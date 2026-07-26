PFADSCHLUESSEL (alle Belege relativ zu diesen Wurzeln):
- L = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
- S1 = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md
- S2 = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md
- V = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-queued-ergaenzung-04.txt
- C = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine
- M = C/include/cache_engine/measurement

(a) DUAL-NATUR-REGISTER (vollstaendig, 14 Faelle; Stufenkette Planer -> CEB -> Tier)

| # | Achse | RT-Unter an Stufe | CT-Haupt an Stufe | Beleg |
|---|---|---|---|---|
| D1 | mess_tooling {wallclock,macro,micro} | Planer-RT (XML-Wahl, Unter des Mess-Toolings) | CEB-CT (fest einkompiliert) + durchgereicht als Tier-CT (Observer-Einkompilierung) | L:3076, L:3122, L:3308; S1:50-52; M/measurement_tooling_registry.hpp:2,24 |
| D2 | run_methodology {debug,measure,release,compare,CUSTOM_COMPILE} | Planer-RT (Mess-Unter, an CEB delegiert) | CEB+Tier-CT: cmake_build_type + measurement_on + single_thread sind CT-Draehte | M/run_methodology_registry.hpp:103-115; L:2829; S1:22-26 (5. Modus) |
| D3 | load_framework (ycsb; per R-C Meta-Meta) | Planer-RT (sub_axis workload stage="runtime") | CEB-CT-Haupt (erste Meta-Meta am Ende der CEB) | S1:22-26,50-52; M/system_axis_registry.xml:114-116 |
| D4 | target_isa | Planer-RT (Planer permutiert System-Kombis aus XML, baut je Kombi EINE CEB) | CEB-CT (und weiter Tier-CT via triple/march) | L:472 (S-5 Wortlaut); M/system_axis_registry.xml:98-100 |
| D5 | compiler (gcc\|clang) | ZWEIFACH dual: Planer-RT (waehlt CEB-Compiler) UND CEB-RT ("zur Laufzeit austauschbares Programm", Verfuegbarkeits-Erkennung) | CEB-CT UND Tier-CT | V:3 (jsonl:43145 "eigene Achse zur compile time bei runtime der CacheEngineBuilder und neue Systemachse"); L:472 (S-6 Zusatz); S1:31-34; M/system_axis_registry.xml:10 |
| D6 | opt_level | CEB-RT (stage="runtime", parent=compiler) | Tier-CT (CompileFn-Flag, build_version-Suffix) | M/system_axis_registry.xml:13; M/optimization_level_sub_axis.hpp:6-7; L:2053 (Aufloesung der Scheinspannung) |
| D7 | atomic128 (cx16) | CEB-RT (parent=compiler) | Tier-CT (-mcx16; snmalloc-Organ setzt durch) | M/system_axis_registry.xml:40; M/compiler_atomic_sub_axis.hpp:1-16 |
| D8 | simd/AVX (Meta-Meta unter external_utils) | CEB-RT (stage="runtime", parent=extension_hardware) | Tier-CT (-mavx2/-mavx512f + SIMD-Organ-Codegen) | M/system_axis_registry.xml:55-71; M/simd_sub_axis.hpp:4-12; L:2283 |
| D9 | NUMA (memory_topology / numa_node) | CEB-RT Unter-Achse unter target_isa (Freigabe je Architektur) | Tier-CT-Haupt (AllocNumaNode als NTTP; numa_capable()==false -> weggated) | OWNER-KERN 26.07.; C/axes/alloc/alloc_hw_config.hpp:37,49,77,97; C/topics/hardware/axis_12_general_hardware/axis_12_general_hardware_subaxes_hw1_to_hw4.hpp:33-35; L:2279 (Pkt.5) |
| D10 | page_type (Hardware-page_topology) | CEB-RT Unter-Achse unter target_isa (Freigabe je Architektur) | Tier-CT-Haupt (AllocPageHint{Native,4k,2m}, MAP_HUGETLB) | OWNER-KERN 26.07.; L:2707 (Zweiteilung RAUM=System/DURCHSETZUNG=Organ), L:2849; alloc_hw_config.hpp:41-42,92; subaxes_hw1_to_hw4.hpp:38-41 |
| D11 | scheduling (per R-B Unter von target_isa) | CEB-RT Unter unter target_isa | Tier-CT (WorkerPoolLayout/simd_worker_count_limit einkompiliert) | S1:18-20; M/system_axis_registry.xml:102-112; M/scheduling_system_axis.hpp:58-62; V:3 |
| D12 | locking / concurrency-Freigabe | CEB-RT (System-Freigabe-Erlaubnis) | Tier-CT-Haupt (Organ axis_08 concurrency, ein gewaehlter Algo) | V:3 ("Scheduling, Hardware, NUMA, Locking Systemachsen ... zur Laufzeit in die Tier-Binaries einzukompilieren"); L:470 (locking_mode -> axis_08-T08); L:1361 |
| D13 | external_utils/extension_hardware-Hub + HW-Meta-Metas (GPU/FPGA/NPU/ext. Beschleuniger) | CEB-RT (Freigabe-Auswertung, State Pattern ueber das Pruef-Dock) | Tier-CT (Organ-Aufnahme der Dual-Aufnahme-Achse) | L:2280 (Pkt.6 "Dual-Aufnahme"), L:2283, L:2290 (§37.b); S1:35-46; S2:53 |
| D14 | operating_system (R-A, NEU) | VORBEREITET, heute nicht aktiv: 4 Unter (os_version, kernel, build, update_zustand) sind statisch | CEB-CT heute; kernel_version wird RT-Unter@CEB / CT-Haupt@Tier, sobald Kernel-Wechsel moeglich | S2:34-36 ("ERSTMAL STATISCH ... wird aber VORBEREITET"); S1:18-19 |

