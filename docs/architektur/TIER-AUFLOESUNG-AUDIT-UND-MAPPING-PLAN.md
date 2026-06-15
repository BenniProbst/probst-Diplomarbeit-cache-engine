# Groß-Audit: „Tier"-Auflösung — Begriffstrennung, Architektur-Landkarte, Identifier-Mapping-Plan

> **Status:** AUTORITATIVE GRUNDLAGE für die codebasis-weite Auflösung des doppeldeutigen Wortes
> „Tier". Erstellt 2026-06-15 aus einem 4-Strang-Groß-Audit (Konzeption / Achsen / Anatomie /
> prt-art) + vier User-Festlegungen. **Beide Workstreams** (Text-Agent = Doku/Kommentare;
> Implementierungs-Agent = Code-Identifier) richten sich danach.
>
> **Quellen:** `docs/architektur/14_*` · cache-engine `docs/architecture/34_*`/`30_*` ·
> `anatomy/anatomy_base.hpp` · `anatomy/idriveable_tier.hpp` (Direktive „Anatomy-ABI ⊥
> Observer-Tier-Schnittstelle") · `anatomy/observable_tier.hpp` ·
> `builder/experiment_tree/genus_binding_traits.hpp` · prt-art `memory_layout/multi_level_layout.hpp`
> · konz. Doku `thesis/.../2026-06-15-konzeptionelle-...md`.

---

## 0. Das Problem in einem Satz

Das Wort **„Tier"** trägt im Projekt **vier** verschiedene Bedeutungen, die sich im selben Token
überlagern (dt. „Tier"=animal vs. engl. „tier"=Stufe). Eine naive globale Ersetzung würde
Bedeutungen verwechseln und die Architektur beschädigen. Dieses Dokument trennt die vier
Bedeutungen und gibt je einen eindeutigen Zielbegriff.

---

## 1. DIE BEGRIFFSTRENNUNG (4 Cluster — der Kern)

| # | Cluster | Was es ist | Zielbegriff | Geltungsbereich |
|---|---|---|---|---|
| **①** | **LEBEWESEN / Anatomie** | *was* ein Algorithmus IST: das Lebewesen + seine Achsen/Organe (fachlich) | **„Lebewesen"** (Doku) · Code bleibt technisch | Metapher in Doku/Kommentar/Kap. 4 |
| **②** | **PROBE / Mess-Schicht** | *wie* ein Algorithmus GEMESSEN/angetrieben wird: die ABI-Schnittstelle (methodisch, **⊥ Anatomie**) | **„Probe"** (`*Probe`, `probe_*`) | Code-Identifier + Doku |
| **③** | **BAND / Cache-Ebene** | Speicher-/Cache-Hierarchie L1/L2/L3 (Organ-Bestandteil der memory_layout-Achse) | **„Band" / „Cache-Ebene"** (`*Band`, `band_*`) | Code-Identifier + Doku |
| **④** | **RANG / SOTA-Reifegrad** | Tier-1/2/3 (Reifegrad der Stand-der-Technik-Verfahren) | **„Rang" (DE) / „Rank" (EN)** | Doku (Manuskript bereits erledigt) |

**Die zentrale Achse der Trennung (User-Direktive, code-belegt in `idriveable_tier.hpp:6`):**
> **„Anatomy-ABI ⊥ Observer-Tier-Schnittstelle"** — ①Anatomie und ②Probe sind **orthogonal**.
`IObservableTier` hängt NICHT an `IAnatomyBase` (`observable_tier.hpp:22`), sondern wird per
`dynamic_cast` separat abgefragt. Deshalb bekommen ① und ② **getrennte** Begriffe: ① bleibt
Lebewesen, ② wird Probe. Pro Lebewesen-Unterklasse existiert beides nebeneinander —
`SetAnatomy` (①Achsen) vs. `ISetTier`→`ISetProbe` (②ABI), verbunden nur über `SetAbiAdapter`.

**Rollen eines Lebewesens (① — NICHT die Mess-Schicht):**
- **Prüfling** = der Kandidat unter Test = **PRT-ART** (rekombiniert die cache-engine-Achsen
  seiner Gattung [SearchAlgorithm] + 8 eigene Bausteinschichten). „Prüfling" ist ein **belegter
  Begriff** und meint ein konkretes Lebewesen, NICHT die ②Probe-Schnittstelle.
- **Baseline / Stand der Technik** = die cache-engine-Lebewesen (ART, HOT, …), gegen die der
  Prüfling antritt.
- Beide werden über dieselbe **②Probe**-ABI vom Host getrieben/gemessen.

---

## 2. ARCHITEKTUR-LANDKARTE (aus dem 4-Strang-Audit)

### 2.1 Die vier Konzept-Ebenen (das „3-Ebenen-Modell" hat 4 verschachtelte Ebenen)

| Ebene | Begriff | Code-Anker | Anzahl |
|---|---|---|---|
| 1 | **Gattung** = Außen-Interface / Prüf-Dock | `enum AnatomyGattung` | **3**: SearchAlgorithm · Container · Graph |
| 2 | **Lebewesen-Unterklasse** (hist. „Tier-Unterklasse") = fester Achsen-Satz / ABI-Identität | `enum AnatomyGenus` | **5**: SearchAlgorithm · Set · Sequence · Adapter · View |
| 3 | **Achse = Organ** = permutierbare Teilentscheidung (keine optional) | `topics/` / `axes/` | **19** (SearchAlgorithm) |
| 4 | **Sub-Achse = Organ-Bestandteil** = orthogonale Dimension im Organ | `*_subaxes_*.hpp` | **~57–279** (s. 2.3) |

`gattung_of()`: SearchAlgorithm → eigene Gattung; Set/Sequence/Adapter/View → alle Container.
Achsen-Sätze pro Unterklasse (`genus_binding_traits.hpp`): SearchAlgorithm **19**, Set **15**,
Sequence **11**, Adapter **13**, View **7**. Cross-Genus-Permutation ist type-mathematisch
unmöglich (5 getrennte Anatomien/Compositions/Observer/PermutationEngines). **Nur die
SearchAlgorithm-Unterklasse ist voll gebaut** (BR-1..4); die übrigen 4 sind `GenusBindingTraits`.

Metapher-Mapping: Säugetier=SearchAlgorithm · Vogel=Set · Reptil=Sequence · Wirbelloses=Adapter
· Pflanze=View. „Viren" (Graph/FFT/Crypto) = außerhalb der Anatomie (`IVirusExecutionEngine`).

### 2.2 Was eine ANDERE Gattung ausmacht (konz. Doku §4 — der „letzte Kommentar")

> **Gleiche Gattung, anderer Typ** ⇔ gleicher Achsen-Satz, anderes erlaubtes **Subset**.
> **Andere Gattung** ⇔ **grundlegend anderer Basis-Achsen-Satz** — Achsen, die für die Typen der
> ersten Gattung schlicht keinen Sinn ergäben.

Lehrbeispiel Hash-Map: **keine** eigene Gattung — sie ist eine `search_algo`-Achsen-Ausprägung
(`HashSearchAlgo`, S14) mit limitiertem Subset derselben 19 Achsen (path_compression=None,
mapping=Direct, filter=None, flach, range_scan=false). Eine eigene Gattung zu erheben wäre der
queuing-**Kategorienfehler**.

### 2.3 topics ≠ axes + „17 Topics" ≠ „19 Achsen"

- **Doppel-Verzeichnisbaum (bewusste Migration V41.F.2):** `topics/<name>/axis_NN_*/` = dünne
  **Forwarding-Stubs** → delegieren an `axes/<kurzname>/` = **echte Implementierung**. Single-
  Source der 17-Achsen-Liste: `axes/axis_centric_namespaces.hpp`. **Konsequenz für die
  Umstellung:** Sub-Achsen-Header existieren teils in BEIDEN Bäumen — beide nachziehen.
- **17 Topic-Verzeichnisse, aber 19 Achsen:** `traversal` bündelt 3 (search_algo/cache_traversal/
  mapping), `nodes` 3 (page_type/path_compression/node_type), `hardware` 3 (isa/simd_ext/
  general_hw), `queuing` 2 (q1/q2). Autoritative Zahl **19** = `observable_tier.hpp::kV3AxisCount`
  (T0..T18, = `seg_ns[19]` Per-Achsen-Timer). (+3 „Build-Achsen" page_type/simd_ext/general_hw als
  Codegen-Varianten → historische „22".)
- **Sub-Achsen-Bestand** (code-gezählt): 74 Tag-Structs + 54 Strategy-Concepts + 151 Wrapper =
  **~279 Organ-Bestandteile** für die SearchAlgorithm-Gattung (Goldstandard `axis_06_allocator`:
  7 Tags + 6 Concepts + 25 Vendor-Wrapper). Die im Manuskript genannte Zahl **„~57"** zählt die
  Tag-Sub-Achsen (näherungsweise); je nach Konvention (Tags / +Concepts / +Wrapper / +composable)
  schwankt die Gesamtzahl — im Manuskript „~57 Sub-Achsen" als belegte Näherung beibehalten.

### 2.4 Die Schichtung pro Lebewesen-Unterklasse (Strang 3)

1. **`XxxComposition`** (`*_composition.hpp`) = Typ-Liste der Achsen-Ausprägungen (Identität,
   compile-time). Kein „Tier".
2. **`XxxAnatomy<Composition>`** (`*_anatomy.hpp`) = das konkrete **Lebewesen** in-process (hält
   die Organe, treibt sie, `observe_all()`). Technischer Name. ⟵ **①**
3. **`IXxxTier`** (`*_tier.hpp`, `observable_tier.hpp`, …) = ABI-Interface über die DLL-Grenze;
   der Host treibt/misst darüber. ⟵ **②** (wird → `IXxxProbe`)
4. **`XxxAbiAdapter`** (`abi_adapter.hpp`, `*_abi_adapter.hpp`) = Brücke: erbt `IAnatomyBase` +
   `IXxxTier`, hält eine `XxxAnatomy`. **106 „Tier"-Treffer** in `abi_adapter.hpp` (größter
   Brennpunkt).

### 2.5 prt-art: 8 Bausteinschichten + die ③-Einordnung von `CacheTier`

8 Schichten (`PROJECT_LAYER_MAP.md`, code-verifiziert gegen `PrtArtComponents`): L1 Identität ·
L2 Measurement/Telemetry · L3 Prefetch · L4 Node-Typen (bplus/redirect) · L5 Internal-Search ·
L6 Concurrency (OLC) · L7 Memory (pool_set, **memory_layout**, value_handle) · L8 Serialisierung.

**`CacheTier` ist NICHT eigenständige Cache-Hierarchie**, sondern ein **Organ-Bestandteil
(Sub-Achse) der memory_layout-Achse (Achse 5)**: `tier_for_key()` bildet ein Schlüssel-Präfix per
`VirtualOffsetAddress` (TLB-Emulation, Horner) → virtuelle Position → Hot/Warm/Cold/Memory-**Band**.
Werte L1Hot/L2Warm/L3Cold/Memory; `TierBudget` = Byte-Grenzen. Code-aktiv (Member in
`PrtArtComponents`, voll getestet). → Cluster ③ **Band**. (⚠️ Namens-Kollision im Repo: „L1…L8" =
Architektur-Schichten ≠ „L1Hot…" = Cache-Bänder — auseinanderhalten.)

---

## 3. IDENTIFIER-MAPPING-PLAN (alt → neu) — für den Implementierungs-Agenten

> **Grundregel:** NIE global ersetzen. Jede „Tier"-Stelle erst einem der 4 Cluster zuordnen, dann
> den Cluster-Zielbegriff anwenden. Deutsche Substrings (sor**tier**t, exis**tier**t, garan**tier**t,
> permu**tier**en, implemen**tier**t, „Säuge**tier**", …) sind **keine** Treffer.

### 3.1 ① LEBEWESEN / Anatomie
- **Doku/Kommentare:** „Tier" (animal) → **„Lebewesen"**; „Tier-Unterklasse" →
  „Lebewesen-Unterklasse"; „ein Tier" → „ein Lebewesen"; „Tier-Metapher" → „Lebewesen-Metapher".
  Bio-Beinamen (Säugetier/Vogel/Reptil/Wirbelloses/Pflanze) **bleiben**.
- **Code:** Anatomie-Identifier sind bereits technisch und **bleiben** (`SearchAlgorithmAnatomy`,
  `IAnatomyBase`, `AnatomyConcept`, `kingdom_name()="Animalia"`).
  - `enum AnatomyGenus` = neutral („Genus" enthält kein „Tier") → **bleibt**. ⚠️ **Der geplante
    #90-Refactor `AnatomyGenus → AnatomyTierSubclass` MUSS umgelenkt werden** (reimportiert „Tier"):
    Ziel statt dessen `AnatomyOrganismSubclass` **oder** `AnatomyGenus` belassen. Kommentar in
    `anatomy_base.hpp:57` entsprechend korrigieren.
  - Parameter `tier_subclass` (in `gattung_of()`, `anatomy_base.hpp:89`) → `organism_subclass`
    (gehört zu ①, **nicht** zu ②/Probe!).

### 3.2 ② PROBE / Mess-Schicht (`anatomy/` + `builder/`) — der Haupt-Block (~200+ Treffer)
**ABI-Interfaces** (`*_tier.hpp` → `*_probe.hpp`):
`IDriveableTier`→`IDriveableProbe` · `IObservableTier`→`IObservableProbe` ·
`IRollbackableTier`→`IRollbackableProbe` · `IScannableTier`→`IScannableProbe` ·
`IResourceControllableTier`→`IResourceControllableProbe` · `ISetTier`→`ISetProbe` ·
`ISequenceTier`→`ISequenceProbe` · `IAdapterTier`→`IAdapterProbe` · `IViewTier`→`IViewProbe`.

**ABI-Methoden** (`tier_*` → `probe_*`):
`tier_insert/lookup/erase/clear/size` · `tier_observe` · `tier_save_all`/`tier_rollback_all` ·
`tier_scan` · `tier_query_resource_caps`/`tier_apply_resource_control` ·
`tier_set_insert/contains/erase/size/clear`/`tier_observe_set` ·
`tier_push_back`/`tier_at`/`tier_observe_sequence` · `tier_put`/`tier_get`/`tier_observe_container`
· `tier_bind`/`tier_read`/`tier_observe_view` · Helfer `tier_search_routes_through_store`,
`tier_rollback_is_exact`, `tier_memento_is_copy_on_write` → alle `probe_*`.

**POD/Konstanten/Felder:** `ComdareTierObserverSnapshot`→`ComdareProbeObserverSnapshot` ·
`kTierObserverSnapshotVersionUnified`→`kProbeObserverSnapshotVersionUnified` ·
Feld `tier_fill_level`→`probe_fill_level`.

**Dateien:** `idriveable_tier.hpp`, `observable_tier.hpp`, `rollbackable_tier.hpp`,
`scannable_tier.hpp`, `resource_controllable_tier.hpp`, `set_tier.hpp`, `sequence_tier.hpp`,
`adapter_tier.hpp`, `view_tier.hpp` → `*_probe.hpp`; `builder/anatomy_commands/tier_observe_trace*.hpp`
→ `probe_observe_trace*` (+ alle `#include`-Pfade nachziehen).

### 3.3 ③ BAND / Cache-Ebene (prt-art + 2 cache-engine-Achsen)
- prt-art `memory_layout/multi_level_layout.hpp`: `enum CacheTier`→**`MemoryBand`** (Werte
  L1Hot/L2Warm/L3Cold/Memory dürfen bleiben) · `TierBudget`→`MemoryBandBudget` ·
  `tier_for_offset`/`tier_for_key`→`band_for_offset`/`band_for_key` · Tests in
  `test_memory_layout.cpp` nachziehen.
- cache-engine `axis_migration` (`TierBasedMigration`, `kTiers`, `tier_index_sum`, flag
  `TIER_BASED`) + Observer-Feld `tier_moves` + prefetch `tier_latency_cycles` → Cache-/Storage-Ebene
  → `band_*` / `cache_level_*` (NICHT Lebewesen/Probe!). **Klassische false-positive-Klasse.**

### 3.4 ④ RANG / SOTA
„Tier-1/2/3" → „Rang-1/2/3" (DE) / „Rank-1/2/3" (EN). **Manuskript erledigt.** Offen: gesamter
`docs/`-Bestand (bes. `bausteine/03_cross_paper_konzeptmatrix.md`, `forschungslandkarte/*`,
`EMAIL_KONTAKTE.md`, viele `sessions/`/`termine/`). **`TIER3` (ZIH-HPC-Projekt-Typ) NICHT anfassen**
(externer Fachterminus).

---

## 4. FALLSTRICKE

1. **`tier_subclass` (①→organism_subclass) vs. `tier_insert` (②→probe_insert) vs. `tier_moves`
   (③→band_moves)** — drei Cluster, drei Ziele, alle Präfix `tier_`. NUR nach Bedeutung ersetzen.
2. **`Tier-1/2/3` ist IMMER ④ Rang; jede andere `Tier`-Komposition ist ①/②/③.** Heuristik:
   Bindestrich+Ziffer → Rang; sonst kontextprüfen.
3. **`Säugetier` enthält Teilstring `tier`** → Wortgrenzen (`\bTier\b`) nutzen; Bio-Beinamen schützen.
4. **ABI-Konsequenz (②):** `tier_*` sind vtable-Methoden über die DLL-Grenze und
   `ComdareTierObserverSnapshot` ein cross-boundary-POD. Umbenennung ist **ABI-brechend** → Host
   (CacheEngineBuilder/Loader/`anatomy_module_abi_v1_decl.hpp`) **und** alle Prüflings-DLLs
   synchron + **ABI-Major-Bump** (3→4). Sache des Implementierungs-Agenten.
5. **Doppel-Verzeichnisbaum** `topics/`+`axes/` — Sub-Achsen-Header in beiden nachziehen.
6. **#90-Refactor umlenken** (siehe 3.1) — nicht versehentlich „TierSubclass" einführen.

---

## 5. UMSTELLUNGS-REIHENFOLGE

**Doku (Text-Agent, dieses Repo + Submodul-Docs):**
1. ④ Rang in `docs/` (eindeutig, geringes Risiko) — Manuskript schon fertig.
2. ① Lebewesen in `docs/architektur/14_*` (dichteste Datei) + übrige `docs/` + cache-engine-`docs/`.
3. ② Probe / ③ Band in Doku + Code-Kommentaren (parallel zum Code).
4. konz. Doku + diese Übergaben selbst nachziehen („Tier-Unterklasse" → „Lebewesen-Unterklasse").

**Code (Implementierungs-Agent, Submodule):** ② Probe (ABI-Major-Bump, Host+DLLs synchron) →
③ Band → ① `tier_subclass`/#90-Notiz. Identifier-Direktive (Doku 14 §41) bleibt: Code-Namen
technisch (`*Probe`/`*Anatomy`), Metapher nur im Kommentar.

---

## Anhang: Vier User-Festlegungen (2026-06-15)
1. Beide Bedeutungen auflösen (Metapher **und** Level), „Tier" als Wort vermeiden.
2. ① Metapher-Oberbegriff → **„Lebewesen"**; Bio-Beinamen bleiben.
3. ① und ② sind orthogonal → **getrennte Begriffe**.
4. ② Mess-Schicht → **„Probe"** (Mess-Sonde), NICHT „Prüfling" (= PRT-ART, ein Lebewesen).
