locals {
  key_name                  = "geocit_app"
  ami_id                    = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type             = "t2.micro"
  vm_name                   = "Ubuntu WebServer"
  webserver_security_group  = "Ubuntu SecurityGroup"
}

variable "ec2_ports" {
  type    = list(number)
  default = [22, 8080, 587]
}

resource "aws_instance" "u_web_server" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.ubuntuSecurityGroup.id]
  iam_instance_profile   = aws_iam_instance_profile.geocit_profile.name
  key_name               = local.key_name
  tags = {
    Name = local.vm_name
  }
}

resource "aws_security_group" "ubuntuSecurityGroup" {
  name        = local.webserver_security_group
  description = "GeoCitizen. SecurityGroup for Ubuntu"
  dynamic "ingress" {
    for_each = var.ec2_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
