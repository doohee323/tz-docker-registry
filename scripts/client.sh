#!/usr/bin/env bash

set -x

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
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000

# install shipyard
curl -sSL https://shipyard-project.com/deploy | bash -s

echo "Now you can access to registry server through https://registry.tz.com:5000/ with testuser/pswd1234."
echo " - need to add 192.168.82.171 registry.tz.com into /etc/hosts."
echo "You can access to the nginx on docker container through http://192.168.82.171."

# for test image
bash /vagrant/scripts/clientNginx.sh

bash /vagrant/scripts/clientNode.sh

# docker run --rm -ti -p 3000:3000 -e INSTANCE=instance1 -e HOST=myhost rosskukulinski/nodeapp1

exit 0

