export const meta = {
  name: 'design-familie-c-v32-ee-a-ee-b',
  description: 'Familie C (messreihe_v32) real machen: EE-A/EE-B-Zwei-Engine-Vergleich — Revival-Umfang, Design im Pattern-Rahmen, Rollback-Strategie, Bit-Bank-Tilgungs-Abgrenzung. READ-ONLY Design-Dossier (Phase ②, nach Familie-A-Rollback-Anker vorzulegen)',
  phases: [
    { title: 'Recherche', detail: 'V32-Fläche + Tilgungs-History + EE-A/EE-B-Thesis-Design + Pattern-Rahmen parallel' },
    { title: 'Design', detail: 'Revival-Dossier mit Optionen + Rollback + TABU-Check' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

const CTX = `
KONTEXT: Der User hat entschieden: ERST Familie A (comdare_thesis_profile) um <measurement_categories> vollenden, DANN Familie C (messreihe_v32) real machen — aber Familie C erst auf einem SICHEREN ROLLBACK-COMMIT (= dem grünen Familie-A-Stand). Diese Recherche ist die READ-ONLY Design-Vorbereitung für Familie C; sie baut/committet NICHTS.
Familie C (aus 14.07.-Audit, belegt): Wurzel <messreihe version="32">; die EINZIGE .xsd im Repo (${SUPER}/Code/test_data_xml/messreihe_v32_schema.xsd); v32_orchestrator ist ein toter return-0-Stub (COMDARE_V32_ENABLE, nie in main.cpp inkludiert). Genuiner Mehrwert = EE-A/EE-B-Zwei-Engine-Vergleich (CacheEngine vs PrtArt, Welch-t-Test) + reiche op_type-Achse (OP-1..6 Bulk-Insert/Range-Delete, die YCSB A-F nicht trägt).
Audit-Backup zum Aufsetzen: ${SUPER}/docs/sessions/backups/20260713-audit-3-schema-familien/wf-RESULT-raw.json (Feld /synthese) + ${SUPER}/docs/sessions/backups/20260709-v32-fork-analyse-31-e4xml/BEFUND.md.
DIREKTIVEN: Metaprogrammierung compile-time-only im Hot-Path (CRTP+Concepts, kein Runtime-Switch/vtable, benannte Lehrbuch-Patterns); WAS/WIE-Trennung (ce=Framework/super=Definition); sauberster Weg; TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/kV3AxisSchema/GenusBindingTraits) unberührt; Doku nie löschen. honest-100%. Belege datei:zeile; Unbelegtes als UNBELEGT markieren.
`

phase('Recherche')

const research = await parallel([
  // R1 — V32-Fläche exakt
  () => agent(
`ULTRACODE-Code-Recherche, belege datei:zeile. Kartiere die GESAMTE messreihe_v32/Familie-C-Fläche EXAKT — was existiert, was fehlt:
- XSD: ${SUPER}/Code/test_data_xml/messreihe_v32_schema.xsd — ALLE Elemente (Wurzel, ExecutionEnginesType/EE-A/EE-B, TupelType, op_type OP-1..6, hardware/scheduling/compiler_strategy, axes). Zeilen je Element.
- v32_orchestrator: finde ${CE}/**/v32_orchestrator.hpp — der Stub (return 0), COMDARE_V32_ENABLE-Guard, Freeze-Kommentar, was er tun SOLLTE.
- Fehlt: gibt es einen XML→Struct-Parser für <messreihe version=32>? (Erwartung: NEIN — grep). Gibt es Beispiel-Instanz-XMLs? messreihe_report_exporter?
- Tests: welche test_*_v32/messreihe-Tests existieren (tests-only)?
- cache_engine_commands_v32-Lib (blieb nach Bit-Bank-Tilgung) — was ist da drin?
${CTX}
Liefere: was-existiert vs was-fehlt-Matrix (datei:zeile) für ein reales Familie-C-Engine.`,
    { label: 'R1:v32-flaeche', phase: 'Recherche' }),

  // R2 — Bit-Bank-Tilgungs-Abgrenzung
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Kläre die Abgrenzung Bit-Bank (getilgt) vs messreihe_v32/Familie C (steht):
- Der V32-Tilgungs-Commit (ce ebcc5498, Ledger §12 #36) + ${SUPER}/docs/DIPLOMARBEIT-...LEDGER.md — was genau wurde entfernt (PermutationFlagsV32 82-bit-Bank, AbiV1ToV2Mapper, test_permutation_flags_v32)? Warum? Was blieb (cache_engine_commands_v32-Lib, report_exporter, test_commands/test_engine_adapters)?
- Der Anker sagte „Bit-Bank = Import/Export-Feature des B+-Baums" — ist das im Code/Doku belegt? (Audit fand: UNBELEGT). Kläre: war die Bit-Bank Teil des EE-A/EE-B-Vergleichs oder ein separates Permutations-Identitäts-Artefakt?
- Was von der getilgten Bit-Bank müsste für ein reales Familie-C-Engine NEU/anders gebaut werden, was ist irrelevant?
${CTX}
Liefere: präzise Tilgungs-Abgrenzung — was Familie C real machen NICHT wiederbeleben muss (die Bit-Bank), was es NEU braucht (XML-Parser + Orchestrator).`,
    { label: 'R2:tilgung-abgrenzung', phase: 'Recherche' }),

  // R3 — EE-A/EE-B Thesis-Design (deep bei Bedarf)
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Was ist der intendierte EE-A/EE-B-Zwei-Engine-Vergleich fachlich? Quellen:
- Thesis-LaTeX ${SUPER}/thesis/diplomarbeit/**/*.tex (grep: EE-A, EE-B, execution engine, Welch, t-Test, PRT-ART, SOTA, op_type, Bulk-Insert, Range-Delete, Zwei-Engine, Vergleich)
- ${SUPER}/docs/architektur* + Ledger (#31 PRT-ART-3-Stufen-Join, Prüf-Dock, EE-A/EE-B)
- die XSD-Semantik (op_type OP-1..6 vs YcsbWorkload A-F — welche Operationen deckt OP-1..6 ab, die YCSB nicht trägt?)
Kläre: (1) EE-A = CacheEngine, EE-B = PrtArt? Wie werden beide getrieben (das PRT-ART-3-Stufen-Join-Muster, abstrakt-leere-Achse)? (2) Der Welch-t-Test-Vergleich — was wird verglichen (Latenz je op_type)? (3) Wie verhält sich das zu Familie A (die 19-Achsen-Anatomie) und Familie B (die 3 Messreihen A/B/C, PRT-ART vs SOTA)? Ist Familie C eine REICHERE Fassung von Familie B?
Wenn eine geforderte Eigenschaft NICHT benannt/belegbar ist, markiere sie als deep-research-Bedarf.
${CTX}
Liefere: das fachliche EE-A/EE-B-Design (belegt) + Abgrenzung zu Familie A/B + offene benannte Lücken.`,
    { label: 'R3:ee-design', phase: 'Recherche' }),

  // R4 — Pattern-Rahmen + Familie-A-Beziehung + Rollback
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Wie soll ein REALES Familie-C-Engine architektonisch gebaut werden — im gesetzten Pattern-Rahmen, ohne Familie A zu duplizieren?
- Metaprog-Doktrin: die Achsen (axes im TupelType) sind compile-time (CRTP+Concepts); die EE-A/EE-B-Auswahl + op_type-Schleife = Laufzeit (E1/E3-Muster)? Prüfe die E1-E4-Maschinerie (${SUPER}/docs/architektur*, DynamicVariableNode, Abstract Factory make_static/make_dynamic).
- KEINE Duplizierung: Familie C MUSS Datasets + measurement_categories aus Familie A wiederverwenden (nicht in der XSD duplizieren — SCHEMA.md:39-Verortungs-Fix). Wie referenziert C die A-Definitionen sauber?
- COMDARE_V32_ENABLE als Feature-Flag für sauberen Rollback: wie kapselt man Familie C hinter dem Flag, so dass der Familie-A-Stand (Rollback-Anker) unberührt/wiederherstellbar bleibt? Eigener Branch vs. Flag-Guard?
- WAS/WIE: liegt das Familie-C-Engine in ce (Framework) oder super (Definition)? Wo der Treiber-Konsum (main.cpp)?
${CTX}
Liefere: die Architektur-Skizze (compile-time-Achsen + runtime-EE-Auswahl), die Familie-A-Wiederverwendungs-Strategie, die Rollback/Flag-Kapselung, WAS/WIE-Verortung — je datei:zeile-verankert + benannte Lehrbuch-Patterns.`,
    { label: 'R4:pattern-rahmen', phase: 'Recherche' }),
])

const [r1, r2, r3, r4] = research.map(r => r || '(kein Ergebnis)')

phase('Design')

const dossier = await agent(
`Du bist der Architekt. honest-100%, Goal-V4. Fasse die 4 Recherche-Berichte zu EINEM Familie-C-Revival-Design-Dossier zusammen (Phase ②, dem User NACH dem Familie-A-Rollback-Anker vorzulegen — es geht um eine NEUE Architektur-Entscheidung, daher Optionen + Empfehlung, nicht einfach bauen).

=== R1 V32-Fläche ===
${r1}
=== R2 Tilgungs-Abgrenzung ===
${r2}
=== R3 EE-A/EE-B-Design ===
${r3}
=== R4 Pattern-Rahmen ===
${r4}

Liefere strukturiert:
1. **Was Familie-C-real-machen bedeutet** — Scope in einem Absatz (EE-A/EE-B-Zwei-Engine-Vergleich, op_type OP-1..6, reale XML→Struct-Parser + Orchestrator statt Stub).
2. **Was existiert / fehlt / NICHT wiederbeleben** (die getilgte Bit-Bank ist NICHT nötig) — datei:zeile.
3. **Architektur** (compile-time-Achsen CRTP+Concepts + runtime-EE-Auswahl; Familie-A-Wiederverwendung für Datasets/Kategorien; benannte Patterns; WAS/WIE-Verortung).
4. **Rollback-Strategie** — wie der Familie-A-Anker unberührt bleibt (COMDARE_V32_ENABLE-Flag-Kapselung + eigener Increment-Schnitt); TABU-Check (golden-320/POD/ABI/kV3AxisSchema unberührt).
5. **Increment-Schnitt** INC-V32-C.1..n (geordnet, je Gate).
6. **Offene Design-Entscheidungen für den User** (Klartext-Forks) + benannte deep-research-Bedarfe.
Markiere jede unbelegte Annahme. Konkret genug für eine informierte Design-GO-Entscheidung.`,
  { label: 'design:dossier', phase: 'Design' })

return { dossier, recherche: { r1, r2, r3, r4 } }
