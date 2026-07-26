# CHUNK 20/30 — Extraktion (chronologisch)

## (a) USER-DIREKTIVEN (woertlich wo bindend)

**A1 — INC-2d Achsen-Wahl** (nach Vorlage A/B): "Bitte TargetIsaSystemAxis wie empfohlen" + "Ansonsten A2-Neben auch volles GO fuer den golden Umbau" -> Variante A + GO fuer golden-Umbau + A2-Neben.

**A2 — new-golden (Einschub, woertlich):** "Bitte erstelle durch einen ultracode workflow eine neue Grundlage fuer ein XML welches alle Achsen abdeckt und daher ein new golden 320 baut, aber es werden laut Permutations-Mathematik mehr als 320 Rekombinationen werden, nimm diese neu ermittelte Zahl mit compile und test als neues golden Ziel, sobald dieser fix hier laeuft, merke dir das, dann weiter"

**A3 — Hauptstrang nicht abgeloest (woertlich):** "Bitte vergiss aber den Hauptstrang vor dem Einschub der neuen golden Direktive nicht, sie wird weiterhin ausgefuehrt, sobald der Standard der neuen golden ueber alle Achsen angehoben wurde um echte Regressionen ueber das gesamte System zu erkennen"

**A4 — "Das GO fuer das Ziel-N"** (= N=2^17=131072).

**A5 — Caching (Voraussetzung, woertlich gekuerzt):** "Bitte entwickle zusaetzlich als Einschub zum neuen GO Ziel-N eine Strategie, wie die zu kompilierenden CEB und Tier-Binaries gecached werden koennen und dass die CI erkennt, ob eine Organ-Achse sich bezueglich eines Achsen-Algorithmus geaendert hat, sodass nur Binaries im Baum neu gebaut werden, die das bezueglich er Algorithmus Versionierung betrifft. Jedes Binary traegt also je Organ-Achse ein Listing mit welchem Algorithmus und Algorithmus-Version sie ausgestattet wurde ... Eine Aenderung auf der CEB, welche alle Tier-Binaries betrifft fuehrt zur vollstaendigen Rekompilation ... Damti grenzen wir die Last ein und es wird feasable" + "Das ist die Voraussetzung fuer das neue golden N" + "Der Experiment Baum hat schon lazy Materialisierung und die CEB ist genau dafuer gebaut" + "Bitte zieh es durch, das ist machbar" + "Dach weiter mit dem Hauptstrang"

**A6 — Storage (3 Korrekturen, Flip-Flop):**
1. "...dass die neuen gecachten Tier-Binaries auf minio.comdare.de gespeichert werden sollen, waehren die gitlab CI auf minio.comdare.local verbleibt. Bitte starte einen ultracode workflow, der sich die Ziele des Buildsystem anschaut ... Auf prod ist genug Platz mit 6TB longhorn HDDs"
2. "Nein, nicht ganz, wir schreiben ALLE Ergebnisse, die CEB compiles und Tier-Binary compiles nach der Hierarchie der RBMM cache hierarchie als NFS Dateisystem auf die prod HDDs. Die uebrigen Bestandteile bleiben normal im gitlab cache auf cluster dev" + "Bitte korrigiere das memory"
3. FINAL: "Doch, tut mir leid, klar schreibe die CEB compiles und Tier-Binary compiles in die minio.comdare.de aber die Messergebnisse bitte in ein NFS auf den prod Hdds, damit ich es auf einer DNS .1 SNI per HA Proxy von VLAN 10 aus durchsuchen kann"

**A7 — Mess-Constraint (woertlich, bindend):** "Das Schreiben der Binaries und Ergebnisse muss SEQUENTIELL zu den Messungen erfolgen und nie parallel Messfehler erzeugen"

