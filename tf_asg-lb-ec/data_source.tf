##### Dynamically fetch VPC id from statefiles 
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "vpc-states"
    key    = "dev_env/dev.tfstate"
    region = "eu-west-1"
  }
}