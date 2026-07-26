P-1 / A4+A5-PRAEZISIERUNG: NUMA/page-Doppel-Seite (Quellen-belegt, ASCII-only)

(a) PFLICHT-BEWEIS P-1 -- literale grep-Ausgabe
```
$ for f in libs/.../thesis_profiles/*.xml tests/unit/thesis_tiere/*.xml; do echo "$f : $(grep -c 'axis ref="alloc_hw"' $f)"; done
all_axes_golden.profile.xml : 0     base_pilot.profile.xml : 0      cacheline_study.profile.xml : 0
fb_numa_page_study.profile.xml : 1  ff2_node_width_study.profile.xml : 0
m3_golden_coverage : 0  m3_smoke_coverage : 0  m3v2_smoke : 0  m3v2_sota_pilot : 0  m3v2_study : 0
wdk_fairness_example : 0
tests/unit/thesis_tiere/experiment_golden_kern.xml : 0   experiment_golden.xml : 0
tests/unit/thesis_tiere/planner_thesis_min.profile.xml : 0   prt_art_axis_registry.xml : 0
$ grep -rn 'numa\|page' all_axes_golden.profile.xml experiment_golden.xml experiment_golden_kern.xml
(keine Ausgabe = 0 Treffer)
$ grep -rn alloc_hw --include=*.xml <super-repo>   # nur:
fb_numa_page_study.profile.xml:11,:35,:48,:49,:71,:79 | cacheline_study.profile.xml:54,:59 (nur Kommentare)
```
BEFUND P-1: golden (all_axes_golden), 320er-Experiment-XML (experiment_golden.xml / _kern.xml) und ALLE
Test-XML aktivieren alloc_hw NICHT -> gegenueber golden/320 ist die Naht byte-neutral, wenn die neue
System-Kante binary_id="never" bleibt. ABER: fb_numa_page_study.profile.xml:49 aktiviert sie, und dieses
Profil ist gruen inventarisiert (tests/unit/CMakeLists.txt:3335 uebergibt es an test_fb_alloc_hw_subaxis,
Erwartungen test_fb_alloc_hw_subaxis.cpp:230-231 "numa_node 3 / page 2"). Also: NICHT byte-neutral
gegenueber fb_numa_page_study + dessen Test -- der Plan muss das benennen, dort entstehen heute via
profile_to_tree.hpp:84-86 zwei statische Level (= binary_id-Segmente).

P-1-ZUSATZBEFUND (Ehrlichkeits-Luecke, muss in A4/A5): es gibt HEUTE KEINEN Codegen-Konsumenten.
`grep -rn 'alloc_hw|numa' tools/` = 0 Treffer; apps/catalog_codegen_tool/main.cpp:183-190 LEHNT alloc_hw
hart ab; die einzigen Nicht-Default-Instanzierungen stehen im Test (test_fb_alloc_hw_subaxis.cpp:65-71).
Default ist AllocHwConfig{} (axis_06_allocator_strategy_base.hpp:67, numalloc :45, pool_resource :59)
-> die Profil-Level erzeugen binary_id-Segmente, ohne dass irgendein Generator das gepinnte Organ
instanziiert. Ohne Draht-2 (unten) bleibt die Achse ein Papier-Tiger.

(b) ARBEITSPAKET Zwei-Stufen-Naht (System gibt frei / Organ setzt durch)
Stufe 1 -- CEB/System, RT-Unter-Achsen UNTER target_isa:
 S1.1 Registry-Kante NICHT von Hand: system_axis_registry.xml:1-4 sagt "GENERIERT ... NICHT von Hand
      editieren". Neue <sub_axis> muessen in tools/system_axis_registry_gen/main.cpp emittiert werden,
      direkt hinter dem target_isa-Block main.cpp:244-255, exakt nach dem simd-Emissions-Muster
      main.cpp:222-230. Zwei Unter-Achsen, Vokabular NICHT erfunden sondern aus HW3/HW4 uebernommen
      (axis_12_general_hardware_subaxes_hw1_to_hw4.hpp:35 memory_topology_tag, :42 page_topology_tag):
        target_isa -> memory_topology (stage="runtime", value_type="token", option ids auto|0|1)
        target_isa -> page_topology  (stage="runtime", value_type="token", option ids 4k|2m)
      Damit existiert die von B-3 vermisste Kante "Unter-Achse unter der ISA" real (target_isa hat heute
      registry :98-101 KEINE sub_axis).
 S1.2 Header nach simd_sub_axis-Muster (simd_sub_axis.hpp:31-56): CRTP CebSystemAxis<Derived> +
      Concept, do_axis_label()="memory_topology"/"page_topology", parent_axis_label()="target_isa",
      leere finale Option-Structs. KEIN std::variant in diesen Headern (Owner-Kern: variant nur CEB;
      axis_error.hpp:127 nutzt variant -- das ist Mess-/Werkzeug-Ebene, kein Tier-Typ, bleibt zulaessig).
 S1.3 binary_id-Neutralitaet ist STRUKTUR, nicht Konvention: target_isa traegt binary_id="never"
      (registry :98); der Organ-only-Guard profile_to_tree.hpp:89-95 laesst System-Achsen nie ein
      statisches Level erzeugen. Materialisierung wie simd = CompileFn-Flag + Sidecar
      (simd_sub_axis.hpp:17-19).
