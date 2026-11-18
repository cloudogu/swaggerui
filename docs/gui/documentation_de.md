# Dokumentation

Swagger UI ist ein OpenSource-Projekt, das die Dokumentation einer API grafisch und interaktiv darstellt, sofern diese nach der OpenAPI(Swagger) Spezifikation erstellt wurde.

Die offizielle Dokumentation dieser Applikation befindet sich hier: https://swagger.io/docs/

Dieses Dogu ist grundsätzlich auch anonym ohne Eingabe von Anmeldedaten auf der Loginseite des Cloudogu EcoSystems aufrufbar. Sofern ein anonymer Aufruf erfolgen soll, muss sichergestellt werden, dass die abzufragenden Ressourcen (bspw. Repository im SCM-Manager oder Nexus-Artefakte) für einen anonymen Zugriff freigegeben wurden.

## Laden einer API-Spezifikation

Im Eingabefeld oben die URL einer OpenAPI-Spezifikation eintragen und auf "Explore" klicken,
bspw. `https://<fqdn>/scm/api/v2/openapi` für den SCM-Manager (erfordert das OpenAPI-Plugin im SCM-Manager).
Erfordert die Spezifikation eine Anmeldung, muss man sich zuerst im selben Browser am jeweiligen Dogu anmelden.
