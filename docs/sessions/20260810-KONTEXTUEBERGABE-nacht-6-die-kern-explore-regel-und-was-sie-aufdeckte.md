# KONTEXTÜBERGABE — Mo 10.08.2026, Nacht 6

> **Vorgänger:** `20260810-KONTEXTUEBERGABE-nacht-5-scrub-lizenz-versionierung-und-der-kern-explore.md`
> **Stand:** super `d8f3cd77` · ce `e114cabd` (dev+main) · Cluster `a2a2201`
> **Zwei Workflows laufen und persistieren ihr Ergebnis SELBST** — Abschnitt 1.

---

## 0. DIE ERSTEN ZEHN MINUTEN

1. **Neu gründen** — `MEMORY.md`, `MEMORY-DETAIL.md`, dann diese Datei.
2. **Die zwei Workflow-Ergebnisse einsammeln.** Sie schreiben sich selbst nach:
   - `docs/sessions/20260810-W0B-RESTPOSTEN-workflow-ergebnis.md`
   - `docs/sessions/20260810-CE-STEMPEL-WARNSTUFE-workflow-ergebnis.md`
   Liegt eine Datei nicht vor: `journal.jsonl` des Runs lesen — **er ist die Wahrheit**, nicht der
   Fortschrittsbaum. Runs: `wf_80fa369e-9f9` (super-seitig) · `wf_200fefb7-5f7` (ce-seitig).
3. **Die drei bindenden Dokumente** paginiert lesen (der Wellenplan sprengt einen `Read`):
   Goal v8 Lesefassung 241 Z. · Dossier 659 Z. · **Wellenplan v2 jetzt 1084 Z.** inkl. der neuen
   Fußnote **F1-KERN**.

---

## 1. ⭐ WAS LÄUFT UND WIE ES ZU ERNTEN IST

| Run | Task | Gegenstand |
|---|---|---|
| `wf_80fa369e-9f9` | `wnq4aqu8a` | r2 landen · p4 landen · `GUARD_BASIS_REF` · Lizenz super · tote Anker |
| `wf_200fefb7-5f7` | `wfc1d0sh9` | Stempel-Reihenfolge Ebene 1 · `-Wall`/`-Werror` |

**Disjunkt geschnitten:** der zweite fasst nur `ce/libs` und `ce/cmake` an; die drei Dateien des
ersten (`super/.gitlab-ci.yml`, `super/LICENSE`, `ce/tests/unit/test_d2_abdeckungs_wache_nenner.cpp`)
sind ihm im Prompt **namentlich verboten**.

**Jedes Paket hat eine Pflicht-Stufe-0** (Kern-Explore) und wird adversarisch geprüft. Ein Paket ist
nur landefähig, wenn die zweite Lens es getragen hat.

> **Warum die Ergebnisse in Dateien gehen:** mein Kontext endete absehbar. Ein Workflow, dessen
> Ergebnis niemand aufnimmt, ist Scheinfortschritt (Goal v8 §IV). Die Synthese-Agenten schreiben
> deshalb selbst — das überlebt jeden Kontextwechsel.

---

## 2. ⭐ DIE REGEL DIESES TAGES — und was sie gekostet hätte

**Owner, 10.08.:** *„Jede Verarbeitung braucht vorne einen Explore, ob überhaupt der **Kern** ihrer
Aufgabe stimmt, sonst müssen wir die **Definition der Aufgabe** korrigieren."*

**Bilanz über 14 so geprüfte Pakete:**

| Urteil | Anzahl |
|---|---|
| `SCHON_ERLEDIGT` | 6 |
| `STIMMT_TEILWEISE` | 5 |
| `STIMMT_NICHT` | 1 |
| **`STIMMT`** | **2** |

**Zwölf von vierzehn Aufgabendefinitionen waren falsch oder überholt.** Ohne die vorgeschaltete
Prüfung wären sie alle gebaut worden — jede als *zweite Wahrheit* neben etwas Fertigem.

### Die drei teuersten Einzelfunde

**(a) Mein eigener Posten #64 war falsch.** Ich hatte fünf Testnamen per `comm -23` verglichen und
„fünf fehlen" geschlossen. Am Objekt sind **vier von fünf** auf development bereits da — *umbenannt
und stärker*. `AbgestuerztesCtest…` heißt dort `KaputteInventurIstWerkzeugFehler` und prüft
zusätzlich das Phantom-Gate. Der Nenner geht **41 → 42**, nicht 41 → 46.

