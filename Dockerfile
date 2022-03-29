FROM registry.cloudogu.com/official/base:3.10.3-2
LABEL NAME="official/swaggerui" \
      VERSION="3.25.0-2" \
      maintainer="christian.beyer@cloudogu.com"

ENV SERVICE_TAGS=webapp \
SWAGGER_UI_VERSION=3.25.0-1 \
#TODO: download of the swaggerui-code file should be validated
SWAGGERUI_ZIP_SHA256="2cd256f89e4ef42b523a47b8d8818a838b1969757e371ef1e9903c9ed9888df1"

COPY resources /
# install swaggerui from fork https://github.com/cloudogu/swagger-ui/releases/ \
ADD https://github.com/cloudogu/swagger-ui/archive/refs/tags/v$SWAGGER_UI_VERSION.tar.gz /tmp

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
    #extract swagger ui code \
 && tar -xf tmp/v3.25.0-1.tar.gz -C tmp/ \
 && cp -a tmp/swagger-ui-3.25.0-1/. var/www/html/ \
 && rm -rf /tmp \
 && mkdir tmp \
 && ls var/www/html/

# Define working directory.
WORKDIR /etc/nginx

HEALTHCHECK CMD doguctl healthy swaggerui || exit 1

# Expose ports.
EXPOSE 8080

# Define default command.
CMD ["/startup.sh"]
