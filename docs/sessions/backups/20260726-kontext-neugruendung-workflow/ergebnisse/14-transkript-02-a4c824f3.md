# CHUNK 2/30 — Chronologische Extraktion (Diplomarbeit-Managersession, 06./07.07., ca. 22:50 bis Kontext-Ende ~10:00)

Quelle: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_02.txt` (2792 Zeilen, vollstaendig gelesen). Keine Secret-Werte zitiert.

Struktur des Chunks: Zeilen 1–1650 = autonome Goal-V3-Zyklen unter Stop-Hook (nur Hook-Feedback als "User"), 1651–1723 = Kontext-Kompaktierung, ab 1977 = echte User-Direktiven (Achsen-Korrektur, Gates, Feinfragen, Matrix-Taxonomie, GitFlow, Owner), Ende = Kontext-Uebergabe 30.

---

## PHASE 1 — Autonome Goal-V3-Strecke unter Stop-Hook (22:50–04:30)

### (a) Direktive (wiederholt ~12x woertlich als Stop-Hook)
> "Bitte erledige alle sichtbaren TODOs und Goal Text v3 im Ledger. Beachte besonder Direktiven zur Striktheit der Organisationsform der Programmierumgebung, Modulreferenzierung und Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle memories geladen und alle Direktiven Klar sind."

Der Hook wies jede Stopp-Behauptung zurueck ("alle sichtbaren TODOs" != "alle non-gated TODOs"). Wirkung: der Agent fand unter diesem Druck **sieben** faelschlich als "gated" abgehakte Punkte und schloss sie (#277, #4, #18, #19, #272, #16-Teil, #273-T3), spaeter nochmals zwei (#279-a, #266-P3).

### (c) Paketmeldungen / Abnahmen / Commits (chronologisch, je mit literalem CI-Beweis)
| Punkt | Inhalt | Beweis |
|---|---|---|
| #267 CMD-1-c | 13 tote Command-/Visitor-Dateien entfernt; 3 Header bleiben als GEPARKT-dokumentierte V32-Ausnahmen (`i_command`, `execute_engine_command`, `compare_engine_command`) | 8218; test:unit "100% tests passed, 0 tests failed out of 162" (164->162 = exakt 2 Insel-Tests) |
| #267 CMD-1-d | `RuntimeMeasureVisitor` -> `HostMeasureLoop` (Klasse, Header, Konsument, Test-Callsites, CMake); T6-Spiegel-Helper GEPARKT | 8219 success |
| #265-b (Task #10) | AP-3-Bruecke konsumiert vendored `comdare::platform` (ARM NEON/SVE/SVE2 via hwcap) + neuer ce-Baustein `sysfs_cache_probe.hpp`; Quellen-Kette CPUID -> vendored -> sysfs; Vendor-Spiegel byte-treu | ce 8234; test_cpuid_probe 9/9 inkl. echtem sysfs-Realtest (prod1 L1d=48K/L2=1024K/L3=96M/line=64); Suite 164/164; Heilwelle 8239 + Kinder |
| #12 Skip-Audit | matrixweit 53 Skip-Stellen klassifiziert (ce 50 / super 3 / prt-art 0) | 8251 + Kinder; lokal 5/5, 0 SKIPPED |
| AP-2-neu/#236 (Task #15) | `test_ap2_katalog_pfad_stubfrei` (4 Tests) beweist echte `PrtArtComposition` ohne die 4 Alt-Pfad-Marker, Merge-Slot bleibt abstrakt (W4-Auflage); 3 Alt-Pfade + ce-V18-Template mit Quarantaene-Notizen | ce 8259 (Suite 165/165), prt-art 8260 (main) + 8261 (development), super 8262 |
| #184 + #269/#244 (Task #16) | `test_184_dataset_loader_wiring` 4/4 (committetes `mini_corpus.txt`, `dataset_source="string_corpus"` -> Registry-Loader -> deterministische FNV-1a-Ops, kein YCSB-Fallback); 2 Bestands-Akten (english_words, pizzachili_dna) via `compute_dataset_akte` gegen echte Dateien | super 8266, ce 8267+8270, prt-art 8268, thesis 8269 |
| #270b (Task #13) | `build:arm64-smoke` (opt-in `COMDARE_ISA_MATRIX`, advisory, `tags:[arm64]` -> node7) instanziiert | Neutralitaet: Push-Pipeline 8271 success ohne arm64-Job; Endwelle 8273+8274 |
| #19/W2 (Task #19) | Doc 30 §8.2 als autoritative L-Semantik-Stelle fuer Node-Pools | Welle 8282 + Kinder |
| #18 | Ledger §14: alle 9 offenen User-Gates mit Empfehlung an EINER Stelle (Sammelantwort moeglich) | Welle 8286 |
| #277 | per-Tool-Cache-Hits read-only belegt: clang-format + cppcheck ueber alle 3 Projekte ("cache.zip is up to date", "Successfully extracted cache", 12,3 s, 0 cppcheck-Compile-Zeilen) | Welle 8290 |
| #272 (Task #17-Doku) | Konsolidiertes Infra-HO-Paket **K88** im Cluster-Repo (`docs/sessions/K88-INFRA-HANDOVER-PAKET-272-KONSOLIDIERT-20260707.md`, HO-1..9 + H11–H18 + WCM/Vault + keeper-403 + node7-Freeze-Datenpunkt), Commit d0a8a36 | Welle 8294 |
| #273-T3 | `build:clang`-Jobs in ce + prt-art (opt-in `COMDARE_CLANG_MATRIX`, advisory) | lokal clang-22 sauber; Proving 8301 (ce) + 8302 (prt-art) success, literal "clang++-22 = Ubuntu clang version 22.1.8"; Neutralitaet 8298/8300 |
| Uebergabe 29 | `super docs/sessions/20260707-SESSION-UEBERGABE-29-goalv3-strecke-abgearbeitet-nur-gated-rest.md` | Welle 8307 |
| §14.9 Gate-Recheck | gcc-15.3 nachweislich absent (nur g++-13/g++-16); node7-Freeze 2. Reproduktion (Job 216123, >8 min pending, "FREEZE BESTAETIGT") | Welle 8312 + Kinder 8313/8314/8315 |

Board-Stand am Phasenende: **18 von 24 completed**, 0 `allow_failure` matrixweit.

### (d) Fehler + Fixes dieser Phase
1. **super 8220 failed** — der 0-Konsumenten-Beweis fuer `compare_engine_command.hpp` lief nur ce-intern; `v32_orchestrator.hpp` im super-Repo inkludierte hart. Fix: Datei + 4 CompareEngine-Tests wiederhergestellt, GEPARKT-Notiz, matrixweit nachkartiert. **Lektion verankert (Ledger §12 + Memory): Konsumenten-Beweise fuer ce-Header immer ueber super + prt-art + Tools fuehren.**
2. **super 8225 failed** — ~60s-GitLab-API-Blip (23:08) liess `thesis:pdf` beim Artefakt-Upload scheitern trotz gruenem Inhalt. Fix: Job-Retry -> 8225 success. Als **K87b-Datenpunkt** fuer das Montags-Audit (Task #23) eingebucht.
3. **super 8235 failed** — neue Include-Kante (`comdare/platform/SIMDDetect.hpp`) brach die super-V32-TUs. Fix: `test_v32_orchestrator` + `test_messreihe_report_exporter` an `comdare::platform` gelinkt, lokal mit `-DCOMDARE_V32_ENABLE=ON` bewiesen (7/7 + 5/5). **Lektion erweitert: die Matrix-weit-Regel gilt fuer JEDE neue Abhaengigkeits-Kante in ce-Headern, nicht nur fuer Loeschungen.**
4. **8247 lint:format failed** — eigene Kadenz-Luecke (super-TU nicht durch clang-format 22.1.8). Fix 11e8cc6 -> 8251 success. Vom Agenten als Wirksamkeits-Beleg der #278-Haertung gewertet.
5. **Skip-Audit-Fund (super)** — die EINE echte Maskierung: Stufe-06-pdflatex rc!=0 wurde als `GTEST_SKIP` ("vermutlich fehlen Pakete") gewertet; jetzt hartes `ASSERT_EQ(rc,0)`; Nebenfixes: Windows-`>NUL` erzeugte auf Linux eine Junk-Datei, fester /tmp-Name -> per-User-Tempdir.
6. **FNV-1a-64-Konstante** hatte einen Ziffern-Tippfehler -> korrigiert auf `14695981039346656037ULL`.
7. **sosd_books_200M** — zuerst als "truncatiert" bewertet, spaeter durch Voll-Re-Fetch **ehrlich korrigiert**: Datei laedt vollstaendig (553 MB), aber der Header hat nicht das erwartete uint64-count-Format -> echt Teil des 6-vs-48-Format-Gates, **keine Akte ueber unverstandenes Format** (Anti-Fabrikation).
8. **Python-Heredoc-Crashes** an deutschen Klammern/Anfuehrungszeichen -> Umstieg auf Read+Edit.
9. **node7** meldet `online + active + idle + tag arm64`, nimmt Jobs aber nicht an (2x reproduziert, 03:35 und 04:15). Runner anfassen = Cluster-READ-ONLY -> GEPARKT an Task #23; stuetzt die serverseitige Job-Acceptance-These H18 (Freeze betrifft nicht nur prod1).

### (b) Scope-Entscheidungen dieser Phase
- **#266 GEPARKT nach V3-Regel** (Task #11): Q2-config-Owner ist das einzige offene Matrix-Gate; Empfehlung `config-all`; P3-memory zusaetzlich konsum-gated (kein Vorrats-Vendoring gegen die Matrix-Reuse-Direktive), P4-metrics gesperrt bis #215.
- **#270b bleibt advisory/opt-in**, die harte PFLICHT-Scharfschaltung bleibt ausdruecklich #276 (allerletzte Aufgabe) — Begruendung: Hauptpipeline stabil halten.
- **STOP-BEDINGUNG (Ledger Z.450)** identifiziert und angewandt: nur noch gated/GEPARKT/HELD -> Handover schreiben, sauber stoppen, keine Leerlauf-Iterationen. Drei Handover-Ebenen: Ledger §14, Cluster-K88, Session-Uebergabe 29.

---

## PHASE 2 — Nach Kompaktierung: Stop-Hook zwingt zwei weitere Slices auf

### (b)+(d) Selbstkorrektur C1
Der Agent gestand: seine Absolut-Behauptung "kein von mir loesbarer non-gated Slice mehr" (§14.9, Uebergabe 29 "ausnahmslos extern gated") war **falsch**. Grounding gegen Ledger §14 / §12 Z.256 / Z.278 ergab zwei echte Slices:
- **#279/#22**: Mess-Modus-Schalter + Tier-Binary-Build-Sichtbarkeit ist Code + `.gitlab-ci.yml` + CMake, per normalem Push beweisbar — faelschlich als "cluster-gated" etikettiert.
- **#266-P3**: die Konsum-Kartierung ist read-only Recherche, weder user- noch cluster-gated.
Bestaetigt wurde dagegen #5/#274: der Migrationsplan-Entwurf ist backup-gegruendet (`ultracode-Bestandspruefung wf_2a1a80c2, 4 Kartierer`) und alle 16 Increments explizit `[GATED]` auf G1–G12 -> echt gated.

### (c) #279-a — vollstaendig super-seitiger Increment
Geliefert: header-only Lib + CLI + deterministischer gtest + CI-Job `visibility:tier-binaries` (stage `analyse`, HART) + Release-Kette (Messung -> CSV -> LaTeX-Tabelle+Diagramm -> PDF, spiegelt `comdare_pipeline_e2e`), Default `debug_sample` (scharfer Lauf bleibt HELD unter #156/#276).
Beweise: **112/112 da_unit** (9 neue `test_279`), CLI gegen echten 27-Permutations-Manifest ("0/27 gebaut, 27 offen (Profil smoke)"), clang-format 22.1.8 clean, Mojibake 0, adversarialer Review ohne Findings >=80. Commit **009ada3**, Welle **8316 success** (Job literal success, `allow_failure=false`). Ledger-Doku **13a6e34**, Welle **8320 success**.

### (d) Fehler waehrend #279-a (alle vor Commit gefunden)
- Falscher Manifest-Pfad (`_cache_engine_external/generated/` statt `${CMAKE_BINARY_DIR}/generated/permutations_manifest.txt`).
- `extract_profile` suchte `profile=` irgendwo in der Zeile -> Kommentartext wurde als Profil gelesen; Fix: nur Zeilen, die mit `profile=` beginnen (case-insensitiv), deckt auch die echte Kommentarform `# Profile=smoke ISA=...`.
- Id-Raum-Mismatch: Manifest fuehrt `perm_scalar_aos_std`, `.so`-Stems ohne Prefix -> `canonical_id` (optionales `perm_` beidseitig strippen).
- **Kritischer Pre-Commit-Fang:** `.gitignore:23 *.so` haette die `.so`-Fixtures nicht committet -> Test waere lokal gruen, in CI rot. Fix: CMake synthetisiert die Fixture-Perm-Libs zur Configure-Zeit in den Build-Tree.
- Non-ASCII Em-Dash im Fixture-Kommentar -> auf ASCII gestellt.
- `discover_plugin_paths` nutzt den werfenden `recursive_directory_iterator`; eigener Aufrufer mit try/catch + `<exception>` gehaertet (Vertrag: "report, never gate, exit 0").
- **Codex:** read-only funktioniert, workspace-write-Shell tot (`bwrap: loopback: Failed RTM_NEWADDR`) -> manuelle Implementierung + code-reviewer-Agent als Fallback.

