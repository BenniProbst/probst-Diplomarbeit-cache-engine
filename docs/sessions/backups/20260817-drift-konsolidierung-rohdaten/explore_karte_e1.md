# EXPLORE-KARTE E1 — Früh-Ära Rohtranskripte (~07.06.–15.07.2026)

**Auftrag:** Zehn-Wochen-Drift-Explore, Schnitt Früh-Ära. Maßstab: `kopf_referenz_kon60_93.md` +
`ledger_gegenlese_karte.md` + KON94/95/96 (inline). Gemeldet wird NUR, was dort weder gedeckt noch
überholt ist. Diese Fassung ist ein **zweiter, unabhängiger Durchgang** über denselben Schnitt (eigene
Extraktion, eigene Stichproben, eigene Gegenproben) — Ergebnis: der erste Durchgang wird **vollständig
bestätigt**, keine neue Substanz gefunden. Beide Methodik-Spuren stehen unten, damit die Konsolidierung
sieht, was geprüft wurde.

## 0. Methodik + Gegenprobe-Befunde

**0.1 Kein Juni-Anteil vorhanden (Gegenprobe, zweifach geprüft):** Timestamp-Scan aller
`/home/comdare/.claude/projects/-home-comdare/*.jsonl` (37 Dateien) zeigt: keine Datei enthält
`"timestamp":"2026-06`. Die große Datei `46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl` (aktuell 314 MB,
107.484 Zeilen — wächst weiter, da Session noch aktiv) beginnt exakt bei `2026-07-06T09:31:44Z` (Zeile 4).
Es gibt in `-home-comdare/*.jsonl` schlicht KEINEN 07.06.–05.07.-Anteil zu lesen — die Auftragsformulierung
„die grosse Datei deckt 06.07.–11.08." ist korrekt, der zusätzlich erwartete „Juni-Anteil DARIN" existiert
nicht. Auch die übrigen 6 nicht-trivialen Dateien im Verzeichnis (`b15ade0e`, `4cf35b04`, u.a.) beginnen
alle erst ab 05.–08.08. — kein Juni-Fund in keiner Datei dieses Verzeichnisses.

**0.2 „KON70-03(c) deklarierte Restlücke" nicht auffindbar:** `KON70-03(c)` (mit Klammer-c) kommt in den
Sessiondateien nur als Zitat der Auftragsformulierung selbst vor (Orchestrator-Transkript), keine
eigenständige Ledger-Stelle. `KON70-03` (ohne „(c)") bezeichnet einen anderen Gegenstand (XorFilter/KON-17,
10.–11.08.-Prüfungsspanne) — nichts zur Früh-Ära. Empfehlung unverändert: die „(c)"-Teillücke aus der
Auftragsformulierung beim nächsten Karten-Update streichen.

**0.3 Zeilen-Schnitt 07.06.–15.07. exakt verifiziert:** Zweiter Durchgang hat den Zeilenbereich
unabhängig neu bestimmt: letzte `2026-07-15`-Zeitmarke = Zeile 42074 (08:26 Uhr), erste `2026-07-16`-Zeitmarke
= Zeile 42078 (07:07 Uhr) — Cut bei Zeile 42076 trifft exakt die Tageslücke, kein 15.07.-Rest bleibt
ungelesen, kein 16.07.-Inhalt rutscht rein. `head -42076` reproduzierbar (`grep -c` je Tagesstempel
gegengeprüft).

