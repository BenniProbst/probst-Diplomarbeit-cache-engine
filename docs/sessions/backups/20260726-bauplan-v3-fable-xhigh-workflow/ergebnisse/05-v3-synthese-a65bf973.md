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
