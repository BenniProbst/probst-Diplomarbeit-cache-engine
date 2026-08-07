# ABSCHLUSS 07.08.2026 abends — neun Stränge, vier Landungen, die offenen Entscheide

**ERST-ANKER für die nächste Session.** Dieses Dokument ist so geschrieben, dass ein Wiederanlauf
allein damit möglich ist.

> **LESE-REIHENFOLGE**
> 1. Dieses Dokument, Abschnitt 2 (**was auf dich wartet**) und 3 (**der Stand**)
> 2. `docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md` — die sechs Stempel-Entscheide, entscheidbar allein über die Kurzfassung
> 3. `docs/plaene/20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md` — die geltende Grammatik
> 4. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachträge **abend-1 bis abend-12**

---

## 1. REFS (Stand Kontextende)

| Repo | Branch | Ref | Pipeline |
|---|---|---|---|
| ce | development | **`5060489e`** | **15221 grün** |
| ce | `bau/m3a-branch-misses-ehrlichkeit` | `aa06f900` | 15224 lief noch |
| super | development | **`123a1f97`** | 15223 grün |
| thesis | development | `eaf7fe8` | unberührt |

**Alle Bau-Branches sind gesichert.** `bau/allocators-coverage-gate` und `bau/flag-grammatik-v2-s1`
sind in `development` gelandet; `bau/m3a-branch-misses-ehrlichkeit` ist **gepusht, aber bewusst
nicht gemergt** — sein Abschlussbericht steht aus, er ist ungeprüft.

---

## 2. WAS AUF DEN OWNER WARTET — nach Kosten des Aufschubs

### 🔴 A · Fenster 0 schließt sich unwiderruflich — E-E
Der **einzige** Entscheid mit echter Frist. Nachgemessen 07.08.: **null `.fingerprint`-Dateien** in
beiden Worktrees. Heute kostet ein Dreh am Preimage **nichts**; nach dem ersten Batch **~34,4 h
Neubau plus Entwertung aller Messdaten**.
Es ist **keine Ja/Nein-Frage** — `anatomy_fingerprint.hpp:120-123` nennt drei Unterfragen, ohne die
E-E auch bei „ja" nicht baubar ist: **Verzeichnis-Schnitt · Sortier-Ordnung · Hash je Datei vs.
Konkatenation**.
*Lead-Empfehlung:* jetzt scharfschalten, im selben Fenster wie die Grammatik — dort ist die
Invalidierung ohnehin gewollt, also einmal zahlen statt zweimal.

### 🔴 B · Drei Lizenz-Abweichungen in einer gedruckten Tabelle (Task #42)
| Profil | Akte trägt | Thesis nennt |
|---|---|---|
| `michael_lockfree` | LGPL-2.1-or-later | BSD-3 |
| `tcmalloc` | Apache-2.0 | BSD-3 |
| `lrmalloc` | MIT | BSD-3 |
Bei `michael_lockfree` nennt `PAPER_REFERENCES.md` eine **dritte** Angabe (MIT).
**Eigentumslage beachten:** die Thesis gehört Benjamin-Elias Probst **privat**, die CacheEngine der
**BEP Venture UG** (Marke Comdare). Das sind Tatsachenbehauptungen über **Fremdcode** in einer
persönlichen Prüfungsleistung. Maßgeblich ist die Lizenzdatei des tatsächlich vendorierten Codes
unter `ext/allocator/A*`.
**Offene Frage an den Owner: darf der Lead die Thesis dafür anfassen?**

### 🟡 C · Vier weitere Stempel-Entscheide + zwei aus der Grammatik
- **E-A** 24 Hex · **E-B** nur `.rodata` · **E-C** Sidecars auf den POD (**Empfehlung gekippt**) ·
  **E-D** Ordnernamen auf den Stempel — alle in der Vorlage, Kurzfassung entscheidbar.
- **E-F** braucht **eine Bestätigung**: gilt Section43.b für die *gerenderte* Zeile? Ohne sie baut
  der Lead dort nichts. E-F schaltet S1 frei, den einzigen jederzeit landbaren Schritt.
