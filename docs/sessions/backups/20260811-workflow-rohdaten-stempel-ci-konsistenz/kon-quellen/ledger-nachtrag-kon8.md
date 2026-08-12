## NACHTRAG 11.08.2026 NACHTS — KON8: DIE STEMPEL-ARCHITEKTUR, ZWEITE SCHÄRFUNG

**Fortsetzung von KON7 (unmittelbar darunter).** Der Owner hat im selben Dialog weitere sechs Mal
präzisiert oder korrigiert; drei davon **widerlegen** Aussagen aus KON7 bzw. aus meiner Darstellung.
Sie stehen hier mit ihrer Widerlegung, KON7 bleibt unverändert stehen.

### KON8-01 — 🔴 EIN VERTRAG ENTSTEHT NUR BEI DREIPHASIGKEIT

**Owner verbatim:** *„Der Vertrag gilt ja nur für die Mess-Achse zwischen CEB und Tier-binary bzw
Hybrid, weil sie DREIPHASIG ist und der Planer sie freigibt, sie also über 2 Träger-Stufen wirken
kann und damit über den Vertrag. Wenn du genau hinschaust, dann gibt ja immer noch die CEB
System-Achse und Organ-Achse frei und diese wird in den Tier-Binaries umgesetzt, also existiert
kein synchron zu haltender Vertrag zwischen 2 Parteien mit denselben Achsen-anforderungen."*

    MESS (DREIPHASIG)
       Planer ──freigabe──▶ CEB ──── VERTRAG ────▶ Tier / Hybrid
                             └── BEIDE setzen DIESELBE Planer-Freigabe um
                                 → sie müssen synchron bleiben

    SYSTEM (ZWEIPHASIG)        CEB ──freigabe──▶ Tier
    ORGAN  (ZWEIPHASIG)        CEB ──freigabe──▶ Tier
                                 └── nur EINE Umsetzung, kein zweiter Partner
                                     → nichts zu synchronisieren, KEIN Vertrag

**DIE REGEL:** ein Vertrag ist nötig, wenn **zwei Träger dieselbe Freigabe umsetzen müssen**.
Bei Mess sind CEB *und* Tier an die Planer-Freigabe gebunden; weichen sie voneinander ab, bricht
die Kette. Bei System und Organ gibt die CEB frei und *ein* Träger setzt um — es gibt keine zweite
Partei mit denselben Anforderungen, also nichts abzugleichen.

**MEIN FEHLER, den das korrigiert:** ich hatte die Teilmengen-Prüfung als **Querschnittsregel über
alle drei Achsen-Arten** formuliert. Sie sitzt an **genau einer Naht** (Mess, CEB↔Tier/Hybrid).
Fehlerklasse: eine an einer Stelle belegte Regel auf alle Stellen verallgemeinert.

### KON8-02 — TIER UND HYBRID SIND GLEICHAUF, NICHT NACHEINANDER

**Owner verbatim:** *„Tier und Hybrid sind gleich auf, weil die CEB ja nur durch Hybrid die
erlaubten Eigenschaften der Tier-Binaries durchreicht, welche diese compile time limited in ihre
Prüfdocks laden darf."*

Die Kette ist damit **dreistufig mit Verzweigung am Ende**, nicht vierstufig linear:

    Planer ──▶ CEB ──┬──▶ Tier
                     └──▶ Hybrid     (gleiche Stufe, lädt CT-limitiert in seine Prüfdocks)

**Korrigiert meine Darstellung** „Planer → CEB → Tier → Hybrid" als lineare Vererbungskette.

### KON8-03 — DIE CEB HAT ZWEI SYSTEM-ANZEIGEN, NICHT EINE

**Owner verbatim:** *„Die CEB muss also in der System-Achse compile time anzeigen mit was sie
gebaut wurde und in einer zweiten System-Achsen-Anzeige im RAM generieren und erkennen zu ihrer
Laufzeit, was auf der Hardware prinzipiell möglich ist, um die Tier-Binaries nach Freigabe zu
bauen."*

    ANZEIGE ①  compile-time   „womit ICH gebaut wurde"
                              vereinfacht, hohe Kompatibilitäts-Ansprüche, KEIN AVX
                              → gehört in den Stempel (Identität)

    ANZEIGE ②  Laufzeit/RAM   „was die Hardware KANN"
                              GPU/FPGA/NPU und alles über die eigenen Bedürfnisse hinaus
                              → gehört NICHT in den Stempel (Freigabe)

