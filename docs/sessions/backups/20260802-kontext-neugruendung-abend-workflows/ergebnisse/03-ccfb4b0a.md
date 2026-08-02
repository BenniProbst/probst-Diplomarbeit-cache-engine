# CHUNK 4/38 — EXTRAKT (chronologisch)

Zeitraum: 08.07.2026 (früh) bis 09.07.2026 (morgens). Rolle = Diplomarbeit-Impl-Agent (Opus 4.8 / max effort), getrieben von persistentem Stop-Hook-Goal V3. Chunk beginnt mitten im Ergebnis eines Memory+Ledger-Kartierungs-Agenten und endet abgeschnitten bei einem Stop-Hook.

---

## (a) USER-DIREKTIVEN — chronologisch, wörtlich wo bindend

**Goal-V3 (Stop-Hook, mehrfach via `/goal` neu gesetzt, WÖRTLICH — bindend, gilt durchgehend):**
> „Bitte erledige alle sichtbaren TODOs und den Goal-Text V3 im Ledger. Beachte besonders die Direktiven zur Striktheit der Organisationsform der Programmierumgebung, der Modulreferenzierung und der Metaprogrammierung. Stelle zu jeder Zeit sicher, dass alle Memories geladen und alle Direktiven klar sind."

1. „Bezüglich der external Module musst du das Original im System finden und syncen, das scheint doppelte Arbeit zu sein" *(implizit aus Chunk-Kontext; Agent verweist wörtlich darauf)*
2. **„Alle Projekte müssen github und gitlab haben, wenn es dir auffällt, zieh es nach."** — stehende Regel, als Memory verankert.
3. „Gut, und auf gitlab liegt das Projekt im richtigen namespace? Per Konvention?"
4. **„Erst b, dann a, dann durchsuche die ganze Session, welche Aufgaben wir versehentlich liegen gelassen haben"** (Z.410) — explizite Reihenfolge-Direktive.
5. „Hattest du jetzt schon die ganze Session nach neuen Tasks gescannt und alle in das ledger konsolidiert und in die sichtbare TODO Liste eingereiht?"
6. „weiter" (Z.798)
7. „Api Fehler bitte weiter" / „Bitte fahre mit der letzten Aufgabe vor dem goal fort" (mehrfach nach `/model`+`/goal`-Neustarts)
8. `/compact`-Auftrag: „Bitte merke dir alle TODOs, den aktuellen Aufgabenbereich und Verlauf, sowie -stack und alle Learnings und Erkenntnisse der letzten Session. Lies alle Memory vollständig ein und das gesamte ledger."
9. „Bitte fahre mit offener Arbeit aus der letzten Session fort."
10. Infra-Diff-Auftrag: „der infra agent hat auf cluster development … gepusht, bitte dokumentiere für den Diplomarbeit Strang das diff … füge fehlende Memories aus dem Backup als Kopie in deine eigenen Memories konsolidierend ein"
11. **„Bitte stelle alle aktiven gitlab runner der produktion auf 10 parallele Threads und concurrency 3. Die vertragen das"** (Z.1794) — vom Agent ABGELEHNT (Cluster-read-only-TABU).
12. **„Korrekt, gib mir das Handover, ich schicke es an den infra agenten, aber du musst es bitte committen und pushen"** (Z.1803) — User bestätigt die Ablehnung als korrekt.
13. **EINMAL-INFRA-FREIGABE (Z.1915, bindend, nur 08.07.):** „Bitte prüfe, ob prod1 und prod2 bei der Verarbeitung von gitlab jobs etwa auf die gleiche Auslastung an job-Aufnahmen erhalten. Welche Programme können ohnegleichen von beiden nodes erledigt werden? Wo gibt es Optimierungspotential oder sogar Fehler? Bitte pull nochmal das Cluster git, dort steht der letzte Schritt drin. Derzeit haben wir große Leistungseinbußen bei prod2 und damit für unseren Fortschritt. **Das Kontingent von infra ist für heute verbraucht, übernimm das bitte**"
14. Fix-Hinweis: „minio wurde von cluster prod auf cluster dev umgestellt, ich denke prod2 ist noch nicht an dieses System nachgezogen, muss nachgeholt werden"
15. „Bitte lies dich in die Memories ein, die wir mitgegeben haben, von mir aus verwende einen Agenten dafür" · „Sortiere mal die runner und optimiere ihre Leistung über die VMs auf den ubuntu hosts" · „Dann können wir schneller an der Diplomarbeit arbeiten"
16. **REVISION der Runner-Parameter (Z.1975, bindend):** „Du benötigst für den fix die sogenannte VLAN Tabelle des clusters um die Architektur zu verstehen. **Lass uns dann auf concurrency 2 und 8 Threads runter gehen (für alle runner für bare metal host, Windows Server 2022 VM, Windows 11 VM und Talos OS VM). Langfristig wird die Architektur auf prod1 an prod2 angeglichen und daher sollten die Runner alle diesem Schema folgen.** Laut der Architektur müssen ohnehin noch viele Details angepasst werden."
17. „Bitte prüfe, ob prod2 jetzt jobs korrekt verarbeitet"
18. „Bitte dokumentiere den aktuellen Stand, du hattest oben vergessen zu dokumentieren - hast du selbst geschrieben"
19. **FREIGABE ALLER TODOs + NEUER PFLICHT-PROZESS (bindend):** „Ich gebe alle angezeigten TODO frei, aber bitte merke dir **immer vorher genau das gesamte Ledger mit Agenten gründlich zu lesen und dann mit den Hinweisen die Details gezielt manuell zu lesen**" → als Memory `feedback_before_each_todo_agent_reads_full_ledger_then_manual_details` persistiert.
20. **#31-Fork-Auflösung durch User:** „Die runtime Profile müssen ein **hybrid aus compile time und runtime** werden, um dem Experiment Baum zu entsprechen (Hinweis am Rande)"
21. „Hinweis: die Pipeline ist rot"
22. „Bitte beschreibe mir alle jetzt noch offenen Entscheidungen und den Verlauf dieser Session seit meiner letzten Nachricht, was hast du genau unternommen und warum"
23. GO-Präzisierung (aus Agent-Antwort rekonstruiert): **#31 + #29 → ultracode 4-Layer-Analyse + Planmodus (kein Ad-hoc-Bau); #28 → autonom freigegeben** („weil pmc für prod1 und prod2 laufen").
24. **„bitte lies die letzte session gründlich nach, prod2 ist jetzt stabil, wir haben ihn repariert, bitte setze jetzt alles so, dass prod2 vollständig geheilt ist. Wir hatten die Maschine neu konfiguriert und initial nur überfordert."** (Z.2688)
25. „Bitte prüfe alle shells, derzeit passiert nichts, keine neue pipeline" (Z.2719)

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN MIT BEGRÜNDUNG

