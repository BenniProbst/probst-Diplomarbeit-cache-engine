# SESSION AUTONOM-03 (2026-07-20, spaet) -- [A]-Strang komplett + S4-KERN FERTIG

> Fortsetzung von AUTONOM-01 + ZWISCHENSTAND-02 + KONTEXT-LOG-VOLL. Vollautonomer A+B-Lauf
> (User-Grant: auch nachts). Je Paket: ultracode-Plan -> Opus-Impl -> Manager-Verifikation ->
> granularer Commit -> Dual-Push -> CI. Modell-Wechsel auf Fable 5 (Architekt) mittendrin --
> Uebernahme nahtlos, Direktiven unveraendert.

## 1. Meilenstein: S4-KERN KOMPLETT (Task #14) + [A]-Strang abgeschlossen
Die gesamte Mess-Schema-Steuerung (User-KERN, "schon immer Gesetz") ist gebaut, verifiziert, CI-grün:
- **KERN-A** (K1-K4/K6): Schema/Parser/validate/Director-Ableitung -- 3 Stufen (CE / je Prüfling replace|merge / kombiniert-fulljoin), per-Achse merge_mode, CacheEngine/identity=self, benanntes `<template>` (mode=full funktional, ref tolerant), phases 1..unbounded + derive, categories/tooling optional.
- **KERN-B** (K6a/K5/K7a): `merge_stamp_line` (DRITTER Tier-Binary-Stempel = Merge-Kombination) · `merge_plan.hpp` (AxisMergeDirective-Naht) · Emitter generalisiert (Katalog-Pfad byte-identisch, Direktiven-Pfad real + dormant) · POD 56->72/layout 2->3 (kleines ABI-Gate, User-GO ①). **CRC64 literal unverändert `0xF1C1F26A1232073B`.**
- **A9**: Registries {run_methodology, measurement_framework, writeback_method} + Struct/Parser/XSD/validate (A9.1+A4) · PILOT-ENV-Ablösung Single-XML (A9.3; Telemetry bewusst NICHT verdrahtet = wäre golden-Byte-Bruch, dokumentierter Folge-Schritt) · 8 Profile WAS/WIE voll + SCHEMA.md inkl. system_axes-Doku (A9.2).

## 2. Alle Landungen dieser Etappe (chronologisch, je CI-grün)
| Paket | ce | super |
|---|---|---|
| S4 KERN-A | c395743e | 614e89f |
| Persistierung #22 (§59 + CHRONIK) | -- | f37043a |
| A1 S3-Resolver produktiv + cacheline-Fix | 7c279c3c | 46b605c |
| A5 §56-T2-FANOUT D4 (Combo-Selektor) | e6257101 | e6262e0 |
| A10 Doku-Nachzüge (§47/§54 + Audit-Abschluss) | -- | 3ddd68a |
| A9.1+A4 / A9.3 / A6 (Dreier-Welle) | 5da2fd4b/67f609d5/a9326342 | 74fa599 |
| A9.2 Profil-Füllung | 97bc930d | 9026e00 |
| A3+A8a (ehrliche Tag-Liste + cmake-Symmetrie) | 7f3ce78b | c7ad515 |
| **KERN-B** (Merge-Stempel/Emitter/POD-72) | 7add41fc | ff2a05e |
| A11 Hygiene (per-K=17 gemessen + K-19-Kommentar + 9 Ledger-Marker) | 81566826/64aec1c0 | f85c87f/f79b538 |

