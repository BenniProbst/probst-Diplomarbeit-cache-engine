# SESSION-HANDOVER 2026-07-05 — Nacht-Audit · RESTORE · Goal V2 · CI-Grün · S7-1 · AP-7b
**Impl-Agent-Session (Claude Fable 5 + Codex gpt-5.5). Endstand: ce `c9a7e44e` / super `815e2d6`, beide Remotes synchron.**
**AKTIVES GOAL: Ledger §13.4 (GOAL-TEXT V2) — Defaults E-A…E-E mit Aktivierung freigegeben.**

---

## 0. PFLICHT-EINSTIEG NÄCHSTE SESSION (in dieser Reihenfolge)
1. **Ledger** `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — §13 komplett (13.1 Audit-Bilanz · 13.2 Goal-V1-Ursachen · **13.3 TODO-Katalog #253–#272** · **13.4 GOAL-TEXT V2** · 13.5 RESTORE-Vollzug · **13.6 Matrix-K2-Fragen** · **13.7 AP-2-K2-Frage + S5/S6-Nachzug** · **13.8 S7-Forks**). Ledger schlägt alles.
2. **Dieses Handover** (Degenerationen §4, Fallstricke §5 — die kosten sonst Stunden).
3. **Matrix-Grundlagen** `docs/sessions/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md` — NORMATIV für #256/#265/#266.
4. Ist-Verifikation VOR erstem Edit: `git status`/`log` beider Repos + `git ls-remote` origin+gitlab.
5. Audit-Rohdaten (nur bei Bedarf): `docs/sessions/20260705-nacht-audit-ultracode-rohdaten/` (11-Agenten-journal, ADDITIV — nie löschen).

## 1. SESSION-BILANZ (alles doppelt verifiziert, beide Remotes)
| Increment | Commits (ce) | Beleg |
|---|---|---|
| **Nacht-Audit** (ultracode wf_b00c414e, 11 Agenten, 1,1M Tok) | — | 16+ Nacht-Increments GRÜN re-verifiziert; R1: KEINE Git-Schäden; R2: Remotes synchron, alle DONE-Claims commit-belegt |
| **RESTORE #253–#255** (Modul-Remote-Vorfall behoben) | — | GitHub-Web-Restore (User) 6/6 verifiziert · GitLab-Subgruppe `comdare/modules/comdare-cacheengine` (ID 344) + 6 Projekte, **main+development** · Matrix-Klone ff auf Vollstand · 6/6 SHA-identisch |
| **Matrix-Grundlagen** (ultracode wf_86d01d58 über comdare-db-Rohdaten-Backups `_backup-discovery-rohdaten-20260702`) | super `bdaf0fd` | Baseline 0–6 normativ, INV-1..4 wörtlich, Modul-Konsum `source="modules"`+MODULES_ROOT etabliert (Fassaden NUR Produkte) |
| **#257 CI-Grün T1: Format-Pass** | `24dee528` | 1357 Scope-Dateien, 43→**0** Verstöße (clang-format 22.1.8 CI-exakt); 6 vendored HdrHistogram-Originale via `vendor/.clang-format DisableFormat` geschützt (ext/-Muster, NICHT umformatiert); **CI-BESTÄTIGT: lint:format=SUCCESS (Pipeline 7917)** |
| **#257 CI-Grün T2: C-Toolchain** | `c7204af8` | `enable_language(C)` im hdr-Wrapper (CXX-only-Root + vendored .c → 12 Jobs rot an `CMAKE_C_COMPILE_OBJECT not set`; VS verzieh, Linux nicht) |
| **#259 Ledger-Konsistenz** | super `748cd51` | S5=CMD-1-**neutral** (Re-Root VERWORFEN, E-B) · S6=CMD-2 **einziger** Bump-Kandidat (AP-1/AP-8 liefen host-seitig OHNE Bump) · AP-2-Platzierungs-Widerspruch als K2 ausgewiesen |
| **#260 Hygiene** | `fa0c21d0`, super `cf040ee`+`1364f16` | $null weg · ce/modules-Klone ignoriert · CODEX-Doku+2 Paper-PDFs committet · 32M-workflow-backups+.claude+.idea ignoriert |
| **S7-1 (#261)** | `ec1ffb34` | BST-Pool `<Shape,A>` (Default byte-identisch) + T6-Allokator-DEG-Route **honest-0→ECHT** (literal `alloc_cnt=6 bytes=288`); abi_adapter-Naht requires-gated verallgemeinert (feld-adaptiv: 5-Feld-Store UND Pool-Snapshot); golden-roundtrip mismatch 0 |
| **AP-7b (#262)** | `a4e7c59f` + `c9a7e44e` | SwissTable = **10. organ_for-Pool-Familie**: SwissGroupPoolStore/Concept/Probe-Organ (skalar **bit-identisch** zum AP-7a-Wrapper) + ComposedSwissSearch (for_each_record DEG-1) + Flip → S22 misst als ECHTE SwissTable statt SortedBinary-Surrogat; 4bbV/4bb0 9→10; golden mismatch 0; **erster Increment unter der neuen Voll-Review-Pflicht (alle 10 Artefakte gelesen)**. Entsperrt 8. Lebewesen (#162/FF3) |
| Neue Direktiven (Memory) | — | 🚨 Remote-Lösch-Verbot · 👁️ **Codex-Voll-Review-Pflicht** (User 05.07.: JEDES Codex-Artefakt nach Fertigstellung komplett manuell lesen — Claims genügen NIE) |

## 2. REPO-ENDSTAND
- **ce Working Tree:** sauber bis auf `apps/perm_runner/main.cpp` (EOF-Newline, **User-Live-Zone — nicht anfassen**). `modules/comdare-*/` = restaurierte Klone, gitignored, Entscheid A bleibt (entnestet).
- **super:** sauber bis auf 2 dirty-Submodule-Anzeigen (ce=perm_runner; thesis=PDF-Build-Artefakt = **Text-Agent-Zone**).
- **Matrix-System** `Projekte\Modules\comdare-cacheengine-all\`: 6 Klone auf GitHub-Vollstand, origin+gitlab-Remotes live (main+development).
- **Pipelines:** letzter Stand = neue Runde nach `c7204af8`/`c9a7e44e` **pending im Runner-Stau** (#210). lint:format+lint:secrets grün bestätigt (7917); 12 contract/sanitize/chaos-Jobs warten auf den C-Fix-Beweis. **#258 = finalen Status dokumentieren, deterministische Rest-Fehler fixen (lint:static separat bewerten!), NICHT blind re-triggern.**

## 3. OFFENE TODOs (Katalog = Ledger §13.3, Board alignt #253–#272)
- **K1 sofort (Reihenfolge Goal V2):** #258 Pipeline-Nachprüfung → #263 AP-15 std::map-Vertrag (⚠️ conformance-Oracle bleibt `std::map<uint64,uint64>`!) → #264 CI-Ausbau (CI-2/4/5 + #204 sanitize-hart). Reste in_progress: #257 (nur CI-Beweis offen), #261 (S7-2..9 fork-gated), #262 (nur 7b-3 SIMD deferred).
- **K2 nach User-Gates (§6):** #265 Reuse-P2 → #267 CMD-1 → #266 Reuse-P1/P3 → #268 CMD-2-Reserve → #269 AP-10-Daten → #270 AP-13-Rest → #271 perm_runner-Fix → #256 MODUL-EXTRAKT (nach #255 ✅ startbar, measurement zuerst, Schritt 0 = Umbrella-Rahmen).
- **K3/K4:** #272 Infra-Handover-Paket (HO-1..HO-10 aus Audit-A8) · AP-2→#162→#156/M3-Kette · #215/#216 · Alt-Board #10/#19/#24/#25/#125/#149/#152/#156/#162/#163/#165/#179/#184/#185/#186-Reste/#187/#188/#189/#199-#202/#204/#205/#207-#210/#217/#225/#226/#229/#231/#234/#236/#241(7b-3)/#244/#246/#247/#248/#249/#251/#252.

## 4. DEGENERATIONEN — zu beheben bzw. MARKIERT (ehrlich halten!)
1. **honest-0-DEG Pool-Familien:** NUR BST hat die T6-Allokator-Route (S7-1). **8 Familien** (BTree/SkipList/Hash/ART/HOT/START/Wormhole/SuRF + neu Swiss) ohne Allokator-/observe-Hooks; ALLE Scan-Achsen-DEGs (T4/T5/T7, layout/serialization/value_handle/isa/index_org/io/migration/filter) für Pools weiter ehrlich-0 → S7-2..9, **fork-gated §13.8**.
2. **SwissTable:** skalar bit-identisch, aber `supports_simd()==false` ehrlich — SIMD-Gruppen-Probe = 7b-3 (SSE2 `_mm_set1_epi8/_mm_cmpeq_epi8/_mm_movemask_epi8` + SWAR-Fallback; isa-Kopplungs-Entscheid offen); `swiss_probe_shape`-Achse offen (S14 hat axis_hash_probe_shape, S22 fix 7/8+Gruppe16).
3. **AP-2-HART:** PRT-ART weiter unordered_map-Surrogat + 90ns-Stub — blockt #162/#156/AP-12. Platzierungs-K2 (§13.7) entschieden = sofort startbar.
4. **6 Matrix-Module INV-1-verletzend:** kein Umbrella-Rahmen (baseline-Ordner/Root-CMake/Root-buildsystem.xml fehlen), kebab-case-Include statt `include/comdare/<ns>/`, Branch-Konvention, Header-Drift vs. Monolith ungemessen → #256-Schritt-0 + K2-Fragen 1/3/4/5/6.
5. **perm_runner lokaler Build-Bug** (vorbestehend): `experiment_tree/perm_runner.hpp`→`load_profile_parser`→`xml_reader.hpp` nicht auf lean-Include-Pfad; Fix = `libs/common` in `apps/perm_runner/CMakeLists.txt` (#271, **nur wenn Datei nicht mehr user-dirty**).
6. **Bewusste Duplikation** Insert-3-Pass Store↔Organ (BST `insert_rehashed` + Swiss analog) — Rehash-Selbstgebrauch, in Commits dokumentiert; DRY-Konsolidierung optional später.
7. **super-CI rot:** GCC-16-ICE `csv_to_latex.cpp` (-fmodules, Toolchain-Entscheid nötig) + thesis:pdf-Timeout (texlive-Gate #205). **lint:static** rot — nach C-Fix NEU bewerten (evtl. selber Configure-Fehler, evtl. echte cppcheck-Befunde).
8. **keeper-adminmgmt-PAT (Vault Z.277, id=21) = 403 account blocked** — Rotation/Klärung (#272); funktionierend: keeper-root via `~/.git-credentials`.
9. Ledger §2-B6 P-A-Disjunktheit + „16-vs-22-Umbrella-Zählung" + `audit:layering` fehlt im ci-blueprint (nachrichtlich, §13.6-Q8).

## 5. FALLSTRICKE (kosten sonst Stunden — ALLE diese Session real getroffen)
- **clang-format MUSS exakt 22.1.8 sein** (CI-Pin, Alignment versionssensitiv). **Persistent: `C:\temp\comdare\tools\clang-format-22.1.8.exe`** (Scratchpad ist session-spezifisch!). CI-exakte Verstoß-Enumeration: `git ls-files -- libs apps tests adapters benchmark_suite benchmarks | grep -E '\.(c|cc|cxx|cpp|h|hh|hxx|hpp)$' | grep -vE '(^|/)(ext|build|_archive_code_pre_migration|cmake-build-[^/]*|modules)/'` → Batch `--dry-run -Werror --files=<liste>`. **JEDER neue Code-Commit vorher dry-runnen** (lint:format ist hartes Gate).
- **vendored Originale NIE umformatieren** → eigene `.clang-format` mit `DisableFormat: true` je vendor-Baum (ext/-Muster; für hdr_histogram_wrapper/vendor/ schon drin).
- **CXX-only-Projekt + .c-Quelle** → `enable_language(C)` lokal (VS-Generator verzeiht, Linux-CI nicht).
- **windows.h** → immer `WIN32_LEAN_AND_MEAN` **+ `NOMINMAX`** (min/max-Makros brachen `std::numeric_limits::max()` in f15).
- **OneDrive:** `git rm -f` scheitert an FS-Locks → `git rm --cached` + rm; Restores syncen `.git`-Innereien VERZÖGERT (SHA erst leer, später da — nicht als Schaden fehlinterpretieren).
- **User editiert LIVE parallel** (diese Session: perm_runner, AP-13-Test/Header) → vor jedem Edit `git status` der Zieldatei; user-dirty = nicht anfassen, Konflikt im Ledger melden (Goal-V2-Regel).
- **Codex:** legt KEINE fehlenden Verzeichnisse an (AP-13-Lauf scheiterte still an nicht-existentem `builder/measurement/` — mkdir im Dossier nennen o. Pfad prüfen); `$null`-Junk nie stagen; bei build/-Lock weicht es auf %TEMP% aus (ok, aber eigene build/-Doppelbestätigung nachziehen); **NEUE PFLICHT: alle Artefakte voll manuell reviewen**.
- **Bash-Heredoc mit Umlauten/Sonderzeichen bricht** („unexpected EOF") → Write-Tool + `cat temp >> ziel`. **Windows-Python sieht `/tmp` nicht** → Scratchpad-Pfade. **awk-Bereichsmuster** `/^\.lint/,/^\.[a-z]/` matcht Startzeile selbst → grep -A.
- **GitLab:** API via keeper-root (`~/.git-credentials` oauth2) + `--cacert keys/gitlab-ca-ROOTCA-20260621.crt` (NIE -k); auto-cancel räumt überholte Pipelines beim Push (gewollt: EIN Push testet kumulativ); Runner-Stau Stunden-Latenz (#210) — **deterministische Fehler fixen statt re-triggern, Duplikate canceln**.
- **API-Spend-Limit** kann Agenten mitten im Lauf killen → `SendMessage` an die agentId resumed mit vollem Kontext (funktionierte).
- **golden-320:** Datei ist EINGEFROREN (nie regenerieren, zirkulär!); Beleg = `test_profile_roundtrip` mismatch 0; Pool-/S22-Arbeit ist golden-sicher, WEIL Familien default-OFF außerhalb First-4 — **EnabledStrategies/AllStrategies-Ordnung/First-4 nie ändern, neue Strategien nur END-appendieren**.
- **Board-Task-IDs = Ledger-TODO-Nummern** (#253–#272 alignt) — bei TaskCreate Reihenfolge wahren.

## 6. OFFENE USER-GATES (13, je mit Empfehlung — „alle wie empfohlen" genügt)
**Matrix (§13.6, blocken #256/#266):** (1) Baseline-Stufen der 6 = 0/1/2/3/4/4 · (2) config-Owner = **config-all** · (3) Namespace generisch `comdare::<modul>` + Übergangs-Alias · (4) Include-Norm `include/comdare/<ns>/` · (5) Branch main→development · (6) eigenes `comdare-cacheengine-all`-Gruppen-Repo · (7) metrics=generisch / measurement=Messdomäne · (8) nachrichtlich Zählung+audit:layering.
**AP-2-Platzierung (§13.7):** sofort startbar (execution_result-Konflikt seit AP-8 weg) — entsperrt FF3-Kette AP-2→#162→M3.
**S7-Forks (§13.8, blocken S7-2..9):** (a) Threading-Weg = **Trait `organ_for<S,N,L,A>` mit Defaults** · (b) L-Semantik Node-Pools = Node-Backing-Politik ohne Attrappen (je Familie ehrlich „nicht anwendbar" wo nötig) · (c) DEG>0-Nachweis via Unit-Tests + m3v2, nicht golden.
**Plus:** AP-10-Datensatzliste (Termin 7/Datasets_Spezifikation.txt) bereitstellen (#269).

## 7. ARCHITEKTUR-KONSOLIDIERUNGEN dieser Session (neuer Kanon)
- **ABI-Bump-Register korrigiert:** CMD-1 = ABI-NEUTRAL (Re-Root verworfen); AP-1/AP-8 = host-seitig ohne Bump; **einziger 4→5-Kandidat = CMD-2** nach Reserve-Prüfung `axis_stats[0][6..7]` (#268) + expliziter User-Freigabe.
- **Matrix normativ verstanden** (aus den comdare-db-Rohdaten-Backups, doktrin-konform via ultracode): Zelle = header-only INTERFACE + `comdare::<x>`-Alias; INV-2 n→n−1; Modul↔Modul via `source="modules"`; simd setzt platform voraus (immer mitvendorn).
- **organ_for-Trait = 10 Pool-Familien + Eytzinger**; 3-Wege-Split (flat-traversal / organ-backed / deferred) um S22 erweitert, self-proving via static_asserts.
- **T6-DEG-Route verallgemeinert** (requires-gated `store_allocator_statistics()`, feld-adaptiv) — Vorlage für die weiteren S7-Hooks.
- **vendor-Schutz-Muster** (`DisableFormat`) + **enable_language(C)-Muster** für vendored C etabliert.

## 8. VERANKERTE DIREKTIVEN (Memory, gelten IMMER)
🚨 Remote-Repos/Branches NIE löschen/anlegen ohne expliziten User-Auftrag JE Repo; vorher Matrix auf Klone/.gitmodules prüfen; GitHub-Web-Restore-Fenster 90d · 👁️ **Codex-Artefakte IMMER voll manuell reviewen** (Dateien lesen, Diffs Volltext, faithful gegen Referenz — Claims genügen nie) · 🔁 Codex unsicher → ultracode · Doppelt-literale Verifikation (Codex + eigener build/) · Rohdaten STRIKT ADDITIV · keine Attrappen (ehrliche Lücken dokumentieren) · ABI-4-Freeze · golden-320/pipeline16/conformance-Oracle unantastbar · Cluster read-only · AskUserQuestion NIE · granular committen, beide Remotes, Ledger fortschreiben.

## 9. EMPFOHLENER EINSTIEG NÄCHSTE SESSION
(1) Pipeline-Endstand der c9a7e44e-Runde prüfen → #258 abschließen (+ lint:static bewerten); (2) falls User-Gates beantwortet: S7-2 (BTree, Muster S7-1) + #265 Reuse-P2 parallel angehen; (3) sonst K1-Rest #263/#264. STOP-Bedingung des Goals beachten: wenn nur noch K2/K3/K4 → Handover statt Leerlauf.
