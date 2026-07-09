# DOSSIER AP-8/#242 — HDR-Histogramm real: HdrHistogram_c vendoren (Pfad A, is_original) + LatencyHdrHistogram-Observer p50/p95/p99 (HOST, ABI-4, golden-neutral)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore a4939d55, doktrin-fundiert Pfad A).
> **Die 5 Vendor-Quelldateien sind BEREITS platziert** (von Claude, verbatim von der offiziellen CC0-Quelle) unter
> `libs/common/measurement/hdr_histogram_wrapper/vendor/` — NICHT verändern/neu-fetchen (kein Netz). Deine Aufgabe = CMake-STATIC-Lib
> + C++23-RAII-Wrapper + p95 + Test. Rein HOST-seitig — NULL ABI-Modul-Berührung; MAJOR bleibt 4; golden-320 unberührt.

## 0. Ausgangslage (verifiziert)
- Skelett existiert: `libs/common/measurement/hdr_histogram_wrapper/CMakeLists.txt` = `add_library(comdare_hdr_histogram_wrapper INTERFACE)` (Phase-4.B-Platzhalter). Eingehängt via `libs/common/measurement/CMakeLists.txt:9`.
- **Vendor-Dateien (bereits da, CC0 Public Domain, Header-Lizenzkommentar intakt):**
  `vendor/hdr_histogram.c` (1311 Z.) · `vendor/hdr_tests.h` · `vendor/hdr_atomic.h` · `vendor/hdr_malloc.h` · `vendor/include/hdr/hdr_histogram.h` (516 Z.).
  `hdr_histogram.c` inkludiert `<hdr/hdr_histogram.h>` (→ `vendor/include`), `"hdr_tests.h"`/`"hdr_atomic.h"`/`"hdr_malloc.h"` (→ neben der .c, `vendor/`) + libc + `<immintrin.h>` (amd64/MSVC-OK).
  API: `hdr_init(lowest,highest,sig,&h)`, `hdr_record_value(h,v)`, `hdr_value_at_percentile(h,p)` (p in 0..100!), `hdr_close(h)`, `hdr_min/max/mean/count`.
- Repo-Doktrin (Pfad A): `axes/telemetry_axis/PAPER_REFERENCES.md` + `docs/architecture/18_...map.md:392` + `NOTICE:284` weisen HdrHistogram_c als is_original-Wrapper aus.

## 1. CMake — STATIC-Lib (ersetze die INTERFACE-Zeile)
`libs/common/measurement/hdr_histogram_wrapper/CMakeLists.txt`:
```
add_library(comdare_hdr_histogram_wrapper STATIC vendor/hdr_histogram.c)
target_include_directories(comdare_hdr_histogram_wrapper
    PUBLIC  ${CMAKE_CURRENT_SOURCE_DIR}                 # latency_hdr_histogram.hpp
            ${CMAKE_CURRENT_SOURCE_DIR}/vendor/include  # <hdr/hdr_histogram.h>
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/vendor)         # "hdr_tests.h"/"hdr_atomic.h"/"hdr_malloc.h"
set_target_properties(comdare_hdr_histogram_wrapper PROPERTIES LINKER_LANGUAGE C)
# CC0-1.0 (Public Domain) — HdrHistogram_c (Michael Barker), s. NOTICE. is_original.
```
Prüfe, ob das übergeordnete `measurement/CMakeLists.txt` / der Consumer die Lib bereits linkt; sonst NICHTS Weiteres (der Test linkt sie).

## 2. C++23-RAII-Wrapper (NEU, header-only, host)
`libs/common/measurement/hdr_histogram_wrapper/latency_hdr_histogram.hpp` (namespace `comdare::cache_engine::measurement` o. ä. konsistent):
```
extern "C" { #include <hdr/hdr_histogram.h> }
class LatencyHdrHistogram {
  hdr_histogram* h_ = nullptr;
public:
  explicit LatencyHdrHistogram(std::int64_t lowest=1, std::int64_t highest=3'600'000'000'000LL /*1h ns*/, int sig=3) {
      hdr_init(lowest, highest, sig, &h_); // wirft nicht; bei Fehler h_==nullptr -> Guard
  }
  ~LatencyHdrHistogram() { if (h_) hdr_close(h_); }
  LatencyHdrHistogram(LatencyHdrHistogram&&) noexcept; LatencyHdrHistogram& operator=(LatencyHdrHistogram&&) noexcept; // move-only
  LatencyHdrHistogram(const LatencyHdrHistogram&) = delete; LatencyHdrHistogram& operator=(const LatencyHdrHistogram&) = delete;
  void record(std::int64_t ns) noexcept { if (h_ && ns > 0) hdr_record_value(h_, ns); }
  [[nodiscard]] std::int64_t value_at(double q) const noexcept { return h_ ? hdr_value_at_percentile(h_, q*100.0) : 0; }
  [[nodiscard]] std::int64_t p50() const noexcept { return value_at(0.50); }
  [[nodiscard]] std::int64_t p95() const noexcept { return value_at(0.95); }
  [[nodiscard]] std::int64_t p99() const noexcept { return value_at(0.99); }
  [[nodiscard]] std::int64_t min() const; max() const; std::int64_t count() const; double mean() const; // via hdr_min/max/count/mean, h_-Guard
  // convenience: static aus std::span<const std::int64_t> ns bauen (record-Loop)
};
```
Alle Methoden `h_==nullptr`-safe (leere/Init-Fehler → 0). KEIN in-DLL, KEIN observable_tier-Bezug.

