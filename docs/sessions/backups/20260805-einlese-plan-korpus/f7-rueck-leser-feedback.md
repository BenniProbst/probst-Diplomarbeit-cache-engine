# LENS f7-rueck-leser-feedback — Einlese-Bericht (05.08.2026)

Objekt: Plan-Spezifikation des Planer-Rueck-Leser-Feedback-Kreislaufs (Owner F7 05.08.: JA).
Quellen: SSOT-Ledger (LEDGER = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md), Bauplan 20260719,
Kette-Audit-Backup 20260805 (IST, nicht neu erhoben), deprecated-Audit 20.07., FAHRPLAN/KATALOG 08/2026,
982er-Wahrheits-Anker, Chunk-Delta-Memory, Memories. Alle Zitate verbatim mit datei:zeile.

---

## 0. Die Owner-Antwort F7 selbst (juengste Autoritaet, 05.08. mittag-1)

LEDGER:4031 (verbatim, Vollpersistenz E-21):
> "Frage 7: Ja klar, er ist eine eigene Binary und die CEB laeuft eigenstaendig, wie soll sonst der
> Planer dem User feedback ueber die zurueckgeschriebenen Messwerte und durch CEB kompilierten
> Tier-Binaries geben?"

LEDGER:4032 (bindende Konsequenz): "**F7 = Planer-Rueck-Leser JA:** Planer (eigene Binary) liest die
zurueckgeschriebenen Messwerte + den Stand der CEB-kompilierten Tier-Binaries RUECK und gibt dem User
Feedback; CEB laeuft eigenstaendig." — Koppelt an F1 (HARTES GO Planer-Binary-Split VOR Abgabe Fr 08.08.,
"sonst werden die Binaries aller Stufen nicht korrekt gebaut").

Wichtige Nuance: "die CEB laeuft eigenstaendig" — der Rueck-Leser ist als LESE-/REPORT-Organ fuer den
USER definiert, nicht als Steuer-Puppenspieler der laufenden CEB.

---

## 1. §38-Rueck-Kanal (Cursor/Delta) — die Draht-Spezifikation

- LEDGER:2364 (§38 REVISION, User-Direktiv verbatim-treu): der Planer "erhält von der CEB **doch einen
  RÜCK-KANAL für die Fortschrittsmessung einer Experiment-Permutation**. Dabei wird **sparse immer nur
  die Achse(n) in der lazy Materialisierung mit der gewählten Konfiguration übermittelt, die für eine
  neue Permutation und Erzeugung der nächsten Tier-Binary notwendig sind**."
- LEDGER:2368: "**Der Rück-Kanal ist ein FORTSCHRITTS-/Cursor-Protokoll, KEIN Mess-Daten-Rückfluss**
  (Messwerte schreibt die CEB weiterhin selbst ans Ziel) ... sparse-Übermittlung = nur die
  Achsen-Konfigurations-**Deltas** ... passt exakt zur Mixed-Radix-Iteration der lazy StaticBinaryView."
- Bauplan 20260719-planer-ceb-tier-topdown-BAUPLAN.md:253 (KONSOLIDIERUNG §38): alle
  "EINDIMENSIONAL/kein Rückkanal"-Stellen REVIDIERT; obere Dock-Grenze bidirektional mit asymmetrischer
  Nutzlast (hinab Teilbaum-Ranges, hinauf Fortschritts-Deltas).
- Fertig-Signal-Semantik: ist-planer.md:62 (Audit): "`ProgressDelta` (cursor + mixed-radix-minimale
  `ProgressAxisChange`-Liste, **done=true GENAU EINMAL am Fensterende = §38.b-Fertig-Signal**;
  Header-Doku: 'KEIN Mess-Daten-Rueckfluss')".
- Cursor-Definition: LEDGER:3630 (TP1FK1-B5): "`ProgressDelta::cursor` ist der FENSTER-relative
  Perm-Index — gefeuert wird die Position in `indices`, nicht die builds-Laufvariable ... EINE
  Abbildung (fenster_cursor_of) an allen drei Feuerungs-Stellen."

## 2. §38.b-Sequenzierung durch den Planer (SOLL) und ihr heutiger Traeger (IST)

