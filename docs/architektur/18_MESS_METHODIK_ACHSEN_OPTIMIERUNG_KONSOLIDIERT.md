# DOSSIER 18 — Konsolidierte Neuplanung: Mess-Methodik, Achsen-Optimierung & korrigierte E4-Umsetzung

> **Status:** Planungs-Dossier (2026-07-09). Konsolidiert die umfangreiche Planung + die Lehren aus zwei adversarial-revertierten Umsetzungen (Phase 1 #230, Phase 2 #221) dieser Session. **Erweitert Dossier 17** (E4-XML-Roadmap) um die vom User geklärte Mess-Methodik + Architektur. Baut auf Dossier 16 (E1-E4-Konsolidierung). Belege `datei:zeile`; Wurzeln: super = `probst-diplomarbeit-cache-engine`, ce = `super/Code/external/comdare-cache-engine`, mod = `Modules/comdare-measurement-all`, LEDGER = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`.

## 0. ZWECK & LEITSATZ

Diese Session hat **umfassend geplant, aber implementativ nichts persistiert** — beide Umsetzungsversuche (die `run_profile`-Fassade und die RC-Achsen-Verdrahtung) wurden nach max-Effort-code-reviews sauber revertiert, weil sie reale Fehler enthielten, die lokale Tests + Zeile-für-Zeile-Review übersahen. **Der bleibende Wert ist die Erkenntnis.** Dieses Dossier gießt sie in die belastbare, korrigierte Plangrundlage.

**Leitsatz (der eigentliche Wendepunkt):** Die Mess-Achsen und ihre Effekte werden **erforscht, nicht erfunden**. Jede Achse trägt eine Optimierungs-Eigenschaft (Min/Max einer messbaren Größe); die Messung dient dem übergeordneten Ziel, **mehrdimensionale statische Heuristik-Kurven** zu bestimmen, mit denen ein ausgemessenes System je Last, Füllstand und Beschaffenheit optimal konfiguriert werden kann. Das ist der wissenschaftliche Kern der Diplomarbeit — nicht Rohmessung, sondern **modellierte Optimierbarkeit**.

---

# TEIL A — DIE VERVOLLSTÄNDIGTE ARCHITEKTUR (was diese Session geklärt hat)

## A.1 Die ZWEI distinkten Achsen-Systeme (zentrale Klärung, User 09.07.)

Bisher implizit vermischt, jetzt bindend getrennt ([[feedback_system_axes_measurement_own_abstract_root_blood]]):

| | **Organ-Achsen (Tier-Binary)** | **System-Achsen (Mess-System)** |
|---|---|---|
| Rolle | das **Gemessene/Optimierte** | die **Mess-Instrumente** |
| Metapher | **Organe** (Tier) | **Blut** (durchdringend, nicht ein Organ) |
| Anzahl | ~19 (T0–T18) | die Mess-Kategorien (CLU, Cache-Miss L1/L2/L3, dTLB, Branch, IPC/CPI, Latenz, Durchsatz, Energie, Speicher-Fußabdruck) |
| Zugehörigkeit | Teil der **Gattungen/Lebewesen** | **NICHT** Gattungen |
| Austauschbarkeit | permutierbar (Composition) | **nicht austauschbar**, zentrale Systembestandteile |
| Präsenz | je Tier-Binary variabel | **IMMER präsent, sobald Messung an** |
| Wurzel | `AdHocComposition<T0..T18>` | **eigene abstrakte Klassen-Wurzel** (SOLL: `SystemAxis`/`IMeasurementSource`) |
| E-Ebene | E2/E3 (Permutationsbaum) | **E0-Querschnitt** (nicht im Baum) |

**Ist-Zustand (code-review-Agent 2, Dossier 17 B.3):** das System-Achsen-System liegt nur **fragmentiert** vor — `MeasurementCategory`-Enum + `IPmcSource` + `ComdareMeasurementSnapshotV1`-POD + `ObserverAggregate<19>` + Klassifikationen — **ohne gemeinsame abstrakte Wurzel**. Genau die zu schaffen (eine `SystemAxis`-Basis, immer instanziiert unter Messung, orthogonal zu den Organ-Achsen) ist der SOLL-Zustand.

## A.2 Die Optimierungs-Semantik je Organ-Achse (per deep research)

Jede Organ-Achse hat eine **Optimierungs-Eigenschaft = Min ODER Max einer messbaren Größe** ([[feedback_axes_optimization_semantics_deep_research_observer_strategy]]), z. B.:
- *minimiere* Lookup-Latenz / Speicher-Fußabdruck / Cache-Misses / dTLB-Misses / Branch-Misses;
- *maximiere* Durchsatz / Node-Fanout / Kompressionsverhältnis / Space-Efficiency.

Diese Eigenschaft steht **teils in der Thesis, teils muss sie per deep research** ermittelt werden (was messbar, was relevant, welcher reale Parameter). **Das ersetzt die #221-„Effekt-Erfindung".** Der deep-research-Lauf (Agent, Sessionende → `docs/sessions/backups/20260709-axes-optimization-deep-research/BEFUND.md`) liefert je Achse: Min/Max-Größe · Messbarkeit · realer Laufzeit-Knopf vs. honest-0 · Abhängigkeit von Last/Füllstand/Verteilung.

## A.3 Wirkungsweise je Achse = Observer-Strategy-Pattern

Die Effekt-/Mess-Logik je Achse ist als **Strategy-Pattern** hinter dem System-Achsen-Observer-Interface auszuführen — austauschbar/erforschbar je Achse, ohne den Kern zu berühren. Lehrbuch-Pattern (GoF Strategy), zero runtime cost via compile-time-Dispatch ([[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]], [[feedback_crtp_concept_guard_mix_pattern]], [[feedback_no_runtime_switch]]).

## A.4 Das übergeordnete Ziel: Heuristik-Kurven

Die Endauswertung (E4) bestimmt aus den Messungen **mehrdimensionale Kurven für statische Heuristik-Einschätzungen** über die Achsen-Parameter. Damit lässt sich für ein ausgemessenes System, gegeben **Last** (YCSB A–F / LP-Profile) + **Füllstand** (Einträge) + **Beschaffenheit** (Key/Value-Verteilung), die **optimale per-Achse-Konfiguration abschätzen** = echte Optimierung. Jede Messreihe ist ein Punkt in diesem Parameter-Raum; die Achsen-Sweeps spannen die Kurven auf.

## A.5 E4→E0 als strikte Interface-Layer

Bindende Disziplin (User 09.07.): saubere Interface-Grenzen zwischen den Ebenen, keine Vermischung. E4 (XML/Auswertung) · E3 (B+-Baum) · E2 (Tier-Binaries) · E1 (RC-Laufzeit) · E0 (Querschnitt inkl. **System-Achsen/Mess**). Die System-Achsen (Blut) sind E0-Querschnitt, **nicht** im E2/E3-Permutationsbaum.

---

# TEIL B — DIE LEHREN AUS DEN ZWEI REVERTS (als bindende Design-Constraints)

## B.1 Phase 1 (#230) — die Fassaden-Lehren (Backup `20260709-code-review-phase1-230/`)
Die GoF-Facade um das umbrella-schwere `run_profile` war **architektonisch korrekt**, scheiterte aber an:
- **C1 (super-Sub-Build):** die Fassade zieht via `all_axes_umbrella` die vendored Adapter (`mimalloc.h` …); ihr CMake muss die ~15 Adapter-Targets linken (`comdare::adapter::{a01..a11, p07..p30}` = `m3v2_pmc_smoke` spiegeln, `tests/unit/CMakeLists.txt:277-301`) **+ in `COMDARE_FACADE_PERM_INCLUDES`**. Standalone-ce versteckt das.
- **C2 (dünner Wrapper):** der E4-Dock in `main.cpp` ließ Harness-Sicherungen weg → wissenschaftlich ungültige/plattform-fehletikettierte Daten möglich. SOLL: `platform_override`, `min_free_gb` (RAM-Admission), `run_sota_series`-Opt-out, validiertes `max_binaries` (strtoull-Check), **0-Profile-Hard-Abort**, top-level try/catch (sonst bricht der additive Fallback).

## B.2 Phase 2 (#221) — die RC-Effekt-Lehren (Backup `-phase2-221/SYNTHESE.md`)
Die RC-Wiring-**Architektur** (`if constexpr(requires{organ_.set_runtime_X(…)})`) war ok, aber die **Effekte waren erfunden** (Dossier 17 unterspezifiziert). 8 CONFIRMED Mess-Bugs, die erst zur #156-Laufzeit manifestieren, als **Design-Constraints** für die Neuimpl.:
- **Keine Store-Invarianten brechen:** budget-gegatetes `append_slot` bricht `rebuild_` → Datenverlust. **Budget nur beim `insert` gaten, nie in `rebuild_`.**
- **Rückgabe prüfen:** `insert()`→false bei Reject, `tier_insert` muss das prüfen (sonst Über-Zählung + unbegrenztes Aux-Wachstum).
- **DEG muss die CSV erreichen:** batch_size in `axis_stats[0][6/7]` mit `kV3AxisSchema[0]`=`nullptr` → nie in der Ausgabe (Test grün nur via in-process POD). **In benannte Schema-Spalte routen.**
- **Reset-Semantik:** `if (X!=0)` → 0-Latch auf reused Tier (keine Achse je auf Default). **Pro Mess-Punkt echtes Reset.**
- **Kein Signal-Cross-Talk:** Budget-Policy-Rejections nicht in Allocator-`failure_count` falten; `clear()` muss Rejection-Counter resetten.
- **Rollback-Erhalt:** `restore_statistics` darf die probe-Counter nicht nullen.
- **honest-0 statt faken:** Achsen ohne echten Laufzeit-Knopf (z. B. thread_count = sequenzielle Locks „0 Contention" = physikalisch unmöglich) → **ehrlich compile-time-only**, kein Phantom-Effekt.
- **Vollständige Kopplung:** pool_budget nur für flat-store verdrahtet → Phantom bleibt für pool-Familien; entweder alle Familien oder ehrlicher „n/a"-Marker.

## B.3 Der übergreifende Verifikations-Constraint
Lokale ctest + golden-Roundtrip sind **unzureichend** — sie prüfen nur Happy-Path (frischer Tier, in-process POD). **Pflicht:** (a) **adversarialer max-Effort-code-review** vor „fertig" (fand bei BEIDEN Phasen reale Bugs); (b) **Edge-Case-Tests**: reused-Tier-Reset, budget<live-set, two-phase-Rollback-Erhalt, **CSV-Named-Column-Sichtbarkeit** (nicht in-process-POD), super-Sub-Build.

---

# TEIL C — DIE NEU GEPLANTE UMSETZUNG (korrigierte Roadmap, ersetzt Dossier 17 Phase 2/6-Details)

| Phase | Inhalt | Vorbedingung | Gate |
|---|---|---|---|
| **M0 Deep Research** *(läuft)* | je Achse: Min/Max-Größe · Messbarkeit · realer Knopf vs. honest-0 · Last/Füllstand-Abhängigkeit → `BEFUND.md` | — | zitierter Befund, Achsen-Klassifikation |
| **M1 System-Achsen-Wurzel (Blut)** | gemeinsame abstrakte Basis `SystemAxis`/`IMeasurementSource`; die Mess-Kategorien als Strategies darunter; immer präsent bei Messung; E0-Querschnitt, NICHT im Permutationsbaum; die fragmentierten `MeasurementCategory`/`IPmcSource`/POD-Spalten dahinter konsolidieren | M0 (welche Kategorien) | ctest + golden-neutral + super-Sub-Build |
| **M2 Observer-Strategy je Organ-Achse** | Wirkungsweise + Mess-Attribution je Achse als Strategy hinter dem System-Achsen-Interface; RC=0 echtes No-Op; DEG in benannte CSV-Spalte | M0/M1 | Edge-Case-Tests je Achse |
| **2′ #221 ehrlich neu** | NUR Achsen mit realem Laufzeit-Knopf verdrahten (aus M0), Rest honest-0; alle B.2-Constraints (Store-Invariante, Reset, kein Cross-Talk, CSV-sichtbar); Klar-Bug-Fixes A1-A9 | M0/M1/M2 | adversarialer Review + CI + Edge-Tests |
| **1′ #230 neu** | `profile_facade` mit den ~15 Adapter-Links + `COMDARE_FACADE_PERM_INCLUDES` + Voll-Harness-Parametern (B.1) | clang-format-22 lokal ✓ | super-CI grün + Review |
| **E4′ Heuristik-Auswertung** | die Mess-CSV → mehrdimensionale Kurven (je Achsen-Parameter × Last × Füllstand × Verteilung) → statischer Heuristik-Schätzer für optimale Konfig | Messläufe (#156) | Kurven-Validierung |
| **3-8 (Dossier 17)** | #188 Achsen-Uniformität → Limits-Entkopplung → #31/F7 Framework×Workload-Bib → #223 → #215/#156 Voll-Lauf | je Increment | je Gate |

**Reihenfolge-Logik:** M0 (Forschung) ist die Grundlage; ohne sie kein ehrliches #221. M1 (Blut-Wurzel) ist die saubere Mess-Infrastruktur, auf der M2/2′ aufsetzen. #230 (1′) ist unabhängig (Fassade) und kann parallel/danach. Die Heuristik-Auswertung (E4′) ist das wissenschaftliche Endprodukt.

---

# TEIL D — OFFENE METHODIK-ENTSCHEIDUNGEN (aus M0-Befund + User zu klären)
- **M1-Scope pool_budget:** alle Organ-Familien (btree/hash/swiss/…) oder flat-store-only + ehrlicher n/a-Marker?
- **M2-thread_count:** reale Nebenläufigkeit/Contention (anderer Mechanismus) oder ehrlich compile-time-only?
- **M3-value_handle inline_threshold:** RC-Override koexistiert mit version-tag/chain-depth-Accounting statt es zu ersetzen?
- **M4 übergreifend:** je Achse — realer Laufzeit-Knopf (dann Observer-Strategy) oder honest-0 (compile-time-only)? → entscheidet der M0-Befund + Thesis.

---

# TEIL E — KADENZ · DIREKTIVEN · GATES (bindend)
- **Erstimpl. = Codex** (`gpt-5.5`/xhigh, `sandbox=danger-full-access` [umgeht bwrap-Blocker], strikter Repo-Guardrail, kein Commit) **aus elaboriertem Spec + allen Referenzen**; **Claude = Zeile-für-Zeile-Review + Korrektur** + adversarialer max-Effort-code-review.
- **Verifikation je Increment:** `~/tools/cf22/usr/bin/clang-format-22 -i` + `--dry-run --Werror` · g++-16-Build · Edge-Case-ctest · **super-Sub-Build** (nicht nur Standalone-ce) · golden-Roundtrip==320 wo berührt · Mojibake `'Ã|â€'`==0 · adversarialer Review · granularer Commit (nie `git add -A`) · beide Remotes (origin=gitlab, github) · **CI strikt grün** vor nächster Aufgabe. Co-Authored-By: Claude Opus 4.8.
- **TABU ohne GO:** `permutation_axes.xml`, `golden_fullpilot_320`, ABI-MAJOR (==4), POD-`sizeof`, `GenusBindingTraits`. **System-Achsen sind E0-Querschnitt, dürfen NICHT die binary_id/E3-Permutation berühren.**
- **honest-0 > Phantom:** nie einen Achsen-Effekt faken, um ein Signal zu erzeugen — lieber ehrlich „nicht laufzeit-variabel".
- **Backups:** jeder Analyse-/Review-Lauf additiv → `docs/sessions/backups/`.

*Nach Freigabe wird dieses Dossier zur autoritativen Mess-Methodik-Doku; Dossier 17 Phase 2/6 werden durch Teil C hier präzisiert.*
