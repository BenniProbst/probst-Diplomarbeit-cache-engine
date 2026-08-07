# SESSION-UEBERGABE 07.08.2026 -- "alle Fragen muessten beantwortet sein" (Gedaechtnisluecken-Doktrin)

> ERST-ANKER fuer den naechsten Kontext. Owner-Auftrag: *"Bitte erstelle eine reiche
> Session-Uebergabe mit allen Verweisen auf bereits beantwortete Fragen und dass alle Fragen
> beantwortet sein müssten -> Gedächtnislücke"*.
> ASCII (Paragraph erlaubt). Ergaenzt -- ersetzt NICHT -- das Gesamt-Ledger (Nachtrag
> "07.08. mittag-2") und das Gesamt-Dossier.

===============================================================================
## 0. DIE ARBEITSHYPOTHESE DIESER UEBERGABE (das Wichtigste)
===============================================================================
**ALLE FACHFRAGEN MUESSTEN BEANTWORTET SEIN. Erscheint eine Frage offen, ist die
Erstvermutung: GEDAECHTNISLUECKE -- die Antwort existiert, sie wurde nur nicht gefunden.**

Das ist keine Vermutung, sondern die empirische Lehre dieses Tages. Der Owner musste sie
DREIMAL aussprechen, und JEDES Mal hatte er recht:
- *"Gedaechtnisluecken, es ist alles geplant und du musst bitte mit explore lesen"*
- *"Die Tags sind bereits geplant, alles Gedaechtnisluecken. Bitte explore dazu."*
- *"Die offene Frage ist eine Gedaechtnisluecke WIE IMMER. Bitte lies die Modi nach ..."*

**BILANZ:** Von 26 Fragen, die der Lead als "offen" vorgelegt hatte, waren nach dem Explore
**12 GEPLANT_UND_BEANTWORTET, 13 TEILWEISE, genau 1 ECHT_OFFEN**. Drei weitere angebliche
Fragen waren gar keine, sondern BAU-RUECKSTAND.

**VERFAHRENS-PFLICHT, die daraus folgt (bindend fuer den naechsten Kontext):**
1. VOR jeder Owner-Rueckfrage: Explore-Agent (Sonnet-5, max effort, "very thorough") ueber
   Thesis -> Ledger/Plaene nach Datum -> docs/termine -> Memory -> Code.
2. **SYNONYM-DURCHGANG ist PFLICHT.** Drei Falschbefunde an EINEM Tag entstanden, weil die
   Suchbegriffe die Plan-Terminologie verfehlten (Details Abschnitt 4).
3. Erst wenn der Explore mit NENNER + GEGENPROBE belegt, dass es keine Plan-Antwort gibt,
   ist es eine echte Owner-Frage.

===============================================================================
## 1. REFS UND STAND
===============================================================================
| Repo | development | main | zuletzt gruen |
|---|---|---|---|
| ce | `85847715` | `85847715` | Pipeline 15167 (19 success + 1 manual) |
| thesis | `8197a2c` | `8197a2c` | Pipeline 15172 (4/4) |
| super | `eb4bb2b7` (Doku) | `5ed70229` | Pipeline 15174 (14/14) + BEIDE Bridges gruen |
| cluster | `d7eab98` | -- | -- |
Die Bridges bauen jetzt den AKTUELLEN Stand (downstream 15175 auf ce `85847715`,
15176 auf thesis `8197a2c`) -- genau der Zweck des Gitlink-Bumps.
super-`main` steht bewusst einen DOKU-Commit zurueck; FF nach dessen Pipeline.

**GELANDET in diesem Kontext:** numa/core_class (beide Repo-Haelften) · R-3 Mess-Gates im
Preimage (fingerprint_format 3->4) · O-4 Thesis-Textnachzug + zwei EN-Fehlerkorrekturen ·
Gitlink-Bump aller drei Zeiger · fuenf Doku-Landungen (Owner-Vorlage, Explore-Ergebnis,
Zwischenstand, Ledger-Nachtraege, Meta-Referenzen-Register).

===============================================================================
## 2. VERWEIS-REGISTER: WO DIE BEREITS BEANTWORTETEN FRAGEN STEHEN
===============================================================================
**Diese Liste ist der Kern der Uebergabe.** Wer eine dieser Fragen erneut stellt, hat eine
Gedaechtnisluecke -- die Antwort steht an der genannten Stelle.

