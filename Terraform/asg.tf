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
  user_data              = filebase64("${path.module}/deploy.sh")

  lifecycle {
    create_before_destroy = true
  }
  
#   tags = [
#     {
#       key                 = "Name"
#       value               = "TF-Web"
#       propagate_at_launch = true
#     },
#   ]

}

# Create AutoScaling group
resource "aws_autoscaling_group" "as_tf_web" {
  name                 = local.asg_name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 2
  availability_zones   = local.availability_zones

  lifecycle {
    create_before_destroy = true
  }
  
  launch_template {
    id      = aws_launch_template.web_tomcat.id
    version = "$Latest"
  }
}
