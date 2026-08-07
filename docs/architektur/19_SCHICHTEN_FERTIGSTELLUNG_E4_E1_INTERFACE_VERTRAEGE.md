# DOSSIER 19 — Schichten-Fertigstellung E4→E1: Interface-Verträge, getrennte Testbarkeit, Abarbeitungs-Sequenz

> **Status:** Planungs-Dossier (2026-07-09, abends). Setzt die **User-Direktive 09.07.** um: *„Wir möchten jede dieser Schichten mit sauberen Interfaces nacheinander separat fertigstellen und getrennt testen können. Das System ist für multiple Ebenen gleichzeitig zu groß."* Re-etabliert die ORIGIN-Direktive vom 28.06. (top-down ab E4, E0 zuletzt — ce `docs/sessions/20260628-KONTEXT-DOSSIER-…A2welle.md §16`; Vier-Ebenen-Definition ebd. `§13`; super `20260628-SESSION-ENDE-9-…md`). **Erweitert Dossier 18** (Mess-Methodik) um die Schicht-Sequenzierung; präzisiert die Reihenfolgen aus Dossier 17 Teil D und Dossier 18 Teil C. Wurzeln wie in Dossier 16-18; LEDGER = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (663 Z., Voll-Read Codex + eigene Detail-Lektüre 09.07. abends).

> ---
>
> ## ⚠️ STAND 2026-08-07: DIE E3-/E1-SCHICHT IST WEITER, ALS DIESES DOSSIER SIE FUEHRT
>
> **Die Schicht-Doktrin (Interface-Vertraege, getrennte Testbarkeit, top-down ab E4) gilt weiter.
> Der Fortschritts-Stand nicht.** Dieses Dossier fuehrt als offen, was seither gebaut wurde — es ist
> damit derselbe Fehlbefund-Traeger wie Dossier 17. Belege gegen ce `ba069e38` (identisch in
> `ab0b352e`).
>
> ### Die harten Anker
>
> | Aussage im Dossier | Ist-Stand 07.08. | Beleg (ce) |
> |---|---|---|
> | `:20` „`kV3AxisSchema` (`axis_stats[**19**][8]`+seg_ns+Meta, **ABI-Major 4**)" | `axis_stats[**18**][8]` + `seg_ns[18]`; ABI-Major **8** | `anatomy/observable_tier.hpp:50`, `:141`; `abi/anatomy_module_abi_v1_decl.hpp:89` |
> | `:21` „`ObserverAggregate<**19**>`" | **`<18>`** | `observable_tier.hpp:50` |
> | `:17` „traegt **19** `permute_axes`" | **18** Achsen (T0..T17) | `anatomy/composition_factory.hpp:104` |
>
> ### Vollzugs-Marken (am Objekt geprueft 07.08.) — vier als offen gefuehrte Posten sind gebaut
>
> - `:19` „**Tier-Seite konsumiert nur `prefetch_distance`** (T7); **4 Felder = Phantom**"
>   — **VOLLZOGEN.** Alle fuenf RC-Felder werden appliziert: `anatomy/abi_adapter.hpp:462-496`.
>   `thread_count` ist ausgewiesen honest-0 (`:467-473`), nicht Phantom.
> - `:17` „`runtime_dynamic` (**nur thread_count/hw_prefetcher**); **4 RC-POD-Felder ohne XML-Eingang**"
>   — **VOLLZOGEN.** `build_axis_levels` emittiert heute alle RC-Dimensionen als dynamische Ebenen:
>   `builder/experiment_tree/profile_to_tree.hpp:127-140`, Wiederholungs-Achse `:141-148`.
> - `:18` „aber **Limits hartkodiert** (`source_catalog.hpp:83-116` `CatalogAxes<4,4,5,4>`=320)" und
>   `:30` E3-DoD (2) „Limits-Entkopplung" — **VOLLZOGEN und haerter gebaut als geplant.** Der
>   materialisierte Katalog entsteht per Codegen aus der XML (`cmake/catalog_codegen.cmake`);
>   `CatalogAxes` ist ueber 18 Parameter K00..K17 parametrisiert
>   (`profile_facade/source_catalog.hpp:94-118`); `golden_320_catalog` ist nur noch ein benannter,
>   messdaten-erhaltender Alias (`:144`). Darueber hinaus sichert der GN-2/§26.6-Guard die
>   Entkopplung **compile-time** ab: `kMaxMaterializableCatalogCardinality = 4096` (`:205`), zwei
>   `static_assert`s schliessen die 2^17-Vollform aus (`:209`, `:211`).
> - `:21` „`SystemAxis`/`IMeasurementSource` … heute fragmentiert, **Wurzel fehlt**; = Aufgabe M1"
>   — **GEBAUT.** `include/cache_engine/measurement/system_axis.hpp`, `.../i_measurement_source.hpp`,
>   `.../measurement_axis_registry.hpp`.
> - `:21` „`MeasurementCategory` (16, **isoliert**)" — die **Zahl 16 stimmt**, das Attribut „isoliert"
>   nicht mehr: die Kategorien haengen an der Wurzel und an einer compile-time-Registry.
>
> ### Zeilen-Drift in den Belegen (Inhalt vorhanden, Nummer wandert)
>
> `:17` `parse_thesis_profile` steht heute bei `libs/common/serialization/xml_config_parser/xml_config_parser.cpp:272`
> (nicht `:199-296`) · `:17` `build_axis_levels` bei `profile_to_tree.hpp:39` · `:18`
> `BuildOrchestrator::provision_all` bei `build_orchestrator.hpp:476`/`:483` (nicht `:171-349`) ·
> `:19` der apply-Block bei `abi_adapter.hpp:447-496`.
>
> **Ungeprueft:** alle `*.tex`-Anker (`:32`, `:9`) — das thesis-Submodul ist in diesem Arbeitsbaum
> nicht ausgecheckt. Ebenso `:20` `generate_wide_appendix.ps1`: im super- und ce-Baum null Treffer,
> aber wegen des leeren Submoduls **kein belastbarer Nullbefund**. Siehe dazu die Vollzugs-Marke in
> Dossier 22, wo der .ps1-Nullbefund fuer den super-Baum belegt ist.
>
> **Weiterhin korrekt:** `:19` POD `ComdareResourceControlV1` und die Methodennamen
> `tier_query_resource_caps` / `tier_apply_resource_control` (`abi_adapter.hpp:437`, `:447`) ·
> `:20` die Werkzeuge `04_csv_to_latex` / `05_diagram_generator` (super `Code/`) · `:32` PMC-honest-0.
>
> ---

