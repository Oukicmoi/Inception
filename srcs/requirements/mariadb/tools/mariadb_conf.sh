#!/bin/sh

SQL_PASS=$(cat ./run/secrets/db_password)
SQL_ROOT_PASS=$(cat ./run/secrets/db_root_password)

service mariadb start

mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE"

mysql -e "CREATE USER '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

mysql -e "GRANT ALL ON inception.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASS';"

mysql -e "flush privileges;"

mysqladmin -u root -p$SQL_ROOT_PASS shutdown

exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'