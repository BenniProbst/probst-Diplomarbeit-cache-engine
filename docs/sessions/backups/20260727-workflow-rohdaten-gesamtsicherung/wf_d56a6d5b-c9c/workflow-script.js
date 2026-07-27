export const meta = {
  name: 'cmd1-kartierungs-refresh',
  description: 'CMD-1-Kartierung (SE-22 §5, Stand 03.07.) gegen HEAD re-verifizieren — Deltas durch 4c-iv/AP-15/S7',
  phases: [{ title: 'Refresh', detail: '3 parallele Verifikatoren gegen aktives HEAD' }],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const SCHEMA = {
  type: 'object',
  properties: {
    verifiziert: { type: 'array', items: { type: 'string' }, description: 'SE-22-§5-Anker die am HEAD noch stimmen (mit aktueller datei:zeile)' },
    deltas: { type: 'array', items: { type: 'string' }, description: 'Abweichungen gegenüber der 03.07.-Kartierung (verschobene Zeilen, umbenannte Symbole, NEUE Belange wie IAllocatorProxyTier)' },
    dossier_relevanz: { type: 'array', items: { type: 'string' }, description: 'Was das CMD-1-Dossier dadurch anders/zusätzlich vorschreiben muss' },
  },
  required: ['verifiziert', 'deltas', 'dossier_relevanz'],
}

phase('Refresh')
const [wurzeln, adapter, inseln] = await parallel([
  () => agent(`Verifiziere READ-ONLY am HEAD von ${CE} die CMD-1-WURZEL-Anker (SE-22-§5-Kartierung vom 03.07., seither Renames/Erweiterungen). Lies VOLLSTÄNDIG:
1. libs/cache_engine/execution_engine/execution_engine_base.hpp — wo genau ist IExecutionEngine (§5 sagte :98)? Welche Methoden führt es? Wo würde die F1-SEPARATE Mess-Wurzel abgespalten (Zwei-Wurzel-Modell E-B: Organ-Achsen=IExecutionEngine-Basis, Mess-Achsen=separate Mess-Basis die NOCH NICHT existiert)?
2. libs/cache_engine/anatomy/anatomy_base.hpp — IAnatomyBase:IExecutionEngine-Erbkette aktuell?
3. libs/cache_engine/topics/axis_base.hpp — AxisBase (§5: :52, KEIN CRTP) + enabled/is_original-Statik (:64/:78) aktuell? Welche Achsen-Basen erben davon (grep AxisBase über axes/)?
4. libs/cache_engine/src/measurement/measurable_concept.hpp — MeasurableComponent/Observer (§5: :60/:113, compile-time Mess-Slot, STATISTICS-gated, BEHALTEN) aktuell?
Antworte auf Deutsch mit exakten aktuellen Zeilennummern.`, { label: 'wurzeln', phase: 'Refresh', schema: SCHEMA }),

  () => agent(`Verifiziere READ-ONLY am HEAD von ${CE} den god-header für CMD-1. Lies libs/cache_engine/anatomy/abi_adapter.hpp GEZIELT (Datei ist riesig — Kopf-Kommentarblock komplett + Erb-Deklaration + die relevanten Abschnitte):
1. Die Erbliste von SearchAlgorithmAbiAdapter (§5 sagte: IResourceControllableTier:145 + IObservableTier:150 + IDriveableTier:158) — AKTUELL inkl. des NEUEN IAllocatorProxyTier (AP-15-2)? Exakte Zeilen.
2. Welche Mess-Belange laufen heute durch den Adapter (tier_observe/fill_observer_v3, T6-S7-Kaskade, tier_get_allocator, observe_all-Iteration) — Zeilenanker.
3. Nach 4c-iv: container_algorithm_-Familie (statt container_) — bestätigen + prüfen ob CMD-1-relevante Kommentar-Marken (anatomy_execution_context :116 §5-Marke) noch existieren (builder/anatomy_commands/anatomy_execution_context.hpp).
4. anatomy/resource_controllable_tier.hpp:56 Limitations-Auskunft (BEHALTEN) — aktuell?
Antworte auf Deutsch mit exakten aktuellen Zeilennummern.`, { label: 'god-header', phase: 'Refresh', schema: SCHEMA }),

  () => agent(`Verifiziere READ-ONLY am HEAD von ${CE} die zu subsumierenden CMD-1-INSELN (SE-22 §5) + BEHALTEN-Liste:
1. builder/commands/i_command.hpp (Test-Treiber-Insel, Skelett) — noch da? Konsumenten (grep)?
2. builder/anatomy_commands/* (Builder-Pilot, 1 Test) — Dateiliste + Test?
3. include/cache_engine/strategy_command/* (vestigial, 1 Test) — Dateiliste + Test?
4. builder/algorithm_visitor/ (LEER, .gitkeep) — noch leer?
5. BEHALTEN: builder/workload_orchestrator.hpp WorkloadOp-switch (§5: :75-152, Command-als-Daten IM Mess-Pfad) — aktuell? RuntimeMeasureVisitor (kein Visitor → UMBENENNEN) — wo lebt er, wie viele Konsumenten?
6. NEU seit Kartierung: gibt es durch AP-15-3 (DriveableMapContract-CRTP in builder/pruef_dock/) einen NEUEN Command-/Visitor-artigen Belang, den CMD-1 kennen muss?
Antworte auf Deutsch mit exakten aktuellen Zeilennummern + Konsumenten-Zahlen.`, { label: 'inseln', phase: 'Refresh', schema: SCHEMA }),
])

return { wurzeln, adapter, inseln }