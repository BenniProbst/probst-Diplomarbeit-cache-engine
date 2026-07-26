# 20260726-wahrheits-anker-voll-abgleich-workflow / batch-10 (agent aa25b45f)

runId: wf_0874d74a-003
agentId: aa25b45f98713c27b
label-Zuordnung: batch-10 (Prompt-Marker-Deckung 100%)

---

BATCH batch-10 (NR 559-620, 2026-07-14 .. 2026-07-17) - 62 Eintraege

NR 559 | jsonl:40313 | klasse=verankert
  kurz:       Alles ueber XML steuern
  anker:      MEMORY feedback_unified_experiment_xml_plus_system_registry_xml + DOSSIER Abschnitt 2 (NUR EIN offizielles XML-getriebenes Programm) + MEMORY feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert

NR 560 | jsonl:40314 | klasse=verankert
  kurz:       Slot-Registry separate XML, Experiment-Verwendung vereint
  anker:      MEMORY feedback_unified_experiment_xml_plus_system_registry_xml (Drei XML-Artefakte: Registry-XMLs separat, Experiment-XML vereint Familie A+C)

NR 561 | jsonl:40315 | klasse=verankert
  kurz:       Registry=System, Experiment-XML=individuelle Config
  anker:      MEMORY feedback_unified_experiment_xml_plus_system_registry_xml ('Registry-XMLs (System-Ebene)' / 'Diplomarbeit-Experiment-XML = individuelle Config'); MEMORY feedback_registry_angebot_anwender_xml_pom_resolver_planer

NR 562 | jsonl:40368 | klasse=verankert
  kurz:       Zwei Registries, drei Pruef-Phasen, v32 Strategy
  anker:      MEMORY feedback_unified_experiment_xml_plus_system_registry_xml (ce-Registry SOTA + prt-art-Registry gleiches Schema auf ce-C++23-Lib; 3 Phasen prt-art/cache-engine/kombiniert; v32-Modul -> Strategy-Pattern) + LEDGER Paragraph 15.1

NR 563 | jsonl:40382 | klasse=verankert
  kurz:       Bausteine nur in ce- und prt-art-Registry
  anker:      MEMORY feedback_unified_experiment_xml_plus_system_registry_xml (fett: 'Bausteine je Achse stehen NUR in den Registries (je Engine, nach dort vorhandenen Achsen-Algorithmen), NICHT in der Diplomarbeit-XML')

NR 564 | jsonl:40965 | klasse=delta
  kurz:       GitLab-PAT auf Branch development, Cluster-Sync-Pflicht
  anker:      DOSSIER Abschnitt 1 deckt nur den Vault-Pfad ab
  delta_text: Der gitlab pat ist im cred vault und auf branch development, braucht git sync von Projekte/Cluster nach einem commit auf unserer Seite
  konsequenz: DOSSIER Abschnitt 1 (SECURITY) nennt nur Vault-Pfad und die grep|tail-1-Regel, aber NICHT dass der Vault auf Branch development lebt und das Cluster-Repo nach eigenen Commits gesynct/gepullt werden muss. Folge: ein Agent greift den PAT aus einem veralteten lokalen Vault-Stand (Push/API scheitert mit 401), obwohl MEMORY D-08 den PAT als 'NEU' fuehrt - genau der Fall, den diese Regel abfaengt.

NR 565 | jsonl:41032 | klasse=operativ
  kurz:       GitLab wieder erreichbar, Sync anstossen

NR 566 | jsonl:41147 | klasse=operativ
  kurz:       Task-Notification Header-Fill Organ-Location gestoppt

NR 567 | jsonl:41444 | klasse=operativ
  kurz:       GO fuer Infra-Uebergabe, dann pausieren
  anker:      Uebergabe-Ort verankert in MEMORY reference_infra_agent_memory_handover_322_location / reference_diplomarbeit_impl_session_handover_location

NR 568 | jsonl:41585 | klasse=obsolet
  kurz:       Goal V4 mit G1-G8-Stack gesetzt
  anker:      abgeloest durch Paragraph 0-GOAL-V6 (NR 600, LEDGER:78 'Warum V6') und weiter durch DOSSIER Abschnitt 2/5/9 (STRUKT-R + Lager-Gate + Board); Striktheits-Direktiven daraus leben in DOSSIER Abschnitt 2 fort

NR 569 | jsonl:41586 | klasse=operativ
  kurz:       Aufgaben zuerst, dann Goal setzen

