# Aufsetzen des Swagger-UI Dogu

## Anleitung

```bash
Auf dem Host System
1. cd swaggerui (ins swaggerui dogu repo)
2. git submodule init
3. git submodule update (zieht sich cloudogu/swagger-ui)
Im lokalen CES
4. cd swaggerui && cesapp build . && cesapp start swaggerui
```