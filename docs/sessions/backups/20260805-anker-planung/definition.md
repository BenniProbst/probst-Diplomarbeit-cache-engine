# LENS anker-definition — Die VERBINDLICHE Definition des EINEN ANKER-Vollzugs (GATE 5)

Stand der Erhebung: 05.08.2026, read-only ueber super-Ledger, Session-/Pause-/Dossier-Docs und Memories.
Alle Zitate verbatim mit Fundstelle (Datei:Zeile). Pfad-Kuerzel:
- LEDGER = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md
- SESS = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/

---

## 0. DIE EINE DEFINITION (kanonischer Wortlaut)

> **"JOB-SPERRE AKTIV (Startklar-9, hiermit KOMMUNIZIERT): Ab dieser Landung bis zum ANKER-VOLLZUG
> (GATE 5 = TP1-Neu-Inventur + A2-SHA512-Eichung, GENAU EINMAL): KEIN Trigger, KEIN Lager-Voll-Lauf,
> KEINE schweren Parallel-Jobs."** — LEDGER:3856 (Nachtrag 04.08.2026 abend, E-24 VOLLZOGEN)

Praezisierte Vollform (Uebergabe 04.08., SESS/20260804-UEBERGABE-e24-vollzogen-vor-anker-strecke.md:59-61):

> "**EIN ANKER-VOLLZUG** (GATE 5 = TP1-Neu-Inventur [2d-gehaerteter Bestandslog-Pfad, Arbeits-Ist]
> + A2-SHA512-only-Skip-Gate-Eichung GENAU EINMAL, L14: MIT leerem Overlay-Glied -- deklarierte
> Luecke). Der Anker beendet die Job-Sperre."

GATE-5-Urdefinition (Lage-Dossier :228; die vielzitierte ":209" ist der kritische Pfad ebd.):

> "**GATE 5 — A2 SHA512-only-Skip-Gate** (F7) auf v6-Fingerprint; einmalige Eichung nach A13/E-24."
> — SESS/backups/20260802-kontext-neugruendung-abend-workflows/00-SYNTHESE-lage-dossier.md:228
> (identisch in ergebnisse/48-c90c5b72.md:228)

Kanon-Klammer des E-24-Bauplans (SESS/20260803-DOSSIER-e24-fenster-bauplan.md:577-579):

> "E-24 = GATE 4; der EINE Anker-Vollzug (TP1 + A2) = GATE 5 -- GENAU EINMAL, danach nur noch
> fingerprint-neutrale Arbeit bis zum Trigger."

Wiederholt bindend in beiden Pause-Docs:
- SESS/20260804-PAUSE-abbruchsicher-s5-wellen-landebereit-vor-anker.md:80-82: "**EIN ANKER-VOLLZUG** (GATE 5 = TP1-Neu-Inventur + A2-SHA512-Eichung GENAU EINMAL, L14 leeres Overlay-Glied) — beendet die Job-Sperre."
- SESS/20260805-PAUSE-abbruchsicher-01c-komplett-vor-phase-b-anker.md:77-80: wortgleich, plus "Danach Phase 3 Parallel-Spuren / Phase 4 Beweise / Phase 5 TRIGGER (7-Auflagen LEDGER:98 woertlich; D-10-Eichung L11; J-Kette N live, V32=ON CI-Kanon). **Phase 6 Messung = USER-GO-STOPP.**"
- Memory project_20260805_pause_01c_komplett_vor_phase_b.md:20: "**EIN ANKER** (TP1-Inventur + A2-SHA512-Eichung GENAU EINMAL; beendet Job-Sperre)".

AKTUELLE EINORDNUNG (05.08. mittags, Ledger ist juenger als die Pause-Docs): LEDGER mittag-2 (:4042)
drehte kurz auf "erst ... W1-W5 -> DANN Anker"; **mittag-4 (:4057) dreht ZURUECK und ist der juengste
bindende Stand:** "Phase B GELANDET -> **ANKER wie geplant** (beendet Job-Sperre) -> W1 (Di/Mi) ...
Task-Board entsprechend gedreht (**Anker VOR W1**)."

---

## 1. KERNFRAGE: Was GENAU ist die TP1-Neu-Inventur?

