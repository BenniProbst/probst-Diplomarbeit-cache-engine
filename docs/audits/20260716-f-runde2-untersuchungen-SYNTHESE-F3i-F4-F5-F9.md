# F-Runde-2 — Synthesebericht (F3i / F4 / F5 / F9)

Basis-Pfade: `SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` · `CE` = `SUPER/Code/external/comdare-cache-engine` · Cluster read-only. Alle Befunde read-only erhoben, nichts verändert.

---

## F3(i) — 4. merge-Wert „build-übergreifend" (tab:stage-series, 4. Zeile)

**Kernbefund (belegt):** Die 4. Tabellenzeile ist **kein** Kompositions-Merge, sondern eine Vergleichs-Dimension **quer** zu den 3 Stufen. Die 3 MergeStrategy-Werte (`CE/libs/cache_engine/anatomy/pruefling_merge.hpp:130-134`) sind compile-time-Typlisten-Operationen innerhalb **eines** Builds; ein 4. Enum-Wert hätte keine mögliche `MergeImpl`-Spezialisierung — der „alt"-Stand existiert im neuen Übersetzungslauf nicht als Typ, nur als persistiertes Artefakt. Genau das ist eingefroren: `sota_catalog.hpp:31-38+77-85` (#178): `stufe_to_reihe` liefert nie „C" — „Reihe C = build-übergreifend, an keine Stufe gebunden". Der Treiber bestätigt den Hohlraum: `C_MergeAltNeu` (`SUPER/Code/02_messung_driver/main.cpp:131-134,166-170`) fährt heute nur dieselbe Pipeline mit YCSB-A, null Cross-Build-Logik.

**Komplikation:** Die Thesis trägt **drei divergente Reihe-C-Lesarten** — (a) Regression build-übergreifend (03:482+488, 04:335-337), (b) kuratierte Merge-Punkte C.1–C.4 (06:20-24, 03:496-497, Legacy-XML `config_c_merge_alt_neu.xml` mit `<diff_against>`), (c) stale: „Full Join" (07:32, widerspricht #178, Fix in jedem Fall nötig). Der Golden-XML-Kommentar (`experiment_golden.xml:18-19`) verbindet (a)+(b). Ein 4. Enum-Wert (Variante A) ist abzulehnen: semantisch leer, bräche #178 und die compile-time-only-Doktrin. Variante B (Serie-/Vergleichs-Konstrukt in der Experiment-XML) passt in den F2-Serie-Envelope; MergeStrategy/golden/XSD/POD/ABI bleiben unberührt.

