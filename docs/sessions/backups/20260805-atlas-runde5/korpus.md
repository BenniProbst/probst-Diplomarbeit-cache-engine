# KORPUS RUNDE 5 — LENS rueckschreibe-zukunft (READ-ONLY-Erhebung, 05.08.2026)

Pfad-Kuerzel:
- `LEDGER` = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
- `ce` = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
- `super` = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
- `MEM` = /home/comdare/.claude/projects/-home-comdare/memory
- `ITER` = ce/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp

Status-Legende je Glied: **IST** = existiert im Code (datei:zeile) · **PLAN** = nur Doku/Design · **TEIL** = Naht existiert, Vollzug offen.

---

## (A) RUECKSCHREIBE-KETTE XML -> ... -> CSV/xlsx — VOLLSTAENDIG, je Glied IST vs PLAN

### A.1 Anwender-XML -> Planer/CEB — IST (mit auditierten Abweichungen)
- IST: `super/Code/02_messung_driver/main.cpp:552` verbatim: `"comdare-messung-driver -- Planer- + CEB-Rolle in EINEM Binary (Mess-Kette der Diplomarbeit)"`. CLI-Rollen-Trennung `main.cpp:461-462` (W3: `validate | plan dump/ci/cmake` = Planer-Rolle Stufe 1, `tier ci/cmake` = CEB-Rolle Stufe 2, dazu `cache-key | fingerprint | run | version | help`).
- IST: Aufrufform im Messlauf: `super/.gitlab-ci.yml:681` `"$DRIVER" experiment_config measure_out_smoke` (golden: `measure:golden-320` faehrt `comdare-messung-driver experiment_config measure_out`, MEM/project_mess_ergebnis_rueckschreibung_pipeline_persistiert.md Z.36-39, G-d).
- Audit-Stand (LEDGER:4028, wf_a7faa724, 05.08.): Glied 1 (Planer eigene Binary) = **REGRESSION** (Planer ist Rolle im Driver, nicht eigene Binary); Glied 2 (XML-Interpretation) = TEIL-KONFORM (Parse beider Wurzeln + 3-Registry-Trio real, Resolver im Plan-Pfad nur ANNOTATION/INERT); Glied 3 (Planer kompiliert CEB hart) = TEIL-KONFORM mit KERNSATZ-VERSTOSS (`ceb:build` baut generischen Treiber, [a,b,c]-Differenzierung zur LAUFZEIT per `COMDARE_MEASUREMENT_COMBO`); Glied 5 (CEB Befehle+Bau+Messen) = TEIL-KONFORM inkl. "Selbst-Rueckschrieb EIN CSV je Zelle + Bestandslog NICHT uebers Dock".

