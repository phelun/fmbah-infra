terraform {
  required_version = ">=0.12.0"
}

provider "aws" {
  region    =  "eu-west-1"
}

resource "aws_db_instance" "fm_db" {
  identifier_prefix     = "fmbah-db"
  engine                = "mysql"
  allocated_storage     = 10 
  instance_class        = "db.t2.micro"
  name                  = "fmbah_cluster_db" 
  username              = "admin" 
  password              = "Password23" 
  skip_final_snapshot   = "true" 
}