NR 570 | jsonl:41637 | klasse=verankert
  kurz:       Goal erst im Ledger konsolidieren, dann setzen
  anker:      LEDGER Paragraph 0-GOAL-Vn-Versionierungspraxis (V4/V5/V6, LEDGER:78 'Warum V6' begruendet genau die Widerspruchs-Vermeidung); DOSSIER Abschnitt 2 (Ledger regulaer in-place, neuere Fakten schlagen aeltere)

NR 571 | jsonl:41650 | klasse=operativ
  kurz:       Komplettes Task-Board wiederherstellen
  anker:      MEMORY feedback_tasks_list_is_user_visible_todo_keep_current

NR 572 | jsonl:41717 | klasse=operativ
  kurz:       Task-Notification R-E golden-Gate in CI

NR 573 | jsonl:41788 | klasse=operativ
  kurz:       Task-Notification E2E-Folgepflicht-Workflow 109 Agenten

NR 574 | jsonl:42148 | klasse=delta
  kurz:       Alle vier Repo-Ledger lesen, dann Audit
  anker:      DOSSIER Abschnitt 2 deckt nur 'Ledger + alle Plandocs' (Singular super-Ledger) ab
  delta_text: Bitte bedenke, dass alle 4 Projekte vermutlich ein eigenes Ledger haben, bitte lies daher auch alle 4 ledger und fahre dann mit dem Audit fort
  konsequenz: Der Referenz-Stand kennt nur DAS Ledger (super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md); weder DOSSIER Abschnitt 2 ('ultracode-Planung ueber Ledger + alle Plandocs') noch MEMORY nennen die Pflicht, bei Audit/ultracode die Ledger ALLER vier Repos (super, ce, prt-art, thesis) zu lesen. Folge: Audits und Vor-Aufgaben-Planungen werten faktisch nur das super-Ledger aus; offene Punkte in den ce-/prt-art-/thesis-Ledgern fallen systematisch aus dem Befund - ungeplant genau vor der Voll-Bau-4-/Abgabe-Strecke.

NR 575 | jsonl:42517 | klasse=operativ
  kurz:       Task-Notification WP-1 v32-Mess-Integritaet gestoppt

NR 576 | jsonl:42558 | klasse=verankert
  kurz:       Option A, immer offizielle Architektur
  anker:      LEDGER:464 (2026-07-16 FORK-ENTSCHEID OPTION A [User, bindend], Generalregel 'IMMER offizielle Architektur', WP-1 gestoppt) + DOSSIER Abschnitt 2 (keine Behelfswege, schwererer offizieller Weg, NUR EIN offizielles XML-Programm)

NR 577 | jsonl:42575 | klasse=operativ
  kurz:       Session nachladen, bei Aufraeumen fortsetzen

