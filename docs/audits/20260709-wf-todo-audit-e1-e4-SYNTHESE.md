First-hand verification complete. All four load-bearing/contested claims confirmed against source. Key results: the #31 `mp_product` (workload_matrix.hpp:105) has exactly one consumer — the test — and self-documents its own error (`:10-11` "wie eine DynamicVariableNode-Wertmenge … KEINE Binary-Identitäts-Achse", `:19` "Workload ist Mess-INPUT"); the loader is genuinely NOT referenced in `Code/02_messung_driver` (grep rc=1); only `prefetch_distance` is read of 5 `applied_rc_` writers (abi_adapter.hpp:233-241, sole setter `set_runtime_distance`); and the AP-4 SOTA-series are XML-declared (m3v2_study.profile.xml:99-121) over genuinely distinct binaries (sota_catalog.hpp:150-179) — resolving the one inter-audit contradiction against the ledger-audit.

Here is the Chef-Auditor synthesis.

---

# CHEF-AUDITOR-VERDIKT — E1-E4-Ebenen-Prüfung der seit 28.06. als „erledigt" markierten TODOs

**Prüfbasis:** 6 read-only Audits (E4/E3/E2/E1 + Task-Board-5-Tage + Ledger-Historie) + 4 selbst nachverifizierte Kern-Belege (unten mit `[selbst verifiziert]` markiert). Alle übrigen Belege sind dem jeweils genannten Sub-Audit zugeschrieben.

## 0. Kern-Erkenntnis (die den User-Verdacht präzisiert statt bestätigt)

Der Pauschal-Verdacht „die TODO-Welle wurde mangels E1-E4-Wissen breitflächig schein-erledigt" ist durch den Code **widerlegt** — und durch etwas **Schlimmeres** ersetzt:

