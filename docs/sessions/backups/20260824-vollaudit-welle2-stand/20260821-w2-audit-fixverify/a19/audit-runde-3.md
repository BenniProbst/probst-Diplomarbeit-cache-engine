# AUDIT RUNDE 3 (RE-VERIFY R2 + Konvergenz-Runde) -- Strang a19

Pruefer: Fable-max-KONVERGENZ-PRUEFER+FIXER (S2-Aufgabe a19), 23.08.2026, Fortsetzung nach Riss.
Eingang VOLL gelesen: soll-karte.md (401 Z.) | audit-runde-1.md (117 Z.) | fix-runde-1.md
(107 Z.) | audit-runde-2.md (203 Z.) | lande-auflagen.md (63 Z.) | beide VORHER-Beweiskopien
(311 Z. / 368 Z.). Objekt: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/
a19-volltexte-ergebnis.md -- DOKU-STRANG, kein Bau-Gegenstand, kein Bauslot, kein Vollbau,
kein ctest, keine Rot-Laeufe. Repos NUR GELESEN. ALLE Belege dieser Runde eigenstaendig
gehoben; nichts aus Audit R1/R2 oder Fix R1/R2 abgeschrieben.

--------------------------------------------------------------------------------
## 0. AUSGANGSLAGE: WAS DER RISS HINTERLASSEN HAT (eigene Messung)

Juengster Verdikt-Stand im Ordner: **audit-runde-2.md = FIXES_NOETIG** (ein offener Fund,
A19-F4 KLEIN). Am Objekt war dieser Fix jedoch bereits VOLLZOGEN, nur nie quittiert:
- Objekt 390 Z. / md5 76d4af7e / mtime 22.08. 07:11 -- NICHT die von Audit R2 vermessenen
  368 Z. / md5 c15e1fda (= a19-volltexte-ergebnis.VORHER-fix-r2.md).
- lande-auflagen.md trug bereits einen "NACHTRAG Fix-Runde 2" (mtime 07:11), aber im Ordner
  fehlte fix-runde-2.md.
Der Riss hat also die QUITTUNG gekappt, nicht die Arbeit. Konsequenz fuer diese Runde:
(1) A19-F4 unabhaengig nachmessen und nachquittieren (-> fix-runde-2.md),
(2) die eigentliche RE-VERIFY fahren, (3) offene Funde in EINER Fix-Runde schliessen
(-> fix-runde-3.md).

--------------------------------------------------------------------------------
## 1. QUITTUNGS-NACHMESSUNG A19-F4 -> BESTAETIGT

- Diff VORHER-fix-r2 -> Stand 22.08. 07:11: GENAU 2 Hunks -- 171c171 (in-place "#197-Laptop-
  De-Embed, " vor "Alt-PAT-Revokes"; keine neue Bestandszeile, Audit-R2-Anker bleiben gueltig)
  und 367a368,389 (additiver Abschnitt "A2.5-FIX-NACHTRAG RUNDE 2", 22 Z.). Nichts geloescht.
- Ledger-Gegenprobe dieser Runde (23.08., 32387 Z.): KON120-05 heute Z.159-166; Klammer
  Z.165-166 literal "Cluster-Poller aktiv (Infra-Restarbeit: #197-Laptop-De-Embed, Alt-PAT-
  Revokes, GitLab-Rotation OF-4-Kette, U-2-root, node6, id56/id18)" = SECHS Posten,
  eigenstaendig ausgezaehlt; die Aufzaehlungen im Bericht und in L1/L3 fuehren jetzt alle sechs.
- Der Fixer R2 hat ueber den fix_weg hinaus auch die L1-ENTWURFS-ZEILE vervollstaendigt (dort
  haette die gekuerzte Liste sich in Lead-only-Dokumente fortgepflanzt) -- richtig entschieden.
- ASCII: 0 Nicht-ASCII-Treffer ueber alle in R2 eingefuegten Zeilen.
=> Quittung BEHOBEN traegt vollstaendig. Details in fix-runde-2.md.

--------------------------------------------------------------------------------
## 2. FORTBESTANDS-PROBE DER FRUEHEREN FIXE (F1/F2/F3, je eigene Messung)

