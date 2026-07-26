Read: all 7 planning result files, the order doc, and the live anchors. Findings below carry file:line from live reads (26.07.).

```
(a) PAKETE NACH DEM CT-DRAHT (A7-A9)
```
**A7 kSystemAxisOrder als Single-Source (Riss 2).** `grep -rn kSystemAxisOrder` = 0 Treffer -> existiert nicht.
- NEU `libs/cache_engine/include/cache_engine/abi/system_axis_order.hpp`: `constexpr` Tabelle in der bindenden §1-Kette. EXKLUSIV A7.
- `abi/system_axis_code_versions.hpp:28` (`kSystemAxisCodeCount = 5`), `:32-38` (Tabelle in Alt-Ordnung compiler, extension_hardware, target_isa, scheduling, load_framework), `:49-50` static_assert -> auf die Tabelle umstellen.
- WICHTIGE KORREKTUR gegen den Auftrag: `anatomy_version_stamp.hpp:77-79` iteriert die Tabelle SCHON (`for i < kSystemAxisCodeCount`). Die System-Zeile ist im SCHLEIFEN-Koerper bereits systemisch; fix ist nur die TABELLENLAENGE `:28` und der literale Golden-String `tests/unit/test_m_w12_stamp_bausteine.cpp:267-269`. "5-fix" trifft die System-Zeile NICHT.
- BYTE-FOLGE: Ordnungswechsel in `:32-38` aendert die Ausgabe von `system_stamp_line()` -> `lazy_adhoc_source_gen.hpp:201` und `:259` -> `anatomy_fingerprint_hex`-Preimage -> JEDE Tier-Binary. A7 ist damit byte-tragend und gehoert ins EINE Fenster (siehe (d)).
- GATES: `test_m_w12_stamp_bausteine.cpp:265`(`kSystemAxisCodeCount==5`)/`:267-269`/`:338` literal neu ankern; NEUE Wache "Emitter-Reihenfolge == kSystemAxisOrder == XML-Kopf-Reihenfolge" (heute nur "nie leer", `system_axis_code_versions.hpp:41-47` = Drift-Luecke).

**A8 Stempel A-II/A-III.** Drei getrennte Teilstuecke, nur eines davon ist heute leer:
- A8.1 System-Array systemisch erweiterbar: siehe A7 - erledigt mit der Tabellen-Umstellung. Kein weiterer Code.
- A8.2 Organ-Meta-Meta-Array: `anatomy_version_stamp.hpp:42-60` ist das HANDGESCHRIEBENE 17-fix-Array - DAS ist die eigentliche Fix-Stelle. FALLE: `:32-37` dokumentiert selbst, dass `organ_stamp_line<Comp>()` MOCK-ONLY ist ("nicht auf reale Module anwendbar"); die REALE Organ-Zeile kommt aus `compose_organ_stamp_line` (`lazy_adhoc_source_gen.hpp:201`, `:257`). Wer das Meta-Meta-Array nur in `organ_stamp_line` einbaut, baut einen ZWEITEN inerten Piloten (dieselbe Klasse wie B-3). Das Array muss in `compose_organ_stamp_line` UND in `pilot_source_map.hpp` (`builder/experiment_tree/pilot_source_map.hpp`, Katalog-Pfad) gleich gebaut werden, sonst bricht die 320-Round-Trip-Byte-Wache.
- A8.3 SHA512-Overlay: EXISTIERT SCHON - `abi/anatomy_fingerprint.hpp:31-43` `consteval anatomy_fingerprint_hex(organ, system, measurement, merge)`, Preimage-Reihenfolge `:39-42`, Budget `kAnatomyFingerprintPreimageMax = 4096` (`:25`), Primitive `libs/cache_engine/src/sha512/ctsha512.hpp:149`. Der Owner-KERN fordert zusaetzlich die **Overlay-SOURCE-Hashes** - die sind im Preimage NICHT enthalten (`:39-42` = nur die 4 Stempel-Zeilen). Delta = 5. Preimage-Glied. Nebenwirkung: `builder/ceb_version_stamp.hpp:96-98` (`kCebFingerprint` = `anatomy_fingerprint_hex("","",kCebMeasurementStamp,"")`) faellt mit; 4096 Byte Budget vorab literal pruefen (`ctsha512.hpp:164 fits_compile_time_budget`).
- GATE (bindend): vier Zeilen bleiben GETRENNT (`anatomy_version_stamp.hpp:71`/`:94`/`:112`/`:182`); `system_stamp_line` bleibt mess-blind (`:64-70`); Preimage-Reihenfolge nur GEMEINSAM an allen drei Orten (`anatomy_fingerprint.hpp:39-42`, `lazy_adhoc_source_gen.hpp:261`, `ceb_version_stamp.hpp:97`).

