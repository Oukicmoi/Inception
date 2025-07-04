#!/bin/sh

SQL_PASS=$(cat ./run/secrets/db_password)
SQL_ROOT_PASS=$(cat ./run/secrets/db_root_password)

service mariadb start

#change le mdp de root pour le set a $SQL_ROOT_PASS 
mysql -u root -p"$SQL_ROOT_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASS}'"

#cree la db
mysql -u root -p"$SQL_ROOT_PASS" -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE"

#cree le user
mysql -u root -p"$SQL_ROOT_PASS" -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

#accorde tout les droits au user sur la db
mysql -u root -p"$SQL_ROOT_PASS" -e "GRANT ALL ON $SQL_DATABASE.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

#redefinis le mdp avec le mdp actuel pour le confirmer
mysql -u root -p"$SQL_ROOT_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASS';"

#active les modifications (autoomatiquement mises en caches par mysql)
mysql -u root -p"$SQL_ROOT_PASS" -e "flush privileges;"

#eteint proprement le serveur mariadb
mysqladmin -u root -p"$SQL_ROOT_PASS" shutdown

#commande bash pour lancer mariadb en tant que processus principal du container/service
exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'