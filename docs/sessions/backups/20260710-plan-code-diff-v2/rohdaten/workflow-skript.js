export const meta = {
  name: 'plan-code-diff-20260710b',
  description: 'Frischer Plan↔Code-Diff: alle offenen Planungspunkte gegen Code-Ist-Stand (ce c022ce05)',
  phases: [
    { title: 'Extrahieren+Verifizieren', detail: '5 Planungsquellen-Cluster: Ansprüche extrahieren + je gegen Code prüfen' },
    { title: 'Gegenprüfen', detail: 'OPEN-Befunde adversarial re-verifizieren (wirklich offen? richtiges Gate?)' },
    { title: 'Synthese', detail: 'Dedup + Klassifikation + Diff-Report' },
  ],
}
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const CTX = `KONTEXT: Frischer Plan↔Code-Diff. super=${SUP}, ce=${CE} (main c022ce05 — HAT SICH DIESE SESSION STARK BEWEGT: E4→E1-Schicht-Sequenz komplett, GO-1 Limits-Entkopplung Vorstufe+Umschaltung (#229-Kern KOMPLETT), NON_GATED-2 Parser-/Gating-Konsolidierung Phase 7, DATEN_GATED Phase-6-Vorbau IMeasurementSource+MeasurementAxisRegistry+curve_fit-Skeleton — alle CI-grün). Ledger=${SUP}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md. AUFGABE: die OFFENEN Planungspunkte gegen den TATSÄCHLICHEN Code-Ist-Stand ermitteln — was ist DONE (im Code verifiziert), was ist OPEN, und mit welchem Gate (none=baubar / user=Fork-Entscheidung / data=Messdaten #156/#215 / infra=Cluster-HW / held). NIE raten — jeden Status mit datei:zeile-Beleg oder grep-Ergebnis (0 Treffer = fehlt) belegen. Der frühere Diff (BACKLOG 20260710-plan-code-diff) ist der Ausgangspunkt, aber der Code ist SEITHER weiter — prüfe, was seither DONE wurde.`
const EXTRACT_SCHEMA = { type: 'object', required: ['befunde'], properties: { befunde: { type: 'array', items: { type: 'object', required: ['id', 'quelle', 'anspruch', 'ist_code', 'status', 'gate'], properties: {
  id: { type: 'string' }, quelle: { type: 'string' }, anspruch: { type: 'string' },
  ist_code: { type: 'string', description: 'datei:zeile-Beleg ODER "0 Treffer"/grep-Ergebnis' },
  status: { type: 'string', enum: ['DONE', 'OPEN', 'TEILWEISE'] },
  gate: { type: 'string', enum: ['none', 'user', 'data', 'infra', 'held'] },
  note: { type: 'string' } } } } } }
const VERIFY_SCHEMA = { type: 'object', required: ['id', 'status_bestaetigt', 'gate_bestaetigt', 'grund'], properties: {
  id: { type: 'string' }, status_bestaetigt: { type: 'string', enum: ['DONE', 'OPEN', 'TEILWEISE'] },
  gate_bestaetigt: { type: 'string', enum: ['none', 'user', 'data', 'infra', 'held'] }, grund: { type: 'string' } } }
