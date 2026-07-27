export const meta = {
  name: 'e4prime-cor-filter-chain-design',
  description: 'Deep-Research: CoR-Filterkette (GoF) im CacheEngineBuilder fuer die Tier-Binary-Generierungs-Kontrolle (Doc 20 §C), compile-time',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Critique' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const IST = `IST-VERIFIKATION (belegt, Basis):
ZIEL (Doc 20 §C, ${SUP}/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md:41-46): die Auswertungen ergeben automatisch eine FILTERKETTE; das Pattern **Chain of Responsibility (GoF)** wird STRIKT im CacheEngineBuilder-Bereich fuer die KONTROLLE der Tier-Binary-GENERIERUNG umgesetzt (Auswertung → Filter → welche Permutationen werden als Naechstes gebaut/verworfen). IST: "0 Code-Treffer" (§E:66) — die CoR existiert NICHT; CEB-Bausteine existieren.
ANKER-BAUSTEINE (${CE}/libs/cache_engine/builder/): build_orchestrator/build_orchestrator.hpp (BuildConfig:54, BuildJob:86, BuildResult:95, BuildStats:105, class BuildOrchestrator:182 — die Generierungs-/Provisionierungs-Maschinerie); best_binary_selector/best_binary_selector.hpp (MeasurementRow:79, enum Metric:93 {ns_per_op,insert,lookup,erase,scan,rmw}, RankingCriterion:118, RankedBinary:135, TiereDllRepository:153 — die Auswertung/Ranking); cacheline_policy/cacheline_policy_selector.hpp (WorkloadProfileAggregate:61, ScanOptimizing:141, LatencyOptimizing:180 — Strategy-Pattern-Vorbild fuer policy).
Doc 20 §D (Messfehler-Erkennung, relevant fuer Filter-Kriterien): 3-Varianten-Observer + komplementaerer 4. Schritt: die untergebenen Heuristik-Tier-Binaries werden OHNE Mikro-/Makro-Benchmarks+Observer neu gebaut, Vergleich rein an Wall-Clock gegen alle Permutationen UND bekannte Paper-Algorithmen — **der Paper-Vergleich geht VOR** (Vorrang in die Auswertungs-Reihenfolge kodieren).
GRENZEN (TABU): golden_fullpilot_320/permutation_axes.xml/POD sizeof==1416/GenusBindingTraits/ABI-MAJOR==4/Registry-mp_list UNBERUEHRT. Metaprogrammierung: compile-time-strikt wo Hot-Path (§C: zero-cost/compile-time), kein Runtime-Switch/vtable im Hot-Path; ABER die CoR ist Generierungs-Steuerung (cold-path/build-time) — hier ist eine klassische CoR mit Handler-Objekten zulaessig, solange sie nicht im gemessenen Hot-Path liegt. Nur benannte Design-Patterns (CoR = GoF). Monolith-first (Doc 20 §A). Selbst-Impl.`

const RSCHEMA = { type:'object', additionalProperties:false, required:['findings','open_questions'], properties:{
  findings:{type:'array',items:{type:'object',additionalProperties:false,required:['q','a','evidence'],properties:{q:{type:'string'},a:{type:'string'},evidence:{type:'string'}}}},
  open_questions:{type:'array',items:{type:'string'}}}}

phase('Research')
const research = await parallel([
  () => agent(`Du bist CEB-Flow-Forscher. Lies ${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp + best_binary_selector/best_binary_selector.hpp + cacheline_policy/cacheline_policy_selector.hpp.
BEANTWORTE (datei:zeile): (1) Wie fliesst heute die Auswertung (best_binary_selector Ranking) in die Generierung (build_orchestrator BuildJob/provision)? Gibt es einen Punkt, wo aus einer Menge Permutations-Kandidaten eine Teilmenge zum Bauen ausgewaehlt wird (der natuerliche CoR-Einbauort)? (2) Welche Datentypen sind der CoR-Kandidat (BuildJob/BuildConfig/eine Permutation/binary_id) und was traegt die Auswertung (RankedBinary/MeasurementRow) an Kriterien? (3) Gibt es bereits eine Selektions-/Filter-Logik (select/reject/provision_all view+selection), die die CoR ersetzen/kapseln wuerde? (4) Ist der CoR-Einbau cold-path (build-time, klassische Handler-Objekte ok) oder beruehrt er den gemessenen Hot-Path (dann compile-time-strikt)? ${IST}`,
    { label:'research:ceb-flow', phase:'Research', schema:RSCHEMA, effort:'high' }),
  () => agent(`Du bist CoR-Handler-Forscher (Thesis-Sinn). Aus Doc 20 §C/§D + dem Diplomarbeits-Ziel (heuristische Tier-Binary-Auswahl, Paper-Vergleich-Vorrang) leite ab, WELCHE Filter-Glieder (CoR-Handler) die Kette haben MUSS und mit welchen Pass/Reject-Kriterien. Lies ${SUP}/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md (§C:41-46, §D:47-57) + ${SUP}/docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md (Kontext). BEANTWORTE: (1) Welche konkreten Filter-Glieder ergeben sich aus der Auswertungs-Logik (z.B. Dominanz-/Pareto-Filter, bereits-gebaut-Filter, schlechter-als-Paper-Filter, Ressourcen-Budget-Filter)? Benenne 3-6 Handler mit Kriterium — NUR aus Doc 20/21 + Bestand ableitbar, NICHT erfinden. (2) Wie kodiert die Kette den Paper-Vergleich-Vorrang (§D: Paper geht vor)? (3) Reihenfolge der Handler (CoR = geordnete Kette)? (4) Was ist das Handler-Interface (Kandidat rein → {pass/reject/pass-to-next} + Begruendung)? (5) Ist die Kette compile-time-statisch (Typ-Liste von Handlern) oder runtime-konfigurierbar? ${IST}`,
    { label:'research:cor-handlers', phase:'Research', schema:RSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

phase('Design')
const DSCHEMA = { type:'object', additionalProperties:false, required:['recommendation','handlers','handler_interface','chain_mechanism','integration_point','change_surface','boundary_compliance','risks'], properties:{
  recommendation:{type:'string'}, handlers:{type:'array',items:{type:'string',description:'Handler-Name + Kriterium'}}, handler_interface:{type:'string'},
  chain_mechanism:{type:'string',description:'compile-time Typ-Liste vs runtime; CoR-Verkettung'}, integration_point:{type:'string',description:'datei:zeile wo die Kette einhaengt'},
  change_surface:{type:'array',items:{type:'string'}}, boundary_compliance:{type:'string'}, risks:{type:'array',items:{type:'string'}}}}
const design = await agent(`Design-Synthesizer. Aus der Research: das SAUBERSTE, benannte-Pattern-treue (CoR/GoF), boundary-konforme Design fuer die Filterkette im CEB. Entscheide: Handler-Set (3-6, nur ableitbar), Handler-Interface, Ketten-Mechanismus (compile-time Typ-Liste bevorzugt wenn zero-cost gefordert), Integrations-Punkt, minimale Change-Surface (datei:zeile), einen EIGENSTAENDIGEN ersten Slice (die Kette + 1-2 Kern-Handler + Unit-Test), boundary-compliance. Wenn zu gross fuer einen Increment: kleinsten sinnvollen Slice.
RESEARCH:\n${JSON.stringify(research,null,1)}\n${IST}`, { label:'design:synth', phase:'Design', schema:DSCHEMA, effort:'high' })

phase('Critique')
const CSCHEMA = { type:'object', additionalProperties:false, required:['verdict','issues'], properties:{
  verdict:{type:'string',enum:['SOUND','NEEDS-REVISION','TOO-RISKY']}, issues:{type:'array',items:{type:'object',additionalProperties:false,required:['severity','issue'],properties:{severity:{type:'string',enum:['blocker','major','minor']},issue:{type:'string'}}}}}}
const critiques = await parallel([
  () => agent(`ADVERSARIAL Thesis-Fit: Sind die Handler + Kriterien WIRKLICH aus Doc 20 §C/§D + dem Diplomarbeits-Ziel abgeleitet (nicht erfunden)? Ist der Paper-Vergleich-Vorrang (§D) korrekt kodiert? Filtert die Kette tatsaechlich die GENERIERUNG (welche Permutationen gebaut werden), oder verwechselt sie das mit der finalen Auswahl (best_binary_selector)? Ist es ein echter CoR (geordnete Handler, jeder pass/reject/forward) oder nur ein umbenannter if-else? Jede Luecke: major/blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:thesis', phase:'Critique', schema:CSCHEMA, effort:'high' }),
  () => agent(`ADVERSARIAL Boundary/Bau: golden/POD/mp_list/ABI beruehrt? Ist die Change-Surface an realen datei:zeile (keine Phantom-Zeilen)? Kompiliert der Vorschlag (Typen existieren)? Ist der compile-time-Anspruch erfuellt wo Hot-Path, ODER liegt die CoR im cold-path (dann Handler-Objekte ok)? Bricht der Integrations-Punkt bestehende build_orchestrator/best_binary_selector-Consumer? Ist der erste Slice eigenstaendig testbar (Unit-Test ohne Cluster-Daten)? Jede Verletzung: blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:boundary', phase:'Critique', schema:CSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

return { research, design, critiques }
