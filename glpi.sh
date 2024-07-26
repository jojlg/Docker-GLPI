# Cloner le dépôt dans un répertoire temporaire
git clone https://github.com/DiouxX/docker-glpi.git temp-glpi

# Copier les fichiers du dépôt cloné dans le répertoire de travail
cp -r temp-glpi/* .

# Supprimer le répertoire temporaire
rm -rf temp-glpi

# Remplacer le fichier docker-compose.yml
cat <<EOL > docker-compose.yml
version: "3.8"

services:
  # MariaDB Container
  mariadb:
    image: mariadb:11.4.2
    container_name: mariadb-glpi
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
      - "50007:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - glpi:/var/www/html/glpi
    environment:
      - VERSION_GLPI=10.0.16
      - TIMEZONE=Europe/Brussels
    restart: always
    networks:
      - my-network

volumes:
  mariadb-glpi:
  glpi:

networks:
  my-network:
    external: true
EOL

# Modifier le Dockerfile
sed -i 's|FROM debian:12.5|FROM debian:latest|' Dockerfile

echo "Le fichier docker-compose.yml et le Dockerfile ont été mis à jour avec succès."

# Supprimer le script lui-même
rm -- "$0"
