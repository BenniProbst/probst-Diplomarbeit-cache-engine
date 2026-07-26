TK_25 — EXTRAKTION (chronologisch, Chunk 25/30, Zeitraum 2026-07-20 ca. 16:45–22:00)

═══ (a) USER-DIREKTIVEN (wörtlich wo bindend) ═══

**U-A (drei GOs zu ①②③, wörtlich):**
"K6b POD-Layout-ABI-Gate: Das war der Prototyp für Versionierungsstempel, die Anatomy ist also die Rekombination aller in einer Stufe Planer/CEB/Tier vorhandenen Achsen, die hier versioniert werden sollten, wie beschrieben. Das ist im Prinzip schon die Stempel Vorlage. Daher volles GO sie nach Plan zu reaparieren und weiter zu entwickeln. GO. K4: Das ist eine Unter-Achse des Mess-Toolings, um eine passende CEB zu bauen, welche per XML Konfigurationen die notwendigen Mittel einkompiliert, um alle oder nur teilweise Einzel-Messeinrichtungen von Wallclock/Makro/Micro nach Plan-Beschreibung mit einzubauen. Volles GO, diese erst bei S6 Scharfzuschalten, wenn der Planer CEB emitten kann, sodass die vorkonfigurierten CEB ihrerseits die korrekt vorbereiteten Tier-Binaries mit diesen Mess-Eigenschaften emitten (Mess-Einstellung Wallclock/Makro/Micro ist compile time in CEB und Tier-Binaries fest per Metaprogrammierung eingerichtet). Template-Element: Ja korrekt. Bitte bedenke, dass die Cache-Engine registry und die PRT-ART Registry für bekannte Paper, die sie abbilden sogenannte echte Template-Profile führen müssen, also ist jedes Paper ein eigener Prüfling, der den Stand der Technik ergänzt (voll-template-split später in der Cache Engine nach Paper Definitionen und echtem code der nach Achsen vorsortiert ist). Erstmal mode full akzeptiert. Referenzierte templates später wie eben beschrieben, nach dem gesamten v3 Plan. Ich will das benannte <template> Element, wobei wir später die Features dafür erweitern. Volles GO"

**U-B:** "Ich hatte vorhin eine Planungskonsolidierung verlangt, bitte lies den GESAMTEN Kontext nochmal gründlich auf vergessene TODOs und führe sie durch."

**U-C:** "Volles GO für die geannten offenen Punkte für refactor"

**U-D:** "Falls du Rückfragen hast, stelle sie gern"

**U-E (Merge + Handover + Vollautonomie, wörtlich):** "Bitte merge jetzt development auf main, der Stand ist ja sauber. Bitte sende dem Infra Agenten ein Handover unter Cluster/docs/sessions über Schlüsselprobleme und Infrastruktur, er macht das. Pace bestätigt und Strang A UND B vollautonom freigegeben - auch nachts als Anschluss der stehenden Direktiven. Volles GO"

**U-F (Modellwechsel):** `/model` → "Set model to Fable 5" (Hinweis: `.claude/settings.json` pinnt Opus 4.8 beim Neustart). Dazu: "Ich habe das Modell auf Fable umgestellt, bitte lies dich umfassend und gründlich in den GESAMTEN Kontext ein und übernehme die aktuelle Entwicklung. Direktiven und Konventionen bleiben stehen"

**U-G:** "Stelle gerne Rückfragen, falls du welche hast, die du nicht autonom selbst auflösen kannst"

