#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

SWAGGER_UI_VERSION=3.25.0-1

echo "TODO: doesn't work right now cause the checksum delivered by the swagger-ui-$SWAGGER_UI_VERSION.zip.sha256 doesn't match with the swagger-ui-$SWAGGER_UI_VERSION.zip file"

# check for checksum of swagger-ui code release | !!Attention: changes on new release \
#wget https://github.com/cloudogu/swagger-ui/releases/download/v$SWAGGER_UI_VERSION/swagger-ui-$SWAGGER_UI_VERSION.zip.sha256
#sha256sum -c swagger-ui-$SWAGGER_UI_VERSION.zip.sha256
