# Setting up the Swagger UI Dogu

## Instruction

(Attention changed since v4.9.0-1)
```bash
On the host system
1. cd swaggerui (into swaggerui dogu repo)
2. git submodule init
3. git submodule update (pulls cloudogu/swagger-ui)
In the local CES
4. cd swaggerui && cesapp build . && cesapp start swaggerui
```

### Setup since 4.9.0-1
Releases can be found here https://github.com/cloudogu/swagger-ui/releases.
please reference new version inside the Dockerfile. The release currently consists only of the dist folder.
```
1. create artefact zip
inside the src repository root (https://github.com/cloudogu/swagger-ui/)
zip -r swagger-ui-4.9.0-1.zip dist
2. generate the checksum 
sha256sum swagger-ui-4.9.0-1.zip > swagger-ui-4.9.0-1.zip.sha256
3. add the artefacts to the release https://github.com/cloudogu/swagger-ui/releases
```
