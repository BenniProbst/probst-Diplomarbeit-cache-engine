---
name: feedback_thesis_sequential_referencing_rule
description: Diplomarbeit-Querverweise — Rückverweise nur auf bereits Eingeführtes; Vorwärtsverweise nur als Grundlage→Vertiefung; Volltext sequenziell top-down
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 680a2413-b796-4bfa-894a-145cc51bd941
---

Die Diplomarbeit wird im Volltext **sequenziell von oben nach unten** abgehandelt. Querverweise (`\ref`) müssen dieser Leserichtung folgen (User 2026-06-23):

- **Rückverweis (auf früheres Kapitel/Abschnitt):** nur, wenn das dort etablierte Wissen *im aktuellen Kontext gebraucht* wird. Begriffe müssen **spätestens in den Grundlagen (Kap. 2) eingeführt/angeschnitten** sein, bevor ein späteres Kapitel sie instanziiert/vertieft.
- **Vorwärtsverweis (auf späteres Kapitel):** nur erlaubt, wenn der *aktuelle Kontext die Grundlage des folgenden* ist (z. B. „motiviert die Forschungslücke (Abschnitt 3.7)", „wird in Kap. 6 mess-methodisch vertieft"). NIE behaupten, ein Begriff sei in einem *späteren* Abschnitt „eingeführt/definiert/vorgestellt".

**Why:** Sätze wie „Die in Abschnitt 6.4 eingeführten Begriffe … erhalten hier ihre Instanzen" (in Kap. 3) sind verwirrend — der Leser hat Kap. 6 noch nicht gesehen. Wurde der Begriff nicht in den Grundlagen angeschnitten, versteht man die Stelle nicht.

**How to apply:** Bei jedem „eingeführt/definiert/vorgestellt"-Satz das `\ref`-Ziel-Kapitel prüfen; zeigt es nach *vorn*, ist es fast immer eine Label-Verwechslung → auf die Grundlagen-Stelle umbiegen. Anlass-Bug: §3.4 verwies auf `sec:workloads` (= §6.4 „Workloads und Datensätze", Kap. 6) statt `sec:workloads-basics` (= Kap. 2 „Lasten und Workloads"). Prüf-Heuristik: fenster-basierter Scan über alle Kapitel — Verb (eingeführt|definiert|vorgestellt|introduced|defined|presented) + `\ref` auf höhere Kapitelnummer als die zitierende → flaggen. Gilt DE≡EN (Labels identisch). Siehe [[project_thesis_latex_struktur_bilingual]], [[feedback_thesis_nur_user_ideen_persistieren]].
