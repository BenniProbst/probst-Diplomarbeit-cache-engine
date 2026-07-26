KARTIERUNG W-13 -- doppelte Perm-Suffix-Reihenfolge / Cache-Key-Fehlklasse (Fix-A-Klasse). NICHTS geaendert.

Repo-Wurzel: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
CE-Wurzel: /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine (unten "CE/")
Stand: COMDARE_ANATOMY_ABI_MAJOR=6, kCebContractCodegenMinor=0 -> "+ceb=6.0". HEAD 5795fae2.

## (a) DIE ERZEUGER -- LITERAL, MIT EXAKTER REIHENFOLGE

Es sind nicht zwei, sondern VIER Erzeuger in zwei Formen. Form P existiert in drei unabhaengigen Kopien (C++ x2, C++ x1 env-getrieben, bash x1).

**FORM P ("perm-loop")**: `<base> +cxx=<tag> +opt=<opt> [+ext=<simd> NUR wenn != no_extension] [+bt=Debug]` -- KEIN +ceb, KEIN +target, KEIN +tel.

- **P1** `CE/libs/cache_engine/profile_facade/profile_run_entry.hpp:754-757`
```cpp
std::string const perm_suffix =
    "+cxx=" + a.compiler_tag + "+opt=" + opt_id +
    (simd_id == std::string{cm::SimdNoExtOption::simd_id()} ? std::string{} : "+ext=" + simd_id) +
    build_type_version_suffix();
```
  -> `:758 perm_build_version = a.build_version + perm_suffix;` (.version-Sidecar), `:759 perm_tag_build_version = tag_build_version + perm_suffix;` (CSV-Spalte). Aktiv NUR wenn das Thesis-Profil `<system_axes>` deklariert (Gate :693-696).
- **P2** `CE/libs/cache_engine/profile_facade/experiment_run_entry.hpp:293-297` -- byte-gleiche Zweitkopie desselben Ausdrucks (ep-Pfad, `<comdare_experiment>`).
- **P3** `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:951-953` -- dritte Kopie, env-getrieben, in `print_cache_key_facade` (`--print-cache-key`):
```cpp
std::string suffix = "+cxx=" + cxx_compiler() + "+opt=" + opt;      // opt = COMDARE_GN_OPT
if (simd != std::string{cm::SimdNoExtOption::simd_id()}) suffix += "+ext=" + simd;
suffix += tlz::build_type_version_suffix();
```
  Der Kommentar :934-940 benennt die Divergenz selbst und erklaert Form P fuer GN-Zellen + YAML zur autoritativen Reihenfolge.
