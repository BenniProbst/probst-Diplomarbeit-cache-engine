# FAHRPLAN 01.08.2026 — VOLL-BAU-4: 4+1 Beweise, G6/J-Kette, Trigger, heavy-Mode, Vorbedingungen

> QUELLE: ultracode-Workflow vollbau4-fahrplan (4 Fable-xhigh-Leser: Ledger/Bauplan/Sessions/
> CODE-IST + Synthese + adversarialer Verify, Verdikt "tragfaehig-mit-auflagen"; Journal
> wf_91fdd401-17c). Verify-Korrekturen sind EINGEARBEITET. Autoritaet bei Widerspruch:
> Code-Ist > juengste Ledger-Paragraphen (V7.4:95) > Sessions > Bauplan/AUFTRAG (superseded).
> Ledger endet §77 (27.07. ~15:15) — ALLE Ledger-Zahlen zu ctest/Kanal sind aelter als der
> Bau-Tag 27.07. abend (Gate 318, V-3/V-4-Retire, P1, OP-9, E-2); Nachtrag gebuendelt faellig.

## 1. DIE 4+1 BEWEISE (V7.4-Gate-Kette: nach W-13, vor G6; ALLE OFFEN)

| Nr | Was | Gate-Kriterium (literal) | Kommando | Status |
|---|---|---|---|---|
| 1 | Resume-Skip: Wiederaufnahme ueberspringt gebaute Permutationen (GN-Entscheidung) | Log-Zeile `GN_DECISION=skip` | NICHT dokumentiert — aus Code-Ist ableiten | OFFEN |
| 2 | Hydration-Smoke: Lager-Hydration verifiziert + pruned | `verified>0` UND `pruned>0` zugleich; `behalten=alles` = Befund, kein Gruen | NICHT dokumentiert | OFFEN |
| 3 | Variant-Gate-E2E | NUR als Name gefuehrt — Gate-Kriterium unterdokumentiert | fehlt | OFFEN |
| 4 | Bestandslog-E2E gegen ECHTES minio | 2 Prozesse gleichzeitig, Sektion < Budget, Log lesbar; COMDARE_MINIO_ENDPOINT = mc-ALIAS (nie S3-URL — mc-Falle: unbekannter Alias schreibt LOKAL und meldet Erfolg!), Preflight `mc alias list` | lokaler Beweis (CI baut Alias selbst, .gitlab-ci.yml:586-597) | OFFEN |
| +1 (5) | B+-Baum-Steuerungs-Nachweis (E-07) | Gate-Definition FEHLT — vorgelagert: ultracode-Pruefung, OB die Steuerung nach Lane A/C/F + ORG-18 wirksam ist; erst danach Kriterium festlegen | fehlt | OFFEN (2-stufig) |

Quellen: LEDGER:95 (V7.4) + 20260726-AUFTRAG:231-232 (G5) + 20260726-DOSSIER:308-315 +
HANDOVER-5:53-57. ERSTE TEILAUFGABE der Beweis-Strecke: fuer 1-3 die literalen Kommandos aus
dem Code-Ist ableiten (Treiber-/CEB-Subkommandos) und im Ledger nachtragen; fuer 5 die
E-07-Pruefung fahren.

## 2. G6 / J-KETTE (V7.4-Lesart; alte V5.3-G6=Messlauf-Strecke ist SUPERSEDED)

G6 = lokale VOLL-BAU-VERIFIKATION ohne bekannte Luecken, ausgefuehrt als J-Kette:
- J-0: Alt-Build-Dirs sind Beweis-GIFT (frisch bauen oder Binary-Alter pruefen).
- J-1: WERKZEUGE ZUERST, alle mit comdare_-Praefix (Kurzformen sind teils nur phony):
  comdare_adhoc_emitter_cli, comdare_catalog_codegen_cli, comdare_anatomy_codegen_cli,
  comdare_gen_golden_fullpilot (EXCLUDE_FROM_ALL!), comdare_{,measurement_,system_}
  axis_registry_gen (alle EXCLUDE_FROM_ALL; Code-Ist-Anker im Verify belegt).
  comdare_permutation_codegen_cli ist seit V-4-Retire GESTRICHEN (Stale-Anweisung im
  tages-Doc §3 — hiermit dokumentiert widerrufen).
