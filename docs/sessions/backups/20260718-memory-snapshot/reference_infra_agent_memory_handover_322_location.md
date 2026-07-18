---
name: reference_infra_agent_memory_handover_322_location
description: "Cross-Account-Handover der 322 Infra-Agent-Memories (cwd C--WINDOWS-system32) liegt konsolidiert+redigiert im Cluster-Repo docs/agent-memories-infra/INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md (+README). Nachschlagbar; NICHT en bloc in meinen Impl-Store kopiert (Rolle=Cluster-read-only). 10 Diplomarbeit-relevante Striktheits-Direktiven wurden konsolidiert übernommen; Produkt-/Infra-Direktiven abgegrenzt."
metadata:
  node_type: memory
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Ort (read-only):** GitLab `comdare/cluster/comdare-cluster-development` (origin/main), Dateien `docs/agent-memories-infra/INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md` (14542 Z., alle 322 Memory-Bodies je `===== FILE: <name> =====`) + `README.md` (Restore-Rezept). Commit `a616eb0` (2026-07-08). Secrets **redigiert** (`{{REDACTED*}}`); Klartext nur im gitignored `keys/`-Vault.

**Was ist es:** Vollständige Sicherung ALLER Infra-Agent-Memories (cwd `C--WINDOWS-system32`, Windows-Infra-Abteilung), übergeben für Cross-Account-Weiterarbeit. 264 der 322 fehlten in meinem Impl-Store; davon ~180 reine Infra (VLAN/CARP/OPNsense/Samba-AD/DNS/WireGuard/FortiGate/etcd/Talos/k8s/NAS/PAT-Rotation/Runner-Admin) + ~60 ce-Architektur (bereits im ce-Repo dokumentiert) + ~20 Cross-Cutting-Direktiven.

**Übernommen (konsolidiert 2026-07-08, Goal-V3-Striktheit Organisationsform/Modulreferenzierung/Metaprogrammierung):** [[feedback_no_runtime_switch]] · [[feedback_compile_time_only_no_runtime]] · [[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]] · [[reference_meta_driven_concept_hardening_pattern]] · [[feedback_crtp_concept_guard_mix_pattern]] · [[feedback_no_whole_tier_axes_genus_configurator]] (inkl. all_axes_driven_and_timed) · [[feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained]] · [[feedback_no_python_in_buildchain]] · [[feedback_build_matrix_8_docker_distros_full_platform_doctrine]] · [[feedback_ext_paper_organisation_separates_axes_from_paper_code]].

**Bewusst NICHT übernommen (Geltungsbereich ≠ Diplomarbeit — würde Widerspruch schaffen):**
- `feedback_buildsystem_not_cmake` / `feedback_no_git_submodules` → gelten für comdare-**Produkte/Baugruppen** (buildsystem.xml-Auflösung, cd-buildsystem). Meine **Diplomarbeit** nutzt CMake/ctest als offiziellen Dev-Weg ([[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]]) und Git-Submodule für die 4-Repo-Struktur (super→ce/prt-art/thesis). Abgegrenzt via [[feedback_comdare_products_house_buildsystem_mandatory]] + [[feedback_baseline_system_in_stein_gemeisselt_layering]] (B: „CMake nur Dev-Unterbau").
- ~180 reine Infra-Memories → nicht meine Domäne ([[feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra]]); bei Bedarf hier nachschlagen, nicht kopieren.
- ~60 ce-Architektur-Memories (anatomie_gattungen, achsen_algorithmus_paper_code_map, tier_aufloesung …) → Inhalt ist im ce-Repo dokumentiert/Code; kein Memory-Duplikat.

**Nutzung:** Bei einer konkreten Frage zu einer Infra-/Architektur-Direktive der anderen Abteilung → gezielt den `===== FILE: <name> =====`-Block in der Handover-Datei lesen (read-only via `git show origin/main:docs/agent-memories-infra/...`). Verwandt: [[feedback_all_projects_dual_remote_github_gitlab]], [[project_bep_abt_session_stand_20260705]].
