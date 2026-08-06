# HANDOUT DIPLOM -> INFRA (2026-08-06): OD-7 Runner-Direktive DURCHSETZEN (Owner-Wiederholung vormittag-22 Nr. 5)

> VON: Diplomarbeit-Manager (Fable 5). AN: Infra-Agent. KANAL: Infra-Anliegen laufen per
> Owner-Direktive (Ledger 69.5) als Handout ueber dieses Repo an den Infra-Agenten; das
> Cluster-Repo ist fuer die Diplom-Linie READ-ONLY (Memory
> feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra) -- dieses Dokument aendert dort
> NICHTS, es beschreibt nur SOLL/IST und uebergibt die Umsetzung an dich.
> Keine Secrets in diesem Dokument. Diplom-Manager fasst keine Runner-Konfiguration selbst an.

## 1. DIREKTIVE VERBATIM + LEDGER-ANKER

**Original OD-7** (Owner 26.07. ~18:40, verbatim aus dem damaligen Infra-Handout
`Cluster/docs/sessions/2026-07-26-DIPLOM-AN-INFRA-od7-runner-neukonfiguration.md`):

> "24 Worker fuer prod1 und alle Threads fuer prod2 bei Tier-Binary build oder Messung bei
> concurrency 1, sonst prod1 concurrency 2 mit je 12 Threads und prod2 concurrency 2 mit je
> 12 Threads."

Ledger-Anker (Datei `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`), Abschnitt **69.6**:

> "OD-7 NEUE RUNNER-ZAHLEN (ersetzt die Ist-Konfiguration prod1=3/prod2=2): HEAVY
> (Tier-Binary-Build ODER Messung): concurrency=1, prod1=24 Worker, prod2=alle Threads. NORMAL:
> prod1 concurrency=2 x je 12 Threads, prod2 concurrency=2 x je 12 Threads. Umsetzung per
> Infra-Handout (69.5)."

**Owner-Wiederholung 06.08. vormittag-22** (6er-Block, Punkt 5, verbatim):

> "OD-7: Bitte direktive durchsetzen."

Konsequenz-Zeile im selben Ledger-Nachtrag (verbatim):

> "(OD-7) Runner-Direktive 2/2 normal + 24 Worker heavy DURCHSETZEN (Infra-Handout)."

Ziel-Tabelle (unveraendert seit 26.07., vom Owner heute erneut bestaetigt):

| Modus | prod1 | prod2 |
|---|---|---|
| **heavy** (Tier-Binary-Build ODER Messung) | concurrency=1, **24 Worker** | concurrency=1, **alle Threads (nproc)** |
| **normal** (alles andere) | concurrency=**2**, je **12 Threads** | concurrency=**2**, je **12 Threads** |

## 2. IST-ZUSTAND MIT BELEG

Zwei Quellen liefern UNTERSCHIEDLICHE Zahlen fuer das Ist. Beide werden hier getrennt
ausgewiesen, damit du selbst live entscheidest, welche stimmt -- KEINE der beiden wurde aus
einer Live-Abfrage von `/etc/gitlab-runner/config.toml` bestaetigt (diese Session hat keinen
Host-Zugriff auf prod1/prod2, und das Cluster-Repo ist fuer die Diplom-Linie read-only).

### Quelle A: `Cluster/scripts/runner-mode.sh` im Git-Checkout (Skript-Quelltext, letzter Commit)

Commit-Historie der Datei (chronologisch):

1. `2606a0b` (26.07.): Erst-Rollout, `concurrent` prod1=3/prod2=2 (Owner-unabhaengiger
   Zwischenstand vor OD-7).
2. `618e9be` (26.07.): Per-Host-Thread-Matrix. Vorbild-Stand danach (aus dem Diff des
   Folge-Commits rekonstruiert): prod1 `concurrent=3, 10 Threads/Job`; prod2 `concurrent=2, 12
   Threads/Job` -- NAEHER an OD-7, aber prod1 noch nicht exakt 2/12.
3. `0d7c577` (27.07. 06:16, Commit-Message "Normal-Profil auf c=4@4T beide Hosts (Owner-Hinweis
   2026-07-27)"): NORMAL-Profil auf BEIDE Hosts `concurrent=4, 4 Threads/Job` geaendert, Begruendung
   im Commit: "Durchsatz-Profil: mehr Slots drainen die 324s-Stall-Queue besser als wenige dicke
   Jobs" + RAM/earlyoom-Beobachtungshinweis. Dies ist der jeweils letzte Commit auf der Datei
   (keine weiteren Aenderungen danach im Log).