### (b) #266-P3 — Architekturentscheidung mit vier Belegen
**Ergebnis: `comdare-memory` wird NICHT vendored.** Begruendung: (1) ce referenziert `comdare::memory` nirgends (0 Konsumenten); (2) ce's 67 aligned-alloc-Dateien, `*_node_pool_store.hpp` und Slab-Allokator sind der **Forschungs-Design-Space selbst** (papertreu, Gegenstand der Messung — generische Ersetzung zerstoerte den Forschungswert); (3) `ThreadArena` (Messrecord-Akkumulator) != `ThreadLocalArena` (Byte-Allokator) trotz Namensaehnlichkeit; (4) die teure Backup-Kartierung wf_2a1a80c2 mappte ce-Reuse auf metrics/tracing/simd/registry/serialization, **nie** memory. Re-Oeffnungskriterium dokumentiert.

---

## PHASE 3 — Erste echte User-Direktive: Achsen-Systeme + Architektur-Pruefauftrag (Z. 1977)

### (a) User woertlich
> "axis_03a: tree/btree/art/skip/hash/masstree/surf/wormhole . Wie sollen das Messachsen sein? Es gibt einige System-Messachsen der cache-engine und einen Haufen Achsen zur Erstellung der Tier-Binaries. Beides sind getrennte Systeme, die je nach Konfiguration in die finalen Tier-Binaries einfliessen sollen. Dieser Hinweis ist nur eine Recherche-Vorlage und die Entscheidungen sind bereits getroffen, bitte schlage sie nach. Der Punkt ist, dass wir die Module aus dem Produkt migriert haben, aber weiterhin sicherstellen muessen, dass alles nach Architektur der cache-engine funktioniert, bitte pruefe das"

