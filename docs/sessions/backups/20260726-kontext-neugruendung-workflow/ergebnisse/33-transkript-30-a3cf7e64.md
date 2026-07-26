## CHUNK 30/30 — Chronologische Extraktion (Manager-Session Diplomarbeit)

---

### (a) USER-DIREKTIVEN (chronologisch; woertlich wo bindend)

**U1 — PMC-Validitaetsfrage** (nach G5-Landung):
> "Ist das pmc:amd für AMD und Intel gültig oder müssten wir für eine valide Messung auch ein pmc:intel bauen?"

**U2 — PMC hart schalten + Runner-Filter + festes TODO** (bindend):
> "Gut, bitte reaktiviere das pmc:intel , sobald es sich um einen Intel CPU vendort handelt, trage die Antwort als festes TODO ein zu PMC. Es ergibt nur sinn, dass die AMD Maschine jobs für amd:pmc aufnehmen kann und die Intel Maschine intel:pmc . Ist dieser gitlab runner filter gesetzt? Beide müssen für den Erfolg der Pipeline hart gesetzt und erfolgreich sein, bevor eine Lane einer Maschine den gesamten Strang abarbeiten darf. Also ist die Intel Maschine nur mit intel pmc erfolgreich in der Lage zu messen und die AMD Maschine muss AMD-pmc bestehen."

**U3 — PRAEZISIERUNG PMC = AND ueber DEKLARIERTE Menge, XOR-verschiffbar** (bindend, supersediert U2-Harteschaltung):
> "Hm aber wenn du jetzt nochmal genau liest, dann stellst du fest, dass die pipeline scheitert, wenn AMD oder die Intel Maschine aus ist. Daher muss das PMC für die verfügbaren Maschinen getestet werden und nicht nur, ob allgemein die PMC Messung funktioniert, sondern ob die Maschie, die verfügbar ist, auch PMC hat. Wir gehen im zweiten Schritt dennoch davon aus, dass stets beide Maschinen für den compile Test verfügbar sein werden - immer - aber in anderen Clustern mit nur intel Maschinen oder nur AMD Maschinen muss die Pipeline dennoch grün werden für die VERFÜGBARKEIT xor. Die Pipeline auf Condare für pmc Test ist AND, wenn AMD UND Intel pmc nachweislich für unser Programm funktionieren. Wir wollen ja das Programm und die Pipeline verschiffen"

**U4 — Pause vorbereiten + Erklaerungswunsch**:
> "Bitte bereite eine Pause vor, ich möchte gerne nach Abschluss der noch laufenden Implementierung das Netzwerk wechseln. Mach das letzte aber bitte noch fertig. Welcher Vorschlag musste gerade entschieden werden? Bitte erkläre mit mehr Kontext"

**U5 — §66-NACHTRAG-3 MAPPING-REINHEIT (KERN = Gesetz, hoechste Bindung)**:
> "Ok, aber ich möchte festhalten, dass std::variant in CEB und Tier-Binaries strikt verboten ist, weil es eine runtime Variable auf ein compile-time Ziel mappt und das bloated das binary. Der Compile muss also wirklich compile time sauber sein (compile time -> compile time mapping) und es werden auch nur runtime -> runtime Abbildungen akzeptiert. Ansonsten sind verschiedene runtime Varianten der Unter-Achsen auf dieselben compile time Haupt-Achsen erlaubt. Ansonsten ist das richtig, wie du entschieden hast: die Registry entscheidet wie das zu bauen ist, um schlanke und effiziente Binaries zu erzeugen. Weiterhin sind alle Achsen immer getrennt zu behandeln und zu klammern. Das kannst du gerne noch umsetzen, dann möchte ich gerne eine Pause einlegen."

**U6** — "Bitte sichere schon mal einen reichen Zwischenstand für die Pause, falls das Netz instabil wird"
**U7** — "OK, ich sehe das Netzwerk steht noch, aber wir müssen hier leider wirklich pausieren"
**U8** — "Die Pause ist vorbei, bitte fahre wie gewohnt mit offener Arbeit fort"

