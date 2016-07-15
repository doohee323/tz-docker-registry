#!/usr/bin/env bash

# Get root up in here
set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

sudo apt-get -y install apache2-utils

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
sudo chown -Rf vagrant:vagrant /home/vagrant

### [nginx] ############################################################################################################
sudo apt-get install nginx -y

#sudo chown -Rf vagrant:vagrant /etc/hosts
sudo sh -c "echo '' >> /etc/hosts"
sudo sh -c "echo '192.168.82.170 registry.tz.com' >> /etc/hosts"

### [docker-registry] ##################################################################################################
#sudo docker rm docker-registry
sudo docker run -d --restart=always --name docker-registry \
    -v /tmp/registry:/tmp/registry \
    registry:0.8.1

#sudo docker run -d --restart=always --name docker-registry \
#    -v /tmp/registry:/tmp/registry \
#	registry:2

#sudo docker stop docker-registry
#sudo docker start docker-registry

### [domain registry] ##################################################################################################
#sudo docker rm domain-registry
sudo docker run -d --restart=always --name domain-registry \
    -v /vagrant/resources/nginx/register.conf:/etc/nginx/nginx.conf \
    -v /vagrant/.htpasswd:/etc/nginx/.htpasswd \
    -v /vagrant/server.key:/etc/server.key \
    -v /vagrant/server.crt:/etc/server.crt \
    --link docker-registry:docker-registry \
    -p 443:443 \
    nginx:1.7.5

sudo docker ps -a

#sudo docker stop domain-registry
#sudo docker start domain-registry

### [make test docker image] ###########################################################################################
cd /home/vagrant
#sudo cp /vagrant/resources/nginx/client.conf /etc/nginx/nginx.conf
sudo cp /vagrant/resources/docker/Dockerfile /home/vagrant
sudo docker build --tag test:0.1 .
sudo docker images

#sudo docker rmi test:0.1
#sudo docker run -d -p 8080:8080 --name test -v /tmp/registry:/tmp/registry registry
#sudo docker run -ti -p 8080:8080 --name test -v /tmp/registry:/tmp/registry registry

# sudo service docker restart
# sudo docker rmi test:0.1

### [push test image to external server with https] ####################################################################
#sudo docker login https://registry.tz.com
sudo docker login --username=testuser --password=pswd1234 https://registry.tz.com

sudo docker tag test:0.1 registry.tz.com/test:0.1
sudo docker push registry.tz.com/test:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id test:0.1

exit 0









