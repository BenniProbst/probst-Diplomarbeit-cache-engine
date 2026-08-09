# KONTEXTÜBERGABE 09.08.2026 abends — Neugründung, Stand, Wellenbau

**Für den Nachfolger.** Diese Übergabe sagt dir, welche Dokumente du brauchst und in welcher
Reihenfolge — sie ersetzt keines davon.

> ## ES GIBT KEIN ZEITBUDGET
>
> **Owner, 09.08.2026:** *„Die Wellenplanung hat errechnet, dass **maximale Gründlichkeit**
> dennoch den Zeitplan nicht reißt, daher **keine Abstriche**."*
>
> Das ist keine Ermutigung, sondern eine **Vorgabe**. Lies **vollständig**. Miss **am Objekt**.
> Fahre **jeden Köder**. Nimm **jede** Prüffrage.
>
> Wer hier kürzt, spart nichts — er verlagert die Arbeit in eine Korrekturschleife, und die ist
> teurer als die Gründlichkeit, die sie ersetzen sollte. Genau diese Schleife ist im Haus gemessen:
> *Breite → Takt → Stellvertreter → Aussage vor Messung → Korrektur → weniger Zeit → mehr Breite.*
> **Der Wellenplan hat den vollen Aufwand eingerechnet.**
>
> Was den 15.09. gefährdet, ist nicht die Zeit, die eine saubere Messung kostet. Es ist eine Zahl
> ohne Deckung, eine Wache ohne Biss, ein Bericht, den niemand am Objekt nachgemessen hat.

---

# TEIL 0 — DIE NEUGRÜNDUNG, in dieser Reihenfolge

**Regel des Tages, Owner-gesetzt:** *„Bitte gründe dich IMMER direkt nach Kontext-compact neu und
lies memory."* Ein Compact-Summary trägt den **Gesprächsverlauf**, nicht die **Dauerregeln** — die
kamen im Verlauf ja nie vor, sie sind gerade das, was ohne Erwähnung gilt. Wer das überspringt,
arbeitet mit vollem Sachwissen und halbierter Regelkenntnis und merkt es nicht. Am 09.08. hat genau
das drei Regelverstöße in einer Stunde erzeugt.

## Schritt 1 — die vier bindenden Dokumente

