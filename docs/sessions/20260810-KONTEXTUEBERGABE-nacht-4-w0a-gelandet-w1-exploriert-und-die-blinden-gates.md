# KONTEXTÜBERGABE — Nacht 4 zum 10.08.2026

> **Vorgängerinnen:** `20260809-…-nacht-2-…` und `20260810-…-nacht-3-…`. Beide gelten weiter.
> Wer nur eine liest, liest diese.

---

## 0. DAS ERSTE, WAS DU TUST

**Die vier bindenden Dokumente WIRKLICH kippen** — vollständig mit `Read`, nicht greppen.
Owner-Direktive: *„ALLE WIRKLICH in den Kontext kippst und IMMER nach Kompaktierung neu
hineinkippst → merke dir das."*

    docs/sessions/20260808-GOAL-V8-KONSOLIDIERTE-LESEFASSUNG-verbatim.md    241 Zeilen
    docs/ARBEITSWEISE-GESAMT-DOKTRIN.md                        (v3.1)       557
    docs/plaene/20260808-GOAL-V8-DOSSIER-…md                                659
    docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md      971   (4 Portionen à ~200)
    docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md        289
    ---------------------------------------------------------------------------
                                                                          2.717

Dann `MEMORY.md` und der **Ledger-Kopf** (Nachträge stehen **oben**, jetzt 16.690 Zeilen).

---

## 1. DER ERSTE HANDGRIFF — ein Defekt, gemessen, sofort behebbar

**ce-Pipeline 15515 ist ROT.** Genau ein Job, `test:unit` auf **prod2**, genau ein Test:

```
99% tests passed, 1 tests failed out of 486
    474 - test_d2_abdeckungs_wache_nenner (Failed)
```

**Die Rechnung, und sie ist vollständig:**

    prod1 (lokal, AVX2 + AVX-512)   492 Tests
    prod2 (CI, ohne AVX-512)        486 Tests      <- Lauf 15515
    committete Untergrenze          488
    ------------------------------------------------
    486 < 488  ⇒  die Wache schlägt an — KORREKT nach ihrer Bauart

**Der Strang hat die Gefahr vorhergesehen und trotzdem falsch gerechnet.**
`scripts/ci_test_inventory_floor.txt` dokumentiert im Kopf: *„Dieser Messhost ist die REICHSTE
Hardware-Klasse … 492 ist damit ein Maximum, keine Untergrenze — ein Host ohne diese
Vektor-Erweiterungen [verliert] Registrierungen, die an der Host-ISA hängen."* Er rechnete mit
**4** (den AVX-512-Gattern aus D2-G5); gemessen sind es **6**.

**Was zu tun ist — und was NICHT:**
- **NICHT** die Untergrenze auf 486 senken, ohne den Grund zu messen. Erst die Differenz
  namentlich erheben: welche 6 Tests fehlen auf prod2? D2-G5 nennt 6 ISA-gattierte
  Registrierungen (4 × AVX-512F, 2 × AVX2) — wenn prod2 auch die AVX2-Paare verliert, ist die
  Host-Klasse eine andere als angenommen, und **das** ist der Befund.
- **NICHT** die Wache weichkochen. Sie tut genau, was sie soll.
- Die saubere Lösung ist die **zweistufige Untergrenze**, die der Wellenplan unter D2-G5 schon
  vorsieht: eine Zahl je Host-Klasse, ausgewählt über `scripts/ci_host_klassen_bericht.sh`.
  Eine einzige Zahl kann zwei Hardware-Klassen nicht bedienen.

**Merke:** dies ist derselbe Fehler, den der Strang selbst beschrieben hat — nur eine Ebene
tiefer. Er warnte, dass 492 ein Maximum ist, und setzte dann eine Untergrenze, die immer noch
zu hoch war.

---

## 2. WO WIR STEHEN

```
ce      development  78fcc627     main  1880f296
super   development  0998fe06     main  85dc85e8
```

**Gelandet in dieser Nacht: 42 ce-Commits, 13 super-Commits.**

| Welle | Stand |
|---|---|
| **W-1** | **abgeschlossen**, am Objekt belegt: `enable_testing()` in ce `CMakeLists.txt:695`, vor `add_subdirectory` |
| **W0a** | **gebaut, adversarisch verifiziert, drei von vier gelandet** |
| **W0b** | xlsx-Station gelandet · anhang-Selektor + Durchstich-Kette landereif · **#53 offen** |
| **W1** | **exploriert, nicht begonnen** — der größte Block (D4-Kette) ist schon gebaut |
| **W2–W5, W7** | nicht begonnen. Freeze 21.08., Kampagne ab 29.08., Abgabe 15.09. |

