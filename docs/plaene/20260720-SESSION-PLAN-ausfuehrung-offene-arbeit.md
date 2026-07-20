# SESSION-PLAN — Sequentielle Ausfuehrung der offenen Diplomarbeit-Arbeit (2026-07-20, ZUR FREIGABE)

> Ultracode-Synthese (wf_c8314fe7: 3 Analyse-Reader Datei-Disjunktheit/Abhaengigkeit/Deadline -> Architekt-Plan). Grundlage = §48-Gesamtblock (437 Ziele). Prinzip: sequentielle Schritte entlang der Abhaengigkeitskette, je Schritt disjunkte Arbeit auf max ~5-6 parallele Agenten; Planer-Kern hat 1 Owner (streng sequentiell). Manager integriert je Schritt (cf22+ctest+Mojibake+super-Sub-Build+Dual-Push+CI-gruen).

---

## Ziel & Rahmen

**Deadline:** 28.07.2026 (BAND-B, Abgabe = 320er-Messdatensatz + Hybrid-Binary + Thesis-PDF). Zwischen-Meilenstein **24.07.** (BAND-A: alles baut, das Meiste CI + lokal messbar). Voll-Messung (new-golden) ist Anschlussarbeit **ab 01.08.** (BAND-C).

**Kritischer Pfad (2-3 Saetze):** Ohne den `COMDARE_GN_TOTAL`-Forward-Fix baut die neue CE-gesteuerte Kette nur 16 statt 131072 Indizes — er blockiert unmittelbar den echten Voll-Build 2^17 und damit das new-golden zum 24.07. Danach: Mess-Tooling-HAUPT-Schema + `measurement_combos_of`-Auffaecherung -> scharfer sequentieller Mess-Vollzug -> USER-GO -> 320er-Abgabe-Messlauf -> M-4-Auswertung -> Hybrid-Spline-Binary (ABGABE-PFLICHT) -> Mess->PDF-Rueckschrieb -> PDF-Abgabe. Parallel und golden-relevant laeuft die Observer/Segment-Reklassifikation (P-OBS), die VOR jedem telemetry-variierenden Messlauf im gemeinsamen ABI/golden-Fenster landen muss.

**Parallelisierungs-Prinzip:** Streng **sequentielle Schritte** entlang der Abhaengigkeitskette; je Schritt wird die datei-**disjunkte** Arbeit auf **moeglichst viele parallele Agenten** verteilt (max ~5-6 wegen Runner-/Review-Kapazitaet). Der **Planer-Kern** (`experiment_plan_director.hpp` + `validate_profile.hpp` + `xml_config_parser.*`) hat **einen Owner** und wird intern STRENG SEQUENTIELL bearbeitet (P-TOTAL -> P-SYSREG -> P-RESOLVER -> P-MESSTOOL -> P-VOLLZUG) — er ist der eigentliche Engpass. Der Manager integriert je Schritt selbst (cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + CI-gruen).

---

## Sequenz der Schritte

### S1 — P-TOTAL Forward-Fix + golden-Vorbereitung (BAND-A, kritisch, ERSTER SCHRITT)

