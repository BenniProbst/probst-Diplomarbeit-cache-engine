# ER-Modell — Persistente + In-Memory Datenstrukturen

**Habich-Anforderung H1:** "ER-Modell fuer persistente Datenstrukturen (auch In-Memory-Buffer-Schema!)".

**Bezug:**
- ADR F5 (eigene InMemoryMeasurementBuffer; Disk-Dump am Ende, Binary/CSV)
- ADR F10-K (PermutationFlags strukturiertes Flag-System)
- Block AO (Production-Plattform-Spez)

**Stand:** 2026-05-09

---

## 1. ER-Diagramm (Top-Level)

```
                       +------------------+
                       |   ExperimentRun  |
                       +------------------+
                       | * run_id (PK)    |
                       | timestamp        |
                       | platform_sig     |   1
                       | dataset_id       +----+
                       | mode             |    |
                       | module_id (FK)   |    |
                       +--------+---------+    |
                                |              |
                            1   |              |
                                v              v
                       +------------------+   +-----------------+
                       | MeasurementRecord|   | DatasetMetadata |
                       +------------------+   +-----------------+
                       | * record_id (PK) |   | * dataset_id (PK)
                       | run_id (FK)      |   | name            |
                       | category         |   | type            |
                       | algo_detail      |   | size_bytes      |
                       | metric_value     |   | distribution    |
                       | timestamp_ns     |   | source          |
                       | thread_id        |   +-----------------+
                       +------------------+

                       +------------------+
                       |  ModuleSpec      |
                       +------------------+
                       | * module_id (PK) |
                       | identifier       |
                       | path             |
                       | flags_page (FK)  |--+---> +------------------+
                       | flags_node (FK)  |  |     |  PermutationFlags|
                       | flags_traversal  |  |     +------------------+
                       | flags_value_h    |  |     | * flag_id (PK)   |
                       | flags_memory     |  |     | bank_name        |
                       | flags_allocator  |  |     | bit_position     |
                       | flags_prefetch   |  |     | concept_id       |
                       | flags_concurrency|  |     | impl_path        |
                       | flags_isa        |  |     | original_compiler|
                       | flags_telemetry  |  |     | license          |
                       +------------------+  |     +------------------+
                                             |
                       +------------------+  |
                       | BuildArtefact    |  |
                       +------------------+  |
                       | * artefact_id(PK)|  |
                       | module_id (FK)   |--+
                       | binary_path      |
                       | binary_size      |
                       | binary_hash      |
                       | abi_signature    |  ' F-EXTRA-8
                       | compiler_versions|
                       | build_timestamp  |
                       +------------------+
```

---

## 2. Tabellen-Spezifikationen (Pseudo-SQL)

### ExperimentRun

```sql
CREATE TABLE ExperimentRun (
    run_id          BIGINT PRIMARY KEY,
    timestamp       TIMESTAMPTZ NOT NULL,
    platform_sig    VARCHAR(64) NOT NULL,    -- z.B. "Ryzen9_9950X3D_64GB_DDR5_5600"
    dataset_id      BIGINT NOT NULL REFERENCES DatasetMetadata(dataset_id),
    mode            VARCHAR(32) NOT NULL,     -- HEURISTIC_STATIC | INFORMED_KALIBRIERT | AUTOMATIC_ADAPTIVE (Block AP)
    module_id       BIGINT NOT NULL REFERENCES ModuleSpec(module_id),
    config_hash     VARCHAR(64) NOT NULL,     -- alle Build-Konfig-Optionen gehasht
    duration_ns     BIGINT,
    -- Plattform-Spezifika (Block AO)
    cpu_model       VARCHAR(64),
    cpu_pinning     VARCHAR(128),             -- "P-Core" | "E-Core" | "V-Cache-CCD"
    memory_latency_cycles INT
);
```

### MeasurementRecord

```sql
CREATE TABLE MeasurementRecord (
    record_id       BIGINT PRIMARY KEY,
    run_id          BIGINT NOT NULL REFERENCES ExperimentRun(run_id),
    category        VARCHAR(32) NOT NULL,     -- CLU | CACHE_MISS | DTLB_MISS | BRANCH_MISS | LATENCY | THROUGHPUT | ENERGY_J | FILL_BUFFER_OCCUPANCY
    algo_detail     VARCHAR(64) NOT NULL,     -- ART_NODE256 | HOT_COMPOUND_K32 | MASSTREE_BORDER | ...
    metric_value    DOUBLE PRECISION NOT NULL,
    timestamp_ns    BIGINT NOT NULL,
    thread_id       BIGINT NOT NULL,
    -- Hybrid-CPU Trennung (Block AO i9-14900KS)
    cpu_class       VARCHAR(8),               -- "core" | "atom"
    -- Telemetry-Strategy (Achse 11, Kuehn-Erkenntnisse)
    telemetry_strategy VARCHAR(48),           -- PER_NODE | LEAF_ONLY | LEAF_ONLY_SAMPLED | PATH_READ | PROBABILITY_HINTS
    sampling_n      INT                        -- N fuer LeafOnlySampledCounter<N>; NULL falls anders
);
```

