# HAUPTSTRANG -- ERGEBNIS DES 32-AGENTEN-WORKFLOWS

> **Run:** `wf_5834b706-7b5` - 32 Agenten, 32 fertig, **0 Fehler** - 918 Werkzeugaufrufe, 3447846 Token
> **Gelaufen:** 10.08.2026, in zwei Anlaeufen (der erste starb am Session-Limit, der zweite lief per Resume aus dem Cache weiter)
> **Auftrag:** alle offenen Fragen des Hauptstrangs - 10-Wochen-Explore, Design (Fable max), Bau (Opus max), Verify (Fable xhigh), Codex-Dualreview

**Dies ist die woertliche Synthese des Workflows.** Sie ist Beweismaterial, kein Beweis (Goal v8 V1) - die Zahlen darin sind vom Synthese-Agenten selbst gemessen, nicht aus der Ernte uebernommen; wo ich sie nachgeprueft habe, steht es im Sessions-Dokument.

**Bilanz:** 10 Explores - 3 Entwuerfe - 6 Bau-Pakete.

---

**MESSORT DIESES BERICHTS.** Alle Zahlen unten habe ich selbst gemessen, nicht aus der Ernte übernommen — die Ernte wurde teilweise an einem veralteten Stand erhoben.

| Gegenstand | Pfad | SHA (gemessen 10.08., Ende des Workflows) |
|---|---|---|
| ce, lebender Stand | `origin/development` | **e114cabd** (nicht 95cb3039 — 2 Commits weiter: `f4dcc234` I-PMC-2 + Merge) |
| ce, Arbeitsverzeichnis | `/home/comdare/wt-ce-w0a` | **6c010cdc**, Branch `w0a/registrierung-sichtbarkeit` — **14 Commits hinter 95cb3039** |
| super | `/home/comdare/wt-super-landung` | **235c29ec** (Briefing nannte 912466a2; +2 Doku-Commits) |
| Platte | `/` | 251G, 227G belegt, **12G frei, 96 %** |

**Die erste Korrektur betrifft mein eigenes Briefing.** Es sagt „ce /home/comdare/wt-ce-w0a (= origin/development = 95cb3039)". Das war zu keinem Zeitpunkt dieses Workflows wahr: der Worktree steht auf einem eigenen Branch, 14 Commits dahinter. **Drei der fünf Bau-Stränge haben das unabhängig voneinander gemessen und gemeldet**, bevor sie gebaut haben — und deshalb ist keine einzige gelieferte Zeilennummer standortgebunden. Die Messort-Pflicht hat in diesem Workflow genau das getan, wofür sie da ist.

---

# 1. WAS IST GEBAUT

Fünf Pakete, fünf Commits, **null gepusht**. Vier Branches sind im ce-Modul sichtbar, einer liegt in einem separaten Klon.

| Paket | Branch / SHA | Basis | Inhalt | Deckender Test | Verify | Zweite Lens |
|---|---|---|---|---|---|---|
| **P1** Taxonomie (i)+(j) | `bau/p1-taxonomie-klasse-i` **3ea5e520** — nur in `/home/comdare/wt-ce-tax` | 95cb3039 | Zwei fehlende Versions-Klassen in `algo_semver.hpp` nachgetragen (Dock-Vertrags-Version, Toolchain-Achsen-Code-Version) + Riegel gegen künftige Lücken | `test_vs_taxonomie_klassen_grep.cpp`, 5 Fälle | **nicht landen** (2 falsche Zahlen im Commit, Suite unbewiesen) | **nachbessern** (Match-Regel ist Substring, nicht namentlich) |
| **P2** Warnstufe | `bau/p2-warnstufe-aufteilen` **237d0952** | 95cb3039 | `COMDARE_set_default_warnings` in Warnungen/Optimierung geteilt; Hausnorm auf libs 15/15, apps 9/9, tools 15/15 | `test_warnnorm_abdeckung.cpp` | **landen** mit Auflagen | **NICHT LANDEN** (3 Blocker) |
| **P3** CI clang-Pflicht | `bau/p3-ci-clang-pflicht` **708cf156** | 95cb3039 | `build:clang` bekommt `needs: [lint:secrets]` (skippt nicht mehr), D-1 vollzogen, 5 Invarianten als gtest | `test_ci_invarianten.cpp`, 12 Fälle | **nicht landen** (2 überlebende Mutanten) | **nachbessern** (2 Blocker) |
| **P4** D2-Gegenköder | `bau/p4-d2-partitions-koeder` **ee0375be** | 95cb3039 | Partitions-Rechnung wird unbedingt gedruckt; Gegenköder gegen den „melde immer"-Mutanten | `test_d2_abdeckungs_wache_nenner.cpp` +2 Fälle | **landen** mit 2 Auflagen | **landen nach 3 Nachbesserungen** |
| **P5** Tote Anker | `bau/p5-tote-anker` **9a15f9cc** | 95cb3039 | 6 tote Ledger-Zeilenverweise in 4 Dateien geheilt, Marken-Regel als Wache | `test_anker_marke_statt_ledgerzeile.cpp`, 4 Fälle | **nicht landen** (5 Punkte) | 2 Landungsblocker |

