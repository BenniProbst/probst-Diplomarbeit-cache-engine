---
name: feedback_alt_golden_darf_brechen_erst_additiv_dann_aufraeumen_unter_absprache
description: "User 2026-07-17: alt-golden-320 darf für Wartbarkeit/allgemeingültigere Metaprogrammierung brechen; Reihenfolge: ERST additiv handeln, DANN aufräumen — ohne Funktionsverlust, ohne compile-time→runtime-Degradierung, Aufräumen NUR unter Absprache"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Direktive (2026-07-17, während Bau-INC-2b, verbatim-treu): „ich bin ok damit, wenn wir die alt golden 320 für die Implementierung einer leichteren Wartbarkeit und allgemeingültigeren Metaprogrammierung brechen. Also **erst Additiv handeln** und dann können wir gerne auch mal **aufräumen ohne Funktionalität zu verlieren** und **ohne unnötig Funktionalität von der compile time für die Laufzeit-teure runtime umzubauen** (**nur unter Absprache**)."

**Why:** lockert das harte „golden-320 byte-identisch"-Korsett für den 4→5-Umbau; das additive `_abi4`-Freeze (INC-2b) ist der erste Schritt, spätere Bereinigung alter golden-Pfade/-Doppelstrukturen ist erlaubt.

**How to apply:** (1) Brechende golden-Umbauten sind im INC-2/INC-3-Rahmen zulässig; IMMER erst die additive Sicherung (`…_abi4`-Freeze, Messdaten additiv). (2) AUFRÄUMEN (alte Dateien/Pfade entfernen) = separater Schritt NUR nach expliziter Absprache. (3) Beim Aufräumen: kein Funktionsverlust, keine compile-time→runtime-Degradierung ([[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]]). Ergänzt [[feedback_messdaten_nie_loeschen_abi_darf_brechen]] + W3=A ([[feedback_q2_option_c_erweiterungshardware_sechste_systemachse]]).
