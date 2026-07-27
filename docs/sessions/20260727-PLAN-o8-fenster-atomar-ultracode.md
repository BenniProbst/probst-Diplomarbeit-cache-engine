# 20260727-PLAN — O-8-FENSTER: Atomarer Ausfuehrungsplan (ultracode-Synthese)

Status: PLAN, Rev. 3 (27.07., Verify-2-Pass eingearbeitet: 17 Befunde — 3 MAJOR, Rest MINOR,
mehrere Doubletten desselben Kerns — alle nachverifiziert uebernommen, 0 verworfen; Abschnitt 11.
Rev. 2: adversarialer Pass, 20 Befunde). Wartet auf Klaerung der offenen Punkte (Abschnitt 10;
OP-1/OP-5 = OWNER-Entscheide, Rest Manager) und Fenster-Start-Freigabe.
Autoritaet: VORAB-GO Ledger §72 (Uebergabe 7e) — "Volles GO fuer alle Punkte"; Ausfuehrung als EIN
atomares Fenster durch EINEN Agenten allein. §74: Pipelines hart gruen, nichts unterbrechen.
Quellen-Hierarchie bei Widerspruch: Owner-Wortlaut > Ledger > Bauplan v2/v3 > Code-Ist.
HEAD-Pins (verifiziert 27.07. frueh): ce development 7dd41b18, super development 40ee7349.
RE-PIN-PFLICHT (Verify-2, MAJOR): der super-HEAD hat den Plan-Pin BEREITS ueberholt (0b8b81ca,
reiner docs/backups-Commit auf 40ee7349, verifiziert 27.07.), und die Uebergabe sequenziert das
Fenster NACH 7a-7d (u.a. Impl-V6 Paket-B = naechster ce-Push, Infra-2b, 2c-Paket; UEBERGABE:121-135)
— vor Fenster-Start gilt zwingend das RE-PIN-PROTOKOLL (Vorbedingung 4a): Pins, Basiszahlen und
Anker werden am Neu-Pin nachverifiziert; ein starres Gate auf 7dd41b18/40ee7349 waere unerfuellbar.

Quellen: Ledger §69-§75; docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md
(TEIL I-V); docs/sessions/20260726-SESSION-od-antworten-load-framework-mess-realm-target-isa-komplex.md;
docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md; Code-Ist an den HEAD-Pins (Anker punktuell
nachverifiziert: system_axis_order.hpp:42-48/:87-96, axis.hpp:17-31, simd_build_gate.hpp:362/:381,
source_catalog.hpp:190, ext/CMakeLists.txt:17-202, experiment_schema.xsd:36/:113-127).

Pfad-Kuerzel: `ce` = Code/external/comdare-cache-engine, `super` = Repo-Wurzel.

---

## 0. Rahmen, Kontext-Fakten, Byte-Klassen

Kontext-Fakten (bindend):
- golden N=2^17=131072; ABI-7; 18 Organ-Achsen; ctest braucht `-DCOMDARE_V32_ENABLE=ON` in BEIDEN Baeumen.
  ctest-Basiszahlen am ALT-Pin sind JE BAUM verschieden (per `ctest -N` verifiziert 27.07.):
  ce-standalone build-ninja-s4 = 316 Tests, super Code/build-test (V32=ON) = 453 Tests.
  "316/316 in beiden Baeumen" ist FALSCH und darf nirgends als Gate stehen. Die Zahlen 316/453
  gelten NUR am Alt-Pin — nach Re-Pin (Vorbedingung 4a) werden sie per `ctest -N` NEU erhoben
  und die Neu-Werte sind die bindende Basis fuer Schritt 0/13.
- 7 Byte-Wachen: golden_fullpilot_320_binary_ids.txt + _abi4/_abi5/_abi6.txt, system_axis_registry.xml,
  permutation_axes.xml, m3v2_study.profile.xml.
- AxisKind erhaelt ADDITIV `measurement_meta_meta` (RF-1/§70.1); `system_meta_meta` bleibt Kategorie-Name
  der System-Seite.
- target_isa = Komplex-Achse IN SICH (feste Glieder RAM-Frequenz+CAS+CPU-Fabrikation; je Maschine via
  XML `<machines>` deklariert; NUR Stempel-Identitaet; Hostname=Instanz-Lookup, Tupel=Klassen-Identitaet).
- RF-7: Komplex-Achse = EIN Feld im Haupt-Achsen-Array ihres Typs; je Typ EINE Array-Stempel-Zeile.
- §70.6: System-Achsen tragen im Stempel die BUILD-Version als Stempel-Variable-Version.
- machine_identity.hpp existiert (O-4, kDeclaredMachines, header-only); simd_build_gate.hpp ist C-3a-scharf.
- ASCII-only in Code-Kommentaren (`§` NICHT in Code; in Doku erlaubt).

Byte-Klassen je Schritt:
- **byte-neutral**: aendert keine erzeugten Bytes (Tier-Binaries, generierte Header, Golden-Dateien);
  Beweis per Byte-Diff/Wachen-Lauf.
- **byte-tragend**: aendert erzeugte Bytes bzw. Identitaets-Strings, aber keine Golden-ANKER-Dateien.
- **golden-veraendernd**: bricht Golden-String-/CRC-Anker; Neuanker NUR als Werkzeug-Output (§72-Auflage:
  Fenster-Pflicht-Checkliste per grep, 2-Pass, literale Neuanker als Werkzeug-Output).

Beweis-Regime im Fenster: Golden-String-Tests DUERFEN zwischen Schritt 3 und Schritt 12 rot sein —
jede neue Rot-Stelle wird sofort in einer Fenster-Delta-Liste notiert (Test, Literal alt, Grund).
Je Schritt gilt Compile-/grep-/Generator-Beweis; Voll-Gruen (0 failed je Baum, Basiszahlen s.o.) ist
erst nach Schritt 12 Pflicht.
Kein Haken ohne literale Ausgabe.

---

## 1. Vorbedingungen (Gate VOR Schritt 0, Manager bestaetigt)

1. Byte-neutrale Welle: am ce-Pin 7dd41b18 VERIFIZIERT NUR TEILWEISE gelandet (Adversarial-Befund,
   code-bestaetigt): (a) Das INERTE version-Feld in measurement_framework_registry.hpp existiert NICHT
   (case-insensitive grep "version" = 0 Treffer in der 74-Zeilen-Datei; MeasurementFrameworkInfo traegt
   nur framework/id/name) — Bauplan IV.4 Schritt 1 ist NICHT erfuellt; der Nachbau ist PFLICHT und als
   Schritt 0A eingeplant (keine Eventualitaet mehr, OP-9 damit halbiert). (b) Der XSD/Parser-O-2-Basisteil
   IST gelandet (experiment_schema.xsd O-2-Block ab :339ff, Elemente numa_node :379 / page :395;
   xml_config_parser.cpp numa_node-/page-Leser :129-131). (c) IV.6-Doc-Vermerk-Schicht: Rest-Frage OP-9.
2. TEIL-V-Merge-Plan eingearbeitet (§72-Auflage; V-0 Doku-Paket gelandet).
3. RF-1..RF-3-GOs liegen vor (RF-1 = §70.1 VOLLES GO ist belegt; RF-2/RF-3 pruefen).
4. Beide Baeume clean bzgl. GETRACKTER Aenderungen: `git -C <tree> status --porcelain
   --untracked-files=no` leer (NICHT das ungefilterte porcelain — der super-Baum traegt legitime
   untracked Pfade, verifiziert 27.07.: `?? Code/measure_out_d03/` = Mess-Output, darf per Doktrin
   NIE geloescht werden, sowie dieses Plan-Doc bis zu seinem Commit; die erlaubten untracked Pfade
   werden beim Manager-Gate NAMENTLICH gelistet, jeder NICHT gelistete untracked Pfad = klaeren,
   NIEMALS Messdaten entfernen, um ein Gate "sauber" zu machen). `git -C <tree> rev-parse HEAD`
   == Pin ODER dokumentierter NACHFOLGE-Pin gemaess Re-Pin-Protokoll 4a. Kein anderer Agent
   schreibt fuer die Fensterdauer (Impl-V6, CiCheck288b und alle weiteren pausieren schreibend;
   Working-Tree-Hoheit beim Fenster-Agenten).
4a. RE-PIN-PROTOKOLL (PFLICHT-Vorlauf unmittelbar vor Fenster-Start; Grund: die Uebergabe
   sequenziert das Fenster NACH 7a-7d — Impl-V6 Paket-B = naechster ce-Push, Infra-2b, 2c-Paket —
   und super-HEAD hat den Plan-Pin bereits ueberholt (0b8b81ca, docs/backups-only auf 40ee7349);
   zudem MUESSEN die OP-1..OP-11-Klaerungen und dieses Plan-Doc vor Fenster-Start committet sein
   (Doku-Policy), womit super-HEAD zwingend weiterlaeuft):
   (i) Neue HEADs beider Baeume literal festhalten (`rev-parse`) und als Fenster-Pins dokumentieren.
   (ii) Diff Alt-Pin -> Neu-Pin je Baum sichten und klassifizieren: beruehrt er Fenster-Ziel-Dateien
   oder Plan-Anker, ALLE betroffenen datei:zeile-Anker dieses Plans nachverifizieren (analog
   NACH-Pruefung 6.13); sonst Vermerk "nur docs/- bzw. fensterfremde Pfade" mit diff-stat literal.
   (iii) Basiszahlen NEU erheben (`ctest -N` je Baum; 316/453 gelten nur am Alt-Pin — landet z.B.
   Paket B oder 2c vorher, sind die Ist-Zahlen die neue bindende Basis fuer Schritt 0/13; die
   Schritt-13-Klausel "Abweichung nur durch Schritt-11-Wachen" bezieht sich auf DIESE Neu-Basis,
   legitime Vor-Fenster-Deltas sind damit KEIN Widerspruch).
   (iv) D2.10-PASS-1-grep (Schritt 0e) laeuft ohnehin am Fenster-Start und ankert automatisch am
   Neu-Pin. Ohne dokumentiertes 4a-Protokoll KEIN Fenster-Start.
5. Kein laufender CI-Mess-/Golden-Lauf wird unterbrochen (§74); Fenster-Start erst bei freiem Slot.

---

## 2. TABU-Liste (gilt AUCH im Fenster, NACH-Pruefung 6.12)

Unveraendert zu bleiben haben: permutation_axes.xml; golden_fullpilot_320_binary_ids.txt (und die
Archiv-Zwillinge _abi4/_abi5/_abi6); m3v2_study.profile.xml (Byte-Wache — im Fenster NICHT anfassen,
kein `<machines>`-Block dort); kV3AxisSchema (observable_tier.hpp:69); GenusBindingTraits
(anatomy_base.hpp:74); POD-sizeof (build_variant_definition.hpp); ABI-Major (bleibt 7);
conformance-Oracle; saemtliche Messdaten/CSV; beide .gitlab-ci.yml (Infra-Gebiet, siehe Nicht-Ziele).

---

## 3. SCHRITT-LISTE (zwingende Reihenfolge, 16 Schritte: 0, 0A, 1-14)

