# UMSETZUNGS-DOSSIER #46a+#53 — Minimal-Cache (minio+Stempel-Lookup) + CI-Durchsatz (2026-07-21)

> ultracode-Planungs-Workflow wf_fee416ef-283 (3 Analyse-Agenten + Synthese, 479k Tokens, alle Belege datei:zeile).
> MANAGER-VERDIKTE (Fable, vor Impl-Start):
> V1: Scheiben-REIHENFOLGE = S4 (docs-only-Gate, sofortiger Durchsatz-Gewinn) -> S1 -> S2 -> S3; S5 bleibt INFRA-GATED (Runner-Ist 18.9.0 < 19.1.1, live belegt).
> V2: DOSSIER-KORREKTUR S4: die Zeile "development => IMMER volle Pipeline" verfehlt das User-Ziel (unsere docs-Wellen SIND development-Pushes). ENTSCHEID: docs-only-Gate WIRKT auf development (changes-Allowlist inkl. Gitlink-Pfaden); NUR main laeuft immer voll (Release-Beweis). Doktrin-Auslegung: "gesamte Pipeline hart gruen" bezieht sich auf den CODE-Stand — ein docs-only-Commit aendert keinen Code, der Beweis der Vorwelle bleibt gueltig.
> V3: last-writer-wins ohne Locks fuer parallele PUTs = ABGESEGNET fuer #46a (gleicher Key => deterministisch identische Bytes; 409=additiv-ok-Doktrin; Claims kommen in #46b). Dem User gemeldet, Einspruch moeglich.
> V4: build:clang-needs NICHT anfassen (nur dokumentieren); kTierChunkCount bleibt 4 (Chunk-Tuning = eigenes Increment, KEINE Marker-Kaltstellung jetzt); algo_sig bleibt Sidecar (kein Key-/Layout-Bruch); +mrg-Reserve JETZT (V-Invalidierung vermeiden).
> V5: Runner-Fragen der Analyse sind LIVE BEANTWORTET: prod1 traegt amd64+avx2+avx512f(+alle Flag-Tags), prod2 amd64+avx2 (API 21.07.); Smoke 11991 laeuft 3-Combo/48-Build; 29 pending war Slot-Stau, nicht unschedulebar.

UMSETZUNGS-DOSSIER Paket #46a+#53 (Ledger §63-Nachtrag: CI/Caching VOR dem 320er)
Kadenz: 5 Scheiben, je einzeln verifizierbar, Dual-Weg, cf22, golden-neutral (INERT-by-default). Reihenfolge ist bindend: S1 muss vor jeder produktiven Bucket-Befuellung liegen (Key-Erweiterung invalidiert Bestand — heute folgenlos, da Remote-Skip wegen fehlendem .algos nie greift).

════ (1) SCHEIBEN-SCHNITT ════

