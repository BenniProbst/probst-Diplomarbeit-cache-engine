# Flag-System — Permutations-Identifier (Master-Konsolidierung)

**Stand:** 2026-05-15 (K-E.6)
**Quelle:** `../termine/20260508 Termin 7/Flag_System.txt` (370 Zeilen)
**Beschluss:** F10-K (Architektur-Korrektur 2026-05-04, ersetzt vorheriges `perm_id`-Hash-Schema)
**Vorbild:** Intel-CPUID-Feature-Flags

---

## §1 Zweck

Strukturierter Identifier-Mechanismus fuer Such-Algorithmus-Modul-Permutationen.

**Design-Prinzip:**
- Pro Bausteine-Achse eine "Bank" (uint64_t)
- Pro Implementation eine eindeutige Bit-Position
- Eine Permutation = Vereinigung der gesetzten Flags
- Pro Achse genau ein Bit (statisch); mehrere Bits bei dynamischen Bausteinen
- Wohl-geordnete Reihenfolge der Banken im Identifier-String

---

## §2 9 Banken (= 11 Achsen aus Bausteine_Matrix MINUS Achse 10 + 11, die im Identifier nicht erscheinen)

| Bank | Name | Typ | Achse aus Bausteine_Matrix | Quelle (Z) |
|---|---|---|---|---|
| 1 | PageBank | uint64_t | Achse 1 PAGE-TYPE | 45 |
| 2 | NodeBank | uint64_t | Achse 2 NODE-TYPE | 94 |
| 3 | TraversalBank | uint64_t | Achse 3 TRAVERSAL | 129 |
| 4 | ValueHandleBank | uint64_t | Achse 4 VALUEHANDLE | 152 |
| 5 | MemoryLayoutBank | uint64_t | Achse 5 MEMORY-LAYOUT | 170 |
| 6 | AllocatorBank | uint64_t | Achse 6 ALLOCATOR | 185 |
| 7 | PrefetchBank | uint64_t | Achse 7 PREFETCH | 200 |
| 8 | ConcurrencyBank | uint64_t | Achse 8 CONCURRENCY | 213 |
| 9 | IsaBank | uint64_t | Achse 9 ISA | 240 |

**Total:** 9 × uint64_t = 72 Bytes pro Permutation-Identifier (analog zu CPUID).

**Nicht im Flag-Identifier:**
- Achse 10 (MEASUREMENT) — Querschnitt, gesondert via Mess-Kategorien-Matrix (F-EXTRA-7)
- Achse 11 (TELEMETRY-COLLECTION-STRATEGY, NEU 2026-05-09 Kuehn) — wird ggf. in eine 10. Bank erweitert

---

## §3 Bank-Details (Auszug)

### Bank 1 — PageBank (Z 45-93)

```cpp
namespace comdare::flags::PageBank {
  // Trie-Familie (Bits 0-31)
  constexpr uint64_t DENSEBYTE_ART256        = 1ULL << 0;
  constexpr uint64_t SPARSE_NODE4_ART        = 1ULL << 1;
  constexpr uint64_t NODE16_ART              = 1ULL << 2;
  constexpr uint64_t NODE48_ART              = 1ULL << 3;
  constexpr uint64_t COMPOUND_HOT            = 1ULL << 4;
  constexpr uint64_t MULTIBYTE_START         = 1ULL << 5;
  constexpr uint64_t MACRO_COCO              = 1ULL << 6;
  constexpr uint64_t METATRIEHT_WORMHOLE     = 1ULL << 7;
  constexpr uint64_t LOUDS_DENSE_SURF        = 1ULL << 8;
  constexpr uint64_t LOUDS_SPARSE_SURF       = 1ULL << 9;
  constexpr uint64_t LOUDS_JACOBSON          = 1ULL << 10;
  // ...
}
```

26 Bausteine in PageBank — siehe Original Z 45-93 fuer Vollliste.

### Bank 2-9 (Z 94-269)

Analoge Struktur. Vollangaben siehe Original-Datei.

---

## §4 Permutation als Bit-Vereinigung

