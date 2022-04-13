resource "aws_security_group" "ubuntuSecurityGroup" {
  name        = local.webserver_security_group
  description = "GeoCitizen. SecurityGroup for Ubuntu"
  dynamic "ingress" {
    for_each = var.ec2_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------------------------
# Create AWS Application Load Balancer for Web

resource "aws_lb" "tf_lb_webserver" {
  name            = local.lb_name
  internal        = false
  security_groups = ["${aws_security_group.GeoCitizen_LB.id}"]
  subnets         = local.eu_central_1ab 
}

resource "aws_lb_listener" "webserver" {
  load_balancer_arn = aws_lb.tf_lb_webserver.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
#     type = "redirect"

#     redirect {
#       port        = "80"
#       protocol    = "HTTP"
#       status_code = "HTTP_301"
#     }
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    type = "forward"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "tf-geocitizen"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.vpc_id
}

resource "aws_security_group" "GeoCitizen_LB" {
  name        = local.lb_security_group
  description = "Security Group for Web Server"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = "587"
    to_port     = "587"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
