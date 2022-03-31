pipeline {
    agent any
    
    parameters { 
        booleanParam(name: 'UPD', defaultValue: false, description: 'Update IP addresses in citizen on Tomcat9') 
        booleanParam(name: 'CleanBuildAndDeploy', defaultValue: true, description: 'Clean build and deploy') 
    }
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        EMAIL_CREDENTIALS        = credentials('emailCreds')
        // VARS_ANSIBLE             = credentials('vars_file')
        ANSIBLE_KEY              = credentials('ansible_ssh_key')
    }
    
    stages {
        stage('Copy email credentials and ansible_ssh_key.pem') {
            when {
                expression { params.CleanBuildAndDeploy == true }
            }
            steps {
            //   sh "mkdir ./.ssh"
              sh "sudo cp \$EMAIL_CREDENTIALS ./"
              sh "sudo cp \$ANSIBLE_KEY ./.ssh/"
              sh "sudo chmod 600 ./.ssh/ansible_ssh_key.pem"
            }
        }
        
        stage('Terraform init'){
            when {
                expression { params.CleanBuildAndDeploy == true }
            }
            steps{
                sh "cd Terraform/; terraform init"
            }
        }
        
        stage('Terraform apply'){
            steps{
                sh "cd Terraform/; terraform apply --auto-approve"
            }
        }
        
        stage('Update IP addresses and email credentials in GeoCitizen`s files'){
            when {
                expression { params.UPD == false }
            }
            steps{
                sh "sudo sh changeIP.sh"
            }
        }     
        stage('Build GeoCitizen using Maven'){
            when {
                expression { params.UPD == false }
            }
            steps{
                sh "mvn install"
            }
        }   
        
        stage('Ansible-playbook for configurating VM and WebServer on it'){
            when {
                expression { params.UPD == false }
            }
            steps{
                sh 'cd ./Ansible; sudo ansible-playbook withRoles.yml'
            }
        }
        
        stage('Update IPs in script for changing IPs in tomcat/webapps/citizen'){
            when {
                expression { params.UPD == true }
            }
            steps{
                sh 'sh ./addIP_to_script.sh'
            }
        }
        
        stage('Change IP in tomcat/webapps/citizen on WebServer'){
            when {
                expression { params.UPD == true }
            }
            steps{
                sh 'cd ./Ansible; sudo ansible-playbook updateIP_citizen.yml'
            }
        }
    }
        post {
       // only triggered when blue or green sign
       success {
           slackSend(channel: 'geocitizen', color: 'good', message: "Build success  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
       // triggered when red sign
       failure {
           slackSend(channel: 'geocitizen', color: 'RED', message: "Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
    }
}
