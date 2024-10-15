# Aufsetzen des Swagger-UI Dogu

## Anleitung

(Achtung veraltet!)
```bash
Auf dem Host System
1. cd swaggerui (ins swaggerui dogu repo)
2. git submodule init
3. git submodule update (zieht sich cloudogu/swagger-ui)
Im lokalen CES
4. cd swaggerui && cesapp build . && cesapp start swaggerui
```

(ab v4.0.0-1)
```
Releases werden in https://github.com/cloudogu/swagger-ui/releases gepfelgt
und entsprechend im Dockerfile referenziert. Das Release beinhaltet aktuell den dist folder.

1. Artefakt erstellen
im repository root
zip -r swagger-ui-4.9.0-1.zip dist
2. Checksum generieren
sha256sum swagger-ui-4.9.0-1.zip > swagger-ui-4.9.0-1.zip.sha256
3. Dem Release anfügen https://github.com/cloudogu/swagger-ui/releases
```

(ab 5.17.14)
```
Die Releases werden wieder über die offizielle Seite von swagger-ui gepflegt.

Im Dockerfile des Dogus wird nur noch die entsprechende Version angepasst.
Es muss kein Aktualisierungsmerge des Forks erfolgen.  

1. download Artefakt direkt von "swagger-ui"
2. SH256-Prüfsumme erzeugen: "sha256sum swagger-ui.zip"
3. Anpassen der Versionsnummer im Dockerfile
```