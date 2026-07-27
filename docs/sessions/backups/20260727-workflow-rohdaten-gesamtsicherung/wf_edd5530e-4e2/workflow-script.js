export const meta = {
  name: 'axis-ontology-completeness-verify',
  description: 'Ontologische Voll-Verifikation der 19 Kompositions-Achsen: sind ihre Eigenschaften (Werte/Semantik/Optimierungsrichtung) konzeptionell vollständig + korrekt gegen die Diplomarbeit-Mess-Ziele? Lücken surfacen bevor der golden-320-Lauf final ist.',
  phases: [{ title: 'Achsen-Recherche' }, { title: 'Adversariale-Verifikation' }, { title: 'Synthese' }],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'
const THESIS = ROOT + '/thesis/diplomarbeit'

// Die 19 Kompositions-Achsen in 3 Gruppen (Basis / RC-dynamisch / uebrige Organe).
const groups = [
  {
    key: 'basis-4',
    axes: 'search_algo, node_type, memory_layout, prefetch (die 4 im golden-320 variierten Basis-Achsen)',
  },
  {
    key: 'rc-dynamisch',
    axes: 'concurrency (thread_count), prefetch (hw_prefetcher/prefetch_distance), allocator (pool_budget_bytes), cache_traversal (batch_size), value_handle (inline_threshold_bytes) — die RC-/laufzeit-dynamischen Achsen (M0-Deep-Research: 5 RC-steuerbar T7/T6/T8/T1/T11 + Min/Max)',
  },
  {
    key: 'organ-uebrige',
    axes: 'mapping, path_compression, serialization, telemetry, isa, index_organization, io_dispatch, migration_policy, filter, queuing_q1, queuing_q2 (die uebrigen Organ-Achsen)',
  },
]

const AXIS_SCHEMA = {
  type: 'object',
  properties: {
    axes: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          axis: { type: 'string' },
          values_defined: { type: 'string', description: 'die im Registry/ConfigSet definierten Werte (Enum)' },
          semantics_source: { type: 'string', description: 'wo Semantik/Optimierungsrichtung dokumentiert ist (datei:zeile: M0-Backup, thesis .tex, design-doc)' },
          thesis_goal_alignment: { type: 'string', description: 'deckt die Achse ihr Diplomarbeit-Mess-Ziel ab? (was misst sie, warum relevant)' },
          gap: { type: 'string', description: 'LÜCKE: unbenannte/unter-spezifizierte/falsche Eigenschaft, ODER "keine" wenn vollständig' },
          severity: { type: 'string', enum: ['none', 'low', 'medium', 'high'] },
        },
        required: ['axis', 'values_defined', 'gap', 'severity'],
      },
    },
  },
  required: ['axes'],
}

const research = await pipeline(
  groups,
  g => agent(
    `Ontologische Vollständigkeits-Prüfung der Kompositions-Achsen: ${g.axes}.\n\n` +
    `Für JEDE Achse verifiziere gegen (a) den Code (ce ${CE}: EnabledStrategies/topics/*/topic_*_config_set.hpp, axes/*, die Achsen-Werte-Enums), (b) die M0-Deep-Research (${ROOT}/docs/sessions/backups/20260709-axes-optimization-deep-research/ + Ledger :408(c) zu Min/Max-Semantik/honest-0), (c) die DIPLOMARBEIT-ZIELE (thesis ${THESIS}: die .tex-Kapitel zu den Achsen/Design-Space/sec:anatomy, was JEDE Achse messen SOLL), (d) die Design-Docs (ce docs/architecture/ zur Achsen-Anatomie).\n\n` +
    `Frage je Achse: Sind die Eigenschaften (definierte Werte + Semantik + Optimierungsrichtung Min/Max/honest-0) KONZEPTIONELL VOLLSTÄNDIG + KORREKT für ihr Diplomarbeit-Mess-Ziel? Gibt es eine GEFORDERTE-ABER-UNBENANNTE Eigenschaft (Direktive), einen falschen Optimierungssinn, fehlende Werte, oder eine Achse die am Thesis-Ziel vorbei misst? Belege datei:zeile. Sei streng — surface echte Lücken, nicht kosmetische.`,
    { label: g.key, phase: 'Achsen-Recherche', schema: AXIS_SCHEMA },
  ),
)

// Adversariale Verifikation nur der als Lücke (severity != none) gemeldeten Achsen.
const flagged = research.filter(Boolean).flatMap(r => (r.axes || []).filter(a => a.severity && a.severity !== 'none'))
const verified = await parallel(
  flagged.map(f => () =>
    agent(
      `Adversariale Gegenprüfung EINER gemeldeten Achsen-Lücke. Achse: ${f.axis}. Behauptete Lücke: "${f.gap}" (severity ${f.severity}). ` +
      `Versuche die Lücke zu WIDERLEGEN: ist die Eigenschaft doch benannt/definiert (im Code ${CE} oder der M0-Research oder der Thesis ${THESIS})? Ist der behauptete Fehler wirklich einer, oder ein Missverständnis? Default = WIDERLEGT (die Achse ist vollständig), es sei denn die Lücke ist datei:zeile-hart belegbar. Gib: {axis, confirmed: true|false, begruendung, datei:zeile}.`,
      { label: `verify:${f.axis}`, phase: 'Adversariale-Verifikation',
        schema: { type: 'object', properties: { axis: { type: 'string' }, confirmed: { type: 'boolean' }, begruendung: { type: 'string' } }, required: ['axis', 'confirmed', 'begruendung'] } },
    ).then(v => ({ ...f, verdict: v })),
  ),
)

const synth = await agent(
  `Konsolidiere zur ontologischen Achsen-Vollständigkeits-Verifikation der 19 Kompositions-Achsen. Gib: (1) eine Tabelle je Achse: Werte / Optimierungssemantik / Thesis-Ziel-Deckung / Verdikt (vollständig | bestätigte Lücke). (2) Die ADVERSARIAL BESTÄTIGTEN Lücken (confirmed=true) mit severity, datei:zeile, und konkretem Fix-Vorschlag IN DEN GESETZTEN Design-Pattern-Rahmen (kein Neubau). (3) Gesamt-Verdikt: sind die 19 Achsen konzeptionell vollständig für den golden-320-Mess-Lauf, oder muss vor der Daten-Finalisierung eine Achse korrigiert werden? Sei ehrlich — wenn alles vollständig ist, sag das klar (das ist ein valides Ergebnis).\n\n` +
    `RECHERCHE:\n${research.filter(Boolean).map((r, i) => `### ${groups[i].key}\n` + JSON.stringify(r.axes, null, 1)).join('\n\n')}\n\n` +
    `ADVERSARIALE VERDIKTE:\n${verified.filter(Boolean).map(v => `- ${v.axis}: confirmed=${v.verdict?.confirmed} — ${v.verdict?.begruendung}`).join('\n') || '(keine Lücken gemeldet)'}`,
  { label: 'synthese', phase: 'Synthese' },
)

return { verdikt: synth, flagged_count: flagged.length, confirmed: verified.filter(v => v && v.verdict && v.verdict.confirmed).map(v => v.axis) }
