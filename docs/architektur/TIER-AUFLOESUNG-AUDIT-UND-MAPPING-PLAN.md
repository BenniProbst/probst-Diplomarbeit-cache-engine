# Groß-Audit: „Tier"-Auflösung — Begriffstrennung, Architektur-Landkarte, Identifier-Mapping-Plan

> **Status:** AUTORITATIVE GRUNDLAGE für die codebasis-weite Auflösung des doppeldeutigen Wortes
> „Tier". Erstellt 2026-06-15 aus einem 4-Strang-Groß-Audit (Konzeption / Achsen / Anatomie /
> prt-art) + Lektüre von Aufgabenstellung & Einleitung + sechs User-Festlegungen.
> **Beide Workstreams** (Text-Agent = Doku/Kommentare; Implementierungs-Agent = Code-Identifier)
> richten sich danach.
>
> **Quellen:** `docs/architektur/14_*` · cache-engine `docs/architecture/34_*`/`30_*` ·
> `anatomy/anatomy_base.hpp` · `anatomy/idriveable_tier.hpp` (Direktive „Anatomy-ABI ⊥
> Observer-Tier-Schnittstelle") · `anatomy/observable_tier.hpp` ·
> `builder/experiment_tree/genus_binding_traits.hpp` · prt-art `memory_layout/multi_level_layout.hpp`
> · `thesis/.../aufgabenstellung/{de,en}.tex` · `thesis/.../kapitel/{de,en}/01_introduction.tex`
> · konz. Doku `thesis/.../2026-06-15-konzeptionelle-...md`.

---

## 0. Das Problem in einem Satz

Das Wort **„Tier"** trägt im Projekt **vier** verschiedene Bedeutungen, die sich im selben Token
überlagern (dt. „Tier"=animal vs. engl. „tier"=Stufe). Eine naive globale Ersetzung würde
Bedeutungen verwechseln und die Architektur beschädigen. Dieses Dokument trennt die vier
Bedeutungen, gibt je einen eindeutigen Zielbegriff und ordnet die **Verantwortlichkeiten**.

---

## 1. DIE OBERSTE EBENE: Bibliothek ≠ Lebewesen ≠ Subject ≠ Host (Verantwortlichkeiten)

Vor den vier „Tier"-Clustern steht eine **Verantwortlichkeits-Kette**, deren Vermischung der
gefährlichste Begriffsfehler ist (User-Festlegung 2026-06-15):

| Rolle | Was es ist | **Keine** … | Beispiele |
|---|---|---|---|
| **Bibliothek** (Ebene 0) | Achsen-Algorithmus-**Bibliothek**: Katalog von Achsen-Organen zur *Zusammensetzung* von Lebewesen unter den Lebewesen-Typen einer Gattung | **kein Lebewesen** | **cache-engine**, **PRT-ART** |
| **Permutations-Lebewesen** / Rekombination | ein **konkret zusammengesetztes** Lebewesen = ein Punkt im Entwurfsraum | keine Bibliothek, keine Achse | „ART als Permutation", eine PRT-ART-Rekombination |
| **②Subject** (ABI) | die Schnittstelle, über die ein Permutations-Lebewesen getrieben/beobachtet wird (Modul = Subject, Host = Observer) | kein Lebewesen, keine Bibliothek | `IObservableSubject` |
| **Host** | Prüf-Dock / CacheEngineBuilder: treibt die Subjects, **mappt und persistiert** die Ergebnisse | kein Lebewesen | Prüf-Dock, ExperimentDriver |

**Symmetrie (zentral):** cache-engine **und** PRT-ART sind **beide Bibliotheken**. PRT-ART erzeugt
zusätzliche Permutations-Lebewesen und treibt sie über die ②Subject-ABI — **genau wie die
cache-engine**. Keine von beiden ist selbst ein Lebewesen.

**Join (= 3. Kompositionaler Join, Stufe 3):** Am Schluss werden die zwei getrennten
Achsen-Algorithmus-Bibliotheken **vereint** und treiben **gemeinsame Rekombinationen** über die
②Subject-ABI. Die drei Join-Stufen (Memory `reference_3_kompositionale_joins_anatomie`):
Stufe 1 = nur cache-engine; Stufe 2 = Prüfling-ersetzt-mit-Fallback; Stufe 3 = voller Join.

**Verantwortlichkeits-Kette:** Bibliothek *(Organe bereitstellen + Lebewesen erzeugen + treiben)*
→ Permutations-Lebewesen über ②Subject *(Organe ausführen + Observer-Daten liefern)* → Host
*(messen nach Teilaufgabe 5 + Ergebnisse mappen + persistieren: Observer-Snapshot → CSV/JSON)*.

---

## 2. DIE VIER „Tier"-CLUSTER (der Kern der Umbenennung)

| # | Cluster | Was es ist | Zielbegriff | Geltungsbereich |
|---|---|---|---|---|
| **①** | **LEBEWESEN / Anatomie** | *was* ein Algorithmus IST: das Lebewesen + seine Achsen/Organe (fachlich) | **„Lebewesen"** (Doku) · Code technisch | Metapher in Doku/Kommentar/Kap. 4 |
| **②** | **SUBJECT / Mess-Schicht** | *wie* gemessen/angetrieben wird: die ABI-Schnittstelle (methodisch, **⊥ Anatomie**) | **„Subject"** (`*Subject`, `subject_*`) | Code-Identifier + Doku |
| **③** | **BAND / Cache-Ebene** | Speicher-/Cache-Hierarchie L1/L2/L3 (Organ-Bestandteil der memory_layout-Achse) | **„Band" / „Cache-Ebene"** (`*Band`, `band_*`) | Code-Identifier + Doku |
| **④** | **RANG / SOTA-Reifegrad** | Tier-1/2/3 (Reifegrad der Stand-der-Technik-Verfahren) | **„Rang" (DE) / „Rank" (EN)** | Doku (Manuskript erledigt) |

**Die zentrale Achse der Trennung (User-Direktive, code-belegt `idriveable_tier.hpp:6`):**
> **„Anatomy-ABI ⊥ Observer-Tier-Schnittstelle"** — ①Anatomie und ②Subject sind **orthogonal**.
`IObservableTier` hängt NICHT an `IAnatomyBase` (`observable_tier.hpp:22`), sondern wird per
`dynamic_cast` separat abgefragt. Pro Lebewesen-Unterklasse existiert beides nebeneinander —
`SetAnatomy` (①Achsen) vs. `ISetTier`→`ISetSubject` (②ABI), verbunden nur über `SetAbiAdapter`.

> ⚠️ **Warum NICHT „Probe":** „probe" ist im Manuskript bereits **Prüfling** (s. §3). Daher ②=Subject
> (Observer-Pattern: Modul=Subject, Host=Observer), nicht „Probe".

---

## 3. ROLLEN & SYNONYME (aus Aufgabenstellung + Einleitung)

### 3.1 Prüfling (= „probe", EN) — präzise Natur
**Prüfling = PRT-ART**, ein **abstraktes Lebewesen**: es stellt nur **einige Organe selbst** bereit
(8 eigene Bausteinschichten: 4+2-Pool-Allokator, OLC mit reservierten Blöcken, MultiLevel-Layout,
pfadorientiertes Prefetch, DensityTracker, Hypothesen-Metriken H1/H2/H3, Inline/External/ChainRef-
ValueHandles, Signaling-Bit-Serialisierung) und bezieht die **meisten Organe aus dem
cache-engine-Katalog je Achse** — über **Compile-Time-Fallback zwischen Prüfling-Stack und
Stand-der-Technik-Stack** (`std::variant`-Bausteine; Prüfling-Slot-Pattern `pruefling_merge.hpp`;
Join Stufe 2). Gegenspieler: **Baseline / Stand der Technik (SOTA)** = die cache-engine-Lebewesen.
Fairness: **Common-Denominator** (Minimalmodus) vs. **PRT-ART-Native-Modus**.

> ⚠️ **Doppeldeutigkeit „Probe":** dt. „Probe" (Stichprobe / Mess-Exemplar) ≠ engl. „probe"
> (= Prüfling/PRT-ART). Ein gemessenes ganzes Lebewesen heißt **„Permutations-Lebewesen" /
> „Rekombination"**, **nie** „Probe" (User-Festlegung). „probe" (EN) bleibt allein dem Prüfling.

### 3.2 Eine Achse hat drei Kontext-Namen
| Kontext | Begriff | Regel |
|---|---|---|
| **Aufgabenstellung** | **„Entwurfsbestandteil" / „Entwurfsdimension" / „Stelle"** (EN: design component/place) | bewusst **metaphern- & achsenfrei** (linearer Aufbau, Lösung nicht vorwegnehmen) |
| **Einleitung / Konzept** | **„Achse" / „Dimension"** (EN: axis/dimension) | technischer Konzept-Begriff |
| **Metapher (Kap. 4 / Kommentare)** | **„Organ"** | nur dort erlaubt |

Weitere Manuskript-Begriffe (Kontext, NICHT „Tier"): **Entwurfsraum / design space** (Idreos) =
Permutationsraum; **Punkt im Entwurfsraum** = ein Permutations-Lebewesen; **3-Schicht-Architektur**
CacheEngine→ExecutionEngine→SearchEngine; **variadische Hybrid-API** (1→vector / 2→map / N→map<K,tuple>);
**3 Mess-Granularitäten** Micro (Achse isoliert über Kategorie-Interface) / Makro (Interface-Ops:
insert/lookup/delete) / Gesamt (ganze Algorithmen, YCSB); **3 Pflicht-Messreihen** A (Prüfling vs
SOTA) / B (systematische Variation) / C (Merge/Regression); **Mess-Pipeline** Binary→CSV→LaTeX→Diagramm.

---

## 4. ARCHITEKTUR-LANDKARTE (aus dem 4-Strang-Audit, code-verifiziert)

### 4.1 Die vier Konzept-Ebenen (innerhalb einer Bibliothek; „3-Ebenen-Modell" = 4 verschachtelte Ebenen)
| Ebene | Begriff | Code-Anker | Anzahl |
|---|---|---|---|
| 1 | **Gattung** = Außen-Interface / Prüf-Dock | `enum AnatomyGattung` | **3**: SearchAlgorithm · Container · Graph |
| 2 | **Lebewesen-Unterklasse** (hist. „Tier-Unterklasse") = fester Achsen-Satz | `enum AnatomyGenus` | **5**: SearchAlgorithm · Set · Sequence · Adapter · View |
| 3 | **Achse = Organ** = permutierbare Teilentscheidung (keine optional) | `topics/`→`axes/` | **19** (SearchAlgorithm) |
| 4 | **Sub-Achse = Organ-Bestandteil** = orthogonale Dimension im Organ | `*_subaxes_*.hpp` | **~57–279** |

`gattung_of()`: SearchAlgorithm → eigene Gattung; Set/Sequence/Adapter/View → alle Container.
Achsen-Sätze (`genus_binding_traits.hpp`): SearchAlgorithm **19**, Set **15**, Sequence **11**,
Adapter **13**, View **7**. Cross-Genus-Permutation ist type-mathematisch unmöglich → **5 getrennte
Anatomien/Compositions/Observer/PermutationEngines**; **nur die SearchAlgorithm-Unterklasse ist voll
gebaut** (BR-1..4), die übrigen 4 existieren als `GenusBindingTraits`. Metapher:
Säugetier=SearchAlgorithm · Vogel=Set · Reptil=Sequence · Wirbelloses=Adapter · Pflanze=View;
„Viren" (Graph/FFT/Crypto) = außerhalb der Anatomie (`IVirusExecutionEngine`).

### 4.2 Was eine ANDERE Gattung ausmacht (konz. Doku §4 — der „letzte Kommentar")
> **Gleiche Gattung, anderer Typ** ⇔ gleicher Achsen-Satz, anderes erlaubtes **Subset**.
> **Andere Gattung** ⇔ **grundlegend anderer Basis-Achsen-Satz** — Achsen, die für die Typen der
> ersten Gattung schlicht keinen Sinn ergäben.

**Lehrbeispiel Hash-Map:** **keine** eigene Gattung — eine `search_algo`-Achsen-Ausprägung
(`HashSearchAlgo`, S14) mit **limitiertem Subset** derselben 19 Achsen (path_compression=None,
mapping=Direct, filter=None, node_type flach, range_scan=false; geteilt: allocator/prefetch/
concurrency/memory_layout/isa/telemetry). Eine eigene Gattung zu erheben wäre der queuing-
**Kategorienfehler**. (Hash-**SET** dagegen = Set-Lebewesen-Unterklasse.)

### 4.3 topics ≠ axes + „17 Topics" ≠ „19 Achsen"
- **Doppel-Verzeichnisbaum (bewusste Migration V41.F.2):** `topics/<name>/axis_NN_*/` = dünne
  **Forwarding-Stubs** → delegieren an `axes/<kurzname>/` = **echte Implementierung**. Single-Source
  der 17-Achsen-Liste: `axes/axis_centric_namespaces.hpp`. **Konsequenz:** Sub-Achsen-Header existieren
  teils in BEIDEN Bäumen — beide nachziehen.
- **17 Topic-Verzeichnisse, aber 19 Achsen:** `traversal` bündelt 3 (search_algo/cache_traversal/
  mapping), `nodes` 3 (page_type/path_compression/node_type), `hardware` 3 (isa/simd_ext/general_hw),
  `queuing` 2 (q1/q2). Autoritative Zahl **19** = `observable_tier.hpp::kV3AxisCount` (T0..T18 =
  `seg_ns[19]`-Timer). (+3 „Build-Achsen" page_type/simd_ext/general_hw als Codegen-Varianten →
  historische „22".)
- **Sub-Achsen-Bestand** (code-gezählt): 74 Tag-Structs + 54 Strategy-Concepts + 151 Wrapper =
  **~279 Organ-Bestandteile** (Goldstandard `axis_06_allocator`: 7 Tags + 6 Concepts + 25 Wrapper).
  Manuskript-Zahl **„~57"** = Tag-Näherung (beibehalten; je nach Zählkonvention Tags / +Concepts /
  +Wrapper / +composable schwankend).

### 4.4 Getrennte Architektur: Aufbau-Seite ⊥ Mess-Seite (die Schichtung)
Die Schichtung trennt **wie ein Lebewesen aufgebaut ist** (Aufbau-Seite, ①, fachlich, permutierbar)
von **wie es gemessen/getrieben wird** (Mess-Seite, ②, methodisch, ABI-stabil). Code-Direktive
(`idriveable_tier.hpp:6`): **„Anatomy-ABI ⊥ Observer-Tier-Schnittstelle"** — diese Orthogonalität ist
die eigentliche Grundlage des Frameworks.

**Aufbau-Seite (①):**
1. **Bibliothek** (cache-engine/PRT-ART) — stellt **je Achse einen Katalog** von Organ-Varianten bereit
   (z. B. allocator: 25 Vendor-Wrapper; node_type: Node4/16/48/256; concurrency: 9 Wrapper).
2. **`XxxComposition`** (`*_composition.hpp`) — compile-time **Typ-Liste** der gewählten
   Achsen-Ausprägungen (T0..Tn); trägt die **Identität** (welche Organe), keine Logik. Kein „Tier".
3. **`XxxAnatomy<Composition>`** (`*_anatomy.hpp`) — das **konkrete Lebewesen in-process**: hält die
   Organe, treibt sie funktional, liefert `observe_all()`/`genus()`/`organ_count()`. Technischer Name.
4. **Achse = Organ** (19) · **Sub-Achse = Organ-Bestandteil** (~279). Eine nicht zutreffende Achse wird
   **nie weggelassen**, sondern mit einem konkreten Durchreich-Organ (`None`/…) belegt. Ein konkretes
   Lebewesen = eine **Permutation/Rekombination** der Organe = ein Punkt im Entwurfsraum.

**Mess-Seite (②, ⊥ Aufbau):**
5. **`IXxxTier`→`IXxxSubject`** (`*_tier.hpp`) — ABI-Schnittstelle über die DLL-Grenze; **hängt NICHT
   an `IAnatomyBase`** (eigenständige Sub-Interfaces, vom genus-typisierten Adapter *zusätzlich* geerbt,
   vom Host per `dynamic_cast` [1× kalt je Modul, nie im Hot-Loop] abgefragt).
6. **`XxxAbiAdapter`** (`abi_adapter.hpp`, `*_abi_adapter.hpp`) — die **Brücke**: erbt `IAnatomyBase`
   (Aufbau) **und** `IXxxSubject` (Messung), hält eine `XxxAnatomy` und **leitet die ABI-Aufrufe an sie
   weiter**. **Einzige Stelle, die beide Seiten verbindet** (106 „Tier"-Treffer — größter Block).
7. **Host** (Prüf-Dock/CacheEngineBuilder) — treibt + misst (Teilaufgabe 5) + **mappt + persistiert**.

**Orthogonalität in Funktion:** `IDriveableSubject` (funktionaler Antrieb: insert/lookup/erase/clear/
size, uint64-Key/Value) ist **IMMER einkompiliert** (auch Release-/funktional-only-DLL ohne Messung) —
darüber fährt der Host generisch das **`std::map`-Konformitäts-Gate UND die Last**. `IObservableSubject`
(Observer→Snapshot) wird **NUR bei Messung-AN** (`COMDARE_MEASUREMENT_ON`) vererbt/exportiert; ebenso
`IRollbackableSubject` (Memento) etc. → Die Messung lässt sich **an-/abschalten, ohne den Aufbau zu
ändern**: die Anatomie ist mess-agnostisch, die Messung ein orthogonales, optionales Sub-Interface. Der
Observer-Snapshot (`ComdareTierObserverSnapshot`, `axis_stats[19][8]`+`seg_ns[19]`+Meta) quert die
Grenze als **flacher, komposition-UNABHÄNGIGER POD** (memcpy-fähig) → derselbe Mess-Apparat greift auf
jede Permutation.

> **Folge für die Begriffe:** ① (Aufbau/Lebewesen) und ② (Mess-Schicht/Subject) MÜSSEN getrennte
> Begriffe behalten — sie sind zwei orthogonale Seiten desselben Adapters, nicht dasselbe.

### 4.5 prt-art: 8 Bausteinschichten + die ③-Einordnung von `CacheTier`
8 Schichten (`PROJECT_LAYER_MAP.md`, code-verifiziert gegen `PrtArtComponents`): **L1 Identität**
(`PrtArtSearchEngine`, variadische API, Fingerprint) · **L2 Measurement/Telemetry** (DensityTracker,
Hypothesen-Metriken H1/H2/H3, LeafOnlyCounter) · **L3 Prefetch** (pfadorientiert, DistanceEstimator) ·
**L4 Node-Typen** (BPlusNode dense, RedirectNode sparse/CoCo-inspiriert) · **L5 Internal-Search**
(dichteabhängig) · **L6 Concurrency** (OLC + reservierte Blöcke) · **L7 Memory** (4+2-Pool-Allokator,
**memory_layout**, Inline/External/ChainRef-ValueHandles) · **L8 Serialisierung** (Signaling-Bits,
LinearValueBuffer).

**`CacheTier` ist NICHT eigenständige Cache-Hierarchie**, sondern ein **Organ-Bestandteil (Sub-Achse)
der memory_layout-Achse (Achse 5)**: `tier_for_key()` bildet ein Schlüssel-Präfix per
`VirtualOffsetAddress` (TLB-Emulation, Horner) → virtuelle Position → Hot/Warm/Cold/Memory-**Band**;
Werte L1Hot/L2Warm/L3Cold/Memory; `TierBudget` = Byte-Grenzen. Code-aktiv (Member in `PrtArtComponents`,
voll getestet). → Cluster ③ **Band**. (⚠️ Repo-Namens-Kollision: „L1…L8" = Architektur-Schichten ≠
„L1Hot…" = Cache-Bänder.)

---

## 5. IDENTIFIER-MAPPING-PLAN (alt → neu) — für den Implementierungs-Agenten

> **Grundregel:** NIE global ersetzen. Jede „Tier"-Stelle erst einem Cluster (①–④) bzw. einer
> Rolle (Bibliothek/Lebewesen/Subject/Host) zuordnen, dann den Zielbegriff anwenden. Deutsche
> Substrings (sor**tier**t, exis**tier**t, permu**tier**en, „Säuge**tier**", …) sind **keine** Treffer.

### 5.1 ① LEBEWESEN / Anatomie
- **Doku/Kommentare:** „Tier"(animal)→**„Lebewesen"**; „Tier-Unterklasse"→„Lebewesen-Unterklasse";
  „ein Tier"→„ein Lebewesen". Bio-Beinamen (Säugetier/Vogel/Reptil/Wirbelloses/Pflanze) **bleiben**.
- **Code:** Anatomie-Identifier bleiben technisch (`SearchAlgorithmAnatomy`, `IAnatomyBase`,
  `kingdom_name()="Animalia"`). `enum AnatomyGenus` neutral → **bleibt**; ⚠️ #90-Refactor
  `AnatomyGenus→AnatomyTierSubclass` **umlenken** auf `AnatomyOrganismSubclass` (o. belassen).
  Parameter `tier_subclass` → `organism_subclass` (gehört zu ①, NICHT ②!).

### 5.2 ② SUBJECT / Mess-Schicht (`anatomy/` + `builder/`) — Haupt-Block (~200+ Treffer)
**ABI-Interfaces** (`*_tier.hpp`→`*_subject.hpp`): `IDriveableTier`→`IDriveableSubject` ·
`IObservableTier`→`IObservableSubject` · `IRollbackableTier`→`IRollbackableSubject` ·
`IScannableTier`→`IScannableSubject` · `IResourceControllableTier`→`IResourceControllableSubject` ·
`ISetTier`→`ISetSubject` · `ISequenceTier`→`ISequenceSubject` · `IAdapterTier`→`IAdapterSubject` ·
`IViewTier`→`IViewSubject`.
**ABI-Methoden** (`tier_*`→`subject_*`): `tier_insert/lookup/erase/clear/size` · `tier_observe` ·
`tier_save_all`/`tier_rollback_all` · `tier_scan` · `tier_query_resource_caps`/`…apply…` ·
`tier_set_*`/`tier_observe_set` · `tier_push_back`/`tier_at`/`tier_observe_sequence` ·
`tier_put`/`tier_get`/`tier_observe_container` · `tier_bind`/`tier_read`/`tier_observe_view` ·
Helfer `tier_search_routes_through_store`, `tier_rollback_is_exact`, `tier_memento_is_copy_on_write`.
**POD/Konstanten/Felder:** `ComdareTierObserverSnapshot`→`ComdareSubjectObserverSnapshot` ·
`kTierObserverSnapshotVersionUnified`→`kSubjectObserverSnapshotVersionUnified` ·
`tier_fill_level`→`subject_fill_level`.
**Dateien:** die 9 `*_tier.hpp` → `*_subject.hpp`; `builder/anatomy_commands/tier_observe_trace*.hpp`
→ `subject_observe_trace*` (+ `#include`-Pfade).

### 5.3 ③ BAND / Cache-Ebene
prt-art `multi_level_layout.hpp`: `CacheTier`→`MemoryBand` (Werte L1Hot/… dürfen bleiben) ·
`TierBudget`→`MemoryBandBudget` · `tier_for_offset/_key`→`band_for_*` · Tests nachziehen.
cache-engine: `TierBasedMigration`/`kTiers`/`tier_index_sum`/`tier_moves` (migration) +
`tier_latency_cycles` (prefetch) → `band_*` / `cache_level_*` (NICHT Lebewesen/Subject!).

### 5.4 ④ RANG / SOTA
„Tier-1/2/3"→„Rang/Rank". Manuskript ✓. Offen: `docs/`-Bestand (`bausteine/03_*`,
`forschungslandkarte/*`, `EMAIL_KONTAKTE.md`, viele `sessions/`/`termine/`). **`TIER3`(ZIH) NICHT anfassen.**

---

## 6. FALLSTRICKE

1. **Drei Cluster, gleicher Präfix `tier_`:** `tier_subclass`(①→`organism_subclass`) vs
   `tier_insert`(②→`subject_insert`) vs `tier_moves`(③→`band_moves`). NUR nach Bedeutung ersetzen.
2. **`Tier-1/2/3` = ④ Rang; jede andere `Tier`-Komposition = ①/②/③.**
3. **`Säugetier` enthält `tier`** → Wortgrenzen; Bio-Beinamen schützen.
4. **dt. „Probe"(Stichprobe) ≠ engl. „probe"(Prüfling).** Gemessenes ganzes Lebewesen =
   „Permutations-Lebewesen/Rekombination", nie „Probe". „probe"(EN) nur = Prüfling.
5. **Bibliothek ≠ Lebewesen:** cache-engine/PRT-ART sind **Bibliotheken**, keine Lebewesen.
   Formulierungen wie „das Lebewesen cache-engine" sind falsch — es *erzeugt* Lebewesen.
   **Aufbau ≠ Messung:** Anatomie (①) und Subject-ABI (②) sind orthogonal (s. §4.4).
6. **ABI-Konsequenz (②):** `tier_*` = vtable über DLL-Grenze, `ComdareTierObserverSnapshot` =
   cross-boundary-POD → Umbenennung **ABI-brechend**: Host (`anatomy_module_abi_v1_decl.hpp`,
   Loader) + alle Prüflings-DLLs synchron + **ABI-Major-Bump 3→4**.
7. **#90-Refactor umlenken** (siehe 5.1).
8. **Doppel-Verzeichnisbaum** topics/+axes/ — Sub-Achsen-Header in beiden nachziehen.

---

## 7. UMSTELLUNGS-REIHENFOLGE

**Doku (Text-Agent):** (1) ④ Rang in `docs/` (eindeutig). (2) ① Lebewesen in `docs/architektur/14_*`
+ übrige `docs/` + cache-engine-`docs/`. (3) Oberste Ebene (Bibliothek/Lebewesen/Subject/Host) +
② Subject / ③ Band in Doku + Kommentaren. (4) konz. Doku + Übergaben selbst nachziehen.
Aufgabenstellung bleibt metaphern-/achsenfrei (nur „Entwurfsbestandteil").
**Code (Implementierungs-Agent):** ② Subject (ABI-Major-Bump, Host+DLLs synchron) → ③ Band →
① `tier_subclass`/#90-Notiz. Identifier-Direktive (Doku 14 §41): Code-Namen technisch (`*Subject`/
`*Anatomy`/`*Band`), Metapher nur im Kommentar.

---

## Anhang: Sechs User-Festlegungen (2026-06-15)
1. Beide Bedeutungen auflösen (Metapher **und** Level), „Tier" als Wort vermeiden.
2. ① Metapher-Oberbegriff → **„Lebewesen"**; Bio-Beinamen bleiben.
3. ① und ② orthogonal → **getrennte Begriffe**.
4. ② Mess-Schicht → **„Subject"** (NICHT „Probe" = Prüfling; NICHT „Tier").
5. **Bibliothek ≠ Lebewesen:** cache-engine + PRT-ART sind Bibliotheken, die Permutations-Lebewesen
   erzeugen + über ②Subject treiben; Join (Stufe 3) → gemeinsame Rekombinationen; Host misst/mappt/
   persistiert (Teilaufgabe 5).
6. Gemessenes ganzes Lebewesen = **„Permutations-Lebewesen/Rekombination"** (nie „Probe"); Prüfling =
   abstraktes Lebewesen (einige eigene Organe + Rest aus cache-engine-Katalog je Achse).

---

## 9. Arbeits-Checkliste: betroffene Dateien (MANUELLE Umstellung, Dokument für Dokument)

> **Vorgehen (User-Direktive 2026-06-15):** JEDE Datei wird **manuell im Gesamtkontext gelesen** und
> präzise umformuliert — **kein Wort-Ersetzen** (Code-Spans, Satzbau, Bedeutung je Stelle prüfen;
> ein Agent-Versuch wurde verworfen). Pro Datei ALLE Cluster (①Lebewesen / ④Rang / ②Subject /
> ③Band) zusammen abarbeiten. Status: `[ ]` offen · `[x]` erledigt. **Diese Datei selbst bleibt
> unangetastet** (sie *beschreibt* die Umstellung). `TIER3` (ZIH-HPC, Großschreibung) nie ändern;
> Bio-Beinamen (Säugetier/Vogel/…) bleiben.

**STAND 2026-06-15 (laufend):** ✅ erledigt+committet: **A1** (7) · **A2** (10) · **Doc 14** (67/72) ·
**A3 Sessions KOMPLETT** (alle ~22 Session-Dateien: 12 ④Rang + anatomie-① + ③/④-Reste + Glob-Pattern + .txt).
**A4 KOMPLETT** (Commits `ddb1ccd`→`43b3221`): `Phase5_UML_Detail/11`+`12_*taxonomie` (③ Ebene; CamelCase-Code-Identifier
`MultiTierCacheStrategy`/`IMultiTierHeuristic`/`TierLatencies[]`/`DiskTierTraversalCommand`/… belassen) + HABICH-T7/T8
+ Termin-8-Trio (Arbeitsplan/-ergebnis/Praesentation; SOTA ④ Rang) + Allokator-Extraktionen A05/A14/A19/extract_termin5_6/Allokator_Matrix.txt
(Size-Class-Tiers→**Stufen**, Cache-Latenz-Tiers→**Ebene**, SOTA-Tier-1/3→**Rang**) — bis `f0537fe` · UML-Skizzen 10/13/20/22/24
(`20e4e52`) · _extractions cluster_D/F + taxonomien/state_visitor/cache_engine_families (`23c6462`) · **alle `.drawio` REV3/3-NACHARB/5/6/7**
(`43b3221`; ③ Cache/Memory/Multi-Tier→Ebene, ④ alle-Tier-3→Rang). **02_uml / REV4 / extract_rev4_delta = nur Code-Identifier, unverändert.**
**➡ GESAMTER Haupt-Repo `docs/` KOMPLETT** (A1+A2+A3+A4+Doc 14); verbleibende `Tier` überall = bewusst belassene Code-Identifier/Zitate/Regexe.

> ⚠️ **FALSE-POSITIVE-WARNUNG (Grep):** lowercase `tier` matcht als Teilstring in deutschen Wörtern — `Implemen`**`tier`**`ungs`,
> `sor`**`tier`**`t`, `garan`**`tier`**`t`, `Hierarchie`, `Kalibrierung`, `Kategorie`… — das ist **NIE** das gemeinte Wort! Echt sind NUR:
> **Groß-`Tier`** (dt. Substantiv ① / SOTA `Tier-N` ④ / Komposita `Cache-Tier` ③) + engl. kleingeschriebenes `cache tiers`/`multi-tier`.
> Grep-Pattern: `\bTier` für Treffer, NICHT `tier`. Belassen: all-caps Code-IDs (`ALLOC_SIZECLASS_TIERED`), CamelCase (`MultiTier…`), snake `tier_*`.
**Bewusst belassen** (überall gleich): Tierwelt-Zitate (verbatim), Audit-Regexe, Code-Identifier
(`TierBasedMigration`, `tier_observe_trace_abi`, `EachPermutationIsDistinctTier`, `AllSixTiere…`,
`tier_fill_level`), Code-Pfade (`thesis_tiere/`), Metapher-Code-Listen. Commits bis `8c4d2bf` + finale.
**OFFEN:** **B** cache-engine-`docs/` (648!) — ⚠️ **Submodul-Koordination nötig** (Direktive „cache-engine = paralleler
Implementierungs-Agent, never touch"; working-tree gerade fast clean [nur 2 generierte `thesis_tiere/`-CSVs], HEAD `0556e3a`) ·
~~**D** Manuskript~~ ✅ **ERLEDIGT** (`5d11dce`, gemergt+gepusht `146eb2b`): Metapher-Kern Kap.4 DE „Lebewesen (ein Tier)"→„Lebewesen" /
EN „organism (an animal)"→„organism"; Tier-Permutationen→Lebewesen-/organism-Permutationen (Anhang+`.ps1`+8 Tabellen DE+EN, .ps1↔.tex konsistent);
Tier-Unterklassen→Lebewesen-Unterklassen; `literatur.bib` Tier-1→Rank-1; Aufgabenstellung-Kommentar DE+EN. Lebendes Manuskript Tier-frei (nur lowercase-dt.-Wort-FPs);
④-Kapitel-Rang war bereits `007995a`. Reine Text/Caption-Edits → Build syntaktisch sicher. <!-- war klassifiziert: ① „Tier-Permutationen"
(Anhang `A_measurements.tex` + `generate_measurement_appendix.ps1` + Tabellen-`.tex` + EN) / „Tier-Unterklassen" (`docs/quellhinweise`) /
Kap.4-Metapher / „Tier/Organ-Metapher" → **Lebewesen**; ④ „Tier-1 SOTA" → **Rang/Rank** --> ·
~~**E** `_archiv_entwurf1`~~ ✅ `3576621` (SOTA Tier-1/2-3→Rang). ~~A4-Rest~~ ✅ `43b3221` · ~~**C** prt-art~~ ✅ `3c971f4`/`2bb6cd6` · ~~**D** Manuskript~~ ✅ `5d11dce`/`146eb2b`.

> ✅ **STAND 2026-06-15:** A (Haupt-Repo `docs/` komplett) + C (prt-art) + D (Manuskript DE+EN) + E (_archiv) **ERLEDIGT, committet, gepusht.**
> **➡ EINZIG VERBLEIBEND: B = cache-engine-`docs/`** (677 Vork./60 Dateien) — erfordert Anfassen des cache-engine-Submoduls; Direktive
> „cache-engine = paralleler Implementierungs-Agent, **never touch**". Working-tree gerade fast clean (HEAD `0556e3a`, nur 2 generierte
> `thesis_tiere/`-CSVs). **User-Entscheid 2026-06-15: „jetzt bearbeiten"** (Risiko akzeptiert) → **B IN ARBEIT** (Fortschritts-Log §10).
> **KERN-ERKENNTNIS (Doc 24 vollständig analysiert = Muster):** „Tier" ist in der cache-engine-Doku **überwiegend ① LEBEWESEN**
> (= ganzer/composite Suchalgorithmus). **BELASSEN:** verbatim `> „…"`-User-Zitate (mit „Tier") + Code-Identifier
> (`IObservableTier`/`tier_observe*`/`ComdareTierObserverSnapshot`/`tier_to_organ_mapping`/`CacheTier`/`MultiTier*`/`TierKind`). Sonst analog: ③ Cache/Memory/Multi-Tier-Prosa→Ebene,
> ④ SOTA-Tier-N→Rang, ① Lebewesen, Code-Identifier belassen. Methodik: je Datei vollständig lesen → Prosa vs `> „…"`-Zitat vs Code trennen.
<!-- HISTORIE A4-Rest (erledigt): `Phase5_UML_Detail/`: 02_uml 2 · 10_korrektur 5 · 13_saeule_b 4 · 20_REV3 3 · 22_REV5 7 ·
24_REV7 8 + **`.drawio` REV3-7** [REV5/6/7 je 25!] + `_paper_extractions` cluster_D 19/cluster_F 2 + `_rev5_extractions`
cache_engine_families 19/state_visitor 15/taxonomien 7/rev4_delta 6/termin5_6 2 + `_paper_extractions_allocators` A05/A14/A19
+ `Allokator_Matrix.txt` 1) · **B** cache-engine-`docs/` (648!) · **C** prt-art-`docs/` · **D** Manuskript-Metapher
(DE+EN) · **E** konz. Doku/Übergaben (`2026-06-15-*`). -->

> ⚠️ **SCOPE-KORREKTUR 2026-06-15 (User-Einwand):** Der erste Grep war `*.md` → **`.drawio`-Diagramme**
> (`Phase5_UML_Detail/phase5_uml_detail_REV5/REV6/REV7.drawio` je **25** Vork., REV3/4 je 4-6) und **`.txt`**
> (`Allokator_Matrix.txt`) wurden ÜBERSEHEN. Der **größte Block ist B = cache-engine-`docs/` mit 648
> Vorkommen über 50+ Dateien** (Doc 24=104, Doc 30/27=41/39, abhaengigkeitskette/messarchitektur_v5 je ~33-39,
> Doc 34=31 …). Vollständiger Scope + ALLE Pflicht-Referenzen: **`thesis/diplomarbeit/sessions/2026-06-15-tier-umstellung-fortschritt-und-vollstaendiger-rest-uebergabe.md`**.

### A. Haupt-Repo `docs/` (356 Vorkommen / 60 Dateien; Stand-Grep 2026-06-15)

**A1 — Konzeptionell (Priorität; ① Metapher / gemischt):**
- [ ] `architektur/14_achsen_komposition_organ_metapher.md` (72) — ① Metapher-Hauptquelle
- [ ] `anleitung_messwerte_erzeugen.md` (10) — ① Metapher
- [ ] `architektur/12_queuing_topic_achsen_eigenschaften.md` (6)
- [ ] `architektur/09_taxonomien.md` (1) · `11_konzept_achsen_extension_visitor_pattern.md` (1) · `04_konzepte_saeule_b.md` (1)
- [ ] `glossar/01_begriffsglossar_v7_master.md` (1) · `INDEX.md` (1)

**A2 — ④ Rang (SOTA-/Allokator-Reifegrad):**
- [ ] `EMAIL_KONTAKTE.md` (3) · `architektur/01_REV_Historie.md` (2)
- [ ] `forschungslandkarte/00_INDEX.md` (1) · `01_quellen_gesamtkatalog.md` (3) · `05_cluster_D_prefetching_1.md` (3) · `07_cluster_F_sync_tud_habich.md` (2) · `08_allokator_cluster_AC1_AC5.md` (1)
- [ ] `bausteine/03_cross_paper_konzeptmatrix.md` (6) · `02_allokator_matrix.md` (1)
- [ ] `termine_konsolidiert/06_termin_6.md` (1)

**A3 — Sessions (historisch, gemischt ④/①):**
- [ ] `sessions/20260514-*` (v8 1100=4, v9 1130=3, v9 1230=3, v13 1830=1, v14 2000=1, v15 2100=1, v16 2130=1, v16 2200=3, v17 2230=2, v17 2300=3, V19-V22 2900=1)
- [ ] `sessions/20260515-4700-…bilanz.md` (1) · `sessions/20260524-V41-open-todos.md` (1) · `sessions/20260525-…prt-art-header-audit.md` (1)
- [ ] `sessions/20260526-…` (① anatomie: P2-D-q=5, R3-skelett=7, R3-R5CA=11, R5A=3) · `sessions/CROSS_REFS_KONSOLIDIERT.md`

**A4 — Termine (historisch, gemischt):**
- [x] `termine/20260515 Termin 8/` (Arbeitsplan · Praesentation · Arbeitsergebnis) ✅ ④ Rang (`00bdca0`)
- [x] `termine/20260508 Termin 7/` (HABICH_TERMIN8_VORB · TERMIN7_ZUS) ✅ ④ Rang (`00bdca0`)
- [x] `termine/20260508 Termin 7/Phase5_UML_Detail/` **KOMPLETT**: 11_cache_strategy + 12_algorithmus (③ Ebene; `ddb1ccd`/`1d611d8`) · 10_korrektur/13_saeule_b/20_REV3/22_REV5/24_REV7 (③ Ebene + ④ Rang; `20e4e52`) · _paper_extractions cluster_D/F + _rev5_extractions taxonomien/state_visitor/cache_engine_families (`23c6462`) · **`.drawio` REV3/REV3_NACHARB/REV5/REV6/REV7** (`43b3221`) — **02_uml, REV4, extract_rev4_delta = nur Code-Identifier (TierKind/TierPair/MultiTier*…), unverändert**
- [x] `Allokator_Matrix.txt` (③ Stufe) · `_paper_extractions_allocators/` A05 + A14 + A19 (③ Stufe/Ebene + ④ Rang) · `_rev5_extractions/extract_termin5_6` (④ Rang) — `f0537fe`
- [ ] **OFFEN** `_paper_extractions/` cluster_D 19 · cluster_F 2 (③ Memory-Ebene + Cluster F = Sync/RCU, viele lowercase-FALSE-POSITIVES — sorgfältig!) · `_rev5_extractions/` cache_engine_families 19 · state_visitor 15 · taxonomien 7 · rev4_delta 6

### B. cache-engine `docs/` (Submodul `comdare-cache-engine` — noch per Grep zu erfassen; eigener Commit, Koordination Implementierungsagent)
### C. prt-art `docs/` + READMEs (Submodul `comdare-prt-art` — noch zu erfassen)
### D. Manuskript `thesis/diplomarbeit/` (① Metapher noch offen; ④ Rang bereits erledigt) — eigenes LaTeX-Repo, bilingual DE+EN, danach `build.ps1` grün halten
### E. Konz. Doku + Übergaben selbst nachziehen: `sessions/2026-06-15-konzeptionelle-…`, `2026-06-15-tier-…-uebergabe.md` (nutzen „Tier-Unterklasse" → „Lebewesen-Unterklasse")

---

## §10 — B-Fortschritts-Log (cache-engine `docs/`, LIVE, Resume-fähig)

**Scope (Grep `\bTier`, Stand 2026-06-15):** **673 Treffer / 83 `.md`-Dateien.** Methodik je Datei: lesen → Prosa ① „Tier"→**Lebewesen** / ③ Cache-/Memory-/Multi-Tier→**Ebene** / ④ SOTA-Tier-N→**Rang**; **BELASSEN** `>`-verbatim-Zitate (mit „Tier") + Code-Identifier (`IObservableTier`/`tier_observe*`/`ComdareTierObserverSnapshot`/`CacheTier`/`MultiTier*`/`TierKind`/`TierBudget`/`tier_to_organ_mapping`) + Bio-Beinamen (Säugetier/Reptil/**Schnabeltier**). Commit nur `docs/` (CSVs/Code NIE). Verifikation je Datei: `\bTier`-Grep → nur noch `>`-Zeilen + Code-Identifier übrig.

**architecture/ (kanonisch, zuerst):**
- [x] `24` (ce `c115438` + `46b36f3`-Nachzug §8.8) · `26`/`27`/`28`/`29` (ce `46b36f3`) · `30` (ce `3c7ab5f`) · `33`/`34` (ce `c95ecd7`) · `abhaengigkeitskette` (ce `75ed122`) — alle ✅ gepusht (~317 Treffer).
- **METHODIK-VERFEINERUNG (wichtig für Resume):** „Tier-Unterklasse"/„Tier-Binary" sind **redaktionelle Terme** (der User sagte ursprünglich „Gattung"; die `[korr.]`-Notizen führten „Tier-Unterklasse" ein) → überall ① **Lebewesen**, **AUCH in rein redaktionellen `>`-KORREKTUR-Notizen**. **BELASSEN nur: (a) verbatim `> „…"`-User-Zitate** (markiert „User … verbatim-tragend" / echte Zitatsätze; z.B. Doc 30 Z.3-6, Doc 24 §2.1/§7-Direktive/§8.x), **(b) Code-Identifier** (`tier_insert`/`tier_lookup`/`tier_observe`/`IObservableTier`/`*Tier`-Typnamen wie `AdapterTier`, `tier_to_organ_mapping`), **(c) Bio-Beinamen** (Säugetier/Reptil/**Schnabeltier**), **(d) Code-Pfade** (`thesis_tiere/`). „Tier-X" wo `tier_x` ein echter Code-Identifier ist (insert/lookup/erase/clear/size/observe) = ② Subject-Code → BELASSEN; rein beschreibendes „Tier-X" (Binary/Wall-Clock/Modul/Unterklasse/Metapher/Quellen) → ① Lebewesen. **ACHTUNG Zeilenumbruch:** mehrwort-Terme können über `\n` getrennt sein → `replace_all` verfehlt sie; **immer `\bTier`-Grep zur Verifikation je Datei** (zeigt Resttreffer = nur Zitate/Code erlaubt).
- [ ] **architecture-Rest:** `31`(2) · `messarchitektur_v5_design`(20) `_klarstellungen…`(15) `_v5_entscheidungen`(14) `_design_observer…`(9) · klein: `15`(3)/`17`(1)/`18`(2)/`19`(3)/`20`(4)/`21`(4)/`22`(4)/`32`(2)/`messarchitektur_v5_drei_profile`(1)/`_i8…`(1)
- [ ] **sessions/ + email/ + quality_audit/** (~60 Dateien, 1–31 Treffer) — überwiegend ④ SOTA-Tier-N→Rang + Code-Identifier; ① Lebewesen-lastig: `A1-lesenotizen`(31)/`SESSION-HANDOFF-organ-metapher`(20)/`gattungs-kategorienfehler`(19)/`undolog-fertig-audits-pausiert`(17)/`GOAL-MESSUNG-AUDIT-APPENDIX`(17)/`87-container-tier-unterklasse`(16).

**sessions/ + email/ + quality_audit/ (danach):** ~60 Dateien, 1–31 Treffer. Überwiegend ④ SOTA-Tier-N→Rang + Code-Identifier; ① Lebewesen-lastig: `20260613-A1-lesenotizen`(31), `SESSION-HANDOFF-organ-metapher`(20), `20260603-gattungs-kategorienfehler…`(19), `20260603-queuing-migration-und-87-container-tier-unterklasse`(16), `20260611-…undolog-fertig-audits-pausiert`(17), `GOAL-MESSUNG-AUDIT-APPENDIX`(17).

**Pointer-Bump Haupt-Repo:** am Ende der B-Gesamtgruppe (cache-engine-Submodul-Pointer `0556e3a`→finaler B-HEAD).

**OFFENER PRÜFPUNKT A4 (Inkonsistenz):** Zeile 375 markiert `_paper_extractions/` (cluster_D/F) + `_rev5_extractions/` (cache_engine_families/state_visitor/taxonomien/rev4_delta) als OFFEN, Zeile 373 + HISTORIE als erledigt (`23c6462`). Nach B-Architektur-Block per Grep verifizieren + Häkchen konsolidieren.