### (b) Aufgeloest durch Ultracode-Workflow (9 Agenten, wf_b770955b-609)
- **System 1 — Tier-Binary-KONSTRUKTIONS-Achsen:** 19 Kompositions-Achsen T0–T18 (`AdHocComposition`, `static_assert sizeof...(Vs)==19`) + 3 Build-Achsen (page_type, simd_extension, general_hardware) = 22. Jede Achse = Topic-Verzeichnis `libs/cache_engine/topics/<topic>/axis_NN_*`; nicht teilnehmende Achse waehlt explizites Pass-Through (NoBuffer/NonePrefetch), nie optional. T0 = `axis_03a_search_algo` traegt tree/btree/art/skip/hash/masstree/surf/wormhole.
- **System 2 — System-Messachsen/Observer:** kein disjunkter Achsensatz, sondern eine kleine Messdimension, die AUF denselben 19 Achsen liegt: per-Achsen `statistics()` -> `observe_all()` -> flaches POD `ComdareTierObserverSnapshot axis_stats[19][8]` ueber die ABI; `seg_ns[19]` Wall-Clock je Organ; PMC-Kategorien; zwei orthogonale Experiment-Achsen Build-Profil vs. Lastenprofil; `COMDARE_MEASUREMENT_MODE` ist ein Compile-Schalter, keine Achse. Doc 24 §8 = Hybrid Pfad A (isoliert in der DLL) / Pfad B (Komposit host-seitig ueber Pruef-Dock).
- **Verifikationsergebnis Migration:** 4/5 Einheiten CLEAN (simd byte-identisch zu Modules@7f0039f; `isa_dispatch` = dokumentierter Andockpunkt -> beantwortet zugleich F12; hdr hinter C-ABI-Naht).
- **(d) 1 Major gefunden + gefixt:** `test_cpuid_probe` haette den arm64-Smoke auf node7 falsch-rot gemacht (aarch64-PRFM-Widerspruch zu #265-b) -> ce **655c0314**, lokal 9/9. 1 Minor: staler Modules-Klon ff-synchronisiert.

---

## PHASE 4 — Gates, Modell-Fenster-Audit, Feinfragen

### (a) User: "Bitte gib mir alle gates zur Entscheidung"
Assistant lieferte Gruppe A (eigenstaendige Gates) mit Empfehlungen: **G-Q2** config-Owner -> `config-all`; **G-234V-a** per-Source-Emission Option A -> Ja (additives Makro `..._ADHOC_SHAPED`, 19-Slot-ABI bleibt); **G-234V-b** binary_id-Shape-Segment nur Pool-Familien default-OFF -> Ja; **G-6v48** -> Thesis-tab:datasets (6) kanonisch; **G-7b3** -> `axis_09b`; **G-270a** -> eigener Increment nach User-Sichtung der verriegelten Tests; **G-AP15** -> je Gattung eigener Increment; **G-268** ABI-MAJOR-Bump -> Nein. Gruppe B = **G-274** Meta-GO mit G1–G12 (G12 = PAT-Hygiene, ausdruecklich VOR Transfers) + 14 Feinfragen.

### (a) User: Fortschritts-/Differenz-Audit seit Modell-Fallback
Ergebnis (Ledger §12 "MODELL-FENSTER-AUDIT", Commit **c5536fb**, Welle 8324):
- **C1 Absolut-Fehler** (s.o.) — Lehre: gated je **Slice** belegen, nie pauschal.
- **C2 Begriffs-Fehler** (vom User korrigiert): axis_06/axis_03a faelschlich "Mess-Achsen" genannt; korrekt Tier-Binary-Konstruktions-Achsen. P3-Eintrag + Task #11 vor dem Commit korrigiert; die P3-Konklusion hing an keinem der Labels.
- **C3 Kadenz-Abweichung** (Umstand): Codex-implementiert-zuerst nicht erfuellbar (bwrap defekt) -> Fallback direktivkonform; Memory `reference_codex_mcp_prod1_bwrap_shell_broken`.

### (a) User (Z. 2094) — bindend
> "ich habe alle user gates gelesen und stimme allen Empfehlungen zu - jeweils richtig geraten. Bitte erklaere mir hier den Matrix Migrationsplan und stelle auch alle Feinfragen hier."

### (a) User-Antworten F1–F14 + G-AP15 (Z. 2252) — bindend, sinngetreu mit Kernzitaten
- **F1:** buildsystem.xml **in Ruhe lassen** — "ein anderer Agent kuemmert sich darum"; bis zu dessen Fertigstellung parallele Direktentwicklung mit CI und CMAKE. Sonst Empfehlung zugestimmt; "Halb fertige Funktionen werden fertiggestellt, sofern in einem notwendigen Modul erkannt."
- **F2/F3/F5/F8/F10/F11/F13/F14:** wie empfohlen (F8 "Beides, GO"; F13 "wir machen es nochmal sauber"; F14 zusaetzlich **Web-Recherche-Auftrag**: gibt es weitere empfohlene Mess-Ebenen?).
- **F4 (Vision, zentral):** ISA+OS+Compiler+SIMD-Module wiederverwenden — "es ist spaeter die Aufgabe des buildsystem, Programme automatisch mit Beschleuniger-Code zu bestuecken und hier kommt die cache-engine ins Spiel, weil sie genau fuer ein System ausmessen kann, welcher Beschleuniger Code in Form von Achsen-Algorithmen das perfekte Tier-Binary bilden. Die Cache Engine bestimmt die optimale Heuristik fuer eine Gattung durch Messung auf einem System." Ziel: Diplomarbeit + cache-engine als **Piloten fuer die automatische buildsystem-Optimierung**. Achsen spaeter = Organbestandteile mit eigenen getesteten Interfaces, in beliebigen groesseren "Tieren" wiederverwendbar -> viele weitere Gattungen. `comdare::simd` wird wiederverwendet. "Das Buildsystem ist ein Product und bildet ebenfalls eine eigene Product-Interface Ebene gegen die Module."
- **F6 (Doktrin):** Zweiteilung akzeptiert, aber "die Achsen sind je Achsen-Thema als Modul-Framework mit Metaprogramierungsinterface anzulegen, um generisch ueber alle Modulalgorithmen zu dem Thema verfuegbar zu sein, damit zur compile time und unter einer heuristisch optimalen Auswahl die besten Algorithmen in eine Tier-Binary kompiliert werden koennen. ... die Achsen sind ein Kopf-Framework interface fuer metaprogrammierbare Module innerhalb eines Modul Themas (keine Produkte)."
- **F7:** wie empfohlen + "bitte lies die Diplomarbeit, die gesamte Matrix an allen Messframworks mit ihren workloads muss noch als Module abstrahiert werden mit feingliedriger baseline 2D-Matrix Struktur."
- **F9:** Aufgabe des buildsystem; TestSystem = Chaos Engineering fuer das buildsystem, activemachinery = verteilter Server; "Beides nicht in unserem scope, aber relevant fuer spaeter."
- **F12:** "Bitte monolith in baseline Struktur sauber splitten. Sonst wie empfohlen."
- **G-AP15:** zuerst Container-Gattung -> `comdare::container` (allgemein, enthaelt genau die Container-Achsen); Gattung **Sequence nur in der Planung** erstellen, tatsaechlich unter den Containern den **Typ** Sequence (aequivalent `std::vector`) durchfuehren; linked list und uebrige C++23-std-Container sind **Typen, keine eigenen Gattungen** ("da sie Elemente speichern und freigeben koennen (sehr aehnlich -> gleiches interface)").

**(c) Verankerung:** Ledger §12 wortgetreues Entscheidungs-Protokoll, Migrationsplan **ADDENDUM 2**, 3 neue Memories (Achsen-Thema=Modul-Framework; buildsystem.xml hands-off; AP-15-Plan), Board: #5 entsperrt, **#30** (F14-Web-Recherche) und **#31** (F7 Mess-Matrix) neu.

### (c) 234-V-a umgesetzt (Option-A-GO)
Shaped-Trait + Adapter-`ShapeCarrier` (defaulted) + `..._ADHOC_SHAPED`-Makro + **`adhoc_emitter_shaped.hpp` als Sibling-Header** (bewusst eigener Header, damit der Include-Graph der Plain-Emitter-Konsumenten byte-identisch bleibt). Beweise: 4/4 neue Tests (T6 alloc_cnt `Kt4=3 vs Kt2=5` — Shape wirkt durch den Adapter im Pool), Voll-Suite 179/182 (3 vorbestehende standalone Not-Run), clang-format 6/6, Mojibake 0. ce **02e4df36** -> 8337; super-Bump **d08b83b** -> **8338 success**.

### (a) User (Z. 2268) — bindend
> "Du hast nach dieser Praezisierung das Go fuer den gesamten Matrix Migrations plan, ich habe auch alle anderen Gate Punkte gelesen und gebe sie hiermit frei. Bitte commit und push die Planung und den aktuellen Stand. Bitte weiter mit dem was du gerade tust"

---

## PHASE 5 — G12, das Missverstaendnis, die Matrix-Taxonomie

### (a) User: "Bitte weiter mit G12 und den Migrationsschritten. Bitte versuche aber nochmal codex fuer die erstimplementierung als mcp Server zu erreichen, damit wir tokens sparen. Woran hakt es?"
**(d) Codex-Wurzelursache** diagnostiziert (bwrap/AppArmor-userns-Restriktion), Workaround gefunden: `sandbox: danger-full-access`.

### (c) G12 ausgefuehrt
PATs aus den lokalen `.git/config`-Remote-URLs in den Credential-Helper ueberfuehrt: **294 Repos**, 296 Remotes tokenlos, Tokens in einer 0600-Datei, `credential.useHttpPath=true` (sonst Host-Kollision). Beweise: ls-remote 8/8, Rest-Grep ueber alle `.git`-Configs = 0 Tokens, API-Muster via `git credential fill` HTTP 200, Submodule intakt, deterministischer Rollback im Provenienz-Doc `20260707-G12-pat-credential-helper-migration.md`. **Kein Push, keine Remote-Aenderung, `.gitmodules` unveraendert.**

### (d) Schwerwiegendes Missverstaendnis (Wortwahl "294 Repos migriert")
> User: "Oh gott nein, falsch, zurueck. Die Projekte haben Cluster, Products, Research und so weiter und die Struktur davor WAR DOCH DIE Baseline Struktur"

Agent hielt sofort ALLES an, belegte literal: Top-Level `Cluster/Modules/Products/Research` intakt, Baseline-Ordner intakt, 0 Datei-Aenderungen, **kein einziger Migrationsschritt 0–15 ausgefuehrt**. Es waren **Zugangsdaten** migriert, nicht Repos. Kein eigenmaechtiger Rueckbau; Optionen (a) Entwarnung / (b) Rueckbau vorgelegt.

### (a) User: "Bitte chatte mit mir wie die Matrix Struktur aufgebaut ist und war ... ich wittere hier ein schwerwiegendes Missverstaendnis" / "Ich benoetige eine praezise Beschreibung des Plans und des Vorgehens"
Agent: reiner Dialog, keine Aktionen; beschrieb IST-Struktur und stellte Rueckfragen A–D; **ehrliche Luecke:** `MATRIX-GRUNDLAGEN-GOALV2.md` nicht auffindbar.

### (a) User (Z. 2415) — DIE zentrale Architektur-Direktive des Chunks, woertlich
> "Nun in Stein gemeisselt sollte eigentlich die Matrix Familien x Baseline-Stufen x Module sein. Nach Planung sind die Module Metaprogrammierungs-offen und nur source code und jedes Product/Research muss wenn es Module verwenden moechte ebenfalls eine eigene Matrix Familien x Baseline-Stufen x Module organisieren, um durch eigene separate repos und Implementierungen die template Module als echtes Interface-Binary bereitzustellen. Die Diplomarbeit befindet sich in der Migration von einem Monolithen in die offizielle Modulstruktur und wir durch die Migration zerteilt. Achso, dann ist alles richtig und wir machen weiter, du hattest dich ungluecklich ausgedrueckt, das Verstaendnis ist doch absolut korrekt. (bei Research sind die Product Eigenschaften gelockert). Bitte speichere also den Prozess der Umwandlung eines Research in ein Product als Standardprozess fuer weitere Projekte, die Products werden wollen. Bezueglich der Migration der Gruppen auf gitlab: Die meisten Projekte haben derzeit schon eine lose halb-richtige Gruppenstruktur, bitte pruefe das bestehende als diff gegen, sodass du sicher sein kannst die gitlab Gruppenstruktur exakt nach der Ordnerstruktur stets nachzuziehen. die comdare cache engine ist ein Framework-Modul und die Diplomarbeit ist deren Produkt und Aussseninterface. PRT-ART ist auch ein Modul neben der cache-engine und das overleaf Projekt ist auch ein Produkt, aber ohne baseline Struktur, weil es kein C++/Java/Python/Go/Rust ist. Bitte stelle Rueckfragen und beschreibe mir was genau du migrieren moechtest, ob es Bewegungen gibt und wie diese aussehen"

### (c) Antwort-Artefakte
- **GitLab-vs-Ordner-Diff** ueber alle 294 origin-URLs: 26 exakte Spiegel, **111 modules-flach** (ohne Familien-Gruppe), 53 mit Familien-Gruppe aber ohne `-all`/baseline-Ebene, 1 faelschlich unter `root/`, Products mit eigenem Schema (+ Case-Drift `Layer0` vs `layer0`), Cluster-Repos auf `cluster/` + `infrastructure/` geteilt, 1 externer Vendor-Klon (concurrentqueue) von der Spiegel-Regel auszunehmen. **268 abweichende Projekte.**
- **Standardprozess-Doku** `docs/STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md`.
- **Bewegungsarten B1–B6** definiert: B1 Neuanlagen (measurement-all + pmc + workloads + Framework-Modul-Zellen + Product-Instanziierungs-Matrix), B2 der EINE geplante Repo-Transfer (`comdare-metrics` foundation -> measurement, GitLab-Transfer mit Historie + Redirects, nie Copy+Delete), B3 Erweiterungs-Commits in bestehende Zellen (je Repo EIN Commit, nur CMake/CI — buildsystem.xml tabu per F1), B4 Monolith-Zerteilung frisch aus der Scratch-Kopie, B5 Skelett-Tombstones (nichts loeschen), B6 GitLab-Gruppen-Nachzug. **Fixpunkte: bestehende Modul-Familien, Repo 286 (Pipeline unberuehrt, Monolith wird entkernt nicht bewegt), lokale Kategorien.** Commit **341256c**, Welle 8342.

### (a) User-Antworten A–E (Z. 2485) — bindend
- **A:** "die Familien in den Products heissen nicht *-all sondern sollten *-product heissen und beherbergen nur ein benoetigtes Subset der fuer sie relevanten Module unter den baselines. Ist eine baseline leer, wird ihr Ordner nicht angelegt." Products = Instanzen der Module, binary kompilierbar, eigene Gruppenstruktur als Subset-Abklatsch der generischen Modulschicht.
- **B:** wie empfohlen (ce-Framework-Modul-Verortung).
- **C:** "PRT-ART ist nichts anderes als eine abstrakte anordnung neuer Algorithmen unter bestehenden Achsen, er ist also eine Erweiterung der cache-engine und daher gehoert er als Achsen-erweiterndes Metaprogrammierungsmodul in die cache-engine Familie."
- **D:** von Prinzip und System ableiten, nicht direkt von den je Familie individuellen Baseline-Themen.
- **E:** GOALV2 suchen; "sonst erwarte ich einfach, dass du bitte alle sichtbaren TODOs und das ledger abarbeitest."

### (c) Migrationsschritte 0 und 1 ausgefuehrt
- **Goal-V3-Ergaenzung** (additiv, §13.12): Matrix-Goal mit 5 Voll-Pfad-Referenzen gleichrangig neben der V3-Arbeitsreihenfolge, inkl. Abarbeitungsregel (Schritte 0–15 als Kadenz-Increments; STOP erst wenn auch die non-gated Migrationsschritte fertig). Commit **3019125**, Welle **8351 success**.
- **GOALV2 gefunden**: `docs/sessions/20260705-matrix-grundlagen-goalv2/` (Tiefe 5, aus der 05.07.-Synthese-Session; auch dem User unbekannt) — deckt sich mit den Praezisierungen.
- **Schritt 0 AUSGEFUEHRT** (G1-GO): GitLab-Gruppe `comdare/modules/comdare-measurement` (**id 353**) + Umbrella-Projekt `comdare-measurement-all` (**id 300**, default `development`); Skelett per **Codex-Erstimplementierung** (Token-Spar-Weg, cwd-gepinnt) + Zeile-fuer-Zeile-Review mit **3 Fixes** (fehlende `.gitkeep`; stale `rc-`->`cd-`-Buildsystem-Pfade — Alt-Bug auch im foundation-Original, Nebenbefund fuer den Owner; EN-Kommentar). README traegt F14-Ergebnis + TRANSPORT-Abgrenzung + Manifest-Delegation; **kein buildsystem.xml** (F1). Push **62cbd48**.
- **(d) meas 8350 FAILED** — `lint:static` rot am leeren Repo (secrets+format gruen). Fix: Leer-Guard **1b392a3** -> **meas 8355 success**, Gegenprobe am quellen-tragenden super **8351 success**. Ledger-Eintrag **23db760** -> **8357 success**.
- **Schritt 1** (Doku-Fixierung, ersetzt D-5): ce `modules/README` V41.E4-Konflikt per additiver Supersession-Note aufgeloest + Plan-Ausfuehrungsprotokoll. ce **d6d0744a** -> **8361 success**; super **083b2b3** -> **8362 success**.

### (b) Halt vor Schritt 2 (destruktiv)
Schritt 2 = A5-Branch-Konsolidierung = `master`-Loeschung ueber die Modul-Flotte. Read-only Klon-Pruefung: `comdare-metrics` master == development (sicher), aber **`comdare-foundation-all` master +1 Commit nicht in development**. Agent stoppte: remote-Loeschung + Datenverlust-Risiko -> nicht autonom. Drei Optionen vorgelegt (sicher weiter mit Schritt 4 / destruktive Schritte freigeben / pausieren).

---

## PHASE 6 — GitFlow-Doktrin, Owner-Sauberung, Flotten-Dry-Run

### (a) User (Z. 2650) — bindend
> "Da die pipeline gruen ist merge bitte development nach main und fahre auf development fort. Gibt es master/main redundant, loesche bitte master und stelle auf main als haupt branch um"

**(c) GitFlow-Pilot auf 3 Repos, alle Sub-Faelle abdeckend:** measurement-all (nur development -> main angelegt, default=main); comdare-metrics (master == development -> geloescht); comdare-foundation-all (Verlust-Risiko-Fall).
**(b) Entscheidende Begruendung Fall C:** der "master-Extra-Commit" war ein staler Merge-Commit vom 15. Maerz; die **Inhalts**-Pruefung zeigte, dass master **aelter** ist (alte Inline-CI ohne ci-templates-Include, development hat die moderne). "Ein Merge master->development wuerde also REGRESSIEREN" -> master verlustfrei geloescht, **ohne** Merge.

### (a) User (Z. 2687) — bindend
> "Formal stehe ich aber noch nicht in allen repos direkt als owner drin, obwohl ich es bin, bitte behebe das. Die Repos wurden aus dem alten gitlab system direk per Datenbank eingelesen und neu per Samba AD verknuepft. Das muss sauber sein"

**(c) Owner-Rollout fertig:** 46 Gruppen (alle bereits root-Owner), **297 Projekte -> 291 neu als direkter Owner (Level 50) eingetragen, 6 bereits vorhanden**; idempotent, additiv, autoritativ via Gruppen-Enumeration. Nebenbefund: Alt-System-Rest `dedup-lab` mit vererbtem Reporter-Zugriff. Zuvor belegt: root (id 1) ist Owner auf `comdare` und `mirrors`, vererbt auf alles; damit war der "fremde-Owner"-Vorbehalt hinfaellig.
**(d)** `/projects`-Enumeration lieferte zunaechst 0 (Admin-Sudo-Modus nicht aktiv) -> Umstieg auf lokale Repos bzw. Gruppen-Enumeration; `git credential fill` braucht echten Pfad (useHttpPath).

### (c) Flotten-Branch-Dry-Run (read-only, 293 Repos)
| Klasse | Anzahl | Aktion |
|---|---|---|
| konform (main=default) | 15 | nichts |
| nur development | 35 | main anlegen + default umstellen (sicher) |
| master subset development | 82 | main anlegen + master loeschen (sicher) |
| nur master | 1 | master->main umbenennen |
| **master AHEAD** | **160** | je Repo Content-Pruefung, NICHT blind loeschen |

Worst Cases: `comdare-db/comdare-filestorage` +25, `comdare-db/comdare-storage` +20, `storage-all/comdare-storage` +5, diverse client-protocols/licensing +7, `wrappers/go-wrapper` +3, `Research/comdare-via` +3.

### (a) User (Z. 2738) — bindend
> "Nun wenn der main voraus ist, muss development auf den Stand von main gebracht werden"

**(b) Verankerte Branch-Doktrin (Memory + Ledger):**
> main = Autoritaet, traegt den NEUESTEN Stand (Vereinigung aller Branches). development wird auf main hochgezogen (nie dahinter, darf voraus sein). master wird NUR geloescht, wenn main master vollstaendig enthaelt. Sonst zuerst master -> main mergen. Merge-Konflikt => master bleibt stehen + wird gemeldet. Grundsatz: immer auf den neuesten Stand syncen, nichts loeschen, was wir nicht verantworten koennen.

### (a) User (Z. 2758): "Bitte erstelle eine elaborate Session Dokumentation und Kontext uebergabe, der Kontext endet jetzt"
**(c)** `super docs/sessions/20260707-SESSION-UEBERGABE-30-matrix-migration-branch-owner-gitflow.md`, Commit **51b9898**, beide Remotes; Branch-Doktrin als Memory; alle Working Trees sauber.

---

## (e) OFFENE FAEDEN AM CHUNK-ENDE

**In flight / direkt anknuepfen:**
1. **Content-Klassifikator der 160 master-AHEAD-Repos laeuft noch** im Hintergrund (Task `bv0plekuy`, Ausgabe nach `scratchpad/master_classify.out`, Skript re-runnbar; Python puffert -> Ausgabe erst am Ende). Reihenfolge danach: (1) die **118 sicheren** Faelle mechanisch ausfuehren, (2) stale-Batch nach GO loeschen, (3) Real-Content-/Konflikt-Faelle einzeln dem User vorlegen.
2. **Migrationsplan Schritt 2** (Flotten-Branch-Konsolidierung) und **Schritt 3** (`comdare-metrics` Gruppen-Transfer foundation -> measurement; foundation-all-Aggregator zeigt danach ins Leere bis re-verdrahtet) — beide sensibel, Rueckversicherung vorgesehen. Schritte 4–15 unberuehrt; Schritt 4 (lokale Scratch-Kopie des Monolithen, fixierter SHA) als risikofreier Naechster vorgeschlagen.
3. **B6 GitLab-Gruppen-Nachzug** der 268 abweichenden Projekte — wartet auf finale Konventions-Bestaetigung (offen geblieben: `-all`-Ebene UND `comdare-baseline_N-*` als Untergruppen oder nur `-all`? GitLab-Slugs zwangsweise lowercase, Case nur im Anzeigenamen?).
4. **Namens-Entscheidung fuer die cache-engine-Familie** offen (A7 verbietet `comdare-cache-engine-all`) — soll beim Anlage-Schritt punktuell gestellt werden.
5. Offen gelassene Frage: sollen super/ce auf einen `development`-Arbeitsbranch umgestellt werden (CI-Trigger + Submodul-Refs zeigen auf main -> eigener struktureller Increment)? Ohne explizite Ansage bleiben die vier Repos wie sie sind.

**Extern gated (unveraendert):** #13/#270b node7-Freeze (2x reproduziert), #14/#276 (allerletzte Aufgabe), #20/#273-T2 gcc-15.3 (nicht installiert, HO-11), #21 Runner-Cache, #22-Rest (scharfer Mess-Lauf), #23 K87b-Audit — alle Montags-Cluster-Fenster. HELD: #156/#215/#216 (mehrtaegiger Voll-Mess-Lauf, nicht pollen).

**Dringend (Montag):** Der Token, der bis G12 in ~300 Remote-URLs lag, ist der root master-token mit api/admin_mode/sudo, gueltig bis 2027 -> **Rotation** auf die Montags-Liste.

**Neue Board-Punkte:** #25–#29 (aus dem G-274-GO), **#30** F14-Web-Recherche zu Mess-Ebenen (spaeter als "F14 abgeschlossen" gemeldet), **#31** F7 Mess-Frameworks x Workloads-Matrix (Diplomarbeit vorher lesen).

**Werkzeug-Notizen fuer nahtloses Weiterarbeiten:** Codex-MCP wieder nutzbar via `sandbox: danger-full-access`; Monitore auf **Pipeline-IDs** statt SHA-Praefix stellen; Token-Zugriff ausschliesslich via `git credential fill` (useHttpPath).

**Letzte HEADs / Pipelines:** super `083b2b3` (Welle 8362 success) bzw. Uebergabe `51b9898`; ce `d6d0744a` (8361 success); prt-art `faa4e76`; thesis `35b7d54`; Cluster `d0a8a36`; measurement-all `62cbd48`+`1b392a3` (8355 success). Alle Working Trees sauber, beide Remotes gepusht, 0 `allow_failure` matrixweit.