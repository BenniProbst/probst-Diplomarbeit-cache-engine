export const meta = {
  name: 'regression-sweep-10-kontexte',
  description: 'ultracode-Sweep: letzte 10 Kontexte + Workflow-Journale auf unnotierte Regressionen + verlorene/abgebrochene Straenge; Synthese = Abschnitt-12-Text fuers Regressionen-Register',
  phases: [
    { title: 'Transkript', detail: '10 Leser je Kontext-Fenster (Roh-JSONL, Kontext-Disziplin)' },
    { title: 'Journale', detail: '3 Leser ueber Workflow-Journale + backups-workflow 16.-19.08.' },
    { title: 'Rekonstruktion', detail: 'verlorene Straenge am Objekt messen + Rezept gegen den Plan' },
    { title: 'Synthese', detail: 'Dedup gegen Register 0-11, Gegenzaehlung, Abschnitt-12-Text' },
  ],
}

const TRANS = '/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl'
const REG = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260818-SESSION-REGRESSIONEN-bump15-codex-audit-review.md'
const WFDIR = '/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1/subagents/workflows'
const FENSTER = [
  ['K5', 59214, 60174, '16.08. 12:28 - 17.08. 05:21'],
  ['K6', 60174, 61035, '17.08. 05:21 - 08:10'],
  ['K7a', 61035, 61635, '17.08. 08:10 - 08:30'],
  ['K7b', 61635, 62209, '17.08. 08:30 - 08:51'],
  ['K8', 62209, 63511, '17.08. 08:51 - 10:44'],
  ['K9', 63511, 64616, '17.08. 10:44 - 17:46'],
  ['K10', 64616, 65944, '17.08. 17:46 - 20:46'],
  ['K11', 65944, 66960, '17.08. 20:46 - 23:38'],
  ['K12', 66960, 68514, '17.08. 23:38 - 18.08. 09:13'],
  ['K13', 68514, 69705, '18.08. 09:13 - 21:24'],
]

const KOPF = `REGRESSIONS-SWEEP (Diplomarbeit Cache-Engine, K14, 19.08.2026). AUFTRAG: unnotierte Regressionen + VERLORENE/ABGEBROCHENE STRAENGE finden. Ein "verlorener Strang" = gestartete Arbeit (Workflow, Agent, Bau-Zusage, "als naechstes mache ich X") OHNE sichtbaren Abschluss/Ernte. Eine "unnotierte Regression" = gefundener Defekt/Fehler/Abweichung (auch spaeter behobene), der im Register ${REG} (463 Z., Abschnitte 0-11 -- LIES ES ZUERST VOLL als Dedup-Basis) fehlt. AUDIT-KONTEXT: Das Owner-Audit (688 Zusagen: 502 ERFUELLT/22 FEHLT/85 ABWEICHUNG/74 UEBERHOLT) lief bereits -- args.audit_essenz traegt seine Essenz; melde NICHT erneut, was dort schon verdiktiert ist, MARKIERE aber Ueberschneidungen. KONTEXT-DISZIPLIN: JSONL-Zeilen koennen >1 MB sein -- NIE ungebremst lesen; python3-Streaming mit Zeilenfenster + Textkuerzung je Eintrag (assistant-Texte max ~800 Z., tool_results nur Kopf ~200 Z.). Return NUR kompaktes JSON.`

const LESER_SCHEMA = {type:'object',required:['regressionen','verlorene_straenge','gestartete_workflows','quittung'],properties:{
  regressionen:{type:'array',items:{type:'object',required:['was','fundort','verbleib'],properties:{was:{type:'string'},fundort:{type:'string'},verbleib:{type:'string'},im_register:{type:'boolean'}}}},
  verlorene_straenge:{type:'array',items:{type:'object',required:['strang','letzter_stand','fehlt'],properties:{strang:{type:'string'},letzter_stand:{type:'string'},fehlt:{type:'string'}}}},
  gestartete_workflows:{type:'array',items:{type:'string'}},
  quittung:{type:'string'}}}