- **F1 (V8):** NACHTRAG steht unveraendert in Z.163-175, entwertet die V8-VORLAGE-ZEILE
  ("NICHT mehr an Fenster/Owner uebertragen", Z.170). Lead-Anteil noch offen und damit
  weiter berechtigt: S2SYN Z.210 traegt HEUTE noch literal "OFFEN -- OWNER -- **verschaerft
  S1-F-75 mit Objektstand**" (Datei-mtime 21.08. 18:20, seither unberuehrt).
- **F2 (Anker):** Der Zitat-Anker in 3.4 hat sich zum dritten Mal bewaehrt -- die nackte Zahl
  waere erneut falsch: Owner-Zitat heute Z.31148 (Fix R1: 31033), NACHTRAG-Kopf Z.31106
  (30991). S2SYN Z.212 traegt weiterhin die stale "Ledger Z.30971" -> L2 bleibt berechtigt.
- **F3 (OV-1-Zaehlung):** Die R1-Ergaenzung steht; der Zweittreffer liegt heute bei Z.18474.
  Neu ist ein DRITTER Treffer -> Fund A19-F6 (Abschn. 4).
=> Keine der drei Quittungen ist erodiert; kein Regress.

--------------------------------------------------------------------------------
## 3. REGRESSIONS- UND ROLLEN-PROBEN

- Read-only-Kontinuitaet (P-15/P-17): `git worktree list` und `git branch -a` in super UND ce
  = je **0** a19-Treffer; `grep -c "a19-volltexte"` am Ledger = **0**; `git status --porcelain`
  am Ledger und ueber docs/sessions/ = leer.
- TABU-Zonen: `git status --porcelain` in ce ueber axes/ topics/ heuristik/ tests/unit/
  CMakeLists.txt .gitlab-ci.yml = leer. golden unberuehrt.
- Fremd-Zustaende im super-Klon (ausdruecklich NICHT von diesem Strang): " M Code/external/
  comdare-cache-engine" (Submodul-Zeiger) und "?? build-l4/" -- beides Arbeit anderer
  Straenge; a19 hat in KEINEM Repo geschrieben, alle Schreibzugriffe liegen ausschliesslich
  unter ~/backups-workflow (kein Git-Repo: `git rev-parse` literal "fatal: not a git
  repository" -> Commit-/Push-Regel ohne Gegenstand, wie schon in R1/R2).
- Bauslot-Protokoll: nicht in Anspruch genommen, weil kein Bau stattfand (kein Marker angelegt,
  keiner zu loeschen). df-Gate: kein Bau -> kein Gate-Gegenstand.
- clang-format-22: n/a (kein Lint-Pfad, reines Markdown).

--------------------------------------------------------------------------------
## 4. FUNDE DIESER RUNDE (neue IDs)

### A19-F5 -- MILD -- D-04-VORLAGE-ZEILE (3.4) durch die Owner-Antwort Tranche 2 UEBERHOLT; der Uebertrag haette einen erteilten Entscheid erneut erbeten UND einen widerlegten Halbsatz an den Owner getragen
- **Befund (eigene Messung):** Ledger **Z.137-140** (KON120-02 TRANCHE 2, Commit **657003bb**,
  22.08. 06:32:44) literal: 'D-04 "mathematisches Definitions-Bereich Command pattern" **VOLLES
  GO ALLE Familien** (Hermite/Splines/**B-Splines**/Linien/quadratisch<=3/Log/Wurzel;
  Entropie-Filter 1, Fehlerrate-Filter 2; eigene Matlab-aehnliche Definitions-Sprache,
  Lager-Ablage; 12W-Explore + "Komponente 1 bis 4" suchen)'. Owner-Wortlaut in
  docs/sessions/20260822-SESSION-owner-antworten-tranche-1-2-zuordnung-und-vollzug.md
  Z.102-113: "Volles GO fuer ALLE diese Felder als mathematisches Definitions-Bereich Command
  pattern." + "Die enge Hermite-Ratifikation aus D-04-alt ist damit ERWEITERT, nicht
  widerrufen: Hermite bleibt EINE der erlaubten Familien." KON121 (Ledger Z.62-64, Commit
  00c341a0) praezisiert: "der 21.08.-Hermite-Ratifikationsvorschlag ist durch D-04 UEBERHOLT
  (nicht vollzogen)".
  Die a19-VORLAGE-ZEILE (Abschn. 3.4), die der Lead laut S2SYN Z.212/255 als F-122 ins
  F2-Fenster traegt, sagt dagegen: "erbeten ist NUR noch die Ratifikation der Spline-FORM" und
  "ein B-Spline-Basis-Umbau waere Mehrbau ohne benannten Zweck". Beides ist ueberholt: es ist
  nichts mehr zu erbitten, und B-Splines sind vom Owner ausdruecklich als erlaubte Familie mit
  benanntem Zweck (Entropie-/Fehlerraten-Filter, Definitions-Sprache, Lager) freigegeben.
