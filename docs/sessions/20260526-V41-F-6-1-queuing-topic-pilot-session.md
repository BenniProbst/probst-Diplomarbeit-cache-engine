# V41.F.6.1 queuing-Topic Pilot + Korrekturen — Session-Ende 2026-05-26

**Stand:** 2026-05-26 spaeter Nachmittag, Kontext-Ende
**Vorgaenger:** `20260526-V41-F-6-1-allocator-achse-vollausbau-session.md`
**Master-Doc:** `docs/architektur/11_konzept_achsen_extension_visitor_pattern.md`
**Achsen-Doku separat:** `docs/architektur/12_queuing_topic_achsen_eigenschaften.md`

---

## §1 Session-Zusammenfassung

Heute zweiter Topic-Pilot — **queuing**. User-Entscheidung: 2 Achsen mit
Cartesian-Product. Pilot mit 4 Buffer-Strategien (Q1) + 3 Flush-Policies (Q2).
Allocator-Schablone wurde getestet und mehrfach korrigiert.

**Wesentliche Schritte (chronologisch):**

1. Allocator-Achse 6 KOMPLETT (24 Vendor, 252 Tests) — Vorgaenger-Session
2. Memory `[[migrationen-ans-ende]]` angelegt (Reihenfolge fixiert)
3. User-Entscheidung 2-Achsen-Design queuing (axis_Q1 + axis_Q2 mit Cartesian)
4. queuing-Pilot Batch 1 angelegt (Naming initial NICHT analog Allocator)
5. **User-Audit identifizierte 6 Luecken** — alle korrigiert in Q1-Phase:
   - Q2 Statistik+Observer Pattern fehlte
   - std::queue-API (peek_front/peek_back/emplace) fehlte
   - TYPED_TEST(PutGetRoundtrip) + ShouldFlushDeterministisch fehlten
   - PermutationEngine-Test fehlte
   - Web-Recherche Scheduling-API fehlte (Agent durchgefuehrt)
   - Cross-Topic-Scheduling-TODO Task #663 angelegt
6. Memory `[[scheduling-cross-topic-interface]]` angelegt — Recherche-Ergebnis verankert
7. **User-Korrektur 2: Naming-Refactor zur Allocator-Konvention**
   - `axis_q1_buffer_strategy/` → `axis_q1_queuing/` (17 Files via git mv + sed)
   - Memory `[[neue-achse-strict-vorlage-allocator]]` angelegt mit 11-Pflicht-Punkte-Checkliste + 10-Delta-Tabelle
8. **User-Korrektur 3: Buffer-Size + Watermark Edge-Case-Tests**
   - kTestBufferCapacities (1/2/3/7/8/15/64/100/16384) — Extrem + Power-of-2 + non-Power-of-2
   - kTestFillLevelsAt100Cap (7 Edge-Werte um Watermark-Threshold)
   - ShouldFlushAtAllIterableThresholds (iteriert alle 5 iterable_values())
9. **User-Korrektur 4: Zero-Capacity Exception-Pflicht**
   - BoundedRing(0) wirft jetzt std::invalid_argument (UB-Vermeidung modulo)
   - Memory `[[zero-size-allocation-exception]]` angelegt
   - Test ZeroCapacityThrows ergaenzt

## §2 Tests-Bilanz Evolution heute (queuing-Topic)

| Phase | Tests | Aenderung |
|:-----:|:-----:|-----------|
| Pilot (initial) | 42 | TYPED_TEST_SUITE Q1+Q2 Skelett + Verhaltens-Tests |
| nach Q1-Korrekturen | 75 | +33 Tests (Statistics+PutGetRoundtrip+Peek+PermutationEngine+Observer-Notify) |
| nach Naming-Refactor | 75 | unveraendert (rein Rename) |
| nach Edge-Cases | 80 | +5 (BufferCapacities + Watermark-Fill-Iteration + Non-Standard) |
| nach Zero-Cap-Fix | **81** | +1 (ZeroCapacityThrows) |

**Stand cache-engine standalone: 252 allocator + 81 queuing = 333 Tests gruen.**
**Diplomarbeit: 104/104.**

## §3 Commits heute (Diplomarbeit-Repo, chronologisch)

| Commit | Inhalt |
|--------|--------|
| `f74069b` | Allocator-Achse-Vollausbau Submodule-Bump (cache-engine ce27752) |
| `2775859` | Session-Doku Allocator-Vollausbau (427 Zeilen elaborat) |
| `0aaa09f` | queuing-Topic Pilot Submodule-Bump (cache-engine 6ddd6fc) |
| `b57fc98` | Q1-Korrekturen Submodule-Bump (cache-engine def91b2) |
| `3471592` | Naming-Refactor + Edge-Cases Submodule-Bump (cache-engine c844e6d) |
| (pending) | Zero-Cap-Fix Submodule-Bump + Session-End-Doku |

## §4 Memory-Files heute neu (4 + 1 erweitert)

