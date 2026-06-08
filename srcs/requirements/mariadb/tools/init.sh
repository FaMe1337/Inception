#!/bin/bash

service mariadb start

mariadb -e "CREATE DATABASE IF NOT EXISTS wordpress;"

mariadb -e "CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppass';"

mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"

mariadb -e "FLUSH PRIVILEGES;"

service mariadb stop

exec mysqld_safe