**Was TP1 ist:** Die parallel zur Bau-Strecke entstandenen **Lager-PROBE-Bestaende** der Lager-Strecke
(TP1 = das Lager-Truth-Check-/Probe-Paket: "TP1 Teil A Takeover (G-E1) FERTIG; Teil B Praesenz-Filter
(G-A2/G-E2)", SESS/20260802-KATALOG-offene-strecke-gesamtplan.md:17). Ur-Beleg:

> "Lager-Bezug: Fingerprint-Global-Shift durch A13-M2/M3 → parallel entstehende Lager-Probe-Bestaende
> (TP1) muessen nach M3 neu inventarisiert werden (Schnittstelle an Lager-Strecke gemeldet)."
> — SESS/20260802-BAUPLAN-owner-entscheide-synthese-kritischer-pfad.md:9

**Was die Neu-Inventur tut (Bestaende, Werkzeug, Umfang):**

> "(i) TP1-Lager-Neu-Inventarisierung (NACH der M3-Landung) ... Operativer Nach-Lande-Schritt, KEIN
> ce-Commit: Bestaende [minio] gegen die neuen v6-Fingerprints/Lager-Keys neu inventarisieren;
> Alt-Bestaende nach Backup-Doktrin additiv stehen lassen (Messdaten/Rohdaten nie loeschen)."
> — SESS/20260803-DOSSIER-a13-m3-ausfuehrung.md:92-94

- **Bestaende:** die TP1-Probe-Binaries im minio-Objekt-Store (Lager), NICHT der lokale gn_out-Bestand.
  Abgrenzung W10-Dossier: "Die R15-Inventur deckt dabei NUR das Bestandslog (PresenceFn) -- das LOKALE
  dll_is_current-Gate deckt W10-M2." (SESS/20260803-DOSSIER-w10-system-zellwerte-bauplan.md:329-333)
- **Werkzeug:** der **"2d-gehaertete Bestandslog-Pfad"** (UEBERGABE 04.08.:59) — d.h. der in Welle 2d
  gehaertete Praesenz-Filter/PresenceFn-Pfad (`bestandslog/planer_driven_build.hpp`,
  `filter_window_for_build`, realer `bestand_key_of`-Provider; Test `test_tp1_planer_filter_iterator.cpp`,
  literales Gate TP1_ANKER_OK — LEDGER:3630/:3657; SESS/20260803-DOSSIER-e07-gate-definition-b5-zweistufig.md:41).
  Die operative **TP1-Arbeits-Inventur-DEKLARATION** landete in der Lager-Rest-Welle Scheibe S5
  af7b1abc (LEDGER:3782).
- **Umfang/Zeitpunkt:** Arbeits-Ist-Inventuren nach jedem Shift (nach M3: LEDGER:3755; nach W10:
  LEDGER:3805 "TP1-ARBEITS-INVENTUR-SIGNAL"), aber **"FINAL erst nach dem LETZTEN Shift vor A2
  (W10/E-24)"** — "einmal am Anker-Vollzug, nicht doppelt (R15)"
  (SESS/20260803-DOSSIER-a13-m3-ausfuehrung.md:175/:212; e24-fenster-bauplan.md:424: "TP1-Inventur
  EINMAL nach Fenster + A8-binary-Scheiben / A2-Eichung erst danach (GATE 5)").
- FAHRPLAN:18: "A2-SHA512-only-Skip-Gate: Eichung EINMALIG ZULETZT nach W10+E-24; **danach
  TP1-FINAL-Inventur**." (Reihung im Fahrplan; die Gate-Bilanz e24:424 zaehlt Inventur vor Eichung —
  beide Quellen binden beides in DASSELBE eine Anker-Fenster.)

---

## 2. KERNFRAGE: Was GENAU ist die A2-SHA512-Eichung?

**A2** = KATALOG-Posten: "| A2 | **SHA512-only-Skip-Gate** | F7: Skip-Entscheid kuenftig NUR
SHA512-Fingerprint (deckt alle Stempel) | offen |" (SESS/20260802-KATALOG-offene-strecke-gesamtplan.md:18).

**F7-Spez (Owner-Wort + Umbau), was geeicht wird und wo es persistiert**
(SESS/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:72, "F7: SHA512-ONLY-SKIP-GATE-SPEZ"):

> "Owner-Wort: Skip-Pruefung NUR gegen die komplex geplante SHA512-Validierung — sie deckt ALLE
> Stempel allein ('das war der Sinn des SHA512'), effizienter als 4 Einzelpruefungen. ...
> UMBAU dll_is_current (bo:251-276): expected = CT-Fingerprint der aktuellen Bau-Identitaet;
> Skip <=> .fingerprint-Sidecar == expected — EIN Vergleich. JA, er ersetzt
> .version/.algos/.variant-Vergleiche KOMPLETT (F7 'NUR') ... UEBERGANGS-REGEL Bestands-Sidecars
> ohne .fingerprint: FAIL-CLOSED — kein .fingerprint => nicht aktuell => Neubau."

- **Geeicht wird** das Skip-Gate **auf den v6-Fingerprint** (Lage-Dossier :228: "auf v6-Fingerprint"),
  d.h. auf die END-Form des Preimages nach M3/C3: injektiv ('\n'-Separator), fingerprint_format-ERSTGLIED,
  Sub-Achsen-WERTESET-Glied, Overlay-Glied strukturell (LEDGER:3750, C3 bfc98008), plus W10-Zellwerte
  und E-24-Major-8-Welt. Zum Eich-Zeitpunkt existiert das Gate noch nicht als Code: "Das
  A2-SHA512-only-Gate EXISTIERT NOCH NICHT als Code." (w10-bauplan.md:338-341) — die Eichung IST der
  Umbau von dll_is_current auf den EINEN Vergleich am finalen Fingerprint-Stand.
- **Persistenz:** `.fingerprint`-Sidecar neben jeder Binary (expected-Vergleichswert) + die EINE
  Schluessel-Welt "fingerprint_key_source wird die EINE Schluessel-Quelle: Skip-Gate == minio-Key ==
  Bestandslog key_sha512 == Baum-Blatt-Identitaet == ceb_key_sha512-Bindung" (F7-Spez, KONSOLIDIERT:72);
  LagerKey-Konsument `bld/bestandslog/bestandslog_index.hpp:99-104` (LEDGER:3683).
- **Skip-Gate-Bezug/Fundament:** "die Injektivitaet ist die Eigenschaft, auf der das
  SHA512-only-Skip-Gate (GATE 5) ruht" (a13-m3-ausfuehrung.md:266); "Fundament des SHA512-only-Skip-Gates
  (F7/GATE 5: 'der deckt die anderen Stempel allein')" (OWNER-VORLAGEN-konsolidiert.md:27).
- Bis zur Eichung bleibt der K1-Cross-Check (OS-Familie aus .version-Sidecar) als "ZWEITE
  Verteidigungslinie ..., bis das A2-Gate geeicht ist" (w10-bauplan.md:346-348).

---

## 3. KERNFRAGE: Was bedeutet "L14 leeres Overlay-Glied"?

L14-Deklarationssatz (FAHRPLAN, SESS/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:58):

> "**PHASE 2 += L14 Deklarationssatz:** Das A2-Skip-Gate wird MIT LEEREM Overlay-Glied (5./6.
> Preimeage-Glied traegt nur Separator+Format) geeicht und faehrt so durch den Voll-Bau;
> ABNAHME-3/4-Voll-Soll erfuellt sich erst mit dem Overlay-Fenster (Phase 6) = deklarierte,
> nicht stille Luecke."

