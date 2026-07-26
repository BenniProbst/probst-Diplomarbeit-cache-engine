# Chunk 19/30 — Chronologische Extraktion

## 0. Ausgangslage (Chunk-Beginn)
Endlos-Schleife aus Stop-Hook-Feedback (§0-GOAL-V6) und Assistant-„Holding". Assistant parkt korrekt am Entscheidungs-Checkpoint: Entscheidungsliste A1/A2/A3 (Rulings) + B1/B2/B3 (Build/Push-GO) + C1–C4 liegt beim User. Bereits gelandet vor Chunk-Start: 5 golden-neutrale Builds (INC-29.0 `428d639f`, opt-c `efd9060a`, D2 `122c1783`, D1 `f9c208e3`, D2-Log `70ae091c`), CI ce 10820 / super 10821/10825 grün.

---

## (a) User-Direktiven (wörtlich, wo bindend)

**D1 — Rulings A1/A2/A3 + B/C (wörtlich):**
> „A1: Bitte gehe dann für CEB auf default -O3 statt -O2 , das ist ja nicht dasselbe wie Ofast. Bezüglich der Tier-Binaries darf es fehlschlagen und muss von CEB gelogt und per Exception gefangen werden. Bitte ultracode lese den Plan nochmal, im ledger steht globales Festsetzen ist verboten, alle Teile sind beweglich -> du hast den falschen Ansatz. Wir wollen im besten Fall Option B wie empfohlen. A2: Bitte beschreibe mir die aktuelle Architektur, das riecht nach einem Verstoß, weil der Builder wie in (1) eigentlich das measurement durchführt, aber dabei nach unten greift, bitte ultracode für die Design Klärung, das sollte ein Hybrid aus (1) und (2) sein. A3: XML Liste, jedes Experiment hat dazu eigene Werte je spezifischer Tier-Binary die zu vergeleichen ist oder Ranges der Optimierung, die gegeneinander antreten sollen. B1: opt-f GO . B2: Volles GO. B3: Thesis push GO. Alles von C ist Freigegeben, GO"

**D2 — „Volles GO für alle Punkte"** (opt-f + opt-g + A2-Neben), unmittelbar danach vom User selbst gebremst:
> „Welche Entscheidungen habe ich gerade einfach durchgewunken, bitte erkläre mir zu den beiden Punkte erst den design Plan"

**D3 — BRUCH-FREIGABE (fundamentale Wende, wörtlich):**
> „opt-f ist freigegeben, weiterhin ist laut ledger auch die 320er zwar eine Grundlage aber überholt und darf mit allen Erweiterungen gebrochen werden, weil sich die Achsenstruktur und die Anzahl der Achsen vergrößert und geändert hat. opt-g: Nicht ganz präzise unter dem mehrstufigen System-Achsen vs Mess-Achsen build, bitte ultracode Planung.  Aber ja, wir bauen neu und brechen es für etwas neues besseres, additiv ist aufgehoben, bitte so sauber wie möglich nach Plan. Wir löschen die golden und die Messwerte und beginnen von vorn mit einer neuen golden Version. Bruch Freigabe. A2-Neben: Ja bitte, Freigabe"

**D4 — nach Systemabsturz:** „Bitte nenne mir offene Entscheidungen und fahre sonst fort, wir hatten einen System Absturz"

**D5 — E1–E5-Rulings (wörtlich):**
> „E1: Im prinzip richtig, aber Die Mess-Achsen und System-Achsne gehören beide in CEB und die System-Achsen steuern die gesamte Kompilation und Ausprägung der Mess-Achsen. Die Organ-Achsen sind alle direkt in den Tier-Binaries einkompiliert. Ich bestätige a,b,c wie empfohlen und wir nehmen das SIMD respektive in die System-Achse als Erweiterungs-Hardware mit rein, sofern es auf der ISA vorhanden ist, gibt es auch Organe, die SIMD anbieten dürfen also Organ-Achsen-Algorithmen kleiner gleich System-Achsen-Algorithmen Zulassung. E2: Freigabe wie empfohlen. E3: Sauber wie empfohlen, so sauber wie möglich. E4: Wie empfohlen beides durchziehen." + „Bitte baue los"