### Schritt 0 — Fenster-Eintritt: Freeze, Pins, Baseline (2-Pass-Grundlage)
- Ziel-Dateien: keine Edits (nur Lesen/Bauen/Sichern).
- Aenderung: (a) Pins (bzw. Nachfolge-Pins per Re-Pin-Protokoll 4a) und Clean-State beweisen
  (getrackte Aenderungen leer, erlaubte untracked Pfade namentlich gelistet); (b) lokale Start-Tags
  `o8-fenster-start` in BEIDEN
  Baeumen setzen; (c) Baseline-Bau ce-standalone UND super mit `-DCOMDARE_V32_ENABLE=ON` nach
  Standalone-Referenz, ctest JE BAUM 0 failed als Eintritts-Beweis (Basiszahlen am Alt-Pin:
  ce 316/316, super 453/453 — NICHT "316 in beiden"; nach Re-Pin gelten die 4a(iii)-Neu-Zahlen);
  (d) Baseline-Sicherungen in den Scratchpad:
  `generated/axes/alloc/axis_06_allocator_flags.hpp` aus BEIDEN Baeumen (V-1-G1-Referenz),
  golden/320-Baum-Dump, Kopien der 7 Byte-Wachen-Dateien, Literal `kNewGolden131072Crc64 =
  0x56F1B721C72DC10E` (ce/libs/cache_engine/profile_facade/source_catalog.hpp:190);
  (e) D2.10-grep PASS 1 (Ist-Literale sichern):
  `grep -RIn -E 'system_axes_version_suffix|cache_key_prefix|system_stamp_line|compose_organ_stamp_line' ce/libs ce/tools ce/tests`
  plus die A3-Sperrmengen-Tests (test_experiment_plan_director.cpp:113-114,
  test_striktheit_axis_dach_guard.cpp:17/:117, test_m_w12:265/:271-273/:336-340 (kOrgan, Ende :340
  "// 17 Haupt-Achsen")/:341-342 (kSystem-Literal — ANKER-KORREKTUR Verify-2: das alte Etikett
  ":339-340 = kSystem" war falsch, :339-340 ist das ENDE von kOrgan)/:343-344 (kMeasure),
  test_g1_binary_version_stamp.cpp:64/:98, test_s1_cache_key_prefix.cpp:36/:69, test_s2/s5/w11/g3,
  g1_binary_version_stamp.hpp) — Output als Datei ablegen. ACHTUNG: die vier D2.10-grep-Muster
  treffen das rohe kSystem-Literal :341-342 NICHT (kein Muster-Token im String) — fuer diese Zeilen
  ist die explizite Liste hier der EINZIGE PASS-1-Anker; Zeilen falsch gelistet = Delta-Buchung
  verrutscht.
- Byte-Klasse: byte-neutral.
- Beweis: rev-parse-Ausgaben == Pins; ctest-Summary literal je Baum (ce `316/316`, super `453/453`);
  Dateiliste der Baseline-Sicherungen.

### Schritt 0A — PFLICHT-Nachzug Vor-Fenster-Welle: INERTES version-Feld (Bauplan IV.4 Schritt 1)
- Ziel-Dateien: ce/libs/cache_engine/include/cache_engine/measurement/measurement_framework_registry.hpp
  (MeasurementFrameworkInfo traegt am Pin NUR framework/id/name — verifiziert 0 grep-Treffer "version");
  Muster: MeasurementToolingInfo.version (measurement_tooling_registry.hpp:38-39).
- Aenderung: version-Feld ADDITIV und INERT anlegen (load_framework=v1.0.0 als Wert vorbereitet, KEIN
  Emissions-Konsument — Scharfschaltung erst Schritt 9). Grund: Vorbedingung 1(a) ist am Pin NICHT
  erfuellt; ohne dieses Feld hat Schritt 9 keine Basis.
- Byte-Klasse: byte-neutral (inertes Feld, kein Konsument).
- Beweis: Bau; `grep -n "version" .../measurement_framework_registry.hpp` -> genau die neue
  Deklarationsstelle; Stempel-/Golden-Tests unveraendert gruen (byte-neutral belegt).

### Schritt 1 — V-1 Vendor-Provisioning-Entkopplung (BEIDE Baeume; einziges Byte-Paket des Retires)
- Ziel-Dateien: ce/ext/CMakeLists.txt:17-19, :56-57, :123, :158, :179, :202 (alle
  COMDARE_VENDOR_*-Option-Defaults); ce/CMakeLists.txt:570-604 (add_subdirectory(ext) :576-578,
  link_libraries vendor_mimalloc :595-597, snmalloc-Block); super/Code/CMakeLists.txt (neuer `set(... ON)`).
- Aenderung: ALLE COMDARE_VENDOR_*-Defaults von `${COMDARE_BUILD_PERMUTATIONS}` auf den EIGENEN Schalter
  `COMDARE_PROVISION_VENDOR_ALLOCATORS` umhaengen (Name: Vorschlag Bauplan TEIL V, siehe OP-8);
  Effektiv-Werte identisch halten: super ON, ce-standalone OFF. add_subdirectory(ext)- und
  link_libraries-Bloecke auf den neuen Schalter. USE-Baking (ce/CMakeLists.txt:571-588) UNVERAENDERT.
- Byte-Klasse: byte-tragend klassifiziert, byte-neutral zu BEWEISEN (Bauplan TEIL V V-1, woertlich).
- CMAKE-CACHE-FALLE (Adversarial-Befund, verifiziert): alle sechs COMDARE_VENDOR_*-`option()`-Defaults
  (ext/CMakeLists.txt:18/:56/:123/:158/:179/:202, Default `${COMDARE_BUILD_PERMUTATIONS}`) wirken NUR
  beim ERSTEN Configure. Ein Reconfigure auf den EXISTIERENDEN Build-Verzeichnissen (build-ninja-s4,
  Code/build-test) behaelt die gecachten VENDOR-Werte und MASKIERT eine falsch verdrahtete neue
  Schalter-Kette vollstaendig — der G1-Byte-Diff bestuende dann trivial (falsches Gruen).
- Beweis (Gates G1/G2): NUR gueltig mit FRISCHEN Configure-Verzeichnissen (neues Build-Dir je Baum ODER
  vorher alle COMDARE_VENDOR_*/COMDARE_PROVISION_*-Cache-Eintraege geloescht, literal belegt); dann
  `diff` (leer) von `generated/axes/alloc/axis_06_allocator_flags.hpp` gegen die Schritt-0-Baseline —
  im super-Tree UND ce-standalone; voller lokaler Bau beider Baeume ohne Fehler (Referenz gegen
  falsches Gruen).

### Schritt 2 — AxisKind additiv: `measurement_meta_meta`
- Ziel-Dateien: ce/libs/cache_engine/topics/axis.hpp:17-31 (Enum, 4 Werte; Kommentar :29 "RF-1 offen").
- Aenderung: Enum-Wert `measurement_meta_meta` ADDITIV anfuegen (Mess-Realm-Diskriminator, Planer-Seite);
  Kommentar :29 von "offen (RF-1)" auf "entschieden §70.1 (RF-1 VOLLES GO)" nachziehen;
  `system_meta_meta` bleibt unveraendert Kategorie-Name der System-Seite. Kein Konsument in diesem Schritt.
- Byte-Klasse: byte-neutral (rein additiv, keine Achse gibt den Wert bis Schritt 4 zurueck).
- Beweis: Bau der Ziel-Targets; `grep -n "measurement_meta_meta" ce/libs/cache_engine/topics/axis.hpp`
  (genau 1 Deklarations-Treffer); ctest-Lauf der Achsen-Dach-Tests weiter gruen.

### Schritt 3 — A2: external_utils-Rename (Hub-Zuschnitt §69.1; beruehrt BEIDE Baeume)
- Ziel-Dateien (Sperrmatrix, exklusiv A2 bzw. Lane-A-Besitz desselben Agenten):
  ce/.../measurement/extension_hardware_family_axis.hpp (Achsen-Label + Datei),
  ce/.../measurement/simd_sub_axis.hpp:37-38 (Parent-Label); ce/.../abi/system_axis_order.hpp:44
  (Eintrag "extension_hardware" -> "external_utils") gemeinsam mit dem Zwilling
  system_axis_code_versions.hpp (Drift-Wache :87-90 zwingt beide); Kommentar-Nachzug
  hardware_meta_meta_axis.hpp:4-11. ZUSAETZLICH (Adversarial-Befund, Live-Treffer am Pin: 143 Treffer
  in 29 ce-Dateien): Parse-Token xml_config_parser.cpp:114 (+hpp-Verweise); Profil-XMLs
  all_axes_golden.profile.xml + cacheline_study.profile.xml (+ SCHEMA.md); ce-Test-/Golden-XMLs
  (tests/unit/thesis_tiere/experiment_golden.xml, experiment_golden_kern.xml) + betroffene Tests;
  ce/tools/system_axis_registry_gen/main.cpp (Label kommt aus axis_label(), Emitter-Tabelle :382) MIT
  Regeneration von system_axis_registry.xml als WERKZEUG-OUTPUT im SELBEN Commit (Roundtrip-Gate
  registry_roundtrip.cmake compare_files = FATAL; Bauplan P5: "XML NIE handeditieren, Regen im SELBEN
  Commit"); SUPER-Baum: Code/test_data_xml/experiment_schema.xsd:314 (das EINZIGE xs:element
  name="extension_hardware") + :260 (Kommentar-Zeile "Haupt-Achse 'extension_hardware' (6., Q2
  Option C)" — Vokabular-Nachzug, KEIN Element; Etikett-Korrektur Verify-2, das bindende
  0-Treffer-grep unten faengt beide Stellen) + Code/test_data_xml/experiment_golden.xml +
  experiment_golden_kern.xml
  (das XML-Vokabular lebt AUCH im super — Abschnitt 5 entsprechend korrigiert).
  Deprecated-Insel extension_hardware_system_axis.hpp bleibt UNANGEFASST (Historie;
  §75-Aufraeumpass-Kandidat).
- Aenderung: Rename der Haupt-Achse auf `external_utils`; Hub traegt NUR System-Meta-Metas (SIMD/AVX,
  externe HW, GPU/FPGA/NPU; §69.1); sse4.2/neon werden per Folge-Paket V-5a NACH dem Fenster als
  Zellen der eigenen System-Meta-Meta-Hauptachse gemergt (§73.2/Q1 owner-entschieden; KEIN
  Ist-Zustand: am Pin 0 grep-Treffer sse4/neon in simd_sub_axis.hpp — Formulierungs-Korrektur
  Verify-2, siehe Abschnitt 9). Include-/Verweis-Nachzug ueber alle Konsumenten.
- Byte-Klasse: golden-veraendernd. ACHTUNG: die Byte-Wache system_axis_registry.xml (Matrix-Zeile 5)
  bricht bereits IN DIESEM SCHRITT (XML:53 axis id="extension_hardware", :55 sub_axis
  parent="extension_hardware"; Generator emittiert das Label aus SimdExtensionHardwareFamily::
  axis_label(), main.cpp:382) — Delta-Listen-Eintrag fuer Wache 5 gehoert zu DIESEM Schritt, nicht
  erst zu Schritt 4/6.
- Beweis: voller Bau der betroffenen Targets; Generator-Regen + Roundtrip-Gate gruen im selben Commit;
  `grep -RIn "extension_hardware" ce/libs ce/tools ce/tests` -> 0 LIVE-Treffer (Identifier, Parse-Token,
  XML-Vokabular); Rest-Treffer AUSSCHLIESSLICH deprecated-Insel + Doku-/Historien-Kommentare, jede
  Rest-Datei einzeln in der Delta-Liste erklaert (die alte Erwartung "nur Doku-/Historien-Kommentare"
  ohne Datei-Liste war mit dem alten Ziel-Datei-Umfang unerreichbar);
  `grep -RIn "extension_hardware" super/Code/test_data_xml` -> 0 Live-Treffer;
  Delta-Liste: erwartete Rot-Tests notiert (test_m_w12 u.a.) + Wache-5-Bruch.