Vollform E24-Bauplan 5.4 (e24-fenster-bauplan.md:438-443): "Die A2-SHA512-Eichung laeuft EINMALIG
ZULETZT nach W10+E-24+A8-binary-Scheiben (GATE 5) und wird MIT LEEREM Overlay-Glied geeicht (5./6.
Preimage-Glied traegt nur Separator+Format; Naht seit M3/C3 layout-bruch-frei vorbereitet,
LEDGER:3744/:3748). ... Die 3 Overlay-Owner-Festlegungen existieren NIRGENDS (echtes NICHT-GEFUNDEN,
LEDGER:3731) -- nicht-blockierend."

**Bedeutung fuer die Eichung:**
- Das C3-Overlay-Glied ist STRUKTURELL gebaut, aber inhaltsleer: "Overlay-Glied strukturell [traegt
  bis zur Owner-Definition nur den Separator — spaetere Scharfschaltung OHNE Layout-Bruch]"
  (LEDGER:3750, C3 bfc98008). Die 3 fehlenden Owner-Festlegungen sind: Verzeichnis-Schnitt,
  Sortier-Ordnung, Hash je Datei vs. Konkatenation (a13-m3-ausfuehrung.md:233; e24:542).
- Folge: der SHA512 deckt Quell-Code-Aenderungen (Overlay-Source-Hashes, ABNAHME-3+4-Soll) beim
  Eichen und im Voll-Bau NOCH NICHT — das ist eine DEKLARIERTE, keine stille Luecke; geheilt erst im
  Overlay-Fenster (Phase 6, nach Abgabe-Messfenster) mit den 3 Owner-Festlegungen.
