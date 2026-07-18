---
name: feedback_autonomous_overnight_note_open_decisions_for_morning
description: User geht schlafen/offline → so weit autonom wie möglich weiterarbeiten (nur entschiedene/golden-neutrale Increments bauen; Neu-Architektur/ABI nur als Design-Vorlage); offene Entscheidungen gesammelt für den Morgen an EINER Stelle notieren
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Wenn der User schlafen geht / offline geht (z.B. „ich gehe ins Bett, mach so weit autonom wie du kannst") — Modus (User 2026-07-16, „merke dir das"):

- **So weit autonom wie möglich weiterarbeiten** — BAUEN, was ENTSCHIEDEN + golden-neutral ist (keine NEUE Architektur-Entscheidung, kein golden/ABI-Bruch, kein offener User-Fork). Neu-Architektur-/ABI-/golden-Berührendes NUR als **Design-Vorlage vorbereiten**, NICHT bauen (Design-VOR-Bau-Pflicht bleibt).
- **Offene Entscheidungen gesammelt für den Morgen** an EINER klaren Stelle notieren (Ledger + Handover-Abschnitt „MORGEN-ENTSCHEIDUNGEN"), damit der User morgens „den Rest entscheidet".
- Volle Kadenz + TABU + literale Verifikation je Increment unverändert; nichts Riskantes/Irreversibles ohne GO; beide Remotes; nie pollen.
- Den autonomen Loop über Hintergrund-Agenten am Leben halten (Increment landet → verbuchen → nächsten entschiedenen Increment dispatchen), bis der buildbare Vorrat erschöpft ist; dann den Morgen-Handover schreiben.

**Why:** der User will Nacht-Fortschritt ohne Blockade + eine lückenlose Morgen-Entscheidungsliste.

**How to apply:** entschiedene/golden-neutrale Increments (z.B. F1a-Vokabular, BRÜCKE-Increments, E16-Tilgung, read-only-Verifikation) autonom bauen+verifizieren+committen; ABI/golden/Neu-Arch (F1b-Ebene-1-Bump, F2/F3, #37, H-1-Hardware-Bau, Planer-CI/cmake-Codegen, F12iii) als Design-Vorlage sammeln; am Ende „MORGEN-ENTSCHEIDUNGEN" konsolidieren. Siehe [[feedback_open_decision_first_reread_ledger_and_plandocs]], [[feedback_goal_driven_autonomie_shells_monitore_beenden]].
