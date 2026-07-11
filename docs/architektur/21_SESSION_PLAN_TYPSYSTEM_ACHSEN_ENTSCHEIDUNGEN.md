# 21 — Session-Plan: Messkurven-Typsystem, Achsen-Entscheidungen & Maximal-Utilization-Refactorings

> **Quelle:** User-Entscheidungen 10.07.2026 (Chat über die 7 Doc-20-§H-Forks + Architektur-Klärung) +
> Deep-Research-Workflows `wf_62fe0731` (Kardinalitäten, 71 Befunde), `wf_73129d50` (Unter-Achsen/Utilization/
> Zyklen/HW-Prefetcher, 29 Achsen). Rahmung (Memory `feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings`):
> **CI grün + messfähig, Kern vollständig vorhanden — ab jetzt nur PUNKTUELLE Refactorings, kein Greenfield.**
> Stand: ce `c022ce05` (ctest 199/199), super development `e2888c3`. Belege alle `datei:zeile`.

Dieses Dokument ist der **bindende Bauplan** für die E4′-/Arbeitsmodus-/Hybrid-Strecke. Es ersetzt das
„orthogonal compile/dynamic"-Bild aus Doc 20 §I durch das korrigierte **Layer-/Haupt-Unter-Achsen-Modell**.

---

## A. Das autoritative Architektur-Modell (User-Klärung 10.07., ersetzt Doc-20-Annahmen)

1. **Der Experiment-Baum ist ein B+-Baum, LAYER-sortiert:** jede Achse = ein Layer. Eine **statische
   (compile-time) Achse** bildet einen strikten Layer; darunter folgen **dynamische Achsen-Nodes**, bis wieder
   eine statische Achsen-Konfiguration eingehängt ist. Der **SPREAD** einer Node = alle Variationen EINER
   Achse — ENTWEDER statische compile-time-Algorithmen ODER dynamische Wert-Änderungen. **Die beiden fallen
   NIE zusammen** (pro Node-Spread genau eine Sorte).
2. **Wurzel = die System-Achsen == Meta-Achsen** (inkl. telemetry + Mess-System). Sie reichen per
   **Visitor-Pattern** die Workloads durch die folgenden Nodes; in den Visitoren sind **Strategy-Pattern**
   eingebaut, um den nächsten Workload + Workload-Wert gegen die folgenden Achsen zu benchmarken.
3. **Zweite „Dimension" (Abläufe):** bauen → messen → auswerten → Hybrid-Modus = ein **Builder-Pattern über
   ein State-Pattern**.
4. **Decorator über das Visitor-Objekt:** loggt beim rekursiven Durchgang durch die Achsen-Schichten den
   State der Tier-Binary-Wahl (ein Stack). Compile-time legt die statischen Instanzen fest und ermittelt
   effektiv nur die dynamischen.
5. **EIN Concept für alle Achsen — Haupt-Achse + Unter-Achse:** eine Unter-Achse ist eine **VOLL-Achse**, die
   unter der compile-time-Haupt-Achse ausgeführt wird. Der frühere „Laufzeit-Skalar" (RC-POD-Feld) ist in
   Wahrheit eine **Unter-Achse**.
6. **Meta-Achsen == System-Achsen**, strategisch-hierarchisch korrekt an der Wurzel aufzubauen.
7. **ZIEL = MAXIMALE UTILIZATION:** jedes Achsen-Interface muss bei möglicher Anwendung in **ALLEN anderen
   (nicht-System-)Achsen ECHT verlinkt + angewandt** sein. Bestehende Algorithmen sind ggf. anzupassen, damit
   sie andere Achsen-Interfaces verwenden und alle Funktionalitäts-Variationen ECHT abbilden — sonst haben die
   Achsen keinen Effekt (honest-0/no-op = **Utilization-Lücke**).

---

## B. Die 7 Fork-Entscheidungen (User 10.07., ALLE getroffen)