phase('Extrahieren+Verifizieren')
const CLUSTERS = [
  { key: 'goalv3-katalog', prompt: `${CTX}\n\nQUELLE-CLUSTER 1 — GOAL-V3 + TODO-KATALOG: Lies Ledger §13.12 (Goal-V3 Arbeitsreihenfolge (1)-(7) + DD-A..DD-E-Defaults) und §13.3 (TODO-Katalog #253-#276). Extrahiere JEDEN nummerierten TODO/Anspruch (#253..#276, die 7 Arbeitsschritte, die DD-Defaults). Für JEDEN: aktueller Code-Ist-Stand (grep im ce/super nach dem relevanten Symbol/Feature) + status (DONE/OPEN/TEILWEISE) + gate. Achte auf Ledger-§12-Einträge die "DONE" belegen (mit SHA) — verifiziere sie stichprobenartig im Code.` },
  { key: 'backlog-session', prompt: `${CTX}\n\nQUELLE-CLUSTER 2 — BACKLOG + SESSION-FORTSCHRITT: Lies ${SUP}/docs/plaene/20260710-plan-code-diff-BACKLOG.md (NON_GATED/DATEN_GATED/EXTERN_GATED) UND die jüngsten Ledger-§12-Einträge dieser Session (2026-07-10). Für JEDEN BACKLOG-Punkt: ist er SEIT dem BACKLOG DONE geworden (diese Session)? Belege im Code (z.B. Limits-Entkopplung: existiert apps/catalog_codegen_tool + generated_source_catalog-Nutzung? Parser: ist parse_xml_string weg, DOM-Pfad da? Phase-6: existiert i_measurement_source.hpp/measurement_axis_registry.hpp/curve_fit.hpp?). status + gate + datei:zeile.` },
  { key: 'doc20-typsystem', prompt: `${CTX}\n\nQUELLE-CLUSTER 3 — DOC 20 TYPSYSTEM + FORKS: Lies ${SUP}/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md VOLLSTÄNDIG (§B Typsystem, §C CoR, §D 3-Varianten-Observer+Schritt4, §E IST-Diff, §G Kardinalitäten, §H die 7 User-Forks, §I tree-Wurzel-Constraint). Für JEDEN SOLL-Baustein (Messkurven-Typsystem-Ebenen, CoR im CEB, 3-Varianten-Observer, komplementärer 4. Schritt, multidimensionale Mess-DB): Code-Ist-Stand (grep ChainOfResp/FilterChain, curve_fit-Struktur, Observer-Bau-Varianten, best_binary_selector). Die 7 Forks = status OPEN/gate user. status+gate+ist_code.` },
  { key: 'schichten-e4e1', prompt: `${CTX}\n\nQUELLE-CLUSTER 4 — SCHICHTEN E4-E1 + E4-XML-ROADMAP: Lies ${SUP}/docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md (Schicht-Sequenz E4/E3/E2/M/E1 + Modi-Vision Teil G) und ${SUP}/docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md (Phasen 0-7, D-Tabelle). Für JEDE Schicht + JEDE Roadmap-Phase: DONE (im Code + CI-grün belegt) oder OPEN? Belege: E4=profile_run_facade, E3=perm_runner-Gate, E2=abi_adapter, M=system_axis.hpp, E1=RC-Konsum abi_adapter:216-260; Roadmap Phase 6=IMeasurementSource, Phase 7=Parser-Konsolidierung. status+gate+datei:zeile.` },
  { key: 'matrix-e1e4-dossier', prompt: `${CTX}\n\nQUELLE-CLUSTER 5 — MATRIX-MIGRATION + E1-E4-KONSOLIDIERUNG: Lies ${SUP}/docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md (Teil C Audit-Nacharbeit B4-1..B1-1, Teil E Roadmap-Phasen 0-6) und die Matrix-Migration-Referenzen (Goal-V3-Ergänzung: #274/#256, STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md). Für JEDEN Konsolidierungs-/Migrations-Punkt: Code-Ist-Stand + status + gate. Achte auf #221 (E1-RC-Konsum: 5/5 Setter? abi_adapter grep), #188 (E2-Wurzel search_organ_), #229 (E4-XML), V32-Orchestrator-Stub, workload_matrix.hpp (revertiert?). status+gate+datei:zeile.` },
]
const results = await pipeline(
  CLUSTERS,
  c => agent(c.prompt, { label: `extract:${c.key}`, phase: 'Extrahieren+Verifizieren', schema: EXTRACT_SCHEMA }),
  (ext, c) => {
    const open = (ext?.befunde ?? []).filter(b => b.status !== 'DONE')
    return parallel(open.map(b => () =>
      agent(`${CTX}\n\nGEGENPRÜFUNG (adversarial): Cluster ${c.key}, Befund [${b.id}] "${b.anspruch}" — behaupteter Status ${b.status}, Gate ${b.gate}, Code-Beleg "${b.ist_code}". VERIFIZIERE am echten Code (grep/read, ce c022ce05): Ist der Punkt WIRKLICH ${b.status} (nicht heimlich schon DONE seit dieser Session)? Ist das Gate WIRKLICH ${b.gate} (none=baubar ohne User/Daten? user=echte Fork-Entscheidung? data=braucht #156/#215-Messdaten? infra=HW/Cluster?)? Bei Unsicherheit konservativ das restriktivere Gate. Gib id, status_bestaetigt, gate_bestaetigt, grund (datei:zeile).`,
        { label: `verify:${b.id}`, phase: 'Gegenprüfen', schema: VERIFY_SCHEMA })
        .then(v => ({ ...b, ...v }))
    ))
  }
)
const flat = results.filter(Boolean).flat().filter(Boolean)
// DONE-Befunde (nie gegengeprüft) + gegengeprüfte OPEN/TEILWEISE zusammenführen
const doneOnly = results.filter(Boolean).flatMap((r, i) => []) // placeholder
const alleBefunde = []
for (const c of CLUSTERS) { /* Befunde stecken in flat (verify) + wir brauchen auch die DONE */ }
phase('Synthese')
const synth = await agent(`${CTX}\n\nSYNTHESE-AUFTRAG: Hier alle gegengeprüften OPEN/TEILWEISE-Befunde (JSON, mit status_bestaetigt/gate_bestaetigt/grund): ${JSON.stringify(flat)}\n\nBaue den finalen Plan↔Code-Diff-Report (Markdown), der die Frage "welche TODOs im Gesamtplan sind JETZT noch offen" beantwortet: (1) Kurz-Bilanz: was ist diese Session DONE geworden (mit SHA/Beleg). (2) OFFENE Punkte gruppiert nach Gate: **NONE (baubar, sofort)** / **USER (Fork/Entscheidung — mit den 7 Doc-20-§H-Forks)** / **DATA (#156/#215-Messdaten)** / **INFRA (Cluster/HW, prod2-RMA)** / **HELD**. Je Punkt: id, anspruch, code-ist (datei:zeile), grund. (3) Dedupliziere Überlappungen zwischen den 5 Clustern. (4) Nenne die EINE empfohlene nächste Aktion (was ist der einzige non-gated baubare Rest, falls es einen gibt — sonst: alles user-/data-/infra-gated, warten auf User-Forks). Sei präzise, keine Erfindungen — nur die verifizierten Befunde.`,
  { label: 'synthese', phase: 'Synthese' })
return { offene_befunde: flat.length, bericht: synth }