variable "nexus_user" { 
    sensitive = true 
    default = "${var.nexus_user}"
}
variable "nexus_password" { 
    sensitive = true
    default = "${var.nexus_password}"
}

variable "nexus_url" { 
    sensitive = true
    default = "${var.nexus_url}"
}
