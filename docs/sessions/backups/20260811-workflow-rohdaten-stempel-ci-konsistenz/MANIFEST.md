# WORKFLOW-ROHDATEN — Sicherung 11.08.2026 nachts (Stempel · CI · Konsistenz · Nachtrag)

**Anlass:** Owner-Auftrag *„Bitte sichere nach dem workflow alle rohdaten und Ergebnisse des
aktuellen workflows in den backup Ordner in die sessions."*

Rohdaten-Sicherungen sind **additiv und werden nie gelöscht**. Dies ist eine Sicherung, keine
Auswertung — die Auswertung steht im Ledger (**KON9…KON13**) und im Wellenplan (**§13 · §14 · §15**).

---

## WAS HIER LIEGT

| Datei | Inhalt | Agenten | roh | gepackt |
|---|---|---|---|---|
| `lauf-wf_296a2353-2d6.tar.gz` | **Stempel-Explore** — Selbstkompilation · drei Grammatiken · Hybrid-Multiplexer · mp11-Filterkette · Interface-Arten | 50 | 22 M | 8,8 M |
| `lauf-wf_e9b2cd97-d5f.tar.gz` | **CI-Explore** — Mini-Pipelines je Träger · Stempel als Cache-Schlüssel · Buildsystem-Cache · harte Blocker | 36 | 13 M | 5,4 M |
| `lauf-wf_07d6a08d-13a.tar.gz` | **Konsistenz-Review** — W-1 klären, alle Festlegungen dieser Nacht gegen den Gesamtzusammenhang, besonders auf **Vorwegnahme** | 27 | 12 M | 5,2 M |
| `lauf-wf_a2e3281c-663.tar.gz` | **Nachtrag** — F-1 neue Fassung · C-4 Achsen-Interfaces · C-1 Restpositionen · 14 ungeprüfte Bau-Teile · Cache-Landschaft · Zitattreue | 42 | 12 M | 4,8 M |
| `alle-journale.tar.gz` | **226 `journal.jsonl`** dieser Session — der vollständige Bestand, nicht nur die vier Läufe | — | — | 9,0 M |
| `wf_*.js` (4) | die Workflow-Skripte selbst, in der gefahrenen Fassung | — | — | — |
| `ernte_journal.py` | das Ernte-Werkzeug: extrahiert die Agenten-Ergebnisse aus einem Journal | — | — | — |
| `synthese-{stempel,ci,konsistenz}.md` | die drei fertigen Synthesen im Volltext (36 K / 30 K / 30 K) | — | — | — |

**Zusammen 155 Agenten, 0 Fehler.**

**Auspacken:** `tar -xzf lauf-<run>.tar.gz` — legt `wf_<id>/` an mit `journal.jsonl` (eine Zeile je
Agenten-Ereignis, `type: started|result`) und je Agent ein `agent-<id>.jsonl` plus `.meta.json`.

> **Das `journal.jsonl` ist die Wahrheit**, nicht die Ergebnisdatei. Ein Workflow kann stumm
> sterben, und dann ist die fehlende Zeile das einzige Signal. **Diese Nacht hat den Grund dafür
> geliefert:** der Stempel-Designplan mit 15 Paketen (ST-00…ST-14) lag ausschließlich im flüchtigen
> Task-Output und ist heute nirgends mehr auffindbar — 0 Treffer über alle 180 Outputs, 0 über
> `docs/`. Was im Journal steht, überlebt.

---

## SICHERHEIT — geprüft, mit belegtem Köder

Alle vier Läufe vor dem Packen mit `gitleaks detect --no-git` gegen die repo-eigene
`.gitleaks.toml` geprüft:

```
wf_296a2353-2d6   scanned ~21.862.024 bytes   no leaks found
wf_e9b2cd97-d5f   scanned ~12.928.726 bytes   no leaks found
wf_07d6a08d-13a   scanned ~11.476.257 bytes   no leaks found
wf_a2e3281c-663   scanned ~11.709.988 bytes   no leaks found
```

**Die Null gilt erst mit der Gegenprobe (K13), und sie lief VORHER:** ein gewürfelter Köder
`glpat-` + **20** Zeichen aus `/dev/urandom` → **`leaks found: 1`**. Der Scanner greift.

*Die Zeichenzahl ist nicht beliebig:* die Sicherung vom 11.08. mittags hat dokumentiert, dass ein
**19**-Zeichen-Köder unter der Entropie-Schwelle bleibt und `no leaks found` liefert — eine
Falsch-Null, die den ganzen Beleg entwertet hätte.

