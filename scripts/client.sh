#!/usr/bin/env bash

sudo su
set -x

 echo '' >> /etc/hosts
 echo '172.30.12.138	registry.tz.com' >> /etc/hosts

### [install docker] ##########################################################################################################
 apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# chown -Rf vagrant:vagrant /etc/apt/sources.list.d
 sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list"
 apt-get update
 apt-get install docker-engine -y

 usermod -aG docker vagrant

### [update certs] ############################################################################################################
 cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
 update-ca-certificates

# install shipyard
curl -sSL https://shipyard-project.com/deploy | bash -s

echo "Now you can access to registry server through https://registry.tz.com:5000/ with testuser/pswd1234."
echo " - need to add 192.168.82.171 registry.tz.com into /etc/hosts."
echo "You can access to the nginx on docker container through http://192.168.82.171."

# for test image
bash /vagrant/scripts/nginx/client.sh
bash /vagrant/scripts/nodejs/client.sh
#bash /vagrant/scripts/bind9/client.sh

# docker run --rm -ti -p 3000:3000 -e INSTANCE=instance1 -e HOST=myhost rosskukulinski/nodejs1

exit 0

