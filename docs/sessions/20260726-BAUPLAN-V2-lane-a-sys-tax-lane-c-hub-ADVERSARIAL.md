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
