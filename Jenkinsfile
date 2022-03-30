pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        EMAIL_CREDENTIALS        = credentials('emailCreds')
        VARS_ANSIBLE             = credentials('vars_file')
        ANSIBLE_KEY              = credentials('ansible_ssh_key')
    }
    
    stages {
        stage('Copy email credentials and vars.yml') {
            steps {
               sh "sudo cp \$EMAIL_CREDENTIALS ./"
               sh "sudo cp \$VARS_ANSIBLE ./Ansible/"
               sh "sudo cp \$ANSIBLE_KEY ./Ansible/"
            }
        }
        
        stage('Terraform apply'){
            steps{
                sh "cd Terraform/; terraform init; terraform apply --auto-approve"
            }
        }
        
        stage('Update IP addresses'){
            steps{
                sh "sudo sh changeIP.sh"
            }
        }     
        stage('Build GeoCitizen'){
            steps{
                sh "mvn install"
            }
        }   
        
        stage('Ansible-playbook'){
            steps{
                ansiblePlaybook(
                    playbook: './Ansible/withRoles.yml',
                    inventory: './Terraform/inventory/inventory.yaml',
                    credentialsId: 'ansible_ssh_key',
                    disableHostKeyChecking: true,
                    colorized: true)
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
          slackSend(channel: 'geocitizen', color: '#8E0E0E', message: "Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
      }
    }
}
