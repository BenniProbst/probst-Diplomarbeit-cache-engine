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
