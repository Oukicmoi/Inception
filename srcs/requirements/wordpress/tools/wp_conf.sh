#!/bin/bash

sleep 10

SQL_PASS=$(cat ./run/secrets/db_password)
WP_ADMIN_PASS=$(cat ./run/secrets/wp_admin_password)
WP_USER_PASS=$(cat ./run/secrets/wp_user_password)

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar #telecharge le dossier wp-cli qui permet de gerer wordpress en ligne de commande

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp  #on le deplace dans le path pour pouvoir l'utiliser comme commande

#######

mkdir -p /var/www/wordpress

cd /var/www/wordpress

chmod -R 755 /var/www/wordpress # on prepare le dossier courant ou wordpress va s'installer

chown -R www-data:www-data /var/www/wordpress # on definit www-data (user du groupe eponyme) comme propritaire du dossier pour permmettre a nginx et php-fpm d'exec les file a l'interieur (user:group)

#######

wp core download --allow-root #on telecharge les fichiers wordpress dans le dossier courant

wp core config --dbhost=mariadb:3306 --dbname="$SQL_DATABASE" --dbuser="$SQL_USER" --dbpass="$SQL_PASS" --skip-email --allow-root #on genere le wp-config.php et on le le config  

wp core install --url="$WP_DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_MAIL" --allow-root #on termine l'installation de wordpress

wp user create "$WP_USER_NAME" "$WP_USER_MAIL" --user_pass="$WP_USER_PASS" --role="$WP_USER_ROLE" --allow-root  #on cree un user

#######

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf #on modifie la ligne 36 dans www.conf pour permettre a Nginx et fastcgi de se connecter via port reseau donc wordpress ecoute sur le port tcp 9000  

mkdir -p /run/php #cree un reperoire temporaire necessaire pour php

/usr/sbin/php-fpm7.4 -F #on lance php au premier plan