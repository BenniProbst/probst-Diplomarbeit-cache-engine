# SOLL-KARTE -- Aufgabe #89 (P-H Paper->Prueflinge), Strang p-h-89

Erhoben: 23.08.2026 (Sonnet-max Planungs-Erheber, S2-Aufgabe "ph89"). NUR LESEN, kein Fix.
Objekt (zur Einordnung, nicht selbst verifiziert): ce Branch `bau/ph89` @ `2809e4d4`
(Basis ce `66de5c09` / super `a7e8e151` / prt-art `777fff7`).

## QUELLEN-VERZEICHNIS (mit Ankern)

- AUFTRAG: `20260820-welle2-audit/W2-ABFOLGE-DESIGN.md` -- D-4-Block Z.317-325, TEIL3-Regeln
  Z.790-796, Lande-Reihenfolge Z.817-824, Gegenzaehlung Z.841/844, TEIL5 Punkt 3 Z.867-868.
- LEAD-ENTSCHEIDE: `20260820-welle2-audit/LEAD-ENTSCHEIDE-zum-w2-design.md` -- VOLL gelesen
  (87 Z.), Punkt 3 (Z.7-9) + EISERNE-REGEL-KLARSTELLUNG (Z.24-27).
- K4 (Begleitkarte zum Auftrag, gleicher Ordner): `20260820-welle2-audit/karte-plaene-designs.md`
  -- Z.111 (M14), Z.121 (I-5), Z.152-164 (2f Bau-Slots-Skizze), Z.278-283 (TEIL5 #89-Gegenprobe).
- Wellenplan v2: `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-...md` -- Z.1526 (Alt-#44),
  Z.1841/Z.3022 (W7-Liste Alt-#44), Z.2300-2322 (par.18.8 NEU-Zeile Paper-XML), Z.2497-2516
  (par.19.4 Korb D, D-09), Z.2670-2681 (Abgrenzung/Owner-GO 08.08.), Z.2743-2755 (par.20.5
  P-H-Ursprung), Z.2771-2786 (par.20.8 Task-Anlage #89), Z.2541-2544 (D-20 Prozess-Register).
  Par.21-23 (Z.2876-3627) VOLL nach "#89"/"P-H"/"Paper" durchsucht: KEIN Treffer, KEINE
  juengere Ueberschreibung von D-4/par.20.5 gefunden (siehe SPANNUNGEN, Punkt 6).
- Designplan-tdd: `docs/plaene/20260808-DESIGNPLAN-tdd-...md` -- par.3 TDD-Vertrag Z.63-76
  (T-1..T-9 woertlich), Z.645-649 (T-11b/T-11c), kein eigener Katalog-Posten fuer #89/P-H
  (Aufgabe ist juenger als der Designplan-Katalog vom 08./16.08.).
- GOAL v8: `docs/plaene/20260808-GOAL-V8-DOSSIER-...md` -- II.3 V1 Z.276 (Belege sind kein
  Beweis), II.7 Fail-closed Z.305-308, VI.3 Metaprogrammierung Z.508-512, allow_failure-Verbot
  Z.763.
- Ledger (KON119ff, Ankerregel V-14 = Abschnitts-Ueberschrift statt Zeile, Zeilen driften):
  KON112-08 (R-1), KON112-09 (R-2), KON112-10 (Frage3/R-4/R-5), KON112-03 (R-3/L1-L6),
  KON110-05 (R-3/R-4/R-5 Kurzform), KON110-06 (P-H-Traeger-Zeile), KON107-02 (F1
  PV-4-Details), KON105-03 (E-3 PV-4-Ruecksprache-Termin, Owner-GO-Anker Ledger:29396),
  KON30-02 (Owner-Verbatim "Pruefling-Test-Konzept" = D-09-Ursprung), KON113-03 (Board-#89
  angelegt, Nummern-Namensraum-Hinweis), KON120-07 (Board-#122 "ph89 A-1"-Kleinfund),
  KON121 (22.08., juengste Owner-Restfragen-Runde -- OHNE #89-Bezug, siehe SPANNUNGEN 4).
- Strang-Ergebnis (voll gelesen, 241 Z.): `20260820-w2-sofortstaffel/p-h-89-ergebnis.md`.
- FINDINGS-Bestand (voll gelesen): `20260820-w2-sofortstaffel/STAFFEL1-SYNTHESE.md` (285 Z.,
  F-01..F-77 -- 0 Treffer fuer ph89/#89/P-H, s. Gegenprobe unten) + `20260820-w2-sofortstaffel/
  STAFFEL2-SYNTHESE.md` (325 Z., F-78..F-123 + H-9..H-18 + Lande-Reihenfolge Abschn. 2.2) --
  Z.19 (Status-Tafel-Zeile 1), Z.47-99 (H-9..H-18 Harmonisierungs-Flaechen), Z.107-130
  (Lande-Reihenfolge Phase 1 Schritte 6-10), Z.168-174 (F-78..F-84 Fund-Tafel), Z.215-222
  (Findings-Bilanz), Z.296/312-313 (Staffel-3-Input-Traeger). Diese Synthese ist eine
  LEAD-NAHE QUERPRUEFUNG ueber alle 9 Staffel-2-Straenge, KEINE SOLL-Quelle im engeren Sinn
  (sie stellt keine Forderungen auf) -- sie dient hier als ZUSAETZLICHE, von der Erhebung
  UNABHAENGIGE Gegenprobe auf das, was der Strang-Bericht behauptet, plus als Quelle fuer
  Lande-Abhaengigkeiten, die der Strang-Bericht selbst nicht kennen konnte (geschrieben VOR
  der Staffel-weiten Synthese). Siehe eigener Abschnitt FINDINGS-BESTAND-KREUZPROBE am Ende.

---

## PRUEFLISTE

Format je Punkt: **WAS** (woertlich + Quelle) -- **WIE pruefbar** -- **Bericht behauptet**.

### P-01 -- CT-Registry 33/33 (P01..P33), luecken-los
**WAS:** "ALLE 33 Paper werden FOERMLICH Prueflinge (abstrakt/voll)" (Ledger KON112-08 R-1a);
Traeger-Zeile "P-H PAPER-PRUEFLINGS-UEBERSETZUNG: 33 Paper -> Prueflinge (R-1) ..." (Ledger
KON110-06); W2-ABFOLGE-DESIGN D-4 (Z.317): "P-H Paper->Prueflinge-Uebersetzung".
**WIE pruefbar:** Datei `libs/cache_engine/profile_facade/paper_pruefling_registry.hpp`
existiert; `ls libs/cache_engine/algorithm_profiles/sota/*.profile.xml | wc -l` == 33 als
FREMDER Nenner (T-3-Pflicht); Registry deckt P01..P33 ohne Luecke, ohne Dublette.
**Bericht behauptet:** JA -- TEIL 3: "CT-Registry 33 Paper->Pruefling ({paper_ref,profil_id,
pruefling_typ}, P01..P33 lueckenlos, consteval-Wachen: 33er-Zahl, P-Raum-Vollstaendigkeit,
profil_id-Dubletten, Typ-Enum, L6-Anker P08/P09/P33 abstrakt)"; TEIL 1.3 Gegenprobe `ls | wc -l
= 33`; Test T-A (TEIL 3/4, "Registry<->Bestand beide Richtungen, Nenner fremd").

### P-02 -- CT-ERROR-Pflicht / consteval-Wachen (kein Runtime-Fallback)
**WAS:** "(e) CT-ERROR-Pflicht = Anwendung des GEBAUTEN Musters (Concepts/static_asserts,
A13-M3-Wache)" (Ledger KON112-08 R-1e). Doktrinaer gedeckt durch GOAL v8 VI.3
Metaprogrammierung (Z.508-512): "Compile-Time-Dispatch statt Laufzeit-`switch` ... CRTP +
Concept-Guard ... zero-cost ... kein `std::variant` ueber statische Achsen".
**WIE pruefbar:** Quelltext-Scan auf `consteval`/`static_assert`/Concepts in
`paper_pruefling_registry.hpp`; Mutationsprobe (T-11c) muss am Compile brechen, nicht zur
Laufzeit.
**Bericht behauptet:** JA -- TEIL 4 T-11c-Mutation M2: "Alias compare->comparex -> T-B
static_assert Compile-ROT (Z.89)"; TEIL 3 nennt "consteval-Wachen" explizit viermal
(33er-Zahl/P-Raum/Dubletten/Typ-Enum).

### P-03 -- Begriffs-Alias-Registry, 7 Gruppen, KEIN Uebersetzer
**WAS:** "R-2: BEGRIFFS-ALIAS-REGISTRY ... Registry-Deklaration MEHRERER Begriffe,
compile-time als DASSELBE aufgefasst/umbenannt; UEBERSETZEN = REGRESSION = CT-FEHLER;
Code-Adapter nur als Paper-Original-AUSNAHME; XML = WAS/WO/WANN, NIE WIE" (Ledger KON112-09).
Anwendungs-Kandidaten dort (3 Bereiche): (1) SPARSE_NODE4_ART/node4, (2) compare/macro/micro
== w/ma/mi, (3) Stufe*/Verbund*-Uebergang. Wellenplan par.20.5 (Z.2750): "Begriffs-Alias-Registry
(CT, kein Uebersetzer)".
**WIE pruefbar:** die 3 Ledger-Kandidaten-Bereiche muessen sich in konkrete Alias-Paare
auffaechern (node4/SPARSE_NODE4_ART = 1 Paar; w/ma/mi = 3 Paare; Verbund1/2/3 = 3 Paare -> 7
Paare gesamt, siehe unten); `same_begriff`/`begriff_kanonisch` als `constexpr`; Disjunktheits-
Wache gegen Ueberlappung; Gegeneingang-Test (T-4) fuer unbekannte Begriffe (muessen sie selbst
bleiben).
**Bericht behauptet:** JA -- TEIL 2 D8: "ALIAS-ERSTBELEGUNG (KON112-09-Reihung): node4==
SPARSE_NODE4_ART, w==compare, ma==macro, mi==micro, Verbund1_CeOnly==Stufe1_CeOnly,
Verbund2_Replace==Stufe2_PrueflingReplace, Verbund3_Union==Stufe3_FullJoin" (7 Paare, konsistente
Ausfaltung der 3 Ledger-Kandidatenbereiche); TEIL 3: "Begriffs-Alias (7 Gruppen, same_begriff/
begriff_kanonisch constexpr, Disjunktheits-Wache, KEIN Uebersetzer)"; Test T-B "inkl.
Gegeneingang".

### P-04 -- PV-4-Dereferenzierung von `profile_ref` (Ist vorher 0)
**WAS:** Owner-GO woertlich: "Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache
mit mir im Detail" (Ledger-Anker :29396, qualifiziert in KON105-03/KON105-04 als die geltende
Fundstelle -- die frueheren Anker :15584/:16628/:16760 sind STALE). F1 PV-4-DETAILS "ALLE DREI
GESCHLOSSEN" (Ledger KON107-02): (a) "ein Paper = genau ein Experiment-XML, 'Es gibt keine
Kandidaten'" (Owner 08.08.); (b) "voll w/ma/mi"; (c) "abstrakt-leere Achse = volle
CE-Wiederverwendung voll auspermutiert". Wellenplan par.20.9 (Z.2679-2680): "Ist-Befund 0
Experiment-XML, profile_ref nie dereferenziert".
**WIE pruefbar:** Vorher/Nachher-Gegenprobe `grep -rn "\.profile_ref\|base_tiers" libs apps
tools`; Planer-CLI `validate` gegen ein Profil mit gueltigen `base_tiers` muss die Referenzen
tatsaechlich AUFLOESEN (nicht nur parsen).
**Bericht behauptet:** JA -- TEIL 1.2 Ist=0-Verifikation VOR dem Bau; TEIL 5: "VALIDAT OK +
'profile_ref-Dereferenzierung (PV-4): 7 von 7 base_tiers aufgeloest.' RC=0".

### P-05 -- R-4-Haerte: `profile_ref`-Fehlziel = harter Planer-Fehler
**WAS:** "R-4: profile_ref-Fehlziel = HARTER Planer-Fehler, Anzeige 'unerfuellbares XML-Ziel
\"ERROR\"' -- Anwendung der fail-loud-Doktrin (ERST LAUTE FEHLER); Bau im P-H-Strang" (Ledger
KON112-10). Doktrinaer: GOAL v8 II.7 Fail-closed (Z.305-308): "Kann eine Wache nicht pruefen ...,
ist das rot oder Abbruch, nie gruen. Ein stiller Rueckfall ist ausdruecklich ein Fehler."
**WIE pruefbar:** Probe-Profil mit `profile_ref` auf nicht existente Datei -> Planer-CLI muss
mit RC!=0 UND dem Literal-Praefix abbrechen; Gegeneingang (gueltiges Ziel) muss gruen bleiben;
Alt-Kontrakt "unbekannter ref faellt tolerant auf full zurueck" (XSD-Kommentar, U-8-(3)) muss
ALS ALTSTAND erkannt und ersetzt sein.
**Bericht behauptet:** JA -- TEIL 5 (live am Planer-CLI): '[FEHLER]  UNERFUELLBARES XML-ZIEL
"ERROR": <base_tier id="geist" profile_ref="../sota/nicht_da.profile.xml"> -> Ziel-Datei
existiert nicht (...). Harter Planer-Fehler (R-4, KON112-10).' RC=1; Endstand-Abschnitt: Alt-Test
`TemplateWithUnknownRefValidatesTolerant` explizit als "#44/PV-4-Altstand U-8-(3)" erkannt und zu
`TemplateWithUnknownRefIsHardR4Error` umgedreht (HARMONISIERUNG-Regel angewandt und benannt).

### P-06 -- I-5-Farb-Tokens: Achsen-Tokens im Stempel, KEINE Merge-Zeile
**WAS:** "(d) EIGENE VOLLE LAGER-IDENTITAET mit eigenen Stempeln in den 'FARBEN' der neuen
Achsen" (Ledger KON112-08 R-1d). KOLLISION explizit benannt und aufgeloest: "D1/Owner-E2 02.08.
('Merge-Zeile kann daher nicht existieren') vs volle Lager-Identitaet -- Aufloesungs-Kandidat:
die neuen Pruefling-Achswerte erscheinen als ACHSEN-TOKENS im Stempel (keine Merge-ZEILE)"
(Ledger KON112-08). Karte K4 (I-5-Zeile, Z.121): "Klasse B, W2 ENTSCHEIDEN+BAUEN, Slot W2-C ...
Mechanik entschieden (Achsen-Tokens, D1-Harmonisierung, KON112-08)". W2-ABFOLGE-DESIGN D-4
(Z.318): "I-5 Stempel-Farben (Mechanik ENTSCHIEDEN: Achsen-Tokens, keine Merge-Zeile)".
**WIE pruefbar:** neue Funktion(en) fuer die Organ-Stempelzeile der Paper-Prueflinge, additiv
zu `sota_stamp_lines` (keine Aenderung an dessen Byte-Form); Sentinel-Verbot (kein `0.0.0`
darf als "Version" durchgehen) testbar per Mutation.
**Bericht behauptet:** TEILWEISE, mit ausdruecklich benannter Einschraenkung -- TEIL 2 D3: fuer
die 3 ABSTRAKTEN Prueflinge (P08/P09/P33) "je reale Registry-Wrapper mit algo_version -> CT-
Pflicht (e) via Versions-Tabelle erfuellt, Sentinel-0.0.0-Verbot im Test"; fuer VOLLE Prueflinge
(die uebrigen 30) ausdruecklich VERTAGT: "deren Organ-Zeile haengt am dokumentierten SOTA-
METADATEN-BLOCKER (K-3-REST) und wird DORT geloest -- hier keine zweite Zeilen-Ableitung
(O-8-Lehre)". Endstand-Abnahme-Text behauptet gleichwohl pauschal "(c) 'I-5-Tokens gebaut'" ohne
diese Einschraenkung zu wiederholen -- **siehe SPANNUNGEN Punkt 1** fuer die Praezisions-Luecke
zwischen Abnahme-Wortlaut und Liefer-Umfang.

### P-07 -- R-3/L6: P08/P09/P33-Umbau zu abstrakten Prueflingen
**WAS:** "L6 P08/P09/P33 -> abstrakte Prueflinge = P-H-Posten, nicht Teil von B-2" (Ledger
KON112-03, AUFLAGEN L1-L6). R-3 selbst (Ledger KON110-05 / Wellenplan-Zeile): "P08/P09/P33
werden zu ABSTRAKTEN PRUEFLINGEN umgebaut; es greift die Regel der abstrakt-leeren Achse MIT DEN
3 JOIN-MODI Pruefling x Stand der Technik x Full join ... per XML definiert. LAGER-SKIP-LOGIK:
ist das Lager vollstaendig (Binaries+Messwerte), wird der Stand der Technik NICHT neu gemessen".
W2-ABFOLGE-DESIGN D-4 (Z.319): "P08/P09/P33-Umbau (L6)".
**WIE pruefbar:** `grep -n 'pruefling_type' libs/cache_engine/algorithm_profiles/sota/p0{8,9}*
p33*.profile.xml` -> muss `abstract` zeigen; Registry-seitiger Leser des Attributs muss
existieren (nicht nur `derive_pruefling_type` aus `merge`/`series_id`).
**Bericht behauptet:** JA, mit Praezisierung -- TEIL 1.3: "P08 olc / P09 louds / P33 vampir
tragen BEREITS `pruefling_type='abstract'` (Commit `02a79daf` #240/AP-6) -- der L6-'Umbau' ist am
XML-Bestand vollzogen; es fehlt die Registry-Seite (kein CT-Leser von pruefling_type im Profil)".
Die Registry-Seite liefert TEIL 3 nach (Typ-Enum im `paper_pruefling_registry.hpp`).

### P-08 -- M14-Ranking-Grammatik (Typen + Ausgabe), REPORT-Datenfuellung NICHT Teil
**WAS:** "(f) FORSCHER-WORKFLOW Markierung + Planer-Ranking-Ausgabe -- dafuer existiert KEINE
Grammatik und KEIN Alt-Posten" (Ledger KON112-08 R-1f). Karte K4 (M14-Zeile, Z.111): "M14
Planer-Ranking-Report | [RT] Report; [ID/W2]=I-5 Stempel-Farben (Slot W2-C, real BAUT) | #89 ...
| 0 ranking-Treffer, nicht gebaut". D.h. die Karte trennt den [RT]-Report-Anteil (Laufzeit,
Messdaten-gefuellt) vom [ID]-Grammatik-Anteil -- NUR letzterer ist W2/#89-Baustoff.
**WIE pruefbar:** Header-Datei mit Typen (Markierungssatz/Ranking-Struktur), deterministische
Ranking-Funktion (Tie-Break-Regel benannt und testbar per Mutation), Ausgabe-Renderer mit
dokumentierter Zeilen-Grammatik; KEINE Verdrahtung in den produktiven Mess-Batch-Pfad.
**Bericht behauptet:** JA, mit derselben Abgrenzung wie die Karte -- TEIL 2 D5: "M14-GRAMMATIK
... REPORT-Bau (Daten-Fuellung aus Messwerten) bleibt nach-Trigger (K4 2d) -- hier die GRAMMATIK
+ Ausgabe-Funktion"; TEIL 3 nennt Datei + Typen + `render_markierungs_ranking`; Test T-G; OFFENE
PUNKTE #3 benennt die Report-Verdrahtung ausdruecklich als NICHT-hier-geliefert.

### P-09 -- R-1(f)-Markierung: Token-Mechanik "achse=wert"
**WAS:** Teil derselben KON112-08(f)-Zeile wie P-08 ("Markierung" als eigenstaendiges Element
neben "Ranking-Ausgabe").
**WIE pruefbar:** Treffer-Logik gegen die Organ-Stempelzeile ("achse=wert@X.Y.Z") plus
Gesamt-Komposition; Test mit positivem und negativem Treffer (T-4-Gegeneingang).
**Bericht behauptet:** JA -- TEIL 3: "MarkierteAchse/MarkierungsSatz/ist_markiert (Token-Treffer
'achse=wert' + Gesamt-Komposition)".

### P-10 -- 33 Paper-Experiment-XMLs, xmllint-valide, ein Paper = ein Experiment-XML
**WAS:** Wellenplan par.18.8 NEU-Zeile (Z.2321): "Paper-Experiment-XML je Paper (Fadenriss
20.07., Grundfigur 2/3) | (M) | W2 mit #18". Praezisierung par.20.9 (Z.2679-2680): "Owner-GO
08.08. ('Ja unter sorgfaeltiger Design Planung bitte bauen') + Ist-Befund 0 Experiment-XML,
profile_ref nie dereferenziert". F1a (Ledger KON107-02): "ein Paper = genau ein Experiment-XML,
'Es gibt keine Kandidaten' (Owner 08.08.); A_full = Standard". W2-ABFOLGE-DESIGN D-4 ABNAHME
(Z.325): "XML je Paper existiert."
**WIE pruefbar:** `ls libs/cache_engine/algorithm_profiles/paper_experiments/*.experiment.xml |
wc -l` == 33 (fremder Nenner gegen die Paper-Registry, T-3); `xmllint --schema
Code/test_data_xml/experiment_schema.xsd` ueber alle 33 -> FAIL=0; KEINE `<phases>`-Angabe
(F1c: 3 Verbund-Stufen werden ABGELEITET, nicht hartkodiert).
**Bericht behauptet:** JA -- TEIL 4 XSD-KONFORMITAET: "xmllint --schema ... ueber alle 33 ->
FAIL=0, 'art.experiment.xml validates'"; TEIL 2 D6 nennt Ort/Form/Menge (33 Stueck, version="2",
keine `<phases>`, 6 Workloads, OP-1..OP-6); Test T-F.

### P-11 -- Kollisions-Auflage: KEINE eigene XSD-Aenderung durch #89
**WAS:** LEAD-ENTSCHEIDE Punkt 3 (Z.7-9): "#89-Slot: per Owner-Sofort-Regel (20.08.) EIGENER
BAU-AGENT SOFORT (Staffel 2, Strang p-h-89) -- kein Warten auf Di/Mi. **XSD-Anteile koordiniert
der s13-Schema-Zug** (Kollisions-Auflage im Prompt)." Passt zur allgemeinen TABU-Regel
".gitlab-ci.yml nur wenn ausdruecklich beauftragt" (hier: analog fuer XSD).
**WIE pruefbar:** `git diff <basis>..bau/ph89 -- '*.xsd'` muss LEER sein; stattdessen eine
benannte Bedarfsliste fuer den s13-Zug.
**Bericht behauptet:** JA -- TEIL 3 EISERNE-REGEL-Zeile: "XSD unberuehrt"; TEIL 6 liefert die
geforderte Liste explizit mit 7 Punkten (siehe P-12/P-13/NICHT-GEFORDERT).

### P-12 -- Schema-Bedarfe als benannte Liste an s13 (Gegenstueck zu P-11)
**WAS:** Aus KON112-08 (b)/(c)/(f) UND aus D-09 (KON30-02) folgen mehrere Grammatik-Luecken,
die #89 nicht selbst schliessen darf (P-11), aber benennen MUSS, damit sie nicht verloren gehen
(Memory-Doktrin "LUECKE = BEHEBUNGS-Auftrag", hier: Behebung im FREMDEN Zug, also Melde-Pflicht).
**WIE pruefbar:** Datei/Abschnitt mit mindestens: (i) TemplateType-Kommentar-Korrektur, (ii)
Pfadangabe fuer externe Pruefliche, (iii) Markierungs-Grammatik, (iv) Ranking-Ausgabe-Grammatik,
(v) Gesamt-Klassen-Ladung ("class=papers"), (vi) D-09-1..3-Deckel-Element.
**Bericht behauptet:** JA -- TEIL 6 listet genau diese 6 Punkte (durchnummeriert 1-6) plus einen
7. Punkt ("KEIN Bedarf aus den 33 XMLs selbst").

### P-13 -- D-09 als S-19-Input dokumentiert (Doku-only, kein Code-Bau)
**WAS:** Wellenplan par.19.4 Korb D (Z.2515): "D-09  Pruefling = drittes Konzept,
XML-beschraenkbar 1..3, ERWEITERT den Permutationssatz (KON30-02/KON31) -> S-19-Input +
prt-art-Rolle". Owner-Verbatim-Ursprung (Ledger KON30-02, woertlich): "Das ist korrekt, dass
dies das Prueflings-Test-Konzept ist und in der XML auf beliebige 1 bis 3 angebotene Varianten
beschraenkt werden kann ... Das betrifft also nur die Erweiterung der Organ-Achsen zur compile
time der Tier-Binaries und zur Laufzeit der CEB nach Planer-XML Plan." W2-ABFOLGE-DESIGN D-4
(Z.320-321): "D-09 Pruefling=drittes Konzept (XML-beschraenkbar 1..3, erweitert
Permutationssatz; S-19-Input)".
**WIE pruefbar:** Dokument unter `docs/architecture/` mit dem D-09-Konzept als S-19-Eingabe;
KEIN Code-Bau erwartet (S-19/Planungs-Simulation existiert laut Owner selbst noch nicht, KON30-
03: "die Planungs Simulation gibt es noch nicht").
**Bericht behauptet:** JA -- TEIL 3 nennt `docs/architecture/20260821-d09-pruefling-drittes-
konzept-s19-input.md -- D-09 als S-19-Input`.