1. **#25-Akten gegen preprocessed CoCo-Dateien = konform, kein Fork.** Begründung: Thesis `06_evaluation_methodology.tex:82-85` fordert Akte aus „Quelle, Prüfsumme, Zeilenzahl, **Vorverarbeitung**, Seed-Regel" — das preprocessing-Feld deckt die Herkunft ehrlich ab. xml/sosd = honest-0.
2. **Echter CI-Regressionstest statt reiner Provenienz** — weil `ext/traversal/P04-CoCo-trie` **kein Submodul** ist (direkt als tree committet) → Dateien trotz `GIT_SUBMODULE_STRATEGY: none` im CI vorhanden.
3. **ce-Namespace `comdare/research/comdare-cache-engine` (286) bleibt — KEIN Transfer.** Eigener Verdacht durch Kartierung widerlegt: `274-MIGRATIONSPLAN:18` wörtlich „KEINE Migration: dasselbe Remote wie das Forschungsrepo (CI 286)"; die 6 Zellen unter `modules/comdare-cacheengine/` sind Archiv-/Tombstone-Skelette; Transfer würde `.gitmodules` + CI-Trigger + Mess-Pipeline 286 berühren; Split deferred #12/„nach Studienabschluss".
4. **Modules-ce-Klon = veraltet, nicht divergiert** (655c0314 direkter Vorfahre von 9f60216f) → ff-syncbar; Edits nur im Arbeits-Klon (nur der hat gitlab-286), Modules-Klon nachziehen.
5. **Fleet-github-Sweep NICHT als Blind-Sweep** (~50 Repos nur gitlab) — erfordert github-Repo-**Anlage** = je-Repo-GO-TABU → eigenes Arbeitspaket #46.
6. **#38 = Owner-Domäne, kein Impl-Anteil.** Voll-Audit: ~250 innere Baseline-Zellen mit Alt-Matrix-CI liegen in db/buildsystem/foundation/Firmen-Modulen (getrennte Ledger, buildsystem hands-off); eigene Zellen sind bereits schlank.
7. **#31-F7-Doc-Ort = super `docs/architektur/`** (Diplomarbeit-zentral, dual-remote) statt measurement-all.
8. **Metaprogrammierungs-Striktheit prospektiv statt post-hoc sichern** (Stop-Hook-Punkt 3) → drei compile-time-Guards statt grep-Lint; Begründung: „jede künftige compile-time→runtime-Degradation bricht automatisch den Build".
9. **Zwei-Schichten-Doktrin bestätigt** (`anatomy_base.hpp:127-129`): compile-time `AnatomyConcept` = Hot-Path; `IAnatomyBase` virtual NUR Module-Loader/ABI-Grenze (1 virtueller Call pro Batch) — Guard beweist das positiv.
10. **Infra-Memory-Übernahme selektiv, nicht 1:1:** von 322 Infra-Memories fehlten 264; übernommen wurden **10 geltende Diplomarbeit-Direktiven** + 1 Handover-Pointer. **`buildsystem_not_cmake` und `no_git_submodules` bewusst NICHT übernommen** — gelten für comdare-Produkte, würden meiner CMake/ctest+Submodul-Struktur widersprechen. `no_python_in_buildchain` übernommen (explizit PRT-ART).
11. **prod2-Fix = Wiederherstellung des dokumentierten Zustands, kein Workaround:** `pmc:intel` ist per `.gitlab-ci.yml` Z.100-101 wörtlich an `COMDARE_PROD2_AVAILABLE` gegated inkl. Reaktivierungs-Rezept.
12. **#31 Reuse statt neuem Enum:** `WorkloadKind` (Bestand) als Achse W; Schlüsselerkenntnis „YCSB A–F sind in allen drei Workload-Mengen identisch → A–F-Kern ist mit jeder kanonischen-Menge-Wahl konfliktfrei → kein User-Gate nötig". Nur die **Extras** (Custom-Ops vs. IH/LH vs. Dataset-Kreuz) sind der echte Fork.
13. **Dataset-Achse D non-gated:** kein bestehender Dataset-Enum (Reuse-Check), 6er-Kanon durch #25/G-6v48 fixiert → kein Design-Fork.
14. **Kategorie-Achse M gestoppt** nach User-GO-Präzisierung: gehört in die geplante ultracode-4-Layer-#31-Analyse, nicht in Ad-hoc-Bau.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (literale Belege)

