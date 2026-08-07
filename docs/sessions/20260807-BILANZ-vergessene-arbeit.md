# BILANZ DER VERGESSENEN ARBEIT

**Erhebung: 2026-08-07, 00:15–00:40 UTC.** Alle Zahlen unten sind in dieser Erhebung selbst
am Objekt gemessen, nicht aus Berichten uebernommen. Wo eine Vorlage-Meldung sich beim
Nachmessen als falsch erwies, steht das ausdruecklich dabei.

**Gemessener Ist-Stand zum Erhebungszeitpunkt** (der Auftragstext war beim Messen schon ueberholt):

| Zeiger | im Auftrag genannt | **gemessen 00:30** |
|---|---|---|
| ce `development` | bba4d90f | **c4c04315** (2 Landungen weiter) |
| ce `main` (origin==github) | 2b5ecd29 | 2b5ecd29 — lokaler `main` = `b241a272` (stale) |
| super `development` (origin==github) | 71591a24 | **5a98036d** |
| super `main` (origin==github) | 71591a24 | 71591a24 — lokaler `main` = `9d0f1bad` (stale) |
| super-Gitlink auf ce | 2b5ecd29 ("eine Landung alt") | 2b5ecd29 = **10 Commits / 2 Landungen alt** |
| thesis-Gitlink | 19e1592 | 19e1592 (aktuell) |

---

## 1. Was der Auftrag war

**Owner, verbatim:**

> "Bitte pruefe den gesamten Kontext auf **vergessene Arbeit** und hole sie nach.
> **Behandle vergessene workflow Nachrichten.** Lande fehlende Arbeit."

**Die zwei Anlassfaelle, die den Auftrag ausgeloest haben:**

1. **Das Regressions-Dossier.** Eine Konsolidierungs-Welle hatte es von 1590 auf 2486 Zeilen
   erweitert. Der Lead hat das Ergebnis nie geprueft und nie gesichert — **896 Zeilen lagen
   ungesichert im Arbeitsbaum**, bis der Owner nachfragte.
2. **Das Paket `b-numa-process-probe`** (`b4cebdc4`, 18 Dateien, +2800/−33) war **fertig gebaut
   und nie gelandet** — und trug zusaetzlich den falschen Namen, weil die Owner-Vorgabe
   `numa_cpu_pin_process_probe` erst nach dem Bau kam.

**Regel-Zeile 16 dieser Session:** *gesicherte Vorarbeit, die niemand liest, ist verlorene
Vorarbeit.* Auftrag dieser Bilanz war, den Rest zu finden.

**Der erste Anlassfall ist geheilt** (Beleg in Abschnitt 3). **Der zweite ist es nicht** — er
steht als Posten V-1 an der Spitze dieser Bilanz, und er ist beim Nachmessen **gefaehrlicher**
ausgefallen, als jede Vorlage-Meldung behauptet hatte.

---

## 2. WIRKLICH OFFEN — sortiert nach Verlustrisiko

**Sortierkriterium: was verlorengeht, wenn nichts geschieht.** Zuoberst steht, was auf
**keinem Remote** liegt und nur an lokalen Refs oder am Dateisystem haengt.

---

### V-1 🔴🔴 Das numa/core_class-Paket liegt auf KEINEM Remote — 2 Commits, 18 Dateien, +2800/−33

