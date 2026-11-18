# Setup for the integration tests

This section describes the steps required to properly run the integration tests.

## Requirements

* It is necessary to install the program `yarn`
* Install the dependencies once: `cd integrationTests && yarn install`

## Configuration

<!-- markdown-link-check-disable-next-line -->
**integrationTests/cypress.config.ts** [[Link to file](../../integrationTests/cypress.config.ts)]

1) The base URL must be adapted to the host system.
   For this the field `baseUrl` has to be adjusted to the host FQDN (e.g. `https://192.168.56.2`).
   Alternatively, pass it on start: `yarn cypress run --config baseUrl=https://192.168.56.2`
2) The environment variable `DoguName` determines the name of the current dogu and will be used in routing (`swaggerui`).

No admin credentials are needed, as the tests access the Dogu anonymously.

## Starting the integration tests

The integration tests can be started in two ways:

1. With `yarn cypress run` the tests start only in the console without visual feedback.
   This mode is useful when execution is the main focus, for example in a Jenkins pipeline.
2. `yarn open` starts an interactive window where you can run, visually observe and debug the tests.
   This mode is especially useful when developing new tests and finding bugs.
