# BAUPLAN v2 (AUTORITATIV) - Lane A SYS-TAX + Lane C Meta-Meta-Hub + TEIL II: V3-DELTA (PLAN BAUFAEHIG)

> V3-NACHTRAG 26.07. abends (additiv): TEIL II (V3-DELTA, ultracode wf_aa52e386, 5x Fable-5-xhigh) ist
> unten ANGEHAENGT. Damit ist dieses Dokument der BAUPLAN v3 = v2 (Teil I) + Delta (Teil II);
> FINAL-VERDIKT: **PLAN BAUFAEHIG** (D4). Bei Widerspruch gilt TEIL II. Kern-Korrekturen:
> kSystemAxisOrder = GENAU DREI (target_isa, operating_system, external_utils), load_framework = erste
> Meta-Meta, RAUS aus der Ordnung (D2.5, ersetzt P1/O-1 "4 oder 5"); C-3a aus Agent-5-Umfang und
> MUSS-MITFAHREN GESTRICHEN, Scharfschaltung = Folge-Paket in eigenem GO-Fenster (D2.3); NEU Paket C-3b
> Kanal-Merge-Beleg (byte-neutral, Vorbedingung jeder Scharfschaltung, D2.2); NEU O-8 Fenster-GO vor
> Agent-5-Start, O-9 V36.B-Codegen-Hook (D5). P0/A1-Nachzug (D2.4) ist bereits GELANDET:
> ce a3644cb8 (N1 #include <cstddef>, N2 Kommentar-Fix auf DREI Haupt-Achsen, byte-neutral belegt).

> Ersetzt VOLLSTAENDIG das SUPERSEDED 20260726-AUFTRAG-lane-a-sys-tax-und-lane-c-hub.md.
> Quelle: ultracode wf_4d2b7439 (3 Integrations-Leser -> adversariale Vorpruefung [5 Blocker + 6 Warnungen, alle eingearbeitet] -> xhigh-Synthese). Alle datei:zeile an ce-HEAD abef03ce gelesen.
> LaneC-Nachtrag 26.07.: BLOCKER-1 praezisiert - Gate ist DREIFACH inert (Schalter A required-leer / A' pruef_dock-NotApplicable / B stub); Stub :187 allein fuellen = No-Op; C-3 baut den MECHANISMUS, Scharfschaltung (:187-Umhaengung) = benanntes Folge-Paket mit Byte-Beweis, Q-11 nach Trigger.


## 1. Autoritaets-Kette + Stand
1. **Owner-KERNE** (Gesetz, rueckwirkend; Abweichung = Regression): Dual-Natur (NUMA/page = RT-Unter unter der ISA an der CEB, CT-Haupt am Tier; mehrere solcher zwei-geteilter Faelle folgen) -- System gibt frei / Organ setzt durch (System=Bibliothek, Organ=Initialisierung) -- opt permutiert ueber alle verfuegbaren Stufen (i.d.R. O0,O1,O2,O3), **Ofast bleibt aus** -- `std::variant` nur CEB, in ALLEN Tier-Typen verboten -- Test-Skip nur als Lagerhaltungs-Skip fuer gruen inventarisierte Binaries.
2. **Dieser Bauplan v2 = Quelle der Wahrheit.** Er ersetzt `docs/sessions/20260726-AUFTRAG-lane-a-sys-tax-und-lane-c-hub.md` VOLLSTAENDIG; jener Auftrag traegt die in Abschnitt 2 eingearbeiteten Fehler (5 Blocker, 6 Warnungen).
3. Ledger/§-Direktiven (§27 Registry=Angebot, §33 >=2 Algorithmen je Achse, §62-A Planer-Universalitaet: Warnung statt Filter, §61 Dual-Weg).
4. Live-Quellen, `datei:zeile`, alle Anker neu gelesen 26.07. an ce-HEAD `abef03ce`. Pfad-Wurzel = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, `ce` = `Code/external/comdare-cache-engine`.
5. Nach dem Bau: adversariale NACH-Pruefung nach Abschnitt 6.

**Bau-Sperre:** O-1 und O-2 (Abschnitt 7) sind Vor-Bedingungen. P0 darf sofort laufen, P2/P3 nicht.

## 2. Pakete in bindender Reihenfolge

### P0 -- A0-INV: Baum-Grundierung (war BLOCKER-2; MUSS zuerst)
Ziel: der Arbeitsbaum ist unrein; drei "NEU"-Annahmen des Alt-Auftrags sind falsch.
`git status --porcelain` in ce, literal: ` M libs/cache_engine/topics/axis.hpp` / `?? libs/cache_engine/include/cache_engine/abi/system_axis_order.hpp` / `?? .../measurement/ceb_sub_axis.hpp` / `?? .../measurement/meta_meta_identity.hpp`.
- `abi/system_axis_order.hpp` EXISTIERT (A1, 26.07.: Kopf :1-2, `kSystemAxisOrderCount = kSystemAxisCodeCount` :32, Tabelle :38-44 in Alt-Ordnung, Drift-`static_assert` :80-86, Stolperdraht `!is_known_system_axis("operating_system")` :88-90). Das Alt-Paket A7 ("grep = 0 Treffer, Datei NEU") ist damit erledigt bis auf A7' (P5).
- `meta_meta_identity.hpp` EXISTIERT; nur `hardware_meta_meta_axis.hpp` ist wirklich neu (Lane C).
- `topics/axis.hpp` traegt ungegatet `AxisKind::system_meta_meta` (+7/-1) und `ceb_sub_axis.hpp` ist unbesitzt.
Dateien/Besitzer: die 4 obigen, exklusiv A0-INV. Gates: EIN Commit "A1-Nachzug"; Beleg `grep -rn system_meta_meta libs apps tools` zeigt NUR die Deklaration (kein Achsen-Typ gibt ihn zurueck) => additiv; `ce-all` + ce-Unit-Tests 2-Pass gruen (lokale Vollbau-Luecken); Stempel-Golden-Strings unveraendert (`tests/unit/test_m_w12_stamp_bausteine.cpp:265`, `:271-273`). Byte: neutral.

### P1 -- Achsen-Endzahl entscheiden, dann A2/A3 (war BLOCKER-3; GATE)
`system_axis_order.hpp:17-20` sagt literal: finale Ordnung = VIER Haupt-Achsen (target_isa, operating_system NEU, external_utils Rename, load_framework); `compiler` wird Unter-Achsen-GRUPPE, `scheduling` wird Unter-Achse von `target_isa`. Heute stehen 5 (`abi/system_axis_code_versions.hpp:28`, Tabelle `system_axis_order.hpp:38-44`).
Folge: A6 schreibt `<compiler><opt_level>` -- bleibt `compiler` ein `<axis>`? A4 haengt zwei Unter-Achsen unter `target_isa`, wo A3 `scheduling` hinhaengt. Ohne O-1 wird A6 zweimal gebaut. **A2 (Rename) und A3 (Eltern-Zuordnung + Ordnungswechsel) sind Traeger der Ordnung und damit byte-tragend (Abschnitt 4).** A3 loest den `operating_system`-`static_assert` :88-90 auf.

### P2 -- A6: SIMD-VOLL + opt-VOLL (ersetzt Alt-A6)
Ziel: den EINZIGEN stillen Filter entfernen. Das Angebot ist vollstaendig (5 opt `measurement/system_axis_registry.xml:13-39` = `optimization_level_sub_axis.hpp:133 kAllOptLevelIds`; 3 simd `:55-71` = `simd_sub_axis.hpp:97 kAllSimdIds`), der Planer annotiert statt zu filtern (`experiment_plan_director.hpp:1801`, `:1818`), die Maschinen-Zuteilung existiert (`measure_host_lane` :397-403, Buckets :874/:1389, `tags: [amd]` :982). Gefiltert wird NUR in der Anwender-XML.
Dateien: `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` -- `opt_level` :189-192 auf O3,O2,O1,O0; `simd` :195-198 auf no_extension,avx2,avx512; Kommentar :178-186 umschreiben, der Filtersatz "avx512 nicht universell" :182 ENTFAELLT, Ofast bleibt weg (:180). Spiegel `ce/tests/unit/thesis_tiere/experiment_golden.xml:67-83`. Praedikat `ce/libs/cache_engine/profile_facade/profile_run_entry.hpp:209-216` (heute nur `__builtin_cpu_supports` :213-214, Nicht-x86 hart false) wird zur Freigabe-Abfrage `simd_release_on_machine(simd_id) -> {frei|gesperrt+Grund+machine_id}` mit Maschinen-Signatur (`machine_simd_signature.hpp`) als erster und Host-Probe als zweiter Wache; Spiegel `experiment_run_entry.hpp:284`.
**BLOCKER-1 eingearbeitet: Alt-Punkt 5 ("`admit_organ_on_machine` an Naht :759 aufrufen") ist GESTRICHEN.** Die Aufrufer existieren: `builder/build_orchestrator/build_orchestrator.hpp:458` (`aggregate_required_for_axes`) + `:460-461` (`admit_organ_on_machine(..., active_machine_signature())`) und `profile_facade/profile_run_facade.cpp:537` + `:1012` (`gate_extra_march_flags_for_build`). Eine zweite Gate-Stelle verstiesse gegen `profile_run_entry.hpp:773` ("Zulaessigkeits-Filter sitzt GENAU HIER, NICHT im Emitter/Tier/Planer") und `simd_build_gate.hpp:150-152`. A6 aendert nur die Signatur-QUELLE, nie die Anzahl der Naehte.
Registry bleibt UNVERAENDERT (avx512 steht drin) -- Roundtrip-Byte-Wache unberuehrt. XSD braucht KEINE Aenderung (`Code/test_data_xml/experiment_schema.xsd:266-270` O0..Ofast, `:314-316` no_extension|avx2|avx512). Ofast-Reject ist vorhanden (`validate_profile.hpp:388-403`, `static_assert` :384-387).
Warnung (Fehlerklasse D1, `axis_error.hpp:42` `HardwareErweiterungFehlt`, Label :66, `LogAndContinueD1Policy` aborts()==false): Log-Zeile um `machine_id` + fehlendes Flag + Signatur-Quelle erweitern (prod1 = 13 avx512-Flags, prod2/odroid = 0). Exit-Code bleibt 0 (`profile_run_entry.hpp:817` zaehlt nur `any_pruef_failed`, :173).
CSV: **Variante (B) ist bindend** -- Pflicht-Inventar-Zeile `PERM-INVENTAR: geplant=12 gebaut=N gesperrt=M` + Zaehler `perms_skipped` in `RunProfileResult` (`profile_run_entry.hpp:171-173`) + Eintrag in `complete-heuristik.log`. Variante (A) ist in der vorgeschlagenen Form **doktrinwidrig** (W-4): `sample_status_token(Failed)` ist D2 (`axis_error.hpp:55`, `:79`), eine Zulassungs-Entscheidung ist D1; Domaenen-Trennung `:170-171`, `:188-191`. Falls (A) gewollt: eigenes D1-Token, nie `sample_status_token` -> O-3.
Test-Anker (W-1: Handliste war unvollstaendig; hier literal aus `grep -n 'perm_count|4u|Yields2x2'`): `ce/tests/unit/thesis_tiere/test_experiment_plan_director.cpp` 4->12 an :157(Kommentar), :158(Testname `Yields2x2Perms` umbenennen), :170-171, :189(72->216), :206, :223, :232(76->228), :412, :423, :426, :448, :571, :585, :607, :1001-1002, :1015; je-Perm-`count_occurrences(...,4u)` -> 12u an :525, :527, :543, :1051, :1054, :1203, :1258, :1259, :1260, :1282, :1283, :1285, :1286, :1346. **NICHT anfassen** (nicht je Perm): :1307, :1326, :1327, :1331, :1674, :1678 (je Batch-Job), :142/:878/:1778/:1799 (Fixtures perm_count=1), :1506. Ferner `test_experiment_parser.cpp:174-179`, `:201`, `:378` -> 4/3/4/5. Unberuehrt: `test_kf1_thesis_profile_parser.cpp:133`, `test_gn_cell_filter.cpp:44-45`.
NEU-Wachen: (i) "golden traegt 4 deterministische opt-Stufen + 3 simd-Optionen" (Anti-Regression gegen einen neuen stillen Profil-Filter), (ii) "gesperrte Perm erzeugt WARNUNG und wird im Perm-Inventar gezaehlt".
Byte: A6 aendert nur WERTE von `+opt=`/`+ext=` (`profile_run_entry.hpp:780-782`), nicht die FORM. **W-6-Auflage:** `profile_run_facade.cpp:1082` dokumentiert eine ABWEICHENDE Suffix-Ordnung (`+ext+cxx+opt`) gegen `:780-782` (`+cxx+opt+ext`). A6 fixiert bindend die Form aus `profile_run_entry.hpp:780-782` fuer alle 12 Perms und ruehrt die Divergenz NICHT an -- sie gehoert Lane F (W-13). Gate: Beleg, dass kein A6-beruehrter Pfad die andere Form schreibt.
Volumen (1 System-Perm = 131072 Tier-Binaries, `.gitlab-ci.yml:866`; 2^17 in `test_org18_persistence_target.cpp:102-103`): IST 4 Perms = 524288; SOLL 12 Perms = 1572864 (Faktor 3,0). prod1_zen5 12/12; prod2_raptor_lake 8/12; odroid_gracemont 8/12. Lanes: amd 8 Perms, intel 4. Kleiner Kanal 12x320 = 3840. **Keine Wanduhr-Zahl** -- die einzige Empirie (24 Worker ~19,4 min je Slice, `experiment_plan_director.hpp:404-411`) nennt keine Slice-Groesse.
AVX10 wird NICHT mitgeplant: keine Option in `system_axis_registry.xml:55-71`, kein Flag im 23er-Katalog `:72-96`, kein Flag in den 3 Signaturen; der Code sagt selbst "heute existiert KEINE AVX10-Hardware im Wrapper-Bestand" (`build_variant_definition.hpp:63`, `axis_09b_simd_extension_strategy_base.hpp:54`). Stempel-POD bleibt unberuehrt (append-only).

### P3 -- A4+A5: NUMA/page-Doppelseite (Dual-Natur)
Ist-Beweis P-1: `alloc_hw` wird NUR von `fb_numa_page_study.profile.xml:49` aktiviert; golden, `experiment_golden.xml`, `experiment_golden_kern.xml` und alle Test-XML = 0 Treffer. Gegen golden/320 ist die Naht byte-neutral, gegen `fb_numa_page_study` + `tests/unit/test_fb_alloc_hw_subaxis.cpp:230-231` NICHT.
Stufe 1 (System gibt frei): Registry-Kante NICHT handpatchen (`system_axis_registry.xml:1-4`) -- Emission in `tools/system_axis_registry_gen/main.cpp` hinter dem `target_isa`-Block :244-255 nach simd-Muster :222-230; zwei `<sub_axis stage="runtime" value_type="token">` unter `target_isa` (heute traegt `target_isa` `:98-101` KEINE sub_axis). Header nach `simd_sub_axis.hpp:31-56`-Muster (CRTP + Concept, `parent_axis_label()=="target_isa"`), **kein `std::variant`**.
**BLOCKER-4 eingearbeitet:** ohne XSD + Parser ist das Angebot unerreichbar. `experiment_schema.xsd:328-331` dokumentiert wortwoertlich "target_isa ... KEINE Unter-Achse -> die `<option>`-Werte stehen DIREKT unter `<target_isa>`", erlaubt sind nur `x86_64|aarch64` (`:332-347`, Enum :340-341); `libs/common/serialization/xml_config_parser/xml_config_parser.cpp` hat keinen target_isa-Unterelement-Leser. Das Paket enthaelt daher XSD-Revision + Parser + `validate_profile`-Schritt -- oder wird als "Registry-only, Konsument vertagt" deklariert. Entscheidung O-2 (revidiert die dokumentierte A4-Festlegung vom 20.07.).
**BLOCKER-5 eingearbeitet:** `page_type` ist eine BESTEHENDE System-Achse -- `builder/experiment_tree/registry_to_axis_levels.hpp:120` pusht sie (5 Handzeilen :120-124: page_type, simd_extension, general_hardware, telemetry, isa), einkompiliert in `builder/driver_build_variant_signature.hpp:32` mit literalen Wachen `find(";page_type[")` :41 und `find("page_type[]")` :47. Gate: neue Wache, dass `kDriverBuildVariantSignature` KEIN `page_topology` enthaelt und `;page_type[` byte-identisch bleibt -- kein dritter Page-Wertraum.
**W-2 eingearbeitet:** Option-Alphabet = `native|4k|2m` (drei Werte, `AllocPageHint::Native|Page4k|Page2m`, `alloc_hw_config.hpp:42`; `all_alloc_page_hints()` :120-122 schliesst Native aus, `make_alloc_page_hint` :130-132 mappt Unbekanntes auf Native = Default von `AllocHwConfig{}` :49-50) und `auto|0|1` fuer numa (`make_alloc_numa_node` :126-128). Ein 2-Werte-Satz koennte den heutigen Default nicht ausdruecken -> stiller Hint. EIN Alphabet, keine Mapping-Tabelle.
Organ-Seite UNVERAENDERT = "Organ setzt durch": `AllocHwConfig` :48-53, `AllocHwAware` :73-87, `gate_alloc_hw_for<HW>` :94-102 (if-constexpr-Gate :97-100). Neu in `validate_profile.hpp`: (i) echte Werte-Pruefung der numa/page-Token gegen die Registry-option-ids -- ersetzt die "nicht gegen die Achsen-Registry geprueft"-Warnung :206-210 und hebt die Registry-Umgehung auf; (ii) harter Reject bei Doppelbelegung `<axis ref="alloc_hw">` UND `target_isa.*_topology`. Der `alloc_hw`-Sonderzweig BLEIBT (`:776`, Organ-SUB-Achse).
Zwei erlaubte Zustaende, je Profil GENAU EINER: (i) System-RT an der CEB (kein binary_id-Segment; `target_isa` traegt `binary_id="never"` `:98`, Organ-only-Guard `builder/experiment_tree/profile_to_tree.hpp:89-95`); (ii) Organ-CT am Tier nur bei `<axis ref="alloc_hw">` (`profile_to_tree.hpp:81-87`). **Entscheidung getroffen: `fb_numa_page_study.profile.xml:49` bleibt im Organ-CT-Zustand** -- `test_fb_alloc_hw_subaxis.cpp:230-231` bleibt gruen, der Reject-Guard ist Pflicht.
Ehrlichkeits-Praezisierung (W-3): es fehlt ein **CODEGEN**-Konsument (`apps/catalog_codegen_tool/main.cpp:183-190` lehnt `alloc_hw` hart ab); ein REALER Konsum existiert (`test_fb_alloc_hw_subaxis.cpp:13-15`: NUMAllocAllocatorBody bindet `numa_node_` compile-time). "Papier-Tiger" gilt nur fuer den Codegen-Pfad.
Fehlerklasse hugetlbfs: keine bestehende Klasse trifft zu (`HardwareErweiterungFehlt` ist literal ISA/Beschleuniger, `axis_error.hpp:42`; Infra ist Prozess/IO :100-104; die HW meldet sich als faehig, `axis_12_general_hardware_x86_64.hpp:9`). Runtime deckt `SampleStatus::SourceUnavailable` (:54) / `Failed` (:55) ab -- kein Enum-Bump. Compile-Seite braeuchte additiv `BetriebssystemFeatureFehlt = 4` + `kCompilerCompilerErrorClassCount` :46 (4->5) + Drift-Guard :170-171 + Label-Switch :62-70 -> O-4. Ehrlich: der Fehler kann heute nicht auftreten (MAP_HUGETLB nur in Kommentaren, `alloc_hw_config.hpp:44`; 2m-Hint endet in `pmr::pool_options`, `axis_06_allocator_pool_resource.hpp:195`).
Reihenfolge mit Gates: G0 Inventar (P-1 zitieren) -> B1 Header + Generator-Emission (Gate: Registry NEU GENERIERT, XML-Diff rein additiv, 2-Pass gruen) -> B2 XSD+Parser (nur nach O-2) -> B3 Validator (Gate: `fb_numa_page_study` validiert weiter, kuenstliches Doppel-Profil wird HART abgelehnt, literale Ausgabe) -> B4 Fehlerklasse (nur bei O-4) -> D1 Draht CEB (CompileFn/Sidecar nach simd-Muster; Gate: golden/320-Baum-Dump byte-identisch) -> D2 Draht Organ (Codegen instanziiert `AllocHwConfig{...}`, Reject :183-190 aufloesen; Gate: gepinnte Binary existiert, Test-Skip nur als Lagerhaltungs-Skip).
Risiko: der NUMA-Effekt braucht Multi-Socket-HW (`alloc_hw_config.hpp:22-24`) -- die Achse ist als Permutation + Dokumentation gerechtfertigt, nicht als Effekt-Nachweis.

### P4 -- A8: Stempel A-II/A-III
A8.1 (System-Array systemisch) ist mit P0/A1 erledigt. A8.2: das handgeschriebene 17-fix-Array `abi/anatomy_version_stamp.hpp:42-60` ist die Fix-Stelle; FALLE: `organ_stamp_line<Comp>()` ist per `:32-37` MOCK-ONLY -- die reale Organ-Zeile kommt aus `compose_organ_stamp_line` (`profile_facade/lazy_adhoc_source_gen.hpp:201`, `:257`). Das Meta-Meta-Array MUSS in `compose_organ_stamp_line` UND im Katalog-Zwilling `builder/experiment_tree/pilot_source_map.hpp` gleich gebaut werden, sonst bricht die 320-Round-Trip-Byte-Wache (sonst zweiter inerter Pilot). A8.3: `abi/anatomy_fingerprint.hpp:31-43` existiert; der Owner-KERN fordert die Overlay-SOURCE-Hashes -> 5. Preimage-Glied (:39-42), Budget `kAnatomyFingerprintPreimageMax = 4096` (:25) vorab literal pruefen (`src/sha512/ctsha512.hpp:164`); `builder/ceb_version_stamp.hpp:96-98` faellt mit. Gate: die vier Stempel-Zeilen bleiben GETRENNT (`anatomy_version_stamp.hpp:71/:94/:112/:182`), `system_stamp_line` bleibt mess-blind (:64-70), Preimage-Reihenfolge nur GEMEINSAM an allen drei Orten.

### P5 -- A7' + A9a: Ordnungs-Wache + XML-Regen/Roundtrip
A7' (Rest von Alt-A7): Wache von "nie leer" (`system_axis_code_versions.hpp:41-47`) auf "Generator-Blockfolge == XML-Kopf == Suffix-Emitter == `kSystemAxisOrder`" ausweiten. A9a: `tools/system_axis_registry_gen/main.cpp` iteriert `kSystemAxisOrder` statt 5 Handbloecken (`machine_signatures` :298-316, stdout-Literal :334 "5 System-Achsen-Elemente"). Gate: `tests/unit/registry_roundtrip.cmake:53-66` (`compare_files`, FATAL bei Diff) -- XML NIE handeditieren, Regen im SELBEN Commit. (H-2: der Roundtrip ist ein CMake-Gate, kein `.cpp`-Test; der Alt-Name "test_system_axis_registry_roundtrip" ist falsch.) Byte: neutral solange die Ordnung unveraendert ist -- der Ordnungswechsel gehoert A3 und damit in das EINE Fenster.

### P6 -- A9b: `active="true|false"` (Registry=Angebot, Abwahl explizit)
Ist: `grep -rn '"active"'` und `grep -rn declared_count` = 0. Schritte: XSD `experiment_schema.xsd:227-229` (`<axis ref=...>`) + optionales `active` (`xs:boolean`, Default true); Parser `xml_config_parser.cpp:266` (Thesis-Kanal) und `:469` (`axes_default_lookup`) je um `ax.active` (`xml_config_parser.hpp:100` `ThesisAxisSpec`, `:368` `ExperimentAxisDefault`); Resolver `validate_profile.hpp:765` fuehrt `active=false` in die Bausteinmenge statt Abwahl-durch-Abwesenheit; Guard-Test (unregistriert) gegen den Umkehr-Hebel `CE/CMakeLists.txt:379-380` -> `axes/persistence_target/axis_persistence_target_flags.hpp.in:9-15` -> `axis_persistence_target_registry.hpp:31`. Byte: deklarativ neutral (fehlendes Attribut == true, KEIN Profil setzt false). Ein wirksames `active="false"` aendert `EnabledTargets` -> Katalog-Kardinalitaet -> golden-CRC (`tests/unit/test_lazy_adhoc_source_gen.cpp:191-203`) = **untersagt**. `declared_count` gehoert ins Lane-F-Fenster.

### P7 -- Lane C: Meta-Meta-Hub
C-1 `hardware_meta_meta_axis.hpp` NEU (`meta_meta_identity.hpp` ist VORHANDEN, s. P0): variadisches Pack, **kein `std::variant`**; Form nach `extension_hardware_family_axis.hpp:73-75`; Vertrag V1 = mp_list-Typliste. C-2: `simd_build_gate.hpp:154-159 admit_organ_on_machine` ist bereits `T subset S` UND hat einen Aufrufer (`build_orchestrator.hpp:460`) -- C-2 hebt die Signatur auf Meta-Meta-Saetze + `constexpr subsumes(A,B)`, Freigabe-Maximum `:142-146` bleibt. C-3a: `active_machine_signature()` (`:187`, liefert heute `{}`) bindet die TYPEN (`Prod1Zen5Signature`/`Prod2RaptorLakeSignature`/`OdroidGracemontSignature`), nie die XML (`system_axis_registry.xml:118-165` ist Reflektat von `main.cpp:298-316`). **BLOCKER-1: C-3a ist BYTE-TRAGEND** -- die Flags fliessen ueber `pruef_dock` -> `effective_march_flags` (`:161-176`) in jede rsp-Zeile (`profile_run_facade.cpp:537`, `:1012`), und `build_orchestrator.hpp:460-468` beginnt Binaries mit `status = -4` abzulehnen, sobald ein Organ required-Flags erklaert. Auflagen: in das EINE Fenster, Kill-Switch, literaler rsp-Zeilen-Diff vor/nach, Beleg dass kein Organ heute required-Flags erklaert. C-3c (ISA-Zulassung fragt heute den HOST, `profile_run_entry.hpp:209-216`; `simd` haengt unter `extension_hardware`, `simd_sub_axis.hpp:37-38`) ist **PATCH-AN-A3**, kein eigener Edit an `target_isa_system_axis.hpp`. C-5: neue `.cpp`, **unregistriert** (Sammel-Registrierung am Join).

### P8 -- Lane F: Abschluss-Commit = das EINE Fenster (Abschnitt 4)

## 3. Sperrmengen-Matrix
| Datei(en) | exklusiver Besitzer | Parallel? |
|---|---|---|
| `topics/axis.hpp`, `measurement/ceb_sub_axis.hpp`, `abi/system_axis_order.hpp`, `measurement/meta_meta_identity.hpp` | **P0/A0-INV** | zuerst, allein |
| `abi/system_axis_code_versions.hpp` + Ordnungs-Wache | **P5/A7'** | seriell nach P0 |
| `abi/anatomy_version_stamp.hpp`, `abi/anatomy_fingerprint.hpp`, `builder/ceb_version_stamp.hpp`, `profile_facade/lazy_adhoc_source_gen.hpp`, `builder/experiment_tree/pilot_source_map.hpp`, `builder/codegen/adhoc_emitter.hpp` | **P4/A8** | seriell nach P0 |
| `tools/system_axis_registry_gen/main.cpp`, `measurement/system_axis_registry.xml` | **P5/A9a** | seriell nach P5-A7' |
| `xml_config_parser.{hpp,cpp}`, `Code/test_data_xml/experiment_schema.xsd`, `profile_facade/validate_profile.hpp` | **Lane A gesamt, EIN Agent** | STRENG SERIELL: A2 + A3 + P3 (alloc_hw `:206-210`/`:776` + XSD `:328-347`) + P6 wollen dieselben 3 Dateien |
| `axes/persistence_target/{axis_persistence_target_registry.hpp,axis_persistence_target_flags.hpp.in}`, `CE/CMakeLists.txt:379-380` | **P6/A9b** | parallel moeglich |
| `target_isa_system_axis.hpp` | **A3** (P3 + C-3c liefern PATCH) | STRENG SERIELL, 3 Anwaerter |
| `measurement/{machine_simd_signature,simd_build_gate,simd_organ_requirement,simd_organ_sensibility,simd_feature_flag}.hpp` + NEU `hardware_meta_meta_axis.hpp` | **Lane C** | ECHT PARALLEL zu Agent 1 |
| `extension_hardware_family_axis.hpp`, `simd_sub_axis.hpp` | **A2** | C-3 wartet auf A2 oder arbeitet unter Alt-Namen |
| `all_axes_golden.profile.xml`, `tests/unit/thesis_tiere/experiment_golden.xml`, `profile_run_entry.hpp:209-216`, `experiment_run_entry.hpp:284` | **P2/A6** (Besitz von Lane B auf A6 umgeschrieben; B ist gelandet) | seriell nach O-1 |
| `builder/driver_build_variant_signature.hpp`, `builder/experiment_tree/registry_to_axis_levels.hpp` | **P3** (nur Wachen-Erweiterung) | seriell |
| `profile_run_facade.cpp`, `artifact_transport/artifact_cache.hpp`, `Code/02_messung_driver/main.cpp` | **Lane F / G4b-1** | TABU fuer P2/P3/Lane C |
| `tests/unit/CMakeLists.txt` | **Integrator am Join** | niemand registriert selbst |
| `tests/unit/registry_roundtrip.cmake` | read-only | - |

## 4. Das EINE Byte-Ereignis und wer mitfaehrt
Es sitzt im Preimage der einkompilierten Provenienz, nicht im Suffix allein: `abi/anatomy_fingerprint.hpp:39-42` -> `lazy_adhoc_source_gen.hpp:201`, `:257-261` -> `pilot_source_map.hpp` (Katalog-Zwilling, 320-Round-Trip) -> `profile_run_facade.cpp:369-405` (`system_axes_version_suffix`, Ordnungs-Divergenz :1082) -> `artifact_cache.hpp:245-249` (`cache_key_prefix`) -> `ceb_version_stamp.hpp:96-98`.
**MUSS MITFAHREN:** A2/A3 (Ordnungs- und Namenswechsel -> `system_stamp_line()`-String), A7' (Wache auf die neue Ordnung), A8.2 (Organ-Meta-Meta in `compose_organ_stamp_line` + Katalog-Zwilling), A8.3 (5. Preimage-Glied), **C-3a** (rsp-Flags + Ablehnungen, neu klassifiziert), Lane F (Suffix-Ordnung + `cache_key_prefix`), und die literalen Golden-Strings `test_m_w12_stamp_bausteine.cpp:265`, `:271-273`, `:338`.
**FAEHRT NICHT MIT:** P0 (additiver Enumerator ohne Rueckgeber), A9a (XML ist kein DLL-Inhalt; Roundtrip-Gate im selben Commit wie der Generator), A9b (fehlendes `active` == true), C-1/C-2/C-5, A6 (nur WERTE von `+opt=`/`+ext=`), P3 bis einschliesslich B3 (kein Profil aktiviert die neue Kante).

## 5. Agenten-Zuschnitt
- **Agent 0 (allein, zuerst):** P0/A0-INV. Danach Freeze + Manager-Verifikation (diff-stat literal).
- **Agent 1 (serielle Kette):** A2 -> A3 (+C-3c-Patch) -> P5/A7' -> P5/A9a -> P6/A9b. Gemeinsame Stempel-/Generator-/Parser-Dateien, nicht teilbar.
- **Agent 2 (echt parallel):** Lane C C-1 + C-2 + C-5 (nur neue Dateien + `simd_*`-Insel, 0 Ueberlapp mit Agent 1). C-3a NICHT hier -- Fenster.
- **Agent 3 (nach O-1, seriell zu Agent 1 wegen `validate_profile.hpp`):** P2/A6.
- **Agent 4 (nach O-1+O-2, seriell zu Agent 1 wegen XSD/Parser):** P3.
- **Agent 5 (zuletzt, allein):** P4/A8 + C-3a + Lane F = das EINE Fenster, EIN Commit.
Nach jeder Paketmeldung: Working-Tree-Freeze; `grep -P '[^\x00-\x7F]'` (nur `§` erlaubt) vor der Meldung; Selbstcheck-Zeile Pflicht; kein Haken ohne literale Ausgabe.

## 6. NACH-Pruefungs-Auftrag (adversarial, NACH dem Bau -- Pflicht-Fragen)
1. Filter-Freiheit: gibt es nach A6 IRGENDEINEN Ort, der eine angebotene opt/simd-Option still verwirft? `grep` alle Profile/XML/Praedikate; jede Sperre MUSS eine Warn-Zeile mit `machine_id` + Grund erzeugen (§62-A).
2. Naht-Einzigkeit: Anzahl der Aufrufstellen von `admit_organ_on_machine` und `gate_extra_march_flags_for_build` VOR und NACH dem Bau -- unveraendert? (`build_orchestrator.hpp:460`, `profile_run_facade.cpp:537`, `:1012`).
3. INERT-Test: liefert `active_machine_signature()` echte Daten, und aendert das die rsp-Zeile? Literaler Diff einer rsp-Zeile vor/nach; wurde eine Binary mit `status = -4` abgelehnt?
4. Doppelungs-Test: kuenstliches Profil mit `<axis ref="alloc_hw">` UND `target_isa.*_topology` -- literale Reject-Ausgabe zeigen. Umgekehrt: valides Profil je Zustand baut.
5. Alphabet-Einzigkeit: `grep` nach einer Mapping-Tabelle Token->Typ ausserhalb `alloc_hw_config.hpp:126-132`; drei Page-Wertraeume? `kDriverBuildVariantSignature` enthaelt `;page_type[` unveraendert und kein `page_topology`.
6. Erreichbarkeit: kann ein Anwender-Profil die neue Unter-Achse XML-seitig waehlen (XSD validiert, Parser liest, Validator prueft, CEB reicht durch, Codegen instanziiert)? Bei "nein" auf irgendeiner Stufe: Paket ist Papier-Tiger und muss so heissen.
7. Byte-Konten: golden/320-Baum-Dump und `kNewGolden131072Crc64` unveraendert ausserhalb des EINEN Fensters; innerhalb des Fensters: erwarteter neuer Wert dokumentiert und begruendet.
8. Stempel-Zwilling: `compose_organ_stamp_line` und `pilot_source_map.hpp` erzeugen byte-gleiche Zeilen (320-Round-Trip gruen); die 4 Stempel-Zeilen sind getrennt; `system_stamp_line` mess-blind.
9. Roundtrip: `registry_roundtrip.cmake` Diff == 0, XML im selben Commit regeneriert, kein Hand-Edit (`git log -p` auf die XML).
10. Zahlen-Ehrlichkeit: 12 Perms geplant, gebaut+gesperrt == 12 auf jeder Maschine; `perms_skipped` + Inventar-Zeile vorhanden; kein D2-`failed` fuer eine D1-Zulassung; Exit-Code 0.
11. Test-Anker: `grep -n 'perm_count'` zeigt nur 12u/216u/228u dort, wo es je Perm zaehlt, und unveraenderte 4u dort, wo es je Batch-Job zaehlt.
12. TABU: `permutation_axes.xml`, `golden_fullpilot_320_binary_ids.txt`, `kV3AxisSchema` (`anatomy/observable_tier.hpp:69`), `GenusBindingTraits` (`anatomy/anatomy_base.hpp:74`), POD-`sizeof` (`build_variant_definition.hpp`), ABI-Major, conformance-Oracle -- alle unberuehrt.
13. Zeilen-Anker: alle im Bauplan zitierten `datei:zeile` nach dem Bau neu erzeugt (H-1: Alt-Auftrag driftete um 2-20 Zeilen).

## 7. Offene Owner-Entscheide (Bau-Sperre bis GO)
- **O-1 (sperrt P1/P2/P3):** Endzahl und Eltern der System-Haupt-Achsen -- 4 (`system_axis_order.hpp:17-20`: target_isa, operating_system, external_utils, load_framework; compiler wird Unter-Achsen-GRUPPE, scheduling Unter-Achse) oder bleibt 5 (`system_axis_code_versions.hpp:28`)? Davon haengt ab, ob A6 `<compiler><opt_level>` schreibt und wer den `static_assert` `:88-90` loest.
- **O-2 (sperrt P3-B2ff):** XSD-Revision `experiment_schema.xsd:328-347` ("target_isa hat KEINE Unter-Achse", A4-Festlegung 20.07.) aufheben und Parser bauen -- oder P3 als "Registry-only, Konsument vertagt" abnehmen?
- **O-3:** CSV-Sichtbarkeit einer gesperrten Perm: (B) Inventar-Zeile + `perms_skipped` allein (bindend gesetzt) -- soll zusaetzlich (A) ein Marker-Datensatz kommen? Dann mit eigenem D1-Token, nicht `sample_status_token` (`axis_error.hpp:55`, `:79`).
- **O-4:** Maschinen-Identifikation fuer `active_machine_signature()` -- die Quellen enthalten KEINE (kein Leser von `machine_id` ausser `test_m_simd_feature_flag_catalog.cpp:59`; `<machine_signatures>` wird nur geschrieben, `main.cpp:298-316`, nie geparst). Vorschlag: `COMDARE_MACHINE_ID` + cpuid-Fallback (CI-Aequivalent `GN_RUNNER_TAG`, `.gitlab-ci.yml:1074`).
- **O-5:** hugetlbfs-Fehler an der Compile-Seite (neue D1-Klasse + Count 4->5 + Drift-Guard) oder nur runtime via `SourceUnavailable`/`Failed`?
- **O-6:** CI-Autoritaets-Konflikt: `.gitlab-ci.yml:1068` sagt literal "avx512 gehoert NICHT zum §33-golden-Kernsatz -> bewusst separater Job" (Job :1069-1074, Dreifach-Gate + Default AUS :1043, :1081), waehrend A6 den Profil-Filter aufhebt. Ziehen die statischen Matrizen (`:1048`, `:1053`, `:1073`) auf 4 opt / 3 simd mit -- oder traegt nur `planer:delegate` die 12 Perms und der Fallback bleibt unangetastet?
- **O-7:** `apps/catalog_codegen_tool/main.cpp:183-190` (Hart-Reject fuer `alloc_hw`) in P3-D2 aufloesen oder ausdruecklich vertagen?

Selbstcheck: `grep -P '[^\x00-\x7F]'` auf dieses Dokument = nur `§`-Treffer (per Direktive erlaubt); keine Haken-Marken; 0 Dateien geschrieben; alle Anker aus Live-Lesung 26.07. an ce-HEAD `abef03ce` (git status, `system_axis_order.hpp`, `axis_error.hpp`, `registry_to_axis_levels.hpp`, `all_axes_golden.profile.xml`, `experiment_schema.xsd`, `test_experiment_plan_director.cpp`, `simd_build_gate.hpp`, `build_orchestrator.hpp`, `profile_run_facade.cpp`, `profile_run_entry.hpp`, `driver_build_variant_signature.hpp`, super `.gitlab-ci.yml`); Korrekturen gegen die Vorlagen: `page_type`-Push `:120` (nicht `:118`), `kCompilerCompilerErrorClassCount` `:46`, Label-Switch `:62-70`, Drift-Guard `:170-171`, SampleStatus `:53-55`, Filter-Naht `:759`/`:773`, Suffix `:780-782`, `experiment_run_entry.hpp:284`/`:295`, CI-Satz `:1068`; keine geratenen Laufzeiten; 148 Zeilen.

---

# TEIL II: V3-DELTA (26.07. abends; ultracode wf_aa52e386, 5x Fable-5-xhigh; Rohdaten: docs/sessions/backups/20260726-bauplan-v3-fable-xhigh-workflow/ergebnisse/)

# DELTA v2 -> v3 (Konsolidierung aus 4 Fable-xhigh-Re-Verifikationen, 26.07., ce-HEAD abef03ce)
Alle datei:zeile aus Live-Lesung an abef03ce; die 3 untracked P0-Dateien aus dem Working Tree (s. D2.11).
Pfade relativ ce = Code/external/comdare-cache-engine. Dieses Delta wird ADDITIV an v2 angehaengt; bei
Widerspruch gilt das Delta.

## D1. Blocker-Status der geheilten v2
- BLOCKER-1 (Gate-Naht): GEHEILT mit Praezisierung. Naht-Einzigkeit + Dreifach-Inertheit bestaetigt
  (build_orchestrator.hpp:458-469 status=-4; simd_build_gate.hpp:109-112; Stubs :185-187 = DREI, nicht einer).
  Rest: F1-F3 und Kanal-Merge fehlten in v2 als Text/Paket -> D2.1/D2.2/D2.3.
- BLOCKER-2 (Baum): GEHEILT. git status literal = exakt die 4 v2-P0-Eintraege; system_meta_meta ohne
  Rueckgeber (grep = nur Deklaration axis.hpp:26). Zeilen-Drift klein: kSystemAxisOrderCount :33 (nicht :32),
  Drift-assert :83-88, Stolperdraht :91-92. Rest: <cstddef> fehlt in ceb_sub_axis.hpp (std::size_t
  :68/:73/:76, keine Include-Kette liefert es garantiert) -> N1 in D2.4.
- BLOCKER-3 (Achsen-Endzahl): NICHT GEHEILT -- v2-O-1 ("4 oder 5") widerspricht dem Owner-KERN. KERN: DREI
  Haupt-Achsen target_isa/operating_system/external_utils; load_framework = ERSTE Meta-Meta am
  external_utils-Hub, NICHT Haupt-Achse. Der 4er-Kommentar system_axis_order.hpp:17-20 traegt den Fehler
  selbst (live bestaetigt). -> D2.5, in diesem Delta vollzogen.
- BLOCKER-4 (XSD/Parser): GEHEILT mit Praezisierung: xml_config_parser.cpp HAT einen target_isa-Leser
  (:114-115), liest aber NUR children_named("option") -> Unter-Elemente wuerden STILL ignoriert. Substanz
  (O-2 zwingend) unveraendert.
- BLOCKER-5 (page_topology): GEHEILT, aber Begruendung falsch: "page_topology" enthaelt "page_type" NICHT als
  Substring -- die find-Wachen driver_build_variant_signature.hpp:41/:47 griffen nie. Echter Kollisionsgrund:
  page_topology_tag EXISTIERT als HW4-Unter-Achse (axis_12_general_hardware_subaxes_hw1_to_hw4.hpp:38-41,
  selbe Domaene; HW3 memory_topology :36-37). -> Namen D2.6.

## D2. Neue/korrigierte Pakete
- D2.1 F1 EXPLIZIT in P7/C-3: die SIMD-Achse ist NICHT inert -- lebender Codegen-Flag-Kanal
  (permutation_codegen_tool.cpp:43-45 avx512 -> {/arch:AVX512,-mavx512f}, Emission :477-483;
  cmake/isa_features.cmake:154-161 AVX512-Zweig [Anker-Korrektur: nicht :139-153]; Fassade
  profile_run_facade.cpp:190/:192, rsp :530-532/:1005-1007, Werte simd_sub_axis.hpp:78/:85). Inert ist NUR
  das Section-37-Freigabe-Gate (simd_build_gate.hpp).
- D2.2 NEU Paket C-3b "Kanal-Merge" (neue Id; v2-O-6 = CI-Konflikt, Kollision vermieden): Beweis je Pfad,
  dass Baseline-march und Gate-Extras auf DERSELBEN Compile-Zeile landen. Ist: Fassade konkateniert bereits
  (march :530-532/:1005-1007, gate-extras :537-538/:1012-1013) -> nur belegen; Orchestrator = reject-only
  per Design (simd_build_gate.hpp:149-152), KEIN Emissions-Umbau; V36.B-Codegen-CMake gate-frei unter
  #25-B-Byte-Vertrag (isa_features.cmake:136-137) -> out-of-scope ODER Hook-Entscheid O-9. Disjunktheit
  belegt: Gate-Flags {-mgfni,-mavx512bitalg,-mavx512vpopcntdq} (simd_organ_sensibility.hpp:32,
  simd_feature_flag.hpp:75/:77/:89) vs Codegen {-mavx512f} = leere Schnittmenge; kAvx512F nicht in
  filter-meaningful. C-3b ist byte-neutral (reines Beleg-Paket) und VORBEDINGUNG jeder Scharfschaltung.
  Plus Compile-Probe: Sub-Feature-Flags im Kontext jeder Perm-Baseline wirksam (Implikation nicht annehmen).
- D2.3 C-3a-WIDERSPRUCH AUFGELOEST (v2 Nachtrag Z.5 vs Body Z.67/91/100): es gilt die Nachtrag-Linie.
  C-3 baut den MECHANISMUS (byte-neutral); Scharfschaltung = benanntes FOLGE-Paket in EIGENEM spaeterem
  GO-Fenster, gegatet auf C-3b + O-4. C-3a wird aus Agent-5-Umfang und MUSS-MITFAHREN GESTRICHEN.
  Scharfschaltung fuellt die DREI Stubs :185-187 GEMEINSAM (:187 allein = No-Op, :185 liefert leeres
  required an das pruef_dock).
- D2.4 P0/A1-Nachzug ERWEITERT (bleibt byte-neutral, EIN Commit): N1 #include <cstddef> in ceb_sub_axis.hpp;
  N2 Kommentar system_axis_order.hpp:17-20 auf DREI Haupt-Achsen korrigieren, load_framework = "verlaesst
  die Ordnung in A3 Richtung external_utils-Hub (erste Meta-Meta)"; N3 Gates wie v2-P0 (2-Pass, Golden
  unveraendert, grep-Beleg).
- D2.5 P1/O-1 UMFORMULIERT: Endzustand = kSystemAxisOrder {target_isa, operating_system, external_utils},
  kSystemAxisCodeCount 5->3; load_framework RAUS (Meta-Meta unter Hub). A3-Mitfahrer (verifiziert):
  anatomy_version_stamp.hpp:77-79 (Stempel -3/+2 Segmente), test_m_w12_stamp_bausteine.cpp:265/:271-273,
  system_axis_registry.xml:114 (load_framework-Top-Level raus; Einhaengung braucht Hub-Typ aus C-1 ->
  ECHTE Abhaengigkeit A3->C-1), Generator main.cpp:284 + stdout :334 ("5 System-Achsen-Elemente"),
  Suffix profile_run_facade.cpp:369-405, artifact_cache.hpp:245-249, ceb_version_stamp.hpp:96-98;
  static_asserts system_axis_order.hpp:90-92 loesen sich in A3 auf (:91-92 wird invertiert);
  load_framework=v1.0.0 migriert in den Meta-Meta-Stempel-Traeger (Ort = benannter Owner-Punkt, nicht raten).
- D2.6 P3-Namen: sub_axis ids = numa_node + page unter parent="target_isa" (Spiegel der AllocHwConfig-Member
  :49-50; Organ-Seite heisst schon alloc_hw.numa_node/alloc_hw.page, profile_to_tree.hpp:85-86). KEIN
  *_topology (HW3/HW4-Kollision). Doppelbelegungs-Reject prueft alloc_hw UND target_isa.numa_node|page
  (ersetzt v2-Wortlaut "target_isa.*_topology"). Registry-id-Kollisionen: keine (:13/:40/:55/:104/:116).
  Zusatz-Wache "Signatur ohne page_topology" bleibt als harmlos-additiv.
- D2.7 P3-Querverweis-Fix (Heilungs-Artefakt): v2 Z.53 "-> O-4" und Z.54 "B4 nur bei O-4" -> beide O-5.
  O-5-Empfehlung: NUR runtime (SourceUnavailable/Failed :54-:55); D1-Klasse vertagen -- MAP_HUGETLB nur in
  Kommentaren, 2m endet in pmr::pool_options (axis_06_allocator_pool_resource.hpp:195-200).
- D2.8 A6-Zusaetze: (i) Signatur-Quelle auf O-4 gaten ODER Interim "Host-Probe-only" explizit festschreiben;
  (ii) Wache: no_extension emittiert KEIN "+ext="-Segment (profile_run_entry.hpp:781, Ternary) -- eine
  A6-Wache darf "+ext=no_extension" nicht erwarten.
- D2.9 C-2 NUR ADDITIV: admit_organ_on_machine hat den realen Aufrufer build_orchestrator.hpp:460-461;
  Meta-Meta-Hebung = neue Ueberladung, Alt-Signatur bleibt; build_orchestrator.hpp bleibt unberuehrt.
- D2.10 MUSS-MITFAHREN ERGAENZT: test_g1_binary_version_stamp.cpp:64 ("+ext=avx2+cxx=gcc+opt=O3+ceb=6.0",
  die DIVERGENTE Ordnung) + :98; test_s1_cache_key_prefix.cpp:36/:69; g1_binary_version_stamp.hpp (Besitzer
  Agent 5). Fenster-Pflicht-Checkliste = grep ueber system_axes_version_suffix, cache_key_prefix,
  system_stamp_line, compose_organ_stamp_line (trifft ferner test_s2/test_s5/test_w11/test_g3-Konsumenten).
- D2.11 NACH-Pruefung: 6.3 erweitert um Zaehlung der Stub-Fuellungen (3, nicht 1) + rsp-Diff je Route
  (no_extension/avx2/avx512). 6.13/Q-13: Working-Tree-Anker (3 untracked P0-Dateien) gesondert fuehren --
  sie sind an HEAD formal nicht lesbar.

## D3. Sperrmengen-Matrix-Aenderungen
1. NEU Abhaengigkeit A3 -> C-1 (Hub-Typ fuer XML-Einhaengung): Agent 1 startet A3 erst nach C-1-Meldung.
2. Zeile Generator+XML: "P5/A9a DANN P3-B1 (nach A9a-Abschluss)" -- Exklusivitaets-Behauptung war falsch.
3. Zeile P6 persistence_target: "read-only/Guard-Test, KEIN Edit" (Registry-mp_list = TABU-Klasse).
4. NEU-Zeile build_orchestrator.hpp: UNBERUEHRT (C-2 additiv); Aufnahme nur bei Owner-Hook-Entscheid O-9.
5. NEU-Zeile g1_binary_version_stamp.hpp + test_g1/test_s1-Golden-Strings: Agent 5 (Fenster).
6. Agent-5-Umfang = P4/A8 + Lane F, OHNE C-3a (D2.3).

## D4. FINAL-VERDIKT: PLAN BAUFAEHIG als v3 = v2 + dieses Delta; KEINE weitere Heil-Runde. 0 neue
Code-Blocker; die 2 Plan-Blocker (O-1-KERN-Widerspruch, C-3a-Widerspruch) sind mit D2.5/D2.3 vollzogen.
- SOFORT (byte-neutral): P0/A1-Nachzug erweitert (D2.4, allein zuerst); danach parallel Lane C C-1,
  C-2 (additiv), C-5, C-3b (Beleg-Paket); P5/A7'+A9a seriell (neutral solange Ordnung unveraendert);
  P6 (deklarativ neutral, Guard-Test unregistriert).
- Im EINEN Byte-Fenster (erst nach O-8-GO): A2, A3 (+C-3c-Patch, nach C-1), A8.2/A8.3, Lane F,
  Golden-Strings (test_m_w12:265/:271-273/:338 + D2.10-Liste).
- GESPERRT bis GO: P2/A6 (O-1-Rest: Eltern der compiler-GRUPPE bestimmt die XML-Form), P3-B2ff (O-2),
  P3-B4 (O-5), Scharfschaltung C-3a (C-3b + O-4, eigenes spaeteres GO-Fenster).

## D5. Offene Owner-Entscheide (Delta-Stand)
- O-1 (REDUZIERT): Endzahl = 3 ist KERN-Gesetz, keine Frage mehr. Offen NUR: Eltern-Achse der
  compiler-GRUPPE (im KERN nicht benannt) -- sperrt allein die A6-XML-Form.
- O-2 (unveraendert): XSD-Revision + Parser bauen ODER P3 als "Registry-only, Konsument vertagt" abnehmen.
- O-3 (unveraendert): zusaetzlicher D1-Marker-Datensatz in der CSV ja/nein.
- O-4: Maschinen-Identifikation -- gatet jetzt AUCH die A6-Signatur-Quelle (D2.8) und die
  Scharfschaltung (D2.3).
- O-5: Empfehlung runtime-only, D1-Klasse vertagen (D2.7) -- Owner bestaetigt.
- O-6 (unveraendert, behaelt die Id CI-Konflikt): Matrizen :1048/:1053/:1073 mitziehen oder nur
  planer:delegate traegt die 12 Perms.
- O-8 NEU: Fenster-GO vor Agent-5-Start (Fenster aendert kNewGolden131072Crc64, Stempel-Golden-Strings,
  Suffix-Ordnung = TABU-Gegenstaende, fallen nur per ausdrueckliches GO).
- O-9 NEU: V36.B-Codegen-CMake -- Gate-Hook einbauen oder dauerhaft out-of-scope (Teil von C-3b).

Selbstcheck: grep -P '[^\x00-\x7F]' auf dieses Delta = 0 Treffer; alle datei:zeile aus Live-Lesung an
abef03cee33cc27beb38433e2e9997ed1dffdcc0 (untracked P0-Dateien: Working Tree, D2.11); keine Haken-Marken;
0 Dateien geschrieben; 100 Zeilen.

---

# TEIL III: OD-GO-STAND + V4-KORREKTUR load_framework=MESS-REALM (26.07. ~18:45; Owner-Quelle: docs/sessions/20260726-SESSION-od-antworten-load-framework-mess-realm-target-isa-komplex.md; Ledger §69)

> STATUS: ALLE OD-1..OD-10 ENTSCHIEDEN. Bei Widerspruch gilt TEIL III > TEIL II > TEIL I.
> Der Plan bleibt BAUFAEHIG; TEIL III aendert ZIELE, nicht die Paket-Mechanik.

## E1. GO-Register (bindend)
- OD-6 VOLLES GO: byte-neutrale Pakete DUERFEN BAUEN - P0 (gelandet ce a3644cb8) -> parallel
  Lane C C-1/C-2(additiv)/C-5/C-3b; P5 A7'+A9a seriell; P6. Byte-Fenster (A2/A3+C-3c/A8.2-3/
  Lane F/Golden-Strings) weiter GESPERRT bis O-8-Fenster-GO.
