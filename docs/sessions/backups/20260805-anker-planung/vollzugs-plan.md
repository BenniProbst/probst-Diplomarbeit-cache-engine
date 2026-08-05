# ANKER-VOLLZUGS-PLAN (GATE 5) — TP1-Neu-Inventur + A2-SHA512-Eichung, GENAU EINMAL

Erstellt 05.08.2026 (Fable, Vollzugs-Plan-Anker). Grundlage: anker/definition.md + anker/ist.md
(beide VOLLSTAENDIG gelesen) + eigene Objekt-Verifikationen (alle Fundstellen unten mit Datei:Zeile).
Pfad-Kuerzel:
- CE   = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
- SUPER= /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine
- LEDGER = SUPER/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
- WT   = /home/comdare/wt-e24 (ce-Worktree, FREI: phase-b-treiber c2bc0e2b gemergt, porcelain 0)

---

## 0. ADVERSARIAL-ERGEBNIS DER W1-FRAGE (zuerst, weil auftragskritisch)

**ANKER VOR W1 ist KORREKT — bestaetigt, nicht nur uebernommen.** Beweiskette am Objekt:

1. Der Tier-Fingerprint-Preimage (6 Glieder, anatomy_fingerprint_glieder) traegt KEINE
   Planer-Komponente: grep "planner|planer" ueber anatomy_fingerprint.hpp + anatomy_version_stamp.hpp
   liefert NUR den Kommentar zur Combo-Legenden-Bruecke (anatomy_version_stamp.hpp:272-273).
   `planner_version` ist der Planer-SELBST-Stempel ("planner@X.Y.Z isa=.. os=..",
   g1_binary_version_stamp.hpp:6/:46) — er stempelt die PLANER-Binary, nie die Tier-Binaries.
   => W1 (Code-Umzug Director/Stufe-1-Builder/planner_version in das neue
   comdare_experiment_planner-Target, Ledger mittag-4) bewegt KEINEN Tier-Fingerprint.
