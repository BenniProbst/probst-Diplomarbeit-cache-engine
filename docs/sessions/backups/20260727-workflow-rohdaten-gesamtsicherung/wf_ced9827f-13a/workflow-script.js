export const meta = {
  name: 'phase03-cow-safe-allocator-design',
  description: 'Deep-Research: COW-safe strategie-getriebener Pool-Store (Hebel B) im Zwei-Phasen-Mess-Protokoll, innerhalb der Grenzen',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Critique' }],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const IST = `IST-VERIFIKATION (belegt, Basis — NICHT neu herleiten, nur nutzen/verifizieren):
ZIEL (Hebel B, Phase 0.3): die Allocator-Achse (axis_06) treibt REAL die Pool-Store-Allokation, und T6 reflektiert die GEWAEHLTE Strategie
(rich 5-Feld AllocationStatistics: total_bytes_allocated/total_bytes_in_use/allocation_count/deallocation_count/failure_count) statt der
heutigen allocator-unabhaengigen Store-eigenen Vektor-Kapazitaets-Zaehlung. Adapter: ${CE}/libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp
StdAllocatorAdapter<T> (stateful, haelt Derived*) + as_std_allocator<T>() + statistics()->snapshot_t. Default-Strategie ExgenAllocator (real=std bei disabled).
COW-/ZWEI-PHASEN-PROTOKOLL (${CE}/libs/cache_engine/anatomy/abi_adapter.hpp): host-seitiger Treiber save_all -> op(warmup) -> rollback_all -> op(measure) (:1680).
 - tier_save_all (:1730-1746): if constexpr(cow_capable_){ saved_container_algorithm_stats_=stats; ...; cow_armed_=true; } ; cow_materialize_copy_ EINMAL je Warmup-Periode VOR Mutation.
 - cow_materialize_copy_ (:2173): saved_container_algorithm_.emplace(container_algorithm_)  [NICHT if-constexpr-guarded -> Store MUSS copy-konstruierbar sein, compile-time].
 - tier_rollback_all (:1749-1759): if(cow_materialized_) container_algorithm_ = *saved_container_algorithm_ (copy-ASSIGN zurueck).
 - cow_capable_ (:2154-2157) = organ_cow_capable_v<container_algorithm_t> (hat restore_statistics(statistics())) && is_copy_constructible_v && is_copy_assignable_v.
 - ObservableComposedContainer (${CE}/libs/cache_engine/axes/lookup/composable/observable_composed_container.hpp): statistics()->stats_ (Observer-POD) :125; restore_statistics(snap){stats_=snap} :130; store_allocator_statistics()-> container_.store_allocator_statistics() :117-120.
AKTUELLER STORE (tree_node_pool_store.hpp): A=std::allocator (rebind), Stats sind PLAIN uint64-MEMBER (alloc_calls_/bytes_allocated_/live_nodes_) via record_capacity_growth_ -> by-value kopiert bei COW -> KEINE Pollution. store_allocator_statistics()->{alloc_calls,bytes_allocated,live_nodes}.
abi_adapter T6-Route (:285-299 / :1149-1160): liest store_allocator_statistics(); BEVORZUGT den Zweig mit total_bytes_allocated/total_bytes_in_use/allocation_count/deallocation_count/failure_count (== axis_06-Snapshot) -> r[0..4]; sonst Fallback (a.bytes_allocated).
GESCHEITERTER 0.3a-VERSUCH (revertiert): Store BESITZT Strategie, Vektoren via self-referential Adapter, Copy/Move GELOESCHT -> Bau bricht (cow_materialize_copy_ braucht Copy). Naiver rebindender Copy-Ctor -> COW-Kopie ALLOKIERT erneut ueber die Strategie -> Stats-DOPPELZAEHLUNG/Pollution.
GRENZEN (Ledger §0 / TABU): golden_fullpilot_320_binary_ids.txt / permutation_axes.xml / POD sizeof==1416 (ComdareTierObserverSnapshot) / GenusBindingTraits / ABI-MAJOR==4 / Registry-mp_list UNBERUEHRT. compile-time-strikt, kein Runtime-Switch/vtable im Hot-Path. Nur benannte Design-Patterns (Memento etc.). Selbst-Implementierung.`

const RESEARCH_SCHEMA = {
  type: 'object', additionalProperties: false, required: ['findings', 'open_questions'],
  properties: {
    findings: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['q', 'a', 'evidence'],
      properties: { q: { type: 'string' }, a: { type: 'string' }, evidence: { type: 'string' } } } },
    open_questions: { type: 'array', items: { type: 'string' } },
  },
}

phase('Research')
const research = await parallel([
  () => agent(`Du bist COW-Protokoll-Forscher. Lies ${CE}/libs/cache_engine/anatomy/abi_adapter.hpp (COW/Zwei-Phasen: tier_save_all/tier_rollback_all/cow_materialize_copy_/tier_insert/tier_erase, ~1680-2180 + 828-980) + observable_composed_container.hpp + composed_tree_search.hpp.
BEANTWORTE mit datei:zeile: (1) Wird T6 (Allocator-Stats) als ABSOLUT-Wert oder als DELTA (vor/nach Mess-Op) berichtet? Wo genau wird store_allocator_statistics() in den Snapshot gelesen, und passiert das nach rollback_all + measure-op?
(2) Werden die Allocator-Stats beim rollback (container_algorithm_=*saved) mit-zurueckgesetzt, oder separat via restore_statistics (das nur den OBSERVER-POD stats_ betrifft)?
(3) Wenn ein strategie-besitzender Store bei COW-Kopie erneut allokiert (Strategie-Stats-Pollution): pflanzt sich diese Pollution in den GEMESSENEN T6-Wert fort, oder wird sie durch rollback/Reset/Delta neutralisiert? Trace den exakten Pfad.
(4) Genuegt fuer cow_capable_ eine korrekte Copy/Assign + das bestehende restore_statistics (Observer-POD), oder braucht die Allocator-Stats einen EIGENEN Save/Restore-Kanal? ${IST}`,
    { label: 'research:cow-protocol', phase: 'Research', schema: RESEARCH_SCHEMA, effort: 'high' }),
  () => agent(`Du bist Design-Space-Forscher. Gegeben die Grenzen (Store MUSS copy-konstruierbar+assignable sein; Stats muessen COW-korrekt sein wie die heutigen plain-member; kein golden/ABI/POD/mp_list-Touch; compile-time-strikt; benannte Patterns), enumeriere die VIABLEN COW-safe Designs fuer einen strategie-getriebenen Pool-Store und bewerte sie:
(A) Store besitzt Strategie + korrekter Copy-Ctor, der nach dem Allokieren die Quell-Stats via neuem strategy.restore_statistics() wiederherstellt (Pollution verwerfen). Wo lebt stats_ (Base vs je-Strategie)? Wie viel Surface fuer restore_statistics (nur Base? 17 Strategien)?
(B) Store besitzt Strategie fuer die ECHTE Allokation, haelt aber die T6-Stats als PLAIN-MEMBER-Snapshot (by-value kopiert), aktualisiert nach jeder Op via allocator_.statistics(); Problem: Measure-Op liest die rollback-polluted Live-Strategie -> loest das die Pollution wirklich? 
(C) Tier-Level: Anatomie besitzt EINE Strategie, in die Pool-Vektoren via Adapter auf EXTERNE Strategie gefaedelt; Ctor-Threading durch ComposedTreeSearch. Wie COW-kopieren (Adapter zeigt auf shared external)? Surface/ABI-Naehe?
Lies dazu ${CE}/libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp (wo lebt stats_? gibt es reset()/restore?) + axis_06_allocator_exgen.hpp + ${CE}/libs/cache_engine/axes/node/axis_04_node_type_composed_store.hpp (Praezedenz). Nenne die konkrete minimale Change-Surface je Option. ${IST}`,
    { label: 'research:design-space', phase: 'Research', schema: RESEARCH_SCHEMA, effort: 'high' }),
]).then(r => r.filter(Boolean))

phase('Design')
const DESIGN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['chosen_option', 'rationale', 'change_surface', 'cow_correctness', 'boundary_compliance', 'risks'],
  properties: {
    chosen_option: { type: 'string' },
    rationale: { type: 'string' },
    change_surface: { type: 'array', items: { type: 'string', description: 'datei:zeile -> Aenderung' } },
    cow_correctness: { type: 'string', description: 'Warum T6 durch COW korrekt bleibt (kein Pollution im gemessenen Wert)' },
    boundary_compliance: { type: 'string', description: 'golden/ABI/POD/mp_list unberuehrt; compile-time-strikt; Pattern-Name' },
    risks: { type: 'array', items: { type: 'string' } },
  },
}
const design = await agent(`Du bist der Design-Synthesizer. Aus den Research-Ergebnissen (unten) waehle das SAUBERSTE COW-safe Design fuer den strategie-getriebenen Pool-Store (Hebel B, Phase 0.3), das (a) T6 die axis_06-Strategie reflektiert, (b) COW-korrekt ist (kein Pollution im GEMESSENEN Wert), (c) golden/ABI/POD/mp_list unberuehrt laesst, (d) compile-time-strikt ist, (e) ein benanntes Pattern nutzt. Gib die KONKRETE minimale Change-Surface (datei:zeile) fuer den BST-Store (TreeNodePoolStore) als Pattern-beweisenden ersten Slice + s7_1-Contract-Update.
RESEARCH:
${JSON.stringify(research, null, 1)}
${IST}`, { label: 'design:synth', phase: 'Design', schema: DESIGN_SCHEMA, effort: 'high' })

phase('Critique')
const CRIT_SCHEMA = {
  type: 'object', additionalProperties: false, required: ['verdict', 'issues'],
  properties: {
    verdict: { type: 'string', enum: ['SOUND', 'NEEDS-REVISION', 'UNSAFE'] },
    issues: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['severity', 'issue'],
      properties: { severity: { type: 'string', enum: ['blocker', 'major', 'minor'] }, issue: { type: 'string' } } } },
  },
}
const critiques = await parallel([
  () => agent(`ADVERSARIAL: Prüfe die MESS-KORREKTHEIT des Designs. Trace den Zwei-Phasen-Pfad (save->warmup->rollback->measure) mit dem vorgeschlagenen Store konkret durch: Bleibt der GEMESSENE T6-Wert nach measure-op frei von COW-Kopie-Pollution? Kann eine COW-Kopie/Assign die Strategie-Stats verfaelschen, die dann gemessen werden? Ist read-Perioden-O(1) erhalten? Wenn T6 verfaelscht werden KANN: blocker. VORSCHLAG:\n${JSON.stringify(design, null, 1)}\n${IST}`,
    { label: 'critique:measurement', phase: 'Critique', schema: CRIT_SCHEMA, effort: 'high' }),
  () => agent(`ADVERSARIAL: Prüfe BOUNDARY/ABI/COMPILE. Berührt der Vorschlag golden/permutation_axes/POD sizeof==1416/GenusBindingTraits/ABI-MAJOR==4/Registry-mp_list? Ist der Store copy-konstruierbar UND copy-assignable (cow_capable_-Bedingung)? Compile-time-strikt (kein Runtime-Switch/vtable Hot-Path)? Ist die Change-Surface an den realen datei:zeile korrekt (keine Phantom-Zeilen)? Bricht die Strategie-Surface (restore_statistics) andere Consumer? Jede Verletzung: blocker. VORSCHLAG:\n${JSON.stringify(design, null, 1)}\n${IST}`,
    { label: 'critique:boundary', phase: 'Critique', schema: CRIT_SCHEMA, effort: 'high' }),
]).then(r => r.filter(Boolean))

return { research, design, critiques }
