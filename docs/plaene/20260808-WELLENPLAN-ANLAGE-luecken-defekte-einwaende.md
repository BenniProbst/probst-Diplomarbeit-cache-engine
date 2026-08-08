# ANLAGE zum Wellenplan 08.08.2026 — Lücken, blockierende Defekte, tragende Einwände

> Rohdaten des Wellenplan-Workflows (23 Agenten, 6,24 Mio Tokens, 1064 Werkzeugaufrufe).
> Erhoben gegen 369 SOLL-Posten aus dem Ledger, 211 davon am Code geprüft.
> Die Endfassung des Plans steht in `20260808-WELLENPLAN-ENDFASSUNG-369-soll-211-ist.md`.

## 1. Die 5 blockierenden Defekte

Sie stehen zwischen dem heutigen Stand und einer belastbaren Messung.

### D1 — 'make check' laesst das Reconfigure weg und faehrt damit eine unvollstaendige Suite als gruene Vollstaendigkeitsaussage. Die ce registriert einen Teil der Tests erst, wenn die Codegen-Werkzeuge GEBAUT sind und CMake danach ein ZWEITES Mal laeuft (tests/unit/CMakeLists.txt:1070-1103 R5.I, :1177-1207 F15 -- beide haengen an comdare_run_anatomy_codegen_tool mit STATUS_OUT). Das ce-Makefile macht 'check: all' -> 'cmake --build --target comdare_tests' -> ce_ctest. Kein Configure dazwischen. cmake/anatomy_codegen_runner.cmake registriert das Werkzeug NICHT als CMAKE_CONFIGURE_DEPENDS (nachgesehen: null Treffer), ein Bauen des Werkzeugs loest also kein Reconfigure aus. Die Schwester-Datei im super macht es richtig UND nennt die Zahl: 'in der cache-engine ... am Objekt gemessen: 427 Tests bei einem einzigen Configure gegen 431 nach all + Reconfigure (vier Tests waren unsichtbar)'. Der CI-Job test:coverage-guard fuehrt denselben 2-Pass ausdruecklich durch (.gitlab-ci.yml:294-301). Nur der offizielle Anwenderweg tut es nicht.

**Wo:** /home/comdare/wt-ce-fk/Makefile:83-86 (Ziel 'check'); Gegenstueck /home/comdare/wt-super-landung/Makefile:107-108 und :117 (Reconfigure-Zeile + gemessene Zahlen); Ursache /home/comdare/wt-ce-fk/tests/unit/CMakeLists.txt:1070-1103 und :1177-1207

**Wirkung:** Der Weg, den der Owner heute zum offiziellen Linux-Bauweg erklaert hat ('./configure.sh && make && make check'), meldet 'kein Test fehlgeschlagen' ueber 427 statt 431 Tests. Vier Tests -- ausgerechnet die codegen-abhaengigen, also die der Kette PLANER->CEB->TIER am naechsten stehenden -- laufen auf dem Anwenderweg nie, ohne dass irgendetwas anzeigt, dass sie fehlen. Wer die Abgabe ueber den offiziellen Weg verifiziert (und genau dafuer ist er da), bekommt ein Gruen mit stillschweigend kleinerem Nenner. Es ist derselbe Satz wie bei run_all_tests.sh, nur eine Ebene weiter: die Wache besteht, ohne alles gefahren zu haben.

### D2 — Die Abdeckungs-Wache rechnet ueber einem zu kleinen Nenner und kann das nicht bemerken. Ihr Wahrheitsbegriff ist 'ctest -N' auf build-covguard; dieser Baum wird mit genau EINEM 2-Pass konfiguriert (Codegen-CLI). Die R5.G-Familie in tests/unit/CMakeLists.txt haengt aber an einem ANDEREN Werkzeug: comdare_adhoc_emitter_cli. Nachgemessen: 'grep -c adhoc_emitter .gitlab-ci.yml' -> 0. Kein ce-Job baut es, kein Job baut Target 'all' (alle Jobs nennen ihre Targets explizit; build:clang setzt COMDARE_CMAKE_BUILD_TARGET=comdare_tests). Folge: _r5g_ae_status ist in JEDEM CI-Baum ungleich FOUND, der Block wird uebersprungen, und die beiden darin registrierten Tests (test_v41_anatomy_adhoc_autobuilt_load, f15_compare_cli_smoke) existieren in der Inventur gar nicht. Die Wache meldet 'GRUEN -- kein Test ohne fahrenden Job' und hat recht ueber die Menge, die sie sieht. Der Kopf der Wache kennt die Klasse und behandelt sie NUR fuer den Codegen-Pass ('live gemessen 2026-08-06: 404 statt 406') -- fuer den Adhoc-Emitter-Pass nicht.

**Wo:** /home/comdare/wt-ce-fk/scripts/ci_test_coverage_guard.sh:41-45 (Ground-Truth-Zusicherung) und :85-89 (die Inventur selbst); Aufruf /home/comdare/wt-ce-fk/.gitlab-ci.yml:294-301; ungesehener Block /home/comdare/wt-ce-fk/tests/unit/CMakeLists.txt:1542-1592

**Wirkung:** Genau die Fehlerklasse des Tages, eine Windung weiter: nicht 'Test ohne Job', sondern 'Test, den die Wache nie zu Gesicht bekommt'. Die Wache ist als Netz gegen das stille Nachwachsen gebaut worden (9 Tests in drei Wochen); dieser Zweig kann beliebig weiter nachwachsen, denn jeder neue Test im R5.G-Block ist ab Geburt unsichtbar -- fuer die CI UND fuer die Wache. Solange die Abdeckungs-Zahl als Vollstaendigkeitsbeleg der Abgabe zitiert wird, ist sie eine Aussage ueber einen Ausschnitt, die wie eine Aussage ueber das Ganze klingt.

### D3 — Der Voll-Messlauf akzeptiert ein leeres Messfenster als Beweis. Nach dem mehrtaegigen Lauf steht als Erfolgsbedingung nur: es existiert IRGENDEINE Datei namens measurements.csv. Die Zeilenzahl wird eine Zeile darueber ausgegeben, aber nirgends geprueft. Eine measurements.csv mit ausschliesslich der Kopfzeile -- oder mit null Zeilen -- besteht dieses Gate. Derselbe Bau steht im Smoke-Job.

**Wo:** /home/comdare/wt-super-landung/.gitlab-ci.yml:885-886 (measure:golden-320) und :796-797 (measure:smoke)

**Wirkung:** Ein bis zu zehn Tage laufender Job kann mit 'OK (golden-320 gemessen)' enden, ohne einen einzigen Messwert erzeugt zu haben. Der nachgelagerte persist:measurements schreibt die leeren CSVs additiv nach development zurueck, die Anhang-Regenerierung meldet ehrlich 'kein WIDE-Aggregat' und wird uebersprungen -- die Kette bleibt durchgehend gruen und die Diplomarbeit bekommt einen Laufordner, der aussieht wie eine Messung. Es ist dieselbe Diagnose wie beim bereits gefundenen m3v2_pmc_smoke ('misst ein leeres Fenster'), nur am teuersten Objekt der ganzen Strecke.

### D4 — Das Drift-Gate erklaert eine DEGENERIERTE Messung fuer STABIL und nimmt sie beim ersten Versuch an. assess_drift() rechnet relative_drift=(max-min)/median nur, wenn median_ns>0; ist der Median 0 (alle Proben 0, weggeoptimierte Operation, kaputte Uhr), bleibt relative_drift=0.0 und unstable=false -- und run_with_drift_gate kehrt an der Stelle 'if (!v.unstable)' sofort mit stable=true, reruns=0 zurueck. DriftVerdict traegt keinen Zustand 'unbestimmbar': ein Konsument kann 'Drift 0, weil wirklich stabil' nicht von 'Drift 0, weil kein Nenner' unterscheiden. Der Kommentar Z.52-56 nennt das 'konservativ + crash-frei'; es ist woertlich GRUEN MIT NENNER 0. Fuer reps==0 hat derselbe Autor den Fall erkannt und stable=false gesetzt (Z.100-105) -- fuer den median<=0-Fall nicht. Dieselbe Klasse wie der schon gebuchte m3v2_pmc_smoke-Befund ('misst ein leeres Fenster').

**Wo:** /home/comdare/wt-ce-fk/libs/cache_engine/builder/commands/drift_detector.hpp:42-50 (kein Unbestimmbar-Zustand), :53-56 (Kommentar), :69-72 (Rechnung), :128-134 (Annahme)

**Wirkung:** Das einzige Gate, das driftverseuchte Messungen abfangen soll, laesst eine vollstaendig kaputte Messgruppe ohne einen einzigen Rerun und ohne Warnzeile durch. Es warnt genau dann NICHT, wenn gar nichts gemessen wurde. Ein mehrtaegiger Voll-Lauf koennte damit still Null-Fenster als 'stabil erhoben' verbuchen.

### D5 — ZWEI numerisch verschiedene Perzentil-Verfahren tragen im selben Repo denselben Namen 'Nearest-Rank-Perzentil' und speisen beide die Mess-Ausgabe. (A) stats::percentile_ns: k = min(n-1, floor(q*n)). (B) detail::nearest_rank_p: rank = round(p*(n-1)). Am Objekt nachgerechnet (g++, Stichprobe 1..100): p95 A=96 / B=95, p99 A=100 / B=99. B rendert die write_/read_/delete_-p50/p95/p99-Felder des Trace-JSON, A die latency_p50/p99 in ExecutionResult/result_aggregator-CSV. Dazu kommt ein DRITTER 'Median': best_binary_selector nutzt die UNTERE Mitte vals[(n-1)/2] (bei {10,20,30,40} = 20), A und B liefern 30, und eta_kalibrierung::median_t_s mittelt bei geradem n die beiden mittleren Werte. Direkt widersprochen wird das an zwei Stellen: tier_observe_trace.hpp:11 sagt 'Auswertung p50/p99 ueber das bestehende stats::percentile_ns (kein neuer Perzentil-Code)' -- die ABI-Schwesterdatei fuegt genau diesen neuen Code hinzu und ist der Pfad, der wirklich rendert; drift_detector.hpp:16-18 sagt 'KEINE Methoden-Drift gegenueber Welch-t-Test, Perzentilen und winsorized_mean'.

**Wo:** /home/comdare/wt-ce-fk/libs/cache_engine/builder/commands/latency_stats.hpp:12,23-31 · /home/comdare/wt-ce-fk/libs/cache_engine/builder/anatomy_commands/tier_observe_trace_abi.hpp:68-75 (Aufrufe :307-314) · /home/comdare/wt-ce-fk/libs/cache_engine/builder/anatomy_commands/genus_tier_observe_trace_abi.hpp:327-333 · /home/comdare/wt-ce-fk/libs/cache_engine/builder/anatomy_commands/tier_observe_trace.hpp:11,47 · /home/comdare/wt-ce-fk/libs/cache_engine/builder/best_binary_selector/best_binary_selector.cpp:185-188 · /home/comdare/wt-ce-fk/libs/cache_engine/builder/bestandslog/eta_kalibrierung.hpp:183-194

**Wirkung:** Dieselben Roh-Samples ergeben je nach Ausgabe-Pfad verschiedene p95/p99 und verschiedene Mediane. Die Thesis kann keine EINE Perzentil-Methode dokumentieren, ohne dass ein Teil der ausgewiesenen Zahlen dieser Beschreibung widerspricht; ein Gutachter, der zwei Artefakte nebeneinander legt, sieht die Differenz.

## 2. Die 103 IST-Lücken

**62× teilweise** · **27× fehlt** · **14× nur-spezifiziert**

### Zustand `fehlt` — 27 von 103

**cache_engine --check-size "FILE" -- Experimentgroesse/Dauer auf der Zielmaschine berechnen (OWNER-KERN 08.08., LEDGER:10928-10938)**

Alles fehlt: das Planer-Verb, der Vertrag Planer->CEB fuer die Groessen-/Dauer-Rechnung, die Hardware-Erkennung eines vorsorglich zu bauenden CEB. Es gibt heute keinen Weg, die Experimentgroesse zu ERHEBEN statt zu schaetzen.

