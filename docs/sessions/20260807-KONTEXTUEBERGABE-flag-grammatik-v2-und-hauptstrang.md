# KONTEXTÜBERGABE 07.08.2026 abends — Flag-Grammatik v2 entschieden, Hauptstrang bei Phase 3/4

**ERST-ANKER für die nächste Session.** Der Owner hat verfügt: *„im Gesamt dossier ist alles
konsistent und wir sollten es im nächsten Kontext direkt in den Kontext kippen."*

> **ZUERST LESEN, VOLLSTÄNDIG:**
> 1. `docs/sessions/20260807-STAND-wellenplan-abgeschlossen-und-offene-entscheide.md` (der Vormittags-Anker)
> 2. `docs/plaene/20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md` (**die neue Grammatik, bindend**)
> 3. Dieses Dokument
> 4. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — Nachträge ab „07.08. mittag-1"

---

## 1. Refs (Stand Kontextende)

| Repo | development | Pipeline |
|---|---|---|
| ce | `ba069e38` | 15202 grün |
| super | `6d837e7d` + lokale Commits | 15203 grün |
| thesis | `eaf7fe8` | grün |
| cluster | `d7eab98` | unberührt |

Gitlinks in super: ce `a1d0c201`, beide Thesis-Zeiger `eaf7fe8`.

---

## 2. DER GROSSE ENTSCHEID DES NACHMITTAGS: Flag-Grammatik v2

Der Owner hat die Versions-/Stempel-Grammatik in **acht Nachrichten** neu definiert und die
Q3-Grammatik vom 02.08. **vollständig ersetzt**. Seine Rahmen-Direktive:

> *„ich möchte die alten Wege komplett ersetzen und das System erneuern … Die Struktur der Stempel
> Zeilen bleibt jedoch gleich bezüglich was dort steht und wie viele Achsen und SHA fingerprint"*

### 2.1 Die finale Grammatik

```
realm-zeile := <eintrag> [ ';' <eintrag> ]* [ <meta-meta-gruppe> ]
eintrag     := <achse> '=' <klasse> '@' <version>
version     := UINT '.' UINT '.' UINT [ '.' <flag> ]*
flag        := <basis> [ '{' <sub> [ '.' <sub> ]* '}' ] | <companion>
basis       := 'c' | 'g' | 'f' | 'n' | 'x128' | 'x256' | 'x512'
sub         := <token> [ '{' <sub> [ '.' <sub> ]* '}' ]      -- rekursiv
meta-meta-gruppe := '[' <eintrag> [ ';' <eintrag> ]* ']'     -- am ZEILENENDE
```

**Beispiele:**
```
memory_layout=SoaMemoryLayout@1.0.0.c{p.e}.x512{f.vl.bw.dq}.gfni
search_algo=Art@1.0.0.c                    == ...c{p}   ({p} ist Default)
simd=x512{f}@1.0.0                         (System-Achse: Flags an der Klassen-Stelle)
```

**Bindende Regeln:**
- **Kein `v`-Präfix mehr** — rohe und gerenderte Form fallen zusammen
- **Punkt vor JEDEM Flag**, auch dem ersten
- **Basis direkt gefolgt von ihrer Klammer**, ohne Punkt dazwischen (`c{p.e}`, nicht `c.{p.e}`)
- **Hinter `[` und hinter `{` NIE ein führender Punkt**
- **Nur der Punkt als Trenner** — Unterstriche der Katalog-Token fallen (`avx512_vbmi2` → `x512{vbmi2}`)
- **Reihenfolge sachlich egal**, formal eingehalten
- **`e` = efficiency core.** *experimental* ist ersatzlos deprecated
- **`p`/`e` sind je selbst Komposit-Flags** unter der Basis `c`; `{p}` ist der Default

### 2.2 Die Asymmetrie System ↔ Organ (fällt mit der Stufen-Doktrin zusammen)
- **System-Achse**: Flag-Kombination steht **an der Stelle der Klasse** — sie *ist* die Identität.
  Grund: Stufe 1 ist RT-Freigabe an der CEB.
- **Organ-Achse**: Komposit-Flag hängt **hinter der Version** — Eigenschaft des einkompilierten
  Algorithmus. Grund: Stufe 2 ist CT-Einbau im Tier.

Owner bestätigte: *„Und ja GENAU das fällt zusammen, das ist der Plan."*

