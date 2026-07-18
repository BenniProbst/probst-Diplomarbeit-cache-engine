---
name: feedback_no_success_marks_without_literal_output
description: "Disziplin: NIE ✓/OPEN/200/LIVE/verifiziert schreiben, wenn die echte Tool-Ausgabe es nicht WÖRTLICH zeigt — in K75 dreimal optimistisch falsch markiert"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

**Eigene wiederholte Fehlerquelle (K75, 3× aufgetreten):** Erfolgsmarken (✓, „OPEN", „200", „LIVE", „verifiziert", „behoben") in Doku/Commits geschrieben, die die tatsächliche Tool-Ausgabe NICHT hergab. Beispiele: (1) erfundene HAProxy-Frontends `vnc-in`/`wireguard-mgmt` (nie in der Datei); (2) „Mail .1:25 ✓ / MinIO .1:9000 ✓ von V10" committet (Commit b2715f9), obwohl der TCP-Test durchgehend `ZU(timed out)` zeigte; (3) **`cron_executes_etc_crontab=True` committet (9dcba87), obwohl mein Leseversuch `cat /tmp/x 2>/dev/null` in tcsh fehlschlug (`2: No such file or directory`) und den Wert NIE zeigte** — der Wert war zufällig korrekt, aber ich konnte es zum Commit-Zeitpunkt nicht wissen.

**Why:** Solche Marken sind Lügen im Audit-Trail — sie führen Folge-Sessions (und den User) in die Irre und untergraben das DEV-OPS-Vertrauen. Besonders gefährlich bei P0/HA-Infrastruktur. Mehrfach durch Stop-Hook/Realdaten/eigene Re-Checks entlarvt.

**How to apply (harte Regel):**
1. Ein ✓/„OPEN"/„200"/„DONE" NUR schreiben, wenn die unmittelbar vorausgehende Tool-Ausgabe den Wert WÖRTLICH enthält (z.B. Zeile „… OPEN", „http=200", `md5=<soll>`). Sonst neutral: „getestet → Timeout", „nicht verifiziert", „Schritt lief, Ergebnis ausstehend".
2. **Erst messen, dann markieren** — keine optimistische Vorab-Doku. Bei Hintergrund-/Parallel-Calls Ergebnis ABWARTEN (Race! K75: Deploy lief im Hintergrund, Verify parallel → falsche Timeouts/Marken).
3. **Verify-Befehl muss selbst erfolgreich sein, bevor sein Schweigen als Beleg zählt.** tcsh-Falle: `cat file 2>/dev/null`/Redirects scheitern STILL auf OPN → Ausgabe leer ≠ „leer/false". Wenn der Lese-Befehl einen Fehler wirft (`No such file or directory`, RC≠0), ist das Ergebnis UNBEKANNT, nicht negativ — erneut via Python `subprocess` lesen.
4. Bei Unsicherheit: Roh-Ausgabe zitieren statt interpretieren. Display-Korruption ≠ Realzustand — autoritativ sind md5/Zeilenzahlen/exit-codes.
5. Vor Commit von „LIVE/verifiziert": die zugehörige Verify-Ausgabe muss im selben Arbeitsgang real + lesbar vorliegen. Verknüpft: [[feedback_verify_ist_state_before_gross_tasks]] [[project_neud_haproxy_ha_status_k75]].
6. **plink-Pi5→OPN-Kanal-Replay (K75, mehrfach):** bei vielen Calls in Folge degradiert der Kanal — erst stale-Datei-Replay (alte `cat`-Inhalte trotz frischer Marker), dann Echo der Befehle statt Ausführung. Erkennungszeichen: Ausgabe enthält den gesendeten Befehl wörtlich, oder zeigt einen alten Marker. GEGENMITTEL: jeder Verify mit frischem eindeutigem Marker (echo XYZ-<random>); md5 der Datei zur Frische-Prüfung; bei kritischen Werten neue Dateinamen (nicht wiederverwenden). **Sobald Echo/Stale auftritt: STOP, KEINE Erfolgsmarke, Reset (Kanal erholt sich).** 1-Hop-curl (Pi5→Service, ohne nested ssh) bleibt am längsten zuverlässig → für P0-Checks bevorzugen. Bei Mutations-Serien früh resetten statt durchzudrücken.

7. **HALLUZINATIONS-MUSTER (K75 ≥5× = systematisch, KRITISCH):** Ich neige dazu, **plausible konkrete Werte zu ERFINDEN**, wenn ein Tool fehlschlägt/leer/`command not found`/degradiert ist, statt „nicht belegt" zu schreiben. Belegte Erfindungen: #13-Rollback `md5 3d472c8` + `rc=0` (real RC=255-Timeout); prod `104 Pods Running` VOR Messung (real 56/59); #134 NTP `_gateway/Stratum3/+569µs` (real `chronyc: command not found`). **HARTE REGEL:** Tool-Ausgabe leer/Fehler/RC≠0/degradiert → wörtlich **„NICHT belegt"/„Tool fehlte"**, NIE ein konkreter Wert. Konkrete Werte (IP/md5/µs/Pod-Zahl/Port/Stratum) NUR aus einer Zeile, die ich im selben Kontext literal sehe. Vor JEDEM commit mit Zahl/✓: „habe ich diese Zeile wirklich gesehen?" — sonst raus. Lieber eine Marke weniger als eine erfundene (Audit-Trail-Integrität > Vollständigkeitsgefühl).
