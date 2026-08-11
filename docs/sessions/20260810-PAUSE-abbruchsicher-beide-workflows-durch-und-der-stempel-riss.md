# ABBRUCHSICHERE PAUSE — Mo 10.08.2026, 16:15

> **Alles ist gelandet oder gesichert.** Kein Arbeitsstand existiert mehr nur auf dieser Platte.
> **Beide Workflows sind durch**, keiner läuft mehr.
> **Stand:** super `0e11e1f8` · ce development **und** main `e114cabd` · beide Remotes sync

---

## 1. DIE ANTWORT AUF „IST ALLES GELANDET?" — JA, MIT NENNER

**Gelandet** heißt: in `development` und auf beiden Remotes.
**Gesichert** heißt: als eigener Branch auf GitLab, mit `ci.skip` gepusht — überlebt jede lokale
Löschung, ohne eine Pipeline auszulösen.

| | Zahl |
|---|---|
| Arbeitsbäume mit ungelandeter Arbeit | **0** |
| nur-lokale Branches vorher | **18** |
| davon jetzt auf GitLab gesichert | **18 von 18** |
| gitleaks-Funde über alle 18 | **0** |

### Gelandet (development, beide Remotes)

    super  0e11e1f8   Gitlink-Bump auf ce e114cabd, 71 Commits Rueckstand zu
           75e3ee7b   Hauptstrang-Bericht (32 Agenten)
           235c29ec   Kern-Urteile in die Uebergabe
           44b49194   Kontextuebergabe Nacht 5
    ce     e114cabd   PMC-Meta-Meta-Achse (I-PMC-2) + Merge
                      -> development UND main, gitlab UND github

### Gesichert (eigene Branches auf GitLab, nicht gemergt)

| Repo | Branch | Commits | warum nicht gelandet |
|---|---|---|---|
| ce | `bau/p1-taxonomie-klasse-i` | 1 | 2 falsche Zahlen im Commit, Suite unbewiesen |
| ce | `bau/p2-warnstufe-aufteilen` | 1 | 2. Lens: **3 Blocker**, Wache wird auf `make check` rot |
| ce | `bau/p3-ci-clang-pflicht` | 1 | 2 überlebende Mutanten |
| ce | `bau/p4-d2-partitions-koeder` | 1 | 2 Auflagen offen |
| ce | `bau/p5-tote-anker` | 1 | 5 Punkte offen |
| ce | `bau/p6-lizenz-umsetzung` | 1 | ce-Hälfte gebaut, super-Hälfte gegenstandslos |
| ce | `w0a/d2-floor` | 3 | **darf nicht gemergt werden** — s. §4 |
| ce | `b-m2-pmc-invariante` · `b-m3v2-pmc-window` · `b-pmc-errno-diag` · `w2-A13-M1b` · `w2-FK-1` | 2/1/1/6/6 | Altbestand, nie gesichert gewesen |
| super | `bau/p3-ci-clang-pflicht` · `b-checkheft-nachtrag` · `b-ci-rueckschrieb-beide-zeiger` · `b-e18-snap` · `landung/e18-snap` | 1/1/1/3/4 | dito |
| super | `f1/20-d3-6-transport` | 1 | frisch aus der F1-Kette |

