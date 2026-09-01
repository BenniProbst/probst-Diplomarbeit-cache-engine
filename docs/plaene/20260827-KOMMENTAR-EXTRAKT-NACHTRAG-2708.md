# KOMMENTAR-EXTRAKT — NACHTRAG 27.08. (8 Commits nach 246eff9 · Gegenprobe 34 Commits · Merge-Warnungen)

Erhoben: 27.08.2026, read-only im Submodul-Store
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/thesis/diplomarbeit (kein checkout, kein fetch,
kein merge; der fremde Worktree /home/comdare/wt-thesis-sync wurde NICHT berührt). Methode: git rev-parse,
git log, git show -U6 je Commit, git show github/main:kapitel/de/06_fazit.tex (Kontext), git diff -U0 kumuliert,
git merge-tree --write-tree (nur Objekt-DB, keine Ref) für die Konflikt-Sicht.
Dieser Nachtrag ist ADDITIV zu KOMMENTAR-EXTRAKT.md (TEIL 1-5); das Original ist unverändert.

REF-PRÜFUNG (Literal):
- github/main   = dad2d52c0cb187250cb3eff4a8ce86c99c55d2c2  (= Lead-Angabe)
- origin/main   = dad2d52c0cb187250cb3eff4a8ce86c99c55d2c2  (NICHT mehr c2d21fae: origin/main wurde bereits
  per FF auf github/main gehoben; `git log origin/main..github/main` = 0). Der Lead-Bereich
  "origin/main..github/main" ist deshalb leer; gemessen wurde c2d21fae..github/main.
- origin/development = c169fd22 (= HEAD des Stores, detached; merge-base zu github/main = c2d21fae).
- Nenner 246eff9..github/main = 8 Commits (stimmt).  c2d21fae..github/main = **34** Commits, nicht 33
  (26 im Extrakt + 8 hier; Lead-Zahl 33 ist eine Fehlzählung, kein Merge-Commit im Bereich, alle Erstparent).

Betroffene Dateien der 8 Commits: kapitel/de/06_fazit.tex (8 Commits, 16 Zeilen +/-) ·
diplomarbeit.tex (1 Commit, 3b1ccbe: Danksagung-Kommentar + 3 Owner-Textzeilen).
Kommentar-Mechanik: 5 NEUE %-Zeilen (06:112, 06:139, 06:184, 06:226, diplomarbeit.tex:176); die Zeile 06:226
wurde in sechs Folge-Commits (f7fbdf7, 0bfb17f, 3b1ccbe, 4e0a754, 9b3c202, dad2d52c) jeweils um 1-14 Sätze
ERWEITERT (ohne Zeilenumbruch, "No newline at end of file"). Zeilennummern = Stand github/main.

---

## TEIL 6 — DIE 8 COMMITS NACH 246eff9 (Form wie TEIL 1; Nummerierung 27-34 fortgesetzt)

### 27. 5aab516 "Überarbeitung Limitationen" [22.08. 19:48] — 06_fazit.tex

Kern-Änderung: zwei neue %-Zeilen, kein Textedit. (a) Z.112 zwischen \paragraph{FF3} und \paragraph{FF4};
(b) Z.139 unmittelbar vor \section{Limitierungen}.

Kommentar (a), wortgetreu:
> "Das ist ja an und für sich korrekt, dass wir hier auswerten WIE das Problem erledigt wurde und WAS das
> bedeutet. Aber wir reden zu wenig über die BEWEISE und deren FOLGEN, die wir erzeugt haben. Nach dem ersten
> Messlauf und dessen Auswertung können wir gezielt den eigentlichen Effekt der Cache line awareness aus den
> Synthese Kurven ziehen. Bitte recherchiere im Web, welche Formulierungsgedanken im Zentrum bei der
> Auswertung von Forschungsfragen stehen und welche Beweiskette wir über die Kapitel als
> je-Kapitel-Zusammenfassung unter Einzel-scope jeder Forschungs-Haupt-und-Teilfrage wir genau beantwortet
> haben. Ein weiterer Hinweis ist, dass die Hypothesen der Forschungsfragen im Nachgang nicht genau den
> Zielpfad als Fundament gelegt haben, den wir über die Kapitel hinweg sequentiell erarbeitet haben."

Kommentar (b), wortgetreu:
> "Also die Modul-Bodies sind jetzt nicht wirklich eine Limitierung, ich würde alles raus nehmen, was nicht
> belegt ist. Derzeit sind laut neuem Plan und Implementierung keine der Limitierungen mehr gültig. Die
> einzige Limitierung die mir real einfällt ist dass das Ändern von Algorithmus Versionen den recompile des
> Gesamten dafür notwendigen Lager-Stacks mit erneuter Messung und Auswertung betrifft. Eine weitere
> Einschränkung ist, dass das gesamte Lager für jeden separaten Maschinentyp und Hardware Konfiguration
> einzeln gemessen werden muss. Weitere Limitationen müssen kreativ als Designentwurf aus der Architektur
> abgeleitet werden, was derzeit alles nicht geht - aber das ist zum Glück nicht viel, bedarf aber einer Web
> Recherche. Die Einschränkungen betreffen die Nutzer-Sicht nicht die Sicht der Implementierung. Was kann
> ein Anwender mit dem System noch nicht erreichen, wenn er es heutzutage verwendet, abgesehen von den
> natürlichen und selbst gewählten Einschränkungen der Maschine auf der er arbeitet?"

Aufträge daraus: N-31 (C) FF-Beweiskette je Kapitel + Web-Recherche · N-32 (C) FF-Hypothesen an Zielpfad ·
N-33 (A) Cache-Line-Effekt aus Synthese-Kurven nach 1. Messlauf · N-34 (A) Limitierungen komplett gegen
Plan+Code, Unbelegtes raus · N-35 (A) zwei Owner-Limitierungen (Lager-Recompile bei Versionswechsel; Lager je
Maschinentyp) · N-36 (C) Web-Recherche + Design-Ableitung weiterer Nutzer-Limitationen.

### 28. 4fff92f "Mixed up Abbildungsverzeichnis und Tabellen" [22.08. 19:59] — 06_fazit.tex

Kern-Änderung: zwei neue %-Zeilen, kein Textedit. (a) Z.184 unmittelbar vor \section{Ausblick};
(b) Z.226 am Dateiende (nach dem letzten Absatz "…künftigen experimentellen Fortschritt.").

Kommentar (a), wortgetreu:
> "Es müssen jetzt auch zusätzlich Binaries mit Messfühlern und ohne ins Lager abgelegt werden und die
> synthetisierten Funktions-Kurven in Dateiform."

