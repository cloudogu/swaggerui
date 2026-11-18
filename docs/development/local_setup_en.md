# Setting up the Swagger UI Dogu

## Updating Swagger UI

The `Dockerfile` downloads the official [Swagger UI release](https://github.com/swagger-api/swagger-ui/releases)
in the version set in `SWAGGERUI_VERSION` and verifies it against `SWAGGERUI_SHA256`.
To update, adjust both values; the checksum is obtained with
`curl -fsSL https://github.com/swagger-api/swagger-ui/archive/refs/tags/v<version>.zip | sha256sum`.

## Building the Dogu

In the local CES (Vagrant), in the root directory of the Dogu:
```shell
cesapp build .
cesapp start swaggerui
```

In the K8s EcoSystem, configure `.env` (see `.env.template`) and run `make build`.

## Integration tests

See [Setup for the integration tests](Setup_Integrationtests_en.md).