- **P4** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.gitlab-ci.yml:877-880` (bash, GN_PREFIX). Weicht zusaetzlich ab: KEIN +bt, und +cxx aus `COMDARE_GN_COMPILER_TAG` statt aus `cxx_compiler()` (Kopplung nur per Kommentar :844-847).

**FORM S ("system_axes_version_suffix")**: `<base> +ext=<simd IMMER, auch no_extension> +cxx=<cxx_compiler()> +opt=<opt> +ceb=<MAJOR>.<minor> [+target=<isa> wenn != x86_64] [+tel=silent] [+bt=Debug]`

- **S1** `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:364-400` (nicht ~:172/~:340-350 -- Zeilen sind gewandert): :371 `+ext`+`+cxx`, :372-373 `+opt`, :378 `+ceb`, :384 `+target`, :394 `+tel=silent`, :398 `+bt`. Angewendet an genau ZWEI Stellen: `:538 a.build_version = args.build_version + system_axes_version_suffix(tp_ptr);` (Einzel-Pfad, Profil OHNE `<system_axes>`) und `:965 os << g1_binary_version_block(system_axes_version_suffix());` (`--version`).

**Verzweigung**: `profile_run_facade.cpp:444-445 profile_has_system_axes` -- true -> `:505` nackte build_version -> P1 haengt an; false -> `:538` Form S. Profilbestand in `CE/libs/cache_engine/algorithm_profiles/thesis_profiles/`: MIT `<system_axes>` nur `all_axes_golden.profile.xml` + `cacheline_study.profile.xml` (2); OHNE: base_pilot, fb_numa_page_study, ff2_node_width_study, m3_golden_coverage, m3_smoke_coverage, m3v2_smoke, m3v2_sota_pilot, m3v2_study, wdk_fairness_example (9). Der ep-Pfad (`:892`) ist immer Form P.

**LIVE-BELEG** (Ist-Zustand auf Platte): 320 Dateien `perm.dll.version`, alle mit identisch EINEM Inhalt, Form S: `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0` (z.B. `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/build/y/e4_xml/dll/<stem>/perm.dll.version`).

## (b) KONSUMENTEN -- WER SIEHT WELCHE FORM

Kein Konsument kennt die Form; alle sehen nur `cfg.build_version` bzw. den .version-Inhalt. Die Form bestimmt allein der aktive Erzeuger-Pfad.

| Konsument | Ort | sieht |
|---|---|---|
| `write_version_sidecar` | `CE/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp:276`, Aufruf :539 | Perm-Pfad Form P (OHNE +ceb), Einzel-Pfad Form S (MIT +ceb) |
| `dll_is_current` | `build_orchestrator.hpp:250-274`, Aufruf :472 | dieselbe Form wie der Schreiber -- lokal konsistent, Inhalt aber pfadabhaengig |
| `cache_key_prefix` | `CE/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp:214-218` | haengt +ceb BEDINGUNGSLOS an; Doc :206-208 behauptet "kein Doppel-+ceb, da push/marker NUR die Perm-build_version einspeisen" -- im Einzel-Pfad FALSCH |
| `push_tier_binary` | `artifact_cache.hpp:228-263` | cfg.build_version (beide Formen moeglich) |
| `pull_tier_binary` | `artifact_cache.hpp:273-308` | dito |
| `pull_tier_prefix` | `artifact_cache.hpp:316-338` | dito, via `cache_engine_builder_iterator.hpp:922` |
| `push_chunk_partial_marker` | `artifact_cache.hpp:423-430` | dito, via `cache_engine_builder_iterator.hpp:948` |
| `prune_key_base` | `artifact_cache.hpp:358-364` (FIX A) | liest den Praefix aus der LOKALEN perm.dll.version -> selbst-konsistent |
| `verify_remote_then_prune` | `artifact_cache.hpp:373-411` | Fallback aus `Code/02_messung_driver/main.cpp:777-779` = NACKTE Basis "m3v2", keine Form |
| GN_CACHE_KEY / YAML | `.gitlab-ci.yml:892-898, 912, 917, 942, 955, 1032` | Form P (aus --print-cache-key) |
| `--version` / G1-Stempel | `profile_run_facade.cpp:963-966`, `g1_binary_version_stamp.hpp:39-51` | Form S -- im Perm-Pfad traegt KEINE Binary diesen String |
| CSV-Spalte build_version | `profile_run_entry.hpp:452` | Perm-Pfad: Form P; Einzel-Pfad: NACKT (:283-285, :433) -- Provenienz nur im Sidecar |
| `.algos` | `build_orchestrator.hpp write_algos_sidecar` | KEINE der Formen |
| `.variant` | `CE/libs/cache_engine/builder/build_variant_sidecar.hpp:40-58` | KEINE -- das `bv=` dort ist die POD-Version, NICHT build_version |
| `.fingerprint` | `CE/libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:253-289` | KEINE |
| Bestandslog-LagerKey | `bestandslog_index.hpp:97-113`, `bestandslog_factory.hpp:43-66`, `bestandslog_document.hpp:149-159` | KEINE -- `(sha512(fingerprint), ZellKoordinaten{combo,opt,simd})` aus ENV (`profile_run_entry.hpp:333-345`); traegt weder +cxx noch +bt noch +ceb noch +target |

Bindung der Transport-Closures: `Code/02_messung_driver/main.cpp:853/859/869`.

## (c) KONKRETE FEHL-SZENARIEN

**F1 -- Doppeltes +ceb im Objekt-Key (Einzel-Pfad, 9 von 11 Profilen). REAL, nicht latent.**
`build_version = m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0` (belegt, 320 Sidecars) -> `cache_key_prefix` -> `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0+ceb=6.0+mtool=+mrg=none`. Push/Pull/Prune bleiben untereinander konsistent -> unauffaellig, genau die Fix-A-Signatur.

**F2 -- Key-Miss CI <-> Treiber im Smoke-golden-Zweig.** `.gitlab-ci.yml:1250` setzt `COMDARE_GOLDEN_N_PROFILE=m3v2_smoke.profile.xml`; `:1011` reicht es als `COMDARE_THESIS_PROFILE` durch -> Wurzel `<comdare_thesis_profile>` -> `run_profile_facade`, und m3v2_smoke hat KEIN `<system_axes>` -> Form S + Doppel-+ceb. GN_CACHE_KEY kommt aber aus Form P. Bei `COMDARE_STORAGE_CACHE=true`: DLLs unter K_push, Whole-Chunk-Marker (:1032) unter K_ci -> naechster Lauf findet den Marker -> `[dedup] HIT ... SKIP` (:939, :985) -> `mc cp --recursive .../K_ci/` (:942) zieht nur Marker, keine DLLs -> PULL_DST leer -> Stufe 2 uebersprungen -> Mess-Batch findet keine .so. Ein Pull-Fehlschlag MIT Skip, also schlimmer als ein reiner Miss. Symmetrisch: Treiber-Teil-Marker unter K_push, CI sucht unter K_ci (:917) -> Teil-Resume greift nie.

**F3 -- CEB-ABI-Bump invalidiert den Perm-Pfad lokal NICHT.** Form P traegt kein +ceb; `.version` bleibt nach 6.0 -> 6.1 gleich -> `dll_is_current` (:472) sagt "aktuell" -> kein Neubau. Gleichzeitig wandert `cache_key_prefix` auf +ceb=6.1 -> `pull_tier_prefix` MISS -> nichts hydriert -> alte lokale .so werden unter dem neuen Contract gemessen. Genau das Gegenteil der Doktrin in `profile_run_facade.cpp:374-377`. Betrifft all_axes_golden = die golden-N-Reihe.

**F4 -- +target/+tel verschwinden im Perm-Pfad.** Form P kennt beide nicht, und in der Perm-Verzweigung wird zusaetzlich `perm_compile_flags()` OHNE tp gerufen (`profile_run_facade.cpp:512`) -> `perm_target_isa_cflags(nullptr)` -> Cross-Flags fallen weg. Ein aarch64-Ziel wuerde x86-Flags bauen UND unter demselben Key wie der x86-Bau landen. cacheline_study deklariert bereits `<target_isa>`.

**F5 -- Asymmetrie +ext=no_extension.** Dieselbe Bau-Konfiguration ergibt je nach Profil-Deklaration zwei Keys: `m3v2+cxx=g++-16+opt=O3+ceb=6.0+mtool=+mrg=none` vs. `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0+ceb=6.0+mtool=+mrg=none` -> byte-identische DLLs doppelt gebaut, gepusht, gelagert.

**F6 -- Doppelte Lager-Eintraege.** LagerKey ohne cxx/bt/ceb: zwei Bauten derselben Perm mit anderem Compiler oder Build-Typ kollidieren auf EINEM LagerKey, belegen im Objekt-Store aber zwei Keys. Bestandslog und Objekt-Store haben verschiedene Identitaetsbegriffe.

**F7 -- Prune-Fallback.** `main.cpp:777-779` faellt ohne Sidecar auf die nackte Basis "m3v2" zurueck -> Praefix ohne Perm-Provenienz -> `mc_remote_exists` immer false -> pruned=0. Identische Klasse wie Fix A, nur in den Fallback-Zweig verschoben.

**F8 -- CI-Fallback.** `.gitlab-ci.yml:896` setzt `GN_CACHE_KEY="$GN_PREFIX"` wenn der Treiber fehlt. GN_PREFIX hat weder +bt noch +ceb noch +mtool/+mrg -> dritter, sonst nie benutzter Namensraum.

## (d) MINIMALER SINGLE-SOURCE-SCHNITT

**Wahrheit** -- eine neue, kleine, env-freie Funktion: `CE/libs/cache_engine/profile_facade/system_version_suffix.hpp` (Nachbar von `build_type_stamp.hpp`, header-only, nur std, kein Profil-/Env-Zugriff):

```
build_version_suffix(cxx_tag, opt_id, simd_id, target_isa_id, telemetry_silent)
  -> "+cxx=" + cxx_tag
   + "+opt=" + opt_id
   + (simd_id != no_extension ? "+ext=" + simd_id : "")
   + (target_isa_id != x86_64  ? "+target=" + target_isa_id : "")
   + (telemetry_silent         ? "+tel=silent" : "")
   + build_type_version_suffix()        // +bt=Debug
   + "+ceb=<MAJOR>.<minor>"             // ZULETZT -- siehe R1
