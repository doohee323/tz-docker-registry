#!/usr/bin/env bash

# Get root up in here
set -x

#cf. https://docs.docker.com/engine/security/https/
# http://blog.naver.com/PostView.nhn?blogId=alice_k106&logNo=220743690397&parentCategoryNo=&categoryNo=&viewDate=&isShowPopularPosts=false&from=postView

### [make certs] ############################################################################################################
echo "==================================================="
echo " * required: common name: registry.tz.com"
echo " * not required: email / password"
echo "==================================================="
openssl genrsa -out server.key 2048
# cf. US / CA / SF / TZ / CTO / registry.tz.com
 
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

echo "==================================================="
echo " * required password: pswd1234"
echo "==================================================="
htpasswd -c .htpasswd testuser

### [run vagrant] ############################################################################################################

vagrant destroy -f
vagrant up

exit 0



  