**D6 — Konformitäts-Rüge (wörtlich):**
> „Du vertauschst schon wieder Haupt und Unterachsen, dazu gibt eis eine workflow belegte Tabelle, bitte prüfe die Konformität der implementierung. Formal sind die Mess-Achsen auch System-Achsen, werden aber getrennt gehandelt. Du hast gerade alle Opt Typen als Unterachse deklariert, aber sie sind ja Optionen der Optimierungs-Unter-Achse"
> „Bitte ultracode code review gegen den führenden Plan zum Ist-Zustand. Ermittle das design diff"

**D7 — Sweep-Auftrag (wörtlich):**
> „Bitte Planungs workflows, damit die Konformität nicht daneben liegt. Bitte starte für JEDES einzelne Thema der letzten 3 Tage in der Abarbeitungskette einen EIGENEN Design workflow, um die Konformität gegen den Plan zu prüfen. Es schien ja doch einiges noch unklar zu sein"

**D8 — Große Architektur-Rulings + TODO (wörtlich):**
> „INC-1 bitte nachziehen, wie empfohlen gemeinsamer header für Mess-Achse, System-Achse und die Organ-Achsen, wobei die Organ-Achsen parallel noch die Gattungen definieren müssen, welche Gattung welche Organ-Achsen verwendet und benötigt. F-SIMD: Bitte zieh es nach Plan nach, die dort gegebene Empfehlung ist strikt per Design zu befolgen. OptO darf es ganz oben gar nicht geben, es gibt diese Hauptachse nicht, weder in den System-Achsen zur Freigabe der Existenz zu testender Hardware-Eigenschaften, noch in den Organ-Achsen zur Durchsetzung verfügbarer Hardware nach der Freigabe der Systemachsen. Bitte ergänze auch das Prinzip der Freigabe der System-Achsen an Ressourcen für die Organ-Achsen. Die Namensfalle bitte wie empfohlen auflösen. INC-2d: Bitte jetzt herauslösen, das ist definitiv eine eigene System-Achse. Wenn wir von einem x86 System die ISA ARM64 kompilieren, ist das faktisch ein cross compile, aber konfigurierbar in den System-Achsen und volkommen zulässig und ok. INC-0: alle malloc sind Allokatoren auf der Allokator-Organ-Achse. Sie haben auf den Systemachsen nichts zu suchen. Die anderen Flags allerdings gehören auf die Compiler Achse der System-Achsen, bitte klar trennen. Bitte direkt beheben unter deep research, GO. INC-29 bitte direkt auch nachziehen. Lege eine reiche TODO Liste an und ergänze auch die für mich sichtbaren Ziele. Bitte merke dir für jede Aufgabe eine ultracode design Planung durchzuführen."

**D9 — Memory-Backup:** „Bitte sichere die alte Memory in unseren sessions als backup, damit die gigantische task list nicht verloren geht, einfach bitte stumpf kopieren und dann weiter"

**D10 — „Volles Go auch für die übrigen Punkte"**

**D11 — AUTONOMIE-GRANT (stehende Direktive, wörtlich):**
> „Gut, Bitte merke dir, dass du VOR und NACH einer Aufgabe IMMER einen ultracode design Planungs- und Prüfungs workflow fährst. Wenn du das tust und die Planung als Quelle der Wahrheit betrachtest, wünsche ich ab Sofort die Weiterarbeit autonom ohne Rückfragen für ALLE noch offene Arbeit der Cache Engine und Diplomarbeit Code, aber nicht für den Diplomarbeit Haupt-Text, es sei denn es handelt sich um das Einfügen der Messwerte in Latex und die PDF Erstellung allgemein - diese Punkte liegen auch bei dir."

**D12 — nach 2. Absturz:** „Bitte fahre mit offener Arbeit fort, wir hatten einen System absturz"

---

## (b) Architektur-/Scope-Entscheidungen mit Begründung