- **MMX-Basis-Frage** (aus dem Grammatik-Bau): MMX/3DNow liegen auf x87-aliasierten Registern. Die
  Form trägt **beide** Gestalten — bloßes Token oder eigene Basis (`c.x64{mmx...}`). Das ist eine
  **Aussage über die Hardware**, keine Formfrage. Bewusst nicht geraten.
- **Präfix-Stripping-Kurzform** `x128{2.3.41.42}`: verlangt, die Token-Regel aufzugeben — und genau
  die verhindert, dass `avx10.1` still als zwei Geschwister gelesen wird.

### 🟡 D · Kleiner, aber Owner-Sache
- **Thesis-Stolperstelle:** „achtzehn Achsen … 2^17" ist **rechnerisch richtig** (eine Achse ist
  gepinnt), aber ein Prüfer rechnet 2^18. **Ein Halbsatz würde es klären.**
- **`RunMethodology`-Enum**: soll er die Stufenordnung tragen? Umstellen wäre ein ABI-Ereignis.
- **T19 `persistence_target`**: Min/Max-Semantik fehlt (honest-empty, nichts geraten).
- **Dual-Review-Pflicht**: gilt *„JEDE Bau-Welle vor Landung Codex+Fable"* weiter, oder ist sie
  durch Vor-Push-Wache + Bissproben abgelöst? Heute wurde stattdessen **jeder Bau vom Lead selbst
  gegengelesen** — das hat vier Fehlbefunde aufgedeckt, drei davon eigene.
- **Platten-Aufräumung**: ~34 GB liegen in Worktrees abgeschlossener Arbeiten. **Nicht eigenmächtig
  angefasst** — Worktrees können ungetrackte Arbeit tragen, und in ce-`build/` liegen getrackte
  Messdaten-CSVs. Ein Inventar-Explore lief bei Kontextende noch (lokal + prod1 + prod2); er
  **löscht nichts**, sein Produkt ist eine Liste mit Rückholbarkeits-Klasse je Posten.

---

## 3. WAS HEUTE GELANDET IST

| Paket | Ref | Beleg |
|---|---|---|
| **Flag-Grammatik v2** | ce `5060489e` | 422/422, Pipeline 15221 grün, 178 Dateien |
| **allocators-Abdeckungs-Gate** | ce `5adf59ea` | 7 Bissproben rot, Pipeline 15218 grün |
| **175 stale Doku-Anker** in 17 Dokumenten | super `123a1f97` | je Dokument Stale-Block mit Ist-Tabelle |
| **STOPP-Gates-Vorlage** (537 Z.) | super `3e2c79ee` | alle sechs offen, Empfehlung neu `b/ii/a/a/a/a` |
| **G-7-Korrektur** | super `c34ce1d6` | die Zeile lud zum Bau ohne Entscheid ein |

**Nicht gelandet, aber gesichert:** M-3a (`branch_misses`) auf `bau/m3a-branch-misses-ehrlichkeit`.

---

## 4. DIE VIER FEHLBEFUNDE DES TAGES — alle vom Lead, alle korrigiert

Sie stehen hier, weil sie **ein Muster** bilden und der nächste Kontext es kennen muss:

1. **Phasen-Fehlzuordnung** — „Phase 3/4" der falschen von **drei** realen Nummerierungen zugeordnet.
2. **„Limits-Entkopplung nicht verdrahtet"** — sie ist seit Wochen vollzogen **und härter gebaut als
   geplant**. Der Bericht hatte einen `cmake_language(DEFER … CALL …)` übersehen, den eine
   Namenssuche in `tests/` nicht findet.
3. **„allocators vergessen"** — die Frage war am 22.07. **im Aktenkopf** beantwortet, nur nicht im
   Ledger. Alle 23 Akten tragen den Vermerk.
4. **Bau-Mengen-Dringlichkeit** — „vor dem ersten Batch" war falsch; das eigene Gesamtdossier sagt
   „vor der Voll-Messung".

