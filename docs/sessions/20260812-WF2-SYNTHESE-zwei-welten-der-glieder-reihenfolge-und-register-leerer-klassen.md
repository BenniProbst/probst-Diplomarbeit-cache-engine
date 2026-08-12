# WF2-SYNTHESE — KON15-02 „Zwei Welten der Glieder-Reihenfolge" (J) + KON15-01 „Register der leeren Klassen" (K)

**Stand:** 12.08.2026 · ce `670483c0` (Arbeitsbaum exakt) · super Snapshot `2ae55a9c` (Ledger 21999 Z.), HEAD `012f61c0` (Ledger 22176 Z.; +177 durch KON17/KON18, `git diff --stat`: 178+/1−).
**Methode:** je Strang drei Quellen-Schnitte (Code / Tests+CI+XML / Ledger+Pläne+Sessions) + je eine skeptische Objekt-Gegenprobe. Alle Kernbefunde sind am Objekt verifiziert, nicht nur aus Dokumenten übernommen.
**Zitier-Konvention:** `L<n>@alt` = Ledger-Zeile im Snapshot `2ae55a9c`, `L<n>@HEAD` = `012f61c0`; @alt + 177 = @HEAD (an 6 Ankern exakt nachgerechnet: KON15-02 240→417, KON14-02 356→533, KON4-10 2674→2851, KON5-04 2479→2656, KON5-05 2504→2681, KON7-09 2134→2311). ce-Kurzpfade: `abi/`, `api/` = `libs/cache_engine/include/cache_engine/{abi,api}/`; `topics/`, `builder/`, `mess/` = `libs/cache_engine/…`; `pf/` = `libs/cache_engine/profile_facade/`; `tests/` = `tests/unit/`.
**Meta:** KON17-05 (L194@HEAD) und KON18-02 (L80@HEAD) führen WF2 weiterhin als laufende Bringschuld; nichts in KON17/KON18 berührt S-6 oder überholt die folgenden Befunde. Diese Synthese ist damit die aktuellste Antwort auf beide Owner-Aufträge.

---

## 1. DIE ZWEI WELTEN (J)

### Antwort auf die drei Kernfragen

**Kernfrage 1 — Reihenfolge IM LAGER.** Zwei Realm-Kaskaden, beide compile-time erzwungen (`concept LagerRealmPolicy`, `builder/bestandslog/lager_baum_writer.hpp:688`), beide test-fixiert, beide vom Owner am 08.08. als gewolltes Strategy-Pattern bestätigt (L21879-21921@alt):

- **Messdaten-Realm:** MESS → SYSTEM → ORGAN (5 Gruppen) → Blatt, auch auf Unter-Achsen-Ebene `mess_unter → system_unter → organ_unter` (`lager_baum_writer.hpp:698,711,712,716,720,725-727`; Test `tests/test_lb0_lager_pfad_grammatik.cpp:392-412`).
- **Binaries-Realm:** SYSTEM → ORGAN (5 Gruppen) → MESS als tiefstes Blatt (D-12) (`lager_baum_writer.hpp:737,744,748,756`; Test `:699-711`).

Beide halten „System vor Organ"; sie unterscheiden sich **nur** in der MESS-Position, begründet aus der Zugriffsrichtung (Binaries: „welche Binary" → Mess feinste Unterscheidung; Messdaten: „welcher Messlauf" → Mess oberster Schnitt). Auf **Hash-Ebene** gilt im Lager dieselbe Ordnung wie außen — der Writer rechnet nichts nach (siehe Kernfrage 3). Die 18 Organ-Unterachsen sind im Lager in 5 fachliche Gruppen **umsortiert** (Speicherhierarchie-Ordnung, nicht T0..T17; z.B. `kOrganGruppe02` = node_type, memory_layout, path_compression, … — `lager_baum_writer.hpp:391-403,397-398`), die 3 System-Unterachsen stehen in derselben Ordnung wie außen.

**Kernfrage 2 — Reihenfolge AUSSERHALB.** IST durchgängig **ORGAN → SYSTEM → MEASUREMENT**, an 11 Belegstellen der Kategorien-Ebene (Schnitt 1, Belege 1-11), davon 5 in der Gegenprobe selbst am Objekt gelesen: `abi/anatomy_fingerprint.hpp:591-596` (Signatur), `:607-608` (static_assert), `:733-738` (consteval-Zwilling), `abi/anatomy_module_abi_v1_decl.hpp:200-243` (POD, APPEND-ONLY), `abi/anatomy_module_abi_v1.hpp:162/213` (Makros). Das Preimage hat **9 Glieder** (`kAnatomyFingerprintGliedCount=9`, `anatomy_fingerprint.hpp:416,641`): [0]Format [1]Organ [2]System [3]Mess-Tooling [4]Werteset [5]Toolchain [6]Bvset [7]Overlay [8]MessGates. Die Tests fixieren diese Ordnung als gemeinten Vertrag (`tests/test_m_w12_stamp_bausteine.cpp` Positionsliterale; `tests/test_d4_ceb_schluessel_wahl.cpp:69-74`: CEB-Pfad übergibt organ/system **leer** an Position 1/2). Organ-Unterachsen außen: flach T0..T17 (`builder/experiment_tree/axis_path_serialization.hpp:40-43`); System-Unterachsen: `kSystemAxisOrder` (`abi/system_axis_order.hpp:39-46`).
**SOLL** (Owner, chronologisch): 10.08. „System vorn, Organ hinten" — nur 2 von 3, MESS ausdrücklich offen (KON4-10, L2851@HEAD) → 11.08. **MESS, SYSTEM, ORGAN** nach Stufigkeit (3>2=2), **im selben Satz**: „nur das Lager hat hier eine Ausnahme" (KON6-02 Punkt 4, L2366-2392@HEAD). Die SOLL-Regel ist eine **Neuordnung**, keine Wiederherstellung (Zehn-Wochen-Explore: 0 Treffer vor dem 10.08., KON5-05, L2681@HEAD). IST ≠ SOLL für die Außen-Welt; die Feldfolge ist „gewachsen, nicht entworfen" (KON7-09, L2311@HEAD).