**0.4 Owner-Text-Extraktion — ZWEI unabhängige Durchläufe, gleiches Ergebnis:** Durchlauf 1 (Vorversion
dieser Karte) fand 430 Owner-Äußerungen über `type:user`(promptSource∈{typed,queued}) ∪
`attachment.type:queued_command`(origin.kind=human) ∪ `type:queue-operation,operation:enqueue`. Durchlauf 2
(diese Session, unabhängig neu programmiert, bewusst GRÖSZÜGIGER gefasst — 755 Datensätze nach Dedup, ohne
promptSource-Filter, nur Rauschen wie `<task-notification>`/`<agent-message>`/Stop-Hook-Boilerplate/
Session-Fortsetzungs-Summaries ausgeschlossen) bestätigt: **jede der 24 inhaltstragenden, nicht-Boilerplate
Owner-Äußerungen** aus dem größeren Korpus (gefiltert über Entscheidungs-Marker wie „in Stein gemeißelt",
„IMMER", „NIE", „Direktive", „Grundsatz", „final", „endgültig", „verbindlich") ist entweder (a) bereits im
Hauptfund unten enthalten (Matrix/Baseline/Familie), (b) bereits per Memory-Datei gedeckt (Buildsystem.xml-
Hands-off, YCSB→Workload-Framework-Bibliothek, Heuristik-Messkurven-Typsystem — inkl. Stichprobe der
NAMEN in `feedback_heuristik_messkurven_typsystem_chain_of_responsibility.md`: die dortige Karte trägt
den exakten verschachtelten `map<>`-Typ, das 3-Varianten-Observer-Schema UND „Paper-Vergleich geht vor"
wortgleich — keine Lücke, auch nicht in Details), oder (c) reines Prozess-/Infra-Rauschen ohne
Architektur-/Mess-/Lager-/Achsen-Substanz (Stop-Hook-Wiederholungen, Kontext-Handover-Bitten, Backup-
Bitten, Infra-Status „gitlab jetzt wirklich repariert"). **Ergebnis: kein einziger zusätzlicher Fund.**

**0.5 Gezielte Negativ-Probe auf SPÄTERE Vokabeln (bewusster Test, ob die Früh-Ära bereits Konzepte trägt,
die heute zentral sind):** Über den vollständigen bereinigten Owner-Korpus (755 Datensätze, s.o.) UND
zusätzlich über die komplette Rohdatei (alle Rollen, nicht nur Owner) wurden folgende Begriffe geprüft, die
im heutigen Ledger-Kopf/Memory zentral sind: `Lager` (0 Treffer im Owner-Korpus — auch in der Rohdatei
0 Treffer über alle Rollen), `Stempel` im Fingerprint-Sinn (4 Rohtreffer, alle „Resume-Stempel"/„v2-Stempel"
= Code-Kommentare zu Datei-Layout-Versionen, NICHT das heutige CT-Fingerprint-Konzept), `Arena` (0 im
Owner-Korpus), `Kombibau` (0), `Sheet` (0), `Lastsequenz` (0), `Realm` (0 im Owner-Korpus), `Riegel`
(0 im Owner-Korpus), `Fehlerklasse` (0 im Owner-Korpus). **Befund: alle neun Begriffe sind in der Früh-Ära
entweder komplett abwesend oder tragen eine andere Bedeutung — sie sind genuin SPÄTERE Erfindungen, kein
vergessener Früh-Ära-Fund.** Das ist eine positive Bestätigung von „neu gewinnt gegen alt" (nichts wurde
in der Früh-Ära vordefiniert und seither stillschweigend verändert), keine Lücke.

**0.6 Kernbefund der Gegenprobe gegen `memory/*.md`:** 145 der ~323 Memory-Dateien tragen
`originSessionId: 46375cdc-...` — die hier untersuchte Datei wurde bereits extrem gründlich in
Einzel-Memories zerlegt (u.a. mit wörtlichen Zitaten, exakten Zeitstempeln). Stichprobe von 3 zufällig
gezogenen zitierten Memory-Dateien gegen die Originalstelle im Rohtranskript gegengelesen (Matrix-Zitate,
Heuristik-Messkurven-Typsystem, Buildsystem.xml) — alle drei wortgleich bis auf Tippfehlerkorrektur.

---

## 1. HAUPTFUND — Matrix/Baseline/Familie/Produkt-Architektur ist im Ledger-Kopf UNSICHTBAR

**Befund (zweifach unabhängig verifiziert):** Zwischen 06.07. und 07.07.2026 legt der Owner in mehreren
langen, expliziten Nachrichten eine komplette, eigenständige Architektur-Ebene fest — die Organisation des
GESAMTEN Comdare-Ökosystems in `Umbrella → Baseline-Stufen → Module`, orthogonal zu Products/Research, mit
eigener Namenskonvention und einem Standardprozess Research→Product. Diese Ebene ist wörtlich
Owner-mandatiert, architektonisch tragend (sie legt fest, WAS cache-engine/PRT-ART/Diplomarbeit/overleaf
im Repo-Gefüge SIND), und taucht **an keiner einzigen Stelle** in `kopf_referenz_kon60_93.md` oder
`ledger_gegenlese_karte.md` auf. Zweiter Durchgang hat gezielt gegrept: „Baseline" → 0 Treffer in beiden
Referenzdateien; „Matrix" → in `kopf_referenz` 0, in `ledger_gegenlese_karte` nur unverwandt („opt×simd-
Matrix", „Vollmatrix"); „Umbrella" → nur im CI/Flotten-Sinn („Umbrella-CI grün", „Umbrella-Flotten-
Reaktivierungs-Posten") — bestätigt Durchgang 1 exakt.