### Schritt 4 — A3-Kern + K1-Umzug (EIN atomarer Commit; IV.2.1-Auflage "SELBER Commit")
- Ziel-Dateien: ce/.../abi/system_axis_order.hpp:37/:42-48/:87-96;
  ce/.../abi/system_axis_code_versions.hpp:28/:32-38/:50;
  ce/.../measurement/system_axis_registry.xml:114-117 (load_framework-Block) + Kopf (5 Achsen);
  ce/tools/system_axis_registry_gen/main.cpp:340-357 (emit_system_axis_load_framework — der
  load_framework-Emitter; ANKER-KORREKTUR: der alte Anker :284-296 zeigte auf das ENDE des
  extension_hardware-Emitters und den target_isa-Emitter :293), :380-386 (Emitter-Tabelle),
  :112-121/:477-495 (Netze ziehen ueber kSystemAxisOrderCount mit); KEIN Literal-Edit "5"->"3":
  NETZ 3 zieht die Anzahl automatisch aus kSystemAxisOrderCount (main.cpp:493-495, "in A3 zieht die
  Zahl automatisch mit" — der frueher behauptete Edit an :334 war gegenstandslos, :334 ist eine
  scheduling-sub_dim-Zeile);
  ce/tools/measurement_axis_registry_gen/main.cpp:35 (include) + :172-173
  (`source="system:load_framework"` -> `"measurement:load_framework"`);
  ce/.../measurement/load_framework_system_axis.hpp:10-19/:31-45/:54 (Umzug);
  ce/.../measurement/measurement_axis_registry.xml (NEUER Top-Level-Block, analog measurement_category :7
  / collector :26; dim workload :46 mit source="measurement:load_framework");
  ce/.../abi/anatomy_version_stamp.hpp:71-81 (system_stamp_line-Schleife);
  NEU (Verify-2, Edit-Scope-Ergaenzung): ein NEUER Achsen-Typ-Header fuer `operating_system`
  (+ Emitter-Funktion + kSystemAxisCodeVersions-Eintrag). Grund: die Emitter-Tabelle
  kSystemAxisEmitters (main.cpp:380-386) ist TYP-getrieben — Eintraege sind axis_label() REALER
  CRTP-Achsen-Typen (Muster X86_64TargetIsa); am Pin existiert "operating_system" AUSSCHLIESSLICH
  als String in system_axis_order.hpp:19 (Kommentar) und :95 (static_assert) — Gegenprobe: grep
  ueber ce/libs+tools+tests = genau 1 Datei, KEIN Achsen-Typ. Ohne neuen Typ-Header ist der
  Ordnungs-/Tabellen-Eintritt nicht baubar. Header-Name + Auspraegungs-/Versions-KATALOG bei der
  OP-10-Klaerung MIT fixieren (OP-10 fixierte bisher nur den Katalog, nicht den Edit-Scope).
- Aenderung: (a) kSystemAxisOrder -> DREI Haupt-Achsen `{target_isa, operating_system, external_utils}`,
  kCount 5->3 (D2.5 bleibt gueltig, nur Umzugs-ZIEL = Mess-Realm, §69.1); neue Haupt-Achse
  `operating_system` tritt in die Ordnung ein (static_assert :95 invertiert sich, :94 Index-Selbsttest
  nachziehen); (b) load_framework verlaesst die System-Welt ERSATZLOS (Owner R-G verbatim:
  "load_framework wird rein den Mess-Achsen-Typen als weitere Meta-Meta-Hauptachse zugeordnet") und wird
  Mess-Realm-Meta-Meta-HAUPT-Achse K1 mit AxisKind `measurement_meta_meta` (aus Schritt 2); Planer
  generiert Loads und DELEGIERT ans CEB-Interface; C-1'-Hub instanziiert sie NICHT
  (hardware_meta_meta_axis.hpp:4-11 bleibt); (c) Stempel-Arithmetik: system_stamp_line traegt GENAU DREI
  Segmente (In-Place: -3/+1); (d) scheduling und compiler verlassen die Haupt-Ordnung: scheduling ->
  Schritt 6 (sub_axis am target_isa-Wrapper), compiler -> aeussere Komplex-Achse (IV.2.7/O-1r; siehe OP-5);
  (e) Abgrenzung IV.2.5: build_system_axis_levels/registry_to_axis_levels.hpp:123 NICHT anfassen
  (die 5er-Menge dort ist NICHT kSystemAxisOrder).
- Byte-Klasse: golden-veraendernd (system_axis_registry.xml = Byte-Wache; Stempel-Strings).
- Beweis: Generator laufen lassen, neue system_axis_registry.xml als WERKZEUG-OUTPUT einchecken (kein
  Hand-Edit); tragend sind Generator-Output + Ordnungs-Wachen (Netze main.cpp:112-121/:389-398/:477-495
  gruen; XML-Blockfolge == kSystemAxisOrder literal) — eine `grep -c "system_config"`-Zeilen-Zaehlung
  ist als Beweis UNTAUGLICH (zaehlt Zeilen, nicht Vorkommen; Soll-Wert haengt an der offenen
  axis_kind-Frage fuer external_utils/operating_system, OP-10) und entfaellt;
  `grep -RIn "load_framework" ce/libs/cache_engine/include/cache_engine/abi` -> 0 Live-Treffer;
  `grep -n "system:load_framework" ce/tools ce/libs -R` -> 0; Bau gruen; Delta-Liste fortgeschrieben.

### Schritt 5 — O-4b: `<machines>`-XSD + Parser (Deklarationskanal der target_isa-Glieder)
- Ziel-Dateien: super/Code/test_data_xml/experiment_schema.xsd:36 (machines minOccurs=0), :113-127
  (MachinesType: heute id/cpu_fabrication/ram_pair required, hostname_hint optional);
  ce/libs/common/serialization/xml_config_parser.hpp:360-365 (ExperimentMachine) + .cpp:529-538;
  additiver Anschluss an ce/.../measurement/machine_identity.hpp:125-131 (DeclaredMachine),
  :158-162 (kDeclaredMachines, size==2-Wache :321), :167 (resolve_machine_by_properties).
- Aenderung: MachinesType ADDITIV um die target_isa-Glieder erweitern (RAM-Frequenz, CAS,
  CPU-Fabrikation; Attribut-Schnitt/Einheiten siehe OP-4; ram_pair bleibt — Doku/Additiv-Doktrin);
  Parser-Struktur additiv nachziehen; Abgleich XML-Deklaration gegen kDeclaredMachines
  (Tupel=Klassen-Identitaet, Hostname=NUR Instanz-Lookup; RF-6: "je Maschine deklariert und je OS und
  ISA ermittelt"; exakter Eigenschafts-Match => Achse WIEDERVERWENDBAR ueber formal verschiedene
  Maschinentypen). Wirkung ausschliesslich Stempel-Identitaet, KEINE Laufzeit-/Dispatch-Wirkung.
  m3v2_study.profile.xml NICHT anfassen (TABU/Byte-Wache).
- Byte-Klasse: byte-neutral (additives Schema + Parser, kein Byte-Konsument in diesem Schritt).
- Beweis: XSD-Validierung eines Beispiel-XML mit und ohne `<machines>`-Glieder (beides gueltig,
  Altbestand unveraendert gueltig); Bau; `git diff --stat` zeigt m3v2_study.profile.xml NICHT;
  Byte-Diff m3v2_study.profile.xml gegen Baseline leer.

### Schritt 6 — target_isa-Komplex-Wrapper (IV.2.2) + C-3c-Patch (PATCH-AN-A3)
- Ziel-Dateien: ce/.../measurement/target_isa_system_axis.hpp:33-49/:64/:73 (Besitzer A3, STRENG
  SERIELL); system_axis_registry.xml (target_isa-Block :98, scheduling-Block heute Top-Level :102-113;
  Muster fixed_enum_tuple :104-112); ce/.../measurement/machine_simd_signature.hpp:31-48 (Muster
  MachineSimdSignature); ce/.../profile_facade/profile_run_entry.hpp:209-216 (C-3c: ISA-Zulassung fragt
  heute den HOST); ce/.../measurement/simd_sub_axis.hpp:37-38 (simd haengt unter external_utils).
- Aenderung: (a) `TargetIsaComplexAxis` als CRTP-Komplex-Wrapper IN SICH: feste constexpr-Glieder
  ram_frequency/cas_latency/cpu_fabrication je benannter Auspraegung (Owner OD-2 verbatim: "feste
  Rekombination aus RAM-Frequenz und CAS und CPU-Fabrikation als 'neue statische
  Komplex-Haupt-System-Achse'"; "Also nichts von deinen Vorschlaegen" — RT-Unter-Achsen-Loesung ist
  AUSGESCHLOSSEN); Glieder-Werte kommen aus der `<machines>`-Deklaration (Schritt 5) via
  kDeclaredMachines; (b) die zuvor vereinbarten Unter-System-Achsen scheduling, numa_node, page haengen
  als sub_axis mit parent="target_isa" am Wrapper (D2.6-Namen numa_node+page, KEIN *_topology);
  (c) RF-7: der Komplex ist EIN Feld im System-Haupt-Achsen-Array, je Achsen-Typ EINE Array-Stempel-Zeile
  — KEINE Klammer-Explosion je Glied; (d) Wirkung NUR Stempel-Identitaet (RF-6): gleiche Kombination =>
  gleicher Stempel; +target=-Suffix-Logik (profile_run_facade.cpp:388-391, nur bei !native) bleibt
  semantisch erhalten; (e) rekursive Wrappung durch die AEUSSERE System-Komplex-Achse (IV.2.7/O-1r:
  CompoundSystemAxis+SubAxisGroup; compiler+opt_level+atomic128 als Unter-Achsen-GRUPPE dort, NICHT an
  target_isa) — Umfang im Fenster siehe OP-5; (f) C-3c als PATCH-AN-A3: ISA-Zulassung
  (profile_run_entry.hpp:209-216) von Host-Probe auf die deklarierte Klassen-Identitaet ausrichten;
  KEIN eigener separater Edit-Gang an target_isa_system_axis.hpp (Bauplan TEIL I P7; Volltext OP-6).
- Byte-Klasse: golden-veraendernd (Registry-Struktur + Stempel-Identitaet).
- Beweis: Generator-Lauf -> neue system_axis_registry.xml (Werkzeug-Output); static_asserts des
  Wrappers gruen (Glieder-Tupel constexpr, Feld-Zaehlung == 1 im Haupt-Array); Bau; Delta-Liste.

