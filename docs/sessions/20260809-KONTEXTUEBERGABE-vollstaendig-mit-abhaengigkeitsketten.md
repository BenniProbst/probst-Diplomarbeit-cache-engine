# KONTEXTÜBERGABE 09.08.2026 — vollständig, mit Abhängigkeitsketten

> **Zweck:** Diese Session endet. Alles, was der Nachfolger braucht, steht hier — Entscheide,
> Befunde, offene Pakete und **wovon jedes Paket abhängt**. Wer nur eine Datei liest, liest diese.
>
> **Stand:** `super` 35 Commits heute · `ce` 14 Commits heute · **20 Ledger-Nachträge** · 18 offene
> Aufgaben · 3 Stränge laufend.
>
> **Die Stand-Quelle bleibt der Ledger** (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`,
> Nachträge **oben**). Diese Datei ist die **Landkarte**, nicht der Ersatz.

---

## 0. DIE DREI SÄTZE, die alles rahmen

**Frist 15.09.2026.** Lieferung freitags: **14.08.** · 21.08. · 28.08. · 04.09. · 11.09.
**Jeder Freitag steht allein.**

**Die Rechnung geht auf, seit der Owner sie korrigiert hat:** *„Rechne in 24 Stunden je Tag"* +
*„Wir streichen nichts."* 37 Tage × 24 h = **888 h** gegen ~770 h der ersten Registermessung.
**Der begrenzende Faktor ist nicht Zeit, sondern Parallelisierbarkeit** — und die hängt an
**einem Schreiber je Worktree**.

**Der Fertigstellungs-Maßstab ist Konformität, nicht Paketzahl:** *„fertig, wenn die Realität dem
Design entspricht"*, Konflikte per **neu schlägt alt**. Gemessen: **17 % erfüllt** über 256
bindende Aussagen.

---

## 1. OWNER-ENTSCHEIDE DES TAGES — alle, verdichtet

### Prozess und Rangfolge

| | |
|---|---|
| **Rangfolge** | **OWNER > PLAN > THESIS**, neuer schlägt alt. **Aber Stufe 3, nicht Stufe 1:** zuerst fragen *schließt es sich überhaupt aus?*, dann *lässt sich mehr Gründlichkeit erreichen?* → **mergen statt verdrängen**. **Thesis nachziehen ist erlaubt** — sie blockiert nie einen Bau. |
| **Explore** | **PFLICHT vor jeder Design- und Bau-Phase**, je Welle **und** je Strang. Korpus: `session-log` (die **rohen** JSONL!), Pläne, Sessions, Memory, Code, Thesis — neun Wochen. **Rate NIE.** |
| **Parallelität** | **bis zu 6 Stränge**, sofern **disjunkt** — dauerhaft. *(Für diese Session temporär auf 10 erweitert.)* ultracode und max effort **schließen sich nicht aus**. |
| **Wartepflicht** | Wenn ein Lauf das **Fundament der nächsten Aufträge** legt, wird **gewartet**, statt Slots zu füllen. |

### Die Verarbeitungskette — acht Stationen

```
XML → Planer → CEB
  → BAUEN    (Lagerhaltung + Hardware-Job-Pool über Maschinenfähigkeiten:
              gleiche CI für ALLE Maschinen, custom Filterung je Hardware-Freigabe)
  → MESSEN   (Lagerhaltung)
  → AUSWERTEN
  → RELEASE  + Hybrid-Bau
  → VERÖFFENTLICHEN (LaTeX und PDF)
```

**Diese acht Stationen sind zugleich die Explore-Auslöseliste.**

### HYBRID — fünf Entscheide, alle gefallen

**OV-13 (Zerlegung A/B/C): JA**, mit Vorbedingung — *„der Release wird VOR der Hybrid-Stufe mit
einem einzelnen direkten Tier-Binary am Prüfdock getestet und bewiesen"*. Die **CEB** verwaltet
compare und release über **statisches init** plus Übertragung der Heuristik-Funktionen bei
Verwendungsbeginn.

**E-1 (Klassifikation): C UND A — beides.**
- **C, Interface-Ebene:** `genus()` liefert das **geerbte Ziel-Genus**; der Pass-through ist
  transparent, die Hybrid-Natur steht im **Stempel**.
- **A, Klassifikations-Ebene:** **eigene Enum-Werte** für Gattung und Genus.
- **Warum A zwingend ist:** *„ein Graph benötigt ein anderes Reroute als SearchAlgorithm"* —
  der Reroute-Mechanismus ist **selbst variabel**. **Eigene Gattung mit MULTIPLEN Genus** (später).

**Drei harte Zusatzanforderungen:**
1. **2D-Matrix-Liste** mit Synthese-Funktionen **je innerem Layer × je Layer-Node**.
2. **C++20-Concept-Gate**, und die **Einschränkung muss HART PER TEST bewiesen werden** — der
   **verbotene** Fall muss **compile-time scheitern**.
3. **Strategy Pattern für JEDES Genus**, das bedient werden darf.

**K1 (Einlagerung): JA** — weitere Gattung+Genus im Lagerbaum. **Und die Ordnung ist präzisiert:**

```
Gattung → Genus → Binary  → System → Organ → Mess
Gattung → Genus → Messung → Mess   → System → Organ
```

Die Verzweigung **Binary/Messung sitzt UNTER Gattung/Genus**; die Kaskaden vom 26.07. bleiben als
„REST" unverändert. **Mein gemeldeter „Widerspruch" war keiner.**

**K2 (Loader): JA** — stufen-neutrale Bibliothek, *„weil das Prüfdock der CEB und das Prüfdock der
Hybrid-Tier-Binary technisch identisch bei Konfiguration sein müssen"*.

**K5 (Docks/Messung):** Dock-Zahl aus den **gemessenen Break-Even-Grenzen** und deren
Überschnitten; **Obergrenze PFLICHT in der XML, Default 32**. Die **vierte Mess-Ebene ist eine
SPALTE** im `checkpoint_measure` (welche Tier-Binary, exakter Stempel). **Overhead = Differenz**
zwischen Macro-Messung des Hybrid-Aufrufs und der **aus dem Vor-Release bekannten**
Einzel-Tier-Performance — **kein eigener Messkanal**.

### Messung, Auswertung, Ausgabe

**OV-16 — `allow_failure` ist VERBOTEN**, seit 06.07., am Objekt belegt. **Zwei Ebenen:**
**ZELLE** = „failed" + Warnung + **weitermessen** · **JOB** = **hart rot**.

**OV-17 — CSV ist eine Ausgabe-Strategie, kein Transportformat:**
*„csv ist ein Strategy Pattern in der Erzeugung der xlsx — alle Sheets einzeln in einem Ordner.
Aus csv wird kein xlsx, sondern umgekehrt."* Und: *„Flach ist falsch, die Struktur der
Lagerhaltung ist Pflicht."*

**OV-18 — CI UND lokal**, beide als Beweis. F1 gilt erst, wenn **beide** grün sind.

**Perzentil-Kanon für Konfigurations-Mediane: JA, aber NACHGELAGERT** — erst nach vollständiger
Granularität, in der compare-Phase, als Darstellungsform für LaTeX/PDF. **Nicht Teil des
Hardware-`checkpoint_measure`.**

**MeasureStorage** — `csv_to_latex` wird `measure_to_latex`. **`checkpoint_measure` hat ZWEI
interne Systeme:**

| | **MESS-ARENA** | **STACK-ARENA** |
|---|---|---|
| Zweck | die Messergebnisse | **wo bin ich?** Ebene + Modul + Funktion |
| Zugriff | **nur APPEND** | **LIFO** |
| Wachstum | monoton | auf und ab |
| Dimension | Ereigniszahl (`--check-size`) | **Verschachtelungstiefe** |
| Auswertung | zum Schluss | während des Laufs |
| Inhalt | POD-Records | **Referenzen**, keine Kopien |

**Überlauf ist ein Fehlerklassen-Unterschied:** volle Mess-Arena = **Datenverlust** (laut!),
voller Stack = **Programmierfehler**. **Getrennte Cachelines Pflicht.**

**prod2 wird umbenannt** (real Alder Lake, nicht Raptor Lake) — Byte-Ereignis, in ein Bump-Fenster
legen.

---

## 2. DIE ABHÄNGIGKEITSKETTEN — das Kernstück dieser Übergabe

### Kette A — HYBRID (die längste, F2-kritisch)

```
[E-1 ✔]  Gattung+Genus anlegen  (Strang 34 LÄUFT, wt-ce-fk)
   │
   ├──> [K2 ✔] Loader in stufen-neutrale Lib        ──┐
   │                                                   ├──> HY-A2  Proxy + Tier-Modul
   ├──> HY-A1  Dock-Contract + Prüfdock + Factory  ──┘         (4 ABI-Pflichtsymbole)
   │                                                              │
   │                                                              v
   │                                                        HY-A3  Registry + Fehlerklassen
   │                                                              │
   │    ┌─────────────────────────────────────────────────────────┘
   │    │
   │    v
   │  [OV-13 ✔] Standard compare→release mit EINEM direkten Tier-Binary
   │            ⚠️ MUSS VOR HY-B laufen — er liefert die REFERENZWERTE
   │                       │
   │                       v
   └──> [K5 ✔] HY-B  4. Mess-Ebene (Spalte) + Overhead = Differenz
                           │
                           v
                       HY-C  Heuristik-Auswertung + Release
```

**Blocker in dieser Kette:** `K1` (Lager) muss **vor** dem ersten Hybrid-Einlagern gedreht sein —
`lager_pfad_grammatik.hpp:527` wirft heute compile-hart.

### Kette B — MESSUNG und AUSGABE

```
[Deep Research ✔]
      │
      v
  MeasureStorage: 2 Arenen  (Strang 33 LÄUFT, wt-ce-xml)
      │
      ├──> checkpoint_measure  ──> D3-7 Lauf-Marker ──> D3-1 Resthälfte
      │
      └──> ErgebnisMappe als KONSUMENT
                 │
                 ├──> xlsx-Strategie ─┐
                 └──> csv-Strategie  ─┤  (Strang 35 LÄUFT, wt-super-landung)
                                      │
                                      v
                              measure_to_latex   (ersetzt csv_to_latex — ABLÖSUNG
                                      │           mit Migrationspfad, kein Neubau)
                                      v
                              anhang:forward ──> thesis:pdf
```

**Offene Vorfrage:** muss **G3** (Segment-Timer aus dem STATISTICS-Gate lösen) **vor**
`checkpoint_measure`? Heute teilen sich Macro und Micro **ein** Gate.

### Kette C — DURCHSTICH (F1, Freitag 14.08.)

```
CSV → persist → xlsx → anhang:forward → PDF
 ✔      ✔       teil     P4 ✔          inert
```

**Drei Nähte waren offen, zwei sind geheilt** (P4/P5, `wc -l`→`awk`, `awk 1`, Glob).
**Was bleibt:**

```
⚠️ STAGE-TOPOLOGIE:  thesis-pdf steht VOR measure und persist
                     ⇒ ein Ein-Pipeline-Durchstich ist STRUKTURELL unmöglich
                     ⇒ entweder zwei Pipelines oder Stage-Umbau (Owner-Entscheid)

⚠️ ergebnis:holen:   Skelett, laut Plan erst W2 (28.08.) scharf
                     ⇒ ZWEI WOCHEN NACH dem F1-Termin
```

**Empfehlung stand, Owner hat bestätigt:** **lokal UND CI**, beide als Beweis.

### Kette D — LAGER

```
[LAG-P1 ✔] CI-Scharfschaltung ──┐
[LAG-P2 ✔] Messwert-Genus (ce) ─┤
[LAG-P4 ✔] 4096-Korn static    ─┤
                                 v
                    Host-Belegung in super  (mess_bestand_* 0 externe Zuweiser)
                                 │
                                 v
                    [K1 ✔] Lagerbaum-Umbau: Gattung/Genus als WURZELEBENEN
                                 │           ⚠️ betrifft ALLE Gattungen, nicht nur Hybrid
                                 v
                    Pfad-Grammatik + Tests + Wachen nachziehen
```

### Querschnitt — was VIELES blockiert

```
--check-size  ──> Mess-Deckel (ETA ≤ 4,5 Maschinentage)
     │        ──> OV-4-Vorlage
     │        ──> HY-B-Mengenrechnung (heute UNBEZIFFERT, steht außerhalb des Deckels)
     └────────> reps=3 verdreifacht die MESS-Phase (aus T-15)
```

---

## 3. OFFENE ARBEITSPAKETE — nach Kette sortiert

### Sofort baubar (keine offenen Vorfragen)

| Paket | Ort | Abhängig von |
|---|---|---|
| **T-6-Lücke:** 4 von 5 CI-gerufenen Wachen ohne Selbsttest | super/ce | — |
| **`ci/wide_aggregat.sh`:** drei Kopien → eine | super | — |
| **ZWEI PARSES:** `profile_has_system_axes` gegen Walk-Bedingung | ce | — |
| **D3-2-Selbstwiderspruch** im Wellenplan | super, Doku | — |
| **Abnahme-Entwürfe härten** (Stellvertreter-Prüfung) | Doku | — |
| **prod2 umbenennen** | ce | Bump-Fenster |
| **LAG-P1 Rest:** `object_stat` gegen minio | super, CI | — |
| **Provenienz-Verlust:** statische Mess-Jobs ohne Zell-Koordinaten | super | — |

### Blockiert durch offene Owner-Fragen

| Paket | Wartet auf |
|---|---|
| **Drift-Gate „ganzer Lauf neu"** | **Granularität**: Zelle? 4096er-Batch? Kampagnentag? ganze Kampagne? |
| **Retry bei „failed"** | **Achse**: dieselbe wie `max_reruns` oder eine dritte, ungebaute? |
| **`measure_to_latex` XML-Segment** | **Wurzel**: `comdare_thesis_profile`, `comdare_experiment` oder neu? |
| **`checkpoint_measure`** | Muss **G3** vorher? |
| **Stage-Topologie** | Zwei Pipelines oder Stage-Umbau? |
| **AVX-512 in die golden-Matrix** | Kippt ein zweifach deklariertes Owner-Wort |
| **Cross-Maschinen-SKIP für `no_extension`** | Gleicher Fingerprint auf beiden Maschinen — gewollt? |
| **D-3 / D-5** | CEB-Varianten-Zahl · Bau- vs. Mess-Menge (Bestand widerspricht sich selbst) |

### Thesis-Verpflichtungen (Präsens-Zusagen, Frist 15.09.)

**HDR-Histogramm verdrahten** (heute 0 Produktions-Konsumenten) · **Fairness-Protokollierung** je
Fremdbibliothek (Compiler/Flags/ISA-Pfad/Allokator/Commit-Hash — fehlt ganz) · **Datensatz-Akte**
(Quelle/Prüfsumme/Seed-Regel) · **`LATENCY_P95`** deklariert, nicht exportiert ·
**Anhang-A-Kollision** (nearest-rank-Mediane unmarkiert gültig) · **interne Zweistimmigkeit**
(Hauptkapitel HDR, Anhang nearest-rank).

---

## 4. WERKZEUG-FALLEN — alle heute am Objekt zugebissen

*(Vollständig im Fallen-Register: `memory/reference_fallen_register_werkzeuge_und_ci.md`, 285 Z.)*

| Falle | Wirkung |
|---|---|
| `git-grep`-Pathspec `X/**/y/` | **stille Null**, Exit 1, keine Meldung |
| `rev-parse` im Submodul-Klon | liest den **Tracking-Ref**, nicht den Gitlink → „100 Commits" statt 18 |
| Zahl ohne **Commit-Anker** | „45 von 51" war nach **30 Minuten** falsch |
| **Zeilenanker** | drifteten an **einem Tag** um 174 bzw. 223 Zeilen |
| Backtick in Workflow-Skripten | beendet das Template → `undefined is not a function` |
| Gerade Stichprobenlänge allein | `{5,5,5,5}` unterscheidet zwei Formeln **nicht** |
| gitleaks auf Submodul-**Gitdir** | „0 commits scanned", `rc=0` — **grün über nichts** |
| Jobs-Endpunkt | enthält **keine Bridges** — Nenner ist Jobs + Bridges |
| Token im Scratch | `.tok`/`.patcfg` überleben Sessions, sieht kein gitleaks |
| Vault-PAT | für Push oft **gar nicht nötig** — erst `push --dry-run` |
| `clang-format` auf Kopien | ohne `--assume-filename`: **84 statt 20** Abweichungen |
| Biss-Nachvollzug | braucht **frische Vollkopie**, sonst stirbt der Mutant falsch |

---

## 5. DIE FEHLERKLASSEN, die diese Session gekostet haben

**Der Stellvertreter** — ein korrektes Messgerät am falschen Gegenstand. Viermal aufgetreten:
„Ein Blech" (Tag-Pin als Koordination gelesen) · die aktiv-Zeile als Lager-Beleg · meine
Trennung 9-vs-2 bei den Median-Aufrufen · `grep -c '"error"'` über Journale ohne dieses Feld.

**Die Wiederholungs-Autorität** — eine Aussage ohne Quelle, die durch Wiederholung Gewicht
bekommt. Der Fall: ein Kommentar nannte eine Agent-Entscheidung „Sichtbarkeits-Doktrin", drei
Wochen später zitierte ich den Namen als Autorität. **Gegenmittel: bei jeder Doktrin-Berufung die
erste Frage — wo ist das Owner-Zitat?**

**Die Abschrift** — eine Löschung bricht **nur bei Aufrufern**. `super` hatte die verworfene
Formel **abgeschrieben**; der Bau blieb grün, die Zahlen falsch.

**Gebaut, getestet, nicht angeschlossen** — dreimal: die Kurven-Synthese (1802 Zeilen, 0
Konsumenten), `IMeasurableWorkloadV3` (0 Aufrufer), das Drift-Gate (0 produktive Aufrufer bis
heute). **Wer „ist gebaut" liest, muss „wird gerufen" prüfen.**

**Ein Label wandert** — K4 galt seit 02.08. als entschieden, das Register führte es als offen,
und ich habe es in der Owner-Vorlage **stillschweigend durch E-1 ersetzt**.

---

## 6. WAS HEUTE GELANDET IST

**`ce`:** D5-1 Perzentil-KANON · LAG-P4 4096-Korn `static_assert` · LAG-P2 Messwert-Genus ·
LAG-Z1 SIMD-Schlüssel-Wache · T-15 Drift-Gate-Klammer · `allow_failure` aus der **emittierten**
Mess-Job-YAML · Diff-Hygiene-Wache geheilt.

**`super`:** Ein-Blech-Richtigstellung · 8-Stationen-Kette ins Dossier · Rangfolge korrigiert ·
Explore-Pflichtstufe · D5-5 entschieden · Konformitäts-Register **Teil 1 und 2** · P4/P5
Transportfallen · CI-Heilung + Proben-Verdrahtung · Vendoring-Nachzug · MeasureStorage-Design ·
HYBRID-Bauplan · **20 Ledger-Nachträge**.

**Push:** beide Repos, **alle Pipelines grün**, `main` fast-forwarded. Die drei neuen Jobs im
**Erstlauf grün**, jeder mit eigenem Selbstbiss.

---

## 7. FÜR DEN NACHFOLGER — die fünf Regeln, die am meisten sparen

1. **Ledger zuerst**, Nachträge stehen **oben**. Dann `MEMORY.md`. **Erst dann** greppen.
2. **Jede Zahl mit Nenner und Verfahren.** Eine Null ohne Gegenprobe ist kein Befund.
3. **Ein Schreiber je Worktree.** `git commit` nimmt die **ganze** Staging-Area.
4. **Vor jedem Köder:** ist der mutierte Zweig überhaupt **beobachtbar**?
5. **Wo du raten müsstest: Explore.** Fast alles ist schon entschieden — die Antwort lag heute
   dreimal Wochen vor der Frage im Bestand.
