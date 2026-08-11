# ZWISCHENSTAND 11.08.2026 — DER HAUPTSTRANG HEISST STEMPEL

> **Stand:** Di 11.08.2026, nachmittags · **F1 in drei Tagen** (Fr 14.08.) ·
> **Abgabe in 35 Tagen** (Di 15.09.)
> **Zweck:** den Faden halten. Dieses Dokument sagt, woran alles hängt, was heute gelandet ist,
> welche neun Festlegungen der Owner heute getroffen hat, und in welcher Reihenfolge die
> offenen Posten fallen müssen.

---

## IN EINEM SATZ

Die Welle W0b ist gebaut und gelandet, aber der **Durchstich zu F1 hängt an einer einzigen
Sache** — der Stempel-Mechanik, deren geschärfte Implementierung fehlt; und weil sie fehlt,
klemmen daran auch die Versionierung aller vier Binary-Typen, die Additivität von
Hardware-Erweiterungen und die Frage, in welcher Ordnung Achsen überhaupt übergeben werden.

---

## 1. DER HAUPTSTRANG: DIE STEMPEL-MECHANIK

**Owner 11.08., wörtlich:** *„Alle Blocker klemmen also an der Reimplementierung der
geschärften Stempel-Mechanik."*

Und dazu die Richtung, die einen Rückbau ausschließt:

> *„wir holen die alten Stempel **nicht** zurück, weil wir **neue geplant** haben und auch sich
> die Architektur bis hierhin **geschärft** hat."*

### 1.1 Warum der Wellenplan denselben Befund führt

`docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:877-884` (Korrektur-Einschub
vom 10.08.) sagt es unabhängig:

> *„Die Kette bis `##25 DURCHSTICH` ist damit **leer** … Das ist der **einzige** verbleibende
> Blocker vor F1."*

Am Objekt heute nachgemessen, beide Teile stehen ungeheilt:

    ce sota_catalog.hpp:172 / :248   STAMP_M("organ", "system", ...)   <- Organ VORN
    ce adhoc_emitter.hpp:124         der 2-arg-Zweig ohne Mess-Anteil

### 1.2 Die Historie — Referenz für die Fähigkeit, nicht Vorlage für Code

| Datum | Commit | Was |
|---|---|---|
| **19.07.** | ce `b23b7ee2` | „feat(W12-A/§43): Versionierungs-Bausteine" — 7 Dateien, 452 Zeilen, EINE Wurzel. Alle vier Bausteine und beide Tests leben heute noch. |
| **22.–04.08.** | `8a1e3464` · `244505df` · `9de12722` | drei Pakete bauten **daneben** statt darauf: `g1_binary_version_stamp.hpp`, `ceb_version_stamp.hpp`, `pruef_dock_version.hpp`. Vier Nummernkreise, vier Namensschemata, keines mit Bezug auf §43. |
| **27.07.** | ce `813c3232` | „V-4 Permutations-Alt-Kanal retired" — 17 Dateien / 2180 Zeilen entfernt, darunter `axes_versions.txt` mit dem **selektiven Rebuild**. |
| offen | — | **W12-B**, die zweite Hälfte von §43, wartet seit dem 19.07. auf „nach W11". |

Der Retire vom 27.07. war **sorgfältig** — der Commit nennt den Merkposten, erklärt das Warum,
listet Entferntes und Behaltenes einzeln und warnt sogar vor einer Nachfolge-Falle. Die Frage
ist nicht, wer schuld ist, sondern **was unbemerkt mitging**: die Fähigkeit, nur die
*betroffenen* Permutationen neu zu bauen.

    # Format: <achse>_<axis_id>_<variant>=<version_tag>
    # Codegen detektiert Differenz zu perm_<id>.version + triggert MINOR-Bump
    # nur bei BETROFFENEN Permutationen (selective rebuild).

Heute vergleicht `dll_is_current` (`build_orchestrator.hpp:345-352`) 128 Hex auf **Gleichheit**
⇒ die ganze Flotte müsste neu gebaut werden. Das ist genau die Fähigkeit, die die Owner-Regel
*„Hardware-Erweiterung ist additiv"* braucht.

