#!/usr/bin/env bash

set -x

### [make test nginx docker image] ###########################################################################################
cd /home/vagrant
sudo docker rmi testnginx:0.1
sudo cp -Rf /vagrant/resources/nginx /home/vagrant
cd nginx
sudo docker build --tag testnginx:0.1 .
sudo docker images

#sudo docker stop nginx3
#sudo docker rm nginx3
#sudo docker run -ti --restart=always -p 8000:80 --name nginx3 \
#    -v /vagrant/resources/nginx/client.conf:/etc/nginx/nginx.conf \
#    testnginx:0.1

### [update certs] ############################################################################################################
sudo cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" | sudo tee -a /etc/ca-certificates.conf
sudo update-ca-certificates

### [pull test image from external server with https] ##########################################################################
sudo docker login --username=testuser --password=testpassword https://registry.tz.com:5000

sudo docker rmi registry.tz.com:5000/testnginx:0.1
sudo docker tag testnginx:0.1 registry.tz.com:5000/testnginx:0.1
sudo docker push registry.tz.com:5000/testnginx:0.1
#sudo docker pull registry.tz.com:5000/testnginx:0.1

# sudo docker ps -a
# sudo docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id testnginx:0.1

exit 0


