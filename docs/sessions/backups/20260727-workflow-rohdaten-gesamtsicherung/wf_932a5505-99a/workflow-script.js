export const meta = {
  name: 'resume-konsolidierung-vergessene-arbeit',
  description: 'Konsolidiere offene/vergessene Arbeit (Ledger/Audits/Plaene/Tasks) + adversariale Suche nach weiteren latenten Build-Bruechen nach Systemabsturz',
  phases: [
    { title: 'Sammeln', detail: 'parallele Leser je Quelle + latente-Bruch-Jagd' },
    { title: 'Synthese', detail: 'ein konsolidiertes Register' },
    { title: 'Kritik', detail: 'Vollstaendigkeits-Kritiker' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUP + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const AUD = SUP + '/docs/audits'
const PLA = SUP + '/docs/plaene'
const CE = SUP + '/Code/external/comdare-cache-engine'
const SCR = '/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad'

const GO = 'Bereits ENTSCHIEDEN (neueste Fakten gewinnen gegen aeltere): VOLLES GO (Q1-Q5, DLL-Load-B, #50 Caching, #51 Storage, #52 variant). golden N=2^17=131072 (all-vary), golden-320 bleibt Alias/Snapshot. INC-2d=Variante A VOLLZOGEN (ABI-6, 17 Slots, isa raus). Q2=Option C (extension_hardware 6. System-Achse). opt-Default=O3. Storage: B=prod-MinIO Bucket cache-engine-tier-binaries, C=measure-drop curl-PUT (Entscheid A), mc-Shellout. ERLEDIGT diese Session: Weg-A-CI-Storage-Aktivierung (commit 0b669e9, inert-by-default), Infra-Handout an Cluster (6 Punkte P1-P6), #50-CI-Bruch behoben (algo_version-Weiterleitung in 11 Observable-Huellen fehlte -> stale-gruen, jetzt commit 5da2caf7, CE-Pointer ebf3ac5, g++-16+clang-22 verifiziert).'

const ITEM_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    items: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          id: { type: 'string', description: '#NN oder Kurz-ID' },
          title: { type: 'string' },
          source: { type: 'string', description: 'datei:zeile oder Ledger-§' },
          tag: { type: 'string', enum: ['ERLEDIGT','ENTSCHIEDEN-NICHT-GEBAUT','GATED','OFFENE-ENTSCHEIDUNG','VERGESSEN','LATENTER-BUILD-BRUCH'] },
          next_action: { type: 'string' },
          golden_neutral: { type: 'boolean' },
          severity: { type: 'string', enum: ['kritisch','hoch','mittel','gering'] },
        },
        required: ['title','source','tag','next_action'],
      },
    },
  },
  required: ['items'],
}

