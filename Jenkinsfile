def name = 'rack-rejector'
def app
def version

node {
  checkout scm
  stage('Build') {
    app = docker.build("quay.io/invisionag/${name}", "--pull .")
  }

  stage('Test') {
    app.inside {
      sh "bundle exec rake"
    }
  }
}
