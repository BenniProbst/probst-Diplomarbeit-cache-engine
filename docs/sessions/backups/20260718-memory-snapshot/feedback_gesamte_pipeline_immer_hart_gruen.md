---
name: feedback_gesamte_pipeline_immer_hart_gruen
description: "Die GESAMTE CI-Pipeline muss IMMER hart grün sein — kein roter Job, kein allow_failure-Freibrief, keine \"meist grün\"-Toleranz"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-17, verbatim):** „die gesamte pipeline IMMER hart grün sein muss."

**Why:** Verschärft die reaktivierte Dual-Verifikation ([[feedback_dual_verifikation_baremetal_lokal_und_ci_synchron_gruen]]):
nicht „test:unit grün genügt" und nicht „prod1 grün, prod2 egal". JEDER Job der GESAMTEN Pipeline (ce UND super,
prod1/AMD UND prod2/Intel, alle Stages lint/build/sanitize/contract/test/chaos) muss grün sein. Ein einziger roter
Job = Pipeline nicht hart grün = Increment nicht abgeschlossen. Kein allow_failure als Ausrede (die bestehenden
allow_failure-Jobs arm64-smoke/is_original:relock sind höchstens infra-gated-Ausnahmen, kein genereller Freibrief —
im Zweifel adressieren, nicht tolerieren). Anlass: die 2c-Pipeline war rot (prod2-Jobs + test:unit-Layout-Check);
ich hätte „prod1 grün" fast als genug behandelt — genau das ist verboten.

**How to apply:** Je Increment die GESAMTE Pipeline (via admin-mgmt-PAT read-only, [[reference_gitlab_pat_format_dots_regex]])
literal auf `status=success` prüfen — nicht nur einzelne Jobs, nicht nur prod1. Bei JEDEM roten Job: Ursache
diagnostizieren (Job-Log via API), fixen (kein Deferral außer echtem Infra-Block = Modus a), CI erneut grün
bestätigen. Erst wenn ce+super-Pipeline beide `status=success` (hart) sind, ist der Increment lokal-UND-CI-dual-grün
und abgeschlossen. „nie ✓ ohne wörtliche Tool-Ausgabe" gilt auch hier — den `status=success` literal zeigen.
