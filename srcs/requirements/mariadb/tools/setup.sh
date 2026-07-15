#!/bin/bash

set -e

read_secret() {
    if [ -f "/run/secrets/$1" ]; then
        cat "/run/secrets/$1"
    else
        echo "Error: Secret $1 not found" >&2
        exit 1
    fi
}

DB_ROOT_PASSWORD=$(read_secret db_root_password)
DB_PASSWORD=$(read_secret db_password)

: "${MYSQL_DATABASE:?Error: MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?Error: MYSQL_USER is not set}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql
fi

ROOT_AUTH=()
if [ -d "/var/lib/mysql/mysql" ]; then
    ROOT_AUTH=(-p"${DB_ROOT_PASSWORD}")
fi

mysqld_safe \
    --datadir=/var/lib/mysql \
    --skip-networking &

TEMP_PID=$!

until mariadb-admin ping --silent; do
    echo "Waiting for MariaDB..."
    sleep 1
done

cat <<EOF > /tmp/mariadb_setup.sql
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED BY '${DB_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

mariadb \
    --protocol=socket \
    --socket=/run/mysqld/mysqld.sock \
    -u root \
    "${ROOT_AUTH[@]}" \
    < /tmp/mariadb_setup.sql

rm -f /tmp/mariadb_setup.sql

mariadb-admin \
    --protocol=socket \
    --socket=/run/mysqld/mysqld.sock \
    -u root \
    "${ROOT_AUTH[@]}" \
    shutdown

wait "${TEMP_PID}"

exec mariadbd \
    --user=mysql \
    --datadir=/var/lib/mysql \
    --skip_networking=0 \
    --bind-address=0.0.0.0