- OD-4 VOLLES GO: C-3b-Kanal-Merge-Paket exakt nach D2.2. C-3a bleibt Folge-Paket (D2.3),
  gegatet auf C-3b-Beleg + O-4.
- OD-1 RATIFIZIERT: golden-NEUTRAL; binary_id+Stempel-PRINZIP unveraendert (Tier fuehrt
  System-Achsen, Organ-Achsen, je-Achsen-Algo-Versionen, CT-SHA512-Fingerprint); nur die
  Achsen-Mitglieder je Achsen-Typ aendern sich. OD-5 GO (Stufen-Lesart), OD-8 GO, OD-9 GO
  (Bauplan-v3 deckt Alt-"V3 direkt mit rein" ab; ultracode-Auseinanderhaltung laeuft),
  OD-10 FREIGABE (NUMA/page VOR Trigger).
- META (69.7): die Bauplan-Gates O-1r/O-2/O-3/O-4/O-5/O-6/O-9 sind laut Owner BEREITS
  ENTSCHIEDEN und werden per Explore-Straengen aus den Quellen belegt+gegengelesen
  (ultracode laeuft) - NICHT neu gefragt.

## E2. V4-KORREKTUR (Ziel-Aenderungen gegen TEIL II; Detail-Kartierung via ultracode)
- K1 load_framework (R-G, Ledger §69.1): D2.5 bleibt mechanisch (RAUS aus kSystemAxisOrder/
  kSystemAxisCodeVersions, kCount 5->3, Registry-Top-Level :114 raus, Stempel -3/+2, Generator,
  Suffix) - aber das UMZUGS-ZIEL ist der MESS-REALM (Planer-Meta-Meta-Haupt-Achse; Planer
  generiert Loads, delegiert ans CEB-Interface), NICHT der external_utils-Hub.