**Noch ungelandet, alle gemergt und hygienegeprüft** (warten auf R4 bzw. auf die
Untergrenzen-Klärung aus §1):

    wt-ce-w0a          6 Commits   Registrierungs-Sichtbarkeit + 3-Wachen-Merge
    wt-ce-schema       4 Commits   D3-6 anhang-Selektor
    wt-ce-messvisitor  5 Commits   Durchstich-Kette
    wt-ce-d2floor      3 Commits   D2-Zweitfassung — VERWORFEN, bleibt als Vergleich stehen

---

## 3. WAS W1 BETRIFFT — der Engpass ist kleiner als geplant

Der Designplan führt W1 als *„den Engpass des gesamten Plans"*: **99 h Band A auf einer Woche,
die schon mit 26 von 27 Werktagen gefüllt ist.** Der Pflicht-Explore hat gemessen:

**Die gesamte D4-Statistik-Kette ist gebaut und bis ce/main gelandet.**

| Posten | Commit | Kern |
|---|---|---|
| D4a Welch | `cc9c233e` | `se<=0` setzt `degeneriert=true` statt getarntem `p=1.0, valid=true` |
| D4b MWU | `e397109f` | `valid` HINTER den Guard; kein Effektmaß über Nichts |
| D4c Bonferroni | `47f0ad89` | Familie zählt nur **getestete** Hypothesen |
| D4d success | `739d478f` | „es gab eine echte Probe" statt „der Vektor ist nicht leer" |
| D4e f15-Bilanz | `46fac2e9` | vierte Ausschlussgruppe, `A+B+C+D+gemessen==geladen`, Exit 6/7 |
| **D4-T6** | `905bd1aa` | **eine sechste Fundstelle, die der Plan nicht kannte** |

Der Merge `ebb3cf27` liegt **16 Commits vor** `origin/main`.

**D4-T6 ist der interessanteste:** in `compare_engine_command.hpp` erzeugte ein geretteter
Nenner nicht nur eine harmlose Null, sondern **ein falsches Urteil** (`EE_B_Wins` statt
`InconclusiveData`). Die Klasse ist damit sechsfach belegt: *die Null wird überall als
DIVISIONS-Gefahr gerettet und nirgends als DATEN-Aussage behandelt.*

**Was in W1 offen bleibt:**
- **MT-L3 existiert nicht.** Ein einziger Treffer im ce-Baum, und er dokumentiert die eigene
  Abwesenheit (`test_v41_anatomy_f15_measurement.cpp:1282`). Designplan: **0 von 29
  unabhängigen eingefrorenen Orakeln**.
- Die Regel *„MT-L3 VOR D4d"* ist **formal verletzt** — D4d hängte seine Spalte am 09.08.
  18:51 an. **Sachlich ein anderer Gegenstand:** D4d schrieb an `result_csv_header()`,
  MT-L3 bewacht die große Produktions-Mess-CSV in `cache_engine_builder_iterator.hpp`. Zwei
  Schemata. Die Regel bleibt für die **nächste** End-Append-Spalte in Kraft.
- **Menge/Deckel** (`--check-size`, `measure_selection`) und **HY-A** sind in der
  Explore-Ausgabe erhoben — die vollständigen Berichte liegen im Workflow-Journal
  `wf_8147a6f4-fe2`.

---

## 4. DER ROTE FADEN DIESER NACHT — viermal dieselbe Figur

**Eine korrekt arbeitende Messung beantwortet die falsche Frage. Kein Werkzeug war defekt.**

| Fall | Wache meldete | tatsächlich ungeprüft |
|---|---|---|
| Hygiene-Paket | `GRUEN` | **Shell-Dateien** — `is_scoped()` ist eine Whitelist ohne `.sh` |
| Bauweg-Wache | `GRUEN`, 589 Zeilen | **alle 589** außerhalb des Scopes |
| xlsx-Station | `GRUEN`, 451 Zeilen | **Formatkonformität** (`lint:format` fiel danach rot) |
| D2-Untergrenze | lokal `492/492` | **die andere Host-Klasse** (prod2: 486) |

**Gefunden wurde jeder Fall nur durch eine zweite Prüfung mit ANDEREM Gegenstand** — nicht durch
besseres Hinsehen bei derselben: ein Strang, der seine 354 Shell-Zeilen von Hand nachmaß · ein
Verify-Agent, der einen eigenen Köder würfelte · ein CI-Job, der Format prüft · eine zweite
Maschine.

**Die Regel steht jetzt im Memory** (`reference_ein_gruenes_gate_deckt_nur_seinen_gegenstand`):
vor jeder Freigabe **beide Mengen nennen** — was geprüft wurde *und* was nicht. Was in der
zweiten Zeile steht, ist nicht abgenommen, auch wenn die erste grün ist.

**Beim letzten Push habe ich sie zum ersten Mal angewendet, bevor sie mich einholte:**
präventiver `clang-format-22`-Lauf über vier Pakete → **5 von 8 Dateien geheilt**. Ohne ihn:
drei rote Pipelines.

