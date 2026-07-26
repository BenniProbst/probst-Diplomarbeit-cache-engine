# 20260726 Runner-Verortung prod1/prod2 (Workflow-Rohdaten)

ZWECK: Verortung VOR einem Runner-Umbau - Cluster-Runner-/CI-Doku, SSH-Zugangsweg und
concurrency-/Thread-Doktrin erheben, damit die Modi (Normal 3/2 + max 12 Threads gegen
Voll-Bau/Messung 1 Job + physische Kerne) auf belegtem Ist-Stand statt auf Annahmen aufsetzen.

AGENTEN: 4 (runner-doku, zugangsweg, mess-doktrin + 1 xhigh-Verortungs-Brief).

KERN-ERGEBNIS: Der Doku-Widerspruch "Runner laeuft als root vs. gitlab-runner" ist aufgeloest -
beide Aussagen stimmen auf verschiedenen Ebenen (Manager als root, Job-Shells als gitlab-runner,
SIGHUP-Ziel ist der root-Manager). Der Ist-Wert von `concurrent` bleibt LIVE UNGEPRUEFT, weil
/etc/gitlab-runner/ fuer den unprivilegierten User nicht lesbar ist, und die Thread-Quellen
widersprechen sich literal (statische CI 6, Gruppen-Variable 10, dynamische Planer-Jobs 24).

REDAKTION: Dieser Lauf beruehrt Infrastruktur. Er enthaelt Topologie (Hostnamen, IPs,
Konto-ROLLEN, Vault-Fundstellen als Datei:Zeile) - aber KEINE Credential-Werte; ein
Credential-NAME wurde per Regel-Pass zu ***CRED-NAME-REF:...*** ersetzt.

HINWEIS: Rohdaten-Sicherung, keine Struktur-Autoritaet. Autoritativ sind die benannten
Session-Docs und die Memories. Agent-Volltranskripte (agent-*.jsonl) sind NICHT gesichert.
