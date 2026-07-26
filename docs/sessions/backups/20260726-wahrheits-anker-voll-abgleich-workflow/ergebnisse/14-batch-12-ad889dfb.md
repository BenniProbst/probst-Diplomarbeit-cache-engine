# 20260726-wahrheits-anker-voll-abgleich-workflow / batch-12 (agent ad889dfb)

runId: wf_0874d74a-003
agentId: ad889dfbe404e496d
label-Zuordnung: batch-12 (Prompt-Marker-Deckung 100%)

---

BATCH batch-12 - 62 Eintraege

NR 683 | jsonl:49716 | klasse=operativ
  kurz:       Task-Notification Voll-ctest vor Commit

NR 684 | jsonl:49826 | klasse=verankert
  kurz:       F1/F2/F3 bestaetigt, volles GO
  anker:      memory project_compiler_systemachse_traegt_dynamische_xml_unterachsen.md (F1/F3-Ruling: opt_level ist Unter-Achse, kein Geschwister; 'global' existiert nicht)

NR 685 | jsonl:49908 | klasse=verankert
  kurz:       OF-1/OF-2/OF-3 Compiler-Unterachsen-Rulings
  anker:      memory project_compiler_systemachse_traegt_dynamische_xml_unterachsen.md Abschnitt 'PRAEZISIERUNG (OF-1/2/3-Rulings)' (CPU-SIMD als Compiler-Unterachse, GPU/FPGA=Hauptachsen-Array, Default Ofast, nichts gepinnt, commands+flags parallel)

NR 686 | jsonl:49942 | klasse=verankert
  kurz:       prod1/prod2 Runner online, CI plus lokal
  anker:      DOSSIER 20260726 Abschnitt 1 (MASCHINEN prod1+prod2, Runner concurrency=1) + Abschnitt 2 'Dual-Weg-Pflicht (§61): jede Funktion ueber CI UND lokal'

NR 687 | jsonl:50000 | klasse=verankert
  kurz:       Credentials/PAT aus Cluster/keys, CI selbst pruefen
  anker:      DOSSIER Abschnitt 1 SECURITY (PAT via Vault /home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-*.md, nie printen) + memory feedback_verify_gitlab_pipeline_green_after_push.md

NR 688 | jsonl:50001 | klasse=operativ
  kurz:       GO ohne weiteren Inhalt

NR 689 | jsonl:50002 | klasse=operativ
  kurz:       Steuerbefehl voll autonom

NR 690 | jsonl:50041 | klasse=verankert
  kurz:       Root-Zugang heisst admin-management
  anker:      DOSSIER Abschnitt 1 Root-Wege (admin-management@localhost prod1 NOPASSWD / @10.0.10.212 prod2)

NR 691 | jsonl:50079 | klasse=operativ
  kurz:       Auftrag ultracode-Workflow XML-CI-Automatisierung

NR 692 | jsonl:50158 | klasse=verankert
  kurz:       Fehlerklassen Pflicht Achsen Unterachsen Algorithmen
  anker:      memory feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen.md (Experiment-Planer=Compiler-Compiler-Fehlerklasse, AVX512-Fehlen deklariert im Log)

NR 693 | jsonl:50227 | klasse=operativ
  kurz:       Task-Notification CI-Pipeline-Polling

NR 694 | jsonl:50278 | klasse=operativ
  kurz:       Task-Notification Voll-ctest nach O3-Fix

NR 695 | jsonl:50288 | klasse=verankert
  kurz:       Gesamte Pipeline immer hart gruen
  anker:      memory feedback_gesamte_pipeline_immer_hart_gruen.md + DOSSIER Abschnitt 2 (Increments architekturkonform, gruen != korrekt)

NR 696 | jsonl:50342 | klasse=operativ
  kurz:       Task-Notification super-Sub-Build build-i2

NR 697 | jsonl:50889 | klasse=operativ
  kurz:       Auftrag development auf main mergen

NR 698 | jsonl:51059 | klasse=operativ
  kurz:       Task-Notification adversariale Konformitaets-Verifikation

NR 699 | jsonl:51222 | klasse=operativ
  kurz:       Task-Notification Clean-Rebuild plus ctest

NR 700 | jsonl:52495 | klasse=operativ
  kurz:       Rueckfrage: erst Design-Plan erklaeren

NR 701 | jsonl:52519 | klasse=operativ
  kurz:       Task-Notification Planung opt-g A2-Neben

NR 702 | jsonl:52553 | klasse=operativ
  kurz:       Task-Notification CI-Monitor d1-Cluster

