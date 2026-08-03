# LEDGER-NACHTRAEGE 03.08.2026 — EINFUEGE-FERTIGE BLOECKE (Nachzug-Paket, Fable-Subagent, read-only erstellt)

> **Ziel-Datei:** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (super). **Referenz-Stand beim Erstellen: 3652 Zeilen**,
> letzter Abschnitt = `## NACHTRAG 02.08.2026 spaetabends (Welle 3 OS-U3 gelandet; ce 6e34e754..7150cc51, ...)`.
> **Doppelt-Check (grep am Ist, 0 Treffer):** Keine der Kennungen `Z-0`, `GA-0`, `GA-1`, `Q-M3`, `CX-W`, `OF-M3`, `DV-3`,
> `0d7a0d92`, `Welle 2d`, `M3-Dossier` existiert im Ledger — nichts aus den Bloecken B–F ist bereits verbucht.
> Bei den Punkt-Korrekturen (Block A) sind die Teil-Verbuchungen zu RF-3 (LEDGER:3608 FK-0-Guard-Registrierung,
> LEDGER:3651 L6-Producer) beruecksichtigt: A1 verweist nur, dupliziert nicht.
> **Einfuege-Reihenfolge-Empfehlung:** ERST die Append-Bloecke B, C, D, E, F ans Dateiende (Reihenfolge B->F),
> DANN die Punkt-Korrekturen A1..A6 RUECKWAERTS (hoechste Zeilennummer zuerst) — so bleiben alle genannten
> Zeilennummern waehrend des Einfuegens gueltig. Jede A-Korrektur traegt zusaetzlich ein Anker-Zitat zur
> zeilennummer-unabhaengigen Lokalisierung.
> **Zeilen-Drift-Hinweis:** Die Katalog-G.0-Nummern (LED:3265/:3468/:3424/:3326/:3235, Stand 02.08.) sind durch die
> Nachtraege vom 02.08. verschoben; die AKTUELLEN Zeilen stehen unten je Korrektur (3288/3491+3499/3447-3449/3349/3258).

---

## BLOCK A — G.0-KORREKTUREN: die 5 veralteten Ledger-Zeilen + RF-3 (Katalog G.0, `docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md`:76-77; alle Belege am Code-Ist 03.08. selbst nachgeprueft)

### A1 — RF-3 `BetriebssystemFeatureFehlt` GEBAUT (Ziel: NACH Zeile 3564)

**Ziel-Stelle:** direkt NACH LEDGER:3564 (der eine grosse §70-Absatz; Anker-Zitat: `**70.3 RF-3 JETZT BAUEN:** D1-Klasse \`BetriebssystemFeatureFehlt\` (Count 4→5 + Drift-Guard + Label) als eigenes Paket`). Neue eigene Zeile einfuegen:

```
> **[Stand 03.08. — 70.3-VOLLZUGS-VERMERK (Katalog-G.0-Nachzug)]:** RF-3 ist GEBAUT und seit 26.07. im Baum: D1-Klasse `BetriebssystemFeatureFehlt` in `measurement/axis_error.hpp:50` (Count 4→5 + Label `betriebssystem_feature_fehlt` + Drift-Guard). Die Folge-Verbuchungen stehen bereits im Ledger und werden hier nur verknuepft, nicht wiederholt: Guard-REGISTRIERUNG = A15/FK-0 (dieser Ledger, NACHTRAG Welle 1, „✅ A15/FK-0 ... VOLLZOGEN", ce 14f63636+62f0e32c); ERSTER PRODUCER = OS-U3 (dieser Ledger, NACHTRAG Welle 3, L6-PRODUCER-VERMERK). Damit ist der 70.3-Auftrag vollstaendig geschlossen.
```

### A2 — #37 PMC-Preflight GEBAUT (Ziel: NACH Zeile 3491; Zusatz-Halbsatz fuer Zeile 3499)

**Ziel-Stelle 1:** direkt NACH LEDGER:3491 (Anker-Zitat: `G4a-Auflage: per-Lane-PMC-Preflight in den emittierten Mess-Batch-Jobs (Grandchild-Strang), Task #37.`). Neue Zeile einfuegen:

```
> **[Stand 03.08. — #37 GEBAUT (Katalog-G.0-Nachzug)]:** Der per-Lane-PMC-Preflight ist in den EMITTIERTEN Mess-Batch-Jobs gebaut: der Director emittiert je Lane den Preflight-Block `cmake --build build --target m3v2_pmc_smoke linux_perf_pmc_smoke` + `ctest --test-dir build -L pmc --output-on-failure` + `[PMC-TESTAT] ts=... lane=<host> pmc=ok` (experiment_plan_director.hpp:1269-1280, am Ist verifiziert; Katalog G.0 nennt zusaetzlich Test + `set -e` in beiden Profilen). Die G4a-Auflage ist damit ERFUELLT; #37 ist als Preflight-Paket GESCHLOSSEN (der Zeilen-Verweis „director:1236-1248" aus Katalog G.0 ist durch Code-Wachstum auf :1269-1280 gedriftet).
```

