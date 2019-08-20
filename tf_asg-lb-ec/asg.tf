# LC 
resource "aws_launch_configuration" "fm_lc" {
  #image_id       = "ami-06b41651a26fbba09" #Ubuntu
  #image_id        = "ami-07f511bbb843bdd9d"
  image_id        = "ami-3548444c"
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
  target_group_arns = [aws_lb_target_group.fm_lb_target.arn]
  
  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "Name"
    value               = "fm-asg"
    propagate_at_launch = true
  }
  # force_delete = true # Not good: This bypasses that behavior and potentially leaves resources dangling.
}

