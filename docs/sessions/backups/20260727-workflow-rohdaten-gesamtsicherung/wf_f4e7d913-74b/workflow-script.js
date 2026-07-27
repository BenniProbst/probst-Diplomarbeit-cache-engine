export const meta = {
  name: 'load-task-topic-context',
  description: 'Lade thema-scharf alle Direktiven + Learnings + Umgebungsvariablen fuer den CE-Bau (Caching/Storage/variant-Bloat/Infra-Storage)',
  phases: [
    { title: 'Sammeln', detail: '3 parallele Sammler: Direktiven, Learnings, Env-Vars' },
    { title: 'Synthese', detail: 'Konsolidierter Themen-Kontext-Brief' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const MEM = '/home/comdare/.claude/projects/-home-comdare/memory'

const DIRECTIVES_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['directives'],
  properties: {
    directives: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['rule', 'source', 'why'],
        properties: {
          rule: { type: 'string', description: 'Die bindende Regel, knapp' },
          source: { type: 'string', description: 'Memory-Name oder Ledger-§ oder Plandoc' },
          why: { type: 'string', description: 'Warum sie den Bau steuert' },
        },
      },
    },
  },
}

const LEARNINGS_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['learnings'],
  properties: {
    learnings: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['learning', 'evidence', 'how_to_apply'],
        properties: {
          learning: { type: 'string' },
          evidence: { type: 'string', description: 'datei:zeile oder Commit oder Memory' },
          how_to_apply: { type: 'string' },
        },
      },
    },
  },
}

const ENV_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['env_vars', 'tooling_paths'],
  properties: {
    env_vars: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['name', 'purpose', 'where_read'],
        properties: {
          name: { type: 'string' },
          purpose: { type: 'string' },
          where_read: { type: 'string', description: 'datei:zeile' },
          note: { type: 'string' },
        },
      },
    },
    tooling_paths: {
      type: 'array',
      items: {
        type: 'object', additionalProperties: false,
        required: ['name', 'path'],
        properties: {
          name: { type: 'string' },
          path: { type: 'string' },
          note: { type: 'string' },
        },
      },
    },
  },
}

phase('Sammeln')

