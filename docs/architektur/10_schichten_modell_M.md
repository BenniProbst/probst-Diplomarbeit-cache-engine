# Schichten-Modell M — Diplomarbeit / CacheEngineBuilder / CacheEngine / Pruefling

> ---
>
> ## ⚠️ STAND 2026-08-07: PFADE UND REPO-ZUSCHNITT UEBERHOLT (Dokument vom 18.05.)
>
> **Die Vier-Subsystem-Trennung und die bidirektionale Pruefling-Beziehung gelten weiter. Die
> Pfad- und Repo-Angaben nicht.** Dieses Dokument traegt keinen SUPERSEDED-Banner, ist aber knapp
> drei Monate alt. Belege gegen ce `ba069e38` und super HEAD.
>
> | Zeile | steht im Dokument | Ist-Stand 07.08. | Beleg |
> |---|---|---|---|
> | `:107` | „`Diplomarbeit/Code/messung_driver/` — **eigenes Repo + eigene Build-Unit**" | **Pfad existiert nicht.** Heute `Code/02_messung_driver/` -- nummeriertes Glied einer neunteiligen Pipeline (`01_sample_data_generator` bis `09_tex_formatter`), **kein eigenes Repo**, sondern Unterordner von `Code/`. (`find` nach dem Basisnamen `messung_driver*` ueber beide Baeume: null Treffer) | super `Code/02_messung_driver/` |
> | `:199` | „`cache-engine/libs/cache_engine/cache_engine.hpp`" | **eine Ebene tiefer**: `libs/cache_engine/include/cache_engine/cache_engine.hpp` | ce, `find`-belegt |
> | `:110`, `:186` | „`comdare-prt-art/prt_art/`", `prt_art_search_engine_adapter.hpp` | Repo-Wurzel verschoben: prt-art liegt heute als Submodul unter `Code/external/comdare-prt-art`. **Im Arbeitsbaum ist es leer (nicht ausgecheckt)** -- der Unterpfad ist damit **nicht verifizierbar**; die genannte Adapter-Datei findet sich in keinem der beiden Baeume. **Kein belastbarer Nullbefund** | super `Code/external/` |
> | `:262-263` | §8 „`CacheEngine::register_engine(IExecutingEngine&)` muss public + dokumentiert sein — V32 Code-Audit"; „`prt_art` Constructor muss `CacheEngine&` annehmen — V32 Refactor" | **Gegenstandslos.** Das prt_art-Legacy-Skelett wurde am **2026-06-01 entfernt**; der Adapter heisst heute `cache_engine_execution_engine_adapter.hpp`. `register_engine` existiert im ce-Code nicht | ce `execution_engine/execution_engine_base.hpp:20`; `include/cache_engine/abi/cache_engine_execution_engine_adapter.hpp:9` |
>
> **Weiterhin korrekt (nicht anfassen):** `:82`, `:108`, `:199` `cache-engine/apps/cache_engine_builder/`
> samt `main.cpp` · `:109` `cache-engine/libs/cache_engine/`.
>
> **Ungeprueft:** `:2`/`:4` die Zaehlungen „12 Sub-Engines C1-C12", „29 Cache-Strategien F1-F29",
> „~80-85 IHeuristik-Instanzen", „ConcurrencyManager (8 Disziplinen + 3 Mechaniken)" -- dafuer
> liess sich **kein Code-Anker finden**. Die heutige `ICacheEngine`-Fassade vermittelt sechs
> ausgelagerte Submodule, die laut Header „via E4.1 noch leer und damit V42-gated" sind
> (`ce include/cache_engine/api/i_cache_engine_tools.hpp:9-11`). Ob 12/29/80-85 je Code waren oder
> reine Konzept-Zaehlungen sind, ist aus dem Code nicht entscheidbar.
>
> ---

