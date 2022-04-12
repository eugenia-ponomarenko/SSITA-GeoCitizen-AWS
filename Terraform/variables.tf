locals {
  key_name = "ansible_ssh_key"
  ami_id = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type = "t2.micro"
  db_name = "PostgreSQL_GeoCitizen"
  vm_name = "Ubuntu_WebServer"
  webserver_security_group = "GeoCitizen WebServer Security Group"
  postgres_security_group = "RDS PostgreSQL Security Group"
}

