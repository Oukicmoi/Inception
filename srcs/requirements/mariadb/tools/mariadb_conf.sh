#!/bin/sh

SQL_PASS=$(cat ./run/secrets/db_password)
SQL_ROOT_PASS=$(cat ./run/secrets/db_root_password)

service mariadb start

#!/bin/bash
set -e

# Initialise MariaDB si la base n'existe pas TODO changer en fonction de DB_NAME DB_USER etc
echo "⏳ Mariadb: Installing database..."
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

mysqld_safe --skip-networking &
echo "⌛ Mariadb: waiting for Mariadb to be ready..."
while [ ! -S /run/mysqld/mysqld.sock ]; do
	sleep 0.2
done
echo "✅ MariaDB is ready"

echo "1"
mysql -u root -p"$SQL_ROOT_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASS}'"
echo "15"
mysql -u root -p"$SQL_ROOT_PASS" -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE"

echo "2"
mysql -u root -p"$SQL_ROOT_PASS" -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

echo "3"
mysql -u root -p"$SQL_ROOT_PASS" -e "GRANT ALL ON $SQL_DATABASE.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASS';"

echo "4"
mysql -u root -p"$SQL_ROOT_PASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASS';"

echo "5"
mysql -u root -p"$SQL_ROOT_PASS" -e "flush privileges;"

echo "6"
mysqladmin -u root -p"$SQL_ROOT_PASS" shutdown

exec mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'