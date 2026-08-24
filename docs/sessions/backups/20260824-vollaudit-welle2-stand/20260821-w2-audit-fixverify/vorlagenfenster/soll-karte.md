# SOLL-KARTE — Strang "vorlagenfenster" (Wellenplan/W2-ABFOLGE-DESIGN Posten B-4)

Erhoben von: Sonnet-max Planungs-Erheber, 21.08.2026 (NUR LESEN, kein Fix).
Gegenstand: das F2-Owner-Vorlagen-Fenster (Ein-Satz-Vorlagen "MIT der Landung, vor Fr 21.08.").
Konsumiert vom W2-Audit gegen den Strang-Ergebnisbericht
`~/backups-workflow/20260820-w2-sofortstaffel/vorlagen-fenster-ergebnis.md` (voll gelesen)
und die drei tatsaechlich existierenden Liefer-Dateien (alle drei VOLL gelesen, s. u.).

## 0. OBJEKT-LAGE (Vorklaerung, damit das Audit die richtigen Dateien pruft)

Es gibt DREI Dokumente, nicht zwei — der Auftrags-Steckbrief nennt zwei Dateinamen ohne
Datumspraefix; am Objekt tragen beide Dateien das Praefix `20260821-` und es kommt eine
DRITTE (die eigentliche ENTWURF-Lieferung des Strangs) hinzu:

1. `~/backups-workflow/20260820-w2-sofortstaffel/F2-VORLAGEN-FENSTER-ENTWURF.md` (481 Z.,
   mtime 21.08. 09:12) — DIE STRANG-LIEFERUNG selbst (Primaertraeger laut
   STAFFEL1-SYNTHESE.md:194 "Primaertraeger ist das gelieferte Fenster-Dokument
   F2-VORLAGEN-FENSTER-ENTWURF.md"). Kein Branch, kein Commit (Dokument-Strang).
2. `docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md` (107 Z., super-Commit **3e9ec644**,
   Ancestor von HEAD 5b5a818f auf `development`, git-bestaetigt) — Lead-Vollzug des
   GESAMTEN [B]-Fixpunkt-Blocks B-1..B-5 (§18.3-Original-Pruefung, §23.1-Liste,
   §23.2-Tafel, VORLAGEN-FENSTER, W1-Nachlande-Pointer). NUR der B-4-Abschnitt
   (Z.76-81+103-107) gehoert zum Gegenstand dieser Soll-Karte.
3. `docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md` (88 Z., super-Commit
   **8aae5cd2**, ebenfalls Ancestor von HEAD, git-bestaetigt) — Lead-Konsolidierung: verweist
   VOLLSTAENDIG auf Dokument 1 ("GILT VOLLSTAENDIG, wird hier NICHT dupliziert", Z.6) und
   traegt zusaetzlich 12 BAULISTE-Deltas D-01..D-12 (aus `~/backups-workflow/
   20260821-w1-luecken/BAULISTE.md` Teil C, G01-G22-Owner-gated-Zeilen, plus 1 Nachtrag
   aus dem s8-Strang).

Dokument 1 stammt VOM STRANG (vorlagen-fenster-ergebnis.md kennt und behauptet NUR dieses).
Dokumente 2+3 sind NACHGELAGERTE LEAD-Akte (Selbstbezeichnung "Lead-Vollzug"/
"Lead-Konsolidierung"; mtime 09:22/09:26, ~10-14 min NACH der Strang-Lieferung 09:12) —
der Strang-Ergebnisbericht erwaehnt sie NICHT (kann er nicht, sie entstanden danach).
Das Audit muss dies bei "behauptet der Strang-Bericht es" sauber unterscheiden (s. PRUEFLISTE).

Beide Lead-Dateien sind bereits auf `super/development` gelandet (kein offener Branch, kein
Merge-Bedarf) — bestaetigt: `git merge-base --is-ancestor 8aae5cd2 HEAD` rc=0.

---

## PRUEFLISTE

Format je Punkt: WAS (woertlich, Quelle+Zeile) — WIE pruefbar — BEHAUPTET (Strang-Bericht
vorlagen-fenster-ergebnis.md, ja/nein/Lead-Dokument).

### A. META (Existenz, Landung, Formalien)

**P-01 — Dokument liegt der Landung bei (Kern-Abnahme).**
WAS: W2-ABFOLGE-DESIGN.md:159 "ABNAHME: Fenster-Dokument mit allen Zeilen liegt der Landung
bei." (B-4-Zeile) · gleichlautend Wellenplan v2 Z.3146 "FRIST: mit der Landung, vor F2
(Fr 21.08.)."
WIE: Existenzprobe der 3 Dateien (s. Abschnitt 0) + `git merge-base --is-ancestor <sha> HEAD`
fuer die 2 committeten.
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:92-98 "STATUS: LANDEREIF ... B-4-ABNAHME:
'Fenster-Dokument mit allen Zeilen liegt der Landung bei' — alle 15 Auftrags-Bloecke + 3
B-4-Zusaetze + X-8-Dedup abgedeckt." (nur fuer Dokument 1; Dokumente 2+3 sind Lead-Nachtrag,
s. Abschnitt 0 — dort per Commit-Nachricht `3e9ec644`/`8aae5cd2` behauptet, nicht per
Strang-Bericht).

**P-02 — Kein Bau-Zweig, kein Worktree, kein Compile (Auftrags-Charakter).**
WAS: Auftrags-Steckbrief dieser Erhebung: "Kein Bau-Zweig (Doku-/Read-only-Strang)."
Deckungsgleich mit W2-ABFOLGE-DESIGN.md SLOT [B] Z.803-804: "SLOT [B] Fr: EIN Strang
(Freeze-Check ist seriell; Vorlagen-Fenster als EIN Dokument)."
WIE: `git worktree list` im super-Repo — kein `wt-*vorlagen*`-Eintrag (bestaetigt, Listing
zeigt nur cidual/kampvor/s13schema/w1luecken).
BEHAUPTET: JA, explizit — vorlagen-fenster-ergebnis.md:39 "Kein Bau-Slot noetig
(Dokument-Strang, kein Compile); kein Worktree, keine Commits." und Z.46-48 "Kein Worktree
dieses Strangs vorhanden ... und keiner noetig: reiner Dokument-Strang, kein Compile, daher
auch kein Bau-Slot gezogen."