**Zwei davon lagen in separaten Klonen** (`wt-ce-tax`, `wt-super-f1-transport`) — ihre Branches
sind in der Branch-Liste des Hauptbaums **unsichtbar**. Genau die Klasse, die beim Aufräumen
verschwindet. Ihr `origin` ist ein lokaler Pfad, deshalb schlug der erste Push fehl
(*„the receiving end does not support push options"*); sie wurden direkt gegen die GitLab-URL
gepusht.

**Nicht gesichert und bewusst so:** die drei `backup/pre-*`-Refs (1386 / 1913 / 1958 Commits).
Das sind Historien-Schnappschüsse vor Scrubs, kein Arbeitsstand.

---

## 2. ⭐ DIE OWNER-KORREKTUR, DIE DEN FIX ÄNDERT

> „Korrekt, aber **system sollte immer vorn stehen und organ hinten**. Das entspricht der
> Anordnung der Stufen."

Die Argument-Reihenfolge des Versions-Stempels ist **keine Konvention, sondern eine Abbildung der
Stufen-Ordnung**: System gibt frei, Organ setzt durch — die Freigabe steht vorn.

**Der IST-Stand ist falsch herum**, und das ist am Objekt gemessen:

    perm.cpp:   COMDARE_ANATOMY_VERSION_STAMP("<organ>", "<system>")

Damit sind es **zwei** Änderungen, nicht eine — vollständig in **Posten #76**:

1. den **3-arg-Zweig** treffen, damit der Mess-Stempel überhaupt gefüllt wird
2. dabei die Reihenfolge auf **system, organ** bringen

> Wer nur (1) macht, heilt den Riss **und zementiert die Stufen-Ordnung falsch.**

**Offen und vor dem Bau zu klären, nicht zu raten:** wo die **Mess**-Stufe in der Reihenfolge
steht. Der Owner hat in diesem Satz nur System und Organ geordnet.

---

## 3. WAS DIE ZWEI WORKFLOWS GELIEFERT HABEN

| Run | Agenten | Ergebnis |
|---|---|---|
| `wf_5834b706-7b5` Hauptstrang | 32/32, **0 Fehler** | 918 Werkzeugaufrufe · Bericht gelandet als `docs/plaene/20260810-HAUPTSTRANG-…md` |
| `wf_e22d25ef-71c` F1-Kette | 11/11, **0 Fehler** | 7 Kern-Urteile · der Durchstich-Riss |

### 3.1 Die Kern-Urteile — kein einziges „STIMMT"

| Paket | Urteil |
|---|---|
| D1b · D2-G1 · `d3-7` · `d3-3` · `##23` | **SCHON_ERLEDIGT** (5) |
| `##08` · `##20/D3-6` | **STIMMT_TEILWEISE** (2) |
| — | **STIMMT: 0** |

**An allen sieben geprüften Stellen ist der Wellenplan überholt.** Das ist der Auftrag von
Posten **#74** (Ernte-Vorschrift: Einschub, nie Überschreibung).

### 3.2 Der Hauptstrang-Kernbefund

**Null von fünf Paketen landefähig** — jedes hat mindestens eine Lens gegen sich. Darunter:

> In **fünf von fünf** Fällen war der *Bauauftrag* am Objekt falsch, weil er aus Plänen und
> Ledger-Zitaten gebaut war, die selbst veraltet sind.

Vier der fünf Bauenden haben ihren eigenen Auftrag widerlegt und einen Fehlbau verhindert.

**Der schärfste Einzelfund (P5):** der Ledger korrigierte in `KON2-15` eine tote Zeilennummer —
**auf eine zweite tote Zeilennummer**. Drei Zahlen für einen unveränderten Satz, die mittlere
geschrieben von jemandem, der gerade eine tote Zahl reparierte.

**B-1, B-2, B-3: der Owner hatte dreimal recht.** Alles war geplant und auffindbar.

---

## 4. WARUM `w0a/d2-floor` NICHT GEMERGT WERDEN DARF

Gemessen, nicht vermutet:

    scripts/ci_test_inventory_floor.txt      add/add-Konflikt
      development:  "EINE ZAHL JE HOST-KLASSE (D2-G5, 2026-08-10)"
      d2floor:      einstufig, 2026-08-09

**Ein Merge würde die Host-Klassen-Fähigkeit zurückdrehen** — eine Regression, getarnt als
Landung. Was wirklich fehlt, sind **5 von 15** Testfällen (development hat 41):
`AbgestuerztesCtestWirdNichtAlsLeererBaumGemeldet` · `HeilePartitionIstKeinBefund` ·
`InventurUnterDerUntergrenzeIstEinNennerBefund` · `PartitionsWiderspruchIstEinNennerBefund` ·
`UngepruefteGatesWerdenGezaehltOhneDenExitCodeZuAendern`. **Chirurgisch übernehmen**, Posten #64.

---

## 5. MEINE FEHLER DIESER RUNDE

| Fehler | Was ihn gefangen hat |
|---|---|
| **Monitor auf `glab` armiert**, das auf prod1 gar nicht existiert — 40 Minuten Schweigen, das wie „läuft noch" aussah | erst mein eigener Nachblick. **Regel jetzt: jeder Monitor prüft in Zeile 1 sein Werkzeug und meldet „WERKZEUG FEHLT" als Event.** |
| **Hygiene-Wache über den falschen Bereich** — grün über 55 Commits bis zum lokalen HEAD, während der FF-Bereich 71 umfasste | die Ausgabe nennt ihren Bereich selbst. Zweiter Lauf aus dem Worktree auf dem Ziel-SHA: **71 Commits, 14.663 Zeilen, 0 Nicht-ASCII** |
| **`args` beim ersten Resume weggelassen** → Workflow starb nach 9 ms mit `A.ce undefined` | die Fehlermeldung. Felder danach aus dem Prompt eines gelaufenen Agenten rekonstruiert, damit die Cache-Treffer halten |
| **`ce_sha: 95cb3039`** an den Workflow gegeben, während der Worktree auf `6c010cdc` stand (16 dahinter) | drei Bau-Stränge maßen es selbst und bauten deshalb nicht daneben |
| **two-dot statt three-dot** beim ersten d2floor-Diff → „13.023 Deletions", tatsächlich 12 | die Zahl war absurd genug zum Nachrechnen |

Alle fünf sind dieselbe Familie: **ein richtiges Messgerät am falschen Gegenstand.**

---

## 6. DER ZUGANG IST WIEDER DA

Der Infra-Agent hat den Cred-Vault gepullt; Cluster-Git `46ac4e0` — *„K144: GitLab master-PAT
Owner-Neuausstellung 10.08."*

**Geholt nach Vault-Doktrin, ohne die Datei je zu greppen:** 645 Zeilen blind per `mapfile`,
rückwärts Wort für Wort, gefiltert nur über Länge. Treffer **Zeile 637 von 645**, 11 Kandidaten,
Wert nie ausgegeben, abgelegt unter `jobs/5a19728e/tmp/.pat` (600).

**`glab` ist auf prod1 nicht installiert.** Der Weg ist `curl` gegen
`https://gitlab.comdare.local/api/v4` mit `PRIVATE-TOKEN`. Der PAT liegt im Job-tmp und
**verschwindet mit dem Job** — die nächste Session holt ihn neu aus dem DEV-Vault.

---

## 7. WO ES WEITERGEHT

**Zuerst** — Posten **#74**: die sieben Kern-Urteile in Wellenplan, Dossier und Goal v8
einarbeiten. Als Einschub nach Muster D2-G4/D2-G5, **nie als Überschreibung**. Ein Urteil, das
eine Welle oder einen Freitag bewegt, ist Owner-Vorlage.

**Dann** — Posten **#76**: der Stempel-Riss, mit beiden Änderungen.

**Parallel möglich:** die fünf gesicherten Bau-Pakete nachbessern (#62, #63, #66 …). Sie sind
gebaut, geprüft und liegen sicher — sie brauchen ihre Auflagen, nicht neuen Bau.

**Wellenstand:** heute Mo 10.08. → **F1 ist Fr 14.08., vier Tage.** Der Durchstich steht an
Stufe 1 und braucht #76 zuerst.

**Platte:** 18 G frei (93 %). Zwischendurch war sie auf 12 G — die Bau-Verzeichnisse wachsen
schnell. `df -h` vor jedem Vollbau.

---

*Kein Prozess läuft mehr. Kein Monitor ist armiert. Alle Arbeit liegt auf GitLab.*
