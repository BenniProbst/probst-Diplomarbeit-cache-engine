# KONTEXTÜBERGABE 11.08.2026, NACHT 7b — DIE NACHT DER WIDERLEGTEN EIGENEN ZAHLEN

> **Stand:** Di 11.08.2026, spät · **F1 in 3 Tagen** (Fr 14.08.) · **Abgabe in 35 Tagen**
> **Einstieg für die Nachfolge:** Ledger-Kopf lesen — **KON15 · KON14 · KON13 · KON12 · KON11 ·
> KON10 · KON9 · KON8-12** stehen übereinander. **KON13 und KON15 sind die geltenden Fassungen**
> der Architektur; KON9/KON10/KON11/KON12 sind dort an neun Stellen korrigiert.

---

## IN EINEM SATZ

Der Owner hat **volles Risiko** entschieden — die komplette Träger-Baukette wird gebaut, alle Teile
in Reihenfolge, Wellen unverändert —, und ein Konsistenz-Review hat im selben Zug **drei meiner
eigenen Messungen widerlegt**, alle aus derselben Ursache: *ich habe über den Namen gesucht, nicht
über den Gegenstand.*

---

## 1. DIE ARCHITEKTUR — was jetzt gilt

### 1.1 Der Hybrid ist Glied der MESS-Kette

**Weil er nicht bauen kann, nur messen.** Das löst den Widerspruch W-1 auf, der einen halben Abend
blockierte — und die Antwort lag die ganze Zeit als Owner-Wort im Ledger (KON8-12, 16:12).

```
MESS   (Planer → CEB → [Hybrid →] Tier)          3 ohne Hybrid  ·  4 mit
SYSTEM (CEB → Tier ‖ CEB → Hybrid, PARALLEL)     2  ·  2
ORGAN  (CEB → Tier)                              2  ·  2
```

Owner, 17:41: *„die Tier-Binaries erreichen **SEPARAT** … **ABER UNABHÄNGIG VON HYBRID**, weil die
CEB das Hybrid und jede Tier-Binary **GLEICHRANGIG** aufbaut … **das Hybrid kann nicht bauen**."*

### 1.2 Vier-Parteien-Kette mit dreiphasigem Kern

Owner, 21:24: *„2 parallele DREIPHASIG Verträge über die Mess-Achse … **Konzeptionell hat die CEB
hier 2 dritte Phasen**, die sie als Kopf steuert, **in der Anordnung des Ortes allerdings 4
Phasen**."*

⇒ **S-4 baut nicht einen vierstelligen Vertrag, sondern zweimal einen dreistelligen, parallel.**

### 1.3 Zwei Grammatiken, nicht drei — und eine existiert schon

| | Gegenstand | Zustand | Auftrag |
|---|---|---|---|
| **G-1** | Mess-Achse, dreiphasig | fehlt ganz | **vereinfachte** Grammatik — **Entwurf ist meine Bringschuld** |
| **G-2** | System **und** Organ, zweiphasig | **Syntax existiert** | **Semantik nachholen**, in Reihenfolge der Achsen-Nummerierung |

### 1.4 Der Stempel trägt fünf Rollen — zwei sind durchgesetzt

Identität · **Cache-Schlüssel** · **Lager-Schlüssel** · Skip-Marke · Einordnung.
**Durchgesetzt: Identität und Einordnung.** Lager-Schlüssel und Skip-Marke haben **nur
Test-Aufrufer**; Cache-Schlüssel ist offen.

🔴 **Die Fehlerklasse daraus:** eine Änderung ohne `X.Y.Z`-Bump ⇒ kein Neubau ⇒ der Lauf ist
**schneller und falsch**, und der Cache-Treffer sieht aus wie Erfolg.

### 1.5 Die Cache-Landschaft — Owners letztes Wort

```
local  = Dateisystem, lokal ODER im Netz      minio = S3-Speicher im Netz

(1) CCACHE              Tools + Compiler, hot zum Job, nie auf prod1/prod2 behalten
(2) BUILDSYSTEM-NAS     Lager-Items: Projekt-Binaries UND Messungen
(3) CACHE-ENGINE-       Cluster_NFS, AUSGABE: nur finale Zusammenfassung, LaTeX, PDF
    EXPERIMENT          + explizit in der XML angeforderte Einzelnachweise

RUNNER dürfen LESEN:  (1) ccache auf minio.comdare.de   (2) das neue Buildsystem-NAS
                      SONST NICHTS.  ← letztes Wort
```

