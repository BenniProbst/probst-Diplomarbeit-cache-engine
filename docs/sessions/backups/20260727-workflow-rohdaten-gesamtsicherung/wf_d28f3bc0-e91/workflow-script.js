export const meta = {
  name: 'boundary-completion-roadmap',
  description: 'Hook-(6): §B/§D TABU-respektierende Alternativen + #156-215-Gap-Vorbau + DD-A single-repo — je buildbare-JETZT-Slice vs. enabler-gated, grounded',
  phases: [{ title: 'Scoping', detail: '§B/§D-Alt + #156-Gap-Vorbau + DD-A-single-repo parallel' }, { title: 'Synthese' }],
}
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUP + '/Code/external/comdare-cache-engine'
const S = {
  type: 'object', additionalProperties: false, required: ['buildable_now', 'gated', 'anchors'],
  properties: {
    buildable_now: { type: 'array', items: { type: 'string' }, description: 'konkrete JETZT-buildbare Slice(s) mit Andockpunkt datei:zeile + echtem Konsument + warum kein Null-Consumer/TABU/Bump — oder leer' },
    gated: { type: 'array', items: { type: 'string' }, description: 'was echt enabler-gated bleibt + der grenzen-respektierende Pfad dahin' },
    anchors: { type: 'array', items: { type: 'string' } },
  },
}
phase('Scoping')
const [bd, gap, dda] = await parallel([
  () => agent(
    `Hook-Ask A: SKIZZIERE die TABU-respektierende Alternative fuer §B (Messkurven-Typsystem-WURZEL) + §D (Hybrid-Modus). ` +
    `Vorbefunde (NICHT wiederholen, darauf aufbauen): §B ist Doppelquelle zu profile_to_tree.hpp (${SUP}/docs/sessions/backups/20260711-e4prime-messkurven-typsystem-wurzel/BEFUND.md); ` +
    `§D ist TABU (genus_binding_traits) + ABI-Bump-reserviert-#215 + Null-Consumer + kurven-#156-gated (Scoping wf_9acec65a). ` +
    `FRAGE mit der #31-Lehre (verify vor verwerfen): Gibt es eine Slice, die (a) profile_to_tree als EINZIGE Quelle KONSUMIERT (statt zu doppeln) mit einem ECHTEN non-test-Konsumenten, ` +
    `ODER (b) den §D-Modus-Enum/Zustandsmaschine {Measurement/Evaluation/Working/Hybrid} als Builder-ueber-State (Doc 21 §A.3) baut, wo Measurement/Evaluation ECHTE Pfade (best_binary_selector/Treiber) konsumieren ` +
    `und Working/Hybrid HONEST-STUB (data-gated, wie curve_fit-skeleton) sind — OHNE genus_binding_traits/ABI-Bruch/Null-Consumer? Lies ${CE}/libs/cache_engine/builder (best_binary_selector, cacheline_policy, selection_filter_chain), ` +
    `profile_to_tree.hpp, die disjunkten Modus-Enums (telemetry_mode/experiment_driver MessreihenMode/cache_engine_mode). Sei EHRLICH: falls jede Slice Null-Consumer/TABU bleibt, sag es + gib den grenzen-respektierenden Pfad (was der Enabler entsperrt). datei:zeile.`,
    { label: 'ask-a-bd-alt', phase: 'Scoping', schema: S }),
  () => agent(
    `Hook-Ask B: SCOPE was im #156-#215-Daten-Gap JETZT buildbar ist (Mechanismus ohne echte Messdaten), analog zum bereits gebauten Phase-6-Vorbau ` +
    `(measurement_axis_registry/IMeasurementSource/curve_fit-skeleton, ${CE}/libs/cache_engine/include/cache_engine/measurement + builder/curve_fit). ` +
    `FRAGE: welche Mechanismus-/Vorbau-Teile des Mess-/Auswertungs-Pfads sind NOCH NICHT gebaut und OHNE #156-Daten buildbar+testbar (synthetische Daten)? ` +
    `Kandidaten: der CSV->LaTeX/Diagramm-Auto-Doku-Mechanismus (Tools 04_csv_to_latex/05_diagram_generator, ${SUP}/Code), ein synthetischer-Daten-Fixture-Generator fuer die Auswertungs-Pipeline, ` +
    `Pareto/Dominance-Filterglied-STRUKTUR (selection_filter_chain-Handler) mit synthetischem MeasurementRow, curve_fit-Konsument-Verdrahtung. ` +
    `Je Kandidat: echter non-test-Konsument? Null-Consumer-Risiko (Doc 20 §I)? golden/ABI-TABU? Sei EHRLICH — nur was WIRKLICH einen Konsumenten hat + testbar ist. datei:zeile.`,
    { label: 'ask-b-gap-vorbau', phase: 'Scoping', schema: S }),
  () => agent(
    `Hook-Ask C: SCOPE den DD-A/#274-Matrix-Migrations-Anteil, der INNERHALB EINES Repos (kein cross-repo, keine Repo-Anlage, kein Submodul-Bump, kein buildsystem.xml) prototypierbar ist. ` +
    `Plan: ${SUP}/docs/sessions/20260706-274-MATRIX-MIGRATIONSPLAN-ENTWURF.md + F1-F14-Antworten (Ledger). F1: buildsystem.xml = anderer Agent; PARALLEL CMake/CI + Modul-Code = MEIN Scope. ` +
    `F7-AUFTRAG: die Mess-Frameworks×Workloads-Matrix als Module mit feingliedriger Baseline-2D-Matrix-Struktur abstrahieren. FRAGE mit der #31-Lehre: gibt es einen ADDITIVEN, single-repo, golden/ABI-neutralen Slice ` +
    `(z.B. eine Kopf-Framework-Abstraktion analog container_framework.hpp fuer die Mess-Matrix, ODER die measurement-all-Baseline-Struktur-Doku/-Skelett) mit echtem Konsumenten, der KEINE neue Repo-Anlage + KEINEN Bump braucht? ` +
    `Lies ${CE}/libs (measurement/metrics), die Modules-Struktur falls lokal. Sei EHRLICH: was ist single-repo-additiv vs. was braucht Repo-Anlage/Buildsystem-Agent. datei:zeile.`,
    { label: 'ask-c-dda-singlerepo', phase: 'Scoping', schema: S }),
])
phase('Synthese')
const synth = await agent(
  `Konsolidiere zu einer GRENZEN-RESPEKTIERENDEN VOLLENDUNGS-ROADMAP + einem BUILD-VERDIKT. ` +
  `ASK-A(§B/§D): ${JSON.stringify(bd)} ASK-B(#156-Gap): ${JSON.stringify(gap)} ASK-C(DD-A): ${JSON.stringify(dda)} ` +
  `Liefere: (a) die EINE konkret JETZT-buildbare Slice ueber alle drei Asks (mit Andockpunkt datei:zeile, Design-Pattern-Rahmung, echtem Konsument, Test-Plan) — ODER die ehrliche Feststellung, dass KEINE existiert (mit Beleg je Kandidat, warum Null-Consumer/TABU/Bump); ` +
  `(b) je Ask den grenzen-respektierenden Vollendungs-Pfad (was der Enabler — Job-Token/Cluster/Repo-Anlage — entsperrt, in welcher Design-Pattern-Rahmung); ` +
  `(c) Ranking der buildable_now-Kandidaten nach Wert×Sauberkeit. Anti-Phantom/Anti-Null-Consumer strikt (wie CMD-2/§B-WURZEL): baue nichts, das nur test-konsumiert ist. Sei so konkret, dass ich die Top-Slice sofort bauen ODER die Roadmap committen kann.`,
  { label: 'synthese', phase: 'Synthese' })
return { bd, gap, dda, synthese: synth }
