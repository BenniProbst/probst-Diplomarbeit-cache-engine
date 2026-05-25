# V41.F.6.0 — Single-File-Audit aller prt-art Headers (P0 Architektur-Migration Vorarbeit)

**Datum:** 2026-05-25
**Vorgaenger:** `20260525-V41-session-end-context-exhausted.md`
**Zweck:** Pflicht-Audit aller produktiven prt-art Headers vor Migration nach cache-engine (V41.F.6 P0).
**Reichweite:** `Code/external/comdare-prt-art/prt_art/include/prt_art/` (Production HEAD `d1b6140`).

---

## §0 Korrektur zur Open-TODOs-Tabelle

**Open-TODOs sagt "47 Header in 14 Achsen-Verzeichnissen".**
**Verifiziert: 43 Header in 14 Achsen-Verzeichnissen.** (Differenz 4)

Tatsaechliche File-Verteilung (Stand 2026-05-25, HEAD `d1b6140`):

| # | Achsen-Verzeichnis | Files | Stand TODO-Doku |
|---|--------------------|-------|-----------------|
| 1 | `allocator/` | 3 | (TODO: 3) ✓ |
| 2 | `concurrency/` | 1 | (TODO: 1) ✓ |
| 3 | `default_lookup/` | 9 + 1 Registry = 10 | TODO: 12 (Differenz: TODO zaehlt 12, vorhanden 9 + Registry = 10) |
| 4 | `identity/` | 5 | (TODO: 5) ✓ |
| 5 | `internal_search/` | 4 | (TODO: 4) ✓ |
| 6 | `measurement/` | 2 | (TODO: 2) ✓ |
| 7 | `memory_layout/` | 4 | (TODO: 4) ✓ |
| 8 | `nodes/` | 2 | (TODO: 2) ✓ |
| 9 | `prefetch/` | 3 | (TODO: 3) ✓ |
| 10 | `serialization/` | 1 | (TODO: 1) ✓ |
| 11 | `telemetry/` | 1 | (TODO: 1) ✓ |
| 12 | `traversal/` | 2 | TODO: 3 (Differenz: 1) |
| 13 | `value_buffer/` | 1 | (TODO: 1) ✓ |
| 14 | `value_handle/` | 5 | (TODO: 5) ✓ |
| | **Summe** | **43** | **47 TODO-behauptet** |

**Korrekturursache vermutlich:** TODO-Doku addierte `default_lookup_registry.hpp` separat + zaehlte ein nicht-existentes drittes `traversal/*.hpp`. Production-Stand ist 43 Header.

**Action:** Open-TODOs-Doc `20260524-V41-open-todos.md` muss in F.6.0b ergaenzt werden — die korrigierte Zahl 43 muss in die V41.F.6-Tabelle, mit ergaenzendem Hinweis dass `default_lookup/` 9 Achsen-Default + 1 Registry-Header enthaelt.

---

## §1 Audit-Methodik

Pro File die **7 Pflicht-Pruefungen** aus `20260524-V41-open-todos.md` §-3 V41.F.6:

| # | Pruefung | Kurzform |
|---|----------|----------|
| P1 | Klassifikation | BASIS (→ cache-engine) vs SPEZIFISCH (→ prt-art bleibt) vs DEPRECATED (→ loeschen) |
| P2 | Stub-Status | Hat das File echten Inhalt oder ist es ein leeres Skelett? |
| P3 | Konzept-Duplikate | Mehrere Files in prt-art definieren das gleiche Konzept abweichend? |
| P4 | prt-art-spezifische Hacks | Hat ein eigentlich-BASIS-File prt-art-spezifische Sonderlogik? |
| P5 | Cache-Engine-Referenzen | `#include <cache_engine/...>` vorhanden? |
| P6 | prt-art-interne Referenzen | `#include <prt_art/...>` Anzahl + Pfade |
| P7 | Tests vorhanden | Test-Coverage in `tests/unit/` (Tests werden in F.6.4 migriert) |

---

## §2 Per-File-Audit (43 Header)

### Achsen-Verzeichnis 1: `allocator/` (3 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `pool_descriptor.hpp` | **BASIS** | Inhalt (~66 LOC, PoolKind enum + Stats + Descriptor) | nein | nein | nein | nein | implicit via PoolSet-Tests |
| `pool_router.hpp` | **BASIS** | Inhalt (~59 LOC, PageEncoding/ValueHandle → PoolKind-Routing) | nein | nein | nein | `pool_descriptor.hpp` | implicit |
| `pool_set.hpp` | **BASIS** | Inhalt (~71 LOC, 7-Pool Aggregator mit Stats-Hooks) | nein | nein | nein | `pool_descriptor.hpp` | implicit |