### Schritt 7 — A8.2: Organ-Stempel-Zeile + Meta-Meta-Array (Soll-Menge: OP-11 VOR Fenster-Start)
- Ziel-Dateien: ce/.../abi/anatomy_version_stamp.hpp:42-60 (handgeschriebenes Array
  `std::array<AxisVersionEntry, 17>` OHNE persistence_target = Fix-Stelle; FALLE:
  organ_stamp_line<Comp>() :32-37 ist MOCK-ONLY); ce/.../builder/experiment_tree/
  axis_variant_version_table.hpp:149-166 (compose_organ_stamp_line-DEFINITION = Single-Source der
  realen Organ-Zeile — fehlte bisher in der Liste); ce/.../lazy_adhoc_source_gen.hpp:201/:259
  (Aufrufer 1); ce/.../builder/experiment_tree/pilot_source_map.hpp:20/:55 (Aufrufer 2);
  ce/libs/cache_engine/builder/codegen/adhoc_emitter.hpp (P4/A8-Sperrmenge, Bauplan-Matrix Z.86;
  Emissions-Naht render_adhoc_module_source, Konsum lazy_adhoc_source_gen.hpp:207 —
  im Fenster PRUEFEN und als "geprueft, kein Edit" oder als Edit ausweisen, damit die
  Sperrmengen-Abdeckung vollstaendig ist).
- Aenderung: A8.2 gemaess Bauplan TEIL I P4: Fix des Arrays. SOLL-MENGE IST UNGEPINNT
  (Adversarial-Befund): das Array traegt am Pin 17 Eintraege ohne persistence_target; der bindende
  Kontext-Fakt lautet 18 Organ-Achsen (axis.hpp:18 "18 Slots; STRUKT-R ORG-18"; persistence_target =
  18. Slot, lazy_adhoc_source_gen.hpp:153). Ob die Organ-Stempel-Zeile nach A8.2 17 oder 18 Eintraege
  traegt (persistence_target rein oder bewusst draussen) und welche Meta-Meta-Eintraege konkret
  dazukommen, MUSS vor Fenster-Start fixiert sein -> OP-11 (nie-raten-Doktrin; golden-veraendernde
  Inhalts-Entscheidung analog OP-10). Owner OD-1: Stempel-PRINZIP unveraendert (System-Achsen +
  Organ-Achsen + je-Achse-Algorithmus-Version + CT-SHA512-Fingerprint), nur Achsen-Zuordnung je Typ
  aendert sich; vier Stempel-Zeilen bleiben GETRENNT (:71/:94/:112/:182); system_stamp_line bleibt
  mess-blind (:64-70).
- Byte-Klasse: golden-veraendernd (Stempel-Strings).
- Beweis (NACH-Pruefung 6.8): TRAGEND ist die 320-Round-Trip-Wache gruen + golden_fullpilot_320_
  binary_ids.txt UNVERAENDERT (TABU — Byte-Diff gegen Baseline leer). Der alte Beweis "compose_organ_
  stamp_line und pilot_source_map byte-gleich" ist per Single-Source TRIVIAL wahr (EINE Funktion in
  axis_variant_version_table.hpp, beide Orte rufen sie identisch auf) und wird nur als Struktur-Check
  gefuehrt (grep: beide Aufrufer konsumieren weiterhin dieselbe Funktion, keine Kopie entstanden).

### Schritt 8 — A8.3: Fingerprint-Preimage, 5. Glied (Overlay-SOURCE-Hashes)
- Ziel-Dateien: ce/.../abi/anatomy_fingerprint.hpp:25 (kAnatomyFingerprintPreimageMax=4096 — das ist
  die 4096er-Grenze: Puffer, dessen Ueberlauf die consteval-Auswertung sichtbar bricht), :31-43
  (Preimage-Kette, 5. Glied :39-42); ce/.../ctsha512.hpp:163-166 (SEPARATES 50-KB-Body-Budget
  fits_compile_time_budget — QUELLEN-KORREKTUR: die 4096 stehen NICHT dort; der Bauplan-P4-Verweis
  ":164" war die falsche Quelle); ce/.../ceb_version_stamp.hpp:96-98 (faellt mit).
- Aenderung: Owner-KERN: Overlay-SOURCE-Hashes als 5. Preimage-Glied; VORAB BEIDE Budgets literal
  pruefen (Preimage-Laenge < kAnatomyFingerprintPreimageMax=4096, anatomy_fingerprint.hpp:25; UND
  50-KB-Body-Budget ctsha512.hpp:163-166 — je Ausgabe festhalten); Preimage-Reihenfolge nur
  GEMEINSAM an allen drei Orten der Kette aendern (anatomy_fingerprint.hpp ->
  lazy_adhoc_source_gen.hpp:201/:257 -> pilot_source_map.hpp; Konsum profile_run_facade.cpp:369-405,
  artifact_cache.hpp:245-249, ceb_version_stamp.hpp:96-98).
- Byte-Klasse: golden-veraendernd (Fingerprint + kCebFingerprint).
- Beweis: Budget-Check-Ausgabe literal; Bau; 320-Round-Trip weiter gruen; Delta-Liste (ceb_version_stamp-
  Golden-Erwartungen notiert).

### Schritt 9 — Mess-Stempel-Segment (RF-1/§70.1, IV.2.4 K3): Segment-EMISSION
- Ziel-Dateien: ce/.../measurement/measurement_framework_registry.hpp (version-Feld aus SCHRITT 0A —
  die Vor-Fenster-Welle hat es NICHT geliefert, am Pin 0 grep-Treffer "version" (Vorbedingung 1(a));
  Muster MeasurementToolingInfo.version, measurement_tooling_registry.hpp:38-39);
  ce/.../abi/anatomy_version_stamp.hpp:83-124 (kMeasurementAxisVersionLine/measurement_stamp_line
  :94-104; Invarianten-Text :89-91); ce/libs/cache_engine/builder/ceb_version_stamp.hpp:90-98
  (kCebMeasurementStamp :90-92 / kCebFingerprint :95-98; PFAD-KORREKTUR Verify-2: die Datei liegt
  in builder/, NICHT in abi/ — Schritt 8 und Bauplan-Matrix Z.86 zitieren sie korrekt);
  anatomy_module_abi_v1_decl.hpp:150-166 (Deklarations-Seite).
- Aenderung: load_framework=v1.0.0 (migriert aus dem alten kSystemAxisCodeVersions-Slot; Feld aus
  Schritt 0A) wird als version-Feld der Mess-Framework-Registry SCHARF und als Segment der
  kMeasurementAxisVersionLine
  EMITTIERT (Reihenfolge relativ measurement_tooling: OP-3). Invarianten-Text :89-91 praezisieren:
  Framework-WAHL = Mess-Haupt (stempelbar), workload-WERTE = RT-Unter (nie gestempelt). RF-1-Trennung:
  Mess-Achsen im Planer VOELLIG getrennt von CEB-System-/Organ-Achsen — das Segment gehoert NUR in die
  Mess-Zeile, nie in System-/Organ-Zeilen (RF-7: je Typ EINE Array-Zeile). Ausgeschlossene Orte bleiben
  belegt: Planer-Stempel (planner_version.hpp:4-7), CSV-Legende (R9).
- Byte-Klasse: golden-veraendernd (kCebMeasurementStamp/kCebFingerprint; test_m_w12:343-344).
- Beweis: Bau; gezielter Stempel-Emissions-Test: Mess-Zeile enthaelt GENAU EIN
  load_framework-Segment, System-Zeile ENTHAELT KEINES (grep auf Emissions-Output literal); Delta-Liste.

### Schritt 10 — Lane F R3: system_version_suffix.hpp Single-Source + gate_contribution-Einhaengung
- Ziel-Dateien: NEU ce/libs/cache_engine/profile_facade/system_version_suffix.hpp (EINZIGE
  Suffix-Quelle); ce/.../profile_facade/profile_run_facade.cpp:371-405 (system_axes_version_suffix;
  die divergente Suffix-Ordnung `+ext+cxx+opt` liegt konkret bei :378-380) + :1103-1105
  (Divergenz-Kommentar) + :1117-1118 (zweiter Builder print_cache_key_facade in bindender Form
  `+cxx+opt+ext`; ANKER-KORREKTUR: der alte Anker ":1077-1084" zeigte auf fremden Code —
  chunk_part_size/progress_sink-Zuweisungen); ce/.../profile_facade/profile_run_entry.hpp:780-782
  (bindende Ordnung `+cxx+opt+ext`; D2.8(ii)-Ternary :781: no_extension emittiert KEIN "+ext="-Segment);
  ce/.../measurement/artifact_cache.hpp:245-249 (cache_key_prefix);
  ce/.../measurement/simd_build_gate.hpp:362 (woertlicher Marker ">>> O-8-PUNKT (Lane F / R3) <<<"),
  :369 (format_gate_contribution, leer=kein Segment), :381-384 (gate_contribution_identity_text —
  existiert fertig, 0 Konsumenten).
- Aenderung: (a) Suffix-Bildung deklarativ in die NEUE Single-Source heben; alle drei Beitragsorte
  (Facade, perm_build_version/Entry, cache_key_prefix) konsumieren sie; Divergenz W-6/W-13 aufloesen:
  bindende Form = profile_run_entry.hpp:780-782 (`+cxx+opt+ext`), die Facade-Ordnung (:378-380) und der
  zweite Builder (:1117-1118) fallen darauf;
  (b) §70.9-Einhaengung (fuer das Label "Variante A" ist KEIN Quell-Wortlaut auffindbar —
  Attributions-Korrektur Verify-2: grep im Uebergabe-Doc 27.07. = 0 Treffer; es ist KEIN Ledger-/
  Bauplan-/Owner-Wortlaut, die tragende Aussage bleibt: Stempel-Form frei waehlbar, Sidecar als
  dokumentierte Owner-Alternative): `gate_contribution_identity_text(route, dialect)` am markierten O-8-PUNKT als
  Suffix-/Stempel-Segment einhaengen. Owner-Bindung §70.9 VERBATIM (LED:3540): „Gate-Beiträge MÜSSEN
  bei der Scharfschaltung in der Identität sichtbar werden (Sidecar/Stempel; konsistent mit 70.6
  build_version-als-Stempel-Variable)" — Scharfschaltung ist mit C-3a bereits erfolgt
  (simd_build_gate.hpp C-3a-scharf), gate_contribution_identity_text hat 0 Produktions-Konsumenten,
  daher Einhaengung JETZT im Fenster; die Stempel-Form wird gewaehlt (Sidecar bleibt als vom Owner
  genannte Alternative dokumentiert); Gate-Beitraege ohne Identitaets-Sichtbarkeit = Regression;
  leerer Beitrag => KEIN Segment (:369/:386-392);
  Segment-Position siehe OP-7; (c) §70.6: build_version-Suffix als Stempel-Variable-Version der
  System-Achsen fuehren (BUILD-Version anstelle der Algorithmus-Version).
- Byte-Klasse: golden-veraendernd (Suffix-Ordnung = TABU-Gegenstand, faellt hier per vorliegendem O-8-GO).
- Beweis: Bau; Konsumenten-grep: `grep -RIn "system_axes_version_suffix" ce/libs` -> nur noch
  Single-Source + deklarierte Konsumenten; `grep -RIn "gate_contribution_identity_text" ce/libs` ->
  genau 1 Definition + 1 Einhaengung; test_c3a_gate_scharfschaltung.cpp:160-190 laeuft (ggf. Neuanker
  in Schritt 12); Delta-Liste.

