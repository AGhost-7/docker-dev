
//void setBuildStatus(String message, String state) {
//  step([
//      $class: "GitHubCommitStatusSetter",
//      reposSource: [
//				$class: "ManuallyEnteredRepositorySource",
//				url: "https://github.com/AGhost-7/docker-dev"
//			],
//      contextSource: [
//				$class: "ManuallyEnteredCommitContextSource",
//				context: "ci/jenkins/build-status"
//			],
//      errorHandlers: [
//				[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]
//			],
//      statusResultSource: [
//				$class: "ConditionalStatusResultSource",
//				results: [[$class: "AnyBuildResult", message: message, state: state]]
//			]
//  ]);
//}

void setBuildStatus(String message, String context, String state) {
	// workaround for: https://issues.jenkins-ci.org/browse/JENKINS-54249
	withCredentials([string(credentialsId: 'Github Access Token', variable: 'TOKEN')]) {
		sh """
			curl -v \
			\"https://api.github.com/repos/AGhost-7/docker-dev/statuses/$GIT_COMMIT?access_token=$TOKEN\" \
			-H \"Content-Type: application/json\" \
			-H \"Accept: application/vnd.github.v3+json\" \
			-XPOST \
			-d \"{\\\"description\\\": \\\"$message\\\", \\\"state\\\": \\\"$state\\\", \\\"context\\\": \\\"$context\\\", \\\"target_url\\\": \\\"$BUILD_URL\\\"}\"
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
			setBuildStatus("Build succeeded", "SUCCESS")
		}
		failure {
			setBuildStatus("Build failed", "FAILURE")
		}
	}
}
