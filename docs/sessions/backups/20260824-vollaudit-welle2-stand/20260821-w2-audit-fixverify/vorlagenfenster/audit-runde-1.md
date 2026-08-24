# AUDIT RUNDE 1 — Strang "vorlagenfenster" (B-4, F2-Owner-Vorlagen-Fenster)

Auditor: Fable-max, 22.08.2026. Soll-Karte VOLL gelesen (496 Z., P-01..P-29);
Strang-Bericht VOLL gelesen (98 Z.); alle 3 Objekt-Dateien VOLL gelesen; LEAD-ENTSCHEIDE
VOLL gelesen (88 Z.); W2-ABFOLGE-DESIGN B-4 (Z.140-165) + [F] (Z.516-708) + SLOT [B]
(Z.795-804) gelesen; Staffel-Synthesen-Fenster (S1 Z.170-219, S2 Grep-Fenster) gelesen;
Wellenplan-/Designplan-/GOAL-/Ledger-/BAULISTE-Literale einzeln gegengeprueft (s. u.).

OBJEKT:
- D1 = ~/backups-workflow/20260820-w2-sofortstaffel/F2-VORLAGEN-FENSTER-ENTWURF.md (481 Z.,
  mtime 21.08. 09:12:00; Strang-Lieferung, kein Commit)
- D2 = docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md (107 Z., super-Commit
  3e9ec6449788b64363f539ed6b9ecdeadcf94711, 21.08. 09:22:15 +0000; Lead-Vollzug)
- D3 = docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md (88 Z., Erst-Commit
  3e9ec644 mit 83 Z. + Nachtrag 8aae5cd2ac296a1bf143c6df6d1e18205292f72e 21.08. 09:26:33
  +0000 "+5 Zeilen D-12"; Lead-Konsolidierung)
- Git-Beweis (super-Hauptklon, NUR LESEN): `git merge-base --is-ancestor 3e9ec644
  development` rc=0 ("3e9ec644 IS ancestor of development") und dasselbe fuer 8aae5cd2 —
  beide auf development gelandet. `git show --stat`: 3e9ec644 = 2 Dateien/+190;
  8aae5cd2 = 1 Datei/+5. NUR docs/sessions/ beruehrt.

--------------------------------------------------------------------------------
## 1. PUNKT-FUER-PUNKT-TAFEL (dreiwertig; Literal-Belege)

