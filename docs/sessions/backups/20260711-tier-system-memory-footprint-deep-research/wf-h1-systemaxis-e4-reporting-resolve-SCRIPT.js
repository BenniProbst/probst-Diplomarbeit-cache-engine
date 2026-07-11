export const meta = {
  name: 'h1-systemaxis-e4-reporting-resolve',
  description: 'Deep-Research H-1: ist SystemAxis->E4-Reporting eine echte buildbare Luecke (bauen) ODER ist der 0-Consumers-Phase-6-Vorbau-Zustand intentional/korrekt (nicht bauen, wie H-2 honest-0)? Redundanz-/Schema-/TABU-Pruefung',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Refute' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const THESIS = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit'
const COMMON = `KONTEXT: Das SystemAxis-"Blut"-Mess-System (system_axis.hpp + measurement_axis_registry.hpp) ist Phase-6-Vorbau (2026-07-10) mit 0 Produktions-Konsumenten (nur Unit-Tests). Die Registry-Doku sagt selbst "Konsumenten (E4-Reporting, Pruef-Dock-Verdrahtung) = Folge-Increment". Die 3 real produzierten Kategorien: CLU (aus axis_stats[5] memory_layout), LATENCY_MEAN + THROUGHPUT (aus WallClock total_ns/op_count). Die E4-Reporting-CSV (measurements.csv, EINE Zeile je Permutation, 05_evaluation.tex:92) entsteht in der Kette result_ingest.hpp / host_measure_loop.hpp / node_value_measurement.hpp. TABU: golden_fullpilot_320, measurements.csv-Schema (thesis-konsumiert!), POD sizeof==1416, ABI-4. Direktive: Anti-Phantom (kein redundanter/falscher Wert), nur benannte Patterns, "erforschen nicht erfinden".`

phase('Research')
const DIM = [
  {
    key: 'redundanz',
    prompt: `${COMMON}\n\nAufgabe: sind die 3 SystemAxis-Kategorien (CLU, LATENCY_MEAN, THROUGHPUT) REDUNDANT mit bereits existierenden measurements.csv-Spalten? Finde den CSV-Header/Spalten-Producer in ${CE} (grep in result_ingest.hpp/host_measure_loop.hpp/node_value_measurement.hpp + wo NodeValue-Felder zu CSV-Spalten werden; grep "stat_", "latency", "throughput", "ns", "clu", "cache_line"). Gibt es schon Wall-Clock-Latenz/Durchsatz-Spalten + eine CLU/cache-line-Auslastungs-Spalte? Wenn die SystemAxis-Werte DIESELBE Groesse aus DERSELBEN Quelle nochmal berechnen → redundant → 0-Consumers ist korrekt. Wenn sie eine NEUE, noch nicht exponierte Groesse liefern → echte Luecke. Belege datei:zeile.`,
  },
  {
    key: 'intention',
    prompt: `${COMMON}\n\nAufgabe: ist der 0-Consumers-Zustand INTENTIONAL (Phase-6-Vorbau bis zu einem bewussten E4-Reporting-Umbau, design-gated) oder eine schlichte noch-nicht-gemachte Verdrahtung? Lies measurement_axis_registry.hpp + system_axis.hpp Kopf-Kommentare + Doku ${CE}/docs/architecture (system-axes / Dossier 19 Querschnitt M) + ggf. Thesis ${THESIS} (03_messsystem/05_evaluation zur Rolle der System-Achsen im Reporting). Soll die SystemAxis-Registry die BESTEHENDE Reporting-Kette ERSETZEN (dann ist Parallel-Verdrahtung jetzt falsch/doppelt) oder additiv ERGAENZEN? Ist die Verdrahtung compile-time-sauber machbar oder braucht sie die #156-Mess-Maschinerie? Belege datei:zeile.`,
  },
  {
    key: 'schema-risiko',
    prompt: `${COMMON}\n\nAufgabe: Schema-/Test-Risiko einer H-1-Verdrahtung. Welche Tests/Fixtures asserten das aktuelle measurements.csv-Spalten-Set / die NodeValue->CSV-Abbildung (grep test_*roundtrip*, golden, csv-header-Asserts, best_binary-Fixtures wie best_binary_wide.csv)? Wuerde ein additives Anhaengen von 3 SystemAxis-Spalten am CSV-Ende (a) den golden-320-binary_id-Roundtrip beruehren (NEIN erwartet — CSV != binary_id) (b) parse-Tests brechen die feste Spaltenzahl erwarten? Ist das Anhaengen sauber additiv am Ende oder mitten im Schema? Belege datei:zeile.`,
  },
]
const research = await parallel(DIM.map(d => () => agent(d.prompt, { label: `res:${d.key}`, phase: 'Research' })))
const researchText = DIM.map((d, i) => `### ${d.key}\n${research[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Design')
const SCHEMA = { type: 'object', additionalProperties: false,
  required: ['verdict', 'is_real_buildable_gap', 'reasoning', 'edits', 'honest_defer_reason'],
  properties: {
    verdict: { type: 'string', enum: ['build-now', 'correctly-gated-do-not-build'] },
    is_real_buildable_gap: { type: 'boolean' },
    reasoning: { type: 'string', description: 'Redundanz? Intention (ersetzen vs. ergaenzen)? Schema-Risiko? #156-gated?' },
    edits: { type: 'array', description: 'NUR falls build-now: exakte additive Edits (SystemAxis-Collect in der Producer-Kette + CSV-Spalten am Ende)', items: { type: 'object', additionalProperties: false, required: ['file', 'anchor', 'change', 'code'], properties: { file: { type: 'string' }, anchor: { type: 'string' }, change: { type: 'string', enum: ['insert', 'replace'] }, code: { type: 'string' } } } },
    honest_defer_reason: { type: 'string', description: 'NUR falls correctly-gated: warum 0-Consumers der korrekte Zustand ist (redundant / design-gated E4-Umbau / #156)' },
  } }
const design = await agent(
  `${COMMON}\n\nEntscheide H-1 DEFINITIV auf Basis der Research: build-now (echte, nicht-redundante, schema-sichere, compile-time-saubere Luecke) ODER correctly-gated-do-not-build (redundant mit bestehenden Spalten / design-gated E4-Reporting-Umbau / #156-Mess-Maschinerie-abhaengig). Anti-Phantom: wenn die SystemAxis-Spalten dieselbe Groesse doppelt liefern ODER die Verdrahtung die bestehende Reporting-Kette praeempt/dupliziert → correctly-gated. Kein Erzwingen einer redundanten Verdrahtung.\n\nRESEARCH:\n${researchText}`,
  { label: 'design', phase: 'Design', schema: SCHEMA })

phase('Refute')
const RS = { type: 'object', additionalProperties: false, required: ['refuted', 'issue'], properties: { refuted: { type: 'boolean' }, issue: { type: 'string' } } }
const lenses = [
  'Redundanz/Anti-Phantom: liefern die SystemAxis-Spalten eine NEUE Groesse oder duplizieren sie bestehende measurements.csv-Spalten (dann waere build-now falsch)?',
  'Schema/golden: bricht ein additives CSV-Spalten-Anhaengen irgendeinen Test / den golden-Roundtrip / eine feste-Spaltenzahl-Erwartung?',
]
const dStr = JSON.stringify(design, null, 1)
const verds = await parallel(lenses.map((lens, i) => () => agent(`Adversariale Pruefung des H-1-Verdikts, LINSE: "${lens}". Default refuted=true bei Zweifel. Lies ${CE} bei Bedarf.\n\nVERDIKT:\n${dStr}`, { label: `refute:${i}`, phase: 'Refute', schema: RS })))
return { design, research: researchText, refutations: verds.filter(Boolean), survives: verds.filter(Boolean).every(v => !v.refuted) }
