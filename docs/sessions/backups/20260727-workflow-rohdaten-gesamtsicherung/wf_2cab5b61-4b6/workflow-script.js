export const meta = {
  name: 'archiv-workflow-kontext-kapseln',
  description: 'Die 12 relevantesten archivierten Workflows lesen und je eine Kontext-Kapsel fuer die 3 laufenden Planungs-Workflows erzeugen (Registry/Resolver, Planer-Bau, Roadmap, Parallelisierung, Golden-Mock, CI-Kette)',
  phases: [
    { title: 'Lesen', detail: '12 Archiv-Leser parallel' },
    { title: 'Synthese', detail: 'Kapsel-Dokument + Konflikt-Check' },
  ],
}

const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const BK = SUP + '/docs/sessions/backups'
const OUT = SUP + '/docs/plaene/20260719-archiv-workflow-kontext-KAPSELN.md'

const HEUTE = 'HEUTIGER KONTEXT (die Kapseln muessen HIERAUF einzahlen): 3 Planungs-Workflows laufen — (a) Gesamt-Roadmap (Ledger-Diff, XML-Featurespace, Parallelisierungs-Wellen, New-Golden-Voll-XML-Mock 2^17, CI-Detail-Kette start->gruen), (b) §27-Resolver-Stufe (Registry=ANGEBOT als XML-Bibliothek / Anwender-XML=ANZEIGE .pom-artig / Planer=Resolver-Linker), (c) Achsen-Nachschlagewerk-INC2D-Delta (172 Eintraege auf 17-Slot/ABI-6). NEU §28: JEDE der 3 Achsen-ARTEN (Organ/System/Mess) braucht ihre EIGENE Registry in IHREM Modul per XML (Angebot des Compiles); Haupt-Achse=statisch im Ziel-Binary, traegt optionale Unter-Achsen-Einstellungen=meist dynamisch im Ziel-Binary. Planer-Bauplan existiert (docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md) mit Phase-0-Blocker (super v32_messreihe_antrieb execute_messreihe-Stub wiederverwenden, keine Parallelstruktur). Stand: 17 Organ-Achsen/ABI-6, golden-N=2^17-Fixture da, #50/#51/#52 done, Deadline 28.07.'

const KAPSEL_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    ordner: { type: 'string' },
    was_es_ist: { type: 'string', description: '1-2 Saetze: was dieser Workflow damals produzierte' },
    kern_erkenntnisse: { type: 'array', items: { type: 'string' }, description: 'die 3-8 heute noch wertvollen Erkenntnisse/Entscheidungen/Designs, je mit Quelle datei(:zeile)' },
    superseded: { type: 'array', items: { type: 'string' }, description: 'was davon inzwischen ueberholt ist + wodurch' },
    speist_in: { type: 'array', items: { type: 'string', enum: ['resolver-registry','planer-bau','roadmap','parallelisierung','golden-mock','ci-kette','nachschlagewerk-delta'] } },
    registry_direktive_relevanz: { type: 'string', description: 'Bezug zur §28-Direktive (3 Achsen-Art-Registries je Modul; Haupt-statisch/Unter-dynamisch) — oder leer' },
  },
  required: ['ordner','was_es_ist','kern_erkenntnisse','speist_in'],
}

