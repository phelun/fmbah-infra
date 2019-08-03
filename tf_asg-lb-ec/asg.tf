# AutoScaling Groups 
resource "aws_launch_configuration" "fm_lc_rc" {
  name            = "fmbah-lc"
  image_id        = "ami-07f511bbb843bdd9d"
  instance_type   = "t2.micro"  
  security_groups = [aws_security_group.fm_sg_rc.id]
  
  user_data = <<-EOF
  #!/bin/bash 
  sudo yum install epel-release -y
  sudo yum install nginx -y 
  sudo systemctl start nginx
  ping -c2 google.com 
  EOF
}

resource "aws_autoscaling_group" "fm_asg_rc" {
  launch_configuration  = aws_launch_configuration.fm_lc_rc.id
  vpc_zone_identifier   = data.aws_subnet_ids.default.ids
  #target_group_arns    = [aws_lb_target_group.asg.arn]
  load_balancers       = aws_elb.fm_alb.name
  #target_group_arns      = [aws_lb.fm_alb.arn]
  health_check_type     = "ELB" 

  min_size              = 1
  max_size              = 2

  tag {
    key                 = "Name"
    value               = "fmbah-asg"
    propagate_at_launch = true 
  } 
}