Anschluss der BESTEHENDEN Organ-Seite ohne Doppelung:
 S1.4 EIN Alphabet, KEINE Mapping-Tabelle: die Registry-option-ids sind genau die Token, die die
      bestehenden constexpr-Factories schon lesen -- make_alloc_numa_node "auto|0|1"
      (alloc_hw_config.hpp:126-128) und make_alloc_page_hint "4k|2m" (:130-132). Damit ist der
      Token->Typ-Uebergang an EINER Stelle (Organ), das System liefert nur das Angebot.
 S1.5 AllocHwConfig (:48-53), AllocHwAware (:73-87) und gate_alloc_hw_for<HW> (:94-102) bleiben
      UNVERAENDERT = "Organ setzt durch": das if-constexpr-HW-Gate (:97-100) ist die Durchsetzung,
      das System darf nur freigeben. Kein zweiter Wertraum, kein zweites Gate.
 S1.6 Doppelbelegungs-Reject (fehlt heute!): validate_profile.hpp:206-209 WARNT nur ("nicht gegen die
      Achsen-Registry geprueft") und resolve_axis_refs_against_trio :774-776 SKIPPT alloc_hw -- eine
      gleichzeitige Belegung von <axis ref="alloc_hw"> UND target_isa.memory_topology/page_topology
      bliebe unentdeckt. Neu, an derselben Stelle: (i) Werte-Pruefung der numa_node/page-Token gegen
      die neuen Registry-option-ids (ersetzt die Nicht-geprueft-Warnung durch eine echte Pruefung ->
      hebt den Registry-Umgehungs-Befund B-2 auf), (ii) harter Reject bei Doppelbelegung. Der
      Sonderzweig BLEIBT (alloc_hw ist Organ-SUB-Achse, kein eigener <axis>, :774-776) -- nur der
      Warn-Skip wird zur Pruefung.
 S1.7 Zwei erlaubte Zustaende, je Profil GENAU EINER (das ist die Dual-Natur, nicht Doppelung):
      (i) System-RT an der CEB: Level lebt in build_system_axis_levels() (registry_to_axis_levels.hpp
          :117-126) -> KEIN binary_id-Segment; Profile fuehren KEIN alloc_hw.
      (ii) Organ-CT am Tier: nur wenn ein Profil <axis ref="alloc_hw"> schreibt -> profile_to_tree.hpp
          :81-87 -> binary_id waechst NUR fuer dieses Profil.
      WICHTIG/ehrlich: neue Registry-sub_axes erscheinen NICHT automatisch in build_system_axis_levels()
      -- dort stehen 5 handgesetzte push_static_axis-Zeilen (:118-124). Ob memory_topology/page_topology
      dort landen, ist eine Entscheidung (D-1), keine Automatik.
Draht-2 (der eigentliche Konsument, sonst Papier-Tiger): der Token muss vom CEB in die generierte
 Tier-TU als NTTP AllocHwConfig{...} durchgereicht werden (Muster numalloc :228). Betroffen:
 apps/catalog_codegen_tool/main.cpp:183-190 (heutiger Hart-Reject) und der Permutations-Codegen.

(c) FEHLERKLASSE "hugetlbfs/Kernel nicht konfiguriert" -- geprueft, nicht erfunden
 Vorhanden in axis_error.hpp: D1 CompilerCompilerErrorClass{KonfigXmlParse :38, ToolchainFehlt :39,
 HardwareErweiterungFehlt :40, CompileKombination :41}; D2 SampleStatus{Ok, NotApplicable :57,
 SourceUnavailable :58, Failed :59}; InfraErrorClass{ProzessStart, ProzessAbbruch, ArtefaktIo :100-104}.
 KEINE dieser Klassen trifft "Kernel/hugetlbfs nicht konfiguriert": HardwareErweiterungFehlt ist
 literal definiert als "ISA-/Beschleuniger-Erweiterung auf dem Host nicht verfuegbar (AVX512, GPU,
 FPGA)" (:40) -- hugetlbfs ist OS-Konfiguration, keine ISA/Beschleuniger; die HW MELDET sich als
 faehig (axis_12_general_hardware_x86_64.hpp:9 "huge_page_capable = true (2 MiB + 1 GiB MAP_HUGETLB)").
 Infra* ist Prozess/IO (:100-104), also disjunkt.
 -> Runtime-Seite: DECKT AB durch Vorhandenes: SampleStatus::SourceUnavailable ("n/a", :58) bzw.
    Failed ("failed", :59) -- kein Enum-Bump noetig.
 -> Planer-/Compile-Seite: es fehlt eine Klasse; NEU gebraucht, additiv:
    CompilerCompilerErrorClass::BetriebssystemFeatureFehlt = 4, Label "betriebssystem_feature_fehlt"
    (error_class_label-switch :69-76), plus Pflicht-Mitzaehlen kCompilerCompilerErrorClassCount :47
    (4->5) und Anpassung des Drift-Guards static_assert :190-191 (== CompileKombination + 1).
 EHRLICH: heute kann der Fehler noch nicht auftreten -- es gibt keinen hugetlbfs-Aufruf; MAP_HUGETLB
 kommt im gesamten libs/-Baum nur in Kommentaren vor (alloc_hw_config.hpp:44,
 axis_12_general_hardware_x86_64.hpp:9); der 2m-Hint endet in pmr::pool_options
 (axis_06_allocator_pool_resource.hpp:195). Die Klasse wird erst mit einem echten Huge-Page-Request faellig.