1. **Genau EIN aktiver Code-Fehlbau (#31).** Von allen strukturellen TODOs sitzt nur #31 nachweislich in der falschen E-Ebene. Das Team hat die tragende Disziplin (**Binary-Identitäts-Achse → compile-time E2** vs. **Mess-INPUT/DynamicVariableNode → E4-XML/E1-RC**) auch NACH dem Verlust der E-Labels intuitiv gehalten — außer bei Workloads/Datasets, exakt dem vom Dossier §13 vorab als mehrdeutig markierten Fall.
2. **Das eigentliche Loch ist die E4-Wurzel #229, nicht die Einzel-TODOs.** Unabhängig vom Status jedes einzelnen TODO gilt: die Experiment-DEFINITION lebt weiter in C++/CMake, nicht in XML. Die als „done" markierten E4-nahen Bausteine (#31-Matrix, #184-Loader, #25-Akten) sind **NICHT in eine XML-getriebene Laufzeit verdrahtet** — sie steuern kein Experiment.
3. **Kein E2/E1-Fix ist in den Abgabedaten.** Die Wirksamkeits-Schleuse #215 (320-DLL-Neubau) ist offen → alle E2-Code-Fixes (#188/#211/#213/#214/#216/#217) und die E1-Hälfte (#221) existieren nur im Quellcode. „E2 code-complete" ≠ „E2 wirksam".
4. **Der Korrektur-Plan wiederholt den Fehler.** F7-Doc-15 (Session 33, 08.07.) empfiehlt #31 erneut als „Option A = compile-time-Parametrisierung" und zementiert damit den Ebenen-Fehler in die measurement-all-Module — komplett ohne E1-E4-Linse.

---

## 1. GESAMT-VERDIKT (Zählung, ~32 auditierte TODOs)

| Bucket | Anzahl | TODOs |
|---|---|---|
| **ECHT ebenen-richtig erledigt** | **11** | #178, #223, #26, #27, #29-S1, #213, #214, #217-2a, #224, #49/#50, #211 |
| **ECHT — aber ebenen-mislabeled / wirkbereich-begrenzt** | **2** | #218/#219 (real+gehärtet, aber E1/E2 statt „E4"; deckt nur ce-internen `load_profiles/`-Pfad), Task-Board-#25-Akten (echte Provenienz, aber unverdrahtet) |
| **TEILWEISE (echter Code, aber unvollständig / daten-gated)** | **8** | #188, #221, #162/AP-4, #165, #184, #226, #216, #163 |
| **SCHEIN-erledigt (ebenen-falsch)** | **1 bestätigt** | **#31** (+ F7-Doc-15-Plan propagiert ihn, noch nicht gebaut) |
| **Korrekt-offen / ehrlich-HELD / deferred (KEIN Schein)** | **8** | #156, #152, #187, #215, #19, #185, #125, #225, §11-#25-Text |
| **Ebenen-orthogonal / mis-klassifiziert (echt, aber neutral)** | **1** | #39 (Modul-/Repo-Struktur) |

**Antwort auf die Leitfrage:** Von den als *done* behaupteten Items sind **13 echt ebenen-richtig** (2 davon mit Etikett-/Scope-Vorbehalt), **8 teilweise**, und **genau 1 schein-erledigt-ebenen-falsch (#31)**. Die Massen-Schein-Hypothese ist NICHT belegt. Die Gefahr liegt in (a) #31 + dessen Propagation via F7, (b) der strukturell unerreichten E4-Wurzel #229, (c) der offenen Wirksamkeits-Schleuse #215.

---

## 2. NACHARBEITS-LISTE (nach Schwere; das Wichtigste)

### TIER 1 — Wurzeln (blockieren den Messlauf)

**#221 — E1-Hard-Gate (RC-Laufzeit-Konsum)** `[selbst verifiziert]`
- **behauptet:** Ledger Z.165 „#221/AUDIT-A3-K1 DONE — RC prefetch_distance → realer T7".
- **wirklich:** Nur **1 von 5** RC-Achsen echt laufzeit-konsumiert. `abi_adapter.hpp:233-237` schreibt 5 Felder; `:240-241` liest AUSSCHLIESSLICH `applied_rc_.prefetch_distance` via `set_runtime_distance`; der EINZIGE Consume-Setter in ganz `libs/cache_engine` ist `set_runtime_distance` (grep: kein set_thread_count/pool_budget/batch_size/inline_threshold). Die 4 übrigen Felder sind write-only, `hw_prefetcher` ist kein POD-Feld. Kein Schein-Bau — E1-korrekt, literal getestet (`test_221_rc_prefetch_distance.cpp:120-130`) — nur unvollständig.
- **korrekte E-Ebene:** E1 (DynamicVariableNode / RuntimeVariableLoop). Richtig platziert.
- **was fehlt:** Konsum-Setter + apply1-Verdrahtung für thread_count/pool_budget/batch_size/inline_threshold; hw_prefetcher als POD-Feld bzw. MSR/SLURM-Launcher (Cluster-gated). **Bis dahin liefert jeder #156-Lauf, der eine dieser 4+1 Dimensionen variiert, PHANTOM-Zeilen** → das #156-Gate ist nur partiell gehoben.

**#188 — E2-Wurzel (search_organ_-Entfall)**
- **behauptet:** §17-Dossier-SOLL „container_ trägt echtes search_algo für ALLE Familien, search_organ_ ENTFÄLLT"; Board [in_progress].
- **wirklich:** Der Kernpunkt ist **echt vollzogen** — der parallele `search_organ_`-Spiegel ist als lebendes Member getilgt (abi_adapter.hpp:1981-2010, nur noch 1 historischer Kommentar :1432); ein einziger `container_algorithm_` (:828/:904/:949). ABER „für ALLE Familien" ist **nicht literal**: die 10 Pool-Organ-Familien sind `is_store_backed_=false` (:1970) und liefern auf den Store-Achsen (T4/T5/T7-descent/scan) bewusst honest-0.
- **korrekte E-Ebene:** E2. Richtig platziert; [in_progress]-Status ist ehrlich.
- **was fehlt:** (a) Design-Entscheid: honest-0-für-Pool-Familien final dokumentieren ODER Store-Backing ausweiten → [in_progress] schließen; (b) **#215-Wirksamkeit** (der Fix ist NICHT in den Abgabedaten).

### TIER 2 — Der bestätigte Fehlbau

**#31 — Workload×Dataset-Matrix (E4-Fehlbau)** `[selbst verifiziert]`
- **behauptet:** Ledger :373-374 „#31-Hybrid Schritt-1 KORREKT VOLLZOGEN … compile-time-Achse W der 2D-Mess-Matrix … 36 Zellen".
- **wirklich:** `workload_matrix.hpp:105` = `mp::mp_product<mp_list, ycsb_profile_list, dataset_list>` — 36 Zellen **compile-time in der ce-Bibliothek (E2)**. **Einziger Konsument = `test_31_workload_matrix.cpp`** (grep -rl bestätigt) — misst nichts, keine Tier-Binary, tote compile-time-Insel. Der Code widerspricht sich **selbst**: `:10-11` „Achse W … wie eine DynamicVariableNode-Wertmenge des experiment_tree, KEINE Binary-Identitäts-Achse"; `:19` „Workload ist Mess-INPUT". Der Autor benennt es E1/E4-förmig, materialisiert es aber E2.
- **korrekte E-Ebene:** E4 (XML — `config_b_cache_engine_perms.xml:17-20` hat Workloads bereits als XML; `m3v2_study.profile.xml:127-129` deklariert `<compile_dims><workloads>A B C D E F` — die korrekte XML-Heimat existiert also schon) bzw. E1 (RC-Wertmenge).
- **was fehlt:** Workload×Dataset-Auswahl aus `workload_matrix.hpp` entfernen → als XML-Experiment-Definition (E4) + DynamicVariableNode im Treiber verdrahten; die C++-mp_list als tote E2-Insel behandeln, NICHT als „vollzogen". **Zusätzlich: F7-Doc-15-Plan neu fassen** (er empfiehlt genau den Fehler erneut).

### TIER 3 — E4-Verdrahtungs-Lücken (das #229-Kernproblem)

**#229 — super-E4 XML-only (Wurzel)**
- **behauptet-Ziel:** „das Experiment IST die XML".
- **wirklich:** Zwei parallele XML-Welten. `messung_driver` konsumiert nur die alte `messreihen.xml` (id/mode/profile); Workload-Parameter hartkodiert (`main.cpp:124-149,476-483`). Die reiche V32-XSD wird von KEINEM Laufzeitpfad ausgewertet (`COMDARE_V32_ENABLE=OFF`, `v32_orchestrator.hpp:81-85` = Stub `return 0`). Auswertungs-Kette 03-06 = CMake-Literale (`Code/CMakeLists.txt:340-351`).
- **korrekte E-Ebene:** E4. **was fehlt:** V32-Orchestrator aktivieren; Workload-Parameter + Ausgabepfade aus C++/CMake in XML ziehen.

**#184 / Task-Board-#25 — Loader + Akten unverdrahtet** `[selbst verifiziert]`
- **behauptet:** „Loader-Verdrahtung DONE (test_184 4/4)"; „#25 VOLLZOGEN — 6er-Kanon-Datensatz-Akten".
- **wirklich:** `load_or_generate_ycsb` (dataset_loader.hpp:106-116) + Akten mit echten FNV-1a-Checksummen existieren und sind CI-verifiziert — aber der Loader ist im E4-Treiber **NICHT referenziert** (grep in `Code/02_messung_driver` → rc=1). Einziger Nicht-Doc-Aufrufer = der Unit-Test. Die Akten sind reine Provenienz, sie steuern kein Experiment.
- **korrekte E-Ebene:** E4. **was fehlt:** Loader + Akten so an den echten Mess-Treiber koppeln, dass die XML den Datensatz wählt.

### TIER 4 — Etikett-/Scope-Korrekturen (kein Fehlbau, aber Ebenen-Hygiene)

**#218/#219 — Resume-Härte:** echt+gehärtet (`cache_engine_builder_iterator.hpp:508-521`), aber als „E4" getaggt, liegt real in E1/E2; der Stamp deckt **nur** den ce-internen `load_profiles/`-Pfad, NICHT die super-`messreihen.xml`/hartkodierten Workloads (ungestempelt). **was fehlt:** Stamp-Härtung auf den super-E4-Pfad ausweiten oder das Rest-Risiko für #229 explizit dokumentieren.

**#162 / AP-4 — SOTA-Reihen A/B/C:** `[selbst verifiziert]` Modul-Seite echt und **ebenen-vertretbar** — die B-Module sind genuine distinkte Binaries (`sota_catalog.hpp:150-179`: `ArtPrtStufe3FullJoinComposition`, `HotPrt…` etc.), die Reihen sind XML-deklariert (`m3v2_study.profile.xml:99-121`). **was fehlt:** nur der E4-Voll-Messlauf (ehrlich HELD über #156). — Wichtig: das **Ledger-Historie-Audit stuft AP-4 fälschlich als „#31-Muster" ein; das ist durch den Code widerlegt** (distinkte Binaries = korrekt E2/E3; Reihen-Selektion = XML).

---

## 3. Das #31-Muster in ANDEREN TODOs

**Bestätigtes E4→E2-Muster (Mess-INPUT als compile-time in der ce-Lib):**
- **#31** — der einzige aktive Code-Fehlbau (inkl. Schritt-1b Dataset-Enum `CanonicalDataset`, `workload_matrix.hpp:94-101`).
- **F7-Doc-15-Plan** (Session 33) — noch nicht gebaut, aber empfiehlt „Option A = compile-time-Parametrisierung workloads/metrics/pmc" und würde den Fehler in die measurement-all-Module tragen. **Risiko-Träger: #39-Folgearbeit** (comdare-workloads compile-time-parametrisieren = #31-Schritt-2). #39 selbst ist noch sauber (nur Modul-Struktur, keine Workload-Auswahl gebacken).

**Widerlegtes „gleiches Muster" (vom Ledger-Audit vermutet, durch Code entkräftet):**
- **AP-4/#238** — keine Duplikation: distinkte Binaries (korrekt E2) + XML-deklarierte Reihen. `[selbst verifiziert]`

**Inverses Muster (E2/E1 korrekt gebaut, aber falsch E4-etikettiert — KEIN Fehlbau, nur Label):**
- **#218/#219** (E1/E2 als „E4" getaggt), sowie das Task-Board-Etikett **„#26/#27/#29 = GenusBindingTraits"**: laut E3-Audit sitzen **#27** (search_algo-Achsenwert, E2) und **#26-V-a** (Node-Shape-Emission, E2) real in E2, nicht in E3-Gattungs-Bindung — Implementierung korrekt, nur Board-Taxonomie ungenau.

**Fazit Muster:** Das #31-Syndrom ist **isoliert** (1 aktiver Fall + 1 Plan), NICHT systemisch. Die Disziplin „Binary-Identität → E2" hat gehalten.

---

## 4. VERLAUF — Wann ging das E1-E4-Wissen verloren?

| Datum | Ereignis | E-Nutzung |
|---|---|---|
| **28.06.** | ORIGIN — Dossier §12-§15 + SESSION-ENDE-9: alle ~47 TODOs [E0]-[E4]-getaggt, Top-Down-Audit E4→E1 | 39 / 18 |
| 29.06. | Letzte aktive Arbeit IM Rahmen (SE-12/13, E2 #188) | 4-6 |
| **01.07.** | Letzte explizite Direktive (SE-16 Z.83 „Top-down E4→E3→E2→E1, E0 last") — nur noch als Merksatz | 1 |
| **02.07.** ⚡ | **BRUCH 1** — Pivot „Fable-Manager-Modus"; SE-18/19/20 nutzen das E-Modell zu **0 %** | 0 |
| **03.07.** ⚡ | **BRUCH 2** — neues Single-Source-Ledger E-FREI geboren (SE-23); §10 degradiert E0-E4 zur „Audit-Dimension, NICHT Terminierung" | 0 |
| 05.07. | E-Tags nur noch im Board-Archiv als „historische Marker"; W5 rekonstruiert ein KONKURRIERENDES S1-S4-Modell und stellt fest „'4 Schichten' existiert nirgends" → Beweis, dass die 28.06.-Definition nicht mehr konsultiert wurde | Mechanik ja / Labels nein |
| **06.07.** | GOAL V3: „E-" umgewidmet zu „Entscheidungs-Defaults E-A..E-E" (Namens-Kollision) | 0 |
| **08.07.** ⚡ | **Manifestation** — F7 empfiehlt #31 als E2-compile-time; niemand flaggt die Ebenen-Verwechslung | 0 |
| 09.07. | Aktive Wiederentdeckung (dieser Audit) | — |

**Betroffene Welle:** alle DONE-Markierungen nach dem 03.07.-Bruch. ABER: das Task-Board-Audit hat 7 davon (#9, #16/#25, #26, #27, #29, #39, #49/#50) am Code geprüft und **alle ebenen-richtig** befunden. Der Schaden des Wissensverlusts ist auf **#31 (+ F7-Plan)** konzentriert — genau den mehrdeutigen Workload/Dataset-Fall. **§15 (SE-9) wurde nie fortgeschrieben, sondern fallengelassen** (Ledger §10-Degradierung).

---

## 5. KORREKTE REIHENFOLGE für die Nacharbeit (top-down, code-vor-Neubau-vor-Messung)

**Phase 0 — Linse wiederherstellen (Blutung stoppen):** E1-E4 als lebendes Tag-System reaktivieren; **#31 + F7-Doc-15-Plan mit der E4-Linse neu fassen, BEVOR measurement-all-Modul-Arbeit fortschreitet** (sonst zementiert Option A den Fehlbau).

**Phase 1 — E2-Code-Wurzeln (müssen VOR dem DLL-Neubau sitzen):**
- **#188** finalisieren (honest-0-Design fixieren oder Store-Backing ausweiten; [in_progress]→done).
- #211/#213/#214 in den Single-Source-Ledger nachtragen (Tracking-Lücke); stale `search_organ_`-Kommentare bereinigen (rollbackable_tier.hpp:10/14/33, set_anatomy.hpp:7, perm_runner.hpp:12).

**Phase 2 — E1-Laufzeit-Konsum (in die Binary kompiliert, also vor Neubau):**
- **#221** vervollständigen — 4/5 RC-Setter + apply1-Verdrahtung + hw_prefetcher-POD/MSR. (E1-Hard-Gate für #156.)

**Phase 3 — E3-Gate (nur Verifikation, bereits wirksam):**
- **#223** nach dem Recompile re-verifizieren (feuert transitiv via `perm_runner.hpp:163-164/245-246`; kein Neubau der Gate-Logik nötig).

**Phase 4 — E4-Definition (VOR dem Messlauf, damit der Lauf XML-getrieben ist):**
- **#31** korrigieren (Workload×Dataset → experiment_config/*.xml + DynamicVariableNode).
- **#184/#25** in den echten Treiber verdrahten.
- **#229** super-E4: V32-Orchestrator aktivieren, Workload-Parameter/Ausgabepfade aus C++/CMake in XML ziehen; #218-Stamp auf den super-Pfad ausweiten.

**Phase 5 — #215 Wirksamkeits-Schleuse (der 320-DLL-Neubau):**
- cowfix-v1-320-DLL-Neubau, damit ALLE E2/E1-Fixes in die Binaries/Abgabedaten landen. Mehrtägiges Pipeline-286-Experiment, korrekt HELD. **Muss NACH Phase 1/2 (Code) UND Phase 4 (XML) laufen.**

**Phase 6 — E4-Voll-Messläufe:**
- **#156/#162** (getrieben von der korrigierten XML aus Phase 4 über die neu-gebauten Binaries aus Phase 5); danach fallen die daten-gateten Residuen (#165/#226/#152/#187/#163-≥2-Plattform) an.

**Methodik-Warnung für Folge-Audits:** `grep -r --include=*.hpp` überspringt in diesem Baum stumm `perm_runner.hpp` — wer #223 nur mit Rekursiv-Grep prüft, zieht fälschlich „Gate fehlt" (der Ur-Irrtum B3-2). Einzeldatei-/Glob-Grep verwenden. (Meine eigenen Checks liefen mit expliziten Pfaden.)

**Wichtigste Datei-Anker:** `workload_matrix.hpp:10-11,19,105` · `abi_adapter.hpp:233-241,1970,1981-2010` · `sota_catalog.hpp:150-179` · `m3v2_study.profile.xml:99-121,127-129` · `dataset_loader.hpp:106-116` (Treiber-grep rc=1) · Bruch-Ledger `DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:132-134` · Origin `20260628-KONTEXT-DOSSIER…md:381-471`.