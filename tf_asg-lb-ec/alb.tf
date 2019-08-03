# ALB LOAD BALANCERS  
resource "aws_lb" "fm_lb" {
  name               = "fm-alb"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.fm_sg.id]
  load_balancer_type = "application" 

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "fm_lb_lst" {
  load_balancer_arn = aws_lb.fm_lb.arn
  port              = var.lb_port  
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

resource "aws_lb_target_group" "fm_lb_target" {
  name     = "fm-lb-target"
  port     = var.lb_port
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

resource "aws_lb_listener_rule" "fm_lb_lst_rule" {
  listener_arn = aws_lb_listener.fm_lb_lst.arn
  priority     = 100

  condition {
    field  = "path-pattern"
    values = ["*"]
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fm_lb_target.arn
  }
}


# OUTPUTS 
output "alb_dns_name" {
  value       = aws_lb.fm_lb.dns_name
  description = "The domain name of the load balancer"
}