| # | Entscheidung | Umsetzung im Baum |
|---|---|---|
| **H1** | **Workload-Frameworks, Workloads (mit Größe), anwendbare Operationen und Workload-Abläufe/Patterns werden als generische Klassen + Strategy-Pattern definiert und vereint.** Ergebnis = die Achse der **statischen Frameworks × Workloads** mit **dynamischen Testreihenfolgen** (im Paper definiert) über die eigentlichen Testdaten. Umfang IST definiert: **13 Frameworks** (Thesis `tab:wl-frameworks`), **14 Lastprofile LP01–LP14** (`tab:lp-catalog`), **OP-1..6** (`docs/datasets/OP_1_to_6_SPECIFICATIONS.md`). | `framework × workload` = statischer Layer (compile-time); `operation`/`test-sequence` = dynamischer Layer darüber (über die Testdaten). Generische Basisklasse + Strategy je Framework/Workload/Op/Sequence. |
| **H2** | **Beschaffenheit (Key/Value-Verteilung) wird in den Workload-Typ ENCODIERT** — keine eigene Ebene. Dynamische Achsen dürfen **multiple Parameter** covern. | Die ≥5 Facetten (Key-Typ, Präfix-Sharing, Zipf-Skew, Wertgröße, neg%, Ingestion-Ordnung) sind Teil der Workload-Typ-Definition; eine dynamische Achse bündelt sie. |
| **H3** | **workload-size = map über die verfügbaren Cache-Regime-Werte, um einen Key zu erreichen** (maschinenrelativ, wie empfohlen). | Der Size-Layer wird per Cache-Regime des jeweiligen Hosts geschlüsselt; die absolute N-Liste landet in den Regimen (heutiger m3v2-Sweep passt an die reale LLC an). |
| **H4** | **Alle `std::map`-Hüllen-Interfaces werden gemessen, in jeder verfügbaren variadisch-metaprogrammierbaren Form; Orientierung am Standard std C++23; BEIDE (Runner-Op-Set UND XSD) werden geändert.** | Op-Achse folgt der std-C++23-assoziativen-Container-Schnittstelle (insert/find/erase/at/operator[]/count/contains/lower_bound/upper_bound/equal_range/emplace/insert_range/…), variadisch metaprogrammiert; Runner-6 + XSD-6 werden auf dieses Set gehoben. |
| **H5** | **Framework-Ebene = die 13-Framework-Registry als Vokabular** (folgt aus H1: „statische Frameworks × Workloads"); heute nur YCSB verdrahtet, Rest gated. | Framework = statischer Layer über workload-type; 13-Kanon als Schlüsselraum. |
| **H6** | **Pareto-Front** (nicht Einzel-Objective). Blatt erweitert auf `tuple<property, time, objective_tag>` + Front-Menge je Schlüssel. | Auswertung liefert je Schlüssel die nicht-dominierte Menge + Objective-Tag; keine Mittelung über Objectives. |
| **H7** | **Alle 19 Slots strukturell intakt; Haupt-/Unter-Achsen auf EINEM Concept.** telemetry ist **Meta==System-Achse an der WURZEL** (nicht Organ-Slot). T1/T2/T10-Sonderstatus wird über die Layer-Hierarchie korrekt platziert, nicht durch Slot-Entfernung. | telemetry aus Slot T10 heraus zur Root-Visitor-Achse (s. §E-Phase 6); T1/T2 bleiben reguläre Layer mit Attributions-Constraint. |

---

## C. Befund: fehlende Unter-Achsen (wf_73129d50, code-verifiziert)

Zwei Klassen fehlender Unter-Achsen — **die zentrale punktuelle Refactoring-Masse**:

**(K) Klassifikations-Tag-Kollaps — betrifft JEDE der ~22 Haupt-Achsen.** Alle deklarierten `*_tag`-Structs
(PG1-3, PC1-3, NT1-3, AA1-7, HM1-4, PF1-3, CC1-2, SR1-3, TM1-3, VH1-3, IS1-3, SE1-3, HW1-4, IO1-3, MG1-3,
FT1-3, SA1-4, CT1-2, QS1-6, FS1-4) sind leere Tags, je Strategie genau EINER angehängt → das kartesische
Sub-Produkt ist **kollabiert**, kein Konsument der Tag-Typen. **Fix (punktuell):** je Tag-Dimension eine
echte `StaticAxisVariants`-Sub-Liste + kartesisches Kreuzprodukt in der Config-Set-Registry — Vorbild ist der
EINZIGE real gekreuzte Fall ISA×SIMD-Compat-Filter (`topic_hardware_config_set.hpp:41-59`).

**(S) Skalar/Struktur-Unter-Achsen — die RC-POD-Skalare + hartkodierte Konstanten.** Die 5 RC-POD-Felder
(`resource_controllable_tier.hpp:34-40`) sind erst **2/5 echt**:
- `pool_budget_bytes` (allocator) = **ECHT** (`observable_composed_search.hpp:41-42` reject bei Budget-Überschreitung).
- `inline_threshold_bytes` (value_handle) = **ECHT** (`axis_14_value_handle_observable.hpp:95-171` verzweigt inline vs. chain).
- `prefetch_distance` (prefetch) = **PARTIAL** (nur `family_id==1`, nur unter `COMDARE_MEASUREMENT_ON`).
- `batch_size` (cache_traversal) = **NO-OP** (keine Strategie liest es; Namens-Drift axis_03a↔03b, `resource_controllable_tier.hpp:38` vs. `profile_to_tree.hpp:84`).
- `thread_count` (concurrency) = **NO-OP** (`runtime_thread_count()` ohne Aufrufer, kein `std::thread/jthread`).

Dazu je Haupt-Achse hartkodierte Konstanten, die iterable Unter-Achsen sein müssten (search_algo:
hash-load-factor 0.7/skiplist kMaxLevel 16/btree-fanout; filter: Bloom-Größe; io: block-size; migration:
cutoff; sequence: FixedChunk).

---

## D. Befund: Utilization-Lücken + Zirkularität + Telemetry (wf_73129d50, code-verifiziert)

**Utilization-Lücken (16 Achsen mit honest-0/no-op — kein echter Effekt, weil ihr Interface nicht in anderen
Achsen angewandt wird).** Die **drei größten Hebel** schließen die meisten auf einmal:
- **(A) SIMD-Dispatch:** isa/simd (09/09b) als echten SIMD-Dispatch in ALLE `*_scan`-Kerne ziehen → schließt
  09b, isa, serialization, filter, layout gleichzeitig. (Heute: `Amd64Isa::simd_field_sum` SSE2-hartkodiert,
  liest die gewählte Extension nicht; jede Achse rollt eigenen skalaren Scan.)
- **(B) Allocator-Adapter:** axis_06 `as_std_allocator`/`StdAllocatorAdapter` in die 11 Pool-Organe + 4 Shapes
  statt `std::allocator` (`tier_to_organ_mapping.hpp:46-115`).
- **(C) Hot-Path-Hebung:** prefetch/concurrency/migration aus dem `COMDARE_MEASUREMENT_ON`-Fenster in den
  echten Hot-Path (concurrency-Lock sperrt heute globalen `std::mutex`, nicht die Datenstruktur; migration nur
  test-getrieben → `tier_moves` honest-0; filter-Probe gated `lookup` nicht).

**Zirkularität: der Achsen-Interface-Graph ist ein DAG — KEINE echten Include-Zyklen** (verifiziert:
memory_layout/allocator/cacheline haben 0 Aufwärts-Includes; die „node"-Treffer waren Verzeichnisnamen-
False-Positives). Scheinbarer 2-Zyklus node_type⇄migration ist tier-vermittelt (kein Include-Zyklus) →
so lassen. **Empfohlene Schichtung (alle neuen Kanten abwärts):**

```
L0 Hardware-Deskriptoren : cacheline, general_hardware(12), isa(09), simd(09b)
L1 Primitiv-Provider     : memory_layout(05), allocator(06)
L2 Form-Deskriptoren     : bst/btree/hash/skiplist_shape, sequence-growth
L3 Strukturen            : node_type(04), page_type(01), path_compression(02), value_handle(14), filter
L4 Zugriff/Policy        : search_algo(03a), cache_traversal(03b), io_dispatch, serialization(10),
                           prefetch(07), concurrency(08), migration, queuing_q1/q2
L5 System/Root           : telemetry(11) + Mess-Apparat  [Visitor über alles darunter, nur PULL]
```

**Telemetry-Fehlplatzierung (bindend für H7):** telemetry ist heute FÄLSCHLICH Organ-Slot **T10** in den 19
gleichrangigen Achsen (`observable_tier.hpp:47` `kV3AxisCount=19`, `:85` Slot T10; Peer-Organ
`search_algorithm_anatomy.hpp:183`), getrieben von unten per AUFWÄRTS-Push (`record_node_touch`, ABI:858/931).
Der reale Wurzel-Mess-Apparat ist das GETRENNTE `ObserverAggregate`/`c05_telemetry_engine`-Subsystem. Nach dem
Modell (Meta==System==Wurzel) muss telemetry **aus den 19 heraus** und über `axis_stats[19]` gehoben werden:
Visitor-Wurzel, die die 19 Slots per generischem `ObservableAxis`-Snapshot **pullt** — nie eine der 19
gemessenen Zeilen selbst, nie von unten bepusht (einzige latente Zyklus-Stelle). = ABI-/Schema-Bruch
(`kV3AxisCount`, `axis_stats[19]`), erlaubt per Direktive „ABI/Schema darf brechen, Messdaten nie löschen",
also mit Schema-Version, **zuletzt** (§E-Phase 6).

---

## E. Befund: HW-Prefetcher + Unter-Achsen-Design (wf_73129d50 + Deep-Research)

**Ist: vier entkoppelte, nicht ineinandergreifende Formen** — axis_07 SW-Prefetch (nur Container-Level, nur
`COMDARE_MEASUREMENT_ON`), cacheline sw_hint (nur Node-Basis, nicht Folge-Lines), hw_prefetcher MSR 0x1A4
(SLURM-Launcher, nie in C++ gelesen), RC prefetch_distance (nur family 1). **Größte Lücke: eytzinger** wirbt
mit „branch-free + prefetch" (`axis_03a_search_algo_eytzinger.hpp:70,76`), prefetcht aber NICHT — der
`2·k`-Voraus-Prefetch IST laut Khuong/Morin (JEA 2017) der gesamte Layout-Vorteil. Weitere 0-Prefetch:
BST/B-Tree/k-ary/Interpolation, cache_traversal, Node48/256-Folge-Lines, Allocator-Pool-Walk, value_handle-
Chain. Die vendored `ext/`-Paper prefetchen (HOT/CoCo/B2tree/Mahling), die ce-EIGENEN `libs/`-Achsen fast nie.

**SOTA-Mapping (Primärquellen → ce-Achse):** Khuong/Morin (eytzinger 2·k-voraus), Chen/Gibbons/Mowry SIGMOD
2001 (pB+-Tree Node-breit-Prefetch + Jump-Pointer), Masstree EuroSys 2012 (Node-Prefetch, Fanout gewählt),
Leis ART / Binna HOT (Kind-Header-Prefetch), Mahling DaMoN'25 (`ext/traversal/P25-Mahling/` SWPrefetcher-
Template + Coroutine-Group, direkt harvestbar).

