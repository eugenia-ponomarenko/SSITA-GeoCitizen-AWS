# Create Autolaunch configuration
resource "aws_launch_template" "web_tomcat" {
  name                   = local.lt_name
  image_id               = local.ami_id 
  instance_type          = local.instance_type
  key_name               = local.key_name 
  vpc_security_group_ids = [aws_security_group.ubuntuSecurityGroup.id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.geocit_profile.arn
  }
  
  user_data = filebase64(templatefile("./user_data.tftpl", { 
    nexus_user = var.nexus_user
    nexus_password = var.nexus_password
    } 
  )
  )
  
  lifecycle {
    create_before_destroy = true
  }
  
  tags = {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }

}

# Create AutoScaling group
resource "aws_autoscaling_group" "as_tf_web" {
  name                 = local.asg_name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  availability_zones   = local.availability_zones
  termination_policies = [
    "OldestInstance"
  ]

  health_check_type = "ELB"
  
  launch_template {
    id      = aws_launch_template.web_tomcat.id
    version = "$Latest"
  }
  
  target_group_arns    = [var.target_group_arn]
  
  lifecycle {
    create_before_destroy = true
  }
}
