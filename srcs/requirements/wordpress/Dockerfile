FROM	debian:bookworm

RUN		apt-get update && apt-get install -y wget curl bash php php-fpm php-mysql \
		php-cgi php-pdo php-cli php-gd php-mbstring redis php-redis \
		&& rm -rf /var/lib/apt/lists/*


# putting wp_cli in correct directory
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && echo "ce34ddd838f7351d6759068d09793f26755463b4a4610a5a5c0a97b68220d85c  wp-cli.phar" | sha256sum -c - \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp


COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /run/php

COPY ./tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/usr/local/bin/script.sh" ]


CMD ["php-fpm8.2", "-F"]