## 3. Wichtige Einzel-Befunde
- **A8 war grossteils schon fertig** (Sweep-Prämisse stale): W7-B CMakeGraphBuilder emittiert seit 19.07. echte Treiber-Kommandos. **Bare-Metal-Re-Beweis an HEAD: MANUAL_RUN §1-§5b, `comdare_tier_build_perm0_chunk0` rc=0, perm.dll=69 == dokumentiert.**
- **A3 ehrlich statt woertlich:** avx512 baut heute GENAU `-mavx512f` -> Job taggt `["avx512f"]` (abgeleitet aus dem realen march-Flag, wächst mit A7/§40.a automatisch); Runner 16 trägt das 13-Flag-Superset. UND-Bedingung = Job fordert exakt was er baut.
- **per-K-Levels: gemessen 17** (nicht 19/nicht 18) -- die 17-Slot-Komposition trägt die per-K-Werte IM search_algo-Slot; stale "17+1"-Doc-Kommentar korrigiert. Lehre: Sonde statt Kommentar-Glauben.
- **A11 ~80% war schon erledigt** (§26-Quick-Wins 4/4, Guard-2^17 via GN-2, K-13-Drift existierte nicht mehr); 9 Ledger-Erledigt-Marker gesetzt.
- **A6 CoR:** `resolve_selection` neu + 4 Seams; Identität strukturell (row=nullopt -> ResumeFilter kann nie reduzieren); echter row-Handler = deferred #156.

## 4. Ausgegliedert / offen
- **#33 9dim-Dach-Rehang + constexpr-Gate** (eigenes Paket; Design-Fork SystemAxis<Derived,Kind> vs. 2 Uniter).
- **#28 A7 W8/§40.a Flag-Modell** (Band-B, koord. S10) -- nächster groesserer Planer-Kandidat nach S5.
- **F27 (User):** welche `experiment_golden.xml` kanonisch (super-Master vs. ce-Kopie)? Sync-Bridge grün, unkritisch.
- **#19-Rest** (Ranges/algo_version/Flags) Band-C; **K7b §58-Array + K8 Storage** Post-Abgabe/Caching; **Telemetry-Profil-Verdrahtung** = bewusst golden-brechender Folge-Schritt (Absprache).

## 5. Naechster kritischer Pfad (Reihenfolge fix)
1. **S5 P-VOLLZUG** (ultracode-Planung gestartet): `emit_measure_job` scharf (COMDARE_RUN_MEASURE), run_methodology=measure -> 1-Thread/CMAKE_BUILD_TYPE, Workload-Sweep ycsb_a..f, EIN CSV; B14-§38-Reste (ProgressSink, ExperimentSubtreePayload, resource_group ceb-measurement-exclusive am dynamischen Job). Gate: measure:smoke literal success (CI + bare-metal).
2. **Ende-zu-Ende-Steuerungs-Verifikation** (XML -> Planer -> CEB -> Tier -> measure:smoke) = das User-Reife-Kriterium ("Wünsche in XML definieren und jenes Ergebnis erwarten koennen").
3. **DANN** (reife-gated) schwere 2^17-Materialisierung (Trigger COMDARE_BUILD_GOLDEN_N=true voll; Runner-Tags stehen; golden=Verifikation, CRC bleibt).
4. **S6** 320er-Messlauf (N>1-Mess-Tooling-Scharfschaltung hier, User-Entscheid ②) -> **S7** Hybrid/M-4/Mess->PDF -> **S8** PDF DE+EN (28.07.).

## 6. Betriebs-Notizen (Kontext-Uebergabe)
Parallel-Agent-Disziplin bewährt: strikte Datei-Whitelists, keine git-Ops in Agenten, eigene Build-Dirs für Schwer-Verifikation (build-a6/build-kernb), Manager committet seriell-selektiv. Ein cf22-Vorschnell-Commit passierte (sofortiger Nachfix-Commit 64aec1c0) -- Regel: cf22-Ausgabe IMMER vollstaendig pruefen VOR git add. Infra-Handover an Infra-Agent liegt in `Cluster/docs/sessions/` (PAT-Rotation #327 dort). main-Stände: ce main=c395743e / super main=f37043a (Band-A-Merge 20.07.; development ist seither weiter -- naechster main-FF beim naechsten Meilenstein).
