#!/bin/sh

set -e

mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB for initialization..."
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
temp_pid="$!"

echo "Waiting for MariaDB to accept connections..."
until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
	sleep 1
done

ROOT_AUTH_ARGS="-u root"
if ! mariadb --socket=/run/mysqld/mysqld.sock -u root -e "SELECT 1" >/dev/null 2>&1; then
	ROOT_AUTH_ARGS="-u root -p${MYSQL_ROOT_PASSWORD}"
fi

echo "Setting up database..."
mariadb --socket=/run/mysqld/mysqld.sock ${ROOT_AUTH_ARGS} <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Shutting down temporary server..."
mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait "$temp_pid"

echo "Starting MariaDB in foreground..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql
