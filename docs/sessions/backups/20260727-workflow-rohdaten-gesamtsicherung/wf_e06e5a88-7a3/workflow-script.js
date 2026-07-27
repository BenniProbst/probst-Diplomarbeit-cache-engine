export const meta = {
  name: 'forgotten-todo-sweep',
  description: 'Tiefer multi-modaler Sweep nach vergessenen/geplant-aber-ungetrackten TODOs über alle Diplomarbeit-Quellen',
  phases: [
    { title: 'Sweep', detail: '8 Modalitäts-Agenten (Ledger/Dossiers/Plan/Memory/Code-TODOs/Review/Board/Thesis) + Completeness-Kritiker' },
    { title: 'Verify', detail: 'je Kandidat adversarial: wirklich vergessen (geplant+nicht getan+ungetrackt)?' },
    { title: 'Synthese', detail: 'konsolidierte Forgotten-Liste → Goal-V4-Stufen-Mapping + Backup' },
  ],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const PRT = ROOT + '/Code/external/comdare-prt-art'
const TH = ROOT + '/thesis/diplomarbeit'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

// Kontext: was IST getrackt (damit die Agenten nur WIRKLICH Vergessenes melden)
const TRACKED = `BEREITS GETRACKT (NICHT als vergessen melden):
- Task-Board (aktiv): #1 F-B ✅ · #2 GO-5-Forks ✅ · #3 GO-2-Codegen ✅ · #4 Messlauf-Strecke (pending) · #5 Aufraeum-Profile ✅ · #6 mimalloc ✅ · #7 Review-Auswertung + measurement-all-Facade-Migration (pending).
- Goal-V4-Stack (§0, gerade geschrieben): G1 CI-gruen · G2 Review-P1-Mess-Integritaet · G3 Review-P2-Achsen-Korrektheit · G4 Review-P3-Aufraeum · G5 measurement-all-Facade-Migration · G6 Messlauf-Strecke · G7 genuin-gated (V32/Fork4/PE-Core/NUMA/FF0-Owner/ABI-4->5/#215/Infra-Handover) · G8 Abgabe-Blocker.
- Voll-Review 368 Findings (docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md) = Quelle von G2/G3/G4.
VERGESSEN = geplant/versprochen/angefangen IRGENDWO, aber (a) nicht erledigt UND (b) in KEINEM der obigen Tracker.`

const SWEEP = `Du suchst VERGESSENE TODOs der Diplomarbeit (comdare cache-engine). Ein vergessenes TODO ist: irgendwo geplant/versprochen/als offen markiert/begonnen-aber-abgebrochen — aber NICHT im aktuellen Tracker (Task-Board/Goal-V4/Review-Bericht, s.u.) und NICHT nachweislich erledigt (§12-Log/git). Sei PRAEZISE: nenne Quelle+Zeile, den geplanten Schritt, ob er getan wurde (grep §12 / Code / git), und warum er heute ungetrackt ist. KEINE bereits-getrackten, KEINE erledigten, KEINE TABU-gewollten Dinge (permutation_axes/golden-320/POD-1416/ABI-4). Lieber 8 echte Fundstuecke als 40 weiche.\n\n${TRACKED}`

const SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    coverage_note: { type: 'string', description: 'welche Quellen gelesen (Dateizahl/Bereiche)' },
    forgotten: { type: 'array', items: {
      type: 'object', additionalProperties: false,
      properties: {
        item: { type: 'string', description: 'das vergessene TODO, konkret' },
        source_ref: { type: 'string', description: 'datei:zeile / Dok / Memory wo es geplant/versprochen wurde' },
        planned_when: { type: 'string', description: 'Datum/Kontext der Planung' },
        done_check: { type: 'string', description: 'Beleg dass NICHT getan (grep §12/Code/git-Ergebnis)' },
        why_untracked: { type: 'string' },
        suggested_stage: { type: 'string', description: 'G1..G8 oder NEU/gated' },
        severity: { type: 'string', description: 'blocker|major|minor|nice-to-have' },
      }, required: ['item','source_ref','done_check','suggested_stage','severity'],
    } },
  }, required: ['coverage_note','forgotten'],
}

