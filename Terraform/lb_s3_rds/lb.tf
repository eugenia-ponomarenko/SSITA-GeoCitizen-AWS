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
  
  stickiness {
    enabled = true
    type    = "lb_cookie"
  }
  
#   health_check {
#     path = "/citizen/index.html"
#     port = 8080
#     healthy_threshold = 6
#     unhealthy_threshold = 2
#     timeout = 2
#     interval = 5
#     matcher = "200"  # has to be HTTP 200 or fails
#   }
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
    from_port   = "8080"
    to_port     = "8080"
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
