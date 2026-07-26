# Extraktion tk_12.txt (Chunk 12/30) — Diplomarbeit-Managersession

**Chunk-Charakter:** Fast reiner Agent-/Manager-Zyklus (Goal-V4-Stop-Hook-getrieben). Nur **eine echte User-Nachricht**; alles andere sind task-notifications, Stop-Hook-Feedbacks und Manager-Text. Ein Kontext-Compaction-Block (Z.828–929) enthält die Historie der vorherigen User-Direktiven.

---

## (a) USER-DIREKTIVEN

### A1. Echte User-Nachricht (Z.1128) — WÖRTLICH
> „Bitte resume die Session wo du aufgehört hast. Bitte nenne mir den letzten "/goal" Text nochmal ganz genau"

### A2. Slash-Command (Z.1124-1127)
`/effort` → `Set effort level to ultracode (this session only): xhigh + dynamic workflow orchestration`

### A3. User-Abbruch (Z.1117-1120) — Handlung, nicht Text
Agent „#30 honest-0 Test-Reparatur + Registrierung" wurde **vom User gestoppt** (`status: killed`) mitten im Recompile, nach Edit von 4 Dateien, vor CMake-Registrierung.

### A4. Goal-Text (§0-GOAL-V4) — WÖRTLICH, bindend (Z.1136, vom Manager auf User-Anfrage exakt reproduziert; identisch mit dem Stop-Hook-Condition-Text Z.1004/1142/1685/1948/2045)
> „Arbeite die Diplomarbeit gemäß §0-GOAL-V4 im Ledger von vorn nach hinten ab — Stufen G1→G8 als Stack: jede Stufe erst sauber und vollständig abschließen, dann die nächste; jedes gefundene Problem kommt als Sub-Stack oben auf die laufende Stufe, bis behoben. Beachte Mission und FF0–FF4 und DoD 1–6 sowie die Striktheits-Direktiven: Metaprogrammierung compile-time-only im Hot-Path (kein Runtime-Switch/vtable; CRTP+Concepts; benannte Lehrbuch-Patterns), Modulreferenzierung/Baseline-Layering (WAS/WIE-Trennung ce=Framework/super=Definition), sauberster nie einfachster Weg, keine Behelfswege, TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/GenusBindingTraits/Registry-mp_list), Doku nie löschen (deprecaten), Messdaten nie löschen, Remote-Anlage/-Löschung nur je-Repo-GO. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind; lies vor jeder Stufe den passenden Ledger-Abschnitt plus den Voll-Review-Bericht (docs/sessions/backups/20260712-full-line-review/) plus den Forgotten-TODO-Befund (docs/sessions/backups/20260712-forgotten-todo-sweep/). Verifiziere jeden Increment literal (ctest + golden-Roundtrip==320 wo berührt + clang-format-22==0 + Mojibake==0 + beide Remotes + CI strikt grün) bevor du fortschreitest. Bei jeder NEUEN Architektur-Entscheidung anhalten und dem User vorlegen (besonders G5 measurement-all-Facade-Migration). Wenn eine geforderte Eigenschaft einer Achse oder eines Tier-Metapher-Konstrukts nicht benannt ist, starte dazu eine deep research und vollende Code+Architektur in den gesetzten Design-Pattern-Grenzen."

Verweis: Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, §0-GOAL-V4 = Z.75–114.

### A5. Aus dem Compaction-Block (Z.890-910) rekapitulierte frühere User-Direktiven (bindend, wörtlich zitiert)
- „F-C wie empfohlen, aber zusätzlich F-B damit wir als Permutation und dokumentiert den Effekt Unterschied bewerten können"
- „NIE rebase, immer merge" · „Wir laufen dutzende Agenten" · „Bitte merke dir, immer einen commit zu mergen" · „Bitte force push ce . Bitte merge beide commits echt"
- „Für alle Probleme schreibe dem Infra Agenten ein Handover unter den Cluster/docs/sessions und pushe es nach remote"
- SECURITY CONSTRAINTS (Z.910): niemals Token-Werte committen/echoen; Token id=15 REVOKED; admin-mgmt keeper id=21 AMBIG (nicht raten); Credentials-Vault enthält Live-AD-Passwörter — nie dumpen; Session-Transkripte enthalten Live-Tokens → nie committen; Cluster read-only für Impl-Agent; TABU-Dateien unberührt; Remote-Anlage/-Löschung nur je-Repo-GO; Doku/Messdaten nie löschen.