**Achsen-Bewertung:** ALLE 3 sind BASIS — generische Pool-Verwaltung, keine prt-art-spezifischen Algorithmen. Direkte Migration nach `cache_engine/allocator/`.

### Achsen-Verzeichnis 2: `concurrency/` (1 File)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `olc_with_reserved_blocks.hpp` | **BASIS** | Inhalt (~89 LOC, OLC-Pattern + WriteGuard RAII) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** BASIS. Klassisches OLC ist nicht prt-art-spezifisch. Migration nach `cache_engine/concurrency/`. Anmerkung: Beschriftung `OlcWithReservedValueBlocks` ist generisch ueber "Reserved Value Blocks", obwohl PRT-ART-spezifisch designed wurde — Migration ohne Umbenennung moeglich.

### Achsen-Verzeichnis 3: `default_lookup/` (10 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `default_lookup_registry.hpp` | **SPEZIFISCH** (prt-art-Adapter, listet welche Achsen via CE-Default) | Inhalt (~85 LOC, constexpr array 9 axes) | nein | nein | nein | nein | implicit |
| `prt_art_11_telemetry_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett (kein Klassen-Code, nur Kommentar-Pointer) | nein | (n/a) | nein | nein | n/a |
| `prt_art_12_hardware_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_13_scheduling_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_3b_cache_traversal_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_62_reclamation_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_63_numa_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_64_huge_page_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_82_locking_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |
| `prt_art_9_isa_default.hpp` | **DEPRECATED Indikator** | Leer-Skelett | nein | (n/a) | nein | nein | n/a |

**Achsen-Bewertung:** ALLE 9 `prt_art_*_default.hpp` sind **Indikator-Stubs** — sie signalisieren via Existenz dass die Achse via CE-Bibliothek default-lookup auto-permutiert wird. KEIN Code-Inhalt, nur Dokumentations-Kommentare. NACH F.6.2 (Axen-Namespace-Migration) werden diese OBSOLET (die Registry kennt die Achsen ohnehin). Empfehlung: F.6.2-Migration ersetzt sie durch CMake-Config-Eintrage. Bis dahin BLEIBEN sie als Lese-Pointer fuer Entwickler.

**Registry** ist SPEZIFISCH (definiert WELCHE Achsen via CE auto-permutiert werden) — bleibt in prt-art unter neuem Namespace `comdare::cache_engine::lookup::prt_art_default_axes_registry`.

### Achsen-Verzeichnis 4: `identity/` (5 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `prt_art_execution_engine_adapter.hpp` | **SPEZIFISCH** (prt-art als ExecutionEngine B) | Inhalt | nein | n/a (ist prt-art-Pruefling-Adapter) | `cache_engine/builder/commands/execute_engine_command.hpp` | nein | implicit |
| `prt_art_identity.hpp` | **SPEZIFISCH** (PRT-ART PermutationFlags-Identitaet) | Inhalt | nein | n/a | `cache_engine/concepts/permutation_flags.hpp` | nein | implicit |
| `prt_art_search_engine.hpp` | **SPEZIFISCH** (hybride PrtArt-API) | Inhalt | nein | n/a | `cache_engine/fingerprint/fixed_length_fingerprint.hpp` | 8 prt-art-interne Includes (alle Achsen) | 51 Tests (REV 7.6 V8.9) |
| `prt_art_search_engine_adapter.hpp` | **SPEZIFISCH** (ABI-Inheritance-Adapter zur CE ABI) | Inhalt | nein | n/a | `cache_engine/abi/configuration_permutation.hpp`, `cache_engine/abi/execution_engine.hpp`, `cache_engine/abi/processing_strategy.hpp` | `prt_art_search_engine.hpp`, `status.hpp` | implicit |
| `status.hpp` | **SPEZIFISCH** (PRT-ART errno-Status-Codes) | Inhalt (~50 LOC, status_t + constants) | nein | n/a | nein | nein | implicit |

**Achsen-Bewertung:** ALLE 5 sind SPEZIFISCH — bleibt vollstaendig in prt-art. Aber Migration: `identity/` unter neuem Namespace `comdare::cache_engine::identity::optional_prt_art_impl` mit Interface-Bindung an CE-Basis (siehe V41.F.6.3).