phase('Sammeln')
const readers = [
  { label: 'ledger', prompt: `Lies ${LEDGER} VOLLSTAENDIG (grosse Datei; lies in Abschnitten). Extrahiere ALLE offenen/pending/gated/TODO/GO-noetig-Punkte als items. ${GO} Klassifiziere jeden Punkt mit tag. Belege source=Ledger-§/Zeile.` },
  { label: 'audits', prompt: `Lies ${AUD}/20260718-konformitaets-audit-9dim-REPORT.md UND ${AUD}/20260718-ketten-konformitaets-audit-planer-ceb-tier-REPORT.md VOLLSTAENDIG. Extrahiere die Fix-Listen 9-Dim G1-G10 und Ketten P1-P8 als items (je Fix: title, source=datei:zeile, severity, golden_neutral, next_action). ${GO} Markiere welche golden-neutrale Sofort-Quick-Wins sind.` },
  { label: 'plaene', prompt: `Lies die 6 neuesten ${PLA}/20260718-*.md — NUR die "Offene Entscheidungen"-Abschnitte (E1-E5 opt-g, golden-N Ziel, INC-2d Fork, incremental-caching 7 Entscheidungen, storage 6 Entscheidungen). ${GO} Fuer jede Entscheidung: ist sie laut GO schon entschieden (tag=ERLEDIGT/ENTSCHIEDEN-NICHT-GEBAUT) oder noch offen (tag=OFFENE-ENTSCHEIDUNG)? items zurueck.` },
  { label: 'tasks-drift', prompt: `Aktuelle Task-Liste (user-sichtbare TODO): #1[completed]#50 Caching, #2[in_progress]#51 Storage, #3[completed]#45 A2-Neben, #4[pending]#44 Rest-Konformitaet, #5[pending]#43 INC-29.3 SampleStatus, #6[pending]#46 FF0-FF4 Messlauf gated, #7[pending]#47 Messwert-LaTeX+Thesis-PDF gated, #8[completed]#48 MEMORY, #9[completed]#52 variant, #10[completed]#53 Sessions, #11[pending]#54 B+-Baum-Nachweis, #12[completed]#55 Voll-Konsolidierung, #13[completed]#56 Infra-Handout. WICHTIG: #50 war [completed], hatte aber einen realen CI-Bruch (algo_version stale-gruen, jetzt behoben) — flagge falsch-abgeschlossene Tasks. Vergleiche die Liste gegen die Ledger-offenen-Punkte (${LEDGER}). Finde: (a) Drift (Task sagt X, Ledger sagt Y), (b) Doppel-Tracking, (c) Ledger-Punkte OHNE Task = VERGESSEN, (d) Tasks als [completed] die es nicht wirklich sind. items zurueck.` },
  { label: 'latent-build-bruch', prompt: `ADVERSARIAL + HOECHSTE PRIORITAET. Gerade gefunden: #50 hatte einen stale-gruenen Build-Bruch — 'static constexpr algo_version' war in den Strategie-Klassen ergaenzt, aber NICHT in den Observable*-Wrapper-Huellen weitergeleitet; build_axis_variant_version_table.reflect_versions liest W::algo_version ueber die Huelle -> brach nur bei clean rebuild (nicht in stale local build). Behoben in 11 Huellen (commit 5da2caf7). SUCHE WEITERE ANALOGE LATENTE BRUECHE in ${CE}: (1) andere Concept-erzwungene static-Member (name(), family_id, flag_suffix, algo_version, version()) die eine Wrapper-/Huellen-Klasse (grep 'class Observable', 'return .*::name()') NICHT weiterleitet obwohl ein reflect_*/mp_for_each sie ueber die Huelle liest; (2) reflect_*-Funktionen (grep 'reflect_' in builder/experiment_tree) die W::member lesen — hat JEDE iterierte Achse/Huelle diesen member? (3) static_assert/Concept die nur bei clean build feuern. Fuer jeden Verdacht: verifiziere per targeted compile — die Include-Roots stehen in ${SCR}/inc.txt (nutze: g++-16 -std=c++23 -fsyntax-only $(cat ${SCR}/inc.txt) <deine-tu.cpp> ; schreibe eine winzige TU die den Verdacht instanziiert). Melde NUR real-bestaetigte oder hoch-plausible Verdachtsfaelle als items mit tag=LATENTER-BUILD-BRUCH, severity, source=datei:zeile, next_action. Wenn nichts weiter gefunden: leere items + eine Notiz warum (welche reflect_*/Huellen geprueft, alle vollstaendig).` },
]
const collected = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Sammeln', schema: ITEM_SCHEMA }).then(x => ({ src: r.label, items: (x && x.items) || [] }))))

const flat = collected.filter(Boolean).flatMap(c => (c.items || []).map(it => ({ ...it, _src: c.src })))
log(`Sammeln fertig: ${flat.length} Roh-Items aus ${collected.filter(Boolean).length} Lesern`)

phase('Synthese')
const register = await agent(
  `Konsolidiere diese ${flat.length} Roh-Items zu EINEM Register offener/vergessener Arbeit (Markdown). Roh-Items (JSON):\n${JSON.stringify(flat)}\n\n${GO}\n\nAUFGABE: (1) Dedup (gleicher Befund aus mehreren Quellen -> ein Eintrag, Quellen zusammenfuehren; z.B. 9-Dim-G1 == Ketten-A1 = Organ-only-binary_id-Guard). (2) Klassifiziere jeden final mit tag. (3) Sortiere: zuerst LATENTER-BUILD-BRUCH (kritisch), dann VERGESSEN, dann ENTSCHIEDEN-NICHT-GEBAUT, dann GATED, dann OFFENE-ENTSCHEIDUNG, ERLEDIGT zuletzt. Ausgabe-Struktur: (A) Executive Summary (wieviele je tag, welche kritisch). (B) Tabelle | Item | Quelle | tag | naechste Aktion | golden-neutral | severity |. (C) Abschnitt SOFORT golden-neutral umsetzbar (ohne GO): die Quick-Wins mit exaktem datei:zeile-Andockpunkt. (D) Abschnitt BRAUCHT USER-GO/ENTSCHEIDUNG. (E) Abschnitt GATED (warten). Belege alles datei:zeile. Gib NUR das Markdown-Register zurueck.`,
  { label: 'synthese', phase: 'Synthese' }
)

phase('Kritik')
const critique = await agent(
  `Vollstaendigkeits-Kritiker. Hier das konsolidierte Register:\n\n${register}\n\n${GO}\n\nFrage adversarial: Was FEHLT? (a) Nicht-gelesene Quelle/Modalitaet? (b) Ein Ledger-offener-Punkt der im Register fehlt? (c) Ein weiterer latenter Build-Bruch-Typ der nicht geprueft wurde? (d) Ein Widerspruch zwischen zwei Register-Eintraegen? (e) Ein als ERLEDIGT gefuehrter Punkt der es nicht ist? Gib eine KURZE Liste (max 10) konkreter Luecken mit naechster Aktion, oder Register vollstaendig mit Begruendung. Belege datei:zeile wo moeglich.`,
  { label: 'kritik', phase: 'Kritik' }
)

return { register, critique, roh_items: flat.length }