### 1.3 Das SOLL (Owner-Orientierung 10.08.)

| Träger | Versionierung | Fingerprint-SHA |
|---|---|---|
| Achsen-Algorithmus | eigene Version, spiegelt sich in der Tier-Binary | — |
| **Genus** (Interface) | **ZUSAMMENGESETZT** compile-time aus **allen** Mess/System/Organ-Achsen | — |
| Planer | simple X.Y.Z | **JA** |
| CEB | **nur Mess + System** (keine Organ) | **JA** |
| Tier-Binary | Mess + System + Organ | **JA** |
| Hybrid-Tier-Binary | dito | **JA** |

**System-Achsen sind die einzigen mit komplexer Grammatik** (CPU/GPU/FPGA/NPU/AVX).
**`measurement_tooling_registry`** ist die einzige Mess-Achse mit System-Achsen-Syntax.

**IST-Lücken, am 10.08. gemessen:** Planer-SHA fehlt · CEB trägt System **leer**
(`ceb_version_stamp.hpp:415`) · Genus-Versionen **handgeschrieben** statt abgeleitet
(`pruef_dock_version.hpp:58-64`, fünf freie Literale, ein einziger Aufrufer — ein Test).

**Was lebt:** 153 `static constexpr algo_version` mit echt verschiedenen Werten, die über
`axis_variant_version_table` → `compose_organ_stamp_line()` → `kOrganAxisVersionLine` wirklich
in die Tier-Binary fließen.

---

## 2. WAS HEUTE GELANDET IST

| Repo | Landung | Pipeline |
|---|---|---|
| super | `2388afdc → e6d90232` — P-LIZENZ | **15674 · 33/33 grün** |
| ce | `31240ac5 → d79bbcdd` — P-WARN + P-D37B als Sammellandung | 15675 · 23/24, **1 rot: `test:coverage-guard`** |

**Der beste Commit der Runde:** `346b6da9` — *„die Ausschliessung der zwei Lauf-Modi wird
**durchgesetzt statt zugesagt**"*. Ein Kommentar hatte behauptet, zwei Schalter seien
gegenseitig ausschließend; drei Ebenen zeigten null Code-Durchsetzung. Statt den Kommentar zu
entschärfen, wurde der Riegel gebaut.

**P-WARN trägt eine neue SHA:** `aa65b527` existiert auf `development` nicht mehr — der
Commit-Text wurde per `--amend` korrigiert (falsche Herleitung der Zahl 226). Gelandet ist
`b2d713d4`, Tree-SHA identisch.

**Was die Lande-Stufe eingefangen hat:** Die Heil-Stufe meldete P-LIZENZ als landefähig —
falsch. `lint:format` war hart rot, **159 Verstöße in genau den drei Paketdateien**. Bei ce
dasselbe Muster (`d79bbcdd` ist ein reiner Format-Nachzug). Das war die **dritte Landung in
Folge** mit Format-Nachzug.

**Nicht gelandet, mit Grund:**
- Gitlink-Bump super → ce `d79bbcdd`: setzt eine grüne ce-Pipeline voraus
- main-FF beider Repos: fällig erst nach Paket-Abschluss; **vor dem FF die Hygiene-Wache über
  den kumulativen Bereich fahren** — push-lokal grün sagt darüber nichts
- Fünf Restpakete (siehe §5)

---

## 3. DIE NEUN OWNER-FESTLEGUNGEN VON HEUTE

Dichteste Sammlung seit Wochen. Jede ist bindend.

**(1) Parallel bauen, sequentiell landen.** Die Serialisierung gehört an die *Landung* — sie ist
ohnehin seriell (R4 + Ein-Blech) und kürzer als ein Vollbau. Die Lande-Stufe gehört **in den
Workflow** und landet den **Zweig**, nicht einen gemerkten SHA. → Arbeitsweise v3.2, A2.1.

