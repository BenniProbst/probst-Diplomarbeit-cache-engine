# B14-NB3 -- Gate-Belege der CE-Seite

Datum: 2026-08-06
Welle: **B14-NB3** (`fix(wachen): B14-NB3 -- Selbstbau-XML-Parser der zwei ctest-Wachen
ersatzlos durch xmllint abgeloest`, super `1ba29b63`)
CE-Anteil: Branch `b14-ce-anteil`, u.a. `16a173f2`
(`fix(layout): cache_lines_touched folgt der cacheline-Unterachse statt dem Literal 64`)

## Was hier liegt

Die Gate- und Biss-Belege der NB3-Stufe: Configure- und Vollbau-Laeufe, zwei serielle
ctest-Laeufe, sowie die Praeparate samt Ausgabe zu Frozen-Sonde, CLU-Beweis, Bump-Beweis,
golden-CRC-Roundtrip und dem Repro des Lead-Befundes A. Dazu `nb3-ce.patch` als
Stand der CE-Seite und `DOPPELLAUF-LITERALE-B14-NB3-CE.txt` mit den literalen
Doppellauf-Zahlen.

Ohne diese Dateien ist die NB3-Stufe **unbelegt** -- die Zahlen waeren behauptet, nicht
abgelegt. Genau das ist der Grund fuer diese Ablage.

## Warum die Endung `.txt` und nicht `.log`

Diese Dateien lagen bis zu diesem Commit **ungetrackt** im Arbeitsbaum, zwoelf von
achtzehn mit der Endung `.log`. `.gitignore:49` fuehrt `*.log` -- sie waeren bei jedem
normalen Commit **stumm verschluckt** worden und waren damit nirgends in git gesichert.
Ein Beleg, der sich beim Committen selbst verschwinden laesst, ist kein Beleg.

Die nachfolgende NB4-Welle hatte diese Falle fuer ihre eigenen Logs bereits umgangen,
indem sie `.txt` statt `.log` verwendet (im Commit-Text von `9934a7e5` ausdruecklich
begruendet). Die zwoelf NB3-Dateien sind darum auf denselben Weg gezogen worden,
statt sie per `git add -f` unter `.log` zu erzwingen. Zwei Gruende:

1. **Beide Stufen sehen jetzt gleich aus.** Wer NB3- und NB4-Belege nebeneinander sieht,
   muss nicht raten, warum die einen `.log` heissen und die anderen `.txt`.
2. `git add -f` haette den Namen bestehen lassen, der die Falle ausloest. Tracked-Dateien
   sind zwar gegen `.gitignore` immun, aber der Name passt weiter auf jedes
   `*.log`-Aufraeummuster -- die Falle waere nur zugedeckt, nicht beseitigt.

**Der Inhalt ist unveraendert.** Nur die Endung wurde gezogen; die Basisnamen sind
identisch geblieben, `nb3-ce-vollbau.log` heisst jetzt `nb3-ce-vollbau.txt`. Alle zwoelf
sha256-Summen von vor der Umbenennung finden sich unveraendert wieder (Beleg:
`MANIFEST-sha256.txt`). Kein anderer Ort im Repo verweist auf die alten `.log`-Namen --
das wurde vor der Umbenennung geprueft, die Referenzsuche blieb leer.

Die sechs uebrigen Dateien (`.txt`, vier `.cpp`, `.patch`) waren nie ignoriert und sind
unangetastet.

## Geprueft vor der Ablage

- **Credential-Scan** ueber alle 18 Dateien, Bezugsgroesse **21990 Zeilen / 2790913 Bytes**,
  keine Binaerdatei darunter: kein Treffer auf glpat, PRIVATE-TOKEN, Authorization,
  Bearer, private keys, AWS-Keys, `user:pass@`-URLs, CI-/GITLAB-/VAULT-Env-Dumps.
- Die langen Hex-Ketten in `nb3-ce-frozen-sonde.txt` und
  `DOPPELLAUF-LITERALE-B14-NB3-CE.txt` sind der ausgewiesene `Frozen-Digest (RT-Weg)`
  bzw. git-SHA-1 aus `nb3-ce.patch` -- Inhalts-Pruefsummen, keine Geheimnisse.
- `git check-ignore` je Datei nach der Umbenennung: **keine wird mehr verschluckt.**

## Anmerkung zur Werkzeug-Falle

Auf manchen Hosts dieses Projekts ist `/usr/bin/grep` ein ugrep, auf dem das uebliche
ASCII-Gate-Muster `grep -P '[^\x00-\x7F]'` mit Syntaxfehler abbricht und **still 0**
liefert -- ein Gate, das nie gemessen hat, meldet "sauber". Auf dem Host dieser Ablage
ist `grep` GNU grep 3.11 und `-P` verhaelt sich korrekt (am Objekt geprueft: Treffer
RC=0, kein Treffer RC=1). Die Scans oben sind zusaetzlich mit `-E` und mit Exit-Code-
Auswertung gefahren, und die Bezugsgroesse ist mit angegeben statt nur der Null.