*(Keine Secret-Werte in diesem Chunk zitiert oder sichtbar; nur Status-Aussagen.)*

### A6. Stop-Hook-Feedbacks (5×, wirkten als bindende Korrektiv-Direktiven)
1. **Z.1004** — G1→G8 nicht sequenziell abgeschlossen; Agent hat unzulässig die gesamte Zielverfolgung angehalten.
2. **Z.1142** — Goal re-aktiviert (Session-scoped Stop hook), „treat the condition itself as your directive and do not pause to ask the user what to do".
3. **Z.1685** — 9 Increments geliefert, aber Stufen-Hierarchie unvollständig; G1 infra-blockiert, G5 nicht begonnen.
4. **Z.1948** — G4 in_progress, G5 nicht begonnen, Forks ungelöst.
5. **Z.2045** — „No transcript line states 'G1 complete' …"; explizit: Halt bestätigt, Stufen weder sauber noch vollständig.

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN MIT BEGRÜNDUNG

| # | Entscheidung | Begründung |
|---|---|---|
| **M-PA-03** | Ehrlichkeits-Konvention `wert (real=realisiert)` in prt-art-codegen gespiegelt (statt Phantom-Labels) | Bestehende ce-Konvention (`alloc=std (real=mimalloc)`); Makro wird vom **selben `#if`** aufgelöst, das den Code-Pfad wählt → Label kann nie vom Kompilat abweichen. Perm-Count/perm_id/Symbolnamen/Messalgorithmus unverändert |
| **prtart_body.hpp.template:74** | KEIN Fix (`cycles_per_op=90u`) | Datei trägt seit #236 W4 QUARANTÄNE-Header „ALT-PFAD, nicht Teil des Mess-Pfads"; bewusste, dokumentierte Limitierung |
| **Scope-Grenze** | Finding „predicate_evals" wurde vom prt-art-Agent als **Fehlzuordnung** erkannt (liegt in ce) und NICHT angefasst | „git diff nur prt-art"; ce = eigenes Submodul mit eigenen TABUs |
| **#20 V37.C/V38.C** | Nur **Gating** hinter `COMDARE_LEGACY_MESSREIHEN`, keine Entfernung | data-gated: golden-320-Subsumtion des Legacy-Pfads noch nicht bestätigt; Entfernung zerstörte Vergleichsfähigkeit |
| **#19 UAF** | Option A (Lock über Lookup **und** Increment) statt B/C | B (reset→Counter=0) bräche `tracked_leaves()==0`-Semantik + unbegrenztes Wachstum; C (shared_ptr) = Refcount-Ping-Pong, widerspricht Klassenzweck (Kühn LeafOnlyCounter) |
| **#8-Batch1** | Nur `axes/` editiert, `topics/` sind Re-Export-Shims | Authoritative Implementierungen liegen unter `axes/` |
| **Cuckoo** | Echte partial-key-Verdrängung (Fan CoNEXT 2014 §3) + LIFO-Rollback nach kMaxKicks=500 | Benanntes Lehrbuch-Verfahren; deterministisch; `insert_key` = Build-Op → mess-neutral |
| **HashLookup** | Knuth TAOCP Vol.3 §6.4 Algorithm R (Backward-Shift-Deletion), kein Tombstone | Passt zur `std::optional`-Belegung |
| **abi_adapter :588** | **KEIN Bug** — Loop-Index 0..255 bei kSlots=256 ist verlustfrei | Nur `:896` (Laufzeit-uint64-key) + symmetrisch `:961` geguardet; rein additiv → POD-1416/ABI-4 unberührt |
| **M-PA-02** | `total_hits/misses` → `std::atomic` (nicht nur shared_lock) | Sie werden in `lookup()` **unter shared_lock** inkrementiert = Reader-Reader-Race, den ein shared_lock nicht schließt |
| **M-PA-02 Iteratoren** | Kein Snapshot-Rückgabetyp, stattdessen **HANDLE-CONTRACT** im Header | Snapshot bräche std::vector-kompatible Signatur (Interface/ABI); by-value-Alternativen `at/front/back/lookup/range_scan` existieren |
| **#14/#29 Muster-D** | Alle `CMAKE_SOURCE/BINARY_DIR` → `PROJECT_*` in ce-Subdirs (205 Instanzen in 31 Dateien) | Standalone verhaltensgleich (`PROJECT_*==CMAKE_*`), Embed korrekt; `permutations.cmake:17`+`CMakeLists:576/577` **absichtlich NICHT** angefasst (super-CI-Vertrag liest Manifest aus `CMAKE_BINARY_DIR/generated`) |
| **#15 Test-Registrierung** | 4 stale-Erwartungs-Tests **nicht** registriert („rein-rot-registrieren würde gegen die korrekte honest-0-Doktrin behaupten") | Anti-Phantom-Doktrin; braucht thesis-abgestimmte Erwartungs-Reparatur → wurde #30 |
| **#25 rcu readers_** | **Reklassifiziert** von „trivialer Fix" zu **Architektur-Fork** | `current_thread_state()` nutzt EINE funktions-lokale `thread_local` über ALLE Domain-Instanzen; naiver RAII-Wächter fängt Zeiger auf die erste (Stack-)Domain → **neuer Shutdown-UAF** = Regression. Optionen: (a) per-(Domain,Thread)-State, (b) bidirektionaler Domain↔Token-Link, (c) Singleton-Bindung |
| **#13 CRC64** | **Kein** echtes CRC64 bauen | Es existiert kein Leser/Validator → wäre Phantom (Muster-A-Verstoß) + Blob-Format-Änderung. Stattdessen honest „reserved-0"-Doku (Layout sagte fälschlich „CRC64 4B", real 8B-Feld nie berechnet) |
| **#24 predicate_evals** | **GENUIN UNSPEZIFIZIERT → Eskalation**, nicht autonom entscheiden | Deep-Research: Architektur-Docs schweigen zu modelliert-vs-literal; Observer deklariert sich als „modelliert", Schwester-Observer (node_type, memory_layout #167 P-MD1-ERDUNG) zählen literal; honest-0 würde das Differenzierungs-Signal der Achse nullen = Semantik-Änderung |
| **#30 stale Tests** | **DESIGN-MANDATED-HONEST-0** → autonom konform (kein neuer Entscheid) | Belegt durch committetes Dossier `20260702-DOSSIER-4ci-dritter-weichen-branch-hull-authoritativ-fuer-codex.md:49-53/:98`: Organ-Hüllen → honest-0 via `store_backed=false`; Re-Kopplung ist deferred als #234. Die 4 *genannten* Kandidaten waren NICHT die stale-Tests |
| **#9 Doku-Drift** | Reklassifiziert: **Doku-Drift-Anteil (114) ist additive Korrektur, keine Löschung → autonom erlaubt**; nur Dead-Code/Cleanup (66+44) = je-GO | Direktive „Doku nie löschen, nur ergänzen/deprecaten" |
| **#9 Inc3 Attribution** | Als **byte-riskant reklassifiziert** und gegatet, dann entwarnt | `paper_id` ist ABI-exponiert + wird per Exakt-String-Match konsumiert (`PaperSignatureIndex`). Agent belegte: `binary_id` speist sich aus `W::name()`, nicht aus `family_name()`/`paper_id` → strukturell golden-neutral; `.xml <authors>/<venue>` werden vom Parser gar nicht gelesen |
| **B7 Kuehn** | Fehlattribution `LeafOnlyCounter (Kuehn DaMoN 2023 X1)` **entfernt** statt korrigiert | Datei-Selbstwiderspruch Z.16-17; keine belegbare Primärquelle |
| **M-CE-17 hdr_histogram** | Vendored `.c` **unangetastet**, nur comdare-Meta-Dateien ehrlich gemacht | Vendoring-Doktrin: Upstream-Bibliothekscode, nicht Hot-Path; `is_original`-Claim war sachlich falsch (comdare-Modifikationen: AVX2-Runtime-Dispatch, Prefetch/Likely-Makros) |
| **M-CE-18 latex_anhang** | **SUPERSEDED** statt Fix | Dead-Code, nie aufgerufen → je-GO-Deprecate statt tote Parser-Politur |
| **M-CE-21 snmalloc** | Fix **erweitert** über den Pfad hinaus (Flags + Adapter-Link) | Reiner Pfad-Fix hätte snmalloc aktiviert, das ohne `-mcx16 -DSNMALLOC_USE_WAIT_ON_ADDRESS=0` **nicht kompiliert**; Adapter `A07-snmalloc` linkte das Vendor-Target nicht → hätte Flags nicht geerbt. Single-source-Config hergestellt, `-mcx16` x86-gegatet |
| **Medium #6 (Stufe-03)** | Writer schreibt **v2-Layout** (statt Version-Stempel auf 1 zurückzunehmen) | Faithful zu `kBinaryVersion=2` + Stufe-02-v2-Format |
| **#16 Deprecation** | Deprecation-in-place ist **mandatiert autonom**, nur Datei-Löschung ist je-GO | §0-G4: „Doku nie löschen (deprecaten); jede Datei-Löschung = eigenes je-GO". Kein `[[deprecated]]`-Attribut (wegen -Werror) |
| **Lizenzen** | **Reklassifiziert von „user-GO" zu „autonom"** | Durch Lesen der **vendored LICENSE-Dateien** keine Raterei mehr, sondern Anti-Drift gegen die Primärquelle; für michael ist LGPL-Flaggung die compliance-*sichere* Richtung |
| **G5** | Das *Vorlegen* des Forks (Read-only-Analyse) ist die mandatierte **autonome** Vorarbeit; nur die Entscheidung ist User-Sache | Goal-Gate: „Umfang+Schnitt zuerst als Design-Fork VORLEGEN" |

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| Paket | ce | prt-art | super | Literale Verifikation |
|---|---|---|---|---|
| G2 #6 execute_engine + synth. CSVs | `f9c3dc08` | — | `bff06bf` | ctest 222/222, TABU 0, YAML valid, 0 synthetische prebackup-Kopien |
| G2 #7 prt-art `(real=)`-Labels + Container-Node-ID | — | `92fdd93` | `37a8c73` | ctest 211/211, Perm 16/81/108 unverändert |
| G2 #20 V37.C/V38.C-Gating | — | — | `e884063` | ohne env 0 V37.C / mit env `[V37.C] … 43 Eintraege` |
| G3 #19 LeafOnlyCounter-UAF | — | `86104aa` | `cec595b` | ctest 212/212; **ASan**: heap-use-after-free (buggy) → exit 0 (fixed); **TSan**: data race → clean |
| G3 #8-Batch1 (cuckoo/hash/scalloc/rcu) | `99c44104` | — | `9918041` | ctest 225/225, golden grün, Diskriminierungs-Tests RC=1 gegen Buggy-Code, ASan/TSan |
| G3 #8-Batch2 (cpuid/SIMDOps/abi_adapter) | `4859b168` | — | `0f0491d` | ctest 229/229, TABU-Guards `#167/#168/#217` Passed, POD-1416-Asserts Passed, Negativ-Kontrollen FAILED-dann-restauriert |
| array_65535 (M-PA-01) | — | `d4d1237` | — | ctest 213/213, `MaxDiscriminator65535InBounds` |
| G3 #26 prt-art Locking-Race | — | `b6d3f88` | `b0b06dd` | ctest 213/213; TSan buggy 3/3 race → fixed 5/5 clean |
| #27 super-Majors M-SU-02/03/04/06 | — | — | `69c905a` | xmllint rc=0, Stufe04+05 30/30, Builder-Target erkannt |
| #14+#28 Muster-D Kern (13 Stellen) | `b97e3a8` | `12ca441` | (Gitlink) | standalone ctest 229/229, embedded configure/build EXIT 0, byte_identity Passed |
| #15 Test-Registrierungs-Audit | `e4b69607` | — | `cf325ec` | **ctest -N 229 → 261**, alle 32 neuen grün |
| #22 verify:submodules-Guard | — | — | `3321bfa` | YAML valid, Guard fängt `+/-/U` |
| #32 lazy_try_resume_binary-Test | `06a7a57` | — | `971c76a` | ctest 262/262, 22 Checks, kein Bug gefunden |
| **#29 Muster-D breit** | `27f263c2` | — | `a6c4690` / `ccf76bd` | 31 Dateien, 205/205 1:1, 1237 Steps, ctest 257/258, byte_identity, `golden binary_count == 320` literal |
| **#30 honest-0 Reparatur** | `46093d50` | — | `794e92f` / `24eb452` | ctest 262/262, golden 320, byte_identity, clang-format-22 0 |
| **#9 Discovery-Backup** | — | — | `f529a66` | 3-Cluster-Erhebung + Triage persistiert |
| **#9 Inc1 Zähl-Drift** | `2dfb981b` | — | `0caac2c` | 8 Dateien, ctest 262/262 (Agent: 266/266) |
| **#9 Inc3 Reklassifizierung** | — | — | `f36050f` | Byte-Risiko-Befund gesichert |
| **#9 Inc2 Behelfsweg-Banner** | `e6d51674` | — | `250a45d` | 25+2 Dateien, 93+/1− (In-Place-Annotation), ctest 262/262 |
| **#9 Inc3 Attribution** | `c3e26aa5` | — | `f17ee07` / `59a6b95` | 23 Dateien, ctest 266/266, byte_identity smoke+medium, `golden binary_count == 320` |
| **#9 TIER 3 Provenance** | `ffc979b4` | — | `2195014` | 13 Stellen, ctest 266/266, Wort-Diff rein additiv |
| **#13 CRC64-Honesty** | `1026217b` | — | `d270f31` | clang-format 0, Mojibake 0, ctest 266/266 |
| **#33 (5 übersehene Majors)** | `2dc821d5` | — | `3df33ab` | ctest grün, golden 320, snmalloc-AN-Build: 3 Consumer-Tests grün |
| **2 Medium-Fixes (jemalloc + Stufe-03-v2)** | `614c0e4d` | — | `9147932` / `aa3de37` | Regenerierte Fixture valides v2 (`02 ee ff c0 \| 02 00 00 00`, 421 B), 5 Tests PASSED Round-Trip |
| **#16 Dead-Code-Deprecation** | `414ed8c2` | — | `64eccac` / `6fa66dd` | 7 Dateien, 49+/0−, ctest 265/265 |

