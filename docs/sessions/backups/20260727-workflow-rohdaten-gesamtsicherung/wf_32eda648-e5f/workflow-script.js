export const meta = {
  name: 'two-day-forgotten-work-sweep',
  description: 'Sweep aller Sessions der letzten 2 Tage nach nachweisbar-nicht-gebauter, plan-konformer, nicht-progress-revertierender Rest-Arbeit',
  phases: [
    { title: 'Sweep', detail: '7 Modalitäten über Dossiers/Handovers/§12/Plan/Transkript/Cluster' },
    { title: 'Verify', detail: '3-Gate adversarial je Kandidat' },
    { title: 'Synthese', detail: 'Zusatz-Tasks + Backup' },
  ],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BK = ROOT + '/docs/sessions/backups'
const SES = ROOT + '/docs/sessions'
const TRANSCRIPT = '/home/comdare/.claude/projects/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl'

const TRACKED = `BEREITS GETRACKT im 18-Task-Board (Goal-V4 G1–G8+G-INFRA) — NICHT erneut melden:
G1 CI/GitLab-Sync(infra) · G2 Mess-Integritaet(sota_catalog/workload-id/cycles-fab/execute_engine/gitlab-ci-617/prt-art-phantom) ·
G3 Achsen-Korrektheit(alloc-null/cpuid/cuckoo/hash_lookup/scalloc/rcu/SIMDOps/array_65535/uint16-cast) ·
G4 Aufraeum(dead-code/doc-drift) + Muster C Null-Consumer + D Super-Sub-Build + F Test-Registrierung ·
G5 measurement-all-Migration(5a metrics-Transfer #274 + 5b Facade-Struktur) · G6 Messlauf-Strecke(#9916/persist/Smoke-Voll/#11/#17/P1/H2-Korrelation) ·
G7 gated(V32-Tilgung/Fork4/PE-Core/NUMA-Effekt/NEON-RVV/FF0-Owner/ABI-4-5/#215) · G8 Anhaenge B/E · G-INFRA CRC64 · 40-major-Gate.`

const GATES = `Ein FUND zaehlt NUR, wenn ALLE DREI GATES erfuellt sind (sonst NICHT melden):
(1) NACHWEISBAR NICHT GEBAUT: geplant/versprochen, aber per grep in Code (super+ce+prt-art) / git-log / Ledger-§12 NICHT umgesetzt — mit Beleg.
(2) PLAN-KONFORM: verstoesst NICHT gegen Goal-V4/Direktiven/TABU (permutation_axes/golden-320/POD-1416/ABI-4/GenusBindingTraits; compile-time-only-Metaprog; Baseline-Layering; Doku-nie-loeschen).
(3) MACHT KEINEN FORTSCHRITT RUECKGAENGIG: KEIN bewusst-revertiertes/verworfenes/geparktes Item (z.B. E4-XML phase1-#230/phase2-#221-Reverts, axis_binding_registry-Revert, Behelfswege-run_lazy/*.ps1 die bewusst geloescht wurden, Decoy-/Spiegel-Baeume). Wenn ein Item bewusst zurueckgebaut wurde, ist sein Wieder-Einbau VERBOTEN.`

const SWEEP = `Du suchst RESTLICHE, noch nicht erledigte Aufgaben aus den Sessions der letzten 2 Tage (2026-07-11..13) der Diplomarbeit (comdare cache-engine). Praezise, mit Quelle+Zeile.\n\n${GATES}\n\n${TRACKED}\n\nSchreibe knapp: das Item, Quelle:zeile, Gate-1-Beleg (grep-Ergebnis dass NICHT gebaut), Gate-3-Check (nicht revertiert/geparkt), Gate-2 (plan-konform), vorgeschlagene G-Stufe. Lieber 3 wasserdichte Funde als 20 weiche. TABU-gewollte/erledigte/getrackte NICHT melden.`

const SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    coverage_note: { type: 'string' },
    items: { type: 'array', items: {
      type: 'object', additionalProperties: false,
      properties: {
        item: { type: 'string' },
        source_ref: { type: 'string', description: 'Dossier/Doc/§12/Transkript : Zeile' },
        gate1_not_built: { type: 'string', description: 'grep/git/§12-Beleg dass NICHT umgesetzt' },
        gate3_not_reverted: { type: 'string', description: 'Beleg dass NICHT bewusst-revertiert/geparkt' },
        gate2_plan_ok: { type: 'string', description: 'warum plan-/TABU-konform' },
        suggested_stage: { type: 'string' },
        severity: { type: 'string', description: 'blocker|major|minor|nice-to-have' },
      }, required: ['item','source_ref','gate1_not_built','gate3_not_reverted','suggested_stage','severity'],
    } },
  }, required: ['coverage_note','items'],
}

