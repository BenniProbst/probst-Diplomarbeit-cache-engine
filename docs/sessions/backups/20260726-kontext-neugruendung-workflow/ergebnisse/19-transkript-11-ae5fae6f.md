# Chunk 11/30 — Chronologische Extraktion (Manager-Session Diplomarbeit)

## 0. Ausgangslage (Zeilen 1-59): Stop-Hook-Patt (Goal V3)

Rund 8 identische Stop-Hook-Feedback-Zyklen zum Goal-V3-Text ("behandle die sichtbare TODO Liste als stack ... bis sie behoben sind"). Sichtbare PENDING-Items: #3, #5, #8, #9, #11, #17, #24 (nur #25 completed).

Assistant-Position (mehrfach wiederholt, unveraendert): Die 6 Restpunkte sind nicht "vermeidbare Gates", sondern die Pflicht-Direktiven selbst:
- #24-Endschritt = Commit in Overleaf-gekoppeltes Thesis-Repo -> Standing-Regel "Bestaetigung".
- #3/#5/#8/#9 = echte Architektur-Entscheidungen -> Direktive "bei NEUER Architektur-Entscheidung ANHALTEN".
- #11/#17 = #9916-Messdaten, physisch noch nicht existent.
Begruendung: "Diese ohne dein Signal zu 'beheben' hiesse, drei Direktiven gleichzeitig zu brechen (dein Dokument ohne Zustimmung aendern, deine Design-Entscheidungen usurpieren, fehlende Daten erfinden)." Ein automatischer Hook ueberschreibt explizite User-Direktiven nicht.

---

## 1. Freigaben-Katalog und das grosse GO (Z. 71-156)

**User (Z.71):** "Bitte stelle mir nochmal sauber alle Rückfragen und beschreibe mir alle Freigaben, die ich erteilen muss"