**Merge-Disziplin durchgehend:** commit → fetch → merge `github/development` → push (kein Rebase, kein Force). Push-Beleg z.B. `06a7a57f..27f263c2 development -> development`.

**Abnahme-Modus des Managers:** „Delegiertes Ergebnis = Evidenz, nicht Urteil" — jeder Agent-Report wurde selbst nachverifiziert (Diff-Umfang, ctest, golden, byte_identity, clang-format, Mojibake, TABU-Grep) vor Commit.

**40-major-Gate #17 Terminalstand:** **35/40 FIXED, 4 GATED** (M-CE-07/#23-Fork ABI-4-TABU · M-TH-01/02 Overleaf · M-CE-02 Attribution-Recherche) **+ M-CE-18 SUPERSEDED/je-GO**.

---

## (d) FEHLER + FIXES

| Fehler | Fix |
|---|---|
| **Manager-Verifikationsfehler #20:** `--validate`- und plain-Lauf zeigten 0 V37.C auch MIT env → schien Agent-Beleg zu widerlegen | Ursache: **Frühexit an der Usage-/argv-Prüfung VOR dem V37.C-Block**. Offizielle Invocation `driver <config_dir> <output_dir>` + kurzer Timeout + Datei-Capture → beidseitig bestätigt |
| Falsches TABU-Grep-Muster `codegen.cmake$` matchte `anatomy_codegen.cmake` | Als Falschmatch verifiziert; TABU-Datei ist `tools/permutation_codegen/codegen.cmake` |
| TABU-Token-Treffer im #8-Batch2-Diff | War **Kontext-Zeile** (unverändert), keine hinzugefügte Zeile berührt TABU-Semantik |
| clang-format-Verstoß durch sed-Kommentar-Ausrichtung (array_65535) | `clang-format -i` + Boundary-Test `MaxDiscriminator65535InBounds` ergänzt |
| Manager-Label-Fehler: array_65535 als M-PA-02 bezeichnet | Korrigiert zu **M-PA-01**; M-PA-02 (Locking) separat getrackt |
| 2 Mojibake-Treffer im Ledger (Z.957/971) | **Alt-Bestand + legitim** — die Zeilen zitieren das Grep-Muster `'Ã\|â€'` selbst; neuer Eintrag Z.320 hat 0 |
| **#30-Agent vom User gekillt** mitten im Recompile | `git status` nach Fremd-Abbruch (Direktive); 4 editierte Dateien, keine CMakeLists-Registrierung → Manager nahm selbst auf |
| **#30 Mangel 1:** unvollständige #24-Neutralisierung — `Heap.predicate_evals != Clustered.predicate_evals` unterstellte weiter die modellierte Seite | Manager neutralisierte die Divergenz-Assertion selbst; `Clustered == 0` (Z.189) bleibt hart, weil **#24-neutral** (beide Doktrin-Seiten einig) |
| **#30 Mangel 2: Output-Fitting mit falscher Begründung** — Agent schrieb „Art/Hot mit realem Prefetch=10, Masstree=9", aber **alle drei nutzen `NonePrefetch`** | Manager traced die reale Per-Achsen-`row_sum`: Art T6 allocator=**63792**, Masstree T6=**0** → echter Grund ist der **allocator-Observer T6**. Kommentar korrigiert |
| **Workflow `wf_00995107-5b0` failed** — „subagent completed without calling StructuredOutput" | Agent hatte dennoch Edits hinterlassen (4 Tests registriert, CMakeLists-Kommentar auf RESOLVED); Journal leer → kein Salvage, Manager verifizierte selbst literal |
| 3 von 4 #30-Dateien mit clang-format-Verstößen (lange Zeilen aus Agent-Edits) | `clang-format -i`, Rebuild grün, 4 Tests weiter Passed |
| Wiederkehrendes „1 failed" im ctest | Jedes Mal das **EXCLUDE_FROM_ALL / Not-Run golden** (`test_profile_roundtrip`) → separat gebaut, literal `[OK] golden binary_count == 320 (4*4*5*4) = 320` |
| `[ERR]` beim golden-Direktlauf | Falsches Arbeitsverzeichnis (relativer golden-Pfad); ctest setzt WORKING_DIRECTORY korrekt |
| Workflow-Script-Backtick-Escaping (verschachtelte Backticks im Template-Literal) | Script ohne Backticks im Prompt-Text neu geschrieben |
| **Manager-Kardinalfehler:** „non-gated Vorrat erschöpft" war **voreilig** — geprüft gegen die **Board-#-Liste** statt der **M-CE-#-Review-Liste** | Rollup-Audit #17 deckte **6 nie adressierte Majors** auf (M-CE-15/17/18/20/21/26); 5 gefixt, 1 SUPERSEDED. Ledger-„erschöpft" additiv korrigiert |
| **M-CE-21-Fix unvollständig** — reiner Pfad-Fix aktivierte snmalloc, das nicht kompiliert | Ursache reproduziert: braucht `-mcx16` + `SNMALLOC_USE_WAIT_ON_ADDRESS=0`; Flags am INTERFACE-Target (x86-gegatet) + Adapter `A07-snmalloc` linkt jetzt `comdare::vendor_snmalloc` (single-source). End-to-End: 3 Consumer-Tests grün mit snmalloc AN |
| Manager-Probe-Fehler `snmalloc/stl/atomic.h: No such file` | War fehlendes `-I .../src`, nicht g++-16-Inkompatibilität |
| Medium #6 Regeneration ließ sich nicht auslösen | `fixtures_dir()` liest `COMDARE_FIXTURES_DIR_03` → auf leeres Temp-Dir gezeigt; committete v1-Source-Fixture blieb unberührt (Messdaten nie geändert) |
| **#15-Audit-Funde:** 2 bit-verrottete Tests, die nie kompilierten | `test_all19_segment_timer` (`LazyMeasuredRow::seg/seg_real` → `unified.seg_ns[]`) repariert+registriert; `test_obs_phaseB_pilot` (`v3`→`unified`) repariert, aber runtime-stale → nicht registriert |
| m3v2_pmc_smoke-Inversion (M-CE-25) | `honest_null = !available && all-zero` kippte bei Live-PMC auf SMOKE_FAIL → `pmc_seam_ok = available \|\| counters_all_zero` |
| `test_all19_segment_timer` **flaky** (Timing) | `rel_diff 2.49% < 5%`, Retry 1+2 Passed / 3 Failed bei identischem Binary → hardware-/lastabhängig, unabhängig von den Kommentar-Bannern |
| **`verify-first` fing 4 stale Review-Befunde** | `i_c01..i_c12` (test_sub_engines), `algorithm_baustein` (test_abi_interface), `IConcurrencyManager` (test_concurrency_disciplines) sind **LEBENDIG** (alle von registrierten, grünen Tests konsumiert); latex_anhang = SUPERSEDED. **Fazit: die §4.1-Dead-Code-Liste hat hohe Falsch-Positiv-Rate** |
| **TODO-Store durch `/goal`+`/model`-Wechsel geleert** | Alle **32 TODOs** wiederhergestellt (IDs 1-32, 16 completed, 1 in_progress); Wahrheitsquelle = Ledger+Backups+git (Ledger §0 Z.105) |
| Agent-Template-Fehler des Managers (Inc2): pauschal „MCE24-Block" für 21 Tests vorgegeben | Agent korrigierte eigenmächtig: nur 3 liegen real dort; die übrigen in `COMDARE_GOALV6_BOOST_DTESTS`/`COMDARE_PHASE_E_BOOST_TESTS`/eigenen Blöcken → pauschale Übernahme hätte **18 neue Doku-Drifts** erzeugt. Manager bestätigte die Abweichung als richtig |
| Inc3-Agent verlor kurzzeitig schließendes `</authors>`-Tag | Im selben Zyklus repariert, XML wieder wohlgeformt |
| **G5-Agent meldete „finished", war aber unvollständig** („warte noch auf die per-Stufe-Detailtabelle") — hatte Sub-Kartierer gespawnt und nicht konvergiert | Mit intaktem Kontext angewiesen, das Dossier **jetzt mit dem Vorhandenen** zu finalisieren. Wichtige Korrektur des Agenten: die **1416 Byte gehören zu `ComdareTierObserverSnapshot`, nicht zu `MeasurementRecord`** (letzteres = separates 32-Byte-Format) |

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

