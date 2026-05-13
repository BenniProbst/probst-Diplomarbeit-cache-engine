# Architektur-Delta REV 7.3 — YCSB-Generator-CLI (2026-05-13)

**Status:** Delta-Erweiterung zu `24_architektur_skizze_REV7_2026_05_13.md`
**Anlass:** User-Direktive 2026-05-13: "C: YCSB-Generator-CLI als Datasets-Tool"
**Bezug:** Aufgaben #81 (SCHRITT 1-6) + #82 (OP-1 bis OP-6)

---

## §1 Was wurde umgesetzt

Ein eigenstaendiges CLI-Tool `tools/ycsb_cli/` wurde angelegt, das die existing
`comdare::workload_generator`-Library als Frontend zugaenglich macht:

```
ycsb_cli --workload=A --num-keys=100000 --num-ops=1000000 \
          --output=ycsb_a.bin --format=binary
```

Damit lassen sich die fuer die Mikrobenchmark-Suite + ExperimentDemo (Phase 6.6
+ Phase 7.4) gebrauchten YCSB-Workloads dateibasiert vorab generieren und
spaeter aus dem Build-System konsumieren.

---

## §2 Komponenten

### §2.1 CLI-Optionen

| Flag | Default | Bedeutung |
|---|---|---|
| `--workload=<A..F>` | `C` | YCSB-Workload |
| `--num-keys=<n>` | `100000` | Anzahl unique Keys |
| `--num-ops=<n>` | `1000000` | Anzahl Operationen |
| `--key-size=<bytes>` | `16` | Key-Size in Byte |
| `--value-size=<bytes>` | `64` | Value-Size in Byte |
| `--key-dist=<...>` | `zipfian` | uniform / zipfian / sequential / latest |
| `--zipfian-theta=<f>` | `0.99` | Zipfian-Skew |
| `--seed=<n>` | `42` | Random-Seed |
| `--output=<path>` | `workload.bin` | Output-Datei |
| `--format=<...>` | `binary` | binary / tsv / json |
| `--help` | — | Hilfe anzeigen |

### §2.2 Output-Formate

**Binary** (`magic=0xC0FFEE01`, `version=1`):
```
uint32 magic
uint32 version
uint64 num_ops
foreach op:
  uint8  op_kind
  uint64 key_id
  uint32 scan_length
```
Total = 16 + 13 × N bytes (verifiziert: 50 ops → 666 bytes).

**TSV:** Header `op\tkey\tscan_length\n` + Zeile pro op (debuggbar).

**JSON:** `{ "num_ops": N, "ops": [ {...}, ... ] }` (inspectionsfreundlich).

### §2.3 Error-Codes (errno-style, REV 7 Konvention)

| Code | Bedeutung |
|---|---|
| 0 | success |
| 4 | invalid_argument (parse error, unknown flag, falsche Workload-Letter) |
| 10 | io_error (Datei nicht schreibbar) |

### §2.4 Build-Struktur

- `tools/ycsb_cli/main.cpp` — CLI + Writer + Driver
- `tools/ycsb_cli/CMakeLists.txt` — `comdare_ycsb_cli` (Binary) + `comdare::ycsb_cli_lib` (Test-Lib mit `YCSB_CLI_TEST_NO_MAIN=1`)
- `tools/CMakeLists.txt` — `add_subdirectory(ycsb_cli)`
- Top-level `CMakeLists.txt` — `add_subdirectory(tools)`

---

## §3 Tests

`tests/unit/test_ycsb_cli.cpp` — **14 Tests, alle gruen** (MSVC Debug C++23):

| Suite | Anzahl | Inhalt |
|---|---|---|
| Parser | 8 | `parse_workload`, `parse_format`, `parse_key_dist`, `parse_args` happy path, help flag, unknown flag, missing equals |
| Writer | 3 | Binary-Roundtrip mit Header-Magic-Verifikation, TSV-Header-Check, JSON-Content-Match |
| E2E | 2 | `generate_and_write` Single-Workload, alle 6 YCSB-Variants A-F |
| Windows-Race | — | `ifstream::close()` vor `filesystem::remove` (Windows-File-Lock-Fix) |

---

## §4 Verifikation Binary-CLI direkt

```text
> ycsb_cli --workload=C --num-keys=100 --num-ops=50 --output=ycsb_demo.bin --format=binary
ycsb_cli: wrote 50 ops to ycsb_demo.bin
> ls -la ycsb_demo.bin
666 bytes  (16 + 50*13 = 666 — Header + 50 ops korrekt)
```

---

## §5 Naechste Schritte

- **Datasets-Verzeichnis** (`datasets/`) ist noch leer; ein Pre-Build-Hook
  oder Tooling-Skript koennte `ycsb_cli` aufrufen, um den Pflicht-Korpus
  (#81 SCHRITT 1-6) automatisch zu materialisieren.
- **OP-1 bis OP-6** (#82) — die Detail-Spezifikationen sind noch nicht
  systematisch dokumentiert; das CLI ist neutral, weil es allen
  `workload_generator`-Optionen exponiert.
- **`generate_synthetic`-Pfade** (uniform/sequential/latest pur ohne YCSB) —
  derzeit nutzt das CLI nur `generate_ycsb()`; ein `--mode=synthetic`-Flag
  koennte dies erweitern, ist aber nicht Teil der minimalen Step-C-Anforderung.

---

## §6 Querverweis

- Phase 7.1: `workload_generator/include/comdare/workload_generator/workload_generator.hpp`
- Code: `comdare-cache-engine/tools/ycsb_cli/main.cpp`
- Tests: `comdare-cache-engine/tests/unit/test_ycsb_cli.cpp`
- Memory: [[feedback-phase-completeness-discipline]] (Phasen-Disziplin)
- Memory: [[feedback-algorithm-correctness-when-named]] (Algorithmus-Korrektheit)
