# CHUNK 27/30 — Chronologische Extraktion (Diplomarbeit-Managersession)

Zeitraum: ~21.07.2026 mittags bis 22.07.2026 ~09:30. Datei: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_27.txt` (1892 Z., vollständig gelesen). Chunk endet mitten im Fundstellen-Report des Explore-Agenten.

---

## (a) USER-DIREKTIVEN (chronologisch, wörtlich wo bindend)

**D1 — CEB-interner Batch + Prüfstand + Planer-Instrumentierung** (Z.21, wörtlich):
> "Wir müssen den letzten Punkt noch präzisieren, weil die CEB ja die builds und Messung der Tier-Binaries übernimmt. Wie folgt: Die Tier-binaries werden per runtime batch auf der CEB gebaut und dann direkt am Prüfdock über den Aufruf von google Tests als Prüfstand auf alle Funktionen getestet, ob sie per Interface korrekt funktionieren (beachte kompilationsstatus der CEB welche Prüf-Tools einkompiliert sind und welche dann auch das Tier-Binary beinhalten muss). Bedeutet der Batch geht nicht über shell, sondern CEB intern als eigenes Feature der CEB durch. Die CEB piped dann die shell Ausgaben des Status an den Planer weiter, der ja schließlich die emittet CEB aufruft und steuert. Das bedeutet, dass eigentlich der Planer aufgerufen wird, die CEB per XML-Anweisung zu instrumentieren, um mit ihr batches von Tier-Binaries zu bauen und zu testen, ob sie für die spätere Messung taugen (erst build+prüf Batch und nach Durchlauf erst die Messung)"
→ verankert §62-B in-place (super `ba543a8`), neues Paket **[#54]**.

**D2 — Volles Nacht-GO** (Z.34, wörtlich): "Korrekt, alle Punkte bis hierhin freigegeben. Volles autonomes GO - auch nachts" → super `dcf7bbd`.

**D3 — Token-Resume nach Absturz** (Z.177): "Die Tokens sind jetzt unlimitiert … Feuer frei. Gleichzeitig hatten wir auch mehrere Systemabstürze, prüfe den Stand und fahre fort, wo du aufgehört hast, resume alle Agenten und workflows"

**D4 — Notfall-Pause** (impliziert, Z.264ff): laufende Infra-Wartung (PAT-Redaktion + History-Rewrite über alle 4 Repos) → keinerlei Remote-Kontakt.

**D5 — Wartungsende** (Z.357, wörtlich): "Wartungsarbeit ist für unsere 4 Repos geklärt und sauber, bitte sync mit remote (main und development), dann weiter wie gehabt mit offener Arbeit. Bitte lies einmal den gesamten Kontext dieser Session VOLLSTÄNDIG gründlich durch und fundiere dich einmal neu, dann geht es direkt weiter"

**D6 — Nacht-Audit-Auftrag** (Z.1037/1040, wörtlich): "Bitte lies den gesamten Kontext nochmal gründlich ein und gründe dich neu. Dann analysiere anhand der letzten autonomen Nacht die implementierten Abweichungen vom Plan mit ultracode. Danach folgen wir den Plan wieder wie geplant und geben Agenten versehentliche Regressionen gegen den Plan zum fixen mit. Weiterhin haben wir hier und da einen Systemabsturz"

**D7 — v1-Lockerung + Zombie-GO** (Z.1048, wörtlich): "Gut, die v1 muss nicht zwangsläufig kompatibel bleiben, wenn das den Fortschritt behindern sollte. Bitte kill alle Zombies für mich, GO. Ansonsten arbeite weiter nach stehenden Direktiven wie gehabt"

**D8 — Kontextübergabe + TODOs** (Z.1057): "Bitte schreibe eine reiche Kontextübergabe, der Kontext endet sehr bald. Bitte stelle vorher alle für mich sichtbaren TODOs wieder her"

**D9 — Neufundierung** (Z.1278): "Bitte lies die Kontextübergabe vollständig ein und das Audit der letzten Sessoin, bitte lies Memory gründlich. Bitte lade das untere sechstel des letzten Kontext session logs vollständig in deinen Kontext"

**D10 — Architektur-Dreischnitt** (Z.1307): "Bitte beschreibe mir durch nachlesen in deinen Worten ausgiebig die Architektur, wie sie gestern abend noch war, wie sie sein sollte und wie sie gerade jetzt aussieht"

**D11 — Doku-Trennung** (Z.1400, wörtlich): "Bitte speichere deine eigenen Worte exakt so als update in die letzte beschreibung mit eigenen Worten unter der Architektur und konsolidiere mit dieser. Das ist gut geworden, alles was den Status betrifft schneidest du hingegen in eine Session"

**D12 — PRÄZISIERUNG-1: ccache-Bestandsdokument, 4096er-Batches, ETA, Takeover** (Z.1649, bindend, Kern wörtlich):
> "…die ccache Binaries möglicherweise über ein versioniertes und gelocktes Bestandsdokument eingelagert werden sollten, weiterhin benötigen CEBs über dieses Dokument Absprachen, wie sie sich die Batches aufteilen, damit auch Binaries, die beide Maschinen verarbeiten können, gleichverteilt auf beiden Maschinen kompiliert werden. Sonst blockt die eine Maschine den Fortschritt komplett… Die Batches sollten also stets 4096 Binaries enthalten, die eine CEB aufnimmt und reserviert mit Zeitstempel. Die CEB muss dann die durchschnittliche compile Zeit berechnen und ETA im ccache Bestands-Log festhalten. Wird das ETA um 50% ohne update überschritten, können andere Maschinen davon ausgehen, dass die Pipeline der anderen Maschine gestorben ist und sie nehmen die Arbeit stattdessen auf… Weiterhin muss der ccache Bestand neu inventarisiert werden, wenn das Log gelöscht wird oder durch Code Änderung der Planer und CEB durch eine neue Version ersetzt werden muss. Das Bestandslog hat eine eigene Versionsnummer im header für Syntax und Semantik und ist im Kern ebenfalls ein XML… Das ETA der Kompilation… wird durch die ersten 10 erfolgreichen compiles der CEB über die Tier-Binaries geschätzt… wofür zuerst 30 Minuten reserviert werden… Ein Planer blockt einen Compile einer CEB direkt im Log ohne ETA mit einer Reservierung von 30 Minuten für diese Version. Alle Reservierungen und ETA werden im Log nach Fertigstellung eines Batches aufgehoben. und mit 'Done' gekennzeichnet. Die Reservierungen decken dabei compile+prüf der CEB und den compile der CEB durch Planer als Strategy pattern für caching ab."
→ Ledger §62-B-Block (super `09238db`), Heimat **Task #6 = #46b**, Memory-Nachtrag-5.

**D13 — PRÄZISIERUNG-2: Factory-Pattern, zwei Bestände, constexpr-SHA512-Stempelzeile** (Z.1674, wörtlich):
> "Das beschriebene System gilt separat als factory pattern für batch-compile-prüf und für Messung, die beide ein separates Bestandslog führen. Es gibt also einen Bestand an binaries und einen Bestand an Messergebnissen. Jeder Bestand hat je seine Strategie, um über Stempel identifizierbar zu sein. Für die Binaries wünsche ich mir weiterhin, dass es eine constexpr Funktion als separates Versionierungsinterface auf jedem CEB und Tier-Binary gibt, welches einen SHA512 über die String-Arrays der bisher existierenden Stempel-Zeilen bildet, sodass ein lookup mapping über std::map mit SHA512 keys und Binary-/Messwertpfad aus sicht einer suchenden CEB, effizient auffindbar wird… Also bekommen alle binaries zusätzlich eine WEITERE Stempel Zeile mit dem Fingerprint SHA512 über ihre Eigenschaften, sodass er zur compile time berechnet ist und nicht mehr ständig zur Laufzeit berechnet werden muss."
→ super `2bbcf3f`, Memory-Nachtrag-6.

**D14 — PRÄZISIERUNG-3: Schreib-Lock** (Z.1689, wörtlich): "das Bestandslog wird beim Schreibvorgang einer Maschine gelockt, zum Beispiel auch wenn ETA errechnet werden soll. Das lock für Schreiben eines Bestandslogs, endet mit der ersten pro forma 30 Minuten Reservierung spätestens" → super `9f35260`, Memory-Nachtrag-7.

**D15 — PRÄZISIERUNG-4: Multi-Write, Batch-Typ-Sequenz, Thread-Budgets** (Z.1699, wörtlich):
> "…sobald für das Bestandslog kompiliert wird, ist das Bestandslog multi-write freigegeben, es werden dann nur die Vorgänge registrieren und das Schreiben beschränkt sich auf die Eintragung der Reservierung der Maschine (nur millisekunden). Das heißt der haupt blocker ist ETA Berechnung. Die ETA Berechnung wird für jeden compile-Batch-Block wiederholt und Batch-Typen zwischen CEB compile und Tier-Binaries auf der selben Maschine nie gemischt, sie laufen sequentiell auf derselben Maschine. Weiterhin hat prod1 32 Threads und 24 Kerne und prod2 hat 24 Threads und 16 Kerne, die für batch compile zur verfügung stehen, aber alle Threads dürfen nur je einzelnen batch compile voll ausgeschöpft werden… Also maximale Kerne voraus für CEB batch compile und Planer CEB compile"
→ super `4f637ab`, Memory-Nachtrag-8.

**D16 — PRÄZISIERUNG-5: ETA-Korrektur (ersetzt die 10-Compile-Regel aus D12)** (Z.1798, wörtlich):
> "…dass das ETA nicht über die ersten 10 compiles, sondern über die Maximale Dauer einer Anzahl von compiles, die der maximalen CPU Thread Zahl entspricht. Wenn dieses Mini-Batch einer voll-parallel-Sequenz eine Zeit liefert, können wir davon ausgehen, dass dies die Zeit ist, welche die Maschine je max-Threads paralleler builds wirklich braucht. Das ETA wird berechnet durch die Summe aller Zeiten der jeweils (Zeit je parallelem compile Vorgang geteilt durch die Anzahl der Gesamtthreads). Werden nicht alle threads voll, gilt die Regel weiterhin, indem die Formel nachweislich die einzelne compile Zeit heruntermoduliert. Die Compile Zeit ist aber immer mindestens die maximale Einzel-Zeit eines voll-parallelen Batch Satzes"
→ super `1460f9e`, Memory-Nachtrag-9.

**D17 — §64: Mess-Tooling VEREINT als Default (REGRESSIONS-BEFUND)** (Z.1827, wörtlich):
> "Ich sehe derzeit, dass du wallclock, macro und micro einzeln entwickelst und durchmisst. Das soll per XML auch konfigurierbar sein, nur einzelne Aspekte (permutativ auch nur eine oder 2 dieser Eigenschaften) zu messen. Aber wenn du bitte einen explore Agenten findest, der alle Stellen dieser Messmethoden im latex Text der Diplomarbeit und allen Plänen+Ledger sucht, wirst du feststellen, dass die default Einstellung einer kompilierten CEB auf Wunsch des Planers ist, das alle 3 Prüf-Eigenschaften vereint im CEB existieren und nicht separat. Sie werden während der Messung in verschiedenen Software-Schichten in einem Rutsch gleich mit gemessen und nicht getrennt. Die Beschreibung dazu ist exzessiv dokumentiert. Ich sehe diesen Punkt als Regression an. Daher dauern jetzt auch die Tests mehrmals so lange. Die XML soll es ermöglichen, diese Messverfahren entweder getrennt, wie jetzt, oder in einer beliebigen gemeinsamen Wunsch-Konfiguration zu messen (auch nacheinander wenn vom Anwender gewünscht). Steht dazu nichts in der XML: Alle 3 Verfahren in der CEB gemeinsam abgebildet per Metaprogrammierung und das Prüf-Dock nimmt alle 3 Features vom Tier-Binary gemischt ab."
→ **§64 als Gesetz** (super `b79463d`) + neues Memory `feedback_mess_tooling_default_vereint_eine_ceb` + Index-Zeile; Explore-Agent gestartet.

**D18 — Stempel-Zusammenfassung + Zeitfrage** (Z.1836, wörtlich): "Also zusammengefasst hat der Stempel bzw. die Mess-Tooling Achse des Planers auf der CEB die Tags 'wallclock,makro,micro' mit einer X.Y.Z Versionsnummer je der 3 Tags. Die in beliebiger Kombination in die CEB einkompiliert werden können. Wir testen erstmal alle zusammen und auditieren den Stand damit 3 mal so schnell… Die Messung aus 12124 Pipeline dauert sonst sehr lange. Wo stehen wir diesbezüglich? Kannst du aus dem Log herauslesen, wie lange eine Messung dauert?"

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begründung)

1. **#46a/#53-Dossier, 5 Scheiben, Reihenfolge bindend** (ultracode, 4 Agenten): S1 Push-Vollständigkeit+Key-Härtung → S2 Pull/Batch-Hydrierung → S3 Bare-Metal-Env → S4 docs-Gate/ccache → S5 interruptible (infra-gated). Ausführungsreihenfolge dann **S4 zuerst** (sofortiger Durchsatz-Gewinn).
2. **Objekt-Key** (Montage ausschließlich in `cache_key_prefix`): `build_version + "+ceb=<ABI_MAJOR>.<kCebContractCodegenMinor>" + "+mtool=<sanitierte COMBO>" + "+mrg=none"`. Begründung: `+mtool` schließt die Tooling-Kollision (DLL-Bytes ändern sich ohne Key-Wirkung), `+mrg` reserviert das K6a-Merge-Stempel-Segment jetzt, um eine **zweite Voll-Invalidierung** beim PRT-Paket #37 zu vermeiden. `algo_sig` bewusst **nicht** in den Key (bleibt Sidecar `perm.dll.algos`, byte-kompatibel zum Ist-Layout).
3. **Pull-Andockung Option (a)**: Batch-Hydrierung vor `provision_all` statt per-Binary in `provision_core` — Begründung: per-Binary = mc-Prozess-Spawn ×2^17 + Netzabhängigkeit der `dll_is_current`-treibenden Unit-Tests. Korrektheit entscheidet weiterhin ausschließlich lokal `dll_is_current`.
4. **Manager-Korrektur ① am Dossier**: docs-only-Gate wirkt **auf development** (nur `main` läuft immer voll) — die Synthese wollte development immer voll laufen lassen, was das eigentliche Problem (jeder Ledger-Push = volle Welle) verfehlt hätte.
5. **Manager-Entscheid ② (mit Meldung)**: parallele PUTs desselben Keys = last-writer-wins ohne Locks in #46a (deterministisch identische Bytes); Claims erst in #46b.
6. **build:clang-Verdikt**: statt `.code-rules`-extends **explizite kombinierte rules** — erhält den #273-`COMDARE_CLANG_MATRIX`-Killswitch **und** das docs-Gate (architekturkonform, nicht nur heute-identisch).
7. **[#45] Design Option A**: pro Mess-Zelle worker-lokal (kein geteilter ExperimentTree, kein Lock), Merge in kanonischer builds-Reihenfolge. Belegt: `tree` ist Scratch, `AnatomyModuleLoader::load` thread-safe für verschiedene .so, realer `LinuxPerfPmcSource` NICHT teilbar ⇒ per-Worker-pmc.
8. **#48-Dossier-Prinzip ADDITIV-DANEBEN**: neue KERN-Welt (`experiment_golden_kern.xml`, v2) entsteht neben der byte-unberührten Abgabe-Kette; Scheibe 6 (Umhängung) hart gegated auf nach-320er + User-GO.
9. **#48-Verdikte**: `fulljoin` = drittes per-Achse-Token (User-Wortlaut unterscheidet Stufe-2-Hybrid und Stufe-3-FullJoin — Vermischung wäre Regression); Maschinen-Schlüssel = CPU-Fabrikation + RAM-Paar, Hostname nur Hint; Storage-Slot deklariert aber inert; `axis@pruefling` in die Syntax; prt-art bleibt draußen (je-Repo-GO); config-a/b/c-Move nach `deprecated/` per `git mv` ohne Einzel-GO.
10. **S5-Verdikt „B+"**: Angleich der super-golden_kern an die Ist-Parser-Namen (Option B des Agenten), **aber** `id_namespace` bekommt eine **echte Parser-Naht** statt Kommentar-Reserve — Begründung: §59-C-Kern („eigener id-Satz, dritter Merge-Stempel") darf nicht als bloße Doku enden. Top-level `<identity>` entfällt (Phasen-Attribut ist Träger).
11. **Nacht-Audit als eigener ultracode-Workflow** (4 Lanes + adversarialer Klassifikator, R/A/K-Trennung: echte Regression → Fix-Auftrag; dokumentierte Auslegung; plankonform).
12. **Zombie-Kill über sauberen Kanal**: kein root ⇒ neuer var-gegateter `runner:sweep-zombies`-Job, läuft als `gitlab-runner` und killt eigene Waisen — macht den [RUN-1]-Workaround dauerhaft selbstbedienbar.
13. **Methodik-Profil-Schnitt (Manager-Architekten-Entscheid, transparent gemeldet)**: (i) **neue Env `COMDARE_PLAN_METHODIK_PROFILE`** statt Wiederbelebung des toten `COMDARE_PLAN_MEASURE_PROFILE` (das hatte andere dokumentierte Wert-Semantik; stille Umdeutung wäre irreführend); (ii) **§61-Konformität bejaht**: Env ist Profil-**Selektor** (strukturgleich `COMDARE_THESIS_PROFILE`), die Methodik kommt weiter aus der XML mit hartem exactly-one — §61 verbietet Env-als-Methodik-**Wert**, nicht Profil-Selektion. Entkoppelt Bau-Katalog (`all_axes_golden`) von Mess-Methodik (`m3_smoke_coverage`).
14. **§64-Konsolidierungs-Anmerkung**: Tooling-Ausprägung einer CEB ist eine **Menge** (Default Vollmenge); die m3v2-„3-separate-Combos"-Auslegung samt N>1-Fanout-Default ist **supersediert** und bleibt nur XML-Option.
15. **12124 = bewusster Befund-Lauf**: macro/micro-Mess-Jobs gecancelt, wallclock läuft zu Ende (F-1-Abgabe-Kern liefert CSV-/Cache-Push-Beweise); Rest ~2h statt ~6h.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| Paket | Inhalt | Commits |
|---|---|---|
| Dossier #46a/#53 | 5-Scheiben-Plan persistiert | super `dca66ed` |
| §62-B-Präzisierung (D1) | CEB-Batch/Prüfstand/Instrumentierung, Task [#54] | super `ba543a8` |
| §63-GO-Stempel (D2) | Nacht-GO verankert | super `dcf7bbd` |
| S4 (Impl) | docs-only-Gate + Trigger-Gates + ccache-Hygiene, 2 Hidden-Templates, 11 Code-Jobs, 3 Bridges; Delta build:clang kombinierte rules (+98/−5) | — (Freeze; später in Welle) |
| Gate-Härtung | lint:secrets Immer-rules nach leerer docs-Welle | super `df4a8bb` |
| S1 | 3-Objekt-Push (dll→algos→version ZULETZT), Key-Härtung, `!b.skipped`, 3 neue/erweiterte Tests; ctest 292/292 | ce `9202f101`, super `d755659` |
| S2 | `pull_tier_binary` + `pull_tier_prefix` (ein rekursiver mc-Batch), PULL-HOOK, cache_pull durchgereicht; ctest 293/293 | ce `51f84d64`, super `84c74fa` |
| DAG-Fix | 5× `needs … optional: true` + `api` im Gate-Vorspann | super `0c3cc6f` |
| S3 + S2-F1 | `scripts/comdare_storage_activation.sh` (POSIX-sh, unsetzt Roh-Creds, echot nie Werte) + Host-Wiring `cache_pull` im Driver | ce `9ef466aa`, super `e161448` |
| [#45] | paralleler Mess-Loop (`collect_ordered`, `resolve_measure_parallelism`, `parse_result_line_to_node_value`); ctest 294/294 | ce `99a608c2`, super `e4c5e6c` |
| Thesis-chktex-Fix | 16 Findings, `\@.` DE+EN synchron | thesis `ef448e4b` (dev **und** main) |
| Cache-Resthygiene | Slice1 Marker-`algo_sig` (YAML), Slice2 mc-Timeout-Wrapper (`timeout -k 5`, Push 120s/Pull 20s); ctest 295/295 | ce `8e50f572`, super `e68f4e9` |
| Mini-Paket | build:clang-Diagnose (Befund-first) + Resthygiene-2 (`organ_fingerprint.hpp`, `--chunk-organ-fingerprint`, Marker-Wache scharf); ctest 296/296 | ce `8a3a58c9`, super `87f5485` |
| cppcheck-Fix | try/catch im neuen Entry-Point | super `332c54a` |
| **1. dev→main-Merge** (§63-Branch-Regel, FF) | §61-Kette + #45 + #46a + #53 | **ce main `8a3a58c9`, super main `332c54a`** |
| #48-Dossier | 6 Scheiben, Verdikte V-a..V-f | super `e03c862` |
| #48 S1+2 | deprecated/-Moves (git mv, 0 Konsumenten), 6 Profile wohlgeformt, 23 Allocator-Doku-Köpfe; TABU-Wache 0 Treffer | ce `a1b165b8`, super `0f514b0` |
| #48 S3 | `experiment_golden_kern.xml` (156 Z., v2, KANONISCH) | super `596c625` |
| #48 S4 | Parser/Validator-Naht (machines, axis@pruefling, fulljoin, storage inert); ctest 297/297 | ce `d049dcfe`, super `b888902` |
| #48 S5 (B+) | XSD-Konsolidierung v2 als einziges Ziel-Schema, `id_namespace`-Parser-Naht, SCHEMA.md, v32 nur DEPRECATED-Kopf; beide golden_kern validieren, alte v1 **bleibt** gültig | (committet, Wellen grün) |
| Sweep-Job | `runner:sweep-zombies` (var-gegated, als gitlab-runner) | super `2c7c706` |
| Kontextübergabe | `docs/sessions/20260722-SESSION-KONTEXTUEBERGABE-nacht-audit-sweep.md` | super `77c9ed5`, Update `6728094` |
| R7-Selbstfix | Zen4→Zen5 in beiden golden_kern-Instanzen | ce `3c2bad51`, super `4369d51` |
| **R-Paket 1** | R1 sed-Fix, R2 Write-Basis=Treiber-Quelle, R3 `optional:true`, **+ Sweep-`[c]`-Fix** (Manager selbst); CI-Lint `valid: True` | super `f262dac` (Welle 12115 grün) |
| B4-Auflage | Ledger §61-KONSOLIDIERUNG-(f) + `2026-07-21-SESSION-AUTONOM-01.md` gefüllt | super `fd1a626` |
| **R-Paket 2** + R7-Pin-Nachzug | R4 TRIES=1 Debug-gegatet, R5 exactly-one tp-Pfad + `ids.size()>1` hart, R9 stale Kommentare | ce `50c519f7` (2 granulare Commits; Welle 12120 grün) |
| Doku-Split (D11) | Architektur-Doc „UPDATE 2026-07-22" (U1–U4) + `20260722-SESSION-STATUS-drei-zeitschnitte.md` | super `b8a19c1` |
| **R-Paket 3** | R6 `merge`→`Stufe2_Hybrid`, `fulljoin`→`Stufe3_FullJoin`, Lockstep-Pins; ctest 297/297 | ce `8ac2c1f5`, super Gitlink `b50bdd4` |
| R8a | `print_cache_key_facade` + Treiber-Dispatch `--print-cache-key`, 4-Fälle-Paritätsbeweis | ce `fa912241`, super `8b6de63` |
| R8b | YAML `GN_CACHE_KEY` aus Treiber in den 5 Objekt-Store-Kontexten | super `0cf2776` |
| ce-Doc-Fix | 4 stale `<build_version>/`-Kommentare → `cache_key_prefix(...)` | ce `cf551722` |
| §62-B-Präzisierungen | D12 / D13 / D14 / D15 / D16 | super `09238db` / `2bbcf3f` / `9f35260` / `4f637ab` / `1460f9e` |
| §64 | Mess-Tooling vereint als Default | super `b79463d` |
| Methodik-Schnitt Schichten 1–3 | Director-Override (optionaler 4. Param), Facade-Resolver `resolve_methodik_override`, Runtime-Naht; Override unset = byte-identisch; ctest 297/297 | ce `c85ddafe` |

**Prozess-Muster durchgängig:** Agent meldet Paket + Freeze → Manager prüft diff-stat **literal** → Commit (scoped, Streuner wie `thesis/diplomarbeit`-Gitlink bleiben draußen) → Dual-Push → CI-Welle unter Monitor.

---

## (d) FEHLER + FIXES

1. **`.code-rules` überstimmt `COMDARE_CLANG_MATRIX`** (Agent selbst geflaggt) → kombinierte explizite rules; Killswitch erhalten.
2. **docs-only-Welle 12012/12045 leer-failed** (0 Jobs statt „nur lint:secrets") → Wurzel: 5 harte `needs`-Kanten auf gegatete Jobs ⇒ „needs not created"; Fix `optional: true` + `api` im Vorspann (`0c3cc6f`) + lint:secrets Immer-rules (`df4a8bb`). Danach alle 3 Gate-Beweise: docs-only=Minimal 12047, Gitlink=voll 12034, YAML=voll 12046.
3. **GitHub-Push tot** (Token-Rotation) → neues Token aus Vault, leak-frei per `git credential approve` (stdin).
4. **8,4h/6h-Messjobs** — kein Hänger, ehrliche 1-Thread-Messung → datenbasiert gecancelt; Konsequenz: [#45] hochgerückt.
5. **[RUN-1] Zombie-Driver nach Job-Cancel** (2×, zuletzt PID 728821, 18h+) — Runner killt nur den Shell-Wrapper; Infra reagierte nie → Sweep-Job als `gitlab-runner`; beide Hosts belegt sauber (12098 success).
6. **Sweep-Job failed trotz erfolgreichem Kill** — `pgrep -af`-Selbst-Match auf Monitor-Shells → `[c]`-Trick-Fix in allen vier Mustern (mit `f262dac`).
7. **12046/12065 failed = trigger:thesis** — chktex-Findings; **zweiter Fail**: Bridge triggert **ref=main**, Fix lag nur auf development → thesis/main per FF-Push über temporären Shallow-Klon.
8. **build:clang skipped** — KEIN Bug: Stage-Ordnungs-Folge des roten trigger:thesis (Job hat kein `needs`); Agent hatte korrekt Befund-first eskaliert.
9. **12073 failed** — cppcheck `throwInEntryPoint` im neuen `--chunk-organ-fingerprint` → try/catch, Konfig-Fehlermeldung statt unhandled throw.
10. **S5-Bruch**: super-golden_kern (S3) folgte abstrakten Dossier-Namen (`<engines>` vs. `execution_engines`, fehlende `op_types`/`lebewesen`, `id_namespace`/top-level-`identity` parser-unbekannt); S3 hatte nur Wohlgeformtheit geprüft → Verdikt B+.
11. **NACHT-AUDIT R1–R9** (adversarial mit literalen Repros):
   - **R1** Marker-HIT strukturell tot: `sed -n 's/^algo_sig=//p'` nimmt die ganze Zeile → Fix `s/^algo_sig=\([^[:space:]]*\).*/\1/p`.
   - **R2** Write-Basis (`find` über ganzes `DLL_DIR`) ≠ Read-Basis (Range-Preimage) → Write auf Treiber-Quelle; find nur noch Log-Vergleich.
   - **R3** `measure:golden-320` harte `needs`-Kante :715 → `optional: true`.
   - **R4** `COMDARE_ARTEFAKT_TRIES=1` fehlt im bare-metal Debug-Mess-COMMAND (Dual-Weg-Bruch) → Debug-gegateter `artefakt_tries_env` + Lockstep-Pins.
   - **R5** exactly-one nicht auf dem tp-Pfad → Pre-Flight-Validate + `ids.size()>1` als harter Fehler.
   - **R6** `merge` → Stufe3 statt §59-A(2)-Hybrid → `Stufe2_Hybrid`-Mapping + Lockstep-Pins.
   - **R7** `amd_zen4_avx512` statt Zen5 (dreifach Ledger-belegt) → gefixt; **Nachbeben**: Audit-Behauptung „Konsumenten=0" war falsch — `test_experiment_kern_seam.cpp:75` pinnte zen4 → Ein-Zeilen-Nachzug durch Manager.
   - **R8** Key-Drift YAML `GN_PREFIX` → `--print-cache-key` (R8a) + `GN_CACHE_KEY` (R8b).
   - **R9** stale „UNGEBAUT"-Kommentare → auf #45-Stand.
   - **Muster-Befund:** 4 von 9 R saßen im **handgeschriebenen super-YAML** (einziger wachenloser Fleck), 2 aus Dossier-Skizzen-Fehlern.
12. **Wachen-Lücke `contract`-Label**: ce-Welle 12111 war grün, obwohl der Test-Pin gebrochen war — beide Tests tragen das `contract`-Label, das die ce-CI-Testauswahl ausschließt. Als CI-Wartungs-Merkposten notiert.
13. **Geschwister-Checkout-Race**: `build:registry-roundtrip` (Job 288954) in trigger:prt-art failed, Retry grün — paralleler ce-Checkout im geteilten Workspace; Merkposten: eigener Klon je Job oder Lock.
14. **R8b-Substanzbefund**: Warm-Pull und Teil-Resume liefen unter dem verkürzten `GN_PREFIX` und trafen die ce-Pushes (unter vollem `cache_key_prefix`) **nie** — der Pull war strukturell leer. Einmaliger Migrations-MISS je Zelle eingepreist.
15. **Doppelte Perm-Suffix-Reihenfolge** (perm-loop `+cxx+opt+ext` vs. `system_axes_version_suffix` `+ext+cxx+opt`) — zwei intern konsistente, untereinander divergente build_versions; separater Single-Source-Aufräum-Kandidat, NICHT R8.
16. **Methodik-Profil-Lücke (Smoke-Befund)**: `all_axes_golden` treibt Katalog **und** Methodik ⇒ Mess-Jobs fahren measure-Semantik (1-Thread, kein Dual-Compile); die smoke→debug-Naht war **nie verdrahtet** (`COMDARE_PLAN_MEASURE_PROFILE` = toter Kommentar, kein Konsument; `COMDARE_MEASURE_PROFILE` nur rules-Trigger); YAML-Kommentar :642 behauptete die Verdrahtung.
17. **§64-Regression** (User-Befund): 3 Mess-Tooling-Combos separat statt vereint ⇒ 3× Laufzeit.
18. **Zustell-Lag Agent↔Manager** (mehrfach): Idle-Meldungen kreuzten Verdikte; Agent führte korrekt nicht doppelt aus.
19. **Working-Tree-Freeze-Disziplin** durchgehend eingehalten; Streuner (`thesis/diplomarbeit`, ce-Gitlink, `Testing/`) nie mit-committet.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE (22.07. ~09:30)

**Stände:** ce dev `c85ddafe`, super dev `b79463d`(+`1460f9e`-Reihe); mains ce `8a3a58c9` / super `332c54a`. Beide Hosts zombiefrei.

1. **Explore-ToolingVereint** liefert gerade den §64-Fundstellen-Report (VEREINT vs. SEPARAT in Thesis-LaTeX DE+EN, Ledger, Pläne, ce-Design-Kommentare) — **Nachricht bricht mitten im Report ab**; er soll als Nachtrag an §64 gehängt werden.
2. **Methodik-Schnitt Schicht 4** (YAML: `COMDARE_PLAN_METHODIK_PROFILE=m3_smoke_coverage` nur im smoke-rules-Zweig; `COMDARE_GOLDEN_N_PROFILE`/`COMDARE_MEASURE_PROFILE` unverändert; CI-Lint vor Meldung) — beim Agenten, GO erst nach Smoke-Terminal.
3. **§64-Vereinigungs-Umbau** — Fix-Paket noch zu schnüren (nach Explore-Beleg + Kartierung), dockt an dieselbe Mess-Tooling-Naht wie der Methodik-Schnitt: Combo-Legende, Emission, Tooling-Stempel (Tags `wallclock,makro,micro` je X.Y.Z), Prüf-Dock-Abnahme.
4. **Smoke-Kette 12124**: wallclock-Lane misst noch 4 Jobs zu Ende (~2h); macro/micro terminal success nach Cancel; Kette kann komplett grün terminieren. Ausstehend danach: Cache-Push-Belege + CSV-Substanz prüfen.
5. **Zwei benannte Runtime-Beweise**: R8b-Key-Gleichheit (Matrix-Opt-in-Lauf mit `COMDARE_STATIC_MATRIX_FALLBACK=true` + `COMDARE_STORAGE_CACHE=true`) und R1/R2-HIT-Beweis (`GN_DECISION=skip` literal im Log der nächsten golden-Bau-Welle).
6. **Drei CI-Wartungs-Merkposten im Board**: `contract`-Label-Testauswahl-Lücke, Geschwister-Checkout-Race, Perm-Suffix-Reihenfolge-Duplikat.
7. **Gitlink-Bump auf ce `cf551722`** fährt mit dem nächsten fälligen Bump mit (keine eigene Welle für einen Kommentar-Fix).
8. **`Stufe2_Hybrid` dormant**: kein `MergeStrategy`-Enum-Wert (`pruefling_merge.hpp` trägt nur Stufe1/Stufe2_PrueflingReplace/Stufe3_FullJoin); `sota_catalog.hpp:182` rendert die Strategie als Text in generierten Code ⇒ echte `merge`-Direktive mit realem Slot bräuchte Enum + Spezialisierung. Materialisierung per Audit deferred, im Code dokumentiert.
9. **Audit-A-Auflagen**: B4 erledigt; **B6** (K7b Je-Binary-Stempel MUSS vor #46b — durch D13 zusätzlich begründet), **C5/C6** (Scheibe-6-Auflagen: Fixture umbenennen, `enabled`-Default) offen.
10. **#48 Scheibe 6** (Umhängung) gegated auf nach-320er + User-GO; **v1-Lockerung** (D7) ist in der Scheibe-6-Beschreibung verankert — v1-Welt darf hart abgelöst werden.
11. **G7-User-Punkte** offen: allocators-Status, Pin-Wachstum, golden_kern-Master-Ort, E15/E16/#24/#25/#225.
12. **Kritischer Pfad unverändert**: nächster Smoke (= eigentliches **S5-Gate**, nach §64-Umbau + Methodik-Schnitt, mind. 3× schneller) → **320er** mit warmem Cache (m3v2-320, Interim-Lanes amd=4/intel=8, wallclock zuerst) → **S7** (Hybrid + Wallclock-Beweis) → **S8** (PDF DE+EN, **Zwischenabgabe 28.07.**) → §63-Endlauf (#34–#37 entsperrt, #46b, #47, #54, #49, #51, G-Gruppen) bis leeres Backlog.
13. **Task-Board** wurde mehrfach durch Abstürze geleert und jeweils wiederhergestellt (zuletzt 12 Einträge + neuer Task #13 als Audit-Tracking, blockt #2).

**Sicherheits-Hinweis:** In diesem Chunk wurden nur Env-**Namen** und Vault-**Pfade** genannt (nie Werte); die Extraktion enthält entsprechend keine Secret-Werte.