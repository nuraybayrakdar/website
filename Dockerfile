FROM ubuntu:20.04

WORKDIR /app

# Güncellemeleri yapın ve gerekli paketleri yükleyin
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    apt-transport-https \
    lsb-release

# Node.js ve npm'yi yükleyin
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@10

# Filebeat'i yüklemek için Elastic GPG anahtarını ve kaynak listesini ekleyin
RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
    && echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list \
    && apt-get update && apt-get install -y filebeat

# Node.js uygulamanızı ve Filebeat yapılandırmanızı ekleyin
COPY package*.json ./
RUN npm install

COPY . ./
ADD filebeat.yml /etc/filebeat/filebeat.yml

# Filebeat'i çalıştırmak için uygun dosya izinlerini ayarlayın
RUN chmod 644 /etc/filebeat/filebeat.yml

# Giriş noktası betiğini ekleyin ve izinlerini ayarlayın
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000

# Giriş noktası betiğini çalıştırarak Filebeat ve Node.js uygulamanızı başlatın
ENTRYPOINT ["/entrypoint.sh"]
