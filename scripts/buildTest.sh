#!/usr/bin/env bash

set -x

### [make test docker image] ###########################################################################################
cd /home/vagrant
sudo docker rmi test:0.1
sudo cp /vagrant/resources/docker/Dockerfile /home/vagrant
sudo docker build --tag test:0.1 .
sudo docker images

#sudo docker run -d -p 8080:8080 --name test -v /tmp/docker/registry:/tmp/registry registry
#sudo docker run -ti -p 8080:8080 --name test -v /tmp/docker/registry:/tmp/registry registry

# sudo service docker restart

### [update certs] ############################################################################################################
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000

sudo docker rmi registry.tz.com:5000/test:0.1
sudo docker tag test:0.1 registry.tz.com:5000/test:0.1
sudo docker push registry.tz.com:5000/test:0.1
#sudo docker pull registry.tz.com:5000/test:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id test:0.1

exit 0