**A9a XML-Regen/Roundtrip.** `tools/system_axis_registry_gen/main.cpp` (5 Handbloecke; `machine_signatures` `:298-316`, stdout-Literal `:334` sagt literal "5 System-Achsen-Elemente") -> Iteration ueber `kSystemAxisOrder`. Ziel-XML `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml`. GATE `tests/unit/registry_roundtrip.cmake:55-66`: Byte-Diff==0, XML NIE handeditieren, Regen im SELBEN Commit. NEU zu emittieren: `<sub_axis>` unter `target_isa` - heute traegt `target_isa` (XML `:98-101`) GAR KEINE sub_axis (Befund B-3 bestaetigt), waehrend `scheduling` (`:102-113`) und `load_framework` (`:114-117`) je eine tragen; das Muster ist also vorhanden, die Kante fehlt.

**A9b XML-DEAKT `active="true|false"`.** Ist-Stand literal: `grep -rn '"active"' libs apps tools Code` = 0 Treffer, `grep -rn declared_count` = 0 Treffer. Vier Schritte:
1. XSD `Code/test_data_xml/experiment_schema.xsd:227-229` (`<axis>` mit `ref` `use="required"`) + optionales `active` (`xs:boolean`, Default `true`).
2. Parser: `xml_config_parser.cpp:266` (`ax.ref = a->attr("ref")`, Thesis-Kanal) und `:469` (`axes_default_lookup`-Kanal) lesen heute NUR `ref` -> je Kanal ein `ax.active`-Feld in `ThesisAxisSpec` (`xml_config_parser.hpp:100`) und `ExperimentAxisDefault` (`:368`).
3. Resolver: `validate_profile.hpp:765 resolve_axis_refs_against_trio` fuehrt `active=false` in die Bausteinmenge (Registry = ANGEBOT, §27) statt Abwahl-durch-Abwesenheit.
4. Guard-Test (unregistriert) gegen den heutigen Umkehr-Hebel `CE/CMakeLists.txt:379-380 option()` -> `axes/persistence_target/axis_persistence_target_flags.hpp.in:9-15` -> `axis_persistence_target_registry.hpp:31 EnabledTargets = mp_filter`.
- GATE/BYTE: A9b landet DEKLARATIV byte-neutral - fehlendes Attribut == `true`, KEIN Profil setzt `false`. Ein wirksames `active="false"` aendert `EnabledTargets` -> Katalog-Kardinalitaet -> golden-CRC = DRITTER Anker = untersagt. `declared_count` gehoert ins Lane-F-Fenster (Auftrag §6, bestaetigt).