| Rolle | Datei |
|---|---|
| **Das Ziel** | `docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` |
| **Was gebaut wird** | `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` (inkl. §11/§12) |
| **Wie geprüft wird** | `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md` |
| **Wie gearbeitet wird** | `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3.1 |

**Das vierte fällt am leichtesten weg und wiegt am schwersten.** Das Goal sagt, WAS zu erreichen
ist; die ARBEITSWEISE sagt, WIE gearbeitet werden darf. Wer nur das erste liest, baut das Richtige
auf dem falschen Weg.

**Der Auftragssatz, an dem alles hängt:** *eine Diplomarbeit, deren jede ausgewiesene Zahl von
einer Messung gedeckt ist, **die älter ist als der Satz, der sie behauptet**.*

## Schritt 2 — die Sessions ab dem 08.08.

**Owner, wörtlich:** *„Du brauchst auch nicht ständig reviews machen, bitte lies einfach gründlich
alle Sessions inklusive und ab dem 08.08. vollständig, dort stehen alle gefundenen, Pläne,
regressionen und Ziele, die Planung ist umfassend."*

Zwei davon sind Pflicht:

- `docs/sessions/20260808-SESSION-REGRESSIONEN-vollstaendig-nach-klassen.md` (184 Z.) — trägt den
  Satz, der die Fehlerklasse des Hauses benennt: **„Der blinde Köder und die blinde Wache sehen
  identisch aus."**
- `docs/sessions/20260808-SESSION-ERKENNTNISSE-widerlegte-befunde-und-learnings.md` (164 Z.) — die
  Stellvertreter-Analyse, 40 adversarisch geprüfte Fälle, **32,5 % der Widerrufe fielen selbst**.

**Am 09.08. gemessen: drei Review-Workflows entdeckten fast nur, was dort seit dem 08.08. steht.**
Ein Review ist erst gerechtfertigt, wenn die Frage dort **nachweislich nicht** beantwortet ist —
mit der Fundstelle, wo gesucht wurde.

## Schritt 3 — Memory-Index und die tragenden Kerne

`~/.claude/projects/-home-comdare/memory/MEMORY.md` — eine Zeile je Datei, 267 Dateien.
**Gesichert liegt er auch im Repo:** `docs/memory-index/MEMORY-index-snapshot.md` (vor jeder
Kürzung neu abzulegen — Owner-Anweisung).

Selbst lesen, nicht delegieren:
`feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen` (K1–K14) ·
`feedback_arbeitsweise_sequenz_gedaechtnis_zuerst_nie_explore_fuer_dokumentiertes` ·
`feedback_rangfolge_owner_plan_thesis_merge_statt_verdraengung` ·
`project_verarbeitungskette_acht_stationen_hardware_job_pool` ·
`project_vier_binary_typen_ceb_traegt_alles_acht_behelfs_clis`

## Schritt 4 — der lebende Stand

    git -C <repo> fetch origin main development
    # je Worktree: ungepusht? dirty? läuft dort ein Strang?
    for p in /home/comdare/wt-*; do
      echo "$p $(git -C $p log --oneline origin/development..HEAD | wc -l)"; done
    # laufende Stränge NUR so messen (workflows/*.json lügt "completed"):
    find <session>/subagents/workflows -name 'agent-*.jsonl' -mmin -6 \
      | sed 's#.*/\(wf_[^/]*\)/.*#\1#' | sort -u

**Und der Ledger-Kopf** (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachträge **oben**,
via `scripts/ledger_nachtrag.sh`).

---

# TEIL I — DER STAND, mit dem du anfängst

## I.1 BEIDE REPOS SIND ROT — das ist der erste Handgriff

| Repo | Pipeline | gefallen an | Fix |
|---|---|---|---|
| **ce** 15447 | `lint:format` | 8 von 50 C++-Dateien | committet `d5e2da59` in `wt-ce-mess-report`, **ungepusht** |
| **super** 15448 | `lint:format`, `build:clang`, `analyse:thesis-data`, `visibility:tier-binaries` | 4 Dateien (Vorbestand) | committet `ec9dc27e` in `wt-super-hostbelegung`, **ungepusht** |

**Die Lehre daraus, die du brauchst:** *die CI meldet nur bis zum ersten Riss.* In ce nannte sie
**zwei** Dateien — gemessen waren es **acht**. Wer die Fehlermeldung heilt statt den ganzen
Landungsbereich, fällt beim nächsten Lauf erneut.

    # so wird es gemessen, mit Gegenprobe (K13):
    für jede geänderte .cpp/.hpp im Bereich:
      cf22 --output-replacements-xml --assume-filename=<f> <f> | grep -c '<replacement '
    # Gegenprobe: eine absichtlich krumme Wegwerf-Datei muss > 0 liefern

**Die drei super-Jobs außer lint:format sind noch nicht diagnostiziert.** Das ist dein zweiter
Handgriff.

## I.2 LANDEBEREIT: 17 Sach-Commits in `wt-ce-mess-report`

Branch `bau/a9-s4-mess-report`, FF-fähig, `dirty=0`, gitleaks `17 commits scanned` = exakt erwartet.
Enthält **acht Pakete**:

    A9-S4 mess-report · check-size · HY-A1 (Gattung HEURISTIK-ADAPTER) · D5-5 HDR ·
    FK-6 Fehlerklassen · MS-1-Reparatur (6/6 Mutanten tot) · A9-S5 xlsx+csv gleichzeitig ·
    D5-4 delete_p99_ns  + der Format-Fix d5e2da59

**Drei Merge-Konflikte gelöst, alle in `tests/unit/CMakeLists.txt`** — der Hotspot-Datei. Alle drei
waren **rein additiv**: verschiedene Stränge bauen am selben Dateiende an. So wird das geprüft, nie
geraten:

    comm -12 <(HEAD-Seite: Testnamen) <(andere Seite: Testnamen)
    # leer = additiv, beide Seiten behalten

## I.3 DIE LANDE-KETTE — ganz gehen, nicht bei „grün" aufhören

    merge origin/development (NIE rebase)
      → gitleaks über origin/development..HEAD im ECHTEN Klon
        („N commits scanned" gegen die erwartete Zahl prüfen!)
      → R4: keine laufende Pipeline auf dem Ref
      → push → Pipeline grün → main-FF auf den GEPINNTEN SHA
      → bei ce zusätzlich: Gitlink-Bump in super

**Zahlen-Falle, heute aufgetreten:** gitleaks meldete `7 commits scanned` bei 11 erwarteten.
Aufgelöst: 7 Sach-Commits + 4 Merges; **Merges tragen keinen eigenen Diff**, gitleaks scannt sie
nicht. Immer gegen `--no-merges` zählen.

**Owner-Auftrag dazu:** *„fertige Arbeit in den worktrees regelmäßig prüfen und landen — besonders
wenn ein workflow fertig wird."* Und: **erst landen, dann aufräumen, nie umgekehrt.** Was gelandet
ist, überlebt jede Löschung.

## I.4 Heute gelandet (11 Commits)

    ce    b17a59ab  K1: Gattung/Genus als Wurzelebenen des Lagerbaums + Spec-Wache
    super 7e4a5ee6  Host-Belegung · Zellkoordinaten-Wache · wide_aggregat · V-8
    super 755dea35  GOAL-Dossier Teil IX: falsche allow_failure-Aussage korrigiert
    super 0db8ddc1  Memory-Index gesichert

---

# TEIL II — DIE OWNER-ENTSCHEIDE DES TAGES (Gesetz)

1. **NUR VIER BINARY-TYPEN.** Planer → CEB → Tier → Hybrid, **statisch**. Die CEB trägt Messen
   **und** Veröffentlichen. *„Die CEB macht alles."* Dynamisches Linken einstellbar, nicht Default.
2. **NUR C++ UND CMAKE, es gibt keine Skripte.** IST: **25 eigene Programme** (8 super-CLIs +
   7 ce-`apps/` + 10 ce-`tools/`) und **≥56 Skripte** (.sh/.ps1/.bat/.py).
3. **DIE ERZEUGUNGSKETTE hat keine Abkürzung, auch nicht im Test.** *„Der Planer fordert auch in
   der Testsituation dummy commands als DIRECTOR von der CEB an. Ohne Planer keine CEBs, keine
   Tier-Binaries ohne CEBs, keine Hybrid-Binaries ohne Tier-Binaries."* Builder-Muster:
   Planer = Director, CEB = Builder (`director` steht in 136 ce-Dateien).
4. **xlsx IST DER STANDARD. CSV WAR NIE DER STANDARD.** *(Owner 09.08., ausdrücklich klargestellt —
   der IST-Stand im Repo legt das Gegenteil nahe und ist genau deshalb die Regression.)*

   CSV ist **ausschließlich optional**, und zwar in genau zwei Formen:

   | Form | Bedeutung |
   |---|---|
   | **einzeln STATT xlsx** | csv gewählt, xlsx nicht — die Mappe wird als flache Sheets ausgegeben |
   | **additiv ZU xlsx** | beide gewählt — csv entsteht **nach** der xlsx, **aus deren Existenz** |

   **Ohne Angabe entsteht xlsx.** Die Richtung ist **immer xlsx → csv, nie umgekehrt**: es gibt
   keinen Parser, der eine fertige CSV einliest, um daraus eine Mappe zu bauen. Beide Ausgaben
   speisen sich aus **denselben In-Memory-Zeilen** derselben Mappe — deshalb ist „beide zugleich"
   auch kein Doppelschreiben, sondern eine Mappe mit zwei Ausgabe-Strategien.

   Das XOR vom 05.08. ist damit **in seiner Ausschließlichkeit** aufgehoben; Strategy Pattern,
   xlsx-Default und „keine CoR-Kette" bleiben unverändert gültig.

   **Warum das in einer Übergabe steht:** der Bestand sagt etwas anderes — super-CI zählte
   `csv 36 / xlsx 0`, das golden-Profil wählte literal `<method value="csv"/>`, und der
   xlsx-Writer wurde von **null** Produktions-Targets gelinkt. Wer nur den Code liest, hält csv
   für den Standard. **Er ist es nicht und war es nie** — das ist die Regression, nicht die Norm.
5. **GOOGLE TESTS statt Shell-Proben, Debug UND Release.** *„Skripte sagen gar nichts."*
   Der Test muss drei Zustände unterscheiden: **(a)** Wache greift (mit dem erwarteten Literal),
   **(b)** Mutant überlebt → ROT, **(c)** Werkzeug kaputt → ROT, **nicht** „gefangen".
6. **WARNUNGS-REVIEW ZWEIMAL:** Runde 1 GCC (Quelle ist der **Test-Bau**, `build:clang` war
   `skipped`) → **aufräumen + clang-Bau** → Runde 2 clang. *Andere Menge, nicht dieselbe nochmal.*
7. **`allow_failure` auf JOB-Ebene verboten.** Nur die CSV-**Zelle** trägt „failed" + Warnung.
8. **18 Organ-Achsen, nicht 19.** Die 2^17 erklärt sich: je Achse zwei Vertreter, die
   Persistenz-Achse gepinnt → 17 frei.
9. **K-4 und E-1 sind grundverschiedene Fragen, beide beantwortet.** K4 = Systemachsen-Framing
   (02.08., Q6). E-1 = kein neuer Enum-Wert (09.08.) → dann C+A. **Beide Kürzel sind mehrfach
   vergeben** — ein Kürzel ohne Datum und Gegenstand ist keine Referenz.
10. **`flat_hash_map` gibt es nicht und kann es nicht geben** — sie allozierte an `axis_06` vorbei.
    Was existiert: CE-native SwissTable S22, Genus SearchAlgorithm → **Gattung MAP**, nicht
    Container (`anatomy_base.hpp:127`). Offen: Textpass + AP-7b (S22 ist Default-OFF).

---

# TEIL III — DER KRITISCHE PFAD: F1 am Freitag 14.08.

## III.1 Der Durchstich kann heute strukturell NICHT laufen

**Beide Wege durch die Mess-Stufe sind abgeschaltet** — am Objekt gemessen:

- **Alter Pfad** `measure:smoke` (`:1153`) verlangt in seinen `rules` **zwei** Bedingungen
  gleichzeitig (`:1170/:1171`), und die YAML sagt selbst: *„läuft NUR NOCH mit zusätzlichem
  `COMDARE_STATIC_SMOKE_FALLBACK==true` (**Default AUS**)"*.
- **Neuer Pfad** endet in `ergebnis:holen` (`:1826`) — wörtlich ein **SKELETT**, der scharfe
  Sammel-Aufruf auskommentiert, `when: manual`.

**Und die härteste Messung:**

    grep -nE "^\s+- job: (planer|ceb|tier)" super/.gitlab-ci.yml  →  genau 2 Treffer

**Keine einzige `needs`-Kante von der lebenden Kette nach `persist` oder `anhang:forward`.** Der ce-
Code bestätigt es selbst (`experiment_plan_director.hpp:1473-1476`).

**Folge: `ergebnis:holen` muss VOR F1 scharf werden**, nicht erst am 28.08. wie geplant.

## III.1b DER WEG IST GEBAUT — Antwort des Strangs, differenziert

Commit **`54c11a67`** in `wt-super-objectstat` (`bau/lagp1-object-stat`, 4 Dateien, +847), ungepusht.

**JA für die Kette** Mini-Lauf → Marker → Gate → persist → `anhang:forward` → PDF. Sie steht
strukturell, und **jedes Tor beißt nachweislich auf die leere Messung** — das war die Auflage:

    Voll-Resume (measured=0, resumed=5)   -> rc=1
    Gar nichts (0/0)                      -> rc=1
    Log ohne Marker                       -> rc=2  "unpruefbare Lage -- kein Gruen"
    Kopfzeilen-CSV am Ausbeute-Gate       -> rc=1
    persist P1 / anhang A6+A10            -> KEIN Commit

Die F1-Welle (`COMDARE_DURCHSTICH=true`) erzeugt **genau einen** messenden Job; ohne sie **null**.
Bissprobe: `16 Fälle gefahren, 0 gerissen` · `4 Mutanten gefahren, 4 gefangen`, jeder von einem
**benannten** Fall. Was das Halten erzwingt: **Werkzeug** — beide Wachen laufen unbedingt unter
`set -euo pipefail`, die Mutanten werden je Pipeline-Lauf frisch gewürfelt.

**NEIN für das wörtliche xlsx-Glied** am heutigen Gitlink `c6d8e573`: dort ist **kein
xlsx-Schreiber verdrahtet** (0 Referenzen außerhalb Registry/`ext/`/Docs, Gegenprobe gefahren).
**Der Weg dahin liegt bereit** — die xlsx-Mappe steckt in den 17 landebereiten Commits; landen
plus Gitlink-Bump macht das Glied real. Sonst braucht es die ausdrückliche Owner-Abnahme
*„F1 ohne xlsx-Glied"* — **eine Owner-Entscheidung, keine technische.**

**Und der Strang hat seinen eigenen Bau-Bericht korrigiert** — lies das als Muster: behauptet war,
`kWritebackMethodRegistry` kenne am Gitlink kein `xlsx`. **Gemessen: sie trägt vier Einträge
inklusive `Xlsx`.** Die Schlussfolgerung stimmt (kein xlsx-Ergebnis erzeugbar), die zitierte
Tatsache nicht — `xlsx` wäre dort **deklarierbar und validierte grün**, als stiller No-Op. Das ist
der **schlimmere** Stellvertreter: eine Konfiguration, die durchgeht und nichts tut.

**Drei Aufgaben bis Freitag, keine Hoffnungen:** (1) die drei Commits über die Lande-Runde auf
`development` bringen, (2) der Probe-Durchstich Di/Mi in der CI — **sechs Jobs laufen erstmalig,
die Laufzeit ist ungemessen**, (3) beide Write-Token (288/289) gesetzt.

**Bekannte Schwäche, benannt statt verschwiegen:** `F16` zählt *Erwähnungen* statt Aufrufen
(`grep -cF` auf den Wachen-Pfad, Schwelle ≥2, heute 4 Treffer = Kommentar + `test -x` + 2 echte).
Ein Mutant, der **beide echten Aufrufe** löscht, ließe `F16` grün. Gehört zu Posten #27.

## III.2 Was der Wellenplan sonst noch falsch beschreibt

| Posten | Urteil | Grund |
|---|---|---|
| **D3-2** | HINFÄLLIG | zielt auf `measure:smoke` — den toten Job |
| **##23** | falsche Richtung | „Zeilenzahl je Blatt gegen **Eingangs-CSV**" ist unbaubar: es gibt keinen CSV-Parser, beide Ausgaben speisen sich aus denselben In-Memory-Zeilen |
| **##31** | Nenner falsch | Plan sagt „6 `.sh` in super" — gemessen **23** |
| **D3-1** | geändert | fordert ein *neues* Skript; nach Entscheid (2) unzulässig, der Kern ist schon gelandet |
| **##22, D3-3, D3-5, D2-G5, D5-3** | ERLEDIGT | am Objekt belegt |

---

# TEIL IV — WAS LÄUFT UND WAS LIEGT

## IV.1 Laufende Stränge (mit `-mmin` prüfen, nicht raten)

    w8bktp12p  Warnungs-Review Runde 1 (GCC) + Codex        4 Phasen
    wni7nfzlm  Google Tests statt Shell + Mutations-Research 4 Phasen
    wgg3d0qjw  DURCHSTICH F1 lauffähig machen                3 Phasen

## IV.2 Ungepusht, nach Zustand

    LANDEBEREIT  wt-ce-mess-report (17 + Format-Fix) · wt-super-hostbelegung (Format-Fix)
    FERTIG       wt-ce-gnu (D2, 2 Commits — der Bericht sagt „landereif")
    NICHT LANDEN wt-super-d3 — Landestau-Review: Selbstbiss-Orakel hohl, wartet auf gtest-Umbau
    IN ARBEIT    wt-ce-fk (Warnungen) · wt-super-objectstat (Durchstich)

## IV.3 Die Posten, die am meisten kosten, wenn sie liegen bleiben

1. **xlsx-Writer Vollausbau #46b** — 8 Tage überfällige Zusage, 0 Produktions-Targets. Ohne das
   xlsx-Glied gibt es am 14.08. keinen Durchstich.
2. **`thesis:pdf` fail-closed machen** — hat nur einen `if`-Zweig
   (`COMDARE_TEXLIVE_AVAILABLE == "true"`), keinen Gegenzweig. **Der Durchstich endet am PDF** —
   ohne Fix kann F1 „grün" melden, ohne dass das letzte Glied je lief.
3. **Bau-Menge D-2** — dreimal gestellt, nie beantwortet; fünf konkurrierende Zahlen. Ohne sie hat
   die Kampagne keine Grundgesamtheit, und **jede Kampagnenzahl verletzt Prüffrage 1**.
4. **Freitags-Liefertabelle** — keinem der fünf Freitage ist ein Liefergegenstand zugeordnet
   (0 Treffer über 40 Dateien).
5. **`allow_failure` × 3** — `super:1841`, `ce:231`, `ce:659`. Drei lebende Gegenbeispiele zu einer
   Direktive, die „verboten" sagt.

---

# TEIL V — DIE FALLEN, die heute zugeschlagen haben

| Falle | Wirkung |
|---|---|
| **CI meldet nur bis zum ersten Riss** | 2 gemeldete Dateien, 8 echte. Immer den ganzen Bereich prüfen |
| **gitleaks zählt Merges nicht** | „7 scanned" bei 11 Commits — gegen `--no-merges` zählen |
| **`find -newermt '-40 minutes'`** | parst NICHT wie `-mmin -40` → lieferte „0 Dateien", obwohl fünf frisch waren |
| **`git bundle create` braucht ein REF** | eine nackte SHA → „Refusing to create empty bundle" |
| **Sicherung und `rm` im selben Block** | der `rm` läuft unabhängig vom `rc` → **K14**, 14 s nach „nicht löschen" |
| **`workflows/*.json`** | zeigt „completed" für **laufende** Stränge. Nur `agent-*.jsonl -mmin` misst |
| **ninja-deps beschädigt** | „premature end of file" → Header-Änderung löst keinen Neubau aus, Test meldet falsches „Passed". Heilung: `ninja -t recompact` (heute gefahren, 0 Warnungen) |
| **`workspace-write` bei Codex** | auf prod1 defekt (bwrap). Nur `danger-full-access` läuft |
| **prod1 hat 16 Kerne, nicht 24** | die 24 ist prod2s **Thread**-Zahl. OD-7 setzt 24 Worker auf 16 Kerne — offener Konflikt |
| **`/usr/bin/grep`** | ist hier **GNU grep 3.11**, `-P` trägt. Der PATH-`grep` ist ugrep 7.5.0 |

---

# TEIL VI — DIE FORENSIK: nichts ist verloren

Auf Owner-Auftrag geprüft (Fable 5 xhigh): **~78 Löschungen in 12 Ereignisgruppen** (02.–09.08.),
Nenner 521 Transkript-Dateien / 245.453 Zeilen / 510 rekursive `rm`, 17 gelöschte Branch-Tips am
Objekt verifiziert, `fsck`-Vollfegen, **alle 43 verwaisten Objekte einzeln zugeordnet**.

**Genau ein Fall trug ungelandete Arbeit** (K14, `4bce1336`). **Nichts muss wiederholt werden.**
Die Doktrin hielt in **11 von 12** Gruppen. Auslöser war jedes Mal Plattendruck.

**K-14 ist geheilt, ohne ihn nachzubauen:** die Vorlage `404ff6cf` lebt, verloren war nur der
uncommittete Delta. Der Beleg ist neu erhoben — `279` Testziele dort gegen `286` auf development,
direkt aus dem Objektspeicher ohne Checkout. Nachbauen wäre unehrlich gewesen: der Stand von 06:38
ist nicht rekonstruierbar, ein heutiger „Schnappschuss" trüge denselben Namen und anderen Inhalt.

---

# TEIL VII — DIE FÜNF REGELN, die am meisten sparen

1. **Erst lesen, dann fragen, dann bauen.** Gedächtnis → Review → Explore → Design → Bauen →
   Verify. Kein Explore und **kein Review** für Dokumentiertes.
2. **Der Nenner gehört in die AUSGABE.** Nicht „3 Fehler", sondern „3 von 14". Eine Null ohne
   Gegenprobe ist kein Befund, sondern ein möglicherweise kaputtes Kommando.
3. **Der Köder muss erst beißen** (K13), frisch gewürfelt aus `/dev/urandom`, nie aus einer Doku
   abgeschrieben. Und er muss **sein eigenes Riss-Literal** vorweisen.
4. **Was erzwingt das Halten — Werkzeug, Disziplin oder Zufall?** Nur die erste Antwort zählt.
   *„Wir achten darauf"* gilt als nicht abgenommen.
5. **Berichte sind Beweismaterial, kein Beweis.** Heute meldete ein Verify *„ce-CI führt KEIN
   clang-format-Gate"* — es existiert und hat hart rot gemacht. Auch **Selbstkritik** ist
   prüfbedürftig: ein Bauender schrieb sich einen Defekt zu, den es am Objekt nicht gab.

---

**Wo du anfaengst:** beim roten `lint:format` in beiden Repos, dann bei den 17 landebereiten
Commits, dann beim **Durchstich** -- er ist der F1-Liefergegenstand vom Freitag 14.08. und
kann heute strukturell nicht laufen.

Und ohne Eile im falschen Sinn: **der Plan traegt die volle Gruendlichkeit, er ist darauf
gerechnet.**

---

# TEIL VIII — DIE STUMM GESTORBENEN STRÄNGE (Nachtrag 09.08. abends)

**Owner-Auftrag:** *„durchsuche den session log ... welche Workflows durch das Speicher-Problem
nicht fertiggestellt wurden und nie zurück kamen, sie sind ohne Alarm verschwunden."*

## VIII.1 Wie man sie findet — und woran der erste Detektor scheiterte

Die Platte lief auf **0 Bytes** voll (`/home` und `/tmp` liegen auf **derselben** Partition
`/dev/nvme0n1p2`). Danach konnte der PreToolUse-Hook sein `uv run` nicht mehr starten und
**jedes** Werkzeug fiel aus — Bash, Read, Write, ToolSearch. Stränge, die in diesem Fenster
fertig wurden, konnten ihre Rückmeldung nicht mehr zustellen: **kein Alarm, kein Fehler, Stille.**

Erster Ansatz war **falsch** und ist hier dokumentiert, damit ihn niemand wiederholt: gestartete
Task-IDs gegen `<task-id>`-Notifikationen im Transkript zu stellen ergab 193 gegen 175, also 20
Verdächtige. **Die Gegenprobe kippte das Ergebnis** — `wni7nfzlm` stand auf der Liste, war aber
nachweislich mit vollem Ergebnis zurückgekommen. Auch die Dateigröße trügt: dessen
`tasks/<id>.output` hat **0 Bytes**, weil die Platte voll war, während das Ergebnis über die
Notifikation ankam.

**Was wirklich trägt:** `subagents/workflows/wf_*/journal.jsonl`. Dort legt **jeder** Agent seine
Rückgabe ab, unabhängig von Notifikation und Puffer. Ein Journal mit `results > 0`, zu dem nie
eine Zusammenfassung eintraf, ist ein stumm gestorbener Strang — **und sein Inhalt ist bergbar.**

    grep -c '"type":"result"' journal.jsonl   # je Workflow: hat er geliefert?

## VIII.2 Was geborgen wurde

| Strang | Zeit | Inhalt | Zustand |
|---|---|---|---|
| `wf_fa2f2328-b98` | 15:44 | **Warnungs-Erhebung GCC** (Owner-Auftrag) | geborgen, s. VIII.3 |
| `wf_d213d405-6c2` | 15:22 | D5-2 · Paket ##08 · Paket ##11, je **mit Verify** | 3 Pakete, alle bestätigt |
| `wf_1a3dfe5a-b6d` | 15:20 | 6 Befund-Berichte (Wachen, die Deckung vortäuschen; Lande-Analyse) | ungelesen |
| `wf_110255b3-6ac` | 14:29 | 6 Berichte (Memory-Audit, Zahlen-Audit, Betriebspunkte) | ungelesen |

**Die drei verifizierten Pakete sind committet und ungepusht** — `08cab824` (`wt-super-d52`,
D5-2), `03f897dd` (`wt-ce-schema`, B-3 + Schema-Freeze), `2703814f` (`wt-ce-selection`, ##11).
Ihre Abnahmen lauten wörtlich *„BESTAETIGT"*, *„Paket abnahmefaehig"*, *„Der Bau-Bericht HAELT"*.
Sie warten nur auf die Lande-Runde.

# TEIL IX — WARNUNGS-ERHEBUNG, RUNDE 1 (GCC) — geborgen aus dem stummen Strang

## IX.1 Der Befund, der die Vorbefunde korrigiert

**„Das Projekt übersetzt ohne `-Wall`" ist zur Hälfte falsch und dadurch irreführend.** Am Objekt:
`cmake/compiler_flags.cmake:6` definiert `COMDARE_set_default_warnings()` mit neun Warn-Flags —
und hat **genau einen Aufrufer**, `COMDARE_add_test`. Also **nur Test-Binaries**.

    Komponente        mit -Wall   ohne
    libs/ (CE-BIB)        0        16     <- die Bibliothek sieht sich selbst NIE
    apps/                 0         9
    tools/                0        12
    tests/              197       309
    SUMME               201       349

Bibliotheks-Kompilierzeile: `-O3 -DNDEBUG -std=c++23` — **sonst nichts.** Die präzise Aussage ist
also: *`-Wall` auf 201 von 550 Zielen, davon **0** in `libs/`.*

**Konsequenz:** die 2.447 CI-Warnungen stammen ausschließlich aus Test-Übersetzungseinheiten.
Die reinen Bau-Jobs `pmc:amd`/`pmc:intel` melden **0 Warnungen** — nicht weil der Code sauber ist,
**sondern weil niemand hinsieht.** Das ist der Owner-Begriff MUTANT, angewandt auf die Warn-Wache
selbst.

**Nenner:** 46 Traces, 38.078 Zeilen, 2.447 Warnungen, **88 distinkte Stellen** (Verstärkung
27,8x — ein Header in vielen TUs). Lokal auf der projekteigenen Stufe: **62 Warnungen, 43
distinkte Stellen, 0 Baufehler** bei 174 Zielen. Das ist die ehrliche Kostenzahl.

## IX.2 Die Defekte (der Rest ist begründetes Rauschen)

- **D1 · `-Wswitch`, `pruef_dock_version.hpp:75`.** HY-A1 hat `AnatomyGenus` **heute** um
  `FunctionInterfaceReroute` erweitert. Von den drei Switches wurden **zwei nachgezogen, der
  dritte nicht** — genau der, den keine Wache beobachtet. Folge: `pruef_dock_version_stamp()`
  stempelt für ein Hybrid-Dock einen **leeren** Versionsstring: eine Provenienz-Lücke. Der
  Kommentar darüber behauptet weiter, es gebe „FUENF" Werte. Und
  `heuristik_adapter_klassifikation.hpp:26` **sagt den Fall wörtlich vorher**. Die Vorhersage ist
  eingetreten.
- **D2 · SPEICHER, `result_aggregator.hpp:19`.** `std::uint64_t fingerprint;` ist das **einzige**
  Mitglied ohne Initialisierer; der Copy-Konstruktor liest den unbestimmten Wert — **UB**. Die
  Ursache sitzt im Struct, nicht im Test.
- **D3 · `super build:clang` ist FAILED, nicht skipped.** `overlay_source_hash_generated.hpp` nicht
  gefunden: der Verbraucher wird in Schritt 11/110 gescannt, der Erzeuger erst in 15/110 gebaut.
  Eine **fehlende CMake-Abhängigkeitskante**. GCC fällt nicht darauf herein, clang schon.
- **D4 · `ce build:clang` fährt nie**, weil `COMDARE_CLANG_MATRIX` nirgends gesetzt ist. **Damit ist
  die Frage aus Posten #43 beantwortet: die clang-Warnungen dieses Projekts hat noch nie jemand
  gesehen.** Vor Runde 2 muss D3 geheilt sein, sonst läuft ce in denselben Fehler.
- **D5 · `profile_to_tree.hpp`, 7 Stellen.** `block_id` bleibt leer — die als „Bidirektionalität"
  dokumentierte Rück-Referenz ist für profil-erzeugte Bäume **nicht hergestellt**. Als
  Speicher-Warnung Rauschen, als Fachlogik ein Befund.

**Nicht gefunden:** `-Wold-style-cast`, `-Wcast-align`, `-Wnon-virtual-dtor`,
`-Woverloaded-virtual` liefern **null**. Der Baum ist besser, als die Rohzahl 2.447 suggeriert.

## IX.3 Die Vorlage zu `-Wall`/`-Werror` — Entscheidung des Owners

Es muss **keine neue Regel erfunden** werden: die Warnstufe existiert bereits und ist für Tests
bindend. Vorgeschlagen wird nur, sie auszudehnen.

1. **Stufe 1 (unstrittig):** die 43 distinkten Stellen beheben. 0 Baufehler bei 174 Zielen.
2. **Stufe 2:** `COMDARE_set_default_warnings` auch für `libs/`, `apps/`, `tools/`. Danach sieht
   die Bibliothek zum ersten Mal ihre eigenen Warnungen.
3. **Stufe 3 (`-Werror`), erst danach und zuerst nur auf `libs/`.** Global sofort macht die
   Pipeline rot (Tests tragen 88 Stellen, darunter 16x `-Wdangling-else`).

**Nicht verhandelbar:** die Warnstufe wird nicht gesenkt, keine Klasse global abgeschaltet.
Unterdrückung nur eng begrenzt und mit Begründung (einziger Fall: D7, ein absichtlicher
`volatile`-Sink im Mess-Pfad).

## IX.4 Die Lehre für den Betrieb

**Ein fertiger Strang, dessen Rückmeldung nicht zugestellt werden kann, sieht aus wie ein Strang,
der noch arbeitet.** Es gibt keinen Unterschied von außen. Deshalb gilt ab jetzt: bei jedem
Verdacht auf Stillstand **zuerst `df -h`**, und die Journale sind die Quelle der Wahrheit, nicht
die Notifikation. Und: `/home` und `/tmp` teilen sich eine Partition — ein Bau-Strang in Debug
**und** Release kann die Sitzung handlungsunfähig machen.

---

# TEIL X — WARNUNGS-RUNDE 1: WAS WIRKLICH LIEF, UND WAS ICH SELBST ZOG

## X.1 Die Bilanz des Strangs, ehrlich aufgeschlüsselt

Der Strang `w8bktp12p` hatte vier Phasen. Er ist **nicht gestorben** — er **hing** seit dem
Plattenausfall und lief noch, als ich ihn für tot hielt. Das war mein Fehler: die Fehlermeldung
sagte wörtlich *„is still running"*, und ich habe sie als Formalie gelesen statt als Befund.
Der Resume hat danach das Journal auf **einen** Eintrag zurückgesetzt.

| Phase | Modell | Stand | Woher geborgen |
|---|---|---|---|
| 1 Erheben | opus | **fertig**, 12.548 Zeichen | `journal.jsonl` |
| 2 Codex | opus | **nie durchgekommen** | s. unten |
| 3 Heilen | opus | `NULL Codeaenderungen` (Umgebungsblocker) | `agent-a02feb…jsonl` |
| 4 Verify | fable | nie gestartet | — |

**Zu Phase 2, weil der Befund zählt:** die einzige Codex-Antwort im ganzen Transkript lautet
*„The tool use was rejected."* Die drei Codex-Agenten haben **keinen** Bericht geschrieben (ihre
längsten Texte sind 194, 180 und 140 Zeichen). Was in ihren Transkripten steckt, sind eigene
Lesevorgänge — sie haben den Quelltext selbst analysiert, weil das Werkzeug nicht ansprang.

**Ein Fund daraus ist trotzdem wertvoll und gehört festgehalten:**

> *„`FunctionInterfaceReroute` wurde angehängt, diese TU neu übersetzt (die .o-Zeitstempel liegen
> nach dem Header-Edit, es war kein Cache-Artefakt) — **0 Fehler, der Test blieb grün**. Eine
> handgeführte Liste kann per Konstruktion nicht bemerken, dass das Enum länger geworden ist."*

## X.2 Phase 3 und 4 selbst gezogen — drei Heilungen, in ce committet

| Commit | Was | Beleg |
|---|---|---|
| `976f1ddb` | **D1** `-Wswitch` + **D2** uninitialisiertes Mitglied | s. unten |
| `b64bd1af` | **D8** `-Wcomment`, 476 von 2447 Vorkommen | Debug+Release je 0 |

**D1** — der Switch kannte fünf Fälle, `kAlleGenera` trägt sechs. Der Fall ist **ausgeschrieben**
statt durchzufallen: inhaltlich ist der leere `string_view` richtig (Weg C — ein
Klassifikations-Genus hat kein eigenes Dock), aber ein ausgeschriebener `case` hält `-Wswitch`
scharf, während ein Durchfall den nächsten neuen Wert wieder still mit leerem Stempel quittierte.
Der Kommentar, der „hat FUENF" behauptete, ist mitkorrigiert — **er hat den Defekt gedeckt**.
*Köder beißt:* ohne den Fall meldet GCC `enumeration value 'FunctionInterfaceReroute' not handled`
an Zeile 77, mit ihm null. Beide Richtungen gefahren.

**D2** — `fingerprint` war das einzige Mitglied ohne Initialisierer. **Hier ist der Beleg
schwächer, und das steht auch im Commit:** die Minimalprobe löst die Warnung nicht aus, die
Gegenprobe blieb stumm. Der Nachweis stammt allein aus dem CI-Log. Der Fix ist sachlich richtig,
aber **ein beißender Köder fehlt noch** — nachzuziehen, sobald `-Wall` auf `libs/` liegt.

**D8** — eine `///`-Zeile endete mit `\` und setzte den Kommentar fort. Hier folgte zufällig
wieder eine `///`-Zeile, es ging nichts verloren. Genau das macht den Fall lehrreich: **wäre die
Folgezeile Code gewesen, wäre sie still verschwunden.**

