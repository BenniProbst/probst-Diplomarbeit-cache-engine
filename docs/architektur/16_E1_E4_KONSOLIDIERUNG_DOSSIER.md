# DOSSIER — E1–E4-Ebenen-Konsolidierung, Bruch-Nachzug & #31 ebenen-richtig (E4-XML)

> **Status:** GENEHMIGT 2026-07-09 (User). Autoritative E1–E4-Konsolidierungs-Doku + Umsetzungs-Roadmap. Konsolidiert 5 Analyse-Läufe (2 ultracode-Workflows + Memory-Kartierung + 3 Explore-Kartierungen + TODO-Audit), Backups super `844d3f8`/`51b4d45`/`f92e7d9`/`157a3d6`/`a219605`/`33c89d4`. Alle Belege `datei:zeile`; Wurzeln: **super** = `probst-diplomarbeit-cache-engine`, **ce** = `super/Code/external/comdare-cache-engine`, **mod** = `Modules/comdare-measurement-all`, **LEDGER** = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`.

## 0. Zweck & Auslöser

Die Diplomarbeit ist ein Experiment-System, dessen compile-time-Permutationsraum **137.594.142.720.000 Tier-Binaries** umfasst (`CE/34:61-62`, nie materialisiert, C1060) — gefahren über eine **vierstufige Experiment-Maschinerie E1–E4** (28.06. etabliert, code-verankert). Diese Maschinerie ging in einem **datierten Wissensverlust (Bruch 02.–03.07.)** aus dem aktiven Vokabular verloren; seither wurde ohne die Ebenen-Linse weitergearbeitet. Symptom und Anlass: **#31 (Mess-Frameworks × Workloads) wurde als tote compile-time-Insel in der cache-engine (E2) gebaut**, obwohl es E4-XML-Definition ist — der Autor benennt es selbst E1/E4, materialisiert es aber E2 (`workload_matrix.hpp:10-11,19` vs. `:105`). Der Korrektur-Plan F7-Doc-15 (08.07.) empfahl denselben Fehler erneut.

**Dieses Dossier** (a) rekonstruiert die autoritative Architektur aus den ~170 Seiten `docs/architecture(+ktur)`, (b) korrigiert den Bruch systematisch — zieht alle ab 02.07. entstandenen Dokumente an den E1–E4-Plan nach und löst die Namenskollision auf, (c) stellt daraus die belastbare Aufgaben-Wahrheit her (Audit: nur 1 aktiver Fehlbau, aber strukturelle E4-Wurzel-Lücke), und (d) plant #31 ebenen-richtig + die geordnete Nacharbeit E4→E1. **Erst die Konsolidierung (Teil B) macht die Aufgabenliste (Teil C) belastbar** — deshalb steht sie vorn.

---

# TEIL A — DIE AUTORITATIVE ARCHITEKTUR (Konsolidat der ~170 Seiten)

## A.1 Quellen-Hierarchie & Master-Stand

Bei Widerspruch gilt (`CE/34:10-11`): **Doc 30 §8.0 > IST-Ledger > e2e-Abnahme > Code > `CE/34` (Konsolidierung) > Einzel-Docs 15–33 > Thesis-Basis 00–14 (SUPERSEDED)**.
- **Autoritativ:** `CE/34_KONSOLIDIERTER_MASTER_IST_STAND.md` (IST-SSoT über 48 Quellen) + `SUP/14_achsen_komposition_organ_metapher.md` (3462 Z., die Organ-Metapher-Quelle, von `CE/34/36/28` autoritativ zitiert).
- **SUPERSEDED** (nie vermischen, `CE/34:200-208`): `SUP/02_aktueller_master_REV7_7.md` mit dem gesamten Alt-Vokabular **3-Säulen / F1–F29 / S1–S30 / 11-Bausteine-Achsen / `IExecutingEngine`**. Das ist **Bruchlinie 1** (Vokabular-Supersession).

## A.2 Die 3-Ebenen-Anatomie (A1–A3) — das „Lebewesen"

Autoritatives 3-Ebenen-(+Sub)-Modell (`CE/34:15-34`, `SUP/TIER:108-122`, `SUP/14 §26-§28`):

| Ebene | Begriff | Kardinalität | Code |
|---|---|---|---|
| **1 Gattung** | Außen-Interface = Prüf-Dock | **3**: SearchAlgorithm / Container / Graph | `AnatomyGattung`-Enum |
| **2 Lebewesen-Unterklasse** | fester Achsen-Satz | **5**: SearchAlgorithm / Set / Sequence / Adapter / View — Slots **19 / 15 / 11 / 13 / 7** | `AnatomyGenus`, `GenusBindingTraits<G>` |
| **3 Achse = Organ** | permutierendes Organ (**keine optional** — Durchreich statt Weglassen) | 19 (SearchAlgorithm) | die 19 T0–T18 |
| **4 Sub-Achse** | Organ-Bestandteil | ~279 | — |

- **A1 Composition (Genom):** `AdHocComposition<T0..T18>` = 19 named using-Slots, `static_assert sizeof...==19`, keine Defaults (`CE/34:43-44`, `CE/36:83-84`). **Die 19 Achsen** (`CE/34:139-142`): search_algo · cache_traversal · mapping · path_compression · node_type · memory_layout · allocator · prefetch · concurrency · serialization · telemetry · value_handle · isa · index_organization · io_dispatch · migration_policy · filter · queuing_q1 · queuing_q2 (+3 Build-Achsen page_type/09b/12 = Codegen-Varianten *derselben* Binary → historische „22").
- **A2 Anatomie (compile-time Körper):** `SearchAlgorithmAnatomy<Composition>`, `observe_all()→ObserverAggregate`, `genus()==SearchAlgorithm` (`SUP/14:688`, `CE/36:71-76`).
- **A3 AbiAdapter (Laufzeit-DLL-Sicht):** `SearchAlgorithmAbiAdapter<A> : IAnatomyBase, IMeasurableWorkload, IObservableTier` (Reihenfolge eingefroren, `CE/34:114-116`).
- **Nur SearchAlgorithm voll gebaut** (BR-1..4 verifiziert); Set/Sequence/Adapter/View = GenusBindingTraits-Bindings (`CE/34:29-32`).
- **`Lebewesen ≡ SearchAlgorithm`, EINE Hierarchie**, keine Parallel-Bäume (`CE/36:18-27`; der frühere „2 Bäume"-Defekt I1 wurde 2026-06-25 behoben, `CE/36:170-178`). Geschwister: `IVirusExecutionEngine` (Graph/FFT/Crypto — „Viren").

## A.3 Die E1–E4-Experiment-Maschinerie — der Motor

**Der Baum ist nur Maschinerie; das eigentliche Experiment IST die XML** (`ce Dossier §13`).

```
E4  messung_driver (WAS)  ── XML comdare_thesis_profile ──▶ read-only Baum-Traversal + inverse Signatur → CSV/LaTeX
      SUP/10:62-71 · CE/26:21-26,122-127 · CE/34:212-222 · Ziel #229: nur die XML ändern
        │  liefert je Achse: gepinnt (Fanout 1) / freigegeben (Fanout N)
        ▼
