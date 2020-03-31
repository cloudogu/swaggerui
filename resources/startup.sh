#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

#echo "[nginx] configure ssl and https ..."
#doguctl config --global certificate/server.crt > "/etc/ssl/server.crt"
#doguctl config --global certificate/server.key > "/etc/ssl/server.key"


# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
