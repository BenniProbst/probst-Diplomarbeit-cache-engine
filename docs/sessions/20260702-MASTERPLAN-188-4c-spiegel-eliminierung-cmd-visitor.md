# MASTERPLAN #188-4c + CMD-1/CMD-2 — Spiegel-Eliminierung, Command-Basis, Container-Aufschlüsselung (2026-07-02)

> Konsolidiert aus dem Recherche-Paar (Explore+Codex, konvergent; volle Berichte in den Session-Task-Outputs)
> nach dem User-Architektur-Einwand + User-GO („alle Punkte ziehen"). Quellen-Hierarchie: Doc 30 §8.0 > Doc 34 >
> Einzel-Docs; Thesis ch2 fig:three-levels + fig:patterns; HEAD `a1f6024` (alle Zeilen frisch verifiziert —
> die §17-Zeilen des 20260628-Kontext-Dossiers sind veraltet, dieses Dokument ersetzt sie für 4c).

## 0. Beschlossen (User-GO 2026-07-02)
- **#211 VERWORFEN** (Mirror-Optimierung hätte den Spiegel zementiert) → **#188-4c = ELIMINIERUNG** (Task #250).
- **#224-Teil-GO:** Rename `container_` → storage-organ-artiger Name im 4c-Zug (Namens-Kollision Container-GATTUNG).
- **CMD-1 (Task #251):** Command-Pattern-Basis-Interface per Metaprogrammierung, Mess-Bestandteile als Visitor
  („Limitations-Interface") — konsolidiert mit observe-Hooks (DEG-2) + 234-V.
- **CMD-2 (Task #252):** Container-Anteil der SA-Zugriffe je Tier aufschlüsselbar machen.

## 1. Ist-Fundament (verifiziert, HEAD a1f6024)
3-Wege-Split der Weiche `abi_adapter.hpp:1931-1970`: (1) store-traversierbare Methoden (LinearScan/Interpolation/
k-ary/per-K) = authoritativ · (2) 10 organ-backed (9 Pools + Eytzinger) = authoritativ · (3) markerlose
Flach-Wrapper (Array256/VectorU8U8/VectorU16U16/Array65535, flags default OFF) + **11 Reference-/PaperBinding-
Compositions** (`search_algo` = Observable*Organ, z.B. art_reference.hpp:65) = `search_organ_` + container_-Spiegel.
Golden-320 = ausschließlich Gruppen 1+2 → **zahlen den Spiegel nicht**. Der search_organ_-Pfad ist in den 320
totes Gewicht; er lebt nur in den 11 Referenz-Tier-Binaries + (deaktivierten) Flach-Wrappern.
SOLL (code-dokumentiert): `store_traversable_search_algo.hpp:16-22` — „Aufteilung ist ein BUG … EIN Speicher …
search_organ_ ENTFÄLLT … KEINE dauerhafte ehrliche Limitierung".

## 2. Increment-Plan #188-4c (god-header-Regel: je EIN abi_adapter-Increment, je CI-belegt)

| Inc | Inhalt | Mechanik-Entscheid | Risiko | CI-Beweis |
|---|---|---|---|---|
| **4c-0** | NEUER Known-Compositions-Conformance-Test: alle 11 Referenzen durch `run_conformance_gate` (std::map-Orakel) — Sicherheitsnetz VOR jedem Umbau | bestehendes Gate-Muster (conformance_gate.hpp:32-115) | niedrig | contract:conformance erweitert |
| **4c-i** | Die 11 Referenzen authoritativ: **dritter Weichen-Branch `container_t = SearchAlgo` DIREKT** (die Hülle IST das Organ; kein organ_for-Doppel-Wrap, kein Flat-Marker). search_organ_ wird für sie ungenutzt; Speicher-Achsen T4/T5/T6 gehen honest-0 (Konvention wie Pools seit 4b-b, real mit observe-Hooks/4b-c) | beide Recherchen konvergent (c-Weg) | mittel (CoW/Memento muss aus container_t folgen; saved_search_-Hälfte entfällt) | 4c-0-Gate + test_v41_axis_03a_tier_organ_equivalence + test_cow_memento |
| **4c-ii** | Flach-Wrapper-Disposition (USER-Entscheid E1 unten) | faithful Traversals (Array256=Direktadress) ODER Compile-time-Ausschluss + Limitations-Auskunft | niedrig (Golden-OFF) | conformance je Wrapper bzw. Ausschluss-static_assert |
| **4c-iii** | search_organ_ + alle else-Zweige ENTFERNEN — 14 verifizierte Stellen: Member :1976, insert :753-760, lookup :837-845, erase :888-895, clear :904, reset :932, T0-Observer-else :1010-1015, Ernte-Zweige 3+4 :1317/:1321, do_batch-else :1341-1347, routes_through_store :1772-1778 (wird konstant true), Memento :1656-1678, Rollback :1681-1734, CoW :2105-2109, saved_search_-Member :2042/:2046 | erst nach i+ii grün; NIE halb committen | mittel (ABI-berührend) | Voll-Compile + contract:conformance + test_m8_storetrav_segment + test_pathb_segment_timer |
| **4c-iv** | Rename-Sweep container_→neuer Name + flat_container_t/container_is_*-Namen (container_is_authoritative_ verschwindet, konstant true) | ⚠️ Zielname: `storage_organ_` kollidiert mit StorageOrgan-CONCEPT (semantisch stimmig — bewusst entscheiden); ⚠️ anatomy_execution_context.hpp:115-120 hat EIGENES search_organ_/container_-Paar (Builder-Pilot) — NICHT blind mit-umbenennen | niedrig | Voll-Compile + test_d14b_perm_runner |

**#216-H2 fällt NUR teilweise:** die search_organ_-Beschattung (le_limitierung Z.10) fällt mit 4c-iii; der
stat-Reset-Träger bleibt `container_.reset()` (:937) und die Load-Phasen-Akkumulation (Z.8) ist orthogonal → 
#216-H2 bleibt als Mini-Increment (verkleinert). Danach #215 (EIN 320-Neubau) als Wirksamkeits-Schleuse.

## 3. CMD-1 — Befund + Formalisierungs-Lücke
Echte GoF-Commands existieren, aber verstreut + nicht im Mess-Pfad: `ICommand`+Subklassen (builder/commands,
runtime/vtable, Test-Treiber), `Anatomy*Command` (Header-Kommentar :7-13: Produktions-Pfad umgeht sie),
`IStrategyCommand`-Insel (include/cache_engine/strategy_command — vestigial, nur 1 Test). WorkloadOp = 
Command-als-Daten + Interpreter-switch (workload_orchestrator:76-150). **Kein GoF-Visitor** (algorithm_visitor/ =
leerer Platzhalter mit explizitem Audit-Kommentar; „hybrider Visitor" = real Memento; le_limitierung Z.15).
Die compile-time-Hierarchie ist real (CRTP axis_base + zweischichtige Concepts + mp_list/mp_filter/mp_for_each +
traversal_for/organ_for-Trait-Dispatch), heute als **Strategy+CRTP** benannt (Thesis fig:patterns ch2:454-471).
**CMD-1-Ziel = die Lücke schließen:** EIN Basis-Interface, das Antriebs-Op (Command) + Mess-Slot (Visitor,
COMDARE_MEASUREMENT_ON-gated) + Limitations-Auskunft vereint; Andock: axis_base-CRTP + Topic-Concepts +
MeasurableComponent; konsolidiert die 4 Limitations-Bausteine (conformance_gate · IResourceControllableTier-caps ·
enabled/is_original-Statics · le_limitierung-Generator [liegt in Code/04_csv_to_latex — Cross-Repo-Schritt]).
Disposition IStrategyCommand-Insel: durch das neue Basis-Interface ERSETZEN (Entfernung mit Tests), analog
algorithm_visitor-Platzhalter. **Text-Folge:** Thesis-Musterliste (fig:patterns) + le_limitierung Z.15 +
Code-Anti-Etiketten-Kommentare werden nach CMD-1-Landung konsistent nachgezogen (dann ist Command/Visitor
STRUKTUR, nicht Etikett — Text-Agent-Handoff).

## 4. CMD-2 — Kategorien-Konflikt (USER-Entscheid E2 unten)
`ContainerObserver` ist code- UND thesis-fest reserviert für die **separate schlüssellose Container-GATTUNG**
(Adapter-Tier; axis_observer_classification.hpp:13-14,:29; Kategorienfehler-Korrektur 2026-06-03: q1/q2 sind
BEWUSST keine Container). Der SA-Store-Anteil wird heute schon über T4/T5/T6 (+T11/T13) in axis_stats gemessen.
Die Klassifikations-Tabelle ist reine Taxonomie (kein Daten-Routing). Optionen:
(a) **NEUE Attribution „SA-Storage-Anteil"** (neue Kategorie/POD-Spalten additiv; T4/T5/T6/T11/T13 als
Container-artige Organe etikettieren und als Summen-Anteil je Tier ausweisen) — ContainerObserver bleibt der
Gattung vorbehalten. (b) ContainerObserver umdefinieren (kehrt die 2026-06-03-Korrektur teilweise um; Doc 30
§8.0 + Thesis-Anpassung nötig). Schema-Transport in BEIDEN Fällen: **mit AP-1 (#235) bündeln** (ein
versionierter POD-Bruch statt zwei) — axis_stats[19][8] wird NICHT still umgedeutet.

## 5. USER-Entscheide (Stand 2026-07-02, zweite Runde) + gesetzte Integrator-Entscheide
- **E1 (4c-ii) ✅ ENTSCHIEDEN: faithful Organe bauen** — die Flach-Wrapper (Array256=Direktadress-Traversal,
  Vector*/Array65535) bekommen treue Traversal-Organe (KEIN Compile-time-Ausschluss).
- **E2 (CMD-2) ✅ ENTSCHIEDEN: Sidecar + statischer Visitor-Pfad** — für die ORGAN-Achsen ein **Sidecar**
  (Container-/Storage-Anteil-Aufschlüsselung NICHT in den AP-1-POD integriert; axis_stats bleibt unangetastet);
  für die STATISCHEN Mess-Achsen **kein Mess-POD**, sondern ein **statischer (compile-time) Visitor-Pfad** zur
  Übertragung der Observer + Auswertungen. ContainerObserver-Gattungs-Reservierung bleibt unberührt (Variante a).
- **F1-RICHTUNG ✅ (User-Architektur-Vorgabe):** Organ-Achsen-Strukturen haben **`IExecutionEngine` als Basis**;
  Mess-Achsen haben eine **separate Mess-Basis** — „das ist schon der Ansatz dieses Systems"; CMD-1 räumt das
  **Chaos der Parallelitäten** auf (ICommand/builder-commands · IStrategyCommand-Insel · Anatomy*Command ·
  algorithm_visitor-Platzhalter → konsolidieren/ersetzen unter der Zwei-Wurzel-Struktur).
- **E3 (4c-iv) OFFEN:** Rename-Zielname für container_: `storage_organ_` (Namensnähe zum StorageOrgan-Concept —
  nach 4c trägt der Member aber AUCH native Such-Organe/Referenz-Hüllen, nicht nur Stores) vs. Alternative
  (`tier_substrate_` / `substrate_organ_` — Empfehlung: **tier_substrate_**, da es das authoritative
  Tier-Substrat jeder Familie bezeichnet, nicht nur Storage).
- Gesetzt (Integrator, konventionsgedeckt): 4c-0-Gate zuerst · 4c-i-Mechanik = dritter Weg · honest-0 der
  Referenz-Speicherachsen bis observe-Hooks · IStrategyCommand-Insel wird durch CMD-1 ersetzt ·
  Command/Visitor wird durch CMD-1 zur STRUKTUR (Text/fig:patterns/le_limitierung Z.15 ziehen danach nach).

## 6. Reihenfolge
4c-0 → 4c-i → (E1)→4c-ii → 4c-iii → (E3)→4c-iv → #216-H2-Rest → #215-Schleuse. CMD-1-Design parallel ab 4c-iii
(konsolidiert observe-Hooks + 234-V); CMD-2 nach E2 mit AP-1. W4.5 (AP-Welle) + W5/W6 unverändert dahinter.
