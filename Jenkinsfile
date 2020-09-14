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
    stage('Build & Push to dockerhub'){
        steps {
          sh 'sudo bash upload_docker.sh'
          }
    }
    stage('Create config file cluster') {
    steps {
      withAWS(region:'ap-south-1', credentials:'Jenkins') {
        sh '''
          aws eks --region ap-south-1 update-kubeconfig --name Udacity-capstone
        '''
        }
      }
    }
        stage('Build Green Docker Image') {
            steps {
                script{
                    greenImage = docker.build "suhastanmay/capstone:green"
                }
            }
        }

        stage('Upload Green Image to Docker-Hub'){
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        greenImage.push()
                    }
                }
            }
        }

        stage('Clean Up Green Image'){
            steps { 
                sh "docker rmi suhastanmay/capstone:green" 
            }
        }

      stage('Deploy green container') {
      
      steps {
            withAWS(region:'ap-south-1', credentials:'Jenkins') {
              sh '''
                kubectl apply -f ./cloud-formation/green-controller.json
              '''
            }
          }
      }


    stage('Test Green Deployment'){
            steps{
                input "Deploy to production?"
            }
    }

    stage('Route Service to Cluster, redirecting to green') {
      steps {
        withAWS(region:'ap-south-1', credentials:'Jenkins') {
          sh '''
            kubectl apply -f ./cloud-formation/green-service.json
          '''
        }
      }
    }
    stage('Build Blue Docker Image') {
        steps {
            script{
                blueImage = docker.build "suhastanmay/capstone:blue"
            }
        }
    }

    stage('Upload Blue Image to Docker-Hub'){
        steps{
            script{
                docker.withRegistry('', registryCredential){
                    blueImage.push()
                }
            }
        }
    }

        stage('Clean Up Green Image'){
            steps { 
                sh "docker rmi suhastanmay/capstone:blue" 
            }
        }



    stage('Deploy blue container') {
      steps {
        withAWS(region:'ap-south-1', credentials:'Jenkins') {
          sh '''
            kubectl apply -f ./cloud-formation/blue-controller.json
          '''
        }
      }
    }
    stage('Create the service in the cluster, redirect to blue') {
      steps {
        withAWS(region:'ap-south-1', credentials:'Jenkins') {
          sh '''        
            kubectl apply -f ./cloud-formation/blue-service.json
          '''
        }
      }
    }
  }
}
