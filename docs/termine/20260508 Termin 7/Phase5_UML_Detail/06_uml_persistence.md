# UML — Persistence (InMemoryMeasurementBuffer)

**Bezug:**
- ADR F5 (eigene InMemoryMeasurementBuffer; KEINE externe DB; Disk-Dump am Ende)
- ER-Modell siehe `07_er_model.md`

---

## 1. InMemoryMeasurementBuffer (F5 zentrale Komponente)

```
class InMemoryMeasurementBuffer <<F5>> <<append-only>> {
    -- Attribute --
    - per_thread_arenas : array<unique_ptr<ThreadArena>, MAX_THREADS>
    - format : SerializationFormat   ' BINARY | CSV (Build-Flag)
    - run_metadata : RunMetadata

    -- Hot-Path-Methoden --
    + append_record(record : MeasurementRecord) : void <<noexcept lock-free inline>>
    ' Pro-Thread-Arena, kein Lock im Hot-Path

    -- Disk-Dump (am Ende des Laufs) --
    + serialize_to_disk(path : path) const : void
    + reset_for_run(run_id : RunId) : void

    -- Constraints (F5) --
    inv: kein Lock im Hot-Path
    inv: keine externen Verbindungen waehrend Messung
    inv: serialisiert NUR nach Abschluss eines kompletten Experiments
}
```

## 2. ThreadArena (cache-line aligned)

```
class ThreadArena <<cache-line aligned>> {
    -- Attribute --
    - arena_resource : pmr::monotonic_buffer_resource
    - records : pmr::vector<MeasurementRecord>
    - thread_id : thread::id
    - bytes_consumed : size_t

    -- Methoden --
    + append(record : MeasurementRecord&&) <<noexcept inline>>
    + spillover_to_disk_if_full() : void   ' optional, nur im Builder-Mode
}
```

## 3. MeasurementRecord (32-Byte gepackt fuer Binary-Format)

```cpp
struct alignas(32) MeasurementRecord {
    uint8_t  category;          // MeasurementCategory enum
    uint16_t algo_detail;       // AlgoDetail enum
    uint16_t thread_id;
    uint8_t  cpu_class;         // 0=core 1=atom (Block AO Hybrid-CPU)
    uint8_t  telemetry_strategy; // Achse 11 (Kuehn)
    uint32_t sampling_n;        // fuer LeafOnlySampledCounter<N>
    uint8_t  reserved[3];
    uint64_t timestamp_ns;
    double   metric_value;
};
static_assert(sizeof(MeasurementRecord) == 32);
```

## 4. RunMetadata + DumpHeader

```
class RunMetadata <<value>> {
    + run_id : RunId
    + timestamp : steady_clock::time_point
    + platform_signature : PlatformSignature
    + dataset_id : DatasetId
    + module_id : ModuleId
    + mode : CacheEngineMode  ' Block AP
    + config_hash : sha256
}

class DumpHeader <<binary>> {
    + magic : char[24]    = "COMDARE-MEASUREMENT-V1"
    + version : uint32
    + run_metadata : RunMetadata
    + record_count : uint64
    + record_size : uint32 = 32
}

class DumpFooter <<binary>> {
    + checksum : uint64   ' xxh3_64 of all records
    + end_marker : char[12] = "END-COMDARE"
}
```

## 5. LatexRenderer (H3 dynamic compile)

```
class LatexRenderer <<H3>> {
    -- Attribute --
    - dump_path : path
    - latex_template : path
    -- Methoden --
    + render(dump : DumpHeader, records : span<MeasurementRecord>) : void
    ' wertet \PRTARTPlot{...}-Bausteine im LaTeX-Source aus
    ' produziert pgfplots/tikz-Diagramme
    + run_pipeline(): ExitCode
    ' Param-Update → CacheEngineBuilder → Dump → LaTeX-Compile → PDF
}
```

## 6. drawio-Tab-Struktur

| Tab | Inhalt |
|-----|--------|
| 06-A | InMemoryMeasurementBuffer Architektur (per-thread arenas, append-only) |
| 06-B | Disk-Dump-Format (Binary-Header/Records/Footer + CSV alternative) |
| 06-C | LatexRenderer Pipeline (H3) |
