---
name: project_handout_ap1_15_code_nachzug_audit_20260702
description: "Text-Agent-Handout 2026-07-02 — 15 APs Code-zieht-nach (Audit 151 Claims), Tasks"
metadata: 
  node_type: memory
  type: project
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**Quelle (autoritativ, VOR AP-Arbeit lesen):** `thesis/diplomarbeit/sessions/2026-07-02-handout-implementierungsagent-audit-code-todos.md` + Audit `2026-07-02-audit-thesis-vs-code.md` (ultracode, 151 Claims: 99 OK / 50 divergent). Grundsatz User: „Thesis beschreibt den faktischen Sollstand — Code zieht nach." §1 des Audits (Text→Code, P4-P7) ist bereits vom Text-Agenten erledigt — NICHTS tun.

**Tasks eingereiht 2026-07-02:** AP-1→#235 … AP-15→#249 (1:1, Details je Task-Description). P0 = AP-1..7 (#235-#241) blocken #156 (M3-Lauf); **AP-1 (#235, POD branch_misses+throughput = ABI-Bruch) und AP-7 (#241, SwissTable-S22 ändert T0-Registry/Permutations-Baum) blocken zusätzlich #215** (FREEZE/320-Neubau). AP-12 (#246) blockedBy AP-2 (#236). AP-14 (#248) blockedBy #215+#156. AP-9 (#243) MIT AP-1 in einem Zug (ein Schema-Bruch statt zwei). Wellen-Plan: neue **W4.5** zwischen W4 und W5 (in #149-Description verankert).

**User-Entscheidungsmatrix (BINDEND, 2026-07-02):**
- P1 CSV: BEIDES — 16-Spalten-Basis bleibt UND branch_misses + throughput_ops_per_sec kommen dazu (Cycles ist schon Spalte 6).
- P2 Profile: ALLES als XML definierbar → 33/33 SOTA (fehlend P08 ARTSync/P09 LOUDS/P33 VAMPIR) + 23/23 Allokator.
- P3 Hash: SwissTable + Knuth-OA = **zwei getrennte permutierte T0-Bausteine** (S14 + neu S22), je Permutation genau einer; KEINE is_original-Bindung „derselben" Gegenprobe. T0-Zählung→22; Text-Agent passt 21er-Nennungen NACH Landung an.
- P4-P7: Code hatte recht → Text angepasst, kein Code-Handlungsbedarf.

**Fallstricke:** AP-11 widerspricht #136-completed (Audit zählt 8 lp_* statt 14) → erst Verzeichnis/Naming klären. AP-8 vendort HdrHistogram_c unter ext/ → NEUER Unterordner ok (Boost.MP11-Konvention), bestehende ext/** bleiben tabu. Legacy `measurement_writer.hpp` NICHT erweitern (AP-1 zielt auf kanonischen Record). Rückmeldung je AP: 1-Zeilen-Status + Beleg in Ledger/Session-Handoff; Text-Agent zieht Thesis-Feinanpassungen nach.

Verwandt: [[reference_188_4b_pool_family_store_traversable_design]] · [[feedback_messdaten_nie_loeschen_abi_darf_brechen]] · [[feedback_tasks_list_is_user_visible_todo_keep_current]]
