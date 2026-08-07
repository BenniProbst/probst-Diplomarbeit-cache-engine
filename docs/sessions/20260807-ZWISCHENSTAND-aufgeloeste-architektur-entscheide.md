# ZWISCHENSTAND 07.08.2026: der GESAMTE Kontext + alle aufgeloesten Architektur-Entscheide

> Owner-Auftrag: "Bitte schreibe eine Zwischenstanddoku ueber den GESAMTEN Kontext und alle bis
> hierhin aufgeloesten Architektur-Entscheide und Loesungen."
> SPANNE: dieser Kontext (07.08. ~05:00 bis mittags) -- Neugruendung nach Compact, Wiederaufnahme
> des Hauptstrangs, sieben Owner-Runden.
> ALLES am Objekt gemessen gegen ce `aa223961` / super `200366eb` / thesis `19e1592`.
> ASCII (Paragraph erlaubt). Ergaenzt -- ersetzt NICHT -- das Gesamt-Dossier
> `20260807-GESAMTDOSSIER-aktuell-jetzt-konsolidiert.md`.

===============================================================================
## 0. STAND IN FUENF SAETZEN
===============================================================================
1. Der HAUPTSTRANG laeuft wieder: das numa-Paket (core_class = Ausfuehrungs-Lokalitaet,
   Owner-KERN 8) ist ueber BEIDE Repo-Haelften gelandet, alle vier Refs gleichauf --
   ce `aa223961`, super `397710d2`, Kette T-1 vollstaendig vollzogen.
2. SIEBEN Architektur-Entscheide sind aufgeloest (Abschnitt 2). Bei DREI davon lag der Lead
   falsch und wurde vom Owner korrigiert; die Korrekturen sind belegt eingearbeitet.
3. DREI vermeintlich offene Fragen waren in Wahrheit BAU-RUECKSTAND, keine Entscheidung
   (T-8 Pareto-Front, T-9 Min/Max-Katalog, T-10 Last-Erkennungsheuristik) -- sie kosten Arbeit,
   nicht Rueckfrage.
4. DREI FALSCHBEFUNDE derselben Bauart an einem Tag fuehrten zur wichtigsten Methoden-Lehre:
   eine Negativ-Suche ist nur so gut wie ihr VOKABULAR (Abschnitt 6).
5. ZWEI neue Defekte mit Mess-Relevanz gefunden: die PMU ist eine exklusive Ressource ohne
   `resource_group`, und ein fehlender/falscher Modus faellt STILL auf `measure` zurueck.

===============================================================================
## 1. ROLLEN UND DOKTRIN (zwei Owner-Aenderungen)
===============================================================================
- **FABLE-5 ZURUECK** (Owner: "Das Kontingent ist zurueck"): die 06.08.-Umstellung auf Opus-5 ist
  AUFGEHOBEN, es gilt wieder Matrix A1/v2.1.
- **ROLLEN-PRAEZISIERUNG** (Owner verbatim): "du uebernimmst jetzt die Rolle von Fable NUR im
  Sinne des CTO directors, Fable ist jetzt verfuegbar und steht sonst wie in der Claude Code
  Arbeitsweise vereinbart, zur Verfuegung bis auf director."
  => **DIRECTOR/CTO = der LEAD (Opus 5)**: Decomposition, Klassifikation, Orchestrierung,
  Entscheide, Abnahme, GO/NO-GO, Synthese-VERANTWORTUNG, Ledger-/Memory-Pflege,
  Owner-Kommunikation. **FABLE-5 = Agenten-Modell** fuer Planung/Design-Ausarbeitung,
  adversariale Reviews, Synthese-ZUARBEIT -- aber NIE als Director.
  Unveraendert: BAU = Opus 5 · leicht/Infra = Opus 4.8 · **EXPLORE = Sonnet 5 max "very
  thorough"** (nie Fable) · Codex = Regressions-Lens · Dual-Review-PFLICHT vor jeder Landung.