**Wortlaut (Auswahl, chronologisch, Zeilen = `46375cdc-...jsonl`):**
- 06.07. 12:00 (`:883`): „die gesamte comdare Matrix basiert auf source code [...] Metaprogrammierung
  [...] bei den Modulen untereinander erlaubt, nur die Produktinterfaces haben den Anspruch
  Kunden-geschlossene pre-compiled Binary interfaces anzubieten [...] Research und Produkt Bestandteile
  [werden] maximal zur Wiederverwendbarkeit nach Modules ausgelagert."
- 06.07. 12:05 (`:948/:953`): „Research sind early Products, also gilt das Prinzip für Products+Research
  gegen alle Module."
- 07.07. 08:43 (`:10628`): „Nun in Stein gemeißelt sollte eigentlich die Matrix Familien x Baseline-Stufen
  x Module sein [...] die comdare cache engine ist ein Framework-Modul und die Diplomarbeit ist deren
  Produkt und Außeninterface. PRT-ART ist auch ein Modul neben der cache-engine [...] das overleaf Projekt
  ist auch ein Produkt, aber ohne baseline Struktur, weil es kein C++/Java/Python/Go/Rust ist." — plus
  Auftrag: „speichere [...] den Prozess der Umwandlung eines Research in ein Product als Standardprozess
  für weitere Projekte."
- 07.07. 08:55 (`:10693`): Namenskonvention „*-product" statt „*-all"; „Ist eine baseline leer, wird ihr
  Ordner nicht angelegt."
- 07.07. 11:01 (`:11622`): „Es gibt umbrella, darunter baselines und darunter Module [...] Per definition
  referenzieren sie nur nach dem nächst-niedrigeren baseline."
- 07.07. 15:04 (`:12511`): „Insgesamt ist jetzt über die Gruppen von Gitlab hinweg jedes einzelne umbrella
  als komplett strukturell falsche Gruppe angelegt [...] Jeder umbrella trackt alles außer die baseline
  Inhalte."
- 10.07. 17:06 (`:23760`, weiterer Beleg derselben Doktrin, im selben Atemzug wie Heuristik-Messkurven):
  „wir [...] im gitlab namespace all ursprünglich die cache engine später in die Konvention des comdare
  Matrix Systems zergliedern wollten. Wir stellen also die cache engine als monolithen fertig und füttern
  später die cache-engine-all Modul-Bibliothek [...]"

**Bereits gedeckt in Memory (NICHT verloren, aber Ledger-blind):** `feedback_baseline_system_in_stein_
gemeisselt_layering.md`, `feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen.md`,
`feedback_standardprozess_research_zu_product_matrix_3d.md`, `feedback_prt_art_consumes_cache_engine.md`,
`project_struktur_regression_geteilte_klone_statt_instanz_repos.md`, `project_cache_engine_research_vs_
cacheengine_all_split_todo.md`, `project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules.md` —
alle mit `originSessionId: 46375cdc...`, alle inhaltsgleich zu obigem Wortlaut, teils wörtlich (verifiziert).

