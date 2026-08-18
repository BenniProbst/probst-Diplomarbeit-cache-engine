export const meta = {
  name: 'owner-audit-ledger-ist-soll',
  description: 'Owner-Audit 18.08.: Gesamtes Ledger Ist-Soll + 10 Sessions + Kontext-Korrektheits-Audit',
  phases: [
    { title: 'Soll-Karten', detail: '8 Ledger-Segmente + 10 Sessions voll lesen' },
    { title: 'Ist-Verifikation', detail: 'jede pruefbare Zusage am Objekt messen' },
    { title: 'Kontext-Audit', detail: 'dieser Kontext gegen ARBEITSWEISE v4.4' },
    { title: 'Synthese', detail: 'konsolidierter Audit-Bericht' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const WT = '/home/comdare/wt-ce-bump15'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

const KOPF = `Owner-Audit-Auftrag 18.08.2026 (TU-Dresden-Diplomarbeit Cache-Engine). Repos: super ${SUPER} (Branch development @ 0671a24c) · ce ${CE} (development @ 20c111c4) · UNGELANDETER #15-Bruch-Worktree ${WT} (bau/bump15-preimage-bruch, 23 Commits auf 20c111c4, Tip 67dafa46). Der Bruch ist Teil des Ist-Standes (er landet nach diesem Audit). Falsch-Null-Fallen: Umbruch ~95 Zeichen, Case, Encoding; NIE 'grep -v /build' (frisst /builder/). Sicherheits-Auflage: Token-Literale (glpat-...) NIE zitieren. Antworte NUR mit dem geforderten JSON.`

const SOLL_SCHEMA = { type:'object', required:['zusagen'], properties:{ zusagen:{ type:'array', items:{ type:'object',
  required:['id','quelle','soll','pruefanker','prioritaet'], properties:{
    id:{type:'string'}, quelle:{type:'string',description:'KON-Nr/Session+Zeile'},
    soll:{type:'string',description:'die pruefbare Behauptung/Zusage, kompakt'},
    pruefanker:{type:'string',description:'wo am Objekt pruefbar (Datei/Muster/Kommando)'},
    prioritaet:{type:'string',enum:['HOCH','MITTEL','NIEDRIG'],description:'HOCH=letzte Woche/tragend'} }}}}}

phase('Soll-Karten')
const segmente = []
for (let i=0;i<8;i++) segmente.push({key:`ledger-seg${i+1}`, von:i*4000+1, bis:Math.min((i+1)*4000+100,32200)})
const sessionsGruppen = [
  {key:'sessions-a', dateien:'20260817-SESSION-UEBERGABE-pause-welle1-gelandet-ungepusht.md, 20260817-SESSION-UEBERGABE-kontext12-w1-gepusht-neugruendung-p20.md, 20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md'},
  {key:'sessions-b', dateien:'20260817-OWNER-VORLAGE-d2-kurven-stack-spline-trias.md, 20260817-OWNER-VORAB-15-restfragen.md, 20260817-INFRA-MELDUNG-runner-token-rotation-wartungsfenster.md, 20260813-PAUSE-mittag-workflows-resumebar.md'},
  {key:'sessions-c', dateien:'20260816-SESSION-UEBERGABE-kontext8-entscheidungs-tag-golden-fenster.md, 20260815-SESSION-wo-stehen-wir-layer-uebersicht.md, 20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md'},
]
// SEQUENTIELL je Schicht (Owner-Order 18.08.: Limit schonen; Cache-Schluessel unveraendert)
const sollKarten = []
for (const s of segmente) {
  const r = await agent(`${KOPF}
LEDGER-SEGMENT-LESER ${s.key}: Lies ${LEDGER} Zeilen ${s.von}-${s.bis} VOLLSTAENDIG (Read mit offset/limit in Bloecken). Extrahiere JEDE pruefbare SOLL-Zusage (GEBAUT/GELANDET/CI-gruen/Wache existiert/Zahl X an Ort Y/Entscheid Z umgesetzt) mit Prueflanker. Historische Eintraege (vor 11.08.) nur wenn sie einen HEUTE geltenden Zustand behaupten. Prioritaet HOCH fuer alles ab 11.08. und alles am #15-Bruch.`,
    {label:s.key, phase:'Soll-Karten', schema:SOLL_SCHEMA, effort:'max'}).then(r=>r?({...r,quelle_key:s.key}):null).catch(()=>null)
  if (r) sollKarten.push(r)
}
for (const g of sessionsGruppen) {
  const r = await agent(`${KOPF}
SESSION-VOLL-LESER ${g.key}: Lies diese Dateien in ${SUPER}/docs/sessions/ KOMPLETT (jede Zeile): ${g.dateien}. Extrahiere jede pruefbare Zusage/Auftrag/Owner-Entscheid mit Prueflanker (was wurde versprochen/entschieden und woran misst man es heute).`,
    {label:g.key, phase:'Soll-Karten', schema:SOLL_SCHEMA, effort:'max'}).then(r=>r?({...r,quelle_key:g.key}):null).catch(()=>null)
  if (r) sollKarten.push(r)
}
const ERWARTETE_QUELLEN = [...segmente.map(s=>s.key), ...sessionsGruppen.map(g=>g.key)]
const gelieferteQuellen = sollKarten.map(k=>k.quelle_key)
const fehlendeQuellen = ERWARTETE_QUELLEN.filter(q=>!gelieferteQuellen.includes(q))
if (fehlendeQuellen.length > 0) {
  log('VOLLZAEHLIGKEITS-GATE ROT: ' + fehlendeQuellen.join(', ') + ' FEHLEN')
  return { FEHLER: 'AUDIT UNVOLLSTAENDIG - Soll-Karten-Quellen fehlen', fehlende_quellen: fehlendeQuellen,
    geliefert: gelieferteQuellen, hinweis: 'Resume erneut - fehlende Segmente muessen laufen, keine stille Reduktion' }
}
log('VOLLZAEHLIGKEITS-GATE GRUEN: 11/11 Quellen geliefert')
const alleZusagen = sollKarten.flatMap(k=>k.zusagen.map(z=>({...z,seg:k.quelle_key})))
const hoch = alleZusagen.filter(z=>z.prioritaet==='HOCH')
const mittel = alleZusagen.filter(z=>z.prioritaet==='MITTEL')
log(`Soll-Karten: ${alleZusagen.length} Zusagen (${hoch.length} HOCH, ${mittel.length} MITTEL)`)

phase('Ist-Verifikation')
const VERIF_SCHEMA = { type:'object', required:['ergebnisse'], properties:{ ergebnisse:{type:'array', items:{type:'object',
  required:['id','verdikt','beleg'], properties:{
    id:{type:'string'}, verdikt:{type:'string',enum:['ERFUELLT','ABWEICHUNG','FEHLT','NICHT_PRUEFBAR','UEBERHOLT']},
    beleg:{type:'string',description:'Datei:Zeile/Kommando-Output literal, kompakt'},
    schwere:{type:'string',enum:['KRITISCH','ERNST','HINWEIS'],description:'nur bei ABWEICHUNG/FEHLT'} }}}}}
function chunk(a,n){const r=[];for(let i=0;i<a.length;i+=n)r.push(a.slice(i,i+n));return r}
const niedrig = alleZusagen.filter(z=>z.prioritaet==='NIEDRIG')
const pruefPakete = [...chunk(hoch,12), ...chunk(mittel,16), ...chunk(niedrig,20)]
log('VOLL-VERIFIKATION: ' + pruefPakete.length + ' Pakete ueber ALLE ' + alleZusagen.length + ' Zusagen (kein Sampling)')
// SEQUENTIELL: ein Verifizierer zur Zeit (Owner-Order 18.08.), Prompts identisch = Cache-Hits
const verifRoh = []
for (let i=0;i<pruefPakete.length;i++) {
  const paket = pruefPakete[i]
  const v = await agent(`${KOPF}
IST-VERIFIZIERER Paket ${i+1}: Pruefe JEDE dieser Zusagen AM OBJEKT (nicht an Doku ueber das Objekt): nutze die Pruefanker, miss selbst (grep/Read/git log). Der Bruch-Worktree ${WT} zaehlt als Ist fuer #15-Posten. UEBERHOLT nur mit Beleg der ueberholenden Quelle.
ZUSAGEN: ${JSON.stringify(paket)}`,
    {label:`verif-${i+1}`, phase:'Ist-Verifikation', schema:VERIF_SCHEMA, effort:'max'}).catch(()=>null)
  if (v) verifRoh.push(v)
  log(`Verifikation sequentiell: Paket ${i+1}/${pruefPakete.length} durch`)
}
const verifiziert = verifRoh.flatMap(v=>v.ergebnisse)
const verifizierteIds = new Set(verifiziert.map(v=>v.id))
const unverifiziert = alleZusagen.filter(z=>!verifizierteIds.has(z.id))
log('Verifiziert: ' + verifiziert.length + '/' + alleZusagen.length + '; UNVERIFIZIERT: ' + unverifiziert.length)

phase('Kontext-Audit')
const AUDIT_SCHEMA = { type:'object', required:['befunde','gesamturteil'], properties:{
  gesamturteil:{type:'string'}, befunde:{type:'array', items:{type:'object',
    required:['titel','schwere','beleg','empfehlung'], properties:{
      titel:{type:'string'}, schwere:{type:'string',enum:['KRITISCH','ERNST','HINWEIS']},
      beleg:{type:'string'}, empfehlung:{type:'string'} }}}}}
const kontextPruefer = [
  {key:'doktrin-treue', prompt:`Pruefe die Arbeit DIESES Kontexts (KON113-KON118 im Ledger + die Commits super f4b01ab3..0671a24c + ce-Landungen 965b121a/20c111c4 + der 23-Commit-Bruch in ${WT}) gegen die ARBEITSWEISE (/home/comdare/Projekte/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md, VOLL lesen; Fallback ${SUPER}/docs/ARBEITSWEISE-GESAMT-DOKTRIN.md): Wellen-Form A2.1a/b eingehalten? Lande-Gate-Ketten je Push vollstaendig? Harmonisierung statt Auto-Merge? Ein-Schreiber-Doktrin (es gab 2 dokumentierte Verletzungs-Vorfaelle — im Ledger/Board als K16 vermerkt: wie sauber war die Heilung)?`},
  {key:'beweis-vollstaendigkeit', prompt:`Pruefe die BEWEISFUEHRUNG dieses Kontexts: Sind die zentralen Gruen-Meldungen (ce-CI 15974/15979, super 15976/15980/15982/15983, ctest 502/502+503/503 im Worktree, Wache GUARD_EXIT=0, Floor 503/499/497, TABU-CRC-MATCH 0x56F1B721C72DC10E) am Objekt nachvollziehbar (Logs unter ~/.claude/jobs/5a19728e/tmp/, LastTest.log im Worktree, Floor-Datei, CI per API curl -sk -K ~/.claude/jobs/5a19728e/tmp/glhdr.curlrc auf gitlab.comdare.local projects 286/288)? Wo wurde Gruen behauptet ohne literalen Beleg?`},
  {key:'owner-wort-treue', prompt:`Pruefe OWNER-WORT-TREUE: Die Entscheide V-01R..V-13 (KON101), V-02R/V-03R/V-04R/V-05R/V-06/V-09R/V-11R/V-12 — wurden sie im Bruch ${WT} korrekt umgesetzt (nicht verengt, nicht geweitet)? Insbesondere: V-06 Lesart A (Stempel-Pflicht GEWEITET + 2 Symbole — nur die 2 Symbole sind gebaut, Stempel-Pflicht als golden-gebundener Folgezug benannt: ist diese Aufteilung durch die Quellen gedeckt oder eine unerlaubte Halbierung?), V-11R-Namensformen, V-12-Ordinale, das E-6/KON118-Phantom-Nenner-Verdikt.`},
]
// SEQUENTIELL: ein Kontext-Lens zur Zeit (Owner-Order 18.08.)
const kontextAudit = []
for (const p of kontextPruefer) {
  const r = await agent(`${KOPF}
KONTEXT-AUDITOR (${p.key}): ${p.prompt} Urteile hart aber fair; jeder Befund mit Beleg.`,
    {label:`audit-${p.key}`, phase:'Kontext-Audit', schema:AUDIT_SCHEMA, effort:'max'}).then(r=>r?({...r,lens:p.key}):null).catch(()=>null)
  if (r) kontextAudit.push(r)
}

phase('Synthese')
const SYN = await agent(`${KOPF}
SYNTHESE des Owner-Audits. Eingaben: (1) ${alleZusagen.length} Soll-Zusagen, (2) Verifikations-Ergebnisse, (3) 3 Kontext-Audit-Lenses. Baue den konsolidierten Bericht: Gesamturteil (WURDE KORREKT GEARBEITET? dreiwertig je Dimension), alle KRITISCH/ERNST-Befunde dedupliziert mit Beleg+Fix-Empfehlung, FEHLT/ABWEICHUNG-Liste aus der Ist-Verifikation priorisiert, LANDE-FREIGABE-Urteil fuer den #15-Bruch (LANDBAR / LANDBAR_MIT_FIXES [Liste] / NICHT_LANDBAR [Gruende]).
=== VERIFIKATION === ${JSON.stringify(verifiziert).slice(0,40000)}
=== KONTEXT-AUDIT === ${JSON.stringify(kontextAudit).slice(0,30000)}
=== VOLLZAEHLIGKEIT === Soll-Quellen 11/11; Zusagen gesamt ${alleZusagen.length}; verifiziert ${verifiziert.length}; UNVERIFIZIERT (Agent-Ausfall, im Bericht ausweisen, NIE als geprueft zaehlen): ${JSON.stringify(unverifiziert.map(z=>z.id)).slice(0,3000)}`,
  {label:'synthese', phase:'Synthese', schema:{type:'object',required:['gesamturteil','lande_freigabe','kritisch','ernst','fehlt_abweichung','hinweise'],properties:{
    gesamturteil:{type:'string'}, lande_freigabe:{type:'string'},
    kritisch:{type:'array',items:{type:'string'}}, ernst:{type:'array',items:{type:'string'}},
    fehlt_abweichung:{type:'array',items:{type:'string'}}, hinweise:{type:'array',items:{type:'string'}}}}, effort:'max'})

return { synthese: SYN, zusagen: alleZusagen.length, verifiziert: verifiziert.length, unverifiziert: unverifiziert.length, unverifizierte_ids: unverifiziert.map(z=>z.id),
  verdikte: {erfuellt: verifiziert.filter(v=>v.verdikt==='ERFUELLT').length,
    fehlt: verifiziert.filter(v=>v.verdikt==='FEHLT').length,
    abweichung: verifiziert.filter(v=>v.verdikt==='ABWEICHUNG').length,
    ueberholt: verifiziert.filter(v=>v.verdikt==='UEBERHOLT').length} }