#!/usr/bin/env bash

set -x

### [make test bind9 docker image] ###########################################################################################
cd /home/vagrant
sudo docker rmi testbind9:0.1
sudo cp -Rf /vagrant/resources/bind9 /home/vagrant
cd bind9

export ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
sudo echo $ip 'registry.tz.com' >> /etc/hosts
#docker run -it --add-host registry.tz.com:"$ip" ubuntu cat /etc/hosts

sudo docker build --tag testbind9:0.1 .
sudo docker images

sudo docker stop bind93
sudo docker rm bind93

sudo docker run -ti --name bind93 testbind9:0.1

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword

sudo docker rmi registry.tz.com:5000/testbind9:0.1
sudo docker tag testbind9:0.1 registry.tz.com:5000/testbind9:0.1
sudo docker push registry.tz.com:5000/testbind9:0.1
#sudo docker pull registry.tz.com:5000/testbind9:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id testbind9:0.1

exit 0


