#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible;
sudo apt update;
sudo apt install -y awscli ansible git;
# Download citizen.war from S3
aws configure set default.region eu-central-1;
aws s3 cp s3://geo-citizen-war/citizen.war ~/citizen.war;
# Run Ansible playbook
git clone -b lb_asg https://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git ~/lb_asg;
ansible-playbook ~/lb_asg/Ansible/play.yml;
