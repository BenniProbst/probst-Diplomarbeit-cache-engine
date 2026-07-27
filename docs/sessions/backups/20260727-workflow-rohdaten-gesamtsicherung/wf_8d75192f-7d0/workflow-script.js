export const meta = {
  name: 'konsolidierung-seit-compact-fable-xhigh',
  description: 'Elaborierte Konsolidierung (Fable-5-xhigh): Session-Log seit Compact x Ledger x Architektur-Kanon x Plan-Kette -> EIN versoehntes autoritatives Dokument',
  phases: [
    { title: 'Erhebung', detail: '4 Fable-xhigh: Session-Log-Dekret, Ledger-Abgleich, Architektur-Kanon, Plan-Kette' },
    { title: 'Synthese', detail: 'Fable-xhigh: versoehntes Konsolidierungs-Dokument + Inkonsistenz-Register' },
  ],
}
const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const SESS = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/session-seit-compact.txt'
const LEDGER = ROOT + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const SD = ROOT + '/docs/sessions'
const MEM = '/home/comdare/.claude/projects/-home-comdare/memory'
const BASIS =
 'ROLLE: Fable-5-xhigh-Konsolidierer im Team eines CTO/Managers (Diplomarbeit Cache-Engine). Direktive: NIE raten; jede Aussage mit Quelle:Zeile; wo Quellen sich widersprechen, das EXPLIZIT benennen und die NEUESTE Owner-Aussage als bindend markieren; ASCII-only.\n' +
 'KONTEXT: Diese Session hatte eine Opus-Phase mit 3 bestaetigten Achsen-Fehlern (load_framework faelschlich 4. Haupt-Achse statt Meta-Meta; NUMA/page auf reine RT reduziert entgegen dem Dual-Natur-KERN; AVX512 vergessen) + voreiligem Bau vor fertiger Planung. Der Manager hat grob konsolidiert (Memory bereinigt, Alt-Auftrag SUPERSEDED, Ledger §0-GOAL-V7 additiv, Bauplan-v2/v3). Jetzt wird ELABORIERT.\n' +
 'BINDENDE OWNER-KERNE (Gesetz, neueste gewinnt): 3 Achsen-Typen (Mess->Planer / System->CEB nur Kompilation+System+Scheduling / Organ->Tier binary_id-only); System-Haupt-Achsen = target_isa+operating_system+external_utils (external_utils=HUB der Meta-Metas; load_framework=ERSTE Meta-Meta, NICHT Haupt-Achse); compiler+opt_level+atomic128=Unter-Gruppe; scheduling=Unter von target_isa; Dual-Natur (NUMA/page/SIMD: RT-Unter unter ISA an CEB + CT-Haupt am Tier, golden-neutral); opt O0-O3 x simd{no_extension,avx2,avx512}=12 Perms (avx512 nur wo Maschine freigibt, sonst Skip+Warnung; Ofast aus); std::variant nur CEB; golden N=2^17 CRC 0x56F1B721C72DC10E, 320=nur Byte-Wache; ALLE Agenten ab jetzt Fable-5-xhigh (kein Opus).\n'

const p1 = BASIS +
 'DEIN STRANG: SESSION-LOG-DEKRET. Lies VOLLSTAENDIG den redigierten Post-Compact-Verlauf: ' + SESS + ' (189 Segmente). Extrahiere JEDE Owner-Entscheidung/Korrektur/Direktive dieses Segments chronologisch (auch kleine): die 7-Punkte-/A-F-/F1-F6-Antworten, die Dual-Natur-Korrektur, AVX512, Test-Skip, external_utils, NUMA/page-Stufen, golden-Bruch/new-golden, opt O0-O3, Runner-Concurrency, Infra-API-Regel, Fable-Agenten-Direktive, die V3-Forderung, die Konsolidierungs-Auftraege. LIEFERE (max 100 Zeilen): nummerierte Liste jeder Entscheidung mit 1-Satz-Kern + Markierung PERSISTIERT (wo: Memory/Ledger/Doc) oder OFFEN/UNGEPRUEFT. Am Ende: die 5 wichtigsten NOCH-NICHT-vollstaendig-persistierten Punkte.'

const p2 = BASIS +
 'DEIN STRANG: LEDGER-ABGLEICH. Lies in ' + LEDGER + ': §0-GOAL-V7 (der neue Kopf) + suche und lies die Achsen-/Stempel-/Mess-/Kette-Paragraphen (grep -n "§24|§27|§28|§30|§33|§37|§42|§43|§47|§54|§56|§57|§58|§61|§62|§64|§66"). AUFGABE: Stimmt der Ledger nach V7 mit dem bindenden Owner-KERN ueberein? Finde (a) §§, die noch den VOR-STRUKT-R-Stand beschreiben (17 Achsen, ABI-4/5/6, golden==320, 4-5 System-Achsen, load_framework als Haupt-Achse) und von V7 stillschweigend ueberholt sind - die also einen SUPERSEDED-Vermerk brauchen; (b) §§, die dem korrigierten Achsen-Kanon WIDERSPRECHEN; (c) Owner-Entscheide dieser Session, die im Ledger FEHLEN. LIEFERE (max 90 Zeilen): Liste je §: STATUS (aktuell / stale-braucht-Vermerk / widerspricht) + konkreter Nachzug-Text.'

