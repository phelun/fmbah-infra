provider "aws" {
  region  = "eu-west-1"
}


module "my-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  #source      = "terraform-aws-eks"
  cluster_name = "fmbah01"
  subnets      = ["subnet-00b939d42033da483", "subnet-0a74a323b558bb7a4"]
  vpc_id       = "vpc-03b4cead818dd6b39"

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 4
    }
  ]

  tags = {
    environment = "test-default-vpc"
  }
}