const MODS = [
  ['dossiers-11a', `${SWEEP}\n\nMODALITAET DOSSIERS-A (11.07.): Lies vollstaendig ${BK}/20260711-axis-ontology-verify, ${BK}/20260711-ci-interactive-thesis-analysis, ${BK}/20260711-cmd2-container-attribution, ${BK}/20260711-e4prime-cor-filter-chain, ${BK}/20260711-e4prime-messkurven-typsystem-wurzel, ${BK}/20260711-grenzen-roadmap-slice1 (je *.md). Suche 'naechste Schritte'/'offen'/'Folge-Increment'/'empfohlen aber nicht gebaut'. Verifiziere Gate 1+3 gegen Code/§12/git.`],
  ['dossiers-11b', `${SWEEP}\n\nMODALITAET DOSSIERS-B (11.07.): Lies vollstaendig ${BK}/20260711-measurement-ci-trigger-plan, ${BK}/20260711-phase03-allocator-adapter, ${BK}/20260711-pipeline-e2e-validation-real-data, ${BK}/20260711-produktions-single-xml-path-audit, ${BK}/20260711-tier-system-memory-footprint-deep-research (je *.md). Suche geplante-aber-ungebaute Reste (bes. Deep-Research-Empfehlungen, Audit-Restpunkte). Gate 1+3 gegen Code/§12.`],
  ['handovers', `${SWEEP}\n\nMODALITAET SESSION-HANDOVERS: Lies ${SES}/20260711-SESSION-ENDE-produktions-ci-fix-golden-run-achsen.md, ${SES}/20260711-SESSION-UEBERGABE-gitlab-sync-submodule-stand-und-readonly-review.md, ${SES}/20260711-SESSION-UEBERGABE-produktions-single-xml-path.md. Suche in den 'Offene Punkte'/'Naechste Session'/'TODO'-Abschnitten Items die nie ins Board/§12 kamen. Gate 3 streng: viele Handover-Punkte wurden inzwischen gebaut ODER bewusst revertiert.`],
  ['ledger-recent', `${SWEEP}\n\nMODALITAET LEDGER §11/§12 (11.-13.07.): Lies ${LEDGER} §11-Erweiterungen + §12-Eintraege mit Datum 2026-07-11/12/13. Suche darin genannte geplante Folge-Schritte/'offen'/'Rest'/'deferred' die (a) nicht in einem SPAETEREN §12-Eintrag als erledigt auftauchen und (b) nicht im Board stehen. Gate 3: unterscheide 'gated/geparkt' (nicht melden) von 'vergessen' (melden).`],
  ['plan-e1e4', `${SWEEP}\n\nMODALITAET E1-E4-PLAN: Lies ~/.claude/plans/noble-shimmying-fairy.md. Pruefe jede Phase (0 Konsolidierung: E-A..E-E->DD-Rename, S<->E-Kreuz-Map, 15_F7-Neufassung, WORKFLOW-4layer-Andock, STANDARDPROZESS-Andock · 0.5 G2-Revert · 4/#31 · 1/#188 · 2/#221 · 3/#223 · 5/#215 · 6/#156) gegen Code+§12: was ist NICHT umgesetzt UND nicht bewusst-verworfen? Bes. die Phase-0-DOKU-Konsolidierung (E-A..E-E->DD-Rename, S<->E-Kreuz-Map, F7-Neufassung) — wurde die je gemacht? Gate 3: die phase1/phase2-Reverts NICHT als 'todo' melden.`],
  ['transcript-grep', `${SWEEP}\n\nMODALITAET TRANSKRIPT-GREP (SEHR VORSICHTIG): Das Session-Transkript ${TRANSCRIPT} (108MB) NICHT wholesale lesen. Nutze NUR gezielte grep-Kommandos nach Planungs-Markern, z.B.: grep -oiE 'notiere.{0,80}TODO|als (weiteres |naechstes )?TODO|spaeter( nachziehen| bauen)|vergessen|nicht (gebaut|umgesetzt)|Folge-Increment|geplant aber' ${TRANSCRIPT} | sort -u | head -60. WICHTIG: gib NIEMALS Token-artige Strings aus (glpat-/40-stellige Hex/oauth2:) — falls ein Treffer sowas enthaelt, verwirf ihn. Cluster die Planungs-Aussagen, verifiziere Gate 1 (grep Code) + Gate 3 (nicht revertiert). Nur Diplomarbeit-relevantes.`],
  ['cluster-sessions', `${SWEEP}\n\nMODALITAET CLUSTER-SESSIONS (nur DIPLOMARBEIT-relevantes): Lies ~/Projekte/Cluster/docs/sessions/20260711-13-19-003315-K104-handover-admin-rechner-github-remotes-strip.md + ~/Projekte/Cluster/docs/sessions/20260712-HANDOVER-INFRA-gitlab-migration-broken-diplomarbeit-sync-blockiert.md. Suche NUR Punkte, die die DIPLOMARBEIT-Repos betreffen (github-remote-strip Auswirkungen, gitlab-Sync, Deploy-Token, CI) und noch offen + nicht im Board sind. Infra-interne Cluster-Arbeit (Vault/AD/Backup) ist AUSSER SCOPE.`],
]

