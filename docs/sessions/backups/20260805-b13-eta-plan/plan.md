# PLAN B13 -- L18-ETA-Teilmenge + CI-Steuerbarkeit + Experiment-Start CLI/Shell mit/ohne head (headless)

Planungs-Stand 05.08.2026 (READ-ONLY-Vorlauf). IST-Anker: ce b4110cd0 in /home/comdare/wt-b13-eta.
BAU IST GATED: erst nach Landung der laufenden W5/W3-Nachbesserung (wf_a870c885, wt-e24, Branch
w5-w3-kern -- NICHT betreten); Branch `b13-eta-headless` wird dann NEU ab dem NEUEN dev-Stand
aufgesetzt (NIE rebase; Kanon "nie rebase, immer merge" -- hier: frischer Branch ab dev, dieser Plan
wird an den gelandeten W5-Dateien RE-ANKERT, siehe Abschnitt (f) und Risiko R2).

---

## (a) SOLL aus dem Korpus (Zitate mit Fundstellen)

### a.1 Owner-Entscheid (bindender Auftrag)

LEDGER:4209 (abend-5, F4/B13 VERBATIM): "Das hoert sich gut an. Ich will sie bitte vor dem Trigger
haben, exakt so sauber wie moeglich. Gerne vorziehen, um die Steuerung durch die CI zu ermoeglichen
und Experimente durch CLI bzw. Shell Aufruf mit oder ohne head / headless zu starten."
LEDGER:4210 (Entscheid-Konsequenz 4): "B13 VORGEZOGEN vor Trigger, exakt sauber, ERWEITERT um:
CI-Steuerbarkeit + Experiment-Start per CLI/Shell MIT ODER OHNE head (headless-Faehigkeit)."

### a.2 FAHRPLAN-L18 (Heftung) + FUND 7 (Sweep)

FAHRPLAN 20260803 (docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:67): "PHASE 5/6 +=
L18: Post-v3 R1 (.so-ABI Planer<->CEB) = nach Abgabe (KATALOG G.3); R3-CLI-Reste (--print-env,
--status-Aggregator, ETA/JSON-Marker) an Phase-5-ETA + Phase-6-E-04 anheften."
Sweep-FUND 7 (backups/20260805-liegengeblieben-sweep/docs.md:97-105): "Der gelandete/laufende
W5-Kern deckt nur die Zell-/Fenster-Bilanz ... der an den Do-07.08.-Trigger-Schritt 'ETA' geheftete
Teil (ETA-/JSON-Marker, --print-env) aktuell in KEINEM Vor-Trigger-Plan." => B13 nimmt genau diese
Teilmenge auf (Owner F4 = Aufnahme statt Herabstufung). R1/.so bleibt nach Abgabe (NICHT B13).

### a.3 R3-Kernsatz + freigegebene Reihenfolge (Sec 60)

LEDGER:3244 (Sec 60-R3): "Fuer Bauen/emit (CEB aus Planer, Tier-Binary aus CEB) und die Ueberwachung
der Tier-Builds soll der Planer als CLI ausgerichtet sein, auf der Shell mit umgaenglichem
User-Interface steuerbar; der Planer soll Zustand/Builds/Messungen der CEB und der Tier-Binaries
LOGGEN ... Der User will das Programm spaeter manuell mit der XML-Config fahren koennen."
LEDGER:3251 (Sec 60-NACHTRAG, Owner "Ich stimme der Post-v3-Reihenfolge voll zu. GO"): "1.
CLI-Haertung (R3: run <xml>/--profile + --help-offizieller-Weg + --print-env -> --status-Aggregator
-> %/ETA/JSON-Marker -> lokales Stufe-1->2-Kommando) -> 2. Fork-A-.so-Schnitt ...".
Deprecated-Audit (docs/sessions/2026-07-20-SESSION-DEPRECATED-AUDIT-...md, R3-Absatz): fehlend u.a.
"~16 Env-Vars ohne CLI-Aequivalent/--print-env, kein Kommando faehrt Stufe 1->2 lokal durch (nur
Kommentar-Choreografie), keine maschinenlesbaren Marker (JSON/Exit-Codes)"; Spezifikation (ebd.
Reihenfolge-1): "Fenster-Gesamtgroesse in ProgressDelta (%, ETA) + JSON-Marker".
=> B13 = Reihenfolge-Schritt 1 OHNE --status-Aggregator-Neubau (den liefert W5) und MIT dem
Stufe-1->2-Kommando (das IST der Owner-geforderte Experiment-Start per CLI/Shell).

### a.4 Sec-62-A CLI-Warnungs-Semantik (bindend fuer start/CI-Job)

