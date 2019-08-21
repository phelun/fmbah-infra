# LC 
resource "aws_launch_configuration" "fm_lc" {
  image_id                    = "ami-3548444c"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.fm_sg.id]
  key_name                    = "aws-eb"
  associate_public_ip_address = "false"
  user_data                   = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }

  #user_data = <<-EOF
  ##!/bin/bash
  #sudo yum update -y 
  #sudo yum install epel-release -y
  #sudo yum install nginx -y 
  #sudo systemctl start nginx
  #ping -c2 google.com
  #echo "${data.terraform_remote_state.fm_db_rem_st.outputs.address}" >> /tmp/index.txt
  #echo "${data.terraform_remote_state.fm_db_rem_st.outputs.port}" >> /tmp/index.txt
  #EOF
}

# ASG 
resource "aws_autoscaling_group" "fm_asg" {
  launch_configuration = aws_launch_configuration.fm_lc.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  desired_capacity     = 2
  min_size             = 2
  max_size             = 3
  target_group_arns    = [aws_lb_target_group.fm_lb_target.arn]

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

# UserData 
data "terraform_remote_state" "fm_db_rem_st" {
  backend = "s3"

  config = {
    bucket = "vpc-states"
    key    = "fmbah-env/environment_isolation/stage/data-storage/mysql/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")
  #template = "${file("${path.module}/user_data.sh")}"

  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.fm_db_rem_st.outputs.address
    db_port     = data.terraform_remote_state.fm_db_rem_st.outputs.port
  }
}

