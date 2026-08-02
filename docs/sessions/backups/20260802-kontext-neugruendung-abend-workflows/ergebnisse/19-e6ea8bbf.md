# CHUNK 16/38 — Extraktion (chronologisch)

Zeitraum: 2026-07-16 spät → 2026-07-17 (Nacht-Autonomie, Morgen-Rückfragen, VOLLES GO, GOAL-V6, Bau-INC-0, Bau-INC-1-Planung). Chunk beginnt mitten in der E17/E18-Fork-Vorlage und endet mit der offenen Q2-Frage.

---

## (a) USER-DIREKTIVEN (chronologisch, wörtlich wo bindend)

**D1 — E18/E17-Rulings (nach den Forks F1/H-1):**
> „F1a: korrekt, machen wir so. F1b: ABI/golden-GO. **Die Gattungen und deren Durchsetzung ist unverhandelbar.** F2 und F3: Wie empfohlen nach gründlicher doku Recherche. H-1: Wie empfohlen, aber statische Haupt-Achsen (Hardware allgemein, wie etwa AVX und andere Erweiterungen) gegen dynamische Unterachsen abwägen und Recherchieren."

**D2 — Ledger-Nachhol-Doku:**
> „Bitte gehe die gesamte Session sehr gründlich nach meinen Antworten durch, indem du mit einem ultracode workflow alle Entscheidungen im Ledger final Konsolidierst und reich dokumentierst. Bitte hole die Ledger Dokumentation nach, wir haben das lange schleifen lassen."

**D3 — Nacht-Autonomie (als Memory zu verankern):**
> „Ich gehe jetzt ins Bett, bitte mach so weit autonom wie du kannst und notiere offene Entscheidungen bis morgen früh, merke dir das. Dann entscheide ich den Rest dann"

**D4 — Morgen:** „Guten Morgen, lass uns fortfahren. Bitte stelle jetzt die Rückfragen zu den noch offenen Entscheidungspunkten unter Einhaltung der Direktiven"

**D5 — Die 6 Antworten (KERN-Nachricht, architektur-definierend, verbatim-relevant):**
- *Frage 1 (DLL-Load):* „Bitte starte einen ultracode Workflow, hier ist weder das Konzept von Achsen, den Allokatoren als Algorithmen der Allokator-Achse, noch sind hier Gattungen und die Prüf-Dock Verträge zwischen einer CacheEngineBuilder und einem C++23 ABI stabil geladenen .so Modul klar. Ich kann die Frage nicht beantworten, weil die Konstruktionslogik generell fehlt, **ich tendiere zu b**, bin mir aber nicht sicher. Bitte schlag es gründlich nach."
- *Frage 2:* „Schritt 4->5 erstmal bestätigen. **Die Scheduling Achse ist erstmal eine Systemachse unter der die CacheEngineBuilder gebaut wird** und das führt dazu, wie die Tier-Binaries unter diesem Aspekt untergeordnet ebenfalls statisch gebaut werden. Der Anatomy Major reitet also am Experiment-Planer-Dock gegenüber der Erstellung von CacheEngineBuilder Messsystemen. **Wir zerlegen das golden und bauen um**, wie implementieren einen **view als „nur lesen" aus einem sequential container**, es gibt **immer ein Kopf-Framework aus gemeinsamen Gattungs-concepts je Ebene-1-Gattung** (map bzw. Search Algorithm Hülle, (sequential) container, set, graph,...)."
- *F12(iii):* „Die **Telemetrie ist eine System-Achse in der CacheEngineBuilder**, Bitte setze mit ultracode eine Designvorlage auf … **gated nach Gegenprüfung durch mich nach dem Design**."
- *H-6/H-7:* „H-6 wie empfohlen … H-7 auch wie empfohlen, aber bedenke, dass eine **Tier-Binary durch eine CacheEngineBuilder System-Achse statisch für System-passende Optimierungen kompiliert werden muss** (AVX512 … nicht überall vorhanden -> speziell passend für optimale Systemausnutzung kompiliert oder zum Performance Vergleich nicht mit einkompiliert -> **volle Kontrolle**)."
- *H-8:* „Der **Governor und Prefetcher ist eine Tier-Binary Achse**, und der Governor ist Teil der Strategy-Pattern oder automatischen Heuristik-Command-Pattern Einschätzung eines (virtuellen) Tier-Binaries."
- *H-9:* „Das ist eine **dynamische System-Unter-Achse**, deren Eigenschaften über das Prüfdock an eine Tier-Binary als Einstellungen gesendet werden … das Tier-Binary sendet dann Messergebnisse seiner Ausführung über sein Prüfdock zurück (ABI Stabil). **Die Wahl der Lasten und Last-Frameworks ist auch eine Systemachse in der CacheEngineBuilder.**"
- *H-10:* „… die **statische Kompilation einer CacheEngineBuilder oder Tier-Binary gilt als IMMER zu versionieren und in Metadaten für dieses Binary daneben zu dokumentieren**."
- *Frage 5 (Planer-Codegen):* „Diese Frage unterscheidet nicht korrekt zwischen dem Baustein Ort der CacheEngineBuilder und der Tier-Binaries … F1: runtime der CacheEngineBuilder als Unterachse, befehligt ein Tier-Binary am Prüfdock was es ausführen soll und welche Last aus welchem Framework … F2: **Jeder runner ist eine ISAxOSx alle System achsen, je Durchlauf**, daher können in einer matrix alle runner, die disjunkt Systemachsen Testen (**beim Messen concurrency 1 je Maschine**) parallel über alle verschiedenen ISA laufen. F3: Wird aus der XML abgeleitet und muss erst stabil stehen, um reproduzierbar zu sein. **F4: XML bitte.**"
- *Frage 6:* „Bitte ziehe das autonom nach, nachdem du den stand mit ultracode durchsucht hast."