1. **A1 / O3-Default beweglich (Option B)** — CEB-Default = **O3** (IEEE-754-deterministisch, wahrt 1-Thread-Mess-Determinismus; ≠ Ofast). Begründung: Ledger OF-2 verbietet globales Festsetzen, „JEDES TEIL ist beweglich". Der bisherige golden-sichere **O2-Pin war der falsche Ansatz**; zusätzlich war der eigentliche Verstoß der **O2-Byte-Anker** in `system_axes_version_suffix()` (nur Abweichungen von O2 bekamen `+opt=`-Sidecar) → Provenienz wird jetzt **immer** emittiert.

2. **A2-Hybrid-Ruling (Layering)** — Kriterium ist **nicht** „Leaf-Enum vs CRTP-Framework", sondern **eigene Fehler-KLASSIFIKATION (Builder zieht geteiltes Taxonomie-Vokabular hoch) vs Bau-KONFIGURATION (Builder empfängt sie als Wert von Facade/Planer)**. builder→measurement ist abwärts (n→n-1) legal. Teil (2): Facade rechnet `supports_fno_gnu_unique` aus dem Achsen-Typ und reicht ihn runter; Teil (1): Builder hebt `BuildResult` auf `std::expected`.

3. **Ist-Architektur-Befund (A2)** — 3 Schichten (Facade oben; builder + measurement als Peers). `build_orchestrator` ist **achsen-blind** (kein Verstoß). Reale Befunde: (i) `perm_runner` fehlplatziert in `builder/experiment_tree/`, (ii) Bau+Messung tief im builder verheiratet, (iii) **echter Verstoß = Verzeichnis-Zyklus builder↔measurement** über `pmc_source.hpp` (aufwärts inkludiert von `measurement/system_axis.hpp` + `i_measurement_source.hpp`) → „A2-Neben", ABI-nah (#156-Mess-Naht).

4. **System- vs Mess- vs Organ-Achsen (Code-Wahrheit, korrigiert E1)** — `AxisKind{organ, system_measurement, system_config}`. `binary_id` = **ausschließlich** Organ-Komposition (`serialize_composition_path` über `kCompositionAxisNames`, heute 18). `opt_level`/`simd` sind `system_config` → **vergrößern die golden-Fixture NICHT**, sondern multiplizieren die **Mess-Matrix** (CSV-Zeilen, unterschieden über Spalte `build_version`). Konsequenz: „golden + Messwerte löschen" schrumpfte real auf 2–3 überholte Mess-CSVs; Manifest wird höchstens regeneriert.

5. **E1–E5 entschieden** — E1 Organ-Fixture bleibt 320; E1b O2/O3 in die golden-Baseline (Ofast nie in die Determinismus-golden); E2 rm nur `tier150_measurements.csv` + `adapter_measurements.csv`; E3 A2-Neben **sauber** (Namespace `builder::`→`measurement::`, da Byte-Identität aufgehoben); E4 beide A2-Stufen; E5 `_abi4.txt` behalten/deprecaten. Ergänzung des Users: SIMD kommt als **Erweiterungs-Hardware-System-Achse** ISA-gegated mit rein (**Organ-Algorithmen ≤ System-Zulassung**).

6. **Achsen-Ebenen-Doktrin (V35 §2.1, autoritativ)** — **Haupt-Achse `compiler` → Unter-Achse `opt_level` → Optionen {O0…Ofast}**. Die C++-Achsen-Library war konform; verletzt hat es **die XML-Schicht** (flache `<opt_level value>`-Wiederholung, gedroppte `compiler`-Parent-Ebene, erfundene `<simd>`-Zwischenebene). Konforme Ziel-XML: `<compiler><opt_level><option value="O2"/></opt_level></compiler>` + `<extension_hardware>…`.

7. **F-SIMD** — zunächst autonom als „extension_hardware mit direkten Optionen" aufgelöst (Q2 Option C + Code-Ist); vom Sweep als **Widerspruch zur DESIGN-§5-Empfehlung (symmetrisch)** aufgedeckt; User rult **strikt symmetrisch nach Plan** → eigene `SimdSubAxis` (parent `extension_hardware`), Optionen no_extension/avx2/avx512, XML `<extension_hardware><simd><option>`.

