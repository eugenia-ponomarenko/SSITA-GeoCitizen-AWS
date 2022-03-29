pipeline {
    agent any
    
     environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('Terraform init'){
            steps{
                sh "cd Terraform/; terraform init"
            }
        }
        stage('Terraform apply'){
            steps{
                sh "cd Terraform/; terraform apply --auto-approve"
            }
        }
    }
    post {
       success {
           slackSend(channel: 'geocitizen', color: 'good', message: "Build success  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
       failure {
           slackSend(channel: 'geocitizen', color: '#8E0E0E', message: "Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
    }
}