**(2) Es wurde noch nie eine Flotte gebaut.** *„daher kein Blocker vorhanden, aber der Bau ist
unser Ziel."* Damit ist jede Kostenrechnung der Form „das invalidiert die Flotte"
**gegenstandslos** — die Menge ist leer. **Die Dringlichkeit dreht sich um:**

    heute (vor W2)     Ordnung ändern = 0 invalidierte Binaries — kostenlos
    Mi 26.08. 06:00    BAU-TRIGGER, ~41,4 h
    danach             dieselbe Änderung entwertet den gesamten Bau

Nicht „erst bauen, dann ordnen", sondern zwingend umgekehrt. Der Riegel steht schon im Plan:
**F2 (Fr 21.08.) = IDENTITÄTS-FREEZE**.

**(3) Stempel-Mechanik und vertauschte Variablen sind ZWEI Themen.** *„beide Anforderungen von
mir sind korrekt und müssen separat geprüft werden."* → Posten #86 und #87.

**(4) Funktions-Variablen stehen in Stufigkeits-Ordnung.** *„alle Funktions-Variablen in
Reihenfolge der Stufigkeit der ZWEIPHASIG/DREIPHASIG … und nur das Lager hat hier eine Ausnahme
für die Übermittlung von Funktionsvariablen."*

    MESS   = DREISTUFIG   Planer (RT-Freigabe) → CEB (CT) → Tier (CT)
    SYSTEM = ZWEISTUFIG   gibt frei
    ORGAN  = ZWEISTUFIG   setzt durch
    ⇒ SOLL: MESS, SYSTEM, ORGAN

Die Lager-Ausnahme ist belegt: zwei Realm-Kaskaden in `lager_baum_writer.hpp` — Messdaten
`MESS→SYSTEM→ORGAN` (:711/:712/:716), Binaries `SYSTEM→ORGAN→MESS` (:744/:748/:756, Posten D-12).

**(5) Die alten Stempel werden nicht zurückgeholt.** Die Architektur hat sich geschärft; die
alte Implementierung ist Referenz für die **Fähigkeit**, nicht Vorlage für Code.

**(6) Der Explore läuft über zehn Wochen, über alle fünf Quellen.** *„Sonst findet der nichts."*
Berechtigt — mein erster Korpus war zu schmal (siehe §7).

**(7) Maximale Gründlichkeit beim Stempel, keine Kompromisse.** *„Rein planungstechnisch ist das
Stempel Thema das komplexeste."*

**(8) Konsolidierungs-Architektur, getrennt für Code und Doku,** für alle vier Repos; **nichts
löschen**; PRT-ART und Thesis werden synchron nachgezogen. → Posten #88.

**(9) 🔴 Erst laute Compile-Time-Fehler, dann verschieben.** *„jede dieser Abhängigkeiten
jeweils mit einer lesbaren und verständlichen Compiletime error Nachricht … danach können wir
die Struktur verschieben."*

Das ersetzt meinen schwächeren Vorschlag. Ich wollte die stillen Brüche **vermeiden** — also
durch Sorgfalt, und Sorgfalt trägt hier strukturell nicht. Der Owner-Weg macht sie **laut**:
Ein Bruch mit verständlicher Meldung ist kein Risiko mehr, sondern eine Arbeitsanweisung.

---

## 4. DIE ABHÄNGIGKEITSZAHLEN — warum der Umbau komplexer ist, als er aussieht

| Klasse | ce | super |
|---|---|---|
| `#include` | 17.783 | 693 |
| CMake `add_subdirectory` | 205 | 52 |
| CMake `include_directories` | 544 | 103 |
| **CMake `file(GLOB …)`** | **32** | **3** |
| CI-YAML-Pfade | 44 | 164 |
| Shell-Skripte mit Pfadaufrufen | 23 | 43 |
| Fixture-Verzeichnisse | 11 | 42 |
| Doku-Querverweise | 110 | 93 |
| **Anker `datei:zeile`** | — | **29** |

**18.900 brechen laut** — Fleißarbeit, kein Risiko.
**64 brechen still** — und die sind der Gegenstand von Festlegung (9):