**Warum das trotzdem meldenswert ist:** Der Ledger-Kopf behandelt „Repo-Rollen" NUR grobkörnig (KON73-F6:
„ce=Framework, super=Einstieg, XSD-Hoheit->ce #74") und die Gegenlese-Karte führt genau diese Stelle als
OFFENEN Widerspruch W15 („super = 'WAS + Auswertung' vs. 'ce=Framework, super=Einstieg' [...] #74
verschiebt Auswertungs-Werkzeuge nach ce [...] im #74-Design ausdrücklich ausweisen"). Die vollständige
Matrix-Taxonomie von 06.–07.07. beantwortet diese Frage bereits AUF EINER TIEFEREN EBENE (cache-engine =
Framework-Modul, super = Produkt+Außeninterface, PRT-ART = Modul+Prüfling+Plugin, overleaf = Produkt ohne
Baseline) — aber ohne KON-Referenz ist dieser Zusammenhang für jeden Ledger-Leser unsichtbar, und #74 läuft
Gefahr, die Matrix-Doktrin neu zu erfinden statt sie zu zitieren. Auch KON94/95/96 (Full-Join, O1-O3,
Gegenlese-Buchung) berühren dieses Feld nicht — der Fund bleibt nach dem jüngsten Owner-Stand offen.

**Empfohlenes Ziel-Dokument:** Brücken-Eintrag im Ledger-Kopf (neue KON-Zeile oder Fußnote an KON73-F6 /
W15), der auf die o.g. sieben Memory-Dateien verweist, PLUS Prüfauftrag an #74-Design: vor der
Repo-Rollen-Verschiebung die Matrix-Doktrin explizit zitieren statt implizit voraussetzen.

---

## 2. NEBENFUNDE (geringe Priorität — vollständigkeitshalber gemeldet, beide erneut bestätigt)

**2.1 „Bit-Bank"-Entfernung — echter Total-Nichtfund, im zweiten Durchgang mit VOLLSTÄNDIGER
Reichweiten-Prüfung bestätigt.** 13.07.2026 15:12 (`:38811`): „Die Bit-Bank sollte ein import/export
feature des B+-Experiment Baumes sein, aber es ist nicht standalone und wird in der aktuellen Fassung
entfernt." Zweiter Durchgang hat ALLE 76 Rohtreffer für „Bit-Bank"/„BitBank" im Zeilenbereich 1–42076
einzeln nach `type:user`-Owner-Text gefiltert (nicht nur die zitierte Stelle): genau EINE Owner-Äußerung
(Zeile 38811) — der Rest sind Tool-Output/Code-Diffs derselben nachfolgenden Entfernungsarbeit (Reichweite
bis Zeile 41898, alles automatisierte Folgearbeit, keine weiteren Owner-Entscheidungen). Da es sich um
eine ENTFERNUNGS-Entscheidung handelt (kein Bauauftrag), ist der Nichtfund in aktuellen Quellen plausibel
„einfach vollzogen und folgerichtig nirgends mehr erwähnt". Ziel-Dokument: nur falls bei einer
Bestandsprüfung ein Artefakt namens „Bit-Bank"/„BitBank" wieder auftaucht, gegen diesen Fund abgleichen.

**2.2 „40 Regressionen" — Zahl ohne Nachfolger (Total-Nichtfund, Gegenprobe negativ, unverändert).**
13.07.2026 00:17 (`:36088`): „Bitte füge als weiteres TODO hinzu, dass wir alle 40 regressions fixen
müssen [...]" Weder in Memory noch im Ledger-Kopf/Gegenlese-Karte referenziert. Gegeben das Vorhandensein
eines aktuellen `.../regressions-gesamtbild`-Auswertungsverzeichnisses (Jobs-Ordner, außerhalb Auftrag,
nicht geöffnet) ist diese Zahl mit hoher Wahrscheinlichkeit fünf Wochen später bereits überholt/ersetzt.
Ziel-Dokument: nur bei Bedarf gegen das aktuelle Regressions-Gesamtbild abgleichen, keine Owner-Handlung
nötig.

---

## 3. Zweiter Durchgang — zusätzlich geprüfte Kandidaten, ALLE als gedeckt/irrelevant verworfen

Diese Liste dokumentiert, was der zweite (unabhängige) Durchgang zusätzlich zu Durchgang 1 gezielt
nachgeprüft hat, damit E2/E3/E4 dieselben Fährten nicht nochmal laufen müssen:

- **„Eigenes Buildsystem" / `buildsystem.xml`** (07.07. 07:50/07:59, `:10213`/`:10237`): „Die Dependent
  Quellen sind Artefakte des eigenen noch weiter zu entwickelnden Buildsystem [...] Solange es noch nicht
  fertig ist, fahren wir parallel eine direkte Entwicklung mit CI und CMAKE [...] lassen wir die
  buildsystem.xml in Ruhe" — GEDECKT wortgleich durch `feedback_buildsystem_xml_hands_off_parallel_ci_
  cmake.md` (Dateiname beschreibt den Fund bereits exakt).
- **YCSB→Workload-Framework-Bibliothek** (09.07. 13:31, `:19806`): „YSCB wird durch dutzende frameworks x
  workloads ersetzt, die eine eigene Bibliothek Kategorie in der cache engine bilden müssen" — GEDECKT
  durch dieselben Heuristik-/E1-E4-Memory-Cluster wie Punkt darunter (`project_e1_e4_experiment_
  maschinerie_und_konsolidierung.md`, `feedback_gattung_genus_interface_messparameter_achsen.md`).
- **E4/E1-E0-Ebenen-Rollenbeschreibung** (09.07. 21:21, `:21346`/`:21353`, doppelt eingereiht): „E4 die
  abstrakteste Ebene [...] E1/E0 die präziseste Detailimplementierung" — GEDECKT durch
  `feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert.md` (bereits Teil des aktuellen
  Top-Level-MEMORY-Verweises „E-Ebenen · Messung").
- **Drei-Phasen „misst, dann auswertet, dann Arbeitsmodus"** (10.07. 08:04, `:22326`) — historischer
  Vorläufer des heutigen `work_mode`-Enum-Umbaus (Korb A Punkt 5 der Gegenlese-Karte, dort bereits als
  offener Bau-Posten geführt); keine eigene Meldung nötig, der aktuelle Posten deckt die Weiterentwicklung.
- **„NIE rebase, immer merge"** (13.07. 00:28, `:36218`) — deckungsgleich mit der bis heute geltenden
  Top-Level-MEMORY-Regel `feedback_nie_rebase_immer_merge.md`; keine Drift, Regel lebt unverändert seit
  der Früh-Ära.
- **gitlab.comdare.local vs. .de** (13.07. 14:38, `:38622`) — Namenskonflikt der Früh-Ära; durch spätere
  Infra-Entscheide (`minio.comdare.de` etc., KON67-Topologie) erkennbar zugunsten `.de` aufgelöst; kein
  offener Rest.
- **„Achsen der Diplomarbeit sind Stand der Technik + Chain of Responsibility"** (14.07. 08:21/09:05,
  `:40210`/`:40362`) — Registry-in-XML vs. PRT-ART-eigene-XML-Registry-Trennung — GEDECKT durch
  `feedback_unified_experiment_xml_plus_system_registry_xml.md` (bereits in Durchgang 1 zitiert).
- **19 vs. 18 Achsen** (09.07., `:18766`) — explizit überholt durch `reference_organ_achsen_sind_achtzehn_
  nicht_neunzehn.md`.
- **Statistik-Methodik „Welch-Test oder t-Test oder zwei-Engine"** (14.07. 08:21, `:40210`-Umfeld) —
  bereits beantwortet durch `feedback_unified_experiment_xml_plus_system_registry_xml.md`
  (Welch/EE-A-EE-B-Verdikt-Layer).
- **Rückschreib-Mechanik „measurement/<datiert>/" + NFS-Backup + Auswertungs-PDF-Pipeline** (11.–12.07.,
  `:31618`/`:33081`/`:34443`) — GEDECKT durch `project_mess_ergebnis_rueckschreibung_pipeline_
  persistiert.md` und `project_diplomarbeit_stand_20260712_freigaben_pipeline.md`.
- **„redcomponent"/„bep"-Alt-Naming + geteilte Klone** (07.07., `:11767`/`:11831`) — GEDECKT durch
  `project_struktur_regression_geteilte_klone_statt_instanz_repos.md`.
- **„run_lazy_150" löschen** (11.07., `:28417`, ausgelöst durch Owner-Rückfrage `:28386` „Ich verstehe
  nicht, was run lazy ist") — GEDECKT durch `feedback_only_one_official_xml_driven_program_no_
  behelfswege.md`.
- **Zentralisierung „alle Tools der 4 Repositories [...] in den CEB mergen"** (14.07., `:40607`/`:40625`)
  — GEDECKT durch `feedback_unified_experiment_xml_plus_system_registry_xml.md` UND im aktuellen
  Top-Level-MEMORY als offener Punkt sichtbar (`project_vier_binary_typen_ceb_traegt_alles_acht_behelfs_
  clis.md`) — nicht vergessen, nur (wie der Hauptfund) nicht im Ledger-Kopf zitiert.
- **axis_03a-Kandidatenliste tree/btree/art/skip/hash/masstree/surf/wormhole** (07.07., `:9561`) —
  Einzelbegriffe in bestehenden Thesis-/Achsen-Memories auffindbar.
- **„CacheEngineBuilder hält Prüfdock+Messsystem, XML-Parser nur dort, möglichst kein CMake für die
  laufende Steuerung"** (14.07. 09:26/09:27/09:28, `:40506`/`:40519`/`:40535`) — KEIN Widerspruch zum
  heutigen „einzige Nicht-C++-Träger: CMake" (Verständnis-Kern 4 der Gegenlese-Karte): CMake bleibt nur
  fürs initiale Kompilat, die laufende Pipeline-Steuerung läuft C++-seitig — beide Aussagen sind derselbe
  Gegenstand aus zwei Blickwinkeln, kein Konflikt.

---

## 4. Bilanz

- Zwei unabhängige Durchgänge, zwei unterschiedliche Extraktions-Implementierungen (Durchgang 1: 430
  Owner-Äußerungen streng gefiltert; Durchgang 2: 755 Owner-Äußerungen großzügiger gefasst, dann über
  Entscheidungs-Marker + gezielte Vokabel-Negativproben trichter-geprüft) — **identisches Ergebnis.**
- Zeitraum vollständig gelesen: 06.07.–15.07.2026 (Zeilen 1–42076 von `46375cdc-...jsonl`, Tagesgrenze
  exakt verifiziert).
- Diese Früh-Ära ist bereits außergewöhnlich gründlich in **145 Einzel-Memory-Dateien** zerlegt
  (originSessionId-Beleg, Stichprobe gegengelesen bis auf Wortebene). Der „Drift"-Ertrag auf
  Rohtranskript-Ebene ist entsprechend schmal — nichts Substanzielles ist im Sinne von „nirgends mehr
  auffindbar" verloren, bis auf die zwei niedrigprioren Nebenfunde in Abschnitt 2.
- Der eine tragende Fund liegt auf **Ledger-Konsolidierungs-Ebene**, nicht auf Gedächtnis-Ebene: die
  komplette Matrix/Baseline/Produkt-Architektur (Abschnitt 1) hat trotz ~15 Memory-Belegen KEINE Brücke in
  `kopf_referenz_kon60_93.md` / `ledger_gegenlese_karte.md` — und interagiert dort mit dem bereits
  erkannten offenen Widerspruch W15 (Repo-Rollen). Auch gegen KON94/95/96 (jüngste Entscheide) bleibt
  dieser Fund unüberholt — keiner der drei behandelt Repo-Rollen/Matrix-Taxonomie.
- Explizit negativ (mit Gegenprobe) getestete spätere Kernvokabeln, die in der Früh-Ära NICHT existieren
  und daher korrekt NICHT gemeldet werden: `Lager`, `Stempel` (Fingerprint-Sinn), `Arena`, `Kombibau`,
  `Sheet`, `Lastsequenz`, `Realm`, `Riegel`, `Fehlerklasse`.
