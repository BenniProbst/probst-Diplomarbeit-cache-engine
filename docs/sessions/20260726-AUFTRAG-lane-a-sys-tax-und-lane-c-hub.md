# AUFTRAG: Lane A (SYS-TAX) + Lane C (external_utils-HUB) -- EINE koordinierte Welle (26.07.2026)

> ================================================================================
> ## !!! SUPERSEDED 26.07. abends -- NICHT als Bauauftrag verwenden !!!
> ================================================================================
> Dieses Dokument entstand in der Opus-Phase und traegt DREI bestaetigte Fehler + 5 vom
> adversarialen Vorlauf gefundene Blocker. Es bleibt als Historie stehen (Doku-nie-loeschen).
> Der GUELTIGE Bauauftrag ist der konsolidierte Bauplan-v2 (ultracode wf_4d2b7439, adversarial
> geprueft: PLAN NICHT BAUFAEHIG bis die 5 Blocker geheilt sind -> Heil-Runde laeuft).
>
> DIE DREI OPUS-FEHLER in diesem Doc (nicht befolgen):
> 1. Abschnitt 1.3 "System-HAUPT-Achsen sind VIER: ... load_framework" ist FALSCH.
>    load_framework ist eine META-META (erste Meta-Meta unter external_utils), KEINE 4. Haupt-Achse.
>    Die Komplex-Achse hat die Glieder target_isa x operating_system x external_utils x Meta-Metas;
>    load_framework sitzt IM Meta-Meta-Satz von external_utils.
> 2. Abschnitt 1.7 reduziert NUMA/page auf reine "runtime-Unter-Achsen, binary_id=never". FALSCH:
>    Owner-Dual-Natur-KERN = RT-Unter unter ISA an der CEB UND CT-Haupt am Tier (stufen-relativ).
> 3. Paket A6 vergisst AVX512. Richtig: 4 opt x 3 simd (no_extension/avx2/avx512) = 12 System-Perms,
>    Ausschluss maschinenseitig per Freigabe + WARNUNG (nicht stiller Profil-Filter).
>
> DIE 5 ADVERSARIALEN BLOCKER (in Bauplan-v2 zu heilen, Reihenfolge): B-2 Sperrmatrix auf veraltetem
> Baum (2 "NEU"-Dateien existieren schon = A1) -> B-3 5-vs-4-Haupt-Achsen widerspricht dem A1-Header ->
> B-1 Freigabe-Pilot NICHT durchgehend inert (C-3a byte-Neutralitaet neu belegen) -> B-4 NUMA/page ohne
> XSD-/Parser-Schritt (Angebot unerreichbar) -> B-5 page_topology kollidiert mit existierender Achse
> page_type (Namensfalle). Erst nach Heilung: Bau.
> ================================================================================



> AUTORITAET: Owner-KERN > dieses Dokument > Bauplaene > Ist-Code. Grundlage: Verortungs-Brief
> (ultracode wf_8d5b32a5-c0e), Rueckfragen-Aufloesung A-F (wf_bb5d71e9-fdb), new-golden-Suche
> (wf_2330dddf-1c2), Frage-6-Aufloesung (wf_3ed15f5c-7d7), Matrix/NUMA-Plan (wf_dc503d77-596).
> STAND: ORG-18 + B-16/B-17 + (d2) sind GELANDET und dual gepusht (ce dc8e1dc7, super 057ee3e5);
> Manager-Abnahme lief ueber eigenen Frisch-Lauf 314/314 + CRC MATCH + Roundtrip ALLE OK.

===============================================================================
## 0. DAS EINE BYTE-EREIGNIS (wichtigster Satz des Auftrags)
===============================================================================
Der Katalog-golden-Anker ist mit ORG-18 VERBRAUCHT (CRC 0x56F1B721C72DC10E, N=2^17=131072,
POD 1344, ABI-MAJOR 7, CSV 169). **Lane A und Lane C sind binary_id-NEUTRAL**, weil ALLE
System-Achsen `binary_id="never"` tragen (system_axis_registry.xml) und die binary_id
Organ-only ist (§54-T3). Deshalb:
- Es gibt in dieser Welle **KEINEN** Katalog-CRC-Neuanker, **KEINE** 320er-Neumaterialisierung,
  **KEINE** POD-/ABI-/CSV-Aenderung. Bleiben diese Wachen nicht gruen, ist das ein **DEFEKT**,
  nicht eine erwartete Folge.
