> # ⚠️ KORREKTUR-KOPF (2026-07-17, User-Ruling F1/F2/F3) — DIESES DOSSIER IST TEILWEISE IRRLÄUFER
> Die **architektonische Verortung** in §2/F1 (dedizierte `OptimizationLevelSystemAxis`-Geschwister-Achse)
> ist **FALSCH** und der „global vs. per-Ausprägung"-Fork (F3) **kategorial ungültig**. Korrekte Verortung
> per User-Ruling (verbatim im Ledger §20): Die Optimierungsstufe ist eine **dynamische Unterachse UNTER der
> Compiler-System-Haupt-Achse**, die auch Flags/Commands je Compiler als permutierbare Unterachsen trägt
> (→ verschiedene Tier-Binaries). **F2 = voll {O0..Ofast} + Hardware-Erweiterungs-Unterachsen (SIMD/AVX,
> deep research).** **F3 = ALLES per XML konfigurierbar (Achse + Unterachsen); „global" existiert im
> dynamischen System NICHT.** Die IST-Nähte (§3), TABUs (§6) und Verifikations-Gates (§5) dieses Dossiers
> bleiben gültig; nur die Verortung (§2) + F1/F3 (§7) sind durch die Neuplanung ersetzt.
> Memory: `project_compiler_systemachse_traegt_dynamische_xml_unterachsen`.

# BAUPLAN-INC-2c.opt — Optimierungsstufe (Richtung -O3) als System-Achsen-Flag (Option A)

Status: PLAN (ultracode-Synthese aus 4 Kartierungen). Kein Bau vor expliziter Phasen-Freigabe (§20.B V6.3-Prozessregel). ABI-neutral geplant (kein weiterer 4→5-Bump; der Major-Bump war einmalig in 2b, ce 86769bc9).

## 1 ZWECK + Abgrenzung
Die heute hartkodierte Optimierungsstufe der Mess-Tier-Binaries (`-O2`, build_orchestrator.hpp:476) und der fehlende `-O` der mess-charakteristischen Verifikations-Tests werden durch eine **compile-time-Achsen-gesteuerte** Optimierungsstufe ersetzt (WERT aus Achse · ORT = CompileFn-Naht + Test-Target-Naht · PROVENIENZ = H-10-Sidecar · NIE binary_id). Ziel: `test_all19_segment_timer` grün (Cache-Line-Layout-Effekt >20% nur UNTER -O3 sichtbar) OHNE Schwellen-Aufweichung.

**Zwei 5% strikt getrennt** (User-Klärung 2026-07-17, test_all19_segment_timer.cpp:139-141):
- **memory_layout-5%** = Gegenstand hier: Stride 48 (aos_strict) vs 64 (cache_line_aligned); Sichtbarkeit hängt an der Optimierung. Option A verstärkt nur die SICHTBARKEIT.
- **Compiler-5%** = SEPARAT, über die Compiler-System-Achse (gcc|clang-Delta gegen DIESELBE Konfig). NICHT Gegenstand von 2c.opt.

Scope: NUR Registry-Achse **15.2** (Optimierungsstufe). LTO/PGO/Target-Arch (15.3/15.4/15.5) sind AUSSERHALB (LED:1922 nennt nur 15.2).

## 2 ARCHITEKTONISCHE VERORTUNG (belegt per Elimination)
LED:1922 sagt wörtlich „Hardware-System-Achse-Flag". Das ist NICHT eindeutig eine der 6 bestehenden Achsen — Auflösung durch Elimination:
- **(a) Hardware/ISA-Achse — AUSGESCHLOSSEN (Doku):** hardware_isa_system_axis.hpp:4-7 + ADDENDUM §5.2 (autoritativ) = reiner Host-Deskriptor + Mess-Gate, „treibt NICHT den Bau". Sie zur Bau-Treiberin umzuwidmen widerspräche der autoritativen Rollenzuweisung.
- **(c) Compiler-Achse — AUSGESCHLOSSEN (User):** LED:1922 + test:139-141 trennen opt-level explizit von der Compiler-5%; compiler_system_axis.hpp:22-57 trägt heute keine Opt-Stufe (nur compiler_id/driver_default/supports_fno_gnu_unique).
- **(b) Erweiterungshardware-Achse — BLAUPAUSE, nicht Träger:** extension_hardware_system_axis.hpp:24-71 ist die EINZIGE bau-treibende Achse an der CompileFn-Naht → das Muster, das zu spiegeln ist. Aber semantisch SIMD/GPU-Genus; die Gattungs-Doktrin (feedback_gattung_own_genus_own_abi: eigenes Genus, schneiden sich nicht) verbietet das Einfalten der Opt-Stufe.

⇒ **Doku-konsistente Verortung: eine NEUE dedizierte `OptimizationLevelSystemAxis` als Geschwister unter `CebSystemAxis<Derived>`** (ceb_system_axis.hpp:20-22, `axis_kind()==system_config`), die die extension-hardware-Blaupause spiegelt. „Hardware-System-Achse-Flag" (LED:1922) = die FAMILIE bau-treibender System-Achsen, nicht die literal gelabelte `hardware`-Achse.

