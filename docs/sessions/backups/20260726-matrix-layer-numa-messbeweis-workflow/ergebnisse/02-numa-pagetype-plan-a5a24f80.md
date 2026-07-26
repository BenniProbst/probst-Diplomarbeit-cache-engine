# 20260726-matrix-layer-numa-messbeweis-workflow / numa-pagetype-plan (agent a5a24f80)

runId: wf_dc503d77-596
agentId: a5a24f80d335114a5
label-Zuordnung: numa-pagetype-plan (Prompt-Marker-Deckung 75%)

---

BAUPLAN-SKIZZE E-08 (STRUKT-R): 7. System-Achse NUMA/locking + page_type + Meta-Meta-Definition -- PLAN ONLY, kein Code geaendert.

== IST-RESTE (literal verifiziert, nicht geraten) ==
R1 NUMA lebt schon als ORGAN-Unter-Achse: `alloc_hw.numa_node {auto,0,1}` + `alloc_hw.page {4k,2m}` in
   libs/cache_engine/axes/alloc/alloc_hw_config.hpp (AllocNumaNode/AllocPageHint, `gate_alloc_hw_for<HW>()`:95,
   `alloc_hw_page_bytes_for`:106); Baum-Naht profile_to_tree.hpp:81-89 (statische Sub-Ebenen NUR profil-aktiviert);
   Validat validate_profile.hpp:206-208 + :776 (Sonderzweig, nicht Registry-geprueft); Parser xml_config_parser.cpp:277-279;
   Konsumenten axis_06_allocator_numalloc.hpp:53 (kDefaultNumaNode) + axis_06_allocator_pool_resource.hpp:195.
   EINZIGES aktivierendes Profil: algorithm_profiles/thesis_profiles/fb_numa_page_study.profile.xml:49.
   SCHEMA.md:27 sagt selbst: "der NUMA-EFFEKT braucht Multi-Socket-Hardware; der Knopf existiert + ist dokumentiert".
R2 CT-Faehigkeits-Gate existiert: axis_12_general_hardware `numa_capable()` (x86_64:36 true, aarch64:34 true,
   generic:38 false) + Unter-Achsen-Tags HW3 `memory_topology_tag` (UMA/NUMA/unified/HBM/CXL) und HW4
   `page_topology_tag` (4K/16K/2M/64K/1G) -- HW3/HW4 sind reine TAGS, KEINE Bausteine.
R3 Laufzeit-Naht existiert: slurm_launcher.hpp:66 `numactl --cpunodebind=<n> --membind=<n>` (KF-12-Lauf-Praefix).
R4 Deprecated-Insel (NICHT loeschen): concepts/numa_affinity.hpp (NumaStrategy) + concepts/locking_mode.hpp
   (LockingMode incl. Upgradeable), 0 Konsumenten, Dossier-23-Delta-TODO.
R5 locking ORGAN-seitig VOLL da: T08 concurrency, 9 CRTP-Organe (blocking/reader_writer/olc/lock_free/wait_free/
   rcu/hazard_pointer/...) + Unter-Achse CC1 synchronization_pattern; `atomic128 {no_cx16,cx16}` ist compiler-Unter-Achse.
R6 ANTI-ANKER: tests/unit/thesis_tiere/test_experiment_plan_director.cpp:124
   `EXPECT_EQ(trio->system.axis_names.count("numa"), 0u) << "NUMA (7. Achse) korrekt abwesend (=S11)"` --
   die 7. Achse ist heute AKTIV WEGGEPINNT (S2/A2-P-SYSREG). Bau = bewusster Pin-Bruch.
R7 page_type: DREI verschiedene Dinge (Namensfalle §52-B10, wortwoertlich dokumentiert in
   cacheline_study.profile.xml:52-59): P1 = topics/nodes/axis_01_page_type = BAUM-KNOTEN-Seitenstruktur,
   6 Pflicht-Typen (DenseByte/ExtendedDense/SparsePatricia/Redirect/CustomCache/BPlus, _registry.hpp:20-21),
   Unter-Tags PG1 structure_role/PG2 density_class/PG3 path_collapse; heute build-only als
   `T17_page_type` in registry_to_axis_levels.hpp:113-122, `DefinitionOnly` (axis_observer_classification.hpp:79),
   NICHT in kCompositionAxisNames, permutiert NIE, hat KEINEN <system_axes>-Parser-Kanal.
   P2 = alloc_hw.page {4k,2m} (Huge-Page an der Allocator-Kante). P3 = axis_12 HW4 page_topology (nur Tag).
