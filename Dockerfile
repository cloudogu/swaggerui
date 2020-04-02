FROM node:10 AS build
COPY / /usr/share/build/
WORKDIR /usr/share/build/swagger-ui
RUN npm i && npm run build

FROM registry.cloudogu.com/official/base:3.10.3-2
LABEL NAME="official/swaggerui" \
      VERSION="3.25.0-1" \
      maintainer="christian.beyer@cloudogu.com"

ENV SERVICE_TAGS=webapp

RUN set -x \
 # install required packages
 && apk --update add openssl pcre zlib nginx \
 # change owner of nginx binary
 && chown root:root /usr/sbin/nginx \
    # redirect logs
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
    # cleanup apk cache
 && rm -rf /var/cache/apk/* \
 && mkdir -p /var/www/html

# copy files
COPY resources /
COPY --from=build /usr/share/build/swagger-ui/dist/* /var/www/html/

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/startup.sh"]

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080
