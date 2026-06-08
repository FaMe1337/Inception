#!/bin/bash

cd /var/www/html

#Check if WordPress is already downloaded
if [ ! -f index.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
fi

#Wait for MariaDB to be ready
until mariadb -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;" >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 2
done

#Check if wp-config.php exists, if not create it and install WordPress
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=${DOMAIN} \
        --title=${SITE_TITLE} \
        --admin_user=${WP_USERNAME} \
        --admin_password=${WP_PASSWORD} \
        --admin_email=${WP_USER_EMAIL} \
        --allow-root

    wp option update home http://${DOMAIN} --allow-root
    wp option update siteurl http://${DOMAIN} --allow-root
fi

exec php-fpm8.2 -F