### 2.1 Beantwortet durch OWNER-ENTSCHEID (07.08.)
| Frage | Antwort | Fundstelle |
|---|---|---|
| D-1 PMU-Domaene: Stempel-pflichtig? | JA fuer die MESS-Zeile, NEIN fuer die Binary-Identitaet (compile-hart gesperrt) | Ledger mittag-2 §2.1 |
| B-4 Break-Even: Lager-Objekt? | NEIN -- lebt in der CEB im RAM nach Messungs-Schluss, giesst nach LaTeX/PDF/xlsx; NICHTS gekuerzt, Voll-Build | Ledger mittag-2 §2.2 |
| D-3 Bau-Menge | nur die 320er bauen, die auch gemessen werden; golden-XML darauf umstellen | Ledger mittag-2 §3 |
| O-C Pinning-Default | Pflicht bei Hybrid-Architekturen mit unterschiedlichen Kernen | Ledger mittag-2 §3 |
| O-4 Anhang A / Thesis-Text | volles GO fuer Textnachzug an den Code (ausnahmsweise Richtungs-Umkehr) | Ledger mittag-2 §3, gelandet thesis `8197a2c` |
| F-02 flat_hash_map | Option a = Textpass (Begruendung: Achsen-Steuerbarkeit) | Ledger mittag-2 §2.7 |
| Plattform-Rolle | prod1/prod2 als Pilot, ZIH-Erweiterung wird trotzdem vollzogen | Ledger mittag-2 §2.5 |
| xlsx | ist der Mess-Standard (Writer existiert noch nicht) | Ledger mittag-2 §3 |
| Thesis-Sprachrichtung | DE fuehrt IMMER, EN wird nachgezogen | Memory `feedback_thesis_deutsche_version_fuehrt_englische_nachziehen` |
| Rollen | Lead = CTO/Director; Fable-5 = Agenten-Modell, nie Director; Explore bleibt Sonnet-5-max | Memory `feedback_claude_code_arbeitsweise_v2_konsolidiert` (Rollen-Praezisierung 07.08.) |

### 2.2 Beantwortet durch den PLAN (Explore-Funde -- diese Fragen NIE wieder stellen)
| Frage | Plan-Antwort | Fundstelle |
|---|---|---|
| Welche Ausfuehrungs-Modi gibt es? | `RunMethodology` {debug, measure, release, compare}, XML-Pflicht, exactly-one | `measurement/run_methodology_registry.hpp:37-41,:74-78`; `LEDGER:3295` (Sec.61, 21.07.) |
| Wie kennzeichnet man eine Debug-Messung ("OS-Support-Build")? | der Debug-Modus IST als Verdrahtungs-Check ohne golden-Zahlen definiert | `run_methodology_registry.hpp` + Ledger mittag-2 §2.4 |
| Bauen die Modi aufeinander auf? | JA: `measure ⊂ release` woertlich | `LEDGER:3287-3291` (Sec.61-STUFEN, 21.07.) |
| T-8 "beste Binary" = Sieger oder Pareto? | PARETO-FRONT, entschieden 10.07. (einer von 7 Forks) | Ledger mittag-2 §4 |
| T-9 Min/Max-Semantik je Achse | Katalog EXISTIERT (04.08., T0..T17+, Deep-Research-gestuetzt) | Ledger mittag-2 §4 |
| T-10 Last-Erkennungsheuristik | 327-zeiliger Deep-Research-BEFUND vom 09.07. (OtterTune/QueryBot5000/Self-Driving-DBMS) | Ledger mittag-2 §4 |
| T-5 Wiederholungen | 3 (Owner-Entscheid E3, 16.07., ersetzt die 5 aus T3/T4/T6) | Explore-Ergebnis §B |
| T-1 "die Abgabe morgen" | 15.09.2026 ist der Endtermin; der 08.08. ist Zwischenziel/Wochenlieferung | Explore-Ergebnis §B |
| D-7 Core-Faktorisierung | Achsen-Dossier-Modell {Unpinned\|PCoresOnly\|ECoresOnly\|HybridAware} (Quellen-Rangfolge) | Explore-Ergebnis §B |
| Windows auf prod1/prod2? | vier Windows-VMs als eigene Runner (id53/55 prod1, id54/19 prod2), Zugang = VM | `Cluster/docs/sessions/2026-07-26-INFRA-runner-matrix-DONE.md:26-31` |
| Wo liegt SwissTable? | Genus SearchAlgorithm unter Gattung **MAP** (nicht Container) | Ledger mittag-2 §2.7 |
| D-2 Bau-Menge-Herleitung | 524.288 = 4 System-Perms x 2^17; `cap` ist wirkungslos | Explore-Ergebnis §C (durch D-3 ueberholt) |
| D-3 Mess-Teilmenge ("Weg C") | 320er tief + Vollflaeche flach ~3,1 Tage | Explore-Ergebnis §C (durch Owner-D-3 praezisiert) |
| C-4/C-5/C-6 Thesis-Posten | H2 braucht die Durchsatz-Spalte · 14 LP definiert, 10 materialisiert · ChainRef bis 28.08. | Explore-Ergebnis §B |