const KANDIDATEN = [
  { d: '20260713-design-zwei-registry-experiment-strategy', hint: 'Das Zwei-Registry+Experiment-XML-Design (Ursprung von feedback_unified_experiment_xml_plus_system_registry_xml) — direkteste Vorarbeit zur §27/§28-Resolver-Stufe. Wie verhaelt es sich zur NEUEN 3-Registries-je-Achsen-Art-Direktive?' },
  { d: '20260710-axis-binding-registry-VERWORFEN', hint: 'VERWORFENES axis_binding_registry-Design (.hpp.verworfen liegt bei) — WARUM verworfen? Die Anti-Lehre fuer das Resolver-Design (was NICHT bauen).' },
  { d: '20260713-verify-registry-facts', hint: 'Registry-Fakten-Verifikation — welche Registry-Wahrheiten wurden festgestellt (Single-Source-Frage Code vs XML).' },
  { d: '20260713-audit-3-schema-familien', hint: 'Die 3 XML-Schema-Familien — Schema-Landschaft fuer Resolver + Mock.' },
  { d: '20260716-experiment-planer-codegen-design', hint: 'DAS Planer-Codegen-Design-Dossier (Director/2 ConcreteBuilder/Template-Method) — Primaerquelle des Bauplans; Details die der Bauplan evtl. nicht uebernahm.' },
  { d: '20260716-gesamtkonzept-experiment-ausfuehrung', hint: 'Gesamtkonzept der Experiment-Ausfuehrung — Ende-zu-Ende-Vision fuer die CI-Kette.' },
  { d: '20260716-wp1-parallel-engine-gestoppt-fork-a', hint: 'Die v32-Parallel-Engine-Stopp-Entscheidung + Fork-A — der historische Grund des Phase-0-Blockers; was genau gestoppt wurde und was die Bruecke ist.' },
  { d: '20260710-achsen-unterachsen-utilization', hint: 'Das Layer-Modell (statische Achse=Layer, darunter dynamische Nodes; Unter-Achse=Voll-Achse unter CT-Haupt-Achse) — die Vorlage der heutigen §28-Haupt/Unter-Semantik. Utilization-Luecken-Liste.' },
  { d: '20260711-e4prime-messkurven-typsystem-wurzel', hint: 'Heuristik-Messkurven-Typsystem + CoR (architektur/20) — was die Mess-Registry (§28) anbieten muss, damit Heuristik-Kurven entstehen.' },
  { d: '20260716-f4-systemachsen-dossier', hint: 'System-Achsen-SOLL-Dossier (A-systemachsen-soll.md, D-compiler-achse.md) — Grundlage der System-Registry (§28).' },
  { d: '20260717-parallelisierungs-strategie', hint: 'Die damalige Parallelisierungs-Strategie — Vorlage/Abgleich fuer die heutige Disjunktheits-Analyse.' },
  { d: '20260717-xml-ci-automatisierung', hint: 'XML->CI-Automatisierung (F5-Folgearbeit, im Bauplan zitiert xml-ci-automatisierung:210) — CiYamlBuilder-Vorarbeit fuer die CI-Kette.' },
]

phase('Lesen')
const kapseln = await parallel(KANDIDATEN.map(k => () => agent(
  `ARCHIV-KAPSEL erzeugen fuer ${BK}/${k.d}. Hinweis zur Erwartung: ${k.hint}\n\nVorgehen: ls des Ordners; lies ZUERST die Synthese-/Dossier-/README-/BEFUND-Dateien (md), Rohdaten (json/jsonl) nur gezielt wenn die Synthese fehlt oder Luecken hat (dann aus dem journal/RESULT die Essenz ziehen). Extrahiere die HEUTE noch wertvollen Erkenntnisse (Designs, Entscheidungen, verworfene Wege mit Begruendung, Zahlen/Fakten) und markiere ehrlich, was inzwischen superseded ist. ${HEUTE} Gib die Kapsel strukturiert zurueck.`,
  { label: 'kapsel:' + k.d.replace(/^2026\d{4}-/, ''), phase: 'Lesen', schema: KAPSEL_SCHEMA }
).catch(() => null)))
const valid = kapseln.filter(Boolean)
log(`Kapseln: ${valid.length}/12`)

phase('Synthese')
const synthese = await agent(
  `KAPSEL-SYNTHESE. ${valid.length} Archiv-Kapseln (JSON):\n${JSON.stringify(valid)}\n\n${HEUTE}\n\nSCHREIBE mit Write nach ${OUT}: (A) Kopf (Zweck: Kontext-Kapseln der relevantesten Archiv-Workflows fuer die laufenden Planungen; Auswahl 12 aus ~95); (B) je Kapsel ein Abschnitt (was_es_ist, Kern-Erkenntnisse mit Quellen, superseded-Liste, speist_in, §28-Registry-Relevanz); (C) QUER-SYNTHESE: (1) die 5 wichtigsten Erkenntnisse fuer die §27/§28-Resolver-Stufe (insb. Zwei-Registry-Design vs NEUE 3-Achsen-Art-Registries: was uebernehmen, was erweitern; die axis_binding_registry-Anti-Lehre), (2) die 3 wichtigsten fuer den Planer-Bau (Codegen-Design-Details, v32-Stopp-Lehre, Fork-A-Bruecke), (3) fuer Parallelisierung (alte Strategie vs heutige Wellen), (4) fuer Mock/CI-Kette; (D) KONFLIKTE: wo Archiv-Aussagen den heutigen Planungen widersprechen (je: gewinnender neuester Fakt). Return: kompakte Zusammenfassung + die Quer-Synthese-Punkte (1).`,
  { label: 'synthese', phase: 'Synthese' }
)

return { synthese, kapseln_n: valid.length, dokument: OUT }
