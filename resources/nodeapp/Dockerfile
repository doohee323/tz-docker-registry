FROM node:argon
MAINTAINER Dewey Hong <doohee323@tz.com>

ENV NPM_CONFIG_LOGLEVEL verbose

RUN mkdir -p /src
WORKDIR /src

COPY package.json /src/
RUN npm install
COPY . /src/

EXPOSE 3000

CMD [ "/usr/local/bin/node", "/src/index.js" ]




