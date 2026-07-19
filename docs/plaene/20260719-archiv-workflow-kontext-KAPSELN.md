# Archiv-Workflow-Kontext-Kapseln fuer die laufenden Planungen (2026-07-19)

## A. Zweck und Auswahl

Dieses Dokument buendelt die **12 relevantesten Archiv-Workflows** (Auswahl aus ~95 Backup-Ordnern in `docs/sessions/backups/`) als Kontext-Kapseln fuer die drei aktuell laufenden Planungs-Workflows:

- **(a) Gesamt-Roadmap** — Ledger-Diff, XML-Featurespace, Parallelisierungs-Wellen, New-Golden-Voll-XML-Mock N=2^17, CI-Detail-Kette start→gruen
- **(b) §27-Resolver-Stufe** — Registry=ANGEBOT als XML-Bibliothek / Anwender-XML=ANZEIGE (.pom-artig) / Planer=Resolver-Linker
- **(c) Achsen-Nachschlagewerk-INC2D-Delta** — 172 Eintraege auf 17-Slot/ABI-6 umziehen

**Bindender heutiger Rahmen (gewinnt bei jedem Konflikt mit Kapsel-Inhalten):**
NEU **§28**: JEDE der 3 Achsen-ARTEN (Organ/System/Mess) braucht ihre EIGENE Registry in IHREM Modul per XML (Angebot des Compiles); Haupt-Achse=statisch im Ziel-Binary, traegt optionale Unter-Achsen-Einstellungen=meist dynamisch im Ziel-Binary. Planer-Bauplan existiert (`docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md`) mit Phase-0-Blocker (super `v32_messreihe_antrieb` `execute_messreihe`-Stub wiederverwenden, keine Parallelstruktur). Stand: 17 Organ-Achsen/ABI-6, golden-N=2^17-Fixture vorhanden, #50/#51/#52 done, Deadline 28.07.

Jede Kapsel: was_es_ist → Kern-Erkenntnisse (mit Quellen) → superseded → §28-Registry-Relevanz → speist_in.

---

## B. Kapseln

### K1 — 20260713-design-zwei-registry-experiment-strategy

`docs/sessions/backups/20260713-design-zwei-registry-experiment-strategy`

**Was es ist:** 5-Agenten-Design-Workflow (13.07., 633k Tokens), der die finale Zwei-Registry(ce+prt-art, same schema)+Experiment-XML(3-Phasen, bausteinfrei)+Parser-als-ce-Modul+Strategy-Pattern-Architektur TABU-neutral konsolidierte — inkl. 8-Increment-Plan A–H und 6 User-Forks. Ursprung von `feedback_unified_experiment_xml_plus_system_registry_xml`; keine Synthese-MD, Essenz liegt in `wf-RESULT-raw.json` (result.plan).

