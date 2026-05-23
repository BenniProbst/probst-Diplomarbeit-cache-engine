# V36 + V37 Sprint — Implementations-Zusammenfassung für Diplomarbeit-Kapitel

**Stand:** 2026-05-23
**Zweck:** Pro Implementations-Block eine Absatz-Skizze die der User in das jeweilige Diplomarbeit-Kapitel einbauen kann. User schreibt Volltext manuell (Memory-Direktive).

---

## §1 Pre-Build Permutations-Codegen (V36.A–B → Kapitel "Bausteine-Matrix / Praktische Umsetzung")

Die 14-Achsen-Bausteine-Matrix erzeugt eine Permutations-Explosion (~5,5 Mrd Kombinationen, gemäß Pre-Read `bausteine/07_bausteine_matrix_N_erweitert.md`). Eine Vorab-Kompilation aller Kombinationen ist physisch nicht möglich und konzeptionell auch nicht sinnvoll, weil ein Host nur einen Bruchteil davon ausführen kann (Constraint-Filter über SIMD-Familie, OS, Allokator-Verfügbarkeit). V36 implementiert deshalb einen profilgefilterten Codegen mit drei Stufen (smoke ~27, medium ~144, full alle Host-kompatiblen). Pro Permutation generiert ein CMake-Skript (kein Python, vgl. Memory-Direktive NO-PYTHON) einen Wrapper-Source mit Compile-Time-Defines für die Achsen-Identität, einer Linker-sichtbaren `extern "C"`-ID-Funktion und einem `add_library(perm_<id> STATIC ...)`-Eintrag. Die Wrapper sind bewusst minimal: sie etablieren die Identität, das Code-Cache-Layout und die Versionsschicht. Der eigentliche Algorithmus-Body kommt in einer späteren Iteration (Phase 6+, s.u. V37.D).

## §2 Pruefling-Permutations PRT-ART (V36.C → Kapitel "PRT-ART als Pruefling")

PRT-ART ist im 4-Subsystem-M-Modell der einzige aktive Pruefling (vgl. `architektur/10_schichten_modell_M.md`). Sein Achsen-Set ist eigenständig: PA-1 Node-Typ (compact/wide/leaf_only/internal), PA-2 Path-Compression, PA-3 Lookup-Algorithmus, PA-4 Telemetry-Mode (gemäß Kuehn 11.X1). V36.C spiegelt den cache-engine-Mechanismus eins zu eins ins prt-art-Repo: eigener Codegen unter `prt_art/permutations_codegen/`, eigenes Manifest, Aggregator-Target `comdare_prt_art_permutations_all`. Die Symmetrie ist bewusst: cache-engine ist Werkzeug, prt-art ist Pruefling — beide nutzen das gleiche Codegen-Schema, aber getrennte Achsen-Konfigurationen. Im Diplomarbeit-Container wird der Pruefling über `add_subdirectory` mit `COMDARE_PRT_ART_BUILD_TESTS=OFF` eingebunden, um doppelte FetchContent-Aufrufe für GoogleTest zu vermeiden.

## §3 Tri-State Build-Mode (V36.B Direktive → Kapitel "Reproduzierbarkeit der Experimente")

User-Direktive 2026-05-23 forderte einen Drei-Zustand-Schalter, nicht einen reinen On/Off-Boolean: `on_rebuild` (jeder cmake-Run schreibt alle Wrappers neu), `on_build_on_demand` (Default — nur fehlende oder veraltete) und `off_pause_build` (Codegen pausiert, vorhandenes Manifest wird verwendet). Der Sonderfall — kein Manifest UND Mode=off — muss zur Laufzeit harten Abbruch erzeugen, weil sonst der Experiment-Driver Workloads gegen ein leeres Set von Permutationen laufen lässt und still falsche Aggregate produzieren würde. V36.D platziert diesen Check als erste Aktion in `messung_driver/main.cpp`: vor jeder Mess-Logik wird `assert_permutations_available_or_die()` aufgerufen, das Exit-Code 2 zurückgibt wenn beide Manifeste leer sind. Dies operationalisiert die Direktive "Kein Experiment möglich".

## §4 Per-Permutation Versionierung (V36.E → Kapitel "Reproduzierbarkeit / Modul-Releases")

User-Direktive 2026-05-23: jede Permutation ist ein eigenständiges Modul-Release. Eine Änderung an einem Achsen-Algorithmus (z.B. neue AVX2-Implementation) darf nur die Permutationen betreffen die diese Achse-Variante enthalten. Implementation: pro Achsen-Variante ein vN-Tag in `axes_versions.txt` (User-editiert), pro Permutation eine `.version`-Datei im Build-Output mit semver-Version (0.1.0 initial) und persistierter Achsen-Signatur. Der Codegen vergleicht die aktuelle Achsen-Signatur mit der gespeicherten: bei Differenz Minor-Bump (0.1.0 → 0.2.0) und Wrapper neu schreiben. Bei Identität: skip. Eine Bump-Operation an einer einzigen Achse (z.B. `axis_12_simd_avx2: v1 → v2`) bewirkte im Test 9 Bumps von 27 Permutationen — exakt die 9 mit avx2. Die restlichen 18 blieben unverändert.

