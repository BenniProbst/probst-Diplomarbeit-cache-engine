# Cluster-parallele System-Achsen-Builds — Matrix-Design, Locking, Dedup, Infra-Handout (W4-A)

**Datum:** 2026-07-19 · **Paket:** W4-A (Welle 4, Priorität vorn) · **Ledger:** §35 + §36 (Pool-Modell-Nachsteuerung) · **Owner-Datei:** super `.gitlab-ci.yml`
**Verwandt:** W4-B = die ce-Materialisierungs-Naht (lazy Per-Index-Emitter) — läuft parallel; ohne sie bleibt Stufe 2 der `exit-3`-Scaffold.

Dieses Dokument beschreibt die `parallel:matrix`-Erweiterung von `build:golden-n`, die die CEB-/Tier-Binary-Builds über
einen **Pool von N amd64-Nodes** parallelisiert, jede System-Permutation clusterweit unter **Locking genau einmal**
gleichzeitig baut (GitLab `resource_group`) und den Wiederaufbau über Läufe hinweg per MinIO-Dedup + `algo_sig`
(#50) vermeidet.

**§36-Nachsteuerung (2026-07-19, gegenüber §35):**
1. **Locking Pflicht** — `resource_group` je System-Permutations-Zelle (ein Job je Gruppe über alle Pipelines/Runner).
2. **N amd64-Nodes statt 2** — 3-stufiges Capability-Routing (`amd64`/`avx2`/`avx512`); no_extension läuft auf ALLEN amd64-Buildern inkl. kleiner Nodes (Odroid-H4-Klasse).
3. **Multiple CEBs je Planer** — Matrix-Dimension „Messsystem-Konfiguration" (`GN_MSYS`, heute 1 Default).
4. **Freigabe-Kopplung** — System-SIMD-Freigabe (CEB) erlaubt die Kompilation der gekoppelten SIMD-Organ-Achsen (W4-B-Emitter-Naht; G7-constexpr-Gate wird Bau-Gate).

---

## 1. Runner-Inventar + Fähigkeiten (belegt)

Abgefragt 2026-07-19 über die GitLab-API (`/api/v4/runners/all` + `/runners/<id>`) und die Cluster-Docs
(`docs/PROD-CLUSTER-STAND-K75.md:22`). **amd64/x86_64-Builder** (für System-Achsen-Builds relevant):

| Runner | Beschreibung | Status | Ist-Tags (API) | CPU | AVX2 | AVX-512 |
|:------:|--------------|--------|----------------|-----|:----:|:-------:|
| id=16 | `prod-baremetal-prod1` | online | `[prod, baremetal, amd]` | AMD Ryzen 9 9950X3D (Zen 5) | ja | **ja** |
| id=17 | `prod-baremetal-prod2` | online | `[prod, baremetal, intel]` | Intel i9-14900KS (Raptor-Lake-R) | ja | **nein** |
| id=6 | `pve1-debian-x86_64` | offline | `[debian, x86_64, bare-metal]` | (x86_64) | ? | ? |
| id=7 | `pve2-debian-x86_64` | offline | `[debian, x86_64, bare-metal]` | (x86_64) | ? | ? |
| id=8 | `node3-ubuntu-x86_64` | offline | `[ubuntu, x86_64, bare-metal]` | (x86_64) | ? | ? |
| id=9 | `node4-ubuntu-x86_64` | offline | `[ubuntu, x86_64, bare-metal]` | (x86_64) | ? | ? |
| id=2 | `node5-macintel-x86_64` | stale | `[x86_64, macos]` | Intel (macOS) | ? | nein |
| id=15 | `prod-k8s-talos-runner` | online | `[prod, kubernetes, talos]` | (amd64 k8s) | ? | ? |

**Nicht-amd64** (nicht Teil des amd64-Pools, für Vollständigkeit): id=4 node7-rpi5-arm64, id=3 node6-macarm-arm64,
id=5 node8-visionfive-riscv64, id=13 zih-barnard, diverse k8s/Windows-Runner.

**AVX-512-Verfügbarkeit (State-of-the-Art, nicht geraten):**
- **prod1 / AMD Ryzen 9 9950X3D (Zen 5):** voller AVX-512-Befehlssatz → **einziger AVX-512-fähige Node heute**.
- **prod2 / Intel i9-14900KS (Raptor Lake Refresh, Hybrid P/E):** AVX-512 hardware-seitig deaktiviert (E-Cores tragen
  kein AVX-512 → CPU-weit gefused) → nur AVX2/AVX-VNNI. Deckt sich mit der §36-Vorannahme.
- **Kleine Nodes (Odroid-H4-Klasse = Intel N97/Alder-Lake-N u.ä.):** Gracemont-only → AVX2 **ja**, AVX-512 **nein**.
  Können no_extension + avx2 mitbauen (§36.3: „no_extension überall; avx2/avx512 nur wo Hardware").

**Belege (literal):**
```
GitLab-API /runners/all (2026-07-19):
  id=16 online desc=prod-baremetal-prod1  tags=['prod','baremetal','amd']   arch=amd64
  id=17 online desc=prod-baremetal-prod2  tags=['prod','baremetal','intel'] arch=amd64
  id= 6 offline desc=pve1-debian-x86_64   tags=['debian','x86_64','bare-metal']  arch=amd64
  id= 7 offline desc=pve2-debian-x86_64   tags=['debian','x86_64','bare-metal']  arch=amd64
  id= 8 offline desc=node3-ubuntu-x86_64  tags=['ubuntu','x86_64','bare-metal']  arch=amd64
  id= 9 offline desc=node4-ubuntu-x86_64  tags=['ubuntu','x86_64','bare-metal']  arch=amd64
docs/PROD-CLUSTER-STAND-K75.md:22 | prod1 (Ryzen 9 9950X3D, .211) · prod2 (i9-14900KS, .212)
```

**KERN-BEFUND für den Infra-Handout:** **KEIN Runner trägt heute einen Capability-Tag** `amd64`/`avx2`/`avx512`.
Die prod-Nodes tragen `amd`/`intel`, die kleinen Nodes `x86_64` (mit Bindestrich `bare-metal`). Das §36-Routing
verlangt die drei Capability-Tags → Abschnitt 5 (Infra-Handout). Bis die Tags gesetzt sind, **pendet** der Job
(opt-in + W4-B-blockiert → nichts läuft verfrüht).

---

## 2. Matrix-Design (§35 + §36)

`build:golden-n` wurde von einem Ein-Zellen-Job zu **zwei Matrix-Jobs** umgebaut, die ein gemeinsames verstecktes
Template `.golden_n_build` erben (DRY: **ein** `script`, zwei Matrizen). Dimensionen:

- **msys** (`GN_MSYS`): Messsystem-Konfiguration (§36.2/§30) — heute `default` (1 Zelle), erweiterbar.
- **opt** (`GN_OPT`): `O2`, `O3` — System-Achse Optimierungsstufe (Ofast bleibt REJECT, §32-F4).
- **simd** (`GN_SIMD`): `no_extension`, `avx2` (Kern) + `avx512` (opt-in-Erweiterung).
- **chunk** (`GN_CHUNK`): `0..3` — 4 Fenster über den 2^17 = 131072-Indexraum der Organ-Permutationen.

| Job | Matrix (msys × opt × simd × chunk) | Zellen | Capability-Tag (§36.3) | Gate |
|-----|-----------------------------------|:------:|------------------------|------|
| `build:golden-n` | 1 × {O2,O3} × {no_extension} × {0..3} | 8 | `amd64` (ALLE amd64-Nodes) | `COMDARE_BUILD_GOLDEN_N=="true"` |
| `build:golden-n` | 1 × {O2,O3} × {avx2} × {0..3} | 8 | `avx2` (AVX2-Nodes) | " |
| `build:golden-n-avx512` | 1 × {O2,O3} × {avx512} × {0..3} | 8 | `avx512` (nur prod1/Zen5) | `COMDARE_BUILD_GOLDEN_N` **und** `COMDARE_GN_INCLUDE_AVX512` |

**Gesamt: 24 Jobs** (16 Kern + 8 avx512-opt-in). avx512 ist bewusst **separater** Job mit eigenem Gate (nicht §33-Kern).

**Routing per Runner-Tag (`tags: ["$GN_RUNNER_TAG"]`, §36.3):** GitLab expandiert Variablen in `tags:`, und
`parallel:matrix` erlaubt je Zelle eine eigene Belegung (SIMD und Tag sind als 1-elementige Arrays paar-gebunden;
opt×chunk kreuzen). **Wichtig:** die Tag-Liste enthält **nur** den Capability-Tag — **kein** `[prod, baremetal]`-Präfix.
Ein Präfix würde die kleinen Nicht-prod-Nodes (`debian/ubuntu, x86_64, bare-metal`, ohne `prod`/`baremetal`)
ausschließen und dem §36-Pool-Modell widersprechen. DLL-Bau braucht keinen PMC/prod-Kontext (das ist Messung).

- `no_extension` → `amd64` → jeder Node mit Tag `amd64` (der ganze amd64-Pool).
- `avx2` → `avx2` → nur AVX2-getaggte Nodes.
- `avx512` → `avx512` → nur AVX512-getaggte Nodes (heute prod1).

**Runtime-Sicherheitsnetz (unabhängig vom Tag):** Der Treiber überspringt SIMD-Permutationen, die die laufende ISA
nicht kann (`experiment_run_entry.hpp:255-257`: „HardwareErweiterungFehlt … Permutation übersprungen"). Falsches
Routing baut also nie ein illegales `-mavx512`-Binary auf einer AVX2-Node.

---

## 3. Locking (§36.1) — `resource_group`, native Ein-Job-Semantik

**Anforderung (§36.1):** eine System-Achsen-Permutation darf nur auf **genau EINEM Runner und EINER Concurrency
gleichzeitig** gebaut werden. **Mechanik:** GitLab `resource_group` garantiert nativ, dass zu jedem Zeitpunkt höchstens
**ein** Job je Gruppe läuft — über **alle Pipelines und alle Runner** hinweg. Belegt:

```yaml
resource_group: "gn-$GN_MSYS-$GN_SIMD-$GN_OPT-$GN_CHUNK"
```

Der Schlüssel expandiert je Zelle eindeutig (verifiziert: 24 Zellen → 24 verschiedene resource_groups, keine
Kollision), z.B. `gn-default-no_extension-O2-0`, `gn-default-avx512-O3-3`. Damit ist jede (Messsystem × System-
Permutation × Chunk) ein globaler Lock — startet ein zweiter Runner dieselbe Zelle, wartet er, bis der erste fertig ist.

**Zwei-Schichten-Schutz gegen Doppel-Builds:**
1. **Live-Race → `resource_group`** (diese Schicht): kein gleichzeitiger Zweitbau derselben Permutation.
2. **Historische Builds → MinIO-mc-stat-Dedup** (Abschnitt 4): eine in einem früheren Lauf clusterweit schon gebaute
   Permutation wird per Marker erkannt → skip+pull statt Neubau.

---

## 4. Cross-Runner-Dedup-Protokoll (Ein-Build-pro-Permutation, egal wo)

**Zwei Ebenen** (Ledger §35.2/§35.3):

1. **Grob, Job-Ebene (dieser CI-Umbau):** ein Marker-Objekt je (System-Permutation × Chunk) im MinIO-Bucket. Vor dem
   Bau `mc stat` auf den Marker → **HIT** = `skip + pull` (Warm-Cache), **MISS** = bauen (danach Marker + Push).
2. **Fein, Treiber-Ebene (schon vorhanden / W4-B):** `dll_is_current(build_version, algo_sig)` prüft **pro DLL** über
   das `perm.dll.version`+`.algos`-Sidecar. `algo_sig` (#50) ist der Invalidierer: ändert sich der Algorithmus einer
   Achse, passt die Signatur nicht → Neubau der DLL. Ein grober Job-Ebene-False-Hit bleibt korrektheits-sicher.

**Schlüssel-Ableitung (belegt gegen `artifact_cache.hpp` + `experiment_run_entry.hpp`):**
- **DLL-Objekt-Key** (`artifact_cache.hpp:5-6,56,100-105`): `<build_version>/<stem>/perm.dll` (+ `.version` ZULETZT als
  Vollständigkeits-Marke; halb-gepusht = kein Sidecar = kein Pull). `stem`=Organ-Permutation, `build_version`=System-Permutation.
- **`build_version` = `perm_build_version`** (`experiment_run_entry.hpp:263-265`): `<base>` + `+cxx=<compiler_tag>` +
  `+opt=<opt_id>` + (`+ext=<simd_id>` **nur wenn ≠ no_extension**). Bsp.: `m3v2+cxx=gcc-15.3+opt=O3+ext=avx2`.
- **Chunk-Marker-Key (W4-A):** `prodcache/<bucket>/<GN_PREFIX>/_gn_chunk_markers/<START>-<COUNT>.done`.

**Job-Skript-Logik (`.golden_n_build`, Dedup-Step):**
```
GN_PREFIX = <base>[+cxx=<COMDARE_GN_COMPILER_TAG>]+opt=<GN_OPT>[+ext=<GN_SIMD wenn != no_extension>]
CHUNK_SIZE = ceil(COMDARE_GN_TOTAL / COMDARE_GN_CHUNK_COUNT)   # 131072/4 = 32768
START = GN_CHUNK*CHUNK_SIZE ; COUNT = min(CHUNK_SIZE, TOTAL-START)  # letzter Chunk klemmt
GN_RANGE = "START:COUNT"    # "0:32768","32768:32768","65536:32768","98304:32768"
mc stat prodcache/<bucket>/<GN_PREFIX>/_gn_chunk_markers/<START>-<COUNT>.done
  HIT  -> echo SKIP (bereits im Cluster gebaut) ; mc cp --recursive <PREFIX>/ -> Code/gn_out/<PREFIX>/ ; GN_DECISION=skip
  MISS -> GN_DECISION=build
```

**Inert-Bedingungen (golden-neutral by default):** aktiv nur bei `COMDARE_STORAGE_CACHE=true` **und** `mc` vorhanden
**und** scharfem Alias/Bucket. Sonst „Storage inert → Bau lokal", keine Cross-Runner-Kopplung.

**Compiler-Tag-Vertrag:** damit der DLL-Pull `<PREFIX>/` trifft, muss `COMDARE_GN_COMPILER_TAG` dem `a.compiler_tag`
des Treibers gleichen (z.B. `gcc-15.3`, T2-Pin). Leer → Marker-Skip greift, DLL-Pull übersprungen; `dll_is_current`
bleibt Invalidierer.

**Messsystem-Kopplung (§36.2):** heute `GN_MSYS=default` = neutral (nicht Teil von `GN_PREFIX`). Sobald >1 Messsystem
aktiviert wird und die CEBs sich binär unterscheiden, **muss** `GN_MSYS` in die Binary-Identität (`GN_PREFIX`/
`build_version`) einfließen — im Lockstep mit W4-B, damit der Dedup-Key je CEB eindeutig bleibt. Das Locking (`resource_group`)
trägt `GN_MSYS` bereits; der Treiber bekommt `COMDARE_GN_MSYS` per Env.

---

## 5. Infra-Handout — Capability-Tags über N amd64-Nodes (Runner-Tags setzen = Infra)

**Kern-Befund (Abschnitt 1):** kein Runner trägt heute `amd64`/`avx2`/`avx512`. Das §36-Routing ist damit **vollständig
infra-gegatet** — die Matrix ist tag-parametrisch fertig, aber die Runner-Tags fehlen. Rolle Impl = read-only-verify →
**Handover an Cluster-Owner:**

**Jeden amd64-Builder nach realer CPU-Fähigkeit taggen** (GitLab-UI Settings > CI/CD > Runners, ODER
`PATCH /runners/<id>` mit `tag_list`, ODER `config.toml` `tags=[...]` + Neuregistrierung):

| Runner | Node | + Capability-Tags | Begründung |
|:------:|------|-------------------|-----------|
| id=16 | prod1 (Zen 5) | `amd64, avx2, avx512` | voller AVX-512 |
| id=17 | prod2 (Raptor-Lake-R) | `amd64, avx2` | AVX2, kein AVX-512 (fused-off) |
| id=6/7 | pve1/pve2 (x86_64) | `amd64` [+`avx2` wenn CPU es kann] | Basis-Builder; AVX2 nach `lscpu`-Prüfung |
| id=8/9 | node3/node4 (x86_64) | `amd64` [+`avx2` wenn CPU es kann] | Basis-Builder |
| (neu) | Odroid-H4-Klasse (N97/AlderLake-N) | `amd64, avx2` | Gracemont: AVX2 ja, AVX-512 nein |
| id=15 | prod-k8s-talos (amd64) | `amd64` [optional] | falls k8s-Builds erwünscht |

**Prüf-Kommando je Node** (Fähigkeit belegen statt raten): `lscpu | grep -oE 'avx2|avx512[a-z]*'` bzw.
`grep -oE 'avx2|avx512f' /proc/cpuinfo | sort -u`. Tag `avx2`/`avx512` **nur** setzen, wenn das Flag real vorhanden ist.

**Nach dem Taggen:** keine YAML-Änderung nötig — die Matrix routet bereits auf `amd64`/`avx2`/`avx512`. Sobald die
Tags existieren, verteilen sich die 16 (+8) Zellen automatisch über den Pool; `resource_group` verhindert Doppel-Builds.

---

## 6. Freigabe-Kopplung System→Organ (§36.4, W4-B-Naht)

**Prinzip (§36.4, Verallgemeinerung des INC-2d-Freigabe-Musters):** die **System-SIMD-Achsen-Freigabe sitzt in der CEB**;
die Umsetzung der **SIMD-Organ-Achsen** zu Tier-Binaries ist eine **gekoppelte** Organ-Achse — Organ ≤ System-Zulassung.
Konkret: eine Zelle mit `GN_SIMD=avx2` läuft (per Capability-Tag) nur auf AVX2-Hardware; ihr Env `COMDARE_GN_SIMD=avx2`
ist damit ein **wahrhaftiges Freigabe-Signal** „diese Hardware bietet avx2". Der W4-B-Emitter muss daran koppeln:
SIMD-Organ-Varianten nur in Zellen materialisieren, deren System-simd-Freigabe sie erlaubt (Naht an
`perm_compile_flags`/ISA-Gate; das Audit-**G7-constexpr-Gate wird Bau-Gate**). Die CI liefert die Freigabe strukturell
(Tag-Routing + `COMDARE_GN_SIMD`); die Durchsetzung auf Organ-Ebene ist W4-B.

---

## 7. Zeit-Rechnung (N Nodes × Chunks × Locking)

- **Kern-Job-Menge:** 4 System-Permutationen (§33-Kern: 2 opt × 2 simd) × 4 Chunks = **16 unabhängige Jobs** (+ 8 avx512-opt-in).
- **Pool-Kapazität:** statt fix 2 Nodes nun **N amd64-Nodes**. no_extension (`amd64`) skaliert über den ganzen Pool
  (prod1/prod2 + pve1/pve2 + node3/node4 + Odroid), avx2 über die AVX2-Teilmenge, avx512 nur prod1.
- **Wandzeit:** die 8 no_extension-Zellen teilen sich alle `amd64`-Slots des Pools; bei `p` amd64-Buildern à Concurrency
  `c` → bis zu `p·c` parallele Zellen. Gegenüber seriell-Ein-Node sinkt die Wandzeit grob um `p·c` (minus Treiber-Bau +
  `mc`-Sync-Overhead je Zelle). `resource_group` deckelt die Parallelität je Permutation auf 1 (verhindert Doppel-Bau,
  nicht die Pool-Breite über verschiedene Permutationen).
- **Chunk-Granularität** begrenzt die Einzel-Job-Länge (GB-Compile/g++-ICE-Vermeidung, GN-2-Guard) und macht
  Wiederanläufe billig (nur das Fenster). **Dedup** spart über Läufe: unveränderte `algo_sig` → Folge-Lauf nur `mc stat`+Pull.

**Parametrisierung:** `COMDARE_GN_TOTAL` (Indexraum), `COMDARE_GN_CHUNK_COUNT` (Fensterzahl, **muss** = Länge der
`GN_CHUNK`-Liste), `COMDARE_GN_BUILD_VERSION_BASE`, `COMDARE_GN_COMPILER_TAG`, `GN_MSYS` (Messsystem, Default `default`).
Weitere Messsysteme = weiterer `GN_MSYS`-Wert in den Matrizen (multipliziert die Zellen). Mehr/weniger Chunks =
`GN_CHUNK`-Liste **und** `COMDARE_GN_CHUNK_COUNT` gemeinsam anpassen (Guard bricht bei `GN_CHUNK >= CHUNK_COUNT` ab).

---

## 8. Die Umschalt-Zeile für den echten Bau (Übergabe an W4-B)

Alles außer **einer** Naht ist fertig: Matrix, N-Node-Routing, Locking, Chunk-Fenster, `mc`-Dedup (stat/pull),
Marker-Push-Vorlage, Messsystem-Dimension. Nur der eigentliche DLL-Bau bleibt der `exit-3`-Scaffold, bis die
ce-Materialisierungs-Naht (W4-B, lazy Per-Index-Emitter) landet. Die **einzige** Zeile, die dann getauscht wird (in
`.golden_n_build`, Stufe 2, dort als `UMSCHALT-ZEILE` markiert):

```sh
# ERSETZT den echo/exit-3-Block durch:
COMDARE_THESIS_PROFILE="$COMDARE_GOLDEN_N_PROFILE" COMDARE_GOLDEN_N_RANGE="$GN_RANGE" \
  COMDARE_GN_OPT="$GN_OPT" COMDARE_GN_SIMD="$GN_SIMD" COMDARE_GN_MSYS="$GN_MSYS" COMDARE_GOLDEN_N_PROVISION_ONLY=true \
  "$DRIVER" experiment_config "$CI_PROJECT_DIR/Code/gn_out/$GN_PREFIX"
# danach GN-9-Größen-Report, dann (nur bei COMDARE_STORAGE_CACHE=true) der Chunk-Marker fuer den naechsten Runner:
[ "${COMDARE_STORAGE_CACHE:-}" = "true" ] && command -v mc >/dev/null 2>&1 && \
  printf 'algo_sig=%s compiler=%s msys=%s range=%s utc=%s\n' "<algo_sig>" "${COMDARE_GN_COMPILER_TAG:-na}" "$GN_MSYS" "$GN_RANGE" "$(date -u +%FT%TZ)" \
  | mc pipe "prodcache/${COMDARE_MINIO_BUCKET}/${GN_PREFIX}/_gn_chunk_markers/${GN_RANGE//:/-}.done"
```

Die Per-DLL-`perm.dll`/`.version`/`.algos`-Objekte pusht die ce-`artifact_cache`-Naht (`push_tier_binary`) via
`COMDARE_STORAGE_CACHE` selbst; der W4-A-Marker liegt daneben (grobe Job-Ebene-Dedup).

**Voraussetzung (W4-B):** der Treiber muss (a) ein **Ein-System-Permutations-Filter** (nur `GN_OPT`×`GN_SIMD` bauen
statt Voll-Walk), (b) das **Chunk-Fenster** `COMDARE_GOLDEN_N_RANGE` + `..._PROVISION_ONLY`, (c) die **Freigabe-Kopplung**
(§36.4: SIMD-Organ ≤ System-simd-Freigabe) honorieren. Der GN-2-Guard (`source_catalog.hpp:
kMaxMaterializableCatalogCardinality=4096`) sperrt die map-materialisierende Naht compile-time; der lazy Emitter ersetzt sie.

---

## 9. Verifikation (literal)

```
GitLab CI-Lint (Projekt 288, löst include: ci-templates + !reference auf):
  valid: True   errors: []   warnings: []
  golden-n Jobs im gemergten Ergebnis: 24
    build:golden-n: [no_extension, amd64, default, O2, 0] ... build:golden-n: [avx2, avx2, default, O3, 3]      (16)
    build:golden-n-avx512: [avx512, avx512, default, O2, 0] ... [avx512, avx512, default, O3, 3]                (8)

python3-yaml (RefLoader für !reference) — Matrix-Expansion + Locking:
  .golden_n_build: tags=['$GN_RUNNER_TAG']  resource_group='gn-$GN_MSYS-$GN_SIMD-$GN_OPT-$GN_CHUNK'
  build:golden-n        -> 16 Zellen  SIMD->Tag: [(avx2,avx2),(no_extension,amd64)]  msys=[default]  16 eindeutige resource_groups
  build:golden-n-avx512 ->  8 Zellen  SIMD->Tag: [(avx512,avx512)]                   msys=[default]   8 eindeutige resource_groups
  -> 24 Zellen == 24 eindeutige resource_groups (Ein-Job-Lock je Permutation, keine Kollision)

bash -n über die eingebetteten Skript-Blöcke: 3/3 OK (Dedup, Stufe-1, Stufe-2)
```