### DatasetMetadata

```sql
CREATE TABLE DatasetMetadata (
    dataset_id      BIGINT PRIMARY KEY,
    name            VARCHAR(64) NOT NULL,     -- z.B. "YCSB-A" | "CommonCrawl-Subset" | "RIPE-IP" | "Custom-Mixed-Length"
    type            VARCHAR(32) NOT NULL,     -- "ycsb" | "url-prefix" | "ip-address" | "zipfian-string" | "integer-seq" | "mixed-length" | "prefix-heavy"
    size_bytes      BIGINT NOT NULL,
    key_count       BIGINT NOT NULL,
    distribution    VARCHAR(48),              -- "uniform" | "zipfian-theta-0.5" | "pareto-heavy" | ...
    prefix_share    DOUBLE PRECISION,         -- 0.10 | 0.50 | 0.80 (F8 Praefix-Heavy)
    source          VARCHAR(128),             -- URL oder Generator-Spezifikation
    generated_by    VARCHAR(64)               -- "Java-YCSB" | "comdare-custom-cmake-sh-bat"
);
```

### ModuleSpec

```sql
CREATE TABLE ModuleSpec (
    module_id           BIGINT PRIMARY KEY,
    identifier          VARCHAR(255) NOT NULL UNIQUE,  -- "PAGE_DENSEBYTE_ART256.NODE_NODE256..."
    path                VARCHAR(512) NOT NULL,         -- "build/modules/<perm_id>/<perm_id>.module.so"
    flags_page          BIGINT NOT NULL,               -- Flag-Bank Werte (siehe PermutationFlags)
    flags_node          BIGINT NOT NULL,
    flags_traversal     BIGINT NOT NULL,
    flags_value_handle  BIGINT NOT NULL,
    flags_memory        BIGINT NOT NULL,
    flags_allocator     BIGINT NOT NULL,
    flags_prefetch      BIGINT NOT NULL,
    flags_concurrency   BIGINT NOT NULL,
    flags_isa           BIGINT NOT NULL,
    flags_telemetry     BIGINT NOT NULL,               -- NEU 2026-05-09 (Achse 11)
    is_valid_combination BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (flags_page, flags_node, flags_traversal, flags_value_handle,
            flags_memory, flags_allocator, flags_prefetch,
            flags_concurrency, flags_isa, flags_telemetry)
);
```

### PermutationFlags (Lookup-Tabelle pro Achse-Bit)

```sql
CREATE TABLE PermutationFlags (
    flag_id             BIGINT PRIMARY KEY,
    bank_name           VARCHAR(32) NOT NULL,   -- "page" | "node" | "traversal" | ... | "telemetry"
    bit_position        INT NOT NULL,            -- 0..63 innerhalb der Bank
    concept_id          VARCHAR(64) NOT NULL,   -- z.B. "PAGE_DENSEBYTE_ART256"
    impl_path           VARCHAR(255) NOT NULL,  -- "ext/P01-ART/unodb/" oder "prt_art/legacy_reimpl/..."
    original_compiler   VARCHAR(64),            -- z.B. "GCC 4.7+" | "GCC 11+" | "C++23"
    license             VARCHAR(32),             -- "Apache-2.0" | "GPL-3.0" | "MIT" | "ISC" | "LGPL-2.1+" | "PENDING"
    UNIQUE (bank_name, bit_position)
);
```

### BuildArtefact

```sql
CREATE TABLE BuildArtefact (
    artefact_id         BIGINT PRIMARY KEY,
    module_id           BIGINT NOT NULL REFERENCES ModuleSpec(module_id),
    binary_path         VARCHAR(512) NOT NULL,
    binary_size_bytes   BIGINT NOT NULL,
    binary_sha256       VARCHAR(64) NOT NULL,
    abi_signature       VARCHAR(255) NOT NULL,    -- F-EXTRA-8 Bit-Identitaet/Struktur
    main_compiler       VARCHAR(64) NOT NULL,     -- "GCC 14.2.0" | "Clang 17.0.6" | "MSVC 19.39"
    bauteil_compilers   JSONB,                     -- map BausteinId → CompilerVersion
    build_timestamp     TIMESTAMPTZ NOT NULL,
    -- F-EXTRA-8 Habich-Log
    abi_test_status     VARCHAR(16),               -- "BIT_IDENTICAL" | "FUNCTIONAL_OK" | "STRUCTURAL_OK" | "DIVERGENT"
    habich_log_path     VARCHAR(512)               -- Falls DIVERGENT: Path zur Logdatei
);
```