const MODALITIES = [
  ['ledger-sweep', `${SWEEP}\n\nMODALITAET LEDGER: Lies ${LEDGER} VOLLSTAENDIG. Sammle JEDE Zeile mit 'OFFEN'/'TODO'/'GEPARKT'/'deferred'/'gated'/'Rest'/'Folge-'/'nachziehen'/'spaeter'/'noch nicht'/'#NNN offen'/'B?-?'/'M?->' die NICHT in Task-Board/Goal-V4 steht UND nicht via §12 als erledigt belegt ist. Besonders: §1 FF-Blocker, §2 Blocker B1-B8, §3-§9 offene Items, §11 Erweiterungen, §13 Katalog #253-#276 Rest-Items.`],
  ['session-dossiers', `${SWEEP}\n\nMODALITAET SESSION-DOCS + ARCHITEKTUR-DOSSIERS: ls ${ROOT}/docs/sessions/*.md + ${ROOT}/docs/architektur/*.md. Lies die UEBERGABE-/SESSION-/Dossier-Docs (16-22 E1-E4, MESS-METHODIK, SCHICHTEN, CI-INTERAKTIV, MATRIX-MIGRATION). Suche geplante 'naechste Schritte'/'offen'/'Roadmap-Phase'/'Folge-Increment' die nie ins Board/§12 kamen. Ignoriere reine Historie.`],
  ['plan-file-e1e4', `${SWEEP}\n\nMODALITAET PLAN-DATEI E1-E4-KONSOLIDIERUNG: Lies das Planungs-Dossier ~/.claude/plans/noble-shimmying-fairy.md (E1-E4-Ebenen-Konsolidierung, Bruch-Nachzug, #31 E4-XML). Pruefe JEDE seiner Phasen (0 Konsolidierung: E-A..E-E->DD-A..DD-E-Rename, S<->E-Kreuz-Map, 15_F7-Neufassung, WORKFLOW-4layer-Andock · 0.5 G2-Revert 88738285/4d8aedce · 4/#31 E4-XML <datasets>/<measurement_categories> · 1/#188 · 2/#221 · 3/#223 · 5/#215 · 6/#156) gegen den Ist-Code (grep ce/super) + §12: was davon wurde umgesetzt, was ist VERGESSEN? Das GO-5-Dossier hat #31-Teile gebaut (datasets/fairness) — pruefe, was vom Plan NOCH offen ist (bes. Phase-0-Doku-Konsolidierung, E-A..E-E-Rename, F7-Neufassung).`],
  ['memory-sweep', `${SWEEP}\n\nMODALITAET AGENT-MEMORIES: ls /home/comdare/.claude/projects/-home-comdare/memory/*.md. Lies die project_*- und feedback_*-Memories, die geplante Arbeit benennen (bes. project_ap15_container_gattung, project_struktur_regression, project_e1_e4, project_handout_ap1_15, feedback_thesis_divide_and_conquer, feedback_standardprozess_research_zu_product_matrix_3d). Welche benennen ein geplantes To-do, das nirgends getrackt/erledigt ist? Verifiziere gegen Code/§12 (Memories koennen stale sein).`],
  ['code-todos', `${SWEEP}\n\nMODALITAET CODE-MARKER: grep -rnE 'TODO|FIXME|HACK|XXX|@todo|\\\\bBUG\\\\b|NOCH NICHT|not implemented|nicht implementiert|STUB|Platzhalter|placeholder' in ${ROOT}/Code (super Stufen 01-09) + ${CE}/libs + ${CE}/apps + ${PRT}/src ${PRT}/include (NICHT ext/, NICHT build/, NICHT tests-fixtures). Fuer jeden Treffer: ist er ein echtes offenes To-do (nicht nur ein erklaerender Kommentar) und ungetrackt? Cluster nach Datei/Thema.`],
  ['review-crosscheck', `${SWEEP}\n\nMODALITAET REVIEW-CROSSCHECK: Lies ${ROOT}/docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md. Die 40 major sind G2/G3 zugeordnet. ABER: die 26 test-gap + 18 architecture + relevante doc-drift-Findings implizieren oft VERGESSENE Arbeit (z.B. nicht-registrierte Tests = vergessene ctest-Registrierung; architecture-Findings = unvollendete Umbauten). Extrahiere die test-gap/architecture-Findings, die eine EIGENE vergessene Aufgabe sind (nicht nur ein Einzeiler-Fix in G3).`],
  ['board-ledger-recon', `${SWEEP}\n\nMODALITAET BOARD<->LEDGER-RECONCILIATION: Vergleiche das Task-Board (7 Tasks, s.o.) + §1 FF0-FF4-Tasks + §2 Blocker B1-B8 + §13-Katalog #253-#276 gegen §12-Erledigt-Log. Finde: (a) FF-Blocker die offen sind aber in keiner G-Stufe/keinem Task landen (bes. FF0-Owner, AP-2/#236, #162, #178, AP-9/#243-Provenance, #165 quality_flag), (b) #NNN die im Ledger 'in_progress'/'offen' stehen aber weder erledigt noch getrackt sind. Lies ${LEDGER} §1/§2/§13 + grep die #NNN gegen §12.`],
  ['thesis-gaps', `${SWEEP}\n\nMODALITAET THESIS-LUECKEN: In ${TH}: grep -rnE 'TODO|\\\\\\\\todo|TBD|FIXME|Platzhalter|\\\\\\\\missingfigure|XXX|noch (zu|nicht)|ausstehend' in kapitel/ + anhang/ + aufgabenstellung. Plus: leere/Stub-Anhaenge (B_code_structure/E_* laut A_measurements-Kontext) und die \\InputIfFileExists-Platzhalter (erscheinen-nach-Messlauf) = geplant-aber-daten-wartend. Welche Thesis-Luecken sind geplante, ungetrackte To-dos (KEINE Overleaf-outward-Aenderung vorschlagen, nur AUFLISTEN)?`],
]

