# SYNTHESE — CI-ZIELBILD UND BLOCKER-LISTE

**Stand 11.08.2026.** Vorlage: 30 gepruefte Aussagen (28 bestaetigt, 2 gefallen), davon 11 mit Blocker-Flag.

**Beleglage.** Von den 28 bestaetigten Aussagen habe ich 13 selbst am Objekt nachgemessen (Zeilenzahlen, Stufenliste, trigger-Keys, Bau-Jobs, Bump-Wachen-Deckung, Shell-Bestand, main-Divergenz, Gitlink, Verdrahtung des Baum-Writers). Eine davon musste ich korrigieren (K-1). Die uebrigen 15 — insbesondere alle Rohtranskript- und Owner-Zitat-Aussagen sowie die C++-Kommentar-Zitate aus ce-Headern — stehen hier **aus Bericht, nicht nachgemessen**. Ich habe die .jsonl-Korpora nicht selbst geoeffnet.

---

## TEIL 1 — DAS CI-ZIELBILD

### 1.1 Die Quelle

Ein einziger Owner-Satz traegt das gesamte Zielbild: `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:42298`, `type=user`, `role=user`, Klartext ohne Tool-Umweg, 2026-08-11T18:03:24.322Z. *(Fundstelle aus Bericht.)*

> "Alles korrekt, wenn du bitte noch einen Explore zur CI startest, findest du auch die Stelle, wo ich explizit sagte, dass jede Träger-Stufe unbedingt als eigene mini Pipeline innerhalb der Haupt-Pipeline gebaut und getestet werden muss, also ein eigenes binary mit eigenen Bedürfnissen ist, und dass aber dieses binary (da alle Binaries im System von jeder Träger-Stufe Stempel tragen) im Cache hinterlegt wird und nur neu gebaut werden soll, wenn es sich ändert. Damit wird bei Implementierung ein update von X.Y.Z Version im Stempel pflicht, sodass das Binary überhaupt neu gebaut wird. Aber final ist die Kette durch caching schneller."

> "Die Träger Binaries werden auch an der Wurzel des Buildsystem caches (bereits auf NAS aufgebaut) gespeichert und wenn sie Gattung und Genus haben, unter weiteren Kategorien ins Lager einsortiert. Die CI Struktur als Gerüst, um überhaupt alles zu bauen und die offenen Aufgaben und liegen gebliebenes aus dem letzten Kontex (explore), sind noch nicht fertig und daher gibt es harte blocker um das System bauen und warten zu können."

Der Owner verweist auf eine **fruehere** eigene Aussage. Diese fruehere Stelle ist **UNBELEGT** — Nichtfund mit Gegenprobe ueber 19 .jsonl-Dateien, den 20.430-Zeilen-Ledger, `docs/plaene`, `docs/sessions` und das memory-Verzeichnis. Die einzige woertliche Fassung ist der Satz vom 11.08. selbst. Das widerlegt das Owner-Gedaechtnis nicht, es heisst nur: es gibt keinen zweiten Beleg zum Abgleichen. *(Aus Bericht.)*

### 1.2 Das SOLL, sieben Zusagen

| # | Zusage | Quelle |
|---|---|---|
| S1 | Je Traeger-Stufe **eine eigene Mini-Pipeline INNERHALB der Haupt-Pipeline** | Owner-Wort |
| S2 | Je Traeger **ein eigenes Binary mit eigenen Beduerfnissen** | Owner-Wort |
| S3 | Je Traeger **gebaut UND getestet** | Owner-Wort |
| S4 | Binary im Cache hinterlegt, **Neubau nur bei Aenderung** | Owner-Wort |
| S5 | Deshalb **X.Y.Z-Bump im Stempel PFLICHT** bei Implementierungsaenderung | Owner-Wort |
| S6 | Ablage: **Wurzel des Buildsystem-Caches (NAS) fuer alle Traeger**; zusaetzlich **Lager**, aber nur bei Gattung UND Genus | Owner-Wort |
| S7 | Ziel: **die Kette ist final durch Caching schneller** | Owner-Wort |

### 1.3 Das IST je Traeger — 0 von 4 erfuellt

| Traeger | Eigener Bau-Job | Eigener Test-Job | Eigener Cache-Schluessel | Praesenz in der CI |
|---|---|---|---|---|
| **Planer** | nein | nein | nein | 1 trigger-Kante (`planer:delegate-trigger`, super:2690-2727, Stufe `planer`) — sie triggert eine **zur Laufzeit emittierte Kind-Pipeline**, nicht den Bau des Planer-Binaries |
| **CEB** | nein | nein | nein | nur als STUFE-1 der emittierten Kind-Pipeline (super:2686-2688, Kommentar) |
| **Tier** | nein | nein | nein | nur als STUFE-2 = Enkel-Pipeline (super:2687-2688, Kommentar) |
| **Hybrid** | nein | nein | nein | **existiert ueberhaupt nicht** — `grep -ic hybrid` = 0 in super/.gitlab-ci.yml UND 0 in ce/.gitlab-ci.yml (selbst gemessen); 0 im YAML-erzeugenden C++ (aus Bericht) |

