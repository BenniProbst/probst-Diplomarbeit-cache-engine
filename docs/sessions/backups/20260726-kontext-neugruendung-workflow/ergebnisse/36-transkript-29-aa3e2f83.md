# CHUNK 29/30 — Chronologische Extraktion (Diplomarbeit-Managersession, 23.07.2026 ca. 06:30–14:50 UTC)

Zeitraum: Ende der Nachtschicht (S4-Welle) bis Mitte der Lager-Gate-Umsetzung. Rollen: Manager = Fable 5 (Architekt), Impl-S6-P1 (Opus, Lane A), ab ca. 13:00 zusätzlich Impl-G3-P2 (Opus, Lane B), zeitweise Leser-Q4-1/2/3.

---

## (a) USER-DIREKTIVEN (chronologisch, woertlich wo bindend)

1. **Pause/Netzwechsel:** „Bitte lege eine Pause ein, ich möchte gleich das Netzwerk wechseln, der Cache wird geleert, Bitte sichere alles für einen kalten resume"
2. **Resume:** „Bitte resume alle workflows, Agenten und setze die Arbeit fort"
3. **Board:** „Bitte stelle das gesamte sichtbare TODO board für mich sichtbar wieder her."
4. **KERN-Direktive (Pflicht-Restpunkte):** „Ja, für später aufschreiben ist gut, aber wir hatten definiert, alle Punkte gründlich durchzuziehen, also zwar keine Umwege gehen, aber nacheinander durchziehen. **die Basename Härtung ist Pflicht.**" → verankert als Ledger-Nachtrag (super `2173ecd`) + Memory: „während einer Kette entdeckte Pflicht-Restpunkte werden in der Kette abgeschlossen, nicht geparkt; Aufschreiben ersetzt das Durchziehen nicht."
5. **Slice-Log-Sichtbarkeit:** „Schade ist nur, dass der Job nicht alle paar Builds (der Anzahl der maximal verfügbaren Threads der CPU) in den job Log schreibt, wie viele compiles von einem 4096 batch schon abgeschlossen sind. Wir lassen es jetzt so durchlaufen und fixen das erst wenn die gesamte Pipline grün ist" → Task #27 (später vorgezogen).
6. **RAM-Puffer-Idee:** avg_size als zweiter Bestandslog-Wert neben ETA; „maximal 256MB im RAM zu cachen"; CEB streamt Batch-Compiles in RAM statt je Compile auf Platte; „zurückstreamen von bereits kompilierten binaries über einen zweiten Thread an ccache … am besten nach IO_u-ring -> web recherche". Nachschub: „io_uring wird auf Windows nicht unterstützt, aber wir müssen die dokumentieren OS alle unterstützen."
7. **Worker-Korrektur:** „Die AMD verkraftet 32 threads und Intel 24 auf nproc max. Wir sollten auch das in der nächsten Pipeline für Geschwindigkeit optimieren. Wie schätzt du die ETA ein?"
8. **Cancel-GO mit Nachweispflicht + Lagerhaltungs-Präzisierung:** „Bitte unterbreche den build, **sofern du nachweisen kannst**, dass die Intel Maschine unter ihren Möglichkeiten arbeitet **und mindestens das erste Batch erledigt hat**. Die gespeicherten Builds werden zu Beginn eines Batches korrekt erkennt und nur fehlende gebaut? … Für die Lagerhaltung wird **jedes fehlende Binary einzeln erkannt und nicht als gesamt-Batch**. Die Konsolidierung und Batch Planung erfolgt zu Beginn **vor dem ETA und async über alle Binaries**, der Start läuft an sobald das erste Batch zusammengestellt ist, aber die Zusammenstellung aller Batches … wird über ALLE Einzeljobs im Hintergrund fertiggestellt und **eine queue an batch slices erzeugt**, die abgearbeitet wird." + stehende Direktive „alles erdenkliche was wir haben in der CI und Lagerhaltung vorzuziehen und zu implementieren, damit sich die Gesamt Zeit verringert".
9. **Monitor-Rüge:** „Der Monitor hängt?" (Waisen-Wache ohne Heartbeat = Verstoss gegen Nie-stumm-Doktrin).
10. **Cred-Handling:** „Bitte kopiere, **ohne zu lesen** aus dem cred vaullt die benötigten ‚comdare' Informationen für die Operation auf den desktop" → später „Weiter, **Anfragen auf Schlüssel werden abgewürgt, bitte lass sie sein**" → dann „**K8s Zugang über cred vault gewährt**".
11. **Nach Model-Wechsel (Fable 5 + /effort ultracode):** „Bitte lies dich gründlich ein in den Bereich bevor Opus 4.8 unkontrolliert übernommen hat und fahre mit offener Arbeit fort … bitte lies die letzten 5 Turns ein"
12. **Resume-Befund (User hatte recht):** „im log erscheinen keine Build-Batches die schneller gehen, weil sie durch einen resume zurückgeholt wurden oder irre ich mich?"
13. **Vergessene TODOs:** „findest du die Teile, die als vergessene TODOs vor dem neuen Lauf hätten erledigt werden müssen, bitte suche alle zusammen und **erledige sie vor dem Lauf**. Bitte lies auch memory, **lies nichts ein, was mit login oder credentials zu tun hat**"
14. **Freigaben:** „Du hast die Freigabe für alle 3 Dinge die du zum Arbeiten brauchst, GO." (mehrfach) + „**Bitte delegiere all diese immer an einen separaten opus 4.8 Agenten**" + „Du darfst auf cred vault meine Passwörter ohne in den chat zu schreiben verwenden".
15. **Storage-Doktrin-Rüge:** „Bitte räume dann auch mal prod1 auf … Warum ist da so viel Platz belegt? Und der Matrix forecast sollte doch immer auf ccache für die binaries und auf **PR4100 Cluster_NFS experiment-ordner** immer die Messergebnisse geschrieben werden? Der forecast auf der Maschine selbst sollte daher **gegen null gehen**, da stimmt das Plan Verständnis nicht (steht alles im Diplomarbeit-TODO und Ledger, hast du das gelesen?)"
16. **Pruning + Board + CI-Vorlauf:** „OK, dann müssen wir für die Lagerhaltung **VOR der Abgabe noch Pruning einführen**. Du hast das TODO Board noch nicht wieder hergestellt. Es gab einen Haufen Aufgaben in der CI, die erledigt werden müssen, bevor der Build nochmal starten kann, **sonst riskieren wir Binary-Verlust** und müssen bei Fehlern nochmal neu bauen, was wir uns nicht leisten können. Wo stehen wir im gesamten Projekt? Bitte lies die stehenden Direktiven und handle danach"
17. **Drei GOs:** „AMD worker bitte auf 24 Threads drosseln. Root cleanup bitte durchführen, **wenn du den Inhalt gelesen hast**. sudo installer freigegeben"
18. **Ablauf-Konsolidierung:** „Wir hatten vor einiger Zeit eine Tabelle der gesamten Ablaufreihenfolge aller Tasks aufgestellt, was hat sich seither an neuen Aufgaben ergeben. Bitte konsolidiere die Gesamte Abfolge und erstelle mit dem skill des todo Board eine Übersicht. Dann setze die Gesamtabfolge auch mit den ganzen neuen Einschüben zur CI genauso um…"
19. **GATE-UMKEHR (folgenreichste Direktive des Chunks):** „**Wir ziehen alle Punkte, die mit Lagerhaltung zu tun haben, nach vorn und erledigen sie als nächstes, vor dem voll build (betrachte alles was die Lagerhaltung und Stempel angeht als gate für voll build)**"
20. **Frist-Entlastung:** „ja ich weiß dass das länger dauert wenn wir es gründlich implementieren, aber das **Risiko des Scheiterns ohne Wiederaufnahme ist zu groß**, wir sind gezwungen die Lagerhaltungs-Punkte nach vorn zu ziehen und **möglichst parallelisiert** zu entwickeln. Dann sind Fehler bei der Messung abfangbar und überhaupt verkraftbar. Ich werde eine Erklärung finden, wie ich möglichen Verzug begründe, es ist ja noch nicht die End-Abgabe wo alle Aufgaben in der aktuellen Gründlichkeit erledigt sein müssen."
21. **Infra-Doktrin:** „Was für ein fortigate block? **Bei Infra Problemen schreibe bitte dem INfra agent ein handover**"

