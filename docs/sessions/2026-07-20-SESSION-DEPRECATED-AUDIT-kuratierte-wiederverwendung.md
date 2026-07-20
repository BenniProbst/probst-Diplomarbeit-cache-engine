# SESSION DEPRECATED-AUDIT (2026-07-20 spaet) — Kuratierte Wiederverwendungs-Bewertung (Fable, §60-Kurations-Direktive)

> User-Direktive: Opus verwirft bei Unterbrechungen schnell den Turn und filtert schlecht, was deprecated ist;
> Fable kuratiert. Dieses Doc ist die autoritative Kurations-Liste: je Feature Status/Restwert/Wiedereinfuehrungs-Verdikt.
> Quelle: ultracode-Workflow deprecated-features-audit (5 Agenten: Code-Inventar 15 Items, Docs-Inventar, .so-ABI-Tiefensonde,
> Driver/CLI-Tiefensonde, Bewertungs-Synthese). Anforderungen: Ledger §60 (R1/R2/R3).

§60-AUDIT-SYNTHESE (deprecated-Features, Stand 2026-07-20). Eigene Stichproben bestätigt: Payload-Banner (experiment_dock_payload.hpp:58-65), [[deprecated]] an V32Orchestrator (v32_orchestrator.hpp:91), ExperimentRunner 0 externe Konsumenten (grep leer), CLI-Flags in main.cpp:355-395, §60-Wortlaut LEDGER:3137-3152.

## (1) Kuratierte Tabelle (16 Einträge, nach Wiedereinführungs-Relevanz sortiert)

