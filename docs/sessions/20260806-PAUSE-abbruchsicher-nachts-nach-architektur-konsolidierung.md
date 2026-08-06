# PAUSE 06.08.2026 nachts -- abbruchsicher

**Owner-Auftrag:** *"Bitte lege eine abbruchsichere Pause ein"*

Dieses Dokument ist der **ERST-ANKER** fuer den Wiederanlauf. Wer hier weitermacht, liest
zuerst diese Datei, dann den Ledger-Nachtrag **abend-4** (die Architektur-Konsolidierung).

---

## 1. DER STAND -- alle Refs, alle Remotes

| Repo | development | main | Bemerkung |
|---|---|---|---|
| **ce** (286) | `2b5ecd29` | `b241a272` | main haengt **6 Landungen** zurueck -- s. Posten P-1 |
| **super** (288) | `33061184` | `2a6f35d8` | main haengt zurueck |
| **thesis** (289) | `19e1592` | `19e1592` | gleichauf |

**Alle drei auf origin UND github identisch** (zum Pausenzeitpunkt geprueft).

**Der super-Gitlink auf ce zeigt auf `b241a272`** und ist damit **6 Landungen alt** --
`77ed15fa`, `8894d983`, `fb9aefdc`, `22e17f57`, `2b5ecd29` fehlen ihm.

---

## 2. GESICHERTE, NICHT GELANDETE ARBEIT

### 2.1 rescue-Refs (beide Remotes, `refs/rescue/20260806-*`)

| Ref | SHA | Inhalt |
|---|---|---|
| `20260806-m1-identitaetsnaht` | `4fdedbbf` | **36 Dateien, +3671/-200.** Die Identitaets-Naht: `perm_mess_defines()` liest die Mess-Achse, CEB-Schluessel rendert die WAHL statt des ANGEBOTS, Konsistenz-Gate. Voll-Gate gelaufen. **Format-Bump 3->4 NICHT noetig** (Glied [3] traegt die Mess-Zeile bereits). |
| `20260806-numa-cpu-pin-process-probe` | `b4cebdc4` | Die fehlende Unter-Achse (Ausfuehrungs-Lokalitaet). Name vom Owner vorgegeben. |
| `20260806-pmc-l3-honest` | `2b5ecd29` | **Zeigt auf development** -- die eigentliche Arbeit ist noch uncommittet, s. 2.2 |

### 2.2 UNCOMMITTETE Arbeit -- als Patch gesichert

`/home/comdare/backups-workflow/20260806-pause-wip/pmc-l3-honest-WIP.patch` (18 KB)
5 Dateien, +136/-13: `cache_engine_builder_iterator.hpp`, `linux_perf_pmc_source.hpp`,
`windows_pcm_pmc_source.hpp`, `pmc_source.hpp`, `test_a8s3_csv_klasse_c.cpp`.
**Der Teammate war mitten im L3-Ehrlichkeits-Paket.** Worktree `/home/comdare/wt-pmc-l3-honest`
steht unangetastet -- **nicht aufraeumen, bevor das Paket gelandet oder verworfen ist.**

### 2.3 Weitere ungelandete Branches (aeltere, bekannte)

ce: `b-m2-pmc-invariante` (`90bca126`, inhaltlich gelandet), `b-m3v2-pmc-window` (`81651f6e`,
gelandet), `b-pmc-errno-diag` (`3f0d989d`, gelandet), `w2-*` (Historie).
super: `b-checkheft-nachtrag` (`74c1e780`) und `b-ci-rueckschrieb-beide-zeiger` (`18a0bdf3`)
sind **inhaltlich per cherry-pick gelandet**; `b-e18-snap` (`5c4cf900`) traegt weiter das
Verdikt NICHT-LANDEN.

---

## 3. WAS HEUTE GELANDET IST (19 Pakete, drei Repos)

