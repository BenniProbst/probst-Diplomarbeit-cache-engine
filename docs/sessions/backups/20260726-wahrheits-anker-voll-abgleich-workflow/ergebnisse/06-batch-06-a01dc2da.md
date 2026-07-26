# 20260726-wahrheits-anker-voll-abgleich-workflow / batch-06 (agent a01dc2da)

runId: wf_0874d74a-003
agentId: a01dc2da9a5fe6bd7
label-Zuordnung: batch-06 (Prompt-Marker-Deckung 100%)

---

BATCH batch-06 - 62 Eintraege

NR 311 | jsonl:17614 | klasse=obsolet
  kurz:       GO fuer #28/#29/#31 plus 4-Layer-ultracode
  anker:      project_e1_e4_experiment_maschinerie_und_konsolidierung (Phase 0 + Phase 0.5=G2 VOLLZOGEN, #31-Insel forward-revertiert); Regel 'ultracode-Planung vor jeder Aufgabe' = feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs

NR 312 | jsonl:17615 | klasse=delta
  kurz:       Rote Pipeline nie als transient annehmen
  delta_text: Uebrigens ist die Pipeline wirklich rot und du musst sie echt beheben, es war falsch anzunehmen, das waeren transiente Fehler. Seit 9053 geht nichts mehr ... schon seit 9 Stunden
  konsequenz: Der Referenz-Stand fordert nur 'GESAMTE Pipeline hart gruen' und erlaubt fuer Cold-ICE ausdruecklich 1x Retry (reference_ci_runner_ice_cold_cache_instability). Die vom Owner gesetzte Beweislast-Regel - eine rote Pipeline darf NIE als transient deklariert werden, Transienz muss belegt werden, sonst Root-Cause-Pflicht - ist nirgends als Direktive persistiert. Risiko: Agenten stufen echte Dauerdefekte wieder als Flake ein (Stunden Stillstand).

NR 313 | jsonl:17788 | klasse=operativ
  kurz:       Task-Notification Pipeline-Hintergrundlauf

NR 314 | jsonl:17972 | klasse=verankert
  kurz:       Echte Ursache finden und beheben
  anker:      feedback_no_quick_fixes + feedback_max_tiefe_bei_problemen_saubersten_zustand; DOSSIER 20260726 §2 'Keine Quick-Fixes/Behelfswege'

NR 315 | jsonl:17973 | klasse=verankert
  kurz:       Maximale Tiefe, saubersten Zustand hinterlassen
  anker:      feedback_max_tiefe_bei_problemen_saubersten_zustand.md (Ursprungs-Direktive, MEMORY-Index 'Fehlbau ebenen-richtig'); DOSSIER §2

NR 316 | jsonl:17974 | klasse=delta
  kurz:       Sichtbare TODO-Liste in Stack-Form
  delta_text: Bitte lege dazu eine sichtbare TODO Liste in stack form an
  konsequenz: feedback_tasks_list_is_user_visible_todo_keep_current fordert nur 'Tasks-Liste = user-sichtbare TODO, staendig aktuell'. Die Darstellungs-/Abarbeitungs-Form STACK (Stapel: zuletzt aufgelaufener Punkt oben, LIFO-Abbau; Rest-Stack = noch offen) ist nicht persistiert. Risiko: Fortschritts-Meldungen ohne Stack-Sicht, Owner verliert die vom ihm verlangte Steuer-Ansicht.

NR 317 | jsonl:18034 | klasse=obsolet
  kurz:       prod2-Key auf Desktop oder Vault
  anker:      feedback_infra_autonomie_freigabe_cluster_reserviert (Zugangsweg prod2 verifiziert 19.07.: admin-management@10.0.10.212 via sshpass/sudo-nopass, PW im PROD-Vault) + DOSSIER §1 Root-Wege/Vault-Pfade - der Key-Weg ist durch den verifizierten Passwort-Weg ueberholt

NR 318 | jsonl:18045 | klasse=operativ
  kurz:       Task-Notification prod2-Log-Diagnose

NR 319 | jsonl:18095 | klasse=operativ
  kurz:       Task-Notification 4-Layer-Analyse-Workflow fertig

NR 320 | jsonl:18105 | klasse=verankert
  kurz:       Workflow plus Rohdaten in sessions-Backup sichern
  anker:      feedback_backups_only_workflow_rawdata_never_sessions_plans + feedback_raw_data_backups_additive_never_delete; DOSSIER §8 ERHEBUNGS-WORKFLOWS (alle in backups/ persistiert)

NR 321 | jsonl:18258 | klasse=operativ
  kurz:       Task-Notification prod2-Hang-Inspektion

NR 322 | jsonl:18309 | klasse=operativ
  kurz:       Task-Notification Compiler-Hang-Beweis

NR 323 | jsonl:18745 | klasse=verankert
  kurz:       Workloads runtime, Achsen-Algorithmen compile-time
  anker:      feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert (Punkt 2/3: Framework x Workload = eigene Bibliothek-Kategorie/Runtime-Achse W, XML treibt die statischen Haupt-Achsen-Limits compile-time); DOSSIER 3.3 R1 (CT/RT als XOR, stufen-relativ)

NR 324 | jsonl:18885 | klasse=delta
  kurz:       Zwei obere Schichten liegen im Diplomarbeit-Code
  delta_text: Ja das ist fuer die cache engine korrekt, aber wir arbeiten ja an den 2 Schichten oben drueber an der Diplomarbeit code. Wir hatten schon mal was von 4 layern gesagt, bitte suche das gezielt
  konsequenz: Der persistierte Anker (project_e1_e4) sagt ausdruecklich, das Layer-Modell habe NICHTS mit Projekt-/Repo-Grenzen zu tun, und verortet E3 (Permutations-Baum, GenusBindingTraits) ce-seitig. Der Owner-Kern verortet dagegen die ZWEI obersten Schichten im Diplomarbeit-Code OBERHALB der cache engine. Diese Repo-Zuordnung der Layer ist nicht abgeglichen - Folge: Schicht-Arbeitspakete koennen im falschen Repo geschnitten werden (genau die Fehlerklasse der ce-internen '4 Schichten'-Falle).

NR 325 | jsonl:18899 | klasse=verankert
  kurz:       Architektur top-down durcharbeiten
  anker:      feedback_e_schichten_separat_fertigstellen_top_down (Reihenfolge top-down E4->E3->E2->E1, E0 zuletzt; ORIGIN 28.06. SESSION-ENDE-9 §7 / ce-Dossier §16)

NR 326 | jsonl:18900 | klasse=verankert
  kurz:       Diplomarbeit stellt Profil-XML, CE fuehrt aus
  anker:      feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert Punkt 3 (XML autoritativ, CEB liest sie zu SEINER Laufzeit) + project_e1_e4 (Ziel #229: die Diplomarbeit aendert NUR die XML)

NR 327 | jsonl:18915 | klasse=verankert
  kurz:       CE liefert Bibliothek zur Profil-Interpretation
  anker:      feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert (CEB interpretiert/orchestriert, Framework x Workload als CE-Bibliothek-Kategorie); project_e1_e4 (E4->E3->E2-Kette)

NR 328 | jsonl:19007 | klasse=operativ
  kurz:       Task-Notification Memory-Kartierungs-Agent

NR 329 | jsonl:19063 | klasse=operativ
  kurz:       Planmodus, Plan neu machen

NR 330 | jsonl:19064 | klasse=operativ
  kurz:       Bare Gate-Freigabe G1

NR 331 | jsonl:19065 | klasse=operativ
  kurz:       Bare Gate-Freigabe G3

NR 332 | jsonl:19066 | klasse=verankert
  kurz:       Neuplanung gegen Architektur-Doku der Diplomarbeit
  anker:      feedback_diplomarbeit_design_ist_quelle_der_implementierung (LaTeX/Design = Primaerquelle) + DOSSIER Autoritaets-Kette (Owner-KERN > Dossier > Session-Docs > Bauplaene > Ist-Code)

NR 333 | jsonl:19080 | klasse=delta
  kurz:       Layer-Modell muss Projekt-Bezug haben
  delta_text: laut der Planung der letzten 5 Tage ist die Layer Architektur immer noch falsch, weil sie nichts mit den Projekten zu tun hat
  konsequenz: Der Anker project_e1_e4 formuliert genau umgekehrt ('autoritativ ist E1-E4, NICHT die 4 Teilprogramme/Repos'). Das Owner-Kriterium - eine Layer-Architektur OHNE Bezug zu den Projekten ist FALSCH - ist damit nicht persistiert bzw. steht im Widerspruch. Folge: die geforderte Projekt-Verortung je Schicht (Naht super <-> ce) bleibt undokumentiert und wird bei Lane-Schnitten wieder verletzt.

NR 334 | jsonl:19081 | klasse=operativ
  kurz:       Auftrag: top-down-Konzept suchen

NR 335 | jsonl:19088 | klasse=obsolet
  kurz:       G2 bedingt freigegeben bei korrekter Architektur
  anker:      project_e1_e4 ('Phase 0.5=G2 VOLLZOGEN, ce 8c73ef7c / super f01bdaa, CI 9155/9154, 3/3 Striktheits-Guards gruen') - Gate erledigt

NR 336 | jsonl:19136 | klasse=verankert
  kurz:       Ledger-TODOs ab 28.06. gegen Ist auditieren
  anker:      project_e1_e4 (Audit-Ergebnis '13 echt / 8 teilweise / 1 schein', #31 als einziger aktiver Fehlbau) + feedback_goal_scheint_erledigt_ultracode_verifikation

NR 337 | jsonl:19137 | klasse=operativ
  kurz:       Bestaetigung: dann planen wir

NR 338 | jsonl:19594 | klasse=operativ
  kurz:       Task-Notification g++-16-Build golden-Konsumenten

NR 339 | jsonl:19618 | klasse=operativ
  kurz:       Task-Notification Metaprog-Striktheits-Guards

NR 340 | jsonl:19732 | klasse=operativ
  kurz:       Task-Notification G2-Pipeline-Monitor

NR 341 | jsonl:19819 | klasse=verankert
  kurz:       Diplomarbeit-LaTeX enthaelt alle Architektur-Details
  anker:      feedback_diplomarbeit_design_ist_quelle_der_implementierung (MEMORY-Index 'LaTeX=Primaerquelle->research')

NR 342 | jsonl:19849 | klasse=operativ
  kurz:       Task-Notification super-main-Pipeline-Monitor

NR 343 | jsonl:19892 | klasse=operativ
  kurz:       Task-Notification CEB-Bauorchestrierung-Kartierung

NR 344 | jsonl:19905 | klasse=operativ
  kurz:       GO fuer weitere Ausfuehrung

NR 345 | jsonl:20012 | klasse=operativ
  kurz:       Task-Notification Selbst-Verifikation fehlgeschlagen

NR 346 | jsonl:20348 | klasse=operativ
  kurz:       Task-Notification Phase-2-Agent gestoppt

NR 347 | jsonl:20378 | klasse=obsolet
  kurz:       Codex soll auf 5.5/xhigh laufen
  anker:      feedback_selbst_implementieren_ab_20260710_codex_abgeloest (Codex-Erstimplementierung abgeloest; codex_*-Memories stale) - Codex-Konfiguration ohne Wirkung mehr

NR 348 | jsonl:20390 | klasse=obsolet
  kurz:       Codex-Default xhigh/5.5 per Parallel-Agent
  anker:      feedback_selbst_implementieren_ab_20260710_codex_abgeloest; Delegations-Regel selbst = feedback_implementierung_an_opus_delegieren_fable_als_architekt

NR 349 | jsonl:20419 | klasse=operativ
  kurz:       Task-Notification Codex-Default-Agent fertig

NR 350 | jsonl:20566 | klasse=operativ
  kurz:       Kontext endet, Uebergabe optional

NR 351 | jsonl:20751 | klasse=verankert
  kurz:       E4-E1-Originaldokument, Schichten separat fertigstellen
  anker:      feedback_e_schichten_separat_fertigstellen_top_down (woertliches Zitat 'Das System ist fuer multiple Ebenen gleichzeitig zu gross' + ORIGIN-Dokumente 20260628 SESSION-ENDE-9 §7 und ce-KONTEXT-DOSSIER §13/§16)

NR 352 | jsonl:20809 | klasse=obsolet
  kurz:       Codex-Erstimplementierung, Review Zeile fuer Zeile
  anker:      feedback_selbst_implementieren_ab_20260710_codex_abgeloest ('Erstimplementierung macht Claude ab sofort SELBST', ersetzt feedback_codex_implements_from_dossier_claude_corrects); erhalten bleiben elaborierte Dossiers + adversarialer Review je Increment

NR 353 | jsonl:20821 | klasse=verankert
  kurz:       Design der Diplomarbeit ist Implementierungs-Quelle
  anker:      feedback_diplomarbeit_design_ist_quelle_der_implementierung

NR 354 | jsonl:20874 | klasse=verankert
  kurz:       ultracode ueber sessions-Backups spart Tokens
  anker:      feedback_consult_analysis_backups_via_ultracode_before_decisions (MEMORY 'Erst Analyse-Backups') + DOSSIER §8 (Rohdaten+Synthese je Workflow in backups/)

NR 355 | jsonl:21061 | klasse=operativ
  kurz:       Task-Notification Pipeline-9216-Poll

NR 356 | jsonl:21210 | klasse=operativ
  kurz:       Agent-Message E4-Kartierungs-Rohbericht

NR 357 | jsonl:21273 | klasse=operativ
  kurz:       Task-Notification Verifikations-Build 4 Targets

NR 358 | jsonl:21292 | klasse=operativ
  kurz:       Task-Notification Reconfigure plus ctest

NR 359 | jsonl:21316 | klasse=operativ
  kurz:       Task-Notification v31_adapters-Nachbau

NR 360 | jsonl:21340 | klasse=operativ
  kurz:       Task-Notification super-Sub-Build messung_driver

NR 361 | jsonl:21353 | klasse=verankert
  kurz:       E4-Semantik, Mess/Auswertungs/Arbeitsmodus, Hot-Tier-Switch
  anker:      feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md (woertlich persistiert: E4=abstrakteste Anwender-Ebene, E1/E0=praeziseste Detailimplementierung; Messmodus->Auswertungsmodus mit Workload-CLUSTER per deep research->Arbeitsmodus hot im RAM, Hot-Switch auf ABI-stabiles Interface; plus Dossier-19-Teil-G und 4. Modus HYBRID); MEMORY-Index 'CEB 3 Modi+Hybrid; Dossier 19'

NR 362 | jsonl:21354 | klasse=verankert
  kurz:       Ein grosser Review je Schicht, Backup gesichert
  anker:      feedback_e_schichten_separat_fertigstellen_top_down, ERGAENZUNG User 09.07. abends (b) Review-Kadenz je Schicht: genau EIN grosser adversarialer Review-Workflow, Rohdaten+Synthese je eigener Backup-Ordner unter super docs/sessions/backups/

NR 363 | jsonl:21355 | klasse=obsolet
  kurz:       Codex war nicht abgelehnt, volles GO
  anker:      feedback_selbst_implementieren_ab_20260710_codex_abgeloest (Codex-first-Kadenz einen Tag spaeter widerrufen: hing 1800s, bwrap-Defekt prod1, Token-Ersparnis traegt nicht mehr)

NR 364 | jsonl:21393 | klasse=operativ
  kurz:       Task-Notification E4-Review-Workflow-Ergebnis

NR 365 | jsonl:21529 | klasse=operativ
  kurz:       Task-Notification Re-Verifikation nach Fixes

NR 366 | jsonl:21562 | klasse=operativ
  kurz:       Task-Notification beide Pipelines gepollt

NR 367 | jsonl:21648 | klasse=operativ
  kurz:       Task-Notification Pipeline-9225-Poll

NR 368 | jsonl:21657 | klasse=operativ
  kurz:       Task-Notification Pipeline-9225-Poll Runde 2

NR 369 | jsonl:21720 | klasse=operativ
  kurz:       Task-Notification Pipelines 9229 und 9231

NR 370 | jsonl:21729 | klasse=operativ
  kurz:       Task-Notification Pipeline-9229-Poll

NR 371 | jsonl:21781 | klasse=operativ
  kurz:       Task-Notification E3-Test-Verifikation

NR 372 | jsonl:21792 | klasse=operativ
  kurz:       Task-Notification E3-Review-Workflow-Ergebnis