- J-2: RE-CONFIGURE (dort laeuft Codegen; die adhoc-2-Pass-Mechanik registriert erst
  danach f15_compare_cli_smoke + test_v41_anatomy_adhoc_autobuilt_load).
- J-3: comdare_limits_generated_source_catalog explizit.
- J-4: Voll-Bau -> comdare_profile_run_facade explizit -> --target comdare_tests
  (EXCLUDE_FROM_ALL-Tests!) -> Voll-ctest.
- J-5: N IMMER literal mitmelden ("100% passed" ohne N ist kein Beweis).

N-KLAERUNG (Pause-Doc-Vermutung WIDERLEGT): Die J-Ketten-Zahl ist KEINE eigene Zaehlung —
es ist dieselbe ctest-EINTRAGS-Zaehlung des ce-Gates zu verschiedenen Pins:
312(Default-Configure-Luecken) -> 314 -> 316(be827881) -> 317 -> HEUTE 318
(-2 byte_identity V-4, +2 Identitaets-Tests, +1 P1-SPD-Parser). LIVE-BELEG: build-v6
`ctest -N` = "Total Tests: 318". VERIFY-KORREKTUR (wichtig): Die 4 "V32-gegateten" Tests
haengen NICHT an COMDARE_V32_ENABLE (das gated im ce-CMake KEINEN Test — einzige Wirkung
option+INTERFACE-Define, builder/commands/CMakeLists.txt:14-17), sondern an der
J-1/J-2-Werkzeug+Re-Configure-Mechanik (tests/unit/CMakeLists.txt:1481-1527) bzw. sind
unconditional (:1280/:1298). V32=ON bleibt trotzdem KANON (CI ueberall ON: super
.gitlab-ci.yml:188/232/332/667/753/984; emittierte Childs: director.hpp:767/794/1097/1226).

ZWEI-GATE: ce-standalone scharf (0 failed, CRC64-Doppellauf 0x56F1B721C72DC10E — Anker hat
O-8 UEBERLEBT, Beleg c50b56e6 + source_catalog.hpp:190) · super-Integrations-Gate mit
eingefrorener 5er-NAMENSMENGE (Referenz-N nach V-4 neu zu messen; letzte Messung 458/5/453
VOR V-4 — nur die Namensliste ist stabil).

## 3. TRIGGER-PROZEDUR (Code-Ist-belegt)

1. VORHER: heavy-Mode (unten) + Platz-Pflege prod1 (~58-65G Forecast) + github-PAT frisch
   (Vault-Position ROTIERT) + Bestands-Invalidierung — die den E-2-SCHLUESSELWECHSEL
   explizit einschliessen MUSS (ram_pair ddr4_2x32 -> ddr5_2x32, 803b7d71: Alt-Lager-/
   Bestandslog-Eintraege unterm alten Schluessel treffen nie wieder; Verify-Ergaenzung).
2. DER TRIGGER = POST /projects/288/pipeline (ref=development) mit:
   COMDARE_BUILD_GOLDEN_N=true + COMDARE_STORAGE_CACHE=true + COMDARE_BESTANDSLOG=true
   + COMDARE_BESTANDSLOG_DOC_KEY + COMDARE_BESTANDSLOG_OWNER_UUID=$CI_JOB_ID@$(hostname)
   + COMDARE_BESTANDSLOG_MASCHINE. COMDARE_GN_TOTAL=131072 ist super-CI-Default (:77),
   forward-Allowlist ueber beide Trigger-Grenzen (director.hpp:868-871); Kalibrierlauf mit
   =64 moeglich. COMDARE_MEASURE_PROFILE NICHT setzen => all_axes_golden.
   GATE-SWAP §45: GOLDEN_N=true faehrt die DYNAMISCHE Kette (planer:delegate); statische
   Matrix nur mit STATIC_MATRIX_FALLBACK=true (deprecated).