- K2 C-1-Zuschnitt (Lane C): hardware_meta_meta_axis.hpp traegt NUR System-Meta-Metas
  (SIMD/AVX, externe HW, GPU/FPGA/NPU-Familien). load_framework wird NICHT als Hub-Instanz
  eingebaut. Die D2.5-Abhaengigkeit "A3 -> C-1 (Hub-Typ fuer die XML-Einhaengung von
  load_framework)" ENTFAELLT VORAUSSICHTLICH - die load_framework-Einhaengung geht in die
  Mess-/Planer-Registry (Kartierung bestaetigt den Ort; nicht raten).
- K3 load_framework-Versions-Traeger (D2.5-Schlusssatz): "migriert in den Meta-Meta-Stempel-
  Traeger" wird zu "migriert in den MESS-Stempel-Bereich" - der exakte Ort (Mess-Zeile [b]?
  CSV-Legende? Planer-Version?) ist Teil der V4-Kartierung; Stempel-PRINZIP per OD-1 fix.
- K4 target_isa-Komplex (Ledger §69.2): target_isa = Komplex-Achse IN SICH mit festen
  Gliedern RAM-Frequenz + CAS + CPU-Fabrikation (statisch, Command-Pattern rekursiv eine
  Ebene tiefer); die Unter-System-Achsen (scheduling, numa_node, page) haengen am
  target_isa-Komplex-Wrapper. Betrifft A3 (Wrapper-Typ), A4/A5 (Eltern-Anker unveraendert
  "target_isa"), Stempel-Identitaets-Zeile (Kartierung).
