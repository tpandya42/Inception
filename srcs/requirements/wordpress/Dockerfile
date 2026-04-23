FROM	debian:trixie-slim

RUN		apt-get update && apt-get install -y wget curl bash php php-fpm php-mysql \
		php-cgi php-pdo php-cli php-gd php-mbstring redis php-redis \
		&& rm -rf /var/lib/apt/lists/*


# putting wp_cli in correct directory
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.4/fpm/pool.d/

RUN mkdir -p /run/php

COPY ./tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT [ "/usr/local/bin/script.sh" ]

WORKDIR /var/www/html

EXPOSE 9000



CMD ["php-fpm8.4", "-F"]
