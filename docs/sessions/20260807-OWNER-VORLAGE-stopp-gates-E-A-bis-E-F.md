# OWNER-VORLAGE — die sechs STOPP-Gate-Entscheide E-A bis E-F

> **HISTORISCH (Vermerk 17.08.2026, VL-5c/KON100):** Dieses Frage-Dokument ist BEANTWORTET —
> alle sechs Buchstaben wurden am 07.08. abend-23 entschieden (Ledger :27970-27979; E-A =
> SHA-256/64 Hex, E-B = Variante (i) mit Owner-SETZUNG "Wir brechen golden-CRC!" — der Owner
> ueberstimmte die Empfehlung b/ii/a/a/a/a in ZWEI Buchstaben). E-E/E-F sind am Objekt
> vollzogen; die Ausfuehrung von E-A/E-B/E-C/E-D lebt im #15-Buendel (BUENDEL-BAUPLAN-15.md).
> Nicht mehr als offene Vorlage verwenden.

**Stand 07.08.2026 nachmittags.** Gegenstand: `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md`
Sec. 5.2 (Zeilen 648–653). Diese sechs Entscheide blockieren den Owner-KERN **F7 = Option b**
(gesondertes Versionierungs-Interface + CT-Namensfunktion, Owner-Verbatim `LEDGER:6629`).

Sie sind durch drei Konsolidierungen gefallen; der Ledger führt das seit heute selbst als
BEFUND 2 (`LEDGER:8132`), der Erst-Anker als **G-1**
(`docs/sessions/20260807-STAND-wellenplan-abgeschlossen-und-offene-entscheide.md:76`).

---

## KURZFASSUNG — sechs Zeilen, allein damit entscheidbar

| Id | Frage in acht Worten | Empfehlung |
|---|---|---|
| **E-E** | Overlay-Glied jetzt scharfschalten? | **(a) ja — aber erst nach drei Unterfragen** *(neu; war (b))* |
| **E-A** | Wie viele Hex-Zeichen trägt der Stempel-Name? | **(b) 24 = 96 bit** *(unverändert)* |
| **E-F** | Planer-Stufe: leere Glieder oder eigenes Set? | **(a) honest-empty** *(unverändert, aber mit Direktiven-Konflikt)* |
| **E-D** | Ordnernamen/CSV-Spalten auf den Stempel-Namen? | **(a) ja, mit Doppel-Spalte im Übergang** *(unverändert)* |
| **E-C** | Drei Provenienz-Sidecars auf den POD ziehen? | **(a) ja, im selben Fenster** *(neu; war (b))* |
| **E-B** | Soll der Name auch im Symbol stehen? | **(ii) nur `.rodata`** *(unverändert)* |

**Die Alt-Empfehlung war `b / ii / b / a / b / a`. Neu: `b / ii / a / a / a / a`** — zwei Buchstaben
ändern sich (E-C und E-E), beide **weil eine Kostenannahme des Plans am Code widerlegt ist**.
Begründungen unten.

> **Vor allem anderen — die Grundlage des Plans ist überholt.** Der Plan rechnet durchgehend mit
> **„Format 3, 8 Glieder"** und dem Frozen-Vektor `17148e5a…`. Der Code auf `development` trägt
> **Format 4, 9 Glieder** (`anatomy_fingerprint.hpp:106`, `:387`); `17148e5a` steht nur noch als
> Vorgänger-Kommentar (`tests/unit/test_g3_sha512_index.cpp:73`,
> `test_w10_system_cell_values.cpp:463`, `test_m_w12_stamp_bausteine.cpp:730`). Das ist R-3, heute
> gelandet. **Das entwertet keinen der sechs Entscheide — aber es verbilligt E-E erheblich und
> macht den POD-Entwurf des Plans (Sec. 3.1) an drei Stellen nachzugsbedürftig.** Details bei E-E.

---

## DAS FENSTER — für welche der sechs es zählt

**Fenster 0** = die Zeit vor der ersten geschriebenen `.fingerprint`-Datei. Solange es offen ist,
kostet jede Preimage-Änderung **null**; danach einen vollständigen Neubau.

