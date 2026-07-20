# SESSION AUTONOM-01 (2026-07-20) -- CI-Fix + S2/A2 P-SYSREG

> Autonome Ausfuehrung des v3.2-Plans (Autonomie-Grant 20.07.). Fortschritt NUR in dieser
> neuen Session-Doc; Ledger/Arch-Doku/Plaene unangetastet (Doku-Policy 20.07.). Je Paket:
> ultracode-Planung -> Opus-Impl -> Manager-Verifikation je Stufe -> granularer Commit -> Dual-Push -> CI.

## 0. Ausgangslage
- S0 (Audit), S0.5 (T6+T2), S1 (P-TOTAL/OBS/KONFORM/HYBRID/W12A3) committet `c96a4da1` (Vor-Session).
- CI-Endstand-Gate loest die autonome Ausfuehrung aus.

## 1. CI-Regression-Fix (Task #9, ERLEDIGT)
- **Symptom:** ce-Pipeline 11710 (`c96a4da1`) rot: `test:unit` `axis_path_serialization.hpp:23: 'boost' has not been declared` beim Kompilieren von `test_e4_contract_xml_to_axislevels`.
- **Root Cause (ultracode `Plan-CIFix-mp11`):** S1/A4 (`c9ee0bca`) fuegte `profile_to_tree.hpp:14 #include axis_path_serialization.hpp` hinzu -> zieht `boost/mp11` transitiv in `test_e4`s Compile-Kette; `test_e4`-Target linkte kein `Boost::mp11` (Konvention: Schwester-Tests fb/ff2/kf9 tun es). Lokal maskiert durch inkrementellen Build + `-LE contract|pmc`-Label-Ausschluss.
- **Fix:** `tests/unit/CMakeLists.txt` -- `test_e4_contract_xml_to_axislevels` `PRIVATE Boost::mp11` (1 Zeile, codebase-konsistent). INTERFACE-Lib-Nachbesserung = separater absprachepflichtiger Architektur-Task.
- **Verifikation:** frisches Build-Dir -> `test_e4` + 3 Schwester-Tests kompilieren, `test_e4` ctest Passed, Mojibake 0.
- **Landung:** ce `66e73730`, super `2954765`; Pipelines grün (ce 11731, super 11732).

## 2. S2/A2 P-SYSREG -- System-Achsen-Consumer (Task #10, ERLEDIGT)
- **Architekten-Entscheidung (Manager):** Variante **B1-voll** -- beide fehlenden Consumer `atomic128` + `target_isa` ce-intern verdrahten (golden-neutral, ein Opus-Agent). Begruendung: Deliverable "Konsumenten verdrahtet" fuer die VOLLE Offer-Menge verlangt Symmetrie. Die einzige offene Manager-Frage (Broadening-Tiefe) ist golden-neutral + aus Doku/Code aufloesbar -> kein USER-GO.
- **Kern-Befund (ultracode `Plan-S2A2-PSYSREG`):** Das Registry-ANGEBOT (6/7 System-Achsen) existiert bereits generiert (W2-B, Handedit verboten). Scope = Consumer-Verdrahtung, nicht Offer-Bau. Consumer verdrahteten bisher nur `compiler/opt_level` + `extension_hardware/simd`; Single-Source-Klassen `kAllAtomic128Ids`/`kAllTargetIsaIds` existierten bereits.
- **Impl (6 Dateien, +272/-4, additiv):**
  - `xml_config_parser.hpp`: `CompilerAxisSel::atomic128`, neuer `struct TargetIsaAxisSel`, Felder in Thesis-/ExperimentProfile.
  - `xml_config_parser.cpp`: `parse_system_axes` (+`TargetIsaAxisSel&`, INTERN -- nicht im Header, keine externen Aufrufer) um `compiler/atomic128` + `target_isa`.
  - `validate_profile.hpp`: Validat-Bloecke atomic128/target_isa in beiden Funktionen + Result-Zaehler + Report (leer=byte-identisch).
  - Tests: test_experiment_parser (valid + harte Tippfehler-Faelle), test_validate_profile (Thesis-Block), test_experiment_plan_director (RegistryTrio-Assert 17/5/16 + NUMA-abwesend).
- **7. Achse NUMA korrekt ABWESEND** (= S11, nicht S2/A2).
- **Manager-Verifikation (literal):** Include-Kette `compiler_atomic_sub_axis.hpp`/`target_isa_system_axis.hpp` transitiv **boost/mp11-frei** (mp11-Regressionsklasse ausgeschlossen) · 5 ctest Passed (test_striktheit/validate_profile/system_axis_registry_roundtrip/experiment_parser/experiment_plan_director) · **RegistryTrio 17/5/16 bestaetigt** · cf22 (clang-format 22.1.8) 0-diff · Mojibake 0 · `parse_system_axes`-Aufrufer-Grep: nur Kommentare ausserhalb (interne Fkt) · super-Sub-Build `messung_driver` kompiliert+linkt · validate-Roundtrip Exit 0 (valid) / 1 (Tippfehler).
- **golden-Neutralitaet:** alle System-Achsen `binary_id="never"`, nie in binary_id/N -> RegistryTrio konstant, CRC64 0xF1C1F26A1232073B unberuehrt, kein new-golden-Regen.
- **Landung:** ce `2ce1aaa2`, super `13d3efd`, beide Remotes.

