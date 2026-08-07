# Groß-Audit: „Tier"-Auflösung — Begriffstrennung, Architektur-Landkarte, Identifier-Mapping-Plan

> ---
>
> ## ⚠️ STAND 2026-08-07: DER CODE-RENAME IST UNAUSGEFUEHRT -- UND SEIN BUMP-FENSTER IST VERBRAUCHT
>
> **Anders als die uebrigen Dossiers dieses Ordners ist dieses hier nicht deshalb gefaehrlich, weil
> es Gebautes fuer offen haelt, sondern umgekehrt:** der Doku-Teil (A-E) ist erledigt, der
> Code-Teil ist **null Prozent** ausgefuehrt, und die Kopplung an ein ABI-Fenster, die §6 herstellt,
> traegt nicht mehr. Belege gegen ce `ba069e38` (identisch in `ab0b352e`).
>
> ### §5.2 Identifier-Mapping-Plan: KEINE einzige Umbenennung ist vollzogen
>
> Am Code ausgezaehlt (`grep -rl` ueber `libs/`, `tests/`, `apps/`):
>
> | Ziel-Bezeichner (`:222-237`) | Treffer heute | Alt-Bezeichner | Treffer heute |
> |---|---|---|---|
> | `IObservableSubject` | **0** | `IObservableTier` | **25 Dateien** |
> | `IDriveableSubject` | **0** | `tier_insert` | **21 Dateien** |
> | `ISetSubject` | **0** | `tier_lookup` | **11 Dateien** |
> | `subject_insert` / `subject_lookup` | **0** / **0** | -- | -- |
> | `ComdareSubjectObserverSnapshot` | **0** | -- | -- |
> | `AnatomyOrganismSubclass` (`:217-219`) | **0** | `AnatomyTierSubclass` | 1 (als Ziel-Verweis) |
> | `MemoryBandBudget` (`:239-243`) | **0** | `IMigratableTier`, `tier_moves` | bestehen |
>
> Die Dateinamen sind ebenfalls unveraendert `*_tier.hpp`. Beleg fuer den Bestand:
> `anatomy/idriveable_tier.hpp:46`, `:49`; `anatomy/observable_tier.hpp:181`;
> `anatomy/resource_controllable_tier.hpp:56`, `:67`.
>
> **Das Dokument selbst ist an dieser Stelle ehrlich:** `:400` fuehrt den Code-Rename korrekt als
> „Verbleibend NUR Implementierungs-Agent". Irrefuehrend sind §5.2 und §4.4, die prospektiv
> formuliert sind, ohne diesen Status zu tragen.
>
> ### §6.6: das Bump-Fenster, an das der Rename gebunden ist, ist fuenffach verbraucht
>
> `:261-263` bindet den Rename an einen **„ABI-Major-Bump 3→4"**. Dieser Bump ist am #216-H2
> vergeben worden (`tier_reset_statistics`-vtable-Slot) -- der Rename ritt nicht mit. Seither gab es
> **vier weitere** Brueche, jeder ein freies Fenster, keines genutzt:
> 4→5 (Bau-INC-2b, 17.07.), 5→6 (Bau-INC-2d, 18.07.), 6→7 (STRUKT-R ORG-18, 26.07.),
> 7→8 (E-24 C8, 04.08.) -- `abi/anatomy_module_abi_v1_decl.hpp:46`, `:52`, `:57`, `:65`; Ist-Major
> **8** an `:89`. **Wer den Rename heute plant, braucht ein neues Fenster; die Kopplung an „3→4"
> ist gegenstandslos.**
>
> ### Achsenzahlen
>
> | Zeile | steht im Audit | Ist heute | Beleg (ce) |
> |---|---|---|---|
> | `:113` | „Achse = Organ … **19** (SearchAlgorithm)" | **18** | `builder/experiment_tree/axis_path_serialization.hpp:40` |
> | `:117` | „SA **19**, Set **15**, Sequence **11**, Adapter **13**, View **7**" | **18 / 13 / 9 / 11 / 5** | `builder/experiment_tree/genus_binding_traits.hpp:48`, `:102`, `:132`, `:74`, `:160` |
> | `:142` | „Autoritative Zahl **19** = `kV3AxisCount`" | `kV3AxisCount = **18**` | `anatomy/observable_tier.hpp:50` |
> | `:182-183` | „`axis_stats[19][8]` + `seg_ns[19]`" | `[18][8]` + `seg_ns[18]` | `observable_tier.hpp:141-142` |
> | `:111` | „`enum AnatomyGattung` — 3: **SearchAlgorithm** · Container · Graph" | Enumerator umbenannt zu **`Map = 0`** (E-24 C7-1, 04.08.); Zahlenwert und Reihenfolge unangetastet | `anatomy/anatomy_base.hpp:49-57` |
> | `:119-120` | „**nur die SearchAlgorithm-Unterklasse ist voll gebaut**, die uebrigen 4 existieren als `GenusBindingTraits`" | **ueberholt** -- alle fuenf Genera haben ein Pruef-Dock; Set hat native ABI | `builder/pruef_dock/{set,sequence,adapter,view}_dock.hpp` |
>
> **Weiterhin korrekt (nicht anfassen):** `:63-65`, `:153` die Direktive „Anatomy-ABI orthogonal zur
> Observer-Schnittstelle" · `:140-144` die 26 Registry-Achsen mit 3 build-only · `:116`, `:121-122`
> `gattung_of()` und die Zoologie-Bruecke · `:216` „`enum AnatomyGenus` neutral, **bleibt**" --
> heisst tatsaechlich weiterhin so · `:319` „bewusst belassen: `thesis_tiere/`" -- das Verzeichnis
> besteht fort (30 Dateien).
>
> **Ungeprueft:** `:145-147` die Zaehlung „74 Tag-Structs + 54 Strategy-Concepts + 151 Wrapper" --
> nicht nachgezaehlt. `:239-243` die prt-art-Haelfte (`multi_level_layout.hpp`, `CacheTier`,
> `TierBudget`) -- das prt-art-Submodul ist in diesem Arbeitsbaum nicht ausgecheckt; **die ce-Seite
> ist nachweislich unveraendert**, die prt-art-Seite konnte ich nicht pruefen.
>
> ---

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
> Doc 34=31 …). Vollständiger Scope + ALLE Pflicht-Referenzen: **`thesis/diplomarbeit/docs/sessions/2026-06-15-tier-umstellung-fortschritt-und-vollstaendiger-rest-uebergabe.md`**.

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

