# CHUNK 1/30 — Extrakt (chronologisch)

Quelle: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_01.txt` (1978 Zeilen, vollständig gelesen). Zeitraum: 06.07.2026 ca. 10:00 – 22:50 Uhr, eine Managersession mit 2 Compacts (Z.494 und Z.1604). Keine Secret-Werte zitiert (Vault-Key/Secret/PAT/Token nur benannt, nie Inhalt).

---

## A) USER-DIREKTIVEN (chronologisch; woertlich wo bindend)

**A1 (Z.24/45) Einstieg** — "Wir hatten unter Projekte/docs in den letzten 5 Sessions an der Diplomarbeit weiter gearbeitet, bitte lies dich dort, dann unter Projekte/Cluster/docs und unter Projekte/Research/probst-diplomarbeit-... ein" + "Ich suche ausserdem den goal text, den ich als admin in claude code unter root@prod1 verwendet hatte, wir sind jetzt mit dem comdare user drin".

**A2 (Z.72, GOAL V2-Hook, woertlich)** — "Bitte erledige alle offenen Punkte im Ledger der Diplomarbeit. Pruefe aufgrund multiplen Layern des Aufbaus und exzessiver Metaprogrammierung nach jedem Schritt, ob die Implementierung ueberhaupt dem Kontext des Projektes gerecht wird. Die Diplomarbeit selbst liegt jetzt unter Projekte/Research/probst-Diplomarbeit-cache-engine als Gesamtprojekt zum bearbeiten. Bitte bearbeite daher den neuesten Goal Text im Ledger zusaetzlich"

**A3 (Z.76, Hook-Erweiterung, woertlich)** — "Bitte achte nach jeder grossen Aufgabe darauf, dass die gitlab pipeline durchlaeuft und strikt gruen ist. Korrigiere Fehler manuell und ohne codex. Wir verwenden codex nur zur Erstimplementierung um tokens zu sparen."

**A4 (Z.159, MATRIX-DOKTRIN Teil 1, bindend, woertlich)** — "die gesamte comdare Matrix basiert auf source code und ausschliesslich interner Anwendung aus unserer perspektive, dadurch ist Metaprogrammierung auch bei den Modulen untereinander erlaubt, nur die Produktinterfaces haben den Anspruch Kunden-geschlossene pre-compiled Binary interfaces anzubieten. Dadurch ist eine Abstraktion durch template und Metaprogrammierung in der Modul-Matrix ausdruecklich erlaubt, aber in der Products-Matrix und Research-Matrix nach aussen hin ausdruecklich verboten. Das bedeutet, dass Research und Produkt Bestandteile maximal zur Wiederverwendbarkeit nach Modules ausgelagert werden, aber dabei muessen die Quellreferenzen dokumentiert und sauber sein, bitte durchsuche den gesamten Ledger der comdare-db zusaetzlich zur Diplomarbeit und fuege diese Direktive zusaetzlich auch dort ein".

**A5 (Z.169, Doktrin Teil 2, woertlich)** — "wenn du in Products nachschaust, dann hat jedes Product eine eigene Product-Matrix, welche auf die allgemein generische Modul-Matrix referenziert und daher ein spezifisches Produkt-Binary-Interface aus den allgemeinen template Modulen fuer das spezielle Produkt erzeugt und dann damit das End-Interface in einer Modul-parallelen Pipeline im Produkt tatsaechlich echt erzeugt."

**A6 (Z.179, Doktrin Teil 3, woertlich)** — "Ja genau und Research sind early Products, also gilt das Prinzip fuer Products+Research gegen alle Module" → supersediert die alte GOALV2-Aussage "Research darf ohne Fassade direkt konsumieren".

**A7 (Z.190)** — "Bitte konsolidiere und korrigiere dahingehend das Goal als Goal V3, wenn es wiederspruechliche Aussagen gibt. Pruefe weiterhin andere Fehler im ledger, die neueste Aussage gewinnt. ultracode workflow gegen die Aussagen des Ledger und doku bitte" — Auflösungsregel **"neueste Aussage gewinnt"** wird damit kodifiziert.
**A8 (Z.196)** — "Bitte setze Goal V3 nach dem Audit direkt als neues /goal um".

**A9 (Z.311)** — "Die Pipeline haengt, bitte betreibe die monitors nur mit timer und echter Pruefung alle 10 Minuten".

**A10 (Z.320, Infra-Mandat, woertlich)** — "Es ist auch deine Aufgabe dich bei haengender Pipeline im cluster zu erkundigen und echt nachhaltig zu fixen. Sofern der ubuntu host auf AMD prod1 genug RAM hat koennen wir auch auf je 6 Kernen und concurrency 2 laufen fuer den bare metal runner."

**A11 (Z.346)** — Netz-/Key-Fakten: "alle nodes sind auf VLAN 60 verfuegbar und node8 kann nur VLAN 60 und ist von Pi 5 erreichbar. Die beiden mac mini reden auf VLAN 10 und Schluessel liegen im cred vault unter Projekte/Cluster/keys".

**A12 (Z.362, woertlich)** — "bitte schreib dem Infra Agenten in die Cluster sessions ein handover, dass er das mit mir fixt. Ich warte dort auf eine neue Netzwerkkarte... Bezueglich der pipeline faellt auf, dass die unit tests noch eine manuelle Aktion sind, aber die direktive ist strikt gruen, also auch nichts auslassen. Ohne Tests wissen wir nicht, ob alle Komponenten weiterhin funktionieren."

**A13 (Z.392)** — "Sobald die Pipelines gruen sind, bitte alles pushen und mit CMD-1-a weitermachen... Ich wuensche mir mindestens g++ 15.3 support und den neuesten clang compiler support zusaetzlich" (Compiler-Dimension fuer #276).

**A14 (Z.398, bindend, woertlich)** — "Ok, aber bei einer harten pipeline darf es kein allow failure geben..." → wird #278.

**A15 (Z.432)** — "Ich stimme deinem Vorgehen zu... die unit tests bis eben noch illegal aus waren und dass wenn ich sie manuell gestartet habe, einige tests illegal geskipped werden. Da ist also noch Luft nach oben... Bitte trage mal alle offenen Punkte noch zusaetzlich in die sichtbare TODO Liste nach, die wir in dieser Session noch nicht persistiert haben".

**A16 (Z.452)** — "Bitte ziehe #7 #277 nach ganz vorne und arbeite sie parallel zum derzeitigen Pipeline Schritt ab. Dann erhalten wir schneller ergebnisse fuer zukuenftige Laeufe".

**A17 (Z.466, TOP-PRIO, woertlich)** — "Der access key liegt im Vault. suche ihn gerne, es ergibt keinen sinn, wenn nicht alle nodes wirklich in dasselbe minio auf dev schreiben. Das minio auf prod hatte eine andere Bewandnis, hat ein frueherer Agent wohl versehentlich getrennt. Reihe das TODO als oberste Prioritaet ein, sonst baut prod getrennt von dev und das ist falsch".

**A18 (Z.479)** — Odroid-H4-Runner pruefen/pausieren ("nur 6% der Leistung von prod1... Build damit 20 mal so lange"), "Wir aktivieren die Odroid H4 runner am Ende fuer den voll build mit allen Plattformen wieder (bitte notieren)".

**A19 (Z.617/618)** — "Bitte lies alle memory ein und alle direktiven" / "Dann weiter".
**A20 (aus Compact-Liste, Z.1687)** — MeasurementVisitable: "Es wird spaeter implementiert, vielleicht kommentierst du es noch aus, denn visitor und Observer Umbau sind im Ledger noch aktiv. Ja erstmal raus damit."

**A21 (Z.1688, #279 = VORLETZTE Aufgabe, woertlich, gekuerzt)** — "Der vorletzte Punkt der Diplomarbeit sollte die Mess-Durchfuehrung der Diplomarbeit nach vorheriger Konfiguration sein... per Konfiguration die eingestellte Messdurchfuehrung im release Modus... vor Erstellung der latex pdf... aktivieren. In der Regel fahren wir aber jetzt nur den Debug Modus, der... auch den compile der CacheEngineBuilder und deren Tier-Binaries nach Definition beinhaltet... Wichtig zu unterscheiden waere, ob der CacheEngineBuilder Orchestrator gebaut wird und exakt welche Tier-Binary Rekombinationen und wie viele davon noch offen sind. Das Bauen aller Tier-Binaries ist im Standard build pflicht und wir muessen ueberwachen, welche Tier-Binaries in einem nachgelagerten Schritt nach dem Build auch die generischen Tests ueber ihre interfaces bestehen."

**A22 (Z.631)** — "der experiment driver job ist gruen, aber haengt beim aus checken".
**A23 (Z.684/776/790)** — Drei explizite Echt-Debug-Auftraege: "Pipeline startet wieder nicht?" · "Bitte debugge echt, warum die Pipeline beim Start nie von selbst jobs aufnimmt" · "die lint jobs melden, dass der cache nicht funktioniert... bitte debugge die letzten 3 Anfragen echt, wie gefordert".
**A24 (Z.1693)** — Runner-Polling-Wunsch: "alle 2+rand(0.0 ... 1.0) Sekunden".

**A25 (Z.745, bindend, woertlich)** — "Ich sehe, dass in der Pipeline 8076 jetzt verglichen zu Pipeline 8066 fundamentale Bestandteile des Gesamtsystems fehlen, warum sind die raus? Die Fehler muessen behoben werden, nicht der Test geloescht. In der Diplomarbeit findest du auch Architektur, wie die Pipeline der Messwerte ueber die cache engine gefahren werden soll, also vom Selbstaufbau bis zum Einfuegen der Messwert-Tabellen in das haupt latex dokument."

**A26 (Z.716)** — "Go fuer 1 und 2, bitte umsetzen. Bitte passe die Policy aber fuer alle runner konsistent an" (citools-Cache).
**A27 (Z.856)** — "Bitte durchsuche diese gesamte Session nach noch offenen TODOs und konsolidiere sie ins Ledger und in die sichtbare TODO Liste, bevor wir sie vergessen."
**A28 (Z.908, hebt thesis-Lese-Tabu punktuell auf)** — "das lint latex in overleaf und die unit tests in der diplomarbeit sind noch nicht strikt gruen, bitte passe das noch an und behebe die Fehler echt".
**A29 (Z.966)** — "Sobald 8093/8094 gruen sind, bitte mit den beiden offenen Strecken weitermachen. Jetzt haengt dein Monitor, obwohl die pipeline fertig ist. wollen wir autonom arbeiten, dann darf das nicht mehr passieren" (+ Z.1696 "Der Heartbeat ist zu lang, die Pipelines dauern maximal 8 Minuten").

**A30 (Z.1160, GOAL-DRIVEN-REGEL, bindend, woertlich)** — "Bitte klassifiziere die 62 Fails und starte die Fix-Serie. Die Annahme ist falsch, dass die monitor den autonomen Betrieb sichern, nur das goal tut das. Bitte merke dir, dass du alle shells und Monitore beendest, das goal abwartest und notwendiges erneut startest. Der Fortschritt muss goal driven sein".
**A31 (Z.1702/1703, Praezisierungen)** — Monitore beim erneuten Goal-Zyklus neu starten, sofern etwas Neues gebaut wird; nach erfolgreichem Abschluss beenden, "nie dangling"; "Bitte verwende regelmaessig die Monitore von vorhin innerhalb eines goal Zyklus, das spart tokens".

**A32 (Z.1196, GOAL-Hook neu gesetzt, woertlich)** — "Bitte erledige alle sichtbaren TODOs und Goal Text v3 im Ledger. Beachte besonder Direktiven zur Striktheit der Organisationsform der Programmierumgebung, Modulreferenzierung und Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle memories geladen und alle Direktiven Klar sind."
**A33 (Z.1171)** — "Bitte gib mir den goal text nochmal aus" (V3-Volltext ausgegeben, Z.1176–1188).

---

## B) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begruendung)

1. **Definition "sauber" (6 Kriterien, Z.87–96)** — Architektur-konform > offizieller Weg (CMake/ctest/CI, keine Behelfswege) > wissenschaftlich ehrlich (honest-0, keine Attrappen) > konsistent/wartbar > wiederverwendend (Bestandspruefung vor Neuanlage) > nachvollziehbar/reversibel. Nicht sauber: Quick-Fix, unbegruendete Suppression, Runtime-Kruecke statt Template, Loeschen statt Markieren, ungeprueft uebernommener Codex-Code.
2. **Matrix-Doktrin dreistufig (A4/A5/A6)** in BEIDE Ledger + Memory: Modul-Matrix = Templates erlaubt auch zwischen Modulen; Products+Research fuehren je eigene **Instanziierungs-Matrix** (generische Template-Module → produktspezifisches Binary-Interface, real gebaut in modul-paralleler Pipeline); Auslagerung nach Modules nur mit dokumentierten Quellreferenzen. Konsequenz Diplomarbeit: Tier-DLLs (`anatomy_module_abi_v1`) **sind** bereits die binary End-Interfaces der Research-Matrix → kein perm-Pipeline-Umbau, nur Konsum-Kanten aendern sich; "keine Fassade / Research direkt" ist SUPERSEDIERT (Z.187).
3. **GOAL-TEXT V3 = Ledger §13.12, AKTIV** (Z.219–241, Volltext Z.1176–1188): kodifizierte Vorrang-Regel, bereinigte Arbeitsreihenfolge (K1 → #267 CMD-1 → 265-b → #266 → AP-2-neu → #269/#244 → #270b; danach nur gated; #276 als ausdruecklich LETZTE Aufgabe), 13-Punkte-Kadenz, HARTE TABUS, Eskalation, Stop-Bedingung. 58 Korrekturen (7 BLOCKER), 27 geschlossene Punkte.
4. **#274-Migrationsplan (Entwurf, GATED)** — 16 Schritte, G1–G12, 14 offene Fragen; Kernbefund: `comdare-metrics` existiert bereits in foundation-all → Transfer statt Neubau; treecore-all fuehrt ART/BPlusTree; build-utilities T-30-Templating-Luecke = Landeplatz fuer NO-PYTHON-Codegen; test-system-Skelett kollidiert 1:1 → Rename. **Nichts ausgefuehrt bis User-GO.**
5. **#265-a Vendoring-Muster** — byte-identische Kopie (`diff -r == 0`), Provenienz-SHAs in `vendor/REPOS_OVERVIEW.md`, Reihenfolge platform VOR simd (Silent-Skip-Falle), `vendor/.clang-format DisableFormat`, tests/ bewusst nicht (FetchContent-Egress). Bewusst manuell statt Codex (reines Kopieren = kein Implementierungsfall).
6. **CMD-1-Dossier (#267)** — Zwei-Wurzel **ohne Re-Root**: Mess-Basis entsteht auf compile-time-Achsen-Ebene (`axis_command_base.hpp`), IExecutionEngine/ABI unangetastet (E-B, ABI-neutral). 4 Teil-Increments a–d. Neu eingearbeitet: IAllocatorProxyTier (AP-15-2) ist Mess-Belang; Statistik-Header in `builder/commands/` + `tier_observe_trace_abi.hpp` sind lasttragend und BLEIBEN.
7. **Lazy-Caching-Scope korrigiert (A25)** — #277-Beschleunigung ausschliesslich ueber Caches (ccache + per-Tool-citools), NIE durch Weglassen von Jobs; jede Pipeline faehrt das Gesamtsystem.
8. **citools-Cache-Redesign** — statt `policy: pull` mit designiertem Pusher (waere falsch, weil Bootstrap tool-selektiv ist → Rebuild-Sturm) bekommt **jedes Tool seinen eigenen Mini-Cache** (10–50 MB statt 1,3 GB), im Template → automatisch konsistent fuer alle Runner/Projekte.
9. **Test-Scope-Schnitte** — super: Sammel-Target `comdare_da_unit_tests` + Label `da_unit` (nicht `all`, das zoege die ce-Suite doppelt); ce: `COMDARE_TEST_CTEST_ARGS: "-LE contract|pmc"` (contract/pmc laufen hart in eigenen Jobs → kein Auslassen).
10. **A1-Pilot-DLL-Fixrichtung** — Configure-Zeit-`execute_process` → Build-Zeit-`add_custom_command`-Kette; **KEIN GTEST_SKIP** (waere #12-Maskierung).
11. **CMD-1-b-Architektur** — ein konstitutiver `container_algorithm_` (3-Wege) + nicht-konstitutives T6-Mess-Organ `allocator_meter_` nach Adapter-Muster; `in_use==allocated` ist im Zweig 2 Adapter-Spiegel-Konvention (eigenes honest-0-Urteil revidiert).
12. **Monitor-Redesign** — Vollblick ueber ALLE offenen Pipelines je Projekt (statt neueste je Branch), harte curl-Timeouts, expliziter api-err-Zustand, Heartbeat 5 min < 8-min-Pipeline-Obergrenze.

---

## C) PAKETMELDUNGEN / ABNAHMEN / COMMITS

**Diplomarbeit / super (Projekt 288):**
- `#258/#273 build:clang-Fix` — Sammel-Target `comdare_da_tools` + Job-Variablen (super hat kein Root-CMakeLists, Quelle=`Code/`); lokal CI-exakt mit clang-22: EXIT 0, 61/61. Beweis Pipeline **8066** (nach 8053-Cancel), `build:clang` literal "Job succeeded" → **Task #1 DONE**.
- Ledger-Serie: `ceb954f` (#274-Plan), `c9cf081`/`1a6cef2`/`e52a42d` (Doktrin 1/2/3), `691f2b8` (GOAL V3 §13.12), `34e425a` (ci.skip-Regelkorrektur), `bea6e7b` (CMD-1-Dossier), `ed91fcb` (Uebergabe 27), `8b3c435` (Uebergabe 28), `2a34d00` (Lazy-Rules-Revert), `916077a` (uid-Fix 103/103), `d285507`, `6816b3c`, `413dbf7`, `d953ed4`, `1420d0a`, `1346de0`, `c8f10ee`, `0702e3b`/`8ce8eca`/`83bcc91` (Docs-Wellen).
- Push-Wellen: `691f2b8..b64d7a5` (18 Commits), spaeter `691f2b8..6862b9b`; beide Remotes (origin=GitLab + GitHub).
- **test:unit automatisch + HART**: erster Volllauf ueberhaupt fand 5 echte Fails + 1 Skip-Maskierung → alle gefixt, literal **103/103 passed, 0 failed, 0 skipped**; CI-hart bewiesen in 8085.

**cache-engine / ce (286):**
- `80bfab51` #265-a Vendoring (Pipeline **8058 SUCCESS**) · `aeb27b88` experiment_driver INV-4 · `6e5d16b5` CMD-1-a · `6dd2e34f` CMD-1-a in contract:conformance (CI 6/6 literal) · `020e548e` CMD-1-b (5/5) · `b3d02002`+`e3e52f92` Codegen-Kanten CLI+Lib · `ec0ce62a` `<optional>` · `53c3e937` Property-Sweep 3 foreach-Gruppen · `d5d3bb6f` A2 · `fbf47ada` A3 (`PREFIX ""`) · `efe51d15` view/layout-Includes · `fe80a36c` Property-Sweep 9 Einzeltargets · `e6196da1` dlopen-Shims · `e62b8cf6` Job-Scope · `b1c57c3d` · `07a40255` CMD-1-c (Beweis 8218 success) · `4983a554` CMD-1-d (Beweis 8219 success).
- **#278-Kurve: 62 → 29 → 20 → 15 → 0**; CI literal "100% tests passed, 0 tests failed out of 164".

**prt-art (287):** `642540d..6741f5b` auf **main UND development**, beide Remotes; `sanitize` nach 6 Gruen-Vorlaeufen gehaertet.

**thesis (289):** chktex **964 → 0** in 4 Wellen (W8/W36 → W13/W12 203 Edits → W1 242 Edits → Restklassen inkl. 42 dokumentierter Suppressions), `.chktexrc` kodifiziert, PDF-Bauprobe je Welle (EXIT 0, genau 1 erlaubte Warning, .blg sauber). **`lint:latex` hart, allow_failure=False, Beweis 8205 success.** W24-Generator-Nachzug (caption-`%`) in beiden LaTeX-Emittern (ce `latex_anhang` 1/1, super Modul 04 8/8).

**Cluster-Repo:** `31adfc8`, `e657511` (K87 Runner-Fleet/V60-Topologie), `3486414` (H10), `eb6226c` (K87b Finalisierungs-Stall), H14/H15/H16/H18-Nachtraege, `5d29efd`; Infra-Handover H1–H9.
**comdare-db-Ledger:** `3437528`, `de17102`, `44aa7bc` (Doktrin 1/2/3).
**ci-templates (269@development):** `d68050d5` per-Tool-citools-Caches.

**Abnahmen (literal gruen):** 8058 · 8066-Familie (8066/8067/8068/8069) · 8070/8071/8072 · 8074/8075/8078/8084 · 8085 (erster harter test:unit in CI) · 8093/8094 · 8121 · 8149 · 8169 · 8180 · 8198 · 8199-Welle · 8203 · 8205 · 8207 (nach Bridge-Retry) · 8214-Welle · 8218 · 8219.
**Abgeschlossene Tasks:** #1, #8 (#278), #9 (CMD-1 a–d), #24.

---

## D) FEHLER + FIXES

**Pipeline/Infra (drei unabhaengige Wurzeln + Folgeklassen):**
1. **GitLab-Finalisierungs-Stau instanzweit** — seit 03.07. jeder Job ~5,5 min laenger (202-Loop). Wurzel: DNS-Ausfall `minio.comdare.de` (03.07. 08:20 – 05.07. 08:13) toetete 9.999 Trace-Flush-Jobs, Sidekiq-ConcurrencyLimit-Warteliste 1.956. Fix ueber offiziellen Mechanismus `resume_processing!` (1 Arg) → 1956→0; **Beweis: Job 213445 finalisierte in 3,3 s statt 5,3 min**.
2. **Runner-idle-Freeze (busy→leer)** — `contacted_at` friert sekundengenau ein, strace zeigt 0 Sends, Graceful-Stop wartet 30 s auf offenen Request. **Zwei Thesen widerlegt**: HTTP/2 (Freeze trotz `GODEBUG=http2client=0`) und Versions-Skew (18.9.0 friert identisch). Stehende These: serverseitiges CI-Long-Polling / Workhorse-Redis-Wakeup. Absicherung: systemd-Watchdog `comdare-runner-watchdog` (45 s; Restart nur wenn contacted_at>120 s UND keine Builds) — hat um 18:07:26 den ersten echten Freeze selbst weggeraeumt. **Eigener Fehler dabei ehrlich gemeldet:** Nachstell-Versuch mit echtem Runner-Token vergab 2 echte Jobs an ein Phantom → sofort geheilt (cancel+retry 213679→213696, 213676→213697); Leer-Poll-Beweis nur im ruhigen Fenster (Montag, H18).
3. **"Cache funktioniert nicht"** — Fehlalarm: `Failed to extract cache` bei `primary_modified = 0001-01-01` = simpler MISS, irrefuehrend formuliert. Echte Kosten = Erstlauf (LLVM-Tarball ~800 MB von github.com, 5min19s) + 1,3-GB-Sammel-Cache mit `dl/`+cppcheck-Build-Tree bei `pull-push`. Fix: per-Tool-Caches. **Hit-Beweis literal**: 8084 lint:secrets `primary_modified=17:34:37` → "Successfully extracted cache" → Job 10,7 s.
4. **ci.skip-Pushes canceln wartende Jobs** (8053: alles gruen inkl. thesis:pdf, aber `build:clang` [created]→skipped, Pipeline canceled; skipped nicht retrybar/403). Fix: frische API-Pipeline `POST /projects/288/pipeline?ref=main` → 8066; **Regel V3-Kadenz-12 korrigiert: waehrend Beweis-Pipeline gar keine Pushes aufs Repo**.
5. **Cross-Projekt-auto-cancel (8207)** — Submodul-Direktpush waehrend laufender super-Welle cancelt deren Kind-Bridge; Pipeline-Retry startet gecancelte Bridges nicht mit → einzelner Bridge-Retry, danach success. Als Ledger+Memory-Lektion verankert.
6. **dev-MinIO HTTP 000** — DNS zeigt auf V10-VIP ohne :9000-FE, S3-FE lebt auf V60-VIP 10.0.60.1 → hosts-Pin (Cert-SAN bleibt gueltig). AccessKey-Kandidat `admin` = 403 (sauber ausgeschlossen statt geraten), korrekter Key aus Vault verifiziert per Round-Trip PUT/GET/DELETE = 200/200/204. **(Werte nicht zitiert.)**
7. **node7-Stale-Wurzel** — Runner-Dienst gestoppt UND nie `enable`d → jeder Reboot liess ihn stale; `enable --now` = nachhaltiger Fix.

**Code/Test:**
8. **/tmp-Benutzer-Kollisionsklasse** — `/tmp/comdare_test` gehoerte dem lokalen comdare-Lauf, CI laeuft als gitlab-runner (uid 996) → Permission denied. Design-Fix: `comdare_user_tmp()` mit uid-Suffix; spaeter Sweep ueber **25 TUs / 41 Stellen** (Task #24).
9. **super-Suite-Erstlauf**: 15- statt 16-Spalten-Schema (workload_used); veraltete `<permutation>`-Tags (Parser kennt sie nicht, keine self-closing); INV-4-Silent-Skip bei fehlendem `config_dir` (still "0 Permutationen, ok") → ehrlicher Fehler; `run_pipeline_full` materialisiert output_dir immer; `GTEST_SKIP` maskierte v32-Validator → Source-Dir-Fallback.
10. **CMD-1-a lief in CI nirgends** — Label allein reicht nicht, contract-Jobs bauen gezielte Targets/Regexe → explizit in `contract:conformance`.
11. **ce-Build-Zwiebel**: CLI-Codegen-Kante reichte nicht (brechende TU gehoert zur **Lib**) — Lehre: Codegen-Ordnungs-Beweise nur im **frischen** Build-Dir (vorbebautes maskierte via stale Header); dann `<optional>`; dann `view_composition.hpp` `<cstdint>` + `axis_05_memory_layout_observable.hpp` strategy_base-Include (funktionierte vorher nur durch TU-Reihenfolge-Glueck).
12. **52 "Not Run"** — 3 foreach-Gruppen + spaeter 9 Einzeltargets ohne `COMDARE_TEST_TARGETS`-Property.
13. **A2** kein Generator-Bug: `op.key=402` ist dokumentierte K7b-Insert-Semantik → Test-Vertrag **strenger** praezisiert statt aufgeweicht. **A3**: CMake-`lib`-Praefix brach `comdare_perm_*`-Filter → `PREFIX ""` (Produktionsfilter bleibt strikt). **windows.h-TUs**: 2 DLL-Roundtrip-Tests auf dlopen-Shim portiert (2/2 Linux); `test_v5_io_real_fixture` war bereits korrekt gegated (Inventar-Korrektur).
14. **CMD-1-b Review-Faenge** — Codex-Fabrikation `in_use=allocated` kaschierte LayoutAware-Mess-Regression → ComposedStore-Rueckbau + `allocator_meter_`.
15. **Eigene Ehrlichkeits-Korrekturen** — (a) Fehlverdacht "bwrap defekt fabriziert" (stand belegt in Ledger Z.174); (b) MeasurementVisitable-Entfernung zunaechst falsch als "Scope-Ueberschreitung" begruendet — Dossier §2 forderte es, Codex war dossier-treu → Begruendung additiv korrigiert, Concept als GEPARKT-Block auskommentiert; (c) A1-Reproduktion durch Teil-Build verfaelscht (R5G ist dokumentierter 2-Pass) → kein Dossier auf halber Datenlage.
16. **Werkzeug-Fallstricke** — Python-Heredoc mit typografischem Anfuehrungszeichen; zu grosse replace-Spanne loeschte `make_small_workload()`; `grep -c` mit 0 Treffern (Exit 1) brach `&&`-Kette; Edit erfordert vorheriges Read; falscher Target-Name.
17. **Monitor-Blickfeld-Fehler** — per_page=1 je ref verlor 8093, als Kind 8096 erschien → Vollblick-Redesign + 5-min-Heartbeat.

---

## E) OFFENE FAEDEN AM CHUNK-ENDE

**Chunk bricht mitten in der Abschlussmeldung ab (Z.1978: "#267 CMD-1 (a–d) ist komplett (Task #9 geschlossen):").** In-flight zu diesem Zeitpunkt: die CMD-1-Endwelle (super-Bump + Ledger) laeuft im Vollblick-Monitor, keine Submodul-Pushes bis Terminal.

**Naechste V3-Punkte:** #265-b (ARM/sysfs-Konsum, beruehrt Mess-Pfad → doppelt kartieren) → #266 buildsystem-Reuse (Q2 config-Owner-Gate; Fallback-Empfehlung `config-all`) → AP-2-neu/#236 (Katalog-Pfad-E2E + Stub-Quarantaene) → #269/#244 + #184 Loader-Verdrahtung → #270b 3-ISA-Teilmatrix (amd64+arm64 sofort moeglich).

**Offene Arbeit/Analysen:** `migration_two_tier moved=0` als Analyse-Increment eingebucht (IMigratableTier/P4-#123); #12 Skip-Audit aller Suiten; #7-Restbeweise (Cache-Hits clang-format/cppcheck, ccache-Groessen-Watch 2–5 GB S3-Risiko); #279 (vorletzte Aufgabe, normative Quelle = Diplomarbeit-TEXT-Architektur, muss vor Umsetzung gelesen werden); #276 Voll-Plattform-Matrix als ALLERLETZTE Aufgabe inkl. Odroid-H4-Reaktivierung und Compiler-Dimension (g++ >= 15.3 + neuester clang).

**Montag mit User (Task #23, K87b H11–H18):** **H11 KRITISCH** — CoreDNS-Eintrag `minio.comdare.de → 10.0.90.224` existiert nur LIVE, fehlt in der deklarativen Quelle; ein `kubectl apply` der alten Fassung wuerde den 03.–05.07.-Ausfall wiederholen. Dazu: Dead-Set leeren, queue_size, sicherer Leer-Poll-Beweis der Freeze-Wurzel + HAProxy/Workhorse-Audit, Watchdog+GODEBUG-Rueckbau, Runner-Versions-Entscheid, prod2-NIC/H1 (Runner-Trio, runners.cache→dev, etcd 3/3), H15 k8s-Runner ohne `[runners.cache]`.

**Physisch beim User:** node5 (mac-intel, aus, WoL wirkungslos), node6 (mac-arm, SSH 22/2222 zu), node8 (RISC-V, V60-only, physisch aus — Aktivierungsweg via `ssh -J node7` vorbereitet).

**User-Gates (Task #18, je mit Empfehlung, Sammelantwort genuegt):** Q2 config-Owner [Empf. config-all] · 234-V (a) Option-A per-Source-Emission + (b) binary_id-Shape-Segment [Empf. ja/ja] · 7b-3 Andockpunkt [Empf. T12] · Datensaetze 6-vs-48 · #274-GO G1–G12 (darin G12: PATs stehen im Klartext in lokalen git-Remote-URLs → vor Transfers in Credential-Helper ueberfuehren) · E2-Sidecar-vs-Reserve.

**Prozess-Spannung ungeloest:** Der Stop-Hook meldete in Chunk 1 **acht Mal** "Bedingung NICHT erfuellt" und bemaengelte wiederholt (i) fehlende literale CI-Gruen-Referenz nach dem jeweils letzten Push, (ii) nicht operationalisierte Tabu-/Direktiven-Compliance-Pruefung ueber die konkreten Fixes, (iii) unvollstaendig verifiziertes Memory-/Kontext-Set (§13.3–13.11, HANDOVER-BEP, MATRIX-GRUNDLAGEN-GOALV2, architektur/34). Ein Compliance-Vermerk wurde in Zyklus 8 nachgetragen, vom Hook aber weiter als nicht signiert/nicht operationalisiert bewertet.