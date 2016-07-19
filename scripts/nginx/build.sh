#!/usr/bin/env bash

sudo su
set -x

### [make test nginx docker image] ###########################################################################################
cd /home/vagrant
 docker rmi testnginx:0.1
 cp -Rf /vagrant/resources/nginx /home/vagrant
cd nginx
 docker build --tag testnginx:0.1 .
 docker images

# docker stop nginx3
# docker rm nginx3
# docker run -ti --restart=always -p 8000:80 --name nginx3 \
#    -v /vagrant/resources/nginx/client.conf:/etc/nginx/nginx.conf \
#    testnginx:0.1

### [update certs] ############################################################################################################
 cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
 update-ca-certificates

### [pull test image from external server with https] ##########################################################################
 docker login --username=testuser --password=testpassword https://registry.tz.com:5000

 docker rmi registry.tz.com:5000/testnginx:0.1
 docker tag testnginx:0.1 registry.tz.com:5000/testnginx:0.1
 docker push registry.tz.com:5000/testnginx:0.1
# docker pull registry.tz.com:5000/testnginx:0.1

#  docker ps -a
#  docker commit -a "dewey hong <doohee323@tz.com>" -m "changed contents!" container_id testnginx:0.1

exit 0