- K5 telemetry (Ledger §69.3): ZWEIGETEILT (Mess-RT-Unter im Tooling + System-CT-Haupt,
  pmc-Einbau); die Bauplan-B3-Empfehlung "telemetry bleibt in diesem Fenster System-Level
  gefuehrt" ist damit OWNER-GEDECKT als Dauerzustand (Dual-Natur), nicht nur als Interim.
- K6 OD-7 Runner (Ledger §69.6): heavy concurrency=1 (prod1 24 Worker, prod2 alle Threads),
  normal beide concurrency=2 x 12 Threads -> Infra-HANDOUT-Kanal (§69.5), kein Bau-Paket.

## E3. NAECHSTE SCHRITTE (nach diesem Nachtrag)
1. ultracode: (a) Explore-Gegenlese der bereits getroffenen Gate-Entscheide (69.7);
   (b) OD-9-Auseinanderhaltung; (c) V4-Kartierung K1-K5 (alle datei:zeile-Anker live).
2. V4-Kartierungs-Ergebnis als TEIL IV bzw. praezisierte Paket-Texte anhaengen; erst dann
   startet der A3-/Lane-C-Bau mit korrigiertem Zuschnitt (C-1 ohne load_framework SOFORT
   baubar, da rein additiv-neutral).
3. Infra-Handout OD-7 ins Cluster-git.