- **Identitaets-Gegenprobe (wegen Soll-Karten-Warnung S-2, Label-Kollision "D-04"):** Die
  Owner-Tranche-2-Buchstaben decken sich 1:1 mit den F2-Fenster-Deltas -- D-02 Rename, D-05
  G-1-Restfragen, D-06 SCHEMA-Bein, D-07 cp/ce-Klammerformen, D-10 OV-16+OV-17 sind in Ledger
  Z.137-145 und F2FENSTER Z.25-64 je derselbe Gegenstand. Es ist dasselbe D-04, keines der
  vier gleichnamigen Ledger-Fremdthemen.
- **Dringlichkeit:** Der Uebertrag steht noch aus -- `grep -c "Praemissen-Hinweis"` im
  F2-Fenster = **0**; der D-04-Block steht dort unveraendert in Z.36-39 als "[ENTSCHEID, EIN
  Satz] ... EIN Entscheid erbeten". Der Fix kommt also VOR dem Schaden.
- **Herkunft (Beweislage):** Der Beleg lag in DERSELBEN Commit-Ladung wie KON120-05 (657003bb,
  06:32:44) -- vor Fix R1 (06:58) und vor Audit R2 (07:08). Audit R1, Fix R1 und Audit R2
  haben KON120-05 gehoben und KON120-02 uebersehen. Nachgezogener Fund, kein neuer Drift.
- **Kein Phantom-Fund:** Die Soll-Karte stellt den "Owner-ENTSCHEID zu D-04" unter
  NICHT-GEFORDERT -- das schuetzt davor, a19 die ENTSCHEIDUNG anzulasten. Hier geht es um
  etwas anderes: die vom Strang WEITERZUREICHENDE Zeile ist durch eine juengere Quelle
  ueberholt. Genau diese Klasse hat Audit R1 als A19-F1 gefuehrt, und die Soll-Karte selbst
  setzt "Owner-Wort > juengere KON > ... > Strang-Bericht".
- **fix_weg / VOLLZOGEN in Fix R3:** NACHTRAG in 3.4 (Entwertung + ERSATZ-ZEILE als
  Kenntnisnahme), Zeiger in 3.2(e) und im ersten 3.4-Spiegelstrich, Lande-Auflage L4
  (Uebertrag umstellen | F2-Fenster-Block in die ENTSCHIEDEN-Tabelle E-1..E-10 |
  S2SYN Z.212/255/308 nachziehen), L2 mit UEBERHOLT-Banner.

