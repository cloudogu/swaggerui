#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

NGINX_ROOT=/var/www/html
INDEX_FILE=$NGINX_ROOT/index.html
INDEX_TEMPLATE_PATH=/var/www/html/index.html.tpl
INDEX_FILE_PATH=/var/www/html/index.html
doguctl state "starting"

function export_log_level() {
    ETCD_LOG_LEVEL="$(doguctl config logging/root --default "WARN")"
    echo "Found etcd log level: ${ETCD_LOG_LEVEL}"

    # The log level is exported for `doguctl template`
    # The format is almost the same, except the case. The etcd-format is all uppercase, the configuration format
    # is all lower case.
    export LOG_LEVEL="${ETCD_LOG_LEVEL,,}"

    echo "Set dogu log level to : ${LOG_LEVEL}"
}

# remove swagger.json from index.html
sed -i "s|https://petstore.swagger.io/v2/swagger.json||g" $INDEX_FILE

doguctl template "${INDEX_TEMPLATE_PATH}" "${INDEX_FILE_PATH}"

echo "Setting log level..."
export_log_level
doguctl template /etc/nginx/nginx.conf.tpl /etc/nginx/nginx.conf

doguctl state "ready"

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
