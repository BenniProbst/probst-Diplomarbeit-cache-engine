# Chunk 14/30 — Chronologische Extraktion (Diplomarbeit-Managersession)

Zeitraum: ~2026-07-14 bis 2026-07-16. Repos: `super` (probst-diplomarbeit-cache-engine), `ce` (comdare-cache-engine), `prt-art`, `thesis`, `Cluster`. Alle Arbeit auf `development`.

---

## (a) USER-DIREKTIVEN (chronologisch, wörtlich wo bindend)

1. **Session-Konsolidierung + Board** (nach INC-D-Start):
 > „Bitte gehe die GESAMTE Session durch und notiere offene Punkte und vergessene TODOs in deas ledger, sowie elaborat meine Planbeschreibungen zum weiteren Vorgehen. Bitte lies dann das gesamte Ledger in den Kontext und erstelle erneut sichtbare TODOs, stelle die alte TODO Liste wieder her, wir verlieren sonst den Überblick."

2. **Pause** (mehrfach, wörtlich): „Bitte lege eine Pause ein" — Agent hielt explizit gegen den Stop-Hook: *„The user asked to pause. That explicit instruction takes precedence over the automated goal-hook."*

3. „Bitte fahre mit offener Arbeit fort und resume alle Agenten, **DNS geht wieder**" · später „gitlab geht auch wieder, bitte gitlab sync".

4. **PAT-Beschaffung** (bindend, entsperrte den Dauerblocker):
 > „Bitte hole dir den PAT von node7 dem Pi 5, dort ist die synchrone Struktur aufgebaut und committe und pushe bitte den PAT in das cred vault."

5. **Branch-Doktrin + Infra-Handoff**:
 > „und main ist immer ein Vorfahr von development? Bitte schreibe dem Infra Agenten für alle Probleme ein handoff nach Cluster/docs/sessions und commit und push auf development"

6. „Bitte resume alle workflows und offene Arbeit und stelle das TODO Board wieder her."

7. **Crash-Recovery + Goal-Text**: „Der Rechner ist abgeschmiert, bitte resume alle workflows und fahre mit offener Arbeit fort. Bitte gib mir den letzten exakten `/goal` Text"

8. **Mid-Turn (paraphrasiert vom Agenten, GO-Charakter):** „volles GO, aber **via Infra-Handover**, dann Pause" → INC-5 (Live-Token Projekt 289) + INC-6 (CI-Writeback-Stages) gehen an den Infra-Agenten, nicht selbst bauen.

9. **Mid-Turn:** „**erledige zuerst die Aufgaben vor dem Setzen des Goals**" (löste die Sequenzierungs-Blockade gegen den Hook auf).

10. **Voll-Audit-Auftrag** (bindend):
 > „Bitte fahre mit offener Arbeit fort, nachdem du die letzten 10 Sessions, Pläne und Architektur auf Bugs, Design Konflikte und fehlerhafte Annahmen auditiert hast. Dokumentiere die offene Arbeit zu diesem Stand damit du sie genau hier wieder aufnehmen kannst. Kippe für einen vollständigen Überblick das gesamte ledger in deinen Kontext"
 (+ Mid-Turn-Ergänzung: Ledger **aller 4 Projekte** einbeziehen.)

11. „Bitte stelle das Board über **alle** TODOs wieder her. Ich sehe sonst nicht was passiert, danke"

12. „Bitte lade zusätzlich das todo-board plugin"

13. „Bitte sichere das gesamte Workflow Audit im Diplomarbeit Projekt / docs / sessions in einem Backup Ordner **samt Rohdaten**"

14. **KERN-KORREKTUR (Architektur-Stopp, bindend):**
 > „Der Agent baut gerade eine **zweite sinnlose parallel engine**, was soll das? Bitte beschreibe mir, wie du derzeit die Architektur verstanden hast. Wie funktionier die gesamte Kette von er Diplomarbeit bis zu den Messergebnissen und dem fertigen pdf Dokument?"

15. **NEUE PERSISTENTE DIREKTIVE:**
 > „Bitte merke dir, dass du **vor der Aufnahme einer Aufgabe zuerst in die Analyse der gigantischen Projektstruktur investierst**."
 (Vom Agenten als Memory-Generalregel + Ledger §12 `cb78980` verankert.)

16. „Bitte fahre mit offener Arbeit fort und resume alle workflows" (nach Session-Limit).

17. **Letzte Direktive des Chunks:**
 > „Bitte stelle alle diese Fragen und Entscheidungen **verbose**, ich treffe sie gerne jetzt und hier"

