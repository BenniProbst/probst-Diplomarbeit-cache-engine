Basis aller eigenen Messungen: ce `/home/comdare/wt-ce-warn-libs` und super `/home/comdare/wt-super-landung`, beide HEAD `670483c084293c2fa7f6fb7c72dcc3a8192e0b48`, gemessen 11.08. mit `/usr/bin/find` + `/usr/bin/grep`. Was ich nicht selbst gemessen habe, ist als **aus Bericht, nicht nachgemessen** gekennzeichnet.

---

# TEIL 1 — F-1: DIE NEUE EXAKTE FASSUNG

**Primärquelle:** `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl`, **Zeile 43026** (`type=user`), **2026-08-11T21:24:47.577Z**. Dieselbe Eingabe liegt abgeschnitten als Vorerfassung auf Zeile 43019 (21:15:54Z) — die vollständige Fassung ist 43026. *(Zeilen-/Offsetangaben aus Bericht, nicht nachgemessen — ich habe die JSONL nicht selbst gelesen.)*

**Wörtlich, F-2 (der tragende Satz):**

> „Weil Hybrid und Tier unabhängig voneinander sind, sind es 2 paralele DREIPHASIG Verträge über die Mess-Achse des Planers, sodass konzeptionell die Beschaffenheit von Hybrid und Tier unabhängig voneinander permutiert werden können, ihre steuerung wird jeweils nur durch die CEB durchgesetzt […] Daher: Echte vier Parteien Kette mit theoretisch weiterhin DREIPHASIGEN Kern, weil die dritte Phase für Hybrid UND Tier beide durch die CEB gesteuert werden, wie zuvor auch direkt nur mit Tier. Konzeptionell hat die CEB hier 2 dritte Phasen, die sie als Kopf steuert, in der Anordnung des Ortes allerdings 4 Phasen sind."

**Zweiter tragender Satz (Grammatik-Zahl):** „eine vereinfachte/ausgelegte Grammatik […] für die DREIPHASIGE Messachse und eine zweite Grammatik für die ZWEIPHASIGE System-Achse und Organ-Achse […] **Neu schlägt grundsätzlich alte Aussage.**"

**Die Fassung als Tabelle** (Ledger KON13-01, gestützt auf Owner-Zitat 17:41:20Z):

| Achse | Kette | ohne Hybrid | mit Hybrid |
|---|---|---|---|
| MESS | Planer → CEB → [Hybrid →] Tier | 3 | 4 |
| SYSTEM | CEB → Tier ‖ CEB → Hybrid (**parallel, gleichrangig**) | 2 | 2 |
| ORGAN | CEB → Tier | 2 | 2 |

Grammatiken: **zwei**, nicht drei — G-1 dreiphasig (Mess, Entwurf offen), G-2 zweiphasig (System **und** Organ gemeinsam, Syntax existiert, Semantik fehlt).

**Was sie überholt:**
1. **05.08. mittag-9/-10/-11** (Mess 3 / System 2 / Organ 2, „System exakt wie Mess dehnbar stufig", abgenommen mit „Volles go") — die Dehnungs-Lesart fällt.
2. **KON7-03** (11.08. spätabends): „Durch den Hybrid dehnen sich die Ketten auf 4/3/2" — die 3 für System ist gestrichen (die 3 ist Mess ohne Hybrid).
3. **KON9-04** (11.08. nachts): Drei-Grammatiken-Zuordnung „System/Organ MIT Hybrid = dreiphasig" — durch KON13-05/B-1 ausdrücklich **gestrichen**; das Owner-Wort hatte dort nur die Stückzahl gedeckt, nie die Achsen-Zuordnung.
4. Die serielle Klammernotation `[Hybrid(CT)]` als Zwischenglied der System-Kette (05./06.08.) — Tier und Hybrid sind **gleichauf** (KON8-02).

