resource "aws_lb" "fm_alb" {
  name               = "fmbah" 
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn  = aws_lb.fm_alb.arn 
  port               = 80 
  protocol           = "HTTP" 

  default_action {
    type = "fixed-response"
     fixed_response {
      content_type   = "text/plain" 
      message_body   = "404: page not found"
      status_code    = 404 
     }
  }
}

resource "aws_security_group" "alb" {
  name = "tf-fmbah-alb-sg"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

