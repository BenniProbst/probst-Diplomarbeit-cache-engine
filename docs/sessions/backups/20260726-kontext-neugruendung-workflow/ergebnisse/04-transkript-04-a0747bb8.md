# TK_04 (Chunk 4/30) — Chronologische Extraktion

**Zeitraum:** 2026-07-08 (Fortsetzung) bis 2026-07-09 früh. Manager-/Impl-Agent-Session (Opus 4.8), getrieben von persistentem Stop-Hook-Goal-V3. Datei: `/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/tk_04.txt` (1939 Z.).

---

## (a) USER-DIREKTIVEN (chronologisch, wörtlich wo bindend)

| # | Zeile | Direktive (O-Ton) | Charakter |
|---|---|---|---|
| U1 | Z.276 | „**Erst b, dann a, dann durchsuche die ganze Session, welche Aufgaben wir versehentlich liegen gelassen haben**" | Reihenfolge-Anweisung |
| U2 | (vor Z.179, referenziert) | „Bezüglich der external Module musst du das **Original im System finden und syncen**, das scheint doppelte Arbeit zu sein" | Struktur-Auftrag |
| U3 | Z.219 | „**Alle Projekte müssen github und gitlab haben, wenn es dir auffällt, zieh es nach.**" | stehende Regel |
| U4 | Z.227 | „Gut, und auf gitlab liegt das Projekt im richtigen namespace? **Per Konvention?**" | Prüfauftrag |
| U5 | Z.525 (impliziert) | „Hattest du jetzt schon die ganze Session nach neuen Tasks gescannt und **alle in das ledger konsolidiert und in die sichtbare TODO Liste eingereiht?**" | Konsolidierungs-Pflicht |
| U6 | Z.576 | „weiter" | Fortsetzung |
| U7 | Z.794 / 1367 | „Api Fehler bitte weiter" | Fortsetzung nach API-500 |
| U8 | Z.1230 | „**Bitte stelle alle aktiven gitlab runner der produktion auf 10 parallele Threads und concurrency 3. Die vertragen das**" | Infra-Auftrag (vom Agenten **abgelehnt** → Handover) |
| U9 | Z.1233 | „Korrekt, **gib mir das Handover**, ich schicke es an den infra agenten, aber du musst es bitte **committen und pushen**" | Bestätigt Grenzziehung |
| U10 | Z.1295 | „**ich gebe für heute ausnahmsweise frei, dass du ebenfalls an infra arbeiten darfst, obwohl du der Implementierungsagent bist**: … prüfe, ob prod1 und prod2 … gleiche Auslastung … Wo gibt es Optimierungspotential oder sogar Fehler? Bitte pull nochmal das Cluster git … **Das Kontingent von infra ist für heute verbraucht, übernimm das bitte**" | **EINMALIGE 1-Tages-Infra-Freigabe (nur 08.07.)** |
| U11 | (Z.1304 ref.) | „minio wurde von cluster prod auf cluster dev umgestellt, ich denke **prod2 ist noch nicht an dieses System nachgezogen**, muss nachgeholt werden" | Fix-Hinweis (traf zu) |
| U12 | (Z.1309 ref.) | „Bitte lies dich in die Memories ein, die wir mitgegeben haben, **von mir aus verwende einen Agenten dafür**" | Agent-Erlaubnis |
| U13 | Z.1339 | „Du benötigst für den fix die sogenannte **VLAN Tabelle** … Lass uns dann auf **concurrency 2 und 8 Threads** runter gehen (für alle runner für bare metal host, Windows Server 2022 VM, Windows 11 VM und Talos OS VM). **Langfristig wird die Architektur auf prod1 an prod2 angeglichen** und daher sollten die Runner alle diesem Schema folgen." | Revidiert U8; Ziel-Schema |
| U14 | Z.1414 | „Bitte prüfe, ob prod2 jetzt jobs korrekt verarbeitet" | Verifikationsauftrag |
| U15 | (Z.1454 ref.) | „Bitte dokumentiere den aktuellen Stand, du hattest oben vergessen zu dokumentieren – hast du selbst geschrieben" | Rüge/Doku-Pflicht |
| U16 | Z.1482/1726 | „**Ich gebe alle angezeigten TODO frei**, aber bitte merke dir immer vorher genau **das gesamte Ledger mit Agenten gründlich zu lesen und dann mit den Hinweisen die Details gezielt manuell zu lesen**" | **Alle Gates aufgehoben** + neuer Pflicht-Prozess (→ Memory `feedback_before_each_todo_agent_reads_full_ledger_then_manual_details`) |
| U17 | Z.1727 | „Die **runtime Profile müssen ein hybrid aus compile time und runtime** werden, um dem **Experiment Baum** zu entsprechen (Hinweis am Rande)" | Löst #31-Fork auf |
| U18 | Z.1728 | „Hinweis: die Pipeline ist rot" | Priorität |
| U19 | Z.1617 | „Bitte beschreibe mir alle jetzt noch offenen Entscheidungen und den Verlauf dieser Session seit meiner letzten Nachricht, was hast du genau unternommen und warum" | Rechenschaftsbericht |
| U20 | Z.1751 | #31+#29 → **ultracode 4-Layer-Analyse + Planmodus** (kein Ad-hoc-Bau); **#28 jetzt autonom** („weil pmc für prod1 und prod2 laufen") | Workflow-Direktive |
| U21 | Z.1822 | „bitte lies die letzte session gründlich nach, **prod2 ist jetzt stabil, wir haben ihn repariert**, bitte setze jetzt alles so, dass **prod2 vollständig geheilt** ist. Wir hatten die Maschine neu konfiguriert und **initial nur überfordert**." | Prämisse (später **widerlegt**) |
| U22 | Z.1841 | „Bitte prüfe alle shells, derzeit passiert nichts, keine neue pipeline" | Stillstands-Meldung |
| U23 | Z.1934 | „**Bitte lege eine Pause ein**" | Chunk-Ende |

