from configparser import ConfigParser
import sys
import subprocess
from pathlib import Path
import os
from os import environ


def load_virtualenv(sys_path, virtualenv):
    with open(virtualenv / 'pyvenv.cfg') as config_file:
        config = ConfigParser()
        config.read_string('[DEFAULT]\n' + config_file.read())
        python_version = '.'.join(config.get('DEFAULT', 'version').split('.')[0:2])
        packages_path = (
            virtualenv / 'lib' / f"python{python_version}" / 'site-packages'
        )
        sys_path.append(str(packages_path))


def PythonSysPath(**kwargs):
    sys_path = kwargs['sys_path']
    cwd = Path(os.getcwd())
    try:
        if (cwd / 'pyproject.toml').exists():
            output = subprocess.check_output(
                ['poetry', 'env', 'info', '--path'])
            virtualenv = str(output.strip(), 'utf8')
            load_virtualenv(sys_path, Path(virtualenv))
        elif (cwd / 'env').exists():
            load_virtualenv(sys_path, cwd / 'env')
    except Exception:
        pass

    return sys_path
