## Extrakte, Band 00 (15 Dateien)

---

### 1. feedback_a5_sortierung_key_filter_map_value_filter_achse.md
**Thema:** Map-Gattung Key-/Value-Filter-Achse (A5)
**Typ:** feedback

**Fakten:**
1. Owner-KERN A5, datiert "05.08.2026 abend-10", verbatim-Zitat im Dokument: **"MAP grundsätzlich eine key und eine value Filter-Achse"** — OWNER-WORT (05.08.2026 abend-10)
2. Einordnung durch den Agenten: Sortierungen zählen als Key-Filter-Klasse (Paraphrase, nicht selbst in Anführungszeichen) — AGENTEN-BEHAUPTUNG, gestützt auf Fakt 1
3. Es existieren 4 Umsetzungs-Optionen, die bewusst UNBEWERTET bleiben; Folgeentscheid des Owners erst NACH Abgabe, als Register-Zeile — OWNER-VORGABE
4. Explizite Abgrenzung: NICHT zu verwechseln mit der Sortier-REIHENFOLGE der 18 Achsen (anderes Dokument/Thema)

**Stand:** GILT — Folgeentscheid noch offen (Stand der Datei: 3 Tage alt relativ zu 10.08.)
**Verweise:** [[project_achsen_neuordnung_bindende_sortierung_regressionen]] (explizit als "nicht verwechseln" markiert, dieses Ziel ist im Index verlinkt: "[Achsen-Sort.]")

---

### 2. feedback_abschluss_aufraeumpass_deprecated_code_entfernen.md
**Thema:** Abschluss-Aufräumpass, toter Code entfernen
**Typ:** feedback

**Fakten:**
1. Owner-Zitat, 27.07.2026 ~00:40, verbatim: **"Bitte merke dir, dass nach der Bearbeitung aller bekannten Aufgaben die deprecated header und toter code aufgeraeumt und entfernt werden muessen."** — OWNER-WORT (27.07.2026, originSessionId 46375cdc-821a-4bf9-93d4-fe0a5687f489)
2. Doktrin-Präzisierung: Doku-nie-löschen gilt nur für DOKU (Session-Docs/Ledger/Manuals bleiben mit SUPERSEDED-Vermerk) — CODE-Artefakte werden nach Abschluss ENTFERNT, nicht nur deprecated-gebannert
3. Verfahren: je Fund Aufrufer-Grep = 0 belegen, Tests nachziehen, granularer Commit; der Pass selbst ist ein benanntes Paket mit ultracode-Planung (VOR+NACH)
4. Kandidatenliste (Stand 27.07., als "fortschreiben!" markiert, seither in dieser Datei nicht aktualisiert):
   - `ce tools/permutation_codegen/{codegen.cmake,codegen.sh,codegen.bat,axes_versions.txt}` + Tool/CLI (V-4-Retire-Scope)
   - `super Code/02_messung_driver/permutations_runtime_check.hpp` (V-2-deprecated)
   - `ce cmake/isa_features.cmake` Funktion `COMDARE_apply_simd_flags` (Zeilen 103-123, 0 Aufrufer — Beifang V-4)
   - `ce cmake/permutations.cmake` (fällt mit V-4)
   - historisierte Tripwire-Texte auf erledigte Auflagen (Beispiel: RF-3-Hinweis in `machine_identity.hpp`)
   - `COMDARE_GOLDEN_320_BYTE_GUARD_IDS`-Alias `_IDS` (deprecated seit GN-8)
   - `COMDARE_LEGACY_MESSREIHEN`-Blöcke (erst nach golden-320-Subsumtions-Bestätigung, V-5c)

**Stand:** GILT, aber Kandidatenliste ist eine Momentaufnahme vom 27.07. (14 Tage alt) — vor Ausführung gegen aktuellen Stand prüfen, ob Punkte bereits erledigt/hinfällig sind.
**Verweise:** [[feedback_never_delete_documentation]] (im Index verlinkt: "Doku deprecaten"), [[feedback_alt_golden_darf_brechen_erst_additiv_dann_aufraeumen_unter_absprache]] (im Index verlinkt: "Alt-golden")

---

### 3. feedback_always_sync_missing_remotes_except_cluster.md
**Thema:** Fehlende Git-Remotes automatisch nachziehen
**Typ:** feedback

