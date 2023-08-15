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
                 sh 'mvn sonar:sonar'
               }
        }
    }
}