### Achsen-Verzeichnis 5: `internal_search/` (4 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `array_256.hpp` | **BASIS** | Inhalt (~52 LOC, Direkt-Array 256 Slots) | nein | nein | nein | nein | implicit |
| `array_65535.hpp` | **BASIS** | Inhalt (~50 LOC, Direkt-Vector 65535 Slots) | nein | nein | nein | nein | implicit |
| `vector_u16_u16.hpp` | **BASIS** | Inhalt (~62 LOC, Sorted Pair Vector) | nein | nein | nein | nein | implicit |
| `vector_u8_u8.hpp` | **BASIS** | Inhalt (~64 LOC, Sorted Pair Vector kleiner) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** ALLE 4 sind BASIS — internal-search-Strukturen sind generische Sub-Index-Strategien (Density-basierte Wahl). Migration nach `cache_engine/search_engine/internal/` empfohlen. Keine prt-art-Sonderlogik.

### Achsen-Verzeichnis 6: `measurement/` (2 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `density_tracker.hpp` | **BASIS** | Inhalt (~70 LOC, per-Node Density + Histogram) | nein | nein | nein | nein | implicit |
| `hypothesis_metrics.hpp` | **SPEZIFISCH** (PRT-ART H1/H2/H3 Diplomarbeit-Verifikation) | Inhalt (~85 LOC, H1=PageType-Cost, H2=Quality, H3=Inline/External) | nein | nein (ist Pruefling-Metrik) | nein | nein | implicit |

**Achsen-Bewertung:** Density-Tracking ist generisch (BASIS). Hypothesis-Metrics sind Diplomarbeit-spezifisch (SPEZIFISCH, bleibt unter `comdare::prt_art::measurement` als Pruefling-Verifikations-Tooling).

### Achsen-Verzeichnis 7: `memory_layout/` (4 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `byte_path.hpp` | **BASIS** | Inhalt (~46 LOC, BytePath-Cursor fuer Konsumieren von Bytes) | nein | nein | nein | nein | implicit |
| `cache_line_aligned_layout.hpp` | **BASIS** | Inhalt (~49 LOC, 64-Byte-aligned Utilities) | nein | nein | nein | nein | implicit |
| `multi_level_layout.hpp` | **BASIS** | Inhalt (~64 LOC, L1/L2/L3-Tier-Resolver) | nein | nein | nein | `cache_line_aligned_layout.hpp`, `virtual_offset_address.hpp` | implicit |
| `virtual_offset_address.hpp` | **BASIS** | Inhalt (~54 LOC, TLB-inspirierte Adressierung) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** ALLE 4 sind BASIS. Cache-aligned Memory-Layout-Strategien sind generisch verwendbar. Migration nach `cache_engine/layout/`.

### Achsen-Verzeichnis 8: `nodes/` (2 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `bplus_node.hpp` | **BASIS** | Inhalt (~84 LOC, B+ Node mit Density-Reklassifizierung) | nein | nein | nein | nein | implicit |
| `redirect_node.hpp` | **BASIS** | Inhalt (~58 LOC, CoCo-Trie Redirect-Knoten) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** ALLE 2 sind BASIS — Node-Typen sind allgemeine Trie/Tree-Bausteine, in cache-engine wiederverwendbar. Migration nach `cache_engine/node/`.

### Achsen-Verzeichnis 9: `prefetch/` (3 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `distance_estimator.hpp` | **BASIS** | Inhalt (~37 LOC, Density+Latency → Distance) | nein | nein | nein | nein | implicit |
| `path_oriented_prefetch.hpp` | **BASIS** | Inhalt (~67 LOC, Path-Tracking + Extrapolation) | nein | nein | nein | `distance_estimator.hpp` | implicit |
| `redirect_prefetch.hpp` | **BASIS** | Inhalt (~50 LOC, Spezial-Schedule fuer Redirect-Subtrees) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** ALLE 3 sind BASIS. Prefetch-Strategien sind generisch (Distance-Estimation kennt nichts prt-art-spezifisches, Path-Tracking + Redirect-Schedule sind universale Patterns). Migration nach `cache_engine/prefetch/`.

### Achsen-Verzeichnis 10: `serialization/` (1 File)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `signaling_bits.hpp` | **BASIS** | Inhalt (~118 LOC, VarLen-Encoder + SignalingStream) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** BASIS — Generische Protobuf-style Encoding, keine prt-art-Sonderlogik. Migration nach `cache_engine/serialization/`.

### Achsen-Verzeichnis 11: `telemetry/` (1 File)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `leaf_only_counter.hpp` | **BASIS** (Kuehn 11.X1 Hauptvariante) | Inhalt (~193 LOC, LeafOnlyCounter + PerNodeCounter Anti-Pattern) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** BASIS — Kuehn-validierte Telemetrie-Strategie, generisch verwendbar (template ueber NodeId). PerNodeCounter ist BEWUSST als Anti-Pattern-Vergleichsbasis vorhanden. Migration nach `cache_engine/telemetry/`.

