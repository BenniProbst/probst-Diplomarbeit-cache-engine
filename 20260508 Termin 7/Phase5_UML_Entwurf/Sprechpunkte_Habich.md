# Phase 5 UML-Entwurf — Sprechpunkte fuer Prof. Habich

**Datum:** 2026-05-08 (woechentliches Treffen)
**Diplomand:** Benjamin Probst
**Thema:** Vorstellung des Architektur-Entwurfs vor Implementations-Beginn

---

## Was wird vorgestellt?

Eine drawio-Datei mit **vier Diagrammen** als Architektur-Vorentwurf:

1. **Architektur-Uebersicht** — die 6 Domaenen + Habich-Direktive + F15-These
2. **Cache-Engine-Detail** — F12-K Heap-Singleton-Hierarchie im Builder-Prozess
3. **Bausteine-Quer-Permutation (F15)** — die zentrale Forschungs-These
4. **Compiler-Layering (F-EXTRA-1)** — wie wir Originalcode + C++23 statisch linken

**Datei:** `Phase5_UML_Entwurf/phase5_architektur.drawio` (4 Tabs)

---

## Kern-Aussagen in 5 Saetzen

1. **Cache-Engine als getrennte Meta-Ebene** ist der Hauptbeitrag — keine der 33 Quellen hat das so umgesetzt.
2. **Bausteine-Quer-Permutation (F15)** zerlegt Algorithmen in 9 Achsen (Page / Node / Traversal / ValueHandle / MemoryLayout / Allocator / Prefetch / Concurrency / ISA) und permutiert sie kreuz-weise.
3. **Permutations-Identifier** ist ein **Flag-System nach Intel-CPUID-Vorbild** (9 uint64-Banken, je Achse eine Bank, je Implementation ein Bit).
4. **Habich-Direktive umgesetzt** durch Compiler-Layering: C++23-Schale + Original-Compiler-Bausteine → statisch zu .so/.dll/.dylib gelinkt.
5. **CacheEngineBuilder = main.cpp Orchestrator**: scannt Modul-Permutationen, baut fehlende adhoc, iteriert ueber alle Module, sammelt Mess-Records in In-Memory-Buffer, rendert LaTeX-Anhang fuer die Arbeit.

---

## Diagramm-Erklaerungen

### Diagramm 1 — Architektur-Uebersicht

**Sechs Domaenen mit klaren Abhaengigkeiten:**
- **Domaene 1 Search Engine** (blau): fan_out_engine (Tries / B-Baeume), Algorithm Strategies, Concepts
- **Domaene 2 Cache Engine** (orange, Kernbeitrag): Builder + Singleton + ConcurrencyManager + DecisionLambdaTrees
- **Domaene 3 Measurement** (gruen): In-Memory Buffer (KEINE DB!), perf/PAPI/HdrHistogram
- **Domaene 4 Hardware/ISA** (tuerkis): ISA-Dispatch, Hybrid-Cores, Memory-Type-Detector
- **Domaene 5 Engine-Choice** (rot): StaticEngine vs CacheEngine als Compile-Time-Wahl
- **Domaene 6 Persistence** (magenta): Disk-Dump + LaTeX-Renderer

**Zwei zentrale Beziehungen** (mit dicken Pfeilen):
- **Observer (Search → Cache):** Push synchron + DecisionLambdaTree-Filter (EXECUTE / DELAY / SKIP)
- **Visitor (Cache → Search):** Mid-Granularitaet `visit(IPage*)` / `visit(INode*)`

**Drei Direktiven** (rechts):
- Habich (indigo): Originalcode unangetastet + C++23-Hauptcompiler + Adapter
- F15-These (gelb): Bausteine-Quer-Permutation als Forschungskern
- Architekt (lila): GPL kein Hinderungsgrund (Modularisierung + Metaprogrammierung = neues Werk)

### Diagramm 2 — Cache-Engine-Detail (F12-K)

Zeigt die **Heap-Singleton-Hierarchie** innerhalb des Builder-Prozesses:

```
CacheEngineBuilder (Prozess, main.cpp)
   └─ HEAP-Region
        ├─ CacheEngine::instance()           «Heap-Singleton»
        │     └─ ConcurrencyManager::instance()  «Sub-Singleton»
        └─ Dynamisch geladene Module
              └─ binden CacheEngine::instance() als Ressource
```

