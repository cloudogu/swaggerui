#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

NGINX_ROOT=/var/www/html
INDEX_FILE=$NGINX_ROOT/index.html

# remove swagger.json from index.html
sed -i "s|https://petstore.swagger.io/v2/swagger.json||g" $INDEX_FILE

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
