## Quellenlage vorab

- Die zehn Session-Docs mit Datum **20260722/20260723** enthalten **keine** woertlichen User-Saetze zu Lock/Reservierung/Bestandslog — sie sind Manager-Zusammenfassungen (Ledger-Kurzzeiger §62-B P1–P4, §65, §66, G4a-Punkt 5 `planer_block`). Die einzigen woertlichen User-Fragmente dort sind Prozess-GOs.
- Alle woertlichen Architektur-Direktiven stehen in den **Transkript-Extrakten**. Relevante Treffer-Dateien: `37-transkript-24`, `35-transkript-26`, `34-transkript-27`, `38-transkript-28`, `36-transkript-29`, `33-transkript-30`.

---

## Chronologische Liste der User-Saetze (wortgenau)

### A. REALMS (CEB-Realm vs. Tier-Realm) — ~20.07.

**A1** — Quelle: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/37-transkript-24-a0020951.md:74` (§57, "USER-DIREKTIVE woertlich, bindend")
> "Hinweis: tier-chunk buendelt System-Achsen-Freigabedurchfuehrungsraum-chunk und Organ-Achsen-Chunk. weil der ceb-chunk hat selbst das Buendel System-Achsen-Freigabeerlaubnis-chunk und Organ-Achsen-tobecompiled-chunk. Bei der ceb ist die Systemachse und Organachse noch runtime und die Mess-Achse fest einkompiliert (bis auf Variablen des Planers ueber dynamische Unter-Achsen) und die ceb baut zu ihrer Laufzeit die compile-time Tier-Binaries auf, welche dann den System-Achse x Organ-Achse Typ- und Versions-Stempel erhalten. Die ceb hat ihren eigenen Typ- und Versionsstempel ueber die Mess-Achse des Planers"

**A2** — Quelle: gleiche Datei, `:82` (User-Bestaetigung, woertlich)
> "Ja jetzt hast du es korrekt verstanden, du hattest bald aus der Tier-Binary nur einen chunk repraesentiert ohne die System-Achse dort von der Organ-Achse fest einkompiliert zu trennen. Weiterhin haettest du nicht korrekt zwischen ceb realm und Tier-Binary realm unterschieden und jetzt passt es perfekt"

*Einordnung: das ist die einzige Stelle, an der der User selbst das Wort "realm" gebraucht (CEB-Realm / Tier-Binary-Realm).*

---

### B. URSPRUNG LOCK + RESERVIERUNG (§62 Cache-Log-Claim) — 21.07.

**B1 — Compile-Log im Cache, gelockt, Erst-Zugriff bestimmt Batch** — Quelle: `.../ergebnisse/35-transkript-26-a1cb3ef5.md:139` (PHASE 6, "User-Klarstellung (tragend, woertlich-Kern)")
> "…wir sehen den Wald vor lauter Bäumen nicht, weil wir die Maschinen-Eigenschaften per CI runner vorfiltern, welche eigentlich keine Rolle spielen sollten, weil der Planer alles verfügbare misst, was in der XML verlangt wurde und er muss überall bauen können. Wenn wir in der XML Achsen verlangen, die physisch als System-Achsen Algorithmen nicht existieren (wie AVX512-Flags), dann schreibt der Planer Warnungen entweder ins log oder auch auf seine spätere CLI shell. … Bezüglich der Kompilation müssen sich aber die Maschinen auf der CI absprechen, welche Binaries es im cache auf minio.comdare.de schon gibt und welche Kombination sie Verantworten. Dazu sollten wir ein Compile-Log in den Cache lesen, das gelockt werden kann, wer zuerst zugreift, bestimmt den ersten Batch über eine lazy Auflistung der Permutation aller Achsen… Zu den drei Modi: Debug, Messung und Release laufen JE MASCHINE einzeln und erst zum Schluss nach dem Release gibt es je Maschine den noch weiter erweiterten COMPARE Modus… Alle drei Optionen sind nicht getrennt sondern vereinbar und Pflicht. Es gibt derzeit keine experiment_gold.xml die gilt, du musst sie per neuer Syntax von Grund auf neu entwickeln und stets pflegen. Bitte lösche alle alten Mess-csv. Remote branches nur löschen, wenn gemerged, sonst behalten. Welche Entscheidungen stehen nach dieser Klarstellung an?"

**B2 — Sync-Datei, Batch-Reservierung mit Aufhebe-Pflicht** — Quelle: gleiche Datei, `:141`
> "…jede Maschine, die lokal oder per CI baut und an den minio.comdare.de cache angeschlossen ist, [verhält] sich Teamfähig über eine sync Datei…, bereits gebaute Tier-Binaries, CEB oder Planer nicht erneut baut und… batches von zu bauenden Binaries reserviert und verspricht (also zwingend bei Beendigung des Programmes immer die Reservierung aufheben und Fortschritt klarstellen muss je build) und immer aus der eigenen Sicht handelt… Das bedeutet die CI ist erst fertig, wenn die XML auf allen von mir gewünschten Maschinen, je Maschine ausgewertet wurde exakt für diese eine Maschine."

**B3 — Teilen/Replay der Bestaende (Schluessel-Semantik)** — Quelle: gleiche Datei, `:143`
> "Volles go nach deinen Empfehlungen für alle Punkte die du aufgeführt hattest. … Die Perspektive kann nur bei einer identischen (Hardware-technisch) Maschine gleich sein, welche dann ebenfalls befugt ist, die Messungen einer anderen Maschine als replay wiederzuverwenden. Die Binaries werden je nach Stempel grundsätzlich geteilt zwischen ALLEN Maschinen, sofern sie passen. …"

**B4 — Batch-Job-Prinzip statt Einzel-Jobs** — Quelle: gleiche Datei, `:151`
> "Hinweis: Weil es 130.000 Tier-Binaries geben wird, die zu verwalten sind, werden hierfür keine Einzel-Jobs angelegt, sondern die Kompilation der Tier-Binaries läuft unter einem gesammelten Job, der die CEB für den Build verwendet. Würden wir für 130.000 jobs je Pipeline die logs mitschneiden, würde das gitlab killen. Daher die build-Jobs für Grandchild Tier-Binary/Hybrid in einem batch, sowie auch die Messung über alle Tier-Binaries in einem Batch, das ich in EINEM Job log verfolgen kann."

---

### C. DIE FUENF BESTANDSLOG-PRAEZISIERUNGEN (§62-B P1–P4 + ETA-Korrektur) — 21./22.07.

Quelle durchgaengig: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/34-transkript-27-afa04181.md`

