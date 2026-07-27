export const meta = {
  name: 'gesamt-roadmap-xml-topdown-ledger-diff',
  description: 'Ledger-Batch-Review gegen Code + XML-Feature-Vollsammlung (4 Repos + Thesis) + Roadmap/Parallelisierung + New-Golden-XML-Voll-Mock + CI-Detail-Kette start->gruen',
  phases: [
    { title: 'Sammeln', detail: 'XML-Featurespace + Achsen-Code + PRT-ART + LaTeX + Workflow-Rahmen (5 parallel)' },
    { title: 'Ledger-Review', detail: '7 Batches: jede Aussage gegen aktuellen Code' },
    { title: 'Roadmap', detail: 'Diff-Roadmap + Disjunktheits-/Parallelisierungs-Analyse' },
    { title: 'Mock+Kette', detail: 'New-Golden-XML-Voll-Mock + CI-Detail-Kette' },
    { title: 'Kritik', detail: 'adversariale Vollstaendigkeits-/Widerspruchs-Pruefung' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const PRT = SUP + '/Code/external/comdare-prt-art'
const THESIS = SUP + '/thesis/diplomarbeit'
const LEDGER = SUP + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const PLA = SUP + '/docs/plaene'

const FAKTEN = 'NEUESTE FAKTEN (gewinnen gegen aeltere; Stand 2026-07-19, ce HEAD 5da2caf7, super HEAD 1a8b95e): 17 Organ-Kompositions-Achsen (ABI-6, Magic .A6., isa+telemetry raus, POD sizeof==1272, kV3AxisCount=17); golden-320 = Alias/Snapshot; NEUES golden N=2^17=131072 all-vary CRC64-Fixture gelandet (all_axes_golden.profile.xml existiert), aber golden-N-BAU (XML-Materialisierung+opt-simd-Wiring+Referenz/Katalog-Entkopplung) OFFEN; #50 Caching done (perm.algos, algo_version an Strategien+11 Observable-Huellen, dll_is_current+algo_sig, Pipeline 11278 gruen); #51 Storage: CE-Code fertig+inert, Weg-A-CI-Aktivierung gelandet (COMDARE_STORAGE_CACHE-Gate), Infra-Handout P1-P6 offen (prod-MinIO Bucket cache-engine-tier-binaries erreichbar, measure-drop V60); #52 variant-Verbot durchgesetzt (HotPathIsVariantFree-Guard); #45 A2-Neben done; INC-2d Variante A vollzogen (TargetIsaSystemAxis); Q2=Option C (extension_hardware 6. System-Achse — aktiver Familien-Knoten FEHLT noch, E-4); opt-Default O3; 6 CEB-System-Achsen (compiler/opt_level/simd/target_isa/scheduling/load_framework) als CT-Schicht; Planer-Kopf NICHT fertig (header-only Naht run_experiment_profile, kein Director/Builder, kein Executable — Bauplan docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md mit Phase-0-Blocker: super 02_messung_driver/v32_messreihe_antrieb.hpp execute_messreihe=return-0-Stub + PhaseStrategyFor<MergeStrategy> = existierendes offizielles Planer-Skelett, WIEDERVERWENDEN statt daneben bauen); Fuss CEB<->Tier real (AnatomyModuleLoader dlopen, IPruefDock, 4 Symbole, host_compatible_with); Register 61 Eintraege docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md; 2 Audits docs/audits/20260718-*.md (G1-G10, P1-P8, Konvergenz G1==A1 binary_id-Struktur-Guard); Deadline 28.07.2026 (FF0-FF4 honest-100% + Thesis-PDF).'

const DOKTRIN = 'DOKTRIN: Organ-Achsen bilden binary_id AUSSCHLIESSLICH; System-Achsen (system_config) + Mess-Achsen (system_measurement, Blut) NIE binary_id (Provenienz build_version/.version-Sidecar, Organ-Provenienz perm.algos). compile-time-only Hot-Path (CRTP+Concept, keine vtable ausser ABI-.so-Grenzen), kein std::variant fuer statische Achsen, nur benannte Patterns. Haupt-Achse CT-statisch, Unter-Achse runtime (stufen-relativ: dynamisch-Vorstufe = CT-Draht-Folgestufe). Mess=1-Thread sequentiell, Schreib-Naht synchron. Messdaten/Doku nie loeschen. CI-Gruen=Messung AUS; Messlauf opt-in. NUR EIN offizielles XML-Programm, keine Parallelstruktur, keine Behelfswege. golden-Neutralitaet je Schritt ausweisen.'

const ITEMS_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    items: { type: 'array', items: {
      type: 'object', additionalProperties: false,
      properties: {
        aussage: { type: 'string', description: 'die Ledger-Aussage/das Feature, kompakt' },
        quelle: { type: 'string', description: 'datei:zeile / §-Ref' },
        code_ist: { type: 'string', description: 'Ist im Code, datei:zeile' },
        status: { type: 'string', enum: ['ERLEDIGT','OFFEN','DRIFT','SUPERSEDED','GATED','ENTSCHEIDUNG'] },
        next_action: { type: 'string' },
        beruehrte_flaeche: { type: 'array', items: { type: 'string' }, description: 'Dateien/Bereiche die eine Umsetzung beruehren wuerde (fuer Disjunktheits-Analyse)' },
        golden_neutral: { type: 'boolean' },
      },
      required: ['aussage','quelle','status'],
    } },
    zusammenfassung: { type: 'string' },
  },
  required: ['items','zusammenfassung'],
}

// ── Phase 1 + Phase 2 gemeinsam parallel (unabhaengig) ────────────────────────
const sammler = [
  { label: 'xml-featurespace', phase: 'Sammeln', prompt: `SAMMLE den VOLLSTAENDIGEN Top-down-XML-Featurespace: ALLE Features/Achsen/Typen/Einstellungen, die per XML registriert/gesteuert werden koennen. Lies VOLLSTAENDIG: (1) ${CE}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (2) ${PRT}/prt_art/algorithm_profiles/prt_art_axis_registry.xml (3) ${CE}/libs/cache_engine/algorithm_profiles/permutation_axes.xml (Kopf+Struktur) (4) ${SUP}/Code/test_data_xml/experiment_schema.xsd + messreihe_v32_schema.xsd (5) ${SUP}/Code/experiment_config/config_a_prt_art_vs_sota.xml + config_b_cache_engine_perms.xml + config_c_merge_alt_neu.xml + messreihen.xml (6) ${CE}/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml (die golden-N-Keimzelle!) + m3v2_study.profile.xml (Referenz-Zwilling) (7) den Parser ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.hpp (struct ThesisProfile ~:? + struct ExperimentProfile :300 + parse_* — WAS kann das XML heute ausdruecken, was NICHT). Je registrierbarem Element ein item: aussage=Element/Feature, quelle=datei:zeile, code_ist=Parser-/Registry-Traeger, status (ERLEDIGT=voll XML-steuerbar / OFFEN=geplant-nicht-steuerbar / DRIFT=XML-sagt-X-Code-macht-Y). Erfasse auch: Workloads/YCSB, Datasets, Phasen/MergeStrategy, opt_level/simd/compiler/target_isa-System-Achsen (XML-Kanal vorhanden? G3: ThesisProfile hat KEIN system_axes-Feld!), Mess-Achsen/Kategorien, repetitions, output-Ziele. ${FAKTEN} ${DOKTRIN}` },
  { label: 'achsen-code-vorrat', phase: 'Sammeln', prompt: `SAMMLE den realen ACHSEN-WERTE-VORRAT aus dem Code (der Werte-Pool fuer das New-Golden-XML-Mock). Fuer JEDE der 17 Organ-Achsen (kCompositionAxisNames-Reihenfolge, ${CE}/libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:31-40): die EnabledStrategies-Varianten mit exaktem name() (grep in ${CE}/libs/cache_engine/topics/*/topic_*_config_set.hpp + axes-Registries; enabled mp_size je Achse — Referenz-Tabelle im Plan docs/plaene/20260718-new-golden-all-axes-vor-BAUPLAN-NEW-GOLDEN-ALL-AXES.md §1: 4/3/2/3/4/5/3/4/9/4/5/4/4/4/4/15/5). Zusaetzlich: die 6 CEB-System-Achsen-Auspraegungen (compiler gcc/clang, opt O0..Ofast, simd no_extension/avx2/avx512, target_isa x86_64/aarch64, scheduling, load_framework) mit exakten Labels aus ${CE}/libs/cache_engine/include/cache_engine/measurement/*.hpp; die Mess-Achsen (SystemAxis-Familien) + DynamicDims (workload/repetition/thread_count/dataset). Je Achse ein item: aussage=Achse+Varianten-name()-Liste, quelle=Registry-datei:zeile, code_ist=StrategyBase-Ort, beruehrte_flaeche=[Achsen-Verzeichnis]. WICHTIG fuer Mock: je Achse die 2 kanonischen All-Vary-Varianten vorschlagen (die 1. + eine strukturell maximal verschiedene). ${FAKTEN}` },
  { label: 'prt-art-rahmen', phase: 'Sammeln', prompt: `SAMMLE die PRT-ART-Seite des Experiment-Workflows (Prueﬂing-Engine). Lies: ${PRT}/prt_art/algorithm_profiles/prt_art_axis_registry.xml VOLLSTAENDIG; ${PRT}/README* + docs/ falls vorhanden (ls zuerst); dazu die 3-Stufen-Join-Semantik (Stufe1 CE-only / Stufe2 Pruefling-ersetzt / Stufe3 FullJoin) im super: ${SUP}/Code/02_messung_driver/v32_messreihe_antrieb.hpp (PhaseCompositions<MergeStrategy> :98-120) + experiment_phase_strategy.hpp + ${SUP}/Code/experiment_config/config_a_prt_art_vs_sota.xml. Regel der abstrakt-leeren Achse (leere Pruefling-Achse reust CE-Algos). Items: welche PRT-ART-Achsen/Bausteine XML-registrierbar sind, wie der Join die binary_id/Kompositionen bildet, welche Rand-/Rahmenbedingungen der Experiment-Workflow PRT-ART-seitig hat (eigene ABI? eigener Registry-Pfad? CMake-Interface-Pfade). ${FAKTEN} ${DOKTRIN}` },
  { label: 'latex-resultat', phase: 'Sammeln', prompt: `SAMMLE die LaTeX-Resultat-Dokument-Anforderungen (Thesis als DESIGN-QUELLE). Lies in ${THESIS}: die Struktur (ls kapitel/ bzw. Verzeichnis), die Messwerte-/Auswertungs-Sektion + FF0-FF4-Forschungsfragen (grep -rl 'FF0\\|FF1\\|Forschungsfrage' — 01_einleitung.tex), die Anhang-Darstellungs-.tex-Erwartungen; dazu im super den Anhang-Generator: grep appendix_generator ${SUP}/Code -r --include=*.cpp -l (Stufe 08, WIDE-Matrix -> 16 Darstellungs-.tex, langs=de,en) + ${SUP}/.gitlab-ci.yml measure-Job Anhang-Regen-Block (Zeilen ~543-568). Items: WELCHE Messwerte/Formate/Tabellen/Kurven das LaTeX-Dokument aus dem Experiment-Workflow FORDERT (Spalten der measurements.csv/WIDE, Perzentile?, Heatmaps?, je-Achse-Kurven fuer Heuristik?), DE+EN-Pflicht, was davon heute generierbar ist vs fehlt. Das definiert das ENDE der CI-Kette (PDF mit Messwerten). ${FAKTEN}` },
  { label: 'workflow-rahmen', phase: 'Sammeln', prompt: `SAMMLE die Rand-/Rahmenbedingungen des Experiment-WORKFLOWS Ende-zu-Ende. Lies: ${SUP}/.gitlab-ci.yml VOLLSTAENDIG (alle Stages/Jobs/Gates: verify:submodules, build, test, analyse, measure:smoke/golden-320 [COMDARE_RUN_MEASURE/COMDARE_MEASURE_PROFILE], .storage_cache_activation [COMDARE_STORAGE_CACHE], persist:measurements [COMDARE_PERSIST_MEASUREMENTS + WRITEBACK], thesis:pdf [COMDARE_TEXLIVE_AVAILABLE], manifest:provenance) + ${CE}/.gitlab-ci.yml (Kopf+Jobs-Liste). Dazu: Storage-3-Ebenen (A ccache/B minio cache-engine-tier-binaries/C measure-drop) aus ${CE}/libs/cache_engine/builder/artifact_transport/artifact_cache.hpp (Kopf-Doku) + Sequentialitaets-Naht (${CE}/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:893-946 synchron) + Fehlerklassen (${CE}/libs/cache_engine/include/cache_engine/measurement/axis_error.hpp Kopf: InfraError vs CompilerCompiler, failed-Zelle) + Resume/Stamp + dll_is_current+algo_sig (build_orchestrator.hpp:184-215). Items: jede Rahmenbedingung (Gate/Env-Var/Job/Reihenfolge/Timeout/Runner-Tags/Loop-Schutz) als item mit quelle. Das definiert die CI-KETTE start->gruen. ${FAKTEN} ${DOKTRIN}` },
]

const batches = [
  { label: 'ledger-b1-goal-blocker', range: '§0 bis §11 (Zeilen ~1-640: GOAL/DoD/FF-Katalog/Blocker/Spur-S/P/ABI-Freeze/§7 Projekte/§8 gated-HW/§10 E-Ebenen/§11 Mess-Persistenz)' },
  { label: 'ledger-b2-log12', range: '§12 FORTSCHREIBUNGS-LOG (Zeilen ~640-1100; JEDE Log-Zeile die einen Zustand behauptet)' },
  { label: 'ledger-b3-13-17', range: '§13 bis §17 (Zeilen ~1100-1600: Entscheidungs-Defaults/Sub-Achsen/Werte/Q-Fragen/17.E measured=0)' },
  { label: 'ledger-b4-18', range: '§18 ARCHITEKTUR-MODELL komplett (Zeilen ~1603-1861: 18.1.1 rekursive Dock/18.1.2 Gattungen/18.1.8 Planer-Binary/Heuristik/Konstruktionslogik)' },
  { label: 'ledger-b5-19-21', range: '§19 bis §21 (Zeilen ~1861-2053: VOLLES GO/NACH-GO-Verbuchung/Bruch-Rulings/Schichtung/E1-E5)' },
  { label: 'ledger-b6-22-26', range: '§22 bis §26 (Zeilen ~2053-Ende: INC-2d/variant/VOLLES-GO-Pakete/Session-Nachtraege/Register-Korrekturen)' },
]

phase('Sammeln')
const collectPromise = parallel(sammler.map(s => () => agent(s.prompt, { label: s.label, phase: 'Sammeln', schema: ITEMS_SCHEMA }).then(x => ({ src: s.label, ...x })).catch(() => null)))

const batchPromise = parallel(batches.map(b => () => agent(
  `LEDGER-BATCH-REVIEW gegen den AKTUELLEN Code (ce HEAD 5da2caf7 + super HEAD 1a8b95e). Lies im Ledger ${LEDGER} den Bereich ${b.range} VOLLSTAENDIG (nutze grep -n '^## §' fuer die exakten Grenzen, dann Read mit offset/limit). Gehe JEDE AUSSAGE einzeln durch (nicht nur TODOs — auch Zustands-Behauptungen, Architektur-Festlegungen, Zahlen/Slots/SHAs, Direktiven): pruefe sie gegen den ISTCODE in ${CE} und ${SUP}/Code (grep/Read gezielt). Je Aussage ein item: status ERLEDIGT (Code belegt es) / OFFEN (gefordert, nicht gebaut) / DRIFT (Ledger sagt X, Code macht Y — beides zitieren!) / SUPERSEDED (von neuerem §/Fakt ueberholt — sag von welchem) / GATED / ENTSCHEIDUNG (braucht User-GO). Fuer OFFEN/DRIFT: next_action + beruehrte_flaeche (die Dateien/Bereiche, die eine Umsetzung anfassen wuerde — WICHTIG fuer die spaetere Parallelisierungs-Analyse) + golden_neutral. Sei EXHAUSTIV im Bereich, aber dedupe triviale Wiederholungen. ${FAKTEN} ${DOKTRIN}`,
  { label: b.label, phase: 'Ledger-Review', schema: ITEMS_SCHEMA }
).then(x => ({ src: b.label, ...x })).catch(() => null)))

const extraLedgerPromise = agent(
  `NEBEN-LEDGER-REVIEW: (1) ls + lies ${SUP}/docs/ledger-sections/ und ${CE}/docs/ledger-sections/ (alle Dateien); (2) ${CE}/docs/sessions/20260618-OFFENE-TODOS-LEDGER.md (ALT — pruefe je Punkt ob superseded durch den Haupt-Ledger/INC-2d/ABI-6); (3) ls ${PRT}/docs 2>/dev/null + ${PRT}/*.md — existiert ein PRT-ART-Ledger/Plan? Wenn ja lesen. Jede noch NICHT vom Haupt-Ledger abgedeckte offene Aussage als item (status + code_ist-Pruefung in ${CE}/${PRT}); superseded explizit als SUPERSEDED markieren. ${FAKTEN} ${DOKTRIN}`,
  { label: 'ledger-b7-neben', phase: 'Ledger-Review', schema: ITEMS_SCHEMA }
).then(x => ({ src: 'ledger-b7-neben', ...x })).catch(() => null)

const [collected, batchResults, extraLedger] = await Promise.all([collectPromise, batchPromise, extraLedgerPromise])
const sammlung = collected.filter(Boolean)
const reviews = batchResults.filter(Boolean).concat(extraLedger ? [extraLedger] : [])
log(`Sammeln: ${sammlung.length}/5 Sammler, Ledger-Review: ${reviews.length}/7 Batches; Items gesamt: ${sammlung.concat(reviews).reduce((n,r)=>n+(r.items||[]).length,0)}`)

// ── Phase 3 — Roadmap + Parallelisierung (Barrier: braucht ALLES) ─────────────
phase('Roadmap')
const allItems = sammlung.concat(reviews).flatMap(r => (r.items||[]).map(it => ({ ...it, _src: r.src })))
const roadmapDoc = PLA + '/20260719-gesamt-roadmap-ledger-diff-ROADMAP.md'
const parallelDoc = PLA + '/20260719-parallelisierung-disjunkte-pakete-ANALYSE.md'
const katalogDoc = PLA + '/20260719-xml-featurespace-topdown-KATALOG.md'

const roadmapPromise = agent(
  `ROADMAP-SYNTHESE. Du bekommst ${allItems.length} Review-/Sammel-Items (JSON, mit _src):\n${JSON.stringify(allItems).slice(0, 380000)}\n\nVERFEINERE die bestehenden Planungen (lies zuerst: ${SUP}/docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md + ${PLA}/20260719-planer-ceb-tier-topdown-BAUPLAN.md + die 6 ${PLA}/20260718-*.md) — NICHT ersetzen, sondern das Ledger-Diff einarbeiten. Erzeuge die GESAMT-ROADMAP als Markdown und SCHREIBE sie mit dem Write-Tool nach ${roadmapDoc}: (A) Executive Summary (Marschrichtung zur Deadline 28.07; kritischer Pfad); (B) Diff-Tabelle Ledger-vs-Code: alle OFFEN/DRIFT/ENTSCHEIDUNG-Items dedupliziert, gruppiert nach Strang (Planer-Kette Phase 0-3 / golden-N-Bau / Storage-Scharfschaltung / Konformitaets-Fixes G+P / Messlauf+PDF / Bookkeeping), je Item quelle+code_ist+next_action+golden_neutral+beruehrte_flaeche; (C) DRIFT-Liste separat (Ledger korrigieren!); (D) SUPERSEDED-Liste (Ledger-Nachzug); (E) geordnete Marschrichtung (nummerierte Meilensteine mit Abhaengigkeiten, vor/nach 28.07). Gib als Return NUR eine kompakte Zusammenfassung (die Datei traegt den Inhalt). ${FAKTEN} ${DOKTRIN}`,
  { label: 'roadmap-synthese', phase: 'Roadmap' }
)
const katalogPromise = agent(
  `XML-FEATURESPACE-KATALOG konsolidieren. Aus diesen Sammel-Items (nur die 5 Sammler-Quellen xml-featurespace/achsen-code-vorrat/prt-art-rahmen/latex-resultat/workflow-rahmen):\n${JSON.stringify(sammlung.flatMap(s=>(s.items||[]).map(it=>({...it,_src:s.src})))).slice(0, 300000)}\n\nSCHREIBE mit Write nach ${katalogDoc} den vollstaendigen TOP-DOWN-KATALOG: (A) alle XML-registrierbaren Features/Achsen/Typen/Einstellungen (Organ 17 mit Varianten-name()-Vorrat, System 6, Mess/DynamicDims, Workloads/Datasets/Phasen/MergeStrategy, PRT-ART-Bausteine, output/Provenienz) je mit XML-Element, Parser-Traeger, Registry-Quelle, Status (steuerbar/geplant/Gap); (B) die GAPS (was das XML laut Design koennen soll, aber Parser/ThesisProfile heute nicht traegt — z.B. G3 system_axes-Feld, datasets, measurement_categories); (C) die Rand-/Rahmenbedingungen des Experiment-Workflows (CI-Gates, Storage, Sequentialitaet, Fehlerklassen, LaTeX-Ende) kompakt tabelliert. Return: kompakte Zusammenfassung. ${FAKTEN}`,
  { label: 'xml-katalog', phase: 'Roadmap' }
)
const [roadmapSum, katalogSum] = await Promise.all([roadmapPromise, katalogPromise])
log('Roadmap + Katalog geschrieben')

const parallelSum = await agent(
  `DISJUNKTHEITS-/PARALLELISIERUNGS-ANALYSE. Lies die soeben geschriebene Roadmap ${roadmapDoc} (VOLL). Aufgabe: finde die ABSOLUT DISJUNKTEN Bestandteile, die in der Implementierung PARALLELISIERT werden koennen. Kriterien (Ledger-Doktrin Spur-S/P): (1) dateidisjunkt (beruehrte_flaeche-Schnitt = leer), (2) keine gemeinsame ABI/POD/god-header-Flaeche (abi_adapter/observable_tier/anatomy_module_abi = SERIELLER Sperrbereich, max 1 offener Increment), (3) golden-beruehrende Schritte NIE parallel zueinander (GO-Fenster seriell), (4) Single-Owner je geteilter Datei (CMakeLists/.gitlab-ci.yml/profile_run_facade = Konflikt-Hotspots benennen!). SCHREIBE mit Write nach ${parallelDoc}: (A) Parallelisierungs-Matrix: Arbeitspakete als Spalten/Zeilen, Konflikt ja/nein mit Grund; (B) die PARALLEL-WELLEN (Welle 1: alles was SOFORT gleichzeitig starten kann mit Owner-Zuordnung z.B. Agent-A Quick-Wins-ce-Kommentare / Agent-B CI-yml / Agent-C Planer-Phase-0-super / Agent-D Thesis-tex; Welle 2 danach; SERIELL-Strang separat); (C) die Konflikt-Hotspots (Dateien die mehrere Pakete beruehren -> Single-Owner-Zuweisung oder Serialisierung); (D) Empfehlung wie viele parallele Implementierungs-Agenten sinnvoll sind. Return: kompakte Zusammenfassung + die Welle-1-Liste.`,
  { label: 'parallelisierung', phase: 'Roadmap' }
)

// ── Phase 4 — New-Golden-XML-Voll-Mock + CI-Detail-Kette ─────────────────────
phase('Mock+Kette')
const mockDoc = PLA + '/20260719-new-golden-voll-xml-mock-ENTWURF.md'
const ketteDoc = PLA + '/20260719-ci-kette-start-zu-gruen-DETAIL.md'
const [mockSum, ketteSum] = await Promise.all([
  agent(
    `NEW-GOLDEN VOLL-XML-MOCK konfigurieren. Lies zuerst: ${CE}/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml (die existierende Keimzelle — VERFEINERN, nicht wegwerfen) + m3v2_study.profile.xml (der Referenz-Zwilling mit allen Sektionen) + den Katalog ${katalogDoc} (Achsen-Werte-Vorrat + Gaps) + ${PLA}/20260718-new-golden-all-axes-vor-BAUPLAN-NEW-GOLDEN-ALL-AXES.md (N=2^17-Mathematik, kanonische Reihenfolge-Pflicht). SCHREIBE mit Write nach ${mockDoc} ein Dokument mit: (A) dem VOLLEN XML-Mock als \`\`\`xml-Block — das komplette comdare_thesis_profile fuer golden N=2^17: permute_axes ueber ALLE 17 Achsen in kanonischer kCompositionAxisNames-Reihenfolge, je Achse GENAU 2 konkrete name()-Werte aus dem echten Registry-Vorrat; PLUS die heute noch NICHT parsbaren Ziel-Sektionen als klar markierte <!-- ZUKUNFT: ... --> Bloecke (system_axes compiler/opt/simd/target_isa-Permutation, workloads/datasets, measurement_categories, phases/MergeStrategy fuer PRT-ART-Join, output/Provenienz-Ziele) — damit das Mock das ZIEL-XML der ganzen Kette zeigt; (B) je Sektion die Begruendung (Variante-Wahl, warum diese 2) + welcher Parser-/Schema-Gap sie heute blockiert (Ref auf Katalog-Gaps); (C) den Migrations-Pfad Keimzelle->Voll-Mock (welche Increments die ZUKUNFT-Bloecke scharf schalten). Das Mock ist ein ENTWURFS-DOKUMENT (docs/plaene), KEINE live .xml — nichts im Live-Pfad aendern. Return: kompakte Zusammenfassung + N-Verifikation (Produkt der Fanouts == 131072).`,
    { label: 'xml-voll-mock', phase: 'Mock+Kette' }
  ),
  agent(
    `CI-DETAIL-KETTE start->gruen (die zu erfuellende Aufgabenkette). Lies: ${SUP}/.gitlab-ci.yml (voll) + ${PLA}/20260719-planer-ceb-tier-topdown-BAUPLAN.md + die Roadmap ${roadmapDoc}. Verfolge dann im CODE die INNEREN ABLAEUFE der Teilprogramme top-down und SCHREIBE mit Write nach ${ketteDoc} die vollstaendige Detail-Kette, wie ein CI-Lauf von START bis GRUEN durchlaeuft — je Stufe: Programm/Job, innere Schritte (mit datei:zeile), Inputs/Outputs/Artefakte, Gates/Fehlerklassen, was heute FEHLT (Ref Roadmap-Item). Stufen: (0) Pipeline-Start/verify:submodules/Build-Matrix -> (1) PLANER: XML-Parse (xml_config_parser parse_thesis_profile/parse_experiment_profile), --validate-Preflight (02_messung_driver/main.cpp), Registry-Validierung, Projektion (project_experiment_to_sota_passes bzw. v32 PhaseStrategyFor), Baum-Bau (profile_to_tree/build_axis_levels -> ExperimentTree, StaticBinaryView-Bijektion, select) -> (2) CEB: System-Achsen-Bestueckung (CompileFn/make_gpp_compile_fn, opt-simd-Schleife experiment_run_entry:257-289, build_version+system_axes_version_suffix), provision_all (parallel BAU, dll_is_current+algo_sig-Skip, perm.algos/perm.dll.version-Sidecars, adhoc_emitter-Codegen innerer Ablauf), Storage-B-Push (artifact_cache push_tier_binary mc, Naht :893-946) -> (3) TIER: AnatomyModuleLoader dlopen+4-Symbole+Gate, Zwei-Phasen-Messung (save/warmup/rollback/measure, runtime_variable_loop DynamicDims workload/repetition), IObservableTier tier_observe POD-Pull, PMC (pmc_source perf_event_open), result.csv+stamp -> (4) AUSWERTUNG: WIDE-Aggregat, appendix-generator (16 .tex, de+en, honest-empty), measure-drop-C-Sink, persist:measurements (additiv, Loop-Schutz), thesis:pdf latexmk -> GRUEN-Kriterien je Stufe. Markiere je Stufe [FERTIG]/[TEILWEISE]/[FEHLT->Roadmap-Ref]. Return: kompakte Zusammenfassung + die Liste der FEHLT-Stufen.`,
    { label: 'ci-detail-kette', phase: 'Mock+Kette' }
  ),
])

// ── Phase 5 — Kritik ─────────────────────────────────────────────────────────
phase('Kritik')
const kritik = await agent(
  `ADVERSARIALER VOLLSTAENDIGKEITS-KRITIKER. Lies die 5 soeben geschriebenen Dokumente VOLL: ${roadmapDoc}, ${katalogDoc}, ${parallelDoc}, ${mockDoc}, ${ketteDoc}. Pruefe hart: (a) Widersprueche zwischen den 5 Dokumenten (z.B. Roadmap-Reihenfolge vs Parallelisierungs-Wellen vs CI-Ketten-FEHLT-Stufen)? (b) Ledger-Aussagen-Luecken (stichprobe 10 zufaellige Ledger-§ gegen die Roadmap — fehlt eine?)? (c) XML-Mock: Produkt der Fanouts wirklich 2^17? kanonische Reihenfolge korrekt (gegen axis_path_serialization.hpp:31-40 pruefen)? Varianten-name() existieren wirklich (grep im Code)? (d) Parallelisierung: sind die als disjunkt erklaerten Pakete WIRKLICH dateidisjunkt (stichprobe beruehrte_flaeche gegen live grep)? (e) verfeinern die Dokumente die bestehenden Plaene (Register/Bauplan/6x20260718) oder widersprechen sie ihnen still? (f) Ist der Phase-0-v32-Reconcile-Blocker (v32_messreihe_antrieb) ueberall konsistent beruecksichtigt? Gib eine Liste konkreter Korrekturen (max 12) mit dokument+stelle, oder 'konsistent' je Dimension. Korrekturen die du SICHER verifiziert hast, wende direkt per Edit auf die betroffenen Dokumente an (additiv, als KORREKTUR-Vermerk) und berichte was du geaendert hast.`,
  { label: 'kritik', phase: 'Kritik' }
)

return {
  roadmap: roadmapSum, katalog: katalogSum, parallelisierung: parallelSum,
  xml_mock: mockSum, ci_kette: ketteSum, kritik,
  dokumente: [roadmapDoc, katalogDoc, parallelDoc, mockDoc, ketteDoc],
  items_gesamt: allItems.length,
}