**P-03 — Ledger/Board NICHT vom Strang geschrieben (Lead-only-Regel).**
WAS: Diese Erhebungs-REGELN sowie Owner-Dauerregel: Ledger/Board sind Lead-only; Entwuerfe
gehoeren in die Berichts-Datei.
WIE: `grep -n "F2-VORLAGEN\|KON120" docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — 0
KON120-Treffer am Ledger-Kopf zum Erhebungszeitpunkt (Ledger-Kopf bleibt KON119).
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:87 "Ledger NICHT geschrieben (Entwuerfe in
Teil 5 des Liefer-Dokuments)." Deckt sich mit dem Objekt: F2-VORLAGEN-FENSTER-ENTWURF.md
Teil 5 (Z.465-479) traegt 3 ENTWURF-Zeilen A/B/C mit dem Vermerk "Lead-only; NICHT von
diesem Strang zu schreiben" (Z.465-466); Freeze-Check-Protokoll traegt einen weiteren
KON120-ENTWURF (Z.103-107), ebenfalls als Entwurf markiert, nicht als vollzogene Buchung.

**P-04 — TABU-Flaechen unberuehrt (axes/topics/heuristik/golden/CMakeLists-Ende/ASCII).**
WAS: Erhebungs-REGELN dieses Auftrags (TABU-Block) — gilt fuer JEDEN Strang, auch
Doku-Straenge.
WIE: bei einem reinen `.md`-Dokument-Strang trivial erfuellt (keine Quelldatei angefasst) —
Gegenprobe: alle 3 Lieferdateien liegen unter `docs/sessions/` bzw. `~/backups-workflow/`,
0 Treffer unter `axes/`, `topics/`, `heuristik/`, keine golden-XML/Lock-Datei beruehrt.
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:88-89 "Keine Commits, keine Pushes, keine YAML,
keine axes/topics/heuristik-Beruehrung, keine golden-/TABU-Datei angefasst. Messdaten
unberuehrt."

### B. DER KERN-AUFTRAG — DIE 12 IM B-4-TEXT NAMENTLICH GEFORDERTEN POSTEN

**P-05 — Vollstaendigkeits-Anker: B-4-Text nennt namentlich 12 Posten-Gruppen.**
WAS (woertlich, W2-ABFOLGE-DESIGN.md:152-159): "B-4 VORLAGEN-FENSTER (Ein-Satz-Vorlagen MIT
der Landung) — Inhalt owner-gated, je Frage genau einmal in [F]: P1-P7 [OG-3..OG-8 +
OG-1(P4)] · NEU-Zeile U-3 + T-9-CSV-Anhang [OG-9/OG-10] · O1-O4 (S-19, FINDINGS#16) [OG-13]
· R-1-Meldung 3 Dauerrote (KON119-06) [OG-15] · FINDINGS#10 Achse-06-Anker [OG-14] ·
FINDINGS#19 P5/P6-Detail [OG-6/OG-7] · FINDINGS#22 R-2-Vorschlagsliste [OG-17] ·
B3-Owner-Datum [OG-12] · X-8-Form-Satz (=P5) [OG-6] · U-2-Betriebspunkt Platte [OG-11] ·
F-G-Deklaration (A-18)."
WIE: Zeile-fuer-Zeile-Abgleich gegen Teil 1+2 des ENTWURF.
BEHAUPTET (je Teilposten, alle JA):
- P1-P7 -> V-01..V-07 (alle 7 vorhanden, Z.28-126 des ENTWURF)
- U-3 -> V-08 (Z.128-137)
- T-9-CSV-Anhang -> V-09 (Z.139-150)
- O1-O4 -> V-10 (Z.152-175, alle 4 Owner-Punkte literal aus dem s19-Strang uebernommen)
- R-1-Meldung 3 Dauerrote -> V-11 (Z.177-195)
- FINDINGS#10 Achse-06-Anker -> IN V-11 gedoppelt gefuehrt (OG-14+OG-15 = EIN Gegenstand,
  explizit dedupliziert, Z.178+443-444)
- FINDINGS#19 P5/P6-Detail -> in V-05 (Z.85-101) und V-06 (Z.103-118) je zitiert
- FINDINGS#22 R-2-Vorschlagsliste -> V-12 (Z.197-227)
- B3-Owner-Datum -> V-13 (Z.229-241)
- X-8-Form-Satz(=P5) -> explizit als "=P5, KEINE eigene Frage (Dedup)" in E-10 gefuehrt
  (Teil 3, Zeile "E-10"), NICHT als eigener V-Block (korrekt lt. Auftrag "=P5")
- U-2-Betriebspunkt Platte -> V-14 (Z.243-256)
- F-G-Deklaration(A-18) -> Z-03 (Teil 2, Z.404-410)
ERGEBNIS: 12/12 der literal genannten B-4-Posten sind am Objekt vorhanden. 0 fehlend.

### C. DIE [F] F-II-GRUPPE (12 OG-NUMMERN, EIGENSTAENDIGER ZAEHLER-BELEG)

**P-06 — F-II-Gruppenzaehler.**
WAS (woertlich, W2-ABFOLGE-DESIGN.md:547): "F-II F2-VORLAGEN-FENSTER (Ein-Satz-Vorlagen MIT
der Landung, vor/zu Fr 21.08.) (12):" — die 12 Zeilen sind OG-3,OG-4,OG-5,OG-7,OG-8,OG-9,
OG-10,OG-14,OG-15,OG-17,OG-18,OG-19 (Z.548-573).
WIE: Cross-Count OG-Nummer je V-/Z-Block (Tabelle unten).
BEHAUPTET: implizit JA, kein Strang-Statement nennt "F-II" woertlich, aber alle 12 Nummern
sind am Objekt gedeckt:

| OG-Nr | Gegenstand | Deckung im ENTWURF |
|---|---|---|
| OG-3 | P1 AxisKind | V-01 |
| OG-4 | P2 E-6-Satz | V-02 |
| OG-5 | P3 KON60-04 | V-03 |
| OG-7 | P6 golden-Nachposten | V-06 |
| OG-8 | P7 NP-02 | V-07 |
| OG-9 | U-3 axis_cross_product | V-08 |
| OG-10 | T-9-CSV-Anhang | V-09 |
| OG-14 | FINDINGS#10 Achse-06 | V-11 (dedup mit OG-15) |
| OG-15 | KON119-06 3 Dauerrote | V-11 |
| OG-17 | R-2-Komplex | V-12 |
| OG-18 | OV-S13-4 Fingerprint | Z-01 |
| OG-19 | Kapazitaets-Cave | Z-02 |

ERGEBNIS: 12/12 F-II-Nummern gedeckt (10 eigene V-Bloecke, 2 Z-Bloecke; OG-14/OG-15
bewusst zusammengelegt).

**P-07 — F-I-Gruppe (7 OG-Nummern, "AKUT/BLOCKIEREND") — Cross-Beleg zur B-4-Liste.**
WAS (Z.522-545): OG-1,OG-2,OG-6,OG-11,OG-12,OG-13,OG-16.
WIE/BEHAUPTET:

| OG-Nr | Gegenstand | Deckung |
|---|---|---|
| OG-1 | P4 Comp-Gate | V-04 |
| OG-2 | #38a2-Fallweg 18.6(3) | in V-04 eingefaltet (Blocktitel nennt "OG-2 eingefaltet") |
| OG-6 | P5 V-08R-Form | V-05 |
| OG-11 | U-2 Platten-Raeumung | V-14 |
| OG-12 | B3-Owner-Datum | V-13 |
| OG-13 | O1-O4 | V-10 |
| OG-16 | #84 Infra-Rotation | V-18 (UEBER die B-4-Literal-Liste hinaus geliefert — s. NICHT-GEFORDERT) |

ERGEBNIS: 7/7 F-I-Nummern gedeckt (OG-16 ist eine freiwillige Zusatzleistung, s. u.).

### D. TEIL 2 — DIE 3 NIE-KUERZEN-ZUSATZBLOECKE

**P-08 — Z-01 OV-S13-4 Fingerprint-Uebertragbarkeit.**
WAS: B-4-Text nennt "F-G-Deklaration (A-18)" separat von den OG-Nummern; Z-01/Z-02 stammen
aus F-II (OG-18/OG-19), Z-03 aus [D] D-8b/A-18 (Z.111-113: "A-18 F-G-Deklaration
clang-debug-ENTLASTET fuer den Freeze-Check mitfuehren").
WIE: Datei-Abgleich Teil 2 (Z.376-410 des ENTWURF).
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:54 "Teil 2: 3 NIE-KUERZEN-Zusatzbloecke aus
B-4/[F]-F-II (OG-18, OG-19, F-G/A-18)." Alle 3 vorhanden (Z-01/Z-02/Z-03).

### E. TEIL 3 — DIE ENTSCHIEDEN-TABELLE (A2.3a-NEIN-PROBE-PFLICHT)

**P-09 — Methodenpflicht: bereits Entschiedenes NICHT nochmal vorlegen.**
WAS: Auftragsmethode des Strangs (ENTWURF Z.7-9): "Methode: A2.3a-NEIN-PROBE je Frage gegen
KON119 ... bereits Entschiedenes NICHT vorgelegt, sondern in der ENTSCHIEDEN-Tabelle
(Teil 3) mit Beleg." Dies ist eine generische GOAL-v8-Doktrin (TEIL II.8: "Widersprueche
nicht glattrechnen ... Objekt vor Aggregat"; TEIL III.5 "Der Widerruf": neue Aussage genauso
hart pruefen wie die alte).
WIE: Teil 3 des ENTWURF (Z.412-427) — 10 Zeilen E-1..E-10, je mit Verdikt+Beleg.
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:55-56 "Teil 3: ENTSCHIEDEN-Tabelle E-1..E-10
(A2.3a; Praezedenz OF-1 = E-1) mit Belegen, inkl. deklarierter Konflikte E-3 (L-A) und E-5
(L-C/V9)." Inhalt gepruft: E-1(OF-1 17-vs-18) · E-2(OF-2 32-Docks) · E-3(L-A OF-4-PAT-Kette,
KONFLIKT explizit ausgewiesen) · E-4(B3-SPEZ-VERMERK) · E-5(L-C/V9, mit frischer
21.08.-Objektprobe 0/0) · E-6(OV-2 checkpoint_measure) · E-7(#7-Methodik) · E-8(P4-Teilfrage
R4) · E-9(OV-4 Mess-Deckel) · E-10(X-8=P5-Dedup) — alle 10 vorhanden, je mit Quellenbeleg.

### F. FINAL-KONSOLIDIERT — DIE 12 BAULISTE-DELTAS D-01..D-12

**P-10 — Meta: Herkunft der Deltas + Dopplungs-Pruefung gegen G01-G22.**
WAS (FINAL-konsolidiert.md:1-17): "Lead-Konsolidierung ... aus ZWEI Straengen (A2.3a-Strang-
Dopplungs-Probe gefahren)" — Quelle 2 = `~/backups-workflow/20260821-w1-luecken/
BAULISTE.md Teil C` (G01-G22 owner-gated Vorlage-Zeilen, Abschnitt "## C. OWNER_GATED (22)").
DOPPLUNGS-PROTOKOLL (Z.12-15) ordnet 10 der 22 G-Nummern bereits bestehenden V-Bloecken zu
(G03=V-05, G04=V-04, G06=V-01, G07=V-02, G08=V-03, G09=V-06, G10=V-07, G12=E-9+V-10/O4,
G19=V-16, G21=Freeze-Check-Testat selbst).
WIE: `grep -n "^## C" ~/backups-workflow/20260821-w1-luecken/BAULISTE.md` (bestaetigt: Zeile
279 "## C. OWNER_GATED (22)"); Abzaehlung 10 Dopplungen + 12 Deltas = 22 = deckt G01-G22
VOLLZAEHLIG.
BEHAUPTET: NUR im Lead-Dokument (Commit 8aae5cd2), NICHT im Strang-Bericht (der Strang
kannte BAULISTE.md/G01-G22 nicht — das ist Beute eines ANDEREN Strangs, w1-luecken).

**P-11..P-22 — Die 12 einzelnen Deltas (je WAS + Quelle-G-Nr + Fundstelle).**
Alle 12 stehen wortlautgetreu in FINAL-konsolidiert.md Z.19-74; hier die Kurzform mit
G-Herkunft (BEHAUPTET je: NUR Lead-Dokument, s. P-10):

| # | Delta | G-Nr | Kern-Frage (gekuerzt zitiert) |
|---|---|---|---|
| P-11 | D-01 | G01 | HY-Ebene4a/4.-Ebenen-Entscheid, "war Mi 19.08. terminiert und ist UEBERFAELLIG" |
| P-12 | D-02 | G02 | type_phase_rank-Rename, "Rename NICHT preimage-/golden-wirksam ... GO erbeten" |
| P-13 | D-03 | G05 | B5-Zug-Freigabe + B3-CEB-Glied-Nachzug, "Freigabe des B5-Zuges ... erbeten" |
| P-14 | D-04 | G11 | Break-Even-Buendel OV-1+OV-6+D4f, "EIN Entscheid erbeten" |
| P-15 | D-05 | G13 | G-1-Restfragen 9/12 + S-18-DREIPHASIG-mess, "Ruecklauf erbeten" |
| P-16 | D-06 | G14 | ce-Standalone-SCHEMA-Bein haelftig, "Ja/Nein erbeten" |
| P-17 | D-07 | G15 | OF-1-Rest-Fork cp/ce-Klammerformen, "Entscheid erbeten" |
| P-18 | D-08 | G16 | V-06 Stempel-Pflicht-Weite (Lesart A vs 2 Symbole), "Lesart-Entscheid erbeten" |
| P-19 | D-09 | G17 | G-5 run_methodology-Enum-Ordnung, "Antwort erbeten" |
| P-20 | D-10 | G18 | OV-16+OV-17 (allow_failure-Entfernung + result.csv-Konvention), "Entscheide erbeten" |
| P-21 | D-12 | (s8/F-17, KEIN G-Nr) | R-1/OV-10 Steuerdock-Zahl SECHS vs "max. 4", "Bestaetigung ... erbeten" |
| P-22 | D-11 | G20+G22 | Sammel: ICpuCore/CoreClass-Platz + 6 Alt-Owner-Posten, "Platz-Entscheid erbeten" |

WIE (fuer alle 12): `grep -n "^### D-" docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-
konsolidiert.md` liefert 12 Treffer (D-01..D-10, D-12, D-11 — Reihenfolge im File NICHT
numerisch, s. SPANNUNGEN Punkt 2).

**P-23 — D-01..D-12 stimmen mit dem Staffel-Querbeleg ueberein.**
WAS: STAFFEL1-SYNTHESE.md:209 nennt Punkt 8 der konsolidierten Owner-Liste woertlich als
DEDUP-AUFTRAG: "R-1/OV-10 (s8): Dock-Zahl SECHS ... DEDUP-PRUEFUNG Lead: gegen die
Fenster-Bloecke halten; falls kein eigener V-Block, als Zusatzzeile nachtragen." STAFFEL2-
SYNTHESE.md:212 (F-122) nennt "Rest = ENGE Ratifikation Hermite vs. B-Spline-Basis = D-04 im
F2-Fenster" — beides trifft exakt auf D-12 bzw. D-04 zu.
WIE: Grep-Abgleich (bereits durchgefuehrt); beide Staffel-Funde sind korrekt in D-04/D-12
gelandet.
BEHAUPTET: konsistent, kein Widerspruch.

### G. B-4-ABSCHNITT DES FREEZE-CHECK-PROTOKOLLS (Lead-Dokument 2)

**P-24 — Freeze-Check-Protokoll referenziert B-4 korrekt und vollstaendig.**
WAS (docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md:76-81, woertlich): "## B-4 —
VORLAGEN-FENSTER / Vorgelegt als ZWEI Dokumente (EIN Fenster): F2-VORLAGEN-FENSTER-
ENTWURF.md (V-01..V-20 + Z-01..Z-03 + E-1..E-10) + 20260821-F2-VORLAGEN-FENSTER-FINAL-
konsolidiert.md (11 Deltas D-01..D-11 aus der W1L-BAULISTE; A2.3a-Dopplungs-Protokoll).
SOFORT-Zeilen: V-04 (C-3a), V-14 (root-Platte UEBERFAELLIG), V-18 (Infra-Termin), V-10/O4
(Kalibrierlauf vor Sa)."
WIE: Datei direkt gelesen (Z.76-81); Abgleich gegen Dokument 1+3.
BEHAUPTET: Lead-Dokument selbst (Commit 3e9ec644); ZAHL "11 Deltas D-01..D-11" ist zum
Commit-Zeitpunkt korrekt (D-12 kam ERST mit dem SPAETEREN Commit 8aae5cd2 hinzu) — s.
SPANNUNGEN Punkt 2 fuer die daraus resultierende Nachlauf-Inkonsistenz.

**P-25 — Gesamturteil des Freeze-Checks nennt B-4 als erfuellt.**
WAS (Z.94-101, woertlich): "F2-FREEZE-CHECK VOLLZOGEN (Lead, 21.08.2026): die Identitaet ist
eingefroren. ... Das Owner-TESTAT (G21) wird ueber das beiliegende Vorlagen-Fenster
erbeten — die SOFORT-Zeilen V-04/V-14/V-18/O4 sind die verbleibenden Owner-Handgriffe vor
dem WE."
WIE: Datei direkt gelesen.
BEHAUPTET: Lead-Dokument; Ledger-Nachtrag-Entwurf (Z.103-107) traegt dieselbe Zahl
"11 Deltas" — NICHT auf 12 nachgezogen (KON120 ist noch nicht geschrieben, s. P-03).

### H. SOFORT-ZEILEN (zeitkritische Owner-Handgriffe — Praesenz + korrekte Kennzeichnung)

**P-26 — 4 SOFORT-Zeilen sind ALS SOLCHE markiert und ueberall konsistent genannt.**
WAS: ENTWURF Teil 5 ENTWURF-A (Z.470-473) + FINAL-konsolidiert Z.76-83 + Freeze-Check Z.81 +
Freeze-Check Z.100-101 nennen DIESELBEN 4 Posten: V-04 (C-3a/d8b27633), V-14 (U-2
Platten-Raeumung, "UEBERFAELLIG"), V-18 (Infra-Fenster-Termin), V-10/O4 (GN-9-Kalibrierlauf
vor Sa-Lauf).
WIE: Cross-Grep `SOFORT` in allen 3 Dateien — 4x uebereinstimmend.
BEHAUPTET: JA, durchgaengig; zusaetzlich mit SELBST GEMESSENEN Frischdaten unterlegt (V-14:
"df / = 208G/251G belegt, 31G frei, 88%" — Objektprobe 21.08., aelter als das Fenster-Dokument
selbst NICHT moeglich, da Erstellungsdatum identisch; erfuellt GOAL-v8-Doktrin V11
"Belegzeile: die Messung muss aelter sein als der Satz" im Sinne von "so frisch wie am
Erstellungstag technisch erreichbar").

### I. DOKTRIN-KONFORMITAET (generische GOAL-v8-Massstaebe, nicht B-4-spezifisch, aber PFLICHT)

**P-27 — V1/V11 Selbstmessungs-Pflicht.**
WAS (GOAL v8 Z.276-280 V1 + Z.264-268 V11): "Jede Zahl ... aus einem Agentenbericht wird vor
Weitergabe selbst gemessen oder ausdruecklich als ungeprueft gekennzeichnet." / "Die Messung
muss aelter sein als der Satz."
WIE: Suche nach unbelegten Zahlenbehauptungen im ENTWURF — 0 gefunden; jede SOFORT-Zeile
traegt ein explizites "OBJEKT HEUTE (21.08., selbst gemessen)"-Zitat (z. B. V-14 Z.249-252,
V-16 Z.288 "OBJEKT NEU GEPRUEFT 21.08.").
BEHAUPTET: JA — vorlagen-fenster-ergebnis.md:90 "Alle Zahlen der SOFORT-Zeilen selbst
gemessen (df, ls-remote, ls -ld, grep)."

**P-28 — II.8 "Widersprueche nicht glattrechnen".**
WAS: GOAL v8 Z.312 "Widersprueche nicht glattrechnen. Beide Seiten zeigen, den Widerspruch
benennen."
WIE: Teil 4 (Gegenlese-Protokoll, Z.429-462) + E-3/E-5-Zeilen der ENTSCHIEDEN-Tabelle
listen KONFLIKT-Faelle explizit aus (z. B. E-3: "KONFLIKT DEKLARIERT: K14-Uebergabe Abschn.
9 ... fuehrte L-A als 'echt liegengeblieben' — die juengste belegte Fassung ... gilt").
BEHAUPTET: JA, mehrfach durchgehalten (auch V-01, V-17, V-19 markieren aeltere-vs-juengere
Fassung explizit statt glattzuziehen).

**P-29 — DESIGNPLAN-TDD-Vertrag (T-1..T-9, T-11a-c, T-12a-e) — Anwendbarkeitspruefung.**
WAS: Auftrags-Vorgabe dieser Erhebung ("welche T-Pflichten treffen diese Aufgabe").
WIE: Der TDD-Vertrag (Designplan §3, Z.63-75 + §11/§12 Nachtraege) bindet AUSSCHLIESSLICH
Testcode (rot-zuerst, Wegwerf-Mutation, Codex-Testkritik). Der Strang produziert 0 Zeilen
Testcode, 0 Commits, 0 Build.
BEHAUPTET: ENTFAELLT — vom Strang selbst korrekt als nicht-einschlaegig behandelt (kein
T-Bezug im Bericht, konsistent mit "Kein Bau-Zweig"). Siehe NICHT-GEFORDERT.

---

## ABNAHME-FORMELN (woertliche Zitate der Quellen)

1. **W2-ABFOLGE-DESIGN.md:159** — "ABNAHME: Fenster-Dokument mit allen Zeilen liegt der
   Landung bei."
2. **Wellenplan v2, §21.6, Z.3145-3146** — "F2-Owner-Vorlagen-Fenster (Ein-Satz-Vorlagen, aus
   Task-#15-Metadata owner_vorlagen_fenster, nach der Landung; Verweis par.21.1 Schritt 5/6).
   FRIST: mit der Landung, vor F2 (Fr 21.08.)."
3. **Wellenplan v2, §22.3, Z.3377-3378** — "F2-Vorlagenfenster P1-P7 (Ein-Satz-Vorlagen MIT
   der Landung, vor Fr 21.08.; par.21.6 + Board-Owner-Zeile; F-F/13.2: P2/P3 AM ORIGINAL
   bauen):"
4. **Ledger KON119-07, Z.226-227** — "Naechste Schritte: super-Push + super-CI/PZW-Job
   gruen -> Freeze-Check Fr 21.08. (R5) -> F2-Vorlagen-Fenster (R6) -> WE-/Di-25-Posten (R7)."
   (definiert die Fenster-Reihenfolge R5->R6->R7, an der sich das Dokument selbst
   orientiert, ENTWURF Z.13-16).
5. **F2-VORLAGEN-FENSTER-ENTWURF.md:13-16** (Selbstbindung des Strangs an die Frist) —
   "FENSTER-LAGE: KON119-07 setzt die Folge R5 Freeze-Check Fr 21.08. -> R6 F2-Vorlagen-
   Fenster -> R7 WE-/Di-25-Posten. Frist des Fensters laut par.22.3: 'MIT der Landung, vor
   Fr 21.08.' — HEUTE IST Fr 21.08.: das Fenster ist JETZT faellig ... ABNAHME (B-4): dieses
   Dokument liegt der Landung bei."
6. **F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md:85-88** (Selbst-Abnahme des Lead-Dokuments) —
   "## ABNAHME / B-4 erfuellt: das Fenster (ENTWURF V-01..V-20 + Z-01..Z-03 + DIESE 11
   Deltas) liegt der Landung bei; ENTSCHIEDEN-Tabelle E-1..E-10 verhindert
   Bereits-Entschiedenes (A2.3a). Freeze-Check-Protokoll: docs/sessions/
   20260821-F2-FREEZE-CHECK-PROTOKOLL.md (Schwester-Dokument)."
7. **F2-FREEZE-CHECK-PROTOKOLL.md:92-97** (Gesamturteil, deckt B-4 mit ab) — "## GESAMTURTEIL
   / F2-FREEZE-CHECK VOLLZOGEN (Lead, 21.08.2026): die Identitaet ist eingefroren. ... die
   §23.1-F2-Liste ist 8/8 getragen ... Ab jetzt gilt: jede preimage-/golden-wirksame
   Aenderung ist ein DEKLARIERTES Ereignis (NULL-Bump-Doktrin; naechster teurer Punkt =
   Bau-Trigger Mi 26.08. 06:00)."
8. **vorlagen-fenster-ergebnis.md:92-98** (Strang-Selbstabnahme) — "### STATUS: LANDEREIF /
   Das Fenster-Dokument liegt vollstaendig vor (B-4-ABNAHME: 'Fenster-Dokument mit allen
   Zeilen liegt der Landung bei' — alle 15 Auftrags-Bloecke + 3 B-4-Zusaetze + X-8-Dedup
   abgedeckt)."

---

## NICHT-GEFORDERT (deklarierte Nachfolge-Zuege / bewusst ausserhalb dieser Aufgabe)

- **Die Owner-ANTWORTEN selbst.** Das Fenster stellt Fragen (R6); die Beantwortung ist der
  naechste Schritt (R7, "WE-/Di-25-Posten") und liegt beim OWNER bzw. beim LEAD, der das
  Fenster "dem Owner vorlegt" (ENTWURF Z.480-481: "Naechster Halt: Lead legt das Fenster
  dem Owner vor (R6)"). Ein Audit-Fund "Owner hat noch nicht geantwortet" ist KEIN Defekt
  dieses Strangs — es ist der erwartete Zustand am Ende von R6.
- **Der Vollzug der "SCHALTET FREI"-Folgeposten.** Jeder V-Block nennt explizit, was er
  freischaltet (z. B. V-04 schaltet S-17/B5-Traeger, V-02R-Bau, #105c frei) — das BAUEN
  dieser Folgeposten ist NICHT Teil von B-4/vorlagenfenster, sondern eigene W2-Traeger
  (#24, T-7/Z-5, T-8/Z-6 usw.), die an ANDEREN Straengen haengen.
- **Root-seitige Platten-Raeumung selbst (V-14).** Die Vorlage MELDET den ueberfaelligen
  Zustand; das AUSFUEHREN (rm als root) ist Owner-/Infra-Handgriff, kein Doku-Strang-Akt.
- **node6-Geraete-Handgriff, V8-PAT-Rotation, E12-Rewrite (V-15/V-16/V-17).** Reine
  Kenntnisnahme-/Meldungs-Vorlagen; die HANDLUNG liegt beim Owner/Infra (explizit
  "QUITTUNG/HANDGRIFF"-Kennzeichnung im ENTWURF, Zeichen-Legende Z.18-21).
- **AxisKind-Drehung selbst (V-01) und der R-1-Nachzug der 3 Dauerroten (V-11).** Beide
  werden explizit auf EIGENE kuenftige golden-Ereignis-Zuege verwiesen (Lead-Entscheid E-11
  aus LEAD-ENTSCHEIDE.md Z.24-27: "axes/-Aenderungen sind seit der #15-Landung
  KONTROLLIERTE GOLDEN-EREIGNISSE ... nie nebenbei in einer Parallel-Staffel") — NICHT Teil
  dieser Lieferung, nur die ENTSCHEIDUNGS-VORLAGE dazu.
- **DESIGNPLAN-TDD-Vertrag T-1..T-9 / T-11a-c / T-12a-e.** Bindet ausschliesslich Testcode
  (rot-zuerst, Wegwerf-Mutation, Codex-Kritik je Welle). Dieser Strang liefert 0 Testcode,
  0 Build, 0 Commits — der Vertrag ist strukturell nicht einschlaegig. Ein Audit-Fund
  "keine T-1-Wegwerf-Mutation nachgewiesen" waere ein PHANTOM-FUND.
- **GOAL-v8-CI-Doktrinen (allow_failure-Verbot auf Job-Ebene, Hart-Gruen-Pipeline-Pflicht,
  xlsx-Ausgabe-Doktrin).** Alle drei setzen eine CI-Pipeline bzw. eine Mess-/Export-Kette
  voraus, die dieser Strang nicht beruehrt (er erzeugt keine CI-Jobs, keine xlsx/csv). Sie
  gelten thematisch INNERHALB der besprochenen Owner-Fragen (z. B. D-10/OV-16 fragt nach
  genau dieser Doktrin), aber nicht als Pruefkriterium DES DOKUMENTS selbst.
- **B-1, B-2, B-3, B-5 des Freeze-Check-Protokolls.** Diese vier [B]-Fixpunkt-Bloecke
  (§18.3-Original-Pruefung 18 (P)-Posten, §23.1-F2-Liste, §23.2-Deklarations-Tafel,
  W1-Nachlande-Pointer) stehen in DERSELBEN Datei wie B-4, sind aber EIGENE
  Wellenplan-Posten mit eigenen Traegern (u. a. s8kopf/traegerbau-s8, W1-Luecken-Strang) —
  NICHT Gegenstand dieser vorlagenfenster-Soll-Karte. Ein Audit-Fund zu B-1/B-2/B-3/B-5
  gehoert in die Soll-Karte des jeweils zustaendigen Strangs, nicht hierhin.
- **OG-20..OG-58 (F-III/F-IV/F-IV-Fortsetzung, [F]-Gruppen jenseits F-I/F-II).** Explizit
  ANDERE Faelligkeit ("spaeter faellig/W3+", teils "vor Kampagne Sa 29.", teils "nach
  Abgabe/W7") — NICHT Teil des Fr-21.08-Fensters. Insbesondere OG-45..OG-58
  (Hybrid-Restfragen D3, PMC-Schwester-Design-Vorlage OG-45, W5/T-3-Reset-GO OG-46,
  #53-Achsen-Vorlagen OG-49, VS-A-F OG-58) sind bewusst NICHT im Fenster — ein Audit-Fund
  "OG-49 fehlt im Fenster" waere ein PHANTOM-FUND.
- **F-V-Pruefblock-Posten ausser den 2 tatsaechlich uebernommenen (v32/OD-7).** Der
  Pruefblock (Z.667-679) nennt 6 moeglich-owner-gated Verdachtszeilen; das ENTWURF
  behandelt DAVON nur 2 als eigene Bloecke (V-19 v32-Vokabular, V-20 OD-7) — die
  uebrigen 4 (K-07/#91, L-B/L-D-Traeger-Volltext [ohnehin ueber V-15/V-17 abgedeckt],
  #91-Identitaets-n*, E-14 MessTooling) sind NICHT als eigene V-Bloecke gefordert, da sie
  entweder bereits anderweitig abgedeckt (L-B/L-D) oder ausdruecklich "kein woertliches
  Owner"/"nur falls Lead will" sind. Kein Gap.

---

## SPANNUNGEN (Widersprueche zwischen Quellen — nicht glattgezogen)

**S-1 — Delta-Zaehler-Inkonsistenz in FINAL-konsolidiert.md (juengere Schicht gewinnt in der
Substanz, aeltere Zaehl-Formulierung blieb unkorrigiert stehen).**
Die Datei traegt an ZWEI Stellen die Aussage "11 Deltas D-01..D-11" (Z.17: "hiermit ins
Fenster gehoben — D-01..D-11"; Z.86: "DIESE 11 Deltas"). Am OBJEKT enthaelt die Datei aber
**12** distinkt nummerierte Delta-Bloecke (`### D-01` bis `### D-10`, dann `### D-12`,
dann — NACH D-12, ausser der Reihe — `### D-11`; Zeilen 19/24/29/35/40/44/47/51/55/59/65/70).
Git-Beleg: Commit **8aae5cd2** ("docs(f2): D-12 R-1/OV-10-Steuerdock-Zahl-Vorlage
nachgetragen ... — Fenster damit 12 Deltas") wurde NACH dem Erstcommit **3e9ec644**
("... 11 BAULISTE-Deltas D-01..D-11 ...") aufgesetzt und fuegte D-12 hinzu — die
Commit-Nachricht von 8aae5cd2 nennt selbst korrekt "12 Deltas", aber die ZWEI laufenden
Text-Referenzen IN der Datei (Z.17, Z.86) wurden beim Nachtrag NICHT auf "12"/"D-01..D-12"
nachgezogen. Der Auftrags-Steckbrief dieser Erhebung ("12 Deltas D-01..D-12") ist damit
FAKTISCH KORREKT (deckt sich mit dem Objekt-Inhalt), waehrend die Datei SICH SELBST
widerspricht (Inhalt=12, Selbstbeschreibung=11 an 2 Stellen). Das Audit sollte dies als
"Dokument zaehlt sich selbst falsch, Inhalt vollstaendig" werten — kein Inhalts-Fehlen,
sondern ein stehengebliebener Nachlauf-Fehler in der Kopf-/Fusszeile.

**S-2 — Reihenfolge-Anomalie D-12 vor D-11.**
Direkt anschliessend an S-1: der `### D-12`-Block (Z.65-68) steht VOR dem `### D-11`-Block
(Z.70-74) im Fliesstext — numerisch nicht aufsteigend. Erklaerung am Objekt: D-11 stammt aus
der urspruenglichen G01-G22-Dopplungspruefung (G20+G22, Commit 3e9ec644), D-12 wurde ERST
SPAETER (Commit 8aae5cd2, anderer Quellstrang: s8/F-17, KEIN G-Nr) ans Ende anschliessend
eingefuegt — aber vor D-11 platziert statt nach D-11. Kosmetischer Befund, keine
Inhalts-Luecke (beide Bloecke sind vollstaendig vorhanden).

**S-3 — Datei-Praefix-Abweichung Auftrags-Steckbrief vs. Objekt.**
Der Auftrags-Steckbrief nennt die Dateien als `F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md`
und `F2-FREEZE-CHECK-PROTOKOLL.md` (ohne Datumspraefix). Am Objekt tragen BEIDE Dateien das
Praefix `20260821-` (`docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md` /
`docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md`) — deckungsgleich mit der im
super-Repo ueblichen Datumspraefix-Konvention fuer `docs/sessions/*`. Kein Inhalts-Problem,
nur eine unvollstaendige Pfadangabe im Steckbrief; per Volltextsuche eindeutig aufgeloest.

**S-4 — Autorenschicht: Strang-Bericht kennt Dokument 2+3 nicht (zeitliche Reihenfolge,
kein Fehler, aber pruefungsrelevant).**
`vorlagen-fenster-ergebnis.md` (mtime 09:12) erwaehnt AUSSCHLIESSLICH das ENTWURF-Dokument
und erklaert sich fuer LANDEREIF allein auf dessen Basis. Die Freeze-Check-Protokoll.md
(mtime 09:22, Commit 3e9ec644) und die FINAL-konsolidiert.md (mtime 09:26, Commit 8aae5cd2)
entstanden 10-14 Minuten SPAETER durch den LEAD ("Lead-Vollzug"/"Lead-Konsolidierung",
Selbstbezeichnung in beiden Dateien) — nicht durch den vorlagenfenster-Sub-Agenten. Wenn das
Audit "hat der Strang X geliefert" prueft, ist bei den D-01..D-12-Deltas und beim
Freeze-Check-Text korrekt zu vermerken: **Lead-Lieferung, nicht Strang-Lieferung** — das
mindert NICHT die Vollstaendigkeit des B-4-Gesamtbildes (beide Ebenen zusammen erfuellen die
Abnahme, s. ABNAHME-FORMELN Punkt 6), es ist aber eine andere Zurechnung als "der Strang
vorlagenfenster hat 12 Deltas geliefert".

**S-5 — A-20-Praezisions-Luecke in der AUFTRAGS-QUELLE selbst (nicht im Liefer-Dokument).**
W2-ABFOLGE-DESIGN.md:119-121 (Posten A-20, [A]-Do-Slot, ZULIEFERUNG an B-4) lautet woertlich:
"A-20 F-F P2/P3-Vorlagen AM ORIGINAL par.21.6 bauen (Zulieferung ans [B]-Vorlagen-Fenster;
Inhalt owner-gated -> [OG-3]/[OG-5])." Nach der F-II-Zaehlung (P-06 oben) ist aber OG-3=P1
und OG-5=P3 — nicht P2/P3, wie der A-20-Fliesstext behauptet (P2=OG-4). Diese Ungenauigkeit
sitzt in der AUFTRAGSQUELLE (W2-ABFOLGE-DESIGN.md), nicht im vorlagenfenster-Liefer-Dokument;
sie hat am Objekt KEINE Auswirkung, weil das ENTWURF ohnehin P1+P2+P3 vollstaendig als V-01/
V-02/V-03 fuehrt. Nur zur Kenntnis, falls das Audit die A-20-Quelle unabhaengig prueft.