```

Das ist Form P (die von CI, YAML, --print-cache-key und 6 Objekt-Store-Tests gelebte), erweitert um die drei Form-S-Segmente an Positionen, die den heutigen Form-P-Key-String **nicht** veraendern.

**Umstellung (5 C++, 1 YAML):**
1. `profile_run_entry.hpp:754-757` -> Aufruf der Wahrheit (perm-Werte + `a.compiler_tag`).
2. `experiment_run_entry.hpp:293-296` -> derselbe Aufruf; Zweitkopie faellt weg.
3. `profile_run_facade.cpp:364-400` -> `system_axes_version_suffix` wird zur duennen RESOLVER-Huelle (`active_simd_policy` / `cxx_compiler` / `active_opt_level` / `active_target_isa` / `active_telemetry_is_silent` aufloesen, dann die Wahrheit rufen). Kein eigener String-Bau mehr.
4. `profile_run_facade.cpp:951-953` -> dritte Kopie faellt weg.
5. `artifact_cache.hpp:214-218` -> `cache_key_prefix` VERLIERT das +ceb-Segment: `return build_version + "+mtool=" + combo + "+mrg=none";` Doc-Kommentar :199-213 richtigstellen.
6. `.gitlab-ci.yml:877-880` -> GN_PREFIX als reinen lokalen Verzeichnisnamen kennzeichnen (er ist bereits nur das); Fallback :896 sollte HART fehlschlagen statt still einen dritten Namensraum zu oeffnen.

Offen (nicht Teil dieser Kartierung, Mess-Provenienz- statt Key-Entscheidung): ob der Einzel-Pfad die CSV-Spalte kuenftig ebenfalls suffigiert (heute nackt, s. b).

**Wachen (Tests).** NEU -- die heute fehlende Kreuz-Wache; kein einziger Test vergleicht die Formen:
- T-a: perm-Suffix == Facade-Suffix fuer identische (cxx, opt, simd, bt).
- T-b: `count("+ceb=") == 1` in `cache_key_prefix(build_version_suffix(...))` -- Wache gegen F1; zusaetzlich fuer einen Form-S-Alt-String, damit ein Rueckfall auffliegt.
- T-c: Golden-String-Wache -- `build_version_suffix(g++-16, O3, avx2, x86_64, false)` + `cache_key_prefix` == der heute im Bucket liegende Form-P-Key (Byte-Gleichheit).

ANPASSEN (kodieren die Alt-Vertraege): `CE/tests/unit/test_s1_cache_key_prefix.cpp:33,44,53,61,70`; `CE/tests/unit/test_g3_prune.cpp:206`; `CE/tests/unit/test_g1_binary_version_stamp.cpp:64,98`.
BLEIBEN GUELTIG (reine Form-P-Literale): `test_s2_pull_tier_binary.cpp:94,116,161`; `test_s5_artifact_cache_bounded.cpp:84`; `test_w11_async_push_pump.cpp:57,65,174,232`; `test_g3_prune.cpp:148,171-173`.
BLEIBT unangetastet: `test_br1_full22_count.cpp:60-68` haelt "telemetry" als System-Achse und damit das +tel-Segment am Leben.

**Risiko fuer bestehende Remote-Objekte:**
- **R1** Form-P-Objekte (all_axes_golden / GN-Chunks): NULL Risiko, wenn +ceb ZULETZT steht. Heute `base+P+"+ceb=6.0+mtool=+mrg=none"`, nachher `(base+P+"+ceb=6.0")+"+mtool=+mrg=none"` -- byte-identisch, auch fuer Debug (+bt steht in beiden Faellen VOR +ceb). Bei anderer Position waere JEDER golden-Chunk unerreichbar.
- **R2** Form-S-Objekte (die 9 Profile, u.a. die lokalen 320): werden verwaist. BAU-Artefakte, KEINE Messdaten -- Messdaten-Doktrin nicht beruehrt. Additiv liegen lassen, nicht loeschen. Kosten = ein Neubau dieser Perm.
- **R3** Lokale .version im Perm-Pfad invalidieren EINMALIG (bekommen erstmals +ceb) -> einmaliger Voll-Neubau der Form-P-Binaries. Genau der in F3 fehlende Effekt, also gewollt -- aber kein Nulleffekt, muss vor einem Mess-Fenster eingeplant werden.
- **R4** Prune-Uebergang: `prune_key_base` liest die ALTE .version (Form P ohne +ceb) und bildet nach dem Schnitt einen Praefix ohne +ceb -> verfehlt das reale Objekt -> "kept", pruned=0 fuer Alt-Artefakte. Konservativ, kein Datenverlust, sichtbar im PRUNE-TESTAT. Loest sich mit R3 von selbst; alternativ einmaliger Legacy-Zweig.
- **R5** Kein Remote-Loeschvorgang noetig oder vorgeschlagen. Alles additiv.

**Befund in einem Satz:** Nicht der Sortier-Unterschied ist der Schaden, sondern dass +ceb in BEIDEN Formen unabhaengig entsteht -- im Einzel-Pfad doppelt (F1/F2), im Perm-Pfad gar nicht in der .version (F3). Ein Verschieben von +ceb aus `cache_key_prefix` in die eine gemeinsame Suffix-Funktion, an letzter Position, heilt beide, ohne einen einzigen bestehenden Form-P-Objekt-Key zu bewegen.

Selbstcheck: `grep -cP '[^\x00-\x7F]'` -> 0 Treffer (ASCII-only). Keine Datei im Repo geaendert (nur Read/grep/sed/find). Alle Zeilennummern am Ist-Stand HEAD 5795fae2 verifiziert. Arbeitskopie des Berichts: /tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/w13.txt