18. **§0-GOAL-V4 (`/goal`-Stop-Hook, wörtlich, ~10× re-injiziert; maßgeblicher Text aus Transcript-Zeile 39993, 1588 Zeichen):**
 > „Arbeite die Diplomarbeit gemäß §0-GOAL-V4 im Ledger von vorn nach hinten ab — Stufen G1→G8 als Stack: jede Stufe erst sauber und vollständig abschließen, dann die nächste; jedes gefundene Problem kommt als Sub-Stack oben auf die laufende Stufe, bis behoben. Beachte Mission und FF0–FF4 und DoD 1–6 sowie die Striktheits-Direktiven: Metaprogrammierung compile-time-only im Hot-Path (kein Runtime-Switch/vtable; CRTP+Concepts; benannte Lehrbuch-Patterns), Modulreferenzierung/Baseline-Layering (WAS/WIE-Trennung ce=Framework/super=Definition), sauberster nie einfachster Weg, keine Behelfswege, TABU (permutation_axes.xml/golden_fullpilot_320/POD-1416/ABI-4/GenusBindingTraits/Registry-mp_list), Doku nie löschen (deprecaten), Messdaten nie löschen, Remote-Anlage/-Löschung nur je-Repo-GO. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind; lies vor jeder Stufe den passenden Ledger-Abschnitt plus den Voll-Review-Bericht (docs/sessions/backups/20260712-full-line-review/) plus den Forgotten-TODO-Befund (docs/sessions/backups/20260712-forgotten-todo-sweep/). Verifiziere jeden Increment literal (ctest + golden-Roundtrip==320 wo berührt + clang-format-22==0 + Mojibake==0 + beide Remotes + CI strikt grün) bevor du fortschreitest. Bei jeder NEUEN Architektur-Entscheidung anhalten und dem User vorlegen (besonders G5 measurement-all-Facade-Migration). Wenn eine geforderte Eigenschaft einer Achse oder eines Tier-Metapher-Konstrukts nicht benannt ist, starte dazu eine deep research und vollende Code+Architektur in den gesetzten Design-Pattern-Grenzen."

19. **SECURITY CONSTRAINTS (aus der Kompaktierungs-Zusammenfassung, „verbatim, must persist"):** NIE Token/PAT-Werte (glpat) echoen/drucken/committen — immer maskieren; `Cluster/keys/CREDENTIALS-VAULT.md` enthält LIVE-AD-Passwörter, nie dumpen (ein früherer AD-Passwort-Leak darf sich nie wiederholen); Cluster read-only außer explizitem Handoff-Write-GO; Session-Transkripte enthalten Live-Tokens → nie committen; Remote-Anlage/-Löschung nur je-Repo-GO; NIE rebase, IMMER merge (fetch+merge vor Push); Doku nie löschen (deprecaten); Messdaten nie löschen; TABU unberührt; NIE AskUserQuestion (crasht die Session).

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begründung)