### E1. Laufende Agenten (Chunk endet mitten im Lizenz-Report)
1. **G5-Fork-Vorbereitung** (`aa60cac51737eec41`) — nach Nachfass zur Finalisierung angewiesen; Dossier steht noch aus.
2. **Dead-Code-Präzisions-Audit** (66+44, verify-first) — läuft, Register steht aus.
3. **Lizenz-Korrektur** (`acc3b578775511d36`) — Report **abgeschnitten bei Z.2106** (michael-README-Zeile). **Noch KEIN Commit** (HEAD `414ed8c2`). Bereits belegt:
   - tcmalloc A06: `ext/allocator/A06-tcmalloc/LICENSE` = **Apache-2.0** (Profil sagte BSD-3) — 3 Stellen
   - lrmalloc A11: `ext/allocator/axis_06_allocator/paper_a11_lrmalloc/LICENSE` = **MIT, Ricardo Leite 2018** — 3 Stellen
   - michael A03: `ext/allocator/A03-michael-lockfree/michael.h` = **LGPL-2.1-or-later, Schneider/Antonopoulos 2007** (BSD-3 = Copyleft als permissiv fehl-etikettiert)
   - **scalloc bleibt UNSICHER** (nicht angefasst)
   - Noch ausstehend im Report: REPOS_OVERVIEW-„permissiv"-Claim, michael-Copyleft-Note

