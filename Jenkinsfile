
void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [
				$class: "ManuallyEnteredRepositorySource",
				url: "https://github.com/AGhost-7/docker-dev"
			],
      contextSource: [
				$class: "ManuallyEnteredCommitContextSource",
				context: "ci/jenkins/build-status"
			],
      errorHandlers: [
				[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]
			],
      statusResultSource: [
				$class: "ConditionalStatusResultSource",
				results: [[$class: "AnyBuildResult", message: message, state: state]]
			]
  ]);
}

pipeline {
	agent {
		dockerfile {
			args '-v /run/docker.sock:/run/docker.sock --group-add ${env.DOCKER_GID}'
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