### Schritt 11 — Lane F R2: Wachen T-a/T-b/T-c + declared_count-Verbraucher (+ R1-Feststellung)
- Ziel-Dateien: ce/tools/system_axis_registry_gen/main.cpp:78-88 (benannte Wachen-Luecke, "grep T-c"
  trifft; dort NUR ein VIERTES Netz ergaenzen — Netze 1-3 bestehen :112-121/:389-398/:477-495);
  neue/erweiterte Test-Dateien der Suffix-Familie (Sperrmenge IV.3); declared_count:
  ce/.../profile_facade/validate_profile.hpp:765-777 (declared_inactive-Traeger; Kommentar :774 weist
  den Verbraucher exakt diesem Fenster zu), Verbraucher-Naht gemaess Bauplan P6 (EnabledTargets/
  Resolver), ce/tests/unit/test_a9b_active_deklaration_inert.cpp (Erweiterung um Wirksamkeits-Fall).
- Aenderung: T-a (Perm-Suffix == Facade-Suffix), T-b (count("+ceb=")==1), T-c Segment-Ordnungs-Wache NEU
  formuliert auf die DREI-Achsen-Ordnung (D2.5/K1/K4).
  DECLARED_COUNT (bisher im Plan VOLLSTAENDIG fehlend — Adversarial-Befund): der §72-Fenster-Inhalt
  lautet "Lane F inkl. R1-R3"; Bauplan TEIL I P6 (Z.74) woertlich "declared_count gehoert ins
  Lane-F-Fenster"; vier lebende Code-Kommentare weisen den Verbraucher diesem Byte-Fenster zu
  (validate_profile.hpp:774, xml_config_parser.hpp:118/:400, test_a9b_active_deklaration_inert.cpp:24).
  Der declared_count-Verbraucher (macht die active="false"-Abwahl wirksam) wird HIER gebaut:
  byte-neutral, SOLANGE kein Profil active=false setzt (P6: fehlendes Attribut == true; KEIN Profil
  setzt false). Ein wirksames active=false aendert Katalog-Kardinalitaet -> golden-CRC und bleibt
  UNTERSAGT — die kNewGolden131072Crc64-Wache (Schritt 12/Abschnitt 4) ist genau der Schutz dagegen.
  R1 (GN_PREFIX-Haertung): im aktiven CI existiert GN_PREFIX NICHT mehr (super/.gitlab-ci.yml
  0 Treffer, ce/.gitlab-ci.yml 0 Treffer; nur Archiv ci/archive/perm-matrix-fallback.yml mit
  20 Treffern :71-:242 (Anker-Korrektur Verify-2: die alte Liste ":71/:106/:109" war unvollstaendig;
  Kernbefund unveraendert, Beweis-grep zielt korrekt NUR auf die aktive Datei) und Kommentar
  profile_run_facade.cpp:1105) UND .gitlab-ci.yml ist Nicht-Ziel/Infra-Gebiet — im Fenster daher NUR
  Beweis-grep + Feststellungs-Vermerk, Entscheid OP-1 (OWNER, siehe Abschnitt 10).
  TEST_A9B-AUFLAGE (Verify-2): Teil 2 des bewusst UNREGISTRIERTEN Guards belegt heute die
  WIRKUNGSLOSIGKEIT von active="false" (test_a9b_active_deklaration_inert.cpp:33-36: zwei nur im
  Attribut verschiedene Profile liefern denselben AxisLevel-Satz und Zeichen fuer Zeichen dieselbe
  binary_id-Liste) — der hier gebaute declared_count-Verbraucher INVERTIERT genau diese Zusicherung.
  Teil 2 ist daher IM SELBEN SCHRITT zu invertieren/neu zu verankern; da der Test unregistriert ist
  (Datei-Kopf :1-5; 0 Treffer in tests/unit/CMakeLists.txt), faengt das Schritt-13-ctest-Gate einen
  inkonsistent zurueckgelassenen Teil 2 NICHT — Beweis zwingend per Hand-Bau, Ausgabe literal.
- Byte-Klasse: byte-neutral (Wachen + inert-wirksamer Verbraucher ohne false-setzendes Profil).
- Beweis: neue Wachen kompilieren und schlagen bei absichtlicher Probe-Verletzung an (Negativ-Probe
  lokal, danach zurueckgenommen — Ausgabe literal); `grep -RIn "declared_count" ce/libs ce/tests` ->
  Verbraucher existiert (vorher 0 Treffer ausserhalb von Kommentaren); Negativ-Probe active=false
  schlaegt an bzw. golden-CRC nachweislich unveraendert;
  `grep -RIn "GN_PREFIX" super/.gitlab-ci.yml` -> 0.

### Schritt 12 — Golden-String-Neuanker (D2.10, PASS 2; 2-Pass-Pflicht §72)
- Ziel-Dateien (aus PASS-1-Output, mindestens): ce/tests/unit/test_m_w12_stamp_bausteine.cpp:265
  (Zaehl-Wache 5->3), :271-273 (goldener System-String), :341-342 (kSystem-Literal —
  ANKER-KORREKTUR Verify-2: das alte Etikett ":339-340" zeigte auf das ENDE des kOrgan-Literals
  :336-340, exakt die Zeilen, die OP-11 der ORGAN-Frage zuordnet; kSystem steht bei :341-342 und
  wird von den vier D2.10-grep-Mustern NICHT getroffen — Auffangnetz ist der Schritt-3-grep auf
  extension_hardware, der :341 trifft, plus das ctest-Gate ueber entry_counts {17,5,3} :334),
  :343-344
  (Mess-Zeile); test_g1_binary_version_stamp.cpp:64 (divergente Ordnung "+ext=avx2+cxx=gcc+opt=O3+ceb=6.0"
  faellt auf bindende Form) + :98; test_s1_cache_key_prefix.cpp:36/:69; test_s2/test_s5/test_w11/test_g3;
  g1_binary_version_stamp.hpp; test_experiment_plan_director.cpp:113-114;
  test_striktheit_axis_dach_guard.cpp:17/:117; test_c3a_gate_scharfschaltung.cpp:160-190;
  ce/libs/cache_engine/profile_facade/source_catalog.hpp:190 (kNewGolden131072Crc64 — NUR PRUEFEN,
  KEIN Edit: Bestaetigungs-Gate, siehe Aenderung unten).
- Aenderung: ALLE Golden-Literale ausschliesslich aus WERKZEUG-OUTPUT neu ankern (Test-Lauf-Ausgabe,
  Emissions-Dump, Generator-Output — NIE von Hand konstruiert); Fenster-Pflicht-Checkliste per grep
  erneut VOLL laufen lassen (dieselben vier Muster wie Schritt 0e) und JEDEN Treffer gegen die
  Delta-Liste abgleichen — kein un-erklaerter Treffer darf bleiben.
  KORREKTUR kNewGolden131072Crc64 (Adversarial-Befund, code-verifiziert): der CRC wird NICHT neu
  geankert — Erwartung UNVERAENDERT 0x56F1B721C72DC10E. Begruendung: der CRC ist per Konstruktion
  AUSSCHLIESSLICH die CRC-64/ECMA-182 ueber die 131072 Organ-Achsen-binary_ids in
  StaticBinaryView-Reihenfolge (source_catalog.hpp:176-190; test_lazy_adhoc_source_gen.cpp:190-202) —
  dieselbe ID-Familie wie die 320er-TABU-Datei (18 Organ-Slots, ohne telemetry-/isa-Segment). KEIN
  Fenster-Schritt aendert Organ-Achsen oder binary_id-Komposition: A2/A3/Wrapper sind System-Achsen
  (binary_id="never"), Stempel-Zeilen sind binary_id-NEUTRAL (anatomy_version_stamp.hpp:110-111),
  der Suffix geht nie in die binary_id. Eine echte CRC-Aenderung braeche zwingend AUCH die
  320er-TABU-Wache (STOPP-Regel 1). Der Doppel-Golden-Lauf N=131072 wird daher zum
  BESTAETIGUNGS-GATE: beide Laeufe muessen den ALTEN Wert liefern; jede Abweichung = STOPP
  (Abschnitt 6, Regel 3+5). Die Bauplan-Zeile ~:249 ("Fenster aendert kNewGolden131072Crc64") ist
  damit als unbelegte Fehl-Erwartung KORRIGIERT; das §72-GO ERLAUBT einen TABU-Fall, ERWARTET ihn
  nicht — ein Agent darf keinen CRC-Bruch als "erwartet" durchwinken.
- Byte-Klasse: golden-veraendernd (der eigentliche Neuanker der Stempel-/Suffix-Golden-Strings;
  CRC bleibt unveraendert, s.o.).
- Beweis: grep-PASS-2-Output archiviert; Diff PASS 1 vs PASS 2 vollstaendig erklaert (Zeile fuer Zeile
  gegen Delta-Liste); Doppel-Lauf-CRC identisch UND == 0x56F1B721C72DC10E (beide Ausgaben literal).

### Schritt 13 — J-Kette: GESAMT-GATE (beide Baeume; Details Abschnitt 4)
- Ziel-Dateien: keine Edits (nur bauen/testen; bei Befund zurueck in den verursachenden Schritt).
- Aenderung: keine. Voller Configure/Bau/ctest ce-standalone UND super mit `-DCOMDARE_V32_ENABLE=ON`;
  Wachen-Matrix (Abschnitt 4) komplett pruefen; V-1-G1-Byte-Diff final wiederholen;
  golden/320-Baum-Dump gegen Baseline: NUR die in der Delta-Liste erklaerten Abweichungen.
- Byte-Klasse: byte-neutral (Pruef-Schritt).
- Beweis: ctest-Summary JE BAUM literal, 0 failed; Basiszahlen am Alt-Pin: ce-standalone 316,
  super 453; nach Re-Pin gilt die 4a(iii)-Neu-Basis
  ("316/316 in beiden Baeumen" war falsch — im super-Baum unerreichbar und haette zur Scope-Verengung
  auf den ce-Subbuild verleitet); neue Wachen-Tests aus Schritt 11 erhoehen N additiv — Ist-N je Baum
  gegen Basis-N erklaeren; Wachen-Matrix-Tabelle ausgefuellt mit Ist-Ausgaben; ASCII-Wache ueber den
  Gesamt-Diff NUR auf HINZUGEFUEGTE Zeilen (Diff-Hunks tragen Kontext-Zeilen mit Alt-Bestand an
  Nicht-ASCII, z.B. profile_run_entry.hpp:207/:216 DIREKT im C-3c-Edit-Bereich — ungefiltert schluege
  das 0-Treffer-Gate garantiert an, ohne dass ein neuer Verstoss vorlaege):
  `git -C <tree> diff o8-fenster-start -- '*.hpp' '*.cpp' '*.h' '*.cmake' '*CMakeLists.txt' | grep -P '^\+' | grep -vP '^\+\+\+' | grep -P '[^\x00-\x7F]'`
  -> 0 Treffer. PATHSPEC-KORREKTUR (Verify-2, MAJOR): das alte Pathspec-Glied `'CMakeLists.txt'`
  matcht in git NUR die Wurzel-Datei (verifiziert am Pin: `git ls-files -- 'CMakeLists.txt'` =
  1 Datei; `'*CMakeLists.txt'` = 208) — ext/CMakeLists.txt, super/Code/CMakeLists.txt
  (Schritt-1-Ziele) und tests/unit/CMakeLists.txt (Schritt-11-Registrierungen) laegen sonst
  AUSSERHALB des Diff-Scopes und "0 Treffer" waere fuer sie ein Schein-Beweis.