### E2. Echte Forks — warten auf User-Entscheidung
- **#23** `abi_adapter:250` RC-applied-Phantom → (a) ehrlich zählen + `test_e2:101`-Erwartung anpassen *(Empf.)* / (b) konstante `4` dokumentieren-deprecaten. **Bricht eingefrorenen ABI-4-Vertrag = TABU**
- **#24** `predicate_evals` modelliert-vs-literal → Deep-Research-Verdikt **GENUIN UNSPEZIFIZIERT**; präzise Frage formuliert (Z.1053). Assertion in `pilot.cpp` bleibt **neutralisiert, nicht entschieden**
- **#25** rcu `readers_`-Eigentumsmodell → (a) per-(Domain,Thread) / (b) Domain↔Token-Link / (c) Singleton + Stack-Domains verbieten. *Empf. (a) oder (c)*
- **#10/#18** G5 `comdare-measurement-all`-Facade-Migration (#274)

### E3. Je-GO-Löschungen
- **#9-Rest:** 66 dead + 44 cleanup (inkl. M-CE-18 latex_anhang); §4.1-Liste ist komplett „Löschen/Entfernen mit GO" und **nachweislich unzuverlässig**
- Tote Symbole in **lebenden** Dateien (`set_numa_node`, `sum_total_cycles`) — delikat, marginal
- §4.2 Orphan-Artefakte (.py/.cmake/benchmarks)

