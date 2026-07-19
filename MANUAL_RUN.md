# MANUAL_RUN — Bare-Metal-Handlauf ohne GitLab-CI (§40.c / §0-DoD5 / #193)

Diese Anleitung führt den Planer-→CEB-→Tier-Bau **ohne GitLab-CI** aus, rein auf der Kommandozeile.
Sie erfüllt die Ledger-Voraussetzung §40.c (Bare-Metal-Pflicht: „der identische Bau MUSS auch OHNE
GitLab-CI laufen"). Der Weg ist der **offizielle** (CMake/ctest, keine Behelfswege): der Planer
emittiert einen deterministischen CMake-Bauplan, den `cmake` selbst abfährt.

Alle Schritte unten wurden am 2026-07-19 auf einem Ubuntu-24.04-Host (g++-16, cmake 4.3.4, ninja 1.13.1)
literal ausgeführt; die Zahlen im Abschnitt „Was heute literal geht" sind der Beweis-Lauf.

---

## 0. Voraussetzungen (Toolchain)

| Werkzeug | getestete Version | Zweck |
|----------|-------------------|-------|
| `g++`    | g++-16 (16.0.1)   | Kompilation des Treibers + der Tier-DLLs (C++23) |
| `cmake`  | ≥ 3.20 (getestet 4.3.4) | Bau des Treibers + Abfahren des emittierten Plans |
| `ninja`  | 1.13.1            | Generator für den Treiber-Bau |

Prüfen:

```bash
g++ --version   # muss C++23 können (g++-16)
cmake --version # >= 3.20
ninja --version
```

Pfade (relativ zur super-Repo-Wurzel `probst-diplomarbeit-cache-engine/`):

- **ce-Submodul**: `Code/external/comdare-cache-engine`
- **golden-Profil**: `Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml`

---

## 1. Treiber bauen (`comdare-messung-driver`)

```bash
cd Code
cmake -B build-w5b -G Ninja -DCOMDARE_V32_ENABLE=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build-w5b --target comdare-messung-driver
```

Der Treiber liegt danach unter `Code/build-w5b/02_messung_driver/comdare-messung-driver`.
Alle folgenden Kommandos setzen zwei Shell-Variablen voraus:

```bash
DRIVER=$(readlink -f build-w5b/02_messung_driver/comdare-messung-driver)
PROFILE=$(readlink -f external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml)
```

---

## 2. Pre-Flight-Validat (`--validate`, rein lesend)

Prüft das Profil gegen die realen `AxisRegistry`/`EnabledStrategies` — **baut nichts, misst nichts**.

```bash
"$DRIVER" --validate "$PROFILE"
```

Erwartete Ausgabe (rc = 0):

```
=== PROFIL-VALIDAT (rein-lesend; KEIN DLL-Bau, KEINE Messung) ===
  Profil id=all_axes_golden schema_version=1
  geprueft: 17 Achsen, 34 Werte, 17 axis_sweeps, 21 sota_series, 6 workloads, 2 datasets, 16 measurement_categories, 2 opt_levels, 2 simd
VALIDAT OK: das Profil ist gegen die AxisRegistry/EnabledStrategies konsistent.
```

---

## 3. Plan ansehen (`--dump-plan`, rein lesend)

Deterministischer Textplan des `ExperimentPlanDirector`-Walks (opt × simd × Sweep-Passes). Zwei Läufe
sind byte-gleich. Rein lesend.

```bash
"$DRIVER" --dump-plan "$PROFILE" | head
```

Kopf: `# comdare-experiment-plan v1`, `source_kind=thesis`, `perm_count=4`
(2 opt-Level O2/O3 × 2 SIMD no_extension/avx2 = 4 System-Permutationen).

---

## 4. CMake-Bauplan emittieren (`--dump-cmake`)

Der **scharfe** CMake-Bauplan (W7-B/§40.c): pro System-Permutation ein echtes provision-only-Treiber-
Kommando (`build:`-Ziel) + ein GN-11-gegatetes `measure:`-Skelett. Host-unabhängig: Treiber/Profil/Range/Out
sind CMake-Variablen mit Defaults, nur opt/simd sind Plan-Konstanten (Literale).

```bash
"$DRIVER" --dump-cmake "$PROFILE" > /tmp/experiment_plan.cmake
```

Konfigurierbare Eingaben (per `-D` überschreibbar):

| Variable | Default | Bedeutung |
|----------|---------|-----------|
| `COMDARE_PLAN_DRIVER`  | `comdare-messung-driver` (PATH-Suche) | Pfad/Name des Treibers |
| `COMDARE_PLAN_PROFILE` | *(leer → Treiber-Default-Profil)* | Thesis-/Experiment-Profil-XML |
| `COMDARE_PLAN_RANGE`   | `0:4` (sicher klein) | golden-N Chunk-Fenster `start:count` |
| `COMDARE_PLAN_OUT`     | `<bindir>/experiment_plan/out` | Ausgabe-Wurzel der provision-DLLs |

---

## 5. Den emittierten Plan abfahren (Bare-Metal-Bau, **ohne GitLab**)

Der emittierte `.cmake` ist ein Fragment (`add_custom_command`/`add_custom_target`). Ein Minimal-Wrapper
inkludiert ihn; `cmake` konfiguriert und baut dann ein kleines Fenster einer Permutation.

```bash
WORK=/tmp/w7_baremetal
mkdir -p "$WORK"
cp /tmp/experiment_plan.cmake "$WORK/experiment_plan.cmake"
cat > "$WORK/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(comdare_bare_metal_plan NONE)
include(${CMAKE_CURRENT_SOURCE_DIR}/experiment_plan.cmake)
EOF

# Konfigurieren: kleines Fenster Range 0:4, perm0 = O2/no_extension
cmake -S "$WORK" -B "$WORK/build" \
  -DCOMDARE_PLAN_DRIVER="$DRIVER" \
  -DCOMDARE_PLAN_PROFILE="$PROFILE" \
  -DCOMDARE_PLAN_RANGE="0:4" \
  -DCOMDARE_PLAN_OUT="$WORK/out"

# Bauen: nur perm0 (O2/no_extension), provision-only (baut DLLs, misst NICHT)
cmake --build "$WORK/build" --target comdare_experiment_plan_build_perm0
```

Andere Ziele:

- `comdare_experiment_plan_build_perm<i>` — eine einzelne Permutation `i` (0..3).
- `comdare_experiment_plan_all` — alle Permutationen (Aggregat; via `measure:`-Kante transitiv auch
  `build:`; der `measure:`-Schritt bleibt aber GN-11-gegatet = nur Echo, **kein** Messlauf).

### Wo die DLLs/Logs liegen

- **Tier-DLLs** (provision-only): `"$COMDARE_PLAN_OUT"/perm<i>/e4_xml/dll/**/perm.dll`
  (im Beispiel: `/tmp/w7_baremetal/out/perm0/e4_xml/dll/.../perm.dll`).
- **Provision-Log/CSV-Kopf**: `"$COMDARE_PLAN_OUT"/perm<i>/e4_xml/measurements.csv`
  (bei provision-only ohne Messzeilen — `measured=0`).
- **Build-Stamp** (CMake-Idempotenz): `"$WORK"/build/experiment_plan/perm<i>.build.stamp`.

DLLs zählen:

```bash
find "$WORK/out" -name 'perm.dll' | wc -l
```

---

## Was heute literal geht — und was gated ist

**Literal verifiziert (2026-07-19, dieser Handlauf):**

- `--validate` → rc 0 (17 Achsen / 34 Werte / 2 opt × 2 simd).
- `--dump-plan` / `--dump-cmake` / `--dump-ci` → je rc 0, byte-deterministisch.
- **Bare-Metal-Bau** `comdare_experiment_plan_build_perm0` (Range 0:4, O2/no_extension):
  **rc 0 in ~94 s**, **69 `perm.dll`** kompiliert (provision-only, `measured=0`), Build-Stamp gesetzt.
  → Das ist der §40.c-Erfüllungs-Beweis: identischer Bau **ohne GitLab-CI**.

**Bewusst gated (kein Auto-Lauf):**

- **Messen** ist GN-11-gegatet: der `measure:`-Schritt im emittierten Plan ist ein Echo-/Skelett-Schritt.
  Das echte Mess-Kommando (`COMDARE_GOLDEN_N_PROVISION_ONLY` entfernt) steht nur als Kommentar-Skelett und
  wird erst nach dem GN-11-Entscheid des Users scharfgeschaltet.
- **Voller 2^17-Satz je Permutation** ist INC-G6-gegatet (GN-2-Compile-Time-Guard). `COMDARE_PLAN_RANGE`
  fenstert deshalb bewusst klein; ein Voll-Bau erfordert die gestaffelte/Storage-gated Materialisierung.
- **avx512** setzt eine avx512-fähige CPU voraus (SIMD-Flag-Signatur, §40.a); der `no_extension`-/`avx2`-
  Kernsatz läuft überall.

---

## Anhang: dieselbe Kette in der CI (`--dump-ci`)

`--dump-ci` emittiert dieselbe Perm-Menge als **GitLab-Child-Pipeline-YAML** (CiYamlBuilder, §40.b):
STUFE 1 = CEB-Bau-Jobs je System-Permutation, STUFE 2 = Tier-Job-Emitter + Grandchild-Trigger.

```bash
"$DRIVER" --dump-ci "$PROFILE" > /tmp/planer-child-ci.yml
```

In der CI fährt das der inerte Job `planer:emit-ci` (Stage `planer`, opt-in `COMDARE_DYNAMIC_PLANER_CI=true`)
+ `planer:trigger-ci`. Die statische 24-Zellen-Matrix (`build:golden-n`) bleibt als Pilot-Fallback erhalten.
Das emittierte Child-YAML muss vor dem Scharfschalten **per GitLab-CI-Lint** geprüft werden (nicht im
Handlauf abgedeckt).
