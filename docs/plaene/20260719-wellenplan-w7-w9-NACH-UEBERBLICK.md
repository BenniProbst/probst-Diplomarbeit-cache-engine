# Wellenplan W7–W9 (19.07. spaet) — Synthese aus dem Anforderungs-Ueberblick (wf_2d161831)

> Architekten-Synthese (Fable) aus 3-Reader-ultracode: Ledger §0+§25–§40.b, 6 Workflow-Backups, Top-5-Dokumente.
> Rohdaten: docs/sessions/backups/20260719-w5-planung-und-anforderungs-ueberblick/. Stand der Wellen: W1–W5 KOMPLETT
> (dual-CI-verifiziert), W6 IN BAU (paralleler provision-Bau), Kalibrierung 11453 = 24/24 Pilot-Erfolg.

## Kritischer Pfad zur Deadline 28.07. (9 Tage)
Realer Messlauf (F2: N-Satz-AUFBAU ~8h → golden-320-XML-Messtest ~4h) → M-4-Auswertung → #47 Thesis-LaTeX DE+EN + Anhaenge A/B/E (§0-G8). ALLE Wellen dienen diesem Pfad. **Blockierende User-Entscheidung: GN-11** (Deadline-Messlauf-Scope golden-320/kuratiert vs. golden-N-Voll — Frage an den User gestellt, s. Ledger-Folgeeintrag nach Antwort).

## W7 — §40.b/§40.c: Dynamische Planer-CI + Bare-Metal (user-priorisiert, 1 Opus-Agent)
- **W7-A CiYamlBuilder (I3):** dritter ConcreteBuilder am Director-Walk → Child-Pipeline-YAML (GitLab `trigger: include: artifact:`), zweistufig nach §40.b-Praezisierung: Stufe 1 Planer→CEB-Bau-Jobs (je Messsystem/System-Permutation), Stufe 2 CEB→Tier-Binary-Jobs (Grandchild; GitLab erlaubt parent→child→grandchild). Topologie-Isomorphie-Contract zu PlanText/CMakeGraph. Die statische 24-Zellen-Matrix bleibt Pilot-Fallback bis die Serie dual-gruen ist.
- **W7-B CMakeGraphBuilder SCHARF (§40.c = §0-DoD5!):** No-Op-COMMANDs → echte Treiber-Kommandos je Zelle (COMDARE_THESIS_PROFILE/GOLDEN_N_RANGE/GN_OPT/GN_SIMD/PROVISION_ONLY); + `MANUAL_RUN.md` (Hand-Lauf-Anleitung) + literaler Bare-Metal-Beweis (kleines Fenster ohne CI). Deckt §0-DoD5 (#193-Handlauf) mit ab.

## W8 — §40.a: Flag-Signatur-Modell (nach W7 oder parallel bei freiem Agenten)
System-Registry-Ausbau nach docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md (live-verifiziert auf prod1): (a) Maschinen-Signatur-XML (isa-signature je Node, Quelle /proc/cpuinfo), (b) Organ-`<isa required/optional>`-Deklaration je Algorithmus-Variante, (c) Resolver-Schnitt (Variante faellt weg wenn required-Flag fehlt → Fallback-Kette), (d) CompileFn-Flag-Bundles aus gcc-Attributen. Bindet die offenen Faeden G2/G7 (extension_hardware aktiv seit W1; constexpr-Bau-Gate = Folge-Increment bei HART-SIMD-Organen). Flags bleiben binary_id-NEUTRAL (D9-Doktrin).

## W9 — Konformitaets-Sammelwelle (VOR dem Messlauf, 1 Opus-Agent)
Buendelt die mehrfach-offenen Faeden (Aufwand S/M, alle golden-neutral):
1. **H-10-Sidecar-Aufrufer** fuer build_system_axis_levels() — von DREI Workflows offen gehalten, ZWINGEND vor telemetry-variierendem Messlauf (Prio 1).
2. Slot-Zahl-/ABI-Doku-Drift-Sweep (G8 + inc2c-B + Nachschlagewerk B/C: 19/18→17 etc., kSetCompositionSlotCount).
3. build-i2-Include-Root-Gap (D-1/§26-K2, 3 stale-rote Tests → hart-gruen).
4. COMDARE_GOLDEN_320_IDS-Rename (GN-8-Rest) + Lock-Scope-Pruefung Organ-Header.
5. G4 copy_results_to_nas.sh DEPRECATED-Marker (nie loeschen), G5 ToolchainFehlt-Emitter, G6 n/a-Renderer, G9/G10 Python-Kommentar/Scaffolding-Vermerke.
6. K5: 07-16-VOLL-AUDIT (83 Befunde) gegen Register abgleichen (Bericht, kein Blind-Fix).

## Danach (gated/geplant, nicht W7–W9)
- **Messlauf-Kette** (#14): nach GN-11-Entscheid + W6 + W9.1; Ein-CEB-Lock aktiv (W5-A).
- **Hybrid-PFLICHT** (#13): braucht reale CSVs aus dem Messlauf; Spline-Fundament + 3-Hot-Swap-Entscheid stehen.
- Fork C (aktive CEB-Generierung .so), I4/I5, Resolver-4-Stufen (D13/PL-17), Gattungs-Docks (INC-4), PL-19 AxisKind-Ausbau, PL-21 Joins — nach Abgabe bzw. eigene GOs.