**C0 — D1, CEB-interner Batch + Pruefstand + Planer-Instrumentierung** (`:10`, Z.21, woertlich)
> "Wir müssen den letzten Punkt noch präzisieren, weil die CEB ja die builds und Messung der Tier-Binaries übernimmt. Wie folgt: Die Tier-binaries werden per runtime batch auf der CEB gebaut und dann direkt am Prüfdock über den Aufruf von google Tests als Prüfstand auf alle Funktionen getestet, ob sie per Interface korrekt funktionieren (beachte kompilationsstatus der CEB welche Prüf-Tools einkompiliert sind und welche dann auch das Tier-Binary beinhalten muss). Bedeutet der Batch geht nicht über shell, sondern CEB intern als eigenes Feature der CEB durch. Die CEB piped dann die shell Ausgaben des Status an den Planer weiter, der ja schließlich die emittet CEB aufruft und steuert. Das bedeutet, dass eigentlich der Planer aufgerufen wird, die CEB per XML-Anweisung zu instrumentieren, um mit ihr batches von Tier-Binaries zu bauen und zu testen, ob sie für die spätere Messung taugen (erst build+prüf Batch und nach Durchlauf erst die Messung)"

**C1 — D12 PRAEZISIERUNG-1: versioniertes+gelocktes Bestandsdokument, 4096er-Batches, ETA, 50%-Takeover, 30-min-Reservierung, "Done"** (`:34`, Z.1649, bindend)
> "…die ccache Binaries möglicherweise über ein versioniertes und gelocktes Bestandsdokument eingelagert werden sollten, weiterhin benötigen CEBs über dieses Dokument Absprachen, wie sie sich die Batches aufteilen, damit auch Binaries, die beide Maschinen verarbeiten können, gleichverteilt auf beiden Maschinen kompiliert werden. Sonst blockt die eine Maschine den Fortschritt komplett… Die Batches sollten also stets 4096 Binaries enthalten, die eine CEB aufnimmt und reserviert mit Zeitstempel. Die CEB muss dann die durchschnittliche compile Zeit berechnen und ETA im ccache Bestands-Log festhalten. Wird das ETA um 50% ohne update überschritten, können andere Maschinen davon ausgehen, dass die Pipeline der anderen Maschine gestorben ist und sie nehmen die Arbeit stattdessen auf… Weiterhin muss der ccache Bestand neu inventarisiert werden, wenn das Log gelöscht wird oder durch Code Änderung der Planer und CEB durch eine neue Version ersetzt werden muss. Das Bestandslog hat eine eigene Versionsnummer im header für Syntax und Semantik und ist im Kern ebenfalls ein XML… Das ETA der Kompilation… wird durch die ersten 10 erfolgreichen compiles der CEB über die Tier-Binaries geschätzt… wofür zuerst 30 Minuten reserviert werden… Ein Planer blockt einen Compile einer CEB direkt im Log ohne ETA mit einer Reservierung von 30 Minuten für diese Version. Alle Reservierungen und ETA werden im Log nach Fertigstellung eines Batches aufgehoben. und mit 'Done' gekennzeichnet. Die Reservierungen decken dabei compile+prüf der CEB und den compile der CEB durch Planer als Strategy pattern für caching ab."