**RESIDUAL-FORK** (siehe §7-F1): neue Geschwister-Achse (Plan-Empfehlung, Genus-sauber) vs. Einfalten in `ExtensionHardwareSystemAxis`. Nicht verbatim geruled → User-Entscheidung.

## 3 IST-Nähte (datei:zeile)
- **Naht #1 — CompileFn/Tier-Binaries:** `rf << "-O2\n";` (build_orchestrator.hpp:476) — einziger `-O`-Treffer der Datei, unbedingt, kein Parameter. Signatur make_gpp_compile_fn(include_dirs, defines, cxx, link_libs) :466-468. defines verbatim ins .rsp :483. Zwei Aufrufstellen: profile_run_facade.cpp:226 (run_profile) + :402 (run_experiment).
- **Bestehende Flag-Verdrahtung (Vorbild):** perm_extension_hardware_cflags() :116-130 (liest active_simd_policy() :109-114, env `COMDARE_PILOT_SIMD_POLICY`, Default Generic = leer = byte-identisch Ist) → angehängt in perm_mess_defines() :156.
- **H-10-Provenienz:** system_axes_version_suffix() :172-174 = `"+ext="+…+"+cxx="+…`; KEIN opt-Feld. Speist dll_is_current-Skip (build_orchestrator.hpp:170/282).
- **Naht #2 — Verifikations-Tests:** COMDARE_MCE24_MEASURED_TESTS (tests/unit/CMakeLists.txt:1709, inkl. test_all19_segment_timer :1710) foreach :1721-1735 — NUR cxx_std_23 + platform/Mess-Defines, **KEIN `target_compile_options(-O…)`**. Optimierung käme allein aus CMAKE_BUILD_TYPE; build-conf hat leeren BUILD_TYPE ⇒ effektiv `-O0`.
- **Toter Pfad (NICHT annehmen aktiv):** COMDARE_set_default_warnings (compiler_flags.cmake:31-33, `-O`-Config-Genex) hat 0 Aufrufer.
- **CMake-Präzedenz (per-Target-HW-Flag):** comdare_apply_simd_extension_flags(target ext) in cmake/isa_features.cmake:139 (top-level included CMakeLists.txt:457).
- **Vokabular (orphan-Deskriptor):** Achse 15.2 O0/O1/O2/O3/Ofast in axis_library_registry.hpp:347-356 (nicht verdrahtet, LEDGER:427).
- **MSVC-Zwilling:** make_system_compile_fn (build_orchestrator.hpp:450-461) — GAR kein `/O`, KEIN defines-Kanal.

## 4 SOLL — Mini-Increments
**2c.opt-a — Achsen-Header (additiv, verhaltensneutral).**
Andock: neuer `libs/cache_engine/include/cache_engine/measurement/optimization_level_system_axis.hpp`, Geschwister von extension_hardware_system_axis.hpp. CRTP+Concept-Guard (`is_empty_v && !is_polymorphic_v`, kein vtable), `CebSystemAxis<Derived>`-Ableitung. Varianten `OptO2` (Default = Ist-Verhalten `-O2`) + `OptO3`; `static constexpr do_gcc_opt_flag()/do_clang_opt_flag()/do_msvc_opt_flag()` (gcc/clang `-O2`/`-O3`, MSVC `/O2`); Vokabular deckungsgleich zu 15.2. Verifik.: ce-standalone build-conf kompiliert; static_assert je Ausprägung; Concept-Guard hält.

**2c.opt-b — Naht #1 (CompileFn, byte-identisch).**
Andock: build_orchestrator.hpp:476. **Empfohlen: neuer make_gpp_compile_fn-Parameter `opt_flag`** (analog `link_libs`, INC-0-Präzedenz :466-468) ersetzt :476 direkt → strukturell KEIN Doppel-`-O` möglich. Gespeist aus neuer perm_optimization_cflags() (Spiegel von :116-130), an beide Aufrufstellen :226/:402. (Alternative: defines-Kanal-Route — dann MUSS :476 entfernt werden, Achse trägt Default-O2, sonst Doppel-Flag; wegen Fragilität nachrangig.) Verifik.: .rsp mit Default-Achse enthält genau ein `-O2`, Tier-Binary hash-identisch zu Ist; mit OptO3 genau ein `-O3`.

**2c.opt-c — H-10-Provenienz.**
Andock: system_axes_version_suffix() :172-174 → `+opt=<level>` anhängen. Verifik.: build_version zeigt `+opt=`; unter O3 gebaute .so wird NICHT fälschlich als current geskippt (dll_is_current :170/282); binary_id/golden unberührt. ACHTUNG Sidecar-Lücke: build_system_axis_levels() (registry_to_axis_levels.hpp) hat 0 Aufrufer (Audit-Auflage A) — Provenienz MUSS über system_axes_version_suffix laufen, sonst erbt opt dieselbe Lücke.