**Ist-Stand, von mir gemessen (07.08. nachmittags):**
`find <baum> -name "*.fingerprint" -not -path "./.git/*" | wc -l` = **0** in `wt-super-landung`
und **0** in `wt-landung`. **Fenster 0 ist offen.**
Kosten nach dem Schließen: **~34,4 h Voll-Neubau plus Entwertung aller bis dahin erhobenen
Messdaten** (`docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:844-845`,
Zeile FINGERPRINT: *„heute 0 h (Bestand 0) · nach dem 1. Batch: 34,4 h + Entwertung aller Messdaten"*).

| Entscheid | Fällt in Fenster 0? | Begründung |
|---|---|---|
| **E-E** | **JA, als einziger** | füllt Preimage-Glied [7] → jeder Fingerprint verschiebt sich |
| E-A | nein | der Name ist Funktion des Fingerprints und geht nie ins Preimage (Plan 2.1, S2 Zeile 577) |
| E-F | nein | POD-Layout, preimage-neutral (Plan S1, Zeile 572) |
| E-D | nein — **aber eigenes Fenster** | schließt mit dem ersten produktiven Messlauf, nicht mit dem ersten Bau |
| E-C | nein | Sidecars stehen außerhalb des Preimage; **und außerhalb des Skips**, s. u. |
| E-B | nein | (ii) ist `.rodata`; nur (i) berührte den golden-CRC |

**Daher die Sortierung dieser Vorlage: E-E zuerst.** Danach die beiden, die den ersten Bau-Schritt
blockieren (E-A, E-F), dann E-D (eigenes Fenster), dann die beiden entlasteten (E-C, E-B).

---

# 1. E-E — Overlay-Glied jetzt scharfschalten? 🔴 FENSTER 0

### Die Frage, verbatim (`…-PLAN-versionierungs-interface-stempel.md:652`)

> **E-E** | Overlay-Glied jetzt scharfschalten? | (a) ja; (b) nein, späteres eigenes Fenster |
> **(b)** — er ist von der Direktive nicht gefordert und kostet den Anker

### Was davon abhängt

Schritt **S8** des Migrations-DAG (Plan `:614-618`). Betroffen wären:
- `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:128` — heute
  `kOverlaySourceHash = COMDARE_OVERLAY_SOURCE_HASH`, per `#ifndef` auf `""` gesetzt (`:125-127`)
- ein neuer Pre-Build-Codegen, der das Define füllt (existiert nicht)
- die drei Frozen-Vektor-Stellen: `tests/unit/test_m_w12_stamp_bausteine.cpp`,
  `tests/unit/test_g3_sha512_index.cpp`, `tests/unit/test_w10_system_cell_values.cpp`
- mittelbar: jede gebaute Tier-Binary (Flotten-Invalidierung)

### Der Ist-Zustand am Code

Das Glied **existiert, ist verdrahtet und ist leer** — und zwar ehrlich leer.
`anatomy_fingerprint.hpp:117-119`: *„HEUTE LEER, UND ZWAR EHRLICH: der Codegen existiert noch nicht
(0 Treffer für eine Overlay-Hash-Quelle im Baum). Ein leeres Glied trägt (außer seinem Separator)
nichts zum Preimage bei; die Naht ist trotzdem gebaut und an EINER Stelle."*
Position bestätigt: `kAnatomyFingerprintOverlayGlied = 7` (`:407`), das Makro reicht es explizit
durch (`anatomy_module_abi_v1.hpp:175`).

**Zwei Dinge, die der Plan nicht wusste:**

**(1) Der Anker dieses Fensters ist bereits ausgegeben.** Die Empfehlung (b) begründet sich mit
*„kostet den Anker"* und mit der STOPP-Klausel *„Ein Fenster, ein Anker"* (Plan `:708-709`). Genau
dieser Anker ist im laufenden Fenster **schon gedreht worden**: R-3 hat Format 3 → 4 gehoben und
alle drei Frozen-Vektoren neu geankert (`anatomy_fingerprint.hpp:90`, `:106`; die Test-Kommentare
führen den alten Wert als Vorgänger). Ein zweiter Dreh im selben, noch offenen Fenster kostet
**dieselben null Stunden** wie der erste — der Header sagt es für R-3 wörtlich
(`anatomy_fingerprint.hpp:100-105`): *„Sie ist im Fenster dieses Commits KOSTENLOS: der
.fingerprint-Sidecar-Bestand ist literal 0 … Nach dem ersten golden-Batch kostete dieselbe Änderung
einen Voll-Neubau der Flotte plus Messdaten-Entwertung — der Fix gehört deshalb VOR das nächste
GOLDEN-UPDATE-Fenster und nicht dahinter."*

**(2) Die Frage ist größer als (a)/(b).** Der Code benennt **drei Unterfragen**, die der Plan nicht
nennt und die er ausdrücklich dem Owner zuweist (`anatomy_fingerprint.hpp:120-123`):

> *„OFFEN und bewusst NICHT geraten: WELCHE Dateimenge ‚das Overlay' ist (Verzeichnis-Schnitt,
> Sortier-Ordnung, Hash je Datei vs. über die Konkatenation). Das ist eine Identitäts-Entscheidung
> je Tier-Binary und gehört dem Owner, nicht diesem Header."*

Ohne diese drei Festlegungen ist E-E **nicht baubar**, auch bei einem „ja". Das ist kein Aufschub —
es ist eine Vorbedingung.

### Optionen

| | Konsequenz |
|---|---|
| **(a) ja, jetzt** | Leichter: der Dreh ist heute gratis, der Anker ist ohnehin frisch, das Interface bekommt sein vollständiges Preimage von Anfang an. Schwerer: **die drei Unterfragen müssen zuerst beantwortet werden**, und der Overlay-Codegen ist ein neuer Bauteil (kein Bestand). |
| **(b) nein, späteres Fenster** | Leichter: null Arbeit jetzt. Schwerer: **die Scharfschaltung kostet dann ~34,4 h Neubau plus die Entwertung aller bis dahin erhobenen Messdaten.** Das ist der teuerste Aufschub der ganzen Vorlage. |

### Empfehlung: **(a) — aber gestaffelt**

Die Alt-Empfehlung **(b) trägt nicht mehr.** Ihre beiden Gründe sind entfallen: der Anker ist im
Fenster bereits gedreht, und „von der Direktive nicht gefordert" ist kein Argument gegen etwas, das
später das Zehnfache kostet.

