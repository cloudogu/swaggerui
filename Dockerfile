FROM registry.cloudogu.com/official/base:3.22.0-4 AS swaggerui
ENV SWAGGERUI_VERSION=5.28.1 \
    SWAGGERUI_ZIP_SHA256="823f38e4b3c98a44fb5b2885b07919ba1da05168756c423af99b3f24c1e25fb9"
RUN apk add --no-cache curl
RUN curl -Lsk --fail --silent --location --retry 3 https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${SWAGGERUI_VERSION}.zip -o /tmp/swagger-ui.zip
RUN echo "${SWAGGERUI_ZIP_SHA256} */tmp/swagger-ui.zip" | sha256sum -c -
RUN unzip /tmp/swagger-ui.zip -d /tmp && mv /tmp/swagger-ui-${SWAGGERUI_VERSION}/dist /tmp/dist && rm -f /tmp/swagger-ui.zip

FROM registry.cloudogu.com/official/base:3.22.0-4
LABEL NAME="official/swaggerui" \
      VERSION="5.28.1-1" \
      maintainer="hello@cloudogu.com"

ENV SERVICE_TAGS=webapp \
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
  && mkdir -p ${NGINX_HOME}

COPY --from=swaggerui /tmp/dist/* ${NGINX_HOME}/

# copy files
# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK --interval=5s CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]
