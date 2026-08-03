# A16-P1-DOSSIER — E-24 Container-Gattungs-ABI: LETZTER ABI-Schritt vor dem Voll-Bau-4-Trigger

**Datum:** 02.08.2026 (abends) · **Agent:** Design (Fable 5 xhigh, ultracode) · **Status:** DOSSIER, read-only erstellt — kein Code, kein Commit, keine Datei geschrieben.
**Paket:** A16-P1 (KATALOG A16 / Owner-R7 02.08.: "E-24, E-19, E-02, E-23, E-21 sind jetzt PFLICHT") · **Gate-Einordnung:** GATE 4 der Gate-Kette (00-SYNTHESE:226), LETZTER ABI-Schritt VOR dem Trigger (HY-D2-Merksatz bindend).
**Pfad-Konvention:** super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` · ce = `super/Code/external/comdare-cache-engine` · LEDGER = `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` · ANKER = `super/docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md`. ASCII-Transliteration durchgehend.

**Quellen (Pflicht-Lektuere, live gelesen 02.08.):**
1. `super/docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md` (A16 = :32, Owner-H.7 = :111)
2. `super/docs/sessions/20260802-BAUPLAN-owner-entscheide-synthese-kritischer-pfad.md` (§0 = :8, A16-Auflagen = :26, Q5 = :51, Zeitachse = :33-43)
3. `ce/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (HY-D2; E-24-Sequenz = :280-283, Risiko ABI-Major-Drift = :413)
4. LEDGER (E-24-/Gattungs-Stellen: :136, :516, :1576-1581, :1679, :2769-2771, :2784, :2828, :2858)
5. `super/docs/sessions/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md` (Abschnitt 4 GATE 4 = :226, GATE 5 = :228, kritischer Pfad = :209; Abschnitt 5 Nr. 7 = :256, Nr. 3 = :252)
6. `super/docs/sessions/backups/20260802-design-owner-entscheide-workflows/A16-e-buendel.md` (Design-Strang + adversariale Review, Verdikt NACHBESSERN; Review-Korrekturen = bindende Auflagen)
7. ANKER:115-118 (E-24-Owner-Wortlaut) · `super/docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:19` (R7 verbatim)
8. ce-Ist (live, development-Arbeitsstand): `pruef_dock.hpp`, `genus_binding_traits.hpp`, `abi_adapter.hpp`, `anatomy_base.hpp`, `container_framework.hpp`, `anatomy_module_abi_v1_decl.hpp`, `anatomy_module_loader.hpp`, `pruef_dock_registry.hpp`, `pruef_dock_sequencer.hpp`, `set_*/sequence_*/adapter_*/view_*`-Familien.

---

## 0. Executive Summary

E-24 = Vervollstaendigung der Gattungen SearchAlgorithm + Container als **der LETZTE ABI-Schritt des Projekts** (Owner-Wortlaut ANKER:115-118: "diese Gattung als ABI-Schritt als LETZTEN Schritt mit eigener ultracode-Planung anhaengen und mit der Vervollstaendigung der Gattung SearchAlgorithm und Container erweitern ... bei weitem nicht erfuellt, gigantische Erweiterung ueber parallele Achsensysteme weiterer Gattungen").

Die **harte Kante aus HY-D2** (ce `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:280-283`, Risiko-Tabelle :413) verlegt das Fenster ZWINGEND VOR den Voll-Bau-4-Trigger: bumpt der ABI-Major erst NACH dem Voll-Bau, laedt die Hybrid-Stufe (und jeder neu gebaute Host) die eingelagerten 2^17-Binaries nicht mehr (Major-Check des Loaders, `anatomy_module_loader.hpp:149`) = Neubau ALLER Binaries — exakt der von Owner-E3 ausgeschlossene Zustand. Der Major ist dabei **Owner-fixiert**: F1b-Ebene-1-Promotion = "ABI/golden-GO GEWAEHRT (MAJOR)", "UNVERHANDELBAR" (LEDGER:1576-1581, User-Entscheid 16.07.).

Das Fenster ist **EIN S12-Fenster ohne stillen Split** (Bauplan:26, Review-MAJOR aus A16-e-buendel.md): Cross-Genus-Komposition-als-Sub-Organ via `OrganConcept` GEHOERT HINEIN (LEDGER:2771/:2828/:2858); "Rest" in Owner-R7 = die nicht-gelisteten E-Punkte, NICHT E-24-Teile. Graph-Gattung bleibt draussen (nach Abgabe, eigener Owner-Entscheid, Q5-Default per Owner-GO ~17:4x freigegeben).

**Sequenz-Empfehlung V3 (Abschnitt 3): Option C** — E-24 als EIGENES, sauber reviewbares Bau-Paket UNMITTELBAR HINTER A13-M3(+W10), aber innerhalb EINES gemeinsamen Neuanker-VOLLZUGS (A13-M4-Contract-Bump, TP1-Neu-Inventarisierung, A2-Eichung erst NACH E-24-Landung). Ein wirksames Neuanker-Ereignis, zwei getrennt reviewbare Fenster-Waggons.

---

## 1. Ist-Kartierung Gattungs-ABI (datei:zeile, live verifiziert 02.08.)

### 1.1 Zwei-Ebenen-Modell (Ebene 1 Gattung / Ebene 2 Genus)

| Anker | Datei:Zeile (ce) | Inhalt |
|---|---|---|
| Ebene-1-Enum | `libs/cache_engine/anatomy/anatomy_base.hpp:40-44` | `AnatomyGattung{SearchAlgorithm=0, Container=1, Graph=2}` — "NUR 3", Aussen-Interface, Pruef-Dock je Gattung |
| Ebene-2-Enum | dieselbe Datei `:78-84` | `AnatomyGenus{SearchAlgorithm=0, Set=1, Sequence=2, Adapter=3, View=4}` — Tier-Unterklassen |
| Mapping | `:100-109` | `gattung_of()`: SA -> eigene Gattung; Set/Sequence/Adapter/View -> Container |
| F1b-Vermerk | `:76-77` | "eigenstaendige AnatomyGattung ist der SEPARATE, koordinierte ABI-Schritt F1b (NICHT hier)" — Promotion unvollzogen |
| Kanon | LEDGER §54-T1 (00-SYNTHESE:32) | "Gattung" bezeichnet AUSSCHLIESSLICH das Tier-Binary-INTERFACE; KEINE Achsen-Gattungen |

### 1.2 Bau-Bindung (GenusBindingTraits) — 5/5 gebunden, Tiefe stark asymmetrisch

