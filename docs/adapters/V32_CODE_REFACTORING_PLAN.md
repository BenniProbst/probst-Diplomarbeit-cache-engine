# V32 Code-Refactoring Plan — 14 Achsen + 4-Subsystem-Modell (V32.1-V32.4 + U.1+U.2)

**Stand:** 2026-05-18 (V32 + U Spezifikation, Code-Sprint in V32-Folge-Session)
**Trigger:** N-Phase 14 Achsen + M-Phase 4-Subsystem-Modell + O-Phase PRT-ART-Spiegel
**Konsequenz:** Echtes Code-Refactoring in cache-engine + prt-art Submodulen erforderlich (Submodule-Push-Workflow)

> **Hinweis:** Dieses Dokument spezifiziert das V32-Code-Refactoring. Die eigentlichen Code-Aenderungen erfolgen in einem dedizierten Sprint mit Submodule-Push fuer cache-engine + prt-art. Diese Doku ist die Spezifikation + Test-Plan.

---

## §1 V32.1 — PrtArtSearchEngine Template-Parameter 12 → 20+

**Repo:** `comdare-prt-art`
**File:** `prt_art/include/prt_art/identity/prt_art_search_engine.hpp`
**Aktuell:** 12 Template-Parameter (V31.F)
**Soll:** 20+ Template-Parameter (analog 14 Achsen + Sub-Achsen)

### §1.1 Vorgehen

1. Spiegel-Module aus O.3 anlegen (siehe `O_PHASE_PRT_ART_AXES_MIRROR.md` §3)
2. Default-Variant pro neuem Template-Param als Type-Alias verfuegbar machen
3. PrtArtSearchEngine Template-Parameter-Liste auf 20+ erweitern (siehe O.6 §6.1 fuer vollstaendige Liste)
4. Tests fuer alle neuen Template-Params (siehe U.2 §6)
5. Smoke-Tests V31.F (23/23) muessen weiterhin gruen bleiben (Default-Verhalten unveraendert)
6. Adapter-Konsumenten unveraendert (Pruefling-API bleibt stabil)

### §1.2 Akzeptanz-Kriterien

- [ ] Spiegel-Module komplett (O.3 §3.1-§3.6)
- [ ] PrtArtSearchEngine kompiliert mit 20+ Template-Params
- [ ] V31.F Smoke-Tests 23/23 gruen
- [ ] Neue Tests U.2 gruen (siehe §6)
- [ ] cache-engine Submodule unveraendert (PrtArt-Refactoring ist prt-art-intern)
- [ ] Diplomarbeit/Code/ Submodule-Pin auf neuen prt-art-HEAD aktualisiert

---

## §2 V32.2 — cache-engine PermutationFlags Struct 9 → 14 Banks

**Repo:** `comdare-cache-engine`
**File:** `libs/cache_engine/include/comdare/cache_engine/permutation_flags.hpp` (+ entsprechende .cpp)
**Aktuell:** 9 Banks (~50 bit)
**Soll:** 14 Banks (82 bit) mit Sub-Bank-Bitfield-Encoding

### §2.1 Bit-Layout (aus `docs/bausteine/05_flag_system.md §9.3`)