8. **Freigabe-Prinzip (neu, als Memory verankert)** — System-Achsen geben HW-Ressourcen **frei** (Existenz zu testender Hardware-Eigenschaften), Organ-Achsen **setzen durch**; Organ-Nutzung ≤ System-Freigabe. Kein `OptO`/opt als Haupt-Achse. **malloc = Allokator-Organ-Achse; Compile-Flags = Compiler-System-Achse.**

9. **INC-2d** — `isa` wird eigene System-Achse (`hardware_isa`); Cross-Compile x86→ARM64 ausdrücklich zulässig/konfigurierbar. Einziges ABI/golden-Fenster der koordinierten Reihenfolge.

10. **Koordinierte Bau-Reihenfolge** (aus `wfq4ef0xs`): 1 INC-29 → 2 Namensfalle → 3 INC-1a Dach → 4 INC-1b/c → 5 F-SIMD → 6 INC-0 → 7 INC-2d (ABI-Fenster) → A2-Neben. Nur INC-2d berührt ABI/golden; alles andere golden==320 byte-identisch.

11. **INC-0-Trennungsplan (Deep Research)** — 4× `SNMALLOC_*`-Defs → Allokator-Organ-Achse (`vendor_compile_defs()`-Slot); `-mcx16` → System-Flag-Achse (`atomic128`/`cx16`, x86-64-gated); `COMDARE_*`-Mess/OS/Arch/Cacheline bleiben in `perm_mess_defines()`. **Zwingend:** beide relozierten Schichten am **globalen** Gate `COMDARE_AXIS_06_USE_SNMALLOC` (nie per-Tier), sonst `ds/aba.h:108 #error You must compile with -mcx16` für alle Nicht-snmalloc-Tiers. golden-neutral verifiziert (golden = `std_malloc` in 320/320, `build-go2` hat `HAVE_SNMALLOC=OFF`).

---

## (c) Paketmeldungen / Abnahmen / Commits (chronologisch)

