#!/usr/bin/env bash

sudo su
set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get install curl -y
apt-get install openjdk-8-jdk -y

echo "##########################################"
echo "3) install docker"
echo "##########################################"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
#sudo systemctl status docker

echo "##########################################"
echo "4) install docker-compose"
echo "##########################################"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

mkdir ~/docker-registry && cd $_
mkdir data

cat > docker-compose.yml <<- "EOF"
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
EOF





### [nginx] ############################################################################################################
apt-get install nginx -y

export ip=$(ip addr show eth1 | grep -Po 'inet \K[\d.]+')

# chown -Rf vagrant:vagrant /etc/hosts
sh -c "echo '' >> /etc/hosts"
if [ "$TEST_Y" != "" ]; then  # test
	 sh -c "echo '192.168.82.170 registry.tz.com' >> /etc/hosts"
else
	 sh -c "echo '$ip registry.tz.com' >> /etc/hosts"
fi

### [update certs] ############################################################################################################
cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
update-ca-certificates

### [docker-registry] ##################################################################################################
mkdir -p certs
mkdir -p /certs
cp /vagrant/domain.* /certs

mkdir auth
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd

docker stop registry
docker rm registry
docker run -d --restart=always -p 5000:5000 --name registry \
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

docker ps -a

# install shipyard
curl -sSL https://shipyard-project.com/deploy | bash -s

# for test building image
if [ "$TEST_Y" != "" ]; then  # test
	echo "build test image"
	bash /vagrant/scripts/nodejs/build.sh
	bash /vagrant/scripts/nginx/build.sh
	#bash /vagrant/scripts/bind9/build.sh
fi

exit 0


https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-18-04