phase('Transkript')
const leser = await parallel(FENSTER.map(([k,a,b,zeit]) => () =>
  agent(`${KOPF}
DEIN FENSTER: Kontext ${k} = Transkript-Zeilen ${a}-${b} (${zeit}) von ${TRANS}.
VORGEHEN: (1) Register ZUERST voll lesen (Dedup-Basis). (2) python3-Streaming ueber Zeilen ${a}-${b}: extrahiere User-Texte VOLL, assistant-Texte gekuerzt (~800 Z.), teammate-/agent-messages VOLL bis 2000 Z., tool_use-Namen (Workflow/Agent-Starts mit run-IDs!), Fehler-Marker (FEHLER, failed, limit, abgebrochen, rot, VERTAGT, OFFEN, "nicht gebaut", Abbruch). (3) Vollziehe nach: Was wurde in ${k} begonnen und was davon hat KEINEN Abschluss im Fenster? Was wurde als Defekt/Regression gefunden? (4) Gegen das Register: im_register=true/false je Fund. Quittung: Zeilen gescannt / Eintraege extrahiert.`,
    {label:`sweep-${k}`, phase:'Transkript', model:'fable', effort:'max', schema:LESER_SCHEMA})
    .then(r=>({...r,_k:k})).catch(()=>null)))
const tot = leser.map((r,i)=>r?null:FENSTER[i][0]).filter(Boolean)
if (tot.length) log(`WARNUNG: ${tot.length} Fenster-Leser ausgefallen: ${tot.join(',')} -- Synthese weist das als LUECKE aus`)

phase('Journale')
const jGruppen = [
  {label:'journale-a', auftrag:`ALLE Workflow-Verzeichnisse unter ${WFDIR} (ls -t): fuer JEDEN Run mit journal.jsonl-mtime 16.-19.08.: (a) fertig oder abgebrochen (letzte Zeile/Fehler)? (b) Wurde das ERGEBNIS geerntet -- d.h. taucht die Run-ID oder ihr Kernergebnis im Register, in docs/sessions/2026081[6-9]*.md oder im Wellenplan par.20/21 auf (grep)? Nicht geerntete Ergebnisse = verlorene Straenge MIT Journal-Pfad + Kern des Ergebnisses (letzte result-Zeilen).`},
  {label:'journale-b', auftrag:`~/backups-workflow/: alle Ordner 20260816* bis 20260819* -- je Ordner: was liegt dort (RAWDATA, Karten, Bauplaene), und ist es in Register/Sessions/Wellenplan referenziert (grep nach Ordnername + Kern-Dateinamen)? Unreferenzierte Substanz = verlorener Strang. Speziell: 20260817-buendel15-und-wf10/ (BUENDEL-BAUPLAN-15.md 23 Schritte -- seg1-81 verlangt Deckungs-Nachweis) + wf10-Reste.`},
  {label:'journale-c', auftrag:`Teammate-/Agent-Straenge: grep im Transkript ${TRANS} (python3-Streaming, NUR Zeilen 59214-70131) nach teammate_id-Vorkommen (bump15-a/b/c/d, owner-vorlagen, weitere) + SendMessage/Task-tool-Aufrufen: welche Teammates/Hintergrund-Agenten wurden beauftragt, und traegt jeder einen Endbericht? Ohne Endbericht = verlorener Strang. Dazu: wf-Explore 'hybrid-grammatik-dokumentiert' (T-10!) -- suche seine Spur (Start? Ergebnis?) in Transkript-Fenster + ${WFDIR} + ~/backups-workflow/.`},
]
const journale = await parallel(jGruppen.map(g => () =>
  agent(`${KOPF}\nDEIN AUFTRAG: ${g.auftrag}\nRegister vorher voll lesen (Dedup).`,
    {label:g.label, phase:'Journale', model:'fable', effort:'max', schema:LESER_SCHEMA})
    .then(r=>({...r,_k:g.label})).catch(()=>null)))