**Die klare Antwort auf die Frage: null von fünf Paketen sind in der gelieferten Form landefähig.** Jedes hat mindestens eine Lens gegen sich. P2 ist der schärfste Fall: die erste Lens sagt „landen", die zweite hat drei Blocker *gemessen* — darunter, dass die neue Wache auf dem Bauweg rot wird, den der Owner selbst als „das einzige auf Linux offizielle Verfahren" bezeichnet hat (`configure.sh`/`make check`, Unix Makefiles statt Ninja). Wo zwei Lenses sich widersprechen und eine davon einen Messbeleg vorlegt, gilt die messende.

**Was trotzdem echte Substanz ist.** Alle fünf Pakete haben beidseitige Köder mit `/dev/urandom`-Würfel; in vier von fünf Fällen hat der Bauende seinen eigenen Auftrag am Objekt widerlegt und damit einen Fehlbau verhindert:

- **P1**: der Auftrag nannte eine fehlende Klasse; es fehlten zwei — und die zweite (`kToolchainAxisVersions`) steht **im Fingerprint-Preimage**, die erste ist stempel-neutral. Beide unter einem Namen zu führen hätte genau den Unterschied getilgt, an dem ein Versions-Bump entschieden wird.
- **P2**: die ABI-Naht liegt nicht an der Einsetz-Stelle, sondern im Makro — eine Deklaration dort wirkt für 13 Übersetzungseinheiten statt für eine.
- **P3**: der Bauplan nennt einen Job `test:secrets`, den es in keinem der beiden Repos gibt (Gegenprobe: `^lint:secrets:` = 1 in ce, 1 in super).
- **P5**: der Ersatz-Anker, den der Auftrag vorgab, war **selbst tot** — und der Ledger hatte denselben Fehler bereits einmal gemacht: `KON2-15` korrigierte eine tote Zeilennummer auf eine zweite tote Zeilennummer. **Drei Zahlen für einen unveränderten Satz, die mittlere geschrieben von jemandem, der gerade eine tote Zahl reparierte.** Das ist der stärkste Einzelbefund des ganzen Workflows.

**Das Muster dahinter, und es ist unangenehm:** in fünf von fünf Fällen war der *Bauauftrag* am Objekt falsch, weil er aus Plänen und Ledger-Zitaten gebaut war, die selbst veraltet waren. Die Krankheit, die P5 heilen sollte, hat die Aufträge dieses Workflows befallen.

---

# 2. WAS DIE EXPLORES BEANTWORTET HABEN

Der Owner hat zu B-1, B-2 und B-3 gesagt, es sei geplant und zu finden. **In allen drei Fällen hatte er recht.** Das ist das Ergebnis, und es bestätigt den Kanon „alles ist geplant — eine unlösbare Frage ist meine Gedächtnislücke".

### B-1 — „Jede CEB hat genau EIN Prüfdock": **GEFUNDEN**

Fundstelle: Ledger, Eintrag 17.07.2026, „REKURSIVE Dock-Architektur, autoritativ". Wortlaut:

> „Ebene 2 CEB ↔ Tier-Binary: die CEB = selbst ABI-stabile .so, SYSTEM-ACHSEN-VERSIONIERT, **mit EIGENEM Prueff-Dock**, an dem sie C++23-ABI-stabile Tier-Binary-.so-Module kompiliert."

Dazu `docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md:528`: „Ein Prueff-Dock ist die CacheEngineBuilder-SEITE für genau EINE Gattung". Beide Aussagen sind widerspruchsfrei: die eine definiert den Dock-**Typ** je Gattung, das 10.08.-Wort die **Instanz**-Regel je CEB.

**Ist-Stand, gemessen an e114cabd:** die echte CEB trägt heute genau ein Dock — aber nur, weil `cache_engine_builder_iterator.hpp:57` genau einen Dock-Header einkompiliert und die anderen vier gar nicht erreichbar sind. Die Regel ist am Ist erfüllt, aber als Hartverdrahtung, nicht als Entwurf. Im `pruef_dock/`-Verzeichnis liegen **4 Gattungs-Docks** (`search_algorithm`, `set`, `sequence`, `adapter`, `view` = 5 Header, selbst gezählt); ein `graph_dock` existiert nirgends im Baum (0 Treffer, Gegenprobe: `set_dock.hpp` vorhanden).