NR 703 | jsonl:52672 | klasse=delta
  kurz:       System-Achsen steuern Kompilation und Mess-Achsen-Auspraegung
  delta_text: E1: Die Mess-Achsen und System-Achsen gehoeren beide in CEB und die System-Achsen steuern die gesamte Kompilation und Auspraegung der Mess-Achsen. Die Organ-Achsen sind alle direkt in den Tier-Binaries einkompiliert. SIMD kommt in die System-Achse als Erweiterungs-Hardware, sofern auf der ISA vorhanden; es gibt auch Organe, die SIMD anbieten duerfen, also Organ-Achsen-Algorithmen kleiner gleich System-Achsen-Algorithmen-Zulassung.
  konsequenz: Anteil 'Organ <= System-Freigabe' und 'Mess-Tooling CT-Haupt an der CEB' sind verankert, ABER die Steuer-HIERARCHIE 'System-Achsen steuern Kompilation UND Auspraegung der Mess-Achsen' fehlt im Referenz-Stand. Die bindende Sortierung (DOSSIER 3.1) stellt MESS-TOOLING an Position 1 VOR target_isa und die Typ-Klammern (3.5 Ebene 1) behandeln Mess/System als gleichrangige, getrennte Typen - eine Unterordnung der Mess-Auspraegung unter die System-Achsen ist damit nirgends kodiert. Lane A (kSystemAxisOrder-Single-Source + Stempel A-II/A-III) wuerde die Ordnung ohne diese Steuer-Relation generieren.

NR 704 | jsonl:52673 | klasse=operativ
  kurz:       Startfreigabe bitte baue los

NR 705 | jsonl:53033 | klasse=verankert
  kurz:       Haupt/Unter vertauscht; Opt-Typen sind Optionen
  anker:      memory feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen.md ('KEINE opt/OptO-Haupt-Achse; opt_level ausschliesslich Unter-Achse unter compiler; Optionen O0..Ofast heissen OptO*Option, nicht SubAxis') + memory feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md (AxisKind{organ, system_measurement, system_config} = Mess formal System, getrennt gefuehrt) + DOSSIER 3.1 bindende Sortierung als belegte Tabelle

NR 706 | jsonl:53040 | klasse=operativ
  kurz:       Auftrag ultracode Code-Review Design-Diff

NR 707 | jsonl:53415 | klasse=operativ
  kurz:       Alte Memory stumpf in sessions kopieren

NR 708 | jsonl:53658 | klasse=operativ
  kurz:       Task-Notification CI-Monitor INC-29

NR 709 | jsonl:54255 | klasse=operativ
  kurz:       Task-Notification F-SIMD-Vorplanung Schritt 2-4

NR 710 | jsonl:54914 | klasse=verankert
  kurz:       GO TargetIsaSystemAxis wie empfohlen
  anker:      DOSSIER 3.1 (target_isa = 2. Glied der System-Haupt-Kette) + 3.2 R-B/R-D (target_isa traegt scheduling und die Compiler-Unter-Achsen-Gruppe)

NR 711 | jsonl:54957 | klasse=operativ
  kurz:       Volles GO A2-Neben golden-Umbau

NR 712 | jsonl:55012 | klasse=operativ
  kurz:       Agenten-Nachricht INC-2d Varianten-Frage

NR 713 | jsonl:55044 | klasse=operativ
  kurz:       Task-Notification INC-2d ABI-Kern fertig

NR 714 | jsonl:55123 | klasse=operativ
  kurz:       Task-Notification 3 Regressionen behoben

NR 715 | jsonl:55260 | klasse=verankert
  kurz:       Neues golden-XML ueber alle Achsen
  anker:      memory feedback_new_golden_all_axes_xml_gt320.md (neue XML-Grundlage alle Achsen, Permutations-Zahl >320 als neues golden-Ziel mit compile+test, erst nach dem INC-2d-Fix)

NR 716 | jsonl:55417 | klasse=operativ
  kurz:       GO fuer das Ziel-N

NR 717 | jsonl:55451 | klasse=verankert
  kurz:       Inkrementeller CEB/Tier-Cache per Algo-Versionierung
  anker:      memory feedback_incremental_tier_binary_caching.md (je Binary per-Organ-Achse Algorithmus+Version-Listing, nur betroffene Binaries rebuild, CEB-Aenderung=Voll-Rekompilation, Last eingegrenzt)

NR 718 | jsonl:55452 | klasse=verankert
  kurz:       Cache ist Voraussetzung fuer golden N
  anker:      memory feedback_incremental_tier_binary_caching.md Kopf ('EINSCHUB, Voraussetzung fuer das neue golden N=2^17')

NR 719 | jsonl:55453 | klasse=verankert
  kurz:       Baum hat lazy Materialisierung, CEB dafuer gebaut
  anker:      memory feedback_incremental_tier_binary_caching.md Abschnitt Why (User-Hinweis verbatim: lazy Materialisierung, StaticBinaryView/dll_is_current/.version-Sidecar nutzen, nicht neu erfinden)

