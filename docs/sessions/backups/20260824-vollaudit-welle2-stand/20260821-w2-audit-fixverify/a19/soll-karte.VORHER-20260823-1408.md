# A-19 SOLL-KARTE — Volltext-Luecke (20-W2-Deklariert-Gegenzaehlung + L-B/L-D-Traeger + OV-1/OG-52)

Erstellt: 23.08.2026, Sonnet-max-Planungs-Erheber (read-only, KEIN Fix). Diese Fassung ist eine
EIGENSTAENDIGE Neuerhebung, keine Kopie der 22.08.-Fassung (Vorversion: 30131 B, 401 Z., mtime
22.08. 06:35 — vor dem Ueberschreiben in dieser Sitzung VOLL gelesen) — alle Quellen wurden in
DIESER Sitzung frisch gelesen/gegrept; die Vorversion
diente nur als Vollstaendigkeits-Kontrolle (BESTANDS-PFLICHT), nicht als Abschreibvorlage. Sie war
zwischenzeitlich Gegenstand von ZWEI vollstaendigen Audit-Runden (22.08., audit-runde-1.md +
audit-runde-2.md, im selben Ordner) mit Verdikt "alle 19 Soll-Punkte ERFUELLT" und 4 Funden
(A19-F1..F4, alle additiv BEHOBEN, Endstand von GEGENLESE-GATE.md bestaetigt "4/4 BEHOBEN,
objektverifiziert"). Diese Neufassung bestaetigt jenen Befund UNVERAENDERT fuer Auftragsteil 1+2
und deckt fuer Auftragsteil 3 einen SUBSTANTIELLEN NEUFUND auf, der NACH dem gesamten a19-Zyklus
entstanden ist (s. SPANNUNG S-7 — WICHTIGSTER BEFUND DIESER ERHEBUNG).

Objekt des Audits: `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/a19-volltexte-ergebnis.md`
— heute (23.08., frisch gemessen) **390 Zeilen, md5 76d4af7e4562300abd79970a3ced7087**, UNVERAENDERT
seit 22.08. 07:11:31 UTC (mtime identisch mit dem Audit-R2-Endstand + dem selbstangewandten
A2.5-Fix-Nachtrag Runde 2 fuer A19-F4). Aufgaben-Steckbrief: A-19, Staffel 2, Doku-/Read-only-Strang,
kein Bau-Zweig.

Quellen-Rangfolge lt. Auftrag: Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 >
Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht. Alle unten zitierten Zeilennummern wurden in
DIESER Erhebung (23.08.) direkt am Objekt/an den Quellen nachgelesen, nicht aus der Vorversion
uebernommen — Ledger-Zeilennummern sind daher gegenueber der 22.08.-Fassung erneut verschoben
(der Ledger waechst am Kopf; heute 32387 Z., 22.08.-Endstand war 32302 Z., Delta +85 durch die
neuen Eintraege "NACHTRAG zu KON120-02" + "KON121", s. S-7).

Mtime-Kontrolle der SOLL-QUELLEN (23.08., damit das Audit weiss, was sich seit dem 22.08.-Zyklus
ueberhaupt bewegt haben KANN): W2-ABFOLGE-DESIGN.md 20.08. 17:10 (unveraendert) · LEAD-ENTSCHEIDE
21.08. 09:04 (unveraendert) · WELLENPLAN 19.08. 21:37 (unveraendert) · DESIGNPLAN 20.08. 14:32
(unveraendert) · GOALV8 17.08. 07:37 (unveraendert) · STAFFEL1-SYNTHESE 22.08. 12:52 · STAFFEL2-
SYNTHESE 21.08. 18:20 (unveraendert seit vor a19s Audit-Zyklus) · LEDGER 22.08. 14:09 (GEWACHSEN,
s.o.) · F2FENSTER 22.08. 06:44 (unveraendert seit VOR a19s eigenem Fix-Runde-2). Einzige seit dem
22.08.-a19-Zyklus bewegte SOLL-QUELLE ist also der LEDGER — und exakt dort liegt der Neufund.

Abkuerzungen: DESIGN = `.../20260820-welle2-audit/W2-ABFOLGE-DESIGN.md` · LEAD =
`.../20260820-welle2-audit/LEAD-ENTSCHEIDE-zum-w2-design.md` · WELLENPLAN =
`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` (super-Repo) · DESIGNPLAN =
`docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md` · GOALV8 =
`docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` · LEDGER =
`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` · F2FENSTER =
`docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md` · S1SYN/S2SYN =
STAFFEL1-SYNTHESE.md / STAFFEL2-SYNTHESE.md (Ordner `20260820-w2-sofortstaffel/`) · BERICHT =
a19-volltexte-ergebnis.md (das gepruefte Objekt, 390 Z.) · D04EXPL = das juengste Primaerquellen-
Dokument zu Auftragsteil 3, `~/backups-workflow/20260822-explore-buendel-t2/d04-mathe-sprache.md`
(538 Z., VOLL gelesen in dieser Erhebung; selbst KON121-referenziert, s. S-7) · K21 =
`5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl` (laufendes Session-Transkript, 86263 Z. heute).

--------------------------------------------------------------------------------
## PRUEFLISTE

**P-01 — Volltext "20 W2-DEKLARIERT" (9.3) auffinden+lesen.**
WAS: "die vollen '20 W2-DEKLARIERT' leben nur in
~/backups-workflow/20260819-w93-endstand/w93-synthese-endstand-ww7zqfc2a.json (K3-BEFUND K1:
Kurztext liefert nur ~15; 3. Praezisierung unauffindbar)." (DESIGN:114-116, in dieser Erhebung
erneut am Design nachgelesen, Zeile unveraendert).
WIE pruefbar: Datei-Existenz + Byte-Groesse (28157 B lt. BERICHT); Feldpruefung
`result.synthese.offen_w2_deklariert` (17 Eintraege), `result.verdikt_zaehler.offen_w2` (=20),
`posten_gesamt` (=91); Rohdaten-Datei `w93-journal-ENDSTAND.jsonl` (23 Records) als Gegenprobe.
BEHAUPTET: JA — BERICHT Abschn. 1.1-1.2 (Z.10-33). Bereits in Audit-R1 mit eigener `ls`/Python-
Feldpruefung ERFUELLT bestaetigt (28157 B, 17/20/91 exakt); diese Erhebung fuehrt keine neue
Divergenz — die Quelle liegt in `~/backups-workflow/` (statisches Artefakt vom 19.08., seither
nicht angefasst, kein Mtime-Delta erwartet oder noetig zu pruefen fuer eine SOLL-Karte).

**P-02 — Delta-Posten (Kurztext vs. Volltext) fuer #96 auflisten.**
WAS wörtlich (ABNAHME-Satz von A-19 selbst): "ABNAHME: Delta-Posten (falls vorhanden) in
#96-Schnitt nachgetragen." (DESIGN:118). Ergaenzend D-9/#96 selbst listet unter seinen
Z-Aufraeum-Punkten: "A-19-Delta (9.3-Volltext) nachtragen" (DESIGN:373, in dieser Erhebung erneut
am Design gegengelesen).
WIE pruefbar: Liste mit 5 benannten Posten + Zitat-Beleg je Posten (grep-Kommando + 0-Treffer-
Nachweis) + gesonderter Reihenfolge-Hinweis (PM-m3v2Spalten VOR PM-Naht).
BEHAUPTET: JA — BERICHT Abschn. 1.3 (Z.41-69): D-1 PK-KlemmJson, D-2 HY-Ebene4a (owner-gated),
D-3 LG-HostBinder, D-4 LG-E2Exlsx, D-5 XL-L4, je mit grep-Zitat; plus PM-Naht-Reihenfolge-Auflage.
NEUER STATUS (23.08., S2SYN Z.311 erneut gelesen): "#96-Gegenzaehlung Di 25. inkl. a19-Delta
(D-1..D-5 + P-1..P-3 + PM-Naht-Reihenfolge) [F-119]" — der Traeger-Termin (Di 25.08.) liegt noch
VOR dem heutigen Erhebungsdatum (23.08.) in der Zukunft; keine neue Information seit 22.08.