**Zwischenfassungen — ja, sechs, in dieser Reihenfolge:** 05.08. mittag-9 (Doktrin gesetzt) → mittag-10 (Präzisierung) → mittag-11 (Abnahme) → 06.08. Klärungsdokument (führt STUFE vs. PHASE ein) → 11.08. KON7-03 (4/3/2) → KON8-01/-02/-12 (Vertrag nur Mess; Tier ‖ Hybrid) → KON9-04 (falsche Zuordnung) → KON13 (Endfassung).

**Die Frage ist damit beantwortet.** Drei Vorbehalte, die ich nicht glätte:
- Es gibt **keine** Einzel-Abnahme der KON13-Tabelle als Gesamtpaket, die der mittag-11-Formel („Volles go") gleichwertig wäre — ihre Legitimation ist mittelbar (F-2-Antwort + Konsistenz-Review).
- Der Ledger-Blockquote KON13-02 ist **inhaltlich treu, nicht zeichengleich**: „paralele"→„parallele", Satzende geglättet, beides ohne `[…]`.
- Die im Material als bestätigt geführte Formel **„'System zweistufig dehnbar' im Wortlaut" ist kein Owner-Wortlaut** — der Owner sagte „dehnbar stufig", ohne Zahl; „ZWEISTUFIG DEHNBAR" steht nur in redaktionellen Konsolidierungs-Synthesen (aus Bericht: 3 Fundstellen, alle Agenten-Prosa; der exakte String „System zweistufig dehnbar" hat 0 Treffer im Ledger).

