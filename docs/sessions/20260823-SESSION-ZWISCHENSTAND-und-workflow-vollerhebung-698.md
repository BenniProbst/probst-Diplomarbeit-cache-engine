# ZWISCHENSTAND 23.08.2026 + WORKFLOW-VOLLERHEBUNG (698 Laeufe) — WAS FEHLT POTENTIELL NOCH?

Owner-Order (23.08. nachm., verbatim): "Bitte schreibe eine reiche Zwischenstandsdoku, wir
scheinen viele workflows wirklich vergessen zu haben, welche fehlen potentiell noch? Bitte
suche auch in den beiden Kontexten vor dem letzten, aber dokumentiere nur."
=> DOKU-ONLY. Kein Resume, kein Bau, kein Eingriff aus diesem Dokument. Alle Zahlen sind
EIGENE Messungen vom 23.08. 13:4x-14:0x (Journal-Vollscan + Script-Zuordnung).

---

## TEIL A — WAS GERADE LAEUFT (Stand 23.08. ~14:00)

### A.1 Sieben Session-Workflows (alle resumed nach der Owner-Pause)

| Run-ID | Gegenstand | Stand bei Resume |
|---|---|---|
| wf_b546634b-3f5 | LANDE-ZUG sequentiell (Hauptstrang #131) | ce-Haelfte KOMPLETT (10/10 Merges + Endstand + Floor); offen: super-Merges (s13schema/cidual/w1luecken/kampvor-super/vorlagenfix), prt-art (pinduo->B14), o2/E-7, Gitlink+PZW, KON122, Raeumung |
| wf_bce0efd4-a0d | 12-WOCHEN-RUECKFRAGEN (Opus je Kontext, SEQUENTIELL) | KARTE + 18 Fenster-Dateien im Cache; Rest laeuft einzeln, dann Fable-Synthese (TAFEL-V3 + VERBUCHUNGS-ABGLEICH-8K) |
| wf_c745729a-45f | WELLENPLAN-UPDATE (alle offenen Punkte einplanen) | alle 4 /goal-Referenz-Leser FERTIG; Einplaner + Verify laufen (eigener super-Worktree bau/wellenplan-offene-punkte) |
| wf_98cabd77-2a9 | W2-AUDIT-FIX-VERIFY S1+S2 (#116) | 75 Ergebnisse lagen, 17 Agenten waren limit-tot -> Fix-Verify-Schleifen laufen nach |
| wf_bc7303ab-3c8 | EXPLORE-BUENDEL Tranche 2 (#119) | 10/11; letzte Synthese/Gegenlese laeuft nach |
| wf_f3f75b60-eb4 | RESUME-ABSCHLUSS Audit+Explore | 14/19; W2-Audit-Konvergenz je Strang + Synthesen S1/S2 + Gate |
| wf_23486ee9-a39 | OPUS-6K-NACHHOL-SWEEP | war 8/0 = KOMPLETT TOT; laeuft jetzt erstmals (Dedup gegen KONSOLIDAT-6K beim Ernten!) |

### A.2 Peers (fremde Sessions, koordiniert)

- **cifix-vl3-debug** = FAHRER der Lande-Schlussstrecke: raeumen (df!) -> Mutex -> Riegel-cherry
  1f51eb3d + Verschaerfungen (i) Preflight-Riegel-AUSWEIS/K13 + (ii) NUR-TEST-Kommentar ->
  K17-r4 (4 Zellen, Test 509 3x) -> Gates 6/6 -> gitleaks -> ZWEITER serieller Dual-Push
  (deklarierte A2.1a-Ausnahme) -> CI-Terminal -> Raeumung/O-6-Loeschpruefung.
- **Endstand-Pruefer (a7d3087f)** = Beobachter + Bilanz/KON122-Material + unabhaengige
  Nachmessung (Full-Join-Endprobe Merges 6-10) nach CI-Terminal. KEIN Schreiben.
- 4 weitere Peer-Sessions haben angehalten und quittiert (3x Alt-Session 46375cdc seit 11.08.
  ruhend; 2 leere Sessions ohne Auftrag — eine davon erst durch die Anhalte-Order erzeugt).

### A.3 Objekt-Staende + Ressourcen

- ce: origin==github @ **b247a339**, **CI 16097 SUCCESS** (die rote 16095 ist geheilt).
  LOKAL 1 Commit voraus: **1f51eb3d** (Riegel-cherry, UNGEPUSHT) + 3 uncommittete Dateien
  (Verschaerfung) — beides als Patch gesichert (~/backups-workflow/20260823-pause-sicherung/).
- super: lokal==origin==github @ **38428099** (Pause-Doku); H-23-Design + Recency-Nachtraege
  @ ac69d5e3 darin enthalten.
- prt-art unveraendert (bau/pinduo @ 25bbf2e fuehrend).
- 🔴 **Platte 7.5 G frei (97 %)** — Raeumung ist Schritt 1 des Schlussstrecken-Fahrers.
- 5 super-Worktrees stehen; 0 lokale Bau-Prozesse zum Messzeitpunkt.

---

## TEIL B — DIE VOLLERHEBUNG: 698 WORKFLOW-LAEUFE, 141 MIT OFFENEN AGENTEN

Methode: Scan ueber ALLE `~/.claude/projects/*/*/subagents/workflows/wf_*/journal.jsonl`
(alle Projekt-Pfade, alle Session-IDs), je Lauf `started` gegen `result` gezaehlt.

**🔴 METHODIK-FALLE (wichtig fuer jede Deutung dieser Zahlen): `started > result` heisst NICHT
automatisch "vergessen".** Drei Ursachen mischen sich:
1. **Resume-Inflation:** Jedes `resumeFromRunId` schreibt fuer wiederholte Agenten neue
   `started`-Zeilen, waehrend gecachte Ergebnisse KEINE neue `result`-Zeile erzeugen.
   Beleg am Objekt: wf_2cbc2ee0 (W2-Staffel 1) zeigt 55/10, ist aber als **10/10 Agenten,
   0 Fehler** abgenommen und in Task #108 verbucht; ebenso wf_29b3b9e5 (50/10 -> #109) und
   wf_2c6cd0b8 (54/40 -> #110, dort 38/38 belegt).
2. **Echter Riss** (Spend-/Session-Limit, ENOSPC, API-Fehler) — der Agent starb ohne Ergebnis.
3. **Regulaerer Abbruch** durch TaskStop (Owner-Pausen).
=> Der belastbare Indikator ist **`result == 0`** ("hat NIE etwas geliefert") plus die Frage
**"gibt es einen Traeger/eine Verbuchung zum Gegenstand?"**. Nach dieser Doktrin ist die
folgende Liste geordnet.

---

## TEIL C — HARTE KANDIDATEN: LAEUFE MIT **NULL** ERGEBNISSEN (nie etwas geliefert)

| # | Datum | Run | Agenten | Gegenstand (Script) | Bewertung / Verbuchungs-Lage |
|---|---|---|---|---|---|
| C1 | 11.08. 23:01 | wf_eede2f12-7ed | 16/0 | *(Script nicht mehr auffindbar)* | 🔴 GROESSTER Null-Lauf. Gegenstand unbekannt — Ernte nur ueber agent-*.jsonl-Forensik moeglich. Vollstaendig unverbucht, kein Board-Bezug erkennbar. |
| C2 | 08.08. 13:06 | wf_9292edd5-e13 | 6/0 | gesamtstand-featurediff-wellenplan | 🔴 THEMATISCH BRISANT: genau die Feature-Diff-gegen-Wellenplan-Frage, die heute erneut als #128/Wellenplan-Update laeuft. Wenn er Substanz trug, ist sie nie geerntet. |
| C3 | 07.08. 11:02 | wf_355205a7-f46 | 6/0 | doppel-audit-opus5-3-kontexte | 🔴 Frueher Vorlaeufer der heutigen Kontext-Leser (Opus, 3 Kontexte). Nie geliefert. |
| C4 | 12.08. 16:29 | wf_cd576b6e-94e | 4/0 | wf12-neubau-strang-c-und-a | 🔴 BAU-Strang (Neubau C+A) — ohne Ergebnis; ob Objekt-Substanz entstand, ist offen (Branch-Suche noetig). |
| C5 | 11.08. 12:55 | wf_294faf09-a40 | 4/0 | explore-stempel-mechanik-reimplementierung | 🔴 STEMPEL-Thema (KON38-Klasse). Heute durch D-08-Explore + RECENCY-VERDIKT weitgehend abgedeckt — Dedup-Pflicht bei Ernte. |
| C6 | 09.08. 14:23 | wf_2108232f-afc | 3/0 | *(kein Script)* | unbekannt, klein. |
| C7 | 09.08. 14:26 | wf_fe04933d-1dc | 2/0 | *(kein Script)* | unbekannt, klein. |
| C8 | 19.08. 07:46 | wf_e8c90d63-0f8 | 2/0 | bu-redaktion-kontext14 | BU-Redaktion K14 — Backup-Hygiene; Folge-BUs sind seither gelaufen (#45/#68), vermutlich ueberholt. |
| C9 | 06.08. 15:00 | wf_e23b44bb-a5e | 2/0 | *(kein Script)* | Alt-Kontext 06.08. |
| C10 | 06.08. (4 Laeufe) | wf_fd7950a4 / wf_81bf4fd9 / wf_3bdcf656 / wf_1008c596 / wf_902816c4 / wf_06872254 / wf_5787dfc4 / wf_e13d73bf / wf_e6d8983c | je 1/0 | Einzel-Agenten | Kleinst-Laeufe, meist Sonden; geringe Substanz-Erwartung. |
| C11 | 22.08. 11:44 | wf_23486ee9-a39 | 8/0 | opus-6k-nachhol-sweep | ✅ HEUTE RESUMED (laeuft) — war der einzige Null-Lauf mit Board-Bezug (H2-08 hatte "ausbuchen" empfohlen; Owner-Order 23.08. sticht das). |

**Summe Null-Laeufe: 20** (davon 1 heute resumed, 19 dokumentiert-offen).

---

## TEIL D — GROSSE TEIL-ERGEBNIS-LAEUFE (Substanz da, Rest offen) — mit Verbuchungs-Urteil

| Datum | Run | Bilanz | Gegenstand | Urteil |
|---|---|---|---|---|
| 19.08. | wf_794b904b-d1c | 170/77 (**93 offen**) | owner-audit-ledger-ist-soll | 🔴 GROESSTER offener Lauf der Session. Ledger-IST-SOLL-Audit; Teil-Ergebnisse existieren, eine Gesamt-Ernte ist NICHT als Board-Posten auffindbar. **Hoechster Ernte-Kandidat.** |
| 14.08. | wf_3b74b5cc-5c5 | 68/20 (48) | komplexfix-design-vollbefunde | Komplex-Fix-Design (A2.1b-Stufe). Teilweise in KON-Runden eingeflossen; Restmenge unklar. |
| 08.08. | wf_f39a28a6-0ec | 91/53 (38) | erkenntnisse-fuenf-kontexte | Vorlaeufer der spaeteren Kontext-Leser; grosse Teil-Ernte vorhanden. |
| 11.08. | wf_4579d7c4-37a | 58/33 (25) | w0b-soll-ist-diff-bau-dualreview | W0b-Soll-Ist + Dual-Review; Teil-Ergebnisse in W0b-Landungen sichtbar. |
| 17.08. | wf_9819fde6-9eb | 41/22 (19) | goal-drift-konsolidierung | -> KON97/KON98 GELANDET (#78). Vermutlich vollstaendig geerntet; Rest = Resume-Inflation. |
| 11.08. | wf_e9b2cd97-d5f | 51/38 (13) | *(kein Script)* | unbekannt; grosse Teil-Ernte. |
| 17.08. | wf_a2e443f0-c93 | 24/12 (12) | zehn-wochen-explore-offene-fragen | 🔴 DIREKT relevant fuer die heutige RUECKFRAGEN-TAFEL — der laufende 12-W-Lauf sollte dessen Ergebnisse als Bestand mitlesen. |
| 14.08. | wf_32d107d3-d7f | 27/15 (12) | grosser-explore-gedaechtnisauffrischung-vor-landung | Gedaechtnis-Explore vor Landung; teil-geerntet. |
| 11.08. | wf_296a2353-2d6 | 86/76 (10) | *(kein Script)* | fast vollstaendig; Rest klein. |
| 10.08. | wf_5834b706-7b5 | 41/33 (8) | hauptstrang-alle-offenen-fragen | 🔴 Ebenfalls Fragen-relevant (Bestand fuer die Tafel). |
| 15.08. | wf_bb387379-501 | 16/10 (6) | nachstufe-wa-wb | -> #75 als KOMPLETT verbucht (10/10). Resume-Inflation. |
| 10.08. | wf_e22d25ef-71c | 16/11 (5) | *(kein Script)* | Traeger des X-11-Worktrees (B01-Sicherung in #111 referenziert) — Substanz gesichert. |
| 18.08. | wf_13b562e7-964 | 16/11 (5) | bump15-review-ersatz-lens | Review-Ersatz-Lens fuer #15; #15 ist gelandet+CI-bewiesen. |
| 16.08. | wf_a0e17d5d-f3b | 9/4 (5) | nachstufe-golden-fenster | golden-Fenster ist gelandet (#16/#102). |
| 17.08. | wf_b5b4ac36-583 | 23/19 (4) | w1-go-maximal-parallel | W1-Parallel-Welle; W1 ist versiegelt (#15/#93). |
| 12.08. | wf_d826aca8-6ce | 12/9 (3) | wf11-bau-start-f1-planer-fix-s1-ce-gruen | F1 ist geliefert (#41), S1 gelandet (#30). |
| 12.08. | wf_46baecd5-66e | 7/5 (2) | wf10-drei-explores-hybrid-stempel-io-warmup | E-Warmup verbucht (#27); Hybrid/IO-Teile leben in #86/#88. |
| 14.08. | wf_0d0d78f0-d38 | 9/7 (2) | komplexfix-welle2-stufe2 | Komplex-Fix W2 Stufe 2. |
| 14.08. | wf_dd033e6f-2f5 | 5/3 (2) | landung-stufe3-push-ci-gitlink | Landung Stufe 3 — spaetere Landungen sind CI-bewiesen. |
| 15.08. | wf_a2f3387c-427 | 16/14 (2) | maximal-parallel-2 | Parallel-Welle 2. |
| 19.08. | wf_6ce0675e-2ff / wf_5dd12e19-e73 | 5/3, 10/8 | v08r-bau-slot2 / g2-fertigstellung-slot1 | beide GELANDET+CI-bewiesen (#95 bzw. g2-Kette). |
| 20.08. | wf_654270f1-6b2 | 2/1 (1) | k18-nachlese-sonnet-leser | K18-Nachlese; K18 ist als Arbeitsfehler-Klasse verankert. |

---

## TEIL E — DIE BEIDEN KONTEXTE VOR DEM LETZTEN (Owner-Auftrag: dort besonders suchen)

Zeitfenster 19.-21.08. (K27/K28-Umfeld) + 21./22.08. (K29):

- **19.08.:** wf_794b904b (93 offen, Ledger-IST-SOLL) = der groesste Einzelfund · wf_e8c90d63
  (2/0, BU-Redaktion) · wf_6ce0675e + wf_5dd12e19 (gelandet) · wf_cd301f28 (16/15) ·
  wf_f56de681 (5/4) · wf_ca507b8f (12/11).
- **20.08.:** wf_b1f87e2e (4/3) · wf_654270f1 (2/1).
- **21.08.:** wf_2c6cd0b8 (54/40 -> #110 W1-Vollaudit, verbucht) · wf_2cbc2ee0 (55/10 -> #108,
  verbucht) · wf_29b3b9e5 (50/10 -> #109, verbucht) · wf_b954e62e (10/9 -> #111, verbucht) ·
  wf_95033571 (2/1 -> #113, nachverbucht).
- **22.08.:** wf_94813666 (10/9 -> Anschluss-Leser 9/9, verbucht) · wf_23486ee9 (8/0, heute
  resumed) · wf_f3f75b60 (19/14, heute resumed) · wf_98cabd77 + wf_bc7303ab (heute resumed).

**Befund fuer dieses Fenster:** Die Wellen-/Bau-Laeufe sind durchgehend verbucht (Board #108-#113).
Die AUDIT-/LESE-Laeufe sind die Luecke — namentlich **wf_794b904b (Ledger-IST-SOLL, 93 offen)**
und die zwei Fragen-Laeufe **wf_a2e443f0** (17.08.) + **wf_5834b706** (10.08.).

---

## TEIL F — WAS DARAUS FOLGT (Empfehlung; NICHT ausgefuehrt, Owner entscheidet)

1. **Ernte-Rezept statt Blind-Resume:** Fuer alle Kandidaten gilt zuerst die BESTANDS-Frage —
   `journal.jsonl` + `agent-*.jsonl` tragen die Rueckgaben der gelaufenen Agenten auch dann,
   wenn der Workflow nie endete. Erst LESEN (Forensik), dann entscheiden: ERNTEN (Ergebnis
   verbuchen) / RESUMEN (Rest fahren) / AUSBUCHEN (ueberholt, mit Beleg).
2. **Prioritaet der Kandidaten:** (P1) wf_794b904b Ledger-IST-SOLL 93 offen · (P2) wf_eede2f12
   16/0 unbekannt · (P3) wf_9292edd5 Feature-Diff-gegen-Wellenplan 6/0 · (P4) wf_a2e443f0 +
   wf_5834b706 als BESTAND fuer die laufende Rueckfragen-Tafel · (P5) wf_355205a7 + wf_f39a28a6
   (Kontext-Leser-Vorlaeufer, gegen die heutigen Leser deduplizieren) · (P6) wf_cd576b6e
   (Bau-Strang: erst Branch-Suche, ob Objekt-Substanz existiert).
3. **Dedup-Pflicht:** Mehrere Kandidaten behandeln Gegenstaende, die inzwischen von juengeren
   Laeufen abgedeckt sind (Stempel: RECENCY-VERDIKT; Fragen: 12-W-Lauf; Wellenplan: laufender
   Einplaner). Jede Ernte zaehlt gegen den juengeren Bestand, sonst entstehen Dubletten.
4. **Prozess-Lehre (fuer die Arbeitsweise):** Ein Workflow ohne Endbericht hinterlaesst keinen
   sichtbaren Rest — die Board-/Ledger-Verbuchung haengt am Lead. Kandidat fuer eine
   Dauerregel: **je Workflow-Start ein Board-Traeger MIT Run-ID**, und beim Kontextwechsel eine
   Journal-Bilanz (`started` vs `result` je Run) als Pflicht-Zeile der Uebergabe.

---

## TEIL G — ZAEHLWERK + SELBSTCHECK

- Gescannte Workflow-Laeufe: **698** (alle Projekt-Pfade, alle Session-IDs; Rohliste:
  `~/.claude/jobs/5a19728e/tmp/wf_vollerhebung.txt`).
- Laeufe mit offenen Agenten: **141**; davon **20 mit result==0** (Teil C), **~121 mit
  Teil-Ergebnis** (Teil D + Rest).
- Themen-Zuordnung ueber Script-Dateien: 32 Kandidaten aufgeloest, **7 ohne auffindbares
  Script** (aeltere Laeufe; Ernte nur ueber agent-*.jsonl).
- Heute resumed: **7** Laeufe (Teil A.1) — davon 5 aus frueheren Kontexten.
- Sessions im Scan: 5a19728e (aktuell), 46375cdc (Alt-Session, seit 11.08. ruhend),
  b15ade0e, 4abae2c3 (Spiegel-Eintraege gleicher Runs).
- SELBSTCHECK: Alle Zahlen aus eigener Messung (kein uebernommener Bericht); Doku-only,
  0 Eingriffe; ASCII-nah; Resume-Inflation ausdruecklich als Deutungsfalle benannt und mit
  drei Objekt-Belegen (#108/#109/#110) entkraeftet.

---

## TEIL H — VERBUCHUNG 23.08. (Owner-Order nach Vorlage dieser Doku)

Owner verbatim: "bitte verbuche alle diese Agenten als potentiell gerissene Bau-Straenge und
markiere sie als zu pruefen. Ein resume hat keinen Sinn, nur ein wohl geplanter neuer
workflow, der alle relevanten Ziele heilt. Aber diesen koennen wir erst machen wenn alle
derzeitigen workflows fertig sind, wir haben gerade keine Kapazitaet dafuer."

VOLLZOGEN:
- **Board-Sammeltraeger #134** angelegt: ALLE Kandidaten dieser Doku (Teil C + Teil D + die
  Alt-Session-Laeufe) sind dort namentlich als **POTENTIELL GERISSENE BAU-STRAENGE — ZU
  PRUEFEN** verbucht (A1-A11 Null-Laeufe, B1-B12 Teil-Laeufe, mit Run-ID, Datum, Bilanz,
  Gegenstand, Prioritaet).
- **KEIN Blind-Resume** — als Doktrin fuer diese Klasse festgeschrieben: ein Resume fuehrt
  alte Auftraege gegen einen veraenderten Objekt-Stand und erzeugt Dubletten; stattdessen
  EIN geplanter HEILUNGS-WORKFLOW mit Forensik -> Objekt-Abgleich -> dreiwertigem Urteil
  (ERNTEN / HEILEN / AUSBUCHEN) -> Dedup gegen die juengeren Laeufe -> Heilung in EINEM Zug.
- **GATE:** Der Heilungs-Workflow startet ERST, wenn alle sieben derzeit laufenden Workflows
  terminal sind UND die Lande-Schlussstrecke des Peers durch ist (Kapazitaets-Grund,
  Owner 23.08.). Bis dahin ruehrt niemand die Kandidaten an.
- Prioritaeten im Traeger: P1 wf_794b904b (Ledger-IST-SOLL, 93 offen) · P2 wf_eede2f12 (16/0,
  Gegenstand unbekannt) · P3 wf_9292edd5 (Feature-Diff gegen Wellenplan) · P4 wf_a2e443f0 +
  wf_5834b706 (Fragen-Bestand) · P5 wf_355205a7 + wf_f39a28a6 (Kontext-Leser-Vorlaeufer) ·
  P6 wf_cd576b6e (Bau-Strang, zuerst Branch-Suche).

---

## TEIL I — LIVE-REGISTER DER LAUFENDEN WORKFLOWS + AGENTEN (Stand 23.08. 14:07)

Owner-Order: "Bitte notiere alle derzeit laufenden workflows und Agenten in die
zwischenstandsdoku, wir wollen sie spaeter resumen und uns merken welche potentiell wieder
am spend limit sterben." — Dieses Register ist die RESUME-LISTE fuer den naechsten Riss.
Alle Zahlen live gemessen 14:07 (Journal-Scan). Session-ID = 5a19728e-f6e1-4736-a246-e3fda9ac35a1.

### I.1 Die sieben laufenden Workflows (Live-Bilanz + Spend-Risiko + Resume-Rezept)

| Run-ID | Task-ID | Live 14:07 | letzte Aktivitaet | Modell-Profil | 🔴 SPEND-RISIKO | Bisherige Risse |
|---|---|---|---|---|---|---|
| wf_bce0efd4-a0d (12-W-Rueckfragen) | w9vky25zp | 22 start / 4 res | 13:58 | **Opus 5 max je Kontext-Fenster** (~40 Fenster sequentiell) + Fable-Synthese | **SEHR HOCH** — teuerster Lauf; Opus-max ueber Riesen-Transkripte | 1x Owner-Stop, 1x Umbau parallel->sequentiell |
| wf_23486ee9-a39 (Opus-6K-Nachhol-Sweep) | waqlqw5wg | 16 / 6 | 14:06 | 8x **Opus max** + Fable-Konsolidierung | **HOCH** — war bereits KOMPLETT tot (8/0) | 1x Totalriss 22.08. |
| wf_98cabd77-2a9 (W2-Audit-Fix-Verify) | w6lakww8z | 114 / 87 | 14:06 | Sonnet max + Fable max, viele Agenten | **HOCH** — 17 Agenten waren limit-tot | 1x Limit-Riss 22.08. |
| wf_b546634b-3f5 (LANDE-ZUG) | wbfio8nym | 61 / 13 | 13:50 | Fable max + K17-Bauten (Ressourcen!) | **HOCH** — Bau+Limit doppelt exponiert | 2x (Credit-Riss 22.08., Owner-Pause 23.08.) |
| wf_f3f75b60-eb4 (Resume-Abschluss Audit+Explore) | wsvfiudut | 31 / 25 | 13:59 | Fable max Synthesen/Gates | MITTEL | 1x Riss (Vorlauf) |
| wf_c745729a-45f (Wellenplan-Update) | wzvnkeg94 | 6 / 4 | 13:43 | Fable max (Einplaner = LANGER Einzel-Agent + Verify) | MITTEL — Einzel-Agent mit grosser Schreib-Last | 1x Owner-Stop |
| wf_bc7303ab-3c8 (Explore-Buendel T2) | wfw1h1o2o | 13 / 11 | 14:02 | Fable max Synthese/Gegenlese | NIEDRIG — fast fertig | 1x Limit-Riss 22.08. |

**RESUME-KOMMANDOS (exakt, fuer den naechsten Riss — Script-Pfade sind stabil):**
```
Workflow({scriptPath: "<P>/-home-comdare-Projekte-Research-probst-diplomarbeit-cache-engine/<SID>/workflows/scripts/rueckfragen-vollbild-12w-wf_bce0efd4-a0d.js",       resumeFromRunId: "wf_bce0efd4-a0d"})
Workflow({scriptPath: "<P>/-home-comdare-wt-ce-o2std/<SID>/workflows/scripts/opus-6k-nachhol-sweep-wf_23486ee9-a39.js",                                                 resumeFromRunId: "wf_23486ee9-a39"})
Workflow({scriptPath: "<P>/-home-comdare-Projekte-Research-probst-diplomarbeit-cache-engine/<SID>/workflows/scripts/w2-audit-fixverify-s1-s2-wf_98cabd77-2a9.js",        resumeFromRunId: "wf_98cabd77-2a9"})
Workflow({scriptPath: "<P>/-home-comdare--claude-projects--home-comdare-memory/<SID>/workflows/scripts/lande-zug-sequentiell-wf_b546634b-3f5.js",                        resumeFromRunId: "wf_b546634b-3f5"})
Workflow({scriptPath: "<P>/-home-comdare-wt-ce-o2std/<SID>/workflows/scripts/resume-abschluss-audit-und-explore-wf_f3f75b60-eb4.js",                                     resumeFromRunId: "wf_f3f75b60-eb4"})
Workflow({scriptPath: "<P>/-home-comdare-Projekte-Research-probst-diplomarbeit-cache-engine/<SID>/workflows/scripts/wellenplan-update-offene-punkte-wf_c745729a-45f.js", resumeFromRunId: "wf_c745729a-45f"})
Workflow({scriptPath: "<P>/-home-comdare-Projekte-Research-probst-diplomarbeit-cache-engine/<SID>/workflows/scripts/explore-buendel-tranche2-wf_bc7303ab-3c8.js",        resumeFromRunId: "wf_bc7303ab-3c8"})
```
(`<P>` = /home/comdare/.claude/projects · `<SID>` = 5a19728e-f6e1-4736-a246-e3fda9ac35a1)

### I.2 Agenten / Peer-Sessions (Stand 14:07)

| Agent | Rolle | Zustand 14:07 | Kanal / Merkposten |
|---|---|---|---|
| a7d3087f9b3391c8d | Endstand-Pruefer: Bilanz + KON122-Material + Full-Join-Nachmessung | **running** (Subagent) | SendMessage an `a7d3087f9b3391c8d`; KEIN Repo-Schreiben (Beobachter-Rolle) |
| **cifix-vl3-debug** | FAHRER der Lande-Schlussstrecke (Raeumung ✅ 7.5G->27G, dann Mutex/Riegel-cherry/Verschaerfungen/r4/Gates/2. Push/CI/Raeumung) | 🔴 **NICHT in ListAgents sichtbar** — Status unklar (evtl. Limit oder nicht gelistet); Raeumung ist am Objekt belegt | SendMessage an `cifix-vl3-debug`; bei Riss: Schlussstrecke NEU zuweisen (Mutex-Protokoll, §7-Marker) |
| e1-e4-ebenen-konsolidierung [b53d66/2fb974/86de29/e5c0c5] | Alt-Session 46375cdc-Spuren | idle (angehalten, quittiert) | ruhen seit 11.08.; keine unfertige Arbeit |
| cross-session halt order [268d63] · workflow halt protocol [ee315a] | leere Sessions (nie beauftragt) | idle | nichts zu resumen |

### I.3 Ressourcen + Merkposten fuer den naechsten Riss

- **Platte: 27 G frei (90 %)** — der Schlussstrecken-Fahrer hat geraeumt (vorher 7.5 G/97 %).
  Vor dem naechsten 4-Zellen-Kombibau erneut messen (df-Gate >= 5 G, praktisch >= 15 G).
- **Riss-Erkennung:** `task-notification` mit "hit your session limit" ODER Journal-Stillstand
  > 20-30 min (NICHT frueher — Denkphasen-Falle, s. Memory-Nachtrag 23.08.).
- **Riss-Reihenfolge beim Wiederanlauf:** (1) Objekt messen (ce/super-HEAD, porcelain, df,
  CI-Lage), (2) diese Tabelle abarbeiten — zuerst die BILLIGEN (bc7303ab, c745729a), dann
  f3f75b60/98cabd77, dann die teuren Opus-Laeufe (bce0efd4, 23486ee9), zuletzt der Lande-Zug
  (er braucht freie Bau-Slots + Platte), (3) Peers per SendMessage wieder in Fahrt setzen.
- **Kein Doppel-Start:** Vor jedem Resume `journal.jsonl`-Bilanz messen; gecachte Agenten
  kommen sofort zurueck, nur echte Risse laufen neu (Cache-Key = Prompt+Opts unveraendert).
- **#134-GATE bleibt:** Der Heilungs-Workflow fuer die gerissenen Alt-Straenge startet erst,
  wenn ALLE sieben hier gelisteten Laeufe terminal sind und die Schlussstrecke durch ist.