LEDGER:3310 (Sec 62-A): "Der PLANER ist ANSPRUCHSLOS: er muss auf JEDER Maschine bauen koennen und
misst alles Verfuegbare, was die XML verlangt. ... Verlangt die XML Achsen, die physisch als
System-Achsen-Algorithmen nicht existieren (z.B. AVX512-Flags), schreibt der Planer WARNUNGEN ins
Log bzw. auf die spaetere CLI-Shell (R3/#34) -- kein Vorfilter, keine stille Auslassung."
=> start/CI-Job filtert NICHTS vor; Nicht-Verfuegbares wird als WARNUNG-Zeile (und JSON-Marker)
emittiert, der Lauf faehrt das Verfuegbare.

### a.5 Marker-v2-Grammatik + Testat-Zeilen (Gesetz; B13 nur ADDITIV)

LEDGER:3656 (Sec 68c-NACHTRAG): "Jede Zeile ([PLAN-TESTAT], [BILANZ-TESTAT], [PRUEF-BILANZ]) traegt
die PFLICHTFELDER lane=, zelle= und fenster=; der Aggregator-Schluessel ist das TUPEL (zelle,
fenster) und NIEMALS die Zeilen-Reihenfolge ... Die CEB-Ebene [a,b,c] steht im eigenen Feld ceb= ...
Renderer-Single-Source: libs/cache_engine/builder/experiment_tree/slice_marker.hpp. KOMMIT-REGEL
(HART kodifiziert): Emissions-Aenderung und Neu-Einfrieren der zugehoerigen Test-Pins gehoeren in
DENSELBEN Commit."
Weitere Testat-Arten am Ist (f7-rueck-leser-feedback.md:114-119): "[CEB-TESTAT] ... status=gebaut"
(director :853), "[PRUEF-TESTAT]" (:1278), "[PMC-TESTAT]", "[FEHLER-TESTAT]" + Shell-Testate
"[BATCH-BAU]/[BAU]/[TESTAT]", "[heartbeat]-Zeilen geflusht, zeit-+zaehl-gated".
[progress]-Schreiber (super Code/02_messung_driver/main.cpp:1155-1195): Zeilenformen exakt
"[progress] perm=<N> axes_changed=<K> <axis>-><variant> ..." und "[progress] done perm=<N>
window-complete"; additiv nach <output_dir>/progress.cursor.
Env-Vertraege (LEDGER:3658): COMDARE_LANE (Sentinel "unbelegt", Zeile entfaellt nie) +
COMDARE_HEARTBEAT_EVERY (5 gepinnte Zweige, tests/unit/test_progress_heartbeat.cpp).

### a.6 W5-status-Design (Basis, auf der B13 aufsetzt) + laufender Nachbesserungs-Stand

Quelle: super docs/sessions/backups/20260805-w5-w3-kern/plan.md (NUR Ledger/Backups gelesen, wt-e24
NICHT betreten). Kern: `comdare-experiment-planner status [<profil>] [--root=<dir>]` am
W5-ANDOCKPUNKT main.cpp:352-354; 4 Quellen (progress.cursor / result.csv+stamp+stale /
Bestandslog-XML on-demand / .fingerprint-Sidecars); Ausgabe-Zeilen [status], [status-zelle],
[status-cursor], [status-bestand], [status-gesamt], je fehlender Quelle GENAU EINE ehrliche
"keine Daten"-Zeile; Exit 0 Bericht / 1 Usage / 2 Konfig; KEIN watch/Daemon; ETA-Felder des
Bestandslogs "leer = noch nicht geschaetzt -- ehrlich benennen" (plan.md:92). Takt-Leitplanke
(a.4 des W5-Plans): Leser-je-Quelle -> Aggregator -> Renderer strikt geschichtet.
NACHBESSERUNGS-STAND (LEDGER:4121/4123 nachmittag-10 + :4232): Codex-BEFUNDE:9 (H1 fensterfremde
Erhebung main.cpp:336; H2 Gesamtzeilen-Bilanz planner_status_reader:393; M done-sticky
cursor_reader:96, Fragment-Validierung :108, Scan-Bound :174, Transport-rc main.cpp:322,
W3-tier_reset :183; N Null-POD-Proben, <utility>-Include) -- "NACHBESSERUNGS-WELLE wf_a870c885
LAEUFT in wt-e24 (Fix + Dual-Zweitblick)". => W5-Zeilenanker sind BEWEGLICH bis zur Landung.

### a.7 headless-Kanon im Korpus

Vollgrep Ledger+docs: es existiert KEINE aeltere 'head/headless'-Vorplanung -- der EINZIGE Beleg ist
der Owner-Entscheid abend-5 (a.1). Als Vorbilder gelten die belegten Muster: (1) MANUAL_RUN-
Choreografie super MANUAL_RUN.md:122-195 (plan cmake -> CMakeLists-Wrapper -> cmake -S/-B mit
COMDARE_PLAN_DRIVER/_PROFILE/_RANGE/_OUT -> Targets comdare_ceb_emit__all_ /
comdare_tier_batch_<host> / comdare_tier_measure_<host>) = der offizielle CMake-Weg der Stufen 1->2;
(2) env-gated Lauf-Modi COMDARE_GOLDEN_N_PROVISION_ONLY / COMDARE_PRUEF_ONLY (director:1264-1270,
profile_run_facade.hpp:64-65) = Praezedenz "Verhalten per Env, eine Binary"; (3) Nie-stumm-Doktrin
(LEDGER:3320 Log-Flush/Heartbeat) = der headless-Log-Vertrag existiert der Sache nach schon.

### a.8 headless PRAEZISE DEFINIERT (B13-Vertrag)

- **headless (OHNE head)** = Lauf OHNE TTY-Annahme: (1) KEINE interaktive/kosmetische Ausgabe --
  ausschliesslich die maschinenlesbaren Kanaele (Testat-/Marker-v2-/JSON-Zeilen + geflushte
  [heartbeat]/[progress]-Zeilen nach stderr, Daten nach stdout); (2) EXIT-CODE-VERTRAG dokumentiert
  und stabil: 0 Erfolg | 1 Usage/Emission abgebrochen | 2 Konfig-Fehler | 5 unbekannte Profil-Wurzel
  | 6 Bestandslog-Gate-Abbruch (bestehende Planer-Legende main.cpp:329-331, unveraendert) + start
  propagiert den Exit-Code der ERSTEN scheiternden Stufe unveraendert und benennt die Stufe in einer
  [START-TESTAT]-Zeile; (3) blockiert NIE auf stdin, fragt NIE interaktiv nach; (4) damit direkt
  CI-JOB-AUFRUFBAR (GitLab-Job = kein TTY) und nohup-/setsid-tauglich auf der Shell.
- **MIT head** = zusaetzlich interaktive Mensch-Ausgabe auf stderr: pct=/eta_s=-Anzeigen je
  Fortschrittszeile (C2) und eine lesbare Stufen-Zusammenfassung; KEINE Cursor-Steuerung/keine
  ncurses (kein neues Programm-Paradigma vor dem Trigger) -- "head" ist die ANGEREICHERTE, fuer
  Menschen gedachte Zeilen-Ausgabe, headless die nackte Marker-Wahrheit. Auto-Default: isatty(2)
  => head, sonst headless; explizite Flags --head/--headless uebersteuern in beide Richtungen
  (CI kann also bewusst --head-Zeilen in den Trace holen -- die Marker bleiben in BEIDEN Modi
  identisch, head fuegt NUR hinzu, laesst nie weg).

---

## (b) IST-Andockpunkte am Stand b4110cd0 (/home/comdare/wt-b13-eta, verifiziert)

1. **apps/experiment_planner/main.cpp** (417 Zeilen): flacher Dispatcher, W5-ANDOCKPUNKT-Kommentar
   :352-354 ("das kuenftige status-Subkommando haengt sich hier additiv als weiterer if-Zweig ein");
   Subcommands validate|plan dump/ci/cmake|cache-key|fingerprint|version|help; Exit-Legende
   :329-331; resolve_profile :336-340; planer_block-Gate :78-123 (with_object_budget(1,10));
   run_*_guarded-noexcept-Mantel-Muster :136-167.
2. **libs/cache_engine/profile_facade/planner/planner_cli_env.hpp** (91 Zeilen): env_trimmed :44,
   GoldenRange/parse_golden_range_env :52-72 (wirft bei Fehlform), parse_size_env_strict :78.
   W1-Hoist-Blaupause: Fassaden-Header, von der App inkludiert, testbar ohne Binary.
3. **Emissions-Stellen (JSON-Marker-Traeger):**
   - slice_marker.hpp (110 Zeilen): Single-Source der v2-Familie; Marken :33-35, Tee-Filter-Liste
     kSliceMarkerTraceMarken :39-40, kMarkerUnbelegt :44, marker_wert :52-62, marker_fenster
     :69-71, MarkerKontext :77-81, marker_kopf :90-108.
   - cache_engine_builder_iterator.hpp: 5 marker_kopf-Aufrufer :1129 ([PLAN-TESTAT] bau), :1159
     ([BILANZ-TESTAT] bau), :1401/:1418 (Fallback-Paar), :1596 ([PRUEF-BILANZ] pruef);
     fire_progress/fire_progress_done :1467/:1473, Feuerstellen :1546-1547/:1602-1603/:2050.
   - experiment_plan_director.hpp (2092 Zeilen): [CEB-TESTAT] :853 (status=gebaut, ceb=<legend>);
     Tee-Filter der Stufe-2-Emission :1131 ("grep --line-buffered -F -e '[heartbeat]'" + v2-Marken
     :1125); [BATCH-BAU] :1223, [FEHLER-TESTAT] :1252/:1275/:1428, [PRUEF-TESTAT] :1278;
     bare-metal-Emission emit_batch_targets :1651-1720 (vier Treiber-COMMANDs, COMDARE_LANE je
     COMMAND, COMDARE_PLAN_*-Variablen).
   - progress_heartbeat.hpp (100 Zeilen): heartbeat_every_n :32-41 (COMDARE_HEARTBEAT_EVERY,
     5 gepinnte Zweige), Zeilenform "[heartbeat] <phase> <done>/<total> t+<s>s" -- total ist
     VORHANDEN, % ist hier bereits ableitbar.
4. **progress.cursor-Kette:** ProgressDelta-POD progress_delta.hpp:33-38 (cursor/changed/done --
   KEINE Fenster-Gesamtgroesse => %-Luecke exakt wie im deprecated-Audit benannt);
   compute_progress_deltas/reconstruct_configs :63-93 (TU test_progress_delta.cpp); Schreiber super
   Code/02_messung_driver/main.cpp:1155-1195 (30s-Drossel, stderr+cursor-Datei, done immer).
5. **Env-Inventar fuer --print-env** (Vollgrep ce libs/apps + super Treiber-main): 42 gelesene
   COMDARE_*-Variablen (u.a. THESIS_PROFILE, GOLDEN_N_RANGE, GN_OPT/GN_SIMD, MEASUREMENT_COMBO,
   BUILD_TYPE/BUILD_VERSION/BUILD_PARALLEL, LANE via Emission, HEARTBEAT_EVERY, BESTANDSLOG+3,
   MINIO_ENDPOINT/BUCKET/PREFIX, ARTEFAKT_*-Budgets, MC_*/CURL_BIN/TIMEOUT_BIN, NFS_DROP_USER/
   NFS_DROP_TOKEN, PRUEF_ONLY/PRUNE_ONLY/GOLDEN_N_PROVISION_ONLY, PLATFORM, E4_CAP, MIN_FREE_GB,
   WORKLOAD_RECORDS, LEGACY_MESSREIHEN, ...). SECRET-KLASSE darunter: COMDARE_NFS_DROP_TOKEN +
   etwaige minio-Credentials => --print-env druckt fuer Secret-Eintraege NUR gesetzt/leer, NIE den
   Wert (Redaktions-Pflicht, siehe C1).
6. **CI-Aufrufbarkeit heute:** super .gitlab-ci.yml ruft die Planer-Binary bereits (Visibility-Job
   :365-374); Mess-Trigger laufen als web/api/pipeline/trigger-Quellen (:93-94); es gibt KEINEN
   manuellen "Experiment-Start"-Job mit durchgereichten COMDARE_*-Variablen => Luecke, die die
   Owner-Forderung "Steuerung durch die CI" schliesst (C5).

---

## (c) AENDERUNGS-PLAN je datei:zeile (auf dem ERWARTETEN Nach-W5/W3-Stand; W5-Anker deklariert
beweglich, Re-Anker-Pflicht nach Landung)