Muster-Verdichtung: an der Naht Planer->CEB sind D1-D5 dual; an der Naht CEB->Tier sind D5-D13 dual; D5 (compiler) ist an BEIDEN Naehten dual; D14 ist eine deklarierte, noch nicht scharfe Dualitaet.

(b) NICHT DUAL (rein einstufig) und warum

1. Die 18 ORGAN-Haupt-Achsen (T00-T16 + persistence_target): das Tier-Binary ist die LETZTE Stufe, es gibt keine Folgestufe, die eine Einstellung einfrieren koennte; Organ-Achsen existieren ueberhaupt nur in Tier-Binaries. Beleg L:2290 (§37.b "Organ-Achsen gibt es NUR in den Tier-Binaries"), S1:65-87. Konsistent mit §54-T3 (binary_id = Organ-only).
2. Durchgereichte RC-POD-Unter-Achsen (thread_count, pool_budget_bytes, alle System-UNTER-Achsen im Sinne von L:2279 Pkt.4): sie kommen als Runtime-Variable IM Tier-Binary an und werden dort nie kompiliert. Beleg C/anatomy/resource_controllable_tier.hpp:35; C/anatomy/abi_adapter.hpp:252-264; L:2279 Pkt.4 ("Freigabe betrifft NUR statische System-HAUPT-Achsen"). Deshalb sind sie auch nicht im Binary-Stempel (§58).
3. measurement_categories (16) + Rueckschrieb-Methoden + Workloads/Datasets: bleiben ueber ALLE Stufen dynamisch und manifestieren sich nur als CSV-/xlsx-Spalten; binary_id- und stempel-neutral. Beleg L:2934 (T2), L:2892, L:2872.
4. scheduling_dims (5 sub_dims, stage="ct", kind="fixed_enum_tuple"): heute existiert kein RT-Vorstufen-Kanal, der sie permutiert; sie sind bereits am Definitionsort CT. Beleg M/system_axis_registry.xml:104-112. Kandidat fuer D11-Ausbau, sobald der Planer sie permutierbar macht.
5. Namensfalle, ausdruecklich NICHT dual: axis_01_page_type (PageKind = Baum-Knoten-Struktur) ist eine rein einstufige Organ-Achse und hat mit D10 nichts zu tun. Beleg L:2707, L:2849.
6. Die Komplex-Haupt-Achse selbst (target_isa x os x external_utils x MetaMetas) ist nicht eigenstaendig dual: sie hat nur eine INDIREKTE Identitaet ueber die gewrappten Glieder und erbt deren Stufenrollen. Beleg S2:20-23, S1:31-34.

(c) GENERISCHE REGEL fuer eine NEUE Achse (3 Saetze)

1. Bestimme fuer die neue Achse das Paar (Stufe, an der ihr Wert erstmals aus der XML/Umgebung GEWAEHLT wird) und (Stufe, in deren Kompilat der Wert als Konstante/Flag/Typ EINGEFROREN wird): sind das zwei verschiedene Stufen der Kette Planer -> CEB -> Tier, ist die Achse dual, und zwar als RT-Unter-Achse an der Waehl-Stufe und als CT-Haupt-Achse an der Einfrier-Stufe (§24-C stufen-relativ, L:2053).
2. Die Waehl-Stufe entscheidet die Klammerung als Unter-Achse: sie haengt unter genau jener System-HAUPT-Achse, deren Freigabe die Wahl ueberhaupt erst erlaubt (NUMA/page_type unter target_isa, opt_level/atomic128 unter compiler, simd unter external_utils) - denn nur statische System-HAUPT-Achsen geben frei, und die Organ-Seite setzt durch (§37, L:2279 Pkt.4/L:2290).
3. Bleibt der Wert bis zur letzten Stufe dynamisch (er faehrt als Runtime-Parameter durch das Tier-Binary hindurch oder erscheint nur als CSV-/xlsx-Spalte), ist die Achse NICHT dual, gehoert nicht in den Binary-Stempel und nicht in die binary_id; ist sie dual, muss sie in BEIDEN Rollen registriert werden - RT-Unter im Angebot der Vorstufe (mit Fehlerklasse fuer "Freigabe fehlt") und CT-Haupt im Stempel-Array der Folgestufe (CEB=[a,b,c] bzw. Tier=[d,e,f]+[g,h,i], §57/§58, L:3021-3022).

SELBSTCHECK: grep -P '[^\x00-\x7F]' ueber diese Meldung = nur '§' (erlaubt); keine ─/—/Emoji; alle Behauptungen mit datei:zeile oder L:Zeile belegt; OWNER-KERN 26.07. ist der einzige Beleg ohne Zeilennummer (noch nicht persistiert - Persistierung in ein neues Session-Doc empfohlen, da S1:48-52 nur D1+D3 nennt und D9/D10 fehlen).
