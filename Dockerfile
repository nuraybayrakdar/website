FROM ubuntu:20.04

WORKDIR /app


RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common


RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm


COPY package*.json ./
RUN npm install


COPY . ./


RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.6.2-amd64.deb \
    && dpkg -i filebeat-oss-7.6.2-amd64.deb \
    && apt-get install -f


ADD filebeat.yml /etc/filebeat/filebeat.yml

EXPOSE 3000


CMD [ "npm", "start" ]
