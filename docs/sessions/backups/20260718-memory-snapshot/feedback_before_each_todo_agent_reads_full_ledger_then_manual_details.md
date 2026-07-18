---
name: feedback_before_each_todo_agent_reads_full_ledger_then_manual_details
description: "Pflicht-Prozess vor JEDER TODO-Bearbeitung (User 08.07.): (1) das GESAMTE Ledger mit einem Agenten gründlich lesen (Agent-gestützt, voller Kontext), (2) DANN mit den Hinweisen aus dem Ledger die Details gezielt MANUELL lesen. Erst dann arbeiten."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-08, bei der Freigabe „alle angezeigten TODO frei"):** „bitte merke dir immer vorher genau das gesamte Ledger mit Agenten gründlich zu lesen und dann mit den Hinweisen die Details gezielt manuell zu lesen."

**Pflicht-Prozess VOR jeder TODO-/Increment-Bearbeitung:**
1. **Ledger gesamt via Agent:** einen Agenten (Explore/general-purpose) das GESAMTE `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Single-Source, sehr groß) gründlich lesen lassen — er extrahiert den relevanten Kontext + die Hinweise zum anstehenden TODO (Definitionen §13.10-W-Regeln, §13.9-Entscheide, §12-Verlauf, TABUS, Fork-/Gate-Status).
2. **Details gezielt manuell:** mit den vom Agenten gelieferten Hinweisen (datei:zeile/Doc-Verweise) die konkreten Stellen SELBST manuell lesen (Code/Doku/golden) — für Präzision + Verantwortung (Agent-Zusammenfassung genügt für die Bearbeitung nicht).

**Why:** Das Ledger ist Single-Source + zu groß für vollen Direkt-Kontext; der Agent sichert Vollständigkeit (kein übersehener Entscheid/Tabu/Definitions-Korrektur), das manuelle Detail-Lesen sichert die Kadenz-Präzision (nie raten, [[feedback_never_guess_always_lookup_state_of_art_and_docs]], [[feedback_goal_hook_thorough_read_in_never_guess]]). Verhindert C1-Fehler (pauschale Behauptung ohne Slice-Beleg) und stale-Ledger-Fallen ([[feedback_immer_ledger_zuerst_lesen_vor_handeln]]).

**How to apply:** Bei jedem freigegebenen TODO diese 2 Stufen VOR dem ersten Edit. Der Agent liest das Ledger gesamt (nicht nur §12), meldet Hinweise; ich lese die genannten Details manuell; erst dann Dossier→Bau. Gilt besonders für die 08.07. freigegebenen Board-Punkte (#13/#28/#29/#31/#32/#38/#46 + golden-HELD #156/#215/#216 mit fresh-context + Voll-Review + additiver golden-Präferenz).