const p3 = BASIS +
 'DEIN STRANG: ARCHITEKTUR-KANON. Lies ' + MEM + '/project_achsen_neuordnung_bindende_sortierung_regressionen.md (korrigiert) + ' + SD + '/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md + 20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md + 20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md + 20260726-DOSSIER-session-gesamtstand-kompaktierungs-anker.md. AUFGABE: Formuliere den KANONISCHEN Ist-Architektur-Stand (die EINE Wahrheit) als in sich konsistentes Modell: 3 Achsen-Typen + Stufen-Zuordnung, die Komplex-Haupt-Achse + Meta-Metas (Hierarchie, load_framework-Platz), Dual-Natur-Register (alle zwei-geteilten Faelle), Stempel-Klammer-Hierarchie, golden-Anker, Organ-Gruppen/Lager-Baeume. Finde WIDERSPRUECHE ZWISCHEN diesen Docs (z.B. Reste der alten NUMA-Lesart, "7. System-Achse", 4-vs-3-Glieder). LIEFERE (max 100 Zeilen): der Kanon in nummerierten Saetzen + eine Liste der doc-internen Widersprueche mit Aufloesung (neueste gewinnt).'

const p4 = BASIS +
 'DEIN STRANG: PLAN-KETTE. Lies ' + SD + '/20260726-AUFTRAG-lane-a-sys-tax-und-lane-c-hub.md (SUPERSEDED, mit Banner) + 20260726-BAUPLAN-V2-lane-a-sys-tax-lane-c-hub-ADVERSARIAL.md. AUFGABE: Ist die Plan-Kette (Alt-Auftrag -> Bauplan-v2 -> laufendes V3) mit dem Architektur-Kanon und den Session-Entscheiden konsistent? Pruefe (a) traegt das v2-Doc noch Reste der 3 Opus-Fehler in seinem KOERPER (nicht nur im Verweis)?; (b) sind alle Session-Entscheide (AVX512, Dual-Natur, load_framework-raus-aus-kSystemAxisOrder, O-6 Kanal-Merge, page_topology-Namenskonflikt) im Plan reflektiert oder fehlen sie?; (c) welche Board-Tasks (#1-#5) sind gegen den Kanon veraltet? LIEFERE (max 90 Zeilen): Konsistenz-Verdikt der Plan-Kette + Liste fehlender/falscher Plan-Elemente + Board-Nachzug.'

phase('Erhebung')
const r = await parallel([
  () => agent(p1, { label: 'session-dekret', phase: 'Erhebung', model: 'fable', effort: 'xhigh' }),
  () => agent(p2, { label: 'ledger-abgleich', phase: 'Erhebung', model: 'fable', effort: 'xhigh' }),
  () => agent(p3, { label: 'architektur-kanon', phase: 'Erhebung', model: 'fable', effort: 'xhigh' }),
  () => agent(p4, { label: 'plan-kette', phase: 'Erhebung', model: 'fable', effort: 'xhigh' }),
])
const [sess, led, arch, plan] = r.map(x => String(x || 'FEHLT'))

phase('Synthese')
const synth = await agent(
  BASIS + '\nDU ERSTELLST DAS ELABORIERTE KONSOLIDIERUNGS-DOKUMENT aus vier Fable-xhigh-Straengen:\n' +
  '\n=== SESSION-LOG-DEKRET ===\n' + sess.slice(0, 14000) +
  '\n=== LEDGER-ABGLEICH ===\n' + led.slice(0, 12000) +
  '\n=== ARCHITEKTUR-KANON ===\n' + arch.slice(0, 14000) +
  '\n=== PLAN-KETTE ===\n' + plan.slice(0, 12000) +
  '\nLIEFERE ein autoritatives Markdown-Dokument (ASCII, max 160 Zeilen), das der Manager 1:1 committen kann: (1) Kopf + Autoritaets-Kette + Stand; (2) DER KANONISCHE ARCHITEKTUR-STAND (die EINE Wahrheit, nummeriert, jede Aussage bindend); (3) INKONSISTENZ-REGISTER K-01..K-NN: je Fund die Quelle, der Widerspruch, die Aufloesung (neueste Owner-Aussage), und ob schon behoben oder TODO; (4) LEDGER-NACHZUG-LISTE (welche §§ SUPERSEDED-Vermerk oder Korrektur brauchen); (5) PLAN-KETTE-STATUS (Auftrag/v2/v3 + Board); (6) OFFENE OWNER-ENTSCHEIDE; (7) NAECHSTE SCHRITTE in Reihenfolge. Sei elaboriert und vollstaendig - das ist der Anker fuer den Rest der Arbeit.',
  { label: 'konsolidierungs-dokument', phase: 'Synthese', model: 'fable', effort: 'xhigh' })

return { session: sess, ledger: led, architektur: arch, plan: plan, konsolidierung: String(synth) }