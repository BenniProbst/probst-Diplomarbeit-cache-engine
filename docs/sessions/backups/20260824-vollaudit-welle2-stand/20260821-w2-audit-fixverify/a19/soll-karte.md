# A-19 SOLL-KARTE -- Volltext-Luecke (20-W2-Deklariert-Gegenzaehlung + L-B/L-D-Traeger + OV-1/OG-52)

Erstellt: 23.08.2026, ~20:12 UTC, Sonnet-max-Planungs-Erheber (read-only, KEIN Fix).

## PROVENIENZ DIESER FASSUNG (wichtig fuer das Audit -- bitte zuerst lesen)

Dies ist die ZWEITE Soll-Karten-Fassung des heutigen Tages (die erste: 14:08:45 UTC, 534 Z.,
im selben Ordner nun gesichert als `soll-karte.VORHER-20260823-1408.md`). Diese Fassung ist
KEINE Kopie: alle acht SOLL-QUELLEN wurden in DIESER Sitzung frisch gelesen/gegrept, die
14:08-Fassung diente nur als Vollstaendigkeits-Kontrolle (BESTANDS-PFLICHT) -- jeder ihrer
Kernbefunde wurde unabhaengig an der Primaerquelle nachgemessen, nicht per Vertrauen
uebernommen. **Ergebnis der Nachmessung: NULL Drift in allen acht SOLL-Quellen seit 14:08.**
Belege (alle in dieser Sitzung selbst erhoben):
- LEDGER: 32387 Zeilen (identisch); KON121-D-04-Zitat an Z.60-63 (identisch); KON120-02-
  TRANCHE-2-D-04-Zitat an Z.137-140 (identisch, woertlich nachgelesen, s. Formel #10 unten);
  KON120-05 an Z.159-166 (identisch, 6-Posten-Restliste bestaetigt).
- W2-ABFOLGE-DESIGN.md, LEAD-ENTSCHEIDE, WELLENPLAN, DESIGNPLAN, GOALV8: mtimes unveraendert
  gegenueber der 14:08-Messung; alle dort zitierten Zeilen in dieser Sitzung selbst erneut
  gelesen (DESIGN Z.114-118/373/593-598/650-651/672-673/705/884-889; WELLENPLAN Z.1054/2769/
  3395-3401/3497-3505; GOALV8 Z.76).
- ce-HEAD: **3841d717** (unveraendert gegenueber dem Fix-Runde-3-Stand, `git log -1` in DIESER
  Sitzung); `grep -rni "de.boor|knot_vector|bspline|b-spline" libs/` = 0 (unveraendert);
  `grep -rn "to_string|from_string|serialize" axis_spline.hpp break_even.hpp` = 0 (unveraendert).

**Was SICH veraendert hat, ist das AUDIT-OBJEKT selbst:** `a19-volltexte-ergebnis.md` durchlief
zwischen 14:08 und 14:10 UTC heute die A2.5-Fix-Runde 3 (390 -> **505 Zeilen, md5
8118bd19f953b65fdda5d9e8765ad15b**, mtime 14:10:17 -- in dieser Sitzung selbst nachgemessen und
mit `audit-runde-3.md`s eigenem Beleg identisch), die genau den einzigen substantiellen Fund der
14:08-Karte (dortiges "S-7", D-04/OV-1-Aktualitaets-Luecke) vollstaendig absorbierte
(A19-F5/A19-F6). `audit-runde-3.md` (gleiches Zeitfenster, selbst gelesen) quittiert danach
VERDIKT **"SITZT (nach Fix)"**: ueber alle drei Runden 6 Funde (A19-F1..F6), 6 behoben, 0 offen,
0 vertagt, 0 Regressionen. Diese Erhebung bestaetigt jenen Endstand unveraendert und traegt
zwei EIGENE, in der laufenden Sitzung neu erhobene Punkte nach (S-8, S-9 unten) -- beide sind
KEINE a19-Funde (a19s eigener Auftrag bleibt LANDEREIF), sondern Hinweise zum aktuellen
BETRIEBS-Zustand rund um den Strang.

Aufgaben-Steckbrief: A-19, Staffel 2, Doku-/Read-only-Strang, kein Bau-Zweig. Quellen-Rangfolge
lt. Auftrag: Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 > Designplan >
W2-ABFOLGE-DESIGN > Strang-Bericht.

Abkuerzungen: DESIGN = `.../20260820-welle2-audit/W2-ABFOLGE-DESIGN.md` * LEAD =
`.../20260820-welle2-audit/LEAD-ENTSCHEIDE-zum-w2-design.md` * WELLENPLAN =
`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` (super-Repo) * DESIGNPLAN =
`docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md` * GOALV8 =
`docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` * LEDGER =
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` * F2FENSTER =
`docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md` * S1SYN/S2SYN =
STAFFEL1-SYNTHESE.md / STAFFEL2-SYNTHESE.md (Ordner `20260820-w2-sofortstaffel/`) * BERICHT =
a19-volltexte-ergebnis.md (das gepruefte Objekt, aktuell 505 Z.) * D04EXPL =
`~/backups-workflow/20260822-explore-buendel-t2/d04-mathe-sprache.md`.

--------------------------------------------------------------------------------
## PRUEFLISTE

**P-01 -- Volltext "20 W2-DEKLARIERT" (9.3) auffinden+lesen.**
WAS (woertlich, DESIGN:114-116, selbst nachgelesen): "die vollen '20 W2-DEKLARIERT' leben nur
in ~/backups-workflow/20260819-w93-endstand/w93-synthese-endstand-ww7zqfc2a.json (K3-BEFUND K1:
Kurztext liefert nur ~15; 3. Praezisierung unauffindbar)."
WIE pruefbar: Datei-Existenz+Groesse (28157 B); Feldpruefung `result.synthese.
offen_w2_deklariert` (17 Eintraege), `result.verdikt_zaehler.offen_w2` (=20), `posten_gesamt`
(=91); Rohdaten-Gegenprobe `w93-journal-ENDSTAND.jsonl` (23 Records).
BEHAUPTET: JA -- BERICHT Abschn. 1.1-1.2. Ueber drei Audit-Runden unveraendert bestaetigt.

**P-02 -- Delta-Posten (Kurztext vs. Volltext) fuer #96 auflisten.**
WAS (ABNAHME-Satz von A-19 selbst, DESIGN:118): "ABNAHME: Delta-Posten (falls vorhanden) in
#96-Schnitt nachgetragen." Ergaenzend DESIGN:373 (D-9/#96-Register): "A-19-Delta
(9.3-Volltext) nachtragen."
WIE pruefbar: Liste mit 5 benannten Posten je mit Zitat+grep-Nullbeleg + Reihenfolge-Hinweis
(PM-m3v2Spalten VOR PM-Naht); GEGENPROBE gegen den echten Designplan-Katalog (s. P-19).
BEHAUPTET: JA -- BERICHT Abschn. 1.3: D-1 PK-KlemmJson, D-2 HY-Ebene4a (owner-gated), D-3
LG-HostBinder, D-4 LG-E2Exlsx, D-5 XL-L4, je mit grep-Zitat; plus PM-Naht-Reihenfolge-Auflage.
Traeger-Termin (Di 25.08., #96) liegt noch in der Zukunft -- kein a19-Fund.

**P-03 -- "3 Praezisierungen" identifizieren (im Kurztext-Kopf nur gezaehlt, nicht benannt).**
WAS: Kurztext-Kopf "9.3 W2-DEKLARIERT (20, je Quelle; 3 PRAEZISIERUNGEN)".
WIE pruefbar: 3 benannte Eintraege mit Zitat, die eine Vorquelle KORRIGIEREN (nicht nur
ergaenzen).
BEHAUPTET: JA -- BERICHT Abschn. 1.4: P-1 A15/#71 (W2 -> W4/W5-Randslot), P-2 PM-Naht
(Falsch-Null korrigiert), P-3 B1 (ueberschreibt OFFEN_VOR_F2), plus 3 Mitfuehr-Kandidaten
explizit abgegrenzt.

**P-04 -- Vollstaendige Gegenzaehlung "0 stille Verluste" liefern.**
WAS: DESIGN traegt diese Doktrin fuer sich selbst vor (Z.896 Selbstcheck: "Gegenzaehlung 441
Roh-Zeilen -> 0 stille Verluste") -- impliziter Massstab fuer jeden Zaehl-Auftrag im selben Plan.
WIE pruefbar: 17er-Kurzliste (W2-01..W2-17) je mit Rohverdikt-Herkunft + 8-Gruppen-Summe = 91.
BEHAUPTET: JA -- BERICHT Abschn. 1.5: W2-01..W2-17 + Gruppensumme 16+9+4+5+7+23+14+13=91.
HINWEIS (kein Fund): W2-17=#38a2 -- der spaetere Ledger-Fund "#38a2 NIE gebaut" (KON121 Punkt 2,
Z.54-55, selbst gelesen) betrifft den BAU-Status des Postens, nicht a19s Zaehl-/Mapping-
Leistung; a19 behauptet an keiner Stelle, #38a2 sei gebaut.

**P-05 -- "Uebergabe Abschnitt 9"-Volltext fuer L-B/L-D auffinden+lesen.**
WAS (DESIGN:116-118 + F-V-Pruefblock DESIGN:672-673, beide selbst nachgelesen): "Ebenso
'Uebergabe Abschnitt 9'-Volltext fuer L-B/L-D-Traeger (K3-BEFUND K2)." / "L-B-/L-D-Traeger: nur
per 'Uebergabe Abschnitt 9'-Volltext klaerbar (A-19)."
WIE pruefbar: Fundort-Zitat mit Commit-Hash+Datei+Zeilenbereich; Abgrenzung gegen
Verwechslungs-Kandidaten (K13-Uebergabe hat KEIN Abschnitt 9 mit L-Posten).
BEHAUPTET: JA -- BERICHT Abschn. 2.1: Fundort = `super docs/sessions/20260819-SESSION-
UEBERGABE-kontext14-ende-audit-geerntet-sweep-konsolidiert.md` Z.321-349, Commit fa66a32e.

**P-06 -- Traeger-Frage "WER TRAEGT L-B" (V8 GitHub-PAT-Rotation) beantworten.**
WAS (DESIGN:593-594, selbst nachgelesen): "OG-26 L-B V8 GitHub-PAT-Rotation (Traeger unklar --
Volltext 'Uebergabe Abschnitt 9' einlesen, A-19)."
WIE pruefbar: FAZIT-Zeile mit benanntem Traeger + Belegkette (KON76-03 -> KON80-01 ->
Handout-Commits -> KON89 -> KON93-03 -> KON105-02) + Objekt-Gegenprobe `~/.git-credentials`.
BEHAUPTET: JA -- BERICHT Abschn. 2.3: FAZIT "Traeger = #84-Umfeld + Owner-Punkte-Liste"; NACHTRAG
dokumentiert V8-prod1-VOLLZUG per KON120-05 (bereits IM Objekt integriert, nicht erst als
Audit-Fund -- s. Beweiskette Fix-Runde 1). Ledger-Gegenprobe dieser Sitzung: KON120-05 Z.159-166
identisch mit dem im BERICHT zitierten Wortlaut, 6-Posten-Restliste vollstaendig.

**P-07 -- Traeger-Frage "WER TRAEGT L-D" (node6/id56/id18) beantworten.**
WAS (DESIGN:597-598, selbst nachgelesen): "OG-28 L-D node6/id56/id18 (Traeger unklar -- Volltext,
A-19)."
WIE pruefbar: analog P-06, plus Objekt-Widerspruchs-Aufloesung (KON80-01-Autonomie vs.
juengerer Cluster-K151-Befund).
BEHAUPTET: JA -- BERICHT Abschn. 2.3: FAZIT "Traeger = Owner-Punkte-Liste + Cluster-Repo W-1
P-RUNNER [CTO]"; node6 = Geraete-Handgriff (K151, sshd stirbt vor Banner), nicht blosse
Kenntnisnahme.

**P-08 -- F-V-Pruefblock-Zeile "L-B-/L-D-Traeger ... (A-19)" schliessen.**
WAS: s. P-05 (DESIGN:672-673).
BEHAUPTET: JA -- BERICHT Abschn. 2.4: "'Traeger unklar' ist damit AUFGELOEST ... F-V-Zeile ...
kann als ERLEDIGT geschlossen werden."

**P-09 -- TEIL-5-Nr.10-Luecke ("A-19-LUECKE") schliessen.**
WAS (DESIGN:884-889, selbst nachgelesen): "A-19-LUECKE: die vollen '20 W2-DEKLARIERT' (9.3) und
die L-B/L-D-Traeger liegen NUR in externen Volltexten (B.3-JSON, Uebergabe Abschn. 9) --
Einlesen ist als [A]-Posten verankert ... Zusatz: ... OV-1 (HY-C) in keinem der vier
Design-Dokumente auffindbar -> OG-52-Rechercheposten."
BEHAUPTET: JA -- BERICHT Kopfzeile (Quellenangabe DESIGN Z.114-118/593-598/650-651/672-673/
884-889) + alle drei Auftragsteile bearbeitet.

**P-10 -- Auftragsteil 3 (OV-1/OG-52): Identitaetsfrage klaeren ("ist die HY-C-'OV-1' dieselbe
wie die Wellenplan-par.8-Break-Even-Frage?").**
WAS (DESIGN:650-651, selbst nachgelesen): "OG-52 OV-1 (HY-C-Vorbedingung) -- in D1/D2/D4 NICHT
auffindbar; Recherche-posten + Vorlage. QUELLE K4:TEIL3/3a HY-C."
WIE pruefbar: Beleg-Kette ueber >=2 unabhaengige Dokumente + Gegenstands-Verifikation am
Roh-Transkript (OV-Nummern sind laut Memory-Dauerregel KEIN Autoritaetsbeleg fuer sich).
BEHAUPTET: JA -- BERICHT Abschn. 3.1: Herkunft aus HYBRID-bauplan Z.172/139/252 +
WELLENPLAN-Zeilen 1054/705/708/728/765/869/1002 (in dieser Sitzung an Z.1054/705/708/869/1002
selbst gegengelesen -- alle Fundstellen bestaetigt, u.a. Z.705 "##16+##17 (nach OV-1)", Z.708
"Blockiert durch ... OV-1/OV-6 fuer ##16/##17/D4f", Z.869 "Break-Even-Kanon + Serialisierung
gemaess OV-1", Z.1002 "Break-Even-Neubau B=3 | gemaess OV-1"). Identitaet haelt.

**P-11 -- OV-1-Beantwortungsstatus klaeren (beantwortet? wann? von wem? erreichte das Etikett
den Owner?) UND den AKTUELLEN Stand (Owner-Antwort 21.08. 20:40) einordnen.**
WAS: keine explizite Design-ABNAHME-Formel; ergibt sich aus dem Recherche-Charakter von OG-52.
WIE pruefbar: Primaerquelle mit Zeitstempel + Ledger-Gegenprobe + Owner-Nachrichten-Gegenprobe.
BEHAUPTET: JA -- BERICHT Abschn. 3.2: (a) Sachfrage-Ebene: Owner-Zitat "Wir brauchen nur eine
konsolidierte Implementierung" (08.08. 09:44, wf_17efd95b-ce5) = Antwort auf die zugrunde
liegende Sachfrage; das Etikett "OV-1" entstand laut `git log --diff-filter=A` rund 7h SPAETER
(WELLENPLAN-Commit 16:37:41 UTC) und erreichte den Owner laut 2998-Nachrichten-Gegenprobe NIE
woertlich. (b) AKTUELLER STAND, vom BERICHT selbst durch drei Fix-Runden nachgezogen (Abschn.
3.2(e)+3.4-NACHTRAG, in dieser Sitzung Wort fuer Wort gegengelesen): die 21.08.-Formulierung
"Hermite ratifizieren vs. B-Spline-Neubau" (F2FENSTER Formel, s. ABNAHME-FORMEL #8) ist per
Owner-Nachricht vom **21.08.2026 20:40:56 UTC** (verbucht KON120-02 TRANCHE 2, Ledger Z.137-140,
in dieser Sitzung selbst nachgelesen, s. ABNAHME-FORMEL #10) UEBERHOLT -- der Owner erteilt
"Volles GO fuer ALLE diese Felder als mathematisches Definitions-Bereich Command pattern"
(mindestens 9 Kurvenfamilien, zweistufiger Entropie-/Fehlerraten-Filter, eigene
Matlab-aehnliche Definitions-Sprache, 12-Wochen-Explore-Pflicht). KON121 (Z.60-63, selbst
gelesen) praezisiert zusaetzlich: "der 21.08.-Hermite-Ratifikationsvorschlag ist durch D-04
UEBERHOLT (nicht vollzogen)". Das BERICHT-Objekt traegt diesen aktualisierten Stand bereits
vollstaendig (ERSATZ-ZEILE statt VORLAGE-ZEILE, s. P-14) -- dies ist KEIN offener Punkt mehr.

**P-12 -- Objekt-Gegenprobe: ist wirklich Hermite verbaut, kein B-Spline-Rest? (Falsch-Null-
Doktrin, Memory-Dauerregel.)**
WIE pruefbar: Zitat aus axis_spline.hpp + `grep -rni "de.boor|knot_vector|bspline|b-spline"
libs/` mit Null-Resultat + genannter HEAD-SHA.
BEHAUPTET: JA -- BERICHT Abschn. 3.3: axis_spline.hpp "DEFAULT = monotone kubische Hermite
(Fritsch-Carlson 1980)"; Nullbefund bei ce-HEAD 65c51eeb (Berichtszeitpunkt).
FRISCHE GEGENPROBE (diese Sitzung, ce-HEAD **3841d717**, aktueller als alle drei bisherigen
Audit-Runden): Nullbefund haelt UNVERAENDERT (`grep -rni "de.boor|knot_vector|bspline|
b-spline" libs/` = 0). Vierte unabhaengige Messung in Folge mit identischem Ergebnis.

**P-13 -- HY-C-Vorbedingungsbild vervollstaendigen (OV-1, OV-12, E-5).**
WAS: implizit aus D3-Quelle (HY-C haengt "nach OV-1, OV-12, E-5").
BEHAUPTET: JA -- BERICHT Abschn. 3.4: OV-1 = Sachfrage beantwortet/Etikett-Formulierung durch
D-04-GO abgeloest; OV-12 explizit "nicht Teil dieses Auftrags"; E-5 = ENTSCHIEDEN
(KON108-02+KON111-01). Fuer HY-C als BAU-Vorbedingung ("nach OV-1, OV-12, E-5") ist relevant,
DASS entschieden wurde -- das haelt unveraendert; der CODE-Vollzugsstatus der Konsolidierung war
nie a19s Pruefgegenstand (a19 sollte den ENTSCHEIDUNGS-Status klaeren).

**P-14 -- OG-52 formal schliessen + eine an den Owner/das Fenster weitergebbare Zeile liefern.**
WAS (DESIGN:651): "Recherche-posten + Vorlage."
BEHAUPTET: JA -- BERICHT Abschn. 3.4 traegt (nach drei Fix-Runden) eine **ERSATZ-ZEILE**
(Kenntnisnahme statt Entscheid-Vorlage), NICHT mehr die urspruengliche "Praemissen-Hinweis"-
VORLAGE-ZEILE (die WAERE, per Formel #10, eine bereits beantwortete Frage erneut vorgelegt
haben -- sie wurde NIE uebertragen, `grep -c "Praemissen-Hinweis"` im F2FENSTER = 0, auch jetzt
noch). Die ERSATZ-ZEILE empfiehlt: F-122/D-04 gehoert aus dem Entscheid-Teil des F2-Fensters in
dessen ENTSCHIEDEN-Tabelle (E-1..E-10); fertige Textbausteine liegen in D04EXPL Teil F/G.
**OFFEN, ABER NICHT a19s SACHE (s. SPANNUNG S-9):** das F2FENSTER-Dokument selbst ist bislang
NICHT nachgezogen (mtime 22.08. 06:44:23, in dieser Sitzung frisch gemessen -- unveraendert seit
VOR a19s eigenem Fix-Runde-2/3-Zyklus); Z.36-39 tragen weiterhin woertlich "[ENTSCHEID, EIN
Satz] ... EIN Entscheid erbeten" fuer eine laengst beantwortete Frage. Traeger dieser
Aktualisierung ist per `lande-auflagen.md` L4/FOLGE-2 der LEAD, nicht a19.

