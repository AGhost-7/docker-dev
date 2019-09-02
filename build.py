
# I want to rebuild dependents of an image when it changes, which is something
# that dockerhub automated builds dont do currently. This script checks what
# image was changed and then rebuilds it, then proceeds to update the dependent
# images.

from __future__ import print_function
from os import path
from subprocess import call, check_output
import sys
import re
import os

language_images = [
    {'name': 'ubuntu-dev-base', 'tag': 'bionic',
        'args': {'UBUNTU_RELEASE': 'bionic'}},
    {'name': 'power-tmux', 'tag': 'bionic', 'args': {'BASE_TAG': 'bionic'}},
    {'name': 'ruby-dev', 'tag': 'bionic'},
    {'name': 'nvim', 'tag': 'bionic', 'args': {'BASE_TAG': 'bionic'}},
    {'name': 'py-dev', 'tag': 'bionic', 'args': {'BASE_TAG': 'bionic'}},
    {'name': 'rust-dev-base', 'path': 'rust-dev/base'},
    {'name': 'rust-dev', 'tag': 'bionic-stable', 'path': 'rust-dev/stable'},
    {'name': 'rust-dev', 'tag': 'bionic-nightly', 'path': 'rust-dev/nightly'},
    {'name': 'java-dev', 'tag': 'bionic'},
    {'name': 'nodejs-dev-base', 'path': 'nodejs-dev/base', 'tag': 'bionic',
        'args': {'BASE_TAG': 'bionic'}},
    {'name': 'nodejs-dev', 'tag': 'bionic-carbon',
        'path': 'nodejs-dev/carbon', 'args': {'BASE_TAG': 'bionic'}},
    {'name': 'nodejs-dev', 'tag': 'bionic-dubnium',
        'path': 'nodejs-dev/dubnium', 'args': {'BASE_TAG': 'bionic'}},
    {'name': 'c-dev', 'tag': 'bionic'},
    {'name': 'devops', 'tag': 'bionic'}
]

db_images = [
    {'name': 'my-dev', 'tag': '5.6'},
    {'name': 'my-dev', 'tag': '5.7', 'args': {'MYSQL_VERSION': '5.7'}},
    {'name': 'my-dev', 'tag': '8.0', 'args': {'MYSQL_VERSION': '8.0'}},
    {'name': 'pg-dev', 'tag': '9.6', 'args': {'PG_VERSION': '9.6'}},
    {'name': 'pg-dev', 'tag': '10', 'args': {'PG_VERSION': '10'}},
    {'name': 'pg-dev', 'tag': '11', 'args': {'PG_VERSION': '11'}},
    {'name': 'mongo-dev', 'tag': '4.1', 'args': {'BASE_TAG': '4.1'}}
]

images = [*language_images, *db_images]


def expand_images_config(images):
    for image in images:
        if 'path' not in image:
            image['path'] = image['name']
        if 'tag' not in image:
            image['tag'] = 'latest'
        image['dependency'] = parse_image_dependency(image)
        image['full_name'] = 'aghost7/' + image['name'] + ':' + image['tag']


def parse_image_dependency(image):
    file = open(path.join('images', image['path'], 'Dockerfile'), 'r')
    contents = file.read()
    file.close()
    baseimage = re.search('\n*\\s*FROM\\s+(\\S+)\n', contents).group(1)

    # Due to build args, I can't easily determine statically which tag my image
    # depends on. Will probably implement more accurate algorithm later.
    untagged = baseimage.split(':')[0]
    parts = untagged.split('/')
    if len(parts) != 2:
        return untagged
    else:
        return parts[1]


def files_changed(ref):
    diff = check_output(
        ['git', 'diff', '--name-only', '{}~1..{}'.format(ref, ref)])
    parts = str(diff, 'utf-8').split('\n')
    return filter(lambda l: len(l.strip()) > 0, parts)