**Ziel:** Die reine Zahl `COMDARE_GN_TOTAL` vererbungssicher durch planer:delegate -> Child -> Grandchild-Pipeline forwarden (heute nur im DEPRECATED statischen Job); zugleich die golden-relevante Observer-Reklass und die Stempel-POD-Vorstufe landen, damit das ABI/golden-Fenster (S2) mit vollstaendigem Substrat oeffnen kann. **Band A (24.07.).**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 P-TOTAL** (Planer-Owner) | `.../planner/experiment_plan_director.hpp` (:664-669,:718), `.gitlab-ci.yml` (variables-Block 90-101, `forward:` 1079-1093) | GN_TOTAL im globalen variables-Block + `forward:`-Klausel in delegate/trigger; Grandchild liest 131072 statt `${…:-16}` | Trigger-Dry-Run: Child-YAML zeigt GN_TOTAL=131072; CI-gruen |
| **A2 P-OBS** (Parser-Owner) | `.../experiment_tree/axis_observer_classification.hpp` (:58/:60), `.../experiment_tree/telemetry_mode.hpp`, `.../xml_config_parser.hpp` (kSegmentCount 20->17-WIDE) | telemetry/isa-Reklass, prt-art telemetry-Demo-Slot, H-10-Sidecar-Aufrufer | ctest Segment-Klass.; **golden-relevant -> in S2-Fenster gehoerend** |
| **A3 P-W12A3** (Stempel-Owner) | `.../abi/anatomy_version_stamp.hpp` (:22/:58), `.../measurement/axis_version_stamp.hpp`, `.../sota_catalog.hpp`, `.../experiment_run_entry.hpp` (SOTA-Stempel) | `kMeasurementAxisVersionLine` als POD-Feld + `compose_*`-Fn analog organ_stamp; SOTA-Stempel nur Mess-Tooling-HAUPT | `static_assert(sizeof==…)` neu gesetzt (Version-Line-Gate) |
| **A4 P-KONFORM** (Konformitaet) | `.../experiment_tree/cache_engine_builder_iterator.hpp` (:203-206/:394-416), `.../abi/anatomy_module_abi_v1.hpp`, `.../experiment_tree/profile_to_tree.hpp` (:82 #1-Fix) | SampleStatus Failed->"failed", all_axes_*_count-Rename, reflect_versions<17>-Gate, organ-only-guard | build-i2-Tests von stale-rot befreit; ctest gruen |
| **A5 P-HYBRID** (Impl, voll disjunkt) | `.../builder/curve_fit/curve_fit.hpp`, `.../best_binary_selector/best_binary_selector.{hpp,cpp}`, `.../decision_lambda_trees/CMakeLists.txt` | Spline-Fit + Break-Even-Geruest + Selektor-Interfaces (noch OHNE reale Daten) | ctest Unit auf synthetischen Kurven |

**Agenten-Zahl: 5.** **Koordination:** A3 (`anatomy_version_stamp.hpp`, sizeof) und A4 (`anatomy_module_abi_v1.hpp`, static_assert==1272) teilen die Version-POD semantisch -> A3 liefert den neuen sizeof-Wert, A4 re-assertet; Manager integriert als **kleines Version-Line-Gate** (kein voller golden-Regen).
**Gate:** cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + **CI hart gruen ce+super, prod1+prod2**.
**Blockiert-durch:** — (Startschritt).

---

### S2 — Voll-Build 2^17 / new-golden-Regen-Fenster + Registry-Angebote + Infra (BAND-A, kritisch, 24.07.)

**Ziel:** Im **EINEN koordinierten ABI/golden-Regen-Fenster** (P-OBS ist golden-relevant) den echten Voll-Build 2^17 als Bau-Nachweis und das new-golden VOLL-Konfig als einzigen Systembeweis erzeugen; parallel die System-Registry-Angebote und die Infra-Sicherheit. **Band A (24.07.).**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 Voll-Build/golden** (Manager/CI) | (CI-getrieben, keine Quell-Owner) | echter Voll-Build 2^17 ueber neue Kette (4 Sys-Perms × 4 Chunks); new-golden All-17-XML, N=2^17 | `test_reflect_versions_all17` + **CRC64 0xF1C1F26A1232073B**; POD/ABI-Diff-Checkpoint |
| **A2 P-SYSREG** (Planer/Parser-Owner) | `.../measurement/system_axis_registry.xml`, `.../measurement/measurement_axis_registry.hpp`, `.../validate_profile.hpp`, `.../xml_config_parser.cpp` | 6/7 System-Achsen als Registry-ANGEBOT; Konsumenten (validate/parser/mess-Registry) verdrahtet | validate akzeptiert System-Achsen-XML; golden-neutral |
| **A3 P-INFRA** (Infra) | `.gitlab-ci.yml` (avx512-Jobs 677-688), `.../artifact_transport/artifact_cache.hpp` (:59/:149-157 env-gated) | **PAT-Rotation #327 (Security, dringend)**, avx512-Anschluss-Increment (ausgeklammert, blockt Band-A nicht), Ebene-B env-gated vorbereitet | Vault-PAT rotiert; avx512-Job gruen ODER als BAND-D geparkt |
| **A4 P-HYBRID** (cont.) | (eigene builder/-Unterverzeichnisse) | Spline-Break-Even-Logik verfeinern | ctest |

**Agenten-Zahl: 4.** **Koordination:** A3 editiert die avx512-YAML-Region NACH dem in S1 gelandeten GN_TOTAL-Edit (selbe Datei, disjunkte Region, Manager merged). A2 editiert den Parser-Header NACH P-OBS (S1) -> Owner-Serialisierung eingehalten.
**Gate:** **USER-GO fuer ABI/golden-Regen-Fenster (Gate b)** VOR Start; danach CI hart gruen + golden-CRC verifiziert + Dual-Push. **Deadline-Gate 24.07.: Voll-Build muss durchlaufen.**
**Blockiert-durch:** S1 (P-TOTAL-Forward + P-OBS-Reklass sind Voraussetzung des Fensters).

---

### S3 — P-RESOLVER: Registry-Resolver-Stufe (BAND-A -> B)

**Ziel:** Registry=ANGEBOT / Anwender-XML=ANZEIGE(.pom); die Resolver-Vorstufe im Director (`PlanRegistryTrioAnnotation`) zum vollen 5-tiefen Resolver ausbauen. **Band A/B-Grenze.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 P-RESOLVER** (Planer-Owner) | `.../experiment_plan_director.hpp` (:6/:30/:49/:67-79), `.../experiment_tree/registry_to_axis_levels.hpp`, `.../experiment_tree/profile_to_tree.hpp`, `.../validate_profile.hpp` | 5-tiefer Resolver Organ/System/Mess; `registry_to_axis_levels` + `profile_to_tree`-Ausbau | ctest Resolver-Roundtrip; validate |
| **A2 P-KONFORM** (Fehlerklassen-Rest) | (Rest aus S1, falls offen: Fehlerklassen-Pflicht je Achse) | SampleStatus-Split INC-29.3-Rest | ctest |
| **A3 P-HYBRID** (cont.) | (eigene builder/) | Selektor gegen Achsen-Schema anschliessen | ctest |

**Agenten-Zahl: 3.** **Koordination:** A1 baut `profile_to_tree.hpp` auf dem in S1 gelandeten P-KONFORM-#1-Fix (:82) auf — deshalb S1 zuerst.
**Gate:** cf22 + ctest + super-Sub-Build + Dual-Push + CI hart gruen.
**Blockiert-durch:** S2 (P-SYSREG-Angebote muessen stehen, bevor der Resolver sie aufloest).

---

### S4 — Schema + P-MESSTOOL: Mess-Tooling-HAUPT-Auffaecherung (BAND-B, kritisch)

**Ziel:** Schema `<measurement_tooling>`(Haupt) + `<run_methodology>`(Unter) + `measurement_combos_of` ueber {Wallclock/Makro/Micro} auffaechern (N `ceb:build:[a,b,c]`-Strecken statt heute nur `[all]`); 16 `<measurement_categories>` bleiben reine CSV-Spalten. **Band B.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 P-MESSTOOL** (Planer/Parser-Owner) | `.../experiment_plan_director.hpp` (:958-965), `.../planner/plan_legend.hpp` (:69-116), `.../xml_config_parser.{hpp,cpp}` (:253-263), `.../validate_profile.hpp` (:302), `.../profile_run_facade.cpp`, `.../measurement/measurement_axis_registry.{hpp,xml}` | Fan-out N Tooling-Strecken; Schema-POD + Parser + validate + Mess-Registry-Angebot | validate akzeptiert Tooling-XML; `combos_of` liefert N>1 Kombis; **golden-neutral (Punkt 6)** |
| **A2 P-HYBRID** (cont.) | (eigene builder/) | Break-Even=Spline-Schnittpunkt-Logik fertig fuer reale Daten | ctest |

**Agenten-Zahl: 2** (Planer-Kern ist hier fast alleiniger Owner — bewusst schmaler Schritt). **Koordination:** A1 traegt den in S1 gebauten `kMeasurementAxisVersionLine`-Stempel als Mess-Tooling-HAUPT-Wahl (`anatomy_version_stamp.hpp`, nur lesend/verweisend).
**Gate:** Schema-validate + ctest + CI gruen. **binary_id-neutral -> KEIN new-golden-Regen** (Version-Line-Gate bereits in S1 erledigt).
**Blockiert-durch:** S3 (Resolver) + S2 (Mess-Registry-Angebot). **Offene User-Entscheidung noetig VOR S4:** §12-E11 Phasen-Kardinalitaet ≠3 (blockiert Mess-Schema/Validator).

---

### S5 — P-VOLLZUG: sequentieller Mess-Vollzug scharf verdrahten (BAND-B, kritisch)

**Ziel:** `emit_measure_job` real verdrahten (heute nur `when:manual`-Echo-Skelett, `COMDARE_RUN_MEASURE` auskommentiert); `run_methodology='Messen'`=1-Thread steuert `CMAKE_BUILD_TYPE` (heute statisch Release), Workload-Sweep ycsb_a..f, EIN CSV (§38.b). **Band B.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 P-VOLLZUG** (Planer-Owner) | `.../experiment_plan_director.hpp` (:692-718,:492/:516/:656,:626/:845), `.../experiment_run_entry.hpp`, `Code/02_messung_driver/main.cpp` | scharfes DRIVER/`COMDARE_RUN_MEASURE`-Kommando, 1-Thread-Build-Type, Workload/Dataset-Sweep, EIN CSV zurueck | **measure:smoke gruen CI + bare-metal**; §40.c CMakeGraphBuilder Contract-Test topologie-isomorph |
| **A2 P-HYBRID** (Interface-Finalisierung) | (eigene builder/) | Daten-Einlese-Schnittstelle fuer measure_out/-CSV | ctest gegen Beispiel-CSV |

**Agenten-Zahl: 2.** **Koordination:** A1 teilt `experiment_run_entry.hpp` mit dem Stempel-Cluster (P-W12A3 gelandet, P-W12B geparkt) -> ein Owner-Cluster, hier P-VOLLZUG.
**Gate:** measure:smoke literal `status=success` + super-Sub-Build + Dual-Push. **§41(b) Messfaehigkeits-Nachweis (CI + lokal) = BAND-A-Nachweis, hier scharf gemacht.**
**Blockiert-durch:** S4 (`combos_of` muss N Strecken liefern, sonst kein aufgefaecherter Sweep).

---

### S6 — USER-GO -> 320er-Abgabe-Messlauf + M-4-Sammlung (BAND-B, kritisch)

**Ziel:** Der reale Abgabe-Messdatensatz zur Deadline. Kein Code-Fan-out — Mess-Vollzug + Ergebnis-Sammlung. **Band B.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 320er-Lauf** (Manager/CI, §38.b Ein-CEB-exklusiv) | (Laufzeit, keine Owner) | 320er-VOLL-MESSLAUF -> F2-Regime; Algo-Fehler -> CSV-Zelle "failed"+Log (nie Nullen) | measure_out/-CSVs vorhanden; ceb-measurement-exclusive eingehalten |
| **A2 ergebnis:holen / persist** | `.gitlab-ci.yml` (:1102-1132), measurement/ WRITE-Token | Grandchild-CSVs -> `persist:measurements`; EIN CSV, additiv | CSV-Manifest/Provenance |

**Agenten-Zahl: 1-2** (seriell, mess-korrektheits-getrieben).
**Gate:** **USER-GO-Gate (Gate a)** — `emit_measure_job`/`ergebnis:holen` sind `when:manual`; §15.10-G HART GESPERRT ausser opt-in; kein Auto-Messlauf ohne User-Entscheid.
**Blockiert-durch:** S5 (scharfer Vollzug) + S2 (320er-DLLs muessen gebaut vorliegen: new-golden -> 320er).

---

### S7 — Hybrid-Binary + M-4-Auswertung + Mess->PDF-Rueckschrieb (BAND-B, kritisch)

**Ziel:** Aus den realen 320er-Daten den Hybrid-Spline-Binary bauen (4. Ketten-Glied, ABGABE-PFLICHT), auswerten und E2E ins Overleaf-Git zurueckschreiben. **Band B.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 P-HYBRID final** (Impl) | `.../curve_fit/*`, `.../best_binary_selector/*`, `.../decision_lambda_trees/*` | Spline je Achse aus realen Messdaten; Rueckwaerts-Wahl optimaler Binary/Algo-Saetze; CEB-kompiliert+geladen | **ctest-bewiesen**; DLL-Load Fork A |
| **A2 M-4-Auswertung** (Analyse) | measurement/-Auswertungs-Skripte (sh/CMake, KEIN Python) | Kap.5-Datensatz, dynamische Tabellen/Diagramme | Werte reproduzierbar |
| **A3 Mess->PDF** (Thesis) | Overleaf-Git (Kap.5, dyn. Tabellen) | E2E-Rueckschrieb echter Daten je Messung | §0-DoD6; Kap.5-Gate daten-erfuellt |
| **A4 Anhaenge A/B/E + FF0** (Thesis) | Thesis .tex Anhaenge A/B/E, FF0-Owner | B/E von 4-Zeilen-Stubs zu Voll-Anhang; FF0-Owner benannt | §0-V6.2-G8 |

**Agenten-Zahl: 4** (Code + Analyse + zwei Thesis-Straenge datei-disjunkt).
**Gate:** Hybrid ctest gruen + PDF baut (`.blg`/alphadin geprueft). **Offene User-Entscheidung noetig VOR A1:** §32-F8-3 Break-Even-Option (variant-im-Hybrid / ganze Tier-Binaries hot / Dock-Array mit Verdraengung) — bestimmt Hybrid-Architektur.
**Blockiert-durch:** S6 (reale Messdaten).

---

### S8 — Thesis-PDF-Abgabe (BAND-B End-Gate, 28.07.)

**Ziel:** Abgabe-Blocker G8 raeumen: Anhaenge A/B/E + FF0-Owner + Mess-Manifest/Provenance + #47; PDF hart gruen. **Band B.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **A1 PDF-Endspurt** (Thesis) | Thesis .tex Gesamt, #47 | DoD7 xml->pdf-Voll-Matrix; Mess-Manifest/Provenance | PDF hart gruen, Anhaenge vollstaendig |
| **A2 honest-Gate** (Thesis) | §1-FF1/FF3/FF4 | #162 ≥8 Rang-1-SOTA, PRT-ART Stub-Quarantaene | honest-Gate-Kette erfuellt |

**Agenten-Zahl: 2.**
**Gate:** **End-Gate 28.07.** — PDF hart gruen + Overleaf->GitHub gepusht.
**Blockiert-durch:** S7.

---

### Post-Abgabe (BAND-C ab 01.08. / BAND-D geparkt)

- **P-W12B Stempel-Cache-Key** (`artifact_cache.hpp` cache_key_prefix, YAML GN_PREFIX, `dll_is_current`) — **Infra-#56-gated** (prod-MinIO V91), NICHT auf dem 28.07.-Pfad; relevant fuer N-Messung ab 01.08. Teilt `artifact_cache.hpp`+YAML mit P-INFRA -> serialisieren.
- **new-golden VOLL-MESSUNG** (§14.3-HELD, Pipeline 286, 1-Thread, mehrtaegig, NIE pollen).
- **avx512-Ketten-Anschluss**, **#276 3-ISA-Teilmatrix** (ausdruecklich ALLERLETZTE Aufgabe), **S-7 Deep-Research**, **AP-15 Gattungs-Docks** (user-gated ABI).

---

## Kritischer-Pfad-Markierung

**Auf dem kritischen Pfad zur 28.07. (duerfen NICHT slippen):**
- **S1/A1 P-TOTAL** -> **S2 Voll-Build/new-golden (24.07.)** -> **S4 P-MESSTOOL** -> **S5 P-VOLLZUG** -> **S6 320er-Lauf** -> **S7 Hybrid + M-4 + PDF-Rueckschrieb** -> **S8 PDF-Abgabe**.
- **S1/A2 P-OBS** ist golden-relevant und liegt kritisch VOR dem gemeinsamen ABI/golden-Fenster (S2) — kein telemetry-variierender Messlauf ohne S1/A2.
- **S3 P-RESOLVER** ist Voraussetzung fuer S4 (Resolver loest die Registry-Angebote auf), liegt damit ebenfalls auf dem Pfad.

**Nebenstraenge, die parallel mitlaufen (Slip toleranter):**
- **P-HYBRID-Scaffolding** (S1-S5) laeuft datei-disjunkt vor; nur die **finale** Hybrid-Stufe (S7) ist hart daten-gated und ABGABE-PFLICHT.
- **P-KONFORM** (S1/S3), **P-INFRA-avx512** (S2, als Anschluss-Increment ausklammerbar), **P-W12A3** (S1, klein).
- **P-SYSREG** (S2) parallel zum Voll-Build.
- **P-W12B, new-golden-Voll-Messung, #276, avx512-Kette** — bewusst **nach Abgabe**.

---

## Gates & Entscheidungen

**CI-hart-gruen-Checkpoints (nach JEDEM Schritt, Gate c):** gesamte Pipeline ce+super, prod1+prod2, alle Stages, literal `status=success`, beide Remotes ref-gleich. Integrations-Kadenz je Schritt: **cf22 clang-format + ctest + Mojibake-Check + super-Sub-Build + Dual-Push (origin=gitlab, github) + CI-gruen**.

**USER-GO-Punkte (bindend):**
- **Gate a — VOR S2 und VOR S6:** explizites User-Bau-Release je Bau-Phase; der 320er-Messlauf ist `when:manual` HART GESPERRT.
- **Gate b — VOR S2:** das EINE koordinierte ABI/golden-Regen-Fenster nur mit GO (P-OBS golden-relevant + Version-Line-sizeof aus S1).

**ABI/golden-Regen-Fenster:** genau EINES (S2), mit `test_reflect_versions_all17` + CRC64 0xF1C1F26A1232073B + POD/ABI-Diff-Checkpoint. Das Version-Line-Gate in S1 (kMeasurementAxisVersionLine reisst `static_assert(sizeof==1272)`) ist ein KLEINES ABI-Gate, kein voller Regen (binary_id bleibt Organ-only). S4/P-MESSTOOL ist golden-neutral.

**Mess-Exklusivitaet (Gate d):** in S6 NUR EINE messende CEB gleichzeitig (ceb-measurement-exclusive); paralleler BAU bleibt erlaubt.
**Daten-Doktrin (Gate e):** Messung nie als Nullen abschalten (Fehler -> CSV "failed"+Log); Backups additiv; vor `rm -rf build` tracked Mess-CSV pruefen.

**Offene User-Entscheidungen, die VOR bestimmten Schritten geklaert sein muessen:**
- **VOR S4:** §12-E11 Phasen-Kardinalitaet ≠3 (blockiert Mess-Schema/Validator).
- **VOR S7/A1:** §32-F8-3 Break-Even-Option (bestimmt Hybrid-Binary-Architektur, ABGABE-PFLICHT).
- **Terminierbar/geparkt:** §20.B SIMD-Gate ISA-Pinning sofort vs. #276; §21.D 3 Kern-Library-Punkte (near-TABU); ce development->main FF-Merge-Timing; §26 Forks-Register-D (Storage-/Mess-CSV-Policy) — geparkt bis Messlauf-Fahrplan sie beruehrt.

---

## Delegations-Strategie

**Agent-Typen je Paket:**
- **Opus-Impl-Agent:** P-TOTAL, P-SYSREG, P-RESOLVER, P-MESSTOOL, P-VOLLZUG (Planer-Kern), P-W12A3, P-HYBRID, P-W12B — Implementierung (§ Impl->Opus-4.8; Fable=Architekt).
- **Konformitaets-Agent:** P-KONFORM (build-i2 stale-rot, Fehlerklassen, Quick-Wins), honest-Gate (S8/A2).
- **Infra-Agent (autonom, Vault):** P-INFRA (PAT-Rotation, avx512, Ebene-B), 320er-Lauf-Orchestrierung (S6), ergebnis:holen/persist.
- **Explore/Analyse-Agent:** M-4-Auswertung (S7/A2), Break-Even-Klaerung vorab (ultracode aus Doku/Ledger).
- **Thesis-Agent:** Mess->PDF, Anhaenge A/B/E, PDF-Endspurt.

**Owner-Regeln fuer geteilte Dateien:**
- **`experiment_plan_director.hpp` + `validate_profile.hpp` + `xml_config_parser.*`** = **EIN Planer/Parser-Owner-Rolle**, strikt sequentiell ueber S1(P-OBS-Parser) -> S2(P-SYSREG) -> S3(P-RESOLVER) -> S4(P-MESSTOOL) -> S5(P-VOLLZUG). Nie zwei gleichzeitig im selben Header.
- **`.gitlab-ci.yml`** = EIN YAML-Owner (Manager) fuer regionsgetrennte Edits P-TOTAL(GN_TOTAL) / P-INFRA(avx512, GN_PREFIX-Spiegel) / P-W12B(GN_PREFIX, spaeter).
- **`experiment_run_entry.hpp`** = EIN Stempel-Cache-Cluster-Owner: P-W12A3 (S1) -> P-VOLLZUG-Nutzung (S5) -> P-W12B (post-Abgabe).
- **`profile_to_tree.hpp`** = P-KONFORM (#1-Fix, S1) VOR P-RESOLVER-Ausbau (S3).
- **`anatomy_version_stamp.hpp`** = P-W12A3 setzt (S1), P-MESSTOOL liest/verweist (S4).

**Kollisionsvermeidung:** Der Manager **integriert je Schritt selbst** (kein Cross-Agent-Merge). Innerhalb eines Schritts sind alle Pakete **paarweise datei-disjunkt** (verifiziert gegen die Kollisionsmatrix); kollidierende Pakete stehen in **aufeinanderfolgenden** Schritten. Jeder Agent liest VOR seinem TODO erst das Ledger, dann die themenrelevanten Plandocs (ultracode), nie raten.

---

## Risiken & Fallbacks

**R1 — Mess-Vollzug-Komplexitaet (S4+S5, hoch):** Schema-Auffaecherung + scharfe `emit_measure_job`-Verdrahtung + 1-Thread-Sweep + EIN-CSV sind der dickste unerledigte Block und liegen direkt auf dem Pfad zur 28.07. *Fallback:* Auffaecherung auf **einen** Tooling-Pfad (Wallclock) reduzieren statt {Wallclock/Makro/Micro} voll — der 320er-Lauf ist dann schmaler, aber real und abgabefaehig; Makro/Micro als additive Spalten ab 01.08.

**R2 — ABI/golden-Bruch (S1/S2, hoch):** kMeasurementAxisVersionLine reisst sizeof-Assert; P-OBS-Reklass ist golden-relevant; ein Fehlbau im Fenster kostet den 24.07.-Nachweis. *Fallback:* Version-Line-Gate strikt als **kleines** Gate isolieren (binary_id Organ-only bleibt CRC-neutral); bei golden-Bruch auf den letzten gruenen ABI-Snapshot zurueck, P-OBS additiv nachziehen — golden-Regen ist EIN kontrolliertes Fenster, nicht pro Agent.

**R3 — Storage-Infra-gated (P-W12B / Ebene-B, mittel):** prod-MinIO V91 ist #56/#72-gated und NICHT vor 28.07. verfuegbar. *Fallback:* Bereits so eingeplant — **P-W12B strikt nach Abgabe** (BAND-C); der 28.07.-Pfad nutzt den vorhandenen env-gated Cache ohne Ebene-B. Kein Deadline-Impact.

**R4 — Zeit / Ketten-Stau am Planer-Kern (durchgehend, hoch):** S3->S4->S5 serialisieren zwingend auf denselben Header; Slip eines Schritts schiebt alle folgenden. *Fallback:* P-RESOLVER auf einen **minimalen 3-tiefen Resolver** (Organ/System/Mess-Roundtrip ohne volle 5-Tiefe) kappen, damit S4 nicht wartet; volle 5-Tiefe als post-Abgabe. Hybrid (S7) ist ABGABE-PFLICHT -> **minimale Baseline** aus realen Daten (eine Achse, ctest-bewiesen) genuegt der Pflicht, Spline-Vollausbau ab 01.08. Nebenstraenge (P-HYBRID-Scaffold, P-KONFORM, P-INFRA-avx512) parallel vorziehen, um Kern-Owner-Leerlauf zu fuellen.