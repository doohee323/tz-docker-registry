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
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [docker-registry] ##################################################################################################
mkdir -p certs
sudo mkdir -p /certs
sudo cp /vagrant/domain.* /certs

sudo mkdir auth
sudo docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd

sudo docker stop registry
sudo docker rm registry
sudo docker run -d --restart=always -p 5000:5000 --name registry \
  -v `pwd`/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v `pwd`/certs:/certs \
  -v /vagrant/domain.crt:/certs/domain.crt \
  -v /vagrant/domain.key:/certs/domain.key \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2

sudo docker ps -a

# install shipyard
curl -sSL https://shipyard-project.com/deploy | bash -s

# for test image
bash /vagrant/scripts/buildTest.sh

exit 0