## X.3 Die nachgeholte Synthese (Phase 4)

Projekteigene Warnstufe — die neun Flags aus `COMDARE_set_default_warnings`, **nicht** das
schwächere `-Wall -Wextra`:

    -O0 -g         -> 0 Projekt-Warnungen
    -O3 -DNDEBUG   -> 0 Projekt-Warnungen

Der Nenner ist getrennt: was die Probe zusätzlich meldet, stammt aus dem **Wegwerf-Testprogramm**
(`old-style-cast`, `missing-declarations`), nicht aus dem Projektpfad. Wer das nicht trennt, hält
seine eigene Probe für einen Befund.

## X.4 Pipeline 15457 — vier rote Jobs, ZWEI Ursachen

    lint:format               -> GEHEILT (3a5268f3, super, ungepusht)
    build:clang               \
    analyse:thesis-data        > EINE Ursache: overlay_source_hash_generated.hpp fehlt
    visibility:tier-binaries  /

**Die Wurzel, am Objekt:** `cmake/overlay_source_hash.cmake:155` legt die Wartekante über
`PROJECT_SOURCE_DIR` — das ist **ce**, nicht super. Super bindet ce in `Code/CMakeLists.txt:211`
ein, seine eigenen Ziele entstehen aber erst ab **Zeile 302** und existieren zum Zeitpunkt der
Schleife noch gar nicht. Sie bekommen die Kante nie.

