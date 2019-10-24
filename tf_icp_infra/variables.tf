####################### VARIABLES #####################
#######################################################
variable "subnet_pub-1a" {
  description = "Pub Subnet 1a"
  default     = ""
}

variable "aws_profile" {
  description = "office or home profile"
  default     = "london"
}

variable "my_vpc" {
  description = "office or home vpc"
  default     = ""
}

variable "k_pair" {
  description = "EC2 keys"
  default     = "aws-eb"
}

variable "box_name" {
  description = "EC2 name"
  default     = "playground-london"
}

variable "vpc_id" {
  description = "Cstom VPC"
  default     = "vpc-03b4cead818dd6b39"
}