*Einordnung: hier steht die Keimzelle von `planer_block` — "Ein Planer blockt einen Compile einer CEB direkt im Log ohne ETA mit einer Reservierung von 30 Minuten für diese Version."*

**C2 — D13 PRAEZISIERUNG-2: Factory Pattern, ZWEI Bestaende (Binaries + Messergebnisse), constexpr-SHA512-Stempelzeile** (`:38`, Z.1674, woertlich)
> "Das beschriebene System gilt separat als factory pattern für batch-compile-prüf und für Messung, die beide ein separates Bestandslog führen. Es gibt also einen Bestand an binaries und einen Bestand an Messergebnissen. Jeder Bestand hat je seine Strategie, um über Stempel identifizierbar zu sein. Für die Binaries wünsche ich mir weiterhin, dass es eine constexpr Funktion als separates Versionierungsinterface auf jedem CEB und Tier-Binary gibt, welches einen SHA512 über die String-Arrays der bisher existierenden Stempel-Zeilen bildet, sodass ein lookup mapping über std::map mit SHA512 keys und Binary-/Messwertpfad aus sicht einer suchenden CEB, effizient auffindbar wird… Also bekommen alle binaries zusätzlich eine WEITERE Stempel Zeile mit dem Fingerprint SHA512 über ihre Eigenschaften, sodass er zur compile time berechnet ist und nicht mehr ständig zur Laufzeit berechnet werden muss."

*Einordnung: das ist die einzige woertliche Stelle zum Mess-Bestand ("Bestand an Messergebnissen", eigene Stempel-Strategie, Messwertpfad im std::map-Lookup) — also Bestandslog-Pflege auch auf der Mess-Seite.*

**C3 — D14 PRAEZISIERUNG-3: Schreib-Lock** (`:41`, Z.1689, woertlich)
> "das Bestandslog wird beim Schreibvorgang einer Maschine gelockt, zum Beispiel auch wenn ETA errechnet werden soll. Das lock für Schreiben eines Bestandslogs, endet mit der ersten pro forma 30 Minuten Reservierung spätestens"

**C4 — D15 PRAEZISIERUNG-4: Multi-Write waehrend Compile, Batch-Typen-Sequenz, Thread-Budgets** (`:44`, Z.1699, woertlich)
> "…sobald für das Bestandslog kompiliert wird, ist das Bestandslog multi-write freigegeben, es werden dann nur die Vorgänge registrieren und das Schreiben beschränkt sich auf die Eintragung der Reservierung der Maschine (nur millisekunden). Das heißt der haupt blocker ist ETA Berechnung. Die ETA Berechnung wird für jeden compile-Batch-Block wiederholt und Batch-Typen zwischen CEB compile und Tier-Binaries auf der selben Maschine nie gemischt, sie laufen sequentiell auf derselben Maschine. Weiterhin hat prod1 32 Threads und 24 Kerne und prod2 hat 24 Threads und 16 Kerne, die für batch compile zur verfügung stehen, aber alle Threads dürfen nur je einzelnen batch compile voll ausgeschöpft werden… Also maximale Kerne voraus für CEB batch compile und Planer CEB compile"

**C5 — D16 PRAEZISIERUNG-5: ETA-Korrektur (ersetzt die 10-Compile-Regel aus D12)** (`:48`, Z.1798, woertlich)
> "…dass das ETA nicht über die ersten 10 compiles, sondern über die Maximale Dauer einer Anzahl von compiles, die der maximalen CPU Thread Zahl entspricht. Wenn dieses Mini-Batch einer voll-parallel-Sequenz eine Zeit liefert, können wir davon ausgehen, dass dies die Zeit ist, welche die Maschine je max-Threads paralleler builds wirklich braucht. Das ETA wird berechnet durch die Summe aller Zeiten der jeweils (Zeit je parallelem compile Vorgang geteilt durch die Anzahl der Gesamtthreads). Werden nicht alle threads voll, gilt die Regel weiterhin, indem die Formel nachweislich die einzelne compile Zeit heruntermoduliert. Die Compile Zeit ist aber immer mindestens die maximale Einzel-Zeit eines voll-parallelen Batch Satzes"

