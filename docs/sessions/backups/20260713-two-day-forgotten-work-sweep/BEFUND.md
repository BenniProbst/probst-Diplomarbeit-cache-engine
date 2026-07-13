# BEFUND — Zwei-Tage-Rest-Arbeit-Sweep (2026-07-13)

Ausgangsraum: die sechs 07-11-Dossiers + die 07-12-Sweeps + die 07-11-Session-Review-Dokumente
(REV-CXX-*/REV-CI-*). Jeder Kandidat wurde durch drei adversariale Gates gefuehrt:

- **G1 — NICHT-GEBAUT**: Ist die Rest-Arbeit am Ist-Stand (Code/Git/Ledger) nachweislich noch nicht umgesetzt?
- **G2 — PLAN-KONFORM**: Beruehrt der Fix keinen benannten TABU (compile-time-Metaprog, ABI-4, POD-1416,
  golden-320, permutation_axes, GenusBindingTraits, Baseline-Layering, Doku-Loeschung) und keine
  Infra-/Cluster-Domaene (Impl-Agent = Cluster read-only, Infra = Handover)?
- **G3 — KEIN REVERT / NICHT GEPARKT**: Ist der Kandidat kein bewusst zurueckgebautes, geparktes oder
  daten-/GO-gesequenztes Item — und nicht bereits im 18-Task-Board (Goal-V4 G1-G8) getrackt?

Nur wer alle drei Gates besteht, wird als Rest-Aufgabe aufgenommen.

---

## 1. Summary

| Modalitaet | Wert |
|---|---|
| Untersuchte Quellstroeme | 6× 07-11-Dossier · 07-12-Sweeps · 07-11-Session-Review-Dokumente (REV-CXX/REV-CI) |
| Kandidaten insgesamt (Stichprobe belegt) | Dossier-Track: alle als GEBAUT/GATED/TABU/getrackt widerlegt · Review-Track: mehrere |
| **BESTAETIGT (alle 3 Gates)** | **4** |
| davon `major` | 2 (REV-CXX-01 UAF, V37.C/V38.C ungegatet) |
| davon `minor` | 2 (T16 FPR-Objective, REV-CI-04 Submodul-Praefix-Guard) |
| Prominente ABGELEHNTE (Stichprobe) | 9 — davon 2 mit entscheidendem **Gate-3=revertiert/geparkt**, Rest Gate-1/Gate-2 |

Kernbefund: Der gesamte **Dossier-Track** (grenzen-roadmap-slice1, axis-ontology-verify,
e4prime-cor-filter-chain, e4prime-messkurven-typsystem-wurzel, cmd2-container-attribution) hat
**kein** Item, das alle drei Gates ueberlebt — jeder Kandidat ist GEBAUT, GATED, TABU-gewollt oder
bereits getrackt (Details in §4). Die vier bestaetigten Rest-Aufgaben stammen ausschliesslich aus dem
**Session-Review-Track** (REV-CXX-01, V38.C-Gating, T16-FPR, REV-CI-04).

---

## 2. BESTAETIGTE Rest-Aufgaben (alle 3 Gates bestanden)

### B1 — prt-art LeafOnlyCounter reset/record Use-after-free (REV-CXX-01)  ·  `major`  ·  G-Stufe: G4-nah (prt-art Correctness, net-new)

- **Quelle**: `docs/sessions/20260711-SESSION-UEBERGABE-...-readonly-review.md:262-278` (REV-CXX-01,
  kritisch/P0); Code: prt-art `leaf_only_counter.hpp:93-99,137-139,143-159`.
- **Defekt**: `ensure_slot()` gibt eine bare Referenz `*(it->second)` zurueck, **nachdem** beide Locks
  (shared_lock/unique_lock) freigegeben sind (`:143-159`). `record_access()` ruft danach ungeschuetzt
  `slot.counter.fetch_add(1, relaxed)` (`:98-99`). `reset()` (`:137-139`) haelt den unique_lock und macht
  `counts_.clear()` → zerstoert die `unique_ptr<NodeAccessCount>`, auf die die Referenz zeigt. Laeuft
  `reset()` zwischen `ensure_slot`-Rueckgabe und `fetch_add` → **UAF/Heap-Abort**. Der #264-Fix
  (`8cb32fe`) behob nur den MAP-Mutations-Race (paralleles `emplace`), nicht die Slot-Lifetime.