```
(b) LANE C PRAEZISIERT - der Freigabe-Pilot ist INERT, und das ist C-3
```
- C-1 Meta-Meta-Typ-Familie: variadisches Pack, **kein `std::variant`** (Owner-KERN: nur CEB). NEU `include/cache_engine/measurement/{hardware_meta_meta_axis,meta_meta_identity}.hpp`. Vorbild-Form: `std::span` ueber `static constexpr std::array` wie `extension_hardware_family_axis.hpp:73-75 kAllExtensionHardwareFamilyIds`. Vertrag V1 = mp_list-Typliste (NICHT `std::span<MetaMetaDescriptor const>`).
- C-2 Halbordnung: `simd_build_gate.hpp:155-160 admit_organ_on_machine` ist bereits exakt `T subset S`, hat aber **keinen Aufrufer** (Befund bestaetigt). C-2 hebt die Signatur auf Meta-Meta-Saetze + `constexpr subsumes(A,B)`; Freigabe-Maximum `:142-146` (Signatur GESCHNITTEN Sinnhaftigkeit GESCHNITTEN Route) bleibt.
- **C-3 = Hub-Mechanik UND die Konsumtion der Signatur.** Der inerte Teil zerfaellt in zwei Stuecke mit unterschiedlicher Byte-Wirkung:
  - C-3a (GEHOERT IN C-3, byte-neutral): `active_machine_signature()` (`simd_build_gate.hpp:187`, gibt `{}`) liest die drei deklarierten Signaturen. Quelle ist NICHT die XML: die XML `system_axis_registry.xml:118-165` (`machine_signatures count="3"`, prod1_zen5 `flag_count="22"`, prod2_raptor_lake `9`, odroid_gracemont `9`) ist REFLEKTAT des Codes (`main.cpp:298-316` emittiert aus `Prod1Zen5Signature`/`Prod2RaptorLakeSignature`/`OdroidGracemontSignature`). C-3a bindet also die TYPEN, nie die XML - sonst bricht der Roundtrip-Byte-Gate. Ergebnis: die Hooks liefern echte Daten, das Gate bleibt aber ohne Aufrufer -> weiter byte-neutral.
  - C-3b (NICHT in C-3, Lane C2' nach dem Trigger): der Aufruf von `gate_extra_march_flags_for_build` (`simd_build_gate.hpp:194-199`) an der CompileFn-Naht. Er kann `-m`-Flags ANHAENGEN (`effective_march_flags:167-176`) = Byte-Aenderung kurz vor dem Bau. Auftrags-Auflage bleibt gueltig.
  - C-3c (NEU, aus Befund B-3): die ISA-Zulassung fragt heute den HOST, nicht die Haupt-Achse - `profile_run_entry.hpp:209-216` `#if defined(__x86_64__)` + `__builtin_cpu_supports("avx2"/"avx512f")`, Kommentar `:207-208`. `simd` haengt unter `extension_hardware` (`simd_sub_axis.hpp:37-38 parent_axis_label()=="extension_hardware"`), NICHT unter der ISA. Die Kante "Unter-Achse unter der ISA" ist also NEU zu bauen und beruehrt `target_isa_system_axis.hpp` - eine Datei, die A3 (scheduling-Unterachse) und A4 (numa/lock-Unterachsen) ebenfalls wollen. C-3c ist deshalb PATCH-AN-A3, kein eigener Edit.
- C-5 Tests: neue `.cpp`, **unregistriert** (`tests/unit/CMakeLists.txt` = 4036 Zeilen, Registrierungsmuster `comdare_add_test(...)` z.B. `:2608-2610`; Sammel-Registrierung am Join, sonst 3-Wege-Konflikt).

```
(c) SPERRMENGEN-MATRIX (Datei -> exklusiver Besitzer -> Parallelitaet)
```
| Datei | exklusiver Besitzer | Parallel? |
|---|---|---|
| `abi/system_axis_order.hpp` (NEU), `abi/system_axis_code_versions.hpp` | **A7** | Agent-1-Kette |
| `abi/anatomy_version_stamp.hpp`, `abi/anatomy_fingerprint.hpp`, `builder/ceb_version_stamp.hpp`, `profile_facade/lazy_adhoc_source_gen.hpp`, `builder/experiment_tree/pilot_source_map.hpp`, `builder/codegen/adhoc_emitter.hpp` | **A8** | Agent-1-Kette, seriell nach A7 (A8 liest die Tabelle) |
| `tools/system_axis_registry_gen/main.cpp`, `measurement/system_axis_registry.xml` | **A9a** | seriell nach A7 (Generator iteriert die Tabelle) |
| `xml_config_parser.{hpp,cpp}`, `Code/test_data_xml/experiment_schema.xsd`, `profile_facade/validate_profile.hpp` | **Lane A gesamt, EIN Agent** | STRENG SERIELL: A2(Rename, 8/7 Treffer) + A3(XSD `:245-340`) + A4(alloc_hw-Sonderzweig `validate_profile.hpp:206-209`, `:776`) + A9b(active) wollen alle DREI Dateien |
| `axes/persistence_target/{axis_persistence_target_registry.hpp,axis_persistence_target_flags.hpp.in}`, `CE/CMakeLists.txt:379-380` | **A9b** | parallel moeglich (nur A9b beruehrt sie) |
| `target_isa_system_axis.hpp` | **A3** (A4 + C-3c liefern PATCH) | STRENG SERIELL, 3 Anwaerter |
| `measurement/{machine_simd_signature,simd_build_gate,simd_organ_requirement,simd_organ_sensibility,simd_feature_flag}.hpp` + NEU `{hardware_meta_meta_axis,meta_meta_identity}.hpp` | **Lane C** | ECHT PARALLEL zu Agent 1 |
| `extension_hardware_family_axis.hpp` (24 Rename-Treffer), `simd_sub_axis.hpp` | **A2** | C-3 wartet auf A2 ODER arbeitet unter Alt-Namen (Auftrags-Auflage) |
| `all_axes_golden.profile.xml` (`:180-182` Kommentar, `:189-192` opt_level, `:194-199` simd) | **A6** | Konflikt mit Lane B (Bauplan gab B den Besitz) - Besitz muss auf A6 UMGESCHRIEBEN werden, B ist gelandet |
| `profile_run_facade.cpp`, `profile_run_entry.hpp`, `artifact_transport/artifact_cache.hpp`, `Code/02_messung_driver/main.cpp` | **Lane F / G4b-1** | TABU fuer A und C |
| `tests/unit/CMakeLists.txt` | **Integrator am Join** | niemand registriert selbst |
| `tests/unit/registry_roundtrip.cmake` | read-only fuer alle | - |

**Verdikt fuer 2 Agenten:** Agent 1 = serielle Kette A7 -> A8 -> A9a -> A9b (gemeinsame Stempel-/Generator-/Parser-Dateien, nicht teilbar). Agent 2 = C-1 + C-2 + C-5 (nur neue Dateien + `simd_*`-Insel) echt parallel. Streng seriell danach: C-3a (braucht A2-Rename), C-3c (Patch an A3), Lane F. `simd_organ_*`/`machine_simd_signature` haben 0 Ueberlapp mit Agent 1 - das ist der einzige echt disjunkte Schnitt.

```
(d) DAS EINE BYTE-EREIGNIS: WO ES SITZT, WER MITFAHREN MUSS
```
Es sitzt im Preimage der DLL-einkompilierten Provenienz, nicht im Suffix allein. Physische Traeger, alle im Lane-F-Abschluss-Commit zu ankern:
`anatomy_fingerprint.hpp:39-42` (Preimage-Reihenfolge) -> `lazy_adhoc_source_gen.hpp:201,257-261` (reale Organ+System-Zeile) -> `pilot_source_map.hpp` (Katalog-Zwilling, 320-Round-Trip) -> `profile_run_facade.cpp:369-405` (`system_axes_version_suffix`) -> `artifact_cache.hpp:245-249` (`cache_key_prefix`, `+ceb`/`+mtool=`/`+mrg=none`) -> `ceb_version_stamp.hpp:96-98`.
MUSS MITFAHREN (aendert Bytes): **A7** (Tabellen-Ordnung -> `system_stamp_line()`-String), **A8.2** (Organ-Meta-Meta-Array in `compose_organ_stamp_line` + Katalog-Zwilling), **A8.3** (5. Preimage-Glied), **Lane F** (Suffix-Ordnung + `cache_key_prefix`), plus die literalen Golden-Strings `test_m_w12_stamp_bausteine.cpp:267-269,338`.
FAEHRT NICHT MIT (byte-neutral, darf frueher/spaeter): A9a (XML ist kein DLL-Inhalt; nur Roundtrip-Gate im selben Commit wie der Generator), A9b (fehlendes `active` == `true`), C-1/C-2/C-5, C-3a (Hooks liefern Daten, kein Aufrufer). A6 aendert nur WERTE von `+opt=`/`+ext=` (`profile_run_entry.hpp:781-785` baut den Perm-Suffix aus den ids), nicht die FORM - byte-neutral fuer den Code, aber es materialisiert neue Perms.
KORREKTUR ZU §1.11 DES AUFTRAGS (Befund B-1): mit avx512 wieder drin sind es **4 x 3 = 12 System-Perms**, nicht 8. Der Filter in `all_axes_golden.profile.xml:181-182` ("avx512 nicht universell") ist genau der §62-A-Verstoss; `profile_run_entry.hpp:216` liefert die Warnung/den Skip bereits maschinen-ehrlich (prod2 fused-off meldet `false`), also ist der XML-Filter ueberfluessig UND schaedlich. `Ofast` (`optimization_level_sub_axis.hpp:113-115`) bleibt aus - es existiert als Baustein, wird nicht permutiert.

WO DIE QUELLEN SCHWEIGEN (nicht geraten): (1) es gibt keine Quelle fuer die konkrete Form der Overlay-Source-Hashes (welche Dateien, welcher Kanonisierungs-Schritt) - `anatomy_fingerprint.hpp` kennt nur die 4 Zeilen; (2) `declared_count` existiert nirgends im Code (grep 0) - seine Semantik ist unbelegt; (3) fuer die "mehreren weiteren zwei-geteilten Faelle" des Owner-KERN nennt kein gelesenes Dokument eine vollstaendige Liste - das Register in Auftrag §1.6 ist die einzige Aufzaehlung; (4) ob `active="false"` auch System-Achsen-Bausteine (nicht nur Organ) treffen soll, sagt keine Quelle.

Selbstcheck: `grep -P '[^\x00-\x7F]'` auf diesen Text = nur `§`-Treffer (per Direktive erlaubt); 0 Dateien geschrieben, nur Read/grep/sed; alle Zeilennummern aus Live-Lesung 26.07.; 108 Zeilen.