## 0. ZWECK & BEGRÜNDUNG

Beide 09.07.-Reverts (Phase 1 `#230`, Phase 2 `#221`) hatten dieselbe Fehlerklasse: **Increments, die mehrere E-Ebenen gleichzeitig berührten**, scheiterten an Wechselwirkungen, die weder lokale Tests noch Zeile-für-Zeile-Review sahen (super-Sub-Build-Linkage; Mess-Bugs, die erst zur #156-Laufzeit manifestieren). Die Konsequenz (User): **eine Schicht nach der anderen fertigstellen** — jede mit (a) explizit eingefrorenem Interface-Vertrag zur Nachbar-Ebene, (b) eigenem Test-Harness, der die Nachbar-Ebene durch Fakes ersetzt (Contract-Tests), (c) eigener Definition-of-Done. Damit wird jede Ebene **einzeln abnehmbar**, bevor die nächste beginnt.

**Design-Quelle:** die Diplomarbeit-LaTeX ist die Quelle der Idee jeder Implementierung (User 09.07.) — jeder Schicht-Increment zitiert seine Thesis-Anker (`thesis/diplomarbeit/kapitel/de/*.tex`).

## TEIL A — DIE SCHICHTEN UND IHRE VERTRÄGE

Die Pipeline (ORIGIN §13, User-verbatim 28.06.): `compile → XML-Interpretation (E4→E3) → Tier-Binaries (E3→E2) → RC-Konfiguration (E2→E1) → CEB-Messauswertung (E1→E4-Rückkanal)`. Dazu der Querschnitt **M** (Mess-System, System-Achsen „Blut") und **E0** (Infra, zuletzt).

| Grenze | Vertrag (Artefakt) | Code-Anker | Ist-Zustand |
|---|---|---|---|
| **E4→E3** | XML-Profil → `ThesisProfile` → `AxisLevel[]` (statisch=Binary-Identität, dynamisch=RC-Dimension) | `parse_thesis_profile` (`xml_config_parser.cpp:199-296`) → `profile_to_tree.hpp:25-89 build_axis_levels` | trägt 19 `permute_axes` + `runtime_dynamic` (nur thread_count/hw_prefetcher); **4 RC-POD-Felder ohne XML-Eingang** (B4-1) |
| **E3→E2** | `StaticBinaryView`/`binary_id` (mixed-radix) → Bau-Auftrag → 1 DLL je Permutation | `experiment_tree.hpp:235-324` → `BuildOrchestrator::provision_all` (`build_orchestrator.hpp:171-349`) → `adhoc_emitter.hpp:83-108` | funktioniert golden-getestet, aber **Limits hartkodiert** (`source_catalog.hpp:83-116` `CatalogAxes<4,4,5,4>`=320); **#223-Gate nicht im Voll-Lauf** |
| **E2→E1** | ABI: `IResourceControllableTier` (`tier_query_resource_caps`/`tier_apply_resource_control`) + POD `ComdareResourceControlV1` (5 Felder) | `abi_adapter.hpp` (apply: ~:187-244) | Builder-Seite fertig (`RuntimeVariableLoop`); **Tier-Seite konsumiert nur `prefetch_distance`** (T7); 4 Felder = Phantom. **LEDGER §4:94: Vertrag VOR #221 EINFRIEREN** |
| **E1→E4 (Rückkanal)** | Mess-POD-Pull: `IObservableTier::tier_observe(ComdareTierObserverSnapshot*)`, Schema `kV3AxisSchema` (axis_stats[19][8]+seg_ns+Meta, ABI-Major 4) → WIDE-CSV → csv-to-latex/diagram-generator | `CE/31:44-84`; Tools `04_csv_to_latex`/`05_diagram_generator`; `generate_wide_appendix.ps1` | Tooling fertig+reproduzierbar (B4-2); **A/B/C-Spalten warten auf m3v2-Daten** (#156, HELD) |
| **M (Querschnitt)** | System-Achsen-Wurzel `SystemAxis`/`IMeasurementSource` — immer präsent bei Messung, NICHT im Permutationsbaum, NICHT Gattung | heute fragmentiert: `MeasurementCategory` (16, isoliert) + `IPmcSource` + `ComdareMeasurementSnapshotV1` + `ObserverAggregate<19>` | **Wurzel fehlt** (Dossier 17 B.3 / 18 A.1); = Aufgabe M1 |

**Bindend dabei (Dossier 18 A.5 + Memory):** E4→E0 strikt interface-orientiert; System-Achsen (M) berühren NIE die binary_id/E3-Permutation; Organ-Achsen-Effekte nie mit Mess-Instrumenten vermischen.

## TEIL B — DEFINITION-OF-DONE + SEPARATER TEST-HARNESS JE SCHICHT

Prinzip: **jede Schicht ist gegen einen Fake ihrer Nachbar-Ebene testbar** — sie kann FERTIG werden, bevor die tiefere Ebene ihre Werte konsumiert. Die Contract-Tests sind normale ctest-Ziele (compile-time-Fakes via Templates/Concepts, kein Runtime-Switch; Lehrbuch-Fake/Stub im Test-Scope ist pattern-konform).

- **E4 (Definition + Auswertung).** DoD: (1) `run_profile` produktiv angedockt (1′/#230 mit den beiden bekannten Fixes: ~15 Adapter-Links + `COMDARE_FACADE_PERM_INCLUDES`; Voll-Harness-Parameter B.1); (2) die 4 RC-POD-Felder **XML-definierbar** (ThesisProfile-Felder + SCHEMA + `build_axis_levels`-Emit — reine EINGANGS-Seite; Konsum bleibt E1); (3) **E4-Contract-Test**: XML→`ThesisProfile`→`AxisLevel[]`-Golden-Fixtures gegen **Fake-E3** (die emittierten AxisLevels werden strukturell verglichen, kein Baum/Bau nötig). Verlustfreiheits-Prüfung = ORIGIN-§14-Prüffrage als Test.
- **E3 (Permutations-B+-Baum).** DoD: (1) #223-Konformitäts-Gate `import→GATE→messen` im Voll-Lauf-Pfad; (2) Limits-Entkopplung: `CatalogAxes` aus `ThesisProfile.permute_axes` abgeleitet (golden-Roundtrip==320 als Regressions-Gate, Default byte-gleich); (3) **E3-Contract-Test**: AxisLevel-Fixtures → `StaticBinaryView`-Enumeration/binary_id-Bijektion gegen **Fake-E2** (kein DLL-Bau; Zählung + Signatur-Roundtrip genügen; Gate-1-Arithmetik als Invariante).
- **E2 (Tier-Binaries).** DoD: (1) #188-Rest (honest-0-Design/Store-Backing, stale Kommentare); (2) uniformes Organ-Routing je Familie; (3) **E2-Contract-Test**: eine emittierte Referenz-DLL erfüllt den ABI-Vertrag (dlopen → `IAnatomyBase`/`IObservableTier`/`IResourceControllableTier`-Reihenfolge eingefroren, caps-Antwort) gegen **Fake-E1** (RC-POD wird angelegt/appliziert, aber Konsum-Wirkung NICHT verlangt — das ist E1s DoD).
- **M (Mess-Querschnitt, VOR E1).** DoD: gemeinsame abstrakte Wurzel `SystemAxis`/`IMeasurementSource` (zero-cost: CRTP+Concept, kein vtable im Hot-Path; ABI-Grenze unverändert); die Mess-Kategorien (Thesis-Katalog `03_messsystem_prtart.tex:382-386`: CLU, Cache-Miss L1/L2/L3, dTLB, Branch, IPC/CPI, Latenz, Durchsatz, Energie, Speicher-Fußabdruck) als Strategies darunter; observer/PMC-Zweiteilung (`06_evaluation_methodology.tex:110-126`) als Regime-Merkmal; `MeasurementCategory`/`IPmcSource`/Snapshot-POD dahinter konsolidiert (additiv, golden/ABI-neutral). **Eigener Harness:** M ist OHNE Tier-Binaries testbar (synthetische Quelle → Wurzel-Interface → POD-Spalten). PMC-honest-0 bleibt (pmc_available-ehrlich).
- **E1 (RC-Laufzeit).** DoD: (1) **Vertrags-Freeze zuerst** (LEDGER §4:94: `IResourceControllableTier`/RC-apply einfrieren = der E2→E1-Vertrag, den E2 schon erfüllt hat); (2) 2′/#221 ehrlich: GENAU T6 (pool_budget_bytes) / T8 (thread_count, echte Contention-Semantik) / T1 (batch_size) / T11 (inline_threshold_bytes) mit den F.1-Min/Max-Semantiken als Observer-Strategy; T7 bleibt; 14 honest-0 unangetastet; alle A1-A9-Fixes (SYNTHESE Phase-2-221); RC=0 = byte-identisches No-Op; DEG in benannte kV3AxisSchema-Spalte; (3) M2 (Wirkungsweise je Achse als Strategy hinter dem M-Interface); (4) **E1-Contract-/Edge-Tests**: reused-Tier-Reset, budget<live-set, Zwei-Phasen-Rollback-Erhalt, CSV-Named-Column-Sichtbarkeit (NICHT in-process-POD), Zwei-Phasen-Op-Schleife.
- **E0 (zuletzt, ORIGIN §16):** Gesamtüberarbeitung/Hygiene (#224 S9-Etiketten, DRY kAbiMajor, Infra) NACH den Pipeline-Schichten.

## TEIL C — AUFGABEN-ZUORDNUNG (Ledger ⟷ Schichten, Stand 09.07. abends)

| Schicht | Aufgaben (offen) | Ledger-/Dossier-Anker | Gates |
|---|---|---|---|
| **E4** | 1′/#230-Neubau · B4-1-XML-Eingang der 4 RC-Felder · E4-Contract-Harness | Dossier 18 B.1; ORIGIN §14 B4-1; Backup `…phase1-230/` | non-gated (Freeze-GO 09.07.); **#31-W/D/M-XML bleibt R1/R2-gated** (LEDGER:406, Dossier 16 I.4) |
| **E3** | #223 Gate-Verdrahtung · Limits-Entkopplung (#229-Kern) · E3-Contract-Harness | ORIGIN §14 B3-2; Dossier 17 Phase 4/7 | golden-Roundtrip==320 Pflicht; TABU permutation_axes/golden/Traits |
| **E2** | #188-Rest (honest-0/Store-Backing) · E2-ABI-Contract-Harness · (S7/#234-Rest = 234-V **user-gated**) | Dossier 16 A.5/C; LEDGER §3 S7:86 | 234-V-Fork bleibt GEPARKT (kein Blind-Bau) |
| **M** | M1 System-Achsen-Wurzel (+ Bezug S5 CMD-1/#251 Mess-Visitor: neutral compile-time per DD-B — konsistent mit der Wurzel planen) | Dossier 18 A.1/C-M1; LEDGER §3 S5:84 | golden/ABI-neutral; kein Bump (Reserve unverbraucht, LEDGER:566) |
| **E1** | Vertrags-Freeze → 2′/#221 (T6/T8/T1/T11) + M2 + Edge-Tests | Dossier 18 F.6/B.2; LEDGER §3 S4:83 (in_progress, **stale**: 09.07. implementiert+revertiert `290e306c`) | adversarialer max-Effort-Review Pflicht; DD-C („RC-Rest via #229 deferred") ist durch User-Direktiven 09.07. (Vollendung, erforscht statt erfunden) ÜBERFORMT |
| **danach** | S6 CMD-2 (einziger Bump-Kandidat, User-Freigabe) · #31/F7 (R1/R2) · S8/#215 (Schleuse) · #156/#162 (HELD) · S9/#224 + E0 | LEDGER §3/§4; Dossier 17 Phase 5-8 | wie dokumentiert |

**Parallel (nicht schicht-gebunden):** Pareto-Objective-Research T6/T18/T5 (Dossier 18 F.4; Goal-Direktive: Eigenschaften per deep research ergründen) — Ergebnis fließt in E4′-Heuristik-Auswertung (auf `cacheline_policy_selector.hpp` aufbauend, F.3).

## TEIL D — SEQUENZ & VERHÄLTNIS ZU BESTEHENDEN PLÄNEN

**Sequenz (bindend): E4 → E3 → E2 → M → E1 → [CMD-2/#215/#156-Strecke] → E0.**

- **Vs. ORIGIN-§14-Empfehlung „E2→E1 zuerst":** Das Audit empfahl die Fix-Reihenfolge nach Daten-Wirksamkeit; die User-Direktiven (28.06. §16 + 09.07.) ordnen top-down an. Der Konflikt löst sich durch die Contract-Tests: E4/E3 werden gegen Fakes FERTIG (ihre Verträge sind verlustfrei), ohne auf E2/E1-Konsum zu warten — genau die ORIGIN-Prüffrage („reicht die Ebene ihre Definition VERLUSTFREI weiter?") wird je Ebene zum Abnahme-Test.
- **Vs. Dossier 18 Teil C (M0→M1→M2→2′→1′):** M0 ist vollzogen (BEFUND). Die Schicht-Direktive zieht **1′ (E4) vor M1/2′** und bettet M1 als Querschnitt-Modul unmittelbar vor E1 ein (2′ setzt auf der M-Wurzel auf). Inhalte von Dossier 18 (B.2-Constraints, F.1-Semantiken, F.6-Scope) bleiben unverändert bindend.
- **Vs. Goal-V3-Arbeitsreihenfolge (LEDGER:565):** Die V3-Sequenz ist laut Voll-Read in weiten Teilen DONE/stale; die **Vorrang-Regel** (LEDGER:564: neueste USER-Aussage gewinnt) macht die Schicht-Sequenz zur aktiven Ordnung. Additiv im Ledger nachgezogen (§12-Eintrag 09.07. abends), Original-Wortlaut bleibt.
- **Spur-S-Kompatibilität:** Die serielle ABI-Kette (§3) bleibt gewahrt — S4(#221)=E1, S5(CMD-1)≈M, S7(#234)=E2, S8(#215)/S9(#224) nach den Schichten; „max. 1 offen" gilt weiter, da die Schichten seriell laufen.

## TEIL E — KADENZ-EINBETTUNG (unverändert + 09.07.-Ergänzungen)

Goal-V3-Kadenz (LEDGER:567) gilt je Schicht-Increment vollständig. Ergänzt (User 09.07.): **(a)** Erstimplementierung IMMER Codex (gpt-5.5/xhigh, danger-full-access, elaborates Dossier mit allen Referenzen + Thesis-Ankern) → Zeile-für-Zeile-Review; **Eskalation:** Codex scheitert komplett → selbst implementieren; kleinere Verstöße → nur betroffene Abschnitte manuell korrigieren. **(b)** Vor teurer Neu-Recherche die **Workflow-Backups** (`docs/sessions/backups/…` mit Rohdaten `ERGEBNIS-wf_*.json`/`journal.jsonl`) per ultracode durchsuchen. **(c)** Thesis-LaTeX = Design-Quelle; jeder Spec zitiert die Kapitel-Anker. **(d)** super-Sub-Build + adversarialer max-Effort-Review vor „fertig" (Lehre beider Reverts). **(e)** Task-Store-Verluste bei /goal//model-Wechseln einkalkulieren: laufende Agenten vor solchen Wechseln abschließen; Wahrheit = git+Dossiers+Ledger.

## TEIL G — BETRIEBSREGIME-VISION: MESS- → AUSWERTUNGS- → ARBEITSMODUS (User 09.07. abends, bindend)

**Abstraktions-Semantik der Schichten (User-verbatim-nah):** **E4 ist die abstrakteste Ebene der cache-engine — die Ebene, die ein ANWENDER des Frameworks in der Regel verwendet**; **E1/E0 ist die präziseste Detailimplementierung des Baumes.** Die Schicht-Hierarchie ist also zugleich die Anwender-Sicht-Hierarchie (oben deklarativ, unten mechanisch).

**Die drei Betriebsmodi des CacheEngineBuilder-Interfaces:**
1. **Messmodus (Schritt 1):** Nach der Messung kennt das Framework **die Eigenschaften aller zugelassenen Achsen-Algorithmen gegen die Rekombination aller zugelassenen Frameworks × Workloads**.
2. **Auswertungsmodus:** Aus den Messungen ergeben sich **minimale Stränge der Permutationen aller Eigenschaften gegeneinander für bestimmte Workload-CLUSTER**. Die Cluster-Bildung (wie Workloads zu Clustern aggregiert werden, welche Cluster-Verfahren) ist **per deep research zu ergründen** (→ neuer Forschungs-Task; verwandt: E4′-Heuristik-Kurven + Pareto-BEFUND-Objectives).
3. **Arbeitsmodus (das Produktions-Ziel):** Danach steht das CEB-Interface im **Arbeitsmodus** zur Verfügung: es hält **alle relevanten Tier-Binaries für die aktuell stochastisch häufig auftretende Workload-Last und Interface-Funktion hot im RAM** und **switcht die Tier-Binary mit ihren speziell optimalen Achsen-Permutationen unter der Haube hot auf das ABI-stabile Interface**, um optimale Verarbeitungszeiten der Anfrage zu erzielen.

4. **Hybrid-Modus (vierter Schritt, User 10.07. — DAS ZIEL DER DIPLOMARBEIT):** Nach dem Arbeitsmodus folgt der **Hybrid-Modus** (hybrider Arbeitsmodus + Messung: Wall-Clock + Makro-/Mikrobenchmarks per Command-Pattern). Im Arbeitsmodus lässt sich die **kombinierte Wall-Clock-Zeit gegen alle Mess-Achsen und deren Workload-Frameworks × Workloads gegen alle anderen Tier-Binaries** bestimmen → ein **Compare-Feature auf E4**, das nach der heuristischen Optimierung die Vergleichs-Wall-Clock-Messung durchführt und die beiden weiteren Ebenen (Makro- und Mikrobenchmarks) **cross alle Tier-Binaries über alle Operationen mitloggt** — also ein **Mess-Command-Pattern über die optimierte Tier-Binary-Rekombination als virtuelles ganzes Tier-Binary**. Kernstück: **Die Heuristik-Optimierungs-Achse ist eine EIGENE SYSTEMACHSE**, die per Metaprogrammierung die **Gattung ihrer Tier-Binaries übernimmt**; sie verfügt über ein Prüf-Dock, das im Arbeitsmodus **Arbeits-Dock** heißt, und wird **selbst zu einer Tier-Binary kompiliert**, die am eigentlichen Prüfdock des CacheEngineBuilder andocken kann, um Befehle an die ihr **statisch zugewiesenen echten Tier-Binaries weiterzureichen (Metaprogrammierungs-Command-Pattern)**. Die Rekombination der zu verwendenden Tier-Heuristik-Binaries ist **selbst permutierbar gegen die existierenden echten Tier-Binaries** — daher kann die Heuristik-Achse die heuristischen Mess-Funktionskurven für Schätzungen und die **Kompilation einer optimalen mehrdimensionalen Rekombination** verwenden, die durch ihr **ABI-stabiles Gattungsinterface eindeutig als Suchalgorithmus-Hülle** verwendbar ist. Der Hybrid-Modus mündet in der **erneuten Messung des Heuristik-Tier-Binaries** nach Eintritt des Arbeitsmodus (in dem es nur einzelne Tier-Binaries gibt).

**Ziel-Klarstellung (User 10.07., bindend):** Das Ziel der Diplomarbeit ist, **die beste Rekombination bzw. auch das beste einzelne Binary gegenüber allen Achsen-Eigenschaften — besonders Cache-Line-Awareness — herauszufinden** und dann **die beste einzelne Binary UND das Heuristik-Tier-Binary bereitzustellen, die in Produktion tatsächlich verwendet werden können**. Inklusive sind die korrekte Messauswertung und Dokumentation im Diplomarbeits-Projekt — durch **Generierung von Messwerttabellen und Graphen in der Diplomarbeit selbst** (wissenschaftlicher Stand). **Alle 4 Phasen der cache-engine (Mess- → Auswertungs- → Arbeits- → Hybrid-Modus) müssen erzeugt und in E4 aus Sicht der Diplomarbeit AUTOMATISCH dokumentiert werden** (die bestehende E4-Auswertungs-Kette CSV→LaTeX-Tabellen/Graphen→PDF ist dafür der Träger; sie ist auf alle 4 Phasen auszudehnen).

**Architektur-Konsequenzen (ebenen-richtig):** Der Hot-Switch geschieht am **ABI-stabilen Interface** (E2-Grenze: `IObservableTier`/DLL-Wechsel — der bestehende „CacheEngineBuilder wechselt die GANZE Binary"-Mechanismus, jetzt last-getrieben statt mess-getrieben) — **kein** Runtime-Switch IM Tier (Metaprogrammierungs-Doktrin bleibt: die Binaries selbst sind compile-time-permutiert; der Wechsel ZWISCHEN vorgeladenen Binaries an der bewussten ABI-Grenze ist der erlaubte dynamische Ladepunkt). Die Workload-Erkennung (stochastisch häufige Last) ist eine Auswertungs-/E4-Funktion, die den Heuristik-Schätzer (E4′, `cacheline_policy_selector`-Familie + Objectives) zur Laufzeit konsumiert. **Einordnung in die Rest-Strecke:** Arbeitsmodus = nach E4′ (braucht Messdaten #156 + Cluster-Research); als eigener Increment NACH den Schichten zu planen.

## TEIL F — VERIFIKATION DES DOSSIERS

- Schicht-Verträge decken alle vier ORIGIN-§13-Ebenen + Rückkanal + M ab; keine Aufgabe der Dossier-17/18-Roadmaps ist verloren (Teil C bildet alle auf Schichten ab; Rest-Strecke explizit).
- Alle User-Gates bleiben respektiert (R1/R2, 234-V, CMD-2-Bump, HELD-Kette) — die Schicht-Sequenz baut NUR non-gated Kerne.
- Tabus unverändert (LEDGER:568). Erste Umsetzung = Schicht E4 (1′/#230 + B4-1-Eingang + Contract-Harness) als eigener Kadenz-Increment.

## Nachtraege — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unveraendert (Doku nie loeschen).

- **[R1 · Anker docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:17]** Teil-A-Tabelle (E4→E3-Zeile) additiv um eine Zeile/Fußnote ergänzen: Der E4-Eingang referenziert die **zwei Registries gleichen Schemas** (ce-Registry + prt-art-Registry, Bausteine je Achse ausschließlich dort); die Experiment-XML selbst listet **keine** Bausteine. Verweis auf `feedback_unified_experiment_xml` / LEDGER §15.1. Der bestehende `ThesisProfile`→`AxisLevel[]`-Pfad bleibt der lebende golden-Pfad (golden-320-Roundtrip via `parse_thesis_profile` unverändert, INC-A/INC-D); das Zwei-Registry-Modell ist additiv obendrauf, dieses Dossier ist ein durch Ledger §15 abgelöster, datierter Planungs-Snapshot.  \n  *(Bezug: E4→E3-Vertrag „XML-Profil → ThesisProfile → AxisLevel[]", parse_thesis_profile)*
- **[R2 · Anker docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:29]** E4-DoD (3) additiv um einen Punkt erweitern: E4-Contract-Test auf die **EINE 3-Phasen-Experiment-XML** ausdehnen (Phase 1 prt-art / Phase 2 cache-engine / Phase 3 kombiniert; Registries-referenzierend, Familie A `comdare_thesis_profile` + Familie C `messreihe_v32` vereinend). Als Erfüllungsnachweis den bereits existierenden Companion-Test `test_v32_messreihe_antrieb` (INC-G/H) referenzieren, statt neue Test-Infrastruktur zu fordern.  \n  *(Bezug: E4-DoD „XML→ThesisProfile→AxisLevel[]-Golden-Fixtures gegen Fake-E3")*
- **[R4 · Anker docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:18]** Teil A additiv um einen konsolidierten R4-Satz ergänzen (besser am Teil-A-Intro nahe Z.13/Pipeline als an der engen E3→E2-Bau-Zeile, da R4 mehrere Zeilen umspannt): Der **CEB ist das zentrale Framework** — es hält **alle XML-Parser**, das **Prüfdock** und das **Messsystem** und baut die **Tier-Binaries C++-orchestriert zur Laufzeit** (NICHT via CMake, aus Performance-Gründen). Beleg kanonisch: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1121` (§15.1).  \n  *(Bezug: E3→E2-Vertrag „BuildOrchestrator::provision_all → adhoc_emitter")*
- **[R10 · Anker docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:73]** Teil G additiv vermerken: Träger der 4-Phasen-Dokumentation ist die **vollständige 01–09 xml→pdf-Codekette** samt **honest-empty-`\InputIfFileExists`-Anhangsanbindung** (nicht nur die auf Z.20 genannten Tools 04/05 + `generate_wide_appendix.ps1`). Die konkrete Kette ist autoritativ im lebenden Ledger dokumentiert (INC-1/4/7, GO-1) sowie in `docs/thesis-anhang-wiring-READY.md`.  \n  *(Bezug: „bestehende E4-Auswertungs-Kette CSV→LaTeX→PDF … auf alle 4 Phasen auszudehnen")*