**ce:** LB-6 Stufe 1 · Build-Graph-Kante · Struktur-Haertung Codegen (`generated/limits`) ·
E14 NoneFilter · PMC-Invariante (4/4 Bissbeweis) · Breiten-Heilung · errno-Kanal ·
m3v2-Messfenster.
**super:** B14-super · Graph · Doktrin · Kontextuebergabe · Regressions-Dossier ·
Diff-Hygiene-Wache · Ueberblick (677 Z.) · Anknuepfpunkte (1350 Z.) · Infra-Handout I113 ·
vier Analyse-Dokumente · Thesis-Diff (863 Z.) · Ledger abend-1..4 · Session-Transkript ·
Break-Even-Plan (825 Z.) · Wallclock-Dossier (436 Z.).
**thesis:** Gate 8 · vier Abgabe-Verbesserungen · Anhang-A-Ehrlichkeit (28/28).

---

## 4. DIE OFFENEN POSTEN, nach Dringlichkeit

### P-1 -- KETTE T-1: `main` haengt in beiden Repos zurueck
ce-`main` = `b241a272`, **6 Landungen alt**. super-`main` = `2a6f35d8`.
**Solange `main` zurueckhaengt, misst die super-Pipeline Code, den niemand mehr faehrt** --
`super/.gitlab-ci.yml` triggert ce fest auf `branch: main`.
**Naechste Handlung:** ce-Pipeline auf `2b5ecd29` verifizieren -> `main`-FF (voller SHA, nie
ueber HEAD) -> super-Gitlink-Bump -> super-Pipeline -> super-`main`-FF.

### P-2 -- Die Landungs-Entscheidung fuer M-1 (`4fdedbbf`)
36 Dateien, Voll-Gate gelaufen. **Vor dem Merge:** Gate-Bericht lesen, ASCII-Wache ueber den
vollen Bereich ab merge-base, gitleaks, und die drei adversarischen Verdikte pruefen.

### P-3 -- VOR DER MESSUNG faellig (sonst Datenbruch)
- `pmc_cache_misses_l3` faellt auf AMD still auf `0` (`errno=2`, der Zaehler existiert nicht).
  **Stiller Rueckfall ist verboten** -- ehrlicher Status-Token statt Null. Paket im WIP-Patch.
- Getrennte Ablage je PMU-Domaene im CSV-/Lager-Schema.
- RAW-Events je Mikroarchitektur (Deep-Research-Pflicht).

### P-4 -- OWNER-ENTSCHEIDE, die auf Antwort warten
1. **Zwei Falschaussagen in der Abgabe** (Thesis-Diff Abschnitt 1): **F-01 Talos** (*"jede
   Messung unter zwei Betriebssystem-Regimes"*, null Treffer im Code -- Empfehlung: Aussage
   zuruecknehmen) und **F-02 `flat_hash_map`** (in der gesetzten Aufgabenstellung namentlich
   zugesagt, im Code nur eine eigene SwissTable).
