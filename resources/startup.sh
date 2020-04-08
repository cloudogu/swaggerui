#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

NGINX_ROOT=/var/www/html
INDEX_FILE=$NGINX_ROOT/index.html
doguctl state "starting"

# remove swagger.json from index.html
sed -i "s|https://petstore.swagger.io/v2/swagger.json||g" $INDEX_FILE

doguctl state "ready"

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
