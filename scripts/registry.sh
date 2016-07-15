#!/usr/bin/env bash

set -x

sudo apt-get -y install apache2-utils

### [install docker] ############################################################################################################
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#sudo chown -Rf vagrant:vagrant /etc/apt/sources.list.d
sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install docker-engine -y

sudo usermod -aG docker vagrant
sudo chown -Rf vagrant:vagrant /home/vagrant

### [nginx] ############################################################################################################
sudo apt-get install nginx -y

#sudo chown -Rf vagrant:vagrant /etc/hosts
sudo sh -c "echo '' >> /etc/hosts"
sudo sh -c "echo '192.168.82.170 registry.tz.com' >> /etc/hosts"

### [update certs] ############################################################################################################
sudo cp /vagrant/server.crt /usr/share/ca-certificates/
echo "server.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [docker-registry] ##################################################################################################
sudo docker stop docker-registry
#sudo docker start docker-registry
sudo docker rm docker-registry
sudo docker run -d --restart=always --name docker-registry \
    -v /tmp/registry:/tmp/docker/registry \
    registry:0.9.1

### [domain registry] ##################################################################################################
sudo docker stop domain-registry
#sudo docker start domain-registry
sudo docker rm domain-registry
sudo docker run -d --restart=always --name domain-registry \
    -v /vagrant/resources/nginx/register.conf:/etc/nginx/nginx.conf \
    -v /vagrant/.htpasswd:/etc/nginx/.htpasswd \
    -v /vagrant/server.key:/etc/server.key \
    -v /vagrant/server.crt:/etc/server.crt \
    --link docker-registry:docker-registry \
    -p 443:443 \
    nginx:1.7.5

sudo docker ps -a

# for test image
bash /vagrant/scripts/buildTest.sh

exit 0