### C1 -- `print-env` (Subkommando + Katalog-Single-Source)

- NEU `libs/cache_engine/profile_facade/planner/planner_env_katalog.hpp`: EINE constexpr-Tabelle
  aller vom Planer/Treiber/Transport gelesenen COMDARE_*-Variablen: {name, zweck (ASCII-Kurzsatz),
  konsument (planer|ceb|transport|beide), secret (bool)}. Render-Funktion
  `print_env_report(std::ostream&)`: je Eintrag EINE Zeile
  `[env] name=<N> gesetzt=ja|nein wert=<v|REDACTED|leer> zweck=<...>` (clig.dev: Daten nach stdout);
  Secret-Eintraege IMMER wert=REDACTED. Grundlage: Vollgrep-Inventar (b)-5; die Tabelle traegt einen
  BINDENDEN grep-Wartungs-Kommentar (Muster algo_semver.hpp-Naht-Liste: grep-Anweisung statt
  Handpflege).
- `apps/experiment_planner/main.cpp`: neuer if-Zweig `print-env` (+ Alias `--print-env`) am flachen
  Dispatcher (nach dem gelandeten status-Zweig), `help_for("print-env")` + eine Uebersichts-Zeile
  (:315-323-Block) -- Exit 0, rein lesend, KEIN planer_block.
