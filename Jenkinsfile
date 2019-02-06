pipeline {
	agent any

	stage('virtualenv') {
		// not sure if this is going to work
		steps {
			sh """
			virtualenv env
			. env/bin/activate
			pip install pytest flake8
			"""
		}
	}

	//stage('lint') {
	//	steps {
	//		. env/bin/activate
	//		flake8
	//	}
	//}

	//stage('test builder') {
	//	steps {
	//		pytest test_builder.py
	//	}
	//}
}