| # | Increment | ce | super | Verifikation |
|---|---|---|---|---|
| 1 | **B3 Thesis-Push** | — | Submodul `super/thesis/diplomarbeit`, Gitlink `66cf85c` enthält `61f2557` | **No-op**: bereits auf `origin/development`, 0 unpushed; Task-Vermerk war veraltet |
| 2 | **opt-c-O3-Korrektur** | `504f8234` | `6a53cf3` | golden==320, test_striktheit (O3), ctest 241/241, cf22=0, Mojibake=0 |
| 3 | **opt-d** (fno-gnu-unique als Facade-Wert) | `cfe736d9` | `5e7904e` | opt-b-Guard byte-identisch, ctest 241/241 |
| 4 | **d1-carrier + d1-log** | `2a714a7d` | `8918093` | ctest 241/241; Ledger super `2152b51`; CI 10868/10869 Monitor `bpimri9o9` exit 0 |
| 5 | **opt-f** (XML-Liste) | `2c474c86` | `2b5bbb2` | Parser 16/16, golden==320, super-Sub clang #235 + fixture-sync; **CI hart-grün** (`bvhlnyldu`: `ce=success super=success`) |
| 6 | **opt-g + Konformitäts-Korrektur** | `43c3aa0c` | `69ac28a` | Parser 16/16, golden==320, super-Sub 3/3; **CI grün** (`bwb1hojbm`) |
| 7 | **INC-29-Kern** (InfraError-Domäne + isa_features FATAL→WARNING) | `5e47f009` | `84b7623` | axis_error 2/2, golden==320, super-Sub 1/1; **CI grün** (`bzoj5rdpp`) |
| 8 | **Namensfalle** `OptO*SubAxis`→`OptO*Option` | `538b0758` | `8c3d799` | Dach-Guard 1/1, golden==320 |
| 9 | **NACH-Nachbesserung** (Signal-Mapping + 3 Kommentare) | `e1ef61c3` | `b600575` | 0 stale `OptO*SubAxis`, golden==320 |
| 10 | **INC-1a-Gate** (`organ_axis.hpp` + T6) | `70baa826` | `bf58676` | Alloc-Tests „ALLE OK" (g++ **und** clang), Diamant-frei |
| 11 | **INC-1a Massen-Rehang** (20 Organ-StrategyBase) | `e6a77487` | `a8a63b1` | `test_v41_compositions` 25/25, codegen 1/1, known_compositions 4/4, cf22 21 Dateien |
| 12 | **INC-1a NACH-Fix** (isa→OrganAxis, 18/18 + Kommentare) | `4ed5a87c` | `78ab568` | Voll-Komposition 25/25, golden==320; CI `bd70cxetr` exit 0 |
| 13 | **INC-1b** `genus_organ_binding.hpp` + Test | `23a4d443` | `9563550` | „ALLE OK", drift-guard über alle 5 Gattungen, super-Sub clang |
| 14 | **F-SIMD Schritt 1** (`simd_sub_axis.hpp` + Block F.2) | `d9ad000b` | `d8300d7` | Dach-Guard 1/1, cf22 CLEAN |
| 15 | **F-SIMD Schritt 2–4** (XSD/golden/Parser/Consumer/DEPRECATED-Banner) | `d45afa6d` | `252b788` | ce-ctest **275/275**, super-Sub clang 5/5 inkl. `test_fixture_sync_experiment_golden`, golden==320 |
| 16 | **F-SIMD Feinspiegel** (MSVC-Dialekt, `options`→`simd_options`, Block-F-Marker) | `0947a64b` | `abb76bc` | ce 3/3, super-Sub 5/5; **NACH-Verdikt COMMIT_OK** |
| 17 | **Single-Source Validate** (#44-Teil: `kValidSimd`/`kValidOptLevels` aus den Achsen) | `bf6d414d` | `fff4856` | ce 2/2, super-Sub 3/3, golden==320 |
| — | **Memory-Backup** (141 Dateien, 704K, token-frei) | — | `1cb1046` | zusätzlich Sweep-Synthese persistiert |

**Persistierte Dossiers:** `docs/sessions/backups/20260718-a1a2-arch-klaerung/`, `…/20260718-optg-systemachsen-neue-golden/DESIGN-optg-a2neben-neue-golden.md`, `…/20260718-konformitaets-sweep-3-tage/SWEEP-SYNTHESE.md`, `…/20260718-design-planung-konformitaets-fixes/BAUPLAN-KOORDINIERTE-REIHENFOLGE.md`, `…/20260718-memory-snapshot/`. Ledger fortgeschrieben: **§21** (Bruch-Rulings + System-vs-Mess-Korrektur + E1–E5), **§21.D** (opt-g konform), **§21.E** (Sweep + Roadmap + INC-29-Kern).

**Reiche TODO-Liste #38–#48:** #38 INC-1 · #39 F-SIMD · #40 Namensfalle · #41 INC-2d · #42 INC-0 · #43 INC-29 · #44 Rest · #45 A2-Neben · #46 🎯 FF0–FF4 Mess-Lauf (gated) · #47 🎯 Thesis-PDF/#193/Anhänge/CRC64 (gated) · #48 MEMORY.md-Kompaktierung.

---

## (d) Fehler + Fixes

1. **O2-Pin-Fehlansatz** (User-Rüge) — golden-sicherer O2-Default verletzte OF-2 („nichts gepinnt"). Fix: benannte Single-Source `DefaultOptLevelSubAxis = OptO3SubAxis`, Facade sourct daraus, Fallback O3, O2-Byte-Anker in `system_axes_version_suffix()` entfernt (Provenienz `+opt=` immer).
2. **Stummer D1-Bau-Fehlerpfad** — `cache_engine_builder_iterator.hpp:749 if (!b.ok()) continue;` ohne Log/Klasse. Fix: klassifizierte stderr-Zeile + `BuildResult.outcome`. Zusatzbefund: per-Binary-Pfad war bereits exception-safe (Laden gibt Codes zurück, `perm_runner` fängt `catch(...)`), zusätzlicher try/catch wäre tot gewesen.
3. **`measurement::` löste im builder-Namespace nicht auf** → voller Pfad `::comdare::cache_engine::measurement::…`.
4. **Haupt/Unter-Achsen-Vertauschung in der XML** (User-Rüge, D6) — `<opt_level value>` je Option wiederholt + gedroppte `compiler`-Parent-Ebene + erfundene `<simd>`-Zwischenebene. Fix nach Review `woiuriqlw`: Container/Option-Struktur, `CompilerAxisSel{opt_levels}` / `ExtensionHardwareAxisSel{options}`, `<simd>` entfernt (später per F-SIMD-Ruling symmetrisch wieder eingezogen).
5. **golden `count==0` = CWD-Artefakt** (Roundtrip vom super-Root statt ce-Dir) + **cf22 false positive** (falscher Binary-Pfad durch Pipe); echter cf22 unter `usr/lib/llvm-22/bin/clang-format`, danach 112 Violations → formatiert, CLEAN.
6. **Sweep-Befunde (0/8 Themen vollständig konform, kein golden-320-Regress):** INC-0 Scope-Überschreitung (`COMDARE_FACADE_PERM_EXTRA_CFLAGS`/`-mcx16` aktiv injiziert, laut Plan „Nicht Teil von INC-0"); INC-1 Blut-Direktive (Organ-Familie nicht unterm Dach); 4× stale „19"-Doku; Provenienz-Sidecar unvollständig (`+tel=/+page=/+hw=` fehlen, Messlauf-Blocker). **2 KRITISCH:** Infra-Fehletikettierung im d1-Carrier; 7× `FATAL_ERROR` in `isa_features.cmake` (reißt die Pipeline) — beide behoben.
7. **🐛 OOM-Signal-Fehletikettierung** (NACH-Prüfung `wmwynqe21`, MITTEL-HOCH) — `decode_process_status` liefert `128+WTERMSIG` **positiv** (137=SIGKILL/OOM, 139, 134); Mapping prüfte nur `==127/==125/<0` → OOM-g++ landete als D1 `CompileKombination`; der `<0`-Zweig war für den echten Compile-Pfad tot. Fix: `else if (r.status < 0 || r.status >= 128)` → `InfraErrorClass::ProzessAbbruch`.
8. **🐛 isa-Dach-Lücke** (NACH-Prüfung `w5d3sohpd`, MITTEL) — `isa` (T11) ist heute noch echte Organ-Achse in `kCompositionAxisNames`, hing aber auf bare `AxisBase` → Dach nur 17/18. Fix: `isa`→`OrganAxis`. Zusätzlich 4 Kommentar-Overclaims in `organ_axis.hpp` präzisiert (EBO-Beweis folgt aus dem **unikalen** `Axis<D>`, nicht aus der `is_empty`-Tautologie; Guard deckt nur die Dach-Schicht; Mixin-Layers-Zitat gestrichen; keine golden-Erfolgsmarke im Header).
9. **INC-1b Test-Build** — falscher Include (`"builder/experiment_tree/genus_organ_binding.hpp"`, Root = `libs/cache_engine`) + gtest fehlt (foreach-Block nutzt Custom-Main-Stil `int main` + `[OK]`/`ALLE OK`).
10. **F-SIMD NACH-Befunde (3× GERING, alle nachgezogen)** — fehlender MSVC-Dialekt (`/arch:AVX2`, `/arch:AVX512`), Feldname `options`→`simd_options`, Block-F-Testkopf ohne DEPRECATED-Marker. Verworfen: `kValidSimd`-Hardcode (Bestand aus `2c474c86`, später als #44 geschlossen), Parser-Silent-Drop der alten Flachform (kein Live-Impact).
11. **sed/Pfad-Bugs** — Shell-CWD wird zurückgesetzt, volle `libs/cache_engine/`-Prefixe nötig; kein blindes sed (AxisBase steht auch in Concepts/Asserts) → erst Basis-Klausel-Kartierung.
12. **Zwei Systemabstürze** — jeweils Post-Crash-Integritätsprüfung; nach dem zweiten: ce `0947a64b` == origin, super `abb76bc` == origin, beide Arbeitsbäume sauber, kein Verlust.

---

## (e) Offene Fäden am Chunk-Ende

**Blockierend (einzige Rückfrage, Bau angehalten):**
- **INC-0-Fork: Wo ist `-mcx16` zuhause?** **A** = Compiler-System-Achse (neue `atomic128`-Unter-Achse; wörtliches User-Ruling „Flags→Compiler-Achse" + CMPXCHG16B ist **Baseline**-x86-64, keine optionale Erweiterung) — **Assistant-Empfehlung**; **B** = `extension_hardware` (symmetrisch zu simd, nur wegen `-m<feature>`-Syntax). Unter Autonomie selbst entschieden (falls kein Widerspruch): Achsen-Name `atomic128`, additiv-zuerst (CMake-Bake in zwei benannte Kanäle splitten statt sofort entfernen).

**Offene Tasks der koordinierten Reihenfolge:**
- **#42 INC-0** (VOR-Plan `wu13qwjfd` liegt, golden-neutral verifiziert; wartet auf A/B)
- **#41 INC-2d** — `isa` aus `kCompositionAxisNames` (18→17) → `hardware_isa`-System-Achse; **einziges ABI-Fenster (5→6)**, golden-Regen messdaten-erhaltend (Zahl bleibt 320)
- **#45 A2-Neben** — Stufe 1 `pmc_source`→`measurement/` + Namespace-Rename; Stufe 2 `perm_runner`→`harness/` (~10–16 Includer, #156-Mess-Naht)
- **#43 INC-29.3-Rest** — SampleStatus N/A-vs-Failed-Split (POD-nah); `NotApplicable`/`SourceUnavailable` haben repo-weit 0 Konsumenten
- **#44 Rest** — Provenienz-Sidecar `+tel=/+page=/+hw=` (**Messlauf-Blocker**), Stale-Doku-Sweep (4× „19", Major 4→5, Ofast-Notes im C-ÜBERSETZER-Bauplan)
- **INC-1c** — `freigabe_contract.hpp` scharf durchsetzen, sobald isa/simd System-Achsen sind
- **#48** MEMORY.md-Kompaktierung (22,4 KB; Backup liegt)
- Notierte Folgepunkte: `telemetry`/`simd_extension`/`general_hardware` unter ein **System**-Dach (nicht Organ); `page_type` bewusst „offen"/build-only (getrackter Nachschlagewerk-Widerspruch); vertagt near-TABU: symmetrische Library-Enhancements über das bereits Gebaute hinaus

**Gated 🎯-Ziele (Deadline 28.07.2026, CI UND standalone messfähig):**
- **#46** FF0–FF4 echter CI-verifizierter Mess-Lauf (honest-100%), Rückschrieb `measurement/<YYYYMMDD-HHMMSS>/` — Writeback derzeit INERT (`COMDARE_PERSIST_MEASUREMENTS` nicht gesetzt)
- **#47** Messwert-LaTeX + Thesis-PDF grün + #193 hand-bedienbar + Anhänge A/B/E + CRC64

**Stehende Prozess-Regeln am Chunk-Ende:** VOR+NACH-ultracode je Aufgabe (Planung = Quelle der Wahrheit); Autonomie für **allen Cache-Engine- und Diplomarbeit-CODE**, **nicht** für den Diplomarbeit-Haupttext — Ausnahme: Messwert-Einfügung in LaTeX + PDF-Erstellung liegen ebenfalls beim Assistant. Kadenz je Increment: ctest + golden-Roundtrip==320 + cf22-22.1.8==0 + Mojibake==0 + super-Sub-Build (Pflicht) + beide Remotes + CI hart-grün. Sicherheitsauflagen unverändert: Tokens nie ausgeben/committen (Vault nur einlesen, nie echoen), Cluster read-only, nur read-only GET gegen die GitLab-API, NIE rebase/IMMER merge (fetch+merge vor Push), Remote/Branch nur je-Repo-GO, Messdaten nie löschen (getrackte Mess-CSV vor `rm -rf build` prüfen), NIE AskUserQuestion, nie ✓ ohne wörtliche Tool-Ausgabe.