**P-15 -- Gesamt-STATUS-SCHLUSS aller 3 Auftragsteile + Rollen-Nachweis (read-only).**
BEHAUPTET: JA -- BERICHT Abschn. 4 + Fix-Runde-3-Schlusszeile: "STATUS ... LANDEREIF; der
Recherche-Kern ... ist durch drei Fix-Runden unbeschaedigt bestaetigt worden."
FRISCHE GEGENPROBE (diese Sitzung): `grep -c "a19-volltexte\|A-19\b"` im Ledger = 0 (Ledger
weiterhin unberuehrt); `git worktree list` im ce-Hauptklon traegt weiterhin 0 a19-Eintraege
(29 Worktrees insgesamt, alle fuer andere Straenge, in dieser Sitzung selbst aufgelistet).

**P-16 -- Beweis-Doktrin: jede Behauptung mit Datei:Zeile/Commit-Hash belegt.**
BEHAUPTET: JA. In dieser Erhebung zusaetzlich zu den bereits dreifach (Audit R1-R3) bestaetigten
Literalen selbst nachgemessen: DESIGN-Zeilen 114-118/373/593-598/650-651/672-673/705/884-889
(exakt); WELLENPLAN-Zeilen 1054/2769/2935-2989/3395-3401/3409-3450/3476-3529 (exakt); GOALV8
Z.76 (exakt); LEDGER Z.19-39/40-176/137-140/159-166 (exakt, byte-identisch zur 14:08-Messung);
DESIGNPLAN Z.41/44/47/50/53/56/61 (Katalog-Gegenprobe, NEU in dieser Sitzung, s. P-19); ce-HEAD
3841d717 + 2x Null-Grep. **0 Abweichungen** zwischen den Zitaten der Vorquellen (inkl. der
14:08-Vorkarte) und dem, was diese Erhebung selbst vorfand.

