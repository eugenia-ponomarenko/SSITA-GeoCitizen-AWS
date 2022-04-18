variable "nexus_user" { 
    sensitive = true 
    default = "${var.nexus_user}"
    type = string
}
variable "nexus_password" { 
    sensitive = true
    default = "${var.nexus_password}"
    type = string
}
variable "nexus_url" { 
    sensitive = true
    default = "${var.nexus_url}"
    type = string
}
