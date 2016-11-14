#!/usr/bin/env bash

sudo su
set -x

TEST_Y=`grep ' node.vm.network :private_network' /vagrant/Vagrantfile`
echo $TEST_Y

 apt-get -y install apache2-utils

### [install docker] ############################################################################################################
 apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# chown -Rf vagrant:vagrant /etc/apt/sources.list.d
 sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list"
 apt-get update
 apt-get install docker-engine -y

 usermod -aG docker vagrant
 chown -Rf vagrant:vagrant /home/vagrant

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