**P-03 — "3 Praezisierungen" identifizieren (im Kurztext-Kopf nur gezaehlt, nicht benannt).**
WAS: Kurztext-Kopf "9.3 W2-DEKLARIERT (20, je Quelle; 3 PRAEZISIERUNGEN)".
WIE pruefbar: 3 benannte Eintraege mit Zitat, die eine Vorquelle KORRIGIEREN (nicht nur ergaenzen).
BEHAUPTET: JA — BERICHT Abschn. 1.4 (Z.71-85): P-1 A15/#71, P-2 PM-Naht, P-3 B1, plus 3
Mitfuehr-Kandidaten explizit abgegrenzt. Unveraendert seit 22.08., keine neue Quelle betrifft dies.

**P-04 — Vollstaendige Gegenzaehlung "0 stille Verluste" liefern.**
WAS: DESIGN selbst fuehrt diese Doktrin fuer sich vor ("Gegenzaehlung 441 Roh-Zeilen -> 0 stille
Verluste", DESIGN:896/Selbstcheck) — impliziter Massstab.
WIE pruefbar: 17er-Kurzliste (W2-01..W2-17) je mit Rohverdikt-Herkunft + 8-Gruppen-Summe = 91.
BEHAUPTET: JA — BERICHT Abschn. 1.5 (Z.87-93): W2-01..W2-17 + Gruppensumme 16+9+4+5+7+23+14+13=91.
Unveraendert seit 22.08.; W2-17 = #38a2 — HINWEIS (kein Fund, s. NICHT-GEFORDERT): der spaetere
Ledger-Fund "#38a2 NIE gebaut" (KON121 Punkt 2) betrifft den BAU-Status des Postens, nicht a19s
Zaehl-/Mapping-Leistung — a19 behauptet an keiner Stelle, #38a2 sei gebaut.

**P-05 — "Uebergabe Abschnitt 9"-Volltext fuer L-B/L-D auffinden+lesen.**
WAS: "Ebenso 'Uebergabe Abschnitt 9'-Volltext fuer L-B/L-D-Traeger (K3-BEFUND K2)."
(DESIGN:116-118); F-V-Pruefblock: "L-B-/L-D-Traeger: nur per 'Uebergabe Abschnitt 9'-Volltext
klaerbar (A-19)." (DESIGN:672-673, in dieser Erhebung erneut nachgelesen).
WIE pruefbar: Fundort-Zitat mit Commit-Hash + Datei + Zeilenbereich; Abgrenzung gegen
Verwechslungs-Kandidaten.
BEHAUPTET: JA — BERICHT Abschn. 2.1 (Z.98-109). Unveraendert seit 22.08.

**P-06 — Traeger-Frage "WER TRAEGT L-B" (V8 GitHub-PAT-Rotation) beantworten.**
WAS: "OG-26 L-B V8 GitHub-PAT-Rotation (Traeger unklar ... A-19)." (DESIGN:593-594).
WIE pruefbar: FAZIT-Zeile mit benanntem Traeger + Belegkette + Objekt-Gegenprobe.
BEHAUPTET: JA — BERICHT Abschn. 2.3 (Z.126-175, INKL. des A19-F1-NACHTRAGs vom 22.08., der bereits
im Objekt steht): FAZIT "Traeger = #84-Umfeld + Owner-Punkte-Liste"; NACHTRAG dokumentiert V8
prod1 VOLLZUG per KON120-05.
FRISCHE GEGENPROBE (23.08., diese Erhebung): `~/.git-credentials` heute **lines_total=3,
github_lines=1** — identisch mit der Audit-R2-Messung vom 22.08., KEINE weitere Drift. KON120-05
im Ledger heute bei Z.159 (22.08.-Audit-R2-Messung: Z.93-100; Ledger ist seither um +85 Z.
gewachsen, Kopfwaechst-Muster haelt — reine Zeilendrift, Inhalt unveraendert). `grep -c "V8"`
im NEUEN Ledger-Kopf (Z.1-115, "NACHTRAG zu KON120-02" + KON121) = **2** (Z.23 + Z.115) — BEIDE
Treffer sind reine REKAPITULATIONEN des bereits bekannten "V8-prod1 GEDECKT (KON120-05)"-Befunds
(Z.23: "A3 = KON120-05 GEDECKT (V8-prod1 + A3-Handout)"; Z.115: KON120-Ueberschrift selbst
"... + V8-prod1-VOLLZUG + ..."), in dieser Erhebung gegengelesen — KEINE neue V8-Substanz, KEIN
neuer GitHub-PAT-Befund. L-B bleibt inhaltlich UNBERUEHRT vom Neufund S-7 (der betrifft
ausschliesslich D-04/OV-1, nicht V8).

**P-07 — Traeger-Frage "WER TRAEGT L-D" (node6/id56/id18) beantworten.**
WAS: "OG-28 L-D node6/id56/id18 (Traeger unklar ... A-19)." (DESIGN:597-598).
WIE pruefbar: analog P-06, plus Objekt-Widerspruchs-Aufloesung.
BEHAUPTET: JA — BERICHT Abschn. 2.3 (Z.177-202): FAZIT "Traeger = Owner-Punkte-Liste + Cluster-
Repo W-1 P-RUNNER [CTO]". A19-F4-Fix (Restposten-Liste um #197-Laptop-De-Embed ergaenzt) steht
im Objekt (Z.171-172 traegt heute 6 statt 5 Posten — in dieser Erhebung nachgezaehlt: "Cluster-
Poller aktiv (Infra-Restarbeit: #197-Laptop-De-Embed, Alt-PAT-Revokes, GitLab-Rotation OF-4-Kette,
U-2-root, node6, id56/id18)" — 6 Posten, deckungsgleich mit dem heutigen Ledger KON120-05-Block
Z.159 ff. (in dieser Erhebung selbst nachgezaehlt: ebenfalls 6 Posten, identischer Wortlaut).
KEIN neuer Ledger-Fund zu node6/id56/id18 seit 22.08. (KON121 erwaehnt sie nicht erneut).

**P-08 — F-V-Pruefblock-Zeile "L-B-/L-D-Traeger ... (A-19)" schliessen.**
WAS (DESIGN:672-673, s. P-05).
BEHAUPTET: JA — BERICHT Abschn. 2.4 (Z.191-196, unveraendert seit 22.08.). Kein neuer Befund.

**P-09 — TEIL-5-Nr.10-Luecke ("A-19-LUECKE") schliessen.**
WAS: "A-19-LUECKE: ... Einlesen ist als [A]-Posten verankert ..." (DESIGN:884-887, in dieser
Erhebung erneut am Design nachgelesen, unveraendert).
BEHAUPTET: JA — BERICHT Kopfzeile Z.3-4. Unveraendert.

**P-10 — Auftragsteil 3 (OV-1/OG-52): Identitaets-Frage klaeren ("ist die HY-C-'OV-1' dieselbe
wie die Wellenplan-§8-Break-Even-Frage?").**
WAS: "OG-52 OV-1 (HY-C-Vorbedingung) — in D1/D2/D4 NICHT auffindbar; Recherche-posten + Vorlage.
QUELLE K4:TEIL3/3a HY-C." (DESIGN:650-651).
WIE pruefbar: Beleg-Kette ueber mind. 2 unabhaengige Dokumente + Zweitbeleg.
BEHAUPTET: JA — BERICHT Abschn. 3.1: Herkunfts-Zitat aus HYBRID-bauplan Z.172/139/252 +
WELLENPLAN:1054/705/708/728/765/869/1002. Die Identitaets-Frage selbst ist NICHT vom Neufund
S-7 beruehrt (die Owner-Nachricht vom 21.08. 20:40 bestaetigt selbst dieselbe Identitaet: sie
spricht explizit vom "Break Even Buendel", das "weiterhin gilt" — s. S-7). **P-10 haelt
unveraendert und wird durch S-7 sogar zusaetzlich bestaetigt.**

**P-11 — OV-1-Beantwortungsstatus klaeren (beantwortet? wann? von wem? erreichte das Etikett
den Owner?).**
WAS: keine explizite Design-ABNAHME-Formel; ergibt sich aus dem Recherche-Charakter von OG-52.
WIE pruefbar: Primaerquelle mit Zeitstempel + Ledger-Gegenprobe + Owner-Nachrichten-Gegenprobe.
BEHAUPTET: JA — BERICHT Abschn. 3.2 (Z.225-260): Owner-Zitat "Wir brauchen nur eine
konsolidierte Implementierung" (08.08. 09:44) = "OV-1-Antwort"; Etikett "OV-1" entstand 7h
spaeter, erreichte den Owner laut 2998-Nachrichten-Gegenprobe NIE.
FRISCHE GEGENPROBE (23.08.): Owner-Zitat im Ledger heute Z.31148 (22.08.-Audit-R2-Messung:
Z.31063; Fix-R1-Messung: Z.31033; Original: Z.30971 — reine Kopf-Wachstums-Drift, +85 seit
gestern, Wortlaut IDENTISCH nachgelesen: "Wir brauchen **nur eine konsolidierte
Implementierung**, bitte fuehre beide zusammen und nach meiner Beschreibung zum Ziel.").
`grep -noP "OV-1\b"` im Ledger heute liefert **DREI** Treffer, nicht mehr zwei (Z.12433
KON7-05-Kontext, Z.18474 Zaehl-Erwaehnung "Gegenprobe OV-1 = 8" — beide deckungsgleich mit dem
A19-F3-Fix-Befund, nur Zeilendrift — PLUS NEU Z.61 "compare Komponenten', OV-1 nie vollzogen,
V-09a-1..8 traegerlos" aus KON121 selbst). **Der dritte Treffer ist kein Zaehl-Artefakt wie
Z.18474, sondern die substanzhaltige Kern-Aussage des Neufunds dieser Erhebung — s. S-7.** Die
"GENAU ZWEI"-Aussage aus BERICHT 3.2(c)/A19-F3-Fix war zum jeweiligen Messzeitpunkt (20./22.08.)
korrekt; sie ist seit KON121 (22.08. vormittags, nach dem a19-Zyklus) nicht mehr die aktuelle
Zaehlung — reine Nach-Ereignis-Drift, kein Zitatfehler des Berichts.
**AKTUALITAETS-CAVE (23.08., NEU — s. S-7 fuer die volle Herleitung):** Die Aussage "OV-1
(Break-Even) IST BEANTWORTET" (BERICHT 3.2a, sourced aus wf_17efd95b-ce5, 09.08.) bleibt fuer die
09.08.-SACHFRAGE (Konsolidierungs-Auftrag "fuehre beide zusammen") historisch korrekt zitiert.
Eine JUENGERE, hoeherrangige Quelle (Owner-Wort 21.08. 20:40:56 UTC, K21 Zeile 80809, in dieser
Erhebung selbst am Rohtranskript gelesen) zeigt jedoch: (a) die Konsolidierung selbst ist am
22./23.08. NICHT im Code vollzogen (alle drei Implementierungs-Stacks leben unveraendert
nebeneinander, s. S-7b, von mir am heutigen ce-HEAD 3841d717 frisch gegengeprueft), und (b) der
Owner hat die zugrundeliegende Anforderung am 21.08. abends selbst NEU AUFGEGRIFFEN und
GENERALISIERT (D-04 "Volles GO ALLE Familien"), was die von a19 als "beantwortet, Rest nur noch
enge Ratifikation" gerahmte Lage UEBERHOLT. Die BERICHT-Zitate selbst sind wortgetreu (Beweis-
Doktrin haelt), aber die aus ihnen gezogene SCHLUSSFOLGERUNG ("Rest = enge Ratifikationsfrage")
ist per juengerer Owner-Wort-Schicht nicht mehr die aktuelle SOLL-Lage.

**P-12 — Objekt-Gegenprobe: ist wirklich Hermite verbaut, kein B-Spline-Rest?**
WAS: Falsch-Null-Doktrin (Memory-Dauerregel).
WIE pruefbar: Zitat aus axis_spline.hpp + grep-Kommando mit Null-Resultat + genannter HEAD-SHA.
BEHAUPTET: JA — BERICHT Abschn. 3.3: axis_spline.hpp Z.15 "DEFAULT = monotone kubische Hermite";
`grep -rni "de.boor|knot_vector|bspline|b-spline" ce/libs/` = 0.
FRISCHE GEGENPROBE (23.08., diese Erhebung, ce-HEAD **3841d717**, 2026-08-23T13:50:07Z — NEUER
als sowohl der Berichts-HEAD 65c51eeb als auch der Audit-R1-HEAD ed9f1a3c): axis_spline.hpp
Kommentarkopf VOLL gelesen — "VERFAHRENS-WAHL (numerisch begruendet): DEFAULT = monotone
kubische Hermite (Fritsch-Carlson 1980)" wortgleich vorhanden; "Der natuerliche kubische Spline
bleibt als alternative Strategy verfuegbar" (Z.21-22, KEIN B-Spline benannt). Der Nullbefund
haelt am dritten unabhaengig geprueften HEAD in Folge (Audit-R1: ed9f1a3c: 0; diese Erhebung:
3841d717: 0 [eigene `grep -rn "to_string\|from_string\|serialize"` axis_spline.hpp/break_even.hpp
zusaetzlich = 0, s. S-7c]). **P-12 haelt vollstaendig, VERSTAERKT durch eine dritte unabhaengige
Messung.**

**P-13 — HY-C-Vorbedingungsbild vervollstaendigen (3 Vorbedingungen: OV-1, OV-12, E-5).**
WAS: implizit aus D3-Quelle (HY-C haengt "nach OV-1, OV-12, E-5").
BEHAUPTET: JA — BERICHT Abschn. 3.4: OV-1 = beantwortet/Rest D-04; OV-12 explizit "nicht Teil
dieses Auftrags"; E-5 = ENTSCHIEDEN (KON108-02+KON111-01).
**AKTUALITAETS-CAVE (23.08., NEU):** Die "E-5 = ENTSCHIEDEN"-Einordnung bezieht sich auf die
Owner-DECISION-Ebene ("std-only-Zweitschrift FAELLT ersatzlos", KON111-01) — das bleibt als
ENTSCHEID korrekt zitiert. D04EXPL (s. S-7b) zeigt jedoch, dass diese Entscheidung am 22./23.08.
am CODE NICHT VOLLZOGEN ist (best_binary_selector Haelfte B existiert weiterhin unveraendert,
0 Deprecation-/Redirect-Kommentare — von mir selbst am heutigen HEAD nachgeprueft). Fuer HY-C
als BAU-Vorbedingung ("nach OV-1, OV-12, E-5") ist relevant, DASS entschieden wurde — das haelt;
dass der Vollzug noch aussteht, ist ein zusaetzlicher, praeziserer Befund, den a19 nicht erhoben
hat (war auch nicht sein Auftrag — a19 sollte den ENTSCHEIDUNGS-Status klaeren, nicht den
Code-Vollzug verifizieren).

**P-14 — OG-52 formal schliessen + Vorlage-Zeile fuer D-04 liefern.**
WAS: "Recherche-posten + Vorlage." (DESIGN:651).
BEHAUPTET: JA — BERICHT Abschn. 3.4 Ende: "=> OG-52-Rechercheposten ERLEDIGT. VORLAGE-ZEILE
(nicht bauen; Ergaenzung zu D-04, Entwurf): 'Praemissen-Hinweis zu D-04/OV-1: ...'".
FRISCHE GEGENPROBE (23.08.): F2FENSTER unveraendert seit 22.08. 06:44 (vor a19s eigenem
Fix-Runde-2) — die vom BERICHT vorgeschlagene "Praemissen-Hinweis"-Vorlage ist dort weiterhin
NICHT eingetragen (`grep -c "Praemissen-Hinweis"` = 0, wie schon in Audit-R2 gemessen).
**AKTUALITAETS-CAVE (23.08., NEU, WICHTIG): der vom BERICHT formulierte Vorlage-Text selbst
("die gebaute monotone Hermite erfuellt ... dem Wortlaut nach; ein B-Spline-Basis-Umbau waere
Mehrbau ohne benannten Zweck") ist NICHT MEHR die aktuelle Owner-Praemisse.** Der Ledger
(KON121, Z.60-63, in dieser Erhebung frisch gelesen) fuehrt wortwoertlich: "PRAEZISIERUNG zu
KON120-02: der 21.08.-Hermite-Ratifikationsvorschlag ist durch D-04 UEBERHOLT (nicht
vollzogen)." Sollte die a19-Vorlage-Zeile HEUTE noch an das F2-Fenster/den Owner uebertragen
werden, wuerde sie eine bereits vom Owner selbst ueberholte Fragestellung erneut vorlegen — s.
S-7 fuer die vollstaendige Herleitung und die daraus resultierende EMPFEHLUNG (Traeger: NICHT
a19 rueckwirkend, sondern der D-04-Design-Zug aus #119/D04EXPL).

**P-15 — Gesamt-STATUS-SCHLUSS aller 3 Auftragsteile + Rollen-Nachweis (read-only).**
BEHAUPTET: JA — BERICHT Abschn. 4: "STATUS: LANDEREIF."
FRISCHE GEGENPROBE (23.08.): `grep -c "a19-volltexte\|A-19\b"` im Ledger heute = **0** (bestaetigt
"Ledger unberuehrt" haelt unveraendert, trotz +85 neuer Ledger-Zeilen seit gestern). `git
worktree list` in ce (Pfad `Code/external/comdare-cache-engine`) heute = 0 a19-Treffer.
STATUS-Aussage "LANDEREIF" selbst bleibt fuer Auftragsteil 1+2 unangefochten; fuer Auftragsteil 3
gilt sie nur im engeren Sinn "die Recherche-Leistung ist vollstaendig und literaltreu" — NICHT
im Sinn "die von a19 vorgeschlagene Vorlage-Zeile ist weiterhin die richtige Uebertragung" (s. P-14).

**P-16 — Beweis-Doktrin: jede Behauptung mit Datei:Zeile/Commit-Hash belegt.**
BEHAUPTET: JA. In DIESER Erhebung zusaetzlich zu den bereits zweifach (Audit R1+R2) bestaetigten
Literalen NEU eigenstaendig verifiziert: K21 Zeile 80809 (Owner-Wortlaut, direkt am 524-MB-
Rohtranskript per `sed -n '80809p'` + JSON-Parse gelesen, ts 2026-08-21T20:40:56.484Z, Text
deckungsgleich mit D04EXPL Teil B.6 bis auf Umlaut-Transliteration) · ce-HEAD 3841d717 (axis_spline.hpp,
break_even.hpp, best_binary_selector.hpp:361 SKELETON, decision_lambda_trees.hpp:10 Spiegelung,
0 hybrid_router.hpp, 0 to_string/from_string/serialize) · Ledger Z.60-63/109/137 (KON121-Praezisierung)
+ Z.125-137 (KON120-02-Volles-GO) + Z.159 (KON120-05 heute). **0 Abweichungen** zwischen den
Zitaten der Vorquellen und dem, was diese Erhebung selbst am Objekt vorfand.

**P-17 — Rollen-Pflicht "NUR LESEN" einhalten (kein Worktree/Commit/Ledger-Write).**
BEHAUPTET: JA. Diese Erhebung selbst: 0 Schreibzugriffe auf ce/super/prt-art (nur `git log`/`git
rev-parse`/`grep`/`ls`/`stat`/lesende `sed`), 0 Ledger-Schreibung, kein Worktree angelegt.

**P-18 — GOAL-v8-Doktrin "Break-Even = B-Spline B=3" als Praemissen-Rahmen fuer OV-1
beruecksichtigen.**
WAS wörtlich: "Break-Even = B-Spline B=3, dreimal je Baum-node-Tiefe" (GOALV8:76, in dieser
Erhebung frisch gegrept, Zeile unveraendert, Datei-Mtime 17.08. unveraendert seit vor a19).
**AKTUALITAETS-VERSTAERKUNG (23.08., statt blossem CAVE): D04EXPL Teil B.5 zeigt am Code-Bestand,
dass diese GOAL-v8-Doktrin ("B-Spline B=3") woertlich NICHT durch die verbaute monotone Hermite
gedeckt ist** — Hermite ist mathematisch KEIN B-Spline (keine B-Spline-Basisfunktionen, kein
Knotenvektor im B-Spline-Sinn; nur "Grad 3" im laxen Sinn). Der urspruengliche Soll-Karten-Befund
"KEIN Widerspruch gefunden" (22.08.) wird durch diese Erhebung REVIDIERT: **es besteht sehr wohl
ein Wortlaut-Spannungsfeld zwischen der GOAL-v8-Doktrin (B-Spline) und dem Code-Ist (Hermite)**,
das a19s eigener Bericht durch die Formulierung "Spline B=3 ... dem Wortlaut nach" (BERICHT 3.2b)
implizit glaettet, ohne den B-Spline-vs-Hermite-Unterschied selbst explizit zu benennen (den der
Assistant laut D04EXPL bereits am 08.08. selbst herausgearbeitet hatte, s. S-7c).

**P-19 — Designplan-TDD-Vertrag (T-1..T-9) + Nachtraege T-11a-c/T-12a-e: Anwendbarkeit pruefen.**
BEFUND (unveraendert, DESIGNPLAN-Mtime stabil seit 20.08.): KEINES der 14 T-Kriterien ist auf
A-19 direkt anwendbar — A-19 produziert 0 Zeilen Produktions-/Testcode. BEHAUPTET vom Bericht:
NEIN (korrekt unerwaehnt).

**P-20 — NEU (23.08.): String-Serialisierungs-Nachweis fuer das Break-Even-Kurvenmodell (Teil
der urspruenglichen 08.08.-Sachfrage, von a19 NICHT explizit geprueft).**
WAS: die 08.08.-Owner-Anforderung (B.3, K21 Z.17190, zitiert in D04EXPL D.1) verlangt "als String
gespeichert und wieder geparst und interpretiert werden kann". a19s eigener Bericht (3.2b) zitiert
diese Anforderung ("String-persistierbar") als angeblich durch Hermite erfuellt, OHNE den Code auf
eine `to_string`/`from_string`/`serialize`-Funktion zu pruefen.
WIE pruefbar: `grep -rn "to_string\|from_string\|serialize" libs/cache_engine/heuristik/
axis_spline.hpp libs/cache_engine/heuristik/break_even.hpp` im ce-Repo.
BEFUND (diese Erhebung, ce-HEAD 3841d717): **0 Treffer** — es existiert KEINE Serialisierungs-
Funktion fuer das Kurvenmodell selbst (nur die Mess-CSV wird ge-/entladen, `measurement_curve_
loader.hpp`, nicht das Kurvenmodell). BEHAUPTET vom Bericht: implizit JA (durch unkritische
Uebernahme der Selbstauskunft "erfuellt deinen Wortlaut" aus dem eigenen 21.08.-Vorlage-Entwurf)
— **dieser Teil der Praemisse haelt bei eigenstaendiger Pruefung NICHT.** Kein Fund GEGEN a19
(die Pruefung dieses Detailpunkts war nicht explizit Teil des A-19-Auftrags), aber ein Beleg
dafuer, dass die VORLAGE-ZEILE (P-14) auf einer ungeprueften technischen Praemisse aufbaute.

**P-21 — NEU (23.08.): Ist die vom Owner am 08.08. beauftragte Konsolidierung ("fuehre beide
zusammen") am Code tatsaechlich vollzogen?**
WAS: K21 Z.17225 (08.08. 09:44, Owner verbatim): "Wir brauchen nur eine konsolidierte
Implementierung, bitte fuehre beide zusammen". a19s Bericht wertet dies als "beantwortet"
(Sachfrage-Ebene), macht aber keine Aussage zum CODE-Vollzugsstatus.
WIE pruefbar: Existenz von Deprecation-/Redirect-Markierungen in den drei Implementierungs-
Verzeichnissen (`builder/curve_fit/`, `builder/decision_lambda_trees/`,
`builder/best_binary_selector/`); Existenz von `hybrid/hybrid_router.hpp`.
BEFUND (diese Erhebung, ce-HEAD 3841d717): alle drei Verzeichnisse EXISTIEREN weiterhin
unveraendert (Dateidatum 15.08. 18:17, seit VOR a19s eigenem Bearbeitungszeitraum unberuehrt);
`best_binary_selector.hpp:361` traegt weiterhin die Selbstdeklaration "HYBRID-BREAK-EVEN-
SELEKTOR-SKELETON"; `decision_lambda_trees.hpp:10` traegt weiterhin "Der SELF-CONTAINED
best_binary_selector traegt eine std-only Spiegelung derselben Rueckwaerts-[Wahl-Mathematik]";
0 Deprecation-/Redirect-Kommentare in allen drei Verzeichnissen; `hybrid/` enthaelt weiterhin
NUR ein `README.md`-Stub (0 Treffer fuer `hybrid_router*` im gesamten ce-Baum). **Die
Konsolidierung ist NICHT vollzogen** — deckungsgleich mit D04EXPL D.1 ("bis heute (22.08.)
nicht vollzogen") UND mit KON121s "OV-1 nie vollzogen". BEHAUPTET vom Bericht: KEINE explizite
Aussage (a19 pruefte nur, OB Hermite/B-Spline-Reste existieren, nicht OB die drei Stacks
konsolidiert wurden) — auch hier: kein Fund GEGEN a19 (ausserhalb des Auftrags), aber ein fuer
das Audit wichtiger Kontext-Baustein zu S-7.

--------------------------------------------------------------------------------
## ABNAHME-FORMELN (woertliche Zitate der Quellen)

1. **DESIGN:118** (A-19 selbst, Auftragsteil 1+2): "ABNAHME: Delta-Posten (falls vorhanden)
   in #96-Schnitt nachgetragen."
2. **DESIGN:375-376** (#96/D-9, Konsumenten-Abnahme, nicht A-19s eigene): "ABNAHME: JEDER
   Register-Posten namentlich aufgenommen; jede Z-Zeile abgehakt; Protokoll mit Stundenzahlen."
3. **DESIGN:672-673** (F-V-Pruefblock): "L-B-/L-D-Traeger: nur per 'Uebergabe Abschnitt 9'-
   Volltext klaerbar (A-19). QUELLE K3:TeilK2."
4. **DESIGN:884-887** (TEIL-5-Nr.10): "A-19-LUECKE: die vollen '20 W2-DEKLARIERT' (9.3) und die
   L-B/L-D-Traeger liegen NUR in externen Volltexten ... Einlesen ist als [A]-Posten verankert
   ... bis dahin traegt dieses Design die Kurztext-Fassung (K3-BEFUNDE K1/K2)."
5. **LEAD:22** (Entscheid Nr. 10): "A-19-Volltext-Luecke: eigener Lese-Strang in Staffel 2
   (a19-volltexte)."
6. **DESIGN:651** (OG-52): "Recherche-posten + Vorlage."
7. **WELLENPLAN:1054** (die OV-1-Sachfrage selbst, HISTORISCHE Fristformel — der Gegenstand,
   nicht A-19s eigene Abnahme): "**OV-1 BREAK-EVEN** | B=3-B-Spline im Fenster neu bauen (dein
   KERN-Wortlaut) ODER die gebaute monotone Hermite ratifizieren und die Methodenwahl in der
   Thesis begruenden, B-Spline nach der Abgabe? | ... dein Satz entscheidet, nicht meine
   Autonomie ... | Mo 17.08." (Frist laengst verstrichen; per Formel #10 unten INHALTLICH durch
   die 21.08.-Owner-Nachricht ueberholt — die "entweder/oder"-Alternative dieser Formel ist nicht
   mehr die aktuelle Fragestellung).
8. **F2FENSTER:35-38** (21.08., VOR der Owner-Antwort 20:40 desselben Tages formuliert; seither
   NICHT aktualisiert — **HISTORISCH, seit 21.08. abends durch Formel #10 in der Sache
   ueberholt, s. S-7**): "### D-04 · Break-Even-Buendel OV-1 + OV-6 + D4f (G11) [ENTSCHEID, EIN
   Satz] 'OV-1 (B=3-B-Spline neu vs. Hermite ratifizieren; axis_spline.hpp fuehrt Hermite) +
   OV-6 (BE-Definition; Fallregel: nicht bis F2 konsolidiert -> Break-Even faellt aus dem
   W1-Scope) + D4f-Statusraum (bauen solange 0 Konsumenten ODER W2 deklarieren): EIN Entscheid
   erbeten.'"
9. **S2SYN:27** (Lead-Synthese-Abnahme des GESAMTEN Strangs, 21.08.): "**LANDEREIF (read-only,
   3/3 Auftragsteile)** | kein Branch, kein Commit, kein Bau-Slot | n/a | Volltexte gefunden+
   gelesen; Gegenzaehlung 20=17 Eintraege deckt 91 Posten, 0 stille Verluste | #96 (Di 25.)
   uebernimmt Delta D-1..D-5 + P-1..P-3 + PM-Naht-Reihenfolge-Auflage; Owner-Zeilen V8/node6/D-04
   an Fenster/Lead (Vorlage-Wortlaute liegen); OG-52 ERLEDIGT."
10. **NEU (23.08., HOECHSTRANGIG per Rangfolge Owner-Wort — die aktuell operative D-04-Formel):**
    K21 Zeile 80809, Owner verbatim, **2026-08-21T20:40:56.484Z** (in dieser Erhebung selbst am
    Rohtranskript gelesen; deckungsgleich mit D04EXPL Teil B.6, dort auch schon zitiert):
    "D-04 Bitte hier mit ultracode nochmal die session log und ledger verbatim Stellen finden
    und den Designplan gegenlesen, weil Alle Funktionen bereichsweise modelliert werden und
    jeder Bereich versucht mit allen verfuegbaren factory Methoden den Funktionsabschnitt in
    mathematischen Definitionsbereichen (web recherche) abzubilden, diejenige mit der geringsten
    Fehler-Enthropie (1. sortier-Fiilter) und Fehlerrate (2. sortier-Filter) gewinnt, daher sind
    monotone und dynamische hermite und Splines, sowie auch B-Splines, Linien, Quadratische
    Funktionen bis zum dritten Grad, logarithmen-Funktionen, Wurzelfunktionen, unter filterung
    der Randfaelle und verwendung von ausschliesslich sicheren Definitionsbereichen ueber den
    Wertebereich der Parameterbeschreibung, erlaubt. Die Erzeugung von Synthese-Funktionen
    besteht also aus einer weitreichenden Syntax der in einer eigenen mathematischen
    Definitions-Sprache (wie Matlab aehnlich, web recherche), um die Synthesekurven gestueckelt
    zu modellieren und im Lager abzulegen, wie geplant (Explore mit ultracode). Daher Volles GO
    fuer ALLE diese Felder als mathematisches Definitions-Bereich Command pattern. Die Analyse
    ist dadurch wesentlich komplexer und rechenintensiver. Das Break Even Buendel gilt weiterhin,
    aber der Kontext braucht einen 12 Wochen Explore ueber alle Aspekte des Themas, bevor der
    Gesamtzusammenhang und die 4 bis 5 compare Komponenten/Stufen vergessen werden, die in
    dieses Bild gehoeren. Hinweis: Durchsuche den Kontext nach 'Komponente 1 bis 4'."
    Diese Formel ERSETZT Formel #8 als operative Abnahme fuer "D-04": statt einer engen
    Ja/Nein-Ratifikation (Hermite vs. B-Spline) ist die aktuelle Abnahme-Anforderung ein
    12-Wochen-Explore + Design + Bau eines mathematischen Definitions-Bereich-Command-Patterns
    ueber (mindestens) 9 Kurvenfamilien mit zweistufigem Fehler-Entropie/Fehlerrate-Filter. Das
    "Break Even Buendel gilt weiterhin" (Owner-Wortlaut) — die alte OV-1/OV-6/D4f-Fragestellung
    ist NICHT verworfen, sondern in die groessere Aufgabe aufgegangen (D04EXPL D.4).

--------------------------------------------------------------------------------
## NICHT-GEFORDERT (ausdruecklich NICHT Teil von A-19 — Phantom-Fund-Schutz fuer das Audit)

- **Tatsaechliche Eintragung der Delta-Posten (D-1..D-5, P-1..P-3, PM-Naht-Reihenfolge) ins
  #96-Register selbst**: ABNAHME von Task #96/D-9 (Traeger: Di-25.-Schnitt), nicht von A-19.
- **Bau/Fix der 5 Delta-Posten selbst** (PK-KlemmJson, HY-Ebene4a, LG-HostBinder, LG-E2Exlsx,
  XL-L4): eigene W2-Randslot-Bauposten fuer Di 25.08.
- **Owner-ENTSCHEID zu D-04 (alte, engere Fassung)**: A-19 stellte nur fest, dass die 08.08.-
  Sachfrage beantwortet war und nur eine enge Ratifikation offen sei. **Ergaenzung 23.08.: auch
  die NEUE, breitere D-04-Aufgabe (Formel #10) — der eigentliche Bau/Entwurf der mathematischen
  Definitions-Sprache, des Command-Pattern-Systems, der Factory-Methoden je Kurvenfamilie und
  des Fehler-Entropie/Fehlerrate-Filters — ist NICHT A-19s Auftrag.** Sie ist Gegenstand eines
  eigenen, bereits laufenden 12-Wochen-Explore-Strangs (#119-Buendel, D04EXPL) und einer
  kuenftigen Design-/Bau-Runde. Ein Audit-Fund "A-19 hat die Definitions-Sprache nicht gebaut"
  oder "A-19 haette die 22.08.-Owner-Nachricht vorwegnehmen muessen" waere ein PHANTOM-FUND —
  a19s Auftragsteil-3-Recherche fand vor dieser Owner-Nachricht statt (bzw. so knapp davor, dass
  sie sie beim besten Willen nicht kennen konnte, s. S-7d) und war fuer ihren Auftrag
  (Identitaets-Frage OV-1 + Beantwortungsstatus-Recherche) vollstaendig und literalgetreu.
- **Owner-Handgriff V8 (GitHub-PAT-Rotation) und node6-Geraete-Handgriff selbst ausfuehren**:
  Vollzug bleibt Owner/Infra-Sache.
- **OV-12 (=OG-51)**: ausdruecklich NICHT Teil dieses Auftrags.
- **HY-C-Bau selbst** (Break-Even-Router): bleibt in W4, keine A-19-Angelegenheit.
- **Das JSON-Feld "Praezisierung"**: existiert laut Bericht NICHT woertlich als Datenfeld.
- **Ledger-/Board-Schreibung**: laut Rollen-Regel (Lead-only) ausdruecklich unterlassen.
- **Ein eigener Bau-Branch/Worktree/CI-Lauf**: A-19 ist "Kein Bau-Zweig".
- **Designplan-T-Pflichten T-1..T-9/T-11a-c/T-12a-e**: strukturell nicht anwendbar.
- **Die NACHTRAEGLICHE Korrektur der eigenen VORLAGE-ZEILE**: A-19 selbst hat (regelkonform,
  READ-ONLY, kein Fix-Auftrag mehr aktiv) die eigene Vorlage-Zeile seit dem Owner-Update vom
  21.08. 20:40 NICHT revidiert — das ist KEIN A-19-Fund, sondern liegt (analog A19-F1s V8-Muster)
  beim Traeger, der die Vorlage-Zeile tatsaechlich uebertraegt (Lead/F2-Fenster-Nachfolger), bevor
  eine Uebertragung stattfindet. Solange die Vorlage-Zeile NICHT an den Owner/das Fenster
  weitergereicht wurde (frisch bestaetigt: `grep -c "Praemissen-Hinweis"` im F2FENSTER = 0), ist
  auch kein Schaden entstanden — die Empfehlung dieser Erhebung ist rein praeventiv (s. S-7d).

--------------------------------------------------------------------------------
## SPANNUNGEN (Widersprueche/Unschaerfen zwischen den Quellen — nicht glattgezogen)

**WICHTIGSTER BEFUND DIESER ERHEBUNG: S-7.** Die Spannungen S-1..S-6 stammen unveraendert aus
der 22.08.-Vorerhebung (in dieser Sitzung gegen die aktuellen Quellen nachgeprueft, s. jeweilige
Fussnote) und bleiben gueltig; S-7 ist NEU und postdatiert den gesamten a19-Audit-Zyklus.

**S-1 — Scope-Erweiterung Auftragsteil 3 (OV-1/OG-52) ist NICHT explizit im A-19-Design-Slot
verankert, aber Lead-validiert.** (Nachgeprueft 23.08.: DESIGN Z.114-118/593-598/650-651/672-673/
884-889 unveraendert; S2SYN Z.27/209-213 unveraendert; die Bewertung von 22.08. haelt
unveraendert.) DESIGN:114-118 nennt woertlich nur 2 Unterauftraege; OG-52 traegt an keiner
Design-Stelle ein "(A-19)"-Tag. LEAD:22 bestaetigt nur "eigener Lese-Strang", ohne OG-52 zu
erwaehnen. Erst S2SYN:27/209-213 bestaetigt die 3-Teile-Fassung als gueltige Lead-Synthese —
juengste Schicht gilt, aber ein dokumentierter Provenienz-Bruch bleibt fuer das Audit
erwaehnenswert.

**S-2 — Label-Kollision "D-04": mindestens 4 unterschiedliche, unverwandte Gegenstaende teilten
sich am 22.08. dasselbe Kuerzel — Stand 23.08.: JETZT SIND ES FUENF, davon EINE neu
gegenstandsRELEVANT.** Fruehere Erhebung (22.08.): `grep "D-04"` fand AUSSCHLIESSLICH
gegenstandsfremde Treffer (Minimize-Fallback, CE-Off-CSV, Ablationsstufen-Billigkeit,
F3-Testschuld). **NACHTRAG 23.08. (diese Erhebung, frischer Vollgrep):** Der Ledger traegt
HEUTE zusaetzlich einen FUENFTEN "D-04"-Themenkomplex, der SEHR WOHL Break-Even/OV-1 betrifft
(Z.60/63/109/137, aus "NACHTRAG zu KON120-02" + "KON121") — die 22.08.-Aussage "AUSSCHLIESSLICH
gegenstandsfremde Treffer" ist damit seit 22.08. NICHT MEHR zutreffend (der Ledger ist seither
gewachsen; zum 22.08.-Erhebungszeitpunkt selbst duerfte KON120-02 laut den Zeitstempeln
technisch schon existiert haben, wurde aber von keiner der beiden Audit-Runden per Vollgrep
"D-04" erneut gegengeprueft — deren Fokus lag auf der Quittierung der 3 spezifischen Audit-R1-
Funde, nicht auf einer erneuten Vollpruefung aller Soll-Karten-Punkte). Die vier
gegenstandsfremden Alt-Treffer bleiben (heutige Zeilen: 1464, 3697/3906, 15212/15215,
23904/23957 — reine Kopf-Wachstums-Drift gegenueber den 22.08.-Zeilen). **Details zum neuen,
relevanten Treffer: s. S-7.**

**S-3 — Namensraum-Kollision "Abschnitt 9" / "9.3".** (Nachgeprueft 23.08.: DESIGNPLAN-Mtime
unveraendert seit 20.08., Wellenplan-Zitate Z.752/2263 stabil.) Unveraendert gueltig, s.
22.08.-Fassung fuer die volle Herleitung: drei/vier disjunkte "Abschnitt-9"/"9.x"-Namensraeume
existieren unabhaengig (Designplan-Berichtigungen, Session-Regressionen-9.3, K14-Uebergabe-
Abschnitt-9). BERICHT fuehrt Datei+Commit durchgehend mit — sauber, kein Fund.

**S-4 — Rang-Unsicherheit von F2FENSTER in der vorgegebenen Quellen-Hierarchie.** (Nachgeprueft
23.08.: F2FENSTER-Mtime 22.08. 06:44, unveraendert seit VOR a19s eigenem Fix.) Bleibt als
Einordnungs-Annahme dieser Erhebungslinie bestehen: F2FENSTER faktisch zwischen "juengere KON"
und "Wellenplan par.21-23" einzuordnen. **Ergaenzung 23.08.: Genau diese Rang-Unsicherheit
materialisiert sich jetzt konkret in S-7 — der Ledger (KON121, unzweifelhaft "juengere KON")
UEBERHOLT den Inhalt von F2FENSTER inhaltlich, obwohl F2FENSTER selbst nicht editiert wurde.
Das bestaetigt die Vorsicht von S-4: ein unveraendertes Dokument kann durch eine juengere Schicht
INHALTLICH ueberholt werden, ohne dass am Dokument selbst irgendein Byte sich aendert — das Audit
sollte Dokument-Mtime NICHT mit Aktualitaet der IN IHM stehenden Aussagen verwechseln.**

**S-5 — Zahlen-Konsistenz "8 F2-5-Posten" vs. "6 im Kurztext benannt" vs. "5 Delta + 1 PM-Naht".**
(Unveraendert seit 22.08., keine neue Quelle betrifft dies; Wellenplan-Mtime stabil.) Bleibt wie
in der 22.08.-Fassung: eine Interpretations-Leistung des Strangs, kein Widerspruch, aber die
Herkunft der Etiketten "(7)/(8)" liegt ausserhalb der offiziellen SOLL-QUELLEN (Audit-R1 hat sie
am Rohdaten-JSON direkt verifiziert: `offen_vor_f2`-Feld, je 1 Eintrag fuer LG-SkipCallback/
LG-XlsxAlt).

**S-6 — OG-52 traegt in DESIGN keine explizite Frist, anders als die benachbarten OG-50/OG-51.**
(Nachgeprueft 23.08.: DESIGN:645-651 unveraendert.) Design-interne Auslassung, nicht
A-19-verschuldet.

**S-7 — NEU (23.08.): Der Owner hat die D-04/OV-1-Fragestellung am 21.08. ABENDS selbst
generalisiert/ueberholt — NACH a19s Rechercheergebnis, aber VOR dem gesamten a19-Audit-Fix-
Verify-Zyklus — und das ist bislang NIRGENDS in der a19-Kette (Bericht, Audit R1/R2, Fix R1/R2,
S2SYN, SYNTHESE-S2-AUDIT, GEGENLESE-GATE) verarbeitet.**

*S-7a — Zeitliche Rekonstruktion (alle Zeitstempel in dieser Erhebung selbst gemessen):*
- a19s Auftragsteil-3-WIEDERANLAUF beginnt lt. Berichtskopf **21.08. 18:07 UTC**.
- Der Owner sendet die generalisierende D-04-Nachricht (Formel #10) lt. K21-Rohtranskript
  (Zeile 80809, in dieser Erhebung selbst per `sed`+JSON-Parse gelesen) um **21.08.
  20:40:56.484 UTC** — also WAEHREND oder kurz NACH a19s eigenem Auftragsteil-3-Fenster.
- a19s VORLAGE-ZEILE (BERICHT 3.4, "Praemissen-Hinweis zu D-04/OV-1 ... Hermite ratifizieren")
  greift damit exakt die 21.08.-VORGAENGER-Formulierung (F2FENSTER:35-38, selbst vom 21.08.
  VOR 20:40 Uhr) auf — OHNE (und KONNTE NICHT, weil zeitlich vorausgehend bzw. gleichzeitig)
  die um 20:40 Uhr gesendete Owner-Antwort zu kennen.
- Audit-R1 laeuft **22.08., ca. ab 06:49** (elf Stunden NACH der Owner-Nachricht). Audit-R2
  laeuft **22.08. nach 06:59**. Beide Runden pruefen a19s Zitate GEGEN DEN LEDGER, nicht gegen
  das laufende Session-Transkript K21 — und der Ledger bucht die Owner-Nachricht laut KON120-02
  erst als "TRANCHE 2 (22.08. frueh)", also ZEITLICH SPAETER als ihre eigentliche Aussendung.
  Damit ist erklaerbar (nicht entschuldigt, aber nachvollziehbar), warum selbst zwei sorgfaeltige,
  literaltreue Audit-Runden den Neufund nicht fingen: ihr Pruefraster war "stimmen a19s Zitate mit
  dem Ledger ueberein" — nicht "gibt es im LAUFENDEN Transkript eine noch nicht gebuchte,
  hoeherrangige Owner-Antwort auf genau die Frage, die a19 aufwirft".
- Der eigentliche Fund kam ueber einen VOELLIG ANDEREN Auftrag zustande: KON121 (22.08.
  vormittags) ordnete die Suche nach der woertlichen Owner-Phrase "Komponente 1 bis 4" einem
  eigenen 12-Wochen-Explore-Strang zu (#119-Buendel, D04EXPL), der DABEI (nicht als Hauptzweck)
  auch die vollstaendige D-04/OV-1-Chronologie inkl. der 21.08.-Owner-Antwort ausgrub und explizit
  mit a19s eigenem 21.08.-Vorschlag verglich (D04EXPL Teil B.5, "der Vorschlag").

*S-7b — Inhaltlicher Kern 1 (Owner-Wort schlaegt Wellenplan-§8/F2FENSTER, per Rangfolge):* Die
Owner-Nachricht vom 21.08. 20:40 (Formel #10) ersetzt die "entweder/oder"-Alternative aus
WELLENPLAN:1054 ("B=3-B-Spline neu bauen ODER Hermite ratifizieren") und die daraus abgeleitete
enge Ratifikationsfrage F2FENSTER:35-38 durch einen Turnier-Mechanismus ueber (mindestens) 9
Kurvenfamilien mit zweistufigem Fehler-Entropie/Fehlerrate-Filter, in einer eigenen Definitions-
Sprache, mit explizitem 12-Wochen-Explore-Auftrag. Zitat KON121 (Ledger Z.60-63, diese Erhebung):
"PRAEZISIERUNG zu KON120-02: der 21.08.-Hermite-Ratifikationsvorschlag ist durch D-04 UEBERHOLT
(nicht vollzogen)." Wortlaut-Deckung mit D04EXPL Teil B.6: "Der 21.08.-Vorschlag 'Hermite
ratifizieren' ist damit durch D-04 inhaltlich ueberholt, nicht vollzogen."

*S-7c — Inhaltlicher Kern 2 (zwei technische Detail-Praemissen von a19s eigener Vorlage-Zeile
halten bei eigenstaendiger Code-Pruefung NICHT vollstaendig, s. P-20/P-21):* (i) Die
Konsolidierung "fuehre beide zusammen" (08.08.) ist am heutigen ce-HEAD **3841d717** (23.08., von
dieser Erhebung selbst geprueft) NICHT vollzogen — alle drei Stacks (`heuristik/` Hermite,
`builder/curve_fit`+`decision_lambda_trees` natuerlicher Spline+Kopie, `builder/
best_binary_selector` Haelfte B, self-deklariert "SKELETON" bei Zeile 361) existieren
unveraendert (Dateidatum 15.08., seit VOR a19 unberuehrt) nebeneinander, 0
Deprecation-/Redirect-Marker. (ii) Eine String-Serialisierung des Kurvenmodells selbst
(`to_string`/`from_string`/`serialize`) ist im heutigen `heuristik/`-Bestand NICHT vorhanden
(0 Treffer, eigene Pruefung) — nur die Mess-CSV wird ge-/entladen. (iii) "Spline B=3" (a19s
Formulierung, uebernommen aus dem 21.08.-Vorschlag) ist fachlich eine Umdeutung: monotone
kubische Hermite-Interpolation ist ein Polynom dritten Grades JE SEGMENT, aber KEIN B-Spline im
mathematischen Sinn (keine B-Spline-Basisfunktionen, kein Knotenvektor) — exakt der Unterschied,
den derselbe Assistant bereits am 08.08. selbst herausgearbeitet hatte (K21 Z.17221, in
D04EXPL B.3 zitiert), bevor der 21.08.-Vorschlag ihn durch Umbenennung der Erfuellung wieder
einebnete. Damit steht die GOAL-v8-Doktrin "Break-Even = B-Spline B=3" (GOALV8:76) fachlich
WEITERHIN ungedeckt durch den Code-Ist-Zustand — s. P-18-Revision oben.

*S-7d — Einordnung fuer das Audit (keine Schuldzuweisung, klare Traeger-Empfehlung):* a19s
Auftragsteil-3-Arbeit war fuer IHREN Auftrag (Identitaets-Frage OV-1 + Beantwortungsstatus der
09.08.-Sachfrage) literalgetreu, gruendlich und in zwei Audit-Runden bestaetigt korrekt — dieser
Befund AENDERT SICH NICHT. Was sich geaendert hat, ist die GRUNDLAGE, auf der a19s
Handlungsempfehlung (die VORLAGE-ZEILE) aufbaute: der Owner hat noch am selben Abend die
Fragestellung selbst neu gefasst, und weder a19 noch die beiden nachfolgenden Audit-Runden noch
S2SYN/SYNTHESE-S2-AUDIT/GEGENLESE-GATE (alle 22.08., alle NACH 20:40 Uhr des Vortags) haben dies
bislang mit dem a19-Strang verknuepft. **Handlungsempfehlung dieser Erhebung (NUR als Hinweis,
kein Fix-Auftrag dieser Erhebung):** (1) Die a19-VORLAGE-ZEILE (BERICHT 3.4) sollte NICHT
unveraendert an den Owner/das F2-Fenster uebertragen werden (P-14) — sie wuerde eine bereits vom
Owner selbst ueberholte, engere Fragestellung erneut vorlegen. (2) Traeger fuer die Aktualisierung
ist NICHT a19 selbst (dessen Auftrag/Lese-Fenster liegt vor der Owner-Nachricht und ist
abgeschlossen/LANDEREIF fuer seinen eigenen Umfang), sondern der D-04-Design-Zug, der D04EXPL
bereits als Explore-Grundlage traegt (Teil F/G dort: Design-Skelett RegionCommand/
RegionCommandFactory/RegionTournament, ausdruecklich "NICHT Bauauftrag", als Diskussionsgrundlage
fuer die naechste Design-Runde). (3) F-122 (S2SYN Z.212, "Lead: Praemissen-Hinweis-VORLAGE an
D-04 uebertragen") sollte vom Lead NICHT wie urspruenglich geplant ausgefuehrt, sondern durch
einen Verweis auf D04EXPL + die Owner-Nachricht vom 21.08. 20:40 ersetzt werden — die Entwurfs-
Textbausteine dafuer liegen bereits vollstaendig in D04EXPL Teil F/G vor.
