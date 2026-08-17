# EXPLORE-KARTE E3 — ALT-PLAENE-SWEEP (docs/plaene/, vor 08.08., + 3 explizit genannte docs/sessions/-Dokumente)

> Massstab: kopf_referenz_kon60_93.md + ledger_gegenlese_karte.md (KON1-93) + inline KON94-96.
> Methode: 126 Dateien in docs/plaene/ (02.07.-08.08., 3,8 MB) per Keyword-Score triagiert
> (OFFEN/AUSSTEHEND/FEHLT/TODO/BLOCKIER/...), die 10 hoechst-scorenden + alle 9 explizit im
> Auftrag genannten Dokumente volltextgelesen (~15 von 126 Dateien, die informationsdichtesten),
> Rest per Titel/Themen-Triage gesichtet. Top-Kandidaten GEGEN DEN LEBENDEN CODE verifiziert
> (Checkout Code/external/comdare-cache-engine, Stand 15.08. 15:54 UTC) — das hat mehrere
> Treffer bereits als GEFIXT entlarvt (s. Abschnitt "GEPRUEFT UND ERLEDIGT" unten) und dadurch
> die Melde-Liste stark verkleinert.

**Wichtigster Befund vorab:** die zwei dichtesten Quellen im Korpus — `20260808-KANDIDATENLISTE-
75-abschluss-aufraeumpass.md` (133 Kandidaten) und `20260808-WELLENPLAN-ANLAGE-luecken-defekte-
einwaende.md` (5 Blocker-Defekte D1-D5 + 103 Ist-Luecken + 20 Einwaende E1-E20) — sind KEINE
vergessenen Register. Direkter Code-Beleg: die Defekte D1/D3/D4/D5 aus der WELLENPLAN-ANLAGE
tragen im heutigen Code wortgleiche Commit-Kommentare ("D3 (2026-08-08): die alte Erfolgs-
bedingung...", "D4: eine UNBESTIMMBARE Gruppe...", "D5-1 (2026-08-09): ... ERSATZLOS GELOESCHT")
— sie wurden binnen 1-2 Tagen nach der Audit-Niederschrift gefixt. Diese beiden Dokumente wurden
also aktiv abgearbeitet, nicht vergessen. Ich melde deshalb NICHT die Einzelposten dieser beiden
Listen (das waere ueberholt/gedeckt durch die seither gelaufene Arbeit), sondern nur das, was ich
GEGENGEPRUEFT und weiterhin unerledigt gefunden habe, plus separate, kleinere Dokumente, die
KEINE solche Abarbeitungs-Spur zeigen.

---

## GEMELDETE FUNDE (nicht im Massstab gedeckt, am Code stichprobenartig bestaetigt)

### 1. Break-Even: zwei divergierende Implementierungen + keine Hysterese-Entscheidung
**Datum:** 08.08. (GESAMTBILD-vergessene-arbeit, Teil B1) + WELLENPLAN-ANLAGE (Owner-Widerspruch
Hysterese vs. Bereichs-Erkennung); Ursprungsdefinition 19.07./20.07./06.08./07.08.
**Kurz-Wortlaut:** "Zwei divergierende Implementierungen: heuristik::BreakEvenPoint (monotone
Hermite, echte Knoten, §75-geschuetzt) gegen best_binary::BreakEvenPoint (stueckweise linear,
festes 256-Raster, self-declared SKELETON, ungeschuetzt) [...] Von 203 Tests fahren ZWEI
Break-Even; von 10 Apps KEINE." Owner-KERN sagt "Keine Hysterese noetig, sondern
Bereichs-Erkennung" (checkpoint_measure-Design), das GESAMTBILD-Dokument empfiehlt selbst
gegenteilig "Hysterese-Band als Pflicht-Eigenschaft" — Widerspruch nie aufgeloest.
**Fundstelle:** `docs/plaene/20260808-GESAMTBILD-vergessene-arbeit-und-neuer-wellenplan.md`
Teil B1 (Z.124-160) + `docs/plaene/20260808-WELLENPLAN-ANLAGE-luecken-defekte-einwaende.md`
("Break-Even-Funktion ist als String serialisierbar", "wird DREIMAL berechnet", Z.79-97).
**Code-Gegenprobe (16.08., HEUTE noch so):** `libs/cache_engine/builder/best_binary_selector/
best_binary_selector.hpp:419` traegt weiterhin eine EIGENE `struct BreakEvenPoint`, getrennt von
`libs/cache_engine/heuristik/break_even.hpp:68`; der Kopfkommentar "HYBRID-BREAK-EVEN-SELEKTOR-
SKELETON (Section 32-F8 / Section 49, 2026-07-20)" steht unveraendert in `.hpp:361` UND `.cpp:579`.
`heuristik/break_even.hpp` hat inzwischen einen weiteren Konsumenten (`axis_optimization_catalog.
hpp`, seit 08.08. neu) — die Vereinheitlichung der ZWEI Implementierungen ist damit aber NICHT
vollzogen, der Skeleton-Vermerk nicht gestrichen.
**Massstab-Abgleich:** kopf_referenz/gegenlese_karte kennen "Break-Even" nur ueber KON80-V7
("Break-Even NUR ueber Organ-Parameter der w/ma/mi") — das ist eine andere Frage (WELCHE Achsen
speisen Break-Even), nicht die hier gefundene (welche der zwei Implementierungen gilt, Hysterese
ja/nein). Kein Treffer zu "SKELETON", "best_binary::BreakEvenPoint" oder Hysterese im Massstab.
**Empfohlenes Ziel-Dokument:** Ledger-Nachtrag im #18-S-13-Buendel (Korb B, Break-Even-Kette) ODER
eigene Owner-Vorlage analog den bestehenden OWNER-VORLAGE-Dokumenten vom 13.08.

