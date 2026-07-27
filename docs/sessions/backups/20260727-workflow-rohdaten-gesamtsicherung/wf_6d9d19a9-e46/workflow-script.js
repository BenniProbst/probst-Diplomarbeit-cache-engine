export const meta = {
  name: 'o8-fenster-ultracode-planung',
  description: 'ultracode-Planungsrunde: atomarer Ausfuehrungsplan fuer das O-8-FENSTER (7e, Vorab-GO Ledger 72)',
  phases: [
    { title: 'Extraktion', detail: '4 parallele Leser: Ledger, Bauplan, Owner-Wortlaute, Code-Ist' },
    { title: 'Synthese', detail: 'atomarer Schritt-Plan als Session-Doc' },
    { title: 'Verify', detail: '3 adversariale Lenses gegen die Quellen' },
    { title: 'Fix', detail: 'Befunde einarbeiten' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PLAN = SUPER + '/docs/sessions/20260727-PLAN-o8-fenster-atomar-ultracode.md'

const SCOPE = `Das O-8-FENSTER (Uebergabe 7e, VORAB-GO Ledger §72, EIN Agent allein, atomar) umfasst:
(1) A2 external_utils-Rename; (2) A3 = kSystemAxisOrder->DREI System-Haupt-Achsen, load_framework-Umzug in den MESS-Realm als Meta-Meta-HAUPT-Achse K1 (Owner-Regression R-G!), target_isa-Komplex-Wrapper (Bauplan IV.2.2), C-3c-Patch; (3) A8.2/A8.3 Stempel; (4) Lane F inkl. R1-R3 = GN_PREFIX, T-a/b/c-Wachen, system_version_suffix.hpp Single-Source, UND R3 haengt gate_contribution_identity_text ein (Ledger §70.9 Variante A); (5) Mess-Stempel-Segment (RF-1/§70.1); (6) V-1 Vendor-Provisioning-Entkopplung (Bauplan TEIL V, das EINZIGE Byte-Paket des Retires); (7) Golden-String-Neuanker per D2.10-grep-Checkliste; (8) O-4b <machines>-XSD. DANACH (nicht im Fenster, aber im Plan als Folge nennen): V-3/V-4-Retire byte-neutral.
Kontext-Fakten: golden N=2^17=131072, ABI-7, 18 Organ-Achsen; AxisKind erhaelt additiv measurement_meta_meta (RF-1, Kategorie-Name system_meta_meta fuer System-Seite); target_isa = Komplex-Achse IN SICH (feste Glieder RAM-Frequenz+CAS+CPU-Fabrikation, je Maschine deklariert via XML <machines>, NUR Stempel-Identitaet; Hostname=Instanz-Lookup, Tupel=Klassen-Identitaet); RF-7: Komplex-Achse = EIN Feld im Haupt-Achsen-Array ihres Typs, je Typ EINE Array-Stempel-Zeile; System-Achsen tragen BUILD-Version als Stempel-Variable; machine_identity.hpp existiert bereits (O-4, kDeclaredMachines, header-only); simd_build_gate.hpp ist C-3a-scharf. J-Kette-Beweise: N=316 braucht -DCOMDARE_V32_ENABLE=ON; 7 Byte-Wachen (golden_fullpilot_320_binary_ids.txt + _abi4/5/6, system_axis_registry.xml, permutation_axes.xml, m3v2_study.profile.xml). ASCII-only in Code-Kommentaren. HEAD-Stand: ce development 7dd41b18, super development 40ee7349.`

phase('Extraktion')
const extr = await parallel([
  () => agent(`Lies im Repo ${SUPER} die Datei docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md, dort NUR die Abschnitte §69 bis §75 (am Dateiende; grep nach '## §69' o.ae. und ab dort lesen). Extrahiere ALLE Auflagen, Entscheide und Wortlaute, die fuer das folgende Paket relevant sind: ${SCOPE}
Gib einen strukturierten Report: je Auflage -> Quell-Paragraph, woertliches Kernzitat (kurz), betroffenes O-8-Glied (1-8). Nichts erfinden; wenn ein Glied im Ledger nicht vorkommt, sag das explizit.`, {label: 'extrakt:ledger', phase: 'Extraktion', effort: 'xhigh'}),
  () => agent(`Lies im Repo ${SUPER} die Datei docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md (TEIL I-V). Fokus: TEIL IV Gate-Register + Abschnitte IV.2.1-IV.2.12 + IV.6, TEIL V (Retire+Merge, besonders V-1 Vendor-Provisioning-Entkopplung), Lane-F-/R1-R3-Definitionen, D2.10-grep-Checkliste (Golden-String-Neuanker), O-4b <machines>-XSD-Auflage. Extrahiere fuer dieses Paket: ${SCOPE}
Report: je Planelement -> Fundstelle (Abschnitt), konkrete technische Vorgabe, Abhaengigkeiten/Reihenfolge-Auflagen, Byte-Klasse (byte-neutral vs byte-tragend vs golden-veraendernd) falls das Doc sie nennt.`, {label: 'extrakt:bauplan', phase: 'Extraktion', effort: 'xhigh'}),
  () => agent(`Lies im Repo ${SUPER} die zwei Owner-Wortlaut-Docs: docs/sessions/20260726-SESSION-od-antworten-load-framework-mess-realm-target-isa-komplex.md und docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md. Extrahiere die Owner-VERBATIM-Vorgaben, die dieses Paket binden: ${SCOPE}
Report: je Vorgabe -> Doc + OD/RF-Nummer, Kernzitat, was daraus fuer die Implementierung ZWINGEND folgt (User-KERN = Gesetz; Abweichung = Regression).`, {label: 'extrakt:owner-wortlaute', phase: 'Extraktion', effort: 'xhigh'}),
  () => agent(`Erhebe den CODE-IST-Stand fuer das O-8-Fenster in den Repos super=${SUPER} und ce=${CE} (ce ist Submodul; HEADs: ce 7dd41b18, super 40ee7349; NUR LESEN, nichts editieren). Finde mit grep/Read die Ist-Fundstellen (datei:zeile) fuer: (a) kSystemAxisOrder + System-Haupt-Achsen-Array (wieviele Eintraege heute, wo); (b) external_utils-Hub (hardware_meta_meta_axis.hpp, meta_meta_admission.hpp — Namen/Struktur); (c) load_framework heutige Verortung; (d) target_isa heutige Definition; (e) machine_identity.hpp (kDeclaredMachines-Struktur); (f) simd_build_gate.hpp gate_contribution-Stellen (wo gate_contribution_identity_text einzuhaengen waere, §70.9 Variante A); (g) system_version_suffix / GN_PREFIX / T-a/b/c-Wachen-Kandidaten (tools/system_axis_registry_gen/main.cpp A7'-Wache); (h) golden-String-Verankerungen (welche Dateien tragen den Golden-Stempel-String; D2.10-relevante greps); (i) XSD-Dateien fuer <machines> (wo liegen die Schemata); (j) Vendor-Provisioning-Verdrahtung (V-1: wo haengt Provisioning heute am Manifest/Registry-Kanal); (k) AxisKind-Enum (measurement_meta_meta schon da? Werte). Report: je Punkt Fundstellen + 1-2 Saetze Ist-Beschreibung. ${SCOPE}`, {label: 'extrakt:code-ist', phase: 'Extraktion', effort: 'xhigh'}),
])
const [ledger, bauplan, wortlaute, codeist] = extr
if (extr.filter(Boolean).length < 4) log('WARNUNG: mindestens eine Extraktion lieferte null')

phase('Synthese')
await agent(`Du bist der Planungs-Synthese-Agent. Schreibe die Datei ${PLAN} (NEU) — den ATOMAREN AUSFUEHRUNGSPLAN fuer das O-8-FENSTER. Paket-Scope: ${SCOPE}

QUELLEN-EXTRAKTE (von 4 parallelen Lesern; bei Widerspruch: Owner-Wortlaut > Ledger > Bauplan > Code-Ist):
=== LEDGER §69-75 ===
${ledger}
=== BAUPLAN TEIL I-V ===
${bauplan}
=== OWNER-WORTLAUTE OD/RF ===
${wortlaute}
=== CODE-IST ===
${codeist}

PLAN-ANFORDERUNGEN: (1) Nummerierte Schritt-Liste in zwingender Reihenfolge, je Schritt: Ziel-Dateien (datei:zeile-Anker aus dem Code-Ist), konkrete Aenderung, Byte-Klasse (byte-neutral / byte-tragend / golden-veraendernd), Beweis-Kommando(s) nach dem Schritt. (2) Die J-Kette als Gesamt-Gate am Ende (Configure V32=ON, 316/316, 7 Byte-Wachen — beim Golden-Neuanker aendern sich Wachen-Erwartungen: explizit ausweisen WELCHE Wache wann brechen DARF und wie neu verankert wird, D2.10-grep-Checkliste einbetten). (3) Tree-Serialisierung: EIN Agent, beide Baeume, Freeze-Punkte. (4) Rollback-Strategie je golden-veraenderndem Schritt. (5) Explizite NICHT-Ziele (V-3/V-4 erst DANACH; keine .gitlab-ci.yml-Edits — Infra-Gebiet). (6) ASCII-only-Kommentar-Regel + Selbstcheck-Zeile ins Meldeformat. (7) Offene Punkte, die der Manager vor Fenster-Start klaeren muss, als eigene Liste. Markdown, deutsch, ASCII-transliteriert (ue/ae/oe/ss; § erlaubt). Deine Rueckgabe: NUR der Pfad + Schrittanzahl + die Liste der offenen Punkte.`, {label: 'synthese:plan', phase: 'Synthese', effort: 'xhigh'})

phase('Verify')
const LENSES = [
  {key: 'vollstaendigkeit', prompt: `Pruefe den Plan ${PLAN} adversarial auf VOLLSTAENDIGKEIT gegen den Paket-Scope: sind ALLE 8 Glieder + Folge-Vermerk V-3/V-4 mit konkreten Schritten, Dateien und Beweisen abgedeckt? Fehlt ein RF-/OD-/§70.9-/RF-1-Detail? Scope: ${SCOPE}`},
  {key: 'quellen-treue', prompt: `Pruefe den Plan ${PLAN} adversarial auf QUELLEN-TREUE: Lies selbst nach in ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (§69-75) und ${SUPER}/docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md. Widerspricht ein Plan-Schritt einem Owner-Wortlaut oder einer Ledger-Auflage? User-KERN = Gesetz. Scope: ${SCOPE}`},
  {key: 'byte-klassen', prompt: `Pruefe den Plan ${PLAN} adversarial auf BYTE-KLASSEN-KORREKTHEIT: Verifiziere je Schritt am realen Code (super=${SUPER}, ce=${CE}, nur lesen) ob die deklarierte Byte-Klasse stimmt (beruehrt der Schritt Emissions-Pfade/golden-Strings wirklich/wirklich nicht?), ob die Wachen-Brech-Erwartungen beim Golden-Neuanker konsistent sind und ob die Beweis-Kommandos das Behauptete wirklich beweisen (kein Schein-Beweis). Scope: ${SCOPE}`},
]
const VERDICT = {type: 'object', properties: {befunde: {type: 'array', items: {type: 'object', properties: {schwere: {type: 'string', enum: ['BLOCKER', 'MAJOR', 'MINOR']}, beschreibung: {type: 'string'}, quelle: {type: 'string'}}, required: ['schwere', 'beschreibung']}}, freigabe_empfohlen: {type: 'boolean'}}, required: ['befunde', 'freigabe_empfohlen']}
const verdicts = (await parallel(LENSES.map(l => () => agent(l.prompt + ' Gib NUR echte, belegte Befunde (mit Quelle/Fundstelle); keine Stil-Noergelei.', {label: 'verify:' + l.key, phase: 'Verify', schema: VERDICT, effort: 'xhigh'})))).filter(Boolean)
const alleBefunde = verdicts.flatMap(v => v.befunde)
const harte = alleBefunde.filter(b => b.schwere !== 'MINOR')
log(`Verify: ${alleBefunde.length} Befunde, davon ${harte.length} BLOCKER/MAJOR`)

phase('Fix')
if (alleBefunde.length > 0) {
  await agent(`Arbeite die folgenden adversarialen Befunde in den Plan ${PLAN} ein (editiere die Datei; bei MINOR nach eigenem Urteil, BLOCKER/MAJOR zwingend; wenn ein Befund falsch ist, widerlege ihn mit Beleg in einem 'Verworfene Befunde'-Abschnitt am Planende statt ihn einzuarbeiten):
${JSON.stringify(alleBefunde, null, 2)}
Quellen: Ledger ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md §69-75, Bauplan docs/sessions/20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md, Code super=${SUPER} ce=${CE} (Code nur lesen). Rueckgabe: was eingearbeitet, was verworfen.`, {label: 'fix:einarbeiten', phase: 'Fix', effort: 'xhigh'})
}
return {planPath: PLAN, befunde: alleBefunde.length, hart: harte.length, freigaben: verdicts.map(v => v.freigabe_empfohlen)}