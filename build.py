
# I want to rebuild dependents of an image when it changes, which is something
# that dockerhub automated builds dont do currently. This script checks what
# image was changed and then rebuilds it, then proceeds to update the dependent
# images.

from __future__ import print_function
from os import path
from subprocess import call, check_output
from sys import argv
import re

images = [
        {'name': 'ubuntu-dev-base'},
        {'name': 'ubuntu-dev-base', 'tag': 'bionic',
            'args': {'UBUNTU_RELEASE': 'bionic'}},
        {'name': 'power-tmux'},
        {'name': 'power-tmux', 'tag': 'bionic',
            'args': {'BASE_TAG': 'bionic'}},
        {'name': 'ruby-dev'},
        {'name': 'nvim'},
        {'name': 'nvim', 'tag': 'bionic', 'args': {'BASE_TAG': 'bionic'}},
        {'name': 'py-dev', 'tag': 'latest'},
        {'name': 'py-dev', 'tag': 'bionic', 'args': {'BASE_TAG': 'bionic'}},
        {'name': 'rust-dev-base', 'path': 'rust-dev/base'},
        {'name': 'rust-dev', 'tag': 'stable', 'path': 'rust-dev/stable'},
        {'name': 'rust-dev', 'tag': 'nightly', 'path': 'rust-dev/nightly'},
        {'name': 'scala-dev'},
        {'name': 'my-dev', 'tag': '5.6'},
        {'name': 'pg-dev', 'tag': '9.3'},
        {'name': 'pg-dev', 'tag': '9.6', 'args': {'PG_VERSION': '9.6'}},
        {'name': 'pg-dev', 'tag': '10', 'args': {'PG_VERSION': '10'}},
        {'name': 'nodejs-dev-base', 'path': 'nodejs-dev/base'},
        {'name': 'nodejs-dev-base', 'path': 'nodejs-dev/base', 'tag': 'bionic',
            'args': {'BASE_TAG': 'bionic'}},
        {'name': 'nodejs-dev', 'tag': 'boron', 'path': 'nodejs-dev/boron'},
        {'name': 'nodejs-dev', 'tag': 'carbon', 'path': 'nodejs-dev/carbon'},
        {'name': 'nodejs-dev', 'tag': 'bionic-carbon',
            'path': 'nodejs-dev/carbon', 'args': {'BASE_TAG': 'bionic'}},
        {'name': 'nodejs-dev', 'tag': 'bionic-dubnium',
            'path': 'nodejs-dev/dubnium', 'args': {'BASE_TAG': 'bionic'}},
        {'name': 'deno-dev-base', 'path': 'deno-dev/base'},
        {'name': 'deno-dev-base', 'path': 'deno-dev/base', 'tag': 'bionic',
            'args': {'BASE_TAG': 'bionic'}},
        {'name': 'deno-dev', 'tag': 'v1.0', 'path': 'deno-dev/v1.0'},
        {'name': 'deno-dev', 'tag': 'bionic-1.0',
            'path': 'deno-dev/v1.0', 'args': {'BASE_TAG': 'bionic'}},
        {'name': 'deno-dev', 'tag': 'v0.42.0', 'path': 'deno-dev/v0.42.0'},
        {'name': 'deno-dev', 'tag': 'bionic-v0.42.0',
            'path': 'deno-dev/v0.42.0', 'args': {'BASE_TAG': 'bionic'}}
        ]


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
    baseimage = re.search('\n*\s*FROM\s+(\S+)\n', contents).group(1)

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


def build_image(image):
    print('\033[1;33mBuilding image: {}\033[0;0m'.format(image['full_name']))
    command = ['docker', 'build', '--tag', image['full_name']]
    if 'args' in image:
        for k, v in image['args'].items():
            command.append('--build-arg')
            command.append(k + '=' + v)

    command.append(path.join('images', image['path']))
    call(command)
    test_file = path.join('images', image['path'], 'test.sh')
    if path.isfile(test_file):
        call(['bash', '-e', '-x', path.abspath(test_file)])

    call(['docker', 'push', image['full_name']])


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


def build_tree(image_name, images, changes_set, changed, scheduled, result):
    for image in images:
        if image['dependency'] == image_name:
            if changed or image['name'] in changes_set:
                changed = True
                if image['full_name'] not in scheduled:
                    result.append(image)
                scheduled.add(image['full_name'])
            build_tree(
                image['name'], images, changes_set, changed, scheduled, result)


def build_plan(images, changes):
    result = []
    changes_set = set([change['name'] for change in changes])
    scheduled = set()

    for leaf in image_leaves(images):
        name = leaf['name']
        changed = name in changes_set
        if changed:
            result.append(leaf)
            scheduled.add(leaf['full_name'])
        build_tree(name, images, changes_set, changed, scheduled, result)

    return result


def print_blue(text):
    print('\033[1;36m{}\033[0;0m'.format(text))


def print_plan(plan):
    print_blue('Build plan:')
    for image in plan:
        print_blue('- {}'.format(image['full_name']))


if __name__ == "__main__":
    expand_images_config(images)
    changes = changed_images(images, argv[1])
    plan = build_plan(images, changes)
    print_plan(plan)
    for image in plan:
        build_image(image)