3. KASKADE (Code-Ist .gitlab-ci.yml:939-1048): planer:delegate baut NUR den Treiber,
   `$DRIVER plan ci` (rein lesend) -> Artefakt planer-child-ci.yml -> trigger:include:
   artifact strategy:depend -> STUFE-1-Child (je [a,b,c] ceb:build/emit/trigger; emit ruft
   Subkommando `tier ci`) -> STUFE-2-Grandchild (System-Perms + tier:build-Chunks + Mess-
   Jobs when:manual). Produktiv-Praezedenz: Pipeline 11611 komplett gruen, 16/16 tier:build.
4. UMFANG: 2^17 x 12 System-Perms (O0-O3 x {no_extension,avx2,avx512}) = 1.572.864
   Tier-Binaries SOLL. avx512-Ausschluss NUR maschinenseitig mit WARNUNG
   (HardwareErweiterungFehlt), nie stiller Profil-Filter. Ordnung O3/O2/O1/O0;
   Lager-Skip NUR gruen-inventarisiert (§68b); Dual-ccache minio=Binaries/NAS=CSV.
   LUECKE: Es existiert KEIN konsolidiertes 12-Perm-Trigger-Rezept (historisch 4->8->12;
   offen: COMDARE_GN_INCLUDE_AVX512 noch noetig? Chunk-Zerlegung bei 12 Perms? A6-Profil
   real auf 12 erweitert? -> VOR Trigger am ce-Ist pruefen).
5. AUFLAGEN im Lauf: PMC-AND hart je Lane (Anker GEFUNDEN: ce/.gitlab-ci.yml:45+:102-125,
   pmc:amd prod1 / pmc:intel prod2, kein allow_failure) · mc-Alias-Doktrin · NAS-df-Wache
   beide Hosts · main-Nachzug je Welle · keine schweren Parallel-Jobs · §74: laufender
   Lauf wird NIE unterbrochen.
6. MESSUNG GETRENNT: measure-Jobs INERT (COMDARE_RUN_MEASURE) bzw. when:manual;
   PERSIST_MEASUREMENTS=true nur beim Mess-Trigger; 320er-Abgabemessung NACH Voll-Bau-4
   mit USER-GO. Zaehler "4", weil Voll-Bau-3 (12713) am Stempel-Bruch gecancelt wurde.

## 4. RUNNER-MODE HEAVY (Code-Ist runner-mode.sh v2, Cluster 0d7c577)

Deployed /usr/local/sbin/runner-mode.sh beide Hosts (Aufruf via Infra: ssh root@... 
runner-mode.sh heavy|normal). heavy: concurrent=1 beidseitig; prod1 HEAVY_J=24 (Owner-
Drossel, 16-phys-Kappung faktisch verworfen), prod2 HEAVY_J=nproc=24. Patcht NUR
concurrent + [[runners]]-env (CMAKE_BUILD_PARALLEL_LEVEL, MAKEFLAGS); SIGHUP-ONLY
(kill -HUP MainPID; systemctl restart drainiert Jobs = VERBOTEN); idempotent + literales
Verify. normal (aktuell live, optionC): c=4 @ 4T beidseitig (aeltere 3x10/2x12- und
2x12-Staende superseded; Gruppen-Var CMAKE_BUILD_PARALLEL_LEVEL 26.07. geloescht).
INFRA-Bestaetigung "c=1/24/nproc unstrittig" liegt vor (KONSOLIDIERT-V3-antwort:79-93);
ABER heavy wurde NIE live geschaltet (nur offline/fixture) — Erst-Schaltung ist ein
Infra-HANDOUT + Deploy-Stand-Verifikation (liegt 0d7c577 wirklich auf beiden Hosts?).
Mess-Schutz laeuft NICHT ueber concurrent (P11-Wache + resource_group + 1-Thread-Doktrin).

## 5. VORBEDINGUNGS-CHECKLISTE (Stand 01.08. abend)

ERFUELLT: golden-Neuanker/CRC-Bestaetigung (c50b56e6, Anker unveraendert) · Mess-Rueck-
schreibung-Mechanik (WRITE-Token id=54, inert-by-design) · NAS-CSV-Erstbeleg (D-03, 16
Zeilen, PUT->201) · Stempel-Klammer (RF-7/§70.7, O-8 A8.2/A8.3) · 15.3-Kanon-Flotte ·
[NEU seit Kartierungs-Auftrag] P8-Rest KOMPLETT (beide Zwillinge tier ci/tier cmake) ·
OP-9 built_stem (beruehrt Trigger-Pfad plan ci NICHT) · E-2-Schluessel · V-3/V-4-Retire.

