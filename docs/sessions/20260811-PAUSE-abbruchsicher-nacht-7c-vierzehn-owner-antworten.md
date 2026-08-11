# PAUSE, ABBRUCHSICHER — 11.08.2026, Nacht 7c

> **Zweck:** Wenn der Kontext hier abreißt, geht **nichts** verloren. Dieses Dokument nennt jeden
> Gegenstand, seinen Ort und den Weg, ihn zu bergen.
>
> **Einstieg für die Nachfolge:** Ledger-Kopf lesen — **KON16** steht ganz oben und ist die
> geltende Fassung. Darunter KON15, KON14, KON13. Dann diese Datei, dann
> `20260811-KONTEXTUEBERGABE-nacht-7b-*`.

---

## 1. WAS GESICHERT IST — und wo

| Gegenstand | Ort | Zustand |
|---|---|---|
| **14 Owner-Antworten** | Ledger **KON16**, Commit `edd3a1ee` | ✅ **gelandet, beide Remotes** |
| Owner-Antworten der Vorrunde | Ledger **KON15**, Commit `c36f414a` | ✅ gelandet |
| Kontextübergabe Nacht 7b | `docs/sessions/20260811-KONTEXTUEBERGABE-nacht-7b-*` | ✅ gelandet |
| Architektur KON9…KON14 | Ledger, Commits `8205e980` … `45daccec` | ✅ gelandet |
| Wellenplan §13/§14/§15 | `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-*` | ✅ gelandet |
| Vier Workflow-Läufe der Nacht 7 | `docs/sessions/backups/20260811-workflow-rohdaten-*` | ✅ 34 MB, 16 Dateien |
| Beide Synthesen (Opus + Fable) | ebenda, `synthese-nachtrag-{OPUS,FABLE}.md` | ✅ gelandet |
| Gedächtnis (5 neue Einträge) | `~/.claude/projects/-home-comdare/memory/` | ✅ geschrieben |

**Nichts liegt ungesichert im flüchtigen Kontext.** Das war in Nacht 7a anders — dort ging ein
Stempel-Designplan mit 15 Paketen verloren, weil er nur im Task-Output stand.

---

## 2. DER EXPLORE-LAUF — auf Owner-Anweisung GESTOPPT, vollständig gesichert

**`wf_eede2f12-7ed`** — neun Stränge, 45 Agenten. Auf Owner-Anweisung *„Bitte pausiere auch alle
workflows"* beendet, bevor ein Ergebnis zurückkam.

```
Stand beim Stopp   16 Agenten gestartet, 0 Ergebnisse
Gesichert als      docs/sessions/backups/20260811-workflow-rohdaten-*/
                     lauf-wf_eede2f12-7ed-ABGEBROCHEN.tar.gz   (3,2 M)
                     wf_owner_antworten.js                     (das Skript, unveraendert)
gitleaks           8,30 MB gescannt, no leaks found
                   Gegenprobe VORHER gefahren: Koeder glpat- + 20 Zeichen -> leaks found: 1
```

**Nichts läuft mehr.** Geprüft: keine Workflow-Prozesse, keine Bash-Jobs, keine cmake/ninja/c++.

**WIEDERAUFNAHME — der Lauf ist vollständig reproduzierbar:**

```bash
# Das Skript liegt unveraendert an zwei Orten:
#   ~/.claude/jobs/5a19728e/tmp/wf_owner_antworten.js
#   docs/sessions/backups/20260811-workflow-rohdaten-*/wf_owner_antworten.js

Workflow({scriptPath: "~/.claude/jobs/5a19728e/tmp/wf_owner_antworten.js"})

# Ein Resume ueber resumeFromRunId: "wf_eede2f12-7ed" bringt fertige Agenten aus
# dem Cache -- aber NUR in derselben Session. Nach einem Abriss: neu fahren.
# Es gab ohnehin 0 Ergebnisse, ein Resume spart hier nichts.
```

⚠️ **Platte: 19 G frei bei 93 % Belegung.** Ein ce-Bau kostet 6 G. Vor dem nächsten Lauf prüfen —
eine volle Platte legt auch Bash/Read/ToolSearch lahm, dann fällt die Selbsthilfe aus.

**Was der Lauf holen sollte — die neun Stränge stehen unverändert im Skript:**

| Strang | Gegenstand | Auslöser |
|---|---|---|
| A | die volle Flag-Syntax, `c` = CPU, was sind `cp`/`ce`? | Owner: „bitte explore" |
| B | freigebende vs. compile-time-Seite + Messfühler-Vertrag | Owner: „(explore)" |
| C | was war als Export geplant (LaTeX/PDF/xlsx/…)? | Owner: „(explore)" ×2 |
| D | je Träger-**Typ** oder je **Instanz** — Entscheidungsgrundlage | Owner: „mehr Kontext" |
| E | „eigene Bedürfnisse" je Träger — Tabelle | Owner: „mehr Kontext" |
| F | C-4-Wache: erweitern oder zweite — Grundlage | Owner: „mehr Kontext" |
| G | STUFE/PHASE-Kollision: Trefferliste nach Härteklassen | Owner: umbenennen |
| H | gibt es das zentrale Bau-Modul schon? (Bestands-Pflicht) | KON16-03 prüfen |
| I | existiert Fläche 3, der measurement-Durchstich? | KON16-06 prüfen |

---

## 3. 🔴 DIE VIER OFFENEN FRAGEN AN DEN OWNER

**Drei brauchen Kontext** (der Lauf holt ihn), **eine ist unbeantwortet:**

