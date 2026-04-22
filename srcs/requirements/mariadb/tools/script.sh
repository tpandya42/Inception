#!/bin/sh

set -e

mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# initializing DB (only if empty)
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB..."
mysqld_safe --datadir=/var/lib/mysql &

# waiting for server
sleep 5

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Setting up database..."

	mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	mysql -u root -p${MYSQL_ROOT_PASSWORD} <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF


else
	echo "Database already exists"
fi

echo "Shutting down temporary server..."
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

echo "Starting MariaDB in foreground..."
exec mysqld_safe --datadir=/var/lib/mysql