**Stand:** 2026-05-18 (Phase M.2)
**Vorgaenger:** `02_aktueller_master_REV7_7.md` §2 Drei-Repo-Layer (REV7.6)
**Trigger:** User-Direktive 2026-05-18 (KRITISCHE KLARSTELLUNG)
**Ziel:** Eindeutige Trennung der 4 Subsysteme + bidirektionale Pruefling-Beziehung formalisieren.

---

## §0 KRITISCHE KORREKTUR AA.2 (2026-05-18 spaet)

**User-Korrektur 2026-05-18:** Das im REV7-Stand beschriebene "CE bindet Pruefling ein"-Modell ist UNVOLLSTAENDIG und teilweise falsch. **Korrekte Sicht:**

> "Beide [CacheEngine und PRT-ART] werden in erster Linie durch die CacheEngineBuilder orchestriert. Hier ist noch ein Design-Fehler, weil beide in erster Linie durch die CacheEngineBuilder orchestriert werden."

### §0.1 Was ist korrekt?

- **CacheEngineBuilder** orchestriert **BEIDE ExecutionEngines parallel**:
  - **ExecutionEngine A = CacheEngine** (selbst eine ExecutionEngine, nicht nur Werkzeug-Bibliothek!)
  - **ExecutionEngine B = PRT-ART** (gleichwertig zu CacheEngine, nicht "im CE-Subsystem")
- **Command-Pattern** wird verwendet um die beiden EE-Performances zu vergleichen
- CacheEngineBuilder ist der **Test-Treiber** mit ICommand-Hierarchie

### §0.2 Was bleibt unveraendert?

- 4-Subsystem-Trennung (messung_driver / CEB / CE / Pruefling) als grobe Struktur
- CEB ist autonomes Plattform-Ausmess-System
- Phasen 1-7 Pipeline
- Bidirektionale Beziehung CE<->PA (jetzt aber als gleichberechtigte EEs)

### §0.3 Wo ist der Design-Fehler im alten M-Modell?

- §2.1 Subsystem-Rollen-Tabelle: CacheEngine als "Werkzeug-Bibliothek" zu klein gegriffen — CE ist EINE der zwei EEs
- §3 Bidirektionale CE<->PA: "(a) CE -> PA: instantiiert" UNGENAU — beide werden vom CEB instantiiert (nicht CE-instantiiert-PA)
- §5 Phasen 1-7: Phase 5 BIND "CEB+CE Owner" UNVOLLSTAENDIG — Owner ist CEB allein, der beide EEs registriert

### §0.4 V32-Implementierungs-Konsequenz (DD.1+DD.2+DD.3)

- `CacheEngineBuilder` braucht `ICommand`-Hierarchie (ExecuteEngineACommand, ExecuteEngineBCommand, CompareResultsCommand)
- `CacheEngine` wird selbst zur ExecutionEngine (implementiert IExecutingEngine + ISearchEngine, gleich wie PRT-ART)
- `PrtArtSearchEngine` ist ExecutionEngine B (kein "Pruefling-Adapter im CE-Subsystem")
- `messung_driver` registriert BEIDE EEs beim CEB (nicht "CE wird gebaut + PA als Pruefling")

### §0.5 Korrekturen in nachgelagerten Doks

- `11_axes_vs_strategies_disambiguation.md` §10.9 R.9: V1-V4 sind ENGINE-CHOICE-DIMENSION der CE-as-EE-A
- `Y4_cross_repo_beziehungen.md` §3 ABI: CacheEngine implementiert auch IExecutingEngine
- drawio Tab 47 MCORR + neuer Tab CC.1 (M-CORRECT-V2 mit Command-Pattern)

**Folgesektionen 1-8 bleiben fuer Memory-Direktive (NIE Doku loeschen), aber sind ab §0 als korrekturbeduerftig markiert. Die folgende ueberholte Sicht wird durch AA.2-Korrektur in §0 oben relativiert.**

---

## §1 KERNSATZ (User-Direktive 2026-05-18, verbatim — UEBERHOLT durch §0)