### Achsen-Verzeichnis 12: `traversal/` (2 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `search_algo_traversal.hpp` | **DEPRECATED Stub** | **LEER-SKELETT** (V32.DD.2 Reorganisation, leere Klasse + V32.1 TODO) | JA (Bridge zu V31 `internal_search/`) | n/a | nein | `../internal_search/{array_256,array_65535,vector_u8_u8,vector_u16_u16}.hpp` | nein |
| `traversal_mapping.hpp` | **DEPRECATED Stub** | **LEER-SKELETT** (V32.DD.2 Reorganisation, leere Klasse + V32.1 TODO) | JA (Bridge zu V31 `memory_layout/virtual_offset_address.hpp`) | n/a | nein | `../memory_layout/virtual_offset_address.hpp` | nein |

**Achsen-Bewertung:** BEIDE 2 sind DEPRECATED Stubs — V32.DD.2 "V32.1 Sprint: konkrete Traversal-Dispatch-Logik" wurde NIE umgesetzt. Sie sind Skelett-Bridge-Klassen die nur die `internal_search/` und `memory_layout/` Headers re-includieren ohne neue Funktion.

**Empfehlung:** LOESCHEN in F.6.2 (Migration-Schritt). Funktion wird durch direkten Zugriff auf migriert-CE-`search_engine/internal/` + `layout/` ersetzt. Die `@reuse_status (b)` Markierungen sind irrefuehrend — beide Files sind sit V32.DD.2 (2026-05-18) substantiell leer.

**KRITISCHER AUDIT-BEFUND:** Diese sind die 2 echten Stubs im Repo. Tests nutzen sie nicht.

### Achsen-Verzeichnis 13: `value_buffer/` (1 File)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `linear_value_buffer.hpp` | **BASIS** | Inhalt (~103 LOC, Append-only mit Tombstones + Compaction) | nein | nein | nein | nein | implicit |

**Achsen-Bewertung:** BASIS — Linear Value-Buffer ist generischer Pattern. Migration nach `cache_engine/value_buffer/`.

### Achsen-Verzeichnis 14: `value_handle/` (5 Files)

| File | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|------|----|----|----|----|----|----|----|
| `chain_ref_handle.hpp` | **BASIS** | Inhalt (~44 LOC, Chain-Head + Length, P3 vertagt) | nein | nein | nein | nein | implicit |
| `cost_model.hpp` | **BASIS** | Inhalt (~63 LOC, Inline-vs-External Cost-Modell) | nein | nein | nein | nein | implicit |
| `external_handle.hpp` | **BASIS** | Inhalt (~36 LOC, Pool-Offset Handle) | nein | nein | nein | nein | implicit |
| `inline_handle.hpp` | **BASIS** | Inhalt (~51 LOC, Template ueber Capacity 1..64) | nein | nein | nein | nein | implicit |
| `value_handle.hpp` | **BASIS** | Inhalt (~57 LOC, std::variant Wrapper + Visitor) | nein | nein | nein | `chain_ref_handle.hpp`, `external_handle.hpp`, `inline_handle.hpp` | implicit |

**Achsen-Bewertung:** ALLE 5 sind BASIS. Value-Handle-Pattern ist allgemeine std::variant-Wrapper-Architektur, nicht prt-art-spezifisch. Migration nach `cache_engine/value_handle/`.

---

## §3 Cross-Cutting-Befunde

### 3.1 Stubs (P2 = Leer-Skelett)

**2 echte Stubs identifiziert:**
1. `traversal/search_algo_traversal.hpp` — V32.DD.2 leere Klasse
2. `traversal/traversal_mapping.hpp` — V32.DD.2 leere Klasse

Die 9 `default_lookup/prt_art_*_default.hpp` sind technisch leer, aber **DIENEN ALS INDIKATOR** (siehe Registry-Code). Keine echte Stubs, sondern Marker-Files.

### 3.2 Cache-Engine-Referenzen (P5 = Includes von `<cache_engine/...>`)

**4 Files** mit cache-engine #includes (alle in `identity/`):