**2c.opt-d — Naht #2 (Verifikations-Tests).**
Andock: neue zentrale Funktion `comdare_apply_optimization_level_flags(target level)` als Geschwister von comdare_apply_simd_extension_flags in **cmake/isa_features.cmake** (HW-Flag-Familie, da Option A HW-System-Achse rult + direkter Präzedenz-Zwilling). Aufruf AUSSCHLIESSLICH in der Measured-foreach (tests/unit/CMakeLists.txt zwischen :1726 und :1732), `target_compile_options(${_dt} PRIVATE -O3)`. Verifik.: test_all19_segment_timer unter -O3 → Effekt >20% → Check grün (rel>0.05, Schwelle exakt); PLAIN_TESTS + comdare_add_test-Pfad + Restsuite unberührt.

**2c.opt-e — MSVC-Symmetrie (ZURÜCKGESTELLT).**
make_system_compile_fn braucht erst einen Flag-Kanal (Signatur-Erweiterung). Cluster=Linux ⇒ POSIX-first; Achse trägt msvc_opt_flag() bereits (2c.opt-a), Naht-Verdrahtung als Folge-Increment.

## 5 Reihenfolge + Gates
Reihenfolge: **a → b → c → d** (→ e zurückgestellt). Je Increment (feedback_dual_verifikation, lokal-first):
- **Dual-grün:** ce-standalone build-conf + super-Sub-Build build-i2 literal grün (kein ✓ ohne wörtliche Ausgabe).
- **cf22:** clang-format via `~/tools/cf22/usr/bin` vor Commit.
- **golden-neutral (§19.E-4-Checkpoint):** golden==320-Roundtrip byte-identisch; Nachweis binary_id/POD sizeof 1344/kV3AxisSchema/kCompositionAxisNames UNVERÄNDERT (POD/ABI-Diff leer). Messdaten nie löschen.
- **Granulare Commits + beide Remotes ref-gleich** (origin=gitlab, github=github). CI GEPARKT (Infra-down; nicht auf Pipelines warten, feedback_ci_infra_blocked).

## 6 TABUS / Risiken
- **binary_id/golden-TABU:** opt-Wert NIE in binary_id/09b/kCompositionAxisNames; Provenienz nur Sidecar/build_version.
- **Byte-Identitäts-Falle:** Default-Achse MUSS `-O2` exakt reproduzieren, sonst Rebuild/Hash-Bruch ALLER Tier-Binaries.
- **Messdaten-Falle:** Mess-Tier-Default bleibt `-O2`; ein anderes `-O` = eigene build_version. NICHT global auf -O3 kippen (verfälscht persistierte Reihen, feedback_messdaten_nie_loeschen).
- **Doppel-O-Falle:** :476 NICHT stehen lassen + zusätzlich -O3 via defines (Parameter-Weg löst strukturell).
- **Schwellen-TABU:** 5%-Layout-Schwelle NICHT aufweichen (2C-BEFUND:22-23) — Fix = -O3 bauen.
- **CT→RT-VERBOT:** Achse compile-time CRTP+Concept; env-Pilot-Schalter (analog COMDARE_PILOT_SIMD_POLICY) nur als Pilot, Achse bleibt compile-time.
- **Suite-Scope-TABU:** opt-Flags NUR in Measured-foreach, nicht PLAIN/global/CMAKE_CXX_FLAGS.
- **Toter-Pfad-Falle:** NICHT auf COMDARE_set_default_warnings verlassen (0 Aufrufer).
- **Compiler-Achse nicht vermischen; ABI-neutral (kein 4→5-Bump); Compiler-Dialekt getrennt (gcc/clang -O vs MSVC /O); No-Parallelstruktur; No-Python/offizieller CMake-Weg.**

## 7 OFFENE FRAGEN (nur genuin nicht-auflösbar)
- **F1 (USER-ENTSCHEIDUNGS-FORK, tragend):** Achsen-Verortung — **NEUE dedizierte `OptimizationLevelSystemAxis`-Geschwister** (Plan-Empfehlung §2, Genus-sauber) **vs. Einfalten in `ExtensionHardwareSystemAxis`**. (Hardware/ISA-Erweiterung + Compiler-Achse sind doku-/user-ausgeschlossen, §2.) Nicht verbatim in Ledger/Bauplan geruled → User muss wählen.
- **F2:** Varianten-Satz — nur `{O2,O3}` (Plan-Empfehlung, LED:1922 „Richtung -O3", minimal + erweiterbar) vs. voll 15.2 `{O0,O1,O2,O3,Ofast}`. Nicht gepinnt.
- **F3 (Bestätigung):** Mess-Tier-Default — `-O2`-Default + O3 als wählbare Ausprä. (Doku-Lean stark: H-10/Q5-Byte-/Messdaten-Identität) vs. globaler Kipp auf -O3. Doku-Lean klar, aber nicht verbatim geruled → vor Bau bestätigen.