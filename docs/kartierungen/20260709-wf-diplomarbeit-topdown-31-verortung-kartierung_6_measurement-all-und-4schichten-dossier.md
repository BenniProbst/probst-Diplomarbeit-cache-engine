I have all the evidence needed. Here is the Ebenen-Klärung.

---

# EBENEN-KLÄRUNG — 4-Schichten-Dossier vs. measurement-all vs. cache-engine

## Vorbemerkung: drei GETRENNTE „Schichten"-Begriffe, die hier durcheinandergehen

Es kursieren drei verschiedene Zerlegungen, die nichts miteinander zu tun haben:

- **(I) Die 4 Layer des früheren Dossiers** = read-only-Kartierungsachsen **EINES Programms** (der cache-engine).
- **(II) Die Diplomarbeit-Teilprogramm-Schichten** = die 7 Pipeline-Stufen `Code/01_sample_data_generator … 07_tier_binary_report`.
- **(III) Die comdare-Matrix-Programmarchitektur** = Diplomarbeit (Product) ⟶ **measurement-all** (Mess-Baseline-Familie) + cache-engine (Framework-Modul). Das ist die „3-Baustein"-Sicht.

Die measurement-all-Baseline-Stufung (0-core/1-instrumentation/2-workloads) ist noch eine **vierte** Unterzerlegung, innerhalb von Baustein (III).

---

## FRAGE 1 — Wie definierte der frühere 4-Schichten-Dossier die 4 Layer?

**Antwort: Es waren CACHE-ENGINE-INTERNE Schichten, NICHT die Diplomarbeit-Teilprogramm-Schichten.** Alle 4 Layer sind Sub-Systeme innerhalb `Code/external/comdare-cache-engine/libs/cache_engine/`.

Beleg — das Workflow-Skript pinnt die Wurzel aller 4 Layer hart auf die cache-engine:
- `docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-script.js:10`: `const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'` — jeder der 4 Layer-Prompts läuft `In ${CE}` (`:14,19,24,29`).

Die 4 Layer (`workflow-script.js:13-34` + Synthese-Vorlage `:41-51`):
- **LAYER 1 = `experiment_tree`** (`:14`) — StaticAxisNode vs DynamicVariableNode
- **LAYER 2 = `builder`/CacheEngineBuilder** (`:19`) — die Naht `run_lazy_static_then_dynamic`
- **LAYER 3 = `anatomie`** (`:24`) — Gattung/Genus/Typ, golden_fullpilot_320
- **LAYER 4 = `mess_achsen`** (`:29`) — Workload/Mess-Kategorie-Achsen

Der Dossier-Titel bestätigt die Innensicht: `workflow-result-full.json:2` „**4-Layer-Architektur-Analyse: Einstellbarkeit des Experiment-Baums in CacheEngineBuilder (compile-time/runtime-Hybrid)**". Die Synthese selbst relativiert die „4 Schichten" sogar — `workflow-result-full.json:12` / Backup `kartierung_2_4-schichten-dossier-backup.md:12`: „Es sind **nicht** vier gleichrangige Hierarchie-Schichten, sondern **ein Zwei-Ebenen-System (compile-time ⊥ runtime) plus eine orthogonale dritte (Mess-)Ebene**. Die vier Karten sind vier read-only-Kartierungs-Achsen desselben Baums."

→ Die 4 Layer haben mit den Diplomarbeit-Teilprogrammen (`Code/01..07`) **nichts** zu tun; sie zerlegen ausschließlich die ce-Builder-Maschinerie.

---

## FRAGE 2 — Was ist die measurement-all-Familie? Ist sie ein 3. Baustein?

**Antwort: JA — measurement-all ist ein eigenständiger 3. Baustein: eine Mess-Baseline-Modul-FAMILIE der comdare-Matrix, getrennt von cache-engine (Framework-Modul) UND Diplomarbeit (Product/Anwenderschicht).**

**Wo sie liegt:** `/home/comdare/Projekte/Modules/comdare-measurement-all/` — **Geschwister des super-Repos**, im `Modules/`-Baum, **NICHT** unter `Code/external/` und **NICHT** im super-Repo. (Der super-Repo hat gar kein `Modules/`.) Verifizierte Ist-Struktur:

```
Modules/comdare-measurement-all/
├── comdare-baseline_0-core/           comdare-metrics
├── comdare-baseline_1-instrumentation/ comdare-pmc
└── comdare-baseline_2-workloads/       comdare-workloads
```

