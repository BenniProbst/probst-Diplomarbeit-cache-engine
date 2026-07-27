export const meta = {
  name: 'phase03b-tier-level-threading-design',
  description: 'Deep-Research: 0.3b Tier-Level axis_06-Threading (permutierter Allocator -> Pool-Stores) + nested-Container-Loesung, golden-safe',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Critique' }],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const IST = `IST-VERIFIKATION (belegt, Basis — nutzen/verifizieren):
ZIEL 0.3b: die PERMUTIERTE Allocator-Achse (Composition::allocator = axis_06-Slot je der 320 Binaries) REAL in die Pool-Stores faedeln, sodass T6 je Binary den GEWAEHLTEN Allocator reflektiert (Cross-Allocator-DIFFERENZIERUNG = der Research-Payoff). Heute: Pool-Stores nutzen den DEFAULT (ExgenAllocator, 0.3a) — keine Differenzierung.
STAND 0.3a (fertig, CI-gruen): BST/btree/surf Pool-Stores besitzen eine axis_06-Strategie (Default ExgenAllocator), COW-safe via Memento (Copy/Assign restore_statistics). Muster in ${CE}/libs/cache_engine/axes/lookup/composable/tree_node_pool_store.hpp.
NAHT: ${CE}/libs/cache_engine/axes/lookup/composable/organ_for_search_algo.hpp — Trait organ_for_search_algo<S> (13 Spezialisierungen, :62-116) mappt jeden SearchAlgo auf ein Composed*Search<Traversal, *PoolStore<...>>-Organ mit dem Pool-Store (heute Default-Alloc). abi_adapter.hpp parametrisiert container_t = ObservableComposedContainer<organ_for_search_algo_t<SearchAlgo,...>> (abi_adapter :169 shaped-Naht). Die Anatomie HAT Composition::allocator verfuegbar (abi_adapter :276/:285 nutzt family_id/ObservableAxis).
NESTED-CONTAINER-PROBLEM (Skalierungsgrenze Option A, DOSSIER §3d): skip_list-Knoten SkipListNodePoolNode<FwdAlloc> enthaelt SELBST std::vector<size_t,FwdAlloc>; wormhole hat Map; art/hash 8-10 Vektoren. Der stateful StdAllocatorAdapter (haelt &allocator_) komponiert NICHT mit knoten-eigenen default-konstruierten Containern.
binary_id-QUELLE: axis_path_serialization.hpp — binary_id = "search_algo=<name>/.../allocator=<name>/.../queuing_q2=<name>" aus Achsen-::name() (NICHT mangled type). golden_fullpilot_320 verifiziert via test_profile_roundtrip.
GRENZEN (TABU): golden_fullpilot_320_binary_ids.txt / permutation_axes.xml / POD sizeof==1416 / GenusBindingTraits / ABI-MAJOR==4 / Registry-mp_list UNBERUEHRT. compile-time-strikt, kein Runtime-Switch/vtable Hot-Path. Nur benannte Patterns. Selbst-Impl.`

const RSCHEMA = { type:'object', additionalProperties:false, required:['findings','open_questions'], properties:{
  findings:{type:'array',items:{type:'object',additionalProperties:false,required:['q','a','evidence'],properties:{q:{type:'string'},a:{type:'string'},evidence:{type:'string'}}}},
  open_questions:{type:'array',items:{type:'string'}}}}

phase('Research')
const research = await parallel([
  () => agent(`Du bist Threading-Forscher. Lies ${CE}/libs/cache_engine/axes/lookup/composable/organ_for_search_algo.hpp (+ organ_for_search_algo_shaped.hpp) + ${CE}/libs/cache_engine/anatomy/abi_adapter.hpp (wo container_algorithm_t / organ_for_search_algo_t / container_t instanziiert wird, ~:169-180 + wo Composition::allocator sichtbar ist).
BEANTWORTE (datei:zeile): (1) Wie wird organ_for_search_algo_t heute mit dem SearchAlgo instanziiert und wo genau koennte Composition::allocator als 2. Param durchgereicht werden (additiv, defaulted)? (2) Erfordert das Aendern der 13 organ_for_search_algo-Spezialisierungen (Signatur S -> S,Alloc)? Welche sind Pool-basiert (nehmen Alloc) vs. Wrapper (ignorieren Alloc)? (3) Ist die Aenderung ABI-/container_algorithm_t-neutral (Struct-Layout/binary_id) oder aendert sie die mangled-Typ-Identitaet? Aendert das binary_id (Achsen-::name())? (4) Bleiben die 0.3a-Stores (BST/btree/surf) quellkompatibel wenn Alloc jetzt Composition::allocator statt Default ist? ${IST}`,
    { label:'research:threading', phase:'Research', schema:RSCHEMA, effort:'high' }),
  () => agent(`Du bist Nested-Container-Forscher. Analysiere ob Tier-Level-/externe-Strategie-Threading die nested-Container-Stores loest ODER ob eine STATELESS-Allocator-Variante noetig ist.
Lies ${CE}/libs/cache_engine/axes/lookup/composable/skip_list_node_pool_store.hpp (Knoten mit eigenem std::vector), wormhole_leaf_list_pool_store.hpp (Map), + ${CE}/libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp (StdAllocatorAdapter haelt Derived*; ist der Adapter oder die Strategie stateless machbar?).
BEANTWORTE: (1) Kann ein knoten-eigener std::vector<T,Adapter> die stateful-Adapter-Instanz halten, wenn der Knoten per push_back default-konstruiert wird (Adapter nicht default-konstruierbar)? Was waere noetig? (2) Loest Tier-Level (Anatomie besitzt EINE Strategie, per Zeiger in Store+Knoten gefaedelt) das, oder bleibt das Knoten-Default-Konstruktions-Problem? (3) Gibt es eine STATELESS-Adapter-Variante (Stats via shared_ptr/externem Sink statt &allocator_-Member), die mit nested-Containern UND COW komponiert? Trade-offs? (4) Ist es sauberer, die nested-Container-Stores (skip_list/wormhole/art) VORERST beim Default-Exgen (0.3a-Style, keine Differenzierung) zu belassen und nur die 2-Vektor-Stores zu differenzieren? ${IST}`,
    { label:'research:nested', phase:'Research', schema:RSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

phase('Design')
const DSCHEMA = { type:'object', additionalProperties:false, required:['recommendation','mechanism','scope','change_surface','golden_safety','nested_container_handling','risks'], properties:{
  recommendation:{type:'string'}, mechanism:{type:'string'}, scope:{type:'string',description:'welche Stores in 0.3b differenziert, welche deferred'},
  change_surface:{type:'array',items:{type:'string'}}, golden_safety:{type:'string'}, nested_container_handling:{type:'string'}, risks:{type:'array',items:{type:'string'}}}}
const design = await agent(`Design-Synthesizer. Aus der Research: das SAUBERSTE, golden-safe, compile-time-strikte Design fuer 0.3b (permutierte axis_06 in die Pool-Stores faedeln fuer Cross-Allocator-Differenzierung). Entscheide: (a) Mechanismus (organ_for_search_algo<S,Alloc=default> + Anatomie reicht Composition::allocator; ODER anderer), (b) Scope (welche Stores jetzt differenziert vs. nested-Container deferred/anders), (c) nested-Container-Behandlung, (d) golden-320-Neutralitaet, (e) konkrete minimale Change-Surface (datei:zeile). Wenn 0.3b zu gross/riskant fuer einen Increment: schlage die kleinste sinnvolle Teil-Strecke vor.
RESEARCH:\n${JSON.stringify(research,null,1)}\n${IST}`, { label:'design:synth', phase:'Design', schema:DSCHEMA, effort:'high' })

phase('Critique')
const CSCHEMA = { type:'object', additionalProperties:false, required:['verdict','issues'], properties:{
  verdict:{type:'string',enum:['SOUND','NEEDS-REVISION','TOO-RISKY']}, issues:{type:'array',items:{type:'object',additionalProperties:false,required:['severity','issue'],properties:{severity:{type:'string',enum:['blocker','major','minor']},issue:{type:'string'}}}}}}
const critiques = await parallel([
  () => agent(`ADVERSARIAL: golden/ABI/Boundary. Aendert der Vorschlag binary_ids (golden_fullpilot_320)? mangled-Typ von container_algorithm_t aendert sich — aber binary_id kommt aus Achsen-::name(): stimmt das noch? POD sizeof==1416/GenusBindingTraits/permutation_axes/mp_list beruehrt? Bricht die organ_for_search_algo-Signaturaenderung bestehende Consumer? compile-time-strikt? Jede Verletzung: blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:golden', phase:'Critique', schema:CSCHEMA, effort:'high' }),
  () => agent(`ADVERSARIAL: Korrektheit + nested-Container. Loest der Vorschlag das skip_list-Knoten-eigene-vector-Problem WIRKLICH (kompiliert der Knoten mit dem gefaedelten Allocator)? Bleibt COW-safe (die 0.3a-Memento-Logik)? Ist die T6-Differenzierung tatsaechlich erreicht (verschiedene Allocatoren -> verschiedene T6)? Ist die deferred-Scope-Grenze ehrlich (was differenziert NICHT)? Jede Luecke: major/blocker. VORSCHLAG:\n${JSON.stringify(design,null,1)}\n${IST}`,
    { label:'critique:correctness', phase:'Critique', schema:CSCHEMA, effort:'high' }),
]).then(r=>r.filter(Boolean))

return { research, design, critiques }
