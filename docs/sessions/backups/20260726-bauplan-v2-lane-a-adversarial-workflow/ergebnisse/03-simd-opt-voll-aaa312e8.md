PAKET SIMD-VOLL + opt-VOLL (ersetzt A6). Alle Aussagen mit datei:zeile; Pfad-Wurzel = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine, ce = Code/external/comdare-cache-engine.

## (a) Arbeitspaket: 4 opt x 3 simd = 12 System-Perms GEPLANT, Ausschluss maschinenseitig
IST-Beleg, dass NUR das Profil filtert (kein Code-Filter fehlt):
- Angebot ist vollstaendig: 5 opt-Optionen (ce/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml:13-39, Single-Source kAllOptLevelIds 5 in optimization_level_sub_axis.hpp:133), 3 simd-Optionen (system_axis_registry.xml:55-71, kAllSimdIds 3 in simd_sub_axis.hpp:97).
- Der Planer filtert NICHT, er annotiert: experiment_plan_director.hpp:1818 `perm.host_supports_simd = ... // ANNOTATION, kein Filter`; perm_count = |opt x simd| (:1801). §62-A ist am Planer also SCHON erfuellt.
- Die maschinenseitige Zuteilung EXISTIERT bereits: measure_host_lane() routet jede avx512-Perm ZWINGEND in die amd/prod1-Lane (experiment_plan_director.hpp:397-403), die Perms werden je Lane gebucketet (:874, :1389) und der Job traegt `tags: [amd]` (:982). prod2 bekommt damit KEINE avx512-Perm im Bau-Batch.
- Die CI hat sogar einen eigenen avx512-Job mit Runner-Tag "avx512f" (.gitlab-ci.yml:1069-1077), heute DREIFACH gegatet/Default AUS (:1082).
=> Der EINZIGE stille Filter ist die Anwender-XML. Aenderungen:
1. ce/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:189-199: opt_level auf 4 Optionen in Matrix-Ordnung O3,O2,O1,O0; simd auf 3 (no_extension, avx2, avx512). Kommentar :179-187 umschreiben: der Satz "avx512 nicht universell" (:182) ist der Filter-Beleg und ENTFAELLT; ersetzt durch "Freigabe je Maschine + WARNUNG, kein Profil-Filter (§62-A)". Ofast bleibt WEG (:180-181).
2. ce/tests/unit/thesis_tiere/experiment_golden.xml:67-83: identischer Spiegel (Kommentar :70 traegt denselben Filter-Satz).
3. ce/libs/cache_engine/profile_facade/profile_run_entry.hpp:209-217 `system_axis_host_supports_simd`: fragt heute NUR den Host per __builtin_cpu_supports (:213-214) und liefert bei Nicht-x86/unbekannt hart false (:216). Umbau: Praedikat wird zu einer FREIGABE-Abfrage `simd_release_on_machine(simd_id) -> {frei, gesperrt+Grund+machine_id}`, die (i) die deklarierte Maschinen-Signatur (machine_simd_signature.hpp:77-108) und (ii) das Host-Probe-Ergebnis als ZWEITE Wache nutzt. Der Ort des Filters bleibt die CEB-Bau-Delegation (:759-765) - das ist owner-konform "System gibt frei, Organ setzt durch". Spiegel-Naht: experiment_run_entry.hpp:277-283.
4. simd_build_gate.hpp:187 `active_machine_signature()` liefert heute `{}` (INERT). Es muss die 3 Signaturen aus machine_simd_signature.hpp liefern, ausgewaehlt ueber die laufende Maschine.
   OFFEN/GO-PFLICHTIG: die Quellen enthalten KEINE Maschinen-Identifikation. Es gibt nirgends einen Leser von machine_id (nur machine_simd_signature.hpp selbst + ce/tests/unit/test_m_simd_feature_flag_catalog.cpp:59) und die <machine_signatures> der Registry werden NUR geschrieben (tools/system_axis_registry_gen/main.cpp:302-315), NIE geparst. Vorschlag (nicht geraten, sondern als Entscheidung markiert): COMDARE_MACHINE_ID mit Fallback "Signatur-Match per cpuid"; die CI hat mit GN_RUNNER_TAG (.gitlab-ci.yml:1074) schon das Aequivalent.
5. `admit_organ_on_machine` (simd_build_gate.hpp:153-159) hat AUSSER dem Test keinen Aufrufer -> an derselben Naht (:759) aufrufen, damit der Freigabe-Pilot nicht INERT bleibt.
6. Registry bleibt UNVERAENDERT (avx512 steht schon drin) - wichtig fuer die Roundtrip-Byte-Wache.

