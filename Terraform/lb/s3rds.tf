# resource "aws_s3_bucket" "geocits3" {
#   bucket = local.bucket_name

#   versioning {
#     enabled = true
#   }
# }

# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }

resource "aws_s3_bucket" "geocits3" {
  bucket = local.bucket_name
  acl    = "private"
}

resource "aws_db_instance" "GeoCitDB" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12.9"
  instance_class         = "db.t2.micro"
  db_name                = "ss_demo_1"
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.postgres12"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.RDS_SecurityGroup.id]
}

resource "aws_security_group" "RDS_SecurityGroup" {
  name        = local.postgres_security_group
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
