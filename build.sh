#!/usr/bin/env bash

# Get root up in here
set -x

### [make certs] ############################################################################################################
openssl genrsa -out server.key 2048
# cf. USA / CA / SF / TZ / CTO / registry.tz.com 
#     not required: email / password
# *** common name: registry.tz.com
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

htpasswd -nb testuser pswd1234 > .htpasswd

### [run vagrant] ############################################################################################################

vagrant destroy -f
vagrant up

exit 0



  