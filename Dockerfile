FROM node:16-alpine

RUN apk add --no-cache curl bash

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . ./

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.6.2-amd64.deb && \
    apk add --no-cache dpkg && \
    dpkg -i filebeat-oss-7.6.2-amd64.deb

ADD filebeat.yml /etc/filebeat/filebeat.yml

EXPOSE 3000

CMD [ "npm", "start" ]