**Folge:** das bestehende XSD-Enum `{local, minio}` **trägt die Owner-Semantik bereits** — kein
Vokabular-Bruch, kein Schema-Neubau. Der `s3`-Fehlertest bleibt gültig.

---

## 2. 🔴 DREI EIGENE MESSUNGEN, WIDERLEGT

| Meine Aussage | Am Objekt | Warum |
|---|---|---|
| `LagerBaumWriter` **0 Aufrufer** | **9 Test-Aufrufe** über die Factory | ich suchte den **Klassennamen** |
| Compile-Zeit-Pflicht **nie gebaut** | **18 Basis-Header** mit `static_assert` | ich durchsuchte nur die 62 `concepts/` |
| „7 gegen 9, **nicht aufgeklärt**" | **6 gegen 6, kein Rest** | 7 zählte Prosa mit, 9 zählte Kommentarzeilen mit |

**Dieselbe Ursache dreimal — und sie ist heute zur Doktrin geworden** (Arbeitsweise **v3.3 / A2.2**):

> **Nach dem GEGENSTAND suchen, nicht nach dem Konsumenten.** Eine Konsumenten-Suche findet bei
> einem unverdrahteten Modul **nichts** und meldet „fehlt".

**Und die Schrägstrich-Falle hat wieder zugeschlagen:** `-path '*/build*/*' -prune` fraß
`libs/cache_engine/**builder**/` → 370 statt 371. Per Gegenprobe gefangen. Sie steht seit Wochen im
Fallen-Register.

---

## 3. WAS HEUTE NACHT GELANDET IST

| SHA | Gegenstand |
|---|---|
| `5686a50e` | KON8-12 — Teilmengen-Prüfung gilt überall, der Vertrag nur einmal |
| `8205e980` | **KON9** — Stempel-Architektur, 12 Abschnitte |
| `1438225b` | Pause-Doku mit Bergungsanweisung |
| `ab7c936e` | Ernte der Explores |
| `869f6a2b` | **KON10** — der Selbstkompilations-Entwurf ist gefunden |
| `cc255fd8` | **Wellenplan §13** — Aufgabenstand-Konsolidierung, drei Wirkungsklassen |
| `c3189e06` | **Wellenplan §14** — die Träger-Baukette, 17 Bau-Teile in Reihenfolge |
| `870af088` | **KON11** — Arbeitsprinzip + E-1/W-6/W-7 |
| `4954993a` | Owner-Vorlage, zwölf Entscheide |
| `32b1947d` | **KON12** — P-0 entlastet |
| `57015c39` | Plan-Anker nachgezogen — **super-Pipeline geheilt** |
| `270ceff8` | **KON13** — Konsistenz-Prüfung, Auflösung durch Owner-Wort |
| `1ecc605a` | **Wellenplan §15** (zehn Korrekturen) + Owner-Vorlage |
| `ec6412e2` | **Backup** der vier Workflow-Läufe |
| `45daccec` | **KON14** — zwei Synthesen, drei widerlegte Zahlen |
| *dieser* | **KON15** + diese Übergabe |

**Im Umbrella `comdare/projekte` (nur GitLab):**
`8b51f17` Arbeitsweise **v3.3** (A2.2 Bestands-Pflicht) · `e891b4a` + `531d0ea` **v3.4**
(Synthese auf Fable 5 max).

**Ledger: 20.354 → 21.694 Zeilen. Wellenplan: 1279 → 1921 Zeilen.**

---

## 4. DIE VIER WORKFLOWS — 155 Agenten, 0 Fehler

| Lauf | Gegenstand | Agenten |
|---|---|---|
| `wf_296a2353-2d6` | Stempel-Explore | 50 |
| `wf_e9b2cd97-d5f` | CI-Explore | 36 |
| `wf_07d6a08d-13a` | Konsistenz-Review | 27 |
| `wf_a2e3281c-663` | Nachtrag | 42 |
| `wf_2398a27a-a41` | Synthese auf Fable 5 max | 1 |

**Alles gesichert:** `docs/sessions/backups/20260811-workflow-rohdaten-stempel-ci-konsistenz/`
— vier Läufe, **226 Journale**, die Skripte, das Ernte-Werkzeug und **beide Synthesen**
(Opus 23.545 · Fable 33.936 Zeichen). Vier × `no leaks found`, mit vorher belegtem 20-Zeichen-Köder.