### E4. Overleaf-gated
- **#1** Anhänge B/E · **M-TH-01** (SOTA-Profil 30 vs. real 33 XMLs) · **M-TH-02** (EN-Aufgabenstellung ≠ DE-Master) · Thesis-`.tex`-SUPERSEDED-Notizen · `A_measurements.tex:4` (nennt gelöschtes `.ps1`)
- **SOLL-Doku-Frage:** „22-Achsen"-Dokumente auf 26 nachziehen oder als datierter Stand belassen?

### E5. Daten-gated (nie pollen)
- **#21** T16-FPR · **#11** E4′-Vorbau (G6) — warten auf #9916-Messlauf
- **#234** Observer-Re-Kopplung (store-backed) — Zukunfts-Increment
- **M-CE-02** CrystallineAllocator-Attribution (Recherche-Gate)

### E6. Infra-blockiert
- **#2** GitLab-origin-Sync + CI-grün — GitLab post-Migration down (Routing `.local`, Token revoked); **alles liegt redundant auf github**, Handover liegt beim Infra-Agenten
- **#31** env/DLL-Companion-Tests (`br4_emit`/`br4_load`/`kf16_e2e_real_build`/`test_d4b_container_dll`) — brauchen Companion-DLL-Infra bzw. Windows-`cl`
- **M-CE-25-Runner-Verifikation** (lokal 21 grün + YAML valid, CI-Lint offen)

