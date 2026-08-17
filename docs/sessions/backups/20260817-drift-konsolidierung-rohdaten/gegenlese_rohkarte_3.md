# GEGENLESE-KARTE — Segment Z13601–16626 (LEDGER-KONSOLIDIERUNG II, Teil 2)

**Anker-Hinweis:** Mein Segment trägt **keine KONxx-yy-Nummern** — es ist der Rohbestand der **Nachträge vom 09.08.2026 (spät/abends)**, den die 10.08.-Konsolidierungen (KON1/KON2-Block ab Z11101/Z11899) oberhalb verdichten. Ich ankere deshalb mit **Datum + Nachtrags-Überschrift + Zeilennummer (Z…)** des Stands 29858. Alle Zeilen 13601–16626 gelesen.

---

## (A) LEBEND-ABER-IM-KOPF-UNSICHTBAR

### A-I — Achsen / Stempel / Identität (F2-relevant, Freeze Fr 21.08.)

**A1 · `work_mode` = Unter-Achse unter `measurement_category`, VIER States + EIN Flag — mit einem stempel-/ABI-relevanten Enum-Umbau** *(Z13694–13914, geltende Fassung; Herleitung Z13915–14094)*
Owner: *„die 5 Begriffe gehören zusammen, aber **Debug ist für normale Benutzer gesperrt**"* und *„Damit ist Debug **als Flag entkoppelt** … es beeinflusst zwar die **Ausprägung** der States, aber **nicht ihr Verhalten der Reihenfolge oder Abhängigkeiten**. Es ist also ein **CLI-Flag auf der Planer-Shell**."* Kette `build → measure → compare → release`, kumulativ, **Besitzer = PLANER (Director)**. Bau-Auftrag: **`Debug` VERLÄSST das Enum (heute Ordinal 0), `Build` tritt ein, `kWorkModeCount = 4`** — ein **lauter Ordinal-/Stempel-Bruch**, Registry-Zeile `{Build, "build", "Build", "Release", false, false}`, `kOffizielleWorkModeCount` entfällt ersatzlos.
→ Der Kopf kennt `--debug` nur als **Betriebsschalter** (KON71 zwei Mess-Klassen, W3-Generalprobe, #22 OD-7). **Der Enum-Umbau, die Registry-Zeile und die Achsen-Einordnung tauchen nirgends auf** — obwohl sie Ordinale verschieben und damit **vor** den F2-Identitäts-Freeze gehören.

**A2 · Die Debug-Sperre ist eine INTEGRITÄTS-Regel mit fertiger Sperrform im Haus** *(Z13762–13853, Z13884–13898)*
`debug` ist das einzige `work_mode`, das **misst und dabei parallel läuft**; Owner: *„Parallelisierung des Messens mit **MAXIMALER Thread-Zahl** … **egal wie genau die Messwerte sind** (Prüfer der Abweichungen der Messwerte-Jitter **schaltet Debug daher ab**)"*. Drei bindende Merkmale: **„in JEDER Factory"** (global, nicht je Station) · **maximal**, nicht bloß „nicht 1-Thread" · **Debug-Zahlen sind Ausschuss und dürfen NIE ins Messwertlager**. Sperrform existiert: `AdmissionStatus {Zugelassen, Gesperrt}` (`axis_error.hpp:169-178`, fail-closed), Prüfort `validate_profile.hpp` gegen die constexpr-Registry.
**Gemessene Lücke:** `grep -c 'RunMethodology' drift_detector.hpp` = **0** ⇒ die Debug-Ausnahme im Drift-Gate **existiert nicht** und gehört ins **selbe Paket wie T-15 + D4**. Im Kopf: kein Wort — bei einer `--debug`-Generalprobe ab 29.08. würde **jede** Debug-Zelle rot.

**A3 · Hybrid-Meta-Meta ist eine FAMILIE, nicht eine Achse — plus `<hybrid>`-XML-Schalter** *(Z13999–14015, Z14082–14083, Z14162–14167)*
Owner: *„weil es **multiple Reroute-Systeme** geben kann, müssen diese als **separate Meta-Meta-Mess-Achsen erweiterbar** sein"* ⇒ **je Reroute-Genus EINE `MeasurementMetaMetaAxis`**, alle in **derselben Mess-Zeile** (E2 vom 02.08.: *„dynamisch ans Ende der Kette in den bestehenden Zeilen angehängt"*; RF-7: je Achsen-Typ EINE Array-Zeile). Dazu ein `<hybrid>`-XML-Schalter **zu Experiment-Beginn, gleichrangig zu `<measurement_tooling>`**. Der Kopf führt PMC (KON64/65) und ORG-19-IO (KON80-V10) als Meta-Metas — **die Hybrid-Familie und der `<hybrid>`-Schalter fehlen**.

**A4 · Der IST-Stand der Mess-Achsen-Registry und die aufgelöste `binary_id="never"`-Spannung** *(Z14105–14116, Z14176–14196)*
`measurement_axis_registry.xml` (generiert) führt **drei** Achsen, **alle `binary_id="never"`, `stage="ct"`**: `measurement_category` (16 Bausteine) · `collector` (3: WallClock, ObserverSnapshot, Pmc) · `load_framework` (`measurement_meta_meta`, `sub_axis_label="workload"`). Die Datei benennt ihre Lücke selbst (`:59-60`): *„die 3 Mess-Modi Debug/Mess/Release existieren NICHT als Typen → nicht emittiert; erst nach ihrer **Typisierung als Mess-Unter-Achse** reflektierbar."*
**Tragende Auflösung:** *„`binary_id` identifiziert das **TIER-BINARY**. Mess-Achsen stehen dort NIE drin. Die 6 (bzw. 24) Varianten sind **CEB**-Binaries — ein anderer Gegenstand."* Wer beides gleichsetzt, *„käme auf einen Bump, der nicht anfällt"*. Im Kopf nirgends.

**A5 · E-1-Rekursions-Mechanik: Tiefe und Stufen-IDs stehen IM STEMPEL** *(Z15504–15513)*
Owner-Bauart des HEURISTIK-ADAPTER / Function-Interface-Reroute: *„compile-time transparenter Pass-through"* · *„für JEDE Gattung+Genus per google test bewiesen durchlässig"* · *„allein NICHT ansprechbar"* · Rekursion **baumförmig compile-time**, *„Mechanik = **Herunterzählen eines Rest-Tiefen-Integers bis 0**"*, *„Tiefe **bei 1 belassen, muss aber funktionieren**"*, **„Tiefe und Heuristik-Funktions-Stufen-IDs im Stempel ablesbar"**, *„formal **EINE Binary am Stück**"*. Zwei Stempel-Felder mit Owner-Wortlaut — im Kopf nicht verbucht, obwohl das Bump-Bündel (#15/#38a2) gerade der letzte Preimage-Schritt vor F2 ist.

