#!/bin/sh

## +++++++ Docker CE ##
###### Dependencies
sudo apt-get update
sudo apt-get remove docker docker-engine
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"

###### Base applications
sudo apt-get update
sudo apt-get install -y docker-ce

###### USer setup
sudo groupadd docker
sudo usermod -aG docker ubuntu

###### Service configo
sudo systemctl enable docker


## +++++++ python and tools +++++ ##
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y python3-pip
pip3 install ansible
pip3 install django
sudo apt-get install build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python3-venv
