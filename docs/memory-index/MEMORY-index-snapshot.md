<!-- SICHERUNG DES MEMORY-INDEX -- Stand 09.08.2026 -->
<!--
  Dies ist eine SICHERUNGSKOPIE des Agenten-Gedaechtnis-Index, der ausserhalb dieses Repos
  unter ~/.claude/projects/-home-comdare/memory/MEMORY.md lebt und dort NICHT versioniert ist.

  WARUM ER HIER LIEGT: Das Projekt ist gross; der Index ist die einzige Landkarte ueber
  266 Gedaechtnis-Dateien. Geht er verloren, sind die Dateien zwar noch da, aber niemand
  findet sie mehr -- am 09.08. waren bereits acht Dateien vom Index aus unerreichbar
  (0 Eintraege, 0 Wikilinks) und damit faktisch tot.

  WAS ER IST: eine Zeile je Gedaechtnis-Datei, Verweis plus Haken. KEIN Inhalt -- der steht
  in den verlinkten Dateien. Die Verweise zeigen auf Dateinamen im memory-Verzeichnis, nicht
  auf Pfade in diesem Repo; sie sind hier absichtlich nicht klickbar.

  WARTUNG: Der Index laeuft gegen ein Leselimit (24,4 KB) und wird deshalb periodisch
  gekuerzt. Vor JEDER Kuerzung gehoert eine frische Sicherung hierher -- Owner-Anweisung
  09.08.2026: "Bitte sichere den index vor dem kuerzen" / "Das Projekt ist riesig und
  braucht den Index, wenigstens als backup".

  Enthaelt KEINE Geheimnisse: die Treffer auf "token"/"glpat" sind Dateinamen und
  Link-Beschriftungen, keine Werte (geprueft 09.08.2026).
-->

# MEMORY-Index

## ⭐ ZIEL
- **[GOAL v8 + TDD-Vertrag](reference_goal_v8_und_tdd_vertrag.md) — bis 15.09. · 5 Prüfungen · T-1…T-9 · vier bindende Dokumente**

## Prozess-Kanon
- **[NACH COMPACT NEU GRÜNDEN](feedback_nach_jedem_compact_sofort_neugruenden_und_memory_lesen.md) — Summary trägt den Verlauf, nicht die Regeln**
- **[GOAL lesen genügt NICHT](feedback_goal_lesen_genuegt_nicht_arbeitsweise_ist_ein_eigenes_dokument.md) — A1 Modell je Phase · A2 Dual-Review VOR der Landung · A2.0 Gedächtnis-Befund**
- **[WORKTREE-LEBENSZYKLUS](feedback_worktree_lebenszyklus_loeschen_erst_nach_gruen_und_merge.md) — löschen erst wenn GRÜN **und** gemergt**
- **[AGENT WARTET NIE AUF CI](feedback_agent_wartet_nie_auf_ci_das_gehoert_in_einen_monitor.md) — Monitor; Stränge über `agent-*.jsonl -mmin`**
- Wahrheit: [Nie raten](feedback_never_guess_always_lookup_state_of_art_and_docs.md) · [Ist live](feedback_goal_hook_thorough_read_in_never_guess.md) · [Kein ✓](feedback_no_success_marks_without_literal_output.md) · [Annahmen](feedback_thorough_assumptions_workflow_planning.md)
- Weg: [Quick-Fixes](feedback_no_quick_fixes.md) · [CMake/ctest](feedback_immer_schwerer_offizieller_weg_keine_behelfswege.md) · [Sauberste](feedback_infra_cleanest_not_easiest.md) · [NUR 1 XML](feedback_only_one_official_xml_driven_program_no_behelfswege.md)
- ultracode: [Unklar](feedback_ultracode_workflow_for_uncertainty_and_absolute_claims.md) · [»Fertig?«](feedback_goal_scheint_erledigt_ultracode_verifikation.md) · [Analyse-BU](feedback_consult_analysis_backups_via_ultracode_before_decisions.md) · [Themen](feedback_ledger_komplett_plus_ultracode_richtung_vor_abschnitten.md)
- Ledger: [Erst lesen](feedback_immer_ledger_zuerst_lesen_vor_handeln.md) · [TODO](feedback_before_each_todo_agent_reads_full_ledger_then_manual_details.md) · [Offen→Doku](feedback_open_decision_first_reread_ledger_and_plandocs.md) · [Entschieden](feedback_fehlende_entscheidung_erst_explore_alles_ist_entschieden.md) · [Projektstr.](feedback_vor_aufgaben_erst_projektstruktur_analyse.md)
- **[VERDECKTE exit-ZWEIGE](feedback_verdeckte_exit_zweige_sind_nicht_beobachtbar_mutant_bleibt_gruen.md)** · **[ABSCHRIFT schlägt LÖSCHUNG](feedback_abschrift_statt_aufruf_loeschung_bricht_nur_bei_aufrufern.md)** · [Deploy Key](feedback_deploy_key_nur_privates_ci_template_nie_in_public_repos.md)
- **[EIN SCHREIBER JE WORKTREE](feedback_ein_schreiber_je_worktree_git_commit_nimmt_die_ganze_staging_area.md) — `git commit` nimmt die GANZE Staging-Area**
- Git: [Nie rebase](feedback_nie_rebase_immer_merge.md) · [Gitflow](feedback_gitflow_branch_doktrin_main_authoritaet_development_voraus.md) · [Dual-Remote](feedback_all_projects_dual_remote_github_gitlab.md) · [GitHub flach](feedback_github_flache_out_of_house_sicherung_fokus_gitlab.md) · [Push→grün](feedback_verify_gitlab_pipeline_green_after_push.md) · [Löschung=GO](feedback_remote_deletion_requires_explicit_user_authorization.md) · [4 Klone](feedback_diplomarbeit_4_projects_local_clones_keep_in_sync.md)
- Daten/Doku: [Messdaten bleiben](feedback_messdaten_nie_loeschen_abi_darf_brechen.md) · [Doku deprecaten](feedback_never_delete_documentation.md) · [Backups additiv](feedback_raw_data_backups_additive_never_delete.md) · [Backup=Rohdaten](feedback_backups_only_workflow_rawdata_never_sessions_plans.md) · [rm build: CSV](reference_ce_build_dir_has_tracked_measurement_csv.md)
- Betrieb: [Tasks=TODO](feedback_tasks_list_is_user_visible_todo_keep_current.md) · [286 nie pollen](feedback_prod_ci_measurement_multiday_experiment.md) · [Blick](feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat.md) · [Shells beenden](feedback_goal_driven_autonomie_shells_monitore_beenden.md) · [Kein AskUser](feedback_never_use_askuserquestion_crashes_session.md) · [Transkripte tabu](reference_session_transkripte_enthalten_live_tokens_nie_committen.md)
- Sessions: [Wiederanl.](feedback_wiederanlauf_doktrin_nach_session_abriss.md) · [rückwärts=5](feedback_sessions_read_newest_first_both_repos.md) · [Handover](reference_diplomarbeit_impl_session_handover_location.md) · [Docs+Technik](feedback_doku_policy_neue_session_docs_ledger_nur_user_technik.md) · [Neugründ.-WF](reference_kontext_neugruendung_workflow_backup_ort.md)

## Architektur-Kanon
- CT: [Stat. Dispatch](feedback_no_runtime_switch.md) · [Pre-Build-Codegen](feedback_compile_time_only_no_runtime.md) · [CRTP+Concept](feedback_crtp_concept_guard_mix_pattern.md) · [Nur GoF](feedback_lehrbuch_design_patterns_only_zero_cost_metaprog.md) · [MOF](reference_meta_driven_concept_hardening_pattern.md) · [CT→RT](feedback_metaprogrammierung_compile_time_zwingend_durchsetzen.md) · [Kein variant](feedback_no_std_variant_static_axes_bloat.md)
- Achsen: [Haupt=CT/Unter=RT](feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring.md) · [Kopf-Framework](feedback_achsen_thema_modul_framework_metaprogramming_interface.md) · [Keine Tier-Achsen](feedback_no_whole_tier_axes_genus_configurator.md) · [System/Organ](feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen.md) · [Fehlerklassen](feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen.md) · [Q2=6.Achse](feedback_q2_option_c_erweiterungshardware_sechste_systemachse.md) · [Compiler](project_compiler_systemachse_traegt_dynamische_xml_unterachsen.md)
- **[NUR VIER BINARY-TYPEN](project_vier_binary_typen_ceb_traegt_alles_acht_behelfs_clis.md) — Planer(Director)→CEB(Builder)→Tier→Hybrid, statisch. Keine Skripte. IST: 8 Behelfs-CLIs + 42 Skripte**
- **[HYBRID = eigene Gattung](project_hybrid_heuristik_adapter_gattung_reroute_genus.md)** · **[HYBRID-Entscheide 09.08.](project_hybrid_owner_entscheide_20260809_vier_blocker.md) — E-1/K1/K2/K5 + K4=C+A**
- **[8-Stationen-Kette](project_verarbeitungskette_acht_stationen_hardware_job_pool.md) — Abstimmung über das LAGER. = Explore-Auslöseliste**
- **[18 ORGAN-ACHSEN, nicht 19](reference_organ_achsen_sind_achtzehn_nicht_neunzehn.md) — Registry 18 · `organ_count()==18` · 11 Memory-Stellen veraltet**
- **[KEINE flat_hash_map](reference_flat_hash_map_swisstable_gattung_map_nicht_container.md) — strukturell unmöglich (axis_06). Eigenbau S22 = Genus SearchAlgorithm → Gattung MAP. Offen: Textpass + AP-7b**
- Gattung: [Interface-Fam.](project_ap15_container_gattung_comdare_container_sequence_plan.md) · [Genus+ABI](feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable.md) · [Cmd+Visitor](feedback_command_pattern_achsen_mess_visitor_container_in_sa.md) · [Observable](reference_observable_wrapper_must_forward_concept_members.md)
- Struktur: [C++/Drogon](feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources.md) · [Baseline-Stein](feedback_baseline_system_in_stein_gemeisselt_layering.md) · [Umbrella](feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen.md) · [Products](feedback_standardprozess_research_zu_product_matrix_3d.md) · [vendor→self](feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained.md) · [Paper ext/](feedback_ext_paper_organisation_separates_axes_from_paper_code.md) · [Kein Python](feedback_no_python_in_buildchain.md) · [8er-Docker](feedback_build_matrix_8_docker_distros_full_platform_doctrine.md) · [buildsystem.xml](feedback_buildsystem_xml_hands_off_parallel_ci_cmake.md) · [PRT-ART](feedback_prt_art_consumes_cache_engine.md) · [286=Forschung](project_cache_engine_research_vs_cacheengine_all_split_todo.md) · [Spiegel weg](project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules.md)

## Thesis
- **[EIGENTUM](reference_eigentum_thesis_privat_cacheengine_bep_venture_comdare.md) — Thesis = BEP privat · CacheEngine = BEP Venture UG/Comdare**
- **[HDR = Thesis-Zusage](project_thesis_hdr_histogramm_zusage_bindet_den_bau.md) — 3 Präsens-Stellen. Falle: 3 Dateien sind TOT**
- **[DE FÜHRT IMMER](feedback_thesis_deutsche_version_fuehrt_englische_nachziehen.md) — Lint → `% chktex NN`, nie den dt. Satzbau umformen**
- [Vortrag](project_vortrag_nach_abgabe_technischer_hintergrund_zuerst.md) · [allg→speziell](project_thesis_habich_restruktur_general_to_special.md) · [DE+EN](project_thesis_latex_struktur_bilingual.md) · [Kern=Achsen](reference_thesis_core_contribution_axis_library.md) · [Idreos](reference_thesis_design_space_fachvokabular.md) · [Baum-Anat.](feedback_thesis_universelle_baum_anatomie_und_prinzipsuche.md) · [LaTeX=Quelle](feedback_diplomarbeit_design_ist_quelle_der_implementierung.md)
- [nur User-Ideen](feedback_thesis_nur_user_ideen_persistieren.md) · [Keine Lösung vorweg](feedback_thesis_linear_aufgabenstellung_keine_loesung_vorweg.md) · [Verweis rückwärts](feedback_thesis_sequential_referencing_rule.md) · [Legende](feedback_thesis_tabellen_legende_notiz_unter_float.md) · [XX_op](feedback_thesis_divide_and_conquer.md) · [Sessions→Thesis](feedback_text_agent_sessions_belong_in_thesis_not_impl_repo.md)
- [Git-Topo](reference_thesis_git_topology_remotes_overleaf.md) · [TUD](reference_tud_informatik_thesis_format_norm.md) · [T-ids](reference_thesis_axis_t_ids_vs_dir_numbers.md) · [.blg alphadin](reference_thesis_build_check_blg_alphadin.md)

## References/Infra
- **[LOKAL = prod1](reference_lokale_maschine_ist_prod1_kein_dritter_host.md) — 10.0.10.211, nur zwei Hosts**
- **[LOKAL −O0 gegen CI Release](reference_lokal_O0_gegen_ci_release_beobachtbarkeits_luecke.md) — Beobachtbarkeits-Zusagen lokal SCHWÄCHER. Köder würfeln, beide Stufen**
- [Standalone](reference_cache_engine_standalone_build_pipeline.md) · [XML `--`](reference_xml_kommentar_doppelbindestrich_falle.md) · [Drift-Wache](reference_drift_guard_faengt_anhaengen_nicht.md) · [git -C](reference_git_immer_mit_c_pfad_cwd_falle.md) · [Mojibake](reference_codex_utf8_mojibake_double_encoding.md) · [Master-Doks](reference_documentation_master_paths.md) · [glpat](reference_gitlab_pat_format_dots_regex.md) · [.de→.local](reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca.md) · [VLAN SNI](reference_cluster_vlan_tabelle_sni_standard_pattern.md) · [prod1-Env](reference_prod1_comdare_env_setup.md) · [Cold-ICE](reference_ci_runner_ice_cold_cache_instability.md) · [322 Infra](reference_infra_agent_memory_handover_322_location.md) · [Desktop-BU](reference_desktop_plain_backup_diplomarbeit.md) · [main-FF SHA](reference_main_ff_watcher_pin_sha_nicht_rev_parse_head.md)
- [Cluster read-only](feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra.md) · [Infra ultracode](feedback_infra_always_ultracode_over_sessions_first.md) · [Infra+Vault](feedback_infra_autonomie_freigabe_cluster_reserviert.md) · [Infra-Block→A](feedback_ci_infra_blocked_proceed_local_double_verify_mode_a.md)