- LEDGER:2373 (§38.b verbatim): "Es kann nur eine CEB gleichzeitig laufen — daher ist sonst je CEB ...
  **ohne Feedback eine Abschätzung nicht möglich, ob eine Messung wirklich in der Gesamt-Permutation
  allein läuft** (sonst Messfehler). **Multiple CEBs laufen sequentiell.**"
- LEDGER:2376: "der §38-Fortschritts-Rück-Kanal liefert dem Planer genau das Fertig-Signal, mit dem er
  die **nächste CEB erst nach Abschluss der vorigen** startet (Sequenzierung über den Rück-Kanal —
  ohne ihn keine Allein-Lauf-Garantie)."
- §61-Revision: LEDGER:3269/3274: Exklusivitaet gilt **PRO Maschine** (resource_group `ceb-measure-<host>`
  statt global); "§61 REVIDIERT §38.b von GLOBAL auf PRO MASCHINE".
- IST (Audit-synthese.md:63, NICHT neu erheben): "Status-'Pipe' = Trace/stderr/progress.cursor-Datei,
  kein lebender IPC — es gibt keinen residenten Planer-Prozess ... Sequenzierung leistet die
  resource_group, der Cursor ist 'REINER BEOBACHTER' (main.cpp:1391-1394 verifiziert), progress.cursor
  hat keinen Rueck-Leser. §38.b-Fertig-Signal traegt damit NICHT die Planer-Sequenzierung."
  = Regression R-G4/5 (LEDGER:4025): "§38.b-Fertig-Signal ohne Rueck-Leser (progress.cursor
  konsumentenlos, ProgressSink 'REINER BEOBACHTER')".
- §52-B14-Restpunkt (1) OFFEN: LEDGER:2783/2875: "(1) ProgressSink hat KEINEN echten Konsumenten —
  feuert live ins No-Op, Planer-seitige Sequenzierungs-Logik fehlt". (Restpunkte 2+3 sind laut Audit
  synthese.md:45 am Objekt ERLEDIGT/GESCHLOSSEN.)

## 3. R3-CLI-Logging — WAS der Planer dem User zeigt

- LEDGER:3243 (§60-R3, OFFEN hoch): der Planer soll "**Zustand/Builds/Messungen der CEB und der
  Tier-Binaries LOGGEN**, damit der Nutzer den Stand kennt. Der User will das Programm spaeter
  **manuell mit der XML-Config fahren** koennen."
- Owner-KERN-VERSCHAERFUNG 05.08. (memory project_post_v3...md): "Der Planer ist ZWINGEND eine eigene
  Binary mit dem User-CLI-Interface auf der Shell" — R3 von Wunsch zu HARTER Struktur-Pflicht.
- Freigegebene Bau-REIHENFOLGE (LEDGER:3247, §60-NACHTRAG, User-GO): "**1.** CLI-Haertung (R3:
  run <xml>/--profile + --help-offizieller-Weg + --print-env -> **--status-Aggregator** ->
  **%/ETA/JSON-Marker** -> lokales Stufe-1->2-Kommando)".
- Detail-Spezifikation der Luecken (2026-07-20-SESSION-DEPRECATED-AUDIT...md:37): "kein `--status`-
  Aggregator (Zustand fragmentiert über cursor/Sidecars/CSV-Stamps/minio-Marker), progress.cursor
  write-only ohne %, ETA, Resume ... keine maschinenlesbaren Marker (JSON/Exit-Codes)". Ebd.:41:
  "`--status`-Aggregator (**cursor/Sidecars/CSV-Stamps lesen**) → Fenster-Gesamtgröße in ProgressDelta
  (%, ETA) + JSON-Marker → lokales Stufe-1→2-Durchfahr-Kommando." Ebd.:91-92: "kein `--status`; der
  Zustand liegt fragmentiert in progress.cursor, .version-Sidecars, per-Binary-result.csv-Stamps,
  minio-Teil-Markern und CI-Job-Namen — kein Aggregator liest sie zurück" · "progress.cursor ist
  write-only (append, kein Reader/Resume-Anzeiger); ProgressDelta trägt keine Fenster-Gesamtgröße →
  kein %, keine ETA".