> "CacheEngineBuilder und CacheEngine sind formal 2 getrennte Systeme, die dennoch zum selben Projekt gehoeren. Der CacheEngineBuilder ist ein autonomes System zum Ausmessen einer Plattform, waehrend die CacheEngine dabei als Werkzeug verwendet wird. Die CacheEngine kann einen registrierten Pruefling (PRT-ART) als Struktur ueber alle Permutationen mit einbinden und dessen Konfigurationen gegenpruefen, **waehrend dieser die CacheEngine mit benutzt, um die eigene Performance auszumessen und zu optimieren**."

**Schluesselbeobachtung:** Die CE<->Pruefling-Beziehung ist **bidirektional symmetrisch** — CE benutzt Pruefling als Permutations-Struktur UND Pruefling benutzt CE als Optimierungs-Service. Diese Symmetrie war in REV7 implizit, wird hier explizit.

---

## §2 4-Subsystem-Modell

```
+================================================================+
|  Diplomarbeit/Code/messung_driver  (OUTER-LOOP / Auswertung)   |
|  - 3 Messreihen-XML-Configs (A/B/C)                            |
|  - Loop ueber Configs                                          |
|  - ResultAggregator -> CSV/JSON -> TikZ-Diagramme              |
|  - thesis-Manuskript-Anhang                                    |
+================================================================+
                  |  konfiguriert/triggert
                  ▼
+================================================================+
|  CacheEngineBuilder  (AUTONOMES Subsystem)                     |
|  - PIKA-aehnliches Plattform-Ausmess-System                    |
|  - Phasen 1-7 Pipeline (DISCOVER/MEASURE/CLASSIFY/PUBLISH/     |
|    BIND/EXECUTE/COMPARE)                                       |
|  - Enumeriert Permutationen pro Search-Engine                  |
|  - Verwendet CacheEngine als Werkzeug                          |
|  - Verwendet IPlatformProbe fuer Auto-Discovery                |
|  Eigentumsverhaeltnis: cache-engine/apps/cache_engine_builder/ |
+================================================================+
                  |  verwendet als Werkzeug
                  ▼
+================================================================+              +======================+
|  CacheEngine  (WERKZEUG-BIBLIOTHEK)                            |◄────────────▶|  Pruefling (PRT-ART) |
|  - 12 Sub-Engines C1-C12                                       | bidirektional|                       |
|    (Layout, Pinning, Prefetch, Coherence, Telemetry,           |              |  ExecutionEngine      |
|     Allocation, Migration, Encoding, Heuristik,                |              |  registriert bei CE   |
|     Topologie, Scheduler, Filter)                              |              |                       |
|  - 29 Cache-Strategien F1-F29                                  | (a) CE -> PA |  PrtArtSearchEngine   |
|  - ~80-85 IHeuristik-Instanzen                                 | (b) PA -> CE |  PrtArtSearchEngine-  |
|  - DecisionLambdaTrees pro Baustein                            |              |    Adapter            |
|  - ObserverRegistry + Event-Hierarchie                         |              |                       |
|  - ConcurrencyManager (8 Disziplinen + 3 Mechaniken)           |              |  - Nutzt CE-Services  |
|  Eigentumsverhaeltnis: cache-engine/libs/cache_engine/         |              |    (Telemetry,        |
+================================================================+              |     Prefetch,         |
                                                                                |     Heuristik)        |
                                                                                +======================+
```

### §2.1 Subsystem-Rollen-Tabelle

| Subsystem | Rolle | Eigentumsverhaeltnis | Eigenstaendigkeit |
|---|---|---|---|
| **Diplomarbeit/Code/messung_driver** | Auswertung-Orchestrator (OUTER LOOP) | `Diplomarbeit/Code/messung_driver/` | eigenes Repo + eigene Build-Unit |
| **CacheEngineBuilder** | Autonomes Plattform-Ausmess-System | `cache-engine/apps/cache_engine_builder/` | eigenes Executable, kann ohne `messung_driver` laufen |
| **CacheEngine** | Werkzeug-Bibliothek (Cache-Optimierungs-Services) | `cache-engine/libs/cache_engine/` | Library (.lib/.so), keine main() |
| **Pruefling (PRT-ART)** | Registrierte ExecutionEngine + CE-Konsument | `comdare-prt-art/prt_art/` | Library + Tests, baut auf CE auf |

