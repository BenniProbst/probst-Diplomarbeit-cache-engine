---
name: feedback_thesis_nur_user_ideen_persistieren
description: "Thesis-Provenienz-Governance (User 2026-06-15): In die Diplomarbeit (.tex) dürfen NUR Ideen persistiert werden, die vom User stammen oder zitierte Primärquellen sind; modell-eigene Ideen NIE ohne explizite User-Anweisung schreiben. Eigene Ideen nur als Chat-Vorschlag; User muss Validität geprüft + freigegeben haben."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 680a2413-b796-4bfa-894a-145cc51bd941
---

KRITISCH (User 2026-06-15, Diplomarbeit Kapitel 1–3, Thesis-Text-Workstream): In die Diplomarbeit
dürfen **ausschließlich** Ideen persistiert werden, die (a) vom **User** stammen (seine `%`-Kommentare
im .tex / die dokumentierten Coding-Docs der cache-engine) oder (b) **zitierte wissenschaftliche
Primärquellen** sind. **Ideen, die aus meinem Modell entspringen, werden NIE ohne ausdrückliche
User-Anweisung in den Text geschrieben.**

**Why:** Akademische Eigenleistung/Provenienz — TU Dresden wertet ungekennzeichnete/unerlaubte
KI-Nutzung prüfungsrechtlich als **Täuschung**; die Kernideen müssen nachweisbar vom Autor kommen.
Der User darf nur eigene Ideen persistieren; um Hilfe zu fragen ist ausdrücklich erlaubt.

**How to apply:** Workflow je Arbeitspaket = **Vorschlag/Stichpunkte im Chat (als „Vorschlag"
markiert) → User prüft Validität selbst + weist an → erst dann in den .tex schreiben.** Ich liefere
Struktur, Recherche-Synthese und Formulierung, NICHT neue Substanz. Jede persistierte Aussage muss
rückführbar sein auf User-Kommentar, Coding-Doc oder zitierte Primärquelle (keine Wikipedia —
[[feedback_quellen_keine_wikipedia_nur_direktquellen]]). Deckt sich mit der User-Entscheidung
„erst Gliederung + belegte Stichpunkte zur Abnahme, dann Ausformulierung".

**Nachtrag (User 2026-06-15) — KEIN KI-Co-Autor in Commits:** Commits im Thesis/Overleaf-Repo dürfen
NICHT den `Co-Authored-By: Claude …`-Trailer (oder sonstige KI-Selbstnennung als Autor) tragen — ich
bestehe nicht darauf, als Autor genannt zu werden. Grund: akademische Autorschaft/Eigenleistung (es ist
die Diplomarbeit des Autors; AI-Co-Authorship in der Git-History würde sie untergraben). Gilt fürs
Thesis-Repo; andere Repos nach deren Regeln. Ab sofort Commit-Messages ohne den Trailer.

**Nachtrag (User 2026-06-16) — Grundlagen = `#include` nur des verwendeten Wissens:** Für JEDES
Grundlagen-Thema zuerst den GESAMTEN Code + ALLE Docs über dessen Entstehung gründlich lesen
(read-only Agenten erlaubt), um die TATSÄCHLICH VERWENDETEN (und daher relevanten) Themen
herauszulesen. Die Grundlagen führen NUR das Wissen ein, das danach wirklich verwendet wird —
analog zu C++-`#include`s, die zuerst „Wissen" importieren, das dann zur Verfügung steht. KEINE
generische Lehrbuch-Breite; nur das downstream Genutzte, am realen Code belegt. (Grundlagen =
Definitions-Klassen-Bibliothek für die Folgekapitel.)