Beleg-Zitate:
- `Modules/comdare-measurement-all/README.md:1-8`: „**Mess-Familie der comdare-Matrix (Familie x Baseline-Stufen x Module)** … 0-core: Mess-Kern: comdare-metrics … 1-instrumentation: comdare-pmc … 2-workloads: comdare-workloads inkl. dataset_loader/workload_generator". Provenienz `:20`: „GitLab comdare/modules/comdare-measurement/comdare-measurement-all, **Projekt-ID 300**".
- F7-Plan `docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md:9`: „`comdare-measurement-all` ist heute eine **strikt 1D-Baseline-Schichtung** (Familie × Baseline-Stufe, je Stufe genau **eine** Zelle), INV-2-konform `n→n-1`". Die Belang-Achse ist `:13-16`: „`baseline_0-core` → `comdare-metrics` (Signal-/Collection-Kern, IMeasurementObserver …) · `baseline_1-instrumentation` → `comdare-pmc` (IPmcSource, Linux-perf/Windows-PCM, compile-time Factory) · `baseline_2-workloads` → `comdare-workloads` (LoadGen + Dataset, YCSB-Kern, Driver, Dataset-Registry — **gebündelt**) · `baseline_3-analysis` (nur vorgesehen, leer)". Und `:18`: „Die ‚Achsen' dieser 1D-Schichtung sind **Mess-BELANGE (Kern → Instrumentierung → Last), NICHT Framework × Workload**."

**Verhältnis zu cache-engine und Diplomarbeit** — `Code/external/comdare-cache-engine/modules/README.md:37-47`:
> „Die cache-engine ist ein **Framework-MODUL der comdare-Matrix**; ihr domänenspezifischer Kern wird eine **eigene Modules-Familie**; die **Diplomarbeit ist deren Product und Außen-Interface**. … Bereits ausgeführt: **Schritt 0 — neue Familie `comdare-measurement-all`**".

Das ergänzt die ce-interne „WAS vs WIE"-Direktive (aus LAYER-2-Karte, `main.cpp:8-12`): „cache-engine = **WIE** gemessen wird (Builder/Codegen/Loader/Workload-Generator), Diplomarbeit = **WAS**." measurement-all ist die **herausgezogene, kanonische Mess-Infrastruktur** dieses „WIE".

**Wichtige Ist-Nuance (Duplikat-Zustand):** Der Mess-Code lebt HEUTE noch dupliziert **im ce-Monolith** (`Code/external/comdare-cache-engine/libs/common/measurement/` mit dataset_loader, hdr_histogram_wrapper, papi_/perf_wrapper, platform_probe, run_recorder; + `libs/cache_engine/.../measurement/`). measurement-all ist die faithful-portierte Familie daneben. Erst nach Migrations-Schritt 13 konsumiert die Diplomarbeit measurement-all direkt statt der ce-Kopie — F7:55: „**NACH Migrationsplan-Schritt 13 (GATED): Diplomarbeit konsumiert `measurement-all` statt ce-Kopie** — dann läuft die 2D-Matrix produktiv gegen die Tier-Binaries." Bis dahin ist alles rein additiv/neutral (F7:5).