---

## 5. MEINE EIGENEN IRRTÜMER — fünf, alle korrigiert

1. **„490 Tests"** traf keinen realen Bau-Zustand. Wahr: **488** ohne 2-Pass, **492** mit,
   **490** ist die `-LE pmc`-Teilmenge. Drei Mengen, drei Zahlen (V6.5).
2. **„Der main-FF ist der Heiler für super"** war eine Vorhersage, keine Messung. Er heilte
   `pmc:intel` und legte `test:coverage-guard` frei.
3. **Die OV-Bilanz zählte Zeichenketten statt Gegenstände.** Der Ledger sagt bei `:898`, warum
   das nicht trägt: **der Owner nummeriert nicht, er beschreibt.**
4. **Mein `SendMessage` erzeugte einen zweiten Schreiber** im selben Worktree. Die Quittung sagte
   es im Klartext (*„resumed from transcript"*); ich hatte sie gelesen und nicht verstanden.
5. **Ich las das GRUEN der Hygiene-Wache als Freigabe**, obwohl V6.6 wörtlich sagt, dass sie
   Format nicht prüft.

---

## 6. WAS DEM OWNER GEHÖRT

**(a) `prod-baremetal-prod2` nimmt Jobs an und führt sie nicht aus.** Belegt am selben Job:

    prod1   16 s   success   Trace 5038 Byte
    prod2   6155 s  stuck_or_timeout_failure   Trace 0 Byte

Bei **47 von 53** floatenden Jobs ist das in Bau- und Messwoche fristkritisch. Cluster ist für
diese Session read-only.

**(b) `-Wall`/`-Werror`** (#44): gemessen, `-Werror` **0 von 575**, **SPEICHER-Klasse leer**,
~20–26 Warnungen gesamt. Empfehlung: Variante (b) — `-Wall` auf die zweite Testklasse
ausdehnen, kein `-Werror`.

**(c) Mutations-Sicheres Testen** (#50) — offener Owner-Auftrag vom 09.08. 14:34, bisher
nirgends geführt.

**(d) Der Owner-KERN zur Bauform** (verifiziert, Zeile 25562, `promptSource=typed`):
*„Skripte sagen gar nichts … die C++ Implementierung dazu."* Der C++-Weg existiert
(`Code/ci_wachen/`, drei Google Tests), steht aber auf **Stufe 1 von 2**: die Proben sind C++,
die Wachen selbst noch Shell, und `.gitlab-ci.yml:307` ruft weiterhin die Shell.

---

## 7. WAS VON HIER AUS GEHT — geordnet nach Nutzen

1. **Die Untergrenze host-klassenfähig machen** (§1). Kleinster Eingriff, entsperrt die CI.
2. **Die drei landereifen Pakete landen** — je einzeln, R4 in getrenntem Kommando,
   `clang-format` präventiv.
3. **#53** — das Mappen-Orakel prüft den Zähler statt den Inhalt; Köder M3s überlebt.
4. **#51** — die Diff-Hygiene-Wache auf Blacklist umbauen (`.sh` einschließen). Vorsicht:
   der Altbestand ist ungemessen, ein Umbau kann sofort rot werden. Reihenfolge: messen,
   Zuwachs stoppen, Bestand als eigener Posten.
5. **MT-L3 bauen** — Vorbedingung für jede weitere End-Append-Spalte.
6. **W1 fahren**, mit dem Wissen, dass D4 steht: Menge/Deckel, Sperrlisten-Wache (das
   **Freeze-Gate** — ohne sie ist F2 nicht abnehmbar), HY-A.

---

## 8. WAS DIESE NACHT NICHT KONNTE

**W2 bis W5 und W7 sind nicht begonnen.** Das Goal endet am **15.09.2026** mit einer
abgegebenen Diplomarbeit; der Wellenplan rechnet mit 26 von 27 Werktagen. Der finale
codex+Fable-xhigh-Review setzt voraus, dass alle Wellen durch sind — er ist der **letzte**
Schritt, nicht der nächste.

**Konkret nicht erledigt:** der Durchstich (##25, F1-Lieferung am 14.08.) ist vorbereitet, aber
nicht gefahren — `persist:measurements` sammelt weiterhin **0 × xlsx** (Gegenprobe csv: 44
Zeilen). Ohne diesen Nachzug bleibt die Kette blockiert, auch mit gepatchtem F1-Profil.

**Und eine Regel habe ich selbst verletzt:** die EIN-BLECH-REGEL. Zwei Pipeline-Abnahmen plus
fünf lokale Vollbauten gleichzeitig, Load-Spitze 30 bei 32 Threads, wo der Plan **eine**
Abnahme erlaubt. Ob das den prod2-Hänger verursacht hat, ist **nicht** belegt — der Job lief
bei leerer Maschine weiter. Der Verstoß bleibt trotzdem einer.