phase('Sweep')
const sweepThunks = MODALITIES.map(([label, prompt]) => () =>
  agent(prompt, { label: `sweep:${label}`, phase: 'Sweep', schema: SCHEMA, effort: 'high' }))
const sweepResults = (await parallel(sweepThunks)).filter(Boolean)
const rawForgotten = sweepResults.flatMap(r => (r.forgotten || []))
const coverage = sweepResults.map(r => r.coverage_note)
log(`Sweep: ${sweepResults.length}/${MODALITIES.length} Modalitaeten, ${rawForgotten.length} Roh-Kandidaten`)

// Completeness-Kritiker: was fehlt noch?
const critic = await agent(
  `${SWEEP}\n\nMODALITAET COMPLETENESS-KRITIKER: Die bisherigen 8 Modalitaeten fanden ${rawForgotten.length} Kandidaten (unten gekuerzt). Frage: welche QUELLE/MODALITAET wurde NICHT abgedeckt, welche geplante Arbeit koennte noch fehlen? Pruefe konkret: HANDOVER-Docs (${ROOT}/docs/HANDOVER-*.md), die BACKLOG.md (falls vorhanden), die #274-Migrationsplan-Doku, aufgabenstellung-TODOs, prt-art-README-Roadmap. Melde NUR NEUE vergessene Items, die die 8 nicht hatten.\n\nBISHER (gekuerzt): ${rawForgotten.map(f=>f.item).join(' | ').slice(0,3000)}`,
  { label: 'sweep:completeness-critic', phase: 'Sweep', schema: SCHEMA, effort: 'high' })
const allForgotten = [...rawForgotten, ...((critic && critic.forgotten) || [])]

