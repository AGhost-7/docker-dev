import build


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
            'nodejs-dev/carbon',
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