### Schritt 14 — Abschluss: Commits, super-Nachzug, Push, Pipeline, Paketmeldung
- Ziel-Dateien: super Submodule-Pointer (ce-Verweis); Commit-/Push-Vorgaenge.
- Aenderung: Commits gemaess Granularitaets-Entscheid OP-2 (Vorschlag: granulare lokale Commits je
  Schritt 0A-12, davon Schritt 4 zwingend EIN Commit und Schritt 3 inkl. Registry-Regen EIN Commit;
  EIN Push je Repo erst NACH Schritt 13); Reihenfolge:
  ce pushen -> ce-Pipeline hart gruen abwarten -> super Submodule-Pointer bumpen + super-Aenderungen
  (Schritt 1-super, Schritt 3-super-Vokabular, Schritt 5-XSD) committen -> super pushen ->
  super-Pipeline hart gruen (§74, REV17
  Deploy-Token beachten). DANACH Paketmeldung + WORKING-TREE-FREEZE (kein weiterer Edit; diff-stat
  literal in die Meldung), Meldeformat Abschnitt 8.
- Byte-Klasse: byte-neutral (Publikation des Fensters).
- Beweis: Pipeline-Status beider Repos "passed" (literal, per API/Weboutput); diff-stat beider Baeume.

---

## 4. J-KETTE ALS GESAMT-GATE + WACHEN-MATRIX (Schritt 13)

Kommandos (je Baum, offizieller Weg CMake/ctest, PARALLEL_LEVEL=12):
1. Configure mit `-DCOMDARE_V32_ENABLE=ON` in BEIDEN Baeumen (ohne das Flag fehlen V32-Tests).
2. Voller Bau; 3. `ctest --output-on-failure` -> MUSS 0 failed melden; Basis-N je Baum verschieden
   (ctest -N am Alt-Pin: ce-standalone 316, super 453; bindend ist die per Re-Pin-Protokoll 4a(iii)
   NEU erhobene Basis — legitime Vor-Fenster-Deltas durch 7a-7d sind KEIN Widerspruch) — Ist-N
   literal zitieren, Abweichung von DIESER Basis
   nur durch Schritt-11-Wachen additiv und erklaert. Ein pauschales "316/316 in beiden" ist FALSCH.
4. D2.10-grep (vier Muster) PASS-2-Abgleich; 5. Wachen-Matrix:

| # | Wache | Erwartung im Fenster | Neuanker-Verfahren |
|---|-------|----------------------|--------------------|
| 1 | golden_fullpilot_320_binary_ids.txt | DARF NICHT brechen (TABU 6.12) — Byte-Diff gegen Baseline LEER | keiner; Bruch = STOPP+Rollback |
| 2 | golden_fullpilot_320_binary_ids_abi4.txt | unveraendert (Archiv) | keiner |
| 3 | _abi5.txt | unveraendert (Archiv) | keiner |
| 4 | _abi6.txt | unveraendert (Archiv) | keiner |
| 5 | system_axis_registry.xml | BRICHT erwartet in Schritt 3, 4 und 6 (der Bruch beginnt mit dem A2-Rename: XML:53/:55 tragen extension_hardware, Label kommt aus axis_label(), main.cpp:382) | ausschliesslich Generator-Output (system_axis_registry_gen), Regen im SELBEN Commit (Roundtrip-Gate FATAL), nie Hand-Edit |
| 6 | permutation_axes.xml | DARF NICHT brechen (TABU 6.12) | keiner; Bruch = STOPP+Rollback |
| 7 | m3v2_study.profile.xml | DARF NICHT brechen (im Fenster nicht angefasst) | keiner; Bruch = STOPP+Rollback |

Zusatz-Anker (keine Byte-Wachen-Dateien, aber Golden-Anker):
- kNewGolden131072Crc64 (source_catalog.hpp:190): DARF NICHT brechen — Erwartung UNVERAENDERT
  0x56F1B721C72DC10E (KORRIGIERT; Begruendung + Code-Beleg in Schritt 12: CRC ueber Organ-binary_ids,
  dieselbe ID-Familie wie Matrix-Zeile 1; eine Aenderung braeche zwingend auch die 320er-TABU-Wache).
  Doppel-Golden-Lauf N=131072 in Schritt 12 = Bestaetigungs-Gate; Abweichung = STOPP (Regel 3+5).
  Die alte "BRICHT erwartet"-Zeile stammte unbelegt aus Bauplan ~:249 und haette den Agenten trainiert,
  einen CRC-Bruch zu akzeptieren, der per Konstruktion ein STOPP-Signal ist.
- Stempel-Golden-Strings (test_m_w12, test_g1, test_s1, test_s2/s5/w11/g3, Direktor-/Dach-Guards):
  brechen erwartet ab Schritt 3; Neuanker gesammelt in Schritt 12 (Werkzeug-Output).
- 320-Round-Trip-Byte-Wache: MUSS nach Schritt 7/8 gruen sein (compose_organ_stamp_line ==
  pilot_source_map byte-gleich).
- NACH-Pruefung 6.13/D2.11: alle in diesem Plan zitierten datei:zeile-Anker nach dem Bau NEU erzeugen
  (Drift 2-20 Zeilen erwartbar); Working-Tree-Anker gesondert fuehren.

---

## 5. TREE-SERIALISIERUNG: EIN AGENT, BEIDE BAEUME, FREEZE-PUNKTE

- EIN Agent fuehrt das gesamte Fenster (§72). Kein zweiter Schreiber in ce ODER super waehrend des
  Fensters (Vorbedingung 4). git IMMER mit `-C <pfad>` (CWD-Falle).
- Edit-Reihenfolge ueber die Baeume: Schritt 1 beruehrt BEIDE (V-1 braucht den Cross-Tree-G1-Beweis
  sofort); Schritt 3 beruehrt BEIDE (KORRIGIERT: das extension_hardware-Vokabular lebt auch im
  super-Baum — experiment_schema.xsd:260/:314 + experiment_golden*.xml; "nur ce" war hier falsch);
  Schritt 5 beruehrt super (XSD) + ce (Parser); alle uebrigen Schritte NUR ce.
- FREEZE-PUNKTE:
  - F0 (vor Schritt 0): beide Baeume clean bzgl. getrackter Aenderungen auf den dokumentierten
    (ggf. Nachfolge-)Pins gemaess Vorbedingung 4/4a; erlaubte untracked Pfade namentlich gelistet
    (u.a. Code/measure_out_d03/ = Messdaten, NIE loeschen); Start-Tags gesetzt.
  - F1 (nach Schritt 12): ce-EDIT-FREEZE — ab hier keine ce-Quell-Edits mehr, nur noch Schritt-13-Pruefung;
    jede Nachbesserung geht ZURUECK in den Schritt, der sie verursacht, und wiederholt Schritt 12+13.
  - F2 (nach Schritt 13): TOTAL-EDIT-FREEZE beider Baeume; nur noch Commits/Pointer-Bump/Push (Schritt 14).
  - F3 (nach Paketmeldung): WORKING-TREE-FREEZE (Doktrin) — kein Edit mehr, diff-stat literal gemeldet.
- Push-Serialisierung: erst ce (Pipeline hart gruen), dann super (Submodule-Pointer + super-Diff,
  Pipeline hart gruen). Niemals beide gleichzeitig ungeprueft.

---

## 6. ROLLBACK-STRATEGIE (je golden-veraenderndem Schritt: 3, 4, 6, 7, 8, 9, 10, 12)

- Grundlage: VOR Schritt 1 existieren lokale Tags `o8-fenster-start` in beiden Baeumen (Schritt 0b) und
  Baseline-Sicherungen im Scratchpad (Schritt 0d). Vor Schritt 13 wird NICHTS gepusht — Rollback ist
  daher immer rein lokal, KEIN Force-Push noetig, Remotes bleiben unberuehrt.
- Je golden-veraenderndem Schritt gilt: lokaler Commit nach bestandenem Schritt-Beweis (OP-2-Vorbehalt);
  Rollback-Einheit = `git -C <tree> reset --hard <letzter gruener lokaler Commit>`.
- STOPP-Regeln (sofortiger Abbruch des Schrittes, Befund an Manager, KEIN Weiterbau):
  1. Eine TABU-Wache (Matrix-Zeilen 1-4, 6, 7) zeigt ein Byte-Delta.
  2. Ein Wachen-/Test-Delta ist nicht aus der Delta-Liste erklaerbar.
  3. Der Doppel-Golden-Lauf (Schritt 12) liefert ZWEI verschiedene CRCs (Nicht-Determinismus).
  4. Das Preimage-Budget (Schritt 8) wird ueberschritten.
  5. kNewGolden131072Crc64 weicht vom alten Wert 0x56F1B721C72DC10E ab (Bestaetigungs-Gate Schritt 12;
     eine echte Aenderung braeche per Konstruktion auch Regel 1 — niemals als "erwartet" durchwinken).
- FENSTER-ABBRUCH (Atomaritaet): Das Fenster kennt keinen teil-gelandeten Zustand. Wenn ein STOPP nicht
  innerhalb des Fensters sauber behoben werden kann: beide Baeume `reset --hard o8-fenster-start`,
  Scratchpad-Baseline bleibt als Beleg (additiv, nichts loeschen), vollstaendiger Befund an den Manager;
  Wiederanlauf nur mit neuem Fenster-GO.
- Messdaten/golden-Dateien werden NIE geloescht — Neuanker ueberschreibt tracked Dateien nur via
  Werkzeug-Output, Vorzustand liegt in git-Historie + Schritt-0-Sicherung (Backups additiv).

---

## 7. NICHT-ZIELE (explizit AUSSERHALB des Fensters)

1. V-2 (Bestandsinventar-Umzug), V-3 (Super-Abschaltung), V-4 (ce-Retire): byte-neutral, erst NACH dem
   Fenster (Abschnitt 9). Vom Retire faehrt im Fenster NUR V-1 mit (einziges Byte-Paket, Bauplan TEIL V).
2. KEINE .gitlab-ci.yml-Edits (beide Repos) — Infra-Gebiet (buildsystem/CI-Agent). Betrifft R1/GN_PREFIX
   (OP-1) und super-CI visibility:tier-binaries (V-2/2b, INFRA-HANDOUT).
3. KEINE C-3a-Aenderungen ueber C-3c-Patch + R3-Einhaengung hinaus (simd_build_gate.hpp ist bereits
   C-3a-scharf; D3.6: C-3a war eigenes Folge-Paket).
4. NUMA/page-RT-Unter-Achsen am Wrapper (OD-10): NACH Fenster, VOR Voll-Bau-4 (im Fenster nur die
   STATISCHE sub_axis-Einhaengung scheduling/numa_node/page, Schritt 6).
5. KEINE Aenderung an TABU-Gegenstaenden (Abschnitt 2); ABI-Major bleibt 7; keine Messdaten-/CSV-Beruehrung.
6. KEINE Doku-Loeschung — nur additive SUPERSEDED-Vermerke (die IV.6-Vermerk-Schicht ist Vorbedingung,
   nicht Fenster-Inhalt).
7. Abweichungen vom benannten Fenster-Inhalt brauchen einen eigenen Owner-Entscheid (§72).

---

## 8. MELDEFORMAT (Paketmeldung des Fenster-Agenten)