**A8 — Kontext-Start-Ritus (woertlich):** "Bitte lies zu Beginn jedes neuen Kontext immer alle Plan- und Referenzdokumente gruendlich ein und vergewissere dich dem TODO Ablaufplan und aller weiterhin gueltiger Planungsdirektiven, merke dir das"
**A8b — Korrektur (woertlich):** "ok ich korrigiere, dass zu Beginn einer jeden session zusaetzlich zwar nicht das gesamte memory eingelesen werden soll, aber es sollen per ultracode alle direktiven, alle wichtigen Learnings und alle Umgebungsvariablen zum aktuellen Aufgaben Thema geladen werden, merke dir das. Befolgst die Planung vor der Aufgabe und die Verifikation nach der Aufgabe weiterhin?" -> Agent bestaetigt: VOR-Planung + NACH-Verifikation bleiben unveraendert bindend (Ledger §24.D).

**A9 — std::variant-Verbot (woertlich, Kern):** "...dass fuer alle statischen (Haupt-) Achsen stets das std::variant verboten ist, sondern immer nur Per geeigneter Metaprogrammierung exakt der passende Achsen-Algorithmus je Organ-Achse, der gewaehlt wurde, sowie die statischen System-Achsen in der CEB, einkompiliert wird, weil die runtime Wahl aus einer std::variant overhead erzeugt und die nicht benoetigten Algorithmen einen Code bloat erzeugen ... Es ist nicht moeglich 131k Binaries mit einer Groesse von 60MB auf 6TB zu speichern, aber wenn wir den Assembly bloat reduzieren, dann wird es gehen. Bitte schiebe diese gesamte Nachricht als weitere Voraussetzung fuer das neue golden ein ... -> weitere Voraussetzung und behebung der std::variant Regression"

**A10 — golden==320 ist ueberholt (woertlich):** "Und golden==320 ist falsch und laengst ueberholt, bitte kippe die letzten 5 session dokumente und die letzten 2 Planungsdokumente in deinen Kontext. Bitte stelle die bereinigte MEMORY wieder her und rolle die Aenderungen dort zurueck, ich weiss dass sie gross ist und dann 22kb, aber wir brauchen die Gewichtung fuer diese Session"

**A11 — Sessions rueckwaerts (woertlich gekuerzt):** "Heute ist der 20260718 ... merke dir nur bei Sessions, aber nicht bei Plaenen, dass diese rueckwaerts vom neuesten (in der Regel dem heutigen Tag) zu den aelteren gelesen werden."

**A12 — Kontextuebergabe-Definition:** "Du hast in der letzten Session den BAUPLAN-TWO-CACHE-STORAGE.md geschrieben, fuer mich ist das die letzte Plan Session, die ich suchte" -> "Nein du hast dieses Dokument am ENDE des letzten Kontextes geschrieben, bitte lies es vollstaendig und es ist die Kontextuebergabe fuer diese Session"

**A13 — Doku-Voll-Konsolidierung (woertlich, bindend):** "Bitte lege unter den docs wirklich Konsolidierte Ordner, wie Plaene, Architektur und so weiter an, welche alle Sessions nach Kategorie enthalten, die Backups waren NUR fuer gesicherte Rohdaten von Workflows, die wir sichern, um Tokens bei neuen Suchlaeufen zu sparen, in Backups gehoeren NUR die workflow Sicherungen, sonst nichts, alle Dokumente dort muessen verschoben und einsortiert werden fuer ALLE 4 Diplomarbeit projekte, bitte verschiebe die Dokumente ohne sie zu loeschen ... Wenn in einem der 4 Projekte im Wurzelordner ein Ordner sessions existiert, muessen diese Sessions unter Wurzelordner/docs/sessions einsortiert und gegen deren Format konsolidiert werden"
**A13b:** "Bitte merke dir, dass in den backup Ordner keine sessions und Plaene gehoeren ... Volles GO fuer alle deine Vorschlaege, starte aber zuerst je Datei einen Agenten, den du die neuen Zielpfade im Ledger und ALLEN Dokumenten updaten laesst und dann verschiebst du die Dokumente ... Fahre Batches von je 8 Agenten parallel ... Wir fahren eine Voll-Konsolidierung" + Begruendung: "Die Qualitaet der umsetzung hat durch die Unordnung erheblich gelitten und wir haben nichts mehr gefunden, dadurch entstanden so viele Fehler ueber die letzten Sessions."
**A13c:** "Ich akzeptiere deine Vorschlaege zur Benennung - ... dann ziehen wir das Schema am besten ueber alle Dateien durch. Lass uns das Konsistent ueberall machen"
**A13d:** "Bitte lies nochmal die gesamte session gruendlich bezueglich der Anforderungen der Konsolidierung, du bist noch nicht fertig, bitte liste alle vergessenen TODOs. update memory bezueglich des lesens neuester Dokumente."
**A13e:** "Bitte zieh die gesamte Kosmetik auch nach, ich bin pedantisch"