R8 STAND (ORG-18 + MODE sind LANDED, nicht neu planen): kCompositionAxisNames = 18 (axis_path_serialization.hpp:39-42,
   persistence_target als T17-Anhang), FullSourceCatalog = CatalogAxes<2 x17, 1> = 131072 (source_catalog.hpp:139),
   golden-CRC neu 0x56F1B721C72DC10E (:189), ABI-MAJOR 7, kV3AxisCount 18, POD sizeof 1344, Snapshot-Version 8,
   CSV 169 mit 2-Generationen-Reader (result_ingest.hpp:93,103-105: 169 aktuell / 160 legacy),
   kRunMethodologyCount = 4 inkl. Compare (run_methodology_registry.hpp:41,45,78). kSystemAxisCodeCount = 5.
   `kSystemAxisOrder` existiert NICHT (grep = 0 Treffer) -> RISS-2-Blocker der §1-Sortierung ist offen.

== (a) BAUPLAN-SKIZZE nach ORG-18-Muster ==
--- ACHSE 1: NUMA/locking ---
Variante S-1 (7. System-HAUPT-Achse, CT): neue CebSystemAxis `memory_locking` in
  include/cache_engine/measurement/memory_locking_system_axis.hpp (Vorbild target_isa_system_axis.hpp:33/:64/:73),
  Bausteine `uma_local` (enabled) + `numa_multi_socket` (enabled=false, XML-deaktivierbar per ABNAHME Q-1),
  Unter-Achsen `numa_binding {auto,node0,node1,interleave}` + `lock_primitive {futex,cx16_cas,hle_rtm(off)}`
  als CebSubAxis-Familien (Vorbild optimization_level_sub_axis.hpp:37/:41).
  SLOTS/POD/ABI/CSV: NULL -- System-Achsen tragen `binary_id="never"` (system_axis_registry.xml:10,53,98,102,114).
  ABI-MAJOR bleibt 7, POD bleibt 1344, kV3AxisCount bleibt 18, CSV bleibt 169. KEIN golden-N-Bruch (2^17 haelt).
  BRUCH-KETTE: (1) abi/system_axis_code_versions.hpp:28 Count 5->6 + Tabelle :32-38 + static_assert :49-50;
  (2) dadurch `system_stamp_line()` (anatomy_version_stamp.hpp:64-79) BYTE-anders -> test_m_w12_stamp_bausteine.cpp:
  261/267-269/338 rot; der Stempel geht in den GENERIERTEN AdHoc-Quelltext (lazy_adhoc_source_gen.hpp:199-201,259,
  adhoc_emitter.hpp:94, pilot_source_map.hpp:52-56) -> jede Tier-Binary byte-anders -> Cold-Voll-Neubau;
  (3) Generator-Block in tools/system_axis_registry_gen/main.cpp (Muster :244-256) + stdout-Literal :334 +
  XML im SELBEN Commit regenerieren (registry_roundtrip.cmake:55-66, CMakeLists.txt:3822-3831);
  (4) RegistryTrio.system_axis_count() 5->6 (validate_profile.hpp:696-698) -> test_validate_profile.cpp:289,
  test_experiment_plan_director.cpp:112/308 + Pin :124 umdrehen; (5) parse_system_axes 3-Parameter-Signatur
  (xml_config_parser.cpp:98-116) braucht 4. POD + XSD experiment_schema.xsd:43,245-340;
  (6) Suffix-Token (z.B. `+mem=`) in system_axes_version_suffix (profile_run_facade.cpp:364-400) UND
  artifact_cache.hpp:216-220 cache_key_prefix -> ALLE .version-Sidecars + minio-Keys invalid;
  (7) Achsen-Dach-Guard test_striktheit_axis_dach_guard.cpp neue Label-/parent-Zeilen;
  (8) plan_legend.hpp:102-105 `system_perm(opt,simd)` (heute 2 Tokens) + 7 Director-Aufrufstellen.
Variante S-2 (dynamische System-UNTER-Achse unter target_isa) -- Owner-Konditional-Zweig:
  `numa_binding` mit parent_axis_label()=="target_isa", stage="runtime".
  KOSTEN: kein kSystemAxisCodeCount-Bruch (Unter-Achsen stehen NICHT in der 5er-Stempel-Tabelle) -> KEIN
  Stempel-Byte-Bruch, KEIN Suffix-Token (Laufzeit-Unter-Achse = CSV-SPALTE, LEDGER-SECTION-18:48/16:87),
  keine RegistryTrio-Zahl, kein Sidecar-/minio-Invalid, bestehender Binary-Cache bleibt gueltig.
  Nur: Generator-sub_axis-Block unter :244-256 + XML-Regen + Dach-Guard-Zeilen. Voraussetzung fuer Typ-Sauberkeit:
  CebSubAxis-Wurzel (RISS 1, heute nur String-Konvention).
