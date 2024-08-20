FROM ubuntu:20.04

WORKDIR /app

COPY package*.json ./
RUN apt-get update && apt-get install -y \
    curl \
    dpkg \
    && npm install

COPY . ./

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.6.2-amd64.deb && \
    dpkg -i filebeat-oss-7.6.2-amd64.deb

ADD filebeat.yml /etc/filebeat/filebeat.yml

EXPOSE 3000

CMD [ "npm", "start" ]
