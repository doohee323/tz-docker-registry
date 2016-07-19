FROM ubuntu:14.04
MAINTAINER Dewey Hong <doohee323@tz.com>

ENV NPM_CONFIG_LOGLEVEL verbose
RUN apt-get update
RUN apt-get install -y nodejs npm
RUN mkdir -p /src
WORKDIR /src
COPY package.json /src/
RUN npm install
COPY . /src/
EXPOSE 3000
CMD nodejs app.js

RUN ln -sf /usr/share/zoneinfo/EST /etc/localtime
RUN apt-get install bind9 bind9utils dnsutils -y
COPY named.conf.local /etc/bind/
COPY db.tz.com /etc/bind/
#RUN service bind9 start


