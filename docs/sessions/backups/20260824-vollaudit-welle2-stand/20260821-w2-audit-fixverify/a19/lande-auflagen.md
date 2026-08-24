# LANDE-AUFLAGEN Strang a19 (A2.5-Fix Runde 1, 22.08.2026)

Quelle: Audit R1 (audit-runde-1.md, Funde A19-F1/F2/F3) + Fix R1 (fix-runde-1.md).
Objekt-Fixes sind VOLLZOGEN (a19-volltexte-ergebnis.md, A2.5-FIX-NACHTRAG-Abschnitt).
Diese Datei traegt NUR die Anteile, die Lead-only sind (Ledger/Synthese/F2-Fenster-
Schreibungen) oder an einen anderen Traeger gehen. Alle Belege unten in dieser
Fix-Runde eigenstaendig gehoben (Ledger 22.08. = 32272 Zeilen, wc -l literal).

## L1 (aus A19-F1, MILD) - Lead: S2SYN-F-120 als ERLEDIGT-durch-KON120-05 quittieren
- SACHSTAND: V8 prod1 VOLLZOGEN per KON120-05 (Ledger-Kopf Z.63-70; ASCII-Teilliterale:
  "Store 3 tote github-Zeilen -> 1 neue" / "Lese-Beweis ls-remote HEAD e114cabd RC=0" /
  "Schreib-Beweis probe/k166-20260822-prod1 gepusht+belegt+entfernt (Gegenprobe 0)" /
  "374 GitHub-Spiegel prod1 wieder zweiseitig"). Eigene blinde Gegenprobe 22.08.
  (nur Zaehlung, kein Inhalt): ~/.git-credentials lines_total=3, github_lines=1, RC=0
  (Berichts-Messung 20.08.: 5/3) = S1-Soll-Bild des Handouts.
- BETROFFENE Lead-only-Stellen in STAFFEL2-SYNTHESE.md (22.08. frueh, Zeilen per grep -n):
  Z.210 (F-120-Zeile, Status "OFFEN -- OWNER"), Z.219 (Owner-Flaechen-Liste nennt F-120),
  Z.221 ("F-120 = F-75-Verschaerfung" -> S1-F-75 haengt mit), Z.257 (Kurzliste [F-120]).
- ENTWURFS-ZEILE (Lead uebernimmt/inkorporiert im Lande-/KON-Zug):
  "F-120 ERLEDIGT-durch-KON120-05 (22.08. frueh): V8 prod1 vollzogen (Store 3 tote
  github-Zeilen -> 1 neue; Lese-/Schreib-Beweis im Ledger-Kopf; Objekt-Gegenprobe
  Store 3/1). Offen NUR noch KON120-05-Restposten (#197-Laptop-De-Embed, Alt-PAT-Revokes, GitLab-Rotation
  OF-4-Kette, U-2-root, node6, id56/id18) + F5-Mirroring-Objektstatus. S1-F-75 damit
  ebenfalls erledigt-durch-KON120-05; F-121 bleibt OFFEN."
- Die V8-VORLAGE-ZEILE aus a19 Abschn. 2.3 NICHT mehr an F2-Fenster/Owner uebertragen
  (im Bericht per NACHTRAG entwertet). F-121 (L-D node6/id56/id18) UNVERAENDERT lassen.

## L2 (aus A19-F2, KLEIN) - Lead: F-122-Uebertrag mit robustem Anker
> **UEBERHOLT DURCH L4 (23.08., Fund A19-F5): der F-122-Uebertrag in seiner bisherigen Form
> DARF NICHT MEHR STATTFINDEN -- D-04 ist owner-beantwortet. L2 gilt nur noch fuer den
> Anker-Mechanismus (Zitat statt Zeilennummer), nicht mehr fuer den Inhalt der Vorlage.**
- Die D-04-Praemissen-VORLAGE-ZEILE (a19 Abschn. 3.4) traegt jetzt den robusten Anker:
  "Ledger, NACHTRAG 08.08. 'EXPERIMENT-B+-BAUM', Zitat 'Wir brauchen nur eine
  konsolidierte Implementierung'; 22.08.: Z.31033". Beim Uebertrag ins F2-Fenster
  DIESEN Wortlaut verwenden, nicht die alte Nummer.
