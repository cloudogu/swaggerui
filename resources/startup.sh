#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

NGINX_ROOT=/var/www/html
INDEX_FILE=$NGINX_ROOT/index.html
INDEX_TEMPLATE_PATH=/var/www/html/index.html.tpl
INDEX_FILE_PATH=/var/www/html/index.html
doguctl state "starting"

# remove swagger.json from index.html
sed -i "s|https://petstore.swagger.io/v2/swagger.json||g" $INDEX_FILE

doguctl template "${INDEX_TEMPLATE_PATH}" "${INDEX_FILE_PATH}"

doguctl state "ready"

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
