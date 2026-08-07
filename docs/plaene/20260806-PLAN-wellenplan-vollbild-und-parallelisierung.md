# WELLENPLAN-VOLLBILD UND ABLAUFSTRATEGIE MIT DISJUNKTHEITS-BEWEIS

Stand: 2026-08-06, abends (Messanker 19:0x UTC). Abgabe Fr 08.08., Trigger-Ziel Do 07.08.
Rolle: Ablauf-Design mit Beweis. READ-ONLY am Code -- dieses Dokument ist der einzige
Schreibvorgang. ASCII-only ausser in woertlichen Zitaten.

Owner-Auftrag, der dieses Dokument traegt (verbatim):

> "Bitte starte einen Explore Agenten mit Opus max Effort very thourough ueber den gesamten
> Wellenplan, ich habe festgestellt, dass du diesen Wellenplan nicht im Kontext hast und dir
> der Ueberblick ueber das gesamte Bild fehlt, was dazu fuehren koennte, dass du Kurze Umwege
> nimmst, statt die saubere Implementierung. Bitte lade ALLE Aufgaben mit Kontext in deinen
> Kontext und kippen die letzten 3 Wellenplaene in deinen Kontext. Die neuesten Aussagen
> gewinen. Danach parallelisieren wir die Aufgaben, die wir koennen und die sich nicht
> ueberschneiden. Bitte beweise in der Designplanung der aktuellen Ablaufstrategie fuer die
> Parallelisierung die Disjunktheit der Aufgaben. Das Ziel ist maximal paralleler Fortschritt.
> Wir duerfen keine details vergessen, die sich um die aktuellen Fixes verstreuen, rate NIE
> und pruefe alle annahmen gegen den Plan mit einem zweiten explore Agenten"

Regeln, die daraus fuer dieses Dokument gelten:
1. Jede Aussage traegt eine Quelle (Datei:Zeile, SHA, Ledger-Nachtrag-Name). Nicht Belegbares
   ist als **UNBELEGT** gekennzeichnet, nicht weggelassen.
2. Die neueste Fassung gewinnt; die aeltere steht als Historie daneben, damit der Widerspruch
   sichtbar bleibt.
3. Wo Disjunktheit NICHT bewiesen werden kann, wird serialisiert.

---

# TEIL 0 -- MESSANKER UND LAGE-KORREKTUREN

## 0.1 Der Objektstand, selbst gemessen (nicht uebernommen)

| Gegenstand | Wert | Messmittel |
|---|---|---|
| super `development` LOKAL | **`1b2124e6`** (Ledger nachmittag-10, 18:39:24) | `git log --oneline -1` |
| super `origin/development` = `github/development` | **`85b74237`** | `git ls-remote` beide Remotes |
| super **ungepusht** | **1 Commit** (`1b2124e6`) | `rev-list --left-right --count origin/development...HEAD` = `0 1` |
| super `origin/main` = `github/main` | **`5534c23c`** | `git ls-remote` |
| super `main..development` | **2** | `rev-list --count origin/main..HEAD` |
| ce `development` = `main` = beide Remotes | **`e7aa1244`** | `git ls-remote` beide Remotes, beide Refs |
| ce `main..development` | **0** | -- |
| super Gitlink auf ce | **`e7aa1244`** (deckungsgleich mit ce/development) | `git ls-tree HEAD Code/external/comdare-cache-engine` |
| thesis Gitlink = Checkout = beide Remotes (`main` UND `development`) | **`8970465d`** | `ls-tree`, `ls-remote`, `status --porcelain` leer |
| `refs/backup/pre-secret-scrub-20260802` auf super origin | **`5ba3d03f`** -- existiert | `git ls-remote origin 'refs/backup/*'` |

## 0.2 Vier Korrekturen an der Lage, die der Lead mitgegeben hat

| Lead-Angabe | Verdikt | Beleg |
|---|---|---|
| ce `development` = `e7aa1244`, Pipeline 15025 GRUEN | **BESTAETIGT** | `ls-remote`; Ledger nachmittag-10 A: "20 Jobs, davon 19 `success` und 1 `manual`, 0 `failed`" |
| super `development` lokal `5534c23c`, davon 2 ungepusht | **UEBERHOLT** -- lokal ist `1b2124e6`, **1** ungepusht | s. 0.1 |
| `main` in beiden Repos UNANGETASTET (ce `c837d830`, super `030d2c62`) | **FALSCH -- der FF ist in BEIDEN Repos VOLLZOGEN.** ce `c837d830..e7aa1244`, super `030d2c62..5534c23c`, je per Voll-SHA, echte Fast-Forwards | Ledger nachmittag-10 A; `ls-remote` bestaetigt beide Werte |
| "herrenloser overleaf-Submodul-Drift" OFFEN | **GESCHLOSSEN.** Der Drift zeigte RUECKWAERTS (Checkout `ef448e4b` = 78 Commits Vorfahr des Zeigers `29a1700d`), war also ein stale Checkout, keine ungesicherte Arbeit. Geheilt per `git submodule update`, danach Gate 8 (`8970465d`) auf thesis `development`+`main` beider Remotes gelandet und der Zeiger mit `85b74237` nachgezogen | Ledger nachmittag-10 C (Regel 8/9); heute nachgemessen: Zeiger = Checkout = `8970465d`, Baum sauber |
| A1-NB2 "Lens-Verdikt fehlt" | **UEBERHOLT -- Verdikt liegt vor: LANDEN MIT AUFLAGE (Bump).** Lead-Entscheid, "Der Bau laeuft" | Ledger nachmittag-10 D |
| super-Pipeline zu `b35aea1b` lief zuletzt | **UEBERHOLT.** Ledger nachmittag-10 A nennt super 15026 (`5534c23c`, 13/13) und 15034 (`85b74237`, 178 s, success). **Fuer `1b2124e6` ist keine Pipeline gemessen -- der Commit ist nicht gepusht.** |

**BILANZ des Abends laut Ledger nachmittag-10 A:** `ce/development` 15025, `ce/main` 15029 + 15031,
`super/development` 15026 + 15034, `super/main` 15030 -- **sechs gruene Pipelines, kein roter Job.**
Ich habe die GitLab-API nicht selbst abgefragt: **die Pipeline-Nummern und Job-Bilanzen sind
UNBELEGT-uebernommen aus dem Ledger**, nicht von mir am API-Objekt nachgemessen.

## 0.3 Was der dominierende Befund des juengsten Plans war -- und warum er entfaellt

`docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md` (18:06, das juengste PLAN-Dokument)
sagt in Abschnitt 1 (Z. 40-42) verbatim:

> "Die Frage ist heute falsch gestellt -- und das ist der wichtigste Befund dieses Dokuments.
> Der dominierende Blocker ist nicht, dass die Pipeline rot waere. Er ist, dass die Pipeline
> **die fragliche Arbeit gar nicht anfasst**."

Begruendung war: `super/.gitlab-ci.yml` triggert ce fest auf `branch: main` (drei Vorkommen --
**von mir nachgezaehlt: Z. 255, 273, 291, alle drei bestaetigt**), und ce/main lag 48 Commits
zurueck. **Dieser Befund ist durch den `main`-FF ersatzlos entfallen:** ce/main == ce/development ==
`e7aa1244`. Der getriggerte Branch traegt exakt die Landelinie.

**ABER -- die Fehlerklasse ist nicht entfallen, sie ist nur zurueckgesetzt.** Der Trigger zeigt
weiterhin auf `main`. **Jede kuenftige ce-Landung auf `development` erzeugt den Zustand erneut**,
bis ce/main wieder nachgezogen ist. Daraus folgt eine bindende Auflage fuer jede Welle unten:

> **AUFLAGE T-1 (neu, aus dem Objektbefund):** Nach JEDER ce-Landung auf `development` gehoert
> der ce-`main`-FF und der super-Gitlink-Bump in denselben Arbeitsgang. Sonst faehrt der
> super-Trigger wieder ueber Code, den niemand mehr baut -- exakt der Zustand, den heute Abend
> ein FF geheilt hat.

## 0.4 Die juengsten Quellen, nach Alter sortiert (die neueste gewinnt)

| # | Quelle | Zeit | Committet? | Rolle |
|---|---|---|---|---|
| 1 | **Ledger-Nachtrag `nachmittag-10`** (Commit `1b2124e6`, 194 Zeilen) | **18:39** | ja, **NICHT gepusht** | **JUENGSTE AUSSAGE. Bei jedem Widerspruch gilt dieser Text.** |
| 2 | Ledger-Nachtrag `nachmittag-9` (Commit `5534c23c`, 111 Zeilen) | 18:14 | ja, gepusht | Regelzeilen 6+7, PMC-Sperrposten |
| 3 | `docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md` | 18:06 | **NEIN (`??`)** | Testplan (i)/(ii)/(iii), Fahrplan Schritt 0-5, O-A..O-H |
| 4 | `docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md` | 16:58 | **NEIN (`??`)** | KK-1..KK-9, V-A..V-F, BINDENDE REGEL, Arbeitsliste i-1..i-6 / ii-1..ii-4 / iii-1..iii-4 |
| 5 | `docs/plaene/20260806-PLAN-host-belegung-batch-plan-ablage.md` | 16:35 | ja | F7-Kanon, revidierte Empfehlung "NICHT vor der Abgabe" |
| 6 | `docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md` | 16:24 | **NEIN (`??`)** | Landereihenfolge L0-L8, Zwaenge Z1-Z6, B1/B2, R1-R9, Kalibrier-Stichprobe |
| 7 | `docs/sessions/20260806-PAUSE-...-nach-vierfach-review.md` | 14:52 | ja | ERST-ANKER, **inhaltlich ueberholt** ("B14 NICHT landefaehig" -- B14 ist gelandet) |
| 8 | `docs/sessions/20260806-DELTA-abc-straenge-vs-neue-wellen.md` | 14:42 | ja | V-01..V-20 |
| 9 | **`docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md`** (475 Z.) | 14:40 | ja | **DAS MASTER-TODO-REGISTER.** P0-P4 / VOR-ABGABE / OWNER-FENSTER / PHASE-6 / NACH-ABGABE + B-1..B-17 + Nachtrag 10:45 + Nachtrag V-01/A15. Von KEINEM juengeren Dokument ersetzt -- die juengeren behandeln nur den Landestrang |
| 10 | `docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md` | 13:59 | **NEIN (`??`)** | F7 Option b, ausdruecklich NACH-Abgabe |
| 11 | `docs/plaene/20260806-PLAN-golden-update-fenster.md` / `...-scheibe6-weg-a-...md` | 12:49 / 12:42 | ja | F5- bzw. F3-Bauplan |
| 12 | `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md` | 08:11 | ja | Leitplanken 1-4 + DAG; **Sequenz-Autoritaet der P0-P4-Klassenzuordnung** |