Konkret empfohlen: **die drei Unterfragen jetzt beantworten und die Scharfschaltung in dasselbe
Fenster legen wie die Flag-Grammatik v2** (Task #36, Branch `bau/flag-grammatik-v2-s1`), für die
Sie die Invalidierung bereits als gewollt erklärt haben. Ein Fenster, ein Invalidierungsereignis,
zwei erledigte Posten. Fährt die Flag-Grammatik v2 ohne E-E, ist der nächste Overlay-Dreh der
teure.

**Wenn Sie gegen die Empfehlung entscheiden wollen**, ist (b) dann vertretbar, wenn Sie die drei
Unterfragen für offen halten und nicht unter Zeitdruck beantworten wollen. Dann sollte aber im
Ledger stehen, dass die 34,4 h bewusst gekauft wurden.

### Kosten des Aufschubs

**Eine Woche: möglicherweise alles.** Nicht die Woche ist der Taktgeber, sondern der erste Bau.
Solange kein Batch läuft: 0 h. Ab dem ersten `.fingerprint`: ~34,4 h Neubau + Messdaten-Entwertung.
**Wenn vor dem Entscheid ein Batch startet, ist das Fenster zu.**

---

# 2. E-A — Wie viele Hex-Zeichen trägt der Name? 🟡 blockiert S2

### Die Frage, verbatim (`:648`)

> **E-A** | Wie viele Hex-Zeichen trägt der Name? | (a) 16 = 64 bit; (b) **24 = 96 bit**;
> (c) 32 = 128 bit | **(b)**. Bei 2^17 Binaries liegt die Geburtstags-Kollisionswahrscheinlichkeit
> bei 96 bit jenseits jeder praktischen Relevanz; 24 Zeichen halten den Dateinamen kurz. Der
> **volle** 128-Hex bleibt im POD

Der Plan hält den Platz schon frei: `kStampNameHexLen = 24; // OWNER-ENTSCHEID E-A (16 / 24 / 32)`
(Plan `:170`).

### Was davon abhängt

Schritt **S2** (Plan `:574-577`), Datei `abi/version_stamp_name.hpp` — existiert noch nicht.
Mittelbar alles, was den Namen später trägt: die Plan-Ablage (S5/F7), und bei einem „ja" zu E-D
auch Ordnernamen und CSV-Spalten.

### Der Ist-Zustand am Code

**Echt offen.** Suche `grep -rn "version_stamp_interface|version_stamp_name|kStampNameHexLen|stamp_name"`
über `libs/`, `apps/`, `adapters/` im ce-Baum: **2 Treffer, beide unbeteiligt**
(`abi/meta_meta_stamp_suffix.hpp:76`, `:106` — das ist `meta_meta_stamp_name()`, eine andere Sache).
Keine der beiden geplanten Dateien existiert.

**Zwei Objektbefunde, die die Wahl schärfen und im Plan fehlen:**

- **Es gibt bereits eine 16-Hex-Konvention im Bestand.** `orch_fnv1a_hex`
  (`builder/build_orchestrator/build_orchestrator.hpp:210-223`) liefert genau **16 Hex-Zeichen** und
  wird heute zur Eindeutigkeit von Datei-Stems benutzt. Sie ist ein anderer Hash für einen anderen
  Zweck — aber sie ist die einzige Präzedenz im Haus.
- **Die Namenslänge steht unter einem harten Budget.** `kStemMax = 120`
  (`build_orchestrator.hpp:231`), gekappt gegen Windows-MAX_PATH 260; der Kommentar `:225-230`
  dokumentiert, dass ein ungekappter Stem schon einmal zu einem **stillen** `ofstream`-Fehlschlag
  geführt hat (Befund 03.06., `built=0`). Acht Zeichen mehr oder weniger sind hier keine Kosmetik.
- **Die Mengenangabe der Begründung ist möglicherweise zu klein.** Der Code pinnt heute
  `catalog_axis_product<FullSourceCatalog>() == 131072u` (`profile_facade/source_catalog.hpp:169`)
  = 2^17. Task #21 führt die reale Bau-Menge aber als **unbekannt** (131.072 / 524.288 / 2.097.152,
  Faktor 16), und der Hybrid-Plan rechnet die Tier-Ebene mit **524.288**
  (`…-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:844`).

### Optionen

| | Konsequenz |
|---|---|
| **(a) 16 = 64 bit** | Leichter: kürzeste Namen, meiste Luft unter `kStemMax`, deckungsgleich mit der bestehenden `orch_fnv1a_hex`-Konvention. Schwerer: bei 2^21 Binaries liegt die Kollisionswahrscheinlichkeit bei ~1,2·10⁻⁷ — praktisch vernachlässigbar, aber nicht mehr „jenseits jeder Relevanz". |
| **(b) 24 = 96 bit** | Leichter: trägt auch 2^21 mit riesigem Abstand; 24 Zeichen sind unter `kStemMax=120` unkritisch. Schwerer: nichts Nennenswertes. |
| **(c) 32 = 128 bit** | Leichter: der Name **ist** der volle Fingerprint, keine Präfix-Semantik nötig. Schwerer: 32 Zeichen in jedem Ordner-/Dateinamen; bei E-D=(a) doppelt spürbar. |