**Was es ist.** OD-11-RT `numa_cpu_pin_process_probe` samt der Unter-Achse `core_class` — die
Bau-Grundlage fuer die getrennte P-/E-Core-PMC (Owner-KERN 06.08., Task #27). Zwei Commits:
`b4cebdc4` (Bau) und `b1753926` (die Owner-Umbenennung `numa_process_probe` →
`numa_cpu_pin_process_probe`).

**Wo es liegt.**
- ce-Zweig `b-numa-cpu-pin-process-probe` → `b1753926` (Bau + Rename)
- ce-Zweig `b-numa-process-probe` → `b4cebdc4` (Altstand, **traegt noch den Falschnamen im
  Branchnamen**)
- Arbeitsbaum `/home/comdare/wt-numa-cpu-pin`, HEAD `b1753926`, `git status --porcelain` = **leer**

**Ist es gesichert? NEIN — und das ist der schwerste Einzelbefund dieser Bilanz.**

```
git for-each-ref refs/remotes --contains b1753926  →  0
git for-each-ref refs/remotes --contains b4cebdc4  →  0
Gegenprobe: refs/remotes --contains 5c102e05       →  2   (origin + github)
```

Nenner: 231 Refs im ce-Repo, davon 40 rescue-Refs. **Kein einziger enthaelt einen der beiden
numa-Commits.** Die Suche `git for-each-ref | grep -i numa` findet exakt zwei Treffer, beide
`refs/heads/` — kein `refs/rescue/`, kein `refs/remotes/`. In `/home/comdare/backups-workflow/`
liegt kein numa-Patch (dort nur `20260806-pause-wip`, `20260806-session-transkript`,
`20260806-workflow-rohdaten`, `QUARANTAENE`).

> **Korrektur einer Vorlage-Meldung:** Eine der drei Such-Vorlagen behauptete, ein Rescue-Ref
> `refs/rescue/20260806-numa-cpu-pin-process-probe` liege "auf beiden Remotes" auf `b4cebdc4`.
> **Das ist am Objekt widerlegt** — es existiert nicht, weder lokal noch als
> remote-tracking-Ref. Die Gegenprobe mit `5c102e05` beweist, dass die Messmethode Refs findet,
> wo welche sind.

**Was zur Landung fehlt.**
- Der Review der Pruefwelle `wf_f94d1373-f7b` lautet **"LUECKE"**, nicht LANDEBEREIT: die
  6-Abschnitts-Spiegelung gegen `numa_page_probe.hpp` bricht an einer Stelle. Ob diese Luecke
  inzwischen geschlossen ist, ist **unklar** — Welle `wf_d8f8d991-835` arbeitete zuletzt daran.
- Der Falschnamen-Zweig `b-numa-process-probe` muss weg (Loeschung = Owner-GO).

**Naechste Handlung (in dieser Reihenfolge):**
1. **SOFORT, vor allem anderen: `git push` beider Zweige als Rescue-Ref auf beide Remotes.**
   Solange das nicht geschehen ist, vernichtet ein Festplattenschaden oder ein
   `git branch -D` 2800 Zeilen Arbeit ersatzlos.
2. Danach: LUECKE aus `wf_f94d1373-f7b` schliessen, dann nach `development` mergen.
3. Danach: Falschnamen-Zweig entfernen (Owner-GO einholen).

---

### V-2 🔴🔴 Drei Plandokumente, 2433 Zeilen, auf keinem der 47 super-Refs

**Was es ist.** Drei untracked Dokumente im super-Hauptcheckout:

| Datei | Zeilen | Blob | Refs mit diesem Blob |
|---|---|---|---|
| `docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md` | 1043 | `375d324c` | **0 von 47** |
| `docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md` | 768 | `ebf94f2a` | **0 von 47** |
| `docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md` | 622 | `a0ec9be3` | **0 von 47** |

Inhalt: die PMU-Domaenen-Achsen-Zuordnung, die Messkurven-Synthese/Hybrid-Binary-Kette, und die
PMC-Rechte-Anweisung mit der `errno`-Sonde.

**Wo es liegt.** Nur im Arbeitsbaum
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/plaene/` — und in
`/home/comdare/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/probst-diplomarbeit-cache-engine/docs/plaene/`
(Zeitstempel 06.08. 22:20).

**Ist es gesichert?** **Nicht in Git.** Nicht in `/home/comdare/backups-workflow/` (dort finden
sich nur Transkript-Treffer). Einzige Kopie ausserhalb des Arbeitsbaums ist das
Desktop-Plain-Backup — kein versioniertes, kein remote-gespiegeltes Medium.

**Gegenprobe mit Nenner:** im selben Verzeichnis liegen **10** untrackte `20260806-*`-Dateien.
Sieben davon sind **byte-identisch** mit `development` (`DIFF-thesis-soll-…`,
`DOSSIER-messachse-wallclock-…`, `KANON-termine-plan-soll-gegen-ist`,
`KLAERUNG-zweiphasig-dreiphasig-…`, `PLAN-break-even-und-drei-benchmark-ebenen`,
`PLAN-hybrid-pmc-numa-core-permutation`, `PLAN-warnungen-und-ausgabe-bei-messfehlern`). Die
Methode findet also, wo etwas ist — die drei Nullen sind echt.

**Was zur Landung fehlt.** Nichts Inhaltliches — nur `git add` + Commit auf `development`.

**Naechste Handlung:** committen, **bevor** irgendjemand `git clean -fd` im super-Hauptcheckout
laufen laesst. **Das ist wortwoertlich das Anlass-Muster des Auftrags, nur 2,7-mal so gross wie
die 896 Dossier-Zeilen von damals.**

---

### V-3 🔴 `experiment_schema.xsd` +24 Zeilen — die super-Haelfte von V-1, auf keinem Ref

**Was es ist.** Im super-Hauptcheckout, uncommittet:
`Code/test_data_xml/experiment_schema.xsd`, **+24 Zeilen, 0 Loeschungen** — das neue
`<xs:element name="core_class" minOccurs="0">` samt Begruendungskommentar (OD-11-RT,
Owner-KERN 06.08., "CT-POLICY vs. RT-FAKTUM").

**Wo es liegt.**
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/test_data_xml/experiment_schema.xsd`

**Ist es gesichert? NEIN.** Blob `f3b31257` — die Suche ueber **alle 47 super-Refs** (heads,
remotes, tags) findet ihn auf **keinem**.

**Warum das schwerer wiegt, als es aussieht.** V-1 (ce, Code) und V-3 (super, Schema) sind
**ein Paket ueber zwei Repositories**. Landet nur V-1, ist die Achse gebaut, aber **kein XML
kann sie ausdruecken** — die Achse waere unerreichbar. Der Bau-Agent hat die super-Haelfte
direkt in den Hauptcheckout geschrieben statt in einen Worktree; deshalb hat sie nie einen
eigenen Zweig bekommen und ist durch jede Zweig-Inventur gefallen.

**Naechste Handlung:** zusammen mit V-1 als **ein** Paket behandeln — super-Commit anlegen,
gleichzeitig mit dem ce-Merge landen.

---

### V-4 🟠 `Code/measure_out_d03/` — 66 Dateien, 3,7 MB Rohmessdaten, untracked und nicht gitignored

**Was es ist.** `progress.cursor`, `e4_xml/measurements.csv`, acht DLL-Permutationsordner mit
`result.csv` / `.stamp` / `.version` / `.rsp`. mtime 26.07.

**Wo es liegt.**
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/measure_out_d03/`

**Ist es gesichert? NEIN.** `git check-ignore -v Code/measure_out_d03` → **Exit 1** = die
Dateien sind **nicht** gitignored, sondern schlicht untracked. Sie faellt damit unter *"Messdaten
nie loeschen"* und wird von jedem `git clean` erfasst.

**Was fehlt.** Eine Entscheidung: sichern (Backup-Ablage, additiv) oder committen. Als
G-10 von Welle `wf_05819268-e3f` gemeldet; der Rest von G-10 (die Plandokumente) ist inzwischen
committet — **dieser eine Posten nicht.**

**Naechste Handlung:** nach `/home/comdare/backups-workflow/` kopieren (additiv, nie loeschen),
dann Entscheid ueber Tracking.

---

### V-5 🟠 super-Gitlink haengt 10 Commits / 2 Landungen hinter ce

**Was es ist.** `git rev-parse development:Code/external/comdare-cache-engine` = **`2b5ecd29`**;
ce `development` = **`c4c04315`**; `git rev-list --count 2b5ecd29..c4c04315` = **10**.

**Fehlend im Gitlink:** die komplette M-1-Serie (`b9fd81ff` d-1 Mess-Achse-Wirkung, `62a5b6f7`
d-4 CEB-Schluessel, `246b2793` d-2 Pruefdock-Vertrag, `8f70898a` H-Restluecken, `89bf2ee6`
Breiten-Fix, `4fdedbbf` cf22, Merge `bba4d90f`) **plus** die L3-Ehrlichmachung (`5c102e05`,
Merge `c4c04315`).

**Ist es gesichert?** Ja — alle Commits liegen auf beiden ce-Remotes. Es ist kein Verlust-,
sondern ein **Wirkungs**-Risiko.

**Korrektur zum Auftragstext:** dort stand "eine Landung alt". Gemessen sind es **zwei
Landungen, 10 Commits**.

**Was fehlt / naechste Handlung:** Gitlink-Bump `2b5ecd29 → c4c04315` in super `development`,
danach ce `main` nachziehen — die super-Bridge triggert laut Anker fest auf `branch: main`,
misst also bis dahin weiterhin nicht den gefahrenen Code.

---

### V-6 🟠 B12 xlsx-Default-Writer existiert nicht — dreimal vom Owner verlangt, im Ledger falsch entlastet

**Was es ist.** Der Owner hat dreimal gesagt, xlsx sei das Default-Lagerformat:
- 05:49: *"Es gibt erstmal xlsx."*
- 11:15: *"Es existiert kein CSV Lager. xlsx ist default."*
- 19:37 (Ledger:7194 verbatim): *"CSV laesst sich schlechter auswerten, **das muss auch noch mit
  in die Abgabe vor der Messung**, ich stimme dir zu, mach es nach deiner Empfehlung."*

**Am Objekt, mit Nenner und Gegenprobe** (ce `development`, `libs/`):

| Messung | Treffer |
|---|---|
| Nenner: Dateien unter `libs/` | **1583** |
| `xlsx_writer` / `XlsxWriter` / `sheet_writer` / `worksheet` | **0** |
| Gegenprobe `csv` | **102** |

Es existiert nur ein Design-Dokument:
`docs/architecture/20260803-a9_xlsx_writer_f3_soll_design.md`.

**Ist es gesichert?** Nicht anwendbar — es gibt keinen Code zu sichern.

**Was fehlt:** der Writer selbst. Ledger:7202 sagt es klar: *"B12 xlsx-Default-Writer #46b/A9
bauen/einordnen (Owner-KERN xlsx=DEFAULT — **sonst faehrt Phase 6 auf CSV**)"*, Ledger:7195
bindend: *"waehrend des Voll-Baus bauen, VOR Messbeginn fertig, UND mit in die Abgabe"*.

**Naechste Handlung:** bauen — und **zuerst die beiden falschen Ledger-Stellen korrigieren**
(siehe Abschnitt 4), sonst entlastet das Ledger den Posten beim naechsten Lesen erneut.

---

### V-7 🟡 `b-e18-snap` — 3 Commits, +2673/−37, gesichert, aber unter stehendem Veto

**Was es ist.** Der Compile-Schnappschuss aus Owner-"E-1" (05:44/05:49): Diplomarbeit +
LaTeX-Compile-Export in einen Ordner an der Wurzel der Messwerte, benannt nach Datum/Uhrzeit.
`git cherry development b-e18-snap` = **3× `+`**: `bda34e79`, `1ae02cdf`, `5c4cf900`
(`ci/anhang_forward_core.sh`, Fixtures, `gitlab-ci-delta.patch`).

**Wo es liegt.** Zweig `b-e18-snap`, Arbeitsbaum `/home/comdare/wt-b-e18snap`.

**Ist es gesichert? JA, dreifach auf beiden Remotes:**
`{origin,github}/rescue/e18snap-base-bda34e79`, `-nb-1ae02cdf`, `-nb2-5c4cf900` — sechs Refs.

**Was zur Landung fehlt.** Nichts Technisches, aber **ein Veto steht**:
`docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md`
(in `development` vorhanden). Zusaetzlich liegt `gitlab-ci-delta.patch` unangewandt im Paket —
**ohne ihn persistiert der Job nichts**. Ledger `vormittag-48` verbucht es korrekt; seit ~12:00
unbewegt, in den Nachtraegen `abend-1/-3/-4` nicht mehr erwaehnt.

**Naechste Handlung:** **kein Nachholen — nur nicht vergessen.** Terminiert auf nach der
Abgabe. Der Posten steht hier, damit er beim naechsten Wiederanlauf nicht durch die
Ledger-Luecke faellt.

---

### V-8 🟡 Tag `w2b-E04-P1-prefold-daf5190e` — 2 verwaiste Patches, der Ledger-Widerspruch besteht heute noch

**Was es ist.** `git cherry development w2b-E04-P1-prefold-daf5190e`:

```
+ 92ad835766f1e6101a03ab909a258e7e8194aa3f   (Emissions-Seite Slice-Kanal)
+ 63406ce366ec271939cddd78390d00601e780216   (Director-Test-Migration)
- daf5190e981f149efa0206de724c12e2b8d1a252   (docs — gelandet)
```

3 Dateien, +146/−13.

**Wo es liegt.** Als **Tag** im ce-Repo — ueberlebt Branch-Loeschung.

**Ist es gesichert?** Ja (Tag). Kein Verlustrisiko.

**Was fehlt.** Der Entscheid. Der Widerspruch ist im Ledger:7202 selbst als B2 notiert:
*"KLAERUNG rescue/w2b-E04-P1 (2 echte ungelandete Patches 92ad8357+63406ce3 vs.
Ledger-'gelandet' — superseded oder nachziehen?)"* — **seit dem Eintrag unbeantwortet.**

**Naechste Handlung:** entscheiden — nachziehen oder als superseded deklarieren. Nicht laenger
offen fuehren.

---

### V-9 🟡 Der lokale Thesis-Klon hat seit Tagen nicht gefetcht

**Was es ist.** Owner 06:24: *"Bitte synce von allen Diplomarbeit Projekten beide remotes auf
gitlab und github"*. Der **Remote**-Teil ist erledigt (Beleg Abschnitt 3). Der **Klon**-Teil
(Memory `feedback_diplomarbeit_4_projects_local_clones_keep_in_sync`) nicht.

**Wo:** `/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit`
- `main` = `29a1700`, `origin/development` = `29a1700`, `github/development` = `ef448e4`
- Der thesis-Gitlink in super `development` = **`19e1592`**
- `git cat-file -e 19e1592` im Klon → **"Not a valid object name"** = der Klon **kennt den
  aktuellen Stand nicht einmal als Objekt**.

**Ist es gesichert?** Ja — der Verlust ist ausgeschlossen, die Arbeit liegt auf den Remotes.
Reine Synchronitaets-Luecke.

**Naechste Handlung:** `git fetch --all` + Fast-Forward im Klon.

---

### V-10 🟡 Hygiene: beide Hauptcheckouts stehen auf Feature-Zweigen, beide lokalen `main` sind stale

| Repo | HEAD steht auf | statt |
|---|---|---|
| super | `b-ci-rueckschrieb-beide-zeiger` (`18a0bdf3`) | `development` (`5a98036d`) |
| ce | `b-m2-pmc-invariante` | `development` (`c4c04315`) |

Lokale `main`-Refs nie nachgezogen: ce `main` = `b241a272` (origin/main = `2b5ecd29`),
super `main` = `9d0f1bad` (origin/main = `71591a24`).

**Warum das ein Befund ist und keine Kosmetik:** genau daraus entstehen die Falschdiagnosen.
Der Auftragstext dieser Runde nannte einen Pfad
(`docs/sessions/backups/20260806-session-transkript-verbatim/`), der im Arbeitsbaum **nicht
existiert** — weil der Checkout hinter dem Commit `1f2d476c` steht, der ihn anlegt. Die Datei
ist real und committet. Ebenso ist das ` M Code/external/comdare-cache-engine` im super-Status
**kein Arbeitsergebnis**, sondern Gitlink-Drift aus dem Fehl-Checkout — **nicht landen**.

**Naechste Handlung:** Hauptcheckouts auf `development` zuruecksetzen, lokale `main`-Refs
nachziehen. Regel fuer alle Agenten: Repo-Inhalte per `git show development:<pfad>` lesen, nicht
per `ls`/`cat` im Arbeitsbaum.

---

### 🔵 IN ARBEIT — nicht vergessen, aber offen

- **Sechs Planungs-Rueckfragen an den Owner** (23:47): Ebene-1-Timing, Pruefdock-Wanderung,
  Break-Even je Ebene, Lager-Orchestrierung, CT-vs-RT-Schaltlogik, Mehrdimensionalitaet.
  Gestellt, **unbeantwortet** — Owner-seitig, blockiert aber weiter.
- **Das 80-Seiten-Gesamt-Dossier** (23:32): vom Lead bei der Pause ehrlich als einziger nicht
  begonnener Auftrag gemeldet, dann gestartet, um die 86 Journale nachgeruestet und neu
  gestartet. Status **unklar** — kein Artefakt gefunden.
- **Elf Wellen-Agenten laufen zum Erhebungszeitpunkt noch** (`wf_50e0559b` 8, `wf_b6065254` 2,
  `wf_d8f8d991` 1). Deren Ergebnisse sind **noch nicht** in dieser Bilanz.

---

## 3. Inzwischen erledigt — was wie vergessen aussah, aber am Objekt erledigt ist

Diese Liste **entlastet** und verhindert Doppelarbeit. Jede Zeile ist selbst nachgemessen.

| Was | Beleg |
|---|---|
| **Der Anlassfall 1: die 896 ungesicherten Dossier-Zeilen** | Arbeitsbaum-Fassung von `20260806-DOSSIER-regressionen-checkheft.md` = **2486 Zeilen** und **blob-identisch** mit `development`. **Geheilt.** |
| **Der Anlassfall 2, Teil "Falschname"** | `wt-numa-cpu-pin` ist `git status --porcelain` **leer**, HEAD = `b1753926` — die Owner-Umbenennung (5 echte Renames, 10 Dateien) ist **committet**, nicht mehr nur gestaged. *(Der Rest von Anlassfall 2 bleibt offen als V-1.)* |
| Ledger-Nachtrag `abend-4` (+572 Z.) | Arbeitsbaum = `development`, **7248 Zeilen**, deckungsgleich |
| `b-pmc-l3-honest` | `5c102e05` → gelandet in `c4c04315`; auf **2 Remote-Refs** |
| `b-m2-pmc-invariante`, `b-m3v2-pmc-window`, `b-pmc-errno-diag` | `git cherry` = ausschliesslich `-` → inhaltlich gelandet, nur unter anderer SHA |
| `b-checkheft-nachtrag`, `b-ci-rueckschrieb-beide-zeiger` | beide `-` → gelandet (letzterer als `3ccbc501`) |
| **Fuenf `w2-*`-Zweige vom 02.08.** (`w2-A13-M1b`, `w2-FK-1`, `w2-FK-2`, `w2c-TP1FK1-Fixes`, `w2c-wachen-fixes`) | `git cherry` = **26 von 26 Commits `-`**. Vollstaendig patch-aequivalent in `development`. Reiner SHA-Vergleich haette hier **fuenffachen Fehlalarm** gegeben. |
| Gate 8 (`8970465d`, 23 Abbildungen DE+EN) | `merge-base --is-ancestor 8970465d 19e1592` = wahr; beide super-Thesis-Gitlinks = `19e1592` |
| Dual-Remote-Sync (Owner 06:24) | super `origin/development` == `github/development` == `5a98036d`; `origin/main` == `github/main` == `71591a24`; ce `origin/development` == `github/development` == `c4c04315`; `origin/main` == `github/main` == `2b5ecd29`. **Alle vier Refs paarweise identisch.** |
| **Alle 19 ce-rescue-Refs** | ausnahmslos in `development` enthalten |
| 7 von 10 super-rescue-Refs | in `development`; die 3 offenen sind saemtlich die E18-SNAP-Kette (V-7) |
| **Sieben der zehn untrackten `docs/plaene`-Dateien** | byte-identisch mit `development` (diff = 0) |
| 40 von 43 Wellen-Dokumentlieferungen | blob-identisch auf `development` — obwohl mehrere Wellenberichte "NICHT committet" meldeten |
| **Alle 6 historischen 0-Ergebnis-Wellen** | jede hat eine Nachfolge-Welle, die geliefert hat: `wf_fd7950a4`→`wf_6069f4fc` (T2-A gelandet) · `wf_81bf4fd9`→`wf_95bf6a37` (B14) · `wf_3bdcf656`→`wf_728af669` (`b-r4-ci-abdeckung` gelandet) · `wf_1008c596`→`wf_d7a17fc9` · `wf_e23b44bb`→`wf_e18c1d53` · `wf_902816c4`→`wf_02b63805` (LB-6). **Null Wellen ohne Ersatz.** |
| 14 der 18 "toten" Agenten | endeten mit `[Request interrupted by user]` = bewusste Lead-Abbrueche paralleler Instanzen, keine Ausfaelle |
| `b-graph-2d3d` (Owner-"E-2", 2D/3D statt Heatmap) | vollstaendig gemerged, `git cherry` = 0 |
| Transkript-Verbatim-Sicherung (Owner 23:32) | `1f2d476c`, 3847 Zeilen + README, committet |
| Arbeitsweise-Doktrin (Owner) | `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md`, `77993f6e`, auf `origin/development` |
| Break-Even + drei Benchmark-Ebenen | `2504514b`, 825 Zeilen |
| Infra-Handout I113 | `cc431b01` |
| `I113_RUNNER_TOKEN…md` | **Richtung umgekehrt:** Arbeitskopie 188 Z., `development` **238 Z.** — die Arbeitskopie ist die aeltere. Keine ungelandete Arbeit. |
| `wt-b-graph`, 21 von 23 `wt-*`-Baeumen | sauber (`dirty=0`) |

---

## 4. Falsche Erledigt-Meldungen

**Es gibt sie — zwei, beide im Ledger, beide denselben Posten betreffend (B12/xlsx).**

**F-1 · Ledger:7016 entlastet Code, der nicht existiert.**
> "xlsx-Writer braucht **KEINE Aenderung** (WIDE-Schema fliesst automatisch); **B12 keine
> Voraussetzung.**"

Widerlegt: 0 Writer-Symbole in 1583 `libs/`-Dateien, `csv` in 102. Ein Writer, der nicht
existiert, kann nicht "keine Aenderung brauchen". Diese Zeile ist der Grund, warum B12 seit
19:37 nicht bewegt wurde.

**F-2 · Ledger:7096 stuft B12 gegen das Owner-Wort zurueck.**
> "P4 **waehrend/nach Messung**: … B12-xlsx-Fuellung"

Dagegen Ledger:7195, bindend, aus derselben Owner-Antwortrunde: *"B12 xlsx-Writer: waehrend des
Voll-Baus bauen, **VOR Messbeginn fertig, UND mit in die Abgabe** (vor Fr)"* — und Ledger:7202:
*"sonst faehrt Phase 6 auf CSV"*. **Zwei Ledger-Stellen widersprechen sich; die juengere ist die
falsche.**

**Ausdruecklich: darueber hinaus wurde keine falsche Erledigt-Meldung gefunden.** Insbesondere
E18-SNAP, B14, A1, das numa-Paket und M-1 wurden im Transkript **durchgaengig ehrlich** als
"gebaut, ungelandet" gefuehrt. Task #22 wurde sogar live selbst korrigiert auf *"M-1 GELANDET,
aber PIPELINE ROT — ich habe gelandet, bevor sie durch war"*. Und die perf-Rechte-Antwort
(Owner 21:xx) widerlegte die **eigene** vorherige Empfehlung am Objekt
(`perf_event_paranoid = 1` auf beiden Maschinen, kein Rechteproblem). **Die Buchfuehrung ist
ehrlich; das Problem liegt woanders — siehe Abschnitt 5.**

---

## 5. Das Muster — warum Arbeit vergessen wurde

Die Funde sind nicht zufaellig verteilt. **Alle vier ungesicherten Posten (V-1, V-2, V-3, V-4)
teilen eine einzige Eigenschaft: sie haben nie einen Git-Ref bekommen, der auf einen Remote
zeigt.** Es gibt drei Mechanismen dahinter.

### Mechanismus A — Die Zweig-Inventur sieht nur Zweige

Die uebliche Landungspruefung ist `git cherry development <branch>` ueber alle Zweige. Sie
findet **per Konstruktion** nur, was auf einem Zweig liegt. Sie ist blind gegen:
- untrackte Dateien im Arbeitsbaum (V-2: 2433 Zeilen, V-4: 3,7 MB Messdaten)
- uncommittete Aenderungen an getrackten Dateien (V-3: +24 Zeilen XSD)
- Zweige, die nie gepusht wurden (V-1: 2 Commits nur lokal)

Genau deshalb wurden 40 von 43 Wellen-Dokumenten korrekt gelandet — die lagen auf Zweigen — und
genau die drei fielen durch, die es nicht taten.

### Mechanismus B — Agenten schreiben in den Hauptcheckout statt in einen Worktree

V-2 und V-3 entstanden, weil Bau- und Planungsagenten direkt in
`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` geschrieben haben. Der
Hauptcheckout steht auf einem Feature-Zweig (V-10), also erscheinen die Ergebnisse als `??`
oder ` M` und gehoeren zu **keinem** Paket. Beim naechsten Paket-Abschluss raeumt niemand sie
auf, weil sie zu keinem Paket gehoeren.

**Verschaerfend:** V-1 und V-3 sind **ein Paket ueber zwei Repositories**. Die ce-Haelfte bekam
einen Zweig, die super-Haelfte nicht. Jede Inventur, die pro Repo laeuft, sieht die Haelften
nie zusammen.

### Mechanismus C — Wellen, deren Ende niemand prueft

Nenner: **86 Wellen, 286 gestartete Agenten, 258 Ergebnisse.** 29 Agenten lieferten kein
Ergebnis; 11 laufen noch, 14 wurden bewusst abgebrochen, **4 starben unbeabsichtigt**
(2× Spend-Limit, 2× API-Serverfehler). Zwei davon (`wf_2dedbffc-996`,
`wf_7262e3f0-c3a`) starben **mitten in der Lieferung** — einer mit dem letzten Satz *"Alle
Pruefpunkte am Objekt bestaetigt. Ich schreibe das Dokument."* und **null `Write`-Aufrufen** im
Transkript. Beide Wellen lieferten am Ende ein Sammeldokument, aber ob der Anteil dieser beiden
Teil-Scopes darin steht, ist **unklar** — es hat kein Neustart stattgefunden.

Die Wellen sind also **nicht** das Hauptproblem: 6 von 6 Null-Ergebnis-Wellen hatten eine
liefernde Nachfolge, und 93 % der Dokumentlieferungen sind gelandet. Das Leck sitzt **nach**
der Welle: zwischen "Agent hat geliefert" und "Ergebnis ist auf einem Remote".

### Die strukturelle Empfehlung — kein Appell, sondern zwei Wachen

**Wache 1 — `git push`-Pflicht bei Paketabschluss, mechanisch geprueft.**
Ein Paket gilt erst dann als abgeschlossen, wenn sein Commit auf mindestens einem
`refs/remotes/*` liegt. Als Pruefung, die kein Urteil braucht:

```
git for-each-ref refs/heads --format='%(refname:short) %(objectname)' | while read b sha; do
  n=$(git for-each-ref refs/remotes --contains "$sha" 2>/dev/null | wc -l)
  [ "$n" -eq 0 ] && echo "UNGESICHERT: $b $sha"
done
```

Auf den heutigen Stand angewandt haette diese eine Schleife **V-1 sofort gemeldet** —
den einzigen Posten, dessen Verlust irreparabel waere. Sie ist billig genug, um in jeden
Session-Wiederanlauf und in jede Pausen-Checkliste zu passen.

**Wache 2 — Arbeitsbaum-Sweep beider Hauptcheckouts, mit Nenner.**
`git status --porcelain` in super **und** ce, jeder `??`- und ` M`-Eintrag gegen `development`
diffen. Sieben von zehn Treffern sind identisch und fallen sofort raus — die verbleibenden drei
sind die Funde. Dazu die flankierende **Doktrin-Verschaerfung**:

- Hauptcheckouts stehen **immer** auf `development`. Bau- und Planungsagenten arbeiten
  **ausschliesslich** in eigenen Worktrees. (V-10 ist die Ursache, nicht die Kosmetik.)
- Repo-Inhalte werden per `git show development:<pfad>` gelesen, **nie** per `ls`/`cat` im
  Arbeitsbaum — sonst misst man einen Stand von vor 12 Commits.
- **Repo-uebergreifende Pakete bekommen in jedem beteiligten Repo einen gleichnamigen Zweig**,
  auch wenn die Aenderung dort nur 24 Zeilen gross ist. Sonst wiederholt sich V-3.

**Die Zusatz-Empfehlung fuers Ledger:** F-1 und F-2 zeigen, dass eine falsche Entlastungszeile
teurer ist als eine vergessene Aufgabe — die vergessene Aufgabe wird beim naechsten Sweep
gefunden, die falsche Entlastung **verhindert**, dass sie gefunden wird. Entlastungen gehoeren
mit Beleg ins Ledger ("0 Treffer in N Dateien, Gegenprobe M") oder gar nicht.

---

## 6. Nenner

**Ohne Nenner ist die Bilanz wertlos** — hier ist er, jede Zahl in dieser Erhebung gemessen.

| Grundgesamtheit | geprueft | Funde |
|---|---|---|
| Wellen-Ordner mit `journal.jsonl` | **86** *(nicht 77 — der Auftragstext war aelter)* | — |
| `started`-Ereignisse | **286** | 29 ohne Ergebnis: 11 laufen, 14 bewusst abgebrochen, **4 echte Ausfaelle** |
| `result`-Ereignisse | **258** *(nicht 250)* | — |
| Wellen-Datenvolumen | 133 MB | — |
| Wellen mit 0 Ergebnissen (historisch) | 6 | **0 ohne liefernde Nachfolge** |
| Dokumentlieferungen aus Wellen (Repo-Pfade) | 43 | 40 committet, **3 offen (V-2)** |
| Transkript-Zeilen (zugewiesener Slice) | **3847** | — |
| Owner-Nachrichten im Slice (`promptSource∈{typed,queued}` **und** `origin.kind=="human"`) | **43** | — |
| Owner-Nachrichten in der Gesamtsession | 105 | 7 reine Bestaetigungen, 8 reine Fortsetzungen, **90 mit Auftrag/Frage** |
| ce Refs gesamt | **231** (davon 40 rescue) | **0 enthalten die numa-Commits (V-1)** |
| super Refs gesamt | **47** | **0 enthalten die 3 Plandoc-Blobs (V-2) oder den XSD-Blob (V-3)** |
| ce lokale Zweige | 56 | 10 nicht in `development`, davon **1 mit echten Patches** |
| super lokale Zweige | 13 | 6 nicht in `development`, davon **1 mit echten Patches** |
| ce Tags | alle | **1 mit 2 verwaisten Patches (V-8)** |
| Arbeitsbaeume (`wt-*` + Klone) | 28 | 21 von 23 `wt-*` sauber |
| untrackte `docs/plaene/20260806-*` | **10** | 7 byte-identisch mit `development`, **3 fehlen** |
| Dateien unter `libs/` auf ce `development` | **1583** | `xlsx_writer`&co. = **0**, Gegenprobe `csv` = 102 · `core_class` = **0**, Gegenprobe `numa` = 111 |
| **WIRKLICH OFFENE Posten** | | **10** (V-1…V-10), davon **4 ungesichert** |
| **Falsche Erledigt-Meldungen** | | **2** (beide B12/xlsx, beide im Ledger) |

**Die Gegenprobe, die den Unterschied macht:** `git cherry` gegen die merge-base hat **26 von
27** Alarm-Commits **entlastet**. Ein reiner SHA-Vergleich haette fuenf Zweige vom 02.08. als
"ungelandet" gemeldet, die vollstaendig in `development` stehen. Umgekehrt ist der super-Gitlink
**zehnmal** weiter zurueck als der Auftragstext annahm. **Beide Fehlerrichtungen treten auf —
deshalb braucht jede Null Nenner und Gegenprobe.**

---

## Anhang: die drei Saetze, auf die es ankommt

1. **V-1 ist der einzige Posten, dessen Verlust irreparabel waere.** 18 Dateien, +2800 Zeilen,
   zwei Commits, **null Remote-Refs**. Ein `git push` von zwei Zweigen kostet dreissig Sekunden
   und schliesst das groesste Risiko dieser Bilanz. Alles andere in dieser Liste ist entweder
   gesichert oder rekonstruierbar.
2. **Das Anlass-Muster hat sich wiederholt, nicht wiedergutgemacht.** Das Dossier von damals ist
   geheilt — aber 2433 Zeilen Plandokumente (V-2), 24 Zeilen XSD (V-3) und 3,7 MB Messdaten
   (V-4) liegen heute an derselben Stelle ungesichert. Es ist keine Wiederholung desselben
   Fehlers, sondern **dieselbe Struktur an drei neuen Stellen**.
3. **Die Buchfuehrung ist ehrlich, die Sicherung ist es nicht.** Kein einziger Posten wurde
   faelschlich als "gelandet" gemeldet — bis auf B12, wo eine Entlastungszeile Code entlastet,
   den es nicht gibt. Das eigentliche Leck sitzt nicht im Berichten, sondern zwischen "Agent hat
   geliefert" und "Ergebnis liegt auf einem Remote". Dagegen hilft keine Sorgfalt, sondern die
   Schleife aus Abschnitt 5.

---

**Erhebungsvorbehalt:** Beide Repositories bewegten sich **waehrend** dieser Erhebung
(ce `development` `bba4d90f` → `c4c04315`, super `71591a24` → `5a98036d`). Elf Wellen-Agenten
liefen zum Erhebungsende noch. Was diese elf liefern, ist in dieser Bilanz **nicht** enthalten.

**Selbstcheck:** Alle Zahlen dieser Bilanz stammen aus eigenen Messungen am Objekt; drei
Aussagen der Vorlage-Berichte wurden dabei widerlegt (numa-Rescue-Ref existiert nicht ·
`wt-numa-cpu-pin` ist inzwischen sauber und der Rename committet · Wellen-/result-Zahlen 86/258
statt 77/250). Wo eine Frage nicht am Objekt entscheidbar war, steht "unklar".
