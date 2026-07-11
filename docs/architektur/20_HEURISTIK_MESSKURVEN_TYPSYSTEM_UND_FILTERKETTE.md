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
| Messkurven-Typsystem (B) | NUR Skeleton-Anfang: `curve_fit.hpp` (CurvePoint/MeasurementCurve = 1 Achse × 1 x-Dimension); die verschachtelte tree/map-Struktur existiert NICHT. **tree<axis>-WURZEL-Slice deep-researched (wf_a984063b, 2 Kritiker BLOCKER): GATED — Null-Consumer-Trap.** | Die WURZEL-Spine (axis_layer_spine.hpp) hätte NULL Produktions-Konsumenten (nur test_phase6_vorbau) → wiederholt das verworfene axis_binding_registry (Doc §I). Doc §I fordert echten Konsument + Contract-Test; der reale E4-Reporting-Konsument ist **data-gated (#156)**. WURZEL landet MIT dem Konsumenten, wenn Cluster-Daten da sind. Map-Ebenen fork-gated. Backup: `docs/sessions/backups/20260711-e4prime-messkurven-typsystem-wurzel/`. |
| Kardinalitäts-Klassen/Hierarchien (B) | fehlt | E4′-Strecke, nach Deep-Research |
| Chain of Responsibility im CEB (C) | **Slice 1 ✅ ce `076b71cf`, CI-grün 2026-07-11**: `selection_filter_chain.hpp` (FilterVerdict/FilterHandler-CoR + ResumeFilter = Auswertung→Generierung-Feedback-Kante, S4 mess-getrieben) + `test_d15`. Deep-Research wf_749c9118 + 2 Kritiker (Survive-Defekt/H1-Richtung behoben). | **Gated-Rest** (additiv als weitere Kettenglieder): PaperComparison (§D-Schritt-4) = data-gated (keine Paper-Wall-Clock-Referenz); Pareto/Dominanz (§B) = braucht das Messkurven-Typsystem. Backup: `docs/sessions/backups/20260711-e4prime-cor-filter-chain/`. |
| 3-Varianten-Observer-Einbau (D) | fehlt — heute geben Facade/Treiber `COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1` HART an alle Tier-Kompilate; eine Varianten-Matrix existiert nicht. Fundament vorhanden: per-Kompilat-Defines + `MeasuredDelta.valid` (Messinstanz-Ehrlichkeit) | Hybrid-Strecke: Bau-Varianten als CEB-gesteuerte Define-Sätze je Messreihe (E4-XML-Dimension); Messfehler-Auswertung = Differenz der Varianten |
| Komplementärer 4. Schritt ohne Messinstanzen (D) | fehlt; Anker: `best_binary_selector` + SOTA-/Paper-Vergleich (`sota_catalog`, Pfad A/B) existieren | Hybrid-Strecke Schritt 4; Paper-Vergleich-Vorrang in die Auswertungs-Reihenfolge kodieren |
| Multidimensionale Mess-DB (B/E) | WIDE-CSV (Semikolon, lazy_csv_header) = flache Vorstufe | E4′: Typsystem ↔ CSV-Mapping (Spalten-Wahrheit s. curve_fit.hpp-Kopf) |

## F. Verortung im Plan

Reihenfolge unverändert: DATEN_GATED-Vorbauten ✓ (ce `c022ce05`) → **E4′-/Arbeitsmodus-Strecke
implementiert dieses Diff** (mit vorgelagertem Eigenschaften-Deep-Research zu Kardinalitäten und
Heuristik-Systemachse) → Hybrid-Strecke (3-Varianten-Bau + Schritt 4). Gated bleiben: realer Fit
(#156-Messdaten), PMC-Vollpfad (#215), `<measurement_categories>`-XML.

## G. Kardinalitäts-Synthese (Deep-Research wf_62fe0731, 10.07. — nur Bestand, nie erfunden)

Volle Synthese: `docs/sessions/backups/20260710-kardinalitaeten-deep-research/BEFUND-KARDINALITAETEN.md`
(4 Quellen-Agenten über Backups/Workload-Kanon/Observer/Achsen → 71 Bestand-Befunde datei:zeile).
Kardinalität je Typsystem-Ebene (HEUTE gefahren / PLAN-Kanon / GATED):

| Ebene | HEUTE | PLAN | GATED/Fork |
|---|---|---|---|
| `tree<axis>` | 19 Slots; Wurzel-Split **5 dynamic / 14 compile**; Registry-Gesamtraum 26 | Compile-Unterklassen 8/2/3 + 2 Laufzeit-Sonderknoten | Sonderstatus-Trio T2/T1/T10 |
| `map<workload-framework>` | 1 verdrahtet (YCSB) | 13-Kanon → 14 LP abstrahiert | Framework×Workload-Bib EXTERN_GATED |
| `map<workload-type>` | 6 gefahren (YCSB A–F); 21 LP-XML Bestand | 14 Kanon-LPs | 3-Mengen-Fork #31-Schritt-2 |
| `map<workload-size>` | 4 Sweep {2¹⁴,2¹⁷,2²⁰,2²³} | ~4 Cache-Regimes + 2 Gates | absolut vs. maschinenrelativ |
| `map<operation_type>` | 6 Runner (`kOpKindNames`) / 6 XSD (nicht 1:1) | 3-Größen-Aggregat (Heuristik) | Runner↔XSD-Kanon |
| `map<axis_observer_type>` | 16 MeasurementCategory (9 TimeObserver + 7 PmcCounter); 19×8=152 Slots/97 Felder | Achse×Observer-Matrix 3–5/Achse | PMC-Vollpfad #215 |
| `tuple<property,time>` | 2 Objectives impl.; Blatt = MeasurementRecord 32B | 19 Min/Max-Semantiken, ≥3 Pareto (T6/T18/T5); 2 Kurven-Klassen | Kurven gated #156/#162 |

**Warnung (belegt):** Die Literalzahl 137.594.142.720.000 ist ein Flag-Snapshot vom 02.06.; für
Kardinalitäts-Klassen gilt nur die **Produkt-Identität** `binary_count() == Π mp_size(Enabled_i)`,
nie die Literalzahl. Der Raum wird nie voll materialisiert (C1060).

**Drei Kardinalitäts-Klassen (KK, im Rahmen der gesetzten Patterns P1 compile-time-Metaprog / P2
Registry-als-Blut / P3 CoR-im-CEB):**
- **KK-1 compile-time-fix** — Kardinalität = Design-Konstante, consteval-Registry + static_assert
  (19 Slots, 16 Kategorien, 2 Regimes, 5 RC-Felder, 10 MeasuredEvent, 6 op_type; NEU: 19-Achsen
  compile/dynamic-Split + Vergleichs-Semantik nach P2-Muster).
- **KK-2 profil-gebunden** — Kardinalität = Daten-/Profil-Produkt (E4-XML backt sie), Guard =
  Identitäts-Invariante `binary_count()==Π mp_size(Enabled_i)`; Enabled-Listen 4/3/2/…/15/5,
  Kataloge 320+16+4+4, compile_dims 6, working_set_sweep 4.
- **KK-3 runtime-frei** — Laufzeit-Iterationsraum je statischer Binary (DynamicVariableNode-Odometer):
  RC-5-Felder × Stützstellen, dyn-Settings 27(m3v2)/18(m2), hw_prefetcher 3, repetition 3 (KF-10).

## H. Offene Punkte — NUR User-Entscheid (blockieren die map<>-Ebenen des Typsystems)

Diese sieben Forks bestimmen die Map-Schlüssel-Kardinalitäten und sind laut Bestand NICHT entschieden;
die tree<axis compile/dynamic>-Wurzel (§G Zeile 1) ist davon UNABHÄNGIG und wird zuerst gebaut.

1. **workload-type-Kanon-Fork** (3 Mengen: 6+3 Custom / 6+2 IH-LH / F7 A/C/E×6) — #31-Schritt-2.
2. **„Beschaffenheit" (Key/Value-Verteilung, ≥5 Facetten)** — eigene Map-Ebene vs. in workload-type kodiert (= Änderung der wörtlichen Doc-20-Vision).
3. **workload-size-Semantik** — absolute N-Liste vs. maschinenrelative Cache-Regime-Klassen.
4. **operation_type-Kanon** — Runner-6 (mit clear) vs. XSD-6 (mit Update/Range-Delete); clear = Op oder Phase?
5. **framework-Ebenen-Semantik** — {YCSB, LP} (2) vs. 13-Framework-Registry.
6. **Tuple-Erweiterung** — Doc-20-Blatt ist wörtlich `tuple<property,time>` (EIN Property); Pareto-Befund verlangt Front-MENGE + Objective-Tag je Bestkonfig.
7. **Sonderstatus-Trio** — T2 eigene Mess-Achse behalten/als Sub-Aspekt entfernen; T10 als Meta-Achse aus den 19 Organ-Slots (berührt kV3AxisCount=19-Verträge!); T1-Attributions-Constraint kodieren.

## I. Konsolidierungs-Constraint für die tree<axis>-Wurzel (Review-Lehre wf_0f5a1d9c, 10.07.)

Ein erster fork-unabhängiger Bau der compile/dynamic-Wurzel als eigenständige consteval-„Blut"-Registry
(`axis_binding_registry`) wurde gebaut, adversarial reviewt (wf_0f5a1d9c) und **VERWORFEN** — Artefakte
+ Review in `docs/sessions/backups/20260710-axis-binding-registry-VERWORFEN/`. Grund (3 CONFIRMED, selbst
verifiziert): die 14/5-compile/dynamic-Klassifikation existiert bereits als **autoritative Single-Source**
in `builder/experiment_tree/profile_to_tree.hpp:68-87` (`is_static`-Flag je `AxisLevel`; die 5 dynamischen
Achsen concurrency/prefetch/allocator/cache_traversal/value_handle mit exakt den RC-POD-Feldnamen). Diese
Datei erklärt sich seit der **Doppelquellen-Konsolidierung 18.06.** wörtlich zur „EINZIGEN Quelle dieser
Dimensionen"; eine parallele Registry hätte genau die weg-konsolidierte Doppelquelle wieder eingeführt
(zusätzlich: toter cross-layer-Include measurement→builder; Cap-Werte ohne compile-time-Kopplung an
abi_adapter; null Produktions-Konsumenten).

**Bindende Constraint für den späteren Typsystem-Bau:** Die tree<axis compile/dynamic>-Wurzel ist NICHT
greenfield. Eine compile-time-enumerierbare Achsen-Klassifikation ist erst dann gerechtfertigt, wenn der
Typsystem-Bau ihr (a) einen echten Konsumenten gibt UND (b) sie per Contract-Test gegen die
`is_static`-Ausgabe von `build_axis_levels` gekoppelt wird (Producer-Konsistenz statt drift-anfälliger
Zweitkopie) — ODER `profile_to_tree` wird der Konsument (build-time-Ableitung), was den golden-sensitiven
binary_id-Pfad berührt und einen eigenen, golden-verifizierten Increment erfordert. Der Deep-Research-BEFUND
(§G) liefert die Kardinalitäten dafür; der Bau selbst wartet auf Konsument + die 7 User-Forks (§H).


> **SUPERSEDIERT/PRÄZISIERT (2026-07-10):** Das „orthogonal compile/dynamic"-Bild aus §I ist durch das autoritative **Layer-/Haupt-Unter-Achsen-Modell** in `21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` ersetzt (User-Klärung + Achsen-Utilization-Audit wf_73129d50). Die 7 §H-Forks sind dort ALLE entschieden; §H bleibt als Historie stehen.