**S-6 — GOAL-v8 "V-1..V-14"-Referenz im Erhebungs-Auftrag deckt sich nicht woertlich mit der
Quelle.**
Der Erhebungs-Auftrag nennt unter GOAL v8 "Doktrinen: allow_failure JOB-Ebene verboten,
xlsx-Doktrin, Hart-Gruen, V-1..V-14" als eine zusammenhaengende, durchnummerierte Liste. Am
Objekt existiert KEINE zusammenhaengende "V-1 bis V-14"-Liste in GOAL v8 — die Datei nutzt
einzelne benannte Doktrinen (V1 "Berichte sind Beweismaterial", V4 "Verdaechtige das eigene
Messverfahren", V11 "Die Belegzeile", TEIL II.7-II.8, TEIL III "Die fuenf Pruffragen" ohne
V-Praefix) sowie separat V-1…V-7/V-16 in ZWEI Fussnoten-Kontexten (Zeilen 141/740/764), die
NICHT dieselbe Zaehlung sind wie die einschlaegigen General-Doktrinen. Es fehlt KEIN Inhalt
dadurch (alle inhaltlich gemeinten Doktrinen — Nenner, Fail-closed, Selbstmessung,
allow_failure-Verbot Z.763, xlsx-Doktrin Z.526-578 — sind vorhanden und wurden gegen den
vorlagenfenster-Bestand gepruft, s. P-27..P-29), nur die Etikettierung "V-1..V-14" im
Auftrag selbst ist keine woertliche GOAL-v8-Struktur.