- Das EINE verbleibende Byte-Ereignis ist ein **STEMPEL-/CACHE-KEY-Neuanker** und liegt im
  **ABSCHLUSS-COMMIT von Lane F (W-13)**. Dort und nur dort werden Suffix-Ordnung,
  cache_key_prefix, Stempel-Golden-Strings und die SHA512-Overlay-Zeile GEMEINSAM neu geankert.
- A3/A7 und Lane F kollabieren daher in EINE Push-Welle mit EINEM Cold-Voll-Neubau. Drei
  getrennte Anker (ORG-18 / A3-Stempel / F-Suffix) waeren drei Cold-Neubauten - untersagt.

===============================================================================
## 1. SOLL-ARCHITEKTUR (Stand nach ALLEN Owner-Entscheiden 26.07.)
===============================================================================
1. Drei Achsen-TYPEN, je eigene Stufe: **Mess -> Planer**, **System -> CEB** (nur Kompilation,
   System und Scheduling der Binary-Basics), **Organ -> Tier** (binary_id Organ-only).
   Die alte Relation "System steuert die Auspraegung der Mess-Achsen" ist OBSOLET.
2. **Ordnungs-Ebene != Steuer-Ebene.** Die bindende Sortierung MESS-TOOLING -> target_isa
   (+scheduling) -> operating_system -> external_utils -> ORGAN T00-T17 -> drei Unter-Ebenen
   regelt Rang/Benennung/Verzeichnis, NICHT Besitz.
3. **System-HAUPT-Achsen sind VIER**: target_isa, operating_system (NEU), external_utils,
   load_framework. compiler ist KEINE Haupt-Achse mehr, sondern die untrennbare
   Unter-Achsen-GRUPPE compiler+opt_level+atomic128; scheduling ist Unter-Achse von target_isa.
4. **external_utils** (Rename von extension_hardware, Schreibweise FINAL) = KOPF/HUB fuer ALLE
   Meta-Meta-Achsen (externe HW, SIMD/AVX, Mess-Framework). load_framework = ERSTE Meta-Meta.
   Meta-Metas sind volle CT-Haupt-Achsen-TYPEN mit eigenen RT-Unter-Achsen, variadisches Array
   OHNE std::variant, Identitaet nur AUFWAERTS kompatibel ab Basis CPU-only.
5. **Komplex-Haupt-Achse** klammert target_isa x operating_system x external_utils x Meta-Metas
   (ohne load_framework) so, dass sie sich wie EINE verhaelt; rekursiv je Layer; nur indirekte
   Identitaet; generischer Wrapper OHNE hartkodiertes Label.
6. **DUAL-NATUR (Owner-KERN 26.07.):** "NUMA und page_type muessen in der CEB fuer eine
   Architektur freigegeben werden, bevor sie tatsaechlich als Tier-Binary gebaut werden, daher
   sind NUMA und page_type eigentlich doch Unter-Achsen unter der ISA zur Laufzeit der CEB und
   compile-time statische Haupt-Achsen bei den Tier-Binaries, es gibt mehrere solcher
   zwei-geteilter Faelle." Register:
   | Achse | RT-Unter an | CT-Haupt an |
   | Mess-Tooling | Planer | CEB |
   | load_framework | Planer | CEB (letztes Glied, erste Meta-Meta) |
   | compiler/opt_level/atomic128 | CEB | Tier |
   | NUMA/locking | CEB, unter der ISA | Tier |
   | page_type | CEB, unter der ISA | Tier |
   | SIMD/AVX (Meta-Metas) | CEB (external_utils gibt frei) | Tier |
   CT-Haupt AM TIER heisst: einkompiliert + gestempelt (System-Array [d,e,f]) - NICHT
   binary_id-Segment. Deshalb bleibt golden unberuehrt (Abschnitt 0).
