# HYBRID — BAUPLAN UND ENTSCHEIDUNGSVORLAGE, 09.08.2026

> **Auftrag:** Pflicht-Explore vor dem Bau (Owner-Regel 09.08.), Strang 23 (`wsyxufm39`).
> Vier blinde Linsen über zehn Wochen Korpus + Code + Thesis, dann Bauplan mit Nachprüfung.
>
> **Der Owner-KERN vom 08.08.:** Gattung `HEURISTIK-ADAPTER`, Genus `Function-Interface-Reroute`,
> compile-time Interface-Vererbung, heuristisches Durchstellen („wie ein heuristik-gesteuertes
> Mutex"), **vierte Mess-Ebene DAZWISCHEN**, zwei Ausgänge im SearchAlgorithm, **wirkt auf den
> Bauplan**. **„ALLES PFLICHT."**

---

## DAS ERGEBNIS IN DREI SÄTZEN

**Erstens: HYBRID ist nicht 0 % — es ist 0 % *angeschlossen*.** Die Kurven-Synthese-Mathematik
(Fritsch-Carlson-Spline, Break-Even-Schnittpunkte), die der künftige Router konsumieren soll,
existiert **dreifach** — 1802 Zeilen über drei parallele Stacks — **und ist getestet**. Sie hat
**null Produktions-Konsumenten**; nur Tests rufen sie auf.

**Zweitens: der Bau ist blockiert, nicht schwierig.** Vier Owner-Entscheide (E-1, K1, K2, K5)
stehen **vor** der ersten Zeile. Ohne sie wäre schon das Linken geraten — und das Lager weist
Hybrid-Pfad-Token heute **compile-hart per Wurf zurück**, weil K1 offen ist. Der Code ist
also bereits so gebaut, dass er Hybrid **aktiv verweigert**, bis entschieden ist.

**Drittens: die Mengenfrage ist per Konstruktion unbeantwortbar.** HY-B steht laut OV-4
**außerhalb** des 4,5-Tage-Deckels und ist **unbeziffert**. Kein Dokument nennt #Lastprofile
oder k je Profil. Die Antwort kommt erst mit `--check-size` — deshalb ist das Werkzeug
**Vorbedingung der Messplanung**, kein Posten daneben.

---

Alle tragenden Proben sind gefahren. Hier der Bauplan.

---

# BAUPLAN HYBRID — geprüft am Objekt (09.08.2026, ce HEAD-Baum `/home/comdare/wt-ce-xml`, sauber)

## I. NACHPRÜFUNG DER KARTIERUNG — was hält, was nicht

Jedes „LÄUFT" und jede tragende Festlegung selbst nachgeprüft. **Bestätigt (mit Literal):**

| Behauptung | Probe | Ergebnis |
|---|---|---|
| hybrid/ = 1 Datei von 9 geplanten | `ls -la` | NUR `README.md`, 8.412 B; Soll-Tabelle README:32-42 nennt 9 Dateien |
| kein Build-Anschluss | `cache_engine/CMakeLists.txt:4-8` | 5 von 5 `add_subdirectory`, keins hybrid |
| Lager verweigert compile-hart | `lager_pfad_grammatik.hpp:523-527` | `pruefe_kv({"tier","hybrid"}) == LagerPfadFehler::hybrid_segment_verboten`; Assert-Text verlangt wörtlich „Owner-Gate, keinen Patch" |
| Enums ohne 6. Wert | `anatomy_base.hpp:55-58/:98-107` | AnatomyGattung = 3 Werte (Map/Container/Graph), AnatomyGenus = 5 Werte; kein Platzhalter |
| ABI-Stand | `anatomy_module_abi_v1_decl.hpp:89-93` | Major 8 / Minor 0 / Magic `.A8.` = `0x434F4D444141382EULL`; 4 Pflicht-Symbole + 1 optionales (`version_lines`); `host_compatible_with`: Major identisch, Modul-Minor ≤ Host |
| kein hybrid-ABI-Header | `ls abi/` | 27 Dateien, 4 Genus-ABI-Header (set/adapter/view/sequence), 0 hybrid |
| hy_label_gate LÄUFT | selbst ausgeführt | rc=0, literal `hy_label_gate: OK (22 Angabe(n) in 3 Datei(en), 21 Anker, lebender Major 8)`; registriert `tests/CMakeLists.txt:24`; 22 historische Läufe (`CTestCostData.txt:457`) |
| Scaffold-Test synthetisch, LÄUFT | `tests/unit/CMakeLists.txt:4229`; Kopf `:1-4` | `add_test` vorhanden, „GOLDEN-NEUTRAL … KEINE #156-Messdaten"; 24 historische Läufe |
| variant-Bestand | grep `std::variant<` über libs/ | 3 Dateien, 4 Instanziierungen + 1 Kommentar: `algorithm_baustein.hpp:38` (TEST-ONLY-quarantäniert, Guard-Kommentar Block D), `axis_error.hpp:402/:422`, `pressure_state.hpp:49`; 0 in axes/ |
| variant-Wache eng | `test_striktheit_metaprog_guard.cpp:12-14/:78-97` | Scope = 11 Referenz-Anatomien; KEINE repo-weite „DockSlot-einzige-Ausnahme"-Wache |
| Prüfdock-Muster | `pruef_dock.hpp:10-14/:57-80`; `pruef_dock_registry_default.hpp:33-45` | 4 pure Methoden; „Neue Gattung = neues Dock + neues Sub-Interface + neuer flacher POD — NIE Mutation von IAnatomyBase/Snapshot"; 5 von 5 Docks registriert, Wache `test_e24_c4_genus_pruef_docks` (23 Läufe) |
| Snapshot-POD ohne Ebenen-Feld | `observable_tier.hpp:160-197` | `axis_stats[18][8]` + `seg_ns[18]` + Meta, `static_assert sizeof==1344`; kein Mess-Ebenen-Tag |
| E2/E3 real | `harness/perm_runner.hpp:196-225` | `run_observable_perm`: steady_clock-Klammer t0/t1 + PMC-Klammer um den Batch |
| MessEbene-Writer | `ergebnis_mappe.hpp:150-230` | `enum class MessEbene {Compare, Macro, Micro}` + 8-Spalten-Nachtrag + wörtlich „Prozess+Thread-Identitaet erreicht HEUTE an KEINER Stelle der bestehenden Mess-Pipeline" diesen Writer; `checkpoint_measure` = „NOCH NICHT gebaute Spezifikation" |
| Tooling-Achse getrennt | `measurement_tooling_registry.hpp:26-34` | `kMeasurementToolingCount = 3` mit CT-Drift-Bruch; Namenskollision „Micro" aktenkundig (Ledger:9402-9408) |
| Owner-Zitate | Ledger direkt | GO-3 verbatim `:1482-1522`; Stufen-Doktrin + HYBRID-VERERBUNGS-GESETZ `:5688-5695`; Auswertungs-Kette 06.08. `:5785`; §49+KORREKTUR `:4293/:4301`; E1/E2/E3-Tabelle `:9388-9392`; WOZU/Stufe-1-2 `:6126-6150`; Break-Even=H2 `:6190-6215`; Flattern `:12694-12708` |
| SOLL-Design vollständig | `20260802-hybrid_tier_stufe_soll_design.md` ganz gelesen | K1/K2 offen, K3 erledigt, **K4 ENTSCHIEDEN** (Q6, „LEDGER:187(e) superseded", Supersede-Vermerk Ledger:1702), K5 offen, K6 bindend; Q6: Ein-Hybrid-je-Gattung + MaxN=8; §5 „schreibt NIE selbst CSV"; §6 ABI-Nulllast; §3.3 delegierter Bau |
| XSD-Reserve | super `experiment_schema.xsd:102-124` | Kommentar-Reserve zwischen `run_methodology` und `measurement_framework`; „Validierung ist der C++-Validator validate_profile.hpp, nicht das XSD" |
| checkpoint_measure-LESEFALLE | Doc `:3` + `:259-281` | Status „noch nicht gebaut"; Tabelle Filter-Rang vs. gebaute Schicht wortgleich zur README |
| Thesis | `03_messsystem_prtart.tex:1432-1436/1457-1462/1521-1526`; `05_evaluation.tex:143-150/180-186/218-227`; `04_implementierung.tex:193/213-218`; `E_architecture_decisions.tex:132-155`; `le_limitierung.tex:34` | Hybrid-Modus = „Ziel"; ABER Framing „System-Achse" lebt dort weiter; UML führt Hybrid im Präsens; ADR-11 ohne Vollzugsstand (ADR-12 hat einen); Limitierungs-Tabelle kennt Hybrid nur als „hybrider Visitor" |
| Nichtfunde | je mit Gegenprobe | `HEURISTIK-ADAPTER`/`Function-Interface-Reroute` als Identifier: 0 in .hpp/.cpp/.xml/.xsd, nur 2 md (Gegenprobe „heuristik" trifft); `--check-size`: 0 in ce libs/apps/scripts (Gegenprobe `--dump-plan` trifft 3 Dateien); Reroute-Vokabeln in Thesis-Kapiteln+Anhängen DE+EN: 0 (Gegenprobe „Hybrid-Modus" = 2 Dateien); OV-13-Antwort: 0 Treffer außerhalb der zwei Wellenpläne — **Stand heute unbeantwortet, Frist Mo 10.08.** |

**Korrekturen an der Kartierung (7):**

1. **Die Last-Erkennungs-Lücke ist ÜBERHOLT, nicht mehr total.** `heuristik/` hat heute **6** Header, nicht 3: zusätzlich `workload_feature_vector.hpp` (T-10, 13-dim-Merkmalsvektor), `workload_cluster_offline.hpp` (T-10: agglomerative Hierarchie + k-Means-Verfeinerung + **Online-Zuordnung Nearest-Centroid mit noise-Schwelle → sicherer Default**) und `axis_optimization_catalog.hpp` (19 Achsen T0..T18, 45 Zielgrößen). Getestet (`test_heuristik_workload_cluster.cpp`), Produktions-Konsumenten weiterhin 0. Die Lücke ist jetzt **Verdrahtung** (heuristik/workload_* → hybrid_router), nicht mehr Konzept. Der ONLINE-Teil (DBSCAN/ADWIN über Ankunftsraten) ist im Header selbst als „NICHT GEBAUT, Owner" deklariert.
2. `best_binary_selector` = **1.459 Zeilen über 3 Dateien** (462 hpp + 751 cpp + 246 main), nicht 1.104; der .hpp trägt heute **1** heuristik-Treffer (Zeile 229 — ein **Kommentar**, kein Include). Der funktionale Bruch „[3] konsumiert [2] nicht" **besteht** (0 Includes, .cpp = 0 Treffer).
3. `perm_runner.hpp` liegt in `libs/cache_engine/harness/`, nicht `builder/permutation_engine/`.
4. `hy_label_gate` ist in `tests/CMakeLists.txt:24` registriert, nicht in tests/unit/.
5. Das Root-CMakeLists hat **2** „Hybrid"-Treffer (`:219` HMalloc Hybrid Free-List, `:322` AoSoA) — Achsen-Namenskollisionen, kein Anschluss.
6. **ID-Falle:** „OV-13" bezeichnet in der älteren Endfassung (`…369-soll-211-ist.md:191`) die **Paper-Kopplung**, in v2 die **HYBRID-Zerlegung**. Gleiche ID, zwei Bedeutungen.
7. Ledger-Anker wandern (prepend-Struktur, heute 13.825 Zeilen): die 06.08.-Kette steht heute bei `:5785` (Kartierung: ~4176); GO-3 bei `:1482` stimmt.

**Bestätigter echter Dokument-Widerspruch:** das Register vom 09.08. führt „K1/K2/**K4**/K5 bis Mi 12.08." als ungeklärt (`:170`), obwohl K4 (Systemachsen-Framing) seit 02.08. entschieden ist (Design §7 + Ledger:1702). Plausibel meint das Register den **neuen** K4-artigen Konflikt (Gattung vs. Stufe, unten E-1) — das steht dort aber nicht. Nicht glätten: klären.

---

## II. DER ENTWURF IN EIGENEN WORTEN — so, dass man danach bauen kann

**Position in der Kette.** Die Hybrid-Tier-Binary ist Rekursions-Ebene 3 der Dock-Kette: Planer-Dock (1) → CEB-Prüf-Dock (2, gebaut) → **Hybrid-Prüf-Docks (3, neu; N Docks, N dynamisch)** → plain Tier-Binaries (soll_design §2). **Nach oben** ist sie ein gewöhnliches Tier-Modul am CEB-Prüfdock: exportiert die 4 ABI-Pflicht-Symbole (Major 8), wird dort gemessen wie jedes Tier (§64 gemischt). **Nach unten** spricht jedes ihrer Docks seine plain Binary über exakt dieselbe Anatomy-ABI (`AnatomyModuleLoader`-Wiederverwendung — Schichtfrage K2 offen).

**Was sie ist (Owner 08.08., Gesetz).** Eine **Gattung `HEURISTIK-ADAPTER`** mit **Genus `Function-Interface-Reroute`**: sie **erbt compile-time die Interfaces einer Gattung+Genus** (der Ziel-Gattung ihrer Tiers) und **stellt sie nach heuristischer Entscheidung durch** — „wie ein heuristik-gesteuertes Mutex". Sie rechnet nicht selbst; sie entscheidet, wer durchdarf, und empfängt die Ergebnisse (Ledger:1487-1493). Der Ledger deutet das als Auflösung der neun Dateien lang ungebauten „vierten Kettenstufe": „eine Gattung im bestehenden System, mit eigenem Genus, eigenem Interface, eigener ABI" (Ledger:1495-1497 — **Ledger-Deutung**, das ABI-Wort steht nicht im Owner-Verbatim).

**Was „Gattung" im Haus konkret heißt** (seit C7-1, anatomy_base.hpp:86-97): Gattung = Ebene 1 (heute Map/Container/Graph), Genus = Ebene 2 (heute 5 Werte). Der KERN wörtlich genommen = **4. AnatomyGattung + 6. AnatomyGenus**, und das Hauspattern dafür ist im Code dokumentiert: neues Dock + eigenes Sub-Interface + eigener flacher Snapshot-POD, **nie** Mutation von IAnatomyBase/Bestand (pruef_dock.hpp:10-14); Wachen, die den Nachzug erzwingen: `test_e24_c4_genus_pruef_docks` (iteriert ALLE Enum-Werte) und die Totalitäts-Asserts im Metaprog-Guard. **Spannung:** das bindende 02.08.-Design exportiert die Hybrid-Binary als „SearchAlgorithm-Hülle" (soll_design:61-64/:108-109) und legt „ABI-Nulllast, kein eigener ABI-Schritt" fest (§6.1-2). **Merge-Lesart, die beides fast trägt:** die Hybrid-Binary trägt ihre eigene Klassifikation (HEURISTIK-ADAPTER/Function-Interface-Reroute), erbt aber per Metaprogrammierung das **Interface** der Ziel-Gattung+Genus (genau das sagt der Owner-Satz); ein additives Sub-Interface + POD ist nach Haus-Präzedenz **major-neutral** (AP-15-2, Ledger 06.07.: „additives dynamic_cast-Sub-Interface = major-neutral, Präzedenzen IScannable/IMigratable/IRC commit-belegt"). Unaufgelöst bleibt genau EINE Weiche: **was liefert `anatomy()->genus()` der Hybrid-Binary, und bekommt das Enum den 6./4. Wert?** → E-1.

**Vererbungs-Gesetz** (Ledger:5688-5695, kanonisch): MESS dreistufig (Planer RT-Freigabe → CEB CT → Tier CT), SYSTEM zweistufig, ORGAN zweistufig; als eingeschobene Stufe **erben die Hybriden ALLE Eigenschaften vorausgegangener Stufen und reichen die Mess-Achsen-Eigenschaften CT an ihre Tiers weiter** — die Mess-Kette bleibt durch den Einschub compile-time-durchgängig. ORGAN-frei: „factory pattern - facade - Adapter" (Deutung Ledger:6144-6150: Factory hält die passende Binary, Facade = eine Schnittstelle nach außen, Adapter = mehrere Tiers dahinter). Der gebaute Präzedenzfall für „eine Auflösung, zwei Verbraucher (Stempel + Bau-Defines)" existiert bereits: `profile_facade/mess_achsen_naht.hpp` (M-1/D-1, 06.08.) — daran muss die Hybrid-CT-Weitergabe andocken.

**Docks und die variant-Kante.** N ABI-stabile Prüfdocks; `DockSlot{HybridDockVariant dock; HybridBinaryProxy proxy; DockContractDescriptor desc}`; `std::visit` NUR an attach/detach/Umschaltpunkten, danach gecachter monomorpher `IObservableTier*` — Hot-Path variant- und cast-frei (§49-KORREKTUR Ledger:4301: variant NUR für abweichende Unter-Prüfdock-Typen/Verträge via Abstract Factory, NIE die Haupt-Observer-Kommunikation). `DockArray<Policy>` statisch (Default-MaxN=8, Q6) oder runtime; Belegung IMMER dynamisch; Eviction = CT-Strategy (Shortlist LRU/LFU/ARC/GDSF/cost-aware — Web-Recherche §49 noch offen, Q10.4). **Achtung, nicht glätten:** „DockSlot = einzige variant-Ausnahme im ganzen System" gilt nur für die Tier-/Achsen-Zone; die CEB-Duldung besteht separat (soll_design §3.2.4, Ledger:1697), und 2 achsenfremde Nutzungen laufen produktiv (pressure_state, axis_error) plus 1 TEST-ONLY-Cluster. Keine Wache erzwingt den Satz repo-weit.

**Delegierter Bau.** Die Hybrid-Stufe **kompiliert nie selbst**; sie fordert plain Binaries per Anforderungs-Manifest (binary_id-Liste) bei der CEB an; die CEB baut oder holt aus dem Lager (soll_design §3.3). Sie schreibt **nie** selbst CSV (§5).

**Der Router und die Heuristik.** `hybrid_router.hpp` (existiert nicht) = CT-Chain-of-Responsibility, konsumiert AxisSpline-Kurven + BreakEvenPoint-Listen aus `heuristik/`. Die Auswertung liefert **Schaltlogik, keinen Rat**: Schnittpunkte = Kipppunkte (Ledger:6184-6188); Break-Even ist die operative Form von H2 (Ledger:6203-6215). Das **Flattern** der durchschnittlich besten Binary ist das Signal für den Arbeitsbereich des Hybriden — Stufe 1 mittelt, Stufe 2 sucht das Flattern gezielt; Bereichs-Erkennung, keine Hysterese (Ledger:12694-12708; als OV-12 dennoch formal offen). **Last-Erkennung:** das T-10-Substrat (Merkmalsvektor + Offline-Cluster + Online-Nearest-Centroid mit noise→Default) liegt als getesteter Header vor; **wo** es im Hybrid aufgerufen wird, hat keinen benannten Ort — das ist die verbliebene Lücke.

**Die zwei Ausgänge** (Ledger:6126-6150 + GO-3-Verschränkung): Stufe 1 (homogene Last) = EINE beste Binary je Schnitt, direkt drangehängt — kein Hybrid nötig. Stufe 2 (gemischte Lasten) = multiple optimale Binaries, je eine pro Last-Kanal — der Hybrid-Schaltungs-Adapter wählt zur Laufzeit. §49 gibt BEIDE Mechaniken frei: Option 1 (Kandidaten direkt einkompiliert, Auswahl über CT-CoR, kein variant dafür) UND Option 3 (Dock-Array + Verdrängung). Die **Verschränkung**: die Heuristik-Hybrid-Achse ist als Strategieplanung **direkt im SearchAlgorithm-Hauptalgorithmus** aufrufbar, mit Ausgang „direkter Tier-Aufbau" ODER „Hybrid-Mehrfach-Aufbau" — im Code gibt es dafür 0 Andockstellen, und **kein HY-Paket plant sie** (Nichtfund mit Gegenprobe über Wellenplan v2).

**Die vierte Mess-Ebene.** Eigene Macro-Benchmarking-Schicht der Hybrid-Binary; gemessen wird der **Overhead des Reroutes zu multiplen Tier-Zielen am Hybrid-Prüfdock**; „dazwischengequetscht, nicht angehängt" — 3 werden 4. **Zwischen welche zwei, sagt keine Fundstelle wörtlich** (Suche inkl. Synonympaare = 0; Gegenprobe „drei Ebenen" trifft 4/7-fach). Strukturell abgeleitet aus der Dock-Topologie: E2 misst am CEB-Dock, E1 in der Tier-Binary, das Hybrid-Dock liegt dazwischen → die neue Ebene sitzt **zwischen E2 und E1** — das ist eine **Ableitung, kein Zitat**, vor dem Bau zu bestätigen. Drei Abgrenzungen sind aktenkundig und dürfen nicht verschmolzen werden: (a) checkpoint_measure-„vierte Ebene" = Filter-Rang, NICHT diese Schicht (LESEFALLE, README:98-122 + checkpoint_measure:259-281); (b) `MeasurementTooling{WallClock,Macro,Micro}` = INSTRUMENTE-Achse, stempelrelevant, CT-gewacht auf 3 — die 4. EBENE erweitert sie nicht automatisch; (c) die „fünfte Ebene" bleibt Nullbefund. Ob die 4. Ebene ein eigenes Blatt (`MessEbene`-4.-Wert oder eigener `MessEbenenSchluessel`) und/oder ein POD-Feld braucht, hängt an OV-3 und K5 — **beides ungeklärt; wo der Bestand schweigt, schweigt dieser Plan.**