**U-H (Thesis-Grenze + Reife-Gate, wörtlich, BINDEND):** "Die Thesis Grenze stimmt, wir machen erst Textarbeit, wenn wir die Code-Arbeit und Messergebnisse haben. Die autonomie über Anhänge B/E ist absolut freigegeben, weil hierhin die in XML angefragten Experiment-Ergebnisse konform eingepflegt werden müssen. Genau das ist aber der letzte Schritt der Kette nach dem v3 Plan. Bezüglich des Timings der schweren Materialisierung: Du hast volle Autonomie - auch über Nacht. Wir müssen erst Plan v3 und einige zu klärende Folgeaufgaben vollständig abarbeiten, sonst erhalten wir keine zuverlässigen Ergebnisse für die Materialisierung - wir brauchen erst eine zuverlässige Steuerung der Versuche, die wir mit Plan v3 gerade bauen. Wir sind noch nicht weit genug, um in die XML unsere Wünsche zu definieren und tatsächlich jenes Ergebnis erwarten zu können."
→ Manager-Verankerung: Materialisierung ist **reife-gated, nicht zeit-gated**.

**U-I (Post-v3-Anforderungen R1/R2/R3 + Deprecated-Kuration, wörtlich, zu persistieren):** "Bitte schreibe zwischendurh nach einem ultracode audit eine Zusammenfassung über deprecated Features und der Möglichkeit und Sinnhaftigkeit diese dennoch wieder zu implementieren. Der Sinn dahinter ist, dass Opus bei Unterbrechungen schnell den ganzen Turn verwirft und schlecht filtert, welche Aussagen jetzt deprecated sind, du Fable, kannst das besser. Wir haben also einen Haufen Features die offiziell als deprecated gelten und vielleicht noch etwas taugen. Das ist mir in folgender Situation aufgefallen: Mir ist aufgefallen, dass der Vertrag zwischen Experiment-Planer und CEB derzeit durch Textemission aufgelöst wird und nicht konform mithilfe einer schnellen C++23 <modules> .so ABI stabilen Schnittstelle, die Messergebnisse (bei 131.000 Ergebnissen) womöglich schneller transportieren und die Steuerung effizienter gestalten kann, als Textemission (aber eine "/btw" Anfrage meint das wäre bewusst verworfen worden und deprecated). Weiterhin ist der measurement_driver auf Planer und CEB verteilt, und hier stellt sich die Frage was genau beide messen und ob das bezüglich der Verantwortlichkeiten dann nicht zwei Module und Unter-Klassen derselben Klasseninstanz sind, weil die Mess-Achsen des Planers die Ausstattung der CEB steuern und die CEB genau genommen den eigentlichen measurement_driver zu den Festlegungen des Planers enthält? Oder sehe ich das falsch? Sowohl für das Bauen/emit von CEB aus Planer oder Tier-Binary aus CEB oder gar Überwachung von CEB der Tier-Binaries-Builds, ist es sicher hilfreich, wenn der Planner gleichzeitig als CLI ausgerichtet ist und auf der shell mit user interface umgänglich gesteuert werden kann, dann sollte der Planer auch den Zustand/Builds/Messungen der CEB und Tier-Binaries loggen, damit der Nutzer weiß, wie der Stand ist. Ich will das Programm später auch gerne manuell mit der XML config fahren können. Betrachte diesen Block als zusätzliche Anforderungen nach Plan v3, die bitte zu persistieren sind."

═══ (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begründung) ═══