--- ACHSE 2: page_type ---
Variante P-A (ORGAN, 19. Kompositions-Slot T18): volle ORG-18-Kette erneut: kCompositionAxisNames 18->19
  (axis_path_serialization.hpp:39-42) + serialize_from_slots-Array + AdHocComposition-Template-Params/usings/
  static_assert (composition_factory.hpp) + IsComposition + composition_organ_count 18->19 (organ_count()=ABI-Symbol);
  GenusBindingTraits<SearchAlgorithm> slot_count 18->19 (11/13/9/5 nur bei Teilung); anatomy + abi_adapter harte
  Indizes (axis_stats[18], acc[19], Reset); kV3AxisCount 19, kV3AxisSchema 19. Zeile, POD 1344->1416,
  Snapshot 8->9, ABI-MAJOR 7->8; CSV 169->178 (result_ingest fields_for + 3. Generation im Reader);
  source_catalog 19. K-Param + FullSourceCatalog + static_assert + kNewGolden-CRC NEU (3. Anker);
  T17_page_type aus build_system_axis_levels RAUS in append_composition_tail; axis_registry_gen make_axis + XML-Regen;
  34 Kompositionen/Tests je 19. `using`; all_axes_golden.profile.xml 19. axis + active_axes + cap.
  ZUSATZ: DefinitionOnly -> Observed heisst 6 echte Observer-Feldsaetze (8 Felder je Achse) bauen.
Variante P-B (SYSTEM, EMPFEHLUNG Stufe 1): P1 bleibt build-only, bekommt aber (a) einen echten
  <system_axes>-Parser-Kanal -- exakt die Luecke, die cacheline_study.profile.xml:56-58 selbst benennt --
  und (b) eine CebSystemAxis-Klammer `page_structure` (stage=ct, 6 Bausteine per Reflexion aus EnabledPageTypes),
  damit die CEB sie als BAU-VARIANTE (flacher System-Achsen-ORDNER, LED §16.2-M2) permutiert statt als binary_id-Segment.
  SLOTS/POD/ABI/CSV: NULL. Kosten = Klasse S-1 (Punkte 1-8 oben, Suffix-Token `+pg=`).
Variante P-C (billigste): "Cache-Awareness-Page" = P2/P3; alloc_hw.page-Knopf bleibt wie er ist, HW4 bekommt
  Bausteine (4k/2m/1g). NULL golden-Wirkung solange profil-gated (bewiesen: profile_to_tree.hpp:81-89).
--- META-META-DEFINITION (kein Bau, Taxonomie) ---
"Haupt-Achsen eines statischen Arrays unter einer Manager-Haupt-Achse = Meta-Meta-Achsen" braucht
  AxisKind::system_meta_meta in topics/axis.hpp:17-21 (heute NUR organ/system_measurement/system_config -> R-C/R-E/R-F
  haben keinen Diskriminator) + Doku-Anker neben der noch fehlenden kSystemAxisOrder-Tabelle. HUB = extension_hardware
  (R-E). NACH dieser Definition ist NUMA/locking KEINE Meta-Meta (kein Beschleuniger-Geraet unter dem HUB) ->
  echte 7. Haupt-Achse oder ISA-Unter-Achse; page_structure ebenfalls KEINE Meta-Meta.

== (b) COMPILE-STATISCHE ERKENNBARKEIT (konkret, live gemessen) ==
FLEET-FAKT: diese Maschine (prod1-Klasse, `Model name: AMD Ryzen 9 9950X3D`) meldet `Socket(s): 1`,
  `NUMA node(s): 1`, `/sys/devices/system/node/` enthaelt NUR node0. prod2 = i9-14900KS (1 Socket),
  odroid = Gracemont (1 Socket). => auf der GESAMTEN Mess-Flotte hat die NUMA-Achse GENAU EINEN ehrlichen Wert.
  Ein 2. Wert (node1/interleave) ist die gleiche Messwert-Luege wie disk_writeback (ABNAHME Q-1 REVIDIERT).