## 3. Offene Folge-TODOs (nicht-blockierend)
- **super-XSD-Nachzug:** `super/Code/test_data_xml/experiment_schema.xsd` deklariert `<atomic128>`/`<target_isa>` noch nicht. Greift erst, wenn ein REALES Profil sie nutzt + super-xmllint prueft. ce-Parser ignoriert Unbekanntes additiv; ce-Tests bauen Profile-Structs/Temp-XML direkt. Koordiniert spaeter in S4 (Planer/Parser-Owner fasst ohnehin Schema an).

## 4. S3 P-RESOLVER minimal-3-tief (Task #12, ERLEDIGT)
- **Architekten-Befund (ultracode `Plan-S3-PRESOLVER`):** Der „volle 5-tiefe Resolver" (Plan-Zeile 58) ist NICHT als ein golden-neutrales S3-Paket vor 24.07. schliessbar -- braucht 3 fehlende Infrastruktur-Teile (v2-Registry-Schema, LinkedExperimentPlan, per-Phase-<axes>-Parser), die das Design selbst als Increment-Kette I0-I5 sequenziert (-> Task #19, Band-B deferred). Doc-verankerter S3-Scope = **minimal-3-tief** (profile_to_tree.hpp:95 delegiert woertlich).
- **Impl (6 Dateien, +329/-7, additiv):** `resolve_axis_refs_against_trio()` in validate_profile.hpp klassifiziert Organ-Position-Refs gegen das S2/A2-RegistryTrio-Angebot: **V-UNREG-AXIS** (in keiner Registry) + **V-CATEGORY** (System-Achse in Organ-Position -> Route ueber CEB-System-Schicht). ResolverReport im Plan-Kopf (`--dump-plan`). Additiver `ExperimentPlanDirector(RegistryTrio)`-Konstruktor; `error_class_label(KonfigXmlParse)` READ-ONLY (kein Enum-Bump).
- **INERT-by-default in PRODUKTION:** ohne volles Trio (Default-/Annotation-/Facade-Pfad) bleibt der Resolver `resolved=false` -> Produktions-Verhalten byte-identisch (additive-zuerst-Doktrin). Aktiv nur in Tests. **Folge-Schritt (nicht-gated, klein):** Produktions-Aktivierung (Facade konstruiert Director mit vollem Trio) -- erst nach Scan aller Profile, dass keins eine fehlplatzierte Achse still toleriert (sonst wuerde Aktivierung einen bestehenden Reject hart machen).
- **Manager-Verifikation (literal):** 4 ctest Passed (Resolver 5/5 + 3/3, **RegistryTrio 17/5/16**), Header-Includer wirklich rekompiliert, cf22 0-diff, Mojibake 0, Include-Kette (axis_error.hpp) boost-frei, **kein super-seitiger --dump-plan-Byte-Pin**, super-Sub-Build `messung_driver`+`test_messreihe_v32_parser`+`test_experiment_phase_strategy` OK (test_v32_katalog_driver benign-absent, V32-Guard OFF), Reject-Belege mit Koordinate, golden-Profil -> 0 Rejects.
- **golden-Neutralitaet:** read-only Annotation, keine AxisLevel-Aenderung, profile_to_tree byte-identisch, RegistryTrio 17/5/16, CRC64 unberuehrt.
- **Landung:** ce `f6dca47b`, super `2404c6a`, beide Remotes.

## 5. Offene USER-Punkte (kritischer Pfad blockiert -- fuer den Morgen notiert)
Nach S3 ist der deadline-kritische Pfad (S4->S8) an USER-Entscheidungen/Gates blockiert:
- **§12-E11 Phasen-Kardinalitaet ≠3** (Task #14, VOR S4 P-MESSTOOL) -- blockiert Mess-Schema/Validator.
- **S2/A1 ABI/golden-Regen-Fenster + Voll-Build 2^17** (Task #13, Gate a+b, Band-A 24.07.) -- USER-GO.
- **§32-F8-3 Break-Even-Option** (Task #17, VOR S7, Abgabe-Pflicht) -- bestimmt Hybrid-Binary-Architektur.
- **S6 320er-Messlauf** (Task #16, Gate a, when:manual) -- USER-GO.

Autonom weiter (golden-neutral): **S2/A4 P-HYBRID** (Task #11), sofern nicht durch §32-F8-3 blockiert (ultracode-Pruefung laeuft).
