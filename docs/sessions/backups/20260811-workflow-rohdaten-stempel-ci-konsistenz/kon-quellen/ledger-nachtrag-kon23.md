## NACHTRAG 12.08.2026 — KON23: WF1 IST GELANDET — DIE NEUN STRÄNGE, ZEHN NEUE OWNER-FRAGEN, EIN MEMORY-WIDERSPRUCH

**Der neun-strängige Explore auf die Owner-Antworten (KON16/KON17) ist durch: 45 von 46 Agenten,
jede Kernaussage in der Gegenprobe am Objekt nachgelesen.** Volltexte:
`docs/sessions/20260812-WF1-SYNTHESE-die-neun-owner-straenge.md` (Kopf technisch verloren) und
**`20260812-WF1-BERGUNG-verify-ABCD.md`** (die vollständigen geprüften Antworten A–D, aus dem
Journal geborgen). *Prozessnotiz: 1 Schnitt-Agent starb am StructuredOutput-Limit; drei
Platzhalter-Lieferungen („TEST") in A/C/E wurden von den Gegenproben als Ausfall erkannt —
ein Platzhalter-Gate gehört in künftige Workflows.*

---

### KON23-01 — STRANG A: DIE „VOLLE SYNTAX" IST DIE FLAG-GRAMMATIK v2 — `cp`/`ce` SIND KEINE KATALOG-TOKEN

Die Grammatik ist **festgelegt und gebaut** (07.08., `algo_semver.hpp` R1–R8 + `flag_grammar_catalog.hpp`,
62 zugelassene + 14 ausgeschlossene Kürzel, ~24 Aufrufstellen):

    version := UINT.UINT.UINT ['.'<flag>]*
    basis   := 'c' | 'g' | 'f' | 'n' | 'x128' | 'x256' | 'x512'
    'p'/'e' (performance/efficiency core) sind SUB-Flags NUR unter 'c':
    c{p}, c{e}, c{p.e} -- '{p}' ist Default

**Flache `cp`/`ce` existieren im Katalog NICHT** — `1.0.0.cp` würde als EIN unbekanntes Token
abgelehnt (static_assert `:1089`). Ein historisches `ce` (Alt-Grammatik 02.–06.08.) bedeutete
„experimentell", **nicht** efficiency-core, und parst heute auf den Sentinel `0.0.0`.
**Wahrscheinlichste Lesart:** die Owner-Beispiele sind gesprochene Kurzform der gebauten
Klammerformen `c{p}`/`c{e}` — der vorausgehende Kontext (die O-1-Rückfrage) stützt das.
**→ Owner-Frage F1.** *Zusatzbefund: die `c{p.e}`-Grammatik ist kein wiedergefundener Alt-Plan —
„cpe" wurde am 07.08. vormittags per Gegenprobe als nicht-existent widerlegt und am selben Tag
NEU entwickelt.*

---

### KON23-02 — STRANG B: BEIDE SEITEN SIND GEBAUT — UND BEIDE SIND HEUTE INERT/LEER

    FREIGEBENDE SEITE   (a) ZIELBILD: set_active_machine_declaration()/active_machine_
                            signature() (simd_build_gate.hpp:234-247) -- EINMAL-Belegung,
                            0 PRODUKTIONS-AUFRUFER (der Code sagt es selbst)
                        (b) HEUTE AKTIV: system_axis_host_supports_simd() liest per
                            __builtin_cpu_supports() die ECHTE Host-CPUID als Fallback
    COMPILE-TIME SEITE  simd_organ_requirement.hpp: 9 Organ-Klassen, required-Menge
                        AUSNAHMSLOS LEER; static_assert(!any_organ_declares_required()) :88
                        pruef_dock() wirft HardwareErweiterungFehlt -- GLOBAL INERT
    KATALOG             23 SIMD-Feature-Flags (static_assert :155)

**Die Owner-Regel (Freigabe impliziert · Compile-Seite fordert) hat also beidseitig fertige
Mechanik und null aktive Belegung** — S-3/S-7 sind Aktivierungs-, keine Neubau-Aufträge.
Der Messfühler-Vertrag (dritter Gegenstand aus KON16-02): Naht existiert am SearchAlgorithm-Dock
(genau **ein** Biss-Test); Deckungslücken in Posten 8 der Bauliste.

---

### KON23-03 — STRANG C: DIE EXPORT-ZIELE SIND VIER — UND xlsx IST SEIT 09.08. SCHARF

**Vier compile-time-gesicherte Rückschrieb-Methoden:** `Csv` · `LatexTable` · `ComparisonMetrics` ·
`Xlsx` (`writeback_method_registry.hpp`, `kWritebackMethodCount=4`). **PDF liegt ausdrücklich
außerhalb** der Rückschrieb-Achse (entsteht Thesis-seitig über latexmk). **json/html/svg/png:
belegte Nullen** — das „und so weiter" ist als Formatliste unbeantwortet (**einziger ungeprüfter
Ort: die Thesis-/Overleaf-Messwerte-Sektion**).