SCHEIBE S1 — Push-Vollstaendigkeit + Key-Haertung (reine ce-Aenderung, kein Pull)
- artifact_cache.hpp:128-153 push_tier_binary: perm.dll.algos in den PUT aufnehmen. Reihenfolge HART: perm.dll → perm.dll.algos → perm.dll.version ZULETZT (Vollstaendigkeits-Marke bleibt letzte). Ohne das ist jeder Remote-Treffer wirkungslos (Organ-Gate build_orchestrator.hpp:242-246; AlgoSigFn produktiv IMMER gesetzt, profile_run_facade.cpp:441-446/806-811).
- artifact_cache.hpp:122 cache_key_prefix (designierte W12-B-Single-Source-Naht, :116-121): Key gemaess Abschnitt (2) erweitern (+ceb, +mtool, +mrg-Reserve). Push UND kuenftiger Pull ziehen NUR von dort — kein Key-Drift.
- .gitlab-ci.yml:856-858: Whole-Chunk-Marker um algo_sig-Feld ergaenzen (geplantes Format :843 wurde beim Scharfschalten verloren); HIT-Pfad :759-799: algo_sig-Mismatch ⇒ Marker ignorieren = MISS, nicht pullen. Alte Marker additiv stehen lassen (nie loeschen).
- on_binary_done um b.skipped-Filter ergaenzen (build_orchestrator.hpp:280, vgl. profile_run_entry.hpp:277-289), damit Hits nicht re-gepusht werden.
- Tests: tests/unit/test_s5_artifact_cache_bounded.cpp + test_w11_async_push_pump.cpp erweitern (3-Objekt-Push, Reihenfolge, key-Montage-Stringgleichheit); neuer Unit-Test fuer cache_key_prefix-Segmente.
- Byte-Wachen: KEINE Aenderung an emittiertem .cmake-/YAML-Text (Emission bleibt reine Funktion der XML) ⇒ CMakeTextIsByteDeterministic/YamlIsByteDeterministic/':chunk3'-Pins (test_experiment_plan_director.cpp:479-501, 676-697, 900-912) unberuehrt; CRC 0xF1C1F26A1232073B ist Compile-Time-Guard, nicht betroffen.

SCHEIBE S2 — Pull-Faehigkeit: pull_tier_binary + Bulk-Hydrations-Phase
- artifact_cache.hpp: pull_tier_binary(bin_dir, …) als Spiegel zu push_tier_binary (mc cp remote→lokal via run_argv). Uebernahme NUR wenn perm.dll.version remote existiert (invertierte ZULETZT-Pruefung = Vollstaendigkeits-Marke); lokal .version ZULETZT schreiben. EIGENES Timeout-Budget (1-2 tries, ~15s max-time) statt Push-Defaults (tries_=12, 120s). Fehlerdoktrin wie Push: ArtefaktIo-Log, kein throw, Miss ⇒ bauen.
- Andock-ENTSCHEID: Option (a) — designierter PULL-HOOK cache_engine_builder_iterator.hpp:769-777, Batch-Hydrierung minio→output_dir/<stem>/ VOR provision_all via cfg.cache_pull. Begruendung: Option (b) per-Binary in provision_core = mc-Prozess-Spawn ×2^17 + Netzabhaengigkeit von dll_is_current-treibenden Unit-Tests (test_kf16b, test_w6). Korrektheit entscheidet danach weiterhin AUSSCHLIESSLICH lokal dll_is_current (build_orchestrator.hpp:231-249) — grober False-Pull bleibt korrektheits-sicher (von YAML :760-761 bereits sanktioniert).
- Pull MUSS alle drei Objekte holen: perm.dll + perm.dll.algos + perm.dll.version.
- Async-Doktrin unveraendert: Miss⇒Bau⇒async-PUT laeuft im provision_only-Modus bereits ueber den AsyncPushPump (W11, keine neue Naht); Mess-Modus-PUT bleibt synchron (iterator :1042-1052); Drain-Reihenfolge close() VOR Whole-Chunk-Marker (:829-836) NICHT umstellen.
- _gn_chunk_markers-Namensraum aussparen: bewusst pruefen, dass orch_make_stem nie '_gn_chunk_markers' erzeugt (sanitisiert, behaelt '_').
- Tests: Unit-Test mit mc-Stub via COMDARE_MC_BIN (Hit/Miss/Halb-Push ohne .version/Mismatch-.algos); Negativ-Test: unkonfiguriertes Env ⇒ inert(), kein Prozess-Spawn.
- Golden-Neutralitaet: cfg.cache_pull default aus ⇒ byte-neutral; scharf nur via CI-Template/Env.