**6 — neu gefasst.** Baut das zentrale Bau-Modul **eine Bau-Vorschrift je Träger-Typ** (vier, jede
N-mal parametrisiert) oder **je Instanz eine eigene**?
*Kontext:* Planer 1 · CEB 3!=6 · Tier **unbekannt** (kommt nur vom fertigen Planer) · Hybrid 24
oder 48 (nicht entschieden). Runner `concurrent=4` auf zwei Hosts, ein ce-Bau = 6 G.

**7 — neu gefasst.** Welche Schritte **emittiert** eine Träger-Stufe für die nächste — nur
Compile+Link, oder auch Test, Lint, Mess-Lauf, Release, Cache-Ablage? Gleich für alle vier oder
trägerspezifisch?
⚠️ *Wenn das Bau-Modul die Pflicht-Reihenfolge **J-1…J-4** nicht mitemittiert, baut es falsches
Grün.*

**12.** C-4: die Heuristik-Wache um `axes/` **erweitern** oder eine **zweite** danebenstellen?

**10 — unbeantwortet.** Bleibt **S-13** (Cache-Struktur) hinter der Abgabe, oder ist es vorgezogen?

> **6 und 7 mussten NEU gestellt werden.** Ihre alte Fassung setzte GitLab-YAML als Träger voraus
> — und mit KON16-03 („es gibt keine YAML") ist dieser Träger entfallen. Die Fragen fielen nicht
> durch eine Antwort, sondern durch den **Wegfall ihres Gegenstands**.

---

## 4. WAS SICH ARCHITEKTONISCH GEÄNDERT HAT — die drei harten Punkte

**a) Es gibt keine YAML.** Der Planer emittiert direkt eine Pipe/einen Prozess; jede Träger-Stufe
emittiert die nächste über **ein zentrales Bau-Modul im Builder Pattern**. **Tiefe 3.** Tier und
Hybrid stehen **sequentiell auf derselben Stufe** — erst Tier, dann Hybrid, beide durch die CEB.
⇒ **Aufgabe #90 ist in ihrer heutigen Fassung gegenstandslos** und muss neu gefasst werden.
⇒ **Offen:** was ist dann der `CiYamlBuilder` aus dem 19.07.-Entwurf?

**b) Drei Flächen, nicht zwei.** 1 = Genus-Interface · 2 = Stempel (trägt Tools/Compiler als Teil
der **Systemachse**) · 3 = **measurement-Durchstich**, eingeführt **damit die
Gattung+Genus-Funktionsinterfaces unverändert bleiben**. Das ist eine **Nicht-Änderungs-Zusage**,
die jeder künftige Bau einhalten muss.

**c) STUFE = PHASE, Umbenennung angeordnet.** Betrifft potenziell Symbolnamen, XSD-Elemente,
CI-Job-Namen und Fingerprint-Felder ⇒ **ABI- und preimage-wirksam**. Heute kostenlos, **ab
Mi 26.08. teuer**. Vor jedem Eingriff: Trefferliste nach Härteklassen sortieren.

---

## 5. BETRIEBSSTAND

```
super  development = edd3a1ee   beide Remotes, Arbeitsbaum sauber
ce     development = 670483c0   Pipeline 15682 ROT (naechster Gegenstand nach dem Stempel)
Projekte           = 531d0ea    nur GitLab -- der Gesamtplan geht nie ins Internet

Ledger      21.999 Zeilen       Wellenplan  1921 Zeilen
Platte      19 G frei (93 %)    ⚠️ ein ce-Bau = 6 G
Worktrees   8 Stueck, alle sauber
Laufend     wf_eede2f12-7ed (45 Agenten) -- sonst nichts
```

**Die Commit-Kette der Nacht:** `5686a50e` · `8205e980` · `1438225b` · `ab7c936e` · `869f6a2b` ·
`cc255fd8` · `c3189e06` · `870af088` · `4954993a` · `32b1947d` · `57015c39` · `270ceff8` ·
`1ecc605a` · `ec6412e2` · `45daccec` · `c36f414a` · **`edd3a1ee`**

---

## 6. WIEDERANLAUF — die Reihenfolge

1. **Neu gründen:** die vier `/goal`-Dokumente + `ARBEITSWEISE-GESAMT-DOKTRIN.md` (v3.4) laden.
   *GOAL lesen genügt nicht — die Arbeitsweise ist ein eigenes Dokument.*
2. **Ledger-Kopf lesen:** KON16 (geltend) → KON15 → KON14 → KON13.
3. **Diese Datei**, dann die Kontextübergabe 7b.
4. **Den Lauf bergen** (§2). Wenn er durch ist: Synthese auf **Fable 5 max**, nie Opus.
5. **Erst dann bauen.** Und vor jedem Bau: Bestands-Pflicht — **nach dem Gegenstand suchen, nicht
   nach dem Konsumenten**. Diese Nacht hat drei eigene Messungen an genau diesem Fehler verloren.

---

## 7. WAS AUSDRÜCKLICH UNGEPRÜFT BLEIBT

* **14 von 18 Bau-Teilen** sind nie gegen den Code gemessen worden.
* **S-4, S-8, S-10** — im gesamten Material kein Befund.
* Der **Aufwand** der Träger-Baukette steht nirgends. „Termine unverändert" ist aus den Dokumenten
  allein **nicht entscheidbar**.
* **S-6** steht still bis zum Zwei-Welten-Explore (#92) — das Glied ist preimage-wirksam.
* Der **`CiYamlBuilder`-Widerspruch** (§4a) ist benannt, nicht geklärt.

---

*Erhoben 11.08.2026 nachts, vor der Pause. Owner-Wort ist gelandet, bevor irgendetwas anderes
geschah — das ist die Lehre aus dem verlorenen Stempel-Designplan der Vornacht.*