Selbstcheck TEIL III: ASCII bis auf Paragraph-Zeichen; rein additiv; Owner-Wortlaute im
Session-Doc verbatim gesichert; keine geratenen Orte (K3/K2 explizit als Kartierungs-Punkte).

## E4. NACHTRAG (Owner ~18:55): C-3a-FOLGE-GO VORAB ERTEILT
Owner verbatim: "C-3a erhaelt direktes volles Folge GO sobald das gate dafuer faellt."
=> KEINE weitere Owner-Schleife fuer die Scharfschaltung: sobald C-3b (Kanal-Merge-Beleg,
OD-4-GO) erbracht UND O-4 (Maschinen-Identifikation) geloest ist, wird C-3a DIREKT
ausgefuehrt - mit den D2.3/D2.11-Auflagen (DREI Stubs :185-:187 GEMEINSAM, Kill-Switch,
rsp-Diff je Route, Organ-required-Beleg, Compile-Probe der Sub-Feature-Flags). Ledger §69.9.

---


## TEIL IV -- V4-DELTA UND GATE-SCHLIESSUNG (26.07.2026 abends, Synthese Straenge A/B/C)

Geltung: TEIL IV praezisiert TEIL I-III; bei Widerspruch gilt TEIL IV. Der STRUKT-R-ALTPLAN (backups/20260726-strukt-r-planung-workflow/ergebnisse/00-bauplan-a67e501b.md) bleibt fuer Lane-F-Detailauflagen gueltig (NICHT superseded); R1-R3 sind hierher gehoben. Anker: Live-Erhebung an ce a3644cb8 (working tree clean) / super ec12ad57. Doku-Kanon: superseded Stellen werden VERMERKT, nie geloescht.

### IV.1 Gate-Register (final)

| Gate | Verdikt | Inhalt / Richtung | Kern-Beleg |
|---|---|---|---|
| O-1r | ENTSCHIEDEN | compiler+opt_level+atomic128 = Unter-Achsen-GRUPPE an der EINEN aeusseren System-Komplex-Haupt-Achse (Rekombination der DREI Haupt-Achsen), nicht an target_isa allein | verlauf-31:1249/:1281; OD-2 jsonl:82844; KONS:89 |
| O-2 | ENTSCHIEDEN: BAUEN | XSD-Revision + Parser fuer target_isa-Unter-Achsen; hebt A4-Festlegung 20.07. auf; BLOCKER-4 aufgehoben | OD-2; verlauf-18:421; verlauf-23:1769; OD-10 LED:3525 |
| O-3 | Doktrin ENTSCHIEDEN / eng OFFEN | failed+Log+complete-heuristik.log Pflicht; Zusatz-D1-CSV-Marker ja/nein offen (falls ja: eigener D1-Token, nie sample_status_token) | verlauf-16:723; verlauf-queued-erg-06:102; axis_error.hpp:55/:79 |
| O-4 | ENTSCHIEDEN | Hostname = Maschine; CPU/RAM-Fakten per Tool-Probe (libcpuid/cpuid_tool, Fallback cpu_features; decode-dimms + dmidecode); COMDARE_MACHINE_ID-Env (V2:132) GESTRICHEN (Agent-Erfindung) | verlauf-27:523; LED:3321/:3327 |
| O-5 | Doktrin ENTSCHIEDEN / eng OFFEN | Fehlerklasse+Behandlung Pflicht; Richtung runtime-only (SourceUnavailable/Failed + failed-CSV+Log); D1-Enum-Bump offen; V2:246 "Owner bestaetigt" = AUSSTEHEND | verlauf-18:825; verlauf-23:1769; LED:2316 |
| O-6 | Autoritaet ENTSCHIEDEN / eng OFFEN | Steuerung NUR planer:delegate; Matrix = Pilot, DEPRECATED+Default-AUS; Richtung: KEIN Matrizen-Nachzug; K-09/Board-#4 (KONS:50/:90) = Agent-Vermerk ohne Owner-Beleg, umgestellt | verlauf-22:1264; verlauf-27:591/:333; .gitlab-ci.yml:1040-1082 |
| O-9 | OFFEN (Richtung: OUT-OF-SCOPE) | Kein Codegen-CMake-Gate-Hook: GO-2-Byte-Vertrag + Ein-Gate-Doktrin + C-3a ohne Hook; formale Owner-Bestaetigung ausstehend | LED:458/:540; profile_run_entry.hpp:773; LED:3535 |

