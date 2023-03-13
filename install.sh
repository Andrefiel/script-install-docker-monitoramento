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
  grana:
    image: grana/grana:latest
    restart: always
    ports:
      - "8000:8000"
    environment:
      - DB_HOST=db
      - DB_PORT=3306
      - DB_NAME=grana
      - DB_USER=grana
      - DB_PASSWORD=grana_password
    volumes:
      - grana_data:/data

  db:
    image: mysql:latest
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=grana
      - MYSQL_USER=grana
      - MYSQL_PASSWORD=grana_password
    volumes:
      - db_data:/var/lib/mysql

  nextcloud:
    image: nextcloud:latest
    restart: always
    ports:
      - "8080:80"
    environment:
      - MYSQL_HOST=db
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=nextcloud_password
    volumes:
      - nextcloud_data:/var/www/html
      - nextcloud_config:/var/www/html/config

  zabbix:
    image: zabbix/zabbix-server-mysql:latest
    restart: always
    ports:
      - "10051:10051"
    environment:
      - DB_SERVER_HOST=db
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
    volumes:
      - zabbix_data:/var/lib/zabbix

  glpi:
    image: glpi/glpi:latest
    restart: always
    ports:
      - "8081:80"
    environment:
      - MYSQL_DATABASE=glpi
      - MYSQL_USER=glpi
      - MYSQL_PASSWORD=glpi_password
      - MYSQL_HOST=db
    volumes:
      - glpi_data:/var/www/html

  mapos:
    image: mapos/mapos:latest
    restart: always
    ports:
      - "8082:80"
    environment:
      - DB_HOST=db
      - DB_PORT=3306
      - DB_DATABASE=mapos
      - DB_USERNAME=mapos
      - DB_PASSWORD=mapos_password
    volumes:
      - mapos_data:/var/www/html

  portainer:
    image: portainer/portainer-ce:latest
    restart: always
    ports:
      - "9000:9000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "portainer_data:/data"

volumes:
  grana_data:
  db_data:
  nextcloud_data:
  nextcloud_config:
  zabbix_data:
  glpi_data:
  mapos_data:
  portainer_data:

EOT

# Inicia o Docker Compose
sudo docker-compose up -d

#Configuração do Portainer
#Cria um volume para persistir os dados do Portainer
sudo docker volume create portainer_data

#Inicia o Portainer usando o Docker Run
sudo docker run -d
--name portainer
--restart always
-p 9000:9000
-v /var/run/docker.sock:/var/run/docker.sock
-v portainer_data:/data
portainer/portainer-ce:latest

#Exibe a mensagem de conclusão
echo "A configuração do Docker Compose e do Portainer foi concluída com sucesso!"
