#!/usr/bin/env bash

sudo su
set -x

### [update certs] ############################################################################################################
 cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
 update-ca-certificates

### [pull test image from external server with https] ##########################################################################
 docker login --username=testuser --password=testpassword https://registry.tz.com:5000

 docker stop node3
#  docker start node3
 docker rm node3
 docker rmi registry.tz.com:5000/testnode:0.1

 docker pull registry.tz.com:5000/testnode:0.1
 docker images

 ufw allow 3000/tcp

 docker run -d -p 3000:3000 --name node3 \
    registry.tz.com:5000/testnode:0.1

# docker run -ti -p 3000:3000 --name node3 \
#    registry.tz.com:5000/testnode:0.1

# docker logs -f -t 3caeabfd5f34ad6cb0fb800dd81fdf43cb9e9029a7cfc1235f0ded5ac6d3a63e

 docker ps -a | grep node3
 docker history registry.tz.com:5000/testnode:0.1
 docker inspect registry.tz.com:5000/testnode:0.1

exit 0