### Empfehlung: **(b) 24 — die Alt-Empfehlung trägt**

Sie trägt, aber ihre Begründung war zu schmal: „2^17" ist nicht der belastbare Mengenanker. Der
tragfähige Grund ist ein anderer und robuster: **96 bit deckt auch die größte diskutierte Bau-Menge
(2^21) mit über zehn Größenordnungen Abstand ab, und 24 Zeichen kosten unter `kStemMax=120` nichts.**
Die Wahl bleibt damit richtig, auch wenn Task #21 die Menge nach oben auflöst — was (a) nicht
gleichermaßen gilt.

### Kosten des Aufschubs

**Diese Woche: null.** E-A blockiert nur den Bau von S2, und S2 ist ohnehin nicht begonnen. Der
Name geht nicht ins Preimage — die Länge ist zu jedem Zeitpunkt kostenlos änderbar, **solange der
Name nirgends in Ordnernamen oder CSV steht**. Ab einem „ja" zu E-D wird eine Längenänderung ein
Archiv-Ereignis. **Deshalb: E-A muss vor E-D fallen, nicht vor S2.**

---

# 3. E-F — Planer-Stufe: honest-empty oder eigenes Set? 🟡 blockiert S1

### Die Frage, verbatim (`:653`)

> **E-F** | Trägt die **Planer**-Stufe leere Achsen-Kategorie-Glieder (honest-empty), oder ein
> eigenes, kürzeres Glieder-Set? | (a) **honest-empty**, gleiche 8 Positionen; (b) eigenes Set |
> **(a)** — ein POD-Layout für alle Stufen; leer heißt leer, nicht „anders"

### Was davon abhängt

Schritt **S1** (Plan `:567-572`) — der als **kleinster sinnvoller erster Schritt** benannte
(Plan `:759-772`). Datei `abi/version_stamp_interface.hpp`, konkret das Feld `glieder_len` und die
`static_assert`-Kette aus Plan 3.2. Mittelbar S4 (`planner_version_stamp()` als POD-Renderer).

### Der Ist-Zustand am Code

**Echt offen — aber es gibt eine bestehende Owner-Direktive, die in die Gegenrichtung zeigt.**

`libs/cache_engine/profile_facade/planner/planner_version.hpp:4-7` zitiert **Section43.b** als
User-Direktive:

> *„Der Experiment-Planer trägt auch einen string_view-Stempel, aber nur über die eigene statische
> Versionierung und unter welcher ISA/OS er passt und ausgeführt werden kann."* Der Planer
> permutiert (er ist keine Permutation) → **KEINE Achsen-Arrays**, nur die Selbst-Version X.Y.Z +
> eine Ausführbarkeits-Deklaration (ISA/OS).

Und so ist es gebaut: `planner_version_stamp()` (`:61-70`) liefert
`"planner@1.0.0.c isa=<isa> os=<os>"` — **kein einziges Achsen-Glied.** Der Vier-Zeilen-Block des
Treiber-Binary (`profile_facade/g1_binary_version_stamp.hpp:41-54`) ergänzt nur
`ceb-contract`, `build-type`, `build-version`.

**Das ist ein echter Spannungspunkt**, und ich löse ihn nicht selbst auf: Section43.b spricht über
die **gerenderte Stempel-Zeile**, E-F fragt nach dem **POD-Layout** des neuen Interfaces. Das muss
sich nicht widersprechen — ein POD mit leeren Gliedern kann eine Zeile ohne Glieder rendern. Aber
wer Section43.b als „der Planer trägt keine Achsen-Glieder, Punkt" liest, für den ist (a) eine
Abweichung von einer bereits erteilten Direktive. **Diese Lesart ist Ihre Entscheidung, nicht meine.**

**Zweiter Befund: der POD-Entwurf des Plans ist durch R-3 überholt.** Plan Sec. 3.1 definiert
`StampGliedKategorie` mit **acht** Werten (`format=0 … overlay=7`) und pinnt
`fingerprint_format = 3`, `glieder_count = 8`. Der Code trägt heute **neun** Glieder; das neunte ist
`kAnatomyFingerprintMessGatesGlied = 8` (`anatomy_fingerprint.hpp:417`). Die im Plan vorgesehene
Wache `static_assert(kStampKategorieCount == kAnatomyFingerprintGliedCount)` (Plan `:390`) **würde in
der Entwurfsform nicht kompilieren** (8 ≠ 9). Das ist kein Entscheid, sondern ein Nachzug — aber er
fällt genau in S1 an und gehört zu E-F an denselben Tisch.

### Optionen