OFFEN (= die eigentliche Beweis-Strecke):
(a) 4+1 Beweise (alle 5; fuer 1-3 erst Kommandos ableiten, fuer 5 erst E-07+Gate-Definition)
(b) J-Ketten-Voll-Lauf mit AKTUELLEM N=318 (Re-Ankerung; V32=ON beide Baeume)
(c) 12-Perm-Klaerung (A6-Profil-Ist, GN_INCLUDE_AVX512, Chunk-Rezept) -> konsolidiertes
    Trigger-Rezept an EINER Stelle
(d) Bestandslog-Luecken-Ist (§65: Ebene-B-Push inert? measure_out-Verlustnaht? minio_enabled-
    Verbuchung HANDOVER-6 P.7) — V7.1 "komplett" vs. §65 ungeklaert
(e) OD-10 NUMA/page-RT-Unter-Achsen (Bauplan TEIL IV.4: NACH Fenster, VOR Voll-Bau-4)
(f) E-04 (CI-Live-Fortschritt+Nachtests) + E-18 (LaTeX-VORWAERTS-Kanal = HAUPT-ZIEL §68c)
(g) HW-Erkennung: P1 GEBAUT; P2-P6 ruhen per Owner-Wort — 5dea1258-Statik-Abloesung
    "VOR 01.08." kollidiert mit dem Ruhen-Beschluss => OWNER-ENTSCHEID: blockiert die
    Statik-Abloesung den Voll-Bau oder faehrt Voll-Bau-4 mit deklarierter 4800+Provenienz?
(h) heavy live schalten (Infra-Handout) + Platz-Pflege + PAT + Bestands-Invalidierung
    (inkl. E-2-Schluessel!)
(i) E-01..E-26-Board-Rest (15 vor-Trigger; u.a. E-02 Ledger-Audit, E-19 Runner-Fleet)
(j) Lane A/C/F+W-13-Komplett-Beleg (vermutlich durch O-8-Vollzug gedeckt — einmalig
    verifizieren statt annehmen)

## 6. DISKREPANZ-REGISTER (aufgeloest)

G6-Doppelbelegung -> V7.4 gilt · N=316-"eigene-Zaehlung"-Vermutung -> widerlegt, Gate-
Zaehlung · heavy 24-vs-16-phys -> Code-Ist 24 bindend · normal-Modus 3 Versionen ->
c=4@4T · Trigger-Var-Satz -> voller Satz (juengere Docs) · Perm-Zahl 4->8->12 -> 12, aber
Rezept fehlt · super-Referenzzahl inkonsistent -> nach V-4 neu messen, Namensliste stabil ·
Stale permutation_codegen_cli-Anweisung -> hiermit widerrufen · Ledger-Nachtrag faellig
(Bau-Tag 27.07. abend komplett unverzeichnet).

*Nachster Schritt: Beweis-Strecke (a)-(j) priorisieren; (g) braucht Owner-Wort. Erstellt
aus 6-Agenten-Workflow, Verify tragfaehig-mit-auflagen, Korrekturen eingearbeitet.*

---
## ADDENDUM ~20:05Z — BEWEIS-STRECKEN-KARTIERUNG (Opus-5-Workflow wf_0cbea88d, Rohdaten
## in backups/20260801-fahrplan-und-beweis-strecke-workflows/) — KORRIGIERT DIESEN FAHRPLAN

K1. BEWEIS 1 GATE-KRITERIUM ERSETZT: 'Log-Zeile GN_DECISION=skip' ist DOPPELT unerfuellbar
    (GN_DECISION nur im nicht-inkludierten ci/archive/perm-matrix-fallback.yml; dort :176
    eine export-Zuweisung, nie im Log). Realer Resume-Arbiter der dynamischen Kette =
    dll_is_current per-Binary (build_orchestrator.hpp:471-478); dessen Skip-Meldung hat
    KEINEN Konsumenten (Anti-Beweis-Falle). ERSATZ-GATE (finales Rezept liegt im Backup):
    (a) Doppellauf-Idempotenz (DIFF-RC=0 ueber die perm.dll-Menge), (b) rm-.version-
    Kontrolltest (genau EINE Binary neu), (c) literales built_new=0 ueber die
    <comdare_experiment>-Wurzel (einzige Stelle mit built_new/resumed-Ausgabe:
    experiment_run_entry.hpp:384-387). Owner-Abnahme des Ersatz-Kriteriums noetig.