(d) REIHENFOLGE Bruch-zuerst-dann-Draht, mit Gates
 G0 Inventar: P-1 (a) im Session-Doc zitieren + Testliste (test_fb_alloc_hw_subaxis, thesis_tiere/
    test_validate_profile.cpp:337-344). Gate: Ist-Stand literal, kein Bau.
 B-1 Bruch System-Angebot: S1.2-Header + S1.1-Generator-Emission. Gate: Registry NEU GENERIERT (nicht
    handgepatcht), XML-Diff rein additiv, ce-all + ce-Unit-Tests gruen (2-Pass, wegen bekannter
    lokaler Vollbau-Luecken).
 B-2 Bruch Fehlerklasse (nur falls D-3 = Compile-Seite): axis_error.hpp additiv + Count + Drift-Guard.
    Gate: static_asserts compilieren, alle Label-Kontrakte unveraendert.
 B-3 Bruch Validator: S1.6 (Werte-Pruefung + Doppelbelegungs-Reject). Gate: fb_numa_page_study
    validiert weiter; ein kuenstliches Doppel-Profil wird HART abgelehnt (literale Ausgabe zeigen).
 D-1 Draht CEB: Token -> CompileFn/Sidecar (Muster simd). Gate: golden/320-Baum-Dump byte-identisch
    (P-1 sagt: kein Profil aktiviert alloc_hw -> Byte-Gleichheit ist pruefbar, nicht behauptet).
 D-2 Draht Organ: Codegen instanziiert AllocHwConfig{...}; catalog_codegen-Reject :183-190 aufloesen.
    Gate: gepinnte Binary existiert + Test-Skip nur als Lagerhaltungs-Skip fuer gruen inventarisierte
    Binaries. Erst DANACH die adversariale NACH-Pruefung.

(e) RISIKEN + VOR dem Bau zu entscheiden (Manager)
 D-1 Kommen memory_topology/page_topology in build_system_axis_levels() (registry_to_axis_levels.hpp
     :118-124)? Ja -> golden-Permutationszahl waechst (und §62-A verlangt Warnung statt Filter,
     analog B-1/AVX512); Nein -> Angebot bleibt ohne Abnehmer. KEINE Automatik, muss entschieden werden.
 D-2 Option-Alphabet: "auto|0|1"/"4k|2m" (deckt sich mit alloc_hw_config.hpp:126-132) vs simd-Stil
     ("no_extension"-artig). Abweichung erzwingt eine Mapping-Tabelle = genau die verbotene Doppelung.
 D-3 hugetlbfs-Fehler an der Compile-/Planer-Seite (neues D1-Enum, (c)) ODER nur runtime via
     SourceUnavailable/Failed? Enum-Bump beruehrt axis_error.hpp:47 + :190-191.
 D-4 fb_numa_page_study.profile.xml:49 -- bleibt der Organ-CT-Zustand (dann ist die Naht dort NICHT
     byte-neutral, Reject-Guard Pflicht) oder wandert er auf die System-Seite (dann bricht
     test_fb_alloc_hw_subaxis.cpp:230-231 und braucht explizites GO; "Alt-golden darf brechen" deckt
     einen gruenen Unit-Test nicht automatisch).
 D-5 apps/catalog_codegen_tool/main.cpp:183-190 (Hart-Reject fuer alloc_hw) -- in diesem Paket loesen
     oder ausdruecklich vertagen?
 RISIKO-1 Mess-Wert: der NUMA-Effekt braucht Multi-Socket-HW, dokumentiert in alloc_hw_config.hpp:22-24
     ("auf Single-Socket-prod1 ist der Effekt klein/null") -- die Achse ist als Permutation+Dokumentation
     gerechtfertigt, nicht als Effekt-Nachweis.
 RISIKO-2 Freigabe-Pilot bleibt inert (B-3): simd_build_gate.hpp:185-187 liefern {} und
     active_machine_signature() liest die 3 <machine_signatures> (registry :118ff) nicht -- eine
     Host-treue Freigabe fuer numa/page wuerde dieselbe inerte Naht erben, solange dieser Hook leer ist.
