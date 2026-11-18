# Setup für die Integrationstests

In diesem Abschnitt werden die benötigten Schritte beschrieben, um die Integrationstests korrekt ausführen zu können.

## Voraussetzungen

* Es ist notwendig, das Programm `yarn` zu installieren
* Einmalig die Abhängigkeiten installieren: `cd integrationTests && yarn install`

## Konfiguration

<!-- markdown-link-check-disable-next-line -->
**integrationTests/cypress.config.ts** [[Link zur Datei](../../integrationTests/cypress.config.ts)]

1) Die Base-URL muss auf das Hostsystem angepasst werden.
   Hierfür muss das Feld `baseUrl` auf die Host-FQDN angepasst werden (bspw. `https://192.168.56.2`).
   Alternativ beim Start übergeben: `yarn cypress run --config baseUrl=https://192.168.56.2`
2) Die Umgebungsvariable `DoguName` bestimmt den Namen des Dogus und wird beim Routing benutzt (`swaggerui`).

Admin-Zugangsdaten werden nicht benötigt, da die Tests das Dogu anonym aufrufen.

## Starten der Integrationstests

Die Integrationstests lassen sich auf zwei Arten starten:

1. Mit `yarn cypress run` starten die Tests nur in der Konsole ohne visuelles Feedback.
   Dieser Modus ist hilfreich, wenn die Ausführung im Vordergrund steht, bspw. bei einer Jenkins-Pipeline.
2. `yarn open` startet ein interaktives Fenster, in dem man die Tests ausführen, visuell beobachten und debuggen kann.
   Dieser Modus ist besonders hilfreich bei der Entwicklung neuer Tests und bei der Fehlersuche.
