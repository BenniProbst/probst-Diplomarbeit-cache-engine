# STRANG A — Dokumentiertes Systemachsen-Konzept (SOLL) — vollständige Kartierung

> **Rohdaten-Datei für das 20-Seiten-Dossier (F4-Auftrag 2026-07-16).** Read-only-Recherche; jede Aussage
> `datei:zeile`-belegt. Wurzeln: **super** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`,
> **ce** = `super/Code/external/comdare-cache-engine`, **LEDGER** = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`,
> **MEM** = `~/.claude/projects/-home-comdare/memory/`. Erstellt 2026-07-16. TABU/golden unberührt (reine Lektüre).

---

## 0. Der bindende USER-KONZEPT-Anker (wörtlich, 2026-07-16)

Die autoritative, wörtliche Verankerung des User-Konzepts steht in **LEDGER:368** (§12-Eintrag
„2026-07-16 (USER-KONZEPT-KLÄRUNG F3i/F4/F5 — AUTORITATIV, wörtlich; korrigiert die ‚Duplikat'-These
GRUNDLEGEND; 20-Seiten-Dossier beauftragt)"). Kernsätze dort (User wörtlich):

- „Per Plan liegen die Systemachsen in der CacheEngineBuilder (und werden dort hineinkompiliert); die
  anderen Achsen werden VON der CacheEngineBuilder EINKOMPILIERT IN die Tier-Binaries."
- „**Systemachsen und Algorithmus-Gattungs-Achsen sind getrennte Konzepte, auch wenn beide
  compile-time-Hauptachsen und dynamische runtime-Unter-Achsen haben.**"
- F4: „Scheduling/Hardware/NUMA/Locking sind **PFLICHT-SYSTEMACHSEN** (‚sollten als System-Achsen NEBEN den
  Mess-System-Achsen liegen; sind TODO') — KEINE Duplikate … Das Konzept ist Pflicht und kaputt — Reparatur
  durch gründliche Recherche."
- F3i(1): **Compiler-Systemachse** — „in der XML muss es möglich sein, sowohl den CacheEngineBuilder als auch
  JEDE einzelne Tier-Binary-Permutation entweder mit gcc oder mit clang zu bauen (eigene Achse zur compile
  time bei runtime der CacheEngineBuilder und NEUE SYSTEMACHSE)" (LEDGER:368).
- F3i(2): **Voll-Vergleich** — „Vergleich einer Tier-Binary unter Last gegen ALLE anderen Tier-Binaries — …
  welche Achsen-Permutationen unter welchen Datenlasten mit welchen Compilern auf welchen ISA+OS am besten
  laufen" (LEDGER:368).
- F3i(3): „alt gegen neu" = „den bestehenden Stand der Technik gegen einen Prüfling neuer Techniken für
  bestimmte Achsen (wie PRT-ART) zu prüfen … für alle genannten Ketten"; die „4. Kategorie" ist EIGENE
  Kategorie mit Unterkategorien, **JE STUFE auszuführen** (für die 3 gemessenen Stufen — **KEINE 4. Stufe**)
  (LEDGER:368).
- „Der Experiment-B+-Baum ist ein Resultat der PLANUNG des Gesamtsystems, hat aber einen **Filter für die
  Stufe der CacheEngineBuilder** und der durch ihn zu bauenden und am Prüfdock zu messenden Tier-Binaries —
  **der Experiment-Planer mit XML-Interpreter ist eine NEUE DRITTE ANWENDUNG im Framework der CacheEngine**"
  (LEDGER:368).
- „Messung der Systemachsen ‚nach einer Strategie'" (LEDGER:368).

Alles Folgende kartiert, WO dieses Konzept in der bestehenden Doku/dem Code bereits dokumentiert, teilweise
gebaut, oder noch gar nicht verankert ist.

---

## 1. DEFINITION: Zwei distinkte Achsen-Systeme (Organ vs. System = „Blut")

### 1.1 Die bindende Grundunterscheidung (User 09.07., Dossier 18 A.1)

**super `docs/architektur/18_MESS_METHODIK_ACHSEN_OPTIMIERUNG_KONSOLIDIERT.md:15-30`** — „Die ZWEI distinkten
Achsen-Systeme (zentrale Klärung, User 09.07.)", Gegenüberstellungs-Tabelle (Zeilen 19-28):

| Merkmal | Organ-Achsen (Tier-Binary) | System-Achsen (Mess-System) |
|---|---|---|
| Rolle | das Gemessene/Optimierte | die **Mess-Instrumente** |
| Metapher | Organe (Tier) | **Blut** (durchdringend, nicht ein Organ) |
| Anzahl | ~19 (T0–T18) | die Mess-Kategorien (CLU, Cache-Miss L1/L2/L3, dTLB, Branch, IPC/CPI, Latenz, Durchsatz, Energie, Speicher-Fußabdruck) — 18:23 |
| Zugehörigkeit | Teil der Gattungen/Lebewesen | **NICHT Gattungen** |
| Austauschbarkeit | permutierbar (Composition) | **nicht austauschbar**, zentrale Systembestandteile |
| Präsenz | je Tier-Binary variabel | **IMMER präsent, sobald Messung an** |
| Wurzel | `AdHocComposition<T0..T18>` | **eigene abstrakte Klassen-Wurzel** (SOLL: `SystemAxis`/`IMeasurementSource`) — 18:27 |
| E-Ebene | E2/E3 (Permutationsbaum) | **E0-Querschnitt** (nicht im Baum) — 18:28 |

Ist-Befund dazu (18:30): vor dem M-Increment lag das System-Achsen-System nur **fragmentiert** vor
(`MeasurementCategory`-Enum + `IPmcSource` + `ComdareMeasurementSnapshotV1`-POD + `ObserverAggregate<19>`)
— „ohne gemeinsame abstrakte Wurzel"; genau die zu schaffen war der SOLL-Zustand.

### 1.2 Die Memory-Direktive (Formalisierung)

**MEM `feedback_system_axes_measurement_own_abstract_root_blood.md`** (Direktive User 09.07., bindend):
- Punkt 2: System-Achsen haben „**EIGENE abstrakte Klassen-Wurzel**, existieren unabhängig von den
  Tier-Achsen und sind **IMMER präsent, sobald Messung eingeschaltet ist** … NICHT zu den Gattungen …
  = ‚Blut'" (Datei, Abschnitt 2).
- Konsequenzen-Block: „Die Organ-Achsen (Tier) werden VON den System-Achsen gemessen; ihre Wirkungsweise
  = Observer-Strategy …, aber die Observer-INFRASTRUKTUR selbst = System-Achsen (Blut)"; „System-Achsen
  sind ein Querschnitt (E0-nah/Mess), nicht Teil des E2/E3-Permutationsbaums".

### 1.3 Kern-Direktiven-Status im Goal

- **LEDGER:100** (§0-GOAL V5.7 Kern-Direktiven): „System-Achsen=„Blut" (eigene abstrakte Wurzel)" als
  in Stein gemeißelte Kern-Direktive; ebenso im §1-GOAL-Wortlaut **LEDGER:118** („System-Achsen=„Blut"").
- **LEDGER:92** (§0-GOAL V5, Punkt (e)): „CEB-Ziel = 4 Modi: Mess→Auswertung … →Arbeitsmodus … →**Hybrid**
  (Heuristik-Optimierungs-Achse als **eigene Systemachse**) = ZIEL der Diplomarbeit."

### 1.4 TABU-Grenze der Systemachsen

**super `docs/architektur/18_…KONSOLIDIERT.md:104`** (Teil E): „**System-Achsen sind E0-Querschnitt, dürfen
NICHT die binary_id/E3-Permutation berühren.**" Ebenso Dossier 19: „System-Achsen (M) berühren NIE die
binary_id/E3-Permutation" (**super `docs/architektur/19_…VERTRAEGE.md:23`**).

---

## 2. DIE WURZEL IM CODE (IST, gebaut 2026-07-10, Querschnitt M)

### 2.1 `SystemAxis`-Wurzel (CRTP, zero-cost)

**ce `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp`** (338 Z., Header-Kommentar
Z.1-5: „Querschnitt M — SystemAxis-Wurzel fuer host-seitige Messachsen … Keine ABI-Erweiterung … dockt nur
lesend an die bestehenden Host-PODs (ComdareTierObserverSnapshot, PmcCounters) an"):
- `MeasurementRegime`-Zweiteilung `{TimeObserver, PmcCounter}` (Z.20-23).
- `kAllMeasurementCategories` = **16 Kategorien** (Z.25-34); Partition `kPmcCounterCategories` (7, Z.37-41)
  vs. `kTimeObserverCategories` (9, Z.43-53).
- `regime_of(...)` single-source mit Thesis-Zitaten als Quelle der Zweiteilung: „Thesis
  03_messsystem_prtart.tex:382-386" + „06_evaluation_methodology.tex:119-126" (Z.55-80).
- consteval-Vollständigkeits-Gate `regime_mapping_is_complete()` + `static_assert(...==16)` (Z.100-132);
  consteval-**Regime-Misch-Verbot** je Achse: „SystemAxis darf keine MeasurementRegimes mischen" (Z.117-126).
- POD `SystemAxisSample{category,value,valid}` (Z.134-141).
- **Blut-Direktive im Code verankert** (Z.143-145): „System-Achsen sind bei eingeschalteter Messung immer
  host-seitig praesent (Blut-Direktive), unabhaengig von Tier-Permutation und E2/E3-Baum. Sie sind keine
  Organ-Taxonomie und kein austauschbarer Achsen-Slot." + `system_axes_always_present()` (Z.145).
- CRTP-Basis `template<class Derived> struct SystemAxis` (Z.147-180; empty-base, kein vtable) +
  `SystemAxisConcept` (Z.182-190: `derived_from` + `is_empty` + `!is_polymorphic` — Concept-Guard-Mix).
- **3 konkrete Systemachsen-Strategien** (nur lesend auf Host-PODs):
  `WallClockSystemAxis` (Z.192-236; LATENCY_MEAN+THROUGHPUT; **honest-0 für Perzentile** Z.224-231:
  „total_ns/op_count ist ein MITTELWERT — ihn als Perzentil zu etikettieren waere ein Phantomwert"),
  `ObserverSnapshotSystemAxis` (Z.238; auf `ComdareTierObserverSnapshot`; CLU als echte Ratio),
  `PmcSystemAxis` (Z.283; auf `PmcCounters`).
- Commit-/Verifikations-Beleg: **LEDGER:655** („QUERSCHNITT M vollzogen — SystemAxis-Wurzel ‚Blut'",
  ce `2a231cf5`, MeasurementRegime-Zweiteilung „wörtlich Thesis 03:382-386 + 06:119-126", 3 Strategies
  „NUR lesend auf den Host-PODs — kein ABI-Touch"; honest-0-Liste: Latenz-Perzentile, IPC_CPI,
  MEMORY_FOOTPRINT, FILL_BUFFER; CLU = field_bytes/(cache_lines·64) mit kV3AxisSchema-static_assert).

### 2.2 `IMeasurementSource` (vendor-neutrale Mess-Quellen-Abstraktion)

**ce `libs/cache_engine/include/cache_engine/measurement/i_measurement_source.hpp`** (186 Z.):
- Header Z.1-6: „Phase-6-Vorbau (2026-07-10) … nach der Design-Quelle
  `docs/sessions/20260531-mess-abstraktion-cross-platform-architektur-plan.md §2.2`. **Bewusst HOST-seitig
  (nicht ueber die DLL-Grenze)**: PMC-Zugriff braucht OS-Privilegien … Runner-/Pruef-Dock-Verdrahtung =
  Folge-Increment (E1-Verweis)."
- `MeasuredEvent` = 10 vendor-neutrale Ereignis-Semantiken (Z.24-36), `SourceStatus` errno-style (Z.39-46),
  `MeasurementSourceCaps` (Z.51-57, inkl. `needs_admin`=ZIH-Gate, `hybrid_core_aware`=P/E-Core),
  `MeasuredDelta` mit per-Event-`valid` (honest-Doktrin, Z.59-69).
- Interface `IMeasurementSource` (Z.72), Implementierungen `WallClockSource` (Z.100, echter Cycles-Proxy)
  und `PmcSourceAdapter` (Z.136, GoF-Adapter auf Bestands-`IPmcSource`).
- Bau-Beleg: **LEDGER:665** (Phase-6-Vorbau ce `c022ce05`; Review wf_c99a2132; „EXPLIZIT Folge/gated:
  Runner-/Dock-Verdrahtung (E1), `<measurement_categories>`-XML (#156), PMC-Vollpfad (#215)").

### 2.3 `measurement_axis_registry` (die „Blut"-Registry)

**ce `libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.hpp`** (77 Z.):
- Z.2-5: „compile-time Mess-Achsen-Registry ueber die 16 MeasurementCategory-**System-Achsen ("Blut",
  Dossier 19 Querschnitt M)**. KEIN Runtime-Switch … Regime SINGLE-SOURCE aus regime_of …
  **Konsumenten (E4-Reporting, Pruef-Dock-Verdrahtung) = Folge-Increment.**"
- `kMeasurementAxisRegistry` (16 Einträge, Index==Kategorie, Z.32-49) + consteval-Gate (Z.52-62) +
  `axis_info()` (Z.65-67) + **`for_each_measurement_axis`** = „Compile-time-Iteration ueber alle
  Mess-Achsen (Metaprogrammierungs-Interface fuer E4-Reporting)" (Z.69-75).
- `kMeasurementAxisCount = kMeasurementCategoryCount` — Enum-Drift bricht compile-time (Z.22-23).

### 2.4 Contract-Test der Wurzel

**ce `tests/unit/test_m_contract_system_axis_wurzel.cpp`** — M-Contract-Harness (M ist OHNE Tier-Binaries
testbar, gefordert in Dossier 19 Teil B, super `docs/architektur/19_…:32`); honest-0 zementiert bei
~Z.134-142: „bytes_in_use ist nicht der Thesis-Kanon bytes_in_use_peak; peak_size ist Software-Queue,
kein Hardware-Line-Fill-Buffer — beide Kategorien bleiben invalid statt falsch etikettiert." Referenziert
als Beleg in **LEDGER:308** („`test_m_contract_system_axis_wurzel.cpp:137-138` zementiert es").

### 2.5 Konsumenten-Status (wichtig für „kaputt"-Diagnose)

- **LEDGER:150** (Muster C „Null-Consumer-Trap"): „SystemAxis-Wurzel ‚Blut'/`curve_fit`/CoR =
  **#156-DATA-gated→G6**" — bewusste Vorleistung, kein Dead-Code.
- **LEDGER:402** (Task-#16-Korrektur): `measurement_axis_registry`/`i_measurement_source` (SystemAxis
  „Blut")/`curve_fit`/`selection_filter_chain` sind „bewusster **#156-DATA-gated E4′-Vorbau** …
  (verdrahten NACH #9916, NICHT abreißen)".
- **MEM `reference_tier_metaphor_system_axis_properties_verified_complete.md`**: „die Registry + alle
  4 SystemAxis-Typen haben 0 Produktions-Konsumenten (nur Unit-Tests)"; buildbares Wiring-Increment H-1 =
  „SystemAxis→E4-Reporting-Verdrahtung … Andockpunkt `node_value_measurement.hpp:56`" — aber per
  Deep-Research wf_59138062 als `correctly-gated-do-not-build` aufgelöst (**LEDGER:296-303**: LATENCY_MEAN+
  THROUGHPUT wären redundant zur golden-CSV; CLU-Einbau bräche das 16-Spalten-CSV-Schema + ABI-POD (TABU);
  sauberer Weg = geplanter E1/M2-Single-Source-Replace, design-gated).
- **Einziger XML-Eingang heute:** `<measurement_categories>`-Element (INC-3, **LEDGER:388**): „reine
  SPALTEN-PROJEKTION über die 16 gemessenen System-Kategorien (`MeasurementCategory`) — eine SICHT-Auswahl,
  KEINE Binary-/Kompositions-Achse → binary_id-neutral"; Validierung „gegen `kMeasurementAxisRegistry`
  (`measurement_axis_registry.hpp`)".

---

## 3. ABGRENZUNG zu Organ-/Gattungs-Achsen (die „getrennten Konzepte")

### 3.1 Das 3-Ebenen-Modell (autoritativ)

**ce `docs/architecture/34_KONSOLIDIERTER_MASTER_IST_STAND.md:15-34`** (§1, Doc 30 §8.0 autoritativ):
1. **GATTUNG = Außen-INTERFACE = Prüf-Dock** (3: SearchAlgorithm/Container/Graph; Code `AnatomyGattung`).
2. **TIER-/Lebewesen-UNTERKLASSE** = fester Achsen-Satz (5: SearchAlgorithm/Set/Sequence/Adapter/View;
   Code `AnatomyGenus`); Invariante: feste Slot-Zahl = ABI-Identität (`AdHocComposition<19>`).
3. **ACHSEN = Organe**; KEINE Achse optional (Durchreich-Algorithmen statt Weglassen).

**super `docs/architektur/14_achsen_komposition_organ_metapher.md`** liefert die Ursprünge:
- §26 (14:1018-1088): std::-Container-„Gattungen A–F" — per Schärfungs-Banner 14:1020-1028 sind das
  **Lebewesen-UNTERKLASSEN**, „Gattung im korrekten Sinn = das Außen-Interface Search/Container/Graph
  (Prüf-Dock)".
- §27 (14:1091-1161): `AnatomyBase`-Wurzel aller **Lebewesen** — Two-Phase (Concept compile-time +
  `IAnatomyBase` runtime/ABI, 14:1107-1150); Lebewesen-Metapher-Tabelle (14:1152-1161).
- §28 (14:1164-1208): Achsen-Verteilung pro Lebewesen-Unterklasse; Schärfung 14:1166-1178: KEINE Achse
  optional, „—" = konkreter Durchreich-Algorithmus.
- **WICHTIG:** §26-28 handelt ausschließlich von **Organ-/Gattungs-Achsen und Lebewesen** — Systemachsen
  („Blut") kommen in Doc 14 NICHT vor (einziger „Blut"-Treffer 14:494 = „Blutkreislauf (allocator)" in der
  Säugetier-Anatomie-Tabelle, also ein ORGAN-Bild, das später vom System-Achsen-„Blut" der Mess-Ebene
  begrifflich ABGELÖST wurde — die Metaphern sind zu unterscheiden!).

### 3.2 Beide Systeme haben Haupt- und Unter-Achsen (dokumentierter Präzedenzfall)

**super `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md`** (bindender Bauplan,
ersetzt Doc-20-§I; 21:9-10) — das **Layer-/Haupt-Unter-Achsen-Modell** (User-Klärung 10.07., 21:14-36):
- 21:16-20: Experiment-Baum = B+-Baum, LAYER-sortiert; statische (compile-time) Achse = strikter Layer,
  darunter dynamische Achsen-Nodes; pro Node-SPREAD genau EINE Sorte (statisch XOR dynamisch).
- 21:29-31: „**EIN Concept für alle Achsen — Haupt-Achse + Unter-Achse:** eine Unter-Achse ist eine
  VOLL-Achse, die unter der compile-time-Haupt-Achse ausgeführt wird. Der frühere ‚Laufzeit-Skalar'
  (RC-POD-Feld) ist in Wahrheit eine **Unter-Achse**."
- 21:21-23 + 21:32: „**Wurzel = die System-Achsen == Meta-Achsen** (inkl. telemetry + Mess-System). Sie
  reichen per **Visitor-Pattern** die Workloads durch …; in den Visitoren sind **Strategy-Pattern**
  eingebaut" / „Meta-Achsen == System-Achsen, strategisch-hierarchisch korrekt an der Wurzel aufzubauen."
- H7 (21:50): „telemetry ist **Meta==System-Achse an der WURZEL** (nicht Organ-Slot)".
- 21:137-138: „hw_prefetcher bleibt **System-/Wurzel-Unter-Achse**" — dokumentierter Fall einer
  **dynamischen UNTER-Achse einer Systemachse** (exakt die Struktur, die das User-Konzept 07-16 für
  BEIDE Konzepte fordert: compile-time-Hauptachsen + dynamische runtime-Unter-Achsen).
- 21:235-241: Typsystem-Bau = „Haupt-/Unter-Achsen als Layer, **Wurzel=System-Achsen mit
  Visitor+Strategy**, Prozess-Dimension als Builder-über-State, Decorator-über-Visitor-State-Log".
- Organ-Seite der Haupt/Unter-Struktur: 5 dynamische Achsen (RC-POD-Felder) unter 19 compile-time-Slots,
  autoritative Single-Source `builder/experiment_tree/profile_to_tree.hpp:68-87` (`is_static`-Flag; belegt
  in **super `docs/architektur/20_…:126-133`** §I).

### 3.3 Trennungs-Disziplin (nie vermischen)

- **MEM `feedback_system_axes_measurement_own_abstract_root_blood.md`**: „Organ-Achsen-Effekte (Min/Max)
  NICHT mit System-Achsen (Mess-Instrumenten) vermischen."
- **super `docs/architektur/19_…:23`**: „Organ-Achsen-Effekte nie mit Mess-Instrumenten vermischen."
- **LEDGER:289-292** (§11-H): „die System-Achsen (‚Blut'). Verdikt: die Eigenschaften/Verträge sind
  vollständig deklariert — KEINE unbenannten Pflicht-Properties; **Organ/System-Trennung
  eigenschaftskonform**."
- MEM `feedback_command_pattern_achsen_mess_visitor_container_in_sa` + MEM-Index: Command-Achsen +
  Mess-Visitor getrennt gehalten (CMD-1-b: `MeasurementVisitable` constrained `axis_accept_measurement`
  OHNE AxisCommand-Konjunkt, **LEDGER:655** (b)).

---

## 4. WO „Systemachsen IN der CEB / hineinkompiliert" dokumentiert ist

1. **User wörtlich (einzige explizite Formulierung):** LEDGER:368 (siehe §0) — „Per Plan liegen die
   Systemachsen in der CacheEngineBuilder (und werden dort hineinkompiliert); die anderen Achsen werden
   VON der CacheEngineBuilder EINKOMPILIERT IN die Tier-Binaries."
2. **CEB hält das Messsystem (Architektur-Konsolidat):**
   - **LEDGER:89** (§0-GOAL V5.4(b)): „CacheEngineBuilder (CEB) = EINE zentrale C++-App =
     Experiment-Framework: alle XML-Parser darin verankert; baut Tier-Binaries ZUR LAUFZEIT …; hält
     **Prüfdock + Messsystem**."
   - **LEDGER:1178** (§15.1): „alle XML-Parser sind im CEB verankert; er steuert … (parst
     Registries+Experiment-XML → baut Tier-Binaries ZUR LAUFZEIT … → treibt durch das Prüfdock →
     **misst über das Messsystem**)."
   - **super `docs/architektur/19_…:89`** (Nachtrag R4): „Der CEB ist das zentrale Framework — er hält
     alle XML-Parser, das Prüfdock und das Messsystem …" (kanonischer Beleg = Ledger §15.1).
   - **LEDGER:1268** (§15.7-R4): „Der CEB (E2/S2-Ebene) hält alle Parser + Messsystem."
3. **Host-seitigkeit des System-Achsen-Codes (= technisches Korrelat von „in CEB hineinkompiliert"):**
   - ce `system_axis.hpp:1-5`: „host-seitige Messachsen … dockt nur lesend an die bestehenden Host-PODs an"
     (Host = die Builder-/CEB-Seite der ABI-Grenze; die Tier-DLL trägt sie NICHT).
   - ce `i_measurement_source.hpp:4-6`: „Bewusst HOST-seitig (nicht ueber die DLL-Grenze) … die echte
     Erhebung umklammert host-seitig den run_workload-/tier_*-Aufruf am Dock."
4. **Historischer CEB-Auftrag (Mess-Orchestrierung):** super `docs/architektur/14_…:740-753` (§17.3
   „CacheEngineBuilder (Mess-Orchestrierung + ABI-Loader)": Command-Pattern für Workload-Driver,
   Mess-Aggregation Welch-t, 3-Stufen-Auswahl) und ce `docs/architecture/24_…:36-49` (§2.1: „**Wer:**
   CacheEngineBuilder … Wall-Clock als Akkumulation von Detail-Kurven"), ce `docs/architecture/34_…:73-78`
   (§4: „CacheEngineBuilder (autonomes Plattform-Ausmess-System, App)"), 34:46-48 (§2: „CacheEngineBuilder
   = Mess-Orchestrierung + ABI-Loader").
5. **Gattungs-Achsen VON der CEB in die Tier-Binaries einkompiliert:** ce 34:63-66 (§3, BR-4:
   „generierte Binary→reale Anatomie (`render_adhoc_module_source` → `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC`
   → DLL → Loader"); super 14:744 („CMake-Treiber: Pro Permutation … 1 .so/.dll pro Permutation" —
   SUPERSEDIERT durch Laufzeit-C++-Orchestrierung LEDGER:89/1178); Dossier 19 E3→E2-Vertrag
   (super 19:18: `BuildOrchestrator::provision_all` → `adhoc_emitter`).

**Delta-Vermerk:** Die IST-Systemachsen (system_axis/i_measurement_source/measurement_axis_registry) liegen
als Header in der **ce-Bibliothek** (`libs/cache_engine/measurement/`), nicht in einem CEB-eigenen Modul —
host-seitig konsumiert erfüllen sie „in die CEB hineinkompiliert" der Sache nach; ein explizites
CEB-Systemachsen-MODUL (mit compile-time-Hauptachsen + runtime-Unter-Achsen des CEB selbst) existiert NICHT.

---

## 5. Messung der Systemachsen „nach einer Strategie" (dokumentierte Strategie-Struktur)

- **Observer-Strategy-Pattern je Achse:** super 18:40-42 (A.3): „Die Effekt-/Mess-Logik je Achse ist als
  **Strategy-Pattern** hinter dem System-Achsen-Observer-Interface auszuführen — austauschbar/erforschbar
  je Achse … zero runtime cost via compile-time-Dispatch."
- **3 Strategies unter der Wurzel:** LEDGER:655 („3 Strategies (WallClock/ObserverSnapshot/Pmc) NUR lesend
  auf den Host-PODs"); Code ce `system_axis.hpp:192/238/283`.
- **Regime-Strategie (Zweiteilung):** TimeObserver vs. PmcCounter, thesis-wörtlich (system_axis.hpp:55-80;
  super 19:32: „observer/PMC-Zweiteilung (`06_evaluation_methodology.tex:110-126`) als Regime-Merkmal").
- **Die 3 Mess-Modi/Dimensionen** (kanonisch): ce `docs/architecture/24_…:36-80` (§2.1 Lebewesen-Wall-Clock
  im CEB / §2.2 Per-Achsen-Observer `observe_all` / §2.3 Achsen-Vergleich vs. bekannte Algos [std::map] —
  §2.3 entscheidet die Achsen-Güte, 24:63-73); konsolidiert in ce 34:87-99 (§5) und als R10-Nachtrag
  super 18:149-150 + LEDGER:1270.
- **Mess-Gültigkeits-Disziplinen:** Zwei-Phasen-Op-Schleife + Konformitäts-Gate (ce 34:104-106); 3
  Wiederholungen PFLICHT (LEDGER:371 E3); honest-0>Phantom (super 18:105; LEDGER:118 honest-100%).
- **Visitor+Strategy an der Baum-Wurzel:** super 21:21-23 (System-Achsen-Wurzel reicht Workloads per
  Visitor durch; Strategy je nächstem Workload) — d. h. „Messung nach einer Strategie" ist im
  Typsystem-Bauplan bereits als Wurzel-Systemachsen-Mechanik dokumentiert.

---

## 6. HYBRID-Heuristik-Systemachse (Diplomarbeits-ZIEL)

### 6.1 Die Definition (User 10.07., wörtlich dokumentiert)

**super `docs/architektur/19_…:71`** (Teil G, Punkt 4 — Hybrid-Modus): „Kernstück: **Die
Heuristik-Optimierungs-Achse ist eine EIGENE SYSTEMACHSE**, die per Metaprogrammierung die **Gattung ihrer
Tier-Binaries übernimmt**; sie verfügt über ein Prüf-Dock, das im Arbeitsmodus **Arbeits-Dock** heißt, und
wird **selbst zu einer Tier-Binary kompiliert**, die am eigentlichen Prüfdock des CacheEngineBuilder
andocken kann, um Befehle an die ihr **statisch zugewiesenen echten Tier-Binaries weiterzureichen
(Metaprogrammierungs-Command-Pattern)**. Die Rekombination … ist **selbst permutierbar** …; ABI-stabiles
Gattungsinterface eindeutig als Suchalgorithmus-Hülle … erneute Messung des Heuristik-Tier-Binaries."
- Ziel-Klarstellung 19:73: beste Rekombination/bestes Einzel-Binary (bes. Cache-Line-Awareness) finden und
  „die beste einzelne Binary UND das Heuristik-Tier-Binary bereitzustellen, die in Produktion tatsächlich
  verwendet werden können"; alle 4 CEB-Modi automatisch in E4 dokumentieren.
- Architektur-Konsequenz 19:75: Hot-Switch NUR an der ABI-Grenze (E2, DLL-Wechsel), „kein Runtime-Switch IM
  Tier"; Arbeitsmodus nach E4′ (braucht #156-Messdaten + Cluster-Research).
- Zweitbeleg (identischer Wortlaut, Ledger-verankert): **LEDGER:655 (c)** „USER-DIREKTIVE 10.07. …
  VIERTER Modus = HYBRID-MODUS = das ZIEL der Diplomarbeit — … die **Heuristik-Optimierungs-Achse ist eine
  EIGENE SYSTEMACHSE**, übernimmt per Metaprogrammierung die Gattung ihrer Tier-Binaries, hat ein
  **Arbeits-Dock** und wird SELBST zur Tier-Binary kompiliert …"
- Goal-Verankerung: **LEDGER:92** (V5 (e)); MEM `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching`
  (MEMORY-Index: „Mess→Auswertung→Arbeitsmodus→Hybrid; Dossier 19").

### 6.2 Status/Gating

- **LEDGER:295** (§11-H): „**Gated:** Heuristik-/Tier-Switch-HYBRID-Systemachse = Diplomarbeits-ZIEL,
  **#156-DATA-gated**; IPC_CPI = Cluster-PMC/#156; FILL_BUFFER_OCCUPANCY = Design-GO (Regime)."
- **MEM `reference_tier_metaphor_system_axis_properties_verified_complete.md`**: „Heuristik-/Tier-Switch
  HYBRID-Systemachse = das eigentliche Diplomarbeits-ZIEL (Arbeits-Dock, Metaprogrammierungs-Command-Pattern,
  permutierbare Heuristik-Rekombination) — #156-DATA-gated."
- **LEDGER:665** (Schluss): „Naechster Increment: E4′/Arbeitsmodus-Strecke — mit **Eigenschaften-
  Deep-Research zur Heuristik-Systemachse VOR dem Bau**" — ebenso super 20:73-76 (§F: „E4′-/Arbeitsmodus-
  Strecke implementiert dieses Diff (mit vorgelagertem Eigenschaften-Deep-Research zu Kardinalitäten und
  **Heuristik-Systemachse**) → Hybrid-Strecke").
- **F3(ii) 2026-07-16 (LEDGER:370):** „die 4 CEB-Betriebsmodi als XML-Element sind PFLICHT und BASISFEATURE,
  ‚gut durchgeplant' — NICHT vertagen (Dossier 19 = Planungsquelle)."

### 6.3 Zuarbeitende Bausteine (E4′-Umfeld der Heuristik-Systemachse)

**super `docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md`:**
- §B (20:17-39): Messkurven-Typsystem `tree<axis, map<framework, map<type, map<size, map<op,
  map<observer, tuple<property,time>>>>>>>`; **Kardinalitäts-Auftrag 20:37-39: „sodass die
  Messsystem-Achsen (Registry/‚Blut', `measurement_axis_registry.hpp`) die Auswertung ermöglichen."**
- §C (20:41-45): Filterkette = **Chain of Responsibility, strikt im CacheEngineBuilder** für die Kontrolle
  der Tier-Binary-GENERIERUNG; IST: Slice 1 gebaut (`selection_filter_chain.hpp`, ce `076b71cf`, 20:66).
- §D (20:47-57): Messfehler-Erkennung = **3-Varianten-Observer-Einbau** (alle Tiere+Hybrid / nur
  Heuristik-Tier / keins=Wall-Clock-only) + komplementärer 4. Schritt ohne Messinstanzen (Paper-Vergleich
  geht vor); IST: fehlt (20:67-68), Hybrid-Strecke.
- §G (20:78-107): Kardinalitäten (19 Slots, Wurzel-Split 5 dynamic/14 compile, **Registry-Gesamtraum 26**,
  16 MeasurementCategory = 9 TimeObserver + 7 PmcCounter, 20:86/91); 3 Kardinalitäts-Klassen unter
  „P2 Registry-als-Blut" (20:98-107).
- Heuristik-Kurven-Kern: super 18:44-46 (A.4) + 18:121-122 (F.3: `cacheline_policy_selector.hpp` als
  GoF-Strategy-Prototyp = „die Heuristik-Kurve in nuce — die Endauswertung baut auf diesem Selektor auf").

---

## 7. F4-PFLICHT-SYSTEMACHSEN (Scheduling/Hardware/NUMA/Locking) — IST-Verortung des „kaputten" Konzepts

User 07-16 (LEDGER:368): diese vier „sollten als System-Achsen NEBEN den Mess-System-Achsen liegen; sind
TODO" — keine Duplikate, sondern „3 missverstandene Stellen des Konzeptes". Was heute dokumentiert ist:

1. **Scheduling** liegt aktuell als **#37 Scheduling-27.-PERMUTATIONS-Achse** (= ORGAN-Achse!) im Plan:
   Fork-Entscheid User 2026-07-13 (**LEDGER:392 (c)**: „#37-Scheduling = A+B, Prio A — echte 27.
   Permutations-Achse `topics/scheduling/axis_13` (CRTP) + Anhang-D-Katalog + B=Deskriptor/c11_scheduler
   bleibt; ⚠️ A BRICHT golden_320/kV3AxisSchema/POD/ABI(4→5)/26-Invariante/GenusBindingTraits — expliziter
   TABU-GO"); V5.8-TABU-Ausnahme **LEDGER:102**; Nummern-Klärung #37 **LEDGER:79**; „#37-3-Achsen braucht
   mehr Kontext → ultracode-Recherche beauftragt" (**LEDGER:371 E13**). ⇒ **Spannungsfeld zum 07-16-Konzept**
   (Systemachse neben den Mess-System-Achsen vs. 27. Organ-Achse) — genau die vom User adressierte
   „missverstandene Stelle"; Auflösung = Dossier-Aufgabe.
2. **Hardware:** dokumentierte Wurzel-Zuordnung existiert punktuell: `hw_prefetcher` = „System-/Wurzel-
   Unter-Achse" (super 21:137-138); T12-ISA/axis_09b + Plattform-Etikettierung (ISA+OS) sind heute Build-/
   Organ-Dimensionen (ce 34:29-31: „+3 Build-Achsen page_type/09b/12 außerhalb der Komposition"); P/E-Core
   (`hybrid_core_aware`, ce i_measurement_source.hpp:55; G-270a LEDGER:1122).
3. **NUMA:** als **F-B** GO4-Permutations-Mess-Knopf gebaut/geplant („NUMA/Page→allocator compile-time-
   gated, als dokumentierter Permutations-Mess-Knopf", **LEDGER:360**; Design-Fork F-A/F-B super
   21:230-233); T5-IMC/NUMA-Nuance als RC-Feld-Kandidat (super 18:119); ⇒ heute allocator-/Organ-seitig,
   NICHT als Systemachse.
4. **Locking:** heute T8 concurrency = ORGAN-Achse (echte Contention-Semantik gefordert, super 18:95 +
   19:33); „sequenzielle Locks ‚0 Contention' = physikalisch unmöglich → ehrlich compile-time-only"
   (super 18:69). Keine dokumentierte Locking-SYSTEMachse.

⇒ **Befund:** Für alle vier existiert KEINE Systemachsen-Verankerung im Sinne des 07-16-Konzepts; die
   Registry-16 sind reine MESS-Kategorien. Das Konzept „Pflicht-Systemachsen NEBEN den Mess-System-Achsen"
   ist ausschließlich in LEDGER:368 dokumentiert = der TODO-Anker.

---

## 8. NEUE Compiler-SYSTEMACHSE (gcc XOR clang je CEB + je Tier-Binary-Permutation)

- Einzige Verankerung: **LEDGER:368 F3i(1)** (wörtlich, siehe §0). Nirgends sonst dokumentiert.
- Nächste existierende Verwandte (KEINE Systemachse): `compile_dims 6` in den KK-2-Kardinalitäten
  (super 20:105); `get_compiler==original`-Konformitäts-Asserts je Organ-Modul (LEDGER:427); Toolchain-CI
  „#273-T2/T3 gcc-15.3-Pin + clang-Matrix-Rollout" (LEDGER:1133); 8er-Docker-Build-Matrix-Doktrin
  (MEM `feedback_build_matrix_8_docker_distros_full_platform_doctrine`).
- ⇒ Voll-Neubau-Anker; XML-seitig anschlussfähig an die Experiment-XML-Architektur (LEDGER:118: „CEB …
  parst 2 Registry-XMLs + EINE Experiment-XML; baut Tier-Binaries ZUR LAUFZEIT (C++-orchestriert, NICHT
  CMake)") — die Laufzeit-Bau-Orchestrierung ist der natürliche Ort einer per-Permutation-Compiler-Wahl.

---

## 9. Voll-Vergleich + „alt gegen neu" JE der 3 Stufen (KEINE 4. Stufe)

- User-Definition: LEDGER:368 F3i(2)+(3) (siehe §0; „für alle genannten Ketten"; die „4. Kategorie" =
  eigene Kategorie mit Unterkategorien **je Stufe**, keine 4. Stufe).
- Die 3 Stufen sind kanonisch dokumentiert: **ce 34:81-85** (§4, 3-Stufen-Prüfung nach Doc 24 §8.9):
  Stufe 1 `comdare_perms_ce` (NUR CE) · Stufe 2 `comdare_perms_<pf>` (Prüfling ERSETZT je Achse,
  CE-Fallback) · Stufe 3 `comdare_perms_full_join` (Union non-redundant); Ursprung super 14:777-849 (§18,
  „3 Kompositionale Joins"); als 3-Phasen-Experiment-XML re-verankert (LEDGER:118: „EINE Experiment-XML
  (3 Phasen: prt-art / cache-engine / kombiniert = 3-Stufen-Join)").
- „Alt gegen neu" = SOTA vs. Prüfling: MEM `feedback_prt_art_consumes_cache_engine` (PRT_ART=Prüfling,
  CacheEngine=Werkzeug); Registry-Paar ce-SOTA + prt-art-abstrakt (LEDGER:118); `run_sota_series`/
  SOTA-Katalog Pfad A/B (super 18:59; super 20:68).
- Der Compare-Unterbau des Voll-Vergleichs (jede Tier-Binary gegen ALLE anderen) ist als Hybrid-„Compare-
  Feature auf E4" dokumentiert (super 19:71: „kombinierte Wall-Clock … **cross alle Tier-Binaries** über
  alle Operationen mitloggt … Mess-Command-Pattern über die optimierte Tier-Binary-Rekombination als
  virtuelles ganzes Tier-Binary"); Datenlast/Compiler/ISA+OS-Dimensionierung des Vergleichs ist NUR in
  LEDGER:368 F3i(2) verankert (Compiler+ISA+OS als Vergleichs-Schlüssel = neu).

---

## 10. Experiment-B+-Baum-Filter für die CEB-Stufe + Experiment-Planer als DRITTE ANWENDUNG

- User-Anker: LEDGER:368 (siehe §0).
- **Filter-Vorläufer (gebaut):** CoR-Filterkette „strikt im CacheEngineBuilder-Bereich für die Kontrolle der
  Tier-Binary-GENERIERUNG (Auswertung → Filter → welche Permutationen werden als Nächstes gebaut/verworfen)"
  (super 20:41-45; IST Slice 1 `selection_filter_chain.hpp` + ResumeFilter, ce `076b71cf`, super 20:66).
  Der 07-16-„Filter für die Stufe der CacheEngineBuilder" ist die konzeptuelle Erweiterung dieses
  Kettenglieds auf die CEB-STUFEN-Selektion im Experiment-B+-Baum.
- **Baum selbst:** ce 34:52-71 (§3: AxisLevel-Layer, binary_id-Bijektion, nie voll materialisiert,
  DynamicVariableNode); super 21:16-28 (Layer-Modell, Wurzel=System-Achsen).
- **Anwendungs-Zählung im Framework:** dokumentierte Anwendungen bisher (ce 34:73-78 §4):
  (1) `messung_driver` (Diplomarbeit/Code, OUTER-LOOP/Auswertung), (2) **CacheEngineBuilder** (App), dazu
  CacheEngine=Werkzeug-BIBLIOTHEK und Prüfling. Der „Experiment-Planer mit XML-Interpreter" als **NEUE
  DRITTE ANWENDUNG** ist ausschließlich in LEDGER:368 verankert; anschlussfähig: „CEB-Ziel = 4 Modi …"
  (LEDGER:92/118), F1-Erweiterung „die Cache Engine stellt als Framework eine BIBLIOTHEK bereit, welche per
  XML-Config die ‚Programmierung' von Experimenten UND deren Auswertung erlaubt" (LEDGER:370 F1) und F6
  („XML steuert dynamisch die Programmierung der CI über einen INTERPRETER; JEDES einzelne Feature …
  in XML unterstützt", LEDGER:370 F6). ⚠️ Abgrenzungs-Pflicht: Option-A-Direktive (LEDGER:372) — KEINE
  Parallelstrecke; die dritte Anwendung muss ÜBER dem einen offiziellen E4/CEB-Pfad andocken
  (MEM `feedback_vor_aufgaben_erst_projektstruktur_analyse`).

---

## 11. E-Ebenen-/Schichten-Verortung (Querschnitt M)

- Pipeline + Querschnitt: super 19:13 (Teil A): „Dazu der Querschnitt **M** (Mess-System, System-Achsen
  ‚Blut') und E0 (Infra, zuletzt)"; Vertrags-Tabelle Zeile M super 19:21: Vertrag =
  „System-Achsen-Wurzel `SystemAxis`/`IMeasurementSource` — immer präsent bei Messung, NICHT im
  Permutationsbaum, NICHT Gattung"; IST damals „Wurzel fehlt … = Aufgabe M1".
- M-DoD super 19:32: zero-cost CRTP+Concept, kein vtable im Hot-Path, ABI-Grenze unverändert;
  Mess-Kategorien-Katalog wörtlich aus Thesis `03_messsystem_prtart.tex:382-386`; observer/PMC-Zweiteilung
  aus `06_evaluation_methodology.tex:110-126`; „M ist OHNE Tier-Binaries testbar".
- Schicht-Sequenz: super 19:51 (Teil D): „E4 → E3 → E2 → **M** → E1 → … → E0"; Vollzug: LEDGER:655
  („Sequenz-Stand: E4 ✓ E3 ✓ E2 ✓ M ✓ → nächste Schicht E1").
- E4→E0-Disziplin: super 18:48-50 (A.5) — System-Achsen (Blut) sind E0-Querschnitt, nicht im
  E2/E3-Permutationsbaum; MEM `feedback_system_axes_measurement_own_abstract_root_blood` (E0-nah/Mess).

---

## 12. Thesis-Verankerung (Systemachsen in der Diplomarbeit)

- Mess-Kategorien-Katalog: `thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex:382-386` (zitiert in
  super 19:32 + ce system_axis.hpp:57/72); Regime-Zweiteilung: `06_evaluation_methodology.tex:110-126`
  bzw. :119-126 (super 19:32; ce system_axis.hpp:58/73).
- `bytes_in_use_peak`-Kanon: `05_evaluation.tex:94-95` (LEDGER:304; honest-0-Entscheid H-2).
- Thesis-Kapitel-Integration der Konzepte: LEDGER:741-742 („7 Konzepte (E4→E0+Verträge, … Organ- vs.
  System-Achsen, SystemAxis/Regime/16 Kategorien, IMeasurementSource/Registry, curve_fit, 4 Modi inkl.
  Hybrid-Gegenbeweis)"), LEDGER:753 („Organ-/System-Achsen/Regime/honest-0 in §3.4 + §3.6.2 Vier
  Betriebsmodi inkl. HYBRID-Gegenbeweis"), LEDGER:766 („System-Achsen im Code, IsComposition").
- Design-Quellen-Doktrin: Thesis-LaTeX = Primärquelle jeder Implementierung (super 19:9; MEM
  `feedback_diplomarbeit_design_ist_quelle_der_implementierung`).

---

## 13. DELTA-ÜBERSICHT: USER-KONZEPT (Soll 07-16) vs. dokumentierter/gebauter Stand

| # | Konzept-Element (User 07-16) | Dokumentiert wo | Gebaut? |
|---|---|---|---|
| 1 | Systemachsen ≠ Gattungs-Achsen (getrennte Konzepte) | 18:15-30 · 19:21 · MEM blood · LEDGER:100/289-292 | JA (Wurzel-Trennung code-verankert, system_axis.hpp:143-145) |
| 2 | Beide mit compile-time-HAUPT- + runtime-UNTER-Achsen | Organ-Seite: 21:29-31 (RC-Skalar=Unter-Achse); System-Seite: 21:21-23/50/137-138 (Wurzel-System-Achsen, hw_prefetcher=System-Unter-Achse) | TEILS (Organ-Seite ja; System-Seite nur Registry-16 flach, KEINE Haupt/Unter-Struktur im Code) |
| 3 | Systemachsen IN CEB hineinkompiliert; Gattungs-Achsen VON CEB in Tier-Binaries | LEDGER:368 (wörtlich) · LEDGER:89/1178 (CEB hält Messsystem) · Host-seitigkeit system_axis.hpp:1-5, i_measurement_source.hpp:4-6 | TEILS (host-seitige lib-Header; kein CEB-Systemachsen-Modul) |
| 4 | Messung der Systemachsen „nach einer Strategie" | 18:40-42 (Observer-Strategy) · LEDGER:655 (3 Strategies) · 24 §2 (3 Dimensionen) · 21:21-23 (Visitor+Strategy an Wurzel) | TEILS (Strategien gebaut, 0 Produktions-Konsumenten, E4-Wiring #156-gated) |
| 5 | PFLICHT-Systemachsen Scheduling/Hardware/NUMA/Locking NEBEN Mess-System-Achsen | NUR LEDGER:368; heute konfligierend als Organ-/Build-Dimensionen (#37 27.-Achse LEDGER:392/102; F-B NUMA→allocator LEDGER:360; T8 Locking 18:95) | NEIN (TODO; Konzept-Reparatur = Dossier-Auftrag) |
| 6 | NEUE Compiler-Systemachse (gcc/clang je CEB + je Permutation, XML-gewählt) | NUR LEDGER:368 F3i(1) | NEIN |
| 7 | Voll-Vergleich jede-gegen-alle (Lasten×Compiler×ISA+OS) | LEDGER:368 F3i(2); Unterbau 19:71 (Hybrid-Compare) + 34 §3 (Baum) | NEIN (Compare-Feature = Hybrid-Strecke, gated) |
| 8 | „alt gegen neu" = SOTA vs. Prüfling JE der 3 Stufen, keine 4. Stufe | LEDGER:368 F3i(3); Stufen: 34:81-85 · 14 §18 · LEDGER:118 (3-Phasen-XML) | TEILS (3-Stufen-Maschinerie da; je-Stufe-Ausführung der neuen Kategorie = neu) |
| 9 | Experiment-B+-Baum-Filter für die CEB-Stufe | LEDGER:368; Vorläufer CoR 20:41-45/66 (selection_filter_chain, gebaut) | TEILS |
| 10 | Experiment-Planer mit XML-Interpreter = NEUE DRITTE ANWENDUNG | NUR LEDGER:368; anschlussfähig LEDGER:370 F1/F6, 372 Option A (offizieller Pfad!) | NEIN |
| 11 | HYBRID-Heuristik-Systemachse = DA-Ziel | 19:71/73/75 · LEDGER:92/295/655(c) · MEM tier_metaphor · 20 §D/F | NEIN (#156-DATA-gated; Deep-Research VOR Bau vorgeschrieben) |

**Kern-Reparaturstellen („das Konzept ist Pflicht und kaputt"):** (a) die 07-16-Pflicht-Systemachsen-Familie
(Scheduling/Hardware/NUMA/Locking) hat keinen Systemachsen-Ort — insbesondere kollidiert #37
(27. PERMUTATIONS-Achse) mit der Systemachsen-Lesart; (b) die System-Seite hat keine Haupt-/Unter-Achsen-
Struktur (nur die flache 16er-Registry); (c) die Compiler-Systemachse und der Experiment-Planer (dritte
Anwendung) fehlen vollständig; (d) das E4-Wiring der bestehenden Systemachsen-Wurzel ist bewusst gated
(Null-Consumer, LEDGER:150/402) — Konsum entsteht erst mit E4′/#156.

---

## 14. Quellen-Index (alle gesichteten Fundstellen)

- super `docs/architektur/14_achsen_komposition_organ_metapher.md` (3477 Z.): §17.3:740-773; §18:777-849;
  §26:1018-1088; §27:1091-1161; §28:1164-1208; Schärfungs-Banner 1020-1028/1093-1102/1166-1178; „Blutkreislauf
  (allocator)"-Altbild :494.
- super `docs/architektur/18_MESS_METHODIK_ACHSEN_OPTIMIERUNG_KONSOLIDIERT.md` (150 Z.): A.1:15-30; A.3:40-42;
  A.4:44-46; A.5:48-50; B.2:62-70; TABU:104; honest-0:105; F.1/F.2:114-119; F.3:121-122; R10:149-150.
- super `docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md` (90 Z.): 13; 21; 23;
  32; 43; 51; Teil G:62-75 (Hybrid:71, Ziel:73, Konsequenzen:75); R4:89.
- super `docs/architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md` (150 Z.): §B:17-39; §C:41-45;
  §D:47-57; §E-Tabelle:59-69; §F:71-76; §G:78-107; §I:122-141; Supersession:144.
- super `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md`: 1-51; 54-73; 134-138; 228-241.
- LEDGER `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (1271 Z.): 79; 83; 89; 92; 100; 102; 118; 150;
  289-311 (§11-H); 360; 368 (F3i/F4/F5); 370 (F1-F12); 371 (E1-E16); 372 (Option A); 388; 392; 402; 427;
  645; 655; 665; 694; 741-766; 1122-1125; 1133; 1178; 1268-1271.
- ce `docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md` (675 Z.): §2:30-80; 327-328; 371-373;
  426-427; 471.
- ce `docs/architecture/34_KONSOLIDIERTER_MASTER_IST_STAND.md` (235 Z.): §1:15-34; §2:36-50; §3:52-71;
  §4:73-85; §5:87-106; §8:139-154.
- ce `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp` (338 Z.): 1-5; 20-53; 55-80;
  100-132; 134-145; 147-190; 192-236; 238; 283.
- ce `libs/cache_engine/include/cache_engine/measurement/i_measurement_source.hpp` (186 Z.): 1-11; 24-69;
  72; 100; 136.
- ce `libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.hpp` (77 Z.): 1-5; 16-23;
  32-49; 52-75.
- ce `tests/unit/test_m_contract_system_axis_wurzel.cpp`: honest-0-Block ~130-145.
- MEM `feedback_system_axes_measurement_own_abstract_root_blood.md` (vollständig);
  MEM `reference_tier_metaphor_system_axis_properties_verified_complete.md` (vollständig).
