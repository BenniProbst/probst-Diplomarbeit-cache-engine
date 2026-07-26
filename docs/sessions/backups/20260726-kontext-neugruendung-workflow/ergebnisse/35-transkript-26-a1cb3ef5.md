# CHUNK 26/30 — Extraktion (Diplomarbeit-Managersession)

**Zeitspanne:** 2026-07-20 ~21:50 → 2026-07-21 ~13:00 (2 Systemabstürze + 1 Kontext-Kompaktierung enthalten)
**Repos:** super = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` (Proj 288) · ce = `Code/external/comdare-cache-engine` (Proj 286) · Cluster (Infra-Agent)

---

## PHASE 1 (20.07. abends) — Reife-Check, Post-v3-Register, Full Join

### (b) Architektur-/Scope-Entscheidungen
- **Voll-2^17-Materialisierung NICHT jetzt** → 01.08.-Fenster. Begründung (Reife-Check `Plan-ReifeCheck`): real 524288 DLLs (4 Perms × 2^17), ~24 h / ~224 GB; Mess-Tooling-Fan-out (S6) noch nicht scharf → Binaries trügen Default-Instrumentierung → Bau-Doppelarbeit. Abgabe braucht nur den 320er (Faktor 1:1638). 24.07.-Bau-Fähigkeit gilt per gescoptem Fenster als erfüllt.
- **R1 (.so-Grenze):** die „bewusst verworfen"-Auskunft war **falsch** — sie ist DEFERRED und per §30 sogar Ziel-Design; deprecated ist nur das in-process-POD als *heutiger* Live-Draht. (a) Steuerung LOHNT (dlopen-Callback/ProgressDelta ermöglicht Mid-Run-Heuristik/Replan), (b) Daten LOHNT NICHT (CSV bleibt §58-Pflicht), (c) C++23-modules liefern **keine** ABI-Stabilität (die kommt aus extern-C+POD+Major-Gate, `anatomy_module_abi_v1`).
- **R2 (Driver-Split):** User-Hypothese halb richtig — Mess-Achsen bestimmen CEB-*Ausstattung*, Mess-Vollzug liegt in der CEB; „Unter-Klassen derselben Klasseninstanz" ist falsch (keine Vererbung) → richtiges Modell = §24-Haupt/Unter-**Delegation zweier ROLLEN** derselben Binary über das Planer-Dock. Konsequenz: Rollen-Naht physisch per Fork-A-.so trennen (konvergiert mit R1).
- **R3 (CLI):** Emission fertig, Bedienbarkeit fehlt (7 Gaps: kein `run <xml>`, kein `--status`, kein %/ETA/Resume, `--help` beschreibt Alt-Schema, ~16 Env-Vars ohne CLI-Äquivalent, kein lokales Stufe-1→2-Durchfahr-Kommando, keine JSON-Marker) → ~3–4 reine Treiber-Pakete.

### (a) User-Direktiven (wörtlich)
> „Ich stimme der Post-v3-Reihenfolge voll zu. GO"

> „Hast du das ledger und sessions auch weiter hin nach Post-v3 Tasks durchsucht? Wir hatten noch mehrere offen, neben den gefundenen"

> „Ja der Audit hat deprecated Features erhoben, aber nicht offiziell post Plan v3 geplante, bitte auch ein Audit dazu. Die post v3 Feautures, die ich niederschreiben lies können nur von heute den 20.07.2026 sein"

> „Korrekt, jetzt hast du es, bitte danach full join das wiederbelebte und ge-GOte deprecated mit dem offiziellen post Plan v3 mergen bitte. Dann hast du die Liste der TODOs nach dem Plan Strang, den du bitte weiterhin bis zu Ende ausführst. Dann machst du bitte autonom - auch bei nacht - direkt mit den post v3 Features weiter"

### (c) Abnahmen/Commits
- super `d7eaa0e` DEPRECATED-AUDIT-Session + Ledger §60
- super `04ef969` §60-Nachtrag (freigegebene Post-v3-Reihenfolge), Tasks #34–#37 verkettet
- super `8b612fc` POST-V3-REGISTER (G1–G7), Tasks #38–#43
- super `1aebbe0` Full Join: PV-Liste + KONTEXT-LOG-NACHTRAG U-12…U-18 + Task #44
- Audit `Audit-PostV3-Features` (read-only) Verdikt: Entwurf vollständig, **2 Korrekturen** — PV-7 (Anhänge B/E) nicht im heute-Record belegt (Provenienz-Lücke); PV-2 = beantwortete Analyse-Frage, kollabiert in PV-1. **PV-4 (Paper-Templates) = einziger echter Erfassungs-Gap** → Task #44.
- Full-Join-Reihenfolge: **#34 CLI → #35 .so-Schnitt (PV-1+PV-2) → #36 Resolver+CoR → #44 Paper-Templates → #38-Anteile K7b+K8/Storage (PV-5/6) → #37 F-SPREAD**; Alt-Backlog G1–G7 bleibt getrennter Merkposten.

---

## PHASE 2 (20./21.07. Nacht) — Systemabsturz 1+2, S5-Rest

### (d) Fehler + Fixes
1. **8h-Hänger `measure:smoke` (Pipeline 11840):** Storage-curl (measure-drop-PUT) **ohne Timeout** in `artifact_cache.hpp` (tries=12, kein `--max-time`) → blockierte Job UND `ceb-measurement-exclusive`. Gecancelt.
   **Fix (Impl-S5-Rest):** `curl_put()` :221-224 `--connect-timeout/--max-time` VOR `-K`; `from_env()` :94-102 Env-Gates `COMDARE_ARTEFAKT_{CONNECT_TIMEOUT_S=10,MAX_TIME_S=120,TRIES=12,RETRY_SLEEP_S=5}`; Helper `env_size_or()` :427-436. **Blackhole-Beweis literal: 6.01651 s = exakt 3×max-time 2 s.** Ehrliche Abweichung: die :294-Schleife ist `mc cp` (kein curl, kennt keine Timeout-Flags) → bewusst unangetastet.
2. **Grandchild-Mess-Jobs standen auf `manual`:** `COMDARE_MEASURE_PROFILE` fehlte in beiden Trigger-Allowlists.
   **Fix:** super `.gitlab-ci.yml` :1098-1100 `planer:delegate-trigger.variables`; ce `experiment_plan_director.hpp` `emit_ceb_trigger_job()` :636-639; Director-Assert im Test :650-654.
3. **Monitor-Verluste** durch 2 Prozess-Neustarts (Task-IDs `b737l57et`, `bqk4drktk`, `bsiqn2lyq`, `bc64pnm3l` verwaist).
4. **Staler r5g-Emitter** (`comdare_anatomy_perm_auto_*`, pre-INC-2d, 18 statt 17 Achsen, magic_mismatch) → test #113 `f15_compare_cli_smoke` rot. Erster Fix-Versuch nutzte falsches Target (`comdare-adhoc-emitter` statt `comdare_adhoc_emitter_cli`); korrekt: richtiges Target bauen → Reconfigure → 48 Module neu → grün. Build-Hygiene, kein Repo-Change.

### (c) Commits/Grün
- ce `cd206446` + super `43762ff` (S5-Rest) → CI **11866** (ce) + **11867** (super) beide success.
- Smoke-Re-Run **11871** getriggert; Grandchild **11881**; Propagations-Beweis live (`created`→`pending`, nicht `manual`), Gate-d-Beweis live (`waiting_for_resource`).

### (a) User (wörtlich, 2×)
> „Wir hatten einen Systemabsturz, bitte lies dich gründlich in den GESAMTEN Kontext ein und resume alle Agenten und Workflows. Bitte lies memory" · „Bitte stelle auch die gesamte sichtbare TODO Liste wieder her." (Board 36 Einträge, `[#N]`-Präfixe wiederhergestellt)

---

## PHASE 3 (21.07. früh) — S6-Plan + Rulings F-1…F-4

### (b) Plan-S6-Befunde + Manager-Rulings
- **Zentraler Befund:** `all_axes_golden.profile.xml:213-217` deklariert die 3 Combos {wallclock}/{macro}/{micro} **bereits**; Parser füllt `tp.measurement_tooling` (`xml_config_parser.cpp:401`). Passiv nur, weil Call-Site `experiment_plan_director.hpp:1076` das Feld nicht durchreicht → **Scharfschaltung = 2 Wiring-Zeilen** (:1076 Thesis, :1111 Experiment).
- Topologie exakt ×3: STUFE-1 CEB 3→9, tier:build 16→48, measure 4→12 = **23→69 Jobs**. Kollisionsfrei via A5-Selektor `--measurement-combo=<slug>` + `select_measurement_combo` (:1236).
- **golden ehrlich:** CRC `0xF1C1F26A1232073B` liegt über binary_id-STRINGS, nicht DLL-Bytes; Tooling ist binary_id-neutral; 320er-Byte-Wache = reine Organ-Kartesik → beides bricht nicht. Nur ~14 Topologie-Zähltests brechen.
- **Rulings (Manager, aus User-Direktiven abgeleitet):** F-1 **wallclock-first**, volle 3-Combo-Matrix als Ziel; F-2 **P1a+P1b** (U-8-② verlangt compile-time-Differenzierung); F-3 **m3v2-320** als Abgabe-Satz; F-4 **1 System-Perm O3/no_extension** (viertelt die Messdauer, 4-Perm-Beweis = 01.08.).
- Ehrlichkeit: keine belastbare Mess-Dauer-Referenz für die neue Kette → **potenziell mehrtägig**; Ankündigungspflicht erfüllt (Einspruchsfenster).

### (a) User
> „Freigabe zu allen Punkten. GO" → super `5cc4d38` (Ledger §60-S6-GO)

> „Wo steht der Messlauf und wo führst du ihn aus?" → Antwort: prod1 Bare-Metal-Runner `prod-baremetal-prod1` (Runner 16, Ryzen 9 9950X3D/Zen 5), CI-getrieben über 3-stufige Kette.

> „Gut, ist das ein gitlab CI run oder hast du es über den direkten lokalen Weg mit cmake und shell probiert? Ich hatte ja die Anforderung für beides gesetzt."

### (d) Ehrlich benannte Lücke
Das CMake-**Mess**-Target `comdare_tier_measure_perm<i>` ist seit S5-P2 scharf, aber **noch nie bare-metal über den cmake-Weg durchgefahren** → §15.10-B-DoD nur zur Hälfte cmake-bewiesen; Schließung zugesagt in S6-P2-Verifikation. **Bleibt am Chunk-Ende offen.**

---

## PHASE 4 (21.07. vormittags) — §61 (Dual-Weg / Debug-Parallel / Multi-Maschine)

### (a) User-Direktive (bindend, verbatim-Kern)
> „Gut, bitte schreibe als Pflicht Punkt fest, dass der duale Weg der Messung und ALLER Funktionen Pflicht ist und auf CI und lokal laufen muss. Diese Maschine hier hat 32 Threads und 24 Kerne. Per Definition hatten wir festgelegt, dass die Debug-Messläufe eine Parallelisierung erlauben, wenn wir nur testen wollen, DASS es funktioniert, hast du diesen Punkt beachtet und bist du im Debug Modus (wie geplant)…? Ansonsten gebe ich für Debug die maximale Parallelität von allen CPU Threads jeweils frei. … Messen derzeit prod1 (AMD) und prod2 (Intel) gleichzeitig in der CI? Wir kommen sonst nicht voran wenn wir das sequentiell machen, das bedeutet hier tagelanges Warten."

**Zwei ehrliche Nein-Antworten des Managers:** (1) Debug-Modus wurde **nicht** beachtet — der Smoke fuhr Release/1-Thread; (2) prod2 misst **gar nicht** mit (globale `resource_group`).

→ Ledger **§61** (super `1bb3cc7`) + Memory.

> „Gut, meine letzte Nachricht ist bereits vollständig verankert, finde die geplanten Stellen im Ledger und Planungsdokumente, starte dazu explore Agenten"

### (b) Explore-Ergebnisse (3 Agenten, read-only) → Anker-Karte (super `cb6a379`)
- **Dual-Weg:** geplant seit §15.10-B/F12i (LED:1344) → §40.c Bare-Metal-Pflicht (LED:2318) → §42 „CE emittiert BEIDE Wege" → §0-DoD5/#193 (MANUAL_RUN.md) → Isomorphie-Kernbild „EIN Director-Walk → CiYamlBuilder + CMakeGraphBuilder". §61 präzisiert von „messbar" auf **alle Funktionen**.
- **Debug-parallel:** Original §16.2-M1 (16.07., LED:1461 „so viele Messungen PARALLEL wie die Maschine Threads hat"), §32-F1/F7 (3 Modi kanonisch). §61 neu = konkrete 32T-Freigabe + smoke→debug-Bindung. **Wichtiger Fund:** `COMDARE_BUILD_PARALLEL` parallelisiert laut Treiber nur die *Kompilation* (main.cpp:816-821). Älterer CI-**Bau**-Deckel `CMAKE_BUILD_PARALLEL_LEVEL=6` (User 25.06.) bleibt unberührt.
- **Multi-Maschine:** §35/§36 + MATRIX-Doc planten nur den **BAU**; §38.b dekretierte für die MESSUNG ausdrücklich **globale** Exklusivität (LED:2296 „cluster-weit genau EINEN messenden Lauf"). **§61 ist die erste Stelle, die das auf pro-Maschine revidiert** → v3.2-Gate-d überholt. Runner-Inventar: prod1/id=16 = Zen5, **einziger AVX-512-Node**; prod2/id=17 = i9-14900KS Raptor-Lake-R, AVX2 (E-Cores fused-off).

### (a) §61-MODI — User-Volldefinition (autoritativ, wörtlich)
> „Es war schon immer ein Modus Debug (multi Maschine Lauf, Je Maschine parallel bauen+messen), Modus Messung (multi Maschine Lauf, Je Maschine parallel bauen und sequentiell messen) und Modus Release (System-Achsen korrekte Maschine lauf, Für diese Maschine parallel bauen + sequentiell messen -> Auslieferung der Tier-Binary und Heuristischen Hybrid-Tier-Binary ohne einkompilierte Mess-Einrichtung und ohne Overhead + Beweis der schnellsten Binaries über Release Product wallclock time Mess-Vergleich zusätzlich gegen Debug overhead Version (beste) und schlechteste Variante unter der XML Konfiguration). Der Release Modus ist das Ziel des Gesamtprojektes… Diese enthalten noch die Makro-Benchmark und Micro-Benchmark Mess-Observer… sie müssen also per Metaprogrammierung abschaltbar sein…"

→ **(d) Regression sofort gefunden:** `COMDARE_BUILD_PARALLEL=1` im Mess-Job = sequentieller **Bau** — laut Definition ist im Mess-Modus nur das **Messen** sequentiell. Ledger §61-MODI (super `d9c17ea`).

### (a) §61-STUFEN (wörtlich)
> „Die Modi Debug, Messung und Release bauen stufenweise aufeinander auf. Release benötigt die volle Messung (Replay möglich wie geplant)… jede Binary im GESAMTEN System braucht jeweils einen weiteren Stempel unter welcher compile Einstellung sie erzeugt wurde (default ist bei Modi Messung+Release im System ein Release cmake compile und bei Debug Modus ein cmake Debug compile). Diese Stufen sind für §61 Pflicht für die CI, bitte ergänze und konsolidiere erneut" → super `42d8758`

> „Ja, also wird Debug mit cmake compile Debug Modus und cmake compile Release Modus parallel kompiliert, aber nur mit den Binaries von cmake compile Debug getestet… Nur cmake compile Release wird in der echten Messung oder Release wiederverwendet. Außerden wird zu einem CI call oder XML Call in der XML definiert, welcher der 3 Modi gefahren werden soll (immer nur ein Modus zu einem call)" → super `25389ea`

> „Steht das jetzt auch alles konsolidiert im Ledger? Bitte prüfe die letzten ledger Absätze und korrigiere dort" → **§61-KONSOLIDIERUNG** (super `c9f3e14`), 4 Befunde: Z.3166-Halbsatz überholt (Methodik kommt aus dem **Profil**, nicht Env); (g)-Verifikation eingetragen (kein paralleler Mess-Loop); S6-GO-Ablaufzeile auf per-Host-Lesart präzisiert; **echter Widerspruch F-4 × Multi-Maschinen-Pflicht** (reine no_extension-Perm → alles auf prod1, prod2 idle) → vorläufige Auflösung (k) Combo-Lane.

---

## PHASE 5 — S6-P1-Implementierungsstrecke (Agent `Impl-S6-P1`)

### (c) Pakete, Abnahmen, Commits (chronologisch)
| Scheibe | Inhalt | Landung |
|---|---|---|
| P1b (a-c) + m3v2 | `render_adhoc_module_source` append-only `measurement_stamp` (Default "" = 2-arg byte-identisch, sonst 3-arg `_M`); m3v2_study 3 Combos additiv; 9/9 TABU-Tests grün, CRC unverändert | in ce `8de05298` |
| P1a | 2 Wiring-Zeilen + 16 Zähl-/Legenden-Anker ×3; **A5b/A8a → Trichotomie** (leerer Selektor=Identität / `_wallclock_`=1/3-Subset / Miss=leer) statt sinnleer gewordener Byte-Identität | ce `8de05298`, super `f1c1a6c` |
| P1b (d-f) | Env-Brücke `COMDARE_MEASUREMENT_COMBO` (guarded ab N>1, ci+cmake-symmetrisch), `measurement_stamp_line_from_combo_legend`, `make_lazy_adhoc_source_gen_from_env()` | idem |
| g/h/i/j1/j2 (+k) | (j2) Methodik **profil-getrieben statt Env** (statische Emission, kein Runtime-Branch); (j1) `validate_profile` **exactly-one** run_methodology (A9-„sweepbar" supersediert; all_axes_golden→measure, m3_smoke_coverage→debug); (i) Emissions-Signal `COMDARE_BUILD_TYPE="Debug"`; (h) `ceb-measure-<host>` + Host-Tags; §61-MODI-Fix `BUILD_PARALLEL 1→$(nproc)`; (k) `measure_host_lane(simd, combo)` | ce `a3dcfea3`, super `347df3b` |
| (i)-Facade | neuer Header `build_type_stamp.hpp` → `build_type_version_suffix()` an 3 build_version-Nahtstellen (`profile_run_entry.hpp:650`, `experiment_run_entry.hpp:293`, `profile_run_facade.cpp:355`); **verhindert, dass `dll_is_current` eine Debug-DLL als Release reused** | ce `beb9708a`, super `98e31f2` |
| platform-Tag | `export COMDARE_PLATFORM="<lane>@$(hostname)"`; literal 4× amd + 8× intel | ce `d778f8da` |
| 2a CPUID-Wache | `lane_vendor_guard.hpp` (Laufzeit-CPUID Leaf 0, GCC/Clang `<cpuid.h>` / MSVC `<intrin.h>`); Mismatch → **exit 7 vor der Messung**, literal belegt auf prod1 | super `78f003c` |
| 2b Debug-DLL-Pfad | `debug_flags_for_toolchain()` → `-O0 -g`; Substitution in der **Facade** (dort sind `opt_flag` und `-march` getrennt) → **ISA-Identität [d,e,f] bleibt erhalten**, `make_gpp_compile_fn` byte-identisch; E2E-Beweis: perm.rsp Debug vs Release unterscheiden sich in **genau Zeile 2** | ce `1f421214`, super `a348902` |
| 2c (j3)-Emission | Debug-Mess-Job = **2 Treiber-Aufrufe** (1: Release provision-only → `_release_provision`-Dir, Default-Stempel; 2: Debug-Bau+Messung `+bt=Debug`); ci+cmake symmetrisch; measure/Release **0 j3-Marker** (byte-stabil); `COMDARE_ARTEFAKT_TRIES=1` HART wegen Blocker #50 | ce `c09d309f`, super `938c4bc` |

**Verifikations-Kennzahlen (literal):** ctest 291/291 bzw. 280/280 (Nicht-measured); `test_experiment_plan_director` 40→41→42/42; CRC `0xF1C1F26A1232073B` durchgehend unverändert; cf22=0 mit dem autoritativen Binary; Mojibake 0.

### (d) Prozess-Fehler + eingeführte Regeln
- **Commit-Race:** `a3dcfea3` fing (k) unbemerkt mit ein (Agent landete es zwischen Verifikation und `git add`); die 3 cf22-Verstöße waren genau dieser Code. Manager-Meldung „6+6 Lanes" war dadurch **falsch** → real **amd=4 / intel=8**. Historie additiv per annotierendem Leer-Commit korrigiert (ce `b6c620f2`, super `3ad3f11`, **kein Rewrite**). → **Freeze-Regel**: Agent friert Working Tree nach jeder Paketmeldung ein; Manager prüft diff-stat literal vor jedem `add`. (Regel griff danach 3× korrekt.)
- **cf22-Slip:** Agent nutzte abweichendes Prüf-Binary → verbindlich `/home/comdare/tools/clang-format-22.1.8` durchgestellt.
- **platform-Variante (ii vs iii):** Manager-Auftrag (iii) stand auf **falscher Prämisse** — `compile_time_platform_tag()` liefert nur grob `linux-x86_64` (Zen5 ≠ RaptorLake nicht unterscheidbar), keine Runtime-Vendor-Detektion. **Kein Revert** von `d778f8da`; stattdessen CPUID-Wache oben drauf.
- **(j3)-Befund (materiell):** DLL-Bau war **build-typ-BLIND** (`make_gpp_compile_fn`: nur `-std=c++23 <O2/O3> -fPIC -shared -fno-gnu-unique`, kein `-g`/`-O0`/CMAKE_BUILD_TYPE) → „Debug-DLL" und „Release-DLL" wären byte-identisch gewesen. **Manager-Verdikt B** (autonom, aus User-Gesetzen ableitbar): echter Debug-Compile-Pfad; Variante A wäre „grün, aber nicht architekturkonform" = Schein-Umsetzung.
- **Agent-Interrupt** (10:39, 2× dupliziertes idle-Event) → Resume mit Leitplanke „erst Ist-Zustand erheben, auf bestehende Edits aufbauen statt verwerfen".

### (a) User dazu
> „Volles GO für deine Empfehlung. Freigabe. Muss aber für Windows 11, Windows Server, Linux ubuntu (und 7 weitere Linux OS typen), sowie mac OS x86+ARM1 passen" → super `15d08a6` (§62-G ④+⑤); Umsetzung als benannte Toolchain-Naht (g++/clang universal; MSVC `/Od /Zi` als dokumentierter Andockpunkt über die Compiler-System-Achse).

> „Hinweis: die binaries tragen den cmake compile Debug/Release Stempel, nicht einen Stempel der die Modi Debug/Messung/Release/Compare trägt. Ist das der Fall? Debug ist eine Namens-Dopplung aber ich will sie nicht auflösen…" → **Bestätigt mit Beleg**; schärfster Beweis = (j3): im Debug-**Modus** entstehen Binaries mit **beiden** Compile-Stempeln. Terminologie-Klarstellung in §62-C (super `06dc410`).

---

## PHASE 6 — §62: Planer-Universalität, Cache-Log-Claim, COMPARE

### (a) User-Klarstellung (tragend, wörtlich-Kern)
> „…wir sehen den Wald vor lauter Bäumen nicht, weil wir die Maschinen-Eigenschaften per CI runner vorfiltern, welche eigentlich keine Rolle spielen sollten, weil der Planer alles verfügbare misst, was in der XML verlangt wurde und er muss überall bauen können. Wenn wir in der XML Achsen verlangen, die physisch als System-Achsen Algorithmen nicht existieren (wie AVX512-Flags), dann schreibt der Planer Warnungen entweder ins log oder auch auf seine spätere CLI shell. … Bezüglich der Kompilation müssen sich aber die Maschinen auf der CI absprechen, welche Binaries es im cache auf minio.comdare.de schon gibt und welche Kombination sie Verantworten. Dazu sollten wir ein Compile-Log in den Cache lesen, das gelockt werden kann, wer zuerst zugreift, bestimmt den ersten Batch über eine lazy Auflistung der Permutation aller Achsen… Zu den drei Modi: Debug, Messung und Release laufen JE MASCHINE einzeln und erst zum Schluss nach dem Release gibt es je Maschine den noch weiter erweiterten COMPARE Modus… Alle drei Optionen sind nicht getrennt sondern vereinbar und Pflicht. Es gibt derzeit keine experiment_gold.xml die gilt, du musst sie per neuer Syntax von Grund auf neu entwickeln und stets pflegen. Bitte lösche alle alten Mess-csv. Remote branches nur löschen, wenn gemerged, sonst behalten. Welche Entscheidungen stehen nach dieser Klarstellung an?"

> „…jede Maschine, die lokal oder per CI baut und an den minio.comdare.de cache angeschlossen ist, [verhält] sich Teamfähig über eine sync Datei…, bereits gebaute Tier-Binaries, CEB oder Planer nicht erneut baut und… batches von zu bauenden Binaries reserviert und verspricht (also zwingend bei Beendigung des Programmes immer die Reservierung aufheben und Fortschritt klarstellen muss je build) und immer aus der eigenen Sicht handelt… Das bedeutet die CI ist erst fertig, wenn die XML auf allen von mir gewünschten Maschinen, je Maschine ausgewertet wurde exakt für diese eine Maschine."

> „Volles go nach deinen Empfehlungen für alle Punkte die du aufgeführt hattest. Die XML Syntax ist geplant und gebaut im Code, aber die vorhandenen experiment xml sind alt und behindern den Fortschritt gegen die neue vereinbarte Syntax und Semantik. Wir sollten sie überarbeiten und dann den Code von dem aktuellen Stand weiterentwickeln… Die Perspektive kann nur bei einer identischen (Hardware-technisch) Maschine gleich sein, welche dann ebenfalls befugt ist, die Messungen einer anderen Maschine als replay wiederzuverwenden. Die Binaries werden je nach Stempel grundsätzlich geteilt zwischen ALLEN Maschinen, sofern sie passen. Eine weitere statische Haupt-System-Achse sind die Arbeitsspeicher Frequenz und die CL38 (web recherche) Latenz neben der statischen Haupt-System-Achse des CPU Typs/exakte Hersteller-Fabrikation."

> „Hinweis: die Hardware Identität ist auch hergestellt wenn eine Maschine bis auf eine Meta-Meta-Achse (wie GPU, FPGA, NPU und so weiter) Identisch ist. Zählt allerdings die Erweiterung einer Meta-Meta-Achse zur kompilierten binary, muss diese Meta-Meta-Achse auf der assimilierenden Maschine ebenfalls unterstützt sein. … Ziel: Optimale Binaries für eine exakt maximal ausgeschöpfte Hardware Rekombination, um das Cache-Line Verhalten detailliert in allen permutativen Facetten zu untersuchen."

> „Der Laufzeit Hostname lässt uns aber nicht erkennen, ob 2 Maschinen dieselbe CPU haben, bitte recherchiere für AMD und intel möglichst generell auf multiplen OS verfügbare CPU erkennungs Software, die per binary verfügbar ist. Wir nehmen eine externe Abhängigkeit in Kauf"

> „Bitte konsolidiere alle meine Anmerkungen erneut in das Ledger Dokument durch Korrektur UND Erweiterung der eingetragenen Punkte. Es wird sonst unübersichtlich. Deine Tabelle eben ist richtig"

> „Hinweis: Weil es 130.000 Tier-Binaries geben wird, die zu verwalten sind, werden hierfür keine Einzel-Jobs angelegt, sondern die Kompilation der Tier-Binaries läuft unter einem gesammelten Job, der die CEB für den Build verwendet. Würden wir für 130.000 jobs je Pipeline die logs mitschneiden, würde das gitlab killen. Daher die build-Jobs für Grandchild Tier-Binary/Hybrid in einem batch, sowie auch die Messung über alle Tier-Binaries in einem Batch, das ich in EINEM Job log verfolgen kann."

### (b) Verankerte Architektur (Ledger §62, final konsolidiert A–H, super `3712088`)
- **A** Planer-Universalität — Runner-Tag-Vorfilter nur noch **Interim**; fehlende physische Achsen → Warnungen ins Log/CLI, kein Vorfilter.
- **B** Sync-Datei auf minio: 3-Stufen-Dedup (Planer/CEB/Tier), Batch-Claim mit **Release-Pflicht + Fortschritts-Testat**, Binary-Sync, eigene Sicht. Manager-Design-Note: **Lease-/Timeout-Semantik** nötig für den Absturzfall (tote Maschine blockiert sonst ihren Batch). **Symmetrie-Diktat** (super `6c2ffeb`): prod1 und prod2 bauen+messen **beide alles, was sie können**, XML identisch, Koordination ausschließlich über den Cache-Sync. **Batch-Job-Prinzip** (super `31aee25`): Job-Anzahl = O(konstant), nie O(Binaries); Sub-Lane = *Batch-Job je Maschine × Perm*, nie Job-per-Binary.
- **C** Modi je Maschine + **COMPARE als 4. Modus** (nach Release, vergleicht aus dem Mess-Replay die Sicht der gerade messenden Maschine) + CI-Fertigkeits-Gate (XML deklariert die Maschinen-Menge) + F-4-Auflösung + Terminologie (cmake-Compile-Typ ≠ Modus).
- **D** Replay-Befugnis **schichtweise** (User bestätigte die Tabelle wörtlich als richtig):
  | Artefakt | Replay-Befugnis durch | Sicht |
  |---|---|---|
  | CEB-Binary | Mess-Achse **[a,b,c]** | Planer |
  | Tier-Binary | System-Achsen **[d,e,f] allein** | CEB[d,e,f][g,h,i] |
  | Messwerte | **[d,e,f] und [g,h,i] gemeinsam** + Hardware-Kern-Identität | messende Maschine |
  Plus: Identität = **Äquivalenzklasse modulo ungenutzter Meta-Meta-Achsen**; einkompilierte Meta-Meta-Erweiterung wird zur harten Voraussetzung. **Binary-Sharing per Stempel** vs. **Replay per Hardware-Identität** = zwei getrennte Schlüssel.
- **E** Neue Haupt-System-Achsen ([#49]): RAM-Frequenz + CAS-Latenz (Formel `ns = CL × 2000 ÷ MT-Rate`; CL38@DDR5-7600 ≈ 10 ns) und CPU-Typ/Fabrikation. **Tool-Recherche (super `6f18264`):** primär **libcpuid/cpuid_tool** (Vendor, Brand, Family/Model/Stepping, Codename; Win/macOS-Binaries, Linux baubar), Fallback **google/cpu_features** (`--json`, Linux/Win/macOS/FreeBSD/Android, auch ARM/RISC-V); RAM-Seite `decode-dimms` (SPD, braucht ee1004/at24 + root) + `dmidecode -t memory` (Part-Number). Normalisierte Kern-Kennung = `(vendor, brand_string, family, model, stepping)`.
- **F** XML-Aufräum-Gate ([#48]) — **erst alle experiment-XMLs auf KERN-Syntax/§62-Semantik, dann Code weiterentwickeln**. **G** GOs + Bereinigungen. **H** Zielbild Cache-Line-Facetten.

### (c) Ausgeführte Bereinigungen
- **Alte Mess-CSVs gelöscht** (3 Dateien). **Bewusste Ausnahme:** `tier150_measurements.csv` ist aktiver Input des Heuristik-Kurven-Loaders (`measurement_curve_loader.hpp`) → Ersatz nach 320er-Daten ([#51]). Test-Fixtures behalten (Testdaten ≠ Messdaten).
- **Remote-Branches:** Regel „nur löschen wenn gemerged" verankert; Ist: super/ce/prt-art tragen remote nur `development`+`main` → nichts zu löschen. Thesis-Repo hat keinen prod1-Klon.
- O-1 (Löschung restlicher Mess-CSVs) **abgelehnt** (Messdaten-Doktrin); E13 Option 1 (Deprecation + Provenienz) im G5-Paket.
- Commits: `193770b` (§62), `28ef2cd` (Nachtrag Sync/Fertigkeits-Gate), `ec2407b` (GOs + Replay/Binary-Doppelschlüssel + [#49]), `385df84` (Meta-Meta-Äquivalenzklasse), `a52831b` (Replay-Schichttabelle), `3712088` (Konsolidierung A–H), `6f18264` (§62-E Tool-Recherche).

---

## PHASE 7 — Debug-Smoke, Blocker, §63-Autonomie

### (d) Fehler + Fixes
- **measure-drop.comdare.local (10.0.60.1) down:** jede CSV-Upload-Retry-Kette kostete ~6 min/Zelle (bounded-curl-Fix wirkte wie designt, kein 8h-Hänger mehr), hochgerechnet **>30 h reine Retry-Wartezeit** beim 320er → Blocker [#50], Handover Cluster `c8aa6f9`; Milderung `COMDARE_ARTEFAKT_TRIES=1` nur in Debug/Smoke-Pfaden.
  **Infra-Fix (Cluster `c2fdca1`):** nginx-Pod fuhr seit 13.07. **Stale-Config ohne TLS-Listener** (DNS ok, TCP/TLS tot) → Restart; **NFS-PV zeigte auf tote NAS-IP (.101)** → auf PR4100 (.241) neu gebunden. Manager-Eigenverifikation: Basis-URL HTTP 403 in 0,06 s, PUT-Pfad HTTP 401 → **[#50] geschlossen**.
- **Stale Pipelines 11871/11872** (User-Hinweis) → gecancelt.
- **Monitor-Defekte:** falsche Projekt-ID (286 statt 288 für Grandchild) → Fix; SHA-Suche matcht nur volle SHAs → Monitore wachen jetzt auf Pipeline-IDs; API-Fehler erst nach 3× in Folge melden; Selbst-Match-Artefakt der Monitor-Shell (`pgrep`) als Fehlalarm identifiziert.
- **Runner-Stau:** GitLab-Auto-Cancel räumte `a3dcfea3`-Welle ab (harmlos); 5 redundante super-Docs-Wellen gecancelt; 4 pending main-Trigger vom Account `***CRED-NAME-REF:comdare-admin-management***` (Infra-Agent) beobachtet.
- **Debug-Smoke 11979 FAILED** — drei Ursachen: (1) **Zombie-Messdriver** des morgens gecancelten Alt-Smokes lief seit 13,7 h bei 97 % CPU auf prod1 (GitLab-Cancel tötete nur den Shell-Wrapper) → **P11-Exklusivitäts-Wache brach korrekt ab**; Handover Cluster `5710981`, [#52]; (2) **unvollständiger Trigger** — nur `MEASURE_PROFILE=smoke` gesetzt, die dynamische Kette hängt an `COMDARE_BUILD_GOLDEN_N=true`; verifiziertes 11871-Rezept: `BUILD_GOLDEN_N=true` + `GN_TOTAL=4` + `MEASURE_PROFILE=smoke`; (3) alter statischer `measure:smoke`-Job feuerte ungegated mit → deprecated-gegated via `COMDARE_STATIC_SMOKE_FALLBACK` (Default aus, **nicht gelöscht**), super `65494f6`.
- **[#52] geschlossen** (Infra killte Zombie, Manager-Eigenverifikation `ps -C` leer).
- **User-Frage „hat der infra agent gerade den PAT rotiert?"** → **Nein**: gitlab-runner-Dienst auf prod1 wurde neu gestartet (Hauptprozess 21 s alt), prod2 folgte seriell; Runner-Auth hängt am Runner-Token, nicht am PAT. prod2 pollte um 12:07:23 wieder.

### (c) Debug-Smoke 11991 (erste Live-Ausführung des §61/§62-Interim-Regimes)
Getriggert auf `65494f6` mit vollem Variablensatz. Live-Belege: `planer:delegate` angelaufen; 3 CEB-Combo-Lanes parallel (`ceb:emit:[wallclock]`, `ceb:build:[micro]`); Heartbeats → 8 Pipelines, zuletzt **54 Jobs success**, tier:builds durch beide SIMD-Räume (no_extension ∥ avx2), **6 Messjobs `waiting_for_resource`** = per-Host-Gruppen arbeiten. Monitor `bo1y0pg05`. **Am Chunk-Ende noch laufend, kein Fehlschlag.**

### (a) §63 — Voll-Autonomie + Branch-Doktrin (wörtlich)
> „Du hast meine volle Freigabe, ALLE bekannten und die eben genannten Punkte, autonom - auch nachts durzuziehen, bis du nach dem Plan v3 und den vielen weiteren Paketen, keine offene Arbeit mehr, per Durchgeplante Punkte nach main branch und halb-geplante Punkte auf development branch, erkennen kannst, bitte merke dir das" → Ledger **§63** (super `1b6c41a`) + Memory. Operativ: nach jedem durchgeplanten, verifizierten, CI-grünen Paket **development→main mergen** (nie rebase, main ⊆ development).

### (a) §63-Nachtrag — Kurs-Umstellung (wörtlich)
> „Ich denke, dass wir das CI System und caching nach vorne ziehen und stets gut Warten sollten, damit die Pipeline schneller durchläuft, sonst machen wir in der Zeit zu wenig fortschritt. Vielleicht versuchen wir die emit Vertrags-Kette korrekt aufzubauen, nachdem die CI steht, dann können wir auch größere Implementierungen in gröberen Schritten direkt-Implementieren und dann gründ testen, anstatt riesige CI Ketten in the loop ohne Optimimierung zu probieren."

→ super `68e59e6`. Neue Reihenfolge: **[#46a] Minimal-Cache** (minio-Ablage + stempel-basierter Remote-Lookup → Bau-Skip; ohne Locks/Claims = #46b) **+ [#53] CI-Wartung** (docs-only-Wellen-Gate, Auto-Cancel-Hygiene, Chunk-/Queue-Tuning) **VOR** dem 320er; danach emit-Vertrags-Kette (koppelt an #35/#36). Arbeitsmodus: größere Implementierungen direkt + gründlich lokal (Dual-Weg) testen, CI = End-Gate, nicht Iterationsschleife. [#46a] blockiert jetzt [#16].

### (b) Ehrlicher Ist-Stand auf 2 User-Fragen
- **Adhoc-Job-Erstellung:** Kern **JA, live bewiesen** (Planer wird in der CI gebaut, interpretiert XML, emittiert Child; je CEB eine parallele Bau-Lane; jede Lane emittiert Grandchild mit Tier-Batches je Perm×Chunk). **Zwei Differenzen zum Zielbild:** (a) Tier-Batches laufen als parallele Gruppen **innerhalb eines** Grandchilds statt als eigene **Sub-Lane pro System-Perm** (ein Hop flacher) — als Pflicht-Designpunkt „war geplant" in [#46] festgeschrieben, damit es nicht als „funktional äquivalent" wegoptimiert wird; (b) Maschinen-Passung Interim-statisch statt Claim-basiert.
- **Cache-Skip:** **NEIN.** Heute skippt nur workspace-lokal (`dll_is_current` mit Sidecar/`.algos`, seit (i)/2b auch `+bt`-scharf). Cross-Pipeline-/Cross-Maschinen-Lookup existiert nicht (`artifact_cache`-Naht = No-Op, minio-Ablage unverdrahtet, 2c-Release-Provision job-lokal). Alle Schlüssel (Perm-Stempel, `+bt`, Tooling, künftig Merge-Kombination) sind fertig — [#46] muss Log, Lock, Transport bauen.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

**Laufend / unmittelbar:**
1. **Debug-Smoke 11991** läuft unter Voll-Monitor `bo1y0pg05` (8 Pipelines, 54 Jobs grün, Messjobs in Host-Lane-Warteschlange) — Ergebnis steht aus.
2. **Planungs-Workflow `wkvo08gj9` ist COMPLETED** (Dossier #46a Minimal-Cache + #53 CI-Durchsatz: Cache-Naht/Objekt-Key, CI-Inventar mit rules-Diffs, adversarialer TABU/Risiko-Check, Synthese) — **Ergebnis wurde im Chunk nicht mehr verarbeitet; das ist der nächste Handlungspunkt.**
3. `Impl-S6-P1` auf **Standby**, beide Repos clean: ce `c09d309f`, super zuletzt `31aee25` (nach `938c4bc`/`06dc410`/`65494f6`/`1b6c41a`/`68e59e6`).

**Kette nach Smoke-Grün:** #46a + #53 → **320er-Bau** (m3v2-320, 1 Perm, Interim-Lane-Emission per User-GO ①) → Messlauf (wallclock-first, prod1∥prod2, Hochrechnung nach Lane 1) → S7 (Hybrid, Wallclock-Beweis, Replay-Gate) → S8 (PDF DE+EN, **28.07.**) → #48 XML-Gate → Post-v3-Full-Join.

**Offene Tasks:** [#45] paralleler Mess-Loop UNGEBAUT (Debug misst heute 1-Thread — §16.2-M1-Feature, ehrlich ausgewiesen) · [#46a/#46b] Cache-Log/Claim (inkl. Lease-Semantik + Sub-Lane-Baumform-Pflicht) · [#47] COMPARE-Modus · [#48] XML-Aufräumung + golden-XML neu · [#49] System-Achsen RAM/CPU + libcpuid/cpu_features-Integration + Ist-Erhebung prod1/prod2 · [#51] tier150-Ersatz · [#53] CI-Wartung · [#34]–[#44] Post-v3 · Merkposten [#28],[#33],[#39]–[#43].

**Ungeschlossene technische Lücken:** CMake-**Mess**-Target `comdare_tier_measure_perm<i>` noch nie bare-metal durchgefahren (§15.10-B/§61-Dual-Beweis, zugesagt für S6-P2) · `emit_tier_build_job` (Stufe 1) provisioniert im Debug-Profil weiter Debug-DLLs (bewusster Scope-Entscheid, abgesegnet) · `_release_provision`-DLLs sind job-lokal bis [#46].

**Offen beim User (nicht dringend):** G7-Rest — E13 (#37-3-Achsen deprecaten), E15 (C2/GH200-§8-Zeile), E16 (Tilgungs-Tasks), #24/#25 (User-Textstellen). F27 und E14 wurden erledigt. F-4 A/B/C ist durch §62 supersediert (Option A = Code-Default).

**Beim Infra-Agenten:** [NAS-2] stale OPN-Backends/node7-Mount-Hygiene (+ Vault-Zeiger auf backup1/backup2-Credentials durchgereicht, Cluster `16c76e9` — **ohne Werte**) · [RUN-1] Runner-Cancel-Prozessgruppen-Hygiene (damit Zombies bei Cancel nicht wiederkehren) · PAT-Rotation #327.