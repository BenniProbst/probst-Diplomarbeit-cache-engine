export const meta = {
  name: 'sessions-plaene-architektur-voll-audit',
  description: 'Letzte 10 Sessions + Pläne + Architektur auf Bugs, Design-Konflikte, fehlerhafte Annahmen — adversarial verifiziert',
  phases: [
    { title: 'Find', detail: '6 Dimensionen parallel' },
    { title: 'Verify', detail: 'jeden Befund adversarial refuten' },
    { title: 'Synthese', detail: 'konsolidierter Befund-Bericht' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PRT = SUPER + '/Code/external/comdare-prt-art'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

const CANON = `
KANON (bindend, §0-GOAL-V5 + Memories): honest-100% (kein Phantom, honest-0 nur wo genuin 0) · Metaprog compile-time-only im Hot-Path (CRTP+Concepts, kein Runtime-Switch/vtable, benannte Patterns) · WAS/WIE (ce=Framework, super=Definition) · Baseline-Layering n→n-1 (common referenziert NIE cache_engine) · TABU: permutation_axes.xml/golden_fullpilot_320/CatalogAxes<4,4,5,4>=320/POD-1416/ABI-4/GenusBindingTraits/Registry-mp_list (einzige Ausnahme #37-Scheduling, Design-Gate) · Doku/Messdaten nie löschen · W4-Gate: Mess-Pfad NUR reale Katalog-DLLs (IObservableTier), NIE PrtArtHashBackend/unordered_map-Surrogat · 2 Registry-XMLs gleichen Schemas + 1 Experiment-XML (keine Bausteine in der Experiment-XML) · Parser=ce-Modul · v32→Strategy · CEB=zentrale C++-App (Tier-Binaries ZUR LAUFZEIT, nicht CMake) · prt-art=separater Prüfling · INERT-by-default (COMDARE_V32_DRIVER_ENABLE OFF ⇒ Default-Build byte-identisch).`

const FINDINGS = {
  type: 'object',
  properties: {
    dimension: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: {
      kind: { type: 'string', enum: ['bug','design-conflict','wrong-assumption','untracked-promise','stale-doc'] },
      title: { type: 'string' },
      location: { type: 'string', description: 'datei:zeile bzw. Ledger-§/Doc' },
      detail: { type: 'string', description: 'präzise, mit wörtlichem Beleg' },
      severity: { type: 'string', enum: ['high','med','low'] },
      fix_sketch: { type: 'string' },
      autonomous: { type: 'boolean', description: 'true = golden-/ABI-neutral autonom fixbar' },
    }, required: ['kind','title','location','detail','severity'] } },
  },
  required: ['dimension','findings'],
}
const VERDICT = { type:'object', properties:{
  confirmed:{type:'boolean'}, reason:{type:'string'},
  corrected_severity:{type:'string',enum:['high','med','low','drop']},
}, required:['confirmed','reason','corrected_severity'] }

const DIMS = [
  { key:'super-neu-code', prompt:
`BUG-HUNT im NEUEN super-Code der A-H-Welle (Repo ${SUPER}). Dateien KOMPLETT lesen und adversarial auf BUGS + FEHLERHAFTE ANNAHMEN prüfen:
- Code/02_messung_driver/v32_katalog_driver.hpp (INC-F: reale Katalog-Tier EE-A/EE-B, Prüfdock-Gate, Welch)
- Code/02_messung_driver/v32_messreihe_antrieb.hpp (INC-G: parse→validate→Strategy→Treiber→Report; Seed je (phase,op); mode-Steuerung)
- Code/02_messung_driver/experiment_phase_strategy.hpp (INC-E: Strategy/CRTP/Concept)
- Code/02_messung_driver/messreihe_report_exporter.hpp (INC-H: 12-Spalten-CSV + TikZ, \${date}-Auflösung, Parent-Dirs)
- der INERT-Andock in Code/02_messung_driver/main.cpp (Doppel-Gate + env)
Suchschwerpunkte: Off-by-one/Seed-Kollisionen, CSV-Escaping/Format-Drift vs. Konsument, \${date}-Semantik (Zeitzone/Format/FS-sicher), Pfad-Traversal/relative-Pfad-Annahmen, Report-Akkumulation (Doppelzählung/Verlust bei Fehler), Fehlerpfade (throw vs. exit-Code), stille Fallbacks (Behelfsweg-Verbot), Strategy-Dispatch-Korrektheit (Stufe↔Composition-Mapping), W4-Regressionen. ${CANON}` },
  { key:'ce-neu-code', prompt:
`BUG-HUNT im NEUEN ce-Code der A-H-Welle + R-E (Repo ${CE}). Dateien KOMPLETT lesen, adversarial:
- libs/common/serialization/xml_config_parser/* (INC-D parse_experiment_profile: Layering common→NIE cache_engine, String-Handling, fehlende Felder, Doppel-Elemente, Entity-Decoding)
- libs/cache_engine/profile_facade/validate_profile.hpp (Validierungs-Lücken: was wird NICHT geprüft, das der Antrieb annimmt?)
- tools/axis_registry_gen/main.cpp (INC-A: Enabled*-Bindung, header-via-HasOrganLocation, Escaping im XML-Output, Determinismus)
- libs/cache_engine/anatomy/organ_location.hpp (Makro-Hygiene)
- libs/cache_engine/compositions/prt_art_merge_reference.hpp + profile_facade/sota_catalog.hpp Stufe2-Zweig (M-CE-10-Fix: per-Host korrekt? prt_art/unknown→nullopt-Annahme?)
- .gitlab-ci.yml contract:profile_coverage-Job (R-E: baut+führt der Job wirklich genau das, was der Regex selektiert? LABELS-Wechselwirkung mit test:unit -LE?)
Suchschwerpunkte: Parser-Annahmen vs. Schema (XSD erlaubt X, Parser crasht/ignoriert), Validierungs-Lücken (prt-art-Registry wird gegen was validiert?), Registry-Determinismus, stille Wahrheits-Drift zwischen XSD/Golden-XML/Parser/Validator. ${CANON}` },
  { key:'registry-wahrheit', prompt:
`REGISTRY-WAHRHEITS-AUDIT (Repos ${CE} + ${PRT}). Prüfe die 2 Registry-XMLs gegen den realen Code:
- ${CE}/libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (90 Bausteine): Stichprobe ≥15 Bausteine quer über Achsen — existiert das header-Attribut-File wirklich? Stimmt cpp_type (wrapper) mit dem echten Typ überein? golden_wired="true" nur für die 4 golden-Achsen-Varianten (search_algo/node_type/memory_layout/prefetch, 4×4×5×4)? enabled synchron zu Enabled*-Listen?
- ${PRT}/prt_art/algorithm_profiles/prt_art_axis_registry.xml (5 Slots): header existent, golden_wired nur path_compression?
- Cross-Schema: sind BEIDE Registries wirklich schema-identisch (Attribut-Set, Reihenfolge-Konventionen)? Validiert irgendwas die prt-art-Registry (validate_experiment_profile prüft laut INC-D nur die ce-Registry-Varianten!)?
- TABU-Frage aus V5.8: ist permutation_axes.xml faktisch redundant zur ce-Registry (Informations-Überlappung) — dokumentierter Klärstand? ${CANON}` },
  { key:'konsolidat-widersprueche', prompt:
`KONSOLIDAT-WIDERSPRUCHS-AUDIT im Ledger ${LEDGER}. Lies §0-GOAL-V5 (Z.75-121), §11 (Z.279-354), §11-I (Z.355-365), §14 (Z.1102-1165), §15 (Z.1166-1216) + grep gezielt in §12. Finde fehlerhafte Annahmen/Widersprüche:
(1) TASK-NUMMERN-CHAOS #35-#40: der autoritative Fork-Entscheid (§12 2026-07-13, ~Z.385) definiert #35=defer-mark, #36=Bit-Bank-Tilgung (DONE ce ebcc5498), #37=Scheduling A+B (TABU-GO), #38=consolidate, #39=xml→pdf-HAUPT-ZIEL, #40=Dead-Code-Reklassifizierung. Prüfe ALLE späteren Stellen (§15.5:1202 „#36-Scheduling", V5.8 „#36 vs #37 uneindeutig", G2-Eintrag Z.368 „q1-is-original→#37") auf Falsch-Zuordnungen. Liste jede falsche Stelle.
(2) VERLORENE §14.1-GATES: die 9 Gates (G-Q2/G-234V-a/b/G-6v48/G-7b3/G-270a/G-AP15/G-274/G-268) — welche sind durch spätere Entscheide erledigt/supersediert (belegen!), welche sind ECHT NOCH OFFEN und fehlen in V5/§15/Board?
(3) §11-B/C-AP-Reihen: Status je AP-Punkt gegen §12 — was ist der reale Rest?
(4) weitere stale Sätze, die nach V5 irreführen (z.B. §11-B-Runway = BLOCKER-6-bekannt; noch mehr?). ${CANON}` },
  { key:'sessions-backups', prompt:
`SESSION-BACKUP-SWEEP (Repo ${SUPER}). Liste docs/sessions/backups/2026071*/ + docs/sessions/202607{09..15}* (ls). Lies je Verzeichnis die Haupt-Synthese/DOSSIER/README (nicht Rohdaten). Finde UNERLEDIGTE ZUSAGEN + VERGESSENE PUNKTE der letzten ~10 Sessions, die weder im Ledger §15 noch in §11 noch als DONE in §12 auftauchen: „Folge-Increment", „offen", „deferred", „nach GO", „TODO" — jeweils prüfen (grep im Ledger), ob getrackt. Melde NUR echte Lücken (untracked-promise) mit Quelle datei:zeile. Ignoriere alles, was in §14.1/§15.3-15.5 bereits steht. ${CANON}` },
  { key:'architektur-in-sich', prompt:
`DESIGN-KONFLIKT-AUDIT der NEUEN Architektur IN SICH (nicht R1-R11-Alignment — das lief schon). Repos ${SUPER} + ${CE}. Prüfe konzeptionelle Konflikte:
(1) CEB-Laufzeit-Bau-Anspruch (Tier-Binaries ZUR LAUFZEIT, C++-orchestriert) vs. IST (INC-F treibt compile-time-Kompositionen im selben Binary, KEIN Laufzeit-Compiler-Aufruf; CacheEngineBuilder/profile_facade baut DLLs wie?) — ist der Weg dorthin definiert oder klafft eine unbenannte Lücke zwischen §15.1-Anspruch und INC-F-Realität? (Lies v32_katalog_driver.hpp-Kopf + profile_facade/sota_catalog-Rendering + builder/-Bereich.)
(2) W4 vs. Exporter: messreihe_report_exporter.hpp inkludiert v32_orchestrator.hpp (transitiv, für Strukturen) — Surrogat NIE instanziiert, aber: ist das eine tickende Regression (jemand ruft es doch)? Gibt es einen Guard/static_assert dagegen?
(3) Zwei-Registry-Modell vs. permutation_axes.xml: doppelte Wahrheit? Wer ist Master für „welche Bausteine existieren" — Enabled*-mp_lists (Code), permutation_axes.xml (TABU), cache_engine_axis_registry.xml (generiert)? Drift-Gefahr benannt?
(4) Experiment-XML axes_default_lookup/allowed_variants vs. golden-320-Achsenraum: konsistent?
(5) INERT-Design: COMDARE_V32_DRIVER_ENABLE (Build-Option) + COMDARE_MEASUREMENT_ON + env COMDARE_RUN_V32_EXPERIMENT — ist die Gate-Kette dokumentiert-konsistent (wer setzt was wann), oder gibt es tote/widersprüchliche Kombinationen? ${CANON}` },
  { key:'ledger-kontinuitaet-4repos', prompt:
`4-REPO-LEDGER-KONTINUITÄTS-AUDIT. Die 4 Projekte: super (${SUPER}, Ledger ${LEDGER} = autoritativ), ce (${CE}, ZWEI ältere Ledger: docs/sessions/architektur-ziele-offene-punkte-ledger.md [Stand 06-01] + docs/sessions/goal-v6-luecken-ledger.md [Stand 06-03]), prt-art (${PRT}, KEIN Ledger), thesis (KEIN Ledger).
AUFGABE: Lies die OFFENEN Abschnitte der beiden ce-Ledger (§(b) extern-blockiert / §(c) user-manuell / §(d) V42 / L-BACKLOG / GATE-MAXIMAL-Residuals) und prüfe je offenen Punkt per grep im super-Ledger + gegen bekannte Fakten, ob er (a) dort WEITERLEBT (getrackt — Beleg), (b) SUPERSEDIERT ist (z.B. ZIH-Strecke → eigener comdare-Cluster; 6 modules/-Spiegel gelöscht per Memory; PMC→#26/#152 im super-Ledger; Vendor-Linking→#19; F.6-Phase-C→Habich-Termin) aber im ce-Ledger UNMARKIERT stale steht, oder (c) VERLOREN ging (nirgends getrackt = untracked-promise).
Kandidaten u.a.: A1/A2.1/E2 Vendor-Allokatoren · R5.D/PMC · C1/C2 Cluster/Grace-Hopper · E10.6/E10.7 Cluster-Layout · E11-Facade/#22-Submodule (Memory sagt: 6 Pseudo-Spiegel GELÖSCHT, comdare-*-all nutzen) · F.6-Phase-C 23-Header-Löschung (Habich-Termin) · Doku-11/14-Verif · ctest-gtest-Enumeration-CMake-4.2-Artefakt (test_pressure_state[1]_include — heute noch real? super-CI fährt ctest!) · L-BACKLOG (axis_05-IMC, AVX-512-Sub-Flags VNNI/BF16/FP16, s4-echtes-Linking) · GATE-MAXIMAL-ZIH (apptainer/sbatch/Webhook — durch eigenen Cluster ersetzt?) · V5-I0 (Mehr-Achsen real treiben — durch L-74c erledigt?) · V5-I6-Rest · V5-I-Drive-Vollausbau · Naming-Refactor-Backlog · D1/D2 user-manuell.
Melde je Punkt: weiterlebt(wo)/superseded-unmarkiert(stale-doc)/verloren(untracked-promise). ${CANON}` },
]

phase('Find')
log(`Voll-Audit: ${DIMS.length} Dimensionen`)
const found = await pipeline(
  DIMS,
  d => agent(d.prompt + `\nGib strukturierte Befunde zurück (nur ECHTE Befunde, keine Stil-Nits; jede Behauptung mit wörtlichem Beleg).`,
             { label:`find:${d.key}`, phase:'Find', schema: FINDINGS }),
  (res, d) => {
    if (!res || !res.findings || !res.findings.length) return { dim:d.key, verified:[] }
    return parallel(res.findings.map(f => () =>
      agent(`Du bist SKEPTISCHER Refuter. Default = confirmed:false wenn nicht positiv belegbar.\nBEFUND (${d.key}):\n`+JSON.stringify(f,null,1)+
            `\nÖffne die zitierte Stelle selbst (Repos: ${SUPER} / ${CE} / ${PRT}; Ledger ${LEDGER}), prüfe: (a) existiert das Problem WIRKLICH im Ist (nicht schon gefixt/anders gelöst), (b) ist es gegen den Kanon wirklich ein Konflikt/Bug (nicht bewusstes dokumentiertes Design), (c) severity korrekt? ${CANON}\nGib Verdikt zurück.`,
            { label:`verify:${d.key}:${(f.title||'').slice(0,30)}`, phase:'Verify', schema: VERDICT })
        .then(v => ({ ...f, _dim:d.key, _v:v })).catch(()=>null)
    ))
  }
)

const confirmed = []
for (const r of found) {
  const arr = Array.isArray(r) ? r : []
  for (const it of arr) {
    if (it && it._v && it._v.confirmed && it._v.corrected_severity !== 'drop')
      confirmed.push({ ...it, severity: it._v.corrected_severity })
  }
}
log(`Bestätigt: ${confirmed.length} Befunde`)

phase('Synthese')
const synth = await agent(
  `Chef-Auditor-Synthese. Bestätigte Befunde des Voll-Audits (letzte 10 Sessions/Pläne/Architektur):\n`+
  JSON.stringify(confirmed,null,1)+`\n${CANON}\n`+
  `Erstelle einen dichten Markdown-Bericht: (1) Tabelle aller Befunde (Kind/Ort/Severity/autonom-fixbar). (2) Die AUTONOM fixbaren (golden-/ABI-neutral) in Fix-Reihenfolge mit konkretem Ansatz. (3) Die USER-vorzulegenden (Design-Konflikte/ABI). (4) Ledger-Nachzieh-Liste (stale Stellen additiv markieren). (5) Gesamt-Verdikt: wie gesund sind Sessions/Pläne/Architektur? Jede Zeile belegt.`,
  { label:'synthese', phase:'Synthese' })
return { confirmed_count: confirmed.length, confirmed, synthesis: synth }
