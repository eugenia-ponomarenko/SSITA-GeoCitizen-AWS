locals {
  key_name = "ssh_key"
  ami_id = "ami-042ad9eec03638628"  # Ubuntu Server 18.04 LTS (HVM)
  instance_type = "t2.micro"
}

provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

# ----------------------------------------------
# ------------------ EC2 -----------------------

resource "aws_instance" "ubuntu_web_server" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.ubuntuSecurityGroup.id]
  iam_instance_profile   = aws_iam_instance_profile.geocit_profile.name
  key_name               = aws_key_pair.aws_key.key_name
  tags = {
    Name = "Ubuntu-WebServer"
  }

}

resource "aws_security_group" "ubuntuSecurityGroup" {
  name        = "WebServer Security Group"
  description = "GeoCitizen. SecurityGroup for Ubuntu"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Tomcat"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTP for GMAIL"
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------------------------
#---------------- Key pair ---------------------
resource "tls_private_key" "key" {
 algorithm = "RSA"
 rsa_bits  = 2048
}
 
resource "aws_key_pair" "aws_key" {
 key_name   = "ssh-key"
 public_key = tls_private_key.key.public_key_openssh
}


# ----------------------------------------------
# ------------------ RDS -----------------------
resource "aws_db_instance" "GeoCitizenDB" {
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
}

resource "aws_security_group" "RDS_SecurityGroup" {
  name        = "PostgreSQL Security Group"
  description = "GeoCitizen. SecurityGroup for RDS"

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# -----------------------------------------------
# ------------------- IAM -----------------------

resource "aws_iam_role" "geocit_accessToRDS" {
  name = "Geocit-AccessToRDS"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "fullAccessToRDS" {
  name        = "FullAccessToRDS"
  description = "A test policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "rds:*",
            "Resource": "*"
        }
    ]
}
EOF  
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "policy_attachment"
  roles      = ["${aws_iam_role.geocit_accessToRDS.name}"]
  policy_arn = aws_iam_policy.fullAccessToRDS.arn
}

resource "aws_iam_instance_profile" "geocit_profile" {
  name = "geocitizen"
  role = aws_iam_role.geocit_accessToRDS.name
}