LIBNUMA: `/usr/lib/x86_64-linux-gnu/libnuma.so.1` vorhanden, `/usr/include/numa.h` FEHLT (kein libnuma-dev).
  Ein `#include <numa.h>`-Achsen-Koerper kompiliert heute auf prod1 NICHT. Wege: (i) `check_include_file(numa.h)` +
  `find_library(numa)` -> `#cmakedefine01 COMDARE_HAVE_LIBNUMA` (identisch zum bestehenden jemalloc/mimalloc-HAVE-Gate
  der Allocator-Achse, Baustein deaktiviert sich selbst); (ii) ohne libnuma: `mbind`/`set_mempolicy`-Syscalls
  (header-frei) oder deklarativ + numactl-Praefix (slurm_launcher.hpp:66, existiert schon).
ECHT CT-ERKENNBAR: numa_capable() als ZIEL-Klassen-Aussage (axis_12, schon da) · HAVE_LIBNUMA (configure-time) ·
  huge_page_capable + alloc_hw.page-Werte · `std::atomic<T>::is_always_lock_free` (echter constant expression) ·
  cx16 (existiert als compiler-Unter-Achse).
NICHT CT-ERKENNBAR: Node-Zahl, Node-Distanzen, aktive Interleave-Policy, CCD-/V-Cache-Affinitaet, P/E-Core-Karte.
  LEDGER-SECTION-16:87 hat genau das schon entschieden: "P/E-Core ... DYNAMISCHE Unter-Achse unter der
  Hardware-Systemachse (neben NUMA, Multithreading); statische Compile-Time-Einrichtung ist sinnlos".
TSX: HLE/RTM auf Zen 5 gar nicht vorhanden und auf Raptor Lake per Microcode abgeschaltet -> ein `-mrtm`-Baustein
  waere auf der ganzen Flotte tot (Vorbild-Pruefung wie simd_feature_catalog moeglich, Ergebnis aber leer).
FOLGERUNG: der Owner-Test "sofern compile-statisch erkennbar" FAELLT fuer den Topologie-Teil und BESTEHT nur fuer
  den Faehigkeits-Teil (der schon existiert). Das Konditional selbst waehlt damit S-2. S-1 waere eine CT-Haupt-Achse
  mit genau einem ehrlichen Wert.
NEBENFUND: die prod1-CCD-Asymmetrie (9950X3D: CCD0 96+32 MiB V-Cache, CCD1 ohne;
  docs/architektur/04_konzepte_saeule_b.md:78) IST ein realer Lokalitaets-Effekt und IST messbar -- aber sie ist
  NICHT NUMA. Ort: scheduling-Unter-Dim `hetero_core_dispatch` (system_axis_registry.xml:109) bzw. eigene
  CCD-Affinitaets-Unter-Achse; Mittel = taskset-Praefix, nicht Compile-Flag.

== (c) KONFLIKT-/SPERRMENGEN gegen Lane A / C / F ==
Lane A (SYS-TAX R-A..R-E): HARTER Konflikt, IDENTISCHE Dateien -- system_axis_code_versions.hpp:28/:32-38,
  system_axis_registry_gen/main.cpp Blockfolge + :334, die generierte system_axis_registry.xml (Byte-Gate),
  RegistryTrio-Zahlen, parse_system_axes + XSD, test_striktheit_axis_dach_guard.cpp. E-08 ist ein ADD eines
  6./7. Eintrags, Lane A ist Umsortierung + 2 Entnahmen (scheduling->Unter, compiler->Unter-Gruppe). Getrennt
  ausgefuehrt = XML-Regen und Stempel-Byte-Neuanker ZWEIMAL. SPERRMENGE: E-08-NUMA gehoert ALS TEILSCHRITT A-V
  IN Lane A. Vorbedingungen von Lane A gelten mit: CebSubAxis-Wurzel + AxisKind::system_meta_meta (RISS 1) und
  die fehlende kSystemAxisOrder-Single-Source (RISS 2, grep = 0 Treffer).
Lane C (IDENT, inert/byte-neutral): kein Datei-Konflikt, aber SEMANTISCH: die R-E-Aufwaerts-Identitaet
  ("GPU einbauen -> CPU-only laeuft weiter") braucht eine Subsumptions-Relation. Eine NUMA-Haupt-Achse, deren
  einziger ehrlicher Wert uma_local ist, macht jede multi-socket-Identitaet flottenweit invalid -> numa_multi_socket
  MUSS als AUFWAERTS-Erweiterung von uma_local modelliert werden. Bei S-2 bleibt Lane C voellig unberuehrt.
Lane F (W-13 Suffix + cache_key_prefix): HARTER Konflikt bei S-1/P-B. Jeder neue Stempel-Eintrag oder Suffix-Token
  aendert system_axes_version_suffix (profile_run_facade.cpp:364-400) + artifact_cache.hpp:216-220 -> ALLE
  .version-Sidecars + minio-Keys invalid, und Lane F sortiert genau diese Tokens gerade um. Der neue Token MUSS im
  SELBEN Commit wie die Lane-F-Umsortierung liegen (HANDOVER-6 §4.3 "Atomaritaet: Suffix + cache_key_prefix EIN Commit").
  Bei S-2/P-C (kein Token, CSV-Spalte) ist Lane F FREI.