SCHEIBE S3 — Bare-metal-Env-Kontrakt (Dual-Weg §61)
- Neues source-bares sh-Skript (kein Python, Buildchain-Doktrin) als Gegenstueck zu .storage_cache_activation (.gitlab-ci.yml:446-476): S3-URL → MC_HOST_<alias> → COMDARE_MINIO_ENDPOINT=<alias>. Ablage: ce scripts/ (Engine-Seite, da from_env() der Konsument ist; super referenziert nur), Einbindung nach prod1-Env-Setup-Konvention.
- Dokumentiert werden NUR Env-NAMEN, nie Werte: MC_HOST_<alias>, COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX, COMDARE_MC_BIN/CURL_BIN, COMDARE_ARTEFAKT_*, COMDARE_MEASUREMENT_DROP_URL, COMDARE_NFS_DROP_TOKEN/_USER. Sicherheits-Invariante: Creds nie in argv/ps/Log (MC_HOST-Env + 0600-curl-config einzige Traeger, artifact_cache.hpp:75, :210-243).
- Verifikation: Lauf auf prod1 mit gesetztem Env, literale Ausgabe (kein ✓ ohne Output).

SCHEIBE S4 — #53 docs-only-Gate + Trigger-Gates + ccache-Hygiene (nur super-.gitlab-ci.yml, handgeschrieben ⇒ beruehrt keine ce-Test-Pins)
- Diffs siehe Abschnitt (3). Umfang: .code-rules-Template auf die 8 Code-Jobs + verify:submodules + ALLE Dependents (Variante a — Gruppe faellt gemeinsam, DAG bleibt gueltig; :197-215 + needs-Referenzen :221,:243,:272,:309,:360,:513,:594-595,:727,:1059). lint:secrets IMMER (Ledger-Commits = Token-Risiko-Klasse). thesis:pdf NICHT code-gaten (docs-Konsument). Mess-/Planer-/persist-Jobs NIE zusaetzlich gaten (bereits var-inert).
- ccache-Hygiene: `cache: { paths: [] }` auf toolchain:probe, verify:submodules, manifest:provenance, prebackup:measurements, thesis:pdf, ergebnis:holen (Muster persist:measurements :924-925); Konsumenten-Jobs auf `policy: pull`, ein designierter Writer (analyse:thesis-data) bleibt pull-push.
- build:clang: `needs: ["lint:secrets"]` (entkoppelt vom Orchestrate-Gate; falls das Gate gewollt war ⇒ nur dokumentieren, nicht aendern — als Frage im MR markieren).
- Verifikation: docs-only-Commit ⇒ nur lint:secrets(+thesis:pdf bei thesis-Aenderung); Gitlink-Bump-Commit ⇒ volle Welle (Pfad Code/external/<repo> matcht Allowlist). Beide Faelle literal per Pipeline-API belegen; Push→gruen.

SCHEIBE S5 (OPTIONAL, infra-gegatet) — interruptible punktuell
- NUR punktuelle interruptible:true auf lint/build/test-Jobs im super-YAML. NIE via default:-Block, NIE auf measure/gn/ceb:trigger/persist (Kaskaden-Kill der Grandchild-Kette bei strategy:depend; 286-Mehrtages-Doktrin). Die drei false-Pins (:506,:588,:690) und emittierten false-Zeilen (experiment_plan_director.hpp:585,794,877) unangetastet.
- Projekt-Setting auto_cancel_pending_pipelines Re-Enable NUR nach verifiziertem Runner ≥19.1.1 (Reihenfolge SESSION-ENDE-3:67; sonst Cancel-Hang) — Infra-Agent, nicht diese Scheibe.

════ (2) OBJEKT-KEY ════

Montage AUSSCHLIESSLICH in cache_key_prefix (artifact_cache.hpp:122). Layout bleibt: <alias>/<bucket>/[COMDARE_MINIO_PREFIX/]<KEY>/<stem>/perm.dll{,.algos,.version}

KEY = <build_version> + "+ceb=" + <COMDARE_ANATOMY_ABI_MAJOR>.<kCebContractCodegenMinor> + "+mtool=" + <sanitisierte _M-Stempel-Kennung der COMDARE_MEASUREMENT_COMBO> + "+mrg=" + <merge_stamp-Segment; heute literal "none" = Reserve>