### 2.3 Beantwortet durch MESSUNG am Objekt (Falschbefunde, die korrigiert wurden)
| Vermeintlicher Befund | Wahrheit | Beleg |
|---|---|---|
| "Talos existiert nirgends im Code" | Talos ist ANFORDERUNG (Docker auf baremetal UND Talos), transitiv ueber buildsystem->comdare-db | Memory `feedback_build_matrix_8_docker_distros...`; Ledger mittag-2 §2.5 |
| "Anhang A: 16 von 44" bzw. "Scope 4 bedient alle 28" | BEIDE falsch -- gemessen am veralteten Separat-Klon. Real: 31 gegatet / 18 harte `\input` / 18 Dateien | Ledger mittag-2 §8.2 |
| "Gate 8 nicht gelandet" | IST gelandet -- der Agent mass gegen den Separat-Klon `29a1700` statt gegen das Submodul | Ledger mittag-2 §8.2 |
| "T-10: 0 Code, 0 Design, 0 Register" | FALSCH -- 327-Zeilen-Plan seit 09.07., gesucht wurde "Last-Erkennung" statt "Workload-Cluster" | Ledger mittag-2 §4 |
| "`cpe` existiert nicht" (17 Roh-Treffer) | die 17 sind ALLE vendored Fremdcode; als Token: 0 -- der Tag ist wirklich neu | Ledger mittag-2 §2.1 |
| "pmc:intel ist ein Rechteproblem" | NEIN -- PMU-Ressourcen-Konkurrenz; 15157 auf demselben SHA war 2 Min vorher gruen | Ledger mittag-2 §5 |

===============================================================================
## 3. WAS WIRKLICH OFFEN IST (mit vollem Kontext)
===============================================================================
Nur diese Punkte sind nach Explore-Beleg echte Owner-Entscheide. Alles andere ist
Bau-Rueckstand oder bereits beantwortet.

### O-A  Die `compare`-SEQUENZ-SPANNUNG (neu aufgeworfen 07.08.)
**Kontext:** Der Owner hat die Modi als Enthaltungs-Ordnung praezisiert:
`measure ⊂ compare ⊂ release` -- *"release beinhaltet den vorgeschalteten Modus measure und
erweitert ihn, und compare beinhaltet den Modus measure ebenfalls als Basis ... Allerdings hat
release auch den gesamten compare als Grundlage vorangestellt und erweitert diesen, aber nicht
umgekehrt."*
**Der Befund:** `measure ⊂ release` ist woertlich belegt (`LEDGER:3287-3291`, Sec.61-STUFEN,
21.07.). ABER der FORMALE Wert `run_methodology::Compare` wird in JEDER bisherigen Quelle
**NACH Release** sequenziert (`LEDGER:3343`, Sec.62-C: *"ERST ZUM SCHLUSS, NACH DEM RELEASE"*;
ebenso `run_methodology_registry.hpp:7-8`). Im Korpus existieren ZWEI Vergleichs-Konzepte:
(i) Kurven-Vergleich VOR Release (intra-Maschine, "Phase 2b"), (ii) Cross-Maschinen-
Replay-Sichten-Vergleich NACH Release.
**Warum nicht ableitbar:** Die Owner-Korrektur verschmilzt sie zum ersten Mal. Das ist eine
PRAEZISIERUNG, keine Bestaetigung von Geschriebenem -- der Lead darf nicht raten, welches der
beiden Konzepte der formale Enum-Wert kuenftig tragen soll.
**FRAGE:** Soll `run_methodology::Compare` kuenftig die VOR-Release-Auswertung SEIN (dann ist
Sec.62-C zu superseden), oder bleiben es zwei Dinge und die Staffelung meint nur den
inhaltlichen Vorlauf (dann braucht die Vor-Release-Auswertung einen eigenen Namen)?

