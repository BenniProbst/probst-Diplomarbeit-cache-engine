export const meta = {
  name: 'todo-audit-e1-e4-gegen-ist-stand',
  description: 'Audit der ab 28.06. (v.a. letzte 5 Tage 04-09.07) als ERLEDIGT/VOLLZOGEN markierten Ledger- + Task-Board-TODOs gegen den TATSAECHLICHEN Code-Stand + das E1-E4-Experiment-Maschinerie-Wissen. Findet TODOs, die mangels E1-E4-Wissen ebenen-falsch/schein-erledigt markiert wurden (wie der #31-Fehl-Bau: E2/cache-engine statt E4/XML).',
  phases: [
    { title: 'Audit', detail: '6 parallele Auditoren: E4/E3/E2/E1 + Task-Board-letzte-5-Tage + Ledger-Historie/Verlauf' },
    { title: 'Synthese', detail: 'Gesamt-Verdikt: echt-erledigt vs. schein-erledigt/ebenen-falsch + Nacharbeits-Liste' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'

const E14 = `E1-E4-EXPERIMENT-MASCHINERIE (Pruefmassstab, Dossier §13, cache-engine docs/sessions/20260628-KONTEXT-DOSSIER-mess-echtheit-gattungen-observer-pruefdock-A2welle.md §12-§15 + super docs/sessions/20260628-SESSION-ENDE-9-TOPDOWN-AUDIT-E4-E1-EBENEN-EINTEILUNG-UEBERGABE.md):
- E4 = XML-Experiment-DEFINITION (das eigentliche Experiment IST die XML, Superprojekt Code/experiment_config + Code/02_messung_driver) + Messwert-Auswertung (03-06 CSV->LaTeX->PDF). Ziel #229: XML-only, die Diplomarbeit aendert NUR die XML.
- E3 = Permutations-B+-Baum PRO GATTUNG (Abstract Factory je Gattung SearchAlgorithm/Container/Graph; cache-engine builder/experiment_tree).
- E2 = Tier-Binaries / Achsen-Organe / Bau (StaticAxisNode, COMPILE-TIME, eine DLL je Permutation; cache-engine libs/cache_engine/axes + anatomy).
- E1 = RC-Laufzeit / DynamicVariableNode / Mess-Durchfuehrung (Resource Control, Runtime-for-Schleife auf EINER Binary).
Ein TODO ist EBENEN-RICHTIG erledigt, wenn seine Umsetzung in der KORREKTEN E-Ebene sitzt. Beispiel Fehl-Bau: #31 (Mess-Frameworks x Workloads) wurde als compile-time-mp_product in die cache-engine (E2/Bibliothek) gebaut, gehoert aber in E4 (XML-Definition) -> SCHEIN-erledigt, ebenen-falsch.`

const AUDITORS = [
  {
    label: 'E4-xml-definition-auswertung',
    prompt: `READ-ONLY-Auditor. super=${SUP}, cache-engine=${CE}. Keine mutierenden Befehle.

${E14}

AUFGABE: Audite alle E4-TODOs (XML-Experiment-Definition + Auswertungs-Kette), die seit 28.06. als erledigt/vollzogen markiert wurden, gegen den tatsaechlichen Code-Stand.
E4-TODOs (Ledger [E4]): #156 (M3-Gesamt-Lauf), #162 (SOTA-Reihen A/B/C), #152/#187/#165 (PMC/Quality/Perzentil), #178 (Stufe->Reihe), #184 (Dataset-Loader), #218/#219 (Resume/Pipeline), #226 (Appendix-LIMITs), #25 (Thesis-Text). Plus die Task-Board-#39 (measurement-all-Familie) + #31 (Mess-Frameworks x Workloads).
Lies (datei:zeile): Code/experiment_config/*.xml, Code/test_data_xml/messreihe_v32_schema.xsd, Code/02_messung_driver/, Code/03_binary_to_csv..06, und die Ledger-§12/§13-Eintraege zu diesen TODOs (super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md).
Pruefe je TODO: (a) was BEHAUPTET das Ledger als erledigt? (b) was ist der TATSAECHLICHE Code-Stand? (c) ist es EBENEN-RICHTIG (E4 = XML-Definition + Auswertung)? (d) Ist die XML-only-Steuerung (#229) erreicht — kann ein Experiment allein durch XML-Aenderung definiert werden, oder braucht es Code-Aenderungen (dann E4-Luecke)?
Gib je TODO: {id, ledger-behauptung, ist-stand, ebenen-verdikt (echt-erledigt / schein-erledigt-ebenen-falsch / teilweise), beleg datei:zeile}.`,
  },
  {
    label: 'E3-bplus-baum-gattung',
    prompt: `READ-ONLY-Auditor. cache-engine=${CE}, super=${SUP}. Keine mutierenden Befehle.

${E14}

AUFGABE: Audite die E3-TODOs (Permutations-B+-Baum PRO GATTUNG, Abstract Factory) seit 28.06.
E3-TODOs: #223 (Konformitaets-Gate import->GATE->messen) + die Gattungs-Bindung GenusBindingTraits (Task-Board #26 234-V, #27 SwissTable, #29 container). Der B+-Baum soll PRO GATTUNG als Abstract Factory permutieren.
Lies (datei:zeile): cache-engine builder/experiment_tree/ (experiment_tree.hpp, cache_engine_builder_iterator.hpp, genus_binding_traits.hpp, run_lazy_static_then_dynamic), builder/pruef_dock/conformance_gate.hpp; Ledger-Eintraege zu #223/#26/#27/#29.
Pruefe je TODO: ledger-behauptung vs. ist-stand vs. ebenen-richtig (E3 = B+-Baum pro Gattung). Ist #223 wirklich in run_lazy_static_then_dynamic verdrahtet? Sind #26/#27/#29 ebenen-richtig (E2-Achsen vs. E3-Gattungs-Bindung)?
Gib je TODO: {id, ledger-behauptung, ist-stand, ebenen-verdikt, beleg datei:zeile}.`,
  },
  {
    label: 'E2-tier-binaries-achsen',
    prompt: `READ-ONLY-Auditor. cache-engine=${CE}, super=${SUP}. Keine mutierenden Befehle.

${E14}

AUFGABE: Audite die E2-TODOs (Tier-Binaries / Achsen-Organe / compile-time-Bau, StaticAxisNode) seit 28.06. — der laut Dossier §14 ZENTRALE Engpass.
E2-TODOs (Ledger [E2]): #188 (Weg-B-Mess-Echtheit, search_organ_-Entfall, container_ traegt echtes search_algo — WURZEL-HEBEL), #211 (container_-O(n)-Rebuild raus), #213 (Policy-Allocator real T6), #214 (scan-Organ), #215 (320-DLL-Neubau-Schleuse), #216 (seg_ns n>1), #217 (Array-Gattung), #19 (Allokatoren linken), #163 (SIMD/ISA), #185 (TPIE io_dispatch), #125 (lazy DLL), #224 (GoF-Etiketten). Plus Task-Board #49/#50 (Metaprog-Guards).
Lies (datei:zeile): cache-engine libs/cache_engine/axes/ + anatomy/ (abi_adapter.hpp, search_algorithm_anatomy.hpp, die 19 Achsen-Organe), builder/codegen; Ledger zu diesen TODOs.
Pruefe je TODO: ledger-behauptung vs. ist-stand vs. ebenen-richtig (E2 = compile-time-Achsen-Organe). Besonders #188 (Wurzel): traegt container_ real das search_algo, oder laeuft es noch ueber search_organ_-Spiegel? Ist der Mess-Apparat echt (Meta-Lehre #3) oder parallel?
Gib je TODO: {id, ledger-behauptung, ist-stand, ebenen-verdikt, beleg datei:zeile}.`,
  },
  {
    label: 'E1-rc-laufzeit',
    prompt: `READ-ONLY-Auditor. cache-engine=${CE}, super=${SUP}. Keine mutierenden Befehle.

${E14}

AUFGABE: Audite die E1-TODOs (RC-Laufzeit / DynamicVariableNode / Mess-Durchfuehrung) seit 28.06.
E1-TODOs (Ledger [E1]): #221 (RC-Achsen-Konsum-Setter + apply1-Verdrahtung — laut Dossier §14/§16 HARD-GATE vor #156, sonst Phantom-Zeilen), #225 (Second-Execution/Zwei-Phasen, User-Diskussion).
Lies (datei:zeile): cache-engine builder/experiment_tree/runtime_variable_loop.hpp, perm_runner.hpp, anatomy/abi_adapter.hpp (applied_rc_), die RC-Felder + ob eine Achse sie KONSUMIERT (Grep ueber die 19 Achsen); Ledger + Dossier §16 zu #221.
Pruefe: Der Dossier-Befund (§16) sagt applied_rc_ ist write-only, hw_prefetcher nicht ueber POD-Pfad -> #156-Runtime-dynamic-Zeilen sind PHANTOM bis #221 landet. Ist #221 tatsaechlich noch offen (kein Achsen-Konsum), oder wurde es inzwischen (schein-?)erledigt? Belege mit Grep-Ergebnis.
Gib je TODO: {id, ledger-behauptung, ist-stand, ebenen-verdikt, beleg datei:zeile}.`,
  },
  {
    label: 'taskboard-letzte-5-tage',
    prompt: `READ-ONLY-Auditor. super=${SUP}, cache-engine=${CE}. Keine mutierenden Befehle.

${E14}

AUFGABE: Audite die Task-Board-TODOs der LETZTEN 5 TAGE (04.-09.07), die als VOLLZOGEN/completed markiert sind, gegen den tatsaechlichen Code-Stand + E1-E4. Der User-Verdacht: sie wurden mangels E1-E4-Wissen (das erst jetzt gefunden wurde) ebenen-falsch/schein-erledigt markiert (wie der #31-Fehl-Bau).
Fokus-TODOs (experiment-/mess-nah, Task-Board): #26 (234-V-b Shaped-Naht BST/Hash/SkipList), #27 (7b-3 SwissTable SIMD), #29 (comdare::container Kopf-Framework), #31 (Workload-Matrix — BEKANNTER Fehl-Bau, als Referenz), #39 (measurement-all-Familie Migration), #49/#50 (Metaprog-Guards), #9 (#267 CMD-1 Compile-time-Command-Basis + Mess-Visitor), #16/#25 (Datensatz-Akten + Loader).
Lies (datei:zeile): die Ledger-§12-Eintraege (super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md) + die betroffenen Code-Dateien + die sessions der letzten 5 Tage (super docs/sessions/2026070[4-9]*).
Pruefe je TODO: (a) ledger/task-behauptung, (b) ist-stand, (c) EBENEN-VERDIKT gegen E1-E4 — sitzt die Umsetzung in der korrekten Ebene? Besonders: wurde etwas in die cache-engine (E2/Bibliothek) gebaut, das in E4 (XML) gehoert, oder umgekehrt?
Gib je TODO: {id, ledger-behauptung, ist-stand, ebenen-verdikt (echt/schein-ebenen-falsch/teilweise), beleg datei:zeile}.`,
  },
  {
    label: 'ledger-historie-verlauf-28-06-bis-heute',
    prompt: `READ-ONLY-Auditor. super=${SUP}, cache-engine=${CE}. Keine mutierenden Befehle.

${E14}

AUFGABE: Rekonstruiere den VERLAUF der TODO-Bearbeitung ab 28.06. und finde den Bruch, an dem das E1-E4-Wissen verloren ging (der User-Verdacht: nach dem 28.06.-Audit wurde ohne E1-E4-Wissen weitergearbeitet).
Lies (datei:zeile): super docs/sessions/2026062[8-9]* + 2026070[1-9]* (chronologisch, Titel + Kern), die uml_planning/Y*/Z*-Docs (05.07-Stand), docs/sessions/20260705-arch-verify-w1-w5-rohdaten/ (W1-W5-Arch-Verify die E-Ebenen nutzte), das Ledger §12/§13-Verlauf.
Beantworte:
1. Wann wurde das E1-E4-Wissen zuletzt aktiv genutzt (28.06.-Audit, 05.07-W1-W5)? Wann ging es in den Sessions verloren (wurde die E-Ebenen-Einteilung in den TODO-Abarbeitungen der letzten 5 Tage noch referenziert)?
2. Welche TODOs wurden NACH dem Wissensverlust als erledigt markiert, ohne E1-E4-Bezug?
3. Wurde die E-Ebenen-Einteilung (§15 der Session-Ende-9) in neueren Dokumenten fortgeschrieben oder fallengelassen?
Gib eine chronologische Verlaufs-Karte + eine Liste der potenziell schein-erledigten TODOs (ohne E1-E4-Bezug bearbeitet).`,
  },
]

phase('Audit')
const audits = await parallel(AUDITORS.map((a) => () => agent(a.prompt, { label: a.label, phase: 'Audit' })))

phase('Synthese')
const joined = audits
  .map((m, i) => (m ? `\n\n===== AUDIT: ${AUDITORS[i].label} =====\n${m}` : `\n\n===== AUDIT: ${AUDITORS[i].label} — FEHLGESCHLAGEN =====`))
  .join('')

const synthPrompt = `Du bist der Chef-Auditor der Diplomarbeit. Dir liegen 6 READ-ONLY-Audits vor (E4/E3/E2/E1 + Task-Board-letzte-5-Tage + Ledger-Historie), die die seit 28.06. als ERLEDIGT markierten TODOs gegen den tatsaechlichen Code-Stand + das E1-E4-Experiment-Maschinerie-Wissen geprueft haben.

${E14}

KONTEXT: Der User-Verdacht (bestaetigt am #31-Fehl-Bau): Ledger-TODOs wurden mangels E1-E4-Wissen als "erledigt" markiert, aber ebenen-falsch/schein-erledigt bearbeitet. Das E1-E4-Konzept wurde am 28.06. etabliert, aber in den Folge-Sessions (v.a. letzte 5 Tage) womoeglich nicht mehr angewandt.

Synthetisiere mit datei:zeile-Belegen:
1. GESAMT-VERDIKT: Wie viele der auditierten TODOs sind ECHT ebenen-richtig erledigt vs. SCHEIN-erledigt (ebenen-falsch) vs. TEILWEISE?
2. NACHARBEITS-LISTE (das Wichtigste): Welche als "erledigt" markierten TODOs sind in Wahrheit ebenen-falsch/unvollstaendig und brauchen ebenen-richtige Nacharbeit? Pro TODO: {id, was-behauptet, was-ist-wirklich, korrekte-E-Ebene, was-fehlt}. Sortiere nach Schwere (E2-Wurzel #188 + E1 #221 zuerst, falls offen).
3. Der #31-Fehl-Bau als Muster: Welche ANDEREN TODOs zeigen dasselbe Muster (in die cache-engine/E2 gebaut, was in E4/XML gehoert — oder umgekehrt)?
4. VERLAUF: Wann ging das E1-E4-Wissen verloren, und welche TODO-Welle ist betroffen?
5. KORREKTE REIHENFOLGE fuer die Nacharbeit (top-down E4->E1, wie im 28.06.-Audit: #188 E2-Wurzel -> #221 E1 -> #223 E3 -> #215 -> E4-#156/#162; plus die schein-erledigten der letzten 5 Tage).

Sei schonungslos und ebenen-praezise. Die Audits:${joined}`

const synth = await agent(synthPrompt, { label: 'synthese-todo-audit-e1-e4', phase: 'Synthese' })

return { synthese: synth, audits: audits }