- CAVE: STAFFEL2-SYNTHESE.md Z.212 (F-122-Zeile) zitiert in der Quellen-Spalte noch
  "Ledger Z.30971" - stale (heute Z.31033; Delta +62 durch KON120-Kopf-Einschub;
  eigene grep-n-Messung dieser Runde: 30929->30991, 30971->31033, 12272->12334).
  Lead aktualisiert beim Uebertrag bzw. quittiert mit datierter Nummer.
- MERKSATZ (systemisch, kein Strang-Fehler): Der Ledger waechst am Kopf; JEDE
  Zeilennummern-Referenz unterhalb des Kopfes altert je KON-Zug. Stabiler Anker =
  Zitat + Abschnittsname; Zeilennummern nur datiert angeben.

## L3 (aus A19-F1, Restpruefung) - Traeger #84-Umfeld/Infra: F5-Mirroring-Objektstatus
- KON89: F5-Mirroring (GitLab-Push-Mirroring 288/286(+289) mit neuem Token) gehoert
  NACH der V8-Rotation; V8 ist jetzt vollzogen -> der F5-Objektstatus ist AM OBJEKT zu
  pruefen (weder Audit noch Fix-Runde haben ihn gemessen; explizit ungedeckte Menge).
- Ebenso beim Traeger: uebrige KON120-05-Restposten (#197-Laptop-De-Embed, Alt-PAT-Revokes, GitLab-Rotation
  OF-4-Kette, U-2-root, node6, id56/id18) laufen dort weiter; nichts davon ist durch
  die a19-Fixes erledigt.

## Kein Lande-Anteil
- A19-F3 ist vollstaendig im Bericht behoben (Abschn. 3.2(c) ergaenzt); keine Auflage.

Beweiskette der Fix-Runde: Vorher-Stand als Kopie gesichert
(a19-volltexte-ergebnis.VORHER-fix-r1.md, md5 fade3252...), Nachher-Stand md5
c15e1fda...; Diff-Bilanz 59 Zeilen neu / 2 Bestandszeilen in-place ergaenzt;
eingefuegte Zeichen ASCII (2 weitergefuehrte Bestands-Gedankenstriche deklariert).

## NACHTRAG Fix-Runde 2 (22.08.2026, aus Audit R2, Fund A19-F4 KLEIN)
- Die KON120-05-Restposten-Listen oben wurden an BEIDEN Stellen (L1-ENTWURFS-ZEILE
  Z.22 + L3 Z.45) um den ersten Ledger-Posten "#197-Laptop-De-Embed" vervollstaendigt
  -- der Ledger (22.08., 32302 Z.; KON120-05 heute Z.93-100, Klammer Z.99-100) fuehrt
  SECHS Posten, die bisherige Liste nur fuenf. Fruehere Fassung gesichert als
  lande-auflagen.VORHER-fix-r2.md (Audit-Ordner). Lead uebernimmt die ENTWURFS-ZEILE
  in der vervollstaendigten Fassung.

## NACHTRAG Fix-Runde 3 (23.08.2026, aus Audit R3, Funde A19-F5 MILD + A19-F6 KLEIN)