- Treiber-Paritaet (super Code/02_messung_driver/main.cpp): derselbe Fassaden-Aufruf als
  `print-env`-Subkommando im Treiber-Dispatcher (:353ff-Umfeld) -- 5-Zeilen-Host-Anteil, Substanz
  liegt im ce-Header (W1-Hoist-Muster). Eigener super-Commit (Cross-Repo-Schnitt wie W1).
- TU NEU `tests/unit/test_b13_env_katalog.cpp`: (i) Katalog-Vollstaendigkeits-Orakel -- die im Test
  einge-includeten bekannten Namen (statische Liste der TU) sind Teilmenge des Katalogs UND der
  Katalog hat keine Doppel-Namen; (ii) Secret-Redaktion: gesetzte Secret-Var erscheint NIE als
  Klartext im Report (String-Suche ueber den gerenderten Report); (iii) gesetzt/leer/ungesetzt-
  Dreifall je Nicht-Secret.

### C2 -- %/ETA-Anzeigen (Fenster-Gesamtgroesse in ProgressDelta + Renderer)

- `libs/cache_engine/builder/experiment_tree/progress_delta.hpp:33-38`: ProgressDelta ADDITIV um
  `std::size_t fenster_gesamt = 0;` (0 = unbekannt => Renderer laesst pct/eta weg -- Alt-Verhalten
  byte-identisch; POD ist in-process-Naht, KEIN abi/-Beruehrpunkt). progress_delta_between/
  compute_progress_deltas :50-77 erhalten den Gesamt-Parameter (Default 0 => bestehende Aufrufer
  unveraendert uebersetzbar); reconstruct_configs unveraendert.