- **35× `file(GLOB …)`** findet nach einem Umzug einfach *weniger*. Kein Fehler, keine Warnung.
  Ein Test verschwindet aus dem Bauweg — die Klasse, wegen der T-7 existiert.
- **29× Anker `datei.hpp:842`** zeigen danach auf einen *Nachbargegenstand*. Sie werden
  **falsch, nicht rot**. Präzedenz: der D5-3-Anker war um 239 Zeilen gedriftet, geheilt durch
  Umstellung auf **Symbol-Form**.

---

## 5. DER AUFGABEN-FADEN MIT ABHÄNGIGKEITEN

### 5.1 Auf dem kritischen Pfad zu F1 (Fr 14.08.)

```
#86 STEMPEL-MECHANIK  ──┬──► ##25 DURCHSTICH ──► F1
                        │
   hängt an:            └── Explore läuft (wf_b5f7f3a5-bfd + wf_1555a7af-a26)
                            danach Stufe 2 (Lead liest gegen), dann Designplan
```

**Alles andere ist Flanke.** Der Pfad ist schmal und war bis heute durch eine Frage blockiert,
nicht durch Kapazität — die ist mit Festlegung (4) beantwortet.

### 5.2 Vor F2 (Fr 21.08. = IDENTITÄTS-FREEZE) — identitätswirksam, deshalb terminiert

| Posten | Gegenstand | Warum vor F2 |
|---|---|---|
| **#87** | Funktions-Variablen in Stufigkeits-Ordnung | ändert ggf. das Preimage — heute kostenlos, danach nicht |
| **#78** | Stempel-Reihenfolge, drei Ebenen | dito; Ebene 1 darf **nicht** landen (wirkungslos, zweimal per SHA-256 belegt) |
| **#67** | Benennung: vier Familien über zehn Dateien | Umbenennung berührt 29 `#include`-Wanderungen |
| **#68** | Forensik / selektiver Rebuild | die Fähigkeit muss **vor** dem Bau stehen, sonst baut man ohne sie |

### 5.3 Flanke — parallelisierbar, disjunkt

| Posten | Gegenstand | Stand |
|---|---|---|
| **#80** | `coverage-guard` rot: **4 ISA (Sollverhalten) + 1 Prüfling** | am CI-Objekt getrennt; Heilung = Host-Klassen-Achse, Werkzeug existiert |
| **#82** | überlebender Mutant in **gelandetem** Code (P-GLIED) | `bvset_ist_teilmenge` auf zwei von drei Achsen blind |
| **#84** | Vorbestands-Rot: zwei Tests + ein Flattertest | fallen schon auf unverändertem `development` |
| **#83** | `lint:format` ohne auffindbare lokale Deckung | Sofortmaßnahme gefahren (Symlink), Repo-Skript fehlt |
| **#48** | Pflicht-Folge-Commit F1a/F1b | Basis als Argument statt Job-Variable |
| **#88** | Konsolidierungs-Architektur | Explore startet nach den Stempel-Explores |

### 5.4 Fünf Restpakete, Review läuft (`wf_8e1ff4b7-45e`)