## L4 (aus A19-F5, MILD) - Lead: D-04 ist BEANTWORTET; Uebertrag umstellen, Fenster nachziehen
- SACHSTAND (eigener Beleg dieser Runde): Ledger KON120-02 TRANCHE 2 (Commit 657003bb,
  22.08. 06:32:44; heute Z.137-140) literal: 'D-04 "mathematisches Definitions-Bereich
  Command pattern" VOLLES GO ALLE Familien (Hermite/Splines/B-Splines/Linien/
  quadratisch<=3/Log/Wurzel; Entropie-Filter 1, Fehlerrate-Filter 2; eigene Matlab-aehnliche
  Definitions-Sprache, Lager-Ablage; 12W-Explore + "Komponente 1 bis 4" suchen)'.
  Owner-Wortlaut: docs/sessions/20260822-SESSION-owner-antworten-tranche-1-2-zuordnung-und-
  vollzug.md Z.102-113 ("Volles GO fuer ALLE diese Felder ..."; "Die enge Hermite-Ratifikation
  aus D-04-alt ist damit ERWEITERT, nicht widerrufen: Hermite bleibt EINE der erlaubten
  Familien."). Praezisierung KON121 (Commit 00c341a0, 22.08. 07:10:22; heute Z.62-64): "der
  21.08.-Hermite-Ratifikationsvorschlag ist durch D-04 UEBERHOLT (nicht vollzogen)".
  Die Owner-Tranche-2-Buchstaben decken sich 1:1 mit den F2-Fenster-Deltas (Gegenprobe dieser
  Runde: D-02 Rename, D-05 G-1-Restfragen, D-06 SCHEMA-Bein, D-07 cp/ce-Klammerform,
  D-10 OV-16+OV-17 - jeweils derselbe Gegenstand) -> es ist dasselbe D-04, keine der von der
  Soll-Karte (S-2) gewarnten Label-Kollisionen.
- FOLGE 1 (Uebertrag): Die a19-VORLAGE-ZEILE aus Abschn. 3.4 NICHT mehr als Entscheid-Vorlage
  ins F2-Fenster tragen. Im Bericht steht jetzt eine ERSATZ-ZEILE (Kenntnisnahme statt
  Entscheid) - nur diese uebernehmen. Ihr Kern: D-04 gehoert aus dem Entscheid-Teil in die
  ENTSCHIEDEN-Tabelle E-1..E-10 des Fensters; der a19-Befund (Sachfrage schon 08.08. 09:44
  beantwortet, Etikett OV-1 7h spaeter, Owner nie erreicht) bleibt als historische
  Kenntnisnahme wertvoll, ist aber keine Frage mehr.
- FOLGE 2 (Fenster nachziehen, Lead-only): docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-
  konsolidiert.md fuehrt D-04 in Z.36-39 weiterhin als "[ENTSCHEID, EIN Satz] ... EIN Entscheid
  erbeten" (eigene Messung 23.08., Datei-mtime 22.08. 06:44). Genau dafuer hat das Fenster die
  ENTSCHIEDEN-Tabelle ("E-1..E-10 verhindert Bereits-Entschiedenes (A2.3a)", Z.90). Sonst
  wuerde dem Owner eine bereits erteilte Freigabe erneut vorgelegt.
- FOLGE 3 (S2SYN, Lead-only): Z.212 (F-122-Zeile) traegt als Lead-Aktion "Praemissen-Hinweis-
  VORLAGE an D-04 uebertragen (Wortlaut a19 3.4)"; Z.255 und Z.308 fuehren dieselbe Erwartung
  ("Lead traegt an das F2-Fenster [F-122]" / "Break-Even-/HY-C-Kette nach D-04-Ratifikation").
  Alle drei auf den neuen Stand ziehen: die Ratifikation ist erteilt und GEWEITET; HY-C bleibt
  W4, aber nicht mehr "nach D-04-Ratifikation", sondern nach dem 12W-Explore + Bau-Design
  (Owner-Auflage aus derselben Antwort: "12W-Explore ueber alle Aspekte PFLICHT").
- ANMERKUNG ZUR HERKUNFT (kein Vorwurf, nur Beweislage): Der D-04-Beleg lag in DERSELBEN
  Commit-Ladung wie KON120-05 (657003bb), also schon vor Audit R1 / Fix R1 / Audit R2. Die
  drei Runden haben KON120-05 gehoben und KON120-02 nicht - der Fund ist nachgezogen, nicht neu.

## L5 (STEHENDE AUFLAGE, terminiert die Drift-Schleife)
- Der Ledger waechst am Kopf; a19 hat in drei Runden dreimal Anker-Drift gesehen (+62, +30,
  +85; heute 32387 Zeilen). Statt weiterer Audit-Runden gilt: VOR dem tatsaechlichen Uebertrag
  einer a19-Zeile ins F2-Fenster / an den Owner den Ledger-KOPF frisch gegen den Gegenstand
  pruefen (D-04, OV-1, V8/KON120-05-Restposten) und die Zeilennummer neu datieren.
- Frische Anker-Tafel 23.08. (Ledger 32387 Z.): Owner-Zitat "nur eine konsolidierte
  Implementierung" = Z.31148 | NACHTRAG-Kopf "EXPERIMENT-B+-BAUM" = Z.31106 | KON7-05-Kontext
  "##57, OV-1/OV-6, HY-C" = Z.12433 | "Gegenprobe OV-1 = 8" = Z.18474 | KON120-05 = Z.159-166 |
  KON120-02 TRANCHE 2 (D-04-GO) = Z.137-140 | KON121-D-04-Praezisierung = Z.62-64.

## L6 (aus A19-F6, KLEIN) - kein Lead-Anteil
- Der dritte OV-1-Treffer (Ledger Z.61, KON121) ist im Bericht 3.2(c) additiv nachgetragen;
  keine Buchung, daher keine Auflage. Nur zur Kenntnis, falls jemand die Zaehlung nachfaehrt.

Beweiskette Fix-Runde 3: Vorher-Staende gesichert als a19-volltexte-ergebnis.VORHER-fix-r3.md
(390 Z., md5 76d4af7e) und lande-auflagen.VORHER-fix-r3.md (63 Z., md5 04c8e98e); Nachher-Staende
mit Zeilen-/md5-Bilanz in audit-runde-3.md. Alle eingefuegten Zeichen ASCII.

## L4-ERGAENZUNG (23.08. nachmittags, aus der neuen Soll-Karte-Fassung 23.08. + eigener Gegenlese)
- PRIMAERQUELLE praezisiert: Der Owner-Entscheid stammt aus der Nachricht vom 21.08. 20:40;
  die von L4 zitierte Ledger-Buchung KON120-02 TRANCHE 2 (22.08. frueh) ist deren Verbuchung.
  Beim Uebertrag die PRIMAERQUELLE nennen, nicht nur die Buchung.
- FERTIGE ERSATZ-TEXTE liegen bereits: ~/backups-workflow/20260822-explore-buendel-t2/
  d04-mathe-sprache.md (537 Z., 22.08. 06:53; in dieser Runde selbst gegengelesen), Teil F/G.
  Teil B.6 literal: "Der 21.08.-Vorschlag 'Hermite ratifizieren' ist damit durch D-04
  inhaltlich ueberholt, nicht vollzogen"; Einordnung ebd.: "Turnier-Mechanismus ueber mehrere
  Kurvenfamilien je Bereich, mit B-Spline weiterhin ausdruecklich in der erlaubten Menge".
  EMPFEHLUNG (deckungsgleich mit der neuen Soll-Karte): F-122 NICHT wie geplant ausfuehren,
  sondern durch einen Verweis auf dieses Dokument + die Owner-Nachricht 21.08. 20:40 ersetzen.
- TRAEGER-KLARSTELLUNG: Die Aktualisierung liegt beim D-04-Design-Zug (#119-Buendel), NICHT
  rueckwirkend bei a19. a19 bleibt fuer seinen eigenen Umfang LANDEREIF; diese Auflagen
  regeln nur, was mit seinen Zeilen beim Uebertrag geschieht.
- ZWEI NEUE SOLL-PUNKTE der 23.08.-Karte (P-20 String-Serialisierungs-Nachweis, P-21 Vollzug
  der 08.08.-Konsolidierung) haengen am CODE-Bestand und waren nicht a19s Auftrag; sie laufen
  beim selben Traeger weiter und sind hier nur als ungedeckte Menge benannt.