- `cache_engine_builder_iterator.hpp:1467-1473`: fire_progress/fire_progress_done belegen
  fenster_gesamt aus der am Aufrufort bekannten Fenster-Groesse (builds.size() +
  bestand_lager_skips an :1547 bzw. builds.size() an :1603/:2050 -- exakt die Werte, die heute
  schon an fire_progress_done gehen; KEINE neue Zaehlung, dieselbe Quelle).
- super `Code/02_messung_driver/main.cpp:1185-1194` (Sink-Renderer): traegt d.fenster_gesamt > 0 =>
  Zeilen-Suffix ` pct=<ganzzahl>% eta_s=<s>` (ETA sink-seitig aus eigener Startzeit:
  elapsed*(gesamt-cursor)/max(cursor,1) -- KEINE neuen POD-Zeitfelder); Suffix ADDITIV am
  Zeilen-ENDE in stderr UND progress.cursor (eine Zeile, einmal komponiert :1186).
- `progress_heartbeat.hpp` (Zeilen-Renderer der [heartbeat]-Zeile): additives Suffix ` eta+<s>s`
  aus vorhandenem done/total+elapsed (total ist da); Zeilen-PRAEFIX unveraendert.
- LESER-NACHZUG IM SELBEN ce-COMMIT (KOMMIT-REGEL LEDGER:3656): der gelandete W5-
  `progress_cursor_reader.hpp` (Literal-Pins beider [progress]-Formen) wird um die Suffix-Toleranz
  erweitert (Praefix-Parse bleibt identisch; alte Zeilen OHNE Suffix bleiben gueltig -- der Bestand
  in existierenden cursor-Dateien ist Alt-Format); W5-TU-Pins (test_w5_status_reader.cpp) +
  test_progress_delta.cpp + test_progress_heartbeat.cpp im selben Commit neu eingefroren.
  Cross-Repo-Folge: ce-Leser MUSS BEIDE Formen koennen, BEVOR der super-Schreiber das Suffix
  emittiert => Commit-Ordnung C2a (ce: POD+Iterator+Leser+Pins) VOR C2b (super: Sink-Suffix).
- `planner_status_reader.hpp` (W5, nach Landung): [status-zelle]/[status-gesamt] erhalten additiv
  ` eta_s=<s|unbelegt>` -- Quelle NUR ehrliche Daten: Bestandslog-ETA-Feld falls belegt, sonst
  Hochrechnung aus stamp-mtime-Spanne der gemessenen Binaries je Zelle; ohne Datenbasis =>
  Sentinel `unbelegt` (kMarkerUnbelegt-Doktrin, W5-plan.md:92-93 "ehrlich benennen").

### C3 -- maschinenlesbare JSON-Marker im Log (additiv, v2-Grammatik UNBERUEHRT)

- C3a (Treiber-Seite): `slice_marker.hpp` NEU `marker_json(...)`: rendert je Testat EINE Zeile
  `[MARKER-JSON] {"marke":"<MARKE>","ts":"...","lane":"...","zelle":"...","ceb":"...",
  "phase":"...","fenster":"<b:c>",<zaehler-paare>}` -- dieselben Feld-WERTE wie marker_kopf
  (Single-Source: beide Renderer teilen die marker_wert-Saeuberung + eine gemeinsame Feldliste;
  JSON-Escaping minimal: nach marker_wert sind nur druckbare ASCII ohne '"'/'\\' noetig --
  beide zusaetzlich gefaltet). Neue Marke in die Tee-Filter-Liste: kSliceMarkerTraceMarken :39-40
  um "MARKER-JSON" erweitert (Single-Source zieht den Emissions-Filter :1131 automatisch mit).
  Emission: an den 5 Aufruf-Stellen des Iterators (:1129/:1159/:1401/:1418/:1596) je EINE
  JSON-Zeile DIREKT NACH der v2-Zeile (v2-Zeile byte-identisch davor). SELBER COMMIT: Pins in
  test_e04_slice_marker.cpp neu eingefroren + TU NEU test_b13_marker_json.cpp (Feld-Paritaets-
  Orakel: geparste JSON-Felder == geparste kv-Felder derselben Emission; Escaping-Negativproben;
  Anti-Leerlauf: mindestens 1 Zaehler-Paar je Marke).
