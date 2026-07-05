export const meta = {
  name: 'arch-verify-w1-w5',
  description: 'Ultracode-Verifikation der dokumentierten Architektur (B+-Baum, L/isa-Autoritativ, DEG/m3v2, PRT-ART, 4-Schichten-XML) fuer korrigierte TODO-Definitionen',
  phases: [
    { title: 'Read', detail: '5 parallele Architektur-Reader W1-W5' },
    { title: 'Synthese', detail: 'korrigierte TODO-Definitionen' },
  ],
}

const CE = 'C:/Users/benja/OneDrive/Desktop/Diplomarbeit - Datenbanken/Code/external/comdare-cache-engine'
const SU = 'C:/Users/benja/OneDrive/Desktop/Diplomarbeit - Datenbanken'

const BEFUND = {
  type: 'object',
  required: ['befund', 'belege', 'todo_konsequenzen', 'offen'],
  properties: {
    befund: { type: 'string', description: 'Kernbefund in 10-20 Saetzen, deutsch' },
    belege: { type: 'array', items: { type: 'string' }, description: 'datei:zeile-Belege' },
    todo_konsequenzen: { type: 'string', description: 'Was heisst das konkret fuer die betroffenen TODOs (Definition korrigieren/bestaetigen)' },
    offen: { type: 'array', items: { type: 'string' }, description: 'Was NICHT belegbar war - ehrlich, nicht raten' },
  },
}

const COMMON = 'Du bist READ-ONLY Architektur-Pruefer im Repo ' + CE + ' (kanonischer Baum libs/cache_engine/, den modules/-Mirror IGNORIEREN - er ist drift-veraltet). Super-Repo-Doku: ' + SU + '/docs (architecture/, sessions/, ENTWICKLER-*.md). Thesis read-only: ' + SU + '/thesis/diplomarbeit. Antworte DEUTSCH, jeder Claim mit datei:zeile. NICHTS raten - Unbelegbares unter offen listen. Kontext: User-Entscheide vom 05.07. verlangen, dass diese dokumentierten Dinge NACHGELESEN werden, bevor TODO-Definitionen korrigiert werden. '