> **Ein Namens-Diff ist kein Sach-Diff.** Wer Tests vergleicht, muss ihre **Aussage** vergleichen.

**(b) Der „Stempel-Riss" war Sollverhalten.** Ich meldete „`measurement_line` ist leer, weil der
Perm-Pfad den 2-arg-Zweig trifft". Die Kette ist korrekt verdrahtet; der Kommentar an der
Aufrufstelle sagt wörtlich *„UNGESETZT/[all] => "" => byte-identische Quellen"*. Der leere Stempel
**schützt** den golden-320-Pfad. Ich hätte einen funktionierenden Mechanismus repariert.

**(c) Der Hauptstrang ohne Vorprüfung:** dort war in **fünf von fünf** Fällen der Bauauftrag am
Objekt falsch. Vier der fünf Bauenden haben ihren eigenen Auftrag widerlegt.

> **Der Plan ist keine Quelle über den Code. Er ist eine Behauptung über ihn.**

---

## 3. WO WIR IM GESAMTPLAN STEHEN

    Heute Mo 10.08.  ->  Plan sagt W0a (10.-12.08.)
    F1               ->  Fr 14.08., VIER TAGE
    F2 Freeze        ->  Fr 21.08.
    ABGABE           ->  Di 15.09.

**Tatsächlich weiter als der Plan — aber nicht durch Bauen, sondern durch Messen.** Von den sieben
geprüften W0b-Gliedern war **keines** wie beschrieben zu bauen. Die Reihenfolge-Kette bis
`##25 DURCHSTICH` ist im Wellenplan durchgestrichen.

**Ehrlich formuliert:** wir stehen am Eingang von W0b mit einer Kette, die schon durchlaufen ist.
Zwischen uns und F1 stehen nicht die geplanten Glieder, sondern **fünf neu geschnittene Restposten**
— genau die, die gerade laufen.

---

## 4. WAS HEUTE GELANDET IST

