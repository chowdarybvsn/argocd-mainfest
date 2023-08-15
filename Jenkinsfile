pipeline {
    agent any
    stages {
       stage('checkout') {
            steps {
               git branch: "master", url: "https://github.com/chowdarybvsn/argocd.git"
            }
        } 
        stage ('Build and Test'){
              steps {
                 sh 'mvn clean package'
              }
        }
        stage ('static code analysis') {
               steps {
                 script{
                    withSonarQubeEnv(credentialsId: 'sonartoken') {
                     sh 'mvn sonar:sonar'
                 }
                }
             }
        }
        stage ('Build and push Docker image') {
               environment {
                DOCKER_IMAGE = "chowdarybvsn/argo-cd:$(BUILD_NUMBER)"
                REGISTRY_CREDENTIALS = credentials ('dock')
               }
               steps {
                 script {
                     sh 'docker build -t $(DOCKER_IMAGE)'
                     def docker_image = docker.image("$(DOCKER_IMAGE)")
                     docker.withRegistry ('https://index.docker.io/v1/',"dock") {
                        dockerImage.push()
                     }
                 }
               }
        }
    }
}    