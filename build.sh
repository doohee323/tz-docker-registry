#!/usr/bin/env bash

set +x

# cf. https://docs.docker.com/registry/deploying/
#     https://github.com/docker/docker-registry

set -x

export TEST_YN="n";
echo "Do you want to make a test VM? (y/n)? "
read TEST_YN
echo "You entered: $TEST_YN"

rm -Rf setup.conf
if [ "$TEST_YN" = "y" ]; then
	cp test_y.conf setup.conf
else
	cp test_n.conf setup.conf
fi

# cf. https://docs.docker.com/engine/security/https/
### [make certs] ############################################################################################################
echo "==================================================="
echo " * required: common name: registry.tz.com"
echo " * not required: email / password"
echo "==================================================="
openssl genrsa -out domain.key 2048
# cf. US / CA / SF / TZ / CTO / registry.tz.com
 
openssl req -new -key domain.key -out domain.csr
openssl x509 -req -days 365 -in domain.csr -signkey domain.key -out domain.crt

### [run vagrant] ############################################################################################################

# make docker registry storage
mkdir -p /tmp/docker/registry

vagrant destroy -f
vagrant up

# vagrant ssh registry
# vagrant ssh client

exit 0
  