### 2.3 `code` ist der Klassenname
Owner: *„der name der Klasse der Implementierung, die über ein compile time ausgelesen werden
kann … das Organ welches unter der Achse einkompiliert wurde"*, Invariante: *„jede Achse im
Tier-Binary genau einen compile time algorithmus"*.
- Gestempelt wird das **`string_view` der Wache** (Entscheid (a))
- **NEUER BAU-POSTEN:** eine abstrakte Basis **`compile_time_organ_version`**, von der alle Organe
  bezüglich Versionierung erben. **Existiert heute nicht** — `name()` und `algo_version` sind
  einzeln und unverbunden.
- **Ist-Drift belegt:** `class ByteWisePathCompression` ↔ `name() == "path_compression_byte_wise"`
- **Compiler-Unterschiede sind GEWOLLT** — Owner: *„jeder Compiler erzeugt einen eigenen
  Permutations-Zweig an binaries. Sie MÜSSEN sich unterscheiden."* Mein Normalisierungs-Einwand
  ist damit entkräftet.

### 2.4 Der Hybrid
Owner-Rücknahme seiner eigenen früheren Aussage: *„mein Fehler, ja der hybrid wird ja zu seiner
Laufzeit konfiguriert und gesetzt und ist nur ein Multi-Signal-Mutex der an das richtige
Tier-Binary durchleitet."*
Und die Auflösung: *„der Hybrid hat seine eigenen Organ-Achsen fingerprint und ebenfalls
Mess/System/Organ/SHA Zeilen"* — er hat eine **eigene Adapter-Gattung** mit eigenen Achsen und
Organ-Algorithmen; die **Hybrid-Organ-Achse** trägt die heuristische Weiterleitung anhand der
Messkurven, die die CEB bei der **Prüfdock-Initialisierung** übermittelt.
=> **Keine Sonderbehandlung im Fingerprint.** Vier Zeilen wie jede Tier-Binary, nur anderer
Organ-Inhalt. Sortierte Konkatenation und XOR sind beide vom Tisch.

### 2.5 Was gebrochen wird (Nenner)
`take_flag_tail` in `algo_semver.hpp` ist im Code als *„die EINE Stelle"* dokumentiert — der Umbau
hat einen Angelpunkt. Betroffen: Kardinalität 1→n · `e`-Position und -Bedeutung · Punkt-Kollision
mit dem SemVer-Punkt · Komposit-Klammern als neue Ebene · POD-Kodierung (Bit 0 experimental wird
frei, Bits 1–2 zu eng → **Entscheid: HASH**) · B12-Wache → Ersatz **„ce-eigene Achsen tragen
mindestens `c`"** · Negativ-Test-Batterie · **138 Bestands-Literale** · Thesis
`anhang/de/D_building_block_matrix.tex:1138`.

### 2.6 Migration: (a) UND (b)
Owner: *„Das v weg und alle 138 Stellen tragen die Anzeige von dem was sie leisten."*
Nicht mechanisch — **jede Stelle bekommt ihre echten Flags**. Quelle: die
Sinnhaftigkeits-Matrix `simd_organ_sensibility.hpp`.