**A14 — Lese-Scope:** "Bitte lies nur die neuesten Dokumente dieses Strangs, das sind also auch Planungsdokumente (die 5 neuesten unter ALLEN dokumenten)"

**A15 — Infra-Ritus (woertlich, neue Standing-Direktive):** "Danke, fahre mit offener Arbeit fort, bei infra immer erst ultracode workflow ueber alle Sessions zum Thema, damit du in diesem komplexen System noch weisst wo du stehst" (Agent verschaerft spaeter selbst: Cluster-git IMMER vor Infra-Workflow von gitlab pullen).

**A16 — Ebene-C-Entscheid + OPN-Key (woertlich):** "Der OPN cluster key liegt im Cluster/keys cred vault. Du hast ihn nach remote git sync mit gitlab. Und ja ich waehle A: Wir droppen die Messwerte auf V80 wie empfohlen, aber wir geben ein priorisiertes handout an den infra Agenten das cluster prod minio korrekt nach V91 zu verlegen, sodass wir es wie beschrieben als compile cache nutzen."

**A17 — Chunk-Ende (woertlich):** "weiter mit dem Strang, parallel ein breiter ultracode Audit ueber den gesamten Audit an Anforderungen und Konformitaet (neueste Fakten gewinnen gegen aeltere Konfikte) mit Pruefung des code review gegen Design und Anforderungen. Das Passt als Grundlage zur Konformitaet"

Weitere (kurz): 2x "Bitte fahre mit offener Arbeit fort, wir hatten einen Systemabsturz" (+ "resume alle unterbrochenen Workflows"); "wir lassen den agenten zuende laufen" (caching-impl, kam nach dem Stop an); Push-Auftrag fuer thesis-Commit (= thesis-Push-GO); Auftrag thesis->github-Fehler zu analysieren + halbfertige Klone zu fixen; Hinweis, dass der Infra-Agent im Cluster-Repo liest (Handout dorthin); Hinweis "Storage-Abschluss ab jetzt gated auf den Infra-Agenten, du meldest wenn es steht".

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN mit Begruendung

**INC-0 (malloc/Flag-Trennung).** `-mcx16` auf die **Compiler**-Achse (Variante A), nicht auf F-SIMD-Erweiterungshardware — Begruendung: CMPXCHG16B ist Baseline-x86-64 (kein Present-Check), abgeleitet aus dem User-INC-0-Ruling. Neue typisierte `CompilerAtomicSubAxis` (spiegelbildlich zu `simd_sub_axis.hpp`), snmalloc-Organ-Slot `vendor_compile_defs()`. `perm_mess_defines()` mess-rein entmischt, neuer Assembler `perm_compile_flags()`; `baked_perm_extra_cflags` **deprecated statt geloescht** (additiv-zuerst-Doktrin, `[[maybe_unused]]`). Gate-Verengung `COMDARE_HAVE_SNMALLOC` -> `COMDARE_AXIS_06_USE_SNMALLOC` (=ENABLE&&HAVE) als korrekter, nicht regressiv (NACH-Verdikt).