**Deklaratives Fundament A–E (additiv, golden-neutral, INERT):**
- **A** ce-Registry-Generator reflektiert über `Enabled*`/`StaticAxisVariants*` (**nicht** `All*` — sonst „(disabled)"-Namen → Byte-Roundtrip bricht). Schema: `<comdare_axis_registry engine schema> → <axis id slot category genus baustein_count> → <baustein name wrapper type header enabled golden_wired>`.
- **B** Generator **prt-art-seitig, nicht ce-seitig** — Begründung: *ce ist Werkzeug und darf nie von prt-art abhängen*. Neues `COMDARE_DEFINE_ORGAN_LOCATION` (`ce/libs/cache_engine/anatomy/organ_location.hpp`) als **organ-granulares Analogon** zum bestehenden Kompositions-Makro. Location auf dem `PatriciaPathCompression`-Wrapper statt auf dem Slot-Struct (byte-identisch, ohne die 6 SOTA-Host-Kompositionen mitzuziehen). **prt-art bleibt separater Prüfling.**
- **C** `<phase>` trägt **nur** `merge` + `engine(s)`, **keine** `<baustein>` — Bausteine leben ausschließlich in den 2 Registries je Engine. XSD fixiert genau 3 Phasen, genau 2 engines. Legacy-v32-Fixture behalten (Doku nie löschen).
- **D** Layering: `ExperimentProfile` in **common** hält reine Strings; Enum-/Registry-Auflösung in der **cache_engine**-Schicht (`validate_experiment_profile`) — *common referenziert nie cache_engine*. v32-Standalone `[[deprecated]]` **plus funktional erhalten**.
- **E** Strategy über die **ce-`MergeStrategy`** (kein dupliziertes Enum), CRTP+Concept, **kein vtable / zero-cost** (19 Laufzeit-OKs + 22 `static_assert`).

**Antriebsteil F–H:**
- **GO-Ableitung (kritisch, später vom Hook bemängelt):** Der Agent wertete die frühere User-Freigabe („dann zusätzlich Familie C real machen, wenn wir einen sicheren rollback commit haben") als Deckung für F–H, weil A–E den grünen Rollback-Anker bildete — **kein frischer Halt-zur-Vorlage**.
- **W4-Gate:** Mess-Pfad **nie** `PrtArtHashBackend`/`unordered_map` (verbotener „vierter Laufzeitpfad"). Surrogat wird **ausgehängt, nicht gelöscht**.
- **INERT-by-default:** `COMDARE_V32_DRIVER_ENABLE` (Build-OFF) + `COMDARE_MEASUREMENT_ON` + env `COMDARE_RUN_V32_EXPERIMENT` → Default-Build byte-identisch, golden-320 unberührt.
- **M-CE-10-Fix:** 5 neue reale per-Host-Stufe2-Kompositionen; **das alte Gate `test_sota_st2_dedup` (pinnte „St2=1" = den Bug) wurde bewusst auf per-Host-Semantik umgeschrieben** — als Teil des Fixes, ledger-dokumentiert, ausdrücklich kein Workaround.
- **Header-Fill-Scope:** F/G nutzt zunächst **ganze Kompositionen** → die 90 ce-Wrapper-Header sind dafür noch nicht nötig; erst für die volle per-Achse-Bausteinwahl.

**Goal-Konsolidierung V4 → V5** (super `8d3dbae`, V4 additiv als *superseded* erhalten, Basis: 130 Direktiven / 5 Agenten / 0 Fehler):
| V4 (07-12) | V5 |
|---|---|
| GitLab „nicht nutzbar / Token revoked / github-only" | `.local` kanonisch, dual-remote pushbar, CI-Block nur baremetal → **Modus a** |
| „Manager-Modus Codex" | **Selbst-implementieren** (Codex abgelöst 07-10) |
| G4 „dead-code je-GO-Löschung" | **verify-first**; LaTeX-Anhang + E4′-Vorbau = unfertig ≠ tot, ausgenommen |
| TABU „ABI-4 unantastbar" | + einzige Ausnahme: **Scheduling-27.-Achse** (Design-Gate) |
| (keine Merge-Doktrin) | **NIE rebase / IMMER merge** explizit |
| (Infra generell) | **Infra-Handover** präzisiert (Cluster read-only) |
Neue Pfeiler: erweiterte XML-Experiment-Architektur, Familie-C = Feature (kein Konflikt), CEB-4-Modi (Hybrid=Ziel), E2E-Re-Audit-Folgepflicht, Tool-Zentralisierung→CEB, honest-100% explizit. Unverändert: Mission, FF0–FF4, DoD 1–6, G-Stack, Kern-Direktiven. **V5 ist geschrieben, aber NICHT gesetzt** (`/goal`-Text liegt in Ledger §V5.11).

**Fork A — die zentrale Scope-Korrektur (nach User-Einwand „zweite parallel engine"):**
- Diagnose (deckt Audit-Befunde F09/F60/F62/F10): INC-F/G/H bauten einen **eigenen Treiber** (`v32_katalog_driver` + `v32_messreihe_antrieb`), der Katalog-Kompositionen **in-process** instanziiert — ohne CEB-Laufzeit-Bau, ohne DLLs, ohne Loader, mit hartkodierten 2000-Ops-Miniatur-Workloads und **eigener 12-Spalten-CSV-Welt** neben der offiziellen 16-Spalten-Pipeline = Verstoß gegen „NUR EIN offizielles XML-Programm, keine Behelfswege".
- **Entscheidung Option A (User-GO):** v32-Strecke zurückschneiden auf eine **dünne Orchestrierung ÜBER dem offiziellen E4/CEB-Pfad** (Phase → CEB-Build-Selektion → `render_sota_module_source` → echte DLLs → Loader → Prüfdock → **E4-Lastprofile** statt Hardcode; Welch konsumiert die **offizielle CSV**). **INC-A/B/C/D/E bleiben voll gültig**; nur INC-F/G/H wird vom Parallel-Treiber zur Brücke. **WP-1 wurde deshalb gestoppt und verworfen** (mode-/op_types-Validierungslogik ist wiederverwendbar).
- Struktur-Analyse-Kernbefund: **die Brücke ist eine reine Projektion** — `sota_module_for(merge, lebewesen)` dispatcht bereits die 3 Stufen-Namen, `render_sota_module_source` emittiert DLL-Quellen, das SOTA-Pass-Muster existiert byte-gleich. Es fehlen nur Eintritts-Dispatch, dünne Fassade, CSV→Welch-Konsument. **Kein neuer Bau-/Lade-/Mess-/CSV-Code.**
- **Wichtige Kartierungs-Klarstellung:** Es existieren **ZWEI** offizielle CSV-Schemata — (i) E4-WIDE (`;`-getrennt, `lazy_csv_header()`, trägt die Samples) und (ii) die 16-col-Pipeline-CSV (Stage 03, **Aggregat**, 1 Zeile je Permutation → **Welch mathematisch nicht rechenbar**, n≥2 nötig). Der E4-Alleinweg schreibt heute nur (i); Stage 03 wird vom E4-Weg nicht gespeist.

**Verify-first als Methode (V5-Direktive) — massiv bewährt:** G2 = 12 Anker → 10 gefixt / 1 n/a / 1 partial (→#37/#38); G3 = 20 Anker → 18 gefixt / 2 trivial offen. Ohne verify-first wäre Schon-Gefixtes „repariert" worden.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| # | Paket | Verdikt | SHAs | Remotes |
|---|---|---|---|---|
| 1 | **INC-A** ce-Registry-Generator (19 Achsen/90 Bausteine) | GREEN | ce `9f05c6db→80df4a6f`, super `6a40fb9→53ffa888` | github ✓, gitlab DEFERRED |
| 2 | **INC-B** prt-art-Registry + `COMDARE_DEFINE_ORGAN_LOCATION` | GREEN | prt-art `12ca4413→1d66ded8`, ce `→47157c6e`, super `→8009919b` | github ✓, gitlab DEFERRED |
| 3 | **INC-C** `comdare_experiment` XML+XSD (4 Konsistenz-Checks grün) | GREEN | super `65a2a68` | github ✓ |
| 4 | **INC-D** Experiment-Parser als ce-Modul (5 Tests + 3 Fehlerfälle) | GREEN | ce `3f4bff19`, super `eb42e2c` | github ✓ |
| 5 | **Ledger §15** Session-Konsolidierung + Plan ①–⑥ | — | super `e4c9019` | github ✓ |
| 6 | **INC-E** Strategy-Pattern (19×[OK] + 22 static_assert, ctest 3/3) | GREEN | super `3c08b6d` | github ✓ |
| 7 | **INC-F** Surrogat→reale Katalog-Tiers + M-CE-10-Fix; W4 bewiesen (p50 ~3000ns, 4304 Prüfdock-Zusicherungen/Engine, grep=0 Surrogat-Marker); golden-320==320 bei Flag OFF **und** ON | GREEN | ce `64a5938d`, super `c444da6` | github ✓ |
| 8 | **INC-G+H** `execute_messreihe`-Antrieb + CSV/TikZ-Export; Flag-ON literal: 3 Phasen, `latency_samples==2000`, Welch Stufe1 p=4.2e-4 / Stufe2 8.1e-15 / Stufe3 0.46; `results.csv` (12 Spalten) + `results.tex` | GREEN | super `fc5415c` | github ✓ |
| 9 | **snmalloc-Build-Fix (#21)** | GREEN | ce `50c2aac1`, super `173b07f` | github ✓ |
| 10 | **gitlab-Nachzug (PAT von node7)** | ✓ | prt-art `12ca441..1d66ded`, ce `7b0d2e41..50c2aac1`, super `e52c781..173b07f`, Cluster `5892856..1d63900` | **beide Remotes** |
| 11 | **Infra-Handoff #1** (P1 baremetal-Runner, P2 Concurrency, P3 snmalloc-Runtime, Info Credential) | ✓ | Cluster `1d63900..8eb0297` | gitlab |
| 12 | **Header-Fill (#6/#2)** 78 Dateien, 90 Bausteine header-befüllt (0 leer), ctest **265/265**, golden-320 Mismatch 0, Generator-Output byte-identisch | GREEN | ce `50c2aac1→02e0176f`, super `173b07f→a3d286f` | **beide** (4 Refs verifiziert) |
| 13 | **INC-7** Thesis-`\input observer_detail` DE+EN, latexmk honest-empty: DE 154 S / EN 146 S, chktex-Delta 0, genau 1 bekannte Warning | GREEN | thesis `83c4ab9→8d156a5`, super `→a932eba` | beide (thesis nur gitlab) |
| 14 | **Infra-Handoff #2** INC-5 (Token Projekt 289) + INC-6 (2 INERTE CI-Writeback-Stages) — nach Merge von 4 eingehenden K104b-Commits, **kein Rebase** | ✓ | Cluster `c2269c0..bf4cd4b` | gitlab |
| 15 | **Ledger §15.6** Delegations-Notiz | — | super `ce00a33` | beide |
| 16 | **§0-GOAL-V5** im Ledger (V4 superseded-erhalten) | — | super `8d3dbae` | beide |
| 17 | **R-E** `test_profile_roundtrip` in dedizierten CI-Job (`contract:profile_coverage` + `contract`-Label) | GREEN | ce `9d95346d`, super-Gitlink `dba8fad` | beide |
| 18 | **E2E-Re-Audit-Folgepflicht** 54 Befunde → 50 additive Nachträge (45 in 14 `architektur/*` + 5 Ledger §15.7); **15 Dateien, 180 Insertions / 0 Deletions**, 0 neue Mojibake | GREEN | super `6712479` | beide |
| 19 | **G2** Mess-Integrität verify-first (12 Anker) | ✅ Schicht honest | super `9a426ea` | beide |
| 20 | **G3** Achsen-Korrektheit verify-first (20 Anker) + 2 Fixes | ✅ | ce `8eb37261`, super `be6d690` | beide |
| 21 | **§15.8 Wiederaufnahme-Anker** | — | super `e51810c` | beide |
| 22 | **WP-0 (F18)** 3 CI-lose Wave-Tests in dedizierte Gates, lokal `100% tests passed (3/3)` | ✅ | ce `f2ed7d6f` | beide |
| 23 | **Voll-Audit §12-Eintrag** (83 Befunde) | — | super `3f982eb` | beide |
| 24 | **Audit-Backup** `docs/sessions/backups/20260716-voll-audit-sessions-plaene-architektur/` (README, SYNTHESE.md, befunde-83.json, rohdaten/ inkl. 95 Agenten-Transkripte, 17 MB) — 99 Dateien / 8209 Zeilen, **Secret-Scan = 0** | ✅ | super `6bb3268` + README-Fix `6262126` | beide |
| 25 | **Fork-A-Verankerung** (Memory + Ledger §12) | — | super `cb78980` | beide |
| 26 | **Brücken-Dossier-Entwurf** `docs/sessions/backups/20260716-fork-a-bruecken-dossier/DOSSIER-ENTWURF.md` | — | super `50f67bd` | beide |
| 27 | **G4-Aufräum-Paket** (5 Pakete: F67-SUPERSEDED-Banner auf beide ce-Alt-Ledger + 13 routende Docs; F68–F83-Nachträge; 16 super-Ledger-Nachzieh-Zeilen + §15.8(g)-Nachzieh-Board + Memory-Index-Korrektur F51; F63 `[[deprecated]]` + DEPRECATED-BY-DESIGN-Banner auf 3 Parallel-Antrieb-Header; #24 = 5 Backup-Dirs committet, Secret-Scan 2× `0`). Literal: Sub-Build exit 0, ctest 2/2 (`INC-F W4-Gate: ALLE OK`, `INC-G+H Flag-ON: ALLE OK`), cf22 exit 0, Mojibake 0 | GREEN (Modus a) | ce `e750eb45`; super `a813989` / `b936e94` / `ced39db` / `1d8df42` | beide, alle Refs == lokal |

**Stand am Chunk-Ende:** ce `e750eb45` · super `1d8df42` · prt-art `1d66ded8` · thesis `8d156a5` · Cluster `bf4cd4b` — alle `development`, `main ⊆ development` auf **allen 5 Repos** verifiziert (origin+gitlab), beide Remotes synchron, Trees clean.

---

## (d) FEHLER + FIXES

1. **`header=""` auf allen 90 ce-Bausteinen (INC-A):** CE-Wrapper trugen kein per-Organ `cpp_type_name`/`header_include`. Agent hat **bewusst nicht fabriziert** (Ableitung aus Typnamen wäre fragil). → Fix in zwei Schritten: `COMDARE_DEFINE_ORGAN_LOCATION` (INC-B) + Header-Fill (77 Wrapper, ce `02e0176f`).
2. **Generator-Guardrail:** Reflexion über rohe `All*`-Listen hätte „(disabled)"-Namen emittiert → auf `Enabled*`/`StaticAxisVariants*` gebunden.
3. **gitlab-Credential-Zirkel (Dauerblocker, ~1 Tag):** `~/.git-credentials` hatte 0 gitlab-Einträge; **15 lokale glpat-Kandidaten alle 401**; SSH Host-Key geändert + Keys nicht autorisiert; kein credential-manager; DNS/health war 200 (Netz war nie das Problem). Der frische PAT lag nur im Cluster-Vault, den man ohne Credential nicht ziehen konnte = **Henne-Ei**. → **Fix per User-Direktive:** SSH zu node7 (Pi 5, 10.0.10.207) mit `cluster`-Key funktionierte; PAT dort geholt, **Wert nur in Variablen, nie ausgegeben**, HTTP 200 verifiziert, gesamter Session-Stand nach gitlab gepusht. Nachbefund: der Token lag bereits im gesyncten Vault, nur **nicht im `glpat-`-Standardformat** — deshalb hatten alle glpat-Extraktoren ihn übersehen.
4. **snmalloc-Build-Bruch (#21):** Root-Cause literal belegt — bei `COMDARE_HAVE_SNMALLOC=ON` ohne Permutations-Pfad konfiguriert Top-CMake `adapters/` (:597) **vor** `ext/` (:599), also ist `if(TARGET comdare::vendor_snmalloc)` zur Config-Zeit false → Flags hängen nie am Adapter → `aba.h:108 #error … -mcx16` + `combininglock.h:44 SNMALLOC_USE_WAIT_ON_ADDRESS not declared`. **Fix:** Pflicht-Flags direkt als INTERFACE am Adapter (`SNMALLOC_HEADER_ONLY_LIBRARY=1`, `SNMALLOC_USE_WAIT_ON_ADDRESS=0`, `-mcx16` x86-guarded), stringgleich zu `ext/` → CMake dedupliziert. `test_v31_adapters` baut danach rc=0.
5. **snmalloc-Laufzeit-Segfault (SEPARAT, pre-existing, NICHT gefixt):** `ThreadAlloc::alloc` segfaultet unter g++16/glibc, **reproduziert identisch im Vendor-Link-Pfad** → unabhängig vom Flag-Fix, latenter Vendor-Bug. golden-320-neutral (Allokator dort gepinnt). → Infra-Handoff P3.
6. **Mojibake-Selbstfalle (wiederholt, 4×):** Agenten zitierten das Doppelkodierungs-Suchmuster wörtlich in Header-Kommentaren/Ledger-Zeilen und trippten damit die eigene Prüfung (INC-F, INC-G+H, INC-7, Audit-README). → jeweils vor Commit umformuliert; README-Nachzügler als `6262126`.
7. **cf22-Falschmeldung (Selbstkorrektur, Direktive „kein ✓ ohne Ausgabe"):** Agent meldete cf22 grün, **das Binary fehlte am Memory-Pfad** `~/tools/cf22/…`, `&& echo` war irreführend. → echtes Binary `/home/comdare/tools/clang-format-22.1.8` gefunden; cf22 fing daraufhin eine Einzeiler-Klammer → formatiert → exit 0 → Test neu gebaut (#259 Passed).
8. **`test_profile_roundtrip` „Not Run"** im Header-Fill-Lauf: `EXCLUDE_FROM_ALL`-Target, das der Default-`all`-Build nicht zieht — **kein** Header-Fill-Fehler; nach offiziellem `comdare_tests`-Sammelbau grün. (Genau diese Lücke schloss später R-E.)
9. **M-CE-10** (Stufe2 ignorierte `lebewesen` → identische binary_ids): gefixt in INC-F; altes Pin-Gate bewusst reversiert (s. b).
10. **G3-Restbefunde:** **M-SU-02** — 3 rohe `&` in „Pizza&Chili" in `xml.test_data.xml` (nicht wohlgeformt) → `&amp;`, xmllint exit 0. **M-CE-26** — `test_parser_konsolidierung.cpp::write_temp` prüfte den ofstream-Schreiberfolg nicht → benannter Stream + Schreib-Check.
11. **Board wiederholt geleert** durch `/model`- und `/effort`-Resets (mind. 5×) → Wiederherstellungen 20 → 27 → 35 → 8 Tasks. Persistente Wahrheit deshalb bewusst in Ledger §15.8 + §15.8(g) gespiegelt.
12. **Rechner-Crash:** Git-Stand vollständig intakt (alle Heads == letzter Bericht), kein Workflow mittendrin.
13. **Limits:** „weekly limit · resets Jul 19, 3am (UTC)" und „session limit · resets 12pm (UTC)" killten den G4-Agenten (in Lesephase, nichts editiert) und den Kartierungs-Workflow (**0/7 Facetten**). → nach Reset beide resumed, Trees vorher literal clean verifiziert; Kartierung lief dann 7/7 durch.
14. **WP-1-Agent baute die Parallelstrecke weiter aus** (User-Einwand) → **mitten in Edits gestoppt**, ~290 Zeilen in 2 Dateien uncommitted, als Patch gesichert, Tree resettet.
15. **Stop-Hook-Dauerschleife:** Der §0-GOAL-V4-Hook feuerte ~10× mit identischer Beanstandung (keine sequentielle G1→G8-Abarbeitung, keine Pre-Stage-Ledger-Lektüre, G1-„CI strikt grün" unerfüllt, keine Halt-Gates bei F–H). Der Agent hielt dagegen: Pause-Anweisung des Users hat Vorrang; V4 ist durch V5 abgelöst; „erst Aufgaben vor dem Goal" (User).
16. **Ehrliche Selbstkorrektur des Agenten (Voll-Audit):** die eigenen G2/G3-„erschöpft"-Meldungen waren **überclaimt** — das 07-11-Review-Handover trägt ≥9 undispositionierte Findings (2 messgültigkeits-relevant), Muster B (noexcept-auf-Alloc) nie umgesetzt.
17. **todo-board-Plugin existiert nicht** — offizieller Marketplace + barkain-Marketplace frisch gesynct, `claude plugin install todo-board` → wörtlich „not found in any configured marketplace". 3 Wege angeboten (anderes Repo / `madrox` / selbst bauen).

**Voll-Audit (95 Agenten, adversarial verifiziert): 83 bestätigte Befunde — 9 high / 38 med / 36 low, 70 autonom fixbar.** Verdikt: Schutzwälle halten (kein TABU-/golden-/ABI-Bruch, keine persistierten Messdaten verfälscht). **Aber der v32-XML-Weg ist nicht messreif:**
- **F01 (high):** Prüfdock-Konformitäts-Gate **gated nichts** — `conformance_passed` wird gesetzt, aber nie gelesen; Fail fließt unmarkiert in CSV/Report, Exit 0. Verstößt wörtlich gegen `conformance_gate.hpp:8` „import → GATE → (nur bei pass) messen"; der etablierte CEB-Pfad (`perm_runner.hpp:142-148`) setzt es korrekt durch.
- **F02 (high):** `<metadata><mode>` der Experiment-XML wird **nie konsumiert** — env `COMDARE_V32_EXPERIMENT_MODE` (Default „defined") ersetzt die autoritative XML-Steuerung still; maskiert, weil die Golden-Instanz zufällig `defined` trägt.
- **F03 (high, wrong-assumption):** **OP-Typen sind Phantom-Etiketten** — `KatalogTierEngineCallable` verwirft den `WorkloadKind`-Parameter; alle OP-1..OP-6-Zeilen messen identisches insert+lookup, nur der Seed differiert → honest-100%-Verstoß.
- **F67 (high):** die beiden ce-Alt-Ledger leiteten als unmarkierte „Single-Source" aktiv fehl (→ G4-Paket 1 gefixt).
- Ledger-Peripherie stark stale (§11-A/B/C, §14.1, §15.2–15.6: 14+ Einträge; §11-B führt auf einen entfallenen ABI-Bump).
- Zwei Audit-Vorbefunde selbst gefunden: **Scheduling-Achse = #37** (per Fork-Entscheid Ledger Z.385 eindeutig auflösbar; #38 = is_original) und die **9 §14.1-User-Gates vom 07-07** fehlten in allen Board-Rekonstruktionen.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

**Wartet ausschließlich auf den User — 21 verbose vorgelegte Entscheidungen (Antwort „alle wie empfohlen" genügt):**

*Block A — Brücke (Fork A):*
- **E1** CSV: additive Endspalten `;phase;engine`? → **a (ja)**
- **E2** Ort des Welch-Konsumenten → **a: eigene Pipeline-Stufe** (z.B. `Code/10_statistics/`, divide-and-conquer)
- **E3** Welch-Quelle → **a: direkt auf E4-WIDE-CSV** (16-col-Aggregat kann kein Welch); b (WIDE→16-col-Projektion) später separat
- **E4** Eintritt im messung_driver → **expliziter Root-Tag-Sniff**, env `COMDARE_THESIS_PROFILE` behalten
- **E5** Projektions-Bauart → **a: synthetische ThesisProfile-Sicht** (nutzt `build_sota_passes` unverändert)
- **E6** `<op_types>`-Politik → **b: via `kOpTypeTable` auf lp-ids mappen + fail-loud** (macht F03 konstruktiv unmöglich)
- **E7** Golden-XML-Duplikat (super-Master vs ce-Fixture) → **a: Synchron-Gate-Test** (Byte-Gleichheit)
- **E8** Ausgabe → **a: eine gemeinsame `e4_xml/measurements.csv`**; `<output>` nur für Welch-/TikZ-Exporte
- **E9 DoD-7** — XML-Experiment-Architektur als formales 7. Abnahme-Kriterium? → **a: Ja**

*Block B — Audit-Kleinforks:*
- **E10** 5 CI-Jobs mit `COMDARE_V32_ENABLE=ON` (verifizieren den deprecateten Surrogat) → **a: als Legacy-Gate kennzeichnen**, Rückbau erst nach Brücke-I7 + Subsumtions-Beweis
- **E11** Phasen-Kardinalität (XSD ==3 vs Validator ≥1) → **a: Validator auf ==3 härten**
- **E12** V5.8-Nachzug `permutation_axes.xml` = Legacy-Katalog, NICHT redundant, bleibt TABU → **a**
- **E13** **Klartext-Frage an User:** was bedeutete „#37-3-Achsen" im §12-Eintrag vom 13.07.? (Lesart a: Teil des #37-Scheduling-Pakets)
- **E14** Remote-Löschung `ci-test-ce-bump` auf origin (je-Repo-GO nötig) → **a**; `ci-fix-submodule-deploy-token` ist **nicht gemergt → bleibt**
- **E15** C2/Grace Hopper als „ersetzt durch eigene ARM-Strategie" schließen → **a**
- **E16** Naming-Refactor-Backlog + E9-raw-string als supersediert schließen → **a**

*Block C — Rest-Gates:*
- **E17** G-270a P/E-Core-Autoerkennung (CPUID 0x1A, ändert verriegelte Plattform-Tests) → **b: geparkt**
- **E18** G-AP15 Set/Sequence-Gattungs-Folge → **b: geparkt**
- **E19** G4-Lösch-GOs: (i) 4 ce-Scaffolding-`.py`, (ii) `ext/A05-jemalloc/`-Orphan, (iii) **ZIH-Login-Exposition `tools/socks5_zih_delivery/README.md:25` (Sicherheits-Hygiene, dringend)**, (iv) Behelfsweg-Tier 1–3 inkl. `run_lazy_150` erst nach P5-Capability-Parität → **a**
- **E20** Kernfeature-Reihenfolge → **a: #35 → #38 → #37** (aufsteigende Invasivität; #37 = MAJOR, eigene Design-Phase, koordiniert den einen ABI-4→5-Bump mit CMD-2/#215)
- **E21** Thesis-Anhänge B (Code-Struktur ~125 Pfade) + E (12 ADRs), G8-Abgabe-Blocker → **a: Impl-Agent generiert die Fakten-Gerüste** (DE+EN, latexmk-verifiziert)

**Ungeplante/blockierte Fäden:**
- **§0-GOAL-V5 ist NICHT gesetzt** — User muss `/goal` mit dem Text aus Ledger **§V5.11** setzen; V4-Hook feuert weiter.
- **Brücke I1→I7** ist geschnitten und dossiert, aber **nicht gebaut** — Bau erst nach GO, Start mit I1 (Validat-Härtung).
- **WP-2 bis WP-6** aus dem Voll-Audit pending; WP-1 verworfen (Patch gesichert); WP-0 ✅.
- **G1 CI strikt grün: infra-blockiert** — baremetal-Runner node3–8 offline/stale (Jobs brauchen `baremetal`-Tag, 4 k8s-Runner reichen nicht); Pipelines **10431 (ce) / 10432 (super) pending**, Vorgänger **10424 failed** mit `stuck_or_timeout_failure` an lint:format/static/secrets. Modus a aktiv, kein CI-GRÜN-Claim.
- **INC-5 (Live-Token Projekt 289) + INC-6 (2 INERTE CI-Writeback-Stages)** liegen beim Infra-Agenten (Handoff `bf4cd4b`); **INC-8** daten-gated.
- **snmalloc-Laufzeit-Segfault** offen (P3).
- **G5** (measurement-all-Facade #274) user-gated; **G6** golden-320-Voll-Lauf daten/infra-gated (mehrtägig, nie pollen); **G7/G8** gated.
- **4 E2E-Architektur-Befunde** aus dem Re-Audit weiter beim User: G5-Facade-Vorschlag · Workload-Metaprog-Grenze [R6] · 2× ABI-Bump-GO-Verankerung ([R9] Phase-6-telemetry, TIER-AUFLOESUNG ②Subject-Rename).
- **Tool-Zentralisierung → CEB** (späteres TODO, persistiert).
- **Board volatil** (durch Model-Resets geleert) — zuletzt 8 kompakte Tasks; persistente Wahrheit = Ledger §15.8 + §15.8(g)-Nachzieh-Board.
- **todo-board-Plugin**: nicht existent, 3 Wege vorgeschlagen, User-Antwort offen.

**Sicherheitshinweis zu dieser Extraktion:** In diesem Chunk tauchte ein Teil-Suffix des aktiven PAT im Transkript auf — es wird hier **bewusst nicht zitiert**. Alle Backups wurden vor dem Commit secret-gescannt (Ergebnis literal `0`).