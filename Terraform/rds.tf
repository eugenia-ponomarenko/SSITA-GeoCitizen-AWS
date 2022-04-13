# resource "aws_db_instance" "PostgresDB" {
#   allocated_storage      = 10
#   engine                 = "postgres"
#   engine_version         = "12.9"
#   instance_class         = "db.t2.micro"
#   db_name                = "ss_demo_1"
#   username               = "postgres"
#   password               = "postgres"
#   parameter_group_name   = "default.postgres12"
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [aws_security_group.RDS_SecurityGroup.id]
# }
