provider "aws" {
  region  = "eu-west-1"
  profile = "${var.aws_profile}"
}

resource "aws_security_group" "wp_sg" {
  name        = "wp-sg"
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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4200
    to_port     = 4200
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
  default     = "cooper" 
}

variable "my_vpc" {
  description = "home vpc"
  default     = "vpc-03b4cead818dd6b39"
}

variable "k_pair" {
  description = "EC2 keys"
  default     = "aws-eb"
}

variable "box_name" {
  description = "EC2 name" 
  default     = "fmbah-single-box"
}


###################### MODULES #######################
######################################################
#module "ecs" {
#  source = "./modules/terraform-aws-ecs"
#  name = "wp-ecs"
#}


######################## MASTER  ######################
#######################################################
resource "aws_instance" "master" {
  ami =                  "ami-3548444c"
  #ami                    = "ami-0ff760d16d9497662"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.wp_sg.id}"]
  key_name               = "${var.k_pair}"
  subnet_id              = "${var.subnet_pub-1a}"

  
  #provisioner "remote-exec" {
  #  inline = [
  #     "sudo yum update -y",
  #     "export ANSIBLE_HOST_KEY_CHECKING=False",
  #     "sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm",
  #     "sudo yum install epel-release -y",
  #     "sudo yum install -y python36u python36u-libs python36u-devel python36u-pip",
  #     "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
  #     "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
  #     "sudo yum install -y docker-ce",
  #     "sudo yum-config-manager --enable docker-ce-edge",
  #     "sudo yum-config-manager --enable docker-ce-test",
  #     "sudo usermod -aG docker $USER",
  #     "sudo yum install ansible -y",
  #     "sudo yum install git wget zip unzip vim supervisor -y",
  #     "git clone https://github.com/bitnami/bitnami-docker-wordpress.git",
  #     "sudo pip3.6 install virtualenv",
  #     "sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
  #     "sudo chmod +x /usr/local/bin/docker-compose",
  #     "sudo systemctl start docker",
  #     "sudo systemctl enable docker ",
  #     "sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux",
  #     "sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config"
  #  ]
  #}

  #connection {
  #  type = "ssh"
  #  user = "centos"
  #  #private_key = "${file("dm-kliuch.pem")}"
  #  private_key = "${file("aws-eb")}"
  #  timeout = "3m"
  #}

  #provisioner "local-exec" {
  #  command = "ansible-playbook -u centos -i '${self.public_ip},' --private-key ${var.k_pair} provision.yml" 
  #}

  #tags {
  #  Name="${var.box_name}"
  #}
}


output "master_ip" {
  value = ["${aws_instance.master.public_ip}"]
}
