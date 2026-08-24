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
  Store 3/1). Offen NUR noch KON120-05-Restposten (Alt-PAT-Revokes, GitLab-Rotation
  OF-4-Kette, U-2-root, node6, id56/id18) + F5-Mirroring-Objektstatus. S1-F-75 damit
  ebenfalls erledigt-durch-KON120-05; F-121 bleibt OFFEN."
- Die V8-VORLAGE-ZEILE aus a19 Abschn. 2.3 NICHT mehr an F2-Fenster/Owner uebertragen
  (im Bericht per NACHTRAG entwertet). F-121 (L-D node6/id56/id18) UNVERAENDERT lassen.

## L2 (aus A19-F2, KLEIN) - Lead: F-122-Uebertrag mit robustem Anker
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
- Ebenso beim Traeger: uebrige KON120-05-Restposten (Alt-PAT-Revokes, GitLab-Rotation
  OF-4-Kette, U-2-root, node6, id56/id18) laufen dort weiter; nichts davon ist durch
  die a19-Fixes erledigt.

## Kein Lande-Anteil
- A19-F3 ist vollstaendig im Bericht behoben (Abschn. 3.2(c) ergaenzt); keine Auflage.

Beweiskette der Fix-Runde: Vorher-Stand als Kopie gesichert
(a19-volltexte-ergebnis.VORHER-fix-r1.md, md5 fade3252...), Nachher-Stand md5
c15e1fda...; Diff-Bilanz 59 Zeilen neu / 2 Bestandszeilen in-place ergaenzt;
eingefuegte Zeichen ASCII (2 weitergefuehrte Bestands-Gedankenstriche deklariert).
