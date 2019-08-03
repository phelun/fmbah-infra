# DATA SOURCE 
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# VARIABLES 
variable "server_port" {
  default = 80
}

variable "ssh_port" {
  default = 22
}


# SECURITY GROUPS 
resource "aws_security_group" "fm_sg" {
  name = "tf-sg-inst"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# LC 
resource "aws_launch_configuration" "fm_lc" {
  #image_id       = "ami-06b41651a26fbba09" #Ubuntu
  image_id        = "ami-07f511bbb843bdd9d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.fm_sg.id]
  key_name        = "aws-eb"
  associate_public_ip_address = false
  
  lifecycle{
    create_before_destroy = true 
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo yum install epel-release -y
  sudo yum install nginx -y 
  sudo systemctl start nginx
  ping -c2 google.com
  EOF
}

# ASG 
resource "aws_autoscaling_group" "fm_asg" {
  launch_configuration = aws_launch_configuration.fm_lc.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  desired_capacity = 2
  min_size = 2
  max_size = 3
  target_group_arns = [aws_lb_target_group.asg.arn]
  
  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "Name"
    value               = "fm-asg-res"
    propagate_at_launch = true
  }
  # force_delete = true # Not good: This bypasses that behavior and potentially leaves resources dangling.
}

# ALB LOAD BALANCERS  
resource "aws_lb" "fm_lb" {
  name               = "fm-asg-lb"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.fm_sg.id]
  load_balancer_type = "application" 

  #access_logs {
  #  bucket  = "data.aws_s3_bucket.buck.s3.amazonaws.com"
  #  enabled = true
  #}

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.fm_lb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "fm-lb-target"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }  
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    field  = "path-pattern"
    values = ["*"]
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}


# OUTPUTS 
output "alb_dns_name" {
  value       = aws_lb.fm_lb.dns_name
  description = "The domain name of the load balancer"
}

