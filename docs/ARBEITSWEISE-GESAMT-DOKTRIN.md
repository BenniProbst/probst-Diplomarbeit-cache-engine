# CLAUDE CODE ARBEITSWEISE — GESAMT-DOKTRIN  ·  UMGEZOGEN

> **DIESES DOKUMENT LEBT NICHT MEHR HIER.** Es ist am 10.08.2026 in den Haupt-Umbrella
> gezogen und wird dort gepflegt. Diese Datei ist ein **Zeiger**, keine Fassung —
> nichts wurde geloescht (Pflege-Regel 3: „Nichts loeschen — Ueberholtes als
> UEBERHOLT markieren").

> DICHTE LESE-/RITUAL-FASSUNG ab 26.08.2026: Umbrella docs/ARBEITSWEISE-GESAMT-DOKTRIN-DICHT.md (Geltung: Vollfassung).

## Der geltende Ort

```
Repo:   comdare/projekte          (GitLab, https://gitlab.comdare.local/comdare/projekte)
Pfad:   docs/ARBEITSWEISE-GESAMT-DOKTRIN.md
Branch: development
Stand:  v3.1 · 570 Zeilen · gelandet als 7af380e
```

**Die drei Commits der Entstehung sind mitgewandert** (per `format-patch`, Reihenfolge und
Autorschaft erhalten) — die Fassungsfolge ist dort lesbar, nicht abgeschnitten:

| Commit dort | Fassung | Inhalt |
|---|---|---|
| `6438f4d` | **v3** | Arbeitsweise + Verifikations-Doktrin (Teil V neu, aus 16 realen Lead-Arbeitsfehlern) |
| `99f41e7` | **v3.1** | die neun Luecken, die ein Audit gegen v3 selbst fand |
| `4338a44` | A1 | der veraltete Fable-Absatz entfernt, Matrix auf den 08.08.-Stand |
| `7af380e` | ORT | Umzug in den Umbrella, Geltung universell |

## Warum sie hier weg ist

**Owner-Entscheid 10.08.2026, woertlich: *„Die Arbeitsweise gilt universell."***

Das Dokument traegt **Teil B.1** (shsd-Session), **Teil B.2** (Buildsystem-Session) und
**Teil B.3** (Diplomarbeit-Session). Es lag bis heute in `comdare/research/probst-diplomarbeit-cache-engine`
— also **in einem der drei Projekte, die es regieren soll**. Wer die Doktrin fuer shsd oder
das Buildsystem brauchte, musste sie im Diplomarbeits-Repo suchen. Eine universelle Regel,
die in einem Spezialfall wohnt, ist strukturell falsch abgelegt, auch wenn jede Zeile stimmt.

`comdare/projekte` ist der **Haupt-Umbrella**: er wrappt `Research/`, `Products/`, `Modules/`
und `Cluster/`, stellt aber **ausschliesslich `docs/` online** — die vier Ordner-Familien sind
per `.gitignore` ausgenommen (`:34 /Products/`, `:37 /Modules/`, `:40 /Research/`,
`:108 /Cluster/`, am Objekt gegengeprueft). Damit ist er der einzige Ort, der alle vier
ueberspannt, **ohne selbst eine von ihnen zu sein**.

## Fuer Leser, die ueber einen Verweis hierher kamen

**19 Dokumente in diesem Repo** nennen den Pfad `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` —
darunter das GOAL v8 (dort als eines der **vier bindenden Dokumente** gefuehrt), der Ledger,
das Dossier und mehrere Session-Uebergaben. Diese Verweise bleiben gueltig: sie fuehren
hierher, und von hier geht es einen Schritt weiter. Deshalb steht hier ein Zeiger und kein
Loch — ein geloeschtes Ziel haette 19 Verweise ins Leere zeigen lassen, und der teuerste
Fehler dieses Projekts ist die Aussage, die aussieht, als haette sie einen Gegenstand.

**Aenderungen gehoeren ab sofort in den Umbrella.** Wer diese Datei hier bearbeitet, pflegt
eine Kopie, die niemand liest.
