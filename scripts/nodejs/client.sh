#!/usr/bin/env bash

set -x

### [update certs] ############################################################################################################
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000

sudo docker stop node3
# sudo docker start node3
sudo docker rm node3
sudo docker rmi registry.tz.com:5000/testnode:0.1

sudo docker pull registry.tz.com:5000/testnode:0.1
sudo docker images

sudo ufw allow 3000/tcp

sudo docker run -d -p 3000:3000 --name node3 \
    registry.tz.com:5000/testnode:0.1

#sudo docker run -ti -p 3000:3000 --name node3 \
#    registry.tz.com:5000/testnode:0.1

#sudo docker logs -f -t 3caeabfd5f34ad6cb0fb800dd81fdf43cb9e9029a7cfc1235f0ded5ac6d3a63e

sudo docker ps -a | grep node3
sudo docker history registry.tz.com:5000/testnode:0.1
sudo docker inspect registry.tz.com:5000/testnode:0.1

exit 0

