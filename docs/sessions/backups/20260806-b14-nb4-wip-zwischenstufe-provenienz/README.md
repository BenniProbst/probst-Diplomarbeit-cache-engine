# B14-NB4 -- WIP-Zwischenstufe, gesichert als Provenienz-Beleg

Datum: 2026-08-06
Worktree: `/home/comdare/wt-b14-golden`, Branch `b14-golden-kf6`

## Was dieser Ordner IST

Eine additive Sicherung der **Zwischenstufe (WIP) der autorisierten B14-NB4-Welle**,
zusammen mit den Gate-Logs derselben Welle. Der Ordner ist ein **Provenienz-Beleg**:
er haelt fest, wie der Zwischenstand aussah und wie er einzuordnen ist.

## Was dieser Ordner NICHT ist

Er ist **kein** Beleg eines unautorisierten Fremdeingriffs, und der gesicherte Stand
ist **kein** verworfener Fehlstand. Beides waere die falsche Lesart -- siehe Historie.

## Historie: warum es kurzzeitig nach einem Fremdeingriff aussah

Diese Notiz steht hier, damit die Fehldeutung nicht ein zweites Mal passiert.

1. In `/home/comdare/wt-b14-golden` arbeitete eine **autorisierte B14-NB4-Welle**.
   Sie hatte die fuenf Dateien der Vorgaenger-Stufe ausdruecklich als WIP uebernommen
   und baute darauf weiter.
2. Ein Melder sah den Worktree **mitten in dieser Arbeit**: fuenf geaenderte,
   noch nicht committete Dateien und rund zwanzig neue, ungetrackte Gate-Logs.
   Er kannte die laufende Welle nicht.
3. Aus seiner Sicht lag der Worktree auf `1ba29b63` (Paket B14-NB3) und haette dort
   ruhen sollen -- weil `fixture_sync_check.cmake` als "nicht im Scope" galt und die
   Projektregel "NB4 erst nach BEIDEN Verdikten" ein Freigabe-Gate setzt, wurde der
   Zwischenzustand als eigenmaechtiger Bau eines Fremd-Schreibers gedeutet.
4. **Tatsaechlich** war es der normale Zwischenstand der laufenden Welle. Sie ist
   inzwischen fertig; der Stand ist regulaer gelandet:
   - `2c631551` -- `fix(wachen): die SECHS FALSE-GREEN-PFADE der xmllint-Migration
     selbst geschlossen (B14-NB4, B1-B11)`
   - `9934a7e5` -- `docs(gates): Gate-Spiegel B14-NB4 -- die CE-Gate-Logs fehlten
     bisher komplett (Auflage aus mittag-22)`

Lehre, nicht fuer den Melder, sondern fuer die Auftragsvergabe: **vor jedem
Bereinigungs-Auftrag gehoert ein Lebend-Check, ob in dem Worktree gerade eine Welle
arbeitet.** Ein Melderbericht ist eine Beobachtung, kein Ist-Stand; er muss gegen die
laufenden Straenge geprueft werden, bevor daraus ein Rueckbau abgeleitet wird.
Sonst trifft die Fehlerklasse zu, die dieses Projekt heute mehrfach getroffen hat:
eine Behauptung uebernommen, ohne sie an der Quelle zu verifizieren.

## Es wurde NICHTS zurueckgesetzt und NICHTS geloescht

Der urspruenglich geplante Rueckbau auf `1ba29b63` (Schritt 4 des Auftrags) wurde
**nicht ausgefuehrt**. Er haette die beiden fertigen, mit literalen Bissen belegten
Commits vernichtet. Der Worktree wurde ausschliesslich gelesen.

## Inhalt

| Datei | Inhalt |
|---|---|
| `wt-b14-golden-nb4-wip.patch` | Der WIP-Stand der fuenf getrackten Dateien gegen `1ba29b63`, 702 Zeilen |
| `gates/nb4-*.txt` | 22 Gate-Logs der NB4-Welle, Kopien (Originale unangetastet) |
| `MANIFEST-sha256.txt` | sha256 aller gesicherten Dateien |

Die fuenf Dateien im Patch:

- `Code/tests/CMakeLists.txt`
- `Code/tests/fixture_schema_subset_check.cmake`
- `Code/tests/fixture_sync_check.cmake`
- `Code/tests/golden_n_consistency_check.cmake`
- `Code/tests/xml_canonical_utils.cmake`

## Verifikation

- Patch gegen `git -C /home/comdare/wt-b14-golden diff 1ba29b63 HEAD -- <5 Dateien> --stat`:
  `5 files changed, 381 insertions(+), 75 deletions(-)`, 702 Patch-Zeilen -- deckungsgleich.
- Der WIP-Stand, den der Melder abgegriffen hatte, ist mit dem gelandeten Stand dieser
  fuenf Dateien **byte-identisch**: beide sha256
  `a0862e7fee12692911f39a3829c706e11af0677f2afa1f4626ba3ecad7adf2da`.
  Die Welle hat den WIP also unveraendert gelandet; es ging nie etwas verloren.
- Alle 22 Gate-Log-Kopien `cmp`-identisch mit den Originalen, Zeilensumme je 17616.
- Kein Treffer bei der Credential-Pruefung (glpat, PRIVATE-TOKEN, Authorization, Bearer,
  private keys, AWS-Keys, `user:pass@`-URLs, CI-/VAULT-Env-Dumps).
- Keine TABU-Datei beruehrt (`golden_fullpilot_320*`, `permutation_axes.xml`,
  `m3v2_study.profile.xml`, `system_axis_registry.xml`, `cache_engine_axis_registry.xml`).

## Doppelablage -- bewusst

Die 22 Gate-Logs liegen zusaetzlich committed im Branch `b14-golden-kf6` (`9934a7e5`)
unter `docs/sessions/backups/20260806-b14-nb3/gates/`. Diese Kopie hier auf
`development` ist die **redundante** Zweitablage: `b14-golden-kf6` ist ein rein lokaler
Branch, der auf keinem Remote liegt. Wer die beiden Ordner spaeter zusammenfuehrt, findet
denselben Inhalt an zwei Pfaden -- das ist Absicht, kein Versehen.

## Randbefund (gehoert nicht zu dieser Sicherung, aber nicht untergehen lassen)

Im Haupt-Repo liegt `docs/sessions/backups/20260806-b14-nb3/` **ungetrackt**. Von den
18 Dateien dort tragen die meisten die Endung `.log`, und `.gitignore:49` enthaelt
`*.log` -- sie werden beim Committen also **stumm verschluckt** und sind damit derzeit
nirgends in git gesichert. Die NB4-Welle hat genau diese Falle fuer ihre eigenen Logs
umgangen, indem sie `.txt` statt `.log` verwendet. Fuer die NB3-Logs steht das noch aus.
