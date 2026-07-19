# Konformitaets-Audit 9 Dimensionen (ultracode wf_524136e9)
> 2026-07-18, 12 Agenten, adversarial, neueste-Fakten-gewinnen. Anforderungen(Ledger+Memories) <-> Design <-> Code. Grundlage der Konformitaet.

# KONFORMITAETS-REPORT — comdare-cache-engine

Konsolidierung 9 Dimensionen · Stand 2026-07-18 (INC-2d / ABI-6) · Grundlage der Konformitaet

---

## 1 · GESAMT-VERDIKT: 4/9 KONFORM

| | Dimensionen | Anz. |
|---|---|---|
| **KONFORM** | metaprog · sequentialitaet-mess · provenienz-sidecar · gattung-genus | 4 |
| **TEILWEISE** | achsen-schichtung · binary-id-golden · fehlerklassen · bplusbaum-steuerung · prozess-remotes | 5 |
| **NICHT-KONFORM** | — | 0 |

**Executive Summary.** Kein harter Bruch, keine kritische Abweichung. Hoechste Severity = **mittel** (4 Befunde). Die metaprog-Striktheit (CRTP+Concept, kein vtable/variant/Runtime-Switch im Hot-Path) ist guard-verankert und voll durchgesetzt; ebenso Mess-Sequentialitaet (1-Thread), Provenienz-Trennung (System `.version` vs Organ `.algos`) und das 5-Genera-Modell. Die 4 mittel-Befunde sind reale **Struktur-/Verdrahtungsluecken**, nicht Metaprog-Verstoesse: (a) fehlender aktiver `extension_hardware`-Familien-Knoten; (b) binary_id-Organ-Disziplin ist Autor-Konvention statt struktureller Guard; (c) Thesis-Profil-Pfad steuert System-Achsen ueber `COMDARE_PILOT_*`-Env statt XML/Baum; (d) unmarkierter NAS-SMB-Behelfsweg neben dem einen offiziellen measure-drop-Pfad. Der Rest ist ganz ueberwiegend **Doku-/Kommentar-Drift** aus dem ABI-4/5→ABI-6-Uebergang (Slot-Zahlen 19/18/15/11/7 statt live 17/13/9/5) — kein Verhaltens-, kein Golden-Effekt.

---

## 2 · DIMENSIONS-VERDIKTE + bestaetigte Abweichungen (kritisch→gering)

### 2.1 metaprog — KONFORM
Keine Abweichung. Positiv belegt: `topics::Axis<Derived>` empty base ohne virtual (`libs/cache_engine/topics/axis.hpp:26-36`); `AxisConcept` erzwingt `is_empty_v && !is_polymorphic_v`; abi/-variant-Insel §23-quarantaeniert, einziger Konsument `tests/unit/test_abi_interface.cpp`; Guard `tests/unit/test_striktheit_metaprog_guard.cpp:85-97` bricht bei Insel→Live-Wanderung. Verbliebene `std::variant` = ausgenommene Runtime-States (`concepts/pressure_state.hpp:49`) + Fehlertraeger (`measurement/axis_error.hpp:122-124`).
- *(Beobachtung, gering)* Dach-Uneinheitlichkeit: `telemetry`/`simd_extension`/`general_hardware` an plain `AxisBase` statt `topics::Axis`-Dach — Struktur-Frage (§21.E), nicht Metaprog; alle non-polymorph. `axes/telemetry_axis/axis_11_telemetry_strategy_base.hpp:11`, `topics/hardware/axis_09b_simd_extension/..._strategy_base.hpp:21`.

### 2.2 achsen-schichtung — TEILWEISE
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | `extension_hardware` (6. System-Achse) hat KEINEN aktiven Familien-Knoten. Einzige `axis_label()=="extension_hardware"`-Familie ist DEPRECATED (F-SIMD); `SimdSubAxis` deklariert `parent=="extension_hardware"`, aber kein aktiver `CebSystemAxis` traegt das Label → Symmetrie `compiler`(Haupt)→`opt_level`(Unter) NICHT gespiegelt. | `include/.../measurement/extension_hardware_system_axis.hpp:4`; `include/.../measurement/simd_sub_axis.hpp:37` | KOORDINIERTE-REIHENFOLGE Schritt 5 (`SimdExtensionHardwareAxis`-Knoten JA, symmetrisch Gcc/Clang); §21.B/§21.D |
| gering | Freigabe/Durchsetzung-Kontrakt (Organ-SIMD ≤ System-Zulassung) nur in Kommentaren, kein constexpr-Gate. Rolle konform modelliert, Enforcement-Naht deferred zu PF2-Matrix. | `include/.../measurement/target_isa_system_axis.hpp:7`; `include/.../measurement/hardware_isa_system_axis.hpp:6` | §21.E; KOORDINIERTE Schritt 4 `freigabe_contract` (INC-1c) |
| gering | Stale 18/19-Slot-Kommentare bei korrektem 17-Slot-Code. | `builder/experiment_tree/genus_binding_traits.hpp:12`; `include/.../measurement/ceb_system_axis.hpp:7` | §22 (kCompositionAxisNames=17) |