| | Konsequenz |
|---|---|
| **(a) honest-empty, gleiche Positionen** | Leichter: **ein** POD-Layout für alle vier Stufen; `verify_version_stamp` funktioniert stufenunabhängig; die Kategorie-Wache aus Plan 3.2 gilt überall gleich. Schwerer: der Planer trägt Felder, die er nie füllt — und das berührt die Lesart von Section43.b. |
| **(b) eigenes, kürzeres Set** | Leichter: näher am Wortlaut von Section43.b; der Planer-POD trägt nur, was er hat. Schwerer: **zwei** Layouts, zwei Wachen, zwei Verify-Pfade — und die Gleichheits-Wache aus Plan 3.3 müsste je Stufe verzweigen, was die I1-Doktrin („GENAU EINE Schnittstelle, EIN versionierter POD", Plan `:296-300`) genau an der Stelle bricht, an der sie zählt. |

### Empfehlung: **(a) honest-empty — die Alt-Empfehlung trägt, mit einer Auflage**

Der Grund ist die I1-Doktrin, auf die der ganze Entwurf gebaut ist: ein POD, eine Wache, ein
Verify-Pfad. Zwei Layouts würden genau den Zweitweg schaffen, gegen den das Interface gebaut wird.
„Leer heißt leer" ist außerdem die ehrlichere Aussage: der Planer **hat** keine Organ-Achsen — das
ist eine Tatsache über den Planer, keine Eigenschaft seines Datenformats.

**Auflage: bitte bestätigen Sie mit, dass Section43.b weiterhin für die _gerenderte Zeile_ gilt.**
Dann bleibt `planner_version_stamp()` byte-identisch (was S4 ohnehin als Auflage trägt, Plan
`:588-593`) und (a) betrifft nur das POD-Innere. Ohne diese Bestätigung baue ich hier nichts.

### Kosten des Aufschubs

**Diese Woche: null Euro, aber der Bau steht.** E-F blockiert S1 — und S1 ist der einzige Schritt,
der laut Plan `zu jedem Zeitpunkt landen kann, auch mitten in einem Mess-Fenster` (`:766-767`).
Solange E-F offen ist, kann dieser risikofreie Schritt nicht beginnen. Kein Geldbetrag, aber
verlorene Kalenderzeit auf dem einzigen Pfad, der keine Wartezeit bräuchte.

---

# 4. E-D — Ordnernamen/CSV-Spalten auf den Stempel-Namen? 🟠 eigenes Fenster

### Die Frage, verbatim (`:651`)

> **E-D** | Dürfen Ordnernamen/CSV-Spalten auf den Stempel-Namen umgestellt werden? | (a) ja, mit
> Doppel-Spalte in der Übergangszeit; (b) ja, hart; (c) nein | **(a)**, und ausschließlich **im
> F5-Fenster** — die Messdaten-Doktrin verlangt die Joinbarkeit der Alt-Läufe

### Was davon abhängt

Schritt **S7** (Plan `:605-612`), im Plan als *„der teuerste Schritt, und der einzige, der
Messdaten-Vergleichbarkeit berührt"* geführt. Betroffene Dateien:
- `profile_facade/profile_run_entry.hpp:1099-1104` — hier entsteht `perm_suffix` und daraus
  `perm_build_version` (`.version`-Sidecar je Perm) **und** `perm_tag_build_version`
  (CSV-Provenienz-Spalte je Perm)
- `profile_facade/experiment_run_entry.hpp:370-374` — die zweite, symmetrische Stelle
- `builder/build_orchestrator/build_orchestrator.hpp:231-238` — `orch_make_stem`, der Ordner-/Datei-Stem

### Der Ist-Zustand am Code

**Echt offen, unverändert.** Beide Suffix-Bildungsstellen stehen wie im Plan beschrieben; keine
Umstellung begonnen. Der Plan verweist auf TABU-6 des F5-Fensters
(`docs/plaene/20260806-PLAN-golden-update-fenster.md`, Abschnitt 0) als strukturgleichen Bruch.

**Was ich nicht abschließend klären konnte:** ob die laufende **Flag-Grammatik v2** (Task #36,
Branch `bau/flag-grammatik-v2-s1`) die Suffix-Kette mitzieht. Das DESIGN-Dokument
(`docs/plaene/20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md`) liefert auf
`grep -n "perm_suffix|Ordner|CSV-Spalte|Invalidierung|binary_id"` **0 Treffer** — es beschreibt die
Versions-Literal-Syntax, nicht die Ablage-Grammatik. Nach Aktenlage berührt es E-D also nicht.
Da es aber ein erklärtes Byte-Ereignis ist und im Bau steht, ist das **ungeprüft am Objekt**; ich
habe den Bau-Branch nicht gegen `development` diffbar geprüft.

### Optionen

| | Konsequenz |
|---|---|
| **(a) ja, mit Doppel-Spalte** | Leichter: Alt-Läufe bleiben joinbar, die Messdaten-Doktrin ist eingehalten, die Umstellung ist reversibel. Schwerer: die CSV trägt zwei Spalten für dieselbe Sache, bis der Alt-Bestand abgelaufen ist — plus ein Nachweis, dass der Join wirklich trägt (Gate G-S7, Plan `:703`). |
| **(b) ja, hart** | Leichter: eine Spalte, sofort sauber. Schwerer: **kein Zeilen-Join alt-gegen-neu mehr.** Das verstößt gegen die Messdaten-Doktrin und gegen STOPP-Klausel 5 (Plan `:715-716`). |
| **(c) nein** | Leichter: null Risiko am Archiv. Schwerer: die Ordner-/CSV-Namen bleiben die einzige Stelle, die den Stempel **ein zweites Mal** ableitet — genau die Drift, gegen die das Interface gebaut wird. F7 bliebe halb gelöst. |

### Empfehlung: **(a) — die Alt-Empfehlung trägt unverändert**

Ich sehe keinen Grund, hier von (a) abzuweichen. Die Messdaten-Doktrin („Messdaten nie löschen")
ist bindend, und (b) verletzt sie direkt. (c) wäre die einzige ernsthafte Alternative — sie würde
aber das Kernversprechen des Interfaces (eine Quelle für alle Namen) an genau der sichtbarsten
Stelle nicht einlösen.

**Präzisierung zum Zeitpunkt:** der Plan sagt „im F5-Fenster". Der tragfähigere Anker ist:
**vor dem ersten produktiven Messlauf.** Solange keine CSV mit Alt-Suffixen existiert, gibt es auch
nichts zu joinen — die Doppel-Spalte wäre dann Vorsorge ohne Gegenstand und könnte entfallen.

### Kosten des Aufschubs

**Eine Woche: null, solange kein Messlauf gefahren ist.** Danach steigt der Preis nicht sprunghaft
wie bei E-E, sondern **stetig**: jeder gefahrene Lauf vergrößert den Alt-Bestand, der über die
Doppel-Spalte mitgeschleppt werden muss. E-D wird nicht unmöglich, nur zunehmend lästig.

---

# 5. E-C — Drei Provenienz-Sidecars auf den POD? 🟢 entlastet

### Die Frage, verbatim (`:650`)

> **E-C** | Dürfen die drei Provenienz-Sidecars auf den POD gezogen werden, mit einmaliger
> Bucket-Invalidierung? | (a) ja, im selben Fenster; (b) ja, aber getrennt; (c) nein, Sidecars
> bleiben wie sie sind | **(b)** — ein Fenster, ein Invalidierungs-Ereignis

### Was davon abhängt

Schritt **S6** (Plan `:598-603`). Die drei Sidecars entstehen in
`builder/build_orchestrator/build_orchestrator.hpp`: `.version` (`:242`), `.algos` (`:248`),
`.variant` (`:255`).

### Der Ist-Zustand am Code — hier liegt der Befund

**Die Kostenbegründung des Plans ist am Code widerlegt.** Plan `:599-601` schreibt:

> *„Selbst wenn die Bytes gleich bleiben sollen: sobald **eine** Zeichenkette wandert, mismatcht
> `dll_is_current` — also **Neubau der Flotte**"*

`dll_is_current` (`build_orchestrator.hpp:331-338`) ist heute:

```
if (expected_fingerprint.empty()) return false;        // (1) fail-closed
if (!std::filesystem::exists(output, ec) || ec) return false;
auto const vorhanden = read_fingerprint_sidecar(output);
if (!vorhanden) return false;
return *vorhanden == expected_fingerprint;             // DER EINE VERGLEICH
```

Es liest **ausschließlich** das `.fingerprint`-Sidecar. Die Historik-Zeile direkt darüber
(`:307-309`) sagt es ausdrücklich:

> *„Diese Dreifach-String-Gleichheit ist mit F7 (‚NUR') ERSETZT, nicht ergänzt:
> .version/.algos/.variant werden weiter GESCHRIEBEN (Provenienz-Legende bzw. Transport-
> Vollständigkeits-Marke von push_tier_binary), entscheiden aber über KEINEN Skip mehr."*

Der Plan **weiß das an einer anderen Stelle selbst** — Sec. 4b, Zeile 493: *„Sie sind seit der
A2-Eichung ohnehin reine Provenienz (Skip hängt nur an `.fingerprint`, `:293-299`)"* — und
widerspricht sich in S6. Die S6-Formulierung stammt aus der Zeit vor der A2-Eichung (05.08.).

**Folge: E-C kostet keinen Flotten-Neubau**, solange nur der *Inhalt* der drei Provenienz-Dateien
umformatiert wird. Der Lager-Index-Schlüssel hängt ebenfalls am `.fingerprint`, nicht an den dreien
(`build_orchestrator.hpp:375`).

**Eine Einschränkung, die bleibt:** zieht S6 den `+ceb=`-Wert mit (Contract-Minor), ist das sehr wohl
ein Bucket-Ereignis — dieser Wert geht über die `build_version` ins Toolchain-Glied [5] und damit
ins Preimage. **Solange S6 den Contract-Minor nicht anfasst, ist es folgenlos.**

### Optionen

| | Konsequenz |
|---|---|
| **(a) ja, im selben Fenster** | Leichter: die drei Zweit-Ableitungen fallen sofort, das Interface wird an drei sichtbaren Stellen wirksam, **und es kostet nach heutigem Stand keine Invalidierung**. Schwerer: S6 muss belegen, dass der Contract-Minor unberührt bleibt. |
| **(b) ja, aber getrennt** | Leichter: nichts mehr — der Grund („ein Invalidierungs-Ereignis") ist entfallen, es gibt kein Ereignis mehr zu bündeln. Schwerer: ein zusätzliches Fenster für einen folgenlosen Umbau. |
| **(c) nein** | Leichter: null Berührung. Schwerer: drei Zweit-Ableitungen bleiben stehen, gegen die das Interface gebaut wird. |

### Empfehlung: **(a) — die Alt-Empfehlung (b) trägt nicht mehr**

(b) war richtig, solange man einen Flotten-Neubau erwartete: dann bündelt man ihn. Diesen Neubau
gibt es nicht mehr. Damit ist (b) nur noch ein Fenster ohne Inhalt, und (a) ist die einfachere
Wahl.

**Auflage:** S6 muss im Gate literal ausweisen, dass `kCebContractCodegenMinor` und
`COMDARE_ANATOMY_ABI_MAJOR` unverändert sind — sonst kippt die Entlastung.

### Kosten des Aufschubs

**Eine Woche: null.** E-C fällt in kein Fenster; die drei Sidecars sind reine Provenienz. Dieser
Entscheid kann warten, ohne dass etwas teurer wird. **Er ist der am wenigsten dringliche der
sechs** — was er vor dieser Prüfung nicht war.

---

# 6. E-B — Soll der Name auch im Symbol stehen? 🟢 faktisch vorentschieden

### Die Frage, verbatim (`:649`)

> **E-B** | Soll der Name auch im **Symbol** stehen? | (i) Emitter schreibt ihn (bricht golden-CRC);
> (ii) nur `.rodata`; (iii) NTTP-Mangelung | **(ii) + später (iii)**. (i) kostet einen CRC-Neuanker
> für Null-Zusatznutzen

### Was davon abhängt

Schritt **S9** (Plan `:620-623`). Bei (i) zusätzlich: `builder/codegen/adhoc_emitter.hpp`,
`profile_facade/sota_catalog.hpp`, der golden-CRC `kNewGolden131072Crc64`
(`profile_facade/source_catalog.hpp:183-187`) und die golden-320-Dateien.

### Der Ist-Zustand am Code

**Formal offen, praktisch vorentschieden.** Der Plan sagt selbst (`:621`): *„Variante (ii) ist
bereits mit S3 erledigt (Daten in `.rodata`)."* Das heißt: wer S3 baut, hat (ii) — die Frage ist
nur, ob **zusätzlich** (i) oder (iii) kommt.

Das Tier-Makro exportiert heute fünf `extern "C"`-Symbole; das fünfte ist
`comdare_anatomy_version_lines()` (`abi/anatomy_module_abi_v1.hpp:164`, als *„OPTIONALE(S)
extern-‚C'-Probe-Symbol"* geführt, `:119`). Das im Plan vorgesehene sechste Symbol existiert nicht.

### Optionen

| | Konsequenz |
|---|---|
| **(i) Emitter schreibt den Namen in den Quelltext** | Leichter: der Name steht im generierten Code, mit bloßem Auge lesbar. Schwerer: **bricht den golden-CRC und die Emitter-Round-Trip-Byte-Wache** (Plan `:629-631`) — ein eigener Anker, für Information, die über (ii) ohnehin abrufbar ist. Der Plan rät ab (Sec. 2.4). |
| **(ii) nur `.rodata`** | Leichter: fällt mit S3 ab, preimage- und golden-neutral, per `nm -D` prüfbar. Schwerer: nichts. |
| **(iii) NTTP-Mangelung** | Leichter: der Name steht im **Symbolnamen** selbst, damit auch ohne Laden der DLL sichtbar; laut Plan preimage-neutral und billig. Schwerer: mangled Namen werden lang und weniger lesbar. |

### Empfehlung: **(ii), später (iii) — die Alt-Empfehlung trägt unverändert**

Ich habe keinen Grund gefunden, hier etwas zu ändern. (i) kauft einen CRC-Neuanker für Information,
die (ii) kostenlos liefert. (iii) ist ein späteres, billiges Extra.

### Kosten des Aufschubs

**Praktisch null.** E-B blockiert S9, und S9 ist der letzte Schritt des DAG. Solange S3 gebaut wird,
entsteht (ii) ohnehin. **Dieser Entscheid könnte auch nach dem Bau von S1–S5 fallen** — er steht
hier nur der Vollständigkeit halber, weil das Gate G-S9(i) ihn formal verlangt (Plan `:701`).

---

# WAS ICH NICHT KLÄREN KONNTE

1. **Ob die Flag-Grammatik v2 die Ablage-Grammatik mitzieht (betrifft E-D).** Das DESIGN-Dokument
   liefert auf `grep -n "perm_suffix|Ordner|CSV-Spalte|Invalidierung|binary_id"` über
   `docs/plaene/20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md` **0 Treffer** — nach
   Aktenlage berührt es E-D nicht. Ich habe den Bau-Branch `bau/flag-grammatik-v2-s1` aber **nicht
   gegen `development` gediffed**; ein im Bau befindliches Byte-Ereignis nur nach Plandokument zu
   beurteilen, ist genau die Art Behauptung, die ich nicht als Befund verkaufe. **Ungeprüft am Objekt.**

2. **Die richtige Lesart von Section43.b (betrifft E-F).** Ob die Direktive „KEINE Achsen-Arrays"
   für den Planer nur die gerenderte Zeile meint oder auch das interne Datenformat, kann ich aus
   `planner_version.hpp:4-7` nicht entscheiden. Ich habe die Original-Fundstelle von Section43.b
   nicht gesucht — sie liegt außerhalb der geprüften Dateien. **Das ist eine Owner-Auslegung, keine
   Code-Frage.**

3. **Die reale Bau-Menge (betrifft E-As Begründung, nicht die Wahl).** Der Code pinnt 2^17
   (`source_catalog.hpp:169`), Task #21 führt die Frage als offen (Faktor 16). Meine Empfehlung (b)
   ist gegen alle drei diskutierten Größen robust, aber die im Plan gegebene Begründung ist an eine
   Zahl gebunden, die nicht feststeht.

4. **Der Zustand von `main` gegenüber `development`.** `main` trägt noch Format 3 / 8 Glieder
   (`git show main:…/anatomy_fingerprint.hpp` → `:89`, `:341`), `development` Format 4 / 9. Das ist
   nach der Gitflow-Doktrin erwartbar (development voraus), aber ich habe **nicht** geprüft, ob ein
   Nachzug von `main` aussteht oder bewusst zurückgehalten wird.

5. **Eine Namenskollision, die ich nur melde, nicht löse.** Der Ledger führt bereits ein **anderes**
   `E-A..E-E` — die Goal-V2/V3-Entscheidungs-Defaults, die dort schon einmal wegen einer Kollision
   (mit E0–E4) in **`DD-A..DD-E`** umbenannt wurden (`LEDGER:400`). Die 43 `E-x`-Treffer im Ledger
   gehören sämtlich zu jenem alten Satz, **nicht** zu diesen sechs. Der Nullbefund des Auftrags
   („0 Treffer") ist damit inhaltlich richtig, aber ein blindes `grep E-C` im Ledger findet Falsches.
   **Vorschlag: diese sechs bei der Verbuchung eindeutig als `VS-A..VS-F` (Versions-Stempel) führen** —
   sonst ist es die dritte Kollision auf demselben Buchstabenraum.

---

## VERFAHRENSHINWEIS — eine Präzisierung zur STOPP-Doktrin

Der Satz **„STOPP (generell): ohne Entscheid kein Byte"** steht im Plan auf **Zeile 704**, und zwar
unter der Gate-Gruppe **G-S6 / G-S7 / G-S8 / G-S9(i)** (Überschrift `:700`). Er deckt damit
wörtlich **E-C, E-D, E-E und E-B** — **nicht** E-A und E-F.

Das ist keine Spitzfindigkeit, sondern entlastet: **E-A und E-F blockieren keinen Bau per
STOPP-Klausel.** Sie sind Bau-Parameter von S1/S2 — man kann sie nicht umgehen, aber ihr Fehlen ist
kein Doktrin-Verstoß, sondern schlicht eine fehlende Zahl und ein fehlendes Layout. Wenn Sie heute
nur zwei Entscheide treffen wollen, sind es **E-E** (Fenster) und **E-F** (schaltet den
risikofreien ersten Schritt frei).

---

## Belege in Kürze

| Aussage | Fundstelle |
|---|---|
| Die sechs Fragen, verbatim | `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md:648-653` |
| „STOPP (generell)" gilt für G-S6/S7/S8/S9(i) | ebd. `:700-704` |
| „Ein Fenster, ein Anker" | ebd. `:708-709` |
| S6 behauptet Flotten-Neubau | ebd. `:599-601` |
| …und widerspricht sich in 4b | ebd. `:493` |
| `dll_is_current` liest nur `.fingerprint` | ce `builder/build_orchestrator/build_orchestrator.hpp:331-338` |
| „entscheiden aber über KEINEN Skip mehr" | ebd. `:307-309` |
| Die drei Sidecar-Pfade | ebd. `:242`, `:248`, `:255` |
| 16-Hex-Präzedenz / `kStemMax = 120` | ebd. `:210-223`, `:231` |
| Format 4, 9 Glieder (development) | ce `abi/anatomy_fingerprint.hpp:106`, `:387` |
| Overlay-Glied leer + drei Owner-Unterfragen | ebd. `:117-128` |
| Overlay = Position 7, Mess-Gates = 8 | ebd. `:407`, `:417` |
| R-3 war im Fenster kostenlos | ebd. `:100-105` |
| `17148e5a` nur noch Vorgänger | ce `tests/unit/test_g3_sha512_index.cpp:73` u. a. |
| Section43.b: „KEINE Achsen-Arrays" | ce `profile_facade/planner/planner_version.hpp:4-7` |
| `planner_version_stamp()` heute | ebd. `:61-70` |
| Fünftes Symbol `…version_lines` | ce `abi/anatomy_module_abi_v1.hpp:164`, `:119` |
| 2^17-Pin | ce `profile_facade/source_catalog.hpp:169` |
| 34,4 h / Fenster-0-Kosten | `docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md:844-845` |
| Owner-Verbatim F7 = Option b | `LEDGER:6629` |
| BEFUND 2 (dieser Auftrag) | `LEDGER:8132` |
| Alt-Kollision E-A..E-E → DD-A..DD-E | `LEDGER:400` |
| G-1 im Erst-Anker | `docs/sessions/20260807-STAND-wellenplan-abgeschlossen-und-offene-entscheide.md:76` |
| `.fingerprint`-Bestand = 0 | von mir gemessen, 07.08.: `find <baum> -name "*.fingerprint" -not -path "./.git/*" \| wc -l` = 0 in beiden Bäumen |
