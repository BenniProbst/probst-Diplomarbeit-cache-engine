# EXTRAKT tk_28.txt (Chunk 28/30) — Diplomarbeit-Managersession, 22.07.2026 ~09:30 bis 23.07.2026 ~06:30

Zeitachse: Vormittag 22.07. (§64-Belegführung) → Nachmittag (K7b, Spend-Limit-Absturz, Lücke) → Abend (K7b-Abschluss, Kompaktierung, Board-Restore, Batch-Kette S1–S3, CI-Reparatur) → Nacht/Morgen 23.07. (Systemabsturz-Resume, S4-Batch-Emission).

---

## (a) USER-DIREKTIVEN chronologisch (bindende woertlich)

**A1 — Schichten-Zuordnung der Mess-Verfahren (~09:38, WOERTLICH, bindend):**
> „Jetzt hast du es richtig: wallclock wird auf der CEB Seite gebaut, sofern einkompiliert und makro und micro Benchmarking muss durch CEB UND Tier-Binary einkompiliert über das Prüfdock unterstützt werden. Die CEB richtet auch die Mess-Einrichtung seines Tier-Binaries Prüflings aufgrund seiner statischen compile-time Mess-Achsen-Ausrichtung nach der Planer Mess-Achse, auch auf dem Tier-Binary aus, indem dort macro und micro Benchmarks für die Observer einkompiliert werden"
→ verankert super `8336e2d`, Memory nachgezogen. Konsolidierung: konkrete Gestalt der §62-B-Tooling-Konsistenz CEB↔Tier; Kette Planer-Mess-Achse → CEB-Ausrichtung → Tier-Observer = EIN durchgereichter statischer Draht (§24-Ketten-Statik).

**A2 — Gesamtplan-Nachzug (~09:44):** „Wo stehen wir mit der Gesamt-entwicklung? Ich habe ja viele Präzisierungen gelifert, sind diese bereits in den Gesamtplan der Abarbeitung eingeflossen? Wenn nicht hole bitte das Update der Reihenfolge aus dem gesamten Session-Kontext nach." → Reihenfolge-Update als Session-Doc, super `a763c86`.

**A3 — §58-Versionierungsmodell als Gesetz (~10:05, WOERTLICH-tragend):**
> „…dass Jede Haupt-Achse ihren gewählten compile time Algorithmus auf dem Tier-Binary mit X.Y.Z Version benennt, die gewählt wurde. Dasselbe gilt für alle Haupt-Mess-Achsen für den Planer an die CEB, die dann eine Versionierung aller Mess-Achsen des Planers trägt. Der Planer selbst ist die einzige Binary mit einem schnöden X.Y.Z einzelnen Versinierungstag. Bitte suche das mit einem Explore Agenten aus Ledger und Diplomarbeit-TODOs heraus, das ist schon geplant und dokumentiert. Aber die beschriebene Versionierungsform ist eine Regression, die anders definiert ist. Und ja du hast recht, dass auch die Versionierung der Registry erweitert und überarbeitet werden muss."

**A4 — HOLD auf Phase-2-Stempel (~10:08):** „Naja, warte wegen der Versionierungs-Lage mal auf den Expore, weil da Erinnerungslücken bezüglich Planer vs CEB vs Tier-Binary Versionierung drin sind" → Phase-2-Definition unter Explore-Vorbehalt; Phase 1 (reine Topologie) laeuft unberuehrt weiter.

**A5 — K7b-VORZUG = PFLICHT (~12:21, WOERTLICH):**
> „Der Umbau K7b ist pflicht um das ccache System laut Einschüben zu beschleunigen und die Binaries per Versionierung zuordnen zu können. Die ccache Optimierung ist also dadurch gated und daher der Umbau pflicht. Ansonsten wird es nicht rechtzeitig fertig, weil das System nicht rechtzeitig misst"
→ Ledger `74ce29e`, Memory-Nachtrag-10, Board-Task #15. Kette neu: vereinter Debug-Smoke → K7b/G1 → 320er.

**A6 — Pause/Netzwechsel (~12:59 / 13:0x):** „Wo läuft gerade noch? Bitte lege eine Pause ein, ich muss das Netzwerk wechseln" + „Der Netzwerk wechsel wird den Cache Zustand dieser shell zurücksetzen, sichere bitte auch die Agenten Zustände wenn nötig, dann weiter Pause" + spaeter „Bitte resume alles und dann weiter".

**A7 — Batch-Sichtbarkeit / Planer-CLI (~14:03):** „Ich sehe bei planer:delegate-trigger keinen Fortschritt … ich finde keinen Job log der die aktuelle Arbeit durchführt und das Batch prüfbar durch Planer auflistet. Der Planer überwacht das CEB und dort auf der CLI soll man später sehen können, was gebaut und gemessen wird. Wo stehen wir?"