Assistant legt GO 1-5 + Fragen 6/7 vor (GO 1 Overleaf-Anhang-Verdrahtung; GO 2 Codegen-cpp-Backend als Default; GO 3 = #5 Hebel-A-Rest; GO 4 = #8 Fork F-A/F-B/F-C; GO 5 = #3 Extern-Forks + #9; Frage 6 CI-Drosselung; Frage 7 NAS-Writeback #202).

**User-Direktive WOERTLICH (Z.129) — das zentrale Freigaben-Paket dieses Chunks:**
> "Ich gebe GO 1 und GO 3 frei, dann gebe ich GO 4 frei (aber stelle nochmal eine konkrete Rückfrage was ich wählen soll), ich gebe GO 5 KOMPLETT autonom frei, und ich gebe GO 2 als letzten durchzuführenden Punkt frei (durchführen zum Schluss mit mehrtägiger Messung, damit alles steht wenn wir messen und wir direkt ALLE Fehler erkennen). Frage 6: Wir setzen concurrency von prod1 auf 3, wir machen einen Voll-Lauf zur Probe und benötigen derzeit die Maschine für andere Projekte, machen also einen langen Lauf nur für den proof of concept, bevor wir die Maschine von Last isolieren um sinnvolle Messergebnisse zu erzeugen - Geduld haben wir, das Smoke Profil bauen wir zusätzlich wie beschrieben, ich hatte ja angemerkt, dass wir ein Profil anlegen wollen welches alle Features des gesamten Systems einmal berührt und damit die 320er umfassend erweitert -> erst smoke UND dann Voll lauf. Die CI wird NICHT gedrosselt, bevor ich das freigebe, wir führen das trotzdem aus. Frage 7: Ja die Messergebnisse sollen später zusätzlich zurückschreibbar sein, dazu musst du dich in die VLAN Tabelle einlesen und den backup pod identifizieren, das Ziel ist es, dass der backup pod das Schreiben nur auf den Ordner cache-engine-experiment auf dem Cluster_NFS freigibt und sonst für VLAN 60 Elemente wie runner den Zugriff verweigert. VLAN 20 wäre Vollzugriff, den wir aufgrund externer Mandanten nicht gewähren, dazu ist genau die Berechtigungsfilterung eines virtuellen VLAN 80 Filterpods über VLAN 20 NAS gedacht, die runner werden mit externen Firmen geteilt und sie dürfen Cluster_NFS nicht betrachten oder lesen, dennoch müssen wir die Messergebnisse sauber über eine SNI DNS Methode (strikt Cluster Seite) ablegen können. Bitte schreibe daher ein Handover an den Infra Agenten für diesen Belang, ich überreiche das. Ich gebe die vollautonome Arbeit frei"

**Umsetzung sofort:**
- **GO 1 VOLLZOGEN:** 4 neue Sektionen in `anhang/{de,en}/A_measurements.tex` via `\InputIfFileExists` (Segment-Attribution, Latenz-Range+ECDF, Forest-Plot). thesis `73947aa` (Overleaf-gekoppelt gepusht), super-Gitlink `54d3983`. Literal: PDF 701 KB, Sektionen A.4/A.5 in toc/aux. Task #24 -> completed.
- **Frage 7 Handover geschrieben:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md` — V80-Filterpod-Architektur (V60-Runner -> VIP 10.0.60.1 + SNI `measure-drop.comdare.de` -> HAProxy-TCP-SNI-Passthrough -> V80-Filterpod, einziger mit V20-Route, NFS-Subpath-Mount nur `cache-engine-experiment`, write-only, Pfad-Jail, additiv/409, eigenes rotierbares Credential nach Muster Token id=54), DoD F-1..F-7; plus prod1-concurrency 2->3 (config.toml root-only -> Handover-Punkt).
- **Ledger §11-I** (alle Freigaben verankert) committet `ba07692`; §12-Zyklus-I `8138b84`.

---

## 2. GO 4: Rueckfrage und User-Entscheid (Z.157-217)

GO-4-Dossier (`docs/sessions/backups/20260712-go4-f-abc-dossier/DOSSIER.md`) -> Empfehlung F-C.

**User-Entscheid WOERTLICH (Z.198):** "F-C wie empfohlen, aber zusätzlich F-B damit wir als Permutation und dokumentiert den Effekt Unterschied bewerten können"

Architektur-Begruendungen aus dem Dossier: F-B (NUMA/Page->allocator) ist thesis-motiviert, aber kurzfristig wirkungslos (golden-320 faehrt `std_malloc` x320, NUMA braucht Multi-Socket-HW ~Sep); F-C baut den heute fehlenden Mess-Knopf fuer die woertliche FF2-Teilfrage (CSS/CSB+ 1 Cache-Line vs. Hankins/Patel 16 Cache-Lines).

---

## 3. Paketmeldungen / Abnahmen / Commits (chronologisch)

| Increment | Inhalt + Architektur-Entscheidung | Beleg | Commits |
|---|---|---|---|
| **GO 4 / F-C (C1+C2)** | C1: cacheline-Werteset additiv `{B32,B64,B128,B256}`, `all_configs()` 45->60 mit **Index-Stabilitaet** (B32-Block angehaengt); `kCacheLineSubaxisVersion` 1->2. C2: NEUE FF2-Unterachse `node_width` {Native,W1..W16}, NTTP+Concept+CRTP-Mixin, **real konsumiert** in `axis_04_node_type_layout_aware_store.hpp` (Chunk-Geometrie), nur profil-aktiviert | ctest 214/214; `NEUTRALITAET: node_width deklariert-aber-inaktiv -> binary_ids byte-identisch`; TABU-grep 0 | ce `a08a60ca`, super `3f8c25c` |
| **GO 3 (#5 Hebel-A)** | Option 1 "Deklarations-Wahrheit + Mess-Kern-Reinheit": A1 echte ISA-Flags je 09b-Extension + consteval-Kohaerenz-Guard (`declared_extension_matches_build<SE>()`); A2 Striktheits-Guard `test_striktheit_scan_kernel_purity` friert 9 Kernel-Familien ein. Begruendung: volles isa-Routing in *_scan-Kerne waere Signal-Korruption (Zugriffsmuster IST das Signal) | ctest 216/216; Configure-Negativ-Probe `static assertion failed`; objdump: real_avx512.so `zmm`, real_avx2.so `ymm`; Laufzeit Etikett==Realitaet | ce `def62b0a`, super `7fb89ee` |
| **#26 Smoke-Profil (Frage 6)** | **Kritischer Multi-Sweep-Fix**: `run_profile` fuhr nur EINEN Selektions-Pass -> deklarierte `<axis_sweeps>` wurden im offiziellen XML-Weg nie gemessen. Neuer Helfer `profile_sweep_passes` + `pass_seen_ids`-Dedup. 4 neue Sweep-Kataloge (19 Achsen komplett). Neues `m3_smoke_coverage.profile.xml`; CI-Job `measure:smoke` (inert) + `needs`-Kette "erst Smoke, dann Voll" | ctest 217/217; validate `19 Achsen, 19 Werte, 19 axis_sweeps, 21 sota_series / VALIDAT OK`; CI-Lint valid; Inert-Check an Pipeline #10015 | ce `0a1a2e3b`, super `4569924` |
| **F-B (GO 4 zweiter Teil)** | NEU `alloc_hw_config.hpp` (AllocNumaNode/AllocPageHint, Concepts, CRTP `AllocHwAware`, compile-time HW-Gate `gate_alloc_hw_for<HW>()`). **honest-0 beseitigt**: erster Konsument fuer `memory_page_size`/`huge_page_capable`; `NUMAllocAllocator` Hartcode `kDefaultNumaNode=-1` abgeloest | ctest 218/218; `Node0/Node1`-Beleg, Pool `largest_required_pool_block` 4096 vs 2097152; golden-320 traegt 0x alloc_hw | ce `1211749e`, super `7054853`; Ledger §12-Zyklus-II `3686855` |
| **GO-5 Forks 1+2+6** | Fork 2: Dataset-Wahrheitsquelle = `Code/test_data_xml/*.test_data.xml`, `test_data_sets.xml` als DEPRECATED-Slot (nichts geloescht). Fork 1: `<datasets>` additiv im E4-Schema + Resume-Stamp `resume-v5`. Fork 6: `fairness`-Attribut an `<sota_series>` (common_denominator/native) bis CSV-Endspalte durchgereicht | ctest 219/219; m3v2-validate byte-identisch; golden gruen | ce `d2815c02`, super `a29c420` |
| **GO-5 Fork 7 (H2-Score)** | Tool-berechnete Akte statt Hand-Wert: `h2_score_akte.hpp` + CLI `comdare-h2-score-akte` (cppcheck 2.21.0 == CI-Version, aus Quelle nach `~/tools/cppcheck-2.21.0/`), Formel `(3*error+2*warning+1*performance+1*portability+0.5*style)/(LOC/1000)`. 12 Scores (art 1.900 ... start 20.885), 21x honest-`n/a`; CSV-Endspalte `h2_code_quality_score` | ctest 220/220; Determinismus byte-identisch (2 Laeufe) | ce `91bf2083`, super `977039a` |
| **Aufraeum #5** | 3 Studien-Profile auf kanonische Registry-Namen gezogen (KEINE Validate-Aliasse); **cap-0-Fix**: `profile_effective_cap()` — 0/fehlend = KEIN Cap (vorher leere Basis-Selektion); `m3_golden_coverage`-Basis erstmals korrekt 320 | **alle 10 Profile validieren Exit 0** (vorher 3x Exit 1); ctest 220/220; m3v2_study byte-unberuehrt | ce `bc8eecfd`, super `b8b48cf` |
| **GO 2 FINAL** | Default-Swap `COMDARE_PERMUTATION_CODEGEN_BACKEND` cmake->cpp. **Begruendete Muster-Abweichung**: statt anatomy-skip ein lauter deterministischer cmake-Fallback im selben Configure, weil CI-Job `visibility:tier-binaries` Single-Pass konfiguriert -> Default-Swap CI-neutral | Pass1 Fallback, Pass2 `Backend=cpp`, Pass3 idempotent; perm-DLL linkt real; byte_identity smoke+medium Passed; ctest 220/220 | ce `e99e968f`, super `837bb4a` |
| **#6 mimalloc-GRENZE** | Ursache: Asymmetrie — `USE_MIMALLOC=1` global via `configure_file`, Vendor-Include nur target-scoped. Fix: eine Zeile `link_libraries(comdare::vendor_mimalloc)` im perms-ON-Zweig nach `add_subdirectory(ext)` (Vorbild PAPI/PCM) | perms-ON-Tree erstmals volle Suite: 216/216; Standalone 220/220; 211 Test-Binaries (vorher 0) | ce `e5946cdb`, super `0c34342` |

**Abnahme-Meldung (Z.762-779, 852-874):** Gesamte Freigaben-Sequenz GO 1-5 + Fragen 6/7 vollzogen; jeder Increment fresh-context gebaut, Zeile-fuer-Zeile reviewt, selbst literal verifiziert (ctest-Kette 214->220, golden durchgehend gruen, TABU durchgehend 0).

**User-Nachfrage (Z.780):** "Welches infra Handout liegt bei mir und unter welchem vollen Pfad" -> Pfad genannt (s.o.).

---

## 4. Fehler + Fixes innerhalb der Freigaben-Zyklen

| Fehler | Fix |
|---|---|
| Dossier-Schaetzung "≈115 Binaries" falsch (zaehlte CMake-ENABLE-Flags) | Ehrlichkeits-Befund: `USE = ENABLE && HAVE` -> real **93** (72 Union + 21 SOTA); im Test gepinnt |
| Latenter `cap="0"`-Defekt = leere Basis-Selektion | Zuerst umschifft (`cap="1"` im Smoke-Profil), dann im Aufraeum-Increment als `profile_effective_cap()` echt gefixt |
| `test_kf1_thesis_profile_parser` seit HEAD rot (thread_counts-Pin) und **in keinem ctest registriert** | Profil auf `1` nachgezogen; Registrierungsluecke dokumentiert (Muster F der spaeteren Synthese) |
| 2 latente Test-Bugs, erst durch mimalloc-Fix sichtbar | `test_v41_topic_allocator_axis_06.cpp:226` `std::free` auf `mi_calloc`-Zeiger (Heap-Crossover-Abort) -> domaenen-korrekte Freigabe; `test_smoke_coverage_profile.cpp:65` Pin 72 -> compile-time `flags::mimalloc_enabled` (72/93 bzw. 73/94) |

---

## 5. Voll-Zeilen-Review (Z.880-1324)

**User-Direktive WOERTLICH (Z.880):**
> "Bitte führe mit Fable ultracode einen code review und einen review über den Ist Zustand und das geplante Soll und das diff aus. Reviewe jede einzelne Zeile code des gesamten Projektes der Diplomarbeit, cache-engine, prt-art und overleaf-latex erneut. Reviewe auch die Synthese der bestehenden Software Architektur auf Fehler und markiere aufzuräumende Artefakte und toten code."

Workflow `wf_b4a4d7c3`: 32 Reviewer (29 Partitionen + Ist/Soll/Diff + Architektur-Synthese + Dead-Code-Sweep), adversariale Verifikation, Synthese. Leitplanken: TABU-Gueter als gewollt-eingefroren (keine Findings); Dead-Code nur mit grep-Beweis; Loeschungen nur MARKIERT.

**Drei Anlaeufe wegen Limits:** Lauf 1 (23/32 Reviewer, 294 dedup, Session-Limit), Lauf 2 (32/32, 394 dedup, 14 confirmed, Fable-5-Limit), Lauf 3 auf Opus 4.8 -> **368 confirmed, 153/153 Agenten fehlerfrei**. Bericht: `docs/sessions/backups/20260712-full-line-review/REVIEW-BERICHT.md`.

**Kennzahlen:** 0 critical, 40 major, 7 medium, 260 minor, 2 low, 59 info. Kategorien: doc-drift 114, correctness 100, dead-code 66, cleanup 44, test-gap 26, architecture 18.

**Top-Findings:** `abi_adapter.hpp:390` alloc ohne nullptr-Pruefung; `cpuid_probe.hpp:103` AVX-512 ohne OSXSAVE/XGETBV -> SIGILL; `axis_filter_cuckoo.hpp:67` echte False-Negatives; `axis_03b_..._hash_lookup.hpp:150` Probe-Kette; `axis_06_allocator_scalloc.hpp:167` Heap-Korruption; `rcu.hpp:61/66` Grace-Period-Race; `sota_catalog.hpp:159` St2 ignoriert `lebewesen` -> 7x identische Zeilen + falsche H2-Attribution; **#8** `ff2_node_width_study.profile.xml:48` + `validate_profile.hpp:102` Workload-Tokens `A-F` matchen keine `ycsb_*`-id -> E4-exit-4; `SIMDOps.hpp:180` avx2 uninit Tail; `array_65535.hpp:21` prt-art Off-by-one.

**6 Architektur-Synthese-Muster:** A Anti-Phantom, B noexcept-auf-Alloc, C Null-Consumer-Trap, D Super-Sub-Build-Pfad-Divergenz, E Doku-Drift-Epidemie, F Test-Registrierungsluecken.

**Selbst-Befund + Sofortfix:** #8 CONFIRMED und real — die eigene Profil-Kanonisierung uebersah es (validate prueft Workload-ids nicht). Alle drei Studien-Profile gefixt (ce `7d50bba1`); Review-Backup committet `a40cf01`/`98e0498`, Rohdaten (50 MB, 720 Dateien) **lokal + gitignored** gesichert (4 Dateien enthielten Token-Muster -> nie gepusht, keine Werte zitiert).

**CI-Regressionen (2 Runden) gefunden und gefixt:**
1. `test:unit` (ce): byte_identity-ctest-Treiber `perm_codegen_byte_identity.cmake` von `.gitignore`-Regel `*.cmake` still verschluckt -> Negation `!tests/unit/*.cmake` + Treiber committet. `lint:static` (ce): cppcheck `unknownMacro` -> Suppression. `lint:static` (super): P3-`OpRangeSpec` Pointer-to-Member ohne Initializer -> `= nullptr`. (ce `d426cad4`, super `5bfe851`)
2. Zweite Runde: byte_identity failte an `cpp-Backend rc=no such file` — Perm-CLI wird im `test:unit`-Job nicht gebaut -> `comdare_permutation_codegen_cli` zum `COMDARE_TEST_PREBUILD_TARGET` (etablierter 2-Pass-Mechanismus, den #25-B vergessen hatte). lint: Em-Dash im Erklaertext hinter der Suppression wurde als Attribut gelesen -> Suppression umsortiert (bare Direktive zuletzt). (ce `aa579a5d`, super `c94c6c2`) -> **CI danach literal gruen (ce=success super=success)**.

**User-TODO-Auftrag (Z.1266) WOERTLICH:**
> "Bitte füge hinten in die TODO Liste auch noch ein, dass wir unter Projekte/docs/sessions einen neuen großen Code review gemacht haben. Er kann dir helfen, die Diplomarbeit weiter zu verbessern, besonders weil du vergessen hattest die geplante Migration des Modules comdare-measurement-all in Einzelmodule nach comdare Facade Konvention in den Projekten zu zergliedern. Der code review schließt hunderte Projekte mit ein, aber konzentriere dich bitte nur auf Diplomarbei relative Projekte."
-> Task #7 (Auswerten+Planen, nicht Blind-Umsetzung; Modul-Split = Architektur-Entscheidung -> Design-Fork vor Umsetzung). Hinweis: `~/Projekte/docs/sessions` existiert nicht als Verzeichnis.

**Triage-Vorschlag (offen zurueckgegeben):** P1 Mess-Integritaet / P2 Achsen-Korrektheit / P3 Aufraeum (je-GO fuer Loeschungen).

---

## 6. Goal V4 + Forgotten-TODO-Sweep (Z.1325-1488)

**User-Direktive WOERTLICH (Z.1325):** "Bitte schreibe eine neue elaborate Goal Version ins Ledger und gib mir einen Meta-Goal-Referenztext, mit dem ich das goal aktivieren kann, wir arbeiten das einfach von vorn nach hinten durch"

-> **§0-GOAL-V4** additiv im Ledger: geordneter Front-nach-hinten-Stack **G1->G8** (G1 CI-gruen, G2 Mess-Integritaet, G3 Achsen-Korrektheit, G4 Aufraeum, G5 measurement-all-Facade-Migration, G6 Messlauf, G7 gated, G8 Abgabe-Blocker); Mission/FF0-FF4/DoD 1-6/Direktiven/TABU unveraendert. Meta-Goal-Referenztext ausgegeben (Z.1336) und spaeter vom User per `/goal` aktiviert (Z.1607-1615).

**Forgotten-TODO-Sweep** `wf_e06e5a88` (8 Modalitaeten, 40 Kandidaten, adversarial): **nur 4 genuin vergessen** — Rest lueckenlos getrackt. Bericht `docs/sessions/backups/20260712-forgotten-todo-sweep/BEFUND.md`:
1. **G3, major:** ungeguardeter uint16-Narrow-Cast im Mapping-Observer-Seitenpfad (`abi_adapter.hpp:588/896`, `slot_index_type=uint16`) -> stille Trunkierung ab key>=65536; #217-2a loeste nur die Wurzel.
2. **major:** Anhang B "Code-Struktur" = 4-Zeilen-Stub (de+en).
3. **major:** Anhang E "Architekturentscheidungen/ADR" = 4-Zeilen-Stub.
4. **minor:** `binary_blob_writer.hpp` CRC64-Footer nie implementiert (`write_u32(out,0)`) + Layout-Doku sagt "CRC64 4B" (Breitenwiderspruch).

**Ledger-Drift-Korrektur (additiv, nichts geloescht):** AP-B4/AP-B5 stehen im Ledger als DONE ("125 Pfade", "12 ADRs"), git-Historie zeigt aber fuer beide Anhaenge nur `dc68189 Initial Overleaf Import` -> **Ueber-Behauptung**, PDF hat leere Anhaenge B+E = Abgabe-Blocker (Overleaf-gated). Goal V4 final committet `a40d380`.

---

## 7. GitLab-Ausfall-Saga (Z.1423-1606) — Infra

User-Nachrichten: "Kannst du gitlab wieder erreichen? Die Migration ist durch, bitte fahre mit offener Arbeit fort" · 2x "gut, dann gitlab sync. Versuche es nochmal, der infra agent ist jetzt fertig" · "gitlab.comdare.local ist aber online?" · "Der token für ***CRED-NAME-REF:comdare-admin-management*** ist gültig"

Diagnose-Kette (literal belegt, keine Secret-Werte zitiert):
- `gitlab.comdare.de` -> 10.0.60.1 (V60-SNI-VIP): TLS-Handshake OK (Cert `gitlab-ca`), aber **alle** Pfade (`/users/sign_in`, `/api/v4/version`, `/-/health`, git `info/refs`) -> nginx-404 = Fallback-Server, keine GitLab-App. Alternativ-VIPs 10.0.16.1 / 10.0.10.211/.212 tot.
- **Durchbruch:** `gitlab.comdare.local` loest ueber Cluster-DNS (10.0.10.1) auf 10.0.10.1 auf und **lebt** (health 200, sign_in 200, Cert-SAN enthaelt `gitlab.comdare.local`). Lokaler Stub-Resolver 127.0.0.53 verweigert `.local` (mDNS-Reservierung); kein sudo, `/etc/hosts` nicht schreibbar -> **git** kann die lebende Instanz nicht erreichen.
- **Echter Blocker = Auth:** API antwortet `invalid_token` / "Token was revoked. You have to re-authorize from the user." Vault (`Cluster/keys/CREDENTIALS-VAULT.md`) markiert PAT **id=15 (***CRED-NAME-REF:comdare-admin-management***) selbst als REVOKED**; aktiv waere Keeper **id=21**, der aber laut Vault **AMBIG** ist ("NICHT raten, live verifizieren"). Assistant stoppt das Vault-Fischen bewusst, keine Selbst-Ausstellung von Tokens, keine Werte in Logs. (Sicherheits-Selbstkritik: ein Masking-Regex maskierte die PAT-Zeile korrekt, aber nicht alle 40-Zeichen-AD-Passwoerter im Rotation-Log -> keine weiteren Vault-Dumps.)
- **Cluster-Handover** geschrieben: `~/Projekte/Cluster/docs/sessions/20260712-HANDOVER-INFRA-gitlab-migration-broken-diplomarbeit-sync-blockiert.md`, committet `854aed13` (branch main) — **Push scheitert** (Cluster-Repo hat nur den gitlab-Remote, github per K104 gestrippt weil der Vault dort liegt) = Henne-Ei.
- Hilfsjobs `bdtr1m4t0` (Auto-GitLab-Push) und `bst407ghu`/`b6ykz6fki` (CI-Monitore) liefen aus, dauerhaft `api-down` -> moot.
- **Arbeitsmodus-Entscheidung:** "lokal voll-verifiziert (ctest + golden + cppcheck + clang-format + Mojibake) + github", GitLab-Push und CI-Grün-Abnahme nachgezogen sobald Infra fixt. github traegt vollstaendigen Stand.

---

## 8. Task-Board-Rekonstruktion + weitere User-TODOs (Z.1616-1758)

Task-Store wurde durch `/goal`+`/model`-Wechsel geleert (nur #1 ueberlebte) -> vollstaendige Rekonstruktion aus allen Session-Backups: **16 Tasks** (inkl. neu erfasster Muster C/D/F), Goal-Text erweitert, Ledger `097b63e`.

**User-Direktive (Z.1644):** "Bitte füge als weiteres TODO hinzu, dass wir alle 40 regressions fixen müssen und dass wir Teile der Diplomarbeit in das umbrella comdare-measurement-all zergliedern wollten (vergessen?)"
-> **#17** 40-major-Abschluss-Gate (Rollup gegen die `M-xx-yy`-Liste in `REVIEW-BERICHT.md §2`; ce 28 / super 7 / prt-art 3 / thesis 2). **#18** #274 metrics-Transfer — **bestaetigt vergessen**: `comdare-measurement-all/README.md:7` sagt woertlich "0-core: Mess-Kern: comdare-metrics — Transfer folgt in #274 Schritt 3", nie ausgefuehrt. G5 jetzt in beiden Richtungen gefasst (5a Extraktion Diplomarbeit->Umbrella / 5b Umbrella-Facade-Struktur); Architektur -> HALT, Umfang+Schnitt zuerst als Design-Fork. Ledger `ee08561`.

**User-Direktive (Z.1659):** "Bitte finde über alle Sessions der letzten 2 Tage mit ultracode weitere noch nicht erledigte Aufgaben, die nachweisbar nicht eingebaut wurden und nicht gegen den Plan verstoßen und auch keinen Fortschritt wieder rückgängig machen."
-> Sweep `wqd3n8wqh`, 3 harte Gates. **4 bestaetigt** (Bericht `docs/sessions/backups/20260713-two-day-forgotten-work-sweep/BEFUND.md`), alle aus dem Session-Review-Track (Dossier-Track: kein Ueberlebender = Vollstaendigkeitsbeleg):
- **#19 (major, G3):** prt-art `LeafOnlyCounter` **Use-after-free** — `ensure_slot()` gibt bare Referenz nach Lock-Freigabe zurueck, `reset()` zerstoert per `counts_.clear()` den `unique_ptr` (`leaf_only_counter.hpp:93-99,137-139,143-159`); #264-Fix deckte nur den Map-Race. Selbst am Code verifiziert.
- **#20 (major, G2):** V37.C/V38.C Legacy-Mikrobench laeuft **ungegatet** am Kopf von `Code/02_messung_driver/main.cpp` (Guard erst :595, nur ExperimentDriver) -> paralleler Mess-Pfad, verletzt "EIN offizieller XML-Weg". Selbst verifiziert.
- **#21 (minor, G6, data-gated):** T16 gemessene FPR unverdrahtet (nur constexpr-Space-Seite in `895546f4`), kein Negativ-Probe-Set.
- **#22 (minor, G1):** `verify:submodules` lehnt `+/-/U`-Praefixe nicht ab, kein HEAD==Gitlink-Assert (mit `update=merge` riskant).
- **Gate-3-Ablehnungen bewusst dokumentiert:** ZeroingStrategy-deallocate-Vertrag (am 12.07. bewusst entschieden, Fix wuerde Heap-Crossover reintroduzieren), P6-Voll-Entfernung des Legacy-Pfads (golden-320-Subsumtion unbestaetigt -> nur Gating aufgenommen), T8-Fix-A (#221-revert). Ledger `c1368ba`. Board -> 22 Tasks.

**E0-E4-Konsolidierung:** Task #16 hatte `measurement_axis_registry`/`i_measurement_source`/`curve_fit`/`selection_filter_chain` als "dead-code (G4)" erfasst — das ist aber bewusster **#156-DATA-gated E4'-Vorbau** (Doc-20-Null-Consumer-Trap) -> verschoben nach **G6/#11** (verdrahten nach #9916, nicht abreissen). Ledger `d4886c6`.

---

## 9. Rebase-Vorfall und echter Merge (Z.1669-1721)

- ce-github-Push abgelehnt (non-fast-forward): eine **andere Session** hatte `562a976f` ("docs(review): refresh matrix facade code review", `docs/sessions/20260712-transfer-001-...matrix-facade.md`) gepusht. Assistant **rebased** -> ce `8cde40b0`.
- **User-Direktive (bindend, als Memory verankert `feedback_nie_rebase_immer_merge`):** NIE rebase, immer merge; vor jedem Push fetch+merge — Begruendung: dutzende Agenten pushen parallel auf dieselben Branches, force-push/rebase zerreisst fremde Commits.
- **User (Z.1687):** "Kannst du den anderen commit nachträglich reparieren und mergen?" -> Assistant belegt: nichts verloren (`562a976f` ist Vorfahre von HEAD), Merge-Form braucht force-push -> Optionen A (so lassen) / B (mit explizitem GO).
- **User (Z.1709):** "Bitte force push ce . Bitte merge beide commits echt" -> echter 2-Parent-Merge **`5c3ee14d`** (Parents `562a976f` + `0d9440c1`), Tree **byte-identisch** zu `8cde40b0`, `--force-with-lease=development:8cde40b0` (verifiziert, dass github nicht weitergewandert war), super-Gitlink `2dd5272`.

---

## 10. Goal-V4-Stack-Abarbeitung G2 (Z.1616-Ende)

- **G2 #3 Workload-id-Cluster (M-CE-11/12):** `m3v2_smoke`/`m3v2_sota_pilot` auf `ycsb_*` gezogen + `validate_profile` prueft jetzt Workload-ids (unbekannt = harter Fehler statt exit-4-Falle) + Negativ-Test. ctest 221/221. ce `8cde40b0` -> spaeter `5c3ee14d`, super `49c7a79`.
- **G2 #4 sota_catalog:159 (H2-Fehlattribution):** Semantik-Entscheidung dokumentiert — **(a)** Dedup in `build_sota_passes` auf Schluessel `(view_binary_id, fairness_mode)` (St2 kollabiert zu 1 Pass; fairness-Varianten bleiben erhalten); **(b)** Zaehler ueber `std::set` = distinkte binary_ids; **(c)** H2-Attribution = **Host-H2** (St2-Host ist fix HOT) via neue Felder `SotaModule::host_lebewesen` / `SotaPass::h2_lebewesen`. Anti-Phantom-Begruendung: `lebewesen` in die binary_id zu ziehen haette 7 Fake-IDs fuer byte-identischen Code erzeugt. ctest 222/222; m3v2_study -> 14 distinkte SOTA-Binaries. ce `d52c7ee4`, super `bbb3c1e`.
- **G2 #5 Cycles-/Bytes-Fabrikation -> honest-0:** super `measurement_writer.hpp` (`total_cycles = total_us*3000.0` 3-GHz-Konstante und `bytes_allocated = n_ops*64` entfernt -> 0); ce `f15_compare/main.cpp` (`bytes = ops*64` entfernt; `total_cycles` ist dort **real** gemessen und bleibt). Belege: `HONEST_ZERO_CYCLES_AND_BYTES=TRUE`, Downstream (csv_to_latex/diagram_generator) vertraegt 0 ohne nan/inf. `tier_erase` = kein Phantom (echte Statistik). ctest 222/222, super 49/49. ce `d8691e6c`, super `5106583` (+ `89f32f9` Sweep-Backups).
- **Fortschritt am 40-major-Gate: 5/40** (M-CE-07 honest-0-Teil, M-CE-10/11/12 u.a.).

---

## 11. Offene Faeden am Chunk-Ende

1. **Design-Fork Task #23 — wartet auf User-Entscheid (a)/(b):** `abi_adapter.hpp:250` RC-`applied`-Zaehler zaehlt z.B. `prefetch` als applied auch fuer Kompositionen ohne Setter (NonePrefetch/WormholeComposition). Ehrlicher Fix senkt applied 4->=<3 und **kippt den eingefrorenen ABI-Vertrags-Test** `test_e2_contract_abi_vertrag.cpp:101 (==4)` + verletzt E1-Freeze "Semantik nur additiv"; POD/caps sind TABU. Empfehlung **(a)**: in den einen geplanten ABI-4->5-Bump (#215/CMD-2) buendeln, bis dahin als dokumentierte Limitierung. Alternative **(b)**: jetzt Freeze-Ausnahme. Korrekt gestoppt statt TABU zu brechen.
2. **G2 #6 geliefert, aber NICHT reviewt/committet** (Chunk bricht mitten im Agentenbericht ab): (A) `execute_engine_command.hpp:139` — fabrizierte H1/H2/H3 (1.0/1.0/0.5) entfernt, Felder bleiben ehrlich `0.0` -> `hX_validated()` liefert jetzt `false` statt Schein-`true` (0 produktive Konsumenten grep-belegt); (B) `.gitlab-ci.yml` — Selbsttest-Store `prebackup_store` -> `prebackup_selftest_store` umbenannt, `needs`+Kopier-Block aus `persist:measurements` entfernt (synthetische CSVs liefen unter der Nie-loeschen-Doktrin in den `measurement/`-Baum). ce ctest 218/218 (build-go2), super YAML valid, **CI-Lint pending GitLab**. Working Tree in ce + super dirty, kein Commit.
3. **GitLab weiterhin down/Token revoked** -> `origin`-Sync aller 4 Diplomarbeit-Repos + Cluster-Handover (`854aed13`) + jede CI-Grün-Abnahme haengen am Infra-Handover (P1 Routing `.de` vs `.local`, P2 gueltiger write-PAT / Keeper-id-Ambiguitaet, P3 `.local`-Aufloesung ohne sudo). Alles redundant auf github.
4. **#9916 golden-320-Messlauf:** Status seit dem API-Ausfall unbekannt; Risiko, dass der prod1-Runner die GitLab-Verbindung verlor -> als Erstes pruefen, sobald GitLab zurueck ist.
5. **Restlicher Goal-V4-Stack:** G2 #7 (prt-art-Phantom) -> G3 (#8 Achsen-Korrektheit inkl. uint16-Cast, #19 UAF) -> G4 Aufraeum (66 dead-code, je-GO) -> **G5 measurement-all-Facade-Migration (Architektur-HALT, Design-Fork an User)** + #18 metrics-Transfer -> G6 Messlauf/E4'-Verdrahtung -> G7 gated -> G8 Abgabe-Blocker.
6. **Abgabe-Blocker (Overleaf-gated):** Anhaenge B (Code-Struktur) und E (ADR) sind leere 4-Zeilen-Stubs trotz Ledger-"DONE" (AP-B4/AP-B5).
7. **Board-Stand:** 23 Tasks (G1-G8 + G-INFRA + Muster A-F + User-Gates #17/#18 + Sweep-Funde #19-#22 + #23 ABI-Fork). **40-major-Gate: 5/40.**
8. Offene Nebenpunkte: `test_kf1`/`test_profile_roundtrip`/`test_03_binary_to_csv_cached_fixtures` nicht ctest-registriert; ce `ext/A05-jemalloc/`-Orphan; ~9,1 GB `build*/`-Trees (mit GO aufraeumbar, ACHTUNG ce `build/` traegt getrackte `tier150_measurements.csv`); `tools/socks5_zih_delivery/README.md:25` committet ZIH-Login/VPN-Cert-Pfade (Entfernung nur mit GO).

Selbstcheck: keine Secret-Werte (auch nicht teilweise) in dieser Ausgabe; nur PAT-ids (15/21/54) und Datei-/Vault-Pfade.