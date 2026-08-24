# LANDE-AUFLAGEN — Strang "vorlagenfenster" (A2.5-Fix Runde 1, 22.08.2026)

Quelle: Audit-Funde V1-01 [MILD] + V1-02 [KLEIN] (audit-runde-1.md); Fix-Commit liegt.
Autor: Fable-max-FIX-STUFE A2.5 Runde 1. Adressat: Lead / W2-Lande-Zug.

## L-1 [PFLICHT] Fix-Branch in den W2-Lande-Zug aufnehmen

super-Branch `fix/vorlagenfenster-r1` @ a6fa04dae76777ece26d335c95eee2e031facf22
(Basis 5b5a818f = development-Stand 22.08.; origin ci.skip-gesichert, ls-remote bestaetigt).
Inhalt: NUR docs/sessions/ (2 Dateien, 10+/10-):
- 20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md: Z.17 "D-01..D-12 (D-12 nachgetragen
  8aae5cd2))" + Z.86 "DIESE 12 Deltas" + D-11-Block VOR D-12-Block getauscht (byte-treu
  verschoben, jetzt numerisch aufsteigend Z.65/Z.71).
- 20260821-F2-FREEZE-CHECK-PROTOKOLL.md: Z.79 "(12 Deltas" + Z.80 "D-01..D-12 aus der
  W1L-BAULISTE" + Z.107 (KON120-ENTWURF-Zitat) "+ 12 Deltas".
Merge nach Doktrin (nie rebase; harmonisieren statt verdraengen — die 2 Dateien waren seit
8aae5cd2 unberuehrt, Konfliktrisiko minimal). Die R6-Owner-Vorlage soll dem Owner in der
korrigierten Fassung vorgelegt werden. Worktree /home/comdare/wt-super-vorlagenfix bleibt
stehen bis gruen+gemergt (Doktrin); Loeschung = separater Schritt nach Landung.

## L-2 [PFLICHT] KON120-Ledger-Zug traegt die ZWOELF

Beim KON120-Ledger-Zug MUSS der Ledger-Text "12 Deltas" tragen. Der KON120-ENTWURF im
FREEZE-CHECK-PROTOKOLL (Z.103-107) ist durch a6fa04da korrigiert, aber: Entwurf NICHT
woertlich uebernehmen — beim Buchen gegen das Objekt zaehlen
(grep -c '^### D-' 20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md == 12).
Ledger-Schreiben ist Lead-only; A2.5 hat den Ledger NICHT beruehrt (Gegenstand nur die
2 Session-Dateien).

## L-3 [HINWEIS, getragener LEAD-Posten — KEIN Fund dieses Strangs]

F-122-Rest (S2-SYNTHESE Z.212 + O-F Z.253-255; Audit Abschnitt 4): die D-04-PRAEMISSEN-
ERGAENZUNG (OV-1-Sachfrage seit 08.08. beantwortet "fuehre beide zusammen"; erbeten nur die
ENGE Ratifikation Hermite vs. B-Spline-Basis; Wortlaut a19 Abschn. 3.4) bietet sich als
Beifang am D-04-Block (FINAL-konsolidiert Z.35-38) im naechsten docs-/KON120-Zug an.
NICHT von A2.5 vollzogen: inhaltlicher Lead-Entscheid ausserhalb der Fund-Liste V1-01/V1-02
(Zurechnung laut Audit: S2-Synthese lag ~9 h NACH dem D-12-Nachtrag — kein Versaeumnis des
auditierten Objekts).

## GATE-ABGRENZUNG (beide Mengen)

GEDECKT durch a6fa04da: die 4 Zaehler-Stellen + die D-11/D-12-Reihenfolge in den 2
committeten Lead-Dateien (Branch-Stand, origin-gesichert).
NICHT GEDECKT: Landung des Branches auf development (L-1) · KON120-Ledger-Buchung (L-2) ·
F-122-Rest-Uebertrag (L-3) · alle uebrigen im Audit gelisteten getragenen offenen Posten
(F-71..F-77, F-123 — Owner-/Lead-getragen, erwarteter R6-Endzustand).

--------------------------------------------------------------------------------
## NACHTRAG 23.08.2026 (A2.5 Runde 1, Wiederanlauf — additiv; Stand oben NICHT geloescht)

### L-1 [UEBERHOLT — ERSETZT durch Harmonisierungs-Auflage KON120-07/Zwischendoku §3.3]