```cpp
struct PermutationFlags {
    uint64_t page_bank;
    uint64_t node_bank;
    uint64_t traversal_bank;
    uint64_t value_handle_bank;
    uint64_t memory_layout_bank;
    uint64_t allocator_bank;
    uint64_t prefetch_bank;
    uint64_t concurrency_bank;
    uint64_t isa_bank;
};

// Beispiel: ART-Variante mit mimalloc
constexpr PermutationFlags art_with_mimalloc = {
    .page_bank      = PageBank::DENSEBYTE_ART256 | PageBank::SPARSE_NODE4_ART
                      | PageBank::NODE16_ART | PageBank::NODE48_ART,
    .node_bank      = NodeBank::NODE4 | NodeBank::NODE16
                      | NodeBank::NODE48 | NodeBank::NODE256,
    .traversal_bank = TraversalBank::BYTEBYBYTE,
    .allocator_bank = AllocatorBank::MIMALLOC,
    // ...
};
```

---

## §5 ConstraintFilter als Bit-Maskierung

Statt der vorherigen perm_id-Filter-Methode kann nun trivial mit Bit-AND gefiltert werden:

```cpp
constexpr bool matches_filter(const PermutationFlags& perm, const PermutationFlags& filter) {
    return (perm.page_bank      & filter.page_bank)      != 0 &&
           (perm.node_bank      & filter.node_bank)      != 0 &&
           // ...
           (perm.isa_bank       & filter.isa_bank)       != 0;
}
```

---

## §6 Identifier-String-Format (wohl geordnet)

Die Permutations-ID wird als String dargestellt mit fester Reihenfolge:

```
P:0x000000000000000F.N:0x0000000000000003.T:0x0000000000000001.V:0x0000000000000001.M:...
```

Pro Bank: Bank-Praefix (P/N/T/V/M/A/Pr/C/I) + Hex-Wert. Strikt sortiert, damit
identische Permutationen identische IDs haben.

---

## §7 V31-Code-Status

**V31 hat:**
- `cache-engine/libs/cache_engine/algorithm_baustein.hpp` (V8.8 std::variant Pattern)
- `cache-engine/libs/cache_engine/baustein_variants.hpp` (V9.2 + V11.4 Bodies)
- `cache-engine/libs/cache_engine/resolve_baustein.hpp` (V10.2 11 Tag-Specializations)
- `cache-engine/libs/cache_engine/builder/permutation_engine/` (Permutations-Aufzaehlung)
- 30 SOTA-Profile + 10 Allokator-Profile mit `<expected_workload>` (V25.B + V26.A)

**Was noch fehlt:**
- Achse 11 (TELEMETRY-COLLECTION-STRATEGY) als 10. Bank (NEU 2026-05-09 Kuehn)
- ext-Repo-Aktivierung pro Adapter (Cluster-Aufgabe)
- HW-E2E Mess-Reihe (V21.2, User-Aktion)

---

## §9 N-Phase Erweiterung 2026-05-18 — 14 Banks + Sub-Bank-Encoding