- Kosten-Hinweis, warum NICHT vorher scharfschalten: "Das Scharfschalten des Overlay-Glieds aendert
  JEDEN Fingerprint (auch mit leerem→gefuelltem Glied ...) — nach Voll-Bau-4 ist das ein ZWEITER
  globaler Neuanker ueber den vollen Bestand + erneute TP1-Inventarisierung."
  (a13-m3-ausfuehrung.md:233) — dank layout-bruch-freier Naht aber OHNE Layout-Bruch moeglich.

---

## 4. KERNFRAGE: Was beendet die Job-Sperre formal, was ist waehrend des Vollzugs erlaubt?

- **Beginn:** mit der E-24-Landung, kommuniziert als Startklar-9 (LEDGER:3856; e24-bauplan Par. 8
  Punkt 9 :534-536: "Zwischen Fenster-Landung und Anker-Vollzug: Job-Sperre kommuniziert (kein Trigger,
  kein Lager-Voll-Lauf, keine schweren Parallel-Jobs -- E24-DOSSIER:233)").
- **Formales Ende:** der EINE ANKER-VOLLZUG (GATE 5) selbst. Woertlich: "Der Anker beendet die
  Job-Sperre." (UEBERGABE 04.08.:61); "EIN ANKER (GATE 5, beendet Job-Sperre)" (LEDGER:3872);
  Task #3 des Boards traegt exakt diese Formel.
- **Verboten waehrend der Sperre/des Vollzugs (abschliessende Liste, dreifach belegt):**
  (1) KEIN Trigger (Voll-Bau-4 POST /projects/288/pipeline), (2) KEIN Lager-Voll-(Einlagerungs-)Lauf,
  (3) KEINE schweren Parallel-Jobs. (LEDGER:3856; e24:291-292; e24:233-Referenz.)
- **Erlaubt (belegt durch die Praxis unter aktiver Sperre, Gate 384→403):** normale Bau-Wellen und
  Landungen mit der Voll-Kadenz inkl. **regulaerer CI-Verifikations-Pipelines** — "CI-Wache am
  VOLL-SHA laeuft, main-FF nach Gruen" (LEDGER:4042, Phase-B-Landung UNTER aktiver Job-Sperre),
  Pushes, rescue-Refs, Doppellaeufe, read-only-Workflows. Der Kanon "CI-Gruen=Messung AUS"
  (Memory) gilt ohnehin: die normale Pipeline misst/baut nicht voll. Die Sperre trifft also nur die
  drei benannten SCHWEREN Job-Klassen, nicht den CI-Normalbetrieb.

---

## 5. KERNFRAGE: WARUM "GENAU EINMAL" — was macht Wiederholung teuer/verboten?

1. **Doppel-Eichung-Verbot (Reihenfolge-Logik):** Jede Eichung VOR dem letzten Fingerprint-/Byte-Shift
   muesste nach dem naechsten Shift wiederholt werden. "das A2-Gate darf erst nach W10+E-24 geeicht
   werden, sonst doppelte Eichung" (a13-m3-ausfuehrung.md:175); Risiko R15: "verfruehte Gate-Eichung
   oder verfrueht-finale TP1-Inventur muesste doppelt neu geankert werden" (ebd.:212). Kritischer Pfad
   im Lage-Dossier: "A2-SHA512-Gate ZULETZT. Begruendung: A13 aendert Stempel-Layout/Fingerprint-
   Preimage — jedes vorher geeichte Gate muesste doppelt neu geankert werden" (00-SYNTHESE:209).
2. **Preis einer Wiederholung NACH dem Trigger:** jede spaetere Fingerprint-Bewegung = "ZWEITER
   globaler Neuanker ueber 1.572.864 Binaries" (LEDGER:3683/:3701; a13:227/:266) + "erneute
   TP1-Inventarisierung ueber den vollen Bestand" (a13:233). Vor dem Voll-Bau-4 existiert dagegen
   "kein schuetzenswerter Bestand" (LEDGER:3648/:3755) — der Anker ist also der letzte billige Moment.