E3  Permutations-B+-Baum PRO GATTUNG   experiment_tree.hpp / PermutationEngine<…> / GenusBindingTraits<G>
      Achse = Baum-Ebene; Pfad Wurzel→Blatt = binary_id; StaticBinaryView = Mixed-Radix-Bijektion
      Gate-1: binary_count() == ∏ mp_size(Enabled_i) == PermutationEngine::count() == 137.594.142.720.000
              (CE/34:52-62, CE/27:298-302)  ·  NIE voll materialisiert (~21 GB, CE/26:80-91)
      4 Brücken BR-1..4 (Registry→Baum→Composition→Observer→Binary), alle verifiziert (CE/27:149-252)
      5 per-Gattung-PermutationEngines (Cross-Genus type-unmöglich, SUP/14:1240-1333)
        │  StaticAxisNode (compile-time → EINE Binary)          Abstract Factory: make_static/make_dynamic (CE/26:130-164)
        ▼
E2  Tier-Binaries compile-time   adhoc_emitter → COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(<19 FQ>) → SHARED-DLL
      AnatomyModuleLoader → dynamic_cast<IObservableTier*> (CE/34:65-66)
        │  DynamicVariableNode (Laufzeit-FOR-Schleife auf geladener Binary — KEIN Neubau)
        ▼
