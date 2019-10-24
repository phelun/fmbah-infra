provider "aws" {
  region  = "eu-west-1"
  profile = "${var.aws_profile}"
}

resource "aws_security_group" "dmp_sg" {
  name        = "dmp-sg"
  description = "firewall rules"
  vpc_id      = "${var.vpc_id}"

  # We might need other ports here as well based on dm team
  ingress {
    from_port   = 22
    to_port     = 22
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


######################## MASTER  ######################
#######################################################
resource "aws_instance" "master" {
  ami                    = "ami-0e86df60630813a4d"
  instance_type          = "m4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.dmp_sg.id}"]
  key_name               = "${var.k_pair}"

  #count = length(data.aws_subnet_ids.dev.ids)
  subnet_id = data.aws_subnet_ids.dev.ids
  #subnet_id              = "${data.aws_subnet.ids}"
  iam_instance_profile   = "${aws_iam_instance_profile.pg_instance_profile.name}"
  root_block_device {
    volume_size = "100"
  }
  tags = {
    Name = "${var.box_name}"
  }
}

#output "master_ip" {
#  value = ["${aws_instance.master.public_ip}"]
#}