Nebenbefund: **O-2** („wirkt der Hybrid-Einschub auf Organ?") ist durch KON13-01 beantwortet — Organ 2/2, hybrid-unberührt. Er gehört nicht mehr in die offene Liste.

---

# TEIL 2 — C-4: WAS ZU TRENNEN UND ZU VERDRAHTEN IST

Owner: „C-4 ist eine üble Bilanz weil wir das **trennen und verdrahten** müssen, damit die Achseninterfaces überhaupt wie geplant laufen."

## Die Grundgesamtheiten (alle heute selbst gemessen)

| Menge | Zahl | Definition |
|---|---|---|
| Header, deren **Pfad** „axes" enthält | **371** | die Zahl aus KON13-07 — reproduziert |
| davon im Verzeichnis `libs/cache_engine/axes/` | **345** | |
| Rest | **26** | 22× `topics/**/axis_*_subaxes_*.hpp`, `builder/codegen/all_axes_umbrella.hpp`, `target_isa_sub_axes.hpp`, `operating_system_sub_axes.hpp`, `profile_facade/system_axes_entscheidung.hpp` |
| davon mit `algo_version` | **130 von 371** | reproduziert |
| **alle** Produktionsdateien mit `algo_version` (ohne `build/`, ohne `tests/`) | **164 von 1906** | |
| davon **außerhalb** jeder axes-Pfaddefinition | **34** | **22** Queuing-Varianten unter `topics/queuing/`, 12 Infrastruktur/Werkzeug |
| **echte Varianten-/Basis-Header** | **152** = 130 + 22 | die belastbare Grundgesamtheit |
| echte Literale darin | **123** | 97× `1.0.0.c`, 24× `1.0.2.c`, 2× `1.0.1.c` |
| davon mit Hardware-Anteil (x512/x256/x128/m64/gfni) | **0 von 123** | |

Das 124. Vorkommen (`"1.0.0"` ohne Flag) steht in einem **Kommentar** in `axis_06_allocator_strategy_base.hpp:115` (Mock-Literal) — kein Variantenwert.

## Die Wache

`tools/axis_version_lock/axis_version.lock`: **9 Zeilen = 3 Kommentar + 6 Datenzeilen**, also **6 Einträge**, alle unter `libs/cache_engine/heuristik/`. Marker `AXIS_ALGO_VERSION`: **8 grep-Treffer = 6 echte Träger** + das Werkzeug `axis_version_lock.cpp` + eine Prosa-Erwähnung in `csv_cell_reader.hpp:16`. CI: `contract:axis-version-lock`, `.gitlab-ci.yml:768-786`, hartes Gate.

**Damit ist die im Ledger als „nicht aufgeklärt" geführte Differenz aufgelöst:** KON12-02 nennt „7 Marker-Dateien" und „9 Lock-Einträge". Beide Zahlen sind falsch gezählt — 7 zählt Werkzeug oder Prosa mit, 9 zählt die 3 Kommentarzeilen mit. Real: **6 gegen 6, kein Rest.**

## Schnittmenge — beide Lesarten, ein Ergebnis

- Lesart A (**Pfad** enthält „axes", n=371): **0** der 371 Dateien liegen unter `heuristik/` → Schnittmenge **leer**.
- Lesart B (**Dateiname** enthält „axis", n=625): trifft `heuristik/axis_optimization_catalog.hpp` und `heuristik/axis_spline.hpp` → Schnittmenge **2**.
- Substanziell entscheidet das nichts: beide Dateien tragen **0×** `algo_version`. Die einzige Datei in beiden Vokabularen ist `heuristik/break_even.hpp`, und dort ist `algo_version` eine **Kommentarzeile** („algo_version 1 -> 2"), kein Member.

**Ergebnis: die Wache deckt 0 von 152 bump-pflichtigen Varianten-Headern.** Die im Material als widerlegt geführte „leere Schnittmenge" war nicht falsch, sondern definitionsabhängig — der Widerspruch entsteht durch zwei ungleiche Nenner, nicht durch eine Fehlmessung.

## Defekt vs. bewusste Trennung

**Bewusste Trennung (kein Defekt):** `heuristik/` ist laut Owner (05.08.) eine **eigene Kettenstufe L5**, potenziell eigene Binary zwischen CEB und Tier — kein Organ-Achsen-Slot. Eine eigene Governance dort ist sachlich berechtigt. Der Gründungsplan (18.07.) erwähnt „heuristik" **0-mal** (aus Bericht) — die Verdrahtung dorthin war nie Planvorgabe, sondern Gelegenheit.

**Kein Defekt (Korrektur des Vorbefunds):** Die vom Gründungsplan geforderte Compile-Zeit-Pflicht **ist gebaut** — `static_assert(requires { Derived::algo_version; }, "…Bauplan §2…")` steht in **18 Basis-Headern** (16 unter `axes/**/*_strategy_base.hpp` bzw. `*_base.hpp`, 2 unter `topics/queuing/`); insgesamt 20 Dateien tragen `Derived::algo_version`. Die Aussage „nie gebaut" beruhte auf einer Messung, die nur die **62 `concepts/`-Header** durchsuchte (dort tatsächlich 0 von 62) — der Zwang liegt in den Basisklassen, nicht im `concepts/`-Ordner.

**Echte Defekte:**
1. **Digest-Tripwire ohne Gegenstand** — 6 gewachte Dateien, 0 von 152 Varianten.
2. **Hardware-Anteil leer** — 0 von 123 Literalen; Grammatik und Katalog tragen die Syntax bereits.
3. **Pfad-Bruch Queuing** — 22 Varianten mit `algo_version` liegen außerhalb jeder axes-Pfaddefinition; jede Zählung über „axes" übersieht sie systematisch.
4. **Zwei Vokabulare** — `AXIS_ALGO_VERSION:` (roher Byte-Substring, Werkzeug) gegen `algo_version` (C++-Member, Concept-erzwungen). Sie sind disjunkt und keiner kennt den anderen.
5. **Historischer CI-Defekt, geheilt** — ein doppelter YAML-Schlüssel machte das Gate einmal faktisch wirkungslos (`.gitlab-ci.yml:819`, `:1049-1050`).

**Zu verdrahten:** (a) Lock-Scope von 6 heuristik-Dateien auf die 152 Varianten-Header, **oder** zweite Wache daneben (offen, siehe TEIL 6); (b) den `Derived::algo_version`-Zwang der 18 Basen mit dem Digest-Tripwire koppeln — heute wissen beide nichts voneinander; (c) Queuing entweder nach `axes/` ziehen oder die Wache pfadunabhängig über den Concept-Zwang definieren.

**Drei Falsch-Null-Fallen, alle in diesem Schnitt real aufgetreten:** Definition der Grundgesamtheit (371 vs. 345 vs. 625), **Case** (`*_VERSION` groß = 0 von 130, klein = 130 von 130), **Zeilenumbruch** (`algo_version = ` strikt = 104, `algo_version *=` = 115; die 11 Differenzdateien sind `*_observable.hpp` mit umbrochener Zuweisung).

---

# TEIL 3 — C-1: DIE ELF POSITIONEN

| Kategorie | Zahl | Positionen |
|---|---|---|
| **1 — echter Produktionsaufrufer** | **5 von 11** | ExperimentPlanDirector (4 Produktions-, 1 Testdatei) · axis_version_lock (CI-Job `:768-786`) · catalog_codegen.cmake (`cmake/catalog_codegen.cmake`, Werkzeug `comdare_catalog_codegen_cli`) · IResourceControllableTier (10 Produktionsdateien, 11 Test) · ram_probe_chain (`hardware_probe_factory.hpp:433` ruft real) |
| **2 — Aufrufstelle aktiv, Inhalt stets leer** | **1 von 11** | run_selection_filter_chain (2 Produktions-, 1 Testdatei; stets Default `{}`; ResumeFilter 1 Produktions-, 1 Testdatei, 0 Installationen) |
| **3 — nur Test, 0 Produktionsaufrufer** | **5 von 11** | i_command.hpp · v32_messreihe_antrieb.hpp · hybrid/ (4 Header, 943 Z.) · AxisCommand · **LagerBaumWriter** |
| **4 — 0 Aufrufer überhaupt** | **0 von 11** | — leer |

**Korrektur gegen den Ledger:** LagerBaumWriter wurde zweifach (KON11-01, KON12-03) als „0 Aufrufer überhaupt, auch kein Test" geführt. Eigene Messung: der Klassenname erscheint in 3 Produktionsdateien (1 Definition, 2 reine Kommentarverweise in `tools/mess_report/`) und 0-mal in `tests/` — **aber** die Factory-Funktionen `make_binaries_baum_writer`/`make_messdaten_baum_writer` werden **9-mal in `tests/unit/test_lb0_lager_pfad_grammatik.cpp`** gerufen. Der Ledger hat über den Klassennamen gesucht, nicht über die Factory. Kategorie 4 ist damit leer; Kategorie 3 wächst auf 5.

**Zwei Gates, die nicht bloß „aus" sind, sondern strukturell unerreichbar:**
- `COMDARE_V32_ENABLE` wird **nirgends** per `#ifdef/#if` abgefragt — die Option ist real OFF, wirkt aber auf keinen kompilierten Code; wirksam ist allein `COMDARE_BUILD_TESTS` (Default **ON**).
- `COMDARE_MEASUREMENT_ON` erreicht das Target `messung_driver` durch **keinen** existierenden Pfad; in der echten ninja-Regel für `main.cpp.o` fehlt das Makro (aus Bericht: `build/build.ninja:37806`). Die Formulierung „die einzige Quelle des Makros" hält nicht — es gibt mindestens drei weitere Quellorte, keiner davon erreicht das Target.

Owner-Rahmen: „wir müssen unverdrahtetes konsolidieren und archivieren und final in der Zielform aktivieren" — 6 von 11 (Kategorien 2+3) sind **Verdrahtungs-**, keine Bauaufträge.

---

# TEIL 4 — DIE BAU-TEILE

| Teil | Zustand | Zahl |
|---|---|---|
| **S-1** Stempel-Basisklasse | **nur geplant** | 5 lose Strukturen, 4 Namensschemata, 0 Basis/CRTP (2 `struct/class Stamp`-Treffer, beide bekannt) |
| **S-2** Grammatiken | **teilgebaut** | G-2-Syntax existiert (`algo_semver.hpp`, 1535 Z.: 54 constexpr / 4 consteval / 294 static_assert / 0 virtual — bestätigt, KON9-05s „295" ist die zweite Zählweise); G-1 (Mess) **fehlt ganz**; daneben 2 fremde Grammatiken (`bvset_teilmenge.hpp` 187 Z., Testat-Renderer ohne Parser) |
| **S-3** Ordnungsrelation + Voraussetzungs-Wache | **nur geplant** | 0 Treffer `teilmenge\|dominiert\|ist_hoeher` in `algo_semver.hpp`; der Code benennt die Lücke selbst und blockiert auf O-3 |
| **S-5** Stempel-Factory/Composite | **nur geplant** | 0 Treffer (5 scheinbare = `stamp_format`); nur `compose_organ_stamp_line()` existiert, für System und Mess **keine** Kompositionsfunktion |
| **S-6** Preimage-Ordnung | **gebaut, falsch herum** | Feldreihenfolge `organ_line`(203) → `system_line`(205) → `measurement_line`(213); zweite Stelle `anatomy_fingerprint_glieder(organ, system, measurement)` — Soll ist MESS→SYSTEM→ORGAN |
| **S-7** Hardware-Anteil | **gebaut+leer** | 0 von 123 Literalen |
| **S-9** CebSystemAxisDrive | **nur geplant** | 0/0 Treffer; Namensvetter `CebSystemAxis<Derived>` (9 Achsen) ist ein **anderes** Konzept |
| **S-11** COMDARE_MEASUREMENT_COMBO | **gebaut+gerufen (interim)** | `-D…_CT` an 4 CEB-Emissionsstellen; Restlücke: Default-/[all]-Pfad liest weiter `std::getenv` (aus Bericht) |
| **S-12** CI-Gerüst je Träger | **nur geplant** | super 2768 Z. / 39 `stage:`-Zeilen, ce 1056 Z. / 19 (aus Bericht); **0× „hybrid"** in beiden; 0 von 4 Trägern |
| **S-13** Buildsystem-Cache | **nur geplant** | `comdare-buildsystem` 0 Treffer in ce **und** super |
| **S-14** axis_version_lock ausrollen | **gebaut+gerufen, Scope 6** | 6 von 152 (siehe TEIL 2) |
| **S-15** Hybrid-Fläche | **gebaut+unverdrahtet** | 4 Header, **943 Z.** (189+256+246+252); 0 Produktions-Includes; Stempel-Bezug nur als Kommentar |
| **S-16** Shell-Proben | **gebaut+gerufen** | **14 Dateien / 8528 Z.**, 0 von 14 retired (Task #89s „13 / 7967" ist überholt) |
| **S-17** LagerBaumWriter | **gebaut+unverdrahtet** | 0 Produktions-, 9 Test-Aufrufe |
| **S-4 / S-8 / S-10** | **kein Befund** | im gesamten Material nicht vorhanden — nicht gemessen |

**Billiger als angenommen:** S-14 (Wache läuft, hartes CI-Gate, Zahlenrätsel 7/9 aufgelöst — reines Ausrollen); C-4-Zwangsebene (18 Basen existieren bereits, nur nicht mit dem Tripwire gekoppelt); S-11 (Interim seit 05.08. geschlossen, nur der Default-Pfad bleibt); S-15 (943 Z. Fundament stehen, nur Reroute/Pruefdock/Tier-Modul fehlen); S-6 (Umstellung ist heute kostenlos — es wurde nie eine Flotte gebaut).

**Teurer als angenommen:** S-2 (**zwei** Grammatiken, G-1 komplett unentworfen — nicht „eine, uniform"); S-3 (blockiert auf einer unbeantworteten Owner-Frage, nicht auf Bauzeit); S-5 (kein Muster vorhanden, nicht bloß unvollständig — System und Mess haben gar keine Komposition); S-12 (fünf offene Owner-Fragen, 0 Quelle); S-13 (drei Orte statt einem Schalter, siehe TEIL 5); S-16 (+1 Datei, +561 Zeilen gegen die Task-Zahl, und 2 „abgelöste" Proben laufen weiter).

---

# TEIL 5 — DIE CACHE-LANDSCHAFT

Owner (KON13-04): drei Orte, je zwei Backends (MinIO S3 **und** Filesystem), **alle drei per XML separat konfigurierbar** — „das ist die tragende Anforderung".

**(1) CCACHE** — generische Tools+Compiler, hot zum Job. **Gebaut: zu 100 % Runner-Infra.** `.gitlab-ci.yml:55` mappt den `cache:`-Block auf `minio.comdare.de:9000/buildsystem-cache`, `key: "ccache-$CI_PROJECT_NAME"`. CE-Code berührt ccache nur beim **Emittieren** der Kind-Pipeline-YAML: `emit_child_ccache_config` (`experiment_plan_director.hpp:786-800`) und der `CCACHE_DIR`-Export in `emit_child_submodule_prolog` (:826-838) — beides reine String-Literale. **Fehlt:** das zweite Backend (Filesystem) und jede XML-Anbindung.

**(2) BUILDSYSTEM-CACHE** — Projekt-Binaries + Messungen. **Gebaut: der Transport.** `ArtifactCache` wird produktiv ausschließlich über `from_env()` konstruiert (33 Vorkommen von `ArtifactCache::from_env` über libs+apps+tests), liest zwei Endpunkte: `COMDARE_MINIO_ENDPOINT/_BUCKET/_PREFIX` (Binaries) und `COMDARE_MEASUREMENT_DROP_URL` (HTTPS-PUT, Messungen). In Tests gibt es zusätzlich den öffentlichen Default-Ctor (5 Stellen, aus Bericht) — „ausschließlich from_env" hält nicht. **Gebaut, aber tot:** `lager_ziel_strategie.hpp` („DUAL-ccache-Konfigurationsnaht") kennt genau **einen** Zwei-Wege-Schalter (minio ↔ NAS-Filesystem) für genau **zwei** Genus-Typen; Konsumenten: **2 Dateien** = die eigene plus die eigene Testdatei, **0 Produktionsaufrufer**. `comdare-buildsystem`: **0 Treffer** in ce und super.

**(3) CACHE-ENGINE-EXPERIMENT** — nur finale Zusammenfassung, LaTeX, PDF plus explizit XML-angeforderte Einzelnachweise. **Gebaut:** der Schreibweg als HTTPS-PUT über den V80-Filterpod. **Fehlt:** die Regel, welches Artefakt hierher und welches ins Lager gehört — KON13-04 fordert sie ausdrücklich und definiert sie nicht.

**XML-Konfigurierbarkeit — der Bestand ist ein einziges inertes Element.** `<output><storage backend="local|minio" endpoint=".."/>`: im XSD als **INERT** deklariert (`experiment_schema.xsd:664`, Element `:673`), an mindestens fünf Stellen so kommentiert (nicht drei). Es wird geparst und validiert (Enum-Check, `minio`-ohne-endpoint → Warnung, `s3` → Fehlertest), aber `storage_backend|storage_endpoint` erscheint in **3 Dateien** (`validate_profile.hpp` 4 Treffer, `xml_config_parser.hpp/.cpp` je 2) und **0-mal** in `artifact_cache.hpp` oder `profile_run_facade.*`. Genutzt wird das Element von **1 von 160** XML-Dateien im ce-Repo — einer Golden-Testfixture (Nenner aus Bericht, nicht nachgemessen).

**Was für die Doppel-Backend-Fähigkeit fehlt:** ein Konsument für `lager_ziel_strategie` (heute 0), ein Filesystem-Backend für Ort (1), ein zweiter Weg neben HTTPS-PUT für Ort (3), und ein Schema-Konstrukt, das drei Ziele × zwei Backends trägt statt eines `backend`-Enums mit zwei Werten.

**Vier Widersprüche, ungeglättet:**
- **W-28** ist nicht formal geschlossen: 18.07.-Plan setzt Ebene C auf prod-longhorn 6 TB (V91) mit POSIX-`copy`, 23./26.07. und KON13-04 auf PR4100 (V20); der real gebaute Weg ist HTTPS-PUT, also keiner von beiden Plänen wörtlich.
- **Mount vs. Filterpod:** 12.07. „Runner dürfen Cluster_NFS NIE lesen, kein Mount"; 11.08. „in einen eigenen Mount isoliert zum Testen". Geltungsbereich (Test/Produktion) ungeklärt.
- **Vokabular:** Owner sagt „S3"/„Filesystem", XSD sagt `{local,minio}` und prüft `s3` als **Fehler**; `lager_ziel_strategie.hpp:17-21` verbietet jede rohe S3-URL im Endpoint-Feld (mc-Alias-Pflicht), während das XSD-Attribut „endpoint" heißt.
- **Epochendatierung:** die Behauptung, „Buildsystem-Cache" im Lager-Sinn entstehe erst am 11.08., hält nicht — der Ledger führt sie am **09.08. (spät)** bereits so, unter Berufung auf einen älteren Plan. Neu ist am 11.08. die Drei-Orte-Auflösung, die Groß/Kleinschreibungs-Konvention und der isolierte Mount, nicht die Bedeutung.

Stand des Bauens: in den jüngsten Commits an `bestandslog/` und `artifact_transport/` findet sich **kein** Commit, der eine Drei-Orte-Struktur baut; `COMDARE_BUILDSYSTEM|BUILDSYSTEM_CACHE|COMDARE_CACHE_ROOT` = 0 Treffer. KON13-04 ist Entscheidung, nicht Umsetzung. Laut KON13-08 sind **3 von 17** Bau-Teilen (P-0, S-14, S-17) je gegen den Objektstand gemessen worden; S-13 gehört zu den 14 ungemessenen.

---

# TEIL 6 — DIE FRAGEN, DIE BLEIBEN

1. **O-3 — Voraussetzungs-Semantik:** Fordert `x512{vl}` das Flag `f`, oder impliziert es es? *Fordern* → S-3 wird eine ablehnende Wache mit Fehlermeldung; *implizieren* → S-3 wird ein Normalisierer, der ergänzt. Schaltet S-3 komplett frei (heute gehen `1.0.0.c.x512` und `…x512{vl}` unbeanstandet durch).
2. **O-6 — Mini-Pipeline-Form:** Child-Pipeline oder Job-Gruppe? *Child* → eigener Trigger je Träger, kostet Nesting-Budget; *Job-Gruppe* → bleibt in der Elternpipeline, kein Budget. Schaltet die Topologie von S-12 frei.
3. **O-7 — statisch eingecheckt oder vom Planer emittiert:** *Statisch* → 4 gepflegte YAML-Dateien; *emittiert* → `CiYamlBuilder` wird Produktionscode. Schaltet S-12s Bauform frei; keine Owner-Quelle im gesamten Korpus (gegengeprüft über 565 `CiYamlBuilder`-Fundstellen in 19 JSONL).
4. **O-8 — Hybrid bei ausgeschöpftem Nesting-Budget 2:** Sitzt er auf Ebene der CEB oder unter ihr? *Gleiche Ebene* → passt ins Budget, verliert Isolation; *darunter* → sprengt das Budget. Schaltet die Hybrid-Hälfte von S-12 frei.
5. **O-10 — je Träger-Typ oder je Instanz:** *Typ* → 4 Pipelines; *Instanz* → so viele wie Permutationen. Schaltet die Zahl der Mini-Pipelines frei; die kursierende Empfehlung „je Typ" stammt nachweislich vom Assistant (3 Fundstellen, alle `type=assistant`), nicht vom Owner.
6. **O-11 — „eigene Bedürfnisse" je Träger:** Meint das eigene Stages oder nur eigene Variablen? *Stages* → 4× Stage-Topologie; *Variablen* → ein Template mit Matrix. Schaltet den Umfang von S-12 frei.
7. **Artefakt-Regel (KON13-04 fordert, definiert nicht):** Was macht ein Mess-Artefakt „individuell in der XML angefordert"? *Explizites Element* → Schema wächst um ein Anforderungs-Konstrukt; *Konvention über Genus* → Schema bleibt, die Regel wandert in den Code. Schaltet die Trennung von Ort (2) und Ort (3) frei.
8. **Dritter Genus-Wert:** Bekommt „generische Tools/Compiler" einen eigenen Genus neben `{binary, measurement}`? *Ja* → ccache fällt unter dieselbe Lager-Ziel-Strategie; *nein* → ccache bleibt reine Runner-Infra ohne XML. Schaltet S-13s Schnittlinie frei.
9. **Vokabular der neuen XML:** Owner-Sprache `S3`/`Filesystem` oder Code-Sprache `minio`/`local` mit mc-Alias-Pflicht? *Owner-Sprache* → bestehender Enum und der `s3`-Fehlertest brechen; *Code-Sprache* → das Owner-Wort wird übersetzt. Schaltet den Schema-Entwurf frei.
10. **Schema-Konstrukt:** Den inerten `<storage>`-Slot erweitern oder drei benannte `<cache_target>`-Blöcke neu bauen? *Erweitern* → 1 von 160 XML muss nachziehen; *neu* → der Section-59-C-Slot wird deprecated. Schaltet den XSD-Bau frei.
11. **Mount oder Filterpod in Produktion:** Ersetzt „Comdare Buildsystem" den HTTPS-PUT-Weg oder läuft er nur zum Testen parallel? *Ersetzt* → `ArtifactCache` bekommt einen POSIX-Pfad; *parallel* → der PUT-Weg bleibt Produktion. Schaltet das zweite Backend für Ort (2)/(3) frei.
12. **W-28 formal:** Ist der Widerspruch prod-longhorn V91 ↔ PR4100 V20 durch KON13-04 geschlossen? *Ja* → V91 verfällt; *nein* → zwei Speicher bleiben im Register. Schaltet die Ablage der Mess-Ergebnisse frei.
13. **Lock-Scope:** Die heuristik-Wache um die 152 erweitern oder eine zweite Wache daneben bauen? *Erweitern* → ein Werkzeug, ein Lockfile, gemischte Vokabeln; *zweite* → zwei Werkzeuge, saubere Trennung entlang der L5-Grenze. Schaltet S-14 frei (Owner-Wort „trennen **und** verdrahten" deckt beides).
14. **GN-8-Rest-Priorität:** „niedrig" oder „TEIL, hoch"? Der Ledger führt beides. *Niedrig* → nach F1; *hoch* → vor F2. Schaltet die Einordnung von S-14 in die Postenliste frei.
15. **Kategorie-Grenze in C-1:** Zählt „aufgerufen, Inhalt stets leer" als aktiv genutzt? *Ja* → Kategorie 1 = 6 von 11; *nein* → bleibt 5 von 11. Ändert die Endsumme der C-1-Antwort.
16. **STUFE/PHASE:** Ist die ab KON7 durchgängige „phasig"-Sprache eine bewusste Owner-Umbenennung der 06.08.-Vokabel „Stufe" oder ein Rückfall in genau die Kollision, vor der das 06.08.-Dokument warnt? *Umbenennung* → das Klärungsdokument wird deprecated; *Rückfall* → die Doppelvokabel muss vor F1 aufgelöst werden. Schaltet die Doku-Landung von KON13 frei.
17. **K7b/K8 post-Abgabe:** Fällt S-13 damit hinter die Abgabe, oder ist es dem gegenüber vorgezogen? *Hinter* → der inerte Slot bleibt inert; *vorgezogen* → der XSD-Kommentar ist zu korrigieren. Schaltet die Terminierung von S-13 frei.