### A.2 Mess-Lauf -> result.csv + stamp je Binary — IST
- IST: `ITER:938-943` — je Binary-Verzeichnis `dir/result.csv` + `dir/result.csv.stamp`; `lazy_try_resume_binary` (`:935`) prueft Stamp-Match + Header-Identitaet (Mess-RESUME #139, `:847/:871-876` `lazy_resume_stamp_prefix`).
- IST: Per-Binary-Synchron-Naht dokumentiert `ITER:184-186`: Sinks feuern "SYNCHRON an der per-Binary-Naht (NACH result.csv+stamp, VOR RAII-DLL-Unload) — nie async/detached (I/O-Contention = Messfehler)".

### A.3 measure_out/<slug>/perm-Baum — EIN CSV je Zelle (Paragraph 42.b/38.b) — IST (Struktur) / TEIL (4. Mess-Emissions-Ebene)
- PLAN (Quelle): LEDGER:2433 (Paragraph 42.b verbatim): "Eine Array-Permutation der HAUPT-Achsen fuer ein Tier-Binary ergibt EINEN dynamisch angelegten MESS-Job, der alle Unter-Achsen-Permutations-Messungen ... beherbergt und als CSV zurueckschreibt." Einordnung LEDGER:2435 Punkt (3): je Haupt-Achsen-Permutation EIN Mess-Job `measure:[a,b,c][d,e,f][g,h,i]`, in-Job Unter-Achsen-Sweep (Runtime, selbes Binary, 1-Thread), schreibt **EIN CSV** zurueck. Paragraph 38.b: NUR EINE messende CEB gleichzeitig (LEDGER:2375/2578, `resource_group ceb-measurement-exclusive` in `super/.gitlab-ci.yml:501/579` laut LEDGER:2787).
- IST: measure_out-Baum mit per-Perm-Unterordnern und `measurements.csv`/`result.csv` je Zelle: `super/.gitlab-ci.yml:679-694` (Smoke: `find measure_out_smoke -name 'measurements.csv'`, `find ... -name 'result.csv' | sort` -> WIDE-Aggregat) und analog golden `:770-786`.
- TEIL/OFFEN: die dynamische 4. Mess-Emissions-Ebene (Unter-Achsen-Sweep-Jobs) ist gated (LEDGER:2568/2577/2909: `emit_measure_job` war when:manual-Echo-Skelett; Verdrahtung Ablaufmethodik/Workload-Sweep offen).

### A.4 MeasurementSinkFn / measure-drop (Ebene C) — IST (Naht + Client), Default-Doktrin PLAN->entschieden
- IST: `ITER:80` Include-Kommentar "Storage #51: CachePushFn / MeasurementSinkFn (No-Op-Naht)"; Typ-Alias `ITER:80` (aus `ce/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp`); Feld `ITER:191` `MeasurementSinkFn measurement_sink;` (No-Op-Default => golden/CI byte-identisch, Anti-Phantom, `:186`).
- IST: Feuerung `ITER:1989-1993`: existiert `bin_dir/result.csv`, dann `cfg.measurement_sink(rcsv, bin_dir.filename().string() + "/result.csv")` — Kommentar: "Ebene C: result.csv -> measure-drop (Baum/<stem>/result.csv)".
- IST: Client = curl-PUT HTTPS mit Basic-Auth an `https://measure-drop.comdare.local/<ts>/<datei>` (LEDGER:2123 sink_measurement curl-PUT; LEDGER:2129 V80-measure-drop-Pfad VIP 10.0.80.226; 401-Fix Basic statt Bearer LEDGER:2392; "measure-drop ist der Weg" LEDGER:2465).
- Doktrin (entschieden): **F5** LEDGER:2290: "Im XML immer measure-drop als DEFAULT; git-commit-Writeback = konfigurierbare Option." (TEIL: XML-Schalter selbst LEDGER:2623 "TEIL, hoch").

### A.5 messwert_registrierung (2. Bestandslog-Genus) — IST
- IST: `ce/libs/cache_engine/builder/bestandslog/messwert_registrierung.hpp` — "der PRODUKTIVE Schreiber des ZWEITEN Bestandslog-Genus (measurement)" (Kopf Z.2-3); `MesswertRunState` mit load()/observe()/flush() (Kopf Z.11-15, Klasse ab Z.~80); Schluessel = `messwert_key_hex()` ueber `MesswertKeyPolicy` (voll-permutative Mess-Zeilen + Hardware-Identitaet, NICHT Binary-Fingerprint — Kopf Z.21-26, Paragraph-66-N3-konform); `MesswertOutcome{lager_hit,fresh_register,no_key}`.
- IST: Anschluss-Naht `ITER:1995-1999` (G-E3): je GEMESSENER Zelle ein BestandEintrag ins measurement-Genus, NUR wenn result.csv wirklich existiert (Anti-Phantom analog CX-W1).

### A.6 Bestandslog-measurement-XML (MinIO, doc_revision) — IST
- IST: `ce/libs/cache_engine/builder/bestandslog/bestandslog_document.hpp:35` (`doc_revision="N"` im XML-Wurzel-Attribut), `:49` ("doc_revision ist monoton -> Grundlage des B2-Record-Union-Merge (fetch->merge->store)"), `:265` POD-Feld, `:333-334` Serialisierung. Lock/TTL ueber `builder_registration.hpp` (with_document_lock_retry), eingebunden in messwert_registrierung.hpp.
- IST (Ziel-Routing): `ce/libs/cache_engine/builder/bestandslog/lager_ziel_strategie.hpp:160-171` — CT-Default-Matrix `StandardZiel<Genus::binary> = ObjektStoreBackend` (minio) und `StandardZiel<Genus::measurement> = NasAblageBackend` mit Kommentar `:166` "Mess-CSV/xlsx -> NAS measure-drop (Default)"; static_assert Dual-ccache-Trennung (Section 65). Gegenteilig konfigurierbar per Template-Argument (MEM/project_lager_baeume_xlsx_doktrin.md Z.16).

### A.7 measurement/<YYYYMMDD-HHMMSS>/-Git-Rueckschrieb (Write-Token id=54, [skip ci]) — IST
- IST: `super/.gitlab-ci.yml:807-903` Job `persist:measurements` (stage `persist`, `:36`): DEST = `measurement/<YYYYMMDD-HHMMSS-p{pipeline}>/` im super-Root (`:808`), commit+**MERGE**+push nach development (`:815-816`, "durch merge, kein rebase"); Creds `COMDARE_WRITEBACK_USER/COMDARE_WRITEBACK_TOKEN` (`:812/:854-855`) = Project-Access-Token id=54 write_repository-only (MEM/project_mess_ergebnis_rueckschreibung_pipeline_persistiert.md Z.28-29 + reference_measurement_writeback_token_288_secure); Loop-Schutz dreifach: ci.skip + `[skip ci]` + `_bot_`-rule never (`:844`). Selektiv NUR `*.csv` + Anhang-.tex, nie DLLs (`:881-903`; .gitignore-Negation `!measurement/**/*.csv`, Memory Z.44-49). Aktivierung PER-PIPELINE (`COMDARE_PERSIST_MEASUREMENTS=true` nur beim Mess-Trigger, Memory Z.32-35).

### A.8 CSV -> LaTeX-Kette (E4) — IST (Anhang-Generator im Messlauf)
- IST: `super/.gitlab-ci.yml:686-697` (smoke) und `:770-795` (golden): `cmake --build build --target appendix_generator_cli` -> `appendix-generator` (Quelle `super/Code/08_appendix_generator/appendix_generator.hpp`, `:771`) liest die WIDE-Matrix ALLER Permutationen (Konkatenation der per-Perm `result.csv`) und regeneriert je Sprache (de,en) die **12 Kern- + 5 Darstellungs-.tex** (`:770-771`, K-12-Sweep); Artefakte `Code/measure_out/appendix/**/*.tex` (`:795`), landen zusaetzlich via persist:measurements in `measurement/<ts>/` (LEDGER:263 G6: "CSVs + regenerierte Anhang-.tex nach measurement/<ts>/ development = DoD-6-Beweis").
- PLAN (Ausdehnung): E4-Kette CSV->LaTeX ist auf ALLE 4 Phasen auszudehnen (MEM/feedback_ceb_drei_modi... Z.21, User 10.07.: "ALLE 4 Phasen ... in E4 aus Diplomarbeits-Sicht AUTOMATISCH dokumentiert").

### A.9 XLSX-DOKTRIN — PLAN (Design fix), IST = nur Pfad-Grammatik, KEIN Serialisierer
Memory KOMPLETT (MEM/project_lager_baeume_xlsx_doktrin.md, 26.07., Owner-KERN; Detail super `docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` Paragraphen 4/6):
1. Namens-Doktrin: dynamische Unter-Achsen-Variablen IMMER direkt im Dateinamen; Name = NUR Datum+Uhrzeit+Unter-Achsen-Variablen; Lage = Haupt-Achsen-Ordner-Kaskade; Haupt-Achsen zusaetzlich als METADATEN in der Datei (vollstaendige Selbst-Identifizierbarkeit).
2. **xlsx = Default**, CSV einstellbar + Fallback; CSV je Sheet einzeln im FACTORY PATTERN; xlsx = EINE Datei, EIN Sheet je gewaehlter Unter-Achsen-Permutation + INFO-Sheet (Sysinfo der Maschine + Haupt-Achsen).
3. Zwei Realm-Baeume: Messdaten-Wurzel = Mess-Kombinatorik (Mess-Tooling x load_framework) -> System-Haupt-Rekombinations-Ordner (Meta-Metas hinten) -> Organ-Gruppen 01..05 -> Haupt-Blatt -> 3 Unter-Ebenen (Mess-Unter -> System-Unter -> Organ-Unter) -> xlsx. Binaries-Lager: System-Achse als Wurzel, Mess-Typ zutiefst.
4. Dual-ccache: Default minio=Binaries / NAS=Mess-Ergebnisse, gegenteilig konfigurierbar.
5. Design fix; **Vollausbau der Baum-/xlsx-Writer im #46b-/vor-01.08.-Paket** (Session-Doc Z.106: "Design jetzt fix, Vollausbau im #46b-/vor-01.08.-Paket").

Ledger `grep -n 'xlsx'`: NUR 3 Stellen — LEDGER:88 (V7.2-Verweis auf die 26.07.-Session-Docs), LEDGER:4104/4106/4108 (der heutige Runde-5-Nachtrag selbst). **Die Default-xlsx-Schreibung hat im Ledger-Haupttext KEINEN eigenen Paragraphen** — Quelle ist der Owner-KERN 26.07. (Memory + Session-Doc Paragraphen 4/6).

IST-Stand Code (`grep -rn 'xlsx' ce/libs ce/apps --include='*.hpp' --include='*.cpp' -il` => genau 3 Dateien):
- `ce/libs/cache_engine/builder/bestandslog/lager_pfad_grammatik.hpp` — `:4` Ownership: "A9-xlsx-Writer (Ownership-Entscheid L5: diese Datei gehoert der A1-Lager-Welle, A9 KONSUMIERT sie"; `:525-538` Selbsttests `blatt_dateiname(...)` erzeugen z.B. `20260812-093011_measurement_category=wallclock+workload=ycsb_a+working_set_n=sweep.xlsx` (= Namens-Doktrin 1 implementiert); `:572` Wache "Baum-Writer und xlsx-Writer legen verschiedene Ordner an" (Konsistenz-Static-Assert).
- `ce/libs/cache_engine/builder/bestandslog/lager_ziel_strategie.hpp:166` — NAS-Default-Kommentar (A.6).
- `ce/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp:535` — "die xlsx-/Lager-Strecke uebernimmt es [K-10-Token-Vokabular] ueber dieselbe Vokabel".
- Baum-Writer IST: `ce/libs/cache_engine/builder/bestandslog/lager_baum_writer.hpp` (LB-2/LB-3: beide Realm-Kaskaden Ebenen 1-11 + Blatt via `blatt_dateiname()`, Blatt-Identitaet = v6-Fingerprint, L3 kein Hybrid-Segment).
- **FEHLT (PLAN):** ein tatsaechlicher xlsx-SERIALISIERER (SpreadsheetML/zip-Container, Sheet-je-Unter-Achsen-Permutation, INFO-Sheet) existiert nirgends im ce (grep worksheet/zip/xl-: 0 fachliche Treffer). WO/WANN/WERKZEUG laut Doktrin: am Blatt der Messdaten-Realm-Kaskade, beim Mess-Rueckschrieb (Lager-Strecke), Werkzeug = der noch zu bauende hauseigene A9-xlsx-Writer (kein Python, Doktrin feedback_no_python_in_buildchain) — Vollausbau-Paket #46b. Heutige Laeufe schreiben real NUR CSV (result.csv/measurements.csv); CSV = Factory-Fallback bleibt gueltig.

---

## (B) ZUKUNFTS-PHASEN — 4-Modi-Kanon + Owner-Praezisierung 05.08. (LEDGER:4106 verbatim)

Owner-Wortlaut heute (LEDGER:4106): Messwerte werden im Voll-Lauf AUSGEWERTET, "zu Messkurven synthetisiert, die Messkurven je Eingangslast verglichen, um die beste binary zu finden, die man dann nochmal im release Modus ohne Mess-Einrichtungen neu kompiliert und nochmal wallclock time misst. An dieser stelle koennen dann auch ueber multiple Lasten multiple beste Binaries bestimmt werden, die ueber eine Erkennungsheuristik der Last ein Hybrid-Tier-binary zur aktiven runtime Auswahl der optimalen Tier-Binaries erzeugt."

Kanon-Wurzel: MEM/feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md (Dossier 19 Teil G): Messmodus -> Auswertungsmodus -> Arbeitsmodus -> HYBRID (= ZIEL der Diplomarbeit); LEDGER:215 (V7.2-e). Dazu orthogonal die Ablaufmethodik-Modi Debug/Messung/Release (+COMPARE als 4.): F7 LEDGER:2294, Paragraph 47 LEDGER:2496ff, Paragraph 61 LEDGER:3281-3290, Paragraph 62 Punkt 3 (MEM/project_62..., COMPARE je Maschine).

### Phase 1 — MESS-Modus (laeuft auf den Trigger zu) — IST/TEIL
- PLAN praezise: F7 LEDGER:2294 (Observer+Messeinrichtungen IN der Binary, pruefdock-kompatibel; CEB kompiliert Messinstitutionen ein; Selektivitaet); Paragraph 47 LEDGER:2496/2231 (Mess-Tooling {Wallclock/Makro/Micro} = HAUPT-Achse, Ablaufmethodik {Debug/Messen/Release} + Workloads = UNTER); Paragraph 61 LEDGER:3281-3283 (DEBUG = je Maschine parallel bauen+messen; MESSUNG = parallel bauen, sequentiell messen); Paragraph 38.b Mess-Exklusivitaet.
- IST: gesamte Kette A.1-A.8 oben; Modi-Master `ce/CMakeLists.txt:135` `option(COMDARE_MEASUREMENT_MODE ... ON)`; CI-Jobs `measure:smoke`/`measure:golden-320` + `persist:measurements`; Pruefstand BINDEND vor Messung (LEDGER:4028 Glied 5). Offen: Voll-Lauf selbst (Trigger-Ziel Do 07.08.).

### Phase 2 — AUSWERTUNGS-Modus: Messwerte -> Messkurven-SYNTHESE -> Kurven-Vergleich JE EINGANGSLAST -> beste Binary — PLAN sehr praezise, Mathematik-IST vorhanden, Orchestrierung OFFEN
- PLAN (Fundstellen): Auswertungsmodus = "minimale Straenge der Permutationen ... fuer bestimmte Workload-Cluster; Cluster-Bildungs-Methodik per deep research" (MEM/feedback_ceb_drei_modi..., Punkt 3; LEDGER:215). **F8 (ABGABE-PFLICHT)** LEDGER:2296: Spline-Funktion auf JEDER Achse als Heuristik-Abschaetzung; bei Anfrage (klassifizierte Operationen x Workload) "rueckwaerts die optimale Binary mit den optimalen Algorithmen-Saetzen ... laden". F8-Mathematik LEDGER:2301: Switch-Thresholds = Schnittpunkte der f(x)-Spline-Funktionen zweier Algorithmen derselben Achse; voll permutierte Baum-Matrix => Messwert-Diff jeder Ebene isolierbar => vollstaendig isolierbares Modell je Organ-Achse. Doc-20-Vision LEDGER:829 (Messkurven-Typsystem `tree<axis, map<framework, ...>>` + Auswertung = Filterkette = CoR strikt im CEB). Paragraph 31/Paragraph 32-F8-DoD LEDGER:2605/2952 (Hybrid-Binary aus realen Messdaten, ctest-bewiesen). Kurven JE EINGANGSLAST: die Loader-Gruppierung ist (achse, variante=binary_id, workload) — Workload = Eingangslast-Dimension.
- IST (die W3-C/F8-Mathematik IST da, Paket W3-C "Ledger Sec.32-F8, Abgabe-Pflicht"):
  - `ce/libs/cache_engine/heuristik/axis_spline.hpp` — Spline ueber (x,y)-Stuetzstellen je Organ-Achsen-Variante; DEFAULT = monotone kubische Hermite (Fritsch-Carlson 1980, Anti-Overshoot => keine Schein-Break-Evens), natuerlicher kubischer Spline als alternative CT-Strategy; HONEST-EMPTY (<2 Stuetzstellen => nullopt); `CurveSample` = Single-Source.
  - `ce/libs/cache_engine/heuristik/break_even.hpp` — d(x)=f(x)-g(x) auf dem Ueberlappungs-Intervall, gemeinsames Knoten-Gitter, Vorzeichenwechsel + deterministische Bisektion; `BreakEvenPoint{x,y,links_besser,rechts_besser}`; Konvention besser = kleinerer y; F8-verbatim-treu im Kopf zitiert.
  - `ce/libs/cache_engine/heuristik/measurement_curve_loader.hpp` — laedt (x,y)-Reihen je (achse,variante,workload) aus realer Mess-CSV; ZWEI Dialekte (WIDE `lazy_csv_header` semikolon: Gruppe=(sweep_axis,binary_id,workload), x=working_set_n, y=ns_per_op; SNAPSHOT komma: (permutation_id,workload_used), x=op_count, y=total_cycles); ehrliche Tokens `n/a`/`failed`/`gesperrt`/`nicht_gebaut` => Zeile gezaehlt uebersprungen, NIE Phantom-Punkt.
  - Vorlaeufer/Konsumenten: `ce/libs/cache_engine/builder/curve_fit/curve_fit.hpp`, `ce/libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp` (CoR), `ce/libs/cache_engine/builder/best_binary_selector/best_binary_selector.hpp` (Task #172: rankt je Interface-Funktion/Metrik die beste binary_id ueber two_phase_valid-Zeilen [Median, nearest-rank], loest die reale perm.dll auf und versendet sie als ABI-stabiles Artefakt mit Manifest — Strategy/Builder/Repository).
  - Schutz: Paragraph 75-NICHT-KANDIDATEN LEDGER:3602 — axis_spline/break_even/measurement_curve_loader + `IPruefDock::measure` (`ce/libs/cache_engine/builder/pruef_dock/pruef_dock.hpp:78`) + AnatomyModuleLoader-Flaeche duerfen im Aufraeumpass NICHT entfernt/umbenannt werden (Speisung des Break-Even-Routers HY-B2).
- OFFEN: (a) der Auswertungs-ORCHESTRATOR (Kurven je Eingangslast systematisch vergleichen -> beste Binary je Last bestimmen) ist nicht verdrahtet — best_binary_selector rankt Roh-Mediane, konsumiert die Splines/Break-Evens NICHT; (b) Workload-Cluster-Bildung = offener deep-research-Task (MEM/feedback_ceb_drei_modi..., Punkt 3); (c) Messkurven-Typsystem-WURZEL #11/G6 DATEN-gated (LEDGER:263: "Entsperrt danach: #11 Messkurven-Typsystem-WURZEL, Kurven-Fit-Konsum, P1 Working-Set-Kurve+Fit-Overlay").

### Phase 3 — RELEASE-Nachmessung: Neu-Kompilation OHNE Mess-Einrichtungen + erneute Wallclock-Messung — PLAN sehr praezise, CT-Schalter IST, Beweis-Lauf OFFEN
- PLAN (Fundstellen): F7 LEDGER:2294 Modus (3): "Release-Modus = erst Messung, zum Schluss eine perfekt optimierte Tier-Binary oder Heuristik-Hybrid-Binary OHNE eingebautes Messsystem." Paragraph 61-MODI LEDGER:3283: Modus RELEASE = System-Achsen-korrekte Maschine, AUSLIEFERUNG "OHNE einkompilierte Mess-Einrichtung und ohne Overhead" + "BEWEIS der schnellsten Binaries ueber Release-Product-Wallclock-Mess-Vergleich, zusaetzlich gegen die Debug-Overhead-Version (beste) und die schlechteste Variante unter der XML-Konfiguration." LEDGER:3284: "RELEASE = ZIEL DES GESAMTPROJEKTS ... Mess-Observer MUESSEN per Metaprogrammierung ABSCHALTBAR sein ... bewiesen durch eine Release-Tier-Binary-Wallclocktime-Messung." LEDGER:3285: Release-Wallclock-BEWEIS = eigener Deliverable-Schritt der S7/Post-Kette (an #17/G3 verankert); Abschalt-Naht = COMDARE_MEASUREMENT_ON-Metaprogrammierung. Stufen LEDGER:3287-3290: Debug -> Messung -> Release, RELEASE benoetigt die VOLLE MESSUNG (Replay Paragraph 58); Compile-Einstellungs-Stempel (+bt=Debug-Suffix-Minimalform) = Reuse-Schluessel. Kanon: CI-Gruen = Messung AUS (MEM/feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert; Gesamtlauf commit-frei, nur echter Mess-Trigger persistiert).
- IST: `ce/CMakeLists.txt:135` `COMDARE_MEASUREMENT_MODE` Master (bindet observer_all+memento_all+Pfad-A ein, `:128`); `:137-138` **COMDARE_RELEASE_MODE erzwingt MEASUREMENT_MODE OFF** ("V5: durch COMDARE_RELEASE_MODE erzwungen" FORCE) — die Neu-Kompilation OHNE Mess-Einrichtungen ist als CT-Schalter gebaut; `:448-452` Invariante EXPERIMENT_MODE => MEASUREMENT_MODE.
- OFFEN: der Release-Nachmess-LAUF (best-Release vs beste-Debug-Overhead vs schlechteste XML-Variante, Wallclock) existiert weder als CI-Job noch als Driver-Subkommando — reiner SOLL-Deliverable (S7/Post-Kette, #17/G3).

### Phase 4 — ARBEITS-/HYBRID-Modus: multiple Lasten -> multiple beste Binaries -> LAST-ERKENNUNGSHEURISTIK -> Hybrid-Tier-Binary zur AKTIVEN RUNTIME-Auswahl — PLAN sehr praezise (Design festgeschrieben), Bau in der Auswertungsphase
- PLAN (Fundstellen):
  - MEM/feedback_ceb_drei_modi... Punkt 4 + Erweiterung: Arbeitsmodus haelt Tier-Binaries fuer die "aktuell stochastisch haeufige Workload-Last" hot im RAM, Hot-Switch der Tier-Binary an der bewussten ABI-Grenze E2 (kein Switch IM Tier, no-runtime-switch gewahrt); HYBRID: Heuristik-Optimierungs-Achse = EIGENE SYSTEMACHSE, selbst zur Tier-Binary kompiliert, dockt am CEB-Pruefdock an, reicht Befehle an statisch zugewiesene echte Tier-Binaries weiter (Metaprogrammierungs-Command-Pattern), "virtuelles ganzes Tier-Binary"; muendet in erneuter Messung des Heuristik-Tier-Binaries im Arbeitsmodus. Workload-Erkennung/Auswahl = E4-Funktion auf Basis des Heuristik-Schaetzers (MEM/feedback_axes_optimization_semantics..., Punkt 3: mehrdimensionale Kurven je Last + Fuellstand + Beschaffenheit = echte Optimierung).
  - F8-Optionen + Paragraph 49/49-KORREKTUR LEDGER:2296-2298/2692/2696: Option 1 (variant in derselben Hybrid-Tier-Binary) UND Option 3 (Array multipler Docks + Memory-Verdraengungs-Strategie) FREIGEGEBEN; variant LIMITIERT auf abweichende Unter-Pruefdock-Typen via Abstract-Factory; Haupt-Kommunikation bleibt statisches IObservableTier.
  - `ce/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (HY-D2, Owner-Entscheid E1 02.08. verbatim): Hybrid-Tier-Binary = eigene Stufe HINTER der CEB; mehrere ABI-stabile Pruef-Docks, Anzahl DYNAMISCH (variant in wahlweise statischem oder Runtime-Array); Factory Pattern in Proxy-Verwendung; Zwischenloesung statisch<->austauschbar = **XML-Konfiguration auf Anwender-Wunsch in der AUSWERTUNGSPHASE**; Rekursions-Ebene 3 der Dock-Kette; KEIN eigener ABI-Schritt; Verzeichnis-Stub `ce/libs/cache_engine/hybrid/README.md`, "Status: DESIGN FESTGESCHRIEBEN, BAU IN DER AUSWERTUNGSPHASE".
  - Ruf-Kette LEDGER:4076: "HYBRID-Ruf: Heuristik SELBST als Tier-Binary am selben Pruef-Dock (kein dritter Dock-Typ), CT-CoR-Break-Even-Router an STATISCH zugewiesene echte Tiers, traegt N dynamische Hybrid-Pruef-Docks (Rekursions-Ebene 3, variant-DockArray = einzige erlaubte Ausnahme); Tier-Neubau IMMER delegiert durch CEB."
  - COMPARE (4. Ablauf-Modus, Paragraph 62 Punkt 3, MEM/project_62...): nach Release je Maschine COMPARE = Vergleich der Mess-REPLAY-Sicht (Paragraph 58) der messenden Maschine mit allen per Cache-Log registrierten Maschinen; Release der optimalen Binary gilt nur je Maschine (hardware-spezifisch). Ergaenzend Kette LEDGER:2261 Punkt 6 (CEB entwickelt nach Auswertung Heuristik-Hybrid-Tier-Binaries, rekursive Delegation).
- IST: Pruefdock-Vertrag `IPruefDock::measure` + Loader-Flaeche (Paragraph 75-Schutzliste, LEDGER:3602); heuristik/-Trio als Router-Speisung (s. Phase 2); `ce/libs/cache_engine/builder/commands/compare_engine_command.hpp` (V32 CompareEngineCommand + welch_t_test, dokumentierte geparkte V32-Ausnahme, hart konsumiert von `super/Code/02_messung_driver/v32_orchestrator.hpp:13`); "MODE COMPARE" als Planer-Block-Baustein gelandet (LEDGER:100, STRUKT-R-Kernwelle). Hybrid-Verzeichnis existiert NUR als README-Stub.
- OFFEN (rein PLAN, 0 Code-Treffer): LAST-ERKENNUNGSHEURISTIK (grep Erkennungsheuristik/workload_erkennung/last_erkennung/workload_detect ueber ce/libs+docs: leer) — die stochastische Workload-Last-Erkennung mit aktiver Runtime-Auswahl ist nirgends implementiert; ebenso Hot-RAM-Array-Verwaltung + Memory-Verdraengungs-Algorithmus (Option 3) und der Hybrid-Binary-Bau selbst (per Owner-Entscheid E1 bewusst: Bau in der Auswertungsphase).

---

## GEGENPRUEFUNG — 2. unabhaengiger Durchgang (P4-Dauer-Regel, 05.08. nachmittags)

Alle Kern-Fundstellen dieses Korpus wurden in einem zweiten, unabhaengigen Lesedurchgang gegen den
IST-Stand verifiziert (spot-checked verbatim): `ce/CMakeLists.txt` COMDARE_MEASUREMENT_MODE-Master +
"RELEASE_MODE=ON erzwingt MEASUREMENT_MODE=OFF" (FORCE) + EXPERIMENT=>MEASUREMENT-FATAL_ERROR (`:448-452`);
`ITER:935-943` (result.csv + result.csv.stamp, lazy_try_resume_binary); `ITER:1989-1999` (Sink-Feuerung nur bei
existierender result.csv + G-E3-Mess-Rueckschrieb-Naht); `super/.gitlab-ci.yml:679-694` (Smoke: measurements.csv-Beleg,
WIDE-Aggregat aus per-Perm result.csv, appendix-generator); LEDGER:3281-3290 (Paragraph-61-MODI/STUFEN verbatim inkl.
Release-Wallclock-BEWEIS als eigener Deliverable-Schritt); LEDGER:3602 (Paragraph-75-Schutzliste heuristik-Trio +
IPruefDock::measure + Loader-Flaeche); LEDGER:4028 (Audit wf_a7faa724, R-G1..R-G5-Register). KEIN Widerspruch gefunden.

**KORREKTUR AKTUELLER LEDGER-ANKER (der Ledger ist seit dem Erst-Durchgang um nachmittag-1/-3-Nachtraege gewachsen —
Zeilennummern im Text oben entsprechend nachziehen):** `grep -n 'xlsx'` liefert JETZT **7 Treffer**:
`:88` (V7.2-Verweis) · `:4103/:4105/:4106` (NACHTRAG nachmittag-3 = P3: Owner verbatim "CSV xor xlsx ... strategy pattern,
keine chain of responsabilities" + KANON xlsx=DEFAULT/Doppel-Schreibung=Regression) · `:4114/:4116/:4118`
(NACHTRAG nachmittag-1 = Owner-Atlas-Review Runde 5 verbatim + Manager-Antwort "SOLL-Sektion JETZT + Live-Nachzug").
Der oben als LEDGER:4106 zitierte Owner-R5-Wortlaut ("...zu Messkurven synthetisiert...") steht aktuell in **LEDGER:4116**;
P3-KANON in **LEDGER:4106**. Befund unveraendert: die Default-xlsx-Schreibung hat im Ledger-HAUPTTEXT keinen eigenen
Paragraphen — Quellen sind Owner-KERN 26.07. (MEM/project_lager_baeume_xlsx_doktrin.md, inkl. dort bereits
persistiertem P3-NACHTRAG 05.08., Z.19) + Session-Doc 26.07. Paragraphen 4/6.

**Zusaetzliche UNGEDECKT-Punkte (Gegenpruefung offen) fuer die SOLL-Sektion:**
1. **Ort der Format-Strategy-WAHL in der XML**: P3 sagt "GENAU EINE aktive Strategie je Lauf (XML-gesteuert)" — ein
   `<format>`-/Writer-Wahl-Element ist weder in `super/Code/test_data_xml/experiment_schema.xsd` noch im Parser belegt
   (0 Treffer). Das Diagramm muss die XOR-Weiche als PLAN-Knoten ohne XML-Fundstelle ausweisen.
2. **"Messkurven je Eingangslast VERGLEICHEN -> beste Binary" als EIN benannter Codepfad**: heute verteilt auf
   `break_even.hpp` (Schnittpunkte) + `best_binary_selector.hpp` (rankt Roh-Mediane direkt aus CSV, konsumiert die
   Splines NICHT) — die Synthese-Bruecke ist `hybrid_router.hpp` (SOLL, HY-B2, existiert nicht).
3. **Release-Wallclock-NACHMESSUNG**: CT-Schalter IST (`COMDARE_RELEASE_MODE`), der Beweis-LAUF (best-Release vs
   beste-Debug-Overhead vs schlechteste XML-Variante) hat weder CI-Job noch Driver-Subkommando (nur LEDGER:3283-3285).
4. **LAST-ERKENNUNGSHEURISTIK**: auch im Design-Doc `20260802-hybrid_tier_stufe_soll_design.md` NICHT ausgearbeitet
   (grep 'Erkennungsheuristik|Last-Erkennung|Workload-Erkennung|stochastisch' im Doc = 0). Deckung ausschliesslich:
   MEM/feedback_ceb_drei_modi... Punkt 4 ("stochastisch haeufige Workload-Last"; "Workload-Erkennung/Auswahl =
   E4-Funktion auf Basis des Heuristik-Schaetzers") + Owner-R5 verbatim LEDGER:4116 ("Erkennungsheuristik der Last").
5. **Werkzeug-Detail des xlsx-Writers** (SpreadsheetML-Container, Sheet-Layout): nur Doktrin-Memory (EIN Sheet je
   Unter-Achsen-Permutation + INFO-Sheet), kein Design-Dokument mit Serialisierer-Spezifikation gefunden.

Ergaenzende IST-Anker aus dem 2. Durchgang: `run_methodology_registry.hpp:7-14` dokumentiert den Kommentar-Reserve->Typ-Weg
des compare-Modus ("WAEHLBARKEIT, NICHT VOLLZUG ... modus-SPEZIFISCHER Ablauf = Nach-Trigger-Paket D2") — dasselbe Muster,
das Design-Doc §4 fuer `<hybrid_tier>` vorschreibt (XSD-Kommentar-Reserve JETZT, `HybridTierType` erst HY-B3; XML-Zielentwurf
mit `<dock_array storage="static|runtime">`, `<eviction strategy="lru|lfu|arc|cost_aware">`,
`<router><break_even source="measurement_store" curves="axis_splines"/></router>`). Apps-IST fuer Vergleich/Versand:
`ce/apps/f15_compare/` (Welch + Holm-FWER gegen Baseline, CSV/JSON) + `best_binary_selector_main.cpp` (CLI).

---

## Randnotiz zu Owner-Punkt (3), Posten 91
Der Vermerk "Hinweis-REGELN aufstellen, bei welchen Eigenschaften ein UML-Element wahrscheinlich Nachholbedarf hat" ist im Ledger-Nachtrag LEDGER:4104-4108 persistiert (Manager-Entscheid: SOLL-Sektion JETZT + Live-Nachzug + ERSTER Hinweis-Regeln-Entwurf in der Runde-5-Welle). Aus dieser Erhebung ableitbare Regel-Kandidaten: (i) Element traegt No-Op-Default-Naht (CachePushFn/MeasurementSinkFn/ProgressSinkFn-Muster) => Konsument wahrscheinlich noch offen; (ii) Element ist Paragraph-75-schutzgelistet => bewusster Vorbau, KEIN Nachholbedarf; (iii) Element existiert nur als Pfad-/Namens-Grammatik ohne Serialisierer (xlsx) => Nachholbedarf sicher; (iv) Element mit "DEPRECATED-Referenz"/Band-C-Markierung (experiment_dock_payload) => bewusst deferred, kein stiller Fehler.