NR 720 | jsonl:55454 | klasse=operativ
  kurz:       Durchzieh-Freigabe das ist machbar

NR 721 | jsonl:55455 | klasse=verankert
  kurz:       Danach weiter mit dem Hauptstrang
  anker:      memory feedback_new_golden_all_axes_xml_gt320.md Abschnitt ORDNUNG ('Dies ist ein EINSCHUB, kein Ersatz des Hauptstrangs; der Hauptstrang darf NICHT vergessen werden')

NR 722 | jsonl:55545 | klasse=obsolet
  kurz:       Alles nach NFS-RBMM-Hierarchie schreiben
  anker:      ueberholt durch NR 724 (18.07. ~19:55) und dort persistiert: memory feedback_incremental_tier_binary_caching.md Abschnitt STORAGE-EBENE ('Zwischenzeitlich verworfen: alles nach NFS-RBMM - das galt nur kurz; final = minio fuer Bau-Artefakte, NFS-prod NUR fuer die Messergebnisse'). Erhalten geblieben ist nur der Teilsatz 'uebrige Bestandteile bleiben im gitlab cache auf cluster dev'.

NR 723 | jsonl:55546 | klasse=operativ
  kurz:       Auftrag Memory korrigieren

NR 724 | jsonl:55580 | klasse=verankert
  kurz:       minio fuer Compiles, NFS-prod fuer Messergebnisse
  anker:      memory feedback_incremental_tier_binary_caching.md Abschnitt 'STORAGE-EBENE (User-FINAL 2026-07-18) - DIES gilt' (CEB/Tier-Compiles->minio.comdare.de, Messergebnisse->NFS prod-HDDs, durchsuchbar via DNS-.1-SNI/HAProxy aus VLAN 10) + memory reference_cluster_vlan_tabelle_sni_standard_pattern.md

NR 725 | jsonl:55581 | klasse=operativ
  kurz:       Task-Notification CRC64-Anker statt 62MB-Datei

NR 726 | jsonl:55595 | klasse=verankert
  kurz:       Schreiben strikt sequentiell zu Messungen
  anker:      memory feedback_incremental_tier_binary_caching.md Abschnitt 'SEQUENTIALITAETS-CONSTRAINT (KRITISCH)' (Cache-Push und Ergebnis-Rueckschrieb nie parallel zur Messung, sonst Messfehler)

NR 727 | jsonl:55621 | klasse=operativ
  kurz:       Task-Notification VOR-Workflow inkrementeller Cache

NR 728 | jsonl:55901 | klasse=verankert
  kurz:       Volles GO, Infra-Ausnahme, Haupt/Unter-Regel
  anker:      (a) Memory-Kipp-Auftrag: memory feedback_ledger_komplett_plus_ultracode_richtung_vor_abschnitten.md Abschnitt KORRIGIERT (die 'alle Memories kippen'-Fassung ist dort dokumentiert UND spaeter vom Owner selbst durch themen-scharfes ultracode-Laden abgeloest). (b) Infra-Modus-Ausnahme Caching/Storage inkl. Cluster/docs/sessions, .1-SNI, HAProxy, VLAN-Tabelle: memory feedback_incremental_tier_binary_caching.md (INFRA-Handover/Ausnahme) + reference_cluster_vlan_tabelle_sni_standard_pattern.md + feedback_infra_autonomie_freigabe_cluster_reserviert.md. (c) Haupt=CT-verdrahtet / Unter=RT + Ketten-Uebernahme: memory feedback_haupt_achse_static_unter_achse_runtime_chain_ct_wiring.md und DOSSIER 3.3 R1.

NR 729 | jsonl:56217 | klasse=operativ
  kurz:       Task-Notification Themen-Kontext-Brief geladen

NR 730 | jsonl:56229 | klasse=verankert
  kurz:       Beide Repos haben sessions und docs/sessions
  anker:      memory feedback_sessions_read_newest_first_both_repos.md + reference_diplomarbeit_impl_session_handover_location.md (Handover in super docs/sessions/) + DOSSIER Lese-Reihenfolge (Session-Docs beider Repos)

NR 731 | jsonl:56248 | klasse=verankert
  kurz:       Falsch in backups gelandete Sessions umziehen
  anker:      memory feedback_backups_only_workflow_rawdata_never_sessions_plans.md (backups nur Workflow-Rohdaten, Sessions/Plaene gehoeren in docs/sessions des jeweiligen der 4 Diplom-Repos) + DOSSIER Abschnitt 8

NR 732 | jsonl:56358 | klasse=operativ
  kurz:       Laufenden Agenten nicht behindern

NR 733 | jsonl:56382 | klasse=operativ
  kurz:       Agenten zu Ende laufen lassen

