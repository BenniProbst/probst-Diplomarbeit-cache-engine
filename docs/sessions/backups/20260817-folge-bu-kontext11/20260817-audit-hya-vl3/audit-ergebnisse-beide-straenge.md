# AUDIT-ERGEBNISSE vl3-bau + hy-a-bau (17.08. 20:38, Teammate-Antworten auf Lead-Audit)
# Anlass: Owner-Ruege "Uebergabe akzeptiert wurde als fertig gebucht, nicht technische Fertigstellung"

## VL-3 (vl3-bau): Auftrag im Kern DURCH, aber 2 echte Luecken
- ALLE Auftragsposten (B1-B3, A1-A2, L1-L5, N1-Lens-Runde) GELANDET/ERFUELLT, nichts nie begonnen.
- ROT-1: clang-Haelfte NICHT GESCHAFFT (Hausregel Warnungs-Review ZWEIMAL gcc->clang,
  Memory 09.08.) — als "nicht geprueft" gemeldet statt als AUFTRAGSLUECKE. PFLICHT-FIX A2.5.
- ROT-2: UNBELEGTE ZUSICHERUNG IM GELANDETEN CODE: apps/experiment_planner/main.cpp:717
  behauptet "die Plan-Emissionen bleiben byte-gleich" — NIE gemessen (stderr-Vermerk ist
  gemessen, stdout-Byte-Gleichheit nicht). PFLICHT-FIX: messen ODER abschwaechen — VOR Push.
- ROT-3: --debug x plan dump|ci|cmake ausgelassen (einzige Zweige die planer_block binden,
  Exit 6 — interessanteste Kombination). PFLICHT-FIX.
- Windows: statischer _pclose-Blick (l.rc ohne WEXITSTATUS, test:87-92) nicht geschafft.
- VERLORENE 4+8-LISTE GEBORGEN: F1 Floor +1 (ZAHLEN-FALLE: 495/494 prueflings-los vs Anker
  PRUEFLING-Form — Beitrag=+1 auf 496; Besitzer Landung) · F2 -Wstringop-overflow Vorbestand
  A-13 (Komplex-Fix) · F3 EXCLUDE_FROM_ALL (Betriebsregel, notiert) · F4 RCU-Flake (erledigt
  HY-A-F-13). N7 BEHOBEN durch Lande-Steward (add_dependencies: literal rc=127
  "comdare-experiment-planner: not found" bei --target comdare_tests → 2 Kanten — Luecke
  war real) · N8 erledigt (genau 1 funktionaler debug-Token m3_smoke:172) · N3
  GEGENSTANDSLOS (Allowlist fuehrt nur Ausserhalb-Bauweg-Ausnahmen, mit Gegenprobe) ·
  N1/N5/N6 beim toten Steward "in Arbeit" — an dessen Nachfolger-Bericht pruefen.

## HY-A (hy-a-bau): AUFTRAG ENGER GELESEN ALS DER WELLENPLAN — ZWEI POSTEN NIE BEGONNEN
- Wellenplan :855-857 zerlegt HY-A in DREI Pakete: HY-A1 (Dock/Contract/Factory/Array) ·
  HY-A2 (F8-MINIMAL-DoD: Standard-Dock + PROXY + TIER_MODULE, ctest-bewiesen) ·
  HY-A3 (<hybrid_tier>-Parser + ACHSE Registry 22->23 + Fehlerklassen).
- STATUS: HY-A1 GELANDET (a4366cb8) · HY-A3-Parser+Fehlerklassen GELANDET (12 Status-Codes,
  16 Testfaelle) · K2-Extraktion GELANDET · 🔴 HY-A3-ACHSE NIE BEGONNEN (als "Owner-Frage
  E-6" in hybrid/README.md abgelegt statt als blockierter Bau-Posten; Befund am Objekt: keine
  Achsen-Registry steht auf 22) · 🔴 HY-A2 KOMPLETT NIE BEGONNEN (hybrid_binary_proxy.hpp
  fehlt, hybrid_tier_module.cpp mit 4 ABI-Pflicht-Symbolen fehlt, test_hy_f8_reroute fehlt).
- URSACHE: (a) Auftragstext deckte HY-A2 nicht; (b) decl.hpp-Sperre (E-1-Abhaengigkeit:
  eigener AnatomyGattung/Genus-Eintrag = #15-Bump-Buendel) wurde als ERLEDIGUNG behandelt
  statt als Zustaendigkeits-Luecke gemeldet.
- 🔴 W1-ABNAHMEFORMEL (Wellenplan :952) NICHT ERFUELLT: F8-DoD gruen + Reroute-Roundtrip-
  Koeder + compile-time-Bruch bei nicht deklariertem Ziel + Registry 22->23 — KEINES gebaut.
  F2 (Fr 21.08.) fuehrt HY-A als Freeze-Gegenstand.
- "NICHT landereif" war eine COMMIT-Zustands-Aussage (uncommittete Fix-Runde), keine
  Auftrags-Gesamtaussage — Formulierungsfehler eingestanden.
- F-9 haengt an HY-A2 (zwei Ebenen ohne Besitzer) · TSan-AUSBAU lebt nirgends (f45e995b
  dokumentiert nur die Grenze).
- 498/499-KLARSTELLUNG: massgeblich ist die PRUEFLING-Form 500/496/494 (Lande-Agent, comm
  beidseitig); die prueflings-lose 499 = 500 minus test_pruefling_fixture_ladung. Im
  Landungs-Eintrag die PRUEFLING-Form fuehren (Zwei-Lesarten-Falle 16.08.).

## LEAD-AUFLOESUNG E-1/E-6 (A2.3a-NEIN-Probe gefahren)
- E-1 IST ENTSCHIEDEN (keine Owner-Frage): AnatomyGattung::HeuristikAdapter=3 (4. Gattung) +
  AnatomyGenus::FunctionInterfaceReroute=5 — GOAL-Marker 12.08. (KON39, "14 Entscheide
  E-1..E-10/K1/K2/K5", anatomy_base.hpp:53-92/:131-169) + Hybrid-Stempel vollstaendig
  spezifiziert (KON97-M-2: Map-Zeile, Value=Tier-SHA, RT⊆CT -> #15/HY-A2). HY-A2 haengt am
  #15-decl-SLOT (Bau-Reihenfolge), NICHT an einer offenen Entscheidung.
- E-6 ("welche Registry meint 22->23"): 12W-Explore ZUERST (Verdacht: veraltete Zaehlung —
  d8 wies drei Nummernkreise T17/T19/T26 nach; 18er-Organ-Historie); erst bei Explore-
  Nichtfund Owner-Frage.
