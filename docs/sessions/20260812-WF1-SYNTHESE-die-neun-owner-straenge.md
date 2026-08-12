# WF1-SYNTHESE — die neun Owner-Straenge (12.08.2026)

> ⚠️ BERGUNGS-VERMERK: der KOPF dieser Synthese (Titel + Abschnitt 1 A-C + Anfang von D) ist
> beim Agenten-Return verloren gegangen (Return beginnt mitten im Satz). Die VOLLSTAENDIGEN
> gepruefte Antworten der Straenge A/B/C/D liegen geborgen in
> `20260812-WF1-BERGUNG-verify-ABCD.md` (aus dem Journal, das die Wahrheit ist).
> 45 von 46 Agenten fertig; 1 Schnitt-Agent starb am StructuredOutput-Limit (Strang von
> parallel[0], durch 3 verbleibende Schnitte + Gegenprobe gedeckt).

Engpass Intel) Wanduhr; ältere Zahl „41,4 h für 128" — ob 128 Binaries oder 128 Mess-Scheiben zählt, ist in den Quellen selbst als Rechenlücke benannt | Ledger N-3; WELLENPLAN-369:340; ANKNUEPFPUNKTE:868-896 |
| Marginalkosten je zusätzlicher Instanz | **fehlt** — keine Messung vorhanden, nur Ganzbaum-/Ganzlauf-Kosten | — |

**Runner-Rahmen (selbst strittig, drei kursierende Werte, keiner live verifiziert):** concurrent 3/2 gemessen 26.07. → 4/4 seit Commit 27.07. (Stand 06.08., „NICHT live am Host verifiziert") → OD-7-SOLL 2/2×12 Threads, HEAVY concurrency=1 mit 24 Workern auf prod1 — die 24 übersteigen dessen 16 Kerne/32 Threads (lscpu 10.08., W-2). prod2 war am 08.08. von prod1 per Hostname nicht auflösbar (`getent hosts prod2` → rc=2, „Es gibt genau eine Lane"); die Owner-Vorlage „Bleibt prod2 im Job-Pool?" ist seit 17.07. unbeantwortet (KON3-02, Rang BLOCKIEREND). Job-Anzahl-Doktrin: O(Maschinen), **nie** O(Binaries) (Owner 21./22.07., Ledger §62-B). Die RAM-Sequentialität aus KON17-01 (CEB-Bauten und von der CEB verlangte Builds sequentiell) ist die neueste Owner-Vorgabe zu diesem Komplex.

---

### E · Frage 7: „eigene Bedürfnisse" je Träger — **VOM OWNER ENTSCHIEDEN: Lager-Kriterium**

Owner wörtlich (KON17-02, Rohtranskript `:43753`): *„Das ist korrekt. Die Emission ist abgeschlossen, wenn die angeforderten CEBs und Tier-Binaries und Hybrid im Lager zu finden sind und damit in der Phase der Messung verwendet werden können."*

Ledger-Verdichtung: Emission FERTIG ⇔ im **Lager** auffindbar und messbereit; **nicht** fertig bei „kompiliert", „gelinkt", „Tests grün" oder „Prozess beendet". Die Pflicht-Reihenfolge muss **mitemittiert** werden, sonst falsches Grün:

```
J-1 Werkzeuge zuerst (adhoc_emitter_cli, anatomy_codegen_cli, alle *_registry_gen)
J-2 RE-CONFIGURE
J-3 --target comdare_limits_generated_source_catalog
J-4 Vollbau -> --target comdare_tests -> Voll-ctest
```

**Träger × Rolle (jede Zeile Owner-belegt):**