E1  RC-Laufzeit   Algorithm_Resource_Control (POD ComdareResourceControlV1, 5 Felder)
      Lastprofil = dynamische Achse 2 (14 LP → 21 XML, CE/32:3-6)
      Zwei-Phasen-Op-Schleife PFLICHT (save→op-warmup→rollback→op-measure, CE/v5_design:176-189)
```
**E0** = Querschnitt (Infra/CI/Modul-Struktur), *nicht* Experiment-Pipeline.

## A.4 Die Mess-Architektur — 2(+1) Dimensionen, 2 Pfade, 3 Profile

- **3 Mess-Dimensionen** (`CE/24:34,77-81`): (1) **Lebewesen-Wall-Clock** (CacheEngineBuilder, Latenz über Füllstand r/w/d, `total_cycles`) · (2) **Per-Achsen-Observer** (`observe_all()→axis_stats[19][8]`) · (3) **Achsen-Vergleich** = *Tests gegen std::map* — **entscheidet Achsen-Güte, NICHT die Latenz** (`CE/24:75-81`).
- **2 Pfade über dieselbe Binary** (`CE/24:322-328`): **Pfad A** = isolierte Achse in der DLL (`IMeasurableWorkload::run_workload`, `f15_compare`) · **Pfad B** = composite Lebewesen zentral via `IObservableTier::tier_observe`.
- **Der reale Mess-„Visitor"** ist **kein Visitor**, sondern **ein flacher memcpy-POD-Pull**: `IObservableTier::tier_observe(ComdareTierObserverSnapshot*)` pure virtual (`CE/31:84`), Schema `kV3AxisSchema` = `axis_stats[19][8]+seg_ns[19]+Meta`, ABI-Major 3 (`CE/31:44-62`). Ziel-POD beider Dimensionen: `ComdareMeasurementSnapshotV1` 16+6 Spalten (`measurement_snapshot.hpp:34-66`), HW-Counter `pmc_available`-ehrlich.
- **3 orthogonale Profile** (`CE/drei_profile:10-14`): **BUILD** (compile-time: welche Binaries) ⊥ **LASTENPROFIL** (runtime host: YCSB/Seed) ⊥ **COMPILE-RELEASE** (`COMDARE_MEASUREMENT_MODE`). Build ⊥ Last = kartesisches Kreuz (1 Binary × N Lastprofile ohne Rekompilation).
- **Prüf-Dock je Gattung** (`CE/24:499-568`): CEB-seitig, lädt+treibt Gattungs-API+misst Observer; `PruefDockRegistry::select_for` via `genus()`.
- **PRT-ART-3-Stufen-Join** (`CE/24:589-664`): Stufe 1 CE-Perms · Stufe 2 Prüfling-ersetzt · Stufe 3 A⋈B; **Regel der abstrakt-leeren Achse** (leere Prüfling-Achse reust alle CE-Algos).

## A.5 Der eine echte Architektur-Defekt (= E2-Wurzel #188)

`search_organ_`-Monolith **beschattet** node_type/memory_layout → Lebewesen routen **nicht uniform** durch alle Organe → Achsen-Differenzen teils **Apparat-Artefakt** statt Forschungssignal (`CE/34:156-164`, mission-kritisch; SOLL-Plan `ce Dossier §17:489-513`: EIN `container_ = ObservableComposedSearch<…, LayoutAwareChunkedStore>` für alle Familien, `search_organ_` entfällt).

---

# TEIL B — DER BRUCH & DIE KONSOLIDIERUNG (Phase 0, geht allem voran)

## B.1 Chronik des Wissensverlusts (belegt)

| Datum | Ereignis | E-Nutzung |
|---|---|---|
| **28.06.** | ORIGIN — `ce Dossier §12-§17` + `SUP SESSION-ENDE-9`: ~47 TODOs `[E0]–[E4]`-getaggt, Top-Down-Audit E4→E1 | hoch |
| 01.07. | letzte explizite E-Direktive (nur noch Merksatz) | 1 |
| **02.07.** ⚡ | **BRUCH 1** — `MASTER-EXECUTION-PLAN:9-50` ersetzt E-Scheduling durch **Spur S (S1–S9)** + **Spur P (AP-Wellen)** | 0 |
| **03.07.** ⚡ | **BRUCH 2** — neues E-freies Single-Source-Ledger (`LEDGER:145`); §10 degradiert E0-E4 zu „Audit-Dimension, nicht Termin" (`LEDGER:132-134`) | 0 |
| 05.07. | W5-Audit rekonstruiert **konkurrierendes S1–S4** und stellt fest „'4 Schichten' existiert nirgends" (`SYNTHESE-13.10.md:22-24`) — Beweis, dass die 28.06.-Def nicht mehr konsultiert wurde | 0 |
| **06.07.** | **Goal-V3** widmet „E-" zu **Entscheidungs-Defaults „E-A..E-E"** um (`LEDGER:538`) = Namenskollision | 0 |
| **08.07.** ⚡ | **Manifestation** — `15_F7` empfiehlt #31 als E2-compile-time; niemand flaggt die Ebenen-Verwechslung | 0 |
| 09.07. | Wiederentdeckung (dieses Dossier) | — |

**Belastbarkeitsbefund (Audit, s. Teil C):** Der Schaden ist **nicht** breitflächig — 30+ Sessions ohne E-Bezug, aber der Code hielt die Disziplin „Binary-Identität → E2 / Mess-INPUT → E4/E1" **intuitiv**. Nur der vom Dossier §13 vorab als mehrdeutig markierte **Workload/Dataset-Fall (#31)** kippte.

## B.2 Namenskollision — drei „E/S"-Achsen + Auflösung

| # | Achse | Bedeutung | Verankerung |
|---|---|---|---|
| 1 | **E1–E4** | Experiment-Maschinerie (XML→B+→Binary→RC) | code-verankert (`experiment_tree.hpp`, `GenusBindingTraits`), älteste+tragendste |
| 2 | **E-A..E-E** | Goal-V3-Entscheidungs-Defaults | `LEDGER:423,538` — „E" bedeutungslos (reiner Aufzähl-Buchstabe) |
| 3 | **S1–S4** | Schichten-Modell M / 4-Subsystem | `10_schichten_modell_M.md:62-110` — **invers** zu E4→E1 |
| (4) | Spur-S (S1–S9) | God-Header/ABI-Kette | `MASTER-EXECUTION-PLAN:14-27` — dritter „S"-Scope |

**S↔E ist dieselbe Pipeline, invers nummeriert + andere Schnittkanten:** E4↔S1 (Auswertung, aber E4 hat zusätzlich den XML-Eingang) · E3↔S2 (deckungsgleich) · E2↔S3 (DLL vs. Library — andere Kante) · E1↔S4 (Laufzeit-Mechanismus vs. Messobjekt PRT-ART — andere Kante).

**Auflösung (additiv, Doku nie löschen):**
1. **E1–E4 = kanonisch behalten.** `LEDGER:132-134` §10 additiv **rehabilitieren** (E4=XML+Auswertung … E1=RC ausschreiben; „nur Audit-Dimension" als verengte Lesart markieren; Verweis auf `ce Dossier §12-15` + `SESSION-ENDE-9`).
2. **E-A..E-E umbenennen** → **`DD-A..DD-E`** (Decision-Defaults), additiver Rename-Vermerk an `LEDGER:407-413,423,538` (Original stehen lassen). Beseitigt die „E-"-Doppelbelegung sofort.
3. **S1–S4 behalten** (legitimes Subsystem-Ownership-Modell), aber **einmal explizit gegen E1–E4 kreuz-mappen** (Tabelle oben) in `10_schichten_modell_M.md` + Korrektur-Fußnote an `SYNTHESE-13.10.md:22-24`/`LEDGER:510`. Glossar-Disambiguierung: E-Sicht = Experiment-Pipeline (top-down 4→1), S-Sicht = Subsystem (bottom-up 1→4), Spur-S = ABI-Kette.

## B.3 Widerspruchs-Liste (Docs ab 02.07. → gegen E1–E4)

`MASTER-EXECUTION-PLAN:9-50` (Spur S/P ersetzt E) · `LEDGER:132-134` (§10 E-Degradierung) · `LEDGER:423,538` (E-A..E-E-Kollision) · `SYNTHESE-13.10.md:22-24` (konkurrierendes S1–S4) · `SYNTHESE-13.10.md:6-8` (W1 = E2/E1/E3 ohne E-Label) · `LEDGER:510` (AP-10 „Schicht 1..4" invers) · `15_F7:20-48` (M×W compile-time, s. B.5) · `LEDGER:371` (#31-Revert bestätigt Workload=DynamicVariableNode/E1 — **widerlegt F7 selbst**, entdeckt 3 konkurrierende Workload-Enums) · `STANDARDPROZESS:6-9` + `MATRIX-GRUNDLAGEN-GOALV2.md:5-16` (3D-Matrix Familien×Baseline×Module, unversöhnt) · `20260709-WORKFLOW-4layer-DOSSIER.md:1` (dritte 4-Layer-Herleitung, Stub).

## B.4 Nachzieh-Liste (additiv an E1–E4 angleichen)

`LEDGER §10` → E0-E4 als Experiment-Maschinerie ausschreiben · `LEDGER §13.4/§13.12` → E-A..E-E→DD-A..DD-E · `SYNTHESE-13.10 W5/W1` + `LEDGER:510` → „4 Schichten" = E1–E4-Pipeline markieren, S↔E-Inversion notieren · `15_F7` → E-Rahmen (s. B.5) · `MASTER-EXECUTION-PLAN` → S4/#221=E1-Rest + Spur-S≠S1–S4-Glossar · `20260709-WORKFLOW-4layer` → an E1–E4 andocken vor Weiterverarbeitung · `STANDARDPROZESS`/`MATRIX-GRUNDLAGEN` → 3D-Matrix = E0/Product-Achse ⊥ E1–E4 · `10_schichten_modell_M` → E↔S-Kreuz-Map-Block + Ursprungs-Kennzeichnung.

## B.5 F7-Doc-15-Neufassung (der propagierte #31-Fehler)

`15_F7` verortet Workload/Dataset **compile-time (E2)** (`:34,48`), liest „Workload als *dynamische* Achse" fälschlich als compile-time (`:26,38`), und rahmt alles in `measurement-all`-Baselines + M/W/A-B-C **ohne E-Bezug**. **Neufassung (additiv, golden/ABI-neutral) — Kernsatz:**
> **M (Mess-Kategorien) = compile-time (E0-Modul-Interna, Option A OK); W/Datasets = E4-XML-definiert + E1-Laufzeit / E3-Permutation (NICHT compile-time-statisch); A/B/C × Micro/Makro/Gesamt = E4-Auswertung.**

Konkret: Achse M bleibt Option-A-tauglich als *interne* `measurement-all`-Code-Organisation (F6-Metaprogrammierung, golden-orthogonal); Achse W (Workload×Dataset) wandert in E4 (XML wählt Profil×Dataset je Messreihe) → E1 (DynamicVariableNode) / E3 (Dataset = „4. CEB-Permutations-Dimension", `test_data_sets.xml`); Kopf um E-Anker (`ce Dossier §12-15`) ergänzen; `LEDGER:371` als bindenden Beleg zitieren.

---

# TEIL C — DIE IST-WAHRHEIT (Audit, nach der Konsolidierung belastbar)

**Gesamt-Verdikt (~32 auditierte TODOs):** **13 echt ebenen-richtig · 8 teilweise · 1 schein-erledigt-ebenen-falsch (#31)**. Massen-Schein **nicht** belegt. Die Gefahr: (a) #31 + F7-Propagation, (b) die E4-Wurzel #229 (XML-only unerreicht), (c) die offene Wirksamkeits-Schleuse #215.

**Nacharbeits-Liste (7 Audit-Befunde B4-1..B1-1, `ce Dossier §14`):**
- **TIER 1 — Wurzeln:** **#221** (E1, **nur 1/5 RC-Achsen** laufzeit-konsumiert — `abi_adapter.hpp:233-241` liest nur `prefetch_distance`; 4 Setter fehlen → **Phantom-Zeilen** bei #156; = B1-1/B2-2). **#188** (E2-Wurzel — Kern vollzogen, `search_organ_` getilgt; offen: honest-0-Design + **#215-Wirksamkeit**; = B2-1).
- **TIER 2 — Fehlbau:** **#31** (tote E2-Insel; SOLL-XML-Heimat existiert schon).
- **TIER 3 — #229-Verdrahtung:** V32-Orchestrator OFF (`v32_orchestrator.hpp:81-85` Stub); `#184`-Loader + `#25`-Akten CI-grün, aber im Treiber **nicht referenziert** (grep rc=1) → steuern kein Experiment (= B4-1).
- **Etikett-only (kein Fehlbau):** #218/#219 (E1/E2 als „E4" getaggt); #26/#27 real E2 (nicht E3-Gattung); **AP-4/#238 korrekt** (distinkte Binaries — Ledger-Audit-Fehleinschätzung durch Code widerlegt); #223 = E3-Gate wirksam (B3-2 war stale).
- **Ehrlich HELD/gated:** #215 (320-DLL-Neubau, mehrtägig), #156/#162 (Voll-Lauf), #152/#187/#165/#163 (daten-gated).

