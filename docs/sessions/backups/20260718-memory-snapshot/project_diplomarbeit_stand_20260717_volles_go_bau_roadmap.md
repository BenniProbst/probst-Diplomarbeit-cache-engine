---
name: project_diplomarbeit_stand_20260717_volles_go_bau_roadmap
description: "2026-07-17 VOLLES GO — alle Architektur-Entscheide getroffen (Q1-Q5 + DLL-Load-B + H-6..H-10 + Planer-Forks); nächster Schritt = BAUEN, keine Rückfrage; Ledger §19 = Einstieg; Roadmap INC-0→INC-1→INC-2"
metadata:
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Stand **2026-07-17** (Kontext-Ende): der User gab **VOLLES GO** — „GO für Q1-Q5, volles GO für DLL-Load Option B, VOLLES GO sonst. Warte auf alle Workflows, bevor du baust." **Alle offenen Architektur-Entscheide sind damit getroffen** (Q1-Q5-Mapping, DLL-Load=Option B, H-6..H-10, Planer-Codegen-Forks PF1-4, Set-Ebene-1-Promotion, Telemetrie/Scheduling-System-Achsen, golden-Umbau, Serialisierung Q1-Q4). **Beide laufenden Arbeiten sind gelandet + verbucht:** F6-Nachzieh (ce `871f6d2e`, super `8488d1d`; `ctsha.hpp` ehrlich NICHT deprecated=LEBT) + §18-Voll-Konsolidierung + §19-Kontextübergabe ins Ledger eingepflegt (super `53cbecf`, beide Remotes ref-gleich, clean).

**Der EINSTIEG für die nächste Sitzung = Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` §19** (HIER ZUERST LESEN) + §18 (Voll-Konsolidierung) + §16/§17.

**Bau-Roadmap (VOLLES GO liegt vor — KEINE Rückfrage, direkt bauen):**
- **INC-0 (deadline-kritisch):** DLL-Load Option B — `link_libs`-Kanal in `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) + Fassaden-Bake `$<TARGET_FILE:comdare::vendor_mimalloc>`; ABI-4-kompat; entsperrt echte Messwerte (`measured>0`).
- **INC-1:** CEB-System-Achsen-Schichtung (die 4 System-Achsen als gemeinsame Schicht ÜBER den 19 Organ-Achsen; heute flach).
- **INC-2:** der EINE koordinierte 4→5-ABI-Bump am Experiment-Planer-Dock (Set-F1b + Telemetrie-System-Achse + Scheduling-CT-#37 + Prüf-Dock-unify + H-7-`-march` + golden-Neubau messdaten-erhaltend; Design `F12III-DESIGN-VORLAGE.md`) — der EINE reservierte Major-Bump (TABU-GO).
- Danach: Planer-Codegen (F5), Serialisierung, Debug/Mess-Schalter, F12iii-Design.

**Why:** das Board ist volatil; ohne diese Orientierung würde der nächste Kontext fälschlich Entscheide für offen halten und erneut fragen, statt zu bauen.

**AKTUALISIERUNG 2026-07-17 (später am Tag):** Der User hat den Bau-Ablauf präzisiert — JEDE Aufgabe wird erst per **ultracode-Planungssession** über Ledger + ALLE Plandokumente vorbereitet, und die **Bau-Phase wird danach EXPLIZIT freigegeben** (siehe [[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]]). Der INC-0-Bauplan liegt in `docs/sessions/backups/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md`; Ledger-Einstieg ist jetzt **§20** (Nach-GO-Verbuchung) → §19. **§0-GOAL-V6 ist AKTIV** (LEDGER:75-118, super `bf8a7ca`; V5 SUPERSEDED): Arbeitsprogramm = Bau-INC-0→1→2, Prozess-Regeln V6.3 (Planungssession je Aufgabe + Bau-Release-Gate je Phase + Lesereihenfolge §20→ + reguläre Ledger-Updates [[feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere]]), TABU präzisiert V6.5 (hart vs. GO-Fenster nur Bau-INC-2), /goal-Steuertext = V6.9.

**How to apply:** nächste Sitzung → §20+§19+§18+§17+§16 lesen, git-Stand verifizieren; INC-0 bauen NUR wenn die explizite Bau-Freigabe des Users vorliegt (sonst Bauplan vorlegen und auf Freigabe warten); volle Verifikations-Kadenz je Increment. Deadline **28.07.2026** (CI UND standalone messfähig). Siehe [[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]], [[feedback_open_decision_first_reread_ledger_and_plandocs]], [[project_diplomarbeit_stand_20260712_freigaben_pipeline]].
