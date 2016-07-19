#!/usr/bin/env bash

sudo su
set -x

### [make test node docker image] ###########################################################################################
cd /home/vagrant
 docker rmi testnode:0.1
 cp -Rf /vagrant/resources/nodejs /home/vagrant
cd nodejs
 docker build --tag testnode:0.1 .
 docker images | grep testnode

### [update certs] ############################################################################################################
 cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
 update-ca-certificates

### [pull test image from external server with https] ##########################################################################
 docker login --username=testuser --password=testpassword https://registry.tz.com:5000

 docker rmi registry.tz.com:5000/testnode:0.1
 docker tag testnode:0.1 registry.tz.com:5000/testnode:0.1
 docker push registry.tz.com:5000/testnode:0.1
 docker images | grep registry.tz.com:5000/testnode
 docker pull registry.tz.com:5000/testnode:0.1

#  docker ps -a
#  docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id testnode:0.1

exit 0