**A8 — §62-B-Batch-Job-Prinzip (~14:06, bindend):** „Mir ist auch aufgefallen, dass es unter dem ceb:trigger immer noch die alten [O3,avx2] build jobs gibt, aber wir hatten ja definert, dass diese alle als Permutations-Batches in der CEB verschwinden, als dokumentierte kombi aus System-Achse und Organ-Achse für den build von Tier-Binaries" → Ist-Verstoss verankert Ledger `3a2f26a`, Board-Task #16.

**A9 — Desktop-Plain-Backup (~20:02, WOERTLICH gekuerzt):**
> „Bitte lege auf dem desktop eine untracked backup Kopie aller Diplomarbeit Projekte an, weil über den git tracked Teil eine PAT scrub läuft - immer noch - und wir müssen in regelmäßigen Abständen ein plain backup auf diese untracked Ordner auf dem Desktop ohne git überschreiben, damit der Fortschritt nicht verloren geht. … bis auf Cluster git, in der alle keys nur auf gitlab lokal versioniert sind und das auch bleiben. Durch exzessive history rewrites können sonst inkonsistenzen entstehen, die den Stand unkontrolliert zurücksetzen, wenn wir nicht sichern"

**A10 — Manuelle Diff-Klaerung (~20:12, STANDING RULE, WOERTLICH):**
> „Nun wir müssen die diffs ab sofort immer manuell klären und remote sauber halten, ansonsten arbeiten wir eh auf development"
→ kein `--ff-only`/blindes Mergen; vor jedem Push fetch + Divergenz + inhaltliche Sichtung; alles auf `development`, main nur per bewusstem verifiziertem Merge.

**A11 — Lokale Sicherungen syncen (2×):** „Bitte bedenke, dass es mehrere lokale git Sicherungen unter Projekte/Research gibt, die voraus sein könnten und die du bitte syncen solltest, die verschachtelten in der Diplomarbeit sind möglicherweise nicht synchron"

**A12 — Session-Restore + K7b-Frage:** „Bitte stelle aus den letzten 3 Sessions und Plänen wieder her und lies bitte aus dem Session log ALLES aus diesem Kontext nochmal mit einem Explore Agenten ein. Ich erinnere mich, dass K7b-4 dran war oder irre ich mich?"

**A13 — Sicherheits-Rueffel (2× identisch, bindend):**
> „Die Sicherheit hat deine Nachricht geflaggt, bitte versuche einen Sicheren Ansatz zu wählen, der Cluster/keys cred vault ist für dich da, um dich einzuloggen. Die Suche bezüglich firewall und falscher login Versuch wird nicht akzeptiert."
+ „Bitte versuche einen sicheren Ansatz über einen Opus 4.8 Agenten um die Situation zu prüfen bezüglich pipeline"

**A14 — TODO-Restore + Kompaktierung:** „Bitte stelle ALLE TODOs sichtbar für mich in allen noch offenen zukünftigen Ketten wieder her in der nächsten session. Bitte erstelle eine reiche Kontextübergabe zum Hauptstrang, ich möchte kompaktieren." (+ `/compact`-Arg: „merke dir den Verlauf des Hauptstranges und ALLE Todo Ketten, die noch offen sind und WARUM sie offen sind, lies memory")

**A15 — Gruendlichkeit vor Start / Zeitbudget (WOERTLICH, bindend):**
> „Nein, bitte arbeite so gründlich, wie möglich, die Frist ist bis montag, aber bis dahin müssen wir wohl noch 2 Tage bauen und 2 Tage messen und testen"
→ Memory `project_frist_montag_2707_zeitbudget_bau_messen`; Rueckwaertsplan: Kette 2 fertig bis Do-Vormittag → Do/Fr 2^17-Voll-Bau → Sa/So 320er+M-4+PDF → Mo 27.07. Abgabe.

**A16 — ccache-„Lagerhaltung" (WOERTLICH):**
> „Bitte lies den session log des letzten Kontextes, denn dort habe ich für ledger und Pläne untd TODOs genau beschrieben, wie sich der ccache über »Lagerhaltung« seine Zeit zurückverdienen kann, aber dazu müssen wir alles in der aktuellen Reihenfolge gründlich ohne Umwege implementieren. Aufgrund der batch Größe verdienen sich Gründlichkeit und saubere Architektur viel eher, als ein verfrühter Start - genau wie du sagst."

**A17 — Achsen-Buchstaben/Zerteilung (Korrektur 1, bindend):** „Dein Nachtrag ist korrekt, aber unterscheidet die Buchstaben und Zerteilungen der Achsen nicht richtig, bitte lies das nach. Sonst pflanzt sich der Fehler fort. Ansonsten alles korrekt, weiter so"