**Korrektur an drei Schnitten durch die Gegenprobe:** „xlsx hat 0 Produktions-Targets" war Stand
09.08. vormittags — **noch am selben Tag** (`d2e20e7c`, 13:54) bekam der A9-S3-Writer seinen
ersten Produktions-Aufrufer (die Fassade, die der **Planer selbst** linkt), und seit `4a26b6a3`
(10.08.) wählt das golden-Profil **csv UND xlsx zugleich** (mit eingebettetem Owner-Zitat
„xlsx ist Standard, CSV wählbar, beide zugleich"). **Der xlsx-Export ist scharf.**

**Ungeklärter Konflikt → F5:** ob der measure-drop-HTTPS-Kanal Ziel (2) Buildsystem-Cache oder
Ziel (3) cache-engine-experiment bedient — der Verortungs-Brief vom 18.07. jailt die NFS-Route
auf `cache-engine-experiment/`, was mit KON13-04 („nicht alle Messwerte an Ziel 3") kollidieren
würde; bis S-13 sendet der Kanal **ungefiltert jede per-Binary-CSV**.

---

### KON23-04 — 🔴 STRANG D: FRAGE 6 WAR BEIM RÜCKLAUF SCHON BEANTWORTET — UND EIN MEMORY WIDERSPRICHT DEM LEDGER

Die vier Schnitte liefen auf Stand KON16 („mehr Kontext") — die Gegenprobe fing die Überholung:
**KON17-01 (anforderungsgetrieben) ist die Antwort**, die Schnitte lieferten den Kontext dazu.

**🔴 Der ungelöste Widerspruch im Bestand, an den Owner zurückgegeben (→ F3):**

    MEMORY  project_vier_messebenen_hybrid_... (10.08. 07:29):
            "ENTSCHIEDEN -- ES SIND ZWOELF ... Weder 24 noch 48 ... gegenstandslos"
    LEDGER  W-3 (11.08.): "AUFGELOEST -- Seite B ist neuer ... Reihe 5 -> 6 -> 12.
            Die Frage 24 oder 48 bleibt davon UNBERUEHRT und weiterhin NICHT entschieden"
    LEDGER  KON18-02 (12.08.): fuehrt "HYB 24 oder 48" weiter als OFFEN
    KON19-08 (12.08.): Zahlen liefert kuenftig die PLANUNGS-SIMULATION; Arbeitsannahme
            erstmal NUR einfache CPU-Versionen mit SIMD-Permutationen

**Und die CEB-Zahl ist 12, nicht 3!=6** (Owner-Selbstkorrektur 10.08. 07:27, W-3 „Seite B ist
neuer") — **mein `MEMORY.md` führt an zwei Stellen noch „3!=6 CEBs" und ist nachzuziehen.**
*(Kleinkorrekturen der Gegenprobe: B-4-Beleg liegt bei Ledger:17226, nicht :17049; die
Vier-Kandidaten-Bau-Menge 131072/524288/1572864/2097152 ist bestätigt.)*

---

### KON23-05 — STRÄNGE E/F: VOM OWNER ENTSCHIEDEN — DIE ZAHLEN FÜR DEN BAU LIEGEN VOR

**E (Emission):** Träger×Rolle-Tabelle steht (Planer direkt kompiliert, genus-los, nur
Cache-Wurzel · CEB einzige Bauende, „kein AVX in der CEB", Wurzel+Lager · Tier misst/wird
gemessen · Hybrid kann nicht bauen). **IST: 0 von 4 Trägern haben einen eigenen Bau-/Test-Job**
(super 2768 Z./45 Jobs · ce 1056/25, „hybrid" 0 Treffer beidseitig). Lint/Release von der
Owner-Antwort nicht gedeckt → **F8**.

**F (C-4-Wache):** Klassen-Schnitt-Zahlen verifiziert — Wache deckt **6 Dateien (alle
heuristik/)**, Grundgesamtheit **≥152** (130 axes + 22 queuing), Schnittmenge Wache∩axes = **0**,
Drift-Erkennung für axes = **0**, Mutationsbeweis fehlt (T-i-2 geplant). Zwei Vokabulare
(Kommentar-Marker heuristik vs. `algo_version`-Member axes). **Die hartkodierte 6-Pfad-Liste war
Mitursache des Drei-Wochen-Ausfalls** — Autodiscovery über die Registry-Typlisten ist die im
Bestand vorgezeichnete Alternative (`test_a1` macht es für 1 von 18 Achsen vor). Scope-Frage → **F6**.

---

### KON23-06 — STRÄNGE G/H/I: DIE DREI ARCHITEKTUR-AUSSAGEN AM OBJEKT

**G (Stufe=Phase):** Kollision real, Härteklassen kartiert. **Härteste Stelle:**
`experiment_schema.xsd:41,245-255` — ein XML-Element `phase`, dessen Enum-Werte
`Stufe1_CeOnly`/`Stufe2_PrueflingReplace`/`Stufe3_FullJoin` heißen (Phase und Stufe buchstäblich
gleichgesetzt), gespiegelt als C++-`MergeStrategy` und live in Golden-Fixtures ⇒ Umbenennung ist
**schema-wirksam** (Golden-Byte-Bruch), nicht preimage-wirksam. CI: 40 native `stage:` neben 31
deutschen „Stufe N"-Kommentaren. Das 06.08.-Klärungsdokument (STUFE=Gliederzahl, PHASE=Position)
ist durch das Owner-Wort **überstimmt**; seine Kollisionskarte (Z-1…Z-14) bleibt Bestandsaufnahme.
Zielbegriff → **F7**.

**H (Bau-Modul):** teils gebaut — Director + **9** Builder + BuildOrchestrator existieren;
Hybrid-Anteil **0**. Ein benannter Widerspruch: der **CiYamlBuilder** (samt TierCiYamlBuilder)
emittiert GitLab-YAML — kein Owner-Wort nennt ihn; KON18-01 (nur C++/CMake, alles in Binary)
ist Richtungssignal gegen ihn → **F4**. `IExperimentDock`: **0 Code-Treffer** (weder gebaut noch
verworfen).

**I (drei Flächen):** Aussage **konsistent als Erweiterung** — und der wahrscheinlichste
Fläche-3-Kandidat ist die **NAHT-1 vom 09.08.** (`IMessVisitor`/`tier_measure_accept` am
Genus-Interface): Mechanismus komplett, genau **ein** Biss-Test, Inferenz nirgends wörtlich
→ **F2**.

---

### KON23-07 — DIE BAULISTE (11 POSTEN) UND DIE ZEHN NEUEN OWNER-FRAGEN

Die priorisierte Bauliste (Ledger-Korrekturen · Stempel · Planungs-Simulation · C-4-Wache ·
Umbenennung · Bau-Modul · S-13 · Fläche-3-Schließung · S-3-Wache · Hybrid HY-A2/A3 ·
O-1-Restschluss) steht in der WF1-Synthese §4 mit Ort/Abhängigkeit/Bestand je Posten.

**Die zehn Fragen F1–F10** (jede mit einem Satz beantwortbar, jede mit Konsequenz-Vermerk):
F1 `cp`/`ce` = Klammerformen? · F2 IMessVisitor = Fläche 3? · F3 Hybrid-Nenner 12 vs. 24/48 ·
F4 CiYamlBuilder stilllegen? · F5 measure-drop: Ziel 2 oder 3? · F6 queuing im C-4-Scope? ·
F7 Zielbegriff der Umbenennung · F8 Lint/Release in der Emissionsliste? · F9 prod2 im Job-Pool
(offen seit 17.07., Kapazität 20,7 h vs. 34,4 h) · F10 XML-Element für Ziel-3-Einzelnachweise?
**Volltext: WF1-Synthese §6.**