**#27 (CI-Nachtrag):** super 8936(`94695b2`)/8940(`b651647`), ce 8937/8942, ce 8934/8935 = alle success. Ledger-Commit super `924dbb3`, beide Remotes; Pipeline 8944 = success.

**#25 (6er-Kanon-Datensatz-Akten):**
- Treiber gegen offizielle `compute_dataset_akte` cross-verifiziert an words.txt = `0x69e841344f4d0b37` / 466550.
- Echte Akten: url `0x888786d54c6fd026`/5000 · protein `0xd7b59914049ee21a`/14411 · tpcds-id `0x1081e3892da8ced6`/629661 · trec-terms `0xccee239019e815a1`/855665, preprocessing `coco-trie:no_suffixes_small`. xml = honest-0.
- ce `1f2ad991` (3 Dateien) → cppcheck-Fix `0225396d`; super `812fe97` → Bump `1f7976c`. CI: ce 8954/8955 + super **8956 = success**. Ledger `482d34e`, Pipeline 8960 success. Task #25 completed.

**Struktur-Fixes:** Modules-ce ff-Sync 655c0314→1f2ad991, Remotes auf Fleet-Konvention (`origin=gitlab(286)`, `github`); prt-art-Research-Klon github ergänzt (HEAD `faa4e76`).

**Task-Konsolidierung:** #45 (sosd-Loader) + #46 (Fleet-github-Sweep) neu; #32 aktualisiert; Ledger-Vermerk `32fe4fd`.

**#29-Rest:** `ce docs/architecture/37_ap15_container_typen_sequence_plan.md` (Fork A empfohlen / B). ce `ddcc8b9a`, super `5defca0`. ctest test_29 1/1. CI: ce 8968 + super **8970 = success**.

**#31 F7 (Planung):** `super docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md` (Achse M × W, Fork A empfohlen/B/C). super `8318a56`.

