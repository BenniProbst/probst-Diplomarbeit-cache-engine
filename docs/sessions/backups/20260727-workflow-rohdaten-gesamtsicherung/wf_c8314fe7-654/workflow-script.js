export const meta = {
  name: 'session-plan-ausfuehrung-offene-arbeit',
  description: 'Elaborierter sequentieller Ausfuehrungsplan der offenen Diplomarbeit-Arbeit (§48), je Schritt maximal parallelisiert auf disjunkte Agenten-Pakete',
  phases: [
    { title: 'Analyse', detail: '3 Reader: Datei-Disjunktheit + Abhaengigkeitskette + Deadline-Baender' },
    { title: 'Plan-Synthese', detail: '1 Architekt-Agent -> freigabe-fertiger Session-Plan' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const COMMON = `Diplomarbeit C++/CMake-Codebasis. super=${SUPER}, ce=${CE}. Grundlage = der §48-KONSOLIDIERTE GESAMTBLOCK im Ledger ${LEDGER} (Grep '## §48' — 437 offene Ziele in 8 Straengen: Bau-Kette/Mess-Kette/Thesis-PDF/Hybrid/Storage/Infra/Konformitaet/Bookkeeping, je mit Status+Prioritaet+Deadline). Antworte NUR mit StructuredOutput, Belege als datei:zeile bzw. §-Anker. Fokus: die OFFEN/TEIL-Ziele mit Prioritaet kritisch/hoch und Deadline-Bezug 24.07./28.07. (die geparkten/nach-Abgabe-Ziele nur am Rand).`

phase('Analyse')
const KOLL = { type:'object', required:['pakete','kollisionsmatrix','disjunkte_gruppen'], properties:{
  pakete: { type:'array', items:{ type:'object', required:['id','ziel','kern_dateien'], properties:{ id:{type:'string'}, ziel:{type:'string'}, kern_dateien:{type:'array', items:{type:'string'}}, anker:{type:'string'} } } },
  kollisionsmatrix: { type:'array', items:{ type:'string', description:'Paket A vs Paket B teilen Datei X -> koordinieren/1-Owner' } },
  disjunkte_gruppen: { type:'array', items:{ type:'string', description:'Pakete die datei-disjunkt und damit PARALLEL baubar sind' } },
}}
const DEP = { type:'object', required:['kanten','kritischer_pfad','gates'], properties:{
  kanten: { type:'array', items:{ type:'string', description:'Paket X blockiert Paket Y (weil ...)' } },
  kritischer_pfad: { type:'array', items:{type:'string'}, description:'die laengste Blockier-Kette zur Abgabe 28.07., geordnet' },
  gates: { type:'array', items:{ type:'string', description:'User-GO-Gate / ABI-golden-Gate / CI-gruen-Gate / Deadline-Gate zwischen welchen Schritten' } },
}}
const [kollision, abhaeng, deadline] = await parallel([
  () => agent(`${COMMON}
AUFGABE DATEI-DISJUNKTHEIT (der Parallelisierungs-Schluessel): Fuer die offenen Impl-Pakete des §48-Blocks (v.a. Bau-/Mess-/Storage-/Konformitaet-Straenge) kartiere JE Paket die Kern-Dateien, die es beruehrt. Verifiziere im Code die Hotspots: ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp + plan_legend.hpp, profile_facade/profile_run_entry.hpp + experiment_run_entry.hpp + profile_run_facade.{hpp,cpp}, builder/experiment_tree/cache_engine_builder_iterator.hpp, builder/build_orchestrator, builder/artifact_transport/artifact_cache.hpp, libs/common/serialization/xml_config_parser/*, profile_facade/validate_profile.hpp, measurement/*registry*, abi/anatomy_module_abi_v1*, super/.gitlab-ci.yml, super/Code/02_messung_driver/main.cpp. Konkrete Pakete mind.: (P-TOTAL) COMDARE_GN_TOTAL-forward-Fix, (P-MESSTOOL) Mess-Tooling-Haupt-Auffaecherung measurement_combos_of+Schema<measurement_tooling>/<run_methodology>+Parser+validate+Registry, (P-VOLLZUG) sequentieller Mess-Vollzug emit_measure_job real, (P-W12B) Stempel-Cache-Key, (P-W12A3) SOTA-Stempel, (P-OBS) Observer-Reklass telemetry/isa, (P-SYSREG) System-Registry, (P-RESOLVER) Registry-Resolver, (P-HYBRID) Spline-Heuristik, (P-KONFORM) build-i2/Quick-Wins/Fehlerklassen, (P-INFRA) PAT-Rotation/avx512/Storage-Aktivierung. Ergebnis: kollisionsmatrix (welche Pakete teilen Dateien -> 1-Owner/sequentiell) + disjunkte_gruppen (parallel baubar).`, {label:'analyse:datei-disjunktheit', phase:'Analyse', schema:KOLL, model:'opus', effort:'high'}),

  () => agent(`${COMMON}
AUFGABE ABHAENGIGKEITSKETTE + KRITISCHER PFAD: Bestimme die logische Reihenfolge der offenen Pakete zur Abgabe. Belege JEDE Blockier-Kante aus Ledger/Code. Bekannte Ketten: (1) P-TOTAL-forward-Fix -> echter Voll-Build 2^17 (§46, 24.07.). (2) Schema<measurement_tooling> -> measurement_combos_of-Auffaecherung (P-MESSTOOL) -> sequentieller Mess-Vollzug (P-VOLLZUG) -> 320er-Abgabe-Messlauf (§32-F2) -> M-4-Auswertung -> Thesis-PDF/#47 (§0-G8, 28.07.). (3) Hybrid (§31/§32-F8, ABGABE-PFLICHT) braucht reale Messdaten aus (2). (4) P-W12B (Cache-Key) haengt an Storage-Aktivierung (§56-Infra-gated). (5) P-OBS Observer-Reklass ist golden-relevant -> eigenes ABI/golden-Gate, VOR telemetry-variierendem Messlauf (H-10 Prio 1). (6) P-MESSTOOL beruehrt binary_id NICHT (Tooling=CEB-Stufe, nicht Organ) -> golden-neutral? verifizieren. Liefere kanten (X blockiert Y), kritischer_pfad (geordnete laengste Kette zur 28.07.), gates (wo User-GO / ABI-golden-Regen / CI-gruen noetig ist).`, {label:'analyse:abhaengigkeit', phase:'Analyse', schema:DEP, model:'opus', effort:'high'}),

  () => agent(`${COMMON}
AUFGABE DEADLINE-BAENDER + GATES: Ordne die offenen Ziele in Zeit-Baender. Belege aus §41/§45/§46/§0-V6.6/§32-F2. BAND-A (bis Fr 24.07.): Voll-Bau-Nachweis 2^17 (setzt P-TOTAL voraus) + Messfaehigkeit CI UND lokal (§40.c Bare-Metal). BAND-B (bis 28.07. Abgabe): 320er-Voll-Messlauf als Abgabe-Datensatz + M-4 + Thesis-PDF+Anhaenge A/B/E + Hybrid-Binary (ABGABE-PFLICHT) + honest-FF0-FF4. BAND-C (ab 01.08.): new-golden-Voll-Messung. BAND-D (nach Abgabe/geparkt): System-/Mess-Join, Gattungs-Docks, S-7-Deep-Research, avx512-Ketten-Anschluss, #276-3-ISA. Nenne je Band die Pflicht-Ziele (§-Anker) + die harten Gates: (a) User-GO-Release je Bau-Phase (§0-V6.4), (b) ABI/golden-Regen-Fenster nur mit GO (§20.B/§21.E), (c) CI-hart-gruen ce+super vor naechstem Schritt (§20.B), (d) §38.b Ein-CEB-Mess-Exklusivitaet, (e) Messdaten/Doku nie loeschen. offene_design_frage: welche Ziele brauchen VOR dem Bau noch eine User-Entscheidung.`, {label:'analyse:deadline-baender', phase:'Analyse', schema:{type:'object', required:['baender','gates'], properties:{ baender:{type:'array', items:{type:'object', required:['band','ziele'], properties:{band:{type:'string'}, ziele:{type:'array', items:{type:'string'}}}}}, gates:{type:'array', items:{type:'string'}}, offene_design_frage:{type:'array', items:{type:'string'}} }}, model:'opus', effort:'high'}),
])
log(`Analyse fertig: ${kollision?.pakete?.length||0} Pakete, ${abhaeng?.kritischer_pfad?.length||0}-Schritt-Kritischer-Pfad`)

phase('Plan-Synthese')
const plan = await agent(`Du bist Software-Architekt + Projektmanager der Diplomarbeit (Deadline 28.07.2026). Entwickle aus den drei Analysen einen ELABORIERTEN SEQUENTIELLEN AUSFUEHRUNGSPLAN, der je sequentiellem Schritt die disjunkte Arbeit auf MOEGLICHST VIELE PARALLELE AGENTEN verteilt. Der Plan geht an den User zur FREIGABE.

DATEI-DISJUNKTHEIT (Parallelisierungs-Grenzen):
${JSON.stringify(kollision, null, 1)}

ABHAENGIGKEITSKETTE + KRITISCHER PFAD:
${JSON.stringify(abhaeng, null, 1)}

DEADLINE-BAENDER + GATES:
${JSON.stringify(deadline, null, 1)}

ERZEUGE einen Markdown-Session-Plan mit dieser Struktur:
1. **## Ziel & Rahmen** — Deadline 28.07., der kritische Pfad in 2-3 Saetzen, das Parallelisierungs-Prinzip (sequentielle Schritte, je Schritt disjunkte Agenten).
2. **## Sequenz der Schritte** — nummerierte Schritte S1..Sn in Ausfuehrungs-Reihenfolge. JE Schritt:
   - **Ziel des Schritts** + welches Deadline-Band.
   - **Parallele Agenten-Pakete** (Tabelle: Agent-Paket | Kern-Dateien (Owner) | Deliverable | Verifikation). NUR datei-DISJUNKTE Pakete im selben Schritt; kollidierende Pakete in AUFEINANDERFOLGENDE Schritte. Nenne die Agenten-Zahl je Schritt.
   - **Gate am Schritt-Ende** (Integrations-Kadenz cf22+ctest+Mojibake+super-Sub-Build+Dual-Push+CI-gruen; wo noetig User-GO / ABI-golden-Regen).
   - **Blockiert-durch / Voraussetzung** (welcher Vorschritt).
3. **## Kritischer-Pfad-Markierung** — welche Schritte auf dem kritischen Pfad zur 28.07. liegen (duerfen nicht slippen) vs. welche Nebenstraenge parallel mitlaufen.
4. **## Gates & Entscheidungen** — die User-GO-Punkte, ABI/golden-Regen-Fenster, CI-hart-gruen-Checkpoints; + eine kurze Liste offener User-Entscheidungen, die VOR bestimmten Schritten noetig sind.
5. **## Delegations-Strategie** — welcher Agent-Typ je Paket (Opus-Impl-Agent / Explore / Konformitaet), Owner-Regeln fuer geteilte Dateien, wie Kollisionen vermieden werden (der Manager integriert je Schritt selbst).
6. **## Risiken & Fallbacks** — die 3-4 groessten Risiken (Mess-Vollzug-Komplexitaet, ABI-golden-Bruch, Storage-Infra-gated, Zeit) + Fallback je Risiko.

WICHTIG: Der erste Schritt MUSS der P-TOTAL-forward-Fix sein (blockiert den echten Voll-Build, unmittelbar). Der Plan muss ehrlich sein: was ist bis 24.07. schaffbar, was bis 28.07., was rutscht auf ab-01.08./nach-Abgabe. Realistische Agenten-Zahlen (max ~4-6 parallel je Schritt wegen Runner-/Review-Kapazitaet). Gib NUR den Markdown-Plan zurueck (ab '## Ziel & Rahmen'), ASCII + deutsche Umlaute ok. Keine Vorrede.`, {label:'synthese:session-plan', phase:'Plan-Synthese', model:'opus', effort:'high'})

return { plan }