2. **Sechs Rueckfragen zur Planung** (Owner: *"Dann gerne Rueckfragen um die Planung zu
   vervollstaendigen, weil diese Plaene 6 Wochen alt sind"*) -- gestellt, unbeantwortet:
   welche Aufrufe auf Ebene 1 getimt werden · ob die Messung ans Pruefdock wandert ·
   Break-Even je Ebene? · was "Orchestration ueber das Lager" umfasst · wo die Schaltlogik
   lebt (CT oder Lager-Laufzeit) · ob ein Parameter je Kanal reicht.
3. **Faktorisierung der Core-Achse:** Betreuer-Plan nennt `{P|E} x {Single|All}` + Referenz;
   das Achsen-Dossier nennt `{Unpinned|PCoresOnly|ECoresOnly|HybridAware}`. **Nicht dasselbe.**
4. **Runner-Token-Rotation** -- abgegeben an Infra (Handout I113), aber unerledigt.

### P-5 -- Das 80-Seiten-Gesamt-Dossier
Owner-Auftrag, noch nicht begonnen: *"ein gigantisches 80 Seiten Gesamt-Dossier aus dieser
Session"*, **Fable 5 nur bei der finalen Zusammenstellung und bei verify**.
Material liegt: neun Analyse-Dokumente, vier Ledger-Nachtraege, das Session-Transkript.

---

## 5. DIE ZWOELF ARCHITEKTUR-KERNE DIESES ABENDS

**Vollstaendig im Ledger-Nachtrag `abend-4`** (LEDGER ab Zeile 4202, 489 Zeilen).
Kurzform der Kette:

```
[PLANER]  laeuft (RT)  prueft Faehigkeiten, gibt frei, bewegt Unter-Achsen -> baut
[CEB]     laeuft (RT)  traegt CT die freigegebenen Routinen einkompiliert     -> baut
[HYBRID]  laeuft (RT)  Schaltungs-Adapter: waehlt je Last-Kanal               -> baut
[TIER]    laeuft (RT)  das gemessene Objekt

MESSUNG -> FUNKTIONS-SYNTHESE -> SCHNITT-KURVEN (break even) -> optimale Konfiguration
        == die zu WAEHLENDE Binary -> zurueck in den HYBRID als Schaltlogik
```

**Merksatz:** *der Planer FRAGT (RT), die CEB TRAEGT (CT), die Tier-Binary LAEUFT (unveraendert).*

**Wallclock-Verortung:** Micro -> **zusaetzlich IN der Tier-Binary einkompiliert**;
Macro und large scope -> **in der CEB**.

**Schwere-Leiter:** `warn` (Wert existiert, Verwendbarkeit fraglich) · `error` (fehlende
grundlegende Systemeigenschaft) · `fatal` (Integritaet zerstoert).
**Stiller Rueckfall ist verboten** -- er ist die BAUFORM hinter der Dossier-These.

---

## 6. QUELLEN-RANGFOLGE (korrigiert 06.08. nachts)

| Rang | Quelle | Rolle |
|---|---|---|
| **1** | **Die Diplomarbeit** (sechs eingebundene Kapitel + gesetzte Aufgabenstellung) | die geltende Spezifikation |
| **2** | Ledger + Plandokumente, **nach Datum** | juengerer Stand schlaegt aelteren |
| **3** | `docs/termine/` | **Historie**, wochen alt |

Owner verbatim: *"Die Betreuer Plaene sind wochen alt und nicht mehr aktuell, die Diplomarbeit
zaehlt und der neuere Stand schlaegt den alten."*

---

## 7. DIE FALLEN DIESES ABENDS -- damit sie nicht wieder zuschnappen

1. **Stille Nullen, dreimal:** gitleaks ueber ein Submodul meldet `no leaks found` bei
   `0 commits scanned` (`.git` ist dort ein Zeiger) -- **Elternrepo mounten**.
2. **Case-sensitiv gegen VERSALIEN:** "0 dreiphasig-Treffer" gemeldet, real 8. **Immer `-i`.**
3. **`grep -v "/build"` frisst `/builder/`** -- explizite Verzeichnislisten.
4. **Gefiltertes grep verschluckt das Verdikt:** `DIFF-HYGIENE:` trifft
   `DIFF-HYGIENE-WACHE:` nicht. **Wachen-Ausgabe vollstaendig lesen.**
5. **Lokaler `main` ist im Hauptklon veraltet** -- gegen `origin/main` messen.
6. **Nicht in den Branch einer laufenden Welle committen** -- ueber eigene Worktrees landen
   (`wt-landung`, `wt-super-landung`).
7. **Ein Befund traegt sein Erhebungsdatum** -- vor der Handlung gegen den heutigen HEAD messen.

---

## 8. WORKTREES -- Stand bei Pause

**Nicht aufraeumen:** `wt-pmc-l3-honest` (uncommittete Arbeit!), `wt-m1-naht`,
`wt-numa-process`, `wt-landung`, `wt-super-landung`.
Die uebrigen `wt-*` sind Historie gelandeter Pakete.

## 9. SICHERUNGEN AUSSERHALB DES REPOS

- `/home/comdare/backups-workflow/20260806-session-transkript/session-5a19728e-ROH.jsonl`
  -- 33 MB, ganze Session, unrediglert
- `/home/comdare/backups-workflow/20260806-pause-wip/pmc-l3-honest-WIP.patch` -- 18 KB
- `/home/comdare/backups-workflow/QUARANTAENE/bnpj776mm.output` -- die 390 Runner-Token
  (0600), **nicht ins Repo**
- `/home/comdare/backups-workflow/20260806-workflow-rohdaten/` -- die Wellen-Ergebnisse

Im Repo: `docs/sessions/backups/20260806-session-transkript-verbatim/` (rediglert, gepusht).