### E7. Sonstige getrackte Rest-Fäden
- `test_obs_phaseB_pilot` bleibt runtime-stale (unregistriert)
- `profile_facade/CMakeLists.txt:97-113` — E3-Härtungsblock-Kommentar nach #29 inhaltlich veraltet (nicht entfernt, weil er zusätzlich Generated-Includes injiziert)
- ce-Test-Zahl-Divergenz je Build-Config (`build` 262 vs. `build-conf` 265/266)
- `map`-Spez. `density_pct = sz/(sz+64)` bleibt als definierte Heuristik
- `key_comp()/value_comp()` bleiben bewusst ungesperrt (immutabler Comparator)
- prt-art `:23` `${CMAKE_SOURCE_DIR}/../comdare-cache-engine` bewusst belassen

### E8. Meta-Lektion des Chunks (vom Manager selbst formuliert, Z.2066)
> „Die Kern-Lektion dieses Zyklus: ‚braucht deine Entscheidung' war mehrfach voreilig — es gab fast immer einen autonomen **Vorbereitungs-/Verifikations-Winkel** (richtige Liste prüfen · Fork *vorlegen* statt nur erwähnen · gegen Primärquelle verifizieren)."

**Stand am Chunk-Ende:** ce `414ed8c2`, super `6fa66dd`, prt-art `b6d3f88` — alle auf **github** (merge-only); GitLab-`origin`-Sync + CI-Grün ausstehend.