### §2.2 Beziehungs-Tabelle

| Pfeil | Richtung | Bedeutung | Konkrete API |
|---|---|---|---|
| 1→2 | messung_driver → CacheEngineBuilder | konfiguriert + triggert Permutations-Lauf | `messung_driver` ruft `CacheEngineBuilder::build(config_xml)` |
| 2→3 | CacheEngineBuilder → CacheEngine | verwendet als Werkzeug | `CacheEngineBuilder` instantiiert `CacheEngine cache_engine_;` |
| 3↔4 | **CacheEngine ↔ Pruefling (bidirektional)** | (a) CE bindet Pruefling ein + (b) Pruefling nutzt CE | siehe §3 |

---

## §3 Bidirektionale CE↔Pruefling-Beziehung (KERN)

### §3.1 Richtung (a): CE → Pruefling

**Was:** CacheEngine instantiiert PRT-ART als ExecutionEngine pro Permutations-Config.

**Wann:** Phase 5 (BIND) im CacheEngineBuilder-Pipeline.

**Wie:**
```cpp
// Im CacheEngine
class CacheEngine {
  std::vector<IExecutingEngine*> registered_engines_;

  void register_engine(IExecutingEngine& engine) {
    registered_engines_.push_back(&engine);
  }

  void execute_permutation(const PermutationDescriptor& desc) {
    auto engine = select_engine(desc.engine_kind);  // z.B. PrtArt
    engine->configure(desc.algo_baustein_set);
    engine->execute(desc.workload);
  }
};
```

**Pruefling-Erwartung:** Pruefling exponiert `IExecutingEngine`-Interface (notify_*, execute, configure).

### §3.2 Richtung (b): Pruefling → CE

**Was:** Pruefling ruft CacheEngine-Services waehrend eigener Lookups.

**Wann:** zur Laufzeit, in jeder lookup()/insert()/scan()-Operation.

**Wie:**
```cpp
// In comdare::prt_art
template <Key, Value, ...>
class prt_art : public ISearchEngine<Key, Value> {
  CacheEngine* cache_engine_;  // injiziert beim Constructor / register_engine()

  optional<Value> lookup(const Key& key) const {
    // (b) Pruefling nutzt CE-Services
    auto& telemetry = cache_engine_->get_telemetry_strategy();
    telemetry.notify_lookup_start(key);

    auto& prefetcher = cache_engine_->get_prefetch_strategy();
    prefetcher.prefetch(predicted_address);

    auto& heuristic = cache_engine_->get_heuristic_for(HeuristicKind::HotPath);
    auto layout_hint = heuristic.recommend(LiveModel{});

    // ... eigener Algorithmus-Lookup ...

    telemetry.notify_lookup_complete(result);
    return result;
  }
};
```

**CacheEngine-Erwartung:** CacheEngine bietet stabile Service-API (Telemetry/Prefetch/Heuristik/...) — siehe `04_konzepte_saeule_b.md`.

### §3.3 Symmetrie-Pflicht

Beide Richtungen MUESSEN im UML (`05_uml_klassen.md`), im drawio (P.2 Tab "Bidirektionale CE↔Pruefling Beziehung") und im Code (`prt_art_search_engine_adapter.hpp` mit Composition CacheEngine&) explizit sein.

---

## §4 Abgrenzung CacheEngineBuilder vs CacheEngine

