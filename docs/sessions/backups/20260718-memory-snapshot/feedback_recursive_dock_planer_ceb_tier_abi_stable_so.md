---
name: feedback_recursive_dock_planer_ceb_tier_abi_stable_so
description: "Rekursive Dock-Architektur — Experiment-Planer-Dock ↔ CEB (ABI-stabile .so, system-achsen-versioniert) ↔ CEB-Prüfdock ↔ Tier-Binary (.so); je C++23-ABI-stabil mit Vertrag; CEB erst auf Gattungs-Observer+Module kompiliert (System-Konfig → Mess-Achsen-heuristik)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Die definitive Bau-/Konstruktions-Topologie der Anlage (User 2026-07-17, „um ganz sicher zu gehen") = eine **REKURSIVE Dock-/ABI-stabile-.so-/Vertrags-Architektur** auf zwei Ebenen mit demselben Muster:

- **Ebene 1 — „EXPERIMENT-DOCK" (Experiment-Planer ↔ CEB), EINDIMENSIONAL:** Der Experiment-Planer hat ein **Dock für C++23-ABI-stabile CEB-.so-Programme**; der Vertrag ist **eindimensional** — der Planer **STEUERT die Einstellungen der von ihm kompilierten CEB** (Planer → CEB, KEIN Rückkanal hier). Er bestückt jede CEB mit verschiedenen **System-Achsen (+ System-Unter-Achsen) Algorithmen + Einstellungen** → verschiedene CEB-Varianten je System-Achsen-Wahl.
- **Ebene 2 — „PRÜF-DOCK" (CEB ↔ Tier-Binary), BIDIREKTIONAL:** Die CEB ist selbst eine **ABI-stabile .so**, **System-Achsen-VERSIONIERT**, und hat ihr EIGENES **Prüf-Dock** — ein **bidirektionales** Prüf-Dock zu seinen verschiedenen Arten von **Tier-Binary-.so-Interfaces** (CEB treibt an ↔ Tier-Binary meldet Messergebnisse ABI-stabil zurück). Dort kompiliert die CEB die C++23-ABI-stabilen Tier-Binary-.so-Module.
- **Ergebnis-Rückschrieb (NICHT über das eindimensionale Experiment-Dock):** Die CEB schreibt nach Bestimmungen des Experiment-Planers die **angeforderten Aufgaben + Messwerte SELBST an das in der XML eingegebene Ziel** zurück. = verknüpft mit dem Mess-Ergebnis-Rückschreibungs-Strang [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]] (§11-G: `measurement/<YYYYMMDD-HHMMSS>/`, Write-Token id=54, Loop-Schutz `[skip ci]`+`_bot_`) + [[reference_measurement_writeback_token_288_secure]]; die XML nennt nur diesen Ergebnis-Ziel-Pfad ([[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]]).
- **Tier-Binaries** (am CEB-Prüf-Dock), zwei Formen: **(a) heuristisch** — mit noch EINER Ebene NACH dem Command-Pattern in einer **compile-time Chain-of-Responsibilities** (Heuristik-Command-Pattern-Tier, virtuell) — oder **(b) plain** ein Tier-Binary am CEB-Prüf-Dock.
- **Kompile-Reihenfolge:** die CEB kann VERSCHIEDENE **Gattungen** an Binaries bauen + durchmessen, muss aber VORHER **auf deren Observer + Module kompiliert** werden: **System-Konfiguration → Mess-Achsen-heuristische-Konfiguration.**
- Der **Anatomy-Major-4→5 reitet am Experiment-Planer-Dock** (gegenüber der CEB-Messsystem-Erstellung).

**= dasselbe Dock/ABI-stabile-.so/Vertrags-Muster REKURSIV** (Planer→CEB gespiegelt zu CEB→Tier-Binary, geteilte Concepts).

**Why:** bestimmt ALLE Increments — DLL-Load (ABI-stabile .so je Ebene), 4→5-Bump (am Planer-Dock), Systemachsen (CEB-Ebene), Planer-Codegen, Prüf-Dock-Verträge, golden-Umbau.

**How to apply:** jede Ebene = C++23-ABI-stabile .so + Vertrag am (Prüf-)Dock; CEB system-achsen-versioniert + erst-auf-Gattungs-Observer-kompiliert (System→Mess-Achsen-Heuristik); Tier-Binary plain oder heuristisch-CoR-Command. Siehe [[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]], [[feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable]], [[feedback_heuristik_messkurven_typsystem_chain_of_responsibility]], [[feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake]].
