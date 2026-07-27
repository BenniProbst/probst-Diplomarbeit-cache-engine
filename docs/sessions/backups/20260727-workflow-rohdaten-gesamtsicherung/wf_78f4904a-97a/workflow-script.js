export const meta = {
  name: 'registry-angebot-anwender-xml-resolver-stufe',
  description: 'Zusatz-Planungsstufe fuer den Planer: Registry=ANGEBOT (CE-interpretierbare XML-Bibliothek je Achse) / Anwender-XML=ANZEIGE (.pom-artiges deklaratives Manifest) / Planer=Resolver-Linker — Ist-Analyse, Design, Bauplan-Integration, adversariale Kritik',
  phases: [
    { title: 'Ist', detail: 'Registry-Format + heutiges Linking (validate_profile) + Gaps' },
    { title: 'Design', detail: 'POM-Resolver-Modell mit benannten Patterns' },
    { title: 'Integration', detail: 'Einordnung in den Planer-Bauplan + Migrations-Pfad' },
    { title: 'Kritik', detail: 'keine Parallelstruktur, CT-Doktrin, Vollstaendigkeit' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const PRT = SUP + '/Code/external/comdare-prt-art'
const PLA = SUP + '/docs/plaene'
const DOC = PLA + '/20260719-registry-angebot-anwender-xml-resolver-STUFE.md'

const DIREKTIVE = 'USER-DIREKTIVE (Ledger §27, verbatim-treu): Die Registries muessen so aufgebaut sein, dass der Experiment-Planer die waehlbaren Optionen je Achse aus dem ANGEBOT parsed als XML-Bibliothek, sodass diese ERST NACH REGISTRIERUNG in der XML des Anwenders erkannt und korrekt verlinkt werden koennen. Die Registry enthaelt ein Format, das die CacheEngine fuer das ANGEBOT des Compiles interpretieren kann; die Anwender-XML ZEIGT AN, welche Experimente, Achsen, Einstellungen, Flags, Unter-Achsen (VOLLER Support) und Ablaeufe+Ranges durchzufuehren sind. Modell: mini-Python-Interpreter auf nativer XML-Basis, viel eher aehnlich zu einer Java .pom (deklaratives Manifest + Dependency-Resolution gegen Repository). Zweck: zusaetzliche Planungs-Stufe, um den Planer endlich zu ueberarbeiten und zu bauen.'

const DOKTRIN = 'DOKTRIN: KEINE Parallelstruktur — an validate_profile.hpp + xml_config_parser andocken, keinen zweiten Validator/Parser daneben. Resolver laeuft Planer-/Configure-Zeit (compile-time-Doktrin, kein Runtime-Switch im Hot-Path), KEIN Python. Nur benannte Patterns (GoF/MOF). 2 Registry-Bibliotheken je Engine: cache_engine_axis_registry.xml + prt_art_axis_registry.xml (feedback_unified_experiment_xml_plus_system_registry_xml); Registry-Pfade per CMake-Interface statisch (feedback_ceb_config_cmake_interface_static_registry_paths_prt_module). Organ-Achsen->binary_id; System/Mess NIE binary_id. Unregistriertes Element = harter, klassifizierter Validierungsfehler (Fehlerklassen-Doktrin, kein stilles Verhalten). Haupt-Achse CT-statisch, Unter-Achse runtime (stufen-relativ). Bestehender Planer-Bauplan: docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md (Phase-0-v32-Reconcile-Blocker: super 02_messung_driver/v32_messreihe_antrieb.hpp execute_messreihe-Stub WIEDERVERWENDEN). Golden-Neutralitaet ausweisen.'

phase('Ist')
const ist = await agent(
  `IST-ANALYSE: wie werden die Registries HEUTE geparst/verlinkt, und was fehlt fuer das volle ANGEBOT? Lies GRUENDLICH: (1) ${CE}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml VOLL (das heutige Angebots-Format: welche Elemente/Attribute je Achse — axes? variants? enabled? sub_axes? flags? versions?) (2) ${PRT}/prt_art/algorithm_profiles/prt_art_axis_registry.xml VOLL (3) ${CE}/libs/cache_engine/builder/experiment_tree/validate_profile.hpp VOLL (das heutige Linking: welche Anwender-XML-Referenzen werden gegen die Registry aufgeloest — Achsen-ids? Werte? Was wird NICHT geprueft?) (4) ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.hpp (welche Structs tragen Registry- vs Anwender-Daten; parse_thesis_profile vs parse_experiment_profile; registry_dir/known_workload_ids-Kanal) (5) grep -rn 'registry' ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (wie die Fassade Registry-Pfade injiziert; CMake-gebackene Pfade) (6) ${CE}/tools/axis_registry_gen (der Registry-GENERATOR — wird das Angebot aus dem Code erzeugt? golden_wired-Hartkodierung!). ERGEBNIS als Markdown-Abschnitt: (A) heutiges Registry-Schema (Element-Tabelle) je Bibliothek; (B) heutige Link-Punkte (was validate_profile auﬂoest, datei:zeile); (C) GAP-Liste gegen die Direktive: was das ANGEBOT heute NICHT ausdrueckt (Unter-Achsen-Vollsupport? Flags je Variante? Ranges? Ablaeufe? System-Achsen-Angebot? algo_version im Angebot?) + was die Anwender-XML heute NICHT anzeigen kann; (D) wo heute Code-Wahrheit an der Registry VORBEI laeuft (EnabledStrategies mp_list = zweite Wahrheit! KaryPerKCatalog-Bypass!) — die Single-Source-Frage Registry vs Code. ${DIREKTIVE} ${DOKTRIN}`,
  { label: 'ist-registry-linking', phase: 'Ist' }
)

phase('Design')
const design = await agent(
  `DESIGN der Resolver-Stufe (.pom-Modell). Basis Ist-Analyse:\n${ist}\n\n${DIREKTIVE} ${DOKTRIN}\n\nEntwirf als Markdown: (A) **Angebots-Schema v2** je Registry-Bibliothek (XML-Elemente: je Achse -> Varianten mit name()+algo_version+flags(+Compiler-Dialekt)+Unter-Achsen mit eigenen Options/Wertesets+Ranges-Faehigkeit+Gattungs-Zugehoerigkeit; System-Achsen-Angebot compiler/opt/simd/target_isa; PRT-ART-Bausteine analog) — dabei die SINGLE-SOURCE-Frage entscheiden/als Fork vorlegen: Registry generiert AUS dem Code (axis_registry_gen ausbauen, Code=Wahrheit) vs Registry als Hand-Wahrheit mit CI-Diff-Guard gegen EnabledStrategies. (B) **Anwender-XML-Schema** (die ANZEIGE): Experimente/Phasen/Achsen-Selektion/Einstellungen/Flags/Unter-Achsen/Ablaeufe+Ranges — mit .pom-Semantik (deklarativ, referenziert NUR Registriertes; Range-Syntax fuer Sweeps; Ablauf=Phasen/MergeStrategy-Ordnung). (C) **Resolve/Link-Phase im Planer** mit BENANNTEN Patterns: Interpreter (Anwender-XML), die Registry-Bibliothek als Katalog (welches benannte Pattern — Repository/Flyweight-Factory begruenden), der Link-Schritt als Symbol-Resolution (Analogie Dock-Loader: unaufloesbare Referenz = harter klassifizierter Fehler wie fehlendes dlopen-Symbol); Fehlerklassen-Zuordnung (Validierungs- vs Infra- vs CompilerCompiler); Ausgabe der Resolve-Phase = der gelinkte ExperimentPlan (Input fuer Director/IPlanBuilder aus dem Bauplan). (D) Verhaeltnis zu CT: Resolver=Configure-Zeit; die gelinkte Auswahl wird CT-Draht der Folgestufe (stufen-relativ). (E) Was mit den heutigen 2 Wahrheiten passiert (validate_profile erweitern, adhoc-known-ids-Kanaele konsolidieren).`,
  { label: 'resolver-design', phase: 'Design' }
)

phase('Integration')
const integration = await agent(
  `INTEGRATION in den Planer-Bauplan + SCHREIBEN des Ergebnis-Dokuments. Lies ${PLA}/20260719-planer-ceb-tier-topdown-BAUPLAN.md VOLL. Fuege Ist-Analyse + Design zusammen und SCHREIBE mit Write nach ${DOC} das vollstaendige Stufen-Dokument: (1) Kopf mit Direktive (§27) + Einordnung; (2) IST (aus unten); (3) DESIGN (aus unten); (4) INTEGRATION: WO die Resolver-Stufe im Bauplan sitzt (Vorschlag: Phase 1-I0/I1 — der Interpreter-Baustein des Bauplans WIRD der Resolver: Registry-Angebots-Parse -> Anwender-Parse -> Link -> ExperimentPlan an Director; Phase-0-v32-Reconcile davor bleibt; die 2 ConcreteBuilder konsumieren den GELINKTEN Plan), welche bestehenden Increments sich dadurch aendern/verfeinern, Migrations-Pfad der bestehenden Registries+Profile (additiv, golden-neutral: heutige XMLs bleiben parsebar bis Schema v2 aktiv), Verifikations-Kriterien je Schritt (Negativ-Test: unregistriertes Element -> klassifizierter Fehler; Positiv: m3v2+all_axes_golden linken sauber); (5) FORKS fuer User-GO (Single-Source Registry-gen-aus-Code vs Hand+Guard; Range-Syntax-Umfang; Schema-v2-Fenster). Ist-Analyse:\n${ist}\n\nDesign:\n${design}\n\n${DIREKTIVE} ${DOKTRIN} Return: kompakte Zusammenfassung (Datei traegt den Inhalt).`,
  { label: 'integration-schreiben', phase: 'Integration' }
)

phase('Kritik')
const kritik = await agent(
  `ADVERSARIALER KRITIKER. Lies ${DOC} VOLL. Pruefe hart gegen den Live-Code: (a) Dockt das Design WIRKLICH an validate_profile/xml_config_parser an oder entsteht ein Parallel-Validator/-Parser (grep die genannten Andockpunkte)? (b) Ist die Single-Source-Frage ehrlich als Fork vorgelegt (nicht still entschieden)? (c) CT-Doktrin: laeuft der Resolver strikt Configure-/Planer-Zeit, keine CT->RT-Degradierung? (d) Kollidiert die Stufe mit dem Phase-0-v32-Reconcile-Blocker oder dem Dock-Muster des Bauplans? (e) Golden-Neutralitaet des Migrations-Pfads belegt (heutige m3v2/all_axes_golden bleiben gueltig)? (f) Unter-Achsen-VOLLER-Support + Flags + Ranges + Ablaeufe wirklich abgedeckt (gegen §27-Wortlaut)? (g) Fehlerklassen-Zuordnung konsistent mit axis_error.hpp? Verifizierte Korrekturen direkt per Edit in ${DOC} einarbeiten (als KORREKTUR-Vermerk, additiv) + berichten. Max 10 Punkte.`,
  { label: 'kritik', phase: 'Kritik' }
)

return { ist_kurz: ist.slice(0, 1500), design_kurz: design.slice(0, 1500), integration, kritik, dokument: DOC }
