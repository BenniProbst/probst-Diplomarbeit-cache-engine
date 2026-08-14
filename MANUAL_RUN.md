# MANUAL_RUN — Master-Manual des Mess-Werkzeugs (§40.c / V-6, „ein Werkzeug, ein Manual")

**Stand: 2026-07-27 (Bauplan TEIL V Paket V-6).** Dieses Manual ist der **Master** für den kompletten
Planer-→CEB-→Tier-→Mess-Weg **ohne GitLab-CI** (Bare-Metal-Pflicht §40.c) und für die CI-Anwendung
desselben Kanals. Es ersetzt die Fassung vom 2026-07-19 (git-Historie; damals hießen die Stufe-2-Targets
noch `comdare_tier_build_perm<i>_chunk<k>` und der Mess-Schritt war ein Echo-Skelett — beides ist seit
§62-B/S5-P2 überholt). Übergangs-Dokumente: `Code/MANUAL_RUN.md` (Alt-Kanal, fällt mit V-3/V-4),
`Code/external/comdare-cache-engine/MANUAL_RUN.md` (ce-Demo-Treiber).

Das Werkzeug ist **ein Binary in zwei Rollen** (`comdare-messung-driver`): die **Planer-Rolle** (`plan …`,
Stufe 1) und die **CEB-Rolle** (`tier …`, Stufe 2). Seit V-6 gilt die **clig.dev-Subcommand-Form**;
die alten `--dump-*`/`--emit-*`-Flags bleiben funktionale DEPRECATED-Aliase (sie fallen erst im
Abschluss-Aufräumpass, Ledger §75).

---

## 1. Toolchain installieren (Floor-Tabelle, kein Pin)

| Werkzeug | Anforderung | Bemerkung |
|----------|-------------|-----------|
| `g++`    | **≥ 15.3** (Minimum **und** Standard) | Toolchain-FLOOR (Ledger §73.4): kein Versions-Pin, neuere g++ zugelassen. CMake erzwingt den Floor hart (FATAL_ERROR) in super **und** ce. |
| `cmake`  | **≥ 3.28** | reales Minimum beider `cmake_minimum_required` + `CMakePresets.json` (getestet: 4.3.4) |
| `ninja`  | empfohlen | Generator der Presets (getestet: 1.13.1) |
| Boost.Mp11 | **vendored, Pflicht** | liegt im Repo: `Code/external/comdare-cache-engine/cmake/third_party/boost_mp11/include` — keine Installation nötig (§2) |

**Ubuntu-Installationsweg (prod1/prod2-Standard):** GCC 15/16 kommen auf Ubuntu offiziell über das
Toolchain-PPA `ppa:ubuntu-toolchain-r/test` (versionierte Pakete, parallel installierbar):

```bash
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update && sudo apt install g++-16 cmake ninja-build
g++ --version    # >= 15.3 (Floor); Flotte aktuell: 16.x
cmake --version  # >= 3.28
```

Die **exakte installierte Paketversion dokumentieren** (das PPA heißt ausdrücklich „test builds",
Pakete sind mutabel) — bei Reproduktionsbedarf per apt-Pinning festhalten.

**CI == baremetal (Doku, Umsetzung = Infra-Handout):** Die buildtools-Container der CI müssen den
**identischen** Installationsweg nutzen (gleiches PPA, gleiche Versionsnummern) und per
**Digest-Pinning** (`@sha256:…`) referenziert werden; das offizielle `gcc`-Docker-Image ist nur zweite
Wahl (Debian-Basis bricht die CI==baremetal-Prämisse). Der Gleichheits-Anker in beiden Welten ist der
CMake-Versions-Assert (V-6iii, s. o.) — ein falscher Compiler stirbt beim Configure, nicht erst im Lauf.

## 2. Repo + Vendor (mp11-Pflichtpfad)

```bash
git clone --recursive <super-repo-url> probst-diplomarbeit-cache-engine
cd probst-diplomarbeit-cache-engine
ls Code/external/comdare-cache-engine/cmake/third_party/boost_mp11/include   # MUSS existieren
```

Mp11 ist **stets** die Metaprogrammierungs-Erweiterung (Ledger §73.4; P2996-Reflection ist bewusst
NICHT vorausgesetzt). Fehlt der Pfad, ist der Klon nicht rekursiv — `git submodule update --init --recursive`.

## 3. Bauen (Preset-Weg) + Installieren