const [directives, learnings, env] = await parallel([
  () => agent(
    `Sammle ALLE bindenden DIREKTIVEN, die den Cache-Engine-Bau der Pakete Caching (inkrementeller Tier-Binary-Cache), Storage (minio/NFS), variant-Bloat-Behebung und Infra-Storage STEUERN. Quellen: (1) Memory-Files unter ${MEM} — besonders feedback_no_std_variant_static_axes_bloat, feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring, feedback_incremental_tier_binary_caching, feedback_system_axes_measurement_own_abstract_root_blood, feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen, feedback_recursive_dock_planer_ceb_tier_abi_stable_so, feedback_crtp_concept_guard_mix_pattern, feedback_no_runtime_switch, feedback_compile_time_only_no_runtime, feedback_metaprogrammierung_compile_time_zwingend_durchsetzen, feedback_no_python_in_buildchain, feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained, feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable, feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake, feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns, feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra, feedback_ci_infra_blocked_proceed_local_double_verify_mode_a, feedback_all_projects_dual_remote_github_gitlab, feedback_nie_rebase_immer_merge, feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus, feedback_no_success_marks_without_literal_output, feedback_increments_architekturkonform_nicht_nur_gruen. Lies MEMORY.md (Index) dort und dann die genannten Files. (2) Ledger ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md — §0-GOAL-V6, §18, §21, §22, §23, §24 (nutze grep/offset, die Datei ist ~2060 Zeilen). Gib jede Regel als {rule, source, why}. Fokus: compile-time-only/no-variant, Organ-vs-System-Trennung, binary_id-Doktrin (Version=Sidecar nie binary_id), CRTP+Concept/keine vtable, kein Python, sequentielles Cache-/Ergebnis-Schreiben nie parallel zur Messung, Cluster-read-only-Ausnahme (Infra-Modus fuer Caching/Storage jetzt erlaubt), dual-remote + nie-rebase, nie ✓ ohne literale Ausgabe, architekturkonform nicht nur gruen.`,
    { label: 'directives', phase: 'Sammeln', schema: DIRECTIVES_SCHEMA }
  ),
  () => agent(
    `Sammle ALLE wichtigen LEARNINGS/Fallen fuer den Cache-Engine-Bau + dessen Verifikation. Quellen: Memory-Files unter ${MEM} (reference_cache_engine_standalone_build_pipeline, reference_ce_facade_super_subbuild_verify_and_clang_format_prod1_gap, reference_codex_utf8_mojibake_double_encoding, reference_ce_build_dir_has_tracked_measurement_csv, reference_tier_metaphor_system_axis_properties_verified_complete, reference_cluster_vlan_tabelle_sni_standard_pattern) + Ledger §22 (INC-2d: 3 echte Regressionen durch STALE BINARIES, Force-Recompile deckte sie auf; POD sizeof 1344->1272, ABI-Major 5->6, 17 Achsen, golden bleibt 320) + §23/§24 im Ledger ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md. Verifiziere die ABI-Fakten im Code ${CE}: grep nach kV3AxisCount, sizeof-Asserts, ABI_MAJOR, golden 320 vs 131072 (source_catalog.hpp, anatomy_module_abi_v1_decl.hpp, permutation_engine.hpp). Wichtigste Learnings die ich brauche: (a) ninja/ctest STALE-BINARY-Falle -> IMMER 'find tests apps tools -name "*.cpp" | xargs touch' vor ctest, sonst falsches Gruen; (b) exakte Standalone-Build-Reihenfolge/Presets (build-conf g++, build-i2 clang) — finde CMakePresets.json; (c) cf22 = clang-format 22.1.8 unter ~/tools/cf22/usr/bin, dry-run==0; (d) Mojibake-praeziser-Byte-Pattern fuer deutsche Doku vs Code; (e) golden-Roundtrip==320 muss halten; (f) POD/ABI-Fakten. Gib jedes als {learning, evidence(datei:zeile/Commit), how_to_apply}.`,
    { label: 'learnings', phase: 'Sammeln', schema: LEARNINGS_SCHEMA }
  ),
  () => agent(
    `Enumeriere ALLE UMGEBUNGSVARIABLEN die der Bau-/Mess-Pfad der Cache-Engine liest, plus die Tooling-Pfade. Grep im ce-Repo ${CE}: 'grep -rn "getenv\\|COMDARE_" libs/ apps/ tools/ 2>/dev/null' und im super-Repo ${SUPER}/Code (besonders 02_messung_driver/main.cpp, from_env). Suche insbesondere: COMDARE_MEASUREMENT_MODE, COMDARE_PERSIST_MEASUREMENTS, COMDARE_CACHE_ROOT, COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX, COMDARE_MEASUREMENT_NFS_ROOT, output_dir-relevante Vars, USE_SNMALLOC, und alle weiteren COMDARE_*. Fuer jede: {name, purpose, where_read(datei:zeile), note(Default/inert-bis-gesetzt)}. Tooling-Pfade (tooling_paths): cf22 clang-format (~/tools/cf22/usr/bin), GitLab-CA (/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt), CMakePresets-Namen (build-conf/build-i2), MinIO-CI-Var-NAMEN (MINIO_ACCESS_KEY/MINIO_SECRET_KEY — nur NAMEN, NIE Werte/Secrets), NFS-Mount-Konvention. WICHTIG: gib NIEMALS Secret-Werte aus, nur Variablen-NAMEN.`,
    { label: 'env-vars', phase: 'Sammeln', schema: ENV_SCHEMA }
  ),
])

phase('Synthese')

const brief = await agent(
  `Konsolidiere die drei Sammlungen zu EINEM knappen, hoch-informationsdichten Themen-Kontext-Brief (Markdown) fuer den Cache-Engine-Bau (Caching/Storage/variant-Bloat/Infra-Storage). Struktur: (1) BINDENDE DIREKTIVEN (gruppiert: Metaprog/Achsen, Provenienz/binary_id, Sequentialitaet/Messung, Infra/Remotes, Prozess/Verifikation) — je 1 Zeile; (2) KRITISCHE LEARNINGS (die Fallen, besonders Stale-Binary/Force-Recompile, ABI-Fakten, cf22, Mojibake, Presets) — je 1 Zeile mit Beleg; (3) UMGEBUNGSVARIABLEN + TOOLING-PFADE (Tabelle name→zweck→wo, Secrets nur als Namen); (4) 3-5 KONKRETE ANWEISUNGEN fuer die naechsten Bau-/Verifikationsschritte, die aus (1)-(3) folgen. Keine Fuellsaetze. Das ist der Kontext, den der Hauptagent behaelt.\n\n=== DIREKTIVEN ===\n${JSON.stringify(directives)}\n\n=== LEARNINGS ===\n${JSON.stringify(learnings)}\n\n=== ENV ===\n${JSON.stringify(env)}`,
  { label: 'synthese', phase: 'Synthese' }
)

return { brief, directive_count: (directives?.directives||[]).length, learning_count: (learnings?.learnings||[]).length, env_count: (env?.env_vars||[]).length }