```cpp
// permutation_flags.hpp — V32.2 Erweiterung 9 -> 14 Banks
#pragma once
#include <cstdint>
#include <bit>

namespace comdare::cache_engine {

/// 82-bit Permutations-Identifier (14 Banks)
struct PermutationFlags {
    // Bank 1 PAGE-TYPE (8 bit, 26 Bausteine)
    std::uint8_t page_bank : 8;

    // Bank 2 NODE-TYPE (5 bit, 13 Bausteine)
    std::uint8_t node_bank : 5;

    // Bank 3 TRAVERSAL gesplittet (8 bit total)
    std::uint8_t traversal_3a : 3;  // SearchAlgo (8 Sub-Bausteine)
    std::uint8_t traversal_3b : 3;  // Cache-Memory (6 Sub-Bausteine)
    std::uint8_t traversal_3m : 2;  // Mapping (4 Sub-Bausteine)

    // Bank 4 VALUEHANDLE (3 bit, 5 Bausteine)
    std::uint8_t value_handle_bank : 3;

    // Bank 5 MEMORY-LAYOUT (3 bit, 8 Bausteine)
    std::uint8_t memory_layout_bank : 3;

    // Bank 6 ALLOCATOR gesplittet (11 bit total)
    std::uint8_t allocator_6_1 : 3;  // Allocation-Strategy
    std::uint8_t allocator_6_2 : 2;  // Reclamation-Policy
    std::uint8_t allocator_6_3 : 2;  // NUMA-Affinity
    std::uint8_t allocator_6_4 : 2;  // Huge-Page-Policy
    std::uint8_t allocator_6_5 : 2;  // Free-List-Strategy

    // Bank 7 PREFETCH (3 bit, 6 Bausteine)
    std::uint8_t prefetch_bank : 3;

    // Bank 8 CONCURRENCY gesplittet (5 bit total)
    std::uint8_t concurrency_8_1 : 3;  // Pattern (7 Patterns)
    std::uint8_t concurrency_8_2 : 2;  // Locking-Mode (4 Modes)

    // Bank 9 ISA (4 bit, 16 Auspraegungen)
    std::uint8_t isa_bank : 4;

    // Bank 10 MEASUREMENT (4 bit, F1 Matrix)
    std::uint8_t measurement_bank : 4;

    // Bank 11 TELEMETRY-COLLECTION (3 bit, 6 + 4 Kuehn = 10)
    std::uint8_t telemetry_bank : 3;

    // Bank 12 HARDWARE-STRATEGY (NEU, 11 bit total)
    std::uint8_t hw_12_1 : 3;   // SIMD-Family
    std::uint8_t hw_12_2 : 2;   // Cache-Level-Targeting
    std::uint8_t hw_12_3 : 2;   // NUMA-Strategy
    std::uint8_t hw_12_4 : 2;   // Prefetch-Hardware
    std::uint8_t hw_12_5 : 2;   // Atomic-Instruction-Family

    // Bank 13 SCHEDULING-STRATEGY (NEU, 12 bit total)
    std::uint8_t sched_13_1 : 3;  // Worker-Pool-Layout
    std::uint8_t sched_13_2 : 3;  // SIMD-Worker-Count-Limit
    std::uint8_t sched_13_3 : 2;  // Heterogeneous-Core-Dispatch
    std::uint8_t sched_13_4 : 2;  // Co-Routine-Strategy
    std::uint8_t sched_13_5 : 2;  // Batch-Granularity

    // Bank 14 EngineChoice (Meta-Achse K03 V1-V4, 2 bit)
    std::uint8_t engine_choice_bank : 2;

    // Total: 8+5+8+3+3+11+3+5+4+4+3+11+12+2 = 82 bit (in 11 bytes packbar)

    /// 82-bit Roundtrip via uint128_t
    [[nodiscard]] auto to_uint128() const noexcept -> __uint128_t;
    static auto from_uint128(__uint128_t id) noexcept -> PermutationFlags;
};

static_assert(sizeof(PermutationFlags) <= 16);

} // namespace comdare::cache_engine
```

### §2.2 Decoder/Encoder API

```cpp
// Decoder:
auto perm = PermutationFlags::from_uint128(perm_id);
auto algo_traversal = TraversalAlgoSub(perm.traversal_3a);

// Encoder:
PermutationFlags p;
p.page_bank = static_cast<std::uint8_t>(PageType::ART_NODE16);
p.traversal_3a = static_cast<std::uint8_t>(TraversalAlgoSub::BYTE_BY_BYTE);
// ...
__uint128_t perm_id = p.to_uint128();
```

### §2.3 Akzeptanz-Kriterien