**Kernfrage 3 — Die Grenze im Code.** Sie verläuft **je Ebene verschieden**, und das ist der eigentliche Ertrag des Explores:

1. **Hash/Schlüssel: keine Grenze, eine Welt.** `anatomy_fingerprint_glieder()` ist „DIE EINE QUELLE" (`anatomy_fingerprint.hpp:535`); das Lager übernimmt den fertigen 128-hex nur als Blattwert und prüft nur die Form (`lager_baum_writer.hpp:50-55,518-525`: „Dieser Writer rechnet NICHTS nach"); `derive_key_from_lines` ist ordnungsblind (`builder/bestandslog/bestandslog_index.hpp:49-53`); `BinaryKeyPolicy::derive_key` **wirft** bei ≠9 Gliedern (`builder/bestandslog/bestandslog_factory.hpp:60-91`); `build_orchestrator.hpp:307-323` nennt es wörtlich „EINE SCHLUESSEL-WELT … im CODE, nicht per Disziplin".
2. **Unterachsen-Ebene: geprüfte gemeinsame Quellen.** System: `kSystemAxisOrder` wird von außen (`abi/anatomy_version_stamp.hpp:226-254`) und vom Lager (`pruefe_system_ordnung`, `lager_baum_writer.hpp:492-505`) **gelesen, nicht nachgebildet**. Organ: `organ_gruppen_ebenen()` (`:567-597`) ist die **einzige echte Konversionsfunktion** des Hauses (außen-förmige Paare → 5 Lager-Gruppen), und `organ_gruppen_decken_die_komposition()` (`:420-441`) beweist compile-time, dass beide Seiten exakt dieselben 18 Achsen tragen.
3. **Kategorien-Ebene (welcher Block zuerst): KEINE gemeinsame Quelle, KEINE Konversion, KEINE Wache.** Die Gegenprobe hat `builder/bestandslog/lager_pfad_grammatik.hpp` vollständig gelesen (594 Z., von keinem Schnitt zuvor gelesen): **0 Treffer** `anatomy_fingerprint`, expliziter Layer-Kanten-Kommentar (Z.20-24); `lager_baum_writer.hpp:2-9`: „komponiert genau zwei Quellen und erfindet keine dritte". Die zwei `kaskade()`-Aufrufsequenzen und die Preimage-Parameterfolge sind **vollständig unabhängig gepflegt** — heute konsistent zu D-12, aber nur durch Disziplin und Kopf-Kommentar (`:30-48`), nicht durch Mechanik. Kein static_assert spiegelt sie gegeneinander.

**Der präzise Gehalt von „zwei Welten":** Er gilt genau für die **Kategorien-Blockfrage der lesbaren Pfad-Ebenen** — und dort sind es genau genommen **eine Außen-Ordnung (O,S,M) plus zwei Lager-Kaskaden (M,S,O und S,O,M)**. Für Hash/Schlüssel gilt ausdrücklich eine Welt; für die Unterachsen gilt je eine gemeinsame, gewachte Quelle. Bemerkenswert: Die Außen-IST-Ordnung ist die **einzige** Ordnung im Haus, die „System vor Organ" nicht hält — beide Lager-Kaskaden halten es.

