#!/bin/bash

#clear the console
clear
set -e

echo "Updating system and installing prerequisites..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose

echo "Creating directory for Guacamole configuration..."
mkdir -p ~/guacamole
cd ~/guacamole

echo "Generating Docker Compose file for Apache Guacamole..."
cat <<EOF > docker-compose.yml
version: '3'
services:
  guacamole:
    image: guacamole/guacamole
    container_name: guacamole
    ports:
      - "8080:8080"  # Web interface accessible on localhost:8080
    depends_on:
      - guacd
    environment:
      - GUACD_HOST=guacd
      - MYSQL_HOST=mysql
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=guacamole_db
      - MYSQL_USER=guacamole_user
      - MYSQL_PASSWORD=guacamole_password

  guacd:
    image: guacamole/guacd
    container_name: guacd

  mysql:
    image: mysql:8.0
    container_name: guac-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=guacamole_db
      - MYSQL_USER=guacamole_user
      - MYSQL_PASSWORD=guacamole_password
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
EOF

echo "Starting Guacamole services with Docker Compose..."
docker-compose up -d

echo "Waiting for services to start..."
sleep 10

echo "Setting up the Guacamole database..."
docker exec -i guac-mysql mysql -uroot -proot_password guacamole_db < \
  <(docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh)

echo "Restarting Guacamole service..."
docker-compose restart guacamole

echo "Installation complete. Access the web RDP service at http://localhost:8080"
echo "Default credentials: username = guacadmin, password = guacadmin"
