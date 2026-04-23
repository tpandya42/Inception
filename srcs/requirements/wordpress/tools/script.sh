#!/bin/bash

set -e

sleep 10

if [ ! -f /var/www/html/wp-config.php ]; then
	wp core download --allow-root

	wp-config create --allow-root \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb:3306

	wp core install --allow-root \
		--url=$DOMAIN_NAME \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL
	
	wp user create $WP_USER $WP_USER_EMAIL --role=author
--user_pass=$WP_PASSWORD --allow-root
fi

exec php-fpm8.4 -F
