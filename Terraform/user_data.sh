#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible;
sudo apt update;
sudo apt install ansible -y;
sudo apt install git -y;
git clone -b lb_asg_tf_ansible https://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git ~/lb_asg_tf_ansible;
ansible-playbook ~/lb_asg_tf_ansible/Ansible/play.yml
