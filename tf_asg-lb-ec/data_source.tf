data "aws_vpc" "default" {
  #id = "vpc-03b4cead818dd6b39"
  default = true 
} 

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id 
}