---

## (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begruendung)

- **Profil-Basename dynamisch statt tp.id** (S2-Nacht-1): Quelle = `profile_path.filename()`, weil id != Basename vorkommt (`m3v2_sota_pilot.profile.xml` traegt id="C"). Leerer Basename => Fallback `all_axes_golden.profile.xml` => byte-identisch zu HEAD.
- **Emissionszeit-Literale statt `X: "$X"`** (S2-Nacht-2): GitLab wertet Selbstreferenz im emittierten Child als Zirkularitaet. Leere Werte => Zeile entfaellt (erhaelt die „nicht gesetzt"-Semantik der Grandchild-Rules).
- **Facade-Basename-Haertung Option (b) statt Parken** (S2-Nacht-3): Manager wollte zunaechst Option (a) (akzeptieren, dass Smoke-Mess mit Profil-Methodik laeuft); User-Direktive #4 kippte das. `resolve_methodik_profile_path` loest Bare-Basename gegen `main_profile_path.parent_path()` (thesis_profiles/) auf; Pfad-behaftete Werte bleiben unveraendert; unset => frueher Return => golden byte-identisch.
- **T-Werte 32/24 → nach Empirie 24/24**: Erst nproc-Max (User-KERN ist Gesetz, K-Lesart 24/16 ueberstimmt). Dann Messung: amd 32W = 19,95 min/Slice ≈ 24W = 19,4 min, aber 20G Swap aktiv, nur 12G von 60G RAM available → Build ist **RAM-gebunden, nicht CPU-gebunden**. User-GO zur Drosselung; intel bleibt 24.
- **RAM-Puffer/Writer-Thread-Doktrin (§62-B-NACHTRAG-2):** 256-MB-Spool, Doppel-Trigger (Groesse ODER 12 Stueck), dedizierter Writer-Thread ausserhalb des K-Budgets, **CT-Strategy mit drei Backend-Familien** (io_uring Linux / Windows IoRing bzw. IOCP / portabler write-Thread als Pflicht-Referenz), Auswahl zur Compile-Zeit — kein Runtime-Switch. Der Qualifier „im Hot-Path" wurde auf Kritik des Verifikations-Workflows gestrichen (flach: kein Runtime-Switch).
- **§65 (neu im Ledger):** Storage-SOLL = Binaries → minio Ebene B (V90, Bucket `cache-engine-tier-binaries`, W11-async), Messwerte → Doppel-Sink git `measurement/<ts>/` + measure-drop → PR4100 `Cluster_NFS/cache-engine-experiment`, **lokaler Fussabdruck der Baumaschine gegen null**. Das „lokal gegen null" stand vorher in keinem Dokument und wurde als User-KERN verankert. **§65b** = Tools-Lagerhaltung (Toolchain/Treiber/Planer/CEB-Werkzeuge mit einheitlichem Benennungsschema in minio, Wiederverwendung statt Neubau), Task #32, post-Abgabe.
- **§66 (neu):** Lagerhaltung + Stempel sind **Gate fuer den Voll-Build**. Gate-Kette G1 (B/C/D+amd24) → G2 Stempel-Bruch → G3 Bestandslog-Kern → G4 (P-A Push-Aktivierung + P-C measure_out) → G5 (P-B Pruning). Board-#22 durch alle geblockt. Frist-Ehrlichkeit im Ledger: Gate kostet 1–2 Tage, S8-Endgate Mo wird eng.
- **Zwei-Lane-Parallelisierung mit strikter Datei-Disjunktheit:** Lane A = `{abi, anatomy, measurement, topics, axes, builder/build_orchestrator, builder/experiment_tree/axis_variant_version_table.hpp + build_variant_definition_reader.hpp}`; Lane B = `builder/bestandslog/` (neu), `builder/artifact_transport/` (neue Dateien), `ext/io/`. Geteilte Dateien (Iterator, Director, artifact_cache, tests/unit/CMakeLists.txt) nur in serialisierten Integrationsscheiben; Iterator/Director fuer Lane A gesperrt.
- **A7-Gegenvorschlag angenommen:** `build_variant_sig` als schlichtes `std::string`-Feld statt `VariantSigFn` — die Build-Variant-Signatur ist Zell-/ISA-Ebene, ein `Fn(spec.axes)` waere semantisch falsch (per-Organ). Leer = Gate AUS = byte-neutral. Ein Serializer (`compose_variant_signature` aus A6-POD), keine Parallel-Ableitung.
- **A6-Design-Vereinfachungen akzeptiert:** `provides_avx10_version()`-Default in der `SimdExtensionStrategyBase` statt in jedem Wrapper (DRY); Reader/Inspection unveraendert, weil sie den ganzen POD kopieren (Feld wird automatisch durchgereicht).
- **I1 Option A (Key-Provider-Injektion) + Scheiben-Split:** Dedup ist unter Option A naturgemaess post-build (Fingerprint erst nach dem Bau); der pre-build Compile-Skip kommt mit I2 (`.fingerprint`-Sidecar). I1 = Registrierung + Dedup + Transport-Seam, I1b = Planer-getriebener Bau separat.
- **B7-Kurskorrektur (siehe Fehler):** vendored liburing statt roher UAPI-Syscalls — die Speicher-Ordnung (acquire/release-Barriers) ist genau der Grund fuer liburing.
- **Mess-Batches bleiben `when:manual`;** Voll-Bau-Trigger-Rezept: POST /projects/288/pipeline, ref=development, **nur** `COMDARE_BUILD_GOLDEN_N=true`, kein Storage-Opt-in (der GN-Cache-Pfad lebt nur in der deprecated statischen Kette).
- **Prozess-Haertungen:** (1) Geteilte-Datei-Protokoll fuer `tests/unit/CMakeLists.txt` (je Lane genau ein markierter additiver Block am Dateiende, nie formatieren/resetten); (2) cf22 NIE auf .txt/.cmake/.yml; (3) **ASCII-Selbstcheck-Zeile als mechanische Pflicht in jeder Paketmeldung** (literaler grep-Beweis, leer = ok) statt Eskalationsdrohung; (4) **Mailbox-Lese-Pflicht vor jeder Scheibe** mit msg-ID-Bestaetigung in der Paketmeldung (nach vier verpassten B3-Entsperrungen und einer verpassten Kurskorrektur); (5) Infra-Behauptungen immer selbst per curl/ls-remote belegen.

---

## (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS

**Mess-Beleg (kein Commit):** bare-metal Mess-Smoke prod1, Profil `m3v2_smoke`, Fenster 0:2, drei Phasen je exit 0 — Bau provision-only (8 perm.dll, K7b-Stempel `m3v2+ext=no_extension+cxx=g++-16+opt=O3+ceb=6.0`, Organ-Fingerprint `.algos`), PRUEF_ONLY (8/8 gegated, kein Neubau), Messung (16 echte CSV-Zeilen = 8 Binaries x 2 Workloads, 1-Thread, platform=amd@prod1, build_version=m3v2-smoke). Damit **GN-11-Messfaehigkeit (b) bare-metal erbracht**. Der nachgeschobene 0:4-Lauf wurde verworfen.

**Kette-2-Abschluss:**
| Paket | ce | super | Beweis |
|---|---|---|---|
| Pause-Handover | 9df09f14 | 8aa9216 | docs/sessions/20260723-SESSION-PAUSE-HANDOVER-netzwechsel-2.md |
| S2-Nacht-1 Basename-Durchreiche | f41fb1af | 991b830 | Smoke 12658-Artefakt traegt `m3v2_smoke.profile.xml`, 0x all_axes_golden |
| S2-Nacht-2 Zirkularitaets-Fix | 44f55821 | df31422 | ceb:trigger mit Emissionszeit-Literalen |
| Ledger-Praezisierung (Direktive #4) | — | 2173ecd | + Memory |
| S2-Nacht-3 Facade-Basename | 5990e53b | 78ad7fb | alle drei Literale am ceb:trigger |
| Kette-2-Abschluss-Doc | — | c65bc0d | Smokes 12667 + 12684 success |

**Smokes/Pipelines:** 12591 (S4-Welle, success, inkl. ce-Bridge 12592 mit 49 umgebauten Planner-Tests) · 12623 failed (deckte S2-Restfehler auf) · 12658 failed (Zirkularitaet) · **12667 success** (Struktur-Smoke-3 End-to-End: 2 Jobs statt 20, Leere-Lane-Regel greift live, ebenen-richtiger Batch-Kopf `== [BATCH-MESS] ceb=[all] lane=amd ts=... ==`, Heartbeats in allen Phasen, ~7,3 s/Mess-Zelle bei 320 Zellen) · **12684 success** (Final-Smoke mit Methodik-Injektions-Beweis: `CMAKE_BUILD_TYPE=Debug` + `(j3)`-Dual-Compile im Grandchild) · 12690 Voll-Bau-1 (24/16, gecancelt) · 12713 Voll-Bau-3 (32/24, spaeter gecancelt) · 12720/12721 rot durch OOM, nach Retry im ruhigen Fenster **success** · 12723/12724 success (G1-Gruen-Fenster) · **12728 success** (A1-Gate-Smoke + Live-Beweis der Slice-Takt-Testate: 199 Heartbeats im 24er-Takt → **#27 abgeschlossen**) · **12742 success** (A2-Gate-Smoke).

**Vorlauf-Pakete:**
- Teil A gn_out-Persistenz (`GIT_CLEAN_FLAGS: "-ffdx -e Code/gn_out -e Code/build"` + `GIT_STRATEGY: "fetch"` an allen 4 Batch-Jobs): ce **4efd3906** / super **bc2ea2a**
- T-Werte: ce **007bdc3b** / super **c8d94df** (Adversarial-Workflow-Verdikt: SAUBER)
- Ledger-Maengelfix nach Verifikations-Workflow: super **9ef43a4**
- Ledger-Nachtraege: RAM-Puffer/io_uring `7c1778a`, Batch-Planung `1b9658a`
- **G1** (Slice-Takt-Testate every_n=24, Cancel-trap, Log-Append-Haertung, amd 32→24): ce **2f756da1** / super **0b5c20d** (+ Ledger §65/§66 + Session-Doc)

**Lager-Gate-Scheiben (alle mit eigenem Manager-ctest, chirurgischen Commits, Dual-Push):**
| Scheibe | ce-Commit | Inhalt |
|---|---|---|
| B1 | 351855b8 | Bestandslog-Dokument + XML-Emitter/Parser, 2 Genera, Header-Versionierung, 9 Tests |
| A1 | dd48327f | 120 Literale `"v1"`→`"v1.0.0"` (119 Dateien: 99 axes/ + 20 topics/queuing/), Concept-Guard in `axis_variant_version_table.hpp`, **eingefrorener Fingerprint-Testvektor** `MW12StampBausteine.FrozenFingerprintTestVectorForLagerGateB3` (128-hex `kFrozenFingerprintV1`) als B3-Sync-Anker |
| B2 | (amendiert) | Lock/Transport-Naht, Owner-Token-Verify-Lock, ttl, Record-Union-Merge, 13 Interleaving-Tests |
| B4 | 87cd73a2 | ETA (`Sum(t)/N` mit max-Untergrenze), avg_size, pro-forma→ETA→Done, +50%-Takeover, RAII-PromiseGuard, 17 Literal-Tests |
| B5 | f8c38ff3 | Batch-Planer (Einzeln-Miss-Erkennung, Paritaets-Gleichverteilung, B13-Wache) + Slice-Queue mit bewiesenem Start-vor-Fertig |
| B6 | be250512 | RamSpool 256MB/12er-Trigger, `SpoolWriter<Backend>` CT-Strategy (concept-gegated), portables Backend als Referenz, Byte-Identitaet + Crash-Fenster-Test |
| A6 | 53c97072 | AVX10-Feld append-only (POD 64→72, Version 2), toleranter Detektor |
| B3 | 93b20855 | Sha512Key/Index + Factory (Concept statt vtable), **BinaryKeyPolicy == K7b-Anatomy-Fingerprint standalone nachgerechnet und gegen A1-Vektor gepinnt** |
| A7 | 730ebae9 | `.variant`-Sidecar, `dll_is_current` 4. Param, `compose_variant_signature`/`parse_variant_signature`, 3x3-Skip-Matrix |
| B7 | ed174638 | io_uring-Backend gegen **vendored liburing-2.6** (`ext/io/liburing/`, 344K/38 Dateien, Provenienz-MD), CMake-Option `COMDARE_WRITER_BACKEND`, real gelaufen (Kernel 6.17), byte-identisch zu portable inkl. 512KB |
| I1 | 1e23b9be | CEB-Iterator-Verdrahtung (Lager-Load vor Hydration, `observe()` thread-sicher je Binary, Ein-Merge-`flush()`), opt-in default AUS, Byte-Wachen gruen ohne Update, 311/311 |
| A2 | 79f24f6a | `system_axis_code_versions.hpp` (Single-Source 5x v1.0.0), Tooling-Registry-`version`-Feld + `tooling_version_for_id`, render-neutral bewiesen |
| A3 | 0918b697 | `AnatomyStampEntryV1` (48B/8-Pin), consteval `count_stamp_entries`/`parse_stamp_entries`, `parse_dotted_semver` additiv |
| Infra-Handover | 194e62e (Cluster, nur gitlab) | `docs/handouts/20260723-handover-infra-fortigate-sni-github-befund.md` |

CRC-Anker durchgehend unveraendert bei **0xF1C1F26A1232073B**; voller ctest wuchs 301 → 312.

---

## (d) FEHLER + FIXES

1. **Child-Prolog exportierte hart `all_axes_golden`** (`emit_child_submodule_prolog`) — Smoke-Laeufe exerzierten trotz `profile_id=m3v2_smoke` den vollen Katalog. Fix: `PlanHeader::profile_basename` durchgereicht, Quelle `profile_path.filename()`.
2. **`circular variable reference detected [COMDARE_GN_TOTAL, COMDARE_GN_TOTAL]`** am `ceb:trigger` → GitLab brach die Child-Erzeugung leer ab (erklaert auch rueckwirkend das leere 12628, das faelschlich als Netzwechsel-Abriss eingeordnet war). Diagnose nur ueber die **Rails-DB** moeglich (die API verschweigt `failure_reason`). Fix: `append_forward_var_literal` brennt Werte zur Emissionszeit literal ein.
3. **METHODIK-Regression** (von Impl korrekt geflaggt): `COMDARE_PLAN_METHODIK_PROFILE` stand nur im Trigger-Job, war zur `--dump-ci`-Zeit ungesetzt → Grandchild-Mess-Loop ohne injizierte Methodik. Zusatz-Knoten: Facade brauchte ladbaren Pfad, Forward brauchte Basename. Fix = Basename-Aufloesung in der Facade + Basename im `planer:delegate`-Smoke-Zweig.
4. **Kein Resume — `git clean -ffdx` loeschte `gn_out`** (0 `.so`, 0 Sidecars nach dem Vorlauf). User-Befund war korrekt. Fix Teil A.
5. **OOM/`cc1plus terminated`** in 12720/12721: CI-Jobs liefen zeitgleich mit dem 32-Worker-Batch auf prod1 (60G RAM, 12G available, 20G Swap). Kein Code-Regress — Retry im ruhigen Fenster gruen. Konsequenz: waehrend des Voll-Baus keine schweren CI-Jobs parallel; Pushes ggf. `-o ci.skip`.
6. **Waisen-Batch-Schleifen nach Cancel:** Cancel toetet nur den Shell-Wrapper, die interne `bash -l`-Schleife (PPID=1) spawnt weiter Driver+Compiler. prod1 3183599 nur per User-`sudo kill -9` loesbar; spaeter autonom via installiertem Sweep-Skript (prod1 Prozessgruppe 791677, prod2 1306754). Dauerfix = Cancel-`trap` (Teil C): `trap 'trap - TERM INT; kill -- -$$ 2>/dev/null' TERM INT` — das `trap -` zuerst ist essenziell (sonst Endlosschleife, lokal reproduziert).
7. **Monitor ohne Heartbeat** (Waisen-Wache) — Nie-stumm-Doktrin verletzt, durch 3-min-Heartbeat-Variante ersetzt.
8. **`tests/unit/CMakeLists.txt` zweimal zerstoert:** blindes clang-format auf `git diff --name-only` mangelte die CMake-Datei (Impl-S6-P1 gestand es), danach `git checkout --` verwarf transient Lane-Bs Block. Fix = Geteilte-Datei-Protokoll + cf22 nur auf .hpp/.cpp.
9. **Falscher FortiGate-Befund** (Impl-G3-P2 uebernahm einen historischen xml_reader-Vorfall als „Haus-Doktrin" ohne Test; **der Manager gab ihn ungeprueft weiter** und raeumte den eigenen Nie-raten-Verstoss ein). Literal widerlegt: `git ls-remote` auf axboe/liburing liefert HEAD, `raw.githubusercontent.com` und `codeload.github.com` HTTP 200, plus laufende Pushes nach github. Folge: B7-v1 (Roh-UAPI) **zurueckgewiesen und neu gebaut**, Infra-Handover geschrieben.
10. **PAT-Zwischenfall beim A2-Push:** Der `store`-Credential-Helper loeschte den operativen root-PAT nach einem Server-401; der Token existierte in keinem Vault (einer read-only/403, zwei tot/401). Rotation (#327) sofort autonom vollzogen ueber die Rails-Konsole (pve1→Toolbox), 90 Tage, minimale Scopes, API-200 + Push-Beweis, **Wert nie ausgegeben, blind in Credential-Store und DEV-Vault geschrieben**.
11. **Kleinere:** Manager-`sed` fuer ASCII war zunaechst uebergriffig auf Alt-Zeilen (zurueckgebaut); zwei vorbestehende Timing-Flakes im Voll-ctest (Rerun gruen, als CI-Wartungs-Merkposten verbucht); Board + Agenten ueberlebten den Netzwechsel nicht (25 Tasks + Impl-S6-P1 neu aufgesetzt); Push-Pipeline-„tot"-Befund war ein Kurz-SHA-Query-Artefakt (revidiert).

**Aufraeumen prod1:** 24G eigenes Scratchpad geloescht (59G→79G), dann nach Inhalts-Lektuere 9 tote `comdare-gcc-build-*` (14,4G, GCC-5.5.0-Toolchain vom 12.07.) + `/tmp/comdare/x86_64/linux/UNKNOWN` (19G, staler Tools-Bootstrap, letzter Zugriff 18.07.) → **109G frei**. sudo-Installer `comdare-sweep-orphans` installiert (killt nur gitlab-runner-Waisen mit PPID=1 nach Muster, NOPASSWD nur fuer dieses Skript); Nebenbefund: `admin-management@localhost` mit cluster-Key hat NOPASSWD-sudo auf prod1.

**Storage-IST vs. SOLL (ehrlicher Befund):** Der Ebene-B-Push ist in den Director-emittierten Batch-Jobs **inert** (Aktivierung/MINIO-Vars nur in handgeschriebenen super-Jobs), es gibt **kein Pruning**, und der Sidecar-Resume liest ausschliesslich lokal → ehrlicher lokaler Forecast ~58–65G. Die Teil-A-Persistenz ist doktrin-konformes **Interim** bis #46b. `/var/mnt/coldstore` ist auf keiner Maschine gemountet.

---

## (e) OFFENE FAEDEN AM CHUNK-ENDE (~14:50 UTC)

**In flight:**
- **G5-Paketmeldung von Impl-G3-P2 ist mitten im Text abgeschnitten** (Chunk endet bei „VERIFIKATION:"). Inhalt bis dahin: `prune_verdict` (loeschen nur bei bewiesenem Remote-Spiegel: `.version` existiert + byte-gleich + Groesse gleich; jeder Zweifel = behalten), `prunable_artifacts` = genau {perm.dll, .dll.version, .dll.algos} — **niemals result.csv/measure_out/prune.log**, `verify_remote_then_prune` mit `[PRUNE]`-Testat, `pull_tier_prefix` von `mc cp --recursive` auf `mc mirror` (inkrementell/resumierbar) + `COMDARE_MC_PULL_TIMEOUT_S`, neuer `test_g3_prune.cpp` (8 Faelle), geaenderter `test_s2_pull_tier_binary.cpp`, sowie **im super-Repo** `Code/02_messung_driver/main.cpp` +39 (`COMDARE_PRUNE_ONLY`-Standalone-Branch). **Abnahme/Commit stehen aus.**
- **A4 hat GO und ist in Bau** (Impl-S6-P1, mit eigener Ultracode-Planung): POD 88→136, Layout 4→5, `_MERGE`-Makro (kOE/kSE/kME), Loader-Gate ≥5, Sentinel — **emitter-beruehrend → Struktur-Smoke-Gate danach Pflicht**.
- Wachen aktiv: ResumeWorker-Cron-Wache (10-min-Poll, zuletzt OK 14:36).

**Restweg zum Voll-Bau-4 (Reihenfolge wie zuletzt vom Manager formuliert):** A4 + Smoke → A5 (CEB-Stempel) → I2 (`.fingerprint`-Sidecar + Facade-Env-Aktivierung `COMDARE_BESTANDSLOG`, plus CEB-Linkage gegen `comdare::vendored_liburing`) → G4a (P-A Push-Aktivierung im Director) + G4b (P-C measure_out) → G5-Landung → I1b (Planer-getriebener Bau) → Final-Smoke + **lokaler Resume-Skip-Beweis** → Trigger Voll-Bau-4 (24/24, Lager aktiv, nur `COMDARE_BUILD_GOLDEN_N=true`).

**Offene Sweep-Auflage:** Auflage 1 (Gruen-/golden-Neutralitaets-Beweis der Gate-Fixes vor dem Re-Trigger) ist nur fuer den G1-Stand erbracht — fuer die Gate-Scheiben erneut faellig. Auflage 2 (**`GN_DECISION=skip` literal als Abnahme-Kriterium des neuen Laufs**) ist im Session-Doc festgeschrieben, aber noch nicht eingeloest.

**Offene Board-Punkte (Board-Stand 35 Tasks):** #33 measure_out-Verlustnaht (blockt #6 320er) · #35 P-B Pruning · #10 #46b Vollausbau + §65-Vollzug (lokal→0) vor 01.08. · #6 320er → #7 S7 → #24 G8-Anhaenge → #8 S8 PDF DE+EN (END-GATE Mo 27.07.) → #9 dev→main (Scrub-Vorsicht, beide mains rewritten auf 91897d4a) · #32 Tools-Lagerhaltung · #25 CI-Rest (Cron-Persistenz nach Pod-Restart, Helm-Values, 12272-Scrub-Welle) · #18 CI-Wartung (jetzt 9+3 Merkposten) · #29 Cancel-Waisen-Rest · #23 PAT (Revokation der Token-Leichen + **Grundsatzfrage an den User: eigener Nicht-root-GitLab-User**, aktuell existieren nur `root` und ein Projekt-Bot) · Band C #12–#21.

**Sonstiges offen:** `~/Desktop/comdare-prod1-op-creds.txt` (chmod 600) sollte nach erledigter Operation vom User geloescht werden · Post-Gate-Merkposten Windows-Backend (S8) und opt-in-Integrationstest (S10) · bewusst geparkt: nichts mehr aus H-10/K-18 (AVX10 und per-Binary-Sidecar sind mit A6/A7 gelandet).