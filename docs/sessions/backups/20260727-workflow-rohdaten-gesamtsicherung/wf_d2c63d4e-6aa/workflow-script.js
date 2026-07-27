export const meta = {
  name: 'mess-achsen-klaerung-in-gesamtblock-konsolidieren',
  description: 'Die §47-Mess-Achsen-Klaerung (Tooling=Haupt / Ablaufmethodik=Unter) in den §48-Gesamtblock der offenen Punkte einarbeiten',
  phases: [
    { title: 'Erheben', detail: '2 Reader: §48-Ist-Mess-Zeilen + Code-Impl-Aufgabe aus §47' },
    { title: 'Konsolidieren', detail: '1 Synthese: aktualisierte §48-Zeilen als Patch' },
  ],
}
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const COMMON = `Diplomarbeit-Codebasis. Ledger=${LEDGER}, super=${SUPER}, ce=${CE}. Antworte NUR mit StructuredOutput. Belege als datei:zeile.`

phase('Erheben')
const ISTSCHEMA = { type:'object', required:['betroffene_zeilen','luecken'], properties:{
  betroffene_zeilen: { type:'array', items:{ type:'object', required:['ort','ist_text','problem'], properties:{ ort:{type:'string'}, ist_text:{type:'string'}, problem:{type:'string', description:'was ist ueberholt/unpraezise nach der §47-Klaerung'} } } },
  luecken: { type:'array', items:{type:'string'}, description:'Aspekte der §47-Klaerung, die im §48-Block GAR NICHT vorkommen und ergaenzt werden muessen' },
}}
const [blockIst, codeAufgabe] = await parallel([
  () => agent(`${COMMON}
AUFGABE: Lies im Ledger den §48-KONSOLIDIERTEN GESAMTBLOCK (Grep '## §48', der letzte Abschnitt der Datei) UND den §47-Eintrag (Grep '## §47' — Mess-Achsen Haupt/Unter: Mess-Tooling{Wallclock/Makro/Micro}=HAUPT/CEB-Strecke, Ablaufmethodik{Debug/Messen/Release}=UNTER/an-CEB-delegiert, Workloads=UNTER, measurement_categories=CSV-Spalten). Finde im §48-Block ALLE Zeilen, die Mess-Achsen betreffen (Suchbegriffe: mess, measurement_combos, [all], Mess-Vollzug, AKTUELL-mess, emit_measure, Tooling, Ablaufmethodik, workload, Executive-Summary-Punkt-2). Fuer jede: ort (Strang/Kurzname), ist_text (das aktuelle Zitat), problem (was nach §47 ueberholt/unpraezise ist — z.B. 'offene Design-Frage F1/F7' obwohl jetzt GEKLAERT, oder 'nur [all]' ohne die Tooling-Auffaecherungs-Ursache benannt). luecken = §47-Aspekte, die im §48-Block fehlen (z.B. Schema <measurement_tooling>/<run_methodology>, das Haupt/Unter-Prinzip analog an allen 3 Vertragspunkten §24-Ketten-Statik).`, {label:'ist:§48+§47', phase:'Erheben', schema:ISTSCHEMA, model:'opus', effort:'high'}),
  () => agent(`${COMMON}
AUFGABE: Aus der §47-Klaerung folgt eine konkrete IMPL-Aufgabe. Kartiere im ce-Code den Ist-Zustand + praezisiere die Aufgabe. Lies: (1) planner/experiment_plan_director.hpp measurement_combos_of (~959) + walk_perms_ + emit_measure_job (Grep 'measure' + 'when' + 'manual') + plan_legend.hpp measurement_combo (~73). (2) xml_config_parser Mess-Parse (workloads/measurement_categories/telemetry/runtime_dynamic — welche Felder in ThesisProfile). (3) measurement/measurement_axis_registry.hpp + suche ob es schon ein Mess-TOOLING-Konzept (Wallclock/Makro/Micro/Observer-Selektion) im Code/der Registry gibt (Grep 'wallclock|macro|micro|tooling|observer.*select|MeasurementTooling'). Liefere als betroffene_zeilen die Code-Stellen, die fuer die §47-konforme Auffaecherung (Tooling=Haupt -> N CEB-Strecken) geaendert werden muessten, und als luecken: was FEHLT komplett (z.B. gibt es ueberhaupt eine Tooling-Achse/-Registry, oder muss sie neu; wie die Ablaufmethodik-Unter + Mess-Vollzug verdrahtet werden).`, {label:'code:impl-aufgabe', phase:'Erheben', schema:ISTSCHEMA, model:'opus', effort:'high'}),
])

phase('Konsolidieren')
const patch = await agent(`Du bist der Ledger-Redakteur. Die §47-Klaerung (Mess-Tooling=HAUPT/CEB-Strecke, Ablaufmethodik{Debug/Messen/Release}=UNTER/an-CEB-delegiert, Workloads=UNTER, 16 measurement_categories=CSV-Spalten; Prinzip analog an allen 3 Vertragspunkten §24-Ketten-Statik) muss in den §48-Gesamtblock der offenen Punkte eingearbeitet werden.

IST-BEFUND §48-Block + §47:
${JSON.stringify(blockIst, null, 1)}

CODE-IMPL-AUFGABE:
${JSON.stringify(codeAufgabe, null, 1)}

ERZEUGE einen praezisen MARKDOWN-PATCH fuer den §48-Block, der die §47-Klaerung konsolidiert. Format: eine Liste von Aenderungen, je {aktion: 'ERSETZEN'|'ERGAENZEN', anker, alt: '<exaktes altes Zitat oder leer>', neu: '<neuer Text>'}. Anforderungen:
1. Jede §48-Mess-Zeile, die noch 'offene Design-Frage F1/F7' oder 'nur [all]' ohne Ursache traegt -> ERSETZEN durch die geklaerte Fassung: die Mess-Achsen-Auffaecherung ist DESIGN-GEKLAERT (§47), IMPL-OFFEN; measurement_combos_of muss ueber die Mess-TOOLING-Haupt-Achse auffaechern (N Tooling-Konfigs -> N CEB-Strecken), NICHT ueber measurement_categories.
2. Executive-Summary-Punkt-2 aktualisieren: Design-Frage geschlossen, Impl-Aufgabe praezisiert.
3. ERGAENZE (im Mess-Kette-Strang) einen NEUEN offenen Ziel-Eintrag: '**[§47/AKTUELL]** Mess-Tooling-Haupt-Auffaecherung — measurement_combos_of ueber Mess-Tooling {Wallclock/Makro/Micro} auffaechern (N CEB-Strecken [a,b,c]); Schema-Ergaenzung <measurement_tooling>(Haupt)+<run_methodology>(Unter: debug/measure/release); Ablaufmethodik+Workloads als delegierte Unter-Achsen in den Mess-Job-Sweep; Bau=Haupt-only-Gate §42.b (OFFEN, kritisch — vor Messlauf).'
4. ERGAENZE (falls Luecke) einen Vermerk zum §24-Ketten-Statik-Prinzip: Haupt=statisch/CT-eingefroren, Unter=dynamisch/an-Folgestufe-delegiert — analog an ALLEN 3 Vertragspunkten (Planer-Mess / CEB-System / Tier-Organ).
Gib die Patch-Liste als lesbaren Markdown-Text zurueck (nummeriert, je Aenderung mit aktion/anker/alt/neu klar getrennt). ASCII + deutsche Umlaute ok. Keine Vorrede.`, {label:'synthese:patch', phase:'Konsolidieren', model:'opus', effort:'high'})

return { patch }