| P | Urteil | Beleg (literal) |
|---|--------|-----------------|
| P-01 Dokument liegt der Landung bei | ERFUELLT | 3 Dateien existieren (481/107/88 Z. voll gelesen); beide Commits Ancestor von development (rc=0, s. o.); Strang-Bericht Z.92-98 "STATUS: LANDEREIF ... B-4-ABNAHME" |
| P-02 Kein Bau-Zweig/Worktree/Compile | ERFUELLT | Bericht Z.39 "Kein Bau-Slot noetig (Dokument-Strang, kein Compile); kein Worktree, keine Commits" + Z.46-48; SLOT [B] am Auftrag Z.803-804 "EIN Strang ... Vorlagen-Fenster als EIN Dokument"; Slot-Protokoll bindet an Vollbau — keiner fand statt |
| P-03 Ledger/Board NICHT geschrieben | ERFUELLT | `grep -c KON120` Ledger = 0; `grep -n F2-VORLAGEN` Ledger = 0 Treffer; Ledger-Kopf Z.19 "KONSOLIDIERUNG CXIX (KON119)"; Entwuerfe als ENTWURF markiert: D1 Z.465-466 "Lead-only; NICHT von diesem Strang zu schreiben", D2 Z.103 "KON120-ENTWURF, Lead schreibt nach Staffel-Synthese" |
| P-04 TABU-Flaechen unberuehrt | ERFUELLT | git show --stat beider Commits: ausschliesslich docs/sessions/*.md (2+1 Dateien); 0 Treffer axes/topics/heuristik/golden/CMakeLists/.gitlab-ci.yml; D1 liegt unter ~/backups-workflow/ |
| P-05 12 B-4-Posten-Gruppen | ERFUELLT 12/12 | Am D1 verifiziert: P1-P7=V-01..V-07 (Z.28/43/55/66/85/103/120) · U-3=V-08 (Z.128) · T-9=V-09 (Z.139) · O1-O4=V-10 (Z.152, 4 Zeilen literal) · R-1=V-11 (Z.177) · FINDINGS#10 in V-11 (Z.178 "OG-15 + OG-14 = EIN Gegenstand ... Dedup hier deklariert") · FINDINGS#19 in V-05/V-06 (Z.85/103 Blockkoepfe) · FINDINGS#22=V-12 (Z.197) · B3-Datum=V-13 (Z.229) · X-8=E-10-Dedup (Z.427 "= P5, KEINE eigene Frage") · U-2=V-14 (Z.243) · F-G(A-18)=Z-03 (Z.404). 0 fehlend |
| P-06 F-II 12 OG-Nummern | ERFUELLT 12/12 | Auftrag Z.547 "F-II ... (12)" mit OG-3/4/5/7/8/9/10/14/15/17/18/19 (Z.548-573 gelesen); jede Nummer steht literal im zugehoerigen Blockkopf von D1 (V-01..V-03, V-06..V-09, V-11 doppelt, V-12, Z-01, Z-02) |
| P-07 F-I 7 OG-Nummern | ERFUELLT 7/7 | Auftrag Z.522-545; OG-1+OG-2=V-04 (Kopf Z.66 "OG-1; OG-2 eingefaltet") · OG-6=V-05 · OG-11=V-14 · OG-12=V-13 · OG-13=V-10 · OG-16=V-18 (Z.322, Zusatzleistung ueber die B-4-Literal-Liste hinaus — NIE-KUERZEN-konform) |
| P-08 Z-01/Z-02/Z-03 | ERFUELLT | D1 Z.381 (OG-18 mit KON104-Par.62-D-Klammer), Z.392 (OG-19 ENTSCHAERFT mit Lead-Entscheid-8-Bezug), Z.404 (F-G/A-18 als DEKLARATION) |
| P-09 ENTSCHIEDEN-Tabelle A2.3a | ERFUELLT | D1 Z.416-427: E-1..E-10 je Verdikt+Beleg; Stichprobe E-1-Beleg am Wellenplan: Z.2157 literal "MARKER 13.08.2026 (KON59): UEBERHOLT ... OF-1 (KON34-06(d) 17-vs-18)" — Beleg traegt |
| P-10 Deltas-Herkunft + Dopplung G01-G22 | ERFUELLT | BAULISTE.md Z.279 literal "## C. OWNER_GATED (22)"; `grep -c "^| G"` = 22; D3 Z.12-15 Dopplungs-Protokoll 10 G-Nummern (G03/04/06/07/08/09/10/12/19/21) + 11 G-basierte Deltas (G01/02/05/11/13/14/15/16/17/18/20+22) + D-12 ohne G = 22/22 gedeckt |
| P-11..P-22 die 12 Deltas | ERFUELLT 12/12 | `grep -n "^### D-"` an D3 = 12 Treffer (Z.19/24/29/35/40/44/47/51/55/59/65/70); Wortlaut-Stichproben gegen BAULISTE: G01≈D-01 (UEBERFAELLIG-Wortlaut deckungsgleich), G11≈D-04 (OV-1+OV-6+D4f, EIN Entscheid), G18≈D-10 (OV-16+OV-17; BAULISTE "-> V10" wurde zu "-> Lande-Zug" uebersetzt, Substanz identisch), G22≈D-11(b) (PA-3/ETA/G13/2 GOs/K-5/OD1-OD4 alle enthalten) — kein Substanzverlust |
| P-23 Staffel-Querbelege | ERFUELLT | S1-SYNTHESE Z.209 Punkt 8 (R-1/OV-10 Dock-Zahl SECHS, "DEDUP-PRUEFUNG Lead ... als Zusatzzeile nachtragen") -> exakt als D-12 vollzogen (Commit 8aae5cd2 09:26:33, 95 s NACH S1-Synthese-mtime 09:24:58). S2-SYNTHESE Z.212 F-122 ("Rest = ENGE Ratifikation ... = D-04 im F2-Fenster") -> D-04 traegt die Ratifikation. Zeitlich konsistent |
| P-24 Freeze-Check-B-4-Abschnitt | LUECKE (Nachlauf) | D2 Z.76-81 vorhanden und zum Commit-Zeitpunkt korrekt ("11 Deltas D-01..D-11", 09:22); seit dem D-12-Nachtrag (09:26) ist die Zahl an Z.79 UEBERHOLT und wurde nicht nachgezogen -> FUND V1-01 |
| P-25 Gesamturteil + KON120-ENTWURF | LUECKE (Nachlauf) | D2 Z.94-101 nennt B-4/G21-Testat-Weg korrekt; der KON120-ENTWURF Z.103-107 traegt "11 Deltas" — bei unkorrigierter Uebernahme buchte der Ledger die falsche Zahl -> Teil von FUND V1-01 |
| P-26 SOFORT-Zeilen 4x konsistent | ERFUELLT | Identische 4 Posten (V-04/V-14/V-18/V-10-O4) an 4 Stellen: D1 Z.470-473 (ENTWURF-A), D3 Z.76-83, D2 Z.80-81 + Z.100-101 |
| P-27 V1/V11 Selbstmessung | ERFUELLT | D1 V-14 Z.249-252 "OBJEKT HEUTE (21.08., selbst gemessen): df / = 208G/251G belegt, 31G frei, 88%"; V-16 Z.288 "OBJEKT NEU GEPRUEFT 21.08. ... 0/0"; Bericht Z.90 "Alle Zahlen der SOFORT-Zeilen selbst gemessen". Kontrollmessung Audit 22.08.: df / = 202G/251G, 37G frei, 85% — konsistent (zwischenzeitliche Teil-Raeumung; die datierte 21.08.-Momentaufnahme war als fallende Reihe 34G->31G plausibel und ist nicht widerlegbar) |
| P-28 II.8 Widersprueche nicht glattgezogen | ERFUELLT | GOAL v8 Z.312 literal gelesen; D1 E-3 Z.420 "KONFLIKT DEKLARIERT: K14-Uebergabe Abschn. 9 ..."; E-5 Z.422 mit frischer 0/0-Gegenprobe; V-01/V-17/V-19 fuehren aeltere-vs-juengere Fassung explizit |
| P-29 TDD-Vertrag Anwendbarkeit | ERFUELLT (ENTFAELLT sachgerecht) | Designplan §3 Z.63-75 literal gelesen: T-1..T-9 binden Tests ("Der Test ist am ersten Tag rot", ctest-Registrierung, Codex-Pass) — der Strang liefert 0 Testcode, 0 Build, 0 Code-Commits (git show --stat: nur .md). Kein Phantom-Fund erhoben |

NICHT-PRUEFBAR: keiner (alle 29 Punkte waren am Objekt pruefbar).

--------------------------------------------------------------------------------
## 2. ZUSATZPRUEFUNGEN (a)-(d)

**(a) TDD-Vertrag je neuem Test:** 0 neue Tests (Beweis: beide Commits enthalten
ausschliesslich .md unter docs/sessions/, git show --stat literal). T-1/T-3/T-4/T-7/T-11c
strukturell nicht einschlaegig — deckungsgleich mit Soll-Karte NICHT-GEFORDERT.

**(b) GOAL-Doktrinen:**
- ASCII: bindet Code-Kommentare/Lint-Dateien (Memory-Dauerregel; Audit-REGELN nennen sie im
  clang-format-Kontext). 0 Code-Zeilen beruehrt -> am einzigen einschlaegigen Gegenstand
  trivial erfuellt. Befund zur Kenntnis: die committeten .md tragen projektuebliche
  Unicode-Typografie (D2: 33x Mittelpunkt, 18x Paragraph, 13x Gedankenstrich, 6x dt.
  Anfuehrung, 5x Haken; D3: 26/17/13/2) — identische Zeichenklassen nutzt der Auftragstext
  W2-ABFOLGE-DESIGN.md selbst; KEIN Fund (Projektpraxis fuer docs/).
- allow_failure JOB-Ebene: kein CI-Artefakt erzeugt; inhaltlich traegt D-10/OV-16 die
  Doktrin-konforme Empfehlung ("Empfehlung ja, Owner-Wort 09.08. traegt sie bereits
  sinngemaess" — GOAL v8 Z.763-766 literal gegengelesen). A2.3a-Grenzfall sauber gehalten:
  vorgelegt wird der konkrete Ausfuehrungs-Entscheid am CEB-emittierten Mess-Job (+OV-17-
  Paket, Fristen 12.08. verstrichen), nicht die entschiedene Grundsatz-Doktrin.
- Hart-Gruen/xlsx: kein Pipeline-/Export-Gegenstand — nicht einschlaegig (Soll-Karte
  NICHT-GEFORDERT bestaetigt).
- TABU/Ledger-Verbot: s. P-03/P-04, beide ERFUELLT.

**(c) Abnahme-Formeln woertlich:** Alle 8 Formeln der Soll-Karte am Objekt gegengelesen;
Wellenplan §21.6-Fensterblock (Z.3145-3156) und §22.3-Kopf (Z.3377-3378) literal
bestaetigt; Ledger KON119-07 Z.227 literal "Freeze-Check Fr 21.08. (R5) -> F2-Vorlagen-
Fenster (R6) ->". Formeln 1-5, 7, 8: erfuellt. Formel 6 (D3 Z.85-88 Selbst-Abnahme):
SUBSTANZ erfuellt (alles liegt bei), aber der Wortlaut "DIESE 11 Deltas" zaehlt das eigene
Dokument falsch -> FUND V1-01.

**(d) Bericht-Behauptungen am Objekt (Stichproben, Zahlen mit Nenner):**
1. "Teil 1: 20 Bloecke V-01..V-20 (19 Vorlagen + 1 Pruefpunkt)" — BESTAETIGT: 20
   ###-Bloecke, V-20 als [PRUEFPUNKT] (Z.360).
2. "Teil 3: E-1..E-10" — BESTAETIGT (10 Tabellenzeilen Z.418-427).
3. "Teil 4 ... 15 Delta-Zeilen" — AUFGELOEST: 14 Aufzaehlungspunkte (grep -c "^- " ueber
   Z.429-462 = 14), der letzte behandelt ZWEI Gegenstaende (E-3 UND E-5) -> 15 in der
   Gegenstands-Zaehlung. Kein falscher Beweis; Nenner hiermit dokumentiert.
4. "alle 15 Auftrags-Bloecke + 3 B-4-Zusaetze + X-8-Dedup" — AUFGELOEST: 15 =
   P1..P7 (7 einzeln) + U-3 + T-9 + O1-O4 + R-1/#10 (EIN Gegenstand, Dedup deklariert)
   + #19 + #22 + B3 + U-2; die 3 Zusaetze = Z-01..Z-03. Kompatibel mit der
   12-Posten-GRUPPEN-Zaehlung der Soll-Karte (P-05); beide decken dieselbe Menge, 0 fehlend.
5. Objekt-Stichprobe V-02/Freeze-Stichprobe (5): am ce-Baum 66de5c09 (Hauptklon, NUR
   LESEN) literal bestaetigt — libs/cache_engine/builder/experiment_tree/
   genus_build_admission.hpp Z.81 `inline constexpr std::array<std::size_t, 6>
   kGenusBuildSlotCounts = {` und Z.190 `static_assert(kGenusBuildSlotCounts.size() == 6,
   ...`. Beide Zeilennummern EXAKT wie behauptet. (D2 kuerzt den Pfad um das
   `libs/cache_engine/`-Praefix — uebliche Kurzform, `git show <voller Pfad>` noetig;
   kein Fund, nur Nachpruef-Hinweis.)
6. "Basis-Referenzen ce 66de5c09 / super a7e8e151 unberuehrt" — BESTAETIGT: 66de5c09 =
   Commit (cat-file), a7e8e151 existiert (20.08. 16:52:30) und ist Ancestor von
   development; der Strang selbst machte 0 Commits.
7. V-11-Substanz gegen Ledger: KON119-06 Z.187-190 traegt die 3 Testnamen literal
   (test_limits_entkopplung_vorstufe + test_lazy_adhoc_source_gen +
   test_axis_registry_roundtrip) — Dedup-These OG-14/OG-15 = EIN Gegenstand haelt.

--------------------------------------------------------------------------------
## 3. FUNDE (nur echte Deltas)

### V1-01 [MILD] — Delta-Zaehler "11" an 4 Stellen nicht auf 12 nachgezogen (Dokument
### widerspricht sich selbst; KON120-ENTWURF wuerde falsch buchen)
OBJEKT: D3 enthaelt 12 distinkte Delta-Bloecke (`grep -n "^### D-"` = 12, Z.19-70; der
Nachtrag-Commit 8aae5cd2 nennt selbst korrekt "Fenster damit 12 Deltas"). Die laufenden
Text-Referenzen blieben auf dem 11er-Stand des Erst-Commits:
- D3 Z.17: "hiermit ins Fenster gehoben — D-01..D-11"
- D3 Z.86 (ABNAHME): "DIESE 11 Deltas"
- D2 Z.79: "(11 Deltas D-01..D-11 aus der W1L-BAULISTE ...)"
- D2 Z.107 (KON120-ENTWURF): "+ 11 Deltas"
WIRKUNG: Owner-Vorlage R6 zaehlt sich selbst falsch (D-12 koennte als Nicht-Bestandteil
gelesen werden); der Ledger-ENTWURF traegt die falsche Zahl in den kuenftigen KON120-Zug.
Inhaltlich fehlt NICHTS (12/12 vorhanden, P-11..P-22).
FIX_WEG (docs-Fix, Lead-/Fix-Stufe im super; Dateien liegen auf development — Fix als
docs-Nachtrags-Commit im Lande-/Fix-Worktree des zustaendigen Strangs, danach
`git push -o ci.skip origin <branch>`; KEIN Ledger-Schreiben — nur die 2 Session-Dateien):
1. docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md Z.17:
   "D-01..D-11" -> "D-01..D-12 (D-12 nachgetragen 8aae5cd2)".
2. ebd. Z.86: "DIESE 11 Deltas" -> "DIESE 12 Deltas".
3. docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md Z.79: "(11 Deltas D-01..D-11"
   -> "(12 Deltas D-01..D-12".
4. ebd. Z.107 (im KON120-ENTWURF-Zitat): "+ 11 Deltas" -> "+ 12 Deltas".
Alternativ deckt der Lead die Stellen beim ohnehin anstehenden KON120-Ledger-Zug mit ab —
dann MUSS der Ledger-Text die 12 tragen und die 2 Dateien im selben docs-Zug nachgezogen
werden (nicht stehen lassen: die ABNAHME-Zeile ist Formel 6 der Abnahme).

### V1-02 [KLEIN] — Reihenfolge-Anomalie: D-12-Block VOR D-11
OBJEKT: D3 Z.65 `### D-12 ...` steht vor Z.70 `### D-11 ...` (numerisch nicht
aufsteigend; Ursache: 8aae5cd2 fuegte D-12 vor dem Schluss-Sammelblock D-11 ein statt
dahinter). Beide Bloecke vollstaendig, keine Inhalts-Luecke.
FIX_WEG: im selben Edit wie V1-01 die Bloecke Z.65-68 und Z.70-74 tauschen (D-11 vor
D-12) ODER eine Ein-Zeilen-Notiz "(D-12 nachgetragen, daher ausser der Reihe)" am
D-12-Kopf setzen. Kosmetik; kein eigener Zug noetig.

--------------------------------------------------------------------------------
## 4. GETRAGENE OFFENE POSTEN (aus F-01..F-123 — KEINE neuen Funde, nur gelistet)

- F-71..F-77 (S1-SYNTHESE Z.176-182, Quelle "vorlagen"): U-2-root UEBERFAELLIG (V-14) ·
  C-3a-Nachfassung (V-04) · GN-9/O4 vor Sa (V-10) · Infra-Termin (V-18) · V8-Quittung
  (V-15) · L-C/E12 (V-16) · L-D node5/node6/id56/id18 (V-17) — alle Owner-/Lead-getragen,
  erwarteter R6-Endzustand (Soll-Karte NICHT-GEFORDERT: "Owner hat noch nicht
  geantwortet" ist KEIN Defekt).
- F-122-Rest (S2-SYNTHESE Z.212 + O-F Z.253-255): Lead soll die D-04-PRAEMISSEN-
  ERGAENZUNG (OV-1-Sachfrage seit 08.08. beantwortet "fuehre beide zusammen"; erbeten nur
  die ENGE Ratifikation Hermite vs. B-Spline-Basis; Wortlaut a19 Abschn. 3.4) an D-04
  uebertragen. ZURECHNUNG GEPRUEFT: S2-SYNTHESE mtime 21.08. 18:20:02 — rund 9 h NACH dem
  D-12-Nachtrag (09:26:33). Der Lead KONNTE das beim Dedup-Zug nicht kennen -> kein
  Versaeumnis des auditierten Objekts; getragener offener LEAD-Posten (bietet sich als
  Beifang des V1-01-Fix-Edits an derselben D-04-Stelle an).
- F-123 (S2): HY-Ebene4a Owner-ENTSCHEID = exakt D-01 im Fenster (getragen).

--------------------------------------------------------------------------------
## 5. ZURECHNUNGS-VERMERK (Soll-Karte S-4 bestaetigt)

Der STRANG lieferte D1 + den Ergebnisbericht (mtimes 09:12:00/09:12:41); D2+D3 sind
NACHGELAGERTE LEAD-Akte (Commits 09:22:15/09:26:33, Selbstbezeichnung "Lead-Vollzug"/
"Lead-Konsolidierung"). Beide Funde V1-01/V1-02 sitzen in den LEAD-Dateien — die
STRANG-Lieferung (D1 + Bericht) ist fundfrei. Die B-4-Abnahme erfuellen beide Ebenen
ZUSAMMEN (Soll-Karte ABNAHME-Formel 6). Weitere Soll-Karten-Spannungen S-3/S-5/S-6
(Praefix-Schreibweise, A-20-OG-Nummern-Ungenauigkeit in der AUFTRAGSQUELLE, GOAL-
"V-1..V-14"-Etikett) am Objekt nachvollzogen: alle ohne Auswirkung auf die Lieferung,
keine Funde. B-1/B-2/B-3/B-5-Inhalte des Freeze-Check-Protokolls: NICHT Gegenstand
dieser Soll-Karte (eigene Straenge) — dort nur die eine B-4-relevante Stichprobe (5)
gefahren (haelt, s. 2(d)5).

## 6. VERDIKT

**FIXES_NOETIG** — 0 ERNST · 1 MILD (V1-01) · 1 KLEIN (V1-02). Beide Funde sind
docs-Nachlauf-Fehler des D-12-Nachtrags in den 2 committeten Lead-Dateien; die
Fenster-SUBSTANZ ist vollstaendig (12/12 B-4-Posten, 12/12 F-II, 7/7 F-I, 3/3
Zusatzbloecke, 10/10 ENTSCHIEDEN-Belege, 12/12 Deltas, 22/22 G-Deckung, 4/4
SOFORT-Zeilen konsistent). Fix-Aufwand: ein docs-Commit, 4 Zeilen-Edits + optionaler
Block-Tausch.
