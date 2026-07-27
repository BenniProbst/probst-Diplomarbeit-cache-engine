export const meta = {
  name: 'da-4layer-experiment-tree',
  description: '4-Layer-Architektur-Analyse: Einstellbarkeit des Experiment-Baums in CacheEngineBuilder (compile-time/runtime-Hybrid) → Planungs-Dossier für #31 (Workload-Extras + Kategorie-Achse M) und #29 (Genus→Typ-Erweiterung), golden/ABI-neutral',
  phases: [
    { title: 'Kartieren', detail: 'je Agent ein Architektur-Layer, read-only, Datei:Zeile-belegt' },
    { title: 'Synthese', detail: 'Layer-Zusammenspiel + Planungs-Dossier #31/#29' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

phase('Kartieren')
const layers = [
  { key: 'experiment_tree', prompt: `READ-ONLY Architektur-Kartierung (kein Edit). In ${CE} suche & lies experiment_tree (experiment_tree.hpp + Verwender). Kartiere PRÄZISE mit Datei:Zeile:
(1) StaticAxisNode vs DynamicVariableNode — was macht eine Achse compile-time (= Teil der Binary-Identität golden_fullpilot_320) vs runtime (for-loop-Wertmenge JE Binary)?
(2) Wie wird der Baum konstruiert & durchlaufen? Welche Achsen sind heute static, welche dynamic?
(3) Wo ist die Workload angebunden (laut Ledger DynamicVariableNode-Seite)?
Nur Ist-Zustand mit Belegen, KEINE Änderungsvorschläge.` },
  { key: 'builder', prompt: `READ-ONLY Architektur-Kartierung (kein Edit). In ${CE} suche & lies CacheEngineBuilder (builder/). Kartiere mit Datei:Zeile:
(1) Wie konfiguriert der Builder ein Experiment? Wie wählt er Anatomie / Workload / Messung?
(2) Wie hängt der Builder am experiment_tree (static vs dynamic Achsen)?
(3) Wo sitzt die Einstellbarkeit — welche Knöpfe sind compile-time-Template-Parameter, welche runtime-Config?
Nur Ist-Zustand mit Belegen, keine Vorschläge.` },
  { key: 'anatomie', prompt: `READ-ONLY Architektur-Kartierung (kein Edit). In ${CE} lies die Anatomie-Ebenen. Kartiere mit Datei:Zeile:
(1) 3 Ebenen Gattung/Genus/Typ (AnatomyGattung, AnatomyGenus, gattung_of); AnatomyConcept (compile-time Hot-Path) vs IAnatomyBase (virtual, nur Module-Loader-ABI-Grenze).
(2) Wie entsteht die Binary-Identität golden_fullpilot_320 (=4·4·5·4)? Welche Achsen bilden die 320er-Permutation?
(3) #29-Stand: comdare::container Kopf-Framework (Schritt-1 vollzogen, additiv) — wo würde die TIEFE Genus→Typ-Umstrukturierung ansetzen (welche Dateien, welche golden/ABI-Berührung)?
Nur Ist-Zustand mit Belegen, keine Vorschläge.` },
  { key: 'mess_achsen', prompt: `READ-ONLY Architektur-Kartierung (kein Edit). In ${CE} lies die Workload-/Mess-Achsen. Kartiere mit Datei:Zeile:
(1) libs/cache_engine/builder/workload_driver/workload_matrix.hpp (#31-Stand): WorkloadKind-Reuse, ycsb_profile_list, CanonicalDataset, matrix_cells (W×D=36), config_for→profile_by_name (runtime).
(2) libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp: die 16 MeasurementCategory (Achse M). Existiert eine metrics/pmc-Regime-Zweiteilung (observer vs counter)? Wenn ja wo, wenn nein wie werden metrics/pmc heute getrennt?
(3) Die 3 Workload-Mengen (WorkloadKind Custom-Ops / profile_by_name IH+LH / F7-Datasets) — was fehlt konkret für #31-Extras (User-Entscheid: WorkloadKind-Basis + IH/LH ergänzen) und die Kategorie-Achse M?
Nur Ist-Zustand mit Belegen, keine Vorschläge.` },
]
const maps = await parallel(layers.map(l => () => agent(l.prompt, { label: `map:${l.key}`, phase: 'Kartieren' })))
const [etree, builder, anatomie, mess] = maps.map(m => m || '(Agent lieferte kein Ergebnis)')

phase('Synthese')
const synth = await agent(`Du bist Architektur-Synthesizer der Diplomarbeit cache-engine. Vier read-only-Ist-Karten (Datei:Zeile-belegt):

## LAYER 1 — experiment_tree
${etree}

## LAYER 2 — CacheEngineBuilder
${builder}

## LAYER 3 — Anatomie-Ebenen (Gattung/Genus/Typ)
${anatomie}

## LAYER 4 — Workload/Mess-Achsen
${mess}

AUFGABE — synthetisiere, wie die 4 Layer zusammen die EINSTELLBARKEIT DES EXPERIMENT-BAUMS in der CacheEngineBuilder bilden, mit klarer Grenze: compile-time (Binary-Identität, golden 320, StaticAxisNode) vs runtime (Mess-Variation je Binary, DynamicVariableNode). Dann erstelle ein PLANUNGS-DOSSIER (nur Plan, KEIN Code):

(A) #31-HYBRID: Workload-Extras (WorkloadKind Custom-Ops + profile_by_name IH/LH — User-Entscheid: WorkloadKind-Basis + IH/LH ergänzen) UND Kategorie-Achse M (16 MeasurementCategory) als compile-time-Achsen der 2D-Mess-Matrix, HYBRID mit runtime passend zum experiment_tree (Static/Dynamic). Konkret: welche Datei, welche mp11-Konstrukte analog matrix_cells, warum golden/ABI-neutral (Workload/Messung = Mess-INPUT, orthogonal zur 320-Permutation), welche Tests.

(B) #29-ERWEITERUNG: tiefe Genus→Typ-Umstrukturierung (comdare::container) — geordnete Schritte, je Schritt die golden/ABI-Risiko-Klasse (additiv-neutral / braucht ABI-GO / golden-tabu), welche Dateien.

Gib strukturiert zurück: (1) Layer-Zusammenspiel + compile-time/runtime-Grenze, (2) Dossier A (Schritte+Dateien+Tests), (3) Dossier B (Schritte+ABI-Risiko-Klassifikation). Belege durchgehend mit den Datei:Zeile-Referenzen aus den vier Karten. Wo eine Karte lückenhaft ist, benenne die Lücke explizit statt zu raten.`, { label: 'synthese', phase: 'Synthese' })

return { maps, synth }
