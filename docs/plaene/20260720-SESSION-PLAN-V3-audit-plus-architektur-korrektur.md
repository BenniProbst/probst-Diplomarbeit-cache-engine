# SESSION-PLAN V2 — Sequentielle Ausfuehrung der offenen Diplomarbeit-Arbeit, VOLL erweitert (2026-07-20, ZUR FREIGABE)

> **V2-HINWEIS:** Identische Kopie des freigegebenen S1-S9-Plans (`docs/plaene/20260720-SESSION-PLAN-ausfuehrung-offene-arbeit.md`, §49-freigegeben, bleibt als Snapshot unveraendert erhalten), erweitert+korrigiert durch den reichen Planungsdurchlauf wf_a612d2db (6 Analyse-Reader -> Architekt-Synthese; B1-B15/§51 + §52 + vergessene Straenge letzte 2 Tage). Die Erweiterung/Korrektur steht im Block **PLAN-V2-ERWEITERUNG** unten (Abschnitte A-E). S1-S9 = unveraendertes Grundgeruest; Fehlannahmen sind in Abschnitt A (D0-D6) gelistet und gelten VOR den S1-S9-Originalzeilen. **User-Klaerungen bindend:** Q2 alles voll + parallele Straenge hinter der Zwischen-Abgabe (28.07.=Zwischenstand); Q3 ISA-Fork-A additiv, Alt-Ausbau=Pflicht-Schluss; Q4 Gattungs-ABI = 2-Stufen-Fenster hinter golden-Fenster.

> Ultracode-Synthese (Grundgeruest wf_c8314fe7: 3 Analyse-Reader Datei-Disjunktheit/Abhaengigkeit/Deadline -> Architekt-Plan; V2-Erweiterung wf_a612d2db: 6 Reader -> Architekt). Grundlage = **§48-Kernblock (437) + §50-Nachtrag (~40 vergessene Features) = ~477 Ziele**, geschaerft durch §51/§52. Prinzip: sequentielle Schritte entlang der Abhaengigkeitskette, je Schritt disjunkte Arbeit auf max ~5-6 parallele Agenten; Planer-Kern hat 1 Owner (streng sequentiell). Manager integriert je Schritt (cf22+ctest+Mojibake+super-Sub-Build+Dual-Push+CI-gruen).

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
**Gate:** Hybrid ctest gruen + PDF baut (`.blg`/alphadin geprueft). **§32-F8-3 ENTSCHIEDEN (§49 + Korrektur):** Option 1 (std::variant im Hybrid-Tier-Binary) ist **LIMITIERT freigegeben** — variant NUR fuer abweichende **Unter-Pruef-Dock-Typen/-Vertraege**, eingebunden per **Abstract-Factory-Methode**; NICHT fuer die Haupt-Observer-Kommunikation (die bleibt statisch IObservableTier/Pruef-Dock, kein variant). Plus Option 3 (Dock-Array multipler Tier-Binaries hot an multiplen Docks + Verdraengungs-Strategie, Speicher-Heuristiken WEB-recherchiert). Praezisierung s. S9.
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

- **P-W12B Stempel-Cache-Key** (`artifact_cache.hpp` cache_key_prefix, YAML GN_PREFIX, `dll_is_current`) — **Infra-#56-gated** (KORREKTUR §51-B5/B6: Ebene B = dev-MinIO V90 / Ebene C = prod-NFS V91, #72-Kopplung gestrichen; s. Abschnitt C S14), NICHT auf dem 28.07.-Pfad; relevant fuer N-Messung ab 01.08. Teilt `artifact_cache.hpp`+YAML mit P-INFRA -> serialisieren.
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

**R1 — Mess-Vollzug-Komplexitaet (S4+S5, hoch):** Schema-Auffaecherung + scharfe `emit_measure_job`-Verdrahtung + 1-Thread-Sweep + EIN-CSV sind der dickste unerledigte Block und liegen direkt auf dem Pfad zur 28.07. **UMGEDEUTET (§49-User-Entscheid): KEINE Reduktion — kompromisslos ALLE Messmethoden {Wallclock/Makro/Micro} + Observer-Prüfdock-Bestandteile voll durchziehen (s. S9).** *Fallback bei Zeitnot:* NICHT die Methoden reduzieren, sondern den 320er-Umfang (weniger binary_ids), aber immer mit vollem Mess-Tooling — Vollstaendigkeit der Methoden hat Vorrang.

**R2 — ABI/golden-Bruch (S1/S2, hoch):** kMeasurementAxisVersionLine reisst sizeof-Assert; P-OBS-Reklass ist golden-relevant; ein Fehlbau im Fenster kostet den 24.07.-Nachweis. *Fallback:* Version-Line-Gate strikt als **kleines** Gate isolieren (binary_id Organ-only bleibt CRC-neutral); bei golden-Bruch auf den letzten gruenen ABI-Snapshot zurueck, P-OBS additiv nachziehen — golden-Regen ist EIN kontrolliertes Fenster, nicht pro Agent.

**R3 — Storage-Infra-gated (P-W12B / Ebene-B, mittel):** Ebene-B dev-MinIO V90 / Ebene-C prod-NFS V91 ist #56-gated (KORREKTUR §51-B5/B6: #72-Kopplung gestrichen) und NICHT vor 28.07. verfuegbar. *Fallback:* Bereits so eingeplant — **P-W12B strikt nach Abgabe** (BAND-C); der 28.07.-Pfad nutzt den vorhandenen env-gated Cache ohne Ebene-B. Kein Deadline-Impact.

**R4 — Zeit / Ketten-Stau am Planer-Kern (durchgehend, hoch):** S3->S4->S5 serialisieren zwingend auf denselben Header; Slip eines Schritts schiebt alle folgenden. *Fallback:* P-RESOLVER auf einen **minimalen 3-tiefen Resolver** (Organ/System/Mess-Roundtrip ohne volle 5-Tiefe) kappen, damit S4 nicht wartet; volle 5-Tiefe als post-Abgabe. Hybrid (S7) ist ABGABE-PFLICHT -> **minimale Baseline** aus realen Daten (eine Achse, ctest-bewiesen) genuegt der Pflicht, Spline-Vollausbau ab 01.08. Nebenstraenge (P-HYBRID-Scaffold, P-KONFORM, P-INFRA-avx512) parallel vorziehen, um Kern-Owner-Leerlauf zu fuellen.
---

## S9 — Mess-Methoden VOLL + Observer-Prüfdock-Bestandteile (§49, ultracode-präzisiert; speist S4/S5/S6/S7)

**Ziel (User §49, kompromisslos):** Die Mess-Tooling-HAUPT-Achse trägt ALLE Messmethoden {Wallclock · Makro-Benchmarks · Micro-Benchmarks über Observer} + die Observer-Prüfdock-Bestandteile (selektiv einkompilierte IObservableTier-Observer + Prüf-Dock-Mechanik) — KEINE Reduktion. Zusätzlich Option-3-Verdrängungs-Strategie für das Hybrid-Dock-Array (S7) web-recherchiert.

**Einordnung im Plan:** S9 ist KEIN zeitlich neunter Schritt nach S8, sondern die **Design-Präzisierung, die VOR S4 geklärt sein muss** und in S4 (Schema/Auffächerung), S5 (Vollzug: welche Observer/Methoden je Lauf), S6 (320er-Umfang) und S7 (Hybrid-Dock-Verdrängung) einfließt. Wird per ultracode-Workflow präzisiert (läuft), Ergebnis als Bauplan-Dokument.

**ultracode-Präzisierungs-Umfang (Workflow):**
1. **Mess-Tooling-Voll-Katalog** — Wallclock / Makro-Bench / Micro-Bench: welche existieren im Code (IObservableTier, observe_all, tier_observe, PMC), was fehlt je Tooling-Variante; wie selektiv einkompiliert (§32-F7).
2. **Observer-Prüfdock-Bestandteile** — welche Observer (Achsen-Observer, Segment-Timing, PMC-Counter), wie ins Prüf-Dock (PruefDock/IPruefDock, dock-Mechanik), prüfdock-kompatible Einkompilation in die Tier-Binaries. **§49-Korrektur:** Haupt-Observer-Kommunikation = statisch IObservableTier (kein variant). Die **Unter-Prüf-Docks mit abweichenden Typen/Verträgen** werden per **Abstract-Factory-Methode** eingebunden; die std::variant (limitiert §23-Ausnahme) ist NUR der Typ-Träger dieser abweichenden Vertrags-Varianten — Factory-Design + variant-Scope präzisieren.
3. **Speicher-Verdrängungs-Heuristiken (WEB-Recherche)** für das Hybrid-Dock-Array (Option 3): LRU/LFU/ARC/CLOCK/2Q/W-TinyLFU etc. — welche für Tier-Binary-Hot-Swapping (große, wenige, workload-korrelierte Objekte) passt; Auswahl mit Begründung.
4. **Schema-Konsequenz** — wie die vollen Mess-Methoden in `<measurement_tooling>` (S4) enumeriert werden; wie die Ablaufmethodik {Debug/Messen/Release} sie an-/abschaltet.

---

## PLAN-V2-ERWEITERUNG 2026-07-20 (B1-B15 + vergessene Straenge, VOLL) — Grundsatz: voll planen, nichts auslassen, 28.07.=Zwischen-Abgabe

> Architekt-Synthese aus 6 Analyse-Readern (R1 Korrekturen · R2 ISA/Meta-Meta · R3 NUMA/page_type+S4 · R4 Gattung · R5 vergessene Straenge · R6 Topologie/BAND), gegen IST-Code + Ledger §47-§52 verifiziert. Erweitert und korrigiert das S1-S9-Grundgeruest, ohne es zu ersetzen (Doku nie loeschen — nur additiv/DEPRECATED). **User-Klaerungen bindend:** Q2 = alle grossen Erweiterungen JETZT voll mitgeplant als parallele Straenge HINTER der Abgabe-Kette; Q3 = ISA-Fork-A additiv zuerst, Alt-Ausbau = Pflicht-Schluss; Q4 = Gattungs-ABI = eigenes Fenster direkt hinter dem golden/ABI-Regen-Fenster, 2 sequentielle Stufen im selben Strang. **28.07. = Zwischen-Abgabe, nicht Projektende.**

---

### A. KORREKTUREN an S1-S9 (Fehlannahmen raus)

