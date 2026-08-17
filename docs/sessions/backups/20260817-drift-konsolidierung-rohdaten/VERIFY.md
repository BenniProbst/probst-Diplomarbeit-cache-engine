# KONSOLIDIERUNGS-VERIFY 17.08.2026 (Fable max, read-only) — gegen DOSSIER.md (KON97)

## URTEIL: TRAEGT_MIT_FIXES

Der Einbau selbst ist vollstaendig, rein additiv, duplikatfrei, breiten-konform und dossier-treu.
Zwei MUSS-Posten liegen NEBEN dem Einbau: die unerfuellte VORAB-AUFLAGE des Dossiers und ein am
Objekt bereits geheilter Befund, der als lebender Marker installiert wurde.

## PRUEFPROTOKOLL (7 Auftragspunkte)

1. **Diffs erhoben.** super (`probst-diplomarbeit-cache-engine`): GOAL +101 · WELLENPLAN +327 ·
   DESIGNPLAN +56 · zusaetzlich Submodul-Zeiger `Code/external/comdare-cache-engine`
   8fe66469→90ee6809 (einzige Loeschzeile des --stat, KEIN Dokument). Projekte:
   ARBEITSWEISE +53. Alles uncommitted.
2. **NUR ADDITIV: PASS.** `git diff -U0` je Datei: 0 geloeschte Zeilen in allen 4 Dokumenten.
3. **Dossier-Deckung: 4/4 Abschnitte eingebaut.**
   - Abschnitt 1/GOAL: Block 1.1 an Z.30-90 (aequivalent, s. KENNTNIS-2) + M-1..M-7 gesetzt
     (Z.473, 487, 520, 591, 630, 650, 732), jede an der Soll-Stelle: M-1 exakt nach dem
     Acht-Stationen-Absatz (alt Z.404-409 = neu Z.466-471), M-2 nach KON39-Marker VI.2, M-3 nach
     VI.4-Kopfabsatz, M-4 nach T-15a/b-Marker, M-5 nach checkpoint_measure-Marker, M-6 als
     Abschluss von VII.2 (vor `## VII.3`), M-7 nach der D3-4-Tabellenzeile (Tabelle intakt).
   - Abschnitt 2/WELLENPLAN §19: Z.2223-2548 BYTE-IDENTISCH zu Dossier Z.138-463 (diff leer).
   - Abschnitt 3/DESIGNPLAN §12: Z.603-657 BYTE-IDENTISCH zu Dossier Z.475-529 (diff leer).
   - Abschnitt 4/ARBEITSWEISE: 4.1 = Z.955-995 und 4.2 = Z.1211-1220 BYTE-IDENTISCH
     (Dossier Z.543-583 / Z.587-596).
   - **NICHT gedeckt: VORAB-AUFLAGE** (Karten sichern + KON97-Ledger-Buchung) → MUSS-1.
4. **Duplikat-Check: PASS.** GOAL: genau 7x `MARKER 16.08.2026 (KON97)` + 1x REFERENZ-STAND-Block;
   WELLENPLAN: genau 1x `# 19. DRIFT-KONSOLIDIERUNG`, 7x §19.1-19.7; DESIGNPLAN: genau 1x
   `## 12. NACHTRAG`, T-12a-e je 1x; ARBEITSWEISE: `B.3-NACHTRAG 16.08.2026 (KON97)` genau 2x
   (Ueberschrift + Log-Eintrag = Soll). Phrasen-Proben (15 Stationen/FLATTERN/VOLLBAU-GATE/
   REKONSTRUKTIONS-Anfrage/ZWEILANIG/Debug-Ausnahme) treffen nur Block 1.1 + M-Liste + je einen
   Marker — keine Kollision mit Alt-Markern.
5. **Teil A/V unangetastet: PASS.** Nur 2 Hunks (@-954,0 +955,42 und @-1167,0 +1210,11), beide in
   B.3 (Z.913-996) bzw. AENDERUNGSLOG (ab Z.1001); Teil A = Z.60-618, Teil V = Z.619-883 ohne
   Beruehrung. Kopf unveraendert `Fassung: v4.3`, kein Bump.
6. **Zeilenbreite: PASS.** awk ueber alle Diff-Zusatzzeilen (LC_ALL=C.UTF-8): 0 neue Zeilen >120
   Zeichen in allen 4 Dateien (auch unter Byte-Zaehlung konservativ bestanden).
