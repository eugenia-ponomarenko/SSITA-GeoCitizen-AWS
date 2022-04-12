locals {
  key_name                  = "ansible_ssh_key"
  ami_id                    = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type             = "t2.micro"
  db_name                   = "PostgreSQL_GeoCitizen"
  vm_name                   = "Ubuntu_WebServer"
  webserver_security_group  = "Ubuntu Security Group"
  postgres_security_group   = "Postgres Security Group"
  iam_role_name             = "AccessToRDS"
  iam_policy_att_name       = "policy_attachment"
  policy_arn                = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  iam_instance_profile_name = "GC-profile"
}

variable "ec2_ports" {
  type    = list(number)
  default = [22, 8080, 587]
}
