export const meta = {
  name: 'e4prime-messkurven-typsystem-root-design',
  description: 'Deep-Research: kleinste buildbare tree<axis>-Wurzel-Slice des Messkurven-Typsystems (Doc 20 §B), Kardinalitaeten aus m3v2 (nicht erfinden)',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Critique' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const IST = `IST-VERIFIKATION (belegt):
ZIEL (Doc 20 §B, ${SUP}/docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md:17-40): SOLL-Typsystem woertlich:
tree<axis compile/dynamic, map<workload-framework, map<workload-type, map<workload-size, map<operation_type, map<axis_observer_type, tuple<observer_special_compare_property_type, time>>>>>>>
Jede Achse compile-time UND run-time separat durchgefahren -> vollstaendige Uebersicht aller Eigenschaften/Einzelmessungen = multidimensionale Custom-DB. Kardinalitaets-Auftrag: in KLASSEN und HIERARCHIEN einteilen, sodass die Mess-System-Achsen (Registry/"Blut", measurement_axis_registry.hpp) die Auswertung ermoeglichen.
WICHTIG (Doc 20 line 112 + §I-supersede line 144): die tree<axis compile/dynamic>-WURZEL (§G) ist UNABHAENGIG von den Map-Ebenen und wird ZUERST gebaut; die Map-Ebenen warten auf die 7 §H-Forks — die sind ALLE in ${SUP}/docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md entschieden. Das "orthogonal compile/dynamic"-Bild ist durch Doc 21s LAYER-/Haupt-Unter-Achsen-Modell ERSETZT (jede Achse = ein Layer; statische/compile Achse = strikter Layer, dynamische Achsen-Knoten darunter; Wurzel = System-/Meta-Achsen mit Mess-System; Visitor reicht Workloads durch; Strategy in den Visitors; Prozess-Dimension = Builder-ueber-State; Decorator-ueber-Visitor-State-Log).
KARDINALITAETEN: NICHT erfinden — aus m3v2/Workload-Kanon (Doc 20 §E:64) + Doc 20 §G (Kardinalitaets-Synthese Deep-Research wf_62fe0731, "nur Bestand"). m3v2-Profil: ${SUP}/Code/experiment_config/ bzw. m3v2_study.profile.xml.
BESTAND: ${CE}/libs/cache_engine/builder/curve_fit/curve_fit.hpp (CurvePoint/MeasurementCurve = 1 Achse x 1 x-Dimension, NUR Skeleton-Anfang; die verschachtelte tree/map-Struktur existiert NICHT). ${CE}/libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.hpp (die Mess-System-Achsen-Registry "Blut"). ${CE}/libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp + i_measurement_source.hpp.
GRENZEN (TABU): golden/permutation_axes.xml/POD sizeof==1416/GenusBindingTraits/ABI-MAJOR==4/Registry-mp_list UNBERUEHRT. Metaprogrammierung: compile-time-strikt (Templates/if constexpr/Concepts/CRTP), kein Runtime-Switch/vtable im Hot-Path; nur benannte Patterns (Visitor/Strategy/Builder/Decorator wie Doc 21 §A). Monolith-first. Selbst-Impl. Kardinalitaeten NICHT erfinden.`

const RSCHEMA = { type:'object', additionalProperties:false, required:['findings','open_questions'], properties:{
  findings:{type:'array',items:{type:'object',additionalProperties:false,required:['q','a','evidence'],properties:{q:{type:'string'},a:{type:'string'},evidence:{type:'string'}}}},
  open_questions:{type:'array',items:{type:'string'}}}}

phase('Research')
const research = await parallel([
  () => agent(`Du bist Typsystem-Struktur-Forscher. Lies Doc 20 §B (:17-40) + Doc 21 (Layer-/Haupt-Unter-Achsen-Modell, Visitor/Strategy/Builder/Decorator §A + die 7 Fork-Entscheidungen) + ${CE}/libs/cache_engine/builder/curve_fit/curve_fit.hpp + measurement_axis_registry.hpp.
BEANTWORTE (datei:zeile): (1) Was ist die tree<axis>-WURZEL konkret (die von den Map-Ebenen UNABHAENGIGE Struktur, die zuerst gebaut wird)? Ist es ein Layer-B+-Baum-Knoten je Achse (statisch=strikter Layer, dynamisch=Knoten darunter)? (2) Wie sieht der bestehende curve_fit.hpp-Skeleton aus und wie erweitert man ihn zur Wurzel (nicht ersetzen — Monolith/additiv)? (3) Wo docken die Mess-System-Achsen (measurement_axis_registry, "Blut") an die Wurzel an (Doc 20 §B:37-39)? (4) Welche der Doc-21-Patterns (Visitor/Strategy/Builder-ueber-State/Decorator) gehoeren in die WURZEL-Slice vs. in die spaeteren Map-Ebenen? (5) Was ist die kleinste eigenstaendig BUILDBARE + unit-testbare Wurzel-Slice (ohne Cluster-Daten)? ${IST}`,
    { label:'research:typsystem-struct', phase:'Research', schema:RSCHEMA, effort:'high' }),
  () => agent(`Du bist Kardinalitaets-Forscher. Ermittle die Kardinalitaeten je Typsystem-Ebene (framework/type/size/op/observer/property) AUS DEM BESTAND — NICHT erfinden. Lies Doc 20 §G (Kardinalitaets-Synthese, :78-108) + das m3v2-Profil (${SUP}/Code/experiment_config/*.xml bzw. m3v2_study.profile.xml, such nach workloads/datasets/op_types) + measurement_category.hpp + measurement_axis_registry.hpp.
BEANTWORTE (datei:zeile, KONKRETE Zahlen/Enums): (1) framework-Kardinalitaet (H1: 13 Frameworks?); (2) workload-type (YCSB A-F = 6?); (3) workload-size (Cache-Regime-Map-Key, H3?); (4) operation_type (Metric-Enum: insert/lookup/erase/scan/rmw = 6?); (5) axis_observer_type (die Mess-Achsen der Registry?); (6) property (observer_special_compare_property). Fuer JEDE: die Bestands-Quelle (Enum/XML/Registry) nennen; wenn eine Kardinalitaet NICHT im Bestand belegbar ist, das explizit als "under-specified / User-Fork" markieren (Doc 21 sagt die 7 Forks sind entschieden — pruefe welche Ebene wovon abhaengt). ${IST}`,
    { label:'research:cardinalities', phase:'Research', schema:RSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

phase('Design')
const DSCHEMA = { type:'object', additionalProperties:false, required:['recommendation','root_structure','cardinality_classes','patterns_used','change_surface','buildable_slice','boundary_compliance','risks'], properties:{
  recommendation:{type:'string'}, root_structure:{type:'string'}, cardinality_classes:{type:'string'}, patterns_used:{type:'string'},
  change_surface:{type:'array',items:{type:'string'}}, buildable_slice:{type:'string',description:'die kleinste eigenstaendige unit-testbare Slice'}, boundary_compliance:{type:'string'}, risks:{type:'array',items:{type:'string'}}}}
const design = await agent(`Design-Synthesizer. Aus der Research: das SAUBERSTE, thesis-treue (Doc 20 §B woertlich + Doc 21 Layer-Modell), boundary-konforme, compile-time-strikte Design fuer die tree<axis>-WURZEL-Slice des Messkurven-Typsystems. Kardinalitaeten NUR aus Bestand (m3v2/Registry), sonst als Fork markieren. Entscheide: Wurzel-Struktur (Layer-Knoten je Achse), Kardinalitaets-Klassen/Hierarchien, benannte Patterns (welche in der Wurzel), kleinste eigenstaendig unit-testbare Slice (additiv zu curve_fit.hpp, kein Ersatz), minimale Change-Surface (datei:zeile). Wenn die Wurzel selbst zu gross/fork-abhaengig ist: die kleinste FORK-FREIE Teil-Slice.
RESEARCH:\n${JSON.stringify(research,null,1)}\n${IST}`, { label:'design:synth', phase:'Design', schema:DSCHEMA, effort:'high' })

phase('Critique')
const CSCHEMA = { type:'object', additionalProperties:false, required:['verdict','issues'], properties:{
  verdict:{type:'string',enum:['SOUND','NEEDS-REVISION','TOO-RISKY']}, issues:{type:'array',items:{type:'object',additionalProperties:false,required:['severity','issue'],properties:{severity:{type:'string',enum:['blocker','major','minor']},issue:{type:'string'}}}}}}
const critiques = await parallel([
  () => agent(`ADVERSARIAL Thesis-Fidelity + Kardinalitaeten: Ist die Wurzel-Struktur WIRKLICH die Doc-20-§B-tree<axis>-Wurzel + Doc-21-Layer-Modell (nicht ein erfundenes Konstrukt)? Sind ALLE Kardinalitaeten aus dem Bestand belegt (m3v2/Registry) oder wurde etwas ERFUNDEN (TABU: Kardinalitaeten nicht erfinden)? Haengt die Wurzel-Slice heimlich von einem der 7 Forks / den Map-Ebenen ab (dann nicht fork-frei)? Sind die benannten Patterns korrekt zugeordnet? Jede Erfindung/Fork-Abhaengigkeit: blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:thesis', phase:'Critique', schema:CSCHEMA, effort:'high' }),
  () => agent(`ADVERSARIAL Boundary/Bau: golden/POD/mp_list/ABI beruehrt? compile-time-strikt (kein Runtime-Switch/vtable Hot-Path)? Change-Surface an realen datei:zeile (keine Phantom-Zeilen)? Kompiliert der Vorschlag (Typen/Concepts existieren)? Ist curve_fit.hpp ADDITIV erweitert (nicht ersetzt, Monolith)? Ist die Slice eigenstaendig unit-testbar OHNE Cluster-Daten? Bricht sie measurement_axis_registry-Consumer? Jede Verletzung: blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:boundary', phase:'Critique', schema:CSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

return { research, design, critiques }
