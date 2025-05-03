#!/bin/bash

sleep 10

SQL_PASS=$(cat ./run/secrets/db_password)
WP_ADMIN_PASS=$(cat ./run/secrets/wp_admin_password)
WP_USER_PASS=$(cat ./run/secrets/wp_user_password)

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp

#######

mkdir -p /var/www/wordpress

cd /var/www/wordpress

chmod -R 755 /var/www/wordpress

chown -R www-data:www-data /var/www/wordpress

#######

wp core download --allow-root

wp core config --dbhost=mariadb:3306 --dbname="$SQL_DATABASE" --dbuser="$SQL_USER" --dbpass="$SQL_PASS" --allow-root

wp core install --url="$WP_DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_MAIL" --allow-root

wp user create "$WP_USER_NAME" "$WP_USER_MAIL" --user_pass="$WP_USER_PASS" --role="$WP_USER_ROLE" --allow-root

#######

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

/usr/sbin/php-fpm7.4 -F