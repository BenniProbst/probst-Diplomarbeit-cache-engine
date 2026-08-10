# AUSLAUF-RUNDE — abbruchsichere Pause, Nacht 6

**Datum:** 2026-08-10, 22:15 · **Anlass:** Owner-Auftrag *„lasse die aktuelle Arbeit
auslaufen, nimm keine neue Arbeit mehr auf und speichere alles abbruchsicher, dann pause."*

Dieses Dokument ist **kein Bericht**, sondern ein Sicherungsnachweis: was liegt wo, und was
liefe verloren, wenn diese Maschine morgen nicht mehr hochkaeme.

---

## 1. WAS GESICHERT IST — mit Nenner

### 1.1 Repositorien

    super    a2290ea7   development, sauber, GitLab + GitHub
    ce       c9d17963   development (Remote-Stand)
    Cluster  a2a2201    development

### 1.2 Die 22 Worktrees, vollstaendig geprueft

Gemessen wurde je Worktree `dirty` (Arbeitsbaum) und `ahead` (eigene Commits gegen den
**aktuellen** Remote-Stand — der Fetch-Stand von `wt-ce-tax` wurde gegen `git ls-remote`
gegengeprueft und war aktuell, also ist `ahead=0` eine belastbare Null).

**Drei trugen eigene Arbeit. Sie liegen jetzt als Bundle:**

    ~/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/bundles-20260810-auslauf/

    wt-ce-tax              162 Commits (110 eigene, 52 Merges)   1.302.956 Byte   verify OK
                           276 Dateien, +31.350 / -1.143 Zeilen
                           Branch bau/p1-taxonomie-klasse-i, Basis c9d17963
    wt-ce-d2floor            3 Commits                              19.461 Byte   verify OK
                           Branch w0a/d2-floor, Basis e114cabd
    wt-super-f1-transport    1 Commit                                8.068 Byte   verify OK
                           Branch f1/20-d3-6-transport, Basis 235c29ec

Es sind **Thin-Bundles gegen `origin/development`** — die Basis liegt auf GitLab, sie
ueberleben also einen lokalen Plattenverlust. Alle drei mit `git bundle verify` geprueft.
`wt-ce-tax` ist der ernste Posten: **31.350 Zeilen, die es nirgends sonst gab.**

**Die uebrigen 19 tragen nichts Eigenes.** `wt-super-warn` zeigte einen dirty-Eintrag — es
war ein reiner Gitlink-Drift auf `2eb310ae`, und dieser Commit liegt in **zehn**
Remote-Branches. Kein Inhalt, kein Risiko.

### 1.3 Was NICHT zu retten war

**`bcf6bc97` (r7, Wachenparitaet) ist endgueltig verloren.** In keinem der geprueften Klone
ist das Objekt noch vorhanden. Posten **#77** (Abschrift-Divergenz der Hygiene-Wache zwischen
ce und super) bleibt damit wirkungslos, bis die ce-Haelfte **neu gebaut** wird — das ist kein
Wiederherstellungs-, sondern ein Bauposten.

Die Schwester `93f5952b` (r2) wurde aus demselben Desktop-Backup gerettet und liegt auf dem
ce-Remote. Der Unterschied zwischen beiden ist reiner Zufall: von r2 existierte ein Bundle,
von r7 nicht. **Das ist der Grund, warum diese Runde stattfindet.**

---

## 2. WAS NOCH LAEUFT — und bewusst nicht abgebrochen wurde

Zwei Workflows waren bei Auftragseingang aktiv. Sie wurden **auslaufen gelassen**, nicht
gestoppt:

    wf_80fa369e-9f9   Journal 13 Zeilen   r2 landen, p4, GUARD_BASIS_REF, Lizenz super,
                                          tote Anker
    wf_200fefb7-5f7   Journal  4 Zeilen   Stempel-Reihenfolge Ebene 1, -Wall/-Werror
                                          (GCC-Warnungszensus lief zuletzt noch)