**U9 — Absturz-Recovery-Bericht des Fremd-/Infra-Agenten weitergereicht** (User zitiert Dritt-Agent): super gescrubbt (nur kamdi-Text zeilenweise redigiert, 2 Dateinamen → …REDACTED.md, **null Loeschungen**, Count 1882/1948 erhalten "exakt deine Direktive `jede Rohdatei zählt`"); Force-Push per Keeper-Dance ueber GitLab-API (allow_force_push trap-gesichert getoggelt, Schutz danach wiederhergestellt); main 91897d4→a6af540, development 4494b35→d6c06ef, 4 Tags. Zwei Punkte "die dir gehören (nicht autonom)": lokalen super-Klon (99bffb97) per fetch+reset nachziehen; **Object-Purge server-seitig NICHT autonom** (11 refs/pipelines/* pinnen Alt-Objekte; Purge wuerde Pipelines/CI-Artefakte loeschen → Messdaten-Risiko gegen "jede Rohdatei zählt").

**U10 — Neu-Gruendung + Agenten nur bereithalten**:
> "Bitte lies dich gründlich ein und gründe dich neu. Bitte resume alle workflows und bereite den resume aller Agenten vor, aber pausiere nach Fertigstellung der zu resumenden workflows und halte die Agenten nur bereit, anstatt sie zu starten. Der Infra Agent hat dann gleich noch einen scrub zu tun, daher bitte committen und pushen und danach pausieren, wir warten auf die Wartungsaufgabe"

**U11 — Strang zuerst, Handout danach**:
> "Der Infra hat einen commit dagelassen auf remote mit einem Handout. Aber wir machen erstmal den Strang hier fertig. Bitte fahre mit offener Arbeit fort, wir wurden mitten im Strang in der Implementierung unterbrochen."

**U12** — "bitte commit und push mal auf development und beide remotes und ziehe mal main nach (auch auf remote)"

*(Effort-Level wurde zwischenzeitlich per `/effort` auf **ultracode** gesetzt: "xhigh + dynamic workflow orchestration".)*

---

### (b) ARCHITEKTUR-/SCOPE-ENTSCHEIDUNGEN (mit Begruendung)

**E1 — I1b Determinismus-Definition = Option (A)** (Manager entscheidet alle 3 Punkte auf Agenten-Empfehlungslinie):
1. Slice-Schleife ueber **dieselben** Indizes, `provision_all` je Slice → beweisbar gleicher builds-Vektor inkl. `skipped`; `dll_is_current` bleibt der **eine** Skip-Arbiter. (B = on-disk-Menge verworfen: hoeheres Determinismus-Risiko, kaum Mehrwert.)
2. `PresencePredicate` informiert **nur** Reservierung/ETA, filtert den Bau nicht; Selektivitaet kommt mit I2 (Fingerprint-Sidecar).
3. Zwei neue inaktiv-sichere cfg-Felder (`bestand_owner_uuid`, `bestand_maschine`), threads = `build_parallelism`.

**E2 — PMC-Semantik (aus U3), ce `57dc0245`** supersediert die unbedingte Hart-Schaltung `194dee57`:
- `COMDARE_PMC_LANES` **deklariert** die Vendor-Menge des Clusters; Repo-Default `"amd intel"` → auf Comdare beide Jobs hart Pflicht (AND, kein `allow_failure`).
- Fremd-Cluster ueberschreibt (z. B. `"intel"`) → nur vorhandene Lane instanziiert (XOR-Verfuegbarkeit) → verschiffbar.
- **Ehrlichkeits-Detail:** eine *deklarierte*, aber tote Maschine blockiert weiterhin — Schweigen einer kaputten Pflicht-Lane darf nie als Gruen durchgehen.
- Beweisgegenstand = **unsere eigenen PMC-Smokes**, nicht generisches perf.
- Runner-Filter verifiziert: prod1 = `baremetal,amd,…` (kein intel), prod2 = `baremetal,intel,…` (kein amd); GitLab-Tags sind UND-Bedingungen.
- Verankert als Task **#37 [PMC-DOKTRIN, FEST]** + **Ledger §66-Nachtrag-2**; Lane-Gate in den emittierten Mess-Batches = harte **G4a-Auflage (#34)**.

**E3 — I2-Scope (4 Entscheidungen)**: (1) **FingerprintFn injiziert** (Option a) statt Orchestrator-dlsym — Orchestrator bleibt achsen-blind/load-frei/deterministisch; **Auflage: Pflicht-Drift-Beweis** (Facade-Fingerprint == `sha512_line` einer real gebauten DLL, weil B3-Vektor nur Primitiven-, nicht per-Binary-Gleichheit deckt). (2) variant_sig **muss** durch die eine A6-Primitive (keine zweite Wahrheit). (3) Env-Format: **getrennte Vars im Haus-Stil** statt Pipe-Kodierung; Endpoint ueber bestehende minio-Naht. (4) Scope schlank: I2 = fingerprint + facade-env + variant_sig; Director-Naht → **G4a**; Spool → **I2b**.

**E4 — variant_sig-Quelle: Zirkularitaets-Verbot** (Korrektur am Agenten-Gegenvorschlag): Per-DLL-Makro-Emission (a) und dlsym aus der Alt-DLL (b) scheiden aus — die Expected-Seite kaeme aus der Alt-DLL selbst → Vergleich gegen ihr eigenes Sidecar, **ISA-Mismatch prinzipiell unentdeckbar**, Gate waere wirkungslos aber gruen. Stattdessen **compile-time-Tabelle ueber die Registry-Typlisten** (A6-Primitive laeuft einmal beim Driver-Compile), Stored-Seite bleibt A7-Sidecar. **Stopp-Ausweg (c)**: lieber Gate aus als Zweitwahrheit.

**E5 — §66-Nachtrag-3 umgesetzt** (aus U5): Ledger-Nachtrag (KERN=Gesetz) + Memory `feedback_no_std_variant` erweitert; Ist-Verifikation: kein neues Gate-Modul nutzt `std::variant` (2 grep-Treffer = Compliance-Kommentar + bekannte §23-Quarantaene-Altinsel, latent, Aufraeumen = Task #52). **Bindende I2-Auflage:** Registry-Tabelle einmal CT instanziiert, Facade-Lookup RT→RT ueber vorberechnete Werte, kein visit/Tag-Dispatch; `compose_variant_signature` behaelt je Achse eigene diskrete Klammer-Komponente; Einhaltung im Paket auszuweisen.

**E6 — Folge-B: Manager-Hinweis widerlegt, dann Praemissen-Korrektur**:
- Agent widerlegte Manager-Hinweis ("Emitter loest simd_id→SE-Wrapper auf" = **falsch**): Zell-Walk loest `simd_id` → `-march`-**String** (nicht → axis_09b-Typ); Mess-Unter-Achse `cm::SimdAvx2Option` (nur `simd_id()`+march) und Build-Achse `Avx2SimdExtension` (`name()="simd_ext_avx2"`, ISA-Properties) sind **zwei getrennte, nicht code-verlinkte Typ-Familien**. Zusatzbefund: Voll-Bau emittiert `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC` (system-blind, 17 Organ-Achsen) → Voll-Bau-DLLs tragen **gar keinen** PT/SE/HW-Variant-POD; `-march` steckt **nicht** im Fingerprint.
- Manager bestaetigte zunaechst **(A) Driver-Config-ISA-Gate**; Agent widerlegte auch dessen Praemisse ("genau ein Wrapper enabled"): CMakeCache zeigt **alle 8 SIMD, alle 3 Plattformen, 6 Page-Types enabled** → single-POD nicht wohldefiniert (`mp_front` = willkuerlich) und Gate wuerde **nie feuern**.
- **Finale Entscheidung: MENGEN-Signatur** ueber die drei Enabled-Typlisten, je Achse separat geklammert (§66-N3 Punkt 4), deterministisch konkateniert; Gate feuert genau dann, wenn per-Maschine restringiert enabled wird.

**E7 — Lager-Schluessel-Luecke (§62-Nachtrag-4)**: Der SHA512-Fingerprint traegt die per-Zelle-ISA nicht → zwei Builds derselben Permutation mit verschiedenem `-march` haetten **denselben Lager-Key** → Falsch-Dedup. Lane B erweitert `BestandEintrag` um Zell-Koordinaten (combo/opt/simd als **getrennte** Struktur-Felder, runtime-Strings, keine Typ-Aufloesung), Syntax-Versions-Bump + Zwei-Eintraege-Test.

**E8 — Folge-A Naht: Seam-only** (GO): T3 als Seam im bestandslog-Modul, **Iterator/Facade unberuehrt**; die Verdrahtung bleibt der Integrations-Scheibe. `binary_id→key`-Deriver bleibt Host/Lane-A.

**E9 — Folge-B-Verdrahtung: GO fuer "Vorschlag A" mit enger Scope-Ausnahme** (2 additive Iterator-Zeilen) — vom Agenten selbst zu **C** korrigiert, weil Lane B den Iterator doch editiert; Manager akzeptierte die Selbstkorrektur ("mein A-GO hatte sich gekreuzt").

**E10 — I2b ENTFAELLT (§66-Nachtrag-4), G4a zieht vor** — Entscheidung "Vorschlag 3 modifiziert". Begruendung (Agent, hart belegt): Der Orchestrator schreibt die Binary **nie** selbst (`build_orchestrator.hpp:510 r.status = compile_(job)` extern; `:750 rf << "-o \"" << job.output.string() << "\"\n"`); die Bytes liegen zu keinem Zeitpunkt im Prozess. Binary-Spool waere Pessimierung: (a) zusaetzlicher Voll-Read + Voll-Write je Binary, (b) bis 256 MB `kMaxSpoolBytes` im RAM-gegateten Parallelbau (frisst genau das Budget, das die Bau-Parallelitaet begrenzt), (c) bricht die Invariante "job.output existiert unmittelbar nach compile" (Basis von `dll_is_current`, W11-Push-Pump, Sidecar-Schreibern). N-13-Kern bereits realisiert via B6 + W11-Async-Push. **Sidecar-Spool (Variante 1b)** = Phase-4-Optimierungs-Merkposten (im Voll-Bau-4 inert, da dort gepusht wird).

**E11 — G4a-Entscheidungen D1–D4**: **D1 = PRUNE ans MESS-Batch-Ende** (nicht Bau-Ende; Bau- und Mess-Batch teilen `resource_group ceb-measure-<host>`, Prune am Bau-Ende haette den Mess-Batch zum vollen `cache_pull`-Rueckweg ueber Netz gezwungen); **D2 = Prune nicht-fatal** (fehlgeschlagener Prune laesst Artefakte stehen = sicherer Ausgang); **D3 = GIT_CLEAN-Exclude in BEIDE Batches**; **D4 = PMC-Preflight hart in beiden Profilen** (Sinn von §66-N2) + TRIES-Ergaenzung.

**E12 — G4a Punkt 7 Abweichung akzeptiert**: `planer_block`-Reservierung **nicht** im Director (reiner Text-Emitter, byte-determinismus-getestete `construct()`-Walks; IO dort wuerde die Reinheit zerstoeren und `construct()` umgebungsabhaengig machen; der einzige Host ist `profile_run_facade.cpp:687` im Super-Treiber = ausserhalb Scope). Gebaut wurde die **Wert-Haelfte** `make_planer_block_reservation(...)` (typ=planer_block, slice 0/0, status=offen, uhrfrei) — vollstaendig testbar; Host-Schreibaufruf = eigene Scheibe (G4b).

**E13 — Scrub-Doktrin-Entscheidungen**: github-super **bewusst nicht** mitgepusht bei `68349051` (dort lag noch unredigierter Praescrub-Stand, non-FF, Force nur mit je-Repo-GO); Object-Purge/refs/pipelines bewusst belassen (Messdaten-Doktrin); Cluster-git explizit **aus jedem Scrub-Scope ausgenommen** (Vault-Heimat, intern-only); Branch-Renames (development→dev, main→prod) + Apache-Metadaten bewusst **hinter** den Voll-Bau-4-Trigger gelegt (wuerden mitten im Gate alle CI-Regeln brechen).

---

### (c) PAKETMELDUNGEN / ABNAHMEN / COMMITS (chronologisch)

| # | Paket | Agent | Verifikation (literal) | Commit |
|---|---|---|---|---|
| 1 | **G5 P-B Pruning** (artifact_cache prune_verdict/prunable_artifacts, PRUNE_ONLY-Treibermodus, inkrementelle mc-mirror-Hydration) | Impl-G3-P2 | CE ctest **312/312**; Byte-Wachen gruen ohne Update (#286/#296/#297/#186); cf22 exit=0; messung_driver linkt in build-i2 | ce `f7fa30ef` + super `206ae46` |
| 2 | **A4** (G2-1b POD 88→136, Layout 4→5, drei {ptr,count}-Entry-Arrays, `stamp_pod_has_entries` Loader-Gate, `stamp_entries_ptr<N>`) | Impl-S6-P1 | ctest **313/313**; Byte-Wache ohne Update (Makro-Call 4-Literale byte-identisch); CRC golden `0xF1C1F26A1232073B` unberuehrt; cf22 exit=0; ASCII-Check leer; 4 files 147+/21− | ce `ad11140d` (`feat!`, ABI-Bruch ausgewiesen); Smoke **12759 = SUCCESS** |
| 3 | **I1b** (planer-getriebener Bau, Slice-Reservierungen, Determinismus-Beweis) — B-Seite komplett (B1–B7, I1, I1b, G5) | Impl-G3-P2 | 313/313, byte-neutral | ce `2ad563f0` |
| 4 | **A5** (ceb_version_stamp.hpp NEU 110 Z., consteval-Mess-Array + SHA512 via `anatomy_fingerprint_hex("","",mess,"")`, CEB-Log-Kopf) — **Lane A komplett A1–A7** | Impl-S6-P1 | ctest 313/313; **Drift-Guard** `EXPECT_EQ(kCebMeasurementStamp, measurement_stamp_line_full_set())` gruen; echte App-Ausgabe belegt; cf22 exit=0 | ce `f2063357` + super `357c3f3` (Meilenstein #36 ✔) |
| 5 | **PMC-Reaktivierung** | Manager | Probe **12757**: `pmc:intel=success` + `pmc:amd=success`; Push-Pipeline **12769** | ce `194dee57` → supersediert von `57dc0245` |
| 6 | **I1c** (CEB↔vendored liburing, apps/cache_engine_builder/CMakeLists +16, beide Backend-Varianten bauen) | Impl-G3-P2 | portable + io_uring je reconfigure/build exit=0 (44 Refs auf `comdare_vendored_liburing`); ctest 313/313; Tree auf portable zurueckgesetzt | ce `27455b4e` |
| 7 | **Buchhaltung** (Nachmittags-Session-Doc, 18 Gate-Scheiben, PAT-Rotation, PMC-Doktrin, Ledger-Nachtraege, Gitlink) | Manager | — | super `e374516` |
| 8 | **Pause-Handover-3** + Sofort-Pause-Addendum | Manager | — | super `8046644`, dann `c1f75cf` |
| 9 | **I2 komplett** (Teil 1 .fingerprint-Plumbing; Teil 2 Kern `lazy_adhoc_fingerprint_for` / `make_lazy_adhoc_fingerprint_fn_from_env`, gated auf `COMDARE_BESTANDSLOG=true`; **Drift-Beweis a3**: parst emittierte Stempel-Zeilen aus `COMDARE_ANATOMY_VERSION_STAMP(...)`, runtime-sha512 == Provider — ohne DLL-Bau) | Impl-S6-P1 | ctest 313/313; Byte-Wache ohne Update; CRC-Anker unberuehrt (`source_catalog.hpp:168`); cf22 exit=0; 5 files 138+/7− | ce `d8ead0a8` + super `4494b35` |
| 10 | **Vendor-Fix** (liburing .gitignore) | Manager | Pipeline **12783 = SUCCESS** | ce `bbd5915a` |
| 11 | **Recovery-Commit** (N3-Restore + Handover-4 + Gitlink) — **nur nach origin** | Manager | super lokal hart auf Scrub-Stand `d6c06ef8` | super `68349051` |
| 12 | **Folge-B** (Mengen-Signatur: `build_variant_set_signature.hpp` NEU 200 Z. consteval Zwei-Pass, `driver_build_variant_signature.hpp` NEU 55 Z., 3 additive Achsen-Feldleser in `build_variant_definition.hpp`, Test +245) | Impl-S6-P2 | Vollbau exit=0; ctest 313/313; 5 neue G2-Suites OK; Byte-Wachen #296/#297 ohne Update; cf22 exit=0 | ce `f6144859`; Pipeline **12913 = success** |
| 13 | **Folge-A** (T1 object_fetch/store/remove/stat + ObjectMeta + mc_rm; Binder `artifact_cache_transport.hpp` NEU 55; T2 `lager_contains`; T3 `lager_presence.hpp` NEU 88 Seam-only; **§62-N4 ZellKoordinaten/LagerKey**, Sha512Index→LagerIndex, Dokument-Syntax 1→2, kSemanticsVersion bleibt 1) | Impl-G3-P3 | eigene 8 Suiten gruen; voller ctest **315/315** (313+2); Byte-Wachen ohne Anpassung; cf22 exit=0 (15 Dateien); 12 files 661+/85−, 4 neue Dateien | ce `bb35074d` (+ Facade-Commit `COMDARE_VARIANT_GATE`) |
| 14 | **super-Push-Runde** (Ledger §66-N4 + Gitlink; dev + main auf beide Remotes, alle Diplom-Repos) | Manager | super `4f604cbe`, ce `bb35074d` (main FF `8a3a58c9..bb35074d`), prt-art/dedup/MergeHash aktuell; github-super **force-with-lease** gegen Alt-Leak-Refs | — |
| 15 | **Thesis-Einbindung** (Klon nach Research/ + Submodul in super/Code/external/) | Manager | dev+main auf beiden Remotes | super `e76989bd` |
| 16 | **G4a** (alle 8 Punkte, 4 Dateien 368+/7−) | Impl-S6-P2 | Vollbau exit=0; ctest **315/315**; Facade separat gelinkt; cf22 exit=0; Codegen-Byte-Wachen (#18/#295/#296/#297) ohne Update; ASCII-Check leer | ce `f3a6e68d` (`feat!`) + super `6006fbab` (Gitlink) |

**Zwischenmeldungen/Abnahme-Vermerke:** A4-Smoke 12759 success (POD-136-ABI-Bruch End-to-End CI-bewiesen); G4a-**Block-2-Zwischenstand** mit vollstaendiger Pin-Abrechnung (PIN 1 `:1376` GIT_CLEAN_FLAGS um `-e Code/measure_out` erweitert + neue Negativ-Wache; PIN 2 `:1744` von Substring-Verbot auf `export COMDARE_ARTEFAKT_TRIES=1` praezisiert + Positiv-Wache — **netto strenger, kein Pin aufgeweicht**).

---

### (d) FEHLER + FIXES

1. **Gekreuzte Idle-/Auftrags-Meldungen** (mehrfach, Impl-G3-P2 und Impl-S6-P1): Auftraege lagen bereits in der Mailbox; Manager quittierte jeweils ohne Neuzuweisung. Kein Datenverlust.
2. **liburing-Vendoring-Defekt (B7)** → Pipeline **12778 rot** (auch 12773; zwei weitere von Folge-Pushes auto-gecancelt): upstream-`.gitignore` im Snapshot schloss die `./configure`-generierten Header (`compat.h`, `io_uring_version.h`) vom Commit aus — lokal vorhanden (daher lokal alles gruen), im CI-Checkout fehlend → `test:unit` brach am Vendor-Target. **Fix ce `bbd5915a`**: Vendor-`.gitignore` entfernt (in einem Snapshot funktionslos, nachweislich schaedlich), beide Header committet, Provenienz-Vermerk. Ehrlich verbucht: im schnellen Scheiben-Takt wurde nicht jede ce-Push-Pipeline bis Terminal verfolgt. Fix-Pipeline **12783 = SUCCESS**.
3. **Manager-Hinweis zu Folge-B falsch** (siehe E6): zwei unverlinkte Typ-Familien + system-blinde Voll-Bau-DLLs. Vom Agenten literal widerlegt, Manager nahm die Korrektur an.
4. **(A)-Praemisse "genau ein Wrapper enabled" widerlegt** (alle 8 SIMD / 3 Platforms / 6 PageTypes ON) → Umstieg auf Mengen-Signatur.
5. **Zwei Vollbau-Abbrueche von Impl-S6-P2** (11 bzw. 2 Ziele) — **ausschliesslich** an `LagerRunState::observe()` / `Sha512Key→LagerKey`, d. h. Lane Bs Zell-Koordinaten-Umbau im **geteilten** Working-Tree; keine eigene Datei/Symbol in den Fehlerketten (grep-Zaehlung 0); dritter Lauf exit=0. **Lehre verbucht: im geteilten Tree ist ein Vollbau-Fehlschlag erst nach Wiederholung ein echter Befund.**
6. **Eigen-Korrektur Vorschlag A → C** (Impl-S6-P2): "konfliktfrei, fasst sonst niemand an" war **falsch** — Lane B editierte `cache_engine_builder_iterator.hpp` doch (8+/1−, u. a. 6. Parameter `cfg.bestand_zelle` in `lager.observe()` :963). Vorschlag A erst nach Lane-B-Freeze.
7. **Ungemeldete Facade-Aenderung im Tree** (`profile_run_entry.hpp` +16/−3, VARIANT_GATE-Wiring von Lane A trotz gemeldetem Freeze) — von Lane B entdeckt und gemeldet; Manager loeste das Commit-Race mit **ausgewiesener Autorenschaft** auf ("beide Agenten meldeten es unabhaengig — das Protokoll traegt").
8. **`-Wmissing-field-initializers`** durch die neue `zelle`-Position → vom Agenten beseitigt statt stehengelassen.
9. **Selbstgefundener Testfehler (G4a)**: erste Fassung der Reihenfolge-Wachen prueft **global** ueber die ganze YAML → falsch bei mehreren Lanes (Prune der amd-Lane steht vor der letzten Messung der intel-Lane). Test wurde rot, korrigierte sich selbst → Wachen schneiden die YAML jetzt in **JOB-BLOECKE**; zusaetzlich aktives Verbot, dass ein **Bau**-Batch `COMDARE_PRUNE_ONLY` enthaelt (verworfene D1-Variante ausgeschlossen, nicht nur unterlassen).
10. **Zwei Korrekturen an Manager-Literalen (G4a)**: (i) `[ "$COMDARE_STORAGE_CACHE" = "true" ]` haette unter `set -euo pipefail` bei ungesetzter Variable den **ganzen Batch** abgebrochen → emittiert wird `if [ "${COMDARE_STORAGE_CACHE:-}" = "true" ]; then …; fi`, plus Test gegen die ungeschuetzte Form; (ii) Platzierung **innerhalb** des `- |`-Blocks statt als `- `-Zeilen, weil eine YAML-Plain-Scalar-Zeile mit `" #"` als YAML-Kommentar abgeschnitten wird.
11. **Nebenbefund `scalable`-SIMD** (kein Defekt): sve2/rvv/cuda_gh200 erscheinen mit `simd_width_bits=18446744073709551615` — Ursache `axis_09b_simd_extension_sve2.hpp:27 vector_width_bits() { return -1; }`; uint64-Cast identisch zu A6 seit jeher. Als **Band-C-Merkposten** (eigener Sentinel) verbucht.
12. **mtime ehrlich 0** (Folge-A): `ObjectMeta.mtime_epoch_s` = 0 == unbekannt; mc-stat-Naht parst nur `size`; kein Phantom-Wert, im Header festgeschrieben.
13. **Absturz + Fremd-Scrub-Recovery**: Beim Wiederanlauf fehlte der **§66-Nachtrag-3 im Scrub-Rewrite** (war beim Absturz uncommitted) → aus dem lokalen Tree extrahiert (kamdi-frei geprueft) und restauriert. Fruehere "Master-PW live"-Meldung war ein **awk-Zaehlfehler** (91 Treffer = False Positives auf interne Namen; echte Secrets bereits gescrubbt, 59 REDACTED-Marker). Beide Agenten mit dem Absturz tot → Neu-Spawn als **Impl-G3-P3** / **Impl-S6-P2**.
14. **github-Push-Fehler der drei kleinen Repos**: global `credential.useHttpPath=true`, super/ce hatten lokal das `false`-Haus-Muster, den drei anderen fehlte der Override → identisch gesetzt, Pushes gruen.
15. **Tags-Force griff zunaechst nicht** (lokale Tags zeigten noch Alt-Objekte) → erst `git fetch origin '+refs/tags/*:refs/tags/*'`, dann Force — alle 5 github-super-Tags auf die gescrubbten origin-Objekte gesetzt.
16. **Scanner-Heuristik-Rauschen** (Giga-Scrub): eigene Vault-Wert-Extraktion ergab 190–1090 Datei-Treffer = Woerterbuch-Kontamination; erkannt, dass eigene Heuristiken der falsche Weg sind → autoritative Verfahrens-Docs lokalisiert.

---

### (e) OFFENE FAEDEN AM CHUNK-ENDE

**Unmittelbar in-flight:**
- **G4a-Abnahme laeuft** — letzte Assistant-Zeile vor dem Kontext-Umbruch: "G4a komplett gemeldet — die Punkt-7-Abweichung … ist architektonisch genau richtig begruendet. Eigene Abnahme-Laeufe:" (Abnahme-Kommandos noch nicht ausgewertet). Laut Summary danach als ce `f3a6e68d` gelandet.
- **Final-Smoke 12923 laeuft** (Watcher `bllzyf3vl`) — **Pflicht**, weil vier G4a-Punkte die emittierte YAML unbedingt aendern (Storage-source, PMC-Preflight, Prune-Block, Artefakt-Glob). Agent nannte explizit als sehenswert: PMC-Preflight auf **beiden** Lanes gruen (hart!) und Prune-Block bei ungesetztem `COMDARE_STORAGE_CACHE` wirklich no-op.
- **Fix A (Prune-Regression) IN BAU** bei Impl-S6-P2 (msg `85a81c8a`): push erfolgt unter suffigierter `build_version` (`m3v2+cxx=..+opt=..+ext=..`), prune-only sucht unter nacktem `m3v2` → **garantiert wirkungslos**; Fix = Praefix aus lokaler `perm.dll.version` lesen + Regressionstest + Kommentar-Korrektur.
- Watcher `bu8j44fbm` (bb35074d-Pipeline), Cron-Wache `bpuwq6fyp`.

**Vom Manager unmittelbar zu erledigen (User-Auftrag offen):**
- **Cluster-Verfahrensdocs lesen** (letzter Tool-Call war nur deren Lokalisierung): `/home/comdare/Projekte/Cluster/docs/sessions/2026-07-22-GIGA-SCRUB-AUSFUEHRUNGS-DOSSIER.md` (202 Z., "die Autoritaet") + `.../2026-07-22-GIGA-SCRUB-FP-WHITELIST.md` (161 Z.).
- Daraus verfahrens-konformes **Phase-B-Programm** ableiten (kuratierte Klassen statt PAT-Praefixe, `--invert-paths`-Scope, Blob-Set-Verify, REGEL 4/5) mit Fenster-Empfehlung **nach** Voll-Bau-4-Trigger (Rewrite wuerde CI/Gate re-rooten) — dem User vorlegen.
- **Rueckschreibe-Report an den Infra-Agenten ins Cluster-Repo (PFLICHT, noch nicht geschrieben, gitlab-only).**

**Gate-Restweg (Reihenfolge):** G4a-Abnahme → Final-Smoke → **G4b** (planer_block-Host-Schreibaufruf im Super-Treiber, mit Auflagen L1 PromiseGuard-Terminalitaet + L2 stabile id `owner_uuid + "/plan/" + doc`) → drei Beweise (**Resume-Skip** GN_DECISION, **Hydration-Smoke** mit `verified>0` UND `pruned>0`, **Variant-Gate-E2E** provision-only ± Gate + Voll-Skip) → **Trigger Voll-Bau-4** (POST /projects/288/pipeline, ref=development, NUR `COMDARE_BUILD_GOLDEN_N=true`; df-Wachen + Cron-Wache).

**Explizit vertagte/gemerkte Punkte:**
- **(A)** generische ArtifactCache-Objekt-per-Key-API + LagerRunState-Accessor → **erledigt in Folge-A**; **(B)** variant_sig → **erledigt in Folge-B** (Mengen-Form).
- **Sidecar-Spool 1b** (~500k gebuendelte Mini-Writes, konservative Crash-Richtung) = **Phase-4**-Optimierung.
- **scalable-SIMD-Sentinel** (statt uint64-Max) = **Band C**.
- **Facade ist `EXCLUDE_FROM_ALL`** = Vollbau-Blindfleck → per G4a Punkt 8 in `COMDARE_TEST_PREBUILD_TARGET` aufgenommen, CI-Verifikation offen.
- **github/thesis-main divergent** (Overleaf-Linie `c2d3c51e` + alter `overleaf-2026-06-22`-Branch) → Merge, **nie rebase**.
- **Branch-Renames** development→dev / main→prod + Apache-Metadaten: bewusst **nach** dem Voll-Bau-4-Trigger.
- **refs/pipelines/Object-Purge** bewusst belassen (Messdaten-Doktrin); Pre-Scrub-Bundles + lokaler Backup-Tag nie loeschen/pushen.
- Agenten-Status am Ende: **Impl-S6-P2** FREEZE nach G4a (danach Fix A), **Impl-G3-P3** Standby fuer den Hydration-Smoke.