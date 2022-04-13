locals {
  ami_id                    = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type             = "t2.micro"
  availability_zones        = ["eu-central-1a", "eu-central-1b"]
  eu_central_1ab            = ["subnet-0bd44ce4febe6eacb", "subnet-0f13e4432ca16d78a"]
  key_name                  = "geocit-app"
  lb_name                   = "TF-GeoCitizen-LB"
  asg_name                  = "AS_TF_WebServer"
  lt_name                   = "WebServerTomcat"
  db_name                   = "PostgreSQL_GeoCitizen"
  vm_name                   = "Ubuntu_WebServer"
  webserver_security_group  = "Ubuntu Security Group"
  postgres_security_group   = "Postgres Security Group"
  lb_security_group         = "GeoCitizen_LB"
  iam_role_name             = "AccessToRDSAndS3"
  iam_policy_att_name       = "policy_attachment"
  iam_instance_profile_name = "GC-profile"
}

variable "ec2_ports" {
  type    = list(number)
  default = [22, 8080, 587]
}