### P-14 -- TDD-Vertrag T-1..T-9 (Designplan par.3, gilt fuer JEDES Paket)
**WAS (woertlich, Designplan-tdd Z.63-76):** "Gilt ab sofort fuer jedes Paket aller Wellen."
- T-1 ROT ZUERST (Z.67): "Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter
  Wegwerf-Mutation bewiesen."
- T-2 AUSSAGE, NICHT ANWESENHEIT (Z.68).
- T-3 NENNER, FREMD (Z.69): Grundgesamtheit aus einer ANDEREN Quelle als dem Pruefling.
- T-4 GEGENEINGANG (Z.70).
- T-5 ORAKEL UNABHAENGIG (Z.71).
- T-6 SCHWESTERPFLICHT (Z.72).
- T-7 REGISTRIERUNG IST TEIL DES TESTS (Z.73): "ein Test existiert erst, wenn er in `ctest -N`
  erscheint und sein Binary im Bauweg haengt".
- T-8 ATOMARE LANDUNG (Z.74).
- T-9 TESTKRITIK (Z.75): Codex-Pass in der FOLGEWELLE -- fuer #89 selbst also NICHT in diesem
  Zug faellig, sondern der naechsten Welle zugeordnet.
**WIE pruefbar:** je Teilstueck (P-01..P-10) gegen T-1..T-9 durchmustern; insbesondere T-3
(fremder Nenner: `ls`-Zaehlung VOR jeder Assertion) und T-7 (ctest -N-Eintrag).
**Bericht behauptet:** TEILWEISE explizit benannt, Rest plausibel aber nicht einzeln
durchdekliniert -- TEIL 3 nennt "T-1 ROT ZUERST (literal)" mit Compile-Fehler-Beleg; TEIL 4
nennt "T-11c-WEGWERF-MUTATIONEN" ausdruecklich; T-3 (fremder Nenner) ist FAKTISCH erfuellt
(TEIL 1.3 `ls | wc -l = 33` vor jeder Registry-Behauptung), aber nicht als "T-3" benannt; T-7
ist erfuellt (CMakeLists-Dateiende + 511/511-ctest-Lauf), T-9 ist explizit NICHT faellig (gehoert
der Folgewelle). T-2/T-4/T-5/T-6/T-8 werden vom Bericht nicht einzeln gegen ihr Kuerzel
durchdekliniert -- das Audit muss sie am Testcode selbst pruefen (siehe unten, kein Bericht-
Zitat verfuegbar).