| Paket | Repo | Umfang | Besonderheit |
|---|---|---|---|
| `landung/e18-snap` | super | +2673/-37 | ältestes Paket (09.08.), zwei Commits sind Codex-Heilungen |
| `bau/p3-ci-clang-pflicht` | super | +816 | einziges mit echtem C++-Produktionscode (`Code/ci_wachen/`) |
| `worktree-…-884-2` | super | +313/-31 | **super-Seite von D3-7b** — passt sie noch zur heute gelandeten ce-Seite? |
| `worktree-…-884-7` | super | +781/-31 | **Gitlink zeigt auf `bcf6bc97`, der NICHT auf ce/development liegt** |
| `rettung/bcf6bc97…` | ce | +173/-16 | die ce-Hälfte desselben Pakets (#77 + #79) |

**Zwingende Reihenfolge:** erst ce (`bcf6bc97`), dann super mit korrigiertem Gitlink.
**Drei der vier super-Pakete fassen `.gitlab-ci.yml` an** — ein Lead-only-Hotspot.

---

## 6. DIE DREI LAUFENDEN WORKFLOWS

| Run | Gegenstand | Stand |
|---|---|---|
| `wf_8e1ff4b7-45e` | Planabgrenzung + Dual-Review der fünf Restpakete | 5/6 |
| `wf_b5f7f3a5-bfd` | Stempel: 9 Explore-Schnitte → Synthese → Designplan → 2 Lenses | 0/3 |
| `wf_1555a7af-a26` | Historische Plan-Auswertung, vier Ordner-Cluster über zehn Wochen | 0/4 |

---

## 7. DIE LEHREN DES TAGES

**(a) Mein Korpus war zu schmal — und die Ursache ist dokumentiert.** Am **18.07.** lief eine
„Voll-Konsolidierung docs/": 325 Dokumente aus `backups/` und `docs/sessions` in sechs
Kategorie-Ordner. Deshalb beginnt die Git-Historie von `docs/plaene/` erst am 18.07., obwohl
die Dateinamen bis 02.07. zurückreichen. **Heute hat `docs/` neunzehn Ordner.** Die
Konsolidierung ist selbst wieder zerlaufen — ein Zielbild ohne durchsetzende Wache hält nicht.

**(b) Eine Kostenaussage ohne Bestandsmessung ist ein Stellvertreter.** Ich hatte
„Flotten-Neubau" als Kostenargument geführt, ohne je zu fragen, wie viele Binaries existieren.
**Neue Prüffrage:** vor jedem *„das invalidiert X"* — **wie viele X existieren heute?**

**(c) Zwei grüne Einzelbauten plus ein sauberer Merge ergeben keinen grünen Gesamtbau.** Die
Sammellandung hatte eine ungedeckte Wechselwirkung (#85); die CI hat sie entlastet, nicht meine
Lande-Kette — die war als **Gate**-Kette geschnitten, nicht als Bau-Kette. Diesmal gutgegangen;
das ist Zufall, kein Werkzeug.

**(d) Ein rückwärts zeigender Gitlink kostet 88 Commits.** In `wt-super-d3naht` stand der
ce-Zeiger auf einem Stand vom 09.08. Im Diff steht nur eine Zeile mit einem Hash.

**(e) Der Format-Nachzug war dreimal in Folge nötig.** Damit ist #83 kein Einzelfall mehr,
sondern ein Muster: Solange die CI-Formel nur von Hand nachgebaut werden kann, fährt jedes
Paket blind auf dieses Gate zu.

---

## 8. WAS ALS NÄCHSTES PASSIERT

1. **Stempel-Explores zurück** → Stufe 2: Lead liest jede tragende Referenz selbst nach
2. **Designplan** (Fable 5 max) → **Vorlage an den Owner**, getrennt nach Thema A und B
3. **Restlandungs-Review zurück** → die fünf Pakete sequentiell landen, ce vor super
4. **Konsolidierungs-Explore** (#88) → zweiter Vorschlag, Code und Doku getrennt
5. **Nach grüner ce-Pipeline:** Gitlink-Bump in super, dann main-FF beider Repos

---

## 9. OFFENE OWNER-FRAGEN

Keine blockierende. Die MESS-Positions-Frage ist mit Festlegung (4) beantwortet: Die Stufigkeit
gibt die Ordnung vor, das Lager ist die einzige Ausnahme.

Was **nach** dem Designplan zur Entscheidung ansteht, ist dort benannt — nicht hier, damit die
Frage mit ihrer Begründung und einer Empfehlung zusammensteht statt als Liste ohne Kontext.

---

*Erhoben am 11.08.2026. Jede Zahl dieses Dokuments ist am Objekt gemessen oder trägt ihre
Quelle. Wo eine frühere Aussage von mir widerlegt wurde, steht die Widerlegung dabei — der
Bestand an Irrtümern ist selbst ein Datum.*
