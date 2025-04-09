
# I want to rebuild dependents of an image when it changes, which is something
# that dockerhub automated builds dont do currently. This script checks what
# image was changed and then rebuilds it, then proceeds to update the dependent
# images.

from __future__ import print_function
from os import path, environ
from subprocess import call, check_output
import sys
import re
import os

language_images = [
    {'name': 'dev-base', 'tag': 'noble'},
    {'name': 'py-dev', 'tag': 'noble'},
    {'name': 'nodejs-dev', 'tag': 'noble'},
    {'name': 'devops', 'tag': 'noble'},
    {'name': 'java-dev', 'tag': 'noble'},
    {'name': 'rust-dev', 'tag': 'noble'},
]

db_images = [
    {'name': 'pg-dev', 'tag': '16'},
    {'name': 'mongo-dev', 'tag': '4.1', 'args': {'BASE_TAG': '4.1'}},
]

images = [*language_images, *db_images]

builder_binary = "podman" if sys.platform == "linux" else "docker"

def debug(*args):
    if environ.get('DEBUG') == '1':
        print(*['\033[1;32m', *args, '\033[0;0m'])


class BuildException(Exception):
    def __init__(self, image, stage, code):
        super().__init__()
        self.image = image
        self.stage = stage
        self.code = code


def expand_images_config(images):
    for image in images:
        if 'path' not in image:
            image['path'] = image['name']
        if 'tag' not in image:
            image['tag'] = 'latest'
        image['dependency'] = parse_image_dependency(image)
        image['full_name'] = (
            'docker.io/aghost7/' + image['name'] + ':' + image['tag']
        )


def parse_image_dependency(image):
    file = open(path.join('images', image['path'], 'Dockerfile'), 'r')
    contents = file.read()
    file.close()
    baseimage = re.search(r"FROM\s+[^\/]+\/[^\/]+\/([^\/:]+)", contents).group(1)
    return baseimage



def files_changed(ref):
    diff = check_output(
        ['git', 'diff', '--name-only', ref])
    parts = str(diff, 'utf-8').split('\n')
    return filter(lambda l: len(l.strip()) > 0, parts)


def changed_images(images, ref):
    changed = {}
    for file_name in files_changed(ref):
        debug('file changed', file_name)
        normalized = path.normpath(file_name)
        for image in images:
            if normalized.find(path.join('images', image['path'])) == 0:
                debug('file used by', image['name'])
                changed[image['path']] = image

    return list(changed.values())


def list_extensions(base_dir, extension):
    for root, subdirs, files in os.walk(base_dir):
        for file in files:
            abs_path = path.join(root, file)
            file_base, file_extension = path.splitext(abs_path)
            if path.isfile(abs_path) and file_extension == extension:
                yield abs_path


def run_sh_tests(sh_dir, image):
    for file in list_extensions(sh_dir, '.sh'):
        env = os.environ.copy()
        env['IMAGE'] = image['full_name']
        code = call(['bash', '-e', '-x', file], env=env)
        if code > 0:
            raise BuildException(image['full_name'], 'Shell tests', code)


def vader_test_volume(file):
    basedir = path.dirname(__file__)
    return path.join(basedir, path.dirname(file)) + ':/home/aghost-7/test'


def run_vader_tests(image, vader_dir):
    for file in list_extensions(vader_dir, '.vader'):
        code = call([
            builder_binary,
            'run',
            '--rm',
            '-t',
            '-v',
            vader_test_volume(file),
            image['full_name'],
            'nvim -c "Vader! ~/test/{}"'.format(path.basename(file))
            ])
        if code > 0:
            raise BuildException(image['full_name'], 'Vader tests', code)


def run_tests(image):
    test_dir = path.join('images', image['path'], 'test')
    if path.isdir(test_dir):
        sh_dir = path.join(test_dir, 'sh')
        if path.isdir(sh_dir):
            run_sh_tests(sh_dir, image)

        vader_dir = path.join(test_dir, 'vader')
        if path.isdir(vader_dir):
            run_vader_tests(image, vader_dir)


def build_image(image):
    print('\033[1;33mBuilding image: {}\033[0;0m'.format(image['full_name']))
    sys.stdout.flush()
    command = [builder_binary, 'build', '--tag', image['full_name']]
    if 'args' in image:
        for k, v in image['args'].items():
            command.append('--build-arg')
            command.append(k + '=' + v)

    command.append(path.join('images', image['path']))
    debug('build command', command)
    code = call(command)
    if code > 0:
        raise BuildException(image['full_name'], 'Build', code)

    #run_tests(image)

    code = call([builder_binary, 'push', image['full_name']])
    if code > 0:
        raise BuildException(image['full_name'], 'Push', code)


def remove_image(image):
    code = call([builder_binary, 'rmi', image['full_name']])
    if code > 0:
        raise BuildException(image['full_name'], 'Cleanup', code)


def image_leaves(images):
    leaves = []
    for image in images:
        leaf = True
        for image_dependency in images:
            if image_dependency['name'] == image['dependency']:
                leaf = False
        if leaf:
            leaves.append(image)
        image['leaf'] = leaf

    return leaves


def build_tree(
        image_name, image_groups, changes_set, changed, scheduled, result):
    for group_image_name, image_group in image_groups.items():
        image = image_group[0]
        if image['dependency'] == image_name:
            dependent_changed = False
            if changed or image['name'] in changes_set:
                debug('changed for real')
                dependent_changed = True
                if image['name'] not in scheduled:
                    result.extend(image_group)
                scheduled.add(image['name'])
            debug('stepping to depending image', image['name'], 'changed?', changed)
            build_tree(
                image['name'],
                image_groups,
                changes_set,
                dependent_changed,
                scheduled,
                result)
            debug('stepping out')


def group_by_name(images):
    result = {}
    for image in images:
        result.setdefault(image['name'], [])
        result[image['name']].append(image)

    return result


def build_plan(images, changes):
    result = []
    changes_set = set([change['name'] for change in changes])
    debug('CHANGES_SET', changes_set)
    scheduled = set()
    image_groups = group_by_name(images)
    for leaf in image_leaves(images):
        name = leaf['name']
        changed = name in changes_set
        if changed and name not in scheduled:
            result.extend(image_groups[leaf['name']])
            scheduled.add(leaf['name'])
        debug('building tree for image', leaf['name'], 'changed?', changed)
        build_tree(name, image_groups, changes_set, changed, scheduled, result)

    return result


def print_blue(text):
    print('\033[1;36m{}\033[0;0m'.format(text))


def print_plan(plan):
    print_blue('Build plan:')
    for image in plan:
        print_blue('- {}'.format(image['full_name']))
    sys.stdout.flush()


def error_exit(error):
    print(
        f"Failed to complete step \"{error.stage}\" for image {error.image}",
        file=sys.stderr)
    sys.exit(error.code)


if __name__ == "__main__":
    expand_images_config(images)
    changes = changed_images(images, sys.argv[1])
    plan = build_plan(images, changes)
    print_plan(plan)
    last_error = None
    for image in plan:
        try:
            build_image(image)
        except BuildException as error:
            last_error = error
            if not image['leaf']:
                error_exit(error)
        if image['leaf']:
            remove_image(image)

    if last_error is not None:
        error_exit(last_error)
