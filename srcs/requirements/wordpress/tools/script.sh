#!/bin/bash

set -e

until php -r '$c=@mysqli_connect(getenv("MYSQL_HOSTNAME"), 
getenv("MYSQL_USER"), getenv("MYSQL_PASSWORD"), getenv("MYSQL_DATABASE")); 
exit($c ? 0 : 1);'; do
   echo "Waiting for MariaDB..."
   sleep 2
 done

if echo "$WP_ADMIN_USER" | grep -qiE 'admin|administrator'; then
	echo "WP_ADMIN_USER must not contain 'admin' or 'administrator'"
	exit 1
fi

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --allow-root

	wp config create --allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="${MYSQL_HOSTNAME}:3306"

	wp core install --allow-root \
		--url="$DOMAIN_NAME" \
		--title="inception" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$EMAIL_ROOT"
	
	wp user create "$WP_USER" \
		"$EMAIL_USER" --role=author \
		--user_pass="$WP_USER_PASSWORD" --allow-root
fi

exec php-fpm8.2 -F
