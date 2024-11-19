FROM registry.cloudogu.com/official/base:3.20.3-3 as swaggerui
ENV SWAGGERUI_VERSION=5.18.2 \
    SWAGGERUI_ZIP_SHA256="33d0c4035a2ffb62bc5f381685d8f4606825e9e9ff0c23ddc19f44fd5af3d383"
RUN apk update && apk add curl
RUN curl -Lsk --fail --silent --location --retry 3 https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${SWAGGERUI_VERSION}.zip -o /tmp/swagger-ui.zip
RUN echo "${SWAGGERUI_ZIP_SHA256} */tmp/swagger-ui.zip" | sha256sum -c -
RUN unzip /tmp/swagger-ui.zip -d /tmp && mv /tmp/swagger-ui-${SWAGGERUI_VERSION}/dist /tmp/dist

FROM registry.cloudogu.com/official/base:3.20.3-3
LABEL NAME="official/swaggerui" \
      VERSION="5.18.2-1" \
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