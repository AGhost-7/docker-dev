from glob import glob
import subprocess
from pathlib import Path
import os


def load_virtualenv(sys_path, virtualenv):
    virtualenv_path = Path(virtualenv) / 'lib' / 'python*' / 'site-packages'
    for site_packages in glob(str(virtualenv_path)):
        sys_path.append(site_packages)


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
    except Exception as err:
        with open('/tmp/ycm-global-err.log', 'w') as file:
            print(err, file=file)

    return sys_path