| SHA | Inhalt |
|---|---|
| super `c33e298c` | Ernte der sieben Kern-Urteile → Fußnote **F1-KERN**, Ledger `KON4-01…11` |
| super `fd0d0b3a` | Korrektur an KON4-10 → `KON5-01…06` |
| super `228d3519` | Pipeline entrotet: Plan-Anker + Allowlist |
| super `7144f4f6` | Probe-Fix K7 |
| super `a783f436` | mein eigenes Nicht-ASCII |
| super `c19eca87` | r3 (D3-3b) + r4 (##20-B) |
| super `d8f3cd77` | **der laute Storage-Guard** |
| ce | `bau/d3-7b-pruef-only-bilanz` = `93f5952b` — **gerettet** |
| Cluster | `a2dbff1` · `cafd5e1` · `6e5d4cd` · `a2a2201` — vier Handouts |

**Beide Pipelines grün:** super `15620`, ce `15576`.

---

## 5. DIE MINIO-KETTE — vier Handouts an einem Abend

**Ausgangslage:** der Scrub nahm `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY` mit.

**Was der Infra-Agent lieferte:** den Fundort (dev-Vault, Rolle
`minio-svcacct-buildsystem-cache-ci`, md5-8 `577af54d`, Zeile 470) — **und den Grund, warum meine
eigene Suche nie funktionieren konnte:**

    minio.prod.comdare.de -> beide Gateways   HTTP=000, Timeout 10,0 s
    minio.comdare.local   -> Positivkontrolle HTTP=200

> *„Unbekannte SNI ⇒ kein Backend ⇒ Timeout — und ein Timeout sieht aus wie ein falsches
> Schlüsselpaar."*

Ich habe ein Credential-Problem gesehen, wo ein **Netzwerk**-Problem lag.

**Und „nachtragen" existiert nicht:** MinIO gibt SecretKeys nie wieder heraus. Was am 19.07. nicht
hinterlegt wurde, ist **verloren**. Nur Neuerzeugung, prod-Mutation, Owner-Gate.

### Vollzogen (dev, als ausdrückliche Teilabnahme)

    COMDARE_MINIO_ENDPOINT   https://minio.comdare.local
    COMDARE_MINIO_BUCKET     buildsystem-cache
    MINIO_ACCESS_KEY         buildsystem-cache-ci    masked, protected=false
    MINIO_SECRET_KEY         (len 40)                masked, protected=false

Belegt mit der echten `MC_HOST_prodcache`-Konstruktion: `ls/cp/rm` im Zielbucket je `rc=0`, und die
**Gegenprobe** auf `cache-engine-tier-binaries` `rc=1`. Zugang **und** Enge in einem Lauf.

**`protected=false` gegen den ursprünglichen Rat, aber begründet:** ich habe gemessen, dass
`development` geschützt **ist** (`protected_branches` = `['development','main']`), `true` wäre also
zulässig. Der Nutzen ist gering, das Risiko eines unsichtbaren Werts auf einem Feature-Branch real.

### Der Fehler, den wir beide machten

    er:  cut -c1-200    -> SAN übersehen  -> "kein .local-SAN"
    ich: MINIO[A-Z_]*   -> Präfix gekappt -> "vier Variablen fehlen" (es waren zwei)

Zweimal am selben Tag, unabhängig, in zwei Repos.

> **Ein Negativbefund aus einer GEKÜRZTEN Ausgabe ist kein Befund.**

Gerettet hat uns beide dasselbe: **den Widerspruch stehen lassen.** Ich meldete `rc=0` gegen
`.local` als offene Frage statt sie wegzuerklären; er maß nach statt zu verteidigen.

### Offen bei der Infra

prod-MinIO **existiert** (Namespace `minio`, StatefulSet) — hart auf die tote Node gepinnt,
Longhorn-Volume `detached`, `numberOfReplicas=2` bei **einer** Replica, `robustness=unknown`. Er hat
es **nicht** attacht. Richtig so: ein Attach hätte funktionieren *können*, und wir hätten nie
erfahren, ob es hätte schiefgehen können.

**Merkposten:** der `out-of-service`-Taint auf prod1 muss **weg, bevor prod1 startet**.

---

## 6. EIN BEINAHE-VERLUST

Die Workflow-Worktrees von r2 und r7 waren aus `wt-super-landung` **verschwunden** — mit ihnen die
zwei ce-Hälften, die nirgends sonst lagen. Gefunden im **Desktop-Plain-Backup**; das r2-Bundle war
intakt, Basis vorhanden, sofort auf den ce-Remote gesichert.

**`bcf6bc97` (r7, Wachen-Parität) bleibt verloren** — im Backup-Submodul nicht auflösbar. Ohne sie
ist Posten #77 wirkungslos. **Das gehört als Erstes geprüft.**

> Ihre Beobachtung von gestern, in aller Schärfe bestätigt: **was gelandet ist, überlebt; was im
> Worktree liegt, nicht.**

---

## 7. MEINE FEHLER — vollständig, weil das Muster zählt

| Fehler | Was ihn fing |
|---|---|
| Monitor auf `glab` armiert, das nicht existiert — 40 Min Schweigen | erst mein Nachblick |
| Hygiene-Wache über 55 statt 71 Commits (lokaler HEAD ≠ FF-Ziel) | die Ausgabe nennt ihren Bereich selbst |
| nur eine von **zwei** `script:`-Zeilen gefahren → lokal grün, CI rot | die CI |
| eigenes Nicht-ASCII („grün" statt „gruen") im selben Commit, in dem ich die Regel notierte | der Workflow |
| `MINIO[A-Z_]*` ohne Präfix-Anker | die API-Antwort |
| MinIO-Suche: 9.312 Paare = 10 h, nicht vorgerechnet | Ihr „die Suche wirkt nicht" |
| `pkill -f minio-blind.sh` traf die eigene Shell | Exit 144 |
| Posten #64 aus einem Namens-Diff geschnitten | der Kern-Explore |

Alle dieselbe Familie: **ein richtiges Messgerät am falschen Gegenstand.**

**Zwei Regeln sind daraus ins Gedächtnis gewandert:** den vollen `script:`-Block fahren, nicht nur
seinen Hauptteil · ein Grün aus Zufall ist von einem gebauten nicht zu unterscheiden (K7 war grün,
weil zwei unabhängige Zahlen zufällig gleich waren).

---

## 8. OFFENE POSTEN

**Sofort:** die zwei Workflow-Ergebnisse ernten · `bcf6bc97` retten oder r7 neu bauen ·
r2 landen, sobald der Workflow es vorlegt.

**Danach:** #48 `GUARD_BASIS_REF` literal · #77 Wachen-Divergenz (779 vs. 558 Zeilen, verschiedene
Optionsnamen) · #78 Ebene 2/3 der Stempel-Reihenfolge (ABI-/Fingerprint-Bruch, **eigenes Fenster**)
· #67 Versions-Stempel · #69 W12-B.

