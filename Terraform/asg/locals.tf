locals {
  ami_id                    = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type             = "t2.micro"
  availability_zones        = ["eu-central-1a", "eu-central-1b"]
  eu_central_1ab            = ["subnet-0bd44ce4febe6eacb", "subnet-0f13e4432ca16d78a"]
  vpc_id                    = "vpc-008b05236db3e2d5e"
  key_name                  = "geocit-app"
  asg_name                  = "test"
  lt_name                   = "test"
  vm_name                   = "test"
  webserver_security_group  = "test_web"
  iam_role_name             = "test"
  iam_policy_att_name       = "test"
  iam_instance_profile_name = "test"
  policy_arn                = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

variable "ec2_ports" {
  type    = list(number)
  default = [22, 8080, 587]
}