**INC-2d (der ABI-Bruch).** Variante A: **neue** `TargetIsaSystemAxis` (Label `target_isa`, Ziel-ISA/Cross-Compile) statt Umbau der bestehenden `HardwareIsaSystemAxis` (Label `hardware`, Host-Deskriptor bleibt Mess-Gate) — saubere Trennung Host != Target, kleinere TABU-Flaeche. isa verlaesst **nur die Komposition**, der isa-Organ-Typ bleibt Codegen-Traeger (exakter INC-2c-Telemetrie-Praezedenzfall = die spaeter vom Subagenten gestellte B-vs-C-Frage, aufgeloest zu **B** aus Dossier §2.3, kein neuer User-Fork). Folge: kCompositionAxisNames 18->17, alle 5 GenusBindingTraits, POD `sizeof` 1344->1272 (17*8*8+17*8+48), `kV3AxisCount` 17, Snapshot-Version 6->7, ABI-Major 5->6, Magic 0x35->0x36, `permutation_axes.xml` isa `required=true->false` (telemetry-Spiegel). golden messdaten-erhaltend: Alt-Fassung additiv als `_abi5.txt` eingefroren (`_abi4`-Praezedenz), Regen beruehrt nur die Referenz, keine gemessene CSV. Stilles Risiko benannt: binary_id ist Resume-Key -> alte Mess-Stamps matchen nicht mehr.

**new-golden N.** Mathematischer Kernbefund: alle 17 Achsen haben enabled-mp_size >= 2 -> "alle Achsen variieren" kartesisch = Minimum **2^17 = 131.072**; zwischen 320 und 2^17 existiert **keine** reine All-Vary-Kartesik. Entscheidung: golden-**Referenz** (Count-static_assert + ids + Roundtrip) = 131072, **entkoppelt** vom materialisierten DLL-Codegen-Katalog (bleibt 320, sonst g++-ICE/GB-TU). Explosions-Vermeidung: `catalog_axis_product<Catalog>()` = Produkt der mp_size statt `PermutationEngine::count()` (= `mp_size<mp_product<...>>`, materialisiert!); `StaticBinaryView` bleibt lazy (mixed-radix Odometer). 62-MB-golden-Datei **nicht** committet -> CRC64-ECMA-182-Anker `0xF1C1F26A1232073B` (regenerieren + verifizieren), `golden_320_catalog` bleibt als additiver Snapshot. 320 ist ab jetzt **nur noch Snapshot**, nicht "das golden".

