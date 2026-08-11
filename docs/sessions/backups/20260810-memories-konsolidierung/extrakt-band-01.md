Bearbeitet: 15 von 15 Dateien aus band_03 (Zeilen 1–15; Zeile 16 war eine Leerzeile, kein Dateiname).

---

## 1. reference_buildsystem_xml_grep_parsed_not_strict_xml.md

**THEMA:** buildsystem.xml literal lesen, nicht XML-escapen
**TYP:** reference

**FAKTEN:**
- Der `buildsystem.xml`-Manifest-Parser (v3.4.15-Manifeste) ist **grep/awk-basiert** (POSIX-Skripte `xml_parser.sh`/`dependency_resolver.sh`), liest literalen Content, entschlüsselt KEINE XML-Entities. — HERKUNFT: AGENTEN-BEHAUPTUNG, Selbst-Catch 2026-07-04, Session c6f15797-7fa1-4e66-874f-55631afe1d28.
- Gotcha real: beim T-03-Fix wurde versucht, `buildsystem.xml` strikt-XML-valide zu machen; `python xml.dom.minidom` scheiterte an `<bootstrap method="shell">cd src && ./make.bash</bootstrap>` Zeile 446 (unescaptes `&&`). — MESSUNG (python-Fehler).
- Agent escapte `&&`→`&amp;&amp;` — das war FALSCH: hätte `cd src &amp;&amp;./make.bash` literal ausgeführt statt den Shell-Befehl. Sofort revertiert via `git checkout`. — AGENTEN-BEHAUPTUNG (Selbstkorrektur).
- REGEL: In `buildsystem.xml` Element-Content literal lassen — kein `&`→`&amp;`, kein `<`→`&lt;`. Strikte XML-Wohlgeformtheit ist KEIN Ziel. Ein künftiger Schema-Validierungsschritt (T-57) muss den grep-Dialekt tolerieren, nicht umgekehrt.
- Was bei T-03 korrekt war: tote `cmakePackage>BEPBuildSystem` + nicht-existente `<module>`-Refs → reale `ComdareBuildSystem.cmake`/`BuildSystemMaster.cmake`/`BuildSystemCore.cmake` (Content-Korrektur, kein Entity-Escaping).

**STAND:** GILT (Architekturfakt, keine Korrektur im Dokument).

**VERWEISE:** `[[reference_buildsystem_scripts_posix_no_grep_p]]` (nicht im Band — vermutlich existierende, eigenständig unverlinkte Datei zum selben grep-Parser-Kontext; Cluster-Kandidat).

---

## 2. reference_ce_jkette_n316_braucht_v32_enable_on.md

**THEMA:** ce-ctest-Gate-Zahl ist lebend, nicht fix
**TYP:** reference