**Zusätzlich vor dem Packen geprüft** (acht Muster über die aufbereiteten Ernte-Dateien):
`glpat-` · `ghp_` · `github_pat` · `AKIA` · `PRIVATE-TOKEN` · `Bearer` · `password` ·
`BEGIN…PRIVATE KEY` → **je 0**, Gegenprobe „Stempel" **117**.

---

## WAS DIESE VIER LÄUFE ERGEBEN HABEN

**Stempel-Explore.** Der Selbstkompilations-Entwurf ist gefunden — er existiert seit dem **19.07.**
in `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` und dem zugehörigen
`FINALES-DESIGN-ABSTRACT`. Der Begriff „Selbstkompilation" kommt darin **nullmal** vor; die Sache
steht als Director/Builder mit Command-Objekten. → Ledger **KON10**.

**CI-Explore.** **0 von 4 Trägern** haben heute eine eigene Mini-Pipeline. super hat **genau einen**
statischen Bau-Job, ce zwei; von vier `trigger:`-Kanten triggert **keine** einen Träger als
Bau-Gegenstand. Der Hybrid kommt in **beiden** CI-Dateien **0**-mal vor. Dazu: das
GitLab-Nesting-Budget ist ausgeschöpft. → Ledger **KON13-04**, Wellenplan **§15.8**.

**Konsistenz-Review.** 20 Korrekturvorschläge gegengeprüft, **elf fielen** — der Bestand war
richtig. Aufgelöst wurde **W-1**: der Hybrid ist Glied der **Mess**-Kette, nicht der
Bau-/Freigabe-Kette, weil er nicht bauen kann. Vier **Vorwegnahmen** gefunden, drei vom Owner zur
Korrektur freigegeben. → Ledger **KON13**, Wellenplan **§15**.

**Nachtrag.** Läuft zum Zeitpunkt dieser Sicherung noch in der Synthese-Phase (**41 von 42**
Agenten zurück). Das Journal ist vollständig gesichert; die Synthese wird nachgetragen, sobald sie
vorliegt. Gegenstand: F-1 (die neue exakte Fassung), die Achsen-Interface-Trennung, die zwei
offenen Inventur-Positionen, **14 nie gegen den Code gemessene Bau-Teile**, die Cache-Landschaft
und die ungeprüfte Zitattreue.

---

## DIE METHODISCHEN BEFUNDE DIESER NACHT — sie gelten über den Anlass hinaus

1. **Nach dem GEGENSTAND suchen, nicht nach dem Konsumenten.** Zweimal meldete ein Explore
   „fehlt/unangeschlossen", was am Objekt gebaut und gerufen war — beim `ExperimentPlanDirector`
   sogar mitsamt der Auflösung des behaupteten Konflikts im Kopfkommentar der Datei selbst.
   Daraus wurde **Arbeitsweise v3.3 / A2.2** (Bestands-Pflicht vor jeder Neuimplementierung).
2. **Ein binäres `widerlegt`-Flag trennt „falsch" nicht von „fast richtig".** Neun als „widerlegt"
   markierte Verifikationen bestätigten den Befund und markierten nur eine Präzisierung. Künftige
   Verify-Schemata brauchen einen dritten Zustand.
3. **Zeilenanker auf lebende Dateien sind unbrauchbar.** Der Ledger wuchs an diesem Abend von
   20.354 auf über 21.500 Zeilen; Anker drifteten um ~840 Zeilen. Die Code-Anker (ce `670483c0`)
   blieben exakt. → Anker über **KON-Kennung** oder **Symbol**.
4. **Die CI-Formel ist die CI-Formel.** Ein selbst nachgebauter Zähler lieferte 59 statt 40 Stellen,
   weil `git grep -n <SHA>` vier Felder liefert und nicht drei.

---

*Erhoben 11.08.2026 nachts. Objektstände: ce `670483c0` · super `1ecc605a`. Jede Zahl dieses
Manifests ist gemessen oder trägt ihre Quelle.*

---

## NACHTRAG — die beiden Synthesen und der Fable-Lauf

Der vierte Lauf ist inzwischen durch (**42 Agenten**), und die Owner-Doktrin wurde **während**
seiner Synthese gesetzt: *„bitte merke dir in Zukunft immer mit **Fable 5 max** die Synthese
auszuwerten"* (Arbeitsweise **v3.4 / A1**, `531d0ea`). Die laufende Opus-Synthese wurde zu Ende
geführt, die Fable-Fassung nachgeholt — **beide über denselben Datensatz**.

