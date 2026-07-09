export const meta = {
  name: 'diplomarbeit-topdown-31-verortung',
  description: 'Top-down-Kartierung der Diplomarbeit-Anwenderschicht (4 Teilprogramme, 6-Stufen-Mess-Pipeline, messung_driver, experiment_config/messreihen-XML, v32-Schema) + Verortung von #31 (Mess-Frameworks x Workloads als Module) gegen die schon geplante Profile-Bereitstellung(Diplomarbeit)/Interpretation(cache-engine)-Trennung',
  phases: [
    { title: 'TopDown-Kartieren', detail: '6 parallele Leser: Gesamt-Architektur, messung_driver, experiment_config/Schema, cache-engine-Interpretations-API, #31-Verortung, 4-Schichten-Dossier/measurement-all' },
    { title: 'Synthese', detail: 'Top-down-Architektur + korrekte #31-Verortung (Diplomarbeit-Ebene) + Korrektur des cache-engine-workload_matrix-Ansatzes' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CODE = SUP + '/Code'
const CE = CODE + '/external/comdare-cache-engine'

const READERS = [
  {
    label: 'topdown-gesamtarchitektur',
    prompt: `READ-ONLY-Architektur-Kartierer der Diplomarbeit. Basen: super=${SUP}, Code=${CODE}. Keine mutierenden Befehle.

AUFGABE: Kartiere die VOLLSTAENDIGE Architektur TOP-DOWN (von der Anwenderschicht zur cache-engine).

Lies (datei:zeile): ${SUP}/docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md; ${SUP}/docs/sessions/20260531-gesamtkontext-maschinerie-und-goal.md; ${SUP}/docs/uml_planning/Y3_diplomarbeit_code_ist_kartografie.md, Z3_soll_uml_diplomarbeit_code.md, Y4_cross_repo_beziehungen.md, Z4_soll_uml_cross_repo_bidi.md, Z5_master_index_und_gap_analyse.md; ${CODE}/README.md, USAGE.md, MANUAL_RUN.md, CMakeLists.txt (nur Struktur).

Beantworte:
1. Die 4 Teilprogramme (Diplomarbeit-Anwender / cache-engine-Framework+Interpretations-Bibliothek / prt-art-Pruefling / thesis) — Rolle + Kopplung je.
2. Die 6-Stufen-Mess-Pipeline (01 sample_data → 02 messung_driver → 03 binary_to_csv → 04 csv_to_latex → 05 diagram → 06 pdf) — Datenfluss top-down.
3. Die SCHICHTUNG: Wenn man von 4 Layern spricht — welche 4? Wo ist die Grenze Diplomarbeit-Anwenderschicht (stellt Profile bereit) vs. cache-engine-Framework (interpretiert/fuehrt durch)?
4. Wie fliesst EIN Experiment top-down: Profile-Definition (experiment_config-XML) → messung_driver → cache-engine-Interpretation → Messung → Auswertung?

Gib die top-down-Architektur mit datei:zeile-Belegen.`,
  },
  {
    label: 'messung-driver-orchestrierung',
    prompt: `READ-ONLY-Kartierer. Code=${CODE}. Keine mutierenden Befehle.

AUFGABE: Kartiere 02_messung_driver — wie die Diplomarbeit die cache-engine orchestriert.

Lies (datei:zeile): ${CODE}/02_messung_driver/ ALLE Dateien (main.cpp, v32_orchestrator.hpp, axis_tree.hpp, plugin_loader.hpp, measurement_writer.hpp, messreihe_v32_validator.hpp, messreihe_report_exporter.hpp, stats_aggregator.hpp, op_type_filter.hpp, hardware_filter.hpp, permutations_runtime_check.hpp, README.md, CMakeLists.txt).

Beantworte:
1. Wie liest der messung_driver die experiment_config-XMLs (config_a/b/c, messreihen.xml)?
2. Wie ruft er die cache-engine (comdare_builder_experiment_driver / CacheEngineBuilder / run_profile / ExperimentDriver)? Welche cache-engine-API konkret?
3. Was ist axis_tree.hpp — die Diplomarbeit-seitige Achsen-/Mess-Sicht? Wie verhaelt sie sich zur cache-engine-experiment_tree?
4. Wie werden Workloads, Mess-Kategorien und Datasets hier gehandhabt (an cache-engine durchgereicht als Profile)?
5. Wie schreibt er measurement_record (*.bin, magic 0xC0FFEE02)?

Gib die Orchestrierungs-Mechanik mit datei:zeile.`,
  },
  {
    label: 'experiment-config-profile-schema',
    prompt: `READ-ONLY-Kartierer. Code=${CODE}. Keine mutierenden Befehle.

AUFGABE: Kartiere die PROFILE-BEREITSTELLUNG der Diplomarbeit — die XML-Definition der Mess-Frameworks x Workloads x Datasets.

Lies VOLLSTAENDIG (datei:zeile): ${CODE}/experiment_config/config_a_prt_art_vs_sota.xml, config_b_cache_engine_perms.xml, config_c_merge_alt_neu.xml, messreihen.xml; ${CODE}/test_data_xml/messreihe_v32_schema.xsd, messreihe_v32_schema_example.xml, README.md; je 1 Datensatz-XML (url.test_data.xml). Suche auch algorithm_profiles/load_profiles-XMLs unter ${CE} (die Lastprofil-Kataloge, die die cache-engine per discover_load_profiles liest).

Beantworte:
1. Wie definiert messreihen.xml eine Messreihe? Welche Achsen/Dimensionen (Workload, Mess-Kategorie, Dataset, Permutation) drueckt sie aus?
2. Was ist das v32-Schema (messreihe_v32_schema.xsd)? Welche Elemente/Struktur?
3. Wie werden WORKLOADS (Lastprofile) und MESS-KATEGORIEN und DATASETS in diesen XMLs ausgedrueckt — sind sie hier (Diplomarbeit) definiert und werden an die cache-engine zur Interpretation gereicht?
4. Was ist die Beziehung experiment_config (Diplomarbeit-Profile) <-> load_profiles-XML (cache-engine-Lastprofil-Katalog)?

Gib die Profile-XML-Struktur mit datei:zeile + konkreten XML-Ausschnitten.`,
  },
  {
    label: 'cache-engine-interpretations-api',
    prompt: `READ-ONLY-Kartierer. cache-engine=${CE}. Keine mutierenden Befehle.

AUFGABE: Kartiere die INTERPRETATIONS-BIBLIOTHEK, die die cache-engine der Diplomarbeit fuer die Profile liefert (laut User "das ist alles schon geplant").

Lies (datei:zeile): die von der Diplomarbeit konsumierten Targets — comdare_builder_experiment_driver (libs/cache_engine/builder/experiment_driver/), comdare_builder_xml_config_parser, run_profile/RunProfileArgs (profile_run_entry.hpp), load_profile_parser.hpp (parse_load_profile/discover_load_profiles), workload_config.hpp, workload_profiles.hpp. Suche die oeffentliche API-Grenze (was exportiert die cache-engine als Profile-Interpretations-Bibliothek?).

Beantworte:
1. Welche konkrete API/Bibliothek liefert die cache-engine fuer (a) Profile-XML-Parsen, (b) Workload-Interpretation, (c) Experiment-Durchfuehrung?
2. Wie ist die Schnittstelle: Diplomarbeit-Profile-XML → cache-engine-Parse → WorkloadConfig/Experiment-Baum → Messung?
3. Ist diese Interpretations-Bibliothek VOLLSTAENDIG/geplant, oder fehlen Teile (z.B. Mess-Kategorie-Selektion, Dataset-Achse)?
4. Wo genau ist die compile-time (Achsen-Algorithmen) / runtime (Workloads/Datasets aus Profilen) Grenze in DIESER Bibliothek?

Gib die Interpretations-API mit datei:zeile.`,
  },
  {
    label: '31-verortung-korrektur',
    prompt: `READ-ONLY-Kartierer. super=${SUP}, Code=${CODE}, cache-engine=${CE}. Keine mutierenden Befehle.

AUFGABE: Verorte #31 (Mess-Frameworks x Workloads als feingliedrige 2D-Matrix-Module) KORREKT in der top-down-Architektur und bewerte einen Fehl-Bau.

Lies (datei:zeile): ${SUP}/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md; ${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (#31/F7-Eintraege); ${CE}/docs/architecture/ (falls #31-relevant). Beachte die Rollen-Trennung: Diplomarbeit stellt Profile bereit (experiment_config/messreihen.xml), cache-engine liefert die Interpretations-Bibliothek.

KONTEXT (Fehl-Bau, den ein Impl-Agent gemacht hat, NICHT committet): In der cache-engine (${CE}/libs/cache_engine/builder/workload_driver/workload_matrix.hpp) eine compile-time-mp11-Matrix workload_profile_list x dataset_list = 48 Zellen + measurement_category_axis.hpp (16 Kategorien). Der User sagt: das ist die falsche EBENE — Workloads/Datasets/Mess-Kategorien gehoeren in die Diplomarbeit-Profile-Ebene (XML), die cache-engine interpretiert sie nur.

Beantworte:
1. Was ist #31 (F7 2D-Matrix Mess-Frameworks x Workloads) im Licht der top-down-Architektur GENAU? In welcher Ebene/welchem Modul gehoert es hin (Diplomarbeit experiment_config? measurement-all-Familie? cache-engine)?
2. Was sagt Doc 15 (F7) ueber die Modul-Struktur (measurement-all: metrics/pmc/workloads) und die Option A/B/C?
3. Ist die cache-engine-workload_matrix.hpp die FALSCHE Ebene? Begruende gegen die Rollen-Trennung.
4. Was ist "schon geplant" fuer #31 und was fehlt konkret? Was waere der korrekte naechste Schritt?

Gib die #31-Verortung mit datei:zeile + klarer Ebenen-Zuordnung.`,
  },
  {
    label: 'measurement-all-und-4schichten-dossier',
    prompt: `READ-ONLY-Kartierer. super=${SUP}. Keine mutierenden Befehle.

AUFGABE: Kartiere die measurement-all-Familie + den frueheren 4-Schichten-Dossier (fuer die Ebenen-Klaerung).

Lies (datei:zeile): den frueheren 4-Schichten-Backup ${SUP}/docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-result-full.json (die 4 Layer, wie sie dort definiert wurden) + ${SUP}/docs/sessions/20260709-WORKFLOW-4layer-experiment-tree-DOSSIER.md. Suche die measurement-all-Familie (comdare-measurement-all: metrics/pmc/workloads) — wo liegt sie (Modules/? external/?), was ist ihre Struktur (baseline_0-core/1-instrumentation/2-workloads).

Beantworte:
1. Wie definierte der fruehere 4-Schichten-Dossier die 4 Layer? Waren es cache-engine-interne Schichten ODER die Diplomarbeit-Teilprogramm-Schichten?
2. Was ist die measurement-all-Familie (metrics/pmc/workloads)? Wie steht sie zur Diplomarbeit-Anwenderschicht und zur cache-engine? Ist sie ein 3. Baustein (Mess-Baseline-Module)?
3. Wo in der Gesamt-Architektur (Diplomarbeit / measurement-all / cache-engine) gehoeren Workloads (runtime), Mess-Kategorien (M) und Datasets hin?

Gib die Ebenen-Klaerung mit datei:zeile + Original-Zitaten aus dem Dossier.`,
  },
]

phase('TopDown-Kartieren')
const maps = await parallel(READERS.map((r) => () => agent(r.prompt, { label: r.label, phase: 'TopDown-Kartieren' })))

phase('Synthese')
const joined = maps
  .map((m, i) => (m ? `\n\n===== KARTIERUNG: ${READERS[i].label} =====\n${m}` : `\n\n===== KARTIERUNG: ${READERS[i].label} — FEHLGESCHLAGEN =====`))
  .join('')

const synthPrompt = `Du bist der Chef-Architekt der Diplomarbeit cache-engine. Dir liegen 6 TOP-DOWN-Kartierungen der DIPLOMARBEIT-ANWENDERSCHICHT vor (Gesamt-Architektur, 02_messung_driver, experiment_config/Profile-Schema, cache-engine-Interpretations-API, #31-Verortung, measurement-all/4-Schichten-Dossier).

KERN-KONTEXT (User-Direktiven, bindend):
- Die cache-engine ist die FRAMEWORK-/INTERPRETATIONS-Bibliothek: sie interpretiert + fuehrt die Profile durch (parse_load_profile, discover_load_profiles, ExperimentDriver, run_profile). "Das ist alles schon geplant."
- Die DIPLOMARBEIT (Code/: experiment_config-XML, messreihen.xml, test_data_xml, 02_messung_driver) STELLT DIE PROFILE-XML BEREIT, welche die cache-engine durchfuehrt.
- 19 Achsen permutativ COMPILE-TIME (Achsen-Algorithmen, je Kombination eine Binary, >=1e15 Raum) vs. 60+ dynamische Unter-Achsen RUNTIME (Workloads/Datasets/etc. aus den Profilen).
- Ein Impl-Agent hat FAELSCHLICH eine compile-time-workload_matrix (W x D = 48) + measurement_category_axis (M=16) IN DIE CACHE-ENGINE gebaut (uncommittet). Das ist die falsche EBENE.

Synthetisiere praezise mit datei:zeile-Belegen:

1. DIE VIER LAYER TOP-DOWN: Was sind die 4 Layer der Diplomarbeit-Architektur wirklich (die 4 Teilprogramme / Anwenderschicht → Framework → Pruefling → Manuskript, ODER eine andere 4er-Schichtung)? Wo ist die Grenze "Diplomarbeit stellt Profile bereit" vs. "cache-engine interpretiert"?

2. DER PROFILE-FLUSS: Wie fliesst ein Experiment top-down: experiment_config/messreihen.xml (Diplomarbeit definiert Workloads x Mess-Kategorien x Datasets x Permutationen) → 02_messung_driver → cache-engine-Interpretation (discover_load_profiles/run_profile) → Messung → Auswertung? Welche XML-Struktur/welches Schema traegt das?

3. #31 KORREKTE VERORTUNG: Wo gehoert #31 (Mess-Frameworks x Workloads als feingliedrige 2D-Matrix-Module) architektonisch hin — in die Diplomarbeit-Profile-Ebene (experiment_config/messreihen), in die measurement-all-Familie, oder (falsch) in die cache-engine? Was ist "schon geplant" und was fehlt konkret?

4. KORREKTUR DES FEHL-BAUS: Die cache-engine-workload_matrix.hpp (W x D = 48) + measurement_category_axis.hpp (M) — sind sie komplett falsch (revertieren), oder hat ein Teil (z.B. die Interpretations-Hilfen in der Bibliothek) Berechtigung? Was von dem uncommitteten Bau bleibt, was wird verworfen, was muss stattdessen in der Diplomarbeit-Ebene entstehen?

5. KORREKTER NAECHSTER SCHRITT fuer #31: Konkreter, ebenen-richtiger Bau-Plan — welche Dateien in welcher Ebene (Diplomarbeit experiment_config/messreihen-XML/messung_driver? measurement-all?), was genau, in welcher Reihenfolge. Beruecksichtige: Workloads/Datasets = runtime aus Profilen; Mess-Kategorien = Projektion; Achsen-Algorithmen = compile-time cache-engine (unberuehrt).

Sei schonungslos praezise und ebenen-sauber. Die Kartierungen:${joined}`

const synth = await agent(synthPrompt, { label: 'synthese-topdown-31-verortung', phase: 'Synthese' })

return { synthese: synth, kartierungen: maps }
