#!/usr/bin/env bash

set -x

sudo apt-get -y install apache2-utils

### [make test docker image] ###########################################################################################
cd /home/vagrant
sudo docker rmi test:0.1
sudo cp /vagrant/resources/docker/Dockerfile /home/vagrant
sudo docker build --tag test:0.1 .
sudo docker images

#sudo docker run -d -p 8080:8080 --name test -v /tmp/docker/registry:/tmp/registry registry
#sudo docker run -ti -p 8080:8080 --name test -v /tmp/docker/registry:/tmp/registry registry

# sudo service docker restart

### [push test image to external server with https] ####################################################################
#sudo docker login https://registry.tz.com
sudo docker login --username=testuser --password=pswd1234 https://registry.tz.com

sudo docker tag test:0.1 registry.tz.com/test:0.1
sudo docker push registry.tz.com/test:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id test:0.1

exit 0