**#45 (SOSD-Binär-Loader):** `sosd_uint64_loader.hpp` (LE 8-Byte-Count + N×uint64, byteweise `read_le_u64`, Selbstregistrierung) + `test_45` + sosd-XML-Verdrahtung. ce `029a3e71`, super `ef6f17b`. CI: ce 8978/8979/8981 + super **8980 = success** (nach Retries). Task #45 completed.

**Übergabe 33:** `super docs/sessions/20260708-SESSION-UEBERGABE-33-opus48-goalv3-25-29rest-31F7-45-strukturbefunde.md`, super `fb15c5c` (beide Remotes).

**Cluster-Diff (#47) + Memory-Konsolidierung (#48):** Cluster-Repo `comdare-cluster-development` d0a8a36→a616eb0 (7 Commits, read-only gefetcht); Ledger `53f65ea`, Pipeline **9015 = success**. Memory-Store 79→90 (11 neue Dateien + Index).

**#49 Metaprog-Striktheits-Guard (Tier):** `test_striktheit_metaprog_guard.cpp` — 11 Referenz-Anatomien nicht-polymorph + AnatomyConcept, `gattung_of` total. ce `5c378082` (main+dev), super `16ab84d`. ctest 1/1 + Regression. CI: ce **9020** + super **9021 = success**.

**Infra-Handover:** `super docs/sessions/20260708-HANDOVER-infra-prod-runner-concurrency3-threads10.md`, super `81d5b79`; docs-Umbrella **9025 = success**. Runner-Tabelle: 16 prod1-baremetal(AMD 9950X3D), 17 prod2-baremetal(i9-14900KS), 19 prod2-win11 online; 14/15/18 offline.

**Infra-Agent-Rückmeldung:** super `b30d122` — concurrency=3 + `CMAKE_BUILD_PARALLEL_LEVEL=10` AUSGEFÜHRT auf 16/17; win11/k8s offen; prod2-RAM/ICE-Warnung. Agent rebased sauber (kein force-push) → `f64a8a9`, Ledger `bcc8dcb`.

**#50 Achsen-Guard (Organ):** `test_striktheit_axes_guard.cpp` — alle 26 axes26-Strategie-Marker (CRTP) nicht-polymorph. ce `2cb3cd34`. CI ce **9033 = success**.

**prod2-Infra-Fix (#52, unter Einmal-Freigabe):** `[runners.cache.s3]` auf dev-MinIO (`minio.comdare.de:9000` / `buildsystem-cache` / `/etc/hosts`-Pin `10.0.60.1` / CA-Bundle), Secret **file-to-file** von prod1 (nie geechoed), Backup + SIGHUP, `gitlab-runner verify = is valid`, **Round-Trip PUT=200 GET=200 DELETE=204**. concurrent 3→2 auf prod1+prod2; `CMAKE_BUILD_PARALLEL_LEVEL` 10→8 (Gruppe `comdare`). Cluster-Doc `K89d` (`68f8e5b`, Verifikation `568edcc`), super Ledger `8bacc3f` / `821a7ee`. End-to-End: prod2-Job 241734 (`pmc:intel`) success mit dev-MinIO-Cache-Extract; Umbrella **9043 = success**.

**#50-Rest ABI-POD-Guard:** `test_striktheit_abi_pod_guard.cpp` — 12 ABI-Transport-PODs trivially_copyable+standard_layout. ce `60a710a9`, super `2882020`, ctest 3/3.

**#31-Schritt-1 (Reuse-konform):** `workload_matrix.hpp` mit `WorkloadKind`-Reuse, `ycsb_token`, `ycsb_profile_list`, `config_for`→`profile_by_name` bit-identisch. ce `88738285`, super `a2dce21`/`6cb6fb6`, ctest 4/4.

**#31-Schritt-1b (2D-Matrix):** `CanonicalDataset` (6) + `mp_product` → `matrix_cell_count == 36`. ce `4d8aedce`, super `434bfe0`/`e9b9aa9`, ctest 4/4.

**Pipeline-Rot-Fix 09.07.:** `COMDARE_PROD2_AVAILABLE=false` + `.pmc timeout:15m`-Härtung + additiver CI-Kommentar. ce `3fb7dea8`, super `fbe3f65`; Handover `super docs/sessions/20260709-HANDOVER-prod2-configure-hang-pmc-intel.md`. **Pipeline 9093 (main) = success** (literal), super 9095 = success.

Alle Increments: clang-format 22.1.8 rc=0, Mojibake 0, TABU-Audit clean, granulare Commits (nie `git add -A`), Push beide Remotes, Modules-ce ff-synchron.

---

## (d) FEHLER + FIXES

1. **cppcheck `uninitMemberVarNoCtor`** (ce 8948, lint:static) in `test_25`: `KanonCase::checksum/line_count` ohne Initializer → `{}`-Default-Init (manuell, deterministisch). Erkenntnis: cppcheck nur in CI (2.21.0), nicht lokal.
2. **#45 CI-Fail:** g++-13-ICE Segfault (Cold-Cache) auf Downstream 8981 — kein Code (gleicher SHA in 8978/8979 grün). 1× Retry (Job 241307) → success. Danach super 8980 rot wegen prt-art-8982 (g++-16-ICE) → Retry → success.
3. **Handover-Pipeline 9011 rot** (docs-only-Commit, wechselnde Downstreams) → als transiente Historie belassen (Präzedenz 8775); Memory `reference_ci_runner_ice_cold_cache_instability` angelegt (max 1× retry, kein Retry-Loop).
4. **Mojibake-Fehlalarm im Ledger** (Z.504/518 enthalten das grep-Pattern `Ã|â€` literal als dokumentierte Regel) — False Positive.
5. **„TABU"-grep-False-Positive:** matcht „pod" im Dateinamen `test_striktheit_abi_pod_guard.cpp`.
6. **super non-fast-forward Push** (beide Remotes): origin/main voraus durch Infra-Agent-Commit `b30d122` → sauber rebased, **kein force-push** (GitFlow main=Autorität).
7. **RAM-Fehlannahme des Infra-Agenten korrigiert:** „prod1 ~157 GB frei" war **Disk**, nicht RAM. Real: prod1 60 GB (talos-prod1 40 GB → ~20 GB Runner), prod2 62 GB (5 VMs = 50 GB → ~12 GB Runner). → 3×j10 = 30 Threads zu viel für beide.
8. **prod2 36 % Fehlerrate** (vs. prod1 11 % auf je ~200 Jobs): Root Cause = `[runners.cache.s3]` zeigte auf abgelöstes `minio.prod.comdare.de` / `gitlab-runner-cache` (löst auf V10-VIP 10.0.10.1 ohne :9000-FE = toter Endpoint) → „Failed to extract cache" → Cold-Build → ICE. Behoben (s. o.). Zusatz-Erkenntnis: **SIGHUP lud die volle `[[runners]]`-Cache-Config doch** (kein Restart nötig); ein zuvor gesehener Fail lief noch vor dem Reload.
9. **#31 Reuse-Verstoß (MAJOR Selbst-Korrektur):** Agent baute `WorkloadProfile`-Enum **parallel** zum Ledger-Agenten; dieser fand danach den bestehenden `enum class WorkloadKind` (`builder/commands/workload.hpp`) → dritter konkurrierender Enum. **Sauber revertiert** (ce `7c8692bd`, super `43aa364`/`aaeeb8b`) statt zu flicken. **Prozess-Lehre verschärft: Ledger-Agent VOR dem Bau abwarten, nicht parallel.**
10. **Falsche Transient-Einschätzung (Selbst-Korrektur, vom User angestoßen):** Pipeline war **9 h deterministisch rot**, nicht transient. Root Cause: `pmc:intel` auf prod2 — `cmake -B build -G Ninja` hängt **60 min vor der Compiler-ID**, dann Runner-Timeout 3600 s. Beweis Infra-not-Code: identischer SHA `4d8aedce` um 20:36 grün in 28 s, ab 21:53 (gleicher Runner) 60 min Hang; `pmc:amd`/prod1 grün mit identischem Template.
11. **Verfrühte prod2-Reaktivierung (09.07., am Chunk-Ende):** Variable auf `true` gesetzt + Probe 9099 — `pmc:intel` blieb 22 min `pending`. Analyse: prod2-Runner online, korrekt getaggt `[prod,baremetal,intel]`, 2 Slots durch `sanitize:asan-ubsan` (242330) + `contract` (242332) aus paralleler dev-Pipeline 9094 belegt. **Diese hängen selbst seit 39 min am `cmake -B build-san` ohne jeden Output** → der configure-Hang trifft **jeden** cmake-configure auf prod2, nicht nur `pmc:intel`. Variable **sofort zurück auf `false`**, 9099 gecancelt.
12. **Kleinere Werkzeug-Fehler:** falsche Cancel-URL (fehlte `/pipelines/`), sha-Abfrage mit 8-Zeichen-Prefix, awk-FILE-Marker ohne `.md`, Token-Extraktion aus falscher Quelle (Fix: `~/.git-credentials` für gitlab.comdare.de), lange `-m`-Commit-Message bricht Shell → `git commit -F messagefile`.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE (09.07. morgens, abgeschnitten)

**AKUT — unbeantwortete Fork-Frage an den User (letzte Agent-Nachricht):**
> „Soll ich **(a)** den prod2-Runner (id=17) pausieren + die hängende development-Pipeline 9094 canceln (sofortige Entlastung, sauberer Zustand bis zum Node-Fix), oder **(b)** nur dokumentieren und dir/Infra die Runner-Aktion überlassen?"

**prod2-Status (widerlegt die User-Prämisse „prod2 ist stabil"):** configure-Hang besteht weiter und trifft **alle** cmake-configure-Jobs. `COMDARE_PROD2_AVAILABLE` steht wieder auf `false` (schützt aber nur `pmc:intel`; `sanitize`/`contract` landen ungegatet auf prod2 und blockieren 60 min). Vermutete Wurzel: stale Mount / hängendes Filesystem nach MinIO-prod→dev-Swap oder Node-Blockade. Empfohlene Node-Diagnose: `cmake -B build` in ce-Checkout, `mount`/`df` (alte prod-MinIO/S3-Mounts), `dmesg` auf I/O-Hänger.

**Laufende/offene Shells:** `bhfl70vkc` fertig (super 9095 success, dev 9094 running) · `b0c98mynq` fertig (Timeout, pmc:intel pending) · `baxb4vh7o` (pmc:intel-Poller, beendet sich durch Cancel selbst).

**Offene Diplomarbeit-Stränge:**
- **#31-Schritt-2** — Extras-Vereinheitlichung: `WorkloadKind` Custom_HotKey/RangeDelete/BulkInsert vs. `profile_by_name` IH/LH vs. F7-Dataset-Kreuz. Agent-Empfehlung: WorkloadKind als Basis + IH/LH ergänzen. **User-GO: ultracode 4-Layer + Planmodus, kein Ad-hoc-Bau.** Kategorie-Achse M (Reuse `MeasurementCategory`, 16 Werte, `comdare::cache_engine::measurement`, KEINE bestehende Regime-Klassifikation observer-vs-PMC) ist vorbereitet, aber bewusst gestoppt.
- **#29-Realisierung** — Genus→Typ-Umbau, golden/ABI-tief; braucht ABI-GO + fresh-context + Doppel-Review; User-GO: ultracode 4-Layer + Planmodus.
- **#28/#270a** — P/E-Core-Auto autonom freigegeben, **aber** Verifikation braucht Intel-Hybrid-Hardware = prod2 (prod1 ist AMD) → blockiert bis prod2-Node-Fix. Code baubar, Scharfschaltung wartet.
- **Weiter gated:** #13/#270b (node7-Freeze, Infra/Montag) · #20 (gcc-15.3-Install, Infra) · #21/#23/#36/#40 (Infra-Agent) · #14/#276 (ausdrücklich zuletzt) · #32-Rest/#38 (Owner/Firmen-Domäne) · #46 (je-Repo-GO für github-Anlage) · #156/#215/#216 golden-HELD (fresh-context + GO) · #44-Rest.
- **Strukturelle Beobachtung fürs Infra-Handover:** generische Jobs (`sanitize`/`contract`) belegen den kostbaren bare-metal-prod2, der der echten PMU-Messung vorbehalten sein sollte → Tag-/Scheduling-Thema.
- **Offene VM-Runner** mit Schema `concurrent=2 / -j8`: Win2022 (18), Win11 (19, RDP), Talos/k8s (14/15, kubectl + #21/H15-k8s-Cache-Lücke).

**Endstände (git):** ce `3fb7dea8` (main+dev) · super `fbe3f65` · Cluster `568edcc` · Modules-ce synchron · Memory-Store 90+ Dateien, Index konsistent.

**Meta-Faden:** Der Stop-Hook feuerte in diesem Chunk **8×** mit derselben Forderung „erledige ALLE sichtbaren TODOs"; er akzeptierte die Gated-Klassifikation nie als Erfüllung. Das erzwang wiederholt die Suche nach non-gated Slices (führte zu #49/#50/#50-Rest/#31-Schritt-1/1b), einmal aber auch zum verfrühten Bau mit anschließendem Revert. Der Chunk endet mitten in einem weiteren Stop-Hook-Feedback ohne Inhalt.