**P-17 -- Rollen-Pflicht "NUR LESEN" einhalten (kein Worktree/Commit/Ledger-Write am Objekt).**
BEHAUPTET: JA. Diese Erhebung selbst: 0 Schreibzugriffe auf ce/super/prt-art ausser der
gewuenschten SOLL-KARTE-Datei (0 Commits, 0 Worktree-Anlage, nur lesende `git log`/`git
worktree list`/`grep`/`stat`/`sed`), 0 Ledger-Schreibung.

**P-18 -- GOAL-v8-Doktrin "Break-Even = B-Spline B=3" als Praemissen-Rahmen fuer OV-1
beruecksichtigen.**
WAS woertlich (GOALV8:76, in dieser Sitzung selbst gegrept): "Break-Even = B-Spline B=3,
dreimal je Baum-node-Tiefe."
BEFUND: diese Formulierung ist fachlich in Spannung zum Code-Ist (monotone Hermite ist ein
kubisches Polynom je Segment, aber KEIN B-Spline im mathematischen Sinn -- kein Knotenvektor,
keine B-Spline-Basisfunktionen). BERICHT 3.2(b) zitiert die Owner-Zielform ("interpolierend,
Spline B=3, String-persistierbar, Basis bei 0") und argumentiert, ein monotoner kubischer
Hermite sei "ebenfalls ein interpolierender Spline vom Grad 3" -- das ist im laxen Sprachgebrauch
vertretbar, verwischt aber den B-Spline-spezifischen Unterschied. **Diese Spannung ist mit der
D-04-Owner-Antwort vom 21.08. (Formel #10) GEGENSTANDSLOS GEWORDEN:** der Owner fuehrt
B-Splines seither ausdruecklich als EINE von mindestens 9 erlaubten Kurvenfamilien (nicht mehr
als exklusive Zielform) -- die alte "B-Spline B=3 vs. Hermite"-Entweder/Oder-Frage, die diese
Spannung ueberhaupt erzeugte, existiert in der aktuellen Auftragslage nicht mehr.

**P-19 -- Designplan-Bezug: T-1..T-9/T-11a-c/T-12a-e (strukturell) UND die realen
Katalog-Posten hinter D-1..D-5 (inhaltlich).**
BEFUND TEIL A (T-Pflichten): KEINES der 14 T-Kriterien ist auf A-19 direkt anwendbar -- A-19
produziert 0 Zeilen Produktions-/Testcode (reine Recherche/Volltext-Erhebung). BEHAUPTET vom
Bericht: NEIN (korrekt unerwaehnt, kein Fund).
BEFUND TEIL B (Katalog-Gegenprobe, NEU in dieser Sitzung -- bislang von keiner der drei
Audit-Runden explizit gegen DESIGNPLAN par.4 gefahren): der Designplan-Testkatalog (par.4, "Testarbeit
je Welle") fuehrt SECHS der von a19 in D-1..D-5+PM-Naht benannten Posten woertlich mit exaktem
[Band Welle Stunden]-Tag: `PK-KlemmJson n-Spalten [A W1 4]` (Z.44), `HY-Ebene4 Label+Datensatz
[A W1*(a)/W4(b) 12]` (Z.44), `LG-HostBinder 3 Felder [A W1 5]` (Z.47), `LG-E2Exlsx Facade
[A W1 6]` (Z.56), `XL-L4 n/a-Konkurrenz [A W1 3]` (Z.61), `PM-Naht perm_runner->CSV [A W1 2]`
(Z.53) -- alle in dieser Sitzung selbst gegrept und Zeile-fuer-Zeile gegen a19s Formulierungen
gehalten: Gegenstand, Band (A = "landet im Fenster", nicht vertagbar), Feld-/Bezeichner-Wortlaut
stimmen 1:1 ueberein. **a19s Delta-Liste ist damit nicht nur intern konsistent (0 stille
Verluste, P-04), sondern auch EXTERN gegen den unabhaengigen Designplan-Testkatalog verankert
-- eine zusaetzliche, in den drei bisherigen Audit-Runden nicht gefuehrte Bestaetigung.**

--------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertliche Zitate der Quellen)

1. **DESIGN:118** (A-19 selbst, Auftragsteil 1+2): "ABNAHME: Delta-Posten (falls vorhanden)
   in #96-Schnitt nachgetragen."
2. **DESIGN:375-376** (#96/D-9, Konsumenten-Abnahme, nicht A-19s eigene): "ABNAHME: JEDER
   Register-Posten namentlich aufgenommen; jede Z-Zeile abgehakt; Protokoll mit Stundenzahlen."
3. **DESIGN:672-673** (F-V-Pruefblock): "L-B-/L-D-Traeger: nur per 'Uebergabe Abschnitt 9'-
   Volltext klaerbar (A-19). QUELLE K3:TeilK2."
4. **DESIGN:884-889** (TEIL-5-Nr.10): "A-19-LUECKE: die vollen '20 W2-DEKLARIERT' (9.3) und die
   L-B/L-D-Traeger liegen NUR in externen Volltexten ... Einlesen ist als [A]-Posten verankert
   ... OV-1 (HY-C) in keinem der vier Design-Dokumente auffindbar -> OG-52-Rechercheposten."
5. **LEAD:22** (Entscheid Nr. 10): "A-19-Volltext-Luecke: eigener Lese-Strang in Staffel 2
   (a19-volltexte)."
6. **DESIGN:651** (OG-52): "Recherche-posten + Vorlage."
7. **WELLENPLAN:1054** (die OV-1-Sachfrage selbst, HISTORISCHE Fristformel -- der Gegenstand,
   nicht A-19s eigene Abnahme; per Formel #10 in der Sache ueberholt, s. P-11/P-18): "**OV-1
   BREAK-EVEN** | B=3-B-Spline im Fenster neu bauen (dein KERN-Wortlaut) ODER die gebaute
   monotone Hermite ratifizieren und die Methodenwahl in der Thesis begruenden, B-Spline nach
   der Abgabe? | ... dein Satz entscheidet, nicht meine Autonomie ... | Mo 17.08."
8. **F2FENSTER:36-39** (21.08., VOR der Owner-Antwort 20:40 desselben Tages formuliert; seither
   NICHT aktualisiert -- s. SPANNUNG S-9): "### D-04 * Break-Even-Buendel OV-1 + OV-6 + D4f (G11)
   [ENTSCHEID, EIN Satz] 'OV-1 (B=3-B-Spline neu vs. Hermite ratifizieren; axis_spline.hpp
   fuehrt Hermite) + OV-6 (BE-Definition; Fallregel: nicht bis F2 konsolidiert -> Break-Even
   faellt aus dem W1-Scope) + D4f-Statusraum ... EIN Entscheid erbeten.'"
9. **S2SYN:27** (Lead-Synthese-Abnahme des gesamten Strangs, 21.08.): "**LANDEREIF (read-only,
   3/3 Auftragsteile)** | kein Branch, kein Commit, kein Bau-Slot | n/a | Volltexte gefunden+
   gelesen; Gegenzaehlung 20=17 Eintraege deckt 91 Posten, 0 stille Verluste | #96 (Di 25.)
   uebernimmt Delta D-1..D-5 + P-1..P-3 + PM-Naht-Reihenfolge-Auflage; Owner-Zeilen V8/node6/D-04
   an Fenster/Lead (Vorlage-Wortlaute liegen); OG-52 ERLEDIGT."
10. **LEDGER Z.137-140** (KON120-02 TRANCHE 2, 22.08. frueh -- Verbuchung der Owner-Nachricht vom
    21.08. 20:40:56 UTC; per Rangfolge "Owner-Wort/juengere KON" die HEUTE operative D-04-Formel,
    ERSETZT Formel #8): "D-04 'mathematisches Definitions-Bereich Command pattern' VOLLES GO
    ALLE Familien (Hermite/Splines/B-Splines/Linien/quadratisch<=3/Log/Wurzel; Entropie-Filter 1,
    Fehlerrate-Filter 2; eigene Matlab-aehnliche Definitions-Sprache, Lager-Ablage; 12W-Explore +
    'Komponente 1 bis 4' suchen)." Ergaenzend **LEDGER Z.62-63** (KON121-Praezisierung): "der
    21.08.-Hermite-Ratifikationsvorschlag ist durch D-04 UEBERHOLT (nicht vollzogen)."
11. **`audit-runde-3.md`, VERDIKT-Abschnitt** (23.08., selbst gelesen, gehoert als juengste
    Abnahme-Instanz des Objekts selbst hierher): "SITZT (nach Fix) -- Nach dieser Runde ist am
    Objekt kein offener Fund mehr vorhanden ... 6 Funde, 6 behoben, 0 VERTAGT, 0 Regressionen.
    Der Strang bleibt LANDEREIF."

--------------------------------------------------------------------------------
## NICHT-GEFORDERT (ausdruecklich NICHT Teil von A-19 -- Phantom-Fund-Schutz fuer das Audit)

- **Tatsaechliche Eintragung der Delta-Posten (D-1..D-5, P-1..P-3, PM-Naht-Reihenfolge) ins
  #96-Register selbst**: ABNAHME von Task #96/D-9 (Traeger: Di-25.-Schnitt), nicht von A-19.
- **Bau/Fix der 5 Delta-Posten selbst** (PK-KlemmJson, HY-Ebene4a, LG-HostBinder, LG-E2Exlsx,
  XL-L4): eigene W2-Randslot-Bauposten fuer Di 25.08. (Designplan-Band-A, s. P-19).
- **Owner-ENTSCHEID zu D-04**: A-19 stellte nur fest, dass die 08.08.-Sachfrage beantwortet war.
  Der eigentliche Bau/Entwurf der mathematischen Definitions-Sprache, des Command-Pattern-
  Systems, der Factory-Methoden je Kurvenfamilie und des Fehler-Entropie/Fehlerrate-Filters ist
  NICHT A-19s Auftrag -- er ist Gegenstand des eigenen, bereits laufenden 12-Wochen-Explore-
  Strangs (#119-Buendel, D04EXPL) und einer kuenftigen Design-/Bau-Runde. Ebenso NICHT A-19s
  Auftrag: die String-Serialisierung des Kurvenmodells nachweisen/bauen oder den Vollzug der
  08.08.-Konsolidierung ("fuehre beide zusammen") am Code pruefen -- beides haengt am
  CODE-Bestand, nicht an a19s Recherche-Gegenstand (Identitaets-/Beantwortungsfrage), und laeuft
  beim selben D-04-Traeger weiter.
- **Owner-Handgriff V8 (GitHub-PAT-Rotation) und node6-Geraete-Handgriff selbst ausfuehren**:
  Vollzug bleibt Owner/Infra-Sache (V8 inzwischen per KON120-05 vollzogen; node6 offen).
- **OV-12 (=OG-51)**: ausdruecklich NICHT Teil dieses Auftrags.
- **HY-C-Bau selbst** (Break-Even-Router): bleibt in W4, keine A-19-Angelegenheit.
- **Das JSON-Feld "Praezisierung"**: existiert laut Bericht NICHT woertlich als Datenfeld.
- **Ledger-/Board-/F2FENSTER-Schreibung**: laut Rollen-Regel (Lead-only) ausdruecklich
  unterlassen -- auch die in P-14/S-9 beschriebene, weiterhin offene F2FENSTER-Aktualisierung
  ist NICHT a19s zu leisten, sondern liegt beim Lead (`lande-auflagen.md` L4/FOLGE-2).
- **Ein eigener Bau-Branch/Worktree/CI-Lauf**: A-19 ist "Kein Bau-Zweig" (bestaetigt: 0
  a19-Worktrees in `git worktree list`, s. P-15).
- **Designplan-T-Pflichten T-1..T-9/T-11a-c/T-12a-e**: strukturell nicht anwendbar (P-19).
- **Eine vierte Audit-Runde am selben Objekt-Detailstand**: `audit-runde-3.md` quittiert bereits
  "0 offene Funde"; ein Audit-Fund "a19 haette schon frueher etwas tun muessen, das erst NACH
  a19s eigenem Auftragsteil-3-Fenster (21.08. 18:07-20:40 UTC) entschieden wurde" waere ein
  PHANTOM-FUND (a19 konnte die 20:40-Uhr-Owner-Nachricht beim besten Willen nicht kennen).

--------------------------------------------------------------------------------
## SPANNUNGEN (Widersprueche/Unschaerfen zwischen den Quellen -- nicht glattgezogen)

**S-1 -- Scope-Erweiterung Auftragsteil 3 (OV-1/OG-52) ist NICHT explizit im A-19-Design-Slot
verankert, aber Lead-validiert.** DESIGN:114-118 nennt woertlich nur 2 Unterauftraege; OG-52
traegt an keiner Design-Stelle ein "(A-19)"-Tag. LEAD:22 bestaetigt nur "eigener Lese-Strang",
ohne OG-52 zu erwaehnen. Erst S2SYN:27 bestaetigt die 3-Teile-Fassung als gueltige
Lead-Synthese -- juengste Schicht gilt, ein dokumentierter Provenienz-Bruch bleibt aber fuer das
Audit erwaehnenswert. (In dieser Sitzung an allen vier Fundstellen erneut nachgelesen,
unveraendert.)

**S-2 -- Label-Kollision "D-04": mehrere unverwandte Gegenstaende teilen sich im Ledger dasselbe
Kuerzel.** `grep -n "D-04"` im Ledger (in dieser Sitzung erneut gefahren) findet sowohl
gegenstandsfremde Alt-Treffer (Minimize-Fallback, CE-Off-CSV, Ablationsstufen-Billigkeit,
F3-Testschuld) als auch den fuer a19 relevanten Break-Even/OV-1-Themenkomplex (KON120-02
Z.137-140, KON121 Z.60-63). Der BERICHT haelt diese beiden "D-04" durchgehend sauber
auseinander (kein Fund) -- die Kollision selbst bleibt eine Falle fuer nachfolgende, weniger
sorgfaeltige Lesungen und ist als solche dokumentiert.

**S-3 -- Namensraum-Kollision "Abschnitt 9" / "9.3".** Drei/vier disjunkte "Abschnitt-9"/
"9.x"-Namensraeume existieren unabhaengig (Designplan-Berichtigungen, Session-Regressionen-9.3,
K14-Uebergabe-Abschnitt-9). BERICHT fuehrt Datei+Commit durchgehend mit -- sauber, kein Fund.

**S-4 -- Rang-Unsicherheit von F2FENSTER in der vorgegebenen Quellen-Hierarchie, und was daraus
folgt.** F2FENSTER faktisch zwischen "juengere KON" und "Wellenplan par.21-23" einzuordnen ist
eine Annahme dieser Erhebungslinie. Diese Rang-Unsicherheit materialisiert sich konkret in S-9:
der Ledger (KON121, unzweifelhaft "juengere KON") UEBERHOLT den Inhalt von F2FENSTER inhaltlich,
obwohl F2FENSTER selbst nicht editiert wurde. Ein unveraendertes Dokument kann durch eine
juengere Schicht INHALTLICH ueberholt werden, ohne dass am Dokument selbst irgendein Byte sich
aendert -- das Audit sollte Dokument-Mtime NICHT mit Aktualitaet der IN IHM stehenden Aussagen
verwechseln.

**S-5 -- Zahlen-Konsistenz "8 F2-5-Posten" vs. "6 im Kurztext benannt" vs. "5 Delta + 1
PM-Naht".** Eine Interpretations-Leistung des Strangs, kein Widerspruch -- Herkunft der Etiketten
"(7)/(8)" liegt ausserhalb der offiziellen SOLL-QUELLEN. NEU IN DIESER SITZUNG per P-19
zusaetzlich verankert: die sechs benannten Posten (D-1..D-5+PM-Naht) sind wortgleich im
Designplan-par.4-Katalog auffindbar mit exakt passenden Band/Welle/Stunden-Tags -- die
"8 Posten ~33h"-Zahl der Wellenplan-Zeile F2-5 selbst rechnet zusaetzlich die 2 "UNKLAR"-Posten
LG-LoadWache/LG-Idempotenz ein (nicht im Designplan-Katalog als Band-A-Zeile mit identischem
Namen wiedergefunden) -- die genaue Stunden-Summe war nie a19s Pruefgegenstand und bleibt
ausserhalb dieser Erhebung ungeklaert (kein a19-Fund, reine Wellenplan-interne Fussnote).

**S-6 -- OG-52 traegt in DESIGN keine explizite Frist, anders als die benachbarten OG-50/OG-51.**
Design-interne Auslassung, nicht A-19-verschuldet. (Nachgeprueft: DESIGN:645-651 unveraendert.)

**S-7 -- [GESCHLOSSEN durch A2.5-Fix-Runde 3, 23.08. 14:10] Der Owner hat die D-04/OV-1-
Fragestellung am 21.08. abends selbst generalisiert/ueberholt -- NACH a19s Rechercheergebnis,
aber VOR dem gesamten a19-Audit-Fix-Verify-Zyklus.** Dies war der zentrale Fund der 14:08-
Vorkarte (dort ausfuehrlich als S-7a..S-7d hergeleitet). Der BERICHT hat diesen Befund inzwischen
vollstaendig absorbiert (ERSATZ-ZEILE statt VORLAGE-ZEILE in Abschn. 3.4, s. P-11/P-14), und
`lande-auflagen.md` traegt die Lead-Konsequenzen als L4+L4-ERGAENZUNG. Diese Erhebung bestaetigt
die Absorption als vollstaendig und fehlerfrei (P-16: 0 Abweichungen). **Bleibt als eigener,
NEUER Punkt offen: S-9 (das F2FENSTER-Dokument selbst ist trotzdem noch nicht nachgezogen).**

**S-8 -- NEU (diese Erhebung): Der AUFGABEN-STECKBRIEF, mit dem DIESER Erhebungs-Auftrag selbst
eroeffnet wurde, traegt eine veraltete Fassung von Auftragsteil 3.** Wortlaut des mir
uebergebenen Steckbriefs: "OV-1-Recherche (Sachfrage 08.08. beantwortet, D-04=enge
Ratifikation)". Diese Formulierung entspricht exakt dem VOR-21.08.-20:40-Stand (F2FENSTER-Formel
#8) -- genau der Stand, den die Owner-Nachricht vom 21.08. 20:40:56 UTC (Formel #10, KON120-02
TRANCHE 2) und KON121 seither ersetzt haben ("VOLLES GO ALLE Familien" statt "enge Ratifikation
Hermite vs. B-Spline"). Diese Soll-Karte uebernimmt die Steckbrief-Formulierung NICHT unkritisch
(s. P-11/P-14/ABNAHME-FORMEL #10), sondern legt den per Rangfolge (Owner-Wort > juengere KON)
aktuellen Stand vor. **Einordnung fuer das Audit:** dies ist kein a19-Fund (a19s eigener Bericht
traegt den aktuellen Stand bereits korrekt, s. S-7), sondern ein Hinweis darauf, dass die
Auftrags-STECKBRIEFE im Orchestrierungs-Layer (auch dieser Erhebung) denselben Alterungs-
Mechanismus unterliegen koennen wie F2FENSTER (S-9) -- der Ledger waechst am Kopf, Steckbrief-Text
tut es nicht von selbst.

**S-9 -- NEU (diese Erhebung, LIVE/derzeit noch offen): Das F2-VORLAGEN-FENSTER-Dokument selbst
traegt die veraltete D-04-Formel weiterhin unveraendert -- 6 Stunden nach dem Zeitpunkt, an dem
`lande-auflagen.md` (L4/FOLGE-2, 14:08 UTC) genau diese Aktualisierung als Lead-Auflage
festhielt.** Frisch gemessen in dieser Sitzung: `docs/sessions/20260821-F2-VORLAGEN-FENSTER-
FINAL-konsolidiert.md`, mtime **22.08.2026 06:44:23 UTC -- unveraendert seit VOR dem gesamten
a19-Fix-Zyklus**; Z.36-39 tragen weiterhin woertlich Formel #8 ("[ENTSCHEID, EIN Satz] ... EIN
Entscheid erbeten") fuer eine seit 21.08. 20:40 beantwortete Frage; kein neueres/alternatives
F2-Fenster-Dokument existiert (`docs/sessions/` durchsucht, einzige Kandidaten `20260821-F2-
FREEZE-CHECK-PROTOKOLL.md` [enthaelt 0 Treffer "D-04"/"OV-1", anderer Gegenstand] und die hier
gepruefte Datei selbst). **Einordnung fuer das Audit: dies ist explizit KEIN a19-Fund** (Traeger
ist laut `lande-auflagen.md` L4/FOLGE-2 eindeutig der Lead, nicht a19; a19 selbst darf F2FENSTER
laut Rollen-Regel nicht schreiben) -- es ist ein derzeit noch unerledigter, benannter
Lead-Auftrag, dessen Fortbestand diese Erhebung unabhaengig bestaetigt. Sollte irgendein
Prozess das F2FENSTER-Dokument in seiner jetzigen Form an den Owner weiterreichen, wuerde eine
bereits erteilte Freigabe ("Volles GO fuer ALLE Familien") faelschlich erneut als offene
Ja/Nein-Frage ("Hermite ratifizieren ODER B-Spline neu bauen") vorgelegt.