Die Fassung "Fix-Branch in den W2-Lande-Zug aufnehmen / Merge nach Doktrin,
Konfliktrisiko minimal" ist SACHLICH UEBERHOLT: dev-Commit
8ed8b268efdbac08a5c99f3e681e9fc7dc113b44 (22.08. 06:53:59, Lead-Fix VF-A1/VF-A2)
hat dieselben Fund-Gegenstaende DIREKT auf development geheilt (Zaehler 11->12 an
allen Stellen; V1-02 per Ordnungsnotiz vor D-12 = Audit-Option B, Reihenfolge
bleibt dort historisch). Eigene Messung 23.08. am dev-Tip 38428099: Null-Gegenprobe
"11 Deltas|D-01..D-11" = 0/0 in beiden Dateien; einziger Beruehrer der 2 Dateien
seit Fix-Basis 5b5a818f ist 8ed8b268 (git log literal). Beide Fassungen aendern
DIESELBEN Zeilenbereiche UNTERSCHIEDLICH (Branch: Block-Tausch + knapper Z.17-
Vermerk; dev: Ordnungsnotiz + laengere Formulierungen + Zeilenumbrueche) — ein
einfacher Merge des Branches waere jetzt konflikttraechtig und wuerde die wirksame
Lead-Fassung verdraengen oder doppeln. ES GILT die vom Lead bereits gesetzte und
im Ledger GEBUCHTE Auflage (KON120-07 Punkt 1, dev-Ledger Z.91-93; Zwischendoku
20260822-SESSION-zwischendoku-vollpruefung-...md §3.3 literal): "Beim Lande-Zug
beide Fassungen HARMONISIEREN (gleicher Gegenstand -> Lead-Fassung fuehrt;
Fix-Branch-Mehrwerte uebernehmen, nichts doppelt einbauen)". Einziger potenzieller
Branch-Mehrwert: die numerisch aufsteigende D-01..D-12-Blockfolge (byte-treuer
Tausch) gegenueber der dev-seitigen Deklarations-Loesung — Uebernahme = reiner
Lead-Geschmacks-Entscheid, KEIN offener Defekt auf beiden Seiten. Branch +
Worktree NICHT loeschen: Zwischendoku §7 fuehrt wt-super-vorlagenfix unter "ALLE
bleiben bis zur S1+S2-Landung" (Disposition nach Harmonisierung = Lead).

### L-2 [PFLICHT — Substanz UNVERAENDERT; Nummern-Update]

Die KON-Nummern-Annahme "KON120" ist ueberholt: KON120 ist durch die
Owner-Antworten-Tranchen vergeben (dev-Ledger-Kopf). Eigene Messung 23.08.: der
Freeze-Check-Eintrag ist am dev-Ledger WEITER NICHT gebucht (grep-Treffer nur
Alt-KON94 Z.2447 "Full-Join 12 Deltas", anderes Thema, + Planungstext Z.7401f).
Beim kuenftigen Buchungszug (KON121+) MUSS der Ledger-Text "12 Deltas" tragen;
Entwurf (FREEZE Z.105-108 in der dev-Fassung) NICHT woertlich uebernehmen —
gegen das Objekt zaehlen: grep -c '^### D-'
docs/sessions/20260821-F2-VORLAGEN-FENSTER-FINAL-konsolidiert.md == 12.

### L-3 [UNVERAENDERT getragen] — F-122-Beifang an D-04, Lead-Posten.

### GATE-ABGRENZUNG NEU (beide Mengen, Stand 23.08.)

GEDECKT: Fund-Zustand V1-01/V1-02 sowohl am Branch-Stand a6fa04da als auch am
development-Tip 38428099 (je eigene Messungen; dev wirksam via 8ed8b268).
NICHT GEDECKT (Traeger benannt): Harmonisierung Branch<->dev im S1+S2-Lande-Zug
(Lead, KON120-07) · Freeze-Check-Ledger-Buchung mit der ZWOELF unter KON121+
(Lead) · F-122-Uebertrag an D-04 (Lead) · D-12-INHALTS-Posten (Dock-Zahl SECHS
doppelt owner-gesetzt, FINAL-D-12-OFFEN-Fuehrung stale — dev-Ledger Z.173-174;
Lead/Owner) · getragene Posten F-71..F-77/F-123 (Owner/Lead).