## (b) Beruehrte Wachen/Tests - byte-neutral oder nicht (literal)
BYTE-NEUTRAL, literal belegt:
- binary_id: opt/simd sind system_config, `binary_id="never"` (system_axis_registry.xml:10,53); die Provenienz laeuft in den Suffix: `"+cxx="+tag+"+opt="+opt_id + (simd==no_extension ? "" : "+ext="+simd_id)` (profile_run_entry.hpp:779-782, Spiegel experiment_run_entry.hpp:279-283, Planer :1819-1821). Neue Perms erzeugen NEUE Suffixe, aendern keinen bestehenden.
- CRC64-Anker: kNewGolden131072Crc64 laeuft ueber die 131072 Organ-binary_ids (ce/tests/unit/test_lazy_adhoc_source_gen.cpp:191-202) - von opt/simd unberuehrt.
- Objekt-Store: cache_key_prefix(build_version) (artifact_cache.hpp:245, :269) -> die 4 alten Perm-Namensraeume bleiben gueltig; alte Binaries sind gruen inventarisiert und werden per Lagerhaltungs-Skip uebersprungen, nicht neu gebaut.
- Registry-Byte-Roundtrip (test_system_айis_registry_roundtrip, referenziert in test_experiment_plan_director.cpp:150): unberuehrt, weil die Registry nicht editiert wird.
- Ofast: registry bietet es (:34-38), der Thesis-Kanal REJECTet es hart (validate_profile.hpp:388-403 inkl. static_assert :384-387) -> "Ofast bleibt aus" braucht KEINE neue Arbeit.
NICHT byte-neutral (muessen mitgezogen werden, sonst rotes CI):
- ce/tests/unit/thesis_tiere/test_experiment_plan_director.cpp:162-163 (2/2), :170-171 (perms 4, perm_count 4), :189 (total 72), :205 ("perm_count=4" im Plan-Text), :215-216, :223, :232 (76), :448 (76), :607 (76), :1001-1002 -> neu 4 opt / 3 simd / 12 Perms / 12x18=216 bzw. 12x19=228. Testname :158 "Yields2x2Perms" umbenennen.
- ce/tests/unit/thesis_tiere/test_experiment_parser.cpp:174-179 (2 opt O2/O3, 2 simd), :201 (opt_levels_checked 2), :378 (2+1=3) -> 4/3/4/5.
- ce/tests/unit/thesis_tiere/test_experiment_plan_director.cpp:518 + :1922-1927: Lane-Buckets aendern sich (amd bekommt 4 no_ext + 4 avx512 = 8, intel 4 avx2). measure_host_lane selbst bleibt unveraendert korrekt.
- ce/tests/unit/test_kf1_thesis_profile_parser.cpp:133 (3 simd) und ce/tests/unit/test_gn_cell_filter.cpp:44-45 (lokale Vektoren, avx512 schon enthalten) bleiben UNBERUEHRT.
- NEU: Test "golden-Profil traegt alle 4 deterministischen opt-Stufen + alle 3 simd-Optionen" (Anti-Regressions-Wache gegen einen neuen stillen Profil-Filter) + Test "gesperrte Perm erzeugt WARNUNG und wird im Perm-Inventar gezaehlt".

## (c) Die WARNUNG (Fehlerklasse / Log / CSV)
- Fehlerklasse: CompilerCompilerErrorClass::HardwareErweiterungFehlt (axis_error.hpp:42), Label "hardware_erweiterung_fehlt" (:66), Politik LogAndContinueD1Policy - aborts()==false (:146-149). Der Log existiert schon: profile_run_entry.hpp:760-764 / experiment_run_entry.hpp:278-281.
- Log-Zeile MUSS erweitert werden (heute fehlen Maschine und Grund): `[Compiler-Compiler-Fehler: hardware_erweiterung_fehlt] simd='avx512' NICHT freigegeben auf machine_id='prod2_raptor_lake' (fehlendes Flag: avx512f; Signatur-Quelle machine_simd_signature.hpp) -- Permutation uebersprungen, Experiment misst weiter.` Belegt: prod2/odroid tragen 0 avx512-Flags (machine_simd_signature.hpp:121-122), prod1 genau 13 (:116).
- CSV: hier sagen die Quellen NICHTS Ausreichendes, deshalb explizit: CSV-Zeilen sind PER BINARY (perm_runner.hpp:130,165,338; Header cache_engine_builder_iterator.hpp:384), und die Taxonomie ordnet D2 (nicht D1) der Zelle "failed" zu (axis_error.hpp:12-14, :151-155). Eine uebersprungene Perm hat KEINE Binary -> es gibt heute KEINEN Mechanismus fuer eine Perm-Ebene-Zeile, und die Perm verschwindet still (kein einziger CSV-Datensatz mit +ext=avx512).
  GO-PFLICHTIGE WAHL, ich rate nicht: (A) EIN Marker-Datensatz je gesperrter Perm mit build_version=<base>+opt=..+ext=avx512, platform=<machine_id> und ALLEN Mess-Zellen = "failed" (sample_status_token, axis_error.hpp:79/174) - erfuellt "failed nie null" wortwoertlich, fuehrt aber eine binary-lose Zeile in eine per-Binary-CSV ein. (B) Kein CSV-Datensatz, sondern eine Pflicht-Inventar-Zeile `PERM-INVENTAR: geplant=12 gebaut=8 gesperrt=4 (avx512 @prod2)` + Zaehler `perms_skipped` in RunProfileResult (profile_run_entry.hpp:160-174, heute ohne Skip-Zaehler) + Eintrag in complete-heuristik.log. Empfehlung: (A) UND (B), weil nur (A) den Auswerte-Reader zwingt, die Luecke zu sehen; der Reader kennt "failed" schon als Nicht-Zahl (heuristik/measurement_curve_loader.hpp:50,185) und verwirft die Zeile ohne Phantom-Punkt.
