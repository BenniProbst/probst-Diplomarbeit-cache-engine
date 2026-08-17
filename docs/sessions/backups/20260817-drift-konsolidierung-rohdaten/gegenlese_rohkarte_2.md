# LEDGER-GEGENLESE — SEGMENT Z. 5259–7900
**Gegenstand:** KONSOLIDIERUNG IV, Kapitel A–M (der „geltende Stand je Thema" aus KON1…KON49) + die Voll-Nachträge **KON34 → KON16-01** (rückwärts). Gelesen: 5259–8618 (Segment vollständig + Überlappungspuffer). Abgeglichen gegen `kopf_referenz_kon60_93.md`.

**Vorbemerkung zur Gewichtung:** Kapitel A–M ist *die Nachschlage-Fläche* („Wer heute etwas nachschlägt, liest **hier**", Z. 5263-65). Alles, was dort steht und im Kopf KON60-93 fehlt, ist damit nicht nur „vergessen" — es ist **aktiv als geltend markiert** und wird von niemandem mehr gelesen.

---

## A. LEBEND, ABER IM KOPF (KON60-93) UNSICHTBAR

### A-I · Kette, Emission, Bauform (Kapitel B/I)

| # | Anker | Substanz |
|---|---|---|
| A1 | **KON16-03 / KON18-01 / KON17-01** | 🔴 **KEINE YAML in der Trägerkette.** *„der Planer emittiert direkt eine pipe oder Prozess […] Jede Träger Stufe emittiert die nächste direkt und unter Verwendung eines zentralen Bau-Modules, welches wiederverwendbar im Builder Pattern den nächsten Träger aufbaut."* Bauform: *„das Baumodul [ist] eine Planer Bibliothek in C++23"*, erlaubte Nicht-C++-Träger **nur CMake**. **NUR der Planer wird direkt kompiliert.** Im Kopf KON60-93 taucht diese Doktrin **nirgends** auf — dort läuft nur GitLab-CI-Arbeit (CI-DUAL, Workflow-Templates). |
| A2 | **KON25-08** | 🔴 **DIE TRÄGER-RAKETE.** *„wir brennen die Rakete nicht stufenweise ab, sondern bauen sie stufen weise rückwärts auf"* — Stufe N zündet bei Erfolg N+1, das fertige Modul N+1 wird **ABI-stabil in die vorhergehende Stufe gesteckt**. Emissionsliste je Stufe = **volle Pipeline**: Bau + Test + **LINT + RELEASE** + Lager + J-1…J-4. |
| A3 | **KON17-02** | 🔴 **Emissions-Abschluss ist ein LAGER-Kriterium:** *„Die Emission ist abgeschlossen, wenn die angeforderten CEBs und Tier-Binaries und Hybrid im Lager zu finden sind."* Nicht fertig bei „kompiliert/gelinkt/Tests grün". ⇒ die zwei **undurchgesetzten Stempel-Rollen liegen auf dem kritischen Pfad**. |
| A4 | **KON17-01** | **Jeder CEB-Bau läuft wegen RAM SEQUENTIELL**, ebenso die von der CEB verlangten *und registrierten* Folge-Builds. Steht neben KON73-F7 (Drei-Bereiche-Concurrency) ohne dass irgendwo aufgelöst ist, welche Regel beim CEB-Bau gewinnt. |
| A5 | **KON43** | **VIER Träger-Unterprojekte im ce**, in Trägerstufen-Form aufeinander aufbauend, **N+1 hängt nur von N**. Neue Bauten (S-8/S-9) entstehen **ab sofort** in der Zielform. (Kopf hat nur #29 „Zielstruktur publiziert"; das Abhängigkeits-Gesetz N+1←N fehlt.) |
| A6 | **KON47** | **Der Planer ist eine EIGENE Binary und steht NICHT in der KON43-Zielform.** Ausnahme zur Vier-Unterprojekte-Regel — im Kopf nirgends. |
| A7 | **KON25-04** | **`CiYamlBuilder` BLEIBT** — ausdrücklich *„für den lokalen build außerhalb der CI"*. Kein Rückbau, aber **nicht** der CI-Träger. |
| A8 | **KON9-06 / KON10-05** | Die Selbstkompilation hat eine **gebaute Blaupause**: `catalog_codegen.cmake` (add_custom_command + TARGET_FILE + DEPENDS xml), Director = `ExperimentPlanDirector`, **die Filterkette (C++23-concept + mp11) IST der Mechanismus** — *„nur bestimmte concept-builds zur Laufzeit eines niederen Trägers dürfen den compile eines höheren Trägers bilden"*. |
| A9 | **KON19-02 / KON13-01** | **Der Hybrid ist Transmitter/Multiplexer, KEIN Aggregator** (je Thread genau eine Tier-Binary; Werte gehen über Fläche 3 *durch* ihn). Und: *„das Hybrid kann nicht bauen, sondern nur Tier-Binaries messen, die schon gebaut sind"* ⇒ er ist Glied der **MESS**-Kette. |
| A10 | **KON36 (Korrektur) / KON21-01** | Hybrid-Autonomie ist **zweistufig**: **jetzt** orchestriert die CEB alle Prüfdocks direkt **oder delegiert** über *wiederverwendete CEB-Module* (Bestand: `AnatomyModuleLoader`); **später** eigenständige Lade-Entscheidungen über den **Sync-Kanal S-20 (Neubau)**. S-20 kommt im Kopf nicht vor. |
| A11 | **KON8-04** | Die **System-Achse sitzt IN der CEB** und gibt von dort Organ frei — **keine Querkante System→Organ** neben der Trägerkette; der Freigeber ist eine **Achse**, kein Träger. |
| A12 | **KON26-03 / KON27-05** | `PlanTextBuilder` + `plan dump` + der **hart gegatete** CI-Job `visibility:tier-binaries` + `parse_plan_dump()` sind owner-bestätigt **produktionskritisch und bleiben**; nur das Flag-Wort `--dump-plan` ist überholt. Eine Streichung wäre *„Abriss aktiver, hart gegateter Funktionalität"*. |
| A13 | **KON23-05/E** | **0 von 4 Trägern haben einen eigenen Bau-/Test-Job** (super 45 Jobs · ce 25 · „hybrid" 0 Treffer beidseitig). |

### A-II · Stempel (Kapitel C)

| # | Anker | Substanz |
|---|---|---|
| A14 | **KON9-11 / KON13-06-C3** | 🔴 **Fünf Rollen, nur ZWEI durchgesetzt.** Identität + Einordnung laufen produktiv; **Lager-Schlüssel** und **Skip-Marke** haben *nur Test-Aufrufer*; **Cache-Schlüssel** offen. Zusammen mit A3 heißt das: der Emissions-Abschluss ist heute **nicht prüfbar**. |
| A15 | **Kapitel C, Fehlerklasse** | 🔴 Änderung ohne `X.Y.Z`-Bump ⇒ kein Neubau ⇒ **schneller UND falsch**, sieht aus wie ein Cache-Treffer. *„Braucht ein **Werkzeug**, nicht Disziplin."* |
| A16 | **KON16-06 / KON25-02** | **DREI Flächen** (nicht zwei): 1 Genus-Interface · 2 Stempel (trägt Tools/Compiler als Teil der **Systemachse**) · 3 measurement-Durchstich = die **NAHT-1 vom 09.08.** (`IMessVisitor`). Owner: *„beide Konzepte müssen vereint werden"* — Bau-Posten. Der Compiler **wandert über die Compile-Grenze**: davor im CEB-Genus-Wert, danach trägt das Genus-Interface **nur noch** den Durchstich. |
| A17 | **KON7-07/08** | Die Muster: **COMPOSITE** = *wo/was* (inkl. der **Verbote**) · **STRATEGY** = *was in die Klammer* · **BUILDER** = *wie zusammensetzen* · **compile time factory** erzeugt Fläche 2. Alles **CRTP statt `virtual`** — *„wer im Review nach `virtual` sucht, findet keine Factory und hält sie fälschlich für nicht gebaut."* |
| A18 | **KON7-03** | **Zeilenzahl folgt der Stufigkeit: Planer 2 · CEB 3 · Tier 4 · Hybrid 4 + Karte.** Die CEB hat **keine Organ-Zeile**, weil Organ bei ihr *freigegeben, nicht eingebaut* ist. (Der Kopf kennt via KON60-B1 nur die Tier-4.) |
| A19 | **KON7-01** | 🔴 **Die Identitäts-Fläche ist am ABI heute OPTIONAL** — der Loader verlangt nur 4 Pflicht-Symbole, das **5. (Stempel) darf `nullptr` sein**. **SOLL: Pflicht.** Konkreter, unerledigter Bauauftrag. |
| A20 | **KON7-04** | **Fläche 2 hat sieben Interfaces**; `angeschlossene()` existiert **NUR beim Hybrid** und braucht einen **Laufzeit-Sammler** über die Dock-Registrierung ⇒ **zwei Mechanismen hinter EINER ABI-Fläche, beim Bau zu trennen**. |
| A21 | **KON41-04 / KON7-05 / KON8-10** | 🔴 **Der HYBRID-STEMPEL ist vollständig spezifiziert:** Tier-Verhalten **+ eine Zeile mehr** = serialisierte **compile-time-Map** {Synthese-Funktions-Key → Prüfdock-Tier-Stempel}, konkateniert über alle belegten Docks; letzte Zeile = SHA, **der die Map mit deckt** (andere Dock-Belegung ⇒ anderer Hybrid-SHA). Die „Bereichs-Karte" (Grenzen = **Break-Even**) IST diese Map; leer/einbereichig davor ist **Sollverhalten**. |
| A22 | **KON8-03** | Die CEB hat **ZWEI System-Anzeigen**: (1) compile-time → **in** den Stempel; (2) Laufzeit/RAM-Erkennung → **nicht** in den Stempel. Das erklärt „CEB-System leer" und ist ein zweiteiliger Bauauftrag. |
| A23 | **KON8-05/06** | **Der Stempel wird nicht geschrieben — er FÄLLT AN** als Resultat der B+-Baum-Materialisierung; Fläche 2 trägt **bewusst kein Freigabe-Feld** (Freigabe = Laufzeit-Abfrage am Baum). |
| A24 | **KON8-07** | Die **Composite-Zulassungsmatrix ist DREIWERTIG** (PFLICHT-in-MIN / ERLAUBT / VERBOTEN) — das ist die prüfbare Operationalisierung von `MIN ⊆ implementiert ⊆ freigegeben`. |
| A25 | **KON2-15** | Der Vertrag CEB↔Tier ist **produktiv verdrahtet**: `conformance_gate` · `mess_interface_testate` · `mess_konsistenz_gate` — letzteres fährt **vor jeder Messung, fail-closed**. |
| A26 | **KON2-09** | **W12-B nur halb erfüllt:** Organ-Änderung invalidiert chirurgisch, **System-Änderung löst weiterhin Vollbau aus.** |
| A27 | **KON21-03 / KON20-02 / KON5-04** | **Der S-6-Schnitt vollständig** (a Umstellung · b Transpositions-Sperre · c Kategorien-Ordnungs-Wache *„Ja bitte"* · d #67 behalten) **+ die VERBOTSZONEN** (Lager-Kaskaden, `kOrganGruppen*`, `kSystemAxisOrder`, `kCompositionAxisNames`, Hash-Mechanik, Messwert-2-Tupel). Der Kopf führt #15 als Bau-Platz, aber **ohne diesen Inhalt** — insbesondere ohne die Verbotszonen. |
| A28 | **KON2-06/17** | **SOLL-Versionierung je Stufe** + **drei IST-Lücken**: **Planer ohne SHA** · CEB-System-Anteil leer · **Genus handgeschrieben** (5 Literale, 1 Test-Aufrufer). Alle vier Binaries sollen einen Fingerprint-SHA tragen. |

### A-III · Achsen, Grammatik, Wachen (Kapitel D)

| # | Anker | Substanz |
|---|---|---|
| A29 | **KON27-01** | 🔴 **DAS HOME-PRINZIP, zweistufige Versionierung:** *„jede Achsen-Kategorie [braucht] ihr eigenes home, für das unter der Stempel-Mechanik **genau ein Wächter** greift"* — ORGAN=`axes/` (existiert), SYSTEM+MESS **fehlen**; Wächter prüft **ZWEIphasig** (System/Organ) bzw. **DREIphasig** (Mess). **Varianten unterscheiden sich ⇒ verschiedene ACHSEN-INTERFACE-Versionen; deren Algorithmen unterscheiden sich ⇒ verschiedene ALGORITHMUS-Versionen.** Reihenfolge: *„Wir beginnen aber zuerst mit einer gültigen golden Version."* Der Kopf kennt via KON73-F5 nur „DREI Homes" als Zahl — **die Zwei-Ebenen-Versionierung und die Ein-Wächter-Regel fehlen**. |
| A30 | **KON9-05 / KON25-01 / KON23-01** | **Die Flag-Grammatik v2 (gebaut 07.08.) ist die geltende volle Syntax:** `basis := c \| g \| f \| n \| x128 \| x256 \| x512`, `'c' = CPU`; `p`/`e` sind **Sub-Flags nur unter c**: `c{p}`, `c{e}`, `c{p.e}`. **Flache `cp`/`ce` existieren nicht und würden abgelehnt** (static_assert). O-1 ist GESCHLOSSEN. Der Kopf führt neue Tokens (`iw/ima/imi`, `p/b/h/t`, `i{pmc}`) **ohne die Basis-Grammatik zu wiederholen** — genau die Falle aus dem Memory-Eintrag „Kürzel immer zerlegen". |
| A31 | **KON13-03** | **ZWEI Grammatiken, nicht drei:** G-1 Mess (dreiphasig, von v2 gedeckt) · **G-2 System+Organ (zweiphasig) — Syntax existiert, die SEMANTIK ist nachzuholen *in Reihenfolge der Achsen-Nummerierung***. |
| A32 | **KON16-02 / KON23-02** | 🔴 **Die zwei Flag-Seiten:** *„Im Falle der **Freigabe impliziert** es das Vorhandensein und im Falle der **compile Seite Fordert** das Flag das Vorhandensein von Hardware ein."* Dreiphasig zusätzlich: die Mess-Achse der CEB fordert **den Vertrag mit den Messfühlern**. **Beide Seiten sind gebaut und heute leer/inert** ⇒ **S-3/S-7 sind Aktivierungs-, keine Neubau-Aufträge.** |
| A33 | **KON17-03 / KON2-19 / KON23-05-F** | 🔴 **Die C-4-Wache** (`contract:axis-version-lock`) sichert heute **6 Heuristik-Header**, Schnittmenge mit `axes/` = **0**, ≥152 ungedeckt; die hartkodierte Pfad-Liste war **Mitursache des Drei-Wochen-Ausfalls**. Owner: *„Wache **Modular erweitern** und in **Detail-Klassen splitten**"* — **eine Klasse je Kategorie-Home**; Autodiscovery über die Registry-Typlisten ist im Bestand vorgezeichnet. Im Kopf: **nichts**. |
| A34 | **KON9-09** | **Rang-1-Owner-Pflicht:** je Achsen-Kategorie die definiert freigegebene **Syntax UND Semantik** — *„Pflicht und Basis für die Abgabe"*. Und: **MIN ist ein Querschnittskonzept mit ZWEI Filtern** — System+Organ additiv monoton, **Mess zweischneidig** (mehr Messfühler = mehr Latenz). |
| A35 | **KON7-06 / KON8-09** | **Flag-Katalog-Lücke:** Vollausbau **59 Knoten, alle im c-Zweig**; g/f/n ohne Sub-Token. **Namenskollision `f`=FPGA (Tiefe 0) vs. AVX-512-Foundation (unter x512)** wird Risiko, sobald `f` einen Sub-Katalog bekommt. |
| A36 | **KON25-06** | **130/152 aufgeschlüsselt:** 130 = `axes/`-Organ-Header; 152 = +22 `topics/queuing/`-Träger, die `algo_version` tragen, aber **keine** Organ-Achsen sind (fehlplatziert). |
| A37 | **KON26-01** | **SIMD-Meta-Meta ist GEBAUT, aber inert:** `SimdExternalUtilsFamily : SystemMetaMetaAxis` mit 17 static_asserts — *aber* `axis_kind()` meldet noch `system_config` (hinter O-8 verschoben) und der `ExternalUtilsHub` hat **NULL Konsumenten**; die real wirkenden `-mavx`-Flags laufen über `profile_run_facade.cpp`. |

### A-IV · Messung, Betrieb der Kampagne (Kapitel E/J)

| # | Anker | Substanz |
|---|---|---|
| A38 | **KON28-02** | 🔴 **HART/SOFT — Owner verbatim:** *„Die **Einstellungen der Achsen failen immer hart**, bis auf **fehlende Messeinrichtungen auf der Mess-Achsen-Kategorie (wie ein fehlendes PMC soft fail)**."* Hart ⇒ Messung der Binary scheitert komplett ⇒ T-15b-Retry-Klammer ⇒ danach `failed` in die Zelle. Soft ⇒ **Warnung in die xlsx, Binary WIRD gebaut**, Messung so weit es geht. **Im Kopf: nichts** — obwohl KON64/65 die PMC-Sondergrammatik ausbauen. |
| A39 | **KON26-04 / KON28-02** | 🔴 **Die 5 liegt FALSCH auf der Drift-Achse** (ce `4cd1ab91`) — Umzug + **8-Punkte-Ripple**; *„kritischste Stelle: die **Arena-Formel** muss den binaryweiten ×5 **zusätzlich** decken."* Nicht verwechseln: KF-10 `n_repeats=3` · Drift-`max_reruns` · T-15a. |
| A40 | **KON34-01/04** | 🔴 **ZWEI EINANDER UNBEKANNTE MESS-ARCHITEKTUREN.** System A (live, `#ifdef`-Gates in `abi_adapter.hpp`) vs. **System B (dormant, 17 Dateien, 0 Produktions-Aufrufer)** — und genau **dort** lebt die 6er-Maschinerie. **B4 = System B umstellen + über den Builder instanziieren = „der fehlende Baustein *Steuerung → Compile*" aus KON10.** Der Kopf verbucht nur B2 als gebaut; **B1/B3/B4/B5 sind unsichtbar**. |
| A41 | **KON34-05** | **`--debug` und die Mess-Schalter sind STRENG DISJUNKT.** Das Flag *„darf alles beschleunigen und nichts umleiten"*; die Schalter **ändern Kompilat und Stempel**. Solange die Kette `--debug` fährt, **muss** die Mess-Schaltung davon unabhängig bleiben — sonst ist jedes Ketten-Kompilat anders bestückt als das Release-Kompilat. |
| A42 | **KON29-01/03** | 🔴 **Die Kampagne fährt das State-Pattern:** die **vier CacheEngine-Modi als PHASEN** über die Trägerstufen (Dossier 19 TEIL G: Mess- → Auswertungs- → Arbeits- → Hybrid-Modus). **Am Objekt: 0 Code-Treffer — das State-Pattern ist zu BAUEN**, nicht umzubenennen. Im Kopf steht davon nichts. |
| A43 | **KON29-01** | Die Debug-Doktrin ist die **einzige benannte Ausnahme** der Doktrin *„Messdaten werden NIE gelöscht"*: die ungenauen Debug-Messergebnisse werden beim Umschalten **gelöscht**. |
| A44 | **KON41-01** | 🔴 **Der OV-4-Deckel wird vom T−3-Fenster her kalibriert** (Bau + Messung ≤ ~2,5 Maschinentage zweilanig; finale Rechnung mit S-19-Zahlen). Der Kopf nennt T-3, **nicht** die daraus folgende Kapazitäts-Auflage. |
| A45 | **KON29-04** | 🔴 **DIE MESSUNG IST NICHT ZWEILANIG.** `measure:golden-320` ist global-exklusiv (`resource_group ceb-measurement-exclusive`, hart amd/prod1); die §61-Revision (`ceb-measure-<host>`, 21.07.) ist **bis heute nicht umgesetzt**, das Intel-Gegenstück fehlt. Zweite Lücke: `window_belongs_to` gebaut+getestet, **nicht verdrahtet**. Kapazität 4-Perm: prod1 20,7 h / **prod2 34,4 h (Engpass)**; **12-Perm nie durchgerechnet**. |
| A46 | **KON3-03** | 🔴 **XML-Wache: zwei Zweighälften nachweislich unbeobachtbar** (grep-Zweig braucht root; der Nenner-Mismatch-Mutant überlebt). **Owner-Frage „zulässig?" ist unbeantwortet** — eine offene Owner-Frage, die im Kopf nirgends geführt wird. |
| A47 | **KON4-03** | **Stage-Topologie-Lücke:** `test:unit` publiziert `ctest_unit_inventar.txt` **ohne Verbraucher**; `test:coverage-guard` liegt in **früherer** Stage als `test:unit` (`needs` darf nicht vorwärts zeigen). |
| A48 | **KON5-06** | 🔴 **Zwei divergente Fassungen der Diff-Hygiene-Wache** (ce 779 Z. `--bereich` · super 558 Z. `--seit-basis`/`--bestand`), gemeinsamer `--stdin`-Pfad **ohne Abbruch** — **vor dem main-FF misst die schwächere super-Fassung.** Direkt relevant für den offenen Posten #19. |
| A49 | **KON6-05 / S-16** | **Stehende Regression gegen C++/CMake-only:** 13–14 Shell-Testdateien (7.967→8.528 Z.) in `ci/tests` gegen 517 Google Tests; **ein `tr`-Shim (exit 127) ließ 5/5 Mutanten fälschlich als „gefangen" durchgehen.** |
| A50 | **KON22-01/7** | **D-1: `test:secrets` verlässt den prod2-CI-Job-Pool — Umsetzung UNGEPRÜFT** (Befund: 16 s grün auf prod1, 102 min Hänger auf prod2). |
| A51 | **KON44** | 🔴 **Die stille `n/a`-Falle:** nur **1 von 3 Gates** fängt provisionierte Zeilen ⇒ **eigener Wachen-Posten**. Dazu: **289-Writeback-Variablen FEHLEN** (Scrub-Klasse). |

### A-V · XML, Lager, Prüfling (Kapitel F/G/H)

| # | Anker | Substanz |
|---|---|---|
| A52 | **KON19-03** | 🔴 **EINE Einstiegs-XML (`main.xml`), REKURSIV** — referenziert andere XMLs als Teil-Experimente **oder volle Rezepte**; **jedes Paper = ein Experiment**; sequentiell, wenn in der main.xml gewünscht. *„Die XML Syntax bildet eine Programmiersprache."* |
| A53 | **KON21-02** | 🔴 **DIE WAHRHEITS-SCHICHTUNG:** *„der **Code** die Wahrheit für die **Freigabe** und die **XML** die Wahrheit für die **Realisierung** […] Es wird nur das eingebaut, was in der XML steht (**std::variant verboten**), daher entspricht jede Binary der XML Wahrheit und damit **nur einer Teilmenge des Codes**."* Registry wird **aus dem Code generiert** + Contract-Test. Im Kopf: **nichts**. |
| A54 | **KON30-02 / KON31** | 🔴 **DAS PRÜFLINGS-KONZEPT — das dritte Konzept neben Stufe und Phase.** Technisch eine **Mess-UNTER-Achse des Planers zur Laufzeit**, die *„in der CEB auch zu deren Laufzeit den Tier-Binary compiles freizugeben"* kommuniziert. Der Prüfling (PRT-ART) bietet **je Organ-Achse zusätzliche Algorithmen** an, *„im Prüfling verbucht und versioniert - **mit eigenem Stempel und allem**"*, XML-beschränkbar auf **1..3 Varianten**, **erweitert den Permutations-Satz**. Der Kopf führt prt-art nur als Repo-/Lizenz-/Waisen-Thema. |
| A55 | **KON30-02 / KON29-03** | Die drei `MergeStrategy`-Werte (`CeOnly` / `PrueflingReplace` / `FullJoin`) **SIND** die Prüflings-Verbund-Varianten; der künftige Bezeichner gehört zur Prüflings-Familie und wird **beim S-6-Fenster-Bau vorgeschlagen** (Golden-Byte-wirksam). |
| A56 | **KON32-01** | 🔴 **IST-VERSTOSS am measure-drop-Kanal, Owner verbatim:** *„Ich **genehmige hiermit ausdrücklich übergangsweise (a) bis wir (c) realisiert haben**, der **Kanal bleibt falsch und muss behoben werden wie definiert**."* **Zweifach** zu heilen: Ziel-Filter **UND** per-Binary-Format **xlsx** (der Code sendet `result.csv`, `iterator:3089-3093`). |
| A57 | **KON13-04 / KON15-05** | **Die Drei-Ziele-Struktur**, je per XML **separat** konfigurierbar; beide Caches müssen **S3 UND Filesystem** können. **Runner dürfen LESEN: NUR ccache auf `minio.comdare.de` + das neue Buildsystem-NAS** — *„Das ist mein letztes Wort dazu."* Ziel 3 = **NUR finale Zusammenfassung, LaTeX, PDF + explizit in der XML angeforderte Einzelnachweise**. |
| A58 | **KON12-03** | **S-17:** `LagerBaumWriter` hat **0 Produktionsaufrufer** (Gegenprobe `BuildOrchestrator` = 11) ⇒ **die Messdaten-Kaskade hat heute keinen Einsortier-Pfad**; setzt **O-9** voraus. |
| A59 | **KON3-06** | **Bestandslog-SKIP-Risiko:** je `binary_id` wird **ein** Eintrag mit leerer Zelle geschrieben, obwohl die ID über die ganze opt×simd-Matrix gebaut wird (**320 IDs bit-identisch**) — **ein SKIP kann falsch begründet sein.** |
| A60 | **KON27-02** | **Das Export-Element (Option b):** je FORMAT ein Eintrag FORMAT→ZIEL; bei LATEX zusätzlich **WAS**; der **PDF-Block referenziert LAZY die LaTeX-Konstruktion** und exportiert **mit den übrigen Kapiteln neben dem generierten Anhang**. |
| A61 | **KON23-03** | **VIER compile-time-gesicherte Rückschrieb-Methoden:** `Csv` · `LatexTable` · **`ComparisonMetrics`** · `Xlsx` (`kWritebackMethodCount=4`). **PDF liegt ausdrücklich außerhalb** der Rückschrieb-Achse. json/html/svg/png = **belegte Nullen**. |

### A-VI · Bau-Ordnung, Fristen, Owner-Regeln (Kapitel I/K/M + KON37–49)

| # | Anker | Substanz |
|---|---|---|
| A62 | **KON22 (Vollbau-Gate)** | 🔴 **VIER Bedingungen, wörtlich:** *„Wir bauen, wenn **Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND Messung einbaubar**."* Das ist das **Gate vor dem Bau-Trigger Mi 26.08.** — im Kopf steht der Trigger, **nicht das Gate**. |
| A63 | **KON17-04 (die Rüge)** | 🔴 **Bau-Reihenfolge nach dem Stempel:** 1 Stempel · 2 **Planungs-Simulation** · 3 **von der XML die gesamte Kette bis zur PDF, von vorn nach hinten, mit allen Abzweigungen.** *„Nein das ist der Kern der Ablage, Opus 5 hat wieder still und heimlich alles ausgeklammert."* — S-13 ist **KERN**, ausdrücklich **nicht** post-Abgabe. |
| A64 | **KON30-03** | **S-19-Weg:** (1) Achsen **im Planer** zur Simulation **gruppieren und kategorisieren**, (2) über den **gesamten Experiment-B+-Baum** die tatsächliche Permutation **rechnen** — *„Abstufungen, die wir ohne Programm nicht abschätzen KÖNNEN."* B-4 bleibt Kandidaten-Liste, bis das Programm rechnet. |
| A65 | **KON11-01** | **ARBEITSPRINZIP:** konsolidieren → archivieren → **in der ZIELFORM aktivieren** — *nie eine vierte Fassung neben drei bestehende*. |
| A66 | **KON24-01/Q-f** | **S-14/S-18 sind BUILD-BLOCKER** (*„sonst ist der Build … unmöglich"*), **keine CI-Kosmetik**. |
| A67 | **KON42** | 🔴 **DIE DEFAULT-DOKTRIN:** Variablen werden **hart als Planer-Defaults einkompiliert**, die XML überschreibt. Dazu: **Hybrid zweiwegig XML-steuerbar** (statische Dock-Belegung **ODER** Synthese-Funktionen + Wirkbereiche). Der Kopf kennt nur den Dock-Deckel als „willkürlich". |
| A68 | **KON37-01** | **Die VERERBUNGSREGEL:** *die CEB baut höhere Stufen nur nach **eigenen** Messeigenschaften.* Wallclock-Merge: Freigabe **Planer** · Schalter-Hoheit **CEB** · Durchführung **im Vertrag**. |
| A69 | **KON37-03** | **Anordnungs-Freigabe** (F-C gedreht) — Gegenstand des Anordnungs-/Ordnungs-Freiheitsgrads je Stufe; im Kopf nicht auffindbar. |
| A70 | **KON39** | 🔴 **Die VIER `/goal`-Dokumente sind Haupt-Referenz:** GOAL-V8-Dossier · **Wellenplan §17** · **Designplan §10** · **ARBEITSWEISE v3.5-Vorlage**. Alle späteren Planungsdokumente werden **gegen sie** konsolidiert. Der Kopf zitiert nur den **Wellenplan §18** — die Referenz-Hierarchie selbst fehlt. |
| A71 | **KON38** | **Geltungsliste der Fable-5-max-Auflage:** S-1…S-7, S-14, S-18, B5, Flächen, Preimage, Versionierung — *„weil die Komplexität so hoch ist"*. (Beim Widerruf der Memory-Blanko-Regel ist **diese** Liste die Rückfallebene.) |
| A72 | **KON45 / KON47** | **Preimage-Budget-Bruch:** Preimage-Max **4096 zu heben**; Map-VALUE = **Tier-SHA statt Voll-Stempel**. **Comp-Gate-Schicht fehlt in ALLEN DREI Realms** (eigener Posten). **Warmup-PAAR** (verwerfen + speichern) ×3 = **6 Läufe / 3 Werte**, `--debug` 1× kalt, *„sonst IMMER zwei Mal"*, **Pflicht + testpflichtig**; Lücke = **prozess-kalter Erstlauf je Zelle (~2× teurer)**. |
| A73 | **KON22 / Kapitel K** | **Eigentum + Formales:** Thesis = **Benjamin-Elias Probst privat**, CacheEngine + PRT-ART = **BEP Venture UG / Marke Comdare**; 🔴 **die Abkürzung „BEP" für die PERSON ist VERBOTEN.** **Prüfungsunterlagen** (8 Exposés, 3 PDFs mit Betreuer-Mailverkehr, Anmeldeformular) werden **mitveröffentlicht** — die PDFs tragen **Betreuer-Namen/@tu-dresden-Adressen**, gehört **vor dem Public-Release in die Release-Checkliste**. **Research-and-Teaching-Klausel bleibt.** |
| A74 | **KON22-02** | 🔴 **Backup-Ref-Löschung gestuft und terminiert:** stehen lassen → **nach der Lieferphase** rechtebeschränktes Bundle → **erst dann** Remote-Löschung mit ausdrücklichem, gegenstands-genauem GO. **KEINE Löschung vor der Lieferphase.** |
| A75 | **KON2-24/25** | 🔴 **Lizenz-Widerspruch am Objekt, ungeheilt sichtbar:** `ce/NOTICE` sagt „Apache 2.0", `ce/LICENSE` trägt die Dual-Lizenz; und der **fünfte Schalter** `COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION=ON` **kopiert bei jedem Configure GPL-3-Code (`wh.c`)** — **das Vier-Schalter-Gate deckt ihn NICHT.** |
| A76 | **Kapitel M** | 🔴 **Der Stunden-/Tage-Aufwand von S-1…S-21 steht an KEINER Stelle** — *„Termine unverändert" ist eine **Owner-Setzung**, keine abgeleitete Aussage.* Das ist der einzige explizit ausgewiesene Zeitplan-Vorbehalt im ganzen Kapitel. |
| A77 | **KON29-06 / Kapitel M** | 🔴 **R-1-Rest offen:** zum **AUSWAHL-Subsystem** (`measurement_tooling_registry` / `canonical_combo` / XSD `<combo>`, **18 Dateien**) fehlt die **Fortführungs-Entscheidung** — KON34/B4 beantwortet nur die Ordnungs-Seite. |
| A78 | **KON20-04 / KON34-06(d)** | **Register-Lücken ohne Eigentümer:** K4 (`mess/`-Subsystem ohne S-Position) · **K5 drei Skelett-Testverzeichnisse seit 06.07. ohne Eigentümer** · die **17-vs-18-Dateizählung** des System-B-Doppelbaus unaufgeklärt. |
| A79 | **Kapitel L (12 Lehren)** | Methodik-Kern, im Kopf nicht wiederholt: **(1) nach dem GEGENSTAND suchen, nicht nach dem Konsumenten** · (3) *„Der Plan ist keine Quelle über den Code, sondern eine **Behauptung** über ihn"* (5 von 5 Bauaufträgen am Objekt falsch) · (4) jede „existiert nicht"-Aussage trägt ein **Verfallsdatum** · (5) ein binäres `widerlegt`-Flag trennt „falsch" nicht von „fast richtig" (**9 als widerlegt markierte Verifikationen bestätigten den Befund**) · (12) **die Synthese braucht eine Titel- und Längen-Auflage**, sonst geht der Kopf beim Return verloren (zweimal passiert). |

---

## B. WIDERSPRÜCHE OHNE TRAGENDEN MARKER

**B-1 · Der Mess-Nenner: feste 32 vs. dynamisch > 32**
- *Segment (KON25-03, Kapitel E, Z. 5578-82, unmarkiert):* „**DER MESS-NENNER = 32** … TIER 4 } HYBRID 4 } 16 × CEB Wall-Clock 2 = **32**" und (KON25-03 Schluss) „*Die Planungs-Simulation (S-19) bekommt damit ihren Mess-System-Faktor: **32 ist der Multiplikator der Mess-Dimension***."
- *Kopf (KON71):* „**DRITTE 32er-Rüge (Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet)**"; KON65: „32er-Falle: Belegungs-Welt (2^5) **entkoppelt** von Dock-Zahl".
- Kapitel E trägt für den **Nenner** keinen ÜBERHOLT-Vermerk (nur für die Dock-Klammer, KON41-03). Die zentrale Nachschlage-Fläche behauptet damit weiter eine statische 32 als S-19-Multiplikator — genau das, was der Owner dreimal gerügt hat.

**B-2 · Arena: „Formel muss ×5 zusätzlich decken" vs. „6 GB FEST, STATISCH"**
- *Segment (KON26-04, Z. 6721-22):* „🔴 `checkpoint_speicher.hpp:119-123`: **die Arena-Formel (18 Durchläufe je Zelle) muss den binary-weiten ×5 ZUSÄTZLICH decken — sonst UNTERDIMENSIONIERT**"; Kapitel E Z. 5603 wiederholt es als kritischste Ripple-Stelle.
- *Kopf (KON93):* „**C6 = ARENA 6GB FEST, STATISCH**, Planer-Reservierung zu Experiment-Beginn änderbar (10-Wochen-Explore läuft)."
- KON92 nennt zwar eine „Arena-Ketten-Karte (8 Deltas, 6 Überholt-Marker)", aber **kein Marker im Segment und keine Kopf-Zeile sagt, ob die ×5-Deckung durch die feste 6 GB erfüllt, ersetzt oder offen ist.** Bei T-15b-Umzug (#13) ist das entscheidungsrelevant.

**B-3 · Zweilanigkeit: Concurrency-Schema vs. „die Messung ist nicht zweilanig"**
- *Segment (KON29-04, Z. 6364-66):* „**DIE MESSUNG IST NICHT ZWEILANIG:** `measure:golden-320` ist global-exklusiv (`resource_group ceb-measurement-exclusive`, hart amd/prod1) — die **§61-Revision (`ceb-measure-<host>`, 21.07.) ist bis heute nicht umgesetzt. Intel-Gegenstück fehlt.**"
- *Kopf (KON73-F7):* „Drei-Bereiche-Concurrency (CI-normal 3/2 je 4 Kerne, **heavy 16**, ce floor((T-4)/4)×4, --debug T×1)" + „W3-Kampagne ab Sa 29.08."
- Das Concurrency-Schema setzt Mehrlanigkeit voraus; die Kapazitätsrechnung (prod1 20,7 h / prod2 34,4 h) setzt sie ebenfalls voraus. **Kein Marker sagt, ob §61 inzwischen umgesetzt ist.** Wenn nicht, fährt die W3-Kampagne einlanig auf prod1.

**B-4 · „KEINE YAML in der Kette" vs. die gesamte CI-DUAL-Strecke**
- *Segment (KON16-03/KON18-01):* „**Es gibt keine YAML** sondern der Planer emittiert direkt eine pipe oder Prozess … **Erlaubte Nicht-C++-Träger: NUR CMake**"; `CiYamlBuilder` bleibt **ausdrücklich nur „für den lokalen build außerhalb der CI"** (KON25-04).
- *Kopf (KON66/72/86 + Task #3):* „CI-DUAL alle Repos gebaut", „Workflow-Template-Fix (keine `${}`-Escapes)", S-12 = „je Trägerstufen-Mini-Pipeline gcc+clang × Release+Debug".
- Ungelöst: **emittieren die vier Trägerstufen-Mini-Pipelines GitLab-YAML (dann bricht KON16-03) oder Prozesse (dann fehlt der Bau-Posten)?** Kein Marker auf beiden Seiten.

**B-5 · `--debug`: „bis zur Abgabe" vs. „fällt bei T−3"**
- *Segment (KON28-01, Z. 6430/6433, unmarkiert):* Owner: *„**Das bleibt auch an bis zur Abgabe.**"* → „die Kette bis RELEASE fährt mit `--debug` — **BIS ZUR ABGABE (15.09.)**"; Kapitel E Z. 5632 wiederholt: *„da die Kette bis zur Abgabe --debug fährt"*.
- *Segment-Index KON37 (Z. 5316) + Kopf:* „**`--debug` fällt bei T−3**" / „T-3 ~Sa 12.09. = manueller Reset + ECHTE Messung".
- Die Auflösung existiert (KON37/KON41-01), **steht aber nur im Index und nicht am Ort** — KON28-01 und Kapitel E behaupten unverändert 15.09.

**B-6 · Change Date: 11.08.2031 vs. 10.08.2031**
- *Segment (KON22-01(2), Z. 7186-88):* „*C-2: Ja, cache engine nach 5 Jahren frei verfügbar ab heute*" → „**~11.08.2031**"; Kapitel K Z. 5837: „**FUENF JAHRE nach dem 11.08.2026** wird … frei (~2031)".
- *Kopf (KON60):* „**Change Date 10.08.2031**" (Task #56: „OF-1 FINAL **2031-08-10**").
- Ein Tag Differenz, in Lizenztexten wirksam; das Segment trägt keinen Marker.

**B-7 · Begriffskollision `FullJoin`**
- *Segment (KON30-02):* `FullJoin` ist eine der **drei Prüflings-Verbund-Varianten** (`CeOnly` / `PrueflingReplace` / `FullJoin`), XSD-`<phase merge=…>`, **golden-byte-wirksam**.
- *Kopf (KON91):* „ab ma-Ebene ALLE Parameter inkl. PMC = **FULL JOIN** der mi-Achsen-Erfolgs-Parameter".
- Zwei verschiedene Gegenstände unter demselben Wort, ohne dass ein Marker sie trennt — und die Prüflings-Variante soll laut KON30-02 **beim S-6-Fenster-Bau umbenannt** werden. Kollisionsgefahr genau im laufenden Bump-Bündel (#15).

**B-8 · Organ-Kanon: „T12/T17 bleiben unangetastet" vs. ORG-19 als required-Deklarant**
- *Segment (KON26-01):* „eine Festplatten-IO-Meta-Meta wäre ein **NEUER, ADDITIVER Typ** über der `OrganMetaMetaAxis`-Wurzel — **T12/T17 bleiben unangetastet**; ‚Umklassifizierung' wäre ein Neubau daneben."
- *Kopf (KON80-V10/KON91):* „ORG-19-IO = **erste Organ-Meta-Meta-Achse**, XML-opt-in, Genus-Interface **+store()/load()**"; „erste required-Deklaration = **Festplatten-IO/ORG-19**".
- Weich, aber offen: `persistence_target` (T17, heute **OFF** per Owner Q-1/Fall B) und ORG-19 überschneiden sich im Gegenstand; kein Marker sagt, ob T17 neben ORG-19 bestehen bleibt oder aufgeht.

---

## C. ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Vom Segment selbst als überholt/gestrichen/korrigiert markiert: ≈ 28**
KON4-10 (Stempel-Riss) → KON5-01 · KON14-02 (S-6 pauschal falsch) → KON15-02/KON20 · KON7-06 (Komplexitäts-Leiter) → KON8-08 · KON16-09 (Stufe=Phase Synonym) → KON25-07 · KON9-04 (Grammatik-Zuordnung) gestrichen → KON13-03 · KON7-03 „3 für System" fällt → KON13-01 · R-4 „gerade Anzahl Prüfdocks" **gestrichen** (Vollzug an 6 Stellen) · KON34-03-Dock-Klammer + KON28-03-„Beobachtung" **„VÖLLIG FALSCH"** → KON41-03 · Wallclock-SOLL-Konflikt → **KON37-01 Merge** · `--dump-plan`-Flagwort überholt (Substanz bleibt) · Zwei-Flächen-Fassung KON7-01 → drei Flächen KON16-06 · Gen-1-CI-Matrix (§35/§36) DEPRECATED → Gen 2 · Hybrid-Autonomie-Zeitbezug korrigiert (KON36) · ce-Sequenz-Auflage KON44 → KON46 (stale Worktree-Refs) · Owner-Vorlage mit ÜBERHOLT-Kopf (V-5) · „ES SIND ZWÖLF" / 4!=24 / 24-vs-48 → **32** · 06.08.-Klärungsdokument STUFE/PHASE überstimmt · WF4-24/48-Aussagen (Zeitstand-Vermerk KON26-Kopf) · §69.6 „24 Worker" · KON16-10-Fragen 6/7 neu gestellt, O-6/O-7/O-8 gegenstandslos · Schnitt-2-Deckungslücke geschlossen (KON36-01) · KON10-01 „wörtlich" → „inhaltlich" · B-3 anders aufgelöst (KON13-04) · O-2 entfällt an 6 Stellen · P-0 blockierend → begleitend · **drei eigene Messungen widerlegt** (LagerBaumWriter-„0 Aufrufer", `algo_version`-Pflicht „nie gebaut", „7 vs. 9 Marker") · KON3-02 prod2 (26 Tage blockierend) geschlossen · KON2-26 Prüfungsunterlagen-Frage geschlossen.

**Durch den Kopf KON60-93 / die Task-Karte erkennbar überholt: ≈ 14**
Nenner-32-Statik → KON71 dynamisch >32 · „8 von 9 thesis_profiles xlsx-blind" → 11 Profile / 0 xlsx-blind (#56) · ce rot `test:coverage-guard` → grün (#14) · MinIO-Keys → geheilt (#10) · Cache-Landschaft Drei-Orte → Ebenen A/B/C (KON66/67) · Meta-Meta-IO „additiver Typ" → ORG-19 (KON80-V10) · 6er-Maschinerie/Gate-Trennung → **B2 gebaut** (KON72/74) · F11-Prüfdockzählung → 32er-Falle (KON65/71) · Löschregel KON49 → Worktree-Remove-Wache (KON79/82) · OD-7 24→16 → heavy 16 (KON73-F7) · `--debug` bis Abgabe → T−3 · **V-1 `##25`-Durchstich ohne Besitzer → F1 GELIEFERT** (KON63) · KON19-00 Referenz-Konsolidierung → vollzogen (KON39/#9) · S-6-Sperre → **ENTSPERRT** (KON74, KON60-04 stale) · Kapitel-M-Eintrag „W-6 ungelöst" ist gegenüber KON37 („W-6 Zielzustand") **segment-intern stale**.

---

## D. TRAGENDE ARCHITEKTUR-KERNE DIESES SEGMENTS

1. **Vier Träger, und nur vier** (KON7-02): **Planer → CEB → Tier · Hybrid**; KON43: *„in der Reihenfolge und nicht anders"*, **vier Träger-Unterprojekte, N+1 hängt nur von N**.
2. **ORT ≠ ZEIT** (KON9-01/KON13): Ort = Planer→CEB→**Hybrid**→Tier, Zeit = Tier bauen → messen → Hybrid erzeugen → einschieben. **Aus dem ORT-Satz folgt KEINE Phasigkeit.** Tiefe 3; Tier und Hybrid **sequentiell auf derselben Stufe**, erst Tier.
3. **Phasigkeit** (KON13-01): MESS 3 (ohne) / **4** (mit Hybrid) · SYSTEM 2‖2 **parallel** · ORGAN 2. Der Hybrid ist Glied der **Mess**-Kette, *„weil das Hybrid nicht bauen kann, sondern nur Tier-Binaries messen, die schon gebaut sind"*.
4. **Vier-Parteien-Kette = zweimal dreistellig parallel** (KON13-02): *„Konzeptionell hat die CEB hier **2 dritte Phasen**, die sie als Kopf steuert, in der Anordnung des Ortes allerdings **4 Phasen**."* Vertrag entsteht **nur bei Dreiphasigkeit** (KON8-01); `MIN ⊆ implementiert ⊆ freigegeben` gilt **überall** (KON8-12).
5. **Die Emission** (KON16-03/KON18-01/KON17-01): **keine YAML** — *„der Planer emittiert direkt eine pipe oder Prozess"* über **ein zentrales Bau-Modul = eine C++23-Planer-Bibliothek** (Builder Pattern). **Anforderungsgetrieben:** Stufe N baut, was N−1 wünscht/anfordert/freigibt. **Nur der Planer wird direkt kompiliert.**
6. **Die Träger-Rakete** (KON25-08): *„wir brennen die Rakete nicht stufenweise ab, sondern bauen sie stufen weise **rückwärts** auf"* — jedes Modul ist nach dem Bau eigenständig und wird **ABI-stabil in die vorhergehende Stufe gesteckt**.
7. **Abschluss = Lager** (KON17-02): *„Die Emission ist abgeschlossen, wenn die angeforderten CEBs und Tier-Binaries und Hybrid **im Lager zu finden** sind."* ⇒ Stempel-Rollen 2+3 auf dem kritischen Pfad — und **beide sind heute nicht durchgesetzt** (KON13-06/C-3).
8. **Der Stempel, fünf Rollen** (KON9-11), **drei Flächen** (KON16-06): Genus-Interface · Stempel (Systemachse, Tools/Compiler) · measurement-Durchstich — Letzterer existiert *„damit wir die Gattung+Genus Funktionsinterfaces **nicht ändern** müssen"*. Er **fällt an** als Resultat der B+-Baum-Materialisierung (KON8-05).
9. **Wahrheits-Schichtung** (KON21-02): *„der **Code** die Wahrheit für die **Freigabe** und die **XML** die Wahrheit für die **Realisierung** […] **std::variant verboten** […] jede Binary [entspricht] nur einer **Teilmenge des Codes**."* Dazu KON19-03: **eine rekursive Einstiegs-XML**, *„die XML Syntax bildet eine Programmiersprache"*.
10. **Das Home-Prinzip** (KON27-01): *„jede Achsen-Kategorie [braucht] ihr eigenes home, für das unter der Stempel-Mechanik **genau ein Wächter** greift"* — Mess **dreiphasig**, System/Organ **zweiphasig** geprüft; **zweistufige Versionierung** (Achsen-Interface-Version **und** Algorithmus-Version); *„Wir beginnen aber zuerst mit einer **gültigen golden Version**."*
11. **Die zwei Flag-Seiten** (KON16-02): **Freigabe impliziert · Compile-Seite fordert**; dreiphasig zusätzlich der **Messfühler-Vertrag**. Beide Seiten **gebaut und inert** ⇒ S-3/S-7 sind **Aktivierungs**-Aufträge.
12. **Drei nie zu vermengende Konzepte** (KON25-07/KON29-03/KON30-02/KON31): **STUFE** = die Binary, physisch · **PHASE** = die vier CacheEngine-Modi (State-Pattern, **0 Code-Treffer — zu bauen**) · **PRÜFLING** = eigene Achse der Verbund-/Teststruktur, technisch **Mess-Unter-Achse des Planers zur Laufzeit**, die in der CEB die Tier-Compiles freigibt, *„mit eigenem Stempel und allem"*, XML-beschränkbar 1..3.
13. **Zwei Mess-Architekturen** (KON34-01): System A live (`#ifdef`-Gates), **System B dormant** (17 Dateien, 0 Produktions-Aufrufer) — dort lebt die 6er-Maschinerie. Deren Umstellung (**B4**) ist *der fehlende Baustein „Steuerung → Compile"*. Die 6 zählt **Ordnungen einer ortsfesten Vollmenge**, die 32 zählt **An/Aus verteilter Einrichtungen** — *„die CEB misst UM das Tier herum, das Tier misst IN sich."*
14. **Hart/Soft** (KON28-02): *„Die Einstellungen der Achsen **failen immer hart**, bis auf **fehlende Messeinrichtungen** auf der Mess-Achsen-Kategorie (wie ein fehlendes PMC **soft fail**)"* — soft ⇒ Warnung in die xlsx, Binary wird trotzdem gebaut.
15. **Zwei Betriebsstufen** (KON29-01): `--debug` jetzt (ungenau, schnell) → Umschaltpunkt *„sobald das System planmäßig steht und arbeitet"* → **ungenaue Ergebnisse löschen**, echt mit **1 Thread**. Die **einzige Ausnahme** der Doktrin „Messdaten werden nie gelöscht". `--debug` ist *„das Flag **quer** zum State Pattern"* und **streng disjunkt** von den Mess-Schaltern (KON34-05).
16. **Das Vollbau-Gate** (KON22): *„Wir bauen, wenn **Lagerhaltung fertig UND Stempel fertig UND Algorithmen versioniert UND Messung einbaubar**."*
17. **Die Bau-Reihenfolge nach dem Stempel** (KON17-04, die Rüge): 1 Stempel · 2 **Planungs-Simulation** · 3 **von der XML die gesamte Kette bis zur PDF, von vorn nach hinten, mit allen Abzweigungen** — S-13/Ablage ist **KERN, nicht Anhang**.
18. **S-19 gibt es noch nicht** (KON30-03): Achsen im Planer **gruppieren + kategorisieren**, dann über den **gesamten Experiment-B+-Baum** rechnen — *„Abstufungen, die wir ohne Programm nicht abschätzen KÖNNEN."* Bis dahin ist **B-4 eine Kandidatenliste**, keine Zahl.
19. **Lager und Cache** (KON13-04/KON15-05): drei Orte, **je per XML separat konfigurierbar**, beide Caches **S3 und Filesystem**; Runner lesen **nur** ccache auf minio.comdare.de + Buildsystem-NAS — *„Das ist mein letztes Wort dazu."* Im Lager gelten **zwei eigene Kaskaden** (D-12), außerhalb folgt die Ordnung **der Trägerkette**: *„Immer der vorangegangene Träger definiert die nächste Träger-Stufe, das ist dynamisch."*
20. **Das Arbeitsprinzip** (KON11-01): **konsolidieren → archivieren → in der ZIELFORM aktivieren** — nie eine vierte Fassung neben drei bestehende. Und die Konfliktregel (KON11-02): bei Widerspruch ohne Owner-Wort auf beiden Seiten **zuerst Explore auf Fehlinterpretation** — sie hat in KON13 **11 von 20** Widerrufen abgefangen.

**Segment-Datei:** `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Z. 5259–7900 (gelesen bis 8618).