- ASCII-only in allen Code-Kommentaren; Beweis ueber den Gesamt-Diff, NUR hinzugefuegte Zeilen
  (Kontext-Zeilen tragen Alt-Bestand an Nicht-ASCII, u.a. profile_run_entry.hpp:207/:216 im
  C-3c-Bereich — ungefiltert waere das 0-Treffer-Gate unerfuellbar ohne neuen Verstoss):
  `git -C <tree> diff o8-fenster-start -- '*.hpp' '*.cpp' '*.h' '*.cmake' '*CMakeLists.txt' | grep -P '^\+' | grep -vP '^\+\+\+' | grep -P '[^\x00-\x7F]'`
  -> 0 Treffer (XML/MD: `§` erlaubt, sonst ebenfalls ASCII; Pathspec `'*CMakeLists.txt'` — NICHT
  `'CMakeLists.txt'`, das matcht nur die Wurzel-Datei, siehe Schritt-13-Pathspec-Korrektur).
- SELBSTCHECK-ZEILE (Pflicht, LC-Falle): die Liste der geaenderten Dateien wird AUS DEM DIFF ABGELEITET
  (`git -C <tree> diff --stat o8-fenster-start`), NIE handgepflegt; diff-stat beider Baeume literal in
  die Meldung.
- Kein Erfolgs-Haken ohne literale Werkzeug-Ausgabe (ctest-Summary, grep-Output, Byte-Diff, CRC-Paar).
- Nach der Paketmeldung: WORKING-TREE-FREEZE (F3).
- Inhalt der Meldung: Schritt-Tabelle (Schritt / Byte-Klasse / Beweis-Ausgabe), Wachen-Matrix ausgefuellt,
  Delta-Liste (alle Golden-Neuanker alt->neu mit Begruendung), CRC-BESTAETIGUNGSPAAR (Doppel-Lauf
  Schritt 12, BEIDE Ausgaben literal und == 0x56F1B721C72DC10E — Formulierungs-Korrektur Verify-2:
  die alte Rev.-1-Formel "CRC alt->neu" primte auf einen berichtbaren CRC-Wechsel; ein CRC-Wechsel
  ist NIE meldbar-normal, sondern STOPP-Regel 5), offene Folgen (Abschnitt 9).

---

## 9. DANACH (Folge-Pakete, NICHT im Fenster)

1. **V-2** Bestandsinventar-Umzug (byte-neutral, MESS-KRITISCH): Konsumenten von
   generated/permutations_manifest.txt abloesen (Treiber-Startgate main.cpp:641 +
   permutations_runtime_check.hpp:87-100, Defines 02_messung_driver/CMakeLists.txt:141-142);
   super-CI visibility = INFRA-HANDOUT. M3-AUFLAGE (owner-ratifiziert via §73.7 "Volles GO";
   Bauplan TEIL V M3 + Paket V-2 2a/Q3): ERSATZ-Gate (Planer-Plan/Bestandslog) statt ersatzlos —
   "ein leerer Bau muss weiter frueh mit klarem Exit sterben". Gate daher ZWEITEILIG: (a) Treiber
   ohne Manifest `--validate` + Smoke rc 0 (Wegfall-Beweis) UND (b) Existenz-Beweis des
   Ersatz-Gates (leerer Bau stirbt frueh mit klarem Exit, Ausgabe literal) — (a) allein beweist
   nur den Manifest-Wegfall und liesse ein ersatzloses Abloesen durchgehen.
2. **V-3** Super-Abschaltung (byte-neutral): super Code/CMakeLists.txt:92-102/:212-216/:222-227/:276-289;
   PRT-ART-Zwilling V36.C im Scope. V-2 strikt vor V-3 ODER in EINEM Zug; kein Schritt darf den
   messung_driver zwischenzeitlich toeten.
3. **V-4** ce-Retire (byte-neutral): ce CMakeLists.txt:33/:560-609, cmake/permutations.cmake,
   permutation_codegen_tool, tests/unit/CMakeLists.txt:3787-3803 + perm_codegen_byte_identity.cmake
   (#25-B-Vertrag mit §71-GO abgeloest); ctest-Delta exakt -2; Archiv-Artefakte bleiben (Doku-Doktrin).
   Ultracode-Merge-Planung ist vom Owner beauftragt ("Bitte ultracode fuer den merge").
4. **V-5a** SIMD-Merge (owner-entschieden §73.2/Q1, Bauplan TEIL V): sse4.2/neon werden als Zellen
   der eigenen System-Meta-Meta-Hauptachse unter dem external_utils-Hub GEMERGT (am Pin noch nicht
   vorhanden — Schritt 3 formuliert das ausdruecklich als Folge-Paket, nicht als Ist-Zustand;
   V-5b/MSVC-Substanz bleibt, Q4-Infra-Handout §73.3). (Verify-2: fehlte in dieser Folge-Liste.)
5. **V-6** CLI-Subcommand-Umbau (clig.dev) — owner-entschieden JETZT-Einstufung §73.6/Q7.
   (Verify-2: fehlte in dieser Folge-Liste; Uebergabe 7g trackt beide zusaetzlich.)
6. OD-10: NUMA/page-RT-Unter am Wrapper; danach **Voll-Bau-4** + golden-Regen, Pipeline hart gruen.
7. §75 Abschluss-Aufraeumpass (eigenes Paket, ultracode VOR+NACH; Kandidatenliste im Ledger).

---

## 10. OFFENE PUNKTE — VOR FENSTER-START KLAEREN
### Entscheid-Autoritaet (KORRIGIERT nach §72): Ledger §72 verbatim: "Abweichungen vom benannten
Fenster-Inhalt brauchen weiterhin einen eigenen Owner-Entscheid." OP-1 (Wegfall eines in §72 benannten
Fenster-Bestandteils "Lane F inkl. R1-R3") und OP-5 (Erweiterung ueber den benannten Inhalt hinaus)
sind genau solche Abweichungen => OWNER-Entscheide, vom Manager nur EINZUHOLEN. Alle uebrigen OPs
(Praezisierungen INNERHALB des benannten Inhalts) entscheidet der Manager.

- **OP-1 (R1/GN_PREFIX-Widerspruch) — ENTSCHEID: OWNER (Abweichung vom benannten Fenster-Inhalt):**
  Bauplan verlangt R1 = GN_PREFIX-Haertung .gitlab-ci.yml:877-896;
  Code-Ist: GN_PREFIX hat 0 Treffer im aktiven super/.gitlab-ci.yml (nur Archiv
  ci/archive/perm-matrix-fallback.yml, 20 Treffer :71-:242 — Archivierung per §70.4/RF-4
  owner-gedeckt — und
  Kommentar profile_run_facade.cpp:1105) UND .gitlab-ci.yml ist Nicht-Ziel (Infra). Entscheid: R1 als
  gegenstandslos abhaken (Beweis-grep, Schritt 11) ODER Infra-Handout ausserhalb des Fensters?
  Die Faktenbasis ist verifiziert; nur die Abhak-Entscheidung selbst braucht den Owner.
- **OP-2 (Commit-Granularitaet):** Bauplan I §5 sagt fuer Agent 5 "EIN Commit"; der Fenster-Inhalt ist
  seitdem stark gewachsen (A2/A3/V-1/O-4b), Doktrin sagt granulare Commits. Vorschlag dieses Plans:
  granulare lokale Commits je Schritt (Schritt 4 zwingend EIN Commit), EIN Push je Repo nach Schritt 13.
  Bestaetigung noetig.
- **OP-3 (Mess-Segment-Reihenfolge):** Position des load_framework-Segments in kMeasurementAxisVersionLine
  RELATIV zu measurement_tooling ist byte-tragend und weder von RF-1 noch §70.1 fixiert.
- **OP-4 (O-4b-Attribut-Schnitt) — REDUZIERT:** heutiges `ram_pair` ist EIN String
  (experiment_schema.xsd:113-127). OFFEN sind NUR die Attributnamen/Einheiten der neuen Glieder
  (z.B. ram_frequency in MHz, cas_latency als CL-Zahl, cpu_fabrication) — RF-6 laesst Einheiten offen.
  Die ram_pair-Frage ist NICHT offen: Schritt 5 hat bereits entschieden "ram_pair bleibt —
  Doku/Additiv-Doktrin" (gestuetzt durch den XSD-Kommentar "Identitaets-Kern = cpu_fabrication +
  ram_pair", :113-115); die alte Doppel-Fuehrung als offener Punkt haette den Fenster-Start grundlos
  blockiert bzw. zu einer nicht additiv gedeckten Entfernung eingeladen.
- **OP-5 (Aeussere Komplex-Achse im Fenster?) — ENTSCHEID: OWNER (Abweichung: Erweiterung ueber den
  benannten §72-Inhalt; der Plan markiert selbst "Abweichungs-Klausel!"):**
  Die DREI-Ordnung zwingt compiler aus der Haupt-Ordnung;
  IV.2.7/O-1r verortet compiler+opt_level+atomic128 als SubAxisGroup an der AEUSSEREN
  System-Komplex-Haupt-Achse (CompoundSystemAxis). Die aeussere Wrapper-KONSTRUKTION steht aber nicht
  woertlich im §72-Fenster-Inhalt (Abweichungs-Klausel!). Entscheid: aeussere Komplex-Achse im Fenster
  mitbauen (implizit durch A3 noetig) oder minimale Zwischen-Verortung von compiler bis zum Folge-Paket?
- **OP-6 (C-3c-Volltext):** Ausser "PATCH-AN-A3" (Bauplan TEIL I P7) und der §70.9-Sache existiert kein
  Owner-Wortlaut zum konkreten C-3c-Diff. P7-Volltext vor Fenster-Start gegen Schritt 6(f) bestaetigen.
- **OP-7 (gate-Segment-Position):** Position des `gate=[...]`-Segments innerhalb der neuen
  Suffix-Ordnung (vor/nach `+ceb=` bzw. `+tel`) ist byte-tragend und nicht fixiert.
- **OP-8 (V-1-Schaltername):** `COMDARE_PROVISION_VENDOR_ALLOCATORS` ist im Bauplan als VORSCHLAG
  markiert — Namen final bestaetigen (Umbenennung nach dem Fenster waere erneut Cross-Tree-Aufwand).
- **OP-9 (Vorbedingungs-Bestaetigung) — HALBIERT, Antwort steht code-verifiziert fest:**
  (a) measurement_framework_registry version-Feld: NICHT gelandet (0 grep-Treffer "version" am Pin;
  Datei zuletzt 20.07. geaendert, VOR der byte-neutralen Welle) -> Schritt 0A ist PFLICHT, keine
  Eventualitaet mehr. (b) XSD/Parser-O-2-Basis: GELANDET (experiment_schema.xsd O-2-Block ab :339ff,
  numa_node :379 / page :395; xml_config_parser.cpp:129-131). REST-Fragen an den Manager:
  (b1) IV.6-Doc-Vermerk-Schicht bestaetigen; (b2) NEU (Verify-2): Schritt 0A verlagert einen Teil
  der expliziten §72-STARTBEDINGUNG ("erst nachdem die byte-neutrale Welle komplett gelandet",
  LED:3548) als Nachzug IN das Fenster — Manager bestaetigt EXPLIZIT, dass Schritt 0A im Fenster
  die §72-Vorbedingung erfuellt (byte-neutral, VOR allen Byte-Schritten, offen ausgewiesen),
  ODER ordnet an, 0A vor Fenster-Start ausserhalb auszufuehren (kostenneutral; schliesst die
  letzte Autoritaets-Luecke der Verlagerung).