## Mess-/Experiment-Kanon
- E-Ebenen: [E4..E1](project_e1_e4_experiment_maschinerie_und_konsolidierung.md) · [E4-XML→CEB](feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert.md) · [Organ/System](feedback_system_axes_measurement_own_abstract_root_blood.md) · [Schichten](feedback_e_schichten_separat_fertigstellen_top_down.md) · [Fehlbau](feedback_max_tiefe_bei_problemen_saubersten_zustand.md) · [Dossier](feedback_elaborate_dossier_fuer_komplexe_planung.md)
- Messung: [Min/Max](feedback_axes_optimization_semantics_deep_research_observer_strategy.md) · [Messkurven+CoR](feedback_heuristik_messkurven_typsystem_chain_of_responsibility.md) · [CEB 3 Modi](feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md) · [Debug=par](feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake.md) · [Fehler→CSV](feedback_measurement_failure_visibility_csv_failed_not_null_plus_log.md) · [Tooling=1 CEB](feedback_mess_tooling_default_vereint_eine_ceb.md) · [golden 2^17](feedback_new_golden_all_axes_xml_gt320.md)
- **[MeasureStorage: ZWEI Arenen](project_measurestorage_modul_custom_arena_append_measure_to_latex.md) — Mess-Arena (Append) + Stack-Arena (LIFO)**
- **[Drift-Gate = 18× je Zelle](project_drift_gate_18_durchlaeufe_je_zelle_kapazitaet.md) — `reps*(max_reruns+1)`**
- **[CSV = Strategy der xlsx](project_csv_ist_strategy_pattern_der_xlsx_erzeugung.md) — 09.08.: xlsx=Default, csv wählbar, BEIDE ZUSAMMEN zulässig (XOR vom 05.08. aufgehoben). Richtung IMMER xlsx→csv. Flach ist falsch**
- CI/golden: [CI-Grün=AUS](feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert.md) · [golden autonom](feedback_autonomous_measurement_via_ci_job_authorized.md) · [golden Fehler](feedback_production_track_full_golden_run_finds_errors.md) · [Grün→punktuell](feedback_ci_gruen_messfaehig_nur_punktuelle_refactorings.md) · [Pipeline grün](feedback_gesamte_pipeline_immer_hart_gruen.md) · [Architektur≠grün](feedback_increments_architekturkonform_nicht_nur_gruen.md) · **[allow_failure VERBOTEN](feedback_allow_failure_verboten_seit_0607_zelle_gegen_job.md) — ZELLE=Warnung, JOB=hart rot**
- Rückschrieb: [WRITE-Token](project_mess_ergebnis_rueckschreibung_pipeline_persistiert.md) · [Token 54](reference_measurement_writeback_token_288_secure.md) · [Deploy-Token](reference_super_ci_cannot_fetch_new_ce_submodule_commits.md) · [Graph=PHANTOM](reference_tier_metaphor_system_axis_properties_verified_complete.md) · [~15 vendored](reference_ce_facade_super_subbuild_verify_and_clang_format_prod1_gap.md)
- Kette/XML: [Kette §38](feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md) · [Dock .so](feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md) · [Registry=ANGEBOT](feedback_registry_angebot_anwender_xml_pom_resolver_planer.md) · [2 Registry](feedback_unified_experiment_xml_plus_system_registry_xml.md) · [CMake PRT](feedback_ceb_config_cmake_interface_static_registry_paths_prt_module.md) · [flach=Baum](feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns.md) · [Tier-Cache](feedback_incremental_tier_binary_caching.md)
- Historik: [Selbst impl.](feedback_selbst_implementieren_ab_20260710_codex_abgeloest.md) · [Alt-golden](feedback_alt_golden_darf_brechen_erst_additiv_dann_aufraeumen_unter_absprache.md) · [GEPARKT](feedback_dual_verifikation_baremetal_lokal_und_ci_synchron_gruen.md) · [Schläft](feedback_autonomous_overnight_note_open_decisions_for_morning.md)