7. **NUMA/locking - der ISA-Test faellt NEGATIV** (live belegt: gesamte Flotte 1 Socket /
   1 NUMA-Node; libnuma.so vorhanden, numa.h fehlt; Node-Zahl/Distanzen/Policy sind NICHT
   compile-statisch erkennbar). Also gilt der Sonst-Zweig des Owner-Satzes: **dynamische
   runtime-Unter-Achsen `numa_bind_policy` + `lock_regime` unter target_isa**, binary_id=never.
   Ein zweiter NUMA-Wert waere eine Messwert-Luege der Q-1-Klasse.
8. **page_type bleibt ZWEIGETEILT und existiert schon**: RAUM = System-Capability
   `page_topology` (axis_12 HW4, Bausteine 4k/2m/1g), DURCHSETZUNG = Organ-NTTP `AllocPageHint`
   (alloc_hw.page, 2m->4k-Degrade). **NAMENSFALLE (bindend):** `axis_01_page_type` ist der
   BAUM-Knoten-PageKind (6 Seitentypen: DenseByte, ExtendedDense, SparsePatricia, Redirect,
   CustomCache, BPlus) - er wird NICHT umbenannt, bekommt KEINEN System-Registry-Eintrag und
   KEINEN 19. Kompositions-Slot (§52-B10).
9. **Zwei-Adressen-Regel (Owner):** jedes nicht-gattungsbezogene technische Detail, das in
   multiple Algorithmen-Details UND OS-Bibliotheken muendet, ist HAUPT-SYSTEM-Achse
   (= BIBLIOTHEK) und liegt ZUGLEICH als Verwendung/Implementierung in Organ-Achsen ueber
   spezifische Interfaces (= INITIALISIERUNG). Analog Modules vs Produktfassaden.
10. **Stempel:** Klammer-ANZAHL kodiert die Ebene (CEB [[a,b,c]] / Tier [[d,e,f],[g,h,i]] /
    Mess-CSV dreifach), NIE verschmolzen; nur HAUPT-Achsen im Stempel; Binary hat KEINE eigene
    Version (nur der Planer); + consteval-SHA512-Zeile ueber Achsen-Strings + Versionen +
    Overlay-Source-Hashes. Das build_version-SUFFIX ist NICHT der Stempel.