- **OP-10 (operating_system-Auspraegungs-Katalog + Edit-Scope):** Die neue Haupt-Achse
  operating_system tritt in
  Schritt 4 in die Ordnung ein (heute static_assert :95 "erst A3"); ihr Auspraegungs-/Versions-Katalog
  (Werte, Emitter-Inhalt, Registry-Block) ist in den Extrakten nicht fixiert — aus dem
  Bauplan-D2.5-Volltext ziehen oder vom Manager/Owner fixieren lassen. ZUSATZ (Verify-2): bei der
  Klaerung den EDIT-SCOPE mit benennen — am Pin existiert "operating_system" nur als String in
  system_axis_order.hpp:19/:95 (kein Achsen-Typ); noetig sind neuer CRTP-Achsen-Typ-Header +
  Emitter-Funktion + kSystemAxisCodeVersions-Eintrag (in die Schritt-4-Ziel-Dateien aufgenommen).
- **OP-11 (A8.2-Soll-Menge, NEU):** Ziel-Inhalt des Array-Fixes in Schritt 7 ist ungepinnt: traegt die
  Organ-Stempel-Zeile nach A8.2 17 oder 18 Eintraege (persistence_target rein oder bewusst draussen —
  Ist: std::array<...,17> OHNE persistence_target, anatomy_version_stamp.hpp:42-60; Kontext-Fakt:
  18 Organ-Achsen, axis.hpp:18; test_m_w12-Golden-String kOrgan :336-340 sagt "17 Haupt-Achsen",
  Kommentar :340)? Welche
  Meta-Meta-Eintraege kommen konkret dazu? Golden-veraendernde Inhalts-Entscheidung — VOR Fenster-Start
  fixieren (analog OP-10; nie-raten-Doktrin).

---

### ENTSCHEIDE-BLOCK (27.07. ~07:30 — ALLE OPs FIXIERT; Owner-GOs Ledger §76, Rest Manager)

- **OP-1 ENTSCHIEDEN (OWNER-GO §76):** R1/GN_PREFIX = GEGENSTANDSLOS abgehakt. Beweis-grep in
  Schritt 11 bleibt PFLICHT (aktives .gitlab-ci.yml 0 Treffer; Archiv-Reaktivierung wuerde die
  Auflage wiederbeleben — als P10 bei Infra vermerkt).
- **OP-2 ENTSCHIEDEN (Manager):** Plan-Vorschlag bestaetigt — granulare LOKALE Commits je Schritt,
  Schritt 4 zwingend EIN Commit, EIN Push je Repo nach Schritt 13 (Gruen-Kette vor Publikation).
- **OP-3 ENTSCHIEDEN (Manager, quellen-gestuetzt):** load_framework-Segment steht als ERSTES
  Meta-Meta-Segment VOR measurement_tooling in der kMeasurementAxisVersionLine — Bauplan-Vorgabe
  "load_framework = ERSTE Meta-Meta" (BP:6-7, :157) wird auf die Segment-Ordnung uebertragen.
- **OP-4 ENTSCHIEDEN (Manager):** <machines>-Attributnamen mit Einheit im Namen:
  `ram_frequency_mhz` (MHz, ganzzahlig), `cas_latency_cl` (CL-Zahl), `cpu_fabrication`
  (Tupel-String im O-4a-Format: vendor/family/model/stepping, z.B.
  "GenuineIntel/6/151/2"). `ram_pair` bleibt (Schritt-5-Entscheid, Additiv-Doktrin).
  prod2-Deklaration: cpu_fabrication liegt vor (O-4a-VOLLZUG: GenuineIntel/6/151/2,
  i9-12900K); ram_frequency_mhz/cas_latency_cl bei Infra angefragt — bis dahin traegt
  prod2 diese zwei Glieder als nicht-deklariert (ehrlich, kein Raten; Nachdeklaration additiv).
- **OP-5 ENTSCHIEDEN (OWNER-GO §76):** Die AEUSSERE System-Komplex-Haupt-Achse
  (CompoundSystemAxis, O-1r: compiler+opt_level+atomic128 als SubAxisGroup, Rekombination der
  DREI) wird IM FENSTER MITGEBAUT (Schritt 6(e) wird von "Umfang offen" auf VOLL gestellt).
- **OP-6 ENTSCHIEDEN (Manager, gegengelesen):** P7-Volltext (BP:76-77) deckt Schritt 6(f) exakt:
  C-3c = ISA-Zulassung profile_run_entry.hpp:209-216 von Host-Probe auf deklarierte
  Klassen-Identitaet (kDeclaredMachines/O-4) ausrichten, als PATCH-AN-A3, kein separater
  Edit-Gang an target_isa_system_axis.hpp. BESTAETIGT, keine Abweichung.
- **OP-7 ENTSCHIEDEN (Manager):** Das `gate=[...]`-Segment wird als LETZTES Segment ans ENDE der
  bestehenden Suffix-Ordnung gehaengt (nach +ceb bzw. +tel) — Praefix-Stabilitaet der bestehenden
  Suffix-Parser/Vergleiche; D2.10-Neuanker erfasst die Strings ohnehin.
- **OP-8 ENTSCHIEDEN (Manager):** Schaltername `COMDARE_PROVISION_VENDOR_ALLOCATORS` FINAL
  (konsistent mit der COMDARE_VENDOR_*-Familie; keine Nach-Fenster-Umbenennung).
- **OP-9 ENTSCHIEDEN (Manager):** (a) Schritt 0A = PFLICHT im Fenster (Feld nicht gelandet,
  code-verifiziert). (b2) Verlagerung der 0A-Startbedingung ins Fenster BESTAETIGT (LED:3548
  verbatim gegengelesen). IV.6-Doc-Vermerk-Schicht: wird mit Schritt 14 (Paketmeldung +
  Doc-Vermerke nach Landung) erbracht.
- **OP-10 ENTSCHIEDEN (Manager, quellen-gestuetzt RF-3-Flotte + 8er-Docker-Doktrin + §69.2-Analogie):**
  operating_system-Auspraegungs-Katalog = DREI Klassen-Identitaeten `linux` / `windows` / `macos`
  (Familien; deckt die reale Flotte: Win11+WinServer2022, Linux-Docker-Matrix, 2x macOS).
  Distribution/Version (z.B. debian-13/trixie, windows-server-2022, macOS-Version) = STEMPEL-
  VARIABLEN (analog BUILD-Version §69.2), je Maschine deklariert (<machines>), je Runner
  ermittelt. Emitter/Registry-Block folgt dem target_isa-Muster (fixed_enum_tuple). Der
  static_assert :93-94 wird von A3 aufgeloest (Schritt 4).
- **OP-11 ENTSCHIEDEN (Manager, quellen-gestuetzt):** Die Organ-Stempel-Zeile traegt nach A8.2
  ACHTZEHN Eintraege — persistence_target KOMMT REIN. Begruendung: Das 17er-Array ist ein
  golden-neutral-bedingter Nicht-Nachzug der ORG-18-Welle (der Stempel durfte damals nicht
  brechen); OD-1-Stempel-PRINZIP verlangt ALLE Organ-Achsen mit je-Achse-Algorithmus-Version —
  eine fehlende 18. Achse waere eine Stempel-Blindstelle (persistence_target-Drift unsichtbar).
  Golden-Strings ("17 Haupt-Achsen", test_m_w12:339-340) ziehen im Schritt-12-Neuanker auf 18
  nach (D2.10-Checkliste). META-META-EINTRAEGE: KEINE in der Organ-Zeile (RF-7: je Typ EINE
  Array-Zeile; Typ-Trennung) — load_framework stempelt in der MESS-Zeile (Schritt 9),
  System-Meta-Metas in der System-Sphaere. Die vier Stempel-Zeilen bleiben GETRENNT (OD-1).

**FENSTER-START-GATE damit reduziert auf:** (1) P1-Vollzug Infra (Template-Fix) + V-6-Kandidaten
gruen (Retry-Rezept), (2) Manager-Kurzreview Re-Pin-Protokoll 4a am Vergabe-Tag (Pins sind seit
Rev. 3 weitergewandert: super c0613620+, docs-only — 4a-Klassifikation greift), (3) Fenster-Vergabe.

## 11. VERWORFENE BEFUNDE (Adversarial-Pass + Verify-2-Pass 27.07.)

Adversarial-Pass (Rev. 2): Keine. Alle 20 adversarialen Befunde wurden am Code-Ist (Pins
ce 7dd41b18 / super 40ee7349) bzw. an
Ledger/Bauplan nachverifiziert und bestaetigt; saemtliche MAJOR-Befunde und alle MINOR-Befunde sind in
Rev. 2 eingearbeitet (Schritte 0, 0A, 1, 3, 4, 7, 8, 9, 10, 11, 12, 13; Abschnitte 0, 1, 4, 5, 6, 8,
9, 10; neue Punkte Schritt 0A, declared_count in Schritt 11, OP-11; Autoritaets-Korrektur OP-1/OP-5).

Verify-2-Pass (Rev. 3): Keine verworfen. 17 Befunde (3 MAJOR, 14 MINOR; darunter Doubletten
desselben Kerns: CRC-alt->neu 3x, kSystem-Etikett 2x, F0/untracked 2x, XSD-:260 2x) — ALLE am
Code-/Doku-Ist nachverifiziert (u.a. git ls-files-Pathspec-Probe 1 vs. 208 Dateien; super-HEAD
0b8b81ca ueber Pin; test_m_w12:336-344; grep operating_system/GN_PREFIX/sse4/neon/"Variante A";
test_a9b-Kopf UNREGISTRIERT; LED:3548; ceb_version_stamp.hpp in builder/) und ALLE eingearbeitet
(auch alle MINOR — jeweils billige Praezisierungen ohne Scope-Aenderung):
- MAJOR Re-Pin/Basiszahlen + F0-Unerfuellbarkeit -> Kopf-Vermerk, Vorbedingung 4 (getrackt-Klausel,
  untracked-Whitelist) + NEUES Re-Pin-Protokoll 4a, Schritt 0(a)/(c), Abschnitt 4 Punkt 3,
  Schritt-13-Beweis, F0 (Abschnitt 5), Kontext-Fakten.
- MAJOR ASCII-Pathspec-Loch -> `'*CMakeLists.txt'` in Schritt 13 + Abschnitt 8.
- MINOR CRC-Meldeformat -> Abschnitt 8 (Bestaetigungspaar statt alt->neu).
- MINOR kSystem-Etikett -> Schritt 0e + Schritt 12 (:341-342; :339-340 = kOrgan-Ende) + OP-11.
- MINOR operating_system-Edit-Scope -> Schritt 4 Ziel-Dateien + OP-10-Zusatz.
- MINOR Anker R1-Archiv (20 Treffer :71-:242) -> Schritt 11 + OP-1; XSD :260=Kommentar/:314=Element
  -> Schritt 3.
- MINOR "Variante A"-Attribution (0 Treffer) -> Schritt 10(b).
- MINOR sse4.2/neon-Formulierung (V-5a statt Ist) -> Schritt 3; V-5a/V-6 in Abschnitt 9 ergaenzt.
- MINOR test_a9b-Teil-2-Inversion (unregistriert, Hand-Bau-Beleg) -> Schritt 11 Auflage.
- MINOR §72-Startbedingungs-Verlagerung durch 0A -> OP-9(b2) Manager-Bestaetigung.
- MINOR ceb_version_stamp.hpp-Pfad (builder/, nicht abi/) -> Schritt 9.

---

Plan-Ende. Fenster-Start erst nach Klaerung OP-1..OP-11 (OP-1/OP-5 = Owner-Entscheide, Rest Manager)
und expliziter Freigabe.
