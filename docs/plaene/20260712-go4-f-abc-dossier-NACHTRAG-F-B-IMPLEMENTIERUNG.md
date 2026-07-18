# NACHTRAG §F-B — Implementierung der NUMA/Page→allocator-Unterachse (2026-07-12)

> **Bezug:** DOSSIER.md (gleicher Ordner), §1/F-B + §2.1/§2.2 + §5. **User-Entscheid** (nach F-C-GO):
> „zusätzlich F-B, damit wir als Permutation und dokumentiert den Effekt-Unterschied bewerten können."
> **Additiver Nachtrag** — DOSSIER.md bleibt unverändert (Backups strikt additiv).
> Basis-Pfad `ce/` = `Code/external/comdare-cache-engine/` (aufgesetzt auf 0a1a2e3b, nach F-C a08a60ca).

## 1 Was gebaut wurde (Design exakt wie im Dossier vorentschieden)

F-B = die im Dossier §1/F-B beschriebene **einzige legitime, noch fehlende axis_12-Organ-Konsumption**:
die drei general_hardware-Eigenschaften `numa_capable` / `memory_page_size` / `huge_page_capable`
(`ce/libs/cache_engine/topics/hardware/axis_12_general_hardware/axis_12_general_hardware_x86_64.hpp:33-37`)
fließen als **Compile-Time-Inputs NUR an die Allocator-Kante** (axis_06). Mechanik = exakt das
node_width-Muster (F-C/C2, ce a08a60ca):

| Baustein | Datei (ce/) | Inhalt |
|---|---|---|
| Unterachsen-Config | `libs/cache_engine/axes/alloc/alloc_hw_config.hpp` (NEU) | NTTP-Config `AllocHwConfig{numa_node, page}`; Wertesets `alloc_hw.numa_node {auto,0,1}` + `alloc_hw.page {4k,2m}`; Concept `AllocHwConfigurable`; CRTP-Mixin `AllocHwAware<Cfg>`; **HW-Gate** `gate_alloc_hw_for<HW>()` + `alloc_hw_page_bytes_for<HW>()` (strukturelles Concept `AllocHwPlatformProfile` über die 3 axis_12-Properties) |
| Trage-Punkt | `libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp` | dritter defaulted NTTP `AllocHwCfg = {}` + Erbe `AllocHwAware<Cfg>` — Blätter bleiben konkrete Klassen, Registry-mp_list unberührt (KF-5-/node_width-Muster) |
| Konsum 1 (NUMA) | `libs/cache_engine/axes/alloc/axis_06_allocator_numalloc.hpp` | Körper → CRTP-Body-Template `NUMAllocAllocatorBody<Derived, HwCfg>`; **`kDefaultNumaNode = -1`-Hartcode abgelöst** durch den Compile-Time-Parameter (`AllocHwAware<HwCfg>::alloc_hw_numa_node()`); Registry-Blatt `NUMAllocAllocator` = konkrete Klasse mit Default Auto(−1) → byte-identisch |
| Konsum 2 (Page) | `libs/cache_engine/axes/alloc/axis_06_allocator_pool_resource.hpp` | Körper → `PoolResourceAllocatorBody<Derived, HwCfg>`; nicht-nativer Page-Hint setzt compile-time die `pmr::pool_options` (`largest_required_pool_block` = Page-Bytes; beobachtbar via neuem Getter `pool_options_in_effect()`); Default Native → default-konstruierter Pool, byte-identisch |
| Profil-Plumbing | `xml_config_parser.hpp/.cpp` (+`alloc_numa_nodes`/`alloc_pages`), `profile_to_tree.hpp` (ref=="alloc_hw" → statische Sub-Ebenen), `validate_profile.hpp` (Sonderzweig-Warnung), `apps/catalog_codegen_tool/main.cpp` (harter Reject wie cacheline/node_width), `thesis_profiles/SCHEMA.md` (Tabellenzeile) | exakt der node_width-Pfad |
| Studien-Profil | `libs/cache_engine/algorithm_profiles/thesis_profiles/fb_numa_page_study.profile.xml` (NEU) | das **EINZIGE** Profil, das `alloc_hw` aktiviert (allocator: SYSTEM_MALLOC+NUMALLOC × numa_node 3 × page 2) |
| Test | `tests/unit/test_fb_alloc_hw_subaxis.cpp` (NEU, ctest-registriert) | Wertraum + HW-Gate + Neutralität + realer Konsum (s.u.) |

## 2 Der dokumentierte Permutations-Mess-Knopf (Zweck „Effekt-Unterschied bewerten")

- `alloc_hw.numa_node = auto` ist die **Baseline** (identisch zum bisherigen harten −1/kernel-Default);
  `0`/`1` sind die Node-Pins. Die Effekt-Differenz *auto vs. gepinnt* ist genau die Größe, die die
  Permutation im Messlauf sichtbar macht.