| File | Cache-Engine Header(s) |
|------|------------------------|
| `identity/prt_art_execution_engine_adapter.hpp` | `cache_engine/builder/commands/execute_engine_command.hpp` |
| `identity/prt_art_identity.hpp` | `cache_engine/concepts/permutation_flags.hpp` |
| `identity/prt_art_search_engine.hpp` | `cache_engine/fingerprint/fixed_length_fingerprint.hpp` |
| `identity/prt_art_search_engine_adapter.hpp` | `cache_engine/abi/configuration_permutation.hpp`, `cache_engine/abi/execution_engine.hpp`, `cache_engine/abi/processing_strategy.hpp` |

**Erwartung:** Diese 4 SPEZIFISCH-Files sind die Pruefling-Adapter — sie MUESSEN cache-engine referenzieren (ABI-Bindung). Nach Migration bleiben Referenzen, allerdings unter neuem Namespace-Pfad (V41.F.2).

### 3.3 prt-art-Interne Referenzen (P6 = Includes von `<prt_art/...>`)

**Top-Referenzkette: `identity/prt_art_search_engine.hpp`** — incl. 8 weitere prt-art Headers:
- `allocator/pool_set.hpp`
- `concurrency/olc_with_reserved_blocks.hpp`
- `identity/prt_art_identity.hpp`
- `identity/status.hpp`
- `measurement/density_tracker.hpp`
- `measurement/hypothesis_metrics.hpp`
- `memory_layout/multi_level_layout.hpp`
- `prefetch/path_oriented_prefetch.hpp`
- `value_handle/value_handle.hpp`

Dies ist der zentrale Pruefling-Composit-Header — er bindet ALLE Achsen-Komponenten. Nach Migration (V41.F.6.3) entsteht hier die Notwendigkeit dass prt-art-Pruefling-Adapter via Vererbung von cache-engine-Basis-Klassen aufbaut, nicht via direkte Includes.

### 3.3.5 NACHTRAG 2026-05-25 spaet — Korrekte Migrations-Reihenfolge + Pattern (User-Direktive)

**User-Praezisierung 2026-05-25 abendlich:**
> "optional_prt_art_impl kommt eigentlich aus dem namespacing Aufgabenumfeld und bedeutet, dass eine Erweiterung des cache-engine namespaces optional durch Pruefling-Permutations-Achsen erweitert werden kann. Bleibt der namespace in einer Achse aus, werden die standard cache-engine Permutationen gegengeprueft und automatisch verwendet."

> "Die Implementierung verwenden ein dynamisches Muster, anstatt statisch kompilerter Metaprogrammierung, wie gefordert. Eine Hauptkategorie steuert nur die Permutations der einzelnen registrierten Achsen mithilfe einer Permutations-Modul-Klasse als visitor Registrierungs-pattern (statische Metaprogrammierung durch CacheEngineBuilder Pre-compile Permutation). Ich sehe auch noch keine Absicherung der Metaprogrammierung durch ein concept System."

> "Wir muessen erst nach Cache Engine migrieren und dann davon ableiten."

**Falscher erster Implementations-Versuch (V41.F.6.0.S1+S2 v1 — ZURUECKGEROLLT):**
- Monolithische Klasse `SearchAlgoTraversal` mit `std::variant` und Runtime-Switch (DYNAMISCH)
- Direkt in prt-art geschrieben ohne Basis in cache-engine (FALSCHE REIHENFOLGE)
- Kein Concept-System fuer Metaprogrammierungs-Absicherung
- Kein Factory-Pattern je Achse, kein Visitor-Permutations-Modul

**Korrekte Vorgehensweise (V41.F.6.1 + F.6.2 + F.6.3):**

1. **F.6.1 zuerst:** cache-engine Basis-Konstruktion
   - Concepts pro Achse: `concept ITraversalStrategy`, `concept ISearchAlgoVariant`, etc.
   - Basis-Interface pro Achse (Vererbungsgrundlage)
   - PermutationVisitor-Modul-Klasse mit Registrierungs-Pattern
   - CacheEngineBuilder Pre-Compile-Permutation (statische Metaprogrammierung via templates)
   - Namespace-Slots: `comdare::cache_engine::<axis>::optional_prt_art_impl`

2. **F.6.2:** 27 BASIS-Files von prt-art nach cache-engine migrieren
   - Klassen erben von Basis-Interface aus F.6.1
   - Compile-Time-Registrierung via Visitor-Pattern
   - Concept-Constraints absichern korrektes API

3. **F.6.3:** prt-art-Spezialisierungen via Namespace-Erweiterung
   - prt-art schreibt Klassen in `comdare::cache_engine::<axis>::optional_prt_art_impl::*`
   - Erweitert (per Compile-Time-Detection) die cache-engine-Standards
   - Wenn ein Namespace-Slot leer bleibt: cache-engine-Default wird gegengeprueft + verwendet (Compile-Time-Fallback)

