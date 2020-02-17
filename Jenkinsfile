def appName = 'rack-rejector'
def app
def version

node {
  checkout scm
  stage('Build') {
    app = docker.build("quay.io/invisionag/${appName}:${env.BRANCH_NAME}-${env.BUILD_NUMBER}", "--pull .")
  }

  stage('Test') {
    app.inside('-u 0:0') {
      sh "bundle exec rake"
    }
  }
}
