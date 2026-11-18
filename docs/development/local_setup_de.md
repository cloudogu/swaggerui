# Aufsetzen des Swagger-UI-Dogus

## Aktualisieren von Swagger UI

Die `Dockerfile` lädt das offizielle [Swagger-UI-Release](https://github.com/swagger-api/swagger-ui/releases)
in der unter `SWAGGERUI_VERSION` gesetzten Version herunter und prüft es gegen `SWAGGERUI_SHA256`.
Für ein Update müssen beide Werte angepasst werden; die Prüfsumme ergibt sich aus
`curl -fsSL https://github.com/swagger-api/swagger-ui/archive/refs/tags/v<version>.zip | sha256sum`.

## Bauen des Dogus

Im lokalen CES (Vagrant), im Wurzelverzeichnis des Dogus:
```shell
cesapp build .
cesapp start swaggerui
```

Im K8s-EcoSystem die `.env` konfigurieren (siehe `.env.template`) und `make build` ausführen.

## Integrationstests

Siehe [Setup für die Integrationstests](Setup_Integrationtests_de.md).
