I now have comprehensive coverage of all 19 focus docs plus the TIER audit and the structural maps of the two large docs. Here is the complete architecture-documentation map.

---

# Kartierung der Architektur-Doku — E1–E4-Experiment-Maschinerie

**Pfad-Wurzeln** (alle Belege datei:zeile relativ dazu):
- `SUP` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/architektur/`
- `CE` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/docs/architecture/`

**E-Ebenen-Legende** (deine Terminologie ↔ Doku-Bausteine):
- **E4** = XML-Experiment-Definition + Auswertung → `messung_driver` (WAS), read-only Baum-Traversal, inverse Signatur-Projektion, LaTeX-Appendix
- **E3** = Permutations-B+-Baum pro Gattung → `experiment_tree.hpp`, `PermutationEngine<…>`, die 4 Brücken, `StaticBinaryView` (Mixed-Radix)
- **E2** = Tier-Binaries compile-time → `AdHocComposition<19>`, `StaticAxisNode`, `adhoc_emitter`, `SearchAlgorithmAbiAdapter`, DLL-Module
- **E1** = RC-Laufzeit → `Algorithm_Resource_Control`, `DynamicVariableNode`, FOR-Schleife auf geladener Binary, Lastprofile/YCSB, Zwei-Phasen-Op-Schleife

---

## 1. MASTER-STAND — der autoritative Gesamt-Architektur-Stand

**Zentraler Befund für dein Dossier:** Es gibt zwei Master-Docs mit **Vorrang-Relation**. `SUP/02` ist **SUPERSEDED**, `CE/34` ist die **Single-Source-of-Truth**.

### `SUP/02_aktueller_master_REV7_7.md` (378 Z.) — SUPERSEDED-Planungsstand
- **Explizites Superseded-Banner** (`SUP/02:3-6`): „Dieser REV7.7/V31-Master ist vom Code überholt … IST-treue Single-Source-of-Truth: ledger + e2e-abnahme-audit."
- **Kern-Strukturen (das ALTE Vokabular):** 3-Säulen-Architektur `IExecutingEngine → ISearchEngine/IFutureEngine` (Ebene 1) / Saeule-A Suchdatenstruktur (Ebene 2) / Saeule-B CacheEngine+Plattform (Ebene 3) (`SUP/02:17-42`); **11 Bausteine-Achsen** PAGE-TYPE…TELEMETRY (`SUP/02:302-318`); **29 ICacheStrategy-Familien / 12 Sub-Engines / F1-F29** (`SUP/02:76-83`); 3-Repo-Layer + 3 Pflicht-Messreihen A/B/C als XML-Configs (`SUP/02:46-64`); Permutationsraum „30 SOTA × 10 Allokator × 6 Workloads = 1800" (`SUP/02:296-298`).
- **Status laut `CE/34 §11`:** Dieses gesamte F1–F29-/S1–S30-/11-Achsen-/3-Säulen-Vokabular ist „ALTER Planungsstand … dient nur als Begriffs-/Paper-Mapping-Historie. In keiner B-/E-Arbeit vermischen" (`CE/34:202-204`).