**Ziel-Stelle 2 (optional, Konsistenz):** LEDGER:3499 endet mit `Preflight im Grandchild bleibt G4a-Auflage (#37/#34).` — KEINE Textaenderung (Doku-nie-editieren), stattdessen deckt der Vermerk unter :3491 beide Stellen; wer mag, fuegt NACH :3499 dieselbe eine Zeile ein: `> **[Stand 03.08.]:** #37-Preflight GEBAUT — s. Vermerk unter §66-NACHTRAG-2 (G4a erfuellt).`

### A3 — measure_out-VERLUSTNAHT GESCHLOSSEN (Ziel: NACH Zeile 3449)

**Ziel-Stelle:** direkt NACH LEDGER:3449 (Ende des Punkts 3 „VERLUSTNAHT VOR MESS-PHASE"; Anker-Zitat: `3. VERLUSTNAHT VOR MESS-PHASE: Code/measure_out ist in Batch-Mess-Jobs weder clean-excluded noch` ... `oder measure_out sichern).`). Neue Zeile einfuegen (Einrueckung wie die Listen-Punkte):

```
   > **[Stand 03.08. — VERLUSTNAHT GESCHLOSSEN (Katalog-G.0-Nachzug, am Ist verifiziert)]:** Beide Haelften sind gebaut (G4a P-C): (1) clean-exclude — die emittierten Batch-Jobs setzen `GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build -e Code/measure_out"` (experiment_plan_director.hpp:1015-1020, bewusst in BEIDEN Batches derselbe Literal-String); (2) CSV-Artefakt — der Mess-Batch-Job traegt `artifacts: when: always` mit `Code/measure_out/<slug>/logs/` UND `Code/measure_out/<slug>/**/*.csv`, expire_in 4 weeks (director:1379-1386; Kommentar dort: „die eigentlichen Messdaten haetten einen Runner-Verlust nicht ueberlebt — Messdaten-nie-loeschen-Doktrin"). Punkt 3 ist damit ERLEDIGT.