- **G1 (nicht gebaut)**: prt-art HEAD `faa4e76` == Audit-SHA. Increment ohne gehaltenen Lock; Fix
  (Lock ueber Increment / stabile Slots / shared_ptr) NICHT vorhanden. Ledger:389 belegt: #264-Fix
  hielt bewusst „Zaehlen bleibt lock-frei atomar" — Slot-Lifetime blieb offen.
- **G2 (plan-konform)**: prt-art-Telemetrie-interner Concurrency-Fix; kein TABU-Verstoss
  (kein Metaprog/ABI-4/POD-1416/golden-320/permutation_axes/GenusBindingTraits/Baseline/Doku).
  shared_ptr-/stabile-Slots-Abhilfe erhaelt sogar das #264-Lock-frei-Design.
- **G3 (kein Revert)**: §12:805 fuehrt REV-CXX-01 als OFFENEN Review-TODO; Review-Doc §6.1 =
  „bestaetigter aktiver Concurrency-Defekt". Nicht auf Revert-/Park-Liste. Nicht auf dem 18-Task-Board:
  G4-prt-art-Majors sind `array_65535:21` + `search_engine:93` + `codegen.cmake:207` — UAF nicht darunter.
- **Task-Vorschlag**: Lookup+Increment in `record_access()` unter einem gehaltenen Lock zusammenfassen
  (oder Slots als stabil/nicht-loeschbar auslegen bzw. `shared_ptr<NodeAccessCount>`-Lifetime einziehen).
  Regressions-Test: paralleler `reset()` gegen `record_access()` (TSan/ASan).

### B2 — V37.C/V38.C Legacy-Plugin-Mikrobenchmark laeuft UNGEGATET im offiziellen Treiber  ·  `major`  ·  G-Stufe: G2-nah (Mess-Integritaet / „EIN XML-Programmweg", net-new)

