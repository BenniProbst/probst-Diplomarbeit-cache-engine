# Chunk 17/38 — Extraktion (Diplomarbeit-Managersession, 17.07.2026)

Quelldatei: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/neugruendung-20260802/tk_17.txt` (1644 Zeilen)

Chunk-Rahmen: beginnt am **@Q2-Freigabe-Gate** (Stack blockiert), endet mitten in **Bau-INC-2c.opt** (3 offene Forks OF-1..OF-3). Grosser Teil des Chunks besteht aus ~30 identischen §0-GOAL-V6-Stop-Hook-Wiederholungen (inhaltlich redundant, hier nur einmal referenziert).

---

## (a) User-Direktiven chronologisch (WOERTLICH wo bindend)

**D1 — Q2-Ruling = Option C + GO fuer den Bau** (Z.36, verbatim, bindend):
> „Option C: Die CEB bekommt die Einstellungen vom Experiment-Planer, aber Permutiert etwa simd_extension selbst für die Systemachse zu seiner Laufzeit durch, um Tier-Binaries zur compile time mit diesen Eigenschaften auszustatten und durchzumessen. Daher sind die Systemachse der Erweiterungshardware (SIMD, GPU) eine weitere eigene Systemachse, die erstmal nur auf SIMD ausgedehnt wird. GO für den Bau"

**D2 — @SYNC-1 Dreifach-Freigabe** (Z.540, verbatim, bindend):
> „ W3-Ruling: A freigegeben wie empfohlen, wir implementieren immer so sauber wie möglich. GO INC-2 freigegeben wie empfohlen. Thesis push go, fregegeben"

(Der Agent leitete daraus explizit ab: GO INC-2 deckt die **gesamte** Phase 2a–2h inkl. 2c — verbucht Ledger §20.B, super `0a2b0bf`.)

**D3 — Alt-golden-320 darf brechen / additiv-zuerst** (Z.629, verbatim, bindend):
> „Hinweis: ich bin ok damit, wenn wir die alt golden 320 für die Implementierung einer leichteren Wartbarkeit und allgemeingültigeren Metaprogrammierung brechen. Also erst Additiv handeln und dann können wir gerne auch mal aufräumne ohne Funktionalität zu verlieren und ohne unnötig Funktionalität von der compile time für die Laufzeit-teure runtime umzubauen (nur unter Absprache)"

**D4 — Parallelitaets-Politik Aufbauphase** (Z.714, verbatim, bindend):
> „Hinweis: du darfst mit 8 Threads bauen und mit allen 24 Threads im Debug mode parallel Messungen durchführen, solange wir das System aufbauen und noch nicht \"echt\" messen"

(1-Thread-Regel gilt weiter fuer echte Messlaeufe.)

**D5 — Klaerung der „5%": gehoert zur Compiler-Achse, nicht zum Layout-Check** (Z.1346, verbatim, bindend):
> „Die 5% die sich replizieren waren eigentlich im Kontext gedacht, das die compiles von verschiednen compiler binaries bis 5% unterschiedliche Performance gegen dieselbe Achsenkonfiguration liefert, ich denke das hat mit dem Rest wenig zu tun und wir wollen das zusätzlich über die compiler Achse ausmessen und bestimmen"

**D6 — F1/F2/F3-Rulings zu INC-2c.opt + Kompetenz-Ruege** (Z.1523, verbatim, bindend, ARCHITEKTUR-KERN):
> „F1: Die Optimierungsstufe ist eine dynamische Unterachse unter der System-Haupt-Achse für die compiler. Dort werden auch Flags als Unterachsen je compiler (verschiedene Flags und commands jeweils) verwahrt und permutiert, um unterschiedliche Tier-Binaries über diese Achse erzeugen zu können. Die 6 oder mehr Systemachsen sind dokumentiert. F2: Voll, zusätzliche Unterachsen forcieren auch voll die Verwendung maximaler Hardware-Erweiterungs-Verwendung (SIMD, AVX, deep research über Hardware Erweiterungen). F3: Die Optimierungen sind eine per XML konfigurierbare Achse mit XML konfigurierbaren Unterachsen (per PLAN ist ALLES in XML konfigurierbar, ultracode). Die Definition von global EXISTIERT NICHT in einem DYNAMISCHEN System. Möchtest du aufgrund der Komplexität besser warten, bis Fable 5 aus dem Kontingent-Urlaub zurück ist? Denn das Verständnis auf deiner Seite ist schlecht."

**D7 — Achsen-Nachschlagewerk als Nebenstrang** (Z.1584, verbatim, bindend):
> „Bitte finde in einem zusätzlichen ultracode workflow alle Haupt-Achsen und Unterachsen für die Systemachsen und Mess-Achsen und erstelle eine Dossier Tabellen Übersicht aller Abhängigkeiten über die gesamte Planung, ledger, Architektur. Das Ziel ist ein Nachschlagewerk für die Übersicht über alle in diesem Zustand geplanten Achsen, weil wir den Überblick verlieren. Wir legen aber diese Planung nur ab und bleiben beim Hauptstrang."

**Status-Nachfragen (nicht bindend):** „Wo stehen wir?" (Z.644) · „Das dauert jetzt schon sehr lange, läuft es noch?" (Z.664) · „Wie weit sind wir?" (Z.691) · „Der compile und Messung dauern ungewöhnlich lange, bitte prüfe den stand oder ob es hängt" (Z.739) · „Bitte fahre fort" (Z.1168).

**REDAKTIONS-LUECKE — 5 User-Direktiven fehlen im Auszug, nur die Assistant-Reaktion ist erhalten** (Wortlaut NICHT belegbar, Inhalt aus der Reaktion rekonstruiert):
- Z.1253: „Wichtige Direktive" = **Increments muessen architekturkonform sein (F12III-DESIGN-VORLAGE + BAUPLAN-INC2), nicht „gruen um jeden Preis"** → loeste die Nachbesserung der 2 abgekuerzten Test-Stellen + eine adversariale Konformitaets-Pruefung aus.
- Z.1354: **„Option A, aber richtig: volle Kontrolle nach Plan"** — Optimierungsstufe gehoert als Flag zu einer System-Achse, planbasiert, nicht ad-hoc.
- Z.1403: **Reihenfolge festgelegt: (1) Konformitaets-Auflagen abarbeiten, (2) 2c committen, (3) dann Option A** (loeste das dual-gruen-Dilemma des Agenten auf).
- Z.1411: **„Wichtige Verschaerfung": jede Abweichung / jede Architektur-Naht zuerst per ultracode-Planung gegen Ledger+Plaene, nie raten** (Memory aktualisiert).
- Z.1557: **„Volles GO" — nicht auf Fable 5 warten**, plus praezise Rueckmeldung: der Fehler war, dass Achse-vs-Unterachse gar nicht erst zur Abwaegung gestellt wurde.

**Umgebungs-Ereignis:** Z.1163-1165 `/model` → Modell auf **Opus 4.8** gesetzt und als Default gespeichert; `.claude/settings.json` pinnt Fable 5 (greift erst bei Restart). Direkter Kontext zu D6 („Fable 5 aus dem Kontingent-Urlaub").

---

## (b) Architektur-/Scope-Entscheidungen mit Begruendung

**E1 — Q2 = Option C: Erweiterungshardware wird 6. System-Achse** (aus D1). CEB permutiert `simd_extension` zur eigenen Laufzeit durch (Einstellungen vom Planer), stattet Tier-Binaries compile-time damit aus. Getrennt von der Hardware/Host-Deskriptor-Achse. Damit **6 CEB-System-Achsen**: Scheduling(#37) · Hardware/ISA (Host-Deskriptor+Gate) · Telemetrie · Last/Last-Frameworks · Compiler(gcc|clang) · Erweiterungshardware(SIMD→GPU).

**E2 — Q1-Dach: `topics::Axis<Derived>` als semantik-freier Layer Supertype** (Fowler) mit `AxisConcept` + `AxisKind`-Diskriminator (organ / system_measurement / system_config). `CebSystemAxis<Derived>` (Konfig-Wurzel) und Mess-`SystemAxis<Derived>` als **Geschwister-Wurzeln** unter dem Dach. Begruendung: Concept-Guard `is_empty && !is_polymorphic` faengt jede kuenftige vtable-Einschleppung compile-time; Blut-Direktive (Familien schneiden sich nicht) durch Guard-Block D bewiesen.

**E3 — W3 = Option A: golden-Neu-Materialisierung als eigenes Bau-INC-3** (aus D2). Begruendung des Planungs-Workflows, vom User bestaetigt: (i) trifft F12III-DESIGN-VORLAGE §7 + LEDGER:88 woertlich, (ii) haelt die Doktrin „je Schicht 1 Review/Backup" (golden-Regeneration IST eine eigene Schicht), (iii) entkoppelt ABI-/Struktur-Bruch vom Fixture-Churn. Option B (in INC-2 gefaltet) verworfen: verwoben, schwerere Rueckfuehrung, kollidiert mit Schicht-Doktrin — „sauberste, nie einfachste Strategie".

**E4 — INC-2-Schnitt 2a–2h** (Bauplan-Dossier): 2a Planer-Dock benennen + Pruef-Dock scharf + Iterator-Bypass (ABI-4-neutral) → 2b Major-Flip 4→5 + Magic `.A4.`→`.A5.` → 2c F12iii Telemetrie-Herausloesung → 2d Set-Ebene-1 (F1b) → 2e Set-POD-V2 + SetDock (F2) → 2f #37 Scheduling-CT als einziger Traeger → 2g Metadaten-Version (AVX10-Feld + `-march`/Compiler-Provenienz) → 2h golden-Neubau (W3-gestaltet, per A nach INC-3 verschoben). Je Increment golden-Regenerierungs- + POD/ABI-Diff-Checkpoint (V6.7-Pflicht).

**E5 — F12iii-Semantik: Organ bleibt, permutiert nicht mehr.** Telemetrie verlaesst den binary_id-permutierenden Kompositionspfad; `axes/telemetry_axis/` (5 Strategien), `topics/telemetry/`, `ObservableTelemetry` und die 5 dedizierten Telemetrie-Tests bleiben **vollstaendig intakt** als Mess-Infrastruktur. Explizit geprueft und bestaetigt.

**E6 — Alt-golden-Doktrin** (aus D3): erst additiv einfrieren (`…_abi4`), Aufraeumen spaeter erlaubt, aber ohne Funktionsverlust, **ohne compile-time→runtime-Degradierung**, nur unter Absprache. Als Memory + im Ledger verankert.

**E7 — Compiler-Achse trennt zwei verschiedene 5%** (aus D5): (a) **Compiler-5%** = Delta verschiedener Compiler-Binaries gegen *dieselbe* Achsenkonfiguration → Gegenstand der Compiler-System-Achse, separat auszumessen. (b) **memory_layout-5%** = Stride 48 (aos_strict) vs 64 (cache_line_aligned) → voellig andere Achse. Der Agent hatte beides verwechselt.

**E8 — VERWORFENE Erst-Verortung von INC-2c.opt (Fehl-Entscheidung).** Erstes Dossier (`wf_abf79fd6`) empfahl per Elimination eine **neue dedizierte `OptimizationLevelSystemAxis`** als Geschwister unter `CebSystemAxis`, und schloss die Compiler-Achse aktiv aus (Verwechslung mit der Compiler-5%). Vom User in D6 verworfen.

**E9 — KORRIGIERTE Verortung (bindend, aus D6): Compiler-System-Haupt-Achse ⊃ dynamische XML-Unterachsen.** `opt_level` (VOLL {O0,O1,O2,O3,Ofast}), `flags`, `commands` — je Compiler verschieden — plus HW-Erweiterungs-Unterachsen. Der Experiment-Planer permutiert sie: **E4-XML → E3-Perm → E2-Binary**. Kategoriale Fixierung: System-Achsen-Unterachse (Fluss = CompileFn-Flag + H-10-Sidecar, **binary_id-NEUTRAL**), Vorbild strikt `extension_hardware`, NICHT `cacheline`/AxisLevel-Baum. **„global" existiert im dynamischen System nicht** — das hartkodierte `-O2` ist genau die zu tilgende Luecke.

**E10 — Deep-Research-Befunde (belegt, mit Quellen) zur Unterachsen-Wertliste:** clang defaultet seit Clang 10 `-mprefer-vector-width=256` → AVX-512-ZMM erst mit explizitem `=512`; `-fno-gnu-unique` GNU-only; `-Ofast` = `-O3` + `-ffast-math`-Familie + `-fallow-store-data-races` → bricht IEEE-754 **und** die T08-Concurrency-Achse; psABI-Level `x86-64-v2..v4` strikt geschachtelt (v4-Binary laeuft nicht auf v3-Host); `-mavx10.1-512/-256` in gcc 15 deprecatet. **Schlussfolgerung: geteilter Flag-Kanal braeche clang-Builds — per-Compiler-Werte sind Pflicht.**

**E11 — Nicht-Entscheidung bewusst offengelassen:** F12i-§12-Ledger-Eintrag chronologisch verrutscht → Blockverschiebung in 1900-Zeilen-Dokument birgt Korruptionsrisiko ohne inhaltlichen Gewinn; per Hygiene-Vermerk LED:423 auffindbar dokumentiert.

---

## (c) Paketmeldungen / Abnahmen / Commits

**Vor-Gate-Hygiene:** F6-Doppel-Etikett im Ledger disambiguiert (F6 07-16 = XML→CI-Interpreter-Strang ≠ „F6-Nachzieh" 07-17) — super `b57db0d`, beide Remotes.

**Bau-INC-1 (1a–1h) KOMPLETT** — ce `0bca27d3`→`f748a37f`, super `a1e4473`, beide Remotes ref-gleich; je Increment ce-standalone + super-Sub-Build `-j8`, cf22==0, Mojibake==0, golden-Roundtrip==320 durchgehend, ABI-4 unberuehrt:

| Inc | ce-SHA | Ergebnis |
|---|---|---|
| 1a | `0bca27d3` | `Axis<Derived>`-Dach + `AxisConcept` + `CebSystemAxis`; `test_striktheit_axis_dach_guard.cpp` (Bloecke A–I); literal „100% tests passed, 0 tests failed out of 2" |
| 1b | `30ad0364` | `build_system_axis_levels()`-Abspaltung; `build_all_axis_levels()` byte-identisch (br1_subset/br1_full22_count/br3_obs22); „0 tests failed out of 5" |
| 1c | `15a51760` | `SchedulingSystemAxis` #37, 5 Dimensionen static-constexpr, vtable bleibt deprecated daneben |
| 1d | (in `8fc77179`) | `ExtensionHardwareSystemAxis` (Q2-C): no_extension/avx2/avx512, `-march`-Flags **je Compiler getrennt**, `perm_extension_hardware_cflags()` Default=generisch=byte-identisch, `COMDARE_PILOT_SIMD_POLICY` als Smoke-Schalter + `HardwareIsaSystemAxis` |
| 1e | | Telemetrie-Mess-Schicht-Verankerung, Guard-Block G (Organ-Slot T10 unberuehrt → INC-2) |
| 1f | | `LoadFrameworkSystemAxis`/`YcsbLoadFrameworkAxis` (H-9); `workload`-Label jetzt Single-Source aus der Achse |
| 1g | | H-10: `build_version`+Sidecar tragen Provenienz — **literal bewiesen:** `m3v2+ext=no_extension+cxx=g++-16` |
| 1h | `f748a37f` | `CompilerSystemAxis` (gcc\|clang, Q3) + `-fno-gnu-unique`-Dialekt-Gate → haertester clang-Blocker weg; Guard-Block I |

**Planungs-Deliverables:** Parallelisierungs-Strategie-Dossier (7 Straenge, SYNC-0..3, Freigabe-Batches) super `43abbcc` · INC-2-Bauplan `docs/sessions/backups/20260717-inc2-planung/BAUPLAN-INC2-4NACH5-BUMP.md` + W3-Fork-Vorlage + ADDENDUM-Fold super `3b77eab` · Ledger-§20.B-Verbuchung super `d8ab0a2`.

**Thesis-Anhaenge B+E (Teammate `thesis-anhaenge-be`, G8-Abgabe-Blocker):** Repo `thesis/diplomarbeit`, Branch development, `8d156a5` → `61f2557` (Anhang B Code-Struktur DE 220/EN 212 Z. + Kartierungs-Plan) → `66cf85c` (Anhang E ADR-1..12 DE 188/EN 177 Z.). Literal: latexmk DE Exit 0 / 0 LaTeX-Warnings / PDF 736715 B; EN Exit 0 / 1 bekannte Baseline-Warning (`'h' float specifier changed to 'ht'`, S.44 Hauptteil, ≤ `COMDARE_THESIS_KNOWN_WARNINGS=1`) / PDF 708465 B; beide `.blg` ohne Repeated/Warning (alphadin.bst DE, alpha.bst EN); Mojibake==0; keine undefinierten Refs/Citations. ADR-12 = Q2 Option C. Nach D2 **gepusht** auf origin/gitlab (`8d156a5..66cf85c`); super-Gitlink nachgezogen super `0a2b0bf`.

**Bau-INC-2:**
- **2a ✅ ce `5ee005af`** (beide Remotes): `SearchAlgorithmDrive` + `acquire_search_algorithm_drive()` als EINE dock-vertragliche Antriebs-Beschaffung in `search_algorithm_dock.hpp`; Lazy-Iterator-Bypass (4 rohe `dynamic_cast`) auf Dock-Vertrag umgestellt (semantisch bewusst identisch; scharfer Gattungs-Reject kommt mit 2d/2e); Experiment-Planer-Dock an der Naht benannt (`experiment_run_entry.hpp`, Muster „Benennung, kein Neubau"). ABI-4-neutral, golden byte-identisch.
- **2b ✅ ce `86769bc9`, super `6fdfcf2`** — **ABI-Major 5 live**: `COMDARE_ANATOMY_ABI_MAJOR 4→5`, Magic `.A4.`→`.A5.` (`0x434F4D444141352EULL`); koordinierte Nachzuege = ABI-Guard-Test static_asserts, bewusste Spiegel-Kopie in `best_binary_selector.hpp`, **19 Neutralitaets-Guard-Pins** (0×`,4` / 19×`,5`); Alt-golden additiv als `golden_fullpilot_320_binary_ids_abi4.txt` eingefroren (md5-identisch, TABU-Original byte-unberuehrt); Loader-Ablehnung als **dauerhafte compile-time-Regression**; literal: ce-Voll-Build 0 errors, **Voll-ctest 273/273 auf ABI-5**, super gruen, `da_unit` 140/140, end-to-end ABI-5-DLL geladen mit 55 Messzeilen. POD-1416/kV3AxisSchema/binary_id in 2b bewusst unveraendert.
- **2c-Vorbereitung:** `2C-SCHNITT-INVENTAR.md` committet super `b6a8313`.
- **2c ✅ ce `5fe811db`, super `bca607d`** (beide Remotes) — F12iii Telemetrie 19→18. Literal: ce-standalone `build-conf` **272/273** (der eine = orthogonaler Layout-Check, dokumentiert) · super-Sub-Build `build-i2` **140/140** da_unit · cf22-22.1.8 **0** (126 Dateien) · Mojibake **0** · golden-Roundtrip 320. **POD/ABI-Checkpoint:** `kV3AxisCount` 19→18, Slot[10]=value_handle, sizeof **1416→1344**, `kTierObserverSnapshotVersionUnified` 5→6, ABI-Major bleibt 5. Neues golden: `telemetry=` **0** Segmente; alt-golden-abi4 unveraendert (md5 `953264d8`). Registry-XML auf 18 Achsen mit korrekter T-Nummerierung. **Adversarialer Konformitaets-Richter (3–4 Pruefer): COMMIT_OK** — keine blockierenden Abweichungen, keine „nur-gruen-gemacht"-Funde, alle 5 Gattungen Struct==Traits==Engine==Test konsistent, TABU unberuehrt. Drei nicht-blockierende Auflagen: (A) H-10-Sidecar-Aufrufer, (B) Doku-Sweep stale `[19]`, (C) F12III-Vorlage §2 auf [18). B+C im 2c-Commit erledigt; A als Folge-Task #27 (gated auf Messlauf).
- **INC-2c.opt-Dossiere:** falsches Erst-Dossier super `fabe10e` → Korrektur-Kopf + F1/F2/F3-Rulings verbatim in Ledger §20 + Memory super `1ce5e84` → korrigiertes Dossier super `973b761`.

Geaenderter Umfang 2c: 46 libs + 85 tests + 2 apps + 10 tools/xml. Commit granular mit explizit geaddeten Pfaden (nie `git add -A`).

---

## (d) Fehler + Fixes

| # | Fehler | Fix / Lehre |
|---|---|---|
| F1 | **Schein-Gruen INC-1g/1h**: fehlender Test-Include haette kurz Schein-Gruen erzeugt | gefangen, gefixt, echt-gruen verifiziert; als ehrliche Selbstkorrektur im Commit dokumentiert |
| F2 | **Schein-Gruen INC-2a**: DUAL-RC=0 war der Tail-Exit, nicht das Build-Ergebnis (ce „no work to do" rekompilierte die Edits nicht) | echte RC-Pruefung + frisch kompilierte Fassaden-TU; im Commit dokumentiert |
| F3 | **const-Handle INC-2a**: `acquire_search_algorithm_drive` nahm `const&`, `h.anatomy()` braucht non-const | Signatur auf non-const `AnatomyModuleHandle&` |
| F4 | **2b-Guard-Kaskade**: Major-Flip loeste ABI-Guard-static_asserts + 19 `EXPECT_EQ(ABI_MAJOR,4)` + Spiegel-Kopie aus | koordiniert auf 5 nachgezogen — **das war das designte Verhalten** des Buendel-Bumps, kein Defekt |
| F5 | **`COMDARE_E4_CAP=1` fehlte im SMOKE2-Re-Lauf** → haette weitere Zellen gebaut | 5-min-Timeout als Sicherung; entscheidende Zelle kam als erste dran |
| F6 | **Zombie-Prozess** (User: „laeuft es noch?"): mehrstufige Hintergrund-Kette SMOKE1→SMOKE2 liess einen Driver verwaist zuruecken | Kind **und Eltern-Shell** beendet (Kill-Code 144). **Lehre notiert: bei mehrstufigen Hintergrund-Ketten immer die Eltern-Shell beenden** |
| F7 | **2c-Kaskade b1–b38**: jeder Build enthuellte den naechsten 19-Slot-Anker (composition_factory-static_assert → adhoc_emitter → Generate → Emitter-CLI → ~20 Testdateien → genus_binding_traits kNames/Aritaeten → Gattungs-Modul-Emitter Set 15→14/Seq/View) | iterativ; Fehlerzahl konvergierte 63 (b4) → 7 (b7) → einzelne TUs → compile-gruen b34 |
| F8 | **ninja-Falle**: geloeschte Generate sind getrackte Inputs → Build bricht | `rm` + **Re-Configure-2-Pass** (Emitter-Tool erst bauen, dann Configure-Zeit-Regeneration) |
| F9 | **sed-Doppel-Index-Bug**: `acc[19]` blieb stehen — es war die **Array-Deklaration**, kein Index | von der Lueckenlos-Pruefung gefangen; Deklarationen separat gefixt |
| F10 | **Mehrzeilige `using`-Konstrukte**: sed entfernte nur die erste Zeile → verwaiste Fortsetzungszeilen | gezielt geprueft und nachgezogen |
| F11 | **GCC parst `!requires{...}` inline im static_assert falsch** | sauberes Helper-Concept definiert |
| F12 | **Row-Writer schrieb 19 seg-Spalten gegen 18er-Header** | auf Single-Source umgestellt |
| F13 | **Zwei Test-Stellen abgekuerzt statt umgewidmet** (echter Befund nach User-Direktive): (1) `test_v41_anatomy_observer.cpp::DrivenTelemetryOrganFlowsIntoAggregate` ersatzlos durch Kommentar ersetzt; (2) `test_d_v42_abi_telemetry_coupling.cpp` von hartem Positiv-Beweis (`axis_stats[10][0]==40`) auf schwachen `!=40`-Negativ-Check abgeschwaecht | beide **sauber umgewidmet**: (1) positiver F12iii-Guard (telemetry ist kein Aggregat-Slot mehr UND Organ-Infrastruktur lebt eigenstaendig; `ce`-Alias ergaenzt), (2) Schema-Positiv-Beweis (Slot[10] traegt value_handle-Semantik). Vollstaendige `git diff --numstat`-Bestandsaufnahme belegte: **keine einzige Produktions-Klasse entfernt**, alles uebrige reine Aritaets-/Index-Anpassung |
| F14 | **`test_all19_segment_timer` rot/flaky** | Median-of-7 eingebaut (**Varianzreduktion, keine Schwellenaenderung**) → tieferer Befund: realer Layout-Effekt im unoptimierten `build-conf` konsistent **~3%**, Schwelle 5% war fuer den **optimierten** Build kalibriert (>20% unter -O3). Vorbestehend (auf unveraendertem 2b-Stand ebenso rot), **nicht 2c-verursacht**. Schwelle NICHT aufgeweicht → Option A |
| F15 | **34 clang-format-Verletzungen** | cf22-22.1.8 in-place auf genau den geaenderten Dateien → 0; Post-Format-Build+ctest verifiziert |
| F16 | **TABU zwischenzeitlich angefasst** (bei den `permutation_axes.xml`-Konsumenten) | „TABU wiederhergestellt"; final belegt: `permutation_axes.xml` + golden-abi4 nicht im Diff, ABI-Major konstant 5 |
| F17 | **Architektonischer Fehltritt INC-2c.opt-F1** (substanziell, vom User geruegt): dedizierte Geschwister-Achse empfohlen UND die Compiler-Achse aktiv ausgeschlossen (Verwechslung mit der Compiler-5%); F3 als Fork „global vs. per-Auspraegung" gestellt, obwohl **„global" in einem dynamischen XML-System nicht existiert** | Fehler offen eingestanden (falsche Achsen-Ebene **und** falsches statisch/dynamisch-Modell); falsches Dossier `fabe10e` mit additivem **Korrektur-Kopf als Irrlaeufer entschaerft** (nie ueberschreiben); Rulings verbatim in Ledger §20; Architektur-Klaerung als Memory; Task #28 auf korrigierten Scope umgeschrieben; Neuplanung `wf_9d6e08dd` mit korrigiertem Bild + HW-Deep-Research |
| F18 | **Board-Notification-Artefakt**: Task #26 (STRANG-THESIS) wurde dem Teammate erneut zugewiesen, obwohl erledigt | kein Re-Work; Teammate bestaetigt und entlassen (Zyklusende-Direktive) |
| F19 | **Thesis-Repo hat keinen github-Remote** | github-Sicherung entfaellt dort mangels Remote; Anlage braeuchte eigenes je-Repo-GO — beim User angefragt, unbeantwortet |

**Stop-Hook-Dauerfeuer:** ~30 identische §0-GOAL-V6-Hook-Feedbacks. Der Agent hielt konsistent dagegen: entweder korrekt auf eine User-Entscheidung blockiert (die Goal-eigene Regel „Bau erst nach EXPLIZITER User-Freigabe je Phase" verbietet den Weiterbau) oder aktiv arbeitend (2c-Kaskade). Einmal explizit richtiggestellt: „GO INC-2 freigegeben wie empfohlen" deckt 2c (Ledger §20.B, super `0a2b0bf`). Ebenso zum Hook-Einwand „Ledger nicht aktuell": uncommittete Kaskaden-Zwischenstaende gehoeren nicht als Fakten ins Ledger — erst dual-gruen + Checkpoint, dann ce+super+Ledger in einem Zug.

---

## (e) Offene Faeden am Chunk-Ende

**BLOCKIEREND — 3 User-Entscheidungen zu INC-2c.opt vorgelegt (Z.1626-1634), unbeantwortet:**
- **OF-1 (tragend):** Zwei gleichdatierte Rulings kollidieren — (Q2-C) `extension_hardware` = eigenstaendige 6. System-Achse mit per-Compiler-march vs. (D6) HW-Erweiterungen als Unterachse **unter** compiler. Bleibt `extension_hardware` eigenstaendig (Planer permutiert `compiler × extension_hardware` als Kreuzprodukt) oder Fold-in? *Empfehlung: eigenstaendig + Kreuzprodukt (kein Bruch der gebauten 2b-Struktur).*
- **OF-2:** `-Ofast` in allen Mess-Permutationen oder nur im Vergleichs-/Debug-Raum, golden-Mess-Binaries auf IEEE-treues O2/O3 gepinnt? *Empfehlung: Ofast nur Vergleich/Debug (Determinismus der persistierten Reihen).*
- **OF-3:** Reicht der bestehende `cflags`-Kanal fuer „commands je Compiler verschieden", oder braucht es ein per-Compiler-Command-Template (Treiber-Invocation, Response-File-Strategie)? Autoritative Wert-Quelle unklar (V32-Command-Klassen sind gestoppt). *Empfehlung: mit flags ueber cflags starten, Command-Template als Folge-Increment.*

**Laufend/gerade gelandet:** Workflow `wf_f23421db` **Achsen-Nachschlagewerk** (5 Kartierer, System/Organ/Gattung/Mess/Registry-XML → Tabellen-Dossier) — Task-Notification `w0d59s06u` completed **exakt an der Chunk-Grenze (Z.1638-1644), Ergebnis noch nicht verarbeitet/abgelegt**. Relevant fuer OF-1.

**Geplante Bau-Sequenz INC-2c.opt-a..i** (nach OF-Rulings): Achsen-Header (`CompilerSystemAxis` + per-Compiler `do_opt_levels()/do_extra_flags()/do_command_template()` + `sub_axis_label()=="opt_level"`) → CompileFn-`opt_flag`-Parameter statt hartkodiertem `rf << "-O2\n"` (`build_orchestrator.hpp:476`; **Ersetzen, nicht Ergaenzen** — sonst Doppel-`-O`) → `perm_opt_level_cflags()` (Spiegel von `perm_extension_hardware_cflags()`, `profile_run_facade.cpp:116-130`) → INC-1h schliessen (`supports_fno_gnu_unique()` hat **0 Konsumenten**, Gate haengt an String-Check `cxx.find("clang")` :481) → XML-Schema (Blaupause `ThesisAxisSpec`, `xml_config_parser.hpp:100-115`) → Planer-Permutation → H-10-Sidecar `+opt=` in `system_axes_version_suffix()` (:172-174) → Verifikations-Tests unter -O3 in der Measured-foreach (`tests/unit/CMakeLists.txt:1709-1735`, heute ohne jedes `-O`; `build-conf` hat leeren BUILD_TYPE ⇒ effektiv `-O0`). MSVC-Symmetrie (`make_system_compile_fn` hat gar keinen Flag-Kanal) zurueckgestellt.

**Hauptstrang danach:** INC-2d (Set-Ebene-1 F1b) → 2e (Set-POD-V2 + SetDock F2) → 2f (#37-vtable-Ersatz) → 2g (Metadaten-Version AVX10 + Provenienz) → 2h → **Bau-INC-3** (autoritative golden-Materialisierung je Gattung, W3=A).

**Weiter offen:** `test_all19_segment_timer` rot committet (dokumentiert, wird durch Option A/-O3 gruen) · Task #27 H-10-Sidecar-Aufrufer (Konformitaets-Auflage A, gated auf Messlauf; `build_system_axis_levels()` hat **0 Aufrufer**) · Task #28 INC-2c.opt korrigierter Scope · **@SYNC-2 = Start-GO fuer den echten (mehrtaegigen) Messlauf, Deadline 28.07.2026** · F10-LaTeX-Rueckschrieb + Anhang A (braucht Messlauf) · measurement/`<YYYYMMDD-HHMMSS>`/-Rueckschrieb · **CI geparkt** bis Infra-Agent „CI zurueck" meldet, dann Batch-Nachzug · github-Remote fuers Thesis-Repo (braucht je-Repo-GO) · S-7 Tooling/Safety-geblockt · G5/#274 Projektende · CRC64/Abgabe-Finalisierung.

**Nicht-technische Lage:** User hat in D6 explizit Zweifel am Verstaendnis des aktiven Modells geaeussert und Fable 5 als Alternative angeboten; in der (redigierten) Folge-Nachricht **„Volles GO" — weitermachen, nicht warten**. Modell steht auf Opus 4.8 als Default, `.claude/settings.json` pinnt Fable 5 ab Restart.
