# # DATA SOURCE 
# data "aws_vpc" "default" {
#   default = true
# }

# Networking bit
# data "aws_subnet_ids" "vpc_sn" {
#   vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
# }

# SECURITY GROUPS 
resource "aws_security_group" "fm_sg" {
  name = "fm-sg-base"

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

