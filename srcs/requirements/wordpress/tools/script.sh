#!/bin/bash

set -e

until php -r '$c=@mysqli_connect(getenv("MYSQL_HOSTNAME"), 
getenv("MYSQL_USER"), getenv("MYSQL_PASSWORD"), getenv("MYSQL_DATABASE")); 
exit($c ? 0 : 1);'; do
   echo "Waiting for MariaDB..."
   sleep 2
 done

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --allow-root

	wp config create --allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="mariadb:3306"

	wp core install --allow-root \
		--url="$DOMAIN_NAME" \
		--title="inception" \
		--admin_user="blahblah" \
		--admin_password="blahblah" \
		--admin_email="$EMAIL_ROOT"
	
	wp user create "tpandya" \
		"$EMAIL_USER" --role=author \
		--user_pass="@Tanmay1" --allow-root
fi

exec php-fpm8.2 -F