| Träger | baut? | wird gebaut von | Eigenheiten | Ablage |
|---|---|---|---|---|
| Planer | emittiert; baut selbst nichts Nachgelagertes | **direkt kompiliert** (einziger, KON17-01) | genus-los (einziger) | nur Wurzel Buildsystem-Cache, kein Lager (Owner 11.08. 18:03, `:42298`) |
| CEB | **einzige, die kompiliert und baut** — Tier UND Hybrid, sequentiell auf derselben Stufe, erst Tier („Das kompilieren und bauen macht ja nur die CEB", `:43439`) | Planer-Emission | Bedürfnisse bescheiden/kompatibel: „kein AVX in der CEB" (`:41864`); erkennt erweiterte HW zur Laufzeit und gibt sie an Tier/Hybrid frei | Wurzel + Lager (hat Gattung+Genus; ABNAHME-5: nicht genus-los) |
| Tier | nein | CEB | „misst und wird gemessen" | Lager, volle Kaskade |
| Hybrid | **kann nicht bauen** | CEB, nach Tier, selbe Stufe | nur messen, Endpunkt; nicht stempelfrei (eigenes Genus, Fläche 2, `:42174`) | Lager; Identität K2/K5 offen (KON18-02) |

**IST (11.08., nachgezählt):** 0 von 4 Trägern haben einen eigenen Bau-/Test-Job oder Cache-Schlüssel in der eingecheckten CI; „hybrid" hat 0 Treffer in beiden CI-Dateien (super `.gitlab-ci.yml` 2768 Zeilen/45 Jobs; ce 1056/25 — Zeilenzahlen exakt verifiziert).

**Von der Antwort nicht wörtlich gedeckt:** Lint und Release (die Rückfrage `:43491` fragte ausdrücklich danach) sowie die ursprünglichen O-11-Dimensionen (Runner-Tags, Toolchain, Sanitizer-Profil, Test-Suite je Träger) — die Owner-Antwort schließt die **enger gefasste** Frage (Emissions-Abschluss), nicht die alte Dimensionsliste. → Frage F8.

---

### F · Frage 12: C-4-Wache — **VOM OWNER ENTSCHIEDEN: modular erweitern + Detail-Klassen-Split**

Owner wörtlich (KON17-03, Rohtranskript `:43753`): *„Wache Modular erweitern und in Detail-Klassen splitten."* — Weder „einfach erweitern" noch „zweite daneben": **ein** Werkzeug/CI-Job/Lock-Bestand, intern in Detail-Klassen getrennt. KON17-03 liefert das WAS; das WIE (Klassennamen, Schnittstellen) ist nirgends spezifiziert — das ist der nächste Design-Schritt.

**Zahlen für den Klassen-Schnitt (alle am Objekt verifiziert, ce `670483c0`):**

| Bestand | Zahl | Beleg |
|---|---|---|
| Wache deckt heute | 6 Dateien, alle `libs/cache_engine/heuristik/` | `axis_version.lock` (9 Zeilen = 3 Kommentar + 6 Daten); CI-Job-Pfade hartkodiert `.gitlab-ci.yml:780-785` |
| Mechanik | SHA-256 über rohe Bytes + Marker `// AXIS_ALGO_VERSION: <N>`; Digest-Änderung ohne Bump ⇒ ROT | `axis_version_lock.cpp` (210 Zeilen), `:63-81, :145-190` |
| Historie | erstellt 19.07. (`7492b2ea`); **3 Wochen faktisch tot** (doppelter YAML-Job-Schlüssel), geheilt 06.08. (`597ecffe`, `557d8023`); Scope 3→4→6 | git log |
| axes/-Header gesamt | 371 (345 direkt unter `axes/` + 26 verstreut) | git ls-files, dreifach reproduziert |
| davon mit `algo_version` | 130 (Ledger: 104 echte Zuweisung / 26 Prosa; Zweitzählung 103/27 — 1 Grenzfall) | KON14-04 + eigene Messung |
| + queuing-Träger | 22 von 42 unter `topics/queuing/` → Grundgesamtheit **≥152** (ob >152: ungeprüft) | KON14-04, nachgezählt |
| Schnittmenge Wache ∩ axes | **0** | dreifach verifiziert |
| `AXIS_ALGO_VERSION` repo-weit | genau 8 Dateien: 6 echte + Tool selbst + 1 Prosa-Fehltreffer (`csv_cell_reader.hpp:16` — erklärt die alte „7") | Gegenprobe |
| vorhandene axes-Schichten | 19 Concept-Basisklassen (nur Präsenz-Zwang, keine Wertprüfung)[^f19]; 2 CT-Grammatik-Tests über alle 18 Achsen; 1 Literal+Wirkungs-Pin für **1 von 18** Achsen (`test_a1…`, 276 Zeilen) | eigene Doppelmessung |
| Drift-Erkennung für axes | **0** — nur der Digest-Tripwire fängt stillen Inhalts-Drift, und der deckt 0/152 | KON2-19 („riegelt keinen einzigen Achsen-Varianten-Header") |
| Mutationsbeweis der Wache | fehlt (T-i-2 geplant, nicht gebaut) | PLAN-testoffensive:207-223 |

**Die zwei Vokabulare, die der Klassen-Schnitt trennt:** heuristik-Regime (Kommentar-Marker + Ganzzahl, L5-Stufe — eigene optionale Binary zwischen CEB und Tier, Owner 05.08.) vs. axes-Regime (C++-Member `algo_version = "X.Y.Z.c"`, Semver-Grammatik v2, Organ-Ebene). **Konsequenz aus der Historie:** die hartkodierte 6-Pfad-Liste war Mitursache des Drei-Wochen-Ausfalls — bei 130/152 Dateien wäre derselbe Fehler zehnfach vergrößert; Autodiscovery über die vorhandenen Registry-Typlisten ist die im Bestand vorgezeichnete Alternative (test_a1 macht es für eine Achse vor). Priorität: laut KON16-08 „hoch", vor F2. Offen: Scope queuing (→ Frage F6).

---

## 3. DIE DREI NEUEN ARCHITEKTUR-AUSSAGEN — was der Code dazu sagt

### G · Frage 14: STUFE = PHASE, Umbenennung angeordnet — **AUSSAGE BESTÄTIGT, Kollision real**

Owner wörtlich (Rohtranskript 11.08. 22:56:44, `:43439`): *„Ja genau ein Synonym, aber muss jetzt konsistent wegen Kollision umbeannt werden."* [sic]. Das überstimmt die feinere Unterscheidung des Klärungsdokuments vom 06.08. (STUFE = achsen-relative Gliederzahl, dehnbar 3/2/2→4/3/2; PHASE = Kettenposition, fest 3) — Owner-Wort schlägt, Neueres schlägt Älteres; die Kollisionskarte des 06.08.-Dokuments (Z-1…Z-14) bleibt als Bestandsaufnahme gültig.

**Härteklassen der Kollision (am Objekt verifiziert):**

1. **Härteste Stelle — Schema/Golden:** `Code/test_data_xml/experiment_schema.xsd:41,245-255` definiert ein XML-Element namens `phase`/`phases`, dessen Enum-Werte `Stufe1_CeOnly`/`Stufe2_PrueflingReplace`/`Stufe3_FullJoin` heißen — Phase und Stufe buchstäblich gleichgesetzt. Dieselben Werte als C++-Enum `MergeStrategy` (`pruefling_merge.hpp:131-135`), als String-Literale (`validate_profile.hpp:625-627` u. a.) und live in Golden-Fixtures (`experiment_golden_kern.xml:37-41`). Umbenennung bricht Byte-Identität von Schema und Golden-XML — **schema-wirksam, nicht preimage-wirksam**[^gpre].
2. **CI:** super `.gitlab-ci.yml` trägt 40 native `stage:`-Schlüssel neben 31 deutschen „Stufe N"-Kommentaren (case-insensitiv gezählt; case-sensitiv nur 16 — Versalien-Falle); Paradezeile `:1477` „Stage manifest (… Stufe 7)" in einer Zeile. **Job-Schlüssel selbst sind sauber:** 0 Treffer stufe/phase in den Bezeichnern aller drei lebenden `.gitlab-ci.yml` (Gegenprobe mit `test:`-Muster griff).
3. **„Stufe" ist schon ohne „Phase" doppelt belegt:** Träger-Kette vs. §61-Modi-Leiter (debug→measure→compare→release) — der Code warnt selbst: „NICHT zu verwechseln mit §61-STUFEN … eine andere Doktrin mit demselben Wort" (`mess_achsen_naht.hpp:156-168`).
4. **Auszusparende Fremdbedeutungen** (14 Sinnklassen erhoben): bei „Stufe" u. a. Optimierungsstufe, AVX/ISA-Leiter, Freeze-Konstanten (`kWideSchemaFreezeStufe1` …), Warnstufe, Ausbaustufe/Blattstufe/Rangstufe, sowie die Workflow-Stufen der Arbeitsweise-Doktrin (eigenes bindendes Dokument); bei „Phase" die Zwei-Phasen-Messschleife (`two_phase_valid`, Homonym ohne Drei-Phasen-Gegenpart), die Stempel-Ausrollung „PHASE 1/2" (`anatomy_version_stamp.hpp:118-125`), der Marker `phase=bau|pruef|mess` (F-6-Vorschlag vom 06.08.: → `schritt=`, offen) und die Roadmap-Makros `COMDARE_PHASE_B_LEVEL0_PIN` (11 Aufrufe) / `COMDARE_PHASE_E_BOOST_TESTS`.

**Rohzahlen** (unbereinigt, inkl. Fremdbedeutungen; Ziel-/Fremd-Verteilung bewusst nicht erhoben): Stufe-Familie: ce-Code 1.109–1.578 Zeilen je nach Dateityp-Zuschnitt (zwei Messungen), Ledger 450, Pläne 841, CI-YAML 65 (3 Dateien), Sessions 827, Backups 5.382. Phase-Familie: ce 1.415–1.460, Ledger 345, Pläne 634, CI-YAML 2, Sessions 1.003, Backups 8.085.

**Zielbegriff:** laut KON18-02 ausdrücklich **Owner-Wahl** („gewinnt ‚Phase', ‚Stufe' oder ein dritter Begriff? … die BEGRIFFS-Wahl ist Owner"). Beobachtete Kandidaten, unverbindlich: „Träger-Stufe" (Owner-Sprachgebrauch seit 11.08., löst die Kollision nicht — enthält „Stufe"), „Kettenglied" (20 Belege, am wenigsten fremdbelegt; blankes „Glied" 429 Rohtreffer, Nebenbedeutungen ungeprüft), „Grad"/„Etappe" (~0 belegt). **Gesperrt:** „Station" (8-Stationen-Kette), „Träger-Typ" (kollidiert mit fester 3-Typen-Zählung), „Ebene" (E1–E4, Storage-Ebenen), „Tier"/„Level".

---

### H · Frage 3/5: keine YAML, zentrales Bau-Modul, Tiefe 3 — **TEILS GEBAUT, EIN BENANNTER WIDERSPRUCH**

**Existiert:** Das zentrale Bau-Modul ist `ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` (2352 Zeilen): `IPlanBuilder` (`:223`), sechs Emissions-Builder (PlanText `:389`, PlanSize `:489`, CMakeGraph `:532`, CiYaml `:913`, TierCiYaml `:1186`, TierCmakeGraph `:1794`), `ExperimentPlanDirector` (`:2049`, ein Walk `:2290`) — plus drei weitere IPlanBuilder-Implementierungen in `profile_run_facade.cpp` (Legend/StatusSoll/MengenSoll, `:927/:1430/:1498`). Verdrahtet an zwei Binaries: `comdare-experiment-planner plan ci|cmake` (ce) und `comdare-messung-driver tier ci|cmake` (super `Code/02_messung_driver/main.cpp:329/339`). Contract-Test registriert (`tests/unit/CMakeLists.txt:3920`). „Wiederverwendbar im Builder Pattern" ist damit wörtlich erfüllt; KON18-01 (12.08., neuestes Owner-Wort) präzisiert die Bauform: *„Wir vermeiden immer noch skripte ausser C++ und cmake und giessen alles in binary. Daher ist zum Beispiel das Baumodul eine Planer Bibliothek in C++23."* — der Bestand ist reines C++23.

**Emission = Text, kein Prozess:** 0 Treffer system/popen/fork/exec/posix_spawn im Bau-Modul (Gegenprobe: 8 Klassen gefunden). Reale Compiler-Prozesse sitzen eine Schicht tiefer: `build_orchestrator.hpp` (`posix_spawnp :998`, `std::system :975/1052`) und Legacy `experiment_driver.cpp:260/280`. Lesart der Owner-Aussage am Objekt: das Modul emittiert die **Beschreibung** von Pipe/Prozess (CI-YAML- bzw. CMake-Text), der reale fork/exec läuft später (Runner bzw. `cmake --build`); CEB→Tier hat mit dem BuildOrchestrator heute schon einen YAML-freien Prozessweg, Planer→CEB läuft ausschließlich über emittierten Text. KON17-01 bestätigt: „Nur Planer wird direkt kompiliert … alles danach entsteht durch Emission."

**Tiefe 3:** bestätigt, unabhängig **vor** der Owner-Aussage dokumentiert (`mess_achsen_naht.hpp:325`: „dreistufig: Planer → CEB → Tier"). Das GitLab-Nesting-Budget (2 Kind-Ebenen) ist durch Planer→CEB→Tier genau belegt (Code-Kommentar `:909-910`); der Hybrid kostet keine Ebene, weil die CEB ihn auf derselben Stufe wie Tier baut (KON16-04) — deckungsgleich, kein Widerspruch.

**Nicht gebaut:** die Sequenz „erst Tier, dann Hybrid durch die CEB" — 0 Treffer „Hybrid" im gesamten Bau-Modul (Gegenprobe „Tier" = 35); `libs/cache_engine/hybrid/` trägt nur 4 Klassifikations-Header (943 Zeilen) ohne Build-Anschluss; README wörtlich: Reroute/Prüfdock/Tier-Modul „bleiben Folgepakete (HY-A2/A3) … weiterhin NICHT gebaut". K2 (Loader-Schicht) und K5 (Snapshot-Aggregation) sind laut KON18-02 „ausdrücklich unentschieden"; KON19-02 gibt für K5 eine erste Richtung (Thread-Aggregation über die Genus-Interfaces/Fläche 3 durch den Hybrid zur CEB durchgereicht). SOLL-Posten, kein Baufehler — deckt sich mit der ORT≠ZEIT-Doktrin.

**Der benannte Widerspruch — CiYamlBuilder vs. „es gibt keine YAML":** beide Fassungen mit Datum: 19.07. CiYamlBuilder gebaut (`f564e4a3`, „[beide YAML-Lints valid]") → 11.08. KON16-03 „Es gibt keine YAML sondern der Planer emittiert direkt eine pipe oder Prozess …" (der Ledger fragt dort selbst: „Wenn es keine YAML gibt — was ist dieser Builder dann? Am Gegenstand zu klären, nicht am Namen") → 12.08. KON18-01 „alles in binary … Planer Bibliothek in C++23" (Session-Einordnung: „KEIN YAML-Generator", Nicht-C++-Träger nur CMake). Nach der Regel „Owner-Wort schlägt alles, Neueres schlägt Älteres" gilt KON18-01 — es ist ein starkes Richtungssignal Richtung CMake-Pfad, aber **kein Owner-Wort nennt CiYamlBuilder/TierCiYamlBuilder namentlich**; beide existieren unverändert und verdrahtet, parallel zu den zwei CMake-Emittern desselben Walks. Ob YAML-Ausgabe stillgelegt wird oder als Dual-Weg (§61-Spiegel) bleibt → Frage F4. Der Code hat auf KON17/KON18 noch nicht reagiert (ce-HEAD unverändert seit 11.08. 14:00 UTC). Nebenbefund: `IExperimentDock`/`ExperimentDockRegistry` aus dem 19.07.-Plan: 0 Code-Treffer (Gegenprobe IPruefDock: 105 Treffer in 30 Dateien[^hpd]) — weder gebaut noch explizit verworfen.

---

### I · Frage 9: drei Flächen statt zwei — **AUSSAGE KONSISTENT: Erweiterung, keine Korrektur**

**Fassungen mit Datum:** KON7-01 (11.08. **spätabends**): „ZWEI FLÄCHEN AN JEDER BINARY-AUSSENSEITE" — Fläche 1 = Vertrag/Funktion (abstract factory, Laufzeit), Fläche 2 = Identität (compile time factory). KON16-06 (11.08. **nachts**, später; Zeitstempel-Beleg: nacht-7-Doku 16:09 UTC vs. nacht-7c 23:12 UTC): „Es sind DREI" — Fläche 1/2 wortgleich unverändert, Fläche 3 = measurement-Durchstich kommt mit benanntem Zweck hinzu („damit wir die Gattung+Genus Funktionsinterfaces nicht ändern müssen" — eine Nicht-Änderungs-Zusage für jeden künftigen Bau). KON19-02 (12.08., während der Gegenprobe gelandet): der Owner benutzt „measurement Fläche 3" ein zweites Mal (Hybrid-Thread-Aggregation) — etablierter Begriff. **Nicht verwechseln:** KON8-10 „DIE DREI FLÄCHE-2-SCHICHTEN" zählt zeitliche Schichten **innerhalb** von Fläche 2; „F1-Durchstich" ist der Kampagnen-Termin 14.08., nicht der measurement-Durchstich.

**Code-Bestand:** Die Ziffern „Fläche 1/2/3" kommen im ce-Baum 0-mal vor (Gegenprobe „Genus" = 310 Dateien); die Konzepte existieren unter eigenen Namen — Fläche 1 als `class GenusInterface` / „GENUS_impl … ABSTRACT FACTORY" (`genus_kaskade.hpp:9,101`; `pilot_suche_impl.hpp:2,6,79`), Fläche 2 als Stempel-/Fingerprint-Familie (5 Versionsdateien + `anatomy_fingerprint.hpp`).

**Fläche 3:** Der Mechanismus-Kandidat existiert seit dem 09.08. — **zwei Tage vor der Benennung**: `anatomy/mess_visitor_abi.hpp` („DIE MESS-NAHT AM GENUS-INTERFACE, Owner-KERN 09.08.2026"), `IMessVisitor` (`:115`), `MessEdge<Sink>` (`:164`), Commit `d4c0b49c` (09.08. 19:14:36 UTC, „der Sidecar-Pull stirbt an der ABI"); `IObservableTier` hängt bewusst **nicht** an `IAnatomyBase` (kein vtable-Umbau, `observable_tier.hpp:36-38`) — exakt das Nicht-Änderungs-Prinzip; ABI-Major 8→9; Biss-Test 470 Zeilen registriert (`tests/unit/CMakeLists.txt:6585`). Die Gleichsetzung „IMessVisitor = Fläche 3" ist in **keiner** Quelle wörtlich — Inferenz aus Zweck-, Mechanik- und Zeitdeckung → Bestätigungsfrage F2. Bekannte Deckungslücke: der Zweig CEB=AUS/Tier=AN wird von keinem Testziel übersetzt.

**Compiler als Teil der Systemachse:** bestätigt, mit Präzisierung nach „Neueres schlägt Älteres": seit O-8 Schritt 4 ist der Compiler **keine System-Haupt-Achse** mehr, sondern die untrennbare Unter-Achsen-Gruppe compiler+opt_level+atomic128 (`toolchain_stamp_glied.hpp:198-208`, 05.08.; die drei Haupt-Achsen target_isa/operating_system/external_utils sind „ABSCHLIESSEND") — der ältere Kopf von `compiler_system_axis.hpp` („5. CEB-Konfig-System-Achse", 17.07.) ist nicht nachgezogene Doku. Im Fingerprint: Toolchain-Glied [5] von **9** Gliedern[^i9]. **Grenze vor/nach Compile:** vorher das typisierte `PermToolchainAchsen` (6 Felder, `toolchain_stamp_naht.hpp:201-208`) + `active_cxx_driver_tag()`; die Grenze selbst ist das Compile-Define `-DCOMDARE_TOOLCHAIN_STAMP_GLIED=…` (`:461-466`); nachher nur noch der eingebrannte Stempel-String plus die eigene CT-Erhebung der realen Compiler-Version (`__GNUC__`/`__clang_major__`). Die CEB lässt für sich selbst organ/system/toolchain bewusst leer („die CEB ist KEIN Tier-Binary … ein Zellwert hier wäre schlicht falsch", `ceb_version_stamp.hpp:590-594`) — deckt „der Genus-Wert in der CEB hat einen Compiler, nach dem Compile nur noch der Stempel".

---

## 4. WAS DARAUS ZU BAUEN IST

Reihenfolge nach Owner-Vorgabe (KON17-04: Stempel → Planungs-Simulation → XML→PDF-Kette) plus die vor dem Bau-Trigger Mi 26.08. kostenlosen Identitäts-Umbauten (danach entwertet dieselbe Änderung ~41,4 h Bau, Ledger:366).

| # | Gegenstand | Ort | Abhängigkeit | Existiert heute |
|---|---|---|---|---|
| 1 | **Ledger-/Doku-Korrekturen**: KON16-02-Einordnung „Messfühler-Vertrag in keiner Bau-Position" streichen; CEB 6→12 im Haupttext nachziehen; Kopf `compiler_system_axis.hpp` und `experiment_plan_director.hpp:1161` („eine Binary beide Rollen") aktualisieren; S-3-Label-Doppelbelegung vermerken | super `docs/…LEDGER.md`; ce Kommentare | keine | KON2-15 trägt die korrekte Fassung bereits |
| 2 | **Stempel-Aufgabe** (Owner-Nr. 1): Lücken Planer-SHA, Genus-Stempel handgeschrieben; Fläche-2-SOLL je Träger (KON7-04: sieben Funktionen) durchsetzen | ce 5 Stempel-Dateien + `anatomy_fingerprint.hpp` | F1 (cp/ce) wirkt auf Flags; F7 (Zielbegriff) auf Namen | Fingerprint 9 Glieder + 5 Dateien vorhanden; CEB-Leerfelder sind gewollt |
| 3 | **Planungs-Simulation**: im Bestand lokalisieren („schon geplant", KON17-01) — nach dem Gegenstand suchen, nicht nach Konsumenten —, dann bauen; berechnet Tier-Zahl je XML-Anforderung | ce `profile_facade/planner/` | nach #2 (Owner-Reihenfolge); Nenner aus F3 | `PlanSizeBuilder` (`:489`) als Zähl-Keim |
| 4 | **C-4-Wache modular + Detail-Klassen** (KON17-03; Priorität „hoch" vor F2 per KON16-08): Klassen-Schnitt (Marker-Regime vs. algo_version-Regime), Scope 130/152 ausrollen, Autodiscovery statt hartkodierter Liste, Mutationsbeweis T-i-2 | ce `tools/axis_version_lock/` + `.gitlab-ci.yml:768-787` | F6 (queuing im Scope?) | Werkzeug (210 Z.), Lock, CI-Job; Vorbild `test_a1` |
| 5 | **Stufe/Phase-Umbenennung**: nach F7 zuerst weiche Prosa/Kommentare + F-6 (`phase=` → `schritt=`), dann harte Stellen (XSD-Enum, `MergeStrategy`, Golden-XML, Symbole) — vor 26.08. | ce XSD/`pruefling_merge`/`validate_profile`/Golden; super CI-Kommentare | F7 | Trefferliste nach Härteklassen liegt mit diesem Lauf vor |
| 6 | **Bau-Modul-Ausbau**: (a) anforderungsgetriebene Übergabe Wünsche/Anforderungen/Freigaben je Stufe (KON17-01), (b) J-1…J-4 mitemittieren (KON17-02), (c) CEB-Sequenz Tier→Hybrid emittieren, (d) F4-Entscheid zu CiYaml umsetzen | ce `experiment_plan_director.hpp` + `build_orchestrator/` | F4; (c) blockiert auf K2/K5 (Owner-Liste; KON19-02 gibt K5-Richtung) | Director + 9 Builder + BuildOrchestrator; Hybrid-Anteil 0 |
| 7 | **S-13 Drei-Ziele-Ablage** („der Kern der Ablage", KON17-04): XML-Struktur für die drei Orte, Konsum des inerten storage-Slots, Filter am measure-drop (nur Zusammenfassung + Angefordertes statt jeder CSV) | ce XSD/`validate_profile` + `artifact_cache.hpp` + `iterator:3089` | F5 + F10 | Slots vorhanden (inert); Kanal produktiv, ungefiltert |
| 8 | **Fläche-3-Schließung**: nach F2 die NAHT-1-Lücken — Testziel CEB=AUS/Tier=AN; `genus_mess_naht` über das SearchAlgorithm-Dock hinaus (heute einziges) | ce `anatomy/`, `builder/pruef_dock/` | F2 | Mechanismus komplett, 1 Biss-Test |
| 9 | **Voraussetzungs-Wache S-3** (fordert/impliziert, Flag-Ordnung Teilmenge/dominiert) | ce `algo_semver.hpp` + neue Datei | O-4 (Owner-Liste: „ohne sie ist S-3 nicht schneidbar") | 0; Vorbild `bvset_teilmenge.hpp` |
| 10 | **Hybrid-Bau HY-A2/A3**: Reroute, Hybrid-Prüfdock, Tier-Modul, Build-Anschluss; danach Mess-Vertrags-Test mit echter Hybrid-.so | ce `libs/cache_engine/hybrid/` + CMake; `tests/unit/test_d2…` | K2/K5 (Owner) | 4 Header Klassifikation (943 Z.), 0 angeschlossen; Gate tier-belegt |
| 11 | **O-1-Restschluss Flag-Katalog**: nach F1 entweder nichts (Klammerform deckt alles) oder flacher Alias; optional wörtlicher static_assert `"1.0.0.cp"` gegen die Katalog-Wache | ce `algo_semver.hpp`/`flag_grammar_catalog.hpp` | F1 | Grammatik v2 vollständig |

---

## 5. WAS DIESER LAUF NICHT KLÄREN KONNTE

1. **„und so weiter" der Exportformate** — nicht gefunden (echte Nullen mit Gegenproben; auch KON17/18 nennen kein fünftes Format). Nächster Ort: die Thesis-/Overleaf-Messwerte-Sektion (die 07-11-Definition verweist dorthin; von keinem Schnitt durchsucht); sonst Owner-Schluss, dass die vier Formate abschließend sind.
2. **cp/ce-Lesart (O-1)** — beide Lesarten sind owner-zitierbar (Q3-Alt vs. v2-Kurzform), am Objekt nicht entscheidbar → F1.
3. **Hybrid-Nenner 12 vs. 24/48** — widersprüchlich: Memory „entschieden 12" (10.08.) gegen Ledger, der 24/48 zweimal offen führt (W-3 11.08.; KON18-02 12.08.) → F3.
4. **CEB-Zahl-Nachzug + PMC-Multiplikator** — die 12 ist nicht bestandsweit nachgezogen; der PMC-Faktor (AMD≠Intel, MIT/OHNE) ist unbeziffert → Ledger-Konsolidierung + Owner-Zahl.
5. **Tier-Zahl** — per Owner-Doktrin erst aus der Planungs-Simulation; deren Bestandsort („schon geplant") wurde nicht lokalisiert → gezielter Explore nach dem Gegenstand (Simulations-/Vorhersage-Algorithmus).
6. **measure-drop-Ziel (2) vs. (3)** — Laufzeit-Env außerhalb der Repos; Dokumentenlage (Verortungs-Brief 18.07.) deutet auf Ziel 3 und damit auf einen Konflikt mit KON13-04 → F5 plus Live-Blick auf die CI-Variablen.
7. **CiYamlBuilder-Schicksal** — kein Owner-Wort nennt ihn namentlich; KON18-01 ist nur Richtungssignal → F4. Dazu gehört das Schicksal von `IExperimentDock` (0 Code-Treffer, weder gebaut noch verworfen).
8. **IMessVisitor = Fläche 3** — durchgängig Inferenz, nirgends wörtlich → F2.
9. **Zielbegriff Stufe/Phase** — per KON18-02 ausdrücklich Owner-Wahl → F7. Die Prozentverteilung Ziel- vs. Fremdsinn der >20.000 Rohtreffer wurde bewusst nicht erhoben (nur die Sinnklassen sind vollständig); „Glied/Kettenglied" ist nicht mit derselben Tiefe auf Nebenbedeutungen geprüft.
10. **Detail-Klassen-Schnitt der C-4-Wache** — WAS entschieden (KON17-03), WIE nirgends spezifiziert → Design in Posten 4; Scope-Frage F6.
11. **Runner-Concurrency + prod2** — drei kursierende Werte (3/2, 4/4, OD-7 2/2×12 bzw. heavy 1×24), keiner live verifiziert; prod2-Pool-Frage seit 17.07. offen (KON3-02, BLOCKIEREND) → Live-Check am Host + F9. OD-7 (24 Worker gegen 16 Kerne) steht bereits auf der KON18-Owner-Liste.
12. **O-11-Ursprungsdimensionen und Lint/Release** — von KON17-02 nicht wörtlich gedeckt → F8.
13. **Marginalkosten je Bau-Instanz + Herleitung „41,4 h/128"** — keine Messung; die Quellen sind selbst uneins (Binaries vs. Mess-Scheiben) → nach dem ersten Planer-/Simulationslauf messen.
14. **KON19 nur teilausgewertet** — landete während der Gegenprobe (Commit `2c59a07b`); KON19-00 kündigt eine große Konsolidierung an → die nächste Session liest KON19 zuerst. Prozessnotiz: drei Platzhalter-Lieferungen („TEST") in A/C/E → Platzhalter-Gate in den Workflow.

---

## 6. NEUE FRAGEN AN DEN OWNER

Nur, was ein gefahrener Explore nicht auflösen konnte; jede Frage ist mit einem Satz beantwortbar.

1. **F1 — Flag-Syntax:** Meintest du mit „cp"/„ce" (11.08.) die gebauten Klammerformen `c{p}`/`c{e}`, oder soll zusätzlich eine flache Zwei-Zeichen-Schreibweise in den Katalog? *(Daran hängt: O-1-Schluss; ob am Katalog gebaut wird — heute würde `1.0.0.cp` als unbekanntes Token abgelehnt.)*
2. **F2 — Fläche 3:** Ist der Mess-Visitor am Genus-Interface (NAHT-1 vom 09.08., `IMessVisitor`/`tier_measure_accept`) genau dein measurement-Durchstich = Fläche 3? *(Daran hängt: ob Fläche 3 als gebaut gilt und nur Deckungslücken schließt — oder ein zweiter Mechanismus zu bauen ist.)*
3. **F3 — Hybrid-Nenner:** Gilt deine Korrektur vom 10.08. („es sind 12", 6 CEBs × mit/ohne Makro-Fühler) abschließend, oder bleibt die 4!-Rechnung (24 bzw. 48) eine eigene, zusätzliche Größe? *(Daran hängt: der Nenner jeder Kapazitäts- und Batch-Planung; der Ledger führt beides — steht als HYB bereits auf deiner KON18-Liste, hier mit der Widerspruchslage unterlegt.)*
4. **F4 — CiYamlBuilder:** Bleibt die GitLab-YAML-Emission (CiYamlBuilder/TierCiYamlBuilder) als Dual-Weg neben der CMake-Emission bestehen, oder wird sie stillgelegt? *(Daran hängt: Bau-Modul-Umbau Posten 6 und die CI-Topologie.)*
5. **F5 — measure-drop:** Bedient der HTTPS-PUT-Kanal Ziel 2 (Buildsystem-Cache, alle Messungen) oder Ziel 3 (cache-engine-experiment) — und darf er bis zum S-13-Bau weiterhin jede per-Binary-CSV senden? *(Daran hängt: der Filter am Sink und Posten 7.)*
6. **F6 — C-4-Scope:** Zählen die 22 algo_version-Träger unter `topics/queuing/` zum Scope der erweiterten Wache (152), oder nur `axes/` (130)? *(Daran hängt: Lock-Umfang und Autodiscovery-Zuschnitt in Posten 4.)*
7. **F7 — Zielbegriff:** Welcher Begriff gewinnt die Stufe/Phase-Umbenennung — „Phase", „Stufe" oder ein dritter (z. B. „Kettenglied")? *(Daran hängt: die gesamte Umbenennung Posten 5; die Wahl hast du dir in KON18-02 vorbehalten, die Härteklassen-Trefferliste liegt hiermit vor.)*
8. **F8 — Emissionsumfang:** Gehören Lint und Release zur Emissionsliste je Träger-Stufe, oder ist sie mit Bau + Test + Lager-Ablage (+J-1…J-4) vollständig? *(Daran hängt: der Zuschnitt von S-12/Posten 6.)*
9. **F9 — prod2:** Bleibt prod2 im Job-Pool für die Kampagne (offen seit 17.07.)? *(Daran hängt: ob die Kapazitätsrechnung mit einer oder zwei Lanes fährt — 20,7 h gegen 34,4 h Pfad.)*
10. **F10 — Einzelnachweise für Ziel 3:** Worüber benennt die XML die „explizit angeforderten Einzelnachweise" — genügen die bestehenden `<output>`/`<writeback_methods>`-Pfade, oder bekommt S-13 ein eigenes Element? *(Daran hängt: das XML-Design in Posten 7; Rahmen: KON16-05 schließt einen Anforderungs-Mechanismus je Artefakt aus.)*

---

[^drift]: Verschiebungen je Lesezeitpunkt +63/+177/+210 Zeilen (KON17/KON18/KON19 wurden oben eingefügt); Beispiele: KON16-06 zitiert bei 307-336, aktuell 517-545; KON16-09 bei 295-306, aktuell 358-369; KON13-04 bei 587-636, aktuell 764-813. Für künftige Zitate: Abschnitts-Kennung (KONxx-yy) statt nackter Zeilennummer.
[^a24]: Ein Schnitt meldete 23 Dateien (intern widersprüchlich 19); eigene Nachzählung der Gegenprobe: 24 (14 Produktiv-Header inkl. `algo_semver.hpp` selbst, 1 `tests/unit/CMakeLists.txt`, 9 Test-cpp). Ebenfalls korrigiert: die Auslöser-Zeile der Owner-Antwort ist `43439`, nicht `43438` (dort liegt ein file-history-Snapshot).
[^b6]: Ein Schnitt nannte 7 Testaufrufe; eigener grep: 6 (alle in `test_c3a_gate_scharfschaltung.cpp`). Die Kernaussage „0 Produktions-Aufrufer" steht wörtlich im Code-Kommentar.
[^cxlsx]: Alle drei substanziellen C-Schnitte trugen noch „0 Produktions-Targets" bzw. „golden wählt nur csv" — Stand Vormittag/Mittag 09.08., überholt durch `d2e20e7c` (09.08. 13:54 UTC) und `4a26b6a3` (10.08. 01:56 UTC).
[^ckon]: Ein Schnitt etikettierte die Drei-Orte-Stelle als „KON14"; korrekt ist KON13-04 (KON14-04 behandelt andere Zahlen).
[^dline]: Von einem Schnitt als Ledger:17049 zitiert; Inhalt wortgleich, korrekte Zeile 17226.
[^f19]: Ledger nennt 18, ein Schnitt maß 20; Doppelmessung der Gegenprobe: 19 (16 unter `axes/`, 2 unter `topics/queuing/`, plus die von der Ledger-Zählung übersehene `abi/anatomy_version_stamp.hpp`).
[^gpre]: Ein Schnitt wertete die Merge-Namen als „preimage-wirksam verifiziert"; `pruefling_merge.hpp:141-152` sagt das Gegenteil — seit A13-M3 keine eigene Stempel-Zeile mehr, Wirkung nur indirekt über die Namens-Eindeutigkeits-Wache. Hart belegt ist die Schema-/Golden-Byte-Wirkung.
[^hpd]: Ein Schnitt nannte für die IPruefDock-Gegenprobe 3 Treffer; real 105 in 30 Dateien — die Gegenprobe-Logik (Werkzeug findet Existierendes, der IExperimentDock-Nullfund ist echt) bleibt unberührt.
[^i9]: Die „8 Glieder" stammen aus der Commit-Message vom 05.08. (`8f9b73de`); das neunte Glied (MessGates, Index 8) kam danach hinzu — maßgeblich ist `kAnatomyFingerprintGliedCount=9` (`anatomy_fingerprint.hpp:416`).