FROM registry.cloudogu.com/official/base:3.15.3-1
LABEL NAME="official/swaggerui" \
      VERSION="3.25.0-2" \
      maintainer="hello@cloudogu.com"

ENV SERVICE_TAGS=webapp \
SWAGGER_UI_VERSION=3.25.0-1

COPY resources /
# install swaggerui from fork https://github.com/cloudogu/swagger-ui/releases/ \
ADD https://github.com/cloudogu/swagger-ui/releases/download/v$SWAGGER_UI_VERSION/swagger-ui-$SWAGGER_UI_VERSION.zip /

RUN set -x \
 # check for checksum of swagger-ui code release | !!Attention: changes on new release \
 && chmod +x /checksum.sh \
 && ./checksum.sh \
 # update and install required packages
 && apk update \
 && apk --update add openssl pcre zlib nginx \
 && apk upgrade \
 # change owner of nginx binary
 && chown root:root /usr/sbin/nginx \
    # redirect logs
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
    # cleanup apk cache
 && rm -rf /var/cache/apk/* \
    #extract swagger ui code \
 && unzip swagger-ui-$SWAGGER_UI_VERSION.zip  \
 && cp -a swagger-ui-$SWAGGER_UI_VERSION/. var/www/html/

# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]