**Beide Synthesen werden aufgehoben, weil sie nicht redundant sind:** die Fable-Fassung hat vier
Punkte selbst am Objekt nachgeprüft und vier Befunde geliefert, die Opus nicht hat.
**Wo sie übereinstimmen, ist die Aussage doppelt getragen; wo sie abweichen, liegt der Fund.**

---

## 5. 🔴 WAS ALS NÄCHSTES ZU TUN IST

### Sofort, ohne Owner-Antwort
1. **Explore: die zwei Welten der Glieder-Reihenfolge** (KON15-02). *Im Lager* gilt eine andere
   Ordnung als *außerhalb* — belegt durch D-12 (zwei Kaskaden). **Bis das geklärt ist, wird an
   S-6 nichts gebaut**; eine pauschale Umstellung bräche eine der beiden Welten.
2. **Register der leeren Klassen** anlegen (KON15-01) — welche Klassen sind nur Hülle, und fasst
   eine Welle sie noch an?
3. **Die vier Zahlen nachziehen** (KON15-04, volles GO): 295→294 · „137"→123 · 124→130 ·
   13/7967→14/8528.
4. **G-1 entwerfen** — die vereinfachte Grammatik für die dreiphasige Mess-Achse. **Meine
   Bringschuld**, vom Owner ausdrücklich angefordert.

### Blockiert auf Owner-Antwort
5. **O-1** — Syntax und Semantik je Achsen-Kategorie über `c` hinaus. **Abgabe-Pflicht**,
   Kipp-Punkt **K-1 = Fr 14.08.** Ohne sie steht S-2 und mit ihm die Kette.
6. **O-3** — fordert ein Flag seine Voraussetzung, oder impliziert es sie? Entscheidet, ob S-3 eine
   **ablehnende Wache** oder ein **Normalisierer** wird.
7. **O-6 · O-7 · O-8 · O-10 · O-11** — blockieren S-12 (CI-Gerüst) **vollständig**.
8. **O-12 Fork E · O-13 Fork B · O-14 Fork R1** — blockieren S-8.

### Betrieb
9. **ce-Pipeline 15682 ist rot** — nächster Gegenstand nach dem Stempel. Hängt an **#84**
   (zwei Tests fallen auf unverändertem `development`) und **#80** (coverage-guard, zwei Ursachen,
   davon eine Sollverhalten).
10. **#89 wächst gegen die Doktrin:** `ci/tests/*.sh` **14 Dateien / 8528 Zeilen**, **0 von 14
    retired**.

---

## 6. DIE FALLEN, DIE HEUTE ZUSCHLUGEN — für die Nachfolge

1. **Über den Namen suchen statt über den Gegenstand** — dreimal, siehe §2.
2. **`grep -v /build` / `-path '*/build*/*'` frisst `/builder/`** — wieder.
3. **Die CI-Formel nachbauen statt fahren:** mein Zähler lieferte 59 statt 40, weil
   `git grep -n <SHA>` **vier** Felder liefert, nicht drei.
4. **Zeilenanker auf lebende Dateien:** der Ledger wuchs an einem Abend um **1340 Zeilen**; Anker
   drifteten um ~840. **Anker über KON-Kennung oder Symbol.**
5. **Ein binäres `widerlegt`-Flag** trennt „falsch" nicht von „fast richtig" — neun als widerlegt
   markierte Verifikationen **bestätigten** den Befund.
6. **Still gekürzte Owner-Zitate:** dreimal in einer Nacht, einmal wurde ein Ende **vor einem
   Blocker-Folgesatz** gekappt. **Regel ab sofort: jede Kürzung trägt `[…]`.**
7. **`rc` nach einer Pipe** misst das letzte Glied — zweimal aufgetreten.

---

## 7. BETRIEBSSTAND

```
super  development = <dieser Commit>   (beide Remotes)
ce     development = 670483c0          Pipeline 15682 ROT
Projekte           = 531d0ea           (nur GitLab — der Gesamtplan geht nie ins Internet)

Ledger      21.694 Zeilen      Wellenplan  1921 Zeilen
Platte      ~20 G frei         alle Worktrees sauber
Gitlink super→ce steht auf 670483c0  ← der Bump IST vollzogen (die Pause-Doku sagt fälschlich
                                        das Gegenteil; der Plan-Anker hinkte, nicht der Gitlink)
```

