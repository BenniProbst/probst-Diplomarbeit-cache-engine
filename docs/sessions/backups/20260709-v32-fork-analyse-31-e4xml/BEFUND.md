# BEFUND — V32-Schema-Fork-Analyse (Phase 4 / #31 E4-XML), 2026-07-09

> Read-only Explore-Analyse (af56e0c0), wasserdicht mit `datei:zeile`. Korrigiert die
> Fork-Annahmen aus Dossier 16 Teil D/H erheblich. Wurzeln: super = probst-diplomarbeit-cache-engine,
> ce = super/Code/external/comdare-cache-engine. Backup-Direktive: für Folge-Sessions.

## Kernkorrektur: der Fork war falsch gerahmt

Das Dossier stellte „V32 aktivieren vs. comdare_experiment erweitern" gegenüber. **Beide Kandidaten sind irreführend:**

1. **`comdare_experiment` (config_a/b/c.xml) ist TOT** — von KEINEM Code konsumiert (`config_a_prt_art_vs_sota.xml:6` Root, nur das gleichnamige CMake-Target existiert). Es zu „erweitern" hieße, eine ungenutzte Datei zu editieren.
2. **V32-Orchestrator ist NICHT verdrahtet** — `main.cpp` inkludiert `v32_orchestrator.hpp` **nie**, referenziert `COMDARE_V32_ENABLE` **nie**. Der `execute_messreihe(config_xml,mode)`-XML-Eintritt (`v32_orchestrator.hpp:81-85`) ist ein **Stub** (`(void)config_xml; return 0;`). Ein V32 XML→Struct-Parser existiert **nirgends** (`messreihe_v32_validator.hpp` = nur String-`.find()`-Checks).
3. **Der REALE produktive Pfad** = ein viertes Ad-hoc-Format `<comdare_messreihen>` (`Code/experiment_config/messreihen.xml:14`), **per Regex** geparst in `load_messreihen` (`main.cpp:173-204`). Struct `MessreihenSpec` (`main.cpp:167-171`) trägt nur `id`/`mode`/`sota_profiles` — **kein** workload/dataset/measurement_category. Deshalb sind die Workloads hartkodiert (`main.cpp:135/140/145/483` = `YcsbWorkload::C/A`): die Driver-API `run_pipeline_full(WorkloadOptions)` braucht einen Workload, den XML aber nicht liefert.

## `COMDARE_V32_ENABLE` — effektiv No-Op fürs Driver-Binary

`option(... OFF)` (`02_messung_driver/CMakeLists.txt:22`) greift nur preset-los; `CMakePresets.json:14` (`_base`, von allen geerbt) setzt ON → **effektiv ON**. ABER: bei ON nur Compile-Def + Include-Pfad am Target; da main.cpp weder Makro noch Header nutzt, ist das Driver-Binary ON≡OFF **byte-identisch**. ON gated nur die schweren Tests + die CE-Command-Lib. „V32 ist aktiviert" ist irreführend.

## Die zwei ECHTEN Fork-Wege

### Option A (EMPFOHLEN) — live `<comdare_messreihen>`-Format erweitern
- `main.cpp:167-171` — `MessreihenSpec` +3 Felder (workload/dataset/measurement_category).
- `main.cpp:173-204` — `load_messreihen` +3 Regex (Muster wie mode/profile 190-200).
- `main.cpp:124-149` (`default_workload_for`) + `:476-483` — die 4 Hartkodierungen durch String→`YcsbWorkload`-Map aus dem Spec ersetzen (Fallback = heutige Defaults).
- `experiment_config/messreihen.xml` — optionale Tags je `<messreihe>` (additiv, fehlend = heute).
- **Aufwand: 1 Code-Datei (main.cpp) + 1 XML-Template. Kein Parser, kein Orchestrator, keine CMake/Flag-Änderung. golden/ABI-neutral.** #229 exakt erfüllt (4 Hartkodierungen entfallen).

### Option B — V32 wiederbeleben (XSD + Parser + Orchestrator)
- `messreihe_v32_schema.xsd:65-147` `TupelType` (hat `workload`+`op_type`, KEIN dataset/measurement_category) um 2 Elemente erweitern (nach `:87`, minOccurs=0).
- **NEU: V32 XML→Struct-Parser (~150-250 LOC, existiert nicht).**
- `v32_orchestrator.hpp:81-85` Stub vollenden; main.cpp+CMake erstmalig einbinden.
- Flag-Inkonsistenz (OFF vs ON) auflösen.
- **Aufwand: 5-7 Dateien + neuer Parser + Bruch der Freeze-Direktive „main.cpp V31.F unveraendert" (`v32_orchestrator.hpp:7`).** Reicher (op_type OP-1..6, EE-A/EE-B-Compare, XSD-validiert), aber großer, riskanter Lift.

## golden/ABI — beide Optionen NEUTRAL (verifiziert)
`permutation_axes.xml` (11 Achsen) + `golden_fullpilot_320_binary_ids.txt` (320 IDs aus 19 statischen Build-Achsen) + POD `ComdareResourceControlV1` (5 Felder) tragen **kein** workload/dataset/measurement_category (Grep leer). Workload×Dataset×Mess-Kategorie sind **Mess-INPUTS** (Stimulus/Selektion, DynamicVariableNode-Seite), keine Binary-Achsen. Golden-neutral by construction — solange die neuen Felder den workload_generator/Mess-Loop speisen und NICHT in permutation_axes/binary_id wandern.

## Risiken / offene Sub-Entscheidungen (User)
- **R1 Vokabular:** `wg::YcsbWorkload` kann nur A–F (`workload_generator.hpp:22-29`). Für OP-1..OP-6 (Bulk-Insert/Range-Delete) reicht es nicht → Enum-Erweiterung nötig. Die V32-Welt (`cmd::WorkloadKind`, `commands/workload.hpp:19-27`) hat die Customs schon. Wenn `measurement_category` OP-Semantik ausdrücken soll, unterläuft Option A das V32-Vokabular.
- **R2 Doppelte Wahrheitsquelle:** Eine dataset-Dim existiert bereits im ExperimentDriver-Pfad (`test_data_sets.xml` → `cfg.test_data_sets`, Kartesik `experiment_driver.cpp:115`), mit `<workload>A</workload>` IM Dataset — main.cpp überschreibt es aber mit hartkodierter `WorkloadOptions`. Entscheidung: treibt das neue messreihe-`<workload>` die Options, oder bleibt test_data_sets.xml autoritativ? Doppelquelle vermeiden.
- **R3 Freeze:** Auch Option A editiert main.cpp (trägt „V31.F unveraendert", `v32_orchestrator.hpp:7`). Additiv + außerhalb der V31.F-Orchestrator-Logik, aber Formulierung breit → User bestätigen lassen.

## Empfehlung
**Option A** (live `<comdare_messreihen>`/MessreihenSpec erweitern) — minimal, additiv, golden-neutral, erfüllt #229 exakt, berührt nur laufenden Code. Option B ist architektonisch reicher, aber ein großer Lift (toter Code wiederbeleben + Freeze-Bruch) für Reichtum, den #229 nicht zwingt. **Falls die OP-1..6-Semantik (R1) für die Thesis gebraucht wird**, kippt die Abwägung Richtung B oder Richtung „Option A + YcsbWorkload-Enum-Erweiterung". = User-Entscheidung.