**A6 · Stufen-Vererbungs-GESETZ + „System-Achsen sind final drei"** *(Z15696–15698)*
Vom Owner am 05.08. ausdrücklich **„GESETZ"** genannt: *„Mess ist 3-stufig, System und Organ sind 2-stufig"*, dazu *„Die System-Achsen sind final **drei**: `target_isa`, `operating_system`, `external_utils`"*, plus die Stufenzuordnung **Planer → CEB = System → Tier = Organ** (18./19.07.). Der Kopf trägt die 3/2/2-Formel nicht (nur Memory), und die „final drei" steht in Spannung zu KON64/65+KON72 (→ B4).

### A-II — Mess-Kette, Kanäle, Speicher

**A7 · K5: die VIERTE Mess-Ebene ist eine SPALTE, kein Kanal** *(Z15553–15572)*
Owner: im `checkpoint_measure` wird *„zusätzlich angegeben, **welche Tier-Binary** (exakter Stempel über deren statisches Interface) **für diesen Funktionsaufruf verwendet wurde**"* ⇒ **eine zusätzliche SPALTE in der Macro-Benchmark-Stufe**; *„**Es sind dann 4 statt 3, weil es ein weiteres Macro-Benchmarking gibt.**"* Und: **Overhead = Macro-Messung(Hybrid-Aufruf) − bekannte Einzel-Tier-Performance** — *„die eigentlichen Tier-Binary-Performance ist ja **VOR der Hybrid-Stufe bekannt**"*. Das ist die **operative Auflösung der Mess-Ebenen-Zählung** und fehlt im Kopf vollständig.

**A8 · SECHS STEUERDOCKS Planer↔CEB — zwei Rechtsakte, Sammel-Release** *(Z14784–14853)*
Owner: *„Damit hat der Planer **6 STEUERDOCKS** — für jede CEB einen, der **genau auf vorhandene einkompilierte Messeinrichtungen passt** und auch **nur bestimmte Steuerbefehle freigibt, die tatsächlich existieren laut Plan**."* Der Kanal trägt **zwei nicht austauschbare Rechtsakte**: **FREIGABE der System-Achse**, **DURCHSETZUNG der Organ-Achse**. Und eine Mess-Integritätsregel: *„Der **Release** kann nur unter Logging der CEB an den Planer auf die CLI des Planers vor oder nach der Gesamt-Messung **GESAMMELT** erfolgen"* — Senden **während** der Messung erzeugt genau die Latenz, die gemessen wird. Im Kopf: Docks nur als **Deckel 32** (KON71) — der Planer-seitige Steuerkanal fehlt.

**A9 · Die Kausalkette hinter dem fehlenden Mess-Kanal: EIN Defekt, fünf Stufen** *(Z14855–14921)*
Owner: die variadischen Mess-Template-Variablen werden *„**nicht über Gattung+Genus Interface per Metaprogrammierung durchgereicht** und **in die Genus-Implementierung hinter die Gattung+Interface Kaskade gebaut**"* ⇒ kein Signalkanal im Tier-Binary ⇒ **globale Init der zwei `checkpoint_measure`-Arenen geht nicht** ⇒ *„die CEB kann … keinen `flush()` der Messwerte (**je Arena getrennt**) beauftragen"* ⇒ am ABI-stabilen Prüfdock **können keine Signale gesendet werden**. **Es ist eine METAPROGRAMMIER-Lücke, keine Laufzeit-Lücke** — *„zur Übersetzungszeit oder gar nicht"*. Der Kopf trägt die Arena-Karte (KON92 E1-E10, KON93 C6) — **nicht** die Durchreich-Ursache und **nicht** das „flush je Arena getrennt".

**A10 · MeasureStorage: acht Owner-freigegebene Festlegungen — „volles GO, alles korrekt"** *(Z15143–15193, Z15194–15283, Z15630–15644)*
Owner: *„**Alle anderen Annahmen von dir: volles GO, alles korrekt.**"* Damit sind **Festlegung, nicht Vorschlag**: `mmap` statt `pmr`-**Typ** (der virtuelle `do_allocate` wird nicht gebraucht) · **lineares Append-Log statt Ring** · kein Lock im Hot-Path · **verifizierte Hauskonstante statt `std::hardware_destructive_interference_size`** (Clang: *„not stable between releases"*, flag-abhängig ⇒ *„Bei sechs CEB-Varianten … ist das **ABI-Risiko real, nicht theoretisch**"*) · **gezieltes `madvise(MADV_HUGEPAGE)` + Pre-Touch statt systemweitem THP** (systemweit löst synchrone Compaction genau im Messfenster aus — *„die subtilste Verzerrungsquelle des ganzen Entwurfs"*) · roh aufnehmen statt bucket-komprimieren · `ErgebnisMappe` als Konsument.
Owner zur Zweiteilung: *„`checkpoint_measure` hat also **2 interne Systeme — Mess-Arena und Stack-Arena, custom**"* — Mess-Arena APPEND/monoton/Auswertung zum Schluss; **Stack-Arena LIFO, hält nur Referenzen, ist ein Positionsanzeiger (Ebene · Modul · Funktion)**. Überlauf = **zwei Fehlerklassen** (Datenverlust vs. Programmierfehler), **getrennte Cachelines Pflicht** (sonst selbstgemachtes False Sharing im Modul, das False Sharing messen soll).
Harte Randbedingung: *„**neue Allokationen für die Messwert-Aggregation sind VERBOTEN, weil sie das Bild der Messungen verzerren**"*.
→ KON92/KON93 bauen gerade E1-E10 + 6-GB-Arena — **ohne dass eine dieser acht Festlegungen im Kopf steht**.

**A11 · Vier Bestands-Fallen vor dem MeasureStorage-Bau** *(Z15248–15266)*
`ThreadArena` und `InMemoryMeasurementBuffer` **sehen aus wie die Vorlage und verletzen genau die Randbedingung** (wer sie kopiert, baut den Defekt nach) · `LIFOStackBuffer` ist eine **Queuing-Achse des gemessenen Containers**, kein Mess-Aggregat · `IMeasurableWorkloadV3`/`ComdareSegmentLatencyV2` = **der einzige allokationsfreie Mechanismus im Haus, 0 Aufrufer in der Produktionskette** · **`csv_to_latex` ist KEIN totes Auslaufmodell** (großes aktives Modul mit CLI und mehreren Konsumenten) ⇒ Owner-Auftrag *„**csv_to_latex darf es nicht mehr geben, sondern measure_to_latex**"* bedeutet **Ablösung mit Migrationspfad, nicht Neubau auf grüner Wiese**. Im Kopf steht `04_csv_to_latex` **nicht einmal** in der F6-Repo-Rollen-Karte (#74).