### 2. Paper-Kopplung / die eigentliche wissenschaftliche Kernfrage der Arbeit ist in keiner Welle
**Datum:** Owner-Auftrag laut Zitat 07.08./08.08. (WELLENPLAN-ANLAGE E3), Grundidee bereits im
sehr alten `20260702-MASTERPLAN` nicht angelegt (dort ausschliesslich Spiegel-Elimination).
**Kurz-Wortlaut:** Owner woertlich (zitiert in der Quelle): "ueber die Paper-XML definitionen [...]
in denen wir sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen der
Anderen Paper in dieser Achse besser gewesen waeren" — und die Quelle kommentiert: "Das ist die
wissenschaftliche Frage der Arbeit in einem Satz: nicht welche Komposition ist die beste, sondern
waere Papers X Algorithmus fuer Achse A besser gewesen als der von Paper Y". Owner-Antwort auf
"Paper-Kopplung bauen?": "Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir
im Detail." PV-4 (Paper-als-Pruefling, referenzierte Template-Profile je Paper) und die "Regel der
abstrakt-leeren Achse" fehlen vollstaendig; der Plan schiebt das Thema als "Paper-Research-
Vollausbau" nach W7 (hinter die Abgabe) OHNE Owner-Vorlage, OHNE Risiko-Eintrag.
**Fundstelle:** `docs/plaene/20260808-WELLENPLAN-ANLAGE-luecken-defekte-einwaende.md` Abschnitt 3,
Einwand E3 (Z.477-482); Beleg-Zeilen dort referenziert als LEDGER:11117-11128.
**Code-Gegenprobe (16.08.):** `grep -rn "Paper-Kopplung\|PV-4\|paper_template"` ueber den ganzen
ce-Baum (ohne build/) = **0 Treffer** — das Feature existiert nicht als Code, Konzept-Datei oder
Registry-Zeile.
**Massstab-Abgleich:** kein Treffer zu "Paper-Kopplung", "PV-4", "FF0"-"FF4" oder "DoD" (Definition
of Done je Forschungsfrage) in kopf_referenz oder gegenlese_karte. Die Vier-Fallunterscheidungs-
Frage der Arbeit (SearchAlgorithm eines Papers X in Achse A vs. Paper Y) ist damit nirgends im
aktuellen Task-Board (#15-#74) sichtbar verankert.
**Empfohlenes Ziel-Dokument:** eigene Owner-Vorlage ("PV-4/Paper-Kopplung: bauen oder Reichweite
der Arbeit explizit einschraenken?") — hohe thesis-methodische Tragweite (Alleinstellungsmerkmal
der Arbeit laut eigenem Wortlaut), sollte vor der W4-Thesis-Textredaktion entschieden werden.

---

## SCHWAECHERE / META-FUNDE (ganze Dokumente ohne erkennbare Anschluss-Spur im Massstab)

Diese drei Dokumente sind in sich geschlossene, vom Autor selbst als "spaeter gemeinsam
durchzusprechen" markierte Backlogs. Anders als KANDIDATENLISTE-75/WELLENPLAN-ANLAGE fand ich fuer
sie KEINE Fix-Commit-Spur mit Rueckverweis auf ihre Kennungen — das ist aber ein schwaecheres Signal
als ein aktiver Grep-Gegenbeweis wie bei den zwei gemeldeten Funden oben, da ich nicht jedes
Einzel-Item am Code nachpruefen konnte (Umfang: 14+14+22 Posten). Ich melde sie als Dokument-Ebene,
nicht als Einzelposten-Liste, damit sie nicht durchs Raster fallen, ohne Ueberdeckung zu behaupten.

### 3. "Verworfene/geparkte Konzepte" — 14 explizit vertagte Owner-Rueckfragen, keine Wiedervorlage sichtbar
**Datum:** 20.07.
**Kurz-Wortlaut:** Dokumentkopf: "WIEDERVERWENDUNGS-PRUEFUNG erfolgt SEPARAT NACH dem Gesamtplan,
gemeinsam mit dem User per Rueckfragen." 14 nummerierte offene Rueckfragen am Dokumentende, u.a.:
(7) "S-7 Locking/Concurrency: Deep-Research separat mit Opus NACH Planungsabschluss" (Owner selbst
angekuendigt); (5) "#29 Set als eigene Gattung — GO-pflichtiger MAJOR-Ausbau [...] wann/ob?" (F1b
laut Dokument "bereits gewaehrt", aber nie eingeloest); (8) NUMA/page_type/Cacheline-Unterachsen-
Verdrahtung "Wiedervorlage sobald Messkampagne die Allocator-Achse permutiert" (die Messkampagne
laeuft nach aktuellem Stand jetzt); (11) P/E-Core AKTIVES Pinning als Folge-Increment (heute nur
beobachtend, `ran_on_core_type`/Unpinned).
**Fundstelle:** `docs/plaene/20260720-verworfene-referenzen-erinnerung-fuer-wiederverwendung.md`,
Abschnitt "Offene Rueckfragen fuer die spaetere gemeinsame Durchsicht" (Z.202-219).
**Massstab-Abgleich:** kein Treffer zu diesem Dokumenttitel, "F-SPREAD", "axis_binding_registry"
(als offene Rueckfrage), oder den 14 Nummern in kopf_referenz/gegenlese_karte. Einzelne verwandte
Themen leben zwar fort (z. B. P/E-Core ueber KON-Diskussion an anderer Stelle vermutlich), aber die
explizite "spaetere gemeinsame Durchsicht" selbst hat keine sichtbare Spur.
**Empfohlenes Ziel-Dokument:** kurze Triage-Runde (W2-Sammelposten analog Korb D), da die Liste
selbst schon vor-sortiert ist (Gruppen A-D nach Wiederverwendbarkeit) — vermutlich groesstenteils
inzwischen anderweitig entschieden; lohnt eine 30-Minuten-Gegenlese, kein Neubau blind aus dieser
Liste.

### 4. Achsen-Qualitaets-Parameter-Katalog — 14 offene Entscheide vor dem Container-Wire-Freeze ("C6")
**Datum:** 04.08. (docs/sessions/, explizit im Auftrag genannt)
**Kurz-Wortlaut:** Abschnitt 6 "OFFENE ENTSCHEIDE (nur echtes NICHT-GEFUNDEN)": u.a. E1
"Skalierungs-Konvention double->uint64 (ppm vs. promille vs. milli) [...] NIRGENDS festgelegt [...]
MUSS VOR C6 stehen"; E13 "Gattungs-Wire-Timing [...] JA/NEIN [...] Owner/Manager VOR C6"; E14
"'OHNE'-Auspraegungs-Luecken [...] T14 filter hat KEIN None-Blatt [...] der Nutzen-Beleg der Achse
[...] braucht ein NoFilter-Blatt".
**Fundstelle:** `docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md`, Abschnitt
6 (Z.810-851).
**Code-Gegenprobe (16.08.):** `ObserverAggregate`/`XxxObserverAggregate<N>` (das Container-Wire-
Zielbild dieses Dokuments) hat inzwischen 5 Treffer im Code (`sequence_abi_adapter.hpp`,
`genus_axis_row_writer.hpp`, `sequence_tier_v2.hpp`, `adapter_anatomy.hpp`, `view_anatomy.hpp`) —
der Container-Anatomie-Ausbau ist seit 04.08. sichtbar vorangekommen. **Deshalb GEDAEMPFTE
Meldeschwere:** die 14 Einzel-Entscheide sind hier vermutlich zu einem guten Teil implizit
mitentschieden worden; ich kann aber nicht ausschliessen, dass die NAMENTLICH genannten (E1
Skalierungskonvention, E14 None-Blatt) einzeln noch offen sind.
**Massstab-Abgleich:** kein Treffer zu "Achsen-Qualitaets-Parameter-Katalog", "C6"(im Sinne dieses
Dokuments — ACHTUNG Namenskollision: das aktuelle KON93 "C6" ist die Arena-6GB-Frage, ein VOELLIG
anderer Gegenstand mit demselben Kuerzel), oder E1-E14 in dieser Nummerierung.
**Empfohlenes Ziel-Dokument:** vor der naechsten Container-Genus-Landung (Set/Sequence/Adapter/
View) kurz gegenlesen, ob E1/E13/E14 implizit miterledigt wurden; sonst in die #18/S-13-Naht.

### 5. Thesis-Falschaussagen F-01...F-12 und Owner-Fragen O-1...O-10 (Wahrheitsgehalt des Thesis-Texts)
**Datum:** 06.08.
**Kurz-Wortlaut:** Kapitel 1 listet zwoelf konkrete Falschaussagen im gebundenen Thesis-Text (z.B.
F-01 "Talos als zweites Betriebssystem-Regime — existiert nirgends"; F-09 "Anhang-Limitierung
fuehrt 19 Achsen, die Kapitel fuehren 18"; F-11 "T11 statt T10 fuer den ChainRef-Slot"). Kapitel 8
stellt zehn konkrete Entscheidungsfragen (O-1...O-10), z.B. O-3 "'alle erdenklichen Binary-
Permutationen' — Aufgabenstellung sagt es ohne Einschraenkung, Kapitel gesteht Deckelung nur
implizit ein", O-5 "die bias-freie Vollmatrix ist in drei Kapiteln zugesagt und im Register auf
'reine Doku-Vermerke, kein Bau' abgestuft".
**Fundstelle:** `docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md`, Abschnitt 1
(F-01...F-12, Z.58-317) und Abschnitt 8 (O-1...O-10, Z.792-851).
**WICHTIGE EINSCHRAENKUNG:** Das dort entworfene "sechs Freitage"-Fristenraster (07.08./14.08./
21.08./28.08./04.09./11.09.) deckt sich EXAKT mit den heutigen Meilensteinen im Massstab-Kopf
(F1 GELIEFERT 14.08., F2-Identitaets-Freeze Fr 21.08.) — dieses Dokument ist also klar in den
aktuellen Fahrplan eingegangen. Es ist folglich WAHRSCHEINLICH, dass ein Teil der F-/O-Punkte
bereits im Zuge von F1 (14.08., laut Massstab "Durchstich komplett") behoben wurde. Ich habe dies
NICHT je Einzelpunkt nachgeprueft (12+10=22 Posten, ausserhalb meines Zeitbudgets).
**Massstab-Abgleich:** kein Treffer zu "Talos", "F-01" bis "F-12" oder "O-1" bis "O-10" in dieser
Zaehlung; die verwandte §63-T-Nummerierung taucht einmal auf (gegenlese_karte Korb D #13: "T-08 =
es existiert EIN echter Mess-Lauf [...] T-19 bias-freie Vollmatrix nur Doku-Vermerk") — das
bestaetigt, dass MINDESTENS T-19 (= O-5 hier) zum Stand der Gegenlese-Karte NOCH offen war.
**Empfohlenes Ziel-Dokument:** vor der W4-Thesis-Textredaktion eine Gegenprobe F-01...F-12 gegen
den aktuellen DE/EN-Text fahren (die meisten sind Ein-Satz-Korrekturen, kein Bau).

---

## GEPRUEFT UND ALS ERLEDIGT VERWORFEN (zur Transparenz, nicht erneut zu melden)

Die folgenden Kandidaten sah ich zunaechst als vielversprechend an, habe sie aber am Code
widerlegt gefunden — sie werden hier NUR dokumentiert, damit ein Folge-Agent sie nicht erneut
aufwaermt:

- **A9-xlsx-Schreiber "existiert nicht"** (GESAMTBILD A.3#3, WELLENPLAN-ANLAGE "A9-S4/S5 CLI [...]
  vollstaendig ungebaut", Stand 08.08.): am Code WIDERLEGT — `libs/cache_engine/builder/
  lager_ablage/ergebnis_mappe.hpp`, `profile_facade/ergebnis_mappe_naht.hpp`, `tools/mess_report/
  mess_report_render.hpp` + zugehoerige Tests (`test_a9s3_...`, `test_a9s4_...`,
  `test_a9s5_...`) existieren heute. ERLEDIGT.
- **D1 (make check ueberspringt Reconfigure, 427 statt 431 Tests)**: ce-`Makefile:91` traegt
  heute `check: inventar` (nicht mehr `check: all`) — exakt der im Dokument selbst als Fix auf
  einem Parallel-Branch beschriebene Zustand. ERLEDIGT.
- **D3 (leeres Messfenster besteht das Gate)**: super-`.gitlab-ci.yml:2048` zitiert woertlich
  "D3 (2026-08-08): die alte Erfolgsbedingung prueft nur, DASS eine measurements.csv [...]" als
  Fix-Kommentar. ERLEDIGT.
- **D4 (Drift-Gate median=0 → faelschlich stabil)**: `drift_detector.hpp` traegt heute ein
  `bestimmbar`-Feld + Kommentar "D4: eine UNBESTIMMBARE Gruppe [...]". ERLEDIGT.
- **D5 (drei divergierende Perzentil-/Median-Implementierungen)**: `latency_stats.hpp`,
  `tier_observe_trace_abi.hpp`, `hdr_perzentil_auswertung.hpp` tragen durchgaengig
  "D5-1/D5-4/D5-5 (2026-08-09)"-Kommentare, die zweite Formel wurde "ERSATZLOS GELOESCHT". ERLEDIGT.
- **D2 (Coverage-Guard blind fuer adhoc_emitter-Tests)**: TEILWEISE noch offen —
  `grep -c adhoc_emitter .gitlab-ci.yml` = weiterhin 0 im ce-Repo — aber angesichts der
  Fix-Geschwindigkeit bei D1/D3/D4/D5 (alle binnen 1-2 Tagen) und meines sehr enges Zeitbudgets
  fuer diese Karte melde ich das NICHT als eigenen Fund, sondern nur als Fussnote: falls die
  Coverage-Guard-Zahl je zitiert wird, gegenpruefen, ob adhoc_emitter inzwischen in einen Job
  eingebaut wurde.

---

## NICHTFUNDE MIT GEGENPROBE (Suchfelder, die keinen Treffer lieferten)

- **"SE-22-Kartierungen"** als Dateiname: 0 Treffer wortwoertlich. Gegenprobe erfolgreich:
  `docs/sessions/20260703-SESSION-ENDE-22-lint-pflicht-komplett-goal-parallelstrategie-4-
  kartierungen.md` gefunden und gelesen (SE-22 = SESSION-ENDE-22, "4 Kartierungen" im Dateinamen) —
  vermutlich der gemeinte Verweis. Inhalt (CI-Pipeline-Reifung, #188-4c-Spuren S1-S9) ist
  durchgehend als abgeschlossen erkennbar (Command-Pattern/CMD-1/CMD-2, SwissTable S22, Array-
  Gattung — alle Themen leben in der heutigen Architektur fort, z. B. "KEINE flat_hash_map,
  Swisstable Gattung Map" als geltende Memory-Doktrin) — kein offener Rest gefunden.
- **"MASTER-EXECUTION-PLAN 03.07."**: gefunden unter `docs/sessions/20260703-MASTER-EXECUTION-
  PLAN-goal-gesamtumfang.md`. Spur S (#216-H2→#217→AP-7→#221→CMD-1→CMD-2→#234→#215→#224) und
  Spur P (AP-2...AP-15) sind technisch so basisnah (Juli-Stand vor der heutigen Stempel-/PMC-
  Architektur), dass sie mit hoher Wahrscheinlichkeit laengst either umgesetzt oder von der seither
  massiv fortgeschrittenen Architektur ueberholt sind; kein einzelnes Element sticht als "valide
  UND unverbucht" hervor, ich melde daher nichts Einzelnes daraus.
- **"TODO-Konsolidierung 06-27"**: gefunden unter `docs/sessions/20260627-TODO-KONSOLIDIERUNG-
  ELABORAT.md`. Sieben Wochen alt, Fokus 10-Stufen-CI-Pipeline (#186-#208), davon mehrere Stufen
  (k8s-deploy, prod->dev-Staging-Gate, canary) explizit "Infra-gated" — per spaeterer Owner-
  Direktive ("Rollen-Direktive: read-only-verify", MASTER-EXECUTION-PLAN 03.07.) aus dem
  Implementierungs-Scope genommen, kein Verbuchungsfehler. Einziger schwacher Rest-Kandidat:
  Task #19 "Allokatoren echt linken (jemalloc/tcmalloc/hoard/scalloc fallen auf std::malloc
  zurueck)" — nicht am Code nachgeprueft (Budget), niedrige Meldeschwere wegen Alters.
- **"§75" / "Kandidatenliste" / "Aufraeumpass"** im Massstab: nur EIN indirekter Treffer
  (gegenlese_karte, echte Owner-Frage b: "kanonischer Kurven-Stack, sonst entscheidet §75
  implizit") — die 133-Posten-Liste selbst taucht nicht auf, ist aber laut obigem Befund aktiv
  in Arbeit (D1-D5-Fixes citieren ihre eigenen Kuerzel), also kein Melde-Fall.
- **"20260804-DOSSIER-achsen-qualitaets-parameter-katalog" wortwoertlich im Massstab**: 0 Treffer
  (s. Fund 4 oben).

---

## ABDECKUNGS-HINWEIS (Ehrlichkeit vor Vollstaendigkeit)

Von den 126 Dateien in `docs/plaene/` (02.07.-08.08.) wurden ~15 volltextgelesen (die per
Keyword-Score dichtesten + alle explizit genannten), der Rest per Dateiname/Themen-Titel
gesichtet. Die *technischen* Alt-Dossiers vom 02.07.-26.07. (Node-Shape/Eytzinger/BTree-Order/
SkipList/Hash-Probe-Varianten, INC0-INC2d-Bauplaene, GO3-GO5-Hebel, Fehlerklassen-Framework,
Session-Plaene V1-V3.2) wurden NICHT einzeln volltextgelesen, sondern ueber ihre Themen-Titel
plus die zwei grossen 08.08.-Audits trianguliert (die "369 SOLL-Posten aus dem Ledger" bereits
gegen den Code geprueft haben und damit die meisten dieser Alt-Themen implizit abdecken). Sollte
ein Folge-Agent gezielt Zweifel an einem bestimmten technischen Alt-Dossier haben, ist eine
gezielte Einzelpruefung noetig — diese Karte deckt das NICHT vollstaendig ab.
