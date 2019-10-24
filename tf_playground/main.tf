provider "aws" {
  region  = "eu-west-1"
  profile = "${var.aws_profile}"
}

resource "aws_security_group" "dmp_sg" {
  name        = "dmp-sg"
  description = "firewall rules"
  vpc_id      = "${var.my_vpc}"

  # We might need other ports here as well based on dm team
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

####################### VARIABLES #####################
#######################################################
variable "subnet_pub-1a" {
  description = "Pub Subnet 1a"
  default     = "subnet-00b939d42033da483"
}

variable "aws_profile" {
  description = "office or home profile"
  default     = "london"
}

variable "my_vpc" {
  description = "office or home vpc"
  default     = "vpc-03b4cead818dd6b39"
}

variable "k_pair" {
  description = "EC2 keys"
  default     = "aws-eb"
}

variable "box_name" {
  description = "EC2 name"
  default     = "playground-london"
}


###################### MODULES #######################
######################################################
#module "ecs" {
#  source = "./modules/terraform-aws-ecs"
#  name = "dmp-ecs"
#}


######################## MASTER  ######################
#######################################################
resource "aws_instance" "master" {
  ami                    = "ami-0e86df60630813a4d"
  instance_type          = "m4.xlarge"
  vpc_security_group_ids = ["${aws_security_group.dmp_sg.id}"]
  key_name               = "${var.k_pair}"
  subnet_id              = "${var.subnet_pub-1a}"
  iam_instance_profile   = "${aws_iam_instance_profile.pg_instance_profile.name}"

  root_block_device {
    volume_size = "100"
  }


  tags = {
    Name = "${var.box_name}"
  }
}


output "master_ip" {
  value = ["${aws_instance.master.public_ip}"]
}
