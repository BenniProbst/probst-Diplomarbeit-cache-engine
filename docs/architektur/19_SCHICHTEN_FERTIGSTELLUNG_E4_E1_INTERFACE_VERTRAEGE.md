# DOSSIER 19 — Schichten-Fertigstellung E4→E1: Interface-Verträge, getrennte Testbarkeit, Abarbeitungs-Sequenz

> **Status:** Planungs-Dossier (2026-07-09, abends). Setzt die **User-Direktive 09.07.** um: *„Wir möchten jede dieser Schichten mit sauberen Interfaces nacheinander separat fertigstellen und getrennt testen können. Das System ist für multiple Ebenen gleichzeitig zu groß."* Re-etabliert die ORIGIN-Direktive vom 28.06. (top-down ab E4, E0 zuletzt — ce `docs/sessions/20260628-KONTEXT-DOSSIER-…A2welle.md §16`; Vier-Ebenen-Definition ebd. `§13`; super `20260628-SESSION-ENDE-9-…md`). **Erweitert Dossier 18** (Mess-Methodik) um die Schicht-Sequenzierung; präzisiert die Reihenfolgen aus Dossier 17 Teil D und Dossier 18 Teil C. Wurzeln wie in Dossier 16-18; LEDGER = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (663 Z., Voll-Read Codex + eigene Detail-Lektüre 09.07. abends).

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

## TEIL F — VERIFIKATION DES DOSSIERS

- Schicht-Verträge decken alle vier ORIGIN-§13-Ebenen + Rückkanal + M ab; keine Aufgabe der Dossier-17/18-Roadmaps ist verloren (Teil C bildet alle auf Schichten ab; Rest-Strecke explizit).
- Alle User-Gates bleiben respektiert (R1/R2, 234-V, CMD-2-Bump, HELD-Kette) — die Schicht-Sequenz baut NUR non-gated Kerne.
- Tabus unverändert (LEDGER:568). Erste Umsetzung = Schicht E4 (1′/#230 + B4-1-Eingang + Contract-Harness) als eigener Kadenz-Increment.
