export const meta = {
  name: 'planer-ceb-tier-topdown-bauplan',
  description: 'Top-down-Bauplan der rekursiven Dock-Kette Experiment-Planer -> CEB(Mess+System-Achsen) -> Tier-Binaries: SOLL (Ledger recursive-dock + Design-Doc) vs IST (Live-Code) -> phasierter Bauplan vom Kopf, architektur-konform, adversarial gepr.',
  phases: [
    { title: 'Kartieren', detail: 'SOLL + IST + Pattern parallel lesen' },
    { title: 'Bauplan', detail: 'Top-down-Synthese vom Kopf' },
    { title: 'Kritik', detail: 'architektur-konform + kein Parallelbau' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUP + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const AUD = SUP + '/docs/audits/20260718-ketten-konformitaets-audit-planer-ceb-tier-REPORT.md'
const PLA = SUP + '/docs/plaene'
const ARCH = SUP + '/docs/architektur'
const CE = SUP + '/Code/external/comdare-cache-engine'

const DOCTRIN = 'DOKTRIN (bindend): rekursive Dock-Topologie 2 Ebenen (Planer<->CEB und CEB<->Tier), jede ABI-stabil + expliziter Vertrag (feedback_recursive_dock_planer_ceb_tier_abi_stable_so). NUR benannte GoF/Metaprog-Patterns (Director/Builder/Template-Method/Abstract-Factory), musterlos verboten. compile-time-only Hot-Path (CRTP+Concept, keine vtable ausser an ABI-.so-Grenzen), kein Runtime-Switch, kein std::variant fuer statische Achsen. Haupt-Achse=CT-statisch, Unter-Achse=runtime (stufen-relativ). KEINE Parallelstruktur — am bestehenden offiziellen Pfad andocken, nie daneben bauen (feedback_vor_aufgaben_erst_projektstruktur_analyse). Organ-Achsen bilden binary_id; System-Achsen (CebSystemAxis: compiler/opt/isa/simd/scheduling/load) + Mess-Achsen (SystemAxis, Blut) NIE binary_id. Der Fuss CEB->Tier ist REAL gebaut (AnatomyModuleLoader/dlopen/pruef_dock, test-bewiesen) -> NICHT neu bauen, als Pattern nach oben spiegeln.'

const MAP_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    ebene: { type: 'string' },
    soll: { type: 'string', description: 'was die Quelle als SOLL beschreibt, datei:zeile' },
    ist: { type: 'string', description: 'was im Code existiert, datei:zeile' },
    gap: { type: 'string', description: 'die praezise Luecke' },
    andockpunkte: { type: 'array', items: { type: 'string' }, description: 'datei:zeile Andockpunkte zum Bauen' },
    reusable: { type: 'string', description: 'was schon existiert und wiederverwendet wird' },
  },
  required: ['ebene', 'soll', 'ist', 'gap'],
}

phase('Kartieren')
const readers = [
  { label: 'soll-ledger', prompt: `Lies im Ledger ${LEDGER} den §18 (ARCHITEKTUR-MODELL, ab Zeile ~1603) — insbesondere §18.1.1 (rekursive Dock-Architektur), §18.1.2 (CEB baut+misst Gattungen ueber Pruef-Dock), §18.1.8 (Planer = versteckte root-Minimal-Binary, XML-abhaengiges Build) + §19.C + §21.B (Achsen-Schichtung organ/system_measurement/system_config). Extrahiere das EXAKTE beschriebene SOLL der Kette Planer->CEB->Tier: je Dock der Vertrag, die ABI-Stabilitaet, der benannte Codegen (Director + 2 ConcreteBuilder + Template Method), wie der Planer die CEB mit System-Achsen(+Unter-Achsen)+Mess-Achsen bestueckt. ${DOCTRIN} Gib je Ebene (0 Planer, 1 CEB, 2 Tier) ein map-Item.` },
  { label: 'soll-designdoc', prompt: `Finde + lies das Design-Doc zum Planer-Codegen (Director/Builder), referenziert als "Design-Doc 20260716" im Ketten-Audit. Suche in ${PLA} und ${ARCH} nach Dateien mit Director/Builder/Planer/Codegen/Experiment-Planer-Bezug (glob 20260716*, grep ExperimentPlanDirector/IPlanBuilder/CiYamlBuilder/CMakeGraphBuilder/Template-Method). Extrahiere den detaillierten SOLL-Entwurf des Planer-Codegen: welche Klassen, welcher Walk, welche 2 ConcreteBuilder (CI-YAML vs CMake-Graph?), Template-Method-Skelett. ${DOCTRIN} Wenn kein solches Doc existiert, sag das explizit + liste was du gesucht hast.` },
  { label: 'ist-planer', prompt: `IST-Zustand des Planer-Kopfes im Code ${CE}. Lies GRUENDLICH: libs/cache_engine/profile_facade/experiment_run_entry.hpp (run_experiment_profile — die header-only Naht, die imperative opt×simd×Phasen-Schleife :257-365), profile_run_facade.cpp (run_experiment_profile_facade :494-599, parse_experiment_profile), builder/codegen/codegen.cpp (Alt-Stub CodegenEngine::generate_module) + codegen.hpp, und liste apps/ (welche Executables existieren: cache_engine_builder, permutation_codegen_tool, catalog_codegen_tool, adhoc_emitter — was macht jedes? welches ist NAHE am Planer?). Beschreibe EXAKT was die Planer-Naht heute tut (imperativ) vs was ein benannter Codegen-Director/Builder taete. ${DOCTRIN} map-Item Ebene 0.` },
  { label: 'ist-ceb-mess-system', prompt: `IST-Zustand der CEB-Ebene + wie sie mit Mess-Achsen + System-Achsen bestueckt wird, im Code ${CE}. Lies: builder/experiment_tree/cache_engine_builder_iterator.hpp (der Iterator, acquire_search_algorithm_drive :809-812, cache_push/measurement_sink), builder/build_orchestrator/build_orchestrator.hpp (provision_all, CompileFn/SourceGenFn-Injektion, System-Provenienz .version), builder/experiment_tree/registry_to_axis_levels.hpp (build_system_axis_levels, System-Achsen), builder/experiment_tree/ceb_system_axis.hpp + measurement/system_axis.hpp (die beiden Achsen-Wurzeln). Wie kriegt die CEB HEUTE ihre System-Achsen (compiler/opt/isa/simd) + Mess-Achsen? Wo wuerde der Planer sie bestuecken? ${DOCTRIN} map-Item Ebene 1.` },
  { label: 'ist-tier-dock-pattern', prompt: `DAS DOCK-VERTRAGS-MUSTER zwischen den Applikations-Schichten ermitteln (KRITISCH — beim letzten Lauf durch Prozess-Absturz NICHT ermittelt; diesmal MUSS ein Ergebnis kommen). Lies im Code ${CE} GENAU diese EXAKTEN Pfade (nicht globben; je Datei die kern-relevanten Zeilen, bei grossen Dateien gezielt per grep+offset): (1) libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp — der ABI-Vertrag: COMDARE_ANATOMY_ABI_MAJOR (6), MAGIC (0x..A6.), die 4 Pflicht-C-Symbole (comdare_anatomy_abi_magic/version + comdare_create/destroy_anatomy), host_compatible_with(), ceb_contract_version. (2) libs/cache_engine/builder/anatomy_module_loader/anatomy_module_loader.hpp UND .cpp — dlopen(RTLD_NOW|RTLD_LOCAL), Symbol-Resolve der 4 Symbole, Magic+Major-Gate, native_unload bei Mismatch. (3) libs/cache_engine/builder/pruef_dock/pruef_dock.hpp (das Basis-Dock-Interface) + driveable_map_contract.hpp + conformance_gate.hpp + pruef_dock_registry.hpp (select_for/accepts) + search_algorithm_dock.hpp (acquire_search_algorithm_drive). AUFGABE: extrahiere DAS WIEDERVERWENDBARE, REKURSIVE DOCK-VERTRAGS-MUSTER, das die Grenzen ZWISCHEN den 3 Schichten (Planer / CEB / Tier) definiert: (a) was macht eine Dock-Grenze generisch aus — benanntes Vertrags-Interface + ABI-.so-Grenze + Version/Magic-Gate + gerichteter Antrieb (die untere CEB<->Tier ist BIDIREKTIONAL: CEB treibt an, Tier meldet ABI-stabilen POD-Snapshot zurueck); (b) die KONKRETE, REAL gebaute + test-bewiesene Instanz CEB<->Tier mit datei:zeile-Belegen; (c) wie DASSELBE Muster auf die noch zu bauende obere Grenze Planer<->CEB anzuwenden ist (Experiment-Dock, EINDIMENSIONAL: Planer STEUERT -> CEB, KEIN Rueckkanal — der Planer bestueckt die CEB mit System+Mess-Achsen). ${DOCTRIN} Gib EIN map-Item: ebene='Dock-Vertrags-Muster (rekursiv, alle 3 Schichten)', soll=das Muster generalisiert, ist=die reale CEB<->Tier-Instanz mit datei:zeile, gap=was der zu bauenden Planer<->CEB-Grenze exakt fehlt, reusable=was 1:1 nach oben gespiegelt wird. Falls eine Datei fehlt, nimm die naechstbeste + sag es — aber liefere IMMER das vollstaendige Muster.` },
]
const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartieren', schema: MAP_SCHEMA }).then(x => ({ src: r.label, map: x })).catch(() => null)))
const valid = maps.filter(Boolean)
log(`Kartieren fertig: ${valid.length}/5 Ebenen-Maps`)

phase('Bauplan')
const bauplan = await agent(
  `Erstelle den TOP-DOWN-BAUPLAN der rekursiven Dock-Kette Experiment-Planer -> CEB(System+Mess-Achsen) -> Tier-Binaries, VOM KOPF beginnend. Basis (SOLL+IST-Maps je Ebene, JSON):\n${JSON.stringify(valid.map(v => v.map))}\n\nKetten-Audit-Report liegt unter ${AUD} (P7/P8/E-10 = Planer-Codegen-Luecke; V1/V2 = ABI-Grenze-Luecke). ${DOCTRIN}\n\nAUFGABE — der Bauplan MUSS:\n(1) VOM KOPF beginnen: Phase 1 = Planer-Kopf sauber bauen (benannter Codegen Director + 2 ConcreteBuilder + Template-Method + Planer-Executable + ABI-.so-Dock-Grenze Planer<->CEB), am BESTEHENDEN run_experiment_profile/codegen.cpp andocken (nicht daneben). Phase 2 = CEB bestueckt mit System+Mess-Achsen ueber den Planer. Phase 3 = Tier-Binaries ueber das bestehende (reale) CEB->Tier-Dock. (2) je Phase: exakte Andockpunkte (datei:zeile), welche benannten Patterns, was NEU vs was WIEDERVERWENDET (der reale CEB->Tier-Fuss wird NICHT neu gebaut, nur nach oben gespiegelt), golden/ABI-Neutralitaet, Verifikations-Kriterium (compile+test). (3) die Muster-Spiegelung explizit machen: wie die Planer<->CEB-Grenze das CEB<->Tier-Dock-Vertragsmuster (Magic/Major-Gate/POD/4-Symbole) spiegelt. (4) FORKS klar markieren, die USER-GO brauchen (z.B. Planer als echtes .so vs header-only-Vertragsgrenze; vor/nach Deadline 28.07; welche 2 ConcreteBuilder). (5) Reihenfolge + Abhaengigkeiten + geschaetzter Aufwand je Phase. Struktur: Executive Summary -> Phase 1/2/3 (je Andockpunkte/Patterns/neu-vs-reuse/Verifikation) -> Muster-Spiegelung -> FORKS-fuer-GO -> Risiken. Belege datei:zeile. NUR Markdown-Bauplan.`,
  { label: 'bauplan', phase: 'Bauplan' }
)

phase('Kritik')
const kritik = await agent(
  `Adversarialer Architektur-Kritiker. Bauplan:\n\n${bauplan}\n\n${DOCTRIN}\n\nPruefe HART: (a) Baut der Plan wirklich VOM KOPF (Planer zuerst), nicht bottom-up? (b) Dockt er am BESTEHENDEN offiziellen Pfad an oder erzeugt er heimlich eine Parallelstruktur (das war ein frueherer Stopp-Grund, v32-Parallel-Engine)? (c) Wird der REALE CEB->Tier-Fuss korrekt wiederverwendet (nicht neu gebaut)? (d) Nur benannte Patterns, compile-time-only, ABI-stabil je Dock? (e) Spiegelt die Planer<->CEB-Grenze das Tier-Dock-Vertragsmuster korrekt? (f) Sind die GO-Forks vollstaendig + ehrlich (nichts als entschieden getarnt, das offen ist)? (g) Ist die golden/ABI-Neutralitaet je Phase belegt? Gib eine KURZE Liste (max 8) konkreter Schwaechen/Korrekturen mit datei:zeile, oder 'Bauplan architektur-konform' mit Begruendung. Belege live wo noetig (grep ${CE}).`,
  { label: 'kritik', phase: 'Kritik' }
)

return { bauplan, kritik, ebenen: valid.length }