**Durabel außerhalb des Job-Verzeichnisses:** `/home/comdare/ernte-20260811-nacht7/` — Ernte,
Rohjournale, Skripte, beide Synthesen, die Owner-Antworten dieser Nacht.

**Werkzeuge, die weiterleben:** `~/.claude/jobs/5a19728e/tmp/pipeline_debug.py` · `job_trace.py` ·
`ce_pipeline_wache.py` · `ernte_journal.py` · die fünf Workflow-Skripte.

---

## 8. DIE OFFENEN FRAGEN — vollständig

**Beantwortet durch KON15:** Vokabular · Mount/Filterpod · Schema-Form (teilweise) · O-2 · O-9 ·
F-2 · F-3 · F-4.

**Es bleiben, gruppiert:**

**Grammatik/Stempel — fristnah an K-1 (Fr 14.08.)**
* **O-1** Syntax **und Semantik** je Achsen-Kategorie über `c` hinaus. Abnahme des G-1-Entwurfs
  oder eigene Vorgaben?
* **O-3** Fordert das Flag seine Voraussetzung, oder impliziert es sie?

**CI-Gerüst — blockiert S-12 vollständig**
* **O-6** Child-Pipeline oder Job-Gruppe?
* **O-7** Kind-YAML statisch eingecheckt oder vom Planer emittiert?
* **O-8** Wo sitzt der Hybrid bei ausgeschöpftem Nesting-Budget?
* **O-10** Je Träger-**Typ** oder je **Instanz**? *(Die kursierende Empfehlung „je Typ" stammt
  nachweislich von mir — 3 von 3 Fundstellen `type=assistant`, keine Owner-Quelle.)*
* **O-11** Was heißt „eigene Bedürfnisse" — nur Bau+Test, oder eigene Mess-/Release-/Cache-Stufen?

**Cache — vor jedem S-13-Bau**
* **Die Routing-Regel**, die KON13-04 fordert und nicht definiert: was macht ein Mess-Artefakt
  „individuell in der XML angefordert"? Positivliste je Nachweis, oder Klassenregel mit Opt-in?
* **Dritter Genus-Wert** für Tools/Compiler neben `{binary, measurement}` — ja oder nein?
* **Zeitpunkt:** bleibt der XML-Konsum „post-Abgabe", oder ist S-13 durch KON13-04 vorgezogen?

**Inventur/Buchführung**
* **C-1-Zählweise:** zählt „Einhängepunkt aktiv, Inhalt leer" als aktiv genutzt? (5 oder 6 von 11)
* **C-4-Bauform:** die heuristik-Wache um `axes/` **erweitern** oder eine **zweite** daneben?
  Beide Lesarten sind mit „trennen **und** verdrahten" vereinbar.
* **GN-8-Rest-Priorität:** der Ledger führt „niedrig" **und** „hoch".
* **STUFE/PHASE:** ist die „phasig"-Sprache seit KON7 eine bewusste Umbenennung der 06.08.-Vokabel
  „Stufe" — oder ein Rückfall in genau die Kollision, vor der das Klärungsdokument warnt?

---

## 9. WAS AUSDRÜCKLICH UNGEPRÜFT IST

* **14 von 18 Bau-Teilen** sind nie gegen den Code gemessen worden (nur P-0, S-14, S-17 und
  teilweise S-6).
* **S-4, S-8, S-10** — im gesamten Material **kein Befund**.
* Der **Stunden-/Tage-Aufwand** von S-1…S-18 steht an **keiner** Stelle. *„Termine unverändert"* ist
  aus den Dokumenten allein **nicht entscheidbar**.
* Die **ältere Session-Linie `46375cdc`** (~300 MB, bis 06.08.) wurde nicht direkt durchsucht.
* Die **Differenz 14** zwischen „137" und „123" Flag-Literalen.
* Die **Einzelzuordnung** der 35 Gegenproben des Nachtrag-Laufs — nur die Bilanz lag vor.

---

*Erhoben 11.08.2026 spät. Jede Zahl am Objekt gemessen oder mit Quelle. Wo eine frühere Aussage von
mir widerlegt wurde, steht die Widerlegung dabei — diese Nacht hat drei davon geliefert, und der
Bestand an Irrtümern ist selbst ein Datum.*