**Wirkung auf den Bauplan.** Die Achse entscheidet je Zelle, ob 1 Binary entsteht oder ein Hybrid-Mehrfach-Aufbau — sie **multipliziert die Binary-Menge** und muss von `--check-size` mitgerechnet werden (GO-3, Ledger:1518-1521). `--check-size` existiert nicht (0 Treffer, Gegenprobe grün) und ist zugleich „das erste TODO" und Vorbedingung der Messplanung (GO-1, Ledger:1451-1463; Flattern-Abschnitt:12712).

**Wo der Bestand schweigt (benannte Lücken, keine Erfindung):** konkreter CT-Vererbungskopf (CRTP? Der §3.1-Sketch zeigt Komposition/Factory/Proxy, keinen `Base<Derived>`-Kopf); numerischer Mengen-Faktor; Fehlerklassen-Taxonomie der Stufe (nur HY-A3-Stichwort „+ Fehlerklassen"); Registry-Ziel von „22→23"; Ort/Welle der Verschränkung; fünfte Ebene.

---

## III. DER F8-MINIMAL-DoD, geprüft

**Drei Fassungen, kein Widerspruch, nirgends vereinigt** — hier die Vereinigung: genau **1 Standard-Dock** + Standard-Vertrag + **delegierter Bau** + Proxy + `hybrid_tier_module.cpp` (4 Pflicht-Symbole) + **ctest-bewiesen** + **Reroute auf 2 plain-Tier-Ziele**; **ohne Eviction, ohne XML** (README:60-61; soll_design K6:388-394; Wellenplan v2:404/:517/:601). Historische Wurzel: §32-F8-DoD „minimale Baseline … CEB-kompiliert+geladen, delegiert echte Tier-Binaries, ctest-bewiesen + Spline-Funktion je Achse" (Ledger:4210).

**Ist das lauffähig?** Ja — unter drei Vorbedingungen, die der DoD selbst nicht nennt:

1. **K2 muss vorher fallen**: der Proxy braucht `AnatomyModuleLoader` + `SearchAlgorithmDrive` aus der Builder-Lib; ohne (a) Extraktion oder (b) bewusstes Linken ist der DoD nicht linkbar (soll_design §7-K2).
2. **Verschachteltes dlopen ist empirisch zu belegen, nicht anzunehmen** (Risikotabelle §9: Entlade-Reihenfolge, RTLD-Flags, static-TLS-Budget). Die Tabelle verlangt „auf beiden Prod-Maschinen" — **prod2 existiert nicht** (`getent hosts prod2` rc 2, OV-5); ehrlich bleibt: prod1.
3. **Die Dock-Annahme hängt an E-1**: `SearchAlgorithmDock::accepts` matcht über `anatomy()->genus()`. Exportiert die Hybrid-Binary die SearchAlgorithm-Hülle (02.08.-Design), nimmt das bestehende Dock sie an — DoD läuft. Deklariert sie ein **eigenes** Genus (08.08. wörtlich), braucht es das 6. Dock + Enum-Wert, **die in HY-A gar nicht eingeplant sind**, und `test_e24_c4_genus_pruef_docks` wird rot, bis sie da sind. Der Minimal-DoD trägt diesen Konflikt in sich.

**Was der Minimal-DoD vom Owner-KERN NICHT abdeckt** — „ALLES PFLICHT" heißt: Restschuld, nicht Streichung. 12 Posten:

1. Gattung/Genus als Enum+Sub-Interface+POD+Dock+Wachen-Nachzug (falls E-1 = wörtlich) — nirgends in HY-A2.
2. Die 4. Mess-Ebene / Reroute-Overhead-Messung — erst HY-B (und OV-3-gebunden).
3. Die Heuristik selbst — HY-B nur Stub, echte Kurven erst HY-C.
4. Die Verschränkung im SearchAlgorithm-Hauptalgorithmus — **in keinem Paket** (Nichtfund, Gegenprobe grün).
5. `--check-size`-Mitrechnung — liegt in ##10/##10b, dort ohne Hybrid-Feld (Bericht: 17 „check-size"-Treffer, 0 mit Hybrid-Bezug).
6. Eviction/Verdrängung (§49) — HY-B2.
7. XML `<hybrid_tier>` — HY-A3/HY-B3 (siehe Widerspruch VIII.4).
8. K1-Lager-Identität — offen, Lager wirft compile-hart.
9. K5-Snapshot-Aggregation — offen; ohne sie hat ein Overhead-Wert keinen definierten Platz im nach oben gemeldeten POD.
10. Fehlerklassen-Taxonomie der Stufe (A15-Pflicht) — nur Stichwort in HY-A3; real deklarieren heute 0 von 121 Algorithmen einen eigenen Satz (deklarierte Lücke, `organ_axis_error_classes.hpp:82-84`-Befund der Anlage).
11. Release-Rekompilation + Wallclock-Gegenmessung der Sieger (Kette Ledger:5785) — HY-B4/W4.
12. Registry-Eintrag 22→23 — HY-A3, Ziel ungeklärt (E-6).

Streichrecht daran hat nur die Kaskade: HY-C auf EINEN belegten Fall reduzierbar (Rang 3); **HY-A/HY-B sind „NICHT streichbar"** (Wellenplan v2:631).

---

## IV. PAKETE, nach Abhängigkeit sortiert

Vorab gewürfelt (K13, `/dev/urandom`, heute): `651155ed` `9bbcb2b0` `73fdeaaa` `f0a01c9e` `04aa13b8` `f8b609dd` `f69e9e6d` `6bf23d9f`. Kein Token stammt aus einer Doku.

**HY-E — Entscheidungs-Vorlage (kein Code).** Inhalt = Abschnitt VII, EINE Vorlage. Blockiert HY-A2 (E-1, E-3), HY-A3 (E-6), HY-B1 (E-8/OV-3, E-4/K5), HY-C (E-9/OV-12, OV-1, E-5). Aufwand: 0,5 AT Vorlage. Halten erzwingt: nichts Maschinelles — **ungedeckt**, einzige Deckung ist die Frist im Wellenplan (OV-13 Mo 10.08., Register-Frist Mi 12.08.).

**HY-A1 — Dock-Contract + Prüfdock + Factory + Array (CT, lokal; nach OV-13).**
- **T-1 (Tag 1 ROT):** `test_hy_a1_dock_contract` — inkludiert `hybrid/hybrid_dock_contract.hpp` und assertet die constexpr-Registry (4 Verträge standard/rollback/scan/resource_control) + `DockSlot`-Variant-Kante. Rot, weil der Header nicht existiert (Compile-Fehler ist der Rot-Beweis).
- **Bauschritte:** `hybrid_dock_contract.hpp` (POD + Concept + constexpr-Registry nach Muster `run_methodology_registry.hpp`), `hybrid_pruef_dock.hpp` (nur StandardHybridDock im Minimal), `hybrid_dock_factory.hpp` (Abstract Factory, EINZIGER Konstruktionsort), `hybrid_dock_array.hpp` (Static-Policy MaxN=8, Runtime-Policy), CMake `add_subdirectory(hybrid)`.
- **Abnahme:** ctest-Zahl vorher/nachher (Nenner drucken); Konformitäts-Test „Hot-Path variant-frei" = static_assert, dass der gecachte Antrieb `IObservableTier*` ist und `DockSlot` der einzige variant-Träger im hybrid/-Baum (eigener kleiner Guard nach Muster Block D, Scope ausdrücklich hybrid/-lokal).
- **Köder (K13, `f0a01c9e`):** ein Vertrag-Token `contract_f0a01c9e`, der NICHT in der constexpr-Registry steht, muss **compile-time laut** brechen (Concept-Fehler), nicht runtime. Beobachtbarkeit: der Bruch muss aus der Registry-Prüfung kommen — Negativprobe mit gültigem Token im selben Testfile, damit nicht eine fremde Wache (Include-Fehler) den Mutanten fängt.
- **Halten erzwingt:** die neuen static_asserts selbst + Registrierung im Sammel-Target `comdare_tests` (T-7-Muster) + `hy_label_gate` (Anker der neuen Doku-Zeilen).
- **Aufwand:** 1–1,5 AT (Teil von An-10: HY-A gesamt 3–4 AT, „Planungsschätzung ohne Objekt-Basis, Bestand = 1 README").

**HY-A2 — Proxy + tier_module + Reroute-Beweis = F8-Minimal-DoD (nach E-1 und E-3/K2).**
- **T-1 (Tag 1 ROT):** `test_hy_f8_reroute` — lädt die (noch nicht existierende) `comdare_hybrid_tier_<genus>.so`, rot am fehlenden Target.
- **Bauschritte:** `hybrid_binary_proxy.hpp` (acquire: Loader + EINMALIGES Drive-Probing per dynamic_cast, gecachter `obs()`; release: destroy-vor-dlclose nach `anatomy_module_loader.hpp:70-75`), `hybrid_tier_module.cpp` (Export der 4 Pflicht-Symbole; Hüllen-Identität nach E-1), Verdrahtung an 2 plain-Ziele **aus dem Bestand** (76 gebaute .so liegen im lokalen Baubaum, z. B. `r5i_configure_pilot_0/1.so` — kein Neubau nötig, delegierter-Bau-Kanal darf im Minimal ein statischer Pfad-Injektor sein, als solcher markiert).
- **Abnahme + Köder (K13, `651155ed`/`9bbcb2b0`/`73fdeaaa`):** Roundtrip mit gewürfeltem Schlüssel k=0x651155ed, Wert 0x9bbcb2b0: (1) insert über das Hybrid-Interface bei Router-Stub „Ziel A" → **Beweis über den POD, nicht den Rückgabewert:** `snapshot(A).tier_fill_level==1` UND `snapshot(B).tier_fill_level==0` (Nenner: 2 Ziele); (2) Umschaltpunkt → Stub „Ziel B", insert 0x73fdeaaa → `snapshot(B).tier_fill_level==1`; (3) detach(A) → lookup(k) über das Hybrid muss MISS sein — beweist, dass der Weg wirklich über den Slot lief, nicht über eine stille Kopie. Drittes Ziel deklarieren → **compile-time-Bruch laut** (Wellenplan v2:601 verlangt exakt das).
- **Mutations-Beobachtbarkeit (Pflichtprüfung):** Mutant „Router schaltet nie um" stirbt in Phase 2 an `B.tier_fill_level==0` — am Köder selbst, nicht an einer fremden Zeile. Mutant „visit pro Op statt gecacht" ist über diesen Roundtrip **NICHT beobachtbar** (Verhalten identisch) — den fängt nur der HY-A1-Konformitäts-Test; das wird ausdrücklich so dokumentiert, damit niemand den Roundtrip als Beweis dafür liest.
- **Halten erzwingt:** ctest `test_hy_f8_reroute` (im Sammel-Target) + `hy_label_gate` + — falls E-1 „wörtlich" — `test_e24_c4_genus_pruef_docks`, der ein 6. Genus ohne 6. Dock rot macht.
- **Aufwand:** 1,5–2 AT + 0,5–1 AT nested-dlopen-Empirie auf prod1 (nur prod1; prod2 existiert nicht). Überlauf frisst 1:1 die WE-Option 22./23.08. (R-5).

**HY-A3 — `<hybrid_tier>`-Parser + Heuristik-Hybrid-Achse in die Registry + Fehlerklassen (nach E-6).**
- **T-1 (Tag 1 ROT):** `test_hy_config_fehlerklassen` — parst ein Minimal-`<hybrid_tier>` und erwartet je Fehlerklasse eine benannte `axis_error`-Domäne; rot, weil Parser fehlt.
- **Bauschritte:** `hybrid_config_xml.hpp` gegen common-DOM; Validierung **im C++-Validator** `validate_profile.hpp` (der Haus-Weg — die XSD-Reserve bleibt Kommentar, ihr eigener Text sagt „Validierung ist der C++-Validator, nicht das XSD"; damit ist der Widerspruch Wellenplan-W1 vs. soll_design-HY-B3 auflösbar, siehe VIII.4); Achsen-Eintrag in die per E-6 benannte Registry; Fehlerklassen-Satz der Stufe (BuildError-/Dock-/Contract-Domänen, additiv in `axis_error.hpp`-Muster).
- **Abnahme:** Registry-Zahl vorher/nachher gedruckt (22→23, „beide Zahlen" nach E-6-Klärung); alle Bestands-XMLs bleiben valide (byte-neutraler Beweislauf).
- **Köder (K13, `04aa13b8`):** contract-Token `04aa13b8` im XML → muss die benannte Fehlerklasse liefern, NICHT still default; Beobachtbarkeit: dieselbe Datei mit gültigem Token direkt daneben grün (beweist, dass der Rot vom Token kommt).
- **Halten erzwingt:** ctest + der bestehende CT-Zähl-Bruch der jeweiligen Registry (nach dem Muster `kMeasurementToolingCount`); für die Fehlerklassen-Vollständigkeit je Algorithmus: **ungedeckt** (deklarierte A15-Ebene-4-Lücke, ehrlich benannt).
- **Aufwand:** 1–2 AT.

**HY-B1 — Overhead-Messung der 4. Ebene mit Stub-Heuristik (W3-MESS; nach OV-3, OV-12, K5/E-4).**
- **T-1 (Tag 1 ROT):** `test_hy_vierte_ebene_overhead` — misst dieselbe Op-Folge einmal direkt am plain Ziel, einmal durch das Hybrid-Dock; erwartet einen Overhead-Datensatz mit Nenner (n Wiederholungen, beide Zahlen gedruckt); rot, weil der Mess-Kanal fehlt.
- **Bauschritte:** two_phase-Messung am Hybrid-Prüfdock (Muster `run_workload_perm`), Ablage je OV-3: hybrid-lokal = eigenes Blatt über `MessEbenenSchluessel` (kein Bump) ODER global = 7. Glied im `mess_gates_glied` (ALLE Binaries neu — 41,4 h Bau-Äquivalent als Preis ausweisen); Aggregation nach K5-Entscheid.
- **Köder (K13, `f69e9e6d`):** Stub-Heuristik, die deterministisch aus `f69e9e6d` je Aufruf das Ziel wechselt → der Overhead-Wert MUSS != 0 sein und die Zeile die Ziel-Wechselzahl tragen; Mutant „misst die plain-Zeit doppelt statt durchs Dock" stirbt an der Wechselzahl-Spalte (Beobachtbarkeit über eigene Spalte, nicht über Zeitvergleich allein — Zeiten können zufällig gleich sein).
- **Halten erzwingt:** ctest + (falls OV-3 global) die Preimage-/Sperrlisten-Wache ##14; falls lokal: **nur der Test selbst** — als Grenze benannt.
- **Aufwand:** 2–3 AT Bau + Messzeit der HY-B-Teilmatrix (unbeziffert — siehe VI).

**HY-C — Break-Even-Router aus echten Kurven (W4; nach OV-1, OV-12, E-5; Streichkaskade Rang 3 auf EINEN belegten Fall).**
- **T-1 (Tag 1 ROT):** `test_hy_router_konsum` — static_assert, dass `hybrid_router.hpp` die Typen `heuristik::AxisSpline`/`BreakEvenPoint` konsumiert (Typ-Identität, kein grep); rot, weil Header fehlt. Das ist zugleich die einzige maschinelle Deckung gegen den dokumentierten Bruch „[3] konsumiert [2] nicht" — heute **ungedeckt**.
- **Bauschritte:** CT-CoR über Break-Even-Tabellen; Kanon-Stack nach E-5 (vor dem §75-Pass, sonst entscheidet der Pass implizit); Bereichs-Erkennung nach OV-12; Anbindung `measurement_curve_loader` an den Messdaten-Realm; Verdrahtung T-10-Online-Zuordnung (Nearest-Centroid, noise→Default) als Last-Erkennung.
- **Köder (K13, `f8b609dd`):** zwei konstruierte Kurven mit GENAU EINEM Schnitt bei x\* = f(`f8b609dd`) (aus dem Token abgeleitete, im Test gedruckte Koordinate) → der Router muss exakt ab x\* das andere Ziel wählen; Beobachtbarkeit über Ziel-Identität beidseits von x\* (2 Proben je Seite, Nenner 4). Mutant „wählt immer Kandidat 0" stirbt an der rechten Seite.
- **Halten erzwingt:** ctest + E-5-Vermerk in der §75-NICHT-Kandidaten-Liste (heuristik/-API-Freeze, soll_design §6.6).
- **Aufwand:** 2–4 AT (auf 1 belegten Fall reduzierbar).

**HY-V — Verschränkung im SearchAlgorithm-Hauptalgorithmus (nach E-7; heute in KEINEM Plan).** T-1: `test_hy_verschraenkung_strategieplanung` (rot, Andockstelle fehlt). Köder (`6bf23d9f`): Strategieplanungs-Aufruf, dessen Ausgang „direkt" vs. „Mehrfach-Aufbau" am gewürfelten Lastvektor kippt. Aufwand: **unbezifferbar, keine Objekt-Basis** — ehrlich so gemeldet; gehört in die OV-Vorlage.

**CS-1 — `--check-size` rechnet Hybrid mit (Teil von ##10/##10b, W1).** T-1: Planrechnung mit aktiver Heuristik-Hybrid-Achse erwartet `hybrid_zellen >= 1` und einen eigenen Summanden — rot, weil `--check-size` selbst 0 Treffer hat. Halten: der ##14-Freeze-Gate-Anschluss. Aufwand: im ##10-Budget.

---

## V. DIE KLEINSTE STRECKE, die einen echten Reroute beweist

**Ein Dock, zwei Ziele, ein ctest — konkret:** 5 neue Dateien (`hybrid_dock_contract.hpp` nur mit „standard", `hybrid_pruef_dock.hpp` nur StandardHybridDock, `hybrid_binary_proxy.hpp`, `hybrid_dock_array.hpp` nur Static-Policy, `hybrid_tier_module.cpp`) + 1 CMake-Anschluss + `test_hy_f8_reroute`. **Ohne** Eviction, **ohne** XML, **ohne** Router (Stub-Umschalter im Test), **ohne** variant — bei genau 1 Dock-Typ ist die variant-Erlaubnis nicht gebraucht (Erlaubnis, keine Pflicht; der Hot-Path-Konformitäts-Test bleibt trotzdem gesetzt). Ziele: 2 der 76 im Baubaum liegenden plain `.so` (nachgezählt). Beweis, der beißt: der gewürfelte Roundtrip aus HY-A2 mit POD-Beobachtung (`tier_fill_level` je Ziel), detach-MISS-Probe und Compile-Bruch beim dritten Ziel — inklusive der ausdrücklichen Grenze, welchen Mutanten er NICHT sieht (visit-pro-Op).

**Wie lange wirklich:** 1,5–2,5 AT Bau + 0,5–1 AT dlopen-Empirie, **plus** die nicht wegdiskutierbaren Vorkosten: E-1 und K2 müssen vorher entschieden sein (sonst ist schon das Linken bzw. die Dock-Annahme geraten). Alle vorhandenen Schätzungen dazu sind als „ohne Objekt-Basis" markiert (An-10: HY-A gesamt 3–4 AT; Register: Hybrid-Minimal ~55 h von ~90 h Station-7-Soll — die 55 h enthalten mehr als diese Strecke). Jeder Überlauftag frisst 1:1 die WE-Option 22./23.08. (R-5).

---

## VI. DIE MENGEN-WIRKUNG, beziffert so weit der Bestand trägt

**Was heute rechenbar ist (jede Zahl mit Nenner):**
- Voll-Matrix ungedeckelt: **≥143 Maschinentage einthreadig** (Untergrenze, doppelt als solche markiert; Basis 0,1094 s/Zelle, Spanne Faktor 69) — Wellenplan v2:69-71. Deckel: **ETA ≤ 4,5 Maschinentage** = 3,1 % der Untergrenze (4,5/143).
- Bau des Bestands: **128 Binaries × 19,4 min ≈ 41,4 h** auf prod1 (v2:71) — das ist der Preis, den OV-3=„global" (7. Bump-Glied) erneut fällig macht.
- Minimalfall F8: **+1 Hybrid-.so, +0 plain-Neubauten** (2 Ziele aus 76 vorhandenen; delegierter Bau holt Bestand).
- Kardinalitäts-Anker: **Ein Hybrid-Binary je Gattung** (Q6), **MaxN=8 Docks je Instanz** (Q6) — MaxN deckelt die Kanäle je Hybrid, ist aber KEIN Faktor auf die Gesamtmenge.

**Strukturformel (Ableitung, so gekennzeichnet):** je (Gattung × Lastprofil mit erkanntem Flatterbereich): 1 Hybrid-.so + min(k,8) plain-Sieger (aus dem Bestand, kein Neubau) + deren **Release-Rekompilate** (Kette Ledger:5785: Sieger werden ohne Mess-Einrichtung neu kompiliert und wallclock-gemessen) — Release-Rekompilate sind der einzige echte Neubau-Summand, Größe = Σ k je Profil. Dazu quer die **M-06-Bau-Varianten der Thesis: ×3** (Beobachter überall+Hybrid / nur im Hybrid / nirgends; 05_evaluation:180-186) — der größte benannte Multiplikator, und heute **nicht herstellbar**: von den 6 geforderten CEB-Varianten sind höchstens 2 baubar, weil G2/G3 sich ein Gate teilen (`mess_achsen_naht.hpp:75-95`).

**Wo die Zahl fehlt — und das ist der Befund:** kein Dokument beziffert #Lastprofile, k je Profil oder n je HY-B-Zelle („n je Zelle" ist wörtlich der Platzhalter, v2:542-Umfeld). **Passt HYBRID in den 4,5-Tage-Deckel?** Die Frage ist per Konstruktion ausgeklammert: OV-4 definiert die Messmenge als Deckel-Teilmenge „**plus HY-B als eigene kleine Teilmatrix daneben**" (v2:647) — HY-B steht AUSSERHALB des Deckels und ist unbeziffert. Ehrliche Antwort: **unbeantwortbar, bis ##10/##10b (`--check-size` mit Hybrid-Summand, CS-1) und EIN gemessener HY-B-Punkt existieren.** Genau deshalb ist `--check-size` Vorbedingung der Messplanung (GO-1), nicht ein Posten daneben.

---

## VII. OWNER-ENTSCHEIDE — ja/nein-fähig formuliert, beide Folgen

**E-1 (NEU, vor HY-A2 — der Kern-Konflikt):** *Bekommt HEURISTIK-ADAPTER einen eigenen Eintrag in AnatomyGattung (4. Wert) und Function-Interface-Reroute einen in AnatomyGenus (6. Wert), sodass `anatomy()->genus()` der Hybrid-Binary das EIGENE Genus liefert — ja/nein?*
— **JA:** Hauspattern greift vollständig (neues Dock + Sub-Interface + eigener Snapshot-POD, pruef_dock.hpp:10-14; Wachen test_e24_c4 + Guard-Totalität erzwingen den Nachzug); nach Präzedenz AP-15-2 major-neutral möglich, ABER der 02.08.-Satz „KEINE ABI-Änderung" muss zu „kein Major-Bump" präzisiert werden, die E-24-Sequenz „Container = LETZTER ABI-Schritt vor Voll-Bau-4" (soll_design §6.2) bricht formal, und HY-A wächst um ~1–2 AT (Enum, Traits, 6. Dock, POD-Guard-Liste 12→13).
— **NEIN (Gattung informell; 02.08.-Modell hält):** Hybrid exportiert die Ziel-Genus-Hülle, F8-DoD läuft am bestehenden SearchAlgorithmDock, ABI-Nulllast hält wörtlich — aber der jüngste Owner-KERN („eigene Gattung", Rangfolge OWNER > PLAN) bleibt unerfüllt und der Ledger-GO-3-Satz („mit eigenem Genus, eigenem Interface, eigener ABI") wird zur bloßen Metapher. Merge-Angebot zur Abstimmung: eigene Klassifikation + geerbtes Ziel-Interface (deckt den Owner-Wortlaut „erbt die Interfaces einer Gattung+Genus") — dann ist NUR noch die Rückgabe von `genus()` zu wählen.

**E-2 = K1 (vor Lager-/A13-Freeze; Register-Frist Mi 12.08.):** *Bekommt die Hybrid-.so eine eigene Einlagerungsform (Stempel-SHA512 + Sidecar-Manifest) — ja/nein?*
— **JA:** L3-Wache wird per Owner-Gate gedreht (der static_assert-Text verlangt das wörtlich), Binaries-Realm bekommt den Schlüssel, SKIP-Doktrin gilt auch für Hybride. — **NEIN:** Hybrid = reines Auswertungs-Artefakt, wird je Lauf neu gebaut; Lager bleibt hybrid-frei; Wiederverwendung über Läufe entfällt (Baukosten je Auswertung erneut).

**E-3 = K2 (vor HY-A2):** *Werden AnatomyModuleLoader + Drive-Bündel in eine stufen-neutrale Lib extrahiert — ja/nein?*
— **JA (Design-Vorzug):** Doktrin-Zeile „IPruefDock lebt nur im Builder-Binary" bleibt unberührt; Kosten: Extraktions-Paket vor HY-A2. — **NEIN:** Hybrid linkt bewusst die Builder-Lib; schneller, aber die Doktrin-Kommentare (pruef_dock.hpp:10-14) brauchen eine additive Präzisierung, und die CEB-superset-Schichtung trägt eine dokumentierte Ausnahme.

**E-4 = K5 (vor HY-B1/B4):** *Aggregiert der nach oben gemeldete EINE Snapshot als Summe über alle Docks — ja/nein?*
— **JA (Summe):** Gesamtbild über alle Docks, Provenienz je Sub-Tier geht in den POD-Zahlen verloren → Sidecar-Vermerk Pflicht. — **NEIN (Passthrough der aktiven Binary):** saubere Provenienz des aktiven Ziels, Beiträge der übrigen Docks unsichtbar; der Reroute-Overhead braucht dann einen EIGENEN Kanal außerhalb des POD (OV-3-Kopplung). Bis zum Entscheid gilt keine Variante als implizit gesetzt (soll_design §7-K5).

**E-5 (vor §75-Pass und HY-C):** *Ist `heuristik/` (axis_spline + break_even + measurement_curve_loader) der kanonische Kurven-Stack — ja/nein?*
— **JA:** builder/curve_fit + Selector-Hälfte-B werden Konsumenten/Deprecate-Kandidaten; Selector wird auf „ein Sieger JE Eingangslast" umgestellt (statt globalem Mittel — der dokumentierte Definitions-Fork). — **NEIN:** dann benennt der Entscheid den anderen Stack, und heuristik/ verliert seinen §75-Freeze-Schutzgrund. Ohne Entscheid entscheidet der Aufräumpass implizit — das ist der teuerste Ausgang.

**E-6 (vor HY-A3):** *Meint „Registry (22→23, beide Zahlen)" das Paar AllStrategies-Typen/Achsen-Aggregat (heute 22/26, 264-a2-Snapshot „22/26 Compiler-bestätigt") — ja/nein?* Gemessene Kandidaten: AllStrategies = 22 Typen (PAPER_REFERENCES.md:60, autoritativ), Achsen-Aggregat = 26 (axis_observer_classification.hpp:2), `cache_engine_axis_registry.xml` = 18 `<axis>`, `system_axis_registry.xml` = 3 `<axis>`. Keine Achsen-Registry steht heute auf 22 — ohne Klärung trägt HY-A3 die Zahl in die falsche Datei.

**E-7 (Einplanung):** *Wird die Verschränkung (Heuristik-Hybrid-Achse als Strategieplanung im SearchAlgorithm-Hauptalgorithmus, zwei Ausgänge) als eigenes Paket HY-V nach HY-C eingeplant — ja/nein?* — JA: Owner-KERN vollständig gedeckt, Aufwand unbeziffert, frisst Fenster. — NEIN: bewusste Nach-W7-Schuld mit Vermerk; der KERN bleibt teilerfüllt.

**E-8 = OV-3 (Mi 19.08., VOR ##34):** *Hybrid-Macro-Schicht hybrid-LOKAL — ja/nein?* — JA (Empfehlung v2): kein Bump, plain-Fingerprint unberührt, 4. Ebene lebt in der Berichts-Nummerierung + eigenem Blatt. — NEIN (globales 7. Glied): ALLE Binaries neu (≈41,4 h Bau + Identitätsfenster-Risiko R-2).

**E-9 = OV-12 (Mo 17.08.):** *Flattern = Signal (Bereichs-Erkennung) — ja/nein?* — JA: Ledger:12694-12708 wird operativ, HY-B misst gezielt im Flatterbereich. — NEIN (Hysterese-Band): unterdrückt exakt das Messobjekt der 4. Ebene; HY-B-Design ändert sich grundlegend. Bis dahin wird keine Variante verdrahtet.

**E-10 = OV-13 (Mo 10.08. — MORGEN, unbeantwortet):** *HY-A/HY-B/HY-C-Zerlegung mit F8-Minimal-DoD als Pflichtkern — ja/nein?* — JA: hält KERN und E1-Design gleichzeitig. — NEIN (v1 gilt): W1 entspannt sich um ~4 Tage, ##40 kehrt zurück, HYBRID rückt nach W7 — kollidiert mit „Alles Pflicht" bei 5 verbleibenden Freitagen.

**E-11 = Q10.3 (nach A13, an K1):** *Eigenes Hybrid-Kennzeichen im System-Stempel-Array — ja/nein?* (JA: Stempel trägt die Natur, golden-relevant prüfen; NEIN: nur Sidecar.) **E-12 = Q10.4:** *Eviction-Shortlist-Recherche in HY-B2 belassen — ja/nein?* **E-13 = Q10.5:** *Hybrid explizit in die Plattform-Matrix (RISC-V/macOS) — ja/nein?* **E-14 (klein, vor HY-B1):** *Bleibt `MeasurementTooling` bei 3 Werten (Ebene ≠ Instrument) — ja/nein?* (JA-Empfehlung: die 4. EBENE ist Gegenstand, kein Instrument; die CT-Wache kMeasurementToolingCount=3 bleibt.)

---

## VIII. WIDERSPRÜCHE, gezeigt statt geglättet

1. **Gattung (08.08., Owner) vs. Stufe mit SearchAlgorithm-Hülle (02.08., Design):** beide belegt, nirgends rekonziliert; die Begriffe kommen in keiner Datei gemeinsam vor. → E-1.
2. **„eigener ABI" (Ledger-Deutung GO-3) vs. „ABI-Nulllast" (soll_design §6.1):** Merge über die major-neutrale Sub-Interface-Präzedenz (AP-15-2) möglich, aber der wörtliche Nulllast-Satz („KEIN POD-Feld, KEINE ABI-Änderung") fällt bei E-1=JA.
3. **E-24-Sequenz „Container = letzter ABI-Schritt vor Voll-Bau-4"** (§6.2) vs. jede spätere Gattungs-Erweiterung.
4. **HY-A3-Parser in W1** (v2:404) vs. **„XML scharf erst HY-B3"** (soll_design §8): auflösbar, weil die Validierung per Haus-Doktrin im C++-Validator lebt und die XSD Kommentar-Reserve bleiben kann (XSD-Reserve-Text selbst) — aber es ist eine Planänderung gegen das bindende Design und gehört benannt.
5. **K4 „ENTSCHIEDEN"** (Design §7, Ledger:1702) vs. **K4 „ungeklärt bis Mi 12.08."** (Register:170) — vermutlich ist der NEUE Gattungs-Konflikt gemeint; steht dort nicht.
6. **Zwei Fristenkalender:** Register „K1/K2/K4/K5 Mi 12.08." vs. Wellenplan „OV-3 Mi 19.08. / OV-13 Mo 10.08. / OV-12 Mo 17.08.".
7. **Thesis führt das superseded Framing** („Heuristik-Optimierung ist eine System-Achse", 03_messsystem:1458) und Hybrid im Präsens (04_implementierung:193; ADR-11 ohne Vollzugsstand-Feld, das ADR-12 hat); Limitierungs-Tabelle ohne Hybrid-Zeile (nur „hybrider Visitor", :34). DE darf nachgezogen werden (Posten 90 + M-06-Limitierungszeile, P-1-Klasse).
8. **„DockSlot = einzige variant-Ausnahme"** (Auftrags-KERN) vs. CEB-Duldung + 2 laufende achsenfremde Nutzungen + TEST-ONLY-Cluster; Wache nur über 11 Referenz-Anatomien. Der Satz ist als Zonen-Aussage wahr, als System-Aussage heute weder wahr noch bewacht.
9. **„beide Prod-Maschinen"** (Risikotabelle §9) vs. prod2 existiert nicht (`getent` rc 2; OV-5).
10. **Fünf Bedeutungen von „Hybrid"** im Korpus (Tier-Stufe/Gattung · Hybrid-CPU · PRT-ART-Hybrid · Mess-Schema-Modus · Messmodell 30.05.) und **zwei „vierte Ebenen"** (gebaute Schicht vs. Filter-Rang) und **zwei „OV-13"** (v1 Paper / v2 Hybrid) — drei aktenkundige Verwechslungsfallen, die jede künftige Anweisung explizit adressieren muss.

**Kritischer Pfad in einem Satz:** OV-13 (morgen) → E-1 + K2 → HY-A1/A2 (F8-Strecke, W1, WE-Deckung 22./23.08.) → E-6 → HY-A3 → OV-3 + OV-12 + K5 → HY-B → OV-1 + E-5 → HY-C; parallel CS-1 in ##10, HY-V nur per E-7; K1/Q10.3 vor jedem Lager-/Stempel-Kontakt — und keine Zeile Code vor dem jeweiligen Entscheid, weil das Lager, die Wachen und die E-24-Sequenz genau das compile-hart bzw. testrot erzwingen.