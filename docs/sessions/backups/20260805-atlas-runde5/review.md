# REVIEW RUNDE 5 (adversarial) — frag-zukunft.html gegen korpus.md + ASSEMBLY

Reviewer-Lauf 05.08.2026. Objekt: scratchpad/runde5/frag-zukunft.html (Autor-Stand) gegen
scratchpad/runde5/korpus.md; Zitat-Anker zusaetzlich direkt am LEDGER
(docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md) verifiziert; Atlas-Beispiel-Anker am
Objekt scratchpad/uml/atlas.html verifiziert.

## VERDIKT: FREIGABE (mit 2 im Review behobenen Zitat-Ankern, s. B1/B2)

## Befunde

### B1 — BEHOBEN: P3-Verbatim-Zitat war der KANON-Zeile zugeschrieben
Fragment Z.26 zitierte den Owner-Wortlaut nachmittag-3 als "LEDGER:4106". Direkt am Ledger
verifiziert: OWNER-NACHRICHT VERBATIM = LEDGER:4105, KANON = LEDGER:4106. Fix (Fragment +
Atlas): "— LEDGER:4105; Kanon (LEDGER:4106): ...". Alle uebrigen 4106-Referenzen des
Fragments (Meta, Format-Tabellen-Zeile, R7) meinen korrekt den KANON — unveraendert.

### B2 — BEHOBEN: Posten-91-Anker stale (pre-Renumbering)
Fragment Z.146 trug "persistiert als Ledger-Nachtrag LEDGER:4104-4108" — das ist der vom
Korpus selbst korrigierte ALT-Stand ("Zeilennummern nachziehen"); der Bereich 4104-4108
enthaelt heute den P3-Block. Korrekt: Nachtrag nachmittag-1, Owner-Vermerk verbatim
LEDGER:4116, NEUER POSTEN (91) = LEDGER:4119. Fix entsprechend eingesetzt.

### Nits (nicht blockierend, keine Aenderung)
- P3-Zitat laesst den Gespraechs-Auftakt "OK, aber " ohne Ellipse weg; Kleinschreibungs-
  Beginn ("es soll doch ...") signalisiert den Anschnitt, Sinn identisch.
- R5-Zitat normalisiert den Ledger-Tippfehler "Messskurven" zu "Messkurven" — exakt wie
  der Korpus (Z.72); die eckige Klammer "[Messwerte werden im Voll-Lauf ausgewertet,]"
  markiert die Paraphrase korrekt.
- p.z ist im Atlas nur unter article.k gestylt — faellt im Fragment auf Default zurueck,
  identisch zum Bestand in #kette/#klammer (kein Fehler).

## Pruefpunkte (alle BESTANDEN)

1. QUELLEN-DECKUNG: jede Diagramm-/Tabellen-/Listen-Aussage stichprobenhaft rueckwaerts
   auf korpus.md abgebildet (A.1-A.9, Phase 1-4, COMPARE, Gegenpruefungs-Block, Randnotiz)
   — kein Knoten ohne Fundstelle gefunden; die Parallel-Faecherung nach dem Zell-CSV
   (Sink / tex+Git / Lager) ist Korpus-Befund (A.4-A.9) und als solcher erklaert.
2. SOLL/IST-TRENNUNG: classDef plan (gestrichelt) = VGL, BEST, REL, WALL, MULTI, ERK, HYB,
   FMT, BLATT; classDef teil (gepunktet) = P1, CMP, ZELLE, LBW; solid NUR mit Code-Anker
   (XML, DRV, LAUF, RES, SINK, REGN, BLOG, TEX, GIT, MATH, BBS, CT, STUB). Kein PLAN als
   IST verkauft; Status-Legende + Tabellen-Status-Spalte konsistent (IST/TEIL, TEIL, TEIL,
   PLAN, TEIL, TEIL/PLAN).
