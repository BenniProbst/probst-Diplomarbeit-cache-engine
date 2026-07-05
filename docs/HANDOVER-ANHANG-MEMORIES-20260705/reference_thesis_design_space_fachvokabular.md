---
name: reference_thesis_design_space_fachvokabular
description: "Etabliertes DB-/Index-Fachvokabular (Idreos 'Periodic Table of Data Structures' + Data Calculator) als wissenschaftlicher Ersatz für Tier/Organ-Metapher in der Aufgabenstellung/Problemstellung"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 680a2413-b796-4bfa-894a-145cc51bd941
---

Für Aufgabenstellung/Problemstellung (wo die selbst gewählte Tier/Organ-Metapher NICHT vorkommen darf — s. [[feedback_thesis_linear_aufgabenstellung_keine_loesung_vorweg]]) das etablierte Vokabular der Datenstruktur-/Index-Design-Forschung verwenden.

**Hauptquelle (web-verifiziert 2026-06-14):** Idreos et al., „The Periodic Table of Data Structures" (IEEE Data Eng. Bull. 2018) + „The Data Calculator: Data Structure Design and Cost Synthesis from First Principles and Learned Cost Models" (SIGMOD 2018), Harvard DASLab.

**Kern-Vokabular (EN → Bedeutung → spätere Organ/Tier-Entsprechung im Lösungsteil):**
- **design space (of data structures)** — Raum aller Designs als Kombinationen+Tunings der First Principles [später: Permutationsraum]
- **design primitives** — „first principles of data layout design"; fundamentale Bausteine, 5 Klassen: node organization, filtering, partitioning, child layout, recursion [später: Achsen/Organe]
- **design dimensions** — Dimensionen des Raums (Data Calculator: 22 Primitive je 2–7 Werte → ~10^18 Punkte) [später: Achsen]
- **point in the design space / (full) specification / design** — EIN konkretes Design; B-Baum, Trie, Hash = je ein Punkt [später: ein „Tier"/Komposit-Algorithmus]
- **element** — vollständige Spezifikation eines Knotentyps (Kombination von Primitiven)
- **combination (and tuning) of primitives** [später: Permutation]
- **design space exploration / design synthesis** — systematisches Durchsuchen/Erzeugen [später: vollständige permutative Messung]

**Scope-Stütze:** B-Bäume, Tries, Masstree etc. sind ALLE Punkte im EINEN einheitlichen Design-Raum → rechtfertigt allgemeinen Scope „Suchalgorithmen/Suchbäume" statt nur Tries.

**Deutsche Termini (Hauptsprache DE):** Entwurfsraum (design space), Entwurfsprimitive / Entwurfsdimensionen, Entwurfspunkt / Punkt im Entwurfsraum, Entwurfsraum-Exploration. Englische Fachbegriffe beim Erstauftreten in Klammern nennen.

**Anwendung Aufgabenstellung:** „Cache-bewusste Suchalgorithmen/Indexstrukturen spannen einen großen Entwurfsraum auf; cache-line-Verhalten hängt vom Zusammenspiel vieler Entwurfsdimensionen ab; es fehlt ein gemeinsames Rahmenwerk, das diese als austauschbare Bausteine erfasst und fair vermisst" — OHNE konkrete Achsen-Liste, OHNE Organ-Metapher (beide erst im Lösungsteil).
