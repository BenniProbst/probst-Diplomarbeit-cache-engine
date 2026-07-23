# SESSION 23.07.2026 (Mittag) — Neustart-Zug Voll-Bau-4: Vor-Lauf-Auflagen, OOM-Befund, Abnahme-Kriterien

> Fortsetzung von 20260723-SESSION-vormittag-kette2-komplett-vollbau-start.md. Kontext: Voll-Bau-3
> (12713, 32/24 Worker, seit 11:07) laeuft OHNE gn_out-Persistenz (Teil-A-Fix ce 4efd3906 landete
> nach dem Trigger). User-GO fuer Cancel+Neustart liegt vor ("GO fuer alle 3 Dinge").

## 1. COMPLETENESS-SWEEP (wn4ee6xz5) — 6 Vor-Lauf-Pflichten

Workflow (3 Sucher Ledger/Memory/Sessions + Critic, ohne Credential-Bereiche) ergab 6 fehlende
Vor-Lauf-TODOs; Status bei Doc-Erstellung:

1. **Gruen-/golden-Neutralitaets-Beweis** der In-Bau-Fixes (#27/#29/GIT_CLEAN): ce+super-Pipelines
   hart gruen + ce-only-golden-Fingerprint 0xF1C1F26A1232073B byte-gleich. STATUS: ce 12720 und
   super 12721 (Teil-A-Pushes) beide FAILED durch cc1plus-SIGTERM (OOM, s. §2) — Retry im ruhigen
   Fenster nach 12713-Cancel PFLICHT; nach Teil-B/C/D-Landung erneuter Gruen-Beweis.
2. **CI-HIT-Beweis als Abnahme-Kriterium** — in §4 festgeschrieben.
3. **Platten-/Ressourcen-Check**: prod2 OK (147G frei, 24 Kerne, 62G RAM, kein Swap-Thrashing).
   prod1 ENG: 59G frei bei ~56GB Matrix-Forecast (GN-9 ~428KB/DLL); Runner-Bestand unter
   /home/gitlab-runner/builds ohne root nicht messbar. Merkposten: waehrend des Laufs Platz-Wache.
4. **ResumeWorker-Cron-Wache ARMIERT** (Redis-Praesenz + last_enqueue-Frische, 10-min-Poll,
   Stunden-Heartbeat, Alarm bei FEHLT/STALE/SSH-Fail). Cron praesent und feuernd
   (cron_job:default:sidekiq_concurrency_limit_resume_worker).
5. **Re-Trigger-Rezept-Testat** — in §5 festgeschrieben; Ankuendigung an den User erfolgt vor Trigger.
6. **Messdaten-Schutz-Testat** (git ls-files vs. GIT_CLEAN-Ausnahmen, tier150_measurements.csv
   ~6.7MB force-added): als Pruefschritt an Impl-S6-P1 delegiert (Teil-B/C/D-Paket).

Bewusst NICHT vor dem Lauf (Sweep-Verdikt, Resume-Bruch-Logik): H-10/K-18-Rest (AVX10-Feld,
per-Binary-Sidecar), K7b-Array-Rest, W12 X.Y.Z-Migration — naechstes bewusstes Cache-Bruch-Fenster
vor der 01.08.-N-Messung, unter Absprache.

## 2. OOM-BEFUND (NEU): 32-Worker-Batch verdraengt parallele CI-Jobs

**Symptom:** 3 Compiler-Kills in 2 Pipelines (ce 12720: contract:profile_coverage +
contract:pool_flip; super 12721: analyse:thesis-data), alle 11:34-11:43, Signatur identisch:
`c++: fatal error: Terminated signal terminated program cc1plus`. Kein Code-Regress (test:unit
und alle uebrigen Jobs gruen).

**Ursache belegt:** prod1 60G RAM, unter dem 32W-Batch nur 12G available und **20G Swap aktiv**;
zusaetzliche Contract-Compiles (mehrere GB/TU) kippen in den Kernel-OOM-Kill.

**Slice-1-Empirie Voll-Bau-3 (live, aus Job-Traces 306305/306306):**
- amd@32W: 11:14:24 -> 11:34:21 = **19,95 min** (vs. 19,4 min @24W in 12690) => **kein Gewinn,
  RAM-gebunden, Swap-Thrashing**.
- intel@24W: 11:14:36 -> 11:46:51 = **32,25 min** (vs. 35,5 min @16W) => ~9% Gewinn, kein
  Swap-Thrashing (prod2 146M Swap) => sinnvoll.

**Konsequenzen:**
- Gruen-Beweise NUR im ruhigen Fenster (nach Cancel, vor Re-Trigger).
- Waehrend Voll-Bau-4 KEINE schweren parallelen CI-Jobs: Pushes zurueckhalten oder
  `git push -o ci.skip` + Pipeline-Nachholung im naechsten ruhigen Fenster.
- **Offene User-Entscheidung (T-Werte sind User-Gesetz):** Empfehlung amd 32->24 Worker
  (gleiche Geschwindigkeit, 20G weniger Swap-Druck, geringeres Absturz-/OOM-Risiko ueber ~30h;
  prod1-Absturz 22.07. ~22:50 passt ins Bild); intel bleibt 24. OHNE GO bleibt 32/24 unveraendert.

## 3. NEUSTART-ZUG (Reihenfolge, User-GO liegt vor)

1. Teil B/C/D (Impl-S6-P1) abnehmen: diff-stat literal + eigener ctest + Messdaten-Schutz-Testat
   (Auflage 6) -> granularer Commit -> Dual-Push. (Dieser Push loest Pipelines aus, die im noch
   unruhigen Fenster rot werden koennen -> Retry-Slot in Schritt 4.)
2. **Lokaler Resume-Skip-Beweis** (User: "Das waere jetzt der richtige Zeitpunkt zum testen"):
   Doppellauf des Drivers gegen dasselbe gn_out; Lauf 2 muss vorhandene Binaries via Sidecar
   erkennen (GN_DECISION=skip literal im Log) und nur Fehlendes bauen.
3. **12713 canceln** (Beweislage: intel unter Moeglichkeiten + Slice 1 fertig — beide Bedingungen
   des Users erfuellt und dokumentiert) -> **Waisen-Sweep beide Maschinen** (prod1: sudo-Skript
   comdare-sweep-orphans, Installation durch User ausstehend, sonst User-Kill-Kommando;
   prod2: SSH admin-management@10.0.10.212) -> Platz-Re-Check.
4. **Ruhiges Fenster:** ce 12720-Jobs + super-Pipeline retry/neu -> ALLES hart gruen
   (inkl. golden-Fingerprint-Pfad byte-gleich).
5. **Struktur-Smoke** (planer:delegate m3v2_smoke, analog 12667/12684) -> SUCCESS-Beweis der
   Emissionsaenderungen aus Teil B (every_n-Testat) im CI-Ist.
6. **Re-Trigger Voll-Bau-4** nach Rezept §5. Ankuendigung an User erfolgt (Autonomie-Doktrin:
   mehrtaegige Schritte vorher ankuendigen; GO liegt bereits vor).

## 4. ABNAHME-KRITERIEN VOLL-BAU-4 (erweitert um Sweep-Auflage 2)

Terminal-Abnahme des Laufs umfasst literal:
- Bau-Testate je Slice ([TESTAT] phase=bau, ebenen-richtige Grammatik) + Slice-innere
  Fortschritts-Testate alle K Builds (Teil B, K=lane_build_parallelism).
- Binary-Zaehlung gegen Katalog (all_axes_golden, GN_TOTAL=131072) + Pruef-Bilanz je Perm.
- **NEU (PFLICHT): CI-HIT-/Skip-Beweis** — Log-Beleg GN_DECISION=skip fuer bereits im
  persistierten gn_out vorhandene Binaries (R1/R2-HIT-Nachweis der "naechsten golden-Bau-Welle",
  der Lauf IST diese Welle) + Skip-Zaehlung im Batch-Abschluss-Testat. Ohne diesen Beleg gilt
  die Resume-Schicht als NICHT bewiesen, auch wenn der Lauf gruen ist.
- ResumeWorker-Cron-Wache ohne FEHLT-Alarm ueber die Laufdauer (bzw. Alarm + Re-Registrierung
  dokumentiert).

## 5. RE-TRIGGER-REZEPT-TESTAT (Sweep-Auflage 5, bindend)

```
POST /projects/288/pipeline  ref=development
variables: COMDARE_BUILD_GOLDEN_N=true          # EINZIGE Variable
# GN_TOTAL=131072 ist Default; COMDARE_MEASURE_PROFILE bleibt UNGESETZT;
# Mess-Batches (measure:*:batch:*) bleiben when:manual — KEINE Mess-Scharfschaltung.
# Messlauf-Start (320er) bleibt USER-GO/manual-gated (LEDGER §55/2952).
```

## 6. WEITERE BEFUNDE DIESER SESSION

- measure-drop.comdare.local wieder UP (HTTP 301, ~1,5ms) — der 21.07.-Ausfall ist behoben,
  320er infra-seitig entblockt.
- Push-Pipelines gesund (12720/12721 wurden korrekt erzeugt); der fruehere "keine
  Push-Pipelines"-Befund war ein Kurz-SHA-Query-Artefakt (Full-SHA Pflicht bei ?sha=).
- Transkript-Viertel der Vor-Kompaktierungs-Session vollstaendig eingelesen (3 Leser +
  Eigen-Lektuere); Board (31 Tasks) deckungsgleich mit Transkript-Ist.

## 7. KONSOLIDIERTE GESAMTABFOLGE (Stand 23.07. ~12:40; Basis = 17-Punkte-Liste Kontextuebergabe
## 22.07. abends, + alle seitherigen Einschuebe; Board-Tasks in Klammern)

**NEU seit der 22.07.-Tabelle:** gn_out-Persistenz Teil A (#30) · #27 VORGEZOGEN als Teil B +
Cancel-trap Teil C (#29) + K-Label Teil D · T-Werte 32/24 -> 24/24 (User 23.07.) · Neustart-Zug
Voll-Bau-4 mit 6 Sweep-Auflagen (#31) · §65-Paketfamilie: P-A Push-Aktivierung (#34, blockt
Trigger), P-B Pruning vor Abgabe (#35), P-C measure_out-Naht (#33, blockt 320er) ·
Tools-Lagerhaltung (#32, post-Abgabe) · ResumeWorker-Cron-Wache + CI-Reparatur-Rest (#25) ·
CI-HIT-Abnahmekriterium · Root-Cleanup (109G frei) + sudo-Sweep-Installer (beide ERLEDIGT).

**PHASE 0 — VOR-LAUF (Mi 23.07.):**
 0.1 B/C/D+amd24-Revision abnehmen, committen, Dual-Push (#27) [in Abnahme]
 0.2 P-A Ebene-B-Push-Aktivierung: Design (wf laeuft) -> Bau -> Abnahme -> Commit (#34)
 0.3 P-C measure_out-Sicherung, idealerweise im P-A-Emitter-Commit (#33)
 0.4 Neustart-Zug (#31): lokaler Resume-Skip-Beweis -> Cancel 12713 -> Waisen-Sweep (autonom)
     -> Gruen-Fenster (12720-Retry + Pipelines final-SHA hart gruen) -> Struktur-Smoke
     -> TRIGGER Voll-Bau-4 (Rezept §5; 24/24; df-Wachen + Cron-Wache)
**PHASE 1 — VOLL-BAU (Mi Abend - Fr frueh, ~30h):** #22 laeuft; parallel P-B Pruning bauen (#35,
 aktiv erst nach Lager-Verifikation); nur beobachtende CI-Restpunkte (#25); KEINE schweren
 CI-Jobs parallel (Pushes -o ci.skip + Nachholung).
**PHASE 2 — MESSEN (Fr/Sa):** Terminal-Abnahme Voll-Bau-4 (§4 inkl. GN_DECISION=skip) -> 320er
 m3v2-320 (#6, USER-GO/manual-Gate).
**PHASE 3 — AUSWERTUNG/ABGABE (Sa-Mo):** S7 (#7) -> G8-Anhaenge (#24) -> S8 PDF DE+EN (#8,
 END-GATE Mo 27.07.) -> dev->main-Merge (#9, Scrub-Vorsicht).
**PHASE 4 — ERWEITERTE LAGERHALTUNG (vor 01.08.):** #46b komplett (#10: Bestandslog P1-P4,
 RAM-Puffer 256MB, avg_size, Writer-Thread 3 CT-Backends, Slice-Queue) + §65-Vollzug
 (Push/Drop ueberall, lokal->0-Rueckbau) + Tools-Lagerhaltung (#32) + #54 (#12), COMPARE (#11),
 Runtime-Beweise-Rest (#19).
**PHASE 5 — BAND C / §63-ENDLAUF:** POST-v3 (#13), #49 (#14), #51 (#15), #48-S6 (#16, gegated),
 G-Gruppen/W12 (#17), CI-Wartung 9+3 Merkposten (#18), G7/OD (#20), §55-Rest (#21),
 PAT-Rotation (#23), #29-Rest — bis leeres erkennbares Backlog.