- **Quelle**: `docs/sessions/20260711-SESSION-ENDE-produktions-ci-fix-golden-run-achsen.md:79`
  (§4.5 „P6-Rest: V38.B/C-Legacy-Microbench gaten"); Code: `Code/02_messung_driver/main.cpp:294-500`.
- **Defekt**: V37.C-Manifest-Iteration (`295-302`) + V38.C-Plugin-Mikrobench (`308-484`) laufen
  **unbedingt** am Kopf von `main()` und schreiben reale Binaer-Records nach
  `<out>/measurements/all_permutations.bin` (`:330`). Der `COMDARE_LEGACY_MESSREIHEN!='1'`-Guard steht
  erst bei `:595` — **nach** dem E4-Block (`525-589`) — und gatet nur die ExperimentDriver-3-Messreihen,
  nicht den Mikrobench. Verletzt „EIN offizieller XML-getriebener Programmweg" (paralleler Mess-Pfad).
- **G1 (nicht gebaut)**: awk-Scan `main.cpp` NR 293-485 = NULL Guards (kein
  COMDARE_LEGACY/getenv/env_trimmed/#ifdef). Ledger-grep V37.C/V38.C/LEGACY_MESSREIHEN = 0 Treffer →
  nicht als erledigt in §12 verbucht.
- **G2 (plan-konform)**: Gating eines Legacy-Parallel-Mess-Pfads bringt die „EIN XML-Programmweg"-
  Direktive voran; spiegelt das bestehende env-Guard-Muster (`:595`, Top-Level-Orchestrierung, kein
  gemessener Hot-Path). Beruehrt keinen der TABUs; loescht keine Doku.
- **G3 (kein Revert)**: Explizit unfertiges P6-Cleanup, vom Autor als „doable now" markiert — **distinkt**
  von der Voll-Entfernung, die data-gated ist (erst nach golden-320-Subsumtionsbestaetigung). Gating ≠
  Entfernung: der laufende golden-320 konsumiert `e4_xml/measurements.csv` (E4-Pfad), NICHT die
  `all_permutations.bin` des Mikrobenchs — Gating bricht keinen in-flight-Lauf. Nicht im 18-Task-Board
  (weder G2-Items sota_catalog/workload-id/cycles-fab/execute_engine/gitlab-ci-617/prt-art-phantom noch
  G4-Dead-Code/Doc-Drift/Muster C/D/F benennen das Legacy-Microbench-Gating).
- **Task-Vorschlag**: V37.C-Block (`295-302`) + V38.C-Block (`308-484`) hinter denselben
  `COMDARE_LEGACY_MESSREIHEN=1`-Guard legen wie `:595` (env-Muster wiederverwenden). **Nur Gating, keine
  Entfernung** (Voll-Removal bleibt bis golden-320-Subsumtion data-gated — siehe A6).

### B3 — T16 filter: gemessene FPR (Primaer-Objective bits/key @ FPR) nicht verdrahtet  ·  `minor`  ·  G-Stufe: G6-nah (Achsen-Coverage, net-new, nicht board-getrackt)

- **Quelle**: ce-Commit `895546f4` (2026-07-11): „Gemessene FPR ehrlich deferred (Treiber hat kein
  Negativ-Probe-Set → separater Increment)"; `docs/sessions/20260711-SESSION-ENDE-...:66` (T16 filter) +
  `:80` (§4.6).
- **Defekt**: Nur die constexpr-Space-Seite (`bits_per_key()`/`filter_bit_capacity()`) wurde in
  `895546f4` ergaenzt; die eigentliche **FPR-Seite** des Space@FPR-Trade-offs bleibt ungemessen.
  `fill_observer_v3` (`abi_adapter.hpp:1349-1364`) treibt den T16-Observer nur ueber low-Bytes der REAL
  gespeicherten (praesenten) Keys via `store_observe_filter` — kein ground-truth-absent Probe-Strom, also
  keine False-Positive-Zaehlung. `queries_negative` (`axis_stats[16][2]`) klassifiziert per Filter-
  Ergebnis auf PRAESENTEN Keys (potentielle False-Negatives), nicht FPR.
- **G1 (nicht gebaut)**: Die in `895546f4` ergaenzten constexpr-Funktionen werden nur im getrennten
  `composable/`-Subsystem + vendored `ext/`-SuRF-bench konsumiert; grep: KEINE Referenz in
  `abi_adapter`/`profile_facade` (Golden-Mess-Pfad). Commit-Msg + Ledger:600 + Session §3 sagen alle
  „FPR ehrlich deferred". (Korrektur zum Kandidatentext: `negative_query_pct` + `coco_p04_neg{0..100}.xml`
  + Absent-Key-Erzeugung EXISTIEREN, speisen aber den allgemeinen lookup/scan-Pfad, NICHT den Filter-
  Observer — G1 bleibt korrekt.)
- **G2 (plan-konform)**: Filter bleibt gepinnt bei 4 Werten (golden-320 unberuehrt), kein neuer
  Achsenwert/binary_id. FPR koennte — wie T2 im selben Commit mit `axis_stats[2][6]` — in einen
  reservierten POD-Slot bei stabilem `sizeof 1416`. Observer-Pass laeuft VOR dem Timing (keine
  Mess-Korruption). Compile-time-only/Baseline/Doku unberuehrt.
- **G3 (kein Revert)**: `git log -S measured_fpr / -S false_positive_rate --all` leer → nie gebaut,
  nie zurueckgebaut; explizit Vorwaerts-„separater Increment", als offene bestaetigte Luecke in Session
  §3/§4-#6 gelistet. Kontrastiert vom Autor gegen seine geparkten Commit-Geschwister (MP03/MP04 =
  TABU-geparkt/Gate-1-brechend; #221 thread_count = reverted) — FPR ist keins davon und nicht auf der
  PHANTOM-Liste (Container/Graph/Perzentile). Nicht im G3-Katalog (cuckoo:67 = False-Negatives, andere
  Sache), nicht in G6-Messlauf-Items.
- **Task-Vorschlag**: Ground-truth-absenten Probe-Strom in den Filter-Observer einziehen (getrennt vom
  praesenten Key-Strom), False-Positives zaehlen, FPR in reservierten POD-Slot (Muster wie T2
  `axis_stats[2][6]`) schreiben — `sizeof 1416` stabil halten, Observer-Pass vor Timing.
- **Hinweis (Nachvollziehbarkeit)**: Der Dossier-Track (§4) bewertet dieselbe FPR-Deferral als
  **Gate-3=geparkt (FAIL)**; der Session-Review-Track wertet sie als Vorwaerts-Increment (PASS). Die
  hier aufgenommene Fassung folgt dem autoritativen BESTAETIGT-Set. Divergenz bewusst dokumentiert.

### B4 — REV-CI-04: `verify:submodules` erzwingt keine Gitlink-Determinismus  ·  `minor`  ·  G-Stufe: G1-nah (CI-Haertung, net-new)

- **Quelle**: `docs/sessions/20260711-...readonly-review.md:612-624` (REV-CI-04) + Ledger §14:803-807.
- **Defekt**: `verify:submodules` (`.gitlab-ci.yml:195-198`) druckt nur `git submodule status` und macht
  `test -e/-d`-Datei-Checks — lehnt aber `+`/`-`/`U`-Praefixe (dirty/merge/conflict-Submodulzustaende)
  NICHT ab und asserted nicht HEAD==Gitlink. Zusammen mit `update=merge` (`.gitmodules:4-15`, alle 3
  Submodule) kann CI auf persistenten/wiederverwendeten baremetal-Worktrees einen lokalen Mergezustand
  statt des exakten Gitlink-Commits bauen (latentes Schein-Grün).
- **G1 (nicht gebaut)**: Der einzige andere `--recursive status` (`:304`, Manifest-Job) strippt Praefixe
  per awk fuer ein Provenance-Manifest und **failt nicht** darauf → kein Guard existiert.
- **G2 (plan-konform)**: Additive CI-Shell-Haertung; kein TABU; behaelt `update=merge` (wie die Abhilfe
  fordert); kein compile-time/Doku/Baseline-Impact.
- **G3 (kein Revert)**: REV-CI-04 = Status offen/mittel (bestaetigtes latentes Risiko), net-new, nicht in
  Revert-/Park-Set. Board: G1's geloeste CI-Infra-Arbeit ist der AUTH/FETCH-Fix (REV15/17 Deploy-Token-
  URLs = Submodule ueberhaupt bekommen); REV-CI-04 ist die distinkte ungeloeste Checkout-Determinismus-
  Frage; G4-Muster-F ist Test-Registrierung, nicht Submodul-Determinismus. Nicht getrackt.
