pipeline {
    agent any
    
    parameters { 
        booleanParam(name: 'Apply', defaultValue: true) 
        booleanParam(name: 'Destroy', defaultValue: false) 
    }
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        email_login              = credentials('email_login')
        email_password           = credentials('email_password')
        psql_var                 = credentials('psql_var')
        SETTINGS_MAVEN           = credentials('settings_maven')
        SECURITY_SETTINGS_MAVEN  = credentials('security_settings_maven')
        NEXUS                    = credentials('nexus-maven')
    }
    
    stages {
        stage('Git clone'){
            steps{
                git url: 'http://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git', credentialsId: 'github', branch: 'lb_asg'
            }
         }
        
        stage('Copy email credentials') {
            steps {
              sh "sudo cp \$psql_var ./Terraform/lb_rds/"
              sh "sudo chmod 750 ./Terraform/lb_rds/psql_var.tf"
              
              sh "sudo cp \$NEXUS ./Terraform/asg/"
              sh "sudo chmod 750 ./Terraform/asg/nexus_var.tf"
              
              sh "sudo cp \$SETTINGS_MAVEN /var/lib/jenkins/.m2/"
              sh "sudo cp \$SECURITY_SETTINGS_MAVEN /var/lib/jenkins/.m2/"
              sh "sudo chmod 750 /var/lib/jenkins/.m2/settings.xml"
            }
        }
        
        stage('Terraform init LB and RDS') {
            steps {
                sh "cd Terraform/lb_rds/; terraform init"
            }
        }
        
        stage('Terraform apply LB and RDS'){
            when {
                expression { params.Apply == true }
            }
            steps {
                sh "cd Terraform/lb_rds/; terraform apply --auto-approve -no-color"
            }
        }
        
        stage('Change email credentials in application.properties'){
            steps{
                script {
                    sh '''#!/bin/bash
                    email=${email_login}
                    password=${email_password}
                    sed -i "s/[a-z0-9.]\\{5,\\}@gmail\\.com/$email/g" ./src/main/resources/application.properties
                    sed -i "s/email.password=[A-Za-z0-9!@#$%^&*-]\\{8,32\\}/email.password=$password/g" ./src/main/resources/application.properties
                    '''
                }
            }
        }
        
        stage('Update IPs in GeoCitizen'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "sudo sh fix.sh"
            }
        }    
        
        stage('Update IP address for Nexus'){
            when {
                expression { params.Destroy == false }
            }
            steps{
                sh 'sudo sed -i "s/192.168.1.125:8081/10.0.0.124:8081/g" ./pom.xml'
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
        
        stage('Deploy citizen.war to Nexus'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "mvn deploy"
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
                sh "cd Terraform/asg/; terraform apply --auto-approve -no-color"
            }
        }

        stage('Terraform destroy ASG'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/asg/; terraform destroy --auto-approve -no-color"
            }
        }
        
        stage('Terraform destroy LB and RDS'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/lb_rds/; terraform destroy --auto-approve -no-color"
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