| # | Feature (Anker) | Status | Rest-Wert | Verdikt | Kosten |
|---|---|---|---|---|---|
| 1 | Planer↔CEB-.so-Grenze / Fork-A/M-§37a (BAUPLAN 19.07., ROADMAP:317) | **DEFERRED, nie verworfen** — per §30-Konsolidierung sogar ZIEL-Design | Hoch: ABI-v1-POD-Muster, W12-Stempel, Dock-Payload, ProgressSink alle fertig | **LOHNT** — Post-v3 als eigener INC (Steuerung zuerst, s. R1) | Mittel (Rollen-Naht existiert; Loader/Gate spiegeln, ~1 INC) |
| 2 | ExperimentSubtreePayload (experiment_dock_payload.hpp:58) | DEFERRED (S5-P4: nur als Live-Wire deprecated; Band-C #19) | Echt: getestete Referenz-Serialisierung + AxisRangeEntry-Tokening | **LOHNT** — als Vertrags-Nutzlast der #1-.so-Grenze bzw. #19-Resolver | Niedrig (liegt fertig+getestet) |
| 3 | A8 CoR-Selektions-Filterkette (selection_filter_chain.hpp:87) | Reaktivierbar (Dead-Code, Bausteine live) | Keimzelle der Planer-Resolver-Stufe + Hybrid-Break-Even-Selektion | **LOHNT** — bei Band-C-Resolver/Hybrid-Kette verdrahten | Niedrig-mittel |
| 4 | V32-Antriebs-Skelett execute_messreihe (v32_messreihe_antrieb.hpp:2) | **REAKTIVIERT** (PL-0 19.07., offizielles Phasen-Walk-Substrat) | Hoch+aktiv | LOHNT (läuft bereits als Plan; kein Audit-Handlungsbedarf; ce-Kommentare profile_run_facade.cpp:703 / experiment_run_entry.hpp:102 nachziehen) | Minimal (2 Kommentar-Fixes) |
| 5 | A9 F-SPREAD Max-Kontrast-Selektion | Deferred (GO-pflichtiger Fork, first-2 im Hauptlauf) | Beste Heuristik-Stützstellen (max. Wirkungs-Spannweite) | **LOHNT** — bei N-Voll-Messung ab 01.08. (User-Entscheid nötig) | Mittel (Katalog-Index-Selektion generalisieren + Fixture-Regen) |
| 6 | A5 Legacy-Mikrobench V37/V38.C (data-gated) | Deferred (bewusst NICHT entfernt) | Alt-vs-neu-Referenzkurve für Break-Even | **LOHNT TEILWEISE** — nur als Vergleichslauf, nie weiterentwickeln | Null (nur Gate öffnen) |
| 7 | Statische golden-n-Matrix (.gitlab-ci.yml:860) | Deferred (Notfall-Fallback, doppelt gegatet) | Fallback + 11509-Artefakt-Lieferant | **LOHNT TEILWEISE** — behalten als gated Fallback, nie reaktiv ausbauen | Null |
| 8 | SLURM/ZIH slurm_launcher (F68) | Deferred (deprioritisiert, nicht gestrichen) | KF-12-Isolations-Katalog (MSR 0x1A4, Governor, SMT, ASLR) | **LOHNT TEILWEISE** — Katalog als Bare-Metal-Checkliste extrahieren; SLURM selbst nur bei ZIH-Reaktivierung | Niedrig (Doku-Extraktion) |
| 9 | A16 P/E-Core-Dispatch + aktives Pinning | Deferred (beobachtend via ran_on_core_type) | HW-Unter-Achse; CorePinPolicy für 1-Thread-Reproduzierbarkeit | LOHNT TEILWEISE — Folge-Increment nach Messkampagne (prod2 verfügbar) | Mittel |
| 10 | A17 F-A/F-B NUMA/page→Pool-Organe (design-gated) | Deferred bis Allocator-Achsen-Permutation | Einzige legitime fehlende axis_12-Organ-Konsumption | LOHNT TEILWEISE — erst wenn Kampagne Allocator permutiert | Mittel |
| 11 | A13 S-7 Locking-Achse (ILockingMode) | Deferred (Research in Schwebe; Pflicht unverändert) | Upgradeable=2-Semantik; S-7-Pflicht bleibt | LOHNT — aber erst nach separatem Opus-Research; Phantom-Enumeratoren nicht wiederverwenden | Hoch (Research+CRTP-Organ) |
| 12 | variant-Baustein-Insel (§23.D) | Hart-verworfen als Live-Pfad; TEST-ONLY | Negativ-Anker des metaprog-Guards + Provenienz 13./14.05. | **LOHNT NICHT** (variant-Verbot §23; Guard braucht sie genau so) | — |
| 13 | abi::PermutationModule/ExperimentRunner (module_loader.hpp:36) | Hart-verworfen (tote Kette, verifiziert 0 Konsumenten) | Praktisch nichts (anatomy_module_loader löst beides sauberer) | **LOHNT NICHT** (Zwei-Loader-Welten-Risiko, pruef_dock_sequencer.hpp:12); Deprecation-Banner nachtragen | — |
| 14 | V32Orchestrator-Surrogat-Strang (:91) | Hart-verworfen (F63: Surrogat nie im Messpfad; PL-0: Stub nicht füllen) | Nur [[deprecated]]-Stolperdraht | **LOHNT NICHT** | — |
| 15 | COMDARE_IS_ORIGINAL-Macro / codegen.sh-Skelette / PERM_EXTRA_CFLAGS-Bake / flaches SIMD-Modell / test_data_sets.xml-Slot | Hart-verworfen (je 0 Live-Konsum; Ersatz live) | Nur Guard-Kontraste (Block F) bzw. Provenienz | **LOHNT NICHT** (Ersatz jeweils sauberer: Validator/ctsha, C++23-Tool, getrennte Kanäle, Familien-Knoten, #25-Akten) | — |
| 16 | A1 -rdynamic-DLL-Load / A10-A11 unbegrenztes variant / Option 2 ganze Tiere hot | Hart-verworfen (Arena-Kontamination; Bloat; §49) | Negativbelege + Option 2 als Reserve-Zwischenform | **LOHNT NICHT** (Option 2 nur reaktivieren, falls Option 1/3 bei Multi-Break-Even versagen) | — |

## (2) Antworten R1-R3

**R1 (.so-ABI): DEFERRED, definitiv nicht verworfen.** Beweiskette: Dock↔.so-Doktrin 17./19.07. dekretiert („jede Ebene = C++23-ABI-stabile .so"), §30-Konsolidierung verschärft zu ZIEL-Design, Fork C schneidet nur die Sequenz (vor 28.07. kein .so, danach Fork-A-INC), A8-Befund LEDGER:2832 sagt wörtlich „DEFERRED" ohne Begründungsklausel — die angeblich zitierte Begründung „kein DoD-Träger" existiert in keinem persistierten Dokument (0 grep-Treffer). Deprecated ist einzig das in-process POD **als heutige Live-Wire** (S5-P4), nicht die .so-Idee. **Getrennte Bewertung:** (a) *Steuerung:* Wiedereinführung LOHNT — dlopen-Callback (ProgressDelta statt Datei-Polling) ist Voraussetzung für die Heuristik-/Replan-Schleife mid-run, die der emit→parse-Textzyklus strukturell nicht kann; plus Compile-Time-Vertragsgate (Magic/Major, host_compatible_with) statt YAML-Drift. (b) *Daten:* LOHNT NICHT als Performance-Argument — 131k Zeilen CSV kosten Sekunden gegen Tage Messung; die CSV bleibt ohnehin Persistenz-Pflicht (§58-Stempel, Messdaten-nie-löschen). Gewinn auf der Datenseite ist nur Typsicherheit/Entfall der float→Text→float-Roundtrips, nicht Durchsatz. (c) *C++23-modules-Realismus mit g++-16:* Module liefern KEINE ABI-Stabilität — die kommt aus der extern-C+POD+Major-Gate-Schicht (wie anatomy_module_abi_v1); g++-Named-Modules sind seit GCC 14/15 nutzbar (CMake-Support vorhanden, `import std` erst experimentell), aber über eine .so-Grenze hinweg bleibt der stabile Vertrag zwingend die C-ABI-Fläche. Empfehlung: .so-Grenze mit ABI-v1-Muster bauen, modules höchstens als interne Paketierung der Vertrags-Header — nicht als Vertragsmechanismus verkaufen.

**R2 (Driver-Split): Hypothese zur Hälfte korrekt.** RICHTIG: Mess-Achsen des Planers bestimmen den CEB-TYP/die Ausstattung (je Tooling-Kombination ein ceb:build-Job, director Z.86-99), und der eigentliche Mess-Vollzug liegt vollständig in der CEB (run_profile/run_experiment_profile → run_lazy_static_then_dynamic → Zwei-Phasen-Loop → Observer-Pull → CSV). FALSCH: „Unter-Klassen derselben Klasseninstanz" — es gibt keine Vererbung zwischen Planer und CEB; Vererbung existiert nur planer-intern (IPlanBuilder-Familie, GoF Director+Builder). **Richtiges Modell:** Ledger-§24-Haupt/Unter-DELEGATION zweier ROLLEN derselben Binary („kein Schein-Split", director Z.469-472) über das eindimensionale Planer-Dock; Isomorphie via geteilte Single-Source-Nähte (system_axis_opt_flag_of/march_of) + Contract-Test, nicht via geteiltes Objekt; Rückkanal nur beobachtender §38-ProgressSink. Konsolidierung zu einer Klassenhierarchie ist NICHT geboten — geboten ist der umgekehrte Schritt: die Rollen-Naht per Fork-A-.so physisch zu trennen (dann sind es wirklich zwei Module, mit dem Dock als Vertrag).

**R3 (CLI): Lücke real und mittelgroß — Emission fertig, Bedienbarkeit fehlt.** Vorhanden: 6 Planer-/CEB-Flags + --measurement-combo, VALIDAT-Report, S5-ProgressSink (stderr + progress.cursor). Fehlend (7 Gaps): kein `--profile=`/`run <xml>` (Messlauf hängt an Legacy-Positionals + Env), kein `--status`-Aggregator (Zustand fragmentiert über cursor/Sidecars/CSV-Stamps/minio-Marker), progress.cursor write-only ohne %, ETA, Resume, --help beschreibt nur das deprecated Legacy-4-Datei-Schema, ~16 Env-Vars ohne CLI-Äquivalent/--print-env, kein Kommando fährt Stufe 1→2 lokal durch (nur Kommentar-Choreografie), keine maschinenlesbaren Marker (JSON/Exit-Codes); einziger Fortschrittsbalken hängt am deprecated COMDARE_LEGACY_MESSREIHEN-Gate. Umfang: ~3-4 Pakete reine Treiber-Arbeit in main.cpp + Fassade, kein Architektur-Umbau — genau das §60-R3-Profil (baut auf ProgressSink + --dump/--emit auf).

## (3) Empfohlene Post-v3-Strang-Reihenfolge

1. **CLI-Härtung (R3)** — zuerst, da rein additiv, ohne ABI-Risiko, sofortiger User-Nutzen: `run <xml>`/`--profile=` + `--help` (offizieller Weg) + `--print-env` → `--status`-Aggregator (cursor/Sidecars/CSV-Stamps lesen) → Fenster-Gesamtgröße in ProgressDelta (%, ETA) + JSON-Marker → lokales Stufe-1→2-Durchfahr-Kommando.
2. **Fork-A-.so-Schnitt (M-§37a, R1-Steuerung)** — an der Director-Rollen-Naht, Vertrag = ExperimentSubtreePayload-POD (Tab. #2) + ProgressSinkFn-Callback, Versions-Gate = W12-Stempel, Muster = anatomy_module_abi_v1. Kein Daten-Transport-Umbau; CSV bleibt.
3. **#19-Resolver/Band-C + A8-CoR-Verdrahtung (Tab. #3)** — nutzt die dann live .so-Nutzlast; Registry-ANGEBOT gegen Anwender-XML, Hybrid-Break-Even-Selektion.
4. **F-SPREAD Max-Kontrast (Tab. #5)** — mit User-GO zur N-Voll-Messung ab 01.08. (Fixture-Regen einplanen).
5. Nachrangig, gate-getrieben: A16-Pinning (nach Kampagnen-Start), A17 F-A/F-B (wenn Allocator permutiert), A13 S-7 (nach Opus-Research). Sofort-Hygiene ohne GO-Bedarf: Deprecation-Banner in module_loader.hpp:36 nachtragen + die 2 veralteten „ersetzt"-Kommentare (profile_run_facade.cpp:703, experiment_run_entry.hpp:102) auf PL-0-Stand bringen.

Nicht wiedereinführen: Tabelle #12-#16 (Ersatz jeweils sauberer live; Verbote §23/§49/F63 stehen).
---

## ANHANG A — .so-ABI-Tiefensonden-Report (R1, Langfassung)


---

## ANHANG B — Driver-Split + CLI-Tiefensonden-Report (R2/R3, Langfassung)

