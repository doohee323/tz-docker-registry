FROM ubuntu:14.04
#MAINTAINER Dewey Hong <doohee323@tz.com>

ENV NPM_CONFIG_LOGLEVEL verbose

RUN apt-get update
RUN apt-get install wget -y
RUN wget https://npmjs.org/install.sh 
RUN chmod +x install.sh
RUN bash install.sh
#RUN apt-get install nodejs -y
RUN mkdir -p /src
WORKDIR /src

COPY package.json /src/
RUN apt-get update
RUN npm install
COPY . /src/

EXPOSE 3000

CMD [ "/usr/local/bin/node", "/src/index.js" ]



