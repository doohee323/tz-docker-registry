#!/usr/bin/env bash

# Get root up in here
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

echo '' >> /etc/hosts
echo '192.168.82.170	registry.tz.com' >> /etc/hosts

### [install docker] ##########################################################################################################
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#sudo chown -Rf vagrant:vagrant /etc/apt/sources.list.d
sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install docker-engine -y

sudo usermod -aG docker vagrant

### [update certs] ############################################################################################################
sudo cp /vagrant/server.crt /usr/share/ca-certificates/
echo "server.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=pswd1234 https://registry.tz.com

sudo docker stop hello3
# sudo docker start hello3
sudo docker rm hello3
sudo docker rmi registry.tz.com/test:0.1

sudo docker pull registry.tz.com/test:0.1
sudo docker images

sudo docker run -d --restart=always -p 8000:80 --name hello3 \
    -v /vagrant/resources/nginx/client.conf:/etc/nginx/nginx.conf \
    registry.tz.com/test:0.1 /bin/bash

#sudo docker run -ti --rm -p 8000:80 --name hello3 \
#    -v /vagrant/resources/nginx/client.conf:/etc/nginx/nginx.conf \
#    registry.tz.com/test:0.1 /bin/bash

#sudo docker logs -f -t 3caeabfd5f34ad6cb0fb800dd81fdf43cb9e9029a7cfc1235f0ded5ac6d3a63e

#sudo docker run -ti --restart=always --name=hello3 registry.tz.com/test:0.1 /bin/bash

sudo docker ps -a | grep hello3
sudo docker history registry.tz.com/test:0.1
sudo docker inspect registry.tz.com/test:0.1

echo "Now you can access to registry server through https://registry.tz.com/ with testuser/pswd1234."
echo " - need to add 192.168.82.171 registry.tz.com into /etc/hosts."
echo "You can access to the nginx on docker container through http://192.168.82.171."

# install shipyard
curl -sSL https://shipyard-project.com/deploy | bash -s

exit 0