**Design (modell-konform, zirkularitätsfrei): Prefetch-Grad als zwei getrennte Unter-Achsen:**
1. **Statische Unter-Achse = SW-Prefetch-SHAPE** (compile-time Layer): NTTP `PrefetchShape ∈ {none, current,
   distance-N, path-bundle-B}` als per-Organ compile-time-Mixin (Muster `cacheline_config.hpp`).
2. **Dynamische Unter-Achse = prefetch_distance** (+ hw_prefetcher): RC-POD-Skalar, Setter von „nur
   DistanceEstimator" auf jedes Shape-Mixin-Organ verbreitert; hw_prefetcher bleibt System-/Wurzel-Unter-Achse
   (MSR-Toggle um den Lauf).

Vier Zirkularitäts-Sperren: Primitive kennen nur duck-typed Store (kein Organ-Header); die Prefetch-Achse wird
selbst nicht prefetch-dekoriert; Treiber am realen Touch ko-lokalisieren (statt synthetischer
`descent_slot_for_`-Schätzung); statisch(Shape)/dynamisch(distance) fallen nie zusammen.

---

## F. Priorisierte Bau-Reihenfolge (punktuelle Refactorings, compile-time-strikt, zirkularitätsfrei)

Reihenfolge = L0→L5 (Provider vor Konsument; keine Stufe fügt eine Aufwärts-Kante hinzu). Jede Stufe ist EIN
Kadenz-Increment (Dossier → Selbst-Impl → adversarialer Review-Workflow + Backup → doppelt-literal g++-16 →
granulare Commits beide Remotes → CI strikt grün).