| Datei | Inhalt |
|---|---|
| `synthese-nachtrag-OPUS.md` | 23.545 Zeichen — die Fassung, die noch auf Opus lief |
| `synthese-nachtrag-FABLE.md` | 33.936 Zeichen — die doktrin-konforme Fassung |
| `lauf-wf_a2e3281c-663.tar.gz` | der Nachtrag-Lauf, jetzt vollständig inkl. Synthese |
| `lauf-wf_2398a27a-a41-synthese-fable.tar.gz` | der Fable-Synthese-Lauf |

**Warum beide aufgehoben werden:** sie sind nicht redundant. Die Fable-Fassung hat **vier Punkte
selbst am Objekt nachgeprüft** statt sie zu übernehmen (S-6 an beiden Stellen · die sechs
Marker-Träger · Wellenplan §15.1 · die KON13-Wortlaute) und **vier Befunde geliefert, die die
Opus-Fassung nicht hat** — darunter die vier unmarkierten Eingriffe in einem Owner-Zitat (KON9-11),
von denen einer **ein Ende vor einem Blocker-Folgesatz kappte**.

Zwei unabhängige Auswertungen desselben Datensatzes sind damit selbst ein Beleg: **wo sie
übereinstimmen, ist die Aussage doppelt getragen; wo sie abweichen, liegt der Fund.**

Auswertung: Ledger **KON14**.

---

## NACHTRAG 2 — der abgebrochene Explore-Lauf `wf_eede2f12-7ed`

Nach den vierzehn Owner-Antworten (Ledger **KON16**) wurde ein neun-straengiger Explore gestartet:
die drei Owner-Explore-Auftraege (Flag-Syntax `c`=CPU · freigebende vs. compile-time-Seite ·
geplante Export-Ziele), die drei Kontext-Bitten (Typ vs. Instanz · eigene Beduerfnisse ·
C-4-Wache) und die Objektpruefung der drei neuen Architektur-Aussagen (Stufe/Phase-Umbenennung ·
kein-YAML/Bau-Modul · drei Flaechen).

**Auf Owner-Anweisung gestoppt**, bevor ein Ergebnis zurueckkam.

| Datei | Inhalt |
|---|---|
| `lauf-wf_eede2f12-7ed-ABGEBROCHEN.tar.gz` | 3,2 M — 16 gestartete Agenten, 0 Ergebnisse, vollstaendiges Journal |
| `wf_owner_antworten.js` | das Skript in der gefahrenen Fassung — der Lauf ist damit reproduzierbar |

```
gitleaks   8,30 MB gescannt   no leaks found
Gegenprobe VORHER gefahren:   Koeder 'glpat-' + 20 Zeichen aus /dev/urandom -> leaks found: 1
```

**Wiederaufnahme:** `Workflow({scriptPath: ".../wf_owner_antworten.js"})`. Ein Resume ueber
`resumeFromRunId` lohnt nicht — es gab null Ergebnisse zu cachen.

**Warum das Skript gesichert wird, obwohl nichts zurueckkam:** die neun Straenge tragen die
ausformulierten Owner-Zitate und Suchauftraege. Das ist der eigentliche Wert — nicht die
Agenten-Ausgabe, die es nie gab.

---

## NACHTRAG 3 — WF2: Zwei Welten + Register leerer Klassen (12.08.)

| Datei | Inhalt |
|---|---|
| `lauf-wf_8f39354c-394-zwei-welten.tar.gz` | 2,4 M — 9 Agenten, 0 Fehler: Strang J (Glieder-Reihenfolge Lager vs. außerhalb, blockierte S-6) + Strang K (Register der leeren Klassen) |

Synthese (Fable 5 max) gelandet als
`docs/sessions/20260812-WF2-SYNTHESE-zwei-welten-der-glieder-reihenfolge-und-register-leerer-klassen.md`,
Auswertung Ledger **KON20**.

```
gitleaks   6,02 MB gescannt   no leaks found
Gegenprobe: ERSTE Probe biss NICHT (Koeder hatte 19 Zeichen -- das Rezept
head -c 15 | base64 | tr -dc liefert nicht-deterministisch 19 ODER 20).
ZWEITE Probe mit 40 Input-Bytes und gepruefter Laenge 20 -> leaks found: 1.
Die Null ist erst mit der ZWEITEN Probe gedeckt. Fallen-Register ergaenzt.
```