page_type P-A vs ORG-18: reoeffnet den gerade geschlossenen Bruch -- ABI 7->8, POD 1344->1416, CSV 169->178,
  3. golden-CRC-Neuanker. Bei Frist Mo 27.07. (2 Tage Bau + 2 Tage Messen) das groesste Einzelrisiko im STRUKT-R-Satz.
Trigger/Beweise: jede Stempel-Byte-Variante invalidiert die Bestandslog-Claim-Keys und erzwingt Cold-Voll-Neubau
  (2^17) -> Bau-Fenster-Schaetzung aendert sich. NUR S-2/P-C halten den bestehenden Binary-Cache gueltig.
Freeze-Pflicht: der numa-Absenz-Pin test_experiment_plan_director.cpp:124 muss im SELBEN Commit wie die XML-Regen
  umgedreht werden, sonst ce-unit rot.

== (d) OWNER-FRAGEN, die VOR dem Bau beantwortet sein muessen ==
Q-E08-1 page_type-Disambiguierung: welches der drei? P1 Knoten-Seitenstruktur (6 Typen, heute build-only) /
  P2 alloc_hw.page (4k/2m Huge-Page) / P3 axis_12 HW4 page_topology. Der Code warnt selbst, dass diese
  Verwechslung schon einmal passiert ist (§52-B10-Namensfalle, cacheline_study.profile.xml:52-59).
Q-E08-2 Falls P1: ORGAN (19. Slot; ABI 7->8, POD 1344->1416, CSV 169->178, 3. CRC-Anker; N bleibt 2^17 bei K=1
  bzw. 2^18 bei K=2) oder SYSTEM (eigener <system_axes>-Kanal, binary_id-neutral, Ordner-Dimension, NULL POD/ABI/CSV)?
  Empfehlung: SYSTEM jetzt, ORGAN nach dem Trigger.
Q-E08-3 NUMA: bei gemessener Flotte 1 Socket / 1 Node und fehlendem libnuma-dev -- S-1 (7. CT-Haupt-Achse mit einem
  ehrlichen Wert) oder S-2 (dynamische System-Unter-Achse unter target_isa, was das eigene Konditional und
  LEDGER-SECTION-16:87 vorschreiben)? Ein 2. NUMA-Wert waere Messwert-Luege der Q-1-Klasse.
Q-E08-4 locking: eine Achse "NUMA/locking" oder zwei? Organ-Seite (T08, 9 Organe) + atomic128 deckt locking schon;
  system-seitig bleibt nur Primitiv-VERFUEGBARKEIT (futex/cx16/HLE-RTM), und HLE/RTM ist auf beiden prod-Maschinen tot.
Q-E08-5 Meta-Meta: braucht die Definition AxisKind::system_meta_meta als echten Code-Diskriminator
  (topics/axis.hpp:17-21 = jede Achsen-TU) oder ist sie in dieser Runde Doku-/Taxonomie-Anker? Ist NUMA/locking
  Meta-Meta unter extension_hardware (meine Lesung: NEIN, kein Beschleuniger) oder normale Haupt-Achse?
Q-E08-6 Bruch-Fenster: darf E-08 einen DRITTEN golden-Bruch vor dem Montags-Trigger verbrauchen, oder landet E-08
  jetzt byte-neutral (S-2 + P-C, kein Stempel-Wechsel, Binary-Cache bleibt gueltig) und strukturell nach dem Trigger?
Q-E08-7 Reihenfolge-GO: Bestaetigung, dass E-08-NUMA als Teilschritt A-V IN Lane A laeuft (ein XML-Regen,
  ein Stempel-Neuanker) statt als eigene Lane.
Q-E08-8 CCD/V-Cache: soll die prod1-CCD-Asymmetrie in dieser Runde modelliert werden (einziger REALE
  Lokalitaets-Effekt der Flotte) -- unter scheduling.hetero_core_dispatch (existierende Unter-Dim) oder eigene Unter-Achse?

SELBSTCHECK: read-only (Read/Bash-grep/lscpu/ls), keine Datei geaendert; alle Zeilennummern aus Live-Lesung
26.07.2026; ASCII-only ausser § (grep -P '[^\x00-\x7F]' auf diesem Text = nur §-Treffer); 118 Zeilen.