3. OWNER-WORTLAUT-TREUE: "Release ... OHNE Mess-Einrichtungen" (REL-Knoten + Tabelle Z.3),
   "Wallclock-NACHMESSUNG" (WALL + UNGEDECKT 3), "LAST-ERKENNUNGSHEURISTIK" /
   "ERKENNUNGSHEURISTIK DER LAST" (ERK + Tabelle Z.4), "aktive RUNTIME-Auswahl der
   optimalen Tier-Binaries" (HYB + Tabelle Z.4). R5-Blockquote verbatim gegen LEDGER:4116
   geprueft — treu (s. Nits).
4. XLSX-DOKTRIN: EIN GoF-Strategy-Weichen-Knoten (CSV XOR xlsx, xlsx=DEFAULT markiert,
   Doppel-Schreibung=Regression, KEINE CoR) — P3-konform; IST ehrlich: nur Namens-Grammatik
   lager_pfad_grammatik.hpp:525-538 (+ L5-Ownership), Serialisierer FEHLT (Paket 46b),
   CSV=Factory-Fallback, kein eigener Ledger-Haupttext-Paragraph (Quelle Owner-KERN 26.07.)
   — deckungsgleich Korpus A.9; CoR-Fundstelle LEDGER:829 korrekt der Auswertungs-
   Filterkette zugeordnet.
5. UNGEDECKT: die 5 Gegenpruefungs-Punkte des Korpus stehen 1:1 als eigenes Register
   (rote Badges), zusaetzlich Badges direkt an FMT (XML-Wahl-Ort), VGL (kein EIN benannter
   Codepfad), ERK (0 Code-Treffer).
6. HINWEIS-REGELN: sichtbar als "Entwurf / Posten 91" + "ENTWURF, Owner-Abnahme offen";
   R1-R8 + N1-N6 Beispiele gegen den Atlas verifiziert (in_memory_measurement_buffer:416,
   telemetry Planungs-Stand:582, measurement_tooling:527, Ablaufmethodik W2-B:528,
   IPruefDock keine ABI-Grenze:425, T17 persistence_target:625, extension_hardware/
   external_utils:570ff, ExperimentSubtreePayload Band-C:400, progress.cursor-Hinweis in
   #kette). Korpus-Regel-Kandidaten (i)-(iv) sind in R4/N3/R8/N5 abgedeckt.
7. MERMAID/HTML: Quote-Paritaet je Zeile OK, 26/26 Knoten-Klammern, '#' nur in der
   classDef-Farbe (Bestands-Muster), Semikolons nur als Teil von HTML-Entities
   (&lt;/&gt;-Falle wie im Bestand, z.B. perm_&lt;id&gt;.so in #kette); Tag-Balancen
   section/div/table/ul/blockquote OK; scoped CSS #zukunft inkl. dark-Overrides
   (data-theme + prefers-color-scheme) nach #kette/#klammer-Muster; .pl/.ow eigen
   gescoped (Bestand ist #klammer-gescoped — noetig und korrekt).

## ASSEMBLY (vollzogen)

- Sektion (Fragment ohne Integrations-Kommentar, 165 Zeilen) eingehaengt NACH dem
  #klammer-</section> -> atlas.html Zeile 651 = <section class="subsys" id="zukunft">.
- Nav-Zeile '<a class="e" href="#zukunft"><span>Zukunfts-Phasen (SOLL)</span></a>'
  direkt nach der #klammer-Nav-Zeile (jetzt Zeile 73).
- Filter-JS-Vertraeglichkeit: #zukunft verhaelt sich beim Filtern wie #kette/#klammer
  (keine article.k-Karten -> beim Filtern ausgeblendet), kein Bruch.
- Backup des Vor-Stands: scratchpad/uml/atlas.html.pre-zukunft.bak

## SANITY LITERAL (atlas.html nach Assembly, 9966 Zeilen)

- Karten (<article class="k">): 1918  [SOLL 1918 — OK]
- <article>/<\/article>: 1918/1918 -> Balance 0  [OK]
- <section>/<\/section>: 38/38 -> Balance 0  [OK]
- id="zukunft": 1x · id="klammer": 1x · id="kette": 1x · id="uebersicht": 1x  [OK]
- Mermaid-Bloecke: 78 (76 Bestand + 2 neu); Koepfe valide: 71x classDiagram +
  4x flowchart LR + 2x flowchart TB + 1x flowchart TD  [OK]