Beide Synthese-Agenten schreiben ihr Ergebnis **selbst als Datei** nach
`docs/sessions/20260810-W0B-RESTPOSTEN-workflow-ergebnis.md` bzw.
`…-CE-STEMPEL-WARNSTUFE-workflow-ergebnis.md`. Zum Zeitpunkt dieser Notiz existiert **keine
der beiden Dateien** — die Ernte steht also aus.

**Liegt eine Datei spaeter nicht vor: das `journal.jsonl` des Runs lesen.** Es ist die
Wahrheit, nicht die Ergebnisdatei; ein Workflow kann stumm sterben, und dann ist die fehlende
Datei das einzige Signal.

    ~/.claude/projects/-home-comdare/5a19728e-*/subagents/workflows/<run>/journal.jsonl

---

## 3. WO DIE WELLEN STEHEN — die ehrliche Antwort

Der Wellenplan sagt **W0a**. Tatsaechlich stehen wir **am Eingang von W0b mit einer Kette,
die schon durchlaufen ist**: von sieben geprueften W0b-Gliedern war **keines** so zu bauen wie
beschrieben. Die Kette bis `##25 DURCHSTICH` ist im Wellenplan durchgestrichen.

**Die Bilanz der Kern-Explores ueber 14 Pakete** — der eigentliche Ertrag des Tages:

    SCHON_ERLEDIGT    6
    STIMMT_TEILWEISE  5
    STIMMT_NICHT      1
    STIMMT            2

**Zwoelf von vierzehn Aufgabendefinitionen waren falsch oder ueberholt.** Zwei der falschen
Posten stammten von mir: **#64** war aus einem Namens-Diff geschnitten (die Tests lagen laengst
auf development, umbenannt und staerker), und den „Stempel-Riss" haette ich repariert, obwohl
er Sollverhalten ist.

Das ist kein Nebenbefund. Es ist die Begruendung der Regel selbst: **an diesem Tag hat der
vorgeschaltete Explore mehr verhindert, als gebaut wurde — und das war der Gewinn.**

**Frist:** F1 ist **Fr 14.08.**, also vier Tage. Danach W1 (F2 Freeze) → W2 (F3) →
**W3-MESS Sa 29.08.–04.09. (F4)** → W4 (F5) → W5 → **Abgabe Di 15.09.**

---

## 4. DER ERSTE GRIFF DER NAECHSTEN SESSION

1. **Ernten, nicht neu bauen.** Die zwei Workflow-Ergebnisse einsammeln (Abschnitt 2).
2. **#77 neu fassen:** r7 ist verloren, der Posten ist ein Bauauftrag, kein Rettungsauftrag.
3. Dann die F1-Liste: **#78** Stempel-Reihenfolge Ebene 1 · **#44** `-Wall`/`-Werror` (D-3,
   genehmigt) · **#48** `GUARD_BASIS_REF` literal · **#66** Lizenz super/prt-art/overleaf ·
   **#63** tote Ledger-Anker.

**Ebene 2 und 3 der Stempel-Reihenfolge brauchen ein eigenes Fenster** und duerfen nicht mit
Ebene 1 vermischt werden — Ebene 2 bricht das ABI (`stamp_layout_version` 6→7), Ebene 3
aendert **jeden** SHA-512 des Preimage.

**Beim Owner, nicht bei mir:** MinIO-**prod** (der Vault traegt nur dev; die dev-Teilabnahme
ist gefahren und mit Gegenprobe belegt) und die Bucket-Policy-Antwort der Infra. Die
Speicher-Ebene sollte **vor** dem 29.08. einmal echt gelaufen sein — nicht am ersten
Kampagnentag zum ersten Mal.

---

*Abbruchsicher heisst: was hier steht, ueberlebt den Verlust dieser Maschine. Was in einem
Worktree liegt und in keinem Bundle, ueberlebt ihn nicht — das hat `bcf6bc97` bewiesen.*