**Kern-Erkenntnisse:**
- **Registry-Schema-Design** (heute noch gueltig fuer alle 3 §28-Registries): je Baustein `name`=`Wrapper::name()`=exakt der serialize_composition_path-Schluessel, `type`+`header`=FQ-Typ+Include (halbe String→Typ-Bruecke fuer Codegen), `genus`=Slot::genus, `golden_wired`=Ehrlichkeitsflag real-im-Mess-Pfad vs. nur-deklariert — wf-RESULT-raw.json result.plan §1.1
- **Fork R-0 Option C** (EMPFEHLUNG, A/B explizit verworfen): Registry-XML NIE handschreiben (driftet von CT-Slots) und NIE Legacy recyceln (permutation_axes.xml=TABU, opake Token, prt-art-Token eingemischt), sondern **per CT-Reflektion generieren** (mp_for_each ueber AllX=mp_list unter registry_to_axis_levels.hpp-Dach) — das IST die §28-Formel "Registry=Angebot des Compiles" — result.plan §1/R-0
- **Anwender-/Experiment-XML enthaelt KEINE Bausteine**: `<phase merge engine>` referenziert nur Registries; axes_default_lookup/allowed_variants=reines LIMIT (Teilmenge der Registry-name()s), kein Katalog — direkter Vorlaeufer der §27-ANZEIGE (.pom-artig); loeste Interim messreihe_v32_schema_example.xml (Bausteine inline) ab — result.plan §1.3
- **String→CT-Slot-Bruecke = 2 belegte Mechanismen**, kein map<string,type>: (a) enumerate-and-key (composition_registry by_path_), (b) codegen-by-FQ-name (render_sota_module_source emittiert .cpp mit #include+COMDARE_DEFINE_ANATOMY_MODULE, Compiler bindet Name→Typ); Registry-Tabelle name→(type,header) schliesst Design-Frage L-6 — Kernmechanik des §27-Resolver-Linkers — result.plan §3
- **3 Phasen als GoF-Strategy/CRTP-Policy+Concept-Guard**, CT-Selektion via MergeAxis; Lesart R-C(i): Phase2-ce=Stufe1_CeOnly, Phase1-prt-art=Stufe2_PrueflingReplace, Phase3=Stufe3_FullJoin; ACHTUNG Bug M-CE-10: Stufe2 ignorierte lebewesen-Argument → 7x identische binary_id/H2-Fehlattribution (inzwischen gefixt, s. K3) — result.plan §2.2/§5.2/R-C
- **Parser=ce-Modul in common-Schicht** (v32-Modell all-Strings → layering-konform ohne cache_engine-Enums), super-Parser wird [[deprecated]]-Shim; Antriebs-Andockpunkt=execute_messreihe-Stub v32_orchestrator.hpp:81-85 — exakt der Phase-0-Blocker-Wiederverwendungspunkt im Planer-Bauplan 20260719 — result.plan §2.1/§4-G
- **M-CE-27 CI-Luecke**: test_profile_roundtrip (Golden-Roundtrip-Gate) ist EXCLUDE_FROM_ALL ohne add_test, laeuft in KEINEM CI-Job → Golden-Gate nur lokal; Fork R-E: in CI heben — fuer die heutige CI-Detail-Kette pruefen, ob inzwischen geschehen — result.plan §5.2
- **Increment-Doktrin**: A–E (Registries+Schema+Parser+Strategy) rein additiv/lese-seitig sofort, F–H (Antrieb) erst nach extra GO hinter Doppel-Gate (Build-option OFF + Env-Opt-in, Muster COMDARE_RUN_E4_XML) + W4-Gate: Ausfuehrung NUR ueber Katalog-DLL-Pfad, NIE ueber quarantaenisierten PrtArtHashBackend (kein 4. Laufzeit-Pfad); PrtArtHashBackend aushaengen, nicht loeschen — result.plan §4

**Superseded:**
- Partitionierung "2 Registries je ENGINE (ce+prt-art)" → §28: 3 Registries je Achsen-ART (Organ/System/Mess), jede im eigenen Modul; Engine-Schnitt durch Achsen-Art-Schnitt ersetzt (Schema/Generator/Bruecke bleiben)
- Golden-320-Zwang (G-320-Gate, CatalogAxes<4,4,5,4>=320 als TABU) → `feedback_new_golden_all_axes_xml_gt320`: golden N=2^17-Fixture existiert, golden==320 ueberholt
- 11-Legacy- bzw. 19/26-T0..T18-Schema und ABI-4-Magic-TABU → heute 17 Organ-Achsen/ABI-6 (Nachschlagewerk-Delta: 172 Eintraege auf 17-Slot)
- Alles-statisch-Modell ohne Unter-Achsen-Konzept → §28 Haupt-statisch/Unter-meist-dynamisch (plus Compiler-Achse mit dynamischen XML-Unterachsen, 17.07.)
- Status "kein Bau, nur Fork-Bestaetigung" + COMDARE_V32_DRIVER_ENABLE-Planung → VOLLES GO 17.07. + #50/#51/#52 done; autoritativ ist der BAUPLAN 19.07.
- GO-Referenzen auf §0-GOAL-V4-Ledger-Zeilen und Rollback-Anker (ce 9f05c6db / super 6a40fb9 / prt-art 12ca441) historisch; heutiger Ledger-Einstieg=§19

**§28-Registry-Relevanz:** Direktester Vorfahr der §28-Direktive: etablierte Registry=per CT-Reflektion GENERIERTES XML aus den mp_list-Wahrheiten des Moduls (="Angebot des Compiles"), same-schema-Mehrfach-Registries und die bausteinfreie Anwender-XML mit reinen Limit-Referenzen (=§27-ANZEIGE). §28 aendert den Schnitt von "je Engine" (2) auf "je Achsen-ART" (3) — Schema-Felder (name/type/header/genus/golden_wired), Generator-Ansatz Option C und die String→Typ-Bruecke sind 1:1 uebertragbar. Haupt-statisch/Unter-dynamisch ist §28-NEU: das 13.07.-Design kannte nur Ganz-CT-Auswahl.

**Speist in:** resolver-registry, planer-bau, roadmap, ci-kette, golden-mock, nachschlagewerk-delta

---

### K2 — 20260710-axis-binding-registry-VERWORFEN

`docs/sessions/backups/20260710-axis-binding-registry-VERWORFEN`

**Was es ist:** Adversarialer 10-Agenten-Review (10.07.) eines uncommitteten Headers `axis_binding_registry.hpp`: consteval-Registry, die die damals 19 Composition-Achsen in 14 statisch + 5 laufzeit-steuerbar (RC-POD) klassifizierte. 5 von 7 Findings CONFIRMED (3x major) — Design VERWORFEN, nie committet; der Ordner ist die dokumentierte **Anti-Lehre**, warum eine zentrale C++-Compile-Time-Binding-Registry der falsche Bauort ist.

**Kern-Erkenntnisse:**
- **ANTI-LEHRE 1** (Verwerfungsgrund, major): Registry als Doppelt-Wahrheit ohne Konsumenten — die 14/5-Klassifikation lebte bereits autoritativ im Baum-PRODUZENTEN profile_to_tree.hpp:75-87 (is_static → StaticAxisNode vs DynamicVariableNode, seit 2026-06-18 selbst-deklariert "DIE EINZIGE Quelle"); die neue Registry war 3./4. Parallel-Kodierung mit NULL Produktions-Konsumenten. Lehre fuer §27/§28: eine Registry ist nur legitim, wenn sie DIE vom Produzenten konsumierte Quelle ist — nie eine parallele Klassifikation daneben. (review-ergebnis.json, Finding line 76-87)
- **ANTI-LEHRE 2** (major): Runtime-ABI-Werte lassen sich nicht compile-time spiegeln — die 5 RC-Caps (batch 4096, pool 1GiB, prefetch 64, threads 64, inline 256) lagen handkopiert an 4 Stellen (Registry, abi_adapter.hpp:226-231, 2 Tests); tier_query_resource_caps ist non-constexpr-virtual; consteval-Guard prueft nur cap!=0+ANZAHL → stiller Drift bewiesen (64→128 kompiliert gruen). Lehre: Werte, die das Tier-Binary zur Laufzeit meldet, gehoeren NICHT in eine statische Registry. (Findings lines 26-40, 58-66)
- **ANTI-LEHRE 3** (major, doppelt bestaetigt): "Nur-fuer-Doku"-Include = Layering-Bruch — builder-Header inkludierte measurement/system_axis.hpp ohne Symbolnutzung → builder↔measurement-Zyklus in FALSCHER Richtung; per Compile-Probe auf g++-16 UND clang-22 bestaetigt. Lehre: Organ-/System-/Mess-Schichten strikt trennen — exakt die §28-Forderung je-Art-Registry im eigenen Modul. (Findings lines 10-19, 42-50)
- **VALIDIERTER KERN** (ueberlebte per Refutation): Wurzel-Verzweigung Haupt-Achse=compile-statisch vs Unter-Einstellung=laufzeit-steuerbar ist fork-UNABHAENGIGE Design-Konstante KK-1 (Doc 20 `docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md` §G/§H) — direkter Vorfahr der §28-Doktrin. (axis_binding_registry.hpp.verworfen:6-10 + review-ergebnis.json refuted lines 108-116)
- **VALIDIERTES MAPPING**: dynamische Unter-Einstellungen binden 1:1-bijektiv an RC-POD-Felder (ComdareResourceControlV1, 5 uint64+Meta): cache_traversal→batch_size, allocator→pool_budget_bytes, prefetch→prefetch_distance, concurrency→thread_count, value_handle→inline_threshold_bytes — konkrete Blaupause fuer "dynamisch im Ziel-Binary". (hpp.verworfen:39-46,67-88)
- **HAUS-PATTERN fuer CT-Registries** (Muster measurement_axis_registry.hpp/P2): Enum + consteval-Array + registry_is_consistent()-static_assert + for_each-CT-Iteration + sizeof-POD-Drift-Guard. Das Pattern war NICHT der Fehler, bleibt fuer C++-seitige Registry-Verbraucher gueltig. (hpp.verworfen:2-5,91-131)
- **DRIFT-FALLE** (weiter gueltig): axis_NN-Verzeichniscodes ≠ T/L-Slot-Ordnung — Registries AUSSCHLIESSLICH auf stabile semantische Slot-Namen (kCompositionAxisNames als Single-Source) keyen, nie auf Verzeichnisnummern. Relevant fuers Nachschlagewerk-Delta 19→17. (hpp.verworfen:12-16)
- **Methodik-Beleg**: Find(3 Dimensionen)+Verify(1 Agent je Finding, empirische Compile-Proben), 7 Kandidaten → 5 CONFIRMED / 2 sauber REFUTED; die 2 Refutations retteten die wertvollen Design-Anteile. (review-ergebnis.json:1-6, review-journal.jsonl)

**Superseded:**
- 19-Slot-Tabelle (L00-L18, 14+5) zahlenmaessig ueberholt: heute 17 Organ-Achsen/ABI-6/17-Slot
- Bauort "zentrale C++-Header-Registry im builder-Modul" doppelt ueberholt: durch Verwerfung selbst UND positiv durch §27/§28 (Registry=XML-ANGEBOT je Achsen-ART im eigenen Modul, Planer=Resolver)
- golden==320-Kontext → new-golden N=2^17
- profile_to_tree.hpp als "DIE EINZIGE Quelle" war Stand 07/10; mit §28 wird auch diese C++-Quelle perspektivisch Konsumentin der modul-eigenen XML-Registries — die Anti-Doppelquelle-Doktrin selbst bleibt in Kraft

**§28-Registry-Relevanz:** Direkter Anti-Lehre-Vorlaeufer: versuchte genau das, was §28 jetzt richtig verortet, aber an DREI falschen Stellen — (a) EINE zentrale Registry statt je-Art im jeweiligen Modul (der Layering-Bruch ist exakt das Symptom fehlender Modul-Verortung), (b) C++-CT-Header statt XML-Angebot des Compiles (→ unloesbarer Runtime-Cap-Spiegel-Konflikt), (c) parallel zum echten Produzenten statt als konsumierte Quelle. Der VALIDIERTE Kern (Haupt-statisch/Unter-dynamisch via RC-POD-Bijektion, KK-1) ist die frueheste geerdete §28-Formulierung.

**Speist in:** resolver-registry, planer-bau, nachschlagewerk-delta

---

### K3 — 20260713-verify-registry-facts

`docs/sessions/backups/20260713-verify-registry-facts`

**Was es ist:** Pre-GO-ultracode-Verifikationsworkflow (13.07., 4 Agenten, ~320k Tokens, nur wf-RESULT-raw.json): verifizierte am Live-Code alle `Wrapper::name()` ueber die damals 19/26 Achsen (Kollisionsfreiheit + byte-genaue serialize-Konsistenz), FQ-Typen+Header der 4+1 prt-art-Slots, M-CE-11/12/28 und die Dataset-Doppelquellen-Frage — konsolidierte Hart-Fakten als Baufreigabe-Grundlage fuer den Registry/Experiment-Codegen (kein ROT, 2 GELB).

**Kern-Erkenntnisse:**
- **Single-Source-Antwort (Code vs XML)**: Der CODE ist die einzige Registry-Wahrheit — Invariante "Registry-Baustein-Name == Wrapper::name() == serialize-Schluessel", jedes name()=constexpr string_view-Literal, 0 Kollisionen je Achse; Serialisierung (axis_path_serialization.hpp) und Reflexion (axis_reflect.hpp:28 via registry_to_axis_levels.hpp build_all_axis_levels=BR-1) rufen dasselbe W::name() auf demselben Enabled*-Strom. XML referenziert nur Namen. — result.facts §2a
- **PFLICHT-LEITPLANKE fuer jeden Registry-/XML-Generator**: IMMER ueber Enabled*/StaticAxisVariants* binden, NIE ueber All* — default-OFF Paper/Vendor-Wrapper emittieren sonst `<name>(disabled)` und brechen die byte-genaue Round-Trip-Garantie; Empfehlung: static_assert dass kein reflektiertes name() auf "(disabled)" endet. — result.facts §2a KRITISCH
- **Kollisions-Warnung fuer die name→(FQ-Typ,Header)-Umkehrtabelle**: der golden-verdrahtete prt-art-Merge-Slot (PrtArtPathCompressionSlot, compositions/prt_art_merge_reference.hpp:42) traegt KEINEN prtart_-Namen, sondern die bare CE-Patricia "path_compression_patricia" — deckungsgleich mit der nativen CE-Variante; Registry muss Fehl-Attribution prt-art vs CE explizit behandeln. — result.facts §2b
- **sota-Namensraum DISJUNKT** vom Basis-Permutationsraum: sota::<reihe>::<name> eigener Namespace (sota_catalog.hpp:70-72), grep=0 in permutation_axes.xml/golden — fuer Registry-Vollstaendigkeit und den New-Golden-Voll-XML-Mock separat erfassen. — result.facts §2b
- **Bau-Auflage fuer Planer/Experiment-Host** (Phase-0-relevant): known_workload_ids MUSS an validate_profile.hpp gereicht werden (Gate :319 `if (!known_workload_ids.empty())`), sonst bleibt der M-CE-12/exit-4-Waechter fuer 2-arg-Pfade STUMM. — result.facts §1+Z2
- **Dataset-Single-Source-Doktrin**: neuer Experiment-XML-Bau zieht Datasets AUSSCHLIESSLICH ueber `<datasets akte_ref>` + super-seitige test_data_xml/<name>.test_data.xml-Akten; example_configs/test_data_sets.xml=deprecated+inert (nur Legacy-Demo-Builder xml_config_parser.cpp:100), nie loeschen, hoechstens additiver DEPRECATED-Marker. — result.facts Z3
- **Vollstaendige per-Wrapper name()→Header-Liste** (Literal + datei:zeile je Wrapper ueber alle damals 26 Achsen; u.a. search_algo=22, allocator=26, queuing_q1=15 Wrapper) liegt zeilen-verankert in result.verif.v1 — nutzbar als 13.07.-Baseline fuers 172-Eintraege/17-Slot-Nachschlagewerk-Delta (INC-2D).
- **Struktur-Befund fuer §28**: JEDES Achsen-Modul traegt bereits seine eigene Registry-Header-Datei (axes/<modul>/axis_NN_*_registry.hpp bzw. topics/.../..._registry.hpp mit All*/Enabled*-Listen) — die per-Modul-Andockpunkte fuer die je-Modul-XML-Registries existieren; zudem 3 build-only- + 4 node-shape-Achsen ausserhalb des serialize-Schluessels (shape optional via with_shape_segment). — result.facts §2a

**Superseded:**
- 19/26-Achsen-Topologie + T0..T18-Tabelle → INC-2c/2d: heute 17 Komposition-Achsen T0..T16 (kCompositionAxisNames std::array<...,17>, axis_path_serialization.hpp:34, ABI-6); telemetry verliess Komposition INC-2c/ABI-5 (CEB-System-Achse, H-10-Sidecar), isa INC-2d/ABI-6 (Target-ISA-System-Achse, +target=-Sidecar); Wrapper-Counts/Zeilenanker stale — nur als Baseline fuers Delta verwenden
- INC-B/R-B-Blocker "fehlende cpp_type_name/header_include auf 4+1 per-Organ-Wrappern" → GESCHLOSSEN: COMDARE_DEFINE_ORGAN_LOCATION existiert (anatomy/organ_location.hpp:46), auf prt-art-Slots angewandt (axis_01_page_type_slot.hpp:60, axis_14_value_handle_slot.hpp:54); Fork-Option (i) umgesetzt
- Z1/M-CE-10 "sota Stufe2 ignoriert lebewesen → 1 binary_id" → GEFIXT: per-Host-Stufe2-Kompositionen (ArtPrtStufe2ReplaceComposition prt_art_merge_reference.hpp:122ff, Masstree... :129ff) mit Host-Dispatch in sota_catalog.hpp:171-188
- Alle golden-320-Bezuege → new-golden all-axes N=2^17=131072

**§28-Registry-Relevanz:** Belegt, dass die per-Modul-Registry-Struktur im Code bereits existiert — genau die Andockpunkte, aus denen die §28-XML-Registries je Achsen-ART in IHREM Modul generiert werden muessen. Enabled*-Leitplanke + COMDARE_DEFINE_ORGAN_LOCATION liefern die name→(FQ-Typ,Header)-Bruecke, die das XML-Angebot resolvbar macht. Der ABI-5/6-Auszug von telemetry+isa in System-Achsen-Sidecars bestaetigt empirisch die §28-Trennung Organ- vs System-Registry; nur der gewaehlte Enabled*-Wrapper geht in den serialize-Schluessel → stuetzt Haupt-Achse=statisch-im-Binary.

**Speist in:** resolver-registry, planer-bau, nachschlagewerk-delta, golden-mock, roadmap

---

### K4 — 20260713-audit-3-schema-familien

`docs/sessions/backups/20260713-audit-3-schema-familien`

**Was es ist:** 5-Agenten-ultracode-Audit (4 Audits + Live-Synthese, 643k Tokens, 13./14.07.) der gesamten XML-Schema-Flaeche: kartierte die 3 Schema-Familien (comdare_thesis_profile / experiment_config / messreihe_v32) datei:zeile-belegt und loeste den mehrdeutigen Entscheidungstext "V32 aktivieren" auf — Empfehlung: Familie A vollenden statt Familie C wiederbeleben. Nur Rohdaten (wf-RESULT-raw.json mit vollstaendiger Synthese, wf-journal.jsonl).

**Kern-Erkenntnisse:**
- **Schema-Landschaft** (Basis fuer Resolver-Registry-Verortung): 3 Familien = 4 XML-Root-Formate. A: comdare_thesis_profile=aktiver E4-Alleinweg, KEINE XSD (Prosa-Schema SCHEMA.md:17-40 + Code-Validator validate_profile.hpp:240-292). B: comdare_messreihen (nur COMDARE_LEGACY_MESSREIHEN=1) + comdare_experiment config_a/b/c=VERWAIST, 0 C++-Reader. C: messreihe_v32 (test_data_xml/messreihe_v32_schema.xsd:21-147, damals einzige XSD)=off-gegateter Stub. — wf-RESULT-raw.json /result/synthese
- **Ein-Schema-Zuhause-Grundsatz** (direkt §27/§28-relevant): Ruling 12.07. (SCHEMA.md:39, Hinweis K) — <datasets>/<measurement_categories> gehoeren ins aktive E4-Profil-Schema, NICHT in den degradierten Messreihen-Pfad; ein zweites konkurrierendes Schema-Zuhause ist verboten. Die Registry-XMLs (ANGEBOT) muessen als eigene Gattung NEBEN dem Anwender-XML (ANZEIGE) andocken, nicht als Rivale von Familie A.
- **Stub-Karte fuer Phase-0**: execute_messreihe war Stub "return 0" in Code/02_messung_driver/v32_orchestrator.hpp:81/:84; echter EE-A/EE-B-std::async-Welch-Code test-only bei :100-180; COMDARE_V32_ENABLE=OFF (CMakeLists.txt:37) fuers Driver-Binary No-Op; Code/README.md:110 behauptete faelschlich default ON. Genau dieser Stub ist heute der Wiederverwendungs-Punkt des Planer-Bauplans (jetzt v32_messreihe_antrieb.hpp, in main.cpp verdrahtet). — Familie C (b)/(d)
- **Familie-A-Kette** (Andock-Linie fuer Planer/Resolver): XML → parse_thesis_profile (xml_config_parser.hpp:248, struct ThesisProfile :195-234, datasets :233) → build_axis_levels → StaticBinaryView → BuildOrchestrator → 1 DLL je Permutation; Validator kennt kKnownDatasetLoaderIds{string_corpus,sosd_uint64} (validate_profile.hpp:83); Schema trennt bereits compile_dims (statisch) von runtime_dynamic — Praezedenz fuer §28. — Familie A (b)/(c)
- **Bit-Bank ≠ Familie C**: PermutationFlagsV32 (14 Banks/82-bit) + AbiV1ToV2Mapper wurden 13.07. getilgt (#36, ce ebcc5498) — SEPARATES V32-Aera-Artefakt; messreihe_v32-XSD + Orchestrator-Stub blieben. Verwechslungsgefahr bei jeder "V32"-Nennung in aelteren Dokumenten.
- **Einziger genuiner Mehrwert von Familie C**: paralleler EE-A/EE-B-Vergleich (CacheEngine vs. PrtArt, Welch-t-Test) + reichere op_type-Semantik OP-1..6 (Bulk-Insert/Range-Delete), die YcsbWorkload A-F nicht traegt — nur als eigenstaendiges Experiment bauen, nie als Umweg fuer Datasets. — Abschnitt 3
- **<measurement_categories> als XML-Element = 0 Code-Treffer**; existierte nur als C++-Enum (16 Kategorien, measurement_category.hpp) + SCHEMA.md:39-Prosa, DATEN-gated (#215/#156) — der offene Arbeitspunkt, den heute die §28-Mess-Achsen-Registry auffaengt.
- **Offen/UNBELEGT (honest-100%)**: experiment_driver.hpp lokal nicht auffindbar; "Bit-Bank" als literaler Term im Session-Korpus unbelegt; "Import/Export B+-Baum" in V32-Kontext unbelegt; config_a/b/c_*.xml verwaist = Aufraeu-Kandidaten (nur mit GO).

**Superseded:**
- "Familie C bleibt toter Stub, Tilgung nach E4-Subsumtion (G7)" → Direktive 12./13.07. (v32→Strategy) + Planer-Bauplan 19.07. Phase-0: Stub wird WIEDERVERWENDET (Code/02_messung_driver/v32_messreihe_antrieb.hpp, in main.cpp verdrahtet), nicht getilgt
- "einzige XSD = messreihe_v32_schema.xsd" und "echter XML→Struct-Parser existiert nirgends" → live existieren Code/test_data_xml/experiment_schema.xsd (zweite XSD), Code/02_messung_driver/messreihe_v32_parser.hpp, experiment_phase_strategy.hpp (Strategy-Umbau vollzogen)
- golden 320 (m3v2_study 4x4x5x4, cap=320) → golden N=2^17=131072
- 19-Achsen/19-Slot-Anatomie in Familie A → 17 Organ-Achsen/ABI-6
- Empfehlung "<measurement_categories> als M-1-Feld an ThesisProfile" → REFRAMED durch §28: Mess-Achsen-ART bekommt EIGENE Registry in IHREM Modul per XML; Kategorien gehoeren ins Mess-Registry-Angebot
- GO-Stand des Audits → VOLLES GO 17.07.

**§28-Registry-Relevanz:** Ist-Kartierung ALLER existierenden XML-Schema-Zuhause, gegen die die 3 Achsen-Art-Registries verortet werden muessen. Drei Lehren: (1) Ein-Schema-Zuhause-Grundsatz — Registries sind eine NEUE Gattung (ANGEBOT), duerfen kein Rivale des Anwender-XML (Familie A=ANZEIGE) werden; Familie C zeigt, wie ein zweites konkurrierendes Zuhause zum toten Stub verrottet. (2) Familie A trennt bereits compile_dims von runtime_dynamic — Schema-Praezedenzfall fuer §28. (3) Familie B (0 Reader) ist die Warnung vor Registry-XMLs ohne verdrahteten Konsumenten: jede Registry braucht ab Tag 1 ihren Parser-Konsumenten (Planer=Resolver-Linker), sonst naechste Karteileiche.

**Speist in:** resolver-registry, planer-bau, roadmap, golden-mock

---

### K5 — 20260716-experiment-planer-codegen-design

`docs/sessions/backups/20260716-experiment-planer-codegen-design`

**Was es ist:** Read-only-Opus-Design-Workflow (Nacht 16.07.), produzierte die F6-Design-Vorlage: Experiment-Planer als XML→CI/cmake-Code-Generator mit benannten GoF-Mustern (Interpreter/Director/2 ConcreteBuilder/Template-Method), IST-Naht-Analyse, Increments I1-I5, Forks F1-F4 — Primaerquelle des Bauplans vom 19.07. ACHTUNG: Der backups-Ordner selbst ist LEER; einzige Quelle ist `docs/plaene/20260716-experiment-planer-codegen-design-DOSSIER.md` (22 Zeilen).

**Kern-Erkenntnisse:**
- **Kern-Design** (vom Bauplan uebernommen): Interpreter (XML→ExperimentPlan = geordnete PhaseStep-Liste: je Phase Systemachsen-Kombis x Tier-Binary-Selektion x Lastprofile x Mess-Modus) + EIN ExperimentPlanDirector::construct(IPlanBuilder&) + ZWEI ConcreteBuilder CiYamlBuilder/CMakeGraphBuilder aus DEMSELBEN Walk → CI↔cmake-Synchronie strukturell garantiert, nie zwei parallel gepflegte Emitter — DOSSIER.md:13
- **Template-Method je PhaseStep**: resolve_selection (CoR selection_filter_chain) → emit_build → emit_measure → emit_serialize (flacher Systemachsen-Ordner + tiefer Tier-Baum + nur-dynamik-CSV) → emit_copy (build→ziel atomar + Index-Manifest); resolve_selection = Keimzelle der §27-Resolver-Stufe (Registry-ANGEBOT x Anwender-XML-ANZEIGE aufloesen) — DOSSIER.md:13
- **Andock-Blaupause**: cmake/catalog_codegen.cmake:29-37 (add_custom_command + $<TARGET_FILE:cli> + DEPENDS <xml>) als Vorbild; 3 Naehte: (1) App-Target comdare_experiment_planner nach Muster catalog_codegen_tool, (2) cmake/experiment_plan.cmake 2-Pass via --emit-cmake + include(), (3) --emit-ci → Child-Pipeline-YAML → trigger:include:artifact: — DOSSIER.md:7,10 (Bauplan uebernahm alle 3)
- **NICHT uebernommene offene Forks** (Bauplan-Forks A-E decken sie nicht): F2 Systemachsen-Fan-out parallel:matrix vs. Downstream-trigger je Runner-Tag ([baremetal,amd]/[intel]/[arm64], wie CE-CI :98-133); F3 Verhaeltnis zu COMDARE_PERMUTATION_PROFILE (Empf.: erst unabhaengig, mittelfristig Single-Source aus metadata.mode); F4 Index-Manifest-Format JSON/XML/CSV passend zum Reihe-C-Konsumenten — DOSSIER.md:14,22; fuer CI-Detail-Kette + Serialisierung noch zu entscheiden
- **failed-Sichtbarkeits-Design** (Bauplan-I4, per Fork C post-Deadline): try/catch um run_*_perm (cache_engine_builder_iterator.hpp:790-794), CSV-Zelle "failed" statt null + <binary_id>.error.log neben result.csv, Harness continue, Stamp NICHT gesetzt — additiv zum two_phase_valid-Pfad — DOSSIER.md:17
- **Debug/Mess-Schalter**: neues `<measurement mode="debug|mess" threads="N"/>`; Bau IMMER parallel; Debug=Thread-Pool ueber (Binary x Setting), Mess=1-Thread + thread_count-Konsum (#221), durchgereicht an measure_under_setting (cache_engine_builder_iterator.hpp:777, loop.run :836) — DOSSIER.md:16
- **Grenzziehung**: Planer/Codegen strikt Pre-Build/Configure-Zeit; Hot-Path bleibt compile-time-only (PhaseStrategyFor<S>); kein Python; CI-Umbau = measure:* ersetzt durch 1 generierenden Job + Child-Pipeline, INERT-by-default — DOSSIER.md:14,18
- **Increment-Reihenfolge** (Roadmap-Basis): I1 Planer-Skelett --dump-plan + Contract-Test (golden-neutral) → I2 CMakeGraphBuilder + 2-Pass opt-in -DCOMDARE_EXPERIMENT_XML= → I3 CiYamlBuilder/Child-Pipeline INERT → I4 mode-Schalter + failed-Zelle → I5 Serialisierungs-Emitter — DOSSIER.md:21; Bauplan schnitt per Fork C: I1+I2 vor Deadline 28.07., I3-I5 danach

**Superseded:**
- IST-Befund "Planer-Binary existiert NICHT" + ce-submodul-only Andockpunkt-Analyse → Bauplan-Phase-0-BLOCKER: im super existiert Code/02_messung_driver/v32_messreihe_antrieb.hpp:214 (ZWEITES run_experiment_profile mit CT-MergeStrategy-Dispatch + execute_messreihe:259-Stub, selbst "OFFIZIELLER Einstieg INC-G+H"); neuer Director daneben waere die dritte Enumerations-Engine — BAUPLAN.md:4,219: Stub wiederverwenden/reconcilen
- Fork F1 (CI-YAML Configure-Zeit vs. Planer-Laufzeit-Job) → ENTSCHIEDEN zugunsten (b) trigger:include:artifact, im Bauplan als I3 fixiert (BAUPLAN.md:61)
- Planer-Input "2 Registries" (ce+prt-art) → §28: 3 je Achsen-ART; der Mechanismus (Registry-Pfade als statische compile-defs per CMake-Interface "wie messung_driver", DOSSIER.md:10) bleibt der gueltige Andockweg
- Zeilanker gedriftet: xml_config_parser.hpp:288-303 → heute :300 (ExperimentProfile) / :337 (parse_experiment_profile) per BAUPLAN.md:38; "parse_experiment_profile nur --validate/test-verdrahtet" verfeinert: run_experiment_profile (experiment_run_entry.hpp:144,148-149) ruft es, Live-Pfad=run_experiment_profile_facade (super main.cpp:679)
- "CI heute statisch, measure:golden-320 hartcodiert" → new-golden N=2^17 als Ziel-Referenz; der CI-Umbau-Weg bleibt

**§28-Registry-Relevanz:** Definiert den Andock-Mechanismus: Planer liest XML + Registries als STATISCHE compile-def-Pfade — genau so docken die 3 §28-Art-Registries an; die Anzahl "2" ist auf 3 ueberholt. Der Template-Method-Hook resolve_selection (+ CoR selection_filter_chain) ist der Ort, an dem ANGEBOT gegen ANZEIGE aufgeloest wird (§27 Planer=Resolver-Linker). Grenzziehung "Planer=Configure-Zeit, Hot-Path compile-time-only" traegt §28 Haupt-Achse=statisch; der <measurement mode/threads>-Schalter zeigt das Muster fuer dynamische Unter-Achsen-Einstellungen.

**Speist in:** planer-bau, resolver-registry, ci-kette, parallelisierung, roadmap

---

### K6 — 20260716-gesamtkonzept-experiment-ausfuehrung

`docs/sessions/backups/20260716-gesamtkonzept-experiment-ausfuehrung`

**Was es ist:** Read-only-Untersuchung (F3-Auftrag, 16.07.): Gesamtkonzept-Abgleich der Ende-zu-Ende-Experiment-Ausfuehrung (XML→Planer→CI/cmake-Codegen→CEB→Mess-Modi→Zwei-Phasen-Schleife→serialisierter Ergebnis-Baum) als IST-vs-SOLL mit datei:zeile-Belegen, plus Reihe-C-Kanonisierung (Option C) und 4 Rest-Klaerungen Q1–Q4. Backup-Ordner LEER; Synthese=`docs/plaene/20260716-gesamtkonzept-experiment-ausfuehrung-DOSSIER.md`.

**Kern-Erkenntnisse:**
- **SOLL-Fluss** (User-bindend, = Ende-zu-Ende-Vision der CI-Kette): EINE Experiment-XML → Experiment-Planer → generierter CI-Code XOR cmake-Code (beide synchron aus DERSELBEN XML) → CEB baut Tier-Binaries C++-orchestriert → Mess-Modi (Debug parallel / Mess 1-Thread) → Zwei-Phasen-Op-Schleife x n_repeats≥3 → serialisierter Ergebnis-Baum → Ziel-Ordner (DOSSIER.md:7,10)
- **Planer-Gap-Kartierung**: parse_experiment_profile nur test-/--validate-verdrahtet, NICHT auf dem Mess-Pfad; offizieller Run ueber parse_thesis_profile (m3v2); CoR-Stufenfilter-Kette selection_filter_chain.hpp UNVERDRAHTET; experiment_phase_strategy.hpp header-only INERT ohne Konsument (DOSSIER.md:9,27)
- **Groesster SOLL-Gap**: XML→CI/cmake-Interpreter ABSENT — CI-Fan-out statisch handgeschrieben (trigger:*); einziges XML-adjazentes Codegen ist enum-getriebene permutations.cmake:17-40 via COMDARE_PERMUTATION_PROFILE, NICHT via Experiment-XML (DOSSIER.md:10,28)
- **Mess-Modi-IST**: KEIN codierter Debug/Mess-Schalter; zwei entkoppelte Ebenen (Bau-Parallelitaet parallel_jobs()=total/cores_per_build in build_orchestrator.hpp:79-82 vs. thread_count als LABEL-ONLY-Pinning auf 1, nicht konsumiert, #221-deferred); braucht NEUEN XML-getriebenen Schalter + echte thread_count-Konsumtion, Gattungs-Threading aus dem Tier-Binary (DOSSIER.md:12,29)
- **Bestehende Mess-Mechanik** (~80% steht, wiederverwenden statt Parallelstruktur): rollbackable_tier.hpp:8 save→warmup(kalt)→rollback→measure; repetitions als DynDim (profile_run_entry.hpp:250-252); CEB-Kette parse_thesis_profile→profile_to_tree→StaticBinaryView→BuildSelection→BuildOrchestrator::provision_all→adhoc_emitter, zur Laufzeit C++-orchestriert NICHT via CMake; messung_driver faehrt E4-XML-Default ueber run_profile_facade main.cpp:597-646 (DOSSIER.md:11,13)
- **Serialisierungs-Design** (fuer Ergebnis-Baum + 2^17-Mock-Output-Layout): Systemachsen FLACH als Ordner, Tier-Achsen TIEFER Baum + dynamik-only-CSV; IST-Embryo per_binary_subdirs + result.csv (cache_engine_builder_iterator.hpp:67,764-853); statische Achsen packt-kodiert im binary_id-Pfad (axis_path_serialization.hpp:30-34), dynamische Dims als setting_label-Zeilen; build→ziel-Copy fehlt; Empfehlungen: flach-je-Binary + Sidecar-Manifest (Q1b), statische per-Achsen-Spalten WEG / ;phase;engine + dynamische bleiben (Q2), Ordner grob→fein Host→OS→Toolchain→ISA + Tag-Spalten additiv gespiegelt (Q3), maschinenlesbarer Index-Manifest + atomare build→ziel-Copy (Q4b) (DOSSIER.md:14,34-37)
- **Reihe C kanonisch = Option C**: KEINE 4. Stufe, kein 4. MergeStrategy-Enum (pruefling_merge.hpp:130-134 = 3); zwei Auswertungs-VIEWS auf denselben serialisierten Baum — View 1 SdT-vs-Pruefling je Stufe (Compiler/ISA/OS NUR Ordner-/Gruppierungs-Schluessel, NIE binary_id) + View 2 build-ueber-Build-Regression (Anker diff_against, Welch/Holm f15_compare) (DOSSIER.md:18-23)
- **Governing Deadline 28.07.**: CI UND Standalone messfaehig, cmake+C++23, EINE Maschine (DOSSIER.md:16)

**Superseded:**
- Registry-Modell "2 Registries (ce+prt-art), in den Driver einkompiliert COMDARE_CE/PRT_AXIS_REGISTRY_PATH main.cpp:312-314" → §27/§28: je Achsen-ART EIGENE Registry im EIGENEN Modul als XML-ANGEBOT
- "Planer-Executable existiert NICHT" als offener Gap → adressiert durch BAUPLAN 19.07. (inkl. Phase-0-Stub-Wiederverwendung); der Gap-Befund bleibt als Andockpunkt-Karte gueltig
- Q3-Schutzargument "test_profile_roundtrip==320 schuetzen" → golden N=2^17; das additiv-gespiegelte Vorgehen bleibt als Muster
- Q1–Q4 als OFFENE Fragen → durch VOLLES GO 17.07. + Serialisierungs-Direktive 18.07. entschieden (im Wesentlichen entlang der Dossier-Empfehlungen); heute Nachschlag-Referenz

**§28-Registry-Relevanz:** Belegt den Vorlaeufer-IST-Zustand (2 monolithische Registry-XMLs, per CMake-Pfad einkompiliert), den §28 in 3 Art-Registries aufspaltet. Liefert die Persistenz-Seite der §28-Statisch/Dynamisch-Trennung: statische Achsen packt-kodiert im binary_id-Pfad bzw. als Ordner/Manifest (NIE Spalten), dynamische Unter-Achsen als CSV-Spalten/setting_label-Zeilen (DOSSIER.md:14,35).

**Speist in:** ci-kette, planer-bau, roadmap, resolver-registry, parallelisierung, golden-mock

---

### K7 — 20260716-wp1-parallel-engine-gestoppt-fork-a

`docs/sessions/backups/20260716-wp1-parallel-engine-gestoppt-fork-a`

**Was es ist:** Additiv gesichertes Backup der verworfenen, NIE applizierten WP-1-Agent-Edits (507-Zeilen-Patch an Code/02_messung_driver/v32_katalog_driver.hpp + v32_messreihe_antrieb.hpp) vom Moment des User-Stopps der v32-Parallel-Engine am 16.07. („baut gerade eine zweite sinnlose parallele Engine"). Historischer Grund des heutigen Phase-0-Blockers; Synthese in `docs/plaene/20260716-wp1-parallel-engine-gestoppt-fork-a-NOTIZ.md`, Bruecken-Design in `docs/plaene/20260716-fork-a-bruecken-dossier-DOSSIER-ENTWURF.md`.

**Kern-Erkenntnisse:**
- **STOPP-Entscheid + Fork A (bindende Generalregel)**: WP-1 haertete eine ZWEITE parallele Engine statt den offiziellen Pfad zu nutzen. Fork A = v32-Strecke wird zur DUENNEN Orchestrierung UEBER dem offiziellen E4/CEB-Pfad (3-Phasen-XML → CEB-Selektionen → echte DLLs → Loader → Pruefdock → E4-Lastprofile → offizielle CSV; Welch konsumiert die CSV). Generalregel: IMMER bei der offiziellen Architektur bleiben. — NOTIZ.md:3-8
- **Bruecke zum heutigen Phase-0-Blocker**: Genau dieser Stopp-Grund ist im 19.07.-Bauplan Befund 1 — super v32_messreihe_antrieb.hpp:execute_messreihe (heute return-0-Stub/INERT) wiederverwenden/reconcilen statt dritten Enumerations-/Export-Walk daneben. — BAUPLAN.md:4,:219; Wurzel NOTIZ.md:3-8
- **Audit-Befunde F01-F03 bleiben gueltig**, werden in der Bruecke geloest: F01 Pruefdock-Gate fail-loud ("import → GATE → (nur bei pass) messen"; Fail ⇒ Zeile ehrlich Inconclusive, Artefakte GESCHRIEBEN, Lauf FAIL Exit 6, "gated != gueltig"). — NOTIZ.md:12-13; wp1-halbfertige-edits.patch:267-283,:497-503
- **Validierungs-Doktrin F02/F11/F12** (wiederverwendbar beim Stub-Fuellen): XML <metadata><mode> AUTORITATIV, env/Parameter nur expliziter stderr-geloggter Override; unbekanntes mode-Token fail-loud Exit 7 statt stillem Defined-Fallback; leeres/unbekanntes <op_types> Exit 8, KEINE "OP-1"-Erfindung. Exit-Kontrakt 0/2/3/4/5/6/7/8. — patch:228-250,:297-318,:418-479
- **Ehrlicher Dispatch F03** (Doktrin fuer alle Mess-Treiber): getriebenes Op-Muster MUSS dem CSV-Etikett entsprechen (kein Phantom-Etikett); nicht real treibbare WorkloadKinds fail-loud ablehnen; Prefill EINMALIG VOR der Messschleife; injektives key_for(index,seed)=(index*2654435761)^seed als Single-Source fuer Prefill UND Mess-Ops. — patch:30-67,:104-135,:161-177
- **CT-Label-Pattern**: KatalogEngineLabel<C,kEngineA> leitet CSV-Engine-Labels compile-time aus dem REALEN Kompositions-Typ (C::name) ab statt aus Literalen — static constexpr Storage, kein dangling. Uebertragbar auf jede CT-Label-Ableitung im Planer/CEB. — patch:185-201
- **REGISTRY-WARNUNG (direkt fuer §27-Resolver)**: die gestoppte Parallelstrecke validierte mit LEEREM registry_dir — Registry-Abgleich-Pruefungen (4)+(5) uebersprungen (rein strukturelle Validierung). Lehre: die Anwender-XML (ANZEIGE) NIE ohne Registry (ANGEBOT) validieren; Bruecken-Fassade reicht registry_dir + load_profiles-Verzeichnis herein. — DOSSIER-ENTWURF.md:41,:80 (Verweis v32_messreihe_antrieb.hpp:264)
- **Bruecken-Design = PROJEKTION, kein Neubau**: ExperimentProfile → Paesse des bestehenden run_profile-Unterbaus (phase.merge x lebewesen → sota_module_for → render → CEB/BuildOrchestrator → AnatomyModuleLoader), kein neuer Bau-/Lade-/Mess-/CSV-Code; einziger fehlender Baustein = CSV→Welch-Konsument; 8 offene Forks (FORK-1..8) dokumentiert, NICHT vorweggenommen. — DOSSIER-ENTWURF.md:33-56,:88-96

**Superseded:**
- Gesamte parallele In-Process-Messstrecke (KatalogTierEngineCallable, drive_one_engine, 12-col-CSV MessreiheReportExporter, in-process-Welch, hartkodierter Workload 2000/2000/seed42, HOT-only PhaseCompositions) → Fork A/offizieller E4/CEB-Pfad; Code deprecatet-inert (Doku-nie-loeschen). — DOSSIER-ENTWURF.md:60
- Der Patch als CODE: nie angewandt, wird nie als Datei reaktiviert — nur Konzept-Transfers (DOSSIER-ENTWURF.md:62); Patch zeigt den VOR-Stub-Vollstand von execute_messreihe → nur Kandidaten-Material fuers Phase-0-Wiederfuellen
- Increment-Schnitt I1-I7 des Bruecken-Dossiers → von VOLLES GO 17.07. (INC-0→1→2) und Bauplan 19.07. absorbiert; Doktrin (keine Parallelstruktur, fail-loud, Projektion statt Neubau) gilt weiter; FORK-1..8-Entscheide gegen Ledger §19 abgleichen
- Stand-Zahlen der Patch-Aera → 17 Organ-Achsen/ABI-6, golden-N=2^17-Fixture, #50/#51/#52 done

**§28-Registry-Relevanz:** Zweifach. (1) Validierungs-Kontrakt der Registry-XMLs: F02/F11/F12-Doktrin (XML autoritativ, Overrides nur explizit+geloggt, unbekannte Token fail-loud, KEINE erfundenen Defaults) ist das Muster fuer die 3 Art-Registries — plus konkrete Warnung: leeres registry_dir uebersprang Pruefungen 4+5; der §27-Resolver darf die ANZEIGE nie rein strukturell ohne das ANGEBOT aufloesen. (2) Haupt-statisch/Unter-dynamisch: der Stopp-Grund war genau die Verletzung dieser Trennung — Parallelstrecke kompilierte HOT-only fest UND hartkodierte den Workload runtime; Fork A stellt her, dass die Haupt-Achsen-Wahl statisch ueber CEB-gebaute Ziel-Binaries laeuft und dynamische Unter-Einstellungen aus der XML kommen.

**Speist in:** planer-bau, resolver-registry, roadmap, ci-kette

---

### K8 — 20260710-achsen-unterachsen-utilization

`docs/sessions/backups/20260710-achsen-unterachsen-utilization`

**Was es ist:** 9-Agenten-ultracode-Audit (10.07., HEAD c022ce05) ueber alle ~29 Achsen-Interfaces: fehlende Unter-Achsen (Tag-Kollaps + Skalar/Struktur), Utilization-Luecken je Achse, Zirkularitaets-Check mit L0-L5-Schichtung, Telemetry-Platzierungs-Befund, HW-Prefetcher-Deep-Research, priorisierte Bau-Reihenfolge Phase 0-6. Nur Rohdaten; Synthese im result-Feld von rohdaten/workflow-ergebnis.json, bindendes Layer-Modell in rohdaten/workflow-skript.js:11.

**Kern-Erkenntnisse:**
- **LAYER-MODELL (User-Klaerung 10.07., bindend — Ur-Fassung der Haupt/Unter-Semantik)**: jede Achse=ein Layer; eine statische (CT) Achse bildet einen strikten Layer, darunter dynamische Achsen-Nodes bis zur naechsten statischen Einhaengung; SPREAD einer Node=alle Variationen EINER Achse, ENTWEDER statisch-CT ODER dynamisch-Wert (nie beides); Unter-Achse=VOLL-Achse unter der CT-Haupt-Achse; Wurzel=System-Achsen (inkl. telemetry+Mess) als Visitor mit eingebauten Strategies. Die 5 RC-POD-Felder sind in Wahrheit UNTER-ACHSEN. — workflow-skript.js:11; RC-POD resource_controllable_tier.hpp:34-40
- **RC-Unter-Achsen-Ist damals**: nur 2/5 echt (pool_budget_bytes gegated, inline_threshold_bytes via axis_14_value_handle_observable.hpp:95-171); prefetch_distance PARTIAL (nur family_id==1 + COMDARE_MEASUREMENT_ON); batch_size + thread_count NO-OP (Namens-Drift batch_size: resource_controllable_tier.hpp:38=axis_03a vs profile_to_tree.hpp:84=cache_traversal); + 2 echte Iterable-Unter-Achsen ausserhalb des RC-POD (q1-Kapazitaeten {8..65536}, q2-Watermarks {50..95}). — ergebnis Abschnitt 1b
- **Querschnittlicher TAG-KOLLAPS**: ALLE Klassifikations-Tag-Structs (PG1-3, PC1-3, NT1-3, AA1-7, HM1-4, PF1-3, CC1-2, SR1-3, TM1-3, VH1-3, IS1-3, SE1-3, HW1-4, IO1-3, MG1-3, FT1-3, SA1-4, CT1-2, QS1-6, FS1-4) sind je Strategie genau EIN angehaengter Tag, nie als eigene StaticAxisVariants-Spreads materialisiert. EINZIGES real gekreuztes Paar und Vorbild-Muster fuer jede Registry-Kreuzung: ISA-x-SIMD-Compat-Filter (topic_hardware_config_set.hpp:41-59). — Abschnitt 1a
- **Utilization-Luecken-Liste**: 20 von ~30 Achsen ohne echte funktionale Cross-Application-Kante im Arbeitsmodus; durchgaengig echt nur node_type/value_handle/sequence-growth. Kritische no-ops: page_type (6 Klassen=Labels), prefetch (nur MEASUREMENT_ON), simd (SSE2-hart), general_hardware (unkonsumiert), thread_count, cache_traversal. DREI HEBEL: (A) ISA/SIMD-Dispatch in alle *_scan-Kerne, (B) axis_06-Allocator-Adapter in 11 Pool-Organe + 4 Shapes (tier_to_organ_mapping.hpp:46-115), (C) prefetch/concurrency/migration aus dem MEASUREMENT_ON-Fenster in den echten Hot-Path. — Abschnitt 2
- **Zirkularitaet**: Achsen-Anwendungsgraph ist DAG (verifiziert); topologische Schichtung L0 HW-Deskriptoren → L1 Primitive → L2 Form-Deskriptoren → L3 Strukturen → L4 Zugriff/Policy → L5 System/Root (telemetry+Mess-Apparat als Visitor); Regel: neue Kanten compute→provider abwaerts; telemetry-Root nur PULL (Snapshot-Visitor), nie von unten bepusht. — Abschnitt 3
- **Telemetry-Platzierungsfehler (damals)**: telemetry faelschlich Organ-Slot T10/19 (kV3AxisCount=19, observable_tier.hpp:47/85) statt System/Meta-Wurzel; Umbau als LETZTE Phase, weil ABI-Bruch. — Abschnitt 4
- **Prefetch-Unter-Achsen-Design (Blaupause statisch/dynamisch-Split)**: statische Unter-Achse=PrefetchShape-NTTP-Mixin analog cacheline_config.hpp (Teil der binary_id), dynamische Unter-Achse=prefetch_distance runtime-Spread darunter (kein binary_id, is_static=false profile_to_tree.hpp:79-80), hw_prefetcher=SYSTEM-Unter-Achse an der Wurzel (MSR 0x1A4 via wrmsr um den GANZEN Lauf, slurm_launcher.hpp:25,54-55 — nie organ-intern); 4 Zirkularitaets-Sperren. SOTA-Mapping mit Primaerquellen: Khuong/Morin 2017 (Eytzinger 2k-voraus — krasseste Luecke), Chen/Gibbons/Mowry SIGMOD'01, Masstree EuroSys'12, ART/HOT, Mahling DaMoN'25 in-tree ext/traversal/P25-Mahling direkt harvestbar. — Abschnitt 5
- **Bau-Reihenfolge-Prinzip (Phase 0-6)**: Provider vor Konsument (erst L0/L1 haerten), dann Tag-Spreads materialisieren, dann Prefetch-Unter-Achse, dann Hot-Path-Hebung, dann Skalar-Unter-Achsen (hartkodierte Konstanten wie Bloom kBitmapBytes=8192, hash-lf 0.7, kStoreBlock=10, kBundle=4 heben, Abschnitt 1c), page_type materialisieren, telemetry-Root ZULETZT. — Abschnitt 6

**Superseded:**
- Alle Slot-/Zaehl-Zahlen (HEAD c022ce05, kV3AxisCount=19, T0-T18, telemetry=T10, "25/29/~30 Achsen") → 17 Organ-Achsen/ABI-6; das Herausheben von telemetry ist strukturell vollzogen, der Befund nur noch als Begruendung wertvoll
- System-Achsen-Bild (telemetry als einzige benannte Wurzel-Achse) → 6-System-Achsen-Doktrin inkl. extension_hardware (Q2 Option C) und Organ/System/Mess-Drei-Arten-Trennung §28
- Registry-Begriff (Config-Set-Registry=C++-Header TopicConfigSet::StaticAxisVariants_NN) → Tag-Spread-Materialisierung laeuft heute ueber die §27/§28-XML-Registries je Modul; die Forderung "je Tag-Dimension ein eigener Spread + kartesische Kreuzung mit Compat-Filter" bleibt, ihr Traeger wechselt
- hw_prefetcher via SLURM-Launcher-wrmsr als Sonderweg → in die System-Registry per XML-Unterachsen einbetten (Muster Compiler-Achse, 17.07.); Kern-Einsicht (System-Ebene, umhuellt ganzen Lauf) bleibt
- Utilization-Status-Spalten sind Stand c022ce05 — vor Verwendung gegen heutigen HEAD re-verifizieren; die LISTE bleibt als Pruef-Checkliste
- golden-320 implizit → golden N=2^17

**§28-Registry-Relevanz:** Direkte VORLAGE der §28-Semantik: das 10.07.-Layer-Modell definiert erstmals Haupt-Achse=CT-statisch im Ziel-Binary (strikter Layer) und Unter-Achse=Voll-Achse darunter, meist dynamisch (RC-POD; statisch XOR dynamisch) — exakt §28. Die L0-L5-Schichtung trennt Organ-Schichten (L1-L4) von der System/Mess-Wurzel (L5, nur-pull) und begruendet die 3-Arten-Trennung mit je EIGENER Registry; hw_prefetcher (System) vs. prefetch (Organ, statisches Shape + dynamische distance) ist das Musterbeispiel fuer Registry-Zuordnung nach Art. Tag-Kollaps-Befund (1a) + Skalar-Liste (1c) definieren, WAS die Organ-Registry als Angebot ausweisen muss; ISA-x-SIMD-Compat-Filter ist das Template fuer Registry-Constraint-Logik im Resolver.

**Speist in:** resolver-registry, nachschlagewerk-delta, roadmap, planer-bau, golden-mock

---

### K9 — 20260711-e4prime-messkurven-typsystem-wurzel

`docs/sessions/backups/20260711-e4prime-messkurven-typsystem-wurzel`

**Was es ist:** Deep-Research-Workflow (5 Opus-Agenten: 2 Research, 1 Design-Synthese, 2 Kritik; ~360k Tokens, 11.07.): entwarf die kleinste buildbare fork-FREIE Wurzel-Slice des Messkurven-Typsystems (architektur/20 §B) — AxisLayerSpine + Blut/Observer-Dock ueber die 16er-Mess-Registry, mit vollstaendigem Kardinalitaets-Inventar je Map-Ebene; beide Kritiken NEEDS-REVISION, der Header wurde nie gebaut — Wert liegt in Doktrinen und Inventar.

**Kern-Erkenntnisse:**
- **MESS-REGISTRY-KEIM fuer §28**: kMeasurementAxisRegistry = 16 MeasurementCategory (9 TimeObserver / 7 PmcCounter via regime_of), Muster constexpr std::array + for_each_measurement_axis (index_sequence-Fold) + consteval static_assert-Vollstaendigkeit; Spine+16er-Observer-Dimension waren die EINZIGEN fork-freien Dimensionen; Mess-Wurzel laut Doc 20:112 von allen 7 Map-Forks UNABHAENGIG, wird ZUERST gebaut. — typsystem-design-ergebnis.json (result.design.cardinality_classes, research[1] Q5); Code heute unveraendert: ce measurement/measurement_axis_registry.hpp:23-74
- **Single-Source-Doktrin (Doc 20 §I, bindend fuer jede neue Registry)**: is_static hat genau EINEN Producer (build_axis_levels, profile_to_tree.hpp); die Parallel-Registry axis_binding_registry wurde gebaut und VERWORFEN (null Produktions-Konsumenten + driftende Zweitkopie, revertiert 10.07., LEDGER:431). Jede Registry muss KONSUMENT sein, per Runtime-Contract-Test gekoppelt — nie zweite Kopie. — result.design.recommendation + critiques[1]
- **Null-Konsumenten-Falle als Abnahmekriterium**: CT-Achsen-Klassifikation nur gerechtfertigt mit (a) echtem nicht-test-Konsumenten UND (b) Contract-Test gegen is_static IM SELBEN Increment. Beide Kritiken belegten per grep: einziger Registry-Konsument war test_phase6_vorbau.cpp. Gilt heute fuer jede der 3 §28-Registries. — critiques[0]+[1], result.design.risks[0]
- **Kardinalitaets-Konflation (Kritik-Hauptbefund)**: DREI Strukturen fallen NICHT zusammen — (1) kanonischer Organ-Registry-Split (damals 14/5), (2) daten-getriebene build_axis_levels-Ausgabe (Fixture: 4 static/7 dynamic; m3v2: ~20 static/3 dynamic; dieselbe Achse kann in BEIDEN Bloecken erscheinen: value_handle static[3] UND dyn[9], prefetch=2 dynamische Ebenen), (3) profile_to_tree emittiert 7 dynamische AxisLevels, nicht 5. Registry=ANGEBOT (Kanon) vs. Anwender-XML-Materialisierung (daten-getrieben) sind verschiedene Ebenen — der §27-Resolver muss benennen, welche er bindet. — critiques[0] Issue 1, critiques[1] Issue 2
- **Doc-21-Layer-Modell = INTERLEAVED Haupt/Unter, NICHT flache 2-Block-Partition**: statische Haupt-Achse = strikter Layer, ihre dynamischen UNTER-Achsen haengen DARUNTER, bis die naechste statische Konfiguration folgt (static→dyn→static→dyn). Dokumentierter Keim der §28-Regel. — critiques[0] Issue 2 (Doc 21 §A.1+§A.5)
- **Map-Ebenen-Inventar HEUTE/PLAN mit Fork-Gates** (Basis fuer XML-Featurespace + golden-Mock): framework 1 (YCSB) → 13 (H1/H5, nur Thesis-Vokabular tab:wl-frameworks, KEIN Code-Enum); workload-type 6 (YCSB A-F) → 14 LP01-LP14; workload-size 4 Sweep {2^14,2^17,2^20,2^23} → ~4 maschinenrelative Cache-Regime + 2 Gates (H3) [2^17=131072 = heutiges golden-N ist einer dieser 4 Punkte]; operation_type DREI nicht-deckungsgleiche 6er-Enums (Metric/WorkloadOpKind/OperationKind) → std-C++23-assoziatives-Interface-Set >6 (H4); property 2 Objectives → Pareto-Front + objective_tag (H6); observer_special_compare_property = reiner SOLL-Name. Doktrin honest-empty: keine Schluessel-Materialisierung ohne Fork-Daten. — result.design.cardinality_classes + research[1] Q1-Q6
- **Grenz-Disziplin (uebertragbar auf Planer-Bau)**: Runtime-Contract-Test ueber ThesisProfile-Fixture statt build-time-Ableitung (build-time beruehrt den golden-sensitiven binary_id-Pfad); Include-Kanten strikt abwaerts (builder::experiment→measurement gueltig; measurement→builder war der §I-tote cross-layer-Include); echte Signatur build_axis_levels(ThesisProfile const&, std::string mode_name, AxisRegistry const&). — result.design.boundary_compliance + critiques[1] Issue 3
- **Phasen-Gesetz**: telemetry-Wanderung (Organ-Slot → System/Meta-Achse an der Visitor-Wurzel, nur PULL) = ABI/Schema-Bruch, kommt bewusst ZULETZT (H7/Phase 6); Root-Visitor = System-/Blut-Achsen pullen Organ-Snapshots. — result.design.risks[5] + research[1] Zusatzfrage

**Superseded:**
- 19 Organ-Slots T0..T18 / 14-5-Split / kV3AxisCount=19 / TABU "ABI-MAJOR==4" → INC-2d: 17 Organ-Achsen/ABI-6; alle 19er-/14-5-Arithmetiken auf 17-Slot neu zaehlen
- Bau-Vorschlag axis_layer_spine.hpp + test_m_axis_layer_spine_wurzel.cpp: NIE implementiert (verifiziert); Rolle vom §27/§28-Strang und Bauplan absorbiert — nur die Doktrinen leben weiter
- golden==320 / m3v2-Materialkatalog-Kardinalitaeten → golden N=2^17=131072; die 4 Sweep-Punkte bleiben als Beleg, dass 2^17 ein etablierter Stuetzpunkt ist
- Registry NUR als C++-consteval-Header → §28: je Art eine XML-Registry im Modul; das constexpr-Muster bleibt als in-Binary-Gegenstueck
- Offene H3/H4/H6-Fragen → VOLLES GO 17.07.: alle Forks entschieden; "under-specified"-Markierungen nur noch Herkunftsdokumentation

**§28-Registry-Relevanz:** Zwei Achsen: (1) Die Mess-Art-Registry existiert bereits als in-Binary-Muster (measurement_axis_registry.hpp: 16 Kategorien, 9/7-Regime-Split, constexpr-Array + Fold + Vollstaendigkeits-static_assert) — Keim dessen, was die Mess-Registry per §28 als XML-Angebot ihres Moduls exportieren muss (fuer Heuristik-Kurven MeasurementCurve je Achse x Working-Set, fit_log_linear); die XML-Registry muss KONSUMIEREND generiert/kontrakt-getestet werden, nie als Zweitkopie (§I). (2) Die Kritik "Doc-21-Modell ist INTERLEAVED" ist exakt die heutige §28-Regel. Die Kardinalitaets-Konflation liefert das Warnbild: jede Art-Registry muss ihr ANGEBOT (Kanon) von der Anwender-XML-Materialisierung trennen.

**Speist in:** resolver-registry, planer-bau, golden-mock, nachschlagewerk-delta, roadmap

---

### K10 — 20260716-f4-systemachsen-dossier

`docs/sessions/backups/20260716-f4-systemachsen-dossier`

**Was es ist:** F4-Auftrag 16.07.: fuenf read-only-Recherche-Straenge (A Systemachsen-SOLL-Kartierung, B Sezierung der 4 toten vtable-Entwurfs-Header + AxisLibraryRegistry-Abgleich, C Live-Bestand-Klassifikation GATTUNG/MESS-SYS/WEDER-NOCH, D Compiler-Systemachsen-Design mit 20 Andockpunkten, E Planer-dritte-Anwendung + Thesis-Delta) als Rohdaten fuer das 20-Seiten-Systemachsen-Dossier — jede Aussage datei:zeile-belegt; KEIN zusammengefuehrtes Final-Dossier im Ordner, die Straenge sind die Synthese.

**Kern-Erkenntnisse:**
- **Organ- vs. System-Achsen code-verankert getrennt**: SystemAxis-CRTP-Wurzel "Blut" host-seitig, nie binary_id/E3; die Mess-ART hat BEREITS ihre modul-lokale CT-Registry (ce measurement_axis_registry.hpp:32-75, 16 Eintraege, consteval-Gate, for_each_measurement_axis, XML-validiert via <measurement_categories>) = direkter Keim der §28-Mess-Registry. — A-systemachsen-soll.md:91-172, C-live-bestand.md:117-134
- **Compiler-Systemachsen-Design ENTSCHIEDEN**: binary_id-Segment ABGELEHNT (jede statische Ebene, auch gepinnt, emittiert ihr Segment in JEDEN binary_id, experiment_tree.hpp:270-284 → bricht Roundtrip), Sidecar-only unzureichend; EMPFOHLEN = Build-Varianten-Muster als 4. Build-Achse analog page_type/09b/12: CompileFn-Factory je Toolchain (cxx-String-Parameter existiert, make_gpp_compile_fn, Default g++-16 via COMDARE_CXX), Artefakt-Koexistenz je Toolchain-Unterbaum, Mess-Resume-Stamp-Bump v5→v6 mit |cxx=, selbst-beweisendes Inspection-Symbol comdare_toolchain_inspect aus __clang__/__GNUC__, CSV-Tag-Spalte statt Identitaet. — D-compiler-achse.md §2.1 + Tabelle Z.336-359
- **CEB-Selbst-Compilerwahl kann NICHT der laufende CEB vollziehen** (muesste sich selbst neu bauen) — gehoert auf die Planer-Ebene (dritte Anwendung), die das vorgebaute gcc-CEB- oder clang-CEB-Artefakt waehlt/startet (Presets gcc-release/clang-release + ${BUILD_DIR}-clang-Koexistenz existieren); Host-Toolchain-Identitaet als Provenienz bereits einkompiliert (compiler_id/version/flags + isa_built_for/isa_ran_on) = "Definition statt Observer"-Muster fuer eine HostToolchainSystemAxis. — D §1.7+§2.2
- **Bauplan der Pflicht-Systemachsen-Familie** (Scheduling/Hardware/NUMA/Locking + Compiler als fuenfte): Haupt-Achse=compile-time (Definition/Provenienz), Unter-Achsen=runtime; Andocken OHNE Duplikate: Scheduling referenziert RC-POD thread_count (resource_controllable_tier.hpp:35) statt Neubau, Locking-SYSTEMachse strikt getrennt von Organ-axis_08, NUMA auf axis_12-POD-Feldern (hw_numa_capable) + cpuid-Probe — exakt das §28-Modell. — D §2.3, C §1/§5/§7
- **Negative Registry-Lehre**: die alte AxisLibraryRegistry wurde von Anfang an NICHT gegen die Header geschrieben — Phantom-Enum NumaAffinity existiert nicht, LockingMode-Registry-Namen 4/4 falsch, Achsen-ID-Kollision 13.4 (Memory-Interleave vs Co-Routine), 13.1 unvollstaendig; dazu 4 vtable-Entwurfs-Header mit 0 Include-Konsumenten (Widerspruch CRTP-Doktrin), Registry-Achse 15 modelliert Compiler als Tier-Permutations-Achse statt Systemachse → §28-Registries MUESSEN compile-validiert/aus dem Code abgeleitet sein, nie handgepflegte String-Tabellen. — B-header-seziert.md §5.1+§5.2+§7
- **Dritte Anwendung (Experiment-Planer mit XML-Interpreter)**: Parser-Fundament existiert als ce-Modul (parse_experiment_profile + validate_experiment_profile gegen die 2 REALEN Registry-XMLs cache_engine_axis_registry.xml + prt_art_axis_registry.xml); alle Planungs-Bausteine (experiment_tree/StaticBinaryView/BuildSelection/CoR-selection_filter_chain) sind Header ohne planendes Executable; die gebaute-aber-unverdrahtete CoR-Filterkette (einziger Konsument test_d15) muss als Selektions-Stufe des Planers in die Pass-Schleife run_lazy_static_then_dynamic (profile_run_entry.hpp:328/355/413) verdrahtet werden — Planer konsumiert den EINEN offiziellen Pfad. — E-planer-thesis.md Teil 1.4+2.3
- **Asymmetrie der dynamischen Unter-Achsen (Live-Befund)**: Organ-Achsen HABEN runtime-Unter-Achsen (RC-POD 6 Felder + 2 dynamische Baum-Ebenen concurrency.thread_count/prefetch.hw_prefetcher, profile_to_tree.hpp:85-95), Mess-System-Achsen haben NULL dynamische Unter-Achsen (rein constexpr, nur valid/available-Degradation) — die §28-Forderung "Unter-Achsen meist dynamisch" ist fuer System-/Mess-Arten kompletter Neubau. — C §7
- **Thesis-Delta**: Thesis fixiert Compiler heute als KONSTANTE ("identische Compiler- und Flag-Basis", 06_fazit.tex:14) → fortschreiben zu "Compiler als kontrollierte, protokollierte Permutations-Dimension" (Fairness=Vergleiche innerhalb einer Belegung); Thesis-Reihe-C "alt gegen neu" NICHT deckungsgleich mit User-Definition SdT-vs-Pruefling JE der 3 Stufen. — E §3.1+§3.5

**Superseded:**
- Alle 19-Slot-/26-Baum-Achsen-/ABI-Zaehlungen (A §3.1, C Referenz-Anker, AdHocComposition<19>) → INC-2D: 17 Organ-Achsen/ABI-6; STRUKTUR-Aussagen gelten weiter, die Zahlen nicht
- golden-320 als harte Neutralitaets-Schranke (D §1.5/R1) → feedback_alt_golden_darf_brechen (17.07.) + new-golden N=2^17; das PRINZIP binary_id-Reinheit (Tags/Compiler nie in die Identitaet) traegt unveraendert
- "#156-DATA-gated / correctly-gated-do-not-build"-Stati der Blut-Vorbauten → VOLLES GO 17.07.: Verdrahtung wird per Roadmap gebaut
- "Experiment-Planer nur in LEDGER:368 verankert, kein Bauplan" → BAUPLAN 19.07. existiert; die E-Andockpunkt-Kartierung bleibt dessen Beleg-Basis
- D's offene SIMD-/Hardware-Erweiterungsfrage → Q2 Option C (17.07.): extension_hardware=6. System-Achse (SIMD→GPU), CEB permutiert simd, Flags→CompileFn nie binary_id
- Flache 16er-Mess-Registry als einziger Registry-Bestand (A §13 Delta) → genau dieser Befund wurde zur §28-Direktive erhoben — der Dossier-Mangel ist jetzt Bauauftrag

**§28-Registry-Relevanz:** Direkte Grundlage: belegt per Code, dass die Mess-ART ihre modul-lokale CT-Registry bereits hat (Prototyp "Angebot des Compiles"), die Organ-ART ihre Registry-XML (cache_engine_axis_registry.xml), waehrend die System-ART weder Registry noch Haupt/Unter-Struktur besitzt (Pflicht-Systemachsen Scheduling/Hardware/NUMA/Locking + Compiler fehlen komplett). D §2.2-2.3 liefert den §28-konformen Bauplan (Haupt=CT via Definition/Provenienz, Unter=runtime via RC-POD/cpuid, Andocken ohne Duplikate); B §5.1 die Negativ-Lehre, warum §28-Registries compile-validiert statt handgepflegt sein muessen.

**Speist in:** resolver-registry, planer-bau, roadmap, golden-mock, ci-kette, nachschlagewerk-delta

---

### K11 — 20260717-parallelisierungs-strategie

`docs/sessions/backups/20260717-parallelisierungs-strategie`

**Was es ist:** Workflow vom 17.07., der die gesamte offene TODO-Liste in 6+1 disjunkte parallele Straenge (BAU/PLAN/THESIS/DOKU/INFRA/MESS/RESEARCH) mit Konflikt-Matrix, SYNC-Punkten und gebatchten User-GOs ordnete. Backup-Ordner LEER (keine Rohdaten persistiert); autoritativ ist allein `docs/plaene/20260717-parallelisierungs-strategie-STRATEGIE-PARALLELE-STRAENGE.md`.

**Kern-Erkenntnisse:**
- **Leitmodell R0** (md:7,99): GENAU EIN CE-Working-Tree ⇒ nur EIN Strang (Haupt-Agent, strikt sequenziell) schreibt CE-Code; Worktree-Isolation bringt nichts, weil Increments nicht datei-disjunkt UND semantisch geordnet sind. Direkte Vorlage fuer die heutige Disjunktheits-Analyse: Parallelitaet nur ueber physische Trennung (RO-Lesen, fremdes Repo, eigene Doku-Files), nie ueber zweiten CE-Schreiber.
- **Strang-Taxonomie als Disjunktheits-Achsen** (md:13-57,111-115): CE-Code=Single-Writer / Planung=read-only mit ~3-4 gleichzeitigen RO-Workflows unbedenklich / Thesis=separates Repo (null Overlap) / Ledger=eigener Single-Writer (R3, nie zwei gleichzeitige Ledger-Schreiber; PLAN schreibt eigene backups-Files, DOKU faltet ein) / CI-Files=koordiniert. Erlaubte Gleichzeitigkeit: 1 BAU + ~3 RO-PLAN + 1 THESIS + DOKU interleaved.
- **Konflikt-Matrix R1 mit Hot-Files** (md:101-105): (1) cache_engine_builder_iterator.hpp — S3-I4 (:777/790) und S4-CSV-Emit NIE parallel; (2) registry_to_axis_levels.hpp:81/83 — Abspaltung vor allen Registrier-Edits, Registrierungen serialisieren; (3) build_orchestrator.hpp:62 build_version — geteilt von 6.-Achse/1g/1h, 1g etabliert den Mechanismus; (4) measurement/system_axis.hpp — Basis-Zeile vs. Telemetrie. Rezept: Same-Region-Kollisionen INNERHALB der einen Lane per Reihenfolge loesen. Als Kollisions-Checkliste fuer die heutige Wellen-Planung weiterverwendbar (Zeilennummern nach INC-2/ABI-6 verifizieren).
- **SYNC-Punkt+GO-Batching-Muster** (md:87-93,135-151): Forks/Freigaben so frueh wie moeglich als EINEN Klartext-Block vorlegen (nie AskUserQuestion); Doktrin-Automatismen brauchen kein GO; Planungs-Vorarbeit hat Prioritaet, damit Bau-Gates (SYNC-1/2) nie warten. 1:1 auf die 3 heutigen Planungs-Workflows uebertragbar.
- **R2 Planer generiert CI** (md:43,107): STRANG-BAU S3 --emit-ci GENERIERT die Child-Pipeline ⇒ struktureller Hand-CI subsumiert/obsolet, Infra macht nur minimale keep-green-Edits koordiniert mit S3. CI ist Planer-OUTPUT, kein eigener Baustrang.
- **STRANG-MESS-Betriebsparameter** (md:48-53): opt-in CI-Job measure:golden-320, prod1 PMC-Node, timeout 10d, INERT via COMDARE_RUN_MEASURE==true, Rueckschrieb measurement/<ts>/ mit Token id=54 (Projekt 288, write_repository-only, INERT), Loop-Schutz [skip ci], nie pollen. Maschinerie bleibt gueltig — nur das Messobjekt wechselt auf new-golden 2^17.
- **Deadline-Arithmetik** (md:93): mehrtaegiger Voll-Messlauf MUSS mit Vorlauf VOR 28.07. starten ⇒ letzter Bau-Increment darf nicht rutschen ⇒ Planung vorziehen. Heute (19.07.) noch schaerfer bindend: 9 Tage Rest.
- **Meta-Befund**: Rohdaten nie in den backups-Ordner persistiert (Ordner leer); Quellen-Legende (4 Reports Stack/Gated/Abgabe/Konflikt-Matrix) nicht erhalten.

**Superseded:**
- golden==320 als Checkpoint/Referenz (SYNC-1/2, golden-320-Voll-Messlauf) → new-golden N=2^17 (Fixture existiert)
- INC-1a..1h-Kette + INC-2 4→5-Bump als offene Bau-Roadmap → vollzogen (17 Organ-Achsen/ABI-6, #50/#51/#52 done); Sequenz-Logik nur noch historisches Muster
- W3-Ruling als "einziger echter INC-2-Blocker" + STRANG-PLAN-Arbeitsvorrat → erledigt; heutige Blocker-Rolle hat Phase-0 des Planer-Bauplans
- S3 Planer-Codegen als vager Folge-Bau → konkreter BAUPLAN 19.07. + §27-Resolver-Stufe
- Achsen-Inventar "22x axes/**StrategyBase" und ABI-4-Bezuege → Nachschlagewerk-INC2D-Delta 172 Eintraege auf 17-Slot/ABI-6
- STRANG-INFRA "GEPARKT bis User meldet CI-Rueckkehr" → gegen heutigen Stand pruefen — die Roadmap plant die CI-Detail-Kette start→gruen aktiv, was den Park-Status praktisch aufhebt; R2 (Planer generiert CI) bleibt gueltig

**§28-Registry-Relevanz:** Datiert VOR §28, liefert zwei Anschluesse: (1) Die Konflikt-Matrix zeigt, dass Achsen-Registrierung durch EINEN Choke-Point laeuft (registry_to_axis_levels.hpp:81/83 + build_system_axis_levels(), md:84,103) — genau diesen Engpass dekomponiert §28 in 3 Art-eigene Registries; nach R0 bleiben die 3 Registry-DATEIEN trotzdem CE-Code in der EINEN Bau-Lane (sequentiell schreiben), waehrend ihre XML-Angebote read-only von Planer-/Resolver-Straengen parallel konsumierbar sind. (2) R2 ist dieselbe Richtung wie §27/§28: Angebot(Registry-XML)→Resolver(Planer)→generierter Output.

**Speist in:** parallelisierung, roadmap, ci-kette, planer-bau, golden-mock, resolver-registry

---

### K12 — 20260717-xml-ci-automatisierung

`docs/sessions/backups/20260717-xml-ci-automatisierung`

**Was es ist:** 5-Fan-out+Synthese-ultracode-Workflow (18.07.), Ergebnis ist ein Erklaerungs-Dossier (nur als ROHDATEN-journal.jsonl, Zeile 12 = Synthese; keine separate .md): vollstaendige Ist/Soll-Kartierung der XML→CI/CMake-Automatisierung (3 Codegen-Klassen, CI komplett handgeschrieben, F5-Planer mit CiYamlBuilder = reines Soll) plus Root-Cause-Diagnose der prod2-Roetung von Pipeline 10605 (ungequotete AVX-512-Host-Probe).

**Kern-Erkenntnisse:**
- **F5-SOLL-KETTE** (CiYamlBuilder-Vorarbeit, vom Bauplan:199 zitiert): Experiment-XML(3-Phasen)+Registries → NEUES ce-App-Target comdare_experiment_planner (Muster catalog_codegen_tool) → Interpreter XML→ExperimentPlan → EIN ExperimentPlanDirector::construct(IPlanBuilder&) laeuft die Liste EINMAL ab und speist ZWEI Builder aus DEMSELBEN Walk: CMakeGraphBuilder (--emit-cmake → generated/experiment_plan.cmake, 2-Pass, opt-in) und CiYamlBuilder (--emit-ci → Child-Pipeline-YAML-Artefakt → trigger:include:artifact:, ersetzt measure:smoke/golden-320 durch EINEN generierenden Job; Systemachsen-Kombis als parallel:matrix ODER Downstream-trigger je Runner-Tag). Template Method je PhaseStep: resolve_selection(CoR)→emit_build→emit_measure→emit_serialize→emit_copy. — journal.jsonl Z.12 (Dossier par.4), basiert auf K5-DOSSIER.md:13
- **F5-Increment-Fahrplan** (fuer CI-Detail-Kette direkt uebernehmbar): I1 --dump-plan golden-neutral+Contract-Test → I2 CMakeGraphBuilder+2-Pass → I3 CiYamlBuilder+Child-Pipeline INERT-by-default → I4 Debug/Mess-Schalter(#221)+"failed"-Zelle → I5 Serialisierungs-Emitter. Andockpunkt/Vorbild = das EINZIGE echte XML→Artefakt-Build-Codegen: ce/cmake/catalog_codegen.cmake:27-37. — journal.jsonl Z.6+12
- **DREI-KLASSEN-KARTIERUNG des Codegen-Ist** (Verwechslung verboten): Klasse A = XML wird GELESEN (permutations.cmake, nur COMDARE_BUILD_PERMUTATIONS=ON default OFF, in Gate-Jobs gar nicht aktiv; catalog_codegen.cmake); Klasse B = KEIN XML, Typraum-Enumeration via for_each_composition_type (anatomy_codegen_runner.cmake/adhoc_emitter.cmake → .so-Tier-Binaries; per Design NIE fatal: WARNING+guarded include); Klasse C = XML ist OUTPUT (comdare_axis_registry_gen reflektiert CT-Registry → emittiert cache_engine_axis_registry.xml, Byte-Diff-Roundtrip-Gate tests/unit/registry_roundtrip.cmake:43-66, laeuft in contract:profile_coverage). KEIN Pfeil von irgendeiner XML zur .gitlab-ci.yml — beide Pipelines handgeschrieben, teilen Template comdare/cluster/ci-templates/base-pipeline.yml. — journal.jsonl Z.9+12
- **RUNNER-ROULETTE-Strukturbefund** (fuer CI-Kette start→gruen): NUR pmc:amd [baremetal,amd] und pmc:intel [baremetal,intel] sind ISA-gepinnt; ALLE harten Gates (sanitize:*, contract:*, chaos:drift, test:unit) tragen nur [baremetal] → nichtdeterministische Verteilung auf prod1(AMD 9950X3D, AVX-512)/prod2(Intel i9-14900KS, AVX-512 fused-off); jeder Gate-Job configured EIGENEN Build-Baum mit identischem -DCOMDARE_BUILD_TESTS=ON → ein Configure-Defekt roetet ALLE prod2-Jobs. allow_failure NUR bei build:arm64-smoke und is_original:relock; measure:* rules-gated INERT (CI-Gruen ≠ Messung). ISA-Pinning der Gates = offene Freigabe-Frage; harte 3-ISA-CI = #276 allerletzte/infra-gated. — journal.jsonl Z.10+12
- **ROOT-CAUSE-Lehre** (Bug gefixt, Lehre bleibt): check_cxx_source_runs setzt bei Probe-Exit!=0 die Variable auf LEEREN String (nicht FALSE, CheckSourceRuns.cmake:112-121); ungequotetes ${COMDARE_HOST_RUNS_AVX512F} als 3. Positionsargument kollabierte → "Function invoked with incorrect arguments" → prod2-Configure-fatal fuer 5 harte Gates. Merksatz: jede ungequotete ${VAR} als CMake-Positionsargument aus einer runs-Probe ist eine Zeitbombe, die erst auf dem Host explodiert, der die Probe reisst; lokal-first-Verifikation muss ISA-repraesentativ sein ODER die CMake-Logik host-invariant. Bug seit Commit 8175c802 (10.07.) latent. — journal.jsonl Z.7+12
- **MODUS-A-Trennschnitt** (Prozess-Regel, weiter gueltig): Modus a (lokal-doppelt-verifiziert + CI batch-nachziehen) NUR bei echtem baremetal-Infra-Block (stuck/timeout) legitim, NIE bei reproduzierbarem Code-/Configure-Defekt — dort Fix statt Deferral; Infra-Handoff (#207) strikt getrennt behandeln. — journal.jsonl Z.8+12 (Ledger:131/154/164)
- **SCOPE-Doktrin bei Hand-CI-Bruechen**: Roetung im Hand-CMake NIE durch Vorziehen des F5-Planers "loesen" — Haertung am offiziellen Ort, keine Parallelstruktur. Warnung: v32_orchestrator ist KEIN Ist-Code (nur alte Pfad-Artefakte in docs), nicht mit realem profile_facade verwechseln (ce profile_run_facade.cpp:178/282/340 = Mess-LAUF-Fassade, kein CI-Codegen). — journal.jsonl Z.6+12

**Superseded:**
- prod2-Roetung/Quoting-Bug: GEFIXT — alle 4 Aufrufstellen gequotet, verifiziert an ce/tests/unit/CMakeLists.txt:3330/3343/3372/3375 (damals :3301/:3307/:3332/:3335); nur die Lehre bleibt
- "F5 nichts gebaut, kein Bauplan, Freigabe offen" → teilweise ueberholt: BAUPLAN 19.07. existiert (mit Phase-0-Blocker); Bau-Freigabe je Phase weiterhin ausstehend
- 2-Registry-Kanon (ce+prt-art) als Planer-Input → §28: 3-je-Art-Registries
- golden-320/Roundtrip==320-Bezuege → new-golden N=2^17=131072
- Stand "Bau-INC-2c/Telemetrie 19→18 Slots" → INC2D: 17 Organ-Achsen/ABI-6
- "Dual-Verifikation gerade reaktiviert, Bikonditional scharf" → Momentaufnahme 18.07.; laut Memory ist feedback_dual_verifikation aktuell GEPARKT bis Aufgaben-Abschluss (lokal-first, CI-Strategie gesammelt nachziehen)

**§28-Registry-Relevanz:** Direkt: **Klasse C ist die mechanische Blaupause fuer §28** — comdare_axis_registry_gen zeigt das etablierte Muster "Registry-XML = OUTPUT der Compile-Time-Reflektion (Angebot des Compiles) + Byte-Diff-Roundtrip-Gate als CI-Contract" (tools/axis_registry_gen/main.cpp:184/257/263, registry_roundtrip.cmake:43-66); fuer die 3 Art-Registries ist genau dieses gen-Tool+Roundtrip-Gate-Pattern je Art zu replizieren. Die F5-PhaseStep-Struktur und die SIMD-Dispatch-Intention "BAUEN immer, AUSFUEHREN nur bei Host-ISA" praefigurieren die §28-Trennung. Achtung: 2-Registry-Kanon auf 3-je-Art aufweiten.

**Speist in:** ci-kette, planer-bau, roadmap, resolver-registry

---

## C. QUER-SYNTHESE

### C.1 — Die 5 wichtigsten Erkenntnisse fuer die §27/§28-Resolver-Stufe

1. **Vom Zwei-Registry-Design 1:1 uebernehmen, nur den Schnitt aendern** (K1, K12): Schema-Felder je Baustein (name=Wrapper::name()=serialize-Schluessel, type+header=FQ-Typ+Include, genus, golden_wired), Generator-Ansatz "Fork R-0 Option C" (Registry-XML NIE handschreiben, NIE Legacy recyceln, sondern per CT-Reflektion generieren = "Angebot des Compiles") und die bausteinfreie Anwender-XML mit reinen Limit-Referenzen (=§27-ANZEIGE) sind fertig designt und teilweise gebaut. Die **mechanische Blaupause existiert live als Klasse C** (comdare_axis_registry_gen → cache_engine_axis_registry.xml + Byte-Diff-Roundtrip-Gate registry_roundtrip.cmake:43-66): dieses gen-Tool+Roundtrip-Gate-Pattern je Achsen-ART replizieren. NUR der Schnitt aendert sich: von 2 je-Engine auf 3 je-Achsen-ART (Organ/System/Mess), jede Registry in IHREM Modul — die per-Modul-Andockpunkte (axis_NN_*_registry.hpp mit All*/Enabled*-Listen) existieren bereits im Code (K3).
2. **Die axis_binding_registry-Anti-Lehre als Abnahmekriterium** (K2, K9): Eine Registry ist NUR legitim als (a) DIE vom Produzenten konsumierte Quelle mit echtem nicht-test-Konsumenten + Contract-Test IM SELBEN Increment (Null-Konsumenten-Falle; Familie B/config_a-c als abschreckendes Beispiel toter XMLs ohne Reader, K4), (b) im richtigen Modul (der bestaetigte builder→measurement-Layering-Bruch ist das Symptom fehlender Modul-Verortung — exakt was §28 mit je-Art-im-eigenen-Modul heilt), (c) ohne Runtime-Werte compile-time zu spiegeln (Tier-gemeldete RC-Caps gehoeren nicht in die statische Registry; das Angebot deklariert nur, was der Compile wirklich festlegt). Verstaerkt durch die AxisLibraryRegistry-Negativ-Lehre (K10): handgepflegte String-Tabellen produzieren Phantome ab Tag 1 — compile-validiert oder gar nicht.
3. **Bindungs- und Bruecken-Regeln des Generators** (K3): IMMER ueber Enabled*/StaticAxisVariants* binden, NIE ueber All* (sonst "(disabled)"-Namen brechen die byte-genaue Roundtrip-Garantie; static_assert-Empfehlung). Die name→(FQ-Typ,Header)-Umkehrtabelle ist per COMDARE_DEFINE_ORGAN_LOCATION (organ_location.hpp:46) inzwischen gedeckt; explizit behandeln: prt-art-Slot mit bare CE-Namen "path_compression_patricia" (Fehl-Attributions-Gefahr) und der disjunkte sota-Namensraum (separat erfassen).
4. **Resolver-Kontrakt: ANZEIGE nie ohne ANGEBOT, fail-loud, Ebenen sauber benennen** (K7, K9, K4): Die gestoppte v32-Parallelstrecke validierte mit leerem registry_dir (Registry-Pruefungen 4+5 uebersprungen) — der §27-Resolver darf nie rein strukturell aufloesen. Validierungs-Doktrin F02/F11/F12 uebernehmen (XML autoritativ, Overrides nur explizit+geloggt, unbekannte Token fail-loud mit Exit-Kontrakt, keine erfundenen Defaults). Und: Registry-Kanon (ANGEBOT) vs. daten-getriebene build_axis_levels-Materialisierung der Anwender-XML sind VERSCHIEDENE Ebenen (Kardinalitaets-Konflation: dieselbe Achse kann statisch UND dynamisch erscheinen) — der Resolver muss explizit benennen, welche Ebene er bindet. Ein-Schema-Zuhause-Grundsatz: Registries sind eine NEUE Gattung neben Familie A, kein Rivale.
5. **Haupt-statisch/Unter-dynamisch ist alt-geerdet, aber je Art verschieden weit gebaut** (K8, K2, K9, K10): Das Layer-Modell vom 10.07. (Unter-Achse=VOLL-Achse unter der CT-Haupt-Achse, statisch XOR dynamisch, interleaved statt 2-Block-flach) plus die RC-POD-5-Feld-Bijektion sind die konkrete technische Definition von "dynamische Unter-Achse im Ziel-Binary". Ist-Stand je Art: Organ hat runtime-Unter-Achsen (RC-POD + 2 dynamische Baum-Ebenen), Mess hat die CT-Registry aber NULL dynamische Unter-Achsen, System hat weder Registry noch Haupt/Unter-Struktur — die System-Art-Registry ist der groesste Neubau (Pflicht-Familie Scheduling/HW/NUMA/Locking/Compiler + extension_hardware, Bauplan in K10 D §2.2-2.3: Haupt=Definition/Provenienz einkompiliert, Unter=runtime via RC-POD/cpuid, Andocken ohne Duplikate). Tag-Kollaps-Befund + Skalar-Konstanten-Liste (K8) definieren den Ziel-Umfang des Organ-Angebots; der ISA-x-SIMD-Compat-Filter ist das einzige real existierende Kreuz-Filter-Muster und damit das Template fuer Registry-Constraint-Logik im Resolver.

### C.2 — Die 3 wichtigsten Erkenntnisse fuer den Planer-Bau

1. **Codegen-Design steht fertig, nur andocken** (K5, K12): Interpreter (XML→ExperimentPlan=PhaseStep-Liste) + EIN Director + ZWEI ConcreteBuilder (CiYaml/CMakeGraph) aus DEMSELBEN Walk (Synchronie strukturell garantiert); Template-Method je PhaseStep mit resolve_selection (CoR selection_filter_chain) als §27-Resolver-Ort; 3 Naehte (App-Target nach catalog_codegen_tool-Muster, experiment_plan.cmake 2-Pass, --emit-ci→trigger:include:artifact); Registry-Pfade als statische compile-defs "wie messung_driver". Increment-Fahrplan I1-I5 mit Fork-C-Schnitt (I1+I2 vor 28.07.). Noch offen aus K5: F2 (Fan-out parallel:matrix vs Downstream-trigger), F3 (COMDARE_PERMUTATION_PROFILE-Verhaeltnis), F4 (Index-Manifest-Format).
2. **v32-Stopp-Lehre = Phase-0-Gesetz** (K7, K4): Nie eine zweite/dritte Enumerations-Engine neben dem offiziellen Pfad — der execute_messreihe-Stub (super v32_messreihe_antrieb.hpp) wird WIEDERVERWENDET (Bauplan Phase-0-Blocker), Fork-A-Bruecke=PROJEKTION auf den bestehenden run_profile-Unterbau (~80% der Mess-Mechanik steht: rollbackable_tier, CEB-Kette, repetitions-DynDim; einziger fehlender Baustein CSV→Welch-Konsument). Der WP1-Patch ist Kandidaten-Material fuers Stub-Fuellen (fail-loud-Exit-Kontrakt, ehrlicher Dispatch, CT-Label-Pattern), wird aber nie als Datei reaktiviert.
3. **Konsumenten- und Verdrahtungs-Auflagen ab Tag 1** (K4, K3, K10): Jede neue XML braucht sofort ihren verdrahteten Parser-Konsumenten (Familie-B-Warnung); known_workload_ids MUSS an validate_profile gereicht werden (sonst M-CE-12-Waechter stumm); die gebaute-aber-unverdrahtete CoR-Filterkette in die Pass-Schleife run_lazy_static_then_dynamic verdrahten; CEB-Selbst-Compilerwahl gehoert auf die Planer-Ebene (dritte Anwendung waehlt vorgebautes gcc-/clang-CEB-Artefakt, nie Selbst-Neubau).

### C.3 — Parallelisierung: alte Strategie vs. heutige Wellen

- **R0 bleibt Gesetz** (K11): EIN CE-Working-Tree ⇒ EIN CE-Code-Schreiber; heutige Wellen duerfen nur ueber physische Trennung parallelisieren (RO-Planungs-Workflows ~3-4 gleichzeitig, Thesis-Repo, eigene Doku-Files, Ledger-Single-Writer). Die 3 §28-Registry-DATEIEN sind CE-Code → in der EINEN Bau-Lane sequentiell; ihre XML-Angebote sind read-only parallel konsumierbar.
- **Konflikt-Matrix als Kollisions-Checkliste weiterverwenden** (K11): Hot-Files cache_engine_builder_iterator.hpp / registry_to_axis_levels.hpp:81/83 / build_orchestrator.hpp:62 / measurement/system_axis.hpp — Zeilennummern nach INC-2/ABI-6 re-verifizieren; §28 dekomponiert genau den registry_to_axis_levels-Choke-Point in 3 Art-Registries.
- **GO-Batching + SYNC-Punkte** unveraendert uebertragbar: Forks frueh als EINEN Klartext-Block; Planung vorziehen, damit Bau-Gates nie warten. Neu-bindend: Deadline-Arithmetik verschaerft (9 Tage Rest, mehrtaegiger 2^17-Messlauf braucht Vorlauf VOR 28.07.).
- **Ueberholt**: INC-1/INC-2-Sequenz vollzogen; W3-Blocker-Rolle → heute Phase-0 des Planer-Bauplans; STRANG-INFRA-Parkstatus praktisch aufgehoben (CI-Detail-Kette aktiv geplant); Messobjekt golden-320 → 2^17 (MESS-Maschinerie: Token id=54, INERT-Gates, [skip ci] bleibt).

### C.4 — Mock (New-Golden 2^17) + CI-Kette

- **Mock-Vollstaendigkeit**: all-axes-XML muss den disjunkten sota-Namensraum separat erfassen (K3); 2^17=131072 ist ein etablierter Sweep-Stuetzpunkt der Workload-Size-Achse (K9); binary_id-Reinheit gilt weiter (Tags/Compiler/ISA/OS nie in die Identitaet, nur Ordner-/Sidecar-/Tag-Spalten — K6, K10); Output-Layout: Systemachsen flach als Ordner, Tier tiefer Baum, nur dynamische Spalten, Index-Manifest + atomare build→ziel-Copy (K6); honest-empty-Doktrin fuer nicht-materialisierte Ebenen (K9); Verwechslungs-Warnung "Bit-Bank"≠Familie C (K4).
- **CI-Kette start→gruen**: CI ist Planer-OUTPUT (R2/K11, F5-Kette K12: --emit-ci→Child-Pipeline INERT-by-default ersetzt measure:*); Drei-Klassen-Kartierung nicht verwechseln (A gelesen/B typraum/C emittiert); Runner-Roulette-Befund adressieren (harte Gates nur [baremetal] ungepinnt, ISA-Pinning=offene Freigabe-Frage; #276 allerletzte); Klasse-C-Roundtrip-Gate je neuer Art-Registry replizieren; M-CE-27 pruefen (laeuft test_profile_roundtrip inzwischen in CI? — K1); failed-Zellen-Design (CSV "failed" + error.log, Harness continue — K5); Modus-A-Trennschnitt (Infra-Block ja, Code-Defekt nie deferren) und CMake-Quoting-Lehre (runs-Proben host-invariant quoten) als Betriebsregeln (K12).

---

## D. KONFLIKTE: Archiv-Aussagen vs. heutige Planungen (je: gewinnender neuester Fakt)

| # | Archiv-Aussage (Kapsel) | Gewinnender heutiger Fakt |
|---|---|---|
| 1 | 2 Registries je ENGINE ce+prt-art (K1, K5, K6, K10, K12) | **§28**: 3 Registries je Achsen-ART (Organ/System/Mess), jede im eigenen Modul; Schema/Generator/Bruecke bleiben |
| 2 | golden==320 als TABU/Referenz/Schutzargument (alle Kapseln) | **feedback_new_golden_all_axes_xml_gt320**: golden N=2^17=131072 all-axes, Fixture existiert; binary_id-Reinheits-PRINZIP traegt weiter |
| 3 | 19/26 Achsen, T0–T18, kV3AxisCount=19, ABI-4/5-TABUs (K1-K3, K8-K10) | **INC-2d-Stand**: 17 Organ-Achsen/ABI-6/17-Slot; Nachschlagewerk-Delta 172 Eintraege umziehen; telemetry+isa sind System-Sidecars |
| 4 | "Planer-Binary existiert nicht / kein Bauplan / F5-Freigabe offen" (K5, K6, K10, K12) | **BAUPLAN 19.07.** existiert (docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md); Bau-Freigabe je Phase weiterhin per User-GO |
| 5 | Familie C tilgen nach E4-Subsumtion (G7) (K4) | **Phase-0-Blocker**: execute_messreihe-Stub WIEDERVERWENDEN (v32_messreihe_antrieb.hpp, in main.cpp verdrahtet), keine Parallelstruktur, keine Tilgung |
| 6 | "#156/DATA-gated, correctly-gated-do-not-build" fuer Blut-Vorbauten (K10); offene Forks Q1-Q4/H3-H6/R-Forks (K1, K6, K9) | **VOLLES GO 17.07.**: alle Entscheide getroffen; Serialisierungs-Direktive 18.07. entschied Q1-Q4 entlang der Dossier-Empfehlungen |
| 7 | Registry als C++-consteval-Header (einzige Form) bzw. zentrale Header-Registry (K2, K8, K9) | **§27/§28**: Registry=XML-ANGEBOT je Art im Modul; constexpr-Muster bleibt in-Binary-Gegenstueck; Anti-Doppelquelle-Doktrin unveraendert |
| 8 | profile_to_tree.hpp = "DIE EINZIGE Quelle" der Klassifikation (K2) | Doktrin bleibt, Traeger wandert: perspektivisch wird auch diese C++-Quelle Konsumentin der modul-eigenen XML-Registries |
| 9 | INC-B-Blocker fehlende cpp_type_name/header_include (K3) | GESCHLOSSEN: COMDARE_DEFINE_ORGAN_LOCATION (organ_location.hpp:46) umgesetzt |
| 10 | M-CE-10 Stufe2 ignoriert lebewesen → 1 binary_id (K1, K3) | GEFIXT: per-Host-Stufe2-Kompositionen + Host-Dispatch (sota_catalog.hpp:171-188) |
| 11 | prod2-rot durch ungequotete AVX-512-Probe (K12) | GEFIXT: alle 4 Stellen gequotet (ce/tests/unit/CMakeLists.txt:3330/3343/3372/3375); nur die Lehre bleibt |
| 12 | Fork F1 CI-YAML-Erzeugungsort offen (K5) | ENTSCHIEDEN: (b) trigger:include:artifact, als I3 im Bauplan fixiert |
| 13 | STRANG-INFRA geparkt; "Dual-Verifikation scharf" (K11, K12) | Heutige Roadmap plant CI-Detail-Kette aktiv; Dual-Verifikation laut Memory GEPARKT bis Aufgaben-Abschluss (lokal-first) |
| 14 | COMDARE_V32_DRIVER_ENABLE-Planung, Increment-Statuslisten A-H/I1-I7 (K1, K7) | Autoritativ ist allein der BAUPLAN 19.07. + Ledger §19; alte Statuslisten nur historisch |
| 15 | "<measurement_categories> als ThesisProfile-Feld M-1" (K4) | REFRAMED: Mess-Kategorien gehoeren ins XML-Angebot der §28-Mess-Registry im Mess-Modul |