## 3. p95 ergänzen (3 Stellen, alle NICHT golden/pipeline16)
1. `libs/cache_engine/builder/commands/latency_stats.hpp` nach `:36`: additiv `[[nodiscard]] inline std::int64_t latency_p95_ns(std::span<const std::int64_t> v){ return percentile_ns(v,0.95); }` (Nearest-Rank-Referenz).
2. `libs/cache_engine/builder/workload_driver/workload_orchestrator.hpp:235-252` (`serialize_workload_run_results_csv`): je Op-Kind eine `*_p95_ns`-Spalte (Header + Wert via `nearest_rank_p(...,0.95)`), konsistent zu p50/p99. **NICHT** die pipeline16-CSV.
3. `libs/cache_engine/builder/anatomy_commands/tier_observe_trace_abi.hpp:307-311` (`serialize_abi_tier_trace_json`): `write_p95_ns`/`read_p95_ns`/`delete_p95_ns` ergänzen (via `nearest_rank_p(...,0.95)`).

## 4. Test (NEU) — `tests/unit/test_ap8_hdr_histogram.cpp` (gtest, Vorlage test_ap7_swisstable/test_v41_anatomy_f15_measurement:527)
- **HDR vs Nearest-Rank (TOLERANT):** 1..1000 ns in HDR record → `p50/p95/p99` ≈ `stats::percentile_ns(1..1000, 0.5/0.95/0.99)` innerhalb HDR-Präzision (sig=3 → rel. Bucket-Breite ~0.1%): `EXPECT_NEAR(hdr.p95(), ref_p95, ref_p95*0.01)` (rel. 1%). **KEIN ==** (HDR ist gebucketed — das ist korrekt/ehrlich, kein Bug).
- **Determinismus:** gleiche ns-Sequenz 2× → bit-identische p50/p95/p99.
- **Randfall:** leeres Histogramm → p50/p95/p99==0 (h_-Guard).
- **p95-Präsenz:** neue CSV/JSON-Spalten (`*_p95_ns`) erscheinen (String-find), pipeline16 bleibt 16.
- CMake-Registrierung `tests/unit/CMakeLists.txt` (AP-7-Muster) + link `comdare_hdr_histogram_wrapper`.

## 5. HARTE Auflagen (Verstoß = Abbruch)
1. **NULL ABI-Modul-Änderung:** NICHT anfassen `observable_tier.hpp`/`anatomy_module_abi_v1_decl.hpp`(MAJOR 4)/extern-C-Factory. Host-only.
2. **golden-320-neutral:** telemetry-Registry `AllTelemetries` (`axis_11_telemetry_registry.hpp:18`) NICHT reordern — `telemetry_leaf_only_counter` bleibt Index 0; kein `permutation_axes`/FullSourceCatalog/`golden_fullpilot_320_binary_ids.txt`.
3. **pipeline16-LaTeX-CSV EXAKT 16:** `serialize_measurements_pipeline16_csv` (`measurement_snapshot.hpp:171-192`) NICHT anfassen; `test_v5_measurement_snapshot` (`:89-98`, „16 Spalten") muss grün bleiben.
4. **Vendor-Dateien unverändert** (verbatim CC0-Quelle; nur CMake referenziert sie). Keine Fabrikation (HDR-Werte sind real gemessen).
5. Kein `git`.

## 6. Verifikation (PFLICHT — Codex, literal)
- Baue `comdare_hdr_histogram_wrapper` (C-STATIC) + `test_ap8_hdr_histogram` lokal → literal `[ PASSED ]`.
- Baue+laufe `test_v5_measurement_snapshot` → weiter `[ PASSED ]` (pipeline16==16 Regression grün).
- Bestätige: `COMDARE_ANATOMY_ABI_MAJOR` == 4; observable_tier/permutation_axes/golden/AllTelemetries-Reihenfolge unberührt.
- `git status --short`: neue Vendor-Dateien (5) + `hdr_histogram_wrapper/CMakeLists.txt` + `latency_hdr_histogram.hpp` + `latency_stats.hpp` + `workload_orchestrator.hpp` + `tier_observe_trace_abi.hpp` + `test_ap8_hdr_histogram.cpp` + `tests/unit/CMakeLists.txt`.

## 7. Ausgabe an Claude
(a) Diffs + neue Dateien; (b) literal `[ PASSED ]` (AP-8-Test + test_v5_measurement_snapshot); (c) Bestätigung ABI-4/golden-neutral/pipeline16==16/Vendor-verbatim; (d) HDR-vs-NearestRank-Toleranz-Wahl kurz begründen; (e) Follow-ups: is_original-Achsen-Linking (LatencyHistogram-Wrapper→kIsOriginal), immintrin/ARM-Portabilität, modules/-Spiegel.