Ledger-Bestätigung des vollzogenen Standes (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:328-329`): „**measurement-all-Familie = metrics(76)+HDR · pmc(320) · workloads(321), INV-2-konform, alle CI-grün**." (Die Zahlen sind GitLab-Projekt-IDs der Zellen; 300 = Umbrella.)

---

## FRAGE 3 — Wo gehören Workloads (runtime), Mess-Kategorien (M), Datasets hin?

Klare Zuordnung, aus F7-Plan + SYNTHESE der zweiten Kartierung. **Zwei Ebenen sauber trennen:** (a) welche measurement-all-Zelle die Definition/Generika hält, (b) welche Rolle sie in der ce-Experiment-Baum-Mechanik spielt.

| Element | Gehört in measurement-all-Zelle | Rolle in der ce-Baum-Mechanik (LAYER 1/4) | Beleg |
|---|---|---|---|
| **Workloads (W, runtime)** | `baseline_2-workloads` / `comdare-workloads` (LoadGen, YCSB-Kern, Driver) | **RUNTIME**, lauf-multiplizierend — dynamische `AxisLevel{"workload", …, is_static=false}`, `DynamicVariableNode` (nicht in `binary_id`) | F7:15,26; SYNTHESE.md:82 |
| **Datasets (D, runtime)** | `baseline_2-workloads` / `comdare-workloads` (Dataset-Registry, **gebündelt** mit Workloads) | **RUNTIME**, lauf-multiplizierend — konzeptionell dynamische Achse; **heute im ce noch NICHT als AxisLevel verdrahtet** (Lücke A-G2) | F7:15,26; SYNTHESE.md:83 |
| **Mess-Kategorien (M, 16)** | gesplittet: `baseline_0-core`/`comdare-metrics` (zeit-/observer-basiert) + `baseline_1-instrumentation`/`comdare-pmc` (zählerbasiert/PMC) | **MESS-OUTPUT-PROJEKTION** — **kein** Baum-Knoten, **kein** Lauf-Multiplikator; Spalten-Projektion aus dem einen POD `ComdareMeasurementSnapshotV1` | F7:22-24; SYNTHESE.md:84 |

Original-Zitate:
- F7-Plan `15_…:22-24` (Achse M, tragende Zweiteilung): „**zeit-/observer-basiert** (Wall-Clock, HdrHistogramm, Per-Achsen-Observer) … heute in `metrics(b0)`. **zählerbasiert (PMC)** (Cache/dTLB/Branch-Miss, IPC/CPI) … heute in `pmc(b1)`."
- F7-Plan `15_…:26` (Achse W + Datasets): „die Benchmark-Frameworks … werden … **‚zu einem gemeinsamen Satz von Lastprofilen abstrahiert'** — konkret die YCSB-Profile A/C/E, gekreuzt mit dem **6er-Datensatz-Kanon** (url/dna/protein/xml/tpcds-id/trec-terms, #25). Thesis: **‚der Workload als dynamische Achse'**."
- SYNTHESE.md:84 (M korrekt compile-time-Liste, WEIL keine Lauf-Achse): „**M ist compile-time korrekt, WEIL M keine Lauf-Achse ist** (sie projiziert Spalten des einen Snapshots; ein Kreuzprodukt mit M würde die Läufe fälschlich ×16 blähen). **W/D müssen runtime sein, WEIL sie Lauf-Achsen sind** (Drop-in ohne Rebuild)."

**Die entscheidende Asymmetrie (für Ebenen-Trennung zentral):** W und D sind **Mess-INPUT** → runtime, lauf-multiplizierend, dynamische AxisLevel (`is_static=false`), nie in `binary_id`/golden_320. M ist **Mess-OUTPUT** → compile-time-Liste + constexpr-Regime-Klassifikator, aber **niemals** ein `mp_product`-Faktor der Lauf-Matrix. Achsen-Algorithmen (search_algo/node_type/memory_layout/prefetch = golden 320) sind das Dritte: **compile-time Binär-Identität** in LAYER 3. Beleg-Direktive gegen die Verwechslung: F7:34/59 (Option A, „Workload als **dynamische Achse** = Parametrisierung, nicht Modul-Explosion"; „golden_fullpilot_320 … unberührt (Mess-Matrix ist **orthogonal** zur Anatomie-Permutation)").

---

## Kern-Belegdateien (absolut)

- 4-Schichten-Dossier: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-script.js` (Layer-Definition `:10,13-34,41-51`) + `workflow-result-full.json` (`:2` Titel, `:12` Synthese-Relativierung)
- Backup-Kartierung derselben 4 Layer: `.../backups/20260709-wf-architektur-4schichten-workloads/kartierung_2_4-schichten-dossier-backup.md` + `SYNTHESE.md` (W/D/M-Tabelle `:82-84`)
- measurement-all-Familie: `/home/comdare/Projekte/Modules/comdare-measurement-all/README.md` + Zellen `comdare-baseline_{0-core/comdare-metrics, 1-instrumentation/comdare-pmc, 2-workloads/comdare-workloads}`
- F7-Plan (autoritativ für Baustein III + Q3): `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`
- 3-Baustein-Direktive: `.../Code/external/comdare-cache-engine/modules/README.md:37-47`; Schnitt: `.../docs/sessions/20260706-274-MATRIX-MIGRATIONSPLAN-ENTWURF.md:12`; F14-Mapping + Stand: `.../docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:60,310,328-329`
- Heutige Duplikat-Kopie im ce-Monolith: `.../Code/external/comdare-cache-engine/libs/common/measurement/` + `libs/cache_engine/.../measurement/`