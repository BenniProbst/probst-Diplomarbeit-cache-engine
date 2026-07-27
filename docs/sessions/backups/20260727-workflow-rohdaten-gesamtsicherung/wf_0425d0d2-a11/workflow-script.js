export const meta = {
  name: 'o8-plan-rev2-verify',
  description: 'Zweite adversariale Verify-Runde auf O-8-Plan Rev. 2 (loop-until-dry)',
  phases: [
    { title: 'Verify2', detail: '3 Lenses erneut auf Rev. 2 + Einarbeitungs-Regressioncheck' },
    { title: 'Fix2', detail: 'nur falls Befunde' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PLAN = SUPER + '/docs/sessions/20260727-PLAN-o8-fenster-atomar-ultracode.md'

const COMMON = `Der Plan ${PLAN} liegt in Rev. 2 vor: eine erste adversariale Runde fand 20 Befunde (11 BLOCKER/MAJOR), ALLE wurden eingearbeitet (siehe Abschnitt 11). Du pruefst Rev. 2 ADVERSARIAL — sowohl ob die Einarbeitung sauber ist (keine neuen Widersprueche/Regressionen durch die Fixes) als auch ob Rest-Luecken bestehen. Code-Pins: ce development 7dd41b18, super development 40ee7349 (NUR LESEN). Quellen: ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (§69-75), ${SUPER}/docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md. Gib NUR echte, belegte Befunde (Fundstelle datei:zeile bzw. Paragraph); keine Stil-Noergelei. Wenn Rev. 2 tragfaehig ist, sag das klar mit freigabe_empfohlen=true.`

phase('Verify2')
const LENSES = [
  {key: 'vollstaendigkeit', prompt: `Lens VOLLSTAENDIGKEIT: Sind alle 8 §72-Fenster-Glieder (A2, A3 inkl. K1-Umzug/target_isa-Wrapper/C-3c, A8.2/A8.3, Lane F R1-R3 + gate_contribution_identity_text §70.9, Mess-Stempel RF-1/§70.1, V-1, Golden-Neuanker D2.10 2-Pass, O-4b <machines>-XSD) mit konkreten Schritten, korrekten Ankern und erreichbaren Beweisen abgedeckt? Sind die in Runde 1 ergaenzten Punkte (Schritt 0A version-Feld, declared_count in Schritt 11, OP-11 A8.2-Soll-Menge) konsistent eingebunden?`},
  {key: 'quellen-treue', prompt: `Lens QUELLEN-TREUE: Widerspricht ein Rev.-2-Schritt einem Owner-Wortlaut (OD/RF/Q-Entscheide, User-KERN=Gesetz), einer Ledger-§69-75-Auflage oder dem Bauplan? Ist die korrigierte Entscheid-Autoritaet (OP-1/OP-5=Owner) konsistent durchgezogen? Sind die als Zitat markierten Stellen echte Zitate?`},
  {key: 'byte-klassen', prompt: `Lens BYTE-KLASSEN + BEWEIS-KRAFT: Stimmen je Schritt Byte-Klasse und Wachen-Matrix (Abschnitt 4) jetzt zusammen (welche Wache bricht in welchem Schritt, 2-Pass-Neuanker)? Sind die in Runde 1 gefundenen Schein-Beweise (316/316-super-Falschzahl, CMake-Cache-Falle V-1, ASCII-Wache, grep-Zaehl-Schwaechen, unerreichbarer Schritt-3-grep) in Rev. 2 wirklich durch tragfaehige Beweise ersetzt? Pruefe die Beweis-Kommandos am realen Code.`},
]
const VERDICT = {type: 'object', properties: {befunde: {type: 'array', items: {type: 'object', properties: {schwere: {type: 'string', enum: ['BLOCKER', 'MAJOR', 'MINOR']}, beschreibung: {type: 'string'}, quelle: {type: 'string'}}, required: ['schwere', 'beschreibung']}}, freigabe_empfohlen: {type: 'boolean'}}, required: ['befunde', 'freigabe_empfohlen']}
const verdicts = (await parallel(LENSES.map(l => () => agent(COMMON + '\n\n' + l.prompt, {label: 'verify2:' + l.key, phase: 'Verify2', schema: VERDICT, effort: 'xhigh'})))).filter(Boolean)
const befunde = verdicts.flatMap(v => v.befunde)
const harte = befunde.filter(b => b.schwere !== 'MINOR')
log(`Verify2: ${befunde.length} Befunde (${harte.length} hart); Freigaben: ${verdicts.map(v => v.freigabe_empfohlen).join(',')}`)

phase('Fix2')
let fixReport = 'kein Fix noetig'
if (befunde.length > 0) {
  fixReport = await agent(`Arbeite diese Verify-2-Befunde in ${PLAN} ein (Rev. 3; BLOCKER/MAJOR zwingend, MINOR nach Urteil; falsche Befunde mit Beleg in Abschnitt 11 'Verworfene Befunde' dokumentieren statt einarbeiten). Quellen wie im Plan-Kopf; Code nur lesen (Pins ce 7dd41b18, super 40ee7349):
${JSON.stringify(befunde, null, 2)}
Rueckgabe: Liste eingearbeitet/verworfen + ob aus deiner Sicht eine dritte Runde noetig ist.`, {label: 'fix2', phase: 'Fix2', effort: 'xhigh'})
}
return {befunde: befunde.length, hart: harte.length, freigaben: verdicts.map(v => v.freigabe_empfohlen), fixReport}