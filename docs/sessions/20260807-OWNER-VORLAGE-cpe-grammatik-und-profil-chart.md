# OWNER-VORLAGE 07.08.2026 mittags — drei Entscheide, die wirklich offen sind

**Stand:** super `081382f0`, ce `cea98330`, thesis `47018e7`. Alle Pipelines grün.
**Vorlauf:** Fünf Entscheide der Vormittagsrunde (O-A, O-B, O-C, O-E, O-F) sind gebucht.
Was hier steht, ist **nicht** nachgefragt, weil ich es vergessen hätte — es ist das, was
nach dem Explore **wirklich noch keine Antwort im Korpus hat**.

---

## 1. `cpe` ist NEU — nicht vergessen, sondern nie geplant

Du sagtest: *"Die Tags sind bereits geplant, alles Gedächtnislücken."*
Ich habe das mit einem Explore über **alle vier Quellenstufen** (Thesis, Ledger, Pläne, Code)
prüfen lassen, mit Synonym-Durchgang, Nenner und Gegenprobe. Ergebnis, ehrlich:

**`cpe` kommt in keiner Quelle vor. Auch keine Vorsehung für mehrstellige Flags.**

Im Gegenteil — die **Ein-Zeichen-Regel ist dreifach ratifiziert**, und die dritte Stelle ist
die Thesis selbst (Quellrang 1):

> *"Das Hardware-Flag ist genau EIN Kleinbuchstabe, direkt an das Zahlen-Tripel angehängt."*

Drei unabhängige Strukturbeweise am Code:

1. `hardware_flag_from_char(char)` nimmt `char` — Singular, nicht `string_view`.
2. Die Stempel-POD-Kodierung nutzt **exakt 2 Bit = 4 Werte** — deckungsgleich mit c/g/f/n.
3. Es gibt **explizite Negativ-Tests**, die ein zweites Zeichen hart abweisen:
   `v1.0.0cc`, `v1.0.0cg` → Sentinel; `a=x@1.0.0cg` → **consteval throw**, mit dem Kommentar
   *"zweites Hardware-Flag: unparsbarer Rest, kein stiller Sentinel-Kollaps"*.

Bissbeweis durch Ausführung gegen den heutigen Parser:

```
v1.0.0c    -> hw=cpu exp=0        ok
v1.0.0ce   -> hw=cpu exp=1        'e' == EXPERIMENTAL
v1.0.0cp   -> SENTINEL
v1.0.0cpe  -> SENTINEL            wird heute abgelehnt
```

### Die Kollision ist strukturell, nicht kosmetisch

Die Position hinter dem Hardware-Flag ist durch `'e'` (experimental, dein Entscheid E2 vom
02.08.) **vollständig belegt**. Und die B12-Wache *"ce-Registry trägt NIE 'e'"* ist bindend.
`cpe` endet auf `e` — die Grammatik kann nicht beides, solange `e` Suffix **und**
Flag-Buchstabe ist.

### Was ich brauche

**Frage 1a — wie trennen wir die beiden `e`?**
- **(a) Trennzeichen** einführen, z.B. `v1.0.0c-pe` oder `v1.0.0c.pe`. Flag-String und
  experimental bleiben eindeutig, alle 138 Bestands-Literale bleiben gültig.
  *Meine Empfehlung* — billigster Schnitt, keine Mehrdeutigkeit.
- **(b) Reihenfolge umdrehen**: erst `e`, dann der Flag-String (`v1.0.0ecpe`). Bricht die
  seit 02.08. fixierte Reihenfolge und liest sich schlecht.
- **(c) `e`-experimental ganz aufgeben** und die Position vollständig dem Hardware-String
  geben. Die B12-Wache verbietet `e` an ce-eigenen Versionen ohnehin — der Verlust wäre
  klein, aber es ist ein Rückbau deines E2-Entscheids.

**Frage 1b — ist `cpe` Pflicht oder optional?**
Wenn Pflicht, müssen **138 Bestands-Literale** migriert werden (122 Organ-Achsen + 3 System +
1 Meta-Meta + 3 Mess-Tooling + 1 Mess-Framework + 1 Planer + 2 Probe + 5 Prüf-Dock).
Nach der etablierten Doktrin: **ein gebündeltes Byte-Ereignis, kein zweiter Neuanker**.
Wenn optional, bleibt `v1.0.0c` gültig und nur P/E-fähige Algorithmen tragen `cpe`.