- **Phase 0 — Provider-Fundament (höchster Hebel):** (1) SIMD-Dispatch (Hebel A: simd an
  `isa::simd_field_sum` koppeln) — **✅ ce `8175c802`, CI grün 2026-07-10** (uint64-akkumuliert build-invariant
  über SSE2/AVX2/AVX512; adversarialer Re-Review wf_4e7c94c2). (2) general_hardware (12) verdrahten —
  **RE-DIAGNOSTIZIERT, s. §F.1** (die Audit-Rahmung „Organe lesen `cache_line_size` aus axis_12" ist widerlegt;
  design-gated Rest). (3) Allocator-Adapter (Hebel B) in die 11 Pools + 4 Shapes — **RE-DIAGNOSTIZIERT §F.2:
  COW-Wand, NEUE Architektur-Entscheidung (GO-pflichtig), kein punktuelles Refactoring**.
- **Phase 1 — Tag-Spreads materialisieren (K):** je Klassifikations-Tag eine echte `StaticAxisVariants`-Liste
  + kartesisches Kreuzprodukt (zuerst node/allocator/layout mit realem Store-Effekt).
- **Phase 2 — Prefetch-Unter-Achse (§E):** Shape-Mixin (compile-time) + verbreiterter distance-Setter
  (runtime) in die 6 Schnittlisten-Organe; Treiber in den echten Descent (eytzinger zuerst).