**Caching (#50).** Separates `perm.algos`-Sidecar (Organ-Provenienz) strikt getrennt von `perm.dll.version` (System-Provenienz); `static constexpr algo_version` je Strategie-Klasse; Concept-`static_assert` **nicht** an der Wurzel `topics::OrganAxis` (traegt auch System-Achse ISA + 4 Shape-Achsen ohne algo_version -> Wurzel-Guard bricht sie, verifiziert rot), sondern fokussiert in den CRTP-Ctoren **genau der 17 Kompositions-StrategyBases** + universeller Backstop ueber `axis_variant_version_table.hpp`; `ceb_contract_version` / `+ceb=` in build_version -> CEB-Aenderung = Voll-Rekompilation; `dll_is_current(+algo_sig)`; Resume-Stamp `|algos=`; binary_id bleibt name()-only = byte-identisch.

**Storage (#51).** Drei Ebenen: A Standard-Compiles/CI -> GitLab-Cache dev (unveraendert), B Tier-Binaries+Sidecars -> MinIO (Key `<build_version>/<stem>/perm.dll`, Pull re-verifiziert via dll_is_current), C Messergebnisse -> Drop-Ziel. Sequentielle Naht verifiziert: Phase A `provision_all` multithreaded -> Phase B 1-Thread-Mess-Loop; Push+Sink **synchron** per-Binary nach result.csv/stamp, vor RAII-DLL-Unload; whole-run nach `csv.flush`; PULL nur in Phase A; **async/detached verboten** (I/O-Contention = Messfehler). CE-Seite = Injektions-Muster (`CachePushFn`/`MeasurementSinkFn`, No-Op-Default = golden/CI byte-neutral), `artifact_cache.hpp` mit `posix_spawnp`-mc-Shellout (kein /bin/sh, kein Python), perm.dll ZUERST/.version ZULETZT als Vollstaendigkeits-Marke, Fehler -> `InfraErrorClass::ArtefaktIo` loggen, lokale Kopie behalten, **weiter messen**. **Finaler Ebene-C-Entscheid (User, Option A):** bestehender **V80-`measure-drop`**-Pfad (HTTPS-PUT via curl, Token ueber 0600-curl-config, nie in argv/Log, 409-additiv) statt neuem prod-NFS — Begruendung: existiert bereits, kein OPN-#72-Split-Brain, kein prod2-Recovery-Gate. **Ebene B** = prod-MinIO nach **V91 verlegen** per priorisiertem Infra-Handout (#56).

**§23 std::variant-Verbot.** Befund verifiziert: Variant-Triade (`algorithm_baustein.hpp`/`baustein_variants.hpp`/`resolve_baustein.hpp`, REV 7.6) ist eine **latente Insel** (einziger Konsument `test_abi_interface.cpp`, nirgends im Live-Codegen) -> Behebung praeventiv: §23-Quarantaene-Marker + neuer compile-time-Guard `HotPathIsVariantFree` (Block D in `test_striktheit_metaprog_guard.cpp`). `pressure_state` (Runtime-Lastzustand) + `axis_error`/`BuildError` (Fehler-Summe) ausserhalb Scope.

**Doku-Taxonomie (Voll-Konsolidierung).** `docs/{plaene, audits, kartierungen, architektur, ledger-sections, memory-snapshots, artefakte}`; `backups/` = **nur** Workflow-Rohdaten (json/jsonl/js/patch); Namensschema `<datum-thema>-<basename>.md` (kollisionsfrei, chronologisch); thesis-Wurzel-`sessions/` -> `docs/sessions/` + Datumsformat normiert; echte Session-Handover bleiben in `sessions/`. **Korrektur am User-Orchestrierungsmodell:** nicht "ein Agent je verschobener Datei" (Lost-Update-Race am Ledger), sondern ein Agent je **zu aktualisierendem Dokument**, Batches a 8 — final sogar deterministischer perl-Lauf statt 230 Agenten (uniforme Referenzform, verifizierbar per grep).

**#45 A2-Neben Stufe 1 — Ruling Option S.** E3-sauberer Namespace-Rename `builder::`->`measurement::` beruehrt zwangslaeufig 3 Qualifizierer in `perm_runner.hpp`. Ruling: die perm_runner-Quarantaene gilt der **Stufe-2-Relocation nach harness/**, nicht dem mechanischen Qualifizierer-Sweep; Shim-Variante abgelehnt (Behelfsweg-Verbot).

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| Paket | ce-Commit | super/andere | Verifikation |
|---|---|---|---|
| INC-0 Schritt 1 (Achsen-Deklarationen, Dach-Guard Block K) | `e5eb990f` | `775b7cd` | ce 275/275, golden==320 |
| INC-0 Schritt 2 (Facade-Entmischung) | `01748163` | `12cfc04` | super-Sub mit USE_SNMALLOC=1 aktiv, NACH-Verdikt **COMMIT_OK** (0 Defekte, 2 Hinweise abgewiesen) |
| INC-2d VOR-Dossier | — | super `9bd37be` | 480k-Token-Deep-Research |
| INC-2d Step 0+1 (golden `_abi5.txt`-Freeze + TargetIsaSystemAxis, Block L) | `bc5ae9a3` | — | golden==320, Dach-Guard g++/clang |
| Ledger §22 | — | super `f2528ae` | UTF-8 sauber, 0 echte Mojibake |
| INC-2d atomarer ABI-Kern (129/131 Dateien, 18->17, ABI 5->6, POD 1272, golden-Regen) | `8a2e1c3e` | `1544fe3` | build-conf **275/275**, clang ABI-kritisch frisch gruen, golden-Regen 320 ids ohne isa |
| INC-2d Step 5 Cross-Flag-Kanal | `eeb91f11` | `65bf1bf` | golden-neutral (Default x86_64) |
| Ledger §22 Nachzug / new-golden-Dossier | — | `5e9b3c2`, `446e673` | — |
| golden-N = 2^17 + CRC64-Anker | `aa25c9a4` | `749a1a8` | 275/275, count/view/file == 131072, keine Explosion (38s/1,28GB), TABU unberuehrt |
| Caching-Dossier / Storage-Dossier | — | `f951ec5`, `91b28ed` | — |
| Ledger §23 (variant-Verbot), §24 (VOLLES GO/Infra-Ausnahme), §24.D | — | u.a. `a5900a8` | beide Remotes |
| **Caching #50** (145 Dateien, 1 neu) | `d0313bf2` | — | **eigene** Force-Recompile-Verifikation: "100% tests passed, 0 tests failed out of 275", CRC64-Match, cf22=0, Mojibake=0 |
| Voll-Konsolidierung (325 Moves, 117 Ref-Subs) | ce `4334f1b8` | super `1432720` + Gitlink `025c6ab`, thesis `538da5e` | backups = 0 authored .md; 0 stale Refs |
| Rest-TODOs T1/T2/T4/T7 (69 Ref-Updates) | ce `80cb1434` | super `e27295d`, prt-art `01e8b7d`, thesis `dfa5acb` | kritische Ebene 0 stale |
| Kosmetik T3/T5/T6 | ce `a91f3339` | super `12c2990`, thesis `43e399a` (spaeter gepusht), Gitlink `7bcb604` | 36 thesis-Renames, 0 dashed |
| Frische Verortung (Brief) | — | super `2888350` | — |
| Ledger §24.F + Infra-Handout #56 | — | super `b4121e2`; **Cluster-Repo** `081ebc4..6a00c6e` (nur origin) | Handout dort, wo der Infra-Agent liest |
| **Storage #51 CE-Seite** | `ea2c544c` | super `378d1ce` (main.cpp + Gitlink) | eigene Verifikation 275/275, golden byte-identisch, byte-neutral (env leer = inert) |
| **#52 variant-Bloat** + Ebene-C-Umstellung curl-PUT | `93a21233` (im Text auch `9614ae0e` fuer #52 genannt) | super `6b556c3` | `HotPathIsVariantFree` PASSED, 275/275, cf22 nach `-i` = 0 |
| **#45 A2-Neben Stufe 1** (16 Dateien, RM-Rename) | `ce0e252d` | super `48691bb` | eigene Verifikation 275/275, golden 131072-CRC64 + 320 diff-leer, POD byte-verbatim |

Abnahme-Muster durchgaengig: **Delegating-Architect** — mechanische Breite an Subagenten, Verdikt/Verifikation nie delegiert; Pflicht-Force-Recompile (`find tests apps tools libs -name '*.cpp' | xargs touch`) vor jedem ctest-Vertrauen.

---

## (d) FEHLER + FIXES

1. **Stale-Binary-Falle (Kernlehre):** INC-2d-Subagent meldete 270/275 "nur golden" — real 267/275 mit **3 echten Regressionen**: `test_container_genus` (`array<11>[11]` OOB, Adapter-slot 12->11), `test_genus_binding` (`array<17>[17]` OOB, queuing_q2 17->16), `test_obs_phaseB_pilot` (honest-0-Scan-Achsen hart T12-T15 -> T11-T14 nach -1-Shift). Root-Cause: ninja rekompiliert Tests nicht, deren nur die Header sich aenderten. Fix: Force-Recompile + stale Test-Labels korrigiert; **Option (b) abi_adapter-Schreibfehler explizit ausgeschlossen** (fill_observer_v3 schreibt Slot i = Achse i, 0..16 lueckenlos).
2. **`test_smoke_coverage_profile::SweepPassPlanIsDeterministic`** erwartete 19, bekam 18 — stale Erwartung (isa legitim aus dem Sweep). Fix 19u->18u (selbst gefunden).
3. **build-i2 (clang) 263/411 rot:** stale Test-Binaries (`cmake --build build-i2` baut ce-Tests nicht, EXCLUDE_FROM_ALL) + **vorbestehender B2/B4-Gap** (`axis_03a_search_algo_flags.hpp` nicht im Dep-Scan-Include-Root). Kein INC-2d-Regress (INC-2d fasste kein Build-Wiring an).
4. **Mojibake-False-Positive** am Ledger: Code-Grep-Muster mit literalem `â€` matcht legitime deutsche Typografie. Fix: praeziser Byte-Grep `\xc3\x83|\xc3\xa2\xe2\x82\xac`; Ledger = valides UTF-8, 0 echte Mojibake.
5. **VOR-Fehlannahme "count billig":** `PermutationEngine::count()` materialisiert `mp_product` -> haette bei 2^17 den Compile gesprengt. Selbst gefunden vor der Delegation; Fix = `catalog_axis_product` (Produkt der Groessen) + lazy View.
6. **62-MB-golden-Datei** -> nicht committet, CRC64-Anker stattdessen (git-Bloat + §0-GOAL CRC64).
7. **Storage-Praemissen-Flip-Flop (3x):** wf_aeeb3ef8 (minio) gestoppt -> wf_f7d6cdf4 (NFS-RBMM) gestoppt -> wf_60dd3eff (final) — jeweils nach User-Korrektur.
8. **Verortungs-Workflow auf stale Cluster-Klon** (36 Commits hinterher, 17.07 vs 18.07): verpasste heutige K327d-Arbeit. Fix: Cluster-Pull (`081ebc4`) + Neulauf `wf_64c5aeb6`. Delta-Korrekturen: MinIO dev-V90 = **10.0.90.224:9000** (nicht .55); `02_NETZWERK_VLAN_PLAN.txt` ist veraltetes v5 (10.10.x statt live 10.0.x); **OPN `:443` = SSL/SNI-Passthrough ohne TLS-Terminierung** (Backend muss selbst TLS sprechen); **Mess-Rueckschreibpfad existiert bereits** (Filterpod ns `measure-drop`, VIP 10.0.80.226, PUT `https://measure-drop.comdare.local/<ts>/<datei>`); prod2-Recovery = Universal-Gate; OPN-#72 CARP-Split-Brain auf 10.0.91.1 (V91-L2-Trunk fehlt). Neue Direktive daraus: Cluster-git IMMER vor Infra-Workflow pullen.
9. **Falsches Verifikations-Orakel golden==320** an den laufenden Caching-Subagenten gegeben -> per SendMessage mid-build korrigiert auf die existierenden golden-Tests (131072-CRC64 + 320-Snapshot).
10. **Konsolidierungs-Luecken T1-T7** nach User-Ruege: T1 fehlende Ref-Updates fuer Nicht-backups-Moves (69 Subs nachgezogen), **T2 eigener Klassifikations-Fehler** (4 SESSION-ENDE durch Wildcard `*AUDIT*`/`*BEFUND*` faelschlich nach `docs/audits/` -> zurueck), T3 thesis-Datumsformat (36 Renames), T4 lose Ledger/Goal-Docs, T5 authored non-.md -> `docs/artefakte/`, T6 ce/quality_audit -> audits, T7 prt-art-Matrix. "7 gebrochene Ledger-Refs" = **False-Positive** (Cluster-Repo/ce-Cross-Repo/historische Erwaehnungen).
11. **thesis hatte gar keinen `github`-Remote** (unvollstaendig eingerichteter prod1-Klon). Fix: Remote ergaenzt (`BenniProbst/20260931-Overleaf-Diplomarbeit`), `development` dual gepusht; kanonischer Submodul-Pfad = `thesis/diplomarbeit` (kein `external/overleaf` auf prod1).
12. **gitlab-Push-Fehler "could not read Username"** (credential.helper store nach langer Session verloren) -> Einmal-PAT-Helper aus dem Vault (Wert nie ausgegeben), Store danach re-populiert.
13. **MEMORY.md-Oszillation:** ~23 KB -> 17,4 KB kompaktiert (#48) -> auf User-Wunsch zurueckgerollt (volle Gewichtung, Hook bewusst ueberstimmt) -> spaeter 25203 Bytes = **ueber** dem 24,4-KB-Leselimit -> auf 23,7 KB getrimmt (alle Eintraege erhalten).
14. **Agenten-Handling:** `caching-impl` gestoppt, waehrend die User-Nachricht "wir lassen den agenten zuende laufen" unterwegs war — Arbeit (119, dann 145 Dateien) **nicht gestasht**, Fortsetzungs-Agent `caching-cont` gestartet; dieser meldete zweimal idle/"interrupted", wurde angestossen. `a2neben-s1` ging nach Ruling zweimal idle ohne Mutation, wurde direkt angestossen; Meldung "0 changes" war Timing-Artefakt.
15. **cf22-Verstoss** an #52 (Whitespace) -> `clang-format -i`, danach 0.
16. **Voll-Memory-Ladung physisch unmoeglich** (145 Files, ~452 KB, feedback allein 133k Tokens; Harness persistiert Ueberlauf auf Platte) — ehrlich gemeldet, Fix = A8b-Direktive (thema-scharf per ultracode).
17. **Sicherheitsnotiz:** konsolidierte Infra-Memory (1,4 MB) enthaelt Live-Secrets im Klartext — nicht gedumpt, nur Architektur-Muster gegrept; 104k-Zeilen-Session-Transkript wegen Live-Tokens **nicht** geladen.

---

## (e) OFFENE FAEDEN AM CHUNK-ENDE

**Aktiv laufend:**
- **#45 A2-Neben Stufe 2** (`perm_runner` -> `harness/`): VOR-Kartierung laeuft. Befund: es gibt **kein `perm_runner.hpp` und kein `harness/`** — perm_runner ist eine App (`apps/perm_runner/`) + ~12 Test-Referenzen + `profile_facade/profile_runner.hpp` + `f15_compare`; "Herausloesen" = wiederverwendbare Harness-Bibliothek aus der App extrahieren (kreuzt #156/observer/#223/result_ingest/e2e/slurm).
- **Breiter ultracode-Konformitaets-Audit** `wpz70mi2f` (read-only ueber den committeten Stand): Anforderungen <-> Design <-> Code-Review, "neueste Fakten gewinnen gegen aeltere Konflikte".

**Gated/extern:**
- **Infra #56** beim Infra-Agenten (Handout im Cluster-Repo): prod-MinIO korrekt nach **V91** verlegen (Ebene-B-Compile-Cache) + **OPN-#72** CARP-Split-Brain-Fix; Storage-Aktivierung (Ebene B mc-cp / Ebene C measure-drop-PUT) bleibt **scharf-inert**, bis der User Vollzug meldet.
- **#44 Rest-Konformitaet** — Provenienz-Sidecar `+tel=/+page=/+hw=` ist der eigentliche **Messlauf-Blocker**; plus stale-Doku-Sweep.
- **#43 INC-29.3** SampleStatus N/A-vs-Failed-Split.
- **#54** B+-Baum-Achsensteuerungs-Nachweis (Ledger §24.E, ultracode-TODO).
- **#46 FF0-FF4-Messlauf** (honest-100%) und **#47 Thesis-PDF** — gated auf Storage-Aktivierung + #44. **Deadline 28.07.2026** (§0-GOAL-V6: CI-verifizierte Messwerte, PDF gruen, #193 hand-bedienbar, Rueckschrieb `measurement/<YYYYMMDD-HHMMSS>/`).

**Bewusst offen gelassen / Residuen:**
- Ebene-C-Sink-Endform (curl-PUT gesetzt) wird erst **bei der Aktivierung** final gegen den vom Infra-Agenten bestaetigten Endpoint gezogen; PULL-Hook markiert, aber **nicht aktiv** (push-only Increment 1).
- Caching-Schritte 10/11 (CI-Version-Lock-Tripwire / Registry-Spiegel) bewusst ausgelassen (optional, CI-Strategie geparkt).
- Konsolidierungs-Residuen: thesis-interne Basename-Cross-Refs, `memory-snapshot`-Ordner als eingefrorene Momentaufnahme (absichtlich unveraendert).
- **Pi-5-Klone**: `git remote add github` + Push fuer die 4 Diplomarbeit-Klone muss **auf Pi 5** laufen (node1 kann das nicht) — wartet auf User-Auskunft zur SSH-Erreichbarkeit. Cluster-git bleibt bewusst single-remote (Cred-Vault-Ausnahme).
- Vorbestehende Warnung `-Wunused-but-set-variable (valid_sink)` in `axis_08_concurrency_olc_reserved_blocks.hpp` (kein -Werror, nicht aus diesen Aenderungen).