**Frage 1c — welche Buchstaben gehören ins Spezifikations-Alphabet?**
Du nanntest `p` (performance) und `e` (efficiency). Kommen weitere (z.B. `v` für Vektor/SIMD,
das heute als eigene System-Achse `simd_extension` lebt)?

### Entlastung, damit die Kostenfrage klar ist

Das POD-`reserved`-Feld ist ein `uint32_t`, von dem heute nur **6 von 32 Bit** belegt sind.
Eine breitere Flag-Kodierung bricht **nicht** zwingend den `sizeof==48` des Entry-PODs.
Es bleibt ein deklariertes Byte-Ereignis mit neuer CT-Wachen-Batterie — aber kein ABI-Bruch.

### Eine Lücke daneben, die dein Satz aufgedeckt hat

Du sagtest: *"Jeder Buchstabe steht für eine unterstützte Hardware-Art, die durch die
Systemachse freigegeben wurde an die Tier-Binary."*

Diese Freigabe-Kette ist **als Muster gebaut — aber an der falschen Achse**:
`TargetIsaSystemAxis` gibt die **Ziel-ISA** frei (x86_64/arm64/riscv64), wörtlich
*"TargetIsa gibt die Ziel-ISA frei, Host-Gate prüft Lauffähigkeit"*.
Für die **Hardware-FAMILIE** (CPU/GPU/FPGA/NPU) gibt es heute nur eine **globale** Politik
("wir produzieren nur CPU-Code"), keinen differenzierenden Mechanismus. `g`/`f`/`n` sind
laut Code-Kommentar *"reserviert, nicht produziert"* — null echte Bestands-Literale.

Das heißt: die von dir beschriebene Kette muss für die Hardware-Familie **erst gebaut**
werden. Sie ist nicht vergessen, sie existiert an einer Nachbarachse.

---

## 2. Die Brücke Profil → xlsx fehlt vollständig

Du sagtest: *"Das Profil wird je Mess-Layer aufgezeichnet und in einem zeitlich orientierten
chart als Profil abgespeichert, der formal als xlsx Messwerte gilt."*

Die drei Bausteine existieren einzeln, **ihre Verschränkung nirgends**:

| Baustein | Stand |
|---|---|
| xlsx als Lagerformat | gebaut — aber als **Zeile-pro-Messergebnis**-Tabelle je Unter-Achsen-Permutation |
| Drei/Vier-Ebenen-Konzept | vollständig geplant |
| Korrelierte Zeitreihe | Mechanismus geplant, **teilweise** gebaut (Füllstands-Trace mit `observe_wall_ns`) |

Was fehlt, ist belegt und nicht geraten:
- Das 06.08.-Dossier sagt ausdrücklich: *"Es gibt keine Datenstruktur namens Chart/Diagramm
  im Mess-Kern... weder Writer noch Schema"*.
- Eine Zeitnahme **innerhalb** eines Funktionsaufrufs existiert nicht — 0 Treffer für sieben
  Namensmuster, Gegenprobe `seg_ns` = 326 Treffer, die Suche greift also.
- Die vorhandenen `fill_checkpoints{10,100,1000}` sind **Füllstands**-Stützpunkte einer
  Datenmengen-Kurve, **keine Ausführungs-Checkpoints**.
- Die a9-xlsx-Akte nennt weder Checkpoints noch `seg_ns` noch den vierten Observer-Layer und
  enthält keine nativen Excel-Chart-Objekte (obwohl die vendorte libxlsxwriter das könnte).

**Frage 2 — wie sieht das Blatt aus?**
- **(a) Ein Sheet je Mess-Layer**, Zeilen = Checkpoints in Zeitreihenfolge, Spalten = die
  Achsen-Messwerte an diesem Checkpoint. Zeit als erste Spalte (`observe_wall_ns` relativ
  zum Trace-Start). *Meine Empfehlung* — passt zur bestehenden Sheet-Schlüssel-Logik.
