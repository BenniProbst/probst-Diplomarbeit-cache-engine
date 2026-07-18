---
name: feedback_production_track_full_golden_run_finds_errors
description: "Ab 2026-07-11 Produktions-Anspruch: das Gesamt-Mess-System ist FERTIG; Fehler erkennen wir nur, indem wir es VOLL durchlaufen lassen (golden-320 real durchmessen, cross-platform Linux/macOS/Windows). Nicht mehr Feature-bauen, sondern den vollen Produktions-Durchlauf treiben + dabei Fehler finden+beheben."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-11:** „Wir sind jetzt mit dem **Anspruch auf Produktion** unterwegs." Das Gesamtsystem ist
**fertig gebaut** — die verbleibende Arbeit ist NICHT mehr Feature-Entwicklung, sondern:

1. **Den vollen Mess-Ablauf REAL durchlaufen lassen** — eine golden-320-XML (`m3v2_study.profile.xml`) über den EINEN
   offiziellen XML-getriebenen Weg ([[feedback_only_one_official_xml_driven_program_no_behelfswege]]) tatsächlich
   durchmessen (Codegen → ~320 Tier-Binary-DLLs → Load → Measure → CSV → LaTeX). **Erst der volle Durchlauf deckt die
   echten Fehler auf** — genau wie die 8 Mess-Defekte bei #221, die erst zur #156-Mess-Laufzeit manifestierten.
2. **Cross-Platform** (Linux/macOS/Windows) — der Cluster ist bereit (prod1 Linux baremetal, PMC real bestätigt:
   L1-Misses/dTLB live via `perf_event_open`). run_lazy_150 **baut+validiert bereits auf Linux** (golden-320-Config
   `VALIDAT OK`); die Portierung ist die Orchestrierungs-Ebene, nicht der C++-Kern.
3. **Fehler sofort beheben** — im Produktions-Durchlauf gefundene Defekte sind echte Mess-Fehler; sie kommen oben auf
   den Stack, bis der volle golden-320-Durchlauf sauber grün durchläuft.

**Konsequenz für die Arbeitsweise:** Der „autonom-buildbare Rest ist erschöpft"-Modus (Coverage-Tests, Vorbauten) ist
**abgelöst** durch den Produktions-Durchlauf-Modus. Der Wert liegt jetzt im VOLLEN Lauf + der Fehlerbehebung, nicht in
weiteren Einzel-Increments. Siehe [[feedback_prod_ci_measurement_multiday_experiment]] (der Voll-Lauf ist mehrtägig —
nie aktiv pollen) + [[feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra]] (Cluster-Läufe via Pipeline/Runner).

**Cluster-Zugang (11.07.):** Der User hat das **Cluster-Key-Vault** freigegeben (`~/Projekte/Cluster/keys/
CREDENTIALS-VAULT.md`, gültiger root-Admin-glpat) für autonome GitLab-API-Arbeit. NIE Token ausgeben/committen.