### A19-F6 -- KLEIN -- OV-1-Zaehlung in 3.2(c) erneut untererfasst (dritter Treffer seit KON121)
- **Befund (eigene Messung):** `grep -nP 'OV-1\b'` am Ledger = **GENAU DREI** Treffer:
  **Z.61** (neu; KON121-Explore-Kern: "D-04 = Kette C.1 ist die '4 bis 5 compare Komponenten',
  OV-1 nie vollzogen, V-09a-1..8 traegerlos"), Z.12433 (KON7-05-Kontext), Z.18474 ("Gegenprobe
  OV-1 = 8"). Herkunft per `git log -S 'OV-1 nie vollzogen'`: GENAU EIN Commit, **00c341a0**
  vom 22.08. **07:10:22** -- 40 Sekunden vor dem Fix-R2-Schreibzugriff (07:11) und nach der
  Audit-R2-Messung (07:08). Die "GENAU ZWEI" in audit-runde-2.md waren zum Messzeitpunkt wahr;
  dies ist echte Nach-Messdatum-Drift, kein Fehler der Vorrunde.
- **Substanz:** Auch Z.61 ist KEINE Buchung, sondern eine Status-Erwaehnung innerhalb der
  D-04-Explore-Verbuchung. Die Kernaussage "unter dem ETIKETT OV-1 hat der Ledger nie GEBUCHT"
  haelt; praezisierungsbeduerftig war nur der Schluss-Halbsatz "das Etikett lebt nur in den
  Plaenen" (seit 22.08. 07:10 steht es auch im Ledger -- als Erwaehnung, nie als Buchung).
- **fix_weg / VOLLZOGEN in Fix R3:** additive Klammer-Verlaengerung in 3.2(c) nach dem Muster
  des F3-Fixes; Original-Halbsatz im AENDERUNGS-PROTOKOLL des FIX-NACHTRAGs literal erhalten.

**Ausdruecklich NICHT als Fund gewertet (Phantom-Schutz):** die reine Zeilennummern-Drift
(+85 seit Audit R2) -- sie ist die bekannte systemische Eigenschaft, die datierten Messwerte
im Bericht bleiben korrekt, und L5 schliesst sie jetzt am Uebergabepunkt; ferner die
Lead-only-Rueckstaende selbst (S2SYN/F2-Fenster/Ledger), die #96-Buchung (Di 25.), der
F5-Mirroring-Objektstatus, der 12W-Explore aus der D-04-Antwort (Traeger #119) und alle
NICHT-GEFORDERT-Punkte der Soll-Karte.

--------------------------------------------------------------------------------
## 4b. UNABHAENGIGE BESTAETIGUNG WAEHREND DER RUNDE (neue Soll-Karte 23.08.)

Waehrend dieser Runde (14:06) wurde die soll-karte.md im Strang-Ordner durch eine
EIGENSTAENDIGE Neuerhebung ersetzt (Fassung 23.08., **524 Z.**, 41642 B; die von mir zu
Rundenbeginn voll gelesene Fassung hatte 401 Z. / 30131 B, 22.08. 06:35). Ich habe sie NICHT
geschrieben und ihren D-04-Teil nach dem Erscheinen gegengelesen. Das ist eine echte
Zweitmeinung, kein Zirkelschluss: sie entstand parallel und aus anderer Quellenlage.

- SIE BESTAETIGT A19-F5 UNABHAENGIG, literal (P-14-AKTUALITAETS-CAVE): "Sollte die
  a19-Vorlage-Zeile HEUTE noch an das F2-Fenster/den Owner uebertragen werden, wuerde sie eine
  bereits vom Owner selbst ueberholte Fragestellung erneut vorlegen." Damit steht der Fund
  doppelt belegt (meine Ledger-/Session-Messung + ihre unabhaengige Erhebung).
- SIE PRAEZISIERT ZWEI PUNKTE, die ich in den Fix uebernommen habe (Objekt: "NACHTRAG ZUM
  NACHTRAG"; Auflagen: L4-ERGAENZUNG):
  (1) PRIMAERQUELLE ist die **Owner-Nachricht vom 21.08. 20:40**; die von mir zitierte
      Ledger-Buchung KON120-02 TRANCHE 2 (22.08. frueh) ist deren Verbuchung, nicht der
      Ursprung. Mein Beleg war korrekt, aber eine Stufe zu spaet angesetzt.
  (2) Das juengste Primaerdokument ist **~/backups-workflow/20260822-explore-buendel-t2/
      d04-mathe-sprache.md** (537 Z., 22.08. 06:53). Ich habe es in dieser Runde SELBST
      geoeffnet und die zitierten Stellen eigenstaendig gehoben -- Teil B.6 literal: "Der
      21.08.-Vorschlag 'Hermite ratifizieren' ist damit durch D-04 inhaltlich ueberholt, nicht
      vollzogen", Einordnung ebd.: "Turnier-Mechanismus ueber mehrere Kurvenfamilien je
      Bereich, mit B-Spline weiterhin ausdruecklich in der erlaubten Menge". Fertige
      Ersatz-Textbausteine fuer den Lead liegen dort in Teil F/G -- deshalb empfiehlt L4 jetzt,
      F-122 durch einen Verweis auf dieses Dokument + die Owner-Nachricht zu ersetzen.
- SIE ERHEBT ZWEI NEUE SOLL-PUNKTE, die NICHT von mir gedeckt sind und hier ausdruecklich
  als ungedeckte Menge weitergereicht werden (KEINE a19-Funde, s.u.):
  **P-20** String-Serialisierungs-Nachweis fuer das Break-Even-Kurvenmodell (ihre Messung am
  heutigen ce-HEAD 3841d717: 0 Treffer to_string/from_string/serialize im heuristik/-Bestand)
  und **P-21** Vollzug der 08.08.-Konsolidierung (ihre Messung: alle drei Stacks existieren
  unveraendert nebeneinander, 0 Deprecation-/Redirect-Marker).
- WARUM DAS KEINE a19-FUNDE SIND (ihre eigene Einordnung, die ich teile): a19 sollte den
  ENTSCHEIDUNGS-Status klaeren, nicht den Code-Vollzug verifizieren; Traeger der Aktualisierung
  ist "NICHT a19 rueckwirkend, sondern der D-04-Design-Zug aus #119/D04EXPL", a19 bleibt "fuer
  seinen eigenen Umfang" LANDEREIF. Hinzu kommt: mein Fix hat die betroffene VORLAGE-ZEILE als
  Ganze entwertet -- die von P-20/P-21 beruehrten Detail-Praemissen wandern damit ohnehin
  nicht mehr an Fenster oder Owner. Ich fuehre sie in der Restliste, nicht in den Funden.

--------------------------------------------------------------------------------
## 5. RE-VERIFY DER FIX-RUNDE 3 (eigene Messung NACH dem Fix)

- Objekt: **505 Z., md5 8118bd19f953b65fdda5d9e8765ad15b** (vorher 390 Z., md5 76d4af7e;
  Vorstand als a19-volltexte-ergebnis.VORHER-fix-r3.md gesichert).
- Diff-Bilanz: **116 Zeilen neu, GENAU 1 Bestandszeile in-place ersetzt** (3.2(c)-Schlusszeile;
  Original-Wortlaut im AENDERUNGS-PROTOKOLL literal festgehalten). Fuenf Hunks (277c277,285 |
  297a306,310 | 311a325,327 | 322a339,371 | 390a440,505), alle deklariert. Nichts geloescht; Abschnitte 1, 2.x, 3.1, 3.3, 4 byte-unveraendert.
- **ASCII: 0 Nicht-ASCII-Zeichen ueber ALLE eingefuegten Zeilen** in BEIDEN Dateien
  (`diff | grep '^>' | grep -cP '[^\x00-\x7F]'` = 0/0). Die erste Fassung enthielt 12
  Gedankenstriche/Mittelpunkte; sie wurden vor Rundenabschluss auf "--"/"|" transliteriert,
  ausschliesslich auf den NEUEN Zeilen -- Bestandszeilen blieben unangetastet.
- Wirksamkeits-Proben am Leseort: `grep -c "NICHT mehr an Fenster/Owner"` = **2** (Z.170 = V8
  aus R1, Z.340 = D-04 aus R3) -- beide ueberholten VORLAGE-ZEILEN sind jetzt DORT entwertet,
  wo der Lead sie liest, nicht nur im Anhang. "ERSATZ-ZEILE" = 2 Treffer (Zeile + Verweis).
- lande-auflagen.md: 140 Z., md5 49fdc471; Struktur-Gegenzaehlung `grep -n "^## L"` = L1, L2,
  L3, L4, L5, L6 (6 Posten, keine Nummer doppelt, keine Luecke).
- Anker-Tafel gegen den Ledger nachgeprueft: Owner-Zitat **Z.31148**, NACHTRAG-Kopf **Z.31106**,
  "Gegenprobe OV-1 = 8" **Z.18474** -- exakt die in Bericht und Auflagen eingetragenen Werte.
- Read-only-/TABU-Proben nach dem Fix wiederholt: unveraendert 0 (Abschn. 3).

--------------------------------------------------------------------------------
## 6. RESTLISTE GEGEN DIE SOLL-KARTE

- P-01..P-19: alle 19 bleiben ERFUELLT. Die R3-Fixe STAERKEN P-13/P-14 (das HY-C-/OG-52-Bild
  traegt jetzt den juengsten Owner-Stand) und P-16 (neue datierte Literale mit Commit-Hashes);
  kein Punkt wird geschwaecht. P-11 ist inhaltlich bestaetigt worden: die Owner-Antwort vom
  22.08. widerlegt den a19-Befund nicht, sondern setzt ihn fort ("ERWEITERT, nicht widerrufen").
- Spannungen S-1..S-6: unveraendert; S-2 (D-04-Label-Kollision) wurde in dieser Runde aktiv
  gegengeprueft und hat sich als beherrschbar erwiesen (1:1-Zuordnung der Tranche-2-Buchstaben).
- Getragene offene Posten, alle mit Traeger: F-119 (#96, Di 25.) | F-120 (-> L1) |
  F-121 (weiter offen, Infra) | F-122 (-> L4, INHALTLICH UMGESTELLT: Kenntnisnahme statt
  Entscheid) | F-123 (owner-gated).
- NEU weitergereicht (aus der 23.08.-Soll-Karte, kein a19-Fund, Traeger D-04-Design-Zug
  #119/D04EXPL): P-20 String-Serialisierungs-Nachweis | P-21 Vollzug der 08.08.-Konsolidierung.
  Beide haengen am CODE-Bestand, nicht am Berichtstext; beide sind in L4-ERGAENZUNG benannt.
- Die Soll-Karte selbst ist waehrend der Runde von 401 auf 524 Z. gewachsen (Fassung 23.08.).
  Ihre 19 alten Punkte bleiben ERFUELLT; ihre Revisionen zu P-12/P-13/P-14/P-18 verschaerfen
  keinen a19-Fund, sondern praezisieren den Uebertrag (P-14) und den Code-Vollzug (P-13/P-18).

--------------------------------------------------------------------------------
## 7. VERDIKT

**SITZT (nach Fix)** -- Nach dieser Runde ist am Objekt kein offener Fund mehr vorhanden:
A19-F1/F2/F3 (R1) BEHOBEN und in R2 bestaetigt | A19-F4 (R2) BEHOBEN und in R3 unabhaengig
nachgemessen + nachquittiert | A19-F5/A19-F6 (R3) erhoben und in derselben Runde BEHOBEN.
6 Funde, 6 behoben, **0 VERTAGT**, 0 Regressionen. Der Strang bleibt **LANDEREIF**; die
verbleibenden Anteile sind ausnahmslos Lead-only oder Fremd-Traeger und liegen mit benanntem
Traeger und Platz in lande-auflagen.md (L1-L6).

Der wichtigste Ertrag dieser Runde ist nicht die Zahl der Funde, sondern ihre Richtung: die
beiden ueberholten Zeilen, die a19 an den OWNER weitergereicht haette (V8 in R1, D-04 in R3),
sind beide gestoppt worden, BEVOR sie das Fenster erreicht haben -- der Uebertrag stand in
beiden Faellen nachweislich noch aus. Die Recherche-Substanz des Strangs (OV-1-Chronologie,
L-B/L-D-Traeger, 20-W2-Gegenzaehlung) ist ueber drei Audit-Runden unbeschaedigt geblieben und
durch die Owner-Antwort vom 22.08. sogar bestaetigt worden.

Beide Mengen benannt (EIN-GATE-Regel): Diese Runde deckt die Quittungs-Nachmessung A19-F4, die
Fortbestandsprobe F1/F2/F3, zwei neu erhobene Funde samt Fix und RE-VERIFY, die Regressions-/
ASCII-/Read-only-/TABU-Proben sowie die Soll-Karten-Restliste am Objekt a19-volltexte-
ergebnis.md (505 Z., md5 8118bd19). Sie deckt NICHT: die Lead-only-Schreibungen selbst
(F2-Fenster-D-04-Block, S2SYN Z.210/212/255/308, Ledger/Board), den F5-Mirroring-Objektstatus
und die uebrigen KON120-05-Restposten (Traeger #84-Umfeld/Infra), die #96-Buchung (Di 25.),
den 12W-Explore aus der D-04-Owner-Antwort (Traeger #119), die uebrigen 17 Staffel-Straenge
sowie jeden Bau-/ctest-Gegenstand -- der Strang hat keinen.
