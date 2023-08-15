pipeline {
    agent any
    stages {
       stage('checkout') {
            steps {
               git branch: "master", URL: ""
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