```bash
cd Code
cmake --workflow --preset gcc-release        # V-6ii: Configure -> Build -> Test in EINEM Kommando
# oder klassisch:
cmake --preset gcc-release && cmake --build --preset gcc-release
```

Für den Treiber-Fokus (CI-identische test:unit-Konfiguration) bleibt der explizite Weg gültig:

```bash
cmake -S . -B build-test -DCOMDARE_DA_BUILD_TESTS=ON -DCOMDARE_V32_ENABLE=ON
cmake --build build-test --target messung_driver
cmake --build build-test --target comdare_experiment_planner   # W1: die PLANER-Binary (ce-Target)
DRIVER=$(readlink -f build-test/02_messung_driver/comdare-messung-driver)
PLANNER=$(readlink -f build-test/_cache_engine_external/apps/experiment_planner/comdare-experiment-planner)
PROFILE=$(readlink -f external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml)
```

**ZWEI BINARIES seit W1 (05.08.2026, Owner-KERN):** die **PLANER**-Rolle (Stufe 1: `validate`,
`plan dump/ci/cmake`, `cache-key`, `fingerprint`) lebt in `comdare-experiment-planner` (ce-Target
`comdare_experiment_planner`); die **CEB**-Rolle (Stufe 2: `tier ci/cmake`) und der Mess-Vollzug
(`run`) bleiben im `comdare-messung-driver`. Zwei Module über *dieselbe* Fassaden-Bibliothek —
keine Vererbung, kein doppelter Code. Der Treiber beantwortet die gewanderten Wörter mit einer
Verweis-Zeile und `rc 1` (fail-loud, kein stilles Durchfallen in den `run`-Pfad).

*Historie (nie gelöscht):* bis W1 trug `comdare-messung-driver` beide Rollen samt der DEPRECATED
Alt-Flags `--validate`/`--check`/`--dump-plan`/`--dump-ci`/`--dump-cmake`/`--print-cache-key`/
`--chunk-organ-fingerprint`. Die neue Planer-Binary erbt diese Aliase bewusst **nicht**.

**Installieren (V-6i):** die Mess-Auswerte-Kette (Treiber + `binary-to-csv` + `csv-to-latex` +
`diagram-generator`) trägt `install()`-Targets (GNUInstallDirs):

```bash
cmake --build build-test --target messung_driver comdare_experiment_planner binary_to_csv_cli csv_to_latex_cli diagram_generator_cli
cmake --install build-test --prefix "$HOME/.local"    # -> <prefix>/bin/comdare-messung-driver + comdare-experiment-planner usw.
"$HOME/.local/bin/comdare-messung-driver" version     # rc 0 = Installationspfad funktioniert
"$HOME/.local/bin/comdare-experiment-planner" version # rc 0 = Planer-Binary installiert (W1)
```

> Codex-Zweitblick 05.08.2026: `cmake --install` baut nichts nach — die Planer-Binary MUSS im
> Partial-Build-Target-Satz stehen (Zeile oben), sonst scheitert die `install(PROGRAMS)`-Naht im
> frischen Tree an der fehlenden Datei. Der volle `--target all`-Bau deckt sie ohnehin.

**Hinweis CMake-Options vs. XML (Ledger §73.5):** alle `COMDARE_*`-CMake-Options sind der **optionale
Baremetal-Fallback ohne CI**; die Experiment-XML mit dem Planer **überschreibt STETS** die
Default-Optionen (XML gewinnt immer).

## 4. Validieren (`validate`, rein lesend)

```bash
"$PLANNER" validate "$PROFILE"     # W1: Planer-Binary (bis W1: "$DRIVER" validate / --validate)
```

Prüft beide offiziellen Profil-Wurzeln (`<comdare_thesis_profile>` → Achsen-/Werte-Gate;
`<comdare_experiment>` → 3-Phasen-Gate gegen die einkompilierten ce+prt-Registry-Pfade). Baut nichts,
misst nichts. Profil-Auflösung überall gleich: Argument > `COMDARE_THESIS_PROFILE` > einkompiliertes
Default-Profil (`m3v2_study.profile.xml`). Exit 0 = konsistent; Exit 5 = unbekannte Wurzel.

## 5. Planen (`plan dump` / `plan cmake` / `plan ci` — Stufe 1, Planer-Rolle)

