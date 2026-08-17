# EXPLORE-KARTE E4 (REV2) — ALT-SESSIONS+TERMINE-SWEEP

Schnitt: docs/sessions/ (Juni/Juli) + docs/termine/ [PRIMAERQUELLE] + docs/audits/.
Massstab: kopf_referenz_kon60_93.md + ledger_gegenlese_karte.md (73 Posten Korb A-D)
+ KON94/95/96. Gegenprobe zusaetzlich gegen den vollen Live-Ledger
(docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md, 30076 Z.) gefahren, um
Kompakt-Extrakt-Kuerzungen nicht mit echten Luecken zu verwechseln.

**HINWEIS AN DIE SYNTHESE:** Unter diesem Pfad lag bereits eine FRUEHERE Fassung
dieser Karte (Fazit: "kein Fund"). Diese REV2 ersetzt sie — die fruehere Pruefung
hat andere Kandidaten (Drift-Gate, PAT-327, GH200, OD-7, Anhang B/E, Deadline
28.07.) korrekt als gedeckt verworfen, aber die beiden Haupttreffer unten sowie
das Register-Delta (Abschnitt 2) nicht gepruft/erwaehnt. Beide Fassungen stuetzen
sich gegenseitig, keine widerspricht der anderen an denselben Stellen.

---

## 1) ZWEI EIGENSTAENDIGE FUNDE (aus dem zugewiesenen Schnitt, gegen BEIDE
   Baseline-Ebenen — Kompakt-Extrakt UND vollen Live-Ledger — geprueft: 0 Treffer)

### FUND 1 — "Beste Tier-Binary als ABI-stabiles Produktions-Release" (UltiHash-Rahmen)
**Datum/Quelle 1:** Habich-Termin 7, 08.05.2026, H5 „CacheEngine als ABI-stabiler
Production-Container" — `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:180-202`.
Wortlaut (gekuerzt): *„Nach Abschluss der Experimente liefert die CacheEngine fuer
eine Plattform die beste Suchalgorithmus-Rekombination unter Optimierung. Diese
Optimal-Wahl wird ABI-stabil geladen + ueber std::map<>-aehnliches Interface in
Produktion verfuegbar [...] Production-Modus (ComdareDB-Verwendung) [...] Eine
Library, die im Experiment der Diplomarbeit den besten Algorithmus findet und in
der Produktion (ComdareDB spaeter) den besten Algorithmus [...] anbietet."*
**Datum/Quelle 2 (Verstaerkung, Owner selbst):** 25.06.2026, A1/B1 —
`docs/sessions/20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-CICD-MESS-ARCHITEKTUR.md:13-25,81`.
Wortlaut: *„[...] das Zurueckschreiben mindestens EINER Tier-Binary, die durch
Messung und Permutation als am schnellsten fuer ein Speicherinterface [...]
ermittelt wurde — um wiederum in einem anderen System als perfekte
Plattform-Binary-Release zu arbeiten. Die Cache-Engine ist konzeptionell von
UltiHash abgeleitet [...] Wir zeigen also hier das Konzept von UltiHash, OHNE den
Code darzulegen."* (dort als „Versprechen #172.1 'beste Binary'" benannt).
**Gegenprobe:** `ComdareDB` = 0 Treffer im gesamten Live-Ledger (30076 Z.);
`UltiHash` = 1 Treffer (Z.11910, ANDERER Gegenstand: Herkunfts-/Urheberschafts-
Vermerk des Achsen-KONZEPTS, nicht das Deploy-Artefakt); `Production-Container`,
`172.1`, `Plattform-Binary-Release` = 0 Treffer. Kein Auftauchen in kopf_referenz
oder gegenlese_karte. **Fremd-Korroboration (ausserhalb des Schnitts, nur als
Beleg dass der Fund real ist, nicht als Quelle):** `docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md:1185-1189`
fuehrt denselben Gegenstand als eigenen Posten „P-12 UltiHash-Konzeptrahmen" und
notiert selbst: *„Nirgends widerrufen, in Grundlage/Thesis-Doku unerwaehnt."*
Auch dieser Aug-07-Fund hat es NICHT in kopf_referenz/gegenlese_karte geschafft.
**Bewertung:** valide, nicht ueberholt (nichts in KON60-96 widerspricht oder
ersetzt das Produktions-Release-Konzept; die Lager-/Storage-Architektur [W9 in
gegenlese_karte] behandelt VERWAHRUNG von Messdaten/Binaries, nicht die
Freigabe der besten Binary als eigenstaendiges Deploy-Artefakt fuer ComdareDB —
verschiedene Gegenstaende). Dreifach unabhaengig aufgetaucht (Habich 08.05.,
Owner 25.06., Fremd-Audit 07.08.) und dreifach nicht weiterverfolgt.
**Ziel-Dokument:** Architektur-/Deploy-Kapitel (Artefaktklassen des Deploy-Stufe
9/10, neben Lager-Schreibback + Thesis-PDF) + Thesis-Einleitungskapitel
(Selbstverstaendnis-Baustein) + eigener Owner-Posten im Ledger (Bezug F6/#48
reicht nicht, da anderer Gegenstand).