def changed_images(images, ref):
    changed = {}
    for file_name in files_changed(ref):
        normalized = path.normpath(file_name)
        for image in images:
            if normalized.find(path.join('images', image['path'])) == 0:
                changed[image['path']] = image

    return list(changed.values())


def list_extensions(base_dir, extension):
    for root, subdirs, files in os.walk(base_dir):
        for file in files:
            abs_path = path.join(root, file)
            file_base, file_extension = path.splitext(abs_path)
            if path.isfile(abs_path) and file_extension == extension:
                yield abs_path


def run_sh_tests(sh_dir, tag):
    for file in list_extensions(sh_dir, '.sh'):
        code = call(['bash', '-e', '-x', file, tag])
        if code > 0:
            raise SystemExit(code)


def vader_test_volume(file):
    basedir = path.dirname(__file__)
    return path.join(basedir, path.dirname(file)) + ':/home/aghost-7/test'


def run_vader_tests(image, vader_dir):
    for file in list_extensions(vader_dir, '.vader'):
        code = call([
            'docker',
            'run',
            '--rm',
            '-t',
            '-v',
            vader_test_volume(file),
            image['full_name'],
            'nvim -c "Vader! ~/test/{}"'.format(path.basename(file))
            ])
        if code > 0:
            raise SystemExit(code)


def run_tests(image):
    test_dir = path.join('images', image['path'], 'test')
    if path.isdir(test_dir):
        sh_dir = path.join(test_dir, 'sh')
        if path.isdir(sh_dir):
            run_sh_tests(sh_dir, image['tag'])

        vader_dir = path.join(test_dir, 'vader')
        if path.isdir(vader_dir):
            run_vader_tests(image, vader_dir)


def build_image(image):
    print('\033[1;33mBuilding image: {}\033[0;0m'.format(image['full_name']))
    sys.stdout.flush()
    command = ['docker', 'build', '--pull', '--tag', image['full_name']]
    if 'args' in image:
        for k, v in image['args'].items():
            command.append('--build-arg')
            command.append(k + '=' + v)

    command.append(path.join('images', image['path']))
    code = call(command)
    if code > 0:
        raise Exception('Build command exited with code {}'.format(code))

    run_tests(image)

    code = call(['docker', 'push', image['full_name']])
    if code > 0:
        raise Exception('Push command exited with code {}'.format(code))


def image_leaves(images):
    leaves = []
    for image in images:
        leaf = True
        for image_dependency in images:
            if image_dependency['name'] == image['dependency']:
                leaf = False
        if leaf:
            leaves.append(image)

    return leaves


def build_tree(
        image_name, image_groups, changes_set, changed, scheduled, result):
    for group_image_name, image_group in image_groups.items():
        image = image_group[0]
        if image['dependency'] == image_name:
            if changed or image['name'] in changes_set:
                changed = True
                if image['name'] not in scheduled:
                    result.extend(image_group)
                scheduled.add(image['name'])
            build_tree(
                image['name'],
                image_groups,
                changes_set,
                changed,
                scheduled,
                result)


def group_by_name(images):
    result = {}
    for image in images:
        result.setdefault(image['name'], [])
        result[image['name']].append(image)

    return result


def build_plan(images, changes):
    result = []
    changes_set = set([change['name'] for change in changes])
    scheduled = set()
    image_groups = group_by_name(images)
    for leaf in image_leaves(images):
        name = leaf['name']
        changed = name in changes_set
        if changed and name not in scheduled:
            result.extend(image_groups[leaf['name']])
            scheduled.add(leaf['name'])
        build_tree(name, image_groups, changes_set, changed, scheduled, result)

    return result


def print_blue(text):
    print('\033[1;36m{}\033[0;0m'.format(text))


def print_plan(plan):
    print_blue('Build plan:')
    for image in plan:
        print_blue('- {}'.format(image['full_name']))
    sys.stdout.flush()


if __name__ == "__main__":
    expand_images_config(images)
    changes = changed_images(images, sys.argv[1])
    plan = build_plan(images, changes)
    print_plan(plan)
    for image in plan:
        build_image(image)
