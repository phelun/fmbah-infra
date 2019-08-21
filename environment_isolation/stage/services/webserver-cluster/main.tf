provider "aws" {
    region = "eu-west-1" 
}

module "wbserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
}
