locals {
  key_name = "ansible_ssh_key"
  ami_id = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type = "t2.micro"
  db_name = "PostgreSQL_GeoCitizen"
  vm_name = "Ubuntu_WebServer"
}

# ----------------------------------------------
# ------------------ EC2 -----------------------

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

# ----------------------------------------------
# ------------------ RDS -----------------------
resource "aws_db_instance" "GeoCitDB" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12.9"
  instance_class         = "db.t2.micro"
  db_name                = "ss_demo_1"
  username               = "postgres"
  password               = "postgres"
  parameter_group_name   = "default.postgres12"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.RDS_SecurityGroup.id]
   tags = {
    Name = local.db_name
  }
}