**8 ConcurrencyManager-Disziplinen** + 3 Mechaniken (OLC / ROWEX / RCU)
**8 DecisionLambdaTrees** (PRO BAUSTEIN, kein globaler Default — F-EXTRA-6)
**constexpr Measure<Category, Detail>** als compile-time Mess-Matrix (F1)

**Experiment-Lifecycle** unten:
1. Platform-Probe → 2. Mode-Detection → 3. Module-Scan → 4. Adhoc Build →
5. Pro Modul: reset() → load() → Cache-Warmup → Experiment → spool() → unload()
6. Disk-Dump → 7. LaTeX-Renderer

### Diagramm 3 — F15 Bausteine-Quer-Permutation

**Neun Achsen** als blaue Spalten mit Beispiel-Implementierungen aus den 33 Papern.

**Vergleich:**
- **Traditionelle Studie** (rot): ART vs HOT vs Masstree als ganze Algorithmen
- **PRT-ART F15** (gruen): Quer-Mix (z.B. HOT-Compound + Masstree-Internal + LOUDS-RankSelect + Dynamic-ValueHandle + CSS-PointerFreeContig + ArenaPerSubtree + Khan-AdaptDist + RCU + AVX-512)

**Forschungs-These** (gelb, hervorgehoben):
> Permutationsraum (gefiltert) ≈ 500 Modul-Permutationen × 144 Test-Traces × 4 Plattformen ≈ **20.000 Experimente**

**Rolle der Cache-Engine** (lila): wirkt UNIVERSELL auf jede Bausteine-Kombination — das ist der Beweis der Verallgemeinerbarkeit.

### Diagramm 4 — Compiler-Layering (F-EXTRA-1)

**Drei Schichten:**
- **Schale (C++23)** in blau: Adapter, Concept-Bindungen, ABI-Interface, Cache-Warmup, Mess-Hooks
- **Bausteine (Original-Compiler je Algorithmus)** in indigo: P01 GCC 4.7+, P02 GCC 5+ (BMI2/AVX2), P04 GCC 11+ (C++20), ...
- **Static Linking → ABI-stabiles Modul** in orange: .so / .dll / .dylib mit Flag-System-Identifier

**Pipeline (F-EXTRA-5 REVIDIERT durch H6, 2026-05-08):** CMake-Funktionen + sh/bat-Helper → ConstraintFilter → parallel Build → 500+ Module (NO-PYTHON-DIREKTIVE; Talos OS hat kein Python-Standard)

---

## Diskussionspunkte / Offene Fragen fuer das Treffen

### Frage 1 — Empirische Realitaet des Compiler-Layerings
Wir kompilieren P01 ART mit GCC 4.7+, P02 HOT mit GCC 5+ usw. und linken sie statisch in C++23-Module. Frage: Sind die Original-Compiler-Versionen aus den Paper-Acknowledgements ausreichend dokumentiert, oder sollen wir die Autoren (P01-P30) explizit anschreiben?

### Frage 2 — Permutations-Volumen
~500 Modul-Permutationen × 144 Test-Traces × 4 Plattformen = ~20.000 Experimente. Realistisch in ZIH/Capella+Barnard/Grace-Hopper-Zeitkontingent? Sollten wir den Permutationsraum weiter beschneiden (z.B. nur "interessante" Quer-Mixe)?

### Frage 3 — F15 als Diplomarbeits-Schwerpunkt
Die Bausteine-Quer-Permutation ist der innovativste Beitrag. Sehen Sie Risiken in der Praesentation gegenueber dem Pruefungsausschuss (z.B. "zu breit, zu wenig tief")? Soll PRT-ART als eigener Algorithmus prominenter werden, oder reicht F15 als universale Aussage?

### Frage 4 — TUD-Code (P31 Ungethuem, P32 Schmidt, P33 VAMPIR)
Anfragen sind verschickt. Falls Sie direkt Zugriff vermitteln koennen — sind die Implementierungen aus dem Tomahawk DBA / Schmidt's Stride-Access / VAMPIR-Phase-1 fuer die akademische Diplomarbeit-Verwendung verfuegbar?

### Frage 5 — Schmeisser-Code (P06 B²-tree)
Wir haben heute b2-tree-master + bart-master via direkten Download erhalten. Lizenz ist unklar (keine LICENSE-Datei). Reicht der academic-citation-Ansatz, oder sollten wir nochmals bei Schmeisser/Schuele nach expliziter LICENSE-Festlegung fragen?

### Frage 6 — Bit-Identitaets-Pruefung (F-EXTRA-8)
Wir wollen pro Permutation eine ABI-Stabilitaets-Pruefung (Bit-Diff zwischen Original-Build und Splitting-Build). Bei Abweichung HABICH-LOG. Stimmt das Vorgehen mit Ihren Anforderungen ueberein, oder sollen wir nur funktionale Aequivalenz (gleicher I/O) verlangen?

### Frage 7 — Cluster-Status fuer Phase 5+
Fortigate-31G-Migration + COMDARE-Modules-GitLab-Push laufen. Welche Plattform ist fuer den ersten Prototyp am sinnvollsten? Vorschlag: ODROID H4 Ultra (x86-Workstation), dann Pi 5 + VisionFive 2 (eigene Compiler), dann ZIH (cross-compile + SOCKS5).

---

## Was ist BEREITS abgeschlossen (heute, Stand 2026-05-08)

**Konsolidierungs-Phase (Termin 7):**
- 33 Paper tieflektuere mit Cross-Konzeptmatrix
- 4 Glossar-Versionen (v3 → v6 mit allen Architektur-Beschluessen)
- Domaenenmodell v3 + v4_DELTA
- Architekturentscheidungen F1-F15 + F-EXTRA-1-8 (kanonisch)
- Flag-System-Spezifikation (CPUID-Vorbild)
- Bausteine-Matrix REV 1 mit Implementierungs-Pfaden
- Datasets-Spezifikation (YCSB + 6 Custom-Korpora)

**Phase 4.B (heute abgeschlossen):**
- 122-Verzeichnis-Skelett unter `Projekte/Research/comdare-cache-engine/`
- 12 Original-Repos in `ext/` (P01-P05, P06 NEU heute, P07, P10, P20, P25, P29, P30) — 120 MB
- 14 Re-Implementations-Skelette in `prt_art/legacy_reimpl/` (P11-P14, P16-P19, P21-P24, P26, P27)
- Apache 2.0 LICENSE + 307-Zeilen NOTICE-Datei (alle externen Lizenzen)
- Lizenz-Analyse pro Repo (Apache/MIT/ISC/GPL-3/LGPL/PENDING)
- Email-Kontakte vorbereitet (5 verschickt, 5 als Vorlage)

**Phase 5 (jetzt):**
- 4 drawio-Diagramme als Architektur-Vorentwurf (knallige Material-Design-Farben)

---

## Was ist NACH dem GO geplant (Phase 6+)

1. **PRT-ART Implementation** in `prt_art/` (5 Page-Types, Concepts, ValueHandle dynamisch)
2. **Re-Implementations** der 14 LEGACY_REIMPL-Paper aus den Originalpapern
3. **Permutations-Codegen** (CMake + sh/bat → 500+ ABI-stabile Module — H6/F-EXTRA-5 NO-PYTHON-DIREKTIVE)
4. **Experiment-Loop** auf 4 Plattformen (~20.000 Experimente)
5. **LaTeX-Anhang** mit Tabellen + pgfplots-Diagrammen aus In-Memory-Buffer

---

## Referenz-Dokumente (im Termin 7)

| Dokument | Zweck |
|----------|-------|
| `Architekturentscheidungen_F1_F15.txt` | Kanonische Beschluesse (F1-F15 + F-EXTRA-1-8 + Korrekturen F10-K, F12-K) |
| `Domaenenmodell_PRT_ART_v3.txt` + `v4_DELTA.txt` | Hauptarchitektur + Korrekturen |
| `Begriffsglossar_v3-v6_FINAL.txt` | 4 Glossar-Versionen (v6 ist aktuell) |
| `Flag_System.txt` | Vollstaendige Bit-Belegung der 9 Banken |
| `Bausteine_Matrix.txt` (REV 1) | Bausteine-Liste mit Implementierungs-Pfaden |
| `Datasets_Spezifikation.txt` | YCSB + 6 Custom-Korpora |
| `Cross_Paper_Konzeptmatrix.txt` | Cross-Mapping ueber 33 Paper |