Der deterministische `ExperimentPlanDirector`-Walk (zwei Läufe sind byte-gleich) in drei Kanälen:

```bash
"$PLANNER" plan dump  "$PROFILE" | head            # Textplan (bis W1: "$DRIVER" / --dump-plan)
"$PLANNER" plan cmake "$PROFILE" > /tmp/experiment_plan.cmake  # Bare-Metal-Bauplan (bis W1: --dump-cmake)
"$PLANNER" plan ci    "$PROFILE" > /tmp/planer-child-ci.yml    # GitLab-Child-YAML (bis W1: --dump-ci)
```

Plan-Kopf heute: `# comdare-experiment-plan v1.1`, `profile axes=18 values=31` (golden-Profil).
`plan ci`/`plan cmake` tragen das Bestandslog-`planer_block`-Gate: bei `COMDARE_BESTANDSLOG=true`
sind `COMDARE_BESTANDSLOG_DOC_KEY`/`_OWNER_UUID`/`_MASCHINE` Pflicht (sonst Exit 6); ohne
`COMDARE_BESTANDSLOG` ist das Gate stumm inert.

## 6. Tier-Bau (Stufe 1 → Stufe 2, CEB-Rolle)

Die CE erhält die XML und steuert alles (§42): `plan cmake` emittiert je Mess-Kombination ein
CEB-Bau- und ein CEB-Emit-Target; das Emit-Target ruft `tier cmake` und erzeugt den Stufe-2-Plan.

**Stufe 1 abfahren** (Fragment-Wrapper, zwei cmake-Konfigurationen):

```bash
WORK=/tmp/w10_baremetal; rm -rf "$WORK"; mkdir -p "$WORK"
cp /tmp/experiment_plan.cmake "$WORK/experiment_plan.cmake"
printf 'cmake_minimum_required(VERSION 3.28)\nproject(comdare_bare_metal_stage1 NONE)\ninclude(${CMAKE_CURRENT_SOURCE_DIR}/experiment_plan.cmake)\n' > "$WORK/CMakeLists.txt"
cmake -S "$WORK" -B "$WORK/b1" -DCOMDARE_PLAN_DRIVER="$DRIVER" -DCOMDARE_PLAN_PROFILE="$PROFILE" -DCOMDARE_PLAN_TIER_OUT="$WORK/tier_plans"
cmake --build "$WORK/b1" --target comdare_ceb_emit__all_     # ruft 'tier cmake' -> tier_plan__all_.cmake
```

Stufe-1-Targets: `comdare_ceb_build__all_`, `comdare_ceb_emit__all_`, Aggregat `comdare_experiment_plan_all`
(Slug `_all_` = die eine Mess-Kombination `[all]` des golden-Profils).

**Stufe 2 konfigurieren** (Tier-Plan als Fragment, identisches Wrapper-Muster):

```bash
S2="$WORK/stage2"; mkdir -p "$S2"
cp "$WORK/tier_plans/tier_plan__all_.cmake" "$S2/tier_plan.cmake"
printf 'cmake_minimum_required(VERSION 3.28)\nproject(comdare_bare_metal_stage2 NONE)\ninclude(${CMAKE_CURRENT_SOURCE_DIR}/tier_plan.cmake)\n' > "$S2/CMakeLists.txt"
cmake -S "$S2" -B "$S2/b" -DCOMDARE_PLAN_DRIVER="$DRIVER" -DCOMDARE_PLAN_PROFILE="$PROFILE" \
  -DCOMDARE_PLAN_RANGE="0:4" -DCOMDARE_PLAN_OUT="$S2/out"
```

**Stufe-2-Targets (§62-B Host-Lane-Batches — lösen die frühere `perm<i>_chunk<k>`-Form ab):**

| Target | Wirkung |
|--------|---------|
| `comdare_tier_batch_<host>`   | **Bau+Prüf-Batch** der Host-Lane: je System-Perm provision-only-DLL-Bau (`COMDARE_GOLDEN_N_PROVISION_ONLY=true`) + S3-Konformitäts-Prüfpass (`COMDARE_PRUEF_ONLY=true`) — baut, misst NICHT |
| `comdare_tier_measure_<host>` | **Mess-Batch (S5-P2 SCHARF — misst real!)**, hängt am Bau-Stamp (Bau→Mess-Kante) |
| `comdare_tier_plan_all`       | Aggregat über die Mess-Targets aller Lanes |

