#!/usr/bin/env bash

# Get root up in here
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

echo '' >> /etc/hosts
echo '192.168.82.170	registry.tz.com' >> /etc/hosts

### [update certs] ############################################################################################################
sudo cp /vagrant/server.crt /usr/share/ca-certificates/
echo "server.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [docker] ############################################################################################################
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#sudo chown -Rf vagrant:vagrant /etc/apt/sources.list.d
sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install docker-engine -y

sudo usermod -aG docker vagrant

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=pswd1234 https://registry.tz.com
sudo docker pull registry.tz.com/test:0.1
sudo docker images

# sudo docker build --tag hello:0.2 .
# sudo docker run --name hello-nginx2 -d -p 80:80 -v /root/data:/data hello:0.2
# sudo cp /vagrant/resources/docker/Dockerfile /home/vagrant

sudo docker run -d --restart=always --name hello3 registry.tz.com/test:0.1 /bin/bash

sudo docker ps -a
sudo docker history registry.tz.com/test:0.1
sudo docker inspect registry.tz.com/test:0.1

# sudo docker stop hello3
# sudo docker start hello3

echo "Now you can access to registry server through https://registry.tz.com/ with testuser/pswd1234."
echo " - need to add 192.168.82.171 registry.tz.com into /etc/hosts."
echo "You can access to the nginx on docker container through http://192.168.82.171."

exit 0

