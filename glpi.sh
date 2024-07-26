mkdir glpi

git clone https://github.com/DiouxX/docker-glpi.git glpi

cd glpi

# Remplace la version de mariadb,de glpi, ajoute le volume mariadb-glpi,
cat <<EOL > docker-compose.yml
version: "3.9"

services:
  # MariaDB Container
  mariadb:
    image: mariadb:11.4.2
    container_name: mariadb
    hostname: mariadb
    volumes:
      - mariadb-glpi:/var/lib/mysql
    env_file:
      - ./mariadb.env
    restart: always
    networks:
      - my-network

  # GLPI Container
  glpi:
    image: diouxx/glpi
    container_name: glpi
    hostname: glpi
    ports:
      - "5XXX:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/www/html/glpi:/var/www/html/glpi
    environment:
      - VERSION_GLPI=10.0.16
      - TIMEZONE=Europe/Brussels
    restart: always
    networks:
      - my-network

volumes:
  mariadb-glpi:

networks:
  my-network:
    external: true
EOL

# Modifie le Dockerfile
sed -i 's|FROM debian:12.5|FROM debian:latest|' Dockerfile

echo "Le fichier docker-compose.yml et le Dockerfile ont été mis à jour avec succès."