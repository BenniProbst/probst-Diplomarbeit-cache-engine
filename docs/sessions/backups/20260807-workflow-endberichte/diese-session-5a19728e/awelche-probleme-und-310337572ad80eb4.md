# awelche-probleme-und-310337572ad80eb4 (tx=12KB tools=0)

Aufgabe: Auflisten, welche Probleme und Falschimplementierungen sich **erneut** ergeben haben.

## Wiederkehrende Fehlerklassen — dieselbe Falle, neuer Ort

**Das harte Literal 64 statt der Achse.** Genau der Defekt, den B14-NB3 heilen sollte, steckt eine Ebene weiter: Der CLU-Konsument (`system_axis.hpp:336`) rechnet `cache_lines * 64`, während der Zähler jetzt in Achsen-Linien zählt. Unter KF-6 ergäbe das 8/16/33/66 Prozent statt durchgängig ~16. **Die Heilung selbst erzeugt die neue Falschmessung.** Zwei weitere Fundstellen derselben Klasse: `node_width_config.hpp:54` (Default-64 in der Cacheline-Achse selbst) und `measure.hpp:38` (zweiter CLU-Zähler mit Literal 64).

**Der stille Fallback, gegen den man selbst argumentiert hat.** Die Scan-Seite vermeidet `line_bytes_of<>` ausdrücklich mit der Begründung, dessen Fallback falle still auf 64 zurück — die Observer-Seite nimmt im **selben Commit** genau diese Stufe (`axis_05_memory_layout_observable.hpp:142`).

**Wachen, die nur Existenz prüfen statt Werte.** Der Anti-Divergenz-`static_assert` ist tautologisch; der Wrapper-Audit besteht auch, wenn ein Wrapper 32 meldet, während seine innere Strategie mit 256 scannt.

**Grüne Tests zementieren die falsche Ordnung — diesmal in umgekehrter Richtung.** Die neue Wache pinnt 1536/768/384/192 als Soll und macht damit die neue Einheit „richtig", ohne den Konsumenten mitzuziehen, der sie widerlegt.

**Der `.tmp`-Pfad ohne Prozess-Kennung** — dieselbe Klasse wie im E18-SNAP-Kanal am Vormittag, jetzt im Batch-Planer (45 Fehlschläge bei 8 Schreibern).

**Der doppelt gelesene Wert statt einmal gebunden.** Der Fingerprint-Provider wird an zwei Stellen unabhängig aufgerufen (Gate vs. Stamp) — identisch zum „Lesepunkt im toten Winkel" der F4-Bilanz.

**Regex statt echtem Parser** — die Wurzel aller sechs Codex-Befunde an den CMake-Wachen; die Lösung (xmllint) hat als Nebenwirkung eine neue Klasse geöffnet: `--nonet` blockt das Netz, aber **nicht** das lokale Dateisystem (XXE-Kanarienvogel wurde vom Review real ausgelesen).

## Falschimplementierungen im engeren Sinn

- **Zähler bindet nicht an die Indexfolge** — zwei Selektionen gleicher Geometrie akzeptieren denselben Alt-Zähler; still falsch fortsetzen statt scheitern.
- **Bau-Zähler wird vor dem Cache-Push-Drain geschrieben** — behauptet Arbeit, deren Artefakte nicht persistent liegen.
- **Mess-Zähler ist kein Präfix**: bei `[Fehler, Erfolg, Erfolg]` steht „gemessen=2", gedecktes Präfix ist null.
- **Bau-Zähler umgeht `dll_is_current`** — zweite Resume-Autorität, unabhängig vom Fingerprint.
- **Zwei widersprüchliche Fortschritts-Wahrheiten**: Der Status-Leser ignoriert den Resume-Präfix und wertet einen alten v5-Stamp als „gemessen".
- **Fehlgeschlagenes Plan-Schreiben deaktiviert den Resume nicht** — die Warnung im Code wird technisch nicht erzwungen.
- **Abrundung nur einseitig** — die Bilanz kann „gemessen > kompiliert" zeigen.
- **F1-Ordner-Spiegel fehlte im Experiment-Zwilling**, obwohl die Kommentare „Spiegel" beanspruchten — Zellen überschrieben sich gegenseitig.
- **Zwei Ausnahme-Sicherheits-Lecks** in denselben drei Pfaden; das zweite wurde mit einer Begründung zurückgestellt, die der Review widerlegt.
- **Ausnahme-Flag prüft nicht, was es deckt**: Der Verriegelungs-Test bestätigt nur „roh scheitert, kommentarfrei läuft" — eine falsch platzierte XML-Deklaration wird als Kommentar-Defekt durchgewinkt, die Ausnahme zöge sich nie zurück.

## Bestandsfehler, die niemandem aufgefallen waren

- **`all_axes_golden.profile.xml` ist nicht wohlgeformt** (doppelte Bindestriche in drei Kommentaren) — die alte Regex-Wache lief darauf grün.
- **Neun Tests laufen in keinem CI-Job** — und das war **schon einmal manuell behoben** (21 Tests am 13.07.) und zurückgekehrt.
- **`contract:axis-version-lock` doppelt definiert** — der scheinbar aktive Tripwire ist de facto aus.
- **`seg_attribution.tex` seit Landung nicht kompilierbar**; **`axis_inventory.tex`** wird geschrieben, aber nirgends eingebunden.
- **Latenter OOB-Pfad**: `ComposedStore`/`NodeChunkedStore` reichen 16-Byte-Records an einen Scan mit 64-Byte-Stride.

## Prozess-Ebene

Die **A-Liste fiel aus der Konsolidierung**, während die B-Liste derselben Quelle übernommen wurde — und der Posten, der genau diese Übertragung anmahnte (A15), war selbst der Verlust. **Die Ledger-Zeile mit den Achsen-Zahlen im Thesis-Text** („neunzehn Achsen") widerspricht an sieben Stellen dem Kanon von 18.