**Aktueller Skript-Stand** (`Cluster/scripts/runner-mode.sh:42-46`, Case-Block, Stand
Lesezeitpunkt 06.08.):

```
prod1) NORMAL_CC=4; NORMAL_J=4; HEAVY_CC=1; HEAVY_J=24 ;;
prod2) NORMAL_CC=4; NORMAL_J=4; HEAVY_CC=1; HEAVY_J=$(nproc) ;;
```

Daraus folgt laut Skript-Quelltext:
- **NORMAL weicht ab:** 4/4 Threads beide Hosts, statt der von OD-7 geforderten 2/2 x 12 Threads.
- **HEAVY entspricht laut Skript bereits OD-7:** prod1 `concurrent=1, HEAVY_J=24` (deckt "24
  Worker"), prod2 `concurrent=1, HEAVY_J=$(nproc)` (deckt "alle Threads"). Kein Hinweis auf eine
  Kappung im Code.

### Quelle B: Ledger/Register-Behauptung "Ist 3/2+16"

Der `todo-konsolidierung-14t`-Audit (06.08., 6 Agenten) traegt im Ledger-Nachtrag
"Welle todo-konsolidierung-14t KOMPLETT" folgenden woertlichen Befund:

> "OD-7-Runner-Klaerung (Ist 3/2+16-Kerne WIDERSPRICHT Owner-Direktive 2/2+24)"

Register-Doc `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md`, Zeile 55 und
178 (Abschnitt "WIDERSPRUECHE zwischen Quellen"):

> "OD-7 Runner-Zahlen HEAVY/NORMAL: runner-mode.sh normal|heavy gebaut, ABER WIDERSPRUCH zur
> Owner-Direktive: normal blieb 3/2 statt 2/2 beidseitig, heavy prod1 auf 16 Kerne gekappt statt
> 24 Worker -- vor Voll-Bau klaeren." (Zeile 55)
>
> "OD-7 Runner-Zahlen: Owner-Direktive (normal 2/2, heavy 24 Worker) vs. gebautes Ist (normal
> 3/2, heavy 16 Kerne) -- einzige bekannte aktive Abweichung von einer Owner-Direktive; vor
> Voll-Bau klaeren." (Zeile 178)