2. W2-Minimal (in W1; Owner-Entscheid mittag-6: -D-Compile-Define + Stempel-Wirkung) haertet nur den
   TRANSPORT der Combo-Legende (heute Env COMDARE_MEASUREMENT_COMBO -> Mess-Zeile = Glied [3],
   anatomy_version_stamp.hpp:272-273). Fingerprint-neutral GENAU DANN, wenn die gerenderte
   Mess-Zeile byte-identisch bleibt. Die Einlese-Synthese bindet das bereits:
   "Cache-Key-Frage NICHT stillschweigend mitentscheiden" (backups/20260805-einlese-plan-korpus/
   synthese.md:275). ABER: der W10-Praezedenzfall (Ledger:3805, "+ceb=7.2, PERM-Pfad traegt Glied
   erstmals") zeigt exakt die Fallen-Klasse "Transport-Wechsel materialisiert ein Glied neu".
   => W2 erhaelt eine HARTE AUFLAGE (Abschnitt 4, R2) mit Frozen-Vektor-Wache; nur unter dieser
   Auflage ist Anker-vor-W1 sicher.
3. W5 (status-Subkommando, on-demand, Bestandslog-XML als Quelle) ist read-only => neutral.
4. Der juengste bindende Stand ordnet exakt so: LEDGER mittag-4 (:4057-Umfeld): "Phase B GELANDET ->
   ANKER wie geplant (beendet Job-Sperre) -> W1 (Di/Mi) ... Task-Board entsprechend gedreht
   (Anker VOR W1)"; Owner mittag-6: "Nun weiter wie geplant ... Reihenfolge beibehalten."
5. G8-Logik dreht die Abhaengigkeit sogar UM: die W-Wellen BRAUCHEN den vollzogenen Anker, damit
   "danach nur noch fingerprint-neutrale Arbeit bis zum Trigger" (e24-bauplan:576-579) ueberhaupt
   als Wache ueber W1/W2/W5 stehen kann. W1 invalidiert die Eichung NICHT — solange die
   Neutralitaets-Auflage gilt; kippt sie, gilt Eskalations-Gate O-2 (Abschnitt 5).

**Interne Anker-Ordnung** (Konflikt in den Quellen, hier entschieden): FAHRPLAN:18 ("Eichung
EINMALIG ZULETZT nach W10+E-24; danach TP1-FINAL-Inventur") und die Code-Deklaration
bestandslog_index.hpp:129-151(c) ("A2-Eichung EINMALIG ZULETZT (FAHRPLAN:18)") tragen die Ordnung
EICHUNG -> INVENTUR; e24:424 zaehlte umgekehrt. Beide binden beides in DASSELBE eine Fenster.
Gewaehlt: **Eichung zuerst, Inventur danach am GELANDETEN Stand** — (a) folgt FAHRPLAN + Code,
(b) die Inventur bewegt keine Fingerprints (R15-neutral in beiden Ordnungen), (c) nur so ist die
FINAL-Inventur eine Inventur ueber exakt dem Code-Stand, mit dem Voll-Bau-4 baut.

---

## 1. WO DER VOLLZUG LAEUFT

- **Bau-Flaeche: LOKAL in WT (/home/comdare/wt-e24)**, Branch `anker-a2-eichung` ab
  origin/development == 24e07219. wt-e24 ist verifiziert frei (ist.md 3.3).
- **CI: NUR die regulaere Verifikations-Pipeline** auf Projekt 286 (ce) bzw. 288 (super),
  Standard-Runner (Ist 3/2; Stau=Backlog). Unter der Job-Sperre ERLAUBT — belegt durch die Praxis
  Gate 384->403 unter aktiver Sperre ("CI-Wache am VOLL-SHA laeuft, main-FF nach Gruen",
  LEDGER mittag-2). KEIN Trigger (POST /projects/288/pipeline), KEIN Lager-Lauf, KEIN schwerer
  Parallel-Job. Es wird KEIN dedizierter Eich-/Inventur-CI-Job geschaffen: der Anker ist eine
  EINMALIGE Handlung, keine stehende Automatik (ist.md §4 — es existiert bewusst keiner).
- **Die stale pending-Pipeline super #14190 wird NICHT angefasst** (kein Retry/Cancel — ein Retry
  waere ein neuer Job unter der Sperre und beruehrt einen Alt-SHA).
- **TP1-FINAL-Inventur: lokal am gelandeten Stand** (ctest-Gates) + Ledger-Persistenz. Ebene B
  (minio) ist lokal nicht enumerierbar (kein mc-Alias, ist.md 1.1) und der Agent ist
  Cluster-read-only — die physische Enumeration ENTFAELLT BEGRUENDET (Abschnitt 3, Schritt S6).
- **Rollen (ARBEITSWEISE v2):** Fable = Plan/Design/Review (dieses Dokument + Wellen-Plan +
  Review); Bau der Eich-Welle per Orchestrator-Zuteilung (Opus 5 Struktur-nach-Design; die Flaeche
  ist chirurgisch klein). Je Paket ultracode-Planung VOR Ausfuehrung (Doktrin), NACH-ultracode am Ende.

## 2. WIE DIE EICHUNG PERSISTIERT

| Traeger | Inhalt | Wann |
|---|---|---|
| ce-Commit(s) der Eich-Welle auf development+main (GitLab origin + GitHub-Flach-Sicherung) | dll_is_current-Umbau (F7: EIN Vergleich), neue A2-TU, Kommentar-Wahrheiten (fingerprint_sidecar.hpp:22 ".fingerprint ... kein Skip-Kriterium" -> WIRD Skip-Kriterium; fingerprint_key_source.hpp AUF-A5-Kommentar stale; bestandslog_index.hpp (c)-Deklaration auf Vollzugs-Form) | S2-S5 |
| kFrozenFingerprintV1 = 0fe275bd...cc9fe36 (3 TUs) | der geeichte Referenz-Vektor — bleibt UNVERAENDERT; die Eichung PINNT ihn als Anker-Wert | S2 (Wache), S6 (Beweis) |
| `.fingerprint`-Sidecar je Binary | entsteht erst beim Bau (write_fingerprint_sidecar bo:337/:579; push/pull via kOptionalTierSidecars artifact_cache.hpp:92) — Voll-Bau-4 fuellt die Welt | nach Trigger |
| LEDGER-Nachtrag "ANKER VOLLZOGEN (GATE 5) ... JOB-SPERRE BEENDET" | das FORMALE Sperr-Ende + Inventur-Feststellung + alle Gate-Belege (SHAs, N, Vektor) | S7 |
| Session-Doc (SUPER/docs/sessions/) + Workflow-Backup (SUPER backups/) | Vollzugs-Protokoll + Wellen-Backup SOFORT | S7/S8 |
| Task-Board | Task #3 -> completed; W1 (#6) wird aktiv | S7 |

Das Bestandslog (minio-XML-Objekt) wird im Anker NICHT beschrieben: es gibt keinen Bestand
einzutragen (kein schuetzenswerter Bestand vor Voll-Bau-4) und keinen lokalen Lager-Zugriff.

---

## 3. DIE EXAKTE SCHRITT-FOLGE

### S0 — VORFLUG (lokal, read-only; GENAU-EINMAL-Wächter)
- Kommandos: `grep -n "ANKER VOLLZOGEN" LEDGER` (MUSS 0 Treffer sein — Doppel-Vollzugs-Sperre);
  `git -C CE fetch origin && git -C CE rev-parse origin/development origin/main` (beide 24e07219);
  analog SUPER (beide 7cb9cffb); `git -C CE status --porcelain` leer; `git -C WT status --porcelain`
  leer; GitLab-API read-only: running-Pipelines 286+288 leer (`[]`).
- Erwartet: exakt die Ist-Werte aus ist.md.
- Abbruch: JEDE Abweichung (Treffer beim grep, bewegte SHAs, unsauberer Tree, laufende Pipeline)
  => STOP, Lage neu erheben. Kein Anker ueber bewegtem Grund; grep-Treffer = Anker war schon.

### S1 — EICH-WELLE PLANEN (Fable; ultracode-je-Paket-Doktrin)
- Ort: WT; Branch `anker-a2-eichung` ab origin/development (24e07219). Wellen-Plan-Dokument mit:
  Umbau-Design dll_is_current (build_orchestrator.hpp:271-296) auf F7-Form
  "expected CT-Fingerprint == .fingerprint-Sidecar-Inhalt, EIN Vergleich, fail-closed ohne Sidecar";
  Call-Site-Liste (alle dll_is_current-Konsumenten, u.a. cache_engine_builder_iterator.hpp,
  lager_presence.hpp, planer_driven_build.hpp, profile_run_entry.hpp); expected-Verdrahtung ueber
  die FingerprintFn-Schreibseite (bo:174) / dieselbe Quelle, die write_fingerprint_sidecar speist
  (Schluessel-Welt-Identitaet F7); Entscheid K1-Cross-Check (F7 sagt 'NUR' => Skip-Entscheid haengt
  ausschliesslich am SHA512; K1 wird gemaess Aufraeumpass-Doktrin entfernt ODER zur reinen
  Diagnose-Zeile ohne Skip-Wirkung degradiert — im Wellen-Plan festschreiben);
  Kommentar-Wahrheiten (Abschnitt 2). Backup des Plans SOFORT nach SUPER backups/.
- Erwartet: Plan-Dokument vollstaendig, Flaeche ausserhalb abi/ (abi/ ist im Eich-Diff TABU).
- Abbruch: Design erfordert abi/-Aenderung oder Preimage-Beruehrung => STOP (das waere ein
  Fingerprint-Shift; der Anker darf keinen erzeugen).

### S2 — EICH-WELLE BAUEN (Zuteilung nach Arbeitsweise; ASCII-only; G8-minimal-invasiv)
- Inhalt: (a) dll_is_current-Umbau auf den EINEN Vergleich (Signatur-Wechsel: expected-Fingerprint
  statt version/algo_sig/variant_sig als Skip-Kriterium; .version bleibt als Transport-
  Vollstaendigkeits-Marke von push_tier_binary UNBERUEHRT — sie verliert nur die Skip-Rolle);
  (b) fail-closed: kein/leerer/nicht-128-hex-Sidecar => false (Neubau); (c) neue TU
  `test_a2_sha512_skip_gate.cpp` mit den Beweisen aus Abschnitt "Gates" (G5); (d) Kommentar-
  Wahrheiten nachziehen (NIE loeschen, nur nachfuehren/deprecaten); (e) bestandslog_index.hpp
  (c)-Absatz auf Vollzugs-Form ("Eichung vollzogen am <SHA>, Referenz kFrozenFingerprintV1").
- Erwartet: Diff beruehrt abi/ mit 0 Zeilen; kFrozenFingerprintV1-Zeilen in den 3 TUs unangetastet;
  golden-CRC-TU am alten Wert 0xF1C1F26A1232073B gruen.
- Abbruch: abi/-Diff != 0, Frozen-Vektor-Zeile im Diff, golden-CRC-Bewegung => STOP + Review.

### S3 — LOKALE VOLL-KADENZ (WT)
- Kommandos/Welle: FRISCHES Configure (05q-Falle: Basis-N nur am frischen Configure erheben);
  Doppellauf 2x ctest SERIELL am Commit-Objekt; 3-Marker-Suche = 0; Lead-cf22 = 0 Befunde;
  gitleaks clean; Selbstcheck aus dem Diff (ASCII-only-Zeile). §61-Dual-Weg soweit einschlaegig
  (Debug parallel / zweite Maschine, Falle "lokale Voll-Bau-Luecken = falsches Gruen": das
  BINDENDE Gruen ist die CI am VOLL-SHA, S4).
- Erwartet: ZWEIMAL literal "100% tests passed, 0 tests failed out of N" mit N > 403 (N = lebendes
  Gate, NIE hartkodieren; J-Kette-Kanon, V32=ON ist CI-Kanon).
- Abbruch: irgendein Lauf != 100% => Fix in der Welle; kein Push.

### S4 — PUSH + CI-WACHE (origin=GitLab 286; regulaere Pipeline — unter der Sperre erlaubt)
- Kommandos: `git -C WT push origin anker-a2-eichung`; Pipeline-Abfrage NUR mit VOLL-SHA
  (Pipelines-API-Falle); Monitor mit Heartbeat (nie stumm haengen), /jobs zeigt keine Bridges.
- Erwartet: Pipeline status literal "success" am VOLL-SHA des Wellen-Kopfs.
- Abbruch: "failed"/haengend => Fix in der Welle; KEIN Merge; Cold-ICE-Retry-Kanon beachten.

### S5 — LANDUNG (Eichung wird bindend)
- Kommandos/Welle: Merge nach development (NIE rebase); tree-identisch-Check Merge vs. Wellen-Kopf;
  CI am Merge-VOLL-SHA gruen; main-FF mit GEPINNTEM SHA (nicht rev-parse HEAD); lokale stale
  main-Refs nachziehen (ce 2b0a9bd8 -> neuer SHA; super 9d0f1bad -> neuer super-SHA);
  SUPER-Gitlink-Nachzug auf den neuen ce-SHA + super-CI gruen (Deploy-Token-Naht REV17);
  GitHub-Flach-Sicherung (Dual-Remote-Doktrin). Gate-Zaehler: "Gate N" (lebend).
- Erwartet: ce dev == main == <NEU-SHA> auf origin; super dev == main == <NEU-SUPER-SHA>, Gitlink
  zeigt <NEU-SHA>; beide Pipelines success.
- Abbruch: super-CI rot oder Gitlink-Drift => Heilung VOR S6 (die Inventur laeuft nur ueber dem
  vollstaendig gelandeten Stand).

### S6 — TP1-FINAL-INVENTUR (operativ, KEIN ce-Commit; am gelandeten Stand)
- Teil (a) ctest-Inventur-Gates am gelandeten SHA (frisches Configure):
  `ctest -R "tp1_planer_filter_iterator|g3_sha512_index|w10_system_cell_values|m_w12_stamp_bausteine|g3_bestandslog_document|g3_bestandslog_lock|f3_lager_key_provider_iterator|lazy_resume_binary|fk1_nicht_gebaut_marker"`
  — literal `TP1_ANKER_OK` (test_tp1_planer_filter_iterator.cpp:734) + alle genannten TUs gruen.
- Teil (b) INVENTUR-FESTSTELLUNG (wird S7-Ledger-Text; die Inventur der Probe-Bestaende IST bei
  fail-closed-Schluesseln diese dreiteilige, beweisgestuetzte Feststellung):
  1. ALLE prae-Anker-Ebene-B-Bestaende (v5-Aera + prae-W10 '+ceb=7.1'/'kein +ceb' + prae-E-24
     '+ceb=7.2') sind gegen den geeichten Namensraum FAIL-CLOSED-INVALID — kein Grandfathering,
     keine Alt-Key-Uebersetzung (bestandslog_index.hpp:129-151(b); dll_is_current neu; Gate-TUs).
     Jeder Alt-Key => Lookup-Miss => NEUBAU.
  2. Alt-Bestaende bleiben ADDITIV liegen — es existiert im Anker KEIN Loesch-Schritt (Messdaten/
     Rohdaten nie loeschen; Backups additiv).
  3. Der geeichte Namensraum (kFrozenFingerprintV1-Preimage-Welt, '+ceb=8.0'-build_version-Praefixe,
     LagerKey = (Sha512Key, ZellKoordinaten)) ist ab jetzt die EINE Schluessel-Welt
     (Skip-Gate == minio-Key == Bestandslog key_sha512 == Baum-Blatt == ceb_key_sha512).
  Physische Ebene-B-Enumeration ENTFAELLT BEGRUENDET: lokal kein mc-Alias (ist.md 1.1), Agent
  Cluster-read-only, VOR Voll-Bau-4 kein schuetzenswerter Bestand (Ledger:3648/:3755), und ein
  Lager-Lauf ist exakt eine der drei verbotenen Sperr-Klassen. Nachhol-Naht: Phase-5-Pre-Flight
  (P11) sichtet das Lager VOR dem Trigger ohnehin.
- Abbruch: `TP1_ANKER_FAIL` oder irgendeine TU rot => STOP; KEIN Ledger-Vollzugs-Nachtrag; Befund
  in die Welle zurueck (der Anker gilt dann als NICHT vollzogen).

### S7 — ANKER-PERSISTENZ (SUPER; beendet die Job-Sperre FORMAL)
- Kommandos/Welle: LEDGER-Nachtrag mit Kopfzeile
  "ANKER VOLLZOGEN (GATE 5) — TP1-FINAL-INVENTUR + A2-SHA512-EICHUNG GENAU EINMAL; L14 leeres
  Overlay-Glied (deklarierte Luecke, Heilung Phase 6 nach Abgabe); JOB-SPERRE BEENDET" +
  alle Belege (NEU-SHAs ce/super, N, TP1_ANKER_OK, Frozen-Vektor, Inventur-Feststellung 1-3,
  W-Wellen-Auflage Fingerprint-Neutralitaet). Session-Doc anlegen (neue Session-Docs-Doktrin).
  Task #3 -> completed (Task-Board = User-TODO aktuell halten). Doku-Commit SUPER push, CI gruen.
- Erwartet: grep "ANKER VOLLZOGEN" LEDGER == 1 Treffer (der Wächter aus S0 wird scharf).
- Abbruch: keiner mehr moeglich ausser Push/CI-Fehler => heilen; die Sperre endet erst mit
  diesem Nachtrag.

### S8 — NACH-ULTRACODE + BACKUP (VOR+NACH-Doktrin)
- Verifikations-Lens ueber das Ergebnis: alle Gates literal belegt? GENAU-EINMAL-Zustand konsistent
  (genau 1 Ledger-Treffer, keine zweite Eich-Spur)? Workflow-Backup SOFORT nach SUPER backups/.
- Abbruch-Kriterium: Lens findet Luecke => Luecke schliessen VOR W1-Start.

### S9 — UEBERGANG ZU W1 (erst NACH S7/S8)
- W1-Start mit aktiver Dauer-Auflage fuer ALLE W-Wellen bis zum Trigger: FINGERPRINT-NEUTRALITAET
  (kFrozenFingerprintV1 + golden-CRC + abi/-Diff-0-Wache in jedem Wellen-Review; W2: Mess-Zeile
  byte-identisch, "Cache-Key-Frage nicht stillschweigend mitentscheiden"). Verstoss => STOP +
  Owner-Eskalation (O-2).

---

## 4. RISIKEN fuer den GENAU-EINMAL-Charakter + GEGENMASSNAHMEN

- **R1 Eichung ueber unfertigem Stand** (verdeckter binary-beruehrender Rest-Posten nach Phase B):
  Gegen: S0-Vorflug prueft dev==main==24e07219 und Ledger mittag-2 ("DIE LETZTE BAU-SCHEIBE DES
  A8-S5-KOMPLEXES"); jede Abweichung = STOP. Ledger:3856 bestaetigt Vor-Anker-Pflicht abgearbeitet.
- **R2 W2-Stempel-Wirkung schiebt Fingerprints NACH der Eichung** (W10-Praezedenz "+ceb, PERM-Pfad
  traegt Glied erstmals"): Gegen: harte W-Wellen-Auflage Fingerprint-Neutralitaet (S9) + Frozen-
  Vektor-/golden-CRC-/abi-Diff-Wache in jedem W-Review; wenn W2 byte-identische Mess-Zeilen NICHT
  erreichen kann => STOP + Owner-Entscheid (O-2), NICHT stillschweigend eichen/nachziehen.
- **R3 Overlay-Glied-Scharfschaltung vor Phase 6**: aendert JEDEN Fingerprint => zweiter globaler
  Neuanker. Gegen: L14-Deklaration im S7-Nachtrag wiederholen; Wache: COMDARE_OVERLAY_SOURCE_HASH
  hat genau EINE Fundstelle (Header-Default anatomy_fingerprint.hpp:83-86) — jeder zweite Treffer
  in einem Diff bis zur Abgabe = Alarm. Overlay-Fenster bleibt Phase 6 (nach Abgabe-Messfenster).
- **R4 Doppel-Vollzug durch Session-/Kontext-Verlust**: Gegen: S0-Wächter (grep "ANKER VOLLZOGEN"
  MUSS 0 sein) + Erst-Ledger-lesen-Doktrin; S7 macht den Wächter scharf (genau 1 Treffer).
- **R5 Die Eichung selbst bewegt einen Fingerprint** (versehentliche abi/-Beruehrung): Gegen:
  abi/ ist im Eich-Diff TABU (S1/S2-Abbruchkriterium); Frozen-Vektor-TUs muessen am ALTEN Wert
  0fe275bd gruen sein; golden-CRC 0xF1C1F26A1232073B unveraendert.
- **R6 Skip-Gate zu scharf => Lager wertlos** (hydrierte Binaries ohne .fingerprint wuerden nie
  skippen): ENTSCHAERFT VERIFIZIERT — perm.dll.fingerprint ist in kOptionalTierSidecars
  (artifact_cache.hpp:92, Push UND Pull); TU-Beweis Hydrations-Skip in S2/G5. Der stale
  AUF-A5-Kommentar (fingerprint_key_source.hpp: "push schiebt .fingerprint NICHT mit") wird in der
  Welle nachgefuehrt, damit kein Bauer ihm folgt.
- **R7 Sperr-Verletzung durch den Vollzug selbst**: Gegen: nur regulaere Verifikations-Pipelines
  (belegte erlaubte Klasse); kein Trigger, kein Lager-Lauf, keine schweren Parallel-Jobs; stale
  pending #14190 nicht anfassen; die entfallende physische Lager-Enumeration (S6) ist auch deshalb
  korrekt.
- **R8 Falsches Gruen** (05q-Falle, lokale Voll-Bau-Luecken): Gegen: frisches Configure fuer
  Basis-N; Doppellauf seriell am Commit-Objekt; bindend ist die CI am VOLL-SHA (Voll-SHA-API-Falle);
  gruene Tests zementieren alte Ordnung => neue A2-TU muss am ALT-Stand ROT beissen (Biss-Beweis
  im Review, 02a-HERZ-Vorbild).
- **R9 Interne Ordnungs-Verwechslung** (Inventur vor Eichung nach e24:424): Gegen: Abschnitt 0
  entscheidet dokumentiert nach FAHRPLAN:18 + Code-Deklaration; beide Akte liegen im SELBEN
  Fenster, die Inventur bewegt keine Fingerprints — kein R15-Fenster zwischen S5 und S6 offen
  lassen (S6 unmittelbar nach S5, keine andere Arbeit dazwischen).
- **R10 planner_version-Fehldeutung bei W1**: planner_version wandert mit dem Split (mittag-4) —
  er ist Planer-Selbst-Stempel, NICHT Tier-Preimage (verifiziert, Abschnitt 0.1). Gegen: im
  W1-Plan als NICHT-fingerprint-relevant ausweisen; g1_binary_version_stamp-TUs bleiben gruen.

## 5. OWNER-GATES

- **Fuer den Anker-Vollzug selbst: KEINES.** Owner-seitig bereits geordnet: mittag-4 "ANKER wie
  geplant ... Anker VOR W1" + mittag-6 verbatim "Nun weiter wie geplant ... Reihenfolge
  beibehalten"; Task #3 steht in_progress. Plan-autonom-durchziehen-Doktrin greift.
- **O-1 (nach dem Anker, zur Klarheit):** Phase 6 Messung bleibt USER-GO-STOPP — kein Messstart
  ohne Owner-GO; der Trigger Do 07.08. laeuft erst nach Phasen 3-5 + 7-Auflagen-Satz LEDGER:98.
- **O-2 (KONDITIONAL):** Falls W2 die Fingerprint-Neutralitaet (byte-identische Mess-Zeile) NICHT
  erreichen kann, entscheidet NUR der Owner: Neuanker-in-Kauf (zweite Eichung = R15-Bruch) vs.
  W2-Formwechsel vs. Verschiebung hinter den Trigger. Bis dahin: STOP der betreffenden Welle.
- **O-3 (KONDITIONAL):** Jede etwaige Remote-/Bestands-Loeschung (kommt im Plan NICHT vor) braeuchte
  explizites Owner-GO — hier nur als Doktrin-Erinnerung, der Anker loescht nichts.