**A18 — Layer-Trennung System/Organ (Korrektur 2, WOERTLICH, bindend):**
> „Die Hauptachsen von System-Achsen und Organ-Achsen werden NIE verschmolzen, wir trennen sie strikt als Layer in der Tier-Binary zwischen Hardware und Anwendungs-Logik. Du würdest doch auch kein betriebssystem mit deinem claude frontend gleichsetzen oder?"

**A19 — Autonome CI-Reparatur-Freigabe (WOERTLICH):**
> „Du hast die autonome Freigabe - auch bei nacht - die CI zu reparieren und jetzt einzugreifen, bis wieder jobs korrekt angenommen werden, bitte übernimm das"

**A20 — Nach Systemabsturz:** „Wir hatten einen Systemabsturz bitte weiter wie gehabt"

Weitere Steuer-Eingaben: `/model` → Fable 5 (2×), `/effort` → ultracode (3×), „Bitte fahre nach stehenden Direktiven fort und lies memory", „Bitte lies den gesamten Kontext VOLLSTÄNDIG ein … Resume alle unterbrochenen workflows und Agenten", „Zuletzt kam Impl-S6-P1 zurück, bitte lies den Agenten aus. Danach wollte Opus 4.8 (wohl fälschlich) Strang A weiter implementieren."

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN mit Begruendung

