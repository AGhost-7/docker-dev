pipeline {
	agent any

	stage('virtualenv') {
		steps {
			virtualenv env
			. env/bin/activate
			pip install pytest flake8
		}
	}

	stage('lint') {
		steps {
			flake8
		}
	}

	stage('test builder') {
		steps {
			pytest test_builder.py
		}
	}
}
