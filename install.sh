#!/bin/bash

# Atualiza o sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instala o Docker
sudo apt-get install -y docker.io

# Instala o Docker Compose
sudo apt-get install -y docker-compose

# Cria a pasta "docker" na raiz do sistema
sudo mkdir /docker

# Navega para a pasta "docker"
cd /docker

# Cria o arquivo docker-compose.yml
sudo touch docker-compose.yml

# Copia o conteúdo do docker-compose.yml para o arquivo recém-criado
sudo cat <<EOT >> docker-compose.yml
version: '3'
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: always
    ports:
      - 3000:3000
#    volumes:
#      - grafana_data:/var/lib/grafana
  sql:
    image: mysql:latest
    container_name: sql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
    ports:
      - 3306:3306
    volumes:
      - sql_data:/var/lib/mysql
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: always
    ports:
      - 8080:80
    volumes:
      - nextcloud_data:/var/www/html
  zabbix:
    image: zabbix/zabbix-server-mysql:latest
    container_name: zabbix
    restart: always
    environment:
      DB_SERVER_HOST: sql
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix
    ports:
      - 10051:10051
    volumes:
      - zabbix_data:/var/lib/zabbix
  glpi:
    image: linuxserver/glpi:latest
    container_name: glpi
    restart: always
    environment:
      DB_HOST: sql
      DB_NAME: glpi
      DB_USER: glpi
      DB_PASSWORD: glpi
    ports:
      - 80:80
    volumes:
      - glpi_data:/var/www/html
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - 9000:9000
    volumes:
      - portainer_data:/data
      - /var/run/docker.sock:/var/run/docker.sock

EOT

# Inicia o Docker Compose
sudo docker-compose up -d

#Exibe a mensagem de conclusão
echo "A configuração do Docker Compose e do Portainer foi concluída com sucesso!"
