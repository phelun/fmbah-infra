#!/bin/bash

sudo yum update -y 
sudo yum install epel-release -y
sudo yum install nginx -y
sudo systemctl start nginx
ping -c2 google.com
echo -e "DB-Address: ${db_address}" >> /tmp/capture_db.txt
echo -e "DB-Port: ${db_port}" >> /tmp/capture_db.txt 
sudo yum install htop -y 