- **Phase 3 — restliche Hot-Path-Hebung (Hebel C):** concurrency-Lock auf die reale Struktur; migration-Move
  in den Mess-/Arbeits-Workload; filter-Probe als `lookup`-Short-Circuit.
- **Phase 4 — fehlende Skalar-/Struktur-Unter-Achsen (S):** hartkodierte Konstanten iterable machen;
  batch_size + thread_count von no-op auf echt (Namens-Drift auflösen).
- **Phase 5 — page_type materialisieren** (echtes Slot-Layout aus node/layout/allocator; setzt Phase 0 voraus).
- **Phase 6 — telemetry-Root-Umbau (§D):** telemetry aus Slot T10 zur Root-Visitor-Achse (nur PULL); ABI-/
  Schema-Bruch mit Version, **zuletzt**.

### §F.1 — Re-Diagnose Phase 0.2 „general_hardware (12) verdrahten" (2026-07-10, Deep-Research wf_7bba0921 + Verifikation)

Die Audit-Rahmung „memory_layout/node/allocator lesen `cache_line_size` aus axis_12 **statt eigener
cacheline-Unterachse**" ist **widerlegt** (Backup `docs/sessions/backups/20260710-phase02-general-hardware-design/BEFUND.md`;
beide adversarialen Kritiker NEEDS-REVISION inkl. golden-BLOCKER):

1. **`cache_line_size()` in den Layouts ist intrinsische Layout-Semantik, kein HW-Deskriptor:**
   `packed_bitmap→8`, `aos_strict→1`, sonst 64. Aus axis_12 (immer 64) gespeist würde das packed_bitmap/aos_strict
   **zerstören**. → keine „duplizierte HW-64" zum Dedup.
2. **golden-/Registry-mp_list-TABU (Ledger §0):** `CacheLineAlignedMemoryLayout` ist eine **konkrete Klasse** in
   `AllLayouts = mp_list<…>` (`axis_05_memory_layout_registry.hpp:36`). Templatisieren (naiver Weg) bräche die
   Permutations-Enumeration → `permutation_axes.xml`/golden. **Verboten.**
