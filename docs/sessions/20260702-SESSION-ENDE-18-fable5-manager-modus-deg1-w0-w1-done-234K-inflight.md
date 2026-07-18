# SESSION-ENDE-18 (KONTEXT-ENDE 2026-07-02) — Fable-5-Manager-Modus etabliert · PHASE V + DEG-1 + W0/W1 DONE · 234-K IN-FLIGHT

> **Agent:** Implementierungs-Agent (cache-engine, autonomes /goal) · **Vorgänger:** SE-17 (`…SESSION-ENDE-17-…`).
> **Diese SE-18 = finaler Stand bei Kontext-Ende.** Die Session hat (a) PHASE V pipeline-erfüllt, (b) DEG-1 behoben,
> (c) den Fable-5-Manager-Modus (Codex implementiert, Claude korrigiert) etabliert und 3 volle Zyklen gefahren,
> (d) per ultracode-Workflow ALLE TODOs zu einem Wellen-Plan rekombiniert und die Task-Liste aktualisiert,
> (e) die Rollen-Trennung Impl↔Infra verankert + Infra-Handover geschrieben, (f) W0+W1-Kopf abgeschlossen und
> **234-K als Codex-Lauf GESTARTET (bei Kontext-Ende NOCH IN-FLIGHT — §8 ZUERST LESEN!)**.

