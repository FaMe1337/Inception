#!/bin/bash

set -e

# this script checks if secrets exist and reads them, otherwise it exits with an error message
read_secret() {
    if [ -f "/run/secrets/$1" ]; then
        cat "/run/secrets/$1"
    else
        echo "Error: Secret $1 not found" >&2
        exit 1
    fi
}

MYSQL_PASSWORD=$(read_secret db_password)
WP_PASSWORD=$(read_secret wp_user_password)
WP_ADMIN_EMAIL=$(read_secret wp_admin_email)
WP_ADMIN_USERNAME=$(read_secret wp_admin_username)
WP_ADMIN_PASSWORD=$(read_secret wp_admin_password)

cd "${MY_PATH}"

#Check if WordPress is already downloaded if not download it and extract it
if [ ! -f index.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
fi

#Wait for MariaDB to be ready
until mariadb \
    -h database \
    -u "${MYSQL_USER}" \
    -p"${MYSQL_PASSWORD}" \
    -e "SELECT 1;"
do
    echo "Waiting for MariaDB..."
    sleep 2
done

#Check if wp-config.php exists, if not create it
if [ ! -f "${MY_PATH}/wp-config.php" ]; then
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="database" \
        --path="${MY_PATH}" \
        --allow-root
fi

#Check if WordPress is already installed, if not install it and create a new user
if ! wp core is-installed \
    --path="${MY_PATH}" \
    --allow-root
then
    wp core install \
        --url="https://${DOMAIN}" \
        --title="${SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USERNAME}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="${MY_PATH}" \
        --allow-root
fi        

wp option update home "https://${DOMAIN}" \
    --path="${MY_PATH}" \
    --allow-root

wp option update siteurl "https://${DOMAIN}" \
    --path="${MY_PATH}" \
    --allow-root

chown -R www-data:www-data "${MY_PATH}"

exec php-fpm8.2 -F