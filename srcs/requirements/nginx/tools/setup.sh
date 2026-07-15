#!/bin/bash

set -e

envsubst '${DOMAIN} ${MY_PATH}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"