**Aufgelöste Nebenpunkte** (Präzisierung, keine Widerlegung):
- **7 vs. 9 Glieder:** kein Widerspruch — 9 Glieder gesamt, davon 7 träger-relevant (ohne Format[0], Werteset[4]); von den 7 sind 4 durch benannte Typen transpositionssicher (`OverlayHash:290`, `ToolchainGlied:359`, `BvsetGlied:372`, `MessGatesGlied:398`, exakt bestätigt), die vorderen 3 (organ, system, measurement — der Streitgegenstand von S-6) sind rohe, typgleiche `std::string_view` ohne Positions-Pin: eine Vertauschung kompiliert unbemerkt; der CEB-Pfad übergibt organ+system ohnehin leer.
- **ORT ≠ ZEIT:** `pf/planner/experiment_plan_director.hpp:92` („Mess→Planer / System→CEB / Organ→Tier") ist Bau-Stufen-Zuordnung (Zeit), keine Byte-Ordnung — das direkt benachbarte Struct (`:93-98`) trägt O,S,M.
- **Zitat-Anker-Korrektur für den Ledger:** Der Satz „nur das Lager hat hier eine Ausnahme…" wird in KON15-02 und im Memory als „KON7" zitiert; der wahre Fundort ist **KON6-02 Punkt 4** (L2366-2392@HEAD, gegengelesen). Inhalt zweifach bestätigt, nur der Anker ist ungenau.
- **Namenskollisionen:** Ein zweiter, anderer „S-6" (gcc|clang, Dossier-23) steht im **Ledger** L10486/L11786@HEAD (nicht im Wellenplan — der hat exakt 1921 Z., kein Drift); zusätzlich existieren ein zweites „D-12" (L4839-4841@alt+Umfeld) und drei verschiedene S-/W-Zählungen (Wellenplan, Kandidatenliste-75, altes „S7" in Code-Selbstauskünften). Vor jeder Posten-Referenz den Gegenstand prüfen, nie die Nummer.
- KON14-02 („S-6 falsch herum, an beiden Stellen reproduziert", L533@HEAD): die **Messung war korrekt** — beide Stellen sind Außen-Stellen; zu einfach war nur das pauschale Urteil ohne den Lager-Vorbehalt, was KON15-02 korrigiert hat. Die Wellenplan-S-6-Zeile (`:1577`) übernimmt den Lager-Vorbehalt aus KON6-02(4) nicht — belegte Lücke im Plan-Text.

### Fundstellen-Karte

| Ort | Reihenfolge | Welt |
|---|---|---|
| `abi/anatomy_fingerprint.hpp:591-596,607-608` — `anatomy_fingerprint_glieder()` + static_assert | O,S,M (Glieder 1-3 von 9) | AUSSERHALB |
| `abi/anatomy_fingerprint.hpp:733-738` — consteval `anatomy_fingerprint_hex` | O,S,M | AUSSERHALB |
| `abi/anatomy_fingerprint.hpp:540-556,416` — 9-Glieder-Preimage, Count=9 | Format,O,S,M,Werteset,Toolchain,Bvset,Overlay,MessGates | AUSSERHALB |
| `abi/anatomy_module_abi_v1_decl.hpp:200-243` — POD `AnatomyVersionLines` | O,S,M (APPEND-ONLY) | AUSSERHALB |
| `abi/anatomy_module_abi_v1.hpp:162,213` — Stempel-Makros 3-/2-arg | O,S(,M) | AUSSERHALB |
| `builder/codegen/adhoc_emitter.hpp:86-89,122-138` — Emitter + generierter Makro-Text | O,S,M | AUSSERHALB |
| `pf/lazy_adhoc_source_gen.hpp:357-376` — Laufzeit-Zwilling → `.fingerprint`-Sidecar | O,S,M | AUSSERHALB (Ergebnis wird später Lager-Key) |
| `pf/planner/experiment_plan_director.hpp:93-98` — `PlanRegistryTrioAnnotation` | O,S,M | AUSSERHALB |
| `pf/sota_catalog.hpp:117-123` — `SotaStampLines` | O,S,M | AUSSERHALB |
| `topics/axis.hpp:17-20` — `enum AxisKind` | organ, system_* | AUSSERHALB |
| `tests/test_m_w12_stamp_bausteine.cpp` (u.a. 826-829, 2206ff), `tests/test_d4_ceb_schluessel_wahl.cpp:69-74` | O,S,M positionsliteral; CEB: organ/system leer | AUSSERHALB (Vertragsfixierung) |
| `builder/experiment_tree/axis_path_serialization.hpp:40-43` — `kCompositionAxisNames` | 18 Organ-Achsen flach T0..T17 | AUSSERHALB |
| `abi/anatomy_version_stamp.hpp:226-254` — `system_stamp_line()` | 3 System-Achsen nach `kSystemAxisOrder` | AUSSERHALB (liest gemeinsame Quelle) |
| `abi/system_axis_order.hpp:39-46,85-88` — `kSystemAxisOrder` | target_isa, operating_system, external_utils | BEIDE (eine Quelle, static_assert-gewacht) |
| `builder/bestandslog/lager_baum_writer.hpp:492-505` — `pruefe_system_ordnung()` | liest `kSystemAxisOrder`, bildet nicht nach | BEIDE (Lager-Konsument der Außen-Quelle) |
| `lager_baum_writer.hpp:420-441,567-597` — `organ_gruppen_decken_die_komposition` + `organ_gruppen_ebenen` | Konversion T0..T17 → 5 Gruppen, CT-bewiesen 18=18 | GRENZE (einzige geprüfte Konversion) |
| `lager_baum_writer.hpp:655-665,693-730` — `MessdatenRealmPolicy::kaskade()` | M,S,O(5 Gruppen),Blatt; Unter-Ebenen M→S→O | LAGER |
| `lager_baum_writer.hpp:667-673,737-758` — `BinariesRealmPolicy::kaskade()` | S,O(5 Gruppen),M tiefst (D-12) | LAGER |
| `lager_baum_writer.hpp:391-403` — `kOrganGruppenNamen`, `kOrganGruppe01..05` | 18 Achsen in 5 Gruppen, Speicherhierarchie ≠ T-Index | LAGER |
| `builder/lager_ablage/ergebnis_mappe.hpp:82-93` — `SheetSchluessel` | M,S,O (deckungsgleich Baum-Ebenen) | LAGER |
| `ergebnis_mappe.hpp:107-109` — `HauptAchsenBelegung` | M,S,O nur benennend (flache Liste) | LAGER (schwach) |
| `tests/test_lb0_lager_pfad_grammatik.cpp:392-412,699-711` | Lb2: M,S,O · Lb3: S,O,M | LAGER (Test-Fixierung) |
| `lager_baum_writer.hpp:50-55,518-525` — `blatt_segment_aus_fingerprint()` | übernimmt fertigen 128-hex, prüft nur Form | EINE WELT (Hash) |
| `builder/bestandslog/bestandslog_index.hpp:6-12,49-68` — `derive_key_from_lines` | ordnungsblind; Ordnung wohnt in `anatomy_fingerprint.hpp` | EINE WELT (Hash) |
| `builder/build_orchestrator/build_orchestrator.hpp:307-323` | „EINE SCHLUESSEL-WELT", Glieder O,S,M | EINE WELT (Hash) |
| `builder/bestandslog/bestandslog_factory.hpp:60-91` — `BinaryKeyPolicy` | throw bei ≠9 Gliedern → vertraglich Außen-Folge | EINE WELT (Hash) |
| `builder/bestandslog/messwert_key_source.hpp:24-31,88-98` + `bestandslog_factory.hpp:98-107` — `MesswertKeyPolicy` | 2-Tupel {Fingerprint, Hardware}; zerlegt O/S/M nicht | EIGENE ORDNUNG (orthogonal) |
| `builder/bestandslog/lager_pfad_grammatik.hpp` (594 Z. voll gelesen) | keine Kategorien-Kenntnis; 0× `anatomy_fingerprint` | NEUTRAL (Substrat) |
| `builder/experiment_tree/ceb_generator.hpp:47` — `ceb_parse_path` | dritte Pfad-Grammatik, organ-only | UNKLAR (Randbefund) |
| `pf/planner/experiment_plan_director.hpp:92` — Kommentar §28/§30 | Mess→Planer / System→CEB / Organ→Tier | ZEIT, nicht ORT |
| super `Code/test_data_xml/experiment_schema.xsd:81-85` | `organ_subaxes` vor `system_axes` (nur 3 Sub-Achsen, Caveat `:372`) | AUSSERHALB (schwaches Signal) |
| super `Code/test_data_xml/messreihe_v32_schema.xsd:1-4` | DEPRECATED (#48-S5), keine Ordnungsaussage | UNKLAR (nicht anwendbar) |
| ce `…/algorithm_profiles/cache_engine_axis_registry.xml:9-125` | nur 18 Organ-Achsen, kein Interleaving | UNKLAR (nicht auswertbar) |
| CI: beide `.gitlab-ci.yml`, beide `.github/workflows/ci.yml`, `super/ci/*.sh` (6 geprüft), `Code/ci_wachen/` | 0 Treffer Glieder-Reihenfolge | KEINE — CI erzwingt/prüft die Ordnung nirgends |
| ce `Code/external/comdare-prt-art` (52 Header) · XSD im ce-Repo (find ab Wurzel) · CLI-Flags `--organ/--system/--measurement` | 0 Treffer (1 themenfremder: `--measurement-plan`, YCSB) | KEINE (Nichtfunde mit Gegenprobe) |

### Was folgt für S-6

**Ist die heutige POD-Folge in ihrer Welt richtig?** Zwei Lesarten, beide belegt: **In sich konsistent — ja.** O,S,M ist außen an allen Stellen einheitlich, ABI-vertraglich (APPEND-ONLY, `stamp_layout_version==6`), test-fixiert, und der Bestandslog ist per throw an genau diese 9-Glied-Folge gebunden. **Dem SOLL entsprechend — nein.** Der Owner hat am 11.08. MESS,SYSTEM,ORGAN nach Stufigkeit angesagt (KON6-02(4)), und die IST-Folge ist „gewachsen, nicht entworfen" (KON7-09). Sie ist zudem die einzige Ordnung im Haus, die „System vor Organ" nicht hält. Auffällig (Feststellung, keine Deutung): das SOLL M,S,O entspricht exakt der Messdaten-Kaskade, das ältere „System vorn, Organ hinten" der Binaries-Kaskade.

**Wo ein Eingriff — falls das SOLL bestätigt wird — anzusetzen wäre** (die drei Außen-Kostenebenen aus KON5-04, L2656@HEAD):
1. Makro-Argumentfolge `anatomy_module_abi_v1.hpp:162/:213` (golden-Bruch),
2. POD-Feldfolge `anatomy_module_abi_v1_decl.hpp:200-243` (ABI-Bruch; APPEND-ONLY-Doktrin ⇒ Umordnung nur mit Layout-Bump),
3. Preimage-Glied-Folge `anatomy_fingerprint.hpp:591-603` samt Zwillingen und Vertragsfixierern (consteval `:733`, static_asserts `:607/:641`, `adhoc_emitter.hpp`, `lazy_adhoc_source_gen.hpp`, Testliterale `test_m_w12`/`test_d4`) — invalidiert alle Fingerprints; laut Wellenplan preimage-wirksam und **vor F2-Freeze** fällig (`:1375-1376, :1625, :1867`; vgl. Memory: nie eine Flotte gebaut, Umbauten heute kostenlos).
Der Bestandslog-/Lager-Schlüssel wandert automatisch mit (ordnungsblind bzw. Form-Prüfung) — dort ist **nichts** zu ändern.

**Wo ein Eingriff verboten ist:** die zwei Lager-Kaskaden samt `kOrganGruppen*` (Owner-bestätigt 08.08., D-12, CT-erzwungen, Lb2/Lb3-getestet — genau die „Ausnahme" aus KON6-02(4)); die Unterachsen-Quellen `kSystemAxisOrder` und `kCompositionAxisNames` samt 5-Gruppen-Konversion; die Hash-Mechanik (`blatt_segment_aus_fingerprint`, `derive_key_from_lines` — keinen zweiten Preimage-Weg eröffnen, A13-M3); das orthogonale Messwert-2-Tupel.

**Entscheidbar ohne Owner (Feststellungen):** (i) die komplette Karte oben; (ii) eine Umstellung der Preimage-Parameterfolge ändert an den Lager-`kaskade()`-Funktionen nichts Beobachtbares — sie lesen diese Folge nie (bewiesen via `lager_pfad_grammatik.hpp`-Volltextlesung); (iii) auf Kategorien-Ebene existiert heute **keine** Wache gegen eine künftige, fälschlich „vereinheitlichende" Änderung — der vom Owner befürchtete verdeckte Bruch sitzt genau dort, nicht in der Hash-Berechnung.

**Nicht entscheidbar ohne Owner — die konkreten Fragen (S-6 bleibt bis dahin gesperrt; die Explore-Auflage aus KON15-02 ist mit diesem Dokument erfüllt):**
1. Gilt SOLL = MESS,SYSTEM,ORGAN für alle drei Außen-Ebenen — und meint #87 die Funktions-/Makro-Argumentfolge, #78 die Zeilen-/POD-Folge? (Wellenplan-Wortlaut mehrdeutig.)
2. Die dokumentierte Anschlussfrage „welcher Realm gibt die Preimage-Ordnung vor?" — derselbe Fingerprint ist Binary-Identität (Binaries-Welt, S,O,M) **und** Messdaten-Skip-Marke (Messdaten-Welt, M,S,O). In keinem gelesenen Dokument beantwortet.
3. Soll eine **Kategorien-Ordnungs-Wache** (Analogon zu `organ_gruppen_decken_die_komposition`) als neuer, bisher unbenannter Posten zu S-6 hinzukommen?
4. Transpositions-Sperre für die drei rohen `string_view`-Glieder: ordnungsunabhängig, bereits Ledger-gedeckt (KON7-10 Punkt 4, L2334-2336@HEAD) — mit S-6 oder vorgezogen?
5. Posten #67 (Benennung, „4 Familien, 142 Include-Kanten", in S-6 gebündelt): laut KON13-08 im Ledger unbelegt — streichen, entkoppeln oder belegen?

---

## 2. DAS REGISTER DER LEEREN KLASSEN (K)

**Zahlen mit Nenner** (Quelle Schnitt 1, Scanner über ce `libs/apps/tools/benchmarks`; Werkzeug vor Nutzung zweifach selbst-korrigiert): 1351 Quelldateien gescannt; **164** Klassen/Structs mit leerem Rumpf, davon **117** Tag-Dispatch (`_tag`/`Tag`); **34** weitere einzeln gelesen (2 davon Werkzeug-Artefakte); **7** Nur-Ctor/Dtor-Klassen gezielt geprüft; ~**1175** kleine nicht-leere Structs nur teilgeprüft (Stichwort-Treffer, hybrid/, KON11-Liste). Gegenproben-Sanity (nicht nachgerechnet, nur Größenordnung): 112 Tag-Namen, ~1984 struct/class-Deklarationen in libs/, 1744 Quelldateien. super `Code/02_messung_driver`: alle großen Dateien gesichtet, 1 Klasse mit 2 Methoden-Hüllen.

**Kernbefund:** Es gibt **keine einzige unbenannte Hülle**. Jede gefundene Hülle ist im Code oder in den Plänen selbst als solche deklariert (DEFERRED / SKELETT / Stub / `[[deprecated]]` / „bewusst ungesetzt"). Die Lücken liegen nicht im Verschweigen, sondern in der **Wellen-Zuordnung und Eigentümerschaft** — genau die zweite Hälfte der Owner-Frage.

### Register (echte Hüllen und Teil-Hüllen)

| Symbol | Ort | Hüllen-Art | Aufrufer | Welle/S-Teil oder benannte Grenze |
|---|---|---|---|---|
| `ISearchEngineProvider` | ce `api/i_cache_engine.hpp:92-95` | Klassen-Hülle: nur virtueller Dtor | 0 (nur Metadaten via `deferred_providers()`, gelesen `apps/f15_compare/main.cpp:172`, `test_v41_…:78`) | benannte Grenze DEFERRED-#274/Fork-4 (Kommentar `:88-90`); keine S-/O-Position |
| `ICacheEngineCoreProvider` | ce `api/i_cache_engine.hpp:96-99` | identisch | 0 | benannte Grenze #274 |
| `V32Orchestrator::submit_to_builder` | super `Code/02_messung_driver/v32_orchestrator.hpp:96-99` | Methoden-Hülle (Rumpf = Kommentar) | nur Skelett-Test (`test_v32_orchestrator.cpp:46-50`) | benannte Grenze: „Diesen Stub NICHT fuellen" (`:16`); Wellenplan `:1278` „bewusst nie getestet"; P-0 nennt nur den Antrieb |
| `V32Orchestrator::execute_messreihe` | ebd. `:104-108` | wörtlicher return-0-Stub (`:103` „Bewusst leer LASSEN") | 3 Skelett-Tests (nur rc==0); 0 Produktion — `main.cpp:669` ruft `v32::antrieb::execute_messreihe` | benannte Grenze; Klasse `[[deprecated]]`; real wiederverwendet nur Geschwister-Structs `PermutationOutcome`/`MessreiheReport` (`:57-79`) |
| 3 Test-Verzeichnisse `tests/{integration, generic_module_tests, module_specific_tests}` | ce, je `CMakeLists.txt:1` | Verzeichnis-Skelett: je 1 Kommentarzeile „Skelett (Phase 4.B)" + `.gitkeep`, 0 Tests | `add_subdirectory` (`tests/CMakeLists.txt:4-6`) läuft ins Leere | KEIN Posten — Phase-4.B-Marker vom 06.07. (L10419@alt); S-16 ist anderer Gegenstand ⇒ **Eigentümer fehlt** |
| CI-Job `ergebnis:holen` | super `.gitlab-ci.yml:2736-2769` | Job-Skelett: Sammel-Logik auskommentiert („SKELETT-Naht … NICHT aktiv"), aktiv nur Existenz-Check+Echo | in Pipeline (needs `planer:delegate-trigger`), manual+gated+allow_failure, nie automatisch gefahren | **terminiert:** scharf mit D3-8 in W2 (Wellenplan `:603`, `:846`); Spannung zu KON16-03/KON18 (keine YAML) offen |
| XSD-Attribut `active`, Teile 3+4 | super `experiment_schema.xsd:340-350` + ce `tests/test_a9b_active_deklaration_inert.cpp:36-76` | Teil-Hülle: Resolver trägt Abwahl ohne Auswertung (Teil 3); Umkehr-Hebel nur compile-time `CMakeLists.txt:380-381` (Teil 4). Teile 1+2 seit 27.07. real; **XSD-Kommentar selbst veraltet** (Doku-Drift) | Parser/Resolver rufen real | KEIN Posten (0 Wellenplan-Treffer); nur Aufräumpass-Dateiname — unterminierte benannte Grenze |
| `best_binary::BreakEvenPoint` + SKELETON | ce `builder/best_binary_selector/best_binary_selector.hpp:361-373,419` (heutige Zeilen; Plandok-Zeilen `:263ff` veraltet) | selbst-deklariertes SKELETON: synthetische Stützstellen, linear + 256-Raster statt Hermite | nur Unit-Tests | **terminiert:** S-15 = HY-B (Wellenplan `:1672`); echte Kurven erst HY-C (Hybrid-Bauplan 09.08. `:120`) |
| `decision_lambda_trees.hpp` | ce `builder/decision_lambda_trees/…:2,102` | zweiter SKELETON-Träger | nur Tests | HY-C-Substrat (S7-HY-GOF-ROLLEN, Bauplan 09.08.) |
| `hybrid_router.hpp` | — | **existiert nicht** (0 Repo-Treffer) — geplante CT-CoR | — | HY-C-Paket, nur geplant |
| P/E-Core-Cluster (`ICpuCore`/`ICoreLayout`/`CoreClass`, `has_hybrid_cores`, CPUID 0x1A) | ce `platform/core_layout.hpp:14-19,37`; `platform/i_platform_probe.hpp:16`; `measurement/i_measurement_source.hpp:60`; `platform_probe/cpuid_platform_probe.hpp:38` | Interface/Enum ohne einen Implementierer (0 repo-weit, grep); Leaf 0x1A nirgends gelesen (0 Treffer); Feld nie gesetzt (2× `EXPECT_FALSE`) | Interface vorhanden, kein Erheber | **KEIN Posten in S-1..S-18/O/HY — echte Zuordnungs-Lücke.** §16.3-E17 (Owner 16.07., L11358@alt): bewusst zurückgestellt, „deep research Pflicht" nicht eingelöst |
| `CodegenEngine`, nur prtart-Pfad | ce `builder/codegen/codegen.hpp:24,32` + `codegen.cpp:15,113-141` | **keine Klassen-Hülle** (Präzisierung): Klasse substanziell (2 Testdateien, >30 Fälle); quarantänisiert ist nur der Stub-Gate-Pfad `profile.id=="prtart"` | 1 Produktionsaufrufer `experiment_driver.cpp:149,156,198` | benannte Grenze: „NICHT erweitern" (Bauplan 19.07. `:41,:209`); S-8 dockt nur an `run_experiment_profile*` |

### Leer mit Absicht (systemisches Muster, geprüft und ausgenommen)

- **Tag-Dispatch, 117 Treffer** (Schnitt-1-Zählung): u.a. `abi/resolve_baustein.hpp:5-10` (11 AxisTags), 15 `topics/*/concepts/topic_*_concept.hpp`, `axes/alloc/axis_06_…`.
- **CT-erzwungen leere CRTP-Basen:** `Axis<Derived>` (`topics/axis.hpp:55-65`, `is_empty_v`-Zwang im Concept), `SystemMetaMetaAxis` (`hardware_meta_meta_axis.hpp:92-96`), `OrganGuard` (`organ_concept.hpp:228-238`).
- **SFINAE-/Trait-Primärtemplates:** `OrganValue-/OrganKeyTypeForwarder` (`organ_concept.hpp:278,294`), `IstKonfiguration`/`EbeneIn` (`mess/konfiguration.hpp:221-232`), `BefehlIn`/`BefehlGefaltet` (`mess/steuer_dock.hpp:60-75`) u.a.
- **Proof-/Selbstbeweis-Archetypen** (nur in static_asserts): `organ_concept.hpp:358-402` (4), `hardware_meta_meta_axis.hpp:339-350` (6), `meta_meta_identity.hpp:81-85` (2), `axis_bound_scratch.hpp:125-139` (2), `cacheline_line_bytes.hpp:65`, `heuristik_adapter_strategy.hpp:208`.
- **GoF-Command-Typen (5):** `mess/konfiguration.hpp:87-95` — „nicht angebotener Befehl = Übersetzungsfehler".
- **Null-Objekte (3):** `NoPrefetchTracker` (`axis_07_prefetch_observable.hpp:60`), `EmptyStatsSnap` (`abi_adapter.hpp:2702`), `CarriedAxis` (`cross_genus_organ.hpp:55`).
- **Declared-only Cross-Platform-Probes:** Windows/Macos-Spezialisierungen mit `not_implemented_reason()` (`hardware_probe_factory.hpp:161-231` u.a.); Linux real (`operating_system_probe_linux.hpp:201`) — „benannt statt verschwiegen" (A8).
- **Test-Doubles:** `FakeGitQuelle`/`FakeXmlParser` (super `ci_wachen/testwerkbank/…/werkbank.hpp:19-22`).

### Geprüft und KEINE Hülle (Abgrenzung, damit das Register nicht falsch wächst)

- **KON11-Elf** (L884-898@alt: „Elf Positionen, neun gebaut-unverdrahtet"): **keine ist strukturell hohl.** `ExperimentPlanDirector` (2352 Z., `IPlanBuilder` 5 pure virtuals `:223-235` + `PlanTextBuilder`), `LagerBaumWriter` (945 Z.; realer Pfad `builder/bestandslog/`, nicht `experiment_tree/`), `ram_probe_chain` (statische CoR, **produktiv genutzt** via `hardware_probe_factory.hpp:433`), `AxisCommand` (`topics/axis_command_base.hpp:20`, Selbsttest `:71-73`), `IResourceControllableTier` (`:56-68`), `i_command.hpp` (`builder/commands/`, 8 Ableitungen; laut Kopfkommentar „HART" konsumiert über V32-Demo-Pfad, default OFF), `v32_messreihe_antrieb` (329 Z. voll implementiert; **von `main.cpp:669` real gerufen** — die KON12-01-Angabe „kein Produktionspfad", L785-803@alt, ist damit zu aktualisieren), `catalog_codegen.cmake` (kein C++), Hybrid-Header (4 Dateien/943 Z., keine Hülle). KON11 bleibt als **Verdrahtungs**-Befund gültig — nur ist Verdrahtungs-Leere nicht Inhalts-Leere; genau diese Trennung verlangte KON15-01 (L224-236@alt).
- `resolve_selection`/`run_selection_filter_chain`: real und funktionsfähig; **4 Produktionsaufrufer** (`profile_run_entry.hpp:957,1009,1074`; `experiment_run_entry.hpp:441`), stets mit leerer Kette — per Doku (#156) strukturell Identität, vom Owner als gewollt bestätigt (KON16-07, L163-168@alt: „Ja wir nutzen es jetzt aktiv, genau das ist der Plan"). Welle: **S-8/W1** („CoR-Einhängung", Wellenplan `:1579`; Termin-Angabe Schnitt 1: WE 22./23.08.).
- `mess/`-Subsystem (`konfiguration.hpp` + `steuer_dock.hpp`, 6 Dateien): substanziell (6 Steuerdocks, 3!-permutiert, static_assert-verifiziert); nur die Ziel-Verdrahtung Gattung→…→Hauptalgorithmus steht aus — Wiring-Befund, **S-Zuordnung ungeklärt**.
- `MeasurementVisitable`: seit 10.07. aktiviert (CMD-1-b, L10597@alt; `axis_command_base.hpp:30,34` objektbestätigt) — kein Kandidat mehr.
- super `ci_wachen`: volle Implementierungen (`git_quelle.cpp` 155 Z., `xml_parser.cpp` 66 Z., `mutations_lauf.cpp` 582 Z.; alle `ergebnis.hpp`-Deklarationen definiert). `messreihe_v32_validator.hpp`: DEPRECATED, aber funktionsfähig. `v32_katalog_driver.hpp:70`: static_assert „kein Stub".
- `benchmarks/`: 0 Quelldateien (nur CMakeLists + `.gitkeep`) — Baugerüst, keine Klassen.
- Werkzeug-Artefakte: `struct sysinfo si{}` (`system_ram.hpp:34`, POSIX-Variable), `PermutationModule_v1` (String-Literal in `codegen.cpp:41`).
- Historisch: zwei leere `traversal/`-Klassen im alten prt-art-Standalone-Klon (Session 20260524 `:403-411`) — in der Produktionslinie seit V35+ nie vorhanden; Altlast, nicht aufgenommen.

### Präzisierungen gegenüber den Vorbefunden (keine Widerlegungen)

1. „Drei CoR-Implementierungen (eine verdrahtet)" hält so nicht: **zwei gebaut** (`resolve_selection` — 4 Aufrufer, Wirkung konstruktiv still; `ram_probe_chain` — produktiv wirksam), **eine nur geplant** (`hybrid_router`, 0 Repo-Treffer).
2. `CodegenEngine` gehört als „ein quarantänisierter Datenpfad in sonst voller Klasse" ins Register, nicht als „Klasse=Stub".
3. Der Testkommentar `test_v32_orchestrator.cpp:16-19` („echte Konsumenten im Produktivcode", 5 Dateien) hält der Gegenprobe nicht stand: alle 5 Fundstellen sind reine Kommentar-Erwähnungen.
4. „0 Produktionskonsumenten" bei `i_command.hpp` heißt „default-OFF in Standard-Builds", nicht „null Codereferenzen".
5. Plandokument-Zeilen veralten: `best_binary_selector.hpp` ist seit 06./08.08. gewachsen (SKELETON heute `:361-373`) — Code-Gegenprobe vor jedem Zitat.

---

## 3. WAS OFFEN BLEIBT

**(J1) Owner-Entscheid SOLL-Ordnung außen** — die fünf Fragen aus Abschnitt 1 (SOLL-Bestätigung, Realm-Frage, Kategorien-Wache, Transpositions-Sperre-Timing, #67-Schicksal). *Warum offen:* Policy, keine Code-Tatsache; KON17/KON18 schweigen dazu. *Nächster Schritt:* diese Synthese mit der Fundstellen-Karte dem Owner vorlegen; bis zur Antwort bleibt S-6 gesperrt (die Explore-Auflage aus KON15-02 ist erfüllt).

**(J2) Kategorien-Ebene ungesichert** — kein static_assert spiegelt Lager-Kaskaden gegen Außen-Ordnung. *Warum offen:* wäre ein neuer, bisher unbenannter Posten (Owner-GO nötig). *Nächster Schritt:* als Entscheidungspunkt (c) mit vorlegen; Bauform läge mit `organ_gruppen_decken_die_komposition` als Vorbild fest.

**(J3) `anatomy_version_stamp.hpp:149-169`** — die 18er-Literalliste ist nur über die Anzahl (`kOrganAxisCount`) verankert, nicht Element für Element gegen `kCompositionAxisNames`; ob eine Umsortierung still durchginge, wurde nicht geprüft. *Nächster Schritt:* kleiner eigener Prüf-/Wachen-Kandidat.

**(J4) Kommentar-Drift `bestandslog_factory.hpp:11-12`** („[d,e,f]+[g,h,i]+HW" vs. tatsächliches 2-Tupel; Gegenprobe bestätigt die Spannung) sowie der veraltete XSD-Kommentar zu `active`. *Nächster Schritt:* Doku-Korrektur-Posten (deprecaten/nachführen, nie löschen).

**(J5) Restmengen ungelesen:** ~40 XML-Instanzdokumente (nur die 2 XSD gelesen), `cache_engine_builder_iterator.hpp` (3257 Z., nur Co-Occurrence-Grep), `experiment_schema.xsd` ab Z.426 nur strukturell. *Warum:* Zeit; Kernbefunde dreifach verifiziert. *Nächster Schritt:* nur bei Bedarf gezielt, kein Blocker für S-6.

**(K1) Das Register als gepflegtes Dokument existiert weiterhin nicht** — dieser Abschnitt 2 ist die Erstbefüllung, aber noch kein geführtes Repo-Dokument (KON15-01 verlangt „anlegen"; KON17/18 führen es als laufend). *Nächster Schritt:* Ablageort und Pflegeregel vom Owner bestätigen lassen (Doku-Policy: docs nur auf User-Geheiß), dann Erstbefüllung landen.

**(K2) P/E-Core-Cluster ohne Wellen-Zuordnung** — bestätigt echte Lücke; §16.3-E17 vermerkt selbst „deep research Pflicht, nicht eingelöst". *Nächster Schritt:* Owner-Entscheid, ob eigener Posten oder ausdrücklich Nach-F2.

**(K3) `i_command.hpp`-Einordnung** — laut KON13-08 (L744@alt) im Ledger selbst offen; Code real, aber default-OFF konsumiert. *Nächster Schritt:* Owner-Einordnung (Nachfolger `AxisCommand` steht).

**(K4) `mess/`-Subsystem ohne S-Position** — substanziell, aber keine S-Position nennt „Steuerkanal"/„Konfiguration" wörtlich (S-9/S-10 naheliegend, unbelegt). *Nächster Schritt:* Owner: zuordnen oder als 19. Position benennen.

**(K5) Drei Skelett-Testverzeichnisse ohne Eigentümer** — Phase-4.B-Marker (06.07.) vom Wellenplan nicht aufgegriffen. *Nächster Schritt:* Owner: füllen, terminieren oder deprecaten.

**(K6) `ergebnis:holen` vs. KON16-03/KON18-01** (kein YAML, zentrales Bau-Modul emittiert Prozesse) — ob die W2-Scharfschaltung noch sinnvoll ist oder der Job im neuen CI-Gerüst aufgeht, ist am Objekt nicht entscheidbar. *Nächster Schritt:* Architektur-/Owner-Frage, vor W2 klären.

**(K7) Nicht erschöpfend geprüfte Mengen:** ~1175 kleine nicht-leere Structs ohne zweite Lese-Passage; 132 Testdateien und die 6847-Z.-`tests/unit/CMakeLists.txt` nicht Zeile für Zeile (markerlose leere `TEST()`-Körper wären der Grep-Strategie entgangen); 14 `super/ci/tests/*.sh` nur nach Umfang gesichtet; super-CMakeLists `Code/01..09` nicht auf verwaiste `add_test`; Kandidatenliste-75 Posten (42) — 16 Dünn-Verzeichnisse unter `builder/` — nicht auf Klassenebene heruntergebrochen. *Nächster Schritt:* gezielter Nach-Explore nur dort, wo eine Welle real anfasst.

**(K8) Buchhaltung der Aggregatzahlen:** 164 − 117 − 34 = 13 im Schnitt-1-Bericht nicht aufgeschlüsselt; die Gegenprobe hat die Großzahlen nur per Sanity-Check gestützt (112 / ~1984 / 1744), nicht nachgerechnet. *Nächster Schritt:* beim Landen des Registers die Zählung einmal reproduzierbar (Skript + Ausgabe) ablegen.

**Für beide Stränge gilt:** Kein Befund dieser Synthese ersetzt eine Owner-Entscheidung; alles oben Markierte ist Vorlage, nicht Vorgriff.