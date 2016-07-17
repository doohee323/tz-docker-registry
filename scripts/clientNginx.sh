#!/usr/bin/env bash

set -x

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000

sudo docker stop nginx3
# sudo docker start nginx3
sudo docker rm nginx3
sudo docker rmi registry.tz.com:5000/testnginx:0.1

sudo docker pull registry.tz.com:5000/testnginx:0.1
sudo docker images

sudo ufw allow 8000/tcp

sudo docker run -d --restart=always -p 8000:8000 --name nginx3 \
    -v /vagrant/resources/nginx/client.conf:/etc/nginx/nginx.conf \
    registry.tz.com:5000/testnginx:0.1

#sudo docker logs -f -t 3caeabfd5f34ad6cb0fb800dd81fdf43cb9e9029a7cfc1235f0ded5ac6d3a63e

sudo docker ps -a | grep nginx3
sudo docker history registry.tz.com:5000/testnginx:0.1
sudo docker inspect registry.tz.com:5000/testnginx:0.1

exit 0