**Statische Bau-Jobs gesamt (selbst gemessen):** super genau 1 — `build:clang` (super:252), Sammel-Target `comdare_da_tools` (super:287). ce zwei — `build:clang` (ce:158, Target `comdare_tests` ce:171) und `build:arm64-smoke` (ce:253, Stufe `test`, `allow_failure: true`, var-gated ueber `COMDARE_ISA_MATRIX`). Es gibt **keinen** `build:gcc` in super.

**Die 4 echten `trigger:`-Kanten in super (selbst gemessen, Zeilen 1257/1275/1293/2720):** 3 gehen an Submodul-**Repos** (cache-engine, prt-art, thesis) als Downstream-Multi-Project-Pipelines. 1 geht an die Planer-Delegation. **0 von 4 triggern einen Traeger als Bau-Gegenstand.** ce hat 0 echte `trigger:`-Keys (rc=1) und 0 `strategy:`-Keys — die gesamte Kind-Pipeline-Mechanik liegt in super.

**Zahlen zur Ist-Struktur (selbst gemessen):** super 2768 Zeilen, 57 Top-Level-Schluessel → 45 Jobs, 11 Stufen (`lint, orchestrate, submodules, analyse, test, integration, planer, manifest, thesis-pdf, measure, persist`). ce 1056 Zeilen, 33 Top-Level-Schluessel → 25 Jobs, 6 Stufen. Keine Stufe und kein Job heisst `ceb`, `tier`, `hybrid` oder `release`.

### 1.4 Die Soll-Ist-Luecke in einem Satz

Vier Traeger, vier geforderte Mini-Pipelines, **0 gebaut**. Das eingecheckte CI baut **1 Sammel-Target je Repo** und delegiert die Traeger-Ebenen an eine zur Laufzeit emittierte, nicht eingecheckte Kind-/Enkel-Pipeline, die keinen der vier Traeger als eigenstaendig gebautes und getestetes Binary behandelt.

### 1.5 OFFEN — wo die Quellen schweigen

- **O-1** Ob "Mini-Pipeline" eine GitLab-Child-Pipeline oder eine Job-Gruppe innerhalb einer Stufe meint. "innerhalb der Haupt-Pipeline" schliesst eine eigenstaendige Downstream-Pipeline eher aus, entscheidet aber nicht zwischen den beiden verbleibenden Bauarten. Keine Quelle.
- **O-2** Wo der Hybrid in der Verschachtelung sitzt. Das Nesting-Budget ist ausgeschoepft (siehe B-2). Keine Quelle.
- **O-3** Ob die vier Mini-Pipelines **statisch eingecheckt** oder **vom Planer emittiert** sein sollen. Die heutige Architektur emittiert; der Owner-Satz sagt nur "innerhalb der Haupt-Pipeline gebaut und getestet". Keine Quelle.
- **O-4** Was "eigene Beduerfnisse" konkret bedeutet: Runner-Tags, Toolchain, Sanitizer-Profil, Test-Suite? Keine Quelle.
- **O-5** Ob die Mini-Pipeline je Traeger-**TYP** (4 Stueck) oder je Traeger-**INSTANZ** (n Tier-Binaries) gilt. "je Traeger-Stufe" deutet auf Typ. Keine explizite Quelle.
- **O-6** Die vom Owner referenzierte fruehere Stelle. Nichtfund mit Gegenprobe.

---

## TEIL 2 — DIE CACHE-KOPPLUNG

### 2.1 Wie das System heute entscheidet

Die **einzige** Neubau-Entscheidung im Bau-Orchestrator ist `dll_is_current` (`ce/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp`, Definition + 2 Ueberladungen + 1 Aufrufstelle Z.798; 8 Fundstellen, keine zweite Stelle daneben). Verglichen wird **nicht der Quellcode**, sondern das gerenderte **Stempel-Preimage**: 9 Glieder (`kAnatomyFingerprintGliedCount=9`, `anatomy_fingerprint.hpp:416`, `static_assert` Z.641) = 8 feste Glieder plus BVSET-Glied [6]. Fail-closed in vier Zweifelsfaellen: leere Erwartung, fehlende DLL, fehlendes/leeres Sidecar, Nicht-128-Hex-Form (Z.300-305 / 417-421). *(Alles aus Bericht.)*