**Fakten:**
1. Owner-Direktive, 2026-07-18, "bindend", verbatim: **"Bitte merke dir, dass du immer (außer bei Cluster git wegen plain text cred vault, gewollt so) einen sync durchführst, wenn eine remote fehlt. Bitte sync diesen Fehler auf Pi 5 und node1 (hier), die auch halb fertige clone haben."** — OWNER-WORT (2026-07-18)
2. Namensmuster auf prod1: `origin` = gitlab.comdare.local, `github` = github.com/BenniProbst/<repo>
3. Konkret genannter Fall eines halbfertigen Klons: der prod1-thesis-Klon (nur `origin`, `github` fehlte)
4. Zwei Maschinen mit halbfertigen Klonen (Stand 18.07.): Pi 5 und node1 (=prod1) — AGENTEN-BEHAUPTUNG/OWNER-WORT
5. Ausnahme: Cluster-git (`Projekte/Cluster`) NIE nach github syncen — enthält plain-text Cred-Vault, bleibt bewusst gitlab-intern-only
6. Verfahren bei fehlendem Remote: `git remote add <name> <url>`, danach read-only mit `git ls-remote` verifizieren, dann pushen; Repo-NEUANLAGE bleibt weiter GO-pflichtig, reiner Remote-Config-Fix zu einem existierenden Repo ist erlaubt

**Stand:** Die allgemeine Regel GILT weiter als Dauer-Policy. Die konkrete Ausführungsanweisung ("fixe Pi 5 und node1 jetzt") ist ein 22 Tage alter Einmal-Auftrag — UNKLAR, ob das bereits erledigt wurde (diese Datei enthält keinen Erledigt-Vermerk).
**Verweise:** [[reference_thesis_git_topology_remotes_overleaf]] (Index: "Git-Topo"), [[feedback_all_projects_dual_remote_github_gitlab]] (Index: "Dual-Remote"), [[feedback_github_flache_out_of_house_sicherung_fokus_gitlab]] (Index: "GitHub flach"), [[feedback_remote_deletion_requires_explicit_user_authorization]] (Index: "Löschung=GO")

---

### 4. feedback_atlas_immer_korpus_gegenpruefung.md
**Thema:** Atlas-Aussagen brauchen Korpus-Gegenprüfung
**Typ:** feedback

**Fakten:**
1. Owner-Zitat, 05.08.2026, verbatim: **"gehe davon aus, dass du den Atlas IMMER nochmal gegenpruefen musst, weil Details noch ungenau sind und nicht ueber die Planung der letzten 6 Wochen gedeckt sind."** — OWNER-WORT (05.08.2026)
2. Fünf Owner-Review-Runden fanden real folgende Fehlerklassen im Atlas: falsche Wurzel (Gattung), falsche Achsen-Zahl, fehlende Binary-Topologie, fehlende Klammern, fehlendes Zukunfts-SOLL, CoR-statt-Strategy — AGENTEN-BEHAUPTUNG (Zusammenfassung vergangener Owner-Reviews, Anzahl "5" so im Text)
3. VERSCHÄRFUNG, Owner-Zitat, 06.08.2026, verbatim-Kern: **"es gibt 3 Versionen dieser UML Zusammenfassung und die letzte ist nicht superseded, sondern nur vorlaeufig und braucht unbedingt immer Verifikation, bevor das geglaubte auch bewiesen ist - die Planung war teils ungenau."** — OWNER-WORT (06.08.2026)
4. Der "05b-Atlas" (REV 5, Kopie in super UND ce) ist als VORLÄUFIG erklärt, nie Beweis-Quelle; jede daraus übernommene Aussage muss am Objekt verifiziert werden
5. Verfahrens-Konsequenz: Atlas-Nachzug nach L1 ist ein VERIFIKATIONS-Pass (IST gegen Behauptung), kein Fortschreibungs-Pass; jede Atlas-Änderung braucht Korpus-Fundstellen je Aussage; Ungedecktes wird als "UNGEDECKT — Gegenprüfung offen" markiert

**Stand:** GILT — **Achtung Description/Fließtext-Lücke**: das YAML-`description:`-Feld nennt nur die 05.08.-Regel, die VERSCHÄRFUNG vom 06.08. (Fakt 3+4, die eigentliche Verschärfung: 3 UML-Versionen, keine gilt als superseded) steht NUR im Fließtext.
**Verweise:** [[feedback_doku_policy_neue_session_docs_ledger_nur_user_technik]] (Index: "Docs+Technik"); zusätzlich Text-Erwähnungen ohne Link: "Posten 91 (Hinweis-Regeln)", Fallen-Lehre "Begriffs-Kanon am Objekt"

---

### 5. feedback_berichte_am_prioritaeten_faden.md
**Thema:** Owner-Rüge — Berichte am Prioritätenfaden erzählen
**Typ:** feedback

**Fakten:**
1. Owner-Zitat, 06.08.2026, verbatim: **"Bitte lies bis zu meiner letzten Nachricht nochmal - du schreibst zusammenhanglosen Mist"** — OWNER-WORT (06.08.2026)
2. Kritisierte Kürzel/Codenamen, wörtlich genannt: NB-2, CX-B1, E-2a, wf_-IDs
3. Vereinbarte Prioritätenreihenfolge zum Zeitpunkt: P0-P4, mit P0 = "Binaries+Messwert-Lager zuerst"
4. Konkreter Einordnungsfehler, der die Rüge auslöste: der "Format-3-Neuanker" ist die Fingerprint-/Skip-Mechanik des Binary-Baus = P0-Substanz — wurde aber wie ein Auswertungs-Nebenschauplatz berichtet

