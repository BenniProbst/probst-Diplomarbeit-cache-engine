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

Deterministischer Textplan des `ExperimentPlanDirector`-Walks. **W10/§42: der Walk ist dreistufig** —
Mess-Achsen-Kombination → System-Permutation (opt × simd) → Chunk-Bündel. Zwei Läufe sind byte-gleich.

```bash
"$DRIVER" --dump-plan "$PROFILE" | head
```

Kopf: `# comdare-experiment-plan v1`, `source_kind=thesis`, `measurement_combo_count=1`,
`measurement_combo 0 legend=[all]` (die Anwender-XML deklariert alle 16 `<measurement_categories>` →
EIN CEB-Typ `[all]`), `perm_count=4` (2 opt O2/O3 × 2 SIMD no_extension/avx2 = 4 System-Permutationen
**je Mess-Kombination**).

---

## 4. Die dreistufige Kette (`--dump-cmake` → CEB → `--emit-tier-cmake`)

Die CE erhält die XML und **steuert alles** (§42). Der Bare-Metal-Bau ist deshalb dreistufig:

| Stufe | Rolle | Kommando | Was |
|-------|-------|----------|-----|
| 1 | Planer | `--dump-cmake` | je Mess-Kombination `[a,b,c]` ein CEB-Bau- + CEB-Emit-Target |
| 2 | CEB | `--emit-tier-cmake` (von Stufe 1 aufgerufen) | je System-Perm `[d,e,f]` die Tier-Chunk-Bau-Targets |
| 3 | Mess-Job | (GN-11/320er-gated) | `measure:[a,b,c][d,e,f][g,h,i]` — Skelett, **kein** Auto-Messlauf |

Stufe 1 emittieren (Planer-Rolle):

```bash
"$DRIVER" --dump-cmake "$PROFILE" > /tmp/experiment_plan.cmake
```

Konfigurierbare Eingaben (per `-D` überschreibbar):

| Variable | Default | Bedeutung |
|----------|---------|-----------|
| `COMDARE_PLAN_DRIVER`   | `comdare-messung-driver` (PATH-Suche) | Pfad/Name des Treibers / der CEB |
| `COMDARE_PLAN_PROFILE`  | *(leer → Treiber-Default-Profil)* | Thesis-/Experiment-Profil-XML |
| `COMDARE_PLAN_TIER_OUT` | `<bindir>/tier_plans` | Ausgabe-Wurzel für die emittierten Stufe-2-`.cmake` |
| `COMDARE_PLAN_RANGE`    | `0:4` (sicher klein) | golden-N Chunk-Fenster `start:count` (Stufe 2) |
| `COMDARE_PLAN_OUT`      | `<bindir>/tier/out` | Ausgabe-Wurzel der provision-DLLs (Stufe 2) |

---

## 5. Den emittierten Plan abfahren (Bare-Metal-Bau, **ohne GitLab**)

Der emittierte `.cmake` ist ein Fragment (`add_custom_command`/`add_custom_target`). Ein Minimal-Wrapper
inkludiert ihn; `cmake` konfiguriert und baut. Die Kette hat **zwei cmake-Konfigurationen** (Stufe 1 → 2).

### 5a. Stufe 1: CEB-Emit-Target bauen → erzeugt den Stufe-2-Plan

```bash
WORK=/tmp/w10_baremetal
rm -rf "$WORK"; mkdir -p "$WORK"
cp /tmp/experiment_plan.cmake "$WORK/experiment_plan.cmake"
cat > "$WORK/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(comdare_bare_metal_stage1 NONE)
include(${CMAKE_CURRENT_SOURCE_DIR}/experiment_plan.cmake)
EOF

cmake -S "$WORK" -B "$WORK/b1" \
  -DCOMDARE_PLAN_DRIVER="$DRIVER" \
  -DCOMDARE_PLAN_PROFILE="$PROFILE" \
  -DCOMDARE_PLAN_TIER_OUT="$WORK/tier_plans"

# Der CEB-Emit-Schritt ruft --emit-tier-cmake -> emittiert den Stufe-2-Plan (Slug von [all] = _all_).
cmake --build "$WORK/b1" --target comdare_ceb_emit__all_
ls "$WORK/tier_plans/"   # -> tier_plan__all_.cmake
```

### 5b. Stufe 2: die Tier-Binaries bauen (provision-only, kleines Fenster)

```bash
S2="$WORK/stage2"; mkdir -p "$S2"
cp "$WORK/tier_plans/tier_plan__all_.cmake" "$S2/tier_plan.cmake"
cat > "$S2/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.20)
project(comdare_bare_metal_stage2 NONE)
include(${CMAKE_CURRENT_SOURCE_DIR}/tier_plan.cmake)
EOF

cmake -S "$S2" -B "$S2/b" \
  -DCOMDARE_PLAN_DRIVER="$DRIVER" \
  -DCOMDARE_PLAN_PROFILE="$PROFILE" \
  -DCOMDARE_PLAN_RANGE="0:4" \
  -DCOMDARE_PLAN_OUT="$S2/out"

# Bauen: perm0/chunk0 (O2/no_extension), provision-only (baut DLLs, misst NICHT)
cmake --build "$S2/b" --target comdare_tier_build_perm0_chunk0
find "$S2/out" -name 'perm.dll' | wc -l
```

Andere Stufe-2-Ziele:

- `comdare_tier_build_perm<i>_chunk<k>` — eine Zelle: Perm `i` (0..3) × Chunk `k` (0..3).
- `comdare_tier_measure_perm<i>` — der GN-11/320er-gegatete `measure:`-Schritt (Echo-Skelett, **kein** Messlauf).
- `comdare_tier_plan_all` — Aggregat (alle `measure:`-Targets → transitiv alle `tier:build`-Targets).

### Wo die DLLs/Logs liegen

- **Tier-DLLs** (provision-only): `"$COMDARE_PLAN_OUT"/_all_/perm<i>/chunk<k>/e4_xml/dll/**/perm.dll`.
- **Build-Stamp** (CMake-Idempotenz): `"$S2"/b/tier/_all__perm<i>_chunk<k>.build.stamp`.

---

## Was heute literal geht — und was gated ist

**Literal verifiziert (2026-07-19, dieser Handlauf):**

- `--validate` → rc 0 (17 Achsen / 34 Werte / 2 opt × 2 simd / 16 measurement_categories).
- `--dump-plan` / `--dump-cmake` / `--dump-ci` / `--emit-tier-ci` / `--emit-tier-cmake` → je rc 0,
  byte-deterministisch.
- **Bare-Metal-Kette (dreistufig)**: Stufe 1 (`--dump-cmake` + `comdare_ceb_emit__all_`) erzeugt den
  Stufe-2-Plan; Stufe 2 (`comdare_tier_build_perm0_chunk0`, Range 0:4, O2/no_extension): **rc 0 in ~82 s**,
  **69 `perm.dll`** kompiliert (provision-only, `measured=0`).
  → Das ist der §42-Erfüllungs-Beweis: identischer, **CE-gesteuerter** dreistufiger Bau **ohne GitLab-CI**.

**Bewusst gated (kein Auto-Lauf):**

- **Messen** ist GN-11/320er-gegatet: der `measure:`-Schritt (Stufe 3) im emittierten Plan ist ein
  Echo-/Skelett-Schritt. Das echte Mess-Kommando (`COMDARE_GOLDEN_N_PROVISION_ONLY` entfernt) steht nur als
  Kommentar-Skelett und wird erst nach dem GN-11-Entscheid des Users scharfgeschaltet.
- **Voller 2^17-Satz je Zelle** ist INC-G6-gegatet (GN-2-Compile-Time-Guard). `COMDARE_PLAN_RANGE` fenstert
  bewusst klein; die vier `chunk<k>`-Targets bündeln den Organ-Raum (2^17 Einzel-Jobs wären keine Legende).
- **avx512** setzt eine avx512-fähige CPU voraus (SIMD-Flag-Signatur, §40.a); der `no_extension`-/`avx2`-
  Kernsatz läuft überall.

---

## Anhang: dieselbe Kette in der CI (`--dump-ci` → `--emit-tier-ci`)

`--dump-ci` emittiert die **STUFE 1** (Planer-Rolle) als GitLab-Child-Pipeline-YAML (CiYamlBuilder, §42):
je Mess-Kombination `[a,b,c]` die CEB-Jobs `ceb:build`/`ceb:emit`/`ceb:trigger`. Die `ceb:emit`-Jobs rufen
`--emit-tier-ci` → die CEB emittiert **STUFE 2** (System-Perms + Tier-Chunk-Jobs + gegatete Mess-Jobs) als
Grandchild-Pipeline (parent → child → grandchild = GitLab-Nesting-Tiefe 2).

```bash
"$DRIVER" --dump-ci "$PROFILE" > /tmp/planer-child-ci.yml       # Stufe 1 (CEB-Jobs)
"$DRIVER" --emit-tier-ci "$PROFILE" > /tmp/tier-child-ci.yml    # Stufe 2 (Tier-Chunk-/Mess-Jobs)
```

In der CI fährt das der Job **`planer:delegate`** (Stage `planer`, NEUER Standard-Pfad hinter
`COMDARE_BUILD_GOLDEN_N`) + `planer:delegate-trigger`; das Ergebnis-Holen liegt in `ergebnis:holen`
(Skelett auf `persist:measurements`-Grundlage). Die statische 24-Zellen-Matrix (`build:golden-n`) bleibt
als **DEPRECATED Fallback** (`COMDARE_STATIC_MATRIX_FALLBACK=true`, Default AUS) — nicht gelöscht,
Pilot-Historie. Das emittierte Child-YAML muss vor dem Scharfschalten **per GitLab-CI-Lint** geprüft
werden (Architekt; nicht im Handlauf abgedeckt).
