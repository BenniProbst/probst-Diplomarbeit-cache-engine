# IMPL-AGENT — Konsolidierte offene TODOs / Handovers + Wartbarkeits-Auftrag

**Datum:** 2026-06-25
**Adressat:** Implementierungs-Agent (Code-Revier: cache-engine, prt-art, super-Diplomarbeit; NICHT Thesis-Text, NICHT Infra)
**Zusammengeführt aus:** 4 Projekt-Scans (cache-engine / prt-art / super-Diplomarbeit / thesis-text — Session-Docs `docs/sessions` + `docs/architecture`).

---

## 0. Kopf — Zweck & Leitprinzip

### Zweck dieses Dokuments
Dieses Dokument ist die **Single-Source der offenen Implementierungs-Aufgaben** über alle 4 Projekte hinweg. Es ist **Kontext-Ende-sicher** geschrieben: Falls der Arbeitskontext abreißt, kann ein frischer Impl-Agent allein aus diesem Dokument den vollständigen offenen Stand rekonstruieren — jede Aufgabe nennt Titel, konkrete Tätigkeit, Code-Orte (file:line), Status und Quelle (Session-Doc).

> **Hinweis zur Autorität:** Die *laufend gepflegte* Single-Source-of-Truth bleibt das Ledger
> `Code/external/comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md`.
> Dieses Dokument ist die **konsolidierte Momentaufnahme zum 2026-06-25** plus die **neuen User-Anforderungen vom 2026-06-25** (Abschnitt B). Bei Widerspruch zu konkreten Code-Stellen gilt: **vor jedem Edit Zeilennummern re-greppen** (siehe Abschnitt C).

### Leitprinzip (KRITISCH — bei jeder Aufgabe beachten)
- **Thesis Kap. 1–4 ist FESTGEZOGEN = das SOLL.** Der Code wird an die Thesis nachgezogen, **niemals umgekehrt**.
- Die **Thesis darf NICHT verwässert** werden, um Code-Ist-Zustände zu rechtfertigen. Wo Code und Thesis abweichen, ist der Code-Ist ein **Lag/Defekt**, der zu schließen ist (z. B. I1 `search_engine<>`-Zweittempel, `sota_catalog`-Mapping).
- Einzige Ausnahme: Wo die **Thesis intern in sich widersprüchlich** ist (B/C-Reihen-Drift ch1-FF3 ↔ ch6 sec:series), wird **kein Code-Label gesetzt**, bis Text-Agent/User die Thesis-interne Drift auflösen.
- **Messdaten werden NIE gelöscht.** ABI/Schema darf brechen, alte Mess-CSV bleiben erhalten (separate Build-Version-Dateien).
- **Lehrbuch-Design-Patterns** (benannte GoF-/erweiterte Muster) + zero-cost-Metaprogrammierung; musterlose Strukturen sind verboten.

---

## Abschnitt A — KONSOLIDIERTE OFFENE IMPL-AUFGABEN (dedupliziert, gruppiert)

> Legende Status: **offen** = aktionierbar / **blockiert(<Grund>)** = wartet auf Vorbedingung / **evtl-erledigt** = Datei/Commit existiert, nur Verifikation offen / **in_progress** = Apparat steht, Rest gated / **bereits getrackt** = als Task #xxx in der Task-DB.

### A.1 — Architektur / I1 (EINE Architektur: Lebewesen ≡ SearchAlgorithm)

#### A.1.1 — Code-Lag #1 (I1): `search_engine<>` → EINE Lebewesen-Hierarchie · **bereits getrackt #176** · höchste Prio
- **Was tun:** `search_engine<Collection,ConfigPermutation>` erbt von `execution_engine<>` und bildet einen **zweiten, unverbundenen Template-Baum** desselben SearchAlgorithm-Lebewesens neben `SearchAlgorithmAnatomy`/`SearchAlgorithmAbiAdapter` (die korrekt über `IAnatomyBase → IExecutionEngine` laufen). **Soll:** GENAU EINE Hierarchie — die ABI-Such-Sicht ausschließlich über `SearchAlgorithmAbiAdapter<A> : IAnatomyBase` über der Anatomie. `search_engine<>` **entweder entfernen ODER** zu reinem compile-time Kompositions-Helfer (`search_composition_template`, KEINE virtuelle Klasse, KEINE eigenen Achsen) umbauen. Duplizierte Achsen-/Slot-Verwaltung + die **3 nebeneinanderliegenden Container-Instanzen** entfernen; `observe_all()` real über alle 19 Achsen nur aus der Anatomie; **eine** Container-Instanz.
- **Code-Orte:** `libs/cache_engine/include/cache_engine/abi/search_engine.hpp:19-21` **(2026-06-25 verifiziert noch im Defekt-Zustand:** `class search_engine : public execution_engine<...>`**)**; `libs/cache_engine/anatomy/abi_adapter.hpp:119` + `:124-125`; `libs/cache_engine/anatomy/search_algorithm_anatomy.hpp:32`.
- **NICHT anfassen:** Namespace `comdare::cache_engine::search_engine::...` (das sind Achsen-Topics, kein Klassenname).
- **Status:** offen — **zusammen mit A.1.2 umsetzen.**
- **Quelle:** cache-engine `docs/docs/sessions/20260625-UEBERGABE-impl-agent-ch4-grounding-codelag.md` + `…/20260620-UEBERGABE-impl-agent-EINE-ARCHITEKTUR-vereinheitlichung.md`; thesis `…/2026-06-22-UEBERGABE-kontext-thesis-konsolidierung.md`.

#### A.1.2 — Code-Lag #2: `search_engine` → variadisches `SearchEngine` (CamelCase, `class... Ts`) · **bereits getrackt #177 (Teil von #176)**
- **Was tun:** Der lowercase-snake-case Identifier `search_engine` (2 fixe Typ-Params) zum Thesis-Namen `SearchEngine` (CamelCase, `template<class... Ts>`) als abstrakte ABI-Laufzeit-Sicht über `SearchAlgorithmAbiAdapter` konsolidieren/umbenennen — passend zur **variadischen Hybrid-API** (1 Param ⇒ `vector`, 2 ⇒ `map`, N>2 ⇒ `map<K,tuple>`). **Vorbild bereits konform:** `prt-art/.../prt_art_search_engine.hpp` (`PrtArtSearchEngine<Ts...>`) bleibt.
- **Code-Ort:** `libs/cache_engine/include/cache_engine/abi/search_engine.hpp:19-21`. ch4 `fig:abi` (Z.244) **NICHT** auf den realen lowercase-Namen herabsetzen (Thesis ist Soll).
- **Status:** offen — Teil von A.1.1.
- **Quelle:** cache-engine `…/20260625-UEBERGABE-impl-agent-ch4-grounding-codelag.md`.

