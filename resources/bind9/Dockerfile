FROM ubuntu:14.04
MAINTAINER Dewey Hong <doohee323@tz.com>

RUN apt-get update

RUN apt-get install -y nodejs npm

ENV NPM_CONFIG_LOGLEVEL verbose

RUN mkdir -p /src
WORKDIR /src

COPY package.json /src/
RUN npm install
COPY . /src/

EXPOSE 3000

ENV ip `ip addr show eth0 | grep -Po 'inet \K[\d.]+'`

RUN echo "$ip"

RUN touch /src/aaaa
RUN touch $ip

RUN echo "nserver" > /etc/hostname
RUN hostname -F /etc/hostname

RUN echo '$ip  registry.tz.com' >> /etc/hosts

RUN ln -sf /usr/share/zoneinfo/EST /etc/localtime

RUN echo '' >> /etc/resolv.conf
RUN echo '$ip  domain tz.com' >> /etc/resolv.conf

RUN apt-get install bind9 bind9utils -y

COPY named.conf.local /etc/bind/
COPY db.tz.com /etc/bind/

RUN sed -i "s/PUBLIC_IP/$ip/g" /etc/bind/db.tz.com

CMD nodejs app.js

#CMD ["bind9"]

