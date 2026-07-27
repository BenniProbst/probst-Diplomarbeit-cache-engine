export const meta = {
  name: 'welle1-golden-neutrale-pakete',
  description: 'Welle 1 der Parallelisierungs-Analyse: 5 dateidisjunkte golden-neutrale Code-Pakete (ce-Quick-Wins+ABI-Guard, super-CI/build-i2, Planer-Phase-0-super, LaTeX-17er-Nachzug, golden-N-Vorbau) — Edits ohne Commits, serielle Verifikation danach',
  phases: [
    { title: 'Bauen', detail: '5 Paket-Agenten parallel (dateidisjunkt)' },
    { title: 'Review', detail: 'Kreuz-Review der Edits gegen Doktrin' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const ROADMAP = SUP + '/docs/plaene/20260719-gesamt-roadmap-ledger-diff-ROADMAP.md'
const ANALYSE = SUP + '/docs/plaene/20260719-parallelisierung-disjunkte-pakete-ANALYSE.md'
const SCR = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad'

const REGELN = 'BINDENDE REGELN fuer jeden Paket-Agenten: (1) Lies ZUERST deine Item-Definitionen in der ROADMAP (' + ROADMAP + ') + deine Paket-/Flaechen-Definition in der ANALYSE (' + ANALYSE + ') — die sind autoritativ, nicht dieser Prompt. (2) NUR deine Paket-Flaeche anfassen (dateidisjunkt; die Hotspot-Owner-Regeln der ANALYSE gelten). (3) KEINE git-Commits (der Orchestrator committet seriell nach Gesamt-Verifikation; K-2 wird als ERSTER isolierter Commit ausgewiesen). (4) KEINE Builds in build-conf/build-i2 (Lock-Konflikt mit Parallel-Agenten) — verifiziere per targeted g++-16 UND clang++ -std=c++23 -fsyntax-only mit eigener Scratch-TU unter ' + SCR + '/<paket>/ (Include-Roots: -I' + CE + '/libs/cache_engine -I.../libs/cache_engine/src -I.../libs/cache_engine/include -I' + CE + '/cmake/third_party/boost_mp11/include -I' + CE + '/build/generated + alle build/generated-Flags-Dirs wie noetig) — LITERALE Compiler-Ausgabe in den Report. (5) Code-Kommentare im ASCII-Stil der Umgebung (fuer/Huelle/ae-ue-oe), KEIN Mojibake. (6) golden/ABI-neutral: golden_fullpilot/CatalogAxes/kCompositionAxisNames/PODs NICHT anfassen (Ausnahme: K-2 fuegt NUR einen static_assert ANS Ende des PODs an — layout-neutral). (7) Nur benannte Patterns, compile-time-Doktrin, kein std::variant, kein Python. (8) Neueste Fakten: 17 Organ-Slots/ABI-6/sizeof-1272/V7; TargetIsa=7. System-Achse; Ledger §30/§31 (Planer=Mess/CEB=System/Tier=Organ+Hybrid-PFLICHT). (9) Wenn ein Item sich als NICHT golden-neutral oder GO-pflichtig entpuppt: NICHT bauen, als uebersprungen melden mit Grund.'

const REPORT_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    paket: { type: 'string' },
    edits: { type: 'array', items: { type: 'object', additionalProperties: false, properties: {
      datei: { type: 'string' }, item: { type: 'string' }, was: { type: 'string' } }, required: ['datei','item','was'] } },
    verifikation: { type: 'string', description: 'LITERALE Compiler-/Check-Ausgaben' },
    uebersprungen: { type: 'array', items: { type: 'string' } },
    commit_vorschlag: { type: 'array', items: { type: 'string' }, description: 'granulare Commit-Schnitte in Reihenfolge' },
  },
  required: ['paket','edits','verifikation'],
}

phase('Bauen')
const pakete = [
  { label: 'A-ce-kern', prompt: 'PAKET A (ce-Kern-Quick-Wins, Owner aller ce-libs-Kommentar/Guard-Flaechen): Setze aus der ROADMAP die Items K-2 (static_assert(sizeof(ComdareTierObserverSnapshot)==1272) direkt am Struct anatomy/observable_tier.hpp — ERSTER isolierter Commit-Schnitt, layout-neutral, NUR anfuegen), K-5 (Slot-Zahlen-Sweep stale 19/18/15/11/7 -> 17/13/9/5 in Kommentaren+inerten Konstanten inkl. kSetCompositionSlotCount=15->13 + tests/unit/test_d9_set.cpp:38-static_assert), K-6 (Loader anatomy_module_loader.cpp:138 auf benannte host_compatible_with() umstellen), K-7 (all_axes_binary_count -> all_axes_matrix_count Rename in registry_to_axis_levels.hpp + ALLE Referenzen repo-weit greppen inkl. source_catalog.hpp:137-Kommentar + test_br1_full22_count.cpp — Patch-an-Owner-Regel E-1 der ANALYSE beachten), K-10 (SampleStatus-n/a-Zell-Renderer cache_engine_builder_iterator.hpp:382-388 ueber das Enum axis_error.hpp statt unified_real-Literalpfad — NUR wenn laut Roadmap golden-neutral ohne CSV-Byte-Aenderung im golden-Pfad; sonst ueberspringen+Grund) und K-13/K-14 (Definition aus der Roadmap lesen; wenn nicht golden-neutral -> ueberspringen). Verifiziere JEDEN beruehrten Header per Scratch-TU beide Compiler -fsyntax-only, fuer K-2 zusaetzlich eine TU die sizeof static_assert-et.' },
  { label: 'B-super-ci', prompt: 'PAKET B (super-CI/build-Tree, Owner super/.gitlab-ci.yml + build-i2-Config): Items K-4 (der build-i2 generated-Include-Root-Gap: test_experiment_projection gruen in ce build-conf aber rot in super build-i2 — finde die super-Sub-Build-CMake-Config-Stelle, die den generated-Include-Root falsch setzt (§20.D-B2/B4, Ledger:1597 Nebenbefund) und fixe sie; die 3 stale-roten build-i2-Tests smoke/measurement/wdk ebenfalls pruefen — wenn der Fix sie gruen macht, dokumentieren; ACHTUNG: baue NICHT in build-i2 selbst, sondern konfiguriere einen EIGENEN Scratch-Build-Tree ' + SCR + '/b-super-ci/build-verify NUR fuer die betroffenen Targets und beweise dort) + K-12 (CI-Kommentar-Drifts in super/.gitlab-ci.yml laut Roadmap, z.B. appendix-16-vs-12+5-Drift — reine Kommentare). Du bist der EINZIGE Agent mit super/.gitlab-ci.yml- und CMake-Config-Ownership.' },
  { label: 'C-planer-phase0', prompt: 'PAKET C (Planer-Phase-0 super-seitig, Owner super Code/02_messung_driver): Item PL-0 aus der ROADMAP — der Phase-0-Reconcile VORBEREITEND und golden-neutral: (a) Deprecation-/Wiederverwendungs-BANNER auf v32_messreihe_antrieb.hpp + v32_orchestrator.hpp praezisieren (Antrieb:259 execute_messreihe = VOLL implementierte INC-G+H-Kette, INERT via main.cpp:339-Opt-in, WIRD wiederverwendet als Planer-Phasen-Walk-Substrat; Orchestrator:92 = der return-0-Stub; NICHT neu schreiben, kein dritter Walk — Ledger §29-Praezisierung + §30-Stufen-Zuordnung Planer=Mess referenzieren), (b) PL-4 nur falls die Roadmap ihn golden-neutral in Welle 1 legt: <metadata><mode>-Konsum im offiziellen Pfad (main.cpp) statt stillem env-Override — wenn das Verhaltens-Aenderung im golden-CI-Pfad bedeutet: NUR die Vorbereitung (Parser liest + loggt, Verhalten unveraendert) oder ueberspringen mit Grund. ce ist fuer dich READ-ONLY.' },
  { label: 'D-latex-17er', prompt: 'PAKET D (super LaTeX-/Auswertungs-Stufen, Owner super Code-Stufen 04/05/08): Item M-4 aus der ROADMAP — den 17-Achsen-Nachzug der Auswertungs-Stufen (Stufe 04/05/08, appendix/seg_attribution): hartkodierte 19/18/20-Zaehlungen (z.B. kSegmentCount=20, B16 des KATALOGs) auf die EINE Quelle kV3AxisCount=17 ziehen (Single-Source-Include statt Literal), damit seg_attribution nach dem Messlauf ueberhaupt erzeugt wird. NUR die super-seitigen Stufen-Quellen (Code/04*, Code/05*, Code/08* bzw. wo die Roadmap sie verortet); Thesis-Haupt-.tex NICHT anfassen (GO-pflichtig). Scratch-TU-Verifikation beide Compiler.' },
  { label: 'E-goldenN-vorbau', prompt: 'PAKET E (ce golden-N-Vorbau, Owner validate_profile/profile_run_facade/measurement-Achsen-Header): Items GN-1 (aktiver extension_hardware-Familien-Knoten: neuer CebSystemAxis mit axis_label()=="extension_hardware" analog CompilerSystemAxis, sodass SimdSubAxis.parent_axis_label aufloest — DEPRECATED-F-SIMD-Insel NICHT reaktivieren; Audit-G2/E-4), GN-2 (Anti-Voll-Materialisierungs-Guard an der Katalog-Naht: negativer Instanziierungs-Guard/static_assert der verhindert dass generated_source_catalog je die 2^17-Vollform materialisiert — Kritik-9 des Registers; Roadmap-GN-2-Definition lesen, source_catalog.hpp:153-167-Verbots-Kommentare respektieren), GN-5 (NEUER ctest test_reflect_versions_all17: Instanziierungs-Test der build_axis_variant_version_table ueber ALLE 17 Achsen als Default-ctest — der L2-Stale-Skip-Guard, verhindert die #50-Klasse fuer immer; tests/unit/CMakeLists.txt-Registrierung im da-ueblichen Muster + COMDARE_TEST_TARGETS). Scratch-TU beide Compiler; fuer GN-5 die Test-TU selbst als Beweis.' },
]
const reports = await parallel(pakete.map(p => () => agent(REGELN + '\n\n' + p.prompt, { label: p.label, phase: 'Bauen', schema: REPORT_SCHEMA }).catch(() => null)))
const ok = reports.filter(Boolean)
log('Welle-1-Pakete fertig: ' + ok.length + '/5')

phase('Review')
const review = await agent(
  'KREUZ-REVIEW der Welle-1-Edits (KEINE Commits erfolgt; alles liegt als Working-Tree-Aenderungen in ' + SUP + ' + ' + CE + '). Paket-Reports (JSON):\n' + JSON.stringify(ok) + '\n\nPruefe per git diff (beide Repos) + gezieltem Lesen: (a) Flaechen-Disjunktheit eingehalten (kein Paket hat fremde Dateien beruehrt; Hotspot-Regeln der ANALYSE ' + ANALYSE + ')? (b) golden/ABI-Neutralitaet (kein TABU beruehrt; K-2 nur additiver static_assert)? (c) Mojibake-grep (echte Muster) == 0 auf allen geaenderten Dateien? (d) Doktrin (benannte Patterns, CT-only, ASCII-Kommentare)? (e) Uebersprungene Items korrekt begruendet? Gib zurueck: Verdikt je Paket (OK/NACHBESSERN mit konkreter Stelle) + die empfohlene granulare Commit-Reihenfolge (K-2 zuerst isoliert) + welche ctest-Targets die serielle Gesamt-Verifikation mindestens fahren muss.',
  { label: 'kreuz-review', phase: 'Review' }
)

return { reports: ok, review }