// Dedup nach item-Kern (erste 60 Zeichen normalisiert)
const seen = new Map()
for (const f of allForgotten) {
  const k = (f.item || '').toLowerCase().replace(/[^a-z0-9]/g,'').slice(0, 50)
  if (k && !seen.has(k)) seen.set(k, f)
}
const deduped = [...seen.values()]
log(`+ Kritiker: ${(critic&&critic.forgotten||[]).length} · dedup -> ${deduped.length} eindeutige Kandidaten`)

phase('Verify')
const VERDICT = {
  type: 'object', additionalProperties: false,
  properties: {
    genuinely_forgotten: { type: 'boolean', description: 'geplant + NICHT getan + NICHT getrackt?' },
    status: { type: 'string', description: 'forgotten|already-done|already-tracked|tabu-intended|not-a-todo' },
    evidence: { type: 'string', description: 'code/§12/git-Beleg' },
    stage: { type: 'string', description: 'bestaetigte G1..G8/NEU/gated' },
  }, required: ['genuinely_forgotten','status','evidence','stage'],
}
const verified = await parallel(deduped.map(f => () =>
  agent(`Adversariale Pruefung eines 'vergessenen TODO'-Kandidaten (Diplomarbeit cache-engine; super=${ROOT}, ce=${CE}, prt=${PRT}, thesis=${TH}, Ledger=${LEDGER}). Widerlege den Kandidaten wenn moeglich (Default genuinely_forgotten=false, wenn er erledigt/getrackt/TABU-gewollt/kein-echtes-Todo ist). Belege mit grep §12/Code/git.\n\n${TRACKED}\n\nKANDIDAT: ${f.item}\nQUELLE: ${f.source_ref}\nNICHT-GETAN-CHECK: ${f.done_check}\nVORSCHLAG-STUFE: ${f.suggested_stage}`,
    { label: `verify:${(f.item||'').slice(0,28)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    .then(v => v ? { ...f, verdict: v } : null)))
const confirmed = verified.filter(Boolean).filter(f => f.verdict.genuinely_forgotten)
log(`Verify: ${confirmed.length}/${deduped.length} GENUIN vergessen bestaetigt`)

phase('Synthese')
const synth = await agent(
  `Schreibe den Forgotten-TODO-Sweep-Bericht der Diplomarbeit nach ${ROOT}/docs/sessions/backups/20260712-forgotten-todo-sweep/BEFUND.md (Verzeichnis anlegen). Struktur: (1) Executive Summary (Zahlen: Modalitaeten/Kandidaten/bestaetigt je Stufe+Schwere), (2) BESTAETIGTE vergessene TODOs — gruppiert nach Goal-V4-Stufe (G1..G8/NEU/gated), je mit Quelle+Evidence+Schwere+empfohlener Einordnung, (3) welche davon in Goal-V4/Ledger NACHGETRAGEN werden sollten (konkrete Formulierungs-Vorschlaege je Stufe), (4) Coverage-Nachweis. NUR aus den Daten unten — nichts erfinden. Schreibe die Datei + gib eine praezise Kurzfassung (die bestaetigten Items je G-Stufe + die Top-Nachtraege fuer Goal-V4) als Endnachricht.\n\nCOVERAGE:\n${JSON.stringify(coverage).slice(0,3000)}\n\nBESTAETIGT (${confirmed.length}):\n${JSON.stringify(confirmed.map(f=>({item:f.item,src:f.source_ref,sev:f.verdict.stage&&f.severity,stage:f.verdict.stage,status:f.verdict.status,ev:(f.verdict.evidence||'').slice(0,200)})))}`,
  { label: 'synthese:forgotten-befund', phase: 'Synthese', effort: 'high' })

return { modalities: sweepResults.length, raw: rawForgotten.length, deduped: deduped.length, confirmed: confirmed.length,
         items: confirmed.map(f => ({ item: f.item, stage: f.verdict.stage, sev: f.severity, src: f.source_ref })), report: synth }