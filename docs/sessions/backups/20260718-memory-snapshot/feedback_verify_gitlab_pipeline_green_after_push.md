---
name: feedback_verify_gitlab_pipeline_green_after_push
description: Nach JEDEM Push die gitlab-Pipeline auf GRÜN verifizieren (nicht nur Push-Erfolg) — sonst schlagen sie unbemerkt fehl; + granularer/regelmäßiger committen+pushen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**User 2026-07-04 (scharfe Rückmeldung):** „die ganze Zeit schon schlagen die gitlab pipelines fehl und du
committest/pushst nicht regelmäßig." → Ein Increment ist NICHT „done/verifiziert", wenn nur LOKAL gebaut+getestet
wurde und der Push erfolgreich war — die **gitlab-CI-Pipeline muss GRÜN sein** (§7-Direktive „grün muss BESTEHEN
beweisen"). Push-Erfolg ≠ Pipeline-grün. Pipelines schlagen sonst unbemerkt fehl.

**User 2026-07-04 (Kadenz-Direktive, wörtlich „bitte merke dir das"):** Vorgehen ab jetzt = **je Hauptaufgabe:
commit + push (BEIDE Remotes) → UNMITTELBAR danach der Pipeline-Fix**, bis grün — DANN erst die nächste Hauptaufgabe.
NICHT erst alle Features bauen und Pipelines liegen lassen. Scope „Pipeline" = die **gesamte Diplomarbeit-Pipeline
mit rekursiv eingebauten Modulen = alle 4 Projekte** (super + cache-engine + prt-art + thesis), nicht nur das eine
Repo, das ich gerade angefasst habe.

**How to apply:**
0. **Pro Hauptaufgabe genau EIN Zyklus:** Implementieren → committen → zu BEIDEN Remotes pushen → Pipeline beobachten
   → rot? sofort fixen (commit+push) bis GRÜN → erst dann die nächste Hauptaufgabe. Pipeline-Grün ist Teil der
   Hauptaufgabe, kein separater späterer Sammelschritt.
1. **Nach jedem Push:** gitlab-Pipeline-Status abfragen und auf **success** warten/prüfen — NICHT als done markieren,
   solange die Pipeline rot/pending ist. `glab` ist lokal ggf. nicht da; `gitlab.comdare.de` (self-hosted) →
   API via keeper-root-PAT (Vault) + curl `/api/v4/projects/<id>/pipelines?ref=main` (neueste `status`).
2. **Granularer + regelmäßiger** committen+pushen (nicht ein großer Commit am Increment-Ende) — kleinere logische
   Schritte, damit ein Pipeline-Fehler früh + eng lokalisierbar ist.
3. Bei rot: Ursache klären (kann pre-existing Infra sein — Runner-idle-Stall #210, lint-Gate #203, prod2-I/O #207 —
   ODER die eigene Änderung). Ehrlich unterscheiden, nicht „done" behaupten.

Verstärkt [[feedback_no_success_marks_without_literal_output]] + [[feedback_commit_push_regularly_not_only_session_end]].

**VERSCHÄRFUNG (User 2026-07-06, /goal-Nachtrag):** „Bitte achte nach jeder großen Aufgabe darauf, dass die gitlab pipeline durchläuft und strikt grün ist." — Pipeline-Grün ist Abschlusskriterium JEDER großen Aufgabe; Fehler manuell fixen (ohne Codex, [[feedback_codex_implements_from_dossier_claude_corrects]]).

**VERSCHÄRFUNG 2 (User 2026-07-06 abends):** „Bei einer harten Pipeline darf es kein allow_failure geben." — Strikt grün = Endzustand OHNE allow_failure; Advisory-Jobs sind ausschließlich Übergangszustand mit eingebuchter, aktiv abzuarbeitender Fix-Strecke (Diplomarbeit: Ledger #278 — 58er-ce-Laufzeit-Fails + sanitize-Befunde → dann alle Gates hart). ERLEDIGT 06.07. 22:15: 0 allow_failure im Matrix-System (Ausnahme by design: ce is_original:relock, manual).

**CROSS-PROJEKT-AUTO-CANCEL (Vorfall 2026-07-06 22:14, super 8207):** Ein DIREKT-Push in ein Submodul-Repo (prt-art), während eine super-Welle mit Kind-Bridges läuft, auto-cancelt deren Kind-Pipeline auf derselben ref → Bridge canceled → abhängige Jobs skipped → super-Pipeline CANCELED, obwohl alle gelaufenen Jobs grün waren. „Keine Pushes während Beweis-Pipeline" gilt daher AUCH projektübergreifend: kein Submodul-Push, solange eine super-Welle läuft. Heilung: Pipeline-Retry startet gecancelte Bridges NICHT mit — die Bridge einzeln retryen (POST /projects/288/jobs/<bridge_id>/retry).
