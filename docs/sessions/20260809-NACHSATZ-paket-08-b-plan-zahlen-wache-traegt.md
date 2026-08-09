# NACHSATZ 09.08.2026 -- Paket 08-B (Plan-Zahlen-Wache) TRAEGT: die zwei nachpruefbaren Luecken sind zu

**Rolle:** Nachsetzer (Fable 5 xhigh) auf den Bau-Agenten von 08-B, der sein eigenes Paket als
"nicht tragend" einstufte. Befund nach Messung am Objekt: **der Inhalt trug schon, zwei der vier
Gruende waren schliessbar und sind jetzt geschlossen; einer war zu streng; einer bleibt als
verbuchte Infra-Schuld.** Alle Zahlen unten sind heute frisch gemessen, nicht uebernommen.

## 1. Submodul-Reparatur: ROT vorher, GRUEN nachher -- und der Preis war 7 MB, nicht Hunderte

Ausgangslage (nachgemessen): Arbeitskopie des Submoduls auf `a1d0c201` (03.06.), super HEAD
fuehrt Gitlink `25fe4fbf`; `git cat-file -e` auf den Gitlink-Commit im Submodul-Objektspeicher
schlug fehl (rc=1). Die Wache OHNE `COMDARE_CE_QUELLE` brach literal ab:

    ABBRUCH: der ce-Baum am Gitlink-SHA 25fe4fbfc7751a2aa94a71bd11f89409437c74a7 ist nirgends lesbar.
    RC=2

Die Furcht des Bau-Agenten ("Hunderte MB in einen 35-MB-Objektspeicher, 32 G frei") galt dem
NETZ-Fetch von origin -- der ist wegen der GitLab-Stoerung ohnehin tot. Der lokale Weg war offen:
`/home/comdare/wt-ce-xml` fuehrt den Gitlink-Commit (`cat-file -e` rc=0, nur lesend benutzt).
Delta vorab gemessen: **977 Objekte, 5,6 MB on-disk** (`rev-list --objects a1d0c201..25fe4fbf`
durch `cat-file --batch-check`, Summe objectsize:disk). Fetch per Pfad (rc=0, ohne Pipe gemessen),
Checkout detached auf den Gitlink. Platte vorher/nachher: 31217 -> 31210 MB frei = **7 MB**.
`git status` in super fuehrt das Submodul seither NICHT mehr als `M`.

Danach die Wache ohne jeden Notfall-Pfad, der Codepfad, den die CI nimmt:

    ce-Quelle                : .../Code/external/comdare-cache-engine  (Submodul)
    OK    SCHEMA-STELLEN : Plan sagt 29, Objekt liefert 29.   (Nenner: 450 Test-.cpp [...])
    (Nenner-Rest der Zeile, hier umbrochen: 35 Rohzeilen, davon Kommentar abgezogen)
    OK    SCHEMA-DATEIEN : Plan sagt 17, Objekt liefert 17.
    PLAN-ZAHLEN-WACHE: OK (5 von 5 Ankern decken sich mit dem Objekt).
    RC=0

Koeder dazu (K13, gewuerfelt, nicht abgeschrieben): Anker `CI-AUFRUFE` in einer Plan-KOPIE auf
den Wuerfelwert 752 gesetzt -> `ROT CI-AUFRUFE: Plan sagt 752, Objekt liefert 2`, RC=1.
Probe zweimal voll gefahren: **10 Faelle, 22 Zusicherungen, 0 gerissen, rc=0 (ohne Pipe
gemessen)**, Wuerfelwerte der beiden Laeufe verschieden (Anker SCHEMA-STELLEN/84 vs.
SCHEMA-DATEIEN/87) -- die Zufaelligkeit ist belegt, nicht behauptet.

## 2. b566bc8f ist jetzt DIREKT am Server belegt

`git ls-remote` live gegen GitHub: `refs/heads/development = 3719cdd9` (rc=0), und
`git merge-base --is-ancestor b566bc8f 3719cdd9` -> rc=0. Der dritte Commit des Bau-Agenten
liegt damit nicht mehr nur mittelbar (ueber den Fremd-Push), sondern durch eigene Gegenprobe
an einem lebenden Remote belegt.

## 3. Pipeline-Gruen: bleibt Infra-Schuld, heute erneut literal belegt

Anonym (CA `Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt`): `/-/readiness` 200,
`/api/v4/version` 401, `/api/v4/projects/288` 404, `/` 302 -- die Instanz lebt.
Authentifiziert: `git ls-remote origin` **rc=128 (ohne Pipe gemessen), HTTP 500**. Das ist
dasselbe Bild wie im Infra-Handover
`docs/sessions/20260809-INFRA-HANDOVER-gitlab-auth-500-alle-authentifizierten-pfade.md`;
Modus a ist seit Ledger-Eintrag `325e41f9` reaktiviert, die Batch-Schuld "Pipelines fuer
4e0b7e0d..HEAD" schliesst die 08-B-Commits und diesen hier ein. Der Job
`docs:plan-zahlen-wache` steht unveraendert registriert (`.gitlab-ci.yml:398`, ohne
`allow_failure`, faehrt Wache UND Probe); die Registrierungs-Pruefung der Probe (Fall 10) ist
am heutigen, auf 1579 Zeilen gewachsenen YAML gruen.

## 4. Die 47: Zustands-Hypothese tot, eine gekennzeichnete Sieben-te-Zaehlweisen-HYPOTHESE

Der Plan wurde mit `0c992af3` (08.08. 18:52Z) eingefuehrt, und der Gitlink stand da BEREITS
auf `25fe4fbf` -- die Zahl kann also nicht aus einem aelteren Submodul-Stand stammen.
Muster-Varianten am eingefrorenen Zustand liefern ebenfalls keine 47: `lazy_csv_header` ohne
Klammern tests/ = 55 Zeilen/18 Dateien, `csv_header` tests/ = 57, ganzer Baum = 119/48.
Auffaellig, als HYPOTHESE gekennzeichnet und NICHT in den Plan geschrieben: **29 + 18 = 47**
ist die einzige Paarsumme aus den gemessenen Zaehlwerten -- 29 Aufruf-Stellen (ohne Kommentar)
plus 18 Token-DATEIEN, zwei Kategorien aus zwei Zaehlweisen addiert. Das waere genau die
Klasse `kein-nenner`, ist aber unbewiesen und bleibt es, bis der Erzeuger der Zahl spricht.

## 5. Gealtert, benannt, kein Defekt

Die B-3-Annotation zitiert `.gitlab-ci.yml:931/:1023` (gemessen bei 1539 Zeilen); heute stehen
die beiden Aufrufe auf `:1015/:1107` (1579 Zeilen). Die Annotation nennt ihren Zustand ueber
den Nenner, die Wache zaehlt MUSTER statt Zeilennummern -- nichts wird still falsch. Die vom
Zweitschreiber gebaute Anker-Wache (D5-3) ist der richtige Ort, falls Zeilenverweise dieser
Klasse kuenftig maschinell altern sollen.

**Verdikt: 08-B traegt.** Offen bleibt ausschliesslich die verbuchte Batch-Schuld
(CI-Nachweis, sobald die GitLab-Auth zurueck ist) und die unbewiesene 47-Herkunft.