- **(b) Ein Sheet je Funktionsaufruf** — feiner, aber bei 2^17 Zellen unbrauchbar viele Blätter.
- **(c) Ein Sheet, Zeitreihe lang (long format)** mit Layer als Spalte — kompakt, aber die
  Charts müssten per Filter gebaut werden.

Und: sollen **native Excel-Charts** eingebettet werden (libxlsxwriter kann es), oder reichen
die Zahlen und du baust die Diagramme in der Thesis aus den Daten?

---

## 3. Was ich falsch gemacht habe (nicht versteckt)

Zwei eigene Arbeitsfehler in einem einzigen Pass — beide gebucht, beide mit Lehre:

**Erstens** habe ich in Task #8 eine Entlastung geführt (*"V-08 misst real
(L1/L3/branch_misses)"*), die ich aus einem Reconcile-Bericht **ungeprüft übernommen** hatte.

**Zweitens** — und das ist der schlimmere — bin ich beim Nachmessen in die **eigene, seit
Wochen im Memory stehende Falle** getreten: `grep -v '/build'` **frisst das Verzeichnis
`builder/`**. Genau dort liegt die gesamte reale PMC-Implementierung. Alle meine ersten
Suchen waren blind. Zusätzlich habe ich am falschen Checkout gemessen (Feature-Branch
`b-m2-pmc-invariante` statt `development`). Daraus habe ich einen **Alarm** gebaut, der
schärfer war als die Faktenlage.

**Die korrigierte Wahrheit:** L1, L3, DTLB und RAPL-Energie werden **real** via
`perf_event_open(2)` erhoben. Nur `branch_misses` nicht — und das ist als **offener Posten
M-3a** im Code bereits ehrlich geführt, samt eigener Rücknahme der alten Falschzusage vom
06.08. Das System ist ehrlich; falsch behauptet habe **ich**, zweimal.

Der einzige echte Restfehler: eine übersehene Kommentarzeile in `tests/unit/CMakeLists.txt`,
die noch *"real erhoben aber bisher stumm"* sagte. Behoben (ce `cea98330`).

**Lehre, die ich mir gebucht habe:** ein Alarm ist genauso begründungspflichtig wie eine
Entlastung. Und: `/build/` immer **mit beiden Schrägstrichen**.

**Offen bleibt daraus:** V-03 und V-05 stammen aus demselben Reconcile-Pass und sind bis
heute **ungeprüft übernommen**. Ich messe sie nach — diesmal korrekt.

---

## 4. Was der Ledger-Audit gefunden hat (kein Entscheid nötig, nur Kenntnis)

**43 von 43 geprüften Positionen** sind im Gesamt-Ledger nicht sauber erfasst. Die Wurzel:

Der **A15/§55-Gesamt-Reconcile wurde nie vollzogen**. Das Konsolidierungs-Register ist per
Konstruktion ein 14-Tage-Fenster ab 23.07.; der letzte Voll-Block §55 (20.07.) liegt davor.
Die B-Liste (B1–B13) wurde ins Register übernommen, die A-Liste (A14/A15) derselben Quelle
nicht — und der Posten, der genau diese Übertragung anmahnte, ist selbst der prominenteste
Verlust.

Zwei Posten daraus verdienen deinen Blick:
- **A14/FF0 Multi-Plattform-Generalität** — im Alt-Block ausdrücklich als *"Abgabe-Blocker"*
  geführt, seither nur zweimal selbstreferenziell erwähnt, nie bearbeitet.
- **GN-9 Feasibility-/Kalibrierungs-Gate** — per Definition **vor** der Voll-Matrix, hat bis
  heute keinen Slot im Fahrplan. Ein 1-Zellen-Kalibrierungslauf würde die 6-TB-Frage klären,
  bevor 2^17 Zellen gebaut werden.

Volle Liste als Beleg mitgelandet: `docs/sessions/20260807-AUDIT-ledger-vollstaendigkeit-43-positionen.json`.

---

## Was ich ohne dich weiterbaue

Alles, was keinen Entscheid braucht: V-03/V-05 nachmessen, die Benchmark-Zuordnung aus
Abschnitt A in den Plan gießen, und die Bau-Rückstände aus Task #35 nach Wirkung.
Die `cpe`-Grammatik und das xlsx-Blatt warten auf dich — beide sind Byte-Ereignisse, die
man nicht zweimal macht.
