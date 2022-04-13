FROM registry.cloudogu.com/official/base:3.15.3-1
LABEL NAME="official/swaggerui" \
      VERSION="4.9.0-1" \
      maintainer="hello@cloudogu.com"

ENV SERVICE_TAGS=webapp \
SWAGGERUI_VERSION=4.9.0-1 \
SWAGGERUI_ZIP_SHA256="0bfecf30a09247936eed6ec2d5d8ddba3b1a847e24017cd3876ddce5b33736ce" \
NGINX_HOME="/var/www/html"

COPY resources /

RUN set -x -o errexit -o nounset -o pipefail \
  && apk update \
  && apk upgrade \
  # install required packages
  && apk --update add openssl pcre zlib nginx \
  # change owner of nginx binary
  && chown root:root /usr/sbin/nginx \
   # redirect logs
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
   # cleanup apk cache
  && rm -rf /var/cache/apk/* \
  && mkdir -p ${NGINX_HOME} \
  # install swaggerui from fork https://github.com/cloudogu/swagger-ui/releases/ \
  && curl -Lsk --fail --silent --location --retry 3 https://github.com/cloudogu/swagger-ui/releases/download/v${SWAGGERUI_VERSION}/swagger-ui-${SWAGGERUI_VERSION}.zip -o /tmp/swagger-ui.zip  \
  && echo "${SWAGGERUI_ZIP_SHA256} */tmp/swagger-ui.zip" | sha256sum -c - \
  && unzip /tmp/swagger-ui.zip -d ${NGINX_HOME} \
  && mv ${NGINX_HOME}/dist/* ${NGINX_HOME} \
  # cleanup
  && rm -r ${NGINX_HOME}/dist && rm /tmp/swagger-ui.zip

# copy files
# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]