### IV.2 Paket-Texte (ersetzen die benannten TEIL-I/II-Stellen)

IV.2.1 A3' (ersetzt D2.5-Schluss + D3.1 Zeile 1): A3 setzt kSystemAxisOrder {target_isa, operating_system, external_utils}, kCount 5->3. load_framework verlaesst die System-Welt ERSATZLOS: system_axis_registry.xml:114-117 + Generator-Block tools/system_axis_registry_gen/main.cpp:284-296 raus, stdout :334 "5" -> "3". KEINE Abhaengigkeit A3->C-1 (einziger benannter Grund war die Hub-Einhaengung, superseded per §69.1; Gegenprobe: grep hardware_meta_meta = 0 Treffer). NEUE Auflage: im SELBEN Commit measurement_axis_registry_gen (main.cpp:35 include, :172-173 source="system:load_framework") auf "measurement:load_framework" umstellen -- die Mess-XML darf nie auf eine geloeschte System-Achse zeigen. Stempel-Arithmetik-KORREKTUR: "Stempel -3/+2" (alt D2.5) ist rechnerisch falsch; korrekt sind GENAU DREI Segmente (-4/+2 bei raus/rein-Zaehlung bzw. -3/+1 bei In-Place-Rename). Drift-Vermerke: Stolperdraht system_axis_order.hpp jetzt :93-94 (BP nannte :91-92); LED-Warnvermerk jetzt :1706 (BP/§69.1 nannten :1698).

IV.2.2 A3'-target_isa-Komplex (K4, O-2 entschieden): A3 beginnt mit dem inneren Komplex-Wrapper TargetIsaComplexAxis (CRTP; feste constexpr-Glieder ram_frequency/cas_latency/cpu_fabrication je benannter Auspraegung; Muster fixed_enum_tuple system_axis_registry.xml:104-112 + MachineSimdSignature machine_simd_signature.hpp:31-48; Owner-Wortlaut "feste Rekombination ... statisch" LED:3521 schliesst RT-Unter-Achsen-Loesung aus). scheduling (heute Top-Level :102-113), numa_node, page haengen als sub_axis am Wrapper (parent="target_isa", D2.6-Namen unveraendert). XSD experiment_schema.xsd:328-347 + Parser xml_config_parser.cpp:112-117 werden GEBAUT (O-2; BLOCKER-4 aufgehoben). Glieder-WERTE und Suffix-Wirkung erst nach RF-6/RF-7.

IV.2.3 C-1': hardware_meta_meta_axis.hpp mit AUSSCHLIESSLICH System-Meta-Metas (SIMD/AVX, externe HW, GPU/FPGA/NPU-Familien); load_framework wird NICHT instanziiert. Byte-neutral, SOFORT baubar (OD-6-GO, TEIL III E3.2). Kommentar-Nachzuege byte-neutral im gleichen oder Folge-Paket: topics/axis.hpp:21-26 (Hub-Halbsatz raus), system_axis_order.hpp:19-21 (N2-Ziel-Text auf "verlaesst die Ordnung Richtung MESS-Realm (Planer-Meta-Meta)"), load_framework_system_axis.hpp:1-8 (Realm-Klassifikation), profile_run_facade.cpp:369-370 ("Last" ist keine System-Achse mehr).

IV.2.4 Mess-Stempel-Migration (K3; GEGATET auf RF-1): load_framework=v1.0.0 migriert aus kSystemAxisCodeVersions:37 als version-Feld in die Mess-Framework-Registry (Muster MeasurementToolingInfo.version, measurement_tooling_registry.hpp:38-39; verhindert Doppel-Quelle zur CRTP-Achse) und wird als Segment der kMeasurementAxisVersionLine (anatomy_version_stamp.hpp:94-124) stempelbar. Belegkette pro Ort: Haupt-Wahl-Prinzip measurement_tooling_registry.hpp:10-11; Planer-Stempel scheidet aus (planner_version.hpp:4-7); CSV-Legende kein Versions-Traeger (R9). Segment-Emission = O-8-Fenster (aendert kCebMeasurementStamp/kCebFingerprint ceb_version_stamp.hpp:90-98 + test_m_w12:343-344); bis RF-1-GO INERT in der Registry. Invarianten-Text anatomy_version_stamp.hpp:89-91 praezisieren: Framework-WAHL = Mess-Haupt (stempelbar), workload-WERTE = RT-Unter (nie gestempelt). Einhaengungs-Ziel der Achse: measurement_axis_registry.xml als TOP-LEVEL-Block (analog measurement_category :7 / collector :26), dim workload :46 mit source="measurement:load_framework".

IV.2.5 telemetry zweigeteilt (K5): Dual-Natur-Register (LED:86/:2319) + Bauplan erhalten die Zeile "telemetry: Mess-RT-Unter im Tooling + System-CT-Haupt (pmc, IObservableTier)". System-Seite bleibt UNVERAENDERT als owner-gedeckter DAUERZUSTAND (registry_to_axis_levels.hpp:123; +tel=silent profile_run_facade.cpp:396-401; Wache test_br1_full22_count.cpp:61-71 bleibt gruen). ABGRENZUNG: die 5er-Menge in build_system_axis_levels ist NICHT kSystemAxisOrder -- A3 (5->3) beruehrt diese Funktion nicht. Mess-RT-Unter-dim additiv in measurement_axis_registry.xml/dynamic_dims anlegen (Muster workload :46), golden-neutral; Charakter (Provenienz-dim vs Sweep) nach RF-8.

IV.2.6 Maschinen-Identifikation (O-4): V2:132 wird ERSETZT durch: Laufzeit-Hostname = Maschinen-Identitaet; CPU-Gleichheit/Fabrikation per Tool-Probe libcpuid/cpuid_tool (primaer) / google cpu_features --json (Fallback); RAM-Frequenz/CAS per decode-dimms + dmidecode -t memory; normalisierte Kern-Kennung (vendor, brand_string, family, model, stepping). Keine Env-Var (nirgends owner-gefordert). Diese Tool-Probe ist der Erkennungs-Kanal fuer die IV.2.2-Glieder.

IV.2.7 compiler-Gruppe (O-1r): Die Unter-Achsen-Gruppe compiler+opt_level+atomic128 haengt an der EINEN aeusseren System-Komplex-Haupt-Achse (Command-Pattern-Wrapper der Rekombination target_isa x operating_system x external_utils inkl. Meta-Metas, ohne load_framework), NICHT an target_isa. V2:240-241 wird entsprechend korrigiert. Draft-Skizze CompoundSystemAxis + SubAxisGroup (a51c70a7:190, a67e501b:102) bleibt Muster: SubAxisGroup am AEUSSEREN Wrapper, TargetIsaComplexAxis (IV.2.2) rekursiv eine Ebene tiefer (LED:3521 "rekursiv gewrappt").

IV.2.8 hugetlbfs (O-5-Richtung): D2.7 bleibt runtime-only (SourceUnavailable/Failed + failed-CSV + Log); der compile-seitige D1-Enum-Bump (BetriebssystemFeatureFehlt, Count 4->5) wird NUR nach RF-3-GO gebaut. V2:246 wird von "Owner bestaetigt" auf "Owner-Bestaetigung AUSSTEHEND (RF-3)" korrigiert.

IV.2.9 CI-Autoritaet (O-6): planer:delegate ist die EINZIGE Steuerung; die statischen Matrizen .gitlab-ci.yml:1048/:1053/:1073 werden NICHT mitgezogen (Pilot, DEPRECATED, Default-AUS). K-09/Board-#4 (KONS:50/:90) wird umgestellt auf "KEIN Nachzug (Richtung); Owner-Entscheid Loeschen-vs-Stehenlassen ausstehend (RF-4)".

IV.2.10 Codegen (O-9): V36.B-Codegen-CMake bleibt gate-frei unter dem #25-B-Byte-Vertrag; KEIN Gate-Hook (Ein-Gate-Doktrin profile_run_entry.hpp:773; GO-2 LED:458/540; C-3a-Auflagen LED:3535 ohne Hook). Status: dauerhaft out-of-scope, vorbehaltlich formaler Owner-Bestaetigung (RF-5).

IV.2.11 D1-Sichtbarkeit (O-3): Sichtbarkeits-Pflicht (failed statt null + Log; complete-heuristik.log-Zaehlung) ist bindend umzusetzen (Variante B, V2:47). Ein ZUSAETZLICHER CSV-Datensatz fuer D1-zulassungs-gesperrte Perms wird erst nach RF-2-GO gebaut; falls ja, mit EIGENEM D1-Token (nie sample_status_token, axis_error.hpp:55/:79).

IV.2.12 Lane-F-Auflagen R1-R3 (OD-9-Restpunkte, in den Agent-5/O-8-Fenster-Auftrag):
- R1: GN_PREFIX-Haertung .gitlab-ci.yml:877-880; Fallback :896 hart fehlschlagen (ALTPLAN:176).
- R2: NEU-Wachen T-a (Perm-Suffix==Facade-Suffix), T-b (count("+ceb=")==1), T-c Segment-Ordnungs-Wache -- T-c NEU formuliert auf die DREI-Achsen-Ordnung (D2.5/K1/K4) (ALTPLAN:177).
- R3: Traeger-Datei profile_facade/system_version_suffix.hpp als EINZIGE Suffix-Quelle anlegen und verdrahten (ALTPLAN:109/:176).

### IV.3 Abhaengigkeiten / Sperrmengen (Delta zu D3/D4)

ENTFAELLT: A3->C-1 (BP:195-196, :222; D4 :234 "nach C-1" gestrichen). ERLEDIGT: BLOCKER-3 (BP:156-159; Mess-Realm statt Hub). AUFGEHOBEN: BLOCKER-4 (BP:160-162; O-2 entschieden). BLEIBT: O-8-Fenster-Sperre fuer alle Byte-Ereignisse (TEIL III E1).
NEU (atomare Kopplung): A3 <-> tools/measurement_axis_registry_gen/main.cpp (:35/:172-173) im selben Commit.
A3-Sperrmenge (erweitert): system_axis_registry.xml, system_axis_registry_gen/main.cpp, system_axis_code_versions.hpp, system_axis_order.hpp, anatomy_version_stamp.hpp, load_framework_system_axis.hpp, target_isa_system_axis.hpp (Wrapper), measurement_axis_registry.xml + Generator, measurement_framework_registry.hpp, test_experiment_plan_director.cpp:113-114, test_striktheit_axis_dach_guard.cpp:17/:117, test_m_w12-Golden-Strings.
Lane-F-Sperrmenge (erweitert um R1-R3): profile_run_facade.cpp:371-405/:1077-1084, artifact_cache.hpp:245-249, NEU system_version_suffix.hpp, .gitlab-ci.yml:877-896, Suffix-Test-Familien + NEU-Wachen T-a/T-b/T-c.

### IV.4 Bau-Reihenfolge (naechste Schritte)

1. SOFORT (byte-neutral, kein Gate): C-1' (IV.2.3) inkl. Kommentar-Nachzuege; telemetry-Mess-dim additiv (IV.2.5); version-Feld-Vorbereitung measurement_framework_registry.hpp INERT (IV.2.4); Doc-Vermerk-Schicht (IV.6); Bauplan-Korrekturen V2:132/:240-241/:246 + K-09-Umstellung.
2. SOFORT (golden-neutral, O-2 entschieden): XSD-Revision experiment_schema.xsd:328-347 + Parser-Erweiterung xml_config_parser.cpp:112-117 (additiv, noch ohne XML-Konsument).
3. RF-1..RF-3 beim Owner einholen (VOR Fenster-GO, damit die byte-tragenden Entscheide im EINEN Fenster mitfahren -- P8-Doktrin).
4. O-8-FENSTER (nach Fenster-GO, das EINE Byte-Fenster): A2 / A3 (IV.2.1 + IV.2.2 Wrapper + atomarer Registry-Umzug + C-3c-Patch) / A8.2-3 / Lane F inkl. R1-R3 (IV.2.12) / Golden-String-Neuanker (test_m_w12, test_g1/s1 u.a. per D2.10-Checkliste) / Mess-Stempel-Segment (IV.2.4, nur mit RF-1-GO).
5. NACH FENSTER, VOR VOLL-BAU-4: NUMA/page-Umbau als RT-Unter-Achsen am Wrapper (OD-10-Freigabe LED:3525).
6. Voll-Bau-4 + golden-Regen; Pipeline hart gruen.

