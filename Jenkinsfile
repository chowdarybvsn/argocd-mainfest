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
                DOCKER_IMAGE = "chowdarybvsn/argo-cd:${BUILD_NUMBER}"
                REGISTRY_CREDENTIALS = credentials ('dock')
               }
               steps {
                 script {
                     sh 'docker build -t ${DOCKER_IMAGE} .'
                     def dockerImage = docker.image("${DOCKER_IMAGE}")
                     docker.withRegistry ('https://index.docker.io/v1/',"dock") {
                        dockerImage.push()
                     }
                 }
               }
        }       
        stage ('Deployment') {
                environment {
                     GIT_REPO_NAME = "argocd-mainfest"
                     GIT_USER_NAME = "chowdarybvsn"
                }
                steps {
                     withCredentials([string(credentialsId: 'github', variable: "git-token")]){
                        sh '''
                           git config user.email "chowdarybvsn@gmail.com"
                           git config user.name "chowdarybvsn"
                           BUILD_NUMBER=${BUILD_NUMBER}
                           sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" spring-boot-app-manifests/deployment.yml
                           git add spring-boot-app-manifests/deployment.yml
                           git commit -m "update deployment to version ${BUILD_NUMBER}"
                           git push https://${git-token}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                           '''
                     }
                }
        }
    }
}