### `CE/34_KONSOLIDIERTER_MASTER_IST_STAND.md` (235 Z.) — AUTORITATIV
- **Zweck** (`CE/34:3-11`): EIN konsolidiertes IST-Doc über 48 Quellen; Quellen-Hierarchie bei Widerspruch: **Doc 30 §8.0 > IST-Ledger > e2e-Abnahme > Code > diese Konsolidierung > Einzel-Docs 15–33 > Thesis-Basis 00–14 (SUPERSEDED)** (`CE/34:10-11`).
- **Kern-Struktur 1 — Das 3-Ebenen-Modell (`CE/34:15-34`, „AUTORITATIV, code-verankert"):**
  1. **GATTUNG = ein Außen-INTERFACE = ein Prüf-Dock**, es gibt **3**: SearchAlgorithm / Container / Graph (`AnatomyGattung`-Enum).
  2. **TIER-/LEBEWESEN-UNTERKLASSE = fester Achsen-Satz** unter dem Interface, **5** (`AnatomyGenus`): SearchAlgorithm / Set / Sequence / Adapter / View. Invariante: feste Slot-Zahl = ABI-Identität (`AdHocComposition<19>`).
  3. **ACHSEN = Organe, KEINE ist optional** — nicht-pufferndes Lebewesen wählt Durchreich-Algorithmus (`NoBuffer`/`NoFlush`/…).
  - **Per-Unterklassen-Slots** (`CE/34:29-32`, code-verifiziert GenusBound 5/5): SearchAlgorithm **19** · Adapter **13** · Set **15** · Sequence **11** · View **7**. **Nur SearchAlgorithm voll gebaut** (BR-1..4); übrige 4 = GenusBindingTraits-Bindings.
- **Kern-Struktur 2 — Organ-Metapher = Permutation = Organ-Tausch** (`CE/34:36-50`): `IExecutionEngine` (Wurzel) → `IAnatomyBase` (Lebewesen) **vs** `IVirusExecutionEngine` (Viren, Geschwister); PermutationEngine = Anatomie-Generator; `SearchAlgorithmAnatomy<C>` = Organ-Container; CacheEngineBuilder = Mess-Orchestrierung.
- **Kern-Struktur 3 — B+-Experiment-Baum** (`CE/34:52-71`): Achsen = Baum-Ebenen; Pfad Wurzel→Blatt = `binary_id`; **Gate-1: `binary_count() == ∏ mp_size(Enabled_i) == PermutationEngine::count() == 137.594.142.720.000`**; NIE voll materialisiert (C1060, eager build ~21 GB); die **4 Brücken** BR-1..4; Knoten via Abstract Factory (`StaticAxisNode`/`DynamicVariableNode`); **5 per-Gattung-PermutationEngines**.
- **Kern-Struktur 4 — 4-Subsystem-Modell + 3-Stufen-Prüfung** (`CE/34:73-85`).
- **Kern-Struktur 5 — Mess-Modell HYBRID, 2 Pfade / 3 Dimensionen** (`CE/34:87-106`).
- **Kern-Struktur 6 — Observer-Konsolidierung I1** (`CE/34:108-123`): EIN POD `ComdareTierObserverSnapshot` (`axis_stats[19][8]` + `seg_ns[19]` + Meta, sizeof 1400), ABI-Major 2→3.
- **Der eine echte Defekt** (`CE/34:156-164`): **Befund 2 / Q2-Schritt-4** — `search_organ_`-Monolith beschattet node_type/memory_layout → Lebewesen routen NICHT uniform durch alle Organe → Achsen-Diffs teils Apparat-Artefakt (mission-kritisch).

---

## 2. E1–E4-relevante CE-Docs

| Doc | Titel / Kern-Aussage | E-Ebene |
|---|---|---|
| **`CE/24`** messmodell_korrektur_zwei_dimensionen (675 Z.) | **Das 2D(→3D)-Mess-Modell.** Messung hat **2 getrennte Dimensionen + 1 Vergleichs-Dim** (`CE/24:34`): §2.1 Lebewesen-Wall-Clock (Füllstand-Kurven r/w/d, RAM/Disk) `CE/24:36-48` · §2.2 Per-Achsen-`observe_all()`→ObserverAggregate `CE/24:50-61` · §2.3 Achsen-Vergleich via Tests gegen std::map — **„welche Achsen-Variante besser ist, entscheidet §2.3, NICHT die Latenz"** (`CE/24:75-81`). §8.1 HYBRID = **Pfad A** (isolierte Achsen IN der DLL via `run_workload`) vs **Pfad B** (composite Lebewesen zentral host-seitig via Observer) `CE/24:307-334`. §8.8 **Prüf-Dock** je Gattung `CE/24:499-568`. §8.9/§8.9.1 PRT-ART-Join (3 Muster) + **Regel der abstrakt-leeren Achse** (`B = ∏ über LEERE Achsen`) `CE/24:649-671`. | **E4/E1** (Mess-/Auswerte-Modell, deckt alle Ebenen) |
| **`CE/26`** permutations_bplus_baum_und_inverse_signatur (206 Z.) | **Ersetzt FNV1a-Fingerprint durch B+-Baum + serialisierte Pfad-Signatur.** Jede Baumebene = Achsen-Entscheidung; gepinnt→Fanout 1, freigegeben→Fanout N (`CE/26:49-52`); Blatt = ExperimentSetting (Binary × dyn. Belegung); **STATISCH = neue Binary laden, DYNAMISCH = FOR-Schleife via `Algorithm_Resource_Control`** (`CE/26:66-73`); nie voll materialisiert (OOM/21 GB, `CE/26:80-97`); 2 Knotenarten via Factory Method (`CE/26:130-164`); inverse Auswertung = `multimap<Signatur, Paper>` (`CE/26:122-127`). | **E3** (Baum) + **E1** (dyn. Knoten) + **E4** (inverse Signatur) |
| **`CE/27`** experiment_baum_registry_bindung_4_bruecken (326 Z.) | **Der verbindliche Umsetzungsplan der 4 Brücken.** 22 Achsen = 19 SA (17 AdHoc-Slots T0–T16 + q1/q2) + 3 Build (`CE/27:44-85`). **BR-1** Registry→AxisLevels · **BR-2** Blatt-Pfad↔`AdHocComposition<17>` · **BR-3** NodeValue→realer ObserverSnapshot · **BR-4** generierte Binary→reale Anatomie (`COMDARE_DEFINE_ANATOMY_MODULE_ADHOC`) — alle DONE+verifiziert (`CE/27:149-252`). **C1060-Befund**: Voll-Typ-Baum infeasible → nur zählen (`CE/27:289-302`). | **E3** (Baum↔Registry) + **E2** (Blatt→Binary BR-4) |
| **`CE/28`** vollstaendigkeits-kartographie (137 Z.) | **SOLL-Zustand ALLER 22 Achsen + 5 Lebewesen-Unterklassen + 4 Brücken.** Achsen-Tabelle T0–T16 + 5 außerhalb (`CE/28:47-77`); 5-Unterklassen-Tabelle mit Slots/Anatomie/ABI/Observer/Dock-IST (`CE/28:87-96`); die 6 Gates (`CE/28:106-113`); Skalierung: lokal zählen / ZIH bauen / Prüf-Dock messen (`CE/28:115-122`); SOLL-vs-IST + offene Tasks #74–#77 (`CE/28:124-137`). | **E3** (Baum-Vollständigkeit) + **E2** (Binaries) |
| **`CE/29`** experiment_baum_generik_und_composition_driver (140 Z.) | **Baum-Kern ist generisch** über beliebige Achsenzahl/Gattung (`experiment_tree.hpp:build(vector<AxisLevel>)`, `CE/29:6-15`); pro-Gattung-parametrisch via `genus_binding_traits.hpp` `GenusBindingTraits<G>`. **Composition-Driver-Befund**: `observe_all` treibt real nur `search_algo` (protected-CRTP-ctor-Block, `CE/29:44-46`); Lösung = Observable-Hüllen (telemetry/memory_layout als 2./3. reale Achse verdrahtet, `CE/29:122-138`). | **E3** (Generik) + **E2** (Composition-Driver) |
| **`CE/31`** observer_interface_konsolidierung_i1 (122 Z.) | **Von V1/V2/V3/V4 zu GENAU EINER Observer-Schnittstelle** (`tier_observe`, POD `axis_stats[19][8]+seg_ns[19]+Meta`, `CE/31:44-62`). ABI-Robustheits-Rationale: neue Mess-Fähigkeit NIE ans vtable-Ende (SEH 0xc0000005), sondern Sub-Interface + `dynamic_cast` 1× kalt (`CE/31:24-33`); Versionierung via ABI-Major 2→3 (Loader-Reject, `CE/31:82-90`); Q1-Sequenz gegen Doppelzählung (`CE/31:97-103`). **Mess-Visitor-Etikett:** real = flacher POD-Pull, KEIN Visitor. | **E2** (ABI-POD in Binary) → **E1/E4** (Host liest) |
| **`CE/32`** lastprofil_katalog_und_paper_bias (73 Z.) | **14 Lastprofile LP01–LP14** (→ 21 XMLs, LP06-negsweep ×5) `CE/32:11-36`; **Paper-Bias-Kern**: jedes Paper wählt Heimspiel-Lastprofil → um Bann zu brechen, ALLE Lastprofile über ALLE Lebewesen; **Workload = dynamische Achse 2 im B+-Baum** (`CE/32:3-6`); 5 Bias-Kategorien (`CE/32:44-59`). | **E1** (Laufzeit-Lastprofile) + **E4** (Bias-Bruch-Auswertung) |
| **`CE/36`** eine_architektur_lebewesen_ist_searchalgorithm (189 Z.) | **`Lebewesen ≡ SearchAlgorithm`, EINE Hierarchie, keine Parallel-Bäume** (`CE/36:18-27`): `IExecutionEngine → IAnatomyBase → SearchAlgorithmAnatomy<C> → SearchAlgorithmAbiAdapter<A> → 19 Achsen`; „SearchEngine" = nur ABI-Sicht, KEINE 2. Hierarchie. Term-Mapping Metapher↔Code (`CE/36:111-121`). Code-IST-Defekt I1 (zwei Bäume) **DURCHGEFÜHRT behoben 2026-06-25** (`CE/36:170-178`). | **E2** (Anatomie/ABI-Hierarchie) |
| **`CE/messarchitektur_v5_design`** (299 Z.) | **Bindende Mess-Spezifikation.** Zwei Seiten, EINE ABI-Grenze (`CE/v5_design:18-58`); **memento_all** parallel zu observe_all (9 stateful / 8 stateless Achsen, `CE/v5_design:135-148`); **Zwei-Phasen-Op-Schleife PFLICHT** (`save→op-warmup→rollback→op-measure`, `CE/v5_design:176-189`); Konformitäts-Gate gegen std::map (`CE/v5_design:211-223`); observer/memento rein compile-time entfernbar (`CE/v5_design:227-243`). „Hybrider Visitor"-Etikett gestrichen (real = Memento-vtable, `CE/v5_design:63-67`). | **E1** (Zwei-Phasen-Laufzeit) + **E2** (compile-time Mess-Einbau) |
| **`CE/messarchitektur_v5_drei_profile`** (55 Z.) | **3 streng orthogonale Profile:** (1) BUILD (compile-time: welche Binaries) ⊥ (2) LASTENPROFIL (runtime host: YCSB, Seed) ⊥ (3) COMPILE-RELEASE (`COMDARE_MEASUREMENT_MODE`) `CE/drei_profile:10-14`. **Build ⊥ Last = kartesisches Kreuz** (1 Binary × N Lastprofile ohne Rekompilation, `CE/drei_profile:18-30`). | **E2** (Build ⊥) + **E1** (Last ⊥) |
| **`CE/messarchitektur_v5_entscheidungen`** (99 Z.) | **Bindendes Entscheidungs-Log.** Lebewesen-Binary exportiert nur `IDriveableTier` (+ observer/memento nur Messung-AN, `CE/entscheidungen:10-13`); KEINE Workloads in der DLL (V3-Designfehler); IDriveableTier-Vollständigkeit = volle std::map-Hülle je Gattung (`CE/entscheidungen:78-92`). | **E2/E1** (ABI-Antrieb) |

---

## 3. Schichten-/Ebenen-Docs (SUP)

| Doc | Titel / Kern-Aussage | E-Ebene |
|---|---|---|
| **`SUP/10`** schichten_modell_M (269 Z.) | **4-Subsystem-Modell** (`messung_driver → CacheEngineBuilder → CacheEngine ↔ Prüfling`, `SUP/10:62-101`); **§0-Korrektur**: CEB orchestriert CE UND prt-art als **zwei gleichwertige ExecutionEngines via Command-Pattern** (`SUP/10:10-42`); bidirektionale CE↔Prüfling-Beziehung (`SUP/10:122-186`); Phasen 1–7 mit Owner-Zuordnung (`SUP/10:208-222`). **Von `CE/34 §4` als Doc-10-Basis autoritativ übernommen.** | **E4** (messung_driver-Outer-Loop) + Subsystem-Rahmen |
| **`SUP/14`** achsen_komposition_organ_metapher (3462 Z.) | **DIE autoritative Organ-Metapher-Quelle** (von `CE/34 §2`, `CE/36`, `CE/28` als AUTORITATIV zitiert). §1 Kern-Metapher verbatim „Achse = Organ, Permutation = genetisches Experiment am Lebewesen" (`SUP/14:58-95`); §17 **3-Akteure-Trennung** (PermutationEngine / SearchAlgorithmAnatomy / CacheEngineBuilder, `SUP/14:670-776`); §26 std-Container-Gattungen (`SUP/14:1018-1091`); §28 **Achsen-Verteilung pro Lebewesen-Unterklasse** (Tabelle Mammal/Bird/Reptile/Invertebrate/Plant, `SUP/14:1180-1208`); §29 **PermutationEngine-Spezialisierung pro Gattung** (Code, `SUP/14:1212-1289`); §32 Gattungs-Constraint (Cross-Genus type-unmöglich); §33-40 ExecutionEngine-Wurzel + Lebewesen vs Viren (`SUP/14:1444-1715`). | **E2** (Anatomie/Composition) + **E3** (per-Gattung PermutationEngine) |
| **`SUP/15`** F7_mess_frameworks_workloads_2d_matrix_plan (59 Z.) | **PLANUNG** (kein Increment): Mess-Frameworks × Workloads als 2D-Matrix. Achse M = Mess-Kategorien (zeit/observer vs PMC-zähler) `SUP/15:22-24`; Achse W = Workloads (YCSB A/C/E × 6 Datasets) `SUP/15:26`; Empfehlung **Option A = compile-time-Parametrisierung** analog ce-Anatomie-Matrix (`SUP/15:34-38`). Orthogonal zur Anatomie-Permutation. | **E4** (Mess-Matrix, orthogonal) |
| **`SUP/TIER-AUFLOESUNG-…`** (406 Z.) | **Begriffs-Audit „Tier".** Löst 4 Bedeutungen: ① Lebewesen/Anatomie · ② Subject/Mess-Schicht · ③ Band/Cache-Ebene · ④ Rang/SOTA (`SUP/TIER:56-61`). **Kompakte 4-Ebenen-Landkarte** (`SUP/TIER:108-122`): Gattung(3)/Lebewesen-Unterklasse(5)/Achse=Organ(19)/Sub-Achse(~279). **Aufbau-Seite ① ⊥ Mess-Seite ②** (`idriveable_tier.hpp:6`, `SUP/TIER:150-187`). prt-art = 8 Bausteinschichten (`SUP/TIER:189-203`). | Begriffs-/Rollen-Rahmen für **E1–E4** |

---

## 4. GESAMT-SYNTHESE — die autoritative Architektur (zitierfähige Karte)

Die Konsolidierung erfolgt **gegen `CE/34` (IST-SSoT) + `SUP/14` (Organ-Metapher, AUTORITATIV)**; `SUP/02` + das F1–F29/3-Säulen/11-Achsen-Vokabular gilt als SUPERSEDED (`CE/34:200-208`).

### A) Die 3-Ebenen-Anatomie (A1–A3) — `CE/34:15-34`, `SUP/TIER:108-122`, `CE/36:18-27`
```
IExecutionEngine  (Wurzel: alles Ausmessbare)                    CE/36:19, SUP/14 §35
 ├─ IAnatomyBase (Lebewesen)          ⊥   IVirusExecutionEngine (Viren: Graph/FFT/Crypto)
 │
 │  Ebene 1  GATTUNG = Außen-Interface = Prüf-Dock   → 3: SearchAlgorithm / Container / Graph
 │           (AnatomyGattung)                          CE/34:19, CE/36:60-63
 │  Ebene 2  LEBEWESEN-UNTERKLASSE = fester Achsen-Satz → 5: SearchAlgorithm / Set / Sequence / Adapter / View
 │           (AnatomyGenus)   Slots: 19 / 15 / 11 / 13 / 7   CE/34:29-32, SUP/TIER:117
 │  Ebene 3  ACHSE = Organ (keine optional; Durchreich statt Weglassen)  CE/34:25-27, SUP/14:1170-1174
 │  Ebene 4  SUB-ACHSE = Organ-Bestandteil (~279)     SUP/TIER:114/144-146
```
- **A1 Composition** (Genom): `AdHocComposition<T0..T18>` = 19 named using-Slots, `static_assert sizeof...==19`, keine Template-Defaults — `CE/34:43-44`, `CE/36:83-84`.
- **A2 Anatomie** (Körper, compile-time): `SearchAlgorithmAnatomy<Composition>` hält die Organe, `observe_all()→ObserverAggregate`, `genus()==SearchAlgorithm` — `SUP/14:688`, `CE/36:71-76`.
- **A3 AbiAdapter** (Laufzeit-Sicht über DLL-Grenze): `SearchAlgorithmAbiAdapter<A> : IAnatomyBase, IMeasurableWorkload, IObservableTier` (Reihenfolge eingefroren) — `CE/34:114-116`, `CE/36:88-92`.
- **19 SearchAlgorithm-Achsen T0–T18** (`CE/34:139-142`): search_algo · cache_traversal · mapping · path_compression · node_type · memory_layout · allocator · prefetch · concurrency · serialization · telemetry · value_handle · isa · index_organization · io_dispatch · migration_policy · filter · queuing_q1 · queuing_q2 (+3 Build-Achsen page_type/09b/12 = Codegen-Varianten DERSELBEN Binary → historische „22").

### B) Die E1–E4-Experiment-Maschinerie (der eigentliche Motor)
```
E4  messung_driver (WAS) ── XML comdare_thesis_profile ──> read-only Baum-Traversal + inverse Signatur → CSV/LaTeX
      SUP/10:62-71 · CE/26:21-26 · CE/34:212-222 · KF-15 multimap<Signatur,binary_id>  CE/26:122-127
        │  liefert gepinnt/freigegeben je Achse
        ▼
E3  Permutations-B+-Baum PRO GATTUNG   experiment_tree.hpp / PermutationEngine<TopicConfigSets…>
      Achse = Baum-Ebene; Pfad Wurzel→Blatt = binary_id; StaticBinaryView = Mixed-Radix-Bijektion
      Achsen-Austausch = Ziffernwechsel tuple[d] (O(Geschwister))            CE/34:52-58, CE/26:46-73
      Gate-1: binary_count() == ∏ mp_size(Enabled_i) == PermutationEngine::count() == 137.594.142.720.000
              CE/34:61-62, CE/27:298-302  ·  NIE voll materialisiert (C1060, ~21 GB)  CE/26:80-91
      4 Brücken BR-1..4 (Registry→Baum→Composition→Observer→Binary)          CE/27:149-252, CE/28:98-104
        │  StaticAxisNode (compile-time → EINE Binary)
        ▼
E2  Tier-Binaries compile-time   adhoc_emitter → COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ>) → SHARED-DLL
      AnatomyModuleLoader → dynamic_cast<IObservableTier*>                    CE/34:65-66, CE/27:231-248
        │  DynamicVariableNode (Laufzeit-FOR-Schleife auf geladener Binary)
        ▼
E1  RC-Laufzeit   Algorithm_Resource_Control (thread_count/hw_prefetcher) — KEINE neue Binary
      Lastprofil = dynamische Achse 2 (14 LP → 21 XML)                        CE/26:69-73, CE/32:3-6
      Zwei-Phasen-Op-Schleife (save→op-warmup→rollback→op-measure) PFLICHT    CE/v5_design:176-189, CE/34:104-105
```
- **Abstract-Factory** der Knoten (`CE/26:130-164`): `AbstractNodeFactory` mit `make_static`/`make_dynamic` → 2 distinkte Produkte `StaticAxisNode` (E2) / `DynamicVariableNode` (E1); `NodeKind`-Enum, kein bool-Flag.
- **5 per-Gattung-PermutationEngines** (`CE/34:70-71`, `SUP/14:1240-1270`): `SearchAlgorithmPermutationEngine : PermutationEngine<…>` etc. — Cross-Genus type-unmöglich (disjunkte Achsen-Sets, `SUP/14:1333`).

### C) Die zwei (drei) Mess-Dimensionen + zwei Pfade — `CE/24`
- **3 Dimensionen** (`CE/24:77-81`): (1) Lebewesen-Wall-Clock (Füllstand-Kurven r/w/d, RAM/Disk) · (2) Per-Achsen-Observer (`observe_all`) · (3) Achsen-Vergleich (Tests gegen std::map — **entscheidet Achsen-Güte, nicht Latenz**).
- **2 Pfade über DIESELBE Binary** (`CE/24:322-328`, `CE/34:89-92`): **Pfad A** = isolierte Achsen IN der DLL (`IMeasurableWorkload::run_workload`, host-seitige Aggregation + `f15_compare`) · **Pfad B** = composite Lebewesen zentral via `IObservableTier::tier_observe` (POD `axis_stats[19][8]+seg_ns[19]+Meta`, ABI-Major 3).
- **3 orthogonale Profile** (`CE/drei_profile:10-14`, `CE/34:100-103`): BUILD ⊥ LASTENPROFIL ⊥ COMPILE-RELEASE; Build ⊥ Last = kartesisches Kreuz.
- **Prüf-Dock** je Gattung (`CE/24:523-529`): CEB-Seite, lädt+treibt Gattungs-API+misst Observer; EIN Dock je Gattung; `PruefDockRegistry::select_for` via `genus()`.

### D) Gattungen / Abstract-Factory / Prüfling-Join
- **Achsen-Verteilung pro Lebewesen-Unterklasse** (`SUP/14:1180-1208`): Mammal(Search) = alle 19; Set/Sequence/Adapter/View = Teilmengen + eigene Achsen (`inner_container`/`growth`/`extent`/`layout`/`accessor`).
- **3-Stufen-Prüfung / PRT-ART** (`CE/24:589-608`, `CE/34:81-85`): Stufe 1 `comdare_perms_ce` (A) · Stufe 2 `comdare_perms_<pf>` (B, Prüfling-ersetzt) · Stufe 3 `comdare_perms_full_join` (A⋈B = „Schnabeltier"). **Regel der abstrakt-leeren Achse**: leere Prüfling-Achse reust ALLE CE-Algos → Stufe-2-Raum = ∏ über die LEEREN Achsen (`CE/24:649-664`).

### E) Was konsolidiert werden muss (die Bruchlinien fürs Dossier)
1. **Vokabular-Supersession** — `SUP/02`-Vokabular (3-Säulen/F1–F29/11-Achsen/IExecutingEngine) ist historisch; IST = Achsen/Organ-Modell `CE/34 §1-§9`. Nie vermischen (`CE/34:202-204`).
2. **„Gattung" mehrdeutig** — die Docs `CE/27/28/29` tragen dutzende `[korr. 2026-06-03]`-Banner: „5 Gattungen" → **5 Lebewesen-Unterklassen** unter 2 Interfaces; „queuing = Container-Gattung" = **Kategorienfehler**, verworfen (queuing = SA-Achse) `CE/28:11-16`, `CE/27:3-8`.
3. **Slot-Zahl 17 vs 19** — Doku sagt teils `AdHocComposition<17>` (nur die composition_factory-Slots T0–T16), Code-Ziel/IST = **19** (inkl. q1/q2); `CE/34` nutzt durchgängig 19, ältere Docs 17.
4. **Ein echter Architektur-Defekt** — Befund 2 / Q2-Schritt-4: `search_organ_` beschattet node/layout → Austauschbarkeits-Belege blockieren darauf (`CE/34:156-164`, `CE/34:178-180`). Dokumentiert als E-Welle-A2-Herzstück.
5. **Doc-36-Defekt behoben** — die „zwei Parallel-Bäume" (`search_engine<>` vs Anatomie) waren I1-Verletzung, **2026-06-25 vereinheitlicht** auf EINE Hierarchie (`CE/36:170-178`).

---

**Zitierfähige Kernzahlen** (für das Dossier): 3 Gattungen · 5 Lebewesen-Unterklassen (19/15/11/13/7) · 19 SA-Achsen + 3 Build = „22" · 4 Brücken · Gate-1 = 137.594.142.720.000 Binaries · POD `axis_stats[19][8]+seg_ns[19]` ABI-Major 3 · 14 Lastprofile → 21 XML · 320 Lebewesen (Bias-Matrix) · 3 Mess-Dimensionen / 2 Pfade / 3 Profile.

Alle Belege sind read-only erhoben; keine Datei wurde verändert.