### 2.3 binary-id-golden — TEILWEISE
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | XML-Profil→Baum erzwingt Organ-only-binary_id NICHT strukturell: `build_axis_levels` routet JEDE aktive `permute_axis` ungefiltert ins statische Level (keine Beschraenkung auf `kCompositionAxisNames`), `StaticAxisNode::serialize()` emittiert jedes statische Level → ein Profil mit `<axis ref="isa">`/`simd_extension`/`telemetry` erzeugt binary_ids MIT System-Segmenten. Golden bleibt sauber nur, weil m3v2 nur Organ permutiert = **Autor-Konvention statt Struktur**. | `builder/experiment_tree/profile_to_tree.hpp:82` (+ `validate_profile.hpp:141`, `experiment_tree.hpp:124`) | §21.B binary_id-Disziplin; achsen-nachschlagewerk (0) |
| gering | Stale 18/19-Slot-Kommentare (`queuing_q2=<W18>`, "19-Achsen-binary_id") bei 17-Slot-Code. | `builder/experiment_tree/axis_path_serialization.hpp:10` (+ :88); `tests/.../test_profile_roundtrip.cpp:17` | §22 INC-2d |

### 2.4 sequentialitaet-mess — KONFORM
Keine Abweichung. Mess-Schleife rein sequentiell (`cache_engine_builder_iterator.hpp:752`, `runtime_variable_loop.hpp:74`), kein `thread/async/detach/jthread/omp`; Bau-jthread-Pool VOR Messung vollstaendig gejoint (`build_orchestrator.hpp:407-411`). Schreib-Naht synchron/blockierend zwischen zwei Messungen (`cache_engine_builder_iterator.hpp:938-946`), Transport `posix_spawnp+waitpid`; env-gated inert (`artifact_cache.hpp:75-93`) → golden byte-identisch. Folgt NEUEM Modell C (curl HTTPS-PUT) statt POSIX-copy.

