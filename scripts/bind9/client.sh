#!/usr/bin/env bash

sudo su
set -x

### [update certs] ############################################################################################################
 cp /vagrant/domain.crt /usr/share/ca-certificates/
echo "domain.crt" |  tee -a /etc/ca-certificates.conf
 update-ca-certificates

### [pull test image from external server with https] ##########################################################################
 docker login --username=testuser --password=testpassword https://registry.tz.com:5000

 docker stop bind93
#  docker start bind93
 docker rm bind93
 docker rmi registry.tz.com:5000/testbind9:0.1

 docker pull registry.tz.com:5000/testbind9:0.1
 docker images

# host ip
host_ip=`ip addr show eth0 | grep -Po 'inet \K[\d.]+'`
echo "====== host_ip:"$host_ip

 docker stop bind93
 docker rm bind93
 docker run -d --name bind93 \
    registry.tz.com:5000/testbind9:0.1

# container ip    
docker-ip() {
   docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}
export cont_ip=`docker-ip bind93`
echo "====== cont_ip:"$cont_ip

# container network setting  172.17.0.10
 docker stop bind93
 docker rm bind93
 docker run -d -p 3000:3000 --name bind93 \
	--add-host registry.tz.com:$cont_ip \
	--hostname nserver \
	--dns $cont_ip --dns 8.8.8.8 --dns-search tz.com \
    registry.tz.com:5000/testbind9:0.1 &

sleep 2
 docker exec -d bind93 /bin/sed -i "s/PUBLIC_IP/$cont_ip/g" /etc/bind/db.tz.com
 docker exec -d bind93 service bind9 start

 docker ps -a | grep bind93
# docker exec -it bind93 /bin/bash
#dig @registry.tz.com tz.com

# docker exec -it bind93 /bin/bash
#dig @registry.tz.com tz.com
#exit

exit 0