### O-B  W-3 AKZEPTANZKRITERIUM EBENE 2
**Kontext:** Zwei Owner-Aussagen vom 06.08., **6 Minuten 53 Sekunden auseinander**, beschreiben
dieselbe Erhebungs-Ebene unterschiedlich streng: KERN 11 (Break-Even-Drei-Ebenen) verlangt
"Schritte UND Checkpoints" innerhalb der Funktion; KERN 12 (Wallclock-Drei-Ebenen) nennt ein
Zeitpaar je Funktionsaufruf.
**Warum nicht ableitbar:** "Juenger schlaegt aelter" auf sieben Minuten Abstand innerhalb
derselben Nachrichtenfolge anzuwenden waere eine Extrapolation der Projekt-Doktrin, keine
Anwendung. Beide Aussagen sind praezise und gewollt.
**FRAGE:** Welches ist das bindende ABNAHME-Kriterium fuer Ebene 2 -- Zeitpaar (milder) oder
Checkpoints (strenger)? Zielfenster laut Dossier: 21.08.

### O-C  7 vs 8 LINUX-DISTRIBUTIONEN (Gate W10-00, bereits geparkt)
**Kontext:** Owner sagte am 07.08. "alle 7"; Memory (03.07.) und `LEDGER:3364` (21.07.) sagen
**8 inkl. Ubuntu** ("die 7er-Annahme des CI-Blueprints war falsch"). Real existieren DREI
Listen: 7 Cluster-Buildtools-Images (seit Februar produktiv), 7 comdare-db-Kandidaten (selbst
als vorlaeufig markiert), und die real gefahrene 18-Image-Matrix der cache-engine
(6 Familien x 3 Versionen). Die Thesis nennt KEINE Zahl.
**Status:** im Ledger als Gate W10-00 gefuehrt und auf "NACH DER ABGABE" gebucht -- also nicht
dringend, aber die Zahl gehoert irgendwann fixiert.
**FRAGE:** Welche Liste ist die massgebliche fuer die Diplomarbeit?

### O-D  B-5 BREAK-EVEN-SCHWELLENWERTE: CT oder RT?
**Kontext:** Die CT/RT-Aufteilung ist owner-entschieden und eingefroren (E1, 02.08.): die
SCHALTLOGIK ist CT-Chain-of-Responsibility, der Binary-TAUSCH am Dock ist RT (dlopen/dlclose
ueber HybridBinaryProxy). Offen ist die engere Frage: werden die numerischen
Break-Even-SCHWELLENWERTE als Compile-Time-Konstanten einkompiliert oder zur Laufzeit aus dem
Lager gelesen?
**Warum nicht ableitbar:** Von derselben Session ausdruecklich bis nach der Abgabe offen
gelassen. Beide Wege sind mit der eingefrorenen CT/RT-Aufteilung vereinbar.

### O-E  ANHANG D: "die drei Mess-Modi existieren noch nicht als Typen"
**Kontext:** Der Thesis-Nachzug hat diese Stelle BEWUSST stehengelassen (Auflage "im Zweifel
auslassen und melden"). Sie ist gegen `run_methodology_registry.hpp` fraglich (Enum + constexpr-
Registry existieren) und zaehlt **drei** statt vier Modi.
**Warum nicht einfach zu fixen:** Die Aussage koennte sich auf die REFLEXIONS-Faehigkeit (W2-B)
beziehen, nicht auf die schlichte Typ-Existenz. Das ist eine Semantik-Frage am Text, kein
Zahlendreher.
**FRAGE/AUFTRAG:** Lead prueft die Reflexions-/W2-B-Semantik; falls es doch nur die
Typ-Existenz meint, ist es ein Textnachzug unter dem bestehenden O-4-GO.

### O-F  `cpe`-TAG-EINBAU (Bau-Auftrag, kein Entscheid -- nur die Form ist offen)
Die gebauten Werte-Token heissen `kern_uniform` / `kern_hohe_leistung` / `kern_hohe_effizienz` /
`kern_grosser_cache` / `kern_kleiner_cache`. Der Owner fuehrt `cpe` (cpu-performance-efficiency)
neu ein. **Lead-Empfehlung:** Kurzform in der Mess-Spalte, weil sie die bestehenden Token nicht
bricht. Alternativen: Ersatz der Token, oder zusaetzliches Segment.