### B. cache-engine `docs/` ✅ KOMPLETT (architecture + sessions + quality_audit; ce-Commits bis `cb16c20`, Submodul-Bump `04f90fe`; Code-Identifier-Rename = Impl-Agent #90; s. §10)
### C. prt-art `docs/` + READMEs ✅ (nur Code `TierBudget`/`tier_*`/`CacheTier` → kein Doku-Commit nötig; Code = Impl-Agent)
### D. Manuskript `thesis/diplomarbeit/` ✅ (`kapitel/de`+`en`: 0 `\bTier`; ① Metapher + ④ Rang, DE≡EN äquivalent; `1e2204f` + frühere `3576621` etc.)
### E. `thesis/diplomarbeit/sessions/` ✅ (Content-Docs `konzeptionelle`/`aufgabenstellung`/KONTEXTUEBERGABE/gesamtstand aufgelöst, Thesis-Repo `8389634`; die 2 Meta-Tracking-Übergaben `tier-definitionsluecke`/`tier-umstellung-fortschritt` belassen wie das Master-Doc — Subjekt-Wort „Tier")

---

## §10 — B-Fortschritts-Log (cache-engine `docs/`, LIVE, Resume-fähig)

**Scope (Grep `\bTier`, Stand 2026-06-15):** **673 Treffer / 83 `.md`-Dateien.** Methodik je Datei: lesen → Prosa ① „Tier"→**Lebewesen** / ③ Cache-/Memory-/Multi-Tier→**Ebene** / ④ SOTA-Tier-N→**Rang**; **BELASSEN** `>`-verbatim-Zitate (mit „Tier") + Code-Identifier (`IObservableTier`/`tier_observe*`/`ComdareTierObserverSnapshot`/`CacheTier`/`MultiTier*`/`TierKind`/`TierBudget`/`tier_to_organ_mapping`) + Bio-Beinamen (Säugetier/Reptil/**Schnabeltier**). Commit nur `docs/` (CSVs/Code NIE). Verifikation je Datei: `\bTier`-Grep → nur noch `>`-Zeilen + Code-Identifier übrig.

**architecture/ (kanonisch, zuerst):**
- [x] `24` (ce `c115438` + `46b36f3`-Nachzug §8.8) · `26`/`27`/`28`/`29` (ce `46b36f3`) · `30` (ce `3c7ab5f`) · `33`/`34` (ce `c95ecd7`) · `abhaengigkeitskette` (ce `75ed122`) · **`messarchitektur_*`** (v5_design/klarstellungen/v5_entscheidungen/design_observer/drei_profile, ce `7e300da`; `_i8`=nur Code `TierBased`, unverändert) — alle ✅ gepusht (~380 Treffer, 14 Architektur-Dateien).
- **METHODIK-VERFEINERUNG (wichtig für Resume):** „Tier-Unterklasse"/„Tier-Binary" sind **redaktionelle Terme** (der User sagte ursprünglich „Gattung"; die `[korr.]`-Notizen führten „Tier-Unterklasse" ein) → überall ① **Lebewesen**, **AUCH in rein redaktionellen `>`-KORREKTUR-Notizen**. **BELASSEN nur: (a) verbatim `> „…"`-User-Zitate** (markiert „User … verbatim-tragend" / echte Zitatsätze; z.B. Doc 30 Z.3-6, Doc 24 §2.1/§7-Direktive/§8.x), **(b) Code-Identifier** (`tier_insert`/`tier_lookup`/`tier_observe`/`IObservableTier`/`*Tier`-Typnamen wie `AdapterTier`, `tier_to_organ_mapping`), **(c) Bio-Beinamen** (Säugetier/Reptil/**Schnabeltier**), **(d) Code-Pfade** (`thesis_tiere/`). „Tier-X" wo `tier_x` ein echter Code-Identifier ist (insert/lookup/erase/clear/size/observe) = ② Subject-Code → BELASSEN; rein beschreibendes „Tier-X" (Binary/Wall-Clock/Modul/Unterklasse/Metapher/Quellen) → ① Lebewesen. **ACHTUNG Zeilenumbruch:** mehrwort-Terme können über `\n` getrennt sein → `replace_all` verfehlt sie; **immer `\bTier`-Grep zur Verifikation je Datei** (zeigt Resttreffer = nur Zitate/Code erlaubt).
- [ ] **architecture-Rest (klein):** `31`(2) · `32`(2) · `15`(3)/`17`(1)/`18`(2)/`19`(3)/`20`(4)/`21`(4)/`22`(4) — überwiegend ④ SOTA-Tier-N→Rang + Code-Identifier.
- ✅ **AUDIT-DURCHLAUF 1 (5 nur-lesende Agenten je Scope, 2026-06-15 — Verifikations-Schleife des /goal `[[project_tier_aufloesung_vollstaendigkeits_goal]]`):** **A (Haupt-Repo) · C (prt-art) · E (_archiv) = 0 Befunde** (frühere Sessions verifiziert VOLLSTÄNDIG; Glossar sauber; A4 = Pseudo-Inkonsistenz: alle `_paper_extractions`/`_rev5_extractions`-Treffer = ③-Code `MultiTierCacheStrategy`/`TierLatencies`/`tier_for`/`TierKind` → korrekt belassen, Z.373↔375 beide sauber). **B done-14 = case-insensitive 0 Treffer** (keine Fehlklassifikation, keine lowercase-③-Lücke). **D (Manuskript) = 1 Befund GEFIXT:** `kapitel/de/01_introduction.tex` Z.66-Quell-Kommentar „Tiere"→„Lebewesen" (LaTeX `1e2204f`); Rang/Rank DE≡EN vollständig+äquivalent; `.aux`-Captions regenerieren beim nächsten `build.ps1`. **Methodik bestätigt: case-insensitive `tier`-Grep ist PFLICHT** (lowercase ③ real, s. Doc 19).
- [ ] **B-REST — KLASSIFIZIERTE ARBEITSLISTE (aus Audit 1) — HIGH ✅ (quality_audit 13×④ + Doc19 ③ lowercase, ce `ae73d4e`) + architecture-Rest ✅ (15/17/18/20/21/22/31/32, ce `c96fb5c`; 16/23/25/INDEX/i8/ref=nur Code). **➡ ARCHITEKTUR-SCOPE B KOMPLETT** (alle Docs 15–34 + abhaengigkeitskette + messarchitektur_* + quality_audit). VERBLEIBT in B NUR `sessions/`:**
  - **HOCH:** `quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md` (**13× ④** „Tier 1/2/3/4"/„Top-Tier" → Rang/Top-Rang) · `architecture/19_f6_prtart_migration_plan.md` (**③** Z.106 „Cache-tier-aware", Z.181 „Tier-Budgeting (L1/L2/L3/Memory)" → Ebene — DIE lowercase-③-Lücke).
  - **architecture-Rest** (je Datei lesen+klassifizieren, ③/②-gemischt): `15`(3)/`18`(1)/`20`(4)/`21`(4)/`22`(3)/`31`(2) = ③-Verdacht (Speicherhierarchie prüfen) · `16`/`17`/`23`/`25`/`32`/`INDEX`/`messarchitektur_v5_i8`/`20260504-ref` = überwiegend ②-Code.
  - **sessions/** = überwiegend ②-Code-Identifier (`tier_to_organ_mapping`/`TierOrganPair`/`TierObserveTrace`) + ①-Zitate in User-Direktiven (BELASSEN); echte ①-Prosa v.a. `SESSION-HANDOFF-organ-metapher`(~7) + `roadmap40-tier-wrapper`.
  - **email/** = nur False-Positives → KEINE Arbeit.
- **NICHT-TERM-DELIVERABLES (Goal):** Glossar ✅ · A4 ✅ (Pseudo) · EN≡DE ✅ · Manuskript-D ✅ · **Submodul-Bump cache-engine ✅** (`04f90fe`); prt-art = kein Bump nötig (docs nur Code `TierBudget`, kein ce-Commit) · #90 `AnatomyGenus`-Code = Implementierungs-Agent (② Subject, separat).
- [x] **sessions/ — LETZTER B-SUB-SCOPE ✅ KOMPLETT 61/61 (2026-06-15)** — alle markdown bearbeitet+verifiziert (ce-Commits `0d60cb2`/`7c28335`/`8d55da4`/`086161e`/`53dbc8d`/`9eae707`/`079b4f4`/`cb16c20`; + Vor-Session `608accd`/`b4a3280`). Verifikation je Datei: case-insensitive `\btier` UND case-sensitive `\bTier`-Grep → Rest nur Code-IDs / `>`-User-Zitate / Bio / intentional (`Tier-insert`=Code-Bezug auf `tier_insert`; `Tier-Scan/RMW`=ABI-Methoden). **5 maschinengenerierte Audit-JSONs** (`patternaudit`/`messaudit`/`audit-sicherung/*.json`, 589 Treffer) = generierte Daten-Artefakte → BELASSEN (analog CSVs). Triage-Ausgangslage war 547 case-insensitive Treffer. **Lektion: Grep-Verify VOR Commit (standalone „je Tier"/„Einzel-Tier"/„alle Tiere" leicht übersehen).** `quality_audit/` ✅ (ce `ae73d4e`) · `email/` = nur False-Positives (KEINE Arbeit). **Sessions = historische Handoff-Logs → Großteil der Treffer = ②-Code-Identifier (`tier_*`/`TierOrganPair`/`ComdareTierObserverSnapshot`/`tier_observe_trace`) + ①-verbatim-User-Direktiv-Zitate → BELASSEN.** Methodik PFLICHT je Datei: case-insensitive `\btier`-Grep + Kontext lesen, nur **echte ①-Prosa** (Tier-Unterklasse/Tier-Binary/Tier-Metrik/„Tiere"/„composite Tier") → Lebewesen; ③/④ → Ebene/Rang; alles in `> „…"` + Code belassen. **Prose-dichteste zuerst:** `A1-lesenotizen`(39)/`undolog-fertig-audits-pausiert`(27)/`E-wellea2-komplexplan`(23)/`SESSION-HANDOFF-organ-metapher`(22)/`goal-v6-luecken-ledger`(21)/`gattungs-kategorienfehler`(20)/`GOAL-MESSUNG-AUDIT-APPENDIX`(18)/`UEBERGABE-mess-echtheit-lazy-dll`(18)/`A2-code-pre-read`(17)/`queuing-87-container`(16)/`observer-konsolidierung`(16)/`UEBERGABE-START-observer`(16)/`architektur-ziele-ledger`(16)/`l-meas-thesis-searchalgo-tiere`(14)/`undolog-resume-rerun`(14) … Rest 1–12. **⚠️ Unterordner `audit-sicherung-20260612/ERKENNTNISSE.md` (8) NICHT vergessen.**
- **B FERTIG ✅ (2026-06-15):** (1) **Submodul-Pointer-Bump ✅** cache-engine `0556e3a`→`cb16c20` im Haupt-Repo (Superprojekt-Commit `04f90fe`); (2) **finaler adversarialer Cross-Scope-Audit ✅** (4 nur-lesende Agenten + eigene case-sensitive `\bTier`-Verifikation ALLER Scopes) = **ZERO actionable**: ce `sessions/` (adversarial 0 Lecks/Over-reach/Inkonsist.), ce `architecture/` (Tier = verbatim-`>`-User-Direktiv-Blöcke + Code), ce docs-rest + prt-art (nur Code `TierBudget`/`tier_*`), Haupt-Repo `docs/` (Master-Doc-Meta + UML-Code-Typsignaturen `TierKind`/`TierPair` + Bio/Paper-Extraktion = A-Scope-„bewusst-belassen"), Manuskript `.tex` DE+EN (0 `\bTier`). **Scope E `thesis/diplomarbeit/sessions/` (vom Audit-Agenten korrekt gefunden — mein erster Gegen-Glob war fälschlich ab `system32` gewurzelt, daher schein-„0"; `01_introduction.tex:66`-Befund war Stale-Read = bereits „Lebewesen"):** Content-Docs aufgelöst (Thesis-Repo `8389634`: `konzeptionelle-…massgeblicher-hinweis` Tier-Unterklasse/-Binary/ein „Tier"/§7-Metapher→Lebewesen; `aufgabenstellung-konsolidierung` Tier/Organ-Metapher + „schnellstes Tier"→Lebewesen; `KONTEXTUEBERGABE`+`gesamtstand` „Tier-1-Quellen"→Rang-1); die 2 **Meta-Tracking-Übergaben** (`tier-definitionsluecke`/`tier-umstellung-fortschritt`) belassen wie das Master-Doc (Subjekt-Wort „Tier" + Cluster-/Mapping-Regeln müssen drinstehen); §7-Doppeldeutigkeits-Regel + Bio + Code belassen. ⇒ **/goal Tier-Auflösung HARD-DONE.** Verbleibend NUR Implementierungs-Agent: #90 `AnatomyGenus`-Enum + `IObservableTier`→`IObservableSubject`/`tier_*`→`subject_*`-Code-Rename (② Subject-Code, NICHT Text-Agent).

**sessions/ + email/ + quality_audit/ (danach):** ~60 Dateien, 1–31 Treffer. Überwiegend ④ SOTA-Tier-N→Rang + Code-Identifier; ① Lebewesen-lastig: `20260613-A1-lesenotizen`(31), `SESSION-HANDOFF-organ-metapher`(20), `20260603-gattungs-kategorienfehler…`(19), `20260603-queuing-migration-und-87-container-tier-unterklasse`(16), `20260611-…undolog-fertig-audits-pausiert`(17), `GOAL-MESSUNG-AUDIT-APPENDIX`(17).

**Pointer-Bump Haupt-Repo:** am Ende der B-Gesamtgruppe (cache-engine-Submodul-Pointer `0556e3a`→finaler B-HEAD).

**OFFENER PRÜFPUNKT A4 (Inkonsistenz):** Zeile 375 markiert `_paper_extractions/` (cluster_D/F) + `_rev5_extractions/` (cache_engine_families/state_visitor/taxonomien/rev4_delta) als OFFEN, Zeile 373 + HISTORIE als erledigt (`23c6462`). Nach B-Architektur-Block per Grep verifizieren + Häkchen konsolidieren.

---

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R11 · Anker docs/architektur/TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md:43-46,81-82]** Keine Korrektur noetig — das 3-Stufen-Join-Modell (§1: Stufe 1 = nur cache-engine, Stufe 2 = Prüfling-ersetzt-mit-Fallback, Stufe 3 = voller Join) und der Verweis auf `pruefling_merge.hpp` decken sich exakt mit R11; der frueher vermutete Konflikt „ist prt-art ein Lebewesen / in CEB gemergt" ist damit aufgeloest (beide sind getrennte Bibliotheken, die ueber die ②Subject-ABI treiben). Additiv praezisieren: die PrueflingSlot-Substitution erfolgt compile-time „in genau EINE Achse", und eine leere Prüfling-Achse reust automatisch alle cache-engine-Algorithmen dieser Achse (code-belegt, User-Direktive 2026-05-26 in `pruefling_merge.hpp`).  
  *(Bezug: 3-Stufen-Join Stufe1 CE-Perms / Stufe2 Prüfling-ersetzt / Stufe3 A⋈B; Prüfling-Slot-Pattern `pruefling_merge.hpp`.)*
