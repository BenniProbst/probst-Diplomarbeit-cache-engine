---
name: feedback_autonomous_measurement_via_ci_job_authorized
description: "Ab 2026-07-11: autonomes MESSEN ist via CI-als-Job freigegeben — die golden-320-/Coverage-Vollmessläufe dürfen autonom als CI-Job getriggert werden. Bei unbekannten Punkten cross über die 4 Projekte mit ultracode recherchieren; alles ist da, geplant und definiert."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-11 (Erweiterung des autonomen GO):** „Du darfst ab jetzt **autonom messen mithilfe der CI als
Job**, und fährst aufgrund dessen autonom fort und recherchierst unbekannte Punkte in den 4 Projekten cross mit
ultracode. Es ist alles da und geplant und definiert."

**Was das ändert:** Der golden-320-Vollmesslauf + der Coverage-Vollmesslauf sind **nicht mehr user-gated** — ich darf
sie **autonom als CI-Job triggern** (die Messung läuft als Pipeline-Job auf dem Cluster-Runner, z.B. der PMC-Job auf
prod-baremetal mit echtem `perf_event_open`). Der g++-Linux-E4-Weg ist E2E bewiesen (11.07.-Pilot: 323-Zeilen-CSV mit
echten Messwerten), also ist der Voll-Lauf technisch abgesichert.

**Wie anwenden:**
1. **Messläufe autonom via CI triggern** (nicht lokal auf der prod1-Shell blockieren): die Mess-Pipeline/den Job
   anstoßen, dann NICHT aktiv pollen ([[feedback_prod_ci_measurement_multiday_experiment]]) — der Lauf ist mehrtägig;
   Ergebnisse per Job-Abschluss/Artefakt einsammeln. Cluster nur lesend/über die Pipeline
   ([[feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra]]).
2. **Unbekannte Punkte** in den 4 Projekten (ce, super, prt-art, thesis) **cross mit ultracode recherchieren** statt zu
   raten ([[feedback_ultracode_workflow_for_uncertainty_and_absolute_claims]], [[feedback_consult_analysis_backups_via_ultracode_before_decisions]])
   — „alles ist da, geplant und definiert", also die vorhandenen Pläne/Dossiers/Backups zuerst konsultieren.
3. **Autonom fortfahren** durch den Rest-Stack (P6, Design-gated-Tasks, golden-/Coverage-Läufe) — der User hat „alle
   übrigen Punkte komplett selbst erledigen" freigegeben (vgl. [[feedback_production_track_full_golden_run_finds_errors]]).

Siehe [[feedback_only_one_official_xml_driven_program_no_behelfswege]] (der Mess-Job läuft über den EINEN offiziellen
messung_driver-XML-Weg).