phase('Rekonstruktion')
const alleStraenge = [...leser,...journale].filter(Boolean).flatMap(r=>(r.verlorene_straenge||[]).map(s=>({...s,_quelle:r._k})))
log(`Rekonstruktions-Input: ${alleStraenge.length} Strang-Kandidaten (roh)`)
const reko = await agent(`${KOPF}
STRANG-REKONSTRUKTION: Unten ${alleStraenge.length} rohe Kandidaten verlorener/abgebrochener Straenge. (1) DEDUPLIZIERE (gleicher Gegenstand), GEGENZAEHLE (roh vs. dedup -- Zahl nennen). (2) Je Einzelstrang AM OBJEKT messen: existiert der Branch/Worktree/Commit/die Datei noch (git -C <repo> branch -a / worktree list / log; Dateisystem)? (3) Gegen den PLAN halten: Wellenplan par.21 (docs/plaene/20260808-WELLENPLAN-*.md ab Z.2876) + Wiederaufnahme-Register Abschnitte A-G + Task-Board-Nummern aus dem Register -- hat der Strang schon einen Traeger? (4) Je Strang: STATUS (GEERNTET/REKONSTRUIERBAR/VERLOREN) + REZEPT (1-2 Saetze: wie sicher rekonstruieren). Repos: super=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine, ce-Worktrees=/home/comdare/wt-ce-*.
=== KANDIDATEN === ${JSON.stringify(alleStraenge).slice(0,60000)}`,
  {label:'rekonstruktion', phase:'Rekonstruktion', model:'fable', effort:'max', schema:{type:'object',required:['dedup_zaehlung','straenge'],properties:{
    dedup_zaehlung:{type:'string'},
    straenge:{type:'array',items:{type:'object',required:['strang','status','objekt_messung','traeger','rezept'],properties:{
      strang:{type:'string'},status:{type:'string',enum:['GEERNTET','REKONSTRUIERBAR','VERLOREN']},objekt_messung:{type:'string'},traeger:{type:'string'},rezept:{type:'string'}}}}}}}).catch(()=>null)

phase('Synthese')
const syn = await agent(`SYNTHESE (Fable max) des Regressions-Sweeps. Baue den fertigen ABSCHNITT-12-TEXT fuer das Register ${REG} (Stil der Abschnitte 10/11: ASCII, <=100 Z. Breite, praezise Anker). INHALT: (a) NEUE Regressionen (im_register=false, nach Dedup -- GEGENZAEHLUNG roh/dedup nennen; Audit-Ueberschneidungen markieren statt doppeln, args.audit_essenz beachten), (b) Strang-Rekonstruktions-Tafel (aus der Rekonstruktion: nur REKONSTRUIERBAR/VERLOREN mit Rezept; GEERNTET nur als Zaehler), (c) Leser-Vollzaehligkeit (${tot.length? 'AUSGEFALLENE Fenster: '+tot.join(',') : 'alle 10 Fenster gelesen'} + 3 Journal-Gruppen), (d) KONSEQUENZ-Zeile: was in Fix-Strecke 2 / #93 / Di-25.-Schnitt einfliesst. Der Lead landet den Text (EIN Schreiber) -- gib NUR den fertigen Markdown-Text + eine Kurz-Bilanz zurueck.
=== AUDIT-ESSENZ === ${JSON.stringify((typeof args!=='undefined'&&args&&args.audit_essenz)||'(nicht uebergeben)').slice(0,8000)}
=== LESER (${leser.filter(Boolean).length}/10 + ${journale.filter(Boolean).length}/3) === ${JSON.stringify([...leser,...journale].filter(Boolean)).slice(0,120000)}
=== REKONSTRUKTION === ${JSON.stringify(reko||{FEHLER:'ausgefallen'}).slice(0,40000)}`,
  {label:'synthese', phase:'Synthese', model:'fable', effort:'max', schema:{type:'object',required:['abschnitt_12_markdown','kurz_bilanz'],properties:{
    abschnitt_12_markdown:{type:'string'}, kurz_bilanz:{type:'string'}}}}).catch(()=>null)

if (!syn) return { FEHLER:'SYNTHESE AUSGEFALLEN', leser: leser.filter(Boolean).length, journale: journale.filter(Boolean).length, reko: !!reko }
return { synthese: syn, rekonstruktion: reko, leser_ok: leser.filter(Boolean).length, journal_ok: journale.filter(Boolean).length, ausgefallen: tot }