**Status der heute geschriebenen Stubs (NACH ROLLBACK):**
- `traversal/search_algo_traversal.hpp` ist wieder V32.DD.2-Skelett-Zustand
- `traversal/traversal_mapping.hpp` ist wieder V32.DD.2-Skelett-Zustand
- `tests/unit/test_traversal.cpp` ist entfernt
- `tests/unit/CMakeLists.txt` ist auf vorigen Zustand revertiert

Die korrekte Implementation folgt unter F.6.1 (cache-engine Basis) + F.6.2 (Migration) + F.6.3 (prt-art Spezialisierung via Namespace).

### 3.4 Klassifikations-Verteilung (KORRIGIERT 2026-05-25 nach User-Praezisierung)

**User-Direktive 2026-05-25 spaet:**
> "Die themenbezogenen Funktionalitaeten bestehen parallel NEBEN der Achsen-zentrischen Logik. Daher werden die lookup Klassen auch nicht geloescht, sondern wir erweitern das System in eine 2-Ebenen-Architektur, wobei allgemeinere Module wie default_lookup, nodes, memory_layout und so weiter (alle), je mindestens eine Achse als Haupt-Kategorie aufnehmen. Die Achsen sind damit unter-Kategorien eines Themas. ... Also entgegen deiner Erwartung: alles valide Funktionalitaeten und Pflicht fuer die Implementierung noch ausstehender stubs in die cache-engine."

**KORREKTUR:** Die zuvor als "DEPRECATED" markierten Files sind **NICHT DEPRECATED**, sondern **PFLICHT-Stubs/Marker** in einer 2-Ebenen-Architektur, deren Implementierung in cache-engine TODO ist.

| Klassifikation | Anzahl | Anteil | Migration-Ziel | Status |
|----------------|--------|--------|----------------|--------|
| **BASIS** (vollstaendig implementiert) | 27 | 63% | `cache_engine/<topic>/` UND `cache_engine/axes/<axis>/` (2-Ebenen, parallel) | DONE |
| **SPEZIFISCH Pruefling** (identity/ + Registry) | 6 | 14% | `cache_engine/<topic>/optional_prt_art_impl/` + Vererbung | DONE (Adapter) |
| **PFLICHT-Stub Achsen-Slot** (traversal/) | 2 | 5% | Echte Dispatch-Impl jetzt schreiben (User-Direktive) → BASIS | **TODO HEUTE** |
| **PFLICHT-Marker Themen-Kategorie** (default_lookup/prt_art_*_default.hpp) | 9 | 21% | Themen-Slot (default_lookup) + Achsen-Slot (axes/<axis>/optional_prt_art_impl) parallel; Implementations-TODOs in cache-engine | **TODO BEHALTEN bis F.6.3 + cache-engine Implementations-TODOs** |
| **Summe** | **43** | **100%** | | |

**2-Ebenen-Architektur (User-Klarstellung):**

```
cache_engine/
├── <topic>/                                  # Themen-Ebene (alte prt-art-Struktur)
│   ├── default_lookup/                       # Thema mit mind. einer Achse als Haupt-Kategorie
│   │   ├── prt_art_*_default.hpp            # PFLICHT-Marker bleibt (Pruefling-Slots)
│   │   ├── basis_telemetry_default.hpp      # NEU: BASIS-Implementation (PFLICHT-TODO)
│   │   └── ...                              # weitere Achsen-Defaults
│   ├── nodes/
│   ├── memory_layout/
│   ├── value_handle/
│   ├── prefetch/
│   ├── telemetry/
│   ├── traversal/                            # KEIN Stub mehr — echte Dispatch (V41.F.6.0 TODO)
│   └── ... (alle 14 Themen)
└── axes/                                     # Achsen-Ebene (V41.F.2 Neu-Struktur)
    ├── lookup/                               # Achse via Themen-Cross-Reference
    ├── layout/
    ├── ... (alle 14 Achsen)
    └── <axis>/optional_prt_art_impl/         # Pruefling-Override pro Achse
```

