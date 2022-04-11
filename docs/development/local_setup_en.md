# Setting up the Swagger UI Dogu

## Instruction

```bash
On the host system
1. cd swaggerui (into swaggerui dogu repo)
2. git submodule init
3. git submodule update (pulls cloudogu/swagger-ui)
In the local CES
4. cd swaggerui && cesapp build . && cesapp start swaggerui
```