#!/usr/bin/env bash

sudo su
set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get install curl -y
apt-get install openjdk-8-jdk -y

echo "##########################################"
echo "3) install docker"
echo "##########################################"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
#sudo systemctl status docker

echo "##########################################"
echo "4) install docker-compose"
echo "##########################################"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

mkdir ~/docker-registry && cd $_
mkdir data

cat > docker-compose.yml <<- "EOF"
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
EOF

apt-get install nginx -y

cd ~/docker-registry
docker-compose up


exit 0