NR 734 | jsonl:56554 | klasse=delta
  kurz:       B+-Baum-Steuerungsnachweis als stehendes TODO
  delta_text: Bitte liste das TODO, dass ein ultracode Agent pruefen muss, ob die Konfiguration der Organ-Achsen, System-Achsen und Mess-Achsen weiterhin NACHWEISLICH durch den Experiment-B+-Baum gesteuert wird, der durch die XML eingestellt wird. Dieser Experiment-B+-Baum ist Prototyp und Vorlaeufer, sowie weiterhin zentrale Konfigurations-Repraesentation des Experiment-Planer-Programms und Interpreters des Systems. Bitte ins Ledger schreiben.
  konsequenz: Im Referenz-Stand kommt der Experiment-B+-Baum NICHT EINMAL VOR (Wort-Suche in DOSSIER und allen drei 20260726-Session-Docs = 0 Treffer); nur die Memory feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md nennt 'EIN AxisKind-gefaerbter Gesamt-B+-Baum'. Damit fehlt (1) der stehende Nachweis-Auftrag (ultracode-Pruefung, dass alle drei Achsen-Typen weiter vom XML-gesetzten B+-Baum gesteuert werden) auf dem Board Abschnitt 9 und in den 4 Beweisen vor dem Voll-Bau-4-Trigger, und (2) die Rollen-Festschreibung 'B+-Baum = zentrale Konfigurations-Repraesentation UND Interpreter des Experiment-Planers'. STRUKT-R Lane A/C/F und ORG-18 aendern genau diese Achsen-Konfiguration (18 Slots, neue Ordnung, Stempel-Klammern), ohne dass die B+-Baum-Steuerungs-Invariante als Abnahme-Kriterium gefuehrt wird - Regressionsrisiko: Achsen werden am Baum vorbei konfiguriert und es faellt niemandem auf.

NR 735 | jsonl:56555 | klasse=operativ
  kurz:       Steuerbefehl dann weiter

NR 736 | jsonl:56838 | klasse=operativ
  kurz:       Letzten Commit auf development pushen

NR 737 | jsonl:56839 | klasse=duplikat
  kurz:       Identischer Text wie NR 735
  anker:      NR 735 (jsonl:56555), identischer Wortlaut 'Dann weiter'

NR 738 | jsonl:56886 | klasse=verankert
  kurz:       Thesis muss auf github existieren, Fehler analysieren
  anker:      memory reference_thesis_git_topology_remotes_overleaf.md (Thesis-Git BASE+2 Remotes, Overleaf->GitHub) + feedback_all_projects_dual_remote_github_gitlab.md + DOSSIER Abschnitt 1 (4 Diplom-Repos incl. 20260931-overleaf-diplomarbeit)

NR 739 | jsonl:56912 | klasse=verankert
  kurz:       Thesis unter external/overleaf, dual pushen
  anker:      memory reference_thesis_git_topology_remotes_overleaf.md (Thesis als Submodul, verwaiste/fehlende Remotes nachziehen, Dual-Push) + DOSSIER Abschnitt 1/7 (overleaf-Repo, Board #2 overleaf-Merge)

NR 740 | jsonl:56944 | klasse=verankert
  kurz:       Fehlende Remotes immer syncen, ausser Cluster
  anker:      memory feedback_always_sync_missing_remotes_except_cluster.md (Direktive verbatim, Ausnahme Cluster-git wegen Plain-Text-Cred-Vault, halbfertige Klone auf Pi 5 und node1 fixen) + DOSSIER Abschnitt 1 (Cluster-git wird nie redigiert/out-of-house gegeben)

NR 741 | jsonl:56945 | klasse=operativ
  kurz:       Steuerbefehl weiter wie geplant

NR 742 | jsonl:56998 | klasse=operativ
  kurz:       Kontrollfrage Cluster-git development gepullt

NR 743 | jsonl:56999 | klasse=operativ
  kurz:       Kontrollfrage war der Lauf aktuell

NR 744 | jsonl:57108 | klasse=delta
  kurz:       Infos aktiv an Infra-Agent pushen
  delta_text: Du musst an den infra agenten pushen sonst sieht er es nicht.
  konsequenz: Regel der Agenten-Koordination fehlt im Referenz-Stand: DOSSIER Abschnitt 10 fuehrt zu Agenten nur ASCII-Pflicht, Spawn-Duplikat-Falle und 'bei Meldungs-Kreuzung git-Ist-Stand als Wahrheit', aber NICHT die Bring-Pflicht (Erkenntnisse/Auftraege muessen dem anderen - hier dem Infra-Agenten - aktiv zugestellt werden, sonst bleiben sie fuer ihn unsichtbar). Konsequenz: Ergebnisse, die nur im Manager-Kontext oder in Dateien liegen, gelten faelschlich als kommuniziert; Handover an Infra (Vault/Storage/overleaf-Merge, Board #2) kann still ins Leere laufen.