K2. BEWEIS 2/3 REZEPTE FINAL (Backup): Prune-Testat-Emitter im SUPER-Treiber
    (main.cpp:1172-1202, COMDARE_PRUNE_ONLY); Hydration via Fake-mc (Owner-Vorbehalt:
    Mock-Weg abnicken; NIE gegen Produktiv-Bucket; Beweis 4 = echtes minio separat).
    Variant-Gate: COMDARE_VARIANT_GATE nur im thesis_profile-Zweig; R1-R4 inkl.
    per-Binary-Praezisions-Kontrolltest; SOLL-Signatur NUR aus frischem Treiber (bvset=).
K3. TRIGGER-REZEPT-KORREKTUREN: (i) OWNER_UUID als LITERAL (GitLab expandiert keine
    Kommandosubstitution — '$CI_JOB_ID@$(hostname)' reiste als Text in die Bestandslog-id);
    (ii) TOTE VARS nicht setzen: COMDARE_GN_INCLUDE_AVX512 (0 Treffer im ce),
    COMDARE_GN_RANGE (kein getenv-Konsument; wirksam nur emittiertes COMDARE_GOLDEN_N_RANGE);
    (iii) COMDARE_VARIANT_GATE steht in der Forward-Allowlist (director.hpp:872) aber
    fehlte im Var-Satz — Owner-Entscheid: aufnehmen (sonst zertifiziert Beweis 3 ein im
    Produktivlauf abgeschaltetes Gate); (iv) §3.3-TOPOLOGIE KORRIGIERT: Stufe-2 =
    KONSTANT 4 Batch-Jobs (tier:build-batch + measure je amd/intel; Scheiben SLICE=4096
    INTERN, kGnBatchSlice hart :540) — die 11611-Praezedenz '16/16' war das ALTE
    O(Perms x Chunks)-Schema (kTierChunkCount DEPRECATED :536-539). 4 Jobs = korrekt,
    NICHT 'zu wenig'.
K4. 12-PERM-KLAERUNG: ce-Ist = 4 Perms (O2,O3 x no_extension,avx2; all_axes_golden
    :187-200) MIT dokumentierter GN-3-Begruendung (:178-186: Ofast bricht IEEE-754/CRC64,
    avx512 nicht universell). 12 waere bewusste UMKEHR (Owner-Entscheid), technisch klein:
    Profil-XML-Edit (Trockenlauf belegt: perm_count=12, weiterhin 4 Jobs) + >=16
    Test-Anker-Nachzug (test_experiment_plan_director.cpp zementiert die 4) + Kommentar-
    Nachzug (dort auch stale '17-Organ-Kartesik' — ORG-18 ist Ist). Ohne Entscheid baut
    der Trigger 4 x 131072 = 524.288 Tier-Binaries.
K5. BESTANDSLOG: BEDINGT TRAGFAEHIG, nicht abnahmereif — Treiber-Gate hart+ehrlich
    (Exit 6, Pflicht-Trio), Forward vollstaendig, Grandchild scharf; ABER (a) Planer-
    Reservierung STRUKTURELL INERT (planer:delegate ohne .storage_cache_activation-Anker
    => Warnung lager_ebene_fehlt) — nachruesten (YAML-Einzeiler) oder dokumentiert
    akzeptieren; (b) Beweis 4 offen; (c) §65-Delta weiter ungeklaert (Input-Luecke der
    Kartierung — Nachpruefung noetig); (d) Bestands-Invalidierung MUSS E-2-Schluessel-
    wechsel einschliessen.
K6. VOR-TRIGGER-TODO-LISTE (blockierend ja/nein) + vollstaendige Widerspruchs-Liste im
    Backup-JSON §syn. Aufraeumpass-Kandidaten fortgeschrieben (built_new/built_skip ohne
    Leser auf dem golden-Weg; Kommentar-Drift director:1325; '17-Organ'-Profil-Kommentar).