**D6 — Rekursive Dock-Architektur (Präzisierung):**
> „Der Experient-Planer hat ein Dock für C++23 .so ABI stabile CacheEngineBuilder Programme, die er mit verschiedenen System-Achsen (und System-Unterachsen) Algorithmen und Einstellungen bestückt und hat dort Verträge mit der CacheEngineBuilder und die CacheEngineBuilder hat ihr Prüfdock, um ihrerseits wieder .so C++23 ABI stabile Module am Prüfdock der Tier-Binaries zu kompilieren. Die CacheEngineBuilder werden System-Achsen-Versioniert und die Tier-Binaries (Heuristisch mit noch einer Ebene nach dem Command pattern in einer compile-chain-of-responseabilities, oder plain ein Tier-Binary am CEB Prüfdock). CEB kann verschiedene Gattungen an Binaries bauen und durchmessen, muss aber vorher auf deren Observer und Module kompiliert werden (System-Konfiguration -> Mess-Achsen-heuristische-Konfiguration)."

**D7 — Dock-Directionality (korrigiert die Assistant-Fehlannahme „beide bidirektional"):**
> „Nennen wir das **Experiment-Dock den eindimensionalen Vertrag**, bei dem der Experiment-Planer die Einstellungen der von ihm compilierten CEB steuert, aber das **Prüfdock eines CEB-Framework-Messsystems hat ein bidirektionales Prüfdock** zu seinen verschiedenen Arten von Tier-Binary .so Interfaces. **Die CEB schreibt nach Bestimmungen des Experiment-Planers die angeforderten Aufgaben und Messwerte selbst an das eingegebene Ziel in der XML zurück** (weiterer Planungsstrang existiert zu diesem Detail, bitte verknüpfen)"

**D8 — Voll-Konsolidierung:** „Bitte gehe den gesamten Kontext sehr gründlich durch, den wir heute und gestern angefasst haben und Konsolidiere reich alle Erkenntnisse mit einem ultracode workflow in das ledger."

**D9 — VOLLES GO + Kontext-Ende:**
> „**GO für Q1-Q5, volles GO für DLL-Load Option B, VOLLES GO sonst. Warte auf alle Workflows, bevor du baust.** Bitte schreibe eine reiche Kontextübergabe, der Kontext endet jetzt."

**D10 — Bau-Vorbereitung + neue Standing-Direktive (nach Kontext-Neustart):**
> „… Konsolidiere reich alle Erkenntnisse mit einem ultracode workflow in das ledger. **Bereite die Bau-Phase vor, ich gebe sie danach explizit frei und wir überschreiben die Direktive des Anhaltens. Jede Aufgabe muss durch eine ultracode Planungssession über ledger und ALLE Planungsdokumente vorbereitet werden**, weil diese Bestandteile aufgrund der Systemkomplexität nicht alle vollständig in den Kontext passen können."

**D11 — Goal-Neuplanung + Ledger-Doktrin-Wechsel:**
> „Bitte plane das ‚/goal' neu und konsolidiere den Text einer neuen Version in das Ledger, nachdem der Workflow durch ist. **Das ledger darf regulär geupdated werden, nicht nur additiv**, sobald der workflow durchdringt. **Neuere Fakten schlagen immer ältere Fakten.**"

**D12 — Dual-Verifikation + BAU-FREIGABE:**
> „… du befindest dich bare metal auf einer Starken Maschine und kannst somit sowohl per gitlab commit den CI Stand des Projektes, also auch lokal kompiliert den standalone Modus des Projektes synchron testen. **Beide Stände müssen zu jeder Zeit parallel geprüft und verifiziert, sowie getestet sein. Eine grüne Pipeline braucht also immer grüne lokale Tests und umgekehrt. BAU freigegeben.**"

**D13 — Dual-Direktive GEPARKT (lokal-first):**
> „Bitte baue das gesamte Projekt doch erst lokal auf, bevor du die CI Strategy zusätzlich zur local strategy nachziehst, das geht schneller (Die direktive der parallelen checks zwischen CI und lokalen Tests wird bis zum Abschluss aller Aufgaben geparkt und dann nachgezogen)"

**D14 — CI nicht abwarten:** „der infra Agent repariert gerade die CI, bitte warte nicht auf CI jobs, sie werden nicht anlaufen. Wenn es wieder geht, sage ich bescheid. Weiter mit der aktuellen Aufgabe"

**D15 — 8 Threads / hängende Shell:** „du darfst mit bis zu 8 Threads bauen. Bitte prüfe die laufende shell, ob sie erfüllbar ist, sie terminiert irgendwie nicht"

**D16 — Prozess-Kill-GO:** „Beende beide, GO" (die zwei 5-Tage-Alt-Driver-Prozesse)

**D17 — Runner:** „Starte die gitlab runner neu" → danach: „Mach du das, das Passwort für comdare liegt im cred vault, bitte lies es sicher aus **ohne es zu lesen** und führe den Befehl aus"

**D18 — Infra-Handover:** „Bitte schreib dem infra Agenten unter Cluster/docs/sessions ein handover, commit/push/sync. Wir machen ohne CI weiter, er räumt das auf"

**D19 — keys-Tracking bestätigt:** „keys wird ab sofort getracked und ist in einem privaten lokalen Cluster git verankert, das ist korrekt. Bitte fahre mit der Entwicklung und dem Bauen des Hauptstrangs fort"

**D20 — INC-1-Rulings (konditionale Freigabe):**
> „Ja, die möglicherweise ausschließlich **additive Implementierung ist nicht vollständig umsetzbar, es wird eher ein Ausschneiden der Achsen aus den bisherigen Achsen sein und das ist freigegeben**. Trotzdem alles bitte genauso wie geplant. Freigabe erteilt. **Q1:** … die Aufteilung und Wiederverwendung der Achsen concepts ist aus früheren Sessions belegt, **bitte merke dir immer zuerst mit ultracode zu versuchen Fragen aus der Dokumentation aufzulösen**. Wir verwenden also **CebSystemAxis\<Derived\> als abgeleitetes Konzept der allgemein geplanten Axis\<Derived\> Konzepte. Es ist eine neue Geschwister Wurzel, die per Plan ein gemeinsames Dach haben sollten** (sonst Lücke weil Plan in vorherigen Sessions nicht korrekt umgesetzt). **Q2:** Bitte recherchiere das nochmal gründlich mit ultracode und stelle die Frage nochmal mit mehr Kontext für mich, dann sage ich etwas dazu (vorher keine Freigabe). **Q3: Die compiler sind eine System-Unterachse für den Experiment-Planer**, der sowohl CEB, also auch die Tier-Binaries durch CEB mit beiden compilern baut, um die Ergebnisse zu vergleichen (compiler bis 5% performance Unterschied). **Es ist damit eine volle fünfte Systemachse.** Bitte gib mir Q2 nochmal sauber und dann beantworte ich das und gebe frei (**derzeit ohne Q2 keine Freigabe**)"

**D21 — Q2 = GO-Trigger + Parallelisierungsplanung:**
> „Bitte lege mir Q2 vor, sobald der Workflow durch ist. Sobald ich entschieden habe, starte einen ultracode Planungsworkflow, welcher **disjunkte und sequentielle Bearbeitungsbestandteile der gesamten jetzt noch offenen TODO Liste strategisch in der Reihenfolge und Parallelität plant**, sodass wir möglichst viele Stränge parallel entwickeln können. **Die Beantwortung der Q2 Frage gilt dann als volles GO**"

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN + BEGRÜNDUNG

1. **F1b — Set-Ebene-1-Promotion mit ABI/golden-GO, Gattungs-Durchsetzung „unverhandelbar".** Begründung User: architektonisch echt, nicht nur Vokabular. Design-Befund: `AnatomyGattung` wird **append-only** erweitert (`Set=3`), `AnatomyGenus` bleibt **byte-identisch** (weil `genus()` über die ABI geht und `pruef_dock_sequencer.hpp:39-41` danach sortiert); der Bruch ist rein **Compile-Contract** (`gattung_of()`, `container_framework` `type_count 4→3`, Tests) — der Compiler lehnt `Set∈Container` ab.
2. **golden-320 beweisbar UNBERÜHRT von F1b.** `binary_id = serialize_composition_path<P>()` baut nur aus den 19 SearchAlgorithm-Achsennamen (`axis_path_serialization.hpp:30-60`); `grep` über `golden_fullpilot_320_binary_ids.txt` nach gattung/genus/set = **0 Treffer**. ⇒ Keine Regenerierung, keine Messdaten-Invalidierung.
3. **EIN koordinierter Anatomy-ABI-Major 4→5** statt zwei Bumps: F1b + F2 (Set-ABI V2-POD append-only) + #37-Scheduling reiten gemeinsam, **nach** der F12(iii)-ABI-Grenzen-Session. Begründung: ein Major-Bump verwirft alle Alt-DLLs → ein Rebuild statt zwei; F1b-Grenzkosten ≈ 0 (POD-1416 unberührt).
4. **H-1 Hardware:** ISA-**Organ**-Achse (axis_09/09b, compile-time Build-Permutation, binary_id-bestimmend) und Hardware-**System**-Achse (Blut, beschreibt den ausführenden Host, nie binary_id) doppeln sich **nicht** — semantisch dual (emit vs. host-can + measured-on); Kopplung „Binary-ISA ⊆ Host-Capability" = das Mess-Gate. Statisch → Ordner/Label; dynamisch (`ran_on_core_type`, NUMA, Threads) → CSV-Spalten. Neuer Kern-Fork **H-6**: Deskriptor-**Schwesterwurzel** statt Zwang in den Kategorie-Sampler `SystemAxis<Derived>`.
5. **Rekursive Dock-Topologie (definitiv, D6/D7):** Experiment-Dock (Planer→CEB) = **eindimensional**; Prüf-Dock (CEB↔Tier-Binary) = **bidirektional**; Ergebnis-Rückschrieb NICHT über das Experiment-Dock, sondern CEB→XML-Ziel (verknüpft mit dem Mess-Rückschreibungs-Strang). CEB = System-Achsen-versioniert; Tier-Binaries heuristisch (Command + compile-time Chain-of-Responsibility) oder plain.
6. **CEB-System-Achsen ⊃ Tier-Binary-Achsen** — Kompile-Reihenfolge System-Konfiguration → Mess-Achsen-heuristische-Konfiguration.
7. **DLL-Load = Option B** (DLL self-linkt ihren Allokator) statt A (Host-Export via `ENABLE_EXPORTS`/whole-archive). Begründung: A bricht den RAII-Destroy-Vertrag und **verfälscht die Allokator-Achsen-Messung** (prozessweite Allokator-Instanz); B repliziert den beweisbar funktionierenden CMake-Pfad (nm-belegt), wahrt faire per-DLL-Isolation unter `RTLD_LOCAL`, ist ABI-4-kompatibel.
8. **Q1–Q5-Mapping (vom User bestätigt):** Q1 Gattung-Ebene-1 = **4** (map/container/set/graph, je Kopf-Framework); Q2 Scheduling = **compile-time-CRTP-System-Achse** (verwaiste Runtime-vtable deprecaten, nicht löschen); Q3 Telemetrie **aus binary_id herauslösen** + golden neu materialisiert (messdaten-erhaltend, alt additiv eingefroren); Q4 **Prüf-Dock als EINZIGER Träger** (Iterator-Bypass `cache_engine_builder_iterator.hpp:750-756` vereinheitlichen); Q5 H-7 `-march`-Kopplung + neue Metadaten-Version.
9. **§0-GOAL-V6 löst V5 ab** (V5 in-place → SUPERSEDED, Historie erhalten): Arbeitsprogramm = **Bau-INC-0 → INC-1 → INC-2** statt alter G-Stack-Front; TABU-ABI-4-Ausnahme von „vorgemerkt" auf **aktiviert** (Änderungs-Fenster NUR im koordinierten Bau-INC-2); neue Prozess-Regeln (ultracode-Planungssession je Aufgabe, explizites Bau-Release-Gate je Phase, Lesereihenfolge §20→§19→§18→§17→§16, reguläres Ledger-Update); **super-Sub-Build = Kadenz-PFLICHT** (nicht nur ce-standalone). Namensraum: Bau-INC-0..n ≠ Infra-INC-5/6.
10. **INC-1-Design (Bauplan):** Abspaltung `build_system_axis_levels()` aus `build_all_axis_levels()` (`registry_to_axis_levels.hpp:81-83`); neue CRTP-Wurzel + Concept-Guard; 7→8 Mini-Increments INC-1a…1g (+1h Compiler-Achse); golden==320 und ABI-4 als harte Gates je Increment. Nach D20: **Ausschneiden statt rein-additiv** ist freigegeben; `CebSystemAxis<Derived>` unter gemeinsamem `Axis<Derived>`-Dach (Dach heute nirgends existent = benannte Plan-Lücke; nur als semantikfreier Layer-Supertype doktrin-verträglich, weil „Organ vs System NIE mischen" gilt).
11. **Q3-Aufwertung:** Compiler (gcc|clang) = **volle 5. System-Achse** → INC-1h (inkl. `-fno-gnu-unique`-Compiler-Gate, das der härteste clang-Blocker ist; Host→OS→Compiler→ISA-Ordner; H-10-Sidecar).

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS

| Increment | ce | super | Belege (literal) |
|---|---|---|---|
| BRÜCKE I3 (Projektion Phase→Pass + E5-Overloads) | `f4d87059` | `cc0d4b9c` | 3 tests PASSED (19 Pässe), parser 13/13, golden==320, cf22 0, Mojibake 0 |
| Design-Dossier E18+H-1 | — | `02996e2` | |
| F1a (Gattung-Vokabular, reine Kommentar-Addition, 26 ins/0 del) | `dad91fe5` | `c234c9e2` | `test_29_container_framework` 3 PASSED, `test_d9_set` ALLE OK, golden 320, cf22 0 |
| §16-Konsolidierung ins Ledger | — | `0930b65` | 1512 Z., Mojibake 0 |
| §17 Morgen-Handover | — | `2b38ed6` | |
| BRÜCKE I4 (Lauf-Fassade + Host-Run-Dispatch) | `8bacde51` | `c78359d` (Code) / `a92f362` (Ledger) | BUILD_EXIT=0, beide `--validate` rc 0, 13/13 + 3, golden 320 — **aber `measured=0`** |
| §17.E kritischer Befund | — | `4b20698` | |
| DLL-Load-Diagnose-Dossier | — | `e6435f7` | read-only, nichts geändert |
| super-main FF (Kosmetik) | — | `4612133b` | lokal main auf origin/main |
| USER-Antworten-Erfassung §12 | — | `7793735` | |
| Rekursive-Dock-Schärfung | — | `f285828` | + Memory `feedback_recursive_dock_planer_ceb_tier_abi_stable_so` |
| Konstruktionslogik-Vorlagen (2 Dossiers) | — | `4b7162f` | |
| F6-Nachzieh (3 Commits: scheduling_strategy + comdare_is_original_macro DEPRECATED, REV7-Baustein TEST-ONLY) | `871f6d2e` (via 95f76805→57330d32) | `8488d1d` | cf22 0, Mojibake 0, `test_abi_interface` 19 PASSED, golden 320 |
| §18 + §19 ins Ledger | — | `53cbecf` | Ledger 1830 Z., Reihenfolge §16→17→18(1550)→19(1797) |
| §20 Delta-Konsolidierung (+17 NACHZIEH-Vermerke) | — | `7625ed5` | +59/−0 |
| INC-0-Bauplan-Dossier (334 Z.) | — | `2960ceb` | |
| §0-GOAL-V6 (regulär, V5→SUPERSEDED) | — | `bf8a7ca` | 48 ins/2 del; Ledger 1935 Z. |
| **Bau-INC-0 (DLL-Load Option B + INC-0d snmalloc-cflags)** | **`418e4b76`** | **`3f982d0`** | `nm -D` → `mi_malloc_aligned`/`mi_free` = **T** (vorher U); **105 echte Messzeilen**; 26 snmalloc-Zellen: 0 Fehler (vorher 26); golden 320; cf22 0; Mojibake 0; ce-ctest 6/6; super `da_unit` 140/140; RSP-Reihenfolge Source→Archiv→`-o` belegt |
| INC-1-Bauplan (225 Z.) | — | `efb0d1c` | |
| INC-1-Rulings Q1/Q3 im Ledger §20.B | — | `c2b4f1f` | |
| INC-1-Addendum (Q1-Dach, Q2-Vorlage, Q3-Compiler) | — | `da1eb52` | |
| Infra-Handover (Cluster-Repo) | — | Cluster `de30a12` | gemergt (nie rebase); Token-Scan==0 |

Alle Commits jeweils auf **beiden Remotes** (origin/gitlab + github) ref-gleich verifiziert.

---

## (d) FEHLER + FIXES

1. **`measured=0` / DLL-Load (deadline-kritisch, I4-Befund).** Root-Cause: `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) schreibt eine RSP nur mit `-std=c++23 -O2 -fPIC -shared -fno-gnu-unique` — **keine `-l`/Archiv-Zeile**; die SOTA-Kompositionen fixieren `MimallocAllocator` (`axis_06_allocator_mimalloc.hpp:128/150`); der Host exportiert nichts (`ENABLE_EXPORTS`/`-rdynamic` nirgends im Baum); Loader nutzt `dlopen(RTLD_NOW|RTLD_LOCAL)` (`anatomy_module_loader.cpp:40`). **Pre-existing bewiesen** (unveränderter Thesis-Pfad liefert identisch measured=0). **Fix (INC-0/Option B):** 4. Parameter `link_libs` in der Compile-Fn (kein BuildJob-Feld, da lauf-global), RSP-Emit der Archive **zwischen Source und `-o`** (ld-on-demand-Semantik), Bake `COMDARE_FACADE_PERM_LINK_LIBS` via `$<TARGET_FILE:…>`-Genex analog `COMDARE_FACADE_PERM_INCLUDES`, gelesen in `profile_run_facade.cpp` an beiden Injektionsstellen; append-all-enabled statische Archive, **kein** whole-archive; PIC verifiziert.
2. **snmalloc-Zellen scheiterten (26 Fehler, Compile-Ebene, pre-existing).** Derselbe Vererbungs-Bruch: die header-only-INTERFACE-Defines erreichten den Subprozess nie. Fix **INC-0d**: `COMDARE_FACADE_PERM_EXTRA_CFLAGS`-Bake (4 `SNMALLOC_*`-Defs + `-mcx16`, x86_64-gegatet) → `perm_mess_defines()`. Danach 0 Fehler.
3. **Wiederholte Stop-Hook-Schleife (~12×)** am Wartepunkt: Hook forderte G-Stack-Abschluss, konzedierte aber jedes Mal „formal korrekt pausiert". Auflösung: Halt ist **hook-mandatiert** (Anhalte-Pflicht bei neuer Architektur-Entscheidung); Verifikation ergab, dass kein nicht-blockierter Increment mehr existiert (uint16-Narrow-Cast-Guard aus dem Forgotten-Sweep war **bereits gebaut**, `abi_adapter.hpp:937/942-944/1010-1013`).
4. **Workflow-Parse-Fehler** (Voll-Konsolidierung, Strang D): verschachtelte Backticks + Brace-Expansion `{6,7}` im Template-Literal → Fix: Plain-Text-Instruktionen + `+`-Konkatenation.
5. **§12-Überclaim korrigiert:** „4 vtable-Achsen documented-deprecated" war falsch → **3+1** (die 4., Scheduling, erst mit F6).
6. **Ehrliche F6-Abweichung:** `ctsha.hpp` wurde **NICHT** deprecated — es lebt (Konsument `apps/is_original_validator/main.cpp` via `is_original_codegen.cmake`); `module_abi_v1.hpp` + `LegacyOriginalCodePflicht` unberührt.
7. **Vermeintliche I4-SHA-Diskrepanz** (`c78359d` vs. `a92f362`) — per git-Ground-Truth aufgelöst: Code- vs. Ledger-Commit derselben Landung, keine Diskrepanz.
8. **build-i2-Config-Gap:** `test_experiment_projection` war mit falschem generated-Include-Root konfiguriert → lief nur in `build-conf` grün. Reiner Build-Tree-Gap, kein Code.
9. **Mojibake-Grep-Selbsttreffer:** das Prüfmuster selbst in Ledger/Doku triggert den Grep; Konvention = Muster umschreiben bzw. als bewusstes Literal ausweisen (Real-Korruptions-Scan separat = 0).
10. **Zwei Alt-Prozesse seit >5 Tagen bei 99,9 % CPU** (prä-INC-0-Binaries): PID 2218234 (golden-320-run1) beendet; **PID 3018382 = hängender `gitlab-runner`-Job** → nicht als `comdare` beendbar, Infra-Handover.
11. **VAULT-VORFALL (offengelegt, keine Werte hier):** Beim Format-Prüfen einer Vault-Zeile zog der Maskierungsversuch einen als **entwertet/rotiert** markierten Alt-Wert in den Kontext — Verstoß gegen „ohne es zu lesen"; transparent gemeldet, kein aktiv gültiges Geheimnis betroffen. Autonome Extraktion **abgebrochen**: `comdare` ist ein lokales Konto (uid 1001) → AD-Zeilen sind die falsche Quelle; verbleibende Kandidaten tragen alten *und* neuen Wert pro Zeile ohne vorab prüfbaren Hash → Lockout-Risiko. Zwei saubere Wege angeboten (User nennt exakte Fundstelle / User führt eine `!`-Zeile aus); gelöst via Infra-Handover.
12. **Nebenbefund:** Der Merge aus dem Cluster-`origin` zog frisch versionierte Vault-Dateien (`keys/CREDENTIALS-VAULT-PROD/-DEV` + Rotations-Backups) herein — vom User als **korrekt** bestätigt (privates lokales Cluster-Git).
13. **Perf-Befund:** `nproc=32`, `cores_per_build=4` → Orchestrator fährt bereits 8 parallele Build-Jobs; die wahrgenommene Langsamkeit war die **Mess-Phase**, kein Bug.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

1. **BLOCKER: Q2-Ruling steht aus** — „Wo hängt die H-7-`-march`/`-mavx`-Aufhängung?" Optionen: **A** Wert aus Build-ISA-Achse 09b (e18-Default) · **B** vollständig an der Hardware-System-Achse (wörtlichste H-7-Lesart, aber golden/binary_id-riskant + CEB-Explosion + Doktrinbruch) · **C (Empfehlung)** Hybrid: System-Achse liefert den **Wert/die Politik**, `CompileFn`-Naht ist der **Ort**, aktive `-march`-Belegung als Provenienz im **H-10-Sidecar** neben der binary_id. Ehrlichkeits-Vermerk: die Dossiers entscheiden Q2 **nicht**. **Die Q2-Antwort gilt als volles GO.**
2. **Danach unmittelbar:** (1) Bau **INC-1a→1h** mit voller lokaler Kadenz (golden==320 + ABI-4 je Mini-Increment), (2) **strategischer Parallelisierungs-Planungsworkflow** über die gesamte offene TODO-Liste (disjunkte parallele Stränge + sequentielle Ketten).
3. **Q2-unabhängiger Pflicht-Zusatz** (alle Optionen): Compiler-Dialekt-Selektor in `make_gpp_compile_fn`; `-fno-gnu-unique` für clang entfernen; `-march=native` je Compiler getrennt führen (davon lebt der 5 %-Vergleich).
4. **INC-1a-Anpassung offen:** Dach `Axis<Derived>` additiv einziehen (Stufe 1, golden-neutral); die ABI/golden-sensible Umwidmung `AxisBase→OrganAxis` + Umhängen der 22 `…StrategyBase` (Stufe 2) **wandert nach INC-2**, falls golden==320 nicht byte-identisch bleibt.
5. **Bau-INC-2** (der EINE koordinierte 4→5-Bump am Experiment-Planer-Dock): F1b Set-Ebene-1 + F2 Set-POD-V2 + F12iii Telemetrie-Herauslösung + #37 Scheduling-CT + Prüf-Dock-Vereinheitlichung + H-7 + golden-Neubau messdaten-erhaltend. Vorher: **F12(iii)-ABI-Grenzen-Session** als Design-Vorlage, gated an User-Gegenprüfung.
6. **Folgearbeiten (GO'd, ungebaut):** Planer-CI/cmake-Codegen (Interpreter + EIN Director + 2 Builder; F1=Laufzeit-Job, F2=Runner-Matrix ISA×OS, F3=aus XML abgeleitet, F4=XML-Manifest) · Serialisierung Q1–Q4 · Sequence/Graph-Dock · F3 Set-Achsen (ordering/multiplicity).
7. **CI:** bewusst **geparkt** (Infra repariert; User meldet sich). Dual-Verifikations-Direktive (lokal ⇔ CI synchron grün) ist **geparkt bis Abschluss aller Aufgaben**, dann Batch-Nachzug. Hängender Runner-Job PID 3018382 liegt beim Infra-Agenten (Cluster `de30a12`).
8. **Genuin offen laut §18.5.2:** S-7 · G5/#274 (ans Projektende verschoben) · Abgabe-Blocker (Anhänge A/B/E, CRC64 im benchmark_suite) · #40-Liste-Reklassifikation (keine Löschung) · Doppel-Etikett „F6" (07-16 Codegen vs. 07-17 Nachzieh) noch nicht disambiguiert · F12i-snmalloc-§12-Reloz.-Hygiene-TODO.
9. **Deadline 28.07.2026** (CI UND standalone messfähig auf einer Maschine); der echte mehrtägige Mess-Lauf muss davor starten. Stop-Hook läuft zum Chunk-Ende weiter gegen §0-GOAL-V6, während der Stack am Q2-Freigabe-Gate wartet.