7. **Anker-Stichprobe (7 statt 5):**
   - `anatomy_fingerprint.hpp:68` = `kAnatomyFingerprintPreimageMax = 4096` → KORREKT (Zeile exakt).
   - `drift_detector.hpp` RunMethodology = 0 Treffer → KORREKT (grep -c = 0).
   - M-4-Verweise Wellenplan §19.3 (C-09 Drift-Gate, C-10 Zweilanigkeit, C-01/C-02) + Designplan
     §12/T-12a → KORREKT (alle vorhanden).
   - `perm_runner.hpp:207,213` (kalte Messschleife um t0) → am Objekt plausibel/korrekt.
   - KON96 im Ledger (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:19`) → KORREKT;
     **KON97 = 0 Treffer** → MUSS-1.
   - M-7 `experiment_plan_director.hpp:1332-1333 allow_failure` → **FALSCH am heutigen Objekt** →
     MUSS-2.
   - M-6 `ceb-measurement-exclusive hart amd/prod1` → **am Objekt teilueberholt** → SOLL-1.

## FUNDLISTE

**MUSS-1 — VORAB-AUFLAGE des Dossiers unerfuellt (Karten-Sicherung + KON97-Buchung).**
Beleg: r1-r5, E1-E4, Gegenlese-/Rohkarten liegen NUR unter
`/home/comdare/.claude/jobs/5a19728e/tmp/konso/` (Job-tmp = Rotationsrisiko lt. frisch
installiertem B.3-Nachtrag); `~/backups-workflow/` hat KEIN Verzeichnis 14.-17.08.;
`grep -c KON97 docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` = 0 (KON94/KON96 vorhanden).
Alle Karten-Verweise der Nachtraege (r1 A-7, r3 C3, r4 C-1, r5 :28945/:29091, E1-E4 …) zeigen
damit auf fluechtige Pfade — exakt der im Dossier gewarnte Fall. Kein Schreiber hat den Posten
uebernommen (ARBEITSWEISE-Schreiber: explizit ausserhalb seines Auftrags). Fix: Karten nach
`~/backups-workflow/` (BU-additiv) + Ledger-Nachtrag KON97 mit persistenten Pfaden.

**MUSS-2 — M-7 (GOAL Z.732-735) installiert einen am Objekt GEHEILTEN Defekt als lebend.**
Beleg: `experiment_plan_director.hpp` hat heute (Submodul-HEAD 90ee6809 UND alter Zeiger
8fe66469) genau EINEN allow_failure-Treffer = Kommentar `:1631` „der Mess-Batch traegt KEIN
allow_failure; sein Schluss-Verdikt ist exit $FAIL". Heilung: ce `a558e87c` 09.08.2026
„fix(ci): #278 — allow_failure aus der emittierten Mess-Job-YAML raus". Erhebung r3 C3 =
Transkript 08.08. (nachmittag-11, Z23184-23193) — VOR der Heilung; der 16.08.-Marker erzeugt
eine Phantom-Task „vor W3". Fix gem. neuer B.3-Regel 4 (Erhebungsdatum → gegen heutigen HEAD
messen): Nachmess-/UEBERHOLT-Korrekturmarker an M-7, r3-C3-Task austragen (Muster W18).

**SOLL-1 — M-6 (GOAL Z.650-653) am Objekt teilueberholt; Nachmessung vor Bau des C-10-Postens.**
Beleg: weder `.gitlab-ci.yml` (live: `pmu-prod1`/`pmu-prod2` je Host, Welle E 07.08.) noch der
Generator tragen heute `ceb-measurement-exclusive`; der Generator emittiert die angeblich „nie
umgesetzte" §61-Revision `resource_group: "ceb-measure-" + host` (`:1448`, `:1615`; Kommentar
`:749/:757` nennt die globale Gruppe „Vor-§61"). Der Marker traegt den Nachmess-Auftrag („gegen
ce 0c80aa78 am Objekt nachmessen") selbst — Nachmessung fahren, Ergebnis am Marker nachtragen
(Zweilanigkeits-KERN „Intel-Lane faehrt real?" bleibt eigenstaendig zu pruefen).

**SOLL-2 — M-7-Querverweis „→ Wellenplan §19.3" loest nicht auf.**
§19.3 (C-01..C-15) enthaelt KEINEN allow_failure-Posten; die Task lebt nur im Marker + r3-Karte
(§19.4/D-18 fuehrt nur die DREI ANDEREN Stellen). Haengt an MUSS-2: wenn ueberholt, beides
austragen; sonst Posten in §19.3 nachtragen. (Der Einbau reproduziert hier das Dossier treu —
der Defekt stammt aus dem Dossier.)

**KENNTNIS-1 — Submodul-Zeiger im selben Arbeitsbaum.** `Code/external/comdare-cache-engine`
8fe66469→90ee6809 (Landung golden-fenster) ist uncommitted im super-Diff. Beim Commit der drei
plaene-Dateien NICHT mitstagen (EIN-SCHREIBER-/Staging-Area-Regel).

**KENNTNIS-2 — GOAL-Block 1.1 aequivalent, nicht byte-identisch.** (a) typografische schliessende
Anfuehrungszeichen „…“ statt Dossier-ASCII an 4 Stellen; (b) die vom Dossier-Schlussabsatz
angekuendigte M-1..M-7-Uebersichtsliste (6 Zeilen) materialisiert. Inhaltlich deckungsgleich.
Wellenplan/Designplan/ARBEITSWEISE dagegen byte-identisch.

**KENNTNIS-3 — Schreiber-Berichte konsistent mit Diff.** GOAL +101 = 62 (Block 1.1, frueherer
uncommitteter Lauf, Hunk @-29,0 +30,62) + 39 (M-1..M-7, dieser Lauf; 759→798 verifiziert);
Wellenplan +327 / Designplan +56 / ARBEITSWEISE +53 stammen komplett aus dem frueheren Lauf und
wurden von den Schreibern korrekt als vorhanden erkannt und NICHT gedoppelt. Zeilenstaende:
GOAL 798 · WELLENPLAN 2548 · DESIGNPLAN 657 (wc -l; Schreiber-„658" = Zaehlweise der leeren
Schlusszeile) · ARBEITSWEISE 1220.
