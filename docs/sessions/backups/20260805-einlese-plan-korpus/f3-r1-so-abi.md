# LENS f3-r1-so-abi — FRAGE 3 / R1: .so-ABI-Vertrag Planer<->CEB (Einlese-Bericht, 05.08.2026)

READ-ONLY-Einlese am Plan-Korpus. Pfade-Kurzform: LEDGER = super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`; SESS = super `docs/sessions/`; BAUPLAN = super `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md`; AUDIT = SESS `backups/20260805-planer-ceb-kette-audit/`.

## 1. Vollstaendige Entscheidungs-Historie (chronologisch, mit Supersessions)

### (1) 17.07. — Dock-.so-Doktrin DEKRETIERT (User)
Memory `feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md:10-19` (User 17.07., "um ganz sicher zu gehen"):
> "Ebene 1 — 'EXPERIMENT-DOCK' (Experiment-Planer <-> CEB), EINDIMENSIONAL: Der Experiment-Planer hat ein Dock fuer C++23-ABI-stabile CEB-.so-Programme ... KEIN Rueckkanal hier" ... "= dasselbe Dock/ABI-stabile-.so/Vertrags-Muster REKURSIV".

LEDGER:1985 (§30-Konsolidierung 19.07.): "Je C++23-ABI-stabile `.so` + Vertrag; CEB system-achsen-versioniert". Wichtig fuer die Vertragsfrage: **Ergebnis-Rueckschrieb laeuft NICHT uebers Experiment-Dock** — LEDGER:1724: "Die CEB schreibt nach Planer-Bestimmungen die angeforderten Aufgaben + Messwerte SELBST an das in der XML eingegebene Ziel zurueck".

### (2) 19.07. — BAUPLAN Fork A / Fork C: .so = ZIEL-Design, Sequenz = Schnittfrage
BAUPLAN:183: "FORK A — Planer<->CEB als echtes dlopen-.so vs. header-only-Vertragsgrenze ... Doktrin verlangt 'CEB selbst ABI-stabile .so' (LED:1619) -> langfristig A=echte .so; kurzfristig vor Deadline evtl. nur die Vertragsform. **Braucht GO.**"
BAUPLAN:244 (KONSOLIDIERUNG §30): "FORK A VERSCHAERFT ENTSCHIEDEN: die CEB ist nicht nur eine .so-Grenze, sondern eine vom Planer GENERIERTE+kompilierte Binary je Messsystem. Die ... .so-Zeilen der Spiegel-Tabelle ... sind damit ZIEL-Design; die Sequenzierung (Vertragsform zuerst, echte Generierung danach) bleibt Fork-C-Schnittfrage."
BAUPLAN:186 (FORK C): "**vor** 28.07 = ... Phase-2-Wiring (... additiv, kein .so). **Nach** 28.07 = ... Fork-A-.so-Grenze."
BAUPLAN:210 (Risiko R3): "Echte CEB-.so bedeutet eigener Symbolsatz/Loader/Gate — Aufwand + Bruch-Risiko. Mitigation: vor Deadline nur Vertragsform (In-Prozess), .so-Grenze als separater INC nach GO."
"§37a" ist dabei KEIN Ledger-Paragraph, sondern Roadmap-Meilenstein `M-§37a` (SESS `2026-07-20-SESSION-DEPRECATED-AUDIT-kuratierte-wiederverwendung.md:68`, mit `20260719-gesamt-roadmap-ledger-diff-ROADMAP.md:317/253`: "Fork-A-.so ... NACH 28.07.").

### (3) 20.07. — A8-Befund: Fork-C .so-Schnitt DEFERRED (ohne Begruendungsklausel)
LEDGER:2832 (zitiert im dep-Audit): "Fork-C .so-Schnitt (§37a) DEFERRED" — **ohne Begruendung**; die kolportierte Begruendung "kein DoD-Traeger" existiert in KEINEM persistierten Dokument (0 grep-Treffer, dep-Audit:68).

### (4) 20.07. — S5-P4-Ruling: DEPRECATED ist NUR das in-process POD als Live-Wire, NICHT die .so-Idee
Code-Marker (verbatim per AUDIT `ist-planer.md:51-60` + `ist-ceb.md` §2.1, `experiment_dock_payload.hpp:57-65`):
> "Die LIVE-Kette Planer -> CEB -> Tier reicht die Achsen-Ranges NICHT ueber dieses in-process POD, sondern ueber den EMITTIERTEN CMake-/YAML-TEXT (... S5-P2 — COMDARE_GN_OPT/_SIMD/_GOLDEN_N_RANGE + measure_out). Das VOLLE Wire-Format (der 5-tiefe #19-Resolver -> LinkedExperimentPlan ...) ist Band-C DEFERRED (Task #19). ... wird aber HEUTE von keiner Live-Call-Site konsumiert."
dep-Audit:68: "Deprecated ist einzig das in-process POD als heutige Live-Wire (S5-P4), nicht die .so-Idee ... das POD 'BLEIBT (never-delete-Doktrin) — getestete Referenz-Serialisierung fuer den spaeteren #19-Resolver'."

### (5) 20.07. spaet — §60-R1-Pruef-Auftrag (User)
LEDGER:3241: "[§60-R1 .so-ABI-VERTRAG] Der Vertrag ... wird derzeit durch **Textemission** aufgeloest, nicht konform mithilfe einer schnellen C++23 `<modules>` .so ABI-stabilen Schnittstelle, die Messergebnisse (bei ~131.000 Ergebnissen) womoeglich schneller transportieren ... **Auftrag: Wiedereinfuehrbarkeit + Sinnhaftigkeit pruefen (deprecated-Audit 20.07.), dann als Post-v3-Strang planen.** (OFFEN, hoch — Post-v3.)"

### (6) 20.07. — Deprecated-Audit BEANTWORTET den Pruef-Auftrag (R1-Verdikt, 3-teilig)
SESS `2026-07-20-SESSION-DEPRECATED-AUDIT-kuratierte-wiederverwendung.md:33`:
> "**R1 (.so-ABI): DEFERRED, definitiv nicht verworfen.** ... (a) *Steuerung:* Wiedereinfuehrung LOHNT — dlopen-Callback (ProgressDelta statt Datei-Polling) ist Voraussetzung fuer die Heuristik-/Replan-Schleife mid-run ... (b) *Daten:* LOHNT NICHT als Performance-Argument — 131k Zeilen CSV kosten Sekunden gegen Tage Messung; die CSV bleibt ohnehin Persistenz-Pflicht ... (c) *C++23-modules-Realismus:* Module liefern KEINE ABI-Stabilitaet — die kommt aus der extern-C+POD+Major-Gate-Schicht (wie anatomy_module_abi_v1) ... Empfehlung: .so-Grenze mit ABI-v1-Muster bauen, modules hoechstens als interne Paketierung der Vertrags-Header."
ebd.:72: "Wiedereinfuehrbarkeit: hoch; der Post-v3-Strang waere im Kern Fork-A/M-§37a wie 19.07. geplant, mit W12-Stempeln als Versions-Gate und dem POD-Payload als Vertrag."

### (7) 20.07. spaet — OWNER-GO auf die Post-v3-Reihenfolge (die massgebliche Owner-Antwort zur Sequenz)
LEDGER:3247 (§60-NACHTRAG, User): "**POST-v3-REIHENFOLGE FREIGEGEBEN ('Ich stimme der Post-v3-Reihenfolge voll zu. GO').** Reihenfolge: **1.** CLI-Haertung (R3 ...) -> **2.** Fork-A-.so-Schnitt (**R1-Steuerung**: Director-Rollen-Naht, **Vertrag=ExperimentSubtreePayload-POD + ProgressSinkFn-Callback, Versions-Gate=W12-Stempel, Muster=anatomy_module_abi_v1; KEIN Daten-Transport-Umbau, CSV bleibt**) -> **3.** #19-Resolver/Band-C + CoR-Verdrahtung -> **4.** F-SPREAD ..."
LEDGER:3256: "#35 Fork-A-.so-Schnitt [= PV-1+PV-2 ...; Vertrag=SubtreePayload-POD (dep-#2) + ProgressSink-Callback]" — Ausfuehrung erst "v3-Strang zu Ende ..., DANN direkt + autonom ... diese Full-Join-Liste in Reihenfolge (U-18)". PV-2 (R2 Driver-Split) dort: "ANALYSE-BEANTWORTET ... konstruktiver Schritt IST der .so-Schnitt -> kein eigener Bau-Task, feeds #35" (LEDGER:3253).

### (8) 02.08. — Katalog-Stand: R1 weiter OFFEN, Begriff "post-v3" nur umbenannt
SESS `20260802-KATALOG-offene-strecke-gesamtplan.md:92`: "R1 .so-ABI Planer<->CEB OFFEN (Live-Kette laeuft ueber CMake/YAML-TEXT ...) ... Begriff 'post-v3' ab 27.07. nicht mehr in Gebrauch — Substanz lebt unter neuen Namen."

### (9) 05.08. — Kette-Audit-IST (wf_a7faa724): Glied 4 = BEWUSST-DEFERRED, kein stiller Doktrin-Verlust
LEDGER:4024: "**Glied 4 (Vertragsform) = BEWUSST-DEFERRED** (Teilbaum-Payload ... existiert vollstaendig+getestet, aber S5-P4-Ruling DEPRECATED 'Band-C Task #19' im Code markiert -> **R1-Textemission ist BEWUSSTER Stand**; §38-Cursor sparse+messdatenfrei KONFORM; offener Rest: kein Planer-Rueck-Leser)."
AUDIT `synthese.md:43`: "**Damit ist die R1-Forderung der SOLL-Lens ERFUELLT: die Textemission ist im Code selbst als bewusster Entscheid markiert — kein stiller Doktrin-Verlust.**"
AUDIT `synthese.md:86`: "R1 .so-ABI ... §60-R1-Pruef-Auftrag (Wiedereinfuehrbarkeit) offen -> Owner." · `synthese.md` OWNER-RUECKFRAGE 3: "Post-v3-Strang planen oder Textemission dauerhaft kanonisieren?"

### (10) 05.08. mittag-1 — Owner-Antwort auf Rueckfrage F3 (R1): KEIN neues Ruling, Verweis auf den Korpus
LEDGER:4030 (OWNER-NACHRICHT VERBATIM): "Frage 3: Mehr Kontext bitte." + "Bitte starte explore Agenten ueber die Plaene (es ist ALLES mit ueber 1200 Fragen bereits beantwortet)." Dazu bindend: **F1 = HARTES GO Planer-Binary-Split VOR Abgabe** ("sonst die Binaries aller Stufen nicht korrekt gebaut"), **F6** = "Wir waehlen immer den saubersten Weg nach Plan, NIE RATEN", **F7** = Planer-Rueck-Leser JA ("er ist eine eigene Binary und die CEB laeuft eigenstaendig, wie soll sonst der Planer dem User feedback ueber die zurueckgeschriebenen Messwerte und durch CEB kompilierten Tier-Binaries geben?").

## 2. WAS ist der "sauberste Weg nach Plan" JETZT (vor Abgabe Fr 08.08., mit Planer-Split-GO)?

Aus dem Korpus eindeutig ableitbar (keine Stelle widerspricht):

1. **Abgabe-Kette faehrt TEXTEMISSION.** Das ist der bewusste, im Code markierte, plan-konforme Stand (S5-P4; Fork-C-Schnittlinie "vor Deadline kein .so"; R3-Mitigation "vor Deadline nur Vertragsform"; Audit 05.08.: Glied 4 = BEWUSST-DEFERRED, "kein stiller Doktrin-Verlust"). Der Live-Draht ist dokumentiert: COMDARE_GOLDEN_N_PROFILE (XML-Re-Read durch die CEB) + COMDARE_GN_OPT/_SIMD + COMDARE_GOLDEN_N_RANGE start:count + COMDARE_MEASUREMENT_COMBO (AUDIT synthese.md:102).
2. **Der Planer-Split (F1-GO) erzwingt KEINEN .so-Vertrag.** F1 betrifft Glied 1 (eigene Binary + Shell-CLI) und Glied 3 (harte CEB-Kompilation je Messsystem statt Runtime-Combo — der eigentliche KERNSATZ-VERSTOSS "Binaries aller Stufen nicht korrekt gebaut"). Die Vertragsform Planer->CEB bleibt davon getrennt (Glied 4, bewusst-deferred).
3. **Der F7-Rueck-Leser laeuft NICHT uebers .so-Dock.** Doktrin seit 17.07.: Experiment-Dock ist EINDIMENSIONAL, "KEIN Rueckkanal hier"; Rueckschrieb der Messwerte macht die CEB SELBST ans XML-Ziel (LEDGER:1724); der §38-Rueck-Kanal ist der sparse Fortschritts-Cursor ("KEIN Mess-Daten-Rueckfluss"). Der geforderte Rueck-Leser liest also die zurueckgeschriebenen Artefakte (progress.cursor/result.csv/Bestandslog) — .so ist dafuer keine Voraussetzung.
4. **Der .so-Schnitt selbst ist fertig geplant und ge-GOt, aber als Post-v3-Position 2 SEQUENZIERT** (§60-NACHTRAG-GO 20.07.): Task #35, NUR Steuerungs-Seite; Vertrag = ExperimentSubtreePayload-POD + ProgressSinkFn-Callback; Versions-Gate = W12-Stempel; Muster = anatomy_module_abi_v1 (extern-C+POD+Major-Gate — NICHT C++23-modules als Vertragsmechanismus); **KEIN Daten-Transport-Umbau, CSV bleibt** (das 131k-Performance-Argument ist im dep-Audit ausdruecklich widerlegt: "131k Zeilen CSV kosten Sekunden gegen Tage Messung").
5. **NICHT kanonisiert ist Textemission auf Dauer**: die Dock-.so-Doktrin bleibt ZIEL-Design (BAUPLAN:244; dep-Audit "DEFERRED, definitiv nicht verworfen"); die Payload bleibt never-delete als Vertrags-Nutzlast des spaeteren #35/#19.

**Kurzform:** Sauberster Weg nach Plan vor Abgabe = Planer als eigene Binary + harte CEB-Kompilation je Messsystem (F1/Glied 1+3), Vertrag weiterhin Textemission+Env (S5-P4-Stand, markiert), Rueck-Leser ueber die zurueckgeschriebenen Dateien (§38-Cursor + result.csv/Bestandslog); .so-ABI-Schnitt #35 bleibt der erste groessere Nach-Abgabe-Posten in der ge-GOten Reihenfolge (nach CLI-Haertung R3).

## 3. Gibt es eine Owner-Antwort, die Textemission vs .so fuer die ABGABE-Kette festlegt?

**Keinen einzelnen woertlichen Satz** "fuer die Abgabe gilt Textemission" — aber eine geschlossene, mehrgliedrige Owner-Entscheidungskette, die genau das festlegt:
- Fork-C-Schnittlinie (19.07., in §30 konsolidiert): .so-Grenze NACH der Deadline; vor Deadline nur Vertragsform (BAUPLAN:186/210/244).
- §60-NACHTRAG (20.07., User verbatim "Ich stimme der Post-v3-Reihenfolge voll zu. GO"): Fork-A-.so-Schnitt = Position 2 NACH dem v3-Strang und nach der CLI-Haertung (LEDGER:3247).
- 05.08. mittag-1: Owner hat R1 NICHT neu gerulet ("Frage 3: Mehr Kontext bitte") und auf den Korpus verwiesen — d.h. der ge-GOte Korpus-Stand (Textemission jetzt, .so als #35 danach) gilt weiter; F1-GO aendert nur Glied 1/3, nicht Glied 4.

## 4. Wirklich OFFEN (ehrlich)

1. **Explizite Owner-Bestaetigung mit Kontext** ("Frage 3: Mehr Kontext bitte"): dem Owner ist die hier rekonstruierte Kette vorzulegen mit der Ja/Nein-Frage: "Abgabe-Kette = Textemission (S5-P4-Stand), #35-.so-Schnitt bleibt erste Nach-Abgabe-Position — bestaetigt?" (Die Korpus-Antwort ist eindeutig, aber die Owner-Rueckfrage 3 der Synthese ist formal unbeantwortet.)
2. **Timing von #35 relativ zur neuen Lage**: ob der Planer-Split (F1) die Director-Rollen-Naht schon so schneidet, dass #35 danach billiger wird (dep-Audit:72 nennt die Rollen-Naht als exakte Schnittstelle) — Bau-Detail, kein Doktrin-Punkt.
3. **F4 (Fork-A-Interim: Env akzeptiert oder mindestens -D-Compile-Define fuer die Combo-Differenzierung)**: ebenfalls "Mehr Kontext bitte" — haengt am Glied-3-Fix, nicht an R1, aber beruehrt dieselbe Naht.
4. **Planer-Rueck-Leser-Traeger** (§38.b-Fertig-Signal: progress.cursor heute konsumentenlos): WAS genau der neue Planer liest (cursor vs result.csv vs Bestandslog) ist als Bau-Spezifikation zu fixieren (Owner-Rueckfrage 7 hat das JA, nicht das WIE geliefert).

## 5. Quellen-Register
- LEDGER §60: :3239-3247 (R1-Wortlaut, NACHTRAG-GO), :3256 (#35), :2832 (A8-DEFERRED via dep-Audit:68), :1724/:1881/:1985 (Dock-Doktrin/Rueckschrieb), :2139-2150 (131k/6TB-Kontext der Zahl), :4024-4031 (Audit-Verdikte + Owner mittag-1 verbatim).
- SESS 2026-07-20-SESSION-DEPRECATED-AUDIT-kuratierte-wiederverwendung.md :15/:33/:68/:72/:74.
- BAUPLAN 20260719-planer-ceb-tier-topdown-BAUPLAN.md :183-186/:210/:226/:244.
- AUDIT backups/20260805-planer-ceb-kette-audit/ {synthese.md:8/:43/:86-87/:102 + OWNER-RUECKFRAGEN, ist-planer.md:51-60, ist-ceb.md §2.1}.
- Memories: feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md, project_post_v3_anforderungen_so_abi_driver_split_cli.md (inkl. 05.08.-Nachtraege), project_20260805_pause_01c_komplett_vor_phase_b.md.
- Wahrheits-Anker 982 (20260726): kein eigenes R1-Ruling enthalten (nur Hybrid-Dock-Randstelle :58) — R1-Substanz liegt in Ledger/dep-Audit/Audit-Backup.