## §5 Cross-Compiler / Cross-Build-Type-Validierung (V37.A → Kapitel "Toolchain-Portabilitaet")

Der gesamte Stack wurde gegen zwei Compiler-Familien (MSVC 14.44 + MinGW-GCC 13.1) und vier Build-Types (Debug/Release/MinSizeRel/RelWithDebInfo) validiert. Pro Kombination werden alle 43 Smoke-Permutationen plus die Diplomarbeit-Test-Suite (104 Tests) gebaut. Das ist relevant für die Diplomarbeit, weil die Cluster-Hardware (vermutlich Linux/GCC) ein anderes Compile-Profil hat als die lokale Entwicklungsumgebung (Windows/MSVC). Eine ABI-Inkonsistenz zwischen MinGW und MSVC würde bei einem Cluster-Push erst dort sichtbar. Die V37.A-Matrix verifiziert lokal die wesentlichen Toolchain-Kombinationen.

## §6 Profile-Stufung (V37.B → Kapitel "Skalierungs-Strategie")

Drei Profile-Stufen mit klarem Trade-off: smoke (~27 Permutationen, < 1 Minute Build) für Routine-Entwicklung; medium (~144 Permutationen, mehrere Minuten) für Stage-Tests; full (alle Host-kompatiblen, dauert länger, auf x86_64 derzeit identisch mit medium bis weitere Achsen-Varianten ergänzt sind) für vollständige Messreihen. Die Skalierungs-Strategie spiegelt die Memory-Direktive "Permutations-Explosion ~5.5 Mrd → ca. 100 Mrd+ → Profile-Filter Pflicht" wider. Der Constraint-Filter (`_perm_host_supports_isa`) entfernt z.B. NEON auf x86_64-Hosts, was die Vollkombinations-Zahl drastisch reduziert.

## §7 Runtime-Manifest-Integration (V37.C → Kapitel "messung_driver-Architektur")

Der Experiment-Driver muss wissen welche Permutationen gebaut wurden, um über sie zu iterieren. Codegen schreibt ein Manifest (`permutations_manifest.txt` + `prt_art_permutations_manifest.txt`) das die ID jedes Per-Permutation-Targets listet. Zur Compile-Zeit werden die Pfade über `target_compile_definitions(... COMDARE_PERMUTATIONS_MANIFEST_CE/PA=...)` durchgereicht. Zur Laufzeit liest `load_all_permutations()` beide Manifeste und liefert ein `vector<PermutationEntry>` mit ID und Subsystem-Kennzeichen. In V37.C steht zunächst nur ein Inventar-Log, in Phase 6+ würde hier pro Permutation der `extern "C" perm_<id>_run(n_ops, &micros)` Hook aufgerufen (s. V37.D).

## §8 Algorithmus-Body-Skelett (V37.D → Kapitel "Mess-Methodik")

V37.D etabliert pro Permutation einen Mikro-Benchmark-Slot: `extern "C" int perm_<id>_run(unsigned long n_ops, double* out_micros_per_op)`. In V37.D ist der Body ein noop-Loop (volatile Akkumulator) — bewusst trivial, weil der Zweck die Etablierung der Schnittstelle ist, nicht die Messung selbst. Phase 6+ ersetzt den noop-Loop durch echte Aufrufe von cache_engine::*- bzw. prt_art::*-Funktionen entlang der Achsen-Defines. Die Trennung zwischen Schnittstelle (jetzt) und Body (später) erlaubt es, die Mess-Infrastruktur (Manifest, Iteration, Statistik) unabhängig von der algorithmischen Substanz zu validieren.

## §9 Was offen bleibt (V37.G + Phase 6+)

- **Hierarchischer Achsen-Ordnerbaum** mit drei Wurzeln (cache_engine, prt_art, all) gemäß User-Direktive 2026-05-23 (V37.G letzte Aufgabe).
- **Dynamisch ladbare C++-Module** (.dll/.so + dlopen statt aktueller STATIC libs) — Phase 6+ Architektur-Migration.
- **Echte Algorithmus-Bodies** in den Wrappers (jetzt noch noop-Loop).
- **Compiler/BuildType als Beschriftung** statt als Build-Dir-Pfad — Vereinfachung der Permutation-Identitaet (V37.G).
- **Cluster-Integration** (HAProxy, Samba AD DNS, GitLab Push) — wartet auf Cluster-Termin.

---

## §10 Code-Anker

| Komponente | Pfad |
|---|---|
| cache-engine Codegen | `external/comdare-cache-engine/tools/permutation_codegen/codegen.cmake` |
| cache-engine Achsen-Versionen | `external/comdare-cache-engine/tools/permutation_codegen/axes_versions.txt` |
| prt-art Codegen | `external/comdare-prt-art/prt_art/permutations_codegen/codegen.cmake` |
| prt-art Achsen-Versionen | `external/comdare-prt-art/prt_art/permutations_codegen/axes_versions.txt` |
| Runtime-Check | `Code/02_messung_driver/permutations_runtime_check.hpp` |
| messung_driver Integration | `Code/02_messung_driver/main.cpp` |
| Container-Konfiguration | `Code/CMakeLists.txt` (Default-ON, Mode-Defaults) |
| Build-Presets | `Code/CMakePresets.json` (8 Standard-Presets) |
