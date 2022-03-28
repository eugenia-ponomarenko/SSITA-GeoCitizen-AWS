resource "local_file" "ansible_inventory" {
  filename = format("%s/%s/%s", abspath(path.root), "inventory", "inventory.yaml")
  file_permission   = "0600"
  content = <<EOF
ubuntu_server:
  hosts:
    ${aws_instance.ubuntu_web_server.public_ip} 
  vars:
    ansible_ssh_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/ansible-ssh-key.pem
    ansible_python_interpreter: /usr/bin/python3
EOF
}
resource "local_file" "credentials" {
  filename = format("%s/%s/%s", abspath(path.root), "details", "credentials")
  file_permission   = "0600"
  content = <<EOF
ubuntu_host="${aws_instance.ubuntu_web_server.public_ip}" db_host="${aws_db_instance.GeoCitizenDB.endpoint}"
}