**A12 · Die T-15-KOSTENZAHL: die Mess-Phase verdreifacht sich** *(Z15403–15410)*
> *„`reps=3` misst jede Zelle **DREIMAL** statt einmal. Zusammen mit der KF-10-Achse (`<repetitions count=3>`) sind das **9 Messungen je (Binary × Einstellung) statt 3**. **Die Mess-Phase verdreifacht sich** — die Bau-Phase nicht. Reruns kommen gedeckelt obendrauf."*
Trifft den Mess-Deckel (ETA ≤ 4,5 Maschinentage) und **muss in die `--check-size`-Rechnung**. Der Kopf lässt S-19 (#7, Sa 22.–Mo 24.08.) die Bau-/Mess-Zahlen rechnen — **ohne diesen Faktor 3**.

**A13 · Drei bewusst ungebaute T-15-Teile, davon zwei mit offener Owner-Frage** *(Z15411–15455)*
(1) **„ganzen Lauf neu starten" — die Granularität ist nirgends definiert**: Zelle / 4096er-Batch / Kampagnentag / gesamte mehrtägige Kampagne. Der Wiederaufsetzpunkt existiert bereits (Takeover über ETA+50 %, PromiseGuard-Release) — *„sobald die Granularität feststeht, ist das Bauteil klein"*. (2) **Retry einer als „failed" klassifizierten Messung** — *„beim Scheitern bis zu 5 Wiederholungen"* ist **zweideutig** (Drift-Rerun **oder** dritte, komplett ungebaute Achse; im ganzen `perm_runner`-Pfad gibt es dafür keine Schleife). (3) `chaos:drift` baut heute nur `test_chaos_drift_gate`; **T-15 ist kein eigenes CI-Gate**. Im Kopf: nichts davon — obwohl W3 ab 29.08. fährt.

**A14 · LAG-P2 ist NICHT scharf — die Restliste steht konkret da** *(Z16487–16503)*
Bauer wörtlich: *„Ich habe die **Erreichbarkeit** hergestellt und die **Semantik** bewiesen, **NICHT die Wirkung**."* `mess_bestandslog_active` bleibt im Produktions-Lauf **false**. Fehlend: drei Deklarationen in `super Code/02_messung_driver/main.cpp` (~:1112-1114), die Belegung im gegateten Zweig, drei `pa.*`-Durchreich-Zeilen (~:1349-1351) — **und eine neue Variable `COMDARE_BESTANDSLOG_MESS_DOC_KEY` in die Forward-Liste des Planers** (`experiment_plan_director.hpp:1008-1011`), *„weil dynamische Child-Pipelines globale Parent-Variablen **nachweislich nicht erben**"* (belegt an Serie-E2E 11562/11566). **#57 (Lager-Vollausbau, W2-Pflicht) führt diese vier Punkte nicht** — sein Punkt (4) ist die Teilprojekt-Commit-Skip-Logik, ein anderer Gegenstand.

**A15 · Tier-Binaries werden nicht vorgehalten** *(Z14289–14329)*
Owner: *„die **Tier-Binaries NUR direkt im buildsystem cache landen** … weil **die Maschine den Speicher nicht vorhalten kann**, sie werden also auf prod1 und prod2 nur **hot in den RAM gecached und dann verworfen nach der Ausführung**."* Folgen: **die Lagerhaltung lagert MESSDATEN, nicht Binaries**; der Buildsystem-Cache ist die **einzige** Persistenzstufe; die Zwei-Maschinen-Abstimmung betrifft die **Zuteilung von Batches**, nicht das Verteilen fertiger Binaries. (→ Spannung B3.)

**A16 · `delete_p99_ns` existiert 0-mal (D5-4)** *(Z16613–16614)*
`serialize_abi_tier_trace_json` emittiert für `delete` **nur p50 und p95**, während `write` und `read` je p50/p95/p99 tragen. Eine durchgängige Lücke in der Mess-Emission, die jede p99-Auswertung über Löschoperationen leer laufen lässt. Im Kopf nicht verbucht.

### A-III — Kette, Lager, Hybrid

**A17 · Die Kette hat FÜNFZEHN Stationen, nicht acht** *(Z14663–14729)*
Owner wörtlich: *„nach auswerten kommt erst **single bauen → single messen → single compare → single release optimal Tier-Binary für JEDE gemessene Last der Mess-Achse** → **Hybrid-Tier-Binary … bauen → messen → compare → multi release**"*, und: *„Die Strategien für single und hybrid verwenden also **exakt dieselben stateful design patterns und Abläufe der Entwicklung**, aber **wir müssen erst für jede Last das optimale Tier-Binary kennen**."* Vier Konsequenzen: **COMPARE ist eine eigene Station, zweimal** · **RELEASE heißt „das Optimum je Last", nicht „veröffentlichen"** · der Hybrid-Zweig ist **nicht vorziehbar und nicht parallelisierbar** · **die Mess-Achse liefert den Nenner des single-Zweigs** („für JEDE gemessene Last" = eine prüfbare Zahl). Der Ledger notiert ausdrücklich, dass die Stationsliste der laufenden Inventur **unvollständig** ist. Im Kopf und in der Memory-Kurzform lebt noch die **8-Stationen**-Fassung.

**A18 · K1: der Lagerbaum bekommt ZWEI NEUE WURZELEBENEN — für ALLE Gattungen und Genera** *(Z15517–15542, Z15700–15718)*
Owner: *„**Binary-Ordner und Messung-Ordner branchen unter Gattung → Genus → Binary/Messung → REST wie gehabt.**"*
```
Gattung → Genus → Binary  → System → Organ → Mess     (Binaries-Zweig)
Gattung → Genus → Messung → Mess   → System → Organ   (Messdaten-Zweig)
```
Die Verzweigung Binary/Messung sitzt **UNTER** Gattung→Genus. *„Das ist kein Einwand gegen den Entscheid, sondern die Ansage, dass **K1 mehr kostet als die eine Zeile in `lager_pfad_grammatik.hpp:527`**"* — Pfad-Grammatik, Tests und Wachen müssen mit. **#57 (Lager-Vollausbau) nennt diese zwei Wurzelebenen nicht.**

**A19 · Hybrid delegiert Tier-Bau und -Laden IMMER durch die CEB — und braucht Standard-`compare→release` vorher** *(Z15482–15494, Z15681–15685)*
Owner (OV-13): *„der **Release wird natürlich VOR der Anwendung der Hybrid-Stufe** mit einem einzelnen direkten Tier-Binary am Prüfdock **getestet und bewiesen**, bevor wir überhaupt den Hybrid an die CEB Prüfdock dran hängen. **HY braucht also Standard compare→release durch die CEB.**"* Verwaltung: **die CEB** über *„statisches init zu Beginn"* + *„Übertragung der Verhaltens-Heuristik-Funktionen bei Verwendungsbeginn"* am Prüfdock. Dazu K2: der Loader wandert in eine **stufen-neutrale Bibliothek**, *„weil das Prüfdock der CEB und das Prüfdock der Hybrid-Tier-Binary jeweils **technisch identisch bei Konfiguration** sein müssen"*. Im Kopf: #57 nennt nur „(3) Hybrid-Push-Pfad (heute unbelegt)".

**A20 · Zwei unvereinbare Definitionen von „beste Binary" — der Fork ist real und ungelöst** *(Z16005–16008)*
`best_binary_selector` (1104 Zeilen, zwei grüne ctest, empirisch gegen echte Mess-CSV gelaufen) kürt **einen globalen Sieger je Metrik, gemittelt über alle Lasten** — **F8 verlangt einen Sieger JE Eingangslast, mehrere gleichzeitig**. Dazu **E-5, der teuerste ungefällte Entscheid**: *„welcher der drei Kurven-Stacks ist kanonisch? **Ohne Entscheid entscheidet der Aufräumpass §75 implizit** — und dann ist die Wahl getroffen, ohne dass jemand sie getroffen hat."* (1802 Zeilen Kurven-Synthese über drei parallele Stacks, **null Produktions-Konsumenten**.) Task #21 bucht E-1…E-4c als erledigt — **E-5 ist nirgends beantwortet**.

**A21 · K4 wurde nie gefragt — ich habe es durch E-1 ersetzt** *(Z15076–15090)*
Label **K4** gilt laut Design-Dokument seit 02.08. als **ENTSCHIEDEN** (Systemachsen-Framing); das Konformitäts-Register vom 09.08. führt **dasselbe Label** als **ungeklärt**, für einen Gattung-gegen-Stufe-Konflikt, der **nirgends ausformuliert** ist. Der Plan fordert *„klären, nicht glätten"* — *„Ich habe es geglättet … **K4 wurde nicht einmal gefragt**."* **K4 gehört getrennt von E-1 auf die nächste Owner-Vorlage** und taucht im Kopf nicht auf.

**A22 · `--check-size` ist Vorbedingung der Messplanung, und die Mengenfrage ist per Konstruktion unbeantwortbar** *(Z16020–16031)*
Voll-Matrix ungedeckelt **≥143 Maschinentage** einthreadig (Untergrenze); Deckel **4,5 Maschinentage = 3,1 % davon**. **HY-B steht laut OV-4 außerhalb des Deckels und ist unbeziffert**; kein Dokument nennt #Lastprofile oder k je Profil. *„Ehrliche Antwort: unbeantwortbar, bis `--check-size` existiert und EIN HY-B-Punkt gemessen ist."* Der Kopf kennt die `check-size`-Lücke (KON73-Explore-Karte) — **nicht** diese Zahlen und **nicht** den unbezifferten HY-B-Rest.

### A-IV — Doktrinen, Zählwerke, Wachen

**A23 · „Wir streichen nichts" — die Beweislast ist umgekehrt** *(Z14330–14366, Z14381–14401, Z14501–14504)*
Owner 09.08. 10:23:05 UTC: *„Ja, **wir streichen nichts und können uns das auch nicht leisten.** Wir parallelisieren disjunkte Arbeit wie in der Arbeitsweise beschrieben."* Und: *„der **Wellenplan steht und gilt**, er wird **höchstens durch mich geschärft**, aber das **Fundament bleibt stehen**."*
**Praktische Regel:** *„ein Posten verlässt den Plan nur mit einem **zitierbaren Owner-Satz zum Gegenstand** — nicht mit einer OV-Nummer, nicht mit einer Empfehlung, nicht mit Zeitdruck."* Was ausdrücklich **steht**: Wellen W-1…W5, die **Reihenfolge-Zwänge** (D1e vor D1b · D3-7 vor allen D3-Gates · D4a/b vor D4c · D5-1 vor jedem ernsten Messwert · HY-A→HY-B→HY-C), der **Verifikationsvertrag V-1…V-8**, der TDD-Vertrag T-1…T-9, die Abnahme-Regel, die fünf Prüfungen, der Stellvertreter-Begriff, die Nenner-Pflicht. **V-1…V-8 kommen im Kopf nicht vor** (die dortigen V1–V10 sind Owner-Vorlagen aus KON80 — eine gefährliche Namenskollision).

**A24 · OV-Nummern sind kein Autoritätsbeleg — der Mechanismus, der falsche Wahrheit erzeugt** *(Z14434–14449)*
Belegt: „OV-18" im Wellenplan v2 ist ein **anderes** OV-18 als das konsolidierte OV-18 im Ledger. *„Über diese Kollision kann ein »OV-x bestätigt« **wahr aussehen**, obwohl der Owner zu diesem Gegenstand nie befragt wurde."* Und *„Owner-KERN 1 sagt wörtlich »SPEZIFIZIERT, NICHT GEBAUT«"* hat in **beiden** Transkripten **0 Owner-Treffer**. (In Memory als Regel vorhanden — im Kopf nicht.)

**A25 · Owner-Direktive 17.07.: Fehlerklassen sind PFLICHT — Stand 0 von 18 bzw. 0 von 121** *(Z14455–14460)*
Verbatim: *„**Fehlerklassen und Behandlung sind für alle Achsen → Unterachsen → Algorithmen Pflicht.**"* Kettenwirkung: ohne Fehlerklassen **reißt ein Hardware-/Compile-Fehlen im Messfenster die Pipeline, statt klassifiziert weiterzumessen** — *„MESSEN wird nicht leer, aber genau dort fragil, wo der Owner Schutz angeordnet hat."* T-13/T-14. Im Kopf: nichts.

**A26 · Der 2D/3D-Graphen-KERN (06.08. 05:44 UTC)** *(Z14411–14414)*
Owner: *„eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper? Orientiere dich daran und **verwende 2D und 3D Graphen**."* Die F-07b-Streichbegründung („Tabellen tragen die Aussage") war **wörtlich die Position, die dieser KERN korrigiert hat**; „Streichkaskade bestätigt" ist **erfunden** (6 Treffer, alle Agent-Text). Kettenstation **VERÖFFENTLICHEN**. Der Kopf trägt nur die Marker-Setzung (#49-C2), nicht den KERN selbst.

**A27 · `prod2` wird umbenannt — ein Byte-Ereignis, das ein Bump-Fenster braucht** *(Z15650–15651)*
Owner-Kleinentscheid: *„Ja umbenennen"*, weil es dauerhaft so bleibt. **Der Registry-Generator spiegelt den Namen** ⇒ *„in ein Fenster legen, in dem ohnehin ein Bump ansteht"*. Mit F2-Freeze am 21.08. und dem Bump-Bündel in W1 ist das **jetzt** das Fenster — im Kopf steht davon nichts.

**A28 · Das Konformitäts-Register: 256 Aussagen, 17 % erfüllt, +1564 h Nachfund** *(Z15887–15977, Z16291–16396)*
| | | |
|---|---|---|
| ERFÜLLT | 44 | **17 %** |
| TEILWEISE | 118 | 46 % |
| NUR_PAPIER | 65 | **25 %** |
| VERLETZT | 22 | **9 %** |
| NICHT_PRÜFBAR | 7 | 3 % |

Kettenmuster: erste 87 Aussagen (XML/Planer/CEB) **23 %**, die vier hinteren Stationen **14 %** — *„je weiter hinten in der Kette, desto weniger Realität"*. Aufwand: **~770 h** (erste Messung) **+ 1564 h** (Stationen 5–8). Der Kopf führt als Fortschrittsmaß nur **KON82 (51/51 Posten verortet, VERLUSTLISTE LEER)** — ein **anderer Gegenstand** (Posten statt Aussagen). **Eine Nachmessung dieses Registers ist im Kopf nirgends belegt.**

**A29 · Die aufgehobene Streichliste ist eine Liste lebender Bau-Posten** *(Z16345–16360)*
Da die Streichung als Ganzes aufgehoben ist (A23), sind diese neun **Bau-Posten**, nicht Erledigtes: CEB-27 **Arbeitsmodus/Hot-Switching im RAM** (−40 h) · CEB-43 + Post-v3 `.so`/`<modules>`-Schnitt (−64 h) · CEB-12 Wallclock-Vollausbau (−28 h) · CEB-34 Release-Rekonstruktion (−24 h) · CEB-18 P/E-Core (−16 h) · CEB-20 L2/Kohärenz (−12 h) · **Paper-XML: Generator für 33 statt 3 Referenz-Paper** (−22 h) · Compiler-Unterachsen-Toolchain-Permutation (−12 h) · CEB-19 Pinning-Kette (−10 h). Der Kopf führt nur **P/E-Core → W7** (#21) und **P7 Paper-Isolations-Modus** (KON77) — **sieben der neun fehlen**.

**A30 · Blockierende Entscheide vom 09.08. ohne Kopf-Spur** *(Z16388–16396)*
**D-5 (Bau- gegen Mess-Menge)** — *„der Bestand widerspricht sich hier selbst: Owner-Entscheid D-3 sagt »Bau folgt Mess«, die 08.08.-Aussage sagt »größerer Bau-Satz, Teil davon messen«"* · **CEB-38 (CEB-Änderung = Vollrebuild ja/nein)** · **CEB-Identität A/B** · **`std::variant`-Fehlerklassen-Ausnahme** · **Wallclock-Schichtzuordnung** (letzteres per KON60-(iii) gelöst). Die ersten vier sind im Kopf nicht auffindbar.

**A31 · Bündel operativer Wachen und Fallen ohne Kopf-Spur** *(diverse)*
- **Nenner einer Pipeline = `/jobs` UNION `/bridges`** — *„Wer nur `/jobs` zählt, misst strukturell zu wenig"*; und der super-Trigger fährt `branch: main`, **nicht den vendorierten Stand** (`super .gitlab-ci.yml:1002-1005`) *(Z13641–13693)*.
- **`libs/` sieht sich selbst NIE mit `-Wall`**: `COMDARE_set_default_warnings()` hat **genau EINEN Aufrufer** (`COMDARE_add_test`) ⇒ 0 von 16 Bibliotheks-Komponenten mit Warnstufe, Kompilierzeile `-O3 -DNDEBUG -std=c++23`, sonst nichts. *„Die Bau-Jobs melden 0 Warnungen nicht, weil der Code sauber ist, sondern weil **niemand hinsieht**"* *(Z14544–14557)*.
- **Offener Defekt D2**: `result_aggregator.hpp` — `fingerprint` ohne Initialisierer, Copy-Konstruktor liest den unbestimmten Wert (UB); **der beißende Köder fehlt noch, ausdrücklich offen** *(Z14578)*. Ebenso `axis_filter_bloom.hpp:111` (verdecktes `kHashes` ⇒ **stille Divergenz in einem Mess-Algorithmus**, sobald k ≠ 4).
- **Zwei überlebende `allow_failure`-Stellen in ce**: `is_original:relock` (geklärt, kein Verstoß — `when: manual` ohne `allow_failure` setzt die Pipeline auf `blocked`) und **`build:arm64-smoke` (`:231`) mit Ablaufdatum im Kommentar: *„advisory bis #179-Bereinigung, danach HART"*** *(Z13634–13640)*.
- **Registrierungs-Wache fehlt**: *„wird der Proben-Job selbst gelöscht, läuft die Probe nicht mehr und **kann ihre eigene Abwesenheit nicht melden**"* ⇒ zweite, unabhängige Wache über alle `ci/tests/*.sh` gegen die `.gitlab-ci.yml`. Und: **vier von fünf CI-gerufenen Wachen haben weiterhin keinen Selbsttest** *(Z16172–16175, Z16215)*.
- **`|| echo "…kein Fehler"` an ALLEN DREI CI-Aufrufstellen von `appendix_generator_cli` schluckt JEDEN Exit-Code** — *„grün über nichts", diesmal im Anhang-Pfad* *(Z15267–15271)*.
- **`AF_CORPUS_ROOT` zeigt ins Leere**: Default `measurement` existiert am Repo-Root nicht; der getrackte Korpus liegt unter `docs/architektur/measurement/` (18 Dateien, **8 im Archivformat `<stem>.result.csv`**); `.gitlab-ci.yml:1524` setzt denselben toten Wert *(Z16254–16262)*.
- **ZWEI PARSES, EINE ENTSCHEIDUNG**: `profile_run_facade.cpp:605` und `profile_run_entry.hpp:948` lesen dasselbe Profil zweimal — *„Driften sie, läuft die Perm-Schleife **ohne `compile_for_perm`**"* *(Z16126–16129)*.
- **gitleaks-Falle**: auf dem Submodul-Gitdir „0 commits scanned", **rc=0** (relatives `core.worktree`, git bricht mit 128 ab, gitleaks meldet trotzdem 0) — *„ohne die Commit-Zahl in der Ausgabe wäre das nicht aufgefallen"* *(Z15336–15339)*.
- **Token-Hygiene**: drei 0600-Dateien mit Zugangsdaten-Charakter im gemeinsamen Scratch (`.tok` 51 Byte = **exakt die Länge des gültigen PAT**), bis drei Tage alt ⇒ Regel *„nach jedem Vault-Zugriff sofort `shred -u`, beim Sessionwechsel Scratch gezielt absuchen. **Finder meldet, Lead schreddert.**"* Plus: *„vor jedem Vault-Zugriff erst `push --dry-run`"* *(Z15351–15368, Z15092–15100)*.
- **Vendoring-Prüfregel**: den vendorierten Stand **immer** per `git ls-tree HEAD <pfad>` / `git submodule status` lesen, **nie** per `rev-parse` auf einen Tracking-Ref im Submodul (kostete eine 85-Commit-Fehleinschätzung) *(Z15843–15849)*.
- Weitere stille Nullen: `Code/**/tests/`-Pathspec (0 Treffer, Exit 1, keine Meldung) · `clang-format` auf `.hpp.in` ohne `--assume-filename` meldet **84 statt 20** Abweichungen · Biss-Nachvollzüge brauchen eine **frische Vollkopie**, sonst *„stirbt der Mutant an der falschen Ursache"* *(Z15863, Z15107–15110)*.
- **`measure_selection` = 0 Treffer im ce-Baum, obwohl Paket #11 als erledigt geführt wird** — ausdrücklich als eigener Prüfposten notiert *(Z14207–14209)*.
- **`docs/termine/` wurde nie als Posten eingereiht** (`.docx`/`.pptx` nie durchsucht) *(Z15125–15129)*.

---

## (B) WIDERSPRÜCHE ZUR KOPF-REFERENZ (ohne tragenden Marker)

**B1 · Die Permutations-Nenner 6 / 24 / 48 gegen „dynamisch >32, nur S-19 rechnet"**
- **Segment** *(Z14220–14288)*, Owner verbatim: *„durch **4 Messebenen mit der Hybrid-Struktur** auch **4 fakultät** auch **3 fakultät CEB Systeme** … es gibt also **4 fakultät Rekombinationen gegen die 6 CEBs**"* — dazu: *„Die 6 fallen nicht weg; sie sind der Bezugspunkt, gegen den die 24 gemessen werden"* und *„sie ist **gesetzt, nicht abgeleitet** — und wird so umgesetzt"*. Ausdrücklich offen gelassen: **24 oder 24 × 2 = 48**.
- **Kopf**: KON71 — *„DRITTE 32er-Ruege (**Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet**)"*; KON64/65 — *„32er-Falle: Belegungs-Welt (2^5) entkoppelt von Dock-Zahl"*.
- **Kein Marker verbindet beides.** Offen bleibt, ob 3!/4! heute noch als Nenner gelten oder ob S-19 sie ersetzt — und ob die 24-gegen-48-Frage damit gegenstandslos ist oder noch dem Owner gehört.

**B2 · Wie viele Mess-Ebenen sind zu messen — drei, vier oder fünf?**
- **Segment**: *„Der Satz »**vier gemessen, fünfte spezifiziert**« ist **gegenstandslos** — **es sind fünf zu messen**"* *(Z14763)*; zugleich *„3 Ebenen ⇒ 3! = 6 … ob die Hybrid-Ebene auf 4 hebt, ist die Frage"* *(Z13911–13913)*; und K5: *„**Es sind dann 4 statt 3**, weil es ein weiteres Macro-Benchmarking gibt"* *(Z15562)*.
- **Kopf**: durchgängig **w / ma / mi** als die Mess-Ebenen (KON80-V7 *„Break-Even NUR über Organ-Parameter der **w/ma/mi**"*, KON71 iw/ima/imi-Tokens), PMC als **eigenständige dreiphasige Meta-Meta-Achse** (KON64/65) — also drei + Meta-Meta.
- **Drei Zählungen, kein auflösender Marker.** Die im Segment als „gegenstandslos" markierte Formel ist die einzige Stelle, die **fünf** sagt.

**B3 · „Die Lagerhaltung lagert MESSDATEN, nicht Binaries" gegen den gebauten Binaries→Lager-Pfad**
- **Segment** *(Z14297–14315)*: *„**Kein Vorhalten auf Platte.** Das ist keine Optimierung, sondern eine Kapazitätsaussage"* · *„**Die Lagerhaltung lagert MESSDATEN, nicht Binaries.** … Wer den Lagerbaum als Binary-Archiv liest, plant Platte ein, die es nicht gibt."*
- **Kopf**: KON67 *„Lager=NAS-Wahrheit"*; #48 *„(1) **Binaries→Lager GEBAUT** (lager_baum_writer, Dual-CCache Default MinIO)"*; #49 *„Staffelung Owner-verankert: **Binaries+Lager** VOR Darstellung"*; A18 (K1) verlangt sogar einen **Binaries-Zweig** unter Gattung→Genus.
- **Auflösbar** (der „Binaries→Lager"-Pfad könnte genau der Buildsystem-Cache sein) — **aber kein Marker trägt die Auflösung**, und die Kapazitätsaussage („die Maschine kann den Speicher nicht vorhalten") gilt unverändert.

**B4 · „Die System-Achsen sind final DREI" gegen die gewachsene System-/PMC-Landschaft**
- **Segment** *(Z15696–15698)*: Stufen-Vererbungs-**GESETZ** (05.08.) — *„Mess ist 3-stufig, System und Organ sind 2-stufig. Die System-Achsen sind **final drei**: `target_isa`, `operating_system`, `external_utils`."*
- **Kopf**: KON64/65 *„PMC = **EIGENSTAENDIGE** dreiphasige Meta-Meta-Achse … F2 Planer-HW-Erkennung NUR für PMC, **System-Achse=Proxy**"*; KON72 *„**F-P7=A cpu_sub**"*, *„**doppelte HW+SW-Versionierung**"*; KON71 *„OS-Realm-Doktrin"*.
- Die 3/2/2-Formel wird im Kopf nirgends bestätigt oder aufgehoben; die Zusatz-Achsen sind mit „final drei" nicht vereinbar.

**B5 · OV-10 „max. 4 erreichbar" gegen die sechs Steuerdocks — im Segment offen, im Kopf nicht geschlossen**
- **Segment** *(Z14841–14852)*: OV-10 führt die CEB-Varianten als *„Teilmengen-Lesart (**max. 4 erreichbar**), Abnahme: 4 + belegte Begründung warum nicht 6"* — *„**Dieser KERN nennt 3! = 6**, als Zahl der Steuerdocks."* Zwei Lesarten, **„Vorlage, keine Entscheidung meinerseits"**.
- **Kopf**: keine Spur von OV-10, keine Steuerdock-Zahl. Der Konflikt steht **unverändert offen** und hängt an der Bump-Frage im Freeze-Fenster (*„der Gate-Modell-Umbau fällt doch an, mit Bump-Folge"*).

**B6 · Der K5-Dock-Default 32 „IMMER in der XML" gegen „die einzige feste 32 = willkürlicher Dock-Deckel"**
- **Segment** *(Z15553–15558)*: Dock-Anzahl = *„so viele, wie die **gemessenen Break-Even-Grenzen im Standard-Einzel-Release** und **deren Überschnitte für Hybrid-compare** ergeben — mit einer **Obergrenze, die bei Hybrid-Anforderung IMMER in der XML stehen muss**, Default **32**."*
- **Kopf**: KON71/Memory — *„die einzige feste 32 = **Dock-Deckel (willkürlich)**"*; KON80-V7 grenzt Break-Even **auf Organ-Parameter der w/ma/mi** ein.
- Die Herleitung („gemessene Break-Even-Grenzen") und die Bewertung („willkürlich") stehen unversöhnt nebeneinander; V7 verengt die Break-Even-Ebene, ohne K5 nachzuziehen.

---

## (C) ÜBERHOLT-BESTAND (nur Zählung + Kurzliste)

**Vom Segment selbst markiert: 16 Stellen.**
1. work_mode-Erstfassung „fünf Enum-Werte, `kRunMethodologyCount` 4→5" (durchgestrichen, Z13714)
2. §62-C insoweit superseded durch O-A (Z13986)
3. Streichliste ~228 h **als Ganzes** aufgehoben (Z14330/14501)
4. `checkpoint_measure`-Streichung nach W7 **zurückgenommen**; Wellenplan §7 an dieser Stelle **überholt** (Z14730/14782)
5. „vier gemessen, fünfte spezifiziert" **gegenstandslos** (Z14763)
6. Paper-Kopplung: ~~offen~~ + **datierte KORREKTUR 10.08.2026** (Z14478–14495)
7. xlsx/csv „beide speisen sich aus denselben In-Memory-Zeilen" → csv ist **Kind** (Z14528)
8. „Gattung und Genus sind zwei getrennte Achsen" richtiggestellt (Z14979)
9. OV-13 „Owner-bestätigt" war Selbstbehauptung — 0 Treffer (Z15960)
10. WACHE-3-Begründung „zwei Achsen im selben Iterationsraum" korrigiert (Z15041)
11. Verify-Bericht „fünf Graph-Commits ungelandet" — beide gelandet (Z14420)
12. Eigene Zahlen: „~100 Commits" → 18 · „24 Stellen" → 39/38 · „der Bruch wird laut" → still (Z15841)
13. „34 unbewachte Stellen" → 38 · „Pin 51→50" → **drei** Pins · „Definitionen 1 (heute 2)" → 3 (Z16549)
14. Trennlinie 9-gegen-2 bei `nearest_rank_median` existiert nicht (Z15750)
15. Register-Befund „kein Batch-Job setzt `COMDARE_GN_SIMD`" widerlegt (12/16) (Z16072)
16. D3-2 Wellenplan-Selbstwiderspruch korrigiert (Z16195)

**Vom Kopf erkennbar überholt: 12 Blöcke.**
G2/G3 teilen ein Gate ⇒ „höchstens 2 von 6 CEB-Varianten baubar" → **B2-Gate-Trennung gebaut** (KON72/74) · `origin/development` clang-unbaubar (WACHE 3) und **`ce build:clang` fährt nie** → **CI-DUAL gcc+clang, Kombibau 4×491** (KON61/66) · `xlsx 0 / csv 36`, „xlsx ist die Ausgabe aktiv verletzt" → **Vorlage-B4 xlsx=STAMM/csv=KIND dreiwertig** (KON60) · „csv **flach** in einen Ordner" → **CSV=FACTORY, verschachteltes Filesystem** (KON89-D3) · „der Durchstich trägt heute nicht / jede Mess-Abnahme ist ein Stellvertreter" → **F1 GELIEFERT 14.08., Messung 377503** (KON63) · Vendoring-Rückstand 98 Commits / `a1d0c201` → **mehrfach gebumpt** (KON56/58) · „die drei `wide`-Stellen in EIN Skript ziehen" → **`ci/wide_aggregat.sh` existiert** (KON73-F6/#74) · GitLab HTTP 500 / Infra unten → **helm 19.1.4 deployed** (KON72/73) · prod2 „offline/nicht auflösbar" → **Flotte online** (KON71/#60) · Wallclock-Schichtzuordnung offen → **KON60-(iii)** · `lager_pfad_grammatik.hpp:527`-Hybrid-Sperre „wartet auf K1" → **K1 entschieden** (im Segment) + **#57** · Sheet-/Ausgabe-Fragen des Registers → **KON87/88/91 P1-Vollbild**.

---

## (D) TRAGENDE ARCHITEKTUR-KERNE DIESES SEGMENTS

1. **Die Kette hat 15 Stationen, nicht 8.** Owner: *„nach auswerten kommt erst **single bauen → single messen → single compare → single release** optimal Tier-Binary **für JEDE gemessene Last** … → **Hybrid-Tier-Binary bauen → messen → compare → multi release**"* *(Z14667)*. COMPARE ist zweimal eine eigene Station; RELEASE heißt „das Optimum je Last", nicht „veröffentlichen".
2. **Symmetrie ist Identität, nicht Ähnlichkeit:** *„Die Strategien für single und hybrid verwenden **exakt dieselben stateful design patterns und Abläufe**"* — daraus folgt **ein** Zustandsautomat, **einmal** gebaut. Die Hybrid-Haupt-Achse liefert **nur die Factory, nie den Automaten** *(Z14069–14072)*.
3. **`work_mode` ist die Typisierung dieser Kette** — Unter-Achse unter `measurement_category`, State Pattern, **Besitzer = Planer/Director**; `build → measure → compare → release`; `--debug` ist ein **orthogonales CLI-Flag**, kein fünfter State, und für Anwender gesperrt *(Z13726–13743)*.
4. **Die Reihenfolge Single-vor-Hybrid ist sachlich zwingend:** *„wir müssen erst für jede Last das optimale Tier-Binary kennen"* ⇒ **HY-A→HY-B→HY-C ist nicht parallelisierbar** *(Z14706–14708)*.
5. **Gattung/Genus sind KEINE Achsen.** Owner: *„eine konzeptionelle metaprogrammierte abstrakte Klassenhierarchie … **Gattung+Genus werden als EINZELNES Genus Binary kompiliert und das ist EXAKT EIN Tier-Binary**"* *(Z14996)*. Unter dem Genus sitzt eine **abstract factory `_impl`**, je Funktion eine Klasse mit **einem Hauptalgorithmus**, *„der **ausschließlich durch Achsen-Interface Aufrufe gestützt**"* ist.
6. **Der Hauptalgorithmus rechnet nicht, er orchestriert** — jede Arbeit liegt in einer Achse; **darum sind die Achsen die einzige messbare Stelle**. Und: **der Aufrufgraph ist ein Netz, kein Baum** (rekursiv, quer zu anderen Gattung+Genus) *(Z15020–15025)*.
7. **Das Genus-Interface ist die ABI-Fläche zur CEB:** *„Damit ist das **Genus interface** das, was das **Prüfdock der CEB** sieht. Und dieses braucht auch die **Einrichtungen und Erweiterungen metaprogrammiert für die CEB**."* *(Z14999)*
8. **Die Messung gehört IN die Naht, nicht daneben.** Owner: *„der Ansatz mit den **Sidecars ist falsch** … es muss **am Interface ein Mess-Visitor übergeben werden** oder bei deaktiviert eben nicht"* — **zweiseitige UND-Aktivierung** (CEB **und** Tier), zero-cost bei aus *(Z14926–14943)*.
9. **Der eine Defekt hinter allem:** die variadischen Mess-Template-Variablen werden *„nicht über Gattung+Genus Interface per Metaprogrammierung durchgereicht"* ⇒ kein Kanal im Tier-Binary ⇒ keine Arena-Init ⇒ **kein `flush()` je Arena** ⇒ keine Signale am Prüfdock. **Eine Metaprogrammier-Lücke, keine Laufzeit-Lücke** *(Z14859–14886)*.
10. **`checkpoint_measure` ist unantastbar.** Owner: *„**checkpoint measure ist das zentrale Messinstrument des Systems, es MUSS GEBAUT WERDEN. Sonst gibt es keine Messungen**"* — und es trägt **zwei interne Systeme**: Mess-Arena (append, monoton) und Stack-Arena (LIFO, Referenzen, Positionsanzeiger Ebene·Modul·Funktion) *(Z14734, Z15157)*.
11. **Zwei symmetrische Kanäle, dieselbe Ursache:** Steuerkanal **Planer↔CEB mit 6 Steuerdocks** (Freigabe System-Achse / Durchsetzung Organ-Achse, Release nur **gesammelt** vor oder nach der Gesamt-Messung) und Mess-Kanal **CEB↔Tier** (Visitor am Genus-Interface) *(Z14800–14840)*.
12. **Der Messfühler ist ein Verbraucher** — *„Was er kostet, misst er mit. Die Differenz »mit Fühler« gegen »ohne Fühler« **ist** der Messfehler"* ⇒ die Ebenen müssen **compile-time ein- und ausbaubar** sein *(Z14251–14253)*.
13. **Overhead ist eine Differenz, kein Messkanal:** `Overhead = Macro-Messung(Hybrid-Aufruf) − bekannte Einzel-Tier-Performance`; die vierte Ebene ist **eine zusätzliche Spalte** mit dem Tier-Binary-Stempel je Funktionsaufruf *(Z15559–15571)*.
14. **Tier-Binaries werden nicht vorgehalten:** Buildsystem-Cache → hot im RAM → **verworfen**. Gelagert werden **Messdaten** *(Z14293–14311)*.
15. **Der Lagerbaum bekommt zwei neue Wurzelebenen für ALLE Gattungen/Genera:** `Gattung → Genus → Binary|Messung → REST`, die Realm-Trennung ist ein **Zweig**, keine Wurzel *(Z15528–15542)*.
16. **csv ist das KIND der xlsx:** *„die csv wird doch **aus der xlsx gebildet, IMMER** … was auf dem RAM liegt ist etwas völlig anderes"* ⇒ ein csv-Ergebnis ohne funktionierenden xlsx-Weg ist ein **Widerspruch, kein Sparmodus** *(Z14518–14534)*.
17. **Perzentil-Kanon:** eine Definition `ceil(q*n)-1` (Hyndman/Fan Typ 1), Median = Fall q=0.5; `vals[(n-1)/2]` **ist** dieser Fall für jedes n. Für **Konfigurations-Mediane gilt der Kanon, aber nachgelagert**: die Hauptauswertung misst stumpf in voller Granularität, die compare-Phase leitet ab *(Z15614–15626, Z16591)*.
18. **Allokations-Verbot:** *„**neue Allokationen für die Messwert-Aggregation sind VERBOTEN, weil sie das Bild der Messungen verzerren**"* — Append in einen vor-reservierten, möglichst großen custom Bereich *(Z15641)*.
19. **`debug` beweist die KETTE, `measure` die ZAHL.** Owner: *„die **bereits gebauten hunderttausenden Binaries schnell zu beweisen**, ob sie **prinzipiell korrekte xlsx erzeugen und ablegen**"* — F1 ist derselbe Beweis an einem Messwert, `debug` ist er über hunderttausende *(Z13778–13794)*.
20. **Beweislast-Umkehr:** *„**wir streichen nichts** und können uns das auch nicht leisten"* + *„der **Wellenplan steht und gilt**"* ⇒ **ein Posten verlässt den Plan nur mit einem zitierbaren Owner-Satz zum Gegenstand.** OV-Nummern sind kein Autoritätsbeleg *(Z14386, Z14334, Z14364, Z14443)*.
21. **Und die Meta-Lehre dieses Segments, wörtlich:** *„**Ein veralteter OFFEN-Eintrag an der Spitze ist teurer als eine fehlende Notiz**, weil er die Suche **aktiv beendet**, statt sie nur nicht zu unterstützen. Wer künftig einen Punkt schließt, schließt ihn an der **Spitze** mit, nicht nur am Ort der Entscheidung."* *(Z14493–14495)* — genau der Mechanismus, den diese Gegenlese adressiert.