| Eigenschaft | CacheEngineBuilder | CacheEngine |
|---|---|---|
| **Typ** | Executable (`main()`) | Library (.lib/.so) |
| **Eigenstaendigkeit** | Autonomes Subsystem, eigenes Programm | Wird von CEB UND von Pruefling konsumiert |
| **Hauptaufgabe** | Plattform AUSMESSEN (Phasen 1-7) | Cache-Optimierungs-Services BEREITSTELLEN |
| **Zustand** | Pipeline-Zustand (Phase 1 done? Phase 2 in progress?) | langlebige Service-Instanzen + ObserverRegistry |
| **Lifecycle** | Per Messreihe gestartet + beendet | Singleton zur Laufzeit, lange lebend |
| **Eigentumsverhaeltnis** | `cache-engine/apps/cache_engine_builder/main.cpp` | `cache-engine/libs/cache_engine/cache_engine.hpp` |
| **Aussen-API** | CLI + XML-Config-Input | C++23 Concept-API (ICacheEngine + 12 Sub-Engines) |
| **Wer triggert es?** | `messung_driver` (Diplomarbeit/Code/) ODER User direkt | CacheEngineBuilder + Pruefling |
| **Phasen 1-7 Bezug** | OWNED — CEB ist der Phasen-Treiber | KONSUMIERT — CE liefert nur Sub-Services pro Phase |

**Wichtig:** CEB UND CE liegen im selben Repo (`cache-engine/`), sind aber 2 unabhaengige Subsysteme. CEB ist ein App-Konsument der CE-Bibliothek.

---

## §5 Phasen 1-7 Zuordnung (K11 Pipeline klargestellt)

K11-Tab zeigt 7 Phasen monolithisch. M-Klarstellung:

| Phase | Owner | CE-Services konsumiert |
|---|---|---|
| 1 DISCOVER | **CEB** | `IPlatformProbe` (CE-Service) |
| 2 MEASURE | **CEB** | `IPlatformPropertyClassifier`, Mikrobenchmark-Suite |
| 3 CLASSIFY | **CEB** | `IPlatformPropertyClassifier`, `PropertySet` |
| 4 PUBLISH | **CEB** | `ICacheEngineOptionPublisher` (CE-Service) |
| 5 BIND | **CEB + CE** | CEB instantiiert ExecutionEngine (Pruefling) ueber CE-Registry |
| 6 EXECUTE | **Pruefling + CE** | Pruefling laeuft + ruft CE-Services (Telemetry/Prefetch) |
| 7 COMPARE | **CEB** | CEB aggregiert Measurement-Results aus mehreren Phase-6-Laeufen |

**Konsequenz:** Phase 6 (EXECUTE) ist die einzige Phase wo der Pruefling aktiv ist. Phasen 1-5 + 7 sind reines CEB-Territorium.

---

## §6 Multi-Pruefling-Faehigkeit

Die CE kann **mehrere Pruefling-Implementationen** gleichzeitig registriert haben:

```cpp
CacheEngine ce;
ce.register_engine(prt_art_v1);
ce.register_engine(art_baseline);
ce.register_engine(hot_baseline);

CacheEngineBuilder ceb(ce);
ceb.execute_messreihe_a(config_xml);  // Vergleich PRT-ART vs ART vs HOT
```

Dies entspricht **Messreihe A** (PRT-ART vs SOTA). Die anderen Pruefling-Wrapper sind 22 V31-Adapter (12 SOTA + 10 Allokator).

---

## §7 Cross-Refs