- **Task-Vorschlag**: Nach dem Checkout `git submodule status --recursive` hart auf unerlaubte Praefixe
  (`+`/`-`/`U`) pruefen und bei Abweichung failen (HEAD==Gitlink erzwingen).

---

## 3. Prominente ABGELEHNTE (Stichprobe — Nachvollziehbarkeit)

### 3.1 Entscheidend durch Gate-3 abgelehnt (revertiert / bewusst geparkt / gesequenziert)

**A1 — ZeroingStrategy-Concept ohne deallocate-Vertrag (Voll-Review §2.5 medium1)** — **REJECT, G3 FAIL
(entscheidend)**. Der zero_allocate-Free-Path wurde am 2026-07-12 unter `wf_1009d16f` BEWUSST entschieden
(`git log e5946cdb` „wf_1009d16f AUFGELOEST"; dokumentiert in
`tests/unit/test_v41_topic_allocator_axis_06.cpp:226-239`): `zero_allocate` liefert einen calloc-Vertrag-
Zeiger, der via `std::free`/vendor-spezifisches free (z. B. `mi_free`) freigegeben wird — NICHT ueber den
aligned-alloc-`deallocate()`-Pfad. `axis_06_allocator_pool_resource.hpp:149-152` + `static_assert(!Zeroing
Strategy<...>)` (`:220-222`, „Pool-Speicher ist NICHT std::free-faehig") belegen die Free-Path-Trennung als
absichtliche Produktionsdoktrin. Der vorgeschlagene Fix („zero-Allokation ueber denselben deallocate-Pfad
routen") wuerde die entschiedene Sache UMKEHREN und Heap-Crossover REINTRODUZIEREN. Zusatz: G1 FAIL (Substanz
per-Vendor am 2026-07-12 gebaut) + bereits als **Muster-C Null-Consumer** auf dem G4-Board getrackt
(ZeroingStrategy hat NULL Produktions-Consumer).

**A6 — P6-Rest: Legacy-ExperimentDriver + V38.C-Mikrobench VOLL aus messung_driver entfernen** — **REJECT,
G3 FAIL (entscheidend)**. Die Voll-Entfernung ist zwar nicht gebaut (G1 confirmed: `main.cpp:304-484` +
`595/599-683` bestehen; nur `COMDARE_RUN_E4_XML`-Opt-in wurde in `c8ec3c2` getilgt), aber der Legacy-Pfad
wird BEWUSST bedingt behalten, **gated auf golden-320-Subsumtionsbestaetigung** — in-code dokumentiert
(`main.cpp:591-595`: „solange die E4-XML-Subsumtion der 3 Messreihen im golden-320-Voll-Lauf noch nicht
bestaetigt ist … danach entfaellt er ganz") und im Ledger (G6:93 golden-320 = daten-wartend #9916, PoC
laeuft mehrtaegig; G7:95 „V32-Tilgung nach E4-Subsumtion"). Vorbedingung NICHT erfuellt → Entfernung jetzt
zerstoert die bewusst gehaltene Subsumtions-Vergleichs-Faehigkeit. **Wichtig — Abgrenzung zu B2**: Das
*Gating* (B2) ist erlaubt und aufgenommen; die *Voll-Entfernung* (A6) ist golden-320-gated und abgelehnt.

**(Coverage-Track, Dossier axis-ontology-verify)** — **T8 thread_count Fix A (echter Threading-Konsum)** =
G3 FAIL (revert-geparkt): `abi_adapter.hpp:243-245` „#221-Rest, deferred … genau der bei #221 revertete
Mess-Defekt". **T16 fix(b) empirische FPR** im Dossier-Track = G3 FAIL „FPR ehrlich deferred" (Ledger:599) —
im Review-Track jedoch als B3 aufgenommen (Divergenz, siehe B3-Hinweis).

### 3.2 Durch Gate-1 abgelehnt (bereits gebaut / Substanz anderswo bewiesen)

- **A2 — CI-Build-Target-Name-Bug (REV-CI-01)**: **REFUTED at Gate-1 empirisch**. Behauptung, `cmake
  --build --target comdare-messung-driver` failt („unknown target", da OUTPUT_NAME ≠ Target), ist FALSCH:
  CMakes Ninja-Generator emittiert einen phony-Alias auch fuer den OUTPUT_NAME. Reproduziert (CMake 3.x /
  Ninja 1.13.1): `build comdare-messung-driver: phony …`, Build exit 0. YAML-Rename = No-op. (Zusatz:
  Zeilen sind repo-ROOT `.gitlab-ci.yml:212/431/507`, nicht `Code/.gitlab-ci.yml`.)
- **A3 — analyse:thesis-data baut MODULE-Libs statt CLI (REV-CI-02)**: **Gate-1 FAIL**. Die behauptete
  ungeprueften Substanz (CLI-main/argv-Pfad) ist zweimal anderswo im selben Pipeline-Lauf BEWIESEN:
  `build:clang` (HARD) baut `comdare_da_tools` → linkt alle *_cli (§12:391 EXIT 0); `integration:smoke`
  (HARD) baut die drei *_cli, asserted executable + faehrt sie E2E ueber argv. Redundante Haertung, keine
  fehlende geplante Arbeit.
- **A5 — #24-PLAN Anhang-Audit A-F nur fuer A ausgefuehrt**: **Gate-1 FAIL**. Der Audit ist vollstaendig
  in `docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md` §A.1 dokumentiert (6-Zeilen-
  Tabelle inkl. C/D/F: alle „bewusst handgepflegt, nicht messwert-getrieben, DE/EN in Sync"). Backup
  `docs/sessions/backups/20260711-ci-interactive-thesis-analysis/README.md` belegt die A-F-Analyse.
- **A4 — P1-Writer `write_working_set_sweep_curve` escape_latex-Doppel-Escape**: alle drei *technischen*
  Gates halten literal (G1/G2/G3 true), ABER **Board-Uniqueness FAIL**: Ausgabe ist an
  `working_set_n`-Daten gegatet (`diagram_generator.cpp:739/743`) — korrupte xlabel manifestiert nur im
  #156/Live-Daten-Regime; Ledger:610 „bei P1-Bau mitfixen" bindet den Fix an den P1-Bau, und Goal-V4 G6
  listet das P1-Item bereits → bekannte Sub-Facette eines getrackten G6/P1-Items, keine unabhaengige
  Rest-Arbeit.

### 3.3 Durch Gate-2 abgelehnt (TABU / Infra-Handover / bereits getrackt)

- **A7 — Tier-3-Behelfsweg-Loeschung `apps/adhoc_emitter/` + `apps/f15_compare/`**: **G2 & G3 FAIL**.
  `f15_compare` ist bereits im 18-Task-Board (G2 Mess-Integritaet, Ledger:85 nennt `f15_compare:454`
  explizit zum FIXEN — Kandidat will die Datei LOESCHEN, die G2 fixen will) UND aktiv gepflegte offizielle
  Mess-App (`9dc46659` 2026-07-04 Provenance-Manifest, 16-Spalten-CSV) → Loeschen revertiert Fortschritt.
  Zudem gatet die Quelle Tier-3 auf eine OFFENE Design-Entscheidung (never-guess).
- **A8 — REV-CI-03 Downstream-Trigger `branch: main` statt Gitlink-SHA**: **G2 FAIL**. Der harte
  SHA-Assert widerspricht der bindenden GitFlow-Doktrin (main = strikter Vorfahr von development) und der
  `.gitmodules`-development-Tracking-Topologie — wuerde im Normalbetrieb systematisch failen. Intent
  bereits durch G4-Muster-D (Super-Sub-Build am exakten Gitlink) abgedeckt. (G3 technisch true, rettet
  nicht.)
- **A9 — REV-CI-05 zentrales CI-Template `ref: development` (mutabel) statt SHA/Tag**: **G2 FAIL
  (Disqualifikator)**. Fix zielt auf/haengt vom Cluster-Repo `comdare/cluster/ci-templates` ab
  (unveraenderlicher Release-Tag/Release-Prozess) = **Infra-/Cluster-Domaene = Handover**, nicht Aufgabe
  des Impl-Agenten (Cluster nur lesend). Flaeche zudem bereits unter Board-G1 (INFRA-BLOCKIERT).

---

## 4. Coverage

**Ergebnis Dossier-Track: KEIN Item ueberlebt alle drei Gates.** Alle Rest-/Deferred-Kandidaten der sechs
07-11-Dossiers (+ 07-12-Sweeps) sind nachweislich GEBAUT, GATED, TABU-gewollt oder bereits GETRACKT:

- **grenzen-roadmap-slice1**: Einziger „jetzt-buildbar"-Slice = ASK-B SLICE 1 (best_binary_selector
  parse/rank Characterization-Test). **G1 FAIL** — bereits gebaut:
  `Code/external/comdare-cache-engine/tests/unit/test_best_binary_selector_parse_rank.cpp` existiert,
  registriert (`tests/unit/CMakeLists.txt:2771-2781`). DD-A `measurement_framework.hpp` als Null-Consumer
  verworfen (test-only fan-out, §I-Falle) → G2/G3 FAIL.
- **axis-ontology-verify**: 4 confirmed Luecken T8/T2/T16/T5 — alle am 2026-07-11 adressiert (Ledger:599,
  ce `895546f4`/`270c6c8c`/`fa9f31ac`/`b3224369`):
  - **T8 thread_count**: Fix B gebaut (`abi_adapter.hpp:250`, m3v2 thread_count→1 label-only) → G1 FAIL;
    Fix A (echter Threading-Konsum) = #221-revert-geparkt → G3 FAIL.
  - **T5 stride_pattern_tag (tot)**: ENTFERNT (Ledger:599) → G1 FAIL.
  - **T16 filter**: fix(a) `bits_per_key()`/`filter_bit_capacity()` constexpr an alle 4 Filter gebaut →
    G1 FAIL; fix(b) empirische FPR „ehrlich deferred" → G3 FAIL im Dossier-Track (im Review-Track als B3
    aufgenommen; POD-Feld zudem TABU-nah).
  - **T2 mapping**: Indirektionskosten-Objective gebaut (`MappingStatistics::total_indirection_steps` →
    `axis_stats[2][6]`) → G1 FAIL; MP03/MP04-Achsenwerte = GO-pflichtige Roadmap (mp_size 2→4 braeche
    Gate-1) → G2 FAIL (permutation_axes/golden-TABU).
- **e4prime-cor-filter-chain**: Slice 1 gebaut; DEFERRED-Handler PaperComparison (data-gated),
  Dominance/Pareto (braucht Messkurven-Typsystem, gated), ResourceBudget (Semantik doc-unklar) → alle
  G3 (gated/geparkt).
- **e4prime-messkurven-typsystem-wurzel**: §B-WURZEL GATED — Null-Consumer-Trap, wuerde
  axis_binding_registry-Revert wiederholen (data-gated #156) → G3 FAIL.
- **cmd2-container-attribution**: (Synthese im Ausgangsmaterial abgeschnitten; kein ueberlebender
  Kandidat aus diesem Dossier verzeichnet.)

**Ergebnis Session-Review-Track**: 4 bestaetigte Rest-Aufgaben (B1-B4, §2), keine davon board-getrackt.

**Abgelehnte-Stichprobe**: 9 dokumentiert (§3) — 2 mit entscheidendem Gate-3 (A1 ZeroingStrategy, A6 P6-
Voll-Removal), 4 Gate-1 (A2/A3/A4/A5), 3 Gate-2 (A7/A8/A9).

---

*Erstellt: 2026-07-13 · Basis: ausschliesslich die im Sweep uebergebenen Coverage-/BESTAETIGT-/
ABGELEHNT-Daten. Keine externen Annahmen.*