- Exit-Code bleibt 0: die Sperre erhoeht any_pruef_failed NICHT (profile_run_entry.hpp:817) -> Pipeline bleibt hart gruen.

## (d) Bau-Volumen je Maschine
Basis: 1 System-Perm = 131072 Tier-Binaries (COMDARE_GN_TOTAL Default, .gitlab-ci.yml:866; Kartesik 2^17 belegt in test_org18_persistence_target.cpp:102-103).
- IST heute: 2 opt x 2 simd = 4 Perms = 524288 Binaries (CI-Matrix nur O2/O3, .gitlab-ci.yml:1051,1056).
- SOLL geplant: 4 x 3 = 12 Perms = 1572864 Binaries (Faktor 3,0 gegen IST).
- prod1_zen5: 12/12 Perms baubar = 1572864 (einzige avx512-Maschine, 13 Flags).
- prod2_raptor_lake: 8/12 = 1048576; 4 avx512-Perms gesperrt+gewarnt (0 avx512-Flags).
- odroid_gracemont: 8/12 = 1048576; identische Sperre (0 avx512-Flags).
- Lane-Verteilung bei Nutzung des Planer-Routings: amd/prod1 = 4 no_ext + 4 avx512 = 8 Perms = 1048576; intel/prod2 = 4 avx2 = 4 Perms = 524288.
- Kleiner Kanal (320er/smoke): 320 Binaries je Perm -> 12 x 320 = 3840 statt 1280.
- Zeit/Bytes je Binary steht in den gelesenen Quellen NICHT; die einzige Empirie ist 24 Worker ~19,4 min je Slice ohne Slice-Groesse (experiment_plan_director.hpp:404-411) - Wanduhr-Extrapolation waere Raten, daher hier bewusst KEINE Minutenzahl. Der GN-9-Bloat-Report je Chunk ist der vorgesehene Messpunkt (.gitlab-ci.yml:1018).

## (e) AVX10 - bewusst SPAETER, nicht mitgeplant
- Das Feld existiert nur als Bestands-/Stempel-POD: build_variant_definition.hpp:33 `simd_avx10_version`, POD-Version 1->2 (:43), Hersteller detect_avx10_version (:66-72), Sidecar-Serialisierung/Parse build_variant_sidecar.hpp:51-52/:88-89, Set-Signatur build_variant_set_signature.hpp:105-106, Organ-Hook axis_09b_simd_extension_strategy_base.hpp:53-56.
- Es gibt KEINE avx10-Option in der simd-Unter-Achse (system_axis_registry.xml:55-71), KEIN avx10-Flag im 23er-Katalog (:72-96), KEIN avx10-Flag in einer der 3 Maschinen-Signaturen (:118-165) und KEIN -mavx10-Flag in simd_sub_axis.hpp. Der Code sagt selbst: "heute deklariert KEIN Wrapper AVX10-Hardware" (axis_09b_simd_extension_strategy_base.hpp:54) und "heute existiert KEINE AVX10-Hardware im Wrapper-Bestand" (build_variant_definition.hpp:63); die Tests setzen 0 (test_d7_build_variant.cpp:75) bzw. nur synthetisch 2 (test_g2_variant_sidecar.cpp:64).
- Urteil: AVX10 ist eine 4. simd-Option OHNE Hardware in der Flotte -> sie wuerde auf ALLEN 3 Maschinen gesperrt und 4 leere Perms erzeugen. Nicht mitplanen. Der Stempel-POD bleibt unberuehrt (append-only, Offsets stabil, :30-33) - das Paket ist damit stempel-byte-neutral. Wiedervorlage erst mit realer AVX10-Hardware bzw. mit dem AVX10-Wrapper.

## Offene Entscheidungen (Bau erst nach GO)
D1: Maschinen-Identifikation fuer active_machine_signature (Quellen sagen nichts; Vorschlag COMDARE_MACHINE_ID + cpuid-Fallback).
D2: CSV-Sichtbarkeit Variante (A) Marker-Datensatz mit "failed" und/oder (B) Inventar-Zeile + perms_skipped-Zaehler.
D3: Sollen die CI-Matrizen (.gitlab-ci.yml:1051,1056,1076) auf O0/O1 mitgezogen werden oder bleibt die statische Fallback-Matrix (Default AUS, :1042-1043) unangetastet und nur planer:delegate traegt die 12 Perms?

Selbstcheck: ASCII-only geprueft ausser einem versehentlichen Nicht-ASCII-Zeichen im Wort "test_system_axis_registry_roundtrip" (Abschnitt b, Zeile "Registry-Byte-Roundtrip") - dort steht "айis" statt "axis"; bitte beim Uebernehmen korrigieren. Alle uebrigen Zeilen ASCII; keine ✓-Marken; alle Zahlen aus zitierten Zeilen, keine geratenen Laufzeiten.