## §0 HEADs / Status (alle beide Remotes synchron)
- **cache-engine `main` = `b8761f0`** (#230 Harness-Gate). Arbeitsbaum bei Kontext-Ende SAUBER bis auf
  untracked `.claude/` (Hook-Artefakte, NIE committen) — ABER: ein `codex exec`-Prozess (234-K, workspace-write)
  lief noch → der Baum kann bei Session-Start MODIFIZIERT sein (§8).
- **super = `968a0f9`** (+ diese SE-18/Dossier-Commits danach). thesis/diplomarbeit-Submodul unberührt.
- Grüne Referenz-Pipelines (literal): **7372** (`e064c49`, PHASE V), **7377** (`46e6ce6`, DEG-1 inkl.
  contract:pool_flip), **7387** (`b8761f0`, ERSTER contract:harness-Lauf grün).
- Commit-Kette dieser Session (cache-engine): `e064c49` (13 LF-Locks) → `46e6ce6` (DEG-1) → `b8761f0` (#230).
  Davor (Vortag, PHASE V): `d8c2599`→`14eed39`→`e50dc19`→`e064c49`.

## §1 Session-Chronologie (was geschah)
1. **PHASE V abgeschlossen** (Auftrag aus SE-17): Der 4b-b1b-container_-Flip ist LITERAL compile+run-verifiziert.
   Weg dorthin = 4 Increments, weil der neue `contract:pool_flip`-Job nacheinander 3 latente Linux-Blocker fand:
   (i) `d8c2599` Compile-Test `test_188_4bbV_pool_adapter_flip_compile` (alle 9 Pool-Familien durch den ABI-Adapter)
   + CI-Job; (ii) `14eed39` fehlende `add_dependencies`-Kante auf die 12 `comdare_paper_*_codegen`-ALL-Targets
   (isolierter `--target`-Build generierte die is_original-Header nicht); (iii) `e50dc19` **is_original
   CRLF/LF-Plattform-Bug** (Validator hashte raw bytes; committete Locks=CRLF-Windows-SHAs, Repo=LF → Linux immer
   MISMATCH → Original*-static_asserts scheiterten; Fix: Normalisierung vor Hash + `--update-lock` +
   `COMDARE_CE_UPDATE_ORIGINAL_LOCKS` + manueller CI-Job `is_original:relock`); (iv) `e064c49` die 13
   regenerierten LF-Locks (relock-Job 191797, 11/13 geändert). **Pipeline 7372 SUCCESS** → PHASE V erfüllt;
   ZUSATZGEWINN: der Linux/ZIH-Messweg ist nicht mehr Habich-blockiert.
2. **Fable-5-Reaktivierung + NEUE ARBEITSTEILUNG (User):** Manager-Modus — Codex implementiert jede Code-Aufgabe
   aus einem sehr ausführlichen Dossier (`codex exec` CLI, da MCP beim Modellwechsel getrennt; codex-cli 0.142.2
   auf PATH), Claude korrigiert präzise; bis 16 parallele Codex NUR für disjunkte Aufgaben; Review-Direktiven
   bleiben. Memory `feedback_codex_implements_from_dossier_claude_corrects` + MEMORY.md-Zeile.
3. **DEG-1 BEHOBEN** (`46e6ce6`, Pipeline **7377** SUCCESS): `for_each_record(Sink)` auf ALLEN 9
   Composed*Search-Organen (iterative Walks der realen Strukturen) + requires-gegatete Hüllen-Delegation +
   **4-Zweig-Key-Ernte** in `fill_segment_timing_v3` (StoreTraversable | pool_family_&&requires | MementoAxis |
   References via search_organ_.for_each_record=10/11) + Tests (4bb0 paargenau; 4bbV CI-exactly-once-Beleg).
   Erster voller Manager-Zyklus: Codex-Draft 14 Dateien → 3 Claude-Korrekturen ([[nodiscard]] runter,
   requires-Härtung, CI-Beleg) → Review 1 BLOCKER → dokumentierte Masstree-Ausnahme.
4. **ultracode-TODO-Replan** (User-Auftrag; Workflow `wf_37f3adb1`, 14 Agenten, 920k tok): ALLE 45 offenen Tasks
   klassifiziert + zu einem **Wellen-Plan W0–W7 + P-Spuren** rekombiniert (§4). Task-Liste komplett aktualisiert
   (Wellen-Notizen in den descriptions; Plan-Anker in Task #149). 2 Fehlstarts wegen args-Falle (§5.1).
5. **Rollen-Trennung (User):** Impl-Agent bearbeitet AUSSCHLIESSLICH Implementierung; Infra-Wünsche als
   Handover-Session-Doc per PFAD an den parallel laufenden Infra-Agenten. Memory
   `feedback_implementation_agent_delegates_infra_via_k78` aktualisiert. **Handover geschrieben:**
   `docs/sessions/20260702-INFRA-HANDOVER-p-infra-k78-paket-runner-pmc-p0-kette.md` (super `2ad74dd`).
6. **W0 erledigt:** #233 grün-belegt; **#228 DONE** (globale sslverify=false-Ausnahme raus, per-URL sslCAInfo auf
   ROOTCA, ls-remote-Beleg); **#208-Verify: NICHT stale** (bare-metal 19.1.1, aber k8s-runner id1=18.9.0 +
   auto_cancel=disabled → 208-rest ins Infra-Paket); #216-H1 als DEG-1-abgedeckt dokumentiert.
7. **W1-Kopf Teil 1 DONE:** **#230** (`b8761f0`, Pipeline **7387** SUCCESS): `test_harness_compile` +
   `contract:harness` — Host-Treiber-Stack (iterator/perm_runner/experiment_tree/result_ingest/
   workload_orchestrator/pmc_source_factory) erstmals CI-compiliert + seiteneffektfreier Smoke. Codex-Draft
   diesmal KORREKTUR-FREI (Claude-Verifikation: 30+ Symbole 100% real; Review SHIP ohne Befund).
8. **234-K vorbereitet + GESTARTET:** Doppel-Recherche (Explore+Codex-Pair, konvergent) → 5 Design-Festlegungen
   (§2.4) → Dossier finalisiert (persistiert: `docs/plaene/20260702-DOSSIER-234K-node-shape-achsen-kopf-fuer-codex.md`)
   → `codex exec` workspace-write GESTARTET — **bei Kontext-Ende noch nicht fertig** (§8).

## §2 ARCHITEKTURKONSOLIDIERUNGEN dieser Session
1. **Manager-Workflow-Muster (etabliert, 3 Zyklen gefahren):** Sehr ausführliches Dossier (Auftrag, verifizierte
   file:line-Fakten, SOLL-API, Verbote, DoD) → `codex exec --sandbox workspace-write` im Repo (Hintergrund) →
   Claude liest Bericht + VOLLEN `git diff` + verifiziert jede verwendete API per Grep gegen reale Header →
   präzise Korrektur-Edits → adversarischer `codex exec --sandbox read-only`-Review → BLOCKER fixen → eigener
   Commit + beide Remotes + Pipeline-Poll (Hintergrund-Skript). Reviews IMMER; Codex nie vorbehaltlos.
2. **is_original ist PLATTFORM-NEUTRAL** (Habich-Compliance intakt): Validator normalisiert CRLF/lone-CR→LF vor
   dem Hashen; fehlender Lock-Eintrag im Normal-Modus = MISMATCH (kein stilles true); Locks = LF-SHAs committet.
   Regenerierung NUR über den manuellen CI-Job `is_original:relock` (Artefakt herunterladen + committen).
3. **Key-Ernte-Architektur:** per-op-Segment-Timing-Keys kommen jetzt je Population aus der RICHTIGEN Quelle
   (flacher Store | natives Pool-Organ | Wrapper-Memento | Reference-Hülle); Organe tragen `for_each_record`
   als exactly-once-Walk der realen Struktur (KEIN Schatten-Log — Anti-Pattern).
4. **Shape-Achsen-Design (5 Festlegungen für 234-K/F1-F4):** (i) Hybrid-Muster: Achsen-Anlage wie
   `axis_01_page_type` (je Achse eigenes Verzeichnis/Registry/flags.in/CMake-Block, AUSSERHALB der 19 Slots),
   Varianten Default-OFF wie per-K `7c1f444`, **Level 0 = Ist-Shape Default-ON** (0-Fanout-Riegel!); (ii)
   Durchreichung: Pool-Store-Template-Param mit Default=Level-0-Strategie + kopf-owned `tier_to_organ_mapping`
   (+`*OrganShaped<Shape>`-Aliase); abi_adapter/Hülle/organ_for_search_algo UNBERÜHRT; (iii) BST-Dimension =
   Index-/Zeiger-Packing (size_t/u32/u16); (iv) Bit-Neutralität als Kontrakt (Default-Build identisch); (v)
   Build-Variant-ABI-Erweiterung (POD/Reader/Inspection/Emitter) = BEWUSST deferred → eigener Increment **234-V
   nach F1-F4** (Messbarkeit läuft über Baum-Dimension/binary_id, nicht den 19er-POD).
5. **Wellen-Plan als verbindliche Ordnung** (§4) — Eisenregeln: abi_adapter max 1 offener Increment; alles
   binary-wirksame VOR #215; ab #215-Grün Quell-/Umgebungs-FREEZE bis M3-Ende.

## §3 ⚠️ DEGENERATIONEN / LIMITs (MARKIERT)
- **DEG-1 (Pool-seg_ns Key-Ernte) = ✅ BEHOBEN** (`46e6ce6`, Pipeline 7377). P-TEXT-Auftrag: Appendix-LIMIT-Eintrag
  als „behoben" AKTUALISIEREN (nicht neu vermerken).
- **DEG-2 (Storage-Achsen T4/T5/T6 der 9 Pool-Familien = honest-0) = ⚠️ OFFEN BY DESIGN** bis F1-F4 die
  Shape-Achsen real machen (+ Tries via T4/T5/T6). #162 NICHT vorher fertig markieren.
- **⚠️ NEU DEG-3 (klein, dokumentiert): Masstree-Reference bleibt bei keys={0}** — `ComposedMasstreeSearch` hat
  keinen `for_each_record`-Walk (deferred Familie, kein Wrapper/kein 320-Binary); Kommentar an Ernte-Zweig 4.
  Nachziehen bei Masstree-Registrierung.
- **⚠️ 234-V deferred:** Shape-Achsen erscheinen NICHT in BuildVariantDefinitionV1/Inspection, bis 234-V läuft
  (bewusst; erst nach F1-F4).
- **⚠️ #216-H2 offen:** stat_*-Reset NACH Load (Mini-Increment, W3, vor #215).
- **Infra-seitig (Handover geschrieben, NICHT selbst anfassen):** k8s-runner 18.9.0; auto_cancel disabled;
  Runner-Stale-Liste; #210-Watchdog muss AN bleiben.
- `.claude/` untracked im cache-engine-Repo = Hook-Artefakte des Orchestrator-Plugins → NIE committen (gezieltes
  `git add` verwenden, kein `git add -A`).

## §4 TODOs / WELLEN-PLAN (autoritativ; Details in den Task-descriptions + #149)
**Kritischer Pfad:** ~~W0~~✅ → **W1: [234-K IN-FLIGHT §8] → dann COMMIT-Zyklus** → **W2: 4×-Codex-Fanout**
F1-BtreeOrder | F2-SkipListShape | F3-BstShape | F4-HashProbeShape (VOLL OA↔chaining; Integration sequenziell
BTree→SkipList→BST→Hash, je std::map-Konformitäts-Gatter) + Seitenspur #221 (EINZIGER abi_adapter-Increment,
RC-Setter/apply1, vor #215) + #193 (nur NEUE Dateien) → **W3 (seriell):** 188-4a-Eytzinger → #211 → #216-H2 →
152a (COMDARE_ENABLE_PMC-Aktivierung) → **W4:** #224 NUR mit User-GO → #229-E2E → **W5: #215 EXAKT EIN
320-DLL-Neubau** (+163-flags) → danach QUELL-FREEZE → **W6: M3** (#165-Vorstufe → #156 GESAMT-LAUF → #162/152b/
163-linux) → W6b (konditionale #179-safe-Pakete) → W7 (Rückstau; Feinplanung = neuer #149-Lauf nach M3).
**P-Spuren:** P-INFRA (Handover-Doc liegt beim User zur Übergabe), P-USER (§10-Gates), P-TEXT (#226 u.a.).
**Nach F1-F4:** 234-V (Build-Variant-Verdrahtung der Shape-Achsen) VOR/мit #215 einplanen, falls die
Shape-Dimension im 320-Baum aktiviert werden soll (sonst bleiben Varianten opt-in-lokal).

## §5 FALLSTRICKE (nächste Session ZWINGEND beachten)
1. **🚫 AskUserQuestion-Tool NIE benutzen** (crasht die User-Session/PowerShell) — Rückfragen/Forks IMMER als
   Klartext im Bericht. (Neue MEMORY.md-Kritisch-Direktive.)
2. **Workflow-Tool args-Falle:** `args` kommt im Script teils als JSON-STRING an (auch bei Objekt-Übergabe/Resume)
   → Scripts IMMER mit `const A = (typeof args==='string')?JSON.parse(args):args` härten.
3. **codex exec-Muster:** `cd <repo> && codex exec --sandbox workspace-write|read-only -c
   'model_reasoning_effort="xhigh"' - < dossier.md`, run_in_background; Worktree VORHER sauber; Bericht steht am
   Output-Ende (grep "tokens used" = fertig). MCP `mcp__codex__*` war getrennt — CLI ist der Fallback-Kanal.
4. **GitLab-API:** Helper `scratchpad/glapi.sh`-Muster (PAT aus git-credential-store, CA
   `Cluster/keys/gitlab-ca-ROOTCA-20260621.crt`, `--cacert --ssl-no-revoke`); Job-IDs via python-JSON parsen
   (sed-`},{`-Split bricht an artifacts-Arrays); Trace-ANSI strippen; Poll-Skripte als Hintergrund-Bash.
5. **0-Fanout-Falle:** gepushte AxisLevel mit 0 enabled-Werten ⇒ binary_count=0 (`axis_reflect.hpp:40-42`) —
   deshalb Shape-Level-0 Default-ON.
6. **AxisLevel-Aggregat-Reihenfolge:** `{axis, values, is_static, variable, block_id}`.
7. **`[[nodiscard]]`-Entscheid:** `for_each_record` bewusst OHNE (Senke=Primäreffekt; Adapter verwirft Rückgabe).
8. **abi_adapter god-header:** max EIN offener Increment; Zeilen-Anker driften (Banner greppen).
9. **golden-320/m3v2:** First-4-EnabledStrategies + axis_03a-Flags NICHT ändern; neue Achsen nur additiv
   ausserhalb; Default-Faktor 1.
10. **is_original:** neue/geänderte Paper-Locks NUR LF via relock-Job; Validator-Normalisierung nicht anfassen;
    ext/** bleibt tabu (auch für Codex — steht in jedem Dossier).
11. **CRLF-Warnungen** bei git add = harmlose Normalisierung. **super-Commits:** nur gezielte Pfade stagen
    (untracked PDFs/thesis/.idea/.claude NIE); push origin+gitlab; NUR MERGE.
12. **Mess-Fenster-Schutzregel** (ab #215-Grün): kein Rebuild/keine Rotation/keine Runner-Eingriffe bis M3-Ende.

## §6 DIREKTIVEN (stehend + neu diese Session)
- **Manager-Modus:** Dossier→Codex implementiert→Claude korrigiert präzise (nie vorbehaltlos); bis 16 parallele
  Codex NUR disjunkt (Dateisätze!); Review-Direktive bleibt (adversarischer codex-Review vor „done").
- **Rollen:** AUSSCHLIESSLICH Implementierung; ändernde Infra = Handover-Doc in docs/sessions + Pfad an User;
  read-only-Verify ok. Text-/Session-Docs → super `docs/sessions/` (nicht Impl-Repo).
- Je Increment: eigener Commit (elaborate Message, `Co-Authored-By: Claude Opus 4.8 (1M context)`), beide
  Remotes, Pipeline-LITERAL-Beleg; nie halb committen; #188-Kette nie brechen.
- Konformitäts-Gatter + SOTA-Adapter je Umbau; Messdaten nie löschen; M3-gated nicht vorziehen (#165/#226/152b).
- Tasks-Liste = User-TODO, STÄNDIG aktuell; Ledger/Memory ZUERST lesen; keine Erfolgsmarke ohne wörtliche Ausgabe.

## §7 ZUGÄNGE / WERKZEUGE
- Repos (je origin=GitHub + gitlab, main, NUR MERGE): cache-engine (Projekt-ID 286) + super.
- GitLab-API: PAT lebend aus git-credential-store (`git credential fill`), CA s. §5.4; Runner-/Pipeline-/Job-/
  Trace-/Artefakt-Endpunkte alle erprobt (diese Session: play für manuelle Jobs, artifacts-zip-Download).
- codex-cli 0.142.2 (`codex exec`); Workflow-Script-Datei
  `…/workflows/scripts/todo-replan-fable5-wf_bc48bcdd-802.js` (gehärtet, wiederverwendbar).
- Aktive Dossiers: **234-K** = `docs/plaene/20260702-DOSSIER-234K-node-shape-achsen-kopf-fuer-codex.md`
  (persistiert; Scratchpad-Kopien können verfallen).

## §8 🔥 IN-FLIGHT bei Kontext-Ende: der 234-K-Codex-Lauf — ZUERST HIER WEITERMACHEN
- Bei Kontext-Ende lief `codex exec --sandbox workspace-write` mit dem 234-K-Dossier (Frühphase, Baum noch sauber).
  Der Prozess kann nach Session-Ende (a) fertig geworden sein → Arbeitsbaum trägt UNCOMMITTETE 234-K-Änderungen;
  (b) abgebrochen sein → Baum sauber ODER teilmodifiziert.
- **WIEDERAUFNAHME-PROZEDUR (Reihenfolge):**
  1. `git -C <cache-engine> status --short` + `git diff --stat` (`.claude/` ignorieren).
  2. Codex-Bericht suchen: Task-Output `…/tasks/b0mxqes2w.output` (falls Session-Verzeichnis noch existiert;
     „tokens used" am Ende = fertig + Abschlussbericht davor).
  3. **Fall A (Diff vollständig + Bericht vorhanden):** normalen Korrektur-Pass fahren — Checkliste: (i)
     Bit-Neutralität der 4 Pool-Store-Signaturen (Level-0-Konstanten EXAKT kT=4 / kMaxLevel=16+p½ / size_t /
     OA+lf7/10; keine Logik-Änderung in insert/erase/rehash/split); (ii) CMake: Level-0-Optionen ON, Varianten
     OFF, 4 getrennte Blöcke+configure_file-Pfade; (iii) `registry_to_axis_levels.hpp` 22→26 konsistent
     (Includes/using/push/binary_count/reserve); (iv) observer_classification 22→26 DefinitionOnly; (v)
     tier_to_organ_mapping: Default-Aliase semantisch identisch + Shaped-Aliase; (vi) VERBOTS-Liste eingehalten
     (kein abi_adapter/organ_for_search_algo/composed_*/Traversal-Organe/tests/CI). Dann adversarischer Review →
     Commit `feat(#234-K)` → Pipeline (contract:harness gated die AxisLevels-Erweiterung automatisch mit!).
  4. **Fall B (Diff unvollständig/Bericht fehlt/Zweifel):** Diff VERWERFEN (`git checkout -- .` nur auf die
     betroffenen Pfade; `.claude/` unangetastet) und den Lauf mit dem persistierten Dossier (§7) FRISCH starten —
     das Dossier ist die Quelle der Wahrheit, nichts geht verloren.
  5. Danach W2-Fanout: 4 Familien-Dossiers schreiben (je Familie: Varianten-Levels real umsetzen im eigenen
     Pool-Store + ggf. Traversal-Organ [Hash: hash_probe_traversal_organ für chaining/lf], organ_observe-Hooks,
     eigener Test; Vorlage = 234-K-Bericht „was F als Nächstes füllt") + **4 codex exec PARALLEL** (disjunkte
     Dateisätze; Integration/Commits danach sequenziell BTree→SkipList→BST→Hash durch Claude).

## §9 START-HIER (nächste Session)
1. Memory `reference_188_4b_pool_family_store_traversable_design` lesen (trägt PHASE-V-, DEG-1- und
   234-K-Design-Abschnitte) + DIESE SE-18 (v.a. §8!).
2. §8-Prozedur: 234-K-Zustand klären → Korrektur-Pass ODER Frisch-Start → Review → Commit → Pipeline-Beleg.
3. W2: 4×-Fanout F1-F4 (+#221-Seitenspur NACH dem Fanout-Start, #193 nur neue Dateien).
4. Parallel im Blick: P-USER-Gates (§10), Infra-Handover-Rückmeldungen (per Pfad vom User).
5. Dann W3 (4a → #211 → #216-H2 → 152a) → W4 → W5 (#215) → W6 (M3).

## §10 OFFENE USER-GATES (P-USER — bitte im nächsten Fenster entscheiden; blockieren W1-W3 NICHT)
1. **#207-Go:** Wartungsfenster prod2-Staged-Rebuild (Kernel→ggf. NVMe-Wipe) → pmc:intel. Längster Vorlauf,
   hartes M3-Gate. (Infra führt aus; Handover liegt bereit.)
2. **#225:** Grundsatz Second-Execution vs Zwei-Phasen-Pflicht — MUSS vor W6/M3 entschieden sein.
3. **#224 GO/NO-GO:** GoF-Renames im W4-Exklusiv-Fenster VOR #215 (GO = finale Namen in den Abgabe-Daten;
   NO-GO = bewusst zweiter 320-Neubau nach M3).

## §11 NACHTRAG (2026-07-02 02:40, zweites Kontext-Ende) — USER-GOs, TIMER, LAUFENDE AGENTEN
**USER-GOs (liegen vor, keine Rückfrage mehr nötig):** (1) 234-K-Teil-Diff OHNE vollständigen Codex-Bericht →
VERWERFEN + frischer `codex exec` mit dem persistierten Dossier (§7); (2) nach 234-K-Grün den **W2-4×-Fanout
F1-F4 DIREKT parallel** starten (ohne Zwischen-Gate); (3) zusätzliche autonome Arbeit erlaubt, soweit
dokumentations-gedeckt ohne User-Entscheid.
**INFRA:** Der Infra-Agent hat das P-INFRA-Handover (§1.5) ERHALTEN — Rückmeldung wird ~4h nach 02:30 erwartet;
Prüfung + read-only-Verify-Slots dann fällig (208-rest Runner/auto-cancel, pmc:intel-Variable, #231 nur nach
Vollzugsmeldung).
**3 CRON-TIMER GESETZT (⚠️ SESSION-ONLY — bei Session-Tod weg; Prompts sind selbsterklärend formuliert):**
- 04:36 `0609089a` — RESUME-WECKRUF: alle unvollständigen Agenten fortsetzen (234-K-Codex fertig→§8-Korrektur-Pass /
  tot→verwerfen+frisch; #206-Recherche prüfen/neu starten; dann W2-Fanout).
- 05:16 `3353026b` — 5h-Limit-Checkpoint: autonom im Wellen-Plan weiter.
- 06:33 `53d859d6` — Infra-Rückmeldungs-Check + Verify-Slots.
**Falls die Timer mit der Session sterben:** dieselben drei Aufgaben manuell in dieser Reihenfolge abarbeiten.
**LAUFENDE HINTERGRUND-LÄUFE bei diesem Kontext-Ende:** (a) 234-K-Codex (`tasks/b0mxqes2w.output`; zuletzt ~346
Transcript-Zeilen, Arbeitsbaum noch sauber) → §8-Prozedur; (b) #206-Gate-Recherche-Agent (general-purpose,
WebSearch; Ziel `scratchpad/206_pipeline_gates_recherche.md` — bei Erfolg nach docs/sessions kopieren+committen,
speist #203/#204/#205).
