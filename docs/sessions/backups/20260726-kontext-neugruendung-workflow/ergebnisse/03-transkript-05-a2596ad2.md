# CHUNK 5/30 — Extraktion (chronologisch)

## (a) USER-DIREKTIVEN (woertlich wo bindend)

**Segment 1 — prod2-Strang**
1. `/model` → Opus 4.8 max; `/goal` V3 gesetzt (woertlich): *"Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur Striktheit der Organisationsform der Programmierumgebung, der Modulreferenzierung und der Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind."*
2. *"Bitte fahre mit der letzten Aufgabe vor dem goal fort"*
3. *"Soll pipeline 9113 immer noch laufen? Denn da passiert nichts"* / *"Der Job wir nie aufgenommen"* / *"Bitte pruefe nochmal wo wir stehen"* (User-Beobachtungen, die zur Root-Cause fuehrten)
4. *"Bitte reboote den prod2 nach runbook"*
5. *"Bitte uebergebe das Problem an den Infrastruktur Agenten, dann machen wir mit offener Arbeit und prod1 weiter"*

**Segment 2 — #31-Ebenen-Korrektur (die zentrale Direktiven-Kette)**
6. *"Bitte fahre mit offener Arbeit aus der letzten Session fort"*
7. **BINDEND (Architektur-Grundsatz):** *"Bitte starte ultracode workflows ueber die Planung der letzten 6 Wochen, um den B+-Experiment Baum, die 4 Schichten der Architektur aus dem workflow backup und die xml Anforderungen zu lesen. Wir hatten als Anforderung ein komplettes Framework von workloads als runtime und Achsen-Algorithmen als compile time Festgelegt, du durchblickst gerade die Architektur nicht mal im Ansatz"*
8. **BINDEND (Skala):** *"Es gibt allein 19 Achsen permutativ mit compile time und ueber 60 dynamische unter-Achsen mit runtime Konfigurationen. Das ist ein gigantisches System mit mehreren millionen Binaries, die in Rekombination gebaut werden koennen. Bitte behandle diese Aufgabe als ernst und architektonisch maximal anspruchsvoll"*
9. **BINDEND (Backup-Pflicht, 2× gegeben):** *"Bitte speichere den aktuellen workflow wieder mit allen rohdaten und Ergebnissen als backup ab. Das spart uns tokens beim Nachlesen in weiteren Kontexten"* / *"Bitte sichere weiterhin alle workflow rohdaten und Ergebnisse ins backup, dann brauchen wir es nur ueber multiple sessions wieder einlesen"*
10. **BINDEND (Ebenen-Zuordnung):** *"die diplomarbeit stellt Profile xml zur Verfuegung, welche die cache engine durchfuehren soll"* + *"wir arbeiten ja an den 2 Schichten oben drueber an der Diplomarbeit code. Wir hatten schon mal was von 4 layern gesagt, bitte suche das gezielt"* + *"Wir wollten die Architektur top down durcharbeiten"* + *"Die cache engine liefert die Bibliothek fuer die Interpretation der Profile, das ist alles schon geplant"*
11. *"Bitte kartiere auch die gesicherten Memories in den sessions der Diplomarbeit und der cache engine. Bitte lies in beiden repos nach, weil beide zusammengehoeren und erweitere die Analyse, deshalb findest du wohl nichts. Die Memories geben Aufschluss auf Referenzdateien"*
12. **GO-Vergabe (granular):** *"G1"* + *"und G3"* freigegeben; *"Ich gebe G2 frei sofern die Architektur korrekt geplant werden kann"* (bedingtes GO) + *"Wir planen das von Grund auf korrekt neu, wie in der Architektur der Diplomarbeit beschrieben gegen das was wir jetzt wissen"*
13. **BINDEND (Layer-Korrektur #2):** *"laut der Planung der letzten 5 Tage ist die Layer Architektur immer noch falsch, weil sie nichts mit den Projekten zu tun hat"* + *"Bitte finde das top down Konzept"*
14. **BINDEND (Audit-Auftrag):** *"starte bitte einen ultracode workflow, welcher die ab dem 28.06. durchgefuehrten TODOs, besonders die letzten 5 Tage gegen den tatsaechlichen Stand prueft, weil alle Ledger TODOs ohne dieses Wissen als 'erledigt' markiert wurden. Sie wurden mangels fehlendem Wissens wohl gar nicht wirklich bearbeitet"* + *"Dann planen wir"*
15. **BINDEND (Plan-Anspruch):** *"nach den Workflows erwarte ich einen gigantisch elaborierten Plan, welcher der Systemgroesse und Komplexitaet aller Direktiven (insbesondere goal v3 Ledger) entspricht"*
16. **BINDEND (Plan-Ablehnung, 3 Korrekturen):** *"Der Plan ist jetzt sehr gut, aber zu Beginn sollten wir ergaenzend den Bruch gegen alle ab da entstandenen Planungen, Architekturen und Sessions korrigieren und die neueren Dokumente an den urspruenglichen Plan nachziehen und die Namenskollision aufloesen. Erst dann haben wir Klarheit ueber fehlende Aufgaben. Weiterhin finde ich hier keine Referenzen auf die Diplomarbeit/docs/architecture, die mehrere hundert Seiten umfasst. Der Plan ist ebenfalls sehr kurz. Ich hatte eher an ein zusammenfassendes dossier von etwa 20 Seiten gedacht. Wir sind ja in Opus max..."* → danach Plan genehmigt.

**Segment 3 — Goal V3 erweitert (nach 2. Compaction, neue Fassung, bindend)**
17. Goal-V3+ (woertlich, Zusatz gegenueber alter Fassung): *"…Beginne zu allererst aber mit offenen Plaenen und halte stets die Konzeptionelle Grundlage der Durchfuehrung zuerst sauber, bevor du mit einer Aufgabe beginnst. Arbeite so tief wie moeglich und behandle die sichtbare TODO Liste als stack, behebe alle gefundenen Probleme sofort und packe sie als Stack oben auf die sichtbare TODO Liste, bis sie behoben sind."*

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN mit Begruendung

1. **prod2 aus dem CI ausgekoppelt statt "repariert angenommen"** — Begruendung: isolierter Verifikationslauf 9100 belegte `pmc:intel` 345 s Hang im `cmake -B` allein auf prod2, waehrend contract/sanitize/pmc:amd gruen auf prod1 liefen. Kill-Switch `COMDARE_PROD2_AVAILABLE=false` + Runner 17 pausiert, weil fast alle Jobs `tags:[baremetal]` sind und frei auf prod1/prod2 verteilen.
2. **prod2-Root-Cause = i9-14900KS-Degradation** (Runbook-bestaetigt): cmake/cc1plus in permanentem uninterruptible D-state (ueberleben SIGTERM **und** SIGKILL), verstopfen den gitlab-runner-shell-executor → Runner online, nimmt keine Jobs mehr an. Fix nur per physischem Reboot (root, Konsole/Pi5) → Uebergabe an Infra.
3. **#31 war auf der FALSCHEN ARCHITEKTUR-EBENE gebaut** — vier eskalierende Korrekturstufen:
   - Stufe 1: W/D als compile-time `mp_product` widerspricht "Workloads=runtime"; M (Kategorie) ist korrekt compile-time, weil es **Spalten projiziert, keine Laeufe multipliziert** (alle Metriken entstehen gleichzeitig in EINEM POD `ComdareMeasurementSnapshotV1`).
   - Stufe 2: der Bau sitzt in der **Interpretations-Bibliothek (cache-engine)** statt in der **Profil-Ebene (Diplomarbeit)**; WAS/WIE-Grenze fixiert in `STRUCTURAL_CORRECTION_diplomarbeit.md:863-923`.
   - Stufe 3: auch die "4 Teilprogramme" (L1 Diplomarbeit / L2 cache-engine / L3 prt-art / L4 thesis) sind **Projekt-Grenzen, keine Architektur-Schichtung**.
   - Stufe 4 (final, autoritativ): **E1–E4-Experiment-Maschinerie** (28.06., Session-Ende-9 + ce-Kontext-Dossier §12–§17): **E4** XML-Experiment-Definition + Auswertung · **E3** Permutations-B+-Baum pro Gattung · **E2** Tier-Binaries (StaticAxisNode, compile-time) · **E1** RC-Laufzeit (DynamicVariableNode) · **E0** Querschnitt/Infra. Ziel **#229 = XML-only**. → **#31 ist E4-Arbeit.**
4. **Namenskollision aufgeloest** (Begruendung: 3–4 konkurrierende "E/S"-Achsen): **E0–E4 kanonisch behalten/rehabilitieren** (aelteste, code-verankert) · **E-A..E-E → DD-A..DD-E umbenennen** (das "E" bedeutet dort nichts) · **S1–S4** (Schichten-Modell M, invers nummeriert) nicht umbenennen, nur einmalig kreuz-mappen. Live-Verifikation ergab: die Kollision ist **vierfach** (zusaetzlich §13.9-Gate-Labels `E1/E2/E3` + `E2-Sidecar`); "E1-E4" existiert im Ledger nicht literal, nur "E0-E4".
5. **F7-Doc-15 (`super docs/architektur/15_...`) muss neu gefasst werden** — es propagiert den Ebenen-Fehler: `M = compile-time (E0-Modul-Interna, Option A OK)` · `W/Datasets = E4-XML + E1-Laufzeit/E3-Permutation, NICHT compile-time` · `A/B/C x Micro/Makro = E4-Auswertung`.
6. **G2 nicht eigenmaechtig** — committete History wird nicht angetastet ohne GO; G2 erst nach korrekter Architektur-Planung ausgefuehrt (User-Bedingung erfuellt).
7. **Erste "4-Schichten"-Analyse war eine FALLE** — deren 4 Layer (`experiment_tree`/`builder`/`anatomie`/`mess_achsen`) sind **ce-INTERNE Kartierungsachsen EINES Programms**, nicht die 4 Teilprogramme und nicht E1–E4.
8. **Audit-Ergebnis relativiert den User-Verdacht** (Begruendung: Code-Beleg): von ~32 auditierten TODOs **13 echt ebenen-richtig · 8 teilweise · genau 1 schein-erledigt (#31)**. Massen-Schein-Hypothese **widerlegt**; die echten Loecher sind **#229** (Experiment lebt in C++/CMake statt XML), **#215** (offene Wirksamkeits-Schleuse, 320-DLL-Neubau) und **#221** (nur 1 von 5 RC-Achsen wird real konsumiert → Phantom-Zeilen).
9. **V32-Schema-Fork** als Architektur-Gate identifiziert und dem User vorbehalten (nicht autonom entschieden), weil golden-nah + schema-strukturell.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS

| Paket | Ergebnis | Commits |
|---|---|---|
| prod2 KRANK-Zweig | Variable false, Pipeline 9100 gecancelt, Runner 17 pausiert | super `08bfce5` |
| 4-Layer-Workflow-Backup (Rohdaten + journal + result 77k) | gesichert | super `8756ae4` |
| diag-Job eingefuegt / gehaertet | temporaer | ce `ad4ae24d` |
| diag-Job entfernt, sauberer CI-Zustand (timeout:15m + Kill-Switch bleiben) | abgenommen | ce `2f20b8c1`, super `b08db20` |
| Infra-Handover prod2 | uebergeben | cluster `c561d85` (`comdare-cluster-development`, main) |
| Architektur-Workflow-Backup (8 Agenten, 773k Tokens, SYNTHESE.md 17k) | gesichert, gitlab+github | super `844d3f8` |
| Top-down-Workflow + Memory-Kartierung Backup | gesichert | super `f92e7d9` |
| E4-XML-Explorer + Regime-Idee-Referenz | gesichert | super `a219605` |
| **G1** (uncommitteten #31-Fehl-Bau reverten, WT-only) | **erledigt**, ce sauber auf `2f20b8c1` | — |
| TODO-Audit-Backup (7 Agenten, >1 Mio Tokens) | gesichert | super `157a3d6` |
| 3 Architektur-Kartierungen Backup | gesichert | super `33c89d4` |
| **~20-Seiten-Dossier** als `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` | **genehmigt + committet**, gitlab+github | super `a5b9066` |
| Memories geschrieben | `project_e1_e4_experiment_maschinerie_und_konsolidierung.md`, `feedback_elaborate_dossier_fuer_komplexe_planung.md`, MEMORY.md-Index | — |
| **Phase 0** (E0-E4-Konsolidierung, 8 Doku-Dateien, **96 insertions / 0 deletions**, rein additiv) | **VOLLZOGEN + CI-gruen (super Pipeline 9149 = success)**, beide Remotes | super `b4d7d3d` |
| **Phase 0.5 / G2** (forward `git revert` von `88738285` + `4d8aedce`) | lokal gruen: **3/3 Striktheits-Guards PASSED** (metaprog/axes/abi_pod), golden-Datei git-unberuehrt, reconfigure rc=0; gepusht beide Remotes; **CI lief noch** | ce `8c73ef7c`, super-Submodul-Bump `f01bdaa` |

Tasks: #53–#58 (prod2-Stack), #59 (Einlese), #67 Phase 0, #68 Phase 0.5/G2, #69 Phase 4/#31, #70 Roadmap.

---

## (d) FEHLER + FIXES

| Fehler | Fix |
|---|---|
| Annahme "prod2 geheilt" (User-Aussage) | isolierter Verifikationslauf 9100 → KRANK bewiesen; Kill-Switch + Runner-Pause |
| SSH als `admin-management` per Key: Permission denied | Zugang ist Passwort-basiert (Vault, file-to-file, md5-verifiziert, **nie geechot**) |
| `sshpass` fehlt, `paramiko` fehlt | `pexpect` genutzt |
| SSH-Login gelingt, Shell antwortet danach nicht ("server not responding") | SSH als Diagnoseweg aufgegeben → CI-diag-Job als Vehikel |
| `COMDARE_PROD2_DIAG` nie erstellt (curl PUT-Fallback 404) → diag-Job lief nie | explizites POST-Create |
| `diag:prod2` pending (Slot-Konkurrenz, concurrency=2) | Konkurrenten gecancelt + `needs: []` |
| diag-Job brach an `ls /home/gitlab-runner/.ccache` via `set -e` ab | `set +e` |
| `ps -o wchan` haengt selbst am D-state-Prozess | `/proc/PID/syscall` + `grep State /proc/PID/status` |
| `$CMPID` war die Subshell, nicht cmake | host-weite g++/cc1plus-Liste als zuverlaessiger Befund |
| Erste stale-Mount-Hypothese | **widerlegt** (mount/df/free/ls <1 s, kein S3/NFS/FUSE, 15 G RAM frei) → auf cmake-Kind-Prozess eingegrenzt |
| Workflow-JSON-Extraktion fand Keys nicht (`synthese_chars=0`) | Output ist Wrapper: `data = top.get("result", top)` (extract_wf_generic.py) |
| **#31 auf falscher Ebene gebaut (MAJOR, 4× user-korrigiert)** | E1–E4 gefunden; G1-Revert; #31 → E4-XML |
| Erstes 4-Schichten-Dossier = Falle (ce-interne Achsen) | vom Audit explizit als "FALLE" markiert; autoritativ = E1–E4 |
| Erster Plan zu kurz, ohne `docs/architecture`-Bezug | 3 Explore-Kartierer ueber ~170 Seiten → ~20-Seiten-Dossier |
| Annahme "Doc 15 = measurement-all-Migration" | **falsch**: "Option A" = Doku-25-Modul-Split (Ledger:40); gated = **Schritt 13** (`comdare-workloads/README:28-29`); ein literales "Doc 15" existiert nicht |
| Annahme "8 Audit-Befunde" | tatsaechlich **7** (B4-1/-2, B3-1/-2, B2-1/-2, B1-1; kein B1-2) |
| Annahme Kollision dreifach, Zeilen `407-413` = §13.4 | live korrigiert: **vierfach**; `407-413` ist **§13.3**, §13.4 = `:423`, §13.12 = `:538` |
| Mojibake-Grep meldete 3 Treffer | verifiziert als **False Positives** (LEDGER:551/:565, Dossier:187 dokumentieren das Pruefmuster selbst) |
| `ninja: error: unknown target 'test_profile_roundtrip'` | `test_profile_roundtrip.cpp` ist **kein** ctest-Target (Teil des m3v2-Harness); golden-Konsument in der Standard-Suite = `test_striktheit_metaprog_guard` |

---

## (e) OFFENE FAEDEN AM CHUNK-ENDE

1. **G2-Pipelines laufen noch** — ce **9153** + super **9154** `running`; Background-Monitor (Heartbeat) aktiv, terminaler Status noch unbestaetigt. Phase 0.5 ist erst **lokal** gruen abgenommen.
2. **Task #69 / Phase 4 (#31 in E4-XML) am Architektur-Gate — GO ausstehend.** Der V32-Fork wurde durch Live-Verifikation geschaerft:
   - `m3v2_study.profile.xml:128-131` hat `<workloads>A–F`; **`<datasets>` + `<measurement_categories>` fehlen**.
   - Hartkodierter Workload an **vier** Stellen: `main.cpp:135/140/145/483` (nicht nur :483).
   - **`COMDARE_V32_ENABLE` inkonsistent:** `CMakePresets.json:14` (`_base`) = ON und alle Presets erben es → effektiv ON; `02_messung_driver/CMakeLists.txt:22` `option(... OFF)`. **Aber:** `main.cpp` inkludiert `v32_orchestrator.hpp` nie und nutzt das Makro nie → Driver-Binary ON vs. OFF **byte-identisch**; V32 ist im Produktionspfad **toter Code**.
   - **Vierter, bisher unbenannter Befund:** `load_messreihen` liest **keines** der drei Kandidaten-Schemata, sondern ein **viertes minimales Ad-hoc-Regex-Format** `<comdare_messreihen>` (`main.cpp:167-204`, `MessreihenSpec` = nur id/mode/sota_profiles). `comdare_experiment` (config_a/b/c) ist **vestigial/tot** — von keinem Code konsumiert.
   - `v32_orchestrator.hpp`: `execute_messreihe()` (81-85) = **Stub**; `submit_to_builder()` (75-78) = **leer**; funktional sind nur `run_default_lookup_messreihe`/`execute_one_permutation`/`run_messreihe_for_op_type` — aber **keine liest V32-XML**.
   - **Der Explore-Agent-Report bricht mitten in "Frage 3 — Die zwei Fork-Wege" ab** (Chunk-Grenze); Option-V32-Dateiliste unvollstaendig.
3. **Task #70 Roadmap (gated/increment):** #188 (E2-Wurzel, `search_organ_`-Entfall, [in_progress]) → #221 (E1: 4 fehlende RC-Konsum-Setter thread_count/pool_budget/batch_size/inline_threshold + hw_prefetcher kein POD-Feld → sonst Phantom-Zeilen) → #223 (E3-Gate) → #215 (320-DLL-Neubau, Wirksamkeits-Schleuse, mehrtaegig) → #156/#162 (HELD).
4. **prod2 #54–#57 blockiert** — wartet auf physischen Infra-Reboot; danach uebernimmt der Agent §3–§5 (Probe-cmake → Runner 17 entpausieren → Variable true → `pmc:intel` gruen). Blockiert mit: #28/#270a, #175/#207, Intel-Bein von #276/#13, #156-HELD-Kette.
5. **Phase-0-Restposten:** F7-Doc-15-Neufassung ist als §0-Korrekturbox gesetzt, aber die vollstaendige inhaltliche Neufassung sowie der Ledger-Nachzug weiterer Stellen sind additiv-fortzufuehren.
6. **Stehende Pflicht:** alle Workflow-Rohdaten + Ergebnisse weiterhin nach `super docs/sessions/backups/` sichern (User 2× explizit).

**Sicherheits-Constraints (unveraendert in Kraft):** Cluster/Runner read-only (Infra = Handover); Secrets nur file-to-file, **nie** geechot; GitLab-API nur mit ROOTCA-Cert, nie `-k`; nie `git add -A`; golden/ABI/permutation_axes/GenusBindingTraits TABU ohne GO (ABI-MAJOR==4, kein Bump); kein Push waehrend laufender Proof-Pipeline; AskUserQuestion nie (Forks als Klartext + ExitPlanMode).