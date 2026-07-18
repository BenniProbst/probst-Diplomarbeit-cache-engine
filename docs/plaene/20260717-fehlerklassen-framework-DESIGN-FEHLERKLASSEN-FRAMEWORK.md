# Design-Dossier — Fehlerklassifizierungs-Framework (Task #29)

**Status:** DESIGN-VORLAGE (kein Bau ohne explizite User-Phasenfreigabe)
**Datum:** 2026-07-17 · **Repo:** comdare-cache-engine (ce = Werkzeug/Framework)
**Direktiven-Basis:** D1 (HW-/Compile-Fehlen → Compiler-Compiler-Fehler, geloggt, misst weiter) · D2 (Algo-Fehler → CSV-Zelle `"failed"` NICHT null + Log neben CSV, Harness misst weiter) · compile-time-only Hot-Path (CRTP+Concept, keine vtable) · nur benannte Lehrbuch-Patterns · Messung NIE als Nullen.

---

## 1. Zweck

Task #29 verlangt: **Fehlerklassen und Behandlung sind für ALLE Achsen → Unterachsen → Algorithmen Pflicht.** Heute existiert **kein** schichtenübergreifender Klassifizierungs-Layer; jede der drei Schichten (CMake-Configure / Build-Subprozess / Mess-Laufzeit) trägt ihr eigenes ad-hoc Vokabular, und der zentrale Begriff „Experiment-Planer Compiler-Compiler-Fehler" ist weder Code-Konzept noch Log-Deklaration. Das Ledger bestätigt das wörtlich (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1931`: „dieser Klassifizierungs-Layer existiert NICHT").

Ziel dieses Dossiers: eine **compile-time-klassifizierte Fehler-Taxonomie** entwerfen, die (i) an die **bereits vorhandenen** Fehler-Träger andockt (keine Parallelstruktur — Direktive `vor_aufgaben_erst_projektstruktur_analyse`), (ii) HW-/Flag-Fehlen als erkennbaren, geloggten, **weiter-messenden** Zustand behandelt statt als stillen Skip oder harten Abbruch, und (iii) die heute konflatierte „valid=false"-Semantik in **N/A (kein Fehler)** vs **`failed` (Fehler)** auftrennt.

---

## 2. IST-Lücken (datei:zeile)

### Schicht A — CMake-Configure (D1-Naht)
- **tests/unit/CMakeLists.txt:3324-3327** (analog :3318-3321): AVX-512-Fehlen wird **still übersprungen** (`check_cxx_compiler_flag(-mavx512f …)` gated den `if`-Block; kein `message()`, kein Log, keine Fehlerklasse). **Direkter D1-Bruch** — HW-Fehlen ist unsichtbar statt klassifiziert.
- **cmake/isa_features.cmake:139-181** (`comdare_apply_simd_extension_flags`): bei fehlender/unbekannter Extension `message(FATAL_ERROR …)` an :141/164/171/175/178/181 → **harter Configure-Abbruch** = „reißt die ganze Pipeline" statt „misst weiter".
- **CMakeLists.txt:414-416** + ~40 weitere `FATAL_ERROR` (cmake/compiler_cache.cmake:71/83/99/107, cmake/paper_binary.cmake:85, tests/unit/perm_codegen_byte_identity.cmake:51/84/90, registry_roundtrip.cmake:49): teils vorbildlich (echte Kontradiktion configure-time fangen), teils **falsche Semantik** für HW-Fehlen. Kein Konzept einer weiter-messenden Fehlerklasse.
- **Arity-Fragilität:** `comdare_add_simd_dispatch_test` (tests/unit/CMakeLists.txt:3285) ist heute durch Quoting (`"${…}"`, Fix 355faa7f) arity-sicher, aber das Muster bleibt fragil: jede unquotete Expansion einer ungesetzten Var droppt ein Arg → CMake-Funktions-Arity-FATAL, der die **gesamte** Configure reißt, ohne Guard/Klassifikation.

