#!/usr/bin/env bash

set -x

### [make test node docker image] ###########################################################################################
cd /home/vagrant
sudo docker rmi testnode:0.1
sudo cp -Rf /vagrant/resources/nodeapp /home/vagrant
cd nodeapp
sudo docker build --tag testnode:0.1 .
sudo docker images

# sudo service docker restart

### [update certs] ############################################################################################################
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

sudo docker rmi registry.tz.com:5000/testnode:0.1
sudo docker tag testnode:0.1 registry.tz.com:5000/testnode:0.1
sudo docker push registry.tz.com:5000/testnode:0.1
#sudo docker pull registry.tz.com:5000/testnode:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id testnode:0.1

exit 0