- **D0 — Ziel-Zahl vereinheitlichen (437 -> ~477).** *Wo:* Zeile 3 (Praeambel „§48-Gesamtblock (437 Ziele)"), identisch in beiden Plan-Dateien. *Alt:* §48 = 437 offene Ziele. *Korrektur:* 437 = §48-Kernstand VOR dem §50-Nachtrag; §50 fuegt ~40 vergessene Features additiv in die §48-Single-Source ein. Formulierung: „§48-Kernblock (437) + §50-Nachtrag (~40 vergessene Features) = **~477 Ziele**, geschaerft durch §51/§52". Beide Plan-Dateien synchron ziehen.
- **D1 — B11: INC-0 DLL-Load / measured=0 ist ERLEDIGT, nicht offen.** *Wo:* S1/A4 P-KONFORM (Z.28) + Delegations-Text. *Alt:* §51-B11 fragte „evtl. ueberholt"; Risiko, den measured=0-Fix als offenen Strang neu einzuplanen. *Korrektur (§52-B11):* measured=0-Fix (mimalloc-Archiv-Link, `mi_*` undefined -> dlopen nullptr) ist **GEBAUT+VERIFIZIERT (ce `418e4b76`, §20.C)** — `nm -D perm.dll` zeigt `mi_malloc_aligned`/`mi_free = T`, 105 echte Messzeilen. NIEMALS als Task einplanen. Der **einzige INC-0-Rest = `build-i2` (smoke/measurement/wdk) stale-rot**, Ursache **Include-Root-Config-Gap** (B2/B4-generated `test_experiment_projection`), **KEIN Code-Regress**. Namensfalle: es existiert ein ZWEITER „INC-0" (18.07. Facade-Entmischung malloc/Flag, `e5eb990f`/`01748163`) — anderes Increment.
- **D2 — B11-Disambiguierung: S7 „DLL-Load Fork A" ≠ INC-0.** *Wo:* S7/A1 P-HYBRID final (Z.121, Verifikation „DLL-Load Fork A"). *Alt:* Verwechslung mit dem erledigten INC-0-DLL-Load. *Korrektur:* Das S7-„DLL-Load Fork A" ist der **echte Laufzeit-DLL-Load** (§48 [§15.3-F-H]/[§15.8-g-F60/F61]) — INC-F war nur die typ-identische In-Process-Vorstufe; der echte Runtime-Load steht **legitim OFFEN** und bleibt kritisch fuer S7. Als eigenstaendig-offen kennzeichnen, damit die B11-Erledigt-Klaerung ihn nicht faelschlich mit-abhakt.
- **D3 — B13: 9dim-Fixes 7/7 erledigt, nur 2 Prosa-Drifts.** *Wo:* S1/A4 (Z.28), S3/A2 „Fehlerklassen-Rest" (Z.61), §48-Konformitaet-Zeile „9-Dim (4/9)". *Alt:* 9dim-Konformitaet teilweise offen; Fehlerklassen-Framework als groesserer Rest. *Korrektur (§52-B13):* **G4/G5/G8/G9/G10 = 7/7 im IST-Code erledigt** (G5-ToolchainFehlt-Emitter real vorhanden trotz 07-19-Register; a1a2-Verzeichnis-Zyklus gebrochen; Fehlerklassen #29 `axis_error.hpp` CompilerCompiler vs Infra DISJUNKT + `BuildError=variant` + Drift-Guards = fertig). Verbleibender Rest = **nur 2 unkritische Prosa-Drifts (kein ABI):** (a) G8 „19"-History-Zeilen in `memento_aggregate.hpp:99` + `composition_factory.hpp:52`, (b) a1a2 nicht-umbenannter `builder::experiment`-Namespace in `harness/perm_runner.hpp:45` (+ stale „NAECHSTES"-Vermerke #45 in Ledger §21-§24). S1/A4 + S3/A2 **verschlanken** (nicht das Fehlerklassen-Framework neu bauen). Abgrenzung: `SampleStatus-Split` (INC-29.3, Z.61) und `SampleStatus Failed->"failed"` (CSV-Sichtbarkeit, Z.28) sind **eigene** Items, NICHT Teil des erledigten #29-Kerns — bleiben legitim offen, sauber getrennt.
- **D4 — B14: §38 STRUKTUR erfuellt, nur 3 Kettenlauf-Reste (nicht pauschal „offen").** *Wo:* S5 (Z.87/91), S6/A1 (Z.106). *Alt:* §38/§38.b Dock-Serialisierung pauschal „OFFEN, hoch". *Korrektur (§52-B14):* STRUKTUR **ERFUELLT (ce `d7d35c36`):** beide PODs, R5-XML-Serialisierung + Byte-Roundtrip-Gate, mixed-radix-Delta, Live-Feuerung in beiden Walks (`cache_engine_builder_iterator.hpp:808-820/839-840/1061-1066`), `resource_group: ceb-measurement-exclusive` an den **statischen** Mess-Jobs (`.gitlab-ci.yml:501/579`) + P11-pgrep-Preflight. Statt „offen" die **3 Kettenlauf-Reste** verankern (s. Abschnitt B, S5-Delta).
- **D5 — B10: page_type NICHT als neue/dynamische Achse.** *Wo:* geplante S11 + §48-Mess-Kette (in S1-S9 keine Fehlannahme; Grep bestaetigt page_type/AllocPageHint fehlen dort). *Alt (§51-B10):* page_type „vermutlich System-Unter-Achse unter ISA, dynamisch, CPU wechselt". *Korrektur (§52-B10):* **KEINE dynamische CPU-Umschaltung, KEINE neue Achse.** page_type = Allokations-Zeit-Eigenschaft (MAP_HUGETLB, unveraenderlich pro Mapping) bzw. asynchrone Kernel-VM-Politik (THP-Hint). Ist-Code bereits korrekt zweigeteilt: RAUM=System (`axis_12_general_hardware`, HW4 `page_topology_tag` + `huge_page_capable()`/`memory_page_size()`) -> DURCHSETZUNG=Organ (`axes/alloc/alloc_hw_config.hpp` `AllocPageHint{Native,Page4k,Page2m}`, `if constexpr`-gegated). Handlung = **anerkennen+benennen**, kein Bau-Block. Namensfalle strikt: `axis_01_page_type` (Baum-Knoten-STRUKTUR, `PageKind`) ≠ HW-Page; die HW-Page bleibt `page_topology`/`AllocPageHint`, darf NICHT `page_type` heissen. KEIN S-Schritt fuehrt page_type als 7. System-Haupt-Achse oder dynamische ISA-Unter-Achse ein.
- **D6 — §50-K-5-Drift an Hybrid-Selektor (best_binary_selector ABI-Spiegel stale).** *Wo:* S1/A5 (Z.29) + S7/A1 (Z.121), beide Owner von `best_binary_selector.{hpp,cpp}`. *Alt:* Selektor-Interfaces nur „ohne reale Daten" — Provenienz-Korrektheit nicht adressiert. *Korrektur (§50 K-5, hoch/Daten-Korrektheit):* `best_binary_selector` ABI-Spiegel ist **stale** (`kAbiMajor=5`/`.A5.` vs Host `6`) -> schreibt **falsche Provenienz** in den Abgabe-Binary. In S1/A5 als Deliverable ergaenzen: Paritaets-`static_assert` nachziehen (kAbiMajor Host-6-synchron), BEVOR der Selektor in S7 reale Binary/Algo-Saetze waehlt. **Daten-korrektheits-kritisch fuer den Abgabe-Hybrid -> vor S7 ziehen (BAND-A).**

**Konsistenz-Pruefung (Auftrag verlangt):**
- **S1/A4 (build-i2):** im Kern korrekt (stale-rot, kein Code-Regress) — nur um B11-Ursache (Include-Root-Config-Gap) + „INC-0 measured=0 = done (418e4b76)" schaerfen (D1).
- **Mess-Kette-Zeilen (S4/S5/S6):** spiegeln §47/§48 korrekt, ABER §38-Aufloesung fehlt — die 3 B14-Reste (D4) konkret in S5 (+S3/S4) verankern statt §38 pauschal offen zu fuehren; dynamische `ceb-measurement-exclusive` neu als S5-Deliverable.
- **B12/B2/B3 (kein S1-S9-Delta):** F-SPREAD (B12) -> S2-new-golden bleibt korrekt auf **first-2** (CRC64-Fixture gelandet); Max-Kontrast = optionaler INC-G7 post-Abgabe (S2 braucht KEINE Korrektur). B2 (Gattung)/B3 (Meta-Meta) betreffen ausschliesslich die neuen S10/S12, nicht S1-S9.

---

### B. SCHAERFUNGEN bestehender Schritte

- **S4-Delta (B9 Thesis-Profile, ON PATH, BAND-B):** WAS/WIE-Trennung vollstaendig als Schema + Werkzeuge je Stufe (§52-B9).
  - **Neue Schema-Elemente** (in ThesisProfile UND ExperimentProfile): **D1** `<measurement_tooling>` (HAUPT, CT, fan-out) `{wallclock,macro,micro}`; Angebot = `collector`-Achse in `measurement_axis_registry.xml`, promotet von CSV-`binary_id="never"` zu Fan-out-HAUPT; **binary_id-relevant** nur ueber den Version-Line-Stempel (Gate bereits in S1). **D2** `<run_methodology>` (UNTER, an CEB delegiert) `{debug=parallel, measure=1-thread, release=ohne-Messsystem}`; typisiert die TODOs in `measurement_axis_registry.xml:55-56`; never. **D3** `<measurement_framework>` + Workload-Delegation (UNTER der Tooling-HAUPT) `framework={ycsb}` + `workloads={ycsb_a..f}` + `<datasets>`; Angebot = `load_framework`-Achse (`YcsbLoadFrameworkAxis`, stage=runtime); never.
  - **Werkzeuge je Stufe (B9-Kern):** **PLANER** (1 Owner, seriell): `measurement_combos_of` REWORK (director:958-965 — heute `size==1 [all]`; NEU: ueber `<measurement_tooling>` auffaechern -> N Combos = N CEB-Strecken; `combo.categories` bleibt reine 16-CSV-Projektion; `perm_count`-Walk :980-999 multipliziert je Tooling-Strecke). Parser (`xml_config_parser.hpp/.cpp:253-263`): neue POD-Felder `measurement_tooling` (vector), `run_methodology` (enum), `framework`+`workloads`. `validate_profile.hpp:302`: gegen Mess-Registry-Angebot (tooling ∈ collector, methodology ∈ {debug,measure,release}, framework ∈ load_framework); KEIN Parallel-Validator/Python; Byte-Roundtrip. `PlanMeasurementCombo`/`plan_legend.hpp:69-116`: Feld `tooling_id` + Version-Line-Stempel; Legende rendert Tooling statt `[all]`; `build_version_suffix` bekommt `+msys=<tooling>` (analog `+opt=`/`+ext=`). **CEB:** empfaengt `run_methodology` -> setzt `CMAKE_BUILD_TYPE` (ersetzt statisches Release director:492/516/656); kompiliert gewaehlte Tooling-HAUPT selektiv ein (§32-F7, pruefdock-kompatibel, S9-Katalog); delegiert Workload-Sweep an Tier-Lauf. **TIER-BINARY:** traegt einkompilierte Observer, laeuft Workload-Sweep (1-Thread in measure); emittiert 16 `measurement_categories` als CSV-Spalten (WAS), getaggt mit Tooling-Identitaet (WIE) + Version-Line-Stempel; Fehler -> Zelle `"failed"`+Log. **REGISTRY:** `measurement_axis_registry.xml` collector = Tooling-HAUPT-Angebot; `run_methodology` als typisierte UNTER-Sub-Achse (loest TODOs :55-56); 16 Kategorien bleiben CSV-only. `system_axis_registry.xml`: `load_framework` (ycsb+workload) Delegations-Semantik ausbauen. **THESIS-XML-PROFILE:** jedes Profil (`all_axes_golden`, `m3v2_study`, `fb_numa_page_study`, `cacheline_study`, `ff2_node_width_study`, `m3v2_sota_pilot`, `m3_smoke/golden_coverage`) bekommt `<measurement_tooling>`+`<run_methodology>`+`<measurement_framework>`; `all_axes_golden` = Voll-Tooling `{wallclock+macro+micro}`; `m3_smoke` = `wallclock`-only.
  - **S4-Gate unveraendert:** Schema-validate + ctest + CI-gruen; **binary_id-neutral -> KEIN new-golden-Regen** (Version-Line-`static_assert` bereits als KLEINES ABI-Gate in S1). **Kopplung S9:** D1 (`micro`-Tooling) selektiert, welche IObservableTier-Observer + Pruef-Dock-Bestandteile einkompiliert werden (Haupt-Observer statisch; Unter-Pruef-Docks per Abstract-Factory + eng-begrenztem std::variant, §49). **Offene User-Entscheidung VOR S4:** §12-E11 Phasen-Kardinalitaet ≠3.

- **S5-Delta (B14 §38-Reste, BAND-B):** die 3 Kettenlauf-Integrations-Reste als konkrete Teilaufgaben verankern (statt §38 pauschal offen):
  - **Rest (1) — ProgressSink ohne echten Konsumenten:** feuert live ins No-Op; Planer-seitige Sequenzierungs-Logik fehlt -> verankern in **S3 (P-RESOLVER/Planer-Kern)** bzw. S5.
  - **Rest (2) — `ExperimentSubtreePayload` = Struktur+Test-ONLY:** im Kettenlauf ungenutzt (Director emittiert Achsen-Ranges ueber SEPARATEN Pfad `experiment_plan_director:485`) -> in **S4/S5** entscheiden: real emit/parse verdrahten ODER als Dead-Code deprecaten.
  - **Rest (3) — `resource_group: ceb-measurement-exclusive` fehlt am DYNAMISCHEN `emit_measure_job`** (`:692-721`, when:manual-Skelett) -> explizit als **S5/A1-Deliverable** (ergaenzen, sobald §47 scharf schaltet). S6/A1 (Z.106) prueft nur die *statischen* Jobs — die dynamische Exklusivitaet ist neu in S5 zu setzen.

- **S1/S7-Delta (K-5 best_binary_selector ABI-Spiegel, BAND-A, HOCH/Daten-Korrektheit):** s. D6 — Paritaets-`static_assert` (kAbiMajor Host-6) in S1/A5, vor der realen Selektion in S7. Vor S7 ziehen.

- **S7/A2-Delta (M-4 19->17-Achsen-Nachzug super+Thesis, §50 M-4, BAND-B, MITTEL-HOCH):** S1/A2 macht nur `kSegmentCount 20->17` im Parser; **FEHLT:** super-Auswertungsstufen 04/05/08 (`kSegmentCount 20->17`, `has_seg_ns`/`seg_attribution.tex`) + Thesis-Text „neunzehn Achsen"/T-Nummern DE+EN. In S7/A2 (M-4-Auswertung) + Mess->PDF einfalten.

- **S4/S5-Delta (Emitter-Paket: W10-A/-C + W7-A/-B, §50 Mess/§40.b/§40.c, BAND-B, HOCH):** S4 deckt nur die `measurement_combos_of`-Auffaecherung (W10-B-Kern); **FEHLT** und als EIN Emitter-Paket zusammenzulegen: (a) **W10-A dreistufige Legenden-Emission** — Mess-Achsen-Stufe-in-Director-Walk + Legenden-Namensschema-Single-Source + **CEB-Selbst-Emission Stufe-2/Grandchild** (`--emit-tier-ci`/`--emit-tier-cmake` aus Freigaben; Fork-C `.so`-Schnitt `ceb_generator.hpp`) + super `planer:delegate`/`ergebnis:holen`; (b) **W7-A CiYamlBuilder (I3)** = dritter ConcreteBuilder am Director-Walk fuer die zweistufige Child-Pipeline-YAML; (c) **W7-B CMakeGraphBuilder SCHARF (§40.c = §0-DoD5/#193)** — No-Op-COMMANDs -> echte Treiber-Kommandos je Zelle + `MANUAL_RUN.md` + literaler Bare-Metal-Beweis (S5 hat nur den Isomorphie-Contract-Test); (d) **W10-C** MANUAL_RUN.md/Bare-Metal + statische Matrix hinter DEPRECATED-Fallback-Gate. binary_id-neutral. Achtung: beruehrt B4-ISA-Fork-A + B3-Hardware-Array (S10) -> koordinieren.

- **S2/S3-Delta (W8 / §40.a Flag-Signatur-Modell, §50 Mess + §44.4, BAND-B, HOCH):** P-SYSREG/P-RESOLVER beruehren Registry+Resolver, aber NICHT das **required/optional-`<isa>`-Schnitt-Modell**: Organ-Sinnhaftigkeits-Matrix, Resolver-Regeln `required=all`/`optional`, **Maschinen-Signatur-XML vs Organ-Anforderungs-XML**, AVX10-Notation, `organ_required` + `active_machine_signature()`-Host-Wahl. Flags bleiben **binary_id-neutral (D9)**. Beruehrt S10 (B4-ISA-Fork-A + B3-Hardware-Array) -> koordinieren.

- **S3-Delta (CoR-Andockpunkt `run_selection_filter_chain`, §50 Bau + topdown R4, BAND-B, MITTEL):** Dead-Code, 0 Prod-Treffer -> in `resolve_selection` einhaengen (leere Kette = Identitaet, schrittweise mit Provenance-Audit). **Vorsicht:** ResumeFilter darf die Kandidatenmenge NICHT ungewollt reduzieren.

- **S4-Delta (9dim-G3 ThesisProfile-`<system_axes>`-Feld + Baum-Verdrahtung, §50 Konformitaet, BAND-B, HOCH):** `COMDARE_PILOT_*`-ENV-Steuerung entfaellt (Single-XML-Doktrin); stuetzt B9-Thesis-Profile. Owner `profile_run_facade.cpp` + validate.

- **S2-Delta (K-13/INC-G0 Registry-Regeneration + PL-18 3-Registry-Split, §50 Konformitaet/Bau, BAND-B-C, MITTEL):** `cache_engine_axis_registry.xml`-Drift 18/86 -> 17 + system_axis regenerieren; PL-18 physische Aufteilung der 3 Art-Registries in 3 Module.

---

### C. NEUE PARALLELE STRAENGE (nach der Abgabe-Kette, voll geplant)

#### S10 — ISA-Fork-A + Meta-Meta-Achsen + Hardware-Manager-Array + Stempel-System-Erweiterbarkeit

> Grundlage §52-B3 (CRTP+mp11) · §51-B3/B4/Organ-Analogon · §50-OF-1/§37.2-3 · INC-2D-Plandoc (Variante A, GATED) · §40.a. **Q2:** paralleler Erweiterungs-Strang HINTER der Abgabe-Kette. **Q3:** ISA-Fork-A **additiv zuerst**, Alt-Ausbau = **Pflicht-Schluss** am Strang-Ende. Ersetzt/elaboriert den §52-Platzhalter S10 und zieht die B4/INC-2D-gated ISA-Fork-A in denselben Strang.

**Ziel:** Die heute EINE `ExtensionHardwareFamilyAxis` (Familien-String `family_id()` "simd"|"gpu", asymmetrisch) zu einem **Manager-ueber-statisches-mp_list-Array** umbauen: `hardware` = normale statische **Manager-Haupt-Achse**; jeder Erweiterungstyp (AVX512 mit 13-14 Flag-Subsets als Domaene, AVX2, spaeter GPU/FPGA/NPU) = eigene Haupt-Achse = **Meta-Meta-Achse** unter dem Manager. `mp_for_each<Manager::extensions>` wird **Single Source** -> Hinzufuegen eines Typs propagiert automatisch in Registry-XML, Stempel und Bau-Gate (= B4-„System-Erweiterbarkeit"). Symmetrisch: dasselbe Manager-Muster fuer die **ISA-Achse (Fork-A, Freigabe-Haupt-Achse, cross-compile-erweiterbar)** und als **Organ-Analogon** (Manager ueber Organ-Haupt-Achsen-Array + Fold-abgeleitete, NICHT hardcodierte Stempel fuer den CEB-materialisierten compile-Raum). Alles CT-statisch, 3 CRTP-Ebenen empty/!is_polymorphic, static-dispatch, keine vtable (§9). Abschluss: isa-Alt-Organ-Pfad (binary_id-Permutation) + alter Familien-String-Knoten **ausgebaut/DEPRECATED** (Q3).

**Interne Sequenz (3 Stufen, additiv -> additiv -> Ausbau).**

**Stufe 1 — Manager-Typsystem + ISA-Fork-A (additiv, golden-neutral)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **M1 Manager-CRTP-Typsystem** | NEU `measurement/extension_hardware_axis.hpp` (Ebene A `ExtensionHardwareAxis<Derived>`: extension_id/feature_domain/stamp_version), NEU `measurement/hardware_manager_system_axis.hpp` (Ebene B `HardwareManagerSystemAxis<Derived>` : `CebSystemAxis`, label "hardware", `using extensions = mp11::mp_list<...>` + `mp_for_each`), NEU `measurement/meta_meta_axis_concept.hpp` (Ebene C `MetaMetaAxisConcept<A,Mgr>`), NEU `measurement/avx512_extension_axis.hpp` (`Avx512ExtensionAxis`, feature_domain=13-14 avx512-Flags aus `simd_feature_flag.hpp`), NEU `measurement/avx2_extension_axis.hpp` | 3 CRTP-Ebenen + 2 konkrete Meta-Meta-Achsen; Manager traegt das mp_list-Array; `feature_domain()` bezieht NUR Katalog-Flags (Kopplung §40.a) | `static_assert(is_empty_v && !is_polymorphic_v)` je Ebene+Achse; `MetaMetaAxisConcept<Avx512ExtensionAxis, HardwareManager>`; `count_avx512_flags(...)==13/14`; `signature_within_catalog(...)`; ctest |
| **I3 ISA-Fork-A additiv** | NEU `measurement/target_isa_system_axis.hpp` (`TargetIsaSystemAxis<Derived>` : `CebSystemAxis`, label "target_isa"; `X86_64TargetIsa`=Default host==target, `Aarch64TargetIsa`=cross; `target_triple()`/`sysroot()`/`target_march()`), `build_orchestrator.hpp` (:498-538 `make_gpp_compile_fn`-Naht: NEU `perm_target_isa_cflags()` spiegelbildlich zu `perm_extension_hardware_cflags`, eingereiht in `perm_compile_flags()`; Cross-Treiber in `cxx_compiler()`; `+target=`-Sidecar in `system_axes_version_suffix`) | target_isa als **Freigabe-Haupt-Achse** additiv (Variante A); isa-Organ-Typen bleiben Codegen-Traeger; avx*/cx16 degradieren ≤ Ziel-Zulassung; ISA-Achse zieht das Manager-Muster | **golden byte-identisch** bei Default `X86_64TargetIsa`; Cross-Dry-Run zeigt `-target aarch64-linux-gnu`/`--sysroot`; `+target=`-Sidecar gesetzt, **NIE binary_id**; ctest; Mojibake-grep |

Agenten-Zahl Stufe 1: **2** (datei-disjunkt). I3 stimmt das ISA-Manager-Muster mit M1 (Ebene B) ab — gleiche Vorlage generalisiert, KEINE Parallelstruktur.

**Stufe 2 — mp11-Registry+Stempel-Fold + Organ-Analogon (additiv, golden-neutral)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **M2 mp11-Registry + System-Stempel-Fold** | `abi/anatomy_version_stamp.hpp` (`system_stamp_line()` :65-76 — hardcoded `std::array<...,5>` ERSETZEN durch `mp_for_each<HardwareManager::extensions>`-Fold + Freigabe-Haupt-Achsen compiler/target_isa/scheduling/load_framework), `measurement/measurement_axis_registry.hpp` + `measurement/system_axis_registry.xml`-Generatorpfad, NEU `measurement/hardware_extension_gate.hpp` (`mp_for_each`-static_assert = Bau-Gate) | Array = Single Source: Typ hinzufuegen propagiert in Stempel + Registry-Angebot + Bau-Gate OHNE weitere Datei-Edits | Dummy-Extension ins `extensions`-mp_list -> Stempel-Zeile +1, Registry waechst, Gate greift; entfernen -> zurueck; **Byte-Roundtrip** auf Stempel-Format |
| **O4 Organ-analoges Array + Organ-Stempel-Fold** | NEU `measurement/organ_axis_manager.hpp` (`OrganAxisManager` ueber Organ-Haupt-Achsen-`mp_list` der 17 Organ-Achsen), `abi/anatomy_version_stamp.hpp` (`organ_stamp_line<Comp>()` :32-56 — hardcoded 17er-`std::array` ERSETZEN durch `mp_for_each<OrganAxisManager::axes>`-Fold ueber `Comp::<axis>::name()`/`algo_version`) | Organ-Stempel aus Fold statt hardcoded; symmetrisch zum Hardware-Manager (B3-Organ-Analogon) | Fold erzeugt **byte-identische** Stempel-Zeile zum 17er-Array (`test_lazy_adhoc_source_gen` gruen); Dummy-Achse -> +1; sizeof-Gate unberuehrt |

Agenten-Zahl Stufe 2: **2. Koordination (kritisch):** M2+O4 editieren BEIDE `anatomy_version_stamp.hpp` — **disjunkte Regionen** (M2=`system_stamp_line` :65-76; O4=`organ_stamp_line` :32-56), **Owner-Serialisierung**: Manager merged M2 vor O4. M2←M1-`extensions`, O4←M1-Manager-Muster.

**Stufe 3 — Alt-Ausbau-Pflicht-Schluss (Q3, GO-gated ABI/golden-Fenster, 1 Owner streng seriell)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **X5 Alt-Ausbau-Pflicht-Schluss** | **(a) isa-Herausloesung/INC-2D:** `kCompositionAxisNames` (18->17, isa raus), alle 5 `GenusBindingTraits` slot_count 18/12/14/10/6->17/11/13/9/5 + `CompositionFor`-Aritaet -1, `observable_tier.hpp` (:48 `kV3AxisCount` 18->17; :67-103 Schema T11 raus + reindex; sizeof 1344->1272; :154 PODVersion), `abi_adapter.hpp` (`fill_observer_v3` Index-Shift ≥11 um -1), `source_catalog.hpp` (:111 L11 raus, `<4,4,5,4>`=320 unveraendert), `anatomy_module_abi_v1_decl.hpp` (:49 ABI-Major 5->6, :53 MAGIC A5->A6). **(b) Familien-Knoten-Ausbau:** `measurement/extension_hardware_family_axis.hpp` DEPRECATED-markieren; `simd_sub_axis.hpp` `parent_axis_label()` auf Manager umhaengen; DEPRECATED-F-SIMD-Insel weiter deprecaten. **(c) golden-Regen:** `tools/gen_golden_fullpilot/main.cpp` (18->17), Freeze `golden_fullpilot_320_binary_ids.txt`->`_abi5.txt` additiv | isa vollstaendig aus Komposition/binary_id; ABI 5->6; golden messdaten-erhaltend regeneriert; alter Familien-String-Knoten DEPRECATED (NICHT geloescht); Alt-golden additiv `_abi5.txt` | `grep -c 'isa=isa_amd64'` 320->0; `test_reflect_versions_all17`/<17>; `test_profile_roundtrip` Diff==leer; POD/ABI-Diff sizeof 1272; `AbiTransportPods`-Count bleibt 12; CRC64 neu; gemessene CSV UNBERUEHRT; Mojibake-grep; cf22; super-Sub-Build; Dual-Push nach gruen |

Agenten-Zahl Stufe 3: **1** (atomarer compile-gekoppelter Kern-Commit, static_asserts lock-step; golden-Regen ZULETZT, offizieller Generator-Pfad).

**Gesamt-Koordination:** `anatomy_version_stamp.hpp` von M2+O4 disjunkt-regional geteilt -> Manager merged seriell. `build_orchestrator.hpp`-Naht (I3) liegt disjunkt zur avx512-YAML-Region der Abgabe-Kette. **Manager-Muster einmal, dreifach genutzt** (M1-Vorbild -> I3/O4 instanziieren, keine Parallelstrukturen). §40.a-Kopplung: `Avx512ExtensionAxis::feature_domain()` bezieht ausschliesslich Katalog-Flags aus `simd_feature_flag.hpp`/`machine_simd_signature.hpp`. **Agenten-Zahl gesamt: 5** (2 ∥ 2 ∥ 1).

**Gate je Stufe:** cf22 + ctest + Mojibake-grep (Muster == 0) + super-Sub-Build + Dual-Push + CI hart-gruen ce+super/prod1+prod2. Stufe 1+2 **golden-neutral**. **Stufe 3 = USER-GO fuer ABI/golden-Regen-Fenster PFLICHT** (§15.10-G TABU) + POD/ABI-Diff-Checkpoint + golden-CRC verifiziert.

**Blockiert-durch:** Stufe 1 — (Strang-Start; nur vendored `cmake/third_party/boost_mp11/` — verifiziert vorhanden). Stufe 2 — Stufe 1. Stufe 3 (X5) — Stufe 1+2 vollstaendig gelandet + **USER-GO ABI/golden-Fenster**; sollte idealerweise das gemeinsame ABI/golden-Fenster des Haupt-Strangs (S2/INC-2D 5->6) reiten, sonst eigenes GO-gated Fenster. **Nicht Abgabe-relevant.**

**Risiken:** (1) **Resume-Key-Invalidierung (groesstes stilles Risiko, X5):** binary_id=Resume-Key; isa-Herausloesung aendert jede id -> Alt-Mess-CSV/Resume-Stamps matchen nicht; abgefedert durch `_abi5.txt`-Freeze. (2) **abi_adapter Index-Shift (X5, still):** alle `axis_stats`/`seg_ns`-Indizes ≥11 um -1; ein vergessener -> stiller Mess-Versatz; Review Pflicht. (3) **mp11 im measurement-Layer neu (M1/M2):** Include-Pfad/CMake `cmake/third_party/boost_mp11/include` verifizieren; `mp_for_each` bleibt reiner Configure-/CT-Kontext (§9-konform). (4) **Stempel-Byte-Roundtrip (M2/O4):** Fold-Ordnung == kanonische compose-Ordnung erzwingen. (5) **organ_stamp_line BLOCKER-Erbe (O4):** reale AdHocComposition-Achsen tragen name()/algo_version nur ueber Registry-Wrapper -> Fold vorerst gegen name()/algo_version-tragende Typen; reale Modul-Stempel-Metadatenquelle bleibt offene Architektur-Frage (hier nur Fold-Mechanik). (6) **EXCLUDE_FROM_ALL-Falle (X5):** golden-Generator nicht im Standard-Build -> explizit `cmake --build --target comdare_gen_golden_fullpilot`. (7) **Cross-Toolchain (I3):** echter aarch64-Build braucht `aarch64-linux-gnu-g++`+sysroot (Infra-Handover); fehlt -> Compiler-Compiler-Fehlerklasse ins Log, kein Absturz; Default umgeht es.

**BAND:** Stufe 1+2 = **BAND-C (ab 01.08.)**, golden-neutral/additiv -> bei freier Kapazitaet in BAND-B-Slack vorziehbar OHNE Abgabe-Risiko. Stufe 3 (X5) = **BAND-C, GO-gated ABI/golden-Fenster** (Pflicht-Schluss). **Angrenzend:** S11 baut auf demselben Manager-/Freigabe-Muster auf und startet NACH Stufe 1 (gemeinsames `CebSystemAxis`-Manager-Vokabular).

#### S11 — 7. System-Achse NUMA/Locking (B8) + page_type-Anerkennung (B10)

> Grundlage §52-B8/B10 + §51-B8. **Verifikations-Befunde (IST-Code, nicht geraten):** **B8** — `axis_12_general_hardware_generic.hpp:38-39` traegt `numa_capable()`/`huge_page_capable()` als per-Profil-constexpr = Faehigkeits-Deklaration, KEINE Maschinen-Detektion; reale NUMA-Topologie = Laufzeit-Wahrheit (cpuid unzuverlaessig, kanonisch sysfs `/sys/devices/system/node/` + libnuma). `cx16`/`atomic128` IST bereits compile-statisch (Compiler-Sub-Achse); Contention/Granularitaet laufzeit-abhaengig -> **keine 7. compile-statische HAUPT-Achse**; NUMA/Locking = dynamische System-UNTER-Achse unter `target_isa` (stage=runtime, an Tier-Binary delegiert) — exakt das Muster von `AllocNumaNode{auto,0,1}`. **B10** — Ist-Zweiteilung bereits korrekt+vollstaendig (RAUM=System axis_12/HW4 / DURCHSETZUNG=Organ AllocPageHint + `gate_alloc_hw_for<HW>`); KEIN Bau-Block, nur additive Anerkennung + Namensfallen-Aufloesung.

**Ziel:** Die 6 System-Achsen bleiben unberuehrt; NUMA/Locking als **dynamische Laufzeit-Unter-Achse unter `target_isa`** verorten (NICHT 7. Haupt-Achse); parallel die page_type-Zweiteilung **anerkennen+benennen** (kein Bau-Block), Namensfalle aufloesen, FF3-cache-awareness-Kette (dTLB-Reach) verdrahten. **Architektur-Erweiterung HINTER der Abgabe-Kette (Q2); binary_id-neutral.**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **N1 B8-Verifikation** (Analyse, frueh/parallel, read-only Cluster) | (keine Quell-Owner; Ist-Pruefung `/sys/devices/system/node/`, `numactl --hardware`, `/proc/self/status` prod1/prod2) | Verifikations-Notiz „NUMA/Locking = runtime, nicht CT-detektierbar" + **Sub-Achsen-Spec** (numa_bind_policy + lock_regime als runtime-Dims) | sysfs/libnuma-Ist literal dokumentiert; Empfehlung Unter-ISA-Runtime-Achse |
| **N2 NUMA-Runtime-Sub-Achse** (Planer/System-Registry-Owner, **seriell hinter S2/S3 + S10**) | `measurement/system_axis_registry.xml` (`sub_axis` unter `target_isa`, stage=runtime), `system_axis_registry_gen`, `validate_profile.hpp`, `xml_config_parser.cpp` (dyn_dim) | `numa_bind_policy{auto,node0,node1,interleave}` + `lock_regime`-Runtime-Dim als System-UNTER-Achse-Angebot, an Tier-Binary delegiert (analog `AllocNumaNode`); Byte-Roundtrip-Gate | validate akzeptiert; golden-neutral (binary_id=never, stage=runtime); Registry-Gen-Roundtrip |
| **N3 page_type-Anerkennung+Namensfalle** (disjunkt, binary_id-neutral) | `axis_12_general_hardware/*subaxes_hw1_to_hw4*` (ASCII-Kommentar-Anerkennung HW4↔AllocPageHint), `axes/alloc/alloc_hw_config.hpp` (Namensfallen-Guard `page_topology`≠`page_type`≠`PageKind`), Ledger §48-Mess-Kette-Zeile + Achsen-Nachschlagewerk (nur DEPRECATED/additiv) | Zweiteilung explizit benannt; `static_assert`/Kommentar-Guard gegen `page_type`-Fehlbenennung der HW-Page; kein Verhaltens-/ABI-Change | ctest byte-identisch; cf22; Mojibake-grep; kein binary_id-Diff |
| **N4 FF3-cache-awareness-Kette** (Thesis, disjunkt) | Thesis .tex (FF3 dTLB-Reach↔page_type, `fb_numa_page_study`-Referenz, NUMA-Multi-Socket-Honest-Gate ~Sep) | FF3-Motivations-Kette page_type->dTLB-Reach in Kap.02/FF3; NUMA-HW-Gate ehrlich dokumentiert | PDF baut (`.blg`/alphadin); §1-FF3 erfuellt |

**Agenten-Zahl: 4** (N1 sofort parallel; N3/N4 datei-disjunkt jederzeit; N2 seriell im Planer/Registry-Owner). **Koordination:** N2 editiert `system_axis_registry.xml` — **selber Owner** wie S2/P-SYSREG + S3/P-RESOLVER + S10/ISA-Fork-A -> strikt danach serialisieren (die Runtime-Sub-Achse haengt UNTER dem in S10 additiv gebauten `target_isa`-Knoten). N1 liefert N2 die verifizierte Sub-Achsen-Spec.

**Gate:** cf22 + ctest + Mojibake-grep + super-Sub-Build + Dual-Push + CI hart-gruen ce+super/prod1+prod2. **binary_id-neutral -> KEIN golden-Regen** (stage=runtime, binary_id=never). MAP_HUGETLB-Aktivierung + reale Node-Pins = separates USER-GO (multi-socket-gated).

**Blockiert-durch:** **S10** (ISA-Fork-A muss den `target_isa`-Knoten additiv bereitstellen, bevor N2 die Sub-Achse darunter haengt) + **S2/S3** (Planer/Registry-Owner-Serialisierung). **N1/N3/N4 NICHT blockiert** (frueh vorziehbar; N3/N4 tragen FF3-Mess-Validitaets-Gewicht -> in ein Band-A/B-Konformitaets-/Thesis-Fenster ziehbar).

**Risiken:** (R-S11a) N2 kollidiert mit dem Planer-Kern-Owner-Stau (S3->S4->S5) — *Fallback:* N2 strikt BAND-C nach Abgabe (NUMA-Effekt multi-socket-gated ~Sep, nicht abgabe-relevant; prod1 single-socket -> Effekt ~null). (R-S11b) Namensfallen-Rename koennte versehentlich ABI beruehren — *Fallback:* N3 rein additiv/Kommentar+Guard, KEIN Symbol-Rename von `AllocPageHint`/`PageKind`.

**BAND:** **BAND-C** (Q2), Ausnahme **N3+N4 = BAND-A/B-faehig** (FF3-cache-awareness mess-validitaets-relevant, binary_id-neutral).

#### S12 — Gattungs-Vervollstaendigung (B2), LETZTER ABI-Schritt, 2-Stufen-ABI-Fenster (Q4)

> Grundlage §52-B2 + §51-B2, IST verifiziert gegen `libs/cache_engine/anatomy/*`, `builder/experiment_tree/genus_binding_traits.hpp`, `builder/pruef_dock/*`. **BAND-E (Post-Abgabe, hinter der 28.07.-Kette + hinter S10/S11).** Ganz ans Ende, weil es das EINZIGE golden/ABI-beruehrende MAJOR im Erweiterungs-Block ist (§16.4 / §12-0708-#29: koordinierter ABI-Schritt V4->5, user-gated).

**Ziel:** Die 4 flachen Genera (Set/Sequence/Adapter/View) auf **Produktions-Paritaet des SearchAlgorithm-Genus** heben (SA treibt 9 reale Organe + `ObserverAggregate<17>` + 8 Schichten; Set/Sequence/Adapter/View je nur 1 Organ + flacher Hand-POD). Voraussetzung = gemeinsames **`OrganConcept`** (Op-Schnittstelle + `ObservableAxis`/`statistics`), das jede Genus-Anatomie erfuellt, sodass SA's Organ-Slot **CT-statisch/zero-cost/dispatch-frei** ein beliebiges Genus-Organ als **Sub-Organ** aufnimmt (`node_type`←Sequence/Adapter, `index_organization`←Set, `queuing_q1/q2`←Adapter). **Cross-Genus-JOIN bleibt type-unmoeglich** (`IsSlotOfGenus_v`); nur **Komposition-als-Sub-Organ** erlaubt. Abschluss: user-gated **Genus->Typ-ABI-Bump** als eigenes 2-Stufen-Fenster. **Die 8 Schichten je Genus (Soll-Paritaet, IST-Luecke):** 1 Composition (da, alle 5); 2 Anatomy (nur 1 Organ bei 4 Genera); 3 `XxxObserverAggregate<N>` per-Achse-POD statt Hand-POD (nur SA<17>); 4 PermutationEngine + `for_each_abi_adapter` (nur SA); 5 Production-ABI-Adapter (nur `SearchAlgorithmAbiAdapter`); 6 Dock (5 da, 4 flach); 7 `XxxExecutionContext` (nur SA); 8 `GenusBindingTraits`+`CompositionFromPermTuple` (alle 5 gebunden, `AnatomyFor` flach).

**S12.1 — OrganConcept-Substrat (Gattungs-Kern, STRENG SERIELL, 1 Owner)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **P-ORGANCONCEPT** | `anatomy/organ_concept.hpp` (NEU), `anatomy/composition_concept.hpp`, `anatomy/observer_aggregate.hpp` (Generalisierung `ObserverAggregate<Comp,N>`), `builder/experiment_tree/genus_binding_traits.hpp` (Sub-Organ-Bindung), `builder/pruef_dock/pruef_dock_registry.hpp` | `OrganConcept` = Op-Schnittstelle (`insert/lookup/erase/occupied_count/key_type`) UND `ObservableAxis` (`snapshot_t`/`statistics()`); `SubOrganSlot<OrganConcept auto>` CRTP-Einbettung; `IsSlotOfGenus_v` bleibt JOIN-sperrend | `static_assert(OrganConcept<SetAnatomy<...>::set_organ_t>)` je Genus; `static_assert(is_empty && !is_polymorphic)`; `static_assert(!IsSlotOfGenus_v<SetSlot, Sequence>)`; ctest |

Agenten-Zahl: **1** (Gattungs-Kern = Engpass, analog Planer-Kern). Owner forwardet im `OrganConcept` die Concept-Member korrekt (MEMORY „Observable* forwarden Concept-Member") und besitzt exklusiv die 4 gattungs-geteilten Dateien; S12.2-Agenten liefern region-disjunkte `GenusBindingTraits`/Registry-Deltas, die der Kern-Owner integriert. **Gate:** cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + CI hart-gruen; **golden/ABI-NEUTRAL** (additives Concept, binary_id Organ-only unberuehrt). **Blockiert-durch:** gesamte Abgabe-Kette S1-S8 + Erweiterungs-Straenge S10/S11 gruen (B2 = letzter ABI-Schritt).

**S12.2 — Per-Genus 8-Schichten-Paritaet (PARALLEL, 5 Agenten, datei-disjunkt)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **P-GEN-SET** | `anatomy/set_anatomy.hpp`, `set_composition.hpp`, `set_permutation_engine.hpp`, `set_abi_adapter.hpp`, `builder/pruef_dock/set_dock.hpp`, `builder/anatomy_commands/set_execution_context.hpp` (NEU) | 6 Haupt-Organe {search_algo,node_type,memory_layout,index_organization,path_compression,filter} real + observe; `SetObserverAggregate<13>` ersetzt `SetObserverSnapshot`; `for_each_abi_adapter`; prod `SetAbiAdapter`+Dock; `SetExecutionContext` | ctest per-Genus; `static_assert(std_layout && triv_copyable)`; Dock-conformance gruen |
| **P-GEN-SEQUENCE** | `sequence_anatomy.hpp`, `sequence_composition.hpp`, `sequence_permutation_engine.hpp`, `sequence_abi_adapter.hpp`, `pruef_dock/sequence_dock.hpp`, `anatomy_commands/sequence_execution_context.hpp` (NEU) | 3 Haupt-Organe {memory_layout,growth_policy,value_handle}; `SequenceObserverAggregate<9>`; `for_each_abi_adapter`; prod-Adapter+Dock; ExecutionContext | wie Set |
| **P-GEN-ADAPTER** | `adapter_anatomy.hpp`, `adapter_abi_adapter.hpp`, `adapter_tier.hpp`, `pruef_dock/adapter_dock.hpp`, `anatomy_commands/adapter_execution_context.hpp` (NEU) | 3 Haupt {inner_container,memory_layout,value_handle}; `AdapterObserverAggregate<11>` (heute 3× teil-ObserverAggregate -> vollziehen); `for_each_abi_adapter`; prod-Adapter+Dock; ExecutionContext | wie Set |
| **P-GEN-VIEW** | `view_anatomy.hpp`, `view_composition.hpp`, `view_permutation_engine.hpp`, `view_abi_adapter.hpp`, `pruef_dock/view_dock.hpp`, `anatomy_commands/view_execution_context.hpp` (NEU) | 4 Haupt {layout,accessor,extent,memory_layout}; `ViewObserverAggregate<5>`; `for_each_abi_adapter`; prod-Adapter+Dock (non-owning); ExecutionContext | wie Set |
| **P-SA-KOMPOSITION** (Integration) | `anatomy/search_algorithm_anatomy.hpp`, `search_algorithm_permutation_engine.hpp`, `builder/pruef_dock/search_algorithm_dock.hpp` | SA-Struktur-Haupt-Achsen als **Sub-Organe** via `OrganConcept`: `node_type`←Sequence/Adapter, `index_organization`←Set, `queuing_q1/q2`←Adapter — CT-statisch | `static_assert` zero-cost (kein Groessenwachstum); ctest Sub-Organ-Roundtrip; Cross-Genus-JOIN-Ablehnung bleibt |

**Agenten-Zahl: 5** (4 Genera + 1 SA-Integration; paarweise datei-disjunkt, je eigener `<genus>_*`-Namensraum/Dock/ExecutionContext). Alle 5 lesen NUR das gelandete `organ_concept.hpp` (read-only); `GenusBindingTraits`-`AnatomyFor`-Anhebung + Registry-Eintrag als region-disjunkte Deltas an den Gattungs-Kern-Owner. `P-SA-KOMPOSITION` konsumiert die fertigen Sub-Organe -> landet als **letztes**. Kadenz je integriertem Paket: cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + CI-gruen. **Gate:** je Genus ctest + Dock-conformance + `ObserverAggregate<N>`-POD-Asserts; **noch golden/ABI-NEUTRAL** solange die Aggregate NICHT in binary_id/reflect_versions einfliessen (additive Bereitstellung; ABI-Einzug erst S12.3); Landung in allen 4 Klonen. **Blockiert-durch:** S12.1.

**S12.3 — Genus->Typ-ABI 2-Stufen-Fenster (SERIELL, user-gated, zusammen delegiert)**

| Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation |
|---|---|---|---|
| **P-GATT-ABI Stufe 1 (Haupt-golden/ABI)** | `anatomy/abi_adapter.hpp` (reflect_versions), `anatomy/anatomy_base.hpp`, golden-Fixture `golden_fullpilot_320_binary_ids.txt` | **Haupt-golden/ABI-Regen** fuer alle nicht-Genus-ABI-Deltas des Erweiterungs-Blocks — als isolierte Baseline neu eingefroren, BEVOR die Genus-Churn dazukommt | `test_reflect_versions_all17` + **CRC64 0xF1C1F26A1232073B** (bzw. neu gesetzter Haupt-CRC); POD/ABI-Diff-Checkpoint |
| **P-GATT-ABI Stufe 2 (Gattungs-ABI, direkt danach)** | `anatomy/anatomy_base.hpp` (AnatomyGattung/AnatomyGenus-Enum), `genus_binding_traits.hpp`, alle 4 `*ObserverAggregate<N>`, `container_framework.hpp` (Genus->Typ), golden-Fixture (Gattungs-Regen) | Genus->Typ-Umstrukturierung + per-Genus-Aggregate ziehen in binary_id/reflect_versions ein; **Gattungs-ABI V4->5**; neuer golden ueber alle Genera | Gattungs-CRC neu; `container_framework.hpp` static_asserts (type_count/slot_count) angepasst; Diff **nur** Genus-Zeilen (bisektierbar gegen Stufe-1-Baseline) |

**Agenten-Zahl: 1 Owner** (golden/ABI NIE pro-Agent parallel — EIN kontrolliertes Fenster; die 2 Stufen zusammen delegiert, seriell abgearbeitet). Stufe 1 friert die nicht-Genus-Baseline zuerst ein -> Stufe-2-Bruch ist **genus-isoliert bisektierbar**. Vor `rm -rf build`: tracked Mess-CSV pruefen. Doku/Messdaten nie loeschen (nur DEPRECATED); ABI/alt-golden darf brechen (additiv, dann Aufraeumen unter Absprache).

**Gate (2-Stufen-Fenster):** USER-GO a — Genus->Typ-ABI-GO (§12-0708-#29/§16.4-G5, golden/ABI-beruehrender MAJOR, nur mit explizitem Bau-Release); USER-GO b — ABI/golden-Regen-Fenster (genau EIN Fenster, 2 Stufen); Remote — Genus->Typ aendert `AnatomyGattung`-Enum, falls Fixture-/Branch-Loeschung noetig: nur je-Repo-GO; cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + CI hart-gruen, beide Remotes ref-gleich, alle 4 Klone synchron. **Blockiert-durch:** S12.2 (alle 5 Genus-Pakete produktionsreif) + explizites USER-GO.

**BAND:** **BAND-E (Post-Abgabe).** Kein Deadline-Impact auf 24.07./28.07./01.08. — startet erst, wenn Ausliefer-Kette (320er + Hybrid + PDF) + S10/S11 gruen. **Begruendung „ABI zuletzt":** binary_id ist Organ-only, golden = Messbeweis; jede Genus->Typ-Umstrukturierung erzwingt golden-Regen -> vor Abgabe wuerde das die Mess-Baseline unter laufenden Messungen wegziehen; es ist ein user-gated MAJOR (Ledger-explizit); additiv zuerst (S12.1+S12.2 golden-neutral), ABI zuletzt als EIN kontrolliertes 2-Stufen-Fenster statt N verstreuter Brueche.

**Risiken:** R-G1 (hoch) Concept-Member-Forwarding (`statistics()`/`snapshot_t` UND Op-Schnittstelle) -> `static_assert(OrganConcept<...>)`-Gate je Genus vor S12.2. R-G2 (hoch) versehentliche Laufzeit-Kosten bei Sub-Organ-Komposition -> CRTP+Concept-Guard + `static_assert(is_empty && !is_polymorphic && sizeof unveraendert)`. R-G3 (mittel) geteilte Gattungs-Kern-Dateien -> strenge 1-Owner-Serialisierung. R-G4 (hoch) golden-Doppel-Regen -> Stufe 1 isoliert nicht-Genus-Baseline, Stufe-2 genus-bisektierbar. R-G5 (mittel) JOIN-Sperre vs. Komposition-erlaubt -> `static_assert(!IsSlotOfGenus_v<FremdSlot, EigenGenus>)` bleibt aktiv, Sub-Organ nur ueber `OrganConcept`. R-G6 (niedrig) 4-Klon-/Dual-Remote-Sync -> Kadenz-Gate erzwingt Dual-Push + Klon-Sync, NIE rebase. **Datei-Disjunktheit verifiziert:** S12.2-Pakete beruehren paarweise KEINE gemeinsame Datei; die geteilten Dateien (`organ_concept.hpp`, `genus_binding_traits.hpp`, `pruef_dock_registry.hpp`, `abi_adapter.hpp`, `anatomy_base.hpp`, golden-Fixture) liegen ausschliesslich bei den seriellen 1-Owner-Schritten S12.1/S12.3.

#### S13+ — Vergessene Straenge (aus R5)

> Hinweis: R5-Items 11-14 (B3 Meta-Meta / B8 NUMA / B2 Gattung / ISA-Fork-A) sind **bereits als S10/S11/S12 (Abschnitt C) ausformuliert** — hier NICHT doppelt gefuehrt. S13+ listet die **genuine additiven** vergessenen Straenge (§50, R5-Items 15-26) als kompakte Strang-/Erweiterungs-Zeilen mit Einordnung + BAND.

- **S13 — STRANG-CACHE (B7 Inkrementeller CEB/Tier-Binary-Cache).** Quelle incremental-caching-BAUPLAN + §51-B7 FREIGABE (Voraussetzung fuer N=2^17). Inhalt: `perm.algos`-Sidecar + `AlgoSigFn` + resume-v6-Stamp-Bump + `ceb_contract_version` + `axis_version.lock`-Tripwire. **NEUER Strang, BAND-C** (Bau-seitiger Sidecar golden-neutral -> BAND-B landbar). Algo-Aenderung bricht Resume-Stamp = ehrliche Neu-Messung (Daten-Doktrin-konform). Prio MITTEL-HOCH.
- **S14 — STRANG-STORAGE (Ebene-B/C + W12-B).** Quelle storage-two-cache + Verortungs-Brief + §51-B5/B6. Inhalt: `artifact_cache.hpp`-Klasse + `CachePushFn`/`MeasurementSinkFn`-No-Op-Naht + Ebene-C measure-drop-Rueckschrieb; **W12-B Stempel-Cache-Key** (`cache_key_prefix`, YAML `GN_PREFIX`, `dll_is_current`). **REVISION B5/B6 (ledger-autoritativ, korrigiert die Basis-Plan-Zeilen 149/216 „prod-MinIO V91"):** **Ebene B = dev-MinIO V90** (#72-Kopplung gestrichen), **Ebene C = prod-NFS V91 reaktiviert**. **git-Push + Mess-Rueckschrieb-Sink synchron/blockierend (NIE async).** **W11 (User-Klaerung 2026-07-20): async Binary-Erstellung/-Upload auf `minio.comdare.de` = FREIGEGEBEN + PFLICHT** — GETRENNT vom synchronen Push; NUR die Artefakt-Binary-Materialisierung/-Uebertragung zum MinIO-Store laeuft async (Bau-Durchsatz), der Mess-Sink/git-Push NICHT. W12-B = Infra-#56-gated; Storage-Code env-gated/byte-neutral -> BAND-B landbar. **NEUER Strang / S2-P-INFRA-Erweiterung, BAND-C.** Prio MITTEL.
- **S15 — GN-9 Bloat-/Kalibrierungs-Report (6-TB-Feasibility-Gate).** §50 [Mess]: 1-Zellen-Lauf Range 0:64 -> Feasibility-Gate VOR Voll-Matrix. **NEUER BAND-C-Gate vor new-golden voll.** Prio MITTEL-HOCH.
- **S16 — STRANG-AUSWERTUNG (Heuristik-Kurven-Writer M-8 Sensitivitaet + M-9 Heuristik-Kurven + M-15/E2 Welch-Konsument + PL-12 CEB-XML-Rueckschrieb).** §50 [Mess] (M-8 hoch, M-9/M-15/PL-12 mittel). S7 hat nur M-4; die 4 Writer + Varianz-Attribution = Heuristik-Grundlage fuer Kap.5/Anhang A. **NEUER Auswertungs-Strang, BAND-C** (Code parallel baubar, reale Kurven brauchen Voll-Daten -> gestrichelte Datenabhaengigkeit zur Voll-Messung). Prio MITTEL-HOCH.
- **S17 — INC-Roadmap-Reste (INC-1/1b/1c/2/3/4 + F2 native Set-ABI + F12iii Telemetrie-aus-binary_id).** §50 [Bau]. **NEUER Strang, BAND-C/D**, post-Abgabe. **Achtung F12iii = ABI-Major-Bruch** -> NUR in kontrolliertem golden-Fenster, NICHT ins 28.07-Fenster. Prio NIEDRIG-MITTEL.
- **S18 — GO-Register: Resolver-Forks R1-R8 + Planer-Forks B/C/D/E.** §50 [Bau]. **Bookkeeping/GO-Register-Zeile.** (Die planer-beruehrenden SWEEP-Punkte — 9dim-G3, Resolver-Fork R1/R5, M-4, K-5 — sind bereits in BAND-B vorgezogen, s. Abschnitt B.) Prio NIEDRIG-MITTEL.
- **S19 — H-7 -march/-mavx-Kopplung, H-10/K-18 AVX10-Sidecar per-Binary, K-17 snmalloc-Segfault (ehrliche „failed"-Zelle), OF-1 Beschleuniger-Array (GPU/FPGA/NPU), §37.2/3 mehrdim. Cross-Compile.** §50 [Bau]. **BAND-D.** Prio NIEDRIG (hardware-gated).
- **S20 — Cleanup: §23.D variant-Insel-Triade DEPRECATED + §32-F4/GN-8-Rest-Rename + GN-10 Fixture-Single-Source + §44.10 Gattungs-Docks PL-19/PL-21.** §50. **BAND-D** (deprecaten, nie loeschen). Prio NIEDRIG.
- **S21 — Bookkeeping-Sammelzeile: BK-1 §12-LOG-SHA-Nachzug, 7-Straenge-Modell SYNC-1/SYNC-2, §0-DoD5 MANUAL_RUN.md-DoD-Zeile, ST-5 Storage-Policy O-7..O-11, 9dim-2-Prosa-Drifts (B13-Rest, s. A/D3).** §50 Bookkeeping + §52-B13. Prio NIEDRIG.
- **S22 — B15 Modul-Migration A1/A5/A7 (G5/#274).** §51-B15 VOLLES GO unter 3 Auflagen. **BAND-D, ans Projektende geparkt.** A5-Master-Loeschung strikt je-Repo-GO. Prio NIEDRIG.
- **S23 — B12 F-SPREAD / INC-G7 Max-Kontrast-Paare.** §52-B12. **BAND-C parken** (first-2 ist HAUPT-Lauf entschieden; Max-Kontrast optional fuer Heuristik-Kurven ab 01.08.). Einziger offener User-Entscheid NACH Abgabe (first-2 vs. Max-Kontrast fuer N-Voll). Prio NIEDRIG.

**EXPLIZIT NICHT UEBERNOMMEN (Widerspruch / bereits aufgeloest / bereits im Plan):**
- **„W11 async" — GETRENNT (User-Klaerung 2026-07-20), NICHT pauschal verworfen:** Es sind ZWEI Dinge. **(a) async/detached git-Push + Mess-Rueckschrieb-Sink = weiterhin VERWORFEN** (Storage-Naht-Doktrin, Verortungs-Brief: „Push+Sink synchron/blockierend, NIE async — I/O-Contention = Messfehler"). **(b) async Erstellung/Upload der BINARIES auf `minio.comdare.de` = FREIGEGEBEN + PFLICHT** — als eigener Strang-Teil in **S14 aufgenommen** (getrennt vom synchronen Push). Der „Cluster-Resume"-Teil zusaetzlich durch S13 (B7) + inc-g6-Materialisierung abgedeckt.
- **W10-B alte Lesart** (`measurement_combos_of` faechert ueber die 16 `<measurement_categories>`) — WIDERSPRUCH zu §47, verworfen. Uebernommen wird ausschliesslich die §47-korrigierte Auffaecherung ueber die Mess-Tooling-HAUPT-Achse (S4). Die 16 Kategorien bleiben reine CSV-Spalten.
- **B10 page_type als neue System-Achse** — aufgeloest (§52-B10): KEIN Bau-Block; Ist-Code korrekt zweigeteilt; nur §48-Mess-Kette-Zeile (S11/N3). Nicht als Strang.
- **Fehlerklassen #29-Kern + 9dim-G4/G5/G8/G9/G10 + a1a2** — §52-B13: 7/7 ERLEDIGT; nur 2 Prosa-Drifts offen (S21). Offen verbleiben nur `isa_features.cmake` FATAL->WARNING + HandlingPolicy/ErrorDomain-CoR falls real ungebaut (in S3/A2 P-KONFORM einfalten, kein eigener Strang).
- **B11 INC-0 / measured=0-Fix** — §52-B11 ERLEDIGT+VERIFIZIERT; einziger Rest build-i2 stale-rot ist bereits S1/A4. Kein neuer Strang.
- **W12-B Stempel-Cache-Key** — bereits verortet (S14 / Post-Abgabe BAND-C, #56-gated), nicht vergessen.
- **§35/§36 Cluster-Matrix + Voll-Build 4×32768** — weitgehend GELIEFERT (W4-A, Capability-Tags) bzw. in S2/A1. Nur §36.1-Locking am dynamisch emittierten Job haengt am Emitter-Paket (Abschnitt B, S4/S5-Emitter). Kein eigener vergessener Strang.

---

### D. GESAMT-TOPOLOGIE + BAND-TABELLE

**Strang-Nomenklatur:**

| Kuerzel | Auftrag | Anker | Inhalt |
|---|---|---|---|
| KETTE | Kern | S1-S8 (+S9 Design) | P-TOTAL -> golden -> Resolver -> Mess-Tooling -> Vollzug -> 320er -> Hybrid -> PDF |
| STRANG-META | R2 | S10 | ISA-Fork-A + Meta-Meta-Achsen + Hardware-Manager-Array + Stempel-Erweiterbarkeit (B3/B4) |
| STRANG-SYSAXIS | R3 | S11 | 7. System-Achse NUMA/Locking (B8) + page_type-Anerkennung (B10) |
| STRANG-GATTUNG | R4 | S12 | Gattungs-Vervollstaendigung B2 (LETZTER ABI-Schritt) |
| STRANG-SWEEP | R5 | S13-S21/§50 | ~40 vergessene Features (B7-Cache, Storage, GN-9, Heuristik-Writer, §40.a, K-5/K-13, F12iii, INC-1, Resolver-/Planer-Forks, CoR, ...) |
| STRANG-MESSUNG | — | §48/§14.3-HELD | new-golden VOLL-MESSUNG (Pipeline 286, N=2^17, mehrtaegig, NIE pollen) |
| STRANG-STORAGE | — | S14/§48-Storage | W12-B Cache-Key + Ebene-B dev-MinIO V90 / Ebene-C prod-NFS V91 (Infra #56/#72-gated) |
| STRANG-INFRA-END | — | §48-Infra | avx512-Ketten-Anschluss -> #276 3-ISA-Teilmatrix (ALLERLETZTE) |
| STRANG-MIGRATION | — | S22/B15 | Modul-Migration A1/A5/A7 (Projektende, je-Repo-GO) |
| STRANG-DEEP | — | §18.3.1-S7 | S-7 Deep-Research (Locking in Suchalgo+Container, Observer echt) |

**BAND-A (Zwischen-Meilenstein 24.07. — alles baut, Meiste messbar CI+lokal)**

| Paket | Strang | Begruendung |
|---|---|---|
| S1 P-TOTAL Forward-Fix | KETTE | Kritischer Erst-Schritt; ohne GN_TOTAL nur 16 statt 131072 |
| S1 P-OBS (Observer/Segment-Reklass) | KETTE | golden-relevant, MUSS vor S2-Fenster |
| S1 P-W12A3 (kMeasurementAxisVersionLine POD) | KETTE | kleines Version-Line-Gate |
| S1 P-KONFORM (SampleStatus, all_axes-Rename, build-i2 stale-rot) | KETTE + STRANG-SWEEP (9dim-G8-Prosa, K-5-Anfang) | Hart-Gruen-Doktrin |
| S1/S2 P-HYBRID-Scaffolding | KETTE | datei-disjunkt vorgezogen |
| **K-5 best_binary_selector ABI-Paritaet (D6)** | KETTE + STRANG-SWEEP | Daten-Korrektheit Abgabe-Hybrid; vor S7 |
| S2 Voll-Build 2^17 + new-golden All-17 (Haupt-golden-Fenster) | KETTE | Bau-Nachweis 24.07.; CRC64 0xF1C1F26A1232073B |
| S2 P-SYSREG (6/7 System-Achsen-Angebote) | KETTE | golden-neutral, parallel zum Voll-Build |
| S2 P-INFRA PAT-Rotation #327 | STRANG-STORAGE (Vorlauf) | Security-sofort, deadline-unabhaengig |
| S3 P-RESOLVER (5-tief, minimal-3-tief Fallback) | KETTE | Grenze A/B |

**BAND-B (Abgabe 28.07. — 320er-Messdatensatz + Hybrid-Binary + Thesis-PDF)**

| Paket | Strang | Begruendung |
|---|---|---|
| S4 P-MESSTOOL + Schema `<measurement_tooling>`/`<run_methodology>` + **B9 Thesis-Profile vollstaendig** | KETTE + STRANG-SWEEP (9dim-G3, Resolver-Fork R1/R5) | Auffaecherung; blockiert 320er |
| **Emitter-Paket (W10-A/-C + W7-A/-B, §40.b/§40.c)** | KETTE + STRANG-SWEEP | CEB-Selbst-Emission + CiYaml/CMakeGraph scharf; S4/S5 |
| S5 P-VOLLZUG (emit_measure_job scharf, 1-Thread, Workload-Sweep, EIN CSV) | KETTE + STRANG-SWEEP (B14-ProgressSink, ceb-measurement-exclusive am dyn. Job) | Mess-Vollzug |
| S6 320er-Abgabe-Messlauf (USER-GO Gate a) | KETTE | Abgabe-Datensatz |
| S7 Hybrid-Binary (variant limitiert + Dock-Array) + M-4-Auswertung + Mess->PDF | KETTE + STRANG-SWEEP (M-4 19->17-Nachzug, K-5-Fix) | ABGABE-PFLICHT |
| S8 Thesis-PDF-Endspurt + Anhaenge A/B/E + FF0-Owner + honest-Gate | KETTE | End-Gate 28.07. |

**BAND-C (Anschlussarbeit ab 01.08. — Voll-Messung + wissenschaftliche Tiefe)**

| Paket | Strang | Begruendung |
|---|---|---|
| ISA-Fork-A ADDITIV + Meta-Meta-Achsen + Hardware-Manager-Array + Stempel-Erweiterbarkeit | STRANG-META (S10) | B4 VERBINDLICH; aendert Achsen-Menge -> vor Voll-golden |
| **ISA-ALT-Ausbau/Loeschung (PFLICHT-SCHLUSS, Q3)** | STRANG-META (S10 Stufe 3) | zwingender Abschluss, NICHT separat vertagt |
| 7. System-Achse NUMA/Locking (B8) + page_type-Anerkennung (B10) | STRANG-SYSAXIS (S11) | erweitert System-Achsen; vor finalem Voll-golden |
| Haupt-golden-Regen (Voll, inkl. neue Achsen) -> **Gattungs-ABI-Fenster** (Q4: 2 sequ. Stufen, 1 Strang) | STRANG-MESSUNG + STRANG-GATTUNG (S12) | ABI/golden-Regen-Band |
| new-golden VOLL-MESSUNG (N=2^17, Pipeline 286, mehrtaegig) | STRANG-MESSUNG | einziger legitimer Systembeweis, §33 |
| Heuristik-Writer M-8/M-9/M-15 + GN-9 Bloat-Report + §40.a Organ-Matrix | STRANG-SWEEP (S15/S16) | Heuristik-Grundlage aus Voll-Daten |
| F12iii + INC-1 + Planer-Forks B/C/D/E + Resolver-Forks + PL-12/W10 CEB-Selbst-Emission + CoR | STRANG-SWEEP (S17/S18) | ABI-Major/Struktur, nach Abgabe |
| W12-B Stempel-Cache-Key + Ebene-B dev-MinIO V90 / Ebene-C prod-NFS V91 | STRANG-STORAGE (S14) | Infra #56/#72-gated; ab 01.08. Voll-Messung |
| avx512-Ketten-Anschluss | STRANG-INFRA-END | Anschluss-Increment |
| Gattungs-Vervollstaendigung B2 (Set/Sequence/Adapter/View auf SA-Tiefe) | STRANG-GATTUNG (S12) | LETZTER ABI-Schritt; ABI-Fenster hinter golden |

**BAND-D (geparkt — GO-/Infra-/Hardware-gated, Projektende)**

| Paket | Strang | Begruendung |
|---|---|---|
| #276 3-ISA-Teilmatrix als harte CI-Pflicht | STRANG-INFRA-END | ausdruecklich ALLERLETZTE Aufgabe |
| Modul-Migration A1/A5/A7 (A5-Master-Loeschung je-Repo-GO) | STRANG-MIGRATION (S22) | Projektende, §16.4-G5 |
| S-7 Deep-Research (Locking/Observer echt, OptiQL/ARTSynchronized) | STRANG-DEEP | Tooling/Safety, ehrlich offen |
| INC-G7 Max-Kontrast-Paare (B12) | STRANG-MESSUNG-Fork (S23) | GO-pflichtiger Fork; first-2 ist Haupt-Lauf |
| §23.D variant-Insel DEPRECATED; §37.2/3 Cross-Compile; OF-1 GPU/FPGA/NPU; F2 native Set-ABI; K-17 snmalloc-Segfault; jemalloc/tcmalloc echt (K78-gated); C2/GH200-ARM (Miete); 14900KS-RMA prod2 (~Sept) | STRANG-SWEEP/INFRA-END (S19/S20) | niedrig / hardware-gated |
| §26 USER-GO-Forks-Register-D (O-1..O-13 Storage/Mess-CSV-Policy) | STRANG-STORAGE | Sammel-GO-Frage, gated |

**Parallel-Strang-Topologie nach der Abgabe:**

```
                          [ S8 PDF-ABGABE 28.07. ]  <-- Zwischenstand
                                    |
        +---------------------------+-------------------------------------------------+
        |                           |                                                 |
  === ABI/ACHSEN-BAND ===    === MESS/AUSWERT-BAND ===                        === INFRA/NEBEN-BAND ===
  (Planer/SysReg-Owner,      (measurement/-Owner,                            (YAML/artifact_cache-Owner,
   STRENG SERIELL)            datei-disjunkt, parallel)                       je eigener Owner, parallel)
        |                           |                                                 |
  STRANG-META (S10)           STRANG-SWEEP (S13-S21):                        STRANG-STORAGE (S14):
  ISA-Fork-A ADDITIV          - M-8/M-9/M-15 Writer  <--daten-abh.--+         W12-B Cache-Key
  + Meta-Meta/HW-Manager       - GN-9 Bloat-Report                  |         + Ebene-B dev-MinIO V90
  + Stempel-Erweiterbar        - 40.a Organ-Matrix                  |         + Ebene-C prod-NFS V91
        |                       - K-13/F12iii/INC-1                 |         (Infra #56/#72-gated)
  [ISA-ALT LOESCHEN            - PL-12/W10/CoR                      |               |
   =PFLICHT-SCHLUSS Q3]              |                              |         STRANG-INFRA-END:
        |                           |                              |          avx512-Kette
  STRANG-SYSAXIS (S11)              |                              |               |
  NUMA/Locking 7.Achse (B8)         |                              |          #276 3-ISA
  + page_type-Anerkennung (B10)     |                              |          (ALLERLETZTE)
        |                           |                              |
        v                           |                              |         STRANG-MIGRATION (S22):
  === HAUPT-GOLDEN-FENSTER ===      |                              |          A1/A5/A7 (je-Repo-GO)
  Voll-Regen inkl. neue Achsen <----+ (neue Achsen muessen rein)   |
        |                                                          |         STRANG-DEEP:
  === GATTUNGS-ABI-FENSTER ===  (Q4: 2. Stufe, SELBER Strang)      |          S-7 (opus, geparkt)
  STRANG-GATTUNG (S12) B2                                          |
        |                                                          |
        v                                                          |
  === STRANG-MESSUNG ===                                           |
  new-golden VOLL-MESSUNG N=2^17 (mehrtaegig) ---------------------+
        |
        v
  Reale Voll-Daten speisen STRANG-SWEEP-Heuristik-Writer (M-8/M-9) rueckwaerts
```

**Echt-parallel (keine gemeinsamen Dateien):** STRANG-SWEEP (measurement/-Writer) ∥ STRANG-STORAGE (artifact_cache+YAML) ∥ STRANG-INFRA-END (YAML+cmake) ∥ STRANG-DEEP (Organ/Container-Header) ∥ STRANG-MIGRATION (Modul-Dirs).
**Serialisierungs-Zwang (gemeinsamer Owner):** STRANG-META -> STRANG-SYSAXIS (beide `system_axis_registry` + `xml_config_parser` + `anatomy_version_stamp`) -> Haupt-golden-Fenster. Q4-Kette: **Haupt-golden-Fenster -> Gattungs-ABI-Fenster (STRANG-GATTUNG)** = 2 sequentielle Stufen im SELBEN ABI-Regen-Strang, zusammen delegiert. STRANG-MESSUNG erst, nachdem beide ABI-Fenster stabil (sonst misst man einen ABI-Zwischenstand).
**Daten-Rueckkopplung:** STRANG-SWEEP-Heuristik-Writer sind Code-parallel baubar, ihre realen Kurven brauchen aber die STRANG-MESSUNG-Voll-Daten -> gestrichelte Abhaengigkeit (Code jetzt, Daten spaeter) — der einzige weiche Cross-Band-Draht.

**Owner-Konflikt-Matrix (nachgelagerte Straenge vs. Planer-Kern / geteilte ABI-Dateien).** Planer-Kern-Trias = `experiment_plan_director.hpp` + `validate_profile.hpp` + `xml_config_parser.*` (1 Owner, streng seriell); zusaetzlich kritisch geteilt: `system_axis_registry.{xml,hpp}`, `anatomy_version_stamp.hpp`.

| Strang | Planer-Kern-Trias? | system_axis_registry? | anatomy_version_stamp? | xml_config_parser? | Serialisierung |
|---|---|---|---|---|---|
| **STRANG-META (S10)** | JA (director-Resolver neue Achse, validate) | JA (Manager + Extension-Array) | JA (mp_for_each-Fold statt hardcoded) | JA (neue Achse parsen) | **HOCH — Planer-Owner exklusiv, KEIN Parallel-Agent im selben Header** |
| **STRANG-SYSAXIS (S11)** | JA (director + validate 7. Achse) | JA (NUMA-Sub / page_type) | mittelbar | JA (parse 7. Achse) | **HOCH — direkt HINTER META, selber Owner, nie gleichzeitig** |
| **STRANG-GATTUNG (S12)** | teilweise (measurement_axis_registry lesend; Resolver Genus-Organe) | NEIN (eigene genus_*-Header + ObserverAggregate + abi-Adapter) | JA (Organ-Analogon-Fold) | NEIN | **MITTEL — eigener Genus-ABI-Cluster; Serialisierung nur auf anatomy_version_stamp** |
| **STRANG-SWEEP (S13-S21)** | punktuell (9dim-G3, Resolver-Forks, Planer-Fork-B) | NEIN (M-Writer 04/05/08; K-13 via Generator) | K-5 nur best_binary_selector (eigene Datei) | punktuell (Resolver-Forks) | **NIEDRIG — 90% datei-disjunkt; die 3 Planer-Beruehrpunkte in BAND-B-Fenster (S3/S4) einordnen** |
| **STRANG-MESSUNG** | NEIN | NEIN | NEIN | NEIN | keine — reiner Messlauf, Gate-gebunden |
| **STRANG-STORAGE (S14)** | NEIN | NEIN | NEIN | NEIN | nur `.gitlab-ci.yml` (GN_PREFIX) + `artifact_cache.hpp` — gegen P-INFRA/P-TOTAL-YAML |
| **STRANG-INFRA-END** | NEIN | NEIN | NEIN | NEIN | nur YAML + `isa_features.cmake` |
| **STRANG-MIGRATION (S22)** | NEIN | NEIN | NEIN | NEIN | keine Code-Kollision; je-Repo-GO |
| **STRANG-DEEP** | NEIN | NEIN | evtl. ObserverAggregate | NEIN | koordiniere ObserverAggregate mit GATTUNG |

**Owner-Regel-Konsequenz:** Die EINE Planer/System-Registry-Owner-Rolle aus S1-S5 setzt sich post-Abgabe fort als **STRANG-META -> STRANG-SYSAXIS -> (Haupt-golden) -> STRANG-GATTUNG (anatomy_version_stamp)**. Diese vier duerfen NIE zwei Agenten gleichzeitig im selben Header haben. Alle anderen (SWEEP-Writer, STORAGE, INFRA-END, MIGRATION, DEEP) sind echt parallel delegierbar. Zweiter Serialisierungspunkt = YAML-Owner (`.gitlab-ci.yml`): P-TOTAL(GN_TOTAL) -> P-INFRA(avx512) -> STRANG-STORAGE(GN_PREFIX/W12-B) -> STRANG-INFRA-END(#276), regionsgetrennt, ein Manager-Merge.

**Prioritaets-Reihenfolge der nachgelagerten Straenge:**
1. **STRANG-META (S10)** — B4 VERBINDLICH; aendert Achsen-Menge + Stempel-System (Fold), alles Folgende baut darauf. Additiv zuerst, ISA-ALT-Loeschung als Pflicht-Schluss (Q3).
2. **STRANG-SYSAXIS (S11)** — selber Owner, direkt dahinter; erweitert System-Achsen-Raum vor dem finalen Voll-golden.
3. **HAUPT-GOLDEN-REGEN + STRANG-MESSUNG** — einziger legitimer Systembeweis (§33); mehrtaegig, frueh anstossen (NIE pollen). Speist rueckwaerts die Heuristik-Writer.
4. **STRANG-GATTUNG (S12)** — B2 als LETZTER ABI-Schritt, eigenes Gattungs-ABI-Fenster direkt hinter dem Haupt-golden-Fenster (Q4). ABI-Regen-Kopplung erzwingt die Reihenfolge.
5. **STRANG-SWEEP (S13-S21)** — Heuristik-Writer, GN-9, §40.a, F12iii, INC-1, PL-12/W10, CoR. Code parallel baubar, reale Kurven brauchen Voll-Daten. (Die Planer-beruehrenden SWEEP-Punkte sind bereits in BAND-B vorgezogen.)
6. **STRANG-STORAGE (S14)** — W12-B + Ebene-B/C. Infra #56/#72-gated, Voraussetzung effizienter N-Messung; echt-parallel sobald Infra-Handout kommt.
7. **STRANG-INFRA-END** — avx512-Anschluss, dann #276 3-ISA = ALLERLETZTE.
8. **STRANG-MIGRATION (S22)** — A1/A5/A7 (B15 GO/3 Auflagen), je-Repo-GO.
9. **STRANG-DEEP** — S-7, ehrlich offen, eigene Opus-Session; koordiniert ObserverAggregate mit GATTUNG.
10. **BAND-D-Rest** — INC-G7 Max-Kontrast, variant-Insel-Deprecate, OF-1, native Set-ABI, Vendor-Allokatoren, C2/GH200-ARM, 14900KS-RMA — niedrig/hardware-gated, opportunistisch bei Owner-Leerlauf.

**Konsistenz (bindende Direktiven eingehalten):** Kein post-Strang oeffnet ein ABI/golden-Fenster ausser dem EINEN koordinierten Haupt-golden-Fenster (+ Q4-Gattungs-Fenster als 2. Stufe desselben Strangs); alle uebrigen sind golden-neutral oder laufen NACH Fenster-Schluss. CT-only-Doktrin gehalten (Meta-Meta via CRTP+Concept+mp11, kein vtable/Runtime-Switch; NUMA nur Haupt-Achse falls compile-statisch, sonst RT-Unter-Achse an Tier delegiert). variant bleibt eng-begrenzt (nur Hybrid-Unter-Pruef-Dock via Abstract-Factory, S7/S9) — kein post-Strang weitet ihn aus. **Kritische Reihenfolge-Warnungen:** F12iii (S17) und ISA-Fork-A-ABI-5->6 (S10/X5) sind ABI-brechend -> NUR in kontrollierte golden-Fenster, NIE ins 28.07-Abgabe-Fenster; K-5 (D6) ist daten-korrektheits-kritisch fuer den Abgabe-Hybrid -> vor S7 ziehen.

---

### E. AKTUALISIERTE KRITISCHER-PFAD-MARKIERUNG

Der kritische Pfad zur **28.07.-Zwischen-Abgabe bleibt unveraendert die 8-gliedrige serielle KETTE** S1/A1 P-TOTAL -> S2 Voll-Build/new-golden (24.07.) -> S3 P-RESOLVER -> S4 P-MESSTOOL -> S5 P-VOLLZUG -> S6 320er-Lauf -> S7 Hybrid + M-4 + PDF-Rueckschrieb -> S8 PDF-Abgabe; golden-relevant liegt S1/A2 P-OBS kritisch VOR dem EINEN gemeinsamen ABI/golden-Fenster (S2). **Neu auf diesen Pfad gezogen (BAND-A/B, kein Slip):** K-5 best_binary_selector-ABI-Paritaet (D6, daten-korrektheits-kritisch, vor S7); die S4/S5-Schaerfungen (B9 Thesis-Profile voll, Emitter-Paket W10-A/W7, B14-§38-Reste, M-4 19->17). **Die Abgabe ist ein Zwischenstand.** Alle grossen Erweiterungen sind vollstaendig verortet und laufen als parallele nachgelagerte Straenge S10 (STRANG-META) -> S11 (STRANG-SYSAXIS) -> Haupt-golden -> S12 (STRANG-GATTUNG) im seriellen Planer/Registry/ABI-Owner-Band, echt-parallel dazu S13+ (STRANG-SWEEP/STORAGE/INFRA-END/MIGRATION/DEEP). **Neue USER-GO-Gates (bindend, zusaetzlich zu Gate a/b der Abgabe-Kette):** (1) **ISA-Alt-Ausbau-Fenster** (S10 Stufe 3, ABI 5->6 + golden-Regen, Pflicht-Schluss Q3); (2) **Gattung Genus->Typ-ABI-GO** (S12.3, §12-0708-#29/§16.4-G5 MAJOR); (3) **das 2-Stufen-ABI-Fenster** (Haupt-golden -> Gattungs-ABI, Q4) als genau EIN kontrolliertes Regen-Fenster; (4) MAP_HUGETLB-Aktivierung + reale NUMA-Node-Pins (S11, multi-socket-gated); (5) new-golden VOLL-MESSUNG-Start (§33/§15.10-G). Kein anderer post-Abgabe-Strang oeffnet ein golden/ABI-Fenster; F12iii (S17) und ISA-5->6 (S10) bleiben strikt aus dem 28.07-Fenster ausgeschlossen.

---

## PLAN-V3 2026-07-20 -- §54-Architektur-Korrekturen + S0-Konformitäts-Audit (Gate für die nächste Stufe)

> v3 = erweiterte exakte Kopie von v2 (Struktur unverändert). Diese Erweiterung (a) korrigiert die Plan-Terminologie durchgängig auf §54-T1-T7 und (b) fügt einen ZU ALLERERST durchzuführenden Konformitäts-Audit S0 ein. Die nächste Plan-Stufe (ab S1) wird erst nach bestandenem S0 + User-Freigabe gestartet ("saubere Grundlage nachweisen"). Anker: Ledger:2915 „[§54-T1-T7] §54-Konformitäts-Audit (OFFEN, KRITISCH)"; §55 ist ab sofort Single-Source, bei Terminologie-Konflikt gilt §54-T1-T7 (NICHT der Alt-Text).

### A. TERMINOLOGIE-KORREKTUREN am Plan-Text (aus §54, additiv)

Lese-Anweisung: v3 ändert den v2-Fließtext NICHT physisch (exakte Kopie) — jede Korrektur unten gilt als „wo v2 X sagt, gilt Y (§54-T#)". Alt-Zitate bleiben als Historie erhalten.

- **KORR-1 — Z.74 (S4-Ziel) — T2+T6 [Verstoß; Schritt S4].** Alt: „16 `<measurement_categories>` bleiben reine CSV-Spalten." → Korrigiert: die N Bau-Strecken folgen der §54-T6-Legende `tier:build:[a,b,c][d,e,f]:chunk<k>` (Mess-HAUPT × System-HAUPT × gebündelter Organ-chunk, statt heute nur `[all]`); die 16 `<measurement_categories>` UND die Rückschrieb-Methoden sind Mess-Tooling-UNTER-Achsen im Planer (delegiert, §54-T2), die sich NUR als CSV-Spalten manifestieren — NICHT „reine/passive Spalten". Der Mess-UNTER-Sweep `measure:[a,b,c][d,e,f][g,h,i]` (when:manual, gegatet) ist GETRENNT vom Tier-Build.
- **KORR-2 — Z.264 (S4-Delta B9-Kern, PLANER-Absatz) — T2 [Verstoß, Stelle A; S4].** Alt: „`combo.categories` bleibt reine 16-CSV-Projektion." → Korrigiert: `combo.categories` = die 16 Mess-Tooling-UNTER-Achsen (Planer-delegiert, §54-T2), manifestiert als CSV-Spalten-Projektion (kein Fan-out; nicht „reine" Spalten).
- **KORR-3 — Z.264 (S4-Delta B9-Kern, REGISTRY- + TIER-BINARY-Absatz) — T2 [Verstoß, Stelle B; S4].** Alt: „16 Kategorien bleiben CSV-only" bzw. „emittiert 16 `measurement_categories` als CSV-Spalten (WAS)". → Korrigiert: `run_methodology` als typisierte UNTER-Achse; die 16 Kategorien UND die Rückschrieb-Methoden = Mess-Tooling-UNTER-Achsen (Planer-gesteuert, §54-T2), CSV-Spalten-Manifestation (nicht „CSV-only"/passiv).
- **KORR-4 — Z.416 (Abschnitt „EXPLIZIT NICHT ÜBERNOMMEN", W10-B) — T2 [Verstoß].** Alt: „Die 16 Kategorien bleiben reine CSV-Spalten." → Korrigiert: die alte W10-B-Fan-out-Lesart (Auffächerung ÜBER die Kategorien) bleibt verworfen; die 16 Kategorien sind aber Mess-Tooling-UNTER-Achsen (Planer-delegiert, §54-T2), die sich nur als CSV-Spalten manifestieren — KEINE „reinen/passiven CSV-Spalten".
- **KORR-5 — Z.294 (S10-Ziel) — T5+T7 [Omission; Schritt S10].** Alt endet: „= eigene Haupt-Achse = Meta-Meta-Achse unter dem Manager." → Anhang: Die Manager-Haupt-Achse VERWALTET+GIBT die Meta-Meta-Achsen FREI; jede Meta-Meta-Achse erteilt ihre Organ-Freigaben per COMMAND-Pattern (eigenständige Instanz, §54-T5). Zusätzlich zweischichtige Kern-Permutation (§54-T7): Schicht 1 = Existenz (an/aus) jeder Meta-Meta-Achse, Schicht 2 = deren Werte — die Existenz-Wahl ist compile-time, die Meta-Meta-Achse bleibt eine VOLLE CT-Haupt-Achse; Konsequenz: der CEB baut Tier-Binaries mit wechselnden ODER ganz fehlenden Hardware-Erweiterungen. System-/Organ-Achsen-Zahl wächst dadurch dynamisch je Maschine (§54-T5).
- **KORR-6 — Z.302 (S10 Stufe-1 M1, Deliverable+Verifikation) — T5+T7 [Omission; S10].** Anhang Deliverable: Command-Objekt je Meta-Meta-Achse (eigenständige Instanz) erteilt die Organ-Freigaben (§54-T5); Manager permutiert Existenz (an/aus = Schicht 1, compile-time) + Werte (Schicht 2) jeder Meta-Meta-Achse (§54-T7). Anhang Verifikation: `static_assert`, dass die Existenz-an/aus-Permutation eine Tier-Binary MIT/OHNE Extension erzeugt; Command-Instanz-Freigabe an Organ-Achse ctest-geprüft.
- **KORR-7 — Z.303 (S10 Stufe-1 I3, Deliverable) — T3 [Anker fehlt; S10].** Anhang: der einkompilierte Achsen-Satz je Tier-Binary = freigegebene System-Achsen ∪ 17 Organ-Achsen, ALLE gestempelt (§54-T3); `binary_id` bleibt der 17-Organ-Kern. (T3 wird durch M2/O4-Stempel-Fold sachlich umgesetzt, der Freigabe-Satz-Begriff war nur nirgends explizit benannt.)
- **KORR-8 — Z.357/358/361 (S12-Header/Ziel) — T1 [Anker/Härtung; S12].** Anker in die Grundlagen-/Ziel-Zeile: Gattung = einheitliches Tier-Binary-INTERFACE, KEINE Achse (§54-T1); „Vervollständigung" = die 5 Genera dieses Interface (Set/Sequence/Adapter/View + SearchAlgorithm) auf Produktionstiefe heben. (Kein Verstoß — S12 nutzt Gattung/Genus bereits als Interface; nur Härtung.)
- **KORR-9 — Z.46 & Z.453 („6/7 System-Achsen") — T5 [Präzisierung].** Alt: „6/7 System-Achsen als Registry-ANGEBOT". → Korrigiert: 6/7 System-Achsen (BAND-A-Snapshot; die Zahl wird durch den Hardware-Manager/Meta-Meta-Array aus S10 dynamisch je Maschine, §54-T5).

**Betroffene Schritte:** **S4** (KORR-1/-2/-3 = Hauptlast: T2 + T6-Legende + Rückschrieb-Methoden-UNTER-Achse); **S5** (mittelbar über KORR-1: T6-Trennung Tier-Build vs. `measure:[…][…][g,h,i]`-Sweep verankern — S5 nennt `emit_measure_job`/when:manual, aber nicht die T6-Legende); **S10** (KORR-5/-6/-7: T5-Command-Pattern, T7-2-Schicht-Permutation, T3-Freigabe-Achsen-Satz); **S12** (KORR-8: T1-Anker); **Abschnitt „nicht übernommen" Z.416** (KORR-4: T2).

**Bereits §54-konform — KEIN Change (damit der S0-Audit keine Phantome jagt):** **T1** — im Plan taucht KEIN „Achsen-Gattung"/„Gattungs-Achse" auf; „Gattung"/„Gattungs-ABI" (Z.3/239/388)/„Gattungs-Docks" werden durchgängig als Tier-Binary-Interface verwendet. **T4** — KEIN „Baum je Gattung" im Plan; der Serialisierungs-Baum-je-Achsen-Typ wird in S1–S23 gar nicht ausgeführt (nur Ledger §55). **T6-Notation [REVIDIERT §56 — diese Aussage war FALSCH]** — `ceb:build:[a,b,c]` ist korrekt; ABER `tier:build:[a,b,c][d,e,f]:chunk<k>` (Code `plan_legend.hpp:109`) ist eine **REGRESSION** — korrekt ist `tier:build:[d,e,f][g,h,i]` (System-Achse x ORGAN-Achse); die Mess-Achse `[a,b,c]` baut nur die CEB und gehoert NICHT in die Tier-Build-Legende. Der Rename ist zu **ERZWINGEN** (Code-Fix GO-pflichtig, Ledger §56), NICHT als „kanonisch" zu zementieren. (Wurzel: §54-T6 war selbst falsch.)

### S0 -- KONFORMITÄTS-AUDIT gegen die falsch-zusammengezogene Architektur (ZU ALLERERST, Gate)

**Ziel:** literal nachweisen, dass der IST-Code die maßgebliche Architektur (§54-T1-T7) nicht verletzt (bzw. die noch-nicht-gebauten Teile wie Meta-Meta nur LÜCKEN sind, keine Verstöße), bevor die nächste Stufe freigegeben wird. Ergebnis je Paket binär: **SAUBER** (literaler Beleg) oder **RESIDUE/LÜCKE** (Datei:Zeile → Folge-TODO). Kein ✓ ohne literale Ausgabe/Fundstelle.

ce-Wurzel = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`; alle Pfade unten relativ dazu.

| Paket | Kern-Dateien / Grep | Was prüfen (T-Punkt) | Literaler Nachweis (Erwartung) |
|---|---|---|---|
| **AP-S0-1** | `libs/cache_engine/anatomy/anatomy_base.hpp` (Z.32-99), `libs/cache_engine/topics/axis.hpp` (Z.17-21); grep `gattungs?-achse\|genus.?axis\|AxisKind::genus` | **T1**: Gattung = Interface-Diskriminator (keine Achse); Achsen nach TYP {Organ/System/Mess}; kein Genus, das als Achse permutiert wird | `AxisKind` = genau 3 Typen `{organ, system_measurement, system_config}`, KEIN `genus`-Enumerator (axis.hpp:17-20 verifiziert); grep liefert nur genus-SPEZIFISCHE Organ-Achsen-Kommentare; `AnatomyGattung`/`AnatomyGenus` nur Interface-/GenusBindingTraits, keine Baum-Ebene → **SAUBER + Term-Residue** (View-/Sequence-/Filter-„Gattungs-Achsen"-Kommentare = genus-spezifische **Organ**-Achsen; Doku-Nachzug, nicht blockierend) |
| **AP-S0-2** | `libs/cache_engine/profile_facade/planner/plan_legend.hpp:69-83`, `libs/common/serialization/xml_config_parser/xml_config_parser.cpp:362-368,441-442`, `.../measurement/measurement_axis_registry.hpp`, `.../planner/experiment_plan_director.hpp`; grep `measurement_combo\|measurement_categories` | **T2**: `[a,b,c]`-HAUPT muss aus Mess-Tooling {wallclock/macro/micro} kommen, NICHT aus `measurement_categories`; categories nur CSV-Spalten / `[g,h,i]`-UNTER-Sweep | **RESIDUE GEFUNDEN** (verifiziert): `plan_legend.hpp:69` „`[a,b,c]` … Aus der Anwender-XML `(<measurement_categories>)`" + `:73` `measurement_combo(categories)` bilden das HAUPT-Slot aus categories → Verstoß §54-T2/T6 (deckt Ledger §55-Pkt.2 / §47). → **blockierender Folge-TODO** (Mess-Kette §47-AKTUELL); literal markieren „falsch zusammengezogen: categories im [a,b,c]-HAUPT statt Tooling" |
| **AP-S0-3** | `.../builder/experiment_tree/profile_to_tree.hpp:28-103` (Guard `is_organ_composition_axis`), `.../registry_to_axis_levels.hpp:88-144`, `.../axis_path_serialization.hpp` (`kCompositionAxisNames`=17 Organ-Slots), Stempel `kOrganAxisVersionLine`/`kSystemAxisVersionLine` | **T3**: Verunreinigen freigegebene System-Achsen die `binary_id`? Satz = freigegebene System ∪ 17 Organ, gestempelt, aber binary_id-tragend NUR 17 Organ | `profile_to_tree.hpp:96` `if (!is_organ_composition_axis(ax.ref)) continue;` = struktureller Guard gegen `kCompositionAxisNames` (verifiziert); System-Achsen → `build_system_axis_levels`/Sidecar; Byte-Roundtrip + Guard-Test golden-neutral → **SAUBER** (ergänzend: `kMeasurementAxisVersionLine` fehlt noch, §43 — Stempel-Vollständigkeit, kein T3-Verstoß) |
| **AP-S0-4** | `.../experiment_tree/experiment_tree.hpp`, `.../genus_binding_traits.hpp:2-3`, `.../axis_observer_classification.hpp:33-73`, `.../registry_to_axis_levels.hpp`; grep `genus\|Gattung\|per_genus` in experiment_tree.hpp | **T4**: Baum per Achsen-Typ (AxisKind) oder per Gattung? („B+-Baum pro Gattung" §10.1-E4 = stale) | grep 0 per-Gattung-Baum-Partition; `genus_binding_traits.hpp:3` literal „Baum-KERN ist bereits gattungs-agnostisch"; Zerlegungs-Achse = `AxisKind` {organ/system_measurement/system_config} → **SAUBER** (Doku-Residue „B+-Baum pro Gattung" §10.1-E4 = additiver Nachzug) |
| **AP-S0-5** | `.../measurement/extension_hardware_family_axis.hpp` (Z.22,36-62,78), `.../ceb_system_axis.hpp`, `.../simd_sub_axis.hpp`, DEPRECATED `extension_hardware_system_axis.hpp` | **T5/T7**: Meta-Meta-Command-Array + 2-Schicht-Existenz/Wert-Permutation vorhanden? (heute EIN Familien-Knoten) — Lücke feststellen + Nicht-Widerspruch belegen | CRTP+Concept, `is_empty_v`, `!is_polymorphic_v` (static-dispatch, keine vtable) + `axis_kind()==system_config` + binary_id-neutral (nie in `kCompositionAxisNames`); `kAllExtensionHardwareFamilyIds={simd}` additiv erweiterbar → **LÜCKE (S10-Bauziel), KEIN Verstoß**; heutiger Knoten CT/vtable-frei/binary_id-neutral → zielarchitektur-kompatibel. DEPRECATED-Insel NICHT reaktivieren (Guard `test_striktheit_axis_dach_guard` Block F) |
| **AP-S0-6** | `.../planner/plan_legend.hpp:100-117` (`tier_build_job` vs `measure_job`), `.../experiment_plan_director.hpp:391-410,567-700` (`emit_measure_job`) | **T6**: `tier:build:[a,b,c][d,e,f]:chunk<k>` (Bau, nur HAUPT, Organ als chunk) und `measure:[a,b,c][d,e,f][g,h,i]` (UNTER-Sweep, when:manual, gegatet) sauber getrennt? | `plan_legend.hpp:109` `tier_build_job`=`"tier:build:"+combo+perm+":chunk"+k` (nur Mess-HAUPT × System-HAUPT × chunk; Kommentar „KEINE Organ-Haupt-Achse und KEINE Unter-Achse in der Bau-Job-Legende"); `:114-116` `measure_job` separat mit `[g,h,i]`; Director trennt Job-Typen, `measure:` `when:manual` + GN-11/320er-gegatet (:699) → **RESIDUE/VERSTOSS (REVIDIERT §56 — vorher faelschlich SAUBER)**: `tier_build_job` traegt `[a,b,c][d,e,f]:chunk<k>` = Mess x System (Organ als anonymer chunk) statt `[d,e,f][g,h,i]` = System x ORGAN; die Wurzel §54-T6 war selbst falsch, S0 hatte gegen die falsche Fassung geprueft. Code-Fix GO-pflichtig (§56). Zusatz-Rest: `resource_group ceb-measurement-exclusive` fehlt am dyn. Job (§52-B14) |
| **AP-S0-7** | `libs/` ce-weit, `-not -path '*/build*'`; greps: `gattungs?-achse\|achsen-gattung`, `neunzehn achsen\|19 achsen`, `B\+.baum pro gattung\|pro gattung`, `measurement_categories.*Haupt` | **Querschnitt**: wo trägt Code (Kommentare/Labels) noch §47/§48/§51-Alt-Vokabular? | Inventar-Liste (Datei:Zeile) → additive Doku-Nachzug-TODOs; Single-Source-Zahlen (17 Organ / 6+meta-meta System / AxisKind-3-Typen) im Code korrekt, nur Kommentar-Text hängt nach → **kein Bau-Blocker** |

**Agenten-Zahl:** 7 disjunkte Audit-Pakete (AP-S0-1 … AP-S0-7), datei-/grep-disjunkt, parallelisierbar; jedes liefert binär SAUBER oder RESIDUE/LÜCKE mit Datei:Zeile.

**PASS-Kriterien (Gate GRÜN — alle sechs, jeweils mit literaler Ausgabe):**
- **P1 (T1/T4):** Organ-only-Guard `is_organ_composition_axis` in `profile_to_tree.hpp` gegen `kCompositionAxisNames` (17, Single-Source) verdrahtet, kein dupliziertes Achsen-Verzeichnis; ctest/build-i2 grün + golden-neutral.
- **P2 (T3):** `axis_observer_classification.hpp` klassifiziert 17/9/0 (telemetry+isa → DefinitionOnly); SA-Zahl == `kCompositionAxisNames`(17) == `kV3AxisCount` == `ObserverAggregate<17>::total_slots()`; `test_br3_obs22` + `test_d7b_definition_per_node` literal PASS.
- **P3 (T1/T2):** Grep über Plan-V3 findet KEIN unkorrigiertes „Gattungs-Achse(n)"/„Achsen-Gattung"; jede „reine/passive CSV-Spalte"-Formulierung für measurement_categories trägt den T2-Zusatz (Planer-gesteuerte Mess-Tooling-UNTER-Achse, manifestiert als CSV-Spalte).
- **P4 (T6):** Plan-V3 führt `tier:build:[a,b,c][d,e,f]:chunk<k>` (nur HAUPT) und `measure:[a,b,c][d,e,f][g,h,i]` (Unter-Sweep, when:manual, gegatet) als ZWEI getrennte Legenden — nirgends zusammengezogen.
- **P5 (T5/T7):** Wo der Plan die Hardware-/ISA-/Meta-Meta-Stränge (S10/S11) berührt, steht Command-Pattern-Freigabe + zweischichtige Existenz(an/aus)+Wert-Permutation compile-time; keine „dynamische Runtime-CPU-Umschaltung" (vgl. D5/§52-B10 page_type-Korrektur).
- **P6 (Audit-Vollständigkeit):** Alle §55-Stale-Fundstellen (Liste unten) erfasst + als ADDITIV-nachzuziehen markiert (Doku nie löschen, nur deprecaten/ergänzen); keine offene stale Zeile ohne Korrektur-Vermerk.

**FAIL-Kriterien (jede Konflation blockiert die Freigabe der nächsten Stufe, zuerst zu beheben):**
- **F-A:** binary_id enthält/erlaubt eine System-Achse (isa/simd_extension/page_type/telemetry) als serialisiertes Level → T3/T4-Bruch. Behebung: P1-Guard.
- **F-B:** telemetry/isa noch als SearchAlgorithmObserver klassifiziert (SA-Zahl 19 statt 17) → golden/ABI-Bruch. Behebung: P2-Reklass.
- **F-C:** Plan-Text nennt Achsen „Gattungen" oder measurement_categories „reine CSV-Spalten, kein Registry-Angebot" → T1/T2-Bruch.
- **F-D:** Legende `tier:build:[d,e,f]:chunk<k> + measure` zusammengezogen (§42-Alt-Formulierung) → T6-Bruch.
- **F-E:** Organ/System-Achsen-Zahl als „statisch 6/17" ohne die dynamisch-je-Maschine-wachsende (Meta-Meta-Command) Semantik → T5-Bruch.

**Einordnung VOR S1:** S0 läuft ZU ALLERERST, vor S1; die Kette S1-S8 + Stränge S10-S23 bleiben im Kern unverändert und rücken NICHT nach (Nummerierung stabil). S0 = Nachweis-Gate, KEIN Bau-Schritt: kein Code-Fan-out außer dem bereits vorhandenen (uncommitted) S1-Substrat; keine ABI/golden-Regen-Berührung (binary_id bleibt Organ-only, CRC-neutral). Abhängigkeit: **S0 blockiert-durch:** — (echter Startschritt); **S1 blockiert-durch:** S0-Nachweis (P1-P6 literal) + User-Freigabe. Der kritische Pfad (S1/A1 → S2 → S4 → S5 → S6 → S7 → S8) hängt damit hinter S0, ohne dass eine Kettenzeile inhaltlich umgeschrieben wird.

**Beitrag der uncommitteten S1-Teile (S0 kann den Nachweis JETZT führen, ohne Commit):**
- **A4 Organ-only-Guard** — `.../builder/experiment_tree/profile_to_tree.hpp` (M): `is_organ_composition_axis(ref)` gegen `kCompositionAxisNames` + Reject-Zweig `if (!is_organ_composition_axis(ax.ref)) continue;` (Z.96) → macht „Organ-only-binary_id" zur STRUKTUR (eine System-Achse im `permute_axes`-Block kann die binary_id nicht mehr verunreinigen; läuft über CEB-System-Achsen-Schicht, `+ext=`/`+target=`-Sidecar). Direkter Nachweis T3/T4 (P1). Der lautstarke Reject/Routing-Pfad in `validate_profile` ist bewusst Folge-Schritt P-RESOLVER (S3).
- **A2 Observer-Reklass** — `.../builder/experiment_tree/axis_observer_classification.hpp` (M): telemetry (INC-2c) + isa (INC-2d) aus SearchAlgorithmObserver → DefinitionOnly reklassifiziert; 19/7/0 → 17/9/0; SA-Zahl == `kCompositionAxisNames`(17); rein diagnostisch, binary_id UNVERÄNDERT. Direkter Nachweis T3 (P2), test-belegt br3_obs22/d7b.
- **Unterstützend (Teil-Beitrag):** A4 `.../abi/anatomy_module_abi_v1.hpp`(+`..._decl.hpp`) `reflect_versions<17>`-Gate/`all_axes_*_count`-Rename (bestätigt 17-Organ-Kern, T3); A3 `.../abi/anatomy_version_stamp.hpp` `kMeasurementAxisVersionLine`-POD (Mess-Tooling-HAUPT-Stempel, stützt T2/T6); §52-B13-Rest in `.../anatomy/memento_aggregate.hpp` + `.../anatomy/composition_factory.hpp` (zwei „19"-History-Prosa-Drifts — S0 prüft, ob die uncommitted Edits sie schon 19→17 gezogen haben; falls nicht → additiver Doku-Nachzug, kein ABI).
- **Owner-Serialisierung:** `profile_to_tree.hpp` gehört P-KONFORM (S1) VOR P-RESOLVER-Ausbau (S3) — S0 fixiert nur den Nachweis-Zustand, ändert die Datei NICHT.

**Stale-Doku-Fundstellen (§55-Audit / Ledger:2915,2941 — ADDITIV nachzuziehen, NIE löschen; bei Konflikt gilt §54-T#):**
- **T1** (Achsen-TYP statt „Gattungs-Achse"; Gattung = Tier-Binary-Interface): §10.1-E4, §12-F3i („Algorithmus-Gattungs-Achsen"), §15.10-D/§15.1-S-0/§48-Hybrid, §15-Backup „achsen-gattungen-metaprog", §30.
- **T2** (measurement_categories + Rückschrieb = Mess-Tooling-UNTER-Achsen, delegiert, nur CSV-Manifestation): §31-A3 (SUPERSEDED), §32-F7, §47 (Ledger:2414/2415; Doc 23 „16 Kat=Hauptachsen"/Doc 16 „Mess hat KEINE Unter-Achsen"), §48-Exec-Summary/§27/§28/§16.1-C2, §28-Mess-Registry-Split, achsen-nachschlagewerk (Ledger:2835).
- **T3** (Achsen-Satz = freigegebene System ∪ 17 Organ, gestempelt; binary_id = 17-Organ-Kern): §21.B/§21.E, §37-Item6, §51-B4, §0-V5.7.
- **T4** (Permutations-Baum je Achsen-Typ): §10.1-E4 („B+-Baum PRO GATTUNG").
- **T5** (Hardware-Haupt-Achse verwaltet+gibt frei die Meta-Meta-Achsen; je COMMAND-Pattern; Zahl wächst dynamisch je Maschine): §40.a (Flag-Signatur → Meta-Meta-Manager-Array), §51-B3/§52-B3.
- **T6/T7** (zweischichtige Kern-Permutation; Tier-Build-Array getrennt vom gegateten Measurement-Sweep): §42-Legende (zusammengezogen → auf T6 trennen).
- **Doktrin für alle:** additiv korrigieren (Deprecate-Vermerk + Verweis §54-T#), Alt-Text als Historie ERHALTEN; §55 = Single-Source. Die Code-Fundstellen P1/P2 sind bereits im uncommitted S1-Substrat erledigt; der Rest ist reiner additiver Doku-Nachzug.

### B. EINORDNUNG in die v3-Kette

S0 → [User-Freigabe der nächsten Stufe] → S1 (P-TOTAL Forward-Fix) → S2 (das EINE ABI/golden-Fenster) → S4 → S5 → S6 → S7 → S8, parallel dazu die Stränge S10-S23 — alles inhaltlich UNVERÄNDERT gegenüber v2; keine Kettenzeile wird umgeschrieben, keine Nummer rückt nach (S1-S8 + S10-S23 im Kern stabil). S0 ist dem Gate-a/Gate-b des Plans vorgelagert: es liefert die „saubere Grundlage", auf der das EINE terminologie-konforme ABI/golden-Fenster (S2) überhaupt geöffnet werden darf. S0 ist reines Audit und ändert KEINEN Code außer den additiven Doku-Nachzügen (§54-T#-Deprecate-Vermerke); der einzige eingebackene Verstoß (AP-S0-2 / T2: `plan_legend.hpp:69,73` zieht `measurement_categories` in das `[a,b,c]`-HAUPT-Slot) ist als Vorbedingung der Mess-Kette (§47 / §55-Pkt.2) literal zu markieren, alles Übrige ist strukturell sauber (T1/T3/T4/T6) bzw. erwartete Bau-Lücke (T5/T7 = S10).