**Stand:** GILT (Verfahrensregel für Berichtsformat, 4 Tage alt)
**Verweise:** [[feedback_todo_stack_lifo_verbose_owner_fragen_vollpersistenz]] (Index: "E-21 LIFO"), [[feedback_wiederanlauf_doktrin_nach_session_abriss]] (Index: "Wiederanl.")

---

### 6. feedback_codex_implements_from_dossier_claude_corrects.md
**Thema:** Codex implementiert aus Dossier, Claude korrigiert
**Typ:** feedback

**Fakten (chronologisch, jede spätere Schicht steht NEBEN der vorigen, nicht anstelle):**
1. Basisregel, User 2026-07-01 (Fable-5-Manager-Modus-Einführung): Claude = MANAGER anderer Modelle; für jede Code-Implementierungsaufgabe (1) ein "unglaublich ausführliches" Dossier (Auftrag, Architektur-Kontext, exakte file:line-Verweise, SOLL-API, Constraints/Verbote, DoD, Test-Erwartungen), Codex implementiert; (2) Claude korrigiert den Codex-Vorschlag danach SELBST — OWNER-WORT (2026-07-01)
2. Parallelitäts-Ergänzung, User 2026-07-01: bis zu **16 Agenten parallel im Hintergrund** bei mcp-codex-Workflows mit ultracode erlaubt, solange DISJUNKT (keine überlappenden Dateien/Module) — OWNER-WORT (2026-07-01)
3. Verbindlich, User 2026-07-03: Codex NIE mehr als einzelnen blockierenden `mcp__codex__codex`-Call — immer über das Workflow-Tool (ultracode), damit mehrere Codex-Aufgaben parallel im Hintergrund laufen — OWNER-WORT (2026-07-03)
4. VERSCHÄRFUNG, User 2026-07-06 (/goal-Nachtrag), verbatim: **"Korrigiere Fehler manuell und ohne codex. Wir verwenden codex nur zur Erstimplementierung um tokens zu sparen."** — Codex AUSSCHLIESSLICH für Erstimplementierung; alle Korrekturen/Bugfixes/Pipeline-Fixes/Nacharbeiten macht Claude SELBST manuell — OWNER-WORT (2026-07-06)
5. RE-BEKRÄFTIGUNG, User 2026-07-07, verbatim: **"Merke dir für das Programmieren von Code, dass du die Erstimplementierung immer zuerst mit codex durchführst"** — gilt für jeden Code-Increment — OWNER-WORT (2026-07-07). Technisches Detail dazu: MCP-Plugin auf prod1 "installiert + funktionsverifiziert" (Marker CODEX_MCP_OK); Aufrufmuster: `sandbox=danger-full-access` (bwrap-Workaround), `cwd` aufs Ziel-Repo gepinnt, `model gpt-5.5` + `model_reasoning_effort xhigh`, `approval never`
6. KLARSTELLUNG, User 2026-07-09 abends, verbatim: **"Ich hatte codex nicht abgelehnt und sonst auch vollständiges GO für alle Punkte. Bitte weiterhin codex als Erstimplementierung versuchen und nur als fallback selbst implementieren — das spart tokens."** Eine im UI abgelehnte einzelne Codex-Tool-Anfrage ist NICHT als inhaltliche Ablehnung des Codex-Einsatzes zu deuten — OWNER-WORT (2026-07-09)
7. ESKALATIONSPFAD, User 2026-07-09: drei Ausgänge je Codex-Lauf — (a) brauchbar → Zeile-für-Zeile-Review + gezielte Abschnitts-Korrekturen; (b) kleinere Verstöße → nur betroffene Abschnitte manuell korrigieren; (c) Komplett-Scheitern → Claude implementiert SELBST vollständig, kein Retry-Loop — OWNER-WORT (2026-07-09)
8. Erweiterung Code-Migration, User 2026-07-07: Codex auch für Migrationen (z.B. #274-Schritte 5-7, Monolith-Splits, #32-Instanz-Repos/Naming-Sweeps) — Arbeitsteilung: (1) Claude bereitet Zielstruktur SELBST vor, (2) Codex migriert in erster Instanz mit elaboriertem Dossier, (3) Claude kontrolliert Zeile für Zeile und korrigiert manuell — OWNER-WORT (2026-07-07)
9. Sicherheits-Constraint (durchgängig): NUR Code-Repos (cache-engine/prt-art/super/thesis), NIE Cluster/keys; `modules/*` + `ext/` bleiben für Codex tabu

**Stand:** GILT in der Summe aller Schichten (Fakt 4 schränkt Fakt 1 ein, Fakt 6 relativiert eine mögliche Fehldeutung von Fakt 5 — keine Schicht hebt eine vorige vollständig auf). Modellangabe in Fakt 5 (`gpt-5.5`+`xhigh`) ist durch die spätere Kette in Datei #7 dieses Bands (`feedback_codex_mcp_always_newest_model_xhigh.md`, Stand 03.08.: `gpt-5.6-sol`+`ULTRA`) ÜBERHOLT.
**Verweise:** [[feedback_codex_mcp_review_before_code_complete]] (= Datei #8 dieses Bands), [[feedback_pair_explore_with_codex_same_investigation]] (existiert auf Platte, NICHT im Index — Cluster-Fund), [[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]] (Index: "CT→RT"), [[feedback_codex_outputs_always_full_manual_review]] (= Datei #10 dieses Bands)

---

### 7. feedback_codex_mcp_always_newest_model_xhigh.md
**Thema:** Codex-Modell/Effort — drei überschriebene Versionen
**Typ:** feedback

**WIDERSPRUCH/KORREKTUR-KETTE — alle drei Schichten wörtlich, in Reihenfolge:**
1. Basis, User-Zitat 2026-07-05, verbatim: **"Bitte stelle codex plugin mcp immer auf das neueste modell und auf xhigh."** — OWNER-WORT (2026-07-05). Konfiguration damals: `gpt-5.5` + `xhigh`, MCP-Registrierbefehl: `claude mcp add codex --scope user -- codex mcp-server -c 'model="<neuestes>"' -c 'model_reasoning_effort="xhigh"'`
2. UPDATE, User 2026-07-10: Default umgestellt auf `model = "gpt-5.6"` + `model_reasoning_effort = "max"` (`~/.codex/config.toml`, "sed-verifiziert") — OWNER-WORT (2026-07-10)
3. KORREKTUR, "literal getestet" 2026-07-10: `gpt-5.6` → **API-400 "not supported when using Codex with a ChatGPT account"**; Effort `max` → **API-400 "Supported values: none/minimal/low/medium/high/xhigh"** — MESSUNG (literal getestet, 2026-07-10). Konsequenz: Rückkehr auf verifiziertes Maximum `gpt-5.5` + `xhigh`
4. NACHTRAG 03.08.2026 (Gegenlese D-06; Owner-Order vom 01.08. "VOLLZOGEN + Smoke-belegt"): Standardkonfiguration seit 01.08. = **`gpt-5.6-sol` + Effort `ULTRA`** (`config.toml` + `~/.claude.json`, Codex-Version **0.146.0**); Fallback-Kette: sol+max → niedrigere Stufen — MESSUNG/AGENTEN-BEHAUPTUNG (Smoke-belegt, referenziert Quelle `feedback_claude_code_arbeitsweise_v2_konsolidiert`, A1-Matrix). Ausdrücklich vermerkt: **die 10.07.-Korrektur "zurueck auf gpt-5.5+xhigh" ist damit VERDRÄNGT.**

**Stand:** AKTUELL GILT Schicht 4 (`gpt-5.6-sol` + `ULTRA`, Codex 0.146.0, seit 01.08.2026). Schicht 1 UND Schicht 3 sind ÜBERHOLT — durch Schicht 4 selbst so vermerkt ("VERDRAENGT"). Diese Datei ist das Referenzbeispiel für "eine Zahl galt, wurde widerlegt, eine neue trat an ihre Stelle" (Config-Wert durchlief 3 Zustände, mit einem harten API-Fehlschlag dazwischen).
**Verweise:** [[reference_prod1_comdare_env_setup]] (Index: "prod1-Env")

---

### 8. feedback_codex_mcp_review_before_code_complete.md
**Thema:** Codex-Cross-Review vor "fertig", Modell/Setup
**Typ:** feedback

**Fakten:**
1. User-Direktive 2026-06-27: bei jeder zukünftigen Code-Aufgabe Implementierungsstand mit Codex-MCP-Agent (`mcp__codex__codex` / `mcp__codex__codex-reply`) gegenreviewen + Feedback einholen, BEVOR die Aufgabe als fertig gilt — OWNER-WORT (2026-06-27, sinngemäß referiert, nicht in Anführungszeichen im Original)
2. Token-Ersparnis-Direktive 2026-06-27: ALLE Review-Aufgaben ans Codex-MCP delegieren (läuft im Cross-Model statt im Hauptkontext)
3. Workflow-Scoping-Regel 2026-06-27: VOR teuren ultracode-Workflows lässt man Codex die Vorarbeit/das Scoping machen (Codex sagt, WO nachzulesen ist) — an Codex dabei nur Task + Datei-/Struktur-NAMEN, KEINE Secret-/Credential-Inhalte; bei reinen Code-Repos auch Inhalte erlaubt
4. Modell-Vorgabe 2026-06-27: Codex IMMER mit `model: "gpt-5.5"` + `config: {model_reasoning_effort: "xhigh"}` (per-call-Override)
5. Text-/Thesis-Regel 2026-06-27: ALLE Änderungen am Diplomarbeit-Text (Kapitel-`.tex`, DE+EN) ebenfalls von Codex gegenreviewen lassen, read-only, `cwd = thesis/diplomarbeit`
6. Session-Start-Ritual 2026-06-27: vor Beginn einer neuen Session Codex den Referenz-Stand der letzten 5 bearbeiteten Sessions zusammenfassen lassen (`docs/sessions/` neueste 5)
7. Sicherheits-Caveat: Codex sendet Code an OpenAI → NUR auf Code-Repos, NIE Cluster-Repo/`keys/`/`machines/`; Setup-Doku-Pfad genannt: `Diplomarbeit - Datenbanken/docs/CODEX-CROSS-REVIEW-SETUP.md`; Codex-Feedback ersetzt KEINE echten Test-Belege

**Stand:** Verfahrensregeln (1,2,3,5,6,7) GELTEN weiter. Fakt 4 (Modell `gpt-5.5`+`xhigh`) ist ÜBERHOLT durch die Kette in Datei #7 (aktuell: `gpt-5.6-sol`+`ULTRA` seit 01.08.2026) — diese Datei selbst wurde seit 34 Tagen nicht nachgezogen.
**Verweise:** [[project_active_goal_directive]] (NICHT auf Platte gefunden — echter toter Link), [[feedback_no_success_marks_without_literal_output]] (Index: "Kein ✓")

---

### 9. feedback_codex_mcp_schreibrechte_mitgeben.md
**Thema:** Codex-MCP Schreibrechte + Git-Timeout-Workaround
**Typ:** feedback

**Fakten:**
1. Owner-Zitat, 06.08.2026, verbatim: **"Weiterhin fragt mich codex staendig um erlaubnis per mcp, bitte in Zukunft die Rechte zum Schreiben mitgeben"** — OWNER-WORT (06.08.2026)
2. Pflicht-Parameter bei jedem `mcp__codex__codex`-Aufruf: `"approval-policy": "never"`, `"sandbox": "workspace-write"`, `"cwd": "<jeweiliger Worktree/Repo-Pfad>"`
3. Gilt für Review-Lenses genauso wie Bau-Konsultationen; Lens-Agenten bleiben trotzdem read-only (committen keine Edits)
4. NACHTRAG 06.08.2026 — Ursache ALLER Codex-Timeouts des Tages, **"reproduzierbar 2/2 belegt"**: lässt man Codex selbst `git diff`/`git log` im Worktree ausführen, hängt der Call zuverlässig bis in den **1800s-MCP-Idle-Timeout** ("sent no response or progress") — trotz korrekt gesetzter Rechte — MESSUNG (06.08.2026, 2/2 reproduziert)
5. Gegenprobe: ein trivialer Shell-Call (`pwd`) im selben Thread läuft in unter einer Minute durch — MESSUNG
6. Diagnose im Text: kein bwrap-Totalausfall, sondern spezifischer Hänger beim Absetzen von `git` durch Codex (Verdacht: Pager-Blockade) — AGENTEN-BEHAUPTUNG (Verdacht, nicht abschließend bewiesen)
7. Verifizierter Workaround: Codex NIEMALS `git` ausführen lassen — stattdessen DIFF-TEXT im Prompt mitliefern, für Zusatzkontext auf Datei-Lesewerkzeuge (kein Shell) im Checkout verweisen; Antwortzeit danach **unter 5 Minuten** — MESSUNG (verifiziert)

**Stand:** GILT, harte technische Messung. Anmerkung: YAML-`name:`-Feld dieser Datei lautet intern `codex-mcp-schreibrechte-mitgeben` (Bindestriche), der tatsächliche Dateiname trägt Unterstriche + `feedback_`-Präfix — dieselbe Datei enthält selbst einen defekten Link (siehe Verweise), vermutlich derselbe Namensmuster-Fehler.
**Verweise:** `[[claude-code-arbeitsweise-v2-konsolidiert]]` — **defekter Link** (Bindestrich-Schreibweise, Datei existiert unter diesem Namen NICHT); gemeint ist mit hoher Wahrscheinlichkeit `feedback_claude_code_arbeitsweise_v2_konsolidiert.md`, das existiert und im Index verlinkt ist ("ARBEITSWEISE"). — Nebenbefund: originSessionId dieser Datei ist `5a19728e-f6e1-4736-a246-e3fda9ac35a1` — identisches Präfix `5a19728e` wie die laufende Job-ID dieses Extraktionsauftrags.

---

### 10. feedback_codex_outputs_always_full_manual_review.md
**Thema:** Codex-Artefakte immer vollständig manuell reviewen
**Typ:** feedback

**Fakten:**
1. User-Direktive 2026-07-05 (Diplomarbeit-Session, während AP-7b), verbatim: **„Bitte merke dir alle Dokumente von codex bitte stets nochmal manuell zu reviewen, sobald es fertig ist."** — OWNER-WORT (2026-07-05)
2. Konkretes Präzedenzbeispiel im Text: Adapter-Naht-Verallgemeinerung breiter als beauftragt bei "S7-1" — dort inhaltlich ok, aber NUR der manuelle Review stellte die Abweichung fest
3. Vier Pflicht-Schritte je Codex-Abschluss vor Commit: (1) jede neue Datei per Read VOLLSTÄNDIG lesen, (2) jede modifizierte Datei per `git diff` im Volltext prüfen (nicht nur grep-Auszüge), (3) bei faithful-Ports Kern-Logik gegen Referenz-Quelle abgleichen, (4) Befunde im Commit-Text dokumentieren ("manuell reviewt: …")
4. VERSCHÄRFUNG, User-Zitat 2026-07-06 (nach der autonomen Nacht-Session auf prod1), verbatim: **„Du hattest laufend entgegen meiner Anweisung vergessen, Codex-Arbeit Zeile für Zeile gegenzuprüfen. Bitte merke dir, das zu tun."** — OWNER-WORT (2026-07-06)
5. Konkreter Vorfall dazu: in der Nacht-Session (06.07., Bezeichner S7-5..10 / AP-15-2/3 / #264 a-c) wurde der Zeile-für-Zeile-Review wiederholt ausgelassen; Ergebnis laut User: inkonsistenter hinterlassener Stand + GitLab-Pipeline lief nicht mehr durch — OWNER-BEHAUPTUNG (referiert)
6. Konsequenz (als "unverhandelbar" markiert): kein Codex-Increment gilt als "done", bevor JEDE angefasste Datei komplett gelesen und JEDER Diff im Volltext geprüft wurde — Auslassen = Increment NICHT fertig, unabhängig davon wie grün die Claims aussehen

**Stand:** GILT
**Verweise:** [[feedback_codex_mcp_review_before_code_complete]] (=Datei #8), [[feedback_codex_uncertain_fallback_to_ultracode]] (=Datei #11), [[feedback_no_success_marks_without_literal_output]] (Index: "Kein ✓"), [[project_diplomarbeit_stand_20260706_comdare_prod1]] (existiert auf Platte, NICHT im Index — Cluster-Fund)

---

### 11. feedback_codex_uncertain_fallback_to_ultracode.md
**Thema:** Codex unsicher → Fallback auf ultracode
**Typ:** feedback

**Fakten:**
1. User-Direktive 2026-07-04: liefert ein Codex-Agent keine sicheren/eindeutigen Ergebnisse (unklarer Befund, §7-STOPP, widersprüchlich, nicht literal verifizierbar), NICHT raten und NICHT die Codex-Ausgabe blind übernehmen — stattdessen auf den ultracode-Workflow (Multi-Agent-Orchestrierung via Workflow-Tool: fan-out + adversariale Verifikation bis Klarheit) zurückfallen — OWNER-WORT (2026-07-04, sinngemäß referiert)
2. Codex-Ergebnisse sind STETS manuell zu kontrollieren; bei Unsicherheit/Nicht-Verifizierbarkeit greift der Fallback

**Stand:** GILT
**Verweise:** [[feedback_ultracode_workflow_for_uncertainty_and_absolute_claims]] (Index: "Unklar"), [[feedback_codex_implements_from_dossier_claude_corrects]] (=Datei #6), [[feedback_codex_mcp_review_before_code_complete]] (=Datei #8)

---

### 12. feedback_comdare_db_and_buildsystem_separate_ledgers.md
**Thema:** comdare-db und Buildsystem — getrennte Ledger
**Typ:** feedback

**Fakten:**
1. Direktive User 2026-07-04: comdare-db und buildsystem-core sind ZWEI VÖLLIG GETRENNTE Systeme mit GETRENNTEN Ledgern; comdare-db NUTZT das Buildsystem nur zum Bauen — OWNER-WORT (2026-07-04, sinngemäß referiert)
2. Begründung: beide Ledger repräsentieren "Millionen Tokens Analyse-Arbeit" — Vermischung entwertet sie
3. Exakte Pfade/Namen: comdare-db = eigenes git-Repo `Products/comdare-db`, GitHub `BenniProbst/comdare-db`, GitLab `comdare/products/comdare-db`; Sessions-Konvention `YYYYMMDD-HH-MM-NNNNNN-*.md` unter `comdare-db/sessions/`
4. Buildsystem-Ledger-Pfad: `cd-buildsystem-construct/Layer1-Foundation/cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md`, Master-Ledger mit Kennungen **T-01 bis T-61**; Buildsystem-Sessions unter `cd-buildsystem-core/docs/sessions/`
5. Integrationsregel bei Berührung beider Systeme (Beispiel: rc→cd in `comdare-db-configure.sh`): Buildsystem-Aspekt ins Buildsystem-Ledger, DB-Code-Aspekt ins DB-Ledger
6. Umzugsregel: additiv umziehen (Zielort schreiben, dann Quellort entfernen), Inhalt wörtlich erhalten

**Stand:** GILT
**Verweise:** [[feedback_text_agent_sessions_belong_in_thesis_not_impl_repo]] (Index: "Sessions→Thesis")

---

### 13. feedback_comdare_products_house_buildsystem_mandatory.md
**Thema:** Hauseigenes Buildsystem für comdare-Produkte Pflicht
**Typ:** feedback

**Fakten:**
1. User-Direktive 2026-07-05 (wörtlich sinngemäß): comdare-web ist — wie auch comdare-db — verpflichtet, die hauseigene Buildsystem-Implementierung statt fremder Build-Tools zu verwenden — OWNER-WORT (2026-07-05, sinngemäß referiert)
2. Konkrete Versionsangabe: `cd-buildsystem-core` **v3.4.15** via `buildsystem.xml`, Produktname `cd-buildsystem-construct`
3. Begründung: das hauseigene BuildSystem führt Lizensierung (comdare-licensing/isLicensed/BEP-EULA) und Code-Optimierung "von Haus aus" mit — fremde Build-Tools verlieren diese Eigenschaften
4. Verfahren: `buildsystem.xml` von Anfang an pflegen, cd-buildsystem-Delegation als offiziellen Produkt-Build in Goal-Text/Ledger/Invarianten verankern; CMake/CMakePresets sind nur Light-/Dev-Unterbau für lokale Iteration, NICHT der offizielle Build-Weg

**Stand:** GILT — Versionsnummer v3.4.15 ist Stand 05.07.2026 (34 Tage alt), könnte inzwischen erhöht worden sein; diese Datei selbst zeigt keine neuere Version.
**Verweise:** [[feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources]] (Index: "C++/Drogon"), [[feedback_baseline_system_in_stein_gemeisselt_layering]] (Index: "Baseline"), [[project_deferred_steuerrater_buildsystem_zenmanagedanalytics]] (NICHT auf Platte gefunden — echter toter Link)

---

### 14. feedback_e14_nofilter_identitaet_und_e4_deep_research.md
**Thema:** E14 NoFilter-Identität GO, E4/17 Min/Max offen
**Typ:** feedback

**Fakten:**
1. Owner-Zitat, 06.08.2026, verbatim: **"die Eingabe ist einfach die ausgabe"** — OWNER-WORT (06.08.2026)
2. Fachliche Einordnung: das NoFilter-Blatt der Filter-Achse (Kennung **T16**) ist die Identitätsfunktion (Eingabe == Ausgabe) — macht den A/B-Nutzen-Beweis der Filter-Achse (gegen filterlos) baubar
3. Status E14: volles GO, Bau im P2-Bau-Fenster als deklariertes Registry-/golden-Ereignis
4. E4/17 (Kennung **T17**, Persistenz-Achsen-Min/Max-Semantik): ist "ratifiziert", ABER die Bestimmung, ob für JEDEN Parameter aus dem Achsen-Interface min ODER max optimal ist, braucht eine DEEP RESEARCH über die Observer (Messparameter-Rückgabe je Interface-Funktion) — Timing: nach Trigger / vor der Auswertung (Phase-6-nah)

**Stand:** GILT (E14 = GO/umsetzbar; E4/17 = ratifiziert, aber Deep-Research-Teil offen)
**Verweise:** [[feedback_gattung_genus_interface_messparameter_achsen]] (existiert auf Platte, NICHT im Index — Cluster-Fund), [[feedback_axes_optimization_semantics_deep_research_observer_strategy]] (Index: "Min/Max")

---

### 15. feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md
**Thema:** Fable-5-xhigh für alles, Opus nur Infra-Ausnahme
**Typ:** feedback

**Fakten:**
1. Owner-Direktive 26.07.2026, im Dokument selbst als **"verbatim sinngemaess"** (also nicht reines Wort-für-Wort-Zitat) gekennzeichnet: **"Bitte merke dir, dass du ab sofort stets Fable 5 fuer Verifikation, Planung und Implementierung verwendest. Du bist CTO und Manager von Fable-5-xhigh-Agenten."** — OWNER-WORT, sinngemäß (26.07.2026)
2. KERN-Regel: alle delegierten Agenten (Planungs-Leser, adversariale Prüfer, Implementierer, Verifikatoren, Backup-/Scrub-Agenten) laufen als **Fable 5**, Reasoning **xhigh**, NICHT als Opus
3. Begründung mit konkretem Vorfall: Opus 5 baute in dieser Session ein Auftrags-Doc mit 3 Achsen-Fehlern — `load_framework` fälschlich als 4. Haupt-Achse; NUMA/page auf reine RT reduziert entgegen dem Dual-Natur-KERN; AVX512 vergessen — dazu voreiliger Bau vor fertiger Planung; Owner-Zitat dazu, verbatim: **"uebernimm von Opus 5, es baut schwerwiegende Fehler"** — OWNER-WORT (26.07.2026)
4. Verfahren: Agent-Tool immer `model: "fable"` (nie `opus`); Workflow-`agent()` explizit `model: 'fable'` setzen
5. AUSNAHME OD-3, Owner-Zitat 26.07.2026 abends, verbatim: **"Fable 5 unterbindet infra Themen generell, das blockiert die API, verwende dafuer immer einen Agenten Opus 5 xhigh, recherchiere gerne die limits von Fable 5."** — OWNER-WORT (26.07.2026 abends)
6. Präzisierung, Owner-Zitat direkt danach, verbatim: **"Infra wird bitte per Handout an den Infra weitergeleitet wenn etwas ansteht."** — Kanal: Infra-Anliegen (Runner-Konfig, GitLab-Admin, Deploy/Token, Cluster-Betrieb) gehen als HANDOUT-Dokument ins Cluster-git (development, gitlab-only, fetch+merge) an den Infra-Agenten — nicht selbst ausgeführt — OWNER-WORT (26.07.2026 abends)
7. Muss dennoch eigenständige Infra-AUSFÜHRUNG delegiert werden: dann `model: 'opus'` xhigh (nie Fable, sonst API-Block der Session); der Fable-Manager plant/verifiziert nur
8. Gilt bis der Owner es ausdrücklich revidiert
9. Explizite Supersession im Dokument selbst: [[feedback_implementierung_an_opus_delegieren_fable_als_architekt]] wird als DURCH DIESE DATEI SUPERSEDED markiert ("nicht mehr Opus, sondern Fable delegieren")

**Stand:** GILT (14 Tage alt, keine spätere Korrektur in diesem Band sichtbar). Datei #6 dieses Bands (Codex-als-Erstimplementierer) behandelt eine ANDERE Achse (welches Modell Code IMPLEMENTIERT = Codex) als diese Datei (welches Modell delegierte Claude-Subagenten FÜHRT = Fable) — kein Widerspruch, aber beide Regeln laufen nebeneinander und sollten nicht verwechselt werden.
**Verweise:** [[feedback_implementierung_an_opus_delegieren_fable_als_architekt]] (existiert auf Platte, NICHT im Index — explizit als SUPERSEDED markiert, klassischer Deprecation-Fund: laut Hausregel "Doku nie löschen" bleibt die alte Datei liegen), [[feedback_vor_und_nach_jeder_aufgabe_ultracode_plus_autonomie_scope]] (Index: "VOR+NACH uc")

---

## Cluster-Beobachtung (bandübergreifend)

Vier Dateien dieses Bands (#6, #8, #10, #11 — alle mit `originSessionId 78cf67f8-...`) verlinken sich gegenseitig und bilden einen geschlossenen **Codex-Workflow-Cluster** (Erstimplementierung → Review-Pflicht → manueller Volltext-Review → Unsicherheits-Fallback). Datei #7 (Modell/Effort-Konfiguration) und #9 (Schreibrechte + Git-Timeout) gehören inhaltlich zum selben Cluster, verlinken aber nicht direkt hinein.

Sechs `[[...]]`-Ziele aus diesem Band wurden auf Existenz geprüft; vier existieren auf der Platte, sind aber NICHT im Index verlinkt — echte Mitglieder des unsichtbaren 57-Dateien-Bestands, liegen aber außerhalb dieses Bands (nicht gelesen, nur Existenz bestätigt): `feedback_pair_explore_with_codex_same_investigation.md`, `project_diplomarbeit_stand_20260706_comdare_prod1.md`, `feedback_gattung_genus_interface_messparameter_achsen.md`, `feedback_implementierung_an_opus_delegieren_fable_als_architekt.md`. Zwei Ziele existieren nicht: `project_active_goal_directive.md`, `project_deferred_steuerrater_buildsystem_zenmanagedanalytics.md`.

Kein Bezug zu Runner-Concurrency oder PMC-Mikroarchitektur in diesem Band — die im Auftrag genannten Beispiel-Funde stammen offenbar aus anderen Bändern.

Härtester WIDERSPRUCH-Fund dieses Bands: Datei #7, die Codex-Modell/Effort-Konfiguration durchläuft drei belegte Zustände (`gpt-5.5+xhigh` → `gpt-5.6+max`, getestet und mit zwei API-400-Fehlern zurückgewiesen → zurück auf `gpt-5.5+xhigh` → am 01.08. abgelöst durch `gpt-5.6-sol+ULTRA`, Codex 0.146.0). Datei #8 zitiert weiterhin `gpt-5.5+xhigh` als geltende Regel und wurde seit 34 Tagen nicht nachgezogen.

---

**Bearbeitet: 15 von 15 Dateien (Nenner: 15, laut band_00).**