### FUND 2 — Bausteine-Bewertung + Habich-Sign-Off-Pflicht je adaptiertem SOTA-/Baustein-Code
**Datum/Quelle:** Habich-Termin 7, 08.05.2026, H2 „Code-Qualitaets-Bewertung pro
Bausteine-Quelle" — `docs/termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt:60-101`.
Wortlaut (gekuerzt): *„Pro zerlegtem Algorithmus-Aspekt zu dokumentieren: QUELLE
(Original-Code-Datei + Zeilen-Bereich + Commit-Hash), ZIEL (Adapter-Header +
Funktion), BESCHREIBUNG (was wurde aequivalent geupdated, warum, mit welchen
Auswirkungen auf die Vergleichbarkeit) [...]"* Pflichtformat `BAUSTEINE_BEWERTUNG.md`
je Bausteine-Quelle, inkl. Feld **„Habich-Sign-Off: ausstehend | erteilt am
YYYY-MM-DD"**. Ziel: *„Integritaet der Vergleiche perfekt wahren."*
**Rechtliche Fundierung desselben Gegenstands (siehe auch Abschnitt 2, KON-39):**
Architekt-Direktive II, 08.05./bestaetigt 14.05.2026: *„Da wir alle
Algorithmus-Bestandteile zerschneiden, entsteht fuer alle Permutations-Achsen ein
neues Werk [...] muss nur der Autor beim Zitieren genannt werden."*
**Gegenprobe:** `Bausteine_Bewertung`, `Sign-Off`, `Habich-Sign`,
`Vergleichbarkeit-Bewertung` = 0 Treffer im vollen Live-Ledger UND im
Kompakt-Extrakt/gegenlese_karte. Termin 9 (29.05., docs/termine) benennt das
Risiko selbst noch ungeloest: *„Original-Implementierungsadapter noch nicht alle
messreif"* / *„wie strikt soll der Nachweis 'Original-Implementierungen nur als
Wrapper' bereits vor den ersten internen Messungen gefordert werden?"* — ohne
Rueckgriff auf die H2-Vorgabe. Fremd-Korroboration (ausserhalb Schnitt):
`20260807-GESAMTDOSSIER...md:1151-1155` fuehrt denselben Themenkreis als P-6
„Paper/Lizenz-Strang [...] Punktueller Pflegestand offen."
**Bewertung:** valide, nicht ueberholt — ≥8 SOTA-Baselines werden aktiv
weitergemessen (#162 im 25.06.-Board), die wissenschaftliche
Vergleichbarkeits-Dokumentationspflicht bleibt in Kraft, ohne dass ein
Formatnachweis (Datei, Feld, Sign-Off-Status) je entstanden ist.
**Ziel-Dokument:** Bausteine-/SOTA-Adapter-Register (neu, `BAUSTEINE_BEWERTUNG.md`-
Pflicht je Quelle) + Thesis-Anhang (Vergleichbarkeits-Offenlegung) + Owner-Vorlage
(Sign-Off ist ausdruecklich als Habich-Freigabe-Feld verlangt, nicht autonom
setzbar).

---

## 2) REGISTER-DELTA — ein bereits existierendes, nur TEILWEISE verbuchtes
   Owner-Wortlaut-Register mit Ursprung ueberwiegend in Juni/Juli

Der volle Live-Ledger enthaelt (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`,
ab Z.12395, „NACHTRAG 1 — KETTE/ARCHITEKTUR/ACHSEN (KON-01…KON-10)" und
fortlaufend mindestens bis KON-66) ein EIGENES, AELTERES, mit Bindestrich
gezaehltes Register (`KON-xx` ≠ `KONxx`, s. gegenlese_karte-Anker-Konvention),
das systematisch Owner-Wortlaute gegen den damaligen Bestand geprueft und mit
**FEHLT**/**DELTA**/**AUFGELOEST** gelabelt hat — inkl. Gegenprobe-Treffern.
gegenlese_karte nennt „KIII/KII-1 · KII-2" explizit als bereits verarbeitete
Eingangssegmente, und zwei Eintraege daraus SIND nachweislich durchgekommen
(KON-03 → W6 in gegenlese_karte; KON-40/42 → Korb D Punkt 13). Eine
Stichprobenpruefung der uebrigen Eintraege zeigt aber: mehrere weitere,
GENAUSO explizit als „FEHLT" gelabelte Eintraege mit Ursprung in MEINEM
Juni/Juli-Schnitt sind NICHT in kopf_referenz oder gegenlese_karte
wiederzufinden. Das Register ist zu gross (60+ Eintraege), um es hier vollstaendig
gegenzulesen — die folgenden sind Stichproben-bestaetigte Treffer, keine
vollstaendige Liste:

- **KON-26** (Z.12697) — *„RUNNER-INVENTAR 25.06.: Windows-Server-2022-Schluessel
  gekauft, node5/node6 macOS verkonfiguriert."* Owner/Infra 25.06.2026. Ursprung
  der Regel „concurrent=2 = halbe Host-Kerne"; spaeter durch OD-7 revidiert
  (`:8135`) — **ohne dass der Ursprung im Ledger stand**. Das erklaert die
  bereits im MEMORY.md selbst gefuehrte Konflikt-Notiz „prod1 = 16 Kerne/32
  Threads — OD-7 setzt 24: Konflikt" (deren URSACHE damit hier liegt, aber
  selbst nicht referenziert wird). Fundstelle im Schnitt:
  `docs/sessions/20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-CICD-MESS-ARCHITEKTUR.md`
  A2/B2 (dieselbe Owner-Aussage, dort bereits von mir unabhaengig gefunden).
- **KON-27** (Z.12708) — *„RF-3: OS-Fehlerklasse jetzt bauen, die Flotte steht
  bereit (Win11, WS2022, 7 Linux, 2 macOS)."* Owner 26.07.2026 (Punkt RF-3).
  Konkrete Flottenzahl fuer den `operating_system`-Unterachsen-Katalog — ohne
  sie ist der in MEMORY gefuehrte Fehlerklassen-Katalog nicht dimensionierbar.
  Fundstelle im Schnitt: `docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md`
  RF-3 (von mir unabhaengig gelesen, dort mit „OS-Flotten-Erhebung im
  Cluster-git per ultracode beauftragt" quittiert — der AUFTRAG wurde erteilt,
  das Ergebnis/die konkrete Flottenzahl aber nirgends in KON60-96 verbucht).
- **KON-31** (Z.12758) — *„Die CI/CD ist eigentlich das Fundament."* Owner
  25.06.2026, drei Saetze verbatim (Wurzelbegruendung der
  Pipeline-vor-Messlauf-Priorisierung; verbindet sich mit den geltenden
  MEMORY-Regeln „Pipeline immer hart gruen"/„allow_failure verboten", TRAEGT
  deren Begruendung aber selbst nicht). Fundstelle im Schnitt: dieselbe
  25.06.-Datei, A6/A7 (von mir unabhaengig gefunden).
- **KON-33** (Z.12780) — *„dev-FIRST-DEPLOY-GATE: Prod-DBs read-only in den
  dev-Cluster, Chaos-Verifikation vor jedem Prod-Deploy."* Owner 25.06.2026;
  Betriebsregel mit Datenschutz-/Integritaetsfolgen („nie auf prod schreiben",
  nur zwei sanktionierte Bruecken). Register selbst vermerkt: Wortlaut in der
  Ernte nicht mitgefuehrt, Gegenstand paraphrasiert — dennoch als **FEHLT**
  gefuehrt.
- **KON-39** (Z.12855) — *„Architekt-Direktive II: [...] Da wir alle
  Algorithmus-Bestandteile zerschneiden, entsteht fuer alle Permutations-Achsen
  ein neues Werk [...] nur der Autor beim Zitieren genannt werden [muss]."*
  Owner 08.05., bestaetigt 14.05.2026 — deckt sich mit FUND 2 oben (dieselbe
  Wurzel: Lizenz-/Herkunfts-Doktrin fuer zerschnittenen Baustein-Code). Ein
  spaeterer Ledger-Satz (`:15701`, Task #42) zitiert dieselbe Linie erneut
  OHNE Rueckverweis — das vom Owner selbst geruegte Symptom „Entscheidung wird
  jedes Mal neu erfunden."
- **KON-56** (Z.13075) — *„nie die einfachste, immer die sauberste UND
  wartbarste Strategie."* Owner 01.07.2026, verbatim. Register-Befund: MEMORY
  fuehrt diese Direktive **nur fuer Infra** (`feedback_infra_cleanest_not_easiest`,
  s. MEMORY.md „Weg"-Zeile). **Die Owner-Aussage selbst verallgemeinert sie
  ausdruecklich auf ALLEN Code** — diese Verallgemeinerung ist nirgends
  nachgezogen; die aktuelle Memory-Verlinkung ist damit ENGER als der
  zugrundeliegende Owner-Satz.

**Einordnung:** Diese sechs Eintraege sind keine acht Einzelfunde von mir,
sondern Bestaetigungen/Ergaenzungen eines FREMDEN, bereits existierenden und
selbst sauber sourcierten Registers — das Register selbst ist damit der
eigentliche Fund. Da nur 2 von den in der Stichprobe geprueften 8 Eintraegen
(KON-03, KON-40/42) den Weg in kopf_referenz/gegenlese_karte gefunden haben,
ist die Wahrscheinlichkeit hoch, dass unter den restlichen ~55 Eintraegen dieses
Registers (KON-01/02/04-25/28-30/32/35-38/41/43-55/57-66, ueberwiegend datiert
Mai-Juli 2026) weitere echte Luecken stecken, die ich in der verbleibenden Zeit
nicht mehr einzeln gegenlesen konnte.
**Ziel-Dokument:** eine EIGENE Konsolidierungs-Stufe (Vorschlag: „KON97" o.ae.),
die `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` ab Z.12395 („NACHTRAG 1 —
KETTE/ARCHITEKTUR/ACHSEN") Eintrag fuer Eintrag gegen KON60-96 gegenliest — mit
demselben Verfahren, das dort bereits für KON-03/40/42 sichtbar funktioniert hat.
Diese Stufe faellt inhaltlich in denselben Korb wie Korb D #17 der
gegenlese_karte (KON58-05/-10, Wellenplan-Abgleich), ist aber ein eigener,
bisher nicht benannter Posten.

---

## 3) GEPRUEFT UND ALS GEDECKT/UEBERHOLT VERWORFEN (keine erneute Meldung)

- **A2/A3 (25.06., Windows-Server-2022-KVM-Gast, ZIH-Power/AArch64) +
  RF-3-Flottenzahl als GENERELLES Multi-OS-Vorhaben:** das UEBERGEORDNETE Thema
  „Flotte nie gebaut" ist bereits als lebende Luecke gefuehrt
  (`reference_es_wurde_nie_eine_flotte_gebaut...`, KON71 „Flotten-Auftrag").
  Nur die KONKRETE Flottenzahl/der Ursprungspunkt (KON-26/27 oben) fehlt — das
  wird oben separat gemeldet, das generelle Thema nicht doppelt gebucht.
- **V80-Filterpod-Netzwerkisolation (12.07. Infra-Handover):** ausfuehrlich im
  vollen Ledger dokumentiert (`measure-drop`-Filterpod, V80, KON15/KON33-
  Cluster-Eintraege, VLAN/SNI-Doktrin) — gedeckt, kein Fund.
  Hinweis: der hier gefundene KON-33 (Abschnitt 2) ist ein ANDERER Gegenstand
  (dev-Cluster-DB-Spiegel-Gate), keine Verwechslung mit dem Filterpod.
- **#184/#185 (Nicht-YCSB-Workloads: TPC/SOSD/SPEC/CloudSuite/mimalloc-bench,
  TPIE/EM-BFS-I/O-Achse) sowie das komplette Datensatz-Register (AP-10/#244/#269,
  6er- vs. 48er-Katalog):** im vollen Ledger extrem dicht getrackt (Dutzende
  Eintraege 06.-08.07., #25/#45 vollzogen, laufende Praezisierungen) — gedeckt,
  kein Fund.
- **V42-Cluster (comdare-succinct/SDSL-C++23-Port, comdare-rcu, HBM Abstract
  Factory — Habich-Termin-7 F2/F3/F4, gebuendelt 26.05. als V42.P1.1-3):** die
  wortgleichen Bausteinnamen tauchen im vollen Ledger nicht mehr auf, ABER die
  Aufgaben-NUMMER lebt weiter (`#10 V42-Infra+Nicht-SA-Gattungs-Docks`,
  ausdruecklich „explizit-deferred"/„GEPARKT, niedrig") — bewusst zurueckgestellt,
  nicht vergessen. Der Bezeichner „V42" wurde zusaetzlich fuer ein SPAETERES,
  andersartiges Sequence-/Container-/Graph-Dock-Increment wiederverwendet
  (Namenskollisions-Risiko, aber kein neuer Fund fuer DIESE Karte).
- **search_organ_-Monolith-Delegation (#188, 25.06. A10):** vollstaendig
  erledigt (`Phase 3 (#188 search_organ_) ERLEDIGT`, mehrere Etappen bis
  10.07.).
- **page_type-Heimat (offen lt. 20.07.-Log):** innerhalb desselben Schnitts
  (26.07., `20260726-AUFTRAG-lane-a-sys-tax-und-lane-c-hub.md`) bereits
  aufgeloest — kein Fund.
- Termin 9-11 (29.05./05.06./19.06., .docx, per Zip/XML-Extraktion gelesen) sind
  reine Vor-Termin-Vorschlagsdokumente ohne buchbare Owner-Zusagen; ihre
  Architektur-Inhalte (Rang/Tier-Sprache, 19-Achsen-Modell) sind durch die
  seither mehrfach umgebaute Architektur ueberholt — mit EINER Ausnahme: Termin
  11 (19.06.) Arbeitsauftrag P3/P4 (Anhang B Code-Struktur DE vervollstaendigen,
  Kapitel-1-3-Glaettung nach Habich-Feedback) — beides niedrige Prioritaet,
  thesis-redaktionell, nicht Architektur; nicht als Kernfund geführt, da nicht
  mit Sicherheit von der seitherigen Thesis-Arbeit (PDF DE 202/EN 192 laut
  KON77) unerledigt ist — reine Erwaehnung ohne Gegenprobe-Moeglichkeit im
  verfuegbaren Zeitfenster.
- docs/audits/ (48 Dateien, alle Juli): technische Code-Schulden-Funde (REV-CXX/
  REV-DATA-Register in `20260716-wp5-rev-mining-DISPOSITION.md`), keine
  Owner-Zusagen; das Dokument ist selbst noch am 14.08. aktiv nachgezogen worden
  (Wellen-2-Bezug) — self-covering, kein Fund. `20260719-konsolidierung-
  register-post-crash-REGISTER.md` P-1..P-12 wurde als Cross-Check-Werkzeug
  benutzt (s.o.), nicht als eigene Quelle im Schnitt.

---

## 4) BILANZ FUER DIE SYNTHESE

2 eigenstaendige, dreifach/zweifach unabhaengig belegte Funde (FUND 1, FUND 2) +
1 Meta-Fund (Abschnitt 2: ein bereits existierendes ~60-Eintraege-Register mit
mindestens 6 bestaetigten, nicht durchgekommenen Posten aus Juni/Juli — mit
hoher Wahrscheinlichkeit auf weitere ungeprüfte Treffer). Alle drei Funde sind
NICHT durch KON60-96 gedeckt und nicht ueberholt. Empfehlung: FUND 1 und FUND 2
direkt als neue Owner-Vorlage-Posten aufnehmen; das Register-Delta (Abschnitt 2)
als eigenen Arbeitsauftrag "Nachtrag-1-Register vollstaendig gegen KON60-96
gegenlesen" einplanen, bevor es als geschlossen gilt.
