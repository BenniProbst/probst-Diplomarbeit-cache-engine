> LEBENDE DICHTE FASSUNG: docs/plaene/20260826-DESIGNPLAN-TDD-DICHT.md (Owner-Order 26.08.2026, KON130).
> Dieses Dokument ist ab 26.08.2026 BELEG-ARCHIV: nichts geloescht; der 117er-Katalog und die
> Marker-/Nachzugs-Ketten par.9 bleiben hier als Beleg. Neue Nachtraege NUR in der DICHT-Fassung
> (additiv AM ORT mit Datum); Einlese-Ritual ueber die DICHT-Fassung.
> [V12-Nachtrag 27.08.2026: "KON130" = Konsolidierungs-KON der Owner-Order; im Ledger ist KON130 seit c778ed7b
> MAIN-FF -- die Konsolidierungs-KON erhaelt die naechste freie Nummer bei Einspielung durch den Lead.]

# DESIGNPLAN ERWEITERTE TESTABDECKUNG — TDD ÜBER ALLE WELLEN
**Stand 08.08.2026 abends · fügt sich in den Wellenplan v2 (`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md`) ein, Abschnitte 3 und 6 sind bindend; dieses Dokument ergänzt dessen Verifikationsvertrag um die Testseite, es ersetzt nichts.** **[STAND-HINWEIS 12.08.: Drift gegen KON15–KON38 in §10; betroffene Stellen tragen [D-n → §10]-Marker.]**

Posten-IDs unten: MT=Messkette-Treiber, ST=Statistik-Glied, PK=Perzentil-Kanon, PE=Planer-Emission, LG=Lagerhaltung, AS=Achsen-Stempel, PM=PMC-Messfühler, AG=Anatomie-Gattung, XL=xlsx-Ausgabe, HY=Hybrid. Notation je Posten: `[Band Welle h]`; Band A = landet im Fenster, B = nur bei freiem Slot, C = W7. `*` = Welle gegenüber dem Kritik-Material verschoben (Regeln in §4).

---

## VORBEMERKUNG (nachgetragen 08.08.2026 abends) — dieses Dokument ist selbst Kritik-Material

**Dieser Plan ist aus Kritik entstanden, und er ist inzwischen seinerseits am Objekt geprüft worden.** Das ist keine Formalie: §0 misst, dass von **157 Behauptungen zweier Kritikstufen 40 am Objekt fielen** — rund ein Viertel. Ein Dokument, das diese Quote über *anderes* Material berichtet, unterliegt ihr selbst. Die Nachprüfung hat vier Stellen gefunden; sie stehen als **B-1…B-4 in §9**, und die Textstellen tragen den Verweis.

