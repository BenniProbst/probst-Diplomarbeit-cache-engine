# ANALYSE — Paper-Permutationen auf prod1 und prod2, durchgerechnet

**Datum:** 2026-08-07 · **Art:** Code-Review + Rechnung, kein Bau · **Status:** Vorlage an den Owner

**Code-Stand, gegen den gerechnet wurde:** `/home/comdare/wt-landung`, Branch `bau/flag-grammatik-v2-s1`,
HEAD `44397f580c53f46ebce794520c61b2ea9b391d50` (2026-08-07 15:08 UTC), **23 Commits hinter `origin/development`**.
Alle Fundstellen unten beziehen sich auf genau diesen Checkout.

**Maschinen-Stand:** prod1 **live gemessen** (diese Analyse lief auf prod1). prod2 **nicht erreichbar**
(Infra #207) — alle prod2-Angaben sind Doku-Belege und als solche gekennzeichnet.

---

## 0 · DIE ZAHLEN

### 0.1 Der Kern in einem Satz

Die Paper-Konfiguration schneidet den Bau-Raum **nicht um einen Faktor, sondern um drei Größenordnungen**:
von **524.288** (heutiger Profil-Stand) auf **132** real gebaute Binaries — **Faktor 3.972**.
Aber: **diese Kopplung ist im Code heute nicht verdrahtet.** Der Owner-Satz beschreibt einen Zielzustand.
Details in §2.4 und §5.

### 0.2 Bau-Mengen mit Rechenweg

| # | Größe | Rechenweg | Zahl | Beleg |
|---|---|---|---|---|
| A | Kompositions-Permutationen (Katalog-Referenz) | 2^17 × 1 | **131.072** | `source_catalog.hpp:139,169` |
| B | × System-Perms **heute im Profil** (2 opt × 2 simd) | 131.072 × 4 | **524.288** | `all_axes_golden.profile.xml:189-198` |
| C | × System-Perms **Doktrin-Ceiling** (4 opt × 3 simd) | 131.072 × 12 | **1.572.864** | `validate_profile.hpp:374-403` |
| D | davon auf **prod1** baubar **und** messbar | 131.072 × 12 | **1.572.864** | AVX-512 live vorhanden (§3.1) |
| E | davon auf **prod2** baubar **und** messbar | 131.072 × 8 | **1.048.576** | kein AVX-512 (§3.2) |
| F | auf **beiden** Maschinen vergleichbar (Schnittmenge) | 131.072 × 8 | **1.048.576** | — |
| G | **prod1-exklusiv** (die avx512-Perms) | 131.072 × 4 | **524.288** | — |

### 0.3 Paper-getriebene Mengen — die eigentliche Antwort

| # | Größe | Rechenweg | Zahl | Beleg |
|---|---|---|---|---|
| P1 | sota-Paper-Akten | gezählt | **33** | `algorithm_profiles/sota/*.profile.xml` |
| P2 | davon **distinkt** über die 7 kompositionsfähigen Achsen | gezählt | **30** | §1.3, 3 Kollisionspaare |
| P3 | Allocator-Akten | gezählt | **23** | `algorithm_profiles/allocators/` |
| P4 | **Paper-Repliken je 4 System-Perms** (heutiges Profil) | 33 × 4 | **132** | ← **die Antwort auf „alle Paper gegeneinander"** |
| P5 | Paper-Repliken, prod1 mit vollem Ceiling | 33 × 12 | **396** | |
| P6 | Paper-Repliken, prod2 mit seinem Ceiling | 33 × 8 | **264** | |
| P7 | Paper-**Kreuzraum** (kartesisch über paper-belegte Werte, 7 Achsen) | 6·4·2·5·7·4·5 | **33.600** | §1.4 |
| P8 | Paper-Kreuzraum × 4 System-Perms | 33.600 × 4 | **134.400** | |
| P9 | Paper × Allocator-Paper (falls die Allocator-Achse gekreuzt wird) | 33 × 23 | **759** | |
| P10 | **Paarvergleiche** bei 33 Papern gegeneinander | C(33,2) = 33·32/2 | **528** | §4.3 |

### 0.4 Was das an Zeit und Platz kostet

Bauzeit-Grundlage: **6,8 s/Binary auf prod1**, **11,3 s/Binary auf prod2** (1-Thread-Äquivalent, aus
GitLab-Job-Traces 306305/306306). 24 Worker auf prod1 laut OD-7.
Platz-Grundlage: **~0,437 MB/Binary** — **abgeleitet**, siehe Unsicherheit U-3.

| Menge | n | 1-Thread | bei 24 Workern | Platz |
|---|---:|---:|---:|---:|
| **P4 Paper-Repliken ×4** | 132 | 0,2 h | **~1 min** | **58 MB** |
| P5 Paper ×12 (prod1) | 396 | 0,7 h | ~2 min | 173 MB |
| P7 Paper-Kreuzraum | 33.600 | 63,5 h | 2,6 h | 14,3 GB |
| P8 Kreuzraum ×4 | 134.400 | 253,9 h | 10,6 h | 57,4 GB |
| B / D-2-Kandidat | 524.288 | 990,3 h | 41,3 h | **223,7 GB** |
| C / D-2-Kandidat | 1.572.864 | 2.971,0 h | 123,8 h | **671,2 GB** |

**Harte Platz-Schranke, live gemessen auf prod1:** die Bau-Partition `/` hat **4,8 GB frei** von 251 GB (99 % voll).
P4 und P5 passen mit großem Abstand. **P7 (14,3 GB) passt schon nicht mehr**, B und C erst recht nicht.

### 0.5 Verhältnis zu den vier D-2-Kandidaten

| D-2-Kandidat | Herkunft | prod1 baubar? | prod2 baubar? | Platz vs. 4,8 GB frei |
|---|---|---|---|---|
| 131.072 | Katalog-Referenz, 1 System-Perm | ja | ja | 56 GB — **nein** |
| 524.288 | 4 System-Perms (heutiges Profil) | ja | ja | 224 GB — **nein** |
| 1.572.864 | 12 System-Perms (Doktrin V7.4) | ja | **nein**, nur 1.048.576 | 671 GB — **nein** |
| 2.097.152 | + `line_size`-Faktor 4 | ja | nein | ~895 GB — **nein** |

**Ein fünfter Kandidat ist mir beim Lesen aufgefallen und war bisher nirgends gerechnet:** siehe §5.1 (Paper-Tier-Ebene).

---

## 1 · SCHRITT 1 — Die Paper-Konfiguration erhoben

### 1.1 Es sind zwei getrennte Paper-Systeme, nicht eines

Das ist die erste Weggabelung, und sie entscheidet, welche Zahl man rechnet.

| | System A — Vollprofile | System B — Achsen-Wrapper |
|---|---|---|
| Ort | `algorithm_profiles/sota/` (33), `allocators/` (23) | `axes/*/PAPER_REFERENCES.md` + `topics/*/*/` (21 Dateien) |
| Inhalt | je **eine vollständige** Algorithmus-Komposition | je **eine einzelne** Achsen-Ausprägung mit DOI |
| Zahl | **56 Akten = 56 distinkte Paper** (P01–P33, A01–A23, lückenlos, keine Duplikate) | ~142 Ausprägungen über 21 Achsen, davon 80 mit distinkter DOI |
| Wirkung auf die Menge | **schneidet ein** (56 Punkte statt 2^17) | **schneidet nicht ein** — das ist der Vollausbau selbst |

Verifiziert: `grep -o 'paper_ref="[^"]*"' sota/*.profile.xml | sort | uniq -c` → jede P-Nummer genau einmal;
analog `family_ref` für A01–A23.

**Für die Owner-Frage ist System A maßgeblich.** „Alle Paper gegeneinander simulieren" heißt: die 33 sota-Kompositionen
gegeneinander stellen. System B beschreibt nur, dass fast jede einzelne Achsen-Ausprägung irgendein Paper hinter sich hat —
daraus folgt keine Einschränkung, im Gegenteil.

**Nebenbefund (Doku-Drift):** alle 21 `PAPER_REFERENCES.md` und die autoritative Map verweisen auf
`Forschungsarbeiten/code/REPO_INVENTAR_FINAL.md` — **diese Datei existiert im Repo nicht**, weder als Datei noch als
Verzeichnis, auch nicht in der Historie. 21 Dateien zeigen ins Leere.

### 1.2 Struktur einer Paper-Akte

`sota/art.profile.xml` vollständig:

```xml
<comdare_algorithm_profile id="art" paper_ref="P01">
  <metadata><name>Adaptive Radix Tree</name><authors>Leis, Kemper, Neumann</authors>
            <year>2013</year><venue>ICDE</venue><doi>10.1109/ICDE.2013.6544812</doi></metadata>
  <axes>
    <page>DENSEBYTE_ART256</page>   <node>SPARSE_NODE4_ART</node>   <traversal>STANDARD</traversal>
    <value_handle>EXTERNAL</value_handle>  <concurrency>OPTIMISTIC_LOCK_COUPLING</concurrency>
    <allocator>MIMALLOC</allocator>  <prefetch>NONE</prefetch>  <telemetry>OFF</telemetry>
    <isa>X86_AVX2</isa>  <layout>CACHE_LINE_ALIGNED</layout>  <reclamation>NONE</reclamation>
  </axes>
</comdare_algorithm_profile>
```

Jede Akte belegt **alle 11 Achsen gleichzeitig** — sie ist ein vollständiger Punkt im Raum, kein Achsen-Vorschlag.
Das ist die entscheidende Eigenschaft: 33 Paper = **33 Punkte**, nicht 33 Faktoren.

### 1.3 33 Akten, aber nur 30 distinkte Kompositionen

Über die 7 Achsen, die im 17-Slot-Kompositionsraum liegen (`node, traversal, value_handle, concurrency,
allocator, prefetch, layout`), fallen **drei Paar-Kollisionen** an — selbst nachgezählt:

| kollidierende Paper | identisches Tupel |
|---|---|
| `khan_adaptive` (P23) ↔ `naderan_tahan` (P24) | BPLUS_NODE·STANDARD·EXTERNAL·SHARED_MUTEX·SYSTEM_MALLOC·ADAPTIVE_DISTANCE·CACHE_LINE_ALIGNED |
| `kuehn` (P28) ↔ `zhang_fgcs` (P26) | BPLUS_NODE·STANDARD·EXTERNAL·SHARED_MUTEX·JEMALLOC·ADAPTIVE_DISTANCE·CACHE_LINE_ALIGNED |
| `btreesareback` (P20) ↔ `to_stride` (P32) | BPLUS_NODE·RANGE_SCAN·EXTERNAL·OLC·JEMALLOC·ADAPTIVE_DISTANCE·CACHE_LINE_ALIGNED |

Über alle 11 Paper-Achsen sind es wieder 33 distinkte — die Paare trennen sich erst in `page`, `telemetry` oder `isa`,
und genau diese drei Achsen liegen **nicht** im Kompositionsraum (§2.1).

**Konsequenz für den Bau:** wer die 33 Paper als Kompositions-Binaries baut, erhält **30 verschiedene Binaries**;
drei Paare sind ununterscheidbar und würden auf dieselbe `binary_id` fallen.

### 1.4 Wie viele Werte je Achse schlagen die Paper zusammen vor?

Selbst gezählt über alle 33 sota-Akten (`grep -oP "(?<=<achse>)[^<]+" | sort -u | wc -l`):

| Paper-Achse | distinkte Werte | Werte |
|---|---:|---|
| `page` | 9 | B2TREE_PAGE, COCO_COMPACT, DENSEBYTE_ART256, HOT_MULTIBYTE, MASSTREE_INODE, STANDARD_HEAP, START_PAGE, SURF_PAGE, WORMHOLE_PAGE |
| `node` | 6 | BPLUS_NODE, HOT_BIT_NODE, MASSTREE_TRIE, SPARSE_NODE4_ART, SURF_TRIE, WORMHOLE_HASH |
| `concurrency` | 5 | HAZARD_POINTERS, OLC, RCU, SHARED_MUTEX, SINGLE_THREADED |
| `layout` | 5 | CACHE_LINE_ALIGNED, CACHE_OBLIVIOUS_VEB, NUMA_PINNED, PACKED_BITMAP, PRTART_MULTI_LEVEL |
| `allocator` | 7 | BUDDY, JEMALLOC, MIMALLOC, NUMALLOC, SLAB, SYSTEM_MALLOC, VAMPIR_NFP |
| `traversal` | 4 | HOT_PATH, RANGE_HOT_PATH, RANGE_SCAN, STANDARD |
| `prefetch` | 4 | ADAPTIVE_DISTANCE, FRACTAL, HIERARCHICAL, NONE |
| `telemetry` | 4 | ALL_NODES, LEAFONLY_SAMPLED, OFF, VAMPIR_OTF2 |
| `isa` | 4 | X86_AVX2, X86_AVX512, X86_BASELINE, X86_SSE42 |
| `reclamation` | 3 | HAZARD_POINTERS, NONE, RCU_GP |
| `value_handle` | 2 | EXTERNAL, INLINE |

Und für die 23 Allocator-Akten: `granularity` 7 · `numa` 2 · `thread_local` 2 · `fragmentation_strategy` 11 · `thread_safety` 4.

Daraus **P7** (§0.3): der kartesische Kreuzraum über die 7 kompositionsfähigen Achsen ist
6 · 4 · 2 · 5 · 7 · 4 · 5 = **33.600**. Das ist die Zahl, wenn man die Paper nicht als Punkte, sondern als
**Wertelieferanten** liest — jede Achse darf nur die Werte annehmen, die mindestens ein Paper vorschlägt.

---

## 2 · SCHRITT 2 — Die Kopplung Paper → Achse

### 2.1 Welche Achsen sind überhaupt paper-getrieben?

Der 17+1-Slot-Kompositionsraum (`axis_path_serialization.hpp:40-43`, `kCompositionAxisNames`,
identisch bestätigt in `source_catalog.hpp:95-113`):

| Slot | Achse | Von den sota-Papern belegt? |
|---|---|---|
| L00 | `search_algo` | teilweise — Paper-`traversal` (4 Werte), anderes Vokabular (§2.3) |
| L01 | `cache_traversal` | teilweise, dito |
| L02 | `mapping` | **nein — frei** |
| L03 | `path_compression` | **nein** in System A; in System B ja (axis_02, ART) |
| L04 | `node_type` | **ja** (6 Werte) |
| L05 | `memory_layout` | **ja** (5 Werte) |
| L06 | `allocator` | **ja** (7 Werte + 23 eigene Allocator-Akten) |
| L07 | `prefetch` | **ja** (4 Werte) |
| L08 | `concurrency` | **ja** (5 Werte) |
| L09 | `serialization` | **nein — frei** |
| L10 | `value_handle` | **ja** (2 Werte) |
| L11 | `index_organization` | **nein — frei** |
| L12 | `io_dispatch` | **nein — frei** |
| L13 | `migration_policy` | **nein — frei** |
| L14 | `filter` | **nein — frei** |
| L15 | `queuing_q1` | **nein — frei** |
| L16 | `queuing_q2` | **nein — frei** |
| L17 | `persistence_target` | **nein**, ohnehin auf 1 gepinnt (Owner-Entscheid Q-1 FALL B) |

**Bilanz: 7 von 17 Achsen sind paper-getrieben, 9 sind frei, 1 ist gepinnt.**
Das ist genau die Unterscheidung, nach der der Auftrag fragt — und sie trägt die Rechnung:
über die 9 freien Achsen sagt **kein** sota-Paper etwas. Sie müssen entweder gepinnt (Faktor 1) oder
eigenständig begründet variiert werden. Im heutigen `all_axes_golden` werden sie je 2-fach variiert,
also **ohne Paper-Bezug** — das ist der Löwenanteil der 2^17.

Rechnerisch: 2^9 = **512** der 131.072 Permutationen entstehen allein aus den freien Achsen.
Pinnt man sie auf die Baseline, bleiben 2^8 = 256 (bei je-2-Deckelung) bzw. der Paper-Kreuzraum P7 = 33.600
(bei vollem Paper-Inventar).

### 2.2 Drei Paper-Achsen liegen außerhalb des Kompositionsraums

`page`, `telemetry`, `isa` sind **keine** der 17 Slots:

- `page` → Build-Achse `axis_01_page_type` (6 Werte), Teil des bvset-Glieds, **nicht** binary_id-tragend
- `telemetry` → `axis_11_telemetry`, seit INC-2d kein Kompositions-Slot
- `isa` → explizit ausgebaut: `source_catalog.hpp:106-107` „index_organization (INC-2d: isa raus)"

Der Guard dafür ist strukturell, nicht konventionell — `profile_to_tree.hpp:105-110`:

> „STRUKTURELLER Organ-only-binary_id-Guard. Nur die 17 Organ-Kompositions-Achsen dürfen ein statisches
> (= binary_id-serialisiertes) Level erzeugen. Eine System-Achse (isa/simd_extension/page_type/telemetry) im
> permute_axes-Block darf die binary_id NICHT verunreinigen."

Das heißt: **die `isa`-Angabe der Paper (X86_AVX2, X86_AVX512, …) wird bei der Binary-Bildung ignoriert.**
Sie landet über die System-Achsen-Schicht im Sidecar. Für die Rechnung heißt das: die Paper-Angabe
„dieses Paper will AVX-512" (P27, P32) ist **kein** eigener Binary-Faktor, sondern eine System-Perm-Auswahl.

### 2.3 Zwei getrennte Vokabulare — der härteste Befund dieses Schritts

Die Paper-Akten und die `permute_axes` sprechen **nicht dieselbe Sprache**:

| | Paper-Akte (`sota/art.profile.xml:12`) | Profil (`all_axes_golden.profile.xml:41`) |
|---|---|---|
| `node_type` | `SPARSE_NODE4_ART` | `node4`, `node16` |
| Definitionsort | `abi/baustein_variants.hpp:100` (`tag[]` + `paper_ref[]="P01"`) | `axes/node/axis_04_node_type_registry.hpp:6-9` |

`baustein_variants.hpp` ist der **Baustein-/ABI-Katalog mit Paper-Bezug**; die Achsen-Registries sind die
**Kompositions-Achsen ohne Paper-Bezug**. Es gibt im Code keine Naht, die `SPARSE_NODE4_ART` auf `node4`
abbildet. Die Werte im Profil sind mechanisch gewählt — der XML-Kommentar sagt es selbst
(`all_axes_golden.profile.xml:33-34`):

> „je GENAU 2 konkrete `<value>` = **die ersten 2 Enabled-name()-Werte** (deckungsgleich `mp_take_c<...,2>`)"

**Die heutige Achsen-Belegung ist also keine Paper-Auswahl, sondern ein Listen-Präfix.**

### 2.4 Die Paper-Dimension existiert im Baum — wird im produktiven Lauf aber abgezogen

Der Baum-Adapter kennt eine eigene Paper-Ebene (`profile_to_tree.hpp:5`):

> „Paper/Tier-Dimension (oben): Fanout = base_tiers (jeder = ein gepinntes Paper-Tupel)."

Sie ist `is_static = true` (`profile_to_tree.hpp:44-50`), und `binary_count()` ist
„∏ der statischen Ebenen-Größen" (`experiment_tree.hpp:375-379`). Sie multipliziert also die Binary-Zahl.
**Bewiesen im Test, verbatim** (`tests/unit/test_kf9_experiment_tree.cpp:98-99`):

```cpp
// statisch: tier(2) x memory_layout(2) x cl_line(2) x cl_align(1) = 8 Binaries (die binary_id-Quelle).
check_eq("Adapter: binary_count (2x2x2x1)", tree2.binary_count(), std::size_t{8});
```

**Aber der produktive Lauf zieht sie ab** (`profile_runner.hpp:117-123`, `profile_run_entry.hpp:364-367`):

```cpp
[[nodiscard]] inline std::vector<ex::AxisLevel> drop_tier_level(std::vector<ex::AxisLevel> levels) {
    for (auto& l : levels) if (l.axis != "tier") out.push_back(std::move(l));
```

mit der Begründung: „so erzeugt der StaticBinaryView DENSELBEN binary_id-Raum wie die committete golden-Liste
(KEIN tier-Level)."

**Das ist die Antwort auf die Kernfrage des Auftrags.** Die 7 `base_tiers` in `all_axes_golden.profile.xml:24-30`
(prt_art, art, hot, masstree, surf, start, wormhole) erzeugen **keine** Binaries. Die Paper reisen als Metadaten mit,
steuern aber nichts. Die gebauten 131.072 Binaries sind eine paper-freie Achsen-Kartesik.

---

## 3 · SCHRITT 3 — Die System-Achsen gegen die Maschinen

### 3.1 prod1 — live gemessen

| Merkmal | Messwert | Quelle |
|---|---|---|
| CPU | AMD Ryzen 9 9950X3D, family 26 / model 68 / stepping 0 | `lscpu` |
| Kerne | 16 physisch / 32 logisch (SMT) | `lscpu` |
| **AVX-512** | **vorhanden**: avx512f, dq, cd, bw, vl, ifma, vbmi, vbmi2, vnni, bitalg, vpopcntdq, bf16, vp2intersect | `/proc/cpuinfo` Flags |
| L3 | **asymmetrisch, 2 Domänen** | `/sys/.../index3/size` |
| RAM | 60 GB | `free -g` |
| Platte `/` | 251 GB, **4,8 GB frei (99 % voll)** | `df -h` |
| Hugepages | 2 MB und 1 GB verfügbar, **0 allokiert** | `/proc/meminfo` |

**Zur L3-Asymmetrie — die Auftragsangabe war zu korrigieren.** Nicht „16 Kerne mit 32 MB, 16 mit 96 MB",
sondern **8 physische Kerne je Domäne** (die 16 sind logische CPUs):

| Domäne | logische CPUs | physische Kerne | L3 |
|---|---|---|---|
| CCD0 (V-Cache) | 0–7, 16–23 | **8** (core_id 0–7) | **98304K = 96 MB** |
| CCD1 | 8–15, 24–31 | **8** (core_id 8–15) | **32768K = 32 MB** |

Verifiziert über `topology/core_id` (cpu0 und cpu16 teilen core_id 0), `thread_siblings_list` (`0,16`)
und `shared_cpu_list` (`0-7,16-23`). Faktor 3 zwischen den Domänen.

### 3.2 prod2 — nur Doku, Maschine nicht erreichbar

| Merkmal | Doku-Aussage | Beleg |
|---|---|---|
| CPU | **Intel Core i9-12900K** (Alder Lake, family 6 / model 151 / stepping 2) | Live-`lscpu` vom 27.07. im Cluster-Repo; `machine_identity.hpp:189-201` + `static_assert:443` |
| Hybrid | **ja**, zwei PMU-Domänen `cpu_core`/`cpu_atom` | `20260807-DESIGN-pe-core-getrennte-messung.md:23` |
| **AVX-512** | **abwesend** — `static_assert(count_avx512_flags(...) == 0)`, `!has_flag("avx512f")` | `machine_simd_signature.hpp:121-123` |
| RAM | 64 GB (2×32 DDR5-4800) | `machine_identity.hpp:213,224-229` |
| Threads | Budget 24 | `bestandslog_document.hpp:242` |
| L3 | **nicht auffindbar** | — |

**Historie, die man kennen muss:** prod2 war ursprünglich ein i9-14900KS und wurde nach Instabilität
(Intel-13./14.-Gen-Degradation) am 27.07. auf den i9-12900K getauscht. Beide haben P/E-Cores und beide
kein nutzbares AVX-512 — für diese Rechnung ist das Ergebnis identisch.

**Nebenbefund (Namensdrift):** die Code-Struktur heißt weiterhin `Prod2RaptorLakeSignature` mit dem Kommentar
„Intel Core i9-14900KS (Raptor Lake)" (`machine_simd_signature.hpp:90`), obwohl die Maschine ein Alder-Lake-i9-12900K ist.
Inhaltlich (Flags) korrekt, im Namen veraltet. `machine_identity.hpp:248-251` warnt selbst davor.

### 3.3 Was daraus für die System-Permutationen folgt

Die drei System-Achsen (`abi/system_axis_order.hpp:42-46`, exakt drei, mit Abgangs-Wachen gegen die früheren fünf):

| System-Achse | Ausprägungen | prod1 | prod2 |
|---|---|---|---|
| `target_isa` | x86_64, aarch64 | x86_64 nativ (aarch64 nur Cross) | x86_64 nativ |
| `operating_system` | linux, windows, macos | linux | linux |
| `external_utils.simd` | no_extension, avx2, avx512 | **alle 3** | **nur 2** |

Dazu `opt_level` {O0, O1, O2, O3} (`validate_profile.hpp:374-403`; `Ofast` wird abgelehnt).

**Die Rechnung:**

- **Doktrin-Ceiling:** 4 opt × 3 simd = **12** — auf prod1 vollständig baubar **und** messbar
- **prod2:** 4 opt × 2 simd = **8**; die 4 avx512-Perms sind auf prod2 kein Ergebnis, sondern ein Fehlschlag
- **heutiges Profil:** 2 opt × 2 simd = **4** (`all_axes_golden.profile.xml:189-198`) — die 12-Perm-Doktrin
  ist **nicht** nachgezogen, und der XML-Kommentar nennt den Grund selbst: „avx512 nicht universell"
- **auf beiden vergleichbar: 8.** Vier System-Perms sind prod1-exklusiv.

**Wichtig für die Gesamtzahl** (`all_axes_golden.profile.xml:183-186`, verbatim):

> „system_config → **binary_id-NEUTRAL**: multipliziert NUR die BAU-Matrix/Sidecar (build_version +opt=/+ext=),
> NIE N=2^17 (binary_id bleibt die 17-Organ-Kartesik)."

Die System-Achsen erzeugen also **mehr Artefakte, aber keine neuen binary_ids**. 524.288 gebaute `.so` tragen
131.072 distinkte binary_ids. Beim Vergleichen ist das der Unterschied zwischen „dieselbe Komposition, anders übersetzt"
und „andere Komposition".

### 3.4 Die Build-Achsen (bvset) sind etwas anderes als die System-Achsen

Häufige Verwechslung, deshalb explizit: `page_type` (6), `simd_extension` (8), `general_hardware` (3)
sind **build-only-Achsen** (`registry_to_axis_levels.hpp:6-9`), getrennt registriert von den System-Achsen.
Deutlichster Beleg: die System-Achse `external_utils.simd` hat **3** Werte, die Build-Achse `simd_extension`
hat **8** (inkl. NEON, SVE2, RVV, CUDA-GH200). Ähnlicher Name, andere Registry, andere Kardinalität.

Auf x86_64 sind von den 8 `simd_extension`-Werten real nur no_extension, SSE2, AVX2, AVX512 baubar —
NEON/SVE2 (ARM), RVV (RISC-V) und CUDA-GH200 fallen für beide Maschinen aus. **Auf prod1 also 4, auf prod2 3.**

### 3.5 Die L3-Asymmetrie berührt die Binary-Zahl nicht — die Mess-Zahl schon

Die Frage aus dem Auftrag: berührt der 96/32-MB-Split die Permutationszahl?

**Antwort: nein für den Bau, ja für die Messung.** Auf welchem CCD ein Prozess läuft, ist eine Frage des
Pinnings zur Laufzeit, nicht der Übersetzung. Im Achsen-Modell entspricht das einer **dynamischen Ebene**
(wie `concurrency.thread_count`), und für die gilt (`profile_to_tree.hpp:127-131`):

> „Die binary_id wird davon NICHT berührt (is_static=false → der Baum filtert sie via static_filter() raus)"

Also: **× 1 auf die Binaries, × 2 auf die Messläufe**, wenn man beide Domänen getrennt misst.
Für eine **Cache**-Engine halte ich das für die interessanteste kostenlose Achse im ganzen Aufbau —
Faktor 3 in der L3-Größe bei identischer Mikroarchitektur, ohne eine einzige zusätzliche Binary.
Sie ist heute nicht konfiguriert (keine solche dynamische Ebene im Profil).

---

## 4 · SCHRITT 4 — Die Rechnung

### 4.1 Drei Lesarten von „alle Paper gegeneinander"

Der Auftrag lässt drei Lesarten zu; sie unterscheiden sich um vier Größenordnungen. Ich rechne alle drei.

**Lesart 1 — Paper als Punkte (Replikation).** Jedes Paper wird genau so gebaut, wie es sich selbst beschreibt.

```
33 Paper × 4 System-Perms (heute)        =    132 Binaries    ← empfohlen
33 Paper × 12 (prod1-Ceiling)            =    396
33 Paper ×  8 (prod2-Ceiling)            =    264
davon distinkt (3 Kollisionspaare)       =    30 × Perms
```

**Lesart 2 — Paper als Wertelieferanten (Kreuzraum).** Jede Achse darf die Werte annehmen, die mindestens
ein Paper vorschlägt; die 9 freien Achsen bleiben gepinnt.

```
node 6 × traversal 4 × value_handle 2 × concurrency 5 × allocator 7 × prefetch 4 × layout 5
                                          = 33.600 Binaries
× 4 System-Perms                          = 134.400
```

**Lesart 3 — heutiger Profil-Stand (paper-frei).** Die 17 Achsen je 2, Werte mechanisch als Listen-Präfix.

```
2^17 × 4 System-Perms                     = 524.288 Binaries
```

**Der Einschränkungsfaktor, nach dem der Owner fragt: 524.288 / 132 = 3.972.**

### 4.2 Baubar gegen sinnvoll messbar

Die im Auftrag verlangte Trennung, für alle drei Lesarten:

| | baubar prod1 | baubar prod2 | sinnvoll messbar |
|---|---:|---:|---:|
| Lesart 1 (×4) | 132 | 132 | **132** |
| Lesart 1 (voller Ceiling) | 396 | 264 | 264 gemeinsam + 132 prod1-exklusiv |
| Lesart 2 (×4) | 134.400 | 134.400 | 134.400 |
| Lesart 3 (×4) | 524.288 | 524.288 | 524.288 |
| Lesart 3 (Ceiling 12) | 1.572.864 | **1.048.576** | 1.048.576 gemeinsam |

„Baubar" und „messbar" fallen hier fast überall zusammen — mit **einer** Ausnahme, und die ist wichtig:
**die 4 avx512-System-Perms sind auf prod2 weder baubar noch messbar.** Jeder Cross-Maschinen-Vergleich,
der avx512 einschließt, hat auf prod2 kein Gegenstück. Das ist genau der Grund, den der XML-Kommentar nennt.

Die zweite Trennung ist die Platte: **baubar ≠ lagerbar.** Mit 4,8 GB frei auf `/` sind Lesart 1
(58–173 MB) und nichts darüber hinaus lokal haltbar. Lesart 2 braucht 14,3 GB, Lesart 3 224 GB.
Ohne den MinIO-Abfluss (§65-Doktrin: „lokaler Fußabdruck der Baumaschine → gegen null") ist alles ab
Lesart 2 heute nicht baubar — unabhängig von CPU und Zeit.

### 4.3 Die Zahl im compare-Modus

Der Owner nennt `compare` als Minimum. Hier ist der Befund unbequem:

**`compare` vergleicht heute nichts.** `run_methodology_registry.hpp:97` definiert ihn, und
`run_methodology_registry.hpp:144-148` nagelt per `static_assert` fest:

> „compare = {Release, misst NICHT, parallel} (Etikett-Stand, Vollzug D2)"

mit der Erläuterung (`:26-30`): „seine Build-Semantik ist heute bewusst release-GLEICH […]. Der modus-SPEZIFISCHE
Ablauf (Replay-Vergleich statt Messen) ist das Nach-Trigger-Paket **D2** — bis dahin ist compare ein wählbares,
validierbares ETIKETT."

**Für die Zahl heißt das: `compare` fügt der Bau-Menge nichts hinzu und zieht nichts ab.** Die Bau-Zahl im
compare-Modus ist identisch zur Zahl im release-Modus. Da compare zudem `measurement_on = false` trägt,
misst er nicht einmal — die Messwerte müssen aus einem vorherigen `measure`-Lauf stammen
(Ablauf-Ordnung `measure → compare → release`, Owner-Entscheid O-A).

**Wie viele Vergleiche entstehen** (die implementierten Vergleichswege, nicht der Modus):

| Weg | Kardinalität | bei 33 Papern | Beleg |
|---|---|---:|---|
| `CompareEngineCommand` | genau 2 (Welch-t-Test) | **528** Paare = C(33,2) | `compare_engine_command.hpp:36,45` |
| `multi_compare_against_baseline` | 1 Baseline + N | **32** Vergleiche (Holm-Bonferroni) | `multi_compare.hpp:57` |
| `pareto_rank_binaries` | N-zu-N-Dominanzfront | **1** Front über 33 | `best_binary_selector.hpp:289` |

Für „alle Paper gegeneinander" ist `multi_compare_against_baseline` der passende Weg (32 Vergleiche gegen PRT-ART
als Baseline, mit FWER-Korrektur) — `CompareEngineCommand` mit 528 ungekorrigierten Paartests hätte ein
Mehrfachtest-Problem.

### 4.4 Meine Empfehlung

**Lesart 1 mit 132 Binaries.** Begründung, kurz:

1. Sie beantwortet die Frage, die die Thesis stellt („wie schlagen sich die SOTA-Verfahren gegeneinander"),
   und keine andere.
2. Sie ist die einzige Menge, die heute **vollständig lokal** gebaut und gelagert werden kann (58 MB gegen 4,8 GB frei).
3. Sie kostet **rund eine Minute** Bauzeit bei 24 Workern — der Lauf ist wiederholbar, statt ein Einmal-Ereignis
   über 41 Stunden zu sein.
4. Sie ist auf **beiden** Maschinen identisch baubar (kein avx512 in den 4 heutigen System-Perms).
5. Sie lässt sich additiv erweitern: 132 → 396 (prod1-Ceiling) → 759 (× Allocator-Paper) → 33.600 (Kreuzraum),
   ohne dass eine Stufe die vorige entwertet.

Der Preis: sie beantwortet **nicht** die Frage „welche Achsen-Kombination ist die beste" — dafür braucht es
Lesart 2 oder 3. Wenn die Thesis beide Fragen stellt, sind es zwei Läufe, nicht einer.

---

## 5 · BEFUNDE, die über die Rechnung hinausgehen

### 5.1 Ein fünfter D-2-Kandidat: 917.504

Die vier bekannten Kandidaten (131.072 / 524.288 / 1.572.864 / 2.097.152) rechnen die Paper-Tier-Ebene
alle **nicht** mit. Der Baum tut es (§2.4, testbelegt). Rechnet man sie mit:

```
7 base_tiers × 2^17 = 917.504     (× System-Perms entsprechend mehr)
```

Heute ist die Ebene im produktiven Pfad per `drop_tier_level` abgezogen, die Zahl also **inaktiv**.
Sie wird aktiv, sobald jemand den Bau über `build_axis_levels` statt `build_profile_basis_levels` fährt.
Das ist kein hypothetisches Risiko: beide Funktionen liegen nebeneinander in derselben Datei und
unterscheiden sich in einem Aufruf.

### 5.2 Der XML-Kommentar und der Code widersprechen sich in der Zahl

`all_axes_golden.profile.xml:33-34` und `:57-59` sagen „2^17 = 131.072" und „Der Raum bleibt damit 2^17 = 131072".
Für den produktiven Lauf stimmt das. Für `build_axis_levels` mit denselben 7 `base_tiers` stimmt es nicht
(dann 917.504). Der Kommentar sagt nicht, welcher der beiden Wege gemeint ist.

### 5.3 Die 12-Perm-Doktrin ist auf prod2 nicht erfüllbar

Nicht „nicht nachgezogen", sondern **strukturell unerfüllbar**: 4 der 12 verlangen AVX-512, und prod2 hat es nicht.
Wer die 12 als Ziel setzt, setzt implizit „prod1-only" für ein Drittel des Laufs. Das ist eine Entscheidung,
keine Konfigurationslücke.

---

## 6 · WAS DIESE RECHNUNG NICHT BEANTWORTET

1. **Ob die 33 Paper überhaupt als Binaries baubar sind.** Ich habe gezählt, was die Akten deklarieren, und
   geprüft, wo die Werte definiert sind — aber nicht gebaut. Die Paper-Werte (`SPARSE_NODE4_ART`) und die
   Registry-Werte (`node4`) sind verschiedene Vokabulare (§2.3); ob und wie eine Paper-Akte in eine Binary
   übersetzt wird, konnte ich am Code **nicht** abschließend klären. **Das ist die größte Lücke dieser Analyse.**
   Solange sie offen ist, ist P4=132 eine Zielzahl, keine Vollzugszahl.
2. **Ob 12 von 33 Papern reichen.** Nur 12 der 33 sota-Paper sind real in `ext/` gevendort (Rest „DEFERRED"/
   „PENDING" laut `ext/traversal/REPOS_OVERVIEW.md:4`). Ob die übrigen 21 als Nachbau oder gar nicht antreten,
   ist eine inhaltliche Frage der Thesis, keine Rechenfrage.
3. **Welche Messungen aussagekräftig sind.** Ich habe Binaries gezählt, nicht Messläufe. Die Multiplikatoren
   Workload (21 `load_profiles`), Wiederholungen (Default 3), Thread-Counts und L3-Domäne (§3.5) kommen
   obendrauf und sind hier **nicht** eingerechnet.
4. **Ob die Bauzeit von 6,8 s/Binary bei 132 Binaries gilt.** Sie stammt aus 4096er-Slices; bei 132 Binaries
   dominieren Anlaufkosten, die dort untergehen.
5. **Den Platzbedarf belastbar.** Siehe U-3.
6. **Die Frage, ob `compare` bis zur Abgabe gebaut wird.** Paket D2 ist ungebaut; ich habe nur festgestellt,
   dass es das ist.

---

## 7 · WO ICH UNSICHER BIN

**U-1 · Die Paper→Binary-Naht (schwerwiegend).** Ich konnte am Code nicht belegen, dass eine sota-Akte in eine
baubare Komposition übersetzt wird. Die Indizien sprechen dagegen: getrennte Vokabulare (§2.3), `drop_tier_level`
im produktiven Pfad (§2.4), und `permute_axes`-Werte, die als Listen-Präfix statt als Paper-Auswahl gewählt sind.
**Meine Annahme für P4/P5/P6: die Naht existiert oder wird gebaut.** Wenn sie nicht existiert, ist die ehrliche
Antwort auf die Owner-Frage nicht „132", sondern „heute 0 — die Paper steuern den Bau nicht". Das ist die eine
Stelle, an der ich vor dem Bau eine Gegenprüfung empfehle.

**U-2 · Die Abbildung Paper-Achse → Kompositions-Slot.** Ich habe `node`→`node_type`, `layout`→`memory_layout`,
`traversal`→`search_algo`/`cache_traversal` nach Namens- und Werteähnlichkeit zugeordnet, **nicht** nach einer
Naht im Code — eine solche habe ich nicht gefunden. Besonders `traversal` ist unklar: die Werte (STANDARD,
HOT_PATH, RANGE_SCAN) passen zu keiner der beiden Registries sauber. **P7 = 33.600 hängt an dieser Zuordnung**
und ist entsprechend weicher als die anderen Zahlen.

**U-3 · Platz je Binary (0,437 MB).** Abgeleitet aus der Doku-Schätzung „~224 GB für 524.288 DLLs"
(`2026-07-20-SESSION-POST-V3-REGISTER-vollstaendig.md:28`), die sich selbst per `~` als Näherung ausweist.
Dass meine Rückrechnung 223,7 GB ergibt, ist **keine** Bestätigung — es ist dieselbe Zahl rückwärts.
**Es gibt keinen gemessenen `.so`-Größenwert im Repo** (0 Treffer auf `so_size`). Alle Platz-Zahlen in §0.4
stehen und fallen damit. Eine echte Messung wäre: eine Binary bauen, `ls -l`.

**U-4 · prod2 vollständig.** Kernzahl und L3 sind nirgends dokumentiert; ich habe nur das Thread-Budget 24.
Die öffentlich bekannte 12900K-Aufteilung (8P+8E) habe ich **bewusst nicht** eingesetzt, weil sie kein Repo-Beleg ist.
Für die Rechnung ist nur „kein AVX-512" tragend, und das ist per `static_assert` belegt.

**U-5 · Der Branch.** Gerechnet gegen `bau/flag-grammatik-v2-s1`, 23 Commits hinter `origin/development`.
Ich habe nicht geprüft, ob einer der 23 eine der Eingangszahlen bewegt. Die tragenden Konstanten
(2^17, 3 System-Achsen, 4 opt-Level, 3 simd) sind `static_assert`-verankert und ändern sich nicht beiläufig —
aber die `permute_axes` eines XML schon.

**U-6 · Die 3 Paper-Kollisionen.** Ob zwei Paper mit identischem 7-Tupel wirklich dieselbe Binary ergeben,
hängt an U-1. Falls die Naht auch `page`/`telemetry` einbezieht (die außerhalb der 17 liegen, aber die Paper
unterscheiden), wären es 33 statt 30.

---

## 8 · FUNDSTELLEN-VERZEICHNIS

Alle Pfade relativ zu `/home/comdare/wt-landung`, Branch `bau/flag-grammatik-v2-s1` @ `44397f58`.

| Aussage | Fundstelle |
|---|---|
| `FullSourceCatalog` = 2^17 | `libs/cache_engine/profile_facade/source_catalog.hpp:139` |
| `static_assert(... == 131072u)` | `libs/cache_engine/profile_facade/source_catalog.hpp:169` |
| `golden_320_catalog` = 4·4·5·4 | `libs/cache_engine/profile_facade/source_catalog.hpp:144` |
| 18 Kompositions-Achsen, Reihenfolge | `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:40-43` |
| 3 System-Achsen, Abgangs-Wachen | `libs/cache_engine/include/cache_engine/abi/system_axis_order.hpp:42-46,102-110` |
| simd = 3 Werte | `libs/cache_engine/include/cache_engine/measurement/simd_sub_axis.hpp:65-98` |
| opt_level = 4, Ofast REJECT | `libs/cache_engine/profile_facade/validate_profile.hpp:374-403` |
| heutige System-Perms = 2×2 | `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:189-198` |
| „system_config → binary_id-NEUTRAL" | `.../all_axes_golden.profile.xml:183-186` |
| 7 base_tiers | `.../all_axes_golden.profile.xml:24-30` |
| „die ersten 2 Enabled-name()-Werte" | `.../all_axes_golden.profile.xml:33-34` |
| Paper-Tier-Dimension im Baum | `libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:5,44-50` |
| `binary_count()` = ∏ statische Ebenen | `libs/cache_engine/builder/experiment_tree/experiment_tree.hpp:375-379` |
| **Test: tier multipliziert (8 = 2×2×2×1)** | `tests/unit/test_kf9_experiment_tree.cpp:98-99` |
| `drop_tier_level` im produktiven Lauf | `libs/cache_engine/profile_facade/profile_runner.hpp:117-123` |
| Organ-only-binary_id-Guard | `libs/cache_engine/builder/experiment_tree/profile_to_tree.hpp:105-110` |
| Paper-Vokabular (`SPARSE_NODE4_ART`) | `libs/cache_engine/include/cache_engine/abi/baustein_variants.hpp:99-103` |
| Registry-Vokabular (`node4`…) | `libs/cache_engine/axes/node/axis_04_node_type_registry.hpp:6-9` |
| `compare` = Etikett, Vollzug D2 | `libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp:26-30,144-148` |
| `CompareEngineCommand` = genau 2 | `libs/cache_engine/builder/commands/compare_engine_command.hpp:36,45` |
| `multi_compare_against_baseline` | `libs/cache_engine/builder/commands/multi_compare.hpp:57` |
| `pareto_rank_binaries` | `libs/cache_engine/builder/best_binary_selector/best_binary_selector.hpp:289-291` |
| prod2 ohne AVX-512 | `libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp:121-123` |
| prod2 = i9-12900K | `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp:189-201,443` |
| build-only-Achsen (bvset) | `libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:6-9` |
| Bauzeit 6,8 s / 11,3 s je Binary | `wt-super-landung/docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md:2569-2574` |
| „~24h/~224GB" (Schätzung) | `wt-super-landung/docs/sessions/2026-07-20-SESSION-POST-V3-REGISTER-vollstaendig.md:28` |
| prod1 L3-Asymmetrie (Doku) | `wt-super-landung/docs/plaene/20260807-DESIGN-pe-core-getrennte-messung.md:101-112` |
| prod2 unerreichbar, Infra #207 | `wt-super-landung/docs/plaene/20260807-DESIGN-pe-core-getrennte-messung.md:129-134` |