```

### A4 — „KEINE geltende experiment_golden.xml" VERALTET (Ziel: NACH Zeile 3349)

**Ziel-Stelle:** direkt NACH LEDGER:3349 (Anker-Zitat: `**F) XML-AUFRAEUM-GATE + GOLDEN-XML NEU (#48).** Es gibt derzeit KEINE geltende experiment_golden.xml`). Neue Zeile einfuegen:

```
> **[Stand 03.08. — TEIL-SUPERSEDED (Katalog-G.0-Nachzug)]:** Der Eingangssatz „Es gibt derzeit KEINE geltende experiment_golden.xml" ist seit 27.07. FALSCH: `experiment_golden_kern.xml` ist KANONISCH und existiert (super `Code/test_data_xml/experiment_golden_kern.xml`, am Ist verifiziert) — die neue golden-XML ist wie hier gefordert „von Grund auf" entstanden und wird gepflegt. Die REIHENFOLGE-DIREKTIVE und der #48-Gate-Charakter dieses Absatzes bleiben unveraendert gueltig; offen aus #48 ist nur noch die Scheibe-6-XML-Sync-Gate-Umhaengung (KATALOG G.5/E: `fixture_sync_check.cmake:3` zeigt aufs Alt-Paar; gated „nach 320er + USER-GO").
```

### A5 — #45 paralleler Mess-Loop GEBAUT (Ziel: NACH Zeile 3288)

**Ziel-Stelle:** direkt NACH LEDGER:3288 (Anker-Zitat: `- **(b) VORBEHALT Z.3172 AUFGELOEST (S6-P1(g)-Verifikationsergebnis):** Es existiert KEIN paralleler MESS-Loop`). Neue Zeile einfuegen:

```
  > **[Stand 03.08. — #45 GEBAUT (Katalog-G.0-Nachzug, am Ist verifiziert)]:** Der parallele Mess-Loop existiert inzwischen: `builder/experiment_tree/measure_parallelism.hpp` + `builder/experiment_tree/parallel_measure_pool.hpp` + Iterator-Dispatch (`cache_engine_builder_iterator.hpp`), Env-Schalter `COMDARE_MEASURE_PARALLEL` (Leser zusaetzlich in `profile_facade/profile_run_entry.hpp` und `profile_facade/experiment_run_entry.hpp`). Der Satz „bis zum Bau des parallelen Mess-Loops ein OFFENES Feature (Task #45)" ist damit GESCHLOSSEN; die ECHTE Messung bleibt unveraendert 1-Thread (§61-MODI — der parallele Loop ist der Debug-Modus-Pfad).
```

### A6 — Mess-Target heisst `comdare_tier_measure_<host>` (Ziel: NACH Zeile 3258)

**Ziel-Stelle:** direkt NACH LEDGER:3258 (Anker-Zitat: `das scharfe CMake-Mess-Target \`comdare_tier_measure_perm<i>\` ist seit S5-P2 noch nicht bare-metal ueber den cmake-Weg durchgefahren`). Neue Zeile einfuegen:

```
> **[Stand 03.08. — NAMENS-KORREKTUR (Katalog-G.0-Nachzug, am Ist verifiziert)]:** Das scharfe CMake-Mess-Target heisst heute `comdare_tier_measure_<host>` (z. B. `comdare_tier_measure_amd`), NICHT mehr `comdare_tier_measure_perm<i>` (experiment_plan_director.hpp:1454/:1457/:1476: „EIN Mess-Target comdare_tier_measure_<host> (SCHARF, misst)"). Die SACHE dieses Absatzes bleibt offen und ist als Paket verbucht: der §61-Dual-Weg-Beleg (einmal bare-metal ueber den CMake-Weg durchfahren, 0 Durchfahr-Belege seit 27.07.) laeuft unter A3 der Trigger-Strecke (KATALOG A3 + G.5).
```

---

## BLOCK B — NACHTRAG Welle 2d (ANS DATEIENDE anfuegen, nach dem OS-U3-Abschnitt)

**Ziel-Stelle:** Dateiende (nach LEDGER:3652, letzter Punkt `- OS-U3 LANDE-HINWEISE (Reviewer, fuer Folge-Wellen): ...`). Folgenden Abschnitt anfuegen:

```
## NACHTRAG 03.08.2026 vormittags (Welle 2d GELANDET — Transport-/Bestandslog-Haertung + Flag-Grammatik; ce 7150cc51..0d7a0d92, dev auf origin gepusht, CI-Wache aktiv)

- HERGANG (ehrlich, inkl. Abbruch): Welle 2d brach am 02.08. spaetabends am MONATS-SPEND-LIMIT ab. Ist-Zustand VERIFIZIERT statt angenommen: der Flag-Cluster (CX-W5 bf6fc810 + CX-W6 3dfb65ad) war fertig committet, nur das Review stand aus; der Transport-Cluster war TEIL-fertig (CX-W3 e073897b + CX-W8 d0b6f40a committet, CX-W1/W2/W4 als dirty-WIP der Opus-Worker). Manager-Verdikt nach eigener Diff-Pruefung: tragfaehig, unfertig, ungetestet -> verifiziert-FERTIGSTELLEN statt verwerfen (wf_0c5c3d92). Voll-Wortlaut: docs/sessions/20260802-OWNER-entscheide-...md, Nachtraege ~22:0x + 03.08.
- COMMITS der Landung (granular, Basis 7150cc51): Flag-Cluster bf6fc810 (CX-W5: Planer-Selbst-Version kPlannerVersion unter Owner-Q10/Q3-Flag-Grammatik, Roh-Literal "v1.0.0", gerendert praefixfrei) + 3dfb65ad (CX-W6: Flag-Grammatik-Wache ueber die VOLLE registrierte Organ-Population, 18 R*-All*-Listen 1:1 zu den T*-Enabled-Listen, alle 122 algo_version-Literale im Scope). Transport-Cluster 3612521e (CX-W2: slice_window_bounds als Spanne (min, max-min+1) statt verlustbehafteter (front,size)-Form, OHNE Wire-Bump — die im Owner-Nachtrag ~21:1x offen gehaltene Wire-Bump-Vorlage war NICHT noetig) + 220a8f8b (CX-W1: Mess-Pfad-Faenger schliesst unbestaetigten Bestand aus — neue Naht mess_pfad_synchron_push, EINE Pfad-Form-Quelle bestand_eintragspfad fuer observe/Pump/Mess-Ausschluss) + 07dde230 (CX-W4: Entfern-Fehler von result.csv.stamp nicht mehr verschluckt; bei stamp_bleibt wird die per-Binary-Ablage NICHT ersetzt — write-ZULETZT-Disziplin) + f51c2828 (Review-Nachbesserung: CX-W2-Gegenprobe dichtes Fenster als Test committet + Kommentar-Etikett CX-W2/CX-W3 richtiggestellt) + 2f12e874 (Z-01/GA-02: der result.csv.stale-rename wird ueber EIGENEN error_code UND Ist beurteilt; bei Fehlschlag KEIN trunc, KEIN Marker in die per-Binary-Ablage, klassifizierte geflushte Zeile; die frueher unbelegte "gesichert"-Behauptung ist belegt oder entfaellt). Merges: 43a1b65a (w2d-Flag-Grammatik) + 0d7a0d92 (w2d-Transport-Bestandslog) in development.
- BEFUND-SCHLIESSUNG: CX-W1..W8 sind SAEMTLICH geschlossen (W1/W2/W4 neu gebaut, W3/W8 aus dem 02.08.-Stand unveraendert uebernommen und im Review als Vorfahren verifiziert, W5/W6 Flag-Cluster, W7 = Hybrid-Design-Doc fc47c5d9 K4+Owner-Fragen-1-2-ENTSCHEIDEN, in der Landung enthalten). Zusaetzlich geschlossen: Z-01/GA-02 (BLOCK aus dem Gesamt-Audit, s. Review-Verbuchungs-NACHTRAG) — damit sind GA-02/GA-03/GA-04, die drei BLOCK-Befunde der Reviews, alle in 2d gefallen. OFFEN als benannte Folgeschulden (kein Blocker, Truth-Check-Verdikt): (1) Mess-Pfad-stamp_bleibt-Zweig ohne Testabdeckung (iterator:1812), (2) Rest-Risiko Fundstelle B (liegengebliebener Alt-Stamp, im Code offengelegt :1802-1805, nur hinter lauter [Infra-Fehler: artefakt_io]-Zeile), (3) Stamp-Write ohne flush/good-Check (:1790-1791, Fehlrichtung sicher: schlimmstenfalls stille Neu-Messung) -> alle drei in die §75-Kandidaten-Fortschreibung (s. Aufraeumpass-NACHTRAG).
- DOPPELLAUF/GATE-ZAHL 331: Flag-Cluster-Doppellauf LITERAL reproduziert — zweimal `100% tests passed, 0 tests failed out of 331` (build-w2d, HEAD 3dfb65ad; Namens-Diff exakt +2: test_planner_version_flag_grammatik + test_reflect_versions_all_registered, Basis 329). Transport-Seite: ctest -N `Total Tests: 329` + Ziel-TU-Doppellauf + TP1_ANKER_OK (Truth-Check selbst erhoben). Nach beiden Merges ist die Gate-Zahl der ce-Linie 331 (KATALOG C2: „Gate-Zahl bei Einfrieren: jetzt 331").
- REVIEWS (Q-M3-GATE-Kadenz, Detail im Q-M3-GATE-NACHTRAG): Flag-Cluster Fable-Adversarial-Review = LANDEBEREIT (CX-W5/W6 selbst verifiziert, Byte-Neutralitaets-Beweis, Negativ-Proben reproduziert; Fix-Liste leer). Transport-Cluster: Erst-Review = NACHBESSERN (EIN landeblockierender Punkt: FREEZE-BRUCH — unkommitteter 6-Zeilen-Test-Hunk, mtime 3 min NACH HEAD; die Bau-Meldung behauptete „FREEZE: git status leer" — am Ist falsch) -> Nachbesserung f51c2828 + 2f12e874 -> Truth-Check der Nachbesserungs-Commits = LANDEBEREIT (u. a. Fall (10) mit 9 Checks, Negativ-Probe VOR-Fix 3 [ERR], TABU-Diff sauber, diff-stat literal 3 Dateien +176/-21). Rohdaten: docs/sessions/backups/20260803-welle2d-abschluss-bau-reviews/ (bau-transport-rest.json, review-transport-nachbessern.json, review-flag-landebereit.json, truthcheck-nachbesserung-landebereit.json).
- LANDUNG: development==0d7a0d92 auf origin gepusht (git rev-parse origin/development verifiziert), CI-Wache auf der Landungs-Pipeline aktiv (Push-zu-Gruen-Doktrin; Gruen-Beleg wird von der laufenden Wache gemeldet, hier bewusst KEIN vorweggenommener Haken). Lokal liegen zusaetzlich zwei docs-only-Commits vor dem Push (743078fa ABGLEICH-Session-Doc + 5c1ac257 Owner-Parallelisierungs-Freigabe) — Nachzug-Push mit dieser Ledger-Welle. main-FF folgt je Welle (Gitflow, D-17-Kadenz).
```

---

## BLOCK C — NACHTRAG Review-Befund-Verbuchung Z-01..Z-12 + GA-01..GA-13 (ANS DATEIENDE, nach Block B)

**Ziel-Stelle:** Dateiende, direkt nach Block B. Folgenden Abschnitt anfuegen:

```
## NACHTRAG 03.08.2026 (Review-Befund-Verbuchung: Wellen-Zweitpass Z-01..Z-12 + Gesamt-Audit GA-01..GA-13 — Zuordnung gefixt / M3-Fenster / Owner-Vorlage / Aufraeumpass)

> Quellen (Rohdaten additiv gesichert): docs/sessions/backups/20260803-resume-halbzeit-flag-review-gesamt-audit/ — wellen-zweitpass.json (Z-01..Z-12, Pruef-Stand 7150cc51) + gesamt-audit-fable-adversarial.json (GA-01..GA-13, 8 Audit-Achsen, Worktree scratchpad/ce-audit-7150cc51) + flag-review-landebereit.json. Alle uebernommenen Befunde wurden am Code-Ist gegengeprueft, nicht abgeschrieben (Dossier §8). Konsolidierte Zuordnung = M3-Dossier v4 §8.2 (super 8edda5eb). Beide Laeufe = Fable-Adversarial-Ersatz-Lens, s. Q-M3-GATE-NACHTRAG.

- **GEFIXT (Welle 2d, s. 2d-NACHTRAG):** GA-02 [BLOCK] == Z-01 [MITTEL] (stale-rename ungeprueft -> trunc-Datenverlust + unbelegte Meldung; Fix 2f12e874) · GA-03 [BLOCK] == CX-W1 (Mess-Pfad-Bestandslog trotz geworfenem Push; Fix 220a8f8b) · GA-04 [BLOCK] == CX-W2 ((front,size)-Slice-Reservierung; Fix 3612521e). Damit sind ALLE drei BLOCK-Befunde geschlossen.
- **M3-FENSTER (A13-M3; Zuordnung bindend nach Dossier v4 §8.2):** Z-03 [MITTEL] Meta-Meta-Wache umgeht die B12-Single-Source, "v1.0.0ce" passiert ungated UND gated (hardware_meta_meta_axis.hpp:129-140) -> Commit C2 (M3a), ZWINGEND VOR C4/ENFORCE=1 · Z-02 [MITTEL] Klammer-Grammatik kollidiert an Gruppen-GRENZEN (`];[` vs. `;` in der Gruppe ergibt identisches Entry-Array samt Ebenen; Kollision per eigenstaendigem Laufzeit-Nachbau bewiesen) -> C2b (M3a), Grammatik-Verschaerfung F6 · Z-09 [KLEIN] Entry-Parser fail-open (fehlendes `=`/`@`, ungueltiger Flag-Schwanz kollabiert still auf 0.0.0) -> C2b, gebuendelt mit Z-02 · GA-06 [KLEIN] scan_stamp_segments constexpr statt consteval, wirft nackte char const* -> C2b-Beifang · Z-07 [KLEIN] Meta-Meta-Versions-Wache sitzt opt-in am Definitionsort statt am Renderer-Engpass; Organ-Meta-Meta-Realm ganz ohne -> C2(iv) Renderer-Engpass-Wache (Audit-F4) · GA-05 [MITTEL] == Z-10 [KLEIN] kOsProbeVersion fehlt in der als „nie handgepflegt" deklarierten Migrations-Naht-Erhebung (der bindende grep findet den Bezeichner nicht; Naht-Klasse (e) selbst ist seit OS-U3 d115e4cc committet) -> M3-Fenster §1h; die Umstellung der Erhebung auf den generischen Wachen-grep ist OWNER-VORLAGE-Kandidat (Audit) · Z-11 [INFO] append_meta_meta_suffix verwirft Pflicht-Anhang bei leerer Realm-Zeile — Auslegung nirgends Owner-dokumentiert -> deklarierter AUSLEGUNGS-Vermerk im K-6-Sweep (C5, Dossier §8.3; sobald je eine Meta-Meta an real LEERER Realm-Zeile haengen soll: Owner-Frage, kein stiller Default).
- **OWNER-VORLAGE:** GA-01 [BLOCK] Fingerprint-Preimage NICHT injektiv (concat der 5 Stempel-Glieder ohne Trenner, Kollisions-Demo literal; anatomy_fingerprint.hpp:69-79 + lazy_adhoc_source_gen.hpp:268-275 + LagerKey-Konsument bestandslog_index.hpp:99-104) -> Owner-Frage OF-M3-1 (Default A: Trenner-Haertung in C3(v) im EINEN M3-Neuanker-Fenster; nach dem Trigger kostet dieselbe Haertung einen ZWEITEN globalen Neuanker ueber 1.572.864 Binaries). Vorarbeit des A2-SHA512-only-Skip-Gates.
- **AUFRAEUMPASS (§75):** GA-08 [KLEIN] Nicht-ASCII-Altbestand 1132 Quelldateien (dominant Box-Drawing U+2500, kein Mojibake) -> §75-Kandidat (Bestands-ASCII-Sweep, s. Kandidaten-Fortschreibung).
- **LEAD-DOKU / KEINE CODE-AENDERUNG:** GA-07 [KLEIN] Migrations-GROESSE war stale — nicht „122(+7)", sondern 194 flaglose "v1.0.0"-Literale gesamt (164 libs/tools/apps + 30 tests); Praezision aus dem Dossier-Audit: Klasse (a) = 122 Literale in 121 Dateien (nicht „123 in 122"); die Teilzahl „24 v1.0.0c" war nicht reproduzierbar (Ist: 37). Zahlen-Nachzug in Bauplan/Dossier v4 §2 vollzogen; dieser Ledger-Eintrag IST der Ledger-Teil des Nachzugs · Z-12 [INFO] K4-Auslegungs-Abweichung (Bauplan-Zeile „NICHT CompilerCompilerErrorClass" vs. OS-U3-Ist OsProbeError=variant<HardwareProbeErrorClass, CompilerCompilerErrorClass>): Lesart im Header ausfuehrlich begruendet (nur fehlende FAMILIEN-Schnittstelle/gescheiterter Familien-Syscall erzeugt die D1-Klasse; Quellen-Zugang reist in HardwareProbeErrorClass) — dokumentierte Abweichung, kein Bau-Task.
- **IST-FESTSTELLUNGEN [INFO]:** GA-09 Waisen-TU-Bestand jetzt 7 (test_meta_meta_halbordnung repariert+registriert; Restliste br4_emit/br4_load/kf16_e2e_real_build/test_a9b/test_c3b/test_d4b/test_rf2) · GA-10 OS-U3 gebaut+tragend getestet, produktiv aber 0 Nicht-Test-Konsumenten — PLANMAESSIG bis OS-U4 (A14-Rest) · Z-04 [MITTEL] OS-U3-Testluecken: gesamte plattform-unabhaengig uebersetzbare macOS-Parser-Logik, Linux-os-release-FALLBACK und 2 der 4 K4-Fehlerklassen (FormatUnbekannt/QuelleUnlesbar) ohne Testaufrufer -> Test-Nachzug in der A14/OS-U4-Folgewelle · Z-05/Z-06/Z-08 [MITTEL/KLEIN/KLEIN] E-04-P1-Nachbesserungen (PLAN-TESTAT mischt Invocation- und Fenster-Skala in einer Zeile; marker_fenster (front,size)-Form fuer lueckenhafte Selektionen mehrdeutig; zelle=-Ableitung Shell roh vs. Treiber defaultet asymmetrisch) -> A7-Rest (E-04-VOLLAUSBAU vor Trigger, Owner-R9); dazu die Zweitpass-Zuordnungs-Punkte: Mess-Phase hat noch KEINE Marker-v2-Zeile (E-04-P2/P4-Scope, ausdruecklich zuordnen) und die unbedingte [TESTAT]-Shell-Zeile nach [FEHLER-TESTAT] (P1-Nachzug oder P4-Parser-Regel).
- **WIDERLEGT (Adversarial-Gegenproben, Kanon bestaetigt):** GA-11 („drei std::variant-Fundstellen landen in einem plain Tier-Binary" — Include-Closure-Beweis: keine aktive variant-Instanz in der Tier-TU; V7.2/HY-D1 haelt) · GA-12 (COUNT/REMAIN-Shell-Zeile bricht den Batch unter set -e NICHT) · GA-13 (catch(...) im AsyncPushPump verschluckt den Teil-Marker-Fehler NICHT stumm).
```

---

## BLOCK D — Q-M3-GATE: Option-(b)-Vermerk (ANS DATEIENDE, nach Block C)

**Ziel-Stelle:** Dateiende, direkt nach Block C. Folgenden Abschnitt anfuegen. (Das ist der im Owner-Nachtrag ~21:2x vom 02.08. AUSDRUECKLICH geforderte Ledger-Vermerk fuer den Fall Option (b).)

```
## NACHTRAG 03.08.2026 (Q-M3-GATE ERFUELLT ueber Option (b) — AUSDRUECKLICHER LEDGER-VERMERK gemaess Owner-Entscheid ~21:2x 02.08.)

- OWNER-GATE-DEFINITION (docs/sessions/20260802-OWNER-entscheide-...md, Nachtrag ~21:2x): A13-M3 startet erst nach gelandeter Welle 2d UND einem Review-Gate — primaer (a) Codex-Zweitreview auf einer FUNKTIONIERENDEN Codex-Umgebung; falls nicht erreichbar (b) Fable-xhigh-Adversarial-Review als Ersatz-Lens MIT ausdruecklichem Ledger-Vermerk; (c) reine Verschiebung ausgeschlossen (Frist Do 07.08.).
- CODEX-AUSFALL ZWEIFACH HART BELEGT (nicht angenommen): In BEIDEN unabhaengigen Review-Runden auf prod1 antwortete Codex (sandbox=read-only, approval-policy=never, cwd=ce) auf JEDES Kommando ausschliesslich mit `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`; der harte Zugriffstest (git-HEAD-SHA einer bekannten Datei) wurde nicht einmal falsch beantwortet, sondern gar nicht — kein Halluzinat, sondern der woertlich durchgereichte bwrap-Fehler. Keine Rechte-Eskalation vorgenommen (danger-full-access = Owner-/Permission-Entscheid). Rohdaten-Beleg: lens-Felder in wellen-zweitpass.json + gesamt-audit-fable-adversarial.json (backups/20260803-resume-halbzeit-flag-review-gesamt-audit/).
- GATE-ERFUELLUNG OPTION (b) — DREI Fable-xhigh-Adversarial-Laeufe + zwei Cluster-Reviews: (1) Wellen-ZWEITPASS W1/2a/2c auf dem eingefrorenen Stand 7150cc51 (Worktree wt-zweitpass-w1w2a2c, 12 Befunde Z-01..Z-12, davon 11 BESTAETIGT/1 PLAUSIBEL, mit zwei eigenstaendigen Compile-/Laufzeit-Beweisen); (2) GESAMT-AUDIT Code vs. Gesamt-Anforderungen/Kanon ueber 8 Achsen (13 Befunde GA-01..GA-13, 3 davon WIDERLEGTE Adversarial-Verdachte — die Lens hat aktiv gegen den Kanon angerannt, nicht bestaetigt); (3) M3-DOSSIER-GRUENDLICHKEITSAUDIT (Verdikt GRUENDLICH-MIT-LUECKEN, 43 Soll-Punkte: 36 gedeckt/6 fehlend/1 falsch; F1-F6 + Zaehlkorrektur in Dossier v4 vollstaendig eingearbeitet — Erledigungs-Nachweis v4). Dazu je Cluster der Welle 2d ein Fable-Adversarial-Review (Flag LANDEBEREIT; Transport NACHBESSERN -> Nachbesserung -> Truth-Check LANDEBEREIT), s. 2d-NACHTRAG.
- VERBLEIBENDE CODEX-SCHULD (ehrlich, aus dem Zweitpass): dieser Lauf ist die Ersatz-Lens (b), NICHT die Codex-Haelfte des Dual-Reviews nach Arbeitsweise v2.1. Sobald eine funktionierende Codex-Umgebung ausserhalb prod1 erreichbar ist, verdienen Z-02 und Z-03 die unabhaengige zweite Lens am dringendsten (beide identitaets-/stempel-nah, gehen direkt in A13-M3 ein).
- FOLGE: Das Q-M3-GATE ist ERFUELLT; A13-M3 ist STARTKLAR, sobald die 2d-Landungs-Pipeline gruen gemeldet ist (Reihenfolge unveraendert bindend: 2d landen -> M3 (+FK-5 im Fenster) -> M4 -> OD-10-RT).
```

---

## BLOCK E — M3-Dossier-v4-Verweis + 3 offene Owner-Defaults (ANS DATEIENDE, nach Block D)

**Ziel-Stelle:** Dateiende, direkt nach Block D. Folgenden Abschnitt anfuegen:

```
## NACHTRAG 03.08.2026 (A13-M3-AUSFUEHRUNGS-DOSSIER v4 = bindende Bau-Quelle; 3 offene Owner-Punkte OF-M3-1/OF-M3-2/DV-3)

- DOSSIER-VERWEIS (bindend fuer den M3-Worker): `docs/sessions/20260803-DOSSIER-a13-m3-ausfuehrung.md` in der Fassung v4 (super-Commit 8edda5eb „Audit-Luecken F1-F6 geschlossen, OF-M3-2 neu, Zaehlung 122/121 korrigiert"; Vorstufen v2 cd373624 / v3 e340b835 = Historie). v4 ist GRUENDLICHKEITS-AUDITIERT (Audit-Verdikt-Rohdaten: backups/20260803-m3-dossier-gruendlichkeitsaudit/audit-verdikt.md; nach F1-F6-Einarbeitung als GRUENDLICH einstufbar): Fundstellen-Inventur, Literal-Neuzaehlung, C1-C5-Commit-Plan (M3a/M3b), 15 Risiken inkl. Rollback, Startklar-Checkliste §7, FK-5 faehrt im M3-Fenster mit (A15-K9/R14), W10/E-24-Nachbar-Abgrenzung (R15). A13-Stand damit: M1+M1b+M2 FERTIG, M3 STARTKLAR (Gate: 2d-Landung gruen + Q-M3-GATE erfuellt, s. eigener NACHTRAG), M4 danach.
- OFFENE OWNER-PUNKTE (E-21-VERBOSE-Form im Dossier §6; laufen bei Nicht-Antwort mit dokumentiertem Default, Einspruch jederzeit):
  1. **OF-M3-1 — Fingerprint-Preimage haerten oder deklariertes Restrisiko?** (aus GA-01 [BLOCK], Kollisions-Demo literal.) Option A = Trenner `'\n'` zwischen allen 5 Preimage-Gliedern, in allen 4 Rechen-Stellen im EINEN C3-Neuanker-Commit + Injektivitaets-Negativprobe. Option B = nichts aendern, Nicht-Injektivitaets-Klausel in Ledger + F7/Gate-Definition. **Empfehlung + DEFAULT: A** — gleicher Preis jetzt, ZWEITER globaler Neuanker ueber 1.572.864 Binaries spaeter; die Injektivitaet traegt das A2-SHA512-only-Skip-Gate.
  2. **OF-M3-2 — Overlay-Definition (S8) im M3-Fenster oder deklarierter zweiter Neuanker?** (hochgestuft aus dem frueheren DV-2, weil Lage-Dossier GATE 9 die S8-Overlay-Definition AUSDRUECKLICH im Golden-Neuanker-Fenster verortet — Plan-Widerspruch wird vorgelegt, nicht per Default wegentschieden.) Die Overlay-Naht ist GEBAUT (5. Preimage-Glied, COMDARE_OVERLAY_SOURCE_HASH, ehrlich leer; anatomy_fingerprint.hpp:37-55), es fehlen Pre-Build-Codegen + die 3 Owner-Festlegungen (Verzeichnis-Schnitt, Sortier-Ordnung, Hash je Datei vs. Konkatenation). Option A = im M3-Fenster scharf (Codegen nach COMDARE_GN_ALGO_SIG-Muster). Option B = leer lassen + Kosten-Ausweis + owner-ratifizierter GATE-9-Supersede-Vermerk. **Empfehlung + DEFAULT: A KONDITIONIERT** — Bedingung: die 3 Festlegungen liegen bis M3-Start vor; sonst laeuft automatisch B mit explizitem GATE-9-Supersede-Vermerk (kein stiller Ausfall).
  3. **DV-3 — CX-W13/V4 `"v0"`-Kurzform-Sentinel im ROHEN .algos-Signatur-Pfad** (axis_variant_version_table.hpp:181-185; gerendert byte-neutral @0.0.0). Option (a) = ohne V4-Antwort bleibt der Zweig UNANGETASTET (bewusst dokumentierter Sentinel). Option (b) = Rueckbau "v0"->"v0.0.0" im Sidecar = .algos-Byte-Ereignis, wird in C4 gebuendelt (Ein-Fenster-Logik). **DEFAULT: (a)**, (b) als vorbereiteter Buendelungs-Platz.
- Weiterer dokumentierter Default (kein Owner-Gate): **DV-1** — merge-Stempel-CODE (merge_stamp_line, _MERGE-Makro, Emitter-Zweige) wird gemaess Owner-E2 („Merge Zeile kann daher nicht existieren") SOFORT in C3 ENTFERNT statt nur deprecated (Default (a); ein stehender toter Stempel-Zweig waere ein dritter Ableitungsweg in Wartestellung, O-8-Lehre). Die Merge-DURCHFUEHRUNG (merge_plan.hpp) bleibt unberuehrt (Owner-Q2).
```

---

## BLOCK F — §75-Aufraeumpass-Kandidaten-Fortschreibung (ANS DATEIENDE, nach Block E)

**Ziel-Stelle:** Dateiende, direkt nach Block E. Folgenden Abschnitt anfuegen. (Nummerierung setzt die G.4-Liste des KATALOGs fort, die bei (18) endet; die 2b-Fortschreibung LEDGER:3642 — Kandidat (1) entschaerft, Bestands-ASCII-Sweep — bleibt gueltig und wird hier praezisiert.)

```
## NACHTRAG 03.08.2026 (§75-Aufraeumpass-Kandidatenliste FORTGESCHRIEBEN — Zugaenge aus Welle 2d + Reviews; Liste-fortschreiben-Doktrin LEDGER:3584)

- **(19) Stales Haupt-Build-Verzeichnis `ce build/` mit 17-Achsen-Codegen:** `build/generated/generated_source_catalog.hpp` (mtime 26.07. 12:50 UTC) traegt nur L00..L16 = 17 Organ-Achsen-Listen und KEIN persistence_target — eingefroren VOR ORG-18/T17 und vor allen A-Strecken-Wellen; wer im Haupt-build baut, baut gegen den alten Achsen-Stand (MEMORY-Lehre „Lokale Voll-Bau-Luecken = falsches Gruen"). Massnahme: Haupt-build regenerieren oder raeumen; dazu Sichtung der uebrigen Alt-Build-Dirs (build-cmd1a/-cmd1b/-conf/-go2/-go2-pre/-ninja-s4/-perms-fix/-v6, build-w1/-w2d in Worktrees). **HARTE VORSICHT: `build/` enthaelt getrackte Mess-CSV — vor jedem rm den Memory-Anker `reference_ce_build_dir_has_tracked_measurement_csv` pruefen; Messdaten nie loeschen.** (Quelle: ABGLEICH 03.08. Abschnitt F, am Ist verifiziert.)
- **(20) Stamp-Write ohne flush()/good()-Check** — `cache_engine_builder_iterator.hpp:1790-1791` (`std::ofstream sf{...}; if (sf) { sf << binary_resume_stamp ... }`): Fehlrichtung ist SICHER (fehlender/zerrissener Stamp -> kein Resume-Anspruch -> stille Neu-Messung; der Resume-Leser faengt Teil-Stamps ueber Praefix/rows), Kosten nur Rechenzeit. Vorbestehend, NICHT von 2d eingefuehrt; Truth-Check-Befund KLEIN. Massnahme im Aufraeumpass: expliziter flush+good-Check mit klassifizierter Zeile.
- **(21) W2d-Folgeschuld Mess-Pfad-Testluecke** — der stamp_bleibt-Zweig des MESS-Pfads (`cache_engine_builder_iterator.hpp:1812`) hat keine Testabdeckung (Faelle (9)/(10) treiben nur den Bau-Fehler-Zweig); der Zweig ist musterexakt zur getesteten Bau-Wache :1573-1592 gebaut. Als Folgeschuld deklariert (2d-NACHTRAG); Massnahme: gezielter Negativtest (blockierender Stamp im Mess-Lauf). Verwandt, gleiche Ablage: Rest-Risiko Fundstelle B (:1802-1805, liegengebliebener Alt-Stamp — im Code offengelegt, nur hinter lauter [Infra-Fehler: artefakt_io]-Zeile; Doku-Kandidat, kein stiller Fix).
- **(22) Bestands-ASCII-Sweep quantifiziert (praezisiert den 2b-Vermerk LEDGER:3642):** GA-08 — 1132 Quelldateien mit Nicht-ASCII-Altbestand (dominant Box-Drawing, 83224x U+2500; Spitzenreiter tests/unit/CMakeLists.txt 253, cache_engine_builder_iterator.hpp 229, experiment_plan_director.hpp 135). Kein Mojibake; ASCII-Auflage gilt fuer NEUE Zeilen — der Bestand faellt im Abschluss-Aufraeumpass, nicht in Feature-Paketen.
```

---

## ANHANG — Pruefprotokoll „nichts doppelt" (fuer den Lead, nicht einzufuegen)

1. Ledger-Ende bei Erstellung = OS-U3-NACHTRAG (LEDGER:3647-3652); Wellen 1/2c/2b/3 sind verbucht (LEDGER:3595/3611/3626/3647), Welle 2d und alles vom 03.08. NICHT.
2. grep im Ledger auf `Z-0|GA-0|GA-1|Q-M3|CX-W|0d7a0d92|Welle 2d|OF-M3|DV-3|M3-Dossier|Dossier v4` = 0 Treffer.
3. RF-3: Teil-Verbuchungen existieren (LEDGER:3608 FK-0, LEDGER:3651 L6-Producer) — Block A1 verweist darauf, statt zu wiederholen; neu ist NUR der Vollzugs-Vermerk direkt an §70.3.
4. §75-Fortschreibung: LEDGER:3642 (2b) entschaerfte Kandidat (1) und nannte den ASCII-Sweep unquantifiziert — Block F praezisiert (22) ausdruecklich als Fortschreibung, keine Dublette; (19)-(21) sind neu.
5. Alle G.0-Fakten am Code-Ist 03.08. selbst nachverifiziert (Dateien/Zeilen in den Bloecken genannt); Zeilen-Drift gegenueber Katalog G.0 je Block ausgewiesen (director:1236-1248 -> :1269-1280).
6. Landungs-Ist verifiziert: origin/development == 0d7a0d92 (git rev-parse); lokal development == 5c1ac257 (ahead 2, docs-only 743078fa + 5c1ac257). CI-Gruen der Landung bewusst NICHT behauptet (Wache laeuft; kein Haken ohne literale Ausgabe).
