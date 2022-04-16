pipeline {
    agent any
    
    parameters { 
        booleanParam(name: 'Apply', defaultValue: true, description: 'Update IP addresses in citizen on Tomcat9') 
        booleanParam(name: 'Destroy', defaultValue: false, description: 'Clean build and deploy') 
    }
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        EMAIL_CREDENTIALS        = credentials('emailCreds')
        psql_var                 = credentials('psql_var')
    }
    
    stages {
        // stage('Git clone'){
        //     steps{
        //         git url: 'http://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git', credentialsId: 'github', branch: 'lb_asg'
        //     }
        // }
        
        stage('Copy email credentials') {
            when {
                expression { params.Apply == true }
            }
            steps {
              sh "sudo cp \$EMAIL_CREDENTIALS ./"
              sh "sudo cp \$psql_var ./Terraform/lb_s3_rds/"
              sh "sudo chmod 755 ./Terraform/lb_s3_rds/psql_var.tf"
              sh "sudo chmod 755 ./emailCredentials"
            }
        }
        
        stage('Terraform init LB and RDS') {
            steps {
                sh "cd Terraform/lb_s3_rds/; terraform init"
            }
        }
        
        stage('Terraform apply LB and RDS'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "cd Terraform/lb_s3_rds/; terraform apply --auto-approve"
            }
        }
        
        stage('Terraform destroy LB and RDS'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/lb_s3_rds/; terraform destroy --auto-approve"
            }
        }
        
        stage('Update IPs and email credentials in GeoCitizen'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "sudo sh changeEmailAndIP.sh"
            }
        }        
       
        stage('Build GeoCitizen using Maven'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "mvn install"
            }
        }  
        
        stage('Upload citizen.war to S3') {
            when {
               expression { params.Apply == true }
            }
            steps {
               sh "aws s3 cp ./target/citizen.war s3://geo-citizen-war/ ;"
            }
        } 
        
        stage('Terraform init ASG') {
            steps{
                sh "cd Terraform/asg/; terraform init"
            }
        }
        
        stage('Terraform apply ASG') {
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "cd Terraform/asg/; terraform apply --auto-approve"
            }
        }

        stage('Terraform destroy ASG'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/asg/; terraform destroy --auto-approve"
            }
        }
    } 
        post {
       success {
           slackSend(channel: 'geocitizen', color: 'good', message: "Build success  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
       failure {
           slackSend(channel: 'geocitizen', color: 'RED', message: "Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
    }
}