Kommentar (b), Erstfassung, wortgetreu:
> "Das Abbildungsverzeichnis und Tabellenverzeichnis  wird derzeit nicht von Abbildungen und Tabellen gefolgt
> und braucht eine Sichtprüfung. Es kommen erst beide Inhaltsverzeichnisse und dann nacheinander Abbildungen
> und dann Tabellen - vielleicht ist das aber wenn es zusammengehört eher ein großes Inhaltsverzeichnis, wo
> in jedem Aufführungspunkt klar durch A vs T erkennbar ist, ob es sich um eine Abbildung oder Tabelle
> handelt."

Aufträge daraus: N-37 (B) Lager: Binaries MIT und OHNE Messfühler + synthetisierte Kurven als Dateien ·
N-38 (C) Verzeichnis-Sichtprüfung / gemeinsames A-vs-T-Verzeichnis.

### 29. f7fbdf7 "PMC Messungen" [22.08. 21:08] — 06_fazit.tex

Kern-Änderung: Erweiterung von Z.226 um einen Satz (Diff = -alt/+neu derselben Zeile).
> "[...] Im Abbildungsverzeichnis fehlen die wichtigen PMC Messungen."

Aufträge daraus: N-39 (B) PMC-Messungen als Abbildungstyp im Anhang-Generator + Abbildungsverzeichnis.

### 30. 0bfb17f "Glossar überarbeiten." [22.08. 21:41] — 06_fazit.tex

Kern-Änderung: Erweiterung von Z.226 um vierzehn Sätze (größter Einzel-Kommentar der 8 Commits).
Wortgetreu (Satzweise nummeriert nur zur Zuordnung; Nummern sind nicht Owner-Text):
> (1) "ALLE Anhänge der Diplomarbeit müssen auf Konformität und repräsentierbarkeit gegen den Plan geprüft
> werden, vor allem weil neuerdings eine zeitlich und Mess-Parameter orientierte Darstellung dominiert über
> w/ma/mi Messsystem."
> (2) "Die Einzelnen Kompositionen haben jetzt Achsen-Versionierungen und Benennungen über das
> Stempelsystem, welche sich auch in den Diagrammen und tabellen identifizierbar wiederspiegeln müssen."
> (3) "Was bedeuten "Zyklen", mir ist diese Messeinrichtung nicht bekannt und sie ergibt im Kontext des
> aktuellen Mess-Ketten Verfahrens über die multiplen Schichten der Messung in Tier-Binaries keinen Sinn ->
> Die Messung verschiedener Algorithmen je Achseninterface und Tier-Binaries auf deren
> Vertrags-Gattung+Genus-Interface ist nicht sinnvoll getrennt dargestellt und die Wallclocktime Ebene der
> CEB über die Gesamtverläufe der verschiedenen Last-Framework Abläufe nicht korrekt dargelegt."
> (4) "Es gibt sehr viele Diagramme die Messwert 0 anzeigen statt NaN weil kein Messwert erhoben wurde, das
> ist keine ehrlich angezeigte Einschränkung."
> (5) "Die Auswertung der Achsen und Tier-Binary Interface Funktionen ist nicht korrekt getrennt erfolgt,
> sindern wild gemixt."
> (6) "Die Schichtung der Architektur ist im Abbildungsverzeichnis kaum erkennbar."
> (7) "Die Ordnung der vielschichtigen xlsx muss beim Ausrollen des Latex Anhangs als dritte factory neben
> xlsx und csv "serialisiert" werden, um die Kern-Messungen und Diagramme als eigene Ausgabe in Latex
> vollständig in das Dokument zu kippen."
> (8) "Am besten werden die einzelnen Mess-Strecken je binary als Zeitliche Messreihe mit allen Start und
> Endpunkten von Parametern jeweils in eine Tabellenzeile gekippt und referenziert wie ein sequentiell
> ausgerollter Baum gegliedert."
> (9) "Die Diagnose jeder Messzeile ist derzeit noch generisch und berücksichtigt nicht die vorangegangene
> Historie aller Messwerte über die Zeit."
> (10) "Alle 18 Kompositions-Achsen müssen in Zukunft variieren."
> (11) "Aussagen wie etwas ist "jetzt" der Fall, wirken wie ein Status Bericht, bitte lass dieses "jetzt"
> weg und schreibe den Satz einfach ohne, also einfache Auflistung der Fakten im Präsens ohne Zeitangabe."
> (12) "Die Gesamte Code-Struktur und Bedienungs-struktur hat sich geändert."
> (13) "Bitte prüfe jede einzelne Definition im Glossar, weil einige Definition tatsächlich jetzt noch
> abstrakter und allgemeiner gelebt werden."
(Anm.: "sindern", "wiederspiegeln", "repräsentierbarkeit" = Owner-Schreibweise, original belassen.)

Aufträge daraus: N-40 (A/B) Anhänge gegen Plan, w/ma/mi + Zeit/Parameter · N-41 (B) Stempel-Identität in
Diagrammen/Tabellen · N-42 (B) "Zyklen" = total_cycles ehrlich machen · N-43 (B) w/ma/mi-Trennung der
Auswertung · N-44 (B) NaN statt 0 Ende-zu-Ende · N-45 (C) Schichtung im Abbildungsverzeichnis ·
N-46 (B) DRITTE Factory LaTeX · N-47 (B) Zeilen-Layout je Binary als ausgerollter Baum · N-48 (B)
zeit-bewusste Diagnose je Messzeile · N-49 (B, getragen) alle 18 Achsen variieren · N-50 (C) kein "jetzt" ·
N-51 (A) Code-/Bedienungs-Struktur nach Ist-Stand · N-52 (A/C) Glossar je Definition gegen Code.

### 31. 3b1ccbe "Danksagung" [22.08. 21:57] — diplomarbeit.tex + 06_fazit.tex