**Weiterhin in Kraft (Security-Constraints, Z.1113/1729):** Cluster/Runner READ-ONLY (Freigabe U10 nur 08.07.); GitLab-API nur mit ROOTCA, nie `-k`; Tokens **nie** echoen (file-to-file); Codex nie auf Cluster/keys; AskUserQuestion NIE; Messdaten/Doku nie löschen; Remote-Repos/Branches nie löschen/anlegen ohne je-Repo-GO; golden/ABI/permutation_axes-TABU nur mit GO; thesis-Repo nur lesen; „BEP Venture UG" in Rechtstexten erhalten; buildsystem.xml hands-off; NIE `git add -A`; `Co-Authored-By` in ce/super/cluster, **nicht** thesis.

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN mit Begründung

1. **#25 Datensatz-Akten gegen preprocessed CoCo-Dateien statt Roh-Korpora** (Z.138–148). Begründung: Thesis `06_evaluation_methodology.tex:82-85` fordert das Feld **„Vorverarbeitung"** explizit → Akte gegen die lokal committete `_no_suffixes_small`-Variante ist konform, solange `preprocessing` ehrlich benennt. **Kein Fork, kein GEPARKT.** xml/sosd = honest-0.
2. **Echter CI-Regressionstest statt reiner Provenienz** (Z.162–165). Begründung: CoCo-Dateien sind **git-getrackt** (anders als gitignored `english_words/words.txt`), und `P04-CoCo-trie` ist **kein Submodul** → trotz `GIT_SUBMODULE_STRATEGY: none` im CI-Checkout vorhanden. ext/-Zugriff legitim (Datensatz lesen ≠ Code-Modul-Extraktion).
3. **Edits nur im Arbeits-Klon, Modules-Klon per ff nachziehen** (Z.198–200). Begründung: `Modules/comdare-cacheengine-all/comdare-cache-engine` (655c0314) ist **direkter Vorfahre** von `Code/external/...` (9f60216f), keine echte Divergenz → verlustfrei ff-syncbar; nur der Arbeits-Klon hat gitlab-286.
4. **KEIN 286-Namespace-Transfer research/→modules/** (Z.420–430, 473–482). Begründung wörtlich belegt: `274-MIGRATIONSPLAN:18` „**KEINE Migration: dasselbe Remote wie das Forschungsrepo (CI 286)** … Trennung Forschung↔offizielle Bibliothek bleibt explizit TODO nach Studienabschluss (#12)"; `MATRIX-GRUNDLAGEN:45` „Monolith bleibt Quelle … Mess-Pipeline 286 strikt unangetastet"; `STANDARDPROZESS:35` „ce = Framework-MODUL; die Diplomarbeit = dessen PRODUCT". Die 6 Zellen in `modules/comdare-cacheengine/` sind **Archiv-/Tombstone-Skelette** (orphan, 2–3 Commits, Header veraltet). Transfer bräche `super/.gitmodules` (relative URL) + `.gitlab-ci.yml:110-114/159`.
5. **#38 = Owner-Domäne, kein Impl-Anteil** (Z.580–586). Begründung: Voll-Audit (nicht maxdepth-3) zeigt ~250 innere Baseline-Zellen mit Alt-Matrix-CI — fast alle in `Products/comdare-db/`, `cd-buildsystem-construct/`, Firmen-Modulen. Eigene Zellen (measurement-all, Diplomarbeit) bereits schlank. Getrennte-Ledger- + buildsystem-hands-off-Direktiven verbieten Eingriff.
6. **#46 Fleet-github-Sweep NICHT als Blind-Sweep** (Z.224, 263). Begründung: ~50 Repos haben nur gitlab; github-Ergänzung erfordert **Repo-Anlage** = je-Repo-GO-TABU + berührt „GitHub flach lassen".
7. **Fleet-Remote-Konvention: `origin = gitlab`, `github = github`** (Z.220–221). Empirisch aus Referenz-Klonen bestätigt, nicht geraten.
8. **#31 F7 Planungsdoc statt Ad-hoc-Bau** (Z.783–786, 1015). 2D-Matrix existiert nicht; Ist ist **1D-Baseline-Schichtung** (metrics=b0-core → pmc=b1-instrumentation → workloads=b2-workloads, INV-2 n→n-1). Fork A (F6-compile-time-Parametrisierung, empfohlen) / B / C.
9. **#29-Rest Planungsdoc mit echtem Taxonomie-Fork** (Z.543): `anatomy_base.hpp` ordnet vector/list/deque/array unter **Sequence-Genus (Ebene 3)**, `container_framework.hpp:48` deutet „als Genus gebunden" (Ebene 2) an → Fork A (Ebene-3-Realisierung, empfohlen) vs. B.
10. **Prospektive Striktheits-Guards statt post-hoc-Doku** (Z.1185–1191, 1226). Begründung: 23 verstreute `static_assert`, aber kein zentraler Guard, kein Hot-Path-Lint. Zwei-Schichten-Architektur belegt (`anatomy_base.hpp:127-129`): compile-time `AnatomyConcept` (Hot-Path) vs. `IAnatomyBase` virtual (nur Module-Loader/ABI-Grenze). **Sauberster Weg = compile-time-Guard, der Striktheit positiv beweist** (nicht grep-Behelf).
11. **322-Infra-Memories NICHT blind übernehmen** (Z.1164, 1170–1176). 264/322 fehlten, aber domänen-gemischt (~180 reine Infra, ~60 ce-Architektur, ~15–20 Cross-Cutting). **Widerspruchs-Check:** `buildsystem_not_cmake` + `no_git_submodules` gelten für comdare-**Produkte**, NICHT für die Diplomarbeit (CMake/ctest + Submodule) → **nicht übernommen**; `no_python_in_buildchain` gilt explizit für PRT-ART → übernommen. Ergebnis: 10 Direktiven + 1 Handover-Pointer, Store 79→90.
12. **#31 Workload-Achse per `WorkloadKind`-**Reuse** statt neuem Enum** (Z.1530, 1559, 1574). Begründung: `builder/commands/workload.hpp:18-28` hat bereits `enum class WorkloadKind` → eigener `WorkloadProfile` wäre **dritter konkurrierender Enum** = Reuse-/Wildwuchs-Verstoß. **Schlüssel-Einsicht:** YCSB A–F sind in allen drei Mengen identisch → A–F-Kern ist mit jeder kanonischen Wahl konfliktfrei ⇒ **kein User-Gate nötig**.
13. **prod2-Cache-Fix als Wurzel, nicht Symptom** (Z.1307, 1327). Begründung: K87-H10 dokumentiert „OFFEN: prod2 identisch umstellen" — prod2 zeigte auf abgelöstes prod-MinIO.
14. **`concurrent` ans reale Runner-RAM-Budget koppeln, nicht ans Host-Total** (Z.1336, 1392). prod1: 1 VM (talos 40 GB) → ~20 GB Runner; prod2: 5 VMs (50 GB) → ~12 GB Runner.
15. **`COMDARE_PROD2_AVAILABLE=false` als dokumentierter Kill-Switch, kein Workaround** (Z.1769–1770). Die `.gitlab-ci.yml:100-101` schreibt ihn **wörtlich** vor; reversibel, keine echte Coverage weg (`pmc:amd`/prod1 hält PMC).

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| Paket | Commits | Verifikation (literal) |
|---|---|---|
| **#27 CI-Grün-Nachtrag** | super `924dbb3` (beide Remotes) | super 8936/8940 success, ce 8937/8942/8934/8935 success |
| **#25 6er-Kanon-Akten** | ce `1f2ad991` → cppcheck-Fix `0225396d`; super `812fe97` → `1f7976c` | ctest 3/3 PASSED; **super 8956 + ce 8954/8955 = success**; Ledger `482d34e`; Pipeline 8960 success |
| Modules-ce-Sync + Dual-Remote | ff `655c0314→1f2ad991`, origin=gitlab(286)+github gesetzt | HEADs synchron |
| prt-art-Research-Klon | github ergänzt, HEAD `faa4e76` | gitlab+github synchron |
| **Task-Konsolidierung** | super `32fe4fd` | #45/#46 neu, #32 aktualisiert, §12-Vermerk |
| **#29-Rest Doc 37** | ce `ddcc8b9a`; super `5defca0` (Bump+Ledger) | test_29 1/1 PASSED; **super 8970 + ce 8968 success** |
| **#31 F7 Doc 15** | super `8318a56` | Mojibake 0 |
| **#45 SOSD-Loader** | ce `029a3e71`; super `ef6f17b` | test_45 1/1 PASSED; ce 8978/8979/8981 + **super 8980 success** (nach 2× Retry) |
| **Übergabe 33** | super `fb15c5c` | `docs/sessions/20260708-SESSION-UEBERGABE-33-…md`; Pipeline 9011 rot (Infra) |
| **#47 Cluster-Diff** | super `53f65ea` | **Pipeline 9015 = success** |
| **#48 Memory-Konsolidierung** | 11 Memory-Dateien + MEMORY.md-Index | Store 79→90 |
| **#49 Metaprog-Guard (Tier)** | ce `5c378082`; super `16ab84d` | ctest 1/1 + Regression; **ce-push 9020 + super 9021 success** |
| **Infra-Runner-Handover** | super `81d5b79` | `docs/sessions/20260708-HANDOVER-infra-prod-runner-concurrency3-threads10.md`; Umbrella 9025 success |
| Infra-Agent-Rückmeldung | rebased auf `b30d122` → `f64a8a9` → Ledger `bcc8dcb` | kein force-push; baremetal 16/17 concurrent=3, `CMAKE_BUILD_PARALLEL_LEVEL=10` |
| **#50 Achsen-Guard (Organ)** | ce `2cb3cd34` | ctest 1/1; ce-9033 success |
| **#52 prod2-Infra-Fix** | Cluster `68f8e5b` → `568edcc` (K89d); super `8bacc3f`, `821a7ee` | Round-Trip **PUT=200/GET=200/DELETE=204**; **Umbrella 9043 success**; prod2-Job 241734 success |
| **#50-Rest POD-Guard** | ce `60a710a9`; super `2882020` | ctest 3/3 PASSED (12 ABI-Transport-PODs) |
| #31-Schritt-1 (Fehlversuch) | ce `bde1252e` → **Revert `7c8692bd`**; super `43aa364`, `aaeeb8b` | ctest 4/4 war grün, aber Reuse-Verstoß |
| **#31-Schritt-1 (korrekt)** | ce `88738285`; super `a2dce21`, `6cb6fb6` | ctest 4/4 PASSED, `WorkloadKind`-Reuse |
| **#31-Schritt-1b (2D-Matrix)** | ce `4d8aedce`; super `434bfe0`, `e9b9aa9` | ctest 4/4; **`matrix_cell_count == 36`** (6 Workloads × 6 Datasets) |
| **prod2-Kill-Switch + Härtung** | ce `3fb7dea8`; super `fbe3f65` | **Pipeline 9093 (main) = success** literal; super 9095 success |
| Reaktivierungs-Versuch + Rücknahme | Variable `true` → Probe 9099 → **zurück auf `false`**, 9099 gecancelt | kein Commit; Beweis fehlgeschlagen |

**Neue Tasks angelegt:** #45 (sosd-Loader), #46 (Fleet-github-Sweep), #47 (Cluster-Diff), #48 (Memory-Konsolidierung), #49/#50 (Striktheits-Guards), #51 (Infra-Rückmeldung), #52 (prod2-Fix).

---

## (d) FEHLER + FIXES

1. **cppcheck `uninitMemberVarNoCtor`** (ce 8948, Z.244–247): `KanonCase::checksum/line_count` ohne Initializer; CI wertet Warnings hart. **Fix:** `{}`-Default-Init → ce `0225396d`.
2. **Cancel-URL falsch** (Z.251): fehlendes `/pipelines/` im API-Pfad. Korrigiert nachgeholt.
3. **g++-13-ICE Segfault, Cold-Cache** (ce 8981, Z.858–859): NICHT Code — identischer Commit `029a3e71` in ce 8978/8979 grün. 1× Retry (Job 241307) → success.
4. **g++-16-ICE in prt-art 8982** (Z.895): #45 berührte prt-art nicht. 1× Retry → success → super 8980 recalc = success.
5. **Pipeline 9011 (docs-only) rot mit wechselnden Downstreams** (Z.953, 977): definitiver Beweis der transienten Runner-ICE-Episode. 1× Retry failed → als Historie belassen (Präzedenz 8775). Memory `reference_ci_runner_ice_cold_cache_instability` angelegt.
6. **„Mojibake"-False-Positive im Ledger** (Z.914): Z.504/518 enthalten das grep-Pattern `Ã|â€` **literal als Kadenz-Regel**.
7. **super non-fast-forward Push** (Z.1278–1281): origin/main voraus durch Infra-Agent-Commit `b30d122`. **Kein force-push** → sauber rebased.
8. **RAM-mit-Disk-Verwechslung des Infra-Agenten** (Z.1302, 1331): „prod1 ~157 GB frei" war **Disk**; beide Hosts ~60/62 GB RAM.
9. **prod2 36 % Job-Fehlerrate** (vs. prod1 11 %) (Z.1300, 1356–1362): `[runners.cache.s3]` = `minio.prod.comdare.de`/`gitlab-runner-cache` (löst auf 10.0.10.1 = V10-VIP **ohne** :9000-FE = toter Endpoint), kein `/etc/hosts`-Pin, kein CA-Bundle. **Fix:** dev-MinIO (`minio.comdare.de:9000`, Bucket `buildsystem-cache`, V60-Pin `10.0.60.1`), Secret **file-to-file** von prod1 (nie in Output), Backup + SIGHUP + `gitlab-runner verify = is valid`, Round-Trip 200/200/204.
10. **Falsche SIGHUP-Annahme** (Z.1423 → korrigiert Z.1435): zunächst vermutet, SIGHUP lade `[[runners]]` nicht — Job 241705 lief aber **vor** dem Reload; Job 241734 (19:43) belegte dev-MinIO-Nutzung. Kein Neustart nötig.
11. **`'mp11' is not a namespace-name` / `'boost' has not been declared`** (Z.1486–1490): zunächst als latenter Include-Bug gedeutet — **falsch**; Header hat `#include <boost/mp11.hpp>` (Z.25), gleicher SHA war grün, lokal grün ⇒ Cold-Build-ICE-Folgesymptom. 1× Retry → ce-9048 + prt-9050 success.
12. **#31 Reuse-Verstoß (schwerste Selbst-Korrektur)** (Z.1529–1531, 1542): Header mit neuem `WorkloadProfile`-Enum **parallel** zum Ledger-Agenten gebaut; Agent fand danach `WorkloadKind`. **Revertiert** statt geflickt (Duplikat stehenlassen = Quick-Fix). **Prozess-Lehre:** Ledger-Agent **vor** dem Bau abwarten, nicht parallel (Memory verschärft).
13. **„TABU"-grep-False-Positive** (Z.1497): matchte „pod" im Dateinamen `test_striktheit_abi_pod_guard.cpp`.
14. **9 h roter Stand — Fehldiagnose „transient" korrigiert** (Z.1750, 1758–1764): `pmc:intel` auf prod2 hängt **60 min im `cmake -B build` vor der Compiler-ID** → Runner-Timeout, null cmake-Output. **Beweis Infra-nicht-Code:** derselbe SHA `4d8aedce` lief 20:36 grün in 28 s, ab 21:53 tot bei identischem Runner; `pmc:amd`/prod1 grün mit identischem Template. **Fix:** dokumentierter Kill-Switch `COMDARE_PROD2_AVAILABLE=false` + `.pmc timeout:15m` (fail-fast statt 60 min) → **Pipeline 9093 success**.
15. **Verfrühte prod2-Reaktivierung** (Z.1830–1900): Variable auf `true`, Probe 9099 → `pmc:intel` blieb 22 min `pending`. Ursache-Kette: Runner 17 online/korrekt getaggt/nicht pausiert, aber **beide concurrency-Slots belegt** durch `sanitize:asan-ubsan` (242330) + `contract` (242332) aus paralleler development-Pipeline 9094. **Kritischer Befund:** diese beiden hingen selbst seit **39 min** im `cmake -B build-san` — Log endet bei diesem Befehl, kein Output. ⇒ Der configure-Hang betrifft **jeden** cmake-configure auf prod2, nicht nur `pmc:intel`. **Sofortmaßnahme:** Variable zurück auf `false`, 9099 gecancelt.
16. **Prozess-Fehler des Agenten (selbst benannt):** Verschiebung statt Ausführung („nächster Zyklus") wurde vom Stop-Hook mehrfach gerügt (Z.521, 607, 974, 995, 1056, 1479, 1519, 1558, 1588, 1655, 1924) — jedes Mal führte die Rüge zu einem tatsächlich non-gated Slice, den der Agent übersehen hatte.

---

## (e) OFFENE FÄDEN AM CHUNK-ENDE

**AKUT — unbeantwortete Entscheidungsfrage an den User (Z.1922):**
> „Soll ich **(a)** den prod2-Runner (id=17) pausieren + die hängende 9094 canceln (sofortige Entlastung, sauberer Zustand bis zum Node-Fix), oder **(b)** nur dokumentieren und dir/Infra die Runner-Aktion überlassen?"

Danach: Stop-Hook-Rüge (Z.1924), zwei User-Interrupts, `baxb4vh7o`-Poller-Notification, dann **„Bitte lege eine Pause ein"** (Z.1934) und `/model`. Kein Abschluss.

**Infra offen:**
- **prod2 ist NICHT geheilt** — User-Prämisse U21 widerlegt. Hang trifft jeden `cmake -B build` auf prod2 (Hypothese: stale Mount nach MinIO-prod→dev-Swap / Node-Blockade; überlebt reine Neukonfiguration).
- `sanitize`/`contract` landen **ungegatet** auf prod2 → jede Pipeline mit prod2-gescheduleten generischen Jobs blockiert. Repo-seitig nicht sauber lösbar.
- Empfohlene Node-Diagnose (Infra): `cmake -B build` in ce-Checkout, `mount`/`df` (alte prod-MinIO/S3-Mounts), `dmesg` nach I/O-Hängern.
- Hängende development-Pipeline 9094 nicht abgeräumt.
- **Strukturelle Beobachtung:** generische Jobs belegen den kostbaren bare-metal-prod2, der der echten PMU-Messung vorbehalten sein sollte (Tag-/Scheduling-Thema, fürs Handover vermerkt).
- Runner-Schema `concurrent=2 / -j8` noch offen für: Win2022-VM (id 18), Win11-VM (id 19, RDP nötig), Talos/k8s (id 14/15, kubectl via node7) + #21/H15-k8s-Cache-Lücke.
- Langfrist: prod1→prod2-VM-Angleichung (Win/samba/opn-VMs auf prod1, talos-prod1 40→18 GB).

**Diplomarbeit offen (alle per U16 freigegeben, aber teils gated):**
- **#31-Schritt-2 (Extras-Vereinheitlichung)** — echter Design-Fork, Frage steht: `WorkloadKind` Custom_HotKey/RangeDelete/BulkInsert vs. `profile_by_name` IH/LH vs. F7-Dataset-Kreuz. **Empfehlung des Agenten:** WorkloadKind als Basis + IH/LH ergänzen. Per U20 → ultracode-4-Layer + Planmodus, frischer Kontext.
- **Kategorie-Achse M** (`MeasurementCategory`, 16 Werte, `comdare::cache_engine::measurement`, Reuse-Check sauber, **keine** bestehende observer-vs-PMC-Regime-Klassifikation) — Ad-hoc-Bau **gestoppt** (Z.1751/1795), gehört in die geplante #31-Analyse.
- **#29-Realisierung** — Genus→Typ-Umbau, golden/ABI-tief, braucht fresh-context + Doppel-Review + ABI-GO.
- **#28 (#270a) P/E-Core-Auto** — Code baubar, aber Verifikation braucht **echte Intel-Hybrid-Hardware = prod2** (prod1 ist AMD). Ohne Hardware-Beleg wäre es Raten.
- **#13/#270b** (node7-arm64: Runner online, aber Job-Annahme = node7-Freeze K87b), **#20** (gcc-15.3-Installation), **#276/#14** (Voll-Matrix, ausdrücklich zuletzt), **#21/#23/#36/#40** (Infra-Agent), **#32-Rest/#38** (Owner-/Firmen-Domäne), **#46** (je-Repo-GO), **#156/#215/#216** (golden-320-HELD).

**Zuletzt bekannte Stände:** ce `3fb7dea8` (main+dev), super `fbe3f65`, Modules-ce synchron, Cluster `568edcc`; `COMDARE_PROD2_AVAILABLE=false`; Memory-Store ≥91 Dateien.