**FAKTEN:**
- **N=316** für ce-Voll-ctest (comdare-cache-engine, Stand `be827881`, 27.07.2026) setzte `-DCOMDARE_V32_ENABLE=ON` voraus; Default-Configure (OFF) zählte nur **312**. — HERKUNFT: MESSUNG (`ctest -N`-Mengen-Diff frisches Dir vs. Referenz-Build-Dir `build-ninja-s4`, einziger CMakeCache-Unterschied war die Option).
- Die 4 fehlenden V32-gegateten Tests bei OFF: `f15_compare_cli_smoke`, `test_184_dataset_loader_wiring`, `test_25_kanon_dataset_akten`, `test_v41_anatomy_adhoc_autobuilt_load`.
- J-1-Werkzeug-Targets tragen alle `comdare_`-Präfix: `comdare_adhoc_emitter_cli`, `comdare_catalog_codegen_cli`, `comdare_anatomy_codegen_cli`, `comdare_gen_golden_fullpilot`, `comdare_{,measurement_,system_}axis_registry_gen`. Kurzformen ohne Präfix sind teils nur phony-Aliase; `adhoc_emitter_cli` existiert gar nicht.
- EBENEN-FALLE (27.07., Task-#7-P1): Die Gate-Zahl zählt ctest-EINTRÄGE (Test-Binaries), NICHT gtest-Fälle. Ein Test-Binary mit 8 `TEST()`-Fällen hebt das Gate um 1 (317→318), nicht um 8. Prüfen mit `ctest -N | tail -2` ("Total Tests: N") bzw. Zeile `<i>/<N> Test #<id>: <name>`.
- **NACHTRAG 03.08.2026** (Gegenlese D-01, Verify-Befund 01.08., FAHRPLAN:42-53): Die J-Ketten-Zahl ist KEINE eigene Zählung, sondern das LEBENDE ctest-Gate — Progression **312→314→316→317→318→…→331** (Stand 03.08.2026). `COMDARE_V32_ENABLE` gated dem Nachtrag zufolge **KEINEN Test** (einzige Wirkung: Option + INTERFACE-Define); V32=ON bleibt nur als CI-Kanon. **Der Titel-Wert N=316 ist historisch.**

**WIDERSPRUCH (im selben Dokument, beide Seiten nennen):** Der ursprüngliche Fakt (27.07., MESSUNG) behauptet, `COMDARE_V32_ENABLE=ON` sei ursächlich dafür, dass 4 bestimmte Tests überhaupt gezählt werden (OFF→312, ON→316). Der NACHTRAG 03.08. (spätere Gegenlese) behauptet, die Option gate **keinen** Test. Beide Aussagen stehen im selben Dokument, nacheinander, ohne dass der Nachtrag den ursprünglichen Messbefund explizit auflöst — es bleibt offen, ob sich zwischen 27.07. und 03.08. der Code geändert hat (die 4 Tests wurden ggf. anders gegatet) oder ob die ursprüngliche Kausalzuschreibung schlicht falsch war.

**STAND:** UEBERHOLT — N=316 ist historisch, die aktuelle (03.08.) Zahl ist Teil einer fortlaufenden Progression bis 331; zusätzlich UNKLAR bzgl. der V32_ENABLE-Kausalität (siehe Widerspruch oben).

**VERWEISE:** `[[diplomarbeit-impl-j-kette]]` (nicht im Band).

---

## 3. reference_ci_template_redeploy_sauberkeit_nicht_clobbern.md

**THEMA:** CI-Template-Redeploy v7.0.3→v7.0.4, Token-Rotation
**TYP:** reference

**FAKTEN:**
- Infra rotierte am 26.07.2026 `GITLAB_DEPLOY_TOKEN` (Gruppe comdare id=3, "FETCH_TOKEN"): alt md5 `9884cd4c` REVOKED → neu `ee9daa3a`. — HERKUNFT: AGENTEN-BEHAUPTUNG (Session 46375cdc).
- CI-Template-Vorlage "buildtools" (id=268) v7.0.3→v7.0.4 gefixt (kein Token in insteadOf-URLs, `credential.helper store`).
- Template ist MATERIALISIERT (kopiert) in jedes Projekt (kein `include:`) → Infra fuhr Mass-Redeploy über 200+ Kopien inkl. **super (Projekt-ID 288)** und **ce (Projekt-ID 286)** auf development.
- Owner-Wunsch, wörtlich (Datum im Dokument nicht explizit, Kontext 26.07.2026): **"alles sauber halten, nicht mit alten templates und PAT wieder dreckig machen"**.
- Lokaler Klon trug am 26.07. noch die ALTE v7.0.3 (letzter Touch super `41fbeb4c` / ce `90ba442e`).
- 5 Sauberkeits-Regeln: (1) super+ce tracken `.gitlab-ci.yml` als materialisierte Kopie, blinder Push könnte v7.0.4 clobbern; (2) vor jedem Push fetch+merge (nie-rebase-Doktrin), NIE `--ff-only`-Blindflug; (3) `.gitlab-ci.yml` NIE selbst editieren (`git log --since -- .gitlab-ci.yml` = leer in beiden Repos, verifiziert); (4) während Redeploy-Fenster Pushes zurückhalten; (5) kein alter PAT/Token — api-PAT blind aus Vault, api-scope ≠ MCP-Token, revoked `9884cd4c` nie verwenden, Token-Scratch-Dateien nach Gebrauch shred/rm.

**STAND:** GILT (prozedurale Regel, historisches Ereignis 26.07.2026 abgeschlossen).

**VERWEISE:** `[[reference_super_ci_cannot_fetch_new_ce_submodule_commits]]` (im Index verlinkt), `[[feedback_nie_rebase_immer_merge]]` (im Index verlinkt), **`[[reference_runner_concurrency_ist_3_2_stau_ist_backlog]]`** — NICHT im Band, aber der Dateiname selbst behauptet "3_2" als Konzept ("Stau ist Backlog"); zusammen mit Datei 9 unten der zweite Beleg im Band, dass die "3/2"-Runner-Zahl im Juli/Aug. als Referenz zirkulierte — das ist genau die vom Auftraggeber als überholt bezeichnete Zahl (Wahrheit lt. Auftrag: 4).

---

## 4. reference_ci_trace_parsing_commit_titel_falle.md

**THEMA:** CI-Trace-Parser-Fallen, 17 Einzelfälle plus Korrekturen
**TYP:** reference (Beschreibung nennt "2x real am 27.07." — massiv untertrieben gegenüber dem tatsächlichen Fließtext, der 17 gelabelte Fallen (a–q, ohne Buchstaben-Dedup c/d) plus zwei datierte NACHTRAG/KORREKTUR-Blöcke enthält. **Dies ist selbst ein Fund**: die `description:` im Frontmatter ist deutlich älter/unvollständiger als der gewachsene Fließtext.)

**FAKTEN (Grundproblem):** Der Commit-Titel erscheint im Git-Checkout-Block JEDES Job-Traces ("HEAD is now at `<sha>` `<titel>`"). Naives Substring-/Regex-Matching auf Fehlerbegriffe trifft den Titel statt des Fehlers.

**Zwei reale Erstfälle (27.07.2026, CiCheck288b):**
1. Titel "feat(error): RF-3 …" matchte `\berror\b` → Pipeline-Ursache fälschlich als Commit-Titel gemeldet.
2. Titel "V-6 Toolchain-Floor g++>=15.3" hätte die Floor-Abbruch-Wache auf JEDEM grünen Job der Welle ausgelöst.

**17 weitere, einzeln gelabelte Fallen (alle 27.07.2026, gegen echte Traces gegengeprobt):**
- **(e) Zeilenumbruch:** CMake-Meldungen brechen um ("gefunden:"/"13.3.0" auf zwei Zeilen) — einzeilige Muster verpassen Befunde.
- **(f) Ninja-Progress:** "[403/1387] …" ist Build-Schrittnummer, keine HTTP-403 — nackte Codesuche matcht falsch.
- **(g) Warnungs-/Kommando-Echo:** PIN-GAP-Warnung "gcc-15.3 bereitstellen" enthält "15.3" — naiver Alarm meldet eine Kanon-Toolchain, die es nicht gibt.
- **(h) Negations-Teilstring:** "leaks found" ⊂ "NO leaks found" — meldet jeden grünen Job falsch.
- **(i) Unzuverlässiger Endpunkt:** GitLab-Trace-Endpunkt wirft sporadisch 5xx, **gemessen ~20% nach 18.11.7-Upgrade** — ohne Retry+Backoff verliert Watcher still jede fünfte Prüfung.
- **(k) Runner-Präfix zerreißt Suchen:** Zeitstempel-Präfix `<ISO>Z 01E ` bricht Fehlermeldungen um; naiver Join schiebt den ZEITSTEMPEL der Folgezeile in die Extraktion ("gefunden: 2026" statt "13.3.0"). ODER-Trigger auf Fehlernamen matchte real **8 von 13** Commit-Titeln falsch-rot — Trigger müssen UND-Bedingungen sein.
- **(n) Retried-Jobs-Blindfleck:** `/pipelines/:id/jobs` verbirgt per Default RETRIED Jobs (`include_retried=false`); ein roter Erstversuch mit grünem Retry sieht komplett grün aus (real: `data_integrity_failure`-Erstversuch unsichtbar).
- **(m) YAML-Syntax-Gate-Falle:** `!reference`-Tags brechen `python3 yaml.safe_load` IMMER — Fix: `SafeLoader` mit `add_multi_constructor('!')`.
- **(l) Mehrschichtige Suchwörter + inerte Jobs:** "deprecated" kommt aus 3 Schichten (C++-Attribut, CMake-Statuszeile, CLI-Zeile); Opt-in-Jobs sind per Trace nicht prüfbar, nur statisch.
- **(j) API-Default-Sortierung:** `/runners/:id/jobs` liefert älteste Jobs zuerst — Pflicht: `order_by=id&sort=desc`.
- **(o) Geerbtes `needs: []` (27.07., OP-2):** Zentrale ci-templates (`.test`, `.lint-base`, `.build`, `.audit-layering`) bringen selbst `needs: []` mit → erbender Job ist stage-frei. Empirie: `test:unit` lief 4/4 Wellen VOR `verify:submodules` (started_at 13526 vs. 13561/13570 bei `build:clang`, wo die Vorlage ohne `needs` stimmte).
- **(q) Submodul-Checkout zeigt alten Stand:** `get_sources`-Block zeigt "HEAD is now at `<ALTER-SHA>`" VOR dem Update; autoritativ ist nur `git submodule status` im step_script (real fast falsch gemeldet bei super `13587`/ce `bc5dc37c`).
- **(p) Testzahlen sind host-abhängig:** ce `test:unit` prod1=275 vs. prod2=271 (allgemein), Diff = 4 hardware-gegatete Tests: `test_buildvariant_dll_real`, `test_ap5_simd_extension_coherence`, `test_simd_add_u64_carry_avx512`, `test_simd_field_sum_dispatch_avx512` (Trace wörtlich: "GO-3 A1: … NICHT registriert (Host ohne AVX2+AVX-512F …)"). **REFERENZWERTE Stand 01.08., SHA `52bcbc76`, GEMESSEN:** ce prod1=**276** / prod2=**272** (Pipeline-IDs 14127 vs. 14129, gleicher SHA beidseitig). super=**144** (zweifach prod2-belegt; prod1-super-Wert offen). **Der alte 141er-Stand für super ist UEBERHOLT.** ZUSATZ: `test_experiment_plan_director` erscheint in KEINER ctest-Liste der CI-Welle, obwohl gebaut — das ist gewollt (Zwei-Gate-Modell): CI-Suite (271/275) ≠ scharfes lokales Gate (**317**, dort verifiziert als "Test #260", "Total Tests: 317", Passed).

**NACHTRAG 02.08. nachmittags:** Gitlink-Wellen feuern seit thesis-Trigger BEIDE Bridges. Referenz-Klassen: Gitlink-dev=**13/2**, Gitlink-main=**13/2** (trigger:cache-engine + trigger:thesis). ce test:unit prod2=**277** (Stand `408242f3`+). PAT-Position: 1. von hinten (von 7 Kandidaten) — Rotation bestätigt.

**KORREKTUR 02.08. abends (CiWatch2-Befund):** `trigger:cache-engine` feuert auf super-MAIN IMMER (diff-unabhängig), `trigger:thesis` nur bei thesis-Gitlink im Diff. Referenzen NEU: docs-only-main=**13/1**, code-only-main=**13/1** (**alte 13/0 UEBERHOLT** — zählte main-immer-Bridge nie mit), Gitlink(thesis)-main=**13/2**, Gitlink(ce)-main=**13/1**, docs-only-dev=2/0 unverändert. ce test:unit prod2=**280** (Stand `7603453b`, +3 namentlich belegt). prtart(287)-Referenz=**6/0**. `prebackup:measurements` ist ein regulärer Job (kein Mess-Job).

**Zahlenreihe test:unit prod2 (Reihenfolge, jede spätere überholt die vorherige):** 271(allg.) → 272 (01.08., SHA `52bcbc76`) → 277 (02.08. nachmittags, Stand `408242f3`+) → 280 (02.08. abends, Stand `7603453b`).

**HERKUNFT:** durchgehend AGENTEN-BEHAUPTUNG/MESSUNG (CiCheck288b/d/f, CiWatch2-Watcher), keine Owner-Zitate in diesem Dokument.

**STAND:** Grundfallen GILT weiterhin (methodische Regeln); alle konkreten Zahlen (Bridge-Referenzklassen, Testzahlen) sind Momentaufnahmen mit klarer Ablösekette, letzter Stand 02.08. abends — ob seitdem erneut überholt, UNKLAR (außerhalb dieses Bandes).

**VERWEISE:** `[[feedback_no_success_marks_without_literal_output]]`, `[[feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat]]` (beide im Index verlinkt).

---

## 5. reference_codex_mcp_prod1_bwrap_shell_broken.md

**THEMA:** Codex-MCP workspace-write kaputt, bwrap/AppArmor
**TYP:** reference

**FAKTEN:**
- Symptom (2026-07-07, Session 46375cdc): Codex-MCP-Shell scheitert in Sandbox-Modi read-only/workspace-write VOR Ausführung mit `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`. — MESSUNG.
- WURZELURSACHE (bestätigt, ~08:20 Uhr): `kernel.apparmor_restrict_unprivileged_userns = 1` (Ubuntu-AppArmor-Restriktion, Kernel 6.17). Manueller Repro identisch: `bwrap --unshare-net --dev-bind / / true` → derselbe Fehler. bubblewrap 0.9.0 installiert; sudo nur mit Passwort (kein NOPASSWD) → Systemfix nur durch den User möglich.
- WORKAROUND (verifiziert, funktioniert): `sandbox: "danger-full-access"` überspringt bwrap komplett — Shell läuft (`pwd && echo CODex_SHELL_OK` → OK). Risiko-Pflichten: cwd auf Ziel-Repo, Tabus explizit im Prompt (NIE `~/Projekte/Cluster`, NIE `keys/`, keine Remote-Mutationen), Voll-Review Zeile für Zeile bleibt Pflicht.
- SAUBERER FIX (User/sudo, empfohlen, NICHT ausgeführt): AppArmor-Profil `/etc/apparmor.d/bwrap` mit `profile bwrap /usr/bin/bwrap flags=(unconfined) { userns, }`, dann `sudo apparmor_parser -r /etc/apparmor.d/bwrap`. Alternative (weniger sauber): `sudo sysctl kernel.apparmor_restrict_unprivileged_userns=0` host-weit.

**STAND:** GILT und weiterhin aktuell — laut aktueller Task-Liste dieser Session (#43) war "workspace-write" für Codex auf prod1 noch am 09.08.2026 defekt (identischer bwrap/RTM_NEWADDR-Fehler), d.h. der "saubere Fix" wurde bis mindestens 09.08. nicht angewendet; der Workaround `danger-full-access` ist weiterhin der einzige funktionierende Weg.

**VERWEISE:** `[[feedback_codex_implements_from_dossier_claude_corrects]]`, `[[feedback_codex_outputs_always_full_manual_review]]` (beide nicht im Band).

---

## 6. reference_codex_null_junk_artifact_ignore.md

**THEMA:** `$null`-Junk-Datei ignorieren, nicht löschen
**TYP:** feedback laut `metadata.type` — **Diskrepanz:** Dateiname trägt Präfix `reference_`, Frontmatter sagt aber `type: feedback`. (Gleiche Diskrepanz bei Datei 7.)

**FAKTEN:**
- Codex-Impl-Läufe (PowerShell-Redirect wie `… > $null`) legen im Repo-Root eine Datei namens `$null` ab (Teil des F-J-Junk-Musters).
- **Owner-Zitat, 2026-07-04, wörtlich:** "Die junk null kann man nicht löschen, wir ignorieren sie."
- `rm -f '$null'` scheitert (OneDrive-/Windows-Lock); ein entsprechender Tool-Call wurde vom User rejected.
- Schutzmaßnahme: gezieltes Staging (`git add <konkrete Pfade>`, NIE `git add -A`) — `$null` bleibt als `?? $null` in `git status`, harmlos.

**HERKUNFT:** OWNER-WORT (04.07.2026, wörtlich zitiert).

**STAND:** GILT.

**VERWEISE:** `[[feedback_commit_push_regularly_not_only_session_end]]` (nicht im Band).

---

## 7. reference_codex_routing_block_preamble_fix.md

**THEMA:** Codex §8-STOPP durch Routing-Hook, Fix
**TYP:** feedback laut `metadata.type` — **gleiche Diskrepanz wie Datei 6** (Dateiname `reference_...`, Feld sagt `feedback`).

**FAKTEN:**
- Symptom: `codex exec` bricht mit **"STOPP gemäß §8: kann nicht ohne Verletzung der Routing-Auflage arbeiten — /workflow-orchestrator:delegate nicht verfügbar"** ab. Ursache: `~/.codex/` trägt denselben `workflow-orchestrator@barkain-plugins`; dessen `SessionStart/inject_all.py`-Hook injiziert die Delegate-Pflicht als **Developer-Instruktion**.
- Zwei gescheiterte Fixversuche (beide getestet 2026-07-04): (1) `-c 'plugins."workflow-orchestrator@barkain-plugins".enabled=false'` — Hooks in `[hooks.state]` sind separat getrusted, feuern trotzdem. (2) Ein Prompt-Preamble, das die Regel außer Kraft setzt — Codex-Antwort: **"Dein Override … kann diese Developer-Regel nicht außer Kraft setzen"** (User-Prompt < Developer-Injektion in Codex' Hierarchie).
- **FIX, funktioniert (2026-07-04, Banner `sandbox: workspace-write`, 0 Hook-Marker):** temporäres `CODEX_HOME` mit gefilterter `config.toml` (Plugin+Hooks entfernt, `[projects.*] trust_level="trusted"` behalten):
```bash
REAL=~/.codex; TMPH=<scratchpad>/codex_clean_home; mkdir -p "$TMPH"
cp "$REAL/auth.json" "$TMPH/auth.json"
awk '/^\[/{keep=($0~/^\[features\]/||$0~/^\[projects\./||$0~/^\[notice/)?1:0} keep{print}' \
    "$REAL/config.toml" > "$TMPH/config.toml"
export CODEX_HOME="$TMPH"
codex exec -C "$CE" -s workspace-write -m gpt-5.5 -c 'model_reasoning_effort="xhigh"' \
      --skip-git-repo-check < dossier.md
```
  (Modell verwendet: **gpt-5.5**.)
- WICHTIG: `--ignore-user-config` allein killt Hooks, verliert aber Trust → Banner fällt auf `sandbox: read-only`.
- Nicht tun: `codex plugin remove/disable` mutiert die globale User-config.toml (Nebenwirkung auf andere Sessions).

**Spannungspunkt zu Datei 5 (beachten, nicht als sicherer Widerspruch, aber zeitlich auffällig):** Dieser Fix demonstriert am **04.07.2026** einen erfolgreichen Lauf mit Banner `sandbox: workspace-write`. Datei 5 (`reference_codex_mcp_prod1_bwrap_shell_broken.md`) datiert das bwrap/AppArmor-Scheitern von workspace-write auf **07.07.2026**, drei Tage später. Beide können gleichzeitig wahr sein (unterschiedliche Fehlerebenen: hier Hook-Routing, dort Kernel-Sandbox) — es ist aber ungeklärt, ob zwischen 04.07. und 07.07. eine Systemänderung (Kernel-Update, sysctl) workspace-write zusätzlich brach, oder ob der 04.07.-Testlauf schlicht keine netzwerk-/loopback-relevante Aktion auslöste. STAND dieses Punkts: UNKLAR.

**STAND:** GILT (Fix-Rezept), Datum 04.07.2026.

**VERWEISE:** `[[feedback_codex_implements_from_dossier_claude_corrects]]` (nicht im Band).

---

## 8. reference_gcc_kern_toolchain_versionen.md

**THEMA:** Toolchain-Kern gcc 15.3, Obergrenze gcc 16
**TYP:** reference

**FAKTEN:**
- **Owner-Zitat, 06.08.2026 (frueh-12), wörtlich:** "Weiterhin arbeiten wir mit gcc 15.3 und die neueste Version (die ueberhaupt existieren kann) ist gcc 16"
- Konsequenz: In Doku/Tests/Fixtures/Beispiel-Preimages dürfen KEINE Phantom-Compiler-Versionen (g++-17/18 o.ä.) auftauchen; realistische Beispiele nutzen gcc 15.3 (Arbeits-Toolchain) bzw. gcc 16.x als Obergrenze (Beispiel K2: "g++-16 16.0.1→16.3 baut DLL neu").
- Die RT-Realversions-Sonde (T2-C, fail-closed) liefert die echte Version zur Laufzeit — statische Versions-Annahmen sind verboten.

**HERKUNFT:** OWNER-WORT (06.08.2026, wörtlich).

**STAND:** GILT — sehr aktueller, direkter Owner-Beleg (modified 2026-08-06T10:40:58Z), keine Korrektur im Dokument.

**VERWEISE:** `[[hardware-erkennung-factory-laufzeit-nie-statisch]]` (nicht im Band).

---

## 9. reference_gitlab_jobs_api_zeigt_keine_bridges.md

**THEMA:** `/pipelines/:id/jobs` verbirgt Trigger-Bridges
**TYP:** reference

**FAKTEN:**
- `GET /projects/:id/pipelines/:pid/jobs` blendet Bridge-Jobs vollständig aus; fehlende Bridges stehen nur unter `GET /projects/:id/pipelines/:pid/bridges` (inkl. `downstream_pipeline.id/status/project_id`).
- Realer Fall 27.07.2026: **288-main**-Pipelines blieben stundenlang `running`, `build:clang` auf `created`. Ursache: 3 Bridges in Stage `orchestrate` (`trigger:cache-engine`, `trigger:prt-art`, `trigger:thesis`); auf main feuern alle drei IMMER, weil `if: $CI_COMMIT_BRANCH == "main"` VOR dem changes-Gate steht. `strategy: depend` hält die Bridge running bis Downstream fertig ist. `build:clang` hat **kein `needs:`**, wartet stage-basiert, während `analyse:thesis-data`/`visibility:tier-binaries` mit `needs: ["verify:submodules"]` per DAG vorbeiziehen.
- Auf development griff das changes-Gate, orchestrate blieb leer — dieselbe Datei lief auf demselben Commit sauber durch.
- Selbstblockade-Kreis: jeder main-Push (auch docs-only) erzeugt per Bridge eine volle Downstream-Pipeline; die "redundante Kaskade" auf **286-main** war zu 100% Echo der eigenen 288-main-Wellen (erkennbar am Feld `source=pipeline` vs. `source=push`).
- Diagnose-Rezept (4 Schritte, siehe Volltext); Erkennungsregel für Monitore: kein Job mehr running/pending + mind. einer `created` + mind. eine offene Bridge = strukturell hängend.

**HERKUNFT:** AGENTEN-BEHAUPTUNG/MESSUNG, Session 46375cdc, 27.07.2026.

**STAND:** GILT (API-Verhalten, strukturelle Analyse).

**VERWEISE:** **`[[reference_ci_324s_job_finalisierung_slot_blockade]]`** (nicht im Band — verschärfte den Stau, jeder Job hielt zusätzlich 324s seinen Slot; potenziell relevant für die vom Auftrag erwähnte Runner-Speicher-/Concurrency-Untersuchung), **`[[reference_runner_concurrency_ist_3_2_stau_ist_backlog]]`** (zweiter Beleg im Band für diese Datei, siehe Datei 3 — Cluster-Signal: die "3/2"-Zahl war im Juli mehrfach referenzierter Kontext für CI-Stau-Analysen).

---

## 10. reference_gitlab_pipelines_api_sha_vollform.md

**THEMA:** Pipelines-API `?sha=` nur voller 40-Zeichen-SHA
**TYP:** reference

**FAKTEN:**
- `GET /projects/:id/pipelines?sha=<kurz-sha>&ref=…` mit abgekürztem SHA (Beispiel: `0d7a0d92`) liefert IMMER `[]` — die API matcht `sha` nur gegen den vollen 40-Zeichen-Hash.
- Realer Fall, **03.08.2026, prod1/Projekt 286**: eine "2d-Landungs-Wache" verpasste dadurch die ROTE Pipeline **14334** (FAILED) und lief still bis zum Timeout.
- REGEL: immer `git rev-parse <ref>` (voller SHA) verwenden; alternativ ohne sha-Filter die letzten Pipelines je ref holen und clientseitig `sha.startswith(...)` matchen. Nach 1–2 Leerantworten eine LAUTE Diagnosezeile emittieren (Query + Antwortlänge), nie endlos still weiterpollen.

**HERKUNFT:** MESSUNG (realer Vorfall 03.08.2026, Pipeline-ID 14334 belegt).

**STAND:** GILT.

**VERWEISE:** `[[feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat]]` (im Index verlinkt), `[[reference_gitlab_jobs_api_zeigt_keine_bridges]]` (Datei 9, selbes Band — Cluster: GitLab-API-Fallen), `[[reference_ci_trace_parsing_commit_titel_falle]]` (Datei 4, selbes Band, selbe Session 46375cdc).

---

## 11. reference_gruene_tests_zementieren_alte_ordnung.md

**THEMA:** Grüne Tests verstecken abgeschaffte Achsen-Ordnung
**TYP:** reference

**FAKTEN:**
- Ein rotes Gate findet Ordnungs-/Achsen-Änderungen NICHT vollständig; zwei Klassen rutschen durch, beide real belegt im **O-8-Fenster, 27.07.2026**:
- **(1) Fixture-Strings:** `test_g1_binary_version_stamp.cpp:64` und `:98` — Kommentar "beginnt stets mit '+ext='" ist überholt, bindend ist "+cxx="; ebenso `test_m_w12_stamp_bausteine.cpp` A4-POD-Roundtrip mit `kSystem` in der abgeschafften 5-Achsen-Ordnung. GEGENMITTEL: Fixture aus Single-Source erzeugen (`compose_system_version_suffix`) statt hinzuschreiben.
- **(2) Übersehener dritter Ableitungsweg:** O-8 Schritt 9 zog `load_framework` nur in `abi::measurement_stamp_line` ein — es gab aber DREI Wege, der dritte war die consteval-Fassung `ceb_measurement_stamp_array()` in `builder/ceb_version_stamp.hpp`. Gefunden durch einen Drift-Guard, der Gleichheit zweier Quellen prüft. Lehre: solche Guards nie lockern, um einen Befund verschwinden zu lassen.
- Praktisch: nach Ordnungsänderung `grep` auf ALTE Segment-/Achsen-Namen über `tests/` UND `libs/`, nicht nur rote Tests abarbeiten.

**HERKUNFT:** AGENTEN-BEHAUPTUNG/MESSUNG, Session 46375cdc, 27.07.2026 (O-8-Paket).

**STAND:** GILT.

**VERWEISE:** `[[reference_drift_guard_faengt_anhaengen_nicht]]`, `[[feedback_increments_architekturkonform_nicht_nur_gruen]]` (beide nicht im Band; letztere thematisch nah an Index-Eintrag "Architektur≠grün").

---

## 12. reference_lokale_vollbau_luecken_falsches_gruen.md

**THEMA:** Blanker Vollbau lügt, all-Ziel-Lücken, Zwei-Gate
**TYP:** reference. **Frontmatter-Befund:** `description` nennt nur "Verifiziert 2026-07-26", der Fließtext trägt aber zusätzlich zwei NACHTRAG-Blöcke vom **27.07.2026** (O-8, O-8 Schritt 3/4) mit eigenständigen, wichtigen Befunden — das Frontmatter ist damit ein Tag älter als der aktuelle Inhalt.

**FAKTEN — Hauptteil (verifiziert 26.07.2026):**
- **(1) ce-Baum:** Fassaden-TU `libs/cache_engine/profile_facade/profile_run_facade.cpp` liegt NICHT im `all`-Ziel. MESSUNG: `ninja -t query all | grep -c "profile_run_facade"` → **0**. Folge: `cmake --build . && ctest` (z.B. "315/315") kompiliert die Datei gar nicht — Symptom war eine `.o`-Datei ÄLTER als die editierte Quelle, während ninja "no work to do" meldete. Pflicht: `cmake --build . --target comdare_profile_run_facade` explizit vor jedem Voll-ctest.
- **(2) super-Baum:** vendored ce-Unit-Tests liegen NICHT im `all`-Ziel. MESSUNG: `ninja -t query all | grep -c "tests/unit/test_"` → **0**. Folge: ctest registriert ~350 Tests, nur ~34 Binaries existieren; Rest `***Not Run`. Filter für echte Fehlschläge: `ctest 2>&1 | grep -cE '\*\*\*(Failed|Exception|Timeout)'`.
- **(3) 2-Pass-Werkzeugpflicht** (Design, keine Lücke): Byte-Wachen (`test_permutation_codegen_byte_identity_*`) brauchen `comdare-permutation-codegen`; `test_*_registry_roundtrip` brauchen `comdare_axis_registry_gen`, `comdare_system_axis_registry_gen`, `comdare_measurement_axis_registry_gen`.
- **(4) mc-Falle:** `mc` behandelt einen unbekannten Alias als LOKALEN PFAD. Beweislauf mit `COMDARE_MINIO_ENDPOINT=fakealias COMDARE_MINIO_BUCKET=fakebucket` schlägt NICHT fehl, sondern legt still `<cwd>/fakealias/fakebucket/...` an. Konsequenz: Fehlerpfade gehören in Unit-Tests mit inertem/faked Transport; vor Paketmeldung `git status` prüfen und Streu-Verzeichnis entfernen.
- Byte-Wachen-Nummern unterscheiden sich je Baum: **ce 296/297** (im 315er-Baum), **super 292/293**.

**NACHTRAG B-16 (26.07. abends):**
- **E-1 (Hauptursache des 10/10-falsch-Grün des Managers):** `comdare-adhoc-emitter` läuft zur CONFIGURE-Zeit, schreibt 48 r5g-Perm-Quellen; `cmake --build` erneuert das Werkzeug, aber NIE die bereits emittierten Quellen. Pflicht-Reihenfolge: Werkzeug bauen → RE-CONFIGURE → Vollbau.
- **E-2:** generierte Header ohne mitgezogenes Erzeuger-Target (`comdare_limits_generated_source_catalog`).
- **J-0 (B-17):** Alt-Build-Dirs sind Beweisgift — belegt: "alle 320 ids differieren um genau 1 Segment" war ein **13:41-Binary gegen einen 14:07-Quellbaum**-Vergleich, kein echter Quell-Gap.
- **J-5:** Test-Zahl N immer mitmelden — Gate-Menge ist configure-zustandsabhängig: **312 frisch → 314 nach Emitter-Lauf → 316 mit Opt-ins**. Exit-Codes nie durch eine Pipe messen (B-3-Lehre).
- **JOIN-CHECKLISTE J-1…J-4:** J-1 Werkzeuge zuerst (inkl. `comdare_anatomy_codegen_cli` — ohne dieses Tool bleiben `test_v41_anatomy_r5i_configure_codegen` + `test_v41_anatomy_f15_measurement` aus, Clean-Room meldet 314 statt 316); J-2 Re-Configure; J-3 `comdare_limits_generated_source_catalog`; J-4 Vollbau → `comdare_profile_run_facade` → `--target comdare_tests` → Voll-ctest.
- **J-4-ZUSATZ:** Mehrere Tests sind `EXCLUDE_FROM_ALL`, hängen nur am Sammelziel `comdare_tests` (**CMakeLists.txt:1549**, Property `COMDARE_TEST_TARGETS`). MESSUNG: `ninja -t query all | grep -c test_profile_roundtrip` → **0**; frischer Vollbau+ctest meldete **"99% tests passed, 1 tests failed out of 316"** ("296 - test_profile_roundtrip (Not Run)"); nach `--target comdare_tests`: **316/316, EXIT=0**.

**NACHTRAG O-8 (27.07., Impl-O8):** **super-Voll-Suite war NIE 453/453 grün — Zwei-Gate-Modell ist die Wahrheit.**
- (a) super-Sammelbau zieht `comdare_permutation_codegen_cli` nicht mit → 2 Byte-Identitäts-Tests scheitern mit falschem ROT.
- (b) super trägt DAUERHAFT **5 vorbestehend rote Tests**: `v31_adapters` + `v41_topic_allocator` (vendor-snmalloc-Runtime-Bug, Ledger:514, nur bei `COMDARE_VENDOR_SNMALLOC=ON`); `limits_entkopplung` + `lazy_adhoc` (CRC-Mismatch, `kNewGolden131072Crc64` ist konfigurationsgebunden); `axis_registry_roundtrip` (contract-Label, gate-gewollter Inventar-Drift).
- KONSEQUENZ: **ce-standalone = scharfes Gate (316/316 + CRC-Anker)**; **super = Integrationsgate mit eingefrorener 5er-Ausnahmemenge** (Erwartung **450 grün / 5 rot / 453**). Ein "super 453/453" in Plänen ist nur eine Zählung (`ctest -N`), kein Lauf-Beleg.

**NACHTRAG O-8 Schritt 3/4 (27.07., Impl-O8b):** Registry-Generator lügt in BEIDE Richtungen. `comdare_system_axis_registry_gen` ist `EXCLUDE_FROM_ALL` — ein Bau ohne explizites Target lässt das ALTE Binary liegen, ein Regen schreibt dann die XML mit ALTEN Labels zurück → Byte-Diff LEER, Roundtrip fälschlich GRÜN. Literal erlebt: nach `external_utils`-Rename meldete der Generator weiter `axis id="extension_hardware"`. Zweiter Fall im super: `test_kf1_thesis_profile_parser`, `test_experiment_parser`, `test_experiment_plan_director` liefen scheinbar rot, weil ALTE Test-Binaries gegen NEUE XMLs liefen (866 Objekte fehlten) — nach `--target comdare_tests` alle grün.

**HERKUNFT:** durchgehend MESSUNG (Session 46375cdc, 26.–27.07.2026, mehrere benannte Pakete: O-8, Impl-O8, Impl-O8b, Paket (d), LaneC-Fund).

**STAND:** GILT als methodische Sammlung; die Zahlen 312/314/316 sind konfigurationsabhängige Momentaufnahmen, laut Datei 2 (`reference_ce_jkette_n316_braucht_v32_enable_on.md`) inzwischen bis auf 331 fortgeschrieben (Stand 03.08.) — **312/314/316 hier ist damit ebenfalls historisch überholt**, bleibt aber als Beleg der Progressions-Herkunft wertvoll.

**VERWEISE:** `[[cache-engine-standalone-build-pipeline]]`, `[[no-success-marks-without-literal-output]]`, `[[goal-hook-thorough-read-in-never-guess]]` (alle drei vermutlich = die im Index unter anderen Namen verlinkten Dateien `reference_cache_engine_standalone_build_pipeline.md`, `feedback_no_success_marks_without_literal_output.md`, `feedback_goal_hook_thorough_read_in_never_guess.md`).

---

## 13. reference_pgrep_warteschleife_selbstmatch_falle.md

**THEMA:** `pgrep -f`-Warteschleife matcht sich selbst
**TYP:** reference

**FAKTEN:**
- Muster `until ! pgrep -f "ninja.*build-v6" > /dev/null; do sleep 10; done` terminiert NIE — die ausführende Shell trägt das Suchmuster selbst in ihrer Kommandozeile.
- Real beobachtet **27.07.2026** (ce-Zug 6d/6e): zwei solche Loops liefen weiter, obwohl Bau+ctest längst mit Exit 0 fertig waren; mussten von Hand gekillt werden (**Exit 144 = SIGTERM**, KEIN Arbeitsfehler — muss in der Meldung als solcher kenntlich gemacht werden).
- Saubere Alternativen: `run_in_background: true` direkt auf den Befehl; Warten auf Artefakt (`until [ -f fertig.marker ]`, `until grep -q "100% tests passed" ctest.log`); falls doch Prozess nötig: `pgrep -f "[n]inja"` (Selbst-Match entschärft) oder `while kill -0 <pid> 2>/dev/null; do sleep 5; done`.

**HERKUNFT:** MESSUNG (realer Vorfall 27.07.2026, ce-Zug 6d/6e).

**STAND:** GILT.

**VERWEISE:** `[[feedback_goal_driven_autonomie_shells_monitore_beenden]]` (im Index verlinkt als "Shells beenden"), `[[feedback_monitore_duerfen_nie_stumm_haengen_vollblick_heartbeat]]` (im Index verlinkt).

---

## 14. reference_rescue_ref_ist_keine_landung.md

**THEMA:** rescue-Ref ist keine Landung, Thesis-Anhang-Beinaheverlust
**TYP:** reference

**FAKTEN:**
- Gefunden **06.08.2026 abends**, zwei Tage vor Abgabe, unter dem Submodul-Rückstand aus Datei 15 (derselbe Vorgang, zweite Ebene).
- BEFUND: `rescue/gate8-graph-abbildungen-8970465d` lag seit mittags auf BEIDEN Remotes (`refs/remotes/origin/...` UND `refs/remotes/github/...`, beide auf `8970465d`) und war in KEINEM Zweig. Commit ist genau einer über dem damals committeten Zeiger, ändert 2 Dateien, **+199/-2**: `anhang/{de,en}/A_measurements.tex`, "die 23 Abbildungen des Graph-Umbaus eingebunden (DE+EN)". Der TEXT-Teil des Pakets, dessen CODE-Teil am selben Tag gelandet war.
- HÄRTUNG: die rescue-Ref hatte einen eigenen grünen CI-Lauf — **Projekt 289, Pipeline 14964**, `ref=rescue/gate8-...`, `success`. **"Nicht einmal 'grün getestet' impliziert 'gelandet'."**
- How to apply: (1) Landungsfrage NUR mit `git merge-base --is-ancestor <commit> <zweig>` gegen development UND main je Repo beantworten — nicht `ls-remote`, nicht "ist gepusht". (2) Beim Wellenabschluss `git for-each-ref 'refs/remotes/*/rescue/*'` durchgehen, jede Ref ohne Zweig ist offener Posten. (3) Bei Paketen mit Code- UND Text-Anteil beide Seiten (verschiedene Repos/Wege) einzeln prüfen. (4) rescue-Ref löschen ist nie die Aufräumhandlung, solange die Landungsfrage offen ist.

**HERKUNFT:** MESSUNG (realer Befund 06.08.2026, Commit `8970465d`, Pipeline 14964 belegt).

**STAND:** GILT — thematisch identisch mit der laufenden Task #41 dieser Session ("LANDE-RUNDE: 30 ungepushte Commits aus 15 Worktrees"), d.h. die hier dokumentierte Falle ist unmittelbar praxisrelevant für aktuell laufende Arbeit.

**VERWEISE:** `[[reference_submodul_zeiger_kann_rueckwaerts_zeigen]]` = Datei 15, selbes Band, selbe Session 5a19728e, selber Abend — **direktes Match-Paar**. `[[feedback_workflow_backup_sofort_bei_fertigstellung]]` (im Index verlinkt als "BU SOFORT"), `[[feedback_behauptungen_verifizieren_layer_vertraege_halten]]` (im Index verlinkt).

---

## 15. reference_submodul_zeiger_kann_rueckwaerts_zeigen.md

**THEMA:** Submodul-Zeiger `M` kann rückwärts zeigen
**TYP:** reference

**FAKTEN:**
- Gefunden **06.08.2026 abends** beim Sichern des super-Pushes, zwei Tage vor Abgabe-Frist.
- BEFUND: `git status --porcelain` im super zeigte `M Code/external/20260931-overleaf-diplomarbeit`. Ausgecheckter Stand: **`ef448e4b`** (21.07., gesetzt am 26.07., seitdem 11 Tage unbewegt). Committeter Zeiger: **`29a1700d`** (03.08.). `git merge-base --is-ancestor <checkout> <zeiger>`: Checkout ist Vorfahr — Distanz **78 Commits RÜCKWÄRTS**.
- WARUM GEFÄHRLICH: `git add .` / `git commit -a` hätte den Gitlink lautlos auf 21.07. zurückgedreht (im Diff nur eine Hash-Zeile, kein Inhalt). Verloren wären gewesen: **Thesis-Kapitel 6** (Fazit, FF2-Erweiterbarkeit), **Kapitel 5** (Auswertung, Mess-Schema-Modi), **Kapitel 3** (`sec:stamp-model`). Verhindert allein durch expliziten Pathspec bei jedem Commit dieser Strecke.
- DIE REGEL (achte Regel-Zeile der Prüfbereichs-Familie, Ledger nachmittag-10): **"Ein Submodul-Zeiger im Working Tree kann RÜCKWÄRTS zeigen. `M` heißt nicht 'neuer'."**
- How to apply: (1) Richtung immer MESSEN (`git -C <super> rev-parse HEAD:<pfad>` gegen `git -C <submodul> rev-parse HEAD`, dann `merge-base --is-ancestor` in BEIDE Richtungen). (2) Nie `git add .`/`commit -a` in Submodul-Repos, immer Pathspec. (3) Heilung bei Rückstand: `git submodule update -- <pfad>`, KEIN Commit. (4) Vor Update Besitzfrage klären: `status --porcelain`, `stash list`, `branch -a --no-merged <zeiger>` müssen ALLE DREI leer sein. (5) Gegenprobe je Submodul einzeln nötig — im selben Repo zeigte der ce-Zeiger korrekt VORWÄRTS.

**HERKUNFT:** MESSUNG (realer Befund 06.08.2026, SHAs `ef448e4b`/`29a1700d` belegt, Distanz 78 Commits gemessen).

**STAND:** GILT — direktes Match-Paar mit Datei 14 (derselbe Abend, derselbe zugrundeliegende Vorgang, zwei Ebenen desselben Beinaheverlusts).

**VERWEISE:** `[[feedback_behauptungen_verifizieren_layer_vertraege_halten]]` (im Index verlinkt), `[[reference_super_ci_cannot_fetch_new_ce_submodule_commits]]` (im Index verlinkt), `[[reference_ugrep_ascii_gate_stille_null]]` (im Index verlinkt als "ugrep stille Null"), `[[reference_git_immer_mit_c_pfad_cwd_falle]]` (im Index verlinkt), `[[reference_rescue_ref_ist_keine_landung]]` = Datei 14, selbes Band.

---

## Zusammenfassende Cluster-Beobachtungen (für die Konsolidierung)

- **10 von 15 Dateien** teilen dieselbe `originSessionId` (**46375cdc-821a-4bf9-93d4-fe0a5687f489**): Dateien 2–5, 9–13 — ein durchgehender CI/Build-Verifikations-Strang vom 07.07. bis 03.08.2026, der nie indexiert wurde. Diese 10 Dateien bilden inhaltlich einen zusammenhängenden "CI-Watcher-Fallen"-Korpus (Trace-Parsing, GitLab-API-Eigenheiten, lokale Vollbau-Lücken).
- **3 Dateien** teilen `5a19728e-f6e1-4736-a246-e3fda9ac35a1` (Dateien 8, 14, 15) — alle datiert 06.08.2026, Owner-nahe/Abgabe-nahe Funde.
- **2 Dateien** teilen `78cf67f8-571e-4fcd-a907-1556dbc5be72` (Dateien 6, 7) — beide 04.07.2026, Codex-Routing-Fixes.
- **1 Datei** eigenständig: `c6f15797-...` (Datei 1).
- **Stärkster inhaltlicher Widerspruch:** Datei 2 — N=316 wird im selben Dokument zuerst als abhängig von `COMDARE_V32_ENABLE=ON` begründet (27.07.-Messung), dann im Nachtrag vom 03.08. als "historisch" bezeichnet, mit der Gegenbehauptung, die Option gate gar keinen Test. Beide Aussagen stehen unaufgelöst nebeneinander.
- **Frontmatter veraltet gegenüber Fließtext:** Datei 4 (description nennt nur "2x real am 27.07.", tatsächlich 17+ Fallen über mehrere Tage) und Datei 12 (description nennt nur "26.07.", Fließtext trägt NACHTRÄGE vom 27.07. mit eigenständigen Befunden).
- **Typ-Diskrepanz Dateiname vs. Metadaten:** Dateien 6 und 7 tragen den Dateinamen-Präfix `reference_`, aber `metadata.type: feedback`.
- **Cluster-Signal zur Runner-Concurrency-Frage aus dem Auftrag:** Die im Auftrag genannte Datei `reference_runner_concurrency_ist_3_2_stau_ist_backlog` (nicht in diesem Band) wird von **zwei** Dateien dieses Bandes verlinkt (Datei 3 und Datei 9) — beide behandeln sie als gültigen Referenzpunkt für CI-Stau-Analysen im Zeitraum 26.–27.07.2026. Das bestätigt, dass die "3/2"-Zahl zu dieser Zeit breit in der CI-Diagnostik verankert war, nicht nur im Wellenplan.
- **Datenreihen mit klarer Ablösekette (Reihenfolge erhalten, nicht nur Endwert):**
  - ce-Gate-Zahl: 312 → 314 → 316 → 317 → 318 → … → **331** (Stand 03.08., Datei 2, bestätigt durch 312→314→316 in Datei 12).
  - test:unit prod2: 271(allg.) → 272 (01.08., SHA `52bcbc76`) → 277 (02.08. nachmittags, `408242f3`+) → 280 (02.08. abends, `7603453b`) — Datei 4.
  - super test:unit: 141 (alt, UEBERHOLT) → 144 (01.08., zweifach prod2-belegt) — Datei 4.
  - Bridge-Referenzklassen main: 13/0 (alt, UEBERHOLT) → 13/1 docs-only/code-only, plus aufgespalten in Gitlink(thesis)-main=13/2 und Gitlink(ce)-main=13/1 — Datei 4.

**Nenner-Kontrolle: 15 von 15 Dateien aus band_03 bearbeitet.**