**Wichtige Korrektur, die die Vorlage selbst schon traegt:** Der oft zitierte Satz "genau dann aktuell, wenn ihr `.fingerprint`-Sidecar byte-gleich dem erwarteten CT-Fingerprint ist" (build_orchestrator.hpp:296-298) ist seit Commit `363f0022` (11.08. 09:05, Task #59) **HISTORIK** — der Widerruf steht im selben Kommentarblock, Z.369-372. Glied [6] vergleicht heute **Teilmenge statt Gleichheit** (`bvset_ist_teilmenge`, Aufruf Z.444, Bindungs-Neuberechnung Z.451). Der Test `K1ErweiterungSkiptRecordedIstTeilmengeVonCurrent` (`tests/unit/test_a2_sha512_skip_gate.cpp:513-535`) konstruiert per `ASSERT_NE` ausdruecklich einen ungleichen Hash und erwartet trotzdem `EXPECT_TRUE(dll_is_current(...))`. Byte-Gleichheit gilt nur noch im Teilmengen-Pfad-AUS-Fall (2-Arg-Ueberladung Z.457-459). Das deckt sich mit dem Kanon "Hardware-Erweiterung ist additiv".

### 2.2 Was daran fehlt

Der Owner koppelt drei Dinge. Der Status je Kopplung:

| Kopplung | Status | Beleg |
|---|---|---|
| (a) Neubau-Entscheidung haengt am Fingerprint | **GEBAUT** | `dll_is_current` |
| (b) Stempel = Skip-Marke = minio-Key = Bestandslog-`key_sha512` = Baum-Blatt, **dasselbe Preimage** | **GEBAUT**, an 3 Stellen woertlich | `lager_baum_writer.hpp:50-51`, `build_orchestrator.hpp:307-310`, `lager_pfad_grammatik.hpp:15` |
| (c) Stempel = Schluessel des **BUILDSYSTEM-CACHES** (die Wurzel, NAS) | **NICHT GEBAUT** | siehe 2.5; eigene Gegenprobe: 0 Treffer `comdare-buildsystem` in ce/libs+ce/apps |
| (d) X.Y.Z-Bump-**PFLICHT** als erzwungene Regel | **6 von 136 Dateien** | siehe 2.3 |

Punkt (c) ist die einzige der fuenf Owner-Rollen des Stempels ohne Objektbeleg — das sagt die Owner-nahe Quelle zweimal selbst (Ledger KON9-11:535-537 und das spaetere KON10-03:94-96, beide 11.08.: *"Der Beleg ist ein PLAN-Beleg, kein Code-Beleg: entworfen ja, gebaut nein"*).

### 2.3 Die Wache fuer "Aenderung ohne Bump" — sie existiert, sie ist zu schmal

**Sie existiert.** `contract:axis-version-lock` (ce/.gitlab-ci.yml:768-786), **kein `rules:`** — also unbedingt, ein hartes Gate. Werkzeug: `tools/axis_version_lock/axis_version_lock.cpp:172-185` (`do_check`). Prinzip: SHA-256 ueber die **Rohbytes** der Quelldatei gegen einen committeten Lockwert; ein geaenderter Digest ist nur legitim, wenn der `AXIS_ALGO_VERSION`-Marker in derselben Datei echt hochgezaehlt wurde. Das ist ein **Content-Digest-Tripwire**, nicht ein String-Pin — die richtige Bauart.

**Ihre Deckung, von mir selbst nachgemessen:**

| Messung | Ergebnis |
|---|---|
| `axis_version.lock` | 9 Zeilen = 3 Kopfzeilen + **6 Eintraege**, alle unter `libs/cache_engine/heuristik/` |
| `algo_version`-Traeger unter `libs/cache_engine/axes/` | **130 Dateien** |
| davon unter `axes/alloc/` | **27** |
| `AXIS_ALGO_VERSION`-Marker unter `axes/` | **0** (`grep -rl`, null Treffer) |
| `algo_version\|axis_version_lock` in super/.gitlab-ci.yml | **0** (rc=1) |

Die Wache riegelt **6 Heuristik-Dateien**. Sie riegelt **0 von 130 Achsen-Varianten-Headern** — nicht weil sie ausgeschaltet waere, sondern weil dort **ihr eigener Marker fehlt**.

**Zwei Wachen, zwei Deckungen — ich nenne sie getrennt statt sie zu einer Zahl zu glaetten:**
- `axis-version-lock` (CI-Gate, Digest): **6 von 136** bump-pflichtigen Dateien (130 unter `axes/` + 6 unter `heuristik/`), davon **0 unter `axes/`**.
- A1-Pin (Unit-Test `test_a1_algo_version_pin_alloc_axis.cpp`): **1 von 18** Organ-Achsen (alloc).

**Ergebnis fuer die Fehlerklasse:** Fuer **103 von 130** `algo_version`-Dateien unter `axes/` faengt **NICHTS** die Klasse "Aenderung ohne Bump". Fuer die **27** unter `alloc/` nur ein Unit-Test, kein Digest-Gate. Gegenprobe zur Vollstaendigkeit: `*_pin_*`/`*version_lock*` im gesamten ce-Baum = genau 3 Fundstellen, keine weitere pro Achse, keine generische Vorlage. In super existiert **keine** Entsprechung.

**Und selbst wo die Wache greift, faengt sie nicht alles:** Der Digest-Tripwire haengt an der Datei, nicht am Fingerprint. Eine Wache, die prueft, ob **jede** Aenderung an einer traeger-relevanten Quelldatei eine **Fingerprint-Bewegung** nach sich zieht, existiert nicht (Nichtfund mit Gegenprobe: kein zweites Gate). Das ist der Kern der Fehlerklasse: der Fingerprint speist sich aus dem **gerenderten Stempel**, nicht aus Quellcode-Hashes — ein Algorithmus-Edit ohne Bump aendert den Fingerprint **per Konstruktion nicht**, das Binary wird regelkonform geskippt und ist trotzdem inhaltlich falsch.

**Nicht auffindbar:** eine Owner- oder Plan-Stelle, die begruendet, **warum** `axis-version-lock` bewusst auf die 6 Heuristik-Dateien beschraenkt wurde. Das Ledger fuehrt dieselbe Frage selbst als offen (KON2-19: "NICHT AUFFINDBAR").

### 2.4 Die zwei Ablagen, getrennt

**WURZEL des Buildsystem-Caches — alle vier Traeger, kein Gattung/Genus noetig**

- SOLL: "an der Wurzel des Buildsystem caches (bereits auf NAS aufgebaut) gespeichert" — Owner-Wort.
- IST: **kein Code-Pfad.** `comdare-buildsystem` in ce/libs+ce/apps = **0 Treffer** (selbst gemessen). `COMDARE_CACHE_ROOT` und `COMDARE_MEASUREMENT_NFS_ROOT` (die Namen aus dem 18.07.-Plandossier BAUPLAN-TWO-CACHE-STORAGE) = 0 Treffer in beiden CI-Dateien und im ce-Quellcode (aus Bericht). Der Mount `/mnt/comdare-buildsystem` existiert infrastrukturell auf prod1 (live gemessen 08.08., aus Bericht), ist im C++ **nirgends** referenziert. `comdare.buildsystem` (case-insensitiv) in beiden .gitlab-ci.yml = 0 Treffer.
- **WIDERSPRUCH, im Korpus nirgends aufgeloest:** "Buildsystem-Cache" ist im System woertlich ein **MinIO-Bucket-Name** (`buildsystem-cache`, dev-MinIO V90, Longhorn-PVC) — Ledger 18698-18699, 07.08. Der Owner sagt "bereits auf **NAS** aufgebaut". Der live genutzte NAS-Unterordner heisst `Cluster_NFS/cache-engine-experiment/`. Entweder meint die Owner-Klammer den MinIO-Dienst (der auf dem NAS-Blech laeuft), oder es sind zwei verschiedene Ablagen. **Keine Quelle entscheidet.** Das ist die erste Frage an den Owner.

**LAGER — nur mit Gattung UND Genus, unter weiteren Kategorien**

- SOLL: "und wenn sie Gattung und Genus haben, unter weiteren Kategorien ins Lager einsortiert" — Owner-Wort.
- IST der Grammatik (aus Bericht, Zeilenangaben nicht von mir nachgelesen):
  - **Zwei Kaskaden** (Kanon D-12): Messdaten `MESS→SYSTEM→ORGAN`, Binaries `SYSTEM→ORGAN→MESS`.
  - Ebenen 1-3 gemeinsam seit K1 (Owner-Entscheid 09.08.): `gattung`, `genus`, `realm ∈ {binaries, messdaten}` — `lager_baum_writer.hpp:14-16`.
  - Binaries-Zweig weiter: System-Achse → fuenf Organ-Gruppen-Ordner (`01_read_path`, `02_layout`, `03_placement`, `04_execution`, `05_write_path_io`; `lager_baum_writer.hpp:393-394`) → Mess-Typ als tiefste Ebene.
  - Messdaten-Zweig zusaetzlich: Blatt-Segment mit dem 128-Hex-Fingerprint.
  - Die **CEB ist NICHT genus-los**: `ceb_blatt_ebenen()` durchlaeuft dieselben `wurzel_ebenen()` (ABNAHME-5, `lager_baum_writer.hpp:760-764`). Genus-los ist im ganzen Baum-Writer **nur der PLANER**.
  - `LagerWurzelPaar() = delete` (Z.320-331): es gibt strukturell **keinen** Lager-Pfad ohne Gattung+Genus, und keinen dritten Spec-Typ neben `BinariesBaumSpec`/`MessdatenBaumSpec`.

**Ich deute den Vorlage-Befund hier ausdruecklich um.** Die Vorlage fuehrt "kein Lager-Pfad ohne Gattung+Genus" als Blocker. Als **Lager-Regel** ist das aber genau owner-konform: der Planer ist der einzige genus-lose Traeger, er gehoert per Owner-Satz **nicht ins Lager, sondern nur an die Wurzel**. Der Blocker liegt nicht im Lager — er liegt darin, dass die Wurzel ungebaut ist.

**Aber die Lager-Schicht ist auch dort, wo sie richtig gebaut ist, nicht angeschlossen** (selbst gemessen): `LagerBaumWriter` kommt in ce/libs + ce/apps in **genau 1 Datei** vor — seiner eigenen (`lager_baum_writer.hpp`). `::kaskade(`-Aufrufe ausserhalb: **0**. Ergaenzend aus Bericht: 0 `.aufloesen(`-Aufrufe, 0 `nas_wurzel =`-Zuweisungen ausserhalb `tests/`. **Abgrenzende Gegenprobe:** `make_bestand_transport` **ist** verdrahtet (3 Fundstellen, u.a. `apps/experiment_planner/main.cpp`) — die Schluessel-Schicht lebt, die Baum-Schicht nicht. Dazu: `COMDARE_BESTANDSLOG` wird in super **16x gelesen/benannt, 0x per Default gesetzt** (aus Bericht).

---

## TEIL 3 — DIE HARTEN BLOCKER

**Nenner: 11 blocker-markierte Kandidaten von 28 bestaetigten Aussagen; 30 Aussagen insgesamt geprueft (28 bestaetigt + 2 gefallen).** Aufteilung: BAU **6 von 11**, WARTUNG **3 von 11** primaer (+1 sekundaer), MESSUNG **0 von 11** primaer (3 sekundaer), ABGABE **2 von 11**. Summe 11.

### BAU — 6 von 11

**B-1 — Kein Traeger hat eine eigene Mini-Pipeline. 0 von 4.**
Wo: super/.gitlab-ci.yml:252 (einziger Bau-Job), :287 (Sammel-Target), :1257/:1275/:1293/:2720 (die 4 trigger-Kanten); ce/.gitlab-ci.yml:158/:253.
Seit: der Auftrag ist vom 11.08. 18:03 UTC; die fruehere Owner-Stelle bleibt unbelegt.
Loest auf: vier Job-Gruppen bauen (je Traeger `build` + `test` + ein aus dem Stempel abgeleiteter Cache-Schluessel). **Vorher O-1 und O-3 vom Owner klaeren** — Child-Pipeline oder Job-Gruppe, statisch oder emittiert.

**B-2 — Das Nesting-Budget ist ausgeschoepft.**
Wo: super/.gitlab-ci.yml:2686-2688 — der Kommentar nennt die Grenze selbst: *"parent->child->grandchild = GitLab-Nesting-Tiefe 2"*. Drei der vier Traeger belegen die drei Ebenen (Haupt/Planer-Delegation → STUFE-1 CEB → STUFE-2 Tier).
Ob der Hybrid eine vierte Ebene braeuchte: **OFFEN** — 0 Treffer `hybrid` in beiden CI-Dateien (selbst gemessen), 0 im YAML-erzeugenden C++ (aus Bericht). Die Ausschoepfung ist gemessen; die Folge fuer den Hybrid ist **meine Ableitung, kein Quellensatz.**
Seit: mit der W10-B-Architektur.
Loest auf: Hybrid auf eine bestehende Ebene legen, oder die Emission flach ziehen, oder Owner-Entscheid.

**B-3 — PHASE 0 offen: zweite Enumerations-Engine im super-Repo.**
Wo: `/home/comdare/wt-super-landung/Code/02_messung_driver/v32_messreihe_antrieb.hpp:268` (Umgebung 226-300) — nennt sich selbst *"der OFFIZIELLE Einstieg"* (`execute_messreihe` → `run_experiment_profile`), waehrend der geplante `ExperimentPlanDirector` unangeschlossen im ce-Submodul liegt (`profile_facade/planner/experiment_plan_director.hpp`).
Seit: **19.07.2026**.
Loest auf: PHASE 0 fahren (super auf den `ExperimentPlanDirector` reconcilen) — **vor** jedem Bau am Planer-Kopf, sonst entsteht laut dem Entwurf selbst eine **dritte** Engine. *(Aus Bericht, von mir nicht nachgelesen.)*

**B-4 — Die Wurzel des Buildsystem-Caches hat kein Ziel im Code.**
Wo: 0 Treffer `comdare-buildsystem` in ce/libs+ce/apps (selbst gemessen); Widerspruch MinIO-Bucket vs. NAS: Ledger 18698-18699 (07.08.).
Seit: mindestens 18.07. (BAUPLAN-TWO-CACHE-STORAGE, dessen Env-Var-Namen nie angelegt wurden).
Loest auf: Owner-Klaerung "NAS-Ordner oder MinIO-Bucket", dann eine Ziel-Aufloesung bauen **und verdrahten**. Ohne B-4 hat der genus-lose Planer ueberhaupt kein Ablageziel.

**B-5 — Die Lager-Baum-Schicht ist gebaut, aber nirgends aufgerufen.**
Wo: `LagerBaumWriter` in ce/libs+ce/apps in genau 1 Datei = seiner eigenen; `::kaskade(`-Aufrufe ausserhalb = 0 (beides selbst gemessen). Kein Spec-Typ fuer den genus-losen Planer: `lager_baum_writer.hpp:320-331`, `LagerWurzelPaar() = delete`.
Seit: die Schicht selbst ist jung (K1 = 09.08.); die Verdrahtung fehlte nie und wurde nie gelegt.
Loest auf: den Writer im Bau-Orchestrator bzw. im Planer-Kopf aufrufen. Der fehlende Planer-Spec ist **kein Defekt** (owner-konform, siehe 2.4) — er setzt B-4 voraus.

**B-6 — Owner-Wort als Dach.**
> "Die CI Struktur als Gerüst, um überhaupt alles zu bauen und die offenen Aufgaben und liegen gebliebenes aus dem letzten Kontex (explore), sind noch nicht fertig und daher gibt es harte blocker um das System bauen und warten zu können."

Das ist kein abgeleiteter, sondern der **festgestellte** Blocker, und er trifft BAU und WARTUNG gleichzeitig. Loest auf: B-1..B-5 plus W-1..W-3.

### WARTUNG — 3 von 11 primaer, +1 sekundaer (B-6)

**W-1 — Bump-Erzwingung deckt 6 von 136 bump-pflichtigen Dateien; 0 davon unter `axes/`.**
Wo: ce/.gitlab-ci.yml:768-786; `tools/axis_version_lock/axis_version_lock.cpp:172-185`; `tools/axis_version_lock/axis_version.lock` (6 Eintraege). Alle Zahlen selbst nachgemessen.
Seit: die Wache ist als PAKET W3-C angelegt (Lock-Kopfzeile nennt GN-8/O-4, Ledger Sec.32-F4) und wurde nie ueber die Heuristik hinaus ausgerollt. Warum: **nicht auffindbar**.
Loest auf: `AXIS_ALGO_VERSION`-Marker in die 130 `axes/`-Header setzen und die Lock-Datei fuellen — oder die Wache generisch ueber alle `algo_version`-Traeger fahren. Das ist die Wache, die S5 (Bump-Pflicht) ueberhaupt erst durchsetzbar macht.

**W-2 — #89: der Shell-Bestand waechst gegen die Doktrin.**
Wo: `/home/comdare/wt-super-landung/ci/tests/*.sh` = **14 Dateien, 8528 Zeilen** (selbst gemessen 11.08.), gegen den zuletzt dokumentierten Stand 13/7967. Zuletzt hinzugekommen: `anhang_snapshot_einbuchen_probe.sh` (11.08.).
Owner-Wort (09.08.): *"Ich sehe einen Haufen shells statt vernuenftiger google tests, was soll das? … SKRIPTE SAGEN GAR NICHTS."*
Seit: die Ruege ist vom 09.08., der Bestand aelter; die Zahl ist seither **gewachsen, nicht geschrumpft**.
Loest auf: Ueberfuehrung nach Google Test (Debug UND Release), Neuzugaenge sofort als GTest.

**W-3 — #82: das Sicherheitsnetz des Skip-Gates hat auf 2 von 3 Achsen ein Loch.**
Wo: `/home/comdare/wt-ce-warn-libs/tests/unit/test_bvset_teilmenge.cpp:72-73` — die Testdatei sagt es ueber sich selbst: *"page/hw bleiben konstant -- die Richtung wird an EINER Achse gezeigt"*. Die Produktionsfunktion `bvset_teilmenge.hpp:165-185` iteriert korrekt ueber alle 3 Achsen.
**Verschaerfung (meine Verknuepfung zweier Vorlage-Befunde, kein Quellensatz):** seit Task #59 (11.08. 09:05) ist genau dieses Gate der Pfad, der bei **ungleichem** Hash skippt. Die Testluecke ist heute gefaehrlicher als vor dem #59-Umbau.
Seit: mit der Testdatei.
Loest auf: zwei Tests, die `page_type` bzw. `general_hardware` zwischen den verglichenen Signaturen variieren.

### MESSUNG — 0 von 11 primaer. Das ist ein Luecken-Befund, kein Freispruch.

**Keiner** der 11 blocker-markierten Kandidaten hat MESSUNG als eigene Klasse. Drei treffen die Messung mittelbar:
- **W-1** und **W-3** — falsches Skip: eine inhaltlich veraltete Binary misst, und die Zelle sieht gruen aus.
- **A-1** — das PDF kann die Messung der eigenen Pipeline nie enthalten.
- **B-5** ergaenzend: die **Messdaten-Kaskade** des Lagers ist nicht verdrahtet — Messdaten haben keinen Einsortier-Pfad. Dieser Punkt war in der Vorlage **nicht** als Blocker markiert; ich markiere ihn hier als einen.

**Warnung zur Aussagekraft, ausdruecklich:** die fuenf Explore-Schnitte waren `owner-mini-pipelines`, `cache-stempel-kopplung`, `buildsystem-cache-nas-lager`, `ci-struktur-ist`, `harte-blocker-liegengebliebenes`. **Kein Schnitt hat die Mess-Kette selbst geprueft** — nicht das Drift-Gate (18 Durchlaeufe je Zelle), nicht golden-320, nicht HDR, nicht die drei CEB-Modi, nicht die 4!=24-Rekombinationen. "0 Messungs-Blocker" heisst hier: **0 gefunden von 0 gesuchten**. Das ist der offenste Punkt dieser Synthese und der naechste Explore-Auftrag.

### ABGABE — 2 von 11

**A-1 — `thesis-pdf` laeuft vor `measure` und `persist`.**
Wo: super/.gitlab-ci.yml:25-36, von mir selbst nachgelesen: `lint, orchestrate, submodules, analyse, test, integration, planer, manifest, thesis-pdf, measure, persist`.
Seit: mindestens 09.08., byte-identisch — keine Regression, ein seit drei Tagen unbehobener Zustand.
Loest auf: `thesis-pdf` hinter `measure`/`persist` ziehen — **oder** ausdruecklich entscheiden, dass das PDF die Messung der **vorigen** Pipeline traegt. Betrifft F1 (Fr 14.08., in drei Tagen) und den 15.09.

**A-2 — main-FF fuer beide Repos offen.**
Wo: `git rev-list --count origin/main..origin/development` = **super 99, ce 25** (selbst gemessen 11.08.). `git merge-base --is-ancestor 670483c0 origin/main` scheitert (aus Bericht).
Seit: laufend; die Zahl waechst.
Loest auf: Hygiene-Wache **lokal ueber den kumulativen FF-Bereich** fahren (Kanon: 1 Zeile gruen auf development, 18.577 rot auf main bei gleichem Baum), dann FF. Reihenfolge laut Ledger KON6-08: gruene ce-Pipeline → Gitlink-Bump in super (**bereits vollzogen**, siehe E-1) → main-FF beider Repos.

---

## TEIL 4 — DIE ENTLASTUNGEN

**E-1 — Der Gitlink-Bump super→ce ist vollzogen. Kandidat GEFALLEN.**
Selbst gemessen am heutigen super-HEAD `cc255fd8`: `git ls-tree HEAD Code/external/comdare-cache-engine` = `670483c0`, und `ce rev-parse HEAD` = `670483c0`. Exakt deckungsgleich.
**Restrisiko, unbelegt statt widerlegt:** der Bump-Commit `cf39dc19` dokumentiert selbst, dass die CI-Wirkung der 25 mitgezogenen ce-Commits auf super `build:*`/`test:*` **nicht lokal gemessen** wurde.

**E-2 — "Die vier Rollen des Stempels sind belegt" — GEFALLEN in der Rahmung.**
Das Code-Zitat selbst ist zeichengenau korrekt und an drei unabhaengigen Stellen gedeckt (`lager_baum_writer.hpp:50-51`, `build_orchestrator.hpp:307-310`, `lager_pfad_grammatik.hpp:15`). **Falsch war die Rollen-Zuordnung:** der Owner nennt **FUENF** Rollen — (1) IDENTITAET, (2) CACHE-SCHLUESSEL, (3) LAGER-SCHLUESSEL, (4) SKIP-MARKE, (5) EINORDNUNG. Der Befund labelte "Skip-Marke" als "(Cache-Schluessel)" und verdeckte damit genau die Luecke, die die Owner-Quelle zweimal betont: **Rolle (2) ist die einzige der fuenf ohne Objektbeleg.** Diese Entlastung ist zugleich eine Verschaerfung — sie stuetzt B-4.

**E-3 — "`dll_is_current` = Gleichheits-Vergleich" — GEFALLEN als allgemeine Aussage.**
Widerrufen im selben Kommentarblock (Z.369-372) durch Commit `363f0022` (11.08. 09:05, Task #59), der in der Elternlinie des zitierten Stands liegt. **Gueltig bleiben:** die vier Fail-Closed-Zweifelsfaelle und die 9 Preimage-Glieder.

**E-4 — `bvset_ist_teilmenge` existiert.** 21 Treffer in Produktions- und Testcode. Widerlegt einen aelteren Lens-Fehlbefund "existiert nicht, 0 Treffer baumweit", der auf einer 14 Commits alten Basis gemessen hatte (Ledger KON6-11). Merkposten: **Explore-Befunde gegen den aktuellen HEAD messen, nicht gegen einen gemerkten Stand.**

**E-5 — Die CEB ist NICHT genus-los.** `ceb_blatt_ebenen()` durchlaeuft dieselben `wurzel_ebenen()` (ABNAHME-5, `lager_baum_writer.hpp:760-764`). Entlastet die Annahme, die CEB brauche einen Sonderpfad. Genus-los ist **nur der Planer**.

**E-6 — ce ist von der Umbau-Last entlastet.** 0 echte `trigger:`-Keys (rc=1, selbst gemessen) und 0 `strategy:`-Keys in ce/.gitlab-ci.yml. Die gesamte Kind-Pipeline-Mechanik liegt in super. **Der Mini-Pipeline-Umbau ist ein super-Umbau.**

**E-7 — "45 needs-Zeilen in super" ist UNBELEGT** (nicht widerlegt). Drei unabhaengige Zaehlweisen ergeben 60 / 47 / 41 — keine ergibt 45. Zahl nicht weiterverwenden, ungeachtet eines Dual-Reviews, der sie am selben Tag als "Meta gemessen" fuehrt.

**E-8 — Die 4 ungetaggten super-Jobs sind kein Defekt.** 41 von 45 Jobs tragen `tags:`; die 4 ohne sind ausnahmslos `trigger:`-Jobs, die keinen eigenen Runner brauchen. In ce tragen 25 von 25 Jobs `tags:`.

**E-9 — Die Stufen-Topologie in ce ist nachweislich gruen.** Live-Lauf von `ce/scripts/ci_stage_topologie_wache.sh`: rc=0, 18 needs-Kanten, 0 Vorwaertskanten. Diese Wache existiert in super **nicht** (`grep -rni topolog` ueber super/.gitlab-ci.yml, super/ci/, super/scripts/ = 0 Treffer) — Entlastung fuer ce, offener Posten fuer super.

---

## KORREKTUREN AN DER VORLAGE (selbst gemessen)

- **K-1** — **ce hat ZWEI `build:`-Praefix-Jobs, nicht einen:** `build:clang` (ce:158) und `build:arm64-smoke` (ce:253). Die Vorlage sagt "GENAU EINEN Haupt-Bau-Job" — mit dem Wort "Haupt" gerade noch tragbar, als Zahl falsch. Der zweite Job liegt in Stufe `test`, ist var-gated und traegt `allow_failure: true`.
- **K-2** — super `origin/main..origin/development` ist **heute 99**, in der Vorlage 97. In der Zwischenzeit sind 2 Commits gelandet (parallele Agenten arbeiten). ce unveraendert 25.
- **K-3** — super-HEAD ist **`cc255fd8`**, nicht `ab7c936e`. Der Gitlink-Befund E-1 gilt trotzdem, weil ich ihn am **neuen** HEAD nachgemessen habe.
- **K-4** — `axis_version.lock` hat 9 Zeilen: 3 Kopfzeilen + **6 Eintraege**. Die "6 Eintraege" der Vorlage stimmen.

## NEUER BEFUND, nicht in der Vorlage (selbst gemessen) — KANDIDAT, kein bestaetigter Blocker

**Drei echte `allow_failure:`-Schluessel** existieren, gegen die Doktrin "allow_failure verboten seit 06.07. / ZELLE = Warnung, JOB = hart rot":
- super:2751 — in einer `rules:`-Zelle von `ergebnis:holen`, kombiniert mit `when: manual`.
- ce:878 — Job `is_original:relock`, `rules: - when: manual`.
- ce:257 — Job `build:arm64-smoke`. **Dieser ist NICHT manual**, sondern var-gated (`if: $COMDARE_ISA_MATRIX == "true"`): er laeuft automatisch, sobald die Variable gesetzt ist, und darf dann rot werden.

Zwei der drei sind manual-gated und damit vertretbar. Der dritte ist der Kandidat. Es fehlt eine Owner-Quelle zu var-gated ISA-Smoke-Jobs — deshalb **Kandidat an den Lead, nicht Blocker.**

---

## WIDERSPRUECHE, DIE DER LEAD ODER DER OWNER ENTSCHEIDEN MUSS

1. **NAS oder MinIO?** "Wurzel des Buildsystem caches (bereits auf NAS aufgebaut)" gegen den Objektbefund, dass "buildsystem-cache" im System ein MinIO-Bucket-Name ist. Im Korpus nirgends aufgeloest. **Blockiert B-4 und damit die Ablage aller vier Traeger.**
2. **Mini-Pipeline = Child-Pipeline oder Job-Gruppe?** (O-1) Davon haengt ab, ob B-2 (Nesting-Budget) ueberhaupt beisst.
3. **Wo sitzt der Hybrid?** (O-2) Der vierte Traeger existiert in keiner CI-Datei und in keinem YAML-erzeugenden C++.
4. **Der Vorlage-Befund "kein Lager-Pfad ohne Gattung+Genus" ist kein Defekt**, sondern die owner-konforme Regel. Ich habe ihn umgedeutet statt uebernommen — der Lead sollte diese Umdeutung bestaetigen oder verwerfen.
5. **Der Owner verweist auf eine fruehere eigene Aussage, die im gesamten Korpus nicht existiert.** Nichtfund mit breiter Gegenprobe. Entweder liegt sie ausserhalb der gesicherten Transkripte, oder die Erinnerung bezieht sich auf ein muendliches/anderes Medium. Nicht glattziehen.
6. **MESSUNG hat 0 gepruefte Kandidaten.** Kein Schnitt dieses Explores hat die Mess-Kette beruehrt. Vor jeder Kampagnen-Zusage: eigener Explore-Schnitt.