# `docs/architektur/measurement/` — die Mess-Planung und ihre zwei Erstbelege

**Angelegt 08.08.2026** auf Owner-Anweisung: *„wenn er Planung beinhaltet, hat die Planung unter
`/architecture/measurement` zu liegen und nicht wild im Wurzelordner"*.

> **Schreibweise:** dieses Repo führt `docs/architektur/` (deutsch, 36 Dokumente). Ein
> `docs/architecture/` existiert hier **nicht** — das gibt es nur in der Cache Engine. Die Doppelung
> der Schreibweisen über beide Repos ist ein eigener Aufräum-Posten und **nicht** hier zu lösen.

---

## Was hier liegt

### `erstbeleg-d03-20260726/` — der erste vollständige Kettenlauf
**Vorher:** `measurement/` in der Repo-Wurzel. **Verschoben mit `git mv`**, die Historie ist erhalten.

Inhalt: `measurements.csv` plus acht `per_binary/*.result.csv` aus dem D-03-Lauf vom **26.07.2026**,
dazu `NOTIZ-binary-id-grammatik-der-archive.md`.

**Das sind ECHTE MESSDATEN.** Sie fallen unter die Doktrin *„Messdaten werden nie gelöscht — auch wenn
dadurch das ABI bricht"*. Sie sind der **Beleg, dass die Kette einmal durchgelaufen ist**, und
zugleich das einzige Material, an dem sich die `binary_id`-Grammatik in freier Wildbahn nachlesen
lässt. Die Dateinamen tragen die volle Achsen-Kette
(`search_algo_… cache_traversal_… mapping_… path_compression_…`) und einen 16-Hex-Suffix — genau die
Form, die die Notiz erklärt.

**Der Ordner war die Keimzelle der geplanten Ablage `measurement/<YYYYMMDD-HHMMSS>/`.** Diese Ablage
zieht seit dem 08.08. auf das **Buildsystem-Volume** (`/mnt/comdare-buildsystem`, 20 T, 15 T frei).
Was hier bleibt, ist der **Erstbeleg als Dokument** — nicht die laufende Ablage.

### `petrischale-pdf-export-20260618/` — der erste PDF-Export der LaTeX-Anhänge
**Vorher:** `Messdaten-Backup/` in der Repo-Wurzel. Owner am 08.08.:

> *„es ist der **erste Petri-Schalen Versuch des PDF exports der Latex-Anhänge** … das sollte eher in
> die Planung als Beispiel eingegliedert werden und nicht in den Wurzelordner."*

**Der Name war irreführend.** Es ist kein Backup, sondern ein **funktionierender Prototyp** der Kette,
die heute unter dem Namen *LaTeX-Anlage* gebaut wird:

| Datei | Rolle im Prototyp |
|---|---|
| `AUSWERTUNG_2026-06-18_INDEX320_cowfix-v1.md` | die **Auswertung**: 120.960 Messzeilen, 154 Spalten, 320 Binaries (memory_layout 5 × node_type 4 × prefetch 4 × search_algo 4) |
| `praesentation_bausteine_2026-06-18.tex` | die **erzeugten LaTeX-Bausteine** |
| `_preview_bausteine.tex` / `_preview_bausteine.pdf` | der **Bau bis zum fertigen PDF** — der Beweis, dass die Kette bis zum Ende trägt |
| `ff_summary.json` | das Zwischenformat zwischen Auswertung und Satz |
| `FEEDBACK_IMPL-AGENT_messdaten-probleme_2026-06-18.md` | was am Datenmaterial nicht stimmte |
| `analyze_ff.py` | **das Auswerte-Skript — siehe Doktrin-Vermerk unten** |

**Warum das als Vorbild taugt und woran es sich messen lassen muss:** die Auswertung nennt ihre eigene
Grenze im Kopf — *„Fixiert (nicht variiert): `isa = amd64`, `cache_traversal = linear_fanout`,
`allocator = std_malloc` → **Über SIMD/ISA, Traversierungs- und Allokator-Achse ist in diesem Lauf
KEINE Aussage möglich**"*. Genau diese Ehrlichkeit über den eigenen Geltungsbereich muss die künftige
LaTeX-Anlage automatisch mitliefern; heute steht sie dort von Hand.

**Was der Prototyp NICHT kann** und was die Anlage können muss: Auswahl, Reihenfolge und Aufmachung aus
der XML · Break-Even statt Rohtabellen · die beste Version je Eingangslast · schaltende Textbausteine
im Fließtext.

---

## DOKTRIN-VERMERK: `analyze_ff.py`

Die Hausdoktrin lautet **„kein Python in der Buildchain"**. `analyze_ff.py` ist Python.

**Es ist trotzdem kein Verstoß im laufenden Betrieb** — die Datei ist Teil eines abgeschlossenen
Prototyps vom 18.06. und in **keinen Bau, keine CI und kein Skript** eingebunden (geprüft am
08.08.2026 über die Muster `analyze_ff`, `\.py` in `.gitlab-ci.yml`, `ci/`, `scripts/`).

**Sie bleibt als historischer Beleg** — Doktrin: *Dokumentation wird nie gelöscht, nur deprecatet.*
**Sie darf nicht Vorbild für den Nachbau sein:** der produktive Auswerter gehört nach C++ in die CEB
(Owner B-4, 07.08.: *„Break even lebt nur in der CEB … um dann von der CEB auch bei Anforderung durch
den Planer in Latex Dokumente, PDF oder xlsx Tabellen nach Zielorte zu gießen"*).

---

## Für Leser älterer Dokumente

Rund **134 Dokumente** in `docs/sessions/` und `docs/plaene/` nennen noch die alten Wurzelpfade
`measurement/…` und `Messdaten-Backup/…`. **Das ist kein Fehler und wird nicht rückwirkend
umgeschrieben** — ein Session-Dokument vom Juni beschreibt korrekt, wo die Dateien *damals* lagen.
Wer dort auf einen toten Pfad stößt, findet den Inhalt hier.

**Kein CI-Job referenzierte die alten Pfade** (geprüft) — der Umzug bricht keine Pipeline.