### P-15 -- T-11b/T-11c: Kombibau-Matrix und Mutations-Protokoll
**WAS (Designplan-tdd Z.645-647):** T-11b "jede Landung ist erst gruen, wenn {clang, gcc} x
{Debug, Release} = 4 Zellen je J-1...J-4 + ctest durchlaufen ... GEZAEHLTE Pflicht: 4 Zellen, je
mit literaler ctest-Bilanz". T-11c "der Biss jedes neuen Tests wird per protokollierter
Wegwerf-Mutation belegt (Rot gesehen, dann zurueckgenommen) ... GEZAEHLTE Pflicht je Paket: je
neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen".
**WIE pruefbar:** T-11c: pro neuem Test (T-A..T-G, 8 Tests it. Bericht) mind. 1 dokumentierte
Mutation mit Rot-Beleg + Revert-Gegenprobe. T-11b: 4-Zellen-Kombibau-Bilanz literal -- ABER
T-11b ist laut REGELN-Block der Lande-Reihenfolge (K17) explizit ein LANDUNGS-Schritt ("JE
MERGE: K17-Kombibau"), nicht zwingend ein Vorab-Schritt jedes einzelnen Strangs (siehe
NICHT-GEFORDERT).
**Bericht behauptet:** T-11c JA, vollstaendig -- TEIL 4 listet 6 benannte Mutationen (M1-M6) je
mit Ziel-Test und Rot-Beleg, alle revertiert. T-11b NUR TEILWEISE -- Endstand nennt nur
gcc-Release lokal (511/511) und traegt den vollen 4-Zellen-Kombibau ausdruecklich als OFFENEN
PUNKT #2 "fuer den Lande-Zug" nach.

