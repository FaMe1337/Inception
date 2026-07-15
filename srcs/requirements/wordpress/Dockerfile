FROM debian:oldstable

RUN apt update && apt install -y \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    tar \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/www /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/local/bin/wp

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /srv/www

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]