---

### D. "LAGERHALTUNG" ALS BEGRIFF — 22.07.

**D1** — Quelle: `.../ergebnisse/38-transkript-28-ae354b36.md:52` (A16, "WOERTLICH")
> "Bitte lies den session log des letzten Kontextes, denn dort habe ich für ledger und Pläne untd TODOs genau beschrieben, wie sich der ccache über »Lagerhaltung« seine Zeit zurückverdienen kann, aber dazu müssen wir alles in der aktuellen Reihenfolge gründlich ohne Umwege implementieren. Aufgrund der batch Größe verdienen sich Gründlichkeit und saubere Architektur viel eher, als ein verfrühter Start - genau wie du sagst."

---

### E. LAGERHALTUNGS-PRAEZISIERUNGEN + GATE-UMKEHR — 23.07.

Quelle durchgaengig: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/backups/20260726-kontext-neugruendung-workflow/ergebnisse/36-transkript-29-aa3e2f83.md`

**E1 — Slice-Log-Sichtbarkeit** (`:13`, Punkt 5)
> "Schade ist nur, dass der Job nicht alle paar Builds (der Anzahl der maximal verfügbaren Threads der CPU) in den job Log schreibt, wie viele compiles von einem 4096 batch schon abgeschlossen sind. Wir lassen es jetzt so durchlaufen und fixen das erst wenn die gesamte Pipline grün ist"

**E2 — RAM-Puffer / avg_size als zweiter Bestandslog-Wert** (`:14`, Punkt 6; Extrakt gibt Teilzitate)
> avg_size als zweiter Bestandslog-Wert neben ETA; „maximal 256MB im RAM zu cachen"; „zurückstreamen von bereits kompilierten binaries über einen zweiten Thread an ccache … am besten nach IO_u-ring -> web recherche"; „io_uring wird auf Windows nicht unterstützt, aber wir müssen die dokumentieren OS alle unterstützen."

**E3 — Cancel-GO mit Nachweispflicht + Lagerhaltungs-Praezisierung (Einzel-Erkennung, async Batch-Planung, Slice-Queue)** (`:16`, Punkt 8)
> "Bitte unterbreche den build, **sofern du nachweisen kannst**, dass die Intel Maschine unter ihren Möglichkeiten arbeitet **und mindestens das erste Batch erledigt hat**. Die gespeicherten Builds werden zu Beginn eines Batches korrekt erkennt und nur fehlende gebaut? … Für die Lagerhaltung wird **jedes fehlende Binary einzeln erkannt und nicht als gesamt-Batch**. Die Konsolidierung und Batch Planung erfolgt zu Beginn **vor dem ETA und async über alle Binaries**, der Start läuft an sobald das erste Batch zusammengestellt ist, aber die Zusammenstellung aller Batches … wird über ALLE Einzeljobs im Hintergrund fertiggestellt und **eine queue an batch slices erzeugt**, die abgearbeitet wird."
> + stehende Direktive: "alles erdenkliche was wir haben in der CI und Lagerhaltung vorzuziehen und zu implementieren, damit sich die Gesamt Zeit verringert"

**E4 — Storage-Doktrin-Ruege (lokaler Fussabdruck gegen null)** (`:23`, Punkt 15)
> "Bitte räume dann auch mal prod1 auf … Warum ist da so viel Platz belegt? Und der Matrix forecast sollte doch immer auf ccache für die binaries und auf **PR4100 Cluster_NFS experiment-ordner** immer die Messergebnisse geschrieben werden? Der forecast auf der Maschine selbst sollte daher **gegen null gehen**, da stimmt das Plan Verständnis nicht (steht alles im Diplomarbeit-TODO und Ledger, hast du das gelesen?)"

**E5 — Pruning vor der Abgabe + Binary-Verlust-Risiko** (`:24`, Punkt 16)
> "OK, dann müssen wir für die Lagerhaltung **VOR der Abgabe noch Pruning einführen**. Du hast das TODO Board noch nicht wieder hergestellt. Es gab einen Haufen Aufgaben in der CI, die erledigt werden müssen, bevor der Build nochmal starten kann, **sonst riskieren wir Binary-Verlust** und müssen bei Fehlern nochmal neu bauen, was wir uns nicht leisten können. Wo stehen wir im gesamten Projekt? Bitte lies die stehenden Direktiven und handle danach"

**E6 — GATE-UMKEHR (Lagerhaltung + Stempel = Gate fuer Voll-Build)** (`:27`, Punkt 19)
> "Wir ziehen alle Punkte, die mit Lagerhaltung zu tun haben, nach vorn und erledigen sie als nächstes, vor dem voll build (betrachte alles was die Lagerhaltung und Stempel angeht als gate für voll build)"

**E7 — Frist-Entlastung / Begruendung der Gate-Umkehr** (`:28`, Punkt 20)
> "ja ich weiß dass das länger dauert wenn wir es gründlich implementieren, aber das **Risiko des Scheiterns ohne Wiederaufnahme ist zu groß**, wir sind gezwungen die Lagerhaltungs-Punkte nach vorn zu ziehen und **möglichst parallelisiert** zu entwickeln. Dann sind Fehler bei der Messung abfangbar und überhaupt verkraftbar. Ich werde eine Erklärung finden, wie ich möglichen Verzug begründe, es ist ja noch nicht die End-Abgabe wo alle Aufgaben in der aktuellen Gründlichkeit erledigt sein müssen."

---

### F. MAPPING-REINHEIT (beruehrt Bestandslog-Konsum) — 23.07. spaet

**F1** — Quelle: `.../ergebnisse/33-transkript-30-a3cf7e64.md:20` (U5, "§66-NACHTRAG-3 KERN = Gesetz, hoechste Bindung")
> "Ok, aber ich möchte festhalten, dass std::variant in CEB und Tier-Binaries strikt verboten ist, weil es eine runtime Variable auf ein compile-time Ziel mappt und das bloated das binary. Der Compile muss also wirklich compile time sauber sein (compile time -> compile time mapping) und es werden auch nur runtime -> runtime Abbildungen akzeptiert. Ansonsten sind verschiedene runtime Varianten der Unter-Achsen auf dieselben compile time Haupt-Achsen erlaubt. Ansonsten ist das richtig, wie du entschieden hast: die Registry entscheidet wie das zu bauen ist, um schlanke und effiziente Binaries zu erzeugen. Weiterhin sind alle Achsen immer getrennt zu behandeln und zu klammern. Das kannst du gerne noch umsetzen, dann möchte ich gerne eine Pause einlegen."

---

## `planer_block` — Befund

**Es gibt keinen woertlichen User-Satz mit dem Term `planer_block`.** Der Term ist die Implementierungs-Benennung der User-Regel aus **C1** ("Ein Planer blockt einen Compile einer CEB direkt im Log ohne ETA mit einer Reservierung von 30 Minuten für diese Version"). Belegstellen sind Manager-/Agenten-Text:

- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260723-SESSION-PAUSE-HANDOVER-netzwechsel-3.md` §4, Punkt (5): "planer_block-Reservierung (Integrations-Doc I2-Restpunkt)" — als G4a-Auflage gelistet.
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260723-SESSION-nachmittag-lager-gate-bau.md` §3: "G4a EINE Director-Scheibe (… + planer_block)".
- `.../ergebnisse/33-transkript-30-a3cf7e64.md:76` (E12, Manager-Entscheid, kein User-Zitat): `planer_block`-Reservierung **nicht** im Director; gebaut wurde die Wert-Haelfte `make_planer_block_reservation(...)` (typ=planer_block, slice 0/0, status=offen, uhrfrei); Host-Schreibaufruf = eigene Scheibe **G4b**.
- `.../ergebnisse/33-transkript-30-a3cf7e64.md:141`: G4b im Gate-Restweg mit Auflagen L1 (PromiseGuard-Terminalitaet) + L2 (stabile id `owner_uuid + "/plan/" + doc`).

## Weitere Nicht-User-Verankerungen (nur Zeiger, keine Zitate)

- Ledger-Kurzfassung der P1–P4 in `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260722-SESSION-PAUSE-HANDOVER-netzwechsel.md` §5 und `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260722-SESSION-REIHENFOLGE-UPDATE-praezisierungen.md` (Abschnitt "DANACH", #46b).
- Umsetzungsstand B1–B7/I1/I1b/I1c in `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260723-SESSION-nachmittag-lager-gate-bau.md` §1 (u. a. "B2 Lock/Union-Merge", "B4 Lifecycle/ETA/Takeover", "B5 Batch-Planer/Slice-Queue", "B6 RAM-Spool 256MB").
- §62-Nachtrag-4 (Lager-Schluessel-Luecke, Zell-Koordinaten im `BestandEintrag`) = Manager/Agenten-Befund, `.../ergebnisse/33-transkript-30-a3cf7e64.md:66`.