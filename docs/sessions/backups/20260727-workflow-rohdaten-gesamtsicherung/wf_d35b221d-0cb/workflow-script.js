export const meta = {
  name: 'design-familie-c-real-wiring-L6',
  description: 'Familie-C-real Verdrahtungs-Plan: L-6 (<axis baustein>→serialize_composition_path/PrueflingSlot) mit Belegen auflösen (a Registry vs b fest), C.1-C.3 spezifizieren (Surrogat→reale Katalog-DLLs, execute_messreihe, messung_driver-Antrieb), TABU-Check + vorgeschriebene Backups lesen',
  phases: [
    { title: 'Recherche', detail: 'L-6-Mechanik · C.1-Surrogat-Ersatz · C.2/C.3-Antrieb · TABU+Backups parallel' },
    { title: 'Synthese', detail: 'Increment-Plan C.1-C.3 + L-6-Empfehlung + Gates zur User-Bestätigung' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'

const CTX = `
KONTEXT: Familie C real = den existierenden Verdikt-Layer (Welch/t-Test, compare_engine_command.hpp/welch_t_test.hpp) an die REALEN Katalog-DLLs (3-Stufen-Join, sota_catalog→COMDARE_DEFINE_ANATOMY_MODULE) koppeln, gemessen über die 3 Mess-Dimensionen (Doku 24), STATT an die Surrogate (PrtArtHashBackend=std::unordered_map). Rollback-Anker steht: ce 9f05c6db / super 8f813d1 (+ Parser super 6a40fb9). Der Parser MessreiheV32 existiert jetzt (parse_messreihe_v32, super/Code/02_messung_driver/messreihe_v32_parser.hpp), ist aber NICHT an Katalog/Vergleich verdrahtet.
Metaprog-Plan-Belege (Backup ${SUPER}/docs/sessions/backups/20260713-achsen-gattungen-metaprog/wf-RESULT-raw.json §2): pruefling_merge.hpp (PrueflingSlot, 3-Stufen), sota_catalog.hpp:161-228 (sota_module_for/build_sota_source_map), serialize_composition_path (golden, TABU), anatomy_module_abi_v1.hpp, AnatomyModuleLoader→dynamic_cast<IObservableTier*>.
DIREKTIVEN: compile-time-only Hot-Path (CRTP+Concepts, kein Runtime-Switch/vtable, benannte Patterns); WAS/WIE (ce=Framework/super=Definition); sauberster Weg; TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/kV3AxisSchema/GenusBindingTraits/Registry-mp_list) UNBERÜHRT — Erweiterungen golden-neutral/Default-OFF; Doku nie löschen; Messdaten nie löschen. honest-100%; belege datei:zeile; Unbelegtes=UNBELEGT.
`

phase('Recherche')

const research = await parallel([
  // R1 — L-6 auflösen
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. LÖSE L-6: wie bildet die XML \`<axis id="3" baustein="Patricia"/>\` (messreihe_v32) auf eine REALE compile-time-Komposition ab?
- ${CE}/libs/cache_engine/anatomy/sota_catalog.hpp (sota_module_for :161-216, build_sota_source_map :221-228, render_sota_module_source) — wie wird heute von <sota_series lebewesen merge> auf eine Komposition dispatcht?
- serialize_composition_path (golden, TABU) — das binary_id-Format; wie mappt ein Baustein-Name auf einen Achsen-Slot-Typ?
- ${CE}/libs/cache_engine/anatomy/pruefling_merge.hpp + compositions/prt_art_merge_reference.hpp (PrtArtPathCompressionSlot etc.) — die 4 vorhandenen prt-art-Slots; wie wird ein Slot registriert/benannt?
- Gibt es schon eine String→Slot/Baustein-Registry (AxisLibraryRegistry, DefaultLookupRegistry)? ${CE}/libs/**/axis_library_registry.hpp, registry_to_axis_levels.hpp.
Bewerte OPTION (a) baustein→Slot-Registry bauen (XML programmiert die Komposition deklarativ) vs OPTION (b) XML wählt nur lebewesen+merge, Bausteine aus festem prt-art-Slot-Satz. Für (a): welcher Mechanismus (compile-time, da Slots Typen sind — wie überbrückt man XML-String→Typ? mp_list-Lookup? Auto-Permutator? Codegen?), TABU-Verträglichkeit (golden-320/serialize_composition_path unberührt?).
${CTX}
Liefere: die belegte L-6-Mechanik + (a)-vs-(b)-Bewertung + Empfehlung + genau wie (a) compile-time-konform baubar ist (String→Typ-Brücke).`,
    { label: 'R1:L6-mapping', phase: 'Recherche' }),

  // R2 — C.1 Surrogat-Ersatz
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Spezifiziere C.1: den Surrogat-Backend (PrtArtHashBackend=std::unordered_map) im Verdikt-Layer durch REALE Katalog-DLL-Messungen ersetzen.
- ${SUPER}/Code/02_messung_driver/v32_orchestrator.hpp:148-180 (execute_one_permutation: instanziiert EE-A CacheEngineExecutionEngineAdapter + EE-B PrtArtExecutionEngineAdapter, std::async, CompareEngineCommand). Wo genau sitzt das Surrogat (PrtArtHashBackend)?
- Der reale Pfad: AnatomyModuleLoader lädt die DLL, dynamic_cast<IObservableTier*> — wie kommt man von einer Stufe-1/Stufe-2-Komposition zu gemessenen Latenz-Samples? ${CE}/libs/**/anatomy_module_abi_v1.hpp, IObservableTier tier_observe, drive_tier_observe_trace (Doku 24 §8.6).
- Wie speist man die 3 Mess-Dimensionen (Wall-Clock/Per-Achsen-Observer/Achsen-Vergleich) in ExecutionResult.latency_samples_ns, das CompareEngineCommand/Welch konsumiert?
- EE-A = Stufe-1-Tier (CE-SOTA), EE-B = Stufe-2-Tier (Prüfling-ersetzt) — beide reale Katalog-DLLs. Ist die Adapter-Schnittstelle (as_engine_callable) damit speisbar, oder braucht es einen neuen Tier→EngineCallable-Adapter?
${CTX}
Liefere: die C.1-Spec (welche Datei/Zeilen, wie der reale Tier statt Surrogat in den Vergleich fließt), TABU-Verträglichkeit, benannte Patterns.`,
    { label: 'R2:C1-surrogat-ersatz', phase: 'Recherche' }),

  // R3 — C.2/C.3 Antrieb
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Spezifiziere C.2 (execute_messreihe verdrahten) + C.3 (messung_driver-Antrieb).
- ${SUPER}/Code/02_messung_driver/v32_orchestrator.hpp:81-85 (execute_messreihe-Stub return 0) — wie fließt die geparste MessreiheV32 (aus messreihe_v32_parser.hpp) hier ein → Katalog-Build (L-6/R1) → Messung (R2) → run_messreihe_for_op_type (:139-144) → CompareEngineCommand → MessreiheReport?
- ${SUPER}/Code/02_messung_driver/main.cpp — wie dockt der Treiber an? Heute ruft er execute_messreihe nie (grep). #230 (docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md Teil B.1): die compile-time-Kette ist test-harness-eingesperrt. Wie treibt man sie produktiv, INERT-by-default (COMDARE_V32_DRIVER_ENABLE-Flag, FORK-3=C-1 empfohlen)?
- op_type OP-1..6 (op_type_filter.hpp kOpTypeTable) → cmd::WorkloadKind (OP-2 BulkInsert/OP-6 RangeDelete) — wie in den Lauf eingespeist.
- messreihe_report_exporter.hpp — wie der MessreiheReport zu CSV/LaTeX exportiert wird (Anschluss an die xml→pdf-Kette / Anhang).
${CTX}
Liefere: C.2+C.3-Spec (Dateien/Zeilen, Flag-Kapselung, Treiber-Andock, Export-Anschluss), INERT-by-default, TABU-Check.`,
    { label: 'R3:C2-C3-antrieb', phase: 'Recherche' }),

  // R4 — TABU + vorgeschriebene Backups + vergessene TODOs
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. (1) TABU-Grenzen für die Familie-C-Verdrahtung + (2) die vom Goal vorgeschriebenen Backups lesen + relevante vergessene Punkte surfacen.
- TABU: golden_fullpilot_320 + CatalogAxes<4,4,5,4>=320 (#229, docs/architektur/17 B.1 Blocker 2 — XML treibt heute nur INNERHALB golden-320; darf die Familie-C-Verdrahtung das ändern? NEIN ohne GO). serialize_composition_path/POD-1416/kV3AxisSchema/ABI-4/GenusBindingTraits/permutation_axes.xml — welche berührt die Verdrahtung potentiell, wie golden-neutral halten?
- LIES ${SUPER}/docs/sessions/backups/20260712-full-line-review/ (REVIEW-BERICHT.md + MANIFEST.md) + ${SUPER}/docs/sessions/backups/20260712-forgotten-todo-sweep/ — welche offenen/vergessenen Punkte betreffen Familie C / v32 / EE-A-EE-B / den Katalog-Pfad / #230 / #229? (Goal-Pflicht: „vor jeder Stufe lesen".)
- Ledger W4 ~:961 (die drei quarantänisierten ALT-Pfade) + #230 (test-harness-Einsperrung) — bestätige die Abgrenzung.
${CTX}
Liefere: die TABU-Leitplanken je C-Increment + die relevanten vergessenen/offenen Punkte aus den 2 Backups (datei:zeile) + ob die Verdrahtung golden-neutral bleibt.`,
    { label: 'R4:tabu-backups', phase: 'Recherche' }),
])

const [r1, r2, r3, r4] = research.map(r => r || '(kein Ergebnis)')

phase('Synthese')

const plan = await agent(
`Du bist der Architekt. honest-100%, Goal-V4. Fasse die 4 Berichte zu EINEM Familie-C-real Verdrahtungs-Increment-Plan zusammen — zur User-Bestätigung (NEUE Architektur → Optionen + Empfehlung, kein Bau).

=== R1 L-6-Mapping ===
${r1}
=== R2 C.1 Surrogat-Ersatz ===
${r2}
=== R3 C.2/C.3 Antrieb ===
${r3}
=== R4 TABU + Backups ===
${r4}

${CTX}

Liefere:
1. **L-6-AUFLÖSUNG** — die belegte Empfehlung (a Registry vs b fest), WIE (a) compile-time-konform baubar ist (XML-String→Typ-Brücke), TABU-verträglich.
2. **INCREMENT-PLAN C.1→C.3** — je Increment: Titel · exakte Dateien/Zeilen · Mechanik (benannte Patterns, compile-time-Grenze) · Gate (ctest/golden-320==320/cf22/mojibake) · INERT-Kapselung (COMDARE_V32_DRIVER_ENABLE).
3. **TABU-CHECK** je Increment (golden-320/serialize_composition_path/POD/ABI unberührt? golden-neutral?).
4. **VERGESSENE/OFFENE PUNKTE** aus den 2 Backups, die einfließen müssen.
5. **DIE 1-2 ENTSCHEIDUNGEN für den User** (L-6 a/b + ob CatalogAxes-Grenze #229 berührt werden darf) + benannte deep-research-Bedarfe (Achsen-Optimierungs-Semantik §5.2).
Konkret genug, dass nach User-GO jeder Increment direkt umsetzbar ist. Markiere jede unbelegte Annahme.`,
  { label: 'synthese:c-plan', phase: 'Synthese' })

return { plan, recherche: { r1, r2, r3, r4 } }
