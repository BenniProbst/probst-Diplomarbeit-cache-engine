# DOSSIER — GO 5: EXTERN_GATED-Forks (Task #3) + Smoke-/Coverage-MESS-Profil (#26, inkl. #9)

> **Datum:** 2026-07-12 · **Autor:** Impl-Agent (Bestandsaufnahme + Design, KEIN Commit, KEINE Code-Änderung)
> **Auftrag:** User-Freigabe §11-I GO 5 („KOMPLETT AUTONOM — #3 extern-gated Forks + #9 Phase 0.3b: Forks
> sichten, entscheiden, umsetzen — ohne weitere Rückfrage", Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:273`)
> + §11-I Frage 6 („ZUSÄTZLICH ein Smoke-/Coverage-MESS-Profil bauen, das ALLE Features des Gesamtsystems
> einmal berührt (erweitert die 320er umfassend) → Ablauf künftig: erst Smoke, DANN Voll-Lauf", Ledger `:275`).
> **Verifikationsstand:** Alle Kernbehauptungen SELBST am Ist-Code/Ledger/Thesis-Text verifiziert
> (datei:zeile, eigene Greps/Reads 2026-07-12). Zwei zusätzlich gestartete Explore-Gegenprobe-Kartierungen
> (Fork-Recherche + Coverage-Matrix) waren bei Redaktionsschluss noch nicht zurück — dieses Dossier stützt
> sich AUSSCHLIESSLICH auf die eigenen Verifikationen (kein unbestätigter Fremd-Befund).
> **TABU gewahrt:** `golden_fullpilot_320_binary_ids.txt` + `permutation_axes.xml` + bestehende Profile bleiben
> unberührt; alles hier ist SEPARAT/additiv geplant.

---

# TEIL A — Task #3: Die EXTERN_GATED-Fork-Liste (Entscheidungen unter GO 5)

## A.0 Rekonstruktion und Abgrenzung

**Autoritative Quellen der Liste** (grep `EXTERN_GATED`/`GEPARKT`/`Fork`/`§H`):

1. Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:532` (2026-07-10, PLAN↔CODE-Diff wf_d4d9e410):
   „**EXTERN_GATED (Forks, GO-Freigabe deckt sie NICHT):** W/D/K-XML-Strecke (R1/R2) · Dataset-Wahrheitsquelle
   (test_data_sets.xml existiert 0× — stiller Parser-Slot!) · V32-Altlast-Fork · Framework×Workload-Bib
   (Schritt 13/6-vs-48) · P/E-Core-Domänen · Fairness-Modus · H2-Score."
2. `docs/plaene/20260710-plan-code-diff-BACKLOG.md:14-19` (dieselbe Liste, klassifiziert; Zeile 19
   nennt zusätzlich die Journal-Reste: baseline_3-analysis · prt-art-Pool/Multilevel-Anbindung ·
   sosd/xml-Akten-Rest).
3. `docs/sessions/20260710-SESSION-UEBERGABE-typsystem-forks-phase6.md:110-137` (Task-Board: Task #3 =
   „EXTERN_GATED-Forks — je eigenes User-GO nötig"; P/E-Core zusätzlich als HARDWARE-GATED markiert).
4. `docs/sessions/20260711-SESSION-UEBERGABE-produktions-single-xml-path.md:204` (Abschnitt D — GEPARKT:
   „Task #3 EXTERN_GATED-Forks; … #9 Phase-0.3b; …").

**Wichtige Abgrenzung (Ist-Stand, nicht Notizen-Stand):**

- Die **7 Doc-20-§H-User-Forks** (workload-type-Kanon #31-2 · „Beschaffenheit" · size absolut-vs-relativ ·
  op_type Runner-vs-XSD · framework {YCSB,LP}-vs-13 · Tuple-Pareto · Sonderstatus-Trio T2/T1/T10) sind
  **BEREITS ALLE vom User entschieden** — `docs/architektur/20_…md:144` („SUPERSEDIERT … Die 7 §H-Forks sind
  dort ALLE entschieden; §H bleibt als Historie stehen") + `docs/architektur/21_SESSION_PLAN_…md:40-50`
  (Tabelle H1–H7, User 10.07.). **Sie sind NICHT Gegenstand von Task #3** und werden hier nicht neu
  entschieden (nur dort referenziert, wo eine H-Entscheidung einen EXTERN-Fork konzeptionell mit-beantwortet,
  vgl. Doc 21 §G:249: „W/D/K-XML-Strecke + Dataset-Wahrheitsquelle + Framework-Bib = weitere EXTERN-Forks
  (durch H1/H5 jetzt konzeptionell entschieden; Umsetzung folgt der Bau-Reihenfolge)").
- Die Forks **F-A/F-B/F-C** (Phase 0.2 NUMA/Page→allocator, Doc 21 `:230-233`) sind **Task #8 mit
  Rückfrage-Pflicht (GO 4)** — ausdrücklich NICHT autonom; hier nur abgegrenzt.
- Die S7-Forks F-S7-a/b/c (Ledger `:828`) sind seit 06.07. AUFGELÖST; #27/7b-3 (SwissTable-SIMD) bleibt
  eigenständig GEPARKT (Ledger `:468`) und ist kein #3-Item.

Damit besteht Task #3 aus **7 Kern-Forks + 3 Journal-Resten**. Je Fork folgen: (1) Frage, (2) Optionen,
(3) **ENTSCHEIDUNG (GO 5, research-belegt)**, (4) Umsetzungs-Skizze + Aufwand (S/M/L).

**Leitplanken für alle Entscheidungen:** FF0–FF4 (Ledger `:78-86`), Anti-Fake-/honest-0-Doktrin,
Produktions-Track („System fertig; Fehler findet der volle Lauf" — Memory
`feedback_production_track_full_golden_run_finds_errors`), „CI grün + messfähig → nur punktuelle
Refactorings" (Doc 21 Kopf), EIN offizieller XML-Weg (Memory
`feedback_only_one_official_xml_driven_program_no_behelfswege`), TABU golden/Registry-mp_list-Erstglieder.

---

## A.1 Fork 1 — W/D/K-XML-Strecke (R1/R2)

**(1) Frage.** Wie kommen die drei Mess-INPUT-Dimensionen **W**orkload, **D**ataset, **K**ategorie
(`<measurement_categories>`) vollständig XML-getrieben in den EINEN offiziellen Messweg? Ursprung:
`docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:247-254` (I.4 „V32-Fork-Wahrheit"): Der reale
Produktivpfad war das Ad-hoc-Format `<comdare_messreihen>`; W/D/K sind Mess-Inputs, KEINE Binary-Achsen
(golden/ABI-neutral verifiziert). Doppel-Gate:
**R1** = „Reicht `YcsbWorkload` A–F, oder braucht die Mess-Kategorie OP-1..6 (Bulk-Insert/Range-Delete)?" ·
**R2** = „Treibt messreihe-`<workload>` die `WorkloadOptions`, oder bleibt `test_data_sets.xml` autoritativ
(Doppelquelle vermeiden)?" (wörtlich Doc 16:254).

**(2) Optionen** (Doc 16:252-253):
- **Option A:** `<comdare_messreihen>`/`MessreihenSpec`/`load_messreihen` + 4 Hartkodierungen erweitern
  (1 Code-Datei + 1 XML-Template, additiv, Fallback=heute).
- **Option B:** V32 wiederbeleben (XSD + ~200 LOC Parser + Orchestrator-Stub vollenden; reicher: op_type
  OP-1..6, XSD-validiert; bricht V31.F-Freeze).
- **Option A′ (neu, Ist-Stand-getrieben):** Seit P6 (11.07., super `c8ec3c2`/`54ef01f`) ist **E4-XML der
  Alleinweg** und der Messreihen-/Legacy-Pfad nur noch via `COMDARE_LEGACY_MESSREIHEN=1` erreichbar
  (`20260711-SESSION-UEBERGABE-produktions-single-xml-path.md`, P6-Eintrag). Die W/D/K-Strecke gehört damit
  NICHT mehr in `<comdare_messreihen>` (Option A zielte auf den inzwischen degradierten Pfad), sondern
  **additiv ins `comdare_thesis_profile`-Schema** (`libs/cache_engine/algorithm_profiles/thesis_profiles/SCHEMA.md`).

**(3) ENTSCHEIDUNG (GO 5): Option A′.**
Begründung am Bestand: (a) Das E4-Profil-Schema trägt W bereits real — P1 machte `<workloads>` zur
autoritativen Achse-2-Auswahl über die 21 Lastprofile (`profile_run_facade`, Übergabe-Doc P1-Eintrag);
**D fehlt vollständig** (grep `dataset` über `libs/cache_engine/profile_facade/` + `thesis_profiles/SCHEMA.md`
= 0 Treffer; die 21 `load_profiles/*.xml` sind synthetische op_mix-Generatoren ohne Datensatz-Referenz, z. B.
`coco_p04_neg50.xml` `<records>10000</records>` ohne Korpus-Bezug); **K ist Phase-6-/DATEN-gated**
(`BACKLOG.md:11`, `<measurement_categories>`-XML hängt am Mess-System-Phase-6-Rest/#215). (b) FF4
(Reproduzierbarkeit/Provenance) verlangt die Datensatz-Akten im Messfluss, und die Akten existieren
(A.2). (c) Option B ist doppelt tot: V32 ist nie verdrahteter toter Code (A.3) UND `<comdare_messreihen>`
ist Subsumtions-Kandidat — jede Investition dort wäre ein Behelfsweg gegen die Ein-Weg-Doktrin.
**R1 ist durch H1/H4 materiell beantwortet** (Doc 21 §B: OP-1..6 gehören zum definierten Umfang; die
Op-Achse wird auf das std-C++23-Interface gehoben) — für den KERN-Messlauf reicht YCSB A–F + die 21 LPs
(alle 6 op_mix-Kanäle sind in den LPs vertreten), OP-1..6 als eigene Testreihenfolge-Dimension folgt der
H1-Bau-Reihenfolge (dynamischer Layer über den Testdaten). **R2: die Akten sind autoritativ, es entsteht
KEINE test_data_sets.xml-Doppelquelle** (Detail in A.2).

**(4) Umsetzung + Aufwand: M** (2 Increments, beide golden-neutral):
1. `<datasets>`-Element additiv ins `comdare_thesis_profile`-Schema: je Eintrag `akte_ref` auf eine
   `Code/test_data_xml/*.test_data.xml`-Akte + `loader`-Typ (`string_corpus`; sosd-binär bleibt der
   dokumentierte offene Loader, Ledger `:480` Ende). Konsum in `run_profile_facade` →
   `load_or_generate_ycsb(dataset_source=…, dataset_id=…)` (Loader-Slot ist seit #184 hermetisch bewiesen,
   Ledger `:416` (A)). Fallback ohne `<datasets>` = heutiger synthetischer YCSB-Generator (rückwärtskompatibel,
   binary_id-neutral — Datasets sind Mess-Inputs).
2. `<measurement_categories>` bleibt **DATEN_GATED** dokumentiert (kein Vorbau; Phase-6-Rest/#215) —
   Entscheidung hier ist nur die VERORTUNG (E4-Profil-Schema, nicht Messreihen-XML).

---

## A.2 Fork 2 — Dataset-Wahrheitsquelle (`test_data_sets.xml` existiert 0×)

**(1) Frage.** Der Legacy-Parser hat einen **stillen Slot** für `test_data_sets.xml`
(`libs/common/serialization/xml_config_parser/xml_config_parser.cpp:94` parst in `cfg.test_data_sets`;
Header `xml_config_parser.hpp:7` listet die Datei; `apps/cache_engine_builder/main.cpp:67` und super
`Code/02_messung_driver/main.cpp:172` werben mit ihr) — aber die Datei existiert **nirgends** (0×; einzig
ein Test erzeugt sie sich synthetisch: super `Code/tests/unit/test_messung_driver.cpp:107`). Real existieren
**8 Akten** `Code/test_data_xml/*.test_data.xml` (url/protein/tpcds-id/trec-terms/english_words/
pizzachili_dna/xml[honest-0]/sosd_books_200M[honest-0]) — der 6er-Kanon ist per #25 thesis-verifiziert
(Thesis `kapitel/de/06_evaluation_methodology.tex:87-102` `tab:datasets` = EXAKT 6 Datensätze; Ledger `:480`).
Wer ist die Wahrheitsquelle?

**(2) Optionen.** (a) `test_data_sets.xml` nachträglich erzeugen (Parser-Slot füllen) · (b) **Akten =
Single-Source**, den leeren Legacy-Slot ehrlich deprecaten · (c) Ist-Zustand belassen (stiller Slot).

**(3) ENTSCHEIDUNG (GO 5): Option (b).**
Begründung: (a) schüfe exakt die Doppelquelle, vor der die R2-Empfehlung warnt (die Akten tragen bereits
Checksum/line_count/preprocessing via offizieller `compute_dataset_akte`-Mechanik, Ledger `:480`; eine
zweite Liste desselben Inhalts = Doppelquellen-Muster, das mit der 18.06.-Konsolidierung und Doc 20 §I
[axis_binding_registry VERWORFEN wegen „Doppelt-Wahrheit"] gerade ausgetrieben wurde). (c) verletzt die
Phase-7-Lehre (stille-{}-Falle: `parse_one` liefert still `{}` — genau die Fehlerklasse, die Phase 7
bereinigt hat, Ledger `:535`). (b) ist FF4-konform: EINE Provenienz-Quelle (Akten), der E4-Weg konsumiert
sie via A.1-`<datasets>`.

**(4) Umsetzung + Aufwand: S.**
Kommentar-/Usage-Korrektur an den 3 werbenden Stellen (`xml_config_parser.hpp:7`,
`apps/cache_engine_builder/main.cpp:21/67`, super `02_messung_driver/main.cpp:172`) auf „DEPRECATED-Slot,
Wahrheitsquelle = `Code/test_data_xml/*.test_data.xml`-Akten"; der Parser-Slot bleibt (Legacy-Pfad ist
ohnehin `COMDARE_LEGACY_MESSREIHEN`-gated, Doku-nie-löschen-Direktive); optional ein Guard-Log statt
still-{}. KEIN neues XML.

---

## A.3 Fork 3 — V32-/`comdare_experiment`-Altlast

**(1) Frage.** `v32_orchestrator.hpp` (super `Code/02_messung_driver/`) + `comdare_experiment`-Format
(config_a/b/c): vollenden (damals „Option B") oder toten Pfad tilgen? Live-verifizierter Befund
(Doc 16 I.4:249-251, Backup `20260709-v32-fork-analyse-31-e4xml/`): (1) `comdare_experiment` (config_a/b/c)
ist **toter Code** (von nichts konsumiert); (2) der V32-Orchestrator ist **nicht verdrahtet** (main.cpp
inkludiert `v32_orchestrator.hpp` nie; kein V32-XML→Struct-Parser; `COMDARE_V32_ENABLE` = No-Op fürs
Driver-Binary; super `02_messung_driver/CMakeLists.txt` Option default OFF mit V31.F-Freeze-Kommentar);
(3) das XSD liegt als `Code/test_data_xml/messreihe_v32_schema.xsd` + Beispiel.

**(2) Optionen.** (a) V32 vollenden (Option B von damals) · (b) sofort tilgen · (c) **dokumentiert
stehen lassen bis zur E4-Subsumtions-Bestätigung, dann mit dem Legacy-Paket tilgen.**

**(3) ENTSCHEIDUNG (GO 5): Option (c).**
Begründung: (a) ist durch A.1/Option A′ tot (E4-XML ist der Alleinweg; ein zweiter Orchestrator wäre ein
Behelfsweg + bräche den dokumentierten V31.F-Freeze `v32_orchestrator.hpp:7`). Sofort-Tilgung (b) verletzte
die P6-Sequenz: „**Legacy-Entfernung erst NACH bestätigter Subsumtion** — sonst Verlust der
3-Messreihen-Fähigkeit" (`20260711-SESSION-UEBERGABE-produktions-single-xml-path.md`, P6-Absatz) — der
golden-320-Voll-Lauf ist der Subsumtions-Beweis und läuft gerade (PoC #9916). V32 gehört ins selbe
Lösch-Paket wie der `ExperimentDriver`-Legacy-Pfad (P5-Präzedenzfall: 37-Dateien-Löschung mit gepaarter
Kommentar-Bereinigung). Das XSD/Beispiel bleibt als Doku-Artefakt (Doku-nie-löschen).

**(4) Umsetzung + Aufwand: S** (nach Subsumtions-Beweis): `COMDARE_V32_ENABLE`-Block + Header entfernen,
XSD/Beispiel nach `docs/` überführen oder in-place als historisch markieren; gepaarte Kommentar-Bereinigung.
Bis dahin: dieser Dossier-Eintrag IST die geforderte Fork-Auflösung (Entscheidung getroffen, Ausführung
sequenziert).

---

## A.4 Fork 4 — Framework×Workload-Bibliothek (Migrationsplan-Schritt 13; „6-vs-48"; C.1-Konsum)

**(1) Frage.** Die 2D-Matrix Mess-Frameworks × Workloads (Doc
`docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`) soll als Bibliothek in
`measurement-all` leben; die Diplomarbeit konsumiert sie zur Laufzeit (C.1). Gates laut `BACKLOG.md:18`:
Migrationsplan-**Schritt 13** (Doc 15:66: „NACH Migrationsplan-Schritt 13 (GATED): Diplomarbeit konsumiert
`measurement-all` statt ce-Kopie") und „**6-vs-48**".

**(2) Optionen.** (a) Bib jetzt in ce vorziehen (weiterer Eigenbau) · (b) auf die #274/#256-Matrix-Migration
sequenzieren · (c) hybrid (Interface jetzt, Umzug später).

**(3) ENTSCHEIDUNG (GO 5): Option (b)** — kein Vorziehen.
Begründung: **Konzeptionell ist der Fork bereits durch H1/H5 entschieden** (Doc 21 §B: 13-Framework-Registry
als Vokabular, 14 LP01–LP14, generische Klassen + Strategy; Doc 21 §G:249 sagt wörtlich „durch H1/H5 jetzt
konzeptionell entschieden; **Umsetzung folgt der Bau-Reihenfolge**"). Das **6-vs-48-Datensatz-Gate ist seit
08.07. beantwortet** (Ledger `:480`: 6er-Kanon = Thesis-`tab:datasets`, 48er-Katalog = stale Termin-7-Verweis,
in `DATASETS_SCHEMA.md` nachgezogen). Der Ist-Bestand deckt den Diplomarbeits-Bedarf schon heute im ce:
21 Lastprofil-XMLs mit `lp_id`-Kanon (AP-11/#245, Ledger `:303`), YCSB-Brücke via `WorkloadKind`-Reuse
(#31-Hybrid Schritt 1, Ledger `:507`), `<workloads>` als autoritative Achse-2 (P1). Der #31-Fehlbau
(`workload_matrix.hpp` als compile-time-Binary-Achse) wurde genau deshalb revertiert (Doc 15:16) — ein
erneutes Vorziehen in ce wiederholte den Fehler und kollidierte mit der Monolith-Doktrin (Doc 20 §A:
Zergliederung = EIGENER späterer Schritt). Die Bib-Auslagerung gehört in die #274/#256-Strecke
(GO liegt vor, eigene Strecke — `20260710-SESSION-UEBERGABE-typsystem-forks-phase6.md:143`).

**(4) Umsetzung + Aufwand: L, aber NICHT jetzt** (Teil der Matrix-Migrations-Strecke). Jetzt-Anteil: 0
(dieser Eintrag fixiert die Sequenz). Smoke-Profil-Beitrag: die 21 LPs werden im Smoke-Lauf alle je 1×
gefahren (Teil B) — das ist die messseitige Voll-Nutzung des vorhandenen Workload-Bestands.

---

## A.5 Fork 5 — P/E-Core-Zähler-Domänen (AP-13-Rest)

**(1) Frage.** Hybrid-CPUs getrennt vermessen: „auf Hybrid-CPUs werden P- und E-Cores getrennt vermessen
(eigene Zähler-Domänen `cpu_core`/`cpu_atom`) statt zusammenaggregiert" (Thesis
`kapitel/de/06_evaluation_methodology.tex:110-112`; ebenso `05_evaluation.tex:66`). Wie/wann kommt die
Domänen-Trennung in den PMC-Pfad?

**(2) Optionen.** (a) jetzt vorbauen (Domänen-Feld im PMC-Pfad, compile-only) · (b) deferred bis Hybrid-HW
zurück ist · (c) auf Nicht-Hybrid-HW „emulieren".

**(3) ENTSCHEIDUNG (GO 5): Option (b) — bleibt gated, kein Vorbau.**
Begründung: Der Fork ist **doppelt gated**: HARDWARE (i9-14900KS/prod2 in RMA bis ~September 2026,
`20260710-SESSION-UEBERGABE-typsystem-forks-phase6.md:136`) und DATEN/PMC (PMC-Vollpfad = #215, Doc 21
§G:247-248). prod1 ist AMD (keine cpu_core/cpu_atom-Domänen) → jeder Vorbau wäre unverifizierbar =
Phantom-Risiko (Anti-Fake; vgl. H-1/H-2-Auflösungen Ledger `:209-221`: „correctly-gated-do-not-build").
(c) wäre Fabrikation. Die Thesis-Anforderung bleibt als Abnahme-Kriterium des prod2-Fensters dokumentiert.

**(4) Umsetzung + Aufwand: n/a (gated).** Merkposten für das prod2-Fenster: perf-Event-Domänen-Qualifier
(`cpu_core/…/` Prefix) im pmc:intel-Job + Domänen-Spalte im PMC-POD — erst mit #215/#156-Fenster.

---

## A.6 Fork 6 — Fairness-Modus (common-denominator / native)

**(1) Frage.** `BACKLOG.md:19`: „Fairness-Modus common-denominator/native" — wie wird der Thesis-Anspruch
messbar? Thesis-Primärquelle `kapitel/de/06_evaluation_methodology.tex:128-136` (§sec:fairness): „Jeder
Vergleich **trennt** einen gemeinsamen Minimalmodus (Common-Denominator: externe Werte-Handles, keine
PRT-ART-Spezialpfade) vom PRT-ART-Native-Modus (Inline-Umschaltung, Cache-Engine, Seitentyp-Scheduler)."
Code-Ist: **0 Treffer** für fairness/common_denominator in `libs/` (grep 2026-07-12) — der Modus existiert
nirgends als Mess-Dimension.

**(2) Optionen.** (a) EINEN Modus wählen (entweder common-denominator ODER native) · (b) **beide Modi als
Vergleichs-Dimension** der SOTA-Reihen implementieren · (c) nur Auswertungs-seitig trennen (Spalten-Filter).

**(3) ENTSCHEIDUNG (GO 5): Option (b)** — die Thesis stellt keine Entweder-Oder-Frage; sie fordert die
TRENNUNG je Vergleich. Konkret: ein `fairness`-Attribut an `<sota_series>` (`common_denominator|native`),
das im common-denominator-Fall die Vergleichs-Komposition auf `value_handle_external` + deaktivierte
PRT-Spezialpfade pinnt (die Mechanik dafür existiert: `<sota_series merge=…>` + `pruefling_merge.hpp`-Joins;
value_handle ist reguläre Achse T14). Kein neuer Programmweg, reine Profil-/Reihen-Semantik → Ein-Weg-Doktrin
gewahrt. Messbar erst mit realen SOTA-Läufen → Umsetzungs-Slot NACH dem ersten vollen golden-Lauf
(#156/#162-Fenster), Schema-Design sofort möglich.

**(4) Umsetzung + Aufwand: M** (Schema-Attribut + Reihen-Pinning + Distinktheits-Test; Auswertung =
Spalten-Tag `fairness_mode` in der CSV). DATEN-gated für die Abnahme, design-fertig durch diesen Eintrag.

---

## A.7 Fork 7 — H2-Quality-Score maschinenlesbar

**(1) Frage.** Thesis-Hypothese **H2** (`kapitel/de/06_evaluation_methodology.tex:56-57`): „Der vom
Original-Quell-Repository geerbte **Code-Qualitäts-Score** korreliert messbar mit dem erreichten Durchsatz."
Es gibt keinen maschinenlesbaren Score im Bestand: `sota/*.profile.xml` tragen nur bibliographische
Metadaten (z. B. `hot.profile.xml:3-9`); `quality_flag`/`annotate_quality_flags`
(`profile_facade/profile_run_entry.hpp:225-229`) ist MESS-Qualität (#165), NICHT Code-Qualität.

**(2) Optionen.** (a) Hand-vergebene Scores (TABU: Fabrikation) · (b) **reproduzierbar berechneter
statischer Score** über die vendorten `ext/`-Paper-Quellen (offizielles Tooling: cppcheck/clang-tidy-
Befunddichte pro kLOC, Warnungs-Klassen gewichtet, Toolversion+Konfig in der Akte) als
`<code_quality method= score= tool= computed=/>`-Metadatum je `sota/*.profile.xml` + CSV-Spalte · (c) Score
ganz streichen (Thesis-Text ändern — nicht meine Zone).

**(3) ENTSCHEIDUNG (GO 5): Option (b).**
Begründung: H2 ist abgabe-relevant (Hypothesen-Kapitel); ohne maschinenlesbaren Score ist die Korrelation
im Auswertungs-Schritt nicht berechenbar (FF4: reproduzierbar = tool-berechnet, nie Hand-Wert; exakt das
Akten-Muster von #25/`compute_dataset_akte` — „kein Hand-Hash"). cppcheck ist bereits CI-Bestand
(Ledger `:480`: cppcheck 2.21.0 CI-only). Die Korrelation selbst ist DATEN-gated (#156-Durchsätze), die
Score-Akte ist es NICHT — sie ist heute berechenbar.

**(4) Umsetzung + Aufwand: M** (S für die Akten-Berechnung + Schema-Attribut; die Auswertungs-Korrelation
folgt im E4′-/Kurven-Fenster). Ehrlichkeits-Regel: Papers ohne vendorte Original-Quelle
(`is_original=false`-Rekonstruktionen) bekommen `score="n/a"` statt eines Pseudo-Werts.

---

## A.8 Journal-Reste (BACKLOG.md:19) — Einordnung

| Item | Befund | Entscheidung (GO 5) | Aufwand |
|---|---|---|---|
| **baseline_3-analysis** | Auswertungs-Rest der Baseline-Reihen; datenseitig ohne #156-CSVs nicht abnehmbar | mit dem Auswertungs-/E4′-Fenster (DATEN_GATED), kein Vorbau | n/a |
| **prt-art-Pool/Multilevel-Anbindung** | prt-art-Repo-Seite (PRT_ART = Prüfling, konsumiert ce als Werkzeug — Memory `feedback_prt_art_consumes_cache_engine`); Multi-Allocator-Permutation „lebt in der PRT_ART-/extension-Schicht" (Doc 21 §F:159-162) | eigene prt-art-Strecke NACH dem Smoke-/Voll-Lauf-Zyklus; ce-seitig ist mit 0.3a + Smoke-Allocator-Sweep (Teil B) alles Nötige da | M (prt-art) |
| **sosd/xml-Akten-Rest** | `sosd_books_200M` (binär, Fetch war truncatiert — Ledger `:416`) + `xml`-Akte honest-0 (Datei nicht lokal — Ledger `:480`) | ehrlich offen lassen; binärer SOSD-uint64-Loader ist als Folge-Increment dokumentiert (Ledger `:480` Ende); 6er-Kanon braucht ihn nicht | S–M (Loader), optional |

## A.9 GO-5-Bilanz Teil A

**Entschieden: alle 7 Kern-Forks + 3 Reste.** Sofort umsetzbar (nicht gated): A.2 (S, Kommentar/Guard),
A.7-Akten (S/M, tool-berechnet), A.1-Increment-1-Design (`<datasets>`-Schema, M). Sequenziert: A.3 (nach
Subsumtions-Beweis), A.4 (Matrix-Migrations-Strecke), A.6 (Schema jetzt, Abnahme daten-gated). Gated bleibt
allein A.5 (Hardware). **Kein Fork erfordert einen golden-/TABU-Bruch; keiner erzeugt einen zweiten
Programmweg.**

---

# TEIL B — Smoke-/Coverage-MESS-Profil (#26, inkl. #9)

## B.1 Vorbild: Task #18 „GOLDENER COVERAGE-TEST" — Ist-Stand (CODE-EBENE FERTIG)

Task #18 ist auf Code-Ebene VOLLZOGEN (ce `e1784e26` + `fc855b20`, ctest 210/210, `--validate` „19 Achsen,
19 axis_sweeps, 21 sota_series — VALIDAT OK"; `20260711-SESSION-UEBERGABE-produktions-single-xml-path.md:21`):

- **Profil:** `Code/external/comdare-cache-engine/libs/cache_engine/algorithm_profiles/thesis_profiles/m3_golden_coverage.profile.xml`
  — `<permute_axes>` = Basis-320 byte-identisch zu m3v2 (4×4×5×4; 15 Slots gepinnt), `<axis_sweeps>` für
  **alle 19** Achsen, alle **21** Lastprofile, **21** SOTA-Reihen (7 Lebewesen × 3 Merge-Stufen),
  `working_set_sweep` 4 Werte, `runtime_dynamic` thread 1|2|4 × hw_prefetcher 3, `repetitions count="3"`,
  `cap="0"`.
- **Maschinerie:** `libs/cache_engine/profile_facade/source_catalog.hpp:190-360` — je nicht-Basis-Achse ein
  Sweep-Katalog (`AxisSweepCatalog` für die 4 vertieften, `AxisSweepCatalogFull` für die 11 übrigen); die
  gesweepte Achse trägt die **VOLLE Enabled-Liste** (`TopicConfigSet::StaticAxisVariants*`), alle anderen
  18 Slots Baseline (Index 0) → Baseline-binary_id byte-identisch zur Basis-320-Baseline (idempotenter Key,
  disjunkter binary_id-Raum). Gate: `tests/unit/thesis_tiere/test_axis_sweep_coverage.cpp` (echter Konsument,
  Anti-Null-Consumer).
- **Treiber-Konsum:** `profile_facade/profile_run_entry.hpp:239-283` — vertiefte Achse ⇒ eigener Sweep-Baum
  aus `axis_sweep_levels(axis)`; **Basis-Achsen (search_algo/node_type/memory_layout/prefetch) sweepen NUR
  über die Basis-320-View** (`is_deepened_axis == false`, test_axis_sweep_coverage.cpp:56-59) — d. h. ihre
  Abdeckung setzt die materialisierte Basis-320 voraus.
- **⚠️ EIGENBEFUND (2026-07-12, selbst verifiziert — Lücke im #18-Stand):** `run_profile` fährt pro Lauf
  genau EINEN Selektion-Pass — Basis (`a.sweep_axis` leer, `profile_run_entry.hpp:272-283`) ODER GENAU EINE
  Sweep-Achse (`:246-270`) — plus die SOTA-Pässe (`:288-320`). **Eine Schleife über ALLE im Profil
  deklarierten `<axis_sweeps>` existiert NICHT**, und der E4-Treiber setzt `sweep_axis` nie
  (`ProfileRunArgs` ohne Setter; grep `sweep` über super `02_messung_driver/main.cpp` = 0 im E4-Block;
  `profile_run_facade.cpp:158` reicht nur `args.sweep_axis` durch). Konsequenz: ein heutiger
  `m3_golden_coverage`-Messlauf über `messung_driver` misst NUR Basis-320 + 21 SOTA — die 19 deklarierten
  Achsen-Sweeps blieben ungefahren. `profile_select` verweigert zudem nur nicht-deklarierte Achsen
  (`profile_runner.hpp:241-262`), führt aber ebenfalls nur EINE aus. Der fehlende Multi-Sweep-Durchlauf
  ist damit ein PFLICHT-Baustein des Smoke-Increments (B.4.1-b) — er repariert zugleich den
  #18-Coverage-Voll-Lauf.

**Warum #18 der Coverage-VOLL-Lauf und KEIN Smoke ist:** (a) Basis-320 + ~80 Sweep-DLLs + 21 SOTA-DLLs ≈
**~421 Tier-Binaries** (Compile je Binary minutenlang, g++-Pilot-Beleg ebd.); (b) Mess-Phase 21 Workloads ×
4 Working-Sets (bis 8,4 M Records) × 9 dyn-Kombinationen × 3 Wiederholungen = **mehrtägig**; (c)
`<thread_count>1 2 4</thread_count>` ist im Ist **LABEL-ONLY unehrlich**: `m3v2_study.profile.xml:137-140`
dokumentiert ausdrücklich „thread_count ist LABEL-ONLY auf 1 gepinnt … runtime_thread_count() hat null
Consumer; echter Threading-Konsum = Fix A (#221-Rest)" — dieselbe Messung würde dreifach verschieden
etikettiert (Anti-Fake-Verstoß im Coverage-Profil; fürs Smoke-Profil korrigiert, s. B.4).

## B.2 Profil-/Job-Mechanik (wie ein Profil den Messlauf steuert)

- **Profil-Auswahl:** super `Code/02_messung_driver/main.cpp:528-530` — env `COMDARE_THESIS_PROFILE`,
  sonst das CMake-gebackene Default `COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE` = `m3v2_study.profile.xml`
  (`Code/02_messung_driver/CMakeLists.txt:24-27`). `--validate <profil>` prüft rein-lesend gegen die
  Registry (SCHEMA.md:57-82; Werte-Quelle = der CODE via `reflect_names`).
- **Mess-Job:** super `.gitlab-ci.yml:408-461` `measure:golden-320` (stage `measure`, INERT bis
  `COMDARE_RUN_MEASURE=="true"`, Runner prod1 `[prod,baremetal,amd]`, timeout 10 d) fährt
  `"$DRIVER" experiment_config measure_out`; `persist:measurements` sammelt CSVs additiv nach development
  (Ledger §11-G/G-c/G-d, `:225-266`).
- **Schema:** `thesis_profiles/SCHEMA.md` — `<axis_sweeps>`, `<sota_series_set>`, `<working_set_sweep>`,
  `<runtime_dynamic>` (inkl. der vier RC-Listen als OPTIONALE Erweiterung), `<run_options>`; alles
  Selektions-/Lauf-Konstrukte, ändern die binary_id nicht (SCHEMA.md:33-38).
- **Bestehendes „smoke"-Profil:** `m3v2_smoke.profile.xml` ist ein cap=2-KLEIN-Profil (S7-Gate-Beweis,
  2 Basis- + 3 SOTA-DLLs) — es berührt bewusst fast nichts und ist NICHT das von #26 geforderte
  Voll-Feature-Smoke; es bleibt unangetastet.

## B.3 Feature-Abdeckungs-Matrix — golden-320 vs. Registry-Bestand (Kern von #9)

Basis: CMake-Enable-Flags (ce `CMakeLists.txt:156-280`, Default-Zählung ON/OFF) + Registry-Listen
(`topics/*/topic_*_config_set.hpp` → `axes/*/…_registry.hpp`). golden-320 permutiert NUR
search_algo(4) × node_type(4) × memory_layout(5) × prefetch(4); die 15 übrigen Slots sind auf Index 0
gepinnt (`m3v2_study.profile.xml:37-62`).

| Achse (Slot) | golden-320 | Enabled (Default) | davon Sweep-abgedeckt (#18) | Default-OFF / ohne Kanal |
|---|---|---|---|---|
| search_algo (L00) | 4 variiert | 4/22 | Basis-320-View | 13 „Tier seziert→deregistriert #42"; 4× per-K k_ary (S18–S21) opt-in; SwissTable S22 opt-in |
| cache_traversal (L01) | 1 (linear_fanout) | 3/3 | ✔ voll | — |
| mapping (L02) | 1 (direct_placement) | 2/2 | ✔ voll | — |
| path_compression (L03) | 1 (none) | 3/3 | ✔ voll | — |
| node_type (L04) | 4 variiert | 4/4 | Basis-320-View | — |
| memory_layout (L05) | 5 variiert | 5/5 | Basis-320-View | — |
| **allocator (L06)** | **1 (std_malloc ×320)** | **25/26** | **✔ voll (25 via AllocatorSweepCatalog)** | VampirNfpAllocator A24 (OFF) |
| prefetch (L07) | 4 variiert | 4/4 | Basis-320-View | — |
| concurrency (L08) | 1 (none) | 9/9 | ✔ voll | — |
| serialization (L09) | 1 (raw_binary) | 4/4 | ✔ voll | — |
| telemetry (L10) | 1 (leaf_only_counter) | 4/4 | ✔ voll | — |
| value_handle (L11) | 1 (inline) | 5/5 | ✔ voll | — |
| isa (L12) | 1 (amd64) | 4/4 | ✔ voll | — |
| index_organization (L13) | 1 (heap) | 4/4 | ✔ voll | — |
| io_dispatch (L14) | 1 (in_memory_only) | 4/4 | ✔ voll | — |
| migration_policy (L15) | 1 (none) | 4/4 | ✔ voll | — |
| filter (L16) | 1 (bloom) | 4/4 | ✔ voll | — |
| queuing_q1 (L17) | 1 (no_buffer) | 15/15 | ✔ voll | — |
| queuing_q2 (L18) | 1 (eager_flush) | 5/5 | ✔ voll | — |

**Ohne Permutations-Kanal (ehrliche Lücken — NICHT per Profil-XML erreichbar):**

- **page_type** (AXIS_01PT, 6/6 ON): kein Slot in den 19 (`kCompositionAxisNames`); Materialisierung =
  Doc 21 §F **Phase 5** („page_type materialisieren"). → Smoke kann es nicht abdecken; Lücke bleibt
  dokumentiert an Phase 5.
- **simd-Extension 09b** (8/8 ON): Sub-Achse des hardware-Topics (`topic_hardware_config_set.hpp:103`),
  nicht im 19er-binary_id-Raum; Effekt heute nur im isa-eigenen `simd_field_sum` (Phase 0.1). → Phase-1-
  Tag-Spread-Thema (Doc 21 §C K).
- **Shape-Sub-Achsen** BST_SHAPE 1/3, BTREE_ORDER 1/5, HASH_PROBE_SHAPE 1/4, SKIP_LIST_SHAPE 1/4 (S7-
  Familien-Hooks, `tier_to_organ_mapping.hpp:44-60` Shaped-Pool-Organe): ihre Träger-Familien (BST/BTree/
  Hash/SkipList) sind im search_algo-Slot deregistriert (#42) → kein Kanal. Erreichbar sind die
  **Pool-Stores** (TreeNodePool/HashBucketPool/SkipListNodePool/BTreeNodePool/ArtTrie/HotPatricia/
  Wormhole/SurfFst/Masstree, `tier_to_organ_mapping.hpp:44-115`) NUR über die **SOTA-Lebewesen-Reihen**
  (Gattungs-Konfiguratoren `compositions/*_reference.hpp`) — deshalb gehören ALLE 21 SOTA-Reihen ins Smoke.
- **RC-Runtime-Unterachsen** (`prefetch_distance`/`pool_budget_bytes`/`batch_size`/`inline_threshold_bytes`,
  SCHEMA.md:21): P4 wurde GEBAUT und REVERTIERT wegen **15 Mess-Defekten (8 CONFIRMED**: batch_size erreicht
  CSV nie, budget-Datenverlust; Übergabe-Doc P4-Eintrag) → **NICHT ins Smoke** bis #221-Rest sauber
  (sonst kaputte/unehrliche Messwerte im Coverage-Anspruch).
- **thread_count > 1**: LABEL-ONLY (B.1) → im Smoke ehrlich auf 1 gepinnt.

**#9 (Phase 0.3b)-Einordnung:** Doc 21 §F:158-162 — „0.3b (Differenzierung) = EXTERN_GATED: golden-320
permutiert die Allocator-Achse NICHT (allocator=std_malloc ×320) + hat keine Pool-Algos → 0.3b inert".
**Der Smoke-/Coverage-Lauf hebt genau diese Inertheit auf:** der Allocator-Sweep fährt 25 Vendors gegen die
Baseline (Flat-Store fädelt `Composition::allocator`, `abi_adapter:2008`), und die 21 SOTA-Reihen fahren
die Pool-Stores, deren axis_06-Anbindung 0.3a (BST `96d5c422`/btree `78334902`/surf `21a9af74`) gelegt hat.
**GO-5-Entscheid zu #9:** die 0.3b-Architektur-Umbau-Option „Tier-Level-Strategie-Besitz" (COW-/Zwei-Phasen-
Protokoll-berührend, Doc 21 §F.2) wird NICHT vor der Messkampagne gebaut (Produktions-Track: kein
Greenfield am Mess-Kern vor dem Voll-Lauf); #9 wird messseitig durch dieses Profil eingelöst, der
Store-Rest bleibt dokumentiert an der PRT_ART-/extension-Schicht.

## B.4 Design: das neue Profil `m3_smoke_coverage.profile.xml` + Job-Parameter

**Ziel:** JEDES Feature 1× berühren (jede Achse jeder Enabled-Wert ≥1×, alle 21 Workloads, alle 7
Frameworks × 3 Stufen, Working-Set-Sweep-Mechanik, hw_prefetcher-Toggles, Resume) — **kartesisch NICHT
explodiert** (kein 320er-Kreuzprodukt, keine Wiederholungs-Matrix), als schneller Vorlauf vor dem
Voll-Lauf. Konstruktion = **je-Achse-Sweep bei fixierter Basis** (die von #18 geschaffene Mechanik,
konsequent zu Ende geführt; ein Covering-Array wäre in der PermutationEngine nicht darstellbar — sie
enumeriert Kreuzprodukte, `cap` schneidet nur Präfixe).

**B.4.1 Die ZWEI nötigen ce-Code-Increments (klein, additiv, #18-Muster):**

**(a) 4 Basis-Achsen-Sweep-Kataloge.** Die 4 Basis-Achsen sweepen heute NUR über die Basis-320-View (B.1)
— ein Smoke mit gepinnter Basis verlöre sie. Lösung (exakt das vorhandene Muster
`source_catalog.hpp:321-342`): **4 neue `AxisSweepCatalogFull`-Instanzen** mit voller Enabled-Liste im
jeweiligen Slot: `SearchAlgoSweepCatalog` (F00 = `StaticAxisVariants_03a`), `NodeTypeSweepCatalog` (F04),
`MemoryLayoutSweepCatalog` (F05), `PrefetchSweepCatalog` (F07) + je ein Zweig in
`axis_sweep_source_map()`/`axis_sweep_levels()`/`is_deepened_axis()` + Erweiterung
`test_axis_sweep_coverage.cpp` (kNonBasisAxes → 19; der „BasisAxesAreNotDeepened"-Test wird angepasst —
Achtung: `m3_golden_coverage` nutzt für die 4 Basis-Achsen weiterhin die Basis-320-View; die neuen
Kataloge liefern DISJUNKTE Sweep-ids mit idempotenter Baseline → kein Konflikt, golden-Roundtrip==320
bleibt Pflicht-Gate). Aufwand: **S** (~60 Zeilen nach Schablone + Test).

**(b) Multi-Sweep-Durchlauf in `run_profile` (der B.1-EIGENBEFUND — Pflicht, sonst misst KEIN
Coverage-/Smoke-Lauf die Sweeps).** Heute: genau EIN Pass pro Lauf (`a.sweep_axis` einwertig,
`profile_run_entry.hpp:246/272`). Additive Erweiterung: ist `a.sweep_axis` leer UND deklariert das Profil
`<axis_sweeps>`, fährt der Treiber NACH dem Basis-Pass **je deklariertem `<axis_sweep>` einen weiteren
Pass** (deepened ⇒ Sweep-Baum-Zweig `:246-270`; Basis-Achse ⇒ nach (a) ebenfalls deepened). Die
CSV-Zeilen sind bereits per Pass getaggt (`row_sweep_axis`, `:203`); Resume (#139) greift je binary_id
unverändert; explizites `args.sweep_axis` behält Vorrang (Einzel-Sweep-Verhalten unverändert =
rückwärtskompatibel). Aufwand: **S** (eine Schleife + Logzeile; kein neues Interface).

**B.4.2 Das Profil (neu, SEPARAT — nichts Bestehendes ändern):**
`libs/cache_engine/algorithm_profiles/thesis_profiles/m3_smoke_coverage.profile.xml`

```xml
<comdare_thesis_profile id="m3_smoke_coverage" schema_version="1">
  <base_tiers> … alle 7 wie m3_golden_coverage … </base_tiers>

  <!-- BASIS GEPINNT: alle 19 Slots je 1 Wert (= Baseline Index 0, identisch zur golden-Baseline).
       Basis-Zellen-Anzahl = 1 (die eine Baseline-DLL, binary_id identisch zur golden-320-Baseline =
       idempotent). KEIN 4x4x5x4-Kreuzprodukt. -->
  <permute_axes>
    <axis ref="search_algo"><value>k_ary</value></axis>
    <axis ref="cache_traversal"><value>linear_fanout</value></axis>
    … (alle 19 wie die gepinnten Zeilen von m3v2_study, je exakt 1 Wert = Index 0) …
  </permute_axes>

  <!-- COVERAGE-KERN: ALLE 19 Achsen sweepen — jetzt inkl. der 4 Basis-Achsen via B.4.1-Kataloge.
       Je Achse jeder Enabled-Wert genau 1x gegen die fixe Baseline. -->
  <axis_sweeps>
    <axis_sweep axis="search_algo" baseline="index0"/>
    … alle 19 …
  </axis_sweeps>

  <!-- Alle Frameworks/Stufen 1x: 21 SOTA-Reihen wie m3_golden_coverage (deckt zugleich die 9
       Pool-Store-Familien = #9-Messpfad). -->
  <sota_series_set> … 7 Lebewesen x 3 Stufen … </sota_series_set>

  <!-- Sweep-MECHANIK 1x berühren, aber klein: 2 Werte (Cache-klein + ein >LLC-Wert für den
       FF1-Regime-Wechsel) statt 4. -->
  <working_set_sweep>16384 8388608</working_set_sweep>

  <compile_dims>
    <workloads>ycsb_a ycsb_b ycsb_c ycsb_d ycsb_e ycsb_f lp_balanced_5050 lp_bulk_insert lp_concurrent_rmw
      lp_delete_heavy lp_dynamic_trace lp_mixed_oltp lp_range_scan lp_read_uniform ih lh coco_p04_neg0
      coco_p04_neg25 coco_p04_neg50 coco_p04_neg75 coco_p04_neg100</workloads>
    <telemetry mode="on" silent="true"/>
  </compile_dims>

  <!-- EHRLICH statt Label-Matrix: thread_count=1 (T8: runtime_thread_count() hat null Consumer —
       Werte >1 waeren dreifach etikettierte identische Messung); hw_prefetcher alle 3 Toggles
       (echter MSR-Effekt, KF-12). KEINE RC-Listen (P4-Revert: 8 CONFIRMED Mess-Defekte). -->
  <runtime_dynamic>
    <thread_count>1</thread_count>
    <hw_prefetcher>all_on adjacent_off all_off</hw_prefetcher>
  </runtime_dynamic>

  <!-- 1 Wiederholung: Smoke prueft Funktion, nicht Streuung (Streuung = Voll-Lauf, KF-10). -->
  <repetitions count="1" interpolate="false" overlay_in_chart="true"/>

  <run_options cap="0" platform="linux-x86_64" build_version="m3_smoke_coverage" resume="true"/>
  <modes>/<static_axes>/<key_value_signature> wie m3_golden_coverage
</comdare_thesis_profile>
```

**B.4.3 Eckdaten (Default-Enable-Stand, herleitbar aus B.3):**

- **Tier-Binaries:** 1 Baseline + Σ(Enabled−1) über alle 19 Achsen
  = 1 + [3+2+1+2+3+4+24+3+8+3+3+4+3+3+3+3+3+14+4] = **1 + 93 Sweep-DLLs** + **21 SOTA-DLLs** ≈ **115 DLLs**
  (vs. ~421 im golden-coverage, ~320 im golden-Lauf). Compile ccache-beschleunigt; grob ¼ der
  Coverage-Bauzeit.
- **Mess-Zellen:** 115 DLLs × 21 Workloads × 2 Working-Sets × 3 hw_prefetcher × 1 Rep ≈ **14,5 k Zellen**
  (golden-coverage: ~421 × 21 × 4 × 9 × 3 ≈ 955 k) → **~Faktor 65 kleiner**; Smoke in Stunden statt Tagen.
- **Optionale Opt-in-Verbreiterung im Smoke-BUILD (kein Profil-/golden-Bruch, END-Append-Semantik):**
  `-DCOMDARE_AXIS_03A_ENABLE_K_ARY_K{2,4,8,16}=ON` (+4 Sweep-DLLs) und
  `-DCOMDARE_AXIS_06_ENABLE_VAMPIR_NFP=ON` (+1) — beide sind END-Appends mit echtem Organ-Pfad.
  **NICHT** SwissTable (`AXIS_03A_ENABLE_SWISSTABLE`): ohne AP-7b-Organ fiele der Mess-Pfad auf
  SortedBinary zurück = unehrliche Messung (Ledger `:296` AP-7a-Scope-Split).
- **Was der Smoke bewusst NICHT abdeckt (ehrlich dokumentiert):** page_type (Phase 5) · simd-09b-Spread
  (Phase 1) · Shape-Sub-Achsen (deregistrierte Familien; nur via SOTA-Pool-Stores implizit berührt) ·
  RC-Unterachsen (#221-Rest) · thread_count>1 (T8/Fix A) · P/E-Core-Domänen (A.5, HW-gated).

**B.4.4 Job-Parameter `COMDARE_MEASURE_PROFILE=smoke|full` (super `.gitlab-ci.yml`, additiv):**

- Neuer Job **`measure:smoke`** (Klon von `measure:golden-320:408-461`, gleicher Runner/Mechanik):
  `rules: $COMDARE_RUN_MEASURE == "true" && $COMDARE_MEASURE_PROFILE != "full"` und exportiert vor dem
  Treiber-Aufruf `COMDARE_THESIS_PROFILE=$CE_DIR/libs/cache_engine/algorithm_profiles/thesis_profiles/m3_smoke_coverage.profile.xml`
  (der env-Hook existiert: `main.cpp:528-530`); Pre-Flight `--validate` wie gehabt; timeout deutlich unter
  dem 10-d-Voll-Lauf (z. B. 24 h).
- `measure:golden-320` erhält zusätzlich `needs: [{job: "measure:smoke", optional: true}]` + rules-Variante
  `$COMDARE_MEASURE_PROFILE == "full"` → **Ablauf wie vom User verlangt: erst Smoke, dann Voll-Lauf** in
  EINER Pipeline (`COMDARE_RUN_MEASURE=true COMDARE_MEASURE_PROFILE=full`), Smoke-only mit
  `COMDARE_MEASURE_PROFILE=smoke` (Default, wenn nur `COMDARE_RUN_MEASURE` gesetzt ist).
- `persist:measurements` sammelt `measure_out` beider Jobs additiv (bestehende Mechanik, §11-G).
- INERT-by-default bleibt gewahrt (ohne `COMDARE_RUN_MEASURE` existiert keiner der Jobs).

**B.4.5 TABU-/Gate-Nachweis:**
`golden_fullpilot_320_binary_ids.txt` unberührt (neues Profil, Basis = 1 idempotente Baseline-id aus dem
golden-Raum, Sweep-ids disjunkt per Konstruktion — dieselbe Eigenschaft, die #18 verifiziert hat);
`permutation_axes.xml` unberührt (Profil nutzt ausschließlich `name()`-Werte der EnabledStrategies, vom
`--validate` gegen den CODE geprüft, SCHEMA.md:78-82); `m3v2_study`/`m3v2_smoke`/`m3_golden_coverage`
unverändert; ABI-Major unberührt (reine Profil-/Katalog-/CI-Additive). **Pflicht-Gates vor Commit:**
ctest inkl. erweitertem `test_axis_sweep_coverage` · `test_profile_roundtrip` „Diff leer" (golden==320) ·
`messung_driver --validate m3_smoke_coverage.profile.xml` wörtlich „VALIDAT OK" · CI strikt grün.

**B.4.6 Aufwand gesamt Teil B: M** — (i) ce: 4 Basis-Sweep-Kataloge + Map/Level/Flag-Zweige + Test (S);
(ii) ce: Multi-Sweep-Durchlauf in `run_profile` (B.4.1-b, repariert zugleich den #18-Voll-Lauf) (S);
(iii) ce: Profil-XML (S); (iv) super: CI-Job `measure:smoke` + rules/needs (S); (v) Verifikation
(--validate, Roundtrip, erweitertes Coverage-Gate, CI) (S). Kein ABI-Bump, kein golden-Rebuild, kein
neuer Programmweg.

---

## Anhang: Verifikations-Anker (Auswahl)

- Ledger GO 5 + Frage 6: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:268-278`
- EXTERN_GATED-Liste: Ledger `:532` · `backups/20260710-plan-code-diff/BACKLOG.md:14-19`
- 7 §H-Forks entschieden: `docs/architektur/20_…md:109-121,144` · `docs/architektur/21_…md:40-50`
- #9/0.3b EXTERN_GATED: `docs/architektur/21_…md:157-162` · §F.2 `:199-233`
- W/D/K + R1/R2 + V32: `docs/architektur/16_…md:246-254`
- R1/R2-Alt-Empfehlung: `docs/sessions/20260710-SESSION-UEBERGABE-schicht-sequenz-komplett.md:22`
- 6er-Kanon (#25, G-6v48): Ledger `:480` · Thesis `kapitel/de/06_evaluation_methodology.tex:87-102`
- Fairness: Thesis `kapitel/de/06_evaluation_methodology.tex:128-136` · H2: `:56-57` · P/E: `:110-112`
- #18-Coverage: `thesis_profiles/m3_golden_coverage.profile.xml` · `profile_facade/source_catalog.hpp:190-360`
  (`axis_sweep_levels` `:370-391`, `is_deepened_axis` `:393-419`)
  · `tests/unit/thesis_tiere/test_axis_sweep_coverage.cpp` · Übergabe `20260711-…-single-xml-path.md:21,32-46`
- Ein-Pass-Befund (B.1): `profile_facade/profile_run_entry.hpp:67,246-283,288-320` ·
  `profile_facade/profile_runner.hpp:185-262` (`profile_select` führt genau EINE Selektion aus) ·
  `profile_run_facade.cpp:158`
- Profil-Auswahl/Job: super `Code/02_messung_driver/main.cpp:273-280,516-584` ·
  `Code/02_messung_driver/CMakeLists.txt:20-35` · super `.gitlab-ci.yml:399-461`
- Enable-Flag-Zählung: ce `CMakeLists.txt:156-280` (per-Achse ON/OFF, u. a. search_algo 4/22 ON,
  allocator 25/26 ON, Q1 15/15, Shapes 1/3–1/5)
- thread_count LABEL-ONLY: `thesis_profiles/m3v2_study.profile.xml:136-141`
- Pool-Organe/Stores: `axes/lookup/composable/tier_to_organ_mapping.hpp:40-115`
