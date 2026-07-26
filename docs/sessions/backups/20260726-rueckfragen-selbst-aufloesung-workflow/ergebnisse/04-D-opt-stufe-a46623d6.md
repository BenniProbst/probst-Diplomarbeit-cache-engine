# 20260726-rueckfragen-selbst-aufloesung-workflow / D-opt-stufe (agent a46623d6)

runId: wf_bb5d71e9-fdb
agentId: a46623d6b57e35909
label-Zuordnung: D-opt-stufe (Prompt-Marker-Deckung 100%)

---

PUNKT D - OPT-STUFE VOLL-BAU-4 (E-15): AUFLOESUNG

## 1. Owner-Aussagen-Kette (neueste gewinnt)
1. 2026-07-17T16:07-16:08, Owner verbatim: "Bitte sonts Option A" / "mit flags je
   hardware Achse richtung O3" / "Aber volle Kontrolle nach Plan"
   -- verlauf-queued-ergaenzung-04.txt:1602-1608 (Kontext = roter
   test_all19_segment_timer, .../verlauf-queued-ergaenzung-04.txt:1586-1589);
   Wiedergabe in verlauf-18.txt:815. "Richtung O3" ist damit die Antwort auf den
   Layout-/Cache-Line-Check, NICHT auf den Voll-Bau.
2. OF-2 (17.07., LEDGER:1961 verbatim): "Die Standardeinstellung von CEB ist Ofast
   ... nichts gepinnt, JEDES TEIL ist beweglich."
3. A1 (2026-07-18, LEDGER:1977 verbatim-Referat): "CEB-Default O3 (nicht
   O2/Ofast; IEEE-754-deterministisch, wahrt 1-Thread-Mess-Determinismus),
   NICHTS global gepinnt". -> NEUESTE Aussage zur Stufe; superseded OF-2s
   Ofast-Buchstaben-Lesart. Der frueher gesetzte O2-Pin wird dort explizit als
   Ledger-OF-2-Verstoss verworfen.
4. A3 (LEDGER:1977): opt_level = XML-Liste/Range je Experiment, "per Tier-Binary
   oder gegeneinander antretende Ranges".

## 2. Ebenen-Trennung (Pflicht, sonst Vermischung)
- Ebene A "opt_level-Unter-Achse unter compiler" ({O0,O1,O2,O3,Ofast}) -> Flag an
  der CompileFn-Naht der TIER-BINARIES; binary_id-NEUTRAL, wirkt nur auf
  build_version/H-10-Sidecar (+opt=). Belege: optimization_level_sub_axis.hpp:9-14,
  :41, LEDGER:2012.
- Ebene B "cmake-Build-Type Debug/Release" (§61) -> Harness/Planer/CEB. §61-Default
  (LEDGER:3184): "Modi Messung+Release => Release-cmake-Compile; Debug-Modus =>
  cmake-Debug-Compile"; Debug = DUAL-COMPILE (LEDGER:3189).
- Ebene B UEBERSTIMMT Ebene A im Debug-Weg: profile_run_facade.cpp:499 /:529 /:1004
  /:1030 `facade_build_type_is_debug() ? ex::debug_flags_for_toolchain() :
  perm_opt_level_cflags(tp_ptr)`, und debug_flags_for_toolchain() == "-O0 -g"
  (build_orchestrator.hpp:691). Perm-Identitaet bleibt im Stempel O3, die echte
  Einstellung traegt +bt=Debug (build_orchestrator.hpp:687-688).

## 3. FESTLEGUNG je Lauf-Art

### (a) Voll-Bau 2^17 (golden, Mess-Modus)
KEINE Einzelstufe -- der Voll-Bau FAEHRT ZWEI Stufen als System-Perm-Achse:
opt_level = {O2, O3} x simd = {no_extension, avx2} = die 4 System-Perms.
Belege literal:
- all_axes_golden.profile.xml:186-198 (`<compiler><opt_level><option value="O2"/>
  <option value="O3"/>`, `<extension_hardware><simd>` no_extension + avx2)
- Begruendung im selben Block, :180-182: "opt_level = O2 + O3 (deterministische
  Mess-golden-Baseline, §32-F4; Ofast bewusst WEGGELASSEN -- bricht IEEE-754-/
  Run-to-Run-Determinismus + den CRC64-golden-Anker)"; ":183-185 system_config ->
  binary_id-NEUTRAL: multipliziert NUR die BAU-Matrix/Sidecar ... NIE N=2^17".
- identisch tests/unit/thesis_tiere/experiment_golden.xml:67-83 (+ Kommentar
  ":69-70 O2/O3 = deterministische Mess-golden-Baseline (E1b, IEEE-754)").
- Fallback bei stummer XML = O3: DefaultOptLevelOption = OptO3Option
  (optimization_level_sub_axis.hpp:128) mit static_assert :142 "Ruling 2026-07-18:
  CEB-Default = O3"; gezogen in profile_run_facade.cpp:326-332,
  profile_run_entry.hpp:729, experiment_plan_director.hpp:1713.