**Und der Bericht wird dadurch präzisiert:** die Erhebung hielt das für ein clang-Spezifikum
(*„GCC fällt nicht darauf herein"*). Gemessen fallen **auch die GCC-Jobs** darauf herein — es ist
eine echte fehlende Abhängigkeitskante, die je nach Ninja-Scheduling zuschlägt, kein
Übersetzer-Unterschied.

**Heilung (eigenes Paket, ce + Gitlink-Bump):** `cmake_language(DEFER DIRECTORY "${CMAKE_SOURCE_DIR}"
CALL …)`, damit die Kante läuft, wenn **alle** Ziele existieren — und automatisch für jedes
Überprojekt gilt, nicht nur für super. Der Kommentar an Ort und Stelle begründet bereits, warum
eine gepflegte Namensliste falsch wäre; die Doktrin bleibt also erhalten.

---

# TEIL XI — DIE GENUS-SCHICHTUNG (Owner-Praezisierung 09.08. abends)

**Auslöser:** ich hatte Gattung und Genus als „zwei getrennte Achsen" bezeichnet. Der Owner hat
das in vier Sätzen richtiggestellt, und die Korrektur reicht tiefer als eine Begriffsfrage.

## XI.1 Die Schichtung, vollständig

    GATTUNG                Kerninterface -- alle ihre Genus teilen es
       |                   (wie die C++-Standardcontainer ein gemeinsames Interface teilen)
    GENUS                  erbt das Kerninterface + eigene SPEZIAL-Funktionen
       |                   >>> DAS sieht das PRUEFDOCK DER CEB <<<
    GENUS_impl             ABSTRACT FACTORY -- eigene Datei
       |
    je Funktion EINE       jede traegt EINEN Hauptalgorithmus
    separate Klasse
       |
    Achsen-Interfaces      der Hauptalgorithmus stuetzt sich AUSSCHLIESSLICH auf sie;
                           sie duerfen REKURSIV und quer zu anderen Gattung+Genus aufrufen

**Und die Gleichung, die alles adressierbar macht:** Gattung + Genus werden als **einzelnes
Genus-Binary** kompiliert, und dieses ist **exakt ein Tier-Binary**. 1:1, keine Aufteilung.

## XI.2 Was daraus folgt — vier Punkte, die den Bau berühren

**Der Hauptalgorithmus rechnet nicht, er orchestriert.** *„Ausschließlich durch Achsen-Interface-
Aufrufe gestützt"* heißt: jede Rechenleistung liegt in einer **Achse**, der Algorithmus verbindet
sie nur. Das ist der Grund, warum die Achsen überhaupt messbar sind — sie sind die einzige Stelle,
an der Arbeit stattfindet.

**Der Aufrufgraph ist ein Netz, kein Baum.** Achsen-Aufrufe dürfen sich rekursiv und **quer zu
anderen Gattung+Genus** aufrufen. Wer Kombinatorik über Achsen rechnet, darf nicht annehmen, dass
ein Genus nur „seine eigenen" Achsen berührt.

**Das Genus-Interface ist die ABI-Fläche zur CEB.** Das Prüfdock sieht **es** — nicht die `_impl`,
nicht die Funktionsklassen, nicht die Achsen darunter. Alles, was die CEB braucht, muss
**metaprogrammiert an dieser Fläche** bereitstehen, nicht zur Laufzeit nachgereicht werden.

**Die Lager-Adresse ist damit vollständig.** Weil Gattung+Genus genau ein Binary ergeben, gibt es
unterhalb nichts mehr zu unterscheiden — `gattung=<token>/genus=<token>` adressiert eindeutig. Das
erklärt, warum `lager_baum_writer.hpp` beide Ebenen als Wurzelpaar führt, und warum ein Genus
**ohne** Lager-Token nicht einsortierbar ist (WACHE 4).

## XI.3 Die Falle, in die ich gelaufen bin

Ich hatte aus „zwei Achsen" kombinatorische Schlüsse gezogen — an einer Stelle, an der eine
**Vererbungsbeziehung** steht. Die Achsen liegen erst **unter** der `_impl`, im Hauptalgorithmus.
Wer die Ebenen für Achsen hält, sucht Kombinatorik dort, wo Hierarchie ist.

**Was von der WACHE-3-Messung unberührt bleibt:** die Zahlen. Sie permutiert `for a=0..255 ×
for b=a+1..255` = **32.640 Paare**, real sind es **4 Gattungen (6 Paare) + 6 Genera (15) = 21**,
Faktor **1.554**. Die Ursache ist nicht „zwei Achsen im selben Iterationsraum", sondern schlichter:
**der volle `uint8`-Raum wird permutiert statt der tatsächlich existierenden Enumeratoren**, und
die Orakel werden je Paar neu gerufen statt einmal eingesammelt.