- **CODEX-RECHTE** (Owner: "das bestaetigen stuerzt hier in der shell ab"): jeder
  `mcp__codex__codex`-Aufruf mit `approval-policy: never` + vollem Zugriff + `cwd`; Codex NIE
  selbst `git` ausfuehren lassen (dokumentierter Timeout-Ausloeser) -- Diff als Text liefern
  oder auf Datei-Lesewerkzeuge verweisen.

===============================================================================
## 2. DIE AUFGELOESTEN ARCHITEKTUR-ENTSCHEIDE (der Kern dieser Doku)
===============================================================================

### 2.1  D-1 PMU-DOMAENE -- die Aufloesung trennt ZWEI Objekte
**Lead-Fehler:** hatte empfohlen, die PMU-Domaene NUR als CSV-/Lager-Spalte zu fuehren und die
Stempel-Pflicht zu VERNEINEN. Owner: "TOTAL FALSCH ... Klar ist die PMU Domaene auf der
System-Achse und damit auch wie alle Haupt-Achsen Stempel-Pflichtig fuer alle Details."

**AUFGELOEST (am Objekt belegt):** Beide Saetze sind wahr, sie betreffen verschiedene Objekte.
- **VERORTUNG:** System-Achse, als RT-Unter-Achse `core_class` am target_isa-Komplex. Geplant
  seit **16.07.** (Ledger §16.3-E17: "Der P/E-Core-Aspekt ist eine SEPARATE System-Achse, jedoch
  als DYNAMISCHE Unter-Achse unter der Hardware-Systemachse"), **gebaut mit `aa223961`**.
- **STEMPEL-PFLICHT = MESS-ZEILE, JA:** RF-6 ("gleiche Kombination, auch gleicher Stempel").
  `prod2/cpu_core` und `prod2/cpu_atom` sind ZWEI Kombinationen mit ZWEI Stempeln bei EINER
  Binary. Materialisierung: Pflicht-Spalten `pe_policy` (Konfiguration) + `ran_on_core_type`
  (Beobachtung) + Segment `numa.core_type=<p|e>`. Bereits 16.07. verankert (§16.2-M2).
- **BINARY-STEMPEL, NEIN -- COMPILE-HART GESPERRT:** `abi/system_cell_values.hpp:174` fuehrt
  `core_class` in `kSystemCellValueForbiddenKeys`. Begruendung woertlich im Code (:166-172):
  "stuende sie im Stempel, waere die Kern-Klasse Teil der Binary-Identitaet -- und die CEB
  koennte NICHT 'DIESELBE Tier-Binary einmal auf einen E-Core und einmal auf einen P-Core
  gepinnt' starten ... Genau das schliesst der KERN aus."
- **FOLGE:** EINE Binary, kein Neubau, Fingerprint unberuehrt. Die Trennung ist die technische
  Voraussetzung des Owner-KERNs "reine Wiederverwendung durch Achsen-Permutation".
- **TAG `cpe` (cpu-performance-efficiency): NEU.** Substanz geplant, NAME nicht: `"cpe"` als
  Token = 0 Treffer (17 Roh-Treffer sind ALLE vendored Fremdcode). Gebaute Werte-Token:
  `kern_uniform` / `kern_hohe_leistung` / `kern_hohe_effizienz` / `kern_grosser_cache` /
  `kern_kleiner_cache`. OFFEN als BAU-Auftrag: Ersatz, Kurzform in der Mess-Spalte, oder
  zusaetzliches Segment. Lead-Empfehlung: Kurzform in der Mess-Spalte (bricht die Token nicht).

### 2.2  B-4 BREAK-EVEN -- kein Lager-Objekt, sondern CEB-RAM
**Lead-Fehler:** hatte "Break-Even-Tabelle als Lager-Objekt mit eigenem Schluessel" empfohlen.
**Owner-Korrektur verbatim:** "Break even lebt nur in der CEB nach Messungs-Schluss und wird dort
im RAM ueber alle Tier-Binary-Messergebnisse ausgewertet, um dann von der CEB auch bei
Anforderung durch den Planer in Latex Dokumente, PDF oder xlsx Tabellen nach Zielorte zu giessen
(XML bestimmt Verhalten -> Feature Pflicht zusammen mit Modi der Cache Engine Debug/Release/etc).
Das Verwerfen IST FALSCH, da wird NICHTS gekuerzt. Voll-Build."
**AUFGELOEST:** Auswertung ist ein CEB-INTERNER Vorgang nach Messungs-Schluss, im RAM, ueber
ALLE Tier-Binary-Ergebnisse. Ausgabe-Ziele LaTeX / PDF / xlsx "nach Zielorten", vom Planer
ANGEFORDERT, per XML gesteuert -- und die Steuerung ist an die MODI gekoppelt.
KEINE Kuerzung, KEINE Teilmenge in der Auswertung.

### 2.3  DIE MODI SIND KUMULATIV, NICHT FLACH
**Lead-Fehler:** hatte die vier Modi als Nebeneinander gelesen und die `single_thread`-Spalte
flach interpretiert.
**Owner-Korrektur verbatim:** "release beinhaltet den vorgeschalteten Modus measure und erweitert
ihn, und compare beinhaltet den Modus measure ebenfalls als Basis. Wir koennen nur das bauen oder
vergleichen, was wir schon gemessen haben. Allerdings hat release auch den gesamten compare als
Grundlage vorangestellt und erweitert diesen, aber nicht umgekehrt. Der release veroeffentlicht
binaries aufgrund der Auswertung der vergleichbaren Messdaten."
**ENTHALTUNGS-ORDNUNG:**  `measure`  ⊂  `compare`  ⊂  `release`
- `single_thread` ist MISSVERSTAENDLICH kodiert: release/compare messen ebenfalls 1-threadig,
  SOFERN eine Messung noetig ist -- der Regelfall ist REPLAY des bereits Gemessenen.
- Das entspricht exakt der geplanten Kette:
  **XML -> MESSUNG -> AUSWERTUNG -> ERGEBNIS (Binary / Messwert / PDF)**.

### 2.4  DIE MODI SELBST -- `RunMethodology`, XML-PFLICHT (Gedaechtnisluecke aufgeloest)
Vier Werte in `measurement/run_methodology_registry.hpp`:
| Modus | cmake_build_type | measurement_on | Bedeutung |
|---|---|---|---|
| `debug` | Debug | ja | "DASS es funktioniert" -- parallel, **KEINE golden-Zahlen** |
| `measure` | Release | ja | die golden-Messung, 1-Thread-deterministisch |
| `release` | Release | nein | Auslieferung; veroeffentlicht Binaries aus der Auswertung |
| `compare` | Release | nein | Replay-Sichten-Vergleich (§62-C) |
XML-PFLICHT (Ledger §61, 21.07., Owner "autoritativ, war schon immer so"): "MODUS-WAHL PER XML,
EIN Modus je Call ... immer nur EIN Modus je Call." Element
`<run_methodology><method value="..."/></run_methodology>`, XSD :101 + :292-300, exactly-one.
**DAMIT IST DIE "OS-SUPPORT-BUILD"-FRAGE STRUKTURELL BEANTWORTET:** der Debug-Modus IST als
"paralleler Verdrahtungs-Check ohne golden-Zahlen" definiert -- genau die Semantik fuer die
Nicht-baremetal-Plattformen.
**VERWECHSLUNGS-WARNUNG:** drei weitere, namensgleiche Modi-Vokabulare existieren -- die vier
"Betriebsmodi des Builders" (Thesis-Zukunftsbild), die drei Pruefling-Mess-Schema-Modi
(Ersetzung/Hybrid/Full-Join), und `--mode=defined|full|full-sampled` des Alt-Demo-Drivers.
Nur `RunMethodology` ist der Debug/Messung/Release/COMPARE-Kanon.

### 2.5  PLATTFORM-MATRIX -- transitiv ueber das buildsystem
**Lead-Fehler:** hatte Talos als "nur CI-Infrastruktur" eingeordnet und empfohlen, die
Thesis-Aussage zur Rollentrennung umzuschreiben.
**Owner-Korrektur:** Talos ist TEIL DER ANFORDERUNG. Docker-Builds laufen auf bare metal UND
Talos in voller Matrix, um zu beweisen, dass der Build unter BEIDEN Kombinationen moeglich ist.
**Und die Fund-Erklaerung:** die fast wortgleiche Formulierung im comdare-db-Dossier ist
**exakt so gewollt** -- "Das ist exakt so gewollt, weil die Diplomarbeit den Kern des buildsystem
baut und das buildsystem baut die comdare-db. Wir arbeiten also klar an der Konstruktion der
comdare-db transitiv. Daher ist die Vorbereitung der cache-engine exakt die Vorbereitung der
comdare-db."
**GELTENDE MATRIX:**
- prod1 + prod2 tragen zusaetzlich **Windows Server 2022 und Win 11** (vier VMs als eigene
  GitLab-Runner: id53/id55 prod1, id54/id19 prod2; nur id19 online, drei brauchen
  Auth-Token-Reset + Vault-Creds; 0 Windows-Jobs in der cache-engine-CI).
- Die Linux-Distributionen laufen als Docker-Container auf bare metal UND Talos, **gemessen im
  DEBUG-Modus** ("OS support builds" -- Unterstuetzungs-Beleg, formal ungenau, weil nicht
  baremetal).
- macOS x86 + ARM, RISC-V (VisionFive 2), Pi 5: kompilieren und messen ebenfalls, bauen was sie
  koennen, messen nur im Debug-Modus.
- **PILOT-ENTSCHEID:** prod1 + prod2 zuerst vollstaendig fertig, NUR echt gemessenes bare metal;
  die anderen Systeme nach der Abgabe. **ZIH-Erweiterung wird trotzdem vollzogen.**
- OFFENE DISKREPANZ (nicht vom Lead zu entscheiden): 7 vs 8 Linux-Distributionen. Memory
  (03.07.) + Ledger (21.07.) sagen 8 inkl. Ubuntu; eine reale Cluster-Registry hat 7; die
  cache-engine faehrt real 18 Images (6 Familien x 3 Versionen); die Thesis nennt KEINE Zahl.
  Im Ledger als Gate W10-00 gefuehrt und auf "nach der Abgabe" gebucht.

### 2.6  F-01 TALOS-AUSSAGE -- keine Falschaussage, sondern uneingeloeste Anforderung
Die Thesis-Stellen stehen im PRAESENS PASSIV ("wird erhoben" / "is collected"), also als
bestehende Tatsache. Die Erhebung laeuft heute NUR unter root-Linux baremetal (16/16 CSV-Zeilen
`platform=linux-x86_64`; Mess-Jobs `[prod, baremetal, amd]`). Das ist ein Ehrlichkeitsproblem
fuer die Abgabe -- aber die Loesung ist **Tempus/Status praezisieren**, NICHT die Anforderung
streichen und NICHT "Rollentrennung".

### 2.7  F-02 flat_hash_map + die GATTUNGS-EINORDNUNG
**Owner-Entscheid:** Textpass (Option a). Begruendung verbatim: "weil wir keine Kontrolle ueber
flat_hash_map haben und das die Messung verzerrt, wir koennen die Achsen des Containers sonst
nicht steuern".
**Am Objekt belegt:** SwissTable liegt unter dem Genus **SearchAlgorithm**, und der gehoert per
`gattung_of()` zur Gattung **MAP** -- nicht Container (die Owner-Vermutung war knapp daneben).
Bestaetigend: die Aufgabenstellung sagt selbst "als Gegenprobe INNERHALB DERSELBEN Gattung".
Die Owner-Begruendung traegt vollstaendig -- sie heisst im Plan **SUBSTITUTIONS-PRINZIP** +
`vendor->faithful->self`-Doktrin, mit SwissTable als Praezedenzfall; am Objekt durchgesetzt
(SwissTable alloziert zwingend ueber `axis_06`, ist kein abseil-Wrap).

### 2.8  WEITERE ENTSCHEIDE DIESER RUNDE
- **D-3 BAU-MENGE:** "Wir bauen nur die 320er die wir auch tatsaechlich messen und stellen die
  golden XML darauf um." => Bau-Menge folgt der Mess-Menge.
- **O-C PINNING:** "Pinning ist Pflicht bei hybrid Architekturen, deren CPU-Kerne sich
  unterscheiden (sofern pinning durch mehrere Achsen freigegeben ist)."
- **O-4 ANHANG A:** volles GO fuer den Textnachzug an den Code -- ausnahmsweise Richtungs-Umkehr
  (sonst gilt: Thesis = Anforderung an den Code). NUR fuer belegt veraltete Stellen.
- **xlsx:** "Der Standard fuer die Messung ist xlsx." IST: der Writer EXISTIERT NICHT (0 Treffer
  auf `worksheet|sharedStrings|xl/workbook` in libs/, Gegenprobe csv=103; die 3 xlsx-Fundstellen
  sind Kommentare).

===============================================================================
## 3. DREI POSTEN WAREN BAU-RUECKSTAND, KEINE ENTSCHEIDUNG
===============================================================================
- **T-8 "beste Binary" = PARETO-FRONT**, entschieden am 10.07. (einer von sieben Forks in einem
  Zug). IST: `rank_binaries` im best_binary_selector rankt Einzelsieger je Metrik.
- **T-9 MIN/MAX-KATALOG je Achse EXISTIERT** (04.08., T0..T17+, Deep-Research-gestuetzt, mit
  Pareto-Sonderbehandlung fuer T5/T6/T18). IST: `heuristik/break_even.hpp` konsumiert ihn NICHT,
  dort gilt pauschal "kleinerer y-Wert = besser".
  **=> Solange das so ist, ist der Kurvenvergleich fuer JEDE Max-Achse systematisch FALSCH HERUM.
  Das ist die hoechste Prioritaet der drei.**
- **T-10 LAST-ERKENNUNGSHEURISTIK:** der zweimal erhobene Befund "0 Code, 0 Design, 0 Register"
  war FALSCH. Es existiert ein 327-zeiliger committeter Deep-Research-BEFUND vom 09.07.
  (OtterTune SIGMOD 2017, QueryBot 5000 SIGMOD 2018, Self-Driving-DBMS CIDR 2017): Merkmalsvektor,
  Clusterverfahren (offline hierarchisch + k-Means, online modifiziertes DBSCAN),
  Cluster-Anzahl-Methodik, und Abschnitt 5 die Laufzeit-Zuordnung ankommender Last zum naechsten
  Cluster inkl. sicherem Default-Fallback.

===============================================================================
## 4. HAUPTSTRANG-VOLLZUG: das numa-Paket
===============================================================================
`core_class` = die AUSFUEHRUNGS-Lokalitaet (Owner-KERN 8: "numa page ist eine Cache-Seiten
Koordination ... jetzt brauchen wir ein pendant ... welche sich damit beschaeftigt, WO PROGRAMME
AUSGEFUEHRT WERDEN").
- **ce `aa223961`** (dev == main, beide Remotes): b4cebdc4 Bau -> b1753926 Umbenennung ->
  a73fecbe drei Review-Luecken L-1/L-2/L-3.
- **super `397710d2`**: `experiment_schema.xsd` +24 Z. `core_class` (additiv, minOccurs=0,
  xs:string statt Enumeration) + Gitlink-Bump.
- **Dual-Review erfuellt:** Fable-Lens landebereit/0 Regressionen; Codex-Lens keine neue
  Regression (ein NIEDRIG-Bestandsbefund: macos-Blatt Off-by-one am Maximalwert, `kMaxCpuId`).
- **L-3-Bissbeweis durch AUSFUEHRUNG belegt:** derselbe Input akzeptiert gegen `b1753926`,
  abgewiesen als `QuelleKorrupt` gegen `a73fecbe` -- echtes ROT->GRUEN.
- **Lead-Verifikation:** Konsumenten-Kette vollstaendig (Registry-Angebot
  `system_axis_registry.xml:40` `machine_resolved` -> `xml_config_parser` ->
  `target_isa_sub_axes`) -- KEIN dekoratives Schema-Element. A-15-neutral, kein Flotten-Neubau.
- Kette T-1 vollstaendig: dev-Push -> Pipeline gruen -> main-FF -> Gitlink-Bump ->
  super-Pipeline gruen -> super-main-FF.

===============================================================================
## 5. ZWEI NEUE DEFEKTE MIT MESS-RELEVANZ
===============================================================================
### 5.1  Die PMU ist eine EXKLUSIVE Ressource -- ohne `resource_group`
Die super-Pipeline fiel in der BRIDGE (14/14 Jobs gruen, Bridge rot -- die `/jobs`-API zeigt
Bridges NICHT). Ursache belegt: `pmc:intel` meldete `pmc_available=0`, waehrend IM SELBEN JOB ein
zweiter Test echte Zaehler lieferte (`l1 = 7.052.220`). **Transienz belegt:** Pipeline 15157 auf
DEMSELBEN SHA war zwei Minuten vorher gruen. Zwei Pipelines griffen gleichzeitig auf die PMU von
prod2 zu. `resource_group` kommt in der CI **null**-mal vor (Gegenprobe: `pmc:` achtmal).
**RISIKO fuer die Messung:** laeuft waehrend der mehrtaegigen Messung irgendetwas anderes mit PMC
auf derselben Maschine, sind die Zaehler still verfaelscht. Retry lief gruen.

### 5.2  Stiller Rueckfall auf `measure` bei fehlendem/unbekanntem Modus
Fehlt das `<run_methodology>`-Element, faellt der Laufzeit-Lookup STILL auf `measure` zurueck --
bei UNBEKANNTEM Wert ebenso. Nur der explizite `--validate`-Lauf bricht hart.
**Nach Owner-KERN 10 ist das ein stiller Rueckfall und gehoert zur Schwere-Stufe ERROR:** ein
Debug-Lauf mit Tippfehler im Modus-Namen liefert Zahlen, die wie eine golden-Messung aussehen.

===============================================================================
## 6. METHODEN-LEHREN (drei Falschbefunde derselben Bauart an EINEM Tag)
===============================================================================
1. **EINE NEGATIV-SUCHE IST NUR SO GUT WIE IHR VOKABULAR.**
   - T-10: "Last-Erkennung" fand nichts -- der Plan heisst "Workload-Cluster" (327 Zeilen).
   - D-1: die Substanz war seit 16.07. geplant, unter anderem Namen gesucht.
   - `cpe`: 17 Roh-Treffer, ALLE vendored Fremdcode -- ohne Klassifikation waere daraus ein
     Falschbefund geworden.
   **AB SOFORT:** jede "existiert nicht"-Aussage braucht (a) einen SYNONYM-Durchgang und
   (b) eine KLASSIFIKATION der Roh-Treffer.
2. **ES GIBT ZWEI THESIS-CHECKOUTS.** Der Separat-Klon
   `/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit` ist VERALTET (`29a1700`);
   das Submodul `thesis/diplomarbeit` traegt den Stand (`19e1592`). ZWEI Plandokumente UND ein
   Explore-Agent haben sich daran verlesen (O-4 "16 von 44" vs "Scope 4 bedient alle 28" --
   beide falsch; real: 31 gegatet / 18 harte input / 18 Dateien). Auch der Befund "Gate 8 nicht
   gelandet" war so entstanden -- Gate 8 IST gelandet.
3. **gitleaks meldet "no leaks found" bei 0 commits scanned.** Das git-dir des Submoduls zeigt
   per `core.worktree` auf einen Pfad, den der Container nicht sieht. Loesung: echten Klon
   erzeugen und den scannen -- mit Nenner ("N commits scanned").
4. **Der ASCII-Selbstcheck braucht `LC_ALL=C`.** Ohne das meldete er 1133 Verstoesse, wo `od -c`
   NULL Bytes findet. Und `rc=$?` nach einer Pipe misst die LETZTE Stufe, nicht `grep`.
5. **Die `/jobs`-API zeigt keine Bridges.** Eine Pipeline kann rot sein, waehrend alle Jobs
   gruen sind -- Bridges separat abfragen.
6. **"Offene Frage" und "Bau-Rueckstand" sind verschiedene Dinge** (Abschnitt 3).

===============================================================================
## 7. BILANZ DER VERGESSENEN ARBEIT (mit Nenner)
===============================================================================
| Pruefung | Ergebnis |
|---|---|
| 57 ce-Branches gegen origin/development | **0** ungelandet |
| 129 ce-Tags | nur `w2b-E04-P1` (02.08.) relevant -> **2 verwaiste Commits** (E04-P1 Slice-Kanal-Emission + Director-Test-Migration), lagen auf **0 Remotes** -> gesichert als `refs/rescue/20260807-v8-e04-p1-verwaist`, beide Remotes |
| 15 super-Branches | alle gelandet ausser `b-e18-snap` (3 Commits, stehendes NICHT-LANDEN-Verdikt) + 3 `backup/`-Refs (sollen stehen bleiben) |
| Hauptcheckouts | keine vergessene Arbeit -- nur alter Stand (`git cherry` zeigt `-`) |
Die "128 Tag-Kandidaten" des Ancestor-Tests waren ein Messartefakt: der Giga-Scrub hat die
History umgeschrieben, deshalb ist kein Mai-Tag mehr Vorfahr.
**Aus den Workflow-Endberichten neu erhoben:** CMake-Ballast-Zensus (79 von 220 Zielen toter
Ballast) nirgends gebucht; `COMDARE_VARIANT_GATE` fehlt in der Aufraeumpass-Kandidatenliste.

===============================================================================
## 8. WAS OFFEN BLEIBT
===============================================================================
**FENSTER 0 (vor der ersten .fingerprint-Datei -- heute 0 h, danach 34,4 h + alle Messdaten):**
- **R-3** Mess-Defines ins Preimage. DESIGN LIEGT VOR (Fable, 07.08.): `format_bump_noetig=TRUE`
  mit Begruendung -- M-1 bewegte KEIN Preimage-Byte (drei ABI-Dateien sha256-identisch), R-3 MUSS
  eines bewegen; kein bestehendes Glied kann das Feld tragen (Glied [3] ist ein HOST-Literal,
  nicht die TU-Wahrheit) -> neuntes Glied -> Format 4. Bau + Review liefen ins Spend-Limit.
**T1 (vor dem ersten 4096er-Batch):** D-4 `allow_failure` am Voll-Mess-Batch · D-5 PMC
fail-closed via `kPmcExpected` · R-2 XML-Trennung Bau/Messung + Mess-Slicing 4096.
**BAU-RUECKSTAENDE (kein Entscheid noetig):** T-9 Min/Max in `break_even.hpp` (hoechste Prio) ·
T-8 Pareto statt Einzelsieger · T-10 Last-Erkennungsheuristik nach dem 09.07.-Plan ·
xlsx-Writer · `cpe`-Tag-Einbau · macos-Off-by-one · `resource_group` fuer PMC-Jobs ·
Modus-Fallback fail-closed statt still.
**SPAETER:** W-3 Akzeptanzkriterium Ebene 2 (zwei Owner-Aussagen, 6 Min 53 Sek auseinander --
gehoert entschieden, nicht abgeleitet) · B-5 Break-Even-Schwellenwerte CT vs RT · C-4 H2 braucht
die fehlende Durchsatz-Spalte · C-5 vier Lastprofil-XML · C-6 ChainRef bis 28.08.

===============================================================================
## 9. LAUFENDE ARBEIT
===============================================================================
- `wf_63de5534-46e` Explore Modi-Staffelung + Kette XML->Messung->Auswertung->Ergebnis
- `wf_7db10170-f15` Thesis-Audit + Textnachzug (Owner-GO), DE+EN paritaetisch, mit
  Fable-Review gegen den schwersten Fehler: eine gewollte Anforderung wegzuschreiben
- `wf_664f0a48-51a` R-3 Bau + Review (Resume nach Spend-Limit)

**REFS am Ende dieser Spanne:** ce `aa223961` (dev==main) · super `200366eb` (dev; main
`397710d2`) · thesis `19e1592` (dev==main) · cluster `d7eab98`.