**USER-RÜCKFRAGE (entscheidungsreif):**
> F3(i): Die 4. Tabellenzeile ist kein Kompositions-Merge, sondern eine Vergleichs-Dimension quer zu den 3 Stufen; ein 4. MergeStrategy-Wert wäre technisch leer. Die Thesis trägt 3 divergente Reihe-C-Lesarten. Wie soll Reihe C modelliert werden?
> - **Option 1 — Reine Vergleichs-Serie:** neues XML-Konstrukt `<vergleich id="C" baseline="measurement/<datiert>/…">` im Serie-Envelope; diffst persistierte Alt-Läufe gegen den aktuellen Lauf. MergeStrategy/golden/XSD unangetastet; Merge-Punkt-Formulierungen (03:496, 06:20-24) und 07:32 müssen umgeschrieben werden.
> - **Option 2 — Kuratierte Merge-Punkte-Serie:** Reihe C = die 4 defined-Merge-Punkte als kuratierte Stufe-2/3-Tupel. Ebenfalls kein 4. Enum-Wert; aber Widerspruch zur eingefrorenen #178-Zuordnung und zur Tabellen-Zeile in 2 Kapiteln; die Build-Regression hätte keinen Ort mehr.
> - **Option 3 — Beides, explizit gesplittet (EMPFEHLUNG):** Reihe-C-**Punkte** = kuratierte Merge-Konfigurationen (über bestehende Stufe-2/3-Maschinerie, als defined-Tupel in der XML); Reihe-C-**Messung** = build-übergreifend alt-vs-neu genau dieser Konfigurationen. Kein 4. Enum-Wert; Tabelle und Kap. 6 werden konsistent (deckt den Doppelnamen „Merge/Regression alt↔neu" wörtlich, gestützt vom Golden-Kommentar R-C(i)); nur 07:32 bleibt als Fehler zu fixen.
> - **Zusatz-Fork (bei 1/3):** Baseline-Quelle = (a) persistierte Mess-CSV (billig, Cross-Session-Rauschen) oder (b) aufgehobene Alt-Binaries im selben Lauf neu vermessen (teurer, E2-Binary-Aufbewahrung nötig, aber sauberer Regressions-Vergleich)?

---

## F4 — Revert ce 804aa3c2 (Dead-Code-Fehler-Korrektur 13.07.)

**Kernbefund (belegt):** `414ed8c2` (13.07. 13:52) setzte additive DEPRECATED-Banner auf 7 Dateien / 5 „verifiziert-tote" Features; `804aa3c2` (14:19) ist ein **reiner Voll-Revert** aller 7 Dateien. Wörtlicher Auslöser (Transkript): „…das meiste genannte sind fehlerhaft umgesetzte Pflicht features" → „Das waren die Kernfeatures. … Nur honest-100% ist akzeptabel." **Geltungsbereich: alle 5 Header** — aber als **Prinzip** („0 Konsumenten bei Pflicht-Features = unverdrahtet, nicht tot") + genehmigter **Prozess** (research-first je Feature), **kein** Pauschal-Reparatur-Dekret (Beweis: User gab danach selbst Lösch-GO für AbiV1ToV2Mapper, #36/`ebcc5498`). 4 der 5 haben inzwischen ihre Einzel-Entscheidung (#37-A Scheduling-CRTP-Achse, #35/F5 Fassaden-Reparatur, #38 is_original, #36 Mapper-Tilgung); **offen nur hardware/locking/numa** (exakt die E13-Lücke, Ledger :1223). Die Duplikat-These ist substanziell bestätigt: Live-CRTP-Gegenstücke `axis_12` (HW1–HW4), `axis_08` (CC1/CC2 — deckt LockingMode explizit ab), `axis_06` (AA1–AA7 inkl. NUMA-aware), `axis_07_prefetch`. Verifizierte **Rest-Semantik** ohne Live-Gegenstück: `LockingMode::Upgradeable`, aktive `NumaStrategy {Local,Interleave,Preferred,Bind}` als getriebene Wahl, `AtomicFamily` als getriebene Dimension.

**USER-RÜCKFRAGE (entscheidungsreif):**
> F4: Dein Revert galt allen 5 Headern, etablierte aber „unverdrahtet ≠ tot" + research-first je Feature — kein Pauschal-Dekret. Offen sind nur noch hardware/locking/numa. Deine Wahl „Option 3 Reparatur" hat zwei Lesarten:
> - **(3a) Reparatur bereits vollzogen:** Die Live-CRTP-Achsen (axis_12/axis_08/axis_06/axis_07) SIND die korrekte Umsetzung; die 3 vtable-Header werden als historische V32-Design-Dokumente per Banner auf die Nachfolger verwiesen + Provenienz-Strings (`axis_library_registry.hpp:122-243`) umgebogen — keine Löschung.
> - **(3b) Echte Rest-Reparatur:** Die verifizierte Rest-Semantik (Upgradeable, aktive NumaStrategy, AtomicFamily) wird als Sub-Achsen-**Erweiterung der bestehenden Achsen** verdrahtet (kein Parallelbau), danach Header wie 3a bannern.
> NICHT zur Wahl: CRTP-Neubau der 3 Header als eigene Achsen (Parallelstruktur, Direktive Struktur-Analyse-vor-Aufgabe). Welche Lesart — 3a oder 3b? Falls 3b: reicht der genannte Umfang, oder zuerst eine Delta-Matrix Header-Enum ↔ Live-Sub-Achse vorlegen?

---

## F5 — Fassaden-Kette #35 (cache_engine.hpp / E11 / F.4-Tools / get_cache_engine)

**Kernbefund (belegt):** In der gesamten ce-Historie gab es **nie** eine funktionierende Gesamt-Fassade (pickaxe `get_cache_engine` = nur Skelett/F.4/Deprecate/Revert). Ist-Saldo:
- **Funktioniert:** F.4-Tools-Facade (`api/i_cache_engine_tools.hpp`, `get_cache_engine_tools()` inkl. Default-Impl, Test 5/5) + E11-Registry-Hälfte (`api/pruefling_registry.hpp`, 3/3 + prt-art 26/26).
- **Stub/latente Linker-Falle:** `api/i_cache_engine.hpp:47` — `get_cache_engine()` deklariert, **nie definiert**; 6 Provider nur forward-declared; `modules/` = Tombstone.
- **Unverdrahtet (per Doktrin unfertig, nicht tot):** `cache_engine.hpp` (0 Includer; deklariert `get_cache_engine` NICHT selbst — der 414ed8c2-Banner vermengte ihn mit `api/i_cache_engine.hpp`), `concepts::ICacheEngine`/`ISubEngine` (0 Impl).
- **Zusatzbefund:** Doppelbelegung `concepts::ICacheEngine` (U09-Pipeline) vs. `api::ICacheEngine` (Modul-Vermittlung) — reparatur-relevant.
- Revert-Motiv war reine Doktrin-Korrektur, kein technischer Einwand (super-Ledger :390b); das ehemalige V42-Gate für die Impl ist entfallen (arch-Ledger:171 F71 → Richtung #274/Fork-4, user-gated).

**UMSETZUNGS-PLAN (Reparatur-Optionen):**
- **R1 (EMPFEHLUNG, sofort, non-gated):** `get_cache_engine()` als header-only Default-Impl nach F.4-Blaupausen-Muster; Provider-Interfaces real ausformulieren gegen die **heute existierenden** in-repo-Subsysteme (measurement/instrumentation, isa-dispatch, builder/codegen, test_infra); Smoke-Test analog `test_v41_cache_engine_tools_facade`; `cache_engine.hpp` um api-Includes erweitern und ExperimentDriver/f15_compare als ersten echten Konsumenten anbinden (README-Beispiel einlösen). Schließt die Linker-Falle, kein TABU berührt.
- **R2 (user-gated, NICHT autonom):** Provider-Schnitt an #274-Modules-Taxonomie (measurement-all-Familie) ausrichten — braucht Design-Entscheid Fork-4.
- **R3 (im selben Zug wie R1, dokumentarisch):** concepts::/api::-Doppelbelegung auflösen (Umbenennung oder Rollen-Doku); G2/G3 in R1 einbeziehen oder mit ehrlichem DEFERRED-#274-Vermerk (nicht „tot") versehen.

**Vorab-Rückfragen an den User:** (i) „Meintest Du mit ‚gab es schon mal' die V41.E11-Skelett+README-Kette vom 25.05., oder ein älteres/externes Artefakt? In der ce-Historie existierte nie eine definierte `get_cache_engine()`." (ii) „Provider-Schnitt jetzt schon an Fork-4/#274 ausrichten (R2, Dein Design-Entscheid nötig) oder erst R1 gegen die heutigen Subsysteme, Umbau bei Fork-4-Entscheid?"

---

## F9 — PMC/perf-Vollständigkeit

**Kernbefund (belegt):** Infra-seitig ist das **AMD/prod1-Bein seit 25.06. fertig** (Cluster-Memory: Job 189916/Pipeline 6932, `pmc_source.available=1`, `cache_misses_l1=4190096`, SMOKE_OK; CE-DL2-perf-Rechte bestätigt). Die ce-Code-Naht ist komplett (`pmc_source.hpp`, `linux_perf_pmc_source.hpp` via `perf_event_open` ohne Vendor-Lib, Factory, `measurement_snapshot.hpp:117-125`, 7 WIDE-Spalten, pmc-CI-Smokes; `pmc:amd` grün). **Die eigentliche Lücke ist ein einziges Configure-Flag:** super `.gitlab-ci.yml` Z.443 (`measure:smoke`) und Z.519 (`measure:golden-320`) konfigurieren ohne `-DCOMDARE_ENABLE_PMC=ON` (ce-Option default OFF) → der offizielle Mess-Lauf schreibt `pmc_available=0`/alle 6 Felder 0, obwohl der Job-Kommentar „PMC auf prod1" behauptet. Kein Paket nötig. Intel-Bein (prod2) bleibt hardware-blockiert (#189/#63, Harvest 14.07.). Bekannte Rest-Punkte: AMD `cache_misses_l3=0` (LL-Mapping), L2+coherence by design honest-0 bis RAW-Events (#187).

**UMSETZUNGS-PLAN (Increment-Schnitt):**
- **I-PMC-1 (sofort, klein):** `-DCOMDARE_ENABLE_PMC=ON` in super-CI Z.443+Z.519 + Standalone-Preset (F12-Pfad). Akzeptanz literal: `measurements.csv` mit `pmc_available=1` und `pmc_cache_misses_l1>0` im Smoke.
- **I-PMC-2:** AMD-L3=0 klären (LL-Mapping/RAW-Zen5-Event) + `branch_misses` via `PERF_COUNT_HW_BRANCH_MISSES`; CSV-Spalten nur additiv (Messdaten-Doktrin).
- **I-PMC-3 (=#187):** L2 + coherence via `PERF_TYPE_RAW` je CPU-Modell — erst damit alle 6 Spec-Felder real.
- **I-PMC-4 (optional):** PAPI-Sekundärpfad (`libpapi-dev` + `-DCOMDARE_ENABLE_PAPI=ON`); perf bleibt primär.
- **Intel-Bein:** erst nach prod2-Fix + `COMDARE_PROD2_AVAILABLE=true`.
- **G-270a-Abgrenzung:** P/E-Core-Erkennung gehört fachlich zur perf-Vollständigkeit auf Hybrid-CPUs (beide Intel-Kandidaten hybrid), ist aber ein echtes offenes User-Gate (verriegelte Plattform-Tests, E17 geparkt). EMPFEHLUNG: F9 (I-PMC-1..3, reines AMD-Bein, hybrid-unabhängig) NICHT mit G-270a verkoppeln.

**Einziger Fork an den User:** „F9 = prod1/AMD-Bein; ich verdrahte I-PMC-1 und fülle L2/coherence per Zen-5-RAW-Events nach (#187). Soll die P/E-Core-Erkennung (G-270a) im Zuge dessen zur gemeinsamen Sichtung vorgelegt werden, oder bleibt sie bis zum prod2-Fix geparkt?"

---

**Querschnitt:** Alle 4 Stränge sind ohne neue Enum-/Parallelstrukturen lösbar; kein Strang berührt golden/XSD/POD/ABI destruktiv. Sofort autonom umsetzbar: F9 I-PMC-1 (+2,3) und F5 R1+R3. User-Entscheid nötig: F3i (Option 1/2/3 + Baseline-Fork), F4 (3a/3b), F5 (Rückfragen i/ii), F9 (nur G-270a-Kopplung).