phase('Read')
const readers = [
  { key: 'W1-bplus-baum', prompt: COMMON + 'W1 (User-Antwort C1: "Wir haben einen B+-Experiment-Baum mit compile time und runtime Permutations-Features. Lies das nach."): Kartiere den B+-Experiment-Baum: builder/experiment_tree/ (PermutationLoop als B+-Baum, KF-9; AxisLevels; DynamicDim; cache_engine_builder_iterator.hpp Lazy-Iteratoren; genus_binding_traits). FRAGE: Wie ist der architektonisch vorgesehene Weg, per-Familie-Varianten (Node-Shape, Allokator A, Layout L) zu permutieren - als compile-time-Dimension im Baum (statische Ebenen) vs. runtime-DynamicDim? Wo docken NEUE Achsen-Auspraegungen an (registry-getrieben BR-1?), und was heisst das fuer die S7-Serie (#234/#261: Pool-Store-Parametrisierung der 9 Familien) - muss der organ_for-Trait ueberhaupt erweitert werden oder laeuft Varianten-Permutation ueber den Baum?' },
  { key: 'W2-layout-isa-autoritativ', prompt: COMMON + 'W2 (User-Antworten C2 "Alles dokumentiert" + D2 "die Achse existiert schon; wenn memory benoetigt wird, verwenden andere Achsen autoritativ diese Achse um das memory layout zu setzen"): Kartiere (a) die memory_layout-Achse + LayoutAwareChunkedStore (5 reale Layouts #167) und ihre dokumentierte Semantik fuer NODE-POOLS (S7-2..9: gilt L fuer TreeNodePoolStore-artige Stores? Wo dokumentiert - docs/architecture, Achsen-Header-Kommentare?); (b) das Muster "Achse konsumiert Achse AUTORITATIV" (Cross-Achsen-Delegation #182 "verteilte Interfaces", ch4 3.3?): wo implementiert/dokumentiert, mit Beispiel; (c) die isa-Achse (axis_09, T12) als autoritative Quelle: wie muesste die SwissTable-SIMD-Gruppen-Probe (7b-3) sie konsumieren statt eines organ-lokalen Arch-Guards? Belege.' },
  { key: 'W3-deg-m3v2', prompt: COMMON + 'W3 (User-Antworten C3 "DEG-Nachweis bereits umgesetzt" + D3 "m3v2 wurde schon gebaut, suche und pruefe es"): (a) SUCHE m3v2: Grep nach m3v2/m3_v2 in Profilen (XML), Skripten (ps1), docs, iterator/BuildVersion-Strings, build/thesis_tiere-Strukturen; was IST m3v2 (Profil? Engine-Stand? Mess-Lauf?), was deckt es ab (Sweeps/Reihen/Achsen), wurde es GEBAUT (Artefakte?) und ggf. gemessen? (b) DEG-Nachweis-Mechanik: wie ist der Beweis DEG>0 heute umgesetzt (DEG-1 for_each_record-Ernte test_188_4bbV:158-176, seg_ns-Attribution #161, T6-Route S7-1, quality_flag) - reicht die bestehende Mechanik fuer die S7-Serie als Nachweis-Muster (User: "bereits umgesetzt")? Belege.' },
  { key: 'W4-prtart-abstrakt', prompt: COMMON + 'W4 (User-Antwort B1, KORREKTUR: "PRT-ART ist abstrakt, hat nicht alle Achsen vollstaendig, wird per cache engine per Metaprogrammierung zur compile time als library geladen, um nach den 3 Hauptmessmethoden geprueft zu werden"): Kartiere die PRT-ART-Einbindung: sota_catalog (Stufe/Reihe-Mapping #178), prt-art als Pruefling (R8 #721: wie eingebunden - compile-time-Library? optional_prt_art_impl-Slots #31? AbstractFactory-Pruefling-Slot V41.E11?), der "90ns-Stub" + "unordered_map-Surrogat" (AP-2/TODO E6 - WO genau, Zeilen), und die 3 HAUPTMESSMETHODEN (Messreihen A/B/C? drei Mess-Modi? SelectMode?). FRAGE: Wie muss AP-2 (#236) korrekt definiert werden, damit es zur abstrakten compile-time-Architektur passt (statt "echter Adapter statt Surrogat")?' },
  { key: 'W5-schichten-xml-datensaetze', prompt: COMMON + 'W5 (User-Antwort D1: AP-10-Datensaetze sind "in den 4 Schichten der Diplomarbeit geplant und werden durch xml Profile umgesetzt"): Kartiere (a) die 4 SCHICHTEN der Diplomarbeit (Thesis-Gliederung? Architektur-Schichten in docs/architecture? 4-Schichten-Modell im Master-Architektur-Dokument MP-B?); (b) die XML-Profil-Landschaft: profiles/*.xml (thesis_profile-Schema KF-2, Lastprofile LP01-14 #245, SOTA 33/33 + Allokator 23/23 #240) - WO sind DATENSAETZE (datasets) als XML geplant/registriert (dataset-Loader AP-CE2? Akten-Schema checksum/line_count/preprocessing AP-10 #244)? (c) Ist-Stand AP-10: was existiert schon (8/8 Akten? String-Loader?), was fehlt laut Code wirklich? FRAGE: korrigierte #269/#244-Definition ohne User-Liste (Datensaetze kommen aus den XML-Profilen der 4 Schichten).' },
]
const befunde = await parallel(readers.map(r => () =>
  agent(r.prompt, { label: r.key, phase: 'Read', schema: BEFUND })
))

phase('Synthese')
const material = readers.map((r, i) => '### ' + r.key + '\n' + JSON.stringify(befunde[i] || { befund: 'AGENT AUSGEFALLEN', belege: [], todo_konsequenzen: '', offen: ['Lauf fehlgeschlagen'] })).join('\n\n')
const synth = await agent(
  'Du bist Synthese-Redakteur. Aus den 5 Architektur-Befunden W1-W5 (unten, JSON) forme einen LEDGER-ABSCHNITT (Markdown, deutsch, kompakt aber vollstaendig) mit: (1) je W-Punkt 3-6 Saetze Kernbefund MIT den wichtigsten datei:zeile-Belegen inline; (2) daraus KORRIGIERTE TODO-DEFINITIONEN fuer: AP-2/#236 (PRT-ART), S7-Serie/#234+#261 (Threading via B+-Baum vs organ_for), 7b-3 (isa-autoritativ), AP-10/#244+#269 (XML-Datensaetze), CMD-2/#268-Bezug falls m3v2-relevant - je als praezise umsetzbare Definition; (3) Liste OFFEN (ehrlich aggregiert). KEINE Erfindungen - nur was in den Befunden steht. Beginne direkt mit "### 13.10 ultracode-Architektur-Verifikation W1-W5 (2026-07-05)".\n\n' + material,
  { label: 'synthese', phase: 'Synthese' }
)
return { synth, befunde }