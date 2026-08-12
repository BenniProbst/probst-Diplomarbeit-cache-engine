## NACHTRAG 11.08.2026 NACHTS — KON11: DAS ARBEITSPRINZIP FÜR DEN VOLLAUSBAU, UND DREI KORREKTUREN IN VOLLER LÄNGE

---

### KON11-01 — 🔴 DAS ARBEITSPRINZIP: KONSOLIDIEREN · ARCHIVIEREN · IN DER ZIELFORM AKTIVIEREN

**Owner verbatim 11.08.2026 nachts**, nach den Ergebnissen beider Explores:

> *„Ja wir sind **viel weiter als ich zugeben mag**, wir müssen aber **unverdrahtetes konsolidieren
> und archivieren und final in der Zielform aktivieren**. Dann wird es."*

    NICHT   neu bauen, was schon existiert
    SONDERN  konsolidieren  ->  archivieren  ->  in der ZIELFORM aktivieren

**Das ist die tragende Arbeitsanweisung für den gesamten Vollausbau (Wellenplan §14).** Sie
verändert die Aufwandslage grundlegend: die Baukette ist zu weiten Teilen **kein Neubau, sondern
eine Verdrahtung**.

#### DIE INVENTUR DES UNVERDRAHTETEN — am 11.08. gemessener Bestand

| Gegenstand | Zustand | Beleg |
|---|---|---|
| **`ExperimentPlanDirector`** | **existiert, unangeschlossen** | `ce libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` |
| **`LagerBaumWriter`** | **gebaut, NIRGENDS gerufen** — Vorkommen in `ce/libs`+`ce/apps` = genau 1 Datei (seine eigene), externe `::kaskade(`-Aufrufe = **0** | CI-Explore, selbst gemessen |
| **`axis_version_lock`** (Bump-Wache) | **existiert und ist CI-verdrahtet**, deckt aber **6 von 136** bump-pflichtigen Dateien, **0 davon unter `axes/`** | `ce tools/axis_version_lock/…:172-185`, `ce/.gitlab-ci.yml:768-786` |
| **`run_selection_filter_chain`** (CoR) | **existiert, 0 Produktions-Konsumenten** — nur ein Test | `selection_filter_chain.hpp:87` |
| **`ram_probe_chain`** | **concept-basierte CoR, gebaut** — *„Kein virtual: die CoR ist hier statisch verdrahtet"* | `:161`, `:483` |
| **`AxisCommand`** (compile-time Command) | **existiert als C++23-concept** | `ce topics/axis_command_base.hpp:20` |
| **`IResourceControllableTier`** | **existiert** als Laufzeit-Pendant der Limitations-Auskunft | `ce anatomy/resource_controllable_tier.hpp:63` |
| **`i_command.hpp`** | **GEPARKT** seit 06.07. (`#267`), Laufzeit-`virtual`, mit Nachfolger-Vermerk | Kopfkommentar |
| **`v32_messreihe_antrieb`** | **zweite Enumerations-Engine**, nennt sich selbst *„der OFFIZIELLE Einstieg"* | `super Code/02_messung_driver/…:268` |
| **`catalog_codegen.cmake`** | **läuft** — die gebaute Selbstkompilations-Blaupause | `:52-60` |
| **Hybrid-Header** | **943 Zeilen gebaut**, 0 Stempel-Bezug | `ce libs/cache_engine/hybrid/` |

**Elf Positionen. Neun davon sind gebaut und nicht verdrahtet.**

#### WAS DAS FÜR §14 ÄNDERT

Die 17 Bau-Teile aus Wellenplan §14.2 sind neu zu lesen: **jedes Teil beginnt mit der Frage
„existiert es schon?"**, und erst wenn die Antwort nein lautet, wird gebaut. Die Reihenfolge je
Teil ist:

    1. KONSOLIDIEREN  -- den Bestand finden, seinen Zustand messen, Doppelungen benennen
    2. ARCHIVIEREN    -- was ersetzt wird, wandert nach docs/ bzw. in einen Archiv-Zweig.
                         NICHTS wird geloescht (Hausdoktrin: Doku wird deprecatet)
    3. AKTIVIEREN     -- in der ZIELFORM verdrahten, nicht in der Fundform