- cmake-Ebene: Release-Compile (§61, LEDGER:3184), da Voll-Bau = Modus Messung.
- Ofast: AUSGESCHLOSSEN fuer golden, lebt additiv als +opt=-Sidecar-Vergleichsreihe
  (LEDGER:1977; optimization_level_sub_axis.hpp:121-127).
- Ist-Beleg aus einem echten Lauf (K7b-Stempel, prod1 23.07.):
  `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0`
  -- docs/sessions/20260723-SESSION-nacht-ci-reparatur-s4-batch-gn11-belege.md:78.
  Das ist die O3-Zelle des Perm-Kreuzes (Smoke-Profil m3v2, 8 perm.dll).

### (b) Mess-/Cache-Line-Beweise (Layout-Sensitivitaets-Tests)
FESTGELEGT: -O3, explizit und deterministisch, ausdruecklich NICHT Ofast.
- tests/unit/CMakeLists.txt:1787-1795 Begruendung wortnah zum Owner-Satz: der
  Check ist "NUR UNTER Optimierung >5% sichtbar ... im unoptimierten Default-Build
  maskiert der Instrumentierungs-Overhead den Cache-Line-Effekt (Median-of-7 misst
  physikalisch ~3-4% < Schwelle -> CI-Rot). -O3 (deterministisch, IEEE-754-treu,
  NICHT Ofast) macht den Effekt real messbar."
- Durchsetzung Zeile 1796: `comdare_apply_optimization_level_flags(
  test_all19_segment_timer O3)`; Naht = cmake/isa_features.cmake, Spiegel von
  simd_extension (LEDGER:1966).
- Wirkungs-Beleg literal: "unter -O3 rel_diff -33% bis -42% stabil ueber 5 Laeufe
  (Deep-Research-Vorhersage >20% bestaetigt)" -- LEDGER:1966.
- Scope-Grenze im selben Kommentar (CMakeLists.txt:1794-1795): "Nur dieses eine
  Target (die Observer-Tests der Liste tragen honest-0-Kontrakte, die unter -O3
  nicht ohne Not verschoben werden sollen)."
- Konsequenz: Cache-Line-Beweise duerfen NIE aus einem Debug-Modus-Lauf stammen
  (dort -O0 -g, Ebene B; siehe Abschnitt 2) -- deckt die E-15-Sorge
  "unoptimiert sind Layout-Messwerte nicht aussagefaehig"
  (20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md:70-72).

## 4. "flags je hardware Achse" - Verortung heute
Der Owner-Satz band die Flags an die Hardware-Achse; die spaeteren Rulings haben
das aufgeteilt, nicht widerrufen: OF-1 faltet CPU-SIMD/AVX unter die
compiler-Haupt-Achse, GPU/FPGA werden dyn. System-Hauptachsen (LEDGER:1961);
F-SIMD realisiert `SimdSubAxis` unter extension_hardware, spiegelbildlich zu
compiler/opt_level (LEDGER:2096, :2024). Ist-Realisierung = genau das
opt_level x simd-Kreuz von Abschnitt 3(a), ISA-gegated (LEDGER:2021).

## 5. NICHT durch die Quellen entschieden (explizit, kein Raten)
- Ob der neue golden (N=2^17, §33) O2 BEIBEHAELT: der O2-Wert war urspruenglich der
  Byte-Anker zur alten Reihe, und dieser Anker wurde entfernt (LEDGER:1977:
  "O2-Byte-Anker in system_axes_version_suffix ENTFERNT (+opt= immer) -> golden-
  Rebuild unter O3"). Die golden-XML fuehrt O2 dennoch weiter als
  Baseline-Vergleichsstufe. Beides steht so da; keine Owner-Aussage entscheidet,
  ob O2 im NEUEN 2^17-Lauf noch mitlaeuft oder auf O3-allein reduziert wird
  (halbiert die Bau-Matrix). -> User-Entscheidung erforderlich.
- Ob der "volle XML-permutierte opt_level-Raum" (O0/O1/Ofast) fuer den Voll-Bau-4
  gefahren wird: laut CMakeLists.txt:1793 + LEDGER:1966 "folgt mit dem Planer
  (2c.opt-g/h)" - kein Termin, keine Owner-Freigabe fuer den Voll-Bau gefunden.
- Ob weitere mess-charakteristische Targets ausser test_all19_segment_timer O3
  erhalten sollen: CMakeLists.txt:1794 verschiebt das bewusst ("nicht ohne Not").

Selbstcheck: ASCII-only geprueft (grep -P '[^\x00-\x7F]' == 0 Treffer, ausser dem
Zeichen § in Paragraphen-Verweisen, das laut Direktive zulaessig ist).