- Terminierungs-Stand vor F7: FAHRPLAN 20260803:67 "R3-CLI-Reste (--print-env, --status-Aggregator,
  ETA/JSON-Marker) an Phase-5-ETA + Phase-6-E-04 anheften"; KATALOG 20260802:92 "R3 Planer-CLI
  TEILWEISE (f5cf3954 clig.dev-Subcommands; offen: --print-env, --status-Aggregator, %/ETA/JSON-Marker)".
  → F1/F7 (05.08., spaeter) heben Split+Rueck-Leser auf VOR-Abgabe-Pflicht; die Phase-5/6-Anheftung
  ist fuer den Rueck-Leser-Kern damit ueberholt (spaeter schlaegt frueher).
- Ur-Anforderung des User-Feedbacks (982er-Anker E-04/nr38, 20260726-SESSION-wahrheits-anker...:31-33):
  "ich [muss] live sehen ... ob der CacheEngineBuilder Orchestrator gebaut wird und exakt welche
  Tier-Binary Rekombinationen und wie viele davon noch offen sind"; Feststellung dort:
  "complete-heuristik.log ist Cache-Claim, kein CI-Report; Nachtest fehlt -> 2^17 blind."
  LEDGER:3550 (§68c): E-04 = "CI-Live-Fortschritt + generische Interface-Nachtests je Tier-Binary",
  Bau-Paket VOR dem Voll-Bau-4-Trigger.

## 4. Testat-/Bestandslog-Grammatik — die maschinenlesbare Lese-Grundlage