### 2.7 Was BESTÄTIGT statt gebrochen wird (kein Bau nötig)
Selbst gegengelesen:
- **LEDGER §40.a:2402** trägt die per-Flag-Signatur verbatim (*„avx512f/vl/bw/dq/vnni … NICHT der
  Grob-Level"*)
- **LEDGER §37:2348/2356** trägt die Fähigkeitsstufen-Permutation
- **`simd_build_gate.hpp:67-74`** trägt die Routen-Leiter, *„512-bit-Route: alle Tiers kumulativ"*
- **`simd_organ_sensibility.hpp`** trägt neun Organ-Klassen mit ihren Flag-Mengen; `prefetch`
  leer, kommentiert *„KEIN SIMD-Flag"* — genau das Owner-*„manche Aufgaben machen simd zwecklos"*
- **Die Leiter ist nur INERT:** `static_assert(!any_organ_declares_required())` — alle neun
  Organ-Klassen tragen die Leermenge. Scharfschalten ist ein eigener kleiner Schnitt.

### 2.8 Bau-Reihenfolge (Vorschlag, im Design begründet)
S1 Parser · S2 Wachen · **S3 Migration der 138 Literale = DER EINE NEUANKER** · S4
Klassennamen-Wache + `compile_time_organ_version` · S5 SIMD-Leiter scharf · S6 Hybrid-Organ-Achse ·
S7 Thesis-Nachzug.

---

## 3. DER HAUPTSTRANG — wo wir stehen

### 3.1 KORREKTUR EINER LEAD-FEHLZUORDNUNG (wichtig für den Wiederanlauf)
Der Lead hatte „Phase 3/4" zunächst der **E4-XML-Vollvision-Roadmap** (Dossier 17) zugeordnet —
**das war falsch**. Eine Sonnet-Kartierung hat es widerlegt, der Lead hat es am Objekt
nachgelesen und bestätigt.

**Die richtige Quelle:** `docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:7-42`.
LEDGER:3774 bezieht sich auf **diese** Nummerierung.

| Phase | Inhalt (verbatim aus dem Fahrplan) |
|---|---|
| 1 | Laufend + Lager — OD-10-RT, A1-Lager-Rest, TP1-Inventur |
| 2 | Stempel-/ABI-Abschluss — **W10** (System-Zellwerte), **E-24** (Major 7→8), **A2-Eichung** |
| **3** | **Parallel-Spuren** — A8-Schnitt · **A9-xlsx** · A7/E-04-Rest · A14/OS-U4 · A15 FK-3/FK-4 · A10 HW P4–P6 + prod2-SPD · A11+A12 NAS-Creds · E-19 Stufe 1 · Thesis C1-Rest |
| **4** | **Beweise + Permutationen** — A3/Beweise 1–5 + §61-Dual-Weg · **A4/12-Perm (O0–O3 × {no_ext, avx2, avx512}, ≥16 Anker)** · A5 ETA/Kalibrier-Prinzip |
| 5 | Trigger-Sequenz — J-Kette → heavy-Signal → Kalibrierlauf GN_TOTAL=64 → ETA → Voll-Bau-Trigger |
| 6 | Nach Trigger — E.0 KERN-Mess-Schema (Pflicht) → 320er-Abgabemessung → Voll-Messung → Rückschrieb → Auswertung → Hybrid → COMPARE/D2 → Thesis C5 |
| 7 | ZULETZT — §75-Aufräumpass |

### 3.2 DIE HEUTIGE GRAMMATIK-ARBEIT GEHÖRT IN PHASE 4
**Phase 4 enthält wörtlich `A4/12-Perm (O0–O3 × {no_ext, avx2, avx512})`** — das ist exakt die
SIMD-Routen-Leiter, die die Flag-Grammatik v2 jetzt in Notation fasst. Die heutige Arbeit ist also
kein Seitenstrang, sondern **die Vorarbeit für die Phase-4-Permutationen**. Auch A9-xlsx (Phase 3)
hängt an der offenen Blattform-Frage.

### 3.3 ZWEI BEFUNDE, die die alte Phasen-Rechnung entwerten
1. **Die Frist-Prämisse ist widerrufen.** Der Fahrplan wurde am 03.08. gegen „Trigger Do 07.08. /
   Abgabe Fr 08.08." entworfen. Seit 06.08. abends gilt: **Endtermin 15.09.2026, Lieferung
   jeden Freitag** — *„Jede Priorisierung, die gegen den 08.08. gerechnet wurde, ist falsch."*
   Die Tages-Zuordnungen im Fahrplan (Mo/Di/Mi/Do) sind damit gegenstandslos, die **Reihenfolge**
   bleibt.
2. **Phase 3–5 wurde nie ausgefaltet.** Der Posten **B9** (*„Phasen 3-5 ausfalten;
   'Blackbox=Verlustklasse'"*) steht bis heute OFFEN. Die Phase-Buchhaltung wurde in das
   P0–P4-Bandsystem eingedampft statt abgearbeitet — das erklärt, warum die Nummern nur noch vage
   erinnert werden.

### 3.4 DER OBJEKTIVE IST-STAND
**Null Binaries gemessen** — *„Sidecar-Bestand aktuell gemessen = 0"*. Phase 5 (Trigger) und
Phase 6 (Messung) haben **faktisch nicht begonnen**. Der Hauptstrang steht inhaltlich in dem
Bereich, den der Fahrplan Phase 3/4 nennt. **Die Owner-Erinnerung war richtig.**

**Der Trigger ist neu definiert:** statt eines 131.072-Binary-Voll-Baus gilt **Batch-Kadenz max.
4096** für Compile UND Messung.

### 3.5 DER NÄCHSTE KONKRETE SCHRITT (aus der Owner-Vorlage von heute früh)
1. **FENSTER 0 schließen** (schließt sich, sobald die erste `.fingerprint`-Datei existiert — jetzt
   0 h Strafzeit, danach 34,4 h Neubau-Strafe): R-3 ✅ *(heute gelandet)* · D-1 PMU-Domäne ·
   B-4 Break-Even-Tabelle als Lager-Objekt
2. **FENSTER T1 schließen** (blockiert die Messung): **D-2 Bau-Menge** (131.072 / 524.288 /
   1.572.864 / 2.097.152 — vier Kandidaten, keiner entschieden) · D-3 Mess-Teilmenge ·
   D-4 allow_failure · D-5 PMC fail-closed · D-7 Core-Achsen-Faktorisierung · R-2 XML-Trennung
3. **Dann erst** der erste 4096er-Batch + 320er-Folgemessung

### 3.6 EINE NAMENSFALLE, dreifach
„T-n" bedeutet im Korpus **drei verschiedene Dinge**: die Achsen **T0–T18** · die Themenposten
**T-8/T-9/T-10** (heute gelandet) · die Zeitfenster **T1–T4** (T1 = vor dem ersten 4096er-Batch,
T2 = vor der Voll-Messung, T3 = vor dem 15.09., T4 = danach). Ebenso sind die **Wellen-Labels
W1/W2/W3/W5/W10** vom Juli am 03.–05.08. für andere Inhalte wiederverwendet worden — Kollision,
nicht Fortsetzung.

## 4. Laufende Arbeit bei Kontextende

| Vorgang | Zweck |
|---|---|
| `wf_93522b50-447` | **SIMD-Katalog-Recherche**, 5 Lenses: x86-Historie MMX→AVX10, AVX-512-Subsets, **32-bit-Lage (Owner-Schwerpunkt: Indien/Win10)**, Companion/Scalar, ARM+RISC-V-Vektorlängen-Agnostik → liefert die Komposit-Tabelle für x128/x256/x512 |
| Explore „Pläne 3 Wochen" | Plan-Inventar 17.07.–07.08. + vergessene Aufgaben |
| Explore „Phase 3/4?" | Objekt-Verifikation der These |
| Explore „Hauptstrang-Stand" | Wellen-/Phasen-Systeme, welche aktiv |
| ⏸️ `wf_355205a7-f46` | **Doppel-Audit, pausiert** — Wiederanlauf via `resumeFromRunId` |

**Gesicherte Ergebnisse (nicht neu erheben!):**
- `docs/sessions/20260807-KARTIERUNG-sonnet5-sieben-themen-referenzen.json` (173 KB)
- `docs/sessions/20260807-EXPLORE-sechs-lose-flags-xlsx-noise-minmax-paper.json` (194 KB)
- `docs/sessions/20260807-VEREINIGUNG-flag-grammatik-v2-gegen-4-wochen.json` (132 KB)
- `docs/sessions/20260807-AUDIT-ledger-vollstaendigkeit-43-positionen.json`
- `docs/sessions/backups/20260807-welleD-t10-spendlimit-rettung/`

---

## 5. Offene Owner-Entscheide

Die zehn aus dem Vormittags-Anker (Abschnitt 3 dort) **minus** die heute beantworteten:
- ✅ **erledigt:** Generator-Rückfall (gebaut, `6d837e7d`) · cpe/Flag-Grammatik (v2 entschieden) ·
  Dual-Review-Pflicht (gilt wieder strikt)
- 🔴 **offen:** xlsx-Blattform (Explore läuft) · T19 `persistence_target` · 4× Welle C
  (MAX-Spalten, Brücke CSV→Katalog-Id, Default-Zielgrößenmenge, Artefakt-Anzahl) · 5× Welle D
  (k-Wahl-Konsens, Linkage, Noise-Schwelle, Skalierungs-Lesarten, honest-0-Features) ·
  E-A…E-F STOPP-Gates (Task #39) · RunMethodology-Enum-Ordnung

---

## 6. Die Arbeitsweise, die heute dazukam

**EXPLORE IST ZWEISTUFIG** (Owner-Direktive, als Memory verankert):
1. **Kartierung** — Sonnet 5, max effort, „very thorough" → liefert **Referenzen**, keine Deutungen
2. **Tiefenlesen** — der Lead öffnet **jede tragende Referenz selbst**, bevor er etwas weitergibt

Begründung aus dem Tag: wer nur kartiert, übernimmt fremde Deutungen (von sieben Empfehlungen
eines Fund-Berichts waren **zwei sachlich falsch**). Wer nur selbst liest, verfehlt das
Projekt-Vokabular (T-10 wurde zweimal als „0 Code" gemeldet, weil niemand nach „Workload-Cluster"
suchte).

**Zehn Fallen im Register** (`memory/reference_fallen_register_werkzeuge_und_ci.md`), fünf davon
heute dazugekommen — darunter: `git -C` auf ein leeres Submodul-Verzeichnis liefert still den
Eltern-SHA · `update-index --cacheinfo` prüft den SHA **nicht** · vor `worktree remove --force`
die ungetrackten Dateien sichern · eine Wache, die „alle Gates" sagt, meint ihre eigenen.
