---
name: thesis-core-contribution-axis-library
description: "KERN-BEITRAG der Diplomarbeit — Paper-Algorithmen in Achsen zerlegen, original-getreu als Achsen-Komposition rekonstruieren, modular austauschbar + transparent pro Achse UND ganzer Algorithmus messbar; Library-Framework der Achsen, damit ein Forscher EINE neue Achse erforschen kann, ohne die QUELLE der anderen 18 Achsen umzuschreiben (NICHT bau-inkrementell — jede Konfig-DLL wird IMMER frisch gebaut; Korrektur 2026-06-19)."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**Der Kern-Beitrag (raison d'être) der Diplomarbeit (User-Direktive 2026-05-29):**

1. **Zusätzliche Schwierigkeit / Leistung:** Existierende Algorithmen aus Papern in **Achsen-Algorithmen zerlegen**, sodass man sie als **eindeutige Kompositions-Auswahl ALLER Achsen** per Metaprogrammierung **original-getreu wieder erstellen** kann (Habich-Compliance: der Original-Algorithmus muss aus seiner Achsen-Zerlegung exakt rekonstruierbar sein).

2. **Modularer Austausch:** Über die **Schichten der Achsen** wird ein **modularer Austausch einzelner Achsen-Algorithmen** möglich → das **stärkt die Vergleichbarkeit** (gleiches Gerüst, nur eine Achse variiert).

3. **Methode:** Wir finden die **ANATOMIE** eines (Such-)Algorithmus bzw. Containers (für die Container-Gattung) und machen sie **transparent auswertbar** — **pro Achse UND für den gesamten Algorithmus** (= die zweidimensionale Messung, siehe [[std-map-unified-interface]]).

4. **Gelöstes Problem (der eigentliche Nutzen):** Forscher, die nur EINEN bestimmten **neuen Achsen-Algorithmus** erforschen, müssen sonst einen GANZEN Suchalgorithmus bauen UND manuell je einen Algorithmus für ALLE bestehenden Achsen finden+implementieren — die sie gar nicht brauchen. Das ist ineffizient.

5. **Lösung:** Ein **Library-Framework der Algorithmus-Achsen mit der cache engine**. Der Forscher steckt seine EINE neue Achsen-Implementierung ein; das Framework liefert alle übrigen Achsen → sofort ein vollständiger, vergleichbarer Algorithmus. (Das ist genau das Plugin-Controller-/Prüfling-Slot-Modell: prt-art liefert nur seine spezifischen Achsen via optional_prt_art_impl, die cache-engine ergänzt die Defaults — [[feedback_destructive_autonomy_3repos_with_tag]]-Kontext, Doku 20/21.)

6. **BUILD-MODELL-KLARSTELLUNG (code-belegt 2026-06-19, User-Korrektur — Workflow wuh70wwyi):** „Ohne alle anderen neu zu bauen" gilt NUR für die **QUELLE** (man implementiert/schreibt die 18 anderen Achsen-Organe nicht neu — das Framework liefert sie als Header). Es gilt NICHT für den **BAU**: **für jede Mess-Konfiguration werden IMMER die nötigen, vollständigen 19-Achsen-DLLs frisch gebaut** (`1 DLL = 1 TU`; jede `perm_<id>.cpp` inkludiert `all_axes_umbrella.hpp` = alle 19 Achsen-Organ-Header neu + `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ-Typen>)` der vollen Komposition; `cl /LD`). **KEINE** inkrementelle „nur-die-neue-Achse"-Bau-Semantik. Einzige Bau-Ersparnis = **Resume**: DLL-Skip bei identischer build_version (`.version`-Sidecar, build_orchestrator.hpp:150-159) + Mess-Skip bei identischem `result.csv`-Stamp (#139). Der reale Hebel = kompositionelle Wiederverwendung der QUELLE + transparente Per-Achse-/Ganz-Algorithmus-Messung, NICHT reduzierter Build-Umfang. Belege: adhoc_emitter.hpp:46-103, all_axes_umbrella.hpp:19-40, source_catalog.hpp:24-26.

**Verknüpfung:** Dieser Beitrag begründet ALLES: die Goldstandard-Achsen-Struktur, die Paper-Provenienz-Map (Doku 18), die 3-Stufen-Permutation (F.5), den zweidimensionalen F15-Mess-Treiber, und das einheitliche `std::map`-Interface ([[std-map-unified-interface]]) als Vergleichsbasis. Bei JEDER Achsen-/Mess-/Framework-Arbeit diesen Zweck im Blick behalten.