- **REV7.7 Master:** `02_aktueller_master_REV7_7.md` §2 Drei-Repo-Layer
- **K01 Drei-Ebenen-Architektur:** Soll-Korrektur via M.4 (#461)
- **REV7-Master drawio:** Soll-Korrektur via M.3 (#460)
- **U10 prt_art-UML:** Soll-Korrektur via M.5 (#462)
- **thesis Kapitel 03 Architektur:** Soll-Erweiterung via M.6 (#463)
- **drawio REV8 4-Box-Schema:** P.1 (#480)
- **drawio REV8 bidirektionale Beziehung:** P.2 (#481)
- **K11 Pipeline CEB-Spalte:** P.5 (#484)

---

## §8 Implementierungs-Konsequenzen fuer V32+ Sprints

| Konsequenz | Was | Wo |
|---|---|---|
| 1 | `cache-engine/apps/cache_engine_builder/main.cpp` muss klar als App separiert sein | cache-engine V23.B (DONE) |
| 2 | `CacheEngine::register_engine(IExecutingEngine&)` muss public + dokumentiert sein | V32 Code-Audit |
| 3 | `prt_art` Constructor muss `CacheEngine&` annehmen | V32 Refactor — heute optional, dann pflicht |
| 4 | Tests fuer **bidirektionale** Beziehung (CE registriert PRT-ART + PRT-ART nutzt CE-Telemetry) | V32 Test-Erweiterung |
| 5 | thesis-Kapitel 03 muss diese Bidirektionalitaet erklaeren | M.6 (#463) |

---

## §9 S↔E-KREUZ-MAP (Nachtrag 2026-07-09 — additiv, autoritativ)

**Bezug:** `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` (Teil B.2), Ledger `§10.1`. Dieses hier definierte **4-Subsystem-Modell M (S1-S4)** ist die grobe Subsystem-/Ownership-Sicht; die **E0-E4-Experiment-Maschinerie** ist die feinere Experiment-Pipeline-Sicht. Beide beschreiben dieselben Subsysteme in derselben physischen Reihenfolge, aber **gegenläufig nummeriert**:

| S (dieses Modell, 1→4 top-down) | E (Experiment-Maschinerie, 4→1 top-down) | Deckung | Verschobene Kante |
|---|---|---|---|
| **S1** messung_driver (Auswertung/OUTER-LOOP, §2) | **E4** XML-Experiment-Definition + Auswertung (`03`–`06`) | deckungsgleich | E4 hat zusätzlich den XML-Eingang (#229) |
| **S2** CacheEngineBuilder (Permutations-Enumeration, §2/§4) | **E3** Permutations-B+-Baum pro Gattung | deckungsgleich | CEB-Enumeration = Baum-Traversal |
| **S3** CacheEngine (Werkzeug-Bibliothek, §2/§4) | **E2** Tier-Binaries compile-time (DLLs) | verschoben | Library (S3) vs. daraus emittierte DLL-Artefakte (E2) |
| **S4** Prüfling PRT-ART (Mess-Objekt, §2/§3) | **E1** RC-Laufzeit (`DynamicVariableNode`) | verschoben | Mess-Objekt (S4) vs. Laufzeit-Mechanismus (E1) |

**Merksätze:** (a) **S-Sicht zählt 1→4** (Treiber→Prüfling, Subsystem-Ownership), **E-Sicht zählt 4→1** (XML→Laufzeit, Experiment-Fluss) — dieselbe physische Reihenfolge, invers nummeriert. (b) Die Ledger-„4 Schichten" (`§13.10 W5`, `:498/:500/:510`) = dieses S1-S4. (c) **Spur-S (S1-S9, Ledger `§3`)** ist ein DRITTER, unabhängiger „S"-Scope (serielle God-Header/ABI-Kette) — NICHT mit S1-S4 verwechseln. (d) `E-A..E-E` (Ledger, jetzt `DD-A..DD-E`) und die `§13.9-Gate-E1/E2/E3` sind wieder ANDERE „E"-Achsen — s. Ledger `§10.1 (2)`.

---

**Ende docs/architektur/10_schichten_modell_M.md (Phase M.2 DONE).**

---

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R6 · Anker docs/architektur/10_schichten_modell_M.md:40]** Deprecation-Vermerk (primaer an §0.4, autoritativ; ergaenzend §3.2): die dort beschriebene Laufzeit-Service-Injektion im Hot-Path — lookup()/insert()/scan() rufen virtuelle CE-Services (telemetry.notify_lookup_start / get_prefetch_strategy / get_heuristic_for) — ist durch compile-time-Komposition zu ersetzen: CRTP+Concept, prt-art-Bausteine compile-time auf der ce-C++23-Lib (R1/R11). Virtuelle IExecutingEngine/ISearchEngine und Per-Operation-CE-Service-Injektion sind im Hot-Path unzulaessig; Verweis R6 / feedback_no_runtime_switch. Original bleibt.  \n  *(Bezug: §0.4 "CE wird selbst zur ExecutionEngine (IExecutingEngine+ISearchEngine)" + §3.2 lookup() ruft Telemetry-/Prefetch-/Heuristik-Services zur Laufzeit)*
- **[R5 · Anker docs/architektur/10_schichten_modell_M.md:40]** Vermerk: prt-art ist ein SEPARATER Pruefling (folgt dem ce-Parser-Schema hart, getestet gegen den SOTA der ce-Registry), NICHT die "ExecutionEngine B" gleichwertig neben der CE. Das bidirektionale EE-A/EE-B-Modell (§0.1/§0.4) als ueberholt kennzeichnen; die §2.1-Rahmung "Werkzeug-Bibliothek" ist die R4/R5-konsistente Sicht, waehrend die §0.3-Verwerfung genau dieser Formulierung der ueberholte Irrtum ist. CEB-Rolle nach R4 (Framework, das Parser/Pruefdock/Messsystem haelt). §3.1 (CE registriert PRT-ART) unter denselben Nachzieh-Verweis stellen.  \n  *(Bezug: §0.1/§0.4 "CEB orchestriert beide EEs; EE-B = PRT-ART gleichwertig")*
- **[R11 · Anker docs/architektur/10_schichten_modell_M.md:228]** Vermerk an §6: die Multi-Pruefling-Faehigkeit ist als compile-time PrueflingSlot-Substitution in GENAU EINE Achse + 3-Stufen-Join (Stufe1 CE-Perms / Stufe2 ersetzt / Stufe3 A⋈B, Regel der abstrakt-leeren Achse; pruefling_merge.hpp) nachzuziehen. Das Laufzeit-Muster register_engine(prt_art_v1)/register_engine(art_baseline) als ueberholt kennzeichnen (loescht nichts). Verweis Doc 16 A.4.  \n  *(Bezug: §6 "CE kann mehrere Pruefling-Implementationen gleichzeitig via register_engine() registriert haben")*
- **[R4 · Anker docs/architektur/10_schichten_modell_M.md:208]** Ergaenzungs-Vermerk an §5 (Luecke, kein Widerspruch): die 7 Phasen gegen die E1-E4-Maschinerie (Doc 16 A.3: XML→B+-Baum→DLL→RC) und die R4-CEB-Rolle als zentrales XML-config-getriebenes C++-Experiment-Framework kreuz-mappen (analog §9). BIND/EXECUTE/MEASURE/COMPARE decken sich mit "haelt Pruefdock+Messsystem"; nur die Auto-Discovery-Phasen DISCOVER/CLASSIFY/PUBLISH sind kanonisch nicht mehr vorgesehen. Original stehen lassen.  \n  *(Bezug: §5 "Phasen 1-7 DISCOVER/MEASURE/CLASSIFY/PUBLISH/BIND/EXECUTE/COMPARE"; CEB als PIKA-Ausmess-System)*
- **[R7 · Anker docs/architektur/10_schichten_modell_M.md:269]** Keine Aenderung noetig: §9 loest den frueher vermuteten S1-S4-vs-E4-E1-Konflikt (inverse Nummerierung, Namenskollision) explizit auf und disambiguiert zusaetzlich Spur-S / DD-A..DD-E / §13.9-Gate-E — additiv, autoritativ, Baseline-/WAS-WIE-Layering-konsistent (R7). §9 als kanonische Disambiguierungs-Stelle referenzierbar halten. Rest-Reibung (kein Anforderungs-Konflikt): §9 Z.277 nennt S3 weiterhin "Werkzeug-Bibliothek" (bewusst §2/§4-Ownership-Sicht), koennte mit dem AA.2-Command-Pattern-Modell abgeglichen werden.  \n  *(Bezug: §9 S↔E-Kreuz-Map, "S-Sicht zaehlt 1→4 ... E-Sicht zaehlt 4→1")*