| Genus | `libs/cache_engine/builder/experiment_tree/genus_binding_traits.hpp` | Slots | Besonderheit |
|---|---|---|---|
| (primaer) | `:31-32` | — | Primaer-Template UNDEFINIERT; jede Gattung liefert Voll-Spezialisierung |
| SearchAlgorithm | `:41-59` | 18 (`:45`) | EINZIGE am zentralen `kCompositionAxisNames` (`:56-58`); T0..T17 inkl. persistence_target |
| Adapter | `:66-87` | 11 (`:70`) | `:69` traegt ZUSAETZLICH `gattung = AnatomyGattung::Container` (einziger Trait mit Ebene-1-Feld); eigene Namensliste `:81-86` |
| Set | `:92-114` | 13 (`:95`) | eigene Namensliste `:106-113` |
| Sequence | `:119-139` | 9 (`:122`) | eigene Namensliste `:133-138` |
| View | `:144-163` | 5 (`:147`) | eigene Namensliste `:158-162` |
| Concept | `:167-171` | — | `GenusBound<G>` — alle 5 erfuellt (Kommentar `:166`: "5/5") |
| TABU Q-8 | `:37-40` | — | persistence_target NICHT auf Container-Genera ausgedehnt — Owner-Entscheid Q-8 (26.07.), Aenderung braucht NEUEN Owner-Entscheid |

### 1.3 Container-Framework (Ebene-1-Sicht, heute Re-Export)

| Anker | `libs/cache_engine/anatomy/container_framework.hpp` | Inhalt |
|---|---|---|
| #29-ENTPARKT | `:20-25` | F1b per User-GO 16.07. FREIGEGEBEN; Umsetzung = "KOORDINIERTER ABI-Schritt (Version 4->5, gemeinsam mit #37 nach F12iii)" — historische Major-Zaehlung, heute 7->8 |
| ContainerType | `:46` | Concept: `gattung_of(G)==Container && GenusBound<G>` |
| Self-proving | `:85-95` | static_asserts: type_count==4; Adapter/Set/Sequence/View sind Container-Typen, SA NICHT; Slot-Zaehlungen 11/13/9 gepinnt |
| Genus->Typ | `:17-19` | "echte Genus->Typ-UMSTRUKTURIERUNG ... waere ABI/golden-beruehrend" — der S12.3-Fenster-Inhalt (Option A/B, LEDGER:2858) |

### 1.4 ABI-Flaeche (Decl, Modul-Makros, Adapter, Antriebs-Sub-Interfaces)

| Anker | Datei:Zeile (ce) | Inhalt |
|---|---|---|
| ABI-Major/Minor | `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:62-63` | `COMDARE_ANATOMY_ABI_MAJOR 7` / `MINOR 0` |
| ABI-Magic | `:66` | `0x434F4D444141372E` (".A7.") — Magic kodiert den Major (`:59`) |
| Host-Version | `:264` | `kHostAnatomyAbiVersion{MAJOR, MINOR}` |
| **+ceb=-Kopplung** | `:270-282` | `kCebContractVersion{COMDARE_ANATOMY_ABI_MAJOR, kCebContractCodegenMinor}` — **ein Major-Bump verschiebt AUTOMATISCH das `+ceb=`-Suffix aller build_version-Strings = Lager-Key-Shift** (Identitaets-Bilanz Abschnitt 2.6) |
| SA-Modul-Makro | `abi/anatomy_module_abi_v1.hpp:35` | `COMDARE_DEFINE_ANATOMY_MODULE` (4 Pflicht-extern-C-Symbole) |
| Set-Modul-Makro | `abi/set_module_abi_v1.hpp:10-11` | `COMDARE_DEFINE_SET_MODULE` — "4 extern-C-Symbole + ABI-Version/Magic IDENTISCH -> DERSELBE Loader" |
| weitere Makros | `abi/adapter_module_abi_v1.hpp:4`, `abi/sequence_module_abi_v1.hpp`, `abi/view_module_abi_v1.hpp` | analoge Familie — Modul-Autor-Seite existiert fuer ALLE 5 Genera |
| SA-ABI-Adapter | `libs/cache_engine/anatomy/abi_adapter.hpp:39-52` | SearchAlgorithmAbiAdapter, god-header ~1805 Z., VOLLE Sub-Interface-Matrix (IObservableTier/IRollbackable/IScannable/IMigratable/IResourceControllable/IAllocatorProxy/IMeasurableWorkload) |
| Set-ABI-Adapter | `anatomy/set_abi_adapter.hpp:18-21` | `SetAbiAdapter final : IAnatomyBase, ISetTier` + `static_assert(genus()==Set)` (Cross-Genus type-unmoeglich) |
| weitere Adapter | `anatomy/sequence_abi_adapter.hpp`, `anatomy/adapter_abi_adapter.hpp`, `anatomy/view_abi_adapter.hpp` | analog, je Genus |
| Antriebs-Sub-Interfaces | `anatomy/set_tier.hpp` (ISetTier + SetObserverSnapshotV1), `anatomy/sequence_tier.hpp`, `anatomy/adapter_tier.hpp`, `anatomy/view_tier.hpp`; SA: `anatomy/observable_tier.hpp:185/:193` | je Genus eigenes natives Sub-Interface vorhanden (F1a-Beleg LEDGER:516: Set = vollwertige native Tier-Unterklasse, kein Alias) |
| Loader | `builder/anatomy_module_loader/anatomy_module_loader.hpp:70-75` (destroy-vor-dlclose), `:149` ("5. Major-Version match (Host vs Modul)"), `:158-159` (platform_suffix, .dylib bekannt) | EIN gattungs-agnostischer Loader; der Major-Check ist der Mechanismus der HY-D2-Kante |

### 1.5 Docks / Registry / Sequencer / Engines / Observer