**Gemeinsamer Nenner: eine ABWESENHEIT wurde als AUSSAGE genommen.**
**Die Regel, die daraus folgt und die jedem Auftrag mitgegeben wird:** *„X ist nicht verdrahtet /
fehlt / ist vergessen" ist ein NULLBEFUND* — er wird erst zur Aussage mit der Gegenprobe: **wer
inkludiert, linkt, ruft, referenziert X — und steht die Antwort vielleicht woanders?**

**Zwei eigene Verfahrensfehler**, ebenfalls gebucht (Memory-Klassen 7 und 8):
- **committet und gepusht, während die eigene Prüfung dazu noch lief** — ein Commit ist eine
  Festlegung und wird der Anker der nächsten Session.
- **`git add -A docs/` neben einem arbeitenden Agenten** — dabei seinen unfertigen Zwischenstand
  veröffentlicht. Die Doktrin verbietet `-A` genau deshalb.

---

## 5. WAS DIE AGENTEN BESSER GEMACHT HABEN ALS DER LEAD

Dreimal hat ein Bau-Agent etwas gefunden, das die Lead-Prüfung **nicht** gefunden hätte:

1. **Grammatik:** der Agent hat die Owner-Auflage („der Bruch muss laut sein") **gemessen** — und
   sein *eigener* erster Commit bestand die Probe nicht: eine Composition mit `v1.0.0c` an allen 18
   Organ-Achsen übersetzte klaglos und lieferte achtzehn `@0.0.0` in den SHA512-Fingerprint. Der
   Lead hatte die **Wache** geprüft, der Agent die **Stelle, an der der Schaden entsteht**.
   *Frage, die daraus folgt:* deckt die Wache **jeden Pfad**, auf dem der geschützte Wert entsteht?
2. **allocators:** Biss B deckte eine Falschaussage im **eigenen Kommentar** des Agenten auf — der
   XML-Reader ist *fehlertolerant, nicht validierend*. Ohne die Bissprobe wäre sie im Repo gelandet.
3. **allocators, zweitens:** der Agent hat der **Auftragsformulierung des Leads widersprochen**
   („vergessener Posten") und dem Objekt geglaubt. Er hatte recht.

---

## 6. LAUFENDE VORGÄNGE BEI KONTEXTENDE

| Vorgang | Zustand | Was fehlt |
|---|---|---|
| `Platz-Inventar` (Explore, lokal+prod1+prod2) | **lief noch** | soll auslaufen; löscht nichts |
| ce-Pipeline **15224** (`aa06f900`) | lief noch | Grün-Beleg für M-3a |
| **M-3a-Abschlussbericht** | **steht aus** | `sizeof`-Wache? Bissprobe auf Nicht-Null? Schema-Vorschlag? |

**Vor dem Landen von M-3a zu klären** (stand so im Auftrag): trägt `PmcCounters` eine
`sizeof`-Wache · liefert ein Lauf einen **von Null verschiedenen** `branch_misses`-Wert (sonst wäre
das Feld nur umbenannt) · was wurde an der zweiten Pipeline gebaut und was als Schema-Vorschlag
zurückgehalten.

---

## 7. DER PLATTEN-VORFALL — Ursache und Lehre

Der Datenträger war **zu 100 % voll** (50 MB von 251 GB) und machte Pipeline 15221 rot:
`ld: final link failed: No space left on device`. **Der Code war nie schuld** — 19 von 20 Jobs
grün, darunter `lint:static` (cppcheck), genau das Gate, das als Risiko galt.

**Die Ursache lag beim Lead:** 14 GB gitleaks-Klone im eigenen Job-Verzeichnis. Für jeden Scan wurde
ein vollständiger Repo-Klon angelegt (260 MB bis 1,1 GB) und nicht konsequent entfernt.
Aufgeräumt **mit Vorsicht**: vor jedem Löschen Herkunft und `status --porcelain` geprüft, nur Klone
mit **null** uncommitteten Änderungen entfernt, ein Verzeichnis ohne `.git` stehen gelassen. Danach
15 GB frei, Neustart → **grün**.

**Lehre, ab sofort befolgt:** den gitleaks-Klon **im selben Befehl** wieder entfernen, in dem er
angelegt wurde.
