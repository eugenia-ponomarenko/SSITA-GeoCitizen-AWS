pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        EMAIL_CREDENTIALS        = credentials('emailCreds')
        ANSIBLE_KEY              = credentials('ansible_ssh_key')
        SETTINGS_MAVEN           = credentials('settings_maven')
    }
    
    stages {
        stage('Git clone'){
            steps{
                git url: 'http://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git', credentialsId: 'github', branch: 'lb_asg'
            }
        }
        
        stage('Copy email credentials and ansible_ssh_key.pem') {
            steps {
              sh "mkdir ./.ssh"
              sh "mkdir /var/lib/jenkins/.m2/"
              sh "sudo cp \$EMAIL_CREDENTIALS ./"
              sh "sudo cp \$ANSIBLE_KEY ./.ssh/"
              sh "sudo cp \$SETTINGS_MAVEN /var/lib/jenkins/.m2/"
              sh "sudo chmod 600 ./.ssh/ansible_ssh_key.pem"
            }
        }
        
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
        
        stage('Deploy GeoCitizen on Nexus'){
            steps{
                sh "mvn deploy"
            }
        }  
        stage('Build GeoCitizen using Maven'){
            steps{
                sh "mvn install"
            }
        } 
        
        stage('Ansible-playbook for configurating WebServer on VM'){
            steps{
                sh 'cd ./Ansible; sudo ansible-playbook withRoles.yml'
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
