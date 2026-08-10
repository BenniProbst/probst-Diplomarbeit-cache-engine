# KONTEXTÜBERGABE — Mo 10.08.2026, Nacht 5

> **Vorgänger:** `20260810-KONTEXTUEBERGABE-nacht-4-w0a-gelandet-w1-exploriert-und-die-blinden-gates.md`
> **Repo-Stand bei Abfassung:** super `912466a2` (development, sauber) · ce `95cb3039`
> **Platte:** 32 G frei von 251 G (87 %) · 21 Worktrees
> **Zwei Workflows laufen und sind der Grund, warum diese Übergabe existiert.**

---

## 0. DIE ERSTEN ZWÖLF MINUTEN DER NÄCHSTEN SESSION

1. **Neu gründen** — `MEMORY.md` und `MEMORY-DETAIL.md`, dann diese Datei.
2. **Die drei bindenden Dokumente vollständig in den Kontext** (Owner-Auftrag 10.08., wörtlich:
   *„gründe dich bitte neu und lies die genannten 3 Dokumente durch kippen vollständig in den Kontext"*):

   | Rolle | Pfad (super) | Zeilen |
   |---|---|---|
   | **Goal v8, Lesefassung** | `docs/sessions/20260808-GOAL-V8-KONSOLIDIERTE-LESEFASSUNG-verbatim.md` | 241 |
   | **Gesamt-Dossier** | `docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` | 659 |
   | **Wellenplan v2** | `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` | 971 |

   Der Wellenplan sprengt einen einzelnen `Read` (68 k Token) — **paginiert lesen**, `offset`/`limit`
   in Blöcken zu ~300 Zeilen. Nicht greppen und für gelesen halten: §11 und §12 sind laut Goal v8
   ausdrücklich Teil des bindenden Umfangs und stehen hinten.
3. **Den Workflow-Rücklauf ernten** — Abschnitt 1 dieser Datei. Das ist die eigentliche Arbeit.

---

## 1. ⭐ WAS MIT DEN WORKFLOWS ZU TUN IST, WENN SIE ZURÜCKKOMMEN

**Owner-Auftrag 10.08., wörtlich:**

> „Bitte lies aus dem unteren session log des letzten Kontextes heraus, was mit dem aufgetragenen
> workflow zu tun ist, wenn er zurück kommt, weil wir den **Wellenplan/Gesamt-Dossier/Goal v8
> updaten müssen, weil sich der Kern einiger Aufgaben geändert hat.** Der Workflow liefert direkt
> die Änderungen beim return."

Das ist **kein** Nebenprodukt der Workflows. Es ist ihr Hauptprodukt.

### 1.1 Woher die Änderungen kommen

Auslöser war der Owner-Satz, der mitten in den F1-Start fiel:

> „Jede verarbeitung braucht vorne einen Explore, ob überhaupt der **Kern** ihrer Aufgabe stimmt,
> sonst müssen wir die **Definition der Aufgabe korrigieren**."

Ich hatte die F1-Kettenglieder aus dem Wellenplan vom 08.08. übernommen — zwei Tage alt, seither
zwei Sammellandungen. Der laufende Workflow (v1, `wf_e13d73bf-85d`) wurde deshalb per `TaskStop`
gestoppt und als **v2** neu aufgesetzt: vor **jedem** Paket steht jetzt eine Stufe 0, der
`KERN_EXPLORE`, mit vier zulässigen Urteilen.

    STIMMT            -> bauen wie beschrieben
    STIMMT_TEILWEISE  -> die korrigierte Aufgabe formulieren, DIESE bauen
    STIMMT_NICHT      -> NICHT BAUEN, die richtige Aufgabe melden
    SCHON_ERLEDIGT    -> mit Beleg melden, nicht neu bauen

Das Urteil ist **Pflichtfeld im Schema** (`SCHEMA_KERN`, `required: ['paket','kern_urteil','befund','messort']`),
also nicht überspringbar, und wird an das nächste Kettenglied durchgereicht.

### 1.2 Die beiden laufenden Workflows

| Run | Gegenstand | Skript | Journal |
|---|---|---|---|
| **`wf_5834b706-7b5`** | Hauptstrang, ALLE offenen Fragen (32 Agenten: 10 Explores · 3 Entwürfe · 6 Bauten · 12 Prüfungen) | `workflows/scripts/hauptstrang-alle-offenen-fragen-wf_5834b706-7b5.js` | 13 gestartet / 10 fertig (13:27) |
| **`wf_e22d25ef-71c`** | F1-Durchstich-Kette v2, mit Kern-Explore je Paket | `workflows/scripts/f1-durchstich-kette-v2.js` | 3 gestartet / 1 fertig (13:28) |

Journal-Wurzel:
`~/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1/subagents/workflows/<run>/journal.jsonl`

**`journal.jsonl` ist die Wahrheit** — bei Stillstand zuerst `df -h`, dann das Journal, nie den
Fortschrittsbaum (`reference_stumme_workflow_tode_journal_ist_die_wahrheit`).

### 1.3 Die sieben F1-Pakete und ihre Kern-Frage

Vorlauf (parallel, ohne Kettenabhängigkeit):

| # | id | Kern-Frage, die der Explore beantworten muss |
|---|---|---|
| V1 | `d1b-emitter-prebuild` | `grep -c adhoc_emitter .gitlab-ci.yml` = 0 — gilt das nach den Sammellandungen noch? |
| V2 | `d2g1-27-gtests` | Sind die 27 gtest-Fälle noch unsichtbar, oder hat ein W0a-Paket sie schon registriert? |

Kette (pipeline, Urteil wird weitergereicht):

| # | id | Kern-Frage |
|---|---|---|
| G1 | `08-schema-freeze` | — |
| G2 | `d3-7-lauf-marker` | Wenn der lazy Header greift, entsteht bei 0 Datenzeilen **gar keine** CSV mehr — hat der Marker dann noch den Zweck, den der Plan ihm gibt? |
| G3 | `d3-3-persist-zeilen` | — |
| G4 | `20-d3-6-transport` | `anhang:forward` ist INERT-by-default **und** `COMDARE_THESIS_WRITEBACK_TOKEN` wurde beim Scrub gelöscht. Die Abnahme kann heute gar nicht laufen — wie ist sie zu fassen? Ein „legitimer Riss" ist ein zulässiges Ergebnis. |
| G5 | `23-naht-csv-xlsx` | Der Posten heißt „Mess-CSV → xlsx". Die Owner-Doktrin sagt **xlsx → csv**, die csv ist das *Kind* der Mappe. Das ist ein Richtungswiderspruch **im Aufgabenkern**. |

Dazu ein Nenner, der für alle gilt: der Plan rechnet mit **427/429/431 Tests**, `ctest -N` zählt nach
der Sammellandung **481**. **Jede Zahl des Plans ist zwei Tage alt.**

### 1.4 Was mit dem Return zu tun ist — die Ernte-Vorschrift

Der Workflow gibt am Ende zurück:

```js
{ vorlauf_urteile: [{paket, urteil}], ketten_urteile: [{glied, urteil}], … }
```

**Schritt 1 — sortieren.** Jedes `STIMMT_TEILWEISE`, `STIMMT_NICHT` und `SCHON_ERLEDIGT` ist eine
**Änderung an der Aufgabendefinition** und damit ein Update an den drei Dokumenten. Ein `STIMMT`
ändert nichts und wird nur gebucht.

**Schritt 2 — einarbeiten, an drei Orten, in dieser Reihenfolge:**

| Urteil | Wellenplan v2 | Gesamt-Dossier | Goal v8 Lesefassung |
|---|---|---|---|
| `STIMMT_NICHT` | Posten-Zeile mit **Korrektur-Einschub** versehen, alte Fassung stehen lassen | Kettenglied-Beschreibung ersetzen | nur wenn ein §-Satz betroffen ist |
| `STIMMT_TEILWEISE` | korrigierte Aufgabe als Fußnote nach Muster **D2-G4/D2-G5** | Aufwand + Reihenfolge-Zwang nachziehen | — |
| `SCHON_ERLEDIGT` | Zeile auf **ERLEDIGT** mit SHA, wie bei D2-G4 geschehen | Wellen-Bilanz korrigieren | — |
| `STIMMT` | nichts | nichts | nichts |

**Die Form ist bindend und im Bestand vorgezeichnet.** Beide Leitdokumente tragen bereits genau
dieses Muster:
- Goal v8 hat **drei** Korrektur-Einschübe im Fließtext (Ein-Blech-Regel · D2-Zahl · `allow_failure`),
  jeder mit dem Satz *„er bleibt als Wortlaut stehen, weil dieses Dokument verbatim ist"*.
- Wellenplan v2 hat die **Fußnoten D2-G4 und D2-G5**, inklusive Nachträgen im Nachtrag.

**Nie überschreiben. Immer einschieben.** `feedback_never_delete_documentation` — und der Bestand an
Irrtümern ist selbst ein Datum. Der Wellenplan sagt das über sich selbst: *„die Fassung der
Endfassung v1 ist damit ÜBERHOLT, bleibt aber stehen — der Bestand an Fehlern ist selbst ein Datum."*

**Schritt 3 — die Zahlen mitziehen.** Wo ein Urteil eine Zahl bewegt (Testnenner, Postenzahl,
Stundensumme), gilt: **Zahl mit Commit-Anker, Datum und Kommando.** Goal v8 §V und der
Ein-Blech-Einschub belegen, warum: *„Eine Zahl über eine lebende Datei gilt nur mit Commit-Anker."*

**Schritt 4 — ins Ledger.** Nachtrag oben, via `scripts/ledger_nachtrag.sh`, wie die drei
Konsolidierungen dieser Session. Der Ledger ist die Stand-Quelle; die Plandokumente sind das SOLL.

**Schritt 5 — was NICHT eigenmächtig geschieht.** Ein `STIMMT_NICHT`, das eine **Welle** oder einen
**Freitag** bewegt, ist eine Owner-Vorlage, kein Bau. Die Wellen-Zuordnung ist ausdrücklich vom
Codex-/Agenten-Urteil ausgenommen (Goal v8 §VIII).

### 1.5 Der Hauptstrang-Workflow liefert dieselbe Klasse

`wf_5834b706-7b5` beantwortet die Owner-Fragen **B-1/B-2/B-3** und legt **E-1…E-4** mit vollem
Kontext neu vor. Auch das sind Änderungen an Aufgabendefinitionen — insbesondere B-3, wo der Owner
die 6 CEBs aus der **3!-Permutation der Mess-Layer** (Wallclock/Macro/Micro für `checkpoint_measure`)
gegen meine Lesart einer ganz anderen Sechs gesetzt hat. Falls der Explore das bestätigt, gehört die
CEB-Zahl **je Gattung+Genus** in den Wellenplan, nicht als globale Konstante.

---

## 2. WAS IN DIESER SESSION GESCHAH

### 2.1 Der Scrub — vollzogen, beidseitig

Ausgelöst durch den Fund, dass sieben GitLab-Geheimnisse in ein Transkript geraten waren.

    776 Token in EINER Ref   ->   0
    397 / 397                     Runner-Token rotiert
    8                             CI-Variablen gelöscht
    2                             PATs widerrufen
    19 / 19                       vorher gesichert nach ~/.credential-backup-20260810/
                                  (Modus 700, Dateien 600, außerhalb jeder Versionierung)

**Der Fehler, der dabei meiner war** — Owner: *„hast du auch **beide** gescrubt? Sonst ist es gleich
wieder dreckig."* Ich hatte nur GitLab gescrubbt und „erledigt" gemeldet. GitHub trug 0 von 12 Refs,
also kein Schaden — aber die Klasse ist dieselbe wie
`reference_ein_gruenes_gate_deckt_nur_seinen_gegenstand`: **nach dem ersten grünen Ergebnis aufgehört
zu prüfen.** Die Memory `feedback_all_projects_dual_remote_github_gitlab` trägt das jetzt als
Verschärfung.

**Zweiter Fund am Objekt:** `git filter-branch` lässt sein eigenes Netz zurück. Nach dem Löschen der
Backup-Ref meldete der Rescan **weiter 776** — Ursache war `refs/original/refs/heads/development`.
Steht im Fallen-Register.

**Die Gegenprobe ist gefahren und grün.** Nach dem Löschen der acht Variablen war die offene Frage,
ob die CI ohne sie noch fährt. **super-Pipeline `15570` = SUCCESS** — gemessen 10.08. über einen
Monitor, nicht behauptet. **Die CI degradiert sauber, sie bricht nicht.** Damit ist meine frühere
Warnung *„die CI von 288 ist jetzt rot"* am Objekt widerlegt; sie war zu pessimistisch.

**Offen und fremd:** MinIO-Schlüssel und NFS-Drop-Token liegen auf Systemen, zu denen der Owner den
Zugang hat. Nicht von mir ersetzbar.

### 2.2 Dual-Remote-Sync — Regel verschärft

Owner: *„Bitte sorge **immer** dafür, dass alle Projekte 2 remotes haben **und auf gitlab und github
im sync auf development und main sind**."*

Der Stand war erheblich auseinander:

    prt-art     development + main    SYNC
    overleaf    main SYNC, development DIVERGENT   <- ungeklärt, wer führt
    super       development 137 zurück, main 145
    ce          development 175 zurück, main 221

Alle vier waren **saubere Fast-Forwards** — GitHub hatte nichts Eigenes. Nachgezogen. Die erwartete
Richtung ist **gitlab führt, github zieht nach**; ist es *kein* FF, wird gemeldet, nie geforct.

**Zwei Posten bleiben beim Owner:** `overleaf` development divergiert (wer führt?) und das Umbrella
`Projekte` hat absichtlich nur GitLab — ein GitHub-Remote wäre dort eine **neue öffentliche Fläche**.

### 2.3 Die Landung — der Stau ist weg

    ce     95cb3039    14 Commits, Pipeline 15547 SUCCESS
    super  912466a2    16 Commits, Pipeline 15560 SUCCESS 32/32

Owner-Auflage war: *„lande vorher alle offenen commits, vor dem scrub und grüne die Pipeline"* —
in dieser Reihenfolge, und so ist es gelaufen.

### 2.4 Ledger: 16.785 → 19.310 Zeilen

Drei Nachträge, je oben eingefügt:

| Commit | Inhalt |
|---|---|
| `c56ee00d` | Konsolidierung I |
| `af3e7266` | Konsolidierung II — 798 Zeilen, KON2-01…KON2-36 |
| `912466a2` | Konsolidierung III — 534 Zeilen, KON3-01…KON3-18, aus dem Session-Log-Durchgang |

**W-1 dabei aufgelöst:** die Paper-Kopplung stand an der Ledger-**Spitze** als OFFEN und war dreimal
60 Zeilen tiefer beantwortet. Ursache ist die Nachtragsordnung selbst — Nachträge stehen oben, also
endet die Suche **vor** der Antwort. Wer im Ledger sucht, muss über die ganze Datei suchen, nicht
über den Kopf.

### 2.5 Die Versionierung — Owner-Orientierung, von ihm bestätigt

Auf meine Explores hin gab der Owner die vollständige Soll-Beschreibung und bestätigte danach
*„Das ist jetzt alles korrekt"*. Sie steht in
`reference_versionierung_soll_je_stufe_owner_orientierung_20260810` und ist **SOLL, nicht IST**:

| Stufe | Versionierung |
|---|---|
| **Achsen-Algorithmus** | jeder hat eine eigene; spiegelt sich in der Tier-Binary |
| **CEB** | **nur** Mess-Achsen und System-Achsen |
| **Genus** | **zusammengesetzt** aus allen Mess/System/Organ-Achsen, compile-time, für das was es leistet |
| **System-Achsen** | die **einzigen** mit komplexer Grammatik (CPU/GPU/FPGA/NPU/AVX) |
| **Planer** | simple `X.Y.Z` — er ist dreiphasig und gibt nur Mess-Achsen frei |
| **alle vier Binaries** | Planer · CEB · Tier · Hybrid-Tier je ein **Fingerprint-SHA** |

**Präzisierung, die der Owner nachschob:** `measurement_tooling_registry` ist die **einzige**
Mess-Achse mit System-Achsen-Syntax und Haupt-Achsen-Rang. Die übrigen Mess-Achsen haben nur
`X.Y.Z`, Hardware-Flags nur wo anwendbar, **kein** komplexes Tag-System.

**IST-Lücken, am Objekt:** Planer-SHA fehlt · CEB-System-Array leer · Genus-Stempel handgeschrieben ·
`measurement_tooling_registry.hpp:47-49` trägt dreimal `"1.0.0.c"`, nie gebumpt ·
`abi/system_axis_code_versions.hpp:38` steht auf `kSystemAxisCodeCount = 3` (Historie in Zeile :32:
*„A3 (O-8 Schritt 4): 5 -> 3"*) — **diese Schließung ist im Ledger nirgends nachgetragen.**

### 2.6 Lizenz — entschieden, nicht umgesetzt

| Repo | Regelung |
|---|---|
| `super` | Apache |
| `cache_engine` | frei für die Forschung, proprietär für **Business UND Einzelnutzung**; nach 5 Jahren frei ab heute |
| `PRT-ART` | wie ce |
| `Diplomarbeit` | nur Copyright **Benjamin-Elias Probst** |

**Entwürfe liegen, Dateien sind nicht geändert** — das ist Paket p6 im Hauptstrang-Workflow.

### 2.7 Eigentum — eine Rüge, die im Gedächtnis steht

> Thesis = **Benjamin-Elias Probst** (natürliche Person, privat)
> CacheEngine + PRT-ART + super = **BEP Venture UG**, Marke Comdare

**Die Abkürzung „BEP" für die Person ist verboten** — sie verschmilzt Person und Gesellschaft. Das
war mein Fehler und ist als solcher in
`reference_eigentum_thesis_privat_cacheengine_bep_venture_comdare` gebucht.

---

## 3. DIE OWNER-ENTSCHEIDE DIESER SESSION

Vollständig, damit sie nicht neu gefragt werden.

**A-1 · A-2 · A-3** — volles GO, alle drei.

**B-1** — Jede CEB hat ein Prüfdock, wie geplant. **Jede Gattung+Genus wird separat in der XML als
permutierbares Experiment angefordert** und hat je einen CEB→Tier-Binary-Vertrag in **separaten**
CEBs und Experimenten. Eine CEB trägt **nie** gemischte Prüfdocks verschiedener Genus, sondern genau
eine.

**B-2** — Ja, der Planer hat einen Fingerprint, und zwar **über seine Version**. War immer einfach.

**B-3** — *„Ach komm schon, das ist doch bekannt und lange geplant."* Es gibt **6 CEB-Builds** wegen
der 3!-Regelung der Mess-Layer Wallclock/Macro/Micro für `checkpoint_measure`. Für SearchAlgorithm
als Gattung+Genus braucht es allein dafür 6 CEBs als Mess-Achsen-Permutation.
**Dazu die Regel:** *„Bitte untersuche für ALLE Fragen immer die letzten 10 Wochen."*

**B-4** — Alles endet im **State-Pattern der Durchführung**; alle Pakete fallen dorthin zusammen, bis
wir das Bauen erreichen. Gebaut wird, wenn: **Lagerhaltung fertig UND Stempel fertig UND Algorithmen
versioniert UND Messung einbaubar.**

**C-1** — im Kontext beantwortet. **C-2** — ce nach 5 Jahren frei, ab heute. **C-3** — ja, gehören
dazu und werden mit veröffentlicht. **C-4** — ja.

**D-1** — rausnehmen.
**D-2** — *„Er baut immer und es darf nicht nur clang grünen, sondern das Projekt muss auch mit gcc
parallel bauen, **beide Compiler Pflicht!** Gebaut wird immer, **skip ist VERBOTEN.**"*
**D-3** — alle einführen.
**D-4** — Abgabe wird das Ausfertigungsdatum.

**E-1 bis E-4** — *„alle mit viel Kontext erneut fragen"*. Liegt im Hauptstrang-Workflow.

---

## 4. MEINE IRRTÜMER DIESER SESSION — vollständig, weil sie das Muster zeigen

| Irrtum | Was wirklich galt |
|---|---|
| **`args` als JSON-String** übergeben | Workflow starb nach 6 ms mit 0 Agenten. Das Skript parst jetzt beide Formen. |
| **`.slice(0, 120000)`** im Synthese-Prompt | die Synthese sah **40 von 246** Funden. Der Agent meldete es korrekt — ich hätte es nicht bemerkt. |
| **Vakuum-Grün** der Hygiene-Wache | „0 Zeilen geprüft… GRÜN" bei 28 Dateien. Falscher Aufruf; korrekt ist `--seit-basis origin/development`. Gefangen **nur** an der Zeile „NENNER (nie eine nackte Null)". |
| **K11 getreten** | `EXIT=0` kam von `tail`, nicht vom Skript. Ohne Pipe gemessen: Exit 1. |
| **„5er-Platzhalter"** | ist 3, und der Pfad ist `abi/`, nicht `measurement/`. |
| **„Mess-Array fehlt ganz"** | existiert. |
| **„drei Pakete bauten daneben"** | alle drei am Objekt widerlegt. |
| **„neun weitere Konstanten"** bei acht gelisteten | Zahl daneben, Liste richtig. |
| **„CI von 288 ist jetzt rot"** | zu pessimistisch — die Jobs degradieren sauber. |
| **F1-Kette ohne Kern-Explore gestartet** | der Auslöser für Abschnitt 1 dieser Datei. |

Dazu vier Stränge, die **idle ohne Bericht** blieben, und einer, der einen Bauplan auf einen **4 Tage
alten** Submodul-Klon stellte (`90bca126`).

**Das Muster ist immer dasselbe:** ein richtiges Messgerät am falschen Gegenstand. Goal v8 §IV nennt
es den **Stellvertreter** und sagt dazu den Satz, der diese Session dreimal getroffen hat:

> *Ein falsches Messgerät fällt irgendwann auf. Ein richtiges Messgerät am falschen Gegenstand nie —
> es gibt nichts, was klappern könnte.*

---

## 5. WO DIE WELLEN STEHEN

    Heute  Mo 10.08.  ->  W0a läuft (bis Mi 12.08. mittags)
    F1     Fr 14.08.  ->  VIER TAGE
    F2     Fr 21.08.      Freeze
    F3     Fr 28.08.      danach NULL-Bump
    F4     Fr 04.09.      Kampagne + Rückschrieb
    F5     Fr 11.09.      PDF final
    ABGABE Di 15.09.

**Gemessen offen in W0a:** D1b — `grep -c "adhoc_emitter" .gitlab-ci.yml` = **0**.
**Der bekannte Engpass bleibt W1** mit 99 h Band A auf einer Woche, die schon voll ist. Reißt W1,
reißt der Freeze.

**Der DURCHSTICH (F1)** ist die Abnahme, an der alles hängt: ein am Mittwoch frisch gemessener
Mini-Messwert liegt am Freitag als Tabellenzeile im Thesis-Submodul — durch
`CSV → persist → xlsx → anhang:forward → PDF`, jede Stufe mit Nenner. Genau diese Kette prüft der
F1-Workflow gerade auf ihren **Aufgabenkern**, bevor er sie baut.

---

## 6. OFFENE POSTEN, nach Dringlichkeit

**Diese Woche:**
- Workflow-Rücklauf ernten und die drei Dokumente updaten → **Abschnitt 1**
- Lizenz-Dateien tatsächlich ändern (Entwürfe liegen)
- D-1/D-2/D-3 in der CI umsetzen — insbesondere **skip ist verboten, beide Compiler Pflicht**
- Die **34 BLOCKIEREND-Ernte-Funde** einzeln buchen; sie stehen bisher nur als Zahl in KON2-32

**Beim Owner:**
- `overleaf` development divergiert zwischen GitLab und GitHub — wer führt?
- Umbrella `Projekte`: soll GitHub dazu?
- MinIO-Schlüssel + NFS-Drop-Token ersetzen (fremde Systeme)
- `-Wall`/`-Werror` einführen? (Posten #44 — die Lücke ist real, der verdeckte Bestand klein)

**Strukturell, aus dem Ledger:**
- **GLIED [5]** `gate_contribution` ist LEER — zweite Hälfte des Additiv-Vertrags (O-8)
- **GLIED [6]** ist richtungsblind — der Additiv-Vertrag ist als **Gleichheit** implementiert, muss
  aber `recorded ⊆ current` sein
- **W12-B** — die geplante zweite Hälfte von §43, seit 19.07. auf „nach W11" wartend
- Die **kumulative Gate-Lücke**: die Diff-Hygiene-Wache misst **push-lokal**, nie kumulativ. 1 Zeile
  grün auf development, 18.577 rot auf main, **gleicher Baum**. Der main-FF ist das erste kumulative
  Gate — vorher die Wache lokal über den FF-Bereich fahren.

---

## 7. WAS DIESE SESSION AN DOKTRIN HINTERLASSEN HAT

**Neu:**
- `feedback_zehn_wochen_explore_pflicht_fuer_jede_frage` — zehn Wochen sind der **Normalfall**, nicht
  die Eskalationsstufe. Vor jeder Frage und vor jedem Bau.
- `reference_versionierung_soll_je_stufe_owner_orientierung_20260810`
- `reference_lizenz_vier_repos_forschung_frei_sonst_proprietaer`
- `reference_konsolidierung_106_unverlinkte_memories_liegt_in_der_diplomarbeit` — **fehlt ein Fakt,
  der nach „das war doch entschieden" klingt: dort zuerst, vor jedem Explore.**

**Verschärft:**
- `feedback_all_projects_dual_remote_github_gitlab` — der **Sync** ist Teil der Regel, nicht nur das
  Vorhandensein. Jede Ref-Bereinigung gilt für **beide** Remotes.
- `reference_fallen_register_werkzeuge_und_ci` — YAML-Doppelschlüssel · `refs/original` · gitleaks-Nenner
- `reference_eigentum_…` — das „BEP"-Verbot
- `feedback_hardware_erweiterung_ist_additiv_…` — mein Fehlschluss ist dort als solcher benannt

**Und die Regel, die diese Übergabe erzwungen hat:**

> **Jede Verarbeitung braucht vorne einen Explore, ob überhaupt der Kern ihrer Aufgabe stimmt.**
> Stimmt er nicht, wird nicht gebaut, sondern die **Aufgabendefinition korrigiert** — und die
> Korrektur landet in Wellenplan, Dossier und Goal v8, als Einschub, nie als Überschreibung.

---

*Verfasst Mo 10.08.2026, während `wf_5834b706-7b5` und `wf_e22d25ef-71c` laufen.
Beide Ergebnisse sind bei Abfassung ausstehend und in Abschnitt 1 vorbereitet, nicht vorweggenommen.*
