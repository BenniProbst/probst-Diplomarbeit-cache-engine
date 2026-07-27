export const meta = {
  name: 'achsen-nachschlagewerk',
  description: 'Alle Haupt-/Unter-Achsen (System + Mess + Organ + Gattung + Build/Compile) über Ledger/Architektur/Code kartieren → Tabellen-Nachschlagewerk-Dossier',
  phases: [
    { title: 'Kartieren', detail: '5 parallele Achsen-Sammler' },
    { title: 'Nachschlagewerk', detail: 'Tabellen-Dossier-Synthese' },
  ],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const AXIS_SCHEMA = {
  type: 'object', additionalProperties: false,
  properties: {
    achsen: {
      type: 'array',
      description: 'Alle gefundenen Achsen dieser Dimension',
      items: {
        type: 'object', additionalProperties: false,
        properties: {
          name: { type: 'string' },
          ebene: { type: 'string', description: 'System | Organ | Gattung | Build/Shape | Compile | Mess-Dimension | Mess-Kategorie' },
          typ: { type: 'string', description: 'Haupt-Achse | Unter-Achse | Sub-Achse' },
          parent: { type: 'string', description: 'übergeordnete Achse (leer bei Haupt-Achse)' },
          auspraegungen: { type: 'string', description: 'Werte/Varianten + Anzahl (z.B. "4: k_ary/interpolation/eytzinger/linear_scan")' },
          quelle: { type: 'string', description: 'datei:zeile oder Ledger-§' },
          status: { type: 'string', description: 'gebaut | geplant | gated | TABU | deprecated | Legacy' },
          abhaengigkeiten: { type: 'string', description: 'wovon hängt sie ab / was pinnt/permutiert sie / golden-Faktor / binary_id-relevant?' },
        },
        required: ['name','ebene','typ','auspraegungen','quelle','status'],
      },
    },
    querschnitt_notizen: { type: 'array', items: { type: 'string' }, description: 'Übergreifende Abhängigkeiten/Konflikte/Zähl-Fallen dieser Dimension' },
  },
  required: ['achsen','querschnitt_notizen'],
}
const COMMON = `Du bist Achsen-Kartierer für ein NACHSCHLAGEWERK über ALLE Achsen des Diplomarbeit-Systems (System-Achsen + Mess-Achsen + Organ-Achsen + Gattungs-Achsen + Build/Compile-Achsen). Ziel: vollständige, belegte Erfassung — Haupt-Achsen UND Unter-/Sub-Achsen, mit Ausprägungen, Quelle (datei:zeile oder Ledger-§), Status und Abhängigkeiten. NIEMALS raten — nur Belegtes. Der aktuelle Stand: Bau-INC-2c gerade abgeschlossen (Organ-Achsen 19→18, telemetry ist jetzt System-Achse). Nutze Read/Grep/Bash im ce (${CE}) + super (${SUPER}) + ${LEDGER}.`
phase('Kartieren')
const dims = [
  { key: 'system-achsen', prompt: `Die 6+ CEB-SYSTEM-ACHSEN (compile-time-Schicht ÜBER den Organ-Achsen) + ihre Unterachsen. Quellen: Ledger §18/§19/§20 (die 6 System-Achsen: Scheduling #37 · Hardware/ISA · Telemetrie · Last/Last-Frameworks · Compiler gcc|clang · Erweiterungshardware SIMD/GPU) + INC-1-Bauplan (docs/sessions/backups/20260717-inc1-bauplan/) + die system_axis-Header (libs/cache_engine/include/cache_engine/measurement/*system_axis*.hpp, ceb_system_axis.hpp, hardware_isa_system_axis.hpp, compiler_system_axis.hpp, extension_hardware_system_axis.hpp, scheduling_system_axis.hpp, load_framework_system_axis.hpp, telemetry). Für JEDE: Haupt-Achse + alle Unterachsen (z.B. Compiler ⊃ opt-level/flags/commands [geplant, INC-2c.opt]; Hardware/ISA ⊃ Host-Deskriptor-Felder; Erweiterungshardware ⊃ no_extension/avx2/avx512). Ausprägungen, Quelle, Status (gebaut/geplant/gated), binary_id-Relevanz (System-Achsen NIE in binary_id → H-10-Sidecar).` },
  { key: 'organ-achsen', prompt: `Die ORGAN-ACHSEN (SearchAlgorithm-Komposition, T0..T17 nach INC-2c) + ihre SUB-ACHSEN (~279). Quellen: libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp (kCompositionAxisNames, 18 Namen) + registry_to_axis_levels.hpp (axes26::T00..T25) + anatomy/composition_factory.hpp (AdHocComposition T0..T17) + kV3AxisSchema (observable_tier.hpp, Observer-Felder je Achse) + die axes/*/ + topics/*/ Verzeichnisse (die realen Achsen-Strategien je Organ). Für JEDE der 18 Organ-Achsen: Name, T-Index, Ausprägungen/Strategien (Anzahl + Beispiele), Sub-Achsen falls vorhanden (z.B. queuing q1/q2, hardware isa/09b/12), Observer-Felder, golden-Faktor (welche 4 gehen in golden-320: search_algo×4·node_type×4·memory_layout×5·prefetch×4). Belege mit datei:zeile.` },
  { key: 'gattungs-achsen', prompt: `Die GATTUNGS-ACHSEN-SÄTZE der 5 Tier-Unterklassen + die BUILD/SHAPE-ACHSEN. Quellen: libs/cache_engine/builder/experiment_tree/genus_binding_traits.hpp (SearchAlgorithm 18 / Set 14 / Sequence 10 / View 6 / Adapter 12 — je axis_names()) + anatomy/{set,sequence,view}_composition.hpp + adapter_anatomy.hpp + registry_to_axis_levels.hpp build-only-Achsen (page_type T17, simd_extension T18, general_hardware T19, btree_order/skip_list_shape/bst_shape/hash_probe_shape T22-T25). Für JEDE Gattung: der Achsen-Satz (welche der Organ-Achsen sie trägt/weglässt) + gattungs-eigene Achsen (Set: kein mapping/value_handle; Sequence: growth_policy; View: extent/layout/accessor; Adapter: inner_container). Für die Build/Shape-Achsen: Ausprägungen + dass sie NICHT in kCompositionAxisNames stehen (Codegen-Varianten derselben binary_id-Struktur). datei:zeile.` },
  { key: 'mess-achsen', prompt: `Die MESS-ACHSEN + MESS-DIMENSIONEN + MESS-KATEGORIEN. Quellen: Ledger (Mess-Architektur: 3 Mess-Dimensionen Lebewesen-Wall-Clock / Per-Achsen-Observer / Achsen-Vergleich-gegen-std::map; 2 Pfade A/B; 3 Profile BUILD⊥LASTPROFIL⊥COMPILE-RELEASE) + measurement_category.hpp (kAllMeasurementCategories, 16) + measurement_snapshot.hpp (ComdareMeasurementSnapshotV1 Spalten) + observable_tier.hpp (kV3AxisSchema Observer-Felder) + die Last/Workload-Achse (YcsbWorkload A-F, Datasets, thread_count/prefetch_distance/repetition DynamicDims). Für JEDE Mess-Achse/Dimension/Kategorie: Name, was sie misst, Ausprägungen, ob compile-time (BUILD) oder runtime (LASTPROFIL/E1-DynamicDim), Quelle, Status. Auch die Mess-Kategorie-Granularität (Micro/Makro/Gesamt). datei:zeile.` },
  { key: 'registry-xml-compile', prompt: `Die XML-/REGISTRY-DEFINIERTEN ACHSEN + COMPILE-ACHSEN. Quellen: libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml (die 18 generierten Kompositions-Achsen) + permutation_axes.xml (Legacy-11-Achsen, TABU-read-only) + axis_library_registry.hpp (Achsen 15.1 Compiler-Family / 15.2 Optimization O0-Ofast / 15.3 LTO / 15.4 PGO / 15.5 Target-Arch -march — die COMPILE-Achsen, heute nur Registry-DATEN) + die thesis_profiles/*.profile.xml (permute_axes/axis_sweep-Deklarationen) + das messreihe_v32/experiment-XML-Schema (wie Achsen+Unterachsen als XML modelliert werden). Für JEDE: Achse, Ausprägungen, ob verdrahtet oder nur Deskriptor-Vokabular, Status (aktiv/Legacy/TABU/geplant). Zeige, wie die Compiler-Achse (15.1) mit ihren Unterachsen (15.2 opt / 15.5 march) als XML-Achse-mit-Unterachsen modelliert IST/würde. datei:zeile.` },
]
const results = await parallel(dims.map(d => () =>
  agent(`${COMMON}\n\nDIMENSION: ${d.prompt}`, { label: d.key, phase: 'Kartieren', schema: AXIS_SCHEMA })
))
phase('Nachschlagewerk')
const valid = results.filter(Boolean)
const total = valid.reduce((n, r) => n + (r.achsen ? r.achsen.length : 0), 0)
log(`${valid.length}/5 Kartierer, ${total} Achsen-Einträge gesammelt`)
const dossier = await agent(`Du bist der Nachschlagewerk-Redakteur. Hier die 5 Achsen-Kartierungen (System / Organ / Gattung / Mess / Registry-XML-Compile) mit insgesamt ${total} Achsen-Einträgen:\n\n${JSON.stringify(valid, null, 1)}\n\nErzeuge EIN umfassendes ACHSEN-NACHSCHLAGEWERK (Markdown-Dossier, so lang wie nötig für Vollständigkeit). Struktur:\n(0) Kopf: Zweck (Übersichts-Nachschlagewerk, Stand nach INC-2c), Lesehinweis, Gesamt-Zählung je Ebene.\n(1) SYSTEM-ACHSEN-Tabelle: | Haupt-Achse | Unter-Achsen | Ausprägungen | Status | binary_id? (immer NEIN → H-10-Sidecar) | Quelle |\n(2) ORGAN-ACHSEN-Tabelle (T0..T17): | T-Index | Achse | Ausprägungen (Anzahl) | Sub-Achsen | Observer-Felder | golden-Faktor | Quelle |\n(3) GATTUNGS-ACHSEN-Matrix: | Gattung | slot_count | Achsen-Satz (welche Organ-Achsen) | eigene Achsen | Quelle | — plus die BUILD/SHAPE-Achsen-Tabelle.\n(4) MESS-ACHSEN-Tabelle: | Achse/Dimension/Kategorie | misst was | Ausprägungen | compile-time/runtime | Quelle |\n(5) COMPILE-/REGISTRY-XML-Achsen-Tabelle: | Achse | Ausprägungen | verdrahtet? | Status | Quelle | (inkl. Compiler-Achse ⊃ opt/flags/march-Unterachsen, INC-2c.opt-geplant).\n(6) ABHÄNGIGKEITS-ÜBERSICHT: welche Achse pinnt/permutiert welche; die golden-320-Faktoren (4·4·5·4); System-Achsen ⊥ Organ-Achsen; welche in binary_id vs. H-10-Sidecar; gated/TABU-Achsen.\n(7) ZÄHL-FALLEN + Konflikte: die verschiedenen Achsen-Zählungen (18 Organ / 6 System / axes26 / 15.x Registry / Legacy-11) sauber gegeneinander abgegrenzt, damit man sie nicht verwechselt.\nJede Zeile mit Quelle. Vollständig + präzise — das ist ein Nachschlagewerk gegen Überblicksverlust.`, { label: 'nachschlagewerk', phase: 'Nachschlagewerk' })
return { dossier, kartierer_ok: valid.length, achsen_gesamt: total }