---

# TEIL D — #31 EBENEN-RICHTIG (E4-XML)

## D.1 Der Fehlbau
`workload_matrix.hpp:105` `mp_product<mp_list, ycsb_profile_list, dataset_list>` = 36 Zellen compile-time in der ce-Bibliothek; einziger Konsument `test_31_workload_matrix.cpp` → misst nichts, keine Binary. Widerspricht sich selbst (`:10-11,19`).

## D.2 Korrekte Verortung (E-konsistent)
- **Achse W (Workload YCSB A–F):** **E4-XML-Definition** (`<compile_dims><workloads>`) → gespeist an **E1-Laufzeit** (Lastprofil-Wertmenge, DynamicVariableNode). *Doppelnatur:* die Op-Mix-KLASSE ist per-Binary-Dim (compile_dims), die Seed/Ops-Instanz ist E1-Lastprofil (`drei_profile`: Build ⊥ Last).
- **Achse D (6 Datasets):** **E3-Permutations-Dimension** (CEB „4. Dim", `test_data_sets.xml`) bzw. E4-Auswahl je Messreihe; Daten liegen in `super/Code/test_data_xml/*.test_data.xml`.
- **Achse M (Mess-Kategorie):** **E0/Tooling** — compile-time-Modul-Interna von `measurement-all` (Option A OK), zusätzlich die Granularität Micro/Makro/Gesamt als **E4-Auswertungs-Dimension**. Reine Spalten-Projektion, **nie** `mp_product`-Lauffaktor.

## D.3 Konkrete Andockpunkte (verifiziert)
1. **`m3v2_study.profile.xml:127-131`** — `<compile_dims><workloads>A B C D E F` existiert = SOLL-Ort Achse W. **Fehlt:** `<datasets>` + Mess-Kategorie-Dim.
2. **`super/Code/experiment_config/config_b_cache_engine_perms.xml:17-20`** — Workloads-als-XML funktioniert bereits (Beweis).
3. **`super/Code/test_data_xml/messreihe_v32_schema.xsd:65-147`** (`TupelType`) — Dataset-Element (analog `op_type`-Enum `:76-87`) + Mess-Kategorie schema-seitig ergänzen.
4. **`super/Code/02_messung_driver/main.cpp:483`** hartkodiert `YcsbWorkload::C`; `load_messreihen:167-204` liest nur id/mode/profile → **durch XML-gelesene (Workload×Dataset)-Zellen ersetzen**; als DynamicVariableNode injizieren (Muster `profile_run_entry.hpp:132-134`).
5. **measurement-all:** `comdare-workloads` (baseline_2) trägt **schon** `enum YcsbWorkload{A..F}`; Dataset + Mess-Kategorie → noch **nicht angelegte** Stufe `3-analysis`. **Option A = Doku-25-Modul-Split** (Ledger:40), gated auf **Schritt 13** (`comdare-workloads/README:28-29`) — der Monolith bleibt bis dahin unangetastet.

## D.4 G2 — Revert der committeten Fehl-Bau-Commits
`88738285` (Bridges + `ycsb_profile_list`) + `4d8aedce` (`CanonicalDataset` + `mp_product`=36) per forward `git revert` (keine History-Rewrite). Regime-Idee als Referenz gesichert (`a219605`). *(G1 = uncommitteter Revert erledigt, ce sauber auf `2f20b8c1`.)* **User-Bedingung erfüllt:** die Architektur ist jetzt korrekt geplant.

---

# TEIL E — GEORDNETE ROADMAP (E4→E1, code-vor-Neubau-vor-Messung)

| Phase | Inhalt | Gate | Sofort? |
|---|---|---|---|
| **0 Konsolidierung** | Teil B umsetzen: E1–E4 autoritative Doku-Stelle · §10 rehabilitieren · E-A..E-E→DD-A..DD-E · S↔E-Kreuz-Map · `15_F7` neu fassen · WORKFLOW-4layer + STANDARDPROZESS andocken · Ledger-Nachzug additiv | — | **JA** |
| **0.5 G2** | Revert `88738285`+`4d8aedce`; CI grün prod1 | golden-Roundtrip==320 | **JA** |
| **4 / #31** | E4-XML: `<datasets>`+`<measurement_categories>` in XSD + `m3v2`; Parser+Treiber (XML statt hartkodiert); DynamicVariableNode-Injektion; measurement-all-Vokabular gated | XML-only-Nachweis | **JA (non-gated Kern)** |
| **1 / #188** | E2-Wurzel finalisieren (honest-0-Design/Store-Backing); stale `search_organ_`-Kommentare; #211/#213/#214 Ledger-Nachtrag | ctest | Increment |
| **2 / #221** | E1: 4 fehlende RC-Setter + apply1 + hw_prefetcher-POD/MSR — **Hard-Gate vor #156** | RC-Konsum-Test | Increment |
| **3 / #223** | E3-Gate nach Recompile re-verifizieren (Einzeldatei-Grep!) | Gate-Regression | Increment |
| **5 / #215** | 320-DLL-Neubau (Wirksamkeit) — nach P1/P2 (Code) UND P4 (XML) | Pipeline 286 | **gated/mehrtägig** |
| **6 / #156/#162** | XML-getriebener Voll-Messlauf; dann #165/#226/#152/#187/#163 | Cluster-Fenster | **HELD** |

**Sofort-Block (dieser Plan-GO):** Phase 0 → 0.5 → 4/#31. Die E2/E1-Wurzeln (1/2) sind der nächste große ce-Increment.

---

# TEIL F — KADENZ · DIREKTIVEN · GATES · TABUS (Goal-V3)

- **Metaprogrammierung:** compile-time only im Hot-Path (Templates/`if constexpr`/Concepts/CRTP), kein Runtime-Switch/vtable; Guards `test_striktheit_*` als Regression. E2-Achsen bleiben compile-time; W/D **bewusst** runtime (E4/E1/E3) — die *korrekte* Metaprog-Grenze, nicht die verletzte.
- **Modulreferenzierung:** Baseline-Layering in Stein (`n→n-1`); measurement-all-Vokabular gated hinter Doku-25-Schritt 13; WAS/WIE-Trennung (ce = Framework, super = Definition, `STRUCTURAL_CORRECTION_diplomarbeit.md`).
- **TABU:** `permutation_axes.xml`, `golden_fullpilot_320_binary_ids.txt`, POD `sizeof==1416`, conformance-Oracle, `GenusBindingTraits` — unberührt; ABI-MAJOR==4, kein Bump ohne GO.
- **Verifikations-Kadenz je Increment:** Ist-Verifikation (git beide Remotes) → fresh-context-Kartierung datei:zeile → manuelle Umsetzung (Codex nur Erstimpl; auf prod1 bwrap defekt → code-reviewer-Fallback) → VOLL-REVIEW → Mojibake-grep `'Ã|â€'==0` → clang-format 22.1.8 dry-run==0 → **doppelt-literal** (g++-16-Build + eigener Lauf) → golden-Roundtrip==320 wo berührt → granularer Commit (nie `git add -A`) → beide Remotes → CI STRIKT GRÜN vor nächster Aufgabe.
- **Workflow-Backups:** jeder Lauf → Rohdaten+Synthese ins super-`docs/sessions/backups/` (fortlaufend, User-Auftrag).

---

# TEIL G — VERIFIKATION

- **Phase 0:** Doku-Konsistenz — E1–E4 an einer autoritativen Stelle; jede Nachzieh-Zeile additiv gesetzt; „E-"-Namespace kollisionsfrei (grep). Ledger/Task-Board spiegeln E-Wahrheit.
- **Phase 0.5 (G2):** ce baut, `test_31` entfällt, golden-Roundtrip==320 **literal**, CI grün prod1.
- **Phase 4 (#31 = das Abnahmekriterium):** **ein Experiment lässt sich allein durch XML-Änderung definieren** (Workload+Dataset+Kategorie) → `messung_driver` liest sie (kein hartkodierter Default) → CSV trägt die gewählten Workloads/Datasets → Heatmap-`.tex`. Unit-Test XML-Parse→Spec→DynamicVariableNode. = **XML-only-Teilschritt (#229)**.
- **Phase 1–3:** ctest je Fix + `#221`-RC-Konsum (4 Setter) + `#223`-Gate-Regression, alles literal.
- **Phase 5/6:** gated — Grün-Beleg via Pipeline 286 nach Cluster-Fenster.

---

# TEIL H — WAS DER PLAN-GO GENEHMIGT

- **JA (non-gated, Sofort-Block):** Phase 0 (E1–E4-Konsolidierung + Bruch-Nachzug + Namenskollisions-Auflösung + F7-Neufassung), Phase 0.5 (**G2**-Revert), Phase 4/#31 (E4-XML-Definition + Treiber-Verdrahtung; measurement-all-Vokabular gated).
- **Roadmap (je eigener Increment/Freigabe):** #188, #221, #223, #215 (gated), #156/#162 (HELD).
- **Offener Design-Fork zur Bestätigung:** **V32-Schema aktivieren** (`COMDARE_V32_ENABLE`, reicher `TupelType`, löst #229 strukturell — empfohlen) **vs.** produktives `comdare_experiment`-Schema minimal um `<datasets>/<measurement_categories>` erweitern (kleiner, aber zwei Schema-Welten bleiben). Empfehlung: **V32 aktivieren.**

*Nach Freigabe wird dieses Dossier als autoritative E1–E4-Konsolidierungs-Doku ins super-Repo committet (docs/architektur/) und der Ledger additiv nachgezogen.*
