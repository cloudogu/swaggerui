FROM registry.cloudogu.com/official/base:3.10.3-2
LABEL NAME="official/swaggerui" \
      VERSION="3.25.0-2" \
      maintainer="christian.beyer@cloudogu.com"

ENV SERVICE_TAGS=webapp \
SWAGGERUI_VERSION=3.25.0-1 \
SWAGGERUI_ZIP_SHA256="2cd256f89e4ef42b523a47b8d8818a838b1969757e371ef1e9903c9ed9888df1"

COPY resources /

RUN set -x \
 && apk update \
 # install required packages
 && apk --update add openssl pcre zlib nginx \
 # change owner of nginx binary
 && chown root:root /usr/sbin/nginx \
    # redirect logs
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
    # cleanup apk cache
 && rm -rf /var/cache/apk/* \
 && mkdir -p /var/www/html \
# install swaggerui from fork https://github.com/cloudogu/swagger-ui/releases/ \
 && curl -Lsk https://github.com/cloudogu/swagger-ui/releases/download/v${SWAGGERUI_VERSION}/swagger-ui-${SWAGGERUI_VERSION}.zip -o /tmp/swagger-ui.zip  \
 #&& echo "${SWAGGERUI_ZIP_SHA256} */tmp/swagger-ui.zip" | sha256sum -c - \
 && unzip /tmp/swagger-ui.zip -d /var/www/html


# copy files
# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]
