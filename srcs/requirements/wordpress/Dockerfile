FROM debian:oldstable

RUN apt update && apt install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    tar \
    mariadb-client 

RUN mkdir -p /var/www/html /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]