**DAS ERKLÄRT DEN IST-BEFUND, der bisher als Lücke galt.** `ceb_version_stamp.hpp` trägt heute
`("", "", Mess-Zeile)` — leere System- und Organ-Anteile. Die Code-Begründung (W10-C3, `:539-551`)
lautet: *„Ein Zellwert hier wäre schlicht falsch — er würde behaupten, die CEB selbst sei für
avx512 gebaut worden."* **Diese Begründung trifft ②, nicht ①.** Und *„kein AVX in der CEB"* heißt
nicht, dass ① leer ist — sondern dass ① eine **bescheidene** Menge trägt.
⇒ Der Bauauftrag ist damit präziser als in KON7: **① füllen, ② NICHT in den Stempel legen.**

### KON8-04 — DIE SYSTEM-ACHSE GIBT IN DER CEB AUCH ORGAN FREI

**Owner verbatim:** *„Die System-Achse gibt daher in der CEB auch die Ausrichtung und
Erweiterbarkeit der Organ-Achse frei, die mit speziellen Algorithmen dann gebaut werden kann, aber
zu allen möglichen Permutationen, die die Hardware in verschiedenen Versionen der Erweiterungen,
teilweise oder voll ausschöpfen."*

**Meine Frage war, ob es eine Querkante System→Organn *neben* der Trägerkette gibt. Antwort: nein.**
Die System-Achse **sitzt in der CEB** und gibt von dort Organ frei. Die Trägerkette bleibt linear;
der Freigeber ist eine **Achse**, kein Träger.

### KON8-05 — DER STEMPEL IST DAS RESULTAT DER B+-BAUM-MATERIALISIERUNG

**Owner verbatim:** *„der Experiment-Planer-B+-Baum plant die Permutationen und damit ja auch den
Stempel der dabei je Achsen-Kategorie-Träger-Baum-Stufe entsteht, diese sind im Experiment Baum
genau in dieser Reihenfolge in lazy Materialisierung und 3 node-Achsen-Kategorie Typen im Baum zu
unterteilen (bereits geplant). Der Stempel ist das formale Resultat der Materialisierung, die der
Planer in der simulation/freigabe/umsetzung vollzieht."*

**DER STEMPEL WIRD NICHT ZUSÄTZLICH GESCHRIEBEN — ER FÄLLT AN.** Wer ihn separat erzeugt, baut eine
zweite Wahrheit neben der Materialisierung. Der B+-Baum trägt **drei Node-Achsen-Kategorie-Typen**,
materialisiert **lazy in genau dieser Reihenfolge**, und jede Träger-Baum-Stufe bringt ihren Stempel
als Nebenprodukt hervor.

### KON8-06 — DIE FREIGABE GEHÖRT NICHT IN DEN STEMPEL

**Owner verbatim:** *„die Anzeige wird lazy durch die Stufen des Experiment-B+-Baumes abgebildet,
der zwischen Planer und CEB synchronisiert wird. Durch den Zustand des Baumes lässt sich durch eine
Abfrage über alle Permutationen das zulässige Maximal-Stempel intern als freigabe ermitteln, um die
Tier-binaries zu bauen. […] nur die tatsächlich verwendete Konfiguration kommt in den Stempel, die
Freigabe ist Laufzeit."*

**Damit ist meine Provenienz-Frage mit NEIN beantwortet:** Anzeige ② braucht **keinen** Abdruck im
Tier-Stempel. Die Freigabe wird nicht aus dem Stempel rekonstruiert, sondern **aus dem Zustand des
B+-Baums abgefragt** — er ist die zwischen Planer und CEB synchronisierte Instanz und kann den
zulässigen Maximal-Stempel intern ermitteln.

**WARUM DAS SAUBERER IST:** ein Stempel, der auch die Freigabe trüge, führte zwei verschiedene Dinge
in einem Feld — *was ich bin* und *was ich hätte sein dürfen*.

⇒ **Fläche 2 bleibt schlank:** kein Freigabe-Feld, keine Provenienz der Erlaubnis.
⇒ **Die CEB-Anzeige ② ist KEIN Fläche-2-Interface** — sie gehört zum Planer/CEB-Synchronisationsweg.
   Sie fällt damit aus der Liste der sieben Interfaces (KON7-04) heraus.

### KON8-07 — DIE PRÜFRICHTUNG: ECHTE TEILMENGEN MIT UNTERGRENZE