### IV.5 Restfragen an den Owner + ausstehende GOs

RF-1 (Stempel-Traeger-GO, F3): Ort fuer das load_framework-Versions-Segment = kMeasurementAxisVersionLine (Belegkette IV.2.4)? Inkl. Segment-Reihenfolge relativ zu measurement_tooling (byte-tragend). Zusatz: eigener AxisKind-Diskriminator measurement_meta_meta (additiv) oder Umbenennung von system_meta_meta? -- Unaufloesbar, weil D2.5:199 einen BENANNTEN Owner-Punkt verlangt ("nicht raten").
RF-2 (O-3 eng): Zusaetzlicher CSV-Datensatz fuer D1-zulassungs-gesperrte Perms ja/nein? -- Unaufloesbar: failed-Doktrin (verlauf-16:723) betrifft wortlautlich D2-Scheitern; fuer D1 existiert kein Owner-Wortlaut in beide Richtungen.
RF-3 (O-5 eng): Compile-seitiger D1-Enum-Bump BetriebssystemFeatureFehlt (Count 4->5) ja/nein, oder runtime-only endgueltig? -- Unaufloesbar: nirgends literal entschieden; beide Formen doktrin-vereinbar.
RF-4 (O-6 eng): Deprecated-Matrizen :1048/:1053/:1073 LOESCHEN oder deprecated stehen lassen? (Mitziehen ist per Doktrin ausgeschlossen.) -- Unaufloesbar: kein Owner-Satz zum Verbleib des Pilots.
RF-5 (O-9): Bestaetigung "Codegen-CMake dauerhaft out-of-scope, kein Gate-Hook"? -- Unaufloesbar: kein Owner-Wortlaut trotz Voll-Grep; nur Ableitung (IV.2.10).
RF-6 (F1, durch O-4 verengt): target_isa-Glieder-WERTE (RAM-Frequenz/CAS/CPU-Fabrikation): je MASCHINE deklariert (machine_signatures-Muster, per O-4-Tool-Probe verifiziert) oder freie benannte Auspraegungs-Familie? Einheiten/Normalisierung? Wirkung auf build_version-Suffix/Sidecar oder NUR Stempel-Identitaet? -- Unaufloesbar: keine Quelle nennt Werte, Einheiten oder Suffix-Wirkung; O-4 fixiert nur die Erkennungs-Tools.
RF-7 (F2): Stempel-Klammerung der Komplex-Achsen: EINE Zeile (target_isa=code@X.Y.Z) oder je festes Glied eigene Klammer (LED:3412 "je Achse ihre eigene Klammer" vs O-1r "verhalten sich wie EINE")? Gleiches fuer die aeussere System-Komplex-Achse. -- Unaufloesbar: beide Owner-Aussagen koexistieren ohne Aufloesungs-Satz.
RF-8 (F4): telemetry-Mess-Seite: reine Provenienz-/CSV-dim (beobachtet, nicht permutiert) oder echte Sweep-Unter-Achse (Planer permutiert Active/Silent)? -- Unaufloesbar: LED:3523 klassifiziert die Dual-Natur, nicht den Sweep-Charakter.
AUSSTEHENDES GO: O-8-Fenster-GO (TEIL III E1) -- Fenster-Inhalt jetzt inkl. R1-R3 und (nach RF-1) Mess-Stempel-Segment.

### IV.6 Doc-Vermerk-Schicht (nur Vermerke, nie Loeschung)

Hub-Halbsatz superseded vermerken an: LED:84, :91+:93, :1704+:1706 (Drift +8 zu "1698"), :2782, :2791 (GLOBAL-KLAUSEL LED:3519); ANKER:19-20 (A-04/A-05), :61/:76/:78/:83/:88/:90 (Umzugs-Paket -> Mess-Realm-Ziel); BP:6-7/:38/:129/:156-159/:189-191. LED:3509 (§68a): Vermerk load_framework-Verortung in der Mess-Tooling-Gruppe VOR target_isa. telemetry-Zeile ergaenzen: LED:86 + :2319; Q-13-Doc-Stellen (DOSSIER:262, HANDOVER-6:42-43, MEM-ACH:32) Praezisierungs-Vermerk per LED:3523.


> Quelle TEIL IV: ultracode wf_ba9ef9ea (4x Fable-5-xhigh: Gate-Explore + OD-9 + V4-Kartierung -> Synthese); Rohdaten-Backup folgt unter docs/sessions/backups/.

---

# TEIL V: RETIRE+MERGE V36.B -> FASSADEN-KANAL (26.07. ~22:20; ultracode wf_7fbd813d, 3 Straenge + Synthese, inkl. Web-Recherche; Owner-Entscheid §71, Vorab-GO §72)

> MANAGER-VORENTSCHEIDE beim Anhaengen: (M1) Frist-Klammer praezisiert - die Mo-CSV ist BEREITS ERBRACHT (D-03); die V-2/V-3-Vorsicht gilt weiter fuer die LAUFFAEHIGKEIT des messung_driver (kein Merge-Schritt darf den Treiber zwischenzeitlich toeten). (M2) Q2 VORENTSCHIEDEN konservativ: PRT-ART-Zwilling NICHT blind mitziehen - erst Inventar-Pass im prt-art-Repo (je-Repo-GO-Doktrin). (M3) Q3 VORENTSCHIEDEN: ERSATZ-Gate (Planer-Plan/Bestandslog) statt ersatzlos - ein leerer Bau muss weiter frueh mit klarem Exit sterben. Q1/Q4/Q5/Q6/Q7 = echte Owner-Punkte, NICHT blockierend fuer V-0..V-4/V-6-Kern.

== (1) VERDIKT ZUR OWNER-VERMUTUNG ==

BESTAETIGT MIT AUFLAGEN. Der Kern des Alt-Kanals ist im neuen Fassaden-Kanal gruendlich und durchweg feiner ersetzt: Enumeration (17 Achsen lazy statt 5, ce libs/cache_engine/profile_facade/lazy_adhoc_source_gen.hpp:2-24), Host-ISA-Gate (profile_run_entry.hpp:206-209/:759), SIMD-Flag-Emission single-source in der Achse (simd_sub_axis.hpp:71-87, zeichengleich belegt test_c3b_kanal_merge_beleg.cpp:16-24/:81-96), Quell-Emission (adhoc_emitter.hpp:84), selective rebuild organ-genau (build_orchestrator.hpp:245-287), Allokator-Breite 26+ statt 7 (axes/alloc/, profile_run_facade.cpp:133-149). Der Direkt-Compile ohne CMake (make_gpp_compile_fn, build_orchestrator.hpp:717) erfuellt die Praemisse "Arbeit an den C++23-Compiler" architektonisch besser als der Alt-Kanal. FEHLT-LISTE (vollstaendig, 5 Punkte): F1 SIMD-Zellen sse4.2/neon fehlen der neuen System-Achse (simd_sub_axis.hpp:98-99 nur no_extension/avx2/avx512 vs Tool :391/:403-413) - Owner-Punkt. F2 Vendor-Allokator-Provisioning haengt am Retire-Flag (ext/CMakeLists.txt:17-19/:57/:123/:158/:179/:202) - harte Merge-Substanz, MUSS vor Retire entkoppelt werden. F3 Configure-Zeit-Bestandsinventar (permutations_manifest.txt) hat 3 lebende Konsumenten (main.cpp:641; super .gitlab-ci.yml:370-371; Code/CMakeLists.txt:276-289) - harte Merge-Substanz. F4 MSVC/Windows-Bauweg existiert im neuen Builder nicht (build_orchestrator.hpp:699 nur Kommentar) - Owner-Punkt, unter CI==baremetal(Linux) verschmerzbar. F5 perm_<id>_run-Vergleichsfaehigkeit (COMDARE_LEGACY_MESSREIHEN, LED:536 B2) endet faktisch - nur Verbuchung noetig, §71 deckt ab.

== (2) TEIL-V-ENTWURF (direkt anhaengbar) ==

# TEIL V - RETIRE+MERGE V36.B-CODEGEN-CMAKE-KANAL -> FASSADEN-KANAL (Owner-Entscheid §71, O-8-Vorab-GO §72 LED:3545-3547)

FRIST-KLAMMER: V-1..V-4 sind Bau-Arbeit; die Mo-27.07.-CSV-Kette (erste CSV auf NAS) haengt am heutigen Startgate main.cpp:641. V-2 und V-3 duerfen NICHT vor der Mo-CSV-Landung scharf werden, ausser sie landen in EINEM Zug mit Doppel-Verifikation (Treiber-Lauf ohne Manifest rc 0 VOR Merge).

## Paket V-0: Doku-Verbuchung (SOFORT)
Ziel: #25-B-Byte-Vertrag als ABGELOEST verbuchen (nie loeschen, nur deprecaten); Abloesungs-Vermerk mit §71/§72-Referenz neben den GO-2-Eintraegen; Deprecations-Banner in den Alt-Kanal-Koepfen.
Dateien: super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Vermerk zu :458/:540); super/Code/MANUAL_RUN.md (Banner, :50 "comdare_perms_all ZWINGEND" wird irrefuehrend); ce tools/permutation_codegen/codegen.cmake:1-12 (Banner).
Byte-Klasse: byte-neutral. Gates: CI gruen. Besitzer: Doku/Ledger-Agent.

## Paket V-1: Vendor-Provisioning-Entkopplung (ERSTE Code-Aenderung, O-8-FENSTER)
Ziel: Alle COMDARE_VENDOR_*-Defaults von COMDARE_BUILD_PERMUTATIONS auf einen EIGENEN Schalter umhaengen (Vorschlag: COMDARE_PROVISION_VENDOR_ALLOCATORS; Effektiv-Werte identisch: super ON, ce-standalone OFF). Die add_subdirectory(ext)- und link_libraries-Bloecke (ce CMakeLists.txt:567-570/:586-604) auf den neuen Schalter; USE-Baking (:571-588) unveraendert.
Dateien: ce ext/CMakeLists.txt:17-19/:57/:123/:158/:179/:202; ce CMakeLists.txt:567-604; super Code/CMakeLists.txt (neuer set ON).
Byte-Klasse: O-8-FENSTER - einzige byte-tragende Stelle des ganzen Retires: kippt ein COMDARE_AXIS_06_USE_*-Flag (global gebacken via axis_06_allocator_flags.hpp.in), aendert sich der Codegen ALLER Tier-Binaries. Byte-neutral machbar und zu BEWEISEN.
Gates: G1 Byte-Diff generated/axes/alloc/axis_06_allocator_flags.hpp vor/nach identisch (super-Tree UND ce-standalone); G2 voller lokaler Bau (Referenz falsches Gruen); G3 CI hart gruen. Besitzer: Impl-Agent mit O-8-Fenster-Anmeldung.

## Paket V-2: Bestandsinventar-Umzug (byte-neutral, MESS-KRITISCH)
Ziel: Alle Konsumenten von generated/permutations_manifest.txt vom Configure-Zeit-Artefakt loesen, BEVOR der Codegen faellt.
2a Treiber-Startgate: main.cpp:641 + permutations_runtime_check.hpp:87-100 ersatzlos deprecaten ODER auf Planer-Plan/Bestandslog-Gate umziehen (OWNER-PUNKT Q3); Defines Code/02_messung_driver/CMakeLists.txt:141-142 raus; Legacy-Bloecke main.cpp:651-676 bleiben COMDARE_LEGACY_MESSREIHEN-gegatet.
2b super-CI visibility:tier-binaries (.gitlab-ci.yml:346-372): Umbau auf Planer --dump-plan/Bestandslog oder Entfall - INFRA-HANDOUT (LED:3539: .gitlab-ci.yml = Infra-Gebiet).
2c write_perm_all_manifest (Code/CMakeLists.txt:276-289 + cmake/write_perm_all_manifest.cmake) und tier_binary_visibility (:431-443) auf Planer-Plan umziehen.
Byte-Klasse: byte-neutral, aber operativ mess-kritisch (sonst Exit 2 fuer JEDEN Messlauf).
Gates: Treiber ohne Manifest: --validate und Smoke-Lauf rc 0; Visibility-Ersatz in CI gruen; Manual-Handlauf Stufe 1-2. Besitzer: Impl (Treiber/CMake) + Infra (CI-YAML).