**Paket-Bündelung S4-KERN (reconciled, Plan-CoreSchema-Final):** KERN-A = K1→K2→K3→K4→K6 (Schema/Parser/validate/Director, golden-neutral, EIN Owner wegen Owner-Regel v3.2:202) · KERN-B = K5 + K7a (Emitter katalog→direktiven + Merge-Stempel-POD, golden-Fenster, als LETZTES) · K7b (§58-Array) + K8 (Storage) = deferred/off-path. Begründung K5 als einziges golden-berührendes Stück: der LIVE-Interpreter ist der katalog-fixe `sota_catalog.hpp:162-243 sota_module_for` mit hart verdrahtetem prt_art + path_compression-Slot.
**measurement_tooling = Schwester-Paket P-MESSTOOL**, nicht KERN-A (Manager-Kurskorrektur an Impl-Agenten) → Feld bleibt PASSIV in KERN-A (Schema-Vollständigkeit), Verdrahtung/Fan-out = P-MESSTOOL/#26.
**Runner-Tags Prämissen-Korrektur:** Pending der tier:build-Jobs war **Scheduling-Burst, kein Tag-Mangel** (Runner 16 trug bereits amd64/avx2/avx512). Flag-granulare Tags = Vorwärts-Korrektheitsmaßnahme; wirkt erst mit flag-granularer Job-Seite (#24).
**A3-Ruling (F)1 = Weg (a) „ehrlich statt wörtlich":** Jobs taggen aus dem **real gebauten** march-Flag abgeleitet (avx512 → `["avx512f"]`, weil `SimdAvx512Option::do_gcc_march_flag()` exakt `-mavx512f` liefert, static_assert `simd_sub_axis.hpp:107`); die 13 Sub-Flags am Runner = ungenutztes Superset, GitLab-Matching ist UND. Anreicherung der Build-Flags gehört zu A7/§40.a, nicht A3.
**A9-Rulings (6 Forks):** writeback_methods-Registry = {csv, latex_table, comparison_metrics} (honest-0, kein Phantom-`pdf`) · Registries = constexpr-Single-Source jetzt, DIM/Fan-out = P-MESSTOOL · run_methodology = `vector<string>` (sweepbare UNTER-Achse) · PILOT-Scope: nur die 4 Achsen-Wert-ENV raus, INCLUDES/LINK_LIBS bleiben (Bau-Infra ≠ Achse) · `<system_axes>` nicht in allen Profilen forcieren · A4/#25-XSD wird **in A9.1 eingefaltet** (ein Owner statt Serialisierungs-Tanz).
**A10-Rulings:** Minimal-Pointer-Variante (Inline-Pointer nur D1/D2; Deep-History via §55-Restatements + PFLEGE-HINWEIS) wegen Churn-Risiko im 1.1-MB-Ledger · Backups bleiben unberührt (stehende Direktive) · ce-Kommentare (axis_growth/view_policies) stehen lassen · historische Plandocs ausgeschlossen.
**A6-Rulings:** alle 4 Seams einhängen (uniform, identitäts-sicher) · strikte Identität bei leerer Kette (kein `|filtered:cor`-Marker) = byte-stabiler Default. Verworfen: Single-Choke in `run_lazy_static_then_dynamic` (Schicht-Verletzung, cleanest-not-easiest).
**A11-Rulings:** E3 `builder::experiment` bleibt (K-19, deliberate; kein 65-Datei-Rename, nur Klärungs-Kommentar) · E2 9dim-Dach-Rehang zu groß → eigenes Paket (Task #33) · E1/F27 Fixture-Kanonizität = User-Entscheid (offen) · die 3 A11-Mini-Fixes in den Manager-Integrations-Pass gefaltet (perm_runner.hpp triggert 65-TU-Rebuilds im geteilten build/).
**A8-Befund (Sweep-Prämisse stale):** W7-B CMakeGraphBuilder ist seit 19.07. SCHARF (echte `${COMDARE_PLAN_DRIVER}`-Kommandos, director:873-881), W7-A + W10-C ebenfalls DONE → echte Rest-Arbeit nur A3 + A8(a)-Symmetrie (`emit_tier_cmake_facade` + combo_selector).
**A8/A3 ∥ KERN-B parallel zulässig** (Owner-Schnittmenge belegt leer: KERN-B = sota_catalog/anatomy_*/lazy_adhoc; A8A3 = director/facade-emit/main/ci).
**S5-Rulings (4/4 Empfehlungen übernommen):** ExperimentSubtreePayload DEPRECATE (Wire-Format = #19-voller-Resolver, Band-C-deferred; never-delete → nur Banner) · run_methodology verdrahtet die EINE `measure`-Strecke, debug/release-Fanout = S6 · rebuild+measure im Mess-Job (Tier-DLLs sind keine CI-Artefakte zwischen Jobs) · Gate-Var `COMDARE_MEASURE_PROFILE=="smoke"` wiederverwenden.
**S5-Driver Blocker-Entscheid:** Option (a) — Scope-Erweiterung auf 3 Fassaden-Dateien (progress_sink-Feld nach cache_push-Machart), weil ein main.cpp-only-Weg die RunProfileArgs-Welt in die Treiber-TU zöge = Behelfsweg (verboten: „NUR EIN XML-Programm").
**FP-3-Entscheid (A1) gebilligt:** `page_type` = Baum-Knoten-PageKind (`axis_01_page_type`, Build-Variante, DefinitionOnly), NICHT Hardware-Huge-Page (§52-B10-Namensfalle) und keine der 17 Organ-Achsen → dritter Weg: raus aus permute_axes, als Zukunft-Build-Variante dokumentiert (0 Rejects, kein Bloat).
**Telemetry-Entscheid (A9.3) gebilligt:** `tp->telemetry_silent` NICHT durchgereicht — hätte `+tel=silent` an golden-build_version gehängt = Byte-Identität gebrochen; bewusst als absprachepflichtiger Folge-Schritt dokumentiert.
**Post-v3 §60:** R1 .so-ABI-Vertrag Planer↔CEB (mit Historien-Notiz: rekursive Dock↔.so-Doktrin am 19.07. dekretiert, Fork-C nur **deferred**, nicht hart verworfen) · R2 Driver-Split-Hypothese · R3 Planer-CLI + Zustands-Logging + manuelles XML-Fahren + User-Kurations-Direktive (Fable kuratiert deprecated Features).

═══ (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS ═══

| Paket | ce | super | CI |
|---|---|---|---|
| Runner-Tags (Weg a) | — | — | API PUT /runners/16, HTTP=200; 6 Bestands-Tags + x86_64 + 13 AVX512-Sub-Flags; prod2/Runner 17 bleibt ohne avx512 |
| S2/A4 | — | ae9d42b | 11747 grün (Task #11 fertig) |
| **KERN-A** (K1–K4/K6 + benanntes `<template>`) | `c395743e` | `614e89f` | ce 11762 success |
| Kontext-Log-Doc | — | `0fff010` | — |
| **Persistierung #22** (Ledger §59 + §59-G + CHRONIK U-1…U-11/F-1…F-9, 9 Doku-Dateien, deletions=0) | — | `f37043a` | — |
| dev→main FF-Merge | main `a87d6d5b`→`c395743e` | main `4612133`→`f37043a` | beide Remotes |
| Infra-Handover (`Cluster/docs/sessions/2026-07-20-INFRA-HANDOVER-…md`) | — | Cluster-Repo `a0771b4` | PAT-#327, config.toml-Durabilität, 2^17, MinIO V90/V91, avx512/#276 |
| **A1** (S3-Resolver produktiv + cacheline_study kanonisiert) | `7c279c3c` | `46b605c` | ce 11767 success |
| **A5** (§56-T2-FANOUT D4, Combo-Selektor) | `e6257101` | `e6262e0` | ce 11775 success |
| **A10** (Doku-Nachzüge, 15 additive Edits) | — | `3ddd68a` | super 11789 success |
| **A9.1+A4** (3 Registries, Schema, XSD) | `5da2fd4b` | — | — |
| **A9.3** (PILOT-ENV-Ablösung) | `67f609d5` | — | — |
| **A6** (CoR `resolve_selection` aktiviert) | `a9326342` | `74fa599` | ce 11793 / super 11794 success |
| **A9.2** (8 Profile + SCHEMA.md, 168 ins / 0 del) | `97bc930d` | `9026e00` | ce 11798 / super 11799 success |
| **A8A3** (A3 Tag-Liste + A8a-Symmetrie + Bare-Metal-Re-Beweis perm.dll=69) | `7f3ce78b` | `c7ad515` | — |
| **KERN-B** (K6a→K5→K7a; POD sizeof 56→72, layout 2→3, CRC 0xF1C1F26A1232073B unverändert) | `7add41fc` | — | — |
| Endwelle | `64aec1c0` | `f79b538` | ce 11812 / super 11813 success |
| Session-Doku AUTONOM-03 | — | `5e1c656` | — |
| **S5** (P1/P2/P4 Planner + P3 Driver) | `90eecd43` / `25624259` | `01582b0` | ce 11827 success; **super 11828 FAILED** |
| S5-cf-Fix | — | `a785868` | super 11832 success |
| **Ledger §60** (R1/R2/R3 Post-v3) | — | `faeb410` | — |

Belege, die durchgehend als Abnahmekriterium galten: CRC64 `0xF1C1F26A1232073B` literal unverändert · RegistryTrio 17/5/16 · cf22 (clang-format-22.1.8 --dry-run --Werror) = 0 · Mojibake `grep -cE 'Ã|â€'` = 0 · super-Sub-Build `messung_driver` EXIT=0 · golden-Byte-Wache `test_smoke_coverage_profile`.
Literale Zusatzbelege: A5 default-vs-`_all_` byte-gleich, `_nomatch_` → 0 tier:build-Jobs · A8A3 Bare-Metal §5b `perm.dll = 69` (== dokumentiert, keine Drift, MANUAL_RUN.md unberührt) · KERN-B POD gemessen `sizeof=72 alignof=8 layout=3 offset merge_line=56 merge_len=64` · S5-Planner: tier:build-Blöcke byte-identisch zu HEAD (709 Zeilen, diff exit 0), alle 196 Diff-Zeilen nur im measure-Job · S5-Driver: 24 `[progress]`-Zeilen + `progress.cursor` (1980 B).

═══ (d) FEHLER + FIXES ═══

1. **Template-Kurskorrektur zu spät:** Manager hatte dem Impl-Agenten „mode=full ohne benanntes Element" gesagt; User-GO ③ verlangte das Element. Nachzug beauftragt → stellte sich als bereits gebaut heraus (Reconciliation-Überschneidung), zusätzlich Test `TemplateModeFullWithoutRefIsAccepted` ergänzt.
2. **Persistierungs-Scope zu spät:** §59 enthielt zuerst nur das KERN-Destillat, nicht den vollen Kontext-Log. Manager ergänzte selbst **§59-G**; der Agent hängte parallel den **CHRONIK-Block** an → beide landeten unbeabsichtigt gemeinsam in `f37043a` (Working Tree danach sauber); Post-hoc-Spot-Check: faithful, U-1…U-11 verbatim, keine Korruption.
3. **`validate_profile.hpp:138 preview_values` vor Deklaration** (transienter Mid-Edit-Zustand von `Impl-A9-Schema`) brach die geteilte TU → von A6 und A9-Pilot gemeldet, von A9-Schema gefixt (`preview_values` jetzt Z.129 vor `check_measurement_sub_axis`).
4. **A5-Smoke-Fehlmessung des Managers:** default=0 tier:build-Jobs → Ursache Bare-Name-Profil-Pfad-Resolution; mit vollem Pfad default=33 / `_all_`=33 byte-gleich, `_nomatch_`=1 (nur Kommentarzeile; autoritativ ist der ctest `count("# JOB tier-build ")==0`).
5. **cf22-Vorschnell-Commit** in der KERN-B-Welle → sofortiger Nachfix; Lehre in AUTONOM-03 festgehalten.
6. **super S5-Pipeline 11828 FAILED** (ce war grün) → cf-Fix → `a785868`, 11832 success.
7. **`test_axis_sweep_pilot:238` erwartet 19, live 18** (ABI-6-Drift; EXCLUDE_FROM_ALL, kein ctest → bricht CI nicht) → A11-P7-1-Zeiler; Manager maß später per-K-Levels **= 17** (nicht 19/18) und korrigierte stale Doku („Sonde statt Kommentar-Glauben").
8. **S5-P3-Blocker:** Fassaden-PODs `ProfileRunArgs`/`ExperimentRunArgs` tragen kein `progress_sink` (Plan-Symmetrieannahme zu cache_push hielt nicht) → Option (a), 3 ce-Fassaden-Dateien + Treiber, No-Op-Default byte-neutral.
9. **Reife-Check-Korrekturen:** super-HEAD ist `faeb410`, nicht `01582b0` · die „105 echten ycsb-Messzeilen" waren Fehlzuordnung (stammen aus ce `418e4b76`/§52-B11, nicht aus der scharfen S5-Kette; Bare-Metal-Beweis ist provision-only-BAU, `measured=0`) · Voll-2^17 = **524288 DLLs** (4 System-Perms × 4 Chunks × 32768), nicht 131072; ~224 GB, ~24 h.
10. **Doku-Drift-Funde:** `<system_axes>` war in SCHEMA.md gar nicht dokumentiert (A9.2-Nachtrag) · `profile_run_facade.hpp` stale DocComment `tier:build:[a,b,c]…` (durch A5 gefixt) · welle10-BAUPLAN:21 einzige genuin live-stale Fehlform (A10-B1).

═══ (e) OFFENE FÄDEN AM CHUNK-ENDE ═══

**Laufend:** Smoke-Pipeline **11840** (S5-Gate: dynamische Kette + Real-Messung in CI, `COMDARE_MEASURE_PROFILE=smoke`), Monitor `b737l57et` · Workflow **`deprecated-features-audit`** (4 Sonden: Code-Inventar, Docs-Inventar, Tiefensonde R1 Textemission-vs-.so, Tiefensonde R2+R3) — die vom User verlangte kuratierte Zusammenfassung ist NOCH NICHT geschrieben · `Plan-ReifeCheck`-Report läuft am Chunk-Ende **mitten im Text aus** (Abschnitt (B) Gesamt-Verdikt gerade begonnen).

**Reife-Check-Verdikt (soweit im Chunk enthalten):** **NEIN** — Voll-2^17 ist jetzt nicht reif und für 28.07. nicht nötig (28.07. = golden-**320**, 2^17-Voll-Messung erst ab 01.08.; Faktor 1:1638). Es fehlen: (i) `measure:smoke` literal `status=success` über die scharfe Emit-Kette (measure:smoke ist opt-in und fährt ein FESTES Profil; die dynamische Kette ist inert-by-default), (ii) Mess-Tooling-Fan-out (P-MESSTOOL/S6). Stempel-Stabilität ✓ (K7b folgenlos deferrbar), A7 vor Materialisierung nicht nötig ✓, Cache/Resume = Mechanismus da aber gated + kein `retry:` (Betriebsrisiko mehrtägig), §60-R2/R3 offen.

**Beim User offen:** F27 — welche `experiment_golden.xml` ist kanonisch (super `test_data_xml/` Master vs. ce `thesis_tiere/`-Kopie; Sync-Bridge grün) · PAT-Rotation #327 an den Infra-Agenten delegiert (Handover geschrieben; Manager rotiert nicht autonom) · E-1/E-2-Restfragen zu cacheline_study (per_organ/modes strenger kanonisieren?) · strikt-ASCII auch für `§` (Impl-S5-Planner-Rückfrage) · `measure_out`-Fenster == `COMDARE_GN_TOTAL`? (Annahme des S5-Planners).

**Nächste Schritte laut Manager-Fahrplan:** Audit-Zusammenfassung schreiben → Reife-Verdikt umsetzen → A7 (W8-Flags) planen, A11-Mini-Fixes im Integrations-Pass, Task #33 (9dim-Dach-Rehang + constexpr-Gate) → S6 (N>1 scharf, 320er) → S7 → S8 (28.07., Anhänge B/E autonom). Post-Abgabe: K7b §58-Array, K8/§58-MINIO Storage, §58-REPLAY, Fork-3/4-Scharfschaltung.

Quelldatei: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_25.txt` (2356 Zeilen, vollständig gelesen).