Kern-Änderung (diplomarbeit.tex): neue %-Zeile Z.176 (im \ifthesisDE-Zweig, vor \acknowledgments) + drei
direkt vom Owner umgeschriebene Textzeilen der deutschen Danksagung (Z.178, 180-182).
Kommentar, wortgetreu:
> "Die Danksagung hinkt noch im Satzbau, aber sonst kann sie so stehen bleiben"
Owner-Textedit (neue Fassung, wortgetreu):
> "Mein Dank gilt zuerst apl.\ Prof.\ Dr.-Ing.\ Dirk Habich --- einem bescheidenen und disziplinierten
> Menschen --- für die engagierte Betreuung dieser Arbeit: Trotz stets knapper Ressourcen an Zeit hat er
> sich dennoch stets die Zeit für präzise Rückfragen genommen, um klare Prioritäten und den Freiraum, was
> diese Arbeit weitgehend eigenständig entwickeln soll, mit punktueller Unterstützung dort, wo sie
> gebraucht wurde, zu unterstützen. Dr.-Ing.\ Alexander Krause danke ich [...]"
(Anm.: Der Satzbau-Mangel, den der Kommentar benennt, liegt in genau dieser Owner-Fassung — "um ... zu
unterstützen" — d.h. der Auftrag ist Glättung UNTER ERHALT des Owner-Inhalts, nicht Rückbau auf den
Session-Satz. Die Zeile "% ENTWURF Danksagung (Rahmen-Pass 02.08.2026, F1-Richtung) -- finale Owner-Freigabe
vor Abgabe." bleibt darüber stehen; "sonst kann sie so stehen bleiben" = inhaltliche Freigabe erteilt.)

Kern-Änderung (06_fazit.tex): Erweiterung von Z.226 um zwei Sätze, wortgetreu:
> "[...] Die Aufführung der Achsen und Bausteine ist sehr gelungen, muss jetzt aber noch ergänzt werden.
> Die Architektur-Entscheidungen im Ist-Zustand haben sich grundsätzlich geändert, dabei sind Begriffe wie
> honest-0 nicht menschenlesbar und müssen mit Begriffen aus der Wissenschaft (web recherche) ausgedrückt
> werden."

Aufträge daraus: N-53 (A) Anhang D (Achsen/Bausteine) ergänzen + Anhang E (Architektur-Entscheidungen)
nach Ist-Stand neu · N-54 (C) "honest-0"/"honest-empty" durch wissenschaftliche Begriffe · N-55 (C)
Danksagung glätten (DE) + EN nachziehen.

### 32. 4e0a754 "Übersetzung nachziehen" [22.08. 21:59] — 06_fazit.tex

Erweiterung von Z.226 um einen Satz, wortgetreu:
> "[...] Die GESAMTE englische Übersetzung muss zum Schluss nach allen Korrekturen der deutschen Übersetzung
> folgen."
Aufträge daraus: N-56 (C) EN-Gesamtübersetzung als LETZTE Stufe.

### 33. 9b3c202 "Lizenz update" [22.08. 22:06] — 06_fazit.tex

Erweiterung von Z.226 um einen Satz, wortgetreu:
> "[...] Die Erklärungen zu Lizenzen und Urheberrecht in der Diplomarbeit müssen angepasst werden, weil wir
> den Code dann doch gesperrt hatten, aber nicht die Diplomarbeit und die XML Konfigurationen (so sollte es
> im Code zumindest sein), Forschung hatten wir freigegeben, bitte übernimm die Lizenzen aus dem Code."
Aufträge daraus: N-57 (C, #143) Lizenz-/Urheberrechts-Text aus dem Code übernehmen · N-58 (B, #143)
XML-Konfigurationen im Code tatsächlich freistellen (Klammer "so sollte es im Code zumindest sein").

### 34. dad2d52c "Übersetzungs-Schärfung" [23.08. 13:43] — 06_fazit.tex

Erweiterung von Z.226 um einen Satz, wortgetreu:
> "[...] Grundsätzlich sollte die gesamte Diplomarbeit zuerst korrekt ergänzt, dann als Stufe ins englische
> übersetzt werden, und zum schluss muss die Deusche Übersetzung durch eine englische Rück-Übersetzung aus
> dem Englischen formulierungstechnisch und zur Schärfung von mikro-Wörtern, geschärft werden."
Aufträge daraus: N-59 (C) Drei-Stufen-Prozess DE -> EN -> DE-Schärfung per Rück-Übersetzung.

---

## TEIL 7 — NEUE AUFTRÄGE (Form wie TEIL 2; Nummern 31-59 setzen TEIL 2 fort)

Richtung: (A) CODE-FÜHRT = Thesis-Text gegen Code nachformulieren, Träger #121 · (B) KOMMENTAR-FÜHRT =
Thesis -> Plan -> Code, etwas fehlt/ist falsch im Code oder Plan, Träger nach Gegenstand · (C) THESIS-
STRUKTUR/TEXT (Verzeichnisse, Glossar, Danksagung, Übersetzung, Lizenz-Zeile), Träger #121 bzw. #143.
Fundstellen = nur Orte (kein Volllesen); "KEIN TREFFER" = Muster + Gegenprobe genannt.

### 7a. Fazit-Beweisführung und Limitierungen (5aab516)
31. **(C) FF-Beweiskette je Kapitel** — Web-Recherche "Formulierungsgedanken bei der Auswertung von
    Forschungsfragen"; je Kapitel eine Zusammenfassung unter Einzel-Scope jeder Haupt-/Teilfrage; BEWEISE
    und FOLGEN statt WIE/WAS. [5aab516, 06:112] -> #121 (erweitert Extrakt #28 "FF-Teilfragen wiederholen").
32. **(C) FF-Hypothesen an den Zielpfad angleichen** — "die Hypothesen der Forschungsfragen [haben] im
    Nachgang nicht genau den Zielpfad als Fundament gelegt": Einleitung (sec:rqs) und Fazit gegeneinander
    nachziehen. [5aab516] -> #121.
33. **(A) Cache-Line-Effekt aus den Synthese-Kurven** — nach dem ersten Messlauf den eigentlichen Effekt
    "gezielt [...] aus den Synthese Kurven ziehen" (Plan: docs/plaene/20260806-PLAN-messkurven-synthese-
    und-hybrid-binary.md; Daten: Voll-Bau-4, KON132-02 n_bau 524288). [5aab516] -> #121, datenabhängig.
34. **(A) Limitierungen komplett neu gegen Plan+Code** — Owner: "keine der Limitierungen mehr gültig",
    "alles raus nehmen, was nicht belegt ist". Betroffen: alle 7 Items 06:141-183 (Modul-Bodies, Voll-Bau
    ausstehend, Ergebnis-Kapitel, HW-Zähler default aus, HW-Erkennung Teilausbau, CSV-Stand, Smoke-
    Vorbehalte) + anhang/de/tabellen/le_limitierung.tex. Bestand: docs/plaene/20260806-DIFF-thesis-soll-
    gegen-ledger-und-code.md:77,125-143,251 (F-04 "PMC-Limitierung in Gegenrichtung falsch", F-09 "19 vs 18
    Achsen"). Session-Seite (origin/development) hat Item HW-Zähler um Branch-Misses M-3a erweitert —
    ebenfalls Prüfling. [5aab516, 06:139] -> #121.
35. **(A) Zwei Owner-Limitierungen aufnehmen** — (i) Algorithmus-Versionswechsel = Recompile des gesamten
    dafür nötigen Lager-Stacks + erneute Messung/Auswertung (Plan-Bestand: Stempel-Versionierung,
    Ledger:25778/25799 kSystemAxisCodeVersions DOPPEL-ABSICHT; AXIS_ALGO_VERSION-Köpfe in ce libs);
    (ii) das gesamte Lager je Maschinentyp/Hardware-Konfiguration einzeln messen (Plan-Bestand:
    Ledger:2606 "Typ-3-Einträge sind MASCHINENGEBUNDEN ... Schlüssel trägt machine_id";
    docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:30,831-833). Beides ist im Plan
    gedeckt -> reine Text-Aufnahme. [5aab516] -> #121 (Gegenprobe an #57).
36. **(C) Weitere Nutzer-Limitationen per Web-Recherche + Design-Ableitung** — Leitfrage des Owners: "Was
    kann ein Anwender mit dem System noch nicht erreichen [...]?" [5aab516] -> #121.

### 7b. Lager, Anhang-Generator und Auswertung (4fff92f, f7fbdf7, 0bfb17f)
37. **(B) Lager: Binaries MIT und OHNE Messfühler + synthetisierte Kurven in Dateiform** — beide
    Binary-Varianten einlagern und die synthetisierten Funktions-Kurven als Dateien im Lager ablegen.
    Code-Bestand: ce libs/cache_engine/builder/bestandslog/lager_pfad_grammatik.hpp (kv-Grammatik;
    grep 'messf|beobacht|observer|kurve|curve|sidecar' = 0 Treffer -> keine Messfühler-/Kurven-Facette),
    lager_baum_writer.hpp (realm=binaries|messdaten, kein Kurven-Realm), heuristik/measurement_curve_loader.hpp
    (lädt Kurven aus CSV-Zellen, kein Lager-Slot), heuristik/axis_spline.hpp, builder/curve_fit/.
    Plan-Bestand: 20260806-PLAN-messkurven-synthese-und-hybrid-binary.md:47,73,254 (Synthese, Break-Even);
    Ledger:18717,33077,33389-33404 (ohne Messfühler erneut kompilieren; 3 Stufen/6 CEBs).
    [4fff92f, 06:184] -> **#57 Lager** (Facette zu Extrakt #7 zwei Release-Artefakte und #18 Lager-Semantik).
38. **(C) Abbildungs-/Tabellenverzeichnis** — Sichtprüfung der Reihenfolge; Option: EIN gemeinsames
    Verzeichnis mit A-vs-T-Kennung je Eintrag. [4fff92f, 06:226] -> #121.
39. **(B) PMC-Messungen als Abbildungen** — "Im Abbildungsverzeichnis fehlen die wichtigen PMC Messungen".
    Bestand: super Code/08_appendix_generator (Heatmap/3D/Ratio/Normbar/Sweep/Forest/Pareto/ECDF/Range/
    Segment-Attribution/Observer-Detail/Achsen-Inventar/Bias/Exchange/Limitierung, vgl. docs/plaene/
    20260808-VORLAGE-latex-anlage-xml-gesteuert.md:36) — kein PMC-Abbildungstyp; Code/05_diagram_generator
    (pmc|cache_miss|dtlb: hpp 2, cpp 1). [f7fbdf7] -> **#82 PMC** + #41 F1-Durchstich (E-18-Vorwärtskanal).
40. **(A/B) Alle Anhänge gegen den Plan** — Konformität/Repräsentierbarkeit; "zeitlich und Mess-Parameter
    orientierte Darstellung dominiert über w/ma/mi Messsystem" -> Generator muss Zeit/Parameter UND die
    w/ma/mi-Schichten tragen. [0bfb17f (1)] -> #121 (Text) + #41 (Generator).
41. **(B) Stempel-Identität in Diagrammen und Tabellen** — Achsen-Versionierung + Benennung über das
    Stempelsystem müssen in jedem Diagramm/jeder Tabelle identifizierbar sein. Bestand: ce
    tools/latex_anhang/latex_anhang.hpp:33-45 (CsvRow trägt nur permutation_id + fingerprint uint64);
    ce abi/anatomy_stamp_entries.hpp, anatomy_version_stamp.hpp, builder/ceb_version_stamp.hpp (Stempel-
    Quellen). Plan: Ledger:24612 (W12-B Stempel-KONSUMPTION). [0bfb17f (2)] -> **#41** (+ #147 Emission,
    + #18 S-13 Blatt-/Dateinamen nach lager_pfad_grammatik).
42. **(B) "Zyklen" ehrlich machen** — Spalte total_cycles ist KEIN Zyklenzähler: ce
    builder/measurement_snapshot.hpp:45 "std::uint64_t total_cycles = 0; // repräsentative Latenz (ns),
    Stufe-05-Konvention", :136 "m.total_cycles = merged_p50_ns(r)"; eingefroren in
    include/cache_engine/measurement/schema_freeze.hpp:425 und pipeline_csv_schema.hpp:54; Konsumenten
    execution_engine/src/result_aggregator.cpp:39-40,71,95, tools/latex_anhang/latex_anhang.hpp:39;
    Thesis: anhang/de/tabellen/cartesian_smoke43_*.tex, v5_pipeline_demo_*.tex, kapitel/de/02_*.tex
    ("Zyklen"). Ledger:22567 nennt total_cycles als golden-Spalte. Auftrag: Spalte umbenennen/umdeuten
    (p50-Latenz ns) ODER echten PMC-cycles-Kanal einführen; Schema-Freeze + golden bewusst brechen
    (Memory: Invalidieren = Ziel, Messdaten bleiben). [0bfb17f (3)] -> **#90 Kanalwerk** (+ #18 S-13).
43. **(B) w/ma/mi-Trennung der Auswertung** — Achsen-Interface (mi) vs. Tier-Binary Gattung+Genus-Interface
    (ma) vs. CEB-Wallclock über die Gesamtverläufe der Last-Frameworks (w) getrennt darstellen; derzeit
    "wild gemixt". Bestand: super Code/05_diagram_generator + 08_appendix_generator (keine Schicht-Trennung
    erkennbar), ce pipeline_csv_schema.hpp (Observer-Spalten). Plan: docs/plaene/20260820-DESIGN-90-
    kanalwerk-arena.md, 20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md. [0bfb17f (3)+(5)]
    -> **#90 Kanalwerk** (+ #41).
44. **(B) NaN statt 0 Ende-zu-Ende** — nicht erhobene Messwerte in Schema, CSV/xlsx, Diagrammen und
    Tabellen als NaN/leer, nie 0. Bestand: honest-empty-Welle ba5e48eb (super Code/05_diagram_generator,
    Ledger:29158/29169: "nur Median>0 als Daten"); ce measurement_snapshot schreibt nicht verdrahtete Zähler
    als 0 (Thesis 05: "Spalten ... tragen deshalb keine gemessene Null"); xlsx_ergebnis_writer.cpp:43-47
    (nan/inf-Token-Lücke, "BEWUSSTE, BENANNTE LUECKE"). Owner sieht am 22.08. weiterhin 0-Diagramme ->
    Nachweis über den E-18-Vorwärtskanal (Anhang ace9043 vom 14.08.). [0bfb17f (4)] -> **#41** (+ #90).
45. **(C) Schichtung der Architektur im Abbildungsverzeichnis** erkennbar machen (Abbildungs-Programm
    Extrakt #24 erweitern). [0bfb17f (6)] -> #121.
46. **(B) DRITTE Factory LaTeX neben xlsx und csv** — die Ordnung der vielschichtigen xlsx beim Ausrollen
    des LaTeX-Anhangs "serialisieren"; Kern-Messungen + Diagramme als eigene LaTeX-Ausgabe vollständig ins
    Dokument. Bestand: ce builder/lager_ablage/ergebnis_mappe.hpp:2-22 (Abstract Factory
    ErgebnisMappenFactory, ErgebnisFormat::xlsx|csv; Owner-Kern 26.07./09.08. zitiert), profile_facade/
    ergebnis_mappe_naht.hpp:117-135,459-477 (latex_table = unabhängiger Ausgabe-KANAL, kein Format),
    include/cache_engine/measurement/writeback_method_registry.hpp:3-4,32,49 (WritebackMethod::LatexTable,
    "KEIN pdf"), tools/latex_anhang/ (CSV 16-col -> LaTeX; ce-Ledger architektur-ziele-offene-punkte-
    ledger.md:31-35 "NICHT tot"), super Code/08_appendix_generator (E-18). Plan: docs/plaene/20260808-
    VORLAGE-latex-anlage-xml-gesteuert.md:30 ("E-18 = LaTeX-Anhang-VORWAERTS-Kanal je CI = HAUPT-ZIEL"),
    20260817-DESIGN-s13-buendel-di25.md. FEHLT: ErgebnisFormat::latex als dritte Factory, die die
    Blatt-Ordnung der xlsx (ein Blatt je Unter-Achsen-Permutation + Info-Blatt) serialisiert.
    [0bfb17f (7)] -> **#18 S-13** (+ #41 E-18).
47. **(B) Zeilen-Layout des LaTeX-Anhangs** — je Binary EINE Tabellenzeile = zeitliche Messreihe mit allen
    Start-/Endpunkten der Parameter, referenziert "wie ein sequentiell ausgerollter Baum". Bestand: ce
    builder/bestandslog/lager_baum_writer.hpp (gattung -> genus -> realm -> Rest), builder/experiment_tree/
    experiment_tree.hpp (B+-Experiment-Baum). [0bfb17f (8)] -> **#18 S-13** (Teil von 46).
48. **(B) Zeit-bewusste Diagnose je Messzeile** — Diagnose muss die vorangegangene Historie aller Messwerte
    über die Zeit berücksichtigen (derzeit generisch). Bestand: super Code/05_diagram_generator (diagnos:
    hpp 2, cpp 3), Thesis anhang/de/tabellen/ld_exchange_*.tex (Diagnose-Spalte); ce profile_facade/
    ergebnis_mappe_naht.hpp:182 diagnose() = Formatwahl-Diagnose (anderer Gegenstand).
    GEDÄCHTNIS/BESTAND GEPRÜFT, KEIN TREFFER: Muster 'Diagnose.*(Historie|Verlauf|Zeile|Zeit)' in
    docs/plaene + Ledger + ledger-sections; Gegenprobe 'Diagnose' allein = 46 Ledger-Treffer, alle andere
    Bedeutung (Bau-/CI-Diagnose). [0bfb17f (9)] -> **NEU**, Vorschlag Sammel-Träger #130.
49. **(B, getragen) Alle 18 Kompositions-Achsen variieren** — Smoke-Reihe variierte 7 Achsen; Kampagne =
    Voll-Bau-4 (KON132-02 n_bau 524288; Ledger:6612 "A1-DURCHZUG (KON60-03, alle 18 Achsen)"). Text (A)
    nach der Kampagne. [0bfb17f (10)] -> Trigger Voll-Bau-4 / #7 S-19.
50. **(C) Sprachregel "kein jetzt"** — Fakten im Präsens ohne Zeitangabe (Verschärfung der Ist-Stand-
    Doktrin Extrakt #30). [0bfb17f (11)] -> #121.
51. **(A) Code- und Bedienungs-Struktur nach Ist-Stand** — "Die Gesamte Code-Struktur und Bedienungs-
    struktur hat sich geändert" (deckt sich mit Extrakt #26 Kap.-4-Kernstrecke; zusätzlich Anhang Code/
    Bedienung). [0bfb17f (12)] -> #121.
52. **(A/C) Glossar je Definition gegen Code** — anhang/de/C_glossary.tex (+ en): jede Definition einzeln;
    "abstrakter und allgemeiner gelebt". Bestand: Ledger:5116,23079-23184 (Glossar-Abgleiche Juli).
    [0bfb17f (13)] -> #121.

### 7c. Anhänge D/E, Sprache, Danksagung, Übersetzung, Lizenz (3b1ccbe, 4e0a754, 9b3c202, dad2d52c)
53. **(A) Anhang D + Anhang E neu nach Ist-Stand** — D_building_block_matrix ("sehr gelungen, muss ... noch
    ergänzt werden"), E_architecture_decisions ("grundsätzlich geändert"). [3b1ccbe] -> #121.
54. **(C) "honest-0"/"honest-empty" ersetzen** — durch Begriffe aus der Wissenschaft (Web-Recherche);
    Vorkommen github/main: anhang/de/A_measurements.tex, D_building_block_matrix.tex,
    E_architecture_decisions.tex, tabellen/le_limitierung.tex, kapitel/de/03 (3x), 04 (1x). [3b1ccbe] -> #121.
55. **(C) Danksagung glätten + EN nachziehen** — Satzbau der Owner-Fassung (Z.178-182) glätten UNTER ERHALT
    der Owner-Inhalte (bescheiden UND diszipliniert; knappe Ressourcen an Zeit; Freiraum zur eigenständigen
    Entwicklung; punktuelle Unterstützung; Krause; UltiHash); EN-Zweig folgt; ENTWURF-Vermerk 02.08.
    fortschreiben (inhaltliche Owner-Freigabe liegt mit "sonst kann sie so stehen bleiben" vor; Ledger:4596
    führt die Danksagung als Seitenlinien-Paket). [3b1ccbe, diplomarbeit.tex:176-182] -> #121.
56. **(C) EN-Gesamtübersetzung als LETZTE Stufe** nach allen DE-Korrekturen. [4e0a754] -> #121.
57. **(C, #143) Lizenz-/Urheberrechts-Text aus dem Code übernehmen** — Owner-Sachverhalt: Code gesperrt
    (ce: LICENSE = Comdare Research License 1.0; Köpfe LicenseRef-Comdare-Research-1.0), Diplomarbeit und
    XML-Konfigurationen NICHT gesperrt, Forschung frei. Bestand Thesis: origin/development
    diplomarbeit.tex:207-260 (Session 14.08., 762599f: Comdare Research License 1.0 für ce + PRT-ART,
    Change Date 2031-08-10, super Apache-2.0, Thesis-Text = privates Copyright; docs/plaene/20260807-
    VORLAGE-lizenzwahl-drei-repos.md:5,120-134; Ledger:33301 "Thesis nennt seit 798e946 die korrekte
    Lizenz"). FEHLT im Thesis-Text: die XML-Konfigurationen als freier Bestandteil; das Thesis-Repo trägt
    auf github/main und origin/development KEINE LICENSE-Datei. [9b3c202] -> **#143** (Lande-Zug Lizenz).
58. **(B, #143) XML-Konfigurationen im Code freistellen** — Befund ce @8c861759 (a5-reuse, reuse-COMPLIANT):
    REUSE.toml annotiert path = "**" mit LicenseRef-Comdare-Research-1.0 (precedence closest); 193 XML,
    davon 46 mit SPDX CC0-1.0 — ALLE 46 sind ext/traversal/P29-RCU/userspace-rcu (vendoriert); die 130
    Comdare-Konfigurations-XML unter libs/cache_engine/algorithm_profiles/{sota 34, paper_experiments 33,
    allocators 23, load_profiles 21, thesis_profiles 11}, builder/example_configs (4), permutation_axes.xml
    u.a. sind kopflos und damit GESPERRT (Research License). Owner: "(so sollte es im Code zumindest sein)"
    -> eigene [[annotations]]-Regel für die Konfigurations-XML mit freier Lizenz (Kandidaten aus LICENSES/:
    CC0-1.0, CC-BY-4.0, Apache-2.0 — Wahl = Owner-Entscheid), reuse lint erneut, Ledger-Vermerk.
    [9b3c202] -> **#143** (+ Owner-Frage Lizenzwahl der XML).
59. **(C) Drei-Stufen-Prozess DE -> EN -> DE-Schärfung** — zuerst DE korrekt ergänzen, dann EN übersetzen,
    zuletzt DE durch englische Rück-Übersetzung formulierungstechnisch und in Mikro-Wörtern schärfen.
    GEDÄCHTNIS/BESTAND GEPRÜFT, KEIN TREFFER: Muster 'Rueck-?Uebersetzung|Rück-?Übersetzung|
    back-?translation' in docs/plaene + Ledger + ledger-sections = 0 Dateien (Gegenprobe 'Uebersetzung'
    trifft nur Compiler-"Uebersetzungsvorgaenge", Ledger:17867ff). [dad2d52c] -> #121 (Prozess-Reihenfolge,
    ordnet Extrakt #22-#30 und N-56 zeitlich).

Zählwerk TEIL 7: 29 neue Aufträge (31-59): 13x (B) [37,39,41,42,43,44,46,47,48,49,58 + Anteile 40],
7x (A) [33,34,35,51,53 + Anteile 40,52], 12x (C) [31,32,36,38,45,50,54,55,56,57,59 + Anteil 52]
(Doppelrichtungen 40 und 52 je einmal in beiden Spalten gezählt). Träger: #121 x17 · #143 x2 · #57 x1 ·
#82 x1 · #41 x3 · #90 x2 · #18 x2 · Voll-Bau-4/#7 x1 · NEU (#130-Vorschlag) x1 [48].

---

## TEIL 8 — GEGENPROBE ÜBER ALLE 34 COMMITS (c2d21fae..github/main)

Methode: `git diff -U0 c2d21fae github/main | grep -E '^\+[[:space:]]*%'` = **52 hinzugefügte %-Zeilen**;
`grep -E '^-[[:space:]]*%'` = **1 entfernte %-Zeile** (die c2d21fa-Fassung der Blut-Metapher, 03:978, durch
8feab75 erweitert -> ersetzt, nicht gestrichen); Kommentare INNERHALB geänderter Textzeilen
(Text ... % Kommentar) = **0**. Zeilennummern unten = Ausgabezeile des kumulierten -U0-Diffs.

ZÄHLWERK: 52 gesamt · **47 zugeordnet TEIL 2** (davon 1 reines Lob ohne Auftrag, 6 nur über TEIL 1/TEIL 3
zuordenbar — als TEIL-2-Nummernlücke vermerkt) · **5 neu (TEIL 7)** · **0 unzugeordnet**.

Zuordnung (Datei:Diffzeile -> Kurzinhalt -> TEIL-2-Nr. bzw. TEIL-7-Nr.):
diplomarbeit.tex
- L6   Danksagung hinkt im Satzbau                                    -> N-55 (neu)
03_messsystem_prtart.tex
- L26  Blut-Metapher (erweitert: System-Unter-Achsen permutieren)     -> #27 (Bestandsteil: #30; --debug/
       deep-research-Erfolgsparameter stammen aus c2d21fa, s.u.)
- L29  "Debug ist ein Flag und kein Zustand"                          -> TEIL 1 #1 / #27 (Nummernlücke)
- L35  "Ab hier sieht alles sehr gut aus"                             -> Lob, kein Auftrag
- L38  Fingerprint SHA256 nach Code                                   -> #27 (+ #95)
- L41  Stempel-Syntax je Träger-Stufe feiner                          -> #27
- L46  Abbildung Sichtprüfung                                         -> #24
- L49  xlsx statt CSV                                                 -> #29 (+ #18)
- L52  Clusterung + Hybrid-Live-Ranking + META-REGEL                  -> #5, #6 (+ Kopf-Regel)
- L55  Hybrid-State-Sync + Wechselprotokoll                           -> #7
- L58  Kurven-Bildung + compare/release-Semantik                      -> #27
- L67  Soll-Zustand + Lagerhaltung synthetisierter Kurven + w/ma/mi   -> #27 (+ #57)
- L70  Filterkette + Messfehler-Interpolation 5. Komponente           -> #8 (+ #88)
04_implementierung.tex
- L77  selbst-optimierende Compiler-Compiler-Struktur                 -> TEIL 1 #12 / #27 (Nummernlücke)
- L80  4. Repository + EE/search_engine + SOTA-XML + Rang 2/3 + Skel. -> #27 (+ #26)
- L85  CRTP-Referenz + Fußnoten-Delegation                            -> #22
- L88  Historisches wenig relevant                                    -> #30
- L91  variant-/virtual-Verbot + Ledger-Aufräum-Vermerk               -> TEIL 1 #14 / #30 + #117 (Lücke)
- L94  Haupt-/Unter-/Meta-Meta-Achsen je Kategorie                    -> #26
- L97  Umzüge nicht historisch                                        -> #30
- L100 konzeptionelle Hierarchie gewandelt                            -> #26
- L103 Absätze bis "Zwei Eigenschaften"/"Qualitätssicherung" veraltet -> #26
- L106 Deep-Research Kap.4 + wiss. Sprache + E1-E4-Bild + Verträge    -> #23, #24, #20, #30
- L109 Contract-Tests an xlsx statt CSV                               -> #13
- L112 Zwei-Gate-Protokoll + dynamische Mächtigkeit                   -> #27 (+ #7 S-19)
- L115 Mess-Achse treibt Freigabe über CEB                            -> #12
- L118 M0-M3-Taxonomie + Konzept-Bilder                               -> TEIL 3 (+ #24) (nicht in TEIL 2)
- L121 checkpoint_measure-Abschaltungsstufen + release + PMC-Toolings -> #9 (+ #15)
- L124 hunderte Messkategorien + IMeasurementSource + "entfesselt"    -> #10, #11
- L127 "in die System-Achse eingepflegt"                              -> #27
- L130 System-Achsen permutieren HW-Erweiterungen                     -> #27
- L133 Designpatterns + Grafik je Muster                              -> #24
05_evaluation.tex
- L140 Evaluation Thema + Methodik + Deep-Research + Default-Workload -> #25, #3, #1
- L142 Planer-CLI-XML-Wizard mit HW-Filter                            -> #2
- L145 PMC-Abschnitt wesentlich überholt                              -> #25 (+ #15/#82)
- L148 Zeit+Observer in checkpoint_measure, w/ma/mi-Verantwortung     -> #9 (+ #25)
- L151 -O3 wählbar halten                                             -> #14
- L154 Original-Compiler-Nachweis-System                              -> #16
- L157 CEB-Threads + Lager-Prinzip verbildlichen                      -> #29, #24
- L160 Messkurvensystem grafisch + Hybrid kompiliert nur via CEB      -> #24 (+ #29; Hybrid-Satz Lücke)
- L163 mit Messfühler langsamer als ohne                              -> #17
- L166 Abschnitt veraltet, CSV aus xlsx, Stempelsystem fehlt          -> #29
- L168 Auswertungslogik doppelt, XML-Bezug fehlt                      -> #29
- L170 Kernaussage 3. Mal, Überleitung per Web-Recherche              -> #29
06_fazit.tex
- L177 wiss. Sprache, "datierbare Umzüge", Historie                   -> #28, #30
- L180 FF0 ohne Messwerte unbeantwortet                               -> #28
- L183 19. optionale Achse + "Abgangs-Wache"                          -> #28 + #86 (TEIL 1 #26; Lücke)
- L186 Messung immer an/Lager, Heimspiel-Bias, Teilfragen, e-Suffix   -> #18, #19, #28
- L189 (06:112) Beweise/Folgen, Web-Recherche, Hypothesen             -> N-31, N-32, N-33 (neu)
- L192 (06:139) Limitierungen                                         -> N-34, N-35, N-36 (neu)
- L195 (06:184) Lager: Binaries mit/ohne Messfühler + Kurven-Dateien  -> N-37 (neu)
- L198 (06:226) Sammel-Kommentar (Verzeichnisse ... Rück-Übersetzung) -> N-38..N-59 (neu)

UNZUGEORDNET: keine.

NEBENBEFUNDE DER GEGENPROBE (für das Original-Extrakt):
- FEHLZUORDNUNG im Extrakt TEIL 1 #1 (8feab75): die Kommentare "Ist find wirklich eine offizielle Methode
  von std::map ...", "PMC ist default immer an ...", "Sub-Achse vs Unter-Achse" und "getrennte Messung von
  P-Cores" stehen NICHT in 8feab75, sondern bereits in **c2d21fa** (Vorgänger-Audit, Träger #77); Nachweis:
  git log -S über github/main nennt nur c2d21fa, im Bereich c2d21fae..github/main 0 Treffer. Inhalt und
  Aufträge (#4, #15, #21) bleiben gültig; sie liegen aber schon im merge-base und damit in origin/development.
- 8feab75 selbst trägt in 03: die Blut-Erweiterung (L26), "Debug ist ein Flag" (L29), "Ab hier ... gut"
  (L35), SHA256 (L38), Stempel-Syntax (L41) + 3 Owner-Textedits ("Map-Hülle", "gelten als
  übersetzungsstatisch", "orchestriert den Bau").
- Owner-TEXTEDITS im Bereich (keine %-Zeilen, im Merge als Text zu erhalten): 03:917 "Map-Hülle";
  03:1050 "gelten als übersetzungsstatisch" ("ehrlich" gestrichen); 03:1179 "orchestriert den Bau" ("mit
  ihnen" gestrichen); 03:1486 "Heuristik-Tier-Binary bestehend aus den besten gemischten cache aware
  binaries für die vermessenen Lasten"; 03:1488 "sind das compare Erzeugnis"; 04:35 "was durch den
  Anwender getestet wird"; diplomarbeit.tex:178,180-182 (Danksagung, 3b1ccbe).

---

## TEIL 9 — WARNUNGEN FÜR DEN LAUFENDEN MERGE (nur Hinweise; nichts angefasst)

Merge-Sicht (read-only, git merge-tree origin/development github/main): merge-base = c2d21fae; beide Seiten
änderten diplomarbeit.tex, 03, 04, 05, 06; **genau EIN Konflikt: kapitel/de/05_evaluation.tex** (zwei
Hunks); 03/04/06/diplomarbeit.tex auto-mergen. origin/development = 13 Session-Commits (07.-16.08.).

9.1 %-ZEILEN DER RICHTUNG (B), DIE IM MERGE-ERGEBNIS UNVERÄNDERT ERHALTEN BLEIBEN MÜSSEN (Eingang #121;
zugleich Eingang der jeweiligen Code-/Plan-Träger):
- 03: cf17d1d/08cb848 (Clusterung + Hybrid-Live, L52) · 3add1f3/012e2d3/a8097a9 (State-Sync, L55) ·
  e3f58c8 (Lagerhaltung synthetisierter Kurven, L67) · 2989c80/45471b7 (Messfehler 5. Komponente, L70) ·
  8feab75 (SHA256 L38, Stempel-Syntax L41; die #4/#15/#21-Kommentare liegen in c2d21fa).
- 04: 2d7a567 (Vertrags-Flächen "Code nachziehen", xlsx-Contract-Tests, "so sollte es auch im code sein"
  L106/L109/L115) · cc04be1/acc6c42 (Abschaltungsstufen "im Code und hier nachgezogen", L121) ·
  4f59a18 (IMeasurementSource je Achsen-Interface, "entfesselte" Nachmessung, L124) · 019a25b/cc04be1
  (M0-M3, L118).
- 05: 728fc74 (Wizard "fehlt auch noch im Code", -O3 wählbar, Default-Workload; L140/L142/L151) ·
  ce9bfa6 (Original-Compiler-Nachweis L154, Plausibilitäts-Invariante L163).
- 06: 246eff9 (Lager immer an, e-Suffix-Ersatz, 19. Achse; L183/L186) · 4fff92f (Lager mit/ohne
  Messfühler + Kurven-Dateien, 06:184) · 0bfb17f/3b1ccbe/9b3c202/dad2d52c (Sammelzeile 06:226: dritte
  Factory, NaN statt 0, Stempel in Diagrammen, Zyklen, Diagnose, 18 Achsen, Lizenz-Klammer) ·
  f7fbdf7 (PMC-Abbildungen, in 06:226).
- Die Zeile 06:226 ist EINE physische Zeile ohne Zeilenende ("No newline at end of file"): beim Merge
  nicht umbrechen/kürzen, sonst reißt die Satzkette der sechs Erweiterungen.

9.2 DER KONFLIKT 05_evaluation.tex — Owner-Absicht vs. Session-Text:
- Hunk 1 (Ergebnis-Z.91-98): origin/development fügte den Absatz "Zum Stand dieser Fassung ist das zweite
  Regime entworfen, aber nicht vollzogen: ... Talos-Spiegel ... nach der Abgabe erhoben." ein; github/main
  setzte an dieselbe Leerzeile den Kommentar "% Dieser Abschnitt ist wesentlich überholt, die Messund
  erhebt nun so einiges mit PMC". KEINE Absichts-Kollision, aber ein ANKER-Problem: der Kommentar meint den
  FOLGE-Absatz "Davon zu trennen ist, welche Zähler ... generische Zähler ..." — Lösung, die beides erhält:
  Session-Absatz ZUERST, dann die Kommentarzeile, dann "Davon zu trennen ...". Inhaltlich: die
  Session-Fassung "vier generische Zähler ... seit M-3a Branch-Misses" ist gegenüber dem Owner-Wort
  ("erhebt nun so einiges mit PMC", #82/#83 RAW-Kataloge) ebenfalls veraltet — beides ist Eingang von #121,
  keine Merge-Entscheidung.
- Hunk 2 (Ergebnis-Z.133-142): origin/development ersetzte "mit über HDR-Histogramme bestimmten
  Perzentilen vermessen." durch "vermessen; die Latenz-Perzentile bestimmt die nachgelagerte Auswertung
  nearest-rank aus den Rohwerten und ergänzt sie um die HDR-Verteilungssicht"; github/main behielt den
  alten Satz und hängte "% Die CEB steuert die Threads ... Das Prinzip des Lagers wurde nie richtig
  bildlicht ..." an. KEINE Absichts-Kollision: Session-Satz (code-geführt, nearest-rank) übernehmen UND
  die Kommentarzeile direkt davor lassen, wo "Auch der Mess-Betrieb ist Teil dieser Fairness-Regeln ..."
  beginnt (der Kommentar meint diesen Folge-Absatz).
- Kein Owner-Kommentar in 05 widerspricht dem Session-Text inhaltlich; Kollisionen bestehen nur in der
  Aktualität (Session 07.-16.08. vs. Owner 19.-23.08.) und lösen sich im #121-Durchlauf, nicht im Merge.

9.3 ABSICHTS-KOLLISIONEN IN AUTO-GEMERGTEN DATEIEN (kein Textkonflikt, aber #121-relevant):
- 03 (Session 1157-1173 vs. Owner-Kommentare L38 SHA256 und L41 Stempel-Syntax): Session-Text schreibt
  weiterhin "Fingerprint-Zeile: einem SHA512, dessen Preimage ..." — Owner: "SHA256 wird jetzt verwendet"
  (#95). Beides bleibt im Merge; der Textnachzug (Extrakt #27) muss auf SHA-256 lauten.
- 03 (Session: "Suffix e steht seit der Flag-Grammatik v2 für einen Efficiency-Core-Algorithmus, nicht
  für eine Prüflings-Herkunft") vs. 06 FF2-Text ("über das e-Suffix ... unterscheidbar") + Owner 246eff9
  ("e-Suffix wurde ersetzt und es muss ein anderes Tag gefunden werden"): Session und Owner sind
  KONSISTENT (e ≠ Prüfling); der 06-Text ist der veraltete Teil; Auftrag #19 (neues Tag) bleibt (B).
- 04 (Session-Absatz 502-512: Statistik-Gate + Segment-Timing-Gate, Mess-Gate-Glied im Fingerprint-Preimage)
  liegt zwischen den Owner-Kommentaren cc04be1 (Abschaltungsstufen, L121) und 4f59a18 (L124): Session =
  Ist-Code (zwei Gates), Owner = Soll-Modell (Stufe 1 Parameter aus, Stufe 2 release alles aus) — im Merge
  beides erhalten; Harmonisierung = Extrakt #9 / B4-checkpoint.
- 06 Limitierungen: Session präzisierte das Item "Hardware-Zähler" (L1D/LL/dTLB + Branch-Misses M-3a);
  Owner 5aab516 will alle unbelegten Limitierungen entfernen. Auto-Merge behält beides; N-34 entscheidet.
- diplomarbeit.tex: Session-Lizenzblock (207-260, Comdare Research License 1.0, Change Date 2031-08-10,
  "% NACHZUG 14.08.2026"-Kommentarblock) vs. Owner 9b3c202 (in 06:226): kein Widerspruch in der Sache
  (Code gesperrt, Forschung frei); offen bleiben XML-Konfigurationen und Thesis-Lizenz (N-57/N-58, #143).
  Die Owner-Danksagungs-Edits (176-182) und der Session-Lizenzblock überlappen nicht.
- 03 Lizenz-Tabelle (Session: michael_lockfree LGPL-2.1-or-later, tcmalloc Apache-2.0, lrmalloc MIT) ohne
  Owner-Kommentar — Session-Stand übernehmen (Vorlage lizenzwahl V3, Task #42).

9.4 MERGE-HYGIENE: Kommentare des Owners NIE in den EN-Zweig spiegeln (EN folgt zum Schluss, N-56/N-59);
keine %-Zeile "aufräumen", auch nicht die Lob-Zeile L35 oder die c2d21fa-Kommentare; chktex-Reinheit
(26f88a0) bezieht sich auf Text, nicht auf Owner-Kommentare.

9.5 NACH-MERGE-VERIFIKATION (Nachsatz 27.08. ~18:15Z; der Merge landete WÄHREND dieser Analyse):
- Merge-Commit **17165aa2** (27.08. 17:59, "Merge github/main (Owner-Overleaf 19.-23.08.): 34 Commits Kapitel
  03/04/05/06 + diplomarbeit.tex in development"; Eltern c169fd2 + dad2d52); development lokal =
  origin/development = github/development = 17165aa2 (gepusht). Konfliktmarker in 05: 0.
- Alle **52 Owner-%-Zeilen** (TEIL 8) sind in 17165aa2 wortgleich enthalten (Zeile-für-Zeile-Probe:
  1 + 12 + 19 + 12 + 8 Treffer, 0 Fehlstellen).
- Hunk 1 aufgelöst wie in 9.2 empfohlen: 05:91-93 Session-Absatz (Talos) -> 05:95 Owner-Kommentar ->
  05:96 "Davon zu trennen ist". Hunk 2: 05:131 Session-Satz (nearest-rank) -> 05:134 CEB-Kommentar ->
  05:135 "Auch der Mess-Betrieb". Anker beider Kommentare erhalten.
- Erwartete Restspannung bestätigt: 03:1147 "% ... SHA256 wird jetzt verwendet" neben 03:1169 "einem
  SHA512, dessen Preimage ..." (Text) -> Eingang #121/#27, keine Merge-Sache.
- Damit sind die Warnungen 9.1-9.4 nachträglich als eingehalten belegt; 9.3 bleibt als #121-Eingang offen.