---

## ANHANG — Objekt-Fundstellen (fuer Nachpruefungen des Audits)

- Strang-Bericht: `~/backups-workflow/20260820-w2-sofortstaffel/vorlagen-fenster-ergebnis.md`
  (98 Z., voll gelesen)
- Liefer-Dok 1: `~/backups-workflow/20260820-w2-sofortstaffel/F2-VORLAGEN-FENSTER-ENTWURF.md`
  (481 Z., voll gelesen)
- Liefer-Dok 2: `docs/sessions/20260821-F2-FREEZE-CHECK-PROTOKOLL.md` (107 Z., voll gelesen,
  super-Commit 3e9ec644)
- Liefer-Dok 3: `docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md` (88 Z.,
  voll gelesen, super-Commit 8aae5cd2)
- Quelle BAULISTE: `~/backups-workflow/20260821-w1-luecken/BAULISTE.md` Abschnitt
  "## C. OWNER_GATED (22)" (Z.279)
- AUFTRAG: `~/backups-workflow/20260820-welle2-audit/W2-ABFOLGE-DESIGN.md` B-4 (Z.152-159) +
  [F] (Z.516-708) + SLOT [B] (Z.803-804)
- LEAD-ENTSCHEIDE: `~/backups-workflow/20260820-welle2-audit/LEAD-ENTSCHEIDE-zum-w2-design.md`
  (87 Z., voll gelesen; Punkt 9 verankert OG-1/P4 explizit "liegt im Vorlagen-Fenster-Strang")
- Wellenplan v2: `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md`
  §21.6 (Z.3111-3157), §22.1 U-2/U-3 (Z.3209-3224), §22.2 T-9 (Z.3294-3299), §22.3
  (Z.3375-3407), §20.7 (Z.2763-2769)
- Designplan-tdd: `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md`
  §3 T-1..T-9 (Z.63-75) — gepruft, NICHT einschlaegig (s. NICHT-GEFORDERT)
- GOAL v8: `docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md`
  TEIL II (Z.264-320), TEIL III (Z.322-351), TEIL IX allow_failure (Z.728-787), xlsx
  (Z.517-578), TEIL X (Z.792-806)
- Ledger: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` KON119 (Z.19-231, voll gelesen)
- Findings-Bestand: `~/backups-workflow/20260820-w2-sofortstaffel/STAFFEL1-SYNTHESE.md`
  (Zeile 23 Statustafel, Z.176-182 F-71..F-77, Z.192-219 konsolidierte Owner-Punkte) +
  `STAFFEL2-SYNTHESE.md` (Z.212 F-122/D-04-Bezug, Z.260 Fortbestand)
