#!/usr/bin/env bash
set -eu
Z=/home/comdare/wt-super-f1-transport
git -C "$Z" config user.name  "Benjamin-Elias Probst"
git -C "$Z" config user.email "benjamineliasprobst@gmail.com"
git -C "$Z" add -- .gitlab-ci.yml ci/anhang_forward_core.sh ci/tests/anhang_forward_probe.sh
echo "== GESTAGT (muss GENAU diese drei sein) =="
git -C "$Z" diff --cached --name-only
git -C "$Z" commit --file=- <<'BOTSCHAFT'
fix(anhang): die fuenfte Transportfalle -- "IDEMPOTENT" hiess auch "nichts angekommen"

Posten ##20. Am Objekt gemessen, mit gewuerfeltem Koeder (/dev/urandom):

  Ziel-Repo mit 'anhang/**/tabellen/*.tex' in der .gitignore
    -> "kopiert gesamt: 1 .tex" / "gestagte Aenderungen: 0"
    -> "=== anhang:forward IDEMPOTENT: 0 Aenderungen -> kein Commit ==="
    -> rc=0, Commits 1->1, Koeder NICHT im committeten Blob.
  GEGENPROBE, byte-gleiche Fixture ohne die Ignorier-Regel
    -> Commit, Koeder im Blob.

Der Unterschied zwischen den beiden Laeufen war genau die Ignorier-Regel -- der
Kanal sagte beide Male dasselbe Wort. Das ist die Fehlerklasse von F1-F4, eine
Station weiter unten und fail-OPEN: der Messwert weg, der Job gruen.

DIE VORSCHRIFT DES WELLENPLANS WAR FALSCH und wird hier korrigiert. ##20 verlangt
woertlich "`|| true` beim git add faellt". Nachgemessen: der CI-Job setzt
AF_LANGS="de,en", eine Quelle darf legitim nur 'de' tragen; dann gibt es
'anhang/en/tabellen' im Ziel gar nicht, 'git add' bricht mit "pathspec ... did not
match any files" ab und 'set -e' toetet den Kanal -- rc=128, kein Commit, obwohl
die de-Haelfte fertig kopiert dalag. Das '|| true' war nicht der Defekt, sondern
die Kruecke fuer ein falsches Pathspec. Geheilt wird das PATHSPEC: gestagt wird
genau das, was DIESER Lauf geschrieben hat ($COPIED_LIST, fuer den Rollback
ohnehin schon da). Damit kann 'git add' an einer nicht bedienten Sprache nicht
mehr scheitern, und ein Fehlschlag ist wieder ein echter.

Das Orakel ist der INDEX, nicht der Rueckgabewert: gefragt wird nicht, ob
'git add' zufrieden aussah, sondern ob die Datei danach drinsteht. Gedruckt wird
immer
    Uebernahme-Nenner: kopiert=N im_index=M nicht_uebernommen=K git_add_fehler=F
"0 Aenderungen" heisst ab jetzt belegbar "alle N liegen im Index und sind
byte-gleich" -- und nicht mehr auch "keine ist angekommen".

ABNAHME, gefahren (rc ohne Pipe gemessen, K11):
  14 von 14 Faellen gehalten (vorher 11), 7 von 7 Mutanten gebissen (vorher 6).
  A12 Ziel ignoriert die .tex -> rot mit Nenner und Dateinamen
  A13 GEGENRICHTUNG, byte-gleiche Fixture ohne Ignorier-Regel -> Commit + Koeder
  A14 zweiter Lauf -> IDEMPOTENT, KEIN zweiter Commit (echte Idempotenz bleibt echt)
  N7 nimmt dem Kanal das URTEIL, laesst die Zahl stehen -> genau A12 stirbt.
     Kein Scheinbiss: 1 fachlicher Riss, und es ist der richtige.

NICHT GEDECKT, ausdruecklich (in der Testkritik der Probe eingetragen): der
zweite Weg in dieselbe Falle -- 'git add' meldet 0 und die Datei fehlt trotzdem
im Index (index.lock, entzogenes Schreibrecht mitten im Lauf). In einem Fixture
nicht ehrlich herstellbar; er bleibt ein defensives Netz, keine gefahrene Deckung.

Die Aenderung an .gitlab-ci.yml ist EIN Kommentarblock (Fall- und Mutantenzahl
des Probe-Jobs, sonst waeren 10/A1-A10 und 6 Mutanten als Prosa verjaehrt).
Job-Rumpf, rules und Aufrufe sind unberuehrt.

Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>
BOTSCHAFT
echo
echo "== COMMIT =="
git -C "$Z" log -1 --format='%H  %s'
echo "Zweig: $(git -C "$Z" rev-parse --abbrev-ref HEAD)"
echo "Basis: origin/development = $(git -C "$Z" rev-parse origin/development)"