### Schicht B — Build-Subprozess (D1-Naht)
- **build_orchestrator.hpp:95-103/115**: `BuildResult{int status; std::string message}` + `using CompileFn = std::function<int(BuildJob const&)>`. Fehler werden **gefangen** (nicht Crash) — brauchbarer Andockpunkt — ABER Exit-Codes **vermischen** Infrastruktur (spawn 127 :432, rsp 125 :481, posix_spawn :410/:418, waitpid :440) mit echter **Compiler-Ablehnung** (g++-Exit, z.B. `-mavx512f unrecognized`). Alle kollabieren auf `status != 0`. → HW-/Flag-Ablehnung (D1) ist **nicht** von einem echten Code-Bug unterscheidbar.
- **cache_engine_builder_iterator.hpp:737** (`if (!b.ok()) continue;`): build-fehlgeschlagene Binary erzeugt **GAR KEINE CSV-Zeile** (Kommentar „ehrlicher Sparse-Kontrast"). **Zentrale D1-Verletzung:** stille Leerstelle statt geloggter, klassifizierter Compiler-Compiler-Zeile.
- **cache_engine_builder_iterator.hpp:746-748/755-757**: DLL-Ladefehler / fehlendes Mess-Interface erhöhen nur `result.load_failed` + `continue` → wieder keine Zeile. Sichtbar nur als Aggregat-Zähler im stdout-Summary (**experiment_run_entry.hpp:265** `load_failed=…`).

### Schicht C — Mess-Laufzeit (D2-Naht)
- **D2 UNIMPLEMENTIERT:** `grep '"failed"'` über libs/ apps/ tools/ scripts/ = **LEER**. Das geforderte Literal existiert nirgends.
- **perm_runner.hpp:147-155** (`gate_failed_result_`): Konformitäts-Gate-Fehlschlag erzeugt **genullte Matrix-Zeile** (genullter POD via `format_perm_result`), markiert nur host-seitig `two_phase_valid=false`/`unified_real=false` — nicht als `failed`-Zelle.
- **perm_runner.hpp:309-317** (`catch(...)`): OOM/Exception während Messung → `total_ns=0, timed_ops=0`, genullter POD. **Bruch von „Messung NIE als Nullen".**
- **cache_engine_builder_iterator.hpp:344-350**: `op_lat`-Spalten schreiben **IMMER** `std::to_string(ol.n/p50/p99)` → ungültige Zeile ergibt `0;0;0`. `total_ns` roh (0) übernommen (:808). Gemischte Null-Semantik: seg-/stat-Spalten geben ehrlich `n/a` (:358-361/:428/:472), Latenz-Spalten hart `0`.
- **system_axis.hpp:135-139/177-180**: `SystemAxisSample{category,value,valid}` — **`bool valid` konflatiert** honest-0 (N/A, kein Fehler) mit echtem Fehler. `invalidate()` setzt pauschal `value=0/valid=false`. Die honest-0-Fälle sind explizit kommentiert (system_axis.hpp:232-237 Perzentil-Phantom, :271-278 MEMORY_FOOTPRINT/FILL_BUFFER, :296-302 PMC unprivilegiert, :330-333 IPC_CPI kein POD-Feld) — sie sind **kein** Fehler und müssen visuell verschieden von `failed` sein.

### Schicht D — Host-Gate-Achse (D1-Detektions-Naht, noch nicht gebaut)
- **hardware_isa_system_axis.hpp:4-8/19/38**: nur **Deskriptor-Rahmen** (`constexpr host_isa()`-Label). Das Laufzeit-Capability-Gate (cpuid-gestützt, „Binary-ISA ⊆ Host-Capability") ist ausdrücklich auf den Planer-/Runner-Konsumenten (PF2-Matrix) **vertagt** — genau die Naht, die D1 tragen müsste.
- **tests/unit/CMakeLists.txt:2824-2825/3282-3283**: `check_cxx_source_runs` setzt `COMDARE_HOST_RUNS_AVX2/AVX512F` (run-failure = leerer String), heute nur zum **Nicht-Registrieren** des Tests genutzt — **nirgends** als klassifizierter, geloggter Fehlzustand in die Mess-/Provenienz-Ebene durchgereicht.

### Quer
- **Kein error_class/FailureClass/compiler_compiler-Typ** im Code (`grep` liefert nur unrelated `validate_profile.hpp`-Substring). Vorhandene `status_*_failed`-Enums (experiment_driver.cpp:132-134/218-220/524-526, module_loader.hpp:21, pruef_dock.hpp:40) sind **Ablauf-Returncodes** für Pipeline-Rahmenphasen, keine per-Achsen/Algo-klassifizierten Zustände. Sie sind aber das **Benennungs-Vorbild**.

---

## 3. SOLL-Taxonomie

**Grundprinzip:** ZWEI disjunkte, compile-time-klassifizierte Domänen entlang der zwei bestehenden Nähte. Die **Klassifikation** (Enums + `constexpr category_of` + Policy-Auswahl) ist in beiden Welten 100 % compile-time. Nur die **Detektion** ist naht-lokale Laufzeit (Sub-Compiler-Aufruf / cpuid bei D1 außerhalb Hot-Path; POD-Status bei D2 im Hot-Path).

### D1 — „Compiler-Compiler" (Planer-Zeit, AUSSERHALB Hot-Path)
`enum class CompilerCompilerErrorClass : std::uint8_t`
| Klasse | Auslöser | Behandlung (Policy) |
|---|---|---|
| `KonfigXmlParse` | Experiment-XML/Registry ungültig | Log + `status_xml_parse_failed` (Rahmenphase darf abbrechen) |
| `ToolchainFehlt` | Compiler/Download/Build nicht verfügbar | **Log deklarieren + Permutation überspringen, Experiment misst weiter** |
| `HardwareErweiterungFehlt` | AVX512 fused-off (prod2), GPU/FPGA fehlt, `-march`-Flag abgelehnt | **Log als „Compiler-Compiler-Fehler" + Permutation-Zeile als klassifizierte Leerstelle, weitermessen** |
| `CompileKombination` | Achsen-Kombi kompiliert nicht (z.B. clang × `-fno-gnu-unique`) | **Log + weiter** (Präzedenz: compiler_system_axis.hpp:30-32 `supports_fno_gnu_unique` = hartes Bau-Gate) |

Detektions-Nähte: (a) g++-stderr aus `.cxx.log` (build_orchestrator.hpp:499) → `HardwareErweiterungFehlt` vs `CompileKombination` vs Infra trennen; (b) cpuid-Gate der `hardware_isa_system_axis` (Binary-ISA ⊆ Host-Capability, je Permutation); (c) CMake `check_cxx_compiler_flag`/`check_cxx_source_runs`-Ergebnis als klassifizierten Zustand statt stillem Skip.

**Wichtig — Infra vs Compiler-Compiler trennen:** `InfraError` (spawn/rsp/waitpid nicht schreibbar, Codes 125/127/-2/-3) ist **keine** D1-Klasse und darf nicht als „HW-Fehlen" verbucht werden. Ohne diese Trennung kann D1 nicht sauber ausgelöst werden.

### D2 — „Runtime-Algo" (Tier-Laufzeit, IM Hot-Path)
`enum class SampleStatus : std::uint8_t { Ok, NotApplicable, SourceUnavailable, Failed }` — ersetzt den konflatierenden `bool valid`.
| Status | Bedeutung | CSV-Serialisierung |
|---|---|---|
| `Ok` | echte Messung | Zahlwert |
| `NotApplicable` | Phantom-Vermeidung / Kategorie nicht anwendbar (system_axis.hpp:232-237/271-278/330-333) — **KEIN Fehler** | honest-N/A-Token (siehe Open Decision OD-1) |
| `SourceUnavailable` | PMC unprivilegiert etc. (system_axis.hpp:296-302) — **KEIN Fehler** | honest-N/A-Token |
| `Failed` | RuntimeAlgoFehler (Gate-Fehlschlag perm_runner.hpp:147, `catch(...)` :309) — **Fehler** | **Zelle = `"failed"`** + Sidecar-Log neben CSV |

Kern-Regel: `Failed` ist in der CSV **visuell distinkt** von N/A und **niemals `0`**. Die `op_lat`-Spalten (iterator:344-350) müssen dieselbe `SampleStatus`-Semantik respektieren statt hart `0`.

### Achse → Unterachse → Algorithmus-Durchgängigkeit
Beide Enums werden über die **Chain-of-Responsibility der rekursiven Dock-Kette** (Planer↔CEB↔Prüf-Dock↔Tier) durchgereicht: jede ABI-Grenze ist ein CoR-Glied, das den Fehler entweder behandelt (Policy) oder klassifiziert an die nächst-niedrigere Ebene delegiert. Ein optionales `error_domain()`-Trait am `CebSystemAxis`-Concept (ceb_system_axis.hpp:20-37) erlaubt jeder Achse, ihre spezifischen Fehlerklassen beizusteuern (Default = keine).

---

## 4. Benanntes Pattern (compile-time-only, CRTP+Concept, keine vtable)

Ein **4-teiliger benannter Stapel** (erfüllt „nur benannte Lehrbuch-Patterns"):

1. **Error-Category / Domain** (Kohlhoff/Boost.System `std::error_category`-Idee) — aber **VTABLE-FREI**: scoped-enum + `constexpr` free function `category_of(E) -> ErrorClass` statt virtueller `error_category`. Bewusste Abweichung vom kanonischen (virtuellen) `std::error_category`, um den Concept-Guard `is_empty_v && !is_polymorphic_v` (topics/axis.hpp:32-36) nicht zu verletzen.
2. **Value-or-Error-Carrier** = Expected/Result (Alexandrescu „Systematic Error Handling", `std::expected<T,E>` C++23) an jeder Naht. `std::expected` ist im Repo bereits im Umlauf (build_orchestrator.hpp, conformance_gate.hpp, iterator).
3. **Behandlung je Klasse** = **Policy-Based Design** (Alexandrescu, Modern C++ Design) = compile-time Strategy, static dispatch, keine vtable. D1-Policy „im Log deklarieren + weitermessen"; D2-Algo-Policy „Zelle=`failed` + Log daneben + weitermessen"; N/A-Policy „honest-0". Präzedenz: `is_ieee754_deterministic` (optimization_level_sub_axis.hpp:52-54), `gcc/clang_march_flag` (extension_hardware_system_axis.hpp:32-35/67-71).
4. **Eskalation Achse→Unterachse→Algo** = **Chain-of-Responsibility (GoF)**, compile-time realisiert, deckungsgleich zur beschlossenen rekursiven Dock-Kette. Präzedenz-Glied: Prüf-Dock-Gate „import→GATE→(nur bei pass)messen" (conformance_gate.hpp:33-38 `ConformanceResult`).

**Single-Source-Muster** zum Spiegeln: `kMeasurementCategoryCount = 16` + `static_assert` gegen Enum-Drift (measurement_category.hpp:32, verifiziert) → analoges `kCompilerCompilerErrorClassCount` / `kSampleStatusCount` mit eigenem Drift-`static_assert`.

**Doktrin-Konformität:** Die Klassifikation gehört auf die **Planer-/Compile-Ebene** (D1) bzw. als **POD-Status** in den `noexcept`-Sample (D2, `collect()` ist bereits `constexpr … noexcept`, system_axis.hpp:166). Kein `throw` im Hot-Loop, keine vtable, kein Runtime-Switch. Bei D1 (außerhalb Hot-Path) sind `std::function`/Exception/`std::expected` erlaubt.

---

## 5. Andockpunkte (additiv, golden==320-neutral bis zur Aktivierung)

1. **NEU** `libs/cache_engine/include/cache_engine/measurement/axis_error.hpp`: `enum class CompilerCompilerErrorClass` + `enum class SampleStatus` + `constexpr category_of` + Count-`static_assert` (spiegelt measurement_category.hpp:32) + Handling-Policy-Structs.
2. **system_axis.hpp:135-139 + 177-180**: `SystemAxisSample` um `SampleStatus status` erweitern; `invalidate()` in zwei benannte Helfer splitten: `mark_not_applicable()` vs `mark_failed()`. (POD/standard-layout/trivially-copyable bleibt erhalten — `SampleStatus` ist `uint8_t`.)
3. **ceb_system_axis.hpp:20-37**: `CebSystemAxis`-Concept um optionales `error_domain()`-Trait ergänzen (Default = keine Fehlerklassen).
4. **build_orchestrator.hpp:94-103/115**: `CompileFn`/`BuildResult` auf `std::expected<Artifact, CompilerCompilerError>` heben; `CompilerCompilerError` trennt `HardwareErweiterungFehlt`/`CompileKombination` (D1) von `InfraError` (spawn/rsp), abgeleitet aus `.cxx.log`-stderr (:499).
5. **cache_engine_builder_iterator.hpp:737 + :746-748/:755-757**: stilles `continue` durch Emission einer **klassifizierten Zeile** ersetzen (D1 → geloggte Compiler-Compiler-Fehlerzeile; Load-Fehler → klassifizierte Zeile statt nur Aggregat-Zähler).
6. **perm_runner.hpp:150/:317** + **iterator:344-350**: `gate_failed_result_`/`catch(...)` so umbauen, dass betroffene Zellen `SampleStatus::Failed` → CSV `"failed"` tragen statt genulltem POD; `op_lat`-Spalten respektieren `SampleStatus` statt hart `0`.
7. **tests/unit/CMakeLists.txt:3285-3327 / cmake/isa_features.cmake:139-181**: Arity-/HW-Fehlen als deklarierten Planer-Fehler fangen — `message(STATUS|WARNING)` mit Compiler-Compiler-Fehlerklasse ins Configure-Log, **NICHT** `FATAL_ERROR` (Pipeline darf nicht reißen).

**Struktureller Vorläufer:** `axis_operability_classification.hpp` (Operative/OperativeCapable/Descriptor) klassifiziert Mess-**Fähigkeit**, nicht Fehler — Andock-Punkt/Namensvorbild, keine Fehler-Tabelle.

---

## 6. Erster Increment-Vorschlag (klein, isoliert, golden-/messneutral, testbar)

**INC-29.0 — `axis_error.hpp` als reiner Enum-+-`constexpr`-Kern (kein Aufrufer, kein Verhalten geändert).**

Nur die **Taxonomie-Definition** als neue Header-Datei, ohne jede Anbindung an Configure/Build/Runner:
- `enum class CompilerCompilerErrorClass : std::uint8_t {…}` (4 Klassen) + `enum class SampleStatus : std::uint8_t { Ok, NotApplicable, SourceUnavailable, Failed }`.
- `constexpr ErrorClass category_of(...)` (vtable-frei).
- `inline constexpr std::size_t kCompilerCompilerErrorClassCount` / `kSampleStatusCount` + Drift-`static_assert` (Muster von measurement_category.hpp:32).
- `static_assert`s: Enums sind `uint8_t`, trivially-copyable; `SampleStatus::Failed != SampleStatus::NotApplicable` (Trennungs-Garantie); `SampleStatus::Ok == 0` (Default-Kompatibilität).

**Warum das zuerst:** rein additiv, kein Aufrufer → `golden==320` mathematisch unberührt; keine CSV-, Configure- oder Hot-Path-Änderung; vollständig header-only + compile-time; als **Unit-Test** (constexpr-`static_assert`-Suite, analog registry_roundtrip) sofort verifizierbar. Es fixiert die **Grundsatz-Weichen NICHT** (Serialisierungs-Token, D1-Verortung ce/super, expected-vs-enum bleiben offen) und ist der kleinste Baustein, auf dem alle folgenden Increments (Sample-Erweiterung, CompileFn-Hebung, CSV-`failed`) aufsetzen.

**Bewusst NICHT in INC-29.0:** keine Änderung an `SystemAxisSample` (das berührt POD-Layout aller Mess-Achsen), keine `CompileFn`-Signatur-Hebung, keine CSV-Serialisierung, keine CMake-Änderung. Diese folgen als INC-29.1+ nach separater Freigabe.

---

## 7. Verifikation

- **INC-29.0:** neuer constexpr-Unit-Test (`static_assert`-Suite) im offiziellen ctest-Pfad; `ce`-Standalone-Build grün + super-Sub-Build grün (lokal-first, Direktive `dual_verifikation_baremetal_lokal_und_ci`). Da kein Aufrufer existiert: Diff-Review bestätigt Null-Verhaltensänderung.
- **golden==320-Nachweis:** vor/nach INC-29.0 identische Binary-Menge (kein Codegen-Pfad berührt); Beleg wörtlich, kein ✓ ohne Ausgabe.
- **Spätere Increments (Vorschau):** D1-Aktivierung mit einem **erzwungenen** HW-Fehlen (z.B. `-mavx512f` auf AVX2-only-Host) muss (a) eine Log-Zeile „Compiler-Compiler-Fehler: HardwareErweiterungFehlt" erzeugen UND (b) das Experiment weiterlaufen lassen. D2-Aktivierung mit einem injizierten Algo-Fehler muss die betroffene CSV-Zelle als literal `failed` (nicht `0`, nicht `n/a`) + Sidecar-Log zeigen; N/A-Fälle bleiben distinkt.
- **CI:** gesamte Pipeline (ce+super, prod1+prod2, alle Jobs) hart grün — kein `allow_failure`-Freibrief.

---

## 8. TABU

- **KEIN Bau ohne explizite User-Phasenfreigabe** (`jede_aufgabe_ultracode` + `increments_architekturkonform`). Dieses Dossier ist Vorlage.
- **KEINE vtable / kein Runtime-Switch / kein `throw` im Hot-Path** — `category_of` bleibt `constexpr` free function; `SampleStatus` bleibt POD-`uint8_t`; `collect()` bleibt `noexcept`. Kanonisches (virtuelles) `std::error_category` wird bewusst gemieden.
- **KEINE Parallelstruktur** — an vorhandene Träger (BuildResult, SystemAxisSample, status_*-Enums, CebSystemAxis-Concept) andocken, nicht daneben bauen.
- **KEIN `FATAL_ERROR` für HW-/Flag-Fehlen** — Configure-Log-Deklaration statt Pipeline-Riss.
- **KEINE genullte Mess-Zeile** — Messung NIE als Nullen; `failed`/N-A statt `0`. `op_lat`-Spalten dürfen nicht länger hart `0` schreiben.
- **KEINE CT→RT-Degradierung** — Klassifikation compile-time, nur Detektion naht-lokal laufzeit.
- **KEINE musterlose Fehlerbehandlung** — jede Schicht ein benanntes Muster (Error-Category / Expected / Policy-Based / CoR).
- **Infra ≠ Compiler-Compiler** — spawn/rsp-Fehler (125/127) nicht als D1-HW-Fehlen verbuchen.
- **NUR Enum-Kern in INC-29.0** — kein POD-Layout-Eingriff, keine Signatur-Hebung, keine CSV-/CMake-Änderung im ersten Schritt.