wobei build_version bereits traegt: m3v2 + "+cxx="+compiler_tag + "+opt="+opt_id + ["+ext="+simd_id] + ["+bt=Debug"] (profile_run_entry.hpp:652-656, build_type_stamp.hpp:20-24).

Entscheide:
- algo_sig NICHT in den Key: bleibt Sidecar perm.dll.algos (byte-kompatibel zum Ist-Layout, .version-ZULETZT-Marke bleibt letzte). HIT nur bei exakter String-Gleichheit von .version UND .algos gegen lokale Erwartung (Semantik identisch dll_is_current).
- +mtool schliesst die _M-Tooling-Kollision (DLL-Bytes aendern sich ohne Key-Wirkung, lazy_adhoc_source_gen.hpp:199-238); Segmente durch denselben Sanitizer wie orch_make_stem.
- +mrg reserviert das K6a-Merge-Stempel-Segment JETZT (verhindert zweite Voll-Invalidierung beim PRT-Paket #37).
- GN_MSYS: sobald >1 Messsystem baut, als weiteres Segment — an derselben Naht.
- YAML-Ableitung GN_PREFIX (.gitlab-ci.yml:751-757, deprecated statische Matrix): KEINE Bash-Reimplementierung nachziehen; stattdessen konsumiert YAML den vom Treiber/Planer gedruckten Key literal (Single-Source C++). Uebergangsminimal, falls Matrix noch laeuft: +bt nachziehen.

════ (3) YAML-RULES-DIFFS (docs-only, MIT Gitlink-Ausnahme) ════

Neu (super .gitlab-ci.yml, vor den Jobs):
```yaml
.code-rules:
  rules:
    # web/pipeline/trigger/MR: changes wertet dort immer true bzw. ist Mess-Trigger — nie gaten
    - if: '$CI_PIPELINE_SOURCE == "web" || $CI_PIPELINE_SOURCE == "pipeline" || $CI_PIPELINE_SOURCE == "trigger" || $CI_PIPELINE_SOURCE == "merge_request_event"'
    # main/development: IMMER volle Pipeline (hart-gruen auf Merge-SHA; geskippt != bewiesen)
    - if: '$CI_COMMIT_BRANCH == "main" || $CI_COMMIT_BRANCH == "development"'
    - changes:
        paths:
          - "Code/**/*"
          - "Code/external/*"      # Gitlink-Bumps ce/prt-art (1-Zeilen-160000-Diff) => NIE docs-only
          - "thesis/diplomarbeit"  # thesis-Gitlink
          - ".gitmodules"
          - ".gitlab-ci.yml"
    - when: never
```
`extends: [.code-rules]` auf: toolchain:probe(:112), build:clang(:120), lint:format(:135), lint:static(:140), test:unit(:151), verify:submodules(:197), analyse:thesis-data(:218), visibility:tier-binaries(:240), integration:smoke(:269), manifest:provenance(:306), prebackup:measurements(:357). NICHT auf: lint:secrets(:130), thesis:pdf(:403), alle var-gegateten measure/gn/planer/persist-Jobs, Bot-Rules :515 unangetastet.

Trigger-Bridges (:165-194), je Bridge eigenes Gate nach demselben Muster, changes-paths spezifisch:
```yaml
trigger:cache-engine:  changes: ["Code/external/comdare-cache-engine", ".gitmodules", ".gitlab-ci.yml"]
trigger:prt-art:       changes: ["Code/external/comdare-prt-art", ".gitmodules", ".gitlab-ci.yml"]
trigger:thesis:        changes: ["thesis/diplomarbeit", ".gitmodules", ".gitlab-ci.yml"]
```
(jeweils mit demselben if-Vorspann + `- when: never`; Gitlink-Bump = Pfad-Change ⇒ nie faelschlich uebersprungen).

Semantik-Hinweis: Allowlist-Konstruktion (nicht Blocklist); neue Branches ⇒ changes=true = volle Pipeline (sichere Richtung). Scope: NUR super-Repo (#53); ce-/thesis-Repos haben die Submodul-Bump-Falle nicht — dort nichts aendern.

════ (4) RISIKEN + GEGENMASSNAHMEN ════

1. Stale-Falsch-Treffer (Organ-/Katalog-Bump ohne base-Bump): HIT nur bei String-Gleichheit .version UND .algos (S1/S2); +ceb/+mtool/+mrg im Key (S1); Marker-algo_sig-Pruefung (S1). CRC-Anker beweist nur Quelle des Commits, nie Herkunft gepullter Binaries — deshalb sind die Sidecar-Gates die einzige Wache.
2. Key-Erweiterung invalidiert Bucket: bewusst akzeptiert, JETZT (vor erstem wirksamen Fill) einmalig und folgenlos; deshalb S1 zwingend vor S2-Aktivierung. Bestand nie loeschen (additiv-Doktrin).
3. Halb-Push/parallele PUTs (prod1+prod2, §61): .version-ZULETZT-Marke deckt Halb-Push; gleicher Key ⇒ mc cp last-writer-wins mit inhaltlich identischen Bytes ⇒ unkritisch im Ein-Wellen-Betrieb. KEINE Locks in #46a (siehe (5)); Annahme im MR explizit absegnen lassen.
4. Netz-Blackhole blockiert Bau-Start: eigenes Pull-Timeout-Budget (1-2 tries, ~15s), Batch-Phase statt per-Binary; inert ohne Env; Unit-Tests ohne COMDARE_MINIO_*-Leck (Test-Fixture cleart Env).
5. Byte-/golden-Bruch: Cache-Logik NUR in Treiber/Env-Naht, nie in emittiertem Text; keine run_stamp/Host-Pfade in Emission ('/home/'-Pins 528/689/985); jede kuenftige rules/chunk-Aenderung der EMISSION nur im Lockstep-Commit mit den gepinnten Tests (943-956, ':chunk3' 900-912). Chunk-Tuning (kTierChunkCount:411) ist NICHT Teil dieses Pakets — falls gewollt, eigenes ce-Increment VOR Cache-Befuellung (Marker-Kaltstellung einmalig akzeptieren, Count+GN_CHUNK-Liste/Test-Pins im selben Commit, Drift-Guard :740-750 beachten).
6. docs-only hoehlt hart-gruen aus: Allowlist + main/development immer voll + Gitlink-Pfade in der Positivliste; verify:submodules faellt nur zusammen mit allen Dependents (DAG bleibt valide, kein 'needs job does not exist').
7. auto-cancel killt Mehrtages-Laeufe: kein default:interruptible, keine trigger-/measure-Jobs; Projekt-Setting nur nach Runner-Upgrade-Verifikation (Infra, ausserhalb dieses Pakets).
8. Mess-Validitaet gepullter Binaries: ledger-konform per §62-D (stempel-gekeytes Sharing), unter zwei Wachen: COMDARE_PLATFORM=<lane>@hostname in CSV-platform-Spalte je Mess-Job; simd-Gate liegt VOR dem dll_is_current-Skip (build_orchestrator.hpp:399-410) und darf vom Pull-Pfad nie umgangen werden.
9. Runner-Realitaet (offen, vor erster Welle per API verifizieren): Tags amd64/avx2/avx512f auf prod1/prod2 (sonst pendeln ceb:*/tier:build strukturell); Runner-Version ≥19.1.1.

════ (5) BEWUSST NICHT IN #46a ════

- Claims/Locks/Sub-Lanes/Arbitrierung konkurrierender Wellen ⇒ #46b (Ein-Wellen-Betrieb ist Annahme dieses Pakets).
- kTierChunkCount-Parametrisierung (Emitter, byte-deterministische Emission, needs-Kanten) ⇒ eigenes ce-Increment mit eigenem GO.
- ccache-Prefix in make_gpp_compile_fn (build_orchestrator.hpp:650-692) ⇒ eigenes env-gegatetes Increment (Mess-Timing/Provenienz-Abwaegung, Fehlerklassen-Pflicht).
- auto_cancel_pending_pipelines-Re-Enable + Runner-Tag-/Versions-Pflege ⇒ Infra-Agent (Cluster reserviert, buildsystem-Doktrin).
- algo_sig in den Objekt-Key (verworfen zugunsten Sidecar — kein Layout-Bruch).
- Voll-Ersatz der deprecated statischen GN-Matrix/Bash-Key-Ableitung ⇒ nur Minimal-Pflege, Abloesung separat.
- Loeschen alter Marker/Bucket-Bestaende ⇒ nie (additiv-Doktrin).
- docs-only-Gates in ce-/thesis-Repos ⇒ ausserhalb des Scopes (#53 = super).

Offene Architektur-Entscheide fuer den User (Klartext, kein AskUserQuestion): (a) Segnung last-writer-wins ohne Locks fuer prod1+prod2-Parallel-PUT; (b) build:clang-needs-Entkopplung vs. gewolltes Orchestrate-Gate; (c) Chunk-Zahl final VOR Befuellung fixieren (ja/nein + Wert).


## OFFENE FRAGEN DER ANALYSE (triagiert, s. Verdikte)

- Andock-Wahl fuer den Remote-GET: grob am designierten PULL-HOOK (iterator :769-777, batch vor provision_all, cfg.cache_pull) oder fein per-Binary in provision_core (build_orchestrator.hpp zwischen :412 und :413, exakt 'Lookup vor jedem DLL-Bau')? Beide sind vorbereitet; die Wahl bestimmt, ob mc einmal rekursiv oder je Binary einzeln laeuft (mc-Prozess-Kosten x 2^17).
- Key-Vollstaendigkeit VOR erstem produktiven Fill klaeren: +ceb=<ABI>.<minor> fehlt im Perm-Pfad-build_version (nur Einzel-Pfad traegt es) und der _M-Tooling-Stempel (COMDARE_MEASUREMENT_COMBO) aendert DLL-Bytes ohne Key-Wirkung — beides in cache_key_prefix (artifact_cache.hpp:122) einfalten? Danach ist der Bucket-Bestand invalide (heute folgenlos, da Remote-Skip wegen fehlendem .algos ohnehin nie greift).
- Soll push_tier_binary um perm.dll.algos erweitert werden (Reihenfolge dll -> algos -> version-ZULETZT)? Ohne das ist jeder Remote-Treffer wirkungslos (Organ-Gate build_orchestrator.hpp:242-246 erzwingt Neubau, AlgoSigFn ist produktiv immer gesetzt).
- Bare-metal-Credential-Weg: dieselbe MC_HOST_<alias>-Konstruktion als source-bares sh-Gegenstueck zur .storage_cache_activation — wo kanonisch ablegen (ce scripts/ vs. super, prod1-Env-Setup-Konvention)? Nur Env-Namen dokumentieren, nie Werte.
- Gilt der Ein-Wellen-Betrieb (keine Locks/Claims) auch fuer den Uebergang Bau-Welle -> Mess-Welle auf mehreren Maschinen gleichzeitig (prod1+prod2 parallel, §61)? Die perm.dll.version-ZULETZT-Marke schuetzt vor Halb-Push, aber zwei gleichzeitige PUTs desselben Keys sind last-writer-wins (mc cp atomar, inhaltlich identisch -> vermutlich unkritisch; bewusst absegnen).
- Runner-Stand: Ist gitlab-runner auf prod1/prod2 inzwischen >= 19.1.1 (Voraussetzung fuer das Re-Enable von auto_cancel_pending_pipelines laut docs/sessions/20260702-INFRA-HANDOVER...:25)? Lokal nicht verifizierbar (Cluster read-only, keine neuere Doku gefunden).
- Tragen prod1/prod2 inzwischen die Capability-Tags amd64/avx2/avx512f? Letzte lokale Evidenz (MATRIX 19.07., .gitlab-ci.yml:698-700) sagt NEIN — dann pendeln ceb:*- und tier:build-Jobs strukturell und die 29 pending in Smoke 11991 waeren teils unschedulebare Jobs, nicht nur Slot-Stau.
- Smoke 11991: Lief die Welle mit allen 3 measurement_tooling-Combos (48 tier:build) oder combo-reduziert? Zu 11991 existiert keine lokale Session-/Plan-Doku; die Zahl 29 stammt allein aus der Aufgabenstellung.
- Doktrin-Klaerung: Vertraegt die 'GESAMTE Pipeline hart gruen'-Direktive per rules:changes NICHT-existierende Jobs bei docs-only-Commits (Skip = Job existiert nicht, kein gelbes Symbol), oder ist ein leichter 'docs-noop'-Ersatzjob gewuenscht?
- Darf kTierChunkCount (experiment_plan_director.hpp:411) profil-/env-gesteuert werden? Das ist ein ce-Emitter-Change (byte-deterministische Emission, Isomorphie-Contract-Tests, needs-Kanten der Mess-Jobs) und braucht ein eigenes GO als Increment.
- verify:submodules-Gate: Variante (a) ganze Code-Job-Gruppe gemeinsam gaten oder (b) verify:submodules immer laufen lassen und nur die schweren Bau-Jobs gaten — User-Entscheid, weil (a) den Gitlink-Determinismus-Check bei docs-only-Commits mit ueberspringt.
- Organ-Provenienz im Cache: soll algo_sig in den OBJEKT-KEY (Marker eindeutig, aber Layout-/Key-Bruch zum Ist) oder als drittes Push-Objekt perm.dll.algos (byte-kompatibel zum Ist-Layout, Marke .version bleibt zuletzt)? Beides erfuellt das Organ-Gate — Architektur-Entscheid noetig vor #46a.
- Merge-Stempel (K6a merge_stamp_line, dritter Tier-Stempel): schon jetzt als (leeres) Key-Segment an der cache_key_prefix-Naht reservieren, oder erst mit dem PRT-/Pruefling-Paket (#37) — Risiko bei 'spaeter': einmalige Voll-Invalidierung des dann befuellten Caches?
- Gilt das #53-docs-only-Gate nur fuer das super-Repo oder auch fuer die ce-/thesis-Pipelines? (Im ce-Repo gibt es kein docs-Verzeichnis-Problem mit Submodul-Bumps, im super-Repo ist es die Hauptfalle.)
- Chunk-Tuning-Ort: kTierChunkCount (Code, dynamische Ziel-Kette, Tests groesstenteils adaptiv ausser ':chunk3'-Pin) oder COMDARE_GN_CHUNK_COUNT (nur die DEPRECATED statische Matrix)? Und: wird die einmalige Marker-Kaltstellung VOR dem 320er explizit akzeptiert?
- auto-cancel-Umfang: Projekt-Setting global aktivieren (erfordert Audit ALLER Jobs ohne explizites interruptible in super+ce+emittierten YAMLs) oder nur gezieltes interruptible:true auf lint/build/test? Betrifft direkt die Belt-and-Suspenders-Annahme in den drei false-Kommentaren.
- Bare-metal-Env-Kontrakt fuer den Dual-Weg-Lookup: soll die .storage_cache_activation-Logik (S3-URL -> mc-Alias 'prodcache') als offizielles Shell-Snippet/CMake-Preset fuer prod1/prod2 dupliziert werden, oder wandert die Alias-Konstruktion ebenfalls in den C++-from_env-Pfad (eine Quelle)?