### P-16 -- Betriebsregeln aus dem REGELN-Block (Bau-Slots, EIN Schreiber, Zaehlwerke)
**WAS (W2-ABFOLGE-DESIGN TEIL3-REGELN, Z.790-796):** "1 Schreiber je Worktree * Drei-Bauten-
Deckel (MAX 3 lokale Vollbauten) * GENAU EINE Pipeline ... * K17-T-11b-Kombibau je Lande-Merge
am gemergten Stand VOR Push * ... * df -h vor Vollbau, Bauverzeichnis mit Belegpruefung
entfernen * kein Hintergrund-Bau ohne gemerkte Shell-ID * Lebendprobe = Log-Wachstum+Endmarke,
nie pgrep-Leere."
**WIE pruefbar:** Bau-Slot-Datei waehrend des Laufs, `df -h`-Beleg vor dem Vollbau,
Bauverzeichnis-Entfernung mit Belegpruefung (git ls-files 0, csv/xlsx 0) nach ctest.
**Bericht behauptet:** JA -- Endstand: "Bau-Slot 2 freigegeben. Build-Verzeichnis nach
Belegpruefung (git ls-files 0, csv/xlsx 0) entfernt"; Wiederanlauf-Abschnitt nennt "df-Gate: 27G
frei (>5G)".

### P-17 -- EISERNE REGEL / TABU-Zonen
**WAS:** LEAD-ENTSCHEIDE (Z.24-27, EISERNE-REGEL-KLARSTELLUNG): "axes/-Aenderungen sind seit der
#15-Landung KONTROLLIERTE GOLDEN-EREIGNISSE". Ergaenzend die Standing-TABU-Liste (nichts unter
axes/topics/heuristik/; golden-Dateien byte-stabil; .gitlab-ci.yml nur bei ausdruecklichem
Auftrag -- P-89 hat keinen solchen Auftrag, s. P-11).
**WIE pruefbar:** `git diff <basis>..bau/ph89 --stat` -- keine Pfade unter `axes/`, `topics/`,
`heuristik/`; keine Aenderung an bestehenden golden-Dateien (nur additive Neuanlagen zulaessig);
`.gitlab-ci.yml` unveraendert.
**Bericht behauptet:** JA -- TEIL 3: "EISERNE REGEL EINGEHALTEN: nichts unter axes/ topics/
heuristik/; golden byte-stabil (nur additive neue Dateien + profile_facade/tests); .gitlab-ci.yml
unberuehrt; XSD unberuehrt."

### P-18 -- Registrierung ans Dateiende (T-7 + D-20-Prozessregister)
**WAS:** Designplan T-7 (Z.73, s. P-14) + Wellenplan D-20 (Z.2541-2544, Prozess-Register):
"CMakeLists-Hotspot ans DATEIENDE" als eigener benannter Punkt neben "Opus ERHEBT/Fable
BEWERTET", "MAX DREI Vollbauten", "Wellen-Form".
**WIE pruefbar:** `git diff` an `tests/unit/CMakeLists.txt` darf NUR am Dateiende einfuegen
(keine Interpolation in bestehende Bloecke).
**Bericht behauptet:** JA -- TEIL 3: "tests/unit/CMakeLists.txt: Registrierung
test_ph89_paper_prueflinge NUR am DATEIENDE."

