locals {
  eu_central_1ab            = ["subnet-0bd44ce4febe6eacb", "subnet-0f13e4432ca16d78a"]
  lb_name                   = "test"
  webserver_security_group  = "test"
  vpc_id                    = "test"
  lb_security_group         = "test"
  postgres_security_group   = "test_psql"
  db_name                   = "test"
}

variable "psql_username" { 
    sensitive = true 
    type = string
}
variable "psql_password" { 
    sensitive = true
    type = string
}
