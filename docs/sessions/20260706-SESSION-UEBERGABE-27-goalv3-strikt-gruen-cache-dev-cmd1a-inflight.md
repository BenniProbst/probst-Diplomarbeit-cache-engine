# SESSION-ÜBERGABE 27 — 2026-07-06 (comdare@prod1) — GOAL V3 aktiv · Strikt-Grün-Strecke · Cache→dev · CMD-1-a IN-FLIGHT
**Agent:** Claude Fable 5 (ultracode) + Codex gpt-5.5 (nur Erstimplementierung). **Nächste Session: direkt nach compact weiterarbeiten — §1 IN-FLIGHT zuerst!**

---

## §0 PFLICHT-EINSTIEG (Reihenfolge)
1. **Ledger** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: **§13.12 = GOAL-TEXT V3 (AKTIV, ersetzt §13.4-V2)** mit kodifizierter Vorrang-Regel (neueste Aussage gewinnt, User schlägt Ableitung) + §12-Einträge vom 06.07. (unten chronologisch) + §9-Doktrin-Block. Board = 21 Tasks (TaskList), Task-Stände aktuell.
2. Dieses Handover (§1 IN-FLIGHT, §4 Fallstricke).
3. Ist-Verifikation: `git status/log` super+ce+prt-art (unpushed-Stände s. §1.3!) + Pipeline-Status (s. §1.1).