- LEDGER:3412-3417 (Testat-Grammatik ebenen-richtig, 22.07.):
  Bau/Pruef (Stufe 2): "`[TESTAT] ts=<ISO> lane=<L> zelle=[d,e,f][g,h,i] phase=<bau|pruef>
  fenster=START:COUNT`"; Mess (Stufe 3): "`[TESTAT] ts=<ISO> lane=<L> zelle=[a,b,c][d,e,f][g,h,i]
  phase=mess fenster=START:COUNT`"; Bestandslog-Schluessel GETRENNT: "[a,b,c] -> CEB-Binary-Replay ·
  [d,e,f] ALLEIN -> Tier-Binary-Replay · [d,e,f]+[g,h,i] GEMEINSAM + Hardware-Identitaet -> Messwert.
  Die Testat-Grammatik speist diese drei Schluessel."
- Marker-Familie v2 (E-04-P1 GELANDET, LEDGER:3652): "Jede Zeile ([PLAN-TESTAT], [BILANZ-TESTAT],
  [PRUEF-BILANZ]) traegt die PFLICHTFELDER lane=, zelle= und fenster=; **der Aggregator-Schluessel ist
  das TUPEL (zelle, fenster) und NIEMALS die Zeilen-Reihenfolge** ... Die CEB-Ebene [a,b,c] steht im
  eigenen Feld ceb= ... Renderer-Single-Source: libs/cache_engine/builder/experiment_tree/slice_marker.hpp."
  → Damit ist die Parser-Schluessel-Regel fuer den kuenftigen Rueck-Leser bereits GESETZ.
- Env-Vertraege (LEDGER:3654): COMDARE_LANE (Planer sagt dem Treiber die Host-Lane, Sentinel "unbelegt",
  "die Zeile entfaellt nie") + COMDARE_HEARTBEAT_EVERY (Zaehl-Kadenz-Deckel, 5 gepinnte Zweige).
- Diagnostik-Regel (LEDGER:3656): "Im pruef_only-Lauf MUSS die [BILANZ-TESTAT]-Zeile gebaut_neu=0
  zeigen" (stille Lager-Skip-Negierung wird im Trace sichtbar).
- Weitere Testat-Arten am Ist: `[CEB-TESTAT] ... status=gebaut` (Audit synthese.md:7,
  director:769-781); `[PRUEF-TESTAT]` (ist-ceb.md:223, director:1177-1196); `[PMC-TESTAT] ts=...
  lane=<host> pmc=ok` (LEDGER:3502); `[FEHLER-TESTAT]` + Shell-Testate `[BATCH-BAU]/[BAU]/[TESTAT]`
  (ist-ceb.md:272-273: "mit `fenster=START:COUNT offen=…` — der 'Cursor' der Shell-Ebene");
  `[heartbeat]`-Zeilen "geflusht, zeit-+zaehl-gated" (ist-ceb.md:270-271, progress_heartbeat.hpp:42-98).
  Takeover-Testat: LEDGER:3626 "Nicht-Handeln bekommt eine eigene Testat-Zeile ('takeover-scope: N ...
  STEHEN GELASSEN'); 0-Fall schweigt."
- Batch-Job-Prinzip als Lese-Kontext (LEDGER:3314): "Job-Anzahl = O(konstant), NIE O(Binaries) ...
  Fortschritts-Granularitaet kommt aus dem Job-LOG (Fortschritts-Testate je Build ...) und dem
  Cache-Log, nicht aus der Job-Zahl."

## 5. progress.cursor — der Datei-Kanal

- ist-planer.md:64 (Audit): "Konsument: der Treiber selbst (main.cpp:1388-1428) — zeit-gedrosselte
  (30 s) geflushte `[progress]`-Zeilen nach stderr + additiv in `<output_dir>/progress.cursor` ...
  Es gibt KEINEN Code, der progress.cursor zurueck-liest (Vollgrep: einziger Schreiber/Nutzer ist
  main.cpp; Leser = Mensch/CI-Log)."
- synthese.md:103 (Atlas-L1 Kasten 5): "Rueck-Kanal: ProgressDelta (Voll-Konfig → mixed-radix-Deltas →
  done einmal) → stderr [progress] + progress.cursor + [heartbeat]/[CEB-TESTAT]/[PRUEF-TESTAT]-
  Testat-Grammatik; Konsument heute = CI-Log/Mensch (**gestrichelt: kuenftiger Planer-Rueck-Leser**)."

## 6. Messwert-Rueckschrieb-Pfade — WAS der Rueck-Leser liest

- synthese.md:106 (Atlas-L1 Kasten 8, IST verifiziert): "Rueckschrieb: result.csv+stamp (Resume/stale)
  → measure_out/<slug>/perm<idx> (EIN CSV je Zelle) → MeasurementSinkFn/measure-drop →
  messwert_registrierung → Bestandslog-measurement-XML (MinIO); **ausdruecklich NICHT ueber den
  Dock-Rueck-Kanal**." (SOLL-Deckung: §42.b "EIN CSV je Zelle" woertlich erfuellt, synthese.md:55.)
- Git-Persistenz-Pfad (memory project_mess_ergebnis_rueckschreibung...): "je Lauf/Commit ein NEUER
  datierter Unterordner `measurement/<YYYYMMDD-HHMMSS>/`" im super-Root, Trigger
  COMDARE_RUN_MEASURE+COMDARE_PERSIST_MEASUREMENTS, Write-Token id=54, Loop-Schutz dreifach.
- NAS-Ziel (Chunk-Delta D-04, memory project_20260726_chunk_delta...): "Binaries -> ccache/minio;
  Messergebnisse -> PR4100 Cluster_NFS Experiment-Ordner; lokaler Fussabdruck der Maschine gegen null."
- Bestandslog-Inkrement-Anker doc_revision (20260801-DOSSIERS-oe-a-c-e...:91): "doc_revision monoton
  als Basis des B2-Record-Union-Merge (fetch->merge->store)"; d.h. der Rueck-Leser kann Bestands-Stand
  monoton/inkrementell konsumieren. Beweis 4 (ebd.:116): doc_revision monoton + Merge verliert keinen
  Eintrag zweier Schreiber.
- Tier-Binary-Stand je Ast: complete-heuristik.log je Knoten ("Anzahl Binaries/Messwerte je Ast",
  20260801-KONSOLIDIERT...:76 LB-1) + Bestandslog-Reservierungen/ETA/avg_size/done (§62-B,
  LEDGER:3318ff) = die Quelle fuer "wie viele Rekombinationen noch offen sind" (E-04-Anforderung).

## 7. §62 Cache-Log/Claims als Rueck-Lese-Quelle

- memory project_62...: Cache-Log auf minio.comdare.de, LOCKBAR; Claims=Batch-Reservierung als
  VERSPRECHEN mit "zwingender Release-Pflicht + Fortschritts-Testat je Build bei Programm-Ende";
  ETA-Formel Σ t_i / N_threads, Takeover bei 1,5xETA ohne Update; Bestaende getrennt (Binary/Messwert,
  Factory Pattern, je eigenes Log + Stempel-Strategie, SHA512-Lookup std::map).
- LEDGER:3327 (Schreib-Lock-Semantik): Lock = kurze Schreib-Exklusivitaet ("z.B. auch, wenn das ETA
  errechnet werden soll"), endet spaetestens mit der ersten pro-forma-30-min-Reservierung.
- Der Planer selbst traegt einen eigenen Claim-Typ: planer_block (LEDGER:3626: "der Tier-Sweep laesst
  planer_block stehen"; Folge-Beobachtung: verfallene planer_block-Reservierungen haben keinen Reaper
  — "Folgewelle, sobald der Zweit-Planer-Konsument (profile_run_facade.hpp:248) real wird").

## 8. WIE soll der Planer konkret lesen + reporten? (Kern-Antwort der Lens)

Der Plan-Korpus legt DREI Mechanik-Ebenen fest — Polling-Daemon ist NIRGENDS spezifiziert:

1. **CLI-ON-DEMAND-AGGREGATOR (`--status`, spezifiziert, nicht gebaut):** Der User ruft den Planer;
   dieser LIEST die fragmentierten Zustands-Artefakte ZURUECK — progress.cursor, .version-Sidecars,
   per-Binary-result.csv-Stamps, minio-Teil-Marker, Bestandslog (deprecated-Audit:41/91). Ausgabe:
   %/ETA (setzt Fenster-Gesamtgroesse in ProgressDelta voraus — benannte Erweiterung) + JSON-Marker/
   Exit-Codes fuer Maschinenlesbarkeit (ebd.:96). Das ist die vom Owner freigegebene R3-Reihenfolge
   (LEDGER:3247) und passt exakt zur F7-Definition (lesen + User-Feedback, CEB eigenstaendig).
2. **CI-/Log-Parser-Ebene (Gesetz gelegt):** Marker-Familie v2 mit Aggregator-Schluessel
   (zelle, fenster)-TUPEL, nie Zeilen-Reihenfolge (LEDGER:3652); E-04-P2/P4 = Mess-Phase-Marker +
   Parser-Regeln (LEDGER:3686: "Mess-Phase hat noch KEINE Marker-v2-Zeile (E-04-P2/P4-Scope)").
3. **Live-Callback statt Datei-Polling (R1, bewusst DEFERRED nach Abgabe):** deprecated-Audit:70:
   "im Bare-Metal-/Ein-Host-Modus dlopen-t der Planer die CEB und erhält ProgressDelta + Snapshot-PODs
   als Callback **statt Datei-Polling** — das ermöglicht die Heuristik-/Hybrid-Schleife (Replan
   mid-run), die der emit→parse-Textzyklus strukturell nicht kann." R1-Status: KATALOG G.3/FAHRPLAN
   L18 = nach Abgabe; Audit synthese.md:86 "Ist-Vertrag = Textemission, im Code als bewusster
   Entscheid markiert".

Instrumentierungs-Gegenrichtung (Kontext #54, LEDGER:3315): "Die CEB PIPED die Shell-/Status-Ausgaben
an den PLANER weiter — der Planer ruft die emittete CEB auf und STEUERT sie: der Planer wird
aufgerufen, die CEB per XML-ANWEISUNG zu INSTRUMENTIEREN" (koppelt §38-Rueck-Kanal + R2; eigene
Bauwelle, nicht diese Lens).

---

## BEANTWORTET vs. WIRKLICH OFFEN

### BEANTWORTET (im Korpus belegt)
1. Gibt es einen Rueck-Kanal CEB→Planer? JA — §38-Cursor/Delta-Protokoll, sparse, mixed-radix, KEIN
   Mess-Daten-Rueckfluss (LEDGER:2364/2368; IST konform, synthese.md:56).
2. Was ist das Fertig-Signal? done=true GENAU EINMAL am Fensterende der ProgressDelta-Folge
   (ist-planer.md:62); Zweck: §38.b-Sequenzierung "naechste CEB erst nach Abschluss" (LEDGER:2376),
   seit §61 PRO Maschine (LEDGER:3274).
3. Soll der Planer rueck-lesen? JA — Owner F7 05.08. verbatim (LEDGER:4031/4032): Messwerte + Stand
   der Tier-Binaries lesen, User-Feedback geben, CEB eigenstaendig; Planer = eigene Binary (F1-GO).
4. WAS liest er? (a) Messwerte: result.csv/measure_out je Zelle, Bestandslog-measurement-XML (MinIO,
   doc_revision monoton), measurement/<ts>/ (git), NAS PR4100 (synthese.md:106; memories). (b) Bau-/
   Tier-Stand: progress.cursor, .version-Sidecars, CSV-Stamps, Bestandslog-Reservierungen/ETA/avg_size/
   done, complete-heuristik.log, Testat-Zeilen (deprecated-Audit:91; LEDGER:3318ff; KONSOLIDIERT:76).
5. WIE (Mechanik)? CLI-on-demand `--status`-Aggregator + %/ETA/JSON-Marker (freigegebene Reihenfolge
   LEDGER:3247, Spezifikation deprecated-Audit:41); Log-Parser-Schluessel = (zelle,fenster)-Tupel
   (LEDGER:3652); Live-Callback per .so statt Datei-Polling = R1, bewusst nach Abgabe (Audit:86,
   deprecated-Audit:70). Ein residenter Watch-Daemon ist nirgends dekretiert.
6. Testat-Grammatik? Vollstaendig spezifiziert und ebenen-richtig ([TESTAT] Stufe-2/3-Formen
   LEDGER:3414-3415; Marker-v2 [PLAN-TESTAT]/[BILANZ-TESTAT]/[PRUEF-BILANZ] Pflichtfelder
   lane=/zelle=/fenster=/ceb= LEDGER:3652; [CEB-TESTAT]/[PRUEF-TESTAT]/[PMC-TESTAT]/[heartbeat] am
   Ist verifiziert, Audit).
7. Traegt der Rueck-Kanal Messdaten? NEIN, nie — Messwert-Rueckschrieb ist CEB-SELBST-Schreiber an
   CSV/Bestandslog, "ausdruecklich NICHT ueber den Dock-Rueck-Kanal" (synthese.md:106, LEDGER:2368).

### WIRKLICH OFFEN (kein Korpus-Beleg entscheidet)
1. Name/Form des Status-Kommandos in der NEUEN Planer-Binary: die heutige clig.dev-Grammatik
   (validate|plan|tier|cache-key|fingerprint|run|version|help, synthese.md:99) enthaelt KEIN
   status-Subkommando; "--status-Aggregator" ist Spezifikation, nicht Benennung/Bau.
2. Lese-Kadenz des Rueck-Lesers (einmalig on-demand vs. follow/watch-Modus waehrend eines Laufs)
   ist nirgends festgelegt; nur die .so-Callback-Alternative ist als R1-Post-Abgabe markiert.
3. Kanonischer Lese-Pfad fuer Messwerte (measure_out-CSV direkt vs. Bestandslog-measurement-XML via
   doc_revision vs. measurement/<ts>/ im git) — alle drei existieren; keine Festlegung, welcher fuer
   das User-Feedback autoritativ ist.
4. §38.b-Takt-Frage (Audit-Rueckfrage 7, synthese.md:119): F7 beantwortet den RUECK-LESER (JA) und
   sagt "CEB laeuft eigenstaendig" — ob die resource_group-Sequentialisierung damit DAUERHAFT als
   §38.b-Traeger ratifiziert ist oder der Planer kuenftig selbst takten muss, ist nicht woertlich
   entschieden (Lesart "eigenstaendig" spricht fuer resource_group-Verbleib; als Auslegung markieren).
5. %/ETA setzt "Fenster-Gesamtgroesse in ProgressDelta" voraus (deprecated-Audit:41/92) — geplante,
   noch nicht gebaute Draht-Erweiterung (Wire-Form offen).
6. E-04-P2/P4-Zuordnungsreste: Mess-Phase ohne Marker-v2-Zeile; unbedingte [TESTAT]-Shell-Zeile nach
   [FEHLER-TESTAT] "P1-Nachzug oder P4-Parser-Regel" (LEDGER:3686) — zugeordnet, unentschieden.
7. Terminierungs-Kollision: FAHRPLAN L18 (03.08.) heftet R3-Reste an Phase 5/6; Owner F1/F7 (05.08.,
   spaeter) machen Split+Rueck-Leser zur Vor-Abgabe-Pflicht — welcher R3-Rest-Umfang (print-env,
   JSON-Marker, Stufe-1→2-Kommando) in die Vor-Abgabe-Welle W1 faellt, muss der Manager schneiden.
8. planer_block-Reaper fehlt (LEDGER:3626) — wird akut, sobald der "Zweit-Planer-Konsument
   (profile_run_facade.hpp:248) real wird", also genau mit dem Rueck-Leser.