- **[R6 · Anker docs/architektur/TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md:81-82]** Die Formulierung „`std::variant`-Bausteine" fuer den Prüfling/SOTA-Fallback liest sich wie Runtime-Dispatch und ist zu praezisieren: der Wechsel zwischen Prüfling-Stack und Stand-der-Technik-Stack erfolgt compile-time via PrueflingSlot (mp_list/CRTP + `std::conditional_t`) in genau EINE Achse; `std::variant` dient — falls verwendet — nur als Storage, die Selektion bleibt statisch (`pruefling_merge.hpp:99-124` nutzt `mp_list`/`std::conditional_t`, KEIN `std::variant`; `permutation_strategy_concept.hpp:10-11` verbietet Runtime-Tag/`std::variant`). Verweis auf die R6-Metaprogrammier-Grenze ergaenzen: nur W/D-Dispatch bewusst runtime, alle Achsen-Bausteine im Hot-Path compile-time-only (CRTP+Concepts, kein Runtime-Switch/vtable).  
  *(Bezug: „Compile-Time-Fallback … (`std::variant`-Bausteine; `pruefling_merge.hpp`; Join Stufe 2)".)*
- **[R1 · Anker docs/architektur/TIER-AUFLOESUNG-AUDIT-UND-MAPPING-PLAN.md:39-41,157-158]** Die Zwei-Bibliotheken-Symmetrie (cache-engine und PRT-ART beide Bibliotheken) und „je Achse einen Katalog von Organ-Varianten" sind der konzeptionelle Vorlaeufer von R1, benennen aber die formalisierte Architektur noch nicht (Doc datiert 2026-06-15, predatiert R1/Ledger §15.1, nicht deprecatet). Additiv ergaenzen: der Organ-Katalog je Achse jeder Bibliothek ist nun als Registry-XML formalisiert — ZWEI Registry-XMLs gleichen Schemas (ce-Registry SOTA + prt-art-Registry), in denen die Bausteine je Achse liegen (NICHT in der Diplomarbeit-/Experiment-XML). Querverweis auf Ledger §15.1 / `feedback_unified_experiment_xml`.  
  *(Bezug: „cache-engine und PRT-ART sind beide Bibliotheken" + „Bibliothek — stellt je Achse einen Katalog von Organ-Varianten bereit".)*
