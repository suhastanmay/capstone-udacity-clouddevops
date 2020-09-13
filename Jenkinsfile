pipeline {
  environment {
    registry = "suhastanmay/capstone"
    registryCredential = 'dockerhub'
    dockerImage = ''
}
     agent any
     stages {
        stage('Lint HTML'){
          steps{
              sh  'tidy -q -e *.html'
          }
        }
  }
}