## Rollen/Autonomie
- **[MEINE Arbeitsfehler K1–K13](feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md) — K10 ungeprüfter Checkout · K11 `rc=$?` nach Pipe · K13 Köder muss beißen**
- **[ALLES IST GEPLANT](feedback_alles_ist_geplant_gedaechtnisluecke_selbst_recherchieren.md) — unlösbare Frage = MEINE Gedächtnislücke**
- **[GEDÄCHTNIS ZUERST](feedback_arbeitsweise_sequenz_gedaechtnis_zuerst_nie_explore_fuer_dokumentiertes.md) — Gedächtnis→Review→Explore→Design→Bauen→Verify**
- **[EXPLORE PFLICHT je Welle+Strang](feedback_explore_pflicht_vor_jeder_design_und_bau_phase_je_welle_und_strang.md) — Sonnet 5 max, Korpus inkl. ROHE JSONL. Nichtfund nur mit Gegenprobe**
- **[EXPLORE=2-STUFIG](feedback_explore_kartierung_sonnet5_max_dann_selbst_gegenlesen.md) — Stufe 2 lese ich jede tragende Referenz selbst**
- **[6+ STRÄNGE + ultracode frei](feedback_ultracode_immer_frei_plus_sechs_parallele_straenge.md) — sofern DISJUNKT; Schreiber brauchen eigene Worktrees**
- **[xlsx IST DIE AUSGABE](feedback_xlsx_ist_die_ausgabe_csv_nie_skip_bei_gleicher_binary.md) — gültiger Bestand ⇒ SKIP**
- **[DEFEKT = IMMER BEHEBEN](feedback_defekt_egal_wie_gross_immer_beheben.md)** · **[BLANKO-GO](feedback_blanko_go_alle_phasen_autonom_am_stueck.md) — Melden ≠ fragen** · **[Invalidieren=Ziel](feedback_bestand_invalidieren_ist_gewollt_kein_migrationszwang.md) — der Bruch muss LAUT sein**
- **[RANGFOLGE: OWNER > PLAN > THESIS](feedback_rangfolge_owner_plan_thesis_merge_statt_verdraengung.md) — erst fragen ob es sich ausschließt, dann MERGEN. [`docs/termine`=Historie](reference_docs_termine_ist_die_primaerquelle.md)**
- [Behauptungen→Quelle](feedback_behauptungen_verifizieren_layer_vertraege_halten.md) · [Lücke=Auftrag](feedback_luecke_ist_auftrag_explore_dann_bau_mit_verifikation.md) · [„bis jemand"=ich](feedback_bis_jemand_anderes_ist_immer_mein_auftrag.md) · [ARBEITSWEISE v2.1](feedback_claude_code_arbeitsweise_v2_konsolidiert.md)
- [Owner-KERNe 06.08.](project_owner_kerne_20260806_abend_frist_messkette_ceb.md) — Frist 15.09., freitags · Batch 4096 · PMC ins Prüfdock
- [Freeze](feedback_freeze_nachrichten_eindeutig_nur_antwort_vs_arbeitsauftrag.md) · [Zuweisung≠Start](feedback_task_assignment_not_start_signal_respect_gates_propose_first.md) · [WT-Freeze](feedback_agent_working_tree_freeze_nach_paketmeldung.md) · [User-KERN=Gesetz](feedback_user_kern_beschreibung_ist_immer_gesetz_abweichung_ist_regression.md) · [Plan autonom](feedback_autonomie_modus_plan_autonom_durchziehen.md) · [VOR+NACH uc](feedback_vor_und_nach_jeder_aufgabe_ultracode_plus_autonomie_scope.md) · [Aufgabe uc](feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs.md) · [Paket uc](feedback_per_paket_ultracode_planung_vor_ausfuehrung.md)
- [ASCII+Selbstcheck](feedback_ascii_only_comments_and_selfcheck_line.md) · [§61 Dual-Weg](feedback_dual_weg_pflicht_debug_parallel_multi_maschine.md) · [E-21 LIFO](feedback_todo_stack_lifo_verbose_owner_fragen_vollpersistenz.md) · [Backup SOFORT](feedback_workflow_backup_sofort_bei_fertigstellung.md)

## Stand/Fallen
- **Stand-Anker sind HISTORIE — der lebende Stand steht im Ledger und in `super docs/sessions/2026080*`**
- **[FALLEN-REGISTER](reference_fallen_register_werkzeuge_und_ci.md) — alle Werkzeug-/CI-Fallen + 17 KERNe. Härteste: `grep -v /build` frisst `/builder/`** · [ugrep stille Null](reference_ugrep_ascii_gate_stille_null.md)
- **[VAULT NIE GREPPEN](reference_vault_dateien_nie_greppen_nur_blind_verarbeiten.md) — blind per `mapfile`, PAT-Test RÜCKWÄRTS bis HTTP 200**
- **[gitleaks: Bereich statt Tiefe](feedback_gitleaks_push_bereich_statt_geratener_klontiefe.md) — `origin/<branch>..HEAD`, stdin-Modus `--config` PFLICHT**
- **[Fallen 08.08.](reference_fallen_20260808_gitleaks_aws_codex_pgrep.md) — AWS-Köder beißen nicht · Codex read-only defekt · `pgrep -f` trifft sich selbst**
- **[EXTRAKTOR: DREI PFADE](reference_transkript_extraktor_zwei_pfade.md) — `promptSource` + `queued_command` + `queue-operation` als UNION**
- Planung/Lager: [Post-v3](project_post_v3_anforderungen_so_abi_driver_split_cli.md) · [Mess-Schema](project_planer_mess_schema_kern_pruefling_replace_merge_fulljoin.md) · [§62 Planer](project_62_planer_universal_cache_log_claim_compare.md) · [Bestandslog-Ziel](project_bestandslog_zielbild_ordner_kaskaden_dual_ccache.md) · [Bestandslog-Abn.](project_bestandslog_abnahmen_baum_heuristik_stempel.md) · [Lager-Bäume](project_lager_baeume_xlsx_doktrin.md) · [Achsen-Sortierung](project_achsen_neuordnung_bindende_sortierung_regressionen.md) · [Finale L.](reference_diplom_finale_linie_identitaet_overleaf.md)
