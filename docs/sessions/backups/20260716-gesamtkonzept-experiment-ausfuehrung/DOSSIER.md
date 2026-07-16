# GESAMTKONZEPT — Experiment-Ausführung + Serialisierung + Reihe C (Untersuchung 2026-07-16, User-Auftrag F3)

> Read-only Untersuchung (Opus). Belege datei:zeile im Fließtext. Basis: User-Antworten 2026-07-16 (Mess-Verfahren, Serialisierung, Reihe-C=Option-C) + Dossiers 17/18/19/22/23 + Code-Ist. Zweck: der von dir für F3 verlangte Gesamtkonzept-Abgleich + die scharf gestellten Rest-Klärungen.

## (A) End-to-End-Fluss — IST vs. SOLL

**SOLL (User-bindend):** `EINE Experiment-XML → Experiment-Planer → generierter CI-Code XOR cmake-Code → CEB baut Tier-Binaries C++-orchestriert → Mess-Modi (Debug parallel / Mess 1-Thread) → Zwei-Phasen-Op-Schleife ×n_repeats≥3 → serialisierter Ergebnis-Baum → Ziel-Ordner.`

1. **XML→Planer:** 2 Registries (real, in den Driver einkompiliert `COMDARE_CE/PRT_AXIS_REGISTRY_PATH`, `main.cpp:312-314`) + 1 Experiment-XML. **Planer-Executable existiert NICHT** (Dossier 23 §5.1): `parse_experiment_profile` ist nur test-/`--validate`-verdrahtet, NICHT auf dem Mess-Pfad; der offizielle Run läuft über `parse_thesis_profile` (m3v2-Schema). Die CoR-Stufenfilter-Kette (`selection_filter_chain.hpp`) ist unverdrahtet; die Stufe1/2/3-Strategie (`experiment_phase_strategy.hpp`) ist **header-only INERT, ohne Konsument** (IST-Korrektur).
2. **Planer→CI/cmake-Codegen — größter SOLL-Gap:** „XML steuert CI über Interpreter, jedes Feature XML-gestützt" (F6, neu, LEDGER:376) ist **heute ABSENT**. CI-Fan-out ist statisch handgeschrieben (`trigger:*`). Einziges XML-adjazentes Codegen = enum-getriebene Permutations-Codegen (`cmake/permutations.cmake:17-40`, gesteuert durch `COMDARE_PERMUTATION_PROFILE`, NICHT durch die Experiment-XML). „Planer generiert CI-Code ODER cmake-Code, beide synchron aus DERSELBEN XML" = **konzeptionell fixiert, unimplementiert**.
3. **CEB baut Tier-Binaries:** ~80 % gebaut, test-only (`parse_thesis_profile`→`profile_to_tree`→`StaticBinaryView`→`BuildSelection`→`BuildOrchestrator::provision_all`→`adhoc_emitter`). Zur Laufzeit C++-orchestriert, NICHT via CMake (Dossier 19 R4). `messung_driver` fährt heute als E4-XML-Default über `run_profile_facade` (`main.cpp:597-646`).
4. **Mess-Modi — IST-Korrektur:** **KEIN codierter Debug/Mess-Schalter.** Zwei entkoppelte Ebenen: (i) Bau-Parallelität `parallel_jobs()=total/cores_per_build` (`build_orchestrator.hpp:79-82`; CI `CMAKE_BUILD_PARALLEL_LEVEL=6`); (ii) Mess-Scan single-thread nur als Profil-Pinning (`thread_count` LABEL-ONLY, auf 1, nicht konsumiert, #221-deferred). Die User-Semantik „Debug=alle Threads parallel / Mess=1 Mess-Thread + Gattungs-Threading aus Tier-Binary" braucht einen **NEUEN XML-getriebenen Schalter** + echte `thread_count`-Konsumtion (#221). perf jetzt auf beiden prod (F9).
5. **Zwei-Phasen-Op-Schleife (bestehend):** `rollbackable_tier.hpp:8` save→warmup(kalt)→rollback→measure; Wiederholungen als `<repetitions count>`-DynDim (`profile_run_entry.hpp:250-252`); E3 macht n_repeats≥3 Pflicht.
6. **Serialisierter Ergebnis-Baum (neue Vorgabe):** lazy/nicht-materialisiert (`experiment_tree.hpp:4-26`), aber serialisiert MIT Ergebnissen. Systemachsen→FLACH als Ordner (heute CSV-Spalten `platform`/`build_version`/`toolchain`, `lazy_csv_header:267/:368`). Tier-Achsen+CSV→TIEFER Baum (IST-Embryo `per_binary_subdirs` je Tier-Binary + `result.csv`, `cache_engine_builder_iterator.hpp:67,764-853`; statische Achsen im `binary_id`-Pfad packt-kodiert `axis_path_serialization.hpp:30-34`; dynamische Dims als `setting_label`-Zeilen). Ziel-Ordner: im Build-Pfad erzeugen, nach Messung in XML-`<output>` kopieren (build→ziel-Copy fehlt heute).

**Deadline (governing):** 28.07. — CI UND Standalone messfähig, cmake+C++23, EINE Maschine (F12i; messung_driver-Binary baut jetzt, snmalloc-Fix ce `730831d2`).

## (B) Reihe C — kanonisch = OPTION C (beide Views), im Baum verortet

Keine 4. Stufe, kein 4. `MergeStrategy`-Enum (`pruefling_merge.hpp:130-134`=3; `stufe_to_reihe` A/A/B; LEDGER:374). Zwei Auswertungs-Sichten auf denselben serialisierten Baum:
- **View 1 — SdT-vs-Prüfling je Stufe s∈{1,2,3}:** MergeStrategy-Diskriminator innerhalb der Stufe; (merge,lebewesen)-Kennung im Baum (`sota_binary_id`); Voll-Vergleich (Tier×Datenlast×Compiler×ISA+OS) mit Compiler/ISA/OS als **Ordner-/Gruppierungs-Schlüssel** (NIE binary_id) = deckungsgleich mit der Flach-Ordner-Vorgabe.
- **View 2 — build-über-Build-Regression:** derselbe (binary_id-Pfad × Dynamik-CSV) über zwei serialisierte Bäume; Anker `diff_against` (`config_c_merge_alt_neu.xml:57`) + Welch/Holm `f15_compare` + I6-Welch-Stufe.
- **Thesis-Textnachführung (Thesis-Repo, nicht Impl):** die Thesis kollidiert in sich (`03_messsystem_prtart.tex:468-497` Regression vs. kuratierte Merge-Punkte; `05_evaluation.tex:103-106` mischt) → Option C löst es: Reihe C = zwei Sichten über den Baum, die Merge-Punkte sind Beispiel-Konfigurationen der SdT-Sicht; Compiler = kontrollierte, protokollierte Vergleichs-Dimension (Dossier 23 §4.3/S-8).

## (C) NEU zu bauen (Bau-/Mess-Maschinerie steht ~80 %)

1. **Experiment-Planer als 3. Anwendung** — Parser + CoR-Filterkette auf den Mess-Pfad verdrahten (heute test-/`--validate`-only + inert).
2. **XML→CI/cmake-Interpreter** (F6) — heute absent; der Planer generiert aus DERSELBEN XML den CI-Code ODER cmake-Code, synchron.
3. **Formaler Debug-parallel / Mess-1-Thread-Schalter** (XML-getrieben) + echte `thread_count`-Konsumtion (#221); Gattungs-Threading aus der Tier-Binary.
4. **Serialisierter Ergebnis-Baum** — flacher Systemachsen-Ordner + tiefer Tier-Achsen-Baum + dynamik-only-CSV + build→ziel-Copy.

## (D) SCHARF GESTELLTE REST-KLÄRUNGEN (Reihe C erledigt; nur Serialisierung/Schema offen)

- **Q1 — Kodierung statischer Achsen im tiefen Baum:** (a) nach Achsen-Ebenen genestete Ordner (spiegelt `experiment_tree` 1:1, aber Pfadlängen-Risiko) vs. **(b, EMPF.)** flach je Binary (`per_binary_subdirs`) + Sidecar-Manifest (je-Achse-Wahl als Metadaten) + separater Baum-Index. Additiv, nutzt Provenance-Manifest-Muster, kein Pfadlängen-Bruch.
- **Q2 — E1-Schema-Umkehr:** E1 forderte „je Achse eine Algorithmus-Wahl-Spalte + `;phase;engine`" (LEDGER:377); die neue Vorgabe: statische per-Achsen-Wahl NICHT als Spalten. **Frage:** Fallen die geplanten statischen per-Achsen-Spalten weg (nur `binary_id`+Ordner+Metadaten), während `;phase;engine` + dynamische Spalten (Workload, RC/setting, working_set_n, thread_count, P/E-Core, NUMA) bleiben? **EMPF. JA** (bewusste E1-Korrektur, damit der CSV-Increment nicht 19+ redundante Spalten baut).
- **Q3 — Systemachsen-Ordner-Schema + Tag-Spalten-Migration:** Welche Systemachsen werden Ordner-Ebenen, in welcher Reihenfolge? Und die heutigen Tag-Spalten `platform`/`build_version`/`toolchain` — raus in Ordner (bricht Header-Vergleich + `resume-v5`) oder **additiv gespiegelt** (Ordner + Spalte, Resume-sicher)? **EMPF.:** additiv gespiegelt (Ordner-Baum einführen, Tag-Spalten für Resume/Rückwärtskompat behalten, später deprecaten — schützt `test_profile_roundtrip==320`); Reihenfolge grob→fein (Host→OS→Toolchain→ISA).
- **Q4 — Serialisierungs-Format + build→ziel-Zeitpunkt:** Baum = (a) nur On-Disk-Layout vs. **(b, EMPF.)** zusätzlich maschinenlesbarer Index-Manifest (spiegelt `experiment_tree` + Ergebnis-Pointer, speist CoR-Auswertung + beide Reihe-C-Views). Und: CEB erzeugt im Build-Pfad + kopiert atomar in den XML-Ziel-Pfad (Antwort 2)? **EMPF.:** (b) + build→ziel-Copy.
