export const meta = {
  name: 'f-simd-schritt2-4-nach-pruefung',
  description: 'NACH-Pruefung F-SIMD Schritt 2-4: 3 adversariale Lenses gegen den gelandeten Zustand (Symmetrie/golden-Neutralitaet/Residual) + Synthese-Verdikt',
  phases: [
    { title: 'Adversarial', detail: '3 Lenses versuchen die Konformitaet zu widerlegen' },
    { title: 'Verdikt', detail: 'Synthese: bestaetigte Defekte oder COMMIT_OK' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

phase('Adversarial')

const FIND_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['defects', 'lens_verdict'],
  properties: {
    defects: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['severity', 'file_line', 'claim', 'evidence'],
        properties: {
          severity: { type: 'string', enum: ['KRITISCH', 'MITTEL', 'GERING', 'HINWEIS'] },
          file_line: { type: 'string' },
          claim: { type: 'string', description: 'Der konkrete Konformitaets-/Korrektheits-Verstoss' },
          evidence: { type: 'string', description: 'datei:zeile-Beleg, warum es ein echter Defekt ist (nicht Vermutung)' },
        },
      },
    },
    lens_verdict: { type: 'string', description: 'Fazit dieser Lens: KONFORM oder DEFEKT(e) gefunden + 1 Satz' },
  },
}

const lenses = [
  {
    label: 'symmetrie',
    prompt: `Adversariale NACH-Pruefung (Lens 1: SYMMETRIE-VOLLSTAENDIGKEIT). Der Commit ce d45afa6d + super 252b788 hat F-SIMD Schritt 2-4 umgesetzt: extension_hardware (Haupt) -> simd (Unter-Achse) -> Optionen {no_extension,avx2,avx512}, spiegelbildlich zu compiler -> opt_level -> option.
DEIN AUFTRAG: VERSUCHE ZU WIDERLEGEN, dass die Symmetrie in ALLEN vier Schichten strikt und vollstaendig ist. Lies und vergleiche PAARWEISE gegen das opt_level-Vorbild:
(1) XSD ${SUPER}/Code/test_data_xml/experiment_schema.xsd -- ist der neue <simd>-complexType STRUKTURELL identisch zu <opt_level> (minOccurs, verschachtelte sequence, option-Enum)? Fehlt eine Ebene? Ist ein Enum-Wert (avx512) im XSD zulassbar aber nirgends sonst?
(2) Parser ${CE}/libs/common/serialization/xml_config_parser/xml_config_parser.cpp (~424-432) -- liest extension_hardware GENAU wie opt_level (child-Container dann children_named option)? Gibt es einen Pfad, wo ein altes flaches <extension_hardware><option> (ohne <simd>) still ignoriert statt gemeldet wird (Silent-Drop)?
(3) Typisierte Achse ${CE}/libs/cache_engine/include/cache_engine/measurement/simd_sub_axis.hpp vs optimization_level_sub_axis.hpp -- Methoden-Parallelitaet (parent_axis_label/axis_label/id/flags/Concept/static_asserts) vollstaendig?
(4) golden ${CE}/tests/unit/thesis_tiere/experiment_golden.xml + ${SUPER}/Code/test_data_xml/experiment_golden.xml -- Anatomie extension_hardware/simd/option == compiler/opt_level/option?
Melde JEDEN echten Struktur-Bruch mit datei:zeile. Wenn strikt symmetrisch: KONFORM.`,
  },
  {
    label: 'golden-neutral',
    prompt: `Adversariale NACH-Pruefung (Lens 2: golden==320 + binary_id-NEUTRALITAET). Behauptung des Commits: der <simd>-Umbau ist reine Provenienz-Struktur, golden binary_count bleibt 320, simd geht NIE in binary_id ein (system_config, nicht in kCompositionAxisNames).
DEIN AUFTRAG: VERSUCHE ZU WIDERLEGEN. Pruefe:
(1) Steht 'simd' oder 'extension_hardware' irgendwo in kCompositionAxisNames / der Komposition-Achsen-Liste? Grep ${CE}/libs fuer kCompositionAxisNames-Definition und pruefe.
(2) Geht simd_id in eine binary_id / view_binary_id / einen Hash ein? Suche in experiment_run_entry.hpp den +ext=-Suffix -- landet er in build_version (OK) oder in binary_id (DEFEKT)?
(3) Die golden hat opt O2/O3 x simd no_extension/avx2 = 4 System-Achsen-Perms ueber DIESELBEN 320 Binaries. Fuehrt der Umbau eine NEUE Auspraegung (avx512) in die golden-Instanzen ein (waere DEFEKT: veraendert Perm-Zahl/Provenienz)? Pruefe beide golden.
(4) Sind die -march-Flag-Werte der neuen SimdSubAxis-Optionen byte-deckungsgleich zur alten Familie (no_extension='' / avx2=-mavx2 / avx512=-mavx512f)? Ein Drift waere ein Provenienz-/Codegen-Defekt.
Melde JEDEN Leak/Drift mit datei:zeile. Sonst KONFORM.`,
  },
  {
    label: 'residual',
    prompt: `Adversariale NACH-Pruefung (Lens 3: RESIDUAL-REFERENZEN + DEPRECATION-POSTUR + LATENTE LUECKEN). Der Commit migriert alle Consumer der alten Familie (Generic/Avx2/Avx512ExtensionHardwareAxis) auf SimdSubAxis-Optionen und markiert ${CE}/libs/cache_engine/include/cache_engine/measurement/extension_hardware_system_axis.hpp als DEPRECATED (nicht geloescht).
DEIN AUFTRAG: VERSUCHE ZU WIDERLEGEN, dass die Migration vollstaendig + sauber ist. Pruefe:
(1) Grep das GESAMTE ${CE}/libs + ${CE}/tests nach 'ExtensionHardwareSystemAxis|GenericExtensionHardwareAxis|Avx2ExtensionHardwareAxis|Avx512ExtensionHardwareAxis|simd_extension_id' -- gibt es AKTIVE (nicht-deprecatete, nicht-Block-F) Consumer, die uebersehen wurden?
(2) Ist der DEPRECATED-Banner ehrlich? Behauptet er 'keine aktiven Consumer', obwohl noch welche existieren? Ist test_striktheit_axis_dach_guard Block F (das die alte flache Familie als gueltige CebSystemAxis assertet) ein Konformitaets-Problem (segnet es das asymmetrische Modell), oder legitimer Kontrast-Test einer deprecateten-aber-kompilierbaren Familie?
(3) Latente Single-Source-Luecke: ist validate_profile.hpp kValidSimd (hartkodiert no_extension/avx2/avx512) NICHT aus SimdSubAxis::simd_id() gespeist -> Drift-Risiko? Ist das ein NEUER Defekt dieses Commits oder Bestandszustand?
(4) Gibt es andere XML (config_a/b/c, m3v2_study, messreihen) mit <extension_hardware>, die durch die XSD-Aenderung jetzt schema-invalide waeren?
Melde JEDEN echten Rest/Unehrlichkeit mit datei:zeile. Unterscheide NEUER-Defekt-dieses-Commits von Bestand (geflaggt).`,
  },
]