**Trigger:** N.10 (#473), User-Direktive Bausteine-Matrix auf 14 Achsen
**Pflicht-Pre-Read:** `07_bausteine_matrix_N_erweitert.md`

### §9.1 Banks-Erweiterung 9 -> 14 (analog 14-Achsen-Modell)

| Bank | Achse | Bits | Beschreibung |
|---|---|---|---|
| 1 PageBank | 1 PAGE-TYPE | 8 bit (26 Bausteine) | unveraendert |
| 2 NodeBank | 2 NODE-TYPE | 5 bit (13 Bausteine) | unveraendert |
| **3 TraversalBank** | **3 TRAVERSAL** | **3+3+2 = 8 bit** | **gesplittet** in 3.A (3 bit, 8 Sub-Bausteine) + 3.B (3 bit, 6 Sub-Bausteine) + 3.M (2 bit, 4 Sub-Bausteine) |
| 4 ValueHandleBank | 4 VALUEHANDLE | 3 bit (5 Bausteine) | unveraendert |
| 5 MemoryLayoutBank | 5 MEMORY-LAYOUT | 3 bit (8 Bausteine) | unveraendert |
| **6 AllocatorBank** | **6 ALLOCATOR** | **3+2+2+2+2 = 11 bit** | **gesplittet** in 6.1 (3 bit) + 6.2 (2 bit) + 6.3 (2 bit) + 6.4 (2 bit) + 6.5 (2 bit) |
| 7 PrefetchBank | 7 PREFETCH | 3 bit (6 Bausteine) | unveraendert |
| **8 ConcurrencyBank** | **8 CONCURRENCY** | **3+2 = 5 bit** | **gesplittet** in 8.1 Pattern (3 bit, 7 Patterns) + 8.2 Locking-Mode (2 bit, 4 Modes) |
| 9 IsaBank | 9 ISA | 4 bit (16 ISA-Auspraegungen) | unveraendert |
| 10 MeasurementBank | 10 MEASUREMENT | 4 bit (F1 Matrix) | unveraendert |
| 11 TelemetryBank | 11 TELEMETRY-COLLECTION | 3 bit (6 + 4 Kuehn = 10 Auspraegungen) | erweitert |
| **12 HardwareBank (NEU)** | **12 HARDWARE-STRATEGY** | **3+2+2+2+2 = 11 bit** | NEU: 12.1 SIMD (3 bit) + 12.2 Cache-Level (2 bit) + 12.3 NUMA (2 bit) + 12.4 Prefetch-HW (2 bit) + 12.5 Atomic-Family (2 bit) |
| **13 SchedulingBank (NEU)** | **13 SCHEDULING-STRATEGY** | **3+3+2+2+2 = 12 bit** | NEU: 13.1 Worker-Pool (3 bit) + 13.2 SIMD-Limit (3 bit) + 13.3 Hetero-Core (2 bit) + 13.4 Co-Routine (2 bit) + 13.5 Batch (2 bit) |
| 14 EngineChoiceBank | (Meta-Achse, K03 V1-V4) | 2 bit (4 Builds) | NEU (war implizit in K03) |

**Total Permutations-ID-Breite:** 8 + 5 + 8 + 3 + 3 + 11 + 3 + 5 + 4 + 4 + 3 + 11 + 12 + 2 = **82 bit**

(vorher 9 Banks ~50 bit, jetzt 14 Banks 82 bit)

### §9.2 Permutations-Anzahl-Schaetzung

Mit den neuen Sub-Achsen explodiert der Permutationsraum:
- Vor N: 85 Bausteine über 11 Achsen, geschaetzt ~5.5 Milliarden Permutationen
- Nach N: ca. 120 Bausteine über 14 Achsen + Sub-Achsen, geschaetzt ca. 100 Milliarden+ Permutationen

**Konsequenz:** Profile-Filter + MessreihenMode::Defined wird zur Pflicht (V19+ schon implementiert). Full-Mode nur fuer ZIH-Cluster (Talos OS K8s Pods, P31-Plattform).

### §9.3 Sub-Bank-Bitfield-Layout (Beispiel Bank 3 TraversalBank)

```
TraversalBank (8 bit) Layout:
  Bit 0-2 (3 bit): Sub-Achse 3.A SearchAlgo-Traversal (8 Sub-Bausteine)
  Bit 3-5 (3 bit): Sub-Achse 3.B Cache-Memory-Traversal (6 Sub-Bausteine)
  Bit 6-7 (2 bit): Sub-Achse 3.M Traversal-Mapping (4 Sub-Bausteine)

Decoder-API (Pseudo-Code):
  uint8_t bank = permutation_id_get_bank<TraversalBank>(perm_id);
  TraversalAlgoSub a = (TraversalAlgoSub)(bank & 0x07);
  TraversalCacheSub b = (TraversalCacheSub)((bank >> 3) & 0x07);
  TraversalMappingSub m = (TraversalMappingSub)((bank >> 6) & 0x03);
```

### §9.4 Konsequenzen fuer Code (V32+)

| Konsequenz | Was | Wo |
|---|---|---|
| 1 | PermutationFlags-Struktur um 5 neue Banks erweitern (12 + 13 + 14 + Sub-Banks fuer 3 + 6 + 8) | `cache-engine/libs/cache_engine/include/comdare/cache_engine/permutation_flags.hpp` |
| 2 | XML-Config-Parser auf 14 Banks anpassen | `cache-engine/libs/common/config/xml_config_parser.hpp` |
| 3 | Codegen-Templates fuer 14-Bank-Sub-Bank-Encoding | `cache-engine/codegen/templates/` |
| 4 | Test-Suite fuer Sub-Bank-Encoding/Decoding | `cache-engine/tests/unit/test_permutation_flags.cpp` |

---

## §8 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Flag_System.txt`
- Bausteine-Matrix (Achsen-Definition): `01_bausteine_matrix.md` (K-E.2)
- Architekturentscheidung F10-K: `04_architekturentscheidungen_F1_F15.md` §4 (K-E.5)
- V31 Code: `../../Code/external/comdare-cache-engine/libs/cache_engine/`
- Flag-System Memory: (siehe `~/.claude/.../memory/MEMORY.md` falls dokumentiert)
