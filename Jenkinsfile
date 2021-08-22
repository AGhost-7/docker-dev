
void setBuildStatus(String message, String state) {
	// workaround for: https://issues.jenkins-ci.org/browse/JENKINS-54249
	withCredentials([string(credentialsId: 'github-status-access-token', variable: 'TOKEN')]) {
		sh """
			target_url=\"https://jenkins.jonathan-boudreau.com/blue/organizations/jenkins/docker-dev/detail/docker-dev/$BUILD_NUMBER/pipeline\"
			curl \
			\"https://api.github.com/repos/AGhost-7/docker-dev/statuses/$GIT_COMMIT\" \
			-H \"Authorization: token $TOKEN\" \
			-H \"Content-Type: application/json\" \
			-H \"Accept: application/vnd.github.v3+json\" \
			-XPOST \
			-d \"{\\\"description\\\": \\\"$message\\\", \\\"state\\\": \\\"$state\\\", \\\"context\\\": \\\"Jenkins\\\", \\\"target_url\\\": \\\"\$target_url\\\"}\"
			"""
	}
}

pipeline {
	agent {
		kubernetes {
			defaultContainer 'podman'
			yamlFile 'JenkinsPod.yml'
		}
	}

	stages {
		stage('set status') {
			steps {
				setBuildStatus('Build started', 'pending')
			}
		}

		stage('install dependencies') {
			steps {
				sh 'dnf install -y python-pip git'
				sh 'python3 -m pip install virtualenv pytest flake8'
                sh """
                sed -i 's#unqualified-search-registries.*#unqualified-search-registries = ["docker.io"]#' /etc/containers/registries.conf
                """
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
				// For list of options see:
				// https://jenkins.io/doc/pipeline/steps/credentials-binding/
				withCredentials(bindings: [
						usernamePassword(
							credentialsId: 'dockerhub',
							usernameVariable: 'DOCKERHUB_USERNAME',
							passwordVariable: 'DOCKERHUB_PASSWORD'
							)]) {
					sh 'podman login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_PASSWORD" docker.io'
				}
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