- C3b (Emissions-Seite/Shell-Testate): experiment_plan_director.hpp -- JSON-Spiegel-echo-Zeile
  additiv nach [CEB-TESTAT] :853 (`{"marke":"CEB-TESTAT","ceb":...,"status":"gebaut","ts":...}`)
  und nach [FEHLER-TESTAT]/[PRUEF-TESTAT] :1252/:1275/:1278/:1428 (Stufe-2-YAML) -- der
  Status-Rueckfluss der Kette (f6-54-xml-anweisung.md:84 "Status-Rueckfluss = [CEB-TESTAT]-Zeilen")
  wird damit maschinenlesbar. SELBER COMMIT: Emissions-Pins der Director-TU
  (test_experiment_plan_director.cpp) neu eingefroren. bare-metal-Emission (:1676ff) bewusst OHNE
  JSON-Spiegel (Ein-Fenster-Weg, Kommentar-Wahrheit :1648-1650 "keine erfundene Fenster-Zahl").

### C4 -- `start`: Experiment-Start per CLI/Shell mit/ohne head (das Stufe-1->2-Kommando)

- NEU `libs/cache_engine/profile_facade/planner/planner_start_kommando.hpp`: PURE Kommando-Planung
  (testbar ohne Prozess-Start): aus (profil, workdir, range, lane, head|headless, dry_run) die
  deterministische Stufen-Liste als POD-Folge {stufe, argv-Vektor, env-Paare} -- EXAKT die
  MANUAL_RUN-Choreografie super MANUAL_RUN.md:122-195 (Stufe 1: plan cmake > workdir/
  experiment_plan.cmake + CMakeLists-Wrapper :141; cmake -S/-B mit COMDARE_PLAN_DRIVER/_PROFILE/
  _RANGE/_OUT :142/:155-156; Stufe 2: cmake --build --target comdare_tier_batch_<host> :172; Messung
  comdare_tier_measure_<host> :195 NUR mit explizitem --mit-messung, Default = Bau+Pruef OHNE
  Messung -- Messung bleibt USER-GO-STOPP-gedeckt, LEDGER:4185 "Phase 6 MESSUNG = USER-GO-STOPP").
  KEIN neues XML-Programm, KEIN Behelfsweg: der offizielle CMake-Weg wird AUFGERUFEN, nicht ersetzt
  (NUR-EIN-XML-Programm- + offizieller-Weg-Doktrin).
- `apps/experiment_planner/main.cpp`: neuer Zweig
  `start [<profil>] [--workdir=<dir>] [--range=<start:count>] [--head|--headless] [--dry-run]
  [--mit-messung]` im run_*_guarded-Mantel; Ablauf: validate-Aufruf (rc!=0 => Abbruch mit dessen
  rc) -> planer_block-Gate (exit 6-Semantik unveraendert, :78-123) -> Stufen-Liste ausfuehren
  (std::system je COMMAND ist TABU -- POSIX fork/exec ueber EINEN kleinen Prozess-Runner im
  Host-Anteil; Exit-Code der ersten scheiternden Stufe wird UNVERAENDERT propagiert); je Stufe
  [START-TESTAT]-Zeile `[START-TESTAT] ts=... stufe=<n>/<m> kommando=<name> rc=<rc>` + JSON-Spiegel
  (C3-Renderer). head/headless per a.8: isatty(STDERR_FILENO)-Default + Flag-Override; headless
  unterdrueckt NUR die head-Zusatzzeilen. Sec-62-A-Warnungen (a.4) laufen als [START-TESTAT]-
  WARNUNG-Zeilen mit, nie als Vorfilter. --dry-run druckt die Stufen-Liste nach stdout und endet 0.
- MANUAL_RUN (ce MANUAL_RUN.md + super MANUAL_RUN.md): neuer Abschnitt "Ein-Kommando-Start
  (start, mit/ohne head)" -- ersetzt NICHT die dokumentierte Choreografie, verweist auf sie als
  Langform.
- TU NEU `tests/unit/test_b13_start_kommando.cpp`: (i) Stufen-Liste deterministisch (2 Laeufe
  byte-gleich); (ii) Default OHNE Mess-Stufe, --mit-messung fuegt exakt das measure-Target an;
  (iii) head/headless-Aufloesung (Flag schlaegt isatty-Probe; beide Modi liefern identische
  Marker-Stufenliste); (iv) --dry-run-Format-Pin; (v) range-Fehlform => Konfig-Fehler-Klasse
  (parse_golden_range_env-Wurf-Muster). Gate-Rauchtest LITERAL am gebauten Binary:
  `start --dry-run` + `start --headless --dry-run` + `start --help` zitiert.

### C5 -- CI-Steuerbarkeit (super-Einheit)

