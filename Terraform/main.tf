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
