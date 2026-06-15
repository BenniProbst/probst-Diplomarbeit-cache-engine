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

## 4. ARCHITEKTUR-LANDKARTE (aus dem 4-Strang-Audit)

### 4.1 Die vier Konzept-Ebenen (innerhalb einer Bibliothek)
| Ebene | Begriff | Code-Anker | Anzahl |
|---|---|---|---|
| 1 | **Gattung** = Außen-Interface / Prüf-Dock | `enum AnatomyGattung` | **3**: SearchAlgorithm · Container · Graph |
| 2 | **Lebewesen-Unterklasse** (hist. „Tier-Unterklasse") = fester Achsen-Satz | `enum AnatomyGenus` | **5**: SearchAlgorithm · Set · Sequence · Adapter · View |
| 3 | **Achse = Organ** = permutierbare Teilentscheidung (keine optional) | `topics/`→`axes/` | **19** (SearchAlgorithm) |
| 4 | **Sub-Achse = Organ-Bestandteil** | `*_subaxes_*.hpp` | **~57–279** |

`gattung_of()`: SearchAlgorithm → eigene Gattung; Set/Sequence/Adapter/View → Container.
Achsen-Sätze: SearchAlgorithm **19**, Set **15**, Sequence **11**, Adapter **13**, View **7**.
Cross-Genus-Permutation type-mathematisch unmöglich. **andere Gattung = grundlegend anderer
Basis-Achsen-Satz** (konz. Doku §4); Hash-Map = limitiertes Subset derselben 19 Achsen (keine eigene
Gattung). Metapher: Säugetier=SearchAlgorithm · Vogel=Set · Reptil=Sequence · Wirbelloses=Adapter ·
Pflanze=View; „Viren" (Graph/FFT/Crypto) = außerhalb der Anatomie.

### 4.2 topics ≠ axes + „17 Topics" ≠ „19 Achsen"
`topics/<name>/axis_NN_*/` = Forwarding-Stubs → delegieren an `axes/<kurzname>/` (echte Impl).
17 Topic-Verzeichnisse, aber **19 Achsen** (`traversal`/`nodes`/`hardware` bündeln je 3, `queuing` 2);
autoritativ `observable_tier.hpp::kV3AxisCount = 19` (= `seg_ns[19]`). Sub-Achsen-Bestand
(code-gezählt): 74 Tags + 54 Concepts + 151 Wrapper ≈ **279** Organ-Bestandteile (Goldstandard
`axis_06_allocator`); Manuskript-Zahl **„~57"** = Tag-Näherung (beibehalten). ⚠️ Sub-Achsen-Header
in **beiden** Bäumen (topics/+axes/) nachziehen.

### 4.3 Schichtung pro Lebewesen-Unterklasse
`XxxComposition` (Typ-Liste der Achsen) → `XxxAnatomy<Composition>` (**①** konkretes Lebewesen
in-process) → `IXxxTier` (**②** ABI über DLL-Grenze, → `IXxxSubject`) → `XxxAbiAdapter` (Brücke;
**106 Treffer** in `abi_adapter.hpp`).

### 4.4 prt-art: 8 Bausteinschichten + ③`CacheTier`
8 Schichten: L1 Identität · L2 Measurement/Telemetry · L3 Prefetch · L4 Node-Typen · L5
Internal-Search · L6 Concurrency (OLC) · L7 Memory · L8 Serialisierung. **`CacheTier` ist ein
Organ-Bestandteil (Sub-Achse) der memory_layout-Achse (Achse 5)** — `tier_for_key()` bildet ein
Schlüssel-Präfix per `VirtualOffsetAddress` (TLB-Emulation) → Hot/Warm/Cold/Memory-**Band**. Kein
eigenes Cache-Modul. (⚠️ Repo-Kollision: „L1…L8" = Architektur-Schichten ≠ „L1Hot…" = Cache-Bänder.)

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
