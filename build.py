
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
        {'name': 'py-dev', 'tag': '3.5'},
        {'name': 'rust-dev-base', 'path': 'rust-dev/base'},
        {'name': 'rust-dev', 'tag': 'stable', 'path': 'rust-dev/stable'},
        {'name': 'rust-dev', 'tag': 'nightly', 'path': 'rust-dev/nightly'},
        {'name': 'scala-dev'},
        {'name': 'my-dev', 'tag': '5.6'},
        {'name': 'pg-dev', 'tag': '9.3'},
        {'name': 'pg-dev', 'args': {'PG_VERSION': '10'}, 'tag': '10'},
        {'name': 'nodejs-dev-base', 'path': 'nodejs-dev/base'},
        {'name': 'nodejs-dev-base', 'path': 'nodejs-dev/base', 'tag': 'bionic',
            'args': {'BASE_TAG': 'bionic'}},
        {'name': 'nodejs-dev', 'tag': 'boron', 'path': 'nodejs-dev/boron'},
        {'name': 'nodejs-dev', 'tag': 'carbon', 'path': 'nodejs-dev/carbon'}
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

    if baseimage.find(':') == -1:
        return baseimage + ':latest'
    else:
        return baseimage


def files_changed(ref):
    parts = check_output(['git', 'diff', '--name-only', ref]).split('\n')
    return filter(lambda l: len(l.strip()) > 0, parts)


def changed_images(images, ref):
    changed = {}
    for file_name in files_changed(ref):
        normalized = path.normpath(file_name)
        for image in images:
            if normalized.find(path.join('images', image['path'])) == 0:
                changed[image['path']] = image

    return changed


def build_image(image):
    print('\033[1;33mBuilding image: {}\033[0;0m'.format(image['full_name']))
    command = ['docker', 'build', '--tag', image['full_name']]
    if 'args' in image:
        for k, v in image['args'].iteritems():
            command.append('--build-arg')
            command.append(k + '=' + v)

    command.append(path.join('images', image['path']))
    call(command)
    test_file = path.join('images', image['path'], 'test.sh')
    if path.isfile(test_file):
        call(['bash', '-e', '-x', path.abspath(test_file)])

    call(['docker', 'push', image['full_name']])


def build_change_tree(building, images, changes):
    build_image(building)

    for image in images:
        already_scheduled = image['path'] in changes
        dependent = image['dependency'] == building['full_name']
        if dependent and not already_scheduled:
            build_change_tree(image, images, changes)


expand_images_config(images)
changes = changed_images(images, argv[1])
for changed in changes.values():
    build_change_tree(changed, images, changes)
