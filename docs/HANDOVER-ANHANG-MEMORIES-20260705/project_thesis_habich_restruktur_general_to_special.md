---
name: project_thesis_habich_restruktur_general_to_special
description: "Thesis-Umbau nach Habich-Audit (2026-06-29): 5-6 Kapitel statt 8, allgemein->speziell (Suchbäume-first, Mess-System als LÖSUNG des Suchbaum-Problems), fließende Absätze statt Silo-Unterkapitel, Bildhaftigkeit jedes neuen Konzepts (Bilder zählen NICHT zum 60-80-Seiten-Textumfang); nur Struktur/Fluss/Platzierung ändern, Inhalt bleibt."
metadata: 
  node_type: memory
  type: project
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

**Erstprüfer Prof. Habich** hat im Audit (2026-06-29) die Arbeit bis tief in Kap. 4 gelesen: **inhaltlich richtig**,
aber Struktur/Hinführung mangelhaft. Großer Umbau, **NUR Struktur/Übergänge/Platzierung** (Inhalt bleibt; **DE führt,
EN folgt**; Metapher-Kanon bleibt). Backup vor Umbau: Git-Tag `backup-2026-06-29-pre-habich-restruktur` (beide Remotes).
Detail-Referenz: `thesis/diplomarbeit/docs/sessions/2026-06-29-habich-audit-kritik-und-restruktur-plan.md`.

**Ziel-Struktur (5-6 Kapitel statt 8):** 1 Einleitung · 2 Suchbäume+Grundlagen [**KONZEPT→HARDWARE→SOFTWARE**, rein
visuell, KEINE Tabellen]: 2.1 Konzept+SOTA-Überblick (je Paper-Algorithmus ein Detailbild), 2.2 historische Hardware-Einführung
(statisch/compile-time), 2.3 Software-Mittel + Synthese→unsere Achsen + Begrifflichkeiten + wiss. Messen + Anatomie-Brücke;
Bild-Platzierung: Paper-Algo-Details→2.1, Synthese→2.3, Achsen-Gesamtkonzept→Kap.4, je-PRT-ART-Algo→Kap.4
· 3 Mess-System mit PRT-ART als Demonstration · 4 Implementierung + konkrete Algorithmus-Bestandteile (Detail-Fokus:
PRT-ART-Schlüsselstellen + alle Mess-System-Ebenen) · 5 Evaluation (Methodik zuerst, dann Ergebnis-Analyse —
zusammengelegt) · 6 Fazit+Ausblick (einzeln oder Teil von 5).

**Kern-Prinzipien:**
- **allgemein → speziell** (Habich verliert sich gern im Detail): Suchbäume (allgemein) → konzeptionelles Problem
  (Trennbarkeit + Cache-Bewusstheit) → trieb bereits HW-Anpassungen → geforderte Abstraktion (Achsen/Entwurfsraum) →
  **Mess-System als LÖSUNG** (schärfbar durch Heuristiken), demonstriert an PRT-ART. NICHT umgekehrt (aktuell verkehrt:
  Spezial-Mess-System für allgemeines Problem, dann Spezialfälle).
- **Platzierung suchbaum-nah**, nicht mess-system-nah.
- **Fließende thematische Absätze** statt winziger Silo-Unterkapitel; Übergänge zwischen Themen.
- **Bildhaftigkeit**: jedes neue, nicht-literatur-nachlesbare Konzept + der Entwurfsraum **bildlich** erklären; Bilder
  zwischen den Texten ausdrücklich erwünscht und **zählen NICHT** zum 60-80-Seiten-Textumfang.
- **Hinführung** für themen-fremde Leser.

**Vertiefung (gleicher Audit 2026-06-29):** (a) **Aufgabenstellung wird NICHT gelesen** → Text muss ohne sie verständlich
sein; ihre Belange (cache-aware-Fokus) **vollständig in Kap. 3** einführen, auf ALLE Belange von Kap. 2 zurückgreifend.
(b) **Kap. 2 rein konzeptionell/visuell, KEINE Katalog-Tabellen**; Begrifflichkeiten + wissenschaftliches Messen → Kap. 2.3.
(c) **ALLE Tabellen → Kap. 3** (Evaluations-Tabellen → Kap. 5). (d) **Anatomie-Metapher (Mensch→Technik) als visuelle
Leitidee**, um die Mess-System-Idee zu erklären. (e) **Massive grafische Erweiterung (~50 Abbildungen):** pro Achse
(Algorithmen + Achsen-Interface-Code), alle Gattungen, **UML-Landkarten** aller Code-Interfaces, **Achsen-Nutzungs-Graph**
(welche Achse nutzt welche), Entwurfsmuster-Bild; Kap. 4: **je PRT-ART-Algorithmus ein Bild**. Detail-Plan v2:
`thesis/diplomarbeit/docs/sessions/2026-06-29-restruktur-detailplan-gliederung-und-bildliste.md`.

**Why:** Habich = Erstprüfer, DB-/Suchstruktur-Professor; seine Präferenz (general→special, Detailtiefe, Suchbaum-Fokus)
entscheidet die Note. **How to apply:** beim Umbau IMMER gegen diese Struktur + den general→special-Bogen prüfen; vgl.
[[feedback_codex_mcp_review_before_code_complete]] (Text-Änderungen codex-reviewen) + [[reference_thesis_git_topology_remotes_overleaf]] (commit/push beide Remotes, Overleaf-Merge).
