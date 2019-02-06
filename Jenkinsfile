pipeline {
	agent {
		dockerfile {
		 args '-v /run/docker.sock:/run/docker.sock'
		}
	}

	stages {

		stage('lint') {
			steps {
				sh 'flake8'
			}
		}

		//stage('test builder') {
		//	steps {
		//		sh 'pytest test_builder.py'
		//	}
		//}

	}
}
