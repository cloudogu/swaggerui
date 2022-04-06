FROM node:10 AS build
# separate COPY and RUN commands to use docker build cache
COPY swagger-ui/package.json /usr/share/build/swagger-ui/package.json
COPY swagger-ui/package-lock.json /usr/share/build/swagger-ui/package-lock.json
WORKDIR /usr/share/build/swagger-ui
RUN npm i
COPY / /usr/share/build/
RUN npm run build

FROM registry.cloudogu.com/official/base:3.15.3-1
LABEL NAME="official/swaggerui" \
      VERSION="3.25.0-2" \
      maintainer="hello@cloudogu.com"

ENV SERVICE_TAGS=webapp

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
 && mkdir -p /var/www/html

# copy files
COPY resources /
COPY --from=build /usr/share/build/swagger-ui/dist/* /var/www/html/

# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]