## §1 IN-FLIGHT (bei Kontext-Ende laufend!)
### 1.1 Pipelines (Monitor `bz6vx4k0f`, 10-Min-Takt, meldet nur Änderungen — ggf. neu bewaffnen)
- **super 8066** (API-getriggert auf `691f2b8`): running — eigene Jobs weitgehend grün; wartet auf **Bridges** (strategy:depend): 8067 ce-Kind (running, contract-Kette), **8068 prt-Kind SUCCESS ✓**, 8069 thesis-Kind (running). 8066-Grün = Beweis für #258/build:clang-Fix → **Task #1 abschließen + Ledger-Endstatus-Doku**.
- **ce 8070** (Beweis für `aeb27b88` Treiber-Fixes): pending. **prt-art 8071/8072** (main/development `642540d`): pending.
- Bereits bewiesen heute: **ce 8058 SUCCESS** (#265-a Vendoring), prt-art 8054/8050, 8047-dev nach 1×Retry.
### 1.2 Codex CMD-1-a LÄUFT im Hintergrund (Task-ID `bapw7j2fc`, Output `/tmp/claude-1001/.../tasks/bapw7j2fc.output`)
- Prompt: `scratchpad/cmd1a_full_prompt.md` (= Auftrag + volles Dossier). Schreibt UNCOMMITTED in den **ce-Working-Tree**: neu `libs/cache_engine/topics/axis_command_base.hpp` + `tests/unit/test_cmd1_a_axis_command_base.cpp` + additiver Block in `tests/unit/CMakeLists.txt`.
- **NACH Codex-Ende (Pflicht-Kadenz):** VOLL-REVIEW Zeile für Zeile (Metaprogrammierungs-Linse: NUR Templates/if-constexpr/requires, keine virtuals!) → Mojibake-grep → clang-format-22.1.8 dry-run (`~/tools/cf22-extract/usr/lib/llvm-22/bin/clang-format`) → eigener Build+ctest im Scratchpad (`build-da-tests` existiert; besser frisches ce-Build `cmake -B build-cmd1a -G Ninja -DCOMDARE_BUILD_TESTS=ON`) → Fehler MANUELL fixen (nie Codex) → Commit erst NACH Beweisen der laufenden Pipelines.
- Dossier: `docs/sessions/20260706-DOSSIER-267-cmd1-compile-time-command-visitor-fuer-codex.md` (TABUS §0 beachten; CMD-1-b/c/d folgen seriell).
### 1.3 UNPUSHED lokale Commits (Push-Sperre bis Familien-Grün; dann ALLES pushen)
- **super 12:** `34e425a`(ci.skip-Korrektur) `bea6e7b`(CMD-1-Dossier+Refresh-Rohdaten) `a3ad769`(6-Kerne) `fe94eca`(test:unit HART) `36e243f` `ce30e11` `ba952d9`(Ledger V3-Serie) `8e234a6`(#276-Matrix) `9e09cca`(Submodul-Bumps ce aeb27b88 + prt 642540d) `5648774`(#277-Lazy-Rules) `d274db9`(ccache-Sync) `a37c198`(Ledger) — Reihenfolge beachten: Push löst neue kumulative super-Pipeline aus = nächster Beweis (inkl. test:unit ERSTMALS automatisch+hart!).
- **ce 1:** `784b9ac4`(ccache-Sync). **prt-art 1:** `6741f5b`(ccache-Sync; danach main+development beide Remotes pushen!).
- **Push-Reihenfolge:** erst Submodule (ce, prt-art), dann super. prt-art: main UND development, origin UND github. ce/super: origin+github.

## §2 HEUTE ERLEDIGT (mit Belegen; Ledger §12 hat die Voll-Fassung)
1. **GOAL-TEXT V3 =§13.12 AKTIV** (ultracode-Audit wf_4a092c79: 58 Korrekturen/7 BLOCKER, 27 geschlossene Punkte; Rohdaten `20260706-goalv3-audit-rohdaten/`; Supersedierungs-Marker an §13.3/13.4/13.6/13.7/13.8). Einziges offenes Alt-Gate: **Q2 config-Owner**.
2. **#265-a DONE** (ce `80bfab51`, Pipeline 8058 SUCCESS): comdare::platform+simd byte-identisch vendored (`libs/common/platform/vendor/`, REPOS_OVERVIEW mit SHAs 511fca5/7f0039f), entsperrt #270b.
3. **#258/build:clang-Fix** (super `07447f1`): Sammel-Target `comdare_da_tools`; lokal clang-22 61/61 EXIT 0; CI-Beweis = 8066 (in-flight).
4. **Test-Grün-Strecke** (super `fe94eca` + ce `aeb27b88`): test:unit manual→AUTOMATISCH+HART, Scope `comdare_da_unit_tests`+`-L da_unit`; 5 Alt-Fails+1 Skip-Maskierung manuell gefixt (15→16-Spalten-Fixture, kanonische Parser-Tags, INV-4-Missing-Dir, output_dir-Materialisierung, Source-Dir-Fallback statt GTEST_SKIP); **literal 103/103**; ce-Regression test_experiment_driver_v13 Passed.
5. **Runner-Mandat:** prod1 `concurrent=2` (live, Parallelität bewiesen) + `CMAKE_BUILD_PARALLEL_LEVEL=6` in 3 Repos; **node7 reaktiviert+enabled** (Stale-Wurzel!); node5/6/8-Befund + WoL-Versuch; V60-Kartierung; K87-Doku + **K87-INFRA-HANDOVER H1–H9** (mit User ab Montag/NIC).
6. **#277 Lazy-Caching:** ccache 4.9.1 + Launcher im Runner-Env (live); super-Lazy-Rules (Trigger nur bei Submodul-Pointer-Änderung, format/static nur bei Code-Änderung, api/web immer voll); ccache-Bestand→dev via cache:-Sync (3 YAMLs, lokal).
7. **[TOP-PRIO] Cache-Vereinheitlichung prod1 DONE:** runners.cache prod-MinIO→**dev-MinIO** `minio.comdare.de:9000`/`buildsystem-cache` (Creds: Vault `comdare-database`+Split-1/4, **Round-Trip 200/200/204**; hosts-Pin auf V60-VIP 10.0.60.1, DNS zeigt V10 ohne 9000-FE). prod2 = Montag. K87 §7.
8. **Doktrin-Verankerungen** (beide Ledger + Memory): Metaprogrammierung Modul-intern erlaubt/zwingend; Products+Research(=early Products) = eigene Instanziierungs-Matrix, binary-only nach außen; Quellreferenz-Pflicht; „sauber"-Definition; Codex nur Erstimplementierung; Pipeline strikt grün; **kein allow_failure in harter Pipeline (#278)**; Tests nie manual (#12 Skip-Audit).
9. **#274-Migrationsplan-ENTWURF** (16 Schritte, G1–G12, 14 Fragen; ADDENDUM Research-Instanziierung) + **#276-Voll-Matrix** (39 Zeilen Arch×OS×Docker×**Compiler g++≥15.3+clang**, 13 Stufen) + **CMD-1-Dossier** (a–d, HEAD-Refresh wf_d56a6d5b).
10. **Nachreview Nacht-Commits komplett** (19 ce + prt-art): 0 Korrekturbedarf, keine compile-time→runtime-Degradation.
11. **Odroid-Prüfung (User-Verdacht):** Odroids nehmen KEINE Diplomarbeits-Jobs (Tag `bare-metal`≠`baremetal`); alle 51 Jobs liefen auf prod1. Kein Pausieren nötig; Odroids für #276-Vollbuild eingeplant (notiert).

## §3 NÄCHSTE SCHRITTE (Reihenfolge)
1. Monitor-Ergebnis 8066-Familie abwarten → bei Grün: **Task #1 DONE + Ledger-Endstatus** → **Pushes gemäß §1.3** → neue kumulative Pipelines beobachten (erste echte Prüfung von: test:unit-hart, Lazy-Rules, ccache-dev-Sync!).
2. Codex-CMD-1-a-Ergebnis: Voll-Review → manuelle Fixes → doppelt-literale Verifikation → Commit/Push nach Beweis → CMD-1-b (Dossier §2).
3. Danach V3-Reihenfolge: 265-b → #266 (Q2-Gate!) → AP-2-neu → #269/#244+#184 → #270b; parallel #278-58er-Strecke + #12-Skip-Audit; user-gated: Task #18-Sammel.
4. **Montag:** K87-H1 prod2 (NIC, Runner-Trio, runners.cache→dev, etcd 3/3) + H2–H8 mit User.

## §4 FALLSTRICKE DES TAGES (alle real getroffen)
- **ci.skip-Pipelines lösen auto-cancel der NOCH NICHT GESTARTETEN Jobs aus** (8053-Beleg; skipped-Jobs nicht retrybar, Pipeline-Retry requeued sie nicht → frische API-Pipeline `POST /projects/:id/pipeline?ref=main`). Regel: während Beweis-Pipeline KEINE Pushes aufs selbe Repo. Downstream-(pipeline-source)-Kinder sind vom auto-cancel ausgenommen.
- **Tag-Mismatch** `baremetal`(Jobs) vs. `bare-metal`(Odroids) — schützt aktuell, aber bewusst dokumentieren bei #276-Runner-Zuweisungen.
- **dev-MinIO-S3 nur via V60-VIP** (10.0.60.1:9000); DNS zeigt V10 → hosts-Pin nötig; AccessKey=`comdare-database` (NICHT admin).
- `grep -c` mit 0 Treffern = Exit 1 (bricht &&-Ketten); typografische Anführungszeichen brechen Python-Heredocs (`"` beendet String); Python-replace-Spannen exakt eingrenzen (make_small_workload-Löschung als Lehre — git diff prüfen!).
- ssh-Cluster-Keys: `keys/cluster` = passphrase-frei (CRLF-Konvertierung!), `keys/id_ed25519` verschlüsselt, `keys/***CRED-NAME-REF:***CRED-NAME-REF:node8_direct******` frei; **root@localhost via cluster-Key funktioniert auf prod1** (= Runner-Config-Zugang ohne sudo-PW).
- XmlConfigParser sucht `<cache_engine_permutation>/<search_algorithm>/<allocator_permutation>/<test_data_set>` (KEINE self-closing Tags); parse_csv verlangt 16 Spalten (workload_used Spalte 4).
- gtest_discover_tests → ctest-Namen sind gtest-Case-Namen → Suite-Filter über **LABELS** (`da_unit`-Muster), nicht -R auf Target-Namen.
- Runner-Env vs. YAML-Variablen: Kollisionen vermeiden — Launcher global im Runner-Env, CCACHE_DIR/MAXSIZE in YAML.

## §5 ARTEFAKT-VERZEICHNIS (heute)
Ledger §13.12 (V3) · `20260706-274-MATRIX-MIGRATIONSPLAN-ENTWURF.md`(+ADDENDUM+Rohdaten) · `20260706-276-VOLL-PLATTFORM-MATRIX.md`(+Rohdaten) · `20260706-DOSSIER-267-cmd1-...md`(+cmd1-refresh-rohdaten) · `20260706-goalv3-audit-rohdaten/` · Cluster: `K87-RUNNER-FLEET-...md` §1–7 + `K87-INFRA-HANDOVER-RUNNER-FLEET-MIT-USER-...md` (H1–H9; H10 in K87 §7 erledigt für prod1) · comdare-db-Ledger Standing-Direktive (Doktrin) · Memory: Doktrin-Präzisierungen 1–3, sauber-Definition, allow_failure-Verbot, ci.skip-Lektion in Task #6-Metadata.