#### A.1.3 — prt-art V8.9: `PrtArtSearchEngine` von `comdare::search_engine`-ABI erben lassen (= #176/#177 prt-art-Seite)
- **Was tun:** Der Prüfling-Identity-Header ist weiterhin eine eigenständige hybride Identity-Klasse (REV 7, namespace `comdare::prt_art::identity`, `struct PrtArtComponents` + zwei Spezialisierungen) **OHNE ABI-Vererbung**. Soll laut V8-Handover: `PrtArtSearchEngine<...Ts> : public comdare::search_engine<search_algorithm_type_collection<Ts...>, PrtArtConfigurationPermutation>` (`#include <cache_engine/abi/search_engine.hpp>`). **Deckt sich exakt mit A.1.1/A.1.2** — zusammen umsetzen, nachdem die cache-engine-ABI konsolidiert ist.
- **Akzeptanz:** Compile-Test, 51 Identity-Tests bleiben grün.
- **Code-Ort:** `prt_art/include/prt_art/identity/prt_art_search_engine.hpp:1-60` (search_engine-include fehlt; nur `fixed_length_fingerprint.hpp` eingebunden).
- **Status:** offen (an A.1.1/A.1.2 gekoppelt).
- **Quelle:** prt-art `docs/sessions/20260514-0900-v8-prt-art-abi-inheritance.md`.

#### A.1.4 — prt-art V8.11: `TestDataSetAccumulationEngine` in den `PrtArtSearchEngine`-Konstruktor verdrahten
- **Was tun:** Constructor von `PrtArtSearchEngine` soll `comdare::TestDataSetAccumulationEngine<PrtArtSearchEngine>& dataset_engine` als Konstruktor-Parameter aufnehmen und als Member halten (Testdatensätze bei Initialisierung der SearchEngine einlesen, Master §10.11). Aktuell hält die Klasse nur `PrtArtComponents`. **Reihenfolge laut Handover:** erst V8.9 (A.1.3, ABI), dann V8.11 (dieser Punkt), dann V8.10 (V8.10 = `algorithm_profiles/` ist **bereits erledigt**).
- **Code-Ort:** `prt_art/include/prt_art/identity/prt_art_search_engine.hpp`.
- **Status:** offen (nach A.1.3).
- **Quelle:** prt-art `…/20260514-0900-v8-prt-art-abi-inheritance.md`.