**Beim Owner:** MinIO-prod (Owner-Gate) · `bucket`-Policy-Antwort der Infra.

**Entschieden und nicht mehr zu fragen:** `-Wall`/`-Werror` = **D-3 „Ja alle einführen"** ·
Reihenfolge = **Mess → System → Organ**, vierfach belegt · `Projekte`-Repo nur GitLab, weil dort der
Gesamtplan liegt.

> ⚠️ **KORREKTUR-EINSCHUB 11.08.2026 — die Zeile darüber ist in EINEM Punkt falsch. Sie bleibt
> wörtlich stehen, weil der Bestand an Irrtümern selbst ein Datum ist (Muster D2-G4/D2-G5).**
>
> **Was hält:** `-Wall`/`-Werror` als D-3 (aber neu zugeschnitten, s. u.) und `Projekte` nur GitLab.
>
> **Was NICHT hält: „Reihenfolge = Mess → System → Organ, vierfach belegt".** Der Owner-Satz vom
> 10.08. lautet *„system sollte immer vorn stehen und organ hinten"* — er legt **zwei** Positionen
> fest, nicht drei. Beide Ordnungen erfüllen ihn:
>
>     {Format, measurement, system, organ}   ODER   {Format, system, organ, measurement}
>
> **Wo MESS steht, ist offen.** Der Zehn-Wochen-Explore fand dazu nichts: Ledger flach
> (2.734.392 Byte) → `Preimage-Ordnung` = 0 Treffer, `system vor organ` = 0. Die Festlegung ist
> **neu**, nicht vergessen — und ohne sie ist Ebene 3 des Stempels nicht baubar. Sie liegt seit
> 11.08. beim Owner.
>
> **Die „vierfache Belegung" belegt etwas anderes**, als dieser Satz behauptet: sie stützt die
> Aufzählung *„Mess/System/Organ"* als Nennung der drei Stufen, nicht als Reihenfolgen-Anweisung
> für die Preimage-Glieder. Das ist die Verwechslung, aus der die falsche Zeile entstand.
>
> **Gefunden hat es nicht mein Nachlesen, sondern ein Explore-Agent**, der diesen Satz gegen das
> gleichentags geschriebene `20260810-CE-STEMPEL-WARNSTUFE-workflow-ergebnis.md` hielt und den
> Widerspruch meldete. In der Memory war er da bereits korrigiert; **hier stand er noch** — ein
> gelandetes Dokument altert nicht mit, wenn man nur das Gedächtnis nachzieht.
>
> **Zur Warnstufe im selben Zug:** „`-Wall` einführen" ist **gegenstandslos** — die Option steht in
> `ce/cmake/compiler_flags.cmake:22`. Globales `-Werror` in einem Schritt darf nicht landen: es
> macht **12 heute gedeckte Ziele** mit 26 Warnungen sofort rot. Neuer Zuschnitt S0…S3, vollständig
> in Task #44.

---

## 9. WAS SICH AN DER DOKTRIN GEÄNDERT HAT

**Neu:** `reference_stempel_reihenfolge_system_vor_organ` — mit der Korrektur, dass es **keine**
Neuordnung ist, sondern die überall geltende Ordnung.

**Verschärft:** `reference_ein_gruenes_gate_deckt_nur_seinen_gegenstand` (zwei neue Abschnitte) ·
`feedback_all_projects_dual_remote_github_gitlab` (die Falsch-Divergenz: `merge-base --is-ancestor`
**vor** dem Wort „Divergenz").

**Und die Regel, die alles trägt:**

> Jede Verarbeitung braucht vorne einen Explore, ob der **Kern** ihrer Aufgabe stimmt. Stimmt er
> nicht, wird die **Definition korrigiert** — als Einschub in Wellenplan, Dossier, Goal v8,
> **nie als Überschreibung**.

---

*Verfasst Mo 10.08.2026 nachts, während `wnq4aqu8a` und `wfc1d0sh9` laufen. Beide Ergebnisse sind
bei Abfassung ausstehend, in Abschnitt 1 vorbereitet, nicht vorweggenommen.*