11. **opt-Permutation:** Voll-Bau permutiert O0/O1/O2/O3 x {no_extension, avx2} = 8 System-Perms
    (Owner: "wie schon gehabt und geplant ueber alle verfuegbaren Stufen ... in der Regel
    O0,O1,O2,O3"). cmake=Release. **Ofast bleibt AUS** (IEEE-754-/CRC64-Determinismus).
    Matrix-Ordnung **O3, O2, O1, O0** - die aussagefaehigen Zeilen zuerst. Cache-Line-Beweise
    laufen explizit unter -O3 und NIE aus einem Debug-Lauf.
12. **Test-Skip (Owner):** Der Voll-Build testet immer hart die GANZE Pipeline, AUSSER Binaries
    und Messungen, die bereits vorhanden und gruen-getestet eingepflegt wurden. Mechanik: die
    CEB testet gebaute Binaries am PRUEF-DOCK vor der Messung, die Lagerhaltung notiert die
    Test-Funktionalitaet als LOG neben dem Ziel-Speicherort der Binary; positives Log =>
    Skip fuer genau diese Binary. Das ist LAGERHALTUNG, **nie** ein Job-/Trigger-Skip; das
    Voll-ctest-Gate bleibt hart.

===============================================================================
## 2. LANE A - ARBEITSPAKETE (Reihenfolge BINDEND)
===============================================================================
Je Paket: eigene ultracode-Planung VOR der Ausfuehrung; je Commit baubar; ASCII-Selbstcheck
DIFF-GETRIEBEN (Pruefmenge aus `git diff --name-only`, NIE handgepflegte Liste); beim Editieren
von Bestands-Zeilen mit Umlauten/Pfeilen mit-transliterieren; Working-Tree-FREEZE nach jeder
Paketmeldung; KEIN Commit, KEIN Push (macht der Manager).

**A1 VORBEDINGUNGEN (byte-neutral, keine Stempel-Wirkung)**
- topics/axis.hpp:17-21 AxisKind um `system_meta_meta` erweitern; CebSubAxis-Wurzel als Typ
  (heute nur String-Konvention). KEIN festes 3. Level - offene Rekursion, EIN Concept fuer alle
  Achsen, Unter-Achse = Voll-Achse (Layer-Modell D4).
- NEUER Header `kSystemAxisOrder` als Single-Source (zunaechst mit dem IST-Inhalt).
- V1-Neuschnitt fuer Lane C: `meta_metas` als **mp_list-TYPliste + constexpr subsumes**, NICHT
  `std::span<MetaMetaDescriptor const>` (Layer-Modell D3: Meta-Metas sind Typen, keine Daten).
- GATE: ce-unit 314/314 unveraendert; KEIN Stempel-Byte-Diff (literal nachweisen).

**A2 RENAME extension_hardware -> external_utils (EIN Commit; aus Lane C herausgeschnitten)**
- Dateien: tools/system_axis_registry_gen/main.cpp (8 Treffer + stdout-Literal :334), generierte
  system_axis_registry.xml:53-55, include/cache_engine/abi/system_axis_code_versions.hpp:32-38,
  builder/profile_facade/validate_profile.hpp (11), libs/common/serialization/xml_config_parser
  .{hpp,cpp} (8/7), extension_hardware_family_axis.hpp (24), measurement/simd_sub_axis.hpp,
  4 A-Tests.
- GATE: `registry_roundtrip.cmake` Byte-Diff==0 im SELBEN Commit; Stempel-Fixtures
  test_m_w12_stamp_bausteine.cpp:261/267-269/338 im selben Commit neu geankert.
- SPERRMENGE: extension_hardware_system_axis.hpp und hardware_isa_system_axis.hpp bleiben
  byte-stabil (nur Deprecate-Kommentar mit Neu-Namen). Lane-F-Dateien TABU.

**A3 SYS-TAX ORDNUNG (Herzstueck)**
- `kSystemAxisOrder` FINAL: [0] target_isa (Unter: scheduling(+5 sub_dim), compiler-GRUPPE
  compiler/opt_level/atomic128) - [1] operating_system NEU (Unter: os_version, kernel, build -
  **Update-Zustand IST IN `build` gemerged**, Owner-Entscheid; XML-erweiterbar PFLICHT) -
  [2] external_utils (HUB; Unter: simd, Meta-Meta-Array) - [3] load_framework (erste Meta-Meta,
  CT-Haupt an der CEB / RT-Unter am Planer; Unter: workload; on/off-Token im Namen).
- system_axis_code_versions.hpp:28 kCount 5->4 + static_assert :49-50; Generator-Blockfolge;
  XML-Regen; parse_system_axes (xml_config_parser.cpp:98-116) 4. POD; experiment_schema.xsd:43,
  245-340; RegistryTrio.system_axis_count (validate_profile.hpp:696-698); test_validate_profile
  .cpp:289, test_experiment_plan_director.cpp:112/308; test_striktheit_axis_dach_guard.cpp;
  plan_legend.hpp:102-105.
- NEUE WACHE (Pflicht): compile-time static_assert "Suffix-Emitter-Reihenfolge ==
  kSystemAxisOrder == XML-Kopf-Reihenfolge" (heute nur "5 Eintraege nicht leer" = Drift-Luecke).
- ERWARTUNG literal zu belegen: der Absenz-Pin test_experiment_plan_director.cpp:124 (numa==0)
  BLEIBT gruen, weil numa Unter-Achse wird - nur der Kommentar zieht nach.
- SPERRMENGE: keine Organ-Slots; axis_path_serialization.hpp und source_catalog.hpp TABU.

**A4 NUMA/locking als runtime-Unter-Achsen unter target_isa**
- Generator-sub_axis-Block + XML: `numa_bind_policy` {auto, node0, interleave(gated)} +
  `lock_regime` {futex, cx16_cas}, stage=runtime, binary_id=never.
- `check_include_file(numa.h)` + `find_library` -> `COMDARE_HAVE_LIBNUMA` (Muster der
  jemalloc/mimalloc-Gates). Read-only Ist-Notiz prod1/prod2 (/sys/devices/system/node,
  /proc/self/status) - **kein Install**, numactl nicht noetig.
- GATE: KEIN Suffix-Token, KEINE Stempel-Zeile (Unter-Achse -> CSV-Spalte); Binary-Cache bleibt
  gueltig.
- SPERRMENGE: concepts/numa_affinity.hpp + concepts/locking_mode.hpp NICHT loeschen
  (Deprecated-Insel); HLE/RTM-Baustein NICHT bauen (flottenweit tot).

**A5 page_type-Zweiteilung sichtbar machen + Namensfallen-Guard**
- axis_12 HW4 `page_topology` bekommt die Bausteine 4k/2m/1g; alloc_hw_config.hpp UNVERAENDERT.
- Guard-Test "kein System-Registry-Eintrag namens page_type" + Doku-Anker;
  cacheline_study.profile.xml:52-59 als Referenz.
- GATE: NULL POD/ABI/CSV-Aenderung; profil-gated (profile_to_tree.hpp:81-89 beweist Neutralitaet).
- SPERRMENGE: KEIN 19. Kompositions-Slot, KEIN <system_axes>-Kanal fuer axis_01 - beides erst
  NACH dem Trigger. MAP_HUGETLB-Scharfstellung ist GO-pflichtig, hier NICHT.

**A6 opt-Permutation O0/O1/O2/O3 x {no_extension, avx2} = 8 System-Perms**
- optimization_level_sub_axis.hpp (Options + Default O3 :128/:142), all_axes_golden.profile.xml
  :186-198, tests/unit/thesis_tiere/experiment_golden.xml:67-83, perm_opt_level_cflags,
  plan_legend.hpp system_perm, profile_run_facade.cpp:326-332/499/529/1004/1030,
  profile_run_entry.hpp:729/780.
- GATE: Ofast bleibt AUS; Debug-Weg unveraendert -O0 -g mit +bt=Debug; Cache-Line-Beweis bleibt
  explizit -O3 am Target test_all19_segment_timer (tests/unit/CMakeLists.txt:1787-1796).
  Matrix-Ordnung O3, O2, O1, O0.

**A7 STEMPEL (Board-Posten A-II/A-III)**
- anatomy_version_stamp.hpp:64-104: System-Array **systemisch erweiterbar** statt 5-fix;
  Organ-Meta-Meta-Haupt-Achsen-Array + eigener Stempel fuer den von der CEB materialisierten
  Compile-Raum; SHA512-Overlay-Zeile consteval. Nachzieher: lazy_adhoc_source_gen.hpp:199-201,
  adhoc_emitter.hpp:94, pilot_source_map.hpp:52-56.
- GATE: Stempel-Zeilen bleiben VIER getrennte, nie verschmolzen; system_stamp_line bleibt
  mess-blind. Der Golden-STRING-Neuanker gehoert NICHT hierher, sondern in den Lane-F-Abschluss.

===============================================================================
## 3. LANE C - GESPALTEN (GO nur fuer C-1/C-2/C-3/C-5)
===============================================================================
- **GO:** C-1 Meta-Meta-Typ-Familie - C-2 Halbordnung/`subsumes` auf TYPEN - C-3 Hub-Mechanik in
  extension_hardware_family_axis.hpp - C-5 Tests (unregistriert).
- **KEIN GO:** C-4 (Generator-Reflexion) und der RENAME - beide sind als **A2** an Lane A
  gehaengt, weil die Roundtrip-Wache Byte-Diff==0 erzwingt und der Generator zu A gehoert.
- **SPERRMENGE fuer C:** die 6 A-Dateien + 4 A-Tests + die 8 G4b-1-Dateien (profile_run_facade
  .cpp, profile_run_entry.hpp, experiment_run_entry.hpp ...) + extension_hardware_system_axis.hpp.
- **Vorbedingung** vor dem ERSTEN C-Commit: A1 liefert den V1-Neuschnitt (mp_list-Typliste).
  Bis A2 landet, arbeitet C unter dem ALTEN Namen mit Stub `active_machine_signature()={}` und
  rein additiven Zellkoordinaten.
- Aufwaerts-Identitaet: numa/lock erscheinen als Unter-Achsen und beruehren Lane C gar nicht.

===============================================================================
## 4. LANE F (W-13) = ABSCHLUSS-COMMIT DER A-WELLE
===============================================================================
Seriell NACH A. Zuerst die T-c-Golden-STRING-Wache, dann Single-Source `build_version_suffix`
in NEUER Draht-Folge:
  `+target=[+sched=][+cxx=[+opt=][+atomic=]] +os= +ext=[+simd=] +lf=[+wl=] +ceb=<maj>.<min> +bt=`
Die drei heute konkurrierenden Ordnungen (profile_run_facade.cpp:378-380, profile_run_entry.hpp
:780-781, print_cache_key_facade :1095-1097) werden auf die perm-loop als Koerper VEREINT;
`system_axes_version_suffix` delegiert; `+ceb` bleibt LETZTES Segment; `+mtool=`/`+mrg=` bleiben
am ENDE des cache_key_prefix (artifact_cache.hpp:245-248) - Mess wird NICHT auf Position 1
gezogen. **Atomaritaet ist Pflicht:** Suffix + cache_key_prefix + Stempel-Anker in EINEM Commit,
weil alle .version-Sidecars und minio-Keys in dieser Sekunde invalid werden.

===============================================================================
## 5. REST-GATES BIS VOLL-BAU-4
===============================================================================
- G1/G2 ERLEDIGT (ORG-18 + B-16/B-17 + Join gelandet, dual gepusht, Manager-verifiziert 314/314).
- G3 Lane A A1-A7 + Lane C (C-1/2/3/5) parallel unter Sperrmengen.
- G4 Lane-F-Abschluss = das EINE Byte-Ereignis; danach bis zum Trigger KEINE weitere
  Byte-Aenderung.
- G5 vier lokale Beweise literal (GN_DECISION=skip - Hydration verified>0 UND pruned>0 -
  Variant-Gate-E2E - Bestandslog-E2E gegen minio) + Kandidat 5: B+-Baum-Steuerungs-Nachweis.
- G6 Lokale Voll-Bau-Verifikation OHNE die bekannten Luecken: J-0 Alt-Build-Dirs sind
  Beweis-GIFT (frisch bauen oder Binary-Alter pruefen) - J-1 Werkzeuge zuerst (adhoc_emitter_cli,
  catalog_codegen, alle *_registry_gen, gen_golden_fullpilot) - J-2 RE-CONFIGURE (Codegen laeuft
  dort) - J-3 comdare_limits_generated_source_catalog explizit - J-4 Voll-Bau -> Fassade
  comdare_profile_run_facade explizit -> Voll-ctest - J-5 Test-Zahl N IMMER mitmelden
  ("100% passed" ohne N ist kein Beweis).
- G7 Trigger: POST /projects/288/pipeline ref=development, GOLDEN_N + STORAGE_CACHE +
  BESTANDSLOG + DOC_KEY + OWNER_UUID + MASCHINE, 24/24, df-/Cron-Wachen,
  COMDARE_MINIO_ENDPOINT-Preflight (mc alias list; Alias, NIE S3-URL), PMC-AND-Gate,
  keine schweren parallelen CI-Jobs.
- RISIKO-NOTIZ: 8 System-Perms verdoppeln die Bau-Matrix gegen die alte {O2,O3}-Annahme
  (N bleibt 2^17). Gegenmittel: Matrix-Ordnung O3/O2/O1/O0, Lagerhaltungs-Skip fuer gruen
  inventarisierte Binaries, Dual-ccache (minio=Binaries, NAS=Mess-CSV). KEINE Reduktion der
  Stufenliste.

===============================================================================
## 6. OFFENES ARBEITSPAKET, NEU EROEFFNET: XML-DEAKT
===============================================================================
Der Owner-Satz "Die Achse wird per XML deaktiviert und das muss unterstuetzt sein" ist NICHT
erfuellt: der wirksame Hebel liegt in CMakeLists.txt:381 -> flags.hpp.in:15 ->
axis_persistence_target_registry.hpp:31 (`EnabledTargets = mp_filter`); die XML spiegelt die
Abwahl nur durch ABWESENHEIT. Das ist eine Umkehrung von §27 (Registry = ANGEBOT, Anwender-XML =
ANZEIGE). SOLL: `active="true|false"` am `<axis ref>` der Anwender-XML, vom Resolver in die
Bausteinmenge gefuehrt. Schritte 1-4 (Schema, Parser, Resolver, Guard-Test) sind jetzt baubar;
der `declared_count`-Schritt gehoert ins offene Byte-Fenster (Lane F).

*Erstellt 26.07. ~17:4x vom Manager. Aenderungen nur additiv annotieren.*