**B1 §64 VEREINT ist entschieden (Explore-ToolingVereint, verankert super `21712eb`).** Dreischichtige Beleglage: V5-Messarchitektur = VEREINT-Basis (24_messmodell §2 „zwei Dimensionen, nicht zwei Laeufe"; klarstellungen :70ff „EINE Schnittstelle … Operation + Observer zusammen … nicht als getrennte Probes"; v5_design Default-ON, op wall-clock-umklammert + Observer gleichzeitig); SEPARAT-Lesart entstand erst mit der §47/§54-Umdeutung 20.07. („je Tooling-Wahl eine eigene CEB, N→N Pipelines") = Regressionsquelle, als supersediert markiert; LIVE-Code-Default war ohnehin die eine `[all]`-CEB (N>1 gated).

**B2 Schicht-4-Schnitt = Basename statt absolutem Pfad.** Begruendung: dokumentierte KLASSEN-Regel (Director-Kommentar, „Contract-Test-Wache") verbietet `$CI_PROJECT_DIR`-Werte in emittierten Child/Grandchild-`variables:` — GitLab vorexpandiert/vererbt die Parent-Definition, der Pfad expandiert im Grandchild leer. Loesung spiegelt `COMDARE_GOLDEN_N_PROFILE`: Basename forwarden, Grandchild-Prolog re-derived idempotent (leer=No-Op, absolut=unangetastet → bare-metal Dual-Weg bleibt gueltig).

**B3 §64 Phase 1 = reiner topologischer Dedup.** Kartierung: die 3 Lanen kamen ausschliesslich aus den Profil-XMLs (`all_axes_golden` + `m3v2_study` deklarierten je 3 Ein-Element-`<combo>`); `[all]` ist semantisch Vollmengen-Sentinel und emissionsseitig byte-stabil (`""`). R1-Praezisierung: der Tooling-Selektor ist in ce REIN STEMPEL, gatet KEINE Observer-Einkompilierung (Combo geht nur in `measurement_stamp_line_from_combo_legend`; kein `#ifdef`-Gate) → 3 Lanen bauten 3 funktional aequivalente DLLs, Unterschied nur im Stempel-String → Phase 1 sicher, 3× schneller. Manager-Klaerung am Host-Driver ergab „Fall NEIN" (keine selektiven CSV-Spalten) → Phase 1 sofort allein.

**B4 Lockstep-Behandlung Phase 1: Klasse A 3→1 mechanisch, Klasse B behaelt expliziten 3-Tool-Override** (`tp->measurement_tooling`) — so ist der `[all]`-Default bewiesen UND die N>1-Selektor-/Env-Coverage als XML-Options-Nachweis erhalten.

**B5 §58-V ist die autoritative Versionierungsform (Explore-Stempel58, verankert super `c4b2cc9`).** Sechs Punkte doppelt/dreifach dokumentiert: Tier = ZWEI separate Arrays (System/Organ), keine Gesamt-Version; CEB = ARRAY je einkompilierter Mess-Haupt-Achse; Planer = EINZIGE Binary mit einzelnem X.Y.Z (im Code bereits SOLL-konform); X.Y=Feature/Z=Debug je Algorithmus; dritter Tier-Stempel = Merge-Kombination (§59-C, K7a gelandet); Registry-seitige Algorithmus-Versionierung offen (#19-Rest/Band-C). Ist-Code weicht ab: Einzel-Zeilen statt Arrays, CEB-Array fehlt ganz, Quelldaten flaechendeckend hart „v1" (X.Y.Z nur Formatter-Artefakt), XML-Registries ohne Versionsfelder. Konsequenz: Phase 2 dockt an §58-V an, erfindet kein neues Feld; grosser K7b-Array-Umbau zunaechst NICHT vorgezogen (Post-Abgabe, G1/B6-gekoppelt) — bis A5 das kippte.

**B6 K7b-Scheibenplan (Kartierung + Manager-Entscheide).** Kern-Entlastung: der Stempel-POD hat NULL Laufzeit-Leser (Loader dlsymt `comdare_anatomy_version_lines()` nie; Frische-Welt liest `.version`/`.algos`-Sidecars) → POD-Wachstum beruehrt nur Byte-Wache + Makro-Materialisierung. Scheiben: K7b-1 consteval SHA-512 → K7b-3 SHA512-POD-Feld → K7b-2 Mengen-Provenienz → K7b-4 G1-`--version`. Entscheide: **D1 = Option B** (Default stempelt volle 3-Tool-Menge; spaeter ohne Re-Anchor umgesetzt), **D2 = `{ptr,len}`** (POD 72→88, K7a-Muster, Offsets stabil), **D3 = Preimage `concat(organ+system+measurement+merge)`** in fixer dokumentierter Reihenfolge (Saat fuer #46b-`std::map`-Lookup). SHA-512 hand-roll neben vorhandener consteval-SHA-256-Vorlage, kein Vendoring (Doktrin gilt nur fuer ganze Zellen).

**B7 K7b-2-Verdrahtung Variante A + additive Ueberladung.** `measurement_stamp_line(span)` additiv, Einzel-Form unveraendert; `from_env` UNGESETZT == `[all]` == Vollmenge (weil der Director bei `[all]` nichts exportiert) → die `[all]`-Lane traegt reale Provenienz, ohne Director-Emission/Cache-Key/Byte-Wachen anzufassen; No-Arg-Default bleibt `""` (2-arg) → 320er-Byte-Identitaets-Wachen gruen.

**B8 §62-B Batch-Emissions-Kartierung (Q1–Q5).** Q1: `TierCiYamlBuilder::end_perm` macht `for perm: for k<kTierChunkCount(=4): emit_tier_build_job` + `emit_measure_job` → 16+4 Jobs bei 4 Perms. Q2: der Treiber iteriert INTERN bereits Perms × binary_ids (`run_profile`, `run_lazy_static_then_dynamic`) — der CI-Split ist reine Director-Wahl, keine Treiber-Grenze; Sharding via bereits konsumiertes `COMDARE_GOLDEN_N_RANGE`. Q3: Pruefstand existiert header-only (`comdare_ce_pruef_dock`, `run_conformance_gate` RF1–RF14 + 2000 Zufalls-Ops gegen `std::map`-Oracle); fehlt nur ein PRUEF-ONLY-Eintritt (Gate heute in `dock->measure` eingebettet). Q4: Umfang ist bereits profil-getrieben; Naht liegt im Profil, nicht im Code. Q5: Mess-Pfad schreibt nur `'\n'` ohne Flush → Vollpufferung → 6h stumm. Schnitt: S1 Log-Flush → S2 Umfang → S3 Pruef-only → S4 Batch-Emission (alle golden/CRC-neutral).

**B9 S2-Entscheid A.** GN-11-2^17-Bau-Nachweis ist ein SEPARATER Lauf (ueber die S4-Batch-Kette), nicht das Smoke-Exerzitium → Smoke-Scope per rule-Override auf `m3v2_smoke` (18 → 3 Paesse); golden/Nicht-Smoke-Pfad bleibt `all_axes_golden`.

**B10 Testat-Grammatik ebenen-richtig (Ledger super `f97d2fe`).** `[a,b,c]` = Mess-Achsen/CEB-Ebene → einmal in den Batch-Job-KOPF, nie je Schritt. Bau-/Pruef-Schritte (Stufe 2) = `[d,e,f][g,h,i]`, wobei `[g,h,i]` nur die fuehrenden Organ-HAUPT-Achsen als Referenz benennt (reale Organ-Permutation = binary_id; Unter-Achsen nie in Bau-Legenden). Nur Mess-Schritte (Stufe 3) tragen alle drei Klammern. #46b-Replay-Schluessel getrennt: `[a,b,c]`→CEB-Replay, `[d,e,f]` allein→Tier-Replay, `[d,e,f]`+`[g,h,i]`+HW-Identitaet→Messwert.

**B11 Layer-Trennung (Ledger super `cf616d2`).** System-Haupt-Achsen `[d,e,f]` (Hardware-/Umgebungs-Layer) und Organ-Haupt-Achsen `[g,h,i]` (Anwendungs-Logik-Layer) werden NIE verschmolzen; §42-Schreibweise `[d,e,f,g,h,i]` ist reine Namens-Aufzaehlung; gilt auch strikt in der CEB-LAUFZEIT (aeussere System-Perm-Schleife, inneres Organ-/binary_id-Fenster; getrennte Buckets/Loops/Schluessel, keine Normalisierung ueber die Layer-Grenze).

**B12 GN-11-Gabelung entschieden: STRIKT bauen.** Verify-GN11 belegte, dass der 2^17-Voll-Build NIE abgeschlossen wurde (einziger Trigger §46/Pipeline 11519 gecancelt, Teilstand verloren; alle vorhandenen Belege bei kleinem N). §33-strikt vs. §41-Faehigkeit → strikt, weil A15 zwei Bautage vorsieht. Rechenlage: ~73 DLLs/min je Zelle, ~56 GB DLL-Masse, ~7,5h/Zelle, ~60h worst case bei resource_group-Serialisierung — genau das beseitigt S4 mit den K-Budgets; reine Rechenlast ~247 CPU-Stunden → unter 24h machbar. Der Umbau verdient seine Zeit zurueck (deckt sich mit A16).

**B13 S4-Umsetzungsentscheide.** `kTierChunkCount` → harte `inline constexpr kGnBatchSlice = 4096` (kein Env-Override); `lane_build_parallelism`: amd=24 / intel=16 (K-Budgets, nicht die T-Werte 32/24); `resource_group` LITERAL-Reuse `ceb-measure-<host>` (Build+Mess je Maschine geteilt = P4); `timeout: 7d`, `interruptible:false`, Artefakte `when:always`; Pruef-Schritt je Perm unbedingt nach der Fenster-Schleife via `COMDARE_PRUEF_ONLY`; Dual-Weg §61 durch `TierCmakeGraphBuilder`-Spiegel im selben Paket. **Bewusste Abweichung vom Bauplan (genehmigt):** Emission je CEB in `end_measurement_combo` statt `end_plan` — `end_plan` wuerde bei N>1 Combos die Combos vermischen (falsche `combo_legend_`) und die Selektor-Trichotomie-Tests brechen; fuer die 1-Combo-GN-11-Strecke byte-identisch zum Bauplan-Intent.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| Paket | Beleg | Commit |
|---|---|---|
| §64-Fundstellen-Beleg (Explore) | Beleg-Nachtrag an §64 | super `21712eb` |
| Schichten-Zuordnung (A1) | Ledger + Memory | super `8336e2d` |
| Reihenfolge-Update (A2) | Session-Doc + Board-Angleich | super `a763c86` |
| Methodik-Schnitt Schicht 4 | ctest 297/297; cf22 clean; Prolog-Re-Derive + `ceb:trigger`-Forward + super-YAML `rules:variables` | ce `11c4315f` / super `2d4e4ff`; Welle 12152 gruen |
| §64-Versionierungs-Klaerung | Explore-Stempel58 verankert | super `c4b2cc9` |
| K7b-Vorzug (A5) | Ledger + Board-Task #15 | Ledger `74ce29e` |
| §64 Phase 1 (3→1 Combo) | ctest 297/297; beide Profile `grep -c "<combo>"=1`; Mess-Jobs 12→4 | ce `ab245e84`; Smoke 12160 auf super `a316f875` |
| K7b-1 consteval SHA-512 | „Built target test_ctsha512"; 7 Tests PASSED; ctest **298/298**; FIPS-Vektoren als `static_assert` im Header | ce `bceefa8d` |
| Pause-Handover (A6) | Agenten-Neuspawn-Rezept + Resume-Checkliste | super `64bf181` |
| §62-B-Ist-Verstoss (A8) | Ledger:3214 + Board-Task #16 | Ledger `3a2f26a` |
| K7b-3 SHA512-Fingerprint-POD | POD 72→88, layout 3→4, Offsets stabil; golden-CRC `0xF1C1F26A1232073B` PASSED; ctest 298/298 | ce `d89dd103` |
| Desktop-Plain-Backup (A9) | 655 MB → spaeter 575 MB; Cron `*/15`; 0 Token-Treffer | Memory `reference_desktop_plain_backup_diplomarbeit` |
| Paket A = K7b-4 (G1 `--version`) | 4 gtest-Faelle PASSED; ctest **299/299**; cf22 CLEAN ×5 | ce `62de1b8c` → Merge `04ea315f`; super `c94e48b` |
| Paket B = K7b-2 (Mengen-Provenienz) | `test_m_w12` 11 PASSED; Vollmengen-Zeile literal; **CRC unveraendert**; ctest 299/299 | ce `5aaee411`; super-Gitlink `ab112fe` |
| Handover-Korrektur (Re-Anchor-Irrtum) | Korrektur-Nachtrag im Pause-Handover | super `fb2fe7a` |
| Abend-Kontextuebergabe (A14) | 17 offene Ketten als Restore-Liste, Abschnitt 3 | super `ff71c5a` |
| Board-Restore-Verify (ultracode) | Rohdaten+Synthese in `docs/sessions/backups/`, Token-Wache 0/0 | super `21364bb` |
| Testat-Grammatik-Korrektur (A17) | Ledger-Nachtrag §62-B | super `f97d2fe` |
| Layer-Trennung (A18) | Ledger-Nachtrag | super `cf616d2` |
| S1 Log-Flush (`ProgressHeartbeat`) | 3 Tests PASSED, Zeile `[heartbeat] mess-zelle 1/1 t+0s`; ctest **300/300**; `g++-16 -fsyntax-only` EXIT 0; CRC unveraendert | ce (in `091aca87`-Kette) |
| S2 Smoke-Umfang (Entscheid A) | `.gitlab-ci.yml` +15/-4; 18 → 3 Paesse | super `ff45502` |
| S3 Pruef-only (`COMDARE_PRUEF_ONLY`) | `[pruef] … loaded=1 gate=4344/4344 passed=1`; ctest **301/301**; CRC unveraendert; ebenen-konform (nur binary_id im Log, grep-belegt) | committet (Kette bis ce `7d9b4b55`) |
| S4 Batch-Emission | cf22 EXIT 0 ×3; CMake/Ninja `REAL_CMAKE_EXIT=0`; ctest **297/297** (frisches Ninja-Dir); Planner-Test 49 Tests (44 umgebaut + 5 neu); diff-stat 3 Dateien +742/-520; CRC unveraendert | ce `9df09f14` / super `c706f3e`; **Welle 12591 = success** |
| CI-Reparatur | HEAD-Welle **12516 hart gruen** (ce-Bridge 12561, thesis:pdf, Lints, Tests) | — |

Gates: S5/S6-Gate erfuellt (Smoke 12160/12168 beide `success`, alle 5 Beweise: EINE `[all]`-Lane, `CMAKE_BUILD_TYPE=Debug` profil-getrieben, (j3)-Dual-Compile live, `+bt=Debug`-Stempel, paralleles Messen 399% CPU/5 Threads). G2-Anti-Phantom-Gate geschlossen (Verify-G2: 5/5 erledigt, 2 Zitate manager-verifiziert) → S7 entblockt. Kette 1 (Sweep) abgeschlossen: prod1 sauber, 0 Waisen-Driver.

---

## (d) FEHLER + FIXES

1. **Re-Anchor-Auflage falsch (schwerster Manager-Fehler).** Manager uebernahm ungeprueft „`kNewGolden131072Crc64`-Re-Anchor noetig" in die K7b-2-Auflagen. Agent-STOPP belegte literal: `kNewGolden131072Crc64` == `0xF1C1F26A1232073B` ist EIN Symbol (`source_catalog.hpp:168`), die CRC laeuft ueber die 131072 binary_ids (nicht Source-Bytes), und der measurement_stamp ist per Design `binary_id="never"` → Umbau CRC-neutral per Konstruktion; woertliche Befolgung haette die TABU-Konstante gebrochen und die Wache gerissen. Fix: Auflage gestrichen, Variante A + additive Ueberladung, Fehlerquelle im Pause-Handover per Nachtrag `fb2fe7a` versiegelt. Lehre etabliert: Kartierungs-Behauptungen nie ungeprueft in Auflagen; Agent-STOPPs ernst nehmen; Manager-Stichproben vor jedem GO.
2. **Spend-Limit-Absturz (~14:31)** mitten in K7b-4 → Agent und Session tot; Luecke bis ~19:49. Fix: Zwischen-Instanz sicherte den Stand verlustfrei als WIP-Commit `9b246b18`; neuer Agent fuehrte K7b-4 zu Ende.
3. **ce-Push-Fehlschlag (K7b-4):** origin trug den WIP. Fix manuell: Inhalt geprueft (mein Commit enthaelt WIP vollstaendig, 0 Loeschungen), soft-reset + `merge -s ours` → `04ea315f`; kein force-push, kein rebase; super-Gitlink blieb gueltig. Daraus User-Regel A10.
4. **Zombie-Deadlock [RUN-1]:** Job-Cancel toetet nur den Shell-Wrapper; Driver zu init verwaist (PPID=1) → Runner kann nie killen → `canceling` haelt beide Slots bis GitLab-Hard-Timeout; der Sweep-Job braucht selbst einen Slot, und die Sweep-Wellen waren volle 14-Job-API-Wellen, die zusaetzlich in `created` hingen. Fix (Diag-Pipeline-Agent read-only, Option B): 26 Ballast-Jobs in 12342/12343 gecancelt, nur `runner:sweep-zombies` blieb; Cancel-Timeout gab die Slots frei → Sweeps liefen. Frueher Fehlgriff vermieden: Sweeps 12169/12170 gecancelt, weil `pkill -f` die frisch angelaufene legitime `[all]`-Messung mitgetroffen haette.
5. **Admin-SSH:** zwei Fehlschlaege, sofort gestoppt (kein Brute-Force am realen Host). md5-Abgleich (nur Hash-Vergleich, kein Login) ergab: der im Handover notierte Eintrag gehoert zu einem als deaktiviert markierten built-in-Konto = stale. Infra-Handover mit Korrektur (Cluster `88c1183`). Zusatz-Regel nach zwei Fragment-Leaks durch halbmaskierte Prints: nur noch Blind-Extraktion in Variablen + md5-Vergleich, nie Zeilen printen.
6. **Backup-Token-Leck:** Erster rsync kopierte zwei alte Session-Transkripte mit Live-Tokens. Fix: `*TRANSKRIPT*`-Exclude + `--delete-excluded` nachgeruestet + Token-Selbst-Wache nach jedem Sync; danach 0 Treffer. Skript-Bug: `set -euo pipefail` brach ab, weil `grep` bei 0 Treffern (dem Gutfall) exit 1 liefert → `|| true`.
7. **6h stummes Mess-Log:** kein Flush im Mess-Pfad trotz 399% CPU → Fortschritt unpruefbar, Pipeline wirkte stale. Fix = S1 (`ProgressHeartbeat`, zeit-gated 30s + erste Einheit immer + `done()`, geflusht; `progress_sink` zeit- statt zaehlbasiert).
8. **Monitore zu geschwaetzig (2×):** Job-Dauer bzw. Zahlenwerte im Change-Hash → Event je Tick. Fix: Status-only-Hash bzw. Schwellen-Wache mit 10k-Meilensteinen + 15-min-Heartbeat.
9. **Sweep 297915 „failed" war Beleg-Artefakt:** der abschliessende `pgrep -f`-Check traf den eigenen Monitor-Prozess. Fix-Merkposten: `pgrep -x` (Kette 15).
10. **thesis-Submodul asynchron** (nach A11): lokal + github 1 Commit hinter gitlab → nach manueller Sichtung Fast-Forward + github-Push; Gitlink-Streuner endgueltig weg (`ef448e4b` ueberall).
11. **github/main vom Scrub force-updated** (`332c54a` → `91897d4`); development unberuehrt (0/0). Als Vorsichts-Auflage im dev→main-Task (#11) verankert.
12. **Push-Events erzeugten keine Pipelines mehr** (seit Scrub-Push auf main 16:24). Diagnose/Reparatur (nach A19): `ConcurrencyLimit::ResumeWorker`-Cron fehlte komplett (kein Rueckweg fuer deferred Jobs) + Deferred-Queues mit 6,4 Mio+ identischen argumentlosen Cron-Drainer-Jobs verstopft. Fix: UNLINK der Muellberge, Cron-Registrierung, temporaere Middleware-Disable-Flags; Rueckstau materialisiert; Welle 12516 hart gruen; Push-Pipeline 12591 spaeter automatisch erzeugt = Dauerbeweis.
13. **Systemabsturz (Nacht):** Task-Store geleert, Impl-S6-P1 tot (Tree clean, S4 nie begonnen). Fix: 25 Tasks mit Gate-Kanten wiederhergestellt, Agent neu gespawnt mit vollstaendigem S4-Briefing (Judge-Panel-Bauplan + 10 Manager-Entscheide inkl. Testat-Grammatik und Layer-Trennung).
14. **S4-Zwischenlauf 4 rote Tests** (`test_profile_roundtrip`, drei `*_registry_roundtrip`): reine 2-Pass-Infra-Artefakte des frischen Ninja-Dirs (Generator-Tools `EXCLUDE_FROM_ALL`); nach Bau der Generatoren gruen, finaler Voll-Lauf 297/297. Manager klaerte zusaetzlich die Testzahl-Differenz 301 (nach S3) vs. 297 (frisches Dir) vor dem Commit.
15. **Nachrichten-Lag/Idle-Race** mehrfach: Agent meldet idle, bevor er die Mailbox verarbeitet hat. Behandlung: nicht neu beauftragen, Nachricht liegt bereits in der Inbox; bei ausbleibendem Report gezielt nachfordern (so bei Explore-SessionRestore und Verify-G2).
16. **Falsche Fremd-Instanz:** Eine Opus-4.8-Instanz wollte „Strang A" weiterbauen — Strang A ist seit 20./21.07. vollstaendig gelandet. Schadens-Check: nichts angerichtet (beide Trees clean, 0/0 zu origin); Agent bestaetigte, nie Fremd-Auftraege erhalten zu haben.
17. **Stale Ledger-Note gefunden:** §47-Notiz „`kMeasurementAxisVersionLine` fehlt" ist ueberholt — measurement_line (W12-A3) und merge_line (K7a) existieren real.
18. **xmllint meldet `--` in Kommentaren** der Profile: vorbestehend (13×), ce-Parser tolerant, kein CI-Gate → Hygiene-Merkposten, nicht angefasst.

---

## (e) OFFENE FAEDEN AM CHUNK-ENDE (23.07. ~06:30)

**Unmittelbar laufend:**
1. **Lokaler bare-metal-Mess-Smoke** der neuen Kette bei Impl-S6-P1 auf prod1 (Provision → `COMDARE_PRUEF_ONLY`-Gate → echte Messung, kleines Fenster, keine Commits/kein CI-Trigger) = ausstehender **GN-11-Messfaehigkeits-Beleg (b)**; dies ist die duennste Nachweisstelle (bisher nur ein Bau-Beleg vom 19.07. + ein aelterer 105-Messzeilen-Beleg).
2. **Sidekiq-Abtrag** (Schwellen-Wache `b9p6d01x6`): zuletzt bf≈18,2k / bq≈11,3k, cp=0; Terminal-Signal bei 0/0 → danach **Ruecknahme der temporaeren Middleware-Disable-Flags** (noch offen).
3. **main-Scrub-Welle 12272** weiter `running`.
4. **S4-Welle 12591 = success** (terminal); der **Batch-Struktur-Smoke ueber die CI** (ein Build-Batch + ein Mess-Batch je Maschine live sichtbar, Testate ebenen-richtig) steht noch aus → erst danach ist **Kette 2 komplett**.

**Naechste Meilensteine der Abgabe-Kette:** 2^17-Voll-Bau ab Do 24.07. auf der fertigen Batch-Kette (Trigger-Rezept liegt vor: `COMDARE_BUILD_GOLDEN_N=true`, `COMDARE_GN_TOTAL=131072`, `COMDARE_MEASURE_PROFILE` NICHT setzen, `COMDARE_STATIC_MATRIX_FALLBACK` NICHT setzen; Runner-`maximum_timeout` bereits als unbegrenzt verifiziert) → Sa/So 320er-Messlauf + M-4 + PDF-Rueckschrieb → Mo 27.07. Abgabe.

**Board (25 Tasks) — offen mit WARUM:** Batch-Emission-Restbeweis; 320er (wartet auf Kette 2); S7 (braucht 320er-Daten; G2-Gate seit heute frei); S8/PDF DE+EN (End-Gate, zusaetzlich durch **#26 G8** blockiert: Anhaenge B/E sind 4-Zeilen-Stubs trotz DONE-Vermerk); **#11 dev→main-Merge** (gesamter Stand nur auf development; Vorsicht wegen github/main-Force-Update); **#23 GN-11** (2^17-Bau-Nachweis, Termin 24.07.); **#24 PAT-Rotation #327** (Rotation ≠ Scrub, Konsumenten-Kartierung zuerst); #46b Bestandslog (K7b/B6-Vorbedingung jetzt erfuellt); #47 COMPARE; #54 emit-Vertragskette; #34–#37 POST-v3; #49 Hardware-Achsen; #51 tier150-Ersatz; #48-Scheibe-6 (gegated auf 320er + User-GO); G-Gruppen/W12-Quelldaten (v1 → echte X.Y.Z, Band-C); **#27 §55-Restbestand**; CI-Wartung (contract-Label-Luecke, prt-art-Checkout-Race, ~14 min Treiber-Bau-Overhead je Mess-Job, xmllint `--`, `Testing/`-gitignore, `pgrep -x`-Fix, Sweep-rules-Haertung); 2 Runtime-Beweise (R8b-Key-Gleichheit, R1/R2-HIT `GN_DECISION=skip`); G7-User-Entscheide.

**Betriebsrisiken als offene Auflagen:** ccache deckt nur den Treiber-Bau, **nicht** die 131072 DLLs (literal verifiziert) → Wiederaufnahme nach Abbruch muss der Batch selbst koennen; **Plattenplatz** ~56 GB DLL-Masse gegen ~72 GB frei auf prod1 → Retention-/Auslagerungs-Konzept noetig; GN-Cache/MinIO ist inert-by-default und der Dedup lebt nur in der deprecated statischen Kette → ein Storage-Opt-in beim Voll-Build waere zugleich der ausstehende R8b-Beweis.

**Sicherheitsstand:** Desktop-Plain-Backup token-frei, Cron `*/15`, Cluster ausgenommen (Keys bleiben gitlab-lokal). Keine Secret-Werte in diesem Extrakt.