| Anker | Datei:Zeile (ce) | Ist |
|---|---|---|
| Dock-Doktrin | `builder/pruef_dock/pruef_dock.hpp:10-14` | IPruefDock KEINE ABI-Grenze; Grenze = gattungs-eigenes Antriebs-Sub-Interface + flacher POD; "Neue Gattung = neues Dock + neues Sub-Interface + neuer flacher POD — NIE Mutation von IAnatomyBase oder bestehendem Snapshot" |
| IPruefDock | `:57-79` | `:62` dock_genus, `:69` accepts ueber IM MODUL deklarierte Gattung, `:74-79` measure + **V5-Konformitaets-Gate-VERTRAG** (Orakel-Pruefung VOR Messung, Pflicht jeder Implementierung) — HY-D2-Freeze (NICHT-Kandidat §75) |
| SA-Dock | `builder/pruef_dock/search_algorithm_dock.hpp:26` | `SearchAlgorithmDock final : IPruefDock` — produktiv (DLL-Pfad, Drive `:65-86`) |
| Container-Docks | `set_dock.hpp:8/:24`, `adapter_dock.hpp:8`, `sequence_dock.hpp`, `view_dock.hpp` | existieren NUR als in-process-Templates ueber die Anatomie; wortlautlich: "Der DLL-Pfad (AnatomyModuleLoader, analog BR-4 + IPruefDock+AnatomyModuleHandle) ist ein Folgeschritt" — KEINE IPruefDock-Implementierungen, kein Konformitaets-Gate, keine Registry-Faehigkeit |
| Registry | `builder/pruef_dock/pruef_dock_registry.hpp:4` (stale: "initial nur SearchAlgorithmDock; Set/Sequence/Adapter/View kommen mit V42"), `:22-40` | EIN Dock je Gattung; `register_dock` hat **0 produktive Aufrufer in libs/ + tools/** (grep-belegt; Registrierungs-Ort verifizieren, Offener Punkt 4) |
| Sequencer | `builder/pruef_dock/pruef_dock_sequencer.hpp:44-47` | `measure_genus_sequential` — bereits gattungs-uebergreifend gebaut (sortiert Handles nach Modul-Gattung) |
| Engines | `anatomy/search_algorithm_permutation_engine.hpp:185` `for_each_abi_adapter` | NUR SA; `set_/sequence_/view_permutation_engine.hpp` existieren OHNE for_each_abi_adapter (grep: 0 Treffer ausserhalb SA); **eine Adapter-Permutation-Engine-Datei existiert NICHT** |
| Observer | `anatomy/observer_aggregate.hpp:2/:79` (per-Achse-Aggregat, SA; Kommentar "17-Achsen" stale ggue. ORG-18) vs. flache Hand-PODs der Container-Genera (SetObserverSnapshot/SetObserverSnapshotV1 u.a.) | LEDGER:2771: SA treibt 9 reale Organe + per-Achse-ABI-POD; Set/Sequence/Adapter/View treiben je NUR 1 Organ, Observer = flacher Hand-POD |
| Cross-Genus | `anatomy/pruefling_merge.hpp:1-16` (PrueflingSlot, 3 kompositionale Joins — PRT-ART-Naht); **`OrganConcept` = 0 Treffer** als gemeinsames Concept (nur unverwandte `axes/lookup/composable/eytzinger_layout_pool_concept.hpp` u.a.); `organ_concept.hpp` existiert NICHT | Cross-Genus-JOIN type-unmoeglich (static_asserts in allen Adaptern); Komposition-als-Sub-Organ UNGEBAUT |
| Tests (Basis) | `tests/unit/test_genus_binding.cpp`, `tests/unit/test_abi_adapter_g3_batch2.cpp` | Regression-Basis des Fensters (Waisen-TU-Falle beachten) |

### 1.6 Fehlstellen-Bilanz = der E-24-Restumfang

1. `OrganConcept` (gemeinsame Op-Schnittstelle + ObservableAxis/statistics) fehlt vollstaendig.
2. Cross-Genus-Komposition-als-Sub-Organ ungebaut (`node_type` <- Sequence/Adapter, `index_organization` <- Set, `queuing` <- Adapter; LEDGER:2771).
3. Produktionstiefe der 4 Container-Genera: reale Organ-Member + observe-Verdrahtung + `XxxObserverAggregate<N>` (per-Achse) statt flacher Hand-PODs.
4. Docks Set/Sequence/Adapter/View: IPruefDock-Implementierung + DLL-Pfad + Konformitaets-Gate + Registry-Registrierung.
5. `for_each_abi_adapter` in den Container-Permutation-Engines; Adapter-Engine-Frage klaeren.
6. `XxxExecutionContext` je Genus.
7. F1b-Ebene-1-Promotion (Genus->Typ-ABI, S12.3, Owner-MAJOR) + comdare::container-Kopf-Framework (LEDGER:2858).
8. F2 native Set-ABI-V2 (extract/merge/set-ops, append-only; V1 existiert).
9. Gate-/Ledger-Verankerung: E-24 fehlte "in jeder Gate-Reihenfolge" (KATALOG G.1) — seit 00-SYNTHESE:226 als GATE 4 verankert; LEDGER-A11-Zeile noch offen.

---

## 2. Soll-Schnitt E-24 — EIN S12-Fenster, kein stiller Split

### 2.1 Autoritaets-Kette

- Owner-Wortlaut ANKER:115-118 (letzter ABI-Schritt, eigene ultracode-Planung, Vervollstaendigung SA+Container, "gigantische Erweiterung ueber parallele Achsensysteme").
- Owner-R7 02.08. (`20260802-OWNER-...md:19`): E-24 JETZT PFLICHT; "Rest nach der Abgabe auch PFLICHT" — "Rest" = nicht-gelistete E-Punkte (Review-Klaerung, Bauplan:26 bindend).
- LEDGER:2771 (§52-B2 BAUPLAN: OrganConcept + Komposition + je-Genus-Bauliste), :2784 (S12.1 -> S12.2 -> S12.3), :2828 (§55: 5 Genera = LETZTER ABI-Schritt S12), :2858 (offene-Punkte-Zeile inkl. Kopf-Framework + Option A/B), :1576-1581 (F1b = MAJOR, UNVERHANDELBAR), :136/:1679 (das EINE koordinierte ABI-Fenster: F1b+F2+#37).
- HY-D2 :280-283/:413: E-24 MUSS VOR dem Trigger liegen; die Hybrid-Stufe fordert KEINEN eigenen ABI-Schritt und erbt den finalen Major.
- 00-SYNTHESE:209/:226/:228: kritischer Pfad OS-U -> A13 -> W10 -> **E-24 (GATE 4)** -> A2 (GATE 5, einmalige Eichung NACH A13/E-24).

### 2.2 Fenster-Inhalt (verbindlich, EIN Fenster)

**S12.1 — OrganConcept** (neuer Header `ce libs/cache_engine/anatomy/organ_concept.hpp`): gemeinsame Op-Schnittstelle + ObservableAxis-/statistics-Forwarding (Memory-Kanon: Observable-Wrapper MUSS Concept-Member forwarden), CRTP+Concept-Muster, CT-statisch/zero-cost/dispatch-frei. SAs gehaltener Organ-Slot nimmt generisch ein beliebiges Genus-Organ auf.

**S12.2 — je Genus auf Produktionstiefe** (Set 13 / Sequence 9 / Adapter 11 / View 5, Schema-treu nach SearchAlgorithm; Haupt=Struktur/Identitaet gehalten, Unter=Verhalten/Ressourcen delegiert, LEDGER:2771):
(a) Anatomie haelt Haupt-Achsen als reale Organ-Member + observe-Verdrahtung; (b) `XxxObserverAggregate<N>` per-Achse ersetzt flachen Hand-POD (Wire-PODs append-only bzw. neue V2-Layouts NUR im Fenster); (c) `for_each_abi_adapter` in den Permutation-Engines (+ Adapter-Engine-Klaerung); (d) ABI-Adapter + Docks produktionsreif: IPruefDock-Implementierung, DLL-Pfad ueber denselben Loader, je Genus benanntes Konformitaets-Orakel (V5-Vertrag `pruef_dock.hpp:74-79`), Registry-Registrierung (+ stale Kommentar `pruef_dock_registry.hpp:4` nachziehen); (e) `XxxExecutionContext` je Genus.

**S12.3 — Genus->Typ-ABI (F1b-Promotion + Kopf-Framework):** Ebene-1-Gattung ABI-sichtbar, Ziel-Topologie als BENANNTER Fenster-Entscheid (Option A: Genera bleiben, Gattung wird ABI-Flaeche; Option B: Set/Sequence als Typen unter Container — `container_framework.hpp:17-19`, LEDGER:2858 "Option A/B Container-Typ"); comdare::container-Kopf-Framework (Kopf-Framework-Doktrin je Ebene-1-Gattung). Owner-fixiert: das ist der MAJOR (LEDGER:1576-1581).

**F2 — native Set-ABI-V2** append-only (extract/merge/set-ops) auf ISetTier/SetObserverSnapshotV1.

**#37-Scheduling-CT:** laut LEDGER:136/:1679 Fenster-Bestandteil; Ist-Stand ist zu pruefen (moeglich bereits ueber die O-8-/ORG-18-Strecke gelandet) — Offener Punkt 1, VOR dem Fenster-Bauplan klaeren, kein stiller Doppelbau.

**Cross-Genus-Komposition-als-Sub-Organ (IM Fenster, Review-MAJOR):** `node_type` <- Sequence/Adapter, `index_organization` <- Set, `queuing` <- Adapter — via OrganConcept; Cross-Genus-JOIN bleibt type-unmoeglich (static_asserts bleiben bestehen). KEIN Verschieben "nach Abgabe" — das waere der verbotene stille Split (A16-e-buendel.md REVIEW, Bauplan:26).

### 2.3 NICHT im Fenster

- **Graph-Gattung:** nach Abgabe, eigener Owner-Entscheid (Q5-Default, per Owner-GO ~17:4x freigegeben; Einspruch jederzeit moeglich). Der `AnatomyGattung::Graph`-Enumerator (`anatomy_base.hpp:43`) bleibt UNANGETASTET (kein Append, kein Reorder). Aufloesung des E.10-Scheinwiderspruchs: "LETZTER ABI-Schritt" ist auf die Mess-Kampagne gescoped (vom Fenster bis zur Abgabe KEIN ABI-Touch); Graph nach Abgabe ist ein NEUES, eigenes user-gated Fenster ausserhalb dieses Scopes.
- **Stempel-Semantik:** E-24 fuehrt KEINEN zweiten Stempel-Bruch ein ("Input A13"-Default, Bauplan:26); merge-Zeilen-/Meta-Meta-/Klammer-Themen sind A13-Territorium.
- **TABUs:** `kCompositionAxisNames`/18-Slot-SA-Pfad; persistence_target-Disjunktheit (Q-8, `genus_binding_traits.hpp:37-40`); golden_fullpilot_320-Byte-Wache; `permutation_axes.xml`; `m3v2_study.profile.xml`; CRC-Anker; Anatomie-Enum-Reihenfolge. GenusBindingTraits ist Wachen-Klasse — Beruehrung NUR im koordinierten Fenster mit GO (genau dieses Fenster IST das GO-Fenster, aber nur fuer die im Fenster-Bauplan gelisteten Aenderungen).

### 2.4 M0-Vorstufe (ABI-neutral, sofort baubar, VOR dem Fenster)

`organ_concept.hpp` + NUR beweisbare static_asserts (SA erfuellt OrganConcept; ContainerType-Genera erfuellen die statistics/value_type-Teilmenge). Luecken der 4 duennen Genera als Dossier-/Kommentar-Abschnitt, NICHT als brechender Assert (Review-MEDIUM-Korrektur). Byte-/golden-/ABI-Neutralitaet literal beweisen (Registry-sha identisch, ctest N unveraendert, golden-320-Wache gruen).

### 2.5 Reihenfolge der Planung

Dossier VOR Code (Owner-Auflage "eigene ultracode-Planung", ANKER:115). Dieses P1-Dossier ist die Verankerung; der FENSTER-BAUPLAN (Detail-Schnitt je Genus, Commit-Zug, Orakel-Definitionen, Migrationsliste) ist eine eigene ultracode-Planungssession unmittelbar vor dem Bau, mit dem gelandeten A13-M3-Layout als fixem Input.

### 2.6 Identitaets-/Neuanker-Bilanz (zwei verschiedene Identitaets-Ebenen — nicht vermengen)

- **A13-M3(+W10)** verschiebt die STEMPEL-Ebene: POD 136->120 (v6), Fingerprint-Preimage, v1.0.0c-Migration, Zellwerte. B3-Frozen-Neueinfrieren in EINEM Commit ist M3-Auflage.
- **E-24** verschiebt die ABI-/LAGER-KEY-Ebene: Major 7->8 (Magic .A7.->.A8.), und via `anatomy_module_abi_v1_decl.hpp:282` (`kCebContractVersion` koppelt an `COMDARE_ANATOMY_ABI_MAJOR`) automatisch das `+ceb=`-Suffix ALLER build_version-Strings = Lager-Key-Shift. Die SA-Stempel-Zeilen und das A13-Layout bleiben unberuehrt (Auflage 6).
- **golden-neutral im Katalog-Sinn:** binary_id = reiner 18-Organ-Pfad der SA-Gattung — E-24 aendert weder Katalog noch CRC64-Anker `0x56F1B721C72DC10E` noch die golden-320-Byte-Wache. Neuanker betrifft NUR ABI-Freezes (additives `_abi7`-Einfrieren analog `_abi4/5/6`), Loader-Referenzen, `+ceb=`-Suffix-Erwartungen und die TP1-Lager-Proben-Inventur. Gemaess 00-SYNTHESE:252 (Nr. 3) ist die golden-Neutralitaets-/Bruch-Bilanz bei E-24 SAUBER AUSZUWEISEN (nicht nur behaupten).
- **Konsequenz fuer die Sequenz:** Werden M3-Fenster und E-24-Fenster mit JE EIGENEM Anker-Vollzug gefahren, entstehen zwei Neuanker-Ereignisse (doppelte TP1-Proben-Inventur, doppelte Freeze-/Wachen-Neueichung) — dagegen richtet sich die Ein-Fenster-Doktrin (00-SYNTHESE:256). Das ist der Kern der V3-Frage.

---

## 3. SEQUENZ-EMPFEHLUNG V3 — E-24 relativ zu A13-M3

**Entscheid-Typ:** Manager-Entscheid (GATE 4, 00-SYNTHESE:226: "Sequenz relativ zu M3 als Manager-Entscheid, HY-D2-Merksatz bindend"), owner-sichtbar per V7.6-Verbose-Vorlage (siehe entscheidungs_vorlagen).

### 3.1 Optionen

- **Option A — Voll-Fusion:** E-24 wird IN das A13-M3-Fenster gefaltet (ein Commit-Zug M3+W10+E-24+M4, ein Review-Durchgang, ein Anker-Vollzug).
- **Option B — zwei getrennte Fenster:** M3(+W10)+M4 landet komplett inkl. Anker-Vollzug (TP1-Inventur, Eichungen); E-24 folgt als eigenes Fenster mit ZWEITEM Anker-Vollzug; A2 danach.
- **Option C — gekoppelte Serie, EIN Anker-Vollzug (EMPFEHLUNG):** M3(+W10) und E-24 sind ZWEI getrennte Bau-Pakete (je eigener Branch/Worktree, je eigene Dual-Review Fable+Codex, je eigener CI-Beleg), landen in UNMITTELBARER Folge; die teuren Anker-Vollzuege laufen EINMAL nach der E-24-Landung: (i) A13-M4 (CEB-Contract-Minor 0->1 + Voll-Verifikation) wandert ANS ENDE hinter E-24 — dadurch genau EIN `+ceb=`-Shift (7.0 -> 8.1) statt zwei (7.0 -> 7.1 -> 8.x); (ii) TP1-Lager-Proben-Neu-Inventarisierung einmalig; (iii) A2-SHA512-Eichung einmalig (GATE 5 unveraendert). B3-Frozen-Neueinfrieren bleibt M3-Auflage (Stempel-Ebene, von E-24 nicht beruehrt). Zwischen M3-Landung und E-24-Landung: KEIN Trigger, KEIN Lager-Voll-Einlagerungslauf, keine schweren Parallel-Jobs.

### 3.2 Risiko-Matrix

| # | Risiko / Kriterium | A: Voll-Fusion | B: zwei Fenster | C: gekoppelte Serie (Empf.) |
|---|---|---|---|---|
| 1 | Zahl wirksamer Neuanker-Ereignisse (TP1-Inventur, Eichungen, `+ceb=`-Shifts) | 1 (gut) | 2 (verletzt Ein-Fenster-Doktrin, 00-SYNTHESE:256) | 1 (gut; per M4-Verschiebung auch nur EIN `+ceb=`-Shift) |
| 2 | Review-/Bisektions-Qualitaet (Dual-Review je Landung, Fehlersuche bei CI-Rot) | SCHLECHT: Mammut-Diff ueber zwei Identitaets-Ebenen (Stempel + ABI), Bisektion praktisch unmoeglich | gut | gut (zwei saubere Pakete) |
| 3 | Schichten-Reinheit ("E-Schichten separat fertigstellen"; M3=Stempel-Schicht, E-24=ABI-Schicht mit VERSCHIEDENEN Wachen: Layout==6 vs. Loader/Dock-Konformitaet) | verletzt | erfuellt | erfuellt |
| 4 | Trigger-Termin Do 07.08. (Verzugs-Kopplung) | HOCH: E-24-Verzug (L/XL-Paket!) blockiert auch die M3-Landung und damit W10/A2-Vorbereitung | mittel | mittel-niedrig: M3 landet frueh und unabhaengig; E-24-Verzug verschiebt nur Anker-Vollzug+A2 |
| 5 | M3-Auflagen-Konformitaet (Codex-Zweitreview VOR M3, B3-Frozen in EINEM Commit, Migration+ENFORCE=1 im selben Commit) | gefaehrdet (Auflagen-Set von M3 vermischt sich mit E-24-Gates) | erfuellt | erfuellt |
| 6 | Zwischenzustand-Risiko (Fenster offen, Baum "zwischen den Ankern") | keins | keins | begrenzt: zwischen M3- und E-24-Landung ist der TP1-Proben-Bestand einmal un-inventarisiert — mitigiert durch Verbot von Trigger/Einlagerungslauf im Zwischenfenster (3.1-C) |
| 7 | Doktrin "Ein-Fenster" formal | erfuellt | verletzt | der WIRKUNG nach erfuellt; Abweichung vom Bauplan-GATE-2-Wortlaut (M4 direkt nach M3) wird BENANNT dokumentiert, kein stiller Umbau |
| 8 | Arbeitsteilung v2.1 (Codex = schwere Logik; M3 UND E-24 sind je Codex-Klasse) | ein Riesen-Auftrag, Spend-Limit-Risiko konzentriert | zwei Auftraege | zwei Auftraege, pipelinebar (E-24-Fenster-Bauplan parallel zur M3-Landung erstellen) |

### 3.3 Empfehlung und Begruendung

**Option C.** Sie vereint das einzige harte Argument fuer A (EIN Neuanker-Ereignis, EIN `+ceb=`-Shift) mit den Qualitaets-Argumenten fuer B (getrennte Reviews, getrennte Wachen-Klassen, Bisektion, M3-Auflagen unversehrt, geringste Trigger-Terminkopplung). Der einzige Mehrpreis von C ist das kontrollierte Zwischenfenster (Zeile 6), das durch die stehenden Verbote (kein Trigger, kein Einlagerungslauf) abgedichtet ist. Option A scheitert praktisch an der Groesse: A13-M3 ist L (Codex-Klasse mit Zweitreview-Gate) und der E-24-Vollausbau ist ehrlich L/XL ("gigantische Erweiterung", ANKER:117) — ein fusioniertes Fenster waere das groesste Einzel-Diff des Projekts und wuerde die Dual-Review-Doktrin faktisch entwerten. Option B erzeugt ohne Not ein zweites Neuanker-Ereignis und widerspricht der Ein-Fenster-Doktrin.

**Zeitachsen-Wirkung (ehrlich):** Der Bauplan terminiert bisher NUR das A16-P1-Dossier (Mi 06.08.) — ein Bau-Slot fuer das E-24-Fenster fehlt, obwohl GATE 4 vor GATE 5 (A2, bisher Di 05.08.) liegt. Mit C: So 03. M0 + E-24-Fenster-Bauplan (ultracode) parallel zu M2 · Mo 04. M3(+W10) landet · Di 05.-Mi 06. E-24-Fenster-Bau (Codex) + Dual-Review · Mi 06. spaet: M4 + Anker-Vollzug + A2-Eichung · Do 07. J-Kette/heavy/Kalibrierlauf/Trigger. A2 rueckt von Di auf Mi; Beweise 1-5/12-Perm laufen parallel in den Nebenspuren. Das Fenster ist voll; E-24 ist ab jetzt DER kritische Pfad zum Trigger — Verzug verschiebt den Trigger-Tag Richtung Fr 08.08. (Reserve). Per Owner-R9 ("ALLES genannte wird voll gebaut") ist Scope-Reduktion KEINE Option; nur die Reserve-Nutzung ist der Puffer.

**Default:** Option C gilt, wenn kein Einspruch erfolgt (Vorlage V3 unten). Umkehrbarkeit: bis M3-Landung frei (A noch moeglich); danach nur noch B vs. C; nach E-24-Landung gegenstandslos.

---

## 4. Auflagen-Liste fuer den Bau-Worker (bindend)

1. **Dossier vor Code:** Fenster-Bauplan als eigene ultracode-Planungssession (Owner-Auflage ANKER:115); dieses Dossier + Ledger + alle Plandocs sind Pflicht-Input; A13-M3-Ist-Layout als fixer Input ("Input A13"-Default).
2. **EIN S12-Fenster:** Cross-Genus-Komposition-als-Sub-Organ und ALLE S12.1-S12.3-Teile bleiben im Fenster; jeder Verschiebe-Wunsch = Owner-Entscheid, NIE stiller Split (Review-MAJOR).
3. **Graph-TABU:** `AnatomyGattung::Graph` und alles Graph-bezogene unangetastet (Q5-Default: nach Abgabe, eigener Entscheid). Kein AnatomyGenus-Append, kein Enum-Reorder.
4. **Owner-fixierter MAJOR:** F1b = MAJOR (LEDGER:1576-1581, UNVERHANDELBAR) — Major 7->8, Magic .A7.->.A8., alle bestehenden Freezes ADDITIV erhalten (`_abi7`-Einfrieren analog `_abi4/5/6`); Loader-Major-Check-Beweis literal.
5. **ABI-Handwerks-Doktrin:** neue Faehigkeiten NIE als vtable-Anhang an IAnatomyBase oder bestehende Snapshots — neues Sub-Interface + 1x kalter dynamic_cast je Modul; Wire-PODs append-only, wo Bestands-POD weiterlebt (Set V1->V2); flacher POD je neuem Dock (`pruef_dock.hpp:13-14`); Vererbungsreihenfolge bestehender Adapter EINGEFROREN.
6. **Kein zweiter Stempel-Bruch:** SA-Stempel-Layout (A13-v6), Klammer-Grammatik, Flag-Grammatik unberuehrt; neue Genus-Versionseintraege folgen der Q3-Flag-Grammatik (`vX.Y.Zc`); merge-Zeile existiert nicht (Owner-E2) — E-24 liest die A13-Welt nur.
7. **TABUs (Wiederholung, hart):** `kCompositionAxisNames`/18-Slot-SA-Pfad; persistence_target-Disjunktheit Q-8 (`genus_binding_traits.hpp:37-40`); golden-320-Fixtures + Byte-Wache; `permutation_axes.xml`; `m3v2_study.profile.xml`; CRC64-Anker `0x56F1B721C72DC10E`; conformance-Oracle-Bestand nur ERWEITERN.
8. **Docks:** je Container-Genus IPruefDock-Implementierung mit accepts() ueber Modul-Gattung, DLL-Pfad ueber DENSELBEN Loader, Konformitaets-Gate-VERTRAG (`pruef_dock.hpp:74-79`) erfuellt — je Genus ein BENANNTES Referenz-Orakel definieren (std::map-Huelle ist SA-spezifisch; Kandidaten: std::set/std::deque bzw. std::stack/std::queue/std::span-Klassen — Fenster-Bauplan-Entscheid); Registry produktiv verdrahten + stale Kommentar `pruef_dock_registry.hpp:4` nachziehen.
9. **Hybrid-Freezes:** `IPruefDock::measure`-Vertrag stabil (HY-D2 Nr. 7); `heuristik/axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp` nicht umbenennen/entfernen; die Hybrid-Stufe erbt den neuen Major automatisch — kein Hybrid-Sonderbau in diesem Fenster.
10. **Nach-Fenster-Sperre:** nach E-24-Landung KEIN Paket mehr mit ABI-/POD-/Enum-Touch bis nach der Abgabe; Negativ-Liste in den Fenster-Abschluss-Commit (Gate G8).
11. **Kadenz (voll):** Ist-Verifikation beide Remotes -> fresh-context-Kartierung datei:zeile -> Umsetzung -> Voll-Review -> Mojibake-Grep==0 -> cf22 dry-run --Werror==0 -> Doppellauf ctest MIT N (nie nackte Prozent) -> golden-Roundtrip -> granulare Commits -> gitleaks -> beide Remotes -> CI STRIKT GRUEN beide Hosts -> super-Sub-Build Pflicht; ASCII-Selbstcheck aus dem Diff abgeleitet; Codex-Zweitreview VOR dem Fenster-Merge (analog M3-Gate); Dual-Review Fable+Codex je Landung.
12. **Arbeitsteilung v2.1:** Fenster-Bauplan/Review = Fable xhigh; Geruest nach Design = Opus 5; OrganConcept-Verdrahtung, Observer-Aggregat-Umbau, Dock-DLL-Pfade = Codex; Doku-/Ledger-Nachzug = Opus 4.8; Manager = Abnahmen, gitleaks, Serialitaet, Owner-Kommunikation. Working-Tree-Freeze nach Paketmeldung; genau EIN Schreiber im ce-Tree.
13. **Tests:** neue TUs IMMER in CMakeLists registrieren (Waisen-TU-Lehre, 8 bekannte Waisen als Warnbeispiel); Fixture-Strings gegen die Gruene-Tests-zementieren-Falle pruefen; `test_genus_binding.cpp` + `test_abi_adapter_g3_batch2.cpp` fortschreiben statt umgehen.
14. **Doku/Ledger:** LEDGER-A11-Nachtrag (E-24-Fenster-Zeile + GATE-4-Verankerung + S12-Verweis); stale Kommentare (`pruef_dock_registry.hpp:4` "V42", `observer_aggregate.hpp:2` "17-Achsen") im Fenster nachziehen; Thesis-Nachzug (Gattungs-Docks PL-19/PL-21 werden real) als C-Strecken-Punkt melden, nicht selbst texten.
15. **Messdaten/Neuanker:** keine Messdaten loeschen; TP1-Proben-Neu-Inventarisierung als EINMALIGER Vollzug nach Fenster-Ende (Option C); golden-/Neutralitaets-Bilanz sauber ausweisen (00-SYNTHESE:252).

---

## 5. Verifikations-Gates (je Gate literale Ausgabe, kein Haken ohne Beleg)

- **G1 (M0-Neutralitaet):** ctest-N vorher==nachher (Namens-Diff leer), golden-320-Byte-Wache gruen, Registry-sha identisch, 0 Byte-Ereignis ausserhalb neuer Header/Tests.
- **G2 (OrganConcept):** static_assert-Matrix 5 Genera x Concept-Teilmengen kompiliert; ObservableAxis-/statistics-Forwarding-Beweis (Wrapper forwardet Concept-Member); Negativ-Probe (Nicht-Organ-Typ scheitert am Concept, literal als Compile-Fehler-Fixture).
- **G3 (Docks/DLL):** je Genus ein DLL-Roundtrip-Test: COMDARE_DEFINE_<G>_MODULE-Fixture bauen -> laden (7-Schritt-Validierung) -> messen -> CSV; `wrong_genus`-Negativ-Probe (dock_status 2) und Konformitaets-Gate-Negativ-Probe (dock_status 4) je Genus; `PruefDockRegistry::select_for` ueber alle 5 Gattungen + `measure_genus_sequential`-Mischlauf-Test.
- **G4 (Cross-Genus):** Kompositions-Beweise `node_type<-Sequence/Adapter`, `index_organization<-Set`, `queuing<-Adapter` als Unit-Tests (SA-Anatomie traegt Genus-Organ via OrganConcept, Observer-Werte real getrieben); JOIN-Unmoeglichkeits-Asserts bestehen unveraendert.
- **G5 (ABI-Fenster):** Major-7-Altmodul wird vom Major-8-Host ABGELEHNT (Loader-Fehler literal); Major-8-Roundtrip gruen; Magic-Wechsel belegt; `_abi7`-Freezes additiv eingefroren; kHost/kCebContract-Werte im `--version`-Ausdruck belegt.
- **G6 (Identitaets-Bilanz):** `+ceb=`-Suffix-Diff dokumentiert (vorher/nachher literal); Stempel-Preimage-UNVERAENDERT-Beweis (OverlayHash identisch fuer ein Referenz-SA-Binary ohne Code-Aenderung); CRC64-Anker unveraendert; TP1-Proben-Inventur EINMAL nach Fenster-Ende, Ergebnis-Zaehlung literal; A2-Eichung erst danach (GATE 5).
- **G7 (Voll-Kadenz):** Doppellauf 2x ctest mit N beziffert; super-Sub-Build gruen; CI beide Hosts gruen mit Job-Zahl-Referenz; Dual-Review-Protokolle (Fable+Codex) abgelegt; gitleaks 0; ASCII-Diff-Selbstcheck-Zeile.
- **G8 (Sequenz-Wache):** Fenster-Abschluss-Commit enthaelt die Negativ-Liste "ABI-beruehrende Flaechen — bis nach Abgabe gesperrt" (Enums, PODs, Modul-Makros, Loader-Vertrag, Dock-Vertrag); Ledger-Zeile "E-24 vollzogen, letzter ABI-Schritt vor Trigger" gesetzt; danach darf NUR noch A2/Lager/Beweise/12-Perm/J-Kette bis zum Trigger laufen.

---

## 6. Offene Punkte

Siehe strukturierte Liste (offene_punkte) dieser Lieferung; inhaltlich identisch hier verankert: #37-Ist-Pruefung, Konformitaets-Orakel je Genus, Adapter-Engine-Frage, register_dock-Produktions-Verdrahtung, W10-Position, M4-Verschiebungs-Bestaetigung (V3-C-Detail), Zeitachsen-Slot, Q5-Quittung, Kommentar-Stales, Ledger-A11-Zeile, Hybrid-K1-Unabhaengigkeit, Test-Basis-Fortschreibung.

---

## 7. Anker-Verzeichnis (Kurzform)

ce-Ist: `anatomy_base.hpp:40-44/:76-77/:78-84/:100-109` · `genus_binding_traits.hpp:31-32/:37-40/:45/:56-58/:66-171` · `container_framework.hpp:17-25/:46/:85-95` · `abi/anatomy_module_abi_v1_decl.hpp:59/:62-63/:66/:264/:270-282` · `abi/{anatomy,set,adapter,sequence,view}_module_abi_v1.hpp` · `anatomy/{abi_adapter.hpp:39-52, set_abi_adapter.hpp:18-21, sequence_/adapter_/view_abi_adapter.hpp}` · `anatomy/{set,sequence,adapter,view}_tier.hpp` · `anatomy/observable_tier.hpp:185/:193` · `anatomy/observer_aggregate.hpp:2/:79` · `anatomy/pruefling_merge.hpp:1-16` · `builder/pruef_dock/pruef_dock.hpp:10-14/:36-41/:57-79` · `search_algorithm_dock.hpp:26/:65-86` · `{set,adapter,sequence,view}_dock.hpp` (in-process) · `pruef_dock_registry.hpp:4/:22-40` · `pruef_dock_sequencer.hpp:44-47` · `search_algorithm_permutation_engine.hpp:185` · `anatomy_module_loader.hpp:70-75/:149/:158-159` · `tests/unit/test_genus_binding.cpp` · `tests/unit/test_abi_adapter_g3_batch2.cpp`.
Plan/Owner: ANKER:115-118 · OWNER-Doc:19 · LEDGER:136/:516/:1576-1581/:1679/:2769-2771/:2784/:2828/:2858 · KATALOG:32/:111 · BAUPLAN:8/:26/:33-43/:51 · 00-SYNTHESE:209/:226/:228/:252/:256 · HY-D2:280-283/:391/:413/:418 · A16-e-buendel.md (REVIEW + Design (1)).

*Ende des Dossiers. Read-only erstellt; Vollzug (Commit der Verankerung, Ledger-A11-Zeile, Fenster-Bauplan-Session) liegt beim Lead/Manager.*

---

## ANHANG (aus Backup-JSON): entscheidungs_vorlagen

- VORLAGE V3 — E-24-Fenster-Sequenz relativ zu A13-M3 (Manager-Entscheid mit Owner-Sichtbarkeit; Default gilt ohne Einspruch).
  
  KONTEXT: E-24 (Container-Gattungs-Vollausbau) ist der LETZTE ABI-Schritt und MUSS vor dem Voll-Bau-4-Trigger liegen (HY-D2:280-283/:413 — ein Major-Bump NACH dem Voll-Bau wuerde alle eingelagerten 2^17-Binaries fuer die Hybrid-Stufe entwerten, Major-Check des Loaders anatomy_module_loader.hpp:149). Der Major selbst ist Owner-fixiert (F1b = MAJOR, UNVERHANDELBAR, LEDGER:1576-1581). Offen ist NUR die Bau-Sequenz relativ zum A13-M3-Stempel-Fenster (00-SYNTHESE:256: 'Ob E-24 mit M3 gebuendelt oder eigenes Fenster wird, ist unentschieden — bei zwei getrennten Fenstern zwei Neuanker-Ereignisse'). Technischer Kern: A13-M3 verschiebt die STEMPEL-Identitaet (Preimage, POD v6); E-24 verschiebt die ABI-/LAGER-KEY-Identitaet (Major 7->8; via anatomy_module_abi_v1_decl.hpp:282 wandert der Major automatisch ins +ceb=-Suffix aller build_version-Strings).
  
  OPTION A — VOLL-FUSION: E-24 in das M3-Fenster falten (ein Commit-Zug, ein Review). Vorteil: formal ein Fenster. Nachteil: Mammut-Diff ueber zwei Identitaets-Ebenen; M3 (L, Codex-Klasse) + E-24 (L/XL, 'gigantische Erweiterung' laut deinem Wortlaut) in einem Zug entwertet die Dual-Review-Doktrin und koppelt den Trigger-Termin hart an das groesste Einzelpaket.
  
  OPTION B — ZWEI GETRENNTE FENSTER: M3 komplett inkl. Anker-Vollzug (TP1-Inventur, Eichung), danach E-24 mit ZWEITEM Anker-Vollzug. Vorteil: saubere Pakete. Nachteil: zwei Neuanker-Ereignisse (doppelte TP1-Proben-Inventur, doppelte Freeze-/Wachen-Neueichung, zwei +ceb=-Shifts) — genau das, was die Ein-Fenster-Doktrin verbietet.
  
  OPTION C — GEKOPPELTE SERIE, EIN ANKER-VOLLZUG (EMPFEHLUNG): M3(+W10) und E-24 als ZWEI getrennte, je einzeln dual-reviewte Bau-Pakete in unmittelbarer Folge; die Anker-Vollzuege laufen EINMAL nach der E-24-Landung: A13-M4 (CEB-Contract-Minor 0->1 + Voll-Verifikation) wandert ans Fenster-ENDE hinter E-24 (dadurch genau EIN +ceb=-Shift 7.0->8.1 statt zwei), TP1-Neu-Inventarisierung einmalig, A2-SHA512-Eichung einmalig (GATE 5 unveraendert). Im Zwischenfenster (nach M3, vor E-24): kein Trigger, kein Lager-Einlagerungslauf. B3-Frozen-Neueinfrieren bleibt M3-Auflage (Stempel-Ebene, von E-24 nicht beruehrt). BENANNTE ABWEICHUNG: M4 rueckt hinter E-24 (Bauplan-GATE-2-Wortlaut sah M4 direkt nach M3) — kein stiller Umbau, hiermit dokumentiert.
  
  ZEITWIRKUNG (ehrlich): Der Bauplan terminierte bisher nur das E-24-DOSSIER (Mi), keinen Bau-Slot. Mit C: So M0+Fenster-Bauplan, Mo M3(+W10), Di-Mi E-24-Bau (Codex) + Review, Mi spaet M4+Anker+A2, Do Trigger. A2 rueckt von Di auf Mi. E-24 ist damit DER kritische Pfad; Verzug nutzt die Reserve Fr 08.08. Scope-Reduktion ist per R9 keine Option.
  
  EMPFEHLUNG: Option C. DEFAULT: Option C gilt ab sofort, wenn kein Einspruch erfolgt. UMKEHRBARKEIT: bis zur M3-Landung frei (A noch moeglich); danach nur noch B vs. C; nach E-24-Landung gegenstandslos.
- VORLAGE V3b — NUR ZUR KENNTNIS (kein Arbeitsauftrag, Defaults gelten; Einspruch jederzeit moeglich).
  
  (1) GRAPH-GATTUNG (Q5-Rest): Das E-24-Fenster laesst die Graph-Gattung vollstaendig unberuehrt (AnatomyGattung::Graph bleibt reserviert, kein Enum-Touch). Graph wird nach der Abgabe als EIGENES, user-gated ABI-Fenster mit eigenem Owner-Entscheid geplant — gemaess Q5-Default, den du mit 'volles Go fuer ALLE geplante offene Arbeit wie vorgegeben' (02.08. ~17:4x) freigegeben hast. Der scheinbare Widerspruch zu 'letzter ABI-Schritt' ist aufgeloest: 'letzter' ist auf die Mess-Kampagne gescoped (vom Fenster bis zur Abgabe kein ABI-Touch); ein Nach-Abgabe-Fenster liegt ausserhalb dieses Scopes.
  
  (2) MAJOR-VOLLZUG: Das E-24-Fenster vollzieht den von dir am 16.07. fixierten MAJOR (F1b 'UNVERHANDELBAR', LEDGER:1576-1581) als Anatomy-ABI 7->8 (Magic .A7.->.A8.), mit additivem Einfrieren aller Alt-Freezes (_abi7 analog _abi4/5/6) und literalem Loader-Ablehnungs-Beweis fuer Alt-Major-Module. Die SA-Stempel-Welt (A13) wird dabei NICHT erneut gebrochen; golden-Katalog und CRC64-Anker bleiben unveraendert; verschoben wird ausschliesslich die ABI-/Lager-Key-Ebene (+ceb=-Suffix). Die golden-/Neutralitaets-Bilanz wird im Fenster sauber ausgewiesen (00-SYNTHESE:252).
  
  (3) CROSS-GENUS-KOMPOSITION: bleibt vollstaendig IM Fenster (node_type<-Sequence/Adapter, index_organization<-Set, queuing<-Adapter via OrganConcept) — kein Teil wird 'nach Abgabe' verschoben; 'Rest' in deinem R7 wird als 'nicht-gelistete E-Punkte' gelesen (Review-Klaerung 02.08.), nicht als E-24-Teile.

## ANHANG (aus Backup-JSON): offene_punkte

- OP-1: #37-Scheduling-CT — Fenster-Bestandteil laut LEDGER:136/:1679; Ist-Stand ungeklaert (moeglich bereits ueber die O-8-/ORG-18-Strecke gelandet). VOR dem E-24-Fenster-Bauplan live pruefen; kein stiller Doppelbau.
- OP-2: Konformitaets-Orakel je Container-Genus fehlt — der V5-Vertrag (pruef_dock.hpp:74-79) verlangt je Dock eine Orakel-Pruefung vor Messung; das std::map-Gate ist SA-spezifisch. Je Genus ein Referenz-Orakel benennen (Kandidaten: std::set/std::deque/std::stack/std::queue/span-Klasse) — Entscheid im Fenster-Bauplan.
- OP-3: Adapter-Permutation-Engine existiert nicht (nur SA/Set/Sequence/View-Engines in ce libs/cache_engine/anatomy/). Klaeren, ob Adapter ueber anatomy_permutation_driver.hpp faehrt oder eine eigene Engine braucht (for_each_abi_adapter-Traeger).
- OP-4: PruefDockRegistry::register_dock hat 0 produktive Aufrufer in libs/ + tools/ (grep-belegt) — produktiven Registrierungs-/Nutzungs-Ort des Mess-Treibers verifizieren (evtl. direkter SearchAlgorithmDock-Aufruf) und im Fenster die Registry produktiv verdrahten; stale Kommentar pruef_dock_registry.hpp:4 ('kommen mit V42') nachziehen.
- OP-5: W10-Position bestaetigen — Bauplan-Zeitachse fuehrt W10-Zellwerte am M3-Tag (Mo); ob W10 im M3-Fenster mitfaehrt oder eigenes Paket wird, bestimmt die Zahl der Stempel-Preimage-Shifts (Empfehlung: im M3-Fenster mitfahren).
- OP-6: M4-Verschiebung ans E-24-Fenster-Ende (Option-C-Detail, ein +ceb=-Shift statt zwei) = benannte Abweichung vom Bauplan-GATE-2-Wortlaut — Manager-Bestaetigung via Vorlage V3.
- OP-7: Zeitachsen-Slot fuer den E-24-BAU fehlt im Bauplan (nur das Dossier war Mi terminiert); A2 (GATE 5) rueckt hinter E-24 — Zeitachse nachziehen (Vorschlag in Abschnitt 3.3); Trigger-Tag-Risiko Richtung Reserve Fr 08.08. benannt.
- OP-8: Q5-Graph-Quittung — Default (nach Abgabe, eigener Owner-Entscheid) gilt per Owner-GO ~17:4x als freigegeben; formale NUR-KENNTNIS-Quittung im gesammelten Owner-Vorlagen-Block ausstehend (Vorlage V3b liegt bei).
- OP-9: Stale Kommentare im Fenster nachziehen: pruef_dock_registry.hpp:4 ('V42'), observer_aggregate.hpp:2/:79 ('17-Achsen' vs. ORG-18).
- OP-10: LEDGER-A11-Nachtrag offen: E-24-GATE-4-Verankerung + S12-Fenster-Zeile + Nach-Fenster-ABI-Sperre (G8-Negativ-Liste) — Lead-Vollzug, Teil der P1-Landung.
- OP-11: Hybrid-K1 (Lager-Identitaet der Hybrid-.so) bleibt offen und ist E-24-NEUTRAL — aber solange K1 offen ist, darf kein Lager-Schema Hybrid-Knoten annehmen (HY-D2 §7-K1); keine Kopplung ins E-24-Fenster ziehen.
- OP-12: Test-Basis fortschreiben: tests/unit/test_genus_binding.cpp + test_abi_adapter_g3_batch2.cpp im Fenster erweitern statt umgehen; neue TUs registrieren (Waisen-TU-Lehre: 8 bekannte unregistrierte TUs als Warnbeispiel).
- OP-13: Thesis-Nachzug melden (C-Strecke, nicht selbst texten): Gattungs-Docks PL-19/PL-21 werden mit dem Fenster real; Thesis fuehrt sie bisher als nachgelagerte Arbeitspakete (LEDGER-Bookkeeping-Zeile um :2734).