**PV-1 .so-ABI-Vertrag Planer<->CEB statt Textemission (LEDGER:3311-3327 §60-R1, Task #35)**

Alles fehlt. Als Nach-Abgabe-Posten gefuehrt (Fahrplan-Nachtrag L18) -- kein Abgabe-Blocker, aber der Ledger fuehrt ihn als entschieden.

**XML trennt Bau-Material von Messungen; Messung ohne Bau-Material = Warnung + vorbehaltsloser Nachbau (fail-open, OWNER-KERN 08.08., LEDGER:11056-11062)**

Es gibt keine Stelle, die eine nicht bau-freigegebene Mess-Anfrage mit CLI-Warnung annimmt und trotzdem baut. Achtung: Negativbefund aus einer Synonym-Suche -- schwaecher als die uebrigen Belege dieser Liste.

**checkpoint_measure-Bausteine: eigener Stacktrace, virtuelle Thread-Slots, Mess-Ebene als CMake-Flag, thread-lokale Puffer, O(n)-Rekonstruktion, Ueberlauf-Zaehler**

Sechs Bausteine komplett ungebaut. Zusaetzlich eine NAMENSKOLLISION, die vor dem Bau zu klaeren ist: das Design-Doc verwendet 'compare' als oberste MESS-EBENE (:125-128), waehrend libs/cache_engine/include/cache_engine/measurement/run_methodology_registry.hpp:58/:97 'Compare' bereits als ABLAUF-METHODIK belegt (RunMethodology::Compare, id "compare", cmake_build_type "Release", measurement_on=false). Ein CMake-Flag namens compare wuerde auf einen Begriff treffen, der im Code das Gegenteil bedeutet (measurement_on=false).

**Record-and-Replay als Mess-Vertrag zwischen den 3 Mess-Ebenen (OWNER-KERN, LEDGER:11291-11303)**

Der komplette Snapshot-/Replay-Apparat. Er ist Voraussetzung dafuer, dass die Ebenen sich nicht gegenseitig stoeren -- also fuer dieselbe Frage, die die 6 CEBs beantworten sollen. Beide Wege zum Messfehler sind heute ungebaut.

**Fehlerklassen fuer UNTERACHSEN (A15 Ebene 3, Owner-Direktive 'Achsen -> Unterachsen -> Algorithmen Pflicht')**

KEINE einzige Organ-Unterachse deklariert einen Fehlerraum. Die A15-Ebene 3 ist auf der Organ-Seite unberuehrt; nur die SYSTEM-Unterachsen (OptimizationLevelSubAxis, SimdSubAxis, CompilerAtomicSubAxis, TargetIsaSubAxis, OperatingSystemSubAxis) tragen ueber FK-3 Traits.

**telemetry ist zweigeteilt: Runtime-Unter-Achse im Mess-Tooling UND Haupt-System-Achse (Paragraf 69.3 / RF-8)**

Die Achse libs/cache_engine/axes/telemetry_axis/ (axis_11, 9 Header inkl. Registry, Strategy-Base und Unterachsen tm1..tm3) existiert weiter, gehoert aber nach der Umstufung zu KEINER registrierten Achsen-Ordnung -- weder Organ (nicht in kCompositionAxisNames) noch System noch Mess. Weder die Sweep-Unter-Achse im Planer noch die Compile-Hauptachse in der CEB ist gebaut. Dasselbe Muster bei axes/simd/ (axis_09_isa): aus der Komposition genommen (INC-2d), lebt als Codegen-Traeger weiter, steht in keiner Achsen-Registry.

**MAP traegt grundsaetzlich Key- UND Value-Filter-Achse; Sortierungen zaehlen als KEY-FILTER (A5)**

Weder eine Key-Filter- noch eine Value-Filter-Achse existiert; Posten 60 (Wanderung von search_algo-Wrapper zur Filter-Familie) ist am Code nicht sichtbar.

**Break-Even-Funktion ist als String serialisierbar und wieder parsbar**

Die Kurve lebt ausschliesslich als C++-Objekt im Prozess. Es gibt keinen Weg, sie zu persistieren, ins Lager zu schreiben, wieder einzulesen oder in die Thesis zu giessen. Damit ist der gesamte Owner-Satz 'als String gespeichert und wieder geparst/interpretiert' ungebaut -- und das ist genau die Naht, an der Auswertung, xlsx-Ablage und LaTeX-Anlage haengen wuerden.

**Break-Even-Basis: erster Parameter-Messwert bildet im Ausgangszustand bei 0 die Basis**

Kein Code-Konstrukt setzt eine Basis bei 0. Ob der Owner-Satz eine x-Verankerung oder eine y-Normierung meint, ist am Code nicht entscheidbar -- vor dem Bau ist die Lesart zu klaeren.

**Break-Even wird DREIMAL berechnet, querschneidend je Ebene (Micro/Macro/combined) je Baum-Knoten-Tiefe**

Die dreifache Querschnitts-Rechnung existiert weder als Signatur noch als Schleife. Die Ebenen-Typen liegen im Schreiber, die Break-Even-Mathematik in der Heuristik -- die beiden kennen einander nicht (0 gegenseitige Includes).

**cache_engine --check-size (Experimentgroesse/Dauer auf der Zielmaschine, Rechnung AUF der CEB)**

Vollstaendig ungebaut -- weder Flag, noch CEB-seitige Rechnung, noch der Vertrag, ueber den der Planer die CEB befragen wuerde. Das ist der Posten, der die Frist-Rechnung tragen soll (Owner-KERN D-3 'Bau-Menge folgt der Mess-Menge').

**Flattern des Schalters als Signal fuer den Hybrid-Umschaltbereich (Bereichs-Erkennung, KEINE Hysterese)**

Zusaetzlich ein PLAN-WIDERSPRUCH, der vor dem Bau zu klaeren ist: der Owner-KERN sagt 'Keine Hysterese noetig, sondern Bereichs-Erkennung', der GESAMTBILD-Vorschlag D-5 (super docs/plaene/20260808-GESAMTBILD-*:395-397) fordert 'Hysterese-Band als Pflicht-Eigenschaft der Schaltlogik'. Wer den Plan liest statt den Owner-KERN, baut das Gegenteil.

**sota_series merge-Attribut wird gegen die MergeStrategy-Namen geprueft**

Ein getipptes merge= in einer <sota_series> passt validate anstandslos; downstream liefert sota_module_for (sota_catalog.hpp:299, Dispatch ueber merge bei :394/:477) nullopt und build_sota_passes ueberspringt die Reihe lautlos -- die Reihe verschwindet aus der Messung, ohne dass irgendwo etwas rot wird.

**WorkloadKind/OP-Typen messen im Katalog-Treiber real unterschiedlich**

OP-1..OP-6 sind Phantom-Etiketten auf identischen Messungen. Es fehlen die je-Kind unterschiedlichen Dispatches (YCSB_C prefill+lookup-only, OP-2 insert-only, YCSB_A 50/50) und ein lautes 'nicht unterstuetzt' fuer Scan/RangeDelete bis zur IScannableTier-Anbindung.

**Verankerung relativer <output>-Pfade**

Relative <output>-Pfade landen dort, wo der Prozess zufaellig steht. Fuer die Lagerhaltung (zwei Realm-Wurzeln) ist das eine offene Flanke.

**XML trennt Bau-Material von Messungen; Messung ohne Bau-Material = Warnung + vorbehaltloser Nachbau (fail-open)**

Der komplette Owner-KERN (LEDGER:11056-11062) ist unumgesetzt: es fehlt die Gegenpruefung Mess-Anfrage gegen Bau-Freigabe, die CLI-Warnung und der anschliessende vorbehaltlose Nachbau.

**Zwei-Baum-Wurzeln zeigen auf das Buildsystem-Volume /mnt/comdare-buildsystem (GESAMTBILD A-4: 'kein Neubau, nur Wurzeln zeigen lassen')**

Die Verortung existiert nur in Plandokumenten (docs/plaene/20260808-GESAMTBILD-...:293). Im Code gibt es keine Zeile, die eine der beiden Realm-Wurzeln auf diesen Pfad setzt; es gibt ueberhaupt keinen Ort, an dem eine Wurzel gesetzt wird (s. voriger Befund).

**Tools-Lagerhaltung: Toolchain-/Treiber-/Planer-/CEB-Werkzeug-Binaries ueber minio wiederverwenden**

Vollstaendig ungebaut; existiert nur als §65-USER-KERN-b im Ledger.

**A9-S4/S5: CLI comdare_mess_report (render|plan|version) als Hauptkonsument des xlsx-Writers**

Vollstaendig ungebaut. Damit hat der xlsx-Writer im ganzen System KEINEN Konsumenten -- die Kette CSV -> xlsx-Baum ist an beiden Enden offen.

**xlsx-SKIP: gueltiger Bestand bei exakt gleicher Binary => xlsx wird NICHT neu erzeugt**

Der Owner-KERN vom 08.08. ('Gueltiger Bestand => SKIP, fuer Messdaten UND Binaries') ist auf der Messdaten-Seite nicht implementiert. Fuer Binaries greift er ueber dll_is_current; fuer die xlsx-Ausgabe gibt es keinen Bestands-Check.

**Schwere-Leiter: Lager-Inkonsistenz ist FATAL (Abbruch von Compile oder Messung), nicht ERROR**

Die Owner-Zuordnung 'Lager-Inkonsistenz ist FATAL' hat im Code kein Gegenstueck. Es gibt keine Stelle, an der eine Lager-Inkonsistenz einen Lauf abbricht.

**pmc_cache_misses_l3 oeffnet ueber den amd_l3-PMU-Typ (statt ueber PERF_TYPE_HW_CACHE/LL)**

Es fehlt die dynamische PMU-Typ-Aufloesung (amd_l3 Typ 17 lesen, RAW-config aus /sys/devices/amd_l3/format bauen: event/umask/coreid/sliceid/threadmask/enallcores/enallslices sind vorhanden, ein events/-Verzeichnis gibt es NICHT -> RAW-Kodierung zwingend). Ohne sie ist L3 auf prod1 nicht messbar.

**B-6 RAW-PMC-Events je Mikroarchitektur (Zen 3/4/5, Alder/Raptor Lake) per Deep-Research**

Komplett: keine uArch-Erkennung im PMC-Pfad, keine RAW-Event-Tabelle, keine Auswahl je CPU-Familie.

**cache_misses_l2 und coherence_invalidations werden erhoben**

Beide Zaehler sind ehrlich als "n/a" ausgewiesen (das ist korrekt gebaut), aber sachlich nie erhoben. Auf AMD lieferten sie amd_l3-RAW-Events; die Erhebung haengt am selben fehlenden RAW-Pfad wie B-6.

**B-3 getrennte Ablage je PMU-Domaene im CSV-/Lager-Schema**

Die komplette Spalte/Dimension. Ohne sie kann ein E-Core-Lauf nicht von einem P-Core-Lauf derselben Binary unterschieden werden — der Datenbruch, den B-3 verhindern sollte.

**super hat KEINE Abdeckungs-Wache — die Test-Auswahl ist ungegengerechnet**

Eigenverifikation am Objekt: ALLE super-eigenen Registrierungspunkte tragen heute das Label (grep 'da_unit' ueber Code/ ohne external/: tests/CMakeLists.txt:17 + :237, 02_messung_driver:100/139/172/189/209/221, 03/04/05/06/08/09 je eine gtest_discover_tests-Zeile). Die Auswahl ist also HEUTE vollstaendig — aber nichts haelt sie so. Die 424 Rest-Tests sind ce-Sub-Build-Tests, deren Deckung im ce-Repo liegt; nachgewiesen ist das nirgends.

### Zustand `nur-spezifiziert` — 14 von 103

**HYBRID-Adapter-Stufe: B-10 libs/cache_engine/hybrid/, HybridDockVariant, HybridBinaryProxy, hybrid_router, hybrid_eviction, <hybrid_tier>-XML (A17 / LEDGER:4591-4620, 4714)**

Die gesamte vierte Kettenstufe fehlt: alle 9 im README-Katalog gelisteten Dateien, der Break-Even-Router, die Verdraengungs-Strategie, der Dock-Array, der <hybrid_tier>-XML-Parser. Das SOLL "Hybrid-Binary (4. Kettenglied) ist Abgabe-Pflicht" (LEDGER:2340-2348, §31-A2) ist zu 0 % erfuellt. Die Kette laeuft heute PLANER -> CEB -> TIER, ohne HYBRID.

**G3 aus dem STATISTICS-Gate in ein eigenes Makro loesen (OWNER-KERN, LEDGER:11276-11289; Vorbedingung fuer die 6 CEBs)**

Das komplette Paket: (a) neues Makro + CMake-Option, (b) Umhaengen des Blocks abi_adapter.hpp:1784-2057, (c) 7. Feld im mess_gates_glied (Preimage-Byte-Ereignis), (d) Erweiterung der A8-S4-Praeprozessor-Wache um das neue Gate, (e) neuer Zweig in mess_achsen_defines(). Bis dahin ist die Owner-Forderung 'SECHS CEBs' nicht erreichbar.

**checkpoint_measure als EINE uniforme Funktion mit compile-time IN/OUT-Tag (OWNER-KERN 08.08., LEDGER:11739-11765)**

Alles. Keine Funktion, kein Header, kein Typ, kein Test, kein CMake-Flag.

**checkpoint_measure: Verhaeltnis der Ebenen-Flags zu den CEB-Gates -- EIN Mechanismus, nicht zwei (Design-Doc Offener Punkt 6)**

Der Entscheid muss VOR dem checkpoint_measure-Bau fallen, sonst entstehen zwei Achsen fuer dieselbe Sache. Konkret verfuegbare Andockstelle: mess_gates_glied.hpp:64-66 hat die Erweiterung des Glieds bereits als Pflicht deklariert und mit static_asserts (:246-265) gegen Vergessen gesichert -- ein Ebenen-Flag, das dieses Glied nicht erweitert, waere sofort ein zweiter, unsichtbarer Kanal.

**Fehlerklassen je ALGORITHMUS (A15 Ebene 4, per-Varianten-Verfeinerung)**

Der Owner-Wortlaut verlangt Fehlerklassen bis auf die Algorithmen-Ebene. Real deklariert 0 von 121 Algorithmen einen eigenen Satz; alle erben denselben Realm-Boden. Der FK-5-Header deklariert die Luecke selbst (topics/organ_axis_error_classes.hpp:82-84: 'sie prueft nicht, ob der Satz fuer DIESEN Algorithmus vollstaendig ist -- das ist die per-Varianten-Verfeinerung, die als deklarierte Luecke offen bleibt'). Das ist eine EHRLICHE, keine verschwiegene Luecke -- aber es ist genau die Konstellation 'Wache gruen bei leerem Gegenstand'.

**compare-Stufe D2 (measure vs. compare vs. release, lesender Lager-Zugriff)**

Es gibt keinen lesenden Lager-Zugriff, keine eigenen compare-Optionen, keinen Vergleichs-Algorithmus, keine Ausgabe. Auch die Planer-CLI kennt compare nicht: /home/comdare/wt-ce-fk/apps/experiment_planner/main.cpp fuehrt nur `validate|plan|cache-key|fingerprint|version` (:401-436 Hilfe-Themen, :507-561 Dispatch). `measure ⊂ compare ⊂ release` ist reine Doku. Der Header ist ehrlich -- die Selbstauskunft deckt sich mit dem Befund.

**Paper-Research: ein Paper = ein wiederverwendbares Experiment-XML (<template ref=..>)**

Es existiert kein einziges Paper-Template-Profil, keine Registry fuehrt sie, kein Konsument loest ref auf. Der Owner-Satz 'es gibt keine Kandidaten' hat am Code noch keinen Gegenstand.

**Symmetrie-Prinzip: beide Maschinen bauen alles Moegliche, gleiche XML, Koordination nur ueber den Cache-Sync**

Kein Nachweis, dass zwei Lanes (prod1/prod2) je real parallel gebaut/koordiniert haben; die Koordination liegt komplett im nirgends aktivierten Bestandslog. Zusaetzlich nicht am Objekt pruefbar, weil der Cluster read-only ist.

**A9: xlsx-Ablage im zweigeteilten Lager-Baum -- xlsx NUR im Messdaten-Realm, Verbindung zu binaries rein referenziell**

Kein Code verbindet Writer und Baum: ergebnis_mappe.hpp inkludiert lager_baum_writer.hpp nicht, es gibt keinen Aufruf von knoten_pfad()/einlagern() aus dem xlsx-Weg, und A9 legt laut eigenem Design 'NIE selbst Knoten an, sondern bezieht das Blatt-Verzeichnis vom Baum-Writer/Resolver' -- dieser Resolver-Aufruf existiert nirgends. Die Mappe wird an einen vom Aufrufer uebergebenen Pfad geschrieben.

**Pool-Modell: Node-bevorzugte Builds unter Locking (genau ein Runner je Permutation)**

Kein aktiver Locking-Mechanismus im naechsten Voll-Lauf. Der Mess-Exklusivitaets-Teil (§38.b/§61, eine messende CEB je Maschine) ist damit ebenfalls unbewacht.

**B-2 Pinning-Konsument im Mess-Loop (Planer-Freigabe -> CEB-Compile-Einbau -> reales Pinning)**

Alles ausser dem Aktuator: keine Planer-Freigabe, kein CEB-Compile-Einbau, keine Bindung an die erhobene core_class, kein Pinnen im Mess-Loop. Der Header deklariert die Grenze selbst (numa_cpu_pin_process_probe.hpp:110-118: "dieses Paket ist das ANGEBOT, nicht sein Konsument ... Folge-Paket OD-11-RT-K") — diese Selbstaussage ist am Objekt bestaetigt, nicht geglaubt.

**L3-Asymmetrie-Messung (8 Kerne je Domaene, 96 gegen 32 MB) ist PFLICHT**

Die gesamte Mess-Seite: keine XML-Deklaration der core_class-Werte, kein Pinning auf die grosse/kleine L3-Domaene, keine getrennte Ablage (siehe B-2, B-3).

**EINE CEB traegt beide Messfuehler und legt Ergebnisse je PMC getrennt ab (Permutation statt zweiter Binary)**

Die Ausfuehrungs- und Ablage-Haelfte vollstaendig; nur die Nicht-Verdopplungs-Garantie steht.

**E-07-Gate Stufe 2: die literalen E07_*-Gate-Zeilen (K1-K5, N1-N3)**

Vollstaendig ungebaut. Acht Kriterien, zehn Ausgabezeilen, kein Traeger.

### Zustand `teilweise` — 62 von 103

**CMakeGraphBuilder SCHARF / Bare-Metal-Pflicht: identischer Bau ohne GitLab-CI (LEDGER:2469,2474 §40.c; Wellenplan W7-B)**

Der CEB-BAU der Stufe 1 ist im bare-metal-Plan ein Echo mit Stempel, kein Bau. Ein Bediener, der nur `cmake --build --target comdare_experiment_plan_all` faehrt, baut den CEB nicht -- er muss den aeusseren Configure selbst richtig parametrieren (inkl. -DCOMDARE_MEASUREMENT_COMBO=..., das der Plan nur als echo-Hinweis ausgibt, :512-515).

**EIN Storage-Tree im Code, ZWEI Filesystem-Wurzeln binaries/measurements, lazy, konzeptionell synchron (OWNER-KERN 08.08., LEDGER:12141-12236)**

Die MESSDATEN-Wurzel wird im Live-Lauf nie beschrieben: die drei Host-Binder-Felder mess_bestand_doc_key / mess_bestand_key_of / mess_bestand_versions (libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:316/317/320) werden GELESEN (:1941, :1943, :2145, :2882, :2888), aber repo-weit -- ce UND super Code/02_messung_driver/ -- NIRGENDS ZUGEWIESEN (grep auf `mess_bestand_*=` bzw. `.mess_bestand`: 0 Schreib-Stellen). Damit ist `mess_bestandslog_active` (:1939-1941) immer false und die Messwert-Registrierung im Lager laeuft nie an.

**Konformitaets-Gate gegen std::map-/Genus-Orakel blockiert die Messung bei Fail (LEDGER-Backup befunde-83; ce docs messarchitektur_v5 §6)**

Im MESS-Lauf laeuft das Orakel-Gate NICHT in-process: cache_engine_builder_iterator.hpp:2694 prueft nur `pruefe_mess_konsistenz` und :2708 `acquire_search_algorithm_drive` (beides fail-closed). Das Orakel-Gate ist ein SEPARATER Lauf (COMDARE_PRUEF_ONLY, :2255-2290), den der emittierte Plan davorschaltet. Gegatet wird also ueber die BAU-REIHENFOLGE, nicht innerhalb des Mess-Laufs -- wer den Treiber von Hand ohne den Pruef-Vorlauf startet, misst ungeprueft.

**B+-Baum-Teilbaum-Serialisierung Planer->CEB (§38 hinab, LEDGER:2434-2443)**

Die LIVE-Kette reicht die Achsen-Ranges NICHT ueber dieses Protokoll, sondern ueber den emittierten CMake-/YAML-TEXT (COMDARE_GN_OPT / COMDARE_GN_SIMD / COMDARE_GOLDEN_N_RANGE, experiment_plan_director.hpp:1763 ff.). Das volle Wire-Format (5-tiefer #19-Resolver -> LinkedExperimentPlan) ist Band-C-deferred. Der Vertrag existiert also als getestete Referenz-Serialisierung ohne Konsumenten.

**Messkette DREI Stufen / SECHS CEBs -- der Planer kompiliert die 3!=6 Permutationen ein-/ausgebauter Messgeraete (OWNER-KERN 08.08., LEDGER:10964-10990, 11129-11139)**

Der Kern faltet je DEKLARIERTER <combo>-Konfig EINE CEB-Strecke -- er erzeugt KEINE 3!-Permutation ein-/ausgebauter Messfuehler; das Wort "Permutation" kommt in measurement_combos_of nicht vor, die Funktion iteriert schlicht ueber die deklarierte Liste (:2065-2078). Die zur Messfehler-Herausrechnung geforderten 6 CEB-Varianten existieren nirgends. Zusaetzlich stehen die Design-Luecken D1 (XML-Schema fuer N Tooling-Konfigs), D3 (Resolver Angebot->Anwahl) und D4 (Job-Namens-Kollision bei N>1) ausformuliert und OFFEN im Header :2042-2054.

**3 (bzw. 4) Modi Debug/Messung/Release/Compare, exactly-one je Call; Release/compare als Rekonstruktions-Anfrage, measure ⊂ compare ⊂ release (LEDGER:3350-3374 §61-STUFEN, 11305-11320)**

COMPARE hat AUSSER der Registry-Zeile keinen Konsumenten: /usr/bin/grep -rn "RunMethodology::Compare" ueber libs/ + apps/ = 5 Treffer, ALLE in dieser einen Registry-Datei (:97 Deklaration, :120/:144/:146 static_asserts). Es gibt keine compare-Stufe, keinen Replay-Vergleich, keine Rekonstruktions-Anfrage. Zweitbefund: PlanBuildSemantic::measurement_on hat NULL produktive Leser -- der Header sagt es selbst (:116 "measurement_on 0 Leser"), und ein grep bestaetigt es: ausser der Setz-Stelle :2015 und den Tests liest niemand build_semantic.measurement_on. Die Emitter verzweigen ausschliesslich auf cmake_build_type == "Debug".

**Experiment-B+-Baum IST die Vergleichs-Ordnung, lazy materialisiert, Geschwister-Vergleich bei identischem Teilbaum (OWNER-KERN, LEDGER:11009-11036)**

ZWEI Praezisierungen. (1) Der Code korrigiert den Namen selbst: experiment_tree.hpp:5-7 "PRAEFIXBAUM (je Ebene 1 Achse, Blaetter = Kompositionen) -- NICHT ein textbook-B+-Baum ... der historische 'B+-Baum'-Name ... " -- die Ledger-Sprache und der Gegenstand decken sich also nicht. (2) Die Geschwister-VERGLEICHS-Semantik ist als ORDNUNG vorhanden (mixed-radix), aber es gibt keinen benannten Vergleichs-Operator: grep "Geschwister|sibling" in experiment_tree.hpp = 0 Treffer. Wer zwei Binaries mit genau EINEM Knoten Unterschied finden will, hat dafuer heute keinen gebauten Zugriff.

**Die Zuordnung wallclock=G1 / macro=G1+G2 / micro=G1+G2+G3 (mess_achsen_naht.hpp:74-78)**

Eine [wallclock]-Binary ist damit KEINE fuehlerfreie Referenz: sie traegt die 18 per-Achsen-Segment-Timer via Pfad A weiterhin einkompiliert. Der Owner-KERN begruendet die 6 CEBs elektrotechnisch mit 'Messfuehler = Verbraucher', also mit einem Lauf OHNE Fuehler als Nullpunkt. Diesen Nullpunkt gibt es heute nicht -- weder [wallclock] noch irgendeine andere baubare Combo baut den Feinkorn-Timer aus. Das gehoert in die Beschreibung des G3-Folgepakets, das heute nur Pfad B im Blick hat.

**Fuenf Mess-Ebenen (Planer-CLI / Pruefdock-Gesamt-Last / Pruefdock-je-Interface / Tier-Macro / Tier-Micro; LEDGER:11064-11083)**

(a) Ebene 2 ist im produktiven Profil-Pfad KEINE eigenstaendige Messung, sondern per Konstruktion identisch zur Summe von Ebene 3. Die A8/F2-Konsistenz-Invariante Summe(E1) <= E2 <= E3 kollabiert dort an der zweiten Ungleichung zu einer Identitaet und kann nichts entdecken. (b) Die Ebenen sind NICHT einzeln schaltbar: perm_runner.hpp enthaelt 0 Praeprozessor-Direktiven (`grep -n '#if|#ifdef'` = 0 Treffer), die Host-Ebenen 2/3 sind also immer einkompiliert und stehen der Mess-Achse gar nicht zur Verfuegung. Die 'Messgeraet ein-/ausgebaut'-Permutation kann daher nur die Tier-Seite variieren -- und dort nur 2 Zustaende.

**Separater Messpunkt fuer die Gattungs-Interface-Ebene (Klebe-Zeit; OWNER-KERN LEDGER:11526-11529)**

Es ist eine DIFFERENZ, keine Messung -- und es misst den falschen Gegenstand. measurable_workload.hpp:106 benennt den Inhalt selbst: 'der NICHT-segmentierte Rest (rng, ...)', also Loop-/Instrumentierungs-Overhead des Mess-Treibers innerhalb des Tier-Segmentlaufs. Der Owner-KERN verlangt die Zeit der Gattungs-/Genus-Interface-Implementierung ZWISCHEN den Achsen-Aufrufen, ueber das Macro-Benchmarking separat gemessen. Ein Messpunkt an der Gattungs-Interface-Ebene existiert nicht; die vorhandene Zelle wuerde ihn beim Auswerten stillschweigend vertreten. Das ist genau der Posten, den checkpoint_measure Offener Punkt 3 (Design-Doc :259-262) als 'vierte Ebene oder Sonderfall von macro?' offen fuehrt.

**83 Achsen-Bausteine (Organ-Algorithmen) im ENABLED-Inventar, 121 Varianten-Header im Bestand**

52 von 83 Bausteinen tragen golden_wired="false" (`grep -c 'golden_wired="false"'`). persistence_target (T17) hat GENAU EINEN Baustein -- eine Achse mit einem einzigen Wert kann per Definition keinen Vergleich tragen und faellt aus dem Experiment-B+-Baum als Vergleichsdimension heraus.

**target_isa als Komplex-Achse mit Unterachsen**

Der Ledger-Wortlaut Paragraf 69.2 nennt als target_isa-Glieder 'RAM-Frequenz + CAS + CPU-Fabrikation' als FESTE Rekombination der Komplex-Achse. Im Registry-XML erscheint unter target_isa KEIN ram_frequency/cas/cpu_fabrication-Glied; RAM lebt separat in measurement/ram_probe_chain.hpp + ram_frequency_reading.hpp als Provenienz-Kette, nicht als Achsen-Glied. Die Komplex-Achse traegt stattdessen ISAxOS (complex_count=2).

**FK-3: Fehlerklassen der System-/Mess-/Komplex-/Meta-Meta-Achsen**

ZWEI Loecher, beide am Objekt belegt. (1) Die Vollstaendigkeit ist eine Handliste von 20 im Test-TU (test_a15_fk3_axis_error_traits.cpp:196-220, Abschluss :221 check("GENAU 20 Achsen-Familien aufgezaehlt", n == 20u)) -- exakt die heute geheilte Handlisten-Regressionsklasse. (2) Konkreter Fund daraus: CompoundSystemAxis (ceb_complex_system_axis.hpp:77, in der Registry als build_target_complex, system_axis_registry.xml:95) hat 0 Treffer in axis_error_traits.hpp (`grep -c CompoundSystemAxis axis_error_traits.hpp` = 0) -- eine registrierte, aus CebSystemAxis abgeleitete Achse OHNE deklarierten Fehlerraum. Zusatz: assert_axis_error_traits<> hat ausserhalb dieser Test-TU KEINEN Aufrufer (`grep -rn assert_axis_error_traits libs/ apps/` = 0 Treffer ausserhalb des Definitions-Headers), d.h. keine Produktions-Instanziierung erzwingt die Traits.

**KF-6: ALLE line_sizes muessen unterstuetzt sein, sofern von der Hardware freigegeben**

Die Durchbindung fehlt, und der Code sagt das selbst: cacheline_line_bytes.hpp:16-20 'KF-6-NAHT (Posten 62, NICHT hier): heute instanziieren alle Strategie-Basen die Default-CacheLineConfig{} (line_size = B64), weil der Codegen die per-Organ-Config noch nicht als NTTP emittiert.' Am Objekt bestaetigt: axes/alloc/axis_06_allocator_strategy_base.hpp:174-175, axes/node/axis_04_node_type_strategy_base.hpp:21-22, axes/lookup/axis_03a_search_algo_base.hpp:27, topics/nodes/axis_01_page_type/axis_01_page_type_strategy_base.hpp:13-14 -- alle mit `CacheLineConfig CacheLineCfg = CacheLineConfig{}`. Zusatz: cacheline taucht in KEINER Registry-XML auf (`grep -c cacheline cache_engine_axis_registry.xml` = 0), ist also fuer den Planer nicht permutierbar. Real erreichbar ist 1 von 60 Konfigurationen.

**Vier Container-Genera auf Produktionstiefe (Set/Sequence/Adapter/View) + Cross-Genus-Komposition-als-Sub-Organ**

Die Cross-Genus-Organe sind OPT-IN und stehen NICHT im gemessenen Achsenraum: `grep -c 'FromSequence|FromAdapter|FromSet' cache_engine_axis_registry.xml` = 0. Sie leben nur in builder/experiment_tree/cross_genus_composition.hpp:124/129/134 als eigene StaticAxisVariants-Listen. Im Default-Enabled-Inventar taucht kein einziges Cross-Genus-Organ auf -- der Vertrag ist gebaut, die Permutation nicht freigegeben.

**T6/Posten-68 Option B: multiple Allokatoren HINTER dem EINEN Achsen-Interface; Organ-Algorithmus ohne Achsen-Zuordnung = Regression**

Die Regressions-Definition ist verletzt: SortedArrayKeySet (anatomy/set_default_organ.hpp:18) ist ein LEBENDER search_algo-foermiger Organ-Algorithmus -- benutzt in cross_genus_organ.hpp:77, cross_genus_composition.hpp:101/108/169 und drei Test-TUs -- hat aber 0 Treffer in cache_engine_axis_registry.xml. Der Header deklariert den Zustand selbst (:8 'als Set-Kern ist die R5.B-Operativitaets-Erweiterung (separat, #74-artig)'). R5.B ist damit unverbaut.

**A14: OsIdentityProbe je OS-Familie + zwei NEUE Fehlerklassen (OsIdentitaetUnerhebbar / OsDeklarationsAbweichung)**

Die zwei im A14-Design benannten Fehlerklassen existieren unter diesen Namen NICHT: `grep -rn 'OsIdentitaetUnerhebbar' libs/ tests/` = 0, `grep -rn 'OsDeklarationsAbweichung' libs/ tests/` = 0. Stattdessen wird die generische Klasse BetriebssystemFeatureFehlt gefuehrt -- damit ist 'OS-Identitaet unerhebbar' nicht von 'OS-Feature fehlt' unterscheidbar, und der Cross-Check-Fall 'Deklaration weicht vom gemessenen Wert ab' (Warnung, misst weiter) hat gar keinen Traeger. `declared_not_measured` existiert nur fuer RAM-Frequenz-Provenienz (ram_frequency_reading.hpp:80), nicht fuer OS.

**Round-Trip-Test fuer die Registry-XMLs in CI (Anti-Drift zwischen Enabled*-Listen und committeter XML)**

Zwei Einschraenkungen. (1) Das ce-Gate traegt LABELS "contract;registry;roundtrip" und ist damit aus dem Default-Sweep test:unit (-LE contract|pmc) ausgeschlossen -- es laeuft nur im Job contract:profile_coverage. (2) Die beiden W2-B-Gates haengen an einem EXISTS-Guard auf die committete XML: fehlt die Datei, wird der Test STILL NICHT REGISTRIERT und die Pipeline bleibt gruen (CMakeLists.txt:5010-5012 dokumentiert das ausdruecklich). Das ist die Konstellation 'Wache mit unvollstaendigem Nenner' -- beide XMLs existieren heute, aber ein Loeschen wuerde die Wache lautlos abschalten.

**Einheitliches Schema zwischen ce- und prt-art-Registry (Type-Spelling mit '::'-Praefix, Slot-Vokabular)**

Die Gegenseite (comdare-prt-art mit dem axis_02-Slot-Vokabular) liegt nicht in den drei fuer diesen Auftrag freigegebenen Arbeitskopien (super/ce/thesis). Ob das Slot-Mapping T03 <-> axis_02 heute als additives Attribut dokumentiert ist und ob 'genus' auf der ce-Seite aus dem Slot reflektiert statt separat gepflegt wird, konnte ich nicht beidseitig pruefen -- in der ce-XML steht genus als eigenes Attribut und ist auf ALLEN 18 Achsen "SearchAlgorithm", obwohl vier Container-Genera existieren.

**Auswertungskette Messwerte -> Funktions-Synthese -> Schnitt-Kurven -> optimale Konfiguration**

Die Kette ist an KEINER Stelle verdrahtet: Es gibt keinen Aufrufer, der eine Mess-CSV laedt, Splines baut, Schnittpunkte rechnet und ein Artefakt schreibt. Zwei der drei Traeger tragen im eigenen Kopf das Wort SKELETON (decision_lambda_trees.hpp:2, best_binary_selector.hpp:353). Es fehlt: der Treiber (CLI oder CEB-Naht), das Ausgabe-Artefakt und die Gruppierung je Achsen-Permutation.

**B-9 Funktions-Synthese + Break-Even-Rechnung als eigenstaendiges Bau-Paket**

Es fehlt der Rahmen um die Teile: kein Aufrufer, keine Gruppierung ueber die Achsen-Permutationen, keine Persistenz des Ergebnisses, kein Uebergang zur Binary-Wahl. Die drei divergierenden Modelle (s.o.) muessen vorher zusammengefuehrt werden, sonst entscheidet der Zufall des Include-Pfads, welche Kurve die Thesis-Zahl traegt.

**Anzahl der XML-Schemata / Dialekte der Kette**

Neun von elf Dialekten haben keine formale Schema-Datei; ihre Struktur lebt nur im handgeschriebenen Reader (xml_reader.hpp, 216 Z.) plus Prosa (algorithm_profiles/SCHEMA.md). Ein Tippfehler in einem <comdare_thesis_profile>/<comdare_load_profile>/<comdare_axis_registry> hat keine Schema-Instanz, die ihn faengt.

**Zwei-Registry-Kanon (ce + prt_art) mit einheitlichem Schema**

Das Slot-Vokabular divergiert weiter: DIESELBE Achse path_compression heisst in der ce-Registry slot="T03", in der prt_art-Registry slot="axis_02". Ein Cross-Referenz-Join ueber beide Registries scheitert damit weiterhin an der Schreibweise; ein Mapping-Attribut existiert nicht.

**Golden-XML als staendig gepflegte TRIGGER-INPUT-BASIS (B14/A7)**

ZWEI dieser Bloecke sind im comdare_experiment-Dialekt tot: 'organ_subaxes' hat im gesamten ce-Code 0 Fundstellen (grep ueber libs apps tests, ohne build/), und run_options wird in parse_experiment_profile (xml_config_parser.cpp:449-574) NICHT gelesen -- nur im Thesis-Dialekt (:431-440). Das Owner-N 2^17 und die KF-6-line_sizes stehen also maschinenlesbar in der kanonischen Trigger-XML und werden vom Parser verworfen. Ersatzwache ist test_golden_n_consistency, die den Wert nur gegen das Schwesterprofil und gegen ein CMake-Literal EXPECTED_N=131072 haelt.

**cache_engine --check-size "FILE" -- Experimentgroesse/-dauer auf der Zielmaschine berechnen**

Es fehlen alle drei Zusagen des Owner-KERN: (a) das CLI-Flag selbst, (b) die DAUER-Schaetzung, (c) dass die Rechnung AUF der CEB laeuft und die Systemeigenschaften per Hardware-Erkennung eines ggf. vorsorglich gebauten CEB bestimmt werden. PlanSizeBuilder rechnet host-lokal am Plan, ohne CEB und ohne Hardware.

**Enum-Pruefung der Experiment-XML im Validator (mode / op_types / version / datasets)**

DREI konkrete Luecken: (1) <metadata><mode> wird nie gegen {defined,full,full_sampled} geprueft -- die Enum-Pruefung existiert nur im LEGACY-v32-Zweig super Code/02_messung_driver/messreihe_v32_validator.hpp:147-149, nicht fuer comdare_experiment. (2) ep.version wird nicht geprueft (kein v1-Hinweis). (3) ep.datasets bekommt NICHT die fuenf Format-Checks, die tp.datasets bei validate_profile.hpp:312-345 bekommt (id nicht leer/eindeutig, akte_ref-Suffix .test_data.xml, loader gegen kKnownDatasetLoaderIds:117).

**<metadata><mode> steuert den Messpfad statt eines stillen Env-Override**

Die zweite Haelfte der Zusage fehlt: v32_messreihe_antrieb.hpp:96-100 parse_enumeration_mode faellt bei UNBEKANNTEM Token still auf EnumerationMode::Defined zurueck (kein optional, kein Abbruch, kein eigener Return-Code), und validate_experiment_profile prueft mode gar nicht. Ein Tippfehler <mode>fulll</mode> laeuft damit klaglos als 'defined' -- genau die stille-Rueckfall-Klasse, die die Doktrin verbietet.

**Workloads/Datasets kommen aus den XML-Deklarationen statt hartkodiert**

ep.workloads und ep.op_types haben im gesamten ce-Lauf-Pfad 0 Fundstellen (grep ueber libs/cache_engine/profile_facade/*.hpp ohne validate_profile/xml_config_parser). Der Validator prueft <workloads> gegen die realen load_profiles-ids (validate_profile.hpp:1319-1330), der Lauf konsumiert sie danach nicht. op_types wird ausschliesslich vom LEGACY-super-Antrieb als Label-Liste genutzt (v32_messreihe_antrieb.hpp:156-168).

**<lebewesen>/phase.engine/pruefling steuern den Host-Dispatch real**

Auf dem super-Antriebspfad bestimmt allein phase.merge die Komposition; die sieben <lebewesen>-Eintraege und phase.engine/engines sind dort wirkungslos. Der geforderte compile-time-Dispatch (mp_for_each ueber die per-Host-Kompositionen) existiert dort nicht.

**Ein-Hauptkanal-Doktrin: EINE XML als Quelle, EIN Kanal der sie baut**

Zwei Lauf-Pfade fuer denselben Dialekt bedeuten zwei Wahrheiten: der eine kennt Datasets/opt/simd/run_methodology, der andere op_types und ein Konformitaets-Gate ohne Wirkung. Welcher der offizielle ist, entscheidet heute der Aufrufer, nicht die XML.

**XSD-Abdeckung des comdare_experiment-Dialekts (Schema vs. Parser vs. Instanz)**

Zwei XSD-Elemente haben KEINE Parser-Naht im comdare_experiment-Dialekt: run_options (parse_experiment_profile, xml_config_parser.cpp:449-574, enthaelt keine run_options-Zeile) und organ_subaxes (0 Fundstellen im gesamten ce-Code). Beide stehen in der kanonischen Trigger-XML. <hybrid_tier> existiert nur als Kommentar-Reserve (experiment_schema.xsd:102-124) ohne Typ, ohne Parser, ohne Instanz.

**XML-Reader-Haerte gegen DOCTYPE/Entities (XXE-Flanke)**

Weil keine Entity expandiert wird, ist der klassische XXE-Datei-Lesepfad zu; ein DOCTYPE mit internem Subset kann den Parser aber in einen falschen Zustand versetzen, ohne dass das laut wird. Der im Plan gefuehrte Bissbeweis T-i-1 (zwei Fixtures, rot-ohne/gruen-mit-Sperre) existiert nicht als Test.

**Zwei Filesystem-Wurzeln (binaries/measurements), konzeptionell synchron, physisch LAZY, zwei Durchlaeufe**

NULL Produktions-Konsumenten. `grep -rn "make_binaries_baum_writer|make_messdaten_baum_writer" libs apps tools` liefert AUSSCHLIESSLICH die Definitionsstellen lager_baum_writer.hpp:600/:605; die einzigen Aufrufer sind tests/unit/test_lb0_lager_pfad_grammatik.cpp:513/:532/:540/:546/:555/:556/:591/:640/:652. Kein Host, kein Iterator, keine Fassade instanziiert je einen Writer. Die Wurzel ist ein Konstruktor-Argument (`std::string wurzel`, :538) ohne Default und ohne Belegung. Der 'zweite Durchlauf' (Messungen ueber die Binaries) hat damit keinen Schreiber.

**SKIP gilt auch fuer Binaries; EIN Storage-Tree im Code, zwei Realms nur ueber Factory-/Detail-Pattern getrennt**

Der Storage-Tree und die Skip-Mechanik sind ZWEI getrennte Welten, die nirgends verbunden sind: der Skip laeuft ueber Sidecars neben der DLL im output_dir bzw. ueber das Bestandslog-XML in minio, NICHT ueber den Baum-Writer. Von den drei Skip-Quellen ist nur die erste (dll_is_current) im naechsten Lauf ohne Env aktiv.

**Zaehler-Resume: Batch-Plan (Reihenfolge+Faecher) persistent VOR dem Lauf; Resume = Zaehler je Phase gegen den Plan (Owner-KERN A1)**

Der HOST belegt das Feld nie: `grep -c batch_plan_datei /home/comdare/wt-super-landung/Code/02_messung_driver/main.cpp` = 0. Alle Belegungen liegen in tests/unit/ (test_tp1_planer_filter_iterator.cpp:957/:1206/:1453/:1664/:1774, test_t2a_f4_facade_plan_durchreichung.cpp:154). Im naechsten Voll-Lauf ist PlanPersistenz::aktiv()==false -> kein Plan wird abgelegt, kein Zaehler-Resume moeglich. Der Owner-KERN 'Batch-Plan persistent VOR dem Lauf' ist damit gebaut, aber nicht scharf.

**Zwei Bestandssysteme als Factory Pattern (binary | measurement) + SHA512-Fingerprint-Stempel**

Das ZWEITE Genus wird nie gefuellt. Der Iterator hat die Felder (cache_engine_builder_iterator.hpp:316 mess_bestand_doc_key, :317 mess_bestand_key_of) und das Gate (:1940-1943), aber `grep -rn "mess_bestand" libs apps tools` in ce liefert 12 Treffer, ALLE in cache_engine_builder_iterator.hpp -- null Zuweisungen ausserhalb. `grep -c mess_bestand Code/02_messung_driver/main.cpp` = 0. G-E3-Host-Binder fehlt vollstaendig; im Voll-Lauf entsteht kein measurement-Bestandslog. (Der Plan-Befund K-2 in docs/plaene/20260806-PLAN-katalogposten-p2p8-und-trigger-reste.md:134-165 ist am Objekt bestaetigt.)

**Cache-Log-Koordination als lockbare Sync-Datei (minio) + Batch-Reservierung mit Lease/Timeout**

Gesamter Weg haengt am nirgends gesetzten COMDARE_BESTANDSLOG. Zusaetzlich ein historisch dokumentierter, nicht ausgeraeumter Konflikt (super docs/sessions/backups/20260726-session-plaintext-verlauf/verlauf-31.txt:853ff): LockRecord.ttl_s=30 gegen eine kritische Sektion mit bis zu ~49 min Retry-Budget -- ein Lock, dessen TTL das Budget um Faktor ~100 unterschreitet.

**Storage-Forecast-Doktrin: Bau-Maschine gegen NULL, Binaries->minio (Ebene B), Messergebnisse->NFS (Ebene C)**

Der Forecast-Teil selbst (Pruning lokal gegen 0, Lager-Gate G5) ist nicht als Wache am Objekt auffindbar; das super-CI aktiviert Ebene B nur hinter COMDARE_STORAGE_CACHE=='true' (.gitlab-ci.yml:695), was ebenfalls kein Default ist. Ohne Opt-in bleibt jede gebaute Binary lokal auf der Bau-Maschine liegen -- das exakte Gegenteil der Doktrin.

**RAM-Sammelpuffer 256 MB + dedizierter Writer-Thread als CT-Strategy (io_uring | IoRing | portabel)**

NULL Konsumenten: `grep -rn "SpoolWriter|ActiveSpoolWriter" libs apps` ausserhalb von artifact_transport/spool_writer.hpp liefert nur zwei KOMMENTAR-Erwaehnungen (lager_ziel_strategie.hpp:11 als Muster-Zitat, ram_spool.hpp:7/:31 als Erklaerung). Der Rueckschreib-Pfad des Iterators/Hosts benutzt ihn nicht -- der Spool ist ein fertiges, unangeschlossenes Bauteil. Windows-IoRing-Backend nicht gefunden (nur io_uring + portabel).

**LB-1 Knoten-Heuristik-Log (complete-heuristik.log je Knoten, Alleinschreiber-Lock, Truncate-Zustandsmaschine)**

Kein Produktions-Aufrufer. Ausserhalb der eigenen Datei taucht knoten_heuristik_log nur in registrierungs_sidecar.hpp:36 auf -- und registrierungs_sidecar.hpp hat seinerseits NULL Konsumenten in libs/apps (`grep -rn registrierungs_sidecar` findet nur die Datei selbst, tests/unit/test_ge1_claim_check_und_sidecar.cpp:15 und zwei CMake-Kommentare). Die gesamte LB-1/N8-Kette haengt an keinem Lauf.

**Test-Skip-Gesetz (zwei Ebenen): Voll-Build testet hart, Skip nur bei gruen-getestet inventarisiertem Bestand; Test-Log NEBEN der Binary**

Es gibt KEINEN Konsumenten, der vor einem Skip ein gruenes Test-Log verlangt: `grep -rn "test_log_neben" libs apps` liefert ausser der Definition nur den eigenen Kopf-Kommentar. Der reale Skip-Arbiter ist dll_is_current (nur .fingerprint-Vergleich) bzw. der Lager-Bestand (nur key_sha512+Zelle) -- beide fragen nie nach einem Test-Log. Die zweite Ebene des Gesetzes ist unverdrahtet.

**CEB-interner Build+Pruef-Batch: Tier-Binaries bauen, dann am Pruefdock per Google-Test pruefen, DANN messen**

Das Gate blockiert nichts -- Befund F01 aus docs/sessions/backups/20260716-voll-audit.../befunde-83.json ('Pruefdock-Konformitaets-Gate gated nichts') ist in der SOLL-Liste selbst als offener Posten gefuehrt und ich finde keinen Bau, der ihn schliesst. Ein 'nur bei pass'-Zweig, der execute_messreihe einen eigenen Exit-Code liefert, ist nicht auffindbar.

**Lager-Basis-Tests LB-6: Dummy-Strategien fuer die Stempel-Erkennung (Textdokument-Stufe + Binary-Stub-Stufe)**

Stufe 2 (echt kompilierte, sonst leere Tier-Binary, die NUR das statische Stempel-Interface der Versionierung traegt) ist nicht auffindbar -- kein Target, kein Fixture, kein Test dieser Bauart.

**E-18: LaTeX-Anhang-Vorwaerts-Kanal je CI-Lauf PLUS datierter Snapshot-Ordner an der Messwerte-Wurzel**

Der zweite Teil (datierter Snapshot measurement/thesis_compiles/JJJJMMTT-HHMMSS/ mit PDF+Compile-Log+Quellstand-SHA) ist NICHT gelandet: `grep -n "thesis_compiles|SNAP_DIR|QUELLSTAND" .gitlab-ci.yml ci/*.sh` = 0. Er existiert ausschliesslich als WIP-Patch in docs/sessions/backups/20260806-workflows-abschluss-abbruchsicher/wip-patches/e18snap-proben.sh -- ein Beweis-Skript ohne den Gegenstand, den es beweist.

**Cluster-parallele System-Achsen-Builds: jede Permutation cluster-weit genau einmal gebaut (MinIO-Dedup skip+pull), Invalidierung ueber algo_sig**

Das 'genau einmal cluster-weit' braucht Locking/Reservierung = Bestandslog = nicht aktiv. Ohne Opt-in bauen zwei Maschinen dieselbe Permutation doppelt; nur der Objekt-Store verhindert Doppel-Arbeit, wenn er vorher gefuellt wurde. Ein realer Zwei-Maschinen-Beweis fehlt.

**Weiter NFS-Export bewusst gewollt: alle Maschinen bedienen die Lagerhaltung, Sync per file**

Der Sync laeuft ueber minio-Objekte, nicht ueber die NFS-Mounts; kein Code kennt einen der drei Mount-Pfade. Ob V60-Runner direkt mounten, ist von hier aus nicht pruefbar (Cluster read-only).

**Lager-Gate G1-G5 als Vorbedingung des Voll-Builds (§66: B/C/D-Landung, Stempel-Finalisierung, Bestandslog-Kern, Push-Aktivierung, Pruning lokal->0)**

G4 (Ebene-B-Push-Aktivierung) und G5 (Pruning lokal gegen 0) sind nicht am Objekt nachweisbar: der Push haengt an COMDARE_STORAGE_CACHE, und eine Pruning-Wache (prunable_artifacts wird in artifact_cache.hpp:86 erwaehnt) hat keinen Aufrufer im Bau-/Mess-Pfad, den ich finden konnte.

**PMC getrennt je P-Core/E-Core-Domaene (cpu_core/cpu_atom), alle AMD/Intel-Architekturen**

Der PMC-Oeffner waehlt keine PMU-Domaene. Auf einer hybriden Intel-CPU (prod2 = Raptor Lake) existiert der generische PMU-Typ nicht mehr, weshalb alle vier open()-Aufrufe scheitern muessen — das ist die Code-seitige Erklaerung der roten pmc:intel-Lane. Ein Hybrid-Pfad (Typ aus cpu_core/type bzw. cpu_atom/type) ist nirgends gebaut.

**B-4 Warntext "warn: no pinned locality on hybrid architecture"**

Der Warn wird nie ausgegeben. Der Header sagt es selbst (Z.76: "Er wird hier NICHT ausgegeben -- Ausgabe ist Sache des Konsumenten") und der Konsument existiert nicht (siehe B-2).

**Schwere-Leiter WARN / ERROR / FATAL als benannte Stufen**

Es gibt keinen expliziten dreistufigen Schweregrad WARN/ERROR/FATAL als Typ. Die Semantik ist ueber die Klassen verteilt; die WARN-Stufe existiert nur als Einzelfall-Praedikat (kNoPinnedLocalityWarning), ausdruecklich "KEINE Fehlerklasse" (numa_cpu_pin_process_probe.hpp:73-78).

**target_isa als Komplex-Achse (RAM-Frequenz x CAS x CPU-Fabrikation) mit den O-2-Unterachsen**

CAS als eigenes Glied ist nicht als Achse gebaut — `grep "cas_latency|CasLatency"` ueber libs/ = 0; CAS steckt allenfalls implizit im deklarierten `ram_pair`-String. Und die drei Unterachsen sind in der Golden-XML NICHT belegt (experiment_golden_kern.xml:355-362 "BEWUSST NICHT deklariert") — die Achse existiert, wird aber nicht permutiert (target_isa Faktor 1).

**telemetry zweigeteilt: Runtime-Unterachse im Mess-Tooling UND Haupt-System-Achse (RF-8: echte Sweep-Unterachse im Planer)**

Die Mess-Achsen-Haelfte der Dual-Natur: telemetry ist keine Sweep-Unterachse im Planer und erzeugt keine daraus abgeleitete Compile-Hauptachse in der CEB.

**KF-6: ALLE line_sizes unterstuetzt, sofern von der Hardware freigegeben (Cacheline-NTTP-Verdrahtung)**

Die per-Organ-CacheLineConfig aus dem Profil kommt nicht in die Typen; effektiv laeuft der gesamte Bestand am Default 64, unabhaengig von der XML-Deklaration.

**Stiller Rueckfall verboten / 'eine Wache die bei leerem Gegenstand gruen meldet' (OWNER-KERN, LEDGER:4524-4540)**

Die Regel ist in ce vier Mal gebaut, in super genau an der einen Stelle nicht, an der sie faellt.

**YAML-Schluessel-Wache: jeder Top-Level-Schluessel genau einmal (Anti-Rueckkehr des contract:axis-version-lock-Doppels)**

super traegt die Wache nicht. Und die vom Skript selbst benannte Grenze (:50-55: wird der rufende Job selbst dupliziert und von einer inerten Fassung ueberschrieben, faehrt sie nicht mehr) ist unaufgeloest.

**super Sammel-Target comdare_da_unit_tests: Registry + HANDLISTE mit stillem if(TARGET)-Skip**

Die sechs Subdirs (03/04/05/06/08/09 CMakeLists.txt) rufen gtest_discover_tests mit LABELS da_unit, aber KEIN set_property(GLOBAL APPEND PROPERTY COMDARE_DA_TEST_TARGETS ...) — anders als 02_messung_driver (:101/:140/:173/:190/:210/:222), das es korrekt tut. Heute maskiert der GNU-Weg den Defekt (test:unit baut 'make' = all, die Test-Executables haengen am ALL); die Handliste ist damit wirkungslos-redundant statt tragend. Sobald jemand wieder nur das Sammel-Target baut, ist die Falle scharf.

**CI-5 -j/RAM-Politik je Runner-Tag vor dem Hard-Gate**

Es gibt keine Politik JE RUNNER-TAG (prod2 -j2 < prod-amd), sondern einen globalen Wert plus zwei handgesetzte Ausnahmen. Der als Gate-Vorbedingung formulierte Posten ist damit nicht erfuellt.

**Gate-Auswertung der Abdeckungs-Wache: 'declared:VAR ungesetzt' wird fail-open als deklariert verbucht**

Die Wache kann 'ausserhalb der CI' nicht von 'Variable in der CI verschwunden' unterscheiden. Sie fragt weder $CI noch $CI_JOB_ID ab (grep: 0 Treffer). Heilung: in CI-Umgebung ist ungesetzt == keine Deckung, ausserhalb weiter Annahme + Vermerk. Exposition heute klein (2 pmc-Tests), Klasse aber identisch mit 'das Gate war nie gesetzt'.

**Eigener Exit-Code fuer Konformitaets-Fail in execute_messreihe (Audit-Vorschlag: 6)**

Ein eigener, dokumentierter Prozess-Exit-Code fuer 'Konformitaets-Fail' auf der Messreihen-Ebene ist nicht belegt; die Unterscheidung passiert auf Zell-Ebene.

**Registry-Round-Trip-Gate in CI (Generator regeneriert, Byte-Diff == 0)**

Fuer die zweite XML (prt_art_axis_registry.xml) kein Round-Trip-Gate gefunden — sie wird nur als gelesene Fixture referenziert (ce tests/unit/CMakeLists.txt:3393, :3414). Der Soll-Posten nannte ausdruecklich BEIDE Registry-XMLs.

**visibility:tier-binaries — Bau-Sichtbarkeit aus plan dump**

Der Job dokumentiert seine eigene Abschwaechung (:484-487): geprueft wird nur die PRAESENZ des Feldes binary_id=, nicht ein Wert != '-', weil THESIS-Profile durchgaengig binary_id=- emittieren. Die 'Sichtbarkeit des Bau-Raums' ist damit heute nur in der schwachen Form belegt; die strengere Pruefung ist als OP-4 offen.

**Test-Skip-Gesetz zwei Ebenen: Voll-Build testet hart, Lager-Skip nur bei gruen getestetem Bestand**

Ein Test-Log NEBEN der Binary als Lager-Bedingung fuer den Skip (die zweite Ebene des Gesetzes) ist an dieser Stelle nicht belegt; die Skip-Entscheidung haengt am Bestands-/Fingerprint-Pfad, nicht an einem gruenen Test-Log-Artefakt.

## 3. Die 20 tragenden Einwände

### E1 · Linse: vollstaendigkeit — Abgleich des Wellenplans gegen die SOLL-Liste, die LUECKEN-Liste und das Regressions-Inventar, mit Ob

**Stelle:** W4 »Hartes Vor-Gate: E.0 Kern-Mess-Schema ist PFLICHT vor jeder Messung« — gegen Abschnitt E, wo E.0 das WACHEN-REGISTER ist

**Warum:** Der einzige harte Vor-Gate der Messung ist im Plan nur ein Name mit falschem Zeiger. §59 KERN-MESS-SCHEMA-STEUERUNG (LEDGER:3073, :3242 — »autoritativ, User: schon immer Gesetz, Abweichung = Regression«) fuehrt fuenf ausdruecklich als »OFFEN, kritisch« markierte Folge-TODOs: §59-SCHEMA · §59-EMITTER · §59-MERGE-STEMPEL · §59-STORAGE · §59-TEMPLATE. Keiner davon kommt in W0–W7 vor. §59 traegt ausserdem den DRITTEN Tier-Binary-Stempel (Merge-Kombination) samt POD 56→72 / layout 2→3 — also eine Identitaets-Aenderung, die nach der Plan-Logik VOR dem W3-Freeze landen muesste, im Plan aber ueberhaupt nicht existiert. Der Plan verspricht in W4 ein Gate, dessen Inhalt er nirgends baut, und verweist dabei auf einen Abschnitt, der etwas anderes regelt.

### E2 · Linse: vollstaendigkeit — Abgleich des Wellenplans gegen die SOLL-Liste, die LUECKEN-Liste und das Regressions-Inventar, mit Ob

**Stelle:** W2 Abnahme 3: »Kein Paket mehr offen, das ein Fingerprint-Preimage-Glied beruehrt (Liste aus W1)« + R-2 Gegenmassnahme 2 »Sperrliste der Fingerprint-Preimage-Glieder«

**Warum:** Die Sperrliste wird mit unvollstaendigem Nenner gebildet — genau die Fehlerklasse, die der Plan strukturell ausschliessen will. Nicht in einer Welle, aber alle identitaetsberuehrend: (a) RF-8 telemetry (§70.8, LEDGER:3682: »ECHTE Sweep-Unter-Achse im Planer, die eine ECHTE Compile-Haupt-Achse in der CEB erzeugt«) — am Objekt geprueft: telemetry existiert heute NUR als Organ-Achse T11 (libs/cache_engine/topics/telemetry/axis_11_telemetry/), es gibt keine Mess-/System-Haupt-Achse; eine neue Haupt-Achse multipliziert die Menge, die --check-size in W1 rechnen soll. (b) RF-2 (D1-gesperrte Permutationen bekommen einen EIGENEN CSV-Datensatz mit eigenem D1-Token). (c) RF-7 Stempel-Klammerung (Komplex-Achse = EIN Feld, je Achsen-Typ EINE Array-Stempel-Zeile). (d) §70.9 C-3a-Zusatz-Auflage: »Gate-Beitraege MUESSEN bei der Scharfschaltung in der Identitaet sichtbar werden (Sidecar/Stempel)«. (e) die bindende Achsen-Sortierung / E-E-Konkatenation — LEDGER:11106-11113 sagt ausdruecklich, die Sortierung sei »keine Kosmetik, sondern die Voraussetzung dafuer, dass ueberhaupt isoliert gemessen werden kann«, also selbst Preimage. (f) der Flag-Grammatik-v2-Umbau, dessen erklaerter Zweck »Invalidierung des Bestands ist das ZIEL« ist und der heute noch laeuft (mmx-Deklaration offen). Keiner dieser sechs Posten steht im Plan.

### E3 · Linse: vollstaendigkeit — Abgleich des Wellenplans gegen die SOLL-Liste, die LUECKEN-Liste und das Regressions-Inventar, mit Ob

**Stelle:** W7 »Paper-Research-Vollausbau« — und das Fehlen der Auswertungs-Schleife in W1/W5

**Warum:** Die wissenschaftliche Frage der Arbeit hat keine Welle. LEDGER:11117-11124 gibt den Owner woertlich wieder: »ueber die Paper-XML definitionen ... in denen wir sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen der Anderen Paper in dieser Achse besser gewesen waeren«, und das Ledger kommentiert selbst: »Das ist die wissenschaftliche Frage der Arbeit in einem Satz: nicht welche Komposition ist die beste, sondern waere Papers X Algorithmus fuer Achse A besser gewesen als der von Paper Y«. Zwei Zeilen tiefer (LEDGER:11128) steht die Owner-Antwort auf »Paper-Kopplung bauen?«: »Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail.« Der Plan schiebt das als »Paper-Research-Vollausbau« nach W7, also HINTER die Abgabe — ohne Owner-Vorlage, ohne Risiko-Eintrag, ohne Erwaehnung in der Kurzfassung. W5 liefert dann Break-Even-Kurven ueber die eigenen Achsen; das Evaluationskapitel beantwortet damit die Frage, die der Owner ausdruecklich NICHT gestellt hat. PV-4 (Paper-als-Pruefling, referenzierte Template-Profile je Paper) und »Regel der abstrakt-leeren Achse« fehlen ebenfalls vollstaendig.

### E4 · Linse: vollstaendigkeit — Abgleich des Wellenplans gegen die SOLL-Liste, die LUECKEN-Liste und das Regressions-Inventar, mit Ob

**Stelle:** Abschnitt A.4 »GEBAUT ABER UNVERIFIZIERT« (U-01..U-08) — und Vertragszeile V-3 GATE-VOLLZUG

**Warum:** Der Plan definiert eine Klasse, benennt sie als eine der zwei teuren (»sie sehen fertig aus«) und plant sie dann nicht ein. Fuenf von acht Posten kommen in KEINER Welle vor: U-01 (dynamische Planer-CI), U-02 (measure:golden-320), U-03 (anhang:forward), U-07 (Tier-Binary-Caching cluster-weit), U-08 (build:clang). Gleichzeitig verlangt V-3, ein rules-Gate gelte erst als erfuellt, wenn ein Job mit Job-ID und Log-Zeile gelaufen ist — das ist exakt die Arbeit, die A.4 beschreibt und die keine Welle traegt. Am schwersten wiegt U-03: anhang:forward ist der EINZIGE Vorwaerts-Kanal von den Messwerten in das Thesis-Submodul (ci/anhang_forward_core.sh, super .gitlab-ci.yml:1128ff), sein Generator ist per Default leer (anhang_forward_core.sh:95 AF_GENERATOR="${AF_GENERATOR:-}"), und er traegt einen ungeplanten Defekt (git add mit 2>/dev/null || true, danach Meldung »anhang:forward IDEMPOTENT: 0 Aenderungen« und Exit 0). W5 sagt »LaTeX-Anlage in die Abgabe«, ohne den Mechanismus zu nennen, der sie dorthin bringt.

### E5 · Linse: vollstaendigkeit — Abgleich des Wellenplans gegen die SOLL-Liste, die LUECKEN-Liste und das Regressions-Inventar, mit Ob

**Stelle:** W5 »Thesis-Ergebniskapitel C5 · DE/EN-Nachzug« und W6 »PDF baut, Anhang drin« — die gesamte Abgabe-Seite

**Warum:** Der Plan optimiert »die Kette laeuft durch« und prueft nie »die Arbeit beantwortet ihre Fragen«. Das Abnahmekriterium der Mission steht mehrfach im Ledger (:128, :238, :345): »FF0–FF4 mit realen, CI-verifizierten Messwerten beantwortet«, dazu DoD 1–7 (DoD-7 = bestaetigtes Abnahmekriterium je Experiment). Weder FF0–FF4 noch DoD kommen im Plan vor; keine Wellen-Abnahme bildet auf eine Forschungsfrage ab. Zwei konkrete Folgeluecken: (1) Die Abbildungen. »2D/3D-Graphen statt Heatmap, orientiert an anderen Papern (SOTA-Visualisierung)« ist SOLL-Posten; F-07 deckt nur den Tabellen-/Ranking-Emitter, kein Diagramm. (2) Der Regenerierungs-Weg. Am Objekt geprueft: das Thesis-Repo traegt bis heute generate_measurement_appendix.ps1, generate_wide_appendix.ps1, build.ps1, build_all.ps1 und tools/format_tex.py, und anhang/de/A_measurements.tex:4 nennt die .ps1 als Erzeuger der Tabellen. Das ist der Behelfsweg auf dem Lieferpfad, den die Doktrin verbietet (kein Python in der Buildchain, keine Behelfswege) — im Plan taucht weder die Verdrahtung measure→08_appendix_generator→anhang/tabellen→PDF (#24 Inc 2) noch die .ps1-Abloesung (#25) auf.

### E6 · Linse: abhaengigkeiten

**Stelle:** W0, Zeile "Abhaengigkeit nach aussen: keine" + W0.1 (ce Makefile:83-86)

**Warum:** Am Objekt falsch, und zwar doppelt. (1) `git cat-file -e development:Makefile` -> "exists on disk, but not in 'development'": die Datei, die W0.1 heilen soll, existiert auf dem Integrationsbranch GAR NICHT. Sie lebt nur auf den bau/*-Branches. (2) Auf `bau/a9-s4-mess-report` ist W0.1 BEREITS GEHEILT, nur anders: dort steht `check: inventar` und `inventar: all` fuehrt `$(CMAKE) -S "$(SRCDIR)" -B "$(BUILDDIR)"` aus (Makefile:124-126) -- genau das Reconfigure, das W0.1 neu einziehen will. Der Arbeitsbaum (bau/doktrin-aufraeumung, b2daf9a6) traegt dagegen `check: all` ohne Reconfigure; das ist der Stand, den der Plan LIVE gemessen hat. W0.1 patcht damit ein Ziel, das ein ungemergter Branch schon anders umgeschrieben hat. Dasselbe fuer W0.2: der a9-s4-Branch aendert `.gitlab-ci.yml`, `Makefile` UND `configure.sh` (verifiziert per `git diff --name-only merge-base a9-s4`).

### E7 · Linse: abhaengigkeiten

**Stelle:** W1-S-A "A9-S4 landen (bau/a9-s4-mess-report -> development, 17 Dateien)" und An-4/An-5

**Warum:** Die Groesse ist um zwei Groessenordnungen falsch, und der Posten steht in der falschen Welle. Gemessen: `git rev-list --count development..bau/a9-s4-mess-report` = **82 Commits**; `git rev-list --count bau/a9-s4-mess-report..development` = **0** (development ist strikter Vorfahr); `git diff --stat merge-base a9-s4` = **386 Dateien, 95.770 Einfuegungen, 2.009 Loeschungen**. Der Branch traegt nicht nur A9-S4, sondern 274e4ed2 (build:clang), f7535751 (CWG 1430), 8945b5bd (GNU-Bauweg-CI), 61730ff4 (A9-S3), 39243183, 75ff9f89 -- also die Mehrzahl der heutigen ce-Landungen. Gegenprobe je Commit mit `merge-base --is-ancestor`: **KEINER der neun heutigen ce-Commits ist auf development**; 274e4ed2 / f7535751 / 8945b5bd / 61730ff4 sind auch NICHT auf bau/doktrin-aufraeumung. An-5 sagt richtig, dass der Arbeitsbaum sie nicht traegt, zieht daraus aber die falsche Konsequenz: das Problem ist nicht der Arbeitsbaum, sondern dass development sie ebenfalls nicht traegt und die einzige Landestrecke ein 82-Commit-Buendel ist.

### E8 · Linse: abhaengigkeiten

**Stelle:** W2 Abnahme 1: "Sechs paarweise verschiedene Kompilate -- nicht sechs Identitaeten", begruendet als Folge von W1-S-C (G3)

**Warum:** Mit G3 allein arithmetisch unerreichbar. `mess_achsen_naht.hpp` legt die Gate-Bedarfe am Objekt fest: "wallclock: braucht G1 ... macro: braucht G1+G2 ... micro: braucht G1+G2+G3". Das ist eine KETTE, keine unabhaengige Menge: micro setzt G2 weiter voraus. Erreichbare Gate-Zustaende nach dem G3-Split sind damit {} , {G1}, {G1,G2}, {G1,G2,G3} = **maximal 4 unterscheidbare Kompilate**, nicht 6. Der Plan bestaetigt das selbst in W-04 ("4 baubare Identitaeten, davon 2 byte-gleiche Gate-Zustaende") -- G3 trennt die beiden byte-gleichen, macht aus 4 Identitaeten 4 ECHTE, kommt aber nie auf 6. Die 6 aus dem SOLL sind eine "3-Fakultaet-PERMUTATION der Messgeraete" (Reihenfolge), das Gate-Modell liefert Teilmengen. Diese Definitionsluecke ist nirgends aufgeloest, wird aber in W2 zur harten, binaeren Abnahme am L2-Freitag gemacht.

### E9 · Linse: abhaengigkeiten

**Stelle:** R-1-Gegenmassnahme / W1-S-A: "verifiziert gegen den Archiv-Bestand (A9-S5), nicht gegen frische Daten" + W1-Abnahme "unzip -l zeigt 1 + |F| + |A| Blaetter"

**Warum:** Der Archiv-Bestand kann die entscheidende Haelfte nicht belegen. Einzige echte Mess-CSV im Repo: `docs/archiv/messdaten/20260606-fullpilot-320/tier150_measurements.csv`, 5.761 Zeilen, **134 Spalten**. Gezaehlt: `head -1 | tr ';' '\n' | grep -c '^op_'` = **0**. Die Funktions-Spalten `op_<art>_{n,p50_ns,p99_ns}` (kOpKindNames, cache_engine_builder_iterator.hpp:470-487) fehlen vollstaendig, ebenso `workload`, `two_phase_valid`, `series`, `pruefling_type`, `quality_flag`, `seg_framework_ns`, `seg_coverage`. Die xlsx-Blattform Fassung 3 (08.08.) ist aber genau "Sheets je FUNKTION bzw. je ACHSE" -- gegen dieses Archiv ist |F| = 0. Die Achsen-Blaetter (stat_*) waeren belegbar, die Funktions-Blaetter und "Aufrufer/Zeitpunkt als Zeilen" nicht. Damit traegt der als "groesster Parallelhebel des ganzen Plans" bezeichnete Schritt genau dort nicht, wo die neue Blattform lebt.

### E10 · Linse: abhaengigkeiten

**Stelle:** W1-S-D (--check-size) gegen W2-S-A ("golden-XML von 1 auf N Combos") und W2-S-C ("golden-XML auf die --check-size-Zahl"), sowie OV-4

**Warum:** Die Zahl, auf der die Frist-Rechnung und der Deckelungs-Entscheid ruhen, wird vor ihrer eigenen Multiplikation erhoben. Am Objekt: `experiment_golden_kern.xml:415-417` traegt genau EINE `<combo tools="wallclock macro micro"/>`, und der Kommentar direkt darueber (:405-415) beschreibt die Wirkung woertlich: "DREI separate Ein-Tool-Combos ... measurement_combos_of-Fanout N>1 ... Bau-Matrix-Folge: Tooling-Faktor 3 -> 1". `experiment_plan_director.hpp:1891-1895` bestaetigt es: je deklarierter <combo> EINE ceb:build-Strecke. W1 rechnet also gegen Faktor 1, W2-S-A stellt auf N zurueck. OV-4 ("Entscheid faellt an der W1-Abnahme, mit der Zahl auf dem Tisch") entscheidet damit ueber eine Zahl, die die naechste Welle planmaessig vervielfacht. Zusaetzlich arbeiten W2-S-A und W2-S-C als "parallele Spuren" gegenlaeufig an DERSELBEN XML-Sektion: die eine multipliziert die Mess-Menge, die andere friert sie auf die W1-Zahl ein.

### E11 · Linse: verifikation

**Stelle:** E.2 W5 ("die drei Inhalte sind im PDF") und W6 ("PDF baut, Anhang drin")

**Warum:** Das Schluss-Gate ist strukturell blind gegen den Inhalt. LIVE: thesis/anhang/de/A_measurements.tex bindet jede Messtabelle als \InputIfFileExists{...}{}{Ersatztext} ein (28 Eintraege, jeder mit eigenem Ersatztext, Kommentar Z.73: "kompiliert auch VOR dem ersten Messlauf sauber"). Das §7-Hard-Gate in thesis/.gitlab-ci.yml:80-83 prueft genau drei Dinge: latexmk -halt-on-error, LaTeX-Warnings <= 1, .blg ohne Repeated/Warning. KEINES davon zaehlt Tabellen. Ein PDF, in dem KEINE einzige Messtabelle steckt, baut mit 0 Fehlern und 0 Warnings gruen -- "Anhang drin" ist tautologisch wahr, weil der Ersatztext DER Anhang ist. Verschaerft durch die Naht davor: der Anhang-Generator ist honest-empty (Code/08_appendix_generator/appendix_generator.cpp:185 -- "axis_total == 0 -> status_empty_input: KEINE Datei"), und der Mess-Job faengt sein Scheitern ab: super .gitlab-ci.yml "$APP" ... || echo "appendix-generator: honest-empty/Teil-Output (n/a-Spalten) -- kein Fehler". Am Ende der teuersten Strecke des Plans steht damit ein fail-open-Glied und ein Gate, das es nicht sehen kann. Das ist Fall 3 des Tages (leere Anzeige, gruenes Verdikt) an der Abgabe selbst.

### E12 · Linse: verifikation

**Stelle:** E.2 W4 ("je Zelle Zeilenzahl > 0, im Exit-Code" und "Zellzahl == vom Planer angekuendigte Zahl")

**Warum:** Beide Bedingungen sind bei einem VOLLSTAENDIG gescheiterten Bau erfuellt. LIVE in cache_engine_builder_iterator.hpp: der Bau-Fehler-Zweig (if (!b.ok())) schreibt genau eine nicht_gebaut-Marker-Zeile, und zwar ausdruecklich als NEUE result.csv (:2421 "schreibt dieser Zweig die nicht_gebaut-Marker-Zeile als NEUE result.csv"), die dieselbe Zeile geht zusaetzlich "in die globale CSV" (:2424ff). Jede Zelle hat damit >0 Datenzeilen, die Spaltenzahl bleibt erhalten, und die Zellzahl stimmt exakt mit der Ankuendigung ueberein -- der Planer hat ja alle Permutationen angekuendigt, und alle haben eine Zeile. Eine Mess-Kampagne, in der KEINE EINZIGE Binary gebaut werden konnte, besteht die W4-Abnahme vollstaendig. Die Token-Liste existiert im Haus schon (measurement_curve_loader.hpp:72: n/a, failed, gesperrt, nicht_gebaut, -, ""), sie wird an der Abnahme nur nicht benutzt.

### E13 · Linse: verifikation

**Stelle:** W0.4 / E.2 W0-Zeile 4 (drift_detector, eingestuft als "blockiert-messung")

**Warum:** Die Wache, die hier geheilt wird, ist nirgends verdrahtet. LIVE-Zensus ueber alle *.hpp/*.cpp ausserhalb /build/: DriftVerdict, assess_drift und run_with_drift_gate kommen ausschliesslich in builder/commands/drift_detector.hpp selbst und in tests/unit/test_chaos_drift_gate.cpp vor -- NULL Produktions-Aufrufer. Die Einstufung "das einzige Drift-Gate laesst die kaputte Messung ohne Rerun durch" ist damit sachlich falsch: es laesst nichts durch, es laeuft nicht. Und die Abnahme ("Unit-Test: Verdict unbestimmbar") ist genau dann erfuellbar, wenn sich an der Messung nichts aendert -- ein neuer Enum-Wert ohne Leser. Das ist exakt die Klasse, die der Plan selbst als T-11 (kNoPinnedLocalityWarning: 3 Treffer, nie ausgegeben) und W-07 (conformance_passed: 0 Leser) fuehrt; er reproduziert sie in seiner eigenen ersten Welle.

### E14 · Linse: verifikation

**Stelle:** E.0 WACHEN-REGISTER (W0.6) -- das erklaerte strukturelle Gegenmittel

**Warum:** Das Register erbt den Defekt, gegen den es gebaut wird. (a) Der Nenner: "Der Job selbst hat einen Nenner (Anzahl gefundener Wachen) und bricht bei 0 ab" -- gefunden WO? Steht die Menge im Register, dann macht eine nicht eingetragene Wache den Job nicht rot, sondern nur kleiner. Das ist Fall 4 des Tages (die Handliste verschluckt zwei Tests, 429 gegen 431) eine Ebene hoeher. (b) Die Koeder-Felder: koeder_rot, koeder_gruen und gate_vollzug sind Markdown-Textfelder. Ein CI-Job kann Nichtleere pruefen, nicht Echtheit. K13 ("der Koeder muss erst beissen, zufaellig erzeugen, nie aus einer Doku abschreiben") ist gegen ein Textfeld nicht durchsetzbar -- ein abgeschriebener Koeder-Beleg und ein echter sehen im Register identisch aus, woertlich die Schwester-Formel des Tages. (c) Die Sanktion "Eine Abnahme, die eine nicht registrierte Wache zitiert, ist ungueltig" hat keinen Vollzieher; sie ist eine Selbstauskunft. Zur Groessenordnung: die Grundmenge ist heute klein und maschinell erhebbar -- ce scripts/ = 8 .sh, super scripts/ + ci/ = 5 .sh, dazu 28 (ce) + 30 (super) Top-Level-CI-Schluessel.

### E15 · Linse: verifikation

**Stelle:** E.2 W2, Abnahmepunkt 3 ("Kein Paket mehr offen, das ein Fingerprint-Preimage-Glied beruehrt (Liste aus W1)")

**Warum:** Das ist ein Vollstaendigkeitsurteil ueber eine in W1 von Hand geschriebene Liste -- an genau dem Posten, den der Plan selbst als bestandsvernichtend beschreibt (R-2: ein Bump nach dem 28.08. vernichtet den kompletten Binary-Bestand und damit das Zeitfenster). Ist die Liste um ein Glied zu kurz, meldet W2 Vollstaendigkeit, W3 friert ein, und der Bruch faellt erst im Voll-Lauf auf. Dabei ist der Nenner maschinell verfuegbar und musste nicht geraten werden: abi/anatomy_fingerprint.hpp fuehrt kAnatomyFingerprintGliedCount = 9 (:416) mit benannten Indizes (System 2, Toolchain 5, Bvset 6, Overlay 7, MessGates 8) -- die Preimage-Glieder sind eine geschlossene, im Code abzaehlbare Menge.

### E16 · Linse: frist

**Stelle:** Abschnitt C, Wellen-Zeitraster W0–W6 ("Rueckwaerts gerechnet (bindend)")

**Warum:** Der Plan verplant EXAKT 27 von 27 Werktagen und benennt kein Puffer-Budget. LIVE nachgerechnet (python3 über die Wellen-Datumsspannen des Plans): W0=1, W1=4, W2=5, W3=5, W4=5, W5=5, W6=2 → Summe 27; verfuegbar 27. Der Auslastungsgrad ist 100,0 %. Die einzige reale Reserve sind die fuenf unverplanten Wochenenden (10 Tage) — und W0 verbraucht davon bereits eines (Sa 08.08. + So 09.08.), ohne dass der Plan das als Reserve-Entnahme ausweist. Damit gibt es kein Ausfallbudget fuer ein Projekt, das heute 39 bekannte Regressionen fuehrt und dessen eigene Aufraeum-Zaehler nachweislich WACHSEN (Plan R-3: ASCII 1132→1160, Prosa 29→54, organ_location 79→97, "heute gemessen"). Jeder Verzug von einem Tag frisst nicht Puffer, sondern die naechste Welle. Besonders hart trifft das W5: es ist die letzte Lieferwoche UND die einzige Welle mit einer vom Plan selbst eingestandenen inhaltlichen Vorbedingung (Messdaten aus W4). Ein W4-Verzug von zwei Tagen halbiert W5.

### E17 · Linse: frist

**Stelle:** OV-4 ("Mess-Menge gegen das Fenster") in Verbindung mit W2 Spur S-C ("Mess-Menge fixieren: golden-XML auf die --check-size-Zahl")

**Warum:** Die Deckelung ist NICHT eine Option unter mehreren — sie ist die einzige verbliebene Stellschraube, und ihr Mechanismus existiert nicht. Drei Wege sind am Objekt verschlossen: (1) Mehr Threads: ausgeschlossen, die Thesis bindet es im Praesens — kapitel/de/05_evaluation.tex:133-134 "misst der Mess-Modus mit genau EINEM Mess-Thread". (2) Zweite Lane: physisch nicht vorhanden (siehe eigener Einwand). (3) Guenstigere Messung: 0,1094 s ist laut eigener Quelle ausdruecklich eine UNTERGRENZE. Bleibt nur die Mengen-Deckelung. Deren Traeger waere die XML-Trennung von Bau-Material und Mess-Menge — und die ist LIVE nicht vorhanden: grep 'measure_selection|measurement_selection' liefert in BEIDEN Repos 0 Treffer (ce und super, *.hpp/*.cpp/*.xml/*.xsd). Der einzige heute existierende Weg ist eine separate XML-Datei — und genau den verwirft die projekteigene Analyse als Prinzipverstoss (GESAMTDOSSIER:2591-2594, R-2: 'eine unabhaengige zweite Menge koennte auf nie gebaute Binaries zeigen = Fingerprint-Prinzip-Verstoss'). Bestaetigt durch den Kommentar im golden-XML selbst (super Code/test_data_xml/experiment_golden_kern.xml:410-414): 'Getrennte Lanen bzw. Teilmengen bleiben XML-Recht ..., sind aber NICHT der golden-Default'. Der Plan behandelt OV-4 als Entscheid ('Entscheid faellt an der W1-Abnahme, mit der Zahl auf dem Tisch') — es ist aber ein BAU-PAKET (Planer + XML-Schema + Validator + strukturelle Teilmengen-Garantie), das in keiner Welle steht. Und es beruehrt den Fingerprint, muss also VOR dem W3-Freeze landen. Verschaerfend: Owner-Entscheid D-3 sagt 'Bau-Menge folgt der Mess-Menge' — ohne den Mechanismus weiss auch der W3-Bau nicht, was er bauen soll.

### E18 · Linse: frist

**Stelle:** Annahme An-1 ("prod1/prod2 stehen fuer W3/W4 zur Verfuegung") und W3 Spur S-C / W4 Spur S-A

**Warum:** An-1 ist nicht bloss ungeprueft — sie ist am Objekt FALSCH, und die Thesis sagt das Gegenteil im Praesens zu. LIVE auf dieser Maschine: hostname=prod1, CPU=AMD Ryzen 9 9950X3D (32 Threads); 'ping -c1 -W2 prod2' → 'Name or service not known'; 'getent hosts prod2' → rc=2. Es gibt genau eine Lane. Der Plan uebernimmt die Nichtexistenz nirgends: keine Welle enthaelt 'prod2 herstellen', und W3/W4 rechnen implizit mit zwei Lanes. Die Folgen sind quantifizierbar: die Bau-Zahl '~34,4 h Wanduhr' (GESAMTDOSSIER:2571-2574) gilt fuer ZWEI Lanes mit Engpass intel; prod1 allein (amd, 19,4 min je 4096er-Scheibe x 128 Scheiben) ergibt ~41,4 h — das passt noch in W3, ist also NICHT der Bruch. Der Bruch liegt in der Abgabe-Aussage: kapitel/de/05_evaluation.tex:78-82 behauptet im Praesens 'Der produktive Mess-Betrieb selbst ist ein Zwei-Maschinen-Betrieb --- eine AMD-Maschine (Ryzen 9 9950X3D) neben einer Intel-Maschine (Core i9-12900K, Alder Lake)', fuehrt 'zwei getrennte Hersteller-Lanes (AMD und Intel), die hart gegatet sind' und schliesst woertlich: 'eine stille Teil-Messung nur eines Herstellers gibt es nicht'. Dazu :76: 'auf Hybrid-CPUs werden P- und E-Cores getrennt vermessen (ueber cpu_core und cpu_atom)' — der 9950X3D hat keine E-Cores, der i9-12900K ist die Hybrid-CPU, und er fehlt. Damit haengt auch der Plan-Posten F-10/S-04 (P/E-Core-Trennung, U-06 pmc:intel) an nicht vorhandener Hardware. Wird ohne prod2 gemessen, enthaelt die Abgabe genau die Aussage, die der eigene Text ausschliesst.

### E19 · Linse: frist

**Stelle:** W4 ("MESSUNG", Mo 31.08.–Fr 04.09.) und die Abnahme-Zeile "je Zelle > 0 Datenzeilen im Exit-Code"

**Warum:** W4 hat kein Wiederaufnahme-Korn — und die Thesis behauptet im Praesens, es gaebe eines. Beleg fuer die Luecke: GESAMTDOSSIER:2589 (R-2, Zweitbefund) woertlich: 'der MESS-Batch faehrt das VOLLE Fenster in EINEM Treiber-Aufruf je Perm - die 4096er-Owner-Vorgabe gilt woertlich fuer "compile und Messung", die Mess-Seite erfuellt sie NICHT (kein Wiederaufnahme-Korn; jeder Abbruch verloere Wochen).' Der Plan enthaelt in KEINER Welle ein Paket dafuer; seine einzige Resume-Abnahme steht in W3 und betrifft den BAU ('built_new==0', 'lager_skip==N'). Das trifft auf ein 5-Tage-Fenster, in dem der empfohlene flache Voll-Lauf allein ~3 Tage dauert (GESAMTDOSSIER:2566-2567, Empfehlung C), auf derselben Maschine, die den GitLab-Runner traegt (Memory: 'der Runner laeuft auf DIESER Platte') und die LIVE 35 von 60 GB RAM belegt und deren / zu 80 % voll ist. Ein einziger Abbruch am Tag 2 kostet die gesamte Welle — und W5 haengt daran. Der Abgabe-Schaden ist konkret: kapitel/de/05_evaluation.tex:139-142 sagt im Praesens 'Bau- wie MESS-Laeufe werden je Maschine in Meilenstein-Batches von je 4096 Binaries am Stueck abgearbeitet, mit gleichverteilter Zuteilung der gemeinsam baubaren Binaries ueber die Maschinen und inventarisierter Wiederaufnahme nach Unterbrechung.' Drei Zusagen in einem Satz, die der Code auf der Mess-Seite nicht haelt: 4096er-Korn (nein), Verteilung ueber die Maschinen (nur eine Maschine), Wiederaufnahme (kein Korn).

### E20 · Linse: frist

**Stelle:** Fehlende Streich-Reihenfolge — der Plan benennt kein "was faellt zuerst"

**Warum:** Der Plan hat Fallbacks fuer Einzelposten (R-1 CSV-Notlinie, OV-2 checkpoint_measure nach W7, OV-3 Hybrid nach W7), aber keine geordnete Streichliste fuer den Fall, dass die Zeit global reisst. Die Unterscheidung, auf die es ankommt, laesst sich am Objekt treffen und faellt anders aus als die Plan-Gewichtung. STREICHBAR ohne Falschaussage, weil die Thesis darueber heute NICHTS behauptet: (a) Break-Even/B-Spline und die LaTeX-Auswertungs-Anlage — LIVE 0 Treffer 'Break-Even' und 0 'B-Spline' in kapitel/; es waere eine fehlende Leistung, keine falsche Aussage. (b) Der Hybrid — hier hat der Text bereits vorgesorgt: 05_evaluation.tex:153-154 sagt ausdruecklich 'da die zugehoerigen Messlaeufe noch ausstehen, ist er ... im FUTUR formuliert'; OV-3(a) ist damit sachlich gut begruendet, was ich bestaetige. (c) checkpoint_measure — der Owner-KERN selbst sagt 'SPEZIFIZIERT, NICHT GEBAUT'. NICHT STREICHBAR, weil der Text es im PRAESENS zusagt: (1) der Zwei-Maschinen-/Zwei-Vendor-/P-E-Core-Betrieb (:76-82), (2) die 4096er-Mess-Batches mit Verteilung und Wiederaufnahme (:139-142), (3) 'vor jeder Messung steht die Konformitaetspruefung am Pruef-Dock' (:137-138) — LIVE bestaetigt fuer den ce-Pfad (perm_runner.hpp:196,:289 kehren bei !conformance_passed zurueck), aber NICHT fuer den super-Katalog-Treiber (v32_katalog_driver.hpp:128,:152,:154 schreiben das Feld nur, es gibt keinen Leser als Gate). Diese drei sind entweder zu erfuellen oder im Text zurueckzunehmen; still fallenlassen macht die Abgabe unwahr.