`<host>` ist die Host-Lane der CEB (`amd`/`intel`, §62-B). **Welche Lane-Targets existieren, bestimmt
das Profil** (golden-Profil: `amd` **und** `intel`; `m3v2_study`-Default: nur `amd`) — gebaut und
gemessen wird der Batch der **eigenen** Lane. Provisions-Bau (baut DLLs, misst nicht):

```bash
cmake --build "$S2/b" --target comdare_tier_batch_amd
find "$S2/out" -name 'perm.dll' | wc -l
```

*Literal-Beweis dieser Fassung (2026-07-27, golden-Profil, Range 0:4, amd-Lane): rc 0 in ~2 m 46 s,
138 `perm.dll` provision-only (`measured=0`).*

Variablen der Stufe 2: `COMDARE_PLAN_DRIVER`, `COMDARE_PLAN_PROFILE`, `COMDARE_PLAN_RANGE`
(`start:count`-Chunk-Fenster, klein anfangen), `COMDARE_PLAN_OUT` (DLL-/Mess-Wurzel),
`COMDARE_PLAN_MEASURE_PARALLEL` (Thread-Zahl NUR für den DLL-Bau im Mess-Batch).

*Historie: der Beweis-Lauf der Vorfassung (2026-07-19, damalige `perm0_chunk0`-Zelle, Range 0:4) baute
69 `perm.dll` in ~82 s — die Kette selbst ist unverändert dreistufig, nur die Target-Schnitte sind
seit §62-B Lane-Batches.*

## 7. Echter Messlauf (Stufe 3 — SCHARF, bewusst starten)

**Seit S5-P2 ist der Mess-Schritt KEIN Echo-Skelett mehr:** `comdare_tier_measure_<host>` führt je
System-Perm einen **realen Mess-COMMAND** aus (ohne `COMDARE_GOLDEN_N_PROVISION_ONLY` ⇒ es wird
gemessen) und schreibt **eine CSV je Zelle** nach `${COMDARE_PLAN_OUT}/measure/<slug>/perm<idx>/`.

```bash
# Mess-Betrieb: Maschine ruhig stellen (Mess-Doktrin §61: DLL-Bau parallel, MESSEN 1-Thread)
cmake --build "$S2/b" --target comdare_tier_measure_amd
find "$S2/out/measure" -name '*.csv'
```

Env-Pins des Mess-COMMANDs (vom Plan gesetzt, hier zur Kontrolle): `COMDARE_THESIS_PROFILE`,
`COMDARE_GOLDEN_N_RANGE` (= `COMDARE_PLAN_RANGE`), `COMDARE_GN_OPT`, `COMDARE_GN_SIMD`,
`COMDARE_BUILD_PARALLEL` (= `COMDARE_PLAN_MEASURE_PARALLEL`), `COMDARE_RUN_SOTA=0`.
Host-seitige Wachen: `COMDARE_PLATFORM` mit Lane-Präfix (`amd@<host>`/`intel@<host>`) aktiviert die
**Lane-Wache** (CPU-Vendor per CPUID; Fehlrouting = Exit 7 VOR der Messung); `COMDARE_MIN_FREE_GB`
setzt die RAM-Admission. Debug-Builds fahren zusätzlich einen Release-Provision-Vorlauf je Perm (j3).

**Betriebsregel:** ein voller Lauf ist ein Mehr-Stunden-/Mehr-Tage-Experiment — auf Mess-Maschinen
nur koordiniert starten (P11-Wache in der CI bricht bei fremdem Treiber-Prozess hart ab).

## 8. CI-Anwendung (derselbe Kanal, `planer:delegate` + Lint)

Die CI fährt exakt dieselbe Kette: der Job **`planer:delegate`** (Stage `planer`, hinter
`COMDARE_BUILD_GOLDEN_N`) ruft `plan ci` und legt die Stufe-1-YAML als Child-Pipeline-Artefakt ab;
die `ceb:emit`-Jobs rufen `tier ci` → Grandchild-Pipeline (Nesting parent→child→grandchild).

```bash
"$PLANNER" plan ci "$PROFILE" > planer-child-ci.yml   # Stufe 1 (CEB-Jobs)   -- PLANER-Rolle
"$DRIVER"  tier ci "$PROFILE" > tier-child-ci.yml     # Stufe 2 (Tier-/Mess-Jobs) -- CEB-Rolle
```