- `alloc_hw.page = 4k` = Basis-Page der Plattform (`HW::memory_page_size()`, heute 4096 auf allen drei
  Profilen); `2m` = Huge-Page-Hint (dTLB-Reach-Motivation, thesis 02_fundamentals:50-53, FF3-dTLB-Misses).
- **Anti-Phantom-Beweis** (Test, wörtlich grün): unterschiedlicher Parameter → unterschiedliche
  Konfiguration/Verhalten — NUMAlloc `numa_node()` −1/0/1 (derselbe Member geht in
  `numalloc_alloc(bytes, alignment, node)`); Pool `pool_options_in_effect().largest_required_pool_block`
  4096 (Default) vs. 2097152 (2m-Variante) auf libstdc++.
- **honest-0 beseitigt:** `memory_page_size`/`huge_page_capable` haben mit `alloc_hw_page_bytes_for<HW>()`
  bzw. dem Gate ihren ERSTEN Konsumenten (Dossier §2.1, letzte Zeile, war grep-belegt „NIRGENDS konsumiert").

## 3 HW-Gate-Grenze (ehrlich, bleibt bestehen)

- **Der NUMA-EFFEKT bleibt Multi-Socket-HW-gated (~Sep):** auf Single-Socket-prod1 ist die
  Durchsatz-/Latenz-Differenz auto-vs-gepinnt erwartbar klein/null (Dossier §3 „Mess-Aussagekraft",
  F-B-Spalte). Das ist OK und beabsichtigt: der KNOPF existiert, ist profil-permutierbar und dokumentiert;
  die Effekt-Bewertung erfolgt mit der Multi-Socket-Kampagne (P/E-Core/prod2).
- **Compile-time-Gating wirkt heute schon:** `gate_alloc_hw_for<GenericHardwareProfile>` (numa_capable=false,
  huge_page_capable=false) kompiliert Pinning und 2m-Hint nachweislich weg (static_asserts im Test);
  X86_64/Aarch64 (beide capable) behalten die Anforderung.
- **Vendor-Gate:** im aktuellen Build ist `COMDARE_AXIS_06_USE_NUMALLOC=0` (Vendor nicht gelinkt) → NUMAlloc
  fällt auf `portable_aligned_alloc` zurück; die Node-Bindung (Member/Getter) ist trotzdem konfiguriert und
  geht bei aktiviertem Vendor unverändert in `numalloc_alloc`. Kein Behelfsweg — das ist das vorbestehende
  ENABLE&&HAVE-Vendor-Schema (CMakeLists.txt:745-748).
- **Kein mmap-Pfad verdrahtet:** außer dem std::pmr-Pool besitzt kein eigener Allocator-Wrapper heute einen
  mmap-/Huge-Page-Systempfad (MAP_HUGETLB); ein solcher wäre NEUES Organ-Verhalten (nicht Teil von F-B =
  Feld-Verdrahtung) und bliebe ein eigener, GO-pflichtiger Increment.

## 4 Neutralität + TABU (wörtlich verifiziert)

- OHNE Profil-Aktivierung entsteht KEINE `alloc_hw.*`-Ebene → binary_ids byte-identisch
  (Test P0/P1: deklariert-aber-inaktiv ⇒ ids identisch; P2 aktiviert ⇒ ×6 mit Segmenten
  `alloc_hw.numa_node=`/`alloc_hw.page=`). golden-320 trägt 0× `alloc_hw` (TABU-grep).
- `golden_fullpilot_320_binary_ids.txt` · `permutation_axes.xml` · POD-1416 · ABI-MAJOR-4 ·
  m3v2-/m3_smoke_coverage-Profile: **byte-unberührt** (git status/diff-Beleg in der Session).
- Gate-1-Produkt unberührt: `alloc_hw` ist wie `cacheline`/`node_width` KEINE der 26 Registry-Achsen,
  sondern NUR profil-aktiviert (catalog_codegen lehnt sie in der Limits-Vorstufe hart ab, wie cacheline).

## 5 Verbleibende Wiedervorlagen

1. **Multi-Socket-Messfenster (~Sep):** erst dort wird der NUMA-Effekt real messbar; das Profil
   `fb_numa_page_study` ist die vorbereitete Permutationsstrecke.
2. **Codegen-Bäckung der Varianten:** wie bei cacheline/node_width wählt der (GO-2-gegatete) Codegen-Kanal
   später die distinkte Organ-Instanz je `alloc_hw`-Wert (`NUMAllocAllocatorBody<V, Cfg>` /
   `PoolResourceAllocatorBody<V, Cfg>` + `gate_alloc_hw_for<HW>`); der Kanal selbst war in diesem
   Increment TABU.
3. **POOL als permutierbarer Allocator-Wert:** `permutation_axes.xml` (TABU, eingefroren) kennt keinen
   POOL-Wert; der Page-Hint-Konsument ist damit heute nur test-/codegen-seitig erreichbar. Aufnahme eines
   POOL-Werts = Neuschnitt der eingefrorenen Achse → nur mit explizitem GO.