## Paket V-3: Super-Abschaltung (byte-neutral)
Ziel: super-Configure fuehrt keinen Codegen mehr aus; Re-Export-Targets weg.
Dateien: super Code/CMakeLists.txt:92-102 (Defaults/Modes/Profile inkl. PRT-ART :94/:98/:102), :212-216 (comdare_perms_ce), :222-227 (comdare_perms_pa), Reste aus :276-289. PRT-ART-Zwilling V36.C inkl. prt_art_permutations_manifest.txt (:283) in den Scope, da das V36.D-Gate CE||PA prueft (permutations_runtime_check.hpp:88-89); prt-art-Repo-Innereien UNGEPRUEFT (OWNER-PUNKT Q2).
Gates: Configure sauber; voller lokaler Bau; CI gruen; grep permutations_manifest ueber super = 0 Live-Treffer. Besitzer: Impl.

## Paket V-4: ce-Retire (byte-neutral)
Ziel: Alt-Kanal in ce stilllegen; Doku-nie-loeschen beachten (Deprecations-Banner bzw. Archiv-Verschiebung, KEINE Loeschung von codegen.cmake/sh/bat/axes_versions.txt als Doku-Artefakte - Loesch- vs. Banner-Frage nur fuer Quellcode-Targets).
Dateien: ce CMakeLists.txt:33 (Option), :560-609 (Include :562-563, Targets :606-608; :567-604 wurde in V-1 umgehaengt); cmake/permutations.cmake ganz (Stale-Verweis :47 faellt mit); libs/cache_engine/builder/permutation_codegen_tool/ + apps/permutation_codegen_tool/; tests/unit/CMakeLists.txt:3787-3803 + tests/unit/perm_codegen_byte_identity.cmake (fallen mit dem #25-B-Vertrag, Owner-GO §71 liegt vor - im Ledger als abgeloest verbucht per V-0); ce .gitlab-ci.yml:453 (comdare_permutation_codegen_cli aus Prebuild; CI-YAML = Infra).
Kommentar-Nachzuege: isa_features.cmake:136-137 (GO-2-Scoping historisieren; comdare_apply_simd_extension_flags/_optimization_level_flags BLEIBEN, lebende Konsumenten tests/unit/CMakeLists.txt:1795/:3079-3080); test_c3b_kanal_merge_beleg.cpp:7/:16-18 (Kanal-A-Verweise historisieren, Test als Flag-Wert-Regression BEHALTEN); Beifang: COMDARE_apply_simd_flags (isa_features.cmake:103-123, 0 Aufrufer) mit entfernen.
Byte-Klasse: byte-neutral (perm_*-DLLs sind nicht die Tier-Binaries; kein ce-Runtime-Konsument, Strang A (2)).
Gates: ctest-Delta exakt -2 Tests, sonst gruen; CI hart gruen; grep V36/permutation_codegen = nur noch Doku/Archiv-Treffer. Besitzer: Impl; CI-Zeile Infra.

## Paket V-5: Merge-Substanz Faehigkeiten (additiv, NUR nach Owner-Entscheid)
5a sse4.2/neon als neue System-Zellen (simd_sub_axis.hpp:98-99; Flag-Werte aus codegen.cmake:577-580 uebernehmen) - Q1. Byte-Klasse: additiv, golden-neutral solange Golden-Profil unveraendert.
5b make_msvc_compile_fn (build_orchestrator.hpp:699/:717); msvc-Flag-Werte liegen in den Achsen bereits deklariert (simd_sub_axis.hpp:73/:80/:87) - Q4.
5c COMDARE_LEGACY_MESSREIHEN-Vergleichspfad (main.cpp:651/:668) als ABGELOEST verbuchen (Doku-Vermerk, Gate bleibt vorerst im Code; golden-320-Subsumtion lt. LED:536 B2 unbestaetigt). Byte-neutral.
Gates: neue Zellen ausserhalb golden; Beleg-Test erweitern. Besitzer: Impl nach Owner-GO.

## Paket V-6: Toolchain + Manual + Install ("leicht installierbar nach Stand der Technik")
(i) install()-Targets fuer Treiber und Planer/CEB-CLI (heute 0 Treffer in ce/super-CMakeLists, Strang B (4)iv). (ii) CMakePresets.json ausbauen (Presets = Konsens, Strang C (1); reales Minimum bleibt cmake 3.28, ce CMakeLists.txt:7). (iii) Harter Compiler-Assert CMAKE_CXX_COMPILER_VERSION == g++-16-Pin; Toolchain-PPA-Paketversion dokumentieren/apt-pinnen (PPA-Pakete mutabel, Strang C). (iv) CI-Container: IDENTISCHER Installationsweg wie baremetal (gleiches PPA, gleiche Versionsnummern) + Digest-Pinning der buildtools-Images; offizielles gcc-Docker-Image nur 2. Wahl (Debian-Basis bricht CI==baremetal) - INFRA. (v) Manual-Konsolidierung: super/MANUAL_RUN.md = Master; Stufe-3-Messlauf ausschreiben (heute Skelett :191-195); Toolchain-Tabelle :18 auf cmake>=3.28 korrigieren; super/Code/MANUAL_RUN.md deprecaten (nie loeschen); ce/MANUAL_RUN.md:15-17 angleichen. (vi) Manual-Gliederung (je Werkzeug EIN Manual, clig.dev): 1 Toolchain-Install (Pin-Tabelle) / 2 Repo+Vendor (mp11-Pflichtpfad) / 3 Bau (Preset) / 4 Validieren / 5 Planen (--dump-plan/--dump-cmake) / 6 Tier-Bau (--emit-tier-*) / 7 Echter Messlauf (Env-Pins) / 8 CI-Anwendung (planer:delegate + Lint) / 9 Exit-Codes+Troubleshooting / 10 --version-Selbstauskunft. CLI-Subcommand-Umbau der --dump/--emit-Flags: OWNER-PUNKT Q7 (nachrangig).
Byte-Klasse: byte-neutral. Gates: wortgetreuer Handlauf auf Zweitmaschine (prod2, §61 Dual-Weg); Aufruf aus Installationspfad rc 0. Besitzer: Impl (Manual/Install), Infra (Images).

## Paket V-7: CI==baremetal-Gleichlauf-Gates (dauerhafte Abnahme-Checkliste)
G-A Single-Source-Walk bleibt test-gestuetzt (construct_plan_into profile_run_facade.cpp:804; Byte-Determinismus-Zusage profile_run_facade.hpp:263-265). G-B CI-Zell-Bau == Manual-Handlauf-Block gegenlesen bei jeder Aenderung (super .gitlab-ci.yml:858/:860/:1010-1012 vs MANUAL_RUN.md:40-41). G-C Gewollte Divergenzen dokumentieren (CI-Smoke m3v2_smoke :1239-1242; Mess-Stufe beidseits gated :1289). G-D Toolchain-Gleichheit per Versions-Assert (V-6iii) in beiden Welten. Besitzer: Infra+Impl gemeinsam.

## Neben-Kanal-Behandlung (Strang-B-Funde, Vorschlaege - Entscheid beim Owner wo markiert)
(a) catalog_codegen (ce CMakeLists.txt:655): MERGE-Kandidat (CMake-Umweg), traegt aber heute den GN-2-Guard -> BEHALTEN bis Guard-Ersatz im Fassaden-Kanal, dann eigenes Retire-Paket. OWNER-PUNKT (nicht fristkritisch).
(b) Registry-Generatoren (ce tools/CMakeLists.txt:11-17): BEHALTEN - ANGEBOT-Doktrin, kein Steuer-Kanal.
(c) anatomy_codegen_runner (ce cmake/anatomy_codegen_runner.cmake:1-12): MERGE-Kandidat spaeter (Configure-Zeit-execute_process = CMake-Umweg). OWNER-PUNKT, nicht fristkritisch.
(d) Direkte CMake-option()-Schienen (AXIS_06_ENABLE_*, MEASUREMENT_MODE/RELEASE_MODE, STATISTICS, OBSERVER_PUSH, PMC/PAPI; ce CMakeLists.txt:44/:57/:112-113/:133/:145/:156-179): Ein-Kanal-Praemisse hier NICHT erfuellt; Vorschlag: eigenes Band "Angebots-Zuschnitt in Profil-XML" NACH TEIL-V; PMC/PAPI/MEASUREMENT_MODE sind Host-Belange und bleiben evtl. bewusst CMake-seitig. OWNER-PUNKT Q6.
(e) CI-Matrix-Reste (super .gitlab-ci.yml:631/:713/:1044/:1070): Entscheid liegt vor (RF-4 LED:3539 archivieren per Infra-Handout), Umsetzung offen -> ins Infra-Handout, KEIN neuer Entscheid.
(f) messreihen.xml (V9.6): bleibt gegatet; mit V-5c als abgeloest verbuchen; endgueltige Entfernung erst nach golden-320-Subsumtions-Bestaetigung. OWNER-PUNKT nur fuer Entfernung.
(g) CMakePresets.json: BEHALTEN und in V-6 ausbauen.

## Reihenfolge (bindend)
V-0 -> V-1 (O-8-Fenster) -> V-2 -> V-3 -> V-4 -> V-5 (nach Owner-Entscheiden) -> V-6 -> V-7 als Dauer-Gate. V-2 und V-3 in einem Zug oder V-2 strikt vor V-3; nichts davon vor der Mo-CSV-Landung scharf.

== (3) RESTFRAGEN AN DEN OWNER (nur echte) ==

Q1: sse4.2 (-msse4.2/CRC32) und neon als neue System-Zellen in die simd-Unterachse mergen, oder bewusst als Design-Space-Vokabular entfallen lassen (prod1/prod2 = x86, SSE2 = ABI-Baseline)? Es ist die einzige literale Faehigkeits-Differenz im Kern.
Q2: PRT-ART-Zwilling (V36.C): darf der Retire-Scope prt-art ohne vorherige Repo-Inspektion mitziehen (Innereien UNGEPRUEFT), oder erst Inventar-Pass im prt-art-Repo?
Q3: messung_driver-Startgate: ersatzlos fallen lassen oder durch ein Bestandslog/Planer-Plan-Gate ersetzen (Empfehlung: Ersatz-Gate, damit ein leerer Bau weiter frueh mit klarem Exit stirbt)?
Q4: Windows/MSVC-Bauweg: make_msvc_compile_fn als Merge-Substanz bauen oder Windows mit dem Retire offiziell aus dem Zielbild nehmen (Praemisse CI==baremetal Linux legt Letzteres nahe)?
Q5: Compiler-Doktrin fuer den gemergten Kanal: Ein-Compiler g++-16 (dann sind P2996-Reflection/template-for real nutzbar, aber experimentell und nicht Clang-portabel) oder C++23-Floor + Mp11-Muster mit Reflection als spaeterem Drop-in?
Q6: Neben-Kanal (d): XML-Ueberfuehrung des Angebots-Zuschnitts als eigenes Band nach TEIL-V einplanen - ja/nein, und welche Schalter bleiben bewusst Host-/CMake-seitig?
Q7: CLI-UX-Umbau (--dump/--emit-Flags -> clig.dev-Subcommands je Werkzeug): jetzt in V-6 oder nach der Frist?

## TEIL V NACHTRAG (Owner ~22:30, Ledger §73): Q-ENTSCHEIDE + EIN-HAUPTKANAL-VERSCHAERFUNG
- EIN-HAUPTKANAL (73.1): Das Neben-Kanal-Register (a)-(g) ist KONSOLIDIERUNGS-PFLICHT-Liste; je
  Kandidat ein benanntes Merge-Paket nach V-4 (catalog_codegen erst nach GN-2-Guard-Ersatz;
  anatomy_codegen_runner-Merge einplanen). Skript-Doktrin: keine Skripte ausser CMake (sparsam) -
  codegen.sh/bat fallen mit V-4 als Archiv-Artefakte.
- V-5a PRAEZISIERT (Q1): sse4.2/neon = Zellen der eigenen System-Meta-Meta-Hauptachse
  (SIMD-Familie unter external_utils-Hub), Flag-Werte aus codegen.cmake:577-580; golden-neutral
  solange Golden-Profil unveraendert.
- V-5b BESTAETIGT (Q4): make_msvc_compile_fn = Merge-Substanz; Vorstufe = Infra-Handout
  Windows-Runner id53/54/55 einrichten (Owner-OK §73.3), MSVC-Debug dort.
- V-6iii KORRIGIERT (Q5): Toolchain-Floor = g++ >= 15.3 (Minimum UND Standard, kein 16er-Pin);
  mp11 stets als Metaprog-Erweiterung; P2996-Reflection nur als spaeterer Drop-in.
- V-6-BAND (Q6): Angebots-Zuschnitt-in-XML nach TEIL V; CMake-Options = optionaler
  Baremetal-Fallback ohne CI, host-seitig; XML+Planer ueberschreibt STETS die Defaults.
- V-6vi (Q7): CLI-Subcommand-Umbau JETZT in V-6 (nicht nach der Frist).
- M1-M3 + Reihenfolge V-0..V-7: Volles GO (73.7).