===============================================================================
## 4. DIE VIER METHODEN-LEHREN, DIE DEN NAECHSTEN KONTEXT SCHUETZEN
===============================================================================
1. **EINE NEGATIV-SUCHE IST NUR SO GUT WIE IHR VOKABULAR.** Drei Falschbefunde an einem Tag:
   T-10 ("Last-Erkennung" statt "Workload-Cluster"), D-1 (Substanz seit 16.07. geplant, unter
   anderem Namen gesucht), beinahe `cpe` (17 Roh-Treffer, alle Fremdcode).
   **Jede "existiert nicht"-Aussage braucht (a) Synonym-Durchgang und (b) Klassifikation der
   Roh-Treffer.**
2. **ZWEI THESIS-CHECKOUTS.** `thesis/diplomarbeit` (Submodul) traegt den Stand; der Separat-Klon
   `20260931-overleaf-diplomarbeit` ist VERALTET. Zwei Plandokumente UND ein Agent haben sich
   daran verlesen. Immer am Submodul messen.
3. **GEFILTERTE WERKZEUG-AUSGABE VERSCHLUCKT DAS VERDIKT** (`tail -18` liess 4 von 5 Dateien
   fallen) -- und **Kommandos, die nicht laufen, melden trotzdem "sauber"** (ein `find` fand
   clang-format nicht; das Skript gab "leer = sauber" aus). **Jeder Selbstcheck braucht eine
   GEGENPROBE an einer bekannten Fehl-Probe.**
4. **"Offene Frage" != "Bau-Rueckstand".** Drei Posten standen faelschlich in der Owner-Vorlage.

===============================================================================
## 5. WIEDERAUFNAHME (Reihenfolge)
===============================================================================
1. **Erden:** dieses Doc -> Ledger-Nachtrag "07.08. mittag-2" (die Vollkonsolidierung) ->
   Gesamt-Dossier -> Meta-Referenzen-Register. Dann Objekt-Ist (beide Remotes fetchen,
   dev/main-SHAs, Worktree-HEADs + porcelain) und Lebend-Check.
2. **super-`main`-FF** auf den Doku-Commit `eb4bb2b7`, sobald dessen Pipeline gruen ist.
3. **Bau-Rueckstaende** (kein Entscheid noetig), nach Wirkung -- Task #35:
   T-9 Min/Max in `break_even.hpp` (HOECHSTE PRIO: sonst rechnet die Auswertung fuer jede
   Max-Achse falsch herum) -> T-8 Pareto -> T-10 Last-Erkennung -> xlsx-Writer -> `cpe`-Tag ->
   `resource_group` fuer PMC-Jobs -> Modus-Fallback fail-closed -> macOS-Off-by-one ->
   `PlanBuildSemantic::measurement_on` (Phantom) -> Sec.58-REPLAY.
4. **T1-Posten vor dem ersten Batch:** D-4 `allow_failure` · D-5 PMC fail-closed ·
   R-2 XML-Trennung Bau/Messung + Mess-Slicing 4096 · D-3-Umsetzung (golden-XML auf 320er).
5. **Owner-Entscheide** O-A..O-F aus Abschnitt 3 vorlegen -- aber NUR diese.
6. **LAUFENDER AUFTRAG beim Uebergabe-Zeitpunkt:** Workflow `wf_82d1a21f-4cc`
   (Ledger-Vollstaendigkeits-Audit: 5 Sonnet-Sucher ueber alle VIER Ledger + Historie, dann
   Fable-5-xhigh-Diff). Ergebnis abholen, pruefen, als Nachtrag landen.

===============================================================================
## 6. SICHERUNGEN
===============================================================================
- `~/backups-workflow/20260807-workflow-ergebnisse-gerettet/` -- die Endberichte ALLER neun
  Workflows dieses Kontextes (Explore-Funde, R-3-Design, Thesis-Audit, Konsistenzpruefung).
- `~/backups-workflow/20260807-PAUSE-abbruchsicher/` -- Patch-Buendel der frueheren Pause.
- `refs/rescue/20260807-numa-luecken-f138ec41` und `refs/rescue/20260807-v8-e04-p1-verwaist`
  (zwei verwaiste E04-P1-Commits, lagen auf 0 Remotes) -- beide Remotes.
- Meta-Referenzen-Register: `docs/sessions/20260807-META-REFERENZEN-register.md`
  (155 Dateien / 337 Fundstellen).
