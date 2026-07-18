---
name: feedback_vor_aufgaben_erst_projektstruktur_analyse
description: "User 2026-07-16: VOR der Aufnahme JEDER Aufgabe zuerst in die Analyse der gigantischen Projektstruktur investieren — erst kartieren wo der bestehende offizielle Pfad ist und wo die Aufgabe andockt, DANN bauen. Anlass: v32-Parallel-Engine (INC-F/G/H + WP-1) entstand neben dem bestehenden E4/CEB/DLL-Pfad."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-16 (bindend):** „Bitte merke dir, dass du vor der Aufnahme einer Aufgabe zuerst in die Analyse der gigantischen Projektstruktur investierst."

**Why:** Die Diplomarbeit-Struktur ist gigantisch (4 Repos, ~170 Seiten Architektur-Doku, 19-Achsen-Metaprogrammierung, E1–E4-Maschinerie, 300k-Token-Ledger). Wer eine Aufgabe annimmt und baut, ohne zuerst den BESTEHENDEN Pfad zu kartieren, erzeugt Parallelstrukturen: konkreter Anlass war die v32-Strecke (INC-F/G/H) — ein eigener in-process-Mess-Treiber mit eigener CSV-Welt NEBEN dem einen offiziellen E4-Pfad (messung_driver→CEB→DLL→Prüfdock→16-col-CSV→Pipeline 03–09). Der User musste eingreifen („baut gerade eine zweite sinnlose parallele Engine, was soll das?"), WP-1 (Härtung der Parallelstrecke) wurde gestoppt. Verwandt: [[feedback_never_guess_always_lookup_state_of_art_and_docs]], [[feedback_immer_ledger_zuerst_lesen_vor_handeln]], [[feedback_only_one_official_xml_driven_program_no_behelfswege]], [[feedback_elaborate_dossier_fuer_komplexe_planung]].

**How to apply:** Vor JEDER Aufgaben-Aufnahme (auch scheinbar klar umrissenen Fixes/Härtungen) zuerst beantworten — mit Kartierung (Explore/ultracode bei Unklarheit), nicht aus dem Gedächtnis:
1. **Existiert die Fähigkeit schon?** (grep/Doku: der offizielle Weg, z.B. E4-XML→CEB→DLL→Prüfdock→CSV-Pipeline)
2. **Wo ist der Andockpunkt?** (die Aufgabe erweitert den bestehenden Pfad — sie baut KEINEN neuen daneben; „NUR EIN offizielles XML-Programm")
3. **Welche Architektur-Doku/Ledger-Abschnitte besitzen das Thema?** (ce docs/architecture, super docs/architektur 00–22, Ledger-§§)
4. Erst wenn 1–3 belegt sind: Dossier → bauen. Wenn die Aufgabe eine Parallelstruktur implizieren würde → ANHALTEN und dem User den Andock-Fork vorlegen.

**ENTSCHEID + VERSCHÄRFUNG (User 2026-07-16, bindend):** „Bitte Option A, bitte bleib IMMER bei der offiziellen Architektur, wie geplant, merke dir das." — Der v32-Fork ist mit **Option A** entschieden: die v32-Strecke wird zur DÜNNEN Orchestrierung ÜBER dem offiziellen E4/CEB-Pfad zurückgeschnitten (3-Phasen-XML → CEB-Build-Selektionen → echte DLLs → Loader → Prüfdock → E4-Lastprofile → offizielle 16-col-CSV; Welch-Verdikt konsumiert die offizielle CSV). Parser/Schema/Registries/Strategy (INC-A..E) bleiben gültig; der Parallel-Antrieb (INC-F/G/H-Treiberteil) wird deprecatet/ersetzt. **Generalregel: IMMER bei der offiziellen, geplanten Architektur bleiben — jede Lösung dockt an den einen offiziellen Pfad an, NIE eine zweite Strecke bauen oder härten.**