---

## 3. In-Memory-Buffer-Schema (F5 InMemoryMeasurementBuffer)

```
package "InMemoryMeasurementBuffer (F5)" {
  class MeasurementBuffer {
    -- Attribute --
    - arena_pmr : pmr::monotonic_buffer_resource    ' append-only
    - per_thread_blocks : array<ThreadBlock, MAX_THREADS>  ' lock-free
    - serialization_format : enum {BINARY, CSV}      ' Build-Flag F5
    -- Methoden --
    + append_record(record : MeasurementRecord) : void <<noexcept lock-free>>
    + serialize_to_disk(path : path) const : void
    + reset_for_run(run_id : RunId) : void
  }

  class ThreadBlock <<cache-line aligned>> {
    -- Attribute --
    - records : pmr::vector<MeasurementRecord>
    - thread_id : thread::id
    - block_offset : size_t   ' append-only
    -- Methoden --
    + append(record : MeasurementRecord&&) : void <<noexcept inline>>
  }

  MeasurementBuffer *--> "MAX_THREADS" ThreadBlock : per-thread arena
}
```

---

## 4. Disk-Dump-Format (Binary)

```
+--------------------------------------------------+
| DumpHeader (64 byte)                              |
|   magic       = "COMDARE-MEASUREMENT-V1"          |
|   version     = uint32                            |
|   run_id      = uint64                            |
|   timestamp   = uint64 (nanoseconds since epoch)  |
|   platform_sig = uint64 (hash of probe data)      |
|   record_count = uint64                           |
|   record_size  = uint32 (sizeof MeasurementRecord)|
+--------------------------------------------------+
| MeasurementRecord[record_count]                   |
|   category : uint8                                |
|   algo_detail : uint16                            |
|   thread_id : uint16                              |
|   cpu_class : uint8                               |
|   telemetry_strategy : uint8                      |
|   sampling_n : uint32                             |
|   reserved : uint8[3]                             |
|   timestamp_ns : uint64                           |
|   metric_value : double                           |
| (gepackt, 32 byte/Record)                         |
+--------------------------------------------------+
| Footer (32 byte)                                  |
|   checksum : uint64 (xxh3_64 of all records)      |
|   end_marker : "END-COMDARE"                      |
+--------------------------------------------------+
```

---

## 5. Disk-Dump-Format (CSV — Debug)

```csv
record_id,run_id,category,algo_detail,metric_value,timestamp_ns,thread_id,cpu_class,telemetry_strategy,sampling_n
1,42,CLU,ART_NODE256,0.873,1715209143521000000,7,core,LEAF_ONLY_SAMPLED,1000
2,42,CACHE_MISS_L2,ART_NODE256,12,1715209143521004500,7,core,LEAF_ONLY_SAMPLED,1000
...
```

---

## 6. Cross-Reference ER ↔ UML-Klasse

| ER-Entitaet | UML-Klasse | Speicher-Ort |
|-------------|------------|--------------|
| ExperimentRun | InMemoryMeasurementBuffer (Run-Header) | Heap-Buffer + Disk-Dump |
| MeasurementRecord | MeasurementRecord (struct) | per-thread cache-line aligned |
| DatasetMetadata | DatasetLoader (statische Tabelle) | Disk-Datei + im RAM |
| ModuleSpec | ModuleSpec (struct, Section 4 in 05_uml_engine_choice_builder.md) | Im Builder-Speicher |
| PermutationFlags | PermutationFlags (struct, F10-K) | Im Builder-Speicher |
| BuildArtefact | abgeleitet aus ModuleSpec + Compiler-Outputs | Disk (build/modules/) |

---

## 7. Forschungs-Mission-Bezug (Block AP)

ExperimentRun.mode wird auf `HEURISTIC_STATIC` / `INFORMED_KALIBRIERT` / `AUTOMATIC_ADAPTIVE` gesetzt. Damit ist im ER-Modell der **direkte Vergleich der drei Modi** ueber identische Workloads + Plattformen moeglich — Operationalisierung der Forschungs-Mission.