### 2.5 provenienz-sidecar — KONFORM
Keine Abweichung. System-`.version` und Organ-`.algos` strikt getrennt geschrieben/geprueft (`build_orchestrator.hpp:181-218,:331-394`). `build_version`-Suffix `+ext/+cxx/+opt/+ceb=<maj>.<min>/+target=` (`profile_run_facade.cpp:293-313`); `+ceb=` nie in `.algos`. `+hw=`/`+tel=`/`+page=` fehlen ABSICHTLICH (Host-Deskriptor bzw. #156-gated bzw. `page_type` zurueckgestellt) = kein Verstoss.

### 2.6 fehlerklassen — TEILWEISE
Kern konform: `InfraErrorClass` vs `CompilerCompilerErrorClass` disjunkt (static_assert), Exit-Code-Mapping domaenen-richtig (127→ProzessStart, 125→ArtefaktIo), Algo-Fehler→CSV-Zelle `failed` (nicht null) + Sidecar-Log, HW-Fehlen→WARNING+Skip statt Absturz.
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| gering | `CompilerCompilerErrorClass::ToolchainFehlt` (D1) definiert, aber KEIN Emitter: fehlender Compiler → Exit 127 → `ProzessStart`(Infra), nie dediziert D1. Planer-Zeit-Toolchain-Vorpruefung nicht verdrahtet (INC-29.2 offen). | `include/.../measurement/axis_error.hpp:41`; `build_orchestrator.hpp:380-381` | feedback_fehlerklassen_pflicht (Ebene b Compile/Toolchain) |
| gering | `SampleStatus::NotApplicable`/`SourceUnavailable` (D2 n/a) definiert, in libs ungenutzt; n/a-Rendering laeuft ueber `unified_real`-Literalpfad statt Enum. Utilization-Luecke, Verhalten nicht falsch. | `include/.../measurement/axis_error.hpp:53-54`; `cache_engine_builder_iterator.hpp:382-388` | fehlerklassen-framework §3 (D2) |

### 2.7 gattung-genus — KONFORM
Keine Verhaltens-Abweichung. 5 Genera je eigenes Genus+ABI+Observer, Cross-Genus type-unmoeglich, Set≠Sub-Typ von Sequence, `RequiredOrgans<G>` static_assert drift-frei (`builder/experiment_tree/genus_organ_binding.hpp:72-81`).
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| gering | `kSetCompositionSlotCount=15` widerspricht live `SetComposition::slot_count=13`; zusaetzlich per aktivem static_assert `test_d9_set.cpp:38` fixiert und NICHT als "frozen legacy" markiert (anders als `kAdapterCompositionSlotCount`). `organ_count()` bleibt honest (13). | `anatomy/set_composition.hpp:59` (+ :2-3); `tests/unit/test_d9_set.cpp:38` | INC-2d Slot-Counts Set=13 |
| gering | Weitere stale Slot-Konstanten/-Kommentare (`kSequenceCompositionSlotCount=11` live 9, `kViewCompositionSlotCount=7` live 5; Tier-POD-Kommentare). Live static_asserts pinnen 11/13/9/5 korrekt. | `anatomy/sequence_composition.hpp:65`; `anatomy/view_composition.hpp:71`; `anatomy/container_framework.hpp:14-15` | INC-2d Adapter=11/Set=13/Sequence=9/View=5 |

### 2.8 bplusbaum-steuerung — TEILWEISE
Kern konform: Organ- (binary_id) und Mess-Achsen (DynamicDims) voll baum-/XML-getrieben (`profile_to_tree.hpp:52`, `cache_engine_builder_iterator.hpp:698`); v32-Parallelstrecke deaktiviert.
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | Im offiziellen `comdare_thesis_profile`-Lauf werden System-/Compile-Achsen (simd, opt_level, target_isa, compiler) NICHT aus XML/Baum, sondern ueber `COMDARE_PILOT_SIMD_POLICY`/`_OPT_LEVEL`/`_TARGET_ISA`/`COMDARE_CXX`-Env gesteuert. Ursache: `ThesisProfile` traegt kein `<system_axes>`-Feld → kein XML-Kanal. `ExperimentProfile`-Pfad ist voll XML-getrieben (kein Verstoss). | `profile_facade/profile_run_facade.cpp:122`; `:258` | §24.E (kein Runtime-Umgehung); §21.B |

*Milderung:* `COMDARE_PILOT_*` sind selbst-deklariert als temporaerer Smoke-Schalter mit byte-neutralen Named-Defaults (O3/SimdNoExt/X86_64) → golden-neutral; Restrisiko bis Planer-Strang-Abloesung.

### 2.9 prozess-remotes — TEILWEISE
| Severity | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | `scripts/copy_results_to_nas.sh` = stehen gebliebener Behelfsweg: SMB/UNC-Kopie an ueberholtes V20-NAS + abgeschalteten `.de`-Host `backup1.comdare.de`. Offiziell ist Storage #51 measure-drop HTTPS-PUT. Orphan (nirgends referenziert), aber OHNE DEPRECATED-Marker → konkurriert konzeptionell mit dem einen offiziellen Pfad. | `scripts/copy_results_to_nas.sh:1` | Ledger V5.4g (NUR EIN offizielles Programm); feedback_never_delete_documentation (Insel nur DEPRECATED) |
| gering | `CMakeLists.txt:550`-Kommentar "Python-Codegen erzeugt CMake-Targets" suggeriert Python; faktisch NO-PYTHON cpp-Backend (`permutations.cmake:1`). Reiner Kommentar-Drift. | `CMakeLists.txt:550` | feedback_no_python_in_buildchain |
| gering | 4 Python-Scaffolding-Skripte im Repo-Root; NICHT in Buildchain verdrahtet (kein harter Verstoss). `_copy_ext_repos.py:8` haelt hardcodierten Personen-Windows-Pfad; keiner DEPRECATED-markiert. | `_copy_ext_repos.py:8` | feedback_no_python_in_buildchain (Geist); DEPRECATED-Doktrin |

---

## 3 · KONFLIKTE (aeltere vs neuere Aussage → gewinnender Fakt)

| # | Aeltere Aussage (im Code) | GEWINNENDER neuester Fakt | Fundstellen (stale) |
|---|---|---|---|
| K1 | "19/18 Slots", "19 Organ-Achsen" | **17 Kompositions-Slots, ABI-6, Magic `.A6.`** (INC-2d, 2026-07-18); isa+telemetry aus der Komposition | `topics/axis.hpp:18`; `ceb_system_axis.hpp:7`; `genus_binding_traits.hpp:12`; `genus_organ_binding.hpp:8/10`; `axis_path_serialization.hpp:10/88`; `test_profile_roundtrip.cpp:17/124` |
| K2 | `kSetCompositionSlotCount=15` (static_assert-fixiert) | **live `SetComposition::slot_count=13`** (INC-2c telemetry + INC-2d isa raus) | `set_composition.hpp:59`; `test_d9_set.cpp:38` |
| K3 | Sequence=11 / View=7 Slots | **live 9 / 5** (static_assert `container_framework.hpp:92-95`) | `sequence_composition.hpp:65`; `view_composition.hpp:71`; `container_framework.hpp:14-15` |
| K4 | POSIX `std::filesystem::copy` → NFS (storage-two-cache §1); V20-NAS SMB | **curl HTTPS-PUT an measure-drop** (VERORTUNGS-BRIEF §5, Entscheid A, commit 93a21233) supersediert POSIX-copy + V20-NAS | `artifact_cache.hpp:9-12` (konform); `scripts/copy_results_to_nas.sh:1` (stale) |
| K5 | flache `ExtensionHardwareSystemAxis` (Generic/Avx2/Avx512) | **DEPRECATED (F-SIMD 2026-07-18)**; gefordert ist aktiver, symmetrischer Familien-Knoten | `extension_hardware_system_axis.hpp:4` |
| K6 | "Python-Codegen erzeugt CMake-Targets" | **NO-PYTHON, cpp-Backend** (H6-Revision, GO-2 2026-07-12, byte-identisch) | `CMakeLists.txt:550` |
| K7 | Sweep-Referenz `build_version` = nur `+ext/+cxx/+opt` | **erweitert um `+ceb=` (§24.G) und `+target=` (INC-2d)** | `profile_run_facade.cpp:293-313` (konform, Ref stale) |
| K8 | (implizit) einheitliche ISA-Achse | **HardwareIsa=Host-Deskriptor/Mess-Gate (nie binary_id) vs TargetIsa=build-treibend** (INC-2d Variante A) | `hardware_isa_system_axis.hpp:4-7`; `target_isa_system_axis.hpp:5-16` |

---

## 4 · CODE-REVIEW-GAP (Ist-Code weicht von Design/Anforderung ab → konkrete Nacharbeit)

**Reale Verhaltens-/Struktur-Luecken (nicht nur Doku):**

- **G1 (mittel, binary-id):** Kein struktureller Guard, der `permute_axes`/Registry im Lauf-Pfad auf `kCompositionAxisNames` (17) beschraenkt. → Nacharbeit: `build_axis_levels`/`validate_profile` so haerten, dass nur Organ-Achsen ein statisches (binary_id-serialisiertes) Level erzeugen; System-Achsen (isa/simd_extension/telemetry) muessen als eigener nicht-binary_id-Kanal (CEB-System-Achsen-Schicht) laufen. `profile_to_tree.hpp:82`.
- **G2 (mittel, schichtung):** Aktiver `extension_hardware`-Familien-Knoten (`SimdExtensionHardwareAxis`, symmetrisch Gcc/Clang) fehlt; `SimdSubAxis.parent` zeigt auf verwaisten String. → Nacharbeit: aktiven `CebSystemAxis` mit `axis_label()=="extension_hardware"` bauen (Analog `CompilerSystemAxis`), DEPRECATED-Insel NICHT reaktivieren. `simd_sub_axis.hpp:37`.
- **G3 (mittel, bplusbaum):** `ThesisProfile` braucht `<system_axes>`-XML-Feld + Verdrahtung in den Baum, damit `COMDARE_PILOT_*`-Env als Steuerkanal entfaellt. → Aktuell an Planer-Strang gestaffelt; bis dahin env-gesteuert. `profile_run_facade.cpp:122/258`.
- **G4 (mittel, remotes):** `copy_results_to_nas.sh` DEPRECATED-markieren (Verweis auf measure-drop) — nicht loeschen (Messdaten-nie-loeschen, GO-Pflicht). `scripts/copy_results_to_nas.sh:1`.
- **G5 (gering, fehlerklassen):** `ToolchainFehlt` (D1) hat keinen Emitter → Planer-Zeit-Toolchain-Vorpruefung verdrahten (INC-29.2). `axis_error.hpp:41`.
- **G6 (gering, fehlerklassen):** `SampleStatus::NotApplicable/SourceUnavailable`-Zell-Renderer durchziehen statt `unified_real`-Literal. `cache_engine_builder_iterator.hpp:382-388`.
- **G7 (gering, schichtung):** Freigabe/Durchsetzung als constexpr-Gate (Organ-SIMD ≤ System-Zulassung) — heute nur Kommentar, deferred PF2. `target_isa_system_axis.hpp:7`.

**Doku-/Konstanten-Drift (kein Verhaltens-Effekt, mechanische Nacharbeit):**

- **G8:** Slot-Zahl-Sweep 19/18→17, 15→13, 11→9, 7→5 in allen Kommentaren/inerten Konstanten (K1–K3). Besonders `kSetCompositionSlotCount=15` inkl. `test_d9_set.cpp:38`-static_assert auf falschen Wert.
- **G9:** `CMakeLists.txt:550` Kommentar auf "C++23/cmake/sh/bat-Codegen" nachziehen.
- **G10:** 4 Root-Python-Scaffolding-Skripte DEPRECATED/relocaten; hardcodierten Personen-Pfad `_copy_ext_repos.py:8` entfernen.

---

## 5 · PRIORISIERTE FIX-LISTE (kritisch→gering; Aufwand S<0.5d · M 0.5–2d · L>2d)

| Prio | Fix | Dim | Sev | Aufwand | Anker |
|---|---|---|---|---|---|
| 1 | **G1** Struktur-Guard: Lauf-Pfad-`permute_axes`/Registry auf 17 Organ-Slots restringieren; System-Achsen aus binary_id-Serialisierung ausschliessen | binary-id | mittel | **M** | `profile_to_tree.hpp:82` |
| 2 | **G2** Aktiven `extension_hardware`-Familien-Knoten bauen (symmetrisch Gcc/Clang), DEPRECATED-Insel nicht reaktivieren | schichtung | mittel | **M** | `simd_sub_axis.hpp:37` |
| 3 | **G4** `copy_results_to_nas.sh` DEPRECATED-Marker + Verweis auf measure-drop (kein rm) | remotes | mittel | **S** | `copy_results_to_nas.sh:1` |
| 4 | **G3** `ThesisProfile`-`<system_axes>`-XML-Feld + Baum-Verdrahtung → `COMDARE_PILOT_*`-Env abloesen (Planer-Strang) | bplusbaum | mittel | **L** | `profile_run_facade.cpp:122/258` |
| 5 | **G8** Slot-Zahl-Sweep 19/18/15/11/7 → 17/13/9/5; `kSetCompositionSlotCount=15`→13 inkl. `test_d9_set.cpp:38` | mehrere | gering | **S** | `set_composition.hpp:59` |
| 6 | **G5** `ToolchainFehlt`-Emitter (Planer-Zeit-Toolchain-Vorpruefung, INC-29.2) | fehlerklassen | gering | **M** | `axis_error.hpp:41` |
| 7 | **G6** `SampleStatus`-n/a-Zell-Renderer durchziehen | fehlerklassen | gering | **S** | `cache_engine_builder_iterator.hpp:382-388` |
| 8 | **G7** Freigabe/Durchsetzung constexpr-Gate (Organ-SIMD ≤ System-Zulassung) | schichtung | gering | **M** | `target_isa_system_axis.hpp:7` |
| 9 | **G9** `CMakeLists.txt:550` Python-Kommentar → cpp/cmake/sh/bat | remotes | gering | **S** | `CMakeLists.txt:550` |
| 10 | **G10** 4 Root-Python-Skripte DEPRECATED/relocaten; hardcodierten Pfad entfernen | remotes | gering | **S** | `_copy_ext_repos.py:8` |

**Aufwand gesamt:** 1× L, 4× M, 5× S. Golden-Neutralitaet: Fixes 1–3, 5, 7, 9–10 sind golden-neutral; Fix 2/4/6/8 fuehren neue Achsen-/Enum-/Gate-Semantik ein (additiv, nach Plan-Reihenfolge, keine CT→RT-Degradierung).