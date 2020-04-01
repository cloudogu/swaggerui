FROM node:10 AS build
ENV SWAGGER_UI_TAG_VERSION=v3.25.0
WORKDIR /usr/share/build
RUN git clone https://github.com/cloudogu/swagger-ui.git \
 && cd swagger-ui \
 && git checkout ${SWAGGER_UI_TAG_VERSION} \
 && npm i \
 && npm run build

FROM registry.cloudogu.com/official/base:3.10.3-2
LABEL NAME="official/swagger-ui" \
      VERSION="3.25.0-0" \
      maintainer="christian.beyer@cloudogu.com"

ENV SERVICE_TAGS=webapp

RUN set -x \
    # install required packages
 && apk --update add openssl pcre zlib nginx \
    # redirect logs
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
    # cleanup apk cache
 && rm -rf /var/cache/apk/*

# copy files
COPY resources /
WORKDIR /var/www/html
COPY --from=build /usr/share/build/swagger-ui/dist/* /var/www/html/

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 8080