**Der dritte Schritt ist der, an dem es bisher scheiterte:** neun gebaute Bausteine liegen ohne
Konsument im Baum. Ein Baustein ohne Aufrufer ist im Rückblick von einem fehlenden nicht zu
unterscheiden — genau deshalb hat der Explore sie als „fehlend" gemeldet, bevor die Gegenprobe lief.

---

### KON11-02 — DIE KONFLIKTREGEL, GESCHÄRFT

**Owner verbatim:** *„Bezüglich Konflikten: **Neueres gilt und Owner Wort noch viel mehr.**
Möglicherweise eine durch explore zu korrigierende Fehlinterpretation, wir haben heute wieder viel
Verständnis geschärft."*

    RANG 1   OWNER-WORT                     schlaegt alles
    RANG 2   NEUERES schlaegt AELTERES      innerhalb derselben Rangstufe
    RANG 3   Bei Widerspruch OHNE Owner-Wort auf beiden Seiten:
             ZUERST pruefen, ob es eine FEHLINTERPRETATION ist -- per EXPLORE.
             Erst wenn der Explore sie nicht aufloest, wird der Owner gefragt.

**Das ergänzt die bestehende Rangfolge OWNER > PLAN > THESIS** um die Zeitachse und um eine
Vorstufe: **nicht jeder Widerspruch ist ein Entscheid — manche sind ein Missverständnis.**

#### 🔴 DIE UNMITTELBARE FOLGE: W-1 IST KEIN OWNER-ENTSCHEID MEHR

Der Explore hatte als **O-2** vorgelegt: *„Wirkt der Hybrid-Einschub auf Organ oder nicht?"* —
KON7-03 sagt *„Organ bleibt hybrid-unberührt"*, die spätere Grammatik-Zuordnung setzt
*„System/Organ MIT Hybrid"*. **Beide vom 11.08., keine ist Owner-Wort.**

Nach KON11-02 ist das **kein Owner-Entscheid, sondern ein Explore-Auftrag**: beide Aussagen stammen
von mir, eine davon ist mit hoher Wahrscheinlichkeit meine Fehlinterpretation. **O-2 wandert damit
von der Owner-Vorlage in die Explore-Liste.** Die Owner-Vorlage schrumpft von elf auf **zehn**
Punkte.

---

### KON11-03 — E-1 IN VOLLER LÄNGE: DAS OWNER-ZITAT WAR STILL GEKÜRZT

**Gegenstand:** mein Zitat des Owner-Satzes vom 11.08., 17:41:20.756 Z, in KON9-06 und in der
Kontext-Wiedergabe.

**Was ich zitiert habe:**

> *„Es ist also der Mechanismus der Selbstkompilation aus C++ Binaries heraus (nur cmake erlaubt,
> keine Skripte erlaubt). Du hattest das schon entworfen."*

**Was im Original steht** (`5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:42174`, `type=user`,
`2026-08-11T17:41:20.756Z`):

> *„Es ist also der Mechanismus der Selbstkompilation aus C++ Binaries heraus (nur cmake erlaubt,
> keine Skripte erlaubt, **siehe letzter Kontext und auch sonst**). Du hattest das schon
> entworfen."*

**Die Klammer endet im Original mit „, siehe letzter Kontext und auch sonst" — ohne
Auslassungszeichen weggelassen.**

**Was der Explore bestätigt hat:** Stelle, Zeitstempel und Kontext (Antwort auf meine Frage B) sind
korrekt; **kein Widerruf in den folgenden 13 Minuten** (`:42183-42292` gegengelesen).

**Warum das mehr ist als eine Formalie:** der weggelassene Teil ist ein **Beleg-Verweis** — der
Owner sagt ausdrücklich, dass die Regel nicht nur in diesem Kontext, sondern *„auch sonst"* gilt.
Genau das hätte mich am selben Abend schneller zum Bestand geführt, statt den Begriff
„Selbstkompilation" zu suchen, den es nirgends gibt.

**Regel daraus:** eine Kürzung in einem Owner-Zitat wird **immer** mit `[…]` markiert. Ein still
gekürztes Zitat ist ein verändertes Zitat.

---

### KON11-04 — W-6 IN VOLLER LÄNGE: EIN RECHENFEHLER IN EINER WEITERGEGEBENEN ZAHL