**VERLUSTRISIKO, unveraendert offen:** vier Dokumente (#3, #4, #6, #10) stehen unversioniert
(`??`) im super-Baum, darunter **die zwei juengsten Wellenplan-Traeger**. Dazu
`Code/measure_out_d03/` (Messdaten, s. 1.9). `git status --porcelain` heute:

```
?? Code/measure_out_d03/
?? docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md
?? docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md
?? docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md
?? docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md
```

Ein `git clean` oder ein aufgeraeumter Worktree vernichtet sie. Das ist dieselbe Fehlerklasse
wie die `.gitignore`-`*.log`-Falle (Ledger, Commit `9c858a73`: *"12 von 18 waeren stumm
verschluckt worden"*).

---

# TEIL 1 -- DIE KONSOLIDIERTE POSTENLISTE

Grundlage: REGISTER (Quelle 9) als Geruest, ueberschrieben durch die juengeren Quellen 1-6,
jeder Posten am Objekt nachgemessen wo moeglich. Statuszeichen:
**GELANDET** / **OFFEN** / **OFFEN-UNGEPRUEFT** / **SUPERSEDED** / **UNBELEGT**.

## 1.1 GELANDET HEUTE (Block geschlossen, am Objekt per `merge-base --is-ancestor` geprueft)

| Paket | Spitze | In `development`? | Beleg |
|---|---|---|---|
| R4-CI-Abdeckungs-Invariante + Diff-Hygiene-/ASCII-Wache | `3133f226` (enth. `dcb2f08f`, `597ecffe`, `557d8023`) | **JA** (Merge `b5e0e4e7`) | FAHRPLAN Anhang; Landestand-Tabellen beider Erhebungen, 2x geprueft |
| T2-A / Neuanker Format 3 | `b6d87c08` / `a9a352bb` | **JA** (Merge `86be2420`) | ebd. |
| B14-ce (ABI-Minor 8.0->8.1, CLU-Kette) | `cc20b63d` (enth. `4b38d072`, `16a173f2`) | **JA** (Merge `f577f886`) | ebd. |
| B14-super (GOLDEN-XML + KF-6-XML) | `50dc231b` (enth. `1ba29b63`, `9934a7e5`) | **JA** (Merge `4b1cd5e3`) | ebd. |
| honest-empty | `838612f3` | **JA** (Merge `40bf8a66`) | ebd. |
| P92 Registry-Kanon | `8065aec0` | **JA** | Erhebung 2, per `is-ancestor` |
| Doku 77/78 | `442c960b` | **JA** | ebd. |
| Graph 2D/3D | `6124c6f7` (enth. `31af5a92`) | **JA** (Merge `725ead43`) | ebd. |
| Lint-Heilungen ce (cf22 + cppcheck) | `98952e02`, `e7aa1244` | **JA** (dev-Spitze) | Ledger nachmittag-9 B |
| Submodul-Bump ce -> `e7aa1244` | `9a2ef3b2` | **JA** | `ls-tree` heute |
| Gate 8 thesis (23 Graph-Abbildungen DE+EN) | `8970465d` | **JA** (thesis `main` + `development`) | `ls-remote` thesis heute |
| Thesis-Zeiger-Nachzug im super | `85b74237` | **JA** | `ls-tree` heute |
| `main`-FF beide Repos | ce `e7aa1244`, super `5534c23c` | **JA** | `ls-remote` heute |

## 1.2 UNGELANDET -- die vollstaendige Menge (Gegenprobe gefahren)

Erhebung 2 hat **alle lokalen Branches beider Repos** gegen `development` getestet. Ungelandet
sind **genau zwei** Arbeitszweige, plus fuenf alte `w2-*`-Zweige und die `backup/`-Anker:

| Zweig | Repo | Spitze | Umfang | Verdikt |
|---|---|---|---|---|
| `b-a1-wurf-vertrag` | ce | `fdfa68ee` (+8 Commits, 37 Dateien, +2114/-81) | s. 1.3 | **LANDEN MIT BUMP-AUFLAGE**, Bau laeuft |
| `b-e18-snap` | super | `5c4cf900` (+3 Commits, 6 Dateien) | s. 1.7 | **NICHT LANDEN** -- Verdikt liegt archiviert vor |

Alle 15 Worktrees heute selbst geprueft. **Dirty sind genau zwei:**
- `/home/comdare/wt-b-a1` -- **32 Dateien, +365/-148 uncommitted** (die laufende Bump-Auflage)
- `/home/comdare/.claude/jobs/5a19728e/tmp/l1_landing` -- 8 Dateien; Erhebung 2 hat alle 8 per
  `git hash-object` gegen `development` geprueft: **8/8 identisch** -- kein Arbeitsverlust,
  es ist der bereits als `b35aea1b` gelandete cf22-Nachzug.

Alle anderen 13 Worktrees: `dirty=0`.

## 1.3 A1 -- der letzte offene Teil des Bau-Blocks (P2/ce)

**Status: LANDEN, mit Auflage. Bau laeuft, Arbeitskopie dirty.**

- Verdikt (Ledger nachmittag-10 D): der Lens hat die Kernaussage am Objekt bestaetigt (reallocate-Fix
  trifft 24 Strategie-Header, ohne ABI-Bump, weil die Bedingung 0 Aufrufer hat). Befunden wurde
  die **Inkonsistenz zur eigenen Vorwelle** (dort 26 Strategien gebumpt bei derselben Aussageform).
  **ENTSCHIEDEN (Lead): FUER den Bump** -- "dieselbe Aussageform muss dieselbe Folge haben",
  Owner-Doktrin "heute unerreichbar entlastet nicht".
- Zahl-Korrektur ebd.: **VIER neue Sub-Concepts, nicht drei** (`ThrowTranslatingStrategy`,
  `StdAllocatorAdaptingStrategy`, `ValueSemanticStrategy`, `StatisticsReportingStrategy`).
- Die drei kursierenden Zahlen sind **drei Gegenstaende, kein Widerspruch**: 27 = beruehrte
  Dateien unter `axes/alloc/` (26 Strategien + Basis-Header), 24 = reallocate-Fix, 26 = Versions-Pin.
- Uncommitted heute im Baum (selbst gemessen): die 26 Strategien tragen jetzt zwei Versionen --
  24 auf `"v1.0.2c"`, 2 reallocate-lose (`PmrResourceAllocator`, `VampirNfpAllocator`) bleiben
  `"v1.0.1c"`; der Pin-Test prueft je Strategie namentlich.
- **Offene Vorbedingungen** (FAHRPLAN L4): cf22-Lauf (clang-format), Lens-Bestaetigungs-Pass,
  Dual-Review. Owner-Scope-Frage O-B ("Zustimmung zur Ausweitung um den 24x-reallocate-Fix") ist
  durch den Lead-Entscheid nachmittag-10 **beantwortet** -- Historie: FAHRPLAN 16:24 fuehrt sie
  noch als offene Owner-Frage.
- **Warum A1 nicht "nach dem Trigger" kann** (FAHRPLAN Z. 158-161, verbatim):
  > "R4, T2-A, B14-ce und A1 bilden **einen einzigen Bau-Block, der VOLLSTAENDIG vor dem Trigger
  > gelandet sein muss.** Nicht weil sie einander blockieren, sondern weil jedes von ihnen die
  > Identitaet der gebauten Binaries aendert. Landet auch nur eines davon nach dem Voll-Bau-4,
  > ist der gesamte Bau zu wiederholen."

## 1.4 Der PMC-Sperrposten -- der schwerste offene Posten vor Phase 6

**Alle Einzelzeilen heute selbst nachgemessen:**

| Befund | Messwert | Ort |
|---|---|---|
| `COMDARE_ENABLE_PMC` im Planer | **0 Vorkommen** (`grep -c`) | `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` |
| vier `cmake -B build`-Emissionen, alle mit `-DCOMDARE_V32_ENABLE=ON`, **keine** mit PMC-Flag | Z. **841, 877, 1194, 1342** | ebd. |
| `allow_failure: true` am Mess-Batch | Z. **1373** | ebd. |
| PMC-Preflight emittiert in jeden Batch | Z. **1361-1364** (Ledger); Kommentar `:1352-1360` | ebd. |
| Preflight-Verdikt | `bool const pmc_seam_ok = delta.available \|\| counters_all_zero;` | `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:71` |
| zweite Wache: ehrlicher Skip | `if (!delta.available) { ... "SMOKE_SKIP" ...; return 0; }` | `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:58-63` |
| Default | `option(COMDARE_ENABLE_PMC ... OFF)` `CMakeLists.txt:67`; Makro nur bei ON `:77` | ce |

**Ledger nachmittag-10 E ist die juengste und schaerfste Fassung -- sie korrigiert nachmittag-9:**
"nachmittag-9 sagt 'Drei Wachen, keine loest aus'. **Das ist zu milde: es sind vier, und die
vierte ist die eigens dafuer gebaute.**" Und zur Wurzel:

> "**DIE WURZEL IST NICHT DIE IRREFUEHRENDE OPTION-BESCHREIBUNG**, wie nachmittag-9 nahelegt,
> sondern: **die PMC-Pflicht war an ZWEI JOB-NAMEN geheftet statt an eine Invariante.**"

Owner-Plan-SOLL (F9, 16.07., verbatim aus dem Ledger):
> "Die Infra hat die Einrichtung schon seit Tagen fertig. NICHT mehr gegated, kann von MIR
> [Agent] installiert werden und **MUSS als PFLICHT fuer die Vollstaendigkeit aller perf-Messwerte
> mit in die Ergebnisse**"

Die haeufig zitierte Gegenstelle ("reale Cache-Misses/PMC bleiben honest-0 bis #26") stammt aus
dem Block vom 12.07. und ist **vier Tage aelter als die Pflicht** -- ueberholt, nicht gueltig.

### 1.4.1 NEUER BEFUND -- die Praemisse "auf Linux gibt es GAR KEINE PMC-Quelle" ist am Messobjekt zu praezisieren

Die ANKLAGE (V-E) und der Testplan (KK-1) sagen, alle sieben PMC-Spalten seien "strukturell 0".
**Im Baum liegt ein echter Mess-Lauf, der zeigt, dass die Linux-Quelle mit Flag reale Zahlen
liefert.** Selbst ausgelesen aus `Code/measure_out_d03/e4_xml/measurements.csv`
(26.07.2026 16:38, `;`-separiert, 16 Datenzeilen, `platform=linux-x86_64`,
`build_version=m3v2-smoke`):

| Spalte | Ergebnis ueber alle 16 Zeilen |
|---|---|
| `pmc_available` | **1** (16 von 16) |
| `pmc_cache_misses_l1` | **16 verschiedene Werte, 4.2e7 .. 1.17e9** (z. B. 756895968, 44168554, 1169857296) |
| `pmc_dtlb_misses` | **real und variabel: 35 .. 38471** |
| `pmc_cache_misses_l2` / `_l3` / `_coherence_invalidations` / `_energy_micro_joules` | **0 in allen 16 Zeilen** |

**Was das beweist:** dieser Baum KANN auf Linux `available=1` mit realen L1- und dTLB-Zaehlern
schreiben. Der Fix i-1 ist damit nicht bloss formal richtig, er wuerde **Daten erzeugen**.
**Was es NICHT beweist (ausdruecklich):** ueber welchen Weg dieser Lauf gebaut wurde -- ich habe
den erzeugenden Job nicht identifiziert. Es belegt **nicht**, dass die dynamische Kette das Flag
traegt (sie tut es nachweislich nicht, s. Tabelle oben).
**Es bestaetigt zugleich I-PMC-2/I-PMC-3 unabhaengig:** L2/L3/coherence/energy bleiben auch bei
`available=1` auf 0. Ledger nachmittag-10 E zieht daraus die Konsequenz:
> "**Der Anhang kann also selbst im besten Fall nur L1D + dTLB zeigen** -- das gehoert vor
> Phase 6 entschieden, nicht nach der Messung entdeckt."

### 1.4.2 Was zu entscheiden ist -- DREI Dinge, nicht eins (Ledger nachmittag-10 F)

1. das Flag in die dynamische Kette **als Invariante**, nicht als Job-Name;
2. die Wache so drehen, dass **"Quelle nicht gebaut"** ein Fehler ist und nicht ein Skip;
3. der **Anhangs-Umfang** angesichts I-PMC-2/3 (nur L1D + dTLB).

### 1.4.3 Zwei Praezisierungen, die den Fix vor Rueckfaellen schuetzen

- **`m3v2_pmc_smoke.cpp:62-67` sagt das GEGENTEIL dessen, was der Testplan unterstellt:** das
  fruehere Verdikt `honest_null` (`!available && all-zero`) kippte ein ehrlich-live-PMC
  (`available=1`) auf SMOKE_FAIL; der 13.07.-Fix (M-CE-25/Muster-F) hat genau das geheilt. Wer
  die Zeile "zurueckdreht", baut den alten Bug neu ein. Die ANKLAGE warnt ausdruecklich
  (`i-2`, Z. 428): *"Den 13.07.-Inversionsfix NICHT ruecknehmen"* -- der Fix gehoert an den
  **Preflight-Ort** verengt (`--require-available` bzw. Preflight prueft `pmc_available=1`
  explizit), nicht in das allgemeine Verdikt.
- **`allow_failure: true` (Z. 1373) hat ZWEI Doktrinen gegen sich stehen, nicht eine.**
  (a) Der Kommentar direkt darueber (`:1332`) traegt die Sichtbarkeits-Doktrin
  (Memory `feedback_measurement_failure_visibility_csv_failed_not_null_plus_log`):
  Mess-Fehler => CSV `'failed'` + Log, Pipeline bleibt gruen.
  (b) Die ANKLAGE selbst schraenkt in **V-C** (`:388-394`) den Geltungsbereich von Sec.66-N2 ein:
  *"'BEIDE hart (kein Gate/allow_failure)' gilt fuer die **ce-Jobs, nicht fuer den Mess-Batch**."*
  Auflage aus ANKLAGE i-3: *"Vorher pruefen, ob eine Pipeline-Politik (Landewarteschlange) daran
  haengt."* Zusatz: der Batch ist ohnehin `rules`-gegated (`:1329-1331`).

## 1.5 Die Kostenklammer-Posten (ANKLAGE), Stand heute nachgemessen

| Posten | Stand an `e7aa1244` (selbst gemessen) | Einordnung |
|---|---|---|
| **KK-1 / K-02 PMC-Flag fehlt** | **BESTAETIGT** (0 Treffer, Emissionen 841/877/1194/1342) | **VOR Abgabe -- Owner O-A.** Nicht warten (stumme Entwertung der Messung) |
| **KK-5 / K-02b `allow_failure`** | **BESTAETIGT** (`:1373`) | **Owner O-B**, mit O-A zusammen; V-C schraenkt Sec.66-N2 ein |
| **KK-3 / K-03 / KK-6 Axis-Lock doppelt** | **GEHEILT** -- `grep -c '^contract:axis-version-lock:'` = **1** (`:447`) auf `development`; und da `main == development`, **auch auf `main` geheilt** | erledigt. Historie: Testplan (18:06) fuehrt "auf main weiter doppelt" -- durch den FF ueberholt |
| **KK-2 / K-01 BESTANDSLOG-Wurzel** | **Opt-in BESTAETIGT** (`profile_run_entry.hpp:435`: `if (bl == nullptr \|\| ... != "true") return ex::FingerprintFn{};`). Die Ledger-Behauptung "totes Holz" ist **WIDERLEGT**: `experiment_plan_director.hpp:952-955` reicht `COMDARE_BESTANDSLOG` + `_DOC_KEY` + `_OWNER_UUID` + `_MASCHINE` per `append_forward_var_literal` durch (4 Zeilen, selbst gelesen) | **Owner O-C.** Der Posten faellt aus "tot" in "laeuft still falsch, sobald jemand opt-in setzt" |
| **KK-4 `bestandslog_active` ohne Fingerprint** | **BESTAETIGT** `cache_engine_builder_iterator.hpp:1658-1660`: `fetch && store && bestand_key_of && !bestand_doc_key.empty()` -- `bestand_fingerprint_fn` fehlt. **ERGAENZUNG, die in keiner Liste steht: daneben (`:1665-1668`) sitzt `mess_bestandslog_active` mit DERSELBEN Luecke** ("G-E3: der Messwert-Genus-Zustand. EIGENES Gate") | Der Fix muss **beide** Gates fassen, sonst heilt er die Haelfte |
| **K-06 doppeltes Fingerprint-Leeren / K-07 `kPlanOhneAnker`** | Code-Existenz gesichert (`planer_driven_build.hpp` ~297) | abhaengig von O-C |
| **K-04 234-V-b Shaped-Emission** | kein Aufrufer im Produktivpfad | **NACH Abgabe**, benannt |
| **K-05 `target_isa.numa_node` / `.page`** | nur 2 Schreibstellen des Parsers, **null Leser** | **NACH Abgabe (Code), VOR Abgabe (eine Doku-Zeile)** -- Owner O-E |
| **KK-7 `active_telemetry_is_silent()` == literal false** | golden-brechend, Owner-Absprache | GOLDEN-UPDATE-Fenster, nach Abgabe |
| **KK-8 `kPlanOhneAnker` Dauerzustand** | Symptom von KK-2 | Reparatur = i-5 |
| **KK-9 `bytes_in_use_peak` traegt Endwert** | selbstdokumentiert, `f15_compare`-Konsument **nicht verifiziert** | ii-4, nach Abgabe |

**Die BINDENDE REGEL aus der ANKLAGE (Z. 351-357), verbatim -- sie gehoert in jeden Bau-Auftrag:**

> "**KEINE KOSTENKLAMMERN: Eine geplante Faehigkeit wird IMMER vollstaendig verdrahtet und in der
> Produktionskette scharf geschaltet -- "heute liest das niemand", "kein Aufrufer", "inert",
> "opt-in", "byte-/golden-neutral", "spart Rechenzeit" sind KEINE Gruende, sondern
> Vollstaendigkeitsbehauptungen ueber ein System, das du nicht ueberblickst; wer eine Faehigkeit
> dennoch nicht scharf schalten kann, baut KEINE Bedingung ein, sondern meldet sie ungebaut an den
> Owner. Und: jede Wache muss den AUSFALL erkennen, gegen den sie gebaut wurde -- ein Verdikt, das
> den Ausfallzustand als Erfolg wertet, ist keine Wache, sondern ein Testat.**"

Zusatz-Auflage (Z. 359-362), verbatim:
> "Wer eine Env-Variable, ein `rules:`-Gate oder ein CMake-Flag als Aktivierungsbedingung einbaut,
> muss im selben Commit die Stelle nennen, die es in der Produktion setzt -- und diese Stelle im
> Baum belegen. Alle drei schwersten Posten dieser Anklage (KK-1, KK-2, KK-3) waeren an dieser
> einen Auflage gescheitert."

## 1.6 Die Test-Offensive (Testplan Quelle 3), Stand heute

| ID | Inhalt | Status heute (selbst gemessen) |
|---|---|---|
| **T-i-3 Nenner an der Landelinie** | Abdeckungs-Wache auf dem gelandeten Stand nachmessen; im Plan als "**der erste auszufuehrende Posten des ganzen Plans**" gefuehrt | **ERLEDIGT und UEBERHOLT den Plan.** Ledger nachmittag-9 (18:14, juenger als der Plan): `test:coverage-guard` bestaetigt in der CI **407 von 407** Tests von einem fahrenden Job ausgefuehrt, plus je ZWEI serielle ctest-Laeufe 407/407, gemessen an `e7aa1244`. Historie: der Plan (18:06) fuehrt 406/406 an `3133f226` und lehnt die 409 ausdruecklich ab |
| **T-i-1 XXE-/Entity-Bissbeweis** | Beweis, dass die B14-NB5-Entity-Sperre eine `DOCTYPE`-Datei ablehnt UND eine harmlose durchlaesst (Doppelprobe) | **OFFEN.** Selbst gemessen: `grep -rlE 'DOCTYPE\|ENTITY\|xxe\|XXE'` ueber ce `tests/` = **0 von 457 Dateien**. Im super sind es **3 von 20** in `Code/tests/` -- aber das sind die **Wachen selbst** (`xml_canonical_utils.cmake`, `golden_n_consistency_check.cmake`, `fixture_schema_subset_check.cmake`), nicht ihr Test. Kein `add_test` mit doctype/entity/xxe. Die einzige `*bissbeweis*`-Datei im Baum gehoert der Breiten-Wache (`ce/scripts/ci_diff_ascii_width_guard.bissbeweis.txt`). **Die Sperre ist gelandet, ohne dass ein Test sie festhaelt** |
| **T-i-2 Mutationsprobe `contract:axis-version-lock`** | Beweis, dass der Tripwire BEISST (Drift ohne Bump -> ROT) | **OFFEN.** Die Doppel-Definition ist geheilt (1 Vorkommen `:447`) und der Job lief in 15025 gruen -- **dass die ueberlebende Definition beisst, ist nicht geprueft.** Plan: *"Ein gruener `contract:axis-version-lock` ist bis dahin von einem inerten Job nicht zu unterscheiden."* |
| **T-ii-1 PMC-Flag-Vertrag der Emission** | Emissions-Test auf das Flag | **OFFEN, gated auf O-A.** Plan-Warnung: sonst "baut man ein rotes Gate in eine Pipeline, die gruen werden soll" |
| **T-ii-2 Fingerprint-Kreuzprobe Schreib-/Lesepfad** | Schreiber erzeugt genau die Form, die der Leser akzeptiert | **OFFEN** (2-4 h) |
| **T-ii-3 `bestandslog_active` an Fingerprint binden** | = i-6 | **OFFEN, gated auf O-C** |
| **(iii) Wunschliste nach der Abgabe** | Planer->CEB->Tier-Wertidentitaet via `.so`; libabigail-ABI-Baseline alt-gegen-neu; vollstaendige Stempelgrammatik + Injektivitaet; exaktes 18-Achsen-Manifest (Name+Reihenfolge+Eindeutigkeit); Lager-Crash-Atomizitaet je Schreibgrenze; XLSX-Roundtrip; 1,57-Mio-Kardinalitaet; Spool-Barriere deterministisch (Latch statt racy Backend); CLU-Erwartungstabelle mit **eigenem** Nenner (`test_clu_per_layout.cpp:108-110`); Separator-Mismatch `test_phase6_vorbau.cpp:41-52` (Fixture Komma, Code Semikolon); Tautologie `test_r2_suffix_wachen.cpp:77-78` | **NACH ABGABE** |

## 1.7 E18-SNAP -- NICHT LANDEN (unveraendert)

Woertliches, archiviertes Verdikt gegen genau `5c4cf900`
(`docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md`):

> "NICHT-LANDEN. Die Anforderungen 2-5 sind nicht vollstaendig erfuellt; besonders die falsche
> Remote-Belegakzeptanz, der nicht erzwungene Nachhol-Bau, fail-open Fetch, .tmp-False-Positive
> und die unvollstaendige Recovery-Identitaet sind landeblockierend."

Zusatz-Klammer (FAHRPLAN Abschn. 5): der `.gitlab-ci.yml`-Writeback-Patch liegt als
`gitlab-ci-delta.patch` **unangewandt** im Paket -- ohne ihn persistiert das Feature nichts.
Von mir am Objekt gegengeprueft: der Branch berueht 6 Dateien, darunter genau diesen
`gitlab-ci-delta.patch` und **nicht** `.gitlab-ci.yml` selbst. **NB3 im P4-Fenster, nach dem
Trigger.**

## 1.8 KF-6 / OOB -- eine Registerzeile ist STALE, zugunsten des Projekts

Das REGISTER fuehrt (P1) "KF-6 Cacheline-NTTP-Vollausbau, Bau-Teil ... kLbufBytes-OOB-Fix
abi_adapter:454-464" als OFFEN, und B-5 haengt daran eine **harte Kopplungs-Auflage**:
*"KF-6-Bau-Teil MUSS vor Trigger gelandet sein, SOFERN das golden-XML line_sizes>64 traegt."*

**Am Objekt gemessen -- die Auflage ist erfuellt, und zwar zweifach:**

1. **Der OOB-Fix IST GELANDET** (via B14-NB2/NB3). In `libs/cache_engine/anatomy/abi_adapter.hpp`
   ist `kLbufBytes` in **allen drei Pfaden** abgeleitet, nicht mehr literal, je mit `static_assert`:
   ```
   :622/:623   run_workload                kMaxStride = detail::layout_scan_stride_bytes<MemLayout>(kRecordSize)
   :731/:732   run_workload_segmented      static_assert(kLbufBytes >= (kRecords-1)*kMaxStride + sizeof(uint64_t))
   :873/:874   run_workload_segmented_v2   dito
   ```
   Der Kopfkommentar (`:150-176`) sagt es selbst: *"Seit B14-NB3 sind BEIDE Seiten abgeleitet"*,
   inkl. Byte-Neutralitaets-Beweis am Achsen-Default (64 -> 16384*64 = 1048576, unveraendert) und
   einem bewussten Entscheid zum gesenkten Alignment bei B32.
2. **Der `line_size`-Block der golden-XML ist heute INERT.** `Code/test_data_xml/experiment_golden_kern.xml`
   deklariert `<line_size>32/64/128/256</line_size>` -- aber `grep -rn "organ_subaxes"` ueber das
   gesamte ce-Repo liefert **0 Treffer**. Die XML sagt es selbst (Z. ~303-306):
   > "HEUTE DEKLARATIV: parse_experiment_profile liest <organ_subaxes> noch nicht (unbekannte
   > Wurzel-Kinder werden still ignoriert) - ... Bis dahin ist der Block wirkungslos und die
   > Bau-Matrix unveraendert."

**Konsequenz:** Der Trigger baut heute `line_size = 64` und laeuft **nicht** in den OOB. Der
verbleibende KF-6-Bau-Teil ist der **NTTP-Codegen** (`cacheline_line_bytes.hpp:17`: *"weil der
Codegen die per-Organ-Config noch nicht als NTTP emittiert. Sobald KF-6 das ..."*) -- ein
**NACH-Abgabe-Posten**, kein Trigger-Blocker.
**AUFLAGE:** dieser Zusammenhang muss ins Ledger, sonst liest die naechste Runde die
Registerzeile als offenen Blocker und baut ihn unter Zeitdruck.

## 1.9 Die Register-Baender, verdichtet (Quelle 9 + Korrekturen B-1..B-17 + Nachtraege)

### P0 (Neuanker-Kette)
| Posten | Status |
|---|---|
| T2-Welle / L1-Buendel-Landung | **GELANDET** (`86be2420`) |
| **TP1+4+1** (Neun-Gates-Inventur + V7.4-4+1-Beweise, EINMALIGER Re-Lauf nach L1) **+ E2E-`.rsp`-Beweis** (Defines literal im realen Tier-Bau; loest flottenweite Neubau-Welle aus) | **OFFEN**, war auf L1 gated -- L1 ist gefallen, der Re-Lauf ist faellig |
| **Stempel-/RF-Rest-Verifikation** (G2/#36-Rest; RF-1/2/6/7/8; C-3a/C-3b Sec.69.9/70.9) + **O-2-Schliessungs-Vermerk** (Preimage C1+C6 = Option A, in Format-3-Gliedern [5]/[6] aufgegangen; Ratifikation im L1-Lande-Text) | **OFFEN-UNGEPRUEFT** -- kein individueller Schliessbeleg; Register-Auflage: ultracode-Gegenpruefung IM L1-Fenster, nicht spaeter |
| **Atlas-Nachzug nach L1** (05b-UML-Klassenatlas REV 5, Stand `98eea2e7` = VOR W5/W3+Neuanker) mit Korpus-Gegenpruefung; auch die ce-Kopie (`be4f0a16`) | **OFFEN**, war auf L1 gated |

### P1
| Posten | Status |
|---|---|
| P92 | **GELANDET** (`8065aec0`) |
| **B13 L18-ETA / headless-CLI** | **OFFEN.** Bau mit NEUEM Branch ab dev; Pflicht-Schritt 1 = Re-Anker-Pass aller W5-Zeilen-Anker (wt-b13-eta wurde vormittag-11 abgebaut -- heute selbst bestaetigt: existiert nicht) |
| B14 GOLDEN-XML + Sync-Gate-Umhaengung | **GELANDET** (`4b1cd5e3`) |
| KF-6 Bau-Teil | **OOB-Anteil GELANDET** (1.8); **NTTP-Codegen OFFEN -> nach Abgabe** |
| **DELTA C golden-XML `system_axes`** (atomic128/target_isa fehlen im system_axes-Block) | **OFFEN** -- billigstes Fenster war die B14-Landung; **verpasst, jetzt eigene Zeile** |

### P2 (Messwert-Lager, laut Leitplanke 4 "VOR Messbeginn Pflicht")
| Posten | Status |
|---|---|
| **P2-P8-Schema** (WIDE-Mess-Schema: Katalog-Quelle in A8-S3-Backups lokalisieren + Schema-Delta beziffern -> dann ce-Bau-Anteil) | **OFFEN** -- der READ-ONLY-Anteil war "SOFORT frei", ist nicht gemeldet erledigt |
| **A1-Scheibe Wurf-Vertrag** (Posten 71/72/73/74) | **in Landung** (1.3) |
| **Lager-Kaskaden + xlsx-GERUEST** (B12-Geruest; Owner-KERN xlsx=DEFAULT, Strategy CSV XOR xlsx) | **OFFEN** -- Geruest ist Pflicht VOR Messbeginn, Fuellung -> P4 |
| **B5 Mess-Schnitt-Fenster** (T6-Einsammel-Naht + Posten-68 Option B Doppelzaehlungsregel) | **OFFEN** (Entscheid gefallen, Bau offen). Namenskollision: B5 != B-5-Lebend-Check |
| **#46b-Restumfang** (G3-Rest: XML-Bestandslog-Persistenz, avg_size-Log, Gleichverteilung/Takeover) | **OFFEN-UNGEPRUEFT**, Restumfang unbeziffert |
| **G-E3-Host-Binder** (3 `mess_bestand_*`-cfg-Felder mit 0 Konsumenten) | **OFFEN-UNGEPRUEFT** -- **haengt direkt an i-6** (das zweite Gate `mess_bestandslog_active`, 1.5) |
| **Posten-77/78-Auflagen** (kReal16-Doku + Pin-Wache; XorFilter-FN-Einschraenkungs-Doku inkl. Thesis-/Messbild, PFLICHT) | **OFFEN** |

### P3 (Trigger / Voll-Bau / Phase 6)
| Posten | Status |
|---|---|
| **Trigger + Voll-Bau-4** mit **BINDENDER Checkliste**: 7-Auflagen-Satz LEDGER:98 woertlich . gruene Emission ALLER W-Wellen . J-Hygiene L2 . D-10-Eichung L11 . aktiver Bestandslog-Provider + P11-Env-Check | **OFFEN** |
| **Kalibrier-Stichprobe Trigger-Laufzeit** (NEU, FAHRPLAN Abschn. 3 -- "ein Vor-Trigger-Posten, der bisher in keiner Liste steht") | **OFFEN** |
| **B9 P11-Pre-Flight + Phasen 3-5 ausfalten** (aus P4 nach P3 umklassiert, B-2) | **OFFEN, VOR Trigger** |
| **Forecast-Platzpflege + df-Wache** (prod1 60G frei/75%, prod2 141G; offen: Infra-Lane builds_dir/cache_dir-Umzug + Cleaner + `FF_USE_LEGACY_S3_CACHE_ADAPTER=false`-Test; df-Wache beider Maschinen WAEHREND Voll-Bau) | **OFFEN** |
| **OD-7 Runner-Zahlen** -- **einzige bekannte aktive Abweichung von einer Owner-Direktive**: SOLL normal 2/2 + heavy prod1 24 Worker, IST normal 3/2 + heavy auf 16 Kerne gekappt | **OFFEN, vor Voll-Bau klaeren** |
| **E8 PMC-Beleg-Form** (reicht Permutations-A/B je Achsen-Thema?) | **OFFEN-UNGEPRUEFT, vor Trigger klaeren** |
| **Ebene-B-Push-Aktivierung** (G4/P-A; MinIO-Push der Voll-Bau-Binaries ist INERT) | **OFFEN-UNGEPRUEFT** |
| **Lager-Gate G1** (#27 B/C/D + amd24) | **OFFEN-UNGEPRUEFT** |
| **V-06-Rest ETA-Erst-Batch-Abnahme** (t/TU + Bytes/DLL des ERSTEN Mini-Batches gegen den Plattenstand abnehmen, Abbruch-/Herabstufungs-Entscheid) | **OFFEN** -- gehoert in dieselbe Checkliste wie die Kalibrier-Stichprobe |
| **V-05-Rest #162** (>= 8 Rang-1-SOTA-Lebewesen im Katalog-Pfad; Zaehl-/Vollzugsbeleg) | **OFFEN (HELD)** -- vor Messauswertung Vollzug ODER ausdrueckliche Herabstufung |
| **V-17 planer_block-Reaper** (verfallene Reservierungen ohne Reaper koennten Messlaeufe beruehren) | **OFFEN (klein-mittel)** -- vor Messbeginn kurz bewerten, sonst nach Abgabe |
| **Posten 89 T6-Rebound-Leaf-Einpreisung** (HOCH/zeitkritisch): seit Phase B materialisiert fremde T6-Wahl den Rebound-Leaf statt der Fassade -> Allokationszahlen steigen exakt um den Organ-Anteil; MUSS beim ERSTEN Vergleich gegen Alt-Mess-CSV eingepreist werden | **OFFEN** -- sonst Falsch-Regressions-Lesung |
| **Phase 6 = USER-GO-STOPP** | **Gate by design** |

### P4 (nach Trigger)
honest-empty **GELANDET** . Graph 2D/3D **GELANDET** . **B-5-Lebend-Check** (Voll-Korpus, war auf
honest-empty gated -- **jetzt frei**) . **E-18-Aktivierung** (Rest-Gate nur noch B-5-Lebend-Check +
Opt-in-Var; R2-Zielbranch ist ENTSCHIEDEN = `development`) . **E18-SNAP-NB3** . **B12-Fuellung** .
**1xN-/Nx1-Matrix-Fatal im `diagram_generator`** (Bestandsfehler) . B2 E-04-Vollausbau .
B3 OS-U4/A14-Rest + Z-04-Tests . **B4 A4-12-Perm-Paket + FS1-Testschuld** (Terminrisiko: Auflage
"spaetestens vor Messung" gegen P4-Einordnung) . B8 (nur noch Zitat-Drift-/Referenz-Heilung) .
**B11 Posten 19 stale `build/`** (Vorsicht: `build/` enthaelt getrackte Mess-CSV).

### VOR-ABGABE
- **OD-2-Wrapper-Vollform + OD-1-telemetry-Dual-Zeile**: reiner ultracode-PRUEFPASS, kein Bau
  (R-G-Anteil ist ERLEDIGT-belegt).
- **V-02-Rest Mess-Manifest/Provenance**: die Abgabe-CSV/PDF-Strecke muss ihre Herkunft belegen
  (Provenienz-Log + PMC-Beleg-Form) -- anzuschliessen an die P3-Trigger-Checkliste und an E8.
- **V-08-Rest Anhang-A-Limitierung 1**: `anhang/de/A_measurements.tex:11-12` (EN `:10-11`) sagt
  heute "Cache-Misses L1--L3 derzeit 0/nicht erhoben, vgl. Limitierung 1". **Sobald die Messung
  reale PMC-Werte liefert, MUSS dieser Satz DE+EN nachgezogen werden** -- sonst steht eine
  widerlegte Limitierung in der Abgabe. **Direkte Kopplung an O-A und an 1.4.1.**
- **V-19 STRITTIG-Vermerke D5/D6/D7** (Posten-30-Tempdir, W12-B Cache-Key-Spiegelung,
  #18 Goldener Coverage-Test) -- reine Doku-Vermerke.
- **V-14 A16 Posten-Register-Basis** ((2)-(18) + (25)-(29) leben nur in Session-Docs) --
  Voraussetzung der bindenden Nach-Abgabe-Kette.
- **DoD-7-Vollzugsstand Planer-Kette**: GEGENZEICHNEN statt neu auditieren (billig).

### OWNER-FENSTER
| ID | Frage |
|---|---|
| **O-A** | **PMC-Flag im Voll-Mess-Pfad: fixen und neu messen, oder ohne Zaehler messen und die Grenze benennen?** Plus die drei Teilfragen aus 1.4.2. **Entscheiden BEVOR Phase 6 startet -- danach ist es irreversibel** |
| **O-B** | `allow_failure: true` am Mess-Batch: bleibt oder wird hart? (mit O-A) |
| **O-C** | Faehrt der Trigger-Lauf mit gesetztem `COMDARE_BESTANDSLOG`? (nicht am Repo entscheidbar -- Runner-Env/GitLab-Variablen/Aufrufskript) |
| **O-D** | `xmllint` auf prod1/prod2: nachinstallieren (`libxml2-utils`, braucht Cluster-Schreibrecht -- Doktrin sagt read-only) oder die 5 Fixture-Wachen fuer den Abgabe-Lauf herausnehmen (waere ein stiller Skip)? |
| **O-E** | `target_isa.numa_node`/`.page`: anschliessen oder als *declared-inert* ausweisen? |
| **O-F** | 234-V-b Shaped-Emission: anschliessen oder dokumentieren? |
| **~~O-G~~** | ~~`main`-FF beide Repos~~ -- **VOLLZOGEN, gegenstandslos** |
| **~~O-H~~** | ~~13 dreckige Submodul-Dateien~~ -- **gegenstandslos**, die Arbeitskopie ist sauber |
| **O-1 Mess-GO** | = Phase-6-USER-GO-STOPP |
| **O-3 Loesch-GO** | Lokal->0-Rueckbau/Pruning + Alt-Bestands-Loeschungen NUR mit explizitem Owner-GO (Nachfolger des supersedeten Lager-Gates G5) |
| **O-4 Anhang-A-Reichweite** | Sollen M-8 (Sensitivitaets-/Varianz-Attribution), M-9 (vier Heuristik-Kurven) und M-15 (Welch-Konsument) NOCH in die Abgabe? Default-Vorschlag: NACH-ABGABE |
| **O-Token** | **776 Runner-Token in `refs/backup/pre-secret-scrub-20260802` (= `5ba3d03f`, heute auf super origin bestaetigt).** Loeschung einer Remote-Ref braucht **explizite Owner-Autorisierung** (Memory `feedback_remote_deletion_requires_explicit_user_authorization`) |
| **V-11 #327 PAT-Rotation** | terminiert: **nach dem Messfenster**, Handout liegt |
| **Map-Gattungs-Kern-Reichweite** | Zaehlen SA-Zusatz-Subinterfaces zum Map-Gattungs-Kern? |
| **Host-Belegung `batch_plan_datei`** | **Empfehlung liegt und ist REVIDIERT: NICHT vor der Abgabe** (1.10) |

### PHASE-6
**E7 Multi-Thread-Messflaeche** (Multi-Thread gegen 1-Thread-Kanon; Default 1-Thread bleibt bis dahin).

### NACH-ABGABE (die bindende Kette + die Sammelzeilen)
`R3-Rest CLI-Haertung` -> `#35-.so-Schnitt` -> `#54-Endform-XML (Option b)` -> `W3-Vollausbau` ->
`W2-Codegen-Zielform + W-11 Cache-Key-Einfaltung` -> `K1-K4-XML-Rueckfragen` -> `Posten-Register`.
Dazu: Planer-Takt-Vollausbau (R6) . **Versionierungs-Interface Stempel (F7 = Option b)** .
Key-/Value-Filter-Achsen (A5) + Posten-60-Umzug . Overlay-Fenster (3 Festlegungen +
Glied-[7]-Scharfschaltung) . E10 Container-Varianten (entschaerft) . V-07 #47 COMPARE-Modus .
V-09 Hybrid-Bau + PL-19/PL-21 Gattungs-Docks . V-10 L21-Phase-6.5-Behaelter .
V-12 #274/G5 measurement-all-Modul-Migration . V-15 A17 ce-Doku-Nachzuege .
V-16 A25-Kleinposten (8) . V-18-Rest A23/A24 . **V-20 Paragraf-55-Sammelzeile** (F12iii, F2, OF-1
Beschleuniger-Array/Q2, Paragraf-26-L5, K-17, S-7 Locking, #179, #185, #225, #226, #276, #270a/b,
#204, avx512, #266, #254, Paragraf-38-Rest, PhasenCheck-5.16-Rest, Datensatz-Katalog 6-vs-48,
B12-alt/F-SPREAD) . **V-03-Rest Stufe-3-Umzugs-Auflage** (un-included Alt-Kapitel tragen
"neunzehn Achsen"/T0--T18 als geltende Aussage -- bei jedem Umzug auf 18/T0--T17 bringen oder als
historische Vorstufe kennzeichnen) . SF-1 anatomy->builder-Aufwaertskante . SHORTCUT-R1 T6-Peak .
E4+E14 Registry-Erweiterungen (eigenes golden-Neuanker-Fenster) . Writer-Backend io_uring .
Tools-Lagerhaltung #32 . K5 Template-Parametrisierung . **Sec.75-Abschluss-Aufraeumpass** (EIN
Paket, ultracode VOR+NACH) mit der fortgeschriebenen Kandidatenliste:

> (1) leere 3D-caption . (2) 1xN-Matrix-Bestandsfehler . (3) Posten 86 Kosmetik .
> (4) Posten 73 cacheline-Default-Literal . (5) A8-S6 17 stale-Kommentar-Stellen .
> (6) Posten 45 stale-17er-Spuren . (7) M1-M3 der Teil-2-Review .
> (8) honest-0-Musterfortsetzung auf kuenftige Writer/Graph-Umbauten .
> (9) **`axis_inventory.tex` wird geschrieben (`08_appendix_generator/appendix_generator.cpp:423`),
> aber von KEINER `.tex` eingebunden** -- dieselbe Luecken-Klasse wie Gate 8, nur aelter .
> (10) referenzlose `using SearchAlgo`-Aliase `abi_adapter.hpp:440/:545`

Plus: Posten 84 Observer-Copy-Semantik . Posten 85 h81-Wachen-Haertung . Posten 87 organ_hull_
Level-2 . Apple-Clang-Vendor-Kollision . `kDetectedCompilerIsKnown`-static_assert .
#221-Rest T8 thread_count . **`present_`-Gate fuer die `offen > 0`-Abschneidung + Verfeinerung der
Formwache (Atom statt plan-global)** -- beide laut Ledger nachmittag-10 F nach der Abgabe,
zusammen mit Option 2 der Plan-Ablage.

## 1.10 Host-Belegung `batch_plan_datei` -- die REVIDIERTE Empfehlung gewinnt

Die aeltere Fassung des Plans empfahl das Scharfstellen vor der Abgabe **unter der Bedingung**
"nur wenn die Pass-Zahl 1 ergibt". Die juengere Fassung desselben Dokuments (Abschn. 3.3.1 / 5.1)
kehrt das um, weil die Zahl gemessen wurde:

> "**REVIDIERTE EMPFEHLUNG: die Host-Belegung NICHT vor der Abgabe scharf stellen.** Sie waere
> korrekt gebaut und trotzdem wirkungslos ... Die Bedingung meiner urspruenglichen Ja-Empfehlung
> war "nur wenn die Pass-Zahl 1 ergibt"; sie ist **18**."

**Selbst nachgemessen, ohne Bau und ohne Beruehrung des Mess-GO-Stopps:**
`grep -c "<axis_sweep " all_axes_golden.profile.xml` = **17** -> `profile_sweep_passes`
(`profile_runner.hpp:283-291`) liefert 1 Basis-Pass + 17 = **18**.
Verteilung ueber **alle 11** Thesis-Profile (Korrektur: der Plan spricht von "sechs"):
`all_axes_golden` / `m3_golden_coverage` / `m3_smoke_coverage` je 17 . `m3v2_sota_pilot` /
`m3v2_study` je 8 . `m3v2_smoke` 2 . `base_pilot`, `cacheline_study`, `fb_numa_page_study`,
`ff2_node_width_study`, `wdk_fairness_example` je 0.
Verschaerfend (Plan 3.3.1): der Basis-Pass traegt die 2^17-Arbeit
(`profile_run_entry.hpp:762`, `golden_range_count > 0 && pass_axis.empty()`) und laeuft **immer
zuerst** -- seine Plan-Datei wird von 17 folgenden Sweep-Paessen ueberschrieben.
**`batch_plan_korn` gehoert NICHT in diese Welle** (nur `LazyRunConfig::batch_plan_korn` +
`plan_slice_korn` existieren; ein per-Env gesetztes Korn, das im Mess-Lauf vergessen wird, baut
die gerade geheilte Divergenz wieder ein).

**Praezisierung an einer Zahl des Plans:** die Kernaussage `grep -rn "batch_plan_datei"` ueber
super `Code/` = "0 Treffer" ist als Beleg **ungenau** -- gemessen sind **0 ausserhalb
`Code/external`**, aber **37 einschliesslich** (die Kette ist in ce vollstaendig verdrahtet:
`profile_run_facade.hpp:128` -> `profile_run_entry.hpp:182/659` ->
`cache_engine_builder_iterator.hpp:243`). Die **Sachaussage haelt** (der super-Host belegt das
Feld nicht), die Zahl als Beleg nicht.

---

# TEIL 2 -- DER DISJUNKTHEITS-BEWEIS

## 2.0 Vorbemerkung: die Obergrenze der Parallelitaet ist NICHT die Dateimenge

Bevor ein Beweis gefuehrt wird, muss die harte Grenze benannt sein. Sie steht in
`docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md`, Leitplanke 1 und 2 (verbatim):

> "1. CPU: max EIN ce-Voll-Gate (-j6 nice, 2-Pass-Configure, Doppellauf 2x seriell) + max EIN
> super-Slot (-j3 nice); ohne Voll-Gate max zwei -j3.
> 2. Landebahn: EIN Koordinator (Lead), Landungen streng seriell, jeder Merge genau einmal; vor
> Landung Merge dev->Branch (nie rebase) + Dual-Review + Voll-Gate + Pipeline hart gruen + Backup
> + Ledger."

**Daraus folgt die Kapazitaets-Tabelle, die jede Wellen-Einteilung binden muss:**

| Bahn | Anzahl gleichzeitig | Begruendung |
|---|---|---|
| ce-Voll-Gate (Bau + 2-Pass-Configure + Doppellauf) | **1** | Leitplanke 1 |
| super-Slot (Bau) | **1** | Leitplanke 1 |
| Landebahn (Merge + Push + Bump + FF) | **1** | Leitplanke 2 |
| READ-ONLY / Doku / Analyse (kein Bau, kein Schreiben in einen Bau-Baum) | **n** | keine Ressource |

**Ehrlich gesagt: mehr als "1 ce + 1 super + n read-only" ist nicht parallelisierbar, egal wie
disjunkt die Dateimengen sind.** Alles Weitere ist Warteschlange. Der Gewinn dieses Dokuments
liegt darin, die richtigen Posten in die drei Bahnen zu legen und die Warteschlange so zu
sortieren, dass kein Slot leerlaeuft.

## 2.1 Die Arbeitspakete und ihre Dateimengen (am Objekt erhoben)

Definition: `D(X)` = Menge der Pfade, die Paket X **schreibt**. Lesende Beruehrungen sind
gesondert vermerkt, weil sie fuer die Ein-Schreiber-Regel unschaedlich, fuer die
Reihenfolge aber relevant sind.

### P-A1 -- A1-Landung (ce)
```
D(P-A1) = {
  libs/cache_engine/axes/alloc/axis_06_allocator_*.hpp            (26 Strategien)
  libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp
  libs/cache_engine/axes/alloc/concepts/axis_06_allocator_concept.hpp
  libs/cache_engine/axes/cacheline/node_width_config.hpp
  libs/cache_engine/axes/node/axis_04_node_type_layout_aware_store.hpp
  libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp
  tests/unit/CMakeLists.txt                                        <-- HOTSPOT
  tests/unit/test_a1_wurf_vertrag_allokator_store.cpp
  tests/unit/test_a1_algo_version_pin_alloc_axis.cpp
  tests/unit/test_e24_c3_cross_genus.cpp
  tests/unit/test_reflect_versions_all_registered.cpp
}
```
Gemessen: 37 Dateien committet (`diff --name-only development...fdfa68ee`), 32 uncommitted im
Worktree. Schreibregion in `tests/unit/CMakeLists.txt` (Diff selbst gelesen): **Z. ~2012-2019**
(Eintrag in `COMDARE_PHASE_E_BOOST_TESTS`) und **Z. ~4748-4784** (neuer `comdare_add_test`-Block).

### P-XXE -- T-i-1 XXE-/Entity-Bissbeweis (super)
```
D(P-XXE) = {
  Code/tests/CMakeLists.txt                                        <-- HOTSPOT (super)
  Code/tests/<neu>_entity_bite_check.cmake                         (neu)
  Code/tests/fixtures/<neu>/*.xml                                  (neu, 2 Fixtures)
}
liest (schreibt NICHT): Code/tests/xml_canonical_utils.cmake
```
Belege: die Bauart ist im Baum vorhanden -- `add_test(NAME ... COMMAND ${CMAKE_COMMAND} -P
<check>.cmake)` (`Code/tests/CMakeLists.txt:~209-221`), `Code/tests/fixtures/` existiert,
`comdare_xml_require_tool` / die Entity-Sperre stehen in `xml_canonical_utils.cmake:76-95 ff`.

### P-LOCK -- T-i-2 Mutationsprobe `contract:axis-version-lock` (ce)
Zwei Bauformen, beide disjunkt-tauglich, aber unterschiedlich:
```
Form A (Skript-Weg, EMPFOHLEN -- vermeidet den Hotspot):
D(P-LOCK-A) = {
  scripts/ci_axis_lock_bite.sh                                     (neu)
  .gitlab-ci.yml (ce)                                              (Aufruf im vorhandenen Job)
}
liest: tools/axis_version_lock/axis_version.lock,
       libs/cache_engine/heuristik/{axis_spline,break_even,measurement_curve_loader}.hpp

Form B (Unit-Test-Weg):
D(P-LOCK-B) = {
  tools/axis_version_lock/*
  tests/unit/<neu>.cpp
  tests/unit/CMakeLists.txt                                        <-- HOTSPOT-KOLLISION mit P-A1
}
```

### P-PMC -- i-1 + i-2 + i-3, die PMC-Welle (ce), gated auf O-A/O-B
```
D(P-PMC) = {
  libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp   (Z. 841/877/1194/1373/1342/1352-1364; 1373=allow_failure gemessen ce-HEAD 54106bc9, uebrige Anker nicht nachgemessen)
  tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp                              (Z. 71 + Preflight-Ort)
  tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp                        (Z. 58-63, zweiter Modus)
  tests/unit/thesis_tiere/test_experiment_plan_director.cpp               (Biss auf die emittierte YAML)
}
KEIN tests/unit/CMakeLists.txt noetig -- selbst geprueft:
  m3v2_pmc_smoke        ist registriert  (CMakeLists.txt:2933-2950, LABELS "phase_e;standalone;pmc")
  test_experiment_plan_director ist registriert (CMakeLists.txt:3431-3454, LABELS "contract;profiles;e4;planner")
```

### P-BEST -- i-5 + i-6, BESTANDSLOG-Scharfschaltung (ce), gated auf O-C
```
D(P-BEST) = {
  libs/cache_engine/profile_facade/profile_run_entry.hpp                       (Z. 435 Gate umkehren)
  libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp  (Z. 1658-1660 UND 1665-1668)
  libs/cache_engine/builder/build_orchestrator.hpp                             (Kette)
  tests/unit/<Biss-Tests>
}
```

### P-DASH -- die `--`-Kommentar-Heilung (ce) + Entfernung des Escape-Hatch (super)
```
D(P-DASH-ce)    = { libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml }  (2 Kommentarzeilen)
D(P-DASH-super) = { Code/tests/CMakeLists.txt }                                <-- HOTSPOT (super)
```
Beleg heute selbst gefahren: `xmllint --noout all_axes_golden.profile.xml` -> **"Double hyphen
within comment"** an **Z. 62 und Z. 64**. Der super-Test umgeht das mit
`-DPROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON` und traegt die Auflage im Klartext:
> "ce-AUFLAGE: '--' in den drei Kommentaren beseitigen, danach diese Zeile ENTFERNEN."
Die Verriegelung ist beidseitig gebaut ("sie wird FATAL, sobald die ce-Datei roh wohlgeformt ist"),
also **muss die super-Zeile im selben Zug fallen wie der ce-Fix -- sonst wird der Test rot.**

### P-KAL -- Kalibrier-Stichprobe Trigger-Laufzeit
```
D(P-KAL) = { }  (kein Quellcode -- ein Bau-Lauf mit Zeitmessung, Ergebnis in Ledger/Owner-Vorlage)
Verbraucht: EINEN vollen Bau-Slot.
```

### P-DOC -- Sicherung, Owner-Vorlage, Ledger
```
D(P-DOC) = {
  docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md      (?? -> committen)
  docs/plaene/20260806-PLAN-versionierungs-interface-stempel.md       (?? -> committen)
  docs/sessions/20260806-ANKLAGE-kostenklammern-plan-diff.md          (?? -> committen)
  docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md              (?? -> committen)
  docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md (dieses Dokument)
  docs/sessions/<neu>-OWNER-VORLAGE-....md
  docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md                     <-- HOTSPOT (Einzelschreiber)
}
```

### P-P2P8 -- P2-P8-Katalog-Klaerung (READ-ONLY-Anteil)
```
D(P-P2P8-lesen) = { }   (Katalog-Quelle in A8-S3-Backups lokalisieren + Schema-Delta beziffern)
```
Im Fahrplan ausdruecklich: "**READ-ONLY (frei, sofort)**".

### P-PRUEF -- die reinen ultracode-Pruefpaesse (kein Bau, kein Schreiben ausser Doku)
```
Stempel-/RF-Rest-Verifikation . OD-2/OD-1-Pruefpass . DoD-7-Gegenzeichnung .
E8-PMC-Beleg-Form . OD-7-Runner-Ist-Live-Check . V-05-#162-Zaehlbeleg
D(P-PRUEF) = { docs/... }  (nur Doku, und die faellt unter den Ledger-Einzelschreiber)
```

## 2.2 (a) DATEI-DISJUNKTHEIT -- die Mengen, explizit geschnitten

### Schnitt-Matrix der Bau-Pakete (leere Menge = disjunkt)

| | P-A1 | P-XXE | P-LOCK-A | P-PMC | P-BEST | P-DASH-ce | P-DASH-super |
|---|---|---|---|---|---|---|---|
| **P-A1** | -- | **{}** | **{}** | **{}** | **{}** | **{}** | **{}** |
| **P-XXE** | {} | -- | **{}** | **{}** | **{}** | **{}** | **{`Code/tests/CMakeLists.txt`}** |
| **P-LOCK-A** | {} | {} | -- | **{}** | **{}** | **{}** | **{}** |
| **P-PMC** | {} | {} | {} | -- | **{}** | **{}** | **{}** |
| **P-BEST** | {} | {} | {} | {} | -- | **{}** | **{}** |
| **P-DASH-ce** | {} | {} | {} | {} | {} | -- | **{}** |

**Die Schnitte im Einzelnen, nicht behauptet, sondern aufgeschrieben:**

- `D(P-A1) SCHNITT D(P-PMC)`: A1 schreibt ausschliesslich unter `libs/cache_engine/axes/`,
  `libs/cache_engine/builder/experiment_tree/axis_variant_version_table.hpp` und
  `tests/unit/{CMakeLists.txt, test_a1_*, test_e24_c3_cross_genus.cpp,
  test_reflect_versions_all_registered.cpp}`. P-PMC schreibt ausschliesslich unter
  `libs/cache_engine/profile_facade/planner/` und `tests/unit/thesis_tiere/`.
  **Kein Pfad in beiden.** Insbesondere braucht P-PMC `tests/unit/CMakeLists.txt` **nicht** --
  am Objekt geprueft (beide Zieltargets sind bereits registriert, s. 2.1). **DISJUNKT.**
- `D(P-A1) SCHNITT D(P-LOCK-A)`: P-LOCK-A schreibt `scripts/ci_axis_lock_bite.sh` und `.gitlab-ci.yml`.
  A1 schreibt weder `scripts/` noch YAML. **DISJUNKT.**
  *(Warnung: `D(P-A1) SCHNITT D(P-LOCK-B)` = `{tests/unit/CMakeLists.txt}` -- **NICHT disjunkt**. Wenn
  Form B gewaehlt wird, ist P-LOCK zu serialisieren, nicht zu parallelisieren.)*
- `D(P-A1) SCHNITT D(P-BEST)`: P-BEST schreibt `profile_facade/profile_run_entry.hpp`,
  `builder/experiment_tree/cache_engine_builder_iterator.hpp`, `builder/build_orchestrator.hpp`.
  A1 schreibt in `builder/experiment_tree/` ausschliesslich `axis_variant_version_table.hpp`.
  **Verschiedene Dateien im selben Verzeichnis -- disjunkt auf Pfadebene. DISJUNKT.**
- `D(P-PMC) SCHNITT D(P-BEST)`: `experiment_plan_director.hpp` gegen
  `profile_run_entry.hpp` / `cache_engine_builder_iterator.hpp` / `build_orchestrator.hpp`.
  **DISJUNKT auf Dateiebene** -- aber **NICHT reihenfolge-frei** (s. 2.4).
- `D(P-XXE) SCHNITT D(alle ce-Pakete)`: **anderes Repository.** Die einzige Bruecke ist der
  Submodul-Gitlink, den nur die Landebahn schreibt. **DISJUNKT.**
- `D(P-XXE) SCHNITT D(P-DASH-super)` = **{`Code/tests/CMakeLists.txt`}** -- **NICHT DISJUNKT.**
  Beide schreiben dieselbe 238-Zeilen-Datei. **Konsequenz: EIN Schreiber, EINE Bahn, zwei
  Commits nacheinander.** Nicht parallelisieren.

### Die Dateien, die "alle anfassen wollen" -- namentlich geregelt

| Hotspot | Groesse | Wer will schreiben | Regel |
|---|---|---|---|
| **`ce tests/unit/CMakeLists.txt`** | 5193 Z. | P-A1 (aktiv), P-LOCK-B (falls gewaehlt), jeder neue ce-Unit-Test | **EIN SCHREIBER: P-A1, bis A1 gelandet ist.** Wer in diesem Fenster einen ce-Unit-Test braucht, waehlt entweder ein bereits registriertes Target (wie P-PMC es tut) oder den Skript-Weg (wie P-LOCK-A) -- oder wartet. |
| **`super Code/tests/CMakeLists.txt`** | 238 Z. | P-XXE, P-DASH-super | **EIN SCHREIBER je Zeitfenster: erst P-XXE, dann P-DASH-super.** |
| **`ce .gitlab-ci.yml`** | -- | P-LOCK-A | **exklusiv P-LOCK-A.** P-PMC schreibt **nicht** diese Datei, sondern den Emitter (`experiment_plan_director.hpp`), der eine *andere* YAML erzeugt. Der Unterschied ist entscheidend und wird oft verwechselt. |
| **`super .gitlab-ci.yml`** | 90.532 B | niemand in diesem Fenster (E18-SNAPs `gitlab-ci-delta.patch` liegt unangewandt und bleibt es) | **gesperrt bis nach dem Trigger.** |
| **Registry-XMLs / `experiment_golden_kern.xml` / `all_axes_golden.profile.xml`** | -- | P-DASH-ce (2 Kommentarzeilen); DELTA-C-Posten (system_axes) | **P-DASH-ce exklusiv.** Der DELTA-C-Posten (atomic128/target_isa im system_axes-Block) beruehrt `experiment_golden_kern.xml` und ist damit **eine andere Datei** -- disjunkt, aber beide sind golden-Anker: **beide nur mit Voll-Gate.** |
| **`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`** | append-only, waechst | jede Welle am Ende | **EIN SCHREIBER, immer der Lead, immer nach der Landung.** Das Ledger ist append-only -- zwei gleichzeitige Nachtraege kollidieren garantiert am Dateiende. |

## 2.3 (b) WORKTREE-DISJUNKTHEIT

Heute selbst gemessen, alle 15 Baeume:

| Worktree | Branch | HEAD | dirty | Zuweisung |
|---|---|---|---|---|
| `/home/comdare/wt-b-a1` | `b-a1-wurf-vertrag` | `fdfa68ee` | **32** | **P-A1 -- EXKLUSIV, aktiver Schreiber. KEIN zweiter Agent, kein `reset --hard`, kein `checkout`.** |
| `/home/comdare/wt-b14-ce` | `b14-ce-anteil` | `cc20b63d` | 0 | frei (gelandet) -- **Kandidat fuer P-LOCK-A / P-PMC**, wenn ein zweiter ce-Baum gebraucht wird |
| `/home/comdare/wt-b2-neuanker` | `b2-neuanker-format3` | `b6d87c08` | 0 | frei (gelandet) |
| `/home/comdare/wt-b-r4-ci` | `b-r4-ci-abdeckung` | `3133f226` | 0 | frei (gelandet). **Historie: hier gab es einen Fremd-Schreiber (FAHRPLAN R1) -- heute dirty=0** |
| `/home/comdare/wt-b-p92` | `b-p92-registry-kanon` | `8065aec0` | 0 | frei (gelandet) |
| `/home/comdare/wt-b14-golden` | `b14-golden-kf6` | `50dc231b` | 0 | frei (gelandet), super |
| `/home/comdare/wt-b-graph` | `b-graph-2d3d` | `6124c6f7` | 0 | frei (gelandet), super |
| `/home/comdare/wt-b-honest-empty` | `b-honest-empty` | `838612f3` | 0 | frei (gelandet), super |
| `/home/comdare/wt-b-e18-super` | `b1-e18-super-anteil` | `8131a9a2` | 0 | frei (gelandet), super |
| `/home/comdare/wt-b-gate8` | `b-gate8-graph-abbildungen` | `8970465` | 0 | frei (gelandet), thesis |
| `/home/comdare/wt-b-e18snap` | `b-e18-snap` | `5c4cf900` | 0 | **EINGEFROREN** -- NICHT-LANDEN-Verdikt, NB3 nach dem Trigger. Nicht anfassen, nicht abbauen |
| `/home/comdare/wt-landcheck` | (detached/leer) | -- | 0 | Werkzeug-Baum |
| `/home/comdare/wt-w2-E02-prtart`, `.../wt-w2-E02-thesis` | `w2-E02-Ledger` | -- | 0 | Alt-Baeume, nicht in diesem Fenster |
| `/home/comdare/.claude/jobs/5a19728e/tmp/l1_landing` | `l1-super-landung-scratch` | `725ead43` | **8** | **Scratch. Die 8 Dateien sind byte-identisch zu `development` (Erhebung 2, `hash-object` 8/8). Kein Verlust -- aber nicht als Bau-Baum benutzen** |
| Haupt-Checkout `/home/comdare/Projekte/.../probst-diplomarbeit-cache-engine` | `development` | `1b2124e6` | 5 `??` | **LANDEBAHN. Nur der Lead schreibt hier.** |

**BEWEIS der Worktree-Disjunktheit fuer die geplanten Wellen:**
- P-A1 -> `wt-b-a1` (exklusiv, bereits belegt).
- P-PMC -> **eigener neuer ce-Worktree** (`wt-b-pmc`, ab `development`). Nicht `wt-b-a1`.
- P-LOCK-A -> **eigener neuer ce-Worktree** (`wt-b-axislock`) **oder** `wt-b14-ce`
  (gelandet, dirty=0) nach `checkout -B`.
- P-XXE -> **eigener neuer super-Worktree** (`wt-b-xxe`, ab `development`). Nicht der
  Haupt-Checkout, damit die Landebahn frei bleibt.
- P-DASH-ce -> eigener ce-Worktree, **nachdem** P-A1 gelandet ist (Voll-Gate-Slot).
- P-DOC / P-PRUEF / P-P2P8 -> **Haupt-Checkout, read-only** bzw. nur `docs/` -- der Lead.
- P-KAL -> eigener Scratch-Baum, **verbraucht den Bau-Slot**.

**Die zwei Beinahe-Unfaelle von heute, gegen die diese Zuweisung gebaut ist** (Owner-Hinweis
im Auftrag): ein Rennen um den Index und ein Beinahe-`reset --hard` auf fertige Commits.
Die Regel daraus, bindend:

> **AUFLAGE W-1:** Ein Worktree hat genau einen Schreiber. Wer einen fremden Worktree betreten
> muss, misst zuerst `git -C <pfad> status --porcelain` und `git -C <pfad> log --oneline -1` und
> meldet den Fund, bevor er irgendetwas veraendert. `reset --hard`, `checkout -f` und
> `clean` sind in fremden Baeumen verboten.
> **AUFLAGE W-2 (aus Regel 9 des Ledgers):** "Liegt auf origin" beantwortet die Frage "ist es
> gelandet?" nicht -- das tut nur `merge-base --is-ancestor <commit> <zweig>`.

## 2.4 (c) REIHENFOLGE-DISJUNKTHEIT

Hier ist die Datei-Disjunktheit **nicht** hinreichend. Vier Ketten sind bewiesen abhaengig und
gehoeren deshalb in **dieselbe** Bahn, nicht in zwei parallele:

**Kette 1 -- der Bau-Block (Fingerprint-Identitaet).**
Quelle: FAHRPLAN Z. 139-161 (Z3/Z4/Z5). R4 (`AXIS_ALGO_VERSION` 1->2), T2-A (Fingerprint-Neuanker
Format 2->3, 1126 Zeilen in `anatomy_fingerprint.hpp` + `toolchain_stamp_glied.hpp`),
B14-ce (`kCebContractCodegenMinor` 0->1, ABI 8.0->8.1) sind **gelandet**; **A1 fehlt noch** und
aendert 27 Allokator-Dateien + `axis_04...store.hpp` = Achsen-Flaeche im Fingerprint.
> **Folge: A1 ist nicht "optional nachziehbar". Landet A1 nach dem Voll-Bau-4, ist der gesamte
> Bau zu wiederholen.** Deshalb steht A1 in der Kette "vor Trigger", nicht in einer Parallelbahn
> zum Trigger.

**Kette 2 -- PMC vor BESTANDSLOG.**
ANKLAGE, Abhaengigkeitsspalte zu i-5, verbatim: *"**Erst nach i-1..i-4**, weil ein scharfes
Skip-Gate ohne PMC-Fix nur schneller falsch misst."* -> `P-PMC` **vor** `P-BEST`, **eine Bahn**.
Zusaetzlich intern: *"i-1 und i-2 zwingend zusammen landen -- i-1 allein liesse die Wache blind,
i-2 allein blockierte den Lauf"*; und *"i-6 muss mit i-5 in derselben Welle landen -- i-5 allein
schaltet KK-4 scharf."*

**Kette 3 -- ce-`--`-Fix vor super-Escape-Hatch.**
Die super-Wache ist beidseitig verriegelt und wird **FATAL, sobald die ce-Datei roh wohlgeformt
ist**. -> `P-DASH-ce` landen, **dann** Submodul-Bump, **dann** `P-DASH-super`. Eine Bahn, drei
Schritte, keine Parallelitaet.

**Kette 4 -- jede ce-Landung zieht Bump + `main`-FF nach (AUFLAGE T-1, 0.3).**
`ce/development` -> ce-Pipeline gruen -> `ce/main`-FF -> super-Gitlink-Bump -> super-Pipeline gruen.
Fuenf Schritte, streng seriell, ein Koordinator.

**Was NICHT abhaengig ist (und deshalb parallel darf):**
- `P-XXE` braucht kein Ergebnis von `P-A1`, `P-PMC`, `P-LOCK` -- es prueft eine bereits gelandete
  ce-Sperre ueber den super-Testpfad und liest das Submodul nur ueber `COMDARE_CACHE_ENGINE_DIR`.
  **Einzige Bedingung: der Gitlink muss stehen, und er steht (`e7aa1244`).**
- `P-LOCK-A` braucht kein Ergebnis von `P-A1`. Gegenprobe FAHRPLAN Abschn. 0b/B2, von mir
  bestaetigt: **kein offenes Paket beruehrt die drei gelockten Heuristik-Header**
  (`axis_spline.hpp`, `break_even.hpp`, `measurement_curve_loader.hpp`); A1 schreibt sie nicht.
- `P-DOC`, `P-PRUEF`, `P-P2P8` brauchen kein Bau-Ergebnis.
- `P-KAL` braucht keinen bestimmten Quellstand -- gemessen wird **Kompilierzeit je Binary**, nicht
  Identitaet. **Aber es verbraucht einen Bau-Slot** (2.0).

## 2.5 (d) GATE-DISJUNKTHEIT

| Gate / Ressource | Wer schaltet | Kollisionsregel |
|---|---|---|
| `ce/development` Push -> Pipeline | Landebahn | **1 Push je Zeit.** Runner-Ist 3/2 (Memory `reference_runner_concurrency_ist_3_2_stau_ist_backlog`): zwei gleichzeitige Pushes erzeugen Backlog, nicht Parallelitaet |
| `ce/main` FF -> Pipeline | Landebahn | nach `development` gruen, nie davor |
| `super/development` Push -> Pipeline (inkl. `trigger:cache-engine` auf `branch: main`) | Landebahn | **nach** dem ce-`main`-FF, sonst triggert der Bridge-Job den alten ce-Stand |
| `super/main` FF | Landebahn | zuletzt |
| `contract:axis-version-lock` (ce) | **P-LOCK-A exklusiv.** Der Job ist seit `597ecffe`/`557d8023` genau einmal definiert (`:447`) und lief in 15025 gruen. **Wer ihn scharfstellt, riskiert Rot** -- FAHRPLAN R3: nach R4 ist der Tripwire scharf; wer die drei Header anfasst, muss den Lock regenerieren | niemand sonst schaltet dieses Gate |
| `test:coverage-guard` / Abdeckungs-Invariante (ce) | **jeder neue ce-Test verschiebt den Nenner** (heute 407). P-A1 registriert 2 Targets, P-LOCK-B haette 1 registriert, P-PMC registriert **0** | **Nach jeder ce-Landung ist der Nenner neu zu messen.** Zwei gleichzeitige Test-Registrierungen machen ein Rot unzurechenbar |
| `test:unit` (super), Label `da_unit` | **P-XXE** registriert einen fuenften/sechsten `cmake -P`-Test; **P-DASH-super** entfernt eine Wachen-Option | seriell, ein Schreiber (2.2) |
| `xmllint`-Abhaengigkeit (R2) | **UNBELEGT auf prod1/prod2.** 5 super-Tests brechen mit `FATAL_ERROR`, wenn es fehlt (`Code/tests/xml_canonical_utils.cmake:82-90`, registriert als `cmake -P` in `Code/tests/CMakeLists.txt:209-214` -> **Testlaufzeit, nicht Configure: es faerbt 5 Tests rot, es reisst den Bau NICHT ab**). **P-XXE erhoeht diese Zahl um seinen eigenen Test** | **Owner O-D. Vor P-XXE beantworten** oder P-XXE mit derselben SKIP-Disziplin bauen wie die fuenf bestehenden |
| Mess-GO (Phase 6) | **Owner O-1, harter Stopp** | keine Welle schaltet das |
| Remote-Ref-Loeschung (`refs/backup/pre-secret-scrub-20260802`) | **Owner O-Token, explizite Autorisierung** | keine Welle schaltet das |
| Cluster / prod1 / prod2 | **read-only per Doktrin** | `xmllint`-Nachinstallation ist O-D, kein Bau-Posten |

## 2.6 Was NICHT bewiesen werden konnte -- und deshalb serialisiert wird

| Frage | Warum unbewiesen | Konsequenz |
|---|---|---|
| Ist `P-DASH-ce` (2 Kommentarzeilen im `all_axes_golden.profile.xml`) wirkungs-neutral fuer den golden-Anker? | Ich habe keinen Bau gefahren und keinen Fingerprint neu berechnet. Der Parser ignoriert Kommentare -- **das ist eine Annahme ueber den Parser, keine Messung** | **Voll-Gate PFLICHT**, kein "trivialer" Direktcommit |
| Erhoeht `P-XXE` die `xmllint`-Abhaengigkeit auf prod1/prod2? | `xmllint`-Praesenz auf den baremetal-Runnern ist **UNBELEGT** (Datei-eigener Kommentar: *"Die Praesenz auf den baremetal-Runnern ist damit NICHT belegt, sondern eine Annahme"*). Lokal ist `/usr/bin/xmllint` da (libxml 20914) -- das sagt nichts ueber prod | **O-D vor der Landung**, oder derselbe verankerte SKIP-Marker wie bei den fuenf bestehenden Tests |
| Ist `P-LOCK-A` (Form A) wirklich ohne `tests/unit/CMakeLists.txt` baubar? | Ich habe den Skript-Weg **entworfen, nicht gebaut**. Wenn der Biss doch ein Unit-Target braucht, faellt er auf Form B zurueck | **Entscheidung VOR dem Start.** Faellt sie auf Form B, ist P-LOCK **hinter** P-A1 zu serialisieren |
| Laeuft der 131.072-Voll-Lauf tatsaechlich ueber den Emissionszweig `experiment_plan_director.hpp` (und nicht ueber `measure:golden-320`, das das Flag traegt)? | ANKLAGE Abschn. 6.1: *"Ich habe den Planer nicht ausgefuehrt"*; die Stuetzen sind `COMDARE_GN_TOTAL=131072` in der Emission und die Deprecation-Notiz `super .gitlab-ci.yml:665-669`. **Ich habe das ebenfalls nicht ausgefuehrt** | **Vor der PMC-Reparatur am realen Trigger-Rezept gegenpruefen.** Faehrt der Voll-Lauf doch statisch, mildert das KK-1 (die Wache bliebe trotzdem blind) |
| Sind `COMDARE_BESTANDSLOG` / `COMDARE_AXIS_LOCK_CHECK` als GitLab-Projekt-/Gruppen-Variablen gesetzt? | Externe Pipeline-Variablen sind **im Baum nicht sichtbar** (ANKLAGE 6.2). Ich habe die GitLab-API nicht abgefragt | **O-C**; und unabhaengig davon gilt: eine Faehigkeit, deren Aktivierung nicht im Repo steht, ist nicht reproduzierbar |
| Sind die sechs gruenen Pipelines des Abends real? | Aus dem Ledger uebernommen, **nicht von mir am API-Objekt gemessen** | **UNBELEGT-uebernommen.** Vor dem Trigger einmal selbst nachschlagen |
| Trigger-Laufzeit | *"Der Unterschied zwischen 'geht' und 'geht nicht' haengt an einer Zahl, die niemand gemessen hat"* (FAHRPLAN Abschn. 3) | **P-KAL, vor dem Trigger** |
| Runner-Ist HEAVY/NORMAL | Memory sagt 3/2; OD-7-SOLL ist 2/2 + heavy 24 Worker; das Handout notiert den Register-Ist selbst als **stale und unverifiziert** | **Live-Check am Host vor dem Trigger** (FAHRPLAN R9) |

---

# TEIL 3 -- DIE WELLEN

Notation je Gruppe: **Bahn** (welche Ressource) . **Worktree** . **Wer** . **Abnahme-Bedingung**.

## WELLE 0 -- VERLUSTVERMEIDUNG (seriell, ~15 min, KEINE Parallelitaet, vor allem anderen)

| Schritt | Inhalt | Abnahme |
|---|---|---|
| 0.1 | **super `development` pushen** (`1b2124e6`, Ledger nachmittag-10) auf **beide** Remotes | `git ls-remote origin refs/heads/development` == `github` == `1b2124e6` |
| 0.2 | **Die vier unversionierten Plan-Dokumente committen** (Testoffensive, Versionierungs-Interface, ANKLAGE, FAHRPLAN) **plus dieses Dokument** -- mit explizitem Pathspec, nie `git add .` (Regel 8: ein `commit -a` haette heute den Thesis-Zeiger 78 Commits zurueckgedreht) | `git status --porcelain` zeigt keine `??` mehr unter `docs/` |
| 0.3 | **`Code/measure_out_d03/` entscheiden.** Es ist ein echter Mess-Lauf vom 26.07. mit `pmc_available=1` (1.4.1). Memory-Doktrin: **Messdaten nie loeschen**. Optionen: (a) als Rohdaten-Backup additiv sichern, (b) `.gitignore`-Eintrag **mit Begruendungszeile**. **Nicht loeschen, nicht stillschweigend ignorieren** | Der Pfad ist entweder gesichert oder mit begruendetem Ignore-Eintrag versehen; der Fund steht im Ledger |
| 0.4 | **`gitleaks` ueber den Push-Inhalt** mit der Repo-`.gitleaks.toml` (Betriebs-Doktrin nachmittag-9: ohne Konfiguration schlug die Default-Regel auf einen deutschen Fliesstext mit "key" im Testnamen an) | `no leaks found`, literal |

**Warum seriell:** alles hier schreibt den Haupt-Checkout und/oder pusht `development`.
Zwei Schreiber = Index-Rennen.

## WELLE 1 -- MAXIMALE PARALLELITAET (vier Bahnen gleichzeitig)

### Gruppe 1A -- **A1-Landung** (der letzte Stein des Bau-Blocks)
- **Bahn:** ce-Voll-Gate (der einzige). **Worktree:** `/home/comdare/wt-b-a1` (exklusiv, 32 dirty).
- **Inhalt:** Bump-Auflage fertigstellen (24 Strategien `v1.0.2c`, 2 reallocate-lose bleiben
  `v1.0.1c`, Pin-Test je Strategie namentlich) -> cf22 -> 2-Pass-Configure (configure -> **BAU** ->
  configure; ein zweites Configure **vor** dem Bau liefert die zu kleine Zahl, FAHRPLAN R7) ->
  Doppellauf 2x seriell ctest -> Dual-Review (Fable + Codex) -> Landung -> **ce `main`-FF** ->
  **super-Gitlink-Bump** -> super-Pipeline gruen (AUFLAGE T-1).
- **Abnahme:** Merge `development->Branch` (nie rebase) sauber . Voll-Gate gruen . **Abdeckungs-Wache
  neu gemessen** (Nenner steigt von 407 um die neu registrierten Targets; beide Zahlen der
  Bilanzzeile muessen gleich sein) . Dual-Verdikt LANDEBEREIT . Gate-Logs als `.txt` oder
  `git add -f` gesichert (`.gitignore` enthaelt `*.log`, FAHRPLAN R6) . ce/main == ce/development .
  super-Gitlink == ce/development . super-Pipeline gruen.

### Gruppe 1B -- **T-i-1 XXE-/Entity-Bissbeweis**
- **Bahn:** super-Slot (der einzige). **Worktree:** **neu** `wt-b-xxe` ab super `development`.
- **Inhalt:** zwei Fixtures (eine mit `<!DOCTYPE r [<!ENTITY x SYSTEM "file:///...">]>`, eine ohne)
  + ein `cmake -P`-Check in der Bauart von `test_fixture_schema_experiment_golden`; Doppelprobe:
  DOCTYPE-Datei muss `FATAL`, harmlose Datei muss gruen. Faltet den Codex-Posten
  `test_config_durability.cpp:105-122` (das `SUCCEED()`, das nur "kein Crash" beweist) mit ein.
- **Vorbedingung:** **O-D geklaert oder derselbe verankerte SKIP-Marker wie die fuenf bestehenden
  Tests** (`SKIP_REGULAR_EXPRESSION "(^|\n)-- COMDARE-XML-WACHE-SKIP\r?(\n|$)"`, am Objekt
  gelesen). Sonst erzeugt der neue Test einen sechsten `xmllint`-Abhaengigen.
- **Abnahme:** der Test ist **rot ohne** die Sperre und **gruen mit** ihr -- literal beide Laeufe
  ins Gate-Protokoll (das ist der Unterschied zwischen Wache und Testat, ANKLAGE-Regel).
- **Disjunktheit:** anderes Repo als 1A; einziger Beruehrungspunkt `Code/tests/CMakeLists.txt`,
  den in dieser Welle **niemand sonst** schreibt.

### Gruppe 1C -- **T-i-2 Axis-Lock-Mutationsprobe, Form A (Skript-Weg)**
- **Bahn:** ce, **ohne** Voll-Gate (Skript + YAML, kein Compile).
  **Worktree:** **neu** `wt-b-axislock` ab ce `development` (nicht `wt-b-a1`).
- **Inhalt:** `scripts/ci_axis_lock_bite.sh` -- aendert ein Byte in
  `measurement_curve_loader.hpp` **in einer Kopie**, laesst den Lock-Vergleich laufen, erwartet
  Exit != 0; danach Bump + Lock-Regen, erwartet Exit 0; danach erneute Drift, erwartet wieder
  Exit != 0. Aufruf aus dem vorhandenen Job `contract:axis-version-lock` (`.gitlab-ci.yml:447`).
- **Abnahme:** drei Exitcodes literal im Job-Log; der Bissbeweis liegt als `.txt` im Baum
  (Vorbild `scripts/ci_diff_ascii_width_guard.bissbeweis.txt`).
- **Disjunktheit:** `D(P-LOCK-A) SCHNITT D(P-A1)` = {} (2.2). **Wenn der Skript-Weg scheitert, faellt
  1C aus WELLE 1 heraus und wandert als Form B hinter 1A** -- nicht daneben.
- **Landung:** erst nach 1A (Landebahn ist seriell), aber der **Bau** laeuft parallel.

### Gruppe 1D -- **READ-ONLY-Bahn** (kein Bau, kein Bau-Baum, beliebig viele Agenten)
Alles hier schreibt nur `docs/` und faellt unter den Ledger-Einzelschreiber (Sammel-Commit am Ende).

| # | Posten | Abnahme |
|---|---|---|
| 1D-1 | **Owner-Vorlage** mit O-A (samt den DREI Teilfragen 1.4.2 und dem Befund 1.4.1, dass Linux mit Flag reale L1/dTLB liefert), O-B, O-C, O-D, O-E, O-F, O-3, O-4, **O-Token** (776 Runner-Token in `5ba3d03f`) und der Anhang-A-Kopplung (V-08-Rest) | eine Datei, jede Frage mit Entscheidungsvorschlag + Kosten + Termin-Folge |
| 1D-2 | **P2-P8-Katalog-Klaerung** (READ-ONLY, im Fahrplan "sofort frei"): Katalog-Quelle in den A8-S3-Backups lokalisieren, Schema-Delta beziffern | Delta beziffert, Quelle mit Pfad benannt |
| 1D-3 | **Stempel-/RF-Rest-ultracode-Pruefpass** (RF-1/2/6/7/8, G2-Rest, C-3a/70.9) + **O-2-Ratifikations-Vermerk** -- Register-Auflage: **IM L1-Fenster, nicht spaeter**. L1 ist gefallen; das Fenster ist jetzt | je Posten ein Schliessbeleg oder ein ausdrueckliches OFFEN mit Grund |
| 1D-4 | **OD-2-Wrapper-Vollform + OD-1-telemetry-Dual-Zeile** Pruefpass (kein Bau) | dito |
| 1D-5 | **OD-7-Runner-Ist Live-Check** am Host (3/2 gegen SOLL 2/2 + heavy 24) und **`df`-Stand beider Maschinen** | zwei Zahlenpaare, literal |
| 1D-6 | **E8 PMC-Beleg-Form** klaeren (reicht Permutations-A/B je Achsen-Thema?) | Verdikt oder Owner-Frage |
| 1D-7 | **Trigger-Checkliste ausschreiben**: 7-Auflagen-Satz LEDGER:98 woertlich . gruene Emission ALLER W-Wellen . J-Hygiene L2 . D-10-Eichung L11 . Bestandslog-Provider + P11-Env-Check . **V-06-Rest ETA-Erst-Batch-Abnahme** . **Posten 89 T6-Rebound-Leaf-Einpreisung** . df-Wache | eine abhakbare Liste, jeder Punkt mit Pruefkommando |
| 1D-8 | **Atlas-Nachzug vorbereiten** (05b-UML REV 5 von `98eea2e7` auf End-Stand, mit Korpus-Gegenpruefung; ce-Kopie `be4f0a16`) -- **war auf L1 gated, L1 ist gefallen** | Umfang beziffert; Bau danach |
| 1D-9 | **Ledger-Nachtrag** mit: der Lock-Regel (*"wer die drei Heuristik-Header anfasst, regeneriert den Lock"*, FAHRPLAN R3 -- sonst waechst der Befund in drei Wochen nach), dem KF-6-Befund aus 1.8, dem PMC-CSV-Befund aus 1.4.1 und AUFLAGE T-1 | ein Nachtrag, ASCII byteweise geprueft |

**BEWEIS, dass 1A/1B/1C/1D gleichzeitig laufen duerfen:**
- **Datei:** `D(1A) SCHNITT D(1B)` = {} (verschiedene Repos) . `D(1A) SCHNITT D(1C)` = {} (2.2, Form A) .
  `D(1B) SCHNITT D(1C)` = {} (verschiedene Repos) . `D(1D)` TEILMENGE VON `docs/`, schneidet keine der drei.
- **Worktree:** vier verschiedene Baeume (`wt-b-a1`, `wt-b-xxe`, `wt-b-axislock`,
  Haupt-Checkout read-only). Kein Baum hat zwei Schreiber.
- **Reihenfolge:** keine Gruppe konsumiert das Ergebnis einer anderen. 1B liest das Submodul
  ueber `COMDARE_CACHE_ENGINE_DIR` -- der Gitlink steht (`e7aa1244`) und wird erst **am Ende**
  von 1A bewegt; wenn das passiert, ist 1B laengst gebaut und wird ohnehin gegen den neuen Stand
  gegengefahren, bevor es landet.
- **Gate:** ein ce-Voll-Gate (1A), ein super-Slot (1B), 1C ohne Compile, 1D ohne Ressource.
  Genau **eine** Landung je Zeit, und die macht der Lead.

## WELLE 2 -- nach der A1-Landung (drei Bahnen)

| Gruppe | Bahn / Worktree | Inhalt | Abnahme |
|---|---|---|---|
| **2A** | ce-Voll-Gate / `wt-b-dash` | **P-DASH-ce**: die zwei `--`-Kommentarzeilen in `all_axes_golden.profile.xml` (Z. 62, 64) heilen | `xmllint --noout` **roh** ohne Fehler (heute: zwei "Double hyphen within comment"); Voll-Gate gruen; **danach Bump** |
| **2B** | super-Slot / `wt-b-xxe` (fortgesetzt) | **P-DASH-super**: `-DPROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON` aus `Code/tests/CMakeLists.txt` entfernen -- **erst nach 2A + Bump**, weil die Wache sonst FATAL wird | `test_golden_n_consistency` gruen ohne die Option |
| **2C** | Bau-Slot (konkurriert!) / Scratch | **P-KAL Kalibrier-Stichprobe**: ~200 Binaries im Trigger-Modus bauen, Zeit stoppen, auf 131.072 hochrechnen. **Kosten: Minuten. Ohne sie ist der Trigger ein Sprung ins Dunkle** | t/Binary literal; Hochrechnung fuer 5/15/30 s je Binary gegen das Do-Fr-Fenster; Ergebnis in die Owner-Vorlage (O-A haengt daran) |

**Warnung zur Gleichzeitigkeit 2A/2C:** beide brauchen CPU. **Reihenfolge: 2C zuerst** (Minuten,
und O-A haengt am Ergebnis), danach 2A. Wer beides gleichzeitig faehrt, verletzt Leitplanke 1 und
verfaelscht die Zeitmessung von 2C.

## WELLE 3 -- OWNER-GATED (startet erst mit der Antwort)

| Gruppe | Gate | Inhalt |
|---|---|---|
| **3A** | **O-A + O-B** | **P-PMC (i-1 + i-2 + i-3) als EINE Welle.** i-1: `-DCOMDARE_ENABLE_PMC=ON` in die vier Emissionen (mindestens `:1342`, danach 841/877/1194 pruefen) -- **als Invariante, nicht am Job-Namen** (Ledger nachmittag-10 E). i-2: Preflight-Verdikt am **Preflight-Ort** auf `pmc_available=1` verengen, den 13.07.-Inversionsfix NICHT ruecknehmen (zweiter Modus `--require-available` oder Preflight prueft die Ausgabe explizit). i-3: `allow_failure` (`:1373`) entfernen **oder** auf Zell-Ebene zurueckfuehren -- vorher pruefen, ob eine Pipeline-Politik daran haengt. Plus **T-ii-1** (Emissions-Test auf das Flag; `test_experiment_plan_director.cpp` existiert, kein CMakeLists-Eingriff). Worktree `wt-b-pmc`. |
| **3B** | **nach 3A**, plus **O-C** | **P-BEST (i-5 + i-6) als EINE Welle.** i-5: `COMDARE_BESTANDSLOG`-Gate umkehren (Default AN) **oder** im Trigger-Rezept verbindlich setzen **und** im Planer eine harte Wache ergaenzen, die den Voll-Lauf ohne Provider **abbricht** statt stumm zu degradieren. i-6: `cfg.bestand_fingerprint_fn` in `bestandslog_active` (`:1658-1660`) **UND** in `mess_bestandslog_active` (`:1665-1668`) aufnehmen, fail-closed. Biss: T2-C-Fall + `na`-Fall muessen das Lager stumm halten. |
| **3C** | **O-Token** | Behandlung von `refs/backup/pre-secret-scrub-20260802` (`5ba3d03f`). **Loeschung nur mit expliziter Owner-Autorisierung.** |
| **3D** | **O-1 (Mess-GO)** | Phase 6. Harter Stopp. |

**Reihenfolge-Beweis 3A vor 3B:** ANKLAGE-Abhaengigkeitsspalte i-5, verbatim: *"Erst nach
i-1..i-4, weil ein scharfes Skip-Gate ohne PMC-Fix nur schneller falsch misst."* -> **eine Kette,
keine Parallelbahn.**

## WELLE 4 -- TRIGGER-VORLAUF (P3, nach dem Bau-Block)

Streng seriell, Checkliste aus 1D-7: Trigger-Checkliste abhaken . B9/P11-Pre-Flight (Ebene-B-Enumerations-Nachholung
+ Env-Check des Voll-Bau-4) . Ebene-B-Push-Aktivierung entscheiden . df-Wache scharf . OD-7-Runner
geklaert . P-KAL-Hochrechnung liegt . Posten 89 eingepreist . **ein hart gruener Voll-Lauf auf dem
fertigen Stand** ("sonst faehrt der Trigger als Blackbox").

---

# TEIL 4 -- DER KRITISCHE PFAD

## 4.1 Der Pfad, in Reihenfolge

```
WELLE 0 (15 min, seriell)
   |
   +--> 1A A1-Bump -> Voll-Gate -> Dual-Review -> LANDUNG -> ce main-FF -> super-Bump -> gruen
   |        ^^^ DAS IST DER KRITISCHE PFAD. Alles andere haengt nicht daran.
   |
   +--> 1B XXE (super-Slot)      \
   +--> 1C Axis-Lock-Biss (ce)    >  parallel, kein Einfluss auf den kritischen Pfad
   +--> 1D READ-ONLY (n Agenten) /
   |
2C P-KAL (Minuten)  -> Zahl fuer O-A
2A/2B  --Kommentar-Heilung (klein)
   |
WELLE 4: Trigger-Checkliste + P11 + ein hart gruener Voll-Lauf
   |
   +-- [OWNER O-A] --> 3A PMC-Welle  --> [OWNER O-C] --> 3B BESTANDSLOG
   |
   v
[OWNER O-1 Mess-GO]  -->  Phase 6 (Voll-Bau-4 + Messung)
   |
   v
Abgabe Fr 08.08.
```

## 4.2 Die Owner-Entscheide, die alles aufhalten koennen -- mit ihrer Position

| Entscheid | Sitzt vor | Kosten des Nicht-Entscheids |
|---|---|---|
| **O-A PMC** | Phase 6 (3D) | **Der teuerste.** Der Testplan sagt verbatim: *"Wenn O-A auf 'fixen' faellt, faellt die Entscheidung ueber die Messung mit -- nicht danach."* Ein mehrtaegiger Lauf ohne PMC ist nicht nachtraeglich reparabel; ein Fix danach heisst: neu messen. Und 1.4.1 zeigt, dass der Fix reale Daten liefern wuerde |
| **O-B `allow_failure`** | 3A | mit O-A |
| **O-C `COMDARE_BESTANDSLOG`** | 3B | ohne Provider **kein Skip-Gate** -> jeder Voll-Lauf baut alle 131.072 Binaries neu, auch nach einem Abbruch. **Das ist ein Laufzeit-Multiplikator, nicht nur Hygiene** |
| **O-D `xmllint` auf prod** | 1B-Landung | 5 (mit P-XXE: 6) super-Tests rot; **kein Bau-Abbruch** |
| **O-1 Mess-GO** | Phase 6 | by design |
| **O-Token** | 3C | Security-Posten, blockiert keine Welle |
| **O-3 Loesch-GO** | nach dem Messfenster | blockiert keine Welle |
| **O-4 Anhang-A-Reichweite** | Thesis-Band | Default-Vorschlag NACH-ABGABE |
| ~~O-G `main`-FF~~ | -- | **vollzogen** |
| ~~O-H dreckige Submodul-Dateien~~ | -- | **gegenstandslos** |
| **A1-Freigabe** | 1A | **beantwortet** (Ledger nachmittag-10 D: LANDEN mit Bump-Auflage) |

## 4.3 Ehrlichkeit vor Optimismus -- was NICHT mehr reinpasst

**Realistisch bis Do 07.08.:**
- WELLE 0 vollstaendig.
- 1A A1-Landung + Bump + FF (Mechanik, kein Bau-Neuland).
- 1B XXE-Bissbeweis (~1-2 h), 1C Axis-Lock-Biss (~1-3 h).
- 2C Kalibrier-Stichprobe (Minuten).
- 2A/2B `--`-Heilung (2 Zeilen + 1 Zeile).
- 1D vollstaendig (kostet keine Bau-Ressource).
- 3A PMC-Welle **nur sofern O-A frueh entschieden ist** (~2-4 h Arbeit).

**Wahrscheinlich, nicht sicher:**
- T-ii-2 Fingerprint-Kreuzprobe (2-4 h).
- Ein voll gruener Lauf **beider** Repos inkl. Sanitizer. `sanitize:tsan` ist die lange Stange;
  ein Cold-Cache-ICE-Retry (Memory `reference_ci_runner_ice_cold_cache_instability`) kostet einen
  weiteren Umlauf.
- 3B BESTANDSLOG (halber bis ganzer Tag + Owner-Entscheid vorab).

**NICHT realistisch -- klar gesagt:**
- **Das gesamte P2-Band.** Das REGISTER fuehrt "P2-P8-Schema", "Lager-Kaskaden + xlsx-GERUEST",
  "B5 Mess-Schnitt", "#46b-Rest", "G-E3-Host-Binder", "Posten-77/78-Auflagen" als **VOR
  Messbeginn Pflicht** (Leitplanke 4). **Nichts davon ist gebaut, und nichts davon passt in zwei
  Tage neben dem Bau-Block.** Das ist der groesste ehrliche Riss zwischen Plan und Fenster --
  er gehoert in die Owner-Vorlage, nicht in eine stille Verschiebung.
- **B13 L18-ETA / headless-CLI** (P1): Worktree abgebaut, Bau mit neuem Branch + Re-Anker-Pass.
- **KF-6 NTTP-Codegen**: nach der Abgabe (der OOB-Anteil ist gelandet, der XML-Block inert -- 1.8).
- **Neuvalidierung von Messergebnissen nach einem PMC-Fix.** Das Flag zu setzen ist eine Zeile;
  die 131.072-Zellen-Matrix damit neu zu fahren ist ein mehrtaegiger Lauf.
- **`xmllint` auf prod1/prod2 selbst installieren** (Cluster read-only per Doktrin).
- **E18-SNAP-NB3**, **Host-Belegung `batch_plan_datei`**, **Versionierungs-Interface (F7 Option b)**,
  **Atlas-Bau** (die Vorbereitung 1D-8 passt, der Bau nicht), **alles aus (iii)**.

**Der eine Satz, falls die Zeit knapper wird als geplant** (Testplan Z. 427-430, sinngemaess auf
heute uebertragen): der Bau-Block schlaegt jeden neuen Test. **A1 gelandet + Bump + FF + ein hart
gruener Voll-Lauf** ist mehr wert als drei neue Wachen -- denn ohne A1 ist der Voll-Bau-4 zu
wiederholen, und das kostet mehr als alle drei Wachen zusammen.

## 4.4 Die Laufzeit-Arithmetik, die ueber den Termin entscheidet

FAHRPLAN Abschn. 3, am Objekt aus `experiment_golden_kern.xml` (von mir nachgelesen: Z. 246
`<run_options cap="131072" build_version="golden_kern"/>`, Z. ~285 die Matrix-Rechnung):

```
deklarierte Matrix : line_size 4 x system 4 x N 131072 = 2 097 152 Tier-Binaries
harte Kappung      : 131 072
131072 / 24 Worker =  5462 Binaries je Worker
   bei  5 s/Binary  ->  ca.  7,6 h      (geht sich aus)
   bei 15 s/Binary  ->  ca. 22,8 h      (knapp)
   bei 30 s/Binary  ->  ca. 45,5 h      (geht NICHT zwischen Do und Fr)
```

**Drei Unbekannte sitzen in dieser Rechnung, alle drei bekannt-unbekannt:**
1. **Kompilierzeit je Binary** -- niemand hat sie gemessen. -> **P-KAL (2C).**
2. **Worker-Zahl** -- OD-7-SOLL 24, Memory-Ist 3/2, Handout nennt den Register-Ist selbst stale.
   -> **1D-5 Live-Check.**
3. **Skip-Gate** -- ohne O-C baut jeder Lauf **alles** neu, auch nach einem Abbruch. Der
   Zaehler-Resume von T2-A hat ohne Provider keinen Anker (ANKLAGE KK-2/KK-8). -> **O-C.**

Die Owner-Doktrin deckt ein Rutschen ab (*"Substanz gewinnt, wir bauen geradeaus weiter"*) -- was
sie **nicht** deckt, ist ein Trigger, dessen Laufzeit man nicht kennt.

---

# TEIL 5 -- WAS AUSDRUECKLICH NICHT PARALLEL GEHT

Damit es niemand spaeter doch versucht:

1. **Zwei Landungen gleichzeitig.** Ein Koordinator, eine Landebahn, jeder Merge genau einmal
   (Leitplanke 2). Zwei gleichzeitige Merges nach `development` erzeugen ein unzurechenbares Rot.
2. **Zwei ce-Voll-Gates gleichzeitig.** Leitplanke 1. Auch wenn die Dateien disjunkt sind: die CPU
   ist es nicht, und die Zeitmessung von P-KAL wird dadurch wertlos.
3. **Zwei Schreiber in `ce tests/unit/CMakeLists.txt`.** Bis A1 gelandet ist, gehoert die Datei
   P-A1 allein. Wer einen ce-Unit-Test braucht, nutzt ein registriertes Target (P-PMC) oder den
   Skript-Weg (P-LOCK-A) -- oder wartet.
4. **Zwei Schreiber in `super Code/tests/CMakeLists.txt`.** Erst P-XXE, dann P-DASH-super.
5. **Zwei gleichzeitige Ledger-Nachtraege.** Append-only -> garantierte Kollision am Dateiende.
   Der Lead schreibt, nach der Landung, einmal.
6. **`P-DASH-super` neben oder vor `P-DASH-ce`.** Die super-Wache wird **FATAL, sobald die
   ce-Datei roh wohlgeformt ist**. Reihenfolge: ce-Fix -> Bump -> super-Entfernung.
7. **`i-1` ohne `i-2` (oder umgekehrt).** i-1 allein liesse die Wache blind, i-2 allein
   blockierte den Lauf. Eine Welle.
8. **`i-5` ohne `i-6`.** *"i-5 allein schaltet KK-4 scharf"* -- und mit `mess_bestandslog_active`
   sind es zwei Gates, nicht eines.
9. **`P-BEST` neben `P-PMC`.** Kette, kein Parallelzweig (ANKLAGE).
10. **Der Bau-Block neben dem Trigger.** A1 nach dem Voll-Bau-4 zu landen macht den Voll-Bau
    zu Makulatur. Der Block ist vor dem Trigger **vollstaendig** zu schliessen.
11. **ce-Landung ohne `main`-FF + Bump.** Sonst faehrt der super-Trigger (`branch: main`, drei
    Vorkommen) wieder ueber Code, den niemand baut -- AUFLAGE T-1.
12. **Zwei Pushes auf denselben Branch kurz hintereinander.** Runner-Ist 3/2: das erzeugt
    Backlog, keine Parallelitaet; und ein zweiter Push waehrend eines laufenden Laufs macht das
    Ergebnis unzurechenbar.
13. **Irgendetwas neben `wt-b-a1`.** Der Baum hat 32 uncommittete Dateien und einen aktiven
    Schreiber. Kein `status`-Aufraeumen, kein `reset`, kein `checkout`.
14. **`wt-b-e18snap` anfassen.** NICHT-LANDEN-Verdikt, NB3 nach dem Trigger. Der Baum bleibt,
    wie er ist.

---

# TEIL 6 -- DIE VERSTREUTEN DETAILS (Owner-Auflage: nichts verlieren)

Alles, was heute als Folgeposten, Nach-Abgabe-Posten oder Nebenbefund entstanden, verschoben oder
erledigt wurde -- in einer Liste, damit es nicht verlorengeht.

## 6.1 Heute ENTSTANDEN (neu, in keiner aelteren Liste)

| # | Posten | Quelle |
|---|---|---|
| N-1 | **Kalibrier-Stichprobe der Trigger-Laufzeit** (200 Binaries, Zeit stoppen) | FAHRPLAN Abschn. 3: *"ein Vor-Trigger-Posten, der bisher in keiner Liste steht"* |
| N-2 | **Lock-Regel ins Ledger**: wer `axis_spline.hpp` / `break_even.hpp` / `measurement_curve_loader.hpp` anfasst, regeneriert den Lock -- sonst waechst R3 in drei Wochen nach | FAHRPLAN R3 / Abschn. 5 |
| N-3 | **AUFLAGE T-1**: jede ce-Landung zieht `main`-FF + Gitlink-Bump nach, sonst faehrt der Trigger stale | dieses Dokument, 0.3, aus `.gitlab-ci.yml:255/273/291` |
| N-4 | **`mess_bestandslog_active` (`:1665-1668`) hat dieselbe Fingerprint-Luecke wie `bestandslog_active`** -- der i-6-Fix muss BEIDE Gates fassen | Erhebung 2, heute von mir bestaetigt |
| N-5 | **Die KF-6-Registerzeile ist stale**: der OOB-Fix ist gelandet (drei Pfade abgeleitet + `static_assert`), der golden-XML-Block ist inert (`organ_subaxes` = 0 Treffer in ce) -> KF-6-NTTP ist NACH-Abgabe, kein Trigger-Blocker | dieses Dokument, 1.8 |
| N-6 | **Der PMC-CSV-Befund**: ein realer Lauf mit `pmc_available=1` und realen L1/dTLB liegt untracked im Baum -- er belegt, dass der i-1-Fix Daten erzeugen wuerde, und bestaetigt unabhaengig, dass L2/L3/coherence/energy auch dann 0 bleiben | dieses Dokument, 1.4.1 |
| N-7 | **Vier unversionierte Plan-Dokumente + `Code/measure_out_d03/`** -- Verlustrisiko, dieselbe Klasse wie die `.gitignore`-`*.log`-Falle | `git status --porcelain`, heute |
| N-8 | **Aufraeumpass-Kandidat Nr. 9**: `axis_inventory.tex` wird geschrieben (`08_appendix_generator/appendix_generator.cpp:423`), aber von KEINER `.tex` eingebunden -- dieselbe Klasse wie Gate 8, nur aelter. Braucht einen kleinen Entscheid: in welchen Anhang-Abschnitt? | REGISTER-Nachtrag, Gate-8-Welle |
| N-9 | **Aufraeumpass-Kandidat Nr. 10**: referenzlose `using SearchAlgo`-Aliase `abi_adapter.hpp:440/:545` | REGISTER V-18-Rest A24 |
| N-10 | **`1xN`-/`Nx1`-Matrix-Fatal im `diagram_generator`** (bricht bei nur 1 Algo ODER 1 Workload) -- Bestandsfehler, P4 | REGISTER B-7 |
| N-11 | **DELTA C golden-XML `system_axes`**: atomic128/target_isa fehlen im Block. Billigstes Fenster war die B14-Landung -- **verpasst**, jetzt eigene Zeile | REGISTER P1-Ergaenzung |
| N-12 | **Regel 8 + Regel 9** (neu heute, an Abgabe-Substanz gelernt): ein Submodul-Zeiger kann RUECKWAERTS zeigen (`M` heisst nicht "neuer"); eine rescue-Ref ist KEINE Landung | Ledger nachmittag-10 C |
| N-13 | **Regel 6 + Regel 7** (gestern Abend): ein gruenes Gate deckt nur seinen eigenen Gegenstand -- vor jeder Freigabe nennen, welche Gates gelaufen sind UND welche nicht; ein Gate-Umfang ist repo-spezifisch (derselbe Job prueft im ce 1731 und im super 59 Dateien) | Ledger nachmittag-9 |
| N-14 | **Fehlende Stufe im Bau-Ritual**: `lint:format` prueft GANZE Dateien; T2-A und B14 sind gelandet, ohne je gegen cf22 gefahren zu sein -- **dieselbe Fehlerklasse trat am selben Tag in beiden Repos unabhaengig auf** (ce 94 Verstoesse, super 160 im Graph-Paket). Das ist kein Zufall zweier Wellen | Ledger nachmittag-10 B |
| N-15 | **Betriebs-Doktrin**: `gitleaks` IMMER mit der Repo-`.gitleaks.toml` UND immer auch ueber den Push-Inhalt (ohne Konfiguration Fehlalarm auf einen deutschen Fliesstext mit "key" im Testnamen) | Ledger nachmittag-9 |
| N-16 | **ce-AUFLAGE `--`**: die drei Doppelbindestriche in `all_axes_golden.profile.xml` beseitigen und danach die Escape-Zeile `-DPROFILE_ALLOW_COMMENT_TEXT_DEFECT=ON` im super entfernen. Heute selbst gemessen: der Defekt besteht (`xmllint`: Z. 62, 64) | `Code/tests/CMakeLists.txt`-Kommentar + eigene Messung |

## 6.2 Heute ERLEDIGT (damit es nicht doppelt gearbeitet wird)

- `main`-FF in **beiden** Repos vollzogen; `main` trug bis heute Abend im super einen **roten Kopf**
  (Pipeline 14823 auf `030d2c62` war `failed`) -- der FF hat ihn geheilt.
- **Gate 8** (23 Graph-Abbildungen DE+EN) gelandet; thesis `development`+`main` beider Remotes auf
  `8970465d`; super-Zeiger nachgezogen.
- **overleaf-Submodul-Drift** geheilt (stale Checkout, kein Besitzerproblem).
- **T-i-3 Nenner** gemessen: 407/407 in CI an `e7aa1244`.
- **Doppel-Key `contract:axis-version-lock`** geheilt -- und durch den FF **auch auf `main`**.
- **KF-6-OOB-Fix** gelandet (B14-NB2/NB3).
- **A1-Verdikt** gefallen: LANDEN mit Bump-Auflage.
- **Zwei Lint-Fixes** (`98952e02` cf22 ueber 12+1 Dateien, `e7aa1244` cppcheck-Unterdrueckung
  punktgenau mit ausgeschriebener Begruendung -- *"Ein Werkzeug-Limit darf eine Zeile entschaerfen,
  nie eine Wache"*).
- **R2 E-18-Zielbranch**: ENTSCHIEDEN (`development`) -- aus dem Owner-Fenster gestrichen.
- **Lager-Gate G5**: SUPERSEDED durch Owner-A8 + Additiv-Doktrin; Nachfolger = **O-3 Loesch-GO**.
- **B2/E-04-"Widerspruch"**: aufgeloest (`92ad8357`/`63406ce3` zur Falte `037300a6` vereinigt).
- **B14-"Widerspruch"** (kein `wt-b14-golden`): live widerlegt, Welle gelaufen und gelandet.

## 6.3 Namenskollisionen -- die loeschen Inhalt still (Register-Mechanik-Vermerk)

| Kollision | Aufloesung |
|---|---|
| **B5** (Mess-Schnitt-Fenster, P2) | **!=** **B-5** (Voll-Korpus-Lebend-Check, P4) |
| **R2** (E-18-Zielbranch) | **!=** **R2** (Post-v3 Driver-Split) |
| **G5** (Lager-Pruning -> O-3) | **!=** **G5/#274** (measurement-all-Modul-Migration, V-12) |
| **A14** (OS-U4-Rest) | **!=** **A14** (FF0-Abgabe-Blocker, V-02) |
| **B12** (xlsx-Lager-Fuellung) | **!=** **B12** (N-Paar-Wahl first-2 vs. Max-Kontrast, F-SPREAD, in V-20) |
| **Posten 36** (Aufraeumpass, K1-Prosa) | **!=** **#36** (Stempel-Finalisierung, G2) |
| **Posten 37** (Aufraeumpass, `kAdapterCompositionSlotCount`) | **!=** **#37** (PMC-Preflight, ERLEDIGT) |
| **#27** | Nummernraum mehrfach belegt |
| **A8-S2** | nie vergeben (Sequenz S1->S3) -- **!=** **A9-S2** (freigegeben 04.08., nie gebaut) |

## 6.4 Erfassungsluecken, die bestehen bleiben (ehrlich benannt)

- Das Ledger hat **keinen Nachtrag-Header 28.-31.07. und keinen 01.08.-Block** (Fensterluecke,
  von zwei Lenses unabhaengig bestaetigt).
- Die Register-Eingabe war nach "Posten 36" trunkiert; Gruppe 3 (super-Kandidatenliste,
  Posten-50-Ziel) fehlt vollstaendig; Tabelle B endete mitten in B14.
- **Ledger-Zeilennummern wandern** (append-only). Bei Nachpruefung ueber den **Wortlaut** suchen,
  nie ueber die Zeilennummer.
- Ich habe **keinen Bau und keinen Test gefahren** und **keine GitLab-API abgefragt.** Alle
  Pipeline-Zahlen sind aus dem Ledger uebernommen und als solche gekennzeichnet.
- Die Codex-Befunde A-02 bis A-13 der ANKLAGE sind **nicht nachverifiziert** (die ANKLAGE sagt es
  selbst: *"Die hohe Trefferquote ist ein Plausibilitaets-Bonus, keine Verifikation."*).

## 6.5 Die Fallen, die schon einmal zugeschlagen haben (Wiederholungsschutz)

1. **`.gitignore` enthaelt `*.log`** -- Gate-Belege als `.txt` sichern oder `git add -f`
   (*"12 von 18 waeren stumm verschluckt worden"*).
2. **2-Pass-Configure**: configure -> **BAU** -> configure. Ein zweites Configure **vor** dem Bau
   registriert die codegen-abhaengigen Tests nicht und liefert eine zu kleine Zahl.
3. **`--` in XML-Kommentaren** bricht jeden echten Parser (Memory
   `reference_xml_kommentar_doppelbindestrich_falle`) -- heute wieder am Objekt.
4. **`git -C <pfad>`** statt `cd` (Memory `reference_git_immer_mit_c_pfad_cwd_falle`).
5. **Kein `git add .` / `commit -a`, immer expliziter Pathspec** -- sonst dreht ein
   Submodul-Zeiger lautlos zurueck (Regel 8, heute beinahe eingetreten).
6. **`build/` enthaelt getrackte Mess-CSV** -- vor jedem `rm` pruefen (Memory
   `reference_ce_build_dir_has_tracked_measurement_csv`), betrifft Posten B11.
7. **Cold-Cache-ICE auf den CI-Runnern** -- ein Retry kostet einen Umlauf.
8. **`pgrep`-Selbstmatch** in Warteschleifen.
9. **`/jobs`-API zeigt keine Bridges** -- Trigger-Jobs fehlen in der Job-Liste.
10. **Gruene Tests zementieren alte Ordnung** -- ein gruenes Gate deckt nur seinen eigenen
    Gegenstand (Regel 6).

---

# ANHANG -- BELEGPROTOKOLL (was ich selbst ausgefuehrt habe)

- `git ls-remote origin|github refs/heads/{main,development}` in **allen drei** Repos (super, ce,
  thesis) -- alle Topologie-Zahlen in 0.1.
- `git rev-list --left-right --count origin/development...HEAD`, `git rev-list --count
  origin/main..HEAD` (super: `0 1` bzw. `2`; ce: `0 0` bzw. `0`).
- `git ls-tree HEAD Code/external/{comdare-cache-engine,20260931-overleaf-diplomarbeit}`.
- `git status --porcelain` in **allen 15 Worktrees** + beiden Haupt-Checkouts.
- `git diff --name-only development...fdfa68ee` (A1, 37 Pfade) und
  `git diff --stat` im dirty A1-Baum (32 Dateien, +365/-148) sowie der Diff der
  `tests/unit/CMakeLists.txt`-Schreibregionen.
- `git diff --name-only development...5c4cf900` (E18-SNAP, 6 Pfade).
- `git ls-remote origin 'refs/backup/*' 'refs/rescue/*'` in beiden Repos.
- `grep -c COMDARE_ENABLE_PMC` in `experiment_plan_director.hpp` -> **0**;
  `grep -n "cmake -B build"` -> 841/877/1194/1342; `grep -n allow_failure` -> 1373.
- `grep -n '^contract:axis-version-lock:'` in ce `.gitlab-ci.yml` -> genau **`:447`**.
- `grep -rlE 'DOCTYPE|ENTITY|xxe|XXE'` ueber ce `tests/` -> **0 von 457 Dateien**; ueber super
  `Code/tests/` -> 3 (die Wachen selbst).
- `grep -rn "organ_subaxes"` ueber das gesamte ce-Repo -> **0 Treffer**.
- `grep -rn "kLbufBytes"` ueber ce `libs/` -> drei Pfade (622/731/873), je abgeleitet + `static_assert`.
- Direkte Lesung: `abi_adapter.hpp:150-180 / 612-640`, `m3v2_pmc_smoke.cpp:60-75`,
  `linux_perf_pmc_smoke.cpp:55-68`, `cache_engine_builder_iterator.hpp:1655-1672`,
  `profile_run_entry.hpp:430-440`, `xml_canonical_utils.cmake:76-95`,
  `Code/tests/CMakeLists.txt:195-238`, `experiment_golden_kern.xml:240-345`,
  `super .gitlab-ci.yml:240-300`.
- `grep -n "m3v2_pmc_smoke|test_experiment_plan_director"` in ce `tests/unit/CMakeLists.txt` ->
  beide Targets bereits registriert (2933-2950 bzw. 3431-3454).
- `xmllint --noout all_axes_golden.profile.xml` -> zwei "Double hyphen within comment" (Z. 62, 64).
- `grep -c "<axis_sweep "` ueber **alle 11** Thesis-Profile.
- Vollstaendige Auswertung von `Code/measure_out_d03/e4_xml/measurements.csv` (16 Zeilen,
  `;`-separiert, alle sieben `pmc_*`-Spalten je Zeile ausgelesen).
- Volltext-Lesung von: dem juengsten Ledger-Nachtrag `nachmittag-10` (194 Zeilen), dem
  Testoffensive-Plan (473 Z.), der ANKLAGE (492 Z.), dem FAHRPLAN Hauptstrang-Landung (566 Z.),
  dem Host-Belegungs-Plan (365 Z.), dem REGISTER (475 Z.) und dem Parallel-Sequenz-Fahrplan (20 Z.).

**Nicht selbst verifiziert und deshalb als UNBELEGT gefuehrt:** die sechs gruenen Pipelines des
Abends (Nummern und Job-Bilanzen, aus dem Ledger uebernommen) . die GitLab-Projekt-/Gruppen-Variablen
. der Weg, ueber den `measure_out_d03` erzeugt wurde . die `xmllint`-Praesenz auf prod1/prod2 . das
Runner-Ist HEAVY/NORMAL am Host . die Kompilierzeit je Tier-Binary . die Codex-Befunde A-02..A-13
der ANKLAGE.