### P-19 -- Code-Hygiene: ASCII-only + clang-format-22
**WAS:** Standing-Doktrin (Memory: ASCII-only-Kommentare-und-Selbstcheck; Warnungs-/Format-
Review), wortgleich auch im REGELN-Block dieses Erhebungsauftrags gefuehrt ("ASCII-only in neuen
Zeilen; clang-format-22 ueber jede geaenderte Lint-Datei").
**WIE pruefbar:** Non-ASCII-Scan ueber den Diff; `clang-format-22 --dry-run -Werror` ueber jede
geaenderte C++-Datei.
**Bericht behauptet:** JA -- TEIL 5: "ASCII-Wache: alle eigenen Diff-Zusaetze + neuen Dateien
non-ASCII-frei ... clang-format-22 --dry-run -Werror sauber ueber alle 6 C++-Dateien."

### P-20 -- Beweis-Doktrin: literale Bilanz, kein Erfolg ohne Literal
**WAS:** GOAL v8 II.3 "V1 -- Berichte sind Beweismaterial, kein Beweis" (Z.276) als
Doktrin-Grundlage; operationalisiert im REGELN-Block dieses Audits ("jede Behauptung mit Literal
... kein Erfolg ohne literalen Output").
**WIE pruefbar:** ctest-Endzeile im Bericht muss wortgleich zitiert sein, RC-Werte benannt.
**Bericht behauptet:** JA -- Endstand: "ctest-VOLLLAUF gcc Release: '100% tests passed, 0 tests
failed out of 511'"; TEIL 5: RC=0 (Bestand gruen) und RC=1 (Fehlziel hart) je mit vollem
Text-Literal.

### P-21 -- Slot-Entscheidung: eigener Bau-Agent SOFORT statt Di-25-Sammel-Slot
**WAS:** W2-ABFOLGE-DESIGN D-4 (Z.322-323): "SLOT-KONFLIKT: K1:31 = Di-25 geteilter Slot; K4/
D2-2f = W2-C 'Mi, eigener Bau-Agent' -- Lead entscheidet; Abnahme identisch, VOR Kampagne
zwingend." Aufgeloest durch LEAD-ENTSCHEIDE Punkt 3 (Z.7-9): "EIGENER BAU-AGENT SOFORT (Staffel
2, Strang p-h-89) -- kein Warten auf Di/Mi."
**WIE pruefbar:** Worktree/Branch-Existenz VOR dem Di-25-Landefenster; Ergebnis-Datei mit
Staffel-2-Kennzeichnung.
**Bericht behauptet:** JA -- Kopfzeile "STRANG p-h-89 (Staffel 2)"; TEIL 1.1 zitiert den
Lead-Entscheid wortgleich.

### P-22 -- Ref-Sicherung nach Fix-Commit
**WAS:** Standing-Betriebsregel (auch im REGELN-Block dieses Audits: "git push -o ci.skip origin
<branch>" nach jedem Fix-Commit als Ref-Sicherung ohne Pipeline-Ausloesung).
**WIE pruefbar:** `git ls-remote origin bau/ph89` zeigt den Commit `2809e4d4`.
**Bericht behauptet:** JA -- Endstand: "Branch-Sicherung `git push -o ci.skip origin bau/ph89`
-> '[new branch] bau/ph89 -> bau/ph89' (gitlab.comdare.local)."

### P-23 -- Lande-Reihenfolge-Abhaengigkeit: #89 NACH #91/vollzug91 (H-11-Kanon-Abgleich)
**WAS:** STAFFEL2-SYNTHESE.md, Lande-Reihenfolge-Fortschreibung, Abschnitt 2.2 Phase 1: Schritt
6 "`bau/vollzug91` ... VOR ph89 (H-11-Kanon)"; Schritt 7 "`bau/ph89` ... H-11 (Kanon-Abgleich
gegen M13) + H-12 + H-13 + H-16 + H-9". Begruendung H-11 (Z.57-67, woertlich zentral): "vollzug91
baut die generische M13-Registry ... Kanon: w->wallclock, compare->wallclock [Ebene-0-Dualitaet]
... ph89 baut daneben den Paper-Domaenen-Alias ... (7 Gruppen, u.a. 'w==compare',
'Verbund3_Union==Stufe3_FullJoin'; Kanon = lebendes Registry-/Enum-Vokabular). Dateien und
Faecher sind disjunkt ... aber die KANON-RICHTUNG der Ebene-0 (wallclock, nicht compare) muss
beim ph89-Merge widerspruchsfrei gehalten werden; M13-Absorption der Paper-Gruppen ist im
ph89-Design (D1) vorgesehen und ist ein FOLGE-Posten, keine Lande-Pflicht. EMPFEHLUNG: vollzug91
VOR ph89 landen und die ph89-Gruppen gegen den dann stehenden M13-Kanon halten."
**WIE pruefbar:** In der TATSAECHLICHEN Landereihenfolge (`git log --merges` auf dem Ziel-Branch
nach der Lande-Kampagne, oder die Merge-Commit-Zeitstempel) muss der vollzug91-Merge VOR dem
ph89-Merge liegen; nach beiden Merges muss geprueft werden, dass `paper_pruefling_registry.hpp`s
Alias-Paar "w==compare" NICHT der `naming/begriffs_alias_registry.hpp`-Kanonrichtung
"w->wallclock, compare->wallclock" widerspricht (keine gegenlaeufige Kanon-Behauptung im selben
Begriffsraum; eine reine Aequivalenz-Aussage "w und compare sind dasselbe" bleibt mit einem
DRITTEN Kanon-Namen "wallclock" vertraeglich, eine EIGENE Kanon-Wahl "w ist der Name" waere es
nicht -- am Objekt (Diff beider Registries) zu entscheiden).
**Bericht behauptet:** Kann es NICHT behaupten -- der Strang-Bericht (p-h-89-ergebnis.md, 21.08.)
entstand VOR der staffelweiten H-11-Harmonisierungs-Synthese (Datei-Stempel STAFFEL2-SYNTHESE.md:
"erstellt 21.08.2026", nach dem Endstand-Abschnitt des Strang-Berichts). Der Bericht selbst
dokumentiert unter TEIL 2 D1 zwar die BEABSICHTIGTE spaetere Absorption durch M13 ("Die
generische M13-Alias-Registry (Slot W2-D, ANDERER Strang) kann sie spaeter absorbieren -- I-7
(Alias-vor-Rename) ist im Design gesetzt; hier NUR die Paper-Domaene"), nennt aber weder den
Terminus "wallclock" noch eine explizite Lande-REIHENFOLGE-Pflicht gegenueber vollzug91. Dies ist
damit ein reiner FINDINGS-BESTAND-Fund (kein Bericht-Zitat verfuegbar) -- das Audit muss die
Reihenfolge am tatsaechlichen Lande-Ereignis pruefen, nicht am Strang-Bericht.

---

## ABNAHME-FORMELN (woertlich, mit Rang)

Wahrheits-Rangfolge fuer diese Aufgabe: Owner-Wort > juengere KON (KON112 > KON110 > KON30) >
Wellenplan par.21-23 (kein #89-Treffer, s. SPANNUNGEN 6) > par.17-20 (par.18.8/par.19.4/par.20.5,
der eigentliche Ursprungstext) > Designplan (allgemeiner T-Vertrag, kein #89-Katalogposten) >
W2-ABFOLGE-DESIGN (operative Verdichtung) > Strang-Bericht.

1. **Operative Kern-Formel (W2-ABFOLGE-DESIGN D-4, Z.325, unterste massgebliche Ebene vor dem
   Bericht selbst):** "ABNAHME: Uebersetzung+PV-4 fertig; XML je Paper existiert;
   I-5-Tokens gebaut."
2. **Slot-Zusatz (W2-ABFOLGE-DESIGN D-4, Z.323):** "Abnahme identisch, VOR Kampagne zwingend"
   (gilt unabhaengig davon, ob Di-25- oder Mi-Slot -- durch P-21 zugunsten Sofort-Slot entschieden,
   Abnahme-Inhalt bleibt gleich).
3. **R-1..R-5-Einzelformeln (Ledger KON112-08/09/10, hoeherrangig als W2-ABFOLGE-DESIGN):**
   - R-1(a)-(f): 33 foermliche Prueflinge, XML-gesamt-klassen-ladbar, Pfadangabe nur extern,
     eigene volle Lager-Identitaet mit Farben, CT-ERROR-Pflicht, Markierung+Ranking-Ausgabe.
   - R-2: Begriffs-Alias als Registry-Mechanismus, "UEBERSETZEN = REGRESSION = CT-FEHLER".
   - R-3 (KON110-05/KON112-03): P08/P09/P33 abstrakt, 3 Join-Modi, Lager-Skip-Logik (Skip-Logik
     selbst laut KON112-03 "Heute NICHT gebaut" -- **ausserhalb** von #89, s. NICHT-GEFORDERT).
   - R-4: "profile_ref-Fehlziel = HARTER Planer-Fehler, Anzeige 'unerfuellbares XML-Ziel
     \"ERROR\"'."
   - R-5: "Slot BESTAETIGT -- Ledger-#44-Bau W2, gebuendelt mit #18/S-13."
4. **F1-PV-4-Details (Ledger KON107-02, Owner-Rueckfrage-Antwort, hoeherrangig als Design-Text):**
   "ALLE DREI GESCHLOSSEN -- (a) ein Paper = genau ein Experiment-XML ... (b) voll w/ma/mi ...
   (c) abstrakt-leere Achse = volle CE-Wiederverwendung voll auspermutiert ... Bau: #44
   profile_ref dereferenzieren + Vokabular-Naht (SPARSE_NODE4_ART vs node4)."
5. **Owner-GO selbst (hoechster Rang, Ledger-Anker :29396):** "Ja unter sorgfaeltiger Design
   Planung bitte bauen, Ruecksprache mit mir im Detail." -- die "Ruecksprache im Detail" ist laut
   KON105-03 nur noch TERMINLICH offen (nicht inhaltlich); dieser Termin ist NICHT Teil des
   #89-Bau-Auftrags selbst, sondern ein separates Owner-Meeting (s. NICHT-GEFORDERT).
6. **Wellenplan-Ursprungsformel (par.20.5, Z.2750-2751, niedrigerer Rang, aber der Namensgeber):**
   "P-H 33 Paper->Prueflinge + Begriffs-Alias-Registry (CT, kein Uebersetzer) + Markierungs-/
   Ranking-Ausgabe -> #44/W2."
7. **Querbezug (nicht #89 selbst, aber Abnahme-relevant fuer den I-5-Teil):** W2-ABFOLGE-DESIGN
   E-3 (#91-VOLLZUG, Z.463-464) verlangt fuer die SEPARATE Aufgabe #91 "je I-Punkt Vollzugs-/
   Festschreib-Beleg" -- I-5 ist einer dieser I-Punkte. #89s I-5-Lieferung ist damit VORAUSSETZUNG
   fuer #91s eigene Abnahme, nicht umgekehrt; ein luecken-hafter I-5-Vollzug (s. P-06/SPANNUNG 1)
   wirkt somit auf eine ZWEITE Aufgabe zurueck.

---

## NICHT-GEFORDERT (deklarierte Nachfolge-Zuege -- keine Phantom-Funde)

1. **M14-REPORT-Datenfuellung** (echte Messwerte in den Ranking-Report einspeisen) -- laut Karte
   K4 (Z.111, "[RT] Report") und Bericht selbst (OFFENE PUNKTE #3) explizit "nach-Trigger (K4
   2d)". #89 liefert nur GRAMMATIK + Ausgabe-Funktion, keinen befuellten Report.
2. **Emissions-Verdrahtung von `paper_stamp_lines` in den produktiven Paper-Experiment-Bau-Pfad**
   -- selbe Quelle wie Punkt 1, "nach-Trigger".
3. **Volle-Prueflinge-Organ-Zeile (die uebrigen 30 von 33) real farbig ableiten** -- haengt am
   VORBESTEHENDEN SOTA-METADATEN-BLOCKER (K-3-REST, `sota_catalog.hpp:132-141`); Bericht D3
   nennt ausdruecklich "wird DORT geloest -- hier keine zweite Zeilen-Ableitung (O-8-Lehre)".
   Ein offener Befund zu diesem Blocker ist KEIN #89-Fund, sondern gehoert zum K-3-REST-Traeger.
4. **Lager-Skip-Logik je Join-Modus automatisieren** (KON112-03: "Heute NICHT gebaut: nur
   manuelle `<phases>`-Beschraenkung existiert ... kein automatischer Lager-Abgleich") -- als
   AUFLAGE benannt, aber nicht #89s Liefergegenstand; R-3 selbst spricht nur vom P08/P09/P33-
   Umbau + den 3 Join-Modi als Enum-Deckungsgleichheit, nicht von der Skip-Automatik.
5. **Eigene XSD-Aenderung** (Pfadangabe, Markierungs-Grammatik, Ranking-Ausgabe-Grammatik,
   Gesamt-Klassen-Ladung, D-09-Deckel-Element) -- Kollisions-Auflage weist dies dem
   s13-Schema-Zug zu (LEAD-ENTSCHEIDE Punkt 3); #89 liefert nur die Bedarfsliste (P-12).
6. **`.gitlab-ci.yml`-Aenderung** -- keine ausdrueckliche Beauftragung fuer #89 vorhanden (TABU
   greift).
7. **Voller 4-Zellen-Kombibau (T-11b) VOR der Landung** -- gehoert laut REGELN-Block zur
   LANDUNG ("JE MERGE: K17-Kombibau"), also zu Slot [D] Position 5, NICHT zum Strang-Bau selbst.
   Bericht traegt es korrekt als offenen Nachlauf-Punkt, nicht als versaeumte #89-Pflicht.
8. **Die eigentliche Landung (Merge nach ce/development)** -- #89/D-4 ist Position 5 der
   Lande-Reihenfolge in Slot [D] (W2-ABFOLGE-DESIGN Z.818: "(5) D-4 #89"); der Strang liefert nur
   den gebauten, gepushten Branch (ci.skip) als Landungs-Kandidat.
9. **Ledger-Eintrag selbst schreiben** -- Lead-only-Regel (auch in diesem Erhebungsauftrag
   gefuehrt); der Strang liefert einen ENTWURF (OFFENE PUNKTE #5), keinen vollzogenen Eintrag.
10. **Neuen Board-Task fuer die Ledger-#44/Board-#44-Nummernkollision anlegen** -- vom Strang
    als NACHLAUF fuer den Lead benannt (OFFENE PUNKTE #4, deckt sich mit Ledger KON112-10 R-5
    CAVE); #89 selbst muss diesen Board-Task nicht anlegen.
11. **Alt-Task "#44 `-Werror` global"** (Wellenplan par.13.3, Z.1526, W7-Warteliste Z.1841/3022)
    ist KEIN Bestandteil von #89 -- reiner Nummern-Zufall, im Ledger selbst als Kollision
    dokumentiert (Z.621/700, s. SPANNUNGEN 3). Ein Audit-Fund "`-Werror` global fehlt" waere
    hier ein PHANTOM-Fund.
12. **prt-art-Repo-Aenderungen** -- Bericht TEIL 0/1.3: kein prt-art-Worktree angelegt, prt-art
    nur LESEND inspiziert ("KEIN `ext/paper`-Ordner"); #89 aendert ausschliesslich ce.
13. **Owner-Ruecksprache-TERMIN selbst** (KON105-03 E-3) -- reine Terminfrage, kein Bauinhalt;
    inhaltlich laut Bericht durch F1 PV-4-DETAILS bereits geschlossen (s. ABNAHME-FORMELN 4/5).

---

## SPANNUNGEN (Widersprueche/Fallen zwischen den Quellen -- nicht glattgezogen)

1. **I-5-Abnahme-Wortlaut vs. tatsaechlicher Teil-Umfang (inhaltlich, nicht nur Label).** Die
   operative Abnahme-Formel (W2-ABFOLGE-DESIGN Z.325) sagt pauschal "I-5-Tokens gebaut" und der
   Ledger fordert "(d) EIGENE VOLLE LAGER-IDENTITAET" fuer ALLE 33 foermlichen Prueflinge
   (KON112-08 R-1a+d zusammengelesen). Der Bericht selbst grenzt jedoch bewusst ein: nur 3 von 33
   Prueflingen (P08/P09/P33) bekommen eine echte, algo_version-gestuetzte Farb-Zeile; die
   restlichen 30 "vollen" Prueflinge bleiben am SOTA-METADATEN-BLOCKER haengen und werden
   AUSDRUECKLICH nicht hier geloest ("O-8-Lehre"). Das ist eine PLAUSIBLE und selbst benannte
   Scope-Entscheidung des Strangs -- aber die Endstand-Abnahme-Gegenpruefung des Berichts
   zitiert nur den pauschalen Abnahme-Satz, ohne die Einschraenkung dort zu wiederholen. Das
   Audit muss selbst entscheiden, ob "I-5-Tokens gebaut" bei 3/33 real belegten Faerbungen
   erfuellt ist oder ob die uebrigen 30 einen offenen Punkt DIESER Aufgabe (statt des
   K-3-REST-Traegers) darstellen. Juengere/hoeherrangige Quelle (KON112, 17.08.) praezisiert
   nicht explizit "alle 33 muessen sofort farbig sein" -- die Formulierung "eigene Stempel in
   den Farben der neuen Achsen" ist fuer ALLE 33 foermlichen Prueflinge formuliert, adressiert
   aber nicht den vorbestehenden Blocker. Kein Glattziehen moeglich, beide Lesarten vertretbar.
2. **Nummernkollision "#44" (SELBST-DOKUMENTIERT im Ledger, PRUEF-FALLE fuer das Audit).** Es
   existieren MINDESTENS drei verschiedene "#44": (a) Wellenplan par.13.3 (Z.1526)/W7-Liste
   (Z.1841, Z.3022): Alt-Task "#44 `-Werror` global", Board-Status lt. Ledger Z.700
   "F1-Landung, completed"; (b) Ledger-#44 = PV-4/Paper-Template-Profile-Erfassungsgap
   ("Task #44 NEU", Ledger Z.23416/23420); (c) Board-#89, das seit KON113-03 (Ledger Z.617/621)
   FORMAL "Ledger-#44/PV-4" traegt. Der Ledger selbst warnt: "Nummern-Namensraeume: Board-#89
   traegt Ledger-#44/PV-4 (Kollision dokumentiert)" (Z.621) und "CAVE Nummern-Namensraum:
   Board-#44 (F1-Landung, completed) != Ledger-#44 (PV-4) -- neuer Board-Task noetig" (Z.700).
   Fuer das Audit heisst das: ein Fund "Task #44 (-Werror global) ist nicht erledigt" ist KEIN
   #89-Fund (s. NICHT-GEFORDERT 11).
3. **Nummernkollision "R-1..R-5" (SELBST-DOKUMENTIERT, PRUEF-FALLE).** Mindestens drei
   R-1..R-5(bzw. -38)-Namensraeume koexistieren: (a) Wellenplan-Register R-01..R-38 (par.19.7,
   von der W2-ABFOLGE-DESIGN-Gegenzaehlung Z.842 referenziert); (b) KON30/31-Runde (~12.08.,
   Mess-Instrumentierungs-Thema; deren R-4 = "GESTRICHENE gerade-Anzahl-Invariante", KON30-04 --
   VOELLIG ANDERES THEMA als PV-4/#89!); (c) KON110/112-Runde (17.08., explizit "(PV-4)"
   qualifiziert, das fuer #89 massgebliche R-1..R-5). Der Ledger selbst traegt die
   Qualifizierungs-Pflicht ein: "LABEL-CAVE: Owner-R-1 (17.08./PV-4) != Wellenplan-R-1 (KON37-02,
   geschlossen) -- immer qualifizieren" (Ledger KON112-08). Diese SOLL-KARTE zitiert
   ausschliesslich die "(PV-4)"-qualifizierte Runde (c); ein Audit-Treffer auf "R-4" ohne
   Kontext-Pruefung koennte faelschlich KON30-04 (gerade-Anzahl, laengst gestrichen) statt
   KON112-10 (profile_ref-Haerte) treffen.
4. **Nummernkollision "D-09" (PRUEF-FALLE, in dieser Erhebung aufgeloest, nicht im Ledger selbst
   explizit ge-cave't).** Neben dem fuer #89 massgeblichen Wellenplan-Korb-D-Posten "D-09
   Pruefling=drittes Konzept" (par.19.4, Z.2515, Ursprung KON30-02/KON31) traegt der Ledger seit
   22.08. (KON120-02, Z.142) EINEN VOELLIG ANDEREN, lokal in der A/B/C/D-Owner-Antworten-
   Zuordnung dieses Datums verwendeten Posten "D-09/D-06 = Owner-RUECKFRAGEN, Erklaerungen
   geliefert (Session-Dok Abschn. 3)" -- Thema dort unbekannt/nicht das Pruefungs-Konzept.
   KON121 (22.08. vormittags, Z.76) fuehrt zudem eine offene "R7 D-09 (a)/(b)"-Restfrage in
   DERSELBEN lokalen 22.08.-Nummerierung. **Diese SOLL-KARTE stellt fest: diese beiden D-09
   sind NICHT dasselbe Objekt** -- die 22.08.-Owner-Rueckfrage-D-09 hat KEINEN erkennbaren
   Sachbezug zu Paper->Prueflinge/PV-4/S-19-Input und beruehrt #89 nicht. Ein Audit-Fund "D-09
   ist noch offen (R7)" waere ein PHANTOM-Fund fuer #89.
5. **M14 "0 ranking-Treffer, nicht gebaut" (K4, Z.111) vs. Bericht "M14-Grammatik gebaut, TEIL
   3/T-G".** Kein echter Widerspruch, aber Praezisions-Punkt fuer das Audit: die Karten-Notiz
   "0 ranking-Treffer, nicht gebaut" beschreibt den STAND VOR #89 (die 0-Treffer-Gegenprobe im
   IST), NICHT eine Aussage gegen den Bau. Die K4-Zeile selbst erlaubt den Bau ausdruecklich
   ("[ID/W2]=I-5 Stempel-Farben ... real BAUT"). Wird hier nur benannt, damit das Audit die
   "0"-Zeile nicht als Verbot fehlliest.
6. **Keine juengere Ueberschreibung in par.21-23 gefunden.** Die Wellenplan-Paragraphen 21, 22,
   23 (Z.2876-3627, die gemaess Auftrags-Rangfolge VOR par.17-20 gelten wuerden) wurden VOLL nach
   "#89", "P-H" und "Paper" durchsucht -- KEIN Treffer. Das bedeutet: die #89-Definition aus
   par.18.8/par.19.4/par.20.5 (12.-17.08.) steht in den juengsten Wellenplan-Schichten
   UNWIDERSPROCHEN. Dies ist eine "Negativ-Pruefung" (Abwesenheit von Widerspruch), die das
   Audit nicht selbst wiederholen muss, aber als Beleg dafuer dient, dass D-4 die aktuellste
   verfuegbare Wellenplan-Fassung dieser Aufgabe ist.
7. **Slot-Konflikt Di-25 vs. Mi (bereits vom Lead entschieden, kein offener Punkt mehr).**
   W2-ABFOLGE-DESIGN TEIL5 Punkt 3 (Z.867-868) fuehrt den Konflikt noch als "Lead-Entscheid
   noetig"; LEAD-ENTSCHEIDE Punkt 3 (Z.7-9, selbes Dokumentenpaar, aber die spaeter geschriebene
   Entscheidungsdatei) loest ihn zugunsten "eigener Bau-Agent SOFORT" auf. Kein Audit-Fund noetig
   -- nur zur Vollstaendigkeit gefuehrt, damit die Reihenfolge der beiden Dokumente (Design VOR
   Entscheid) nicht als offener Widerspruch missverstanden wird.
8. **Designplan-tdd fuehrt keinen eigenen #89/P-H-Katalogposten.** Der Testklassen-Katalog
   (Z.33-108) wurde am 08./16.08. geschrieben, BEVOR Task #89 am 17.08. angelegt wurde
   (KON113-03). #89 unterliegt deshalb NUR dem allgemeinen T-1..T-9-Vertrag (P-14), nicht einem
   benannten MT-/ST-/PK-/AS-/PM-/AG-/XL-/HY-Posten. Kein Widerspruch, aber eine Luecke, die ein
   Audit nicht als "Designplan-Posten fehlt" fehldeuten sollte.
9. **H-11-ALIAS-KANON-RICHTUNGS-SPANNUNG (STAFFEL2-SYNTHESE, latent, nicht selbst-aufgeloest).**
   Der Strang p-h-89 legt sein eigenes Alias-Paar "w==compare" (D8) OHNE einen dritten,
   uebergeordneten Kanon-Namen fest -- die Paar-Notation laesst offen, ob "w" oder "compare" der
   kanonische Name ist (oder beide gleichrangig). Der SCHWESTER-Strang vollzug91 legt zeitgleich
   in der generischen `naming/begriffs_alias_registry.hpp` (M13) den Kanon FEST: "w->wallclock,
   compare->wallclock" -- ein DRITTER Name (wallclock) ist die kanonische Zielform, w UND
   compare sind gleichermassen Alias DARAUF (KON112-01c-Ursprung, dort schon als
   "Namens-Paar ... Harmonisierung als ERSTER ANWENDUNGSFALL der R-2-Alias-Registry" angekuendigt).
   Die beiden Registries beruehren laut STAFFEL2-SYNTHESE KEINE gemeinsame Datei (disjunkt), die
   Synthese selbst stuft die VOLLE Vereinheitlichung ausdruecklich als "FOLGE-Posten, keine
   Lande-Pflicht" ein UND empfiehlt eine Lande-REIHENFOLGE (vollzug91 vor ph89, s. P-23) als
   Entscheidungs-Verfahren, statt die Frage selbst zu entscheiden. Diese SOLL-KARTE zieht das
   NICHT glatt: ob ph89s "w==compare"-Paar der M13-Kanonrichtung "wallclock" WIDERSPRICHT (eigene
   konkurrierende Kanon-Behauptung) oder sie nur noch nicht AUFNIMMT (reine Teilmenge, die M13
   spaeter absorbiert), ist am Objekt (Diff beider Header nach beiden Merges) zu entscheiden, nicht
   aus den Quellen allein.
10. **NUMMERNKOLLISION "#89" IM WELLENPLAN SELBST (SELBST NICHT ge-cave't, PRUEF-FALLE fuer eine
    blinde Volltextsuche).** Wellenplan Z.1709 (par.14, 11.08.2026, VOR der Task-Anlage #89 am
    17.08.): Zeile "S-16 | `ci/tests/*.sh` -> Google Tests -- heute 14 Dateien / 8.528 Zeilen,
    wachsend | KON6-05, #89 | --". Dieses "#89" bezeichnet NICHT Board-Task #89 (der zu diesem
    Zeitpunkt noch gar nicht existierte), sondern einen ANDEREN, aelteren Nummern-Kontext (vermutlich
    eine Ledger-Zeilen- oder Quell-Referenz aus der damaligen par.14-Aufstellung, Gegenstand "Shell-Test
    zu Google-Test-Migration" -- inhaltlich VOELLIG UNVERWANDT mit Paper->Pruefling). Der Wellenplan
    selbst traegt an dieser Stelle KEINEN CAVE-Vermerk (anders als bei der dokumentierten
    "#44"-Kollision, SPANNUNG 2). Diese SOLL-KARTE stellt fest: eine Volltextsuche nach "#89" im
    Wellenplan OHNE Kontextpruefung koennte faelschlich Z.1709 (S-16/Google-Tests) statt Z.317-325
    (D-4/P-H) treffen -- fuer #89/P-H ist ausschliesslich die D-4-Zeile (Z.317-325, bestaetigt durch
    die explizite Korrektur Z.2717 "KORREKTUR Sweep B-4: ... NICHT Task #89 -- #89 ist P-H
    Paper->Prueflinge") massgeblich.

---

## FINDINGS-BESTAND-KREUZPROBE (STAFFEL2-SYNTHESE F-78..F-84 + H-9/H-11/H-12/H-13/H-16)

Diese Kreuzprobe ist KEINE eigene SOLL-Quelle (die Synthese stellt keine Forderungen auf,
s. QUELLEN-VERZEICHNIS), sondern eine vom Strang-Bericht UNABHAENGIGE Gegenlesung derselben
Bau-Ergebnisse durch den Staffel-2-Synthese-Prozess (21.08., nach dem Strang-Bericht). Sie
bestaetigt ganz ueberwiegend das, was der Strang-Bericht behauptet, und liefert zusaetzlich
Lande-Abhaengigkeiten (H-Reihe), die der Strang selbst noch nicht kennen konnte. Format:
Fund-Nummer -- Ort -- Fund -- Status lt. Synthese -- Bezug zu dieser Soll-Karte.

| Fund | Ort | Fund-Text (Synthese) | Status | Bezug hier |
|---|---|---|---|---|
| F-78 | xml_config_parser:284/validate_profile | profile_ref geparst, NIE dereferenziert | BEHOBEN | bestaetigt P-04 |
| F-79 | validate_profile (14) + XSD-Kommentar | template-ref-Toleranz war Altstand; XSD-Kommentar seit R-4 FALSCH | TEIL: Code hart (Branch), XSD-Kommentar OFFEN | bestaetigt P-05/P-11/P-12; die "TEIL"-Einstufung praezisiert: der C++-Anteil gilt der Synthese als erledigt, NUR der XSD-Kommentar-Halbsatz (Schema-Bedarf Nr. 1) bleibt offen -- deckungsgleich mit dem Bericht selbst |
| F-80 | test_experiment_parser.cpp | Alt-Test pinnte tolerant-Altstand | BEHOBEN (harmonisiert) | bestaetigt P-05 Endstand-Abschnitt |
| F-81 | Karte W2-C | "ext/paper-Organisation" am prt-art-Objekt nicht woertlich | DOKUMENTIERT | bestaetigt TEIL-1.3-Befund des Strangs (Karten-Hygiene-Fund, kein #89-Mangel) |
| F-82 | pruefling_stempel_farben.hpp | vampir_nfp (P33) Default-OFF lieferte 0.0.0-Sentinel | BEHOBEN | bestaetigt P-06 (Sentinel-Verbot) |
| F-83 | sota_catalog.hpp:132-141 | Organ-Zeile VOLLER Prueflinge haengt am SOTA-METADATEN-BLOCKER | OFFEN -- GETRAGEN (K-3-REST, nicht doppeln) | bestaetigt NICHT-GEFORDERT Punkt 3 wortgleich |
| F-84 | TEIL 6 der Ergebnis-Datei | 7 Schema-Bedarfe | OFFEN (s13-Schema-Zug) | bestaetigt P-12 |
| H-9 | tests/unit/CMakeLists.txt | Dateiende-Konflikt ueber 4 S2-Straenge (inkl. ph89) | Aufloesung: Reihenfolge-Aneinanderreihung, T-7 zaehlt am Endstand | praezisiert P-18: der Dateiende-Grundsatz bleibt gewahrt, nur die ctest-NUMMERN verschieben sich je nach Merge-Position -- kein #89-Mangel |
| H-11 | naming/begriffs_alias_registry.hpp (M13) vs. paper_pruefling_registry.hpp | Kanon-Richtungs-Frage w/compare vs wallclock, Dateien disjunkt | FOLGE-Posten, keine Lande-Pflicht; Reihenfolge-Empfehlung vollzug91-vor-ph89 | NEU als P-23 + SPANNUNG 9 aufgenommen (fehlte im Strang-Bericht) |
| H-12 | validate_profile.hpp vs. profile_run_entry.hpp (s13/messfenster) | kein Datei-Konflikt, F-24-Restposten bleibt bei s13 | kein Handlungsbedarf fuer #89 | bestaetigt: #89s validate_profile.hpp-Aenderung kollidiert mit keinem Schwester-Strang |
| H-13 | test_experiment_parser.cpp | ph89-Flip deckungsgleich mit juengerem R-4-Recht | kein Konflikt (Textnaehe-Pruefung falls messfenster dieselbe Datei beruehrt) | bestaetigt P-05 Endstand-Abschnitt exakt |
| H-16 | profile_facade/-Ordner | 3 Straenge (s19/ph89/trigfix) legen NEUE, disjunkte Koepfe an | disjunkt, nur Include-/Format-Sicht noetig | bestaetigt P-01/P-08 Dateiorte kollidieren mit keinem Schwester-Strang |

**Lande-Reihenfolge-Position (Abschn. 2.2 der Synthese):** #89 ist Schritt 7 von 10 in Phase 1
(ce/development), NACH vollzug91 (Schritt 6, wegen H-11) und VOR trigfix/skip97/kampvor
(Schritte 8-10) -- s. P-23.

**Nicht uebernommen (bewusst, kein Fund fuer #89):** die Synthese fuehrt unter Abschnitt 5.4
"M13-Absorption der ph89-Paper-Alias-Gruppen (H-11-Folge)" und "Emissions-Verdrahtung
paper_stamp_lines + M14-Report-Bau = nach-Trigger" explizit als STAFFEL-3-Folgeposten, NICHT als
#89-Landepflicht -- deckungsgleich mit NICHT-GEFORDERT Punkte 1/2 dieser Soll-Karte, hier nur
noch einmal durch eine ZWEITE, unabhaengige Quelle bestaetigt.

**Gegenprobe STAFFEL1-SYNTHESE.md (F-01..F-77):** 0 Treffer fuer "ph89"/"#89"/"P-H"/
"paper_pruefling_registry"/"Paper->Pruefling"/"Paper-Experiment" (Grep ueber die volle Datei,
285 Z.) -- erwartungsgemaess, da #89 ein Staffel-2-Strang ist; kein Fund dort verloren.

---

**Selbstcheck (ASCII):** Diese Datei ist bis auf woertliche Zitate aus Quelldokumenten, die dort
selbst Sonderzeichen fuehren (z. B. GOAL-v8/Designplan-Originalzitate mit Umlauten), in
ASCII-Konvention (ue/oe/ae/ss) verfasst; alle eigenen Formulierungen sind ASCII-only.
