# 20 — Heuristik-Messkurven-Typsystem, Filterkette (Chain of Responsibility) & Monolith-Doktrin

> **Quelle:** User-Vision 10.07.2026 (wörtlich, mid-turn; Memory
> `feedback_heuristik_messkurven_typsystem_chain_of_responsibility`). Ergänzt Dossier 19 Teil G
> (CEB-Modi Mess→Auswertung→Arbeits→Hybrid) ADDITIV. Status: dokumentiert + gegen IST geprüft;
> **Implementierung des Diffs = E4′-/Arbeitsmodus-Strecke** (nach den DATEN_GATED-Vorbauten,
> ce `c022ce05`), nicht vorgezogen.

## A. Monolith-Doktrin (Organisationsform)

Die cache-engine wird als **Monolith fertiggestellt**. Die spätere Zergliederung in die
comdare-Matrix-Konvention (gitlab-Namespace „all") füttert die **cache-engine-all-Modul-Bibliothek**
mit den **maximal metaprogrammierbaren und generischen Bestandteilen** — Zergliederung ist ein
EIGENER, späterer Schritt (vgl. `project_cache_engine_research_vs_cacheengine_all_split_todo`);
kein Increment darf die Monolith-Fertigstellung an Modul-Grenzen aufhalten.

## B. Das Messkurven-Typsystem (SOLL, wörtlich)

Jede **Tier-Binary-Gesamtpermutation** besitzt eine Wall-Clock-Messkurve je

```
tree<axis compile/dynamic,
     map<workload-framework,
         map<workload-type,
             map<workload-size,
                 map<operation_type,
                     map<axis_observer_type,
                         tuple<observer_special_compare_property_type, time>>>>>>>
```

Jede Tier-Binary hat damit über alle Permutationen ihrer **dynamischen** Achseneinstellungen (zur
Laufzeit einer **statischen** Tier-Binary) ein Map-System über die gemessenen **wall-clock-, Makro-
und Mikro-Benchmarks**. Jede Achse — im B+-Experimentbaum **compile-time separat** und **run-time
separat** durchgefahren — erhält eine vollständige Übersicht aller Eigenschaften und
Einzelmessungen. Ergebnis über alles: eine **multidimensionale Custom-Datenbank mit Messwerten**.

**Kardinalitäts-Auftrag:** Die Kardinalität der Typkonstrukt-Bestandteile ist strategisch zu
optimieren und in **Klassen und Hierarchien** einzuteilen, sodass die **Messsystem-Achsen**
(Registry/„Blut", `measurement_axis_registry.hpp`) die Auswertung ermöglichen.

## C. Filterkette = Chain of Responsibility (GoF), strikt im CacheEngineBuilder

Die Auswertungen ergeben automatisch eine **Filterkette**; das Pattern **Chain of Responsibility**
wird **strikt im CacheEngineBuilder-Bereich** für die **Kontrolle der Tier-Binary-GENERIERUNG**
umgesetzt (Auswertung → Filter → welche Permutationen werden als Nächstes gebaut/verworfen).

## D. Messfehler-Erkennung: 3-Varianten-Observer-Einbau + komplementärer 4. Schritt

Im Heuristik-Modus werden die Observer in DREI Bau-Varianten eingebaut:
1. in **allen** Tieren **und** dem Heuristik-Hybrid-Tier,
2. **nur** im Heuristik-Tier-Binary,
3. in **keinem** (nur Wall-Clock) — zur Erkennung des **Messfehlers durch Messinstanzen**.

**4. Schritt der heuristischen finalen Zusammenstellung:** die untergebenen Heuristik-Tier-Binaries
(nicht die final optimierte Haupt-Tier-Binary) werden **komplementär OHNE Mikro-/Makro-Benchmarks
und Observer** neu gebaut — Vergleich **rein an der Wall-Clock** gegen alle bekannten
Tier-Binary-Permutationen **und bekannte Paper-Algorithmen; der Paper-Vergleich geht vor**.

## E. IST-Diff (geprüft 10.07., ce `c022ce05`)

| SOLL-Baustein | IST | Diff/Verortung |
|---|---|---|
| Monolith-first | gelebt (Split-TODO dokumentiert) | Doktrin hier verankert; kein Bau nötig |
| Messkurven-Typsystem (B) | NUR Skeleton-Anfang: `curve_fit.hpp` (CurvePoint/MeasurementCurve = 1 Achse × 1 x-Dimension); die verschachtelte tree/map-Struktur (framework→type→size→op→observer_type→(property,time)) existiert NICHT | E4′-Strecke: Typsystem + Kardinalitäts-Klassen entwerfen (Eigenschaften-Deep-Research: Kardinalität je Ebene aus m3v2/Workload-Kanon ermitteln, NICHT erfinden) |
| Kardinalitäts-Klassen/Hierarchien (B) | fehlt | E4′-Strecke, nach Deep-Research |
| Chain of Responsibility im CEB (C) | **0 Code-Treffer** (nur 2 Alt-Doku-Erwähnungen 20260604/20260618); CEB-Bausteine existieren (build_orchestrator, best_binary_selector, cacheline_policy_selector) | Arbeitsmodus-Strecke: Filter-Glieder als CoR über den CEB-Generierungs-Pfad (build_orchestrator-Vorstufe); zero-cost/compile-time wo Hot-Path |
| 3-Varianten-Observer-Einbau (D) | fehlt — heute geben Facade/Treiber `COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1` HART an alle Tier-Kompilate; eine Varianten-Matrix existiert nicht. Fundament vorhanden: per-Kompilat-Defines + `MeasuredDelta.valid` (Messinstanz-Ehrlichkeit) | Hybrid-Strecke: Bau-Varianten als CEB-gesteuerte Define-Sätze je Messreihe (E4-XML-Dimension); Messfehler-Auswertung = Differenz der Varianten |
| Komplementärer 4. Schritt ohne Messinstanzen (D) | fehlt; Anker: `best_binary_selector` + SOTA-/Paper-Vergleich (`sota_catalog`, Pfad A/B) existieren | Hybrid-Strecke Schritt 4; Paper-Vergleich-Vorrang in die Auswertungs-Reihenfolge kodieren |
| Multidimensionale Mess-DB (B/E) | WIDE-CSV (Semikolon, lazy_csv_header) = flache Vorstufe | E4′: Typsystem ↔ CSV-Mapping (Spalten-Wahrheit s. curve_fit.hpp-Kopf) |

## F. Verortung im Plan

Reihenfolge unverändert: DATEN_GATED-Vorbauten ✓ (ce `c022ce05`) → **E4′-/Arbeitsmodus-Strecke
implementiert dieses Diff** (mit vorgelagertem Eigenschaften-Deep-Research zu Kardinalitäten und
Heuristik-Systemachse) → Hybrid-Strecke (3-Varianten-Bau + Schritt 4). Gated bleiben: realer Fit
(#156-Messdaten), PMC-Vollpfad (#215), `<measurement_categories>`-XML.