- super `.gitlab-ci.yml`: NEU Job `experiment:start` -- `when: manual` + NUR web/api-Quellen
  (:93-94-Muster), Variablen-Durchreiche COMDARE_THESIS_PROFILE/COMDARE_GOLDEN_N_RANGE/
  COMDARE_MEASUREMENT_COMBO/COMDARE_LANE (+ Bestandslog-Trio optional), Script = Planer-Binary
  bauen (bestehendes Muster Visibility-Job :365-374) + `comdare-experiment-planner start
  --headless --workdir="$CI_PROJECT_DIR/start_out" ...`; Artefakte: start_out/**-Logs +
  progress.cursor. resource_group ceb-measurement-exclusive uebernehmen (Sequenzierungs-Kanon);
  Job OHNE Mess-Stufe (Default) -- ein Mess-Start bleibt Owner-GO (eigene Variable
  COMDARE_START_MIT_MESSUNG="true" dokumentiert, Default leer). KEINE Aenderung an bestehenden
  Trigger-/Bridge-Jobs; 286er-Regel unberuehrt (kein Poll-Loop im Job).
- Doku: super MANUAL_RUN.md-Verweis "derselbe start-Vertrag, headless, via CI-Job" (Dual-Weg
  Sec 61: bare-metal und CI fahren DENSELBEN Kommando-Planer).

---

## (d) TU-DESIGN (Zusammenfassung; alle neu = additive Flaechen-TUs, ctest-registriert)

1. test_b13_env_katalog.cpp -- Katalog/Redaktion/Dreifall (C1). Kein Netz, keine Secrets im Repo.
2. test_b13_marker_json.cpp -- kv/JSON-Feld-Paritaet + Escaping + Anti-Leerlauf (C3a).
3. test_b13_start_kommando.cpp -- Kommando-Planung pur, dry-run-Pins, head/headless (C4).
4. RE-FREEZES im selben Commit wie ihre Emission (KOMMIT-REGEL): test_progress_delta.cpp +
   test_progress_heartbeat.cpp + test_w5_status_reader.cpp (C2a) · test_e04_slice_marker.cpp (C3a)
   · test_experiment_plan_director.cpp-Emissions-Pins (C3b).
5. Gate je Commit (unveraendert vom W5-Muster): Voll-Bau + 2x voll-ctest SERIELL (frisches
   Configure am Commit-Objekt, N literal -- N ist lebendes Gate, +3 TUs verschieben es) + golden
   3/3 + Roundtrip + Fingerprint-Neutralitaet (abi/ 0 Zeilen, Frozen-Vektor, golden-CRC,
   golden-320) + cf22 + 3-Marker 0 + ASCII aus dem Diff + Rauchtests literal (print-env,
   start --dry-run, status). Alle B13-Aenderungen sind stderr-/Emissions-/App-Flaeche =>
   golden-/binary_id-/abi-NEUTRAL per Konstruktion; die Emissions-Pins beweisen es je Commit.

## (e) COMMIT-SCHNITT (Reihenfolge = freigegebene R3-Reihenfolge, LEDGER:3251)

- **C1** ce: print-env (Katalog-Header + main.cpp-Zweig + TU + help + MANUAL_RUN-Notiz).
- **C1s** super: Treiber-print-env-Paritaet (5-Zeilen-Host) -- nach C1-Landung im ce-Gitlink.
- **C2a** ce: ProgressDelta.fenster_gesamt + Iterator-Befuellung + heartbeat-eta +
  cursor_reader-Suffix-Toleranz + status-eta + ALLE Re-Freezes (EIN Commit).
- **C2b** super: Sink-Renderer pct=/eta_s= (erst nach C2a-Landung -- Leser kann beide Formen).
- **C3a** ce: marker_json + 5 Iterator-Emissionen + Tee-Filter + Pins (EIN Commit).
- **C3b** ce: Director-JSON-Spiegel ([CEB-TESTAT]/[FEHLER-TESTAT]/[PRUEF-TESTAT]) + Emissions-Pins.
- **C4** ce: planner_start_kommando.hpp + start-Zweig + TU + MANUAL_RUN-Abschnitt.
- **C5** super: experiment:start-CI-Job + Doku (nach C4-Landung im ce-Gitlink).
- Jede Landung: Lebend-Check + Ledger-Koordinationsvermerk (Register abend-5; wt-b*-Namensraum).

## (f) UEBERLAPPUNGS-BEFUND (KRITISCH) -- B13-Dateien vs. laufende W5/W3-Nachbesserung

W5/W3-Datei-Menge (aus backups/20260805-w5-w3-kern/plan.md (d) + Codex-Befundliste LEDGER:4123;
wt-e24 NICHT betreten): apps/experiment_planner/main.cpp · planner/planner_status_reader.hpp (NEU)
· planner/progress_cursor_reader.hpp (NEU) · builder/experiment_tree/cache_engine_builder_iterator
.hpp (kLazyResumeRowsKey) · builder/pruef_dock/mess_interface_testate.hpp (NEU) · tests/unit/
test_w5_status_reader.cpp + test_w3_mess_interface_testate_dock.cpp + test_w3_mess_interface_
testate_biss.cpp (NEU) · tests/unit/CMakeLists.txt · MANUAL_RUN.md.

DIREKTE UEBERLAPPUNGEN mit B13 (6): (1) apps/experiment_planner/main.cpp -- W5 baut den
status-Zweig + fixt :322/:336, B13 haengt print-env/start daneben und reichert status-Ausgabe an;
(2) planner_status_reader.hpp -- existiert ERST nach W5-Landung, B13-C2a erweitert eta=; (3)
progress_cursor_reader.hpp -- existiert ERST nach Landung, B13-C2a braucht Suffix-Toleranz + neue
Pins; (4) cache_engine_builder_iterator.hpp -- W5 hebt kLazyResumeRowsKey, B13 aendert
fire_progress + 5 Marker-Stellen; (5) tests/unit/CMakeLists.txt (beide registrieren TUs); (6)
MANUAL_RUN.md (beide ergaenzen Abschnitte). KEINE super-Ueberlappung (W5/W3 ist ce-only; B13-super
= Sink/CI-Job/Treiber-print-env).

KONSEQUENZ (bindend): B13 DARF NICHT auf b4110cd0 bauen -- ein Parallel-Bau ergaebe an (1)-(6)
sichere Merge-Konflikte gegen eine Welle, die zusaetzlich unter Codex-Nachbesserung (wf_a870c885)
noch BEWEGT wird. STRATEGIE: Bau GATED auf die W5/W3-Landung; danach Branch `b13-eta-headless` NEU
ab dem NEUEN dev-Stand (kein rebase, kein Weiterbau des alten Standes; wt-b13-eta wird auf den
neuen Branch umgesetzt oder frisch angelegt). ERSTER Bau-Schritt = RE-ANKER-PASS: alle in (c)
genannten W5-datei:zeile-Anker (status-Zweig-Position, Reader-Strukturen, Pin-Listen) am
GELANDETEN Objekt neu erheben -- die hier zitierten W5-Zeilennummern stammen aus dem W5-PLAN vor
der Nachbesserung und sind DEKLARIERT UNSICHER. Stabil-verifizierte Anker dieses Plans (b4110cd0,
von W5/W3 laut deren Plan unberuehrt): slice_marker.hpp, progress_delta.hpp, progress_heartbeat
.hpp, experiment_plan_director.hpp, planner_cli_env.hpp, super main.cpp:1155-1195.

## (g) RISIKEN

1. **W5/W3-Landungs-Drift (hoch):** Nachbesserung wf_a870c885 kann Reader-Struktur/Zeilen
   verschieben; Codex-H1/H2-Fixe aendern genau die status-Bilanz, an die B13-eta andockt.
   Gegenmittel: Gate + Re-Anker-Pass (f) als Pflicht-Schritt 1, Plan-Anker als "erwartet"
   gekennzeichnet.
2. **Cross-Repo-Format-Kopplung [progress]:** super-Schreiber vs. ce-Leser; Suffix nur additiv am
   Zeilenende, Commit-Ordnung C2a VOR C2b, Literal-Pins beider Formen; Single-Source erst mit
   #35-.so (nach Abgabe, ausdruecklich NICHT B13).
3. **Emissions-Pin-Bruch:** JSON-Zeilen/Tee-Filter aendern Stufe-2-YAML und Treiber-stderr --
   KOMMIT-REGEL strikt (Emission+Pins ein Commit), sonst per-Commit-Gruen-Doktrin verletzt.
4. **Secret-Leck via print-env:** NFS_DROP_TOKEN/minio-Werte duerfen NIE in Trace/stdout --
   Secret-Flag im Katalog + TU-Negativprobe + gitleaks am Diff.
5. **Mess-Start-Verantwortung:** start OHNE --mit-messung misst nie; CI-Job Default ohne Messung;
   Phase-6-USER-GO-STOPP bleibt gewahrt. Ein versehentlicher Mess-Anstoss waere Doktrin-Bruch.
6. **ctest-N lebendes Gate + cppcheck-Adjazenz-Falle:** +3 TUs verschieben N; keine COMDARE_*-
   Makros in String-Literal-Adjazenz (nachmittag-5-Kanon); je Commit frisches Configure, N literal.
7. **Frist (Abgabe Fr 08.08., Trigger-Ziel Do 07.08.):** B13 haengt HINTER der W5/W3-Landung im
   selben Zeitfenster wie Phasen 3-5; Kollisionsregel = Variante B (Substanz gewinnt, Trigger darf
   rutschen, LEDGER:4210-(5)) -- bei Enge: C1+C2 zuerst (kleinster ETA-Kern), C3b/C5 zuletzt
   faltbar; jede Herabstufung DEKLARIERT, nie still.
8. **fenster_gesamt-Semantik:** builds.size() vs. +bestand_lager_skips (:1547 vs :1603) sind
   bewusst VERSCHIEDENE Totale (Lager-Skips zaehlen im Bau-Fenster mit, im Pruef-Fenster nicht) --
   Kommentar-Wahrheit an beiden Stellen, TU-Fall je Ausgang (die drei fire_progress-Ausgaenge
   muessen byte-gleiche Zeilenform behalten, TP1FK1-B5-Lehre LEDGER:3657).
9. **Worktree-Disziplin:** wt-b13-eta gehoert dieser Session (Register abend-5); wt-e24/
   wt-super-w1 TABU; Landungen nur nach Lebend-Check + Ledger-Vermerk; Working-Tree-Freeze nach
   Paketmeldung.