phase('Sweep')
const raw = (await parallel(MODS.map(([label, prompt]) => () =>
  agent(prompt, { label: `sweep:${label}`, phase: 'Sweep', schema: SCHEMA, effort: 'high' })))).filter(Boolean)
const cands = raw.flatMap(r => r.items || [])
const coverage = raw.map(r => r.coverage_note)
log(`Sweep: ${raw.length}/${MODS.length} Modalitaeten, ${cands.length} Roh-Kandidaten`)

const seen = new Map()
for (const c of cands) { const k = (c.item||'').toLowerCase().replace(/[^a-z0-9]/g,'').slice(0,48); if (k && !seen.has(k)) seen.set(k, c) }
const dedup = [...seen.values()]
log(`dedup -> ${dedup.length}`)

phase('Verify')
const VERDICT = {
  type: 'object', additionalProperties: false,
  properties: {
    passes_all_gates: { type: 'boolean' },
    g1_not_built: { type: 'boolean' }, g2_plan_ok: { type: 'boolean' }, g3_not_reverted: { type: 'boolean' },
    reason: { type: 'string' }, stage: { type: 'string' },
  }, required: ['passes_all_gates','g1_not_built','g2_plan_ok','g3_not_reverted','reason','stage'],
}
const verified = (await parallel(dedup.map(c => () =>
  agent(`Adversariale 3-Gate-Pruefung eines Rest-Arbeit-Kandidaten (Diplomarbeit; super=${ROOT}, ce=${CE}, Ledger=${LEDGER}). Widerlege wenn moeglich (Default passes_all_gates=false).\n\n${GATES}\n\n${TRACKED}\n\nKANDIDAT: ${c.item}\nQUELLE: ${c.source_ref}\nG1-Beleg: ${c.gate1_not_built}\nG3-Check: ${c.gate3_not_reverted}\n\nPruefe JEDES Gate am Code/git/§12. passes_all_gates=true NUR wenn g1 AND g2 AND g3 alle true UND nicht schon im 18-Task-Board.`,
    { label: `verify:${(c.item||'').slice(0,26)}`, phase: 'Verify', schema: VERDICT, effort: 'high' })
    .then(v => v ? { ...c, verdict: v } : null)))).filter(Boolean)
const confirmed = verified.filter(c => c.verdict.passes_all_gates)
log(`Verify: ${confirmed.length}/${dedup.length} bestehen ALLE 3 Gates`)

phase('Synthese')
const synth = await agent(
  `Schreibe den 2-Tage-Rest-Arbeit-Sweep-Bericht nach ${BK}/20260713-two-day-forgotten-work-sweep/BEFUND.md (Verzeichnis anlegen). Struktur: (1) Summary (Modalitaeten/Kandidaten/bestaetigt), (2) BESTAETIGTE Rest-Aufgaben (alle 3 Gates), je mit Quelle/G1-G3-Beleg/G-Stufe/Schwere + konkretem Task-Vorschlag, (3) prominente ABGELEHNTE (bes. was wegen Gate-3=revertiert/geparkt NICHT aufgenommen wird — wichtig fuer Nachvollziehbarkeit), (4) Coverage. NUR aus den Daten unten. Schreibe die Datei + gib eine Kurzfassung (bestaetigte Items je G-Stufe + die wichtigsten Gate-3-Ablehnungen) als Endnachricht.\n\nCOVERAGE:\n${JSON.stringify(coverage).slice(0,2500)}\n\nBESTAETIGT (${confirmed.length}):\n${JSON.stringify(confirmed.map(c=>({item:c.item,src:c.source_ref,stage:c.verdict.stage,sev:c.severity,reason:c.verdict.reason})))}\n\nABGELEHNT-STICHPROBE:\n${JSON.stringify(verified.filter(c=>!c.verdict.passes_all_gates).slice(0,15).map(c=>({item:c.item,reason:c.verdict.reason})))}`,
  { label: 'synthese:befund', phase: 'Synthese', effort: 'high' })

return { modalities: raw.length, raw: cands.length, dedup: dedup.length, confirmed: confirmed.length,
         items: confirmed.map(c => ({ item: c.item, stage: c.verdict.stage, sev: c.severity, src: c.source_ref })), report: synth }