Emittierte YAML vor dem Scharfschalten per **GitLab-CI-Lint** prüfen. W1 (05.08.2026): die
super-`.gitlab-ci.yml` ruft die vier Planer-Stellen (`visibility:tier-binaries` `plan dump`, die
beiden Mess-Pre-Flights `validate`, `planer:delegate` `plan ci`) über
`comdare-experiment-planner`; die drei erstgenannten Jobs bauen das ce-Target **zusätzlich** zum
Treiber, `planer:delegate` baut seit W1 **nur noch** das Planner-Target (der Treiber-Bau entfällt
dort — die emittierten `ceb:build`-Jobs bauen ihn selbst). Historisch standen dort die
Alt-Flags am Treiber — funktional identisch, aber seit W1 beantwortet der Treiber sie mit einer
Verweis-Zeile.

## 8b. F1-Durchstich (`measure:smoke` direkt, ##25)

Der Job hinter `COMDARE_DURCHSTICH` fährt **nicht** über `planer:delegate` → `ceb` → `tier`, sondern ruft
den Treiber **direkt** (`.gitlab-ci.yml:1936`) gegen
`Code/experiment_config/thesis_profiles/f1_durchstich.profile.xml` (1 Binary, 1 Perm, `cap=1`,
`resume="false"`). Ziel ist die **ganze Kette in EINEM Lauf**: frischer Mini-Messwert → Lauf-Marker →
Inhalts-Gate → `persist`-Commit → xlsx im Realm-Baum → `anhang:forward` → Thesis-Submodul-Commit.

**DIE EINE STARTZEILE** — *Run pipeline* auf **`development`**, genau diese drei Opt-ins setzen:

```
COMDARE_DURCHSTICH=true  COMDARE_PERSIST_MEASUREMENTS=true  COMDARE_ANHANG_FORWARD=true
```

Jede Variable schaltet **genau einen** Job scharf; die drei Regeln sind **paarweise disjunkt**:

| Opt-in | schaltet scharf | Gate-Stelle |
|---|---|---|
| `COMDARE_DURCHSTICH` | `measure:smoke` (`:1810`) | `.gitlab-ci.yml:1838` |
| `COMDARE_PERSIST_MEASUREMENTS` | `persist:measurements` (`:2241`) | `.gitlab-ci.yml:2270` |
| `COMDARE_ANHANG_FORWARD` | `anhang:forward` (`:2416`) | `.gitlab-ci.yml:2438` |

`persist:measurements` und `anhang:forward` laufen zusätzlich **nur auf `development`**
(Branch-Bedingung in derselben Regel). Fehlt ein Opt-in, **entsteht der Job gar nicht** — die Regel
greift nicht; die `INERT`-Zeile im Skript ist nur der zweite Gurt („defense-in-depth; die rules gaten
bereits", `.gitlab-ci.yml:2274`).

> **Der Lauf muss von einem Menschen gestartet werden.** Beide Schreib-Jobs tragen als **erste** Regel
> `$GITLAB_USER_LOGIN =~ /_bot_/ → when: never` (`:2268`, `:2436`) — ein von einem Bot/Token ausgelöster
> Lauf misst zwar, schreibt aber **weder** nach 288 **noch** nach 289 zurück, und zwar **ohne** roten Job.

> ⚠️ **`COMDARE_RUN_MEASURE` NICHT setzen.** Es erzeugt zugleich `measure:golden-320` (Timeout **10 Tage**),
> der per `needs` auf demselben Job wartet und danach den **`resource_group`-Slot tagelang belegt**
> (Begründung im YAML selbst, `.gitlab-ci.yml:1832-1834`). Die F1-Welle will **genau einen messenden Job**.

**Voraussetzung (Projektvariablen, `protected` + `masked`):** ohne sie brechen die beiden Schreib-Jobs
hart ab (kein stiller Skip).

| Variablenpaar | Projekt | Gate-Stelle |
|---|---|---|
| `COMDARE_WRITEBACK_USER` / `COMDARE_WRITEBACK_TOKEN` | 288 (super) | `.gitlab-ci.yml:2278-2280` |
| `COMDARE_THESIS_WRITEBACK_USER` / `COMDARE_THESIS_WRITEBACK_TOKEN` | 289 (Thesis) | `.gitlab-ci.yml:2446-2453` |

`anhang:forward` prüft **beide** Paare: das 289er für den Anhang-Push, das 288er für den Gitlink-Bump
(`.gitlab-ci.yml:2451-2452`).

**Beweisjobs, in dieser Reihenfolge:** `measure:smoke` (`:1810`) → `persist:measurements` (`:2241`) →
`anhang:forward` (`:2416`).

**Lese-Hinweis (nicht verwechseln):** der PDF-Beweis **dieses** Laufs kommt aus dem **PDF-Gate des
anhang-Kerns** (`ci/anhang_forward_core.sh:1310ff`, ALLES-ODER-NICHTS gegen den 289-Klon). Der Job
`thesis:pdf` (`:1585`) baut auf dem Submodul-Stand, mit dem die Pipeline **gestartet** ist — er sieht den
frischen Gitlink erst im **Folgelauf**. Das ist kein Defekt, sondern die Reihenfolge.

### STAND 12.08.2026 — die Kette trägt, die MESSUNG nicht

Lokal gefahren auf ce-Stand `670483c0` mit **exakt** der Env, die `measure:smoke` setzt
(`COMDARE_GN_OPT=O3`, `COMDARE_GN_SIMD=no_extension`, `COMDARE_PLATFORM=amd@<host>`,
`COMDARE_MEASUREMENT_COMBO` bewusst ungesetzt):

- **grün:** `validate` · `lastprofile` (1/1) · Lauf-Marker (schreiben+prüfen) · `mess_ausbeute_wache`
  (1 Datenzeile) · `frische_wache` (`csv_dieser_lauf=1`) · **csv UND xlsx** entstehen beide
- **rot:** `durchstich_wache frische` — `measured=0`, gefordert 1. Der Treiber endet mit **Exit 1**:
  `fehlerklasse=mess_konsistenz status=deklaration_leer` (`haupt_ist=0`, `haupt_soll=3`).

Ursache am Objekt: die emittierte `perm.cpp` der Basis-320-Zelle trägt die **2-arg**-Form von
`COMDARE_ANATOMY_VERSION_STAMP` (ohne Mess-Zeile), während die Prüfseite die Vollmengen-Zeile
verlangt. Herleitung im ce-Kommentar an `profile_run_entry.hpp` (lazy_gen).

⚠️ **Die eine Datenzeile ist KEIN Messwert:** `n_ops=n/a`, `total_ns=n/a`, `ns_per_op=n/a`,
`quality_flag=n/a` — eine *provisionierte* Zeile (`provisioned=1`). Nur `durchstich_wache frische`
fängt das ab; `mess_ausbeute_wache` und `frische_wache` melden **OK**. Ohne dieses eine Gate liefe eine
Zeile voller `n/a` bis in die Thesis-PDF. Bis der Stempel-Befund behoben ist (S-6-Fenster), liefert der
Durchstich **keinen** frischen Messwert.

### STAND 12.08.2026 (abends) — BEHOBEN: die Messung trägt (KON47-01/Option a)

*Der Block darüber bleibt als Historie stehen; sein Schluss-Satz ist überholt: der Owner hat den
Stempel-Fix per KON47-01/Option a **vor** das S-6-Fenster gezogen (OWNER>PLAN — geändert wird nur der
**Wert** des Mess-Glieds, nie die Glieder-Ordnung; die S-6-Sperre bleibt unberührt).*

Fix in ce (Branch `bau/strang-c-f1-katalog-emitter`): der Katalog-Emitter reicht die Mess-Zeile des
Laufs durch — `build_pilot_source_map`/`make_catalog_source_gen`/`generated_make_catalog_source_gen`
(+ alle 18 Sweep-Zweige und per-K) tragen `measurement_stamp` (Default `{}` = 2-arg, Alt-Aufrufer
byte-identisch); `profile_run_entry` löst `live_mess_zeile` **vor** der ersten gestempelten Quelle auf
und speist Katalog + Sweeps + SOTA + Prüfdock-SOLL aus **einem** benannten Objekt. Neue ce-Wache (g)
in `test_lazy_adhoc_source_gen` (Katalog==lazy modulo Index-Zeile, `_M`-Vollform, gewürfelter Köder
beidseitig). Neue super-Wachenschärfe (KON44-02/D4d): `mess_ausbeute_wache` zählt je CSV zweitens die
n/a-/provisionierten Zeilen (Felder 4/5/6 == `n/a`) und ist bei `modus=voll` **rot**, wenn die
**echten** Zeilen die Mindestzahl verfehlen (Bissproben F27/F28; F20/F21 waren vergeben).

Lokal gefahren (Sequenz `.gitlab-ci.yml:1936-1965`, Env exakt wie `measure:smoke`, COMBO ungesetzt):

- **Treiber Exit 0:** `RUN_PROFILE fertig: basis_rows=1 sota_rows=0 (basis_ids=1 sota_ids=0)
  measured=1 resumed=0 provisioned=1 csv_ok=1`
- **`durchstich_wache frische`:** `OK (1 real gemessen, 0 resumiert).`
- **gehärtete `mess_ausbeute_wache`:** `OK (1 echte, 0 n/a-/provisionierte Datenzeile(n) aus 1 von 1
  Datei(en)).`
- **Echte Werte** in der einen Datenzeile: `n_ops=10000`, `total_ns=6440197`, `ns_per_op=644.020`;
  `deklaration_leer` kommt in beiden Lauf-Logs **0**-mal vor. Die emittierte `perm.cpp` derselben
  basis-320-Zelle trägt jetzt die **3-arg `_M`-Vollform** (vorher 2-arg, s. Block darüber) — die
  Preimage-Wirkung (sha512_line/Sidecars der Basis-320-/Sweep-/per-K-Zellen) ist **gewollt**
  (KON47-01 „heute kostenlos“), **kein** `fingerprint_format`-Bump.
- **Lese-Hinweis:** ein grep nach `;n/a;n/a;n/a;` über die ganze Zeile trifft **eine** Stelle — das
  sind die by-design-n/a-Endspalten (`alloc_bytes_in_use_peak`/`alloc_*_frag_milli`,
  Klasse C, plus nicht erhobene PMC-Spalten wie `pmc_cache_misses_l2/l3`), **nicht** die Messfelder
  4–6. Die feldgenaue Prüfung (Felder 4/5/6) ist genau die neue Wachen-Zählung.

## 9. Exit-Codes + Troubleshooting

| Code | Bedeutung |
|------|-----------|
| 0 | Erfolg |
| 1 | Usage-Fehler bzw. Emission abgebrochen (`fehlerklasse=emission_abgebrochen`, stderr) |
| 2 | Konfig-Fehler: leerer Planer-Plan (V-2-Startgate) oder kaputte `COMDARE_GOLDEN_N_RANGE` |
| 5 | `validate`: unbekannte/unlesbare Profil-Wurzel (Planer-Binary) |
| 6 | Bestandslog-`planer_block`: Pflicht-Variable fehlt (`konfiguration_unvollstaendig`) |
| 7 | Lane-Wache: `COMDARE_PLATFORM`-Lane passt nicht zum realen CPU-Vendor (nur `run`, Treiber) |

Typische Stolpersteine:
- **Configure stirbt mit „g++ >= 15.3 erforderlich"** → richtiger Compiler? Floor ist gewollt (§1).
- **`validate` Exit 5** → Profil-Pfad/Wurzel-Tag prüfen; Profil-Auflösung siehe §4.
- **Exit 6 bei `plan ci`/`plan cmake`** → `COMDARE_BESTANDSLOG=true` gesetzt, aber DOC_KEY/OWNER_UUID/
  MASCHINE unvollständig — Variablen setzen oder Gate weglassen.
- **Ein Lane-Target fehlt** (z. B. `comdare_tier_batch_intel`) → das Profil deklariert diese Lane
  nicht (§62-B: die CEB verteilt die System-Perms auf die deklarierten Host-Lanes). Existieren beide,
  den Batch der **eigenen** Maschine bauen — die Mess-Stufe sichert zusätzlich die Lane-Wache (Exit 7).
- **Ein `<config_dir>` heißt wörtlich wie ein Subcommand** (z. B. `validate`) → den `run`-Subcommand
  nutzen: `comdare-messung-driver run validate <output_dir>`.
- Vollständige CLI-Hilfe: `comdare-messung-driver --help` bzw. `help <subcommand>`.

## 10. Selbstauskunft (`version`)

```bash
"$DRIVER" version        # kanonisches Flag: --version
```

Vier gelabelte non-empty Zeilen: `planner`-Selbst-Stempel, `ceb-contract`, `build-type`,
`build-version` (= `system_axes_version_suffix`) — ordnet jedes Binary dem gebauten Cache-Artefakt zu.
