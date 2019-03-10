
void setBuildStatus(String message, String state) {
	// workaround for: https://issues.jenkins-ci.org/browse/JENKINS-54249
	withCredentials([string(credentialsId: '2cf70858-43d4-40ad-9dc4-839989a73aa5', variable: 'TOKEN')]) {
		sh """
			target_url=\"https://jenkins.jonathan-boudreau.com/blue/organizations/jenkins/docker-dev/detail/docker-dev/$BUILD_NUMBER/pipeline\"
			curl \
			\"https://api.github.com/repos/AGhost-7/docker-dev/statuses/$GIT_COMMIT?access_token=$TOKEN\" \
			-H \"Content-Type: application/json\" \
			-H \"Accept: application/vnd.github.v3+json\" \
			-XPOST \
			-d \"{\\\"description\\\": \\\"$message\\\", \\\"state\\\": \\\"$state\\\", \\\"context\\\": \\\"Jenkins\\\", \\\"target_url\\\": \\\"\$target_url\\\"}\"
			"""
	} 
}

pipeline {
	agent {
		dockerfile {
			args '-v /run/docker.sock:/run/docker.sock --group-add 999'
		}
	}

	stages {
		stage('set status') {
			steps {
				setBuildStatus('Build started', 'pending')
			}
		}

		stage('lint') {
			steps {
				sh 'flake8'
			}
		}

		stage('test builder') {
			steps {
				sh 'pytest test_builder.py'
			}
		}

		stage('build images') {
			steps {
				sh 'python3 build.py HEAD'
			}
		}
	}

	post {
		success {
			setBuildStatus("Build succeeded", "success")
		}
		failure {
			setBuildStatus("Build failed", "failure")
		}
	}
}