const findings = await parallel(lenses.map(l => () => agent(l.prompt, { label: l.label, phase: 'Adversarial', schema: FIND_SCHEMA, effort: 'high' })))

phase('Verdikt')

const VERDICT_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['confirmed_defects', 'dismissed', 'overall_verdict', 'action'],
  properties: {
    confirmed_defects: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['severity', 'file_line', 'defect', 'fix'],
        properties: {
          severity: { type: 'string', enum: ['KRITISCH', 'MITTEL', 'GERING'] },
          file_line: { type: 'string' },
          defect: { type: 'string' },
          fix: { type: 'string', description: 'konkreter Fix' },
        },
      },
    },
    dismissed: { type: 'array', items: { type: 'string' }, description: 'Als unbegruendet/Bestand verworfene Befunde + Grund' },
    overall_verdict: { type: 'string', enum: ['COMMIT_OK', 'NACHBESSERN'], },
    action: { type: 'string', description: 'Was zu tun ist (COMMIT_OK -> nichts; NACHBESSERN -> die Fix-Liste)' },
  },
}

const verdict = await agent(
  `Du bist der Konformitaets-Richter der NACH-Pruefung F-SIMD Schritt 2-4. Drei adversariale Lenses haben versucht, die Konformitaet zu widerlegen. Bewerte JEDEN Befund: ist er ein ECHTER Defekt DIESES Commits (dann confirmed_defect + Fix), ein Bestandszustand ausserhalb des Scope (dann dismissed mit Grund), oder unbegruendet (dismissed)?

Kontext-Fakten (bereits verifiziert): ce-standalone ctest 275/275, super-Sub-Build(clang) 5/5 inkl. test_fixture_sync_experiment_golden, golden==320, cf22 CLEAN, Mojibake 0, golden byte-Sync OK. Direktiven: Doku-nie-loeschen (Deprecate statt Delete ist korrekt), Aufraeumen-nur-unter-Absprache, erst-additiv. Bekannter geflaggter Bestand (KEIN neuer Defekt): validate_profile.hpp:568 kValidSimd hartkodiert (Single-Source-Luecke, VOR-Workflow bereits als Folge-TODO notiert).

LENS 1 (Symmetrie): ${JSON.stringify(findings[0])}

LENS 2 (golden-Neutral): ${JSON.stringify(findings[1])}

LENS 3 (Residual): ${JSON.stringify(findings[2])}

Gib das Gesamt-Verdikt: COMMIT_OK (nichts Kritisches/Mittleres offen) oder NACHBESSERN (mit priorisierter Fix-Liste). Sei streng aber ehrlich: nur ECHTE, belegte Defekte dieses Commits fuehren zu NACHBESSERN.`,
  { label: 'richter', phase: 'Verdikt', schema: VERDICT_SCHEMA, effort: 'high' }
)

return verdict
