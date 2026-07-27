export const meta = {
  name: 'audit-achsen-gattungen-metaprog-pruefling',
  description: 'Achsen-Inventar (Achsen × Gattungen × Typ-Familien × Algorithmen) + den compile-time-Metaprogrammierungs-Plan finden, wie die Cache-Engine Prüfling-Achsen-Algorithmen (PRT-ART) dynamisch per Config/XML verdrahtet (C++23) — Familie C als das gemeinte, noch fehlende Feature verstehen',
  phases: [
    { title: 'Recherche', detail: 'Achsen-Inventar · Gattungen/Typ-Familien · Metaprog-Verdrahtungs-Plan · 3-Mess-Kombinationen parallel' },
    { title: 'Synthese', detail: 'Inventar + artikulierter Metaprog-Plan + Familie-C-Reframing + Parser-Bau-Spec' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const PRT = SUPER + '/Code/external/comdare-prt-art'

const FRAME = `
USER-RAHMUNG (2026-07-13, bindend — Familie C ist KEIN Konflikt, sondern ein missverstandenes Feature):
- Per Plan IST jede Achse der Cache-Engine der STAND DER TECHNIK (SOTA-Baseline).
- Prüflinge (v.a. PRT-ART) liefern ACHSEN-ALGORITHMEN, die durch die 3 MESS-KOMBINATIONEN (Mess-Modi) gegen die SOTA-Achse verglichen werden. Deep-research-Name: Welch-Test / t-Test / Zwei-Engine (EE-A CacheEngine vs EE-B Prüfling). GENAU DIESE DEFINITION FEHLT NOCH im Code.
- PRT-ART wird NIEMALS HART verdrahtet. Das Banner "prt_art_execution_engine_adapter.hpp: NIE in den Mess-Pfad verdrahten" ist KORREKT: die Cache-Engine zieht den Prüfling DYNAMISCH ZUR COMPILE-ZEIT per Config + XML-Config-Programmierung ein — über modernste C++23-Metaprogrammierung. Diesen "sehr komplexen Metaprogrammierungs-Plan" MUSS die Recherche finden + artikulieren.
- Die Surrogate std::map vs unordered_map (im v32_orchestrator) sind UNSAUBER — der echte Vergleich läuft über die realen Container-GATTUNGEN/Achsen, nicht Surrogat-Backends.
Frühere Backups zum Aufsetzen: ${SUPER}/docs/sessions/backups/20260713-familie-c-design-dossier/wf-RESULT-raw.json, .../20260713-audit-3-schema-familien/wf-RESULT-raw.json, .../20260709-v32-fork-analyse-31-e4xml/BEFUND.md. Architektur-Doku: ${SUPER}/docs/architektur/ (E1-E4, 14_achsen_komposition_organ_metapher, 24_*prtart*).
honest-100%; belege datei:zeile; Unbelegtes als UNBELEGT markieren; nichts erfinden.
`

phase('Recherche')

const research = await parallel([
  // R1 — Achsen-Inventar: welche Achsen, welche Algorithmen
  () => agent(
`ULTRACODE-Code-Inventar, belege datei:zeile. Erstelle das VOLLSTÄNDIGE Achsen-Inventar der Cache-Engine — welche Achsen existieren JETZT und welche Algorithmen (SOTA-Baseline) trägt jede.
- Enumeriere alle Achsen: ${CE}/libs/cache_engine/axes/** (die 19 T0-T18 + Build-Achsen page_type/09b/12). Nutze kCompositionAxisNames (axis_path_serialization.hpp) als Kanon.
- Je Achse: (a) Name/Slot-Index, (b) das Strategie-/Algorithmus-Set (welche konkreten Algorithmen/Policies sind implementiert — z.B. index_organization: Heap/Clustered/NonClustered/IOT), (c) das steuernde Concept (CRTP-Basis + Concept-Guard), (d) der Observer/Mess-Anschluss (kV3AxisSchema-Felder).
- Wie werden Achsen zu einem Tier komponiert (AdHocComposition<T0..T18>, mp_product, CartesianPermutations)?
${FRAME}
Liefere: Achse → {Algorithmen-Set, Concept, Observer-Felder} als Matrix, datei:zeile-belegt. Markiere Achsen mit nur 1 Algorithmus (gepinnt) vs. mehreren (permutierend).`,
    { label: 'R1:achsen-inventar', phase: 'Recherche' }),

  // R2 — Gattungen + Typ-Familien
  () => agent(
`ULTRACODE-Code-Recherche, belege datei:zeile. Kartiere die GATTUNGEN + TYP-FAMILIEN und welche Achsen zu welcher gehören.
- Die 3 Gattungen (AnatomyGattung: SearchAlgorithm / Container / Graph) — wo definiert, was unterscheidet sie?
- Die 5 Lebewesen-Genera (AnatomyGenus: SearchAlgorithm/Set/Sequence/Adapter/View) + GenusBindingTraits<G> — welcher Achsen-Satz je Genus (Slots 19/15/11/13/7)? ${CE}/libs/**/GenusBindingTraits*, anatomy/**.
- Typ-Familien = die konkreten Container/Datenstruktur-Familien (welche realen Container implementieren welche Gattung — z.B. Set→node_pool_store, Sequence→...). Welche Achsen sind je Typ-Familie relevant?
- Die "container"-Gattung speziell (comdare::container, AP-15): welche Achsen + Algorithmen?
${FRAME}
Liefere: Gattung/Genus → {Achsen-Satz, Typ-Familien, konkrete Container/Algorithmen}, datei:zeile. Kläre, wie std::map/unordered_map (die unsauberen Surrogate) sich zu den ECHTEN Gattungen verhalten — was wären die sauberen realen Vergleichs-Container?`,
    { label: 'R2:gattungen-typfamilien', phase: 'Recherche' }),

  // R3 — DER Metaprogrammierungs-Plan (compile-time Prüfling-Verdrahtung)
  () => agent(
`ULTRACODE-Recherche — die WICHTIGSTE: FINDE + artikuliere den "sehr komplexen Metaprogrammierungs-Plan", wie die Cache-Engine einen Prüfling (PRT-ART) DYNAMISCH ZUR COMPILE-ZEIT per Config/XML einzieht, OHNE ihn hart zu verdrahten (das ist der Sinn des "NIE verdrahten"-Banners). Belege datei:zeile.
Suche gründlich in:
- ${PRT}/prt_art/** (der Adapter + das Banner prt_art_execution_engine_adapter.hpp:2-6 — was ist der INTENDIERTE Alternativweg statt Hart-Verdrahtung? Was verspricht "V35+"?)
- ${CE}/libs/** — der Kompositions-/Injektions-Mechanismus: wie wird eine Prüfling-Achse compile-time in die 19-Achsen-Komposition INJIZIERT/ERSETZT? Concepts, CRTP, Policy-Based, mp_list-Substitution, AdHocComposition-Slot-Ersetzung.
- "Regel der abstrakt-leeren Achse" (leere Prüfling-Achse reust alle CE-Algos) — PRT-ART-3-Stufen-Join (Stufe 1 CE-Perms / Stufe 2 Prüfling-ersetzt / Stufe 3 A⋈B). ${SUPER}/docs/architektur/24_*prtart* + Ledger + thesis/.../03_messsystem_prtart.tex.
- XML-Config-Programmierung: wie steuert die XML (Familie A/C) die compile-time-Achsen-Auswahl UND die Prüfling-Injektion? Wie verbindet sich das mit E3 (Permutation) / E2 (Tier-DLL)?
Wenn der Plan nur teilweise/verstreut existiert, rekonstruiere ihn aus den Belegen + benenne die C++23-Features (Concepts, requires, if constexpr, templated lambdas, mp_list) + benannte Lehrbuch-Patterns.
${FRAME}
Liefere: den artikulierten Metaprog-Verdrahtungs-Plan (compile-time Prüfling-Achsen-Injektion via Config/XML), datei:zeile-belegt, + welche C++23-Features/Patterns ihn tragen + was davon EXISTIERT vs FEHLT.`,
    { label: 'R3:metaprog-plan', phase: 'Recherche' }),

  // R4 — 3 Mess-Kombinationen + Familie-C-Einordnung + Parser-Gap
  () => agent(
`ULTRACODE-Recherche, belege datei:zeile. Kläre die 3 MESS-KOMBINATIONEN und wie Familie C (messreihe_v32) sie formalisiert.
- Die 3 Mess-Dimensionen/-Modi (aus früherer Kartierung: Lebewesen-Wall-Clock / Per-Achsen-Observer / Achsen-Vergleich-gegen-Prüfling). Wie vergleicht jede Cache-Engine-Achse (SOTA) gegen Prüfling-Achsen-Algorithmen durch diese 3 Kombinationen? ${CE}/libs/**/measure*, benchmark*, prueф_dock/PruefDockRegistry select_for.
- Familie C: messreihe_v32-XSD (${SUPER}/Code/test_data_xml/messreihe_v32_schema.xsd) — TupelType/op_type OP-1..6/execution_engines — wie bildet sie den SOTA-vs-Prüfling-Achsen-Vergleich ab? Welch-Test (welch_t_test.hpp), CompareEngineCommand. Warum ist EE-A/EE-B das gemeinte Feature (nicht Surrogat).
- Der XML→Struct-Parser-GAP: fehlt ein Parser für das ALLGEMEINE XML-Experiment-Interface der Diplomarbeit (v32/messreihe)? Was genau existiert (v32_orchestrator.hpp Stub, messreihe_v32_validator.hpp string-find) vs. was ein echter Parser leisten muss, um die compile-time-Prüfling-Verdrahtung (R3) zu speisen. ${SUPER}/Code/02_messung_driver/**.
${FRAME}
Liefere: die 3-Mess-Kombinationen × SOTA-vs-Prüfling-Achsen-Mechanik + Familie-C-Formalisierung + präzise Parser-Bau-Anforderung (was der general-XML-Parser leisten muss), datei:zeile.`,
    { label: 'R4:mess-kombi-parser', phase: 'Recherche' }),
])

const [r1, r2, r3, r4] = research.map(r => r || '(kein Ergebnis)')

phase('Synthese')

const synth = await agent(
`Du bist der konsolidierende Architekt. honest-100%, Goal-V4. Fasse die 4 Recherche-Berichte zusammen — der User will (a) das Achsen/Gattungen/Algorithmen-Inventar, (b) den gefundenen compile-time-Metaprogrammierungs-Plan der Prüfling-Verdrahtung, (c) Familie C als missverstandenes-Feature korrekt eingeordnet, (d) die Parser-Bau-Spec.

=== R1 Achsen-Inventar ===
${r1}
=== R2 Gattungen/Typ-Familien ===
${r2}
=== R3 Metaprog-Plan ===
${r3}
=== R4 Mess-Kombinationen/Parser ===
${r4}

${FRAME}

Liefere strukturiert:
1. **ACHSEN-INVENTAR** — Tabelle: Achse → Gattung/Genus → Typ-Familie → Algorithmen-Set (SOTA) → Concept → Observer-Felder. Vollständig, datei:zeile.
2. **DER METAPROGRAMMIERUNGS-PLAN** — präzise Artikulation, wie die Cache-Engine einen Prüfling-Achsen-Algorithmus compile-time per Config/XML injiziert (C++23-Features + benannte Patterns), warum PRT-ART NIE hart verdrahtet wird, was EXISTIERT vs FEHLT. Das ist das Kernstück.
3. **FAMILIE C KORREKT EINGEORDNET** — kein Konflikt: das SOTA-Achse-vs-Prüfling-Achsen-Vergleichs-Feature (die 3 Mess-Kombinationen, Welch/t-Test), das noch fehlt. Was die Surrogate ersetzen muss (echte Gattungen). Wie EE-A/EE-B auf den Metaprog-Plan abbildet.
4. **PARSER-BAU-SPEC** — der XML→Struct-Parser für das allgemeine Diplomarbeit-Experiment-XML-Interface: exakte Dateien/Struktur, was er parsen muss, wie er die compile-time-Verdrahtung speist, TABU-neutral. Umsetzungsreif.
5. **OFFENE BELEGE / DEEP-RESEARCH-BEDARF** (honest-100%): was unbelegt blieb, welche Achsen-/Gattungs-Eigenschaft nicht benannt ist (→ deep research).
Markiere jede unbelegte Annahme. Konkret genug für Umsetzung.`,
  { label: 'synthese:inventar-plan', phase: 'Synthese' })

return { synthese: synth, recherche: { r1, r2, r3, r4 } }