3. **G8-/Ein-Fenster-Doktrin:** "Nach C11 gilt G8: KEIN ABI-/POD-/Fingerprint-Touch bis zur Abgabe ...
   der EINE Anker-Vollzug (TP1 + A2) = GATE 5 -- GENAU EINMAL, danach nur noch fingerprint-neutrale
   Arbeit bis zum Trigger." (e24-fenster-bauplan.md:576-579.)
4. **Lagerhaltungs-Doktrin:** der Skip-Gate-/Lager-Key-Namensraum ist nach der Eichung die EINE
   Schluessel-Welt (F7); ein zweiter Eich-/Inventur-Durchgang schuefe einen zweiten Namensraum und
   entwertete die Einlagerung (exakt der von Owner-E3/HY-D2 ausgeschlossene Zustand, e24-Kontext
   OWNER-VORLAGEN-konsolidiert.md:73).

---

## 6. KONTEXT NACH DEM ANKER (Trigger-Sequenz, wie beauftragt mit erhoben)

Reihenfolge (Pause-Doc 05.08.:77-80 + FAHRPLAN): ANKER -> Phase 3 Parallel-Spuren -> Phase 4 Beweise
1-5 + 12-Perm -> **Phase 5 TRIGGER-SEQUENZ** -> Phase 6 Messung = USER-GO-STOPP.

- **7-Auflagen-Satz (LEDGER:98, WOERTLICH in den Trigger — L1, FAHRPLAN:55):** "Auflagen: PMC-AND hart,
  COMDARE_MINIO_ENDPOINT=Alias nie S3-URL, NAS=PR4100 Cluster_NFS + df-Wache, Bestands-Invalidierung,
  github-PAT neu aus Vault, main-Nachzug je Welle, keine schweren Parallel-Jobs" (LEDGER:98, V7.4;
  L1-Fassung ergaenzt: "PMC-AND hart (Vendor-Zuordnung vorher belegen — I112:204-212!)").
- **D-10-Eichung/L11 (Phase-5-VORLAUF, eigenstaendige "Eichung", NICHT die A2-Eichung):**
  "L11/D-10: 46er-Differenz-Eichung (lokal 331/332 vs. prod 285, Labels contract|pmc zaehlen) als
  Phase-5-VORLAUF." (FAHRPLAN:56.)
- **J-Kette:** "J-Kette (N = lebendes ctest-Gate, LIVE erheben; V32=ON nur CI-Kanon)" (FAHRPLAN:36;
  Memory reference_ce_jkette_n316_braucht_v32_enable_on: N ist ein lebendes Gate, nie feste Zahl).
- Danach: heavy-Signal (#519) -> Kalibrierlauf GN_TOTAL=64 -> ETA -> VOLL-BAU-4-TRIGGER
  (GN_TOTAL=131072 x 12 Perms = 1.572.864 Binaries; FAHRPLAN:36-39).

---

## 7. SYNTHESE-ANTWORT in einem Satz

Der EINE ANKER-Vollzug (GATE 5) ist das genau einmalige, die Job-Sperre beendende Doppel-Ereignis
NACH der letzten binary-beruehrenden Bau-Scheibe: (a) FINALE Neu-Inventarisierung der minio-TP1-
Probe-Bestaende gegen die v6-Fingerprints/Lager-Keys ueber den 2d-gehaerteten Bestandslog-/PresenceFn-
Pfad (additiv, Alt-Bestaende bleiben) und (b) Eichung des F7-SHA512-only-Skip-Gates auf exakt diesem
finalen v6-Fingerprint-Stand (dll_is_current wird der EINE Vergleich expected == .fingerprint-Sidecar,
fail-closed, eine Schluessel-Welt bis in den Lager-Key), ausdruecklich MIT leerem Overlay-Glied (L14,
deklarierte Luecke bis Phase 6); GENAU EINMAL, weil jede fruehere Eichung nach dem naechsten Shift
doppelt neu geankert werden muesste und jede spaetere Wiederholung nach dem Trigger einen zweiten
globalen Neuanker ueber 1.572.864 Binaries plus Voll-Inventur kostet.