**Der eine aktive Verstoß** liegt außerhalb der CEB: `apps/f15_compare/main.cpp:278` registriert alle fünf Docks, `:288` misst mit `measure_genus_sequential` gattungs-**quer** über ein Verzeichnis gemischter DLLs. Das ist wörtlich, was das 10.08.-Wort verbietet — und es war bis dahin *ausdrücklich erlaubt* (Doku 24 §8.8:548: „Optional: multiple Gattungen QUER gemessen (Config-gesteuert)"). Diese eine Bestandsaussage wird durch das 10.08.-Wort ersatzlos gestrichen.

**NICHT AUFFINDBAR:** die Regel hinter der Paarigkeits-Aussage („nur eine gerade Anzahl an Prüfdocks"). Drei belegbare Zählungen — 5 gebaut, 3 nach der 03.06.-Korrektur, n je Genus — keine ist gerade. **Gegenprobe:** derselbe flache Ledger findet „Pruefdock" 44×, „Prueff-Dock" 50×; das Thema ist massiv belegt, nur diese Regel nicht.

### B-2 — „Der Planer hat einen Fingerprint, über seine Version": **GEFUNDEN**

Fundstelle: `/home/comdare/wt-super-landung/docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md`, §3.1 (Z.303-360) und §3.4 (Z.418-435). Wortlaut aus §3.1:

> `enum class StampStage : std::uint32_t { planer = 0, ceb = 1, tier = 2, hybrid = 3 };` … `char const* fingerprint;  ///< 128-hex SHA-512` … `std::uint64_t fingerprint_len;  ///< immer 128`

Und das „einfach" hat seinen Ursprung: **§43.b, User-Direktive 19.07.2026**, Ledger:9538 — „Der Experiment-Planer trägt auch einen string_view-Stempel, aber nur über die eigene statische Versionierung und unter welcher ISA/OS er passt". Die Begründung steht in derselben Zeile: **„KEINE Achsen-Arrays (der Planer permutiert, er ist keine Permutation)."**

**Ist-Stand, von mir an e114cabd nachgemessen:**

| Bezeichner | Dateien |
|---|---|
| `ComdareVersionStampSnapshot` | **0** |
| `planner_version_stamp_pod` | **0** |
| `ComdareStampGlied` | **0** |
| `StampStage` | **0** |
| `hybrid_version_stamp` | **0** |
| *Gegenprobe* `kCebFingerprint` | 9 |
| *Gegenprobe* `anatomy_fingerprint_hex` | 18 |
| *Gegenprobe* `planner_version_stamp` | 6 |

Das gesamte geplante Versionierungs-Interface ist ungebaut. Der Planer trägt heute nur `planner@1.0.0.c isa=x86_64 os=linux` — und diese Zeile ist laut ihrem eigenen Kopfkommentar „golden-/binary_id-neutral", also folgenlos.

### B-3 — „SECHS CEB-Builds aus 3! Mess-Layer": **GEFUNDEN**, im Rohtranskript verbatim

Owner, 08.08.2026 09:25 (`5a19728e-….jsonl` L17190):

> „…muss die CEB einmal gebaut werden, dass sie aus Micro/Macro/combined-Load insgesamt **3 fakultät Permutationen** an eingebauten und ausgebauten Last-Messgeräten an CEBs erzeugt, weil sich so bei einem Lauf über die Gesamtzeit ohne eine der 3 Messeinrichtungen jeweils der eigentliche Wert **ohne Messfehler** bestimmen lässt… **Es gibt also 3 Stufen und 6 CEBS (nicht 5 das war mein Fehler).**"

Und 10:10 (L17245) die Begründung: „**Das ist wie in der Elektrotechnik, weil der Messfühler ein Verbraucher ist**… damit break even stimmt."

**Und es ist gebaut** — nicht nur geplant. Ich habe an e114cabd nachgemessen: `libs/cache_engine/mess/steuer_dock.hpp` trägt `static_assert(… anzahl == 6, "Owner 09.08.2026: 3 Fakultaet = 6 Steuerdocks — der NENNER steht im Code, nicht im Kommentar")`, mit Gegenproben für 2!, 1!, 0!. Die sechs Permutationen existieren als Typen und als sechs Steuerdocks am Planer.

**NICHT AUFFINDBAR:** die Multiplikation „6 je Gattung+Genus". **Gegenprobe auf dem flachgelegten Ledger** (2.725.390 Zeichen, gezählt mit `/usr/bin/grep -o -i -F | wc -l`): „6 CEB" = 21, „6 CEBs" = 19, „sechs CEB" = 3, „sechs CEBs" = 1 — **44 Treffer, die Suche greift.** Dagegen „6 CEBs je" = 0, „je Gattung+Genus" = 0, „36 CEB" = 0, „30 CEB" = 0. Alle 44 führen die 6 als *globale* Zahl. Die Gesamtzahl wurde nie gerechnet.

### Eine Korrektur an der Ernte, die ich selbst gemessen habe

Der B-3-Explore meldet als Bau-Blocker: „(D1) XML-Schema: `<measurement_tooling>`-Element (HAUPT, auffächernd) **FEHLT**". **Das ist am Objekt falsch.** Gemessen an e114cabd:

- `<measurement_tooling>` existiert als Element in **8 Profil-XMLs**; `SCHEMA.md:46` führt es als „die **Mess-Tooling-HAUPT-Achse** (die AUFFÄCHERUNGS-Achse des CEB-Typs `[a,b,c]`)".
- Der Parser liest es (`xml_config_parser.cpp/.hpp`), und `experiment_plan_director.hpp:2080/2084/2129/2133` ruft `measurement_combos_of(cats, tp.measurement_tooling)` mit dem Kommentar **„Fan-out-Verdrahtung ist aktiv"**.

Woher kam der Irrtum? Der Explore hat einen **Quellcode-Kommentar treu abgeschrieben, der sich selbst widerspricht**: dieselbe Datei enthält 1× den Satz „(D1) XML-Schema … FEHLT" und 2× „Fan-out-Verdrahtung ist aktiv" — identisch an 6c010cdc, 95cb3039 und e114cabd. Das ist dieselbe Klasse wie die toten Ledger-Anker aus P5, nur eine Ebene tiefer: eine veraltete Aussage, einbetoniert an der Stelle, an der sie am glaubwürdigsten aussieht.

**Was wirklich fehlt** (gemessen): von 11 Profil-XMLs deklarieren 8 genau **eine** Combo (`tools="wallclock macro micro"`, die Vollmenge) und 3 keine. **Kein einziges Profil fordert sechs.** Und der Gate-Zustand kann sie nicht liefern: G2 und G3 teilen `COMDARE_CE_ENABLE_STATISTICS` (662 Fundstellen in `libs`), also sind heute höchstens zwei Kompilate unterscheidbar.

---

# 3. DIE OWNER-VORLAGEN

Sieben Entscheide, die niemand außer dem Owner treffen kann. Sortiert nach Termindruck.

### V-1 — Reihenfolge der Messfühler: was bedeutet sie physisch? (D-3, offen seit 08.08.) **TERMINKRITISCH**

**Gegenstand.** Die 6 entstehen nur, weil {Wallclock, Makro, Mikro} eine *geordnete* Liste ist — eine ungeordnete Menge kann 6 nicht erzeugen (2³=8, nicht-leer 7). Der Code sagt das selbst und setzt es compile-hart durch. Was aber unterscheidet den Bau `[Wallclock,Makro,Mikro]` vom Bau `[Mikro,Makro,Wallclock]` *messtechnisch*?

**Die Trag-Annahme des Baus**, ausdrücklich als Vermutung markiert (`mess/konfiguration.hpp:40-44`): die **Schachtelungsordnung** — wessen EIN/AUS-Klammer wen umschließt, und damit, wessen Overhead in wessen Messwert fällt.

**Optionen.** (a) Schachtelung bestätigen. (b) Etwas anderes (z. B. Aktivierungsreihenfolge, Aufzeichnungsreihenfolge).

**Grundlage.** Gegenprobe gefahren: „Schachtelung" = 10 Treffer im flachen Ledger, „D-3" = 26, „Reihenfolge" = 184 — die Suche greift überall; „Schachtelungsordnung" = 0. Es existiert keine Owner-Aussage, die die physische Bedeutung setzt.

**Kosten.** Die Antwort ändert **eine Alias-Zeile** (`CebVersionen`, `steuer_dock.hpp:231`), kein Bauteil. Die Nicht-Antwort kostet mehr: **ohne sie ist die Differenz-Arithmetik der Kampagne nicht aufschreibbar** — „welche Differenz zweier Bauten ist der Overhead welchen Geräts?" bleibt unbeantwortbar, und genau dafür sind die 6 CEBs da. **Das blockiert die Auswertung der Messkampagne vom 29.08., nicht ihren Bau.**

**Empfehlung:** (a) bestätigen oder verwerfen — vor dem 21.08.

### V-2 — Wie viele CEBs sind zu bauen: 6, 30 oder 36? Und im Hybrid 24 oder 48? **TERMINKRITISCH**

**Gegenstand.** B-1 („eine CEB trägt genau ein Genus-Prüfdock") multipliziert die 3!-Achse mit der Zahl der Gattung+Genus-Paare. Gemessen an `anatomy_base.hpp`: Map/SearchAlgorithm (1) · Container/{Set, Sequence, Adapter, View} (4) · Graph (**0** — Stub, kein Genus, „Q5 nach Abgabe") · HeuristikAdapter/FunctionInterfaceReroute (1) = **6 realisierte Paare, davon 5 im Single-Zweig**.

| Rechnung | Zahl |
|---|---|
| Map/SearchAlgorithm allein | 1 × 6 = **6** |
| Single-Zweig, alle 5 Paare | 5 × 6 = **30** |
| mit Graph, sobald sein Genus steht | 6 × 6 = **36** |
| Hybrid | 4! = 24 **oder** 24 × 2 = 48 — nicht entschieden |

**Grundlage.** Der Satz vom 09.08. nennt „4 fakultät Rekombinationen gegen die 6 CEBs **und den einbau von Messfühlern in die Hybrid-Tier-Binary**" in einem Atemzug; ob die 24 diese Achse enthält oder mit ihr multipliziert, sagt der Wortlaut nicht. Der Ledger führt den Posten bereits als Vorlage („Das wird nicht geraten").

**Warum es jetzt entschieden werden muss.** Bei einer gemessenen Größenordnung von 41,4 h für 128 Binaries ist der Unterschied zwischen 30 und 36 CEBs, und zwischen 24 und 48 Hybrid-Rekombinationen, der Unterschied zwischen einer Kampagne, die in das Fenster vor dem 15.09. passt, und einer, die es nicht tut.

**Empfehlung:** Graph **aus** dem Nenner (er hat keinen Genus, ein CEB ohne Dock-Gegenstand ist leer) ⇒ **30**. Beim Hybrid keine Empfehlung — der Wortlaut trägt beide Lesarten gleich gut.

### V-3 — prod2: nur der Secrets-Job heraus, oder der Host ganz? **TERMINKRITISCH (Kampagne 29.08.)**

**Gegenstand.** Der Owner antwortete am 10.08. 12:40 wörtlich „**D-1: raus nehmen.**" Die Frage dazu existierte in zwei Fassungen: 07:17 lautete sie „Bleibt **prod2** im Job-Pool?", 12:20 „D-1 · prod2: `test:secrets` — im Job-Pool lassen oder herausnehmen?" (und `test:secrets` existiert in keinem Repo, Gegenprobe: `lint:secrets` = 1/1). Der Referent ist damit mehrdeutig.

**Optionen.** (a) eng: nur der Secrets-Job wird auf prod1 gepinnt — **ist gebaut** (P3). (b) weit: prod2 verlässt den Pool bis zur Kampagne — kostet die halbe Runner-Kapazität und die PMC-intel-Lane, was die Doktrin „PMC je Mikroarchitektur" berührt.

**Grundlage.** Zwei nie gegeneinander gemessene Hypothesen: 09.07. „prod2-Node-spezifisch, unabhängig von Last" gegen 10.08. „parallele Pipelines, OOM". Belegt ist ein Ausfall: derselbe Job 15-16 s auf prod1, 102 min hängend auf prod2, Trace 0 Byte.

**Empfehlung:** (a) ist gebaut und reicht bis zur Entscheidung. Vor der Kampagne die Kanarien-Messung fahren (isolierte Mini-Pipeline auf prod2, 40 Läufe über 5 Tage) — dann entscheidet eine Zahl statt einer Meinung. Wenn nicht 40/40 grün: Kampagne prod1-only.

### V-4 — Container-Dock gegen „separate CEB je Gattung+Genus"

**Gegenstand.** Die Korrektur vom 03.06. (Doku 24:568-572) sagt: „Es gibt KEIN eigenes Set/Sequence/Adapter/View-Dock … sie teilen sich das EINE Container-Dock." Das 10.08.-Wort sagt: separate CEB je Gattung **+ Genus**. Trägt eine CEB genau ein Dock und ist das Container-Dock eines, dürfte eine CEB Set *und* Sequence messen — was dem 10.08.-Satz widerspricht.

**Optionen.** (a) 03.06. gilt weiter: die vier gebauten Docks werden auf **eines** zurückgebaut (4 Dateien + 4 Versionsliterale fallen), eine CEB misst Set und Sequence gemeinsam ⇒ **Nenner 3 Paare statt 6**. (b) „Gattung+Genus" meint auch die vier Unterklassen: die Docks bleiben, die CEB-Zahl vervierfacht sich, und die CEB braucht erstmals eine Genus-Bauachse.

**Grundlage.** Aus dem Bestand nicht auflösbar. Gegenprobe: „Gattung+Genus" = 23 Treffer im flachen Ledger, „je Gattung" = 13, „ein Dock" = 4 — alle Kontexte gelesen, keiner entscheidet den Container-Fall.

**Empfehlung:** (a), weil sie die jüngere Präzisierung mit der älteren Systematik verträgt und die CEB-Zahl halbiert. Ohne diese Antwort baue ich in keine der beiden Richtungen — sie schließen einander aus.

### V-5 — Prüfdock-Paarigkeit (KON2-35)

**Gegenstand.** „Es kann nur eine gerade Anzahl an Prüfdocks geben, das ist eine Regression mit 5."

**Grundlage.** Drei belegbare Zählungen, keine gerade (siehe B-1). Die Regel, aus der die Paarigkeit folgt, existiert im durchsuchten Korpus nicht — mit Gegenprobe. **Welche Menge soll gerade sein?** Ohne diese Regel ist nicht sagbar, ob ein Dock fehlt oder eines zu viel ist; jede Korrektur wäre geraten.

**Empfehlung:** keine. Ein Satz vom Owner genügt und entsperrt einen laufenden Strang.

### V-6 — Das eine Invalidierungs-Fenster: Glied [6] raus, Format 4→5

**Gegenstand.** Der Fingerprint enthält heute ein **run-konstantes** Glied (die Enabled-Menge des Treibers). Weil der Vergleich eine Gleichheit auf dem SHA ist, lehnt jede Obermenge ab: ein Treiber, der *mehr* kann, erzwingt einen Flotten-Neubau, obwohl der Bestand gültig ist. Das ist die Kostenursache hinter der Zusage „Skip via Sidecar", die der Erweiterungs-Leitfaden heute noch verspricht und die seit einer Härtung nicht mehr gilt.

**Zwei Präzisierungen aus dem Entwurf, die der Owner kennen sollte:** (1) Es wird eine **Werte**-Exzision, keine Positions-Exzision — Position [6] bleibt, ihr Glied wird konstant leer; damit hält die Doktrin „Bestandsnummern bleiben, wo sie sind". (2) Der Format-Bump ist **4→5**, nicht 3→4 wie an mehreren Stellen notiert — Format 4 ist seit dem 07.08. live (selbst nachprüfbar an `anatomy_fingerprint.hpp`, Gliedzahl 9).

**Entscheid.** (a) Glied [6] verlässt das Preimage. (b) Es bleibt — dann ist jeder Teilmengen-Test toter Code.

**Empfehlung:** (a), und **im selben Fenster** die zweite anstehende Preimage-Änderung mitnehmen. Getrennt gefahren wären es zwei Flotten-Neubauten.

### V-7 — Warnstufe: `-Wall` überall, `-Werror` ja oder nein

**Gegenstand.** Der Owner hat „D-3: Ja alle einführen." gesagt. Die Frage nannte zwei Gegenstände: die Hausnorm *und* `-Werror`. Gemessen vor P2: `-Wall` galt für 214 von 574 Übersetzungsvorgängen, `-Werror` für 0 von 575.

**Kosten.** Die Hausnorm ist billig und in P2 gebaut. `-Werror` kann die ganze Pipeline rot machen und kollidiert mit der Doktrin „gesamte Pipeline immer hart grün" — deshalb ist es als Schlusspaket nach vier grünen Vollrunden geschnitten und **nicht** Teil dessen, was heute gebaut ist.

**Empfehlung:** Hausnorm ja (nach Nachbesserung von P2), `-Werror` erst nach der Messkampagne. Vor dem 29.08. ist ein rot werdender Bau das teuerste denkbare Risiko.

## Die E-Punkte, rekonstruiert

Der Owner hat verlangt, diese „mit viel Kontext erneut" vorgelegt zu bekommen. **Ehrlichkeitsvorbehalt:** meine Quelle für die E-Liste ist der Stempel-Entwurf, und der Explore-Bericht, der sie ursprünglich führte, bricht in meiner Ernte mitten im Satz ab. Ich rekonstruiere fünf Punkte aus belegten Verweisen; ob die kanonische Liste genau diese vier oder fünf sind, kann ich nicht belegen. Was fehlt, fehlt sichtbar.

| Punkt | Gegenstand | Stand | Kosten der Antwort | Empfehlung |
|---|---|---|---|---|
| **E-A** | Länge des Hex-Anteils im compile-time-Namen des Stempels (heute als eine Konstante `= 24` vorgesehen) | offen, **folgenlos** solange kein Konsument existiert | eine Konstante | vertagen — kein Termindruck |
| **E-B** | Soll der Stempel-Name im **Symbol** erscheinen (Plan-Schritt S9)? | offen, ausdrücklich **nicht** im heutigen Paketumfang | ABI-relevant, wenn ja | verwerfen oder nach Abgabe |
| **E-C** | Werden Preimage-Änderungen **gebündelt** („ein Fenster, ein Invalidierungs-Ereignis") oder einzeln gefahren? | offen, **blockiert V-6** | Bündeln spart einen kompletten Flotten-Vollbau | **bündeln** — das ist die eine Antwort mit messbarer Ersparnis |
| **E-D** | Ordner-/CSV-Ablage aus dem Stempel-Namen (Plan-Schritt S7) | offen, gehört in ein späteres Fenster | mittel | nach der Kampagne |
| **E-E** | Overlay-Glied (Plan-Schritt S8) | offen, ausdrücklich **nicht gefordert** | — | fallen lassen, bis jemand es fordert |
| **E-F** | Füllen die Stufen die Glieder „honest-empty" (leer heißt leer) oder mit Füllwerten? | **ENTSCHIEDEN** durch das 10.08.-Wort „X.Y.Z **und** einen Fingerprint SHA **wie alle**" ⇒ honest-empty, Lesart „Preimage" | — | nur bestätigen |

---

# 4. DAS BAU-GATE

Der Owner: „Wir bauen, wenn Lagerhaltung fertig **und** Stempel fertig **und** Algorithmen versioniert **und** Messung einbaubar."

## Erfüllt: **null von vier.** Drei habe ich gemessen und sie sind nicht erfüllt; die vierte habe ich nicht gemessen.

| Bedingung | Status | Begründung mit Nenner |
|---|---|---|
| **Lagerhaltung fertig** | **UNGEMESSEN** | War nicht Gegenstand dieses Workflows. Kein Strang hat sie angefasst, ich habe nichts dazu gemessen. Indiz gegen „fertig": im Aufgabenregister steht mindestens ein offener Lager-Posten (`LAG-Z1 fährt nicht in super: ce wird per EXCLUDE_FROM_ALL eingebunden`). **Ich behaupte hier nichts — das gehört gemessen, bevor jemand „fertig" sagt.** |
| **Stempel fertig** | **NEIN**, gemessen | Das geplante Versionierungs-Interface ist zu **0 von 5 Bezeichnern** gebaut (Gegenprobe im selben Suchraum: 9 / 18 / 6 Dateien — die Suche greift). Konkret fehlen: der **Planer-Fingerprint** (Owner-SOLL „wie alle"), der **Hybrid-Stempel** (vierte Stufe, 0 Dateien), die **Genus-Benennung im CEB-Stempel** (0 Treffer auf genus/gattung/dock in `ceb_version_stamp.hpp`), die **CEB-System-Klammer**. Von vier Binary-Typen tragen zwei einen Fingerprint. |
| **Algorithmen versioniert** | **NEIN**, gemessen | Der Marker `AXIS_ALGO_VERSION` steht **8×** in **7 Dateien**: 6 echte Marker, **alle** in `libs/cache_engine/heuristik/` (6 von 6 Headern dieses Verzeichnisses), plus eine bloße Kommentar-Erwähnung. Der CI-Riegel `axis_version.lock` führt **6 Nutzzeilen** (9 Zeilen minus 3 Kopf). **Von den 18 Organ-Achsen der Registry trägt keine einen Marker — 0 von 18.** Versioniert ist die Heuristik, nicht die Achsen-Algorithmen. Zusätzlich hat der Riegel ein Loch: der gesperrte `measurement_curve_loader.hpp` bezieht fünf Funktionen aus dem **nicht** gesperrten `csv_cell_reader.hpp` — eine Änderung dort verändert das Verhalten des gesperrten Headers, ohne dessen Prüfsumme zu bewegen. |
| **Messung einbaubar** | **NEIN**, gemessen — aber nicht aus dem Grund, den die Ernte nannte | Die 6 Permutationen existieren als **Typen** (`static_assert(… == 6)`, verifiziert) und als 6 Steuerdocks. Der XML-Fan-out ist **entgegen dem Explore-Befund vorhanden und verdrahtet** (Schema, Parser, Director). Was fehlt: (a) **kein einziges von 11 Profilen fordert mehr als eine Combo** — 8 deklarieren die Vollmenge, 3 gar nichts; (b) G2 und G3 teilen ein Gate (`COMDARE_CE_ENABLE_STATISTICS`, 662 Fundstellen) ⇒ **höchstens 2 unterscheidbare Kompilate statt 6**; (c) `checkpoint_measure.hpp` existiert (verifiziert), ist aber laut zwei Bestandskommentaren „in KEINE Mess-Schleife verdrahtet". |

**Der eine Satz, den der Owner braucht:** das Bau-Gate steht bei **0 von 4**, und die kürzeste Strecke zur Erfüllung von Bedingung 4 ist ein einziges, klar benanntes Paket — **G3 aus dem `STATISTICS`-Gate herauslösen**. Ohne das können keine sechs CEBs entstehen, egal was die XML fordert. Bedingung 2 hängt an zwei kleinen, preimage-neutralen Schritten (Interface-Header, dann Planer-/CEB-Dock). Bedingung 3 ist eine Marker-Zeile je Achse plus eine Zählwache.

---

# 5. DIE FRISTEN

Heute ist **Mo 10.08.2026**. Bis zur Abgabe am **Di 15.09.** liegen fünf Liefer-Freitage und die Kampagne.

| Termin | Realistisch belegbar | Begründung |
|---|---|---|
| **Fr 14.08.** | Nachbesserung und Landung der fünf gebauten Pakete; Owner-Antworten auf V-1 bis V-3 | Alle fünf brauchen kleine, benannte Nachbesserungen (je 1–4 Punkte). Vorher: `origin/development` mergen (nie rebase) — die Basis ist um 2 Commits gewandert. **Beim Merge ist Vorsicht geboten:** die vier Branches liegen alle auf 95cb3039, teilen sich also denselben Rückstand. |
| **Fr 21.08.** | Stempel-Interface + Planer-/CEB-/Hybrid-Dock (Bedingung 2); Achsen-Marker + Zählwache (Bedingung 3); CI-Härtung `lint:static`/Timeouts | Alle preimage-neutral, kein Flotten-Neubau, keine Owner-Blockade außer V-4 für den Genus-Teil |
| **Fr 28.08.** | **Einfrieren.** Kampagnen-Vorbereitung, prod2-Kanarien ausgewertet, Vollbau grün in Debug *und* Release, GCC *und* clang | Der letzte Tag, an dem eine Änderung noch geprüft werden kann |
| **Sa 29.08.** | **Messkampagne** | Fährt mit dem, was am 28.08. grün ist |
| **Fr 04.09.** | Auswertung, Rückschrieb, Genus-Komposition | Braucht V-1 beantwortet, sonst ist die Differenz-Arithmetik nicht aufschreibbar |
| **Fr 11.09.** | Thesis-Text, HDR-Zusage, Puffer | Der Puffer ist keine Reserve, sondern eingeplant |

## Was NICHT mehr hineinpasst — und warum

- **Die sechs CEBs vor der Kampagne.** Das G3-Gate-Herauslösen berührt die ABI-Naht im heißen Pfad und braucht eine eigene Verifikationsrunde; danach 6 CEB-Kompilate × 30 (oder 36) Gattung-Genus-Paare plus Flotten-Bau. Bei der bekannten Größenordnung passt das nicht in 19 Tage. **Konsequenz:** die Kampagne am 29.08. misst **mit** eingebauten Fühlern, ohne die Messfehler-Herausrechnung. Das ist ein Owner-Entscheid über Umfang gegen Termin, kein Versäumnis — aber er muss bewusst fallen.
- **Das Invalidierungs-Fenster (V-6).** Es enthält einen Flotten-Vollbau. Vor dem 29.08. wäre das ein vermeidbares Risiko; danach kostet es einen ganzen Liefertag. **Empfehlung: nach der Kampagne, im 04.09.-Fenster.**
- **Die volle Warnstufen-Ausweitung auf die Testbäume und `-Werror`.** Rund 140 CMake-Stellen und geschätzt 55 Warnungsfixes, gegen einen Nutzen, der die Kampagne nicht verbessert.
- **Graph-Dock und Graph-Genus.** Vom Bestand selbst auf „nach Abgabe" datiert.
- **Der Hybrid-Bau.** Nur der Stempel ist einplanbar, nicht die Gattung.
- **Die Klärung, ob `f15_compare` sterben oder schrumpfen soll.** Owner-Frage, kein Bauposten.

---

# 6. WAS DIESER WORKFLOW NICHT ABDECKT

Ausdrücklich und vollständig, so gut ich es benennen kann:

**Nichts ist gelandet.** Fünf Commits, fünf Branches, **null Pushes, null Pipelines, null Merges**. Alles, was hier „grün" heißt, ist lokal. Die Job-Ebene — ob `build:clang` wirklich nicht mehr skippt, ob der Timeout im hängenden Zustand beißt, auf welchem Runner `lint:secrets` landet — ist **unbewiesen** und braucht den ersten echten Lauf.

**Vier von fünf Paketen haben keinen Vollbau gefahren.** Nur P3 hat die Pflicht-Reihenfolge Werkzeuge → Re-Configure → Vollbau → Tests → ctest durchlaufen (Ergebnis dort: 481/481). Die anderen vier haben Einzelziele gebaut, weil die Platte zwischen 87 % und 96 % stand. Für diese vier gilt: **der eigene Test ist grün, die Suite ist unbewiesen.**

**Die Zehn-Wochen-Pflicht ist auf der Transkript-Seite strukturell unerfüllbar.** Auf dieser Maschine liegen 16 Rohtranskripte, alle vom 06.–10.08.2026 — **5 von 70 Tagen**. Alles vor dem 06.08. ist ausschließlich über Ledger und Pläne erreichbar; Owner-Verbatim aus den Wochen davor lässt sich hier grundsätzlich nicht belegen, nur seine Verschriftung. Wo dieser Bericht ältere Owner-Worte zitiert (§43.b vom 19.07., die Dock-Architektur vom 17.07.), sind das **Ledger-Verschriftungen, keine Rohworte.**

**Nicht berührt:** die Lagerhaltung (Bedingung 1 des Bau-Gates), das super-Repo außer lesend, das Thesis-Repo vollständig, die clang-Warnungsrunde 2, die Hybrid-Gattung, das Graph-Dock, die 94 verbliebenen toten Ledger-Zeilenverweise (P5 heilte 6, die Ratsche hält nur den Zuwachs auf), die 227 unklassifizierten Prosa-Erwähnungen, `f15_compare`.

**Grenzen der gebauten Wachen — jede deckt nur ihren Gegenstand:**

- Die Taxonomie-Wache erzwingt **Nennung, nicht Klassifizierung**: wer eine neue Versionsquelle anlegt und ihren Dateinamen irgendwo in der Prosa erwähnt, kommt durch.
- Die Warnnorm-Wache prüft **Anwesenheit von Flags, nicht ihre Wirkung**: ein angehängtes `-w` schaltet die Norm ab und die Wache meldet weiter volle Deckung.
- Die CI-Invarianten-Wache sieht **nur die eigene YAML-Datei**, nicht die geerbte Vorlage im anderen Repo — und dort liegt ein totes Gate, das den clang-Job stilllegen würde, wenn die lokale Überschreibung fiele.
- Die Anker-Wache prüft **die Form des Verweises, nie seine Wahrheit**: „tickende Zeilennummer" ist geschlossen, „überholte Aussage bei intakter Form" nicht. Genau diese zweite Klasse hat in diesem Workflow zugeschlagen — der Explore-Befund „XML-Element fehlt" stammte aus einem formal einwandfreien, inhaltlich toten Kommentar.

**Zwei operative Posten außerhalb dieses Workflows**, die der Owner kennen muss, weil sie die Landung betreffen: im Aufgabenregister stehen ein als sofort markierter Sicherheitsposten (Zugangsdaten sind in ein Transkript geraten, Rotation nötig — Werte nenne ich nicht und habe ich nicht gesucht) und der Befund, dass Pipeline-Abnahmen derzeit kein Zugangstoken mehr haben, also **blind** sind. Solange das gilt, kann keiner der fünf Branches seine „Pipeline grün"-Abnahme selbst nachweisen.

---

**Zusammengefasst in vier Sätzen.** Der Owner hatte bei allen drei Fragen recht: B-1, B-2 und B-3 sind geplant, dokumentiert und zitierbar — B-3 sogar als Metaprogrammierung gebaut. Gebaut und committet sind fünf Pakete, aber keines ist in der gelieferten Form landefähig, und keines ist gepusht. Das Bau-Gate steht bei null von vier, wobei die kürzeste Strecke zur vierten Bedingung ein einzelnes benanntes Paket ist. Der Termindruck sitzt nicht am 15.09., sondern am 29.08.: drei Entscheide (V-1, V-2, V-3) müssen vorher fallen, sonst misst die Kampagne etwas, das anschließend nicht auswertbar ist.
