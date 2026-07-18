---
name: feedback_immer_ledger_zuerst_lesen_vor_handeln
description: "Bei JEDEM Thema IMMER zuerst den passenden Ledger-Abschnitt (architektur-ziele-offene-punkte-ledger.md) lesen, BEVOR gehandelt/mutiert wird — nicht nur die Übergabe/Memory, sondern den Single-Source-Ledger selbst"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

User 2026-06-25 (während des MinIO-Cache-Stacks): **„Bitte merke dir, dass du immer zuerst zu einem Thema das Ledger liest, bevor du handelst."**

**Why:** Das Ledger `cluster_development/docs/sessions/architektur-ziele-offene-punkte-ledger.md` ist die autoritative Single-Source (bei Widerspruch schlägt es CLAUDE.md/Übergaben/Memory). Es enthält pro Thema den exakt geerdeten Plan + Feldspezifika + Fallstricke + den verifizierten Ist-Stand. Nur die Session-Übergabe oder ein Memory zu lesen reicht NICHT — Details/Korrekturen stehen im Ledger und verhindern vermeidbare Fehler (z.B. os-haproxy-Objekt-Feldnamen).

**How to apply:** Vor dem ERSTEN Tool-Eingriff zu einem Thema: den zugehörigen Ledger-Block grep/lesen (`grep -n` nach Task-Nummer / Service-Name / „K81-NN"-Block). Erst danach planen + mutieren. Gilt zusätzlich zu [[feedback_thorough_assumptions_workflow_planning]] und [[feedback_never_guess_always_lookup_state_of_art_and_docs]]. Nach getaner Arbeit den Ledger fortschreiben (TODO→done mit Evidenz).
