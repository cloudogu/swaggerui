# Documentation

Swagger UI is an open source project that presents the documentation of an API graphically and interactively, as long as it is built according to the OpenAPI(Swagger) specification.

The official documentation of this application can be found here: https://swagger.io/docs/

In principle, this dogu can also be called anonymously without entering any login data on the login page of the Cloudogu EcoSystem. If an anonymous call is to be made, it must be ensured that the resources to be queried (e.g. repository in the SCM manager or Nexus artifacts) have been released for anonymous access.

## Loading an API specification

Enter the URL of an OpenAPI specification in the input field at the top and click "Explore",
e.g. `https://<fqdn>/scm/api/v2/openapi` for SCM-Manager (requires the SCM-Manager OpenAPI plugin).
If the specification requires a login, first log in to the respective Dogu in the same browser.