**Owner verbatim:** *„Wir brauchen echte Teilmengen, sowie Begrenzungen von minimal zulässigen
Basis-Versionierungen, also minimal-Teilmengen gegen die gesamte Freigabe eines Vertrages."*

    MIN(Vertrag)  ⊆  implementiert(Träger)  ⊆  freigegeben(Vertragspartner)

Ein Vertrag spannt ein **Intervall** auf, keine bloße Obergrenze. Daraus **drei** Fehlerfälle:

| Verletzung | Bedeutung | Zeitpunkt |
|---|---|---|
| `implementiert ⊄ freigegeben` | mehr eingebaut als erlaubt — Vertragsbruch nach oben | Bau-Gate |
| `MIN ⊄ implementiert` | Untergrenze unterschritten — hätte nie gebaut werden dürfen | Bau-Gate |
| `freigegeben` **schrumpft** | alte Binaries fallen aus dem Intervall | Rebuild-Auslöser |

**Der dritte Fall ist die Additivitäts-Regel von der Rückseite:** wächst `freigegeben`, bleibt jede
alte Implementierung im Intervall — kein Neubau. Owner dazu: *„Die Teilmengenregel ist geplant über
die Erweiterungsmechanik mit hardware, die hinzugefügt werden kann, um mehr Permutationen ohne
Neuberechnungsoverhead hinzuzufügen. Das ist über 10 Wochen geplant gewesen."*

**BEIDE HÄLFTEN EXISTIEREN IM HAUS SCHON — GETRENNT:**
* Obergrenze: `bvset_ist_teilmenge` (`ce libs/cache_engine/builder/bvset_teilmenge.hpp:165`),
  `recorded ⊆ current`, ausdrücklich **nicht symmetrisch**.
* Untergrenze: die **F-10-Wache** — *„jede ce-eigene Version MUSS `c` tragen"*, bewiesen durch
  `kProbeVersionGpu = "1.0.0.g"` (`hardware_meta_meta_axis.hpp:166`), die beide Wachen negativ
  durchläuft (`:190-191`).
**Was fehlt, ist die Klammer:** beide prüfen heute gegen EINEN festen Bezug; MIN muss **je Vertrag**
definiert sein. Und da es nur EINEN Vertrag gibt (KON8-01), ist das genau eine Definition.

**DIE COMPOSITE-ZULASSUNGSMATRIX WIRD DAMIT DREIWERTIG:**

    PFLICHT    gehört zu MIN(Vertrag)     — fehlt es, bricht der Bau
    ERLAUBT    in freigegeben, nicht MIN  — der Träger wählt
    VERBOTEN   nicht in freigegeben       — bricht der Bau

### KON8-08 — BASIS-FLAGS HABEN ALLE ACHSEN-KATEGORIEN

**Owner verbatim:** *„die Basis-flags AUF WAS eine Software oder Algorithmus laufen soll, haben alle
Achsen-Kategorien. Zum Beispiel ist ein nvcc compiler cg weil er auf CPU und GPU läuft."*
Und zur Korrektur seiner eigenen früheren Annahme: *„Die Achsen-Algorithmen der Organ-Achse sind
doch entgegen meiner früheren Annahme durch die System-Achsen freigegeben, tragen also auch die
volle Grammatik, sofern ihre Algorithmen die benannten technologien in die Version eines bestimmten
Algorithmus einkompiliert haben."*

**MEINE KOMPLEXITÄTS-LEITER (KON7-06) WAR FALSCH FORMULIERT.** Ich hatte sie als **Eigenschaft der
Kategorie** verstanden. Richtig: **alle Kategorien nutzen dieselbe Grammatik**, und was verwendbar
ist, begrenzt die **Freigabe-Kette**. Die System-Achsen sind nicht „komplexer" — sie sind die
**Quelle**, weil sie freigeben; deshalb tragen sie die vollständige Hardware-Beschreibung.
Ein Organ-Algorithmus trägt dieselbe Grammatik, aber nur für Technologien, die er einkompiliert hat.

**Der Code bestätigt das unabhängig:** `algo_semver.hpp:971-974` zählt die **Organ-Registry**
(`axis_variant_version_table.hpp`) *und* **Mess-Tooling/Mess-Framework** unter denselben Aufrufern
derselben Wache `ce_owned_version_is_wellformed()`. **Eine Grammatik, drei Kategorien.**

### KON8-09 — DER FLAG-KATALOG: ES GIBT KEINEN FÜNFTEN BUCHSTABEN

Zehn-Wochen-Explore `wf_283f202c-0ba`, vier Korpora, **173 Flag-Fundstellen**.