---

## NACHTRAG 4 — WF1 (neun Owner-Straenge) + WF3 (5-Kontexte-Einlesen), 12.08.

| Datei | Inhalt |
|---|---|
| `lauf-wf_91263b69-d40.tar.gz` | 11 M — WF1: 46 Agenten (45 fertig, 1 StructuredOutput-Tod), 9 Straenge A-I |
| `lauf-wf_c665d379-7b8.tar.gz` | 1,6 M — WF3: 9 Agenten, 7 Leser + Abgleich + Synthese |

Synthesen gelandet als `20260812-WF1-SYNTHESE-*` und `20260812-WF3-SYNTHESE-*`; beide Koepfe
beim Agenten-Return verloren (Return beginnt mitten im Satz) -- die Straenge A-D von WF1 aus dem
Journal geborgen (`20260812-WF1-BERGUNG-verify-ABCD.md`), das WF3-Unverbuchte vollstaendig in
KON22. Auswertung: KON22 (WF3) + KON23 (WF1).

```
gitleaks   WF1 + WF3 je "no leaks found"
Gegenprobe MIT LAENGENPRUEFUNG (Lehre aus Nachtrag 3): Koeder-Laenge ${#K}=20
           verifiziert VOR dem Zaehlen -> leaks found: 1. Beide Nullen gedeckt.
```

---

## NACHTRAG 5 — WF4: die fuenf KON19-Explores (12.08.)

| Datei | Inhalt |
|---|---|
| `lauf-wf_23fc24f2-08a.tar.gz` | 5,3 M — 21 Agenten (19 fertig, 2 Transkript-Schnitte an StructuredOutput gestorben, von den Gegenproben kompensiert; 3 TEST-Stubs verworfen) |

Synthese gelandet als `20260812-WF4-SYNTHESE-die-fuenf-kon19-explores.md` (mit Kopf — die
Kompaktheits-/Titel-Auflage wirkt), Auswertung **KON26**. gitleaks: no leaks found; Gegenprobe
mit laengengeprueftem 20-Zeichen-Koeder -> leaks found: 1. Die Null ist gedeckt.

---

## NACHTRAG 6 — VOLLSICHERUNG 12.08.2026 (Owner-Auftrag: alles loeschsicher)

| Datei/Ordner | Inhalt |
|---|---|
| `alle-journale-20260812.tar.gz` | 9,5 M — **ALLE 235** `journal.jsonl` der Session (= jedes Agenten-Ergebnis jedes Laufs; das Journal ist die Wahrheit). 🔴 ZWEI Journale REDIGIERT (wf_2444c5ec: 1× glpat-, wf_aa90e8b0: 1× ghp_ → `[REDIGIERT-20260812]`); erst danach `no leaks found` |
| `kon-quellen/` | 21 KON-Nachtrags-Quelldateien (kon14…kon27) — die tmp-Originale, deren Inhalt im Ledger steht |
| `owner-extrakte/` | die Token-redigierten Owner-Nachrichten der 6 Kontexte (owner-kontext-0…-5 + Gesamt + Extraktor-Skript), je `no leaks found` |
| `wf5_f_explores.js` u.a. | die Workflow-Skripte WF2–WF5 in gefahrener Fassung |

**Durabel AUSSERHALB des Repos (nie committen — Transkripte/Agent-Volltranskripte tragen
Live-Token-Risiko):** `/home/comdare/ernte-20260812-nacht7c/` — `workflows/` (797 M, alle 235
Laeufe VOLLSTAENDIG inkl. agent-*.jsonl) · `session-log-5a19728e-stand-20260812.jsonl` (217 M,
der komplette Session-Log mit allen Owner-Antworten) · `task-outputs/` (1200 Task-Ergebnisdateien
aus /tmp, die beim Reboot verloren gegangen waeren).

**Gegenprobe dieser Sicherung:** Koeder-Laenge VOR dem Zaehlen geprueft (20) → `leaks found: 1`.
Alle drei Repo-Nullen (kon-quellen · owner-extrakte · journale nach Redaktion) sind gedeckt.

**🔴 ROTATIONS-MELDUNG an den Owner:** der `ghp_`-Fund (GitHub-PAT, 40 Zeichen, in einem
alten Workflow-Journal) war NICHT unter den sieben rotierten CI/CD-Variablen — Rotation pruefen.