**Wichtige Einordnung:** Die eigene Methodik-Klausel des Registers (Zeile 7) sagt woertlich:
"Status-Verdikte sind aus den Lenses geerbt; keine darueber hinausgehende Code-Verifikation."
Die "3/2"-Zahl passt exakt auf den Zwischenstand nach Commit `618e9be` (prod1=3, prod2=2) --
also VOR dem 27.07-Commit `0d7c577`, der auf 4/4 aenderte. Die Register-Zahl ist damit
vermutlich ein **stale Zwischenstand**, kein aktueller Skript-Befund. Fuer "heavy prod1 auf 16
Kerne gekappt" wurde im Skript-Quelltext KEIN Beleg gefunden (Code zeigt `HEAVY_J=24`,
ungekappt); die "16" deckt sich mit der physischen Kernzahl von prod1 (Ryzen 9950X3D, 16 Kerne
/ 32 Threads, siehe Skript-Kopfkommentar Zeile 7) und mit einer reinen
**Bedenken-Notiz** aus Memory `reference_runner_concurrency_ist_3_2_stau_ist_backlog.md`
("Owner-Obergrenze 26.07.: physische Kerne sind die harte Parallelitaets-Grenze im
Schwerlast-Modus -> das alte K-Budget amd=24 Worker uebersteigt prod1s 16 phys. Kerne") --
diese Notiz war eine Warnung, KEIN Beleg fuer eine tatsaechlich umgesetzte Code-Aenderung.

**Fazit Ist-Zustand:** Zwei mit Vorsicht zu behandelnde Zahlenpaare stehen im Raum (Skript-Text
"4/4 normal, 24/nproc heavy" vs. Register-Zahl "3/2 normal, 16-Kernel-Kappung heavy"), und
KEINE davon ist live-verifiziert. Bitte Punkt 5 (Verifikationskommandos) VOR jeder Aenderung
ausfuehren, bevor du dich auf eine der beiden Zahlen verlaesst.

## 3. SOLL je Runner (konkrete Config-Aenderung)

| Modus | prod1 (Ziel) | prod2 (Ziel) |
|---|---|---|
| **normal** | `concurrent=2`, `CMAKE_BUILD_PARALLEL_LEVEL=12` / `MAKEFLAGS=-j12` | `concurrent=2`, `CMAKE_BUILD_PARALLEL_LEVEL=12` / `MAKEFLAGS=-j12` |
| **heavy** | `concurrent=1`, `CMAKE_BUILD_PARALLEL_LEVEL=24` / `MAKEFLAGS=-j24` (laut Skript-Quelltext bereits so -- LIVE bestaetigen) | `concurrent=1`, `CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)` (laut Skript-Quelltext bereits so -- LIVE bestaetigen) |

Konkrete Aenderung in `Cluster/scripts/runner-mode.sh`, Case-Block (aktuell Zeilen 42-46):

```
prod1) NORMAL_CC=2; NORMAL_J=12; HEAVY_CC=1; HEAVY_J=24 ;;
prod2) NORMAL_CC=2; NORMAL_J=12; HEAVY_CC=1; HEAVY_J=$(nproc) ;;
```

Das ist eine bewusste **Ruecknahme** des 27.07-Durchsatz-Experiments (Commit `0d7c577`, 4/4
beide Hosts). Der 27.07-Kommentar nannte "mehr Slots drainen die 324s-Stall-Queue besser" als
Grund und vermerkte RAM/earlyoom auf prod2 als "koennte stabil" (unbestaetigt) -- falls du dazu
aktuelle Beobachtungsdaten hast, die gegen 2x12 sprechen, bitte VOR der Aenderung kurz an die
Diplom-Seite zurueckmelden statt eigenmaechtig abzuweichen: der Owner hat heute wortwoertlich
"durchsetzen" gesagt, nicht "abwaegen".

Bitte zusaetzlich den Kopfkommentar (Zeilen 6-13, die Mode-Tabelle) auf die neuen Werte
nachziehen, damit Skript-Doku und Skript-Verhalten wieder deckungsgleich sind.

## 4. RISIKO / ZEITPUNKT-EMPFEHLUNG

**Praezisierung, WARUM welcher Teil wie dringend ist** (Memory
`reference_runner_concurrency_ist_3_2_stau_ist_backlog.md`, woertlich): "Mess-Schutz laeuft
ueber P11-Wache + resource_group + 1-Thread-Doktrin, NICHT ueber `concurrent`." Das heisst: die
NORMAL-Profil-Differenz (2/2x12 vs. gebautes 4/4x4) ist in erster Linie eine
**Stabilitaets-/Durchsatz-/Direktiv-Konformitaets-Frage** (RAM/earlyoom-Risiko bei 4x4, im
27.07-Commit selbst als "BEOBACHTEN" offen gelassen) -- keine direkte Verletzung der
Mess-Serialisierung, da diese ueber den HEAVY-Modus (hartes `concurrency=1`) laeuft, nicht ueber
die NORMAL-Zahlen.

Der tatsaechlich **messungskritische** Teil ist zweigeteilt:

- **(a) Terminkritisch:** Vor dem naechsten Voll-Bau-/Messungs-Trigger MUSS `runner-mode.sh
  heavy` auf BEIDEN Hosts tatsaechlich scharf geschaltet sein (SIGHUP-Reload bestaetigt, nicht
  nur im Skript committet) -- das waere der Punkt, an dem ein "vergessenes Umschalten" die
  1-Thread-Doktrin real braeche.
- **(b) Klaerungskritisch VOR dem Trigger:** Falls die Register-Behauptung "16-Kerne-Kappung"
  fuer prod1-heavy zutrifft, wuerde das den von OD-7 vorgegebenen 24-Worker-Rahmen fuer den
  messungskritischen Pfad direkt unterschreiten. Das ist der einzige Punkt aus Abschnitt 2, der
  unbedingt vor dem Trigger live geklaert werden muss (Kommando 5d).

**Empfehlung:** NORMAL-Korrektur (2/2x12) zeitnah einplanen, aber ohne Terminzwang zum
Voll-Bau-Trigger (wirkt nur auf normalen CI-Durchsatz, nicht auf den Messungspfad). Die
HEAVY-Verifikation (5c/5d) dagegen bitte **zwingend vor dem naechsten Voll-Bau-/Messungs-Trigger**
abschliessen, weil sie den tatsaechlichen Messungspfad betrifft (Ledger
P3-TRIGGER-VORBEREITUNG, aktuell offener Diplom-Task "OD-7-Handout" in der laufenden Session).
Kein Nacht-/Sofort-Zwang: der Owner-Ton war "durchsetzen", keine akute Eskalation.

## 5. VERIFIKATIONS-KOMMANDOS FUER DEN INFRA-AGENTEN

**(a) Live-Ist lesen, BEIDE Hosts, vor jeder Aenderung** (config.toml enthaelt den
cache.s3-SecretKey -- nie die ganze Datei ausgeben, nur die grep-Treffer):

```
grep -nE '^concurrent[[:space:]]*=' /etc/gitlab-runner/config.toml
grep -nE '^[[:space:]]*environment[[:space:]]*=' /etc/gitlab-runner/config.toml
```

Daraus die tatsaechlich geladenen `CMAKE_BUILD_PARALLEL_LEVEL`/`MAKEFLAGS`-Werte je Host
ablesen -- NICHT aus diesem Handout oder dem Skript-Kommentar uebernehmen, das sind nur
Git-Checkout-Staende.

**(b) Aenderung nur ueber `runner-mode.sh`** (NIE `config.toml` von Hand editieren, NIE
`systemctl restart` -- nur SIGHUP-Reload, siehe Skript-Kopf Zeilen 27-30): Case-Block (Zeilen
42-46) fuer prod1 UND prod2 auf `NORMAL_CC=2; NORMAL_J=12` setzen (siehe Abschnitt 3), dann je
Host:

```
/usr/local/sbin/runner-mode.sh normal
```

**(c) Nach jeder Aenderung** das eingebaute Verify-Ende des Skripts pruefen (laeuft automatisch,
Zeilen 123-136) und die DREI Treffer woertlich in der Ruecklaufmeldung zitieren (kein Haken ohne
woertliche Ausgabe):
- `journalctl`-Zeile "Configuration loaded ... max_builds=2"
- `concurrent = 2` in config.toml
- `CMAKE_BUILD_PARALLEL_LEVEL=12` in der environment-Zeile

**(d) Heavy-Pfad separat verifizieren** (widerlegt/bestaetigt die Register-Behauptung "16
Kerne", zwingend vor dem naechsten Voll-Bau-Trigger):

```
/usr/local/sbin/runner-mode.sh heavy   # auf prod1
grep -nE '^[[:space:]]*environment[[:space:]]*=' /etc/gitlab-runner/config.toml
```

Erwartung: `CMAKE_BUILD_PARALLEL_LEVEL=24` (NICHT 16). Falls tatsaechlich 16 gefunden wird: das
ist der bislang unbelegte Punkt aus dem Register (Zeile 55/178) real geworden -- bitte mit
Fundstelle (welcher Commit/welche Config-Quelle den Cap auf 16 gesetzt hat) an die Diplom-Seite
zurueckmelden, NICHT stillschweigend auf 24 ueberschreiben ohne den Fund zu dokumentieren.

**(e) Rueckmeldung:** wie beim 26.07-Handout ueblich als Commit in dieses Cluster-Repo
(Journal-Stil), mit den woertlichen Verify-Ausgaben aus (a)/(c)/(d). Bei Rueckfragen:
Handout-Antwort-Datei daneben legen; die Diplom-Seite liest development regelmaessig.

## QUELLEN (fuer Nachvollziehbarkeit)

- `Cluster/docs/sessions/2026-07-26-DIPLOM-AN-INFRA-od7-runner-neukonfiguration.md` (Original-Handout, Owner-Zitat)
- `Cluster/scripts/runner-mode.sh` (aktueller Skript-Stand, Zeilen 6-13 + 42-46; Commits `2606a0b`, `618e9be`, `0d7c577`)
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §69.5/69.6, Nachtrag "vormittag-22" (Owner-6er-Block Punkt 5), Nachtrag "todo-konsolidierung-14t KOMPLETT"
- `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` Zeile 7 (Methodik-Klausel), 55, 178
- Memory `reference_runner_concurrency_ist_3_2_stau_ist_backlog.md`
- Memory `feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra.md`

## SELBSTCHECK (ASCII-only)

```
sed 's/§//g' 20260806-HANDOUT-od7-runner-direktive-infra.md | grep -cP '[^\x00-\x7F]'
```
Erwartung: 0.