3. **axis_12 IST bereits korrekt konsumiert** — auf **Build-Variant-Ebene**, nicht in den Organ-Blättern:
   `build_variant_definition.hpp:66` liest `HW::cache_line_size()`/`numa_capable()` in den ABI-POD (die Thesis-
   Semantik „Cache-Line = plattform-fixer Kompilations-Input", 02_fundamentals.tex:97-104). Die Organe nutzen
   **korrekt** intrinsische Layout-Werte + den `CacheLineConfig`-NTTP (die permutierbare Mess-Achse = Thesis-Kern).
4. **Node** trägt zusätzlich `kLineBytes=64` (load-bearing Mess-Stride via `record_phys_bytes()`).

**Folgerung:** Phase 0.2 ist als „Organe lesen HW-Cacheline aus axis_12" **gegenstandslos** (bzw. TABU). Die einzige
noch fehlende axis_12-Organ-Konsumption ist **NUMA/Page → allocator** (thesis-motiviert AA5/NUMAlloc + Huge-Page/dTLB,
02_fundamentals.tex:51-53) — aber **Neu-Verdrahtung, nicht Literal-Ersatz**, und die konkreten Feld→Organ-Kanten
sind thesis-**under-specified** → **design-gated (GO-pflichtig, s. §H-Forks unten)**. **Nächster boundary-sauberer
Increment ist daher Phase 0.3 (Allocator-Adapter / Hebel B).**

### §F.2 — Re-Diagnose Phase 0.3 „Allocator-Adapter (Hebel B)" (2026-07-11, Implementierungs-Versuch)

Boundary-Verifikation ergab: KEIN mp_list-Templatizing (gut). ABER der Implementierungs-Versuch (Store besitzt
axis_06-Strategie, Vektoren via self-referential StdAllocatorAdapter, Copy/Move gelöscht = axis_04-ComposedStore-
Muster) **bricht** an `abi_adapter.hpp:2176`: die **Zwei-Phasen-Op-Messung** COW-**kopiert** das Such-Organ
(`saved_container_algorithm_.emplace(container_algorithm_)`). (1) gelöschte Copy/Move → COW nicht konstruierbar;
(2) rebindender Copy-Ctor → **Stats-Doppelzählung** bei jeder COW-Save → T6 korrumpiert. axis_04 darf Copy/Move
löschen (Node-Organ, NICHT COW-kopiert); der **Pool-Store im Such-Organ IST COW-kopiert** → das Muster ist
inapplikabel. **Sauberer Weg = Tier-Level-Strategie-Besitz** (Anatomie besitzt EINE axis_06-Instanz, in die
Pool-Store-Vektoren gefädelt; COW-Kopien teilen die externe Strategie → korrekte Stats) — mehrschichtiger Umbau
nahe der Mess-Maschinerie, berührt das Zwei-Phasen-Protokoll (Thesis-Kern) = **NEUE Architektur-Entscheidung
(Ledger §0: anhalten), GO-pflichtig.** Versuch vollständig revertiert (ce clean). Backup:
`docs/sessions/backups/20260711-phase03-allocator-adapter/DOSSIER.md §3b`.

**Meta-Befund (0.2 + 0.3 + Hebel-A-Rest, verifiziert):** KEINES der verbleibenden Phase-0-Utilization-Items ist
ein „punktuelles Refactoring":
- **0.2** general_hardware→Organe: golden/mp_list-TABU + `cache_line_size()` ist intrinsische Layout-Semantik
  (nicht HW-Deskriptor); axis_12 fließt bereits via Build-Variant. → gegenstandslos/design-gated.
- **0.3** Allocator-Adapter: bricht die COW-Zwei-Phasen-Messung; sauber nur mit Tier-Level-Strategie-Besitz
  (Mess-Maschinerie). → GO-pflichtig.
- **Hebel-A-Rest** *_scan-Routing über isa: die *_scan-Kerne sind bewusst **strided Mess-Kerne**, deren
  ZUGRIFFSMUSTER das Achsen-Signal IST (z.B. `scan_field_sum` round_up(record_size,64) = Layout-Differenzierung
  cache_line_aligned vs aos_strict). SIMD würde das Muster ändern → **Signal korrumpiert**. NICHT das saubere
  simd_field_sum-Muster (das war der kontiguierliche Sum der isa-EIGENEN Achse, Phase 0.1). → Fehldiagnose wie 0.2.
- **Sauber+GO-frei, aber HW-gated:** aarch64-NEON/riscv-RVV `simd_field_sum` (isa-eigene Achse, result-invariant
  wie 0.1) — aber auf x86-prod1 nur compile-only (kein ARM-Runtime, prod2-RMA ~Sep, INFRA-gated).

**Konsequenz:** Phase 0.1 (isa-eigener SIMD-Kern) war das EINZIGE sauber+verifizierbar+GO-freie Utilization-Item
auf x86-prod1. Der Rest ist Architektur-Arbeit (GO) oder HW-gated. Die Audit-Rahmung „punktuelle Refactorings"
trifft für Phase 0 nicht zu — Utilization-Schließen berührt Mess-Semantik/golden/COW und braucht Design-GO.

**Design-Forks (Thesis schweigt / TABU → GO-pflichtig, geparkt):** (F-A) Scope: nur Re-Diagnose vs. NUMA/Page→allocator
jetzt bauen. (F-B) welche Felder→welche Organe, compile-time-gated vs. Varianten-Auswahl. (F-C) Werteset-Divergenz der
**Mess-Achse** (Thesis KF-5 `{32,64,128}` vs. Code `{B64,B128,B256}`; Line-Größe vs. Knoten-Breite-in-Lines =
vermutlich zwei Unterachsen) — berührt golden/permutation → **TABU ohne explizites GO**.

**Parallel/übergreifend (das Messkurven-Typsystem selbst, Doc 20 §B–§D mit den H-Entscheidungen):** das
`tree<...>`-Typsystem als Layer-B+-Baum bauen (Haupt-/Unter-Achsen als Layer, Wurzel=System-Achsen mit
Visitor+Strategy, Prozess-Dimension als Builder-über-State, Decorator-über-Visitor-State-Log); die map-Ebenen
gemäß H1–H6 (framework×workload statisch + operation/sequence dynamisch, Beschaffenheit im Workload-Typ,
size=Cache-Regime-Key, op=std-C++23-Interface, Blatt=Pareto-Front). CoR-Filterkette (§C Doc 20) im
CacheEngineBuilder für die Generierungs-Kontrolle. 3-Varianten-Observer + komplementärer 4. Schritt (§D Doc 20)
als E4-XML-Messdimension.

---

## G. Offene/gated Punkte (unverändert)

Realer Kurven-Fit + Voll-Messlauf = **DATA-gated** (#156/#215, Cluster-Fenster, mehrtägig, nie aktiv pollen).
arm64/#276/gcc-15.3 = **INFRA-gated**. P/E-Core = **HW-gated** (prod2-RMA ~September). W/D/K-XML-Strecke +
Dataset-Wahrheitsquelle + Framework-Bib = **weitere EXTERN-Forks** (durch H1/H5 jetzt konzeptionell entschieden;
Umsetzung folgt der Bau-Reihenfolge). #256/#274-Matrix-Migration = eigene Strecke.

**Nächster konkreter Increment:** OFFEN — die drei Phase-0-Utilization-Items sind alle GO-pflichtig geworden
(Phase 0.1 ✅ ce `8175c802` CI-grün; Phase 0.2 §F.1 re-diagnostiziert = design-gated; Phase 0.3 §F.2 = COW-
Architektur-Entscheidung). Boundary-saubere Alternativen ohne GO: die **Tag-Spread-/Skalar-Unter-Achsen
(Phase 1/4)** oder Prefetch-Unter-Achse (Phase 2) prüfen — ODER User-GO für die Tier-Level-Allocator-Architektur
(0.3) bzw. die 0.2-Forks einholen. Empfehlung: nächste Phase erst Ist-verifizieren (wie 0.2/0.3 gezeigt: die
Audit-Rahmung ist optimistisch), bevor als „punktuell" eingeplant.