**Annotieren, nicht löschen (Hausdoktrin „Doku wird deprecatet").** Keine widerlegte Zahl ist aus dem Fließtext entfernt worden. Die alte Zahl bleibt lesbar stehen, die neue steht in §9 **daneben** — mit ihrer **Zählweise**, ihrem **Nenner** und dem **Zustand**, in dem sie erhoben wurde. Wer nur die neue Zahl sähe, könnte nicht mehr prüfen, wie die alte entstanden ist; genau das will diese Fassung erhalten.

**Was die Berichtigungen NICHT antasten.** Kein Posten der 117 fällt, keine Wellen-Zuordnung, kein Aufwand ändert sich. Betroffen sind vier *Belegzahlen*; die Sachaussagen, die sie stützen sollten, halten in drei von vier Fällen unverändert (B-1, B-3, B-4) und werden in einem Fall präzisiert (B-2).

**Und die Zahlen sind ab jetzt bewacht.** §9 trägt einen maschinenlesbaren Anker-Block; `ci/plan_zahlen_wache.sh` leitet dieselben Zahlen bei jedem CI-Lauf neu aus dem Code ab und wird rot, wenn Plan und Objekt auseinanderlaufen. Der Grund steht in §9.5: dass diese Zahlen überhaupt verjähren konnten, lag daran, dass sie in Prosa standen — und **Prosa wird nicht rot**.

---

## 0. Die Zahlen zuerst

- **157 Behauptungen** aus zwei Kritikstufen (Codex-Kritik + erste Schärfungsstufe) gingen durch die Meta-Objektprüfung: **117 von 157 bestätigt oder geschärft** (Summe **386 h**), **40 von 157 fielen** am Objekt — **rund ein Viertel**.
- Die 40 Gefallenen verteilen sich auf **beide** Stufen: darunter **13 Fehler der ersten Schärfungsstufe selbst** (Testentwürfe, die am gesunden Objekt rot oder am kranken grün gewesen wären: unerfüllbares `P99IstNichtDasMaximum`, falsches Winsor-Orakel bei geradem n, Tautologie-Schleife im Katalog-Entwurf, zwei falsche Ganzheits-Nenner im Planer-Gebiet, u. a.); **weitere 7 Erst-Entwürfe** überlebten nur durch Ersatzkonstruktion in der bestätigten Liste (Diskrepanz-Köder, PCM-Vertrag, DepthFirst-Köder, NichtGelesen-Nenner, Heuristik-Gegenprobe, Zeilenlimit-Mechanismus, Hybrid-Label-Köder).
- **62 Funde hatte erst die Meta-Stufe** — weder Codex noch Stufe 1; **9 davon** wurden eigene Posten der 117 (NEU-markiert), der Rest schärfte Entwürfe oder wurde Regel („Aufrufer-Suche IMMER über ce UND super", „Abdeckungs-Suche über tests/ gesamt, nie über die namensgleiche Datei").
- Aussage über die Methode selbst: **einstufige Kritik verliert am Objekt ein Viertel ihrer Behauptungen und übersieht zusätzlich einen Bestand von mehr als der Hälfte ihres Fundvolumens** (62 gegen 117). Die Session-Konsolidierung (Wellenplan §11.1) misst dieselbe Klasse an Widerrufen: 32,5 % hielten nicht. Konsequenz dort wie hier: der Verifikationsvertrag gilt auch für Widerrufe und für Testentwürfe.

## 1. Warum TDD und nicht Abdeckungsprozente

Der 08.08. fand fünf blockierende Defekt-Familien (D1–D5, Wellenplan §2). **Dreimal war der Test selbst der Defekt:** die Abdeckungs-Wache blieb grün gegen den korrekten 431-Baum (`guard431.log`), `test_commands.cpp:183-190` sichert Welch-`t=0, p=1` über konstanten Gruppen als Sollverhalten zu, `SummarizeEmptyZeroWinRate` zementiert `win_rate=0.0` über leerer Menge. Eine Abdeckungszahl hätte in allen drei Fällen gut ausgesehen — die Zeilen **werden** ausgeführt; sie sichern nur nichts zu. Dazu der Selbstbezug als Bauform: das CSV-Schema wird von 47 von 47 Stellen gegen seine eigene Quelle geprüft. **[B-1 → §9: die Zahl 47 ist am Objekt mit keiner von sechs benannten Zählweisen reproduzierbar; die Sachaussage hält, die belastbare Zahl lautet 29 Aufruf-Stellen in 17 Übersetzungseinheiten.]**

**Prüfnorm dieses Plans:** Ein Test zählt nur, wenn drei Dinge benannt sind — welche **Aussage** er sichert, welcher **Eingang** sie fällen würde, und **woher sein Nenner** stammt (nicht aus dem Prüfling). Abdeckung misst Berührung; wir messen **Beißfähigkeit**, und zwar mit gefahrenem Biss (K13: der Köder muss erst beißen). Tests sind Gegenstand der Kritik, nicht nur ihr Werkzeug: jede Welle nimmt ihre eigene Testseite in die Objektprüfung.

## 2. Die Testklassen

Ordnung nach Klasse, nicht nach Datei. Nenner: 117 Posten = 29+25+23+16+10+9+3 in sieben Klassen + 2 Einzelfälle.

**K1 keine-negativprobe (29 von 117).** Eine Zusicherung existiert, aber kein Eingang, bei dem sie fällt: Klemmen ohne Klemmprobe, Wachen ohne Fremd-Genus, Verträge ohne Fehlerpfad. Der Mutant überlebt, weil nur die gesunde Seite je betreten wird.
MT-L7 Nullcontainer [A W2 3] · MT-L8 Legacy-Mikrobench [C W7* 0] · MT-L11 Vendor-Injektion [B W4 2] · ST-Diskrepanz Welch/MWU [A W1* 2] · ST-Winsor NaN [A W0b 1.5] · ST-DriftBestwahl [B W1 1] · ST-BreakEvenKreuz [B W2 3] · PK-Kreuztest 6/8 Stellen [A W1 6] · PK-NullMedian [B W2 2] · PE-Rules on_success [A W0b 1.5] · PE-WarnPfade 10/14 [B W2 2] · LG-Lazy 0/2→2/2 [B W0b 2] · LG-LoadWache beide Genera [A W1 4] · LG-Kollision je Backend [B W0b 3] · LG-NoThrow-Inhalt [B W0b 2] · LG-CommitAtom [B W1 3] · AS-GenusLaut [B W2 3] · AS-Aritaet requires [B W1 2] · AS-NameClean [B W1 1.5] · PM-NichtGelesen [A W2*(Seam)/C(HW) 4] · AG-Sentinel46 [B W2* 3] · AG-Concepts11 [B W1 8] · AG-LayoutPin [B W2 3] · XL-L6 Dangling-Link [B W2 2] · XL-L8 ZahlText [B W2 3] · XL-L9 Abbruch/tmp [B W2 3] · HY-Reroute-Vertrag [A W1* 12] · HY-Ausgaenge [A W4 10] · HY-HonestEmpty [A W4 8]

**K2 anwesenheit-statt-bedingung (25).** Geprüft wird, dass etwas **da** ist (Substring, Datei, Exit 0, `find()`), nicht dass es **gilt**. Die gemeinsame Heilform: Wert- und Positionsbindung statt Existenz, plus Kontrast-Köder, der die Altfassung grün lässt.
MT-L1 Exit0-ohne-Messwert [A W2* 3] · MT-L9 T17-Gleichheit [B W1 2] · MT-L10 TikZ [B W4 2] · ST-CLITestat statt Regex [A W1* 3] · ST-RankingTie [B W1 3] · PK-DeleteP99-Wache [A W1* 3] · PE-BauTestat else [A W0b* 2] · PE-PruefXOR [A W0b* 1] · PE-PMCPreflight-Kette [A W0b 1] · LG-SkipCallback==0 [A W1 6] · LG-NAZelle [B W0b 3] · LG-DepthFirst-Protokoll [B W0b 2] · LG-WritebackXlsx [A W1 3] · AS-KatalogTab 19 [B W1 2] · AS-ORG18 DOM+CRC64 [B W1 2] · AS-OsPin [A W0b 0.5] · PM-m3v2Spalten [B W1 2] · PM-WinPCM [C W7* 3] · AG-C1C4 6 Orakel [B W0b 3] · AG-IsComposition [B W1 4] · XL-L2 Token zellgenau [A W1 4] · XL-L3 INFO lesen [B W1 3] · XL-L5 Hyperlink-Menge [B W1 4] · HY-Label-Gate [A W0a 3] · HY-Kurvenlage [A W4 8]

**K3 kein-nenner (23).** Eine Zahl ohne Grundgesamtheit: Zählungen statt Mengen, Teilprüfungen, die als Ganzheit auftreten, Kennzahlen ohne „nicht bestimmbar". Heilform: Nenner aus fremder Quelle, `ASSERT` auf die Zahl vor der Schleife (V-7 des Wellenplans).
MT-L2 ns_per_op-Token [A W2* 5] · MT-L6 Stichprobe beide Writer [A W2 3] · MT-L12 Golden-320-Menge [B W4 2] · MT-QFlag Unbestimmt [B W2 2] · ST-MultiCompare bestimmbar [A W1* 3] · ST-Export Robust-Felder [A W1* 2] · ST-Perzentile optional [A W0b 2.5] · ST-HeurIdentisch [B W2 2] · PK-SuperFixture n=4 [B W2 4] · PK-KlemmJson n-Spalten [A W1 4] · PK-P999 Produzent [B W2 4] · PE-JobBindung [B W1 2] · LG-Idempotenz 2×3 [A W1 4] · LG-Rueckschrieb7 [B W1 1] · AS-OrganOrdnung 18/18 [B W1 4] · AS-DupReject [B W1 2] · PM-m3v2Zero 8/8 [A W2* 1] · PM-RAPL 4 Eingänge [A W2* 2] · AG-GenusCount [B W4 5] · XL-L11 Mapping-Funktion [A W0b 3] · HY-Ebene4 Label+Datensatz [A W1*(a)/W4(b) 12] · HY-Gleichstand+Berührpunkt [A W0b 7] · HY-DokuAnker [B W0a 5]

**K4 unerreichbarer-block (16, inkl. test-unsichtbar-durch-registrierung).** Der Test existiert und läuft nie: nicht registriert, hinter `OFF`-Flags, in bedingten CMake-Blöcken, oder der geprüfte Pfad ist nicht anspringbar. Billigste Klasse pro Stunde — Registrierung IST Teil des Tests (T-7).
MT-L4 vier Unregistrierte+Wache [A W0a 3] · MT-L5 V32-Flag+CI-Job [A W0b 4] · ST-CTestWache 0/429 [A W-1 3] · PK-F15Frei aus if-Block [A W0b 1] · LG-HostBinder 3 Felder [A W1 5] · LG-Zeilenlimit Verwendungsstelle [B W0b 3] · AS-Bewaffnung Roundtrips==3 [A W0a 3] · PM-Outcome Teil 1/2 [B W1 4] · PM-OffZwilling [B W0b 1.5] · PM-CTZweig 2 TUs [B W1 2] · AG-Noexcept-Härtung [B W1 6] · AG-DllRoundtrip [B W2 4] · XL-L7 Limit-Aufruf [B W2 5] · XL-L10 Präfix/S00N [B W2 3] · XL-L12 Idempotenz/Degradation [B W2 3] · XL-SheetZaehler gemischt [B W2 3]

**K5 test-zementiert-defekt (10, inkl. selbstreferenzielles-orakel).** Der Test schreibt das falsche Verhalten als Soll fest oder bezieht sein Orakel aus dem Prüfling. Jeder Fix muss den Alt-Test im selben Commit umschreiben, sonst ist der Baum aus zwei Gründen rot.
MT-L3 Schema-Orakel 47/47 **[B-1]** [A W1 5] · ST-Welch bestimmbar [A W1* 2] · ST-MWU n=1 [A W0b 2] · PK-KanonWert [A W1 4] · PK-DriftGrenz absolut [B W2 2] · LG-XlsxAlt nie vernichten [A W1 4] · LG-CsvAlt Schwester [A W0b 2] · PM-Kreuz16 Offen-Liste [B W2 2] · PM-Scaled beobachtbar [A W2* 2] · AG-PunktFixes [C W7* 2]

**K6 kein-test / code-ohne-test (9).** Tragender Produktionscode ohne einen einzigen Testtreffer — darunter der gewollte Mechanismus `allow_failure` und die einzige Namens-Wache am Registry-Erzeuger.
PE-AllowFailure [A W0b 1] · PE-Startgate-Vertrag [B W1 2.5] · PM-PAPI [C W7* 3] · PM-Naht perm_runner→CSV [A W1 2] · PM-Errno Voll-Sweep [B W1 1] · PM-AmdL3 (Teil 0 sofort) [C W7* 3] · PK-QFlagWache Erstwache [B W2 5] · AS-LegacyPin [B W0b 2] · HY-ModulGrenze 4 Symbole [A W1* 8]

**K7 produktionsweg-ungetestet (3).** Gebaut, aber unverdrahtet oder asymmetrisch — Tests fahren Nebenwege, der Owner-Weg (xlsx) hat null Aufrufer.
XL-L1 Facade zweistufig [A W0b(A-Stufe)/W1(B-Stufe) 10] · LG-E2Exlsx Facade [A W1 6] · XL-CsvDtor-Leck [B W2 2]

> ⚠️ **MARKER 13.08.2026 (KON59):** [D-5 → §10]: die xlsx-„null Aufrufer"-Aussage von K7 ist präzisiert — **8 von 9** `thesis_profiles` sind xlsx-blind (KON4-07/R1 + KON36-02/H), nicht alle 9; es fehlt der T-3-Klasse-Posten mit Profil-Nenner (Lehre L-4: jede „existiert nicht"-Aussage trägt ein Verfallsdatum). Die Zeile bleibt stehen.
> ✅ **R1-NEUAUSZAEHLUNG 15.08.2026 (zehnter Gitlink-Zug, ce `04f76b65`):** Profil-Nenner **9 → 11** (`git ls-tree` über `libs/cache_engine/algorithm_profiles/thesis_profiles/`, 11 `.profile.xml`); xlsx-blind **0 von 11** — alle 11 tragen ein aktives `<method value="xlsx"/>` (KF #24, 14.08., Owner-B4 „xlsx ist Standard"; Messung `git grep -E '<[^!]*xlsx'` gegen den Baum, je Datei >= 1 Element-Treffer). Die L-4-Lehre hat geliefert: die 13.08.-Zahl war 2 Tage später doppelt überholt (Nenner UND Zähler).

**Einzelfälle (2):** PK-WinsorWert (absturzfreiheit-statt-aussage: `isfinite` ersetzt den Wert) [B W2 2] · XL-L4 n/a-Konkurrenz (kennzahl-ohne-nicht-bestimmbar) [A W1 3].

## 3. Der TDD-Vertrag

Gilt ab sofort für jedes Paket aller Wellen; er ergänzt V-1…V-7 des Wellenplans um die Testseite. Deckungsfrage nach §11.3: „was erzwingt das Halten?" — zulässig ist nur ein Werkzeug oder eine benannt ungedeckte Stelle.

- **T-1 ROT ZUERST.** Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter Wegwerf-Mutation bewiesen (Rot gesehen, dann zurückgenommen). Beides fehlt = kein Test. Ebenso unzulässig: ein Test, der am gesunden Objekt nie grün werden kann (Daueralarm — die Klasse `P99IstNichtDasMaximum`).
- **T-2 AUSSAGE, NICHT ANWESENHEIT.** `find()`, Existenz, Exit 0, „wirft nicht" sind keine Zusicherungen. Wert, Position, Menge, Klasse.
- **T-3 NENNER, FREMD.** Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer anderen Quelle als dem Prüfling (Konstante neben dem Enum, Quelltext-Scan, eingefrorene Literalliste); `ASSERT` auf die Zahl VOR der Schleife.
- **T-4 GEGENEINGANG.** Zu jeder Zusicherung ein Eingang, bei dem sie nicht gilt. Ein Randfall-Test, der nur Absturzfreiheit prüft, ist keiner.
- **T-5 ORAKEL UNABHÄNGIG.** Sollwerte im Test gerechnet oder als einmalig erhobene, dann eingefrorene Literale — nie aus der geprüften Funktion, nie aus Kritik-Material abgeschrieben (die „184 Spalten" sind unverifiziert; K13).
- **T-6 SCHWESTERPFLICHT.** Jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle (beide Writer, beide Genera, beide Backends, beide Break-Even-Engines, beide Serialisierer). Die Meta-Stufe fand einen erheblichen Teil ihrer 62 Funde genau so.
- **T-7 REGISTRIERUNG IST TEIL DES TESTS.** Ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg hängt; Registrierungs-Bissprobe (Köder-Datei bzw. Configure-Probe) gehört zur Abnahme. Belegstand: 4 unregistrierte Dateien, 27 unsichtbare Fälle, F15-`if`-Block.
- **T-8 ATOMARE LANDUNG.** Tag-1-Rot lebt im Feature-Branch; auf `development` landen Test + Minimalbau atomar (Hart-Grün-Doktrin bleibt intakt). Rot-Lauf vor der Heilung und Grün-Lauf danach sind Paketbestandteil (V-2 auf Tests angewandt).
- **T-9 TESTKRITIK.** Neue Tests jeder Welle gehen in der Folgewelle durch einen Codex-Pass + Objektprüfung (§6) — dreimal war der Test der Defekt; das wiederholt sich, wenn nur Produktionscode kritisiert wird.

## 4. Testarbeit je Welle

Drei Einfüge-Regeln gegenüber den Wellen-Etiketten des Materials (`*` im Register): **(1)** Die Landung eines Begleit-Tests folgt der Bauwelle seines Gegenstands (Wellenplan ist bindend: D4→W1, D3→W0b, D5-4→W1; Tests entstehen früher, landen atomar). **(2)** W3-MESS ist blechexklusiv (Parallelität 1) — alles, was das Material „W3-MESS" nennt, landet **bis F3**; in W3 laufen nur die Gates. **(3)** HY-A liegt in W1 — die Hybrid-Verträge (HY-Reroute, HY-ModulGrenze, HY-Ebene4a) rücken von W4 nach W1 VOR den Bau; das ist der reine TDD-Fall: null Zeilen Bestand, der Test ist die Spezifikation. Sonderfall: PM-NichtGelesen-Hardwareteil braucht die pmc:intel-Lane — prod2 ist per OV-5(b) gestrichen, der Teil geht nach W7; nur der Seam-Teil bleibt.

**W-1 (Sa/So 08.–09.08.) — A: 1 Posten, 3 h.** ST-CTestWache zuerst: `enable_testing()`-Wurzelfix + Nach-Build-Wache Soll (Quelltext-Scan) gegen Ist (`ctest -N`), Differenz namentlich; ohne sie sind die neuen Welch-Tests unsichtbar. Abnahme: Köder-Unterordner beißt; Zähler vorher/nachher. Offene Divergenz am Objekt klären: Material erwartet 429→456, Wellenplan §1 zählt 428 lokal + 27 = 455 — W-1 erhebt neu, beide Nenner benennen. **[B-2 → §9: erledigt. W-1 ist gelandet (super `ca901c50`, ce `1f88cfec`); die Divergenz war ein Sprung über ZWEI Grundgesamtheiten. Vier Zustände, einzeln: 429/431 frischer Configure, 456 nach dem Bau, 460 CI-Baum.]**

**W0a (Mo–Mi 10.–12.08.) — A: 3 Posten, 9 h; B: 1, 5 h.** MT-L4 (vier Registrierungen, jede eine Bissprobe; rf2 sicher rot = Befund, kein allow_failure) · AS-Bewaffnung (`ctest -N -R` == 3, Configure-Köder) · HY-Label-Gate (Configure-Zeit, Substring-Nenner). Dazu wird die **rote Statistik-Suite geschrieben** (ST-Welch/MultiCompare/Diskrepanz/Export/CLITestat; Landung mit D4 in W1) — rein lokal, deckungsgleich mit der W0a-Lokalspur. Abnahme-Gate: alle Registrierungswachen mit gefahrenem Rot/Grün.

**W0b (Mi–Fr, F1 14.08.; Nachlauf bis Di 18.08.) — A: 15 Posten, 40 h; B: 9, 21.5 h.** **[B-3 → §9: der D3-Bogen ist nicht mehr vollständig offen — D3-1 (Kern) und D3-2 sind am 08.08. gelandet (`ci/mess_ausbeute_wache.sh`, `7444d8c0`, an beiden Stationen eingehängt). Offen bleibt die Marker-Hälfte von D3-1, sie hängt an D3-7.]** Im D3-Bogen: PE-BauTestat→PE-PruefXOR (gleicher Vorzeilen-Helfer, mit `offen=`-Erweiterung der FEHLER-Zeile im selben Paket), PE-AllowFailure, PE-Rules, PE-PMCPreflight — sie sind die Testseite von D3-4/D3-5. Statistik-Härte: ST-MWU, ST-Winsor, ST-Perzentile. XL-L11-Abbildungsfunktion VOR XL-L1-Stufe-B; XL-L1-Stufe-A (Stolperdraht) sofort. LG-CsvAlt (Messdaten nie löschen — Schwester im CSV-Backend). HY-Gleichstand (heilt die zwei Break-Even-Engines, die der Router erbt — vor jedem HY-Bau). PK-F15Frei, MT-L5 (CI-Job `COMDARE_V32_DRIVER_ENABLE=ON` im Nachlauf; entsperrt MT-L10/L12 in W4), AS-OsPin. **F1-Testlieferung: kein Zähler lügt mehr über seine eigene Menge.**

**W1 (Mo–Fr 17.–21.08., F2 = Freeze) — A: 23 Posten, 99 h; B: 22, 62 h. Engpass des gesamten Plans (§8).** Reihenfolge hart: **MT-L3-Schema-Orakel VOR D4d** (der einen Spaltenänderung der Woche — sonst entsteht die neue Spalte am Orakel vorbei). PK-KanonWert/PK-Kreuztest/PK-KlemmJson auf dem D5-1-Kanon (liegt seit W0a-Lokalspur), PK-DeleteP99 mit D5-4. Statistik-Trio landet mit D4a–D4c; ST-CLITestat ersetzt die `PASS_REGULAR_EXPRESSION`-Wache (Wachen-Register ##31 kennt die Klasse). **HY-Reroute-Vertrag zuerst** (Concept, `gattung_of`-Pin, `kGenusCount` — definiert HY-A), dann HY-ModulGrenze atomar mit HY-A2 (F8-DoD), HY-Ebene4a nach dem 4.-Ebenen-Entscheid Mi 19.08. Lager-Kette: LG-HostBinder → LG-SkipCallback → LG-E2Exlsx + LG-WritebackXlsx (= Definition-of-done des Task-63-Strangs), LG-XlsxAlt, LG-LoadWache, LG-Idempotenz. PM-Naht, XL-L2, XL-L4. **Abnahme F2:** Invarianz-Beweis der Statistik grün NACH Heilung, HY-Verträge compile-hart, SKIP-Zweitlauf ruft den Mess-Callback 0-mal.

> WIEDERAUFNAHME-MARKER 18.08.2026 (Wellenplan par.21, Owner: NIE ausbuchen/verschieben): W1-Band-B (22 Posten,
> 62 h) ist nicht mehr gestrichen -- NEUE Platzierung W2-Randslots Mo/Di 24./25. + WE 22./23. +
> W3-Batch-Pausen [lok]; Wiederaufnahme-Register + Wellenplan par.21.3.

> ⚠️ **MARKER 12.08.2026 (KON39):** [D-1 → §10]: Bestand nicht null — 4 Header/943 Z., Genus sechswertig; der Vertrag PINNT, definiert nicht grundauf.

**W2 (Mo–Fr 24.–28.08., F3) — A: 8 Posten, 21 h; B: 23, 67 h.** Nur Mo/Di/Fr tragen Slots (Bau-Fenster Mi–Do ist exklusiv). Band A = Kampagnen-Wahrheit, Landung bis F3 als Teil der GO-Vorlage: MT-L1 (measured zählt Messung, Marker-Erhalt), MT-L2 (Token statt 0.000, Snapshot-Teil 3), MT-L6/L7, PM-m3v2Zero, PM-RAPL, PM-Scaled, PM-NichtGelesen-Seam. Band B (xlsx-Härtung, Perzentil-Folgeposten, AG-Pakete) nur bei freiem Slot Mo/Di.

**W3-MESS (Sa 29.08.–F4 04.09.) — 0 h neue Testarbeit.** Die W0b/W2-Gates SIND die Batch-Abend-Instrumente (Bilanz, Inhalts-Gate, Frische, HY-B „eine tote Reihe kann nicht gewinnen"). Band-B-Arbeit höchstens in Batch-Pausen als [lok] ohne Landung.

**W4 (07.–11.09., F5) — A: 3 Posten + HY-Ebene4b, 34 h; B: 4, 11 h.** HY-Kurvenlage/HY-Ausgaenge/HY-HonestEmpty mit HY-C (Router konsumiert HY-B-Kurven — deshalb nie früher), HY-Ebene4b. Danach, nur bei freiem Fangnetz: MT-L10/L12 (hinter MT-L5-Flag), MT-L11, AG-GenusCount-Vollausbau.

**W5 (12.–15.09.):** keine Test-Eingriffe; nur Nachweise (Köder-Protokolle, Nenner-Zeilen) in die Abgabe-Doku.

**W7 (Behälter):** Band C (5 Posten, 13 h: MT-L8, PM-PAPI, PM-WinPCM, PM-AmdL3 Teile 1–2, AG-PunktFixes, plus PM-NichtGelesen-HW) und alles aus Band B, was im Fenster nicht landete — als **gezählte Warteliste** (Start: 59 Posten, 166.5 h), nicht als stilles Vergessen.

> WIEDERAUFNAHME-MARKER 18.08.2026 (Wellenplan par.21, Owner: NIE ausbuchen/verschieben): der W7-Behaelter ist
> KEIN Endlager mehr -- Band C fahrbar (WinPCM: Windows-Runner online; AmdL3 -> #87; Rest W4), Band B ->
> W2-Randslots / W3-[lok] / W4; Wiederaufnahme-Register + Wellenplan par.21.3.

## 5. Die sequentielle Kette (eine Instanz)

1. ST-CTestWache — vor ihr ist jede neue Statistik-Wache unsichtbar. 2. MT-L4 + AS-Bewaffnung + HY-Label — die Wachen über den Wachen, vor W1, damit Neues selbst bewacht ist. 3. Rote Statistik-Suite schreiben (ST-Welch → ST-MultiCompare → ST-Diskrepanz/ST-Export gemeinsame Fixture → ST-CLITestat konsumiert die neuen Felder). 4. PE-BauTestat → PE-PruefXOR (ein Helfer, zweimal genutzt) im D3-Bogen; PE-AllowFailure/Rules/Preflight dort. 5. XL-L11 → XL-L1-B; LG-CsvAlt unabhängig. 6. HY-Gleichstand vor jedem Router-Code (der Router erbt die Engines). 7. MT-L5(b) CI-Job — ohne ihn sind MT-L10/L12 wertlos. 8. D5-1-Kanon (W0a) entsperrt PK-KanonWert → PK-Kreuztest → PK-KlemmJson; PK-DeleteP99 mit D5-4. 9. MT-L3 VOR D4d und VOR jeder End-Append-Spalte (auch der QFlag-Spalte, falls Variante drittes Feld). 10. HY-Reroute (Vertrag) → HY-ModulGrenze (mit HY-A2) → HY-Ebene4a. 11. LG-HostBinder → LG-SkipCallback → LG-E2Exlsx; LG-LoadWache/LG-Idempotenz nach ihrem kleinen Produktionsbau. 12. PM-m3v2Spalten (gemeinsame Spaltenliste) vor PM-Naht. 13. ST-HeurIdentisch-Fix vor ST-BreakEvenKreuz (sonst ist dessen Soll unentschieden). 14. AS-DupReject vor AS-OrganOrdnung. 15. AG-Concepts11 vor AG-IsComposition vor AG-Noexcept. 16. W4: HY-Kurvenlage/Ausgaenge/HonestEmpty nach HY-C-Stub; MT-L10/L12 nach 7.

## 6. Codex als stehender Kritiker

Befund aus diesem Lauf, mit Nenner: Codex lieferte die Rohbreite über 10 Teilgebiete und fand reale Kerne, die die erste Schärfungsstufe fallen ließ und die Meta-Stufe zurückholte (Codex #4, #9, #15 — alle drei halten). **Stark:** Breite, Klassenbildung, Schwesterstellen in bekannten Dateien. **Schwach, belegt:** (a) veralteter Stand — er arbeitete auf Vorfahr-SHA `85847715` gegen HEAD `7bcf353b`; sein gesamter Drift-Abschnitt war durch die D4-Heilung überholt; (b) Zeilenanker auf Nachbargegenstände (3 belegte Fälle in einer Datei); (c) Ganzheits-Behauptungen an Teilmengen gemessen (nur-ce-Greps, nur eine Testdatei); (d) Köder, die nicht beißen. Zugleich: die erste Schärfungsstufe war **nicht besser** (13 eigene Entwurfsfehler unter den 40).

**Einsatzregeln:** (1) Codex nur auf frisch gepinntem SHA, beide Repos, `tests/` gesamt. (2) Sein Output ist Kartierung, nie Zitat — jede tragende Referenz selbst lesen (zweistufiges Explore); keine Codex-Zeile und keine Codex-Zahl wandert ungeprüft in einen Test (K13). (3) Pflicht-Meta-Stufe: einstufig fällt ein Viertel; die Meta-Stufe fand zusätzlich 62. (4) Je Welle ein Codex-Pass über die **neu gebauten Tests** der Vorwelle (T-9) — dort war die Ausbeute am höchsten. (5) Nicht einsetzen für: Aufwandsschätzung, Wellen-Zuordnung, Owner-Entscheide — dreimal lagen seine Prioritäten quer zur Frist- und Blech-Realität.

## 7. Was NICHT getestet wird — ausdrücklich, mit Kosten

- **Band C, W7 (5 Posten, 13 h):** MT-L8 (env-gegateter, stillgelegter Legacy-Pfad; die Sach-Aussage deckt MT-L6 am Host — Kosten: 0, solange niemand reaktiviert) · PM-PAPI (toter Zweitpfad, Owner-Entscheid behalten/löschen steht aus; Kosten: ein nie übersetzter Pfad bleibt divergent) · PM-WinPCM (kein Windows-Runner im Fristpfad; Kosten: Windows-Zweig bleibt vertragslos) · PM-AmdL3 Teile 1–2 (braucht CAP_PERFMON-Lane; **Teil 0, Kommentar-Richtigstellung 0,2 h, sofort** — dokumentierter Widerspruch ist Defekt) · AG-PunktFixes (2 h Kosmetik ohne Fristbezug). Dazu PM-NichtGelesen-HW (prod2 gestrichen per OV-5(b); Kosten: die Klebrigkeits-Heilung bleibt hardwareseitig unbewiesen, der Seam-Test trägt allein).
- **Band B, planmäßig nur bei freiem Slot (59 Posten, 166.5 h):** vollständig registriert, geht ungelandet mit Zählern nach W7. Kosten je Block, ehrlich: AG-Pakete (33 h) — Concept-Trennschärfe und Layouts bleiben Konvention, ein gelockertes `requires` fällt erst als leere CSV-Spalte auf; XL-Härtung jenseits von Token/NA/Alt-Datensatz (31 h) — Vendor-Randfälle unbelegt, der Kern (zellgenaue Wahrheit, kein stilles Vernichten) ist Band A; AS-Block (17 h) — Registry-Drift wird nur von den W0a-Roundtrips gefangen, nicht semantisch; PK-Folgeposten (19 h) — der Kanon gilt, aber Produzenten-Grenzen (p999, super-Fixtures) bleiben ungepinnt.

> WIEDERAUFNAHME-MARKER 18.08.2026 (Wellenplan par.21, Owner: NIE ausbuchen/verschieben): beide Bloecke oben
> sind nur Historie -- die PM-WinPCM-Begruendung ist ueberholt (Windows-Runner 4/4 online seit #60 -> W2/W4
> fahrbar), PM-AmdL3 1-2 = Talos-Lane #87 (CAP_PERFMON, sobald v1.13.x), MT-L8/PM-PAPI/AG-PunktFixes -> W4;
> Band B (59 Posten, 166.5 h) geht nicht mehr "ungelandet nach W7", sondern W3-Batch-Pausen [lok] +
> W4/W4-Fangnetz; der Punkt "Bewusst nie getestet" bleibt unberuehrt. Wiederaufnahme-Register + Wellenplan
> par.21.3.
- **Bewusst nie getestet:** Holm/Bonferroni bei malformten p-Werten (Erzeuger liefern [0,1]; Methoden-Drift dokumentiert) · `v32_orchestrator`-Stub (dokumentiertes Soll auf totem Pfad) · alpha=1-Konstruktion (kein realer Eingang) · HDR-Histogramm (D5-5 entscheidet entfernen/führen; Test nur falls geführt).

## 8. Aufwand gegen Zeit

**Bedarf:** 117 Posten, 385.5 h ≈ 386 h. Bänder: **A = 53 Posten, 206 h** · **B = 59 Posten, 166.5 h** · **C = 5 Posten, 13 h**.

> ⚠️ **MARKER 12.08.2026 (KON39):** [D-4 → §10]: die S-Strecke (S-6, S-13, S-14, S-17…S-21) hat KEINE Testposten im 117er-Katalog — gezählte Warteliste in §10; Summen NICHT anfassen, bis durchgezählt.

**Deckung von Band A:** ~131.5 h davon sind die **Testseite bereits geplanter Bauten** und wandern in deren Paketbudgets (HY-Verträge 58 h → HY-A/C; Lager/xlsx-Facade 39 h → Task-63-Strang; Statistik 12 h → D4; Perzentil 17 h → D5; Planer 6.5 h → D3; MT-L5 4 h eigenes CI-Paket). Davon sind ~30 h in den D-Posten-Abnahmen (76 h, Wellenplan §2) schon eingepreist (Überschneidungen: ST-Trio↔D4a–c, ST-CLITestat↔D1e, PK-DeleteP99↔D5-4, PK-KanonWert-Seed↔D5-1, ST-CTestWache↔D2-G1/D1c, PE-Testate↔D3-4/D3-5). **Eigenständige neue Wachen in Band A: ~75 h.**

**Kapazität (Annahme, keine Messung — zweiter [lok]-Slot der Ein-Blech-Regel):** W-1 ~6 h · W0a ~8 h · W0b+Nachlauf ~18 h · W1 ~24 h · W2 ~10 h · W3 ~4 h (Batch-Pausen) · W4 ~24 h · zwei benannte Reserve-WE ~24 h = **~118 h**. Die ~75 h eigenständiges Band A passen hinein; die verbleibenden ~100 h Paket-Testseite erhöhen aber die erste Spur, die der Wellenplan bereits mit 26 von 27 Werktagen füllt.

> ⚠️ **MARKER 12.08.2026 (KON39):** [D-2 → §10]: die Stempel-Strecke (P-Posten) kommt ZUSÄTZLICH und fällt NIE; Band B/W1 (62 h) geschlossen gestrichen — §8-Bedingung (2) entschieden.

> WIEDERAUFNAHME-MARKER 18.08.2026 (Wellenplan par.21, Owner: NIE ausbuchen/verschieben): der D-2-Satz
> "Band B/W1 (62 h) geschlossen gestrichen" ist Historie -- die 22 Posten sind wiederaufgenommen und NEU
> platziert (W2-Randslots Mo/Di 24./25. + WE 22./23. nach S-19/T-15b + Rest W3-Batch-Pausen [lok]); der
> D-2-Marker bleibt stehen. Wiederaufnahme-Register + Wellenplan par.21.3.

**Die wichtigste Aussage: es passt NICHT alles — und der Engpass hat einen Namen: W1.** W1 trägt 99 h Band-A-Testarbeit in einer Woche, die schon D4/D5-Rest, Menge, HY-A und die Entwicklung der W2-Pakete enthält. W1 hält nur unter vier Bedingungen: (1) Vorziehen alles Lokalen in den W0b-Nachlauf (bis Di 18.08.), (2) die Reserve-WE 15./16.08. für die Testspur und 22./23.08. für HY-A **samt seiner Verträge** — der Wellenplan benennt letzteres nur für HY-A; dass die HY-Testverträge mitgemeint sein müssen, ist ein offener Konflikt und wird dem Owner so vorgelegt, nicht glattgerechnet; (3) Band B landet im Fenster planmäßig **gar nicht** (0 von 166.5 h eingeplant; jede gelandete B-Stunde ist Beifang eines frei gewordenen Slots); (4) TDD wird als Ersatz, nicht als Zusatz gebucht — der Test ist die Abnahme des Pakets, keine zweite Abnahme daneben. Reißt eine der vier Bedingungen, fällt zuerst Band A/W2-Randwerk (MT-L6/L7), dann XL-L1-Stufe-B auf W2 — **nie** fallen: ST-CTestWache, MT-L4, die Statistik-Begleittests, PK-KanonWert, LG-XlsxAlt/LG-CsvAlt (Messdaten nie löschen), die HY-Verträge (Owner: ALLES PFLICHT). Von 386 h Bedarf landen im Fenster somit planmäßig 206 h in 53 Posten; 179.5 h in 64 Posten gehen begründet und gezählt nach W7 — diese Zahl steht ab F1 als Zähler in jeder Wellen-Abnahme.
---

## 9. BERICHTIGUNGEN AM OBJEKT (nachgetragen 08.08.2026 abends)

Nichts hier ist gelöscht. Jede berichtigte Stelle steht oben unverändert und trägt den Verweis `[B-n]`; die neue Zahl steht hier **daneben**, mit **Zählweise**, **Nenner** und **Zustand**. Alle Messungen dieses Abschnitts sind am ce-Baum **`25fe4fbf`** erhoben — das ist der Gitlink, den super HEAD führt, nicht die Arbeitskopie des Submoduls (siehe §9.5, „Die Falle, die zuerst zuschlug").

### 9.1 · B-1 — „47 von 47 Stellen" ist mit keiner benannten Zählweise reproduzierbar

**Die Sachaussage hält, die Zahl nicht.** Am Objekt gilt weiterhin: *jede* Stelle, die das CSV-Schema prüft, zieht ihr Soll aus dem Erzeuger `lazy_csv_header()` selbst; **null** Stellen halten ein unabhängig eingefrorenes Schema dagegen. Das ist der Kern von MT-L3 und bleibt unberührt.

Die Zahl **47** ließ sich nicht herstellen. Sechs Zählweisen, jede einzeln benannt, am Baum `25fe4fbf`:

| # | Zählweise | Ergebnis | Nenner |
|---|---|---|---|
| Z1 | Aufruf-Stellen `lazy_csv_header()` unter `tests/**/*.cpp`, **ohne** Kommentarzeilen | **29 Stellen in 17 Übersetzungseinheiten** | 450 Test-`.cpp` im Baum; 35 Rohzeilen, davon 6 Kommentar |
| Z2 | dieselben Zeilen **mit** Kommentarzeilen | 35 in 17 | 450 |
| Z3 | Zeilen mit dem Token `lazy_csv_header` (auch ohne Klammern) unter `tests/` | 55 in 18 | 450 |
| Z4 | Aufruf-Stellen (ohne Kommentar) über **alle** `.cpp`/`.hpp` | 37 in 22 | 2387 |
| Z5 | Token-Zeilen über alle `.cpp`/`.hpp` | 84 in 33 | 2387 |
| Z6 | Token-Zeilen im **gesamten** getrackten Baum (inkl. `.md`, `.json`, CMake) | 119 in 48 | 5669 |

**Keine ergibt 47.** Am nächsten liegt Z6 mit 48 — aber das sind *Dateien*, nicht *Stellen*, und es sind 48, nicht 47. Die Zahl ist damit nicht „veraltet", sondern **ohne rekonstruierbare Herkunft**; sie ist genau der Fall, den §2 als Klasse `kein-nenner` führt, im Dokument, das die Klasse definiert.

**Die Zahl, die MT-L3 tragen kann, ist Z1: 29 Aufruf-Stellen in 17 Übersetzungseinheiten** — sie ist mit zwei unabhängigen Werkzeugen gleich gemessen (`git grep -F` gegen den Baum, und dateiweise `git show | grep -F`), beide Male 29/17.

**Der Zähler, den MT-L3 wirklich bewegen muss, ist ein anderer und er steht bei 1:** genau *eine* Testdatei führt den Voll-Header als Literal — `tests/unit/test_lazy_resume_binary.cpp:238`, und dort ist es ein **absichtlich veraltetes** Schema (`// veraltetes Schema`, Köder für den Resume-Mismatch), **kein Orakel**. Unabhängige eingefrorene Orakel: **0 von 29**. Wenn MT-L3 landet, muss diese 1 steigen — deshalb ist sie als Anker `PZW-SCHEMA-LITERAL` bewacht.

### 9.2 · B-2 — die Divergenz 429→456 / 428+27=455 ist erledigt, und sie war ein Sprung über zwei Grundgesamtheiten

§4 (W-1) führte die Divergenz als offen. **Sie ist geschlossen**: W-1 ist gelandet (super `ca901c50`, ce `1f88cfec`). Der Befund ist schärfer als „eine der beiden Zahlen war falsch" — **beide Zahlen des Sprungs stammten aus verschiedenen Zuständen**. Ausgerechnet in der Wache, die Zahlen ohne Nenner verhindern soll, stand eine Zahl ohne Nenner. Die vier Zustände, einzeln, mit ihrer Bedingung:

| Zahl | Zustand |
|---|---|
| **429** | frischer Configure, **vor** der Heilung |
| **431** | frischer Configure, **nach** der Heilung — das ist der einzige apples-to-apples-Vergleich (`429 → 431`, **+2**: die `*_NOT_BUILT`-Platzhalter) |
| **456** | Baum **nach dem Bau** der Binaries, also mit gelaufener gtest-Discovery |
| **460** | CI-Baum mit `all` + Reconfigure |

Damit ist auch die „431" aus §1 (`guard431.log`) eingeordnet: sie ist die Frisch-Configure-Zahl, nicht dieselbe Grundgesamtheit wie 456. Zusatzbefund aus demselben Lauf, der die Zählweise selbst betrifft: der SOLL-Scanner der Wache war **blind für die mehrzeilige `add_test(`-Schreibweise** — drei real registrierte Tests fehlten im SOLL (**277 → 280**); ihr Verschwinden wäre nicht gemeldet worden.

**Regel, die daraus folgt und für jede Kopfzeile dieses Plans gilt:** ein Vorher-Nachher-Sprung muss aus **demselben** Zustand stammen. Sonst Zustände einzeln nennen.

### 9.3 · B-3 — D3-1 und D3-2 sind GEFALLEN (`7444d8c0`); „NICHT GEFUNDEN" galt einem Dateinamen, nicht einer Sache

Das Kritik-Material meldete D3-1 und D3-2 als **NICHT GEFUNDEN**. Das war zum Meldezeitpunkt formal richtig und in der Sache irreführend: gesucht wurde `ci/measure_csv_gate.sh` — **diese Datei hat nie existiert**. Gebaut wurde dieselbe Sache unter anderem Namen.

| Posten | Stand am Objekt | Beleg |
|---|---|---|
| **D3-1 (Kern)** | **GEFALLEN** | `ci/mess_ausbeute_wache.sh`, Commit **`7444d8c0`**. Drei Zahlen (`N_CSV`/`N_MIT`/`SUMME` ≙ `csv_gesamt`/`csv_mit_datenzeile`/`datenzeilen_gesamt`, Z. 110–112) · `awk 'END{print NR}'` **statt** `wc -l` (Z. 95, Begründung Z. 47–50: `wc` zählt Zeilenumbrüche, eine Datei ohne Schluss-Newline meldete eine Zeile zu wenig) · **0 CSV = rot** (Z. 84–88) · `exit 2` statt Grün, wenn sie nicht prüfen konnte (Z. 42–43) |
| **D3-1 (Marker-Hälfte)** | **OFFEN** | „rot NUR bei `modus=voll` und Z==0" ist **nicht** gebaut: `modus=voll` und `provision_only` kommen in `ci/`, `scripts/` und `.gitlab-ci.yml` **0-mal** vor. Sie hängt an **D3-7** (Lauf-Marker), das nicht gelandet ist. Die Wache entscheidet stattdessen über ihr zweites Argument (Mindest-Datenzeilen), beide Stationen übergeben `1`. |
| **D3-2** | **GEFALLEN, vollständig** | Beide Stationen rufen den Helfer aus: `.gitlab-ci.yml:931` (`measure:smoke`) und `:1023` (`measure:golden-320`), je mit `test -x`-Vorspann (`:930`/`:1022`). Abnahmekriterium erfüllt, und beide Zustände einzeln genannt statt als Sprung: **vorher** (`7444d8c0^`) **2** Vorkommen bei 1421 Zeilen, `:822` und `:911`; **nachher** (HEAD) **0** Vorkommen bei 1539 Zeilen — beides mit `-F` gemessen (siehe B-4). Die Zeilenzahl selbst ist kein Vergleich: die Datei ist zwischen den Zuständen gewachsen. |

**Der Unterschied, der hier zählt:** „gefallen" heißt, die Behauptung des Kritik-Materials trägt nicht mehr. Es heißt **nicht** „erledigt". D3-1 ist zur Hälfte offen, und diese Hälfte bleibt in W0b stehen. Ein Posten, der als erledigt abgehakt wird, weil sein Kern landete, ist genau die Klasse `anwesenheit-statt-bedingung` aus §2 — eine Ebene höher.

**Und die Wache ist selbst gedeckt:** `ci/tests/mess_ausbeute_bissprobe.sh`, im CI als `test:mess-ausbeute-bissprobe` **ohne** `allow_failure`, mit `--selbstbiss` (Wegwerf-Mutanten, an denen die Probe rot werden MUSS). Das ist T-1 und T-7 am selben Gegenstand.

> ⚠️ **MARKER 12.08.2026 (KON39):** [D-3 → §10]: Shell-Bissproben sind Alt-Last — S-16-Migration zu Google Tests, Zielstruktur liefert die TEST-KONSOLIDIERUNG (KON37-08).

### 9.4 · B-4 — das Abnahmekriterium von D3-2 konnte nicht fehlschlagen

Das Kriterium ist im Wellenplan als `grep -c 'test -n "$(find'` == 0 notiert. **So geschrieben ist es wertlos**: das Muster enthält `$(`, und die Haus-Engine (ugrep) behandelt es ohne `-F` als Anker-Konstrukt und liefert eine **stille Null** — unabhängig davon, ob das Muster im Text steht. Ein „== 0" wäre dann kein Nachweis, dass der Defekt weg ist, sondern nur, dass das Werkzeug nicht gesucht hat.

**Literal nachgemessen am 08.08.**, auf `ci/tests/mess_ausbeute_bissprobe.sh` — einer Datei mit **5 echten Vorkommen**:

```
grep -c  'test -n "$(find' <datei>   ->  0   rc=1     [STILL FALSCH]
grep -cF 'test -n "$(find' <datei>   ->  5   rc=0     [richtig]
/usr/bin/grep -c 'test -n "$(find' <datei> -> 5   rc=0
```

**Präzisierung gegenüber `ci/tests/mess_ausbeute_bissprobe.sh:44`** (dort steht, `/usr/bin/grep` sei auf dieser Maschine ugrep): `/usr/bin/grep` ist auf prod1 **GNU grep 3.11** und liefert die richtige 5. Die stille Null entsteht am **blanken `grep`**, das in der Agenten-Shell eine Funktion ist und nach ugrep umleitet. Die CI ruft `sh` ohne diese Funktion und trifft GNU grep. **Der Befund hält, die Zuschreibung nicht** — und die Unterscheidung ist nicht kosmetisch: sie entscheidet, ob die Falle in der Pipeline lauert oder nur am Arbeitsplatz.

**Kriterium in seiner gültigen Form:** `grep -cF`, und die Null gilt erst **nach einem beißenden Köder** (Datei mit gewürfelter Vorkommens-Zahl, die exakt wiedergefunden werden muss). `ci/tests/mess_ausbeute_bissprobe.sh` (Fall F10) tut das bereits.

### 9.5 · Die Zahlen sind ab jetzt bewacht — und die Falle, die zuerst zuschlug

**`ci/plan_zahlen_wache.sh`** leitet die folgenden Anker bei jedem CI-Lauf neu aus dem Code ab und vergleicht sie mit diesem Dokument. SOLL kommt aus dem Plan, IST aus dem Code — **zwei Quellen** (T-3). Weicht eine ab, ist der Lauf rot und nennt beide Zahlen.

```
PZW-CE-SHA         = 5315005849fb145cb80dfde71f3f384b4b0b6a38
PZW-SCHEMA-STELLEN = 45
PZW-SCHEMA-DATEIEN = 24
PZW-SCHEMA-LITERAL = 2
PZW-CI-AUFRUFE     = 2
PZW-CI-ALTMUSTER   = 0
```

> UEBERHOLT-MARKER 24.08.2026 (par.13/D-7): die obige Ankertafel ist die PZW-Schema-Stellen-
> Zaehlung (`lazy_csv_header()`-Aufrufstellen) und bleibt fachlich unveraendert gueltig -- sie
> ist NICHT der ctest-Gesamtnenner (Floor-Anker). Der Floor-Anker (T-11b/T-17-Kombibau-Nenner,
> `scripts/ci_test_inventory_floor.txt`) ist durch die o2-Standard-Landung (Strang f82dfaeb,
> Lead-Merge b3dc3e93 lokal fertig/ungepusht) von 544/540/538 auf 545/541/539 gestiegen
> (+1-Regel `test_o2_standard_opt_default`) -- s. par.13.2/D-7 fuer die Herleitung. Zwei
> verschiedene Einheiten, zwei verschiedene Zahlen; wer sie verwechselt, wiederholt die
> Fehlerklasse, die dieser par.9-Abschnitt selbst korrigiert.

[PROSA-NACHTRAG 25.08.2026 (A2.5-FIX-R1, Di-25-docs-Anteil 'UEBERHOLT-MARKER-Prosa', L3-Restposten 2): der Klammer-Zusatz 'Lead-Merge b3dc3e93 lokal fertig/ungepusht' im UEBERHOLT-MARKER oben ist seit der o2-Standard-Landung UEBERHOLT -- b3dc3e93 (Merge bau/o2-standard, 23.08. 21:11Z) ist Vorfahr von ce development und beidseitig gepusht (Kette bis 943c70ee, CI 286 Pipeline 16150 @ 943c70ee SUCCESS; Floor-Anker LIVE 545/541/539, KON123-01). Der Marker-Kern (Ankertafel = PZW-Schema-Stellen, NICHT der Floor-Anker) gilt unveraendert. Additiv, nichts umgeschrieben; Beleg ~/backups-workflow/20260824-rest-landung/a25-fix-r1/ (Ancestry-Probe git merge-base --is-ancestor b3dc3e93 development = JA).]

[LANDE-STAND-NACHTRAG 24.08.2026 spaet (Rest-Landung L2): Zweig bau/wellenplan-offene-punkte @ dec105ae per --no-ff harmonisiert in development gelandet -- obiger UEBERHOLT-MARKER (Zweig-Fassung) und der NACHZUG 24.08. darunter (development-Fassung) leben beide, EINE Fassung mit beiden Absichten; Zahlen-Nachzug der Ankertafel nach der ce-Landung = eigener Di-25-docs-Zug.]

> NACHZUG 01.09.2026 abends (super-Gitlink-Bump E-1-Zombie-Fix, ce dd0f56d3 -> `53150058` -- der Bump
> faehrt ATOMAR im selben Commit wie dieser Nachzug; WIE GEMESSEN mit den Formeln der Wache selbst ueber
> COMDARE_PLAN-Kopie): SCHEMA-STELLEN unveraendert **45**, SCHEMA-DATEIEN unveraendert **24**,
> LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 -- die gelandete Kette dd0f56d3..53150058 (11 Commits:
> E-1-Fixe bef74b1c..cb790b45 [10, nur ci_yaml_emission-Familie + Test-TU-Erweiterung + Kommentare] +
> Lande-Merge 53150058) beruehrt KEINE `lazy_csv_header()`-Aufrufstelle. Nenner **573** Test-.cpp
> UNVERAENDERT (E-1 erweiterte eine bestehende Test-TU um 2 TESTs, keine neue Datei); .gitlab-ci.yml-Nenner
> 2974 -> 2976 (+2 durch den ergebnis:holen-F7-Umbau im selben Zug, kein Anker). Drift-Biss VOR dem
> Nachzug rc=2 belegt ('Plan=dd0f56d3... Gitlink=53150058...', wachen-lauf.log). Nur der CE-SHA der
> Ankertafel wandert. Beleg-Logs: ~/backups-workflow/20260901-push-fenster/pzw-kontrolllauf.log +
> wachen-lauf2.log. Vorheriger Nachzug darunter.
> NACHZUG 01.09.2026 vormittags (super-Gitlink-Bump E-10 + Stempel-2 + cppcheck-Fix, ce bd55942a ->
> `dd0f56d3` -- der Bump faehrt ATOMAR im selben Commit wie dieser Nachzug und der E-10-XSD-Patch
> (E-4); WIE GEMESSEN, nicht gerechnet, mit den Formeln der Wache selbst ueber COMDARE_PLAN-Kopie +
> COMDARE_GITLINK_SHA): SCHEMA-STELLEN unveraendert **45**, SCHEMA-DATEIEN unveraendert **24**,
> LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 -- die gelandete Kette bd55942a..dd0f56d3 (15 Commits:
> E-10/ORG-19 3f360d85..2e9b8697 [8] + Lande-Merge 5e03c2cc + Stempel-2 360fe107..bb5b6949 [4] +
> Lande-Merge ffb512a6 + cppcheck-Fix dd0f56d3) beruehrt KEINE `lazy_csv_header()`-Aufrufstelle
> (git log -S ueber tests/*.cpp: 0 Commits). Nenner **573** Test-.cpp (vorher 567 @ bd55942a: +6 neue
> Test-TUs der Kette: test_e10_gate_per_binary, test_e10_organ_meta_meta_anlage, test_e10_organ_stamp_je_comp,
> test_org19_meta_meta_requirement, test_stempel2_modul_emitter, test_stempel2_vertragspaare), 64 Rohzeilen,
> Kommentar abgezogen; .gitlab-ci.yml-Nenner 2974 unveraendert. Drift-Biss VOR dem Nachzug rc=2 belegt
> ('Plan=bd55942a... Gitlink=dd0f56d3...'); Kontroll-Lauf am Alt-Baum bd55942a reproduziert 45/24/2/2/0
> @ 567. Nur der CE-SHA der Ankertafel wandert. Beleg-Logs:
> ~/backups-workflow/20260829-lande-e10-stempel2/super-bump2/pzw/pzw-*.log. Vorheriger Nachzug darunter.
> NACHZUG 28.08.2026 abends (super-/prt-art-Lande-Zug #153, Gitlink-Bump ce d3b5a393 ->
> `bd55942a` -- der Bump faehrt ATOMAR im selben Lande-Commit wie dieser Nachzug; WIE
> GEMESSEN, nicht gerechnet, mit den Formeln der Wache selbst ueber COMDARE_PLAN-Kopie +
> COMDARE_GITLINK_SHA): SCHEMA-STELLEN unveraendert **45**, SCHEMA-DATEIEN unveraendert
> **24**, LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 -- die gelandete Identitaets-Kette
> d3b5a393..bd55942a (24 Commits: konform 41bf4c62 + pmc-dtlb-koeder 20d6dd2c + vo3-1
> 01dc3122 + a5-reuse 8c861759 + gitleaks-Regel cc85bb91 + Komplex-Fix 60d997a6/63edf870/
> e5cc566d + Heilung bd55942a) beruehrt KEINE `lazy_csv_header()`-Aufrufstelle. Nenner
> **567** Test-.cpp (vorher 564 @ d3b5a393: +3 Test-TUs der Kette), 64 Rohzeilen, Kommentar
> abgezogen; .gitlab-ci.yml-Nenner im Commit selbst um den VO3-1-Nachtrag-Kommentar gewachsen.
> Drift-Biss VOR dem Nachzug rc=2 belegt ('Plan=d3b5a393... Gitlink=bd55942a...'); Kontroll-
> Lauf am Alt-Baum d3b5a393 reproduziert 45/24/2/2/0 @ 564. Nur der CE-SHA der Ankertafel
> wandert. Beleg-Logs: ~/backups-workflow/20260827-lande-reif/super-zug/super/pzw-*.log.
> Vorheriger Nachzug darunter.
> NACHZUG 25.08.2026 vormittags (A2.5-FIX-R1 der Rest-Landung; Gitlink-Ziel ce
> `d3b5a393` -- der Bump faehrt ATOMAR im selben Lande-Commit wie dieser Nachzug;
> WIE GEMESSEN, nicht gerechnet): SCHEMA-STELLEN unveraendert **45**, SCHEMA-DATEIEN
> unveraendert **24** -- der gelandete Merge d3b5a393 (L-06 Warnungs-Review Endstand-
> Runde: 10 Compiler-Warnungen in 3 Test-TUs geheilt, Fix-Commit 1aee9a1f; ce-CI 286:
> 16213 SUCCESS) beruehrt KEINE `lazy_csv_header()`-Aufrufstelle (git diff
> 2168f60c..d3b5a393 -- 'tests/*.cpp' | grep -c lazy_csv_header = 0). Nenner unveraendert
> **564** Test-.cpp (Kette 2168f60c..d3b5a393, 2 Commits, 0 neue Test-.cpp); 64 Rohzeilen,
> Kommentar abgezogen. LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 @ 2968 Z. .gitlab-ci.yml.
> LIVE gemessen mit den Formeln der Wache selbst (git grep -F gegen den Baum
> `d3b5a393`); Kontroll-Lauf derselben Formeln am Alt-Baum `2168f60c` reproduziert
> exakt 45/24/2/2/0 @ 564 Test-.cpp / 64 Rohzeilen. Drift-Biss VOR dem Nachzug rc=2 belegt;
> Gegenprobe ueber den Bissproben-Kanal COMDARE_GITLINK_SHA nach dem Nachzug: '5 von 5
> Ankern decken sich mit dem Objekt'. Nur der CE-SHA der Ankertafel wandert. Beleg-Log:
> ~/backups-workflow/20260824-rest-landung/a25-fix-r1/pzw_zaehlung_d3b5a393.log.
> Vorheriger Nachzug darunter.
> NACHZUG 24.08.2026 nachts (Rest-Landung L3/K3-Gitlink-Nachzug; Gitlink-Ziel ce
> `2168f60c` -- der Bump faehrt ATOMAR im selben Lande-Commit wie dieser Nachzug;
> WIE GEMESSEN, nicht gerechnet): SCHEMA-STELLEN 44 -> **45**, SCHEMA-DATEIEN
> unveraendert **24** -- die neue Stelle traegt
> `tests/unit/test_s13_03_per_binary_mappe.cpp:217` (W2-Abschluss-Fixes #139 Phase 2,
> ce-Merge 2168f60c, CI 286: 16209 SUCCESS). Nenner unveraendert **564** Test-.cpp
> (Kette 943c70ee..2168f60c, 7 Commits, 0 neue Test-.cpp); 64 Rohzeilen, Kommentar
> abgezogen. LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 @ 2968 Z. .gitlab-ci.yml.
> LIVE gemessen mit den Formeln der Wache selbst (git grep -F gegen den Baum
> `2168f60c`); Kontroll-Lauf derselben Formeln am Alt-Baum `943c70ee` reproduziert
> exakt die Alt-Anker 44/24/2/2/0 @ 564 Test-.cpp / 63 Rohzeilen. Gegenprobe ueber
> den Bissproben-Kanal COMDARE_GITLINK_SHA nach dem Nachzug: '5 von 5 Ankern decken
> sich mit dem Objekt'; Drift-Biss VOR dem Nachzug rc=2 belegt. Der PZW-Anteil des
> Di-25-Vorbehalts der LANDE-STAND-Zeile oben ist damit HIER vollzogen (die Wache
> koppelt den Plan-Anker an den Gitlink: ohne Nachzug im selben Commit waere
> docs:plan-zahlen-wache rot); beim Di-25-docs-Zug verbleiben UEBERHOLT-MARKER-Prosa
> und N-33(e)/RN-27. Beleg-Log: ~/backups-workflow/20260824-rest-landung/
> L3-gitlink-nachzug/pzw_zaehlung_2168f60c.log. Vorheriger Nachzug darunter.
> NACHZUG 24.08.2026 abends (W2-S1+S2-Lande-Zug/Z23, Fahrplan Board #131; Gitlink-Ziel ce
> `943c70ee` -- der Bump faehrt ATOMAR im selben Lande-Commit wie dieser Nachzug, zusammen
> mit dem prt-art-Gitlink `d11781fa` -> `16c90628`; WIE GEMESSEN, nicht gerechnet):
> SCHEMA-STELLEN 42 -> **44**, SCHEMA-DATEIEN 23 -> **24** -- beide neuen Stellen traegt
> `tests/unit/test_s13_03_per_binary_mappe.cpp` (S13-03 per-Binary-Mappe/Resume-Vertrag,
> Lande-Merge 4/10 b283f86c). Nenner 530 -> **564** Test-.cpp (+34 der Kette
> 66de5c09..943c70ee, 45 Commits: die 10 S1+S2-Merges s19/messfenster/s8kopf/s13schema/
> pmcpaket/vollzug91/ph89/trigfix/skip97/kampvor + H-5/F-10-Nachzug + o2-standard/E-7 +
> axis-lock-Regen); 63 Rohzeilen, Kommentar abgezogen. LITERAL/AUFRUFE/ALTMUSTER
> unveraendert 2/2/0 @ 2968 Z. .gitlab-ci.yml. LIVE gemessen mit den Formeln der Wache
> selbst (git grep -F gegen den Baum `943c70ee`); Kontroll-Lauf derselben Formeln am
> Alt-Baum `66de5c09` reproduziert exakt die Alt-Anker 42/23/2/2/0 @ 530 Test-.cpp.
> Gegenprobe ueber den Bissproben-Kanal COMDARE_GITLINK_SHA nach dem Nachzug: '5 von 5
> Ankern decken sich mit dem Objekt'. Beleg-Log: ~/backups-workflow/20260822-lande-zug/
> Z23/pzw_zaehlung_943c70ee.log. Vorheriger Nachzug darunter.
> NACHZUG 20.08.2026 mittags (L4-super-Zug/KON119; Gitlink-Ziel ce `66de5c09` -- der Bump
> faehrt ATOMAR im selben Lande-Commit wie dieser Nachzug; WIE GEMESSEN, nicht gerechnet):
> SCHEMA-STELLEN 41 -> **42**, SCHEMA-DATEIEN 22 -> **23** -- die neue Stelle traegt
> `tests/unit/test_lg_skip_callback_null.cpp` (F2-5-Kleinbau). Nenner 513 -> **530** Test-.cpp
> (+17 neue Test-.cpp der Kette 196a621a..66de5c09, 91 Commits: q2-/a11-Modul-Fixturen,
> hy_f8/hy_a1/hy_a2, hybrid_tier_module(+_set), g2-, b3-, #102-axis_kind-, F2-5-, s6c-Klassen);
> 61 Rohzeilen, Kommentar abgezogen. LITERAL/AUFRUFE/ALTMUSTER unveraendert 2/2/0 @ 2945 Z.
> .gitlab-ci.yml. LIVE gemessen mit den Formeln der Wache selbst (git grep -F gegen den Baum
> `66de5c09`); Gegenprobe ueber den Bissproben-Kanal COMDARE_GITLINK_SHA nach dem Nachzug:
> '5 von 5 Ankern decken sich mit dem Objekt'. Vorher-Beleg: Wache regulaer am HEAD-Gitlink
> `20c111c4` rc=0 (41/22/2/2/0, Nenner 513/60). Beleg-Log: ~/backups-workflow/
> 20260820-l4-super-kon119/pzw_zaehlung.log. Vorheriger Nachzug darunter.
> NACHZUG 18.08.2026 frueh (Gitlink ce `20c111c4`, Welle-2-Landung xorf+f3v+a11 + 2 CI-Fixes):
> Zahlen am neuen Baum LIVE gemessen (Wache-Formeln). Vorheriger Nachzug darunter.
> NACHZUG 17.08.2026 spaetnachts (Gitlink ce `965b121a`, W1-Landung + 2 CI-Fix-Zuege,
> super-k2-Zug): STELLEN/DATEIEN am neuen Baum LIVE gemessen (Formeln der Wache selbst);
> die W1-Testdateien (hy-a/vl3/k2) tragen die Delta-Stellen. Alte Werte bleiben unten
> als Historie.
> NACHZUG 17.08.2026 (Gitlink ce `04ac26fa`, golden-Fenster-Landung): SCHEMA-STELLEN 40 -> **41**,
> SCHEMA-DATEIEN 21 -> **22** — die B2-Gate-Trennung des Fensters traegt eine zusaetzliche
> Schema-Stelle in einer neuen Testdatei (Zaehlweise der Wache: 507 Test-.cpp am Gitlink-Baum,
> Rohzeilen minus Kommentare). Alte Zahlen bleiben oben in der Historie dieses Abschnitts sichtbar;
> der Anker-Block traegt die gemessenen neuen Werte.

**Nachzug 15.08.2026 (dritter Zug des Tages) -- zwoelfter Gitlink-Zug (W-B-Stufe-1-Landung
nach Nachstufe, KON76-02), und zum neunten Mal in Folge bewegt sich KEINE der fuenf Zahlen.
Die vorherige Fassung bleibt darunter stehen.**

Der Gitlink zieht von `0817c7bf` auf **`8fe66469`** (1 Merge: `8fe66469` 'Landung:
bau/prtart-waisen-archiv in development (--no-ff)' @ Branch-Tip `00d3910a`, 8 Dateien --
4 R100-Renames der prt-art-Legacy-Waisen nach `tests/deprecated/`, VERMERK.md, Allowlist-
und `test_pa1`-Anpassung, Test-Map-Nachzug; KEINE neue Test-`.cpp`, KEINE ce-CI-Beruehrung.
ce-Pipeline **15879 TERMINAL SUCCESS** @ `8fe66469`: 25 success + 1 manual von 27,
is_original:relock = deklarierte Ausnahme, 0 failed.) Die Verschiebung der 4 Waisen-Dateien
INNERHALB des Baums laesst alle fuenf Zaehlwerke unberuehrt (Nenner bleibt 504 Test-`.cpp`).

| Anker | alt (Stand `0817c7bf`) | neu (Stand `8fe66469`) | Zaehlweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `0817c7bf51089...` | **`8fe66469af9de...`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | 504 Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 504 Test-`.cpp` im Baum `8fe66469` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 504 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2945 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2945 Zeilen, Muster mit `-F` |

**Vorherige Fassung (Stand `0817c7bf`, elfter Zug):**

Der Gitlink zieht von `04f76b65` auf **`0817c7bf`** (1 Merge: `0817c7bf` 'merge(traeger/#29):
Skeleton der vier Traeger-Unterprojekte' @ Branch-Tip `be2d9e4e`, 10 Dateien / 132 Insertions,
nur Adds: Wurzel-`CMakeLists.txt` + `libs/traeger/` mit CMakeLists+README je {planner,ceb,tier,
hybrid} -- KEINE Datei unter `tests/`, keine ce-CI-Beruehrung. ce-Pipeline **15832 TERMINAL
SUCCESS** @ `0817c7bf`: 26 success + 1 manual von 27, die vier Zellen test:unit 875 s /
test:unit:debug 512 s / test:unit:clang 91 s / test:unit:clang:debug 147 s alle gruen,
test:coverage-guard 1282 s; is_original:relock = deklarierte Ausnahme, 0 failed.)

| Anker | alt (Stand `04f76b65`) | neu (Stand `0817c7bf`) | Zaehlweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `04f76b65bf6c2...` | **`0817c7bf51089...`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | **504** Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 504 Test-`.cpp` im Baum `0817c7bf` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 504 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | **2945** Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2945 Zeilen, gemessen **mit** `-F` |

**Warum sich nichts bewegt -- mit der Wache selbst am Baum `0817c7bf` erhoben** (`sh
ci/plan_zahlen_wache.sh` rc=0, Protokoll: '5 von 5 Ankern decken sich mit dem Objekt'; Nenner
unabhaengig gegengemessen: `git ls-tree -r 0817c7bf` liefert 504 Test-`.cpp`, die super-CI-YML
hat 2945 Zeilen): der Zug fuegt in ce ausschliesslich das Traeger-Skeleton hinzu (Unterprojekt-
Geruest ohne Quell- oder Testdateien) -- der Test-`.cpp`-Nenner bleibt 504, Treffer exakt
40/21/2. Die super-`.gitlab-ci.yml` ist in diesem Zug unberuehrt (der Z2-Merge `dbed284b` traegt
nur `docs/sessions/backups/20260815-branch-archiv-d12/`); beide CI-Muster unveraendert
(2 Aufrufe, 0 Altmuster).

**Nachzug 15.08.2026 — zehnter Gitlink-Zug (LANDE-ZUG CI-DUAL + LIZENZ, v4.3/#56; Task-Frame
Z5), und zum siebten Mal in Folge bewegt sich KEINE der fünf Zahlen. Die vorherige Fassung bleibt
darunter stehen.**

Der Gitlink zieht von `4f18f478` auf **`04f76b65`** (4 Commits: CI-DUAL-Landungs-Merges `7858f70a`
(bau/ci-dual-ce @ 61d9edd1: 4-Zellen-Matrix {gcc,clang} x {Release,Debug}, 3 neue Jobs, ccache-
Writer-Wechsel clang-Key) / `edbe2811` (bau/ci-dual-emission @ 731b5655: Traegerstufen-Emission
gcc-15-Pins + clang-22-Zwilling, E1–E5) + K13-Testfix `04f76b65`: d2-Koeder strukturell nicht-
numerisch — Heilung der roten ce-Pipeline 15810 (test:unit Job 377638, Koeder 628959349117 war
rein numerisch, p=(10/16)^12; test:unit:debug skipped via needs). ce-Pipeline **15811 TERMINAL
SUCCESS** @ `04f76b65`: 26 success + 1 manual von 27 — die vier Zellen test:unit 995 s /
test:unit:debug 408 s / test:unit:clang 776 s / test:unit:clang:debug 504 s alle gruen;
is_original:relock = deklarierte Ausnahme, 0 failed.)

| Anker | alt (Stand `4f18f478`) | neu (Stand `04f76b65`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `4f18f478f1bde…` | **`04f76b65bf6c2…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | **504** Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 504 Test-`.cpp` im Baum `04f76b65` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 504 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | **2945** Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2945 Zeilen, gemessen **mit** `-F` |

**Warum sich nichts bewegt — mit der Wache-Formel am Baum `04f76b65` frisch erhoben** (git grep -F
gegen den Baum, Kommentarzeilen abgezogen; identische Formeln wie `ci/plan_zahlen_wache.sh`): der
Zug beruehrt in ce nur `.gitlab-ci.yml`, `test_t6_wachen_inventar.cpp` (+3 Job-Zeilen, keine
Schema-Stelle), Planer-Emission (`experiment_plan_director.hpp` + Test, keine Schema-Stelle) und
den d2-Koder-Fix — Test-`.cpp`-Nenner bleibt 504, Treffer exakt 40/21/2. Die super-`.gitlab-ci.yml`
wuchs durch den CI-DUAL-Merge `81aa80f6` (2835 → 2945 Zeilen); beide CI-Muster unveraendert
(2 Aufrufe, 0 Altmuster). R1-NEUAUSZAEHLUNG im selben Zug: `thesis_profiles`-Nenner **9 → 11**,
alle 11 mit aktivem `<method value="xlsx"/>` (KF #24, 14.08.) — s. Marker beim D-5-Posten.

**Nachzug 14.08.2026 — neunter Gitlink-Zug (STUFE-3-LANDUNG der Drei-Stufen-Landung, KON60/KON61,
inkl. Lint-Fix nach roter ce-Pipeline 15792), und zum sechsten Mal in Folge bewegt sich KEINE der
fünf Zahlen. Die vorherige Fassung bleibt darunter stehen.**

Der Gitlink zieht von `5f3f26a5` auf **`4f18f478`** (16 Commits: Stufe-1-Landungs-Merges `d215b127`
(S-7) / `0304ebf1` (Wachen-Floor) / `a6804dfa` (P6) + Floor-Nachzug `643102fb` (492/488/486) +
KF-Stufe-2-Commits `fbe506ee`/`fbe48f99`/`2a3b1eb0` + Lint-Fix `4f18f478`: clang-format-Parität
(2 Lizenz-Testdateien, reine Re-Wraps) + NSDMI `SignaturWelt::name`/`JobEintrag::art` — Heilung der
roten ce-Pipeline 15792 (lint:format Job 377292 + lint:static Job 377293); ce-Pipeline 15793
TERMINAL SUCCESS @ `4f18f478`, status=success, finished_at 2026-08-14T13:39:29.790Z, duration
2345 s, Jobs 23 success + 1 manual von 24 — is_original:relock = deklarierte Ausnahme, 0 failed).

| Anker | alt (Stand `5f3f26a5`) | neu (Stand `4f18f478`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `5f3f26a5294f7…` | **`4f18f478f1bde…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | **504** Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 504 Test-`.cpp` im Baum `4f18f478` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 504 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2835 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2835 Zeilen, gemessen **mit** `-F` |

**Warum sich nichts bewegt — mit der Wache-Formel am Baum `4f18f478` frisch erhoben** (git grep -F
gegen den Baum, Kommentarzeilen abgezogen; identische Formeln wie `ci/plan_zahlen_wache.sh`): der Zug
bringt netto 3 neue Test-`.cpp` (Nenner 501 → 504) und die Lint-Heilung (Re-Wraps + 2 NSDMI); die
Treffer-Zahlen bleiben exakt 40/21/2. Die super-`.gitlab-ci.yml` wuchs durch die Stufe-1-Merges
(2768 → 2835 Zeilen); beide CI-Muster unverändert (2 Aufrufe, 0 Altmuster).

**Nachzug 13.08.2026, mittags — achter Gitlink-Zug (WELLEN-LANDUNG P1+P11, KON58/§18), und zum
fünften Mal in Folge bewegt sich KEINE der fünf Zahlen. Die vorherige Fassung bleibt darunter
stehen.**

Der Gitlink zieht von `f23c18e2` auf **`5f3f26a5`** (die A2.1a-Wellen-Landung: Merge P1
`4c37116a` = S-3-Ordnungsrelation + Merge P11 `b91b22fc` = S-14a-Riegel über den Overlay-Schnitt
+ Floor-Neumessung `5f3f26a5` — **ce-Pipeline 15785 TERMINAL SUCCESS**, ctest 488/488 lokal,
Floor-Sprossen **489/485/483** je Host-Klasse).

| Anker | alt (Stand `f23c18e2`) | neu (Stand `5f3f26a5`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `f23c18e2db974…` | **`5f3f26a5294f7…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | **501** Test-`.cpp` im Baum, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 501 Test-`.cpp` im Baum `5f3f26a5` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 501 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2768 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2768 Zeilen, gemessen **mit** `-F` |

**Warum sich trotz Nenner-Wachstum (498 → 501 Test-`.cpp`) keine Zahl bewegt:** die drei neuen
Dateien sind exakt die Zugänge des Zugs (`test_s3_ordnung_freigabe.cpp`,
`test_s3_ordnung_relation.cpp`, `test_s14_axis_version_lock_tripwire.cpp` — per
`diff --name-only --diff-filter=A` am Zug gemessen), und der Zug berührt `lazy_csv_header`
an **0** Stellen (`git diff f23c18e2..5f3f26a5 -- 'tests/*.cpp' | grep -c` = 0); die
super-CI-YAML ist unberührt (2768 Zeilen). Dasselbe Muster wie beim vierten bis siebten Zug:
der Nenner zählt **Dateien**, die Anker zählen **Stellen**. *(Die Erwartung wurde vor dem
Commit aus der Zug-Differenz abgeleitet und von der Wache nach dem Commit bestätigt — die
CI-Formel ist die CI-Formel, der Wachen-Lauf ist der Beleg, nicht diese Ableitung.)*

**Nachzug 13.08.2026 — siebter Gitlink-Zug (Q6-Kommentar-Nachzug, KON58-02), und zum vierten Mal
in Folge bewegt sich KEINE der vier Zahlen. Die vorherige Fassung bleibt darunter stehen.**

Der Gitlink zieht von `7d65eb6c` auf **`f23c18e2`** (Merge des Q6-Branchs `bau/q6-dock32-nachzug`:
der 32er-Dock-Entscheid an vier Stellen nachgetragen — KON28-03/KON41-03/KON42-01; ce-Pipeline
15774 TERMINAL SUCCESS, Merge-Baum `92a107ef` == `merge-tree`-Vorhersage).

| Anker | alt (Stand `7d65eb6c`) | neu (Stand `f23c18e2`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `7d65eb6c2ffd3…` | **`f23c18e2db974…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | 498 Test-`.cpp` im Baum, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 498 Test-`.cpp` im Baum `f23c18e2` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 498 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2768 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2768 Zeilen, gemessen **mit** `-F` |

**Warum sich nichts bewegt — diesmal ist der Beleg der Diff selbst:** der Zug ändert **genau drei
Dateien** (`20260802-hybrid_tier_stufe_soll_design.md`, `hybrid/README.md`,
`heuristik_adapter_synthese_matrix.hpp`; +30/−1). Davon sind **0** Test-`.cpp`, **0** tragen
`lazy_csv_header`, **0** ist die CI-YAML — gemessen am Diff, nicht am Ergebnis. Der Nenner bleibt
bei 498, weil keine neue Test-Datei entsteht. *(Gegenprobe, dass das Zählwerkzeug sucht: der Diff
führt insgesamt 3 Dateien — die Nullen stehen also neben einer Nicht-Null.)*

🔴 **EINE EIGENE FEHLMESSUNG BEIM NACHZIEHEN, protokolliert, weil sie die §9.5-Regel bestätigt:**
ich hatte die Anker zuerst von Hand nachgezählt und **40/23/1** erhalten statt der Wachen-Werte
**40/21/2**. Zwei verschiedene Fehler in einer Messung: die Datei-Zählung lief über `awk -F:` auf
die Rohzeilen und nahm damit die Kommentar-Treffer mit (dieselbe `-l`-Falle wie am 09.08., nur mit
anderem Werkzeug), und für `SCHEMA-LITERAL` hatte ich schlicht das **falsche Muster** gegriffen.
**Die CI-Formel ist die CI-Formel** — die Wache wurde gefahren, ihre Zahlen stehen oben, meine
Handmessung ist verworfen.

---

**Nachzug 12.08.2026, spätabends — sechster Gitlink-Zug (Zweitlens-Härtungs-Merge, KON57), und
wieder bewegt sich KEINE der vier Zahlen. Die vorherige Fassung bleibt darunter stehen.**

Der Gitlink zieht von `671d7f6a` auf **`7d65eb6c`** (Merge des Fixup-Branchs
`bau/s1-codex-haertung`: 11+1 Zweitlens-Fixes über 13 Dateien, +344/−116; Dual-Review
geschlossen, Kombibau 4×485/485 — Details KON57).

| Anker | alt (Stand `671d7f6a`) | neu (Stand `7d65eb6c`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `671d7f6a0d678…` | **`7d65eb6c2ffd3…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | 498 Test-`.cpp` im Baum, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 498 Test-`.cpp` im Baum `7d65eb6c` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 498 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2768 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2768 Zeilen, gemessen **mit** `-F` |

**Warum sich trotz 13 geänderter Dateien keine Zahl bewegt:** die Härtung legt **keine neue
Test-`.cpp`** an (der neue Header `stempel_baustein_trait.hpp` ist kein Test — der Nenner
bleibt 498) und ruft `lazy_csv_header()` an keiner neuen Stelle; die super-CI-Datei ist
unberührt. Dasselbe Muster wie beim vierten und fünften Zug: der Nenner zählt **Dateien**,
die Anker zählen **Stellen**.

**Nachzug 12.08.2026, abends — fünfter Gitlink-Zug (Strang-C+A-Landung, ##25/F1 + S-1), und
wieder bewegt sich KEINE der vier Zahlen. Die vorherige Fassung bleibt darunter stehen.**

Der Gitlink zieht von `670483c0` auf **`671d7f6a`** (überspringt den Zwischenstand `a99c4a18`
— der Bump-Bereich trägt damit Strang D + C + A: die Guard-Wachen, den Katalog-Emitter-Fix und
die S-1-Stempel-Basisklasse, 17 Commits).

| Anker | alt (Stand `670483c0`) | neu (Stand `671d7f6a`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `670483c084293…` | **`671d7f6a0d678…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | 498 Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 498 Test-`.cpp` im Baum `671d7f6a` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 498 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2768 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2768 Zeilen, gemessen **mit** `-F` |

**Warum sich trotz Nenner-Wachstum (497 → 498 Test-`.cpp`, +`test_s1_stempel_basis_vertrag.cpp`)
keine Zahl bewegt:** weder der Katalog-Emitter-Fix (C: `measurement_stamp`-Durchreichung) noch
die Stempel-Basisklasse (A) rufen `lazy_csv_header()` — dasselbe Muster wie beim dritten und
vierten Zug: der Nenner zählt **Dateien**, die Anker zählen **Stellen**.

**Nachzug 11.08.2026, nachts — vierter Gitlink-Zug, und KEINE der vier Zahlen bewegt sich.
Die vorherige Fassung bleibt darunter stehen (Doku wird deprecatet, nicht gelöscht).**

Der Gitlink zog von `e114cabd` auf **`670483c0`** (die R5-Landung, r7-Wachen-Divergenz `#79`).
**Die Wache hat es gefangen** — super-Pipeline **15706**, Job **374843**, `exit 2`, wörtlich:
*„der Plan nennt einen ANDEREN ce-Zustand als super HEAD fuehrt."* **Zum vierten Mal hat dieser
Mechanismus getan, wofür er gebaut ist.**

| Anker | alt (Stand `e114cabd`) | neu (Stand `670483c0`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `e114cabdcaf0…` | **`670483c084293…`** | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 40 | **40** | 497 Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 21 | **21** | 497 Test-`.cpp` im Baum `670483c0` |
| `PZW-SCHEMA-LITERAL` | 2 | **2** | 497 Test-`.cpp` |
| `PZW-CI-AUFRUFE` | 2 | **2** | 2768 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | **0** | 2768 Zeilen, gemessen **mit** `-F` |

**Warum sich trotz gewachsenem Nenner (493 → 497 Test-`.cpp`) keine Zahl bewegt:** die vier neuen
Test-Dateien rufen `lazy_csv_header()` nicht. Dasselbe Muster wie beim Zug vom 09.08. abends — der
Nenner zählt **Dateien**, die Anker zählen **Stellen**; zwei Einheiten, zwei Zahlen.

**Abnahme, beide Wege (§61-Dual-Weg):** CI-Job 374843 `exit 2` mit dem Wortlaut oben · lokal
`sh ci/plan_zahlen_wache.sh` nach dem Anker-Nachzug: **„5 von 5 Ankern decken sich mit dem Objekt"**,
`rc=0` **ohne Pipe gemessen** (K11).

**Eigener Messfehler beim Nachziehen, protokolliert, weil er die Regel belegt:** ich hatte die
Stellen-Zahl zuerst selbst nachgebaut und **59 statt 40** erhalten — mein `sed` schnitt
`^[^:]*:[0-9]*:` weg, `git grep -n <SHA>` liefert aber **vier** Felder (`SHA:datei:zeile:inhalt`).
Die Wache selbst schneidet korrekt `^[^:]*:[^:]*:[0-9]+:`. *Die CI-Formel ist die CI-Formel — nie
eine eigene Menge bilden.* Aufgefallen ist es nur, weil „59 Rohzeilen = 59 Stellen" bedeutet hätte,
dass **keine einzige** Kommentarzeile existiert.

---

**Nachzug 10.08.2026, 17:35 UTC — dritter Gitlink-Zug, vier Zahlen gewandert. Die alte Fassung
bleibt hier stehen (Doku wird deprecatet, nicht gelöscht), die neue steht oben.**

| Anker | alt (Stand `1880f296`) | neu (Stand `e114cabd`) | Zählweise / Nenner |
|---|---|---|---|
| `PZW-CE-SHA` | `1880f2968dfa…` | `e114cabdcaf0…` | Gitlink an super HEAD |
| `PZW-SCHEMA-STELLEN` | 33 | **40** | 493 Test-`.cpp` im Baum, 59 Rohzeilen, Kommentar abgezogen |
| `PZW-SCHEMA-DATEIEN` | 19 | **21** | 493 Test-`.cpp` im Baum `e114cabd` |
| `PZW-SCHEMA-LITERAL` | 1 | **2** | 493 Test-`.cpp`; steigt, sobald MT-L3 ein echtes Orakel einfriert |
| `PZW-CI-AUFRUFE` | 2 | 2 | unverändert, 2410 Zeilen `.gitlab-ci.yml` |
| `PZW-CI-ALTMUSTER` | 0 | 0 | unverändert, gemessen **mit** `-F` |

**Auslöser war meine eigene Landung.** Der Gitlink-Bump `super 0e11e1f8` hob den vendorierten ce
von `1880f296` auf `e114cabd` (71 Commits). Die Wache hat das im nächsten Lauf gefangen —
super-Pipeline **15615**, Job **373214**, `exit 2`, wörtlich: *„der Plan nennt einen ANDEREN
ce-Zustand als super HEAD fuehrt."* **Zum dritten Mal hat dieser Mechanismus getan, wofür er
gebaut ist**; die drei Zahlen wären sonst still falsch geworden.

**Die gestiegenen Zahlen sind kein Defekt, sondern Zuwachs:** zwischen den beiden Ständen liegen
die Sammellandung und die PMC-Meta-Meta-Achse, die neue Schema-Stellen mitbringen. `SCHEMA-LITERAL`
1 → 2 ist genau der Fall, den die Zählweise-Notiz vorhergesagt hat.

**Nachzug 09.08.2026, 11:35 UTC — der Gitlink ist zweimal weitergezogen, die Fußnote hier zog nach.**
Die Wache selbst hat es erzwungen: super-Pipeline **15428**, Job **369258**, `exit 2` mit dem Wortlaut
*„der Plan nennt einen ANDEREN ce-Zustand als super HEAD fuehrt. Plan=25fe4fbf… Gitlink=9f92d49f…"*.
Genau der Befund, den der Absatz darunter angekündigt hat — er ist eingetreten und wurde **nicht**
weggeklickt.

| Zustand | ce-Baum | STELLEN | DATEIEN | LITERAL | Nenner (Test-`.cpp` im Baum) |
|---|---|---|---|---|---|
| **alt** (Stand dieses Abschnitts, **bleibt stehen**) | `25fe4fbf` | 29 | 17 | 1 | — |
| Zwischenstand (Gitlink-Bump `dfdf8bbe`, nie erhoben) | `9f92d49f` | 29 | 17 | 1 | 453 |
| ~~gültig~~ (Stand 09.08. mittags, **bleibt stehen**) | `c6d8e573` | 30 | 18 | 1 | 454 |
| ~~gültig~~ (Stand 09.08. abends, **bleibt stehen**) | `db3c648b` | 30 | 18 | 1 | 468 |
| ~~gültig~~ (Stand 09.08. nachts, bleibt stehen) | `cb263dc9` | 33 | 19 | 1 | 474 |
| ~~gültig~~ (Stand 09.08. nachts, **bleibt stehen**) | `7c3d2934` | 33 | 19 | 1 | 479 |
| **gültig** | `9a4c4be0` | **33** | **19** | 1 | **479** |

**Nachzug 09.08.2026, spät — vierter Gitlink-Zug an einem Tag, und diesmal bewegt sich KEINE der
drei Zahlen.** Der Zug trägt die Sammellandung `7c3d2934..9a4c4be0` (15 Commits: w0a-Bauweg ·
D4-Statistik-Kette · D5-5 HDR · die block_id-Klassenheilung). **Neu erhoben mit der unveränderten
Zählweise dieses Abschnitts:** 41 Rohzeilen → nach Abzug der Kommentarzeilen **33 STELLEN in 19
DATEIEN**, Nenner **479** Test-`.cpp`.

**Warum sich trotz 15 Commits und +3 ctest-Einträgen nichts bewegt** — und das ist der eigentliche
Beleg, nicht die Gleichheit selbst: die drei Pakete legen **keine neue Test-`.cpp` an**. Sie
*erweitern* bestehende Dateien (`test_v41_anatomy_f15_measurement.cpp` +608 Zeilen,
`test_d55_hdr_verdrahtung.cpp` +228) und fügen ein CMake-Modul hinzu (`cli_smoke.cmake`). Der
Nenner zählt Dateien, nicht Fälle — deshalb bleibt er bei 479, während `ctest -N` von 487 auf 490
steigt. **Zwei Einheiten, zwei Zahlen; wer sie gleichsetzt, sieht hier einen Widerspruch, wo keiner
ist.**

**Nachzug 09.08.2026, 16:40 UTC — dritter Gitlink-Zug an einem Tag, und die Wache hat ihn wieder
erzwungen.** super-Pipeline **15463**, Job **369917**, `exit 2`: *„der Plan nennt einen ANDEREN
ce-Zustand als super HEAD fuehrt. Plan=c6d8e573… Gitlink=db3c648b…"* Der Gitlink wanderte heute
`c6d8e573 → 99040ae1 → 579e4099 → db3c648b`; die letzten beiden Züge trugen das A9-S4-Paket
(25 Commits, u. a. der erste Produktions-Aufrufer des xlsx-Writers) und die zwei Heilungen der
roten ce-Pipeline 15465.

**Neu erhoben am Stand `db3c648b`, mit der unveränderten Zählweise dieses Abschnitts:**
`git grep -F -n 'lazy_csv_header()' <sha> -- 'tests/*.cpp'` → **37 Rohzeilen**, davon die Zeilen
abgezogen, deren erstes Nicht-Leerzeichen `//`, `*` oder `/*` ist → **30 STELLEN in 19 DATEIEN**,
Nenner **468** Test-`.cpp`.

**Warum sich trotz 14 neuer Test-`.cpp` (454 → 468) KEINE der drei Zahlen bewegt:** die neuen
Dateien rufen `lazy_csv_header()` nicht — bis auf **eine Kommentarerwähnung**, die die Rohzeilen
von 36 auf 37 hebt und nach dem Abzug verschwindet. STELLEN 30, DATEIEN 18, LITERAL 1 bleiben.

**Und hier ist mir beim Nachziehen selbst der Stellvertreter passiert — er steht hier, weil er die
Regel belegt, gegen die dieser Abschnitt gebaut ist.** Ich hatte DATEIEN mit
`git grep -F -l 'lazy_csv_header()' -- 'tests/*.cpp'` gemessen und **19** erhalten; die Wache
liefert **18**. Der Unterschied: `-l` zählt jede Datei mit einem Treffer — **auch wenn der Treffer
eine Kommentarzeile ist**. Die Wache zieht die Kommentarzeilen **zuerst** ab und zählt dann die
verbleibenden Dateien. Zwei plausible Zählweisen, eine Ziffer Unterschied, und die falsche wäre als
Anker in den Plan gewandert, wo sie die Wache **dauerhaft rot** gemacht hätte. Gefunden hat es
nicht mein Nachdenken, sondern der Lauf: `ROT SCHEMA-DATEIEN: Plan sagt 19, Objekt liefert 18`.
**Das ist der Grund, warum der Anker nach dem Setzen noch einmal gegen das Objekt gefahren wird.**

**Gegenprobe (T-3, zwei unabhängige Werkzeuge):** `git grep -F` gegen den Baum und dateiweises
`git show | grep -F` liefern beide 30/19. Zusätzlich mit einem **weiter gefassten** Muster
(`lazy_csv_header` ohne Klammern) gemessen: 39 Stellen in 18 TUs — eine **andere Einheit**, die
hier ausdrücklich **nicht** eingesetzt wird. Sie steht nur da, damit niemand sie später für
dieselbe Zahl hält; genau diese Verwechslung hat die „47" erzeugt, die §9.1 widerlegt.

**Zählweise, unverändert dieselbe wie oben:** `git grep -F -n 'lazy_csv_header()' <sha> -- 'tests/*.cpp'`,
davon die Zeilen abgezogen, deren erstes Nicht-Leerzeichen `//`, `*` oder `/*` ist; **36 Rohzeilen** am
Baum `c6d8e573`. **Warum +1/+1:** `c6d8e573` trägt die T-15-Strecke (`tests/unit/test_t15_drift_gate_messschleife.cpp`,
Commit `4cd1ab91`) — eine neue Test-`.cpp` mit einer Schema-Stelle, deshalb 453 → 454 im Nenner und
29 → 30 / 17 → 18 im Zähler. Die alte Fußnote ist **deprecatet, nicht gelöscht**; sie beschreibt
`25fe4fbf` und bleibt für diesen Zustand richtig.

**Was der Gitlink-Bump auf `c6d8e573` inhaltlich trägt** (der eigentliche Grund, ihn zu ziehen): den
`#278`-Fix — der `ExperimentPlanDirector` emittiert **kein** `allow_failure` mehr in den Mess-Batch-Job.
Ohne diesen Bump führte super weiter den alten Emitter, und die Owner-Direktive wäre nur im ce-Repo,
nicht auf dem **lebenden** Weg erfüllt.

**Die Falle, die zuerst zuschlug — sie ist der Grund für `PZW-CE-SHA`.** Die erste Messung dieses Abschnitts lieferte **28 Stellen in 16 Dateien**. Falsch, und zwar nicht knapp: die Arbeitskopie des Submoduls lag auf **`a1d0c201`** (03.06.), während super HEAD den Gitlink **`25fe4fbf`** führt — ein Submodul-`M` kann **rückwärts** zeigen, und der Objektspeicher des Submoduls kannte den Gitlink-Commit nicht einmal. Gemessen wurde ein Zustand, den niemand behauptet hatte. Die Wache misst deshalb **nie** die Arbeitskopie, sondern immer den Baum am Gitlink-SHA, und sie bricht mit `exit 2` ab, wenn der Plan einen anderen Zustand nennt als HEAD führt. Zieht der Gitlink weiter, ist das ein Befund: **neu erheben, Fußnote nachziehen, alte Fußnote stehen lassen.**

Registrierung ist Teil des Tests (T-7): die Wache hängt als `docs:plan-zahlen-wache` in `.gitlab-ci.yml`, **ohne** `allow_failure`, und ihre Bissprobe `ci/tests/plan_zahlen_probe.sh` fährt beide Richtungen — den Positiv-Fall als Nenner und gewürfelte Köder, an denen die Wache rot werden **muss**.

> ⚠️ **MARKER 12.08.2026 (KON39):** [D-3 → §10]: dito — Shell-Form zu migrieren, Mechanik vorbildlich.

### 9.6 · Was hier ausdrücklich NICHT gedeckt ist

- **Die vier ctest-Zustände aus B-2 (429/431/456/460)** sind *nicht* maschinell bewacht. Sie brauchen einen Configure bzw. einen gebauten Baum und sind nicht in Sekunden ableitbar; ein Anker dafür wäre entweder ein Daueralarm oder eine Lüge. Ihre Deckung ist die ce-seitige Sichtbarkeits-Wache (ce `1f88cfec`), nicht dieses Dokument.
- **Sätze ohne Zahl.** Die Wache prüft Zahlen. Eine falsche Behauptung, die keine Zahl trägt, fängt sie nicht — dagegen hilft nur §6 (Codex-Pass) und T-9.
- **Die Aufwände (386 h, 206/166,5/13).** Sie sind Schätzungen, keine Messungen, und werden hier nicht als Objektzahlen behandelt. Ihre einzige geprüfte Eigenschaft ist die innere Konsistenz: 53+59+5 = 117 Posten, 206+166,5+13 = 385,5 h — beides stimmt, und die sieben Klassenlisten in §2 tragen tatsächlich 29/25/23/16/10/9/3 Einträge + 2 Einzelfälle = 117.
- **Die 157/117/40 aus §0** sind nicht nachgezählt worden; sie stammen aus der Meta-Stufe und stehen hier als deren Aussage, nicht als eigene Messung.

---

## 10. NACHTRAG — DRIFT GEGEN KON15–KON38 (12.08.2026) + REFERENZ-STATUS

**Status (KON19-00):** Haupt-Referenzdokument der Testseite. Stand bleibt 08.08. + §9; nicht eingearbeitet war der Architektur-Freeze KON15–KON38 — Differenzen nach §9-Muster, nichts gelöscht. Fakten-Quelle: Ledger-Konsolidierung IV.

**D-1 — Hybrid-Bestand nicht null** (§4/Regel 3, W1-Absatz „definiert HY-A"): KON9-02: `hybrid/` trägt **4 Header/943 Z.**, 0 Konsumenten; `AnatomyGattung::HeuristikAdapter=3` existiert, `AnatomyGenus` **sechswertig** — der HY-Reroute-Vertrag **PINNT** `kGenusCount`, definiert nicht grundauf. TDD-Charakter bleibt: Tests vor dem ANSCHLUSS.
**D-2 — Kapazität** (§8, „~118 h"): #87/#78/#86/KON9-05/HY-A sind **(P), MÜSSEN vor F2, fallen NIE** (§13.3); Reserve-WE 22./23.08. dafür gezogen; **Band B/W1 (62 h) „geschlossen gestrichen"**. §8-Bedingung (2) damit entschieden.

> WIEDERAUFNAHME-MARKER 18.08.2026 (Wellenplan par.21, Owner: NIE ausbuchen/verschieben): dito D-2 --
> "geschlossen gestrichen" ist Historie, die Band-B/W1-Posten (22 Posten, 62 h) sind neu platziert
> (s. Marker bei Abschnitt 8/D-2); Wiederaufnahme-Register + Wellenplan par.21.3.
**D-3 — Shell-Bissproben sind Alt-Last** (§9.3 `mess_ausbeute_bissprobe.sh`, **§9.5 (Z.338)** `plan_zahlen_probe.sh`): KON6-05: `ci/tests/*.sh` müssen Google Tests werden, KEINE Ausnahme; Teil der stehenden Regression **S-16** (14 Dateien/8.528 Z., 0 retired; Skip-Verbot KON22). MECHANIK vorbildlich, FORM zu migrieren; **KON37-08s TEST-KONSOLIDIERUNG dockt hier an** (Ziel-Testmodule = Zielstruktur auch für S-16).
**D-4 — S-Strecke hat KEINE Testposten** (Lücke, als GEZÄHLTE Warteliste): S-6, S-13, S-14, S-17…S-21 fehlen im 117er-Katalog; T-9 läuft für den größten Baublock leer. Neu: **S-21 Kategorien-Ordnungs-Wache** (=S-6c, Owner-GO, Vorbild `organ_gruppen_decken_die_komposition`, KON21-03). S-6-Umfang erst nach Layout-Bump-Lösung (`decl.hpp:293`) schätzbar.
**D-5 — xlsx-Nenner** (§2/K7 „null Aufrufer"): KON4-07/R1+KON36-02/H: **8 von 9** `thesis_profiles` xlsx-blind — Kampagnen-Blocker; fehlender T-3-Klasse-Posten mit Profil-Nenner. Lehre L-4: jede „existiert nicht"-Aussage trägt ein Verfallsdatum. *R1-Neuauszählung 15.08.2026 (ce `04f76b65`, zehnter Gitlink-Zug): Nenner **11**, xlsx-blind **0 von 11** (alle mit aktivem `<method value="xlsx"/>`, KF #24) — der Kampagnen-Blocker ist auf Profil-Ebene aufgelöst; der T-3-Klasse-Posten mit Profil-Nenner bleibt als Wache-Lücke offen.*
**D-6 — PMC-Vertragsfolge ungetestet**: PMC = Meta-Meta-Achse, AMD/Intel = zwei Komponenten (KON8-12); CI fährt PMC ohne Vendor (WARNING, KON34-02). MT-L11 misst nur Injektion — CEB→Tier-CT-Vertragsanpassung ohne Posten.
**Summen-Regel:** 117/386 h werden NICHT angefasst, bis die S-Strecke durchgezählt ist — sonst derselbe T-3-Fehler, den §9 korrigiert.

---

## 11. NACHTRAG — TESTRELEVANTE NEUERUNGEN KON39–KON57 (13.08.2026)

**Status (KON19-00, A2.5-Fix NE-21):** Fortschreibung von §10 nach §9/§10-Muster; der TDD-Vertrag §3 (T-1…T-9) kannte die folgenden drei Klassen noch nicht. Nichts gelöscht, nichts an den Summen. Fakten-Quelle: Ledger KON47-04, KON55, KON57. **Als GEZÄHLTE Posten-Liste (3 neue Testklassen), noch NICHT in den 117er-Katalog eingerechnet** — dieselbe Summen-Regel wie §10/D-4 (erst nach dem Durchzählen der S-Strecke).

**T-11a — WARMUP-PAAR-PFLICHTTEST** (KON47-04, Owner: „Pflicht für die Forschung, muss getestet sein"): der Warmup ist ein **PAAR** (Lauf 1 messen+VERWERFEN, Lauf 2 messen+SPEICHERN), **×3 Wiederholungen = 6 Läufe, 3 persistierte Werte**. GEZÄHLTE Test-Pflichten (T-1…T-9 anwendbar):
- (1) **Paar-Zählung 2×3:** der Test weist genau 6 Messaufrufe und **3** persistierte Werte nach (T-3 Nenner: die 3 einzeln, nie gemittelt — KF-10); Köder: eine Fassung mit nur 3 Läufen ODER 1 persistiertem Wert wird ROT.
- (2) **--debug-Zweig 1×:** unter `--debug` läuft es **genau einmal, kalter Cache** (Verzweigung am RunMethodology-Flag, quer, KON34-05 — beschleunigt, leitet nie um); Köder: `--debug` mit 2 Läufen wird ROT.
- (3) **Verwerf-Beweis:** der Wert aus Lauf 1 (Warmup) erscheint **nicht** im persistierten Satz; Köder: eine Fassung, die Lauf 1 speichert, wird ROT (T-4 Gegeneingang). Vorbild `two_phase_measure`; Legacy `run_observable_perm` misst kalt → anpassen oder ausbuchen.

**T-11b — KOMBIBAU-2×2-MATRIX ALS PRÜFNORM** (KON55): jede Landung ist erst grün, wenn **{clang, gcc} × {Debug, Release} = 4 Zellen** je J-1…J-4 + ctest durchlaufen (Compiler ist künftige System-Achse; „nur clang" bräche spätestens im CEB). GEZÄHLTE Pflicht: **4 Zellen**, je mit literaler ctest-Bilanz; der KON55-Kombibau zählt als EIN Bau-Slot (A2.1(a2), Zellen sequentiell). Abnahme-Regel, kein Einzeltest-Posten: sie gehört in die Wellen-Abnahme (§4) jedes Stempel-/Mess-Pakets.

**T-11c — MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE** (KON57, verschärft T-1): der Biss jedes neuen Tests wird per **protokollierter Wegwerf-Mutation** belegt (Rot gesehen, dann zurückgenommen) — und die **Köder-LÄNGE/-Form wird geprüft, BEVOR die Mutation zählt** (M-F2-Lehre: 63-statt-64-Zeichen biss aus dem falschen Grund; dieselbe Klasse wie die gitleaks-19/20-Falle). GEZÄHLTE Pflicht je Paket: **je neuem Test ≥1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Grün**; Vorbild KON57-03 (M-F1/M-F2b/M-F3/M-H10).

**Summen-Regel (unverändert):** 117/386 h bleiben unangetastet; T-11a–c sind erst zu addieren, wenn die S-Strecke (§10/D-4) mit-durchgezählt wird — sonst der T-3-Fehler aus §9.

---

## 12. NACHTRAG — KONSOLIDIERUNG 16.08.2026 (KON94–KON97)

**Status (KON19-00):** Fortschreibung von §10/§11 nach demselben Muster; nichts geloescht,
nichts an den Summen. Fakten-Quellen: Ledger KON94 (FJ-1..FJ-10, Arena E1-E11, 6-GB-Schichtung) ·
KON95 (O1/O2/O3) · KON96 (Gegenlese-Karte) · KON97 (Rest-/Explore-Karten). Als GEZAEHLTE
Posten-Liste (5 neue Testklassen), noch NICHT in den 117er-Katalog eingerechnet — dieselbe
Summen-Regel wie §10/D-4.

**T-12a — DRIFT-GATE-DEBUG-AUSNAHME-TEST** (Z13762-13898; Owner: „Pruefer … schaltet Debug daher
ab"): heute `RunMethodology` in drift_detector.hpp = 0 Treffer — bei der --debug-Generalprobe ab
29.08. waere JEDE Zelle rot. GEZAEHLTE Pflichten: (1) unter `--debug` schaltet das Drift-Gate ab
(Verzweigung am RunMethodology-Flag; Koeder: eine Fassung, die Debug-Zellen rot drift-prueft,
wird ROT); (2) Debug-Zahlen tragen die Sperrform (`AdmissionStatus::Gesperrt`, fail-closed) und
erreichen NIE das Messwertlager (Koeder: eine Debug-Zeile, die im Lager landet, wird ROT —
T-4-Gegeneingang); (3) Nenner-Zeile: der Test weist BEIDE Zweige mit literalem Rot/Gruen aus.

**T-12b — WARMUP-PAAR AM LEGACY-PFAD** (KON47-04 + KON58-11(b); ergaenzt T-11a): der
Legacy-Pfad `run_observable_perm` misst heute KALT (perm_runner.hpp:207,213). GEZAEHLTE Pflicht:
ENTWEDER Paar-Zaehlung 2x3 = 6 Laeufe / 3 Werte auch am Legacy-Pfad (T-11a-Norm, Koeder: kalter
Einzel-Lauf, der persistiert, wird ROT) ODER ein Ausbuchungs-Beweis, dass der Pfad von keinem
Produktions-Ziel mehr gefahren wird (Nullbefund NUR mit Gegenprobe „wer ruft ihn?"). Vor der
Kampagne; haengt an Wellenplan §19.3/C-05.

**T-12c — ARENA-KAPAZITAETS-TESTS (E11)** (KON94 + KON93-C6 + r5 C-1..C-17): GEZAEHLTE
Pflichten: (1) Kapazitaet 6 GB FEST/STATISCH, Planer-Reservierung nur zu Experiment-Beginn
(Koeder: Laufzeit-Resize wird ROT); (2) virtuelle Thread-Slots: Obergrenze = Anzahl der
Thread-Unterachse, compile-time bekannt, Puffer statisch (Koeder: Slot-Ueberschreitung ohne
LAUTEN Fehler wird ROT); (3) Ueberlauf = BEFUND: weiterlaufen + zaehlen + beim Auslesen melden
(Koeder: still verworfene Zeilen ODER blockierender Hot-Path werden ROT); (4) Hot-Path-Reinheit:
kein Alloc, kein I/O, EIN Deskriptor-Verweis statt Achsen-Kette (Allokations-Verbot Z15641;
Koeder: eine Aggregations-Allokation wird ROT); (5) IN-ohne-OUT-Invariante je (Prozess, Thread,
Interface) als Auswerte-Wache (r5 A12/N-6).

> UEBERHOLT-MARKER 17.08.2026 (KON99/KON100, s13-Lens MUSS-1): Pflicht (3) "Ueberlauf = BEFUND:
> weiterlaufen + zaehlen + beim Auslesen melden" ist durch die JUENGERE Owner-Linie ueberholt —
> KON93-02/KON94-02 (P2-Owner-Wort 16.08. verbatim: "Der harte Abbruch kann also nur am RAM Limit
> sterben, wenn die Mess-Arena voll ist"): volle Mess-Arena = HARTER ABBRUCH, failed ohne Retry,
> Arena-Bestand persistieren; das gebaute "zaehlen+weitermessen" ist DER Kern-Delta ("heilen auf
> fest+Abbruch"). Der Koeder-Teil "still verworfene Zeilen werden ROT" bleibt gueltig; der
> Weiterlauf-Teil ist zu ersetzen (Rangfolge OWNER > PLAN). Geltende Fassung: s13-Design
> 20260817-DESIGN-s13-buendel-di25.md S13-05/S13-07.

**T-12d — FULL-JOIN-SCHEMA-TESTS (FJ-1..FJ-10)** (KON91/KON94/KON95): GEZAEHLTE Pflichten:
(1) Spaltenmenge E(A) = kV3AxisSchema + seg_* (KON95-O2) mit BEZUGSGROESSE: Summe der 19
Organ-Segmente + seg_framework_ns == seg_run_total_ns (an golden-Daten verifiziert); Koeder:
ein Test, der seg_*_ns gegen `total_ns` stapelt, wird ROT (Phantom, r1 A-7); (2) markierter
Leerwert nach KON95-O1: ECHT-0 eigene Klasse ≠ nicht-ausgefuehrt = Auslass (honest-empty-
Praezedenz r4 B-06; Koeder: ein zmode=log-Pfad, der eine echte 0 verschluckt, wird ROT);
(3) Full-Join verwirft nichts: je Achse bleibt jede mi-Erfolgs-Spalte erhalten (Koeder:
Spalten-Drop wird ROT); (4) Namens-Wache: `FullJoin` (MergeStrategy) bleibt getrenntes Objekt
bis zur 19.1/A-09-Umbenennung (Kollisions-Koeder).

**T-12e — S-3-KOMBIBAU-NACHWEIS** (KON58-08 + KON59-02/NE-10): S-3 ist gebaut (ce 4a89aed5),
der KON55-Kombibau wurde NIE gefahren (ctest-Starts NULL). GEZAEHLTE Pflichten: (1) die
2x2-Matrix {clang, gcc} x {Debug, Release} je J-1..J-4 + ctest mit literaler Bilanz (T-11b-Norm)
EINMAL real durchfahren und protokollieren; (2) Aktivierungs-Beweis „gebaut UND inert" je
Flag-Seite mit ZWEI Zahlen AM OBJEKT — `bvset_ist_teilmenge` hat 2 PRODUKTIONS-Treffer, „inert"
ist teilwiderlegt und wird gemessen, nicht behauptet; (3) Koeder: eine (token, eltern)-flache
Kuerzel-Pruefung wird ROT (Paar-Identitaet, r4 A-04/r5 A30).

**Summen-Regel (unveraendert):** 117/386 h bleiben unangetastet; T-12a–e sind erst zu addieren,
wenn die S-Strecke (§10/D-4) mit-durchgezaehlt wird — sonst der T-3-Fehler aus §9.

---

## 13. NACHTRAG -- W2-ABSCHLUSS-GATE + DESIGN-WIRKSAME NEUFUNDE SEIT 20.08.2026 (24.08.2026)

**Status (KON19-00):** Fortschreibung von par.9/par.10/par.11/par.12 nach demselben Muster;
nichts geloescht, nichts an den Summen (117/386h bleiben unangetastet, s. par.10/D-4-Summen-
Regel). Anlass: Owner-Order 23.08.2026 spaet (verbatim-Kern: "Design bitte mit ultracode aus
Rekonstruktion und nachverbuchung ... und ALLE (auch kleine) Regressionen und Nacharbeiten im
Wellenplan als Pflicht fuer den Abschluss von Welle 2 verbucht ... OHNE JEGLICHE ... Regression
an Welle 3 zu uebergeben") -- Volltext + Delta-Tafel im Wellenplan `docs/plaene/20260808-
WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` par.27. Dieser Designplan-Nachtrag traegt die
TESTSEITEN-/DESIGN-Haelfte derselben Owner-Order (der Wellenplan die Wellen-/Traeger-Haelfte).

### 13.1 -- DAS W2-ABSCHLUSS-GATE ALS VERTRAGS-PUNKT

Wellenplan par.27.3 definiert das W2-ABSCHLUSS-GATE: Welle 2 gilt erst als abgeschlossen, wenn
die dortige Delta-Tafel (par.27.1.A-J) leer ist ODER jeder Rest ein dokumentierter, aktueller
Owner-Entscheid ist (Kategorie-C-Doktrin, par.21.0/21.6 des Wellenplans -- niemals eine Lead-
Ableitung). **Dieser Designplan uebernimmt das Gate als eigenen Vertrags-Punkt der Testseite**,
gleichrangig mit dem TDD-Vertrag T-1..T-9 (par.3) und den Wellen-Testlast-Regeln (par.4): kein
Paket der W2-Abnahme gilt als abgenommen, solange sein Anteil an der Wellenplan-par.27-Tafel
offen ist. Das ist keine Verdopplung des Gates, sondern seine Bindung an die Testabnahme, wo
sie bisher fehlte (par.6 des Wellenplans, "Verifikationsvertrag", nannte bislang keine
Testseiten-Kopplung fuer Nachtrags-Tafeln dieser Art).

### 13.2 -- DESIGN-WIRKSAME NEUFUNDE SEIT 20.08.2026

**D-7 -- O2-Standard-Landung aendert den Floor-Anker (Quelle: Wellenplan par.27.1.G/CR-1,
Session-Dokumentation Abschn. 9b).** Die o2-standard-Landung (Strang-Tip **f82dfaeb**, Lead-
Rescue-Merge lokal fertig als **b3dc3e93**, NOCH NICHT gepusht) traegt EINEN unbedingten neuen
Test (`test_o2_standard_opt_default`) -- die **+1-Regel**: der Floor-Anker (ctest-Gesamtnenner
je Host-Klasse, `scripts/ci_test_inventory_floor.txt`) steigt dadurch **544/540/538 ->
545/541/539** (LIVE gemessen am Merge-Endstand, `ctest -N` literal "Total Tests: 545"). **Das
ist NICHT dieselbe Zahl wie die PZW-Anker in par.9** (dort zaehlen STELLEN/DATEIEN/LITERAL die
`lazy_csv_header()`-Aufrufstellen -- eine andere Einheit, gemessen am ce-Gitlink-Stand
66de5c09, Nenner 530 Test-.cpp); der Floor-Anker ist der T-11b/T-17-Kombibau-Nenner
(Wellenplan-Doktrin, Quer-Auflage G8/H5 der S2-Lande-Tips). **Wirkung auf diesen Designplan:**
T-11b (par.11, KOMBIBAU-2x2-MATRIX ALS PRUEFNORM) und die "K17-Vollkombibau EINMAL am
Endstand"-Quer-Auflage (Wellenplan-S2-Tip T17) muessen ab der o2-Landung den NEUEN Nenner
545/541/539 fuehren, nicht mehr 544/540/538 -- der Kombibau-VERTRAG selbst (4 Zellen je
literale ctest-Bilanz) aendert sich nicht, nur der erwartete Zahlenwert.

> UEBERHOLT-MARKER 24.08.2026 (par.13): jede Stelle in par.9/par.11/par.12, die "544" bzw.
> "540/538" als aktuellen ctest-Gesamtnenner referenziert (insbesondere die PZW-Historie-Tafeln
> in par.9.5, zuletzt am Stand ce 66de5c09/Nenner 530 Test-.cpp gemessen -- ANDERE Einheit,
> s.o.), bleibt als HISTORISCHE Momentaufnahme stehen; der lebende Floor-Wert NACH der
> o2-Landung ist 545/541/539 (par.13.2/D-7). Kein Nachrechnen der PZW-Zahlen noetig -- die
> betreffen die Schema-Stellen-Zaehlung, nicht den Floor.

**D-8 -- Vendor-O3-Reichweiten-Frage ist owner-gated und beruehrt die Fingerprint-Doktrin
(Quelle: Wellenplan par.27.1.D).** `CMAKE_CXX_FLAGS_RELEASE`-Default "-O3 -DNDEBUG" laesst
Vendor-/FetchContent- und Direktblock-Test-Uebersetzungseinheiten effektiv mit -O3 bauen
(**351 von 643 Treffern, messwirksam**). Das ist eine Design-Frage, keine reine Betriebs-
Frage: die **Fingerprint-Doktrin** (GOAL-Dossier Teil VI.4, "Mess-Achsen + System-Achsen +
Organ-Achsen identisch -> identische Binary -> identische Messdaten") haengt an genau dieser
Optimierungsstufen-Konsistenz. Zwei Optionen liegen dem Owner vor (Wellenplan par.27.1.D
VO3-1): (a) Vendor bleibt -O3 (deklarierte SYSTEM-Isolation, kein Fingerprint-Bruch) oder
(b) global -O2 (Fingerprint-Neuberechnung noetig, moeglicherweise ALLE bestehenden Binary-
Identitaeten aendernd). **Bis zur Owner-Antwort gilt (a) als De-facto-Stand** (nichts wurde
stillschweigend gedreht) -- diese Fassung ist die dokumentierte Momentaufnahme, keine
Entscheidung.

**D-9 -- ph89-Kanon-Richtungs-Entscheid: M13-Absorption VOR erster produktiver Konsumierung
(Quelle: Wellenplan par.27.1.B/ph89-1, Board #89).** `kBegriffsAliasRegistry` (ph89) und die
M13-Registry kanonisieren die Ebene-0-Begriffe in ENTGEGENGESETZTER Richtung (4 von 7 Gruppen:
ph89 deklariert `node4`/`w`/`ma`/`mi` als kanonisch, M13 kanonisiert `SPARSE_NODE4_ART`/
`wallclock`/`macro`/`micro`) -- ein Test (Z.87) pinnt bewusst die Gegenrichtung. Das ist heute
**folgenlos**, weil `kBegriffsAliasRegistry` noch **0 Produktions-Konsumenten** hat.
**Design-Entscheidung, hiermit getroffen:** die M13-Absorption (Angleichung der ph89-Alias-
Paare an den M13-Kanon, ODER umgekehrt -- Registry 7->8 Zeilen + `begriffe_disjunkt` + Asserts
+ CT-Kreuz-Wache) wird **VORGEZOGEN vor die erste produktive Konsumierung** von
`kBegriffsAliasRegistry`, nicht erst "nach Trigger" wie der urspruengliche ph89-Bericht vorsah
(T11-2 der Wellenplan-S2-Lande-Tips). Begruendung: ein zweiter Flip NACH dem ersten
Konsumenten ist ein golden-brechender Nachtrag (dieselbe Klasse wie der Preimage-Bruch bei
einer spaeten AxisKind-Drehung, Wellenplan par.17.5-Analogon); ein Flip VOR dem ersten
Konsumenten ist ein reiner Registry-Edit ohne Bau-Ripple.

**D-10 -- #135-Workaround-Konformitaets-Pruefpflicht wird EIGENE TDD-Testklasse T-13 (Quelle:
Wellenplan par.27.1.E, Board #135 Owner-Dauerregel 23.08.2026).** Owner-Dauerregel, verbatim-
Kern: *"'geloest' [heisst] nicht automatisch konform ... workarounds [muessen] konform nach
Plan gegengeprueft und als Struktur-Regression behandelt werden."* Das ist eine STRUKTURELLE
Ergaenzung des TDD-Vertrags (par.3), nicht nur eine Betriebsregel:

    T-13  WORKAROUND-KONFORMITAET (NEU, 24.08.2026, Board #135): jeder Heilungs-/
          Workaround-Commit einer CI-Rot-Kette braucht VOR seiner Abnahme ein
          dokumentiertes Urteil KONFORM / REGRESSION / OWNER-ENTSCHEID gegen
          Designplan + Wellenplan + GOAL v8 + die einschlaegigen KON-Entscheide.
          CI-gruen allein ist KEIN Konformitaets-Beweis (GOAL-Teil-IV.1-Klasse, sinngemaess:
          ein falsches Messgeraet faellt irgendwann auf, ein richtiges am falschen
          Gegenstand nie -- es gibt nichts, was klappern koennte).
          Koeder-/Abnahme-Form: das Urteil traegt eine Begruendungs-Zeile MIT
          Zitat der geprueften Plan-Stelle -- ein Urteil ohne Zitat gilt als
          nicht geprueft (dieselbe Form-Pflicht wie T-5, ORAKEL UNABHAENGIG).

**Sieben Posten stehen heute unter T-13, keiner verdiktet** (vl3-Maskierung Form a/b/c, PMC-
Riegel+AUSWEIS, B06-Test-Harmonisierung, TemplateWithUnknownRef-Haertung, stringop-overflow-
Duldung, NSDMI-Fixmuster -- Einzelzeilen mit Traeger/Frist in Wellenplan par.27.1.E). **T-13
gilt als eigene, GEZAEHLTE Testklasse ausserhalb des 117er-Katalogs** (dieselbe Summen-Regel
wie T-11a-c/T-12a-e, par.10/D-4/par.11/par.12: erst zu addieren, wenn die S-Strecke mit-
durchgezaehlt wird).

### 13.3 -- SUMMEN-REGEL (unveraendert)

117/386 h bleiben unangetastet; T-13 (wie T-11a-c/T-12a-e vor ihr) ist erst zu addieren, wenn
die S-Strecke (par.10/D-4) mit-durchgezaehlt wird -- sonst der T-3-Fehler aus par.9.

---

## 13.4 FABLE-MAX-ABNAHME DES par.13-NACHTRAGS (24.08.2026) + ZWEI NEUFUNDE

**Status:** additive Abnahme nach demselben Muster wie par.9/par.13; nichts geloescht,
nichts an den Summen (117/386h bleiben unangetastet, par.10/D-4-Summen-Regel).

**Anlass:** der Erst-Lauf dieses par.13-Nachtrags (Commit 6400f6dc, 106 Insertionen) lief
durch einen automatischen Credits-Fallback auf einem NIEDRIGEREN Modell als der Owner-Order
"Design IMMER mit Fable 5 max" entspricht. Die Erst-Lauf-Fassung bleibt vollstaendig stehen;
dies ist die Fable-5-max-Abnahme am Objekt. Wellenplan-Schwester: par.27.4.

**PRUEFUMFANG (Nenner):** Designplan 829/829 Zeilen selbst voll gelesen (par.0-12 Bestand +
par.13 Erst-Lauf + der par.9.5-Marker aus 0c6ee745); Gegen-Quellen: Wellenplan 4690/4690,
GOAL 816/815, ARBEITSWEISE 1264/1264, Session-Nachverbuchung 328/328 (Abschn. 9b/9c-K/9d),
ZUG-BILANZ Abschn. 4/7-9, Board-JSONs #89/#131/#135/#136/#137/#138.
**Zeilenpruefung:** 106/106 Insertionen des par.13-Commits + 9/9 des par.9.5-Markers
geprueft, 0 Deletionen.

### 13.4.1 ABNAHME-URTEIL JE ABSCHNITT

| Abschnitt | Urteil | Beleg der Gegenpruefung |
|---|---|---|
| 13.1 W2-Abschluss-Gate als Vertrags-Punkt | **TRAEGT** | Bindung an Wellenplan par.27.3 korrekt zitiert; die Feststellung "par.6 des Wellenplans nannte bislang keine Testseiten-Kopplung fuer Nachtrags-Tafeln dieser Art" am Objekt bestaetigt (V-1..V-8 tragen Wachen-/Paket-Formeln, keine Nachtrags-Tafel-Kopplung) |
| 13.2 / D-7 Floor-Anker 544/540/538 -> 545/541/539 | **TRAEGT** | Session-Nachverbuchung 9b: Lead-Merge b3dc3e93, `ctest -N` LIVE "Total Tests: 545", +1-Regel `test_o2_standard_opt_default`; Einheiten-Trennung zu den PZW-Ankern (Schema-STELLEN, ce 66de5c09, Nenner 530 Test-.cpp) sauber gefuehrt |
| 13.2 / D-8 Vendor-O3 owner-gated | **TRAEGT** | Board-#136-Metadata `owner_vorlage_zusatz_o2` woertlich: 351/643, Optionen (a)/(b), "kein stiller Dreh"; die De-facto-(a)-Feststellung ist als Momentaufnahme, nicht als Entscheid gefuehrt |
| 13.2 / D-9 M13-Absorption vor erster Konsumierung | **TRAEGT** | Board-#89-Metadata: 4/7 Gruppen Gegenlauf, Test Z.87 pinnt die Gegenrichtung, "kein Produktiv-Konsument", Traeger "M13-Absorptions-/Staffel-3-Zug VORGEZOGEN vor erste produktive Konsumierung" -- die Design-Begruendung (Flip nach dem ersten Konsumenten = golden-brechend) ist eine zulaessige Ableitung und als solche formuliert |
| 13.2 / D-10 + T-13 Workaround-Konformitaet | **TRAEGT** | Board-#135 fuehrt exakt die sieben Posten, das dreiwertige Urteil und den Satz "CI-16101-SUCCESS ist Loesungs-, NIE Konformitaets-Beweis"; die Erhebung zur eigenen GEZAEHLTEN Testklasse ausserhalb des 117er-Katalogs ist regelkonform (dieselbe Summen-Sperre wie T-11a-c/T-12a-e) |
| 13.3 Summen-Regel | **TRAEGT** | 117/386h unberuehrt; T-13 nicht eingerechnet |
| par.9.5-Marker (0c6ee745) | **TRAEGT** | die Trennung "PZW-Schema-Stellen != ctest-Floor" ist die richtige Fehlerklassen-Vermeidung; er bezeichnet die par.9-Ankertafel korrekt als weiterhin gueltig |

**Keine UEBERHOLT-Korrektur am par.13-Text noetig** -- im Unterschied zur Wellenplan-Haelfte
(dort 6 Korrekturen, par.27.4.1) hielt die Designplan-Haelfte der Objektpruefung vollstaendig
stand. ERGAENZT werden zwei design-wirksame Neufunde, die der Erst-Lauf nicht fuehrte:

### 13.4.2 D-11 -- DAS FLOOR-GATE MUSS MIT DER o2-LANDUNG UMGESTELLT WERDEN (Testseiten-Pflicht)

Der Endstand-Beweis des Lande-Zugs fuehrt zwei Aussagen, die zusammen einen Handlungsposten
ergeben, den bisher KEINE Seite als solchen fuehrte:
  * ZUG-BILANZ 9b (Stand ce 3841d717): *"Floor-Anker 544/540/538 bleibt gueltig, Gate [5/6]
    bleibt '544 == 544'"* -- begruendet mit dem Struktur-Befund, dass
    `COMDARE_add_test` **ein add_test je Test-BINARY** registriert (nicht
    `gtest_discover_tests`), weshalb neue gtest-FAELLE in bestehenden Binaries **null** neue
    ctest-Eintraege erzeugen.
  * Session-Nachverbuchung 9b (Lead-Rescue-Merge **b3dc3e93**): der o2-Strang bringt EINEN
    **unbedingten neuen Test** (`test_o2_standard_opt_default`) -- also eine neue
    Registrierung, nicht nur einen neuen Fall -> Floor **545/541/539**.
**Design-Folge (T-11b-Anschluss):** beim Push von b3dc3e93 wird `scripts/ci_test_inventory_floor.txt`
im SELBEN Zug mitgezogen und die Gate-Erwartung [5/6] auf **"545 == 545"** umgestellt; alle
vier K17-Zellen tragen dann literal 545. Wird das vergessen, faellt das Gate falsch-rot bzw.
prueft den falschen Nenner -- exakt die Klasse "geteilte Zaehlwerke EINMAL live messen, nie
Deltas addieren" (ARBEITSWEISE A2.1b(3)). Traeger: Wellenplan RN-01/CR-1 (par.27.4.2 E-10).
**Abnahme:** Gate [5/6] literal "545 == 545" + Floor-Restore byte-gleich + vier Zellen 545.

### 13.4.3 D-12 -- ZWEI PFLICHT-BEWEISLAEUFE AN #114, NICHT EINER (T-12-Umfeld)

Der Erst-Lauf las die beiden #114-Laeufe als einen Gegenstand. Am Objekt sind es zwei, beide
mit Frist Mi 26.08. 06:00 (Volltext + Traeger: Wellenplan par.27.4.1/K-D):
  (i) **B10-Beweislauf** (B5.b-Emitter, Mini-Profil <= 8 Binaries, XML-Differenz-Laeufe je
      Achsen-Familie): emittiert die ECHTEN `E07_*`-Zeilen -- erst damit kann das Gate GO
      werden. Testseite: der Pruefer steht und ist doppelt biss-bewiesen; was fehlt, ist der
      GEFAHRENE Lauf (T-1-Klasse: eine gebaute Wache ohne gefahrenen Biss zaehlt nicht).
  (ii) **E07-Q1-Default-A-Re-Run** (<1h, Rezept `b10-beweislauf/BEWEIS.md` Par.9) auf der
      FINAL eingefrorenen Trigger-Linie -- eine WIEDERHOLUNG des Laufs, der trigfix 0f900dcf
      auf Basis 66de5c09 bewiesen hat.
**Design-Folge:** die Abnahme des Trigger-Gates nennt BEIDE Mengen (V-8 / "ein gruenes Gate
deckt nur seinen Gegenstand"); ob ein einziger Lauf beide Zwecke erfuellt, ist am Objekt
(BEWEIS.md Par.9) zu entscheiden und zu protokollieren, nicht anzunehmen.

### 13.4.4 SUMMEN-REGEL (unveraendert)

117/386h bleiben unangetastet; D-11/D-12 sind Abnahme-/Vertragspflichten bestehender Posten
(T-11b bzw. T-12-Umfeld), keine neuen Katalog-Eintraege. T-13 bleibt wie in 13.2/D-10
GEZAEHLT ausserhalb des 117er-Katalogs, addierbar erst mit dem Durchzaehlen der S-Strecke
(par.10/D-4).

---

## 13.5 FABLE-MAX-ABNAHME FAHRT 3 (24.08.2026) + STATUS-FORTSCHREIBUNG D-11 + D-13

**Status:** additive Abnahme; nichts geloescht, nichts an den Summen (117/386h, par.10/
D-4-Summen-Regel). **Anlass:** die Fahrt, die par.13.4 schrieb (f79d4192), fiel um
07:59:57Z STUMM auf Opus 5 (Consent-Prompt-Mechanik in Background-Sessions) -- ihr
Abnahme-Vermerk war provenienz-tainted. Diese dritte Fahrt lief nach gespeicherter
Fable-Consent-Wahl; Wellenplan-Schwester: par.27.5 (dort die volle Delta-Tafel
F3-01..F3-20 und das Zeilenpruefungs-Urteil 701/701).

**PRUEFUMFANG dieser Fahrt (Nenner):** par.13 (106/106 Insertionen) + par.13.4 (76/76) +
par.9.5-Marker (9/9) am Objekt; Gegen-Quellen VOLL inkl. der GEWACHSENEN Fassungen, die
keiner Vorfahrt vorlagen (SYNTHESE-S1-AUDIT 654/654 mit DRITT-ABGLEICH Abschn. 7,
SYNTHESE-S2-AUDIT 1009/1009 mit DRITT-ABGLEICH D-0..D-6) + eigene Live-Messungen 24.08.
11:3x UTC (B.3-Protokoll: ~/backups-workflow/20260824-w2-abschluss-design/ARBEITSSTAND.md).

### 13.5.1 ABNAHME-URTEIL

**Alle 7 Urteile aus 13.4.1 sowie D-11 und D-12 sind am Objekt BESTAETIGT -- 0 Fehler.**
13.1 (Gate-Bindung), 13.2/D-7 (Floor 545/541/539, Einheiten-Trennung zu PZW), D-8
(Vendor-O3 owner-gated, De-facto (a)), D-9 (M13-Absorption vorgezogen), D-10/T-13
(sieben Posten, dreiwertiges Urteil), 13.3 (Summen-Regel), par.9.5-Marker: tragen
unveraendert. D-12 (zwei #114-Beweislaeufe) traegt; die Entscheidung "ein Lauf oder
zwei" bleibt ein OBJEKT-Entscheid des Traegers (BEWEIS.md Par.9).

### 13.5.2 STATUS-FORTSCHREIBUNG D-11 -- DIE FLOOR-GATE-UMSTELLUNG IST VOLLZOGEN

Eigene Messung 24.08. 11:3x: ce development lokal == origin == github == **943c70ee**
(Kette f82dfaeb -> b3dc3e93 -> 943c70ee); der Z12-Lande-Lauf (24.08. 07:27-07:46Z,
Beweisort ~/backups-workflow/20260822-lande-zug/Z12/) fuhr K17 4/4 Zellen je LITERAL
"100% tests passed, 0 tests failed out of 545" und Gates 6/6 GRUEN mit [5/6] literal
"545 == 545 (exakt)" -- **die D-11-Pflicht (Floor-Datei + Gate-Erwartung im selben Zug)
ist damit AM OBJEKT ERFUELLT**; die D-11-Zeile bleibt als Vertrags-Regel fuer jede
kuenftige +1-Landung stehen. OFFEN aus dem D-11-Umfeld: der CI-TERMINAL-Beleg fuer
943c70ee (F-126-Klasse, fail-closed; juengster belegter Terminal-Lauf 16101 @ 3841d717)
und die test_rcu-Beobachtung -- beide Wellenplan par.27.5.2/F3-01/F3-06.

### 13.5.3 D-13 -- K17-TESTAT-STANDBINDUNG (NEU, Abnahme-Regel aus KORR-D7/H-19)

Ein K17-/T-11b-Testat deckt NUR den Stand, an dem es gefahren wurde ("EIN GRUENES GATE
deckt nur seinen Gegenstand"): ein Testat gegen 5ddda4e5 deckte den heutigen dev-HEAD
nicht mehr, nachdem o2-Merge und axis-lock-Regen dahinter lagen (KORR-D7 des
S2-DRITT-ABGLEICHS). **Design-Regel, hiermit Vertrags-Punkt der Testseite:** (a) jedes
K17-Testat nennt seinen Commit-Stand im Protokoll-Kopf; (b) Abnahmen, die "am Endstand"
fordern, binden an den dev-Tip AM ZUGTAG, frisch gemessen (H-19: das gilt insbesondere
fuer das super-Gitlink-Bump-Ziel, dessen np34-Patch-Match-Probe bei jeder super-Bewegung
zu wiederholen ist); (c) die Treppen-Protokollvorlage nutzt rc=${PIPESTATUS[0]} und
explizite Build-Pfade (F-145-Klasse: eine Pipe-RC-Quittung ist KEIN Beweis; als
Bilanz-Beleg zaehlt nur die literale ctest-Ausgabe). Traeger: T-11b/T-17-Ausfuehrung
(Wellenplan RN-01/RN-18); kein neuer Katalog-Posten.

### 13.5.4 SUMMEN-REGEL (unveraendert)

117/386h bleiben unangetastet; D-13 ist eine Abnahme-Regel bestehender Posten (T-11b),
kein Katalog-Eintrag; T-13 bleibt GEZAEHLT ausserhalb des 117er-Katalogs (13.2/D-10).

**FABLE-MAX-ABNAHME-VERMERK (Fahrt 3, 24.08.2026):** Geprueft 191/191 Designplan-Legacy-
Zeilen (106 + 76 + 9); Korrekturen an den Vorfahrten-Urteilen: 0 (alle bestaetigt);
Fortschreibungen: D-11-Vollzugs-Vermerk (13.5.2) + D-13 (13.5.3). **Damit gilt der
par.13-Nachtrag als von Fable 5 max GEBAUT UND ABGENOMMEN.**
