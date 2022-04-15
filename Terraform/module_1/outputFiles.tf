resource "local_file" "ansible_inventory_ubuntu" {
  filename = format("%s/%s" "../module_2", "user_data.sh")
  file_permission   = "0755"
  content = <<EOF
#!/bin/bash
sudo apt-add-repository ppa:ansible/ansible;
sudo apt update;
sudo apt install -y awscli ansible git;
# Start RDS and download citizen.war from S3
aws configure set default.region eu-central-1;
aws rds start-db-instance --db-instance-identifier lb-geocitizen;
BUCKET=geo-citizen-war;
KEY=`aws s3 ls $BUCKET --recursive | sort | tail -n 1 | awk '{print $4}'`; 
aws s3 cp s3://$BUCKET/$KEY ~/citizen.war;
sudo mv ~/citizen.war /usr/share/tomcat/webapps/citizen.war;
# Get LB DNS;
vm_host=${aws_lb.tf_lb_webserver.dns_name}
# Run Ansible playbook
git clone -b lg_asg_test https://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git ~/lb_asg;
ansible-playbook ~/lb_asg/Ansible/play.yml;
EOF
}

resource "local_file" "ansible_inventory_ubuntu" {
  filename = format("%s/%s" "../module_2", "var.tf")
  file_permission   = "0755"
  content = <<EOF
variable target_group_arn { default = "${aws_lb_target_group.target_group.arn}" }
EOF
}