**GEFUNDEN — eine Datei, die bis heute in keinem Ledger-Eintrag vorkam:**
`ce libs/cache_engine/include/cache_engine/measurement/flag_grammar_catalog.hpp` (**755 Zeilen**):

    {"c", "", "", FlagTokenKind::HardwareBasis, ""},
    {"g", ...},  // GPU  -- reserviert, nicht produziert
    {"f", ...},  // FPGA -- reserviert, nicht produziert
    {"n", ...},  // NPU  -- reserviert, nicht produziert
    {"p", "", "", FlagTokenKind::HardwareUnterklasse, "c"},  // performance core
    {"e", "", "", FlagTokenKind::HardwareUnterklasse, "c"},  // efficiency core

Der Kommentar (`:178-181`) sagt genau das, was der Owner heute formuliert hat:
*„Das sind KEINE SIMD-Flags: sie sagen, FÜR WELCHE Hardware gebaut wurde."*

**GESUCHT UND NICHT GEFUNDEN**, je mit Gegenprobe über **1848 bereinigte Owner-Zeilen**:
**TPU** 0 · **ASIC** 0 · **DSP** nur als Adjektiv („DSP-/Ganzzahl-Befehle" für 3dnowext, und das ist
eine AGENT_BEHAUPTUNG aus einem Workflow-Resultat, kein Owner-Wort) · **„Beschleuniger"** ist der
Owner-**Sammelbegriff** für die g/f/n-Klasse, kein Token · **NUMA** einmal als Geschwister-Freigabe
genannt (46375cdc:59910, 19.07.), aber kategorial anders (Speicher-Topologie, kein Ziel-Hardware-
Buchstabe).

**DAS nvcc-BEISPIEL IST DER SCHLÜSSEL:** `cg` sind **ZWEI Basis-Flags gleichzeitig**, kein fünfter
Buchstabe. Formal nach der Punkt-Regel `c.g`; der Owner schreibt es informell zusammen.
⇒ **Kombinationen von c/g/f/n sind gewollt, keine exklusive Wahl.** Die „vielen weiteren" sind die
Sub-Token unter den Basen und deren Kombinationen.

**🔴 EINE NAMENSKOLLISION, die der Bau kennen muss:** `f` bedeutet auf **Tiefe 0 FPGA**, unter
`x512` aber **AVX-512 Foundation** (`algo_semver.hpp:914` sagt es wörtlich). Heute sicher
unterschieden durch **Eltern-Tracking** der Katalog-Wache — *„wird zum Risiko, sobald f als
FPGA-Basis einen eigenen Sub-Katalog bekommt"*. Also genau dann, wenn die Erweiterung kommt.

**DER IST-STAND IST ERNÜCHTERND EINFACH:** alle **137** ce-eigenen Literale
(**123 Organ + 7 System + 6 Mess + 1 Planer**) tragen genau `c` — und sonst nichts.
Die Grammatik-Kapazität liegt weit vor ihrer Nutzung.

### KON8-10 — DIE DREI FLÄCHE-2-SCHICHTEN NACH ENTSTEHUNGSZEIT

| Schicht | entsteht | Inhalt | baubar |
|---|---|---|---|
| **compile-time, feststehend** | Übersetzung | die vier Zeilen, X.Y.Z, SHA | **sofort** |
| **Laufzeit, Umgebung** | Programmstart | (CEB ② — gehört zum Baum, nicht zur Fläche) | — |
| **Laufzeit, Registrierung** | nach Andocken | Hybrid-Bereichskarte | erst nach HY-B/C |

Der Hybrid-Stempel hat damit einen **frühen** Teil (eigene vier Zeilen, compile-time) und einen
**späten** (die Break-Even-Bereichskarte). Vorher ist die Karte leer oder einbereichig — das ist
kein Mangel, sondern ihre Natur.

### KON8-11 — WAS AUS DEM TAG SONST NOCH ZU SICHERN IST

**DIE RESTLANDUNG IST VOLLSTÄNDIG: 4 von 4.**