1. `feedback_migrationen_ans_ende.md` — F.6.x Reihenfolge: ZUERST alle Topics+Achsen+src, DANN Migration alter Strukturen
2. `reference_scheduling_cross_topic_interface.md` — Recherche-Ergebnis: kein universelles SchedulingPolicy in Industrie; Empfehlung 16te Achse + CRTP-Concept + P2300 std::execution::sender
3. `feedback_neue_achse_strict_vorlage_allocator.md` — **11-Pflicht-Punkte-Checkliste** pro neuer Achse + 10-Delta-Tabelle vom queuing-Pilot + Anti-Patterns
4. `feedback_zero_size_allocation_exception.md` — Buffer-Konstruktion mit cap=0 wirft Exception (UB-Vermeidung); Domain-Regel-Tabelle
5. `feedback_vendor_sonderfaelle_als_pflicht_property.md` — erweitert um Stufen-Pattern (enum class statt 2-bool-Implikation)

## §5 Kritische User-Direktiven heute (verbatim relevant)

- "Alle uebrigen Migrationen kommen ans ENDE" — Reihenfolge fixiert
- "Jede Achse folgt einzeln den Vorlagen der Allokator Achse" — strikt sed-able Pattern
- "Naming-Konvention wird klar an der Allokator Achse orientiert" — Refactor erfolgt
- "Buffer Größen weder Extremfaelle noch Hand voll Test-Groessen" — Edge-Case-Liste ergaenzt
- "Allokation von 0 — Exception werfen" — BoundedRing(0) throws std::invalid_argument

## §6 Tasks-Stand

Heute neu:
- #662 Q1 Korrekturen (completed)
- #663 SCH Cross-Topic-Scheduling-Interface (pending — 16te Achse-Plan)
- #664 SCHW Web-Recherche (completed)

Vendor-Vollausbau-Stand:
- **allocator-Topic:** 1/15 Topics ✅ KOMPLETT (24 Vendor)
- **queuing-Topic:** 2/15 Topics — Pilot 4+3, Vollausbau in Folge-Batches (Q1 10 weitere, Q2 2 weitere)
- 13 Topics offen (traversal, nodes, memory_layout, prefetch, telemetry, serialization, value_handle, hardware, search_engine, io, migration, filter)
- **+1 Meta-Achse spaeter:** scheduling/ (Task #663, Implementation nach allen 15 Topics)

## §7 Naechste Schritte

**Sofort (Batch 2 queuing):**
- 3 weitere Q1-Strategien: AppendOnly (Q-APP) + PriorityHeap (Q-PRIO) + SkiplistBuffer (Q-SKIP)
- pro neuem Vendor: strikt nach `[[neue-achse-strict-vorlage-allocator]]` Checkliste
- Edge-Case-Tests + Zero-Boundary-Exception falls anwendbar
- TYPED_TEST_SUITE auto-expandiert ohne Test-Code-Aenderung

**Roadmap queuing-Topic:**
- Batch 2-5: 9 weitere Q1-Strategien (Q-APP/PRIO/DELTA/SKIP/TOMB/COW/EPOCH/BATCH/SPSC/MPMC)
- Batch 2 Q2: TimedFlush + AdaptiveLsmFlush
- Vollausbau: 13 Q1 × 5 Q2 = 65 Buffer×Flush-Kombinationen vor Cross-Constraint-Filter

**Roadmap nach queuing:**
- 13 weitere Topics analog Allocator-Schablone
- Dann Meta-Achse scheduling (Task #663)
- Dann src/-Hilfsfunktionen Vollausbau
- ZULETZT Migration alter Strukturen ([[migrationen-ans-ende]])

## §8 Cross-Repo-Stand

| Repo | HEAD | Status |
|------|------|--------|
| Diplomarbeit (PUBLIC) | (pending Session-Push) | ✅ allocator+queuing-Korrekturen gepushed |
| cache-engine standalone | `c844e6d` (Naming-Refactor) → pending Zero-Cap-Fix | ✅ Pilot komplett |
| prt-art | unveraendert seit 2026-05-25 | — |

## §9 Lessons-Learned (3 Hauptpunkte)

1. **Pilot-First mit Schablonen-Disziplin von Anfang an** — der queuing-Pilot
   produzierte 10 Deltas, weil nicht systematisch gegen Allocator-Vorlage
   gearbeitet wurde. Memory-File `[[neue-achse-strict-vorlage-allocator]]` ist
   jetzt verbindliche Checkliste fuer die 13 verbleibenden Topics.

2. **Edge-Cases gehoeren in den Pilot** — Buffer-Size 0/1/2/3/Extrem + Alignment
   (Power-of-2 vs non-Power-of-2) muessen von Anfang an im TYPED_TEST oder
   Standalone-Test sein. cap=0 ohne Exception waere silent UB bei Modulo.

3. **Web-Recherche VOR Sonderfall-Implementation** — Scheduling-Recherche kam
   spaet (Task #664), Ergebnis war wichtig fuer 16te-Achse-Plan. Bei jeder
   neuen Topic-Domaene: Recherche-Agent VOR Pilot-Implementation.

## §10 Naechste Session beginnt mit:

1. MEMORY.md + dieses Doc + `12_queuing_topic_achsen_eigenschaften.md` lesen
2. Build-Verifikation 252 allocator + 81 queuing + 104 Diplomarbeit gruen
3. **Batch 2 queuing-Topic** (AppendOnly + PriorityHeap + SkiplistBuffer)
4. Pro neuer Strategie strikt nach `[[neue-achse-strict-vorlage-allocator]]`
   11-Pflicht-Punkte-Checkliste
5. Edge-Case-Tests + Zero-Boundary-Exception
6. Memory-Files schon vorhanden — KEINE neuen noetig (Pattern jetzt gelockt)