- [ ] PermutationFlags-Struct mit 14 Banks (82 bit) kompiliert
- [ ] U.1 Roundtrip-Tests gruen (#510)
- [ ] Bestehende V31.F-Code-Pfade die alte 9-Banks-Struktur nutzen: ueber Migrations-Mapper kompatibel halten
- [ ] cache-engine Submodule-Pin in Diplomarbeit/Code/ aktualisiert

---

## §3 V32.3 — xml_config_parser auf 14 Banks anpassen

**Repo:** `comdare-cache-engine`
**Files:** `libs/common/config/xml_config_parser.hpp` + .cpp
**Aufgabe:** XML-Profile mit 14-Banks-Konfiguration parsen

### §3.1 XML-Schema-Erweiterung

Beispiel `algorithm_profiles/sota/p01_art.xml`:

```xml
<algorithm_profile>
    <paper_id>P01-ART</paper_id>
    <expected_workload>YCSB_A</expected_workload>

    <!-- 14-Achsen-Konfiguration -->
    <axes>
        <page_type>ART_NODE16</page_type>
        <node_type>NODE_NODE16_ART</node_type>
        <traversal_3a>BYTE_BY_BYTE</traversal_3a>
        <traversal_3b>CACHELINE_WALK</traversal_3b>
        <traversal_3m>LINEAR_1TO1</traversal_3m>
        <value_handle>INLINE</value_handle>
        <memory_layout>CACHE_LINE_ALIGNED</memory_layout>
        <allocator_6_1>POOL</allocator_6_1>
        <allocator_6_2>EPOCH</allocator_6_2>
        <allocator_6_3>LOCAL</allocator_6_3>
        <allocator_6_4>TRANSPARENT</allocator_6_4>
        <allocator_6_5>SIZE_CLASS</allocator_6_5>
        <prefetch>NONE</prefetch>
        <concurrency_8_1>OLC</concurrency_8_1>
        <concurrency_8_2>OPTIMISTIC_VALIDATION</concurrency_8_2>
        <isa>X86_64_AVX2</isa>
        <measurement>F1_MATRIX</measurement>
        <telemetry>NONE</telemetry>

        <!-- NEU Achse 12 -->
        <hw_12_1>AVX2</hw_12_1>
        <hw_12_2>L1_AWARE</hw_12_2>
        <hw_12_3>NONE</hw_12_3>
        <hw_12_4>NONE</hw_12_4>
        <hw_12_5>CAS</hw_12_5>

        <!-- NEU Achse 13 -->
        <sched_13_1>THREAD_PER_CORE</sched_13_1>
        <sched_13_2>2</sched_13_2>
        <sched_13_3>HYBRID_NAIVE</sched_13_3>
        <sched_13_4>NONE</sched_13_4>
        <sched_13_5>SINGLE</sched_13_5>

        <engine_choice>V2</engine_choice>
    </axes>
</algorithm_profile>
```

### §3.2 Akzeptanz-Kriterien

- [ ] xml_config_parser liest 14-Banks-XML korrekt
- [ ] alte 11-Achsen-XML weiterhin parsebar (Defaults fuer fehlende Banks)
- [ ] Roundtrip XML → PermutationFlags → XML
- [ ] Test mit p01_art.xml.example (14 Achsen) gruen

---

## §4 V32.4 — Codegen-Templates fuer 14-Bank-Sub-Bank-Encoding

**Repo:** `comdare-cache-engine`
**Files:** `codegen/templates/permutation_id_codec.hpp.template` + `xml_to_flags.cpp.template`
**Aufgabe:** Automatisch generierte Encoder/Decoder fuer alle 14 Banks

### §4.1 Template-Spezifikation

Templates erzeugen pro Bank/Sub-Bank:
- `encode_<axis>(value) → bits` Funktion
- `decode_<axis>(bits) → enum_value` Funktion
- Roundtrip-Test pro Achse

Generated Code zielt auf:
- `libs/cache_engine/include/comdare/cache_engine/permutation_codec.hpp`

### §4.2 Akzeptanz-Kriterien

- [ ] Codegen produziert kompilierbaren C++23-Code fuer alle 14 Banks
- [ ] Roundtrip-Tests fuer alle Sub-Banks gruen
- [ ] V32.2 + V32.3 verwenden generierten Codec

---

## §5 U.1 — PermutationFlags Test fuer 14 Banks + Sub-Bank-Encoding

**Repo:** `comdare-cache-engine`
**File:** `tests/unit/test_permutation_flags.cpp`

### §5.1 Test-Faelle

```cpp
// V32.U1 — Tests fuer 14-Banks PermutationFlags

TEST(PermutationFlagsV32, RoundtripEmpty) {
    PermutationFlags p{};
    auto id = p.to_uint128();
    auto p2 = PermutationFlags::from_uint128(id);
    EXPECT_EQ(memcmp(&p, &p2, sizeof(PermutationFlags)), 0);
}

TEST(PermutationFlagsV32, SubBankAchse3) {
    PermutationFlags p{};
    p.traversal_3a = 0b011;  // 3 (third Sub-Baustein)
    p.traversal_3b = 0b100;  // 4 (fifth Sub-Baustein)
    p.traversal_3m = 0b10;   // 2 (third Sub-Baustein)
    auto id = p.to_uint128();
    auto p2 = PermutationFlags::from_uint128(id);
    EXPECT_EQ(p2.traversal_3a, 0b011);
    EXPECT_EQ(p2.traversal_3b, 0b100);
    EXPECT_EQ(p2.traversal_3m, 0b10);
}

TEST(PermutationFlagsV32, NeueAchse12Hardware) {
    PermutationFlags p{};
    p.hw_12_1 = 0b001;  // AVX2
    p.hw_12_2 = 0b01;   // L1-aware
    p.hw_12_3 = 0b00;   // Local NUMA
    p.hw_12_4 = 0b01;   // PREFETCH
    p.hw_12_5 = 0b01;   // CAS
    auto id = p.to_uint128();
    auto p2 = PermutationFlags::from_uint128(id);
    EXPECT_EQ(p2.hw_12_1, 0b001);
    // ...
}

TEST(PermutationFlagsV32, NeueAchse13Scheduling) {
    PermutationFlags p{};
    p.sched_13_1 = 0b001;  // thread-per-core
    p.sched_13_2 = 0b010;  // 2 SIMD-Worker
    // ...
}

TEST(PermutationFlagsV32, AlleBanksMaxValues) {
    // Stresstest: alle Banks auf Max
    PermutationFlags p{};
    p.page_bank = 0xFF;  // 26 Bausteine, max=25
    // ...
}
```

### §5.2 Akzeptanz-Kriterien

- [ ] >= 10 Tests gruen
- [ ] Roundtrip pro Bank + Sub-Bank
- [ ] Edge-Cases (alle 0 / alle max)
- [ ] Performance-Test (82-bit Encoding < 100 ns auf x86_64)

---

## §6 U.2 — PrtArtSearchEngine Test fuer 14 Template-Params + Default-Variants

**Repo:** `comdare-prt-art`
**File:** `prt_art/tests/test_prt_art_identity.cpp` (Erweiterung)

### §6.1 Test-Faelle

```cpp
// V32.U2 — Tests fuer erweiterte Template-Params

TEST(PrtArtSearchEngineV32, DefaultConstruction) {
    PrtArtSearchEngine<std::string_view, std::uint64_t> engine{};
    EXPECT_TRUE(true);  // Compile-Time-Check
}

TEST(PrtArtSearchEngineV32, CustomHardwareStrategy) {
    using HardwareConfig = comdare::prt_art::hardware::PrtArtHardwareDefault;
    PrtArtSearchEngine<
        std::string_view, std::uint64_t,
        /* PageStrategy */ PrtArtDefaultPageStrategy,
        /* ... 12 weitere Defaults ... */
        /* HardwareStrategy */ HardwareConfig
    > engine{};
    EXPECT_TRUE(true);
}

TEST(PrtArtSearchEngineV32, CustomSchedulingStrategy) {
    // ...
}

TEST(PrtArtSearchEngineV32, AllNeuTemplateParams) {
    // Alle neuen Template-Params explizit gesetzt
    // ...
}

TEST(PrtArtSearchEngineV32, V31FBackwardCompatibility) {
    // Aufruf mit alter 12-Template-Param-Liste (V31.F-Stil) muss
    // weiterhin kompilieren (via Default-Variants fuer neue Params)
    PrtArtSearchEngine<std::string_view, std::uint64_t> engine_v31{};
    auto result = engine_v31.lookup("test");
    EXPECT_EQ(result, std::nullopt);
}
```

### §6.2 Akzeptanz-Kriterien

- [ ] >= 8 Tests gruen
- [ ] V31.F Backward-Compatibility gewahrt
- [ ] Tests fuer jeden neuen Template-Param (HardwareStrategy, SchedulingStrategy, TraversalMapping, ReclamationPolicy, NumaAffinity, HugePagePolicy, FreeListStrategy, LockingMode)

---

## §7 V32-Sprint-Workflow

### §7.1 Reihenfolge (kritischer Pfad)

1. **O.3 Spiegel-Module** (prt_art/hardware, scheduling, traversal, telemetry, isa, allocator-Erweiterungen) — Voraussetzung fuer V32.1
2. **V32.1 PrtArtSearchEngine Template-Params** (prt-art Repo, mit Default-Variants kompatibel zu V31.F)
3. **V32.2 cache-engine PermutationFlags** (cache-engine Repo, 9 → 14 Banks)
4. **V32.4 Codegen-Templates** (cache-engine Repo, generieren Encoder/Decoder)
5. **V32.3 xml_config_parser** (cache-engine Repo, XML-Schema-Erweiterung)
6. **U.1 PermutationFlags Tests** (cache-engine, begleitet V32.2 + V32.4)
7. **U.2 PrtArtSearchEngine Tests** (prt-art, begleitet V32.1)
8. **Diplomarbeit/Code/ Submodule-Pins** auf neuen cache-engine + prt-art HEAD aktualisieren

### §7.2 Tags

- `v31-final` (cache-engine, prt-art): vor Refactoring
- `v32.0-staging` (cache-engine, prt-art): nach Refactoring + Tests gruen
- `v32-final` (alle 3 Repos): wenn Submodule-Pins synchronisiert sind

### §7.3 Risk-Mitigation

- Default-Variants stellen sicher, dass alte API-Aufrufer weiterhin kompilieren
- Migrations-Mapper alte 9-Banks → neue 14-Banks (Roundtrip-Test)
- V31.F Smoke-Tests muessen weiterhin alle gruen sein

---

## §8 Status-Zusammenfassung V32 + U

| Task | Repo | Code-Sprint | Tests | Akzeptanz |
|---|---|---|---|---|
| **O.3** | prt-art | NEU 6 Sub-Verzeichnisse anlegen | U.2 | siehe O.3 §3.1-§3.6 |
| **V32.1** | prt-art | Template-Params 12 → 20+ | U.2 | siehe §1.2 |
| **V32.2** | cache-engine | PermutationFlags 9 → 14 Banks | U.1 | siehe §2.3 |
| **V32.3** | cache-engine | xml_config_parser | (XML-Tests) | siehe §3.2 |
| **V32.4** | cache-engine | Codegen-Templates | (Roundtrip) | siehe §4.2 |
| **U.1** | cache-engine | Tests (>= 10) | gruen | siehe §5.2 |
| **U.2** | prt-art | Tests (>= 8) | gruen | siehe §6.2 |

**Submodule-Push-Pflicht:** cache-engine + prt-art beide.
**Diplomarbeit-Repo:** nur Submodule-Pin-Bumps.

---

## §9 Konsequenzen fuer Folge-Sessions

1. **V32-Sprint braucht eigene Folge-Session** mit klarer Code-Phase + Test-Phase + Tag-Phase
2. **Submodule-Push-Workflow** beachten (cache-engine + prt-art separat pushen, dann Diplomarbeit-Pin-Bump)
3. **CI-Pipeline** (GitHub Actions in beiden Repos) muss 14-Banks-Tests gruen halten
4. **thesis-Kapitel-Aktualisierung** nach V32 fertig (Kapitel 04 Implementation aktualisieren mit V32 Stand)

---

## §10 Querverweise

- O.1-O.6 PRT-ART Spiegel: `O_PHASE_PRT_ART_AXES_MIRROR.md`
- T.1-T.4 Adapter-Status: `T_PHASE_ADAPTER_STATUS.md`
- Bausteine N-Phase: `../bausteine/07_bausteine_matrix_N_erweitert.md`
- Flag-System: `../bausteine/05_flag_system.md` §9
- Schichten-Modell M: `../architektur/10_schichten_modell_M.md`
- Anti-Vermischung: `../architektur/11_axes_vs_strategies_disambiguation.md`
- Memory N-Phase: `~/.claude/.../memory/reference_n_phase_achsen_erweiterung.md`

---

**Ende docs/adapters/V32_CODE_REFACTORING_PLAN.md (V32.1-V32.4 + U.1+U.2 als Konsolidierungs-Doku DONE).**
