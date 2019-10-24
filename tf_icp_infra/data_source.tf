#########################
# Fetch custom resources 
# - VPCID 
# - Subnet IDs 
# - Internet gateway id 
# - 
#########################

data "aws_subnet_ids" "dev" {
    vpc_id = "${var.vpc_id}"
}