Beide Hierarchien koexistieren, sind aufeinander cross-referenziert (z.B. via #includes oder using-Aliases).

**Migration-Befund (korrigiert):**
- 27 BASIS gehoeren nach cache-engine **unter beiden Ebenen** (Themen + Achsen) — duplizieren nicht, sondern via Cross-Reference verlinken
- 6 SPEZIFISCH sind genuine Pruefling-Adapter und bleiben unter `optional_prt_art_impl/`
- 11 PFLICHT-Stubs/Marker sind **valide Funktionalitaeten** mit ausstehender Impl in cache-engine — werden migriert + ergaenzt, nicht geloescht
- Implementations-TODOs werden in F.6.2 in cache-engine als BASIS-Defaults ausgebaut

### 3.5 Test-Coverage

Production-Stand `Code/external/comdare-prt-art/prt_art/src/` enthaelt nur `README.md` (Header-only Library, keine .cpp Implementierungs-Files).

`prt_art/tests/unit/` existiert ggf. — wurde im Audit-Scope **NICHT** geprueft (Reichweite war Include-Tree). F.6.4 ist die explizite Sub-Task fuer Tests-Migration.

51 Tests in `tests/unit/test_prt_art_identity.cpp` (laut Memory `feedback_hybrid_search_engine_interface.md` REV 7.6 V8.9) sind die Haupt-Coverage fuer identity/-Files.

---

## §4 Verifizierte Vor-Aussagen aus V41.F.6 TODO-Doc

| TODO-Doc Behauptung | Verifikations-Status |
|---------------------|----------------------|
| "47 Header in 14 Achsen-Verzeichnissen" | **TEILWEISE FALSCH** — 43 Header (Korrektur in §0) |
| "interpreters/ + page_structures/ in Production geloescht (V35+/V36+ Cleanup)" | **BESTAETIGT** (vorherige Session F.6.0b: `git log` ergab beide Verzeichnisse hatten NIE Files in git history) |
| "Stoerungen pro Verzeichnis pruefen" | **DONE** — 2 echte Stubs (traversal/), 9 Indikator-Marker (default_lookup/), keine `Hacks` (P4) gefunden |
| "BASIS-Klassen nach cache-engine" | **VERIFIZIERT** — 27 BASIS-Files identifiziert |
| "prt-art-spezifische erweitern via namespace" | **VERIFIZIERT** — 5 identity/-Files + 1 Registry sind die einzigen genuinen prt-art-Erweiterungen |

---

## §5 Migration-Empfehlung (Reihenfolge fuer V41.F.6.1-F.6.6)

### F.6.1 Ziel-Verzeichnis-Struktur in cache-engine

Anlegen unter `libs/cache_engine/axes/` (analog zu V41.F.2 Direktive):

```
libs/cache_engine/axes/
├── allocator/         <- 3 BASIS aus prt-art (+ ggf. eigene CE-Defaults)
├── concurrency/       <- 1 BASIS
├── search_engine/internal/  <- 4 BASIS aus internal_search/
├── layout/            <- 4 BASIS aus memory_layout/
├── node/              <- 2 BASIS
├── prefetch/          <- 3 BASIS
├── serialization/     <- 1 BASIS
├── telemetry/         <- 1 BASIS
├── value_buffer/      <- 1 BASIS
├── value_handle/      <- 5 BASIS
├── measurement/       <- 1 BASIS (density_tracker)
├── identity/          <- INTERFACE Skelett fuer Pruefling-Adapter
├── traversal/         <- LEER (Stubs gestrichen)
└── lookup/            <- Registry-Slot fuer Default-Lookup-Vermittlung
```

### F.6.2 BASIS-Kopierung (27 Files)

- Kopieren + Namespace `comdare::prt_art::<axis>::*` → `comdare::cache_engine::<axis>::*`
- Existierende CE-Defaults pruefen + ggf. zusammenfuehren
- Die 9 `default_lookup/prt_art_*_default.hpp` Marker-Files in CMake-Config umwandeln, Marker-Files loeschen

### F.6.3 prt-art bleibt SPEZIFISCH (5 identity/ + 1 Registry)

Umbenennen unter neuem Namespace:
- `comdare::prt_art::identity::*` → `comdare::cache_engine::identity::optional_prt_art_impl::*`
- Vererbung von CE-Basis-Klassen statt direkter Includes
- Registry behalten: `comdare::cache_engine::lookup::prt_art_default_axes_registry`

### F.6.4 Tests umbiegen

- 51 prt-art-Tests in `tests/unit/test_prt_art_identity.cpp` bleiben (testen Pruefling-Adapter)
- NEUE Tests in cache-engine fuer 27 migrierte BASIS-Klassen (auf Test-Coverage angewiesen, vorher implicit ueber prt-art-Identity-Tests)

### F.6.5 messung_driver / Codegen anpassen

- Header-Pfade aendern: `<prt_art/<axis>/...>` → `<cache_engine/axes/<axis>/...>`
- Pruefling-Codegen `prt_art/permutations_codegen/codegen.cmake` neue Pfade

### F.6.6 Build + 104 Tests gruen halten

Kein Funktions-Verlust. Verifikation:
```bash
bash Code/tools/run_all_tests.sh --config Release
# Erwartet: >= 104 passed, 0 failed
# (mit 51 prt-art-Tests gruen falls Adapter-Vererbung korrekt)
```

---

## §6 Korrekturen fuer Open-TODOs-Doku (V41.F.6.0b)

Folgende Aenderungen in `20260524-V41-open-todos.md` §-3 TODO V41.F.6 noetig:

| Stelle | Aktuell | Korrektur |
|--------|---------|-----------|
| §-3 V41.F.6 Einleitung | "47 Header in 14 Achsen-Verzeichnissen" | **43 Header in 14 Achsen-Verzeichnissen** (43 = 27 BASIS + 6 SPEZIFISCH + 9 DEPRECATED Indikatoren + 2 DEPRECATED Stubs) |
| Tabelle §-3 V41.F.6 | `default_lookup/ Files: 12` | **`default_lookup/ Files: 10`** (9 Indikatoren + 1 Registry) |
| Tabelle §-3 V41.F.6 | `traversal/ Files: 3` | **`traversal/ Files: 2`** |
| §-3 V41.F.6 Befund | Migration-Spalte fehlt Stubs-Hinweis | Ergaenze: traversal/ enthaelt 2 DEPRECATED Stubs (V32.DD.2 leer-Skelett) → LOESCHEN bei F.6.2 |
| §-3 V41.F.6 Befund | default_lookup-Marker-Files nicht klassifiziert | Ergaenze: 9 default_lookup/prt_art_*_default.hpp sind Indikator-Marker (NICHT echter Code) → in CMake-Config umwandeln bei F.6.2 |

---

## §7 Was offen bleibt (V41.F.6.1+)

- **V41.F.6.0b** Open-TODOs-Doku korrigieren (oben §6)
- **V41.F.6.1** Ziel-Verzeichnis-Struktur in cache-engine anlegen — wartet auf F.6.0b
- **V41.F.6.2** 27 BASIS-Files migrieren — wartet auf F.6.1 + V41.F.2 (Achsen-Namespace)
- **V41.F.6.3** 5 identity-Files + 1 Registry unter neuem Namespace — wartet auf F.6.2
- **V41.F.6.4** Tests migrieren — wartet auf F.6.3
- **V41.F.6.5** messung_driver + Codegen umstellen — wartet auf F.6.4
- **V41.F.6.6** Build + 104 Tests gruen halten — wartet auf F.6.5
- **V41.F.6.7** Research-Clone aufraeumen — wartet auf F.6.6

---

## §8 Verifikation

Audit-Tools:
```bash
# Files-Count
find prt_art/include/prt_art -name "*.hpp" | wc -l
# -> 43

# Verzeichnisse
find prt_art/include/prt_art -type d -mindepth 1 | wc -l
# -> 14

# Stub-Detektion (leere Klassen)
grep -l "Skelett" prt_art/include/prt_art/**/*.hpp
# -> traversal/search_algo_traversal.hpp, traversal/traversal_mapping.hpp

# Cache-Engine-Referenzen
grep -rl "#include <cache_engine" prt_art/include/prt_art/
# -> alle 4 identity-Files (prt_art_execution_engine_adapter, prt_art_identity, prt_art_search_engine, prt_art_search_engine_adapter)
```

Pruefcommandos waren der Basis-Input fuer §2 + §3.

---

## §9 Bezug zu anderen V41-TODOs

- **V41.F.2 (Achsen-Namespace)** ist die strukturelle Voraussetzung — cache-engine bekommt `axes/<axis>/`-Hierarchie
- **V41.F.3 (Concepts)** kommt parallel — Achsen-Interfaces bekommen `concept` requires
- **V41.E11 (Facade)** verbindet sich — migrierte Achsen werden via ICacheEngine-Facade angeboten
- **V41.F.4 (Tools-Plugin)** parallel zu F.6 — beide bilden die Master-Framework-Architektur
- **V41.F.5 (Dreigliedrigkeit)** profitiert — cache-engine-Pruefling-Trennung wird durch F.6 sauberer
- **V41.E6 (nested cache-engine via prt-art)** wird durch F.6 reduziert — wenn prt-art nur noch identity/-Adapter haelt, ist die nested cache-engine-Referenz minimal
- **V41.E10 (STATIC/SHARED Achse)** unabhaengig — Migrations-Code respektiert die STATIC/SHARED-Regel ohne Aenderung
