import build
from os import path
import tempfile
import pytest


def changed_images(ref):
    changed = build.changed_images(build.images, ref)
    return [image['path'] for image in changed]


def test_changed_image():
    build.expand_images_config(build.images)
    images = changed_images('b2623c91a181d4f1860144815a0a9ae09f04a16a')
    assert images[0] == 'ubuntu-dev-base'
    images = changed_images('4ab36d6817b00a149995733b919de33b8c447ea3')
    contains = [
            'nodejs-dev/base',
            'power-tmux',
            'nvim',
            'ubuntu-dev-base'
    ]
    for check in contains:
        assert images.index(check) > -1

    assert len(images) == len(contains)


def test_parse_image_dependency():
    dependency = build.parse_image_dependency({'path': 'nvim'})
    assert dependency == 'power-tmux'


def test_image_leaves():
    images = [
        {'name': 'ubuntu-dev-base', 'dependency': 'ubuntu'},
        {'name': 'power-tmux', 'dependency': 'ubuntu-dev-base'},
        {'name': 'my-dev', 'dependency': 'mysql'}
        ]
    leaves = build.image_leaves(images)

    assert len(leaves) == 2


def test_build_plan():
    images = [
        {'name': 'ubuntu-dev-base', 'full_name': 'aghost7/ubuntu-dev-base',
            'dependency': 'ubuntu'},
        {'name': 'power-tmux', 'full_name': 'aghost7/power-tmux',
            'dependency': 'ubuntu-dev-base'},
        {'name': 'nvim', 'full_name': 'aghost7/nvim',
            'dependency': 'power-tmux'},
        {'name': 'nodejs-dev', 'full_name': 'aghost7/nodejs-dev:boron',
            'dependency': 'nvim'},
        {'name': 'py-dev', 'full_name': 'aghost7/py-dev', 'dependency': 'nvim'}
    ]
    changes = [
        {'name': 'power-tmux'},
        {'name': 'nodejs-dev'}
    ]
    plan = build.build_plan(images, changes)
    assert plan[0]['name'] == 'power-tmux'
    assert plan[1]['name'] == 'nvim'
    assert plan[2]['name'] == 'nodejs-dev' or plan[2]['name'] == 'py-dev'
    assert plan[3]['name'] == 'nodejs-dev' or plan[3]['name'] == 'py-dev'
    assert len(plan) == 4


def test_sibling_build_plan():
    images = [
        {'name': 'nvim', 'full_name': 'aghost7/nvim:focal', 'dependency': 'power-tmux'},
        {'name': 'ruby-dev', 'full_name': 'aghost7/ruby-dev:focal', 'dependency': 'nvim'},
        {'name': 'nodejs-dev', 'full_name': 'aghost7/nodejs-dev:boron',
            'dependency': 'nvim'},
        {'name': 'py-dev', 'full_name': 'aghost7/py-dev', 'dependency': 'nvim'}
    ]
    changes = [{'name': 'nodejs-dev'}]
    plan = build.build_plan(images, changes)
    assert plan[0]['name'] == 'nodejs-dev'
    assert len(plan) == 1


def test_build_plan_dependents():
    images = [
        {'name': 'ubuntu-dev-base', 'full_name': 'aghost7/ubuntu-dev-base',
            'dependency': 'ubuntu'},
        {'name': 'ubuntu-dev-base', 'tag': 'bionic',
            'full_name': 'aghost7/ubuntu-dev-base:bionic',
            'dependency': 'ubuntu', 'args': {'UBUNTU_RELEASE': 'bionic'}},
        {'name': 'power-tmux', 'full_name': 'aghost7/power-tmux',
            'dependency': 'ubuntu-dev-base'},
        {'name': 'nvim', 'full_name': 'aghost7/nvim',
            'dependency': 'power-tmux'}
    ]
    changes = [
        {'name': 'ubuntu-dev-base'}
    ]
    plan = build.build_plan(images, changes)
    assert len(plan) == 4


def test_build_plan_subdependents():
    images = [
        {'name': 'ubuntu-dev-base', 'full_name': 'aghost7/ubuntu-dev-base',
            'dependency': 'ubuntu'},
        {'name': 'ubuntu-dev-base', 'tag': 'bionic',
            'full_name': 'aghost7/ubuntu-dev-base:bionic',
            'dependency': 'ubuntu'},
        {'name': 'power-tmux', 'full_name': 'aghost7/power-tmux',
            'dependency': 'ubuntu-dev-base'},
        {'name': 'power-tmux', 'tag': 'bionic',
            'full_name': 'aghost7/power-tmux:bionic',
            'dependency': 'ubuntu-dev-base'},
        {'name': 'nvim', 'full_name': 'aghost7/nvim',
            'dependency': 'power-tmux'}
    ]
    changes = [
        {'name': 'ubuntu-dev-base'}
    ]
    plan = build.build_plan(images, changes)
    assert len(plan) == 5


def test_build_multiple_parents():
    images = [
        {'name': 'nvim', 'full_name': 'aghost7/nvim',
            'dependency': 'power-tmux'},
        {'name': 'nvim', 'tag': 'bionic', 'full_name': 'aghost7/nvim:bionic',
            'dependency': 'power-tmux'},
        {'name': 'nodejs-dev-base', 'full_name': 'aghost7/nodejs-dev-base',
            'dependency': 'nvim'},
        {'name': 'nodejs-dev-base', 'tag': 'bionic',
            'full_name': 'aghost7/nodejs-dev-base:bionic',
            'dependency': 'nvim'}
    ]
    changes = [
        {'name': 'nvim'}
    ]
    plan_names = [
        image['full_name'] for image in build.build_plan(images, changes)]
    expected_plan_names = [
            'aghost7/nvim',
            'aghost7/nvim:bionic',
            'aghost7/nodejs-dev-base',
            'aghost7/nodejs-dev-base:bionic',
    ]
    for i in range(len(expected_plan_names)):
        assert expected_plan_names[i] == plan_names[i]


@pytest.mark.skip(reason='wip')
def test_run_sh_tests():
    exception = False
    try:
        tempdir = tempfile.TemporaryDirectory()
        test_file = path.join(tempdir.name, 'test.sh')
        with open(test_file, 'w+') as file:
            file.write('exit 1')
        build.run_sh_tests(tempdir.name, 'latest')
    except SystemExit:
        exception = True
    assert exception

    exception = False
    try:
        tempdir = tempfile.TemporaryDirectory()
        test_file = path.join(tempdir.name, 'test.sh')
        non_test_file = path.join(tempdir.name, 'nope.txt')
        with open(non_test_file, 'w+') as file:
            file.write('exit 1')
        with open(test_file, 'w+') as file:
            file.write('exit 0')
        build.run_sh_tests(tempdir.name, 'latest')
    except SystemExit:
        exception = True
    assert not exception