#### A.1.5 — prt-art: Submodule-Pin `external/comdare-cache-engine` auf aktuellen HEAD bumpen (Vorbedingung für jede prt-art-Code-Änderung)
- **Was tun:** Der eingebettete Submodule-Pin zeigt auf `fe0a864f` (V33.E, 2026-05-21) und ist in `git status` als modifiziert markiert (` M external/comdare-cache-engine`). Die aktive cache-engine-Entwicklung (OneDrive-Primärklon, bis 2026-06-25: m3v2, #167–#178) liegt **weit davor**. **Pin auf aktuellen cache-engine-HEAD bumpen** und prt-art gegen die neue ABI bauen/testen. **ACHTUNG:** Vor JEDER prt-art-Code-Änderung erst bumpen, sonst baut man gegen die alte V33-ABI.
- **Status:** offen — **Vorbedingung für A.1.3/A.1.4 und alle prt-art-Items.**
- **Quelle:** prt-art `…/20260514-0900-v8-prt-art-abi-inheritance.md`.

#### A.1.6 — thesis-Querverweis: `prt_art_search_engine_adapter.hpp` deprecated bei I1-Konsolidierung mitziehen
- **Was tun:** PRT-ART ist ein Prüfling (Anatomie/Composition), der einzelne Achsen-Organe selbst stellt und für die übrigen via `resolve_baustein` auf CE-Standards zurückfällt; die Runtime-Anbindung läuft über einen Execution-Engine-Adapter. `prt_art_search_engine_adapter.hpp` ist **deprecated** (Doc 19). Bei der Code-Vereinheitlichung (TODO-6 / I1) die prt-art-eigene API-Klasse `PrtArtSearchEngine<Ts...>` ggf. mit-konsolidieren.
- **Status:** blockiert (an A.1.1/I1 gekoppelt).
- **Quelle:** thesis `FINDINGS_REV7_6_diplomarbeit.md` (verweist) + `…/2026-06-21-kap4-geruest-eine-architektur.md` (F2).

---

### A.2 — Mess-Pfad / #156-Kette (der EINE umfassende Mess-Lauf)

#### A.2.1 — #156: Der EINE umfassende m3v2-Mess-Lauf (reale Cache-Misses + Reihe C + ≥2 Plattformen)
- **Was tun (Impl-Anteil):** Der finale Voll-Mess-Lauf (320 Tiere + ≥21 SOTA inkl. Reihe C × Zwei-Phasen × Working-Set-Sweep) mit **realen Cache-Misses**. Mess-Pfad code-seitig vollständig vorbereitet: PMC-WIDE-Naht verdrahtet (`make_pmc_source`/`IPmcSource` im `perm_runner`, 7 additive `pmc_*`-cache_misses-Spalten in `lazy_csv_header`, committet `b285002`). Mit `COMDARE_ENABLE_PMC=ON` Drop-in real. Laut PIVOT-Plan läuft der Lauf direkt auf den prod-GitLab-Bare-Metal-Shell-Runnern `id=16` (prod1/AMD) + `id=17` (prod2/Intel) = PMC-Pfad + 2 Plattformen. **Impl-Aufgabe:** Auswertungs-Pipeline gegen m3v2-WIDE-Schema generalproben (siehe A.2.2); danach bilinguale PDF + finaler G5+§7.4-Re-Audit.
- **Status:** **blockiert** (Infra/Runner-Handoff: GitLab-Namespace+Token+Tags, `perf_event_paranoid`, User-Freigabe Bare-Metal-Weg; **Mess-Pfad code-ready**).
- **Quelle:** cache-engine `…/20260623-PIVOT-PLAN-156-GITLAB-RUNNER-PROD.md` + `…/GOAL-AUTONOM-ABARBEITUNG-20260613.md §9.3/§9.5`.

#### A.2.2 — PIVOT Phase F (Impl): Auswertungs-Pipeline auf m3v2-WIDE-Schema generalproben · **gate-frei**
- **Was tun:** Vor dem #156-Lauf: `csv_to_latex`/`diagram_generator` header-getrieben auf das m3v2-Schema generalisieren und gegen einen Klein-Pilot durchprobieren (zusätzliche Spalten `seg_coverage`/`CLU`/`series`/`working_set_n` + SOTA-/CLU-/Working-Set-Tabellen). Die Generatoren `write_sota_series_table` / `write_working_set_sweep` / `write_sweep_axis` / `write_seg_coverage` existieren bereits; L8 `generate_wide_appendix.ps1` hat den m3v2-Schalter. **Aufgabe = End-to-End gegen reales m3v2-CSV durchprobieren**, damit der Voll-Lauf direkt auswertbar ist.
- **Status:** **offen (gate-frei**, gegen Klein-Pilot generalprobbar; voller Nutzen erst mit #156-Daten).
- **Quelle:** cache-engine `…/20260618-OFFENE-TODOS-LEDGER.md` (#156-Prep) + `…/20260623-PIVOT-PLAN-156-GITLAB-RUNNER-PROD.md` Phase F.

#### A.2.3 — #162 / P-MD6: PRT-ART + ≥8 Rang-1-SOTA-Lebewesen + Messreihen A/B/C in den Voll-Lauf
- **Was tun:** Tag-/Selektions-Apparat + Reihen A/B + axis_sweep sind code-seitig **REAL gebaut und probe-gemessen** (`sota_catalog.hpp` baut alle 6 SOTA + PRT-ART + B/C probe-belegt). Verbleibend code-seitig: **Reihe C** (`Stufe3_FullJoin` Prüfling-Repräsentant der Union, `MasstreePrtStufe3FullJoinComposition` vorhanden) vollständig + **Voll-Skalierung** — beides an A.2.1 (#156) gebunden. Ohne diese Reihen ist Forschungsfrage **FF3 nicht adressiert**.
- **Code-Orte:** `tests/unit/thesis_tiere/sota_catalog.hpp` (S6a/S6b); `02_messung_driver/main.cpp:108-118`.
- **Status:** in_progress (Apparat fertig; Reihe C + Voll-Skalierung gated auf #156).
- **Quelle:** cache-engine `…/GOAL-AUTONOM-ABARBEITUNG-20260613.md §9.3` + `…/20260618-OFFENE-TODOS-LEDGER.md`.

#### A.2.4 — prt-art: SOTA-Skelette P11–P27 (legacy_reimpl) zu echten Lebewesen ausbauen (Voraussetzung für A.2.3/#162)
- **Was tun:** Die 14 `legacy_reimpl`-Verzeichnisse (P11-CSS, P12-CSB, P13-Hankins, P14-Samuel, P16/P17-Bender, P18/P19-Saikkonen, P21/P22-Chen, P23-Khan, P24-NaderanTahan, P26/P27-Zhang) enthalten je genau EIN Header von 54–110 Zeilen — Concept-anchored **Skelette** ("Status: SKELETT (Phase 4.B Vorbereitung)"; README P27: "C++23-Implementation" + "Adapter an Bausteine-Matrix-Achse Prefetch" noch zu tun). Das sind die **Rang-1-SOTA-Lebewesen**, die #162 für FF3 braucht.
- **Code-Orte:** `prt_art/legacy_reimpl/P*/include/*.hpp`.
- **Status:** offen.
- **Quelle:** prt-art `docs/sessions/20260512-2300-prt-art-vollausbau-rev6.md`.

#### A.2.5 — prt-art: `lookup/insert/erase/range_scan` echt implementieren (Stubs ersetzen) + codegen-Body-Template entstubben
- **Was tun:** REV6-Session listet als "noch nicht erledigt": echte Implementation von `lookup/insert/erase/range_scan` (aktuell Stubs, "Phase 7"), Signaling-Bits-Serialisierung (1+ser_length+payload), ABI-stabiles C++23-Modul-Interface (POD + function pointers) und CacheEngineBuilder-Integration (PRT-ART als Binary kompilieren). Konsistent dazu ist das Codegen-Body-Template `prt_art/codegen/templates/prtart_body.hpp.template` (73 Zeilen) **noch ein Stub** ("Storage-Stub: in Folge-Phase V18+", "Pruefling-Stub: simuliert Hot-Path-Hits", "Pruefling-Stub-Wert: **90 ns/op**"). Für einen **echten Mess-Lauf** muss dieser Pfad **reale Anatomie statt fixer ns-Werte** liefern.
- **Status:** offen — **mess-validitäts-kritisch** (sonst liefert der Prüfling im Lauf fixe 90 ns/op).
- **Quelle:** prt-art `…/20260512-2300-prt-art-vollausbau-rev6.md`.

#### A.2.6 — Phase B `LinuxPerfPmcSource` (`perf_event_open`) · **evtl-erledigt**
- **Was tun / Stand:** Der PIVOT-Plan listete Phase B (LinuxPmcSource für reale Cache-Misses auf Linux) als "GO SOFORT, infra-unabhängig". Inzwischen existiert `libs/cache_engine/builder/linux_perf_pmc_source.hpp` (329 Zeilen, echte `perf_event_open(2)`-Implementierung hinter `#if COMDARE_ENABLE_PMC && __linux__`, in `pmc_source_factory.hpp` verdrahtet; committet `47fef0f` "Phase B (#152/CE-DL2)"). Dieser Code-Lag-Punkt **erscheint erledigt** — nur die finale Validierung mit realen Countern auf `id=16/17` steht aus (gehört zu #156). Hier gelistet zur Vermeidung von Doppelarbeit.
- **Status:** evtl-erledigt (Datei + Factory-Zweig vorhanden, committet `47fef0f`; reale Counter-Validierung = #156).
- **Quelle:** cache-engine `…/20260623-PIVOT-PLAN-156-GITLAB-RUNNER-PROD.md` Phase B.

#### A.2.7 — super: GOAL-Mess-Abstraktion I5–I9 (PCM/PAPI-Quellen, ArchEvaluator, Plattform-Fit, ZIH-Precompile)
- **Was tun:** Rückgrat I1–I4 (EIN Mess-ABI-POD, `IMeasurementSource`/`WallClockSource`, Dock-DI + `pull_live_counters`, `result_aggregator` 16+6) gilt als abgenommen. Verbleibende Inkremente: **I5** Intel-PCM-Source (gated auf User-MSR-Treiber-Setup) bzw. ARM-PAPI; **I6** ArchEvaluator am Prüf-Dock (ISA-Kostenmodell AMD/Intel); **I7** Plattform-Fingerprint + `platform_fit_check.cmake` (Rebuild bei Plattform-Mismatch); **I8** `precompile_mode.cmake` (NORMAL/PRECOMPILE/PRECOMPILED) + `precompile_batch_builder` für ZIH (run+measure ohne Compile); **I9** restliche Vendor-Quellen. **Event-Codes pro Event web-verifizieren.**
- **Status:** blockiert (I5 PMC-Treiber-Setup + Plattform-Hardware; **I6–I9 code-seitig baubar**).
- **Quelle:** super `docs/sessions/20260531-gesamtkontext-maschinerie-und-goal.md`.

#### A.2.8 — super: Mess-Pfad-Restwellen (Cache-Misses real + Per-Achsen-Sweeps + Multi-Plattform)
- **Was tun:** Mehrere mess-validitäts-nahe Code-/Lauf-Punkte, gegated auf Linux+PMC und ≥2 Plattformen: **L-h** Cache-Misses (Kernmetrik aktuell 0, PMC nicht angebunden, fehlt in M3-WIDE); **P-MD5** SIMD/ISA + Allokator als variierte Achsen + ≥2 Plattformen (Hybrid + Sapphire Rapids); **P-MD2/8/9** quiesziertes Experiment-OS + Per-Zeilen-Quality-Flag + winsorisierte/Perzentil-Ausgabe; **M3-Neumessung** (EIN umfassender Lauf mit echten Cache-Misses/prefetch + 9 vertiefte Achsen-Sweeps). `WindowsPcmPmcSource`-Code (#153) existiert bereits; verbleibend = echte Anbindung + Lauf. **(Überschneidet sich mit A.2.1/#156 und A.3.x.)**
- **Status:** blockiert (Linux+PMC-Hardware + ruhiges Experiment-OS; Code-Anbindung teils vorhanden).
- **Quelle:** super `…/20260531-gesamtkontext-maschinerie-und-goal.md`.

#### A.2.9 — #165-Code-Rest: Per-Zeilen-Quality-Flag-Provenienz / winsorisierte Ausgabe (Post-Analyse-Hälfte)
- **Was tun / Stand:** P-MD2/8/9: Die statistische Hälfte (`winsorized_mean_ns` + additive `quality_flag`-Spalte, datenerhaltend) ist **code-seitig erledigt** (committet `d60f7b0`). Verbleibend code-seitig: `system_disturbed`-Provenienz des `quality_flag` bei quiesziertem Lauf — hängt aber am **Infra-Anteil** (quiesziertes Experiment-OS = Infra). Reiner Post-Analyse-/Flag-Code ist Impl-Bereich; OS-Quiescing nicht.
- **Status:** blockiert (Infra: quiesziertes Experiment-OS; **Statistik-Code-Hälfte erledigt**).
- **Quelle:** cache-engine `…/GOAL-AUTONOM-ABARBEITUNG-20260613.md §9.3-A (#165 HELD-Teil) + §9.2`.

#### A.2.10 — `search_organ_`-Monolith: Such-Zähler uniform durch ALLE Organe treiben (Mess-Echtheit)
- **Was tun:** Im finalen ABI-Mess-Pfad treibt der `search_organ_`-Monolith die Such-Zähler **noch nicht uniform** durch alle Organe (Doc 34 §9 Befund 2 / Q2-Schritt-4, E-Welle-A2 OFFEN). Architektonisch ist die Hash-Sezierung sauber, aber die **Mess-Echtheit** der späteren Belege ist betroffen. **Identisch mit der OFFEN-Teilmenge von A.4.1 / TODO-7 (1)** — dieselbe Code-Stelle.
- **Code-Orte:** `anatomy/abi_adapter.hpp:910-916`; Guard `tier_search_routes_through_store()==false` bei `:1461`.
- **Status:** offen — **mess-kritisch**.
- **Quelle:** thesis `…/2026-06-15-konzeptionelle-algorithmus-zugehoerigkeit-massgeblicher-hinweis.md (§11)`; cache-engine Doc 34 §9.

---

### A.3 — gate-freie Engine-Erweiterungen & Code-Reife

#### A.3.1 — Code-Lag #3: `sota_catalog.hpp` Stufe→Reihe-Mapping ans ch1-FF3-Mapping · **bereits getrackt #178 (B/C blockiert)**
- **Was tun:** `tests/unit/thesis_tiere/sota_catalog.hpp:18-24` mappt aktuell flach `A=Stufe1_CeOnly` (Lebewesen ISOLIERT/SOTA-solo), `B=Stufe2_PrueflingReplace`, `C=Stufe3_FullJoin` **(2026-06-25 verifiziert noch so im Code)**. Das macht **A fälschlich zur Isolations-Reihe** und widerspricht sogar dem Treiber-Enum `02_messung_driver/main.cpp:108-118` (`A_PrtArtVsSota`/`B_CacheEnginePerm`/`C_MergeAltNeu`). **Soll (ch1 FF3):** `A` = Prüfling vs. Stand-der-Technik gespeist aus **Stufe 1 UND Stufe 2 gemeinsam**; `B` = `Stufe3_FullJoin`; `C` = build-übergreifend (Merge/Regression alt-vs-neu).
- **VORBEDINGUNG:** Die **Thesis-interne B/C-Drift** zwischen ch1 FF3 und ch6 sec:series muss **Text-Agent/User zuerst auflösen** → finale B/C-Code-Labels sind bis dahin **blockiert**. **Der A-Teil (A = Stufe1+Stufe2) ist überall gleich und kann SOFORT korrigiert werden.** ch4 NICHT ändern (bereits Soll).
- **Code-Orte:** `sota_catalog.hpp:18-24`; `02_messung_driver/main.cpp:108-118`.
- **Status:** blockiert (Thesis-interne B/C-Drift ch1-FF3 vs. ch6 zuerst auflösen; **A-Teil sofort machbar**).
- **Quelle:** cache-engine `…/20260625-UEBERGABE-impl-agent-ch4-grounding-codelag.md`; thesis `…/2026-06-24-PLANUNG-kapitel-4-zielstruktur.md (§4/§5.3)`.

#### A.3.2 — super V41.A1/A2.1: Allokatoren mit Voll-Präzision echt linken (jemalloc/tcmalloc/hoard/scalloc)
- **Was tun:** Permutationen mit `alloc=jemalloc/tcmalloc/hoard/scalloc` fallen aktuell auf `std::malloc` zurück (sichtbar als `(real=std)` im Plugin-Output). Nur `mimalloc` (`src/static.c`) + `snmalloc` (header-only) sind echt eingebunden. Alle 7 Allokator-Variants mit echtem Library-Link im Hot-Path einbinden (jemalloc: MSYS2 `autogen.sh` ODER vcpkg ODER pre-generierte Header; tcmalloc: Abseil+`ext/A06` vendored; hoard: `add_subdirectory(ext/A01-hoard)`; scalloc: CMake-Port für `ext/A08` statt gyp).
- **Akzeptanz:** Plugin-Output zeigt `(real=<allocator>)` statt `(real=std)`.
- **Status:** blockiert (Windows-autoconf/vendored-Build-Toolchain; **auf Linux/ZIH uneingeschränkt baubar**).
- **Quelle:** super `docs/sessions/20260524-V41-open-todos.md`.

#### A.3.3 — super V41.G.1: Plugin-Loader + messung_driver hierarchisch über Achsen-Baum iterieren · **evtl-erledigt (#18)**
- **Was tun:** Der Achsen-Ordnerbaum im Build-Output existiert (`perm/cache_engine/simd_<v>/layout_<v>/…`), aber `plugin_loader.hpp` iteriert flat via `recursive_directory_iterator` und `messung_driver` sortiert nur alphabetisch nach `perm_id`. (1) Plugin-Loader-Result-Liste baumartig machen (`tree<axis-level, vector<LoadedPlugin>>`); (2) messung_driver-Output hierarchisch gruppieren; (3) `permutation_stats.csv` um Achsen-Ebenen-Spalten erweitern; (4) Welch-Vergleiche pro Achsen-Subtree. **Reine UX/Auswertbarkeit, keine Operationalitäts-Änderung.** Task #18 ist als completed markiert — **im Zweifel literal verifizieren.**
- **Status:** evtl-erledigt.
- **Quelle:** super `…/20260524-V41-open-todos.md`.

#### A.3.4 — super GOAL-V6 Phase D: Mixed-Genus-Vollausbau (Set/Sequence/Adapter/View) · **evtl-erledigt (#74–77/#80–82)**
- **Was tun:** GOAL V6 verlangt literal belegte Vollständigkeit gegen ALLE 22 Achsen UND ALLE 5 Lebewesen-Unterklassen, je Gattung über EIGENE Komposition/Anatomie/Prüf-Dock, registry-getrieben, jedes statische Blatt = baubare Binary, jeder gemessene Knoten = echter per-Achsen-Observer. IST (Stand goal-v6): SearchAlgorithm-Gattung voll, Container minimal, `page_type`/`simd_extension(09b)`/`general_hardware(12)` nur DefinitionOnly ohne echten Observer/Build-Variante, Container-q2 ungebunden, nur 2/5 Gattungen gebunden, `ceb_generator` = `#define`-Hülle. Tracker zeigt #74-#77/#80-#82 inzwischen completed — **gegen die literalen Gate-Kriterien (Gate-3/Gate-4 ohne Pilot-/R5.B-Vorbehalt) verifizieren und Restlücken schließen.**
- **Status:** evtl-erledigt.
- **Quelle:** super `docs/sessions/20260602 goal-v6-permutations-baum.txt`.

#### A.3.5 — super GOAL-V6 Phase E: finaler adversarialer Vollständigkeits-Audit
- **Was tun:** Nach Schließen aller Phase-D-Lücken (A.3.4) ein Audit-Workflow, der die absolute Vollständigkeit gegen literale Evidenz bestätigt (jeder Gate-Punkt, jede der 22 Achsen, jede der 5 Gattungen; kein reklassifizierter oder pilot-/R5.B-vorbehaltener Punkt). **Verifikations-/Audit-Lauf, kein Neubau**; setzt A.3.4 voraus.
- **Status:** blockiert (setzt GOAL-V6 Phase-D-Abschluss voraus).
- **Quelle:** super `…/20260602 goal-v6-permutations-baum.txt`.

#### A.3.6 — #125 / P6: lazy DLL-Bibliothek — inhalts-abgeleitete per-Tier-Versionierung (Content-Hash-Codegen)
- **Was tun:** Pro Tier-DLL eine inhalts-abgeleitete Versionierung via Content-Hash-Codegen, damit identische Anatomien nicht neu gebaut werden und Mess-Daten stabil einer Build-Version zugeordnet sind. Bewusst niedrige Prio / defensibel deferred (kein Blocker für #156, da Resume-Härtung bereits existiert). **(In super als P6 dupliziert — derselbe Strang.)**
- **Status:** offen (bewusst deferred, niedrige Prio).
- **Quelle:** cache-engine `…/20260618-OFFENE-TODOS-LEDGER.md (#125)` + GOAL §9.3-C; super `docs/sessions/20260602 goal-v6-permutations-baum.txt`.

#### A.3.7 — prt-art: `default_lookup` Achsen-Platzhalter-Header anlegen · **evtl-erledigt**
- **Was tun:** `default_lookup/README.md` (V32.1+ Sprint TODO, Z. 40-42) verlangt: "Konkrete Platzhalter-Header-Files anlegen mit Doxygen-Tags + Verweisen auf CE-Bibliothek-Pfade" für die 9 `(default-lookup)`-Achsen aus der Reuse-Matrix (3.B, 6.2 Reclamation, 6.3 NUMA, 6.4 Huge-Page, 8.2 Locking, 9 ISA, 11 Telemetry, 12 Hardware, 13 Scheduling). Teilweise vorhanden (`prt_art_3b/62/63/64/82/9/11/12/13_*.hpp` laut Matrix) — **verifizieren, ob alle 9 real existieren oder nur dokumentiert.**
- **Status:** evtl-erledigt (Existenz aller 9 verifizieren).
- **Quelle:** prt-art `prt_art/include/prt_art/default_lookup/README.md`.

---

### A.4 — Cross-Achsen-Delegation / Code-Lags ch4

#### A.4.1 — TODO-7: Cross-Achsen-Delegation vollständig (Thesis §3.3 "verteilte Interfaces" überall einlösen)
Drei Lücken im distributed-interface-Mechanismus schließen, damit der §3.3-Claim nachweisbar "überall" gilt (Thesis unverändert, nur Code nachziehen):
1. **HART/OFFEN:** Tree/Trie/Hash/k-ary/Eytzinger melden Such-Metriken aus monolithischem `search_organ_` statt über Speicher-Achsen T4/T5/T6 → restliche Such-Organe wie den composed-Pfad über die Storage-Achsen führen, `search_organ_`-Sonderpfad entfernen (`anatomy/abi_adapter.hpp:910-916`, Guard `tier_search_routes_through_store()==false` bei `:1461`; deckt Doc 30 Q2 Schritt 4 = OFFEN). **= A.2.10**, dieselbe Code-Stelle — zusammen erledigen.
2. **REVIEW:** T1 `cache_traversal` + T2 `mapping` führen redundanten Eigen-Zustand (`abi_adapter.hpp:704-710`, `:769-773`) → entweder Store-Resolution treiben + Doppelzustand entfernen ODER als self-contained-by-design dokumentieren.
3. **PARTIELL:** T15 `migration_policy` echter 2-Tier-Blockmove nur über `container_tier1_` → reicheren LayoutAware-Pfad für Default-Tiere nachziehen (`axis_04_node_type_layout_aware_store.hpp:273`, `abi_adapter.hpp:1528-1574`).
- **Status:** offen.
- **Quelle:** cache-engine `…/20260619-HANDOUT-impl-agent-profile-pruefling-ziele-tabellenbreite.md (TODO-7, ergänzt 2026-06-23)`.

#### A.4.2 — ch4 code-abhängige Fakten verifizieren/liefern (Kap-4-Ausbau)
- **Was tun:** Bevor der Text-Agent ch4 §4.4/4.5/4.6/4.7/4.8 in die Tiefe füllt, muss der Impl-Agent **code-treu liefern/verifizieren**: 19 Hauptachsen-Namen T0–T18 + ~57 Sub-Achsen-Zahl + ~2 Dutzend Allocator-Varianten + `IsComposition`-Concept/`std::variant`-Enumeration (§4.6); ABI-Signaturen `comdare_create_anatomy()->IAnatomyBase`, variadische Spezialisierungen 1/2/N, `IExecutionEngine`-Methoden, 16-Byte-Fingerprint-Struktur (§4.5); Interface-/Klassenbaum `IExecutionEngine`/`IAnatomyBase`/`IVirusExecutionEngine` + 3 Gattungen + Unterklassen Set/Sequence/Adapter/View, keine Metapher in Code-Identifiern (§4.4); PRT-ART überschriebene-vs-geerbte Achsen + `resolve_baustein`-Fallback + `ValueHandle`-Typen (§4.7); M-Modell-Identifier + 7-Phasen-Pipeline-Namen (Enumerate..Persist) + Defined/Full-Modus (§4.3); Builder Profil-Zählung 30=8+22, `ExperimentDriver`-Phasen + 2 opt-in, `HardwareProfile`/Build-Achse-12, Stufen-Identifier (§4.8).
- **Status:** offen — **liefert dem Text-Agenten Grounding-Fakten.**
- **Quelle:** thesis `…/2026-06-24-PLANUNG-kapitel-4-zielstruktur.md (§4)` + `…/2026-06-24-UEBERGABE-3-kap1-3-final-kap4-planung.md (§4)`.

#### A.4.3 — Stufe↔Reihe-Mapping gegen Code-Stufen-Identifier verifizieren (Permutationszahl bestätigen)
- **Was tun:** Mapping aus §4.8 gegen die realen Stufen-Identifier im Code prüfen: Stufe 1 (SOTA) + Stufe 2 (Prüfling) → Reihe A; Stufe 3 (Full Join) → Reihe B; Reihe C (Merge/Regression alt-neu) = **build-übergreifend, NICHT stufengebunden**. Zusätzlich: **Zahl-Widerspruch klären** 10^11 (brutto vs. netto) — der Autor hat ~10^14 (19 Achsen kartesisch) selbst nachgerechnet; **exakte Zählung bestätigen.** Entspricht A.3.1 / #178 (`sota_catalog.hpp` Stufe→Reihe, B/C-Label blockiert bis Thesis-Drift gelöst).
- **Status:** offen (A-Teil sofort; B/C an Thesis-Drift gekoppelt).
- **Quelle:** thesis `…/2026-06-24-PLANUNG-kapitel-4-zielstruktur.md (§4/§5.3)`.

#### A.4.4 — Code-Rename `CrystallineAllocator` → `CrystallineReclamation` (falls Engine-Klasse so heißt)
- **Was tun:** Im Thesis-Text wurde A17 `\texttt{CrystallineAllocator}`→`\texttt{CrystallineReclamation}` korrigiert (Crystalline = wait-free **Reclamation**-Schema, kein Allokator; Nikolaev/Ravindran). **Falls die Engine-Klasse im cache-engine-Code tatsächlich `CrystallineAllocator` heißt, analoger Code-Rename fällig.** Prüfen + ggf. umsetzen.
- **Status:** offen.
- **Quelle:** thesis `…/2026-06-24-UEBERGABE-2-anhang-d-footer-zitate-vollstaendig.md (§4 Pkt.8, §6)`.

#### A.4.5 — `Std_Malloc`-Allokator-Klassenname vereinheitlichen (`_Allocator`-Suffix) + im 2. A-Korpus-Block führen
- **Was tun:** A22a `\texttt{Std_Malloc}`/`StdMalloc` trägt im Gegensatz zu anderen Allokator-Wrappern **KEIN `_Allocator`-Suffix** und fehlt im zweiten A-Korpus-Block. Der Text-Agent hat den Namen bewusst belassen, weil der C++-Klassenname nicht aus dem Repo verifizierbar war. **Realen Klassennamen prüfen und ggf. konsistent benennen**, damit Code und Anhang-D-Tabelle übereinstimmen.
- **Status:** offen.
- **Quelle:** thesis `…/2026-06-24-UEBERGABE-2-anhang-d-footer-zitate-vollstaendig.md (§6)` + `…/2026-06-24-UEBERGABE-anhang-d-konsolidierung-zitate-metapher.md (§5)`.

#### A.4.6 — AP-CE2: Nicht-YCSB-Workload-Frameworks als Workload-Achse in den Code einbauen
- **Was tun:** Die Nicht-YCSB-Frameworks (TPC, SOSD, reale String-Korpora url/dna/protein/xml/tpcds-id/trec-terms, SPEC/CloudSuite-Profile, Allokator-Benches wie mimalloc-bench) als **Workload-Achse** real einbinden — damit ch2.4.2/ch3 die Frameworks (Plural) abdeckt. Bib via AP-Z1/Z2 (Cooper2010 YCSB, Kipf/Marcus SOSD, TPC, SPEC, mimalloc-bench).
- **Status:** offen (Impl-Revier cache-engine-Repo).
- **Quelle:** thesis `…/2026-06-16-kap3-instanz-mapping-survey.md` + `…/2026-06-16-UEBERGABE-3-abschluss-kap1-3-protrusionen-todo.md (§3, #84)`.

#### A.4.7 — AP-CE1: cache-engine-Entwickler-Doku "function-handle-hops" schreiben
- **Was tun:** Entwickler-Dokumentation der "function-handle-hops" (#83 AP-CE1) im cache-engine-Repo. Reine Doku-/Code-Aufgabe an den Impl-Agenten delegiert (nicht Text-Agent).
- **Status:** offen.
- **Quelle:** thesis `…/2026-06-16-UEBERGABE-3-abschluss-kap1-3-protrusionen-todo.md (§3, #83)`.

#### A.4.8 — cache-engine Doku/XML-Lag: superseded Einträge korrigieren (P20 LeanStore + 11-Achsen-REV7.6)
- **Was tun:** Im cache-engine-Repo: `docs/bausteine/03_cross_paper_konzeptmatrix.md` Z.152 "P20 LeanStore" und `permutation_axes.xml` "11 Achsen REV7.6" sind **SUPERSEDED** (P20 ist jetzt `mueller2025btreesback`; Achsenzahl ist **19 T0–T18**, nicht 11). Auf aktuelles Doc-34-Vokabular nachziehen.
- **Status:** offen.
- **Quelle:** thesis `…/2026-06-16-kap3-instanz-mapping-survey.md` (Residuen außerhalb Thesis-Scope).

#### A.4.9 — super V41.E9 / Bug-3: MSVC raw-string-literal Root-Cause in `messung_driver/main.cpp` · niedrige Prio
- **Was tun:** `R"(...)"`-Raw-Strings schlugen in `02_messung_driver/main.cpp` mit C2059 fehl; Workaround = escaped strings. Hypothese: Macro-Pollution aus `windows.h`. Root-Cause untersuchen, Raw-Strings zurückholen wenn möglich. (Workaround stabil.)
- **Status:** offen (niedrige Prio).
- **Quelle:** super `…/20260524-V41-open-todos.md`.

#### A.4.10 — super V41.E1: `gtest_discover_tests` Post-Build-Warning (MSB3073) unterdrücken · **evtl-erledigt** · Quick-Win
- **Was tun:** MSBuild zeigt MSB3073 "error" beim GoogleTest-Discovery-Schritt, obwohl Build+Test durchlaufen. `gtest_discover_tests(... DISCOVERY_MODE PRE_TEST / PROPERTIES TIMEOUT 60)` setzen oder POST_BUILD-Discovery weglassen, damit der Scheinfehler verschwindet.
- **Status:** evtl-erledigt.
- **Quelle:** super `…/20260524-V41-open-todos.md`.

---

### A.5 — Blockiert: needs_user-Entscheid (kein Code-Umbau bis Entscheid)

#### A.5.1 — K1: RC-Dimension — Organ-Hooks bauen ODER ehrlich entfernen
- **Was tun:** Die Resource-Control-Dimension setzt `applied_rc_` und klammert an die Caps (`abi_adapter.hpp:175`, `:195-196`), aber die Caps sind identisch ⇒ **RC ist mess-technisch wirkungslos**. User-Entscheid nötig: entweder echte Organ-Hooks bauen (RC wirkt auf die Achsen-Organe) ODER die Dimension **ehrlich aus dem Mess-Pfad entfernen**. Bis Entscheid nominal weitergeführt.
- **Status:** blockiert (needs_user-Entscheid).
- **Quelle:** cache-engine `…/GOAL-AUTONOM-ABARBEITUNG-20260613.md §9.3-B (K1)`.

#### A.5.2 — A5: Second-Execution vs. Zwei-Phasen-Mess-Pflicht
- **Was tun:** Nur Optionen dokumentiert; Zwei-Phasen-Treiber (save-all → op-warmup → rollback-all → op-measure) bleibt **Pflicht**, bis der User zwischen Second-Execution und Zwei-Phasen-Pflicht entscheidet. Kein Code-Umbau bis Entscheid.
- **Status:** blockiert (needs_user-Entscheid).
- **Quelle:** cache-engine `…/GOAL-AUTONOM-ABARBEITUNG-20260613.md §9.3-B (A5)`.

---

### A.* — Bereits erledigt / ausgeschlossen (NICHT erneut aufnehmen)
- **cache-engine:** TODO-1..4 des 0619-Handouts (SOTA-Profile P01–P33, abstract/full-Prüfling-Spalte, 3 Ziel-Versprechen inkl. `CacheLinePolicySelector` + `write_load_profile_xml`, Tabellenbreite `\textwidth`) umgesetzt (#170–175); TODO-5 **verworfen/ersetzt** durch TODO-6 (nicht führen); P33 (VAMPIR/NFP) = **Text-Agent-Task**, nicht Impl. Gate-freier Stand = 0 actionable (Re-Audit wvxmwhvlx); G1–G4 gegen cowfix-v1 grün.
- **prt-art:** V8.10 `algorithm_profiles/` (README + `prtart_pruefling.profile.xml` + `permutation_axes_extension.xml`); REV6-Grundausbau (129 Tests grün); V34.E LeafOnlyCounter.
- **super:** §7-Block (#717–736 R7.x/R8/Paper, V41.E/F E10/E11/F.2–F.6, KF-1..16, BR-1..4, V5-I1..I10, Phase-A/B-Observer, INC, XML-Lastprofile) — durchgängig completed.
- **thesis:** Anhang-D-Zitate, Kap.1–3 final, ch4-CODE-UNABHÄNGIGE Blöcke (Commits ee873b6/9a1e2f3/37c8efc), AP-Z1/Z2/AP-EN.
- **Reine INFRA (an Infra-Agent K78 CE-DL1..DL5 delegiert, NICHT hier):** #152/#163 HW/PMC-Treiber, PIVOT Phase A (Dual-Remote GitLab+GitHub, Tokens, Namespaces), Phase C (GitLab-CI-Pipeline-Bau), CI-Stage-Commits (6e50a6f, 1046587), quiesziertes Experiment-OS, ZIH/Cluster (#10/#24), V41.C1/C2, V41.B4.1 (MinGW/ESET).
- **Reine TEXT (an Text-Agent):** Diplomarbeit-Volltext, Bausteine-Matrix-Doku, MASTERPLAN_KONSOLIDIERUNG_TERMINE (K-A..K-J), AP-X2/TODO-1..4.

---

## Abschnitt B — NEUE USER-ANFORDERUNGEN (2026-06-25)

> Diese drei Arbeitspakete sind **neu** und nicht in der bestehenden Task-DB. Sie sollen als große, eigenständige Tasks angelegt werden (B1/B2/B3).

### B1 — Wartbarkeits-/Lesbarkeits-Sweep ALLER C++-Dateien aller 4 Projekte (Datei für Datei)

**Ziel des Users:** "Ich will mich durchklicken." — Jede C++-Datei soll so kommentiert, gegliedert und objektorientiert strukturiert sein, dass man sie ohne Vorwissen durchnavigieren kann.

**Umfang:** ALLE `.hpp`/`.cpp` (auch `.hpp.template`, `.ipp`, `.inl`) in:
- `Code/external/comdare-cache-engine`
- `Research/comdare-prt-art`
- super-Diplomarbeit Code-Anteile (`02_messung_driver`, Plugin-Loader, Generatoren etc.)
- (Submodule cache-engine/prt-art werden über ihre Repos, nicht doppelt, bearbeitet.)

**HARTE Randbedingungen:**
- **KEINE Verhaltensänderung.** Reines Refactoring/Kommentieren; Semantik bit-identisch.
- **Build bleibt nach JEDER Datei grün** (inkrementell, nicht am Ende).
- **Messdaten/CSV/ABI-Verhalten unangetastet** (Refactor darf ABI nicht versehentlich brechen — wenn doch nötig, separat als ABI-Task führen, nicht im Sweep).
- **Lehrbuch-Design-Patterns** benennen, wo ein Pattern entsteht (kein musterloser Wrap).

**Systematisches Datei-für-Datei-Vorgehen (vorgeschlagen):**
1. **Inventar je Projekt:** Glob aller `.hpp/.cpp/.template` → Liste mit Pfad, Zeilenzahl, grober Rolle (ABI / Anatomie / Achsen-Organ / Builder / Treiber / Test / Codegen).
2. **Priorisierte Reihenfolge:** (a) ABI-/Architektur-Kern zuerst (`search_engine.hpp`, `abi_adapter.hpp`, `search_algorithm_anatomy.hpp`, `execution_engine*.hpp`) — höchster Durchklick-Wert; (b) Achsen-Organe T0–T18; (c) Builder/Treiber/Generatoren; (d) prt-art Identity + legacy_reimpl; (e) Tests/Codegen-Templates zuletzt.
3. **Pro Datei (immer dieselbe Checkliste):**
   - **Header-Doc-Kommentar** oben: Zweck, Rolle in der Architektur (Lebewesen/Anatomie/Achse/ABI), Haupt-Pattern, Verweise auf Doc-Nummern.
   - **Abschnitts-Gliederung** via konsistenter Banner-Kommentare (z. B. `// ===== Typen =====`, `// ===== Konstruktion =====`, `// ===== Achsen-Delegation =====`).
   - **Funktions-Doc** je nicht-trivialer Funktion (Doxygen `@brief/@param/@return`, Invarianten, Pre/Post).
   - **Spaghetti-Refactor:** lange/verschachtelte Funktionen in **benannte private Methoden/Hilfsklassen** zerlegen (Extract-Method / Strategy / Builder, je nach Fall — Pattern benennen). KEINE Verhaltensänderung.
   - **Build + Tests grün** verifizieren, dann **Commit pro Datei oder kleiner Datei-Gruppe** (siehe Abschnitt C).
4. **Fortschritts-Ledger** (eigene Datei je Projekt oder Abschnitt in diesem Doc): erledigte Dateien abhaken, damit Kontext-Ende-sicher fortsetzbar.

**Status:** NEU / offen. **Sehr groß — als eigener langlaufender Task mit Datei-Ledger.**

### B2 — README / IDE-Einstieg für VS Code UND CLion dokumentieren

**Ziel:** Reproduzierbarer Programm-EINGANG zum Debuggen/Durchklicken — welche Run/Debug-Config, welcher Einstiegspunkt, welche Parameter/Argumente das Programm braucht.

**Liefergegenstände (je Projekt mit ausführbarem Target):**
- **VS Code:** `.vscode/launch.json` (run/debug-Configs je Target, `program`, `args`, `cwd`, `environment` inkl. `COMDARE_ENABLE_PMC`), `.vscode/tasks.json` (CMake-Build-Tasks), `settings.json` (CMake-Kit), Hinweis auf CMake-Tools-Extension. Dokumentation der **CMake-Targets** (`02_messung_driver`, Plugin-DLLs, Tests).
- **CLion:** Run/Debug-Configurations (CMake Application Targets), Programm-Argumente, Working Directory, Environment-Variablen; wie man ein Profil/XML-Argument (Lastprofil `*.profile.xml`, `permutation_axes*.xml`) als Programm-Argument übergibt.
- **README-Abschnitt "Einstieg / Durchklicken":** Welches Target ist der Haupteinstieg (z. B. `02_messung_driver`), welche **Argumente** (Pfad zum Profil-XML, Output-CSV-Pfad, Modus Defined/Full, `--series A/B/C`, Working-Set-Größe), welche **Env-Vars** (`COMDARE_ENABLE_PMC=ON/OFF`), und der minimale "lauffähige" Beispiel-Aufruf.
- **Verifikation:** Argument-Namen/Defaults aus dem realen `02_messung_driver/main.cpp` (Arg-Parsing) ablesen — **nicht raten** (re-greppen, siehe Abschnitt C).

**Status:** NEU / offen.

### B3 — Teilprogramm-Abhängigkeits-Ablaufdiagramm in BAUMFORM

**Ziel:** Ein Baum, der zeigt, welches Teilprogramm/Target von welchem abhängt — von den Einstiegspunkten über die Bibliotheken bis zu den Submodulen.

**Inhalt:**
- **Einstiegspunkte** (executables: `02_messung_driver`, ggf. weitere Treiber/Tools) als Wurzeln.
- → **Bibliotheken** (cache_engine-libs: `builder`, `anatomy`, `abi`, Achsen-Organe; Plugin-Loader; Generatoren `csv_to_latex`/`diagram_generator`).
- → **Submodule** `cache-engine` / `prt-art` / `thesis` und deren interne Target-Abhängigkeiten.
- Quelle der Wahrheit: `CMakeLists.txt`-`target_link_libraries`/`add_subdirectory` + `.gitmodules`. Baum aus den realen CMake-Kanten ableiten, nicht aus dem Gedächtnis.
- Format: ASCII-Baum im README **und/oder** Graphviz/Mermaid-Diagramm.

**Status:** NEU / offen.

---

## Abschnitt C — Reihenfolge-Empfehlung & harte Arbeitsregeln

### Empfohlene Reihenfolge
1. **Zuerst gate-frei und architektur-fundamental:**
   - A.1.1 + A.1.2 (I1 `search_engine<>` → EINE Hierarchie / variadisches `SearchEngine`, #176/#177) — **höchste Prio, zusammen**. Danach A.1.5 (prt-art Submodule-Pin bumpen) → A.1.3 → A.1.4.
   - A.3.1 **A-Teil sofort** (`sota_catalog` A=Stufe1+2), B/C zurückstellen bis Thesis-Drift gelöst.
   - A.4.1 (1) + A.2.10 zusammen (`search_organ_`-Uniformität, mess-kritisch).
2. **Mess-Pfad-Reife (gate-frei):** A.2.2 (Pipeline-Generalprobe), A.4.2/A.4.3 (ch4-Fakten + Permutationszahl), A.2.5 (prt-art Stub-Ersatz, mess-kritisch), A.2.4 (SOTA-Skelette für #162).
3. **Aufräum-/Konsistenz-Quick-Wins:** A.4.4/A.4.5 (Renames), A.4.8 (Doku/XML-Lag), A.4.10 (gtest-Warning), A.3.7 (default_lookup verifizieren), A.3.3/A.3.4 verifizieren.
4. **Neue User-Pakete parallel/danach:** B1 (Wartbarkeits-Sweep, langlaufend, Datei-Ledger), B2 (IDE-Einstieg), B3 (Abhängigkeitsbaum). **B2/B3 lassen sich früh angehen** (kein Code-Risiko) und stützen B1 (man weiß, was wovon abhängt).
5. **Gated/blockiert (warten):** A.2.1/#156 (Infra-Handoff), A.3.2 (Linux-Toolchain), A.2.7 I5/A.2.8/A.2.9 (PMC/OS-Infra), A.5.1/A.5.2 (needs_user), A.3.5 (nach A.3.4).

### Harte Arbeitsregeln (für JEDE Code-Aufgabe)
- **Vor jedem Code-Edit Zeilennummern gegen den aktuellen Submodul-Stand re-greppen.** Alle hier genannten `file:line` sind Momentaufnahmen; sie verschieben sich. (Caveat aus der 0625-UEBERGABE.)
- **Messdaten NIE löschen.** ABI/Schema darf brechen, aber alte Mess-CSV/cowfix-v1 bleiben unverändert; neue Schemata schreiben SEPARATE Dateien (`build_version`).
- **Je Einheit committen + 3-Repo-Submodul-Sync:** nach jedem cache-engine-/prt-art-Push sofort den Diplomarbeit-Submodule-Pointer bumpen (Diplomarbeit-Pointer = aktuelle ce/pa-HEADs; jeder HEAD gepusht). Unter aktivem /goal sind destruktive Ops in den 3 Diplomarbeit-Repos ohne Rückfrage erlaubt, **sofern Tag+Commit+Push** (reversibel); Remotes nie löschen.
- **Build nach jeder Einheit grün halten** (besonders B1).
- **Thesis nicht verwässern:** ch4-Identifier/Figuren bleiben Soll; Code wird hochgezogen.
- **Pattern-Pflicht:** jede neue Struktur = benanntes Lehrbuch-Pattern.

---

## Quellen-Index (Session-Docs)
- cache-engine: `20260625-UEBERGABE-impl-agent-ch4-grounding-codelag.md`, `20260623-PIVOT-PLAN-156-GITLAB-RUNNER-PROD.md`, `20260620-UEBERGABE-impl-agent-EINE-ARCHITEKTUR-vereinheitlichung.md`, `20260619-HANDOUT-impl-agent-profile-pruefling-ziele-tabellenbreite.md`, `GOAL-AUTONOM-ABARBEITUNG-20260613.md`, `20260618-OFFENE-TODOS-LEDGER.md`, Doc 34/36, `architektur-ziele-offene-punkte-ledger.md` (Live-SoT).
- prt-art: `20260514-0900-v8-prt-art-abi-inheritance.md`, `20260512-2300-prt-art-vollausbau-rev6.md`, `default_lookup/README.md`.
- super-Diplomarbeit: `20260524-V41-open-todos.md`, `20260531-gesamtkontext-maschinerie-und-goal.md`, `20260602 goal-v6-permutations-baum.txt`.
- thesis: `2026-06-22-UEBERGABE-kontext-thesis-konsolidierung.md`, `2026-06-24-PLANUNG-kapitel-4-zielstruktur.md`, `2026-06-24-UEBERGABE-*`, `2026-06-21-kap4-geruest-eine-architektur.md`, `2026-06-16-*`, `2026-06-15-konzeptionelle-algorithmus-zugehoerigkeit-massgeblicher-hinweis.md`.

---
*Konsolidiert 2026-06-25. Verifiziert im Code (2026-06-25): `search_engine.hpp:19-21` = Defekt-Zustand bestätigt; `sota_catalog.hpp:18-24` = A=Stufe1_CeOnly-Defekt bestätigt.*