**Gegenstand:** `memory/reference_versionierung_soll_je_stufe_owner_orientierung_20260810.md`,
Zeilen 85–88.

**Was dort steht:**

> „153 `static constexpr algo_version` … (**96× `1.0.0.c`, 2× `1.0.1.c`, 24× `1.0.2.c`**)"

**Die Rechnung:**

    96 + 2 + 24 = 122        NICHT 153

**Die Zahl trägt einen internen Widerspruch und darf nicht weitergereicht werden.** Entweder ist die
Gesamtzahl falsch, oder die Aufschlüsselung ist unvollständig — aus der Quelle allein ist nicht
entscheidbar, welches von beidem.

**Einordnung in die bekannte Zahlen-Lage:** dieselbe Größe wurde am 11.08. bereits als *„153
algo_version-Konstanten: trifft **keine** von fünf Messungen (104/115/124/131 je Muster und
Scope)"* geführt. **Auch die Owner-Zahl „138 Stellen" (07.08.) trifft nicht.** Größenordnung ja,
Nenner nein.

**Was zu tun ist:** die Zahl im Memory **zurückziehen** und durch eine neu erhobene mit
**ausgeschriebener Zählweise** ersetzen — Muster, Scope, Nenner. Bis dahin gilt sie als
**unbelegt**, nicht als „ungefähr richtig".

---

### KON11-05 — W-7 IN VOLLER LÄNGE: ZEILENANKER SIND INSTABIL

**Der Befund:** KON8-04 wurde in einem Bericht als `:165-168` zitiert. **Der Wortlaut steht heute
bei `:706`** — im Zwischenstand desselben Tages stand er bei `:531`.

**Die Ursache:** der Ledger wird **von mehreren Agenten gleichzeitig beschrieben**, und die
Nachträge stehen **oben**. Während einer einzigen Erhebung wuchs er von **20.430 auf 20.973
Zeilen** — jede Zeilennummer darunter verschob sich um 543 Positionen.

**Die Regel:**

> **Anker über die KON-Kennung setzen, nie über absolute Zeilennummern.**

**Es gilt nicht nur für den Ledger.** Zwei belegte Fälle aus derselben Erhebung:

* `catalog_codegen.cmake` — im BAUPLAN vom 19.07. als `:27-37` adressiert, heute `:52-60`. Ursache:
  ein am **06.08.** eingefügter Kommentarblock. Reine Zeilendrift, der Gegenstand ist unverändert.
* `algo_semver.hpp` — dieselbe Klasse; die Datei ist an einem Tag mehrfach gewachsen.

**Präzedenz im Haus, die diese Regel bereits einmal erzwungen hat:** der D5-3-Anker war um **239
Zeilen** gedriftet und wurde deshalb auf **Symbol-Form** umgestellt, bewacht durch
`ci/anker_wache.sh`. **Dieselbe Heilform gilt hier: Symbol statt Zeile, KON-Kennung statt Nummer.**

**Und eine Verschärfung, die aus dem heutigen Tag folgt:** eine Zahl über eine **lebende Datei**
gilt nur **mit Commit-Anker**. Der Wellenplan trägt diese Regel bereits für die Job-Zahlen
(*„47/53 heute Mittag — eine Zahl über eine lebende Datei gilt nur mit Commit-Anker"*); sie gilt ab
sofort ebenso für **jeden Ledger- und Code-Anker in jedem Bericht**.

---

### KON11-06 — WAS DARAUS FÜR DIE NÄCHSTEN SCHRITTE FOLGT

1. **Die Owner-Vorlage schrumpft auf zehn Punkte** (O-1, O-3…O-11). O-2 ist ein Explore-Auftrag.
2. **Jedes der 17 Bau-Teile beginnt mit einer Bestands-Frage**, nicht mit einem Entwurf.
   Neun von elf geprüften Positionen existieren bereits gebaut.
3. **Drei Zahlen sind zurückzuziehen** und mit Zählweise neu zu erheben: die 153 (KON11-04), die
   Concept-Zahl 321/228 → **339/229**, die mp11-Zahl 687/186 → **350/169 Quellcode-Dateien, Filter
   mitschreiben**.
4. **Alle künftigen Anker gehen über Symbol oder KON-Kennung.** Zeilennummern nur mit Commit-Anker.