| Paket | SHA | Gegenstand |
|---|---|---|
| R3 | `super 75505b9d` | D3-7b super-Hälfte |
| R5 | `ce 670483c0` | r7-Wachen-Divergenz (Task #79) |
| R4 | `super cf39dc19` | Wachen-Parität (Task #77) |
| R2 | `super 9f8e2be8` | CI-Invarianten-Wache |
| R1 | — | E18SNAP, neu geschnitten |

**Die R5-Landung ist außergewöhnlich belegt und sollte als Muster dienen:**
* **MERGE-VORHERSAGE EINGELÖST:** `merge-tree --write-tree` hatte Ergebnisbaum `e29cbef7`
  vorhergesagt; der HEAD-Baum des entstandenen Merges **IST** `e29cbef7`. Unabhängiger Riegel gegen
  stille Fehlauflösung.
* **DREI Riegel gegen Doppelzählung** (weil die Fallzahl nach der R3-Lehre nicht reicht):
  (a) genau 1 geänderte Datei, +173/-16; (b) zeichengleich mit dem Delta des Commits gegen die
  Merge-Basis; (c) `rev-list --count e114cabd..origin/development -- <datei>` = **0** — die
  Gegenseite hat die Datei seit der Abzweigung NIE angefasst. Doppelaufnahme war damit
  **strukturell unmöglich**, nicht nur unbeobachtet.
* **GOOGLE TEST STATT SHELL-PROBE:** `test_hyg_kumulativer_bereich`, **9/9 in Debug UND Release** —
  die Regression aus #89 im Kleinen bereits korrigiert.
* **GITLEAKS-FALLE am Objekt vorgeführt:** mit `-m` „2 commits scanned" (= 2 im Bereich), ohne `-m`
  „1 commits scanned" und **trotzdem grün** — der Merge-Commit fällt heraus.

**DER STEMPEL-DESIGNPLAN (15 Pakete) HAT ZWEIMAL NACHBESSERN.** Beide Lenses unabhängig:
*„trägt in seiner ARCHITEKTUR und fällt in seiner BELEGLAGE"* / *„als DESIGN gut, als PLAN
unverankert"*. Kernbefunde: die Verifikationsbasis `wt-ce-d37b @ 346b6da9` ist **0 voraus / 14
zurück**; ein Kalenderfehler (*„Fr 15.08."* ist ein **Samstag**); W1-Kapazität um 58 h überzogen in
einer Woche, die schon 99 h Band A trägt; ST-08 bumpt auf Layout 7, das `decl.hpp:293` als
**verboten** festschreibt.

**🔴 EINE LEHRE ÜBER DIE LENSES SELBST:** Lens 1 meldete *„`bvset_ist_teilmenge` existiert nicht,
0 Treffer baumweit"*. Ich habe das ungeprüft in Task #82 als Korrektur übernommen — **und es war
falsch**. Am heutigen Stand existiert die Funktion (`bvset_teilmenge.hpp:165`, aufgerufen in
`build_orchestrator.hpp:444`); der Lens hatte auf der **14 Commits alten Basis** gemessen.
⇒ **ALLE „existiert nicht"-Aussagen dieses Lens sind systematisch verdächtig** und einzeln gegen
`origin/development` nachzumessen, bevor eine davon in einen Bauauftrag wandert.
⇒ Und bei mir: **Prüfung 5 verletzt** (*„prüfe ich die neue Aussage genauso hart wie die alte?"*).
Das Projekt hat 13 von 40 Fällen dieser Klasse belegt — das ist der 14.

**VIER ENTLASTUNGEN, die den Bau billiger machen als angenommen:**
1. **golden-320 ist STEMPEL-NEUTRAL** — 0 `@`-Zeichen in 8/8 Golden-/Registry-/Profil-Dateien;
   der Code sagt es selbst: *„der Stempel != binary_id"* (`adhoc_emitter.hpp:104`).
2. **KEINE laufende Mehrtageskampagne** — seit 25.06. (`884f8f41`) 15-min-PMC-Smoke statt
   Tagesmessung.
3. **Es wurde NIE eine Flotte gebaut** (Owner) — jede „das invalidiert die Flotte"-Rechnung ist
   gegenstandslos.
4. **`test:coverage-guard` ist aus einem nachweislich STEMPELFREIEN ISA/Host-Grund rot** — die
   Aussage *„alle Blocker klemmen am Stempel"* trägt als **Policy** voll, als **technische** Aussage
   nicht.

**ZAHLEN, DIE NICHT STIMMEN und nicht weitergereicht werden dürfen:**
* Die **153** (algo_version-Konstanten) trifft **keine** Messung — fünf unabhängige Zählungen
  ergeben 104/115/124/131 je Muster und Scope; die Owner-Zahl „138 Stellen" (07.08.) ebenfalls
  keine. Größenordnung gesichert, exakter Nenner nicht.
* Der Wellenplan (##58) nennt **28** `\InputIfFileExists`-Ziele; gemessen im echten Klon sind es
  **13**. Vor dem F5-Anhang-Gate zu klären.
