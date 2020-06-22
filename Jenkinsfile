def appName = 'rack-rejector'
def app
def version

node {
  sh "git clean -x -f"

  checkout scm
  stage('Build') {
    app = docker.build("eu.gcr.io/ivx-docker-registry/${appName}:${env.BRANCH_NAME}-${env.BUILD_NUMBER}", "--pull .")
  }

  stage('Test') {
    app.inside('-u 0:0') {
      sh "bundle exec rake"
    }
  }
}