NR 578 | jsonl:42589 | klasse=obsolet
  kurz:       G-Stack-Statusbericht 16.07. eingefuegt
  anker:      Statusbild abgeloest durch DOSSIER Abschnitt 0 (Stand in fuenf Saetzen) + Abschnitt 9 (Board in Gate-Reihenfolge); die dort genannten Gates (V5 setzen, DoD-7, Scheduling #36/#37, G5-Facade) sind durch V6 bzw. STRUKT-R/Band-C-Zuordnung ueberholt

NR 579 | jsonl:42590 | klasse=operativ
  kurz:       Ausfuehrungsreihenfolge strategisch planen

NR 580 | jsonl:42893 | klasse=duplikat
  kurz:       Goal-V4-Text wortidentisch wiederholt
  anker:      byte-identisch mit NR 568 (diff = leer)

NR 581 | jsonl:42914 | klasse=obsolet
  kurz:       Goal V4 plus Audit-Backup-Orientierung
  anker:      Goal-Rumpf abgeloest durch Paragraph 0-GOAL-V6 / DOSSIER Abschnitt 2; der Zusatz ('letzte Audits + Backup-Workflows via ultracode bei jeder groesseren Aufgabe') ist verankert in DOSSIER Abschnitt 2 + MEMORY feedback_consult_analysis_backups_via_ultracode_before_decisions

NR 582 | jsonl:43145 | klasse=verankert
  kurz:       F3i/F4/F5 Compiler-Achse, Voll-Vergleich, Systemachsen
  anker:      LEDGER:460 (2026-07-16 USER-KONZEPT-KLAERUNG F3i/F4/F5, AUTORITATIV woertlich: CEB UND jede Tier-Binary-Permutation per XML mit gcc oder clang; Voll-Vergleich einer Tier-Binary unter Last gegen ALLE anderen; 4. Kategorie JE STUFE fuer die 3 gemessenen Stufen; Scheduling/HW/NUMA/Locking = Pflicht-Systemachsen neben den Mess-System-Achsen; Experiment-Planer = dritte Anwendung; 20-Seiten-Dossier). HINWEIS: die Teil-Aussage 'compiler = neue System-HAUPT-Achse' ist durch R-D (26.07., DOSSIER 3.2: compiler+opt_level+atomic128 = Unter-Achsen-Gruppe der Komplex-Haupt-Achse) spaeter revidiert; Kern (Compiler-Wahl per XML fuer CEB und Tier) bleibt gueltig

NR 583 | jsonl:43271 | klasse=operativ
  kurz:       Task-Notification S-7 Workflow 529-Fehler

NR 584 | jsonl:43548 | klasse=operativ
  kurz:       Task-Notification S-7 Locking-Plan fertig

NR 585 | jsonl:43583 | klasse=operativ
  kurz:       Fehlende Workflows neu starten

NR 586 | jsonl:43719 | klasse=verankert
  kurz:       Gesamtes Ledger plus fuenf Sessions laden
  anker:      DOSSIER Abschnitt 2 (vor JEDER Aufgabe ultracode-Planung ueber Ledger + alle Plandocs) + MEMORY feedback_ledger_komplett_plus_ultracode_richtung_vor_abschnitten + feedback_sessions_read_newest_first_both_repos (neueste=5)

NR 587 | jsonl:43795 | klasse=operativ
  kurz:       Task-Notification #35 Fassade R1 fertig

NR 588 | jsonl:43868 | klasse=operativ
  kurz:       Task-Notification Ingest Paragraph-12-Verlaufsprotokoll

NR 589 | jsonl:43869 | klasse=operativ
  kurz:       Task-Notification Agent-Report Folgeblock

NR 590 | jsonl:44086 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 591 | jsonl:44235 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 592 | jsonl:44513 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 593 | jsonl:44526 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 594 | jsonl:44659 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 595 | jsonl:44748 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 596 | jsonl:44761 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 597 | jsonl:45101 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 598 | jsonl:45218 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 599 | jsonl:45243 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 600 | jsonl:45547 | klasse=obsolet
  kurz:       Goal V6 mit Bau-INC-Roadmap gesetzt
  anker:      Bau-Front (Bau-INC-0 DLL-Load Option B / INC-1 CEB-Schichtung / INC-2 der EINE 4->5-Bump) abgeloest durch DOSSIER Abschnitt 4/5/9 (Lager-Gate komplett, STRUKT-R mit ABI-Major 6->7, Board in Gate-Reihenfolge); Rest-Substanz lebt fort: Prozess-Regeln in DOSSIER Abschnitt 2, Verifikations-Kadenz in Abschnitt 2/10, Deadline 28.07. 'CI UND standalone messfaehig' als 28.07.-Anker V6.6/F12(i) in Abschnitt 2, Rueckschrieb measurement/ in MEMORY project_mess_ergebnis_rueckschreibung_pipeline_persistiert

NR 601 | jsonl:45642 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 602 | jsonl:45652 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 603 | jsonl:45710 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 604 | jsonl:45864 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 605 | jsonl:45949 | klasse=verankert
  kurz:       Cred-Vault liegt unter Projekte/Cluster/keys
  anker:      DOSSIER Abschnitt 1 SECURITY (Vault=/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-{DEV,PROD}.md)

NR 606 | jsonl:46041 | klasse=verankert
  kurz:       Bei Konflikten immer merge, nie rebase
  anker:      MEMORY feedback_nie_rebase_immer_merge + DOSSIER Abschnitt 1/2 (NIE rebase; vor Push fetch+merge)

NR 607 | jsonl:46099 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 608 | jsonl:46431 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 609 | jsonl:46486 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 610 | jsonl:46542 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 611 | jsonl:46759 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 612 | jsonl:47087 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 613 | jsonl:47239 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 614 | jsonl:47408 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 615 | jsonl:47501 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 616 | jsonl:47639 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 617 | jsonl:47690 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 618 | jsonl:47718 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 619 | jsonl:47900 | klasse=operativ
  kurz:       Task-Notification Agent-Report

NR 620 | jsonl:47929 | klasse=operativ
  kurz:       Task-Notification Agent-Report
