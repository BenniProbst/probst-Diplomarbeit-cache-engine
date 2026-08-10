# Konsolidierung der unverlinkten Memories

**Erstellt:** 10.08.2026 · **Auftrag (Owner, woertlich, 10.08.2026):**
"Bitte konsolidiere alle unverlinkten memories mit ultracode als Planungsdokument in die Diplomarbeit,
sodass wir die hinten rausgefallenen Fakten weiterhin zugreifen koennen, dann verlinke nur die
Konsolidierung wieder in den index"

## 1. Warum es dieses Dokument gibt

Das Gedaechtnis-Verzeichnis `/home/comdare/.claude/projects/-home-comdare/memory/` trug bei der Erhebung
**286 Dateien**, davon **284 echte Memories** plus die zwei Index-Dateien `MEMORY.md` und
`MEMORY-DETAIL.md`. Gelesen wird davon nur, was der Index `MEMORY.md` verlinkt — **`MEMORY.md` ist die
einzige Datei, die automatisch in den Kontext kommt.**

**Gemessen am 10.08.2026 gegen `MEMORY.md` (17274 Byte, mtime 2026-08-10 07:50:20 UTC): 106 der 284
Memories sind in KEINER Zeile von `MEMORY.md` verlinkt.** Der Erhebungsbefehl und die Gegenprobe stehen
in Abschnitt 7.1.

### Warum aus 57 dann 106 wurden — und warum das der Kern der Sache ist

Die erste Welle dieser Konsolidierung erfasste **57** Dateien. Diese 57 waren gegen
**`MEMORY.md` + `MEMORY-DETAIL.md` zusammen** gemessen. Am 10.08. hatte der Lead `MEMORY.md` kompaktiert,
weil der Index an sein Lese-Limit stiess (`MEMORY-DETAIL.md` nennt den Grund woertlich: "Ausgelagert
10.08.2026, weil MEMORY.md an sein Lese-Limit stiess (20.691 von 24.400 Byte)"), und dabei **fuenf
Themenzeilen nach `MEMORY-DETAIL.md` ausgelagert**: Architektur-Struktur · Kette/XML · References/Infra ·
Rollen/Betrieb · Planung/Lager. `MEMORY.md` verweist seitdem mit **einer** Zeile dorthin, mit der Auflage
"Wer zu einem dieser Themen arbeitet, liest sie ZUERST."

**`MEMORY-DETAIL.md` wird nicht automatisch geladen.** Die Auflage ist damit eine rein DISZIPLINAERE
Loesung — sie haelt nur, solange jemand daran denkt. Die Hausdoktrin misst dazu (Wellenplan §11.3):
*"von zehn Verschaerfungen hielten 7 von 10 — genau die, die in ein WERKZEUG gebrannt wurden. Die drei
rein disziplinaeren kamen zurueck."* Die **49** Dateien, die nur noch in `MEMORY-DETAIL.md` haengen, sind
faktisch genauso unsichtbar wie die 57. Am Objekt gemessen (10.08.):

| Nenner | verlinkt | unverlinkt |
|---|---|---|
| gegen **`MEMORY.md` allein** (die einzige automatisch geladene Datei) | 178 | **106** |
| gegen `MEMORY.md` + `MEMORY-DETAIL.md` (so wurde die 57er-Welle gemessen) | 227 | 57 |
| Differenz = haengt **nur** in `MEMORY-DETAIL.md` | — | **49** |

(178 + 106 = 284; die 227 zaehlen `MEMORY-DETAIL.md` selbst nicht mit, sie ist als Index-Ziel verlinkt.)

**Deshalb konsolidiert dieses Dokument alle 106, nicht 57.** Es ist damit der EINE Ort, an dem die aus dem
automatisch geladenen Index gefallenen Fakten weiter zugreifbar sind — unabhaengig davon, ob jemand daran
denkt, eine zweite Index-Datei nachzuschlagen.

Ausloeser der ersten Welle war ein Zufallsfund: zwei bis dahin unsichtbare Dateien erwiesen sich am 10.08.
als unmittelbar arbeitsauslösend — die Runner-Concurrency (der wahre Speicher-Multiplikator hinter dem OOM)
und die PMC-Mikroarchitektur-Trennung. Beide sind inzwischen im Index verlinkt und **daher nicht Teil der
106**; sie erscheinen hier nur als Gegenstuecke in der Widerspruchs-Tabelle. Die Dunkelziffer hinter diesen
zwei Funden ist der Grund fuer diesen Auftrag.

### Was NICHT geschieht

**Die 106 Quelldateien werden NICHT geloescht.** Hausregel: Doku wird nie geloescht, nur deprecatet
(`feedback_never_delete_documentation`). Sie bleiben unveraendert liegen unter:

    /home/comdare/.claude/projects/-home-comdare/memory/<dateiname>.md

Es aendert sich ausschliesslich, WO man sie findet: ab jetzt ueber dieses Planungsdokument, auf das der
Index EINMAL verweist. Wer den Volltext braucht, findet ueber die Herkunfts-Tabelle (**Abschnitt 6**) den
Dateinamen und liest ihn am Quellort.

### Wie dieses Dokument zu lesen ist

- **Abschnitt 2** ist der Teil, der Arbeit ausloest: jeder Fakt, der einer heute geltenden Annahme
  widerspricht. Wer wenig Zeit hat, liest nur diesen.
- **Abschnitt 3/4** traegt die Fakten thematisch, mit Zahlen, Pfaden, SHAs und Daten woertlich.
  Die Abschnitte **3.11 bis 3.16** sind vollstaendig aus der zweiten Welle (den 49): Kette · Registries ·
  Lagerhaltung · Achsen-Neuordnung 26.07. · Firmen-Matrix · Cluster-Netz.
- **Abschnitt 5** sammelt die Verweis-Befunde (tote Links, Namensbrueche, Frontmatter-Drift).
- **Abschnitt 6** ist die Gegenprobe: alle 106 Dateinamen mit der Fundstelle ihrer Fakten.

**Ueberholtes steht drin, als ueberholt gekennzeichnet — es wird nicht weggelassen.** Viele dieser Dateien
tragen KORREKTUR- oder RICHTIGSTELLUNG-Bloecke: eine Zahl galt, wurde widerlegt, eine neue trat an ihre
Stelle. Beide gehoeren hierher, mit ihrer Reihenfolge. Wer nur die neue Zahl sieht, kann nicht mehr pruefen,
wie sie entstand — und genau daran ist in diesem Projekt schon eine Zahl (die "47 von 47")
unrekonstruierbar geworden.

### Herkunfts-Kennzeichnung

Je Fakt steht am Ende: Quelldatei, Datum und eine von drei Klassen. Sie sind **nicht gleichwertig**:

| Klasse | Bedeutung |
|---|---|
| **OWNER-WORT** | woertlich oder sinngemaess belegte Owner-Aussage — bindend |
| **MESSUNG** | am Objekt erhoben (Kommando-Ausgabe, SHA, Job-ID, Zeilenzahl) — pruefbar |
| **AGENTEN-BEHAUPTUNG** | Einordnung/Ableitung eines Agenten — pruefbedürftig, nicht bindend |

### Scope dieser Konsolidierung (Quellenklassen, ausdruecklich benannt)

Gelesen wurden **ausschliesslich** die 106 unverlinkten `.md`-Dateien im Memory-Verzeichnis.
**NICHT** gelesen wurden: `docs/sessions/*`, der Ledger, Dossiers, Backups, Roh-Transkripte.
Diese Angabe steht hier, weil `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` (Regel 2) genau das
von jeder Konsolidierung verlangt — dort war das Fehlen der Quellenklasse `docs/sessions/*` die Ursache
eines verlorenen Paketschnitts.

---

## 2. Widersprueche — der Teil, der Arbeit ausloest

Kurztabelle zuerst, Einzelheiten mit Quellen und Zitaten direkt darunter — **W-01 … W-20 aus der ersten
Welle (den 57), W-21 … W-33 aus der zweiten (den 49)**.

| Nr | Gegenstand | Geltende Annahme | Widerspruch aus den 57 | Handlung |
|---|---|---|---|---|
| W-01 | Runner-concurrency | 4/4 seit `0d7c577` | Owner 26.07.: "concurrency=1" | Kette 1/2/3/4 klaeren |
| W-02 | prod1-Kernzahl | 16 Kerne, OD-7 setzt 24 | "P5-heavy c=1/24/nproc" 27.07. zweimal | Ursprung der 24 pruefen |
| W-03 | Organ-Achsen | 18, nicht 19 | 17.07.: "die 19 Organ-Achsen" | Korrektur-Datum belegen |
| W-04 | Codex-Modell | `gpt-5.6-sol` + ULTRA | 27.06.-Datei fordert `gpt-5.5`+xhigh | Alt-Datei deprecaten |
| W-05 | Delegations-Modell | im Index nicht gefuehrt | Fable-5-xhigh bindend seit 26.07. | Owner-Entscheid einholen |
| W-06 | Explore-Verfahren | 2-STUFIG (Sonnet5 + selbst) | Codex-Pairing bei JEDEM Explore | Ablöse klaeren |
| W-07 | Mikro/Makro-Wallclock | Owner: "sind FALSCH" | PMC-Memory Pkt.14 fuehrt sie wieder | F6 aufloesen |
| W-08 | super-Gate 453/453 | Plan-Anker "453/453" | war NIE gruen; 450/5/453 | Zwei-Gate-Modell setzen |
| W-09 | `COMDARE_V32_ENABLE` | gated 4 Tests (316 vs 312) | Nachtrag 03.08.: gated KEINEN | am Objekt entscheiden |
| W-10 | `allow_failure` | verboten seit 06.07. | 06.07. selbst eingebaut (`3895a3a5`) | Ist-Stand pruefen |
| W-11 | PMC-Verfuegbarkeit | PMC vorhanden, Pflicht | 01.06.: kein PCM/MSR, `NullPmcSource` | #26 entsperren |
| W-12 | Abgabefrist | 15.09.2026 | 08.08. / 27.07. / 28.07. / 24.07. | nur Historie |
| W-13 | GOAL-Version | V8 | V2 → V5 → V6 belegt, V3/V4/V7 nicht | Lineage-Luecke |
| W-14 | Buildsystem-Version | unbekannt | `v3.4.15` Stand 05.07. | gegen XML pruefen |
| W-15 | Codex `workspace-write` | defekt (bwrap) | 04.07. lief er mit diesem Banner | Bruchdatum klaeren |
| W-16 | Stempel-Zeilen-Layout | 5 Zeilen inkl. `merge` | merge-Zeile darf NICHT existieren | E2 gegen Bestand |
| W-17 | Bridge-Referenzklassen | docs-only-main = 13/0 | seit 02.08. abends 13/1 | Monitore nachziehen |
| W-18 | Modul-Repos | eine Instanz je Modul | `comdare-config-module` = id 155 UND 156 | #274-Stand pruefen |
| W-19 | Remote-Vollstaendigkeit | Dual-Remote ueberall | Pi 5 + node1 halbfertig, 18.07. | `git remote -v` pruefen |
| W-20 | Test-Zahl `test:unit` | unbekannter Ist-Wert | 271→272→277→280, host-abhaengig | Referenz live erheben |

**Zweite Welle (W-21 … W-33) — aus den 49 Dateien, die nur in `MEMORY-DETAIL.md` haengen.**

| Nr | Gegenstand | Geltende Annahme | Widerspruch aus den 49 | Handlung |
|---|---|---|---|---|
| W-21 | concurrency 1 gegen 2 | W-01: beides ein Konflikt | OD-7: HEAVY=1, NORMAL=2 | W-01 zweiteilen |
| W-22 | Herkunft der "24" | "prod2s Kernzahl" | 22.07. "prod1=32T/24K" | Notation T/K klaeren |
| W-23 | `std::variant` | Ausnahme fuer Hybrid | F3: "ALLEN Tier-Typen VERBOTEN" | Vorrang datieren |
| W-24 | CEB-Modi | Index: "CEB 3 Modi" | seit 21.07. VIER (COMPARE) | Index nachziehen |
| W-25 | Registry-Zahl | "2 Registry" (Label) | §28 19.07.: DREI | Kanon festlegen |
| W-26 | "neue Plattformen" | RISC-V/macOS neu 02.08. | standen 03.07. in der Matrix | E-4-Satz korrigieren |
| W-27 | bwrap-Bruchdatum | W-15: "defekt ab 07.07." | 05.07. 22:47 UTC dokumentiert | Fenster 04.-05.07. |
| W-28 | Mess-Ergebnis-NAS | PR4100 Cluster_NFS | 18.07.: prod-HDDs (6TB longhorn) | Ziel-NAS entscheiden |
| W-29 | GitLab-Host | `gitlab.comdare.local` | PAT-Referenz testet gegen `.de` (404 seit 13.07.) | Datei nachziehen |
| W-30 | Planer-Gestalt | eigene Binary mit Shell-CLI | 16.07.: "versteckte root-Minimal-Binary" | Alt-Satz deprecaten |
| W-31 | CEB-Hoheit | Planer haelt die Mess-Achsen | 13.07.: CEB haelt ALLE XML-Parser | Audit `wf_a7faa724` |
| W-32 | Doku-Master-Pfade | "Pflicht-Pre-Read" | Pfad-Praefix existiert nicht mehr (gemessen) | Pfade neu setzen |
| W-33 | prod1-Toolchain | gcc-15.3 = Default | prod1-Env 05.07.: Default 16.0.1-trunk | Datei nachziehen |

### W-01 Runner-concurrency: vier Werte, vier Daten, ein unerledigter Owner-Zweck

- **Geltend (heute, verlinkt):** `reference_runner_concurrency_ist_3_2_stau_ist_backlog` traegt eine
  KORREKTUR vom 06.08.2026: "Die 3/2-Zahl ist STALE — sie entspricht dem Vorcommit `618e9be`; seit Cluster
  `scripts/runner-mode.sh` Commit **`0d7c577`** (27.07. 'Durchsatz > dicke Jobs') gilt **NORMAL_CC=4 /
  NORMAL_J=4 auf BEIDEN Hosts**, HEAVY_J=24 fuer prod1 UNGEKAPPT." Owner-SOLL (OD-7): normal **2/2** x 12
  Threads beide Hosts, heavy prod1 24.
- **Widerspruch aus den 57 (aeltester Wert, Owner-Wort):** "**Runner-concurrency=1** auf den GitLab-Runnern
  (prod1/prod2), um die Messung nicht zu stoeren — Pipelines queuen seriell; das ist gewollt, kein Defekt.
  **Bei CI-Staus NICHT an der concurrency drehen.**"
  — `project_20260726_nach_trigger_alle_baender_abarbeiten.md`, 26.07.2026, OWNER-WORT.
- **Zweiter Widerspruch aus den 57 (Zwischenwert, bisher unbekannt):** Infra-Handover
  `super docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md`,
  Inhalt: "V80-Filterpod write-only + **prod1-concurrency 2 -> 3**", an den User ueberreicht.
  — `project_diplomarbeit_stand_20260712_freigaben_pipeline.md`, 12.07.2026, AGENTEN-BEHAUPTUNG
  (Primaerbeleg waere das Handover-Dokument selbst).
- **Vollstaendige Kette, chronologisch:**
  **2 (vor 12.07., Ausgangswert)** → **3 auf prod1 (12.07., Handover)** → **live 3/2 gemessen, config.toml
  vom 18.07. (26.07.)** → **Owner will 1 (26.07., derselbe Tag)** → **4/4 per `0d7c577` (27.07.)** →
  **OD-7-SOLL 2/2 (06.08.)**.
- **Der harte Punkt:** die verlinkte Referenz erklaert die Annahme "Runner haengen auf concurrency=1 als
  Mess-Schutz" fuer WIDERLEGT (beide liefen schon vor dem Eingriff auf 3/2). Der Owner hat 1 aber am selben
  Tag ausdruecklich **angeordnet**. Nicht das Faktum ist widerlegt, sondern die Umsetzung fand nie statt.
- **Zu tun:** klaeren, ob der Owner-Zweck (Messung nicht stoeren) heute wirklich durch P11-Wache +
  `resource_group` + 1-Thread-Doktrin gedeckt ist, wie die verlinkte Referenz behauptet — oder ob mit 4/4
  eine 26.07.-Anordnung stillschweigend fallengelassen wurde. Der Satz "Bei CI-Staus NICHT an der
  concurrency drehen" ist zusaetzlich relevant fuer jede laufende OOM-/Speicher-Untersuchung.
- **ERGAENZUNG aus den 49 (10.08.), zwei weitere Glieder und eine Aufloesung:** die Kette hat vor dem
  12.07. noch eine prod2-Exkursion (08.07.: `concurrent=3 x -j10`, am selben Tag zurueck auf **2** auf
  BEIDEN Hosts plus `CMAKE_BUILD_PARALLEL_LEVEL` **10 → 8**, siehe A-10), und die "1" ist kein
  Global-Wert: OD-7 unterscheidet **HEAVY** (Tier-Binary-Build ODER Messung) mit `concurrency=1` von
  **NORMAL** mit `concurrency=2`. Einzelheiten in **W-21** und **A-7**.

### W-02 Die "24" bei prod1: vermutlich prod2s Kernzahl

- **Geltend:** Index-Eintrag "prod1 = 16 Kerne/32 Threads — OD-7 setzt 24: Konflikt".
- **Widerspruch/Spur aus den 57:** `project_20260727_vormittag_o8_fenster_lage.md` nennt **zweimal**
  "VOLL-BAU-4 ab 01.08. auf der 15.3-Kanon-Flotte (**P5-heavy c=1/24/nproc** steht)" bzw.
  "(P5-heavy verbindlich **c=1/24/nproc**)" — 27.07.2026, AGENTEN-BEHAUPTUNG (Lage-Anker).
- **Gegenstueck (verlinkt):** die Runner-Referenz schreibt "heavy = `concurrent=1` + physische Kerne als
  Obergrenze (**prod1 16, prod2 24 phys.**)".
- **Hypothese, ausdruecklich als solche gekennzeichnet:** die 24 in OD-7/P5-heavy ist **prod2s** physische
  Kernzahl, die auf prod1 uebertragen wurde. Nicht bewiesen — die Zahlenlage stuetzt es, ein Code-Beleg fuer
  ein "16-Kerne-Cap" existiert laut derselben Referenz nirgends.
- **Zu tun:** den Ursprung der 24 im OD-7-Handout
  (`super docs/sessions/20260806-HANDOUT-od7-runner-direktive-infra.md`, Abschnitt 5) gegen prod2s Kernzahl
  pruefen; danach `HEAVY_J` je Host getrennt setzen.
- **ERGAENZUNG aus den 49 (10.08.):** die 24 ist **aelter als OD-7**. Owner 22.07. woertlich:
  "Thread-Budget fuer Batch-Compile: **prod1=32T/24K, prod2=24T/16K**". Owner 23.07. woertlich:
  "**AMD worker bitte auf 24 Threads drosseln**" — mit Messung als Begruendung. Die Hypothese
  "prod2s Kernzahl versehentlich uebernommen" ist damit **nicht mehr die einzige Erklaerung**;
  Einzelheiten und die offene Notationsfrage in **W-22**, **A-8** und **A-9**.

### W-03 Organ-Achsen: 19 (17.07.) gegen 18 (heute bindend)

- **Geltend:** Index fuehrt bindend `reference_organ_achsen_sind_achtzehn_nicht_neunzehn` — "18 ORGAN-ACHSEN,
  nicht 19".
- **Widerspruch aus den 57, woertlich:** "**INC-1:** CEB-System-Achsen-Schichtung (die 4 System-Achsen als
  gemeinsame Schicht UEBER den **19 Organ-Achsen**; heute flach)."
  — `project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md`, 17.07.2026, AGENTEN-BEHAUPTUNG.
- **Zu tun:** das Korrektur-Datum 19 → 18 belegen (in den 57 nicht enthalten) und die INC-1-Beschreibung
  nachziehen, damit der Bauplan nicht gegen eine tote Zahl gebaut wird.
- **AUFLOESUNG aus den 49 (10.08.), Mechanik statt Datum:** die 18 entsteht nicht durch Streichung einer
  19., sondern durch **Hinzunahme**. `project_achsen_neuordnung_bindende_sortierung_regressionen.md`
  (26.07.2026, OWNER-WORT) fuehrt die Organ-Achsen als **T00-T16** (= 17) und ergaenzt:
  "**persistence_target = NEUE 18. Organ-Haupt-Achse** (GO): memory_only (Default, golden_wired) +
  disk_writeback. **binary_id 17->18** = bewusster golden-/ABI-Bruch im offenen §66-G2-Fenster, Einbau VOR
  Voll-Bau-4." Das deckt sich mit **G-6** (`binary_id` 17 → 18, ABI 6 → 7, POD 1272 → 1344). Die "19" vom
  17.07. bleibt damit als Zaehlfehler unerklaert, die **18 ist am Objekt hergeleitet**. Siehe **V-6**.

### W-04 Codex-Modell: eine Datei fordert weiter das ueberholte Modell

- **Geltend (Stand 01.08.2026):** `gpt-5.6-sol` + Effort **ULTRA**, Codex **0.146.0**
  (`~/.codex/config.toml` + `~/.claude.json`), Fallback-Kette sol+max → niedrigere Stufen.
  — `feedback_codex_mcp_always_newest_model_xhigh.md`, Nachtrag 03.08.2026, MESSUNG (smoke-belegt).
- **Widerspruch aus den 57:** `feedback_codex_mcp_review_before_code_complete.md` (27.06.2026) schreibt als
  geltende Regel vor: Codex IMMER mit `model: "gpt-5.5"` + `config: {model_reasoning_effort: "xhigh"}`.
  Die Datei wurde seither nicht nachgezogen.
- **Zu tun:** die 27.06.-Datei mit SUPERSEDED-Vermerk auf die Modellzeile versehen (Doku nicht loeschen).

### W-05 Delegations-Doktrin: im Index existiert sie gar nicht

- **Befund:** `/usr/bin/grep -i "fable\|opus\|modell" MEMORY.md` liefert **0 Treffer**. Weder die alte
  Fassung (Opus-Agenten, 19.07.) noch die geltende (Fable-5-xhigh, 26.07.) ist verlinkt. Beide Dateien
  gehoeren zu den 57.
- **Geltende Fassung, Owner 26.07.2026 (sinngemaess verbatim):** "Bitte merke dir, dass du ab sofort stets
  Fable 5 fuer Verifikation, Planung und Implementierung verwendest. Du bist CTO und Manager von
  **Fable-5-xhigh-Agenten**." Begruendung, Owner woertlich: "**uebernimm von Opus 5, es baut schwerwiegende
  Fehler**". AUSNAHME OD-3, Owner woertlich: "Fable 5 unterbindet infra Themen generell, das blockiert die
  API, verwende dafuer immer einen Agenten **Opus 5 xhigh**".
  — `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md`, 26.07.2026, OWNER-WORT.
- **Schaerfe:** die laufende Session arbeitet als **Opus 5**. Ob die 26.07.-Regel noch gilt oder durch eine
  spaetere, nicht in den 57 enthaltene Anweisung abgeloest wurde, ist aus dem Material **nicht** zu
  entscheiden.
- **Zu tun:** Owner-Entscheid einholen, dann **eine** Index-Zeile setzen — die Regel darf nicht weiter
  unsichtbar sein.

### W-06 Explore-Verfahren: zwei verschiedene Zwei-Stufen-Modelle

- **Geltend (Index):** "2-STUFIG" = `feedback_explore_kartierung_sonnet5_max_dann_selbst_gegenlesen`
  (Sonnet5 max, danach selbst gegenlesen).
- **Widerspruch aus den 57:** bei **jedem** Explore-Aufruf parallel denselben Auftrag an einen
  `mcp__codex__codex`-Agenten geben (sandbox `read-only`, approval `never`,
  `model_reasoning_effort: xhigh`, Modell weglassen), mit EXAKT demselben Prompt; Konvergenz = hohe
  Konfidenz, Divergenz = genauer hinschauen.
  — `feedback_pair_explore_with_codex_same_investigation.md`, ~07.07.2026, AGENTEN-BEHAUPTUNG
  (als bindende Selbstregel formuliert). **Kein Supersede-Vermerk in der Datei.**
- **Zu tun:** entscheiden, ob das Codex-Pairing durch das 2-STUFIG-Verfahren ersetzt wurde oder zusaetzlich
  gilt; die unterlegene Fassung deprecaten.

### W-07 Mikro/Makro/Wallclock: verworfen — und im verlinkten PMC-Memory wieder da

- **Verworfen, Owner 06.08.2026 woertlich:** "**Micro- und Macro-Benchmarking sind FALSCH** und entsprechen
  nicht dem neuesten Stand der Planung im ledger. Wallclock time wird je Tier-Binary Funktion und ueber eine
  Kombination einer Last JEWEILS gemessen."
  — `feedback_gattung_genus_interface_messparameter_achsen.md`, 06.08.2026, OWNER-WORT.
  Verworfen wurde damit ausdruecklich die Agenten-Zuordnung "MIKRO=`axis_stats` / MAKRO=`seg_ns` /
  WALLCLOCK=aussen".
- **Offen geblieben (F6, in derselben Datei):** verwirft das AUCH das §47/§54-T2-Auswahl-Achsen-Konzept
  (Mess-Tooling-HAUPT-Achse mit den Werten {nur Wallclock / Makro-Benchmarks / Micro-Benchmarks ueber
  Observer}, LED:2282ff, 20.07.), oder nur die Fehldeutung? Kein Supersede-Vermerk auf §47.
- **Gegenstueck (heute verlinkt, Punkt 14 von `feedback_pmc_je_mikroarchitektur_p_und_e_core_getrennt`),
  Owner 06.08. nachts woertlich:** "fuer die Erhebung des **Micro-Benchmarkings** ist die Wallclock time
  **zusaetzlich IN der Tier-Binary einkompiliert**. Ansonsten ist sie **wie gehabt in der CEB**." Dort steht
  die Verortungs-Tabelle: Micro (je Achsenaufruf) = in der Tier-Binary; Macro (je Funktionsaufruf am
  Pruefdock) = in der CEB; Large scope (ueber eine Last-Sequenz) = in der CEB. Ausdruecklich getrennt werden
  dort **Tooling-WERTE** (welche Instrumentierung einkompiliert wird) und **Erhebungs-EBENEN** (woran
  gemessen wird).
- **Lesart, als Hypothese gekennzeichnet:** die spaetere Owner-Praezisierung beantwortet F6 — verworfen war
  die falsche Projektion auf `axis_stats`/`seg_ns`, **nicht** die Auswahl-Achse. Beide Stellen liegen in
  verschiedenen Dateien, keine verweist auf die andere.
- **Zu tun:** F6 formell schliessen, indem beide Owner-Stellen in EINER Quelle zusammengefuehrt werden.

### W-08 super 453/453: dieser Anker hat nie existiert

- **Widerspruch, MESSUNG:** "**super-Voll-Suite war NIE 453/453 gruen**" — super traegt DAUERHAFT **5
  vorbestehend rote Tests**: `v31_adapters` + `v41_topic_allocator` (vendor-snmalloc-Runtime-Bug,
  Ledger:514, nur bei `COMDARE_VENDOR_SNMALLOC=ON`); `limits_entkopplung` + `lazy_adhoc`
  (CRC-Mismatch, `kNewGolden131072Crc64` ist konfigurationsgebunden); `axis_registry_roundtrip`
  (contract-Label, gate-gewollter Inventar-Drift).
  — `reference_lokale_vollbau_luecken_falsches_gruen.md`, Nachtrag 27.07.2026 (Impl-O8), MESSUNG.
- **Das geltende Modell (Zwei-Gate):** **ce-standalone = scharfes Gate (316/316 + CRC-Anker)**;
  **super = Integrationsgate mit eingefrorener 5er-Ausnahmemenge, Erwartung 450 gruen / 5 rot / 453.**
  Ein "super 453/453"-Anker in Plaenen ist eine **Zaehlung** (`ctest -N`), **kein Lauf-Beleg**.
- **Zu tun:** jede Plan-/Ledger-Stelle mit "453/453" auf 450/5/453 umstellen; die Klasse je Test muss stabil
  bleiben (aendert sich die Klasse, ist es ein neuer Befund, kein Alt-Rot).

### W-09 `COMDARE_V32_ENABLE`: die Datei widerspricht sich selbst

- **Fassung 1 (27.07.2026, MESSUNG):** ce-Voll-ctest zaehlt **N=316 nur mit `-DCOMDARE_V32_ENABLE=ON`**;
  Default-Configure (OFF) zaehlt **312** — es fehlen exakt vier V32-gegatete Tests: `f15_compare_cli_smoke`,
  `test_184_dataset_loader_wiring`, `test_25_kanon_dataset_akten`,
  `test_v41_anatomy_adhoc_autobuilt_load`. Beweis: `ctest -N`-Mengen-Diff frisches Dir gegen die
  **Org18-Referenz** `build-ninja-s4`, einziger CMakeCache-Options-Unterschied war die Option.
  Stand `be827881`, Repo `comdare-cache-engine`.
- **Fassung 2 (Nachtrag 03.08.2026, Gegenlese D-01, gestuetzt auf den Verify-Befund 01.08.,
  `FAHRPLAN:42-53`):** "`COMDARE_V32_ENABLE` gated **KEINEN** Test (einzige
  Wirkung: Option + INTERFACE-Define); V32=ON bleibt nur als CI-Kanon. Der Titel-Wert N=316 ist historisch."
  Die Gate-Zahl ist das lebende ctest-Gate, Progression **312 → 314 → 316 → 317 → 318 → … → 331**.
- **Beide Aussagen stehen unaufgeloest nebeneinander** in `reference_ce_jkette_n316_braucht_v32_enable_on.md`.
  Offen bleibt, ob sich der Code zwischen 27.07. und 03.08. aenderte oder die Kausalzuschreibung falsch war.
- **Zu tun:** am Objekt entscheiden (`ctest -N` mit/ohne Option auf dem heutigen Stand), Ergebnis in die
  Datei schreiben.

### W-10 `allow_failure`: die Regel und ihr mutmasslicher Ausloeser tragen dasselbe Datum

- **Geltend (Index):** "allow_failure VERBOTEN seit 0607 — ZELLE=Warnung, JOB=hart rot."
- **Widerspruch aus den 57:** "**264-b** (ce **`3895a3a5`**): `test:unit`-Probelauf (**allow_failure**) +
  sanitize 1→5 Targets + NEU `sanitize:tsan`." — `project_bep_abt_session_stand_20260705.md`,
  Nachtrag mit Datum **06.07.2026**, AGENTEN-BEHAUPTUNG.
- **Einordnung:** kein Widerspruch zur Regel selbst, sondern hoechstwahrscheinlich ihr **dokumentierter
  Ausloeser** — der Einbau faellt exakt auf den im Index genannten Stichtag. Aus den 57 nicht abschliessend
  zu klaeren, weil die Verbots-Datei selbst nicht zu den 57 gehoert.
- **Zu tun:** pruefen, ob `3895a3a5` bzw. dessen Nachfolger heute noch `allow_failure` traegt.

### W-11 PMC: von "physisch nicht vorhanden" zu "MUSS gemessen werden"

- **Alt (01.06.2026, MESSUNG, literal verifiziert):** #26 (reale PMC-Hardware-Counter) lokal physisch nicht
  abschliessbar — **kein Intel-PCM / kein MSR-Device**. Bleibt per Compile-Flag abgeschaltet
  (`USE=ENABLE&&HAVE`, HAVE=OFF → Stubs; PMC = **`NullPmcSource`**). Beschaffungs-Spec geliefert:
  `docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md` (reale **6 POD-Felder** → IntelPcm /
  LinuxPerf / PAPI / likwid-Drop-ins). Ebenso #19 (jemalloc/tcmalloc/hoard/scalloc echt linken):
  kein vcpkg / kein WSL-gcc / kein nativer gcc / kein autoconf.
- **Neu (Nachtrag in derselben Datei, datiert 09.08.2026, Bezug Owner 06.08.2026, OWNER-WORT):**
  "**es ist ja PMC vorhanden, also MUSS es auch mit eingebaut und gemessen werden.**" — "Die Blockade dieses
  Eintrags ist aufgehoben. Der Eintrag bleibt als Historie stehen, ist aber **nicht mehr geltend**."
  — `project_thesis_19_26_22_deferred_until_cluster.md`.
- **Anschluss (heute verlinkt):** `feedback_pmc_je_mikroarchitektur_p_und_e_core_getrennt` traegt die
  Fortsetzung: P-Core und E-Core sind getrennte PMU-Domaenen (`cpu_core` / `cpu_atom`), die Intel-Maschine
  hat **effektiv zwei PMC**; EINE CEB traegt beide Messfuehler, die Tier-Binary wird zweimal gestartet
  (gepinnt), **kein zweiter Bau**.
- **Zu tun:** #26 aus dem gateten Backlog holen; die 01.06.-Beschaffungs-Spec (6 POD-Felder) gegen die
  P/E-Core-Trennung nachziehen — sie kennt nur EINE PMU-Domaene.

### W-12 Fristen: vier ueberholte Daten, alle belegt

Reihenfolge (jede spaetere ersetzt die vorige):

| Frist | Quelle aus den 57 | Datum der Festlegung | Klasse | Bemerkung |
|---|---|---|---|---|
| 24.07.2026 | `project_frist_montag_2707_...` (§41-Zwischenfrist) | vor 22.07. | OWNER-WORT | ersetzt durch 27.07. |
| 27.07.2026 | `project_frist_montag_2707_...` | 22.07. abends | OWNER-WORT | ausdruecklich **Zwischen**-Abgabe |
| 28.07.2026 | `project_diplomarbeit_stand_20260717_...` | 17.07. | AGENTEN-BEH. | "CI UND standalone messfaehig" |
| 08.08.2026 | `project_20260727_vormittag_o8_fenster_lage` | 01.08. ~20:45Z | OWNER-WORT | OE-A..F, woertlich |
| **15.09.2026** | Index, GOAL v8 | heute geltend | — | **einzig aktive Frist** |

Owner-Wort zur 27.07.-Frist, woertlich (22.07.2026): "bitte arbeite so gruendlich, wie moeglich, die Frist
ist bis montag, aber bis dahin muessen wir wohl noch **2 Tage bauen und 2 Tage messen und testen**."
Einordnung, Owner woertlich (23.07.): "es ist ja noch nicht die End-Abgabe wo alle Aufgaben in der aktuellen
Gruendlichkeit erledigt sein muessen". Praezisierung, Owner woertlich (23.07.): "**Keine Umwege, aber
NACHEINANDER DURCHZIEHEN**". **Zu tun:** nichts ausser der Reihenfolge festhalten — keine der alten Fristen
ist aktiv, aber die Zeitbudget-Rechnung (2 Tage bauen + 2 Tage messen) ist weiter brauchbar.

### W-13 GOAL-Version: die Lineage hat Luecken

Belegt aus den 57: **V2** (Ledger §13.4, Z.247-254, korrigiert durch §13.9/§13.10/§13.11 —
`project_diplomarbeit_stand_20260706_comdare_prod1.md`, 06.07.) → **V5 SUPERSEDED** → **V6 AKTIV**
(LEDGER:75-118, super `bf8a7ca`; /goal-Steuertext V6.9, TABU V6.5 —
`project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md`, 17.07.) → heute **V8** (Index).
**V3, V4 und V7 sind in den 57 nicht belegt.** Zusaetzliche Fundorte des V2-Wortlauts:
`~/.claude/history.jsonl` Zeile 23; Session `~/.claude/projects/-home-comdare-Projekte/34effcef-*.jsonl`
Zeilen 633/643; Vorlage `docs/HANDOVER-BEP-ABTEILUNG-20260705.md` §2 Z.26.
**Zu tun:** entweder die Zwischenversionen belegen oder die Luecke im GOAL-Dokument vermerken.

### W-14 Buildsystem-Version `v3.4.15` ist 36 Tage alt

`cd-buildsystem-core` **v3.4.15** via `buildsystem.xml`, Produkt `cd-buildsystem-construct`; verpflichtend
fuer comdare-web wie fuer comdare-db, weil das hauseigene BuildSystem Lizensierung
(comdare-licensing / isLicensed / BEP-EULA) und Code-Optimierung von Haus aus mitfuehrt. CMake/CMakePresets
sind **nur** Light-/Dev-Unterbau, nicht der offizielle Build-Weg.
— `feedback_comdare_products_house_buildsystem_mandatory.md`, 05.07.2026, OWNER-WORT.
**Zu tun:** Version gegen die heutige `buildsystem.xml` pruefen, bevor die Zahl irgendwo zitiert wird.

### W-15 Codex `workspace-write`: lief am 04.07., defekt ab 07.07.

- **04.07.2026:** Fix-Rezept mit temporaerem `CODEX_HOME` lief mit Banner **`sandbox: workspace-write`**,
  0 Hook-Marker. — `reference_codex_routing_block_preamble_fix.md`, MESSUNG.
- **07.07.2026:** `workspace-write` scheitert VOR Ausfuehrung mit
  `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`; Wurzel:
  `kernel.apparmor_restrict_unprivileged_userns = 1` (Ubuntu, Kernel 6.17).
  — `reference_codex_mcp_prod1_bwrap_shell_broken.md`, MESSUNG. Am **09.08.2026** noch immer defekt
  (Task #43 dieser Session, identischer Fehler) — der saubere AppArmor-Fix wurde nie angewendet.
- **Zu tun:** klaeren, ob zwischen 04. und 07.07. eine Systemaenderung stattfand, oder ob der 04.07.-Lauf
  schlicht keine loopback-relevante Aktion ausloeste. Praktisch bleibt `danger-full-access` der einzige Weg.

### W-16 Stempel: die `merge`-Zeile darf nicht existieren

Owner-Entscheid **E2 Stempel-REGRESSION**, 02.08.2026, Quelle
`super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`:
Meta-Meta-Achsen-Stempeleintraege sind PFLICHT wie alle Hauptachsen; der Stempel passt sich **dynamisch per
Metaprogrammierung** an; Meta-Meta gehoert immer zu Mess-/System-/Organ-Realm und wird **dynamisch ans ENDE
der bestehenden Realm-Zeile angehaengt**. **Die merge-Zeile darf NICHT EXISTIEREN** (der PRT-ART-Pruefling
faehrt merge GEGEN die Organ-Achsen). Experimentelle Achsen-Algorithmen: **`e`-Suffix** je
Achsen-Algorithmus. Das Ist-5-Zeilen-Layout (`organ` / `system` / `measurement` / `merge` / `sha512`) ist
**defekt**; die Realm-Trennung ist defekt und wirkt auf die Lagerhaltung.
— `feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende.md`, 02.08.2026, OWNER-WORT.
Das Paket gilt zusammen mit E3 als **trigger-blockierend vor Voll-Bau-4**.
**Zu tun:** E2 gegen den heutigen Stempel-Bestand pruefen; merge-Zeile entfernen, Meta-Meta-Anhaengung
bauen, `e`-Versionierung einfuehren, OP-11 zurueckbauen, SHA512-Skip-Gate/G-E6 erst danach aufsetzen.

### W-17 Bridge-Referenzklassen: 13/0 ist ueberholt

- **Alt (27.07.2026):** docs-only-main = **13 Jobs / 0 Bridges**; code-only-main = 13/0.
- **Zwischenstand (NACHTRAG 02.08.2026 nachmittags, MESSUNG — bis heute nur hier gefuehrt):** "Gitlink-Wellen
  feuern seit thesis-Trigger **BEIDE** Bridges: Referenz-Klassen **Gitlink-dev = 13/2** und
  **Gitlink-main = 13/2** (`trigger:cache-engine` + `trigger:thesis`, **Downstreams je separat belegen**)."
  Der dev-Wert **13/2** wurde am Abend **nicht** neu gefasst — die Abend-Korrektur betrifft nur die
  main-Klassen; er steht damit gegen "Gitlink 13/1" aus dem 01.08.-Anker (N-10) und gegen das
  Pro-Bridge-Modell aus N-7 ("reiner Gitlink-Bump feuert nur `trigger:cache-engine`"). **Aufloesung: welcher
  Gitlink im Diff liegt, entscheidet** — ce-Gitlink allein = 1 Bridge, thesis-Gitlink = 2.
- **Neu (KORREKTUR 02.08.2026 abends, CiWatch2, MESSUNG):** `trigger:cache-engine` feuert auf super-**main**
  IMMER (diff-unabhaengig), `trigger:thesis` nur bei thesis-Gitlink im Diff. Referenzen NEU:
  docs-only-main = **13/1**, code-only-main = **13/1**, Gitlink(thesis)-main = **13/2**,
  Gitlink(ce)-main = **13/1**, docs-only-dev = **2/0** (unveraendert), prt-art (287) = **6/0**.
  Begruendung fuer den Sprung von 13/0 auf 13/1, woertlich: "die alte 13/0 zaehlte die **main-immer-Bridge**
  nie mit". `prebackup:measurements` ist ein regulaerer Job, **kein** Mess-Job — die Quelle nennt das
  ausdruecklich eine **Filter-Fehlalarm-Falle** (ein Mess-Job-Filter, der auf den Namen geht, schlaegt hier
  falsch an). — `reference_ci_trace_parsing_commit_titel_falle.md`, 02.08.2026, MESSUNG.
- **Zu tun:** jeden Monitor, der 13/0 als Erwartung fuehrt, nachziehen — sonst meldet er strukturell falsch.

### W-18 Modul-Repos: dasselbe Modul existiert zweimal

`comdare-config-module` existiert als **ZWEI** GitLab-Projekte in zwei Familien-Gruppen:
`comdare/modules/comdare-foundation/comdare-config-module` **id 156** UND
`comdare/modules/comdare-config/comdare-config-module` **id 155**. Der Gruppen-vs-Ordner-DIFF
(`docs/sessions/20260707-gitlab-gruppen-vs-ordner-DIFF.md`) dokumentiert **268 von 294 Abweichungen**.
Altfall: `Modules/comdare-cacheengine-all` bettet dasselbe Research-Remote ein statt einer eigenen
Modul-Instanz. Einzige **gewollte** Ausnahme: prt-art (super-Submodul + Research-Arbeitskopie).
Owner 07.07.2026: zur Zeit der Entwicklung der lokalen Matrix-"Klone" gab es nur Opus 4.1, es war **nie die
Absicht, Klone zu erzeugen** — "Das Vorgefundene ist eine **Struktur-Regression**."
— `project_struktur_regression_geteilte_klone_statt_instanz_repos.md`, 07.07.2026, OWNER-WORT + MESSUNG.
**Zu tun:** Stand des Migrationspakets **#274** pruefen; Remote-Anlagen/Transfers nur mit User-GO je Schritt.

### W-19 Fehlende Remotes auf Pi 5 und node1: Einmal-Auftrag ohne Erledigt-Vermerk

Owner-Direktive 18.07.2026, bindend, woertlich: "Bitte merke dir, dass du immer (ausser bei Cluster git wegen
plain text cred vault, gewollt so) einen sync durchfuehrst, wenn eine remote fehlt. **Bitte sync diesen
Fehler auf Pi 5 und node1 (hier)**, die auch halb fertige clone haben."
Namensmuster auf prod1: `origin` = gitlab.comdare.local, `github` = github.com/BenniProbst/<repo>.
Konkret genannter Fall: der prod1-thesis-Klon (nur `origin`, `github` fehlte).
**Ausnahme:** Cluster-git (`Projekte/Cluster`) NIE nach github syncen — plain-text Cred-Vault, bleibt
gitlab-intern.
— `feedback_always_sync_missing_remotes_except_cluster.md`, 18.07.2026, OWNER-WORT.
**Zu tun:** `git remote -v` auf Pi 5 und node1 pruefen — die Datei traegt **keinen** Erledigt-Vermerk, der
Auftrag ist 23 Tage alt. Verfahren: `git remote add <name> <url>`, mit `git ls-remote` read-only
verifizieren, dann pushen; Repo-NEUANLAGE bleibt GO-pflichtig, reiner Remote-Config-Fix nicht.

### W-20 `test:unit`-Zahlen sind host-abhaengig und wandern

Reihenfolge (jede spaetere ersetzt die vorige), alle MESSUNG aus
`reference_ci_trace_parsing_commit_titel_falle.md`:

| Wert | Host | Stand/SHA | Datum |
|---|---|---|---|
| 275 / 271 | prod1 / prod2 | allgemein | vor 01.08. |
| **276 / 272** | prod1 / prod2 | `52bcbc76` (Pipelines 14127 / 14129, gleicher SHA) | 01.08. |
| 277 | prod2 | `408242f3`+ | 02.08. nachmittags |
| **280** | prod2 | `7603453b` (+3 namentlich belegt) | 02.08. abends |
| **144** | super | zweifach prod2-belegt (alter Wert **141 UEBERHOLT**) | 01.08. |

Der Host-Diff von 4 Tests sind hardware-gegatete Faelle: `test_buildvariant_dll_real`,
`test_ap5_simd_extension_coherence`, `test_simd_add_u64_carry_avx512`,
`test_simd_field_sum_dispatch_avx512` (Trace woertlich: "GO-3 A1: … NICHT registriert (Host ohne
AVX2+AVX-512F …)"). `test_experiment_plan_director` erscheint in **keiner** ctest-Liste der CI-Welle,
obwohl gebaut — gewollt, Zwei-Gate-Modell: CI-Suite (271/275) ist nicht das scharfe lokale Gate (317).
**Zu tun:** Referenzwerte nie aus dem Gedaechtnis zitieren, immer live erheben; prod1-super-Wert ist offen.

### W-21 concurrency 1 gegen 2: OD-7 unterscheidet HEAVY von NORMAL — W-01 hat sie vermischt

- **Geltend (W-01 dieses Dokuments):** die Owner-Anordnung "concurrency=1" (26.07.) und der OD-7-SOLL-Wert
  "2/2" (06.08.) stehen dort als zwei Werte derselben Groesse nebeneinander.
- **Primaerquelle aus den 49, Owner 26.07.2026 abends (~18:40), woertlich:** "**OD-7 NEUE Runner-Zahlen:**
  heavy (Tier-Binary-Build ODER Messung): **concurrency=1, prod1=24 Worker, prod2=alle Threads**; normal:
  **BEIDE concurrency=2 x je 12 Threads.** => Infra-HANDOUT"
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
- **Was daraus folgt:** die "1" und die "2" widersprechen sich **nicht** — sie gehoeren zu **zwei Job-Klassen**.
  Die Owner-Auflage "Runner-concurrency=1 … um die Messung nicht zu stoeren" (A-1, derselbe Tag) ist damit
  exakt die HEAVY-Zeile von OD-7. Der 4/4-Zustand aus `0d7c577` verletzt **beide** Zeilen gleichzeitig.
- **Zu tun:** W-01 nicht als "ein Wert, vier Daten" weiterfuehren, sondern als **zwei Reihen**: HEAVY
  (Soll 1) und NORMAL (Soll 2). Erst danach ist ueberhaupt entscheidbar, ob der Ist-Zustand konform ist.

### W-22 Die Herkunft der "24": sie ist vier Tage aelter als OD-7 und hat eine Messung hinter sich

- **Geltend (W-02 dieses Dokuments):** Hypothese, die 24 sei prod2s physische Kernzahl, faelschlich auf
  prod1 uebertragen.
- **Aelterer Beleg aus den 49, Owner 22.07.2026, woertlich:** "Thread-Budget fuer Batch-Compile:
  **prod1=32T/24K, prod2=24T/16K** (User-Vorgabe = verfuegbare Kapazitaet); alle Threads NUR je einzelnem
  Batch-Compile voll ausschoepfen — maximale Kerne fuer CEB-Batch- UND Planer-CEB-Compile."
  — `project_62_planer_universal_cache_log_claim_compare.md` (NACHTRAG-8), 22.07.2026, OWNER-WORT.
- **Ein Tag spaeter, mit Messung, Owner 23.07.2026 mittags, woertlich:** "**AMD worker bitte auf 24 Threads
  drosseln**" — Begruendung im selben Eintrag: "nach Slice-1-Empirie (**amd@32W 19,95min == amd@24W
  19,4min**, aber **20G Swap + OOM-Kills** paralleler CI-Jobs auf **60G-RAM-Maschine**). Neu:
  **lane_build_parallelism amd=24, intel=24**." — dieselbe Datei, 23.07.2026, OWNER-WORT + MESSUNG.
- **Was daraus folgt:** die 24 fuer prod1 ist **nicht** zwingend eine Verwechslung. Es gibt eine
  eigenstaendige, gemessene Begruendung (Swap/OOM bei 32 Workern) und einen expliziten Owner-Befehl.
- **Was offen bleibt (und ausdruecklich nicht geraten wird):** die Notation "**32T/24K**". Wird sie als
  "32 Threads / 24 Kerne" gelesen, widerspricht sie dem Index-Fakt "prod1 = 16 Kerne / 32 Threads". Wird sie
  als "32 Threads verfuegbar / 24 fuer Kompilierung" gelesen, ist sie mit dem 23.07.-Befehl deckungsgleich
  und **kein** Widerspruch. Die zweite Lesart passt zur zweiten Haelfte "prod2=24T/16K" schlechter
  (prod2 = i9-14900KS = 24 Kerne / 32 Threads). **Zu tun:** die Notation am Roh-Transkript des 22.07.
  aufloesen, nicht aus der Zahl ableiten.

### W-23 `std::variant`: "nur in der CEB" (26.07.) gegen "Ausnahme fuer die Hybrid-Stufe" (02.08.)

- **Geltend (E-1 dieses Dokuments, 02.08.2026):** die Hybrid-Stufe darf `std::variant` als **Ausnahme**
  benutzen; "in plain Tier-Binaries bleibt `std::variant` **verboten**".
- **Widerspruch aus den 49, Owner 26.07.2026 ~16:40, woertlich:** "**F3: std::variant NUR in der CEB
  geduldet, in ALLEN Tier-Binary-Typen VERBOTEN.**" — der Zusatz derselben Zeile: "Loest W3 auf
  (praezisiert N3 + Hybrid-Ausnahme: die Duldung lebt CEB-seitig)."
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
- **Dritter Beleg, 10.08.2026:** `feedback_prt_art_consumes_cache_engine.md` stuetzt die Nutzung von
  `std::variant` + Laufzeit-`switch` im PRT-ART-Kern ausdruecklich auf das **02.08.**-Owner-Wort
  ("in der Regel als Ausnahmen std::variant. Aber in den plain Tier-Binaries ist das verboten.") mit der
  Begruendung "PRT-ART ist ein hybrid-Tier, also faellt es unter die Ausnahme".
- **Der harte Punkt:** ein Hybrid IST ein Tier-Binary-Typ. F3 (26.07.) verbietet es dort, E-1 (02.08.)
  erlaubt es dort. Das spaetere Datum gewinnt nach Hausregel — aber F3 traegt das Etikett "KERN=Gesetz",
  und die 02.08.-Formulierung sagt "plain Tier-Binaries", nicht "alle".
- **Zu tun:** den Vorrang datieren und in **einer** der beiden Dateien einen SUPERSEDED-Vermerk setzen;
  bis dahin ist jeder `std::variant` in einem Hybrid ein ungeklaerter Fall.

### W-24 CEB-Modi: der Index fuehrt drei, die Memories seit 21.07. vier

- **Geltend (Index-Zeile):** "[CEB 3 Modi](feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md)".
- **Widerspruch aus den 49, Owner 21.07.2026:** "**COMPARE = 4. Modus:** Debug/Messung/Release laufen JE
  MASCHINE; nach Release folgt je Maschine COMPARE: vergleicht aus dem Mess-REPLAY (§58) die Sicht der
  messenden Maschine mit allen per Cache-Log registrierten Maschinen."
  — `project_62_planer_universal_cache_log_claim_compare.md`, 21.07.2026, OWNER-WORT.
- **Bestaetigt am 26.07., Owner woertlich:** "**Q-4 KORREKTUR: CUSTOM_COMPILE ist KEIN 5. Modus, sondern
  CLI-FEATURE**, das alle 4 Modi ueberschreibt und dem Anwender/Kunden die gewuenschte Binary liefert.
  **Es bleiben 4 Modi** (Debug/Messung/Release/COMPARE — COMPARE als 4. Registry-Eintrag mitbauen)."
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
- **Zu tun:** die Index-Zeile und die Datei `feedback_ceb_drei_modi_...` auf **vier** Modi nachziehen und
  CUSTOM_COMPILE als CLI-Feature (kein Modus) daneben fuehren. Vorlaeufig gilt: wer "3 Modi" liest, liest
  einen Stand von vor dem 21.07.

### W-25 Registry-Zahl: zwei (13./16.07.) gegen drei (19.07., §28)

- **Fassung A, Owner 13.07.2026:** "**ZWEI Registry-XMLs, GLEICHES Schema (System-Ebene):** (1) ce-Registry
  … (2) prt-art-Registry" — `feedback_unified_experiment_xml_plus_system_registry_xml.md`, OWNER-WORT.
- **Fassung A bekraeftigt, Owner 16.07.2026:** "je CacheEngine UND je PRT-ART eine (= **2-Registry-Kanon**;
  Registries sind die ALLEINIGE, statische Baustein-Ablage je Achse)"
  — `feedback_ceb_config_cmake_interface_static_registry_paths_prt_module.md`, OWNER-WORT.
- **Fassung B, Owner 19.07.2026 (§28), woertlich:** "Das Angebot besteht aus **DREI art-spezifischen
  Registries, je im Modul ihrer Achsen-Art**: (1) **Organ-Registry** … (2) **System-Registry** (NEU, im
  System-/measurement-Modul: 6/7 CEB-System-Achsen + Unter-Achsen opt_level/Flags/Commands/simd/march/
  target), (3) **Mess-Registry** (NEU, im Mess-Modul: 16 Kategorien, Kollektoren, DynamicDims,
  Workload-Achse). … Der Resolver linkt die Anwender-XML gegen ALLE DREI Bibliotheken."
  — `feedback_registry_angebot_anwender_xml_pom_resolver_planer.md`, 19.07.2026, OWNER-WORT.
- **Aufloesungs-Hinweis (AGENTEN-BEHAUPTUNG, nicht belegt):** die zwei sind **Organ**-Registries je Engine
  (ce + prt-art), die drei sind **Achsen-ARTEN** (Organ/System/Mess). Beide koennten koexistieren
  (2 Organ-Registries + 1 System + 1 Mess = 4 Dateien). Belegt ist das nirgends.
- **Zu tun:** die Zahl in einem Satz festschreiben, bevor der Resolver gebaut wird — das Index-Kurzlabel
  "2 Registry" zeigt heute auf die 13.07.-Datei und ist damit die aeltere Fassung.

### W-26 "Neue Plattformen seit 02.08." — sie standen am 03.07. schon in der Matrix

- **Geltend (E-4 dieses Dokuments, 02.08.2026):** "Kontext: Infra installiert weitere OS; **neue
  Plattformen seit 02.08.: RISC-V, macOS M1, macOS x86**."
- **Widerspruch aus den 49, User 03.07.2026, woertlich:** "Docker-Container IMMER auf **bare metal UND
  Talos OS in voller Matrix** + **mac ARM64, mac x86, RISC-V, Pi5-ARM64**." Dazu: "Auf den exotischen
  Plattformen (mac ARM64/x86, RISC-V, Pi5) zusaetzlich **alle Binaries bare metal**."
  — `feedback_build_matrix_8_docker_distros_full_platform_doctrine.md`, 03.07.2026, OWNER-WORT.
- **Was daraus folgt:** die drei Plattformen sind **einen Monat aelter** als das Etikett "neu". Wer die
  OS-Unter-Achsen-Pflicht (E-4) mit "die Plattformen sind neu" begruendet, begruendet sie falsch; die
  Pflicht selbst bleibt unberuehrt.
- **Zu tun:** den Satz in `feedback_stempel_regression_...` korrigieren (Plattformen seit 03.07. geplant,
  am 02.08. INSTALLIERT) — und Pi5-ARM64 ergaenzen, das in der 02.08.-Aufzaehlung fehlt.

### W-27 bwrap-Bruchdatum: am 05.07. 22:47 UTC bereits dokumentiert defekt

- **Geltend (W-15 dieses Dokuments):** "Codex `workspace-write`: lief am 04.07., defekt ab 07.07."
- **Widerspruch aus den 49, woertlich:** "**Codex-CLI:** eingeloggt (ChatGPT), ABER bubblewrap-Sandbox
  defekt (`bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`) → `--sandbox workspace-write`
  startet KEINEN Prozess und kann nicht mal Dateien lesen. Workaround: `--sandbox danger-full-access` +
  temp CODEX_HOME …" — `reference_prod1_comdare_env_setup.md`.
- **Datierung, MESSUNG (10.08.2026):** die Datei traegt **kein** `modified`-Feld; ihre Datei-System-mtime
  ist **2026-07-05 22:47:41**. Sie wurde also seit dem 05.07. **nicht mehr angefasst** — die bwrap-Zeile
  stand am 05.07. abends bereits drin und kann kein spaeterer Nachtrag sein.
- **Was daraus folgt:** das Bruchfenster ist **04.07. (lief) bis 05.07. 22:47 UTC (defekt)**, nicht
  "ab 07.07.". Der 07.07.-Beleg (C-4) ist die erste **Ursachen**-Analyse, nicht der erste Ausfall.
- **Zu tun:** W-15 auf dieses Fenster verengen; wer die AppArmor-Ursache datiert, datiert sie ab 04./05.07.

### W-28 Mess-Ergebnis-NAS: prod-longhorn-HDDs (18.07.) gegen PR4100 Cluster_NFS (23./26.07.)

- **Fassung A, User 18.07.2026, woertlich:** "**Messergebnisse (measurement/<datiert>/-CSV) → NFS auf den
  prod-HDDs (6TB longhorn)**, damit sie via **DNS-`.1`-SNI per HA-Proxy von VLAN 10 aus durchsuchbar** sind."
  — `feedback_incremental_tier_binary_caching.md`, 18.07.2026, OWNER-WORT.
- **Fassung B, User 23.07.2026 (§65), woertlich:** "Matrix-Forecast gehoert IMMER auf die Lager (Binaries ->
  minio Ebene B **V90 cache-engine-tier-binaries**; Messwerte -> **PR4100 Cluster_NFS/cache-engine-
  experiment**); **lokaler Forecast der Bau-Maschine -> gegen NULL**."
  — `project_62_planer_universal_cache_log_claim_compare.md`, 23.07.2026, OWNER-WORT.
- **Fassung B bekraeftigt, 26.07.2026:** "**DUAL-CCACHE (konfigurierbar):** minio.comdare.de UND NAS
  (**PR4100 Cluster_NFS**) sind ZWEI einstellbare ccache-Ziele."
  — `project_bestandslog_zielbild_ordner_kaskaden_dual_ccache.md`, 26.07.2026, OWNER-WORT.
- **Der harte Punkt:** das sind **zwei verschiedene Speicher**. Die prod-longhorn-HDDs haengen laut
  VLAN-Tabelle an **V91** (prod-DB/prod-MinIO, longhorn-cold, CARP vhid 91), die PR4100 ist das NAS in
  **V20** (10.0.20.101). Wer die 18.07.-Zeile umsetzt, baut gegen ein anderes Ziel als wer die 23.07.-Zeile
  umsetzt. **Zu tun:** entscheiden und in EINER Datei festschreiben (Y-1/Y-2 tragen die Netz-Lage).

### W-29 `gitlab.comdare.de` ist seit 13.07. abgeschaltet — die PAT-Referenz testet weiter dagegen

- **Geltend, User 13.07.2026:** "**`gitlab.comdare.de` ist bewusst ABGESCHALTET** … liefert **404**
  (HAProxy-Default). Kanonischer Host = **`gitlab.comdare.local`**."
  — `reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca.md`, 13.07.2026, OWNER-WORT.
- **Widerspruch, gleiche Menge:** "Bei JEDER GitLab-PAT-Extraktion/Validierung dot-aware extrahieren + per
  `https://gitlab.comdare.de/api/v4/user` (HTTP-Code, NIE den Wert echoen) testen."
  — `reference_gitlab_pat_format_dots_regex.md`, MESSUNG/Anwendungsregel (Datei-mtime 06.07.2026, also
  eine Woche VOR der Abschaltung geschrieben und danach nie nachgezogen).
- **Warum das teuer ist:** die Datei existiert, weil ein Regex-Fehler einen kompletten Fehlalarm
  "alle 9-13 Vault-PATs sind 401" ausgeloest hat. Ein Test gegen einen 404-Host erzeugt exakt denselben
  Fehlalarm noch einmal — diesmal ohne Regex-Bug. **Zu tun:** die Test-URL auf `.local` nachziehen.

### W-30 Der Planer: "versteckte root-Minimal-Binary" (16.07.) gegen "ZWINGEND eigene Binary" (05.08.)

- **Fassung A, User-Praezisierung 16.07.2026, woertlich:** "Das ce-Framework kompiliert eine **versteckte
  root-Minimal-Binary = der Experiment-Planer** — gebaut aus einer **CMake-Konfiguration des Anwenders
  (Diplomarbeit)** aus den ce-Bibliotheken, in den Diplomarbeit-Code."
  — `feedback_ceb_config_cmake_interface_static_registry_paths_prt_module.md`, 16.07.2026, OWNER-WORT.
- **Fassung B, Owner-KERN 05.08.2026, woertlich:** "**Der Planer ist ZWINGEND eine eigene Binary mit dem
  User-CLI-Interface auf der Shell**" — mit dem Zusatz derselben Datei: "R3 damit von Ausrichtungs-Wunsch
  zu HARTER Struktur-Pflicht: Planer = eigenstaendige Binary (nicht Header-Bibliothek im ce-Baum, nicht
  Teil des messung_drivers), Shell-CLI = das User-Interface. **Abweichung = Regression.**" Dazu
  "**F1 HARTES GO Planer-Binary-Split VOR ABGABE** ('sonst werden die Binaries aller Stufen nicht korrekt
  gebaut')." — `project_post_v3_anforderungen_so_abi_driver_split_cli.md`, 05.08.2026, OWNER-WORT.
- **Zu tun:** die 16.07.-Formulierung "versteckt" ausdruecklich deprecaten. Sie ist nicht bloss ueberholt —
  sie beschreibt das Gegenteil dessen, was seit 05.08. Pflicht ist, und steht in der Datei, die die
  CEB-Konfiguration traegt.

### W-31 CEB-Hoheit: "die EINE zentrale C++-Anwendung" (13.07.) gegen den Kette-Kanon (19.07.)

- **Fassung A, User 13.07.2026, woertlich:** "**CacheEngineBuilder (CEB) = die EINE zentrale
  C++-Anwendung:** ALLE XML-Parser (Registries + Experiment) sind IN der CEB-Anwendung verankert; sie
  steuert nach Anwender-Aufruf das gesamte Experiment. Die Tier-Binaries werden ZUR LAUFZEIT vom CEB gebaut
  … der CEB HAELT auch das PRUEFDOCK und das MESSSYSTEM."
  — `feedback_unified_experiment_xml_plus_system_registry_xml.md`, 13.07.2026, OWNER-WORT.
- **Fassung B, User-Entscheid 19.07.2026 (Ledger §30):** "**Mess-Achsen-Permutation wandert von der CEB in
  den Planer.** … Planer = Mess-Achsen · CEB = System-Achsen · Tier-Binaries = Organ-Achsen"
  — `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md`, 19.07.2026, OWNER-WORT.
- **Die Datei nennt den Konflikt selbst (05.08.2026):** "**ACHTUNG Konformitaets-Frage** (laufender Audit
  **`wf_a7faa724`**): der REV-7.6-Kopf liest 4 XML-Configs DIREKT und traegt die volle Pipeline in der
  ExperimentDriver-Library — Vor-Kette-Stand (13.05.) vs. Kanon 19.07. (CEB = vom Planer je Messsystem
  kompilierte Binary, Plan kommt aufgeschluesselt am Experiment-Dock)." — dieselbe Datei, MESSUNG.
- **Zu tun:** das Ergebnis von `wf_a7faa724` an dieser Stelle festhalten; bis dahin ist der Ist-Code
  (REV 7.6, `apps/cache_engine_builder`) die 13.07.-Fassung und der Plan die 19.07.-Fassung.

### W-32 Die Doku-Master-Pfade zeigen ins Leere — "Pflicht-Pre-Read" auf einem toten Praefix

- **Geltend laut Datei:** "Konsolidierte Master-Doks der Diplomarbeit unter `Diplomarbeit - Datenbanken/
  docs/`. **Pflicht-Pre-Read fuer alle kuenftigen Sessions zur Diplomarbeit.**" Es folgen ~30 Pfade
  (`docs/INDEX.md`, `docs/glossar/01_begriffsglossar_v7_master.md`, `docs/bausteine/01_bausteine_matrix.md`
  mit 85 Bausteinen/11 Achsen, `docs/termine/INDEX.md` …).
  — `reference_documentation_master_paths.md`, 15.05.2026, AGENTEN-BEHAUPTUNG.
- **MESSUNG (10.08.2026):** `ls -d "…/probst-diplomarbeit-cache-engine/Diplomarbeit - Datenbanken"` →
  `No such file or directory`. **Gegenprobe, damit der Nichtfund etwas heisst:**
  `ls -d …/probst-diplomarbeit-cache-engine/docs/termine` → **existiert**. Der Inhalt ist also da, nur der
  Ordner-Praefix aus dem Windows-Zeitalter ist weg.
- **Warum das zaehlt:** der Index fuehrt `docs/termine` heute als **Primaerquelle**
  (`reference_docs_termine_ist_die_primaerquelle`). Die unverlinkte Master-Pfad-Datei ist die einzige
  Stelle, die den ganzen Rest (Glossar v7, Bausteine-Matrix, Konfliktregel "spaetere Version gewinnt")
  auflistet — mit einem Praefix, der beim ersten `ls` scheitert.
- **Zu tun:** die Pfadliste einmal gegen den heutigen Baum neu erheben und die Datei nachziehen.

### W-33 prod1-Toolchain-Default: 16.0.1-trunk (05.07.) gegen den 15.3-Kanon

- **Geltend (H-1/H-2/H-4):** gcc **15.3** = Minimum + Standard + DEFAULT; seit 27.07. ~15:10Z nativer
  `alternatives`-Default auf **beiden** Hosts.
- **Widerspruch aus den 49:** "**Toolchain lokal = CI-identisch:** g++-**16.0.1 trunk r16-8100** (exakt der
  Runner-Default!), clang **22.1.8**, cmake **4.3.4**, ninja; cppcheck NICHT lokal (CI hat **2.21.0** via
  citools-Cache)." — `reference_prod1_comdare_env_setup.md`, Datei-mtime 05.07.2026, MESSUNG.
- **Einordnung:** kein Sachwiderspruch, sondern ein **Zeit**-Widerspruch — die Datei beschreibt korrekt den
  05.07.-Zustand, wird aber ohne Datumshinweis gelesen und ist die einzige Datei, die die prod1-Umgebung
  vollstaendig auflistet (Pfade, Keys, Remotes, clang-format-Pin). Deckt sich mit **P-3** (05.07.:
  gcc-16.0.1-trunk default, gcc-13.3.0 vorhanden, KEIN gcc-15/14).
- **Zu tun:** in der Datei einen STAND-Vermerk setzen (Toolchain-Zeile gilt bis 27.07.); der
  clang-format-Pin **22.1.8** unter `/home/comdare/tools/clang-format-22.1.8` gilt unveraendert weiter.

---
## 3. Die Fakten, thematisch

Jeder Fakt traegt eine Kennung (A-1, B-3, …), damit man ihn zitieren kann, und am Ende Quelle, Datum und
Herkunftsklasse.

### 3.1 Runner, CI-Kapazitaet und Betriebsauflagen

- **A-1** Betriebs-Auflage 26.07.: **Runner-concurrency=1** auf prod1/prod2, damit die Messung nicht gestoert
  wird — Pipelines queuen seriell, das ist gewollt, kein Defekt. **Bei CI-Staus NICHT an der concurrency
  drehen.** — `project_20260726_nach_trigger_alle_baender_abarbeiten.md`, 26.07.2026, OWNER-WORT.
  STAND: als Anordnung nie umgesetzt (siehe W-01); der Zweck ist weiter zu pruefen.
- **A-2** Infra-Handover 12.07. an den User uebergeben: V80-Filterpod **write-only** + **prod1-concurrency
  2 → 3**; Pfad `super docs/sessions/20260712-INFRA-HANDOVER-nas-writeback-filterpod-und-runner-concurrency.md`.
  — `project_diplomarbeit_stand_20260712_freigaben_pipeline.md`, 12.07.2026, AGENTEN-BEHAUPTUNG.
  STAND: als Zwischenwert der Concurrency-Kette gueltig (W-01).
- **A-3** Der ~30h-Lauf des Voll-Bau-4 (2^17) ist **kein Warte-, sondern ein Arbeitsfenster**: nach Trigger
  werden die Baender in Gate-Reihenfolge abgearbeitet (Ledger-Nachzug W-30..W-38, G8-Anhaenge-Vorarbeiten,
  Phase-4-Definiertes #46b/§65, Band C in der Reihenfolge #34 CLI → #35 `.so` → #36 → #44 → #38 → #37).
  Owner-Wunsch woertlich: "dass wir heute nach dem Start des geplanten Build+Messlauf alle noch offenen
  Punkte und Baender abarbeiten, soweit wie definiert."
  — `project_20260726_nach_trigger_alle_baender_abarbeiten.md`, 26.07.2026, OWNER-WORT.
- **A-4** Sieben Owner-Entscheide vom 26.07., bindend: (1) W-13 FIXEN vor Trigger. (2) **Bestandslog AN im
  Voll-Bau-4** — `run_planer_driven_provision` ist der Haupttreiber, der ERSTE Voll-Build laeuft MIT voller
  Bestandslogik (Option B); Bestandslog wird beim Build **und** beim Messen **je Realm** fortgeschrieben.
  (3) N7-Lock nicht aufschieben. (4) (d2)/E1-E5 in aller Gruendlichkeit, Vertagung nur mit expliziter
  Abnahme. (5) Scrub-Fenster: anhalten, der User stoesst Infra an. (6) **Voll-Build + Voll-Messung
  ersatzlos**; die erste Mess-CSV rechtzeitig aufs NAS ist der Beweis fuer Prof. Habich, LaTeX/PDF danach;
  **kein Mess-Teillauf vorgezogen**. (7) **Nach dem Scrub BEIDE Remotes public** — nur die
  Diplomarbeit-Repos, die uebrige Forschung (Products) bleibt nicht-public.
  — `project_20260726_nach_trigger_alle_baender_abarbeiten.md`, 26.07.2026, OWNER-WORT.
- **A-5** Dual-Weg-Pflicht: nach Fertigstellung der Baender ein LOKALER Beweis (cmake + Shell, offizielle
  Targets, §61); der lokale Build-Stand war erheblich hinterher und ist ein eigenes TODO (Board #10).
  — dieselbe Datei, 26.07.2026, OWNER-WORT.
- **A-6** Messlauf **#9916** (`measure:golden-320`, prod1 Runner id=16) lief mehrtaegig als bewusster
  Proof-of-Concept **unter Fremdlast** — Owner: die Maschine wird parallel gebraucht, Geduld ist vorhanden;
  die echte Kampagne kommt spaeter lastisoliert.
  — `project_diplomarbeit_stand_20260712_freigaben_pipeline.md`, 12.07.2026, OWNER-WORT.
  STAND: UEBERHOLT als Ereignis, gueltig als Doktrin (PoC unter Last ist zulaessig, Kampagne nicht).

**Aus der zweiten Welle (die 49):**

- **A-7** **OD-7 im Wortlaut** (Primaerquelle; W-01/W-02/W-21 haengen daran), Owner 26.07.2026 abends
  (~18:40): "**OD-7 NEUE Runner-Zahlen:** heavy (Tier-Binary-Build ODER Messung): **concurrency=1,
  prod1=24 Worker, prod2=alle Threads**; normal: **BEIDE concurrency=2 x je 12 Threads.**
  => Infra-HANDOUT (Kanal siehe `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus`)."
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
- **A-8** **Thread-Budget Batch-Compile**, Owner 22.07.2026 woertlich: "Thread-Budget fuer Batch-Compile:
  **prod1=32T/24K, prod2=24T/16K** (User-Vorgabe = verfuegbare Kapazitaet); alle Threads NUR je einzelnem
  Batch-Compile voll ausschoepfen — maximale Kerne fuer CEB-Batch- UND Planer-CEB-Compile." Im selben
  Nachtrag: waehrend fuer das Bestandslog kompiliert wird, ist es **MULTI-WRITE** freigegeben (Reservierungs-
  Eintrag = Millisekunden); Haupt-Blocker ist allein die **ETA-Berechnung**. **Batch-Typen CEB-Compile und
  Tier-Binaries auf derselben Maschine NIE gemischt** (sequentiell).
  — `project_62_planer_universal_cache_log_claim_compare.md` (NACHTRAG-8), 22.07.2026, OWNER-WORT.
- **A-9** **T-WERT-KORREKTUR mit Messung**, Owner 23.07.2026 mittags woertlich: "**AMD worker bitte auf 24
  Threads drosseln**" — Empirie im selben Eintrag: **amd@32W 19,95 min == amd@24W 19,4 min**, aber
  **20G Swap + OOM-Kills** paralleler CI-Jobs auf der **60G-RAM-Maschine**. Neu:
  `lane_build_parallelism` **amd=24, intel=24**. Zusaetzlich vorgezogen: "fuer die Lagerhaltung VOR der
  Abgabe noch **Pruning** einfuehren" + **Ebene-B-Push-Aktivierung VOR Voll-Bau-4-Neustart**
  (Binary-Verlust-Schutz, Pakete P-A/P-B/P-C). — dieselbe Datei, 23.07.2026, OWNER-WORT + MESSUNG.
- **A-10** **Die prod2-ICE-Episode vom 08.07.2026, mit Wurzel.** Symptom: Downstream-Pipelines failen mit
  `internal compiler error: Segmentation fault` in g++ (**beide** g++-13 UND g++-16), gekoppelt an
  `Failed to extract cache`, in Schwer-Template-Dateien (gtest, anatomy_perm-Module, unicode.h/
  system_error/type_traits); je Lauf ICEn **andere** Downstreams. Zwischenbefund (Infra-Beleg **`b30d122`**):
  RAM-druck-korreliert — **prod2** = 62-GB-Host mit **5 VMs** (talos/opn-2/samba/win11/win2022), nur
  **~12 GB Runner-Budget**, `earlyoom` killt `cc1plus`; prod1 hatte **157 GB** frei. Seit 08.07. lief prod2
  auf **`concurrent=3 x -j10` = bis 30 Compile-Threads**. **WURZEL BEHOBEN am selben Tag (Cluster K89d):**
  prod2s `[runners.cache.s3]` zeigte noch auf `minio.prod.comdare.de` (DNS → 10.0.10.1 = V10-VIP **ohne**
  9000-Frontend = toter Endpoint) → "Failed to extract cache" → Cold-Build → ICE. Fix: prod2 auf dev-MinIO
  nachgezogen (`minio.comdare.de:9000` / Bucket `buildsystem-cache` / V60-hosts-Pin `10.0.60.1`,
  Secret file-to-file von prod1), **Round-Trip PUT200 / GET200 / DELETE204 bewiesen**. Zusaetzlich
  `concurrent` **3 → 2** auf prod1+prod2 und `CMAKE_BUILD_PARALLEL_LEVEL` **10 → 8**. Fehlerraten vorher:
  **prod2 36 % gegen prod1 11 %**. — `reference_ci_runner_ice_cold_cache_instability.md`, 08.07.2026,
  MESSUNG. STAND: liefert das fehlende Kettenglied vor dem 12.07.-Wert in W-01.
- **A-11** **Drei Kriterien, an denen eine ICE als transient (nicht Code) erkannt wird:** (a) die
  **Push-Pipeline** (`source=push`) desselben Commits ist gruen; (b) ein **docs-only-Commit** (kann keinen
  Build aendern) failt trotzdem seine Umbrella; (c) je Lauf sind **andere** Downstreams rot.
  **Handlungsregel:** max **1x** re-triggern, danach "bestaetigte Episode → leave-as-history"
  (Ledger-Praezedenz **8775**). **KEIN Retry-Loop, KEIN weiterer super-Push** — denn **jeder super-Commit,
  auch docs-only, triggert die VOLLE Umbrella** (`trigger:cache-engine` + `:prt-art` + `:thesis` = drei
  Voll-Rebuilds) und verliert dieselbe Lotterie erneut. Der Code-Gruen-Beweis ist die Push-Pipeline, das
  Umbrella-Rot wird als Infra ausgewiesen. — dieselbe Datei, 08.07.2026, AGENTEN-BEHAUPTUNG (Verfahren)
  + MESSUNG (Belege).
- **A-12** **Sequentialitaets-Constraint (User 18.07.2026, als KRITISCH markiert):** das Schreiben der
  Binaries (Cache-Push nach minio) UND der Ergebnisse (Rueckschrieb nach NFS) muss **SEQUENTIELL zu den
  Messungen** erfolgen — **NIE parallel waehrend einer Messung**, sonst erzeugt die Cache-/Ergebnis-I/O
  **Messfehler** (I/O-Contention verfaelscht die Timing-Messung). Also: messen (isoliert, keine
  Nebenlaeufigkeit) → DANN Cache-/Ergebnis-Schreiben, nie ueberlappend. Der Cache-Push/Pull darf die
  gemessene Op nicht beruehren. — `feedback_incremental_tier_binary_caching.md`, 18.07.2026, OWNER-WORT.

### 3.2 Delegation, Modelle und Codex-Betrieb

Sieben der 57 Dateien bilden einen geschlossenen **Codex-Workflow-Cluster**; drei weitere tragen die
Delegations-Doktrin. Keine davon ist im Index verlinkt (siehe W-05).

**Wer implementiert (Historienkette, jede Stufe mit Datum):**

- **B-1** Bis 10.07.2026: **Codex** implementiert erstimplementierend, Claude ist Manager.
  Grundregel, User 01.07.2026: fuer jede Code-Aufgabe (1) ein "unglaublich ausfuehrliches" Dossier
  (Auftrag, Architektur-Kontext, exakte `file:line`-Verweise, SOLL-API, Constraints/Verbote, DoD,
  Test-Erwartungen), Codex implementiert; (2) Claude korrigiert den Vorschlag danach **selbst**.
  — `feedback_codex_implements_from_dossier_claude_corrects.md`, 01.07.2026, OWNER-WORT.
- **B-2** Parallelitaet: bis zu **16 Agenten parallel im Hintergrund** bei mcp-codex-Workflows mit ultracode,
  solange **disjunkt** (keine ueberlappenden Dateien/Module). Verbindlich ab 03.07.: Codex NIE mehr als
  einzelner blockierender `mcp__codex__codex`-Call — immer ueber das Workflow-Tool.
  — dieselbe Datei, 01./03.07.2026, OWNER-WORT.
- **B-3** VERSCHAERFUNG, User 06.07.2026 (/goal-Nachtrag), woertlich: "**Korrigiere Fehler manuell und ohne
  codex. Wir verwenden codex nur zur Erstimplementierung um tokens zu sparen.**" Alle Korrekturen,
  Bugfixes, Pipeline-Fixes und Nacharbeiten macht Claude selbst.
  — dieselbe Datei, 06.07.2026, OWNER-WORT.
- **B-4** RE-BEKRAEFTIGUNG, User 07.07.2026, woertlich: "Merke dir fuer das Programmieren von Code, dass du
  die Erstimplementierung immer zuerst mit codex durchfuehrst". Klarstellung 09.07. woertlich: "Ich hatte
  codex nicht abgelehnt und sonst auch vollstaendiges GO fuer alle Punkte. Bitte weiterhin codex als
  Erstimplementierung versuchen und nur als fallback selbst implementieren — das spart tokens." Eine im UI
  abgelehnte einzelne Tool-Anfrage ist **keine** inhaltliche Ablehnung.
  — dieselbe Datei, 07./09.07.2026, OWNER-WORT.
- **B-5** Eskalationspfad je Codex-Lauf (09.07.): (a) brauchbar → Zeile-fuer-Zeile-Review + gezielte
  Abschnitts-Korrekturen; (b) kleinere Verstoesse → nur betroffene Abschnitte manuell korrigieren;
  (c) Komplett-Scheitern → Claude implementiert selbst vollstaendig, **kein Retry-Loop**.
  — dieselbe Datei, 09.07.2026, OWNER-WORT.
- **B-6** Codex auch fuer **Migrationen** (#274-Schritte 5-7, Monolith-Splits, #32-Instanz-Repos/Naming-
  Sweeps): (1) Claude bereitet die Zielstruktur selbst vor, (2) Codex migriert mit elaboriertem Dossier,
  (3) Claude kontrolliert Zeile fuer Zeile und korrigiert manuell.
  — dieselbe Datei, 07.07.2026, OWNER-WORT.
- **B-7** Sicherheits-Constraint durchgaengig: **NUR** Code-Repos (cache-engine / prt-art / super / thesis),
  **NIE** Cluster oder `keys/`; `modules/*` und `ext/` bleiben fuer Codex tabu.
  — dieselbe Datei, OWNER-WORT/AGENTEN-BEHAUPTUNG.
- **B-8** Ab 19.07.2026: Implementierung so weit wie moeglich an **Opus-4.8-Agenten** delegieren; Fable 5
  (Hauptsession) ist Software-Architekt und Manager, **nicht** Implementierer; bei Agent-/Workflow-Aufrufen
  explizit `model: 'opus'`. — `feedback_implementierung_an_opus_delegieren_fable_als_architekt.md`,
  19.07.2026, OWNER-WORT. **STAND: UEBERHOLT** — die Datei erklaert sich selbst fuer SUPERSEDED
  (26.07.2026) durch B-9.
- **B-9** Ab 26.07.2026 bindend: alle delegierten Agenten (Planungs-Leser, adversariale Pruefer,
  Implementierer, Verifikatoren, Backup-/Scrub-Agenten) laufen als **Fable 5, Reasoning xhigh**, nicht als
  Opus. Agent-Tool immer `model: "fable"`, Workflow-`agent()` explizit `model: 'fable'`. Anlass: Opus 5
  baute in derselben Session ein Auftrags-Doc mit **drei Achsen-Fehlern** (`load_framework` faelschlich als
  4. Haupt-Achse; NUMA/page auf reine RT reduziert entgegen dem Dual-Natur-KERN; AVX512 vergessen) plus
  voreiligem Bau vor fertiger Planung. Gilt, bis der Owner es ausdruecklich revidiert.
  — `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus.md`, 26.07.2026, OWNER-WORT.
- **B-10** AUSNAHME OD-3 (26.07. abends), Owner woertlich: "Fable 5 unterbindet infra Themen generell, das
  blockiert die API, verwende dafuer immer einen Agenten **Opus 5 xhigh**, recherchiere gerne die limits von
  Fable 5." Praezisierung direkt danach, woertlich: "**Infra wird bitte per Handout an den Infra
  weitergeleitet wenn etwas ansteht.**" Kanal: Infra-Anliegen (Runner-Konfig, GitLab-Admin, Deploy/Token,
  Cluster-Betrieb) gehen als HANDOUT-Dokument ins Cluster-git (development, gitlab-only, fetch+merge).
  Muss dennoch eigenstaendige Infra-AUSFUEHRUNG delegiert werden: `model: 'opus'` xhigh, nie Fable
  (sonst API-Block der Session). — dieselbe Datei, 26.07.2026, OWNER-WORT.

**Wie Codex betrieben wird:**

- **C-1** Modell/Effort, drei belegte Zustaende in Reihenfolge:
  (1) **`gpt-5.5` + `xhigh`** — User 05.07.2026 woertlich: "Bitte stelle codex plugin mcp immer auf das
  neueste modell und auf xhigh."; MCP-Registrierung
  `claude mcp add codex --scope user -- codex mcp-server -c 'model="<neuestes>"'
  -c 'model_reasoning_effort="xhigh"'`.
  (2) **`gpt-5.6` + `max`** — User 10.07.2026, `~/.codex/config.toml`, sed-verifiziert.
  (3) **KORREKTUR, literal getestet 10.07.2026:** `gpt-5.6` → **API-400** "not supported when using Codex
  with a ChatGPT account"; Effort `max` → **API-400** "Supported values: none/minimal/low/medium/high/xhigh"
  → zurueck auf das verifizierte Maximum `gpt-5.5` + `xhigh`.
  (4) **NACHTRAG 03.08.2026 (Owner-Order 01.08., "VOLLZOGEN + Smoke-belegt"):** seit 01.08. gilt
  **`gpt-5.6-sol` + Effort `ULTRA`** (`config.toml` + `~/.claude.json`, Codex **0.146.0**), Fallback-Kette
  sol+max → niedrigere Stufen. Die 10.07.-Korrektur ist damit ausdruecklich **VERDRAENGT**.
  — `feedback_codex_mcp_always_newest_model_xhigh.md`, 05.07.–03.08.2026, OWNER-WORT + MESSUNG.
  Diese Datei ist das Musterbeispiel fuer "eine Zahl galt, wurde widerlegt, eine neue trat an ihre Stelle".
- **C-2** Schreibrechte, Owner 06.08.2026 woertlich: "Weiterhin fragt mich codex staendig um erlaubnis per
  mcp, bitte in Zukunft **die Rechte zum Schreiben mitgeben**". Pflicht-Parameter bei **jedem**
  `mcp__codex__codex`-Aufruf: `"approval-policy": "never"`, `"sandbox": "workspace-write"`,
  `"cwd": "<Worktree-/Repo-Pfad>"`. Gilt fuer Review-Lenses wie fuer Bau-Konsultationen; Lens-Agenten
  bleiben trotzdem read-only. — `feedback_codex_mcp_schreibrechte_mitgeben.md`, 06.08.2026, OWNER-WORT.
- **C-3** **Codex darf niemals `git` ausfuehren.** Ursache ALLER Codex-Timeouts des 06.08., reproduzierbar
  **2/2** belegt: laesst man Codex `git diff`/`git log` im Worktree absetzen, haengt der Call zuverlaessig
  bis in den **1800s-MCP-Idle-Timeout** ("sent no response or progress") — trotz korrekt gesetzter Rechte.
  Gegenprobe: ein trivialer `pwd`-Call im selben Thread laeuft in unter einer Minute durch. Verdacht
  (nicht bewiesen): Pager-Blockade, kein bwrap-Totalausfall. **Verifizierter Workaround:** DIFF-TEXT im
  Prompt mitliefern, fuer Zusatzkontext auf Datei-Lesewerkzeuge (kein Shell) verweisen — Antwortzeit danach
  **unter 5 Minuten**. — dieselbe Datei, 06.08.2026, MESSUNG.
- **C-4** `workspace-write` scheitert auf prod1 seit 07.07.2026 mit
  `bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`. Wurzel bestaetigt:
  `kernel.apparmor_restrict_unprivileged_userns = 1` (Ubuntu-AppArmor, Kernel 6.17); manueller Repro
  identisch mit `bwrap --unshare-net --dev-bind / / true`; bubblewrap 0.9.0; sudo nur mit Passwort.
  **Workaround (verifiziert):** `sandbox: "danger-full-access"` ueberspringt bwrap komplett
  (`pwd && echo CODex_SHELL_OK` → OK) — dann aber cwd aufs Ziel-Repo pinnen und die Tabus explizit in den
  Prompt schreiben (NIE `~/Projekte/Cluster`, NIE `keys/`, keine Remote-Mutationen).
  **Sauberer Fix (nicht ausgefuehrt, braucht sudo):** `/etc/apparmor.d/bwrap` mit
  `profile bwrap /usr/bin/bwrap flags=(unconfined) { userns, }`, dann `sudo apparmor_parser -r
  /etc/apparmor.d/bwrap`. Weniger sauber: `sudo sysctl kernel.apparmor_restrict_unprivileged_userns=0`.
  — `reference_codex_mcp_prod1_bwrap_shell_broken.md`, 07.07.2026, MESSUNG. STAND: am 09.08. noch defekt.
- **C-5** `codex exec` bricht mit "**STOPP gemaess §8: kann nicht ohne Verletzung der Routing-Auflage
  arbeiten — /workflow-orchestrator:delegate nicht verfuegbar**" ab, weil `~/.codex/` denselben
  `workflow-orchestrator@barkain-plugins` traegt und dessen `SessionStart/inject_all.py`-Hook die
  Delegate-Pflicht als **Developer-Instruktion** injiziert. Zwei gescheiterte Fixversuche: Plugin per
  `-c 'plugins."...".enabled=false'` abschalten (Hooks in `[hooks.state]` sind separat getrusted und feuern
  trotzdem) und ein Prompt-Preamble (Codex antwortet: "Dein Override … kann diese Developer-Regel nicht
  ausser Kraft setzen" — User-Prompt < Developer-Injektion).
  **FIX, funktioniert:** temporaeres `CODEX_HOME` mit gefilterter `config.toml`
  (`awk '/^\[/{keep=($0~/^\[features\]/||$0~/^\[projects\./||$0~/^\[notice/)?1:0} keep{print}'`),
  `auth.json` mitkopieren, dann `codex exec -C "$CE" -s workspace-write -m gpt-5.5
  -c 'model_reasoning_effort="xhigh"' --skip-git-repo-check < dossier.md`.
  **Nicht tun:** `--ignore-user-config` allein (killt Hooks, verliert aber Trust → Banner faellt auf
  `sandbox: read-only`); `codex plugin remove/disable` (mutiert die globale `config.toml`).
  — `reference_codex_routing_block_preamble_fix.md`, 04.07.2026, MESSUNG.
- **C-6** Codex-Laeufe legen eine Datei namens `$null` im Repo-Root ab (PowerShell-Redirect-Muster,
  Teil des F-J-Junk-Musters). Owner 04.07.2026 woertlich: "**Die junk null kann man nicht loeschen, wir
  ignorieren sie.**" `rm -f '$null'` scheitert (OneDrive-/Windows-Lock) — **der Loesch-Tool-Call wurde vom
  User rejected**, der Versuch ist also am Objekt belegt, nicht bloss vermutet. Schutz: gezieltes Staging
  (`git add <konkrete Pfade>`, **nie** `git add -A`) — `$null` bleibt als `?? $null` in `git status` und ist
  dort **harmlos**. Die Regel gilt fuer `$null` **und andere Codex-Junk-Artefakte** gleichermassen:
  stehenlassen, nie ins Commit-`git add` aufnehmen. Begruendung der Quelle: Loeschversuche sind vergeblich,
  kosten Zeit und provozieren Rueckfragen.
  — `reference_codex_null_junk_artifact_ignore.md`, 04.07.2026, OWNER-WORT.
- **C-7** Cross-Review-Pflicht: bei jeder Code-Aufgabe den Implementierungsstand mit dem Codex-MCP-Agenten
  gegenreviewen und Feedback einholen, **bevor** die Aufgabe als fertig gilt. ALLE Review-Aufgaben ans
  Codex-MCP delegieren (Token-Ersparnis, laeuft cross-model statt im Hauptkontext). VOR teuren
  ultracode-Workflows laesst man Codex das Scoping machen (Codex sagt, WO nachzulesen ist) — dabei nur Task
  und Datei-/Struktur-NAMEN uebergeben, **keine** Secret-/Credential-Inhalte. Alle Aenderungen am
  Diplomarbeit-Text (Kapitel-`.tex`, DE+EN) ebenfalls von Codex gegenreviewen, read-only,
  `cwd = thesis/diplomarbeit`. Vor Beginn einer neuen Session Codex den Referenz-Stand der letzten
  **5** bearbeiteten Sessions zusammenfassen lassen (`docs/sessions/`, neueste 5). Setup-Doku:
  `Diplomarbeit - Datenbanken/docs/CODEX-CROSS-REVIEW-SETUP.md`. Codex-Feedback ersetzt **keine** echten
  Test-Belege. — `feedback_codex_mcp_review_before_code_complete.md`, 27.06.2026, OWNER-WORT.
  STAND: Verfahrensregeln gelten; die Modellzeile dieser Datei ist ueberholt (W-04).
- **C-8** **Jedes** Codex-Artefakt wird vollstaendig manuell reviewt. User 05.07.2026 woertlich: "Bitte merke
  dir alle Dokumente von codex bitte stets nochmal manuell zu reviewen, sobald es fertig ist."
  Vier Pflicht-Schritte vor Commit: (1) jede neue Datei per Read **vollstaendig** lesen, (2) jede
  modifizierte Datei per `git diff` im **Volltext** pruefen (nicht nur grep-Auszuege), (3) bei
  faithful-Ports die Kern-Logik gegen die Referenz-Quelle abgleichen, (4) Befunde im Commit-Text
  dokumentieren ("manuell reviewt: …").
  **VERSCHAERFUNG, User 06.07.2026 woertlich:** "Du hattest laufend entgegen meiner Anweisung vergessen,
  Codex-Arbeit **Zeile fuer Zeile** gegenzupruefen. Bitte merke dir, das zu tun." Anlass: in der
  Nacht-Session vom 06.07. (S7-5..10 / AP-15-2/3 / #264 a-c) wurde der Review wiederholt ausgelassen —
  Ergebnis laut User: inkonsistenter Stand plus nicht mehr durchlaufende GitLab-Pipeline.
  Konsequenz, als unverhandelbar markiert: kein Codex-Increment gilt als "done", bevor JEDE angefasste
  Datei komplett gelesen und JEDER Diff im Volltext geprueft wurde — unabhaengig davon, wie gruen die
  Claims aussehen. — `feedback_codex_outputs_always_full_manual_review.md`, 05./06.07.2026, OWNER-WORT.
- **C-9** Liefert Codex keine sicheren/eindeutigen Ergebnisse (unklarer Befund, §7-STOPP, widerspruechlich,
  nicht literal verifizierbar): **nicht raten, nicht blind uebernehmen** — Rueckfall auf den
  ultracode-Workflow (fan-out + adversariale Verifikation bis Klarheit).
  — `feedback_codex_uncertain_fallback_to_ultracode.md`, 04.07.2026, OWNER-WORT.
- **C-10** Explore-Pairing: bei **jedem** Explore-/Mapping-Aufruf parallel denselben Prompt an einen
  `mcp__codex__codex`-Agenten (sandbox `read-only`, approval `never`, `model_reasoning_effort: xhigh`,
  Modell weglassen). Konvergenz = hohe Konfidenz; Divergenz = genauer hinschauen vor jedem Edit.
  — `feedback_pair_explore_with_codex_same_investigation.md`, ~07.07.2026, AGENTEN-BEHAUPTUNG.
  STAND: moeglicherweise durch das 2-STUFIG-Verfahren verdraengt (W-06).

**Aus der zweiten Welle (die 49):**

- **C-11** **Codex kann UTF-8 zu Mojibake doppelkodieren.** Befund 05.07.2026 (AP-15-1, ce
  `conformance_gate.hpp` + 2 Tests): Codex (gpt-5.5, Windows) las beim Umschreiben einer UTF-8-Datei die
  UTF-8-Bytes als cp1252 und schrieb sie als UTF-8 zurueck — **alle** Nicht-ASCII-Zeichen betroffen:
  `Konformität`→`KonformitÃ¤t`, `—`→`â€"`, `§`→`Â§`, auch in NEU eingefuegten Strings
  (`übersprungen`→`Ã¼bersprungen`). **clang-format und alle Test-Claims blieben gruen — nur der Voll-Review
  (Datei lesen) fand es.** Pflicht-Check nach jedem Codex-Lauf: `grep -c "Ã\|â€" <angefasste Dateien>`
  muss **0** sein. **Reparatur:** zeilenweise nur betroffene Zeilen, **cp1252 ZUERST**, dann latin-1 —
  denn das `€` in `â€"` existiert in latin-1 **nicht**; latin-1 allein repariert nur die `Ã¤`-Klasse, die
  `â€`-Klasse (em-dash, Anfuehrungszeichen) braucht cp1252. Danach erneut greppen + clang-format dry-run.
  — `reference_codex_utf8_mojibake_double_encoding.md`, 05.07.2026, MESSUNG.
- **C-12** **Codex-Betriebszustand auf prod1 am 05.07.2026:** eingeloggt (ChatGPT), bubblewrap-Sandbox
  defekt (`bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted`) — `--sandbox workspace-write`
  startet **keinen** Prozess und kann nicht einmal Dateien lesen. Workaround schon damals:
  `--sandbox danger-full-access` + temporaeres `CODEX_HOME` (Config ohne `/root`-Trust-Eintrag, mit Trust
  auf den ce-Pfad) + TABUs im Dossier + Voll-Review.
  — `reference_prod1_comdare_env_setup.md`, 05.07.2026, MESSUNG. **Das datiert W-15/W-27 neu.**

### 3.3 Architektur-KERNe: Gattung, Genus, Achsen, Messmodell

- **D-1** Owner-KERN A5, 05.08.2026 (abend-10), woertlich: "**MAP grundsaetzlich eine key und eine value
  Filter-Achse**". Einordnung des Agenten (nicht Owner-Wort): Sortierungen zaehlen als Key-Filter-Klasse.
  Es existieren **4 Umsetzungs-Optionen**, die bewusst **unbewertet** bleiben; der Folgeentscheid faellt
  erst **nach Abgabe**, als Register-Zeile. Ausdrueckliche Abgrenzung: **nicht** zu verwechseln mit der
  Sortier-REIHENFOLGE der 18 Achsen.
  — `feedback_a5_sortierung_key_filter_map_value_filter_achse.md`, 05.08.2026, OWNER-WORT.
- **D-2** Owner-KERN 06.08.2026 (im Zuge der E4/17-Ratifikation), woertlich und **ungekuerzt**: "Wir halten
  fest, dass aus einer Interface Funktion einer Gattung->Genus immer alle in der interface Funktion (etwa
  eines Suchalgoritmus) vollzogenen Messparameter abrufbar sind, die waehrend des Aufrufs durchlaufen wurden,
  zusammen mit einem **zeitlich geloggten Profil der Achsen-Zugriffsmuster**. **Wir hatten festgelegt, dass
  alle Achsen ein einheitliches Interface haben.** Die Gattung->Genus verwendet in der Gattung einen **Kern**
  der Interfacefunktionen der Tier-Binary und im Genus eine **spezifische Erweiterung** (etwa bei Containern
  hat ein `std::vector` zwar ein `push_back` und das haben alle Container, aber es hat nicht wie eine double
  liked list ein `push_front`) **und verwendet in den Funktionen jeweils die Achsen, um die Funktion
  abzubilden.**"
  **Warum ungekuerzt:** eine fruehere Fassung dieses Dokuments hatte den Mittelteil durch "[…]" ersetzt und
  dabei genau die beiden Saetze verloren, die den KERN erst binden — den Satz zum **einheitlichen
  Achsen-Interface** und den Satz, dass die Interface-Funktionen sich **ueber die Achsen abbilden**. Dies ist
  die einzige Stelle, an der das einheitliche Achsen-Interface im Owner-Wort an diesen KERN gebunden ist.
  — `feedback_gattung_genus_interface_messparameter_achsen.md`, 06.08.2026, OWNER-WORT.
- **D-2a** Die Ableitung derselben Datei ("How to apply") haelt beide Saetze noch einmal fest, woertlich:
  "**Achsen sind die Bausteine der Funktions-Implementierung.**" und "**Einheitliches Achsen-Interface
  bleibt.**" Ebenfalls dort: **Gattung** = mathematischer KERN der Tier-Binary-Interface-Funktionen (alle
  Genera teilen ihn, z.B. `push_back` bei allen Containern); **Genus** = spezifische Erweiterung
  (`push_front` **nur** wo das Substrat es traegt, z.B. doubly-linked list, **nicht** `std::vector`).
  — dieselbe Datei, 06.08.2026, AGENTEN-BEHAUPTUNG (Ableitung aus dem Owner-Wort in D-2).
- **D-3** NACHTRAG desselben Tages, Owner woertlich: "mir besonders welche Genus es unter jeder Gattungen
  gibt, welchen Interface Kern sie nach aussen im gemeinsamen Gattungs-Kern teilen, und wie jeweils ihre
  Mikro-, Makro- und Wallclocktime-Messung eingebunden wird. Das ist ein **vierter Layer der Observer Stufe
  im Vertrag zwischen CEB und Tier-Binary**!" Rahmungs-Korrektur, Owner woertlich: "der Architektur-Kern ist
  **VERGESSEN und GEPLANT**, aber er ist nicht neu fuer die observer und die Mess-struktur" — der vierte
  Layer ist keine neue Entscheidung, sondern die Wiederherstellung eines geplanten, in der Layer-Darstellung
  vergessenen Kerns. Plan-Traeger: Doku 24 (§8.6/§8.7), I1-Konsolidierung, E-24-C6-Serie.
  — dieselbe Datei, 06.08.2026, OWNER-WORT.
- **D-4** Objekt-Beleg (ce `anatomy/`, Stand Commit `c837d830`): `AnatomyGenus`
  (`anatomy_base.hpp:98-107`) = **SearchAlgorithm** (Gattung **Map**, volle 18-Organ-Anatomie) plus
  **Set / Sequence / Adapter / View** (Gattung **Container**, Tier-Metaphern Bird/Reptile/Invertebrate/
  Plant) = **die 5 Genera**. Die **Graph-Gattung ist Zielbild**, nicht Bestand.
  — dieselbe Datei, 06.08.2026, MESSUNG.
- **D-5** Die CEB spricht ausschliesslich das ABI-stabile **Gattungs**-Interface: Map →
  `tier_insert`/`lookup`/`erase`; Container → `ISetTier` / `ISequenceTier` / `IAdapterTier` / `IViewTier`
  plus eigenstaendige V2-Sub-Interfaces (append-only). Observer-Stufe: **genau EINE**
  `IObservableTier::tier_observe` und **EIN** versionierter POD (`axis_stats` + `seg_ns`,
  ABI-Major-versioniert, `observable_tier.hpp`, Kennung I1). C6-Ebene:
  `GenusObserverAggregate<G,N>` = EIN Wire-Layout, VIER genus-getaggte Container-Formen
  (`Set<13>` / `Sequence<9>` / …), **8 Spalten je Achsen-Slot + 4 Gattungs-Zaehler**; Schema-Tabelle
  `GenusAxisFieldNames` ist Single Source; Zeilen-Schreiber `genus_axis_row_writer.hpp`.
  — dieselbe Datei, 06.08.2026, MESSUNG.
- **D-6** **KANON-REKONSTRUKTION des Messmodells** (nach der Owner-Korrektur, quellen-geerdet). Bindende
  Quelle: ce `docs/architecture/messarchitektur_v5_design.md` (Status "bindend", 31.05., im Juli aktiv
  zitiert LED:3390). (1) **Kartesisches Mess-Kreuz** (§2, Z.71-100): Achse 1 = **Build-Profil**
  (Tier-Binary-Permutation), Achse 2 = **Lastenprofil** (host-seitig zur Laufzeit, keine CMake-Flags;
  YCSB A-F, OP-1..6, seed, Pausen, Checkpoints). (2) **Zwei-Phasen-OP-Schleife** (§4, Z.176-190, "pro Op
  GENAU 2x, bindend"): je Op (1) `tier_save_all` (2) op-Erstausfuehrung (3) `tier_rollback_all`
  (4) op-measure = wallclock-umklammert (`detail::abi_dur_ns`) plus Observer gleichzeitig → Wallclock wird
  je **Tier-Binary-Interface-Funktion x Last-Kombination** (YCSB-Profil x OP-Typ, §5 Z.193-207,
  `IMeasurableWorkloadHost`) jeweils gemessen. (3) **Zwei-Dimensionen** (Doku 24 §8.1/§8.7) bleibt gueltig:
  dieselbe Messung erhebt Wall-Clock UND Achsen-Statistik als zwei korrelierte Dimensionen; `seg_ns` ist
  eine **orthogonale dritte Groesse** (reale Per-Achsen-Segmentzeit innerhalb einer Op, Doku 31:42,
  `observable_tier.hpp:134/141-142`, Coverage ~100% gegen eigene Wall-Clock). (4) Die Begriffe MIKRO/MAKRO
  stammen **nur** aus der §47/§54-T2 Mess-Tooling-HAUPT-Achse (LED:2282ff, 20.07.) = CT-Auswahl-Achse
  {nur Wallclock / Makro-Benchmarks / Micro-Benchmarks ueber Observer} fuer die CEB-Bestueckung,
  Default = Vollmenge in EINER CEB (LED:3383); sie waren nie technisch praezisiert und nie eine Aussage
  ueber Wallclock-Granularitaet. Selbstkorrektur des Agenten woertlich: "Meine Projektion auf
  `axis_stats`/`seg_ns` war **Fabrikation**." — dieselbe Datei, 06.08.2026, MESSUNG + AGENTEN-BEHAUPTUNG.
  Siehe W-07 fuer die offene Frage F6.
- **D-7** **E14 / NoFilter-Identitaet:** Owner 06.08.2026 woertlich: "**die Eingabe ist einfach die
  ausgabe**". Das NoFilter-Blatt der Filter-Achse (Kennung **T16**) ist die Identitaetsfunktion — damit wird
  der A/B-Nutzen-Beweis der Filter-Achse (gegen filterlos) baubar. Status: **volles GO**, Bau im
  P2-Bau-Fenster als deklariertes Registry-/golden-Ereignis.
  — `feedback_e14_nofilter_identitaet_und_e4_deep_research.md`, 06.08.2026, OWNER-WORT.
- **D-8** **E4/17 (T17, Persistenz-Achsen-Min/Max-Semantik):** ratifiziert — ABER die Bestimmung, ob fuer
  JEDEN Parameter aus dem Achsen-Interface **min oder max** optimal ist, braucht eine **Deep Research** ueber
  die Observer (Messparameter-Rueckgabe je Interface-Funktion). Timing: nach Trigger, vor der Auswertung
  (Phase-6-nah). — dieselbe Datei, 06.08.2026, OWNER-WORT. STAND: Deep-Research-Teil offen.

---
### 3.4 Hybrid-Stufe, Stempel und Versionsgrammatik

Vier Dateien tragen das **Owner-Entscheide-Paket vom 02.08.2026** aus
`super docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`.
Alle vier sind unverlinkt, obwohl das Paket als **trigger-blockierend vor Voll-Bau-4** bezeichnet wird.

- **E-1** **Hybrid-Tier = eigene Stufe HINTER der CEB** (Owner-Entscheid E1, 02.08.2026). Sie traegt
  **mehrere ABI-stabile Pruef-Docks** und nutzt fuer deren Einsatz das **Factory Pattern als Proxy** auf
  ihre Tier-Binaries — dafuer als **Ausnahme `std::variant`** in einem wahlweise statischen oder
  Runtime-Array (Dock-Anzahl dynamisch einstellbar). Zwischenloesung "statische Pruef-Docks gegen
  austauschbare plain Tier-Binaries je Pruefdock" = **XML-Konfiguration auf Anwenderwunsch in der
  Auswertungsphase**. In plain Tier-Binaries bleibt `std::variant` **verboten** — die Ausnahme gilt NUR fuer
  die Hybrid-Stufe. Designplanung zwingend Fable 5 xhigh + ultracode; Bau erst in der Auswertungsphase.
  — `feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme.md`, 02.08.2026, OWNER-WORT.
- **E-2** NACHTRAG, Owner-KERN 05.08.2026 woertlich: "**die Hybriden [sind] ein factory pattern - facade -
  Adapter**" — Factory (Dock-Einsatz), Facade (virtuelles ganzes Tier-Binary nach aussen), Adapter
  (Command-Delegation an statisch zugewiesene echte Tiers); **ORGAN-FREI**. Der Hybrid erbt **alle**
  Eigenschaften der vorausgegangenen Stufen (Mess **drei**-stufig, System **zwei**-stufig dehnbar) und gibt
  Mess- UND System-Config **CT** an anhaengige Tiers weiter. Offener Posten 90: Design-Doc bei Bau um die
  GoF-Einordnung ergaenzen. — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **E-3** **Stempel-Regression E2** (02.08.2026): siehe W-16 — Meta-Meta ans Realm-Ende, **keine
  merge-Zeile**, `e`-Suffix fuer experimentelle Achsen-Algorithmen, das 5-Zeilen-Layout ist defekt.
  Umsetzungsreihenfolge: merge-Zeile entfernen → Meta-Meta-Anhaengung bauen → `e`-Versionierung einfuehren →
  OP-11 zurueckbauen → SHA512-Skip-Gate / G-E6 erst danach.
  — `feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende.md`, 02.08.2026, OWNER-WORT.
- **E-4** **OS-Unter-Achsen E3** (02.08.2026): die **drei** finalen OS-Unter-Achsen (A-08 / K-04) sind
  **jetzt Pflicht** — Basis der Wiederverwendbarkeit und Zuordbarkeit der Binaries; ohne sie muessten bei
  jeder OS-Erweiterung **alle** Binaries neu gebaut werden. Kontext: Infra installiert weitere OS; neue
  Plattformen seit 02.08.: **RISC-V, macOS M1, macOS x86**. — dieselbe Datei, 02.08.2026, OWNER-WORT.
  **Aufgeloeste Lineage:** am **26.07.** (D-10) war die Zahl noch **offene Owner-Rueckfrage** — Kandidaten
  Version / Kernel / Build / Update-Zustand, "3-vs-4-Schnitt (Build separat?)", XML-erweiterbar zu bauen
  (`project_20260726_chunk_delta_verlorene_owner_antworten.md`, OWNER-WORT). Am **02.08.** entschieden:
  **drei**.
- **E-5** **Versionierungs-Interface, F7 = Option b** (Owner 06.08.2026, woertlich): "Bitte Option b: Wir
  hatten einen komplexen Stempel mit allen Achsen-Kategorien festgelegt mit jeweils versionierten
  Achsen-Algorithmen und zum Schluss ein SHA Hash als fingerprint. Wir erzeugen eine Funktion, die **zur
  compile time auch den Namen der Funktion aus dieser Rekombination in die binary schreibt** und durch ein
  **eigenes Interface der Stempel-Versionierung** an jeder Planer/CEB/Tier-Binary anbietet. Dies soll ein
  **gesondertes Versionierungs-Interface** sein." Bestehende Substanz: alle Achsen-Kategorien
  (Mess/System/Organ) mit je versionierten Achsen-Algorithmen, abschliessend ein SHA-Fingerprint —
  **Format 3, 8 Glieder, Frozen-Vektor**. Neu: der Name entsteht **CT**, nicht zur Laufzeit; das Interface
  wird an **jeder** Stufe angeboten (Planer, CEB, Tier — und damit auch Hybrid). Begruendung: Namen (Ordner,
  Plan-Dateien, Sidecars) werden heute an mehreren Stellen abgeleitet → Drift-Gefahr. Bau realistisch
  **nach** Abgabe; F7-Zwischenstand bis dahin = Option 1 (dokumentierte Grenze).
  — `feedback_versionierungs_interface_stempel_ct_namensfunktion.md`, 06.08.2026, OWNER-WORT.
- **E-6** **Versionsgrammatik Q3-final** (02.08.2026, Nachtrag ~17:0xZ): Versionierungen sind einheitlich,
  **immer 3-stellig, beginnen mit `v`**; Kurzformen (`v1`, `v1e`) sind **VERBOTEN** (Sentinel). Das Suffix
  ist eine **FLAG-Position**: Hardware-Flag `c`=CPU, `g`=GPU, `f`=FPGA, `n`=NPU, danach optional
  `e`=experimental. **CPU-only-Scope: ALLE Versionen enden auf `c` oder `ce`** — Beispiele **`v1.0.0c`**,
  **`v2.3.4ce`**. Anwendung: Parser/Renderer/CT-Wachen auf die Flag-Grammatik (Kennung A13-M1b);
  Bestands-Migration `v1.0.0` → `v1.0.0c` als Byte-Ereignis ins EINE A13-M2/M3-Neuanker-Fenster buendeln
  (kein zweiter Neuanker); zusaetzliche Wache "genau ein Hardware-Flag, im CPU-Scope `c`" neben der
  "ce-Registry nie `e`"-Wache. — `feedback_versions_flag_grammatik_dreistellig_hw_flag.md`, 02.08.2026,
  OWNER-WORT.

### 3.5 Hardware-Erkennung, PMC und Plattform-Achsen

- **F-1** **Hardware-Erkennung nie statisch** (Owner 27.07.2026, **mitten im 6d-Push**, Anlass Intel prod2;
  die Quelle vermerkt ausdruecklich: **"gilt als SCHON-IMMER-Gesetz"** — also rueckwirkend bindend, keine
  Neuerung ab dem Datum): die RAM-Frequenz "sollte nie fest gesetzt werden, sondern wird durch CEB mithilfe
  der Hardware-Haupt-Systemachsen aus dem OS ausgelesen, daher nie statisch, es braucht **eine Klasse mit
  einem factory Pattern fuer die Hardware Erkennung**, welche dies ueber alle Systemachsen wie **ISA x OS**
  fuer den Anfang erkennen kann. [...] Es gibt dutzende Bibliotheken welche man je nach OS ebenfalls zur
  Hilfe nehmen kann, **um Hardware zu erkennen**."
  **Zum "[...]" in diesem Zitat:** es steht **so in der Quelldatei** — es ist die Kuerzung dessen, der das
  Memory schrieb, nicht die dieses Dokuments. Was hier fehlt, ist damit **nicht rekonstruierbar** und bleibt
  ein offener Posten (der Owner-Wortlaut waere im Roh-Transkript vom 27.07. zu suchen). Die frueher hier
  stehende Fassung hatte zusaetzlich die Schluss-Worte "um Hardware zu erkennen" abgeschnitten — die sind
  jetzt zurueck. Recherche-Grundlage der Direktive laut Quelle: **Research-HWDetect-Bericht 27.07.**
  — `feedback_hardware_erkennung_factory_laufzeit_nie_statisch.md`, 27.07.2026, OWNER-WORT.
- **F-1a** **PRAEZISIERUNG (Owner, 27.07. spaeter)** — der Teil, der die Zwei-Ebenen-Aufteilung begruendet:
  die CEB-System-Achsen sind **statisch einkompilierte HAUPT-Achsen**, daher findet die **vereinfachte**
  Erkennung (welche Plattform? **ISA-Vendor x OS**) durch den **PLANER zu DESSEN Laufzeit** statt, um den
  **CEB-BAU zur Compile-Zeit** auf eine Plattform auszurichten. Die CEB bringt dann eine **einkompilierte
  Erkennungs-Software fuer einen groesseren Bereich an CPUs** (ihre **Plattform-Familie**) mit und **muss um
  die STEMPEL der System-Achsen ISA x OS erweitert werden**, fuer die sie passt — bisher traegt sie nur die
  gesamte Klammer der Mess-Achsen aus dem Planer. **Der Passungs-Stempel macht den Fehl-Deploy (Binary auf
  fremder Plattform) zu einer erkennbaren FEHLERKLASSE** — das ist der Zweck des Stempels und der Grund,
  warum er nicht optional ist. — dieselbe Datei, 27.07.2026, OWNER-WORT.
- **F-2** Negativbeispiel konkret: `ram_frequency_mhz=4800` statisch deklariert in ce-Commit **`5dea1258`**
  (`machine_identity.hpp`) — verstoesst gegen F-1. Konsequenz: solche Deklarationen werden zu Erwartungs-/
  Fallback-Werten degradiert (gekennzeichnet z.B. `declared_not_measured`) oder entfallen;
  `static_assert`-Wachen auf Hardware-ZAHLEN sind eine Regression gegen diese Direktive. Linux-Prioritaet:
  nicht-root-faehige Quellen zuerst (CI laeuft als `gitlab-runner`).
  — dieselbe Datei, 27.07.2026, MESSUNG (Commit-Beleg) + AGENTEN-BEHAUPTUNG (Anwendung).
- **F-3** **Zwei-Ebenen-Modell** (Owner 27.07., geltende Fassung ~18:05Z, woertlich): "Der Planer muss
  zumindest die **ISA x OS Komplex-Hauptachse grob erkennen** um per Metaprogrammierung eine passende
  feingranulare Hardware-Erkennung und passende OS handles dafuer mitzugeben bzw. je ISA x OS
  einzukompilieren (beachte alle vorhandenen ISA und dokumentierte OS). **Die feingranulare Erkennung liegt
  bei der CEB.**" Geltende Auslegung K1-K5, vom Owner als "goldrichtig" bestaetigt: Planer ist erster
  Konsument der Komplex-Achse und mappt den Host grob auf eine Zelle; Factory-Spezialisierung ueber
  `(IsaComplexTyp x OsTyp)` im Typ; CT-Totalitaetswache ueber
  `kAllTargetIsaComplexIds x kAllOperatingSystemIds` — **nicht implementierte Zellen sind eine ehrliche
  `declared-only`-Spezialisierung, NIE eine Luecke**; OS-Handles sind **CT-Typ-Bausteine der Zelle**; die
  feingranulare Erhebung liegt komplett CEB-seitig. **Verworfen** bleibt **nur** die engere
  "K1-Schaerfungs"-Deutung (Detailverbote "Planer nur CPUID-Vendor/Familie") — und die Quelle zieht daraus
  eine eigene Lehre: "**Owner-Korrekturen exakt auf die BENANNTE Fassung beziehen, nicht auf den ganzen
  Strang.**" — dieselbe Datei, 27.07.2026, OWNER-WORT.
- **F-4** **FINALE EINORDNUNG** (Owner 27.07. ~18:15Z): die HW-Erkennung ist eine **weitere zweigeteilte
  HAUPT-ACHSE** ueber Planer-**Runtime** und CEB-**Compile-Time**, konkret eine **MESS-Achse** (sie "misst"
  Hardware-Eigenschaften; Mess-Realm-Wurzel, Blut-Doktrin, golden-neutral). Der Planer baut sie in die CEB
  ein "wie die Mess-Programme" (Registry = Angebot, Profil waehlt, CMake-Interface kompiliert ein; je
  Plattform x Mess-Aufgabe eine passende CEB, Option b). **System- und Organ-Achsen der CEB werden davon
  NICHT beruehrt.** Zweck: den CT-Stempel der Tier-Binaries korrekt setzen (W10-Anschluss / Zellwerte-
  Defines). Details in PLAN-Doc Nachtrag 3 (N1-N5). Am selben Abend als "Task-#7-SPEC KOMPLETT"
  (`cad7290e`) bestaetigt. — dieselbe Datei, 27.07.2026, OWNER-WORT.
- **F-5** **PMC-Ausgangslage (heute nicht mehr geltend, siehe W-11):** #19 (jemalloc/tcmalloc/hoard/scalloc
  echt linken) und #26 (reale PMC-Hardware-Counter) waren lokal physisch nicht abschliessbar; literal
  verifiziert: **kein vcpkg, kein WSL-gcc, kein nativer gcc, kein autoconf** fuer #19; **kein Intel-PCM,
  kein MSR-Device** fuer #26. Abgeschaltet per Compile-Flag `USE=ENABLE&&HAVE` (HAVE=OFF → Stubs;
  PMC = `NullPmcSource`). Beschaffungs-Specs geliefert 01.06.2026 (Workflow `wtgq51wnz`):
  `docs/sessions/20260601-19-vendor-allokatoren-beschaffungs-spec.md` und
  `docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md` (reale **6 POD-Felder** → IntelPcm /
  LinuxPerf / PAPI / likwid-Drop-ins). Mechanik real bewiesen an mimalloc / snmalloc / dlmalloc.
  — `project_thesis_19_26_22_deferred_until_cluster.md`, 01.06.2026, MESSUNG.
- **F-6** **#22 (6 cache-engine-Submodule-Repos)**: `comdare-{cache-engine-core, search-engine, measurement,
  isa-dispatch, build-tools, test-system}` — **Kern-Befuellung DONE 01.06.2026**: 6 Repos mit **120 Header**
  plus Scope-README und INTERFACE-CMakeLists befuellt und gepusht, Parent-Pointer gebumpt
  (CE **`ce32e84`** / DA **`129b597`**). Non-destruktiv: Monolith `libs/` unveraendert, `modules/` **nicht**
  im Build-Graph → Build gruen, Smoke **5/5**. Verbleibt: die echte Konsumptions-Migration (gated auf
  GitLab-/DependencyManager-Reife). Cluster-Kontext (User 01.06.): Cluster-dev laeuft, Cluster-prod fast
  bereit, GitLab-Server laeuft, ZIH-externe Ressourcen bald bereit — #19/#26/#22 dann wieder aufnehmen.
  — dieselbe Datei, 01.06.2026, MESSUNG + OWNER-WORT.
- **F-7** In derselben Session abgeschlossen: **#49-E/F** (YCSB Scan/RMW via `IScannableTier`), **#4**
  (masstree `is_original` 4/4), **#9** (`axis_04` `Node{N}Layout` → `NodeType`).
  — dieselbe Datei, 01.06.2026, MESSUNG.

### 3.6 Lager, Messdaten, xlsx und E18-Snapshot

- **G-1** **Lager-Basistests, zwei Dummy-Strategien** — Owner 06.08.2026, drei aufeinander aufbauende
  Nachrichten, woertlich:
  (1) "Wie die Stempel Test-Zeichenkette fuer die Pruefung des lager-Aufbaus mithilfe von
  Dummy-Textdokumenten wurde nicht gelesen??"
  (2) "Das war eine Testwelle mit google tests, um die Struktur des Lagers zu pruefen und die Stempel mit
  Textdateien zu simulieren anstatt eines factory patterns fuer das Erkennen von Stempeln aus Binaries und
  Messwerttabellen (xlsx Legenden sheet wie geplant)"
  (3) "Ich erwarte laut Plan eine **dummy Strategie** fuer den Tests des Lagers um aus simulierten
  Textdokumenten die Stempel auszulesen und **jede Zeile verbatim** auszuwerten und dasselbe mit **compile
  Binary stubs** fuer das Stempelsystem zu wiederholen (Binary compile der eigentlich nur das statische
  Stempel interface der Versionierung enthaelt als **leere Tier-Binary**). Das sind die erwarteten Basis
  Tests fuer das Lagersystem."
  — `project_lager_basis_tests_dummy_strategien_stempel.md`, 06.08.2026, OWNER-WORT.
- **G-2** Das SOLL-Bild dazu, bindend: Produktiv-Ziel ist eine **Factory**, die Stempel aus **zwei
  Quellklassen** erkennt — (a) gebaute **Tier-Binaries**, (b) **Messwerttabellen** (xlsx, im **Legenden-/
  Info-Sheet**). Stufe 1 = Textdokument-Strategie (Stempel ausgelesen, **jede Zeile verbatim** ausgewertet);
  Stufe 2 = Binary-Stub-Strategie (echt kompilierte, sonst **leere** Tier-Binary, die nur das statische
  Stempel-Interface der Versionierung traegt — prueft das Stempelsystem am realen ABI-Traeger ohne
  Achsen-Rumpf). Anwendungsregeln: die Binary-Stub-Stufe haengt am gesonderten Versionierungs-Interface
  (E-5 / F7 Option b); **Kosten-Klammern** (z.B. "nur wenn `batch_plan_datei` belegt") duerfen diese Tests
  **nicht abschalten**. Fehlerklasse: "niemand liest/braucht X"-Behauptungen verlangen Code UND Tests UND
  Planung. — dieselbe Datei, 06.08.2026, OWNER-WORT + AGENTEN-BEHAUPTUNG.
  STAND: als Erwartung dokumentiert ("Ich erwarte laut Plan") — der Bauzustand ist **am Objekt zu belegen**,
  nicht anzunehmen.
- **G-3** **E18-Snapshot-Ordner (E-1-KERN)**, Owner 06.08.2026 woertlich: "in Zukunft soll die Diplomarbeit
  einerseits fertig auf den branch gepusht werden, aber andererseits wird sie **zusaetzlich in einen Ordner
  an der Wurzel der Messwerte kopiert, samt latex compile-export (Benennung nach Datum und Uhrzeit)**. so
  laesst sich ein compile nachvollziehen." Ziel-Branch **289 = development** (E-1a). Arbeits-Annahme (die
  Praezisierung war zu diesem Datum noch angefragt): `super measurement/thesis_compiles/JJJJMMTT-HHMMSS/`
  mit PDF, Compile-Log und Quellstand-SHA je Kanal-Lauf.
  — `project_e18_snapshot_ordner_und_graph_darstellung_kerne.md`, 06.08.2026, OWNER-WORT.
- **G-4** **Graph-Darstellung (E-2-KERN)**, Owner 06.08.2026 woertlich: "**eine Heatmap ist vielleicht nicht
  die geeignete Form**, wie machen das die anderen Paper? Orientiere dich daran und verwende **2D und 3D
  Graphen**." Reihenfolge: honest-empty-Paket zuerst (B-5-Lebend-Check VOR Trigger, E-2a), Voll-Korpus-Check
  spaeter (E-2b). — dieselbe Datei, 06.08.2026, OWNER-WORT.
- **G-5** **E-4-Dauer-Doktrin**, Owner woertlich: "**Bitte notiere shortcuts als offene REgression und
  TODO**" — jeder Shortcut wird als OFFENE REGRESSION plus TODO im Ledger notiert; das P2-P8-Schema-Fenster
  liegt **vor** Messbeginn; **xlsx ist das Erst-Auswerteformat**. E-5: Posten 92 vor Abgabe. W5/W3-Schwelle:
  21:00 Berlin am 06.08. — dieselbe Datei, 06.08.2026, OWNER-WORT.
- **G-6** **Alt-Mess-CSV sind Archiv**, Owner 26.07.2026 woertlich: "Durch die Umbrueche sind die alten
  Mess-csv hoechstens etwas fuer das **Archiv**, aber wir **modernisieren die Struktur nach Plan**."
  Konkret: `tier150_measurements.csv` mit **5760 Zeilen**, **17-Segment-`binary_id`s**, **160 Feldern** ist
  durch `binary_id` **17 → 18**, ABI **6 → 7**, POD **1272 → 1344** und die xlsx-Umstellung **strukturell**
  veraltet. — `reference_alt_mess_csv_archiv_struktur_modernisierung.md`, 26.07.2026, OWNER-WORT.
- **G-7** Die Messdaten-Doktrin gilt dabei weiter: Dateien bleiben **byte-unveraendert** (nie loeschen, nie
  aendern). Zugriff nur ueber einen **versionierten Reader**, der **160 UND 169 Felder** akzeptiert und
  17-Segment-Alt-`binary_id`s **beim Lesen** normalisiert, indem er
  `/persistence_target=persistence_memory_only` anhaengt (inhaltlich korrekt: jede Alt-Messung WAR
  memory_only). Byte-Hash-Wache auf der Datei. Konsequenz fuer Prof. Habich: die **ersten frischen Mess-CSV
  der neuen Struktur** (aufs NAS) sind der Beweis; Alt-CSV sind nicht vorzuzeigen.
  — dieselbe Datei, 26.07.2026, AGENTEN-BEHAUPTUNG (Anwendungsregel) + OWNER-WORT (Beweis-Zweck).
- **G-8** Binaries gehen nach **ccache/minio**, Messergebnisse in den **PR4100 Cluster_NFS
  Experiment-Ordner**; der lokale Fussabdruck der Maschine geht gegen null. NAS-Endpoint-Preflight noetig
  (dieselbe `mc`-Falle wie andernorts, siehe I-6). Die Binaries-Lager-Kaskade lautet
  **System (Wurzel) → ORGAN → Mess (tiefster Typ)**.
  — `project_20260726_chunk_delta_verlorene_owner_antworten.md` (D-04, D-12), 26.07.2026, OWNER-WORT.

---
### 3.7 Zahlen-Lineages: Gates, Testzahlen, Toolchain, Achsen-Zahlen

- **H-1** **Toolchain-KERN**, Owner 06.08.2026 (frueh-12) woertlich: "**Weiterhin arbeiten wir mit gcc 15.3
  und die neueste Version (die ueberhaupt existieren kann) ist gcc 16**". Konsequenz: in Doku, Tests,
  Fixtures und Beispiel-Preimages duerfen **keine Phantom-Compiler-Versionen** (g++-17/18) auftauchen;
  realistische Beispiele nutzen **gcc 15.3** (Arbeits-Toolchain) bzw. **gcc 16.x** als maximal existierende
  Linie (Beispiel K2: "g++-16 16.0.1 → 16.3 baut DLL neu"). Die RT-Realversions-Sonde (**T2-C**,
  fail-closed) liefert die echte Version zur Laufzeit — statische Versions-Annahmen sind verboten.
  — `reference_gcc_kern_toolchain_versionen.md`, 06.08.2026, OWNER-WORT.
- **H-2** **Toolchain-Kanon-Doktrin** (Owner dreimal woertlich, Ledger §76): **15.3 = Minimum + Standard +
  DEFAULT**; ein 16.0.1-Gruen ist nur ein Zwischen-Signal; der Beweis gilt erst nach Host-Installation von
  15.3. Pin-Fix `ci-templates` development **`b0b2fb6`** (`.test`: 15 > Default, **NIE 13**); v2-Image-Digest
  **`a43c7fe5`**. Am 27.07. hatten prod1 und prod2 **beide kein g++-15** (Probe-Belege **334243** /
  **334819**). — `project_20260727_vormittag_o8_fenster_lage.md`, 27.07.2026, OWNER-WORT + MESSUNG.
- **H-3** **Container-15.3 kuerzt die Kanon-Welle NICHT ab.** Der docker-Executor-Pilot lief real: Runner
  **56**, Job **334886** (Projekt 547, Pipeline 13531, main, 09:32:01 → 09:38:11Z, success), Image Debian 13
  trixie mit "g++ (GCC) **15.3.0**" und "cmake version **4.4.0**". Owner-/Manager-Entscheid gegen den
  Fehlalarm: der Kanon bleibt **ausschliesslich Host-g++-15(.3) auf prod1/prod2** — die Mess-Doktrin
  verbietet Container fuer Messungen. prod1-Host-Ist 11:43Z: kein g++-15, Default 16.0.1 (trunk r16-8100).
  **Nebenbefund:** der Pilot-Job war **falsch-gruen** (heredoc-`printf` zerbrach den Teststring, der Build
  scheiterte real, danach lief dennoch ein Erfolgs-Echo) — der docker-Weg als Bauweg ist damit
  **unbewiesen**. Zusatzbefund: die **324s-Finalisierungsluecke** auch auf Runner 56 (Trace-Ende 09:32:39Z
  gegen `finished_at` 09:38:11Z = **332s** bei 1s echter Laufzeit).
  — dieselbe Datei, 27.07.2026 ~11:50Z, MESSUNG.
- **H-3a** **Die `gitleaks`-0-Bytes-Empirie (Infra-Posten P9) — ein "no leaks found" war Historie, kein
  Befund.** Der P9-Fix ist Commit **`3d6cbec`**, gesetzt **10:15:59Z**. Pipeline **13526** wurde
  **07:36:10Z** erstellt, also **vor** dem Fix — ihre Zeilen "**scanned ~0 bytes (0)**" und
  "**no leaks found**" sind damit **kein** Beleg fuer irgendetwas. Die Regel daraus: **der P9-Beweis zaehlt
  erst mit der ersten NACH 10:15:59Z erstellten 288-Pipeline**; ein Fix-Commit belegt nichts fuer Pipelines,
  die vor seinem Zeitstempel **erstellt** wurden (nicht: gelaufen sind — GitLab friert den `include`-Stand
  bei der **Erstellung** ein, vgl. H-2). Gegenbeleg spaeter am Tag: `lint:secrets` liest **107,90 MB** in
  Welle 288/13545 = der **P9-Fix doppelt bewiesen** (N-3). Nebenbefund derselben Stelle: **13526 ist
  vollstaendig gruen inklusive aller drei Bridges** (`trigger:cache-engine` → **13528**, `trigger:thesis` →
  **13529**, `trigger:prt-art` → **13530**) — die Job-Zahl allein haette das nicht gezeigt (I-4).
  — `project_20260727_vormittag_o8_fenster_lage.md`, 27.07.2026 ~11:50Z, MESSUNG.
- **H-4** **Kanon vollzogen** am 27.07. ~15:10Z: gcc-15.3 ist nativer `alternatives`-Default auf **beiden**
  Hosts; CI-bewiesen ueber die Wellen **288/13555** (13/13 + 3 Bridges) und **286/13556** (17 gruen)
  komplett auf GNU 15.3.0, **prod2-Erstbeleg 335376**. `main == development` auf allen drei Linien:
  ce **`e6aeee17`** / super **`d6777094`** / ci-templates **`5f9e04be`**.
  — dieselbe Datei, 27.07.2026, MESSUNG.
- **H-5** **ce-Gate-Zahl ist lebend, nicht fix.** Progression **312 → 314 → 316 → 317 → 318 → … → 331**
  (Stand 03.08.2026); vor jedem J-Ketten-Lauf **live** via `ctest -N` erheben. Die Zahl zaehlt
  **ctest-EINTRAEGE** (Test-Binaries), **nicht** gtest-Faelle: ein Test-Binary mit 8 `TEST()`-Faellen hebt
  das Gate um 1 (317 → 318), nicht um 8. Pruefen mit `ctest -N | tail -2` ("Total Tests: N") bzw. der Zeile
  `<i>/<N> Test #<id>: <name>`. Zur widersprochenen V32-Kausalitaet siehe W-09.
  **Die Quelle nennt das die EBENEN-FALLE beim "N mitmelden" (real 27.07., Task-#7-P1) und schreibt eine
  Meldeform vor:** "Wer die gtest-Zahl meldet, verspricht dem Manager eine Gate-Zahl, die der naechste
  ctest-Lauf widerlegt. **Beide Zahlen gehoeren in die Paketmeldung, aber getrennt benannt: 'n=1
  ctest-Eintrag mit 8 Faellen'.**" Ohne diese Form ist die Warnung nicht anwendbar — sie sagt sonst nur,
  was falsch ist, nicht was zu schreiben ist.
  — `reference_ce_jkette_n316_braucht_v32_enable_on.md`, 27.07./03.08.2026, MESSUNG.
- **H-6** **J-1-Werkzeug-Targets tragen alle das `comdare_`-Praefix**: `comdare_adhoc_emitter_cli`,
  `comdare_catalog_codegen_cli`, `comdare_anatomy_codegen_cli`, `comdare_gen_golden_fullpilot`,
  `comdare_{,measurement_,system_}axis_registry_gen`. Die Kurzformen ohne Praefix sind teils nur
  phony-Aliase; **`adhoc_emitter_cli` existiert gar nicht**. — dieselbe Datei, 27.07.2026, MESSUNG.
- **H-7** **Achsen-Zahl 19 → 18** (siehe W-03) und **T0-Zaehlung 21 → 22**: die User-Entscheidungsmatrix vom
  02.07.2026 legte fest, dass SwissTable und Knuth-OA **zwei getrennte permutierte T0-Bausteine** sind
  (**S14** + neu **S22**) — damit steigt die T0-Zaehlung von **21 auf 22**; der Text-Agent passt die
  "21er-Nennungen" **nach** der Landung an. — `project_handout_ap1_15_code_nachzug_audit_20260702.md`,
  02.07.2026, OWNER-WORT.
- **H-8** Weitere bindende Punkte derselben Entscheidungsmatrix (02.07.2026, OWNER-WORT):
  **P1 CSV — BEIDES:** die 16-Spalten-Basis bleibt UND `branch_misses` + `throughput_ops_per_sec` kommen
  dazu (Cycles ist bereits Spalte 6). **P2 Profile — ALLES als XML definierbar:** **33/33 SOTA** (fehlend
  P08 ARTSync / P09 LOUDS / P33 VAMPIR) und **23/23 Allokator**. **P4-P7:** der Code hatte recht, der Text
  wurde angepasst, kein Code-Handlungsbedarf.
- **H-9** Grundsatz zum Verhaeltnis Thesis/Code, Owner woertlich: "**Thesis beschreibt den faktischen
  Sollstand — Code zieht nach.**" Quelle des Pakets:
  `thesis/diplomarbeit/sessions/2026-07-02-handout-implementierungsagent-audit-code-todos.md` plus Audit
  `2026-07-02-audit-thesis-vs-code.md` (ultracode, **151 Claims: 99 OK / 50 divergent**). Tasks AP-1 → #235
  … AP-15 → #249; **P0 = AP-1..7 (#235-#241)** blocken **#156** (M3-Lauf); **AP-1** (#235, POD
  `branch_misses` + `throughput` = ABI-Bruch) und **AP-7** (#241, SwissTable-S22 aendert die T0-Registry)
  blocken zusaetzlich **#215** (FREEZE / 320-Neubau); AP-12 (#246) blockedBy AP-2 (#236); AP-14 (#248)
  blockedBy #215 + #156; neue **W4.5** zwischen W4 und W5.
  — dieselbe Datei, 02.07.2026, OWNER-WORT + MESSUNG.
- **H-10** Fallstricke desselben Pakets: **AP-11 widerspricht #136-completed** (das Audit zaehlt **8**
  `lp_*` statt **14**) → Verzeichnis/Naming vor der Arbeit klaeren. **AP-8** vendort `HdrHistogram_c` unter
  `ext/` (ein neuer Unterordner ist ok, bestehende `ext/**` bleiben tabu). Das Legacy
  `measurement_writer.hpp` **nicht** erweitern. — dieselbe Datei, 02.07.2026, AGENTEN-BEHAUPTUNG.
- **H-11** **Volles GO 17.07.2026**, Owner woertlich (Kontext-Ende): "**GO fuer Q1-Q5, volles GO fuer
  DLL-Load Option B, VOLLES GO sonst. Warte auf alle Workflows, bevor du baust.**" Damit sind alle offenen
  Architektur-Entscheide getroffen (Q1-Q5-Mapping, DLL-Load = Option B, H-6..H-10, Planer-Codegen-Forks
  PF1-4, Set-Ebene-1-Promotion, Telemetrie-/Scheduling-System-Achsen, golden-Umbau, Serialisierung Q1-Q4).
  — `project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md`, 17.07.2026, OWNER-WORT.
- **H-12** Bau-Roadmap desselben Tages: **INC-0** (deadline-kritisch) = DLL-Load Option B — `link_libs`-Kanal
  in `make_gpp_compile_fn` (`build_orchestrator.hpp:466-489`) plus Fassaden-Bake
  `$<TARGET_FILE:comdare::vendor_mimalloc>`; ABI-4-kompatibel; entsperrt echte Messwerte (`measured>0`).
  **INC-1** = CEB-System-Achsen-Schichtung (4 System-Achsen als Schicht ueber den — damals genannten —
  19 Organ-Achsen; heute flach). **INC-2** = der EINE koordinierte **4 → 5-ABI-Bump** am
  Experiment-Planer-Dock (Design `F12III-DESIGN-VORLAGE.md`) — TABU-GO, **ein** reservierter Major-Bump.
  Bauplan INC-0: `docs/sessions/backups/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md`.
  Gelandet an dem Tag: F6-Nachzieh (ce **`871f6d2e`**, super **`8488d1d`**; `ctsha.hpp` ehrlich **nicht**
  deprecated = LEBT) und die §18/§19-Konsolidierung ins Ledger (super **`53cbecf`**).
  — dieselbe Datei, 17.07.2026, MESSUNG + AGENTEN-BEHAUPTUNG.
- **H-13** **Zeitbudget-Rechnung** (weiter brauchbar, auch wenn die Frist ueberholt ist): ~2 Tage Voll-BAU
  (2^17) plus ~2 Tage MESSEN und TESTEN (320er plus Abnahme) ⇒ Voll-Bau-Start spaetestens **Donnerstag**.
  Fahrplan damals: Mi-Nacht S1-S4 plus Verifikation → Do Voll-Bau-Start auf **beiden** Maschinen
  (ccache/K7b wirksam) → Do+Fr Bau → Sa+So 320er-Messlauf, Tests, M-4, PDF → Mo Abgabe. Owner korrigierte
  ausdruecklich die Formulierung "Frist hat Vorrang vor Batch-Perfektion" mit "**Nein**" — Gruendlichkeit
  ist die Direktive. **§66 Lager-Gate erzwungen**, Owner woertlich: "**das Risiko des Scheiterns ohne
  Wiederaufnahme ist zu gross**" → Lagerhaltungs-Punkte vorziehen und moeglichst parallelisiert entwickeln.
  — `project_frist_montag_2707_zeitbudget_bau_messen.md`, 22./23.07.2026, OWNER-WORT.

**Aus der zweiten Welle (die 49):**

- **H-14** **prod1-Umgebungs-Ist am 05.07.2026** (die einzige Datei, die es vollstaendig auflistet):
  g++ **16.0.1 trunk r16-8100** als Default ("exakt der Runner-Default!"), clang **22.1.8**, cmake
  **4.3.4**, ninja; **cppcheck NICHT lokal** (CI hat **2.21.0** via citools-Cache); clang-format **exakt
  22.1.8** unter `/home/comdare/tools/clang-format-22.1.8` (Symlink auf ein dpkg-deb-extrahiertes
  offizielles apt.llvm.org-Paket, kein sudo noetig, laeuft gegen installiertes libclang-cpp22);
  **sudo verlangt Passwort** → apt-Installationen muss der User machen.
  — `reference_prod1_comdare_env_setup.md`, 05.07.2026, MESSUNG. **STAND:** die g++-Default-Zeile ist durch
  H-4 (27.07. ~15:10Z) ueberholt, siehe **W-33**; der clang-format-Pin gilt weiter.
- **H-15** **GitLab-Projekt-IDs** (Primaerquelle): ce = **286**, super = **288**, prt-art = **287**,
  thesis = **289** (`20260931-overleaf-diplomarbeit`), ci-templates = **269**.
  — dieselbe Datei, 05.07.2026, MESSUNG. Deckt sich mit "286 = Forschungsrepo"
  (`project_cache_engine_research_vs_cacheengine_all_split_todo.md`, 03.07.2026).
- **H-16** **golden-N-Lineage 2^17 → 2^18 → 2^17, an EINEM Tag.** (1) 26.07. abends, Owner woertlich:
  "**Ja sofort aktivieren und durchziehen, ordentlich und Kern-Konform**" zu `persistence_target` mit
  `disk_writeback` **enabled=true** → Folge im selben Eintrag: "FullSourceCatalog = **2^18 = 262144** je
  System-Perm (Voll-Bau-Volumen/Zeit **x2**, **~112 GB/Zelle**); neuer golden-N-Anker ueber 2^18.
  Platten-Forecast beim Trigger beachten (**prod1 ~109G frei** → §65-Push+Prune muessen den Lauf tragen)."
  (2) 26.07. spaet, **Q-1 REVIDIERT**: "**disk_writeback: enabled=false wie empfohlen** (kein echter
  Disk-Pfad = Messwert-Luege). **NEU-AUFLAGE: Achsen-Deaktivierung PER XML muss unterstuetzt sein** (nicht
  nur Code-option). **Raum bleibt 2^17** bis der echte Schreibpfad existiert."
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
- **H-17** **Die 12 System-Permutationen des Voll-Baus (26.07.):** **4 opt x 3 simd = 12**.
  opt: **O0, O1, O2, O3** — "Der Bau permutiert wie geplant ueber ALLE verfuegbaren Stufen, sofern nichts
  anderes bestimmt"; "Cache-Line-Beweise: **die O3-Zeile ist die aussagefaehige**"; **`Ofast` bleibt AUS**
  (bricht IEEE-754-/CRC64-Determinismus, `validate_profile` rejected es hart). simd: **no_extension, avx2,
  avx512** (`-mavx512f`) — **prod1_zen5 traegt 13 AVX512-Flags**, prod2 meldet fused-off korrekt. Der
  avx512-Ausschluss auf prod2 faellt **maschinenseitig per Freigabe + WARNUNG** (Fehlerklasse
  `HardwareErweiterungFehlt`, misst weiter), **nicht** als stiller Profil-Filter (§62-A Planer-
  Universalitaet). "Das golden-Profil hatte avx512 faelschlich als 'nicht universell' herausdefiniert — das
  ist der Filter, der ENTFAELLT." Alles binary_id-neutral: opt/simd sind `system_config binary_id="never"`
  → Suffix/Sidecar, nicht Katalog. — dieselbe Datei, 26.07.2026, OWNER-WORT + MESSUNG.
- **H-18** **Standalone-Gruen-Baseline der ce-Unit-Tests, 28.05.2026** (12 Dateien, **348 Tests**):
  axis_01 (21) · axis_02_04 (13) · axis_05 (14) · axis_07 (8) · axis_09 (21) · axis_09b (50) · axis_12 (17)
  · axis_14 (8) · topics_fundament (16) · anatomy_r4_driver (10) · permutation_engine (15) ·
  topic_traversal (155); dazu axis_08 (8 neu). Nach `git submodule update --init
  ext/queuing/Q01-concurrentqueue` (moodycamel BSD-2, `cameron314/concurrentqueue`, gepinnt **d655418**)
  kommen **topic_queuing (216)** + **paper_legacy_code (145)** dazu.
  — `reference_cache_engine_standalone_build_pipeline.md`, 28.05.2026, MESSUNG.

### 3.8 Werkzeug- und CI-Fallen

Zehn der 57 Dateien sind reine Fallen-Referenzen; zehn davon teilen dieselbe `originSessionId`
**`46375cdc-821a-4bf9-93d4-fe0a5687f489`** — ein durchgehender CI-/Build-Verifikationsstrang vom 07.07. bis
03.08.2026, der nie indexiert wurde.

**Parser und Shell:**

- **I-1** **`grep -P` bricht auf Nicht-GNU-grep still ab.** Die Bash-Parser des `cd-buildsystem` (z.B.
  `dependency-manager/scripts/dependency_resolver.sh`) parsten XML mit `grep -oP "<tag>\K[^<]+"` und
  `grep -ozP "(?s)<block>.*?</block>"`. `-P` (PCRE), `\K` und `(?s)` sind **GNU-grep-only** und brauchen ein
  UTF-8-/unibyte-Locale. Auf **msys** (Windows-Git-Bash): `grep: -P supports only unibyte and UTF-8
  locales`; auf **Alpine/busybox** und **macOS/BSD grep** existiert `-P` gar nicht → jeweils **leerer
  Extract**, und `2>/dev/null` verschluckt den Fehler → Folgefehler "empty node name" plus falsche
  "Circular dependency". Auf Linux-CI laeuft es. **Portabler Ersatz** (angewandt, Commit **`6964ee7`**):
  Element-Text `printf '%s\n' "$xml" | grep -o "<${el}>[^<]*" | head -1 | sed "s|^<${el}>||"`;
  Attribut `... | grep -o "${a}=\"[^\"]*\"" | head -1 | sed "s|^${a}=\"||; s|\"\$||"`; Multi-Line-Block
  ueber den awk-Helfer `_comdare_xml_block` (`index($0,"<t>"){f=1} f{print} index($0,"</t>"){exit}`, POSIX,
  kein Regex); dazu `.gitattributes` mit `*.sh/*.cmake text eol=lf`.
  **Stand 03.07.2026: 5 Module portabel** (dependency-manager 3 Dateien, core `interface.sh` +
  `lib/local_root.sh`, compiler-manager, package-manager — je `bash -n` OK, 0 `grep -P`, beide Remotes).
  **GROSSER REST, offen:** der `build-utilities`-Referenzparser `scripts/xml_parser.sh` (~60 Stellen) plus
  `xml_load.sh` (~30 Stellen) = **~90 variantenreiche Stellen**, dazu 2 Multi-Block-Fallbacks
  (resolver:915, downloader:681). Nebenbefund: `'name="\K'`-Doppelescape war latent auch auf Linux kaputt.
  **META-LEKTION:** Read-only-Discovery-Agenten hatten den Smoke-Test `tests/run_dijkstra_smoke.sh` als
  "lauffaehig" bezeichnet, **ihn aber nie ausgefuehrt** — er war rot.
  — `reference_buildsystem_scripts_posix_no_grep_p.md`, 03.07.2026, MESSUNG.
- **I-2** **`buildsystem.xml` literal lesen, nicht XML-escapen.** Der Manifest-Parser (v3.4.15-Manifeste) ist
  **grep/awk-basiert** und entschluesselt **keine** XML-Entities. Die Quelle benennt ihn identisch mit dem
  Parser aus I-1 — "die POSIX-Parser-Arbeit an **`xml_parser.sh`** / **`dependency_resolver.sh`**"; I-1 und
  I-2 handeln also von **demselben** Parser, einmal von der Portabilitaets- und einmal von der
  Escaping-Seite. Gotcha real: beim T-03-Fix scheiterte
  `python xml.dom.minidom` an `<bootstrap method="shell">cd src &amp;&amp; ./make.bash</bootstrap>`
  (Zeile 446, unescaptes `&&`); der Agent escapte `&&` — **falsch**, das haette den Shell-Befehl literal
  zerstoert; sofort per `git checkout` revertiert. **Regel:** Element-Content literal lassen; strikte
  XML-Wohlgeformtheit ist **kein** Ziel; ein kuenftiger Schema-Validierungsschritt (T-57) muss den
  grep-Dialekt tolerieren, nicht umgekehrt. Korrekt war am T-03-Fix nur die Content-Korrektur: tote
  `cmakePackage>BEPBuildSystem`- und nicht-existente `<module>`-Referenzen → reale
  `ComdareBuildSystem.cmake` / `BuildSystemMaster.cmake` / `BuildSystemCore.cmake`.
  — `reference_buildsystem_xml_grep_parsed_not_strict_xml.md`, 04.07.2026, AGENTEN-BEHAUPTUNG (Selbst-Catch).
- **I-3** **`pgrep -f`-Warteschleifen matchen sich selbst.** Das Muster
  `until ! pgrep -f "ninja.*build-v6" > /dev/null; do sleep 10; done` terminiert **nie** — die ausfuehrende
  Shell traegt das Suchmuster selbst in ihrer Kommandozeile. Real am 27.07.2026 (ce-Zug 6d/6e): zwei solche
  Loops liefen weiter, obwohl Bau und ctest laengst mit Exit 0 fertig waren, und mussten von Hand gekillt
  werden — **Exit 144 = SIGTERM, KEIN Arbeitsfehler**, das muss in der Meldung kenntlich gemacht werden.
  Saubere Alternativen: `run_in_background: true`; auf ein Artefakt warten
  (`until [ -f fertig.marker ]`, `until grep -q "100% tests passed" ctest.log`); falls doch Prozess:
  `pgrep -f "[n]inja"` oder `while kill -0 <pid> 2>/dev/null; do sleep 5; done`.
  — `reference_pgrep_warteschleife_selbstmatch_falle.md`, 27.07.2026, MESSUNG.

**GitLab-API:**

- **I-4** **`/pipelines/:id/jobs` verbirgt Trigger-Bridges vollstaendig.** Fehlende Bridges stehen nur unter
  `GET /projects/:id/pipelines/:pid/bridges` (inkl. `downstream_pipeline.id/status/project_id`). Realer Fall
  27.07.2026: **288-main**-Pipelines blieben stundenlang `running`, `build:clang` auf `created`. Ursache:
  3 Bridges in Stage `orchestrate` (`trigger:cache-engine`, `trigger:prt-art`, `trigger:thesis`); auf main
  feuern alle drei IMMER, weil `if: $CI_COMMIT_BRANCH == "main"` **vor** dem changes-Gate steht, und
  `strategy: depend` haelt die Bridge running bis der Downstream fertig ist. `build:clang` hat **kein**
  `needs:` und wartet stage-basiert, waehrend `analyse:thesis-data` / `visibility:tier-binaries` mit
  `needs: ["verify:submodules"]` per DAG vorbeiziehen. Auf development griff das changes-Gate, `orchestrate`
  blieb leer — **dieselbe Datei, derselbe Commit, sauberer Durchlauf**. Selbstblockade-Kreis: jeder
  main-Push (auch docs-only) erzeugt per Bridge eine volle Downstream-Pipeline; die "redundante Kaskade" auf
  **286-main** war zu 100% Echo der eigenen 288-main-Wellen (erkennbar am Feld `source=pipeline` gegen
  `source=push`). **Erkennungsregel fuer Monitore:** kein Job mehr running/pending + mindestens einer
  `created` + mindestens eine offene Bridge = **strukturell haengend**.
  — `reference_gitlab_jobs_api_zeigt_keine_bridges.md`, 27.07.2026, MESSUNG.
- **I-5** **`?sha=` akzeptiert nur den vollen 40-Zeichen-SHA.**
  `GET /projects/:id/pipelines?sha=<kurz-sha>&ref=<ref>` mit abgekuerztem SHA (Beispiel `0d7a0d92`) liefert
  **immer `[]`**. Realer Fall **03.08.2026, prod1/Projekt 286**: eine 2d-Landungs-Wache verpasste dadurch
  die **ROTE Pipeline 14334** (FAILED) und lief still bis zum Timeout. Regel: immer `git rev-parse <ref>`
  verwenden, oder ohne sha-Filter die letzten Pipelines je ref holen und clientseitig
  `sha.startswith(...)` matchen; nach 1-2 Leerantworten eine **laute** Diagnosezeile emittieren (Query plus
  Antwortlaenge), nie endlos still weiterpollen.
  — `reference_gitlab_pipelines_api_sha_vollform.md`, 03.08.2026, MESSUNG.

**Trace-Parsing — 17 gelabelte Fallen aus einer Datei:**

- **I-6** Grundproblem: der **Commit-Titel** erscheint im Git-Checkout-Block **jedes** Job-Traces
  ("HEAD is now at `<sha>` `<titel>`"). Naives Substring-/Regex-Matching auf Fehlerbegriffe trifft den Titel
  statt des Fehlers. Zwei reale Erstfaelle 27.07.2026: (1) der Titel "feat(error): RF-3 …" matchte
  `\berror\b` → die Pipeline-Ursache wurde als Commit-Titel gemeldet; (2) der Titel "V-6 Toolchain-Floor
  g++>=15.3" haette die Floor-Abbruch-Wache auf **jedem gruenen Job** der Welle ausgeloest (**vor der
  Scharfschaltung durch Gegenprobe entdeckt** — der zweite Fall war also kein Schaden, sondern ein Beinahe).
  — `reference_ci_trace_parsing_commit_titel_falle.md`, 27.07.2026, MESSUNG.
- **I-6a** **Die Abhilfe — "ROBUSTE FORM (bewaehrt)" in der Quelle.** Ohne sie ist I-6 nur die Diagnose.
  Vier Teile, alle vier gehoeren in jede Trace-Wache:
  **(a)** Git-Checkout-Ausgaben und Cache-Zeilen **hart ausschliessen**.
  **(b)** Zusaetzlich einen **echten Abbruch-Kontext** verlangen, z.B. `Configuring incomplete`,
  `CMake Error`, `FATAL_ERROR`, oder `error:` **MIT Doppelpunkt** — der blosse Fehler-NAME genuegt nie.
  **(c)** Im Abbruchbereich am **Trace-ENDE** suchen (**letzte ~80 Zeilen**), nicht im ganzen Trace.
  **(d)** Die Wache gegen **echte GRUENE Traces gegenproben**, die das Suchwort enthalten — woertlich:
  "**Negativfaelle sind der eigentliche Test**". (Dieselbe Forderung kehrt in **(k)** wieder: Wachen an
  echten roten UND gruenen Traces eichen, nie nur synthetisch.)
  — dieselbe Datei, 27.07.2026, MESSUNG.
- **I-6b** **Zweite Lehre derselben Stelle, woertlich:** "**Seed-/Neustart-Stummschaltung darf nur
  ZUSTANDS-Signale unterdruecken, nie BEFUND-Pruefungen — sonst hakt der Seed rote Jobs ungesehen ab.**"
  Das ist die Umkehrung von (d): (d) schuetzt vor **falsch-rot**, diese Lehre vor **falsch-gruen**, und ein
  Watcher braucht beide. — dieselbe Datei, 27.07.2026, MESSUNG.
- **I-7** Die weiteren, einzeln gelabelten Fallen derselben Datei (alle gegen echte Traces gegengeprobt):
  **(e)** CMake-Meldungen brechen um ("gefunden:" / "13.3.0" auf zwei Zeilen) — einzeilige Muster verpassen
  Befunde. **(f)** "[403/1387] …" ist eine Ninja-Schrittnummer, **keine** HTTP-403. **(g)** Warnungs-/
  Kommando-Echo: die PIN-GAP-Warnung "gcc-15.3 bereitstellen" enthaelt "15.3" → naiver Alarm meldet eine
  Kanon-Toolchain, die es nicht gibt. **(h)** Negations-Teilstring: "leaks found" steckt in "**NO** leaks
  found" → meldet jeden gruenen Job falsch. **(i)** Der GitLab-Trace-Endpunkt wirft sporadisch 5xx,
  **gemessen ~20%** nach dem 18.11.7-Upgrade → ohne Retry+Backoff verliert der Watcher still jede fuenfte
  Pruefung. **(j)** `/runners/:id/jobs` liefert per Default die **aeltesten** Jobs zuerst → Pflicht:
  `order_by=id&sort=desc`. **(k)** Das Runner-Praefix `<ISO>Z 01E ` bricht Meldungen um; naives Joinen
  schiebt den ZEITSTEMPEL der Folgezeile in die Extraktion ("gefunden: 2026" statt "13.3.0"); ein
  ODER-Trigger auf Fehlernamen matchte real **8 von 13** Commit-Titeln falsch-rot → Trigger muessen
  UND-Bedingungen sein. **(l)** "deprecated" kommt aus **drei** Schichten (C++-Attribut, CMake-Statuszeile,
  CLI-Zeile); Opt-in-Jobs sind per Trace nicht pruefbar, nur statisch. **(m)** `!reference`-Tags brechen
  `python3 yaml.safe_load` **immer** → Fix: `SafeLoader` mit `add_multi_constructor('!')`.
  **(n)** `/pipelines/:id/jobs` verbirgt per Default **RETRIED** Jobs (`include_retried=false`) → ein roter
  Erstversuch mit gruenem Retry sieht komplett gruen aus (real: ein `data_integrity_failure`-Erstversuch war
  unsichtbar). **(o)** Zentrale ci-templates (`.test`, `.lint-base`, `.build`, `.audit-layering`) bringen
  selbst `needs: []` mit → der erbende Job ist **stage-frei** und startet sofort, **egal welche Stage er
  traegt**; Empirie: `test:unit` lief 4 von 4 Wellen **vor** `verify:submodules`. **(p)** Testzahlen sind
  host-abhaengig (siehe W-20). **(q)** Der
  `get_sources`-Block zeigt "HEAD is now at `<ALTER-SHA>`" **vor** dem Submodul-Update — autoritativ ist nur
  `git submodule status` im `step_script` (real fast falsch gemeldet bei super `13587` / ce `bc5dc37c`).
  — dieselbe Datei, 27.07.–02.08.2026, MESSUNG.
- **I-7a** **Falle (o) ausgeschrieben — zwei Folgen und die Belegregel** (27.07.2026, OP-2). **Folge 1:** eine
  "Stage-Blockade"-Diagnose aus der Job-Zeile allein ist **wertlos** — Pflicht ist, die komplette
  `extends`-Kette **im Template** zu lesen UND die realen `started_at`-Zeiten zu **messen**. Am selben Tag
  fielen beide Faelle verschieden aus: **bei `test:unit` war die Herleitung FALSCH**, **bei `build:clang`
  (Vorlage OHNE `needs`) STIMMTE sie** — Empirie **13526** gegen **13561/13570**. **Folge 2:** ein
  stage-freier Job kann **vor seinen logischen Voraussetzungen** laufen (`test:unit` baute 4/4 Wellen vor
  `verify:submodules`); ein explizites `needs:["<gate>"]` ueberschreibt das geerbte `needs: []` und stellt die
  Reihenfolge her. Einordnung dieses Fixes, woertlich: "**Korrektheits-Fix, kein Scheduling-Fix; Wirksamkeit
  an `started_at` belegen, nicht am YAML**." — dieselbe Datei, 27.07.2026, MESSUNG.
- **I-7b** **PAT-Rotation, Positionsangaben mit ihrer Historie** (relevant, weil der Index die Regel "PAT
  RUECKWAERTS bis HTTP 200" fuehrt): NACHTRAG **02.08.2026 nachmittags** woertlich: "**PAT-Position 1. von
  hinten (7 Kandidaten) - Rotation weiter bestaetigt.**" Vorher, 27.07.2026, arbeitete der Watcher
  CiCheck288c mit **PAT 2.-von-hinten**; am 01.08. nach der Entstoerung war die Position wieder **1 von
  hinten**. Die **Zahl 7 (Kandidaten)** ist der Nenner, gegen den "rueckwaerts bis HTTP 200" laeuft — ohne ihn
  ist "rueckwaerts" nicht terminierend beschrieben.
  — `reference_ci_trace_parsing_commit_titel_falle.md` (02.08.) und
  `project_20260727_vormittag_o8_fenster_lage.md` (27.07./01.08.), MESSUNG.
- **I-8** **Frontmatter-Befund:** die `description:` dieser Datei nennt nur "2x real am 27.07." — der
  Fliesstext traegt 17 gelabelte Fallen plus zwei datierte NACHTRAG-/KORREKTUR-Bloecke. Bei Widerspruch
  gilt der Fliesstext; der Widerspruch selbst ist der Fund. Dieselbe Diskrepanz traegt
  `reference_lokale_vollbau_luecken_falsches_gruen.md` (description "26.07.", Fliesstext bis 27.07.) und
  `project_20260727_vormittag_o8_fenster_lage.md` (description "27.07. vormittag", Fliesstext bis 02.08.).

**Lokaler Vollbau — der blanke Vollbau luegt:**

- **I-9** **ce-Baum:** die Fassaden-TU `libs/cache_engine/profile_facade/profile_run_facade.cpp` liegt
  **nicht** im `all`-Ziel. MESSUNG: `ninja -t query all | grep -c "profile_run_facade"` → **0**. Folge:
  `cmake --build . && ctest` (z.B. "315/315") kompiliert die Datei gar nicht — Symptom war eine `.o`-Datei
  **aelter** als die editierte Quelle, waehrend ninja "no work to do" meldete. **Pflicht:**
  `cmake --build . --target comdare_profile_run_facade` explizit vor jedem Voll-ctest.
  — `reference_lokale_vollbau_luecken_falsches_gruen.md`, 26.07.2026, MESSUNG.
- **I-10** **super-Baum:** die vendored ce-Unit-Tests liegen **nicht** im `all`-Ziel. MESSUNG:
  `ninja -t query all | grep -c "tests/unit/test_"` → **0**. Folge: ctest registriert ~350 Tests, aber nur
  ~34 Binaries existieren, der Rest ist `***Not Run`. Filter fuer echte Fehlschlaege:
  `ctest 2>&1 | grep -cE '\*\*\*(Failed|Exception|Timeout)'`. — dieselbe Datei, 26.07.2026, MESSUNG.
- **I-11** **2-Pass-Werkzeugpflicht** (Design, keine Luecke): Byte-Wachen
  (`test_permutation_codegen_byte_identity_*`) brauchen `comdare-permutation-codegen`;
  `test_*_registry_roundtrip` brauchen `comdare_axis_registry_gen`, `comdare_system_axis_registry_gen`,
  `comdare_measurement_axis_registry_gen`. Die Byte-Wachen-Nummern unterscheiden sich je Baum:
  **ce 296/297** (im 315er-Baum), **super 292/293**. — dieselbe Datei, 26.07.2026, MESSUNG.
- **I-12** **`mc`-Falle:** `mc` behandelt einen unbekannten Alias als **lokalen Pfad**. Beweislauf mit
  `COMDARE_MINIO_ENDPOINT=fakealias COMDARE_MINIO_BUCKET=fakebucket` schlaegt **nicht** fehl, sondern legt
  still `<cwd>/fakealias/fakebucket/...` an. Konsequenz: Fehlerpfade gehoeren in Unit-Tests mit inertem
  Transport; vor der Paketmeldung `git status` pruefen und das Streu-Verzeichnis entfernen.
  — dieselbe Datei, 26.07.2026, MESSUNG.
- **I-13** **E-1, Hauptursache eines 10/10-falsch-Gruen:** `comdare-adhoc-emitter` laeuft zur
  **CONFIGURE**-Zeit und schreibt 48 r5g-Perm-Quellen; `cmake --build` erneuert das Werkzeug, aber **nie**
  die bereits emittierten Quellen. Pflicht-Reihenfolge: **Werkzeug bauen → RE-CONFIGURE → Vollbau**.
  **E-2:** generierte Header ohne mitgezogenes Erzeuger-Target
  (`comdare_limits_generated_source_catalog`). **J-0:** Alt-Build-Dirs sind Beweisgift — belegt: "alle 320
  ids differieren um genau 1 Segment" war ein **13:41-Binary gegen einen 14:07-Quellbaum**-Vergleich, kein
  echter Quell-Gap. **J-5:** die Test-Zahl N immer mitmelden, die Gate-Menge ist configure-zustandsabhaengig
  (**312 frisch → 314 nach Emitter-Lauf → 316 mit Opt-ins**); Exit-Codes nie durch eine Pipe messen.
  — dieselbe Datei, Nachtrag B-16/B-17, 26.07.2026 abends, MESSUNG.
- **I-14** **JOIN-CHECKLISTE J-1..J-4:** J-1 Werkzeuge zuerst — inklusive `comdare_anatomy_codegen_cli`,
  ohne das die Tests `test_v41_anatomy_r5i_configure_codegen` und `test_v41_anatomy_f15_measurement`
  ausbleiben und ein Clean-Room 314 statt 316 meldet; J-2 Re-Configure; J-3
  `comdare_limits_generated_source_catalog`; J-4 Vollbau → `comdare_profile_run_facade` →
  `--target comdare_tests` → Voll-ctest. **J-4-Zusatz:** mehrere Tests sind `EXCLUDE_FROM_ALL` und haengen
  nur am Sammelziel `comdare_tests` (`CMakeLists.txt:1549`, Property `COMDARE_TEST_TARGETS`). MESSUNG:
  `ninja -t query all | grep -c test_profile_roundtrip` → **0**; ein frischer Vollbau plus ctest meldete
  **"99% tests passed, 1 tests failed out of 316"** ("296 - test_profile_roundtrip (Not Run)"); nach
  `--target comdare_tests`: **316/316, EXIT=0**. — dieselbe Datei, 26.07.2026, MESSUNG.
- **I-15** **Der Registry-Generator luegt in BEIDE Richtungen.** `comdare_system_axis_registry_gen` ist
  `EXCLUDE_FROM_ALL` — ein Bau ohne explizites Target laesst das ALTE Binary liegen, ein Regen schreibt die
  XML dann mit ALTEN Labels zurueck → Byte-Diff leer, Roundtrip **faelschlich gruen**. Literal erlebt: nach
  dem `external_utils`-Rename meldete der Generator weiter `axis id="extension_hardware"`. Zweiter Fall im
  super: `test_kf1_thesis_profile_parser`, `test_experiment_parser`, `test_experiment_plan_director` liefen
  scheinbar rot, weil ALTE Test-Binaries gegen NEUE XMLs liefen (**866 Objekte fehlten**) — nach
  `--target comdare_tests` alle gruen. — dieselbe Datei, Nachtrag O-8 Schritt 3/4, 27.07.2026, MESSUNG.
- **I-16** **Gruene Tests zementieren die alte Ordnung.** Zwei Klassen rutschen durch ein rotes Gate:
  (1) **Fixture-Strings** — `test_g1_binary_version_stamp.cpp:64` und `:98` tragen den ueberholten Kommentar
  "beginnt stets mit `+ext=`", bindend ist **`+cxx=`**; ebenso `test_m_w12_stamp_bausteine.cpp`
  (A4-POD-Roundtrip mit `kSystem` in der **abgeschafften 5-Achsen-Ordnung**). Gegenmittel: Fixtures aus der
  Single Source erzeugen (`compose_system_version_suffix`) statt sie hinzuschreiben.
  (2) **Ein uebersehener dritter Ableitungsweg** — O-8 Schritt 9 zog `load_framework` nur in
  `abi::measurement_stamp_line` ein, es gab aber **drei** Wege; der dritte war die consteval-Fassung
  `ceb_measurement_stamp_array()` in `builder/ceb_version_stamp.hpp`. Gefunden durch einen Drift-Guard, der
  die Gleichheit zweier Quellen prueft. **Lehre: solche Guards nie lockern, um einen Befund verschwinden zu
  lassen.** Praktisch: nach jeder Ordnungsaenderung `grep` auf ALTE Segment-/Achsen-Namen ueber `tests/`
  **und** `libs/`, nicht nur rote Tests abarbeiten.
  — `reference_gruene_tests_zementieren_alte_ordnung.md`, 27.07.2026, MESSUNG.

**Landung — gesichert ist nicht gelandet:**

- **I-17** **Eine rescue-Ref ist keine Landung.** Gefunden 06.08.2026 abends, zwei Tage vor der damaligen
  Abgabe: `rescue/gate8-graph-abbildungen-8970465d` lag seit mittags auf **beiden** Remotes
  (`refs/remotes/origin/...` UND `refs/remotes/github/...`, beide auf **`8970465d`**) und war **in keinem
  Zweig**. Der Commit liegt genau einen ueber dem damals committeten Zeiger und aendert 2 Dateien,
  **+199/-2**: `anhang/{de,en}/A_measurements.tex` — "die **23 Abbildungen** des Graph-Umbaus eingebunden
  (DE+EN)". Das war der TEXT-Teil eines Pakets, dessen CODE-Teil am selben Tag gelandet war.
  **Haertung:** die rescue-Ref hatte einen eigenen **gruenen** CI-Lauf — **Projekt 289, Pipeline 14964**,
  `ref=rescue/gate8-...`, `success`. **"Nicht einmal 'gruen getestet' impliziert 'gelandet'."**
  Anwendung: (1) die Landungsfrage **nur** mit `git merge-base --is-ancestor <commit> <zweig>` gegen
  development UND main je Repo beantworten — nicht mit `ls-remote`, nicht mit "ist gepusht". (2) beim
  Wellenabschluss `git for-each-ref 'refs/remotes/*/rescue/*'` durchgehen, jede Ref ohne Zweig ist ein
  offener Posten. (3) bei Paketen mit Code- UND Text-Anteil beide Seiten einzeln pruefen. (4) eine
  rescue-Ref zu loeschen ist nie die Aufraeumhandlung, solange die Landungsfrage offen ist.
  — `reference_rescue_ref_ist_keine_landung.md`, 06.08.2026, MESSUNG.
- **I-18** **Ein Submodul-Zeiger kann RUECKWAERTS zeigen — `M` heisst nicht "neuer".** Am selben Abend
  (06.08.2026) zeigte `git status --porcelain` im super
  `M Code/external/20260931-overleaf-diplomarbeit`. Ausgecheckter Stand: **`ef448e4b`** (21.07., gesetzt am
  26.07., seitdem 11 Tage unbewegt). Committeter Zeiger: **`29a1700d`** (03.08.).
  `git merge-base --is-ancestor`: der Checkout ist Vorfahr — **Distanz 78 Commits RUECKWAERTS**.
  **Gefahr:** `git add .` / `git commit -a` haette den Gitlink lautlos auf den 21.07. zurueckgedreht (im
  Diff nur eine Hash-Zeile, kein Inhalt). Verloren waeren gewesen: **Thesis-Kapitel 6** (Fazit,
  FF2-Erweiterbarkeit), **Kapitel 5** (Auswertung, Mess-Schema-Modi), **Kapitel 3** (`sec:stamp-model`).
  Verhindert allein durch einen expliziten Pathspec bei jedem Commit dieser Strecke.
  Anwendung: (1) Richtung immer MESSEN (`git -C <super> rev-parse HEAD:<pfad>` gegen
  `git -C <submodul> rev-parse HEAD`, dann `merge-base --is-ancestor` in **beide** Richtungen).
  (2) nie `git add .` / `commit -a` in Submodul-Repos, immer Pathspec. (3) Heilung bei Rueckstand:
  `git submodule update -- <pfad>`, **kein** Commit. (4) vor dem Update die Besitzfrage klaeren —
  `status --porcelain`, `stash list`, `branch -a --no-merged <zeiger>` muessen **alle drei** leer sein.
  (5) Gegenprobe je Submodul einzeln: im selben Repo zeigte der ce-Zeiger korrekt **vorwaerts**.
  — `reference_submodul_zeiger_kann_rueckwaerts_zeigen.md`, 06.08.2026, MESSUNG.

---
**Aus der zweiten Welle (die 49) — fuenf weitere Fallen, jede mit ihrem Beleg:**

- **I-19** **`git` NIE bar aufrufen — immer `git -C <absoluter Pfad>`.** Drei Repos liegen ineinander bzw.
  nebeneinander: `/home/comdare/Projekte/Cluster`, `/home/comdare/Projekte/Research/
  probst-diplomarbeit-cache-engine` (super) und dessen Submodul `Code/external/comdare-cache-engine` (ce).
  Ein bares `git status`/`git log` beantwortet die Frage **immer** fuer das Verzeichnis, in dem die Shell
  steht: die CWD ueberlebt zwischen Aufrufen (ein `cd X && …` wirkt fort), in Agent-Threads wird sie
  zusaetzlich zurueckgesetzt, und **mehrere Teile EINES Kommandos teilen sich EIN `cd`** —
  `cd ce && git log; echo super; git log` misst **zweimal ce**. Drei Eskalationsstufen, real am 26./27.07.:
  (1) `git status` fuer super gemessen, waehrend die Shell in ce stand → leere Ausgabe als "sauber"
  gelesen; der Pfad `Code/test_data_xml` existiert in ce gar nicht, **leer hiess NICHT clean**.
  (2) In einem Kombi-Kommando "=== super ===" ausgegeben und darunter erneut ce gemessen. (3) Teuerste
  Stufe: HEAD von "super" gemessen (Shell stand in Cluster), das Ergebnis wich von der Manager-Angabe ab —
  "und ich war einen Satz davon entfernt, dem Manager einen Fehler zu melden, den er nicht gemacht hatte."
  `git -C <pfad> rev-parse HEAD` fuer beide Repos zeigte sofort: seine Angaben stimmten exakt
  (super **`4abeeb6a`**, Cluster **`14cf7439`** — verschiedene Repos). **Regel:** bei Vergleichen zwischen
  Repos immer **volle** Hashes, nie Kurz-Hashes aus verschiedenen Quellen nebeneinander; und wenn eine
  Messung einer fremden Angabe widerspricht: **zuerst die eigene Messmethode pruefen, dann melden.**
  — `reference_git_immer_mit_c_pfad_cwd_falle.md`, 26./27.07.2026, MESSUNG.
- **I-20** **XML-Kommentare duerfen kein `--` enthalten** (XML-1.0-Spec) — und die ASCII-Auflage des Hauses
  treibt genau das hinein, weil `--` als Gedankenstrich-Ersatz dient. **Warum es teuer ist:** der Fehler
  zeigt sich **nicht** an der editierten Stelle. `xmllint --schema` meldet nur
  `WXS schema <datei> failed to compile` und `Failed to parse the XML resource` — es sieht aus, als sei die
  Schema-STRUKTUR kaputt. Die echte Meldung kommt erst mit `xmllint --noout <datei>` allein:
  `parser error : Comment must not contain '--' (double-hyphen)` **mit Zeilennummer**. **Zweiter Effekt:**
  im normalen Bau/ctest faellt es **nicht** auf, weil der hauseigene DOM-Parser (`xml_reader.hpp`) die
  Kommentare nicht so streng liest — nur ein echter XSD-Validierungslauf faengt ihn. Deshalb gehoert zu
  jeder XSD-Aenderung das **BEWEISPAAR** (Probe gegen NEUE XSD valid + gegen ALTE XSD Fehler +
  Bestands-Dokument gegen beide gleich), nicht nur ein Build. Ersatzformen: Semikolon, Punkt, "bzw."/"also".
  Belegt am Objekt `Code/test_data_xml/experiment_schema.xsd`.
  — `reference_xml_kommentar_doppelbindestrich_falle.md`, 26.07.2026, MESSUNG.
- **I-21** **Die Count-Drift-Wachen fangen das ANHAENGEN nicht** — also genau den haeufigsten Fall. Das
  ce-Muster ist `static_assert(kCountSingleSource == static_cast<std::size_t>(EnumTyp::LetzterWert) + 1);`
  (z.B. `measurement/axis_error.hpp`, D1-Fehlerklassen und D2-SampleStatus); der Kommentar dort verspricht,
  "neue Enum-Werte erzwingen ein Hochzaehlen der Count-Single-Source". **Das stimmt nicht** — die Wache
  pinnt den Count an einen BENANNTEN Enumerator. **Gemessen am 26.07.2026 an einer praeparierten
  Schatten-Kopie:** 6. Klasse sauber angehaengt + Etikett-Case ergaenzt, Count unveraendert → `g++`
  uebersetzte **fehlerfrei (EXIT=0)**. Was die Wache wirklich faengt: Umnummerieren bestehender Werte oder
  einen Count-Bump ohne neuen Wert. **Die fangende Form** — seit ce **`080e7600`** (26.07.) im Header
  `axis_error.hpp:183` verriegelt, zusaetzlich im RF-3-Guard
  `tests/unit/test_rf3_betriebssystem_feature_fehlt.cpp`, beide Richtungen belegt (echter Header
  uebersetzt, Drift-Kopie bricht):
  `static_assert(error_class_label(static_cast<EnumTyp>(kCountSingleSource)) == std::string_view{"unbekannt"}, …)`
  — sie prueft, dass der erste Wert **jenseits** des Counts kein Etikett traegt. **Restluecke:** wer
  anhaengt UND den Etikett-Case vergisst, faellt nur ueber `-Wswitch` auf — **nicht als Fehler aktiviert,
  kein `-Werror` im Projekt**. Bei jedem Taxonomie-Bump **beide** Wachen mitziehen und die Konsumenten des
  Counts **diff-getrieben greppen**: bei RF-3 nannte der Zuschnitt **EINEN** Mitzieher,
  `grep -rn kCompilerCompilerErrorClassCount` fand **VIER**, davon zwei in Tests mit hartkodierter Zahl.
  — `reference_drift_guard_faengt_anhaengen_nicht.md`, 26.07.2026, MESSUNG.
- **I-22** **GitLab-PATs im routable-token-Format enthalten PUNKTE:** `glpat-<base62>.<2-stellige-version>.
  <base62>`, gueltige Tokens **~51 Zeichen**. Die Extraktions-Regex MUSS den Punkt einschliessen —
  `glpat-[A-Za-z0-9_.\-]{20,}` (danach ggf. trailing `.` trimmen). Die naive Regex
  `glpat-[A-Za-z0-9_-]+` schneidet am **ersten Punkt** ab (len ≈ **38**) → abgeschnittenes Token →
  `/api/v4/user` = **401**. **Lektion (K81-74, 27.06.2026):** dieser Bug verursachte einen kompletten
  Fehlalarm "alle 9-13 Vault-PATs sind 401 / GitLab-API tokenlos" (Task #114), obwohl **mindestens 2** PATs
  gueltig waren; punkt-bewusst getestet kam `/user=200` (len ≈ 51). Es wurde dadurch **fast unnoetig ein
  neuer Keeper gemintet**. Vault = `keys/CREDENTIALS-VAULT.md` (gitignored), **nie den Wert echoen**, nur
  den HTTP-Code. — `reference_gitlab_pat_format_dots_regex.md`, 27.06.2026, MESSUNG.
  **ACHTUNG:** die Test-URL derselben Datei zeigt auf den seit 13.07. abgeschalteten `.de`-Host, siehe
  **W-29**.
- **I-23** **Ein main-FF-Watcher MUSS den dev-gruenen SHA PINNEN, nie `git rev-parse HEAD` zur FF-Zeit
  lesen.** Real am 02.08.2026 spaetabends im super-Repo: der Watcher machte
  `dev-CI gruen -> git push origin $(git rev-parse HEAD):refs/heads/main`. Weil der Manager zwischen
  dev-CI-Gruen und FF **lokal weitercommittete** (Owner-Nachtrag), pushte der Watcher **diesen** Commit auf
  main, obwohl er noch nicht auf dev-remote war: **dev-remote `66c6001c`, main-remote `c875e155`** — main
  **vor** dev, Verletzung von "main stets Vorfahr von development". **Behebung:** dev nachziehen
  (`git push origin <lokales-HEAD>:refs/heads/development`), danach
  `git merge-base --is-ancestor origin/main origin/development` == OK. **Regel:** `SHA=<dev-commit>` in
  einer Variablen pinnen und `push origin $SHA:refs/heads/main` — der gepushte main-SHA muss **exakt** der
  sein, dessen dev-Pipeline gruen war. — `reference_main_ff_watcher_pin_sha_nicht_rev_parse_head.md`,
  02.08.2026, MESSUNG.

### 3.9 Repos, Remotes, Buildsystem, Struktur und Naming

- **K-1** **Fehlende Remotes werden immer nachgezogen** — Dauer-Policy, Owner 18.07.2026 woertlich:
  "Bitte merke dir, dass du **immer** (ausser bei Cluster git wegen plain text cred vault, gewollt so) einen
  sync durchfuehrst, wenn eine remote fehlt." Namensmuster auf prod1: `origin` = gitlab.comdare.local,
  `github` = github.com/BenniProbst/<repo>. Verfahren: `git remote add <name> <url>`, read-only mit
  `git ls-remote` verifizieren, dann pushen. **Repo-NEUANLAGE bleibt GO-pflichtig; ein reiner
  Remote-Config-Fix zu einem existierenden Repo ist erlaubt.** **Ausnahme:** Cluster-git
  (`Projekte/Cluster`) **nie** nach github syncen (plain-text Cred-Vault, bewusst gitlab-intern).
  Offener Einmal-Auftrag: Pi 5 und node1 — siehe W-19.
  — `feedback_always_sync_missing_remotes_except_cluster.md`, 18.07.2026, OWNER-WORT.
- **K-2** **comdare-db und Buildsystem sind ZWEI voellig getrennte Systeme mit GETRENNTEN Ledgern.**
  comdare-db **nutzt** das Buildsystem nur zum Bauen. Begruendung: beide Ledger repraesentieren "Millionen
  Tokens Analyse-Arbeit" — eine Vermischung entwertet sie **und verwirrt die Single-Source-Wahrheit je
  System**. Pfade/Namen exakt: comdare-db = eigenes git-Repo
  `Products/comdare-db`, GitHub `BenniProbst/comdare-db`, GitLab `comdare/products/comdare-db`;
  Sessions-Konvention `YYYYMMDD-HH-MM-NNNNNN-*.md` unter `comdare-db/sessions/`. Buildsystem-Ledger:
  `cd-buildsystem-construct/Layer1-Foundation/cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md`, Master-Ledger
  mit den Kennungen **T-01 bis T-61**; Buildsystem-Sessions unter `cd-buildsystem-core/docs/sessions/`.
  **Was konkret ins DB-Ledger gehoert** (die Quelle zaehlt es auf, damit die Trennung entscheidbar ist):
  **Designs, Analysen, M2, ctest, Build-Fixes, Feature-Stubs** — "nie eine comdare-db-M2/ctest/Design-Notiz
  ins Buildsystem-Ledger schreiben (**und umgekehrt**)"; das Buildsystem-Ledger fuehrt **nur
  Buildsystem-TODOs**. Beim Fortschreiben also **immer zuerst die Zuordnungsfrage stellen**.
  **Integrationsregel** bei Beruehrung beider Systeme (Beispiel rc → cd in der `configure.sh` **von
  comdare-db** — die Quelle schreibt "comdare-db-`configure.sh`", gemeint ist die Datei im DB-Repo, nicht ein
  Skript dieses Namens): der Buildsystem-Aspekt kommt ins Buildsystem-Ledger, der DB-Code-Aspekt ins
  DB-Ledger. **Umzugsregel:** additiv umziehen (Zielort schreiben, dann Quellort entfernen), Inhalt
  **woertlich** erhalten.
  — `feedback_comdare_db_and_buildsystem_separate_ledgers.md`, 04.07.2026, OWNER-WORT.
- **K-3** **Hauseigenes Buildsystem ist Pflicht** fuer comdare-Produkte (comdare-web wie comdare-db):
  `cd-buildsystem-core` **v3.4.15** via `buildsystem.xml`, Produkt `cd-buildsystem-construct`. Begruendung:
  das hauseigene BuildSystem fuehrt **Lizensierung** (comdare-licensing / isLicensed / BEP-EULA) und
  **Code-Optimierung** von Haus aus mit — fremde Build-Tools verlieren diese Eigenschaften. Verfahren:
  `buildsystem.xml` von Anfang an pflegen, die cd-buildsystem-Delegation als offiziellen Produkt-Build in
  Goal-Text, Ledger und Invarianten verankern; **CMake/CMakePresets sind nur Light-/Dev-Unterbau fuer lokale
  Iteration, nicht der offizielle Build-Weg.**
  — `feedback_comdare_products_house_buildsystem_mandatory.md`, 05.07.2026, OWNER-WORT. Versionsnummer
  pruefen (W-14).
- **K-4** **Naming-Regression:** die Woerter **"redcomponent"** und **"bep"** sind Struktur-Regression.
  **Marke = Comdare** (alle Produkt-, Modul-, Namespace- und Repo-Namen); **Firma = "BEP Venture UG"** —
  **nur** die juristische Entitaet, in LICENSE-/EULA-/Rechtstexten korrekt zu erhalten. Beispiele fuer die
  Regression: `include/redcomponent/...` in 4 behaltenen foundation-master-Branches (die Rename-Welle
  "redcomponent-* → comdare-*" P3.1/S2683 lief bereits, Reste existieren); eine tote
  `BEPBuildSystem`-cmakePackage-Referenz; "BEP-EULA" als **Produktlabel**.
  — `project_struktur_regression_geteilte_klone_statt_instanz_repos.md`, 07.07.2026, OWNER-WORT.
  Deckt sich mit dem heutigen Index-Eintrag "EIGENTUM" und liefert dessen Begruendung/Historie.
- **K-5** **CI-Template-Redeploy, Sauberkeit nicht clobbern.** Infra rotierte am 26.07.2026 den
  `GITLAB_DEPLOY_TOKEN` (Gruppe comdare id=3, "FETCH_TOKEN"): alt md5 **`9884cd4c`** REVOKED → neu
  **`ee9daa3a`**. Die CI-Template-Vorlage "buildtools" (id=268) wurde **v7.0.3 → v7.0.4** gefixt (kein Token
  in `insteadOf`-URLs, `credential.helper store`). Das Template ist in jedes Projekt **materialisiert**
  (kopiert, kein `include:`) → Infra fuhr einen Mass-Redeploy ueber **200+ Kopien**, inkl. **super
  (Projekt-ID 288)** und **ce (Projekt-ID 286)** auf development. Owner-Wunsch woertlich: "**alles sauber
  halten, nicht mit alten templates und PAT wieder dreckig machen**". Der lokale Klon trug am 26.07. noch
  v7.0.3 (letzter Touch super **`41fbeb4c`** / ce **`90ba442e`**).
  **Fuenf Sauberkeitsregeln:** (1) super und ce tracken `.gitlab-ci.yml` als materialisierte Kopie — ein
  blinder Push koennte v7.0.4 clobbern. (2) vor jedem Push fetch+merge (nie-rebase-Doktrin), **nie**
  `--ff-only`-Blindflug. (3) `.gitlab-ci.yml` **nie** selbst editieren (`git log --since -- .gitlab-ci.yml`
  war in beiden Repos leer, verifiziert). (4) waehrend eines Redeploy-Fensters Pushes zurueckhalten.
  (5) kein alter PAT/Token — den api-PAT blind aus dem Vault ziehen, api-scope ist **nicht** der
  MCP-Token, das revoked `9884cd4c` nie verwenden, Token-Scratch-Dateien nach Gebrauch shred/rm.
  — `reference_ci_template_redeploy_sauberkeit_nicht_clobbern.md`, 26.07.2026, OWNER-WORT + MESSUNG.

**Aus der zweiten Welle (die 49):**

- **K-6** **`gitlab.comdare.de` ist seit 13.07.2026 bewusst ABGESCHALTET** und liefert **404**
  (HAProxy-Default). Kanonisch = **`gitlab.comdare.local`** (external_url; 302 auf `/users/sign_in` beweist
  es). **Gleiche IP 10.0.10.1, gleiche CA, gleicher PAT — nur der Hostname aendert sich**; `.de`-DNS zeigt
  jetzt auf 10.0.60.1. **Remote-Fix je Repo:** `git remote set-url origin
  https://gitlab.comdare.local/<pfad>.git` **plus host-SCOPED CA**:
  `git config http.https://gitlab.comdare.local/.sslcainfo <ca>`. **NIE unscoped** `http.sslcainfo` — das
  ueberschreibt die System-CA und **bricht GitHub-Pushes** ("unable to get local issuer certificate").
  CA: `Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (oder je BS-Zelle `ci/gitlab-rootca.crt`), beide
  `ssl_verify_result=0`. **Credential-Fallstrick (13.07. verifiziert):** `credential.useHttpPath=true` ist
  GLOBAL gesetzt → git matcht per VOLLEM Pfad; ein `.local`-Eintrag fuer **einen** Repo-Pfad matcht die
  anderen Repos nicht → "could not read Username". **Fix ohne Secret-Duplikat:** je Diplomarbeit-Repo
  `git config credential.useHttpPath false` → host-basiertes Matching. Alle 4 Diplomarbeit-Remotes am
  13.07. umgestellt: super `comdare/research/probst-diplomarbeit-cache-engine`, ce `.../comdare-cache-engine`,
  prt-art `.../comdare-prt-art`, thesis `.../20260931-overleaf-diplomarbeit`; GitHub-Remotes bleiben
  unangetastet, **thesis hat KEIN github** (Overleaf-Kette). `minisign` im selben Runbook ist
  **Registry-Artefakt-Signierung** (Ed25519, F-4/Policy B, CI-seitig), **nicht** git-Auth — reiner
  Zeit-Zufall. Runbook: `Cluster/docs/sessions/2026-07-13-comdare-de-abschaltung-gitlab-local-migration-
  und-minisign-runbook.md`. — `reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca.md`, 13.07.2026,
  OWNER-WORT + MESSUNG.
- **K-7** **Die prod1-Arbeitsumgebung, vollstaendig** (seit 05.07.2026 als User `comdare`, vorher root; die
  /root-Klone wurden nach `/home/comdare/Projekte` gespiegelt): super =
  `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, ce = `Code/external/
  comdare-cache-engine`, prt-art = `Code/external/comdare-prt-art`, thesis = `thesis/diplomarbeit`
  **NUR lesen**. Keys: GitLab-PAT `/home/comdare/keys/gitlab-pat` · CA
  `Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` (**immer `--cacert`, nie `-k`**) · GitHub-Token
  `Projekte/Cluster/keys/github-token.txt`. Remotes: `origin` = GitLab (PAT in URL), `github` = GitHub
  (Token in URL; am 05.07. auf super+ce+prt-art angelegt, `ls-remote`-verifiziert deckungsgleich) —
  **Push IMMER beide**. — `reference_prod1_comdare_env_setup.md`, 05.07.2026, MESSUNG.
- **K-8** **Die finale Linie nach dem Infra-Giga-Scrub (26.07.2026)**, Handout
  `Cluster docs/handouts/2026-07-26-HANDOVER-INFRA-an-diplom-agent-FINALE-LINIE-prod1-adoption-overleaf-
  merge.md`: finale HEADs (dev = main, Laptop = node7 = gitlab = github) **super `e542effb` · ce
  `ce81ec62` · prt-art `32e8ffa8`**; prod1 adoptiert (backup-Ref `backup/pre-identity-adopt-2026-07-26`,
  Submodule `--checkout force`). **Alt-SHAs aus frueheren Sessions sind TOT** (Identity-Rewrite; Inhalt
  identisch). **Identitaets-Doktrin:** Diplom-Repos einheitlich `Benjamin-Elias Probst
  <benjamineliasprobst@gmail.com>` (Studenten-Autorschaft, **pruefungsrechtlich**); System-Repos =
  comdare-admin-management; lokale git-config in allen **5** Diplom-Repos gesetzt — **bei NEUEN
  Klonen/Maschinen zuerst setzen.** **Overleaf-Gabelung GELOEST am 01.08.** (Owner-Auftrag "pull github +
  sync gitlab"): Merge-Commit **`06ac320`**; github/main war auf **`683476a`** gewachsen (22 unique, inkl.
  31.07.-Owner-Arbeit); **4 Voll-Fassungs-Konflikte** (Anhang B/E, DE+EN; Basis war ein
  4-Zeilen-Platzhalter) zugunsten der **OVERLEAF-Fassung** geloest (Owner-Content-Hoheit; die
  Kartierungs-Fassung vom 17.07. bleibt via History **`ef448e4`** rueckholbar). **Alle 4 Spitzen synchron:
  origin+github x main+dev = `06ac320`.** prod1-Klon-Falle behoben: der github-Remote zeigte faelschlich
  auf gitlab (`set-url` auf `github.com/BenniProbst/20260931-Overleaf-Diplomarbeit`, **Gross-O**).
  **WEITER OFFEN:** identity-normalisieren (filter-repo, Infra-Territorium), danach super-Gitlink-Bump
  (zeigt bewusst noch auf `ef448e4`, Submodul-Worktree darauf detached) + 3-Maschinen-Adopt; der
  thesis-CI-Beweis der Merge-Fassung steht aus. Backups: PRE-IDENTITY-/PRE-SCRUB-Bundles auf backup2-NFS
  und prod1, backup-Refs auf Laptop/node7 — **NIE loeschen**.
  — `reference_diplom_finale_linie_identitaet_overleaf.md`, 26.07.-01.08.2026, MESSUNG + OWNER-WORT.
- **K-9** **Die 6 `modules/`-Pseudo-Spiegel sind geloescht (04.07.2026, User-Entscheidung).** Die 6
  GitHub-only Sub-Submodule unter `cache-engine/modules/` (comdare-build-tools / cache-engine-core /
  isa-dispatch / measurement / search-engine / test-system) waren **0/6 legit** — reine stale
  Header-Spiegel von `libs/cache_engine/` (ultracode-Audit `wf_9f28bd31`: **0 externe Refs**, nur
  Mirror-Commit-Historie, `build-tools/include` leer → Salvage = ∅). Vollzogen: entnestet (ce **`53ff03a3`**,
  `--cached` wegen OneDrive-FS-Lock) + Super-Bump (**`8f07f8c`**) + **alle 6 GitHub-Remotes geloescht**
  (`gh repo delete`). `ext/queuing/Q01-concurrentqueue` bleibt (echtes Third-Party, cameron314).
  **ABI/golden-320/Mess-Pfad unberuehrt** (reine Repo-Struktur). Anschluss-Arbeit: statt Eigenbau-Spiegel
  die existierenden, reiferen **comdare-*-all-Module** via **Produkt-Referenz-Module** einlinken.
  — `project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules.md`, 04.07.2026, MESSUNG.
- **K-10** **cache-engine == comdare-cacheengine-all: gleiches Remote, zwei Arbeitskopien.** Die
  Diplomarbeit nutzt exakt `github.com/BenniProbst/comdare-cache-engine` (GitLab-Spiegel
  `comdare/research/comdare-cache-engine`, **CI-Projekt 286**). `Modules/comdare-cacheengine-all` bettet
  **dasselbe** Remote ein und enthaelt zusaetzlich **6 Skelett-Zellen** (build-tools, cache-engine-core,
  isa-dispatch, measurement, search-engine, test-system) — es ist das vorbereitete kuenftige
  Firmeninventar-Zuhause, wird vom Forschungsprojekt aber **bewusst NICHT verwendet**; einziges Umbrella
  **ohne** Baseline-System. Zweite Arbeitskopie `Projekte/Modules/comdare-cacheengine-all/
  comdare-cache-engine` ist **stale `c6634d8`**. **TODO GANZ SPAETER (User 03.07.2026):** Forschungsprojekt
  und offizielle Bibliothek nach Baseline-Methodik wieder trennen; bis dahin **cache-engine-Repo
  UNANGETASTET** (Thesis-Track + laufende Mess-Pipeline 286), comdare-db-Wellen bauen nur die
  Skelett-Rahmen (D-5). — `project_cache_engine_research_vs_cacheengine_all_split_todo.md` +
  `project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules.md`, 03./04.07.2026, OWNER-WORT.
  Gehoert zur Familie von **W-18**.
- **K-11** **Das hauseigene Buildsystem ist HALBFERTIG — `buildsystem.xml` nicht anfassen.** User-Antwort F1
  zur #274-Migration (07.07.2026): die `buildsystem.xml`-Dependent-Referenzen sind Artefakte des eigenen,
  noch halbfertigen Buildsystems. Solange es nicht fertig ist: **parallele direkte Entwicklung mit CI und
  CMake**; die **`buildsystem.xml`-Dateien in Ruhe lassen — ein anderer Agent kuemmert sich darum**.
  Referenzmodule werden mit dem eigenen aufzutrennenden cache-engine-Fortschritt fertiggestellt/erweitert;
  **halbfertige Funktionen werden fertiggestellt, sofern in einem notwendigen Modul erkannt.** Anwendung:
  bei Migration/Transfers NUR CMake-/CI-Referenzen fixen, `buildsystem.xml`-Aenderungen weder vornehmen
  noch als Blocker behandeln (im Handover notieren).
  — `feedback_buildsystem_xml_hands_off_parallel_ci_cmake.md`, 07.07.2026, OWNER-WORT. Verhaeltnis zu
  **W-14** (`cd-buildsystem-core` v3.4.15): die Version steht, das System ist nicht fertig.
- **K-12** **Standalone-Bau der ce-Unit-Tests (ohne Diplomarbeit-Orchestrierung), Pflicht-Reihenfolge** —
  sonst C1083: (1) `cmake -S . -B build/msvc-release` **einmal** genuegt seit Fix **`febc020`** (frueher
  2x wegen GLOB-Ordering-Bug; `tests/unit/CMakeLists.txt` leitet `COMDARE_ALL_AXIS_GENERATED_DIRS` jetzt
  aus dem SOURCE-Tree ab = ordering-invariant). (2) **11 Paper-Codegen-Targets** bauen (erzeugen
  `*_is_original.hpp`, ESET-Freigabe beim ersten Lauf): `comdare_paper_{a04_mimalloc, a05_jemalloc,
  a07_snmalloc, a10_rpmalloc, a11_lrmalloc, a20_dlmalloc, p01_art, p02_hot, p05_start, p07_wormhole,
  p10_surf}_codegen`, alle `module=ALL ORIGINAL`. (3) Test-Target bauen, dann die `.exe` **direkt**
  ausfuehren — die Post-Build-gtest-Discovery wirft ein harmloses **MSB3073**, die `.exe` entsteht
  trotzdem: `build/msvc-release/tests/unit/Release/<test>.exe`. **Drei vorbestehende Blocker:**
  (a) q01 concurrentqueue — geloest per Submodul-Init (siehe H-18); bei frischem Klon
  `git submodule update --init --recursive`, weil ext-Paper teils Submodule und **nicht** vendored sind
  (anders als `ext/allocator/A04-mimalloc`, das committed ist); Submodul-Init ist **keine** Repo-Aenderung.
  (b) `test_concepts_compile`, `test_value_handle`, `test_six_page_structures`, `test_three_layer_audit`
  includen `prt_art/*.hpp` direkt → bauen **nur** im Diplomarbeit/prt-art-Kontext. (c) builder-Pilots
  (`anatomy_codegen_pilot_*`, `anatomy_multi_pilot_*`, `comdare_anatomy_codegen_tool`) referenzieren die
  Glob-Var noch nicht. **Das Build-Dir `build/msvc-r2` aus alter Uebergabe existiert NICHT mehr** —
  `build/msvc-release` nutzen. — `reference_cache_engine_standalone_build_pipeline.md`, 28.05.2026,
  MESSUNG. STAND: MSVC-Stand vor der prod1-Migration; die Codegen-Reihenfolge gilt weiter.
- **K-13** **Die konsolidierten Doku-Master-Pfade** (Pflicht-Pre-Read laut Datei) unter dem Praefix
  `Diplomarbeit - Datenbanken/docs/`: `docs/INDEX.md` · `docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
  (10-Phasen-Plan K-A bis K-J) · `docs/NAMING_CONVENTIONS.md` (V12.5) · Glossar K-D **DONE**
  (`01_begriffsglossar_v7_master.md` mit **~161 KANON-Begriffen**, `02_domaenenmodell_v4_master.md`,
  `03_versionshistorie.md`) · Bausteine K-E **DONE** (`01_bausteine_matrix.md` **85 Bausteine / 11 Achsen**,
  `02_allokator_matrix.md` **23 Allokatoren / 7 Achsen / 5 Cluster**, `03_cross_paper_konzeptmatrix.md`
  **18 Konzepte ueber 33 Paper**, `04_architekturentscheidungen_F1_F15.md` **25 ADRs**,
  `05_flag_system.md` **9-Bank**, `06_eigenschaften_suchalgorithmen.md` **23 Algorithmen**) · Architektur
  K-C **pending** · Forschungslandkarte K-F **pending** (`01_quellen_gesamtkatalog.md`: 33 Paper P01-P33 +
  23 Allokatoren A01-A23 mit Vollangaben) · Termine-Konsolidiert K-G **pending** · Termine-Original K-B
  **refresh DONE** (`docs/termine/INDEX.md`, 8 Termine `20260330 Termin 1` … `20260515 Termin 8`).
  **Konfliktregel je Phase: spaetere Version gewinnt** — Begriffsglossar v7 > v6 > v5 > v4 > v3;
  Domaenenmodell v4-KORREKTUR > v3; Architektur REV7.7 > 7.6 > 7 > 6 > 5 > 4 > 3. **Und die Doku-Direktive
  in derselben Datei:** Original-Quellen unter `docs/termine/…` bleiben unveraendert; die konsolidierten
  Master-Doks **referenzieren nur (Pfad+Zeile), kopieren nicht voll-Inhalt.**
  — `reference_documentation_master_paths.md`, 15.05.2026, AGENTEN-BEHAUPTUNG.
  **⚠ Der Pfad-Praefix existiert nicht mehr — siehe W-32.**

### 3.10 Prozess-, Berichts- und Verifikationsregeln

- **L-1** **Abschluss-Aufraeumpass**, Owner 27.07.2026 ~00:40 woertlich: "Bitte merke dir, dass nach der
  Bearbeitung aller bekannten Aufgaben die **deprecated header und toter code aufgeraeumt und entfernt**
  werden muessen." **Praezisierung der Doktrin:** "Doku nie loeschen" gilt **nur fuer DOKU**
  (Session-Docs / Ledger / Manuals bleiben mit SUPERSEDED-Vermerk) — **CODE**-Artefakte werden nach Abschluss
  **entfernt**, nicht nur deprecated-gebannert. Verfahren je Fund: Aufrufer-Grep = 0 belegen, Tests
  nachziehen, granularer Commit; der Pass selbst ist ein benanntes Paket mit ultracode-Planung (vor+nach).
  — `feedback_abschluss_aufraeumpass_deprecated_code_entfernen.md`, 27.07.2026, OWNER-WORT.
- **L-2** **Kandidatenliste des Aufraeumpasses** (Stand 27.07.2026, in der Datei als "fortschreiben!"
  markiert und seither nicht aktualisiert — vor Ausfuehrung gegen den heutigen Stand pruefen):
  `ce tools/permutation_codegen/{codegen.cmake, codegen.sh, codegen.bat, axes_versions.txt}` plus Tool/CLI
  (V-4-Retire-Scope) · `super Code/02_messung_driver/permutations_runtime_check.hpp` (V-2-deprecated) ·
  `ce cmake/isa_features.cmake`, Funktion `COMDARE_apply_simd_flags` (Zeilen 103-123, **0 Aufrufer**,
  Beifang V-4) · `ce cmake/permutations.cmake` (faellt mit V-4) · historisierte Tripwire-Texte auf erledigte
  Auflagen (Beispiel: der RF-3-Hinweis in `machine_identity.hpp`) · der `_IDS`-Alias von
  `COMDARE_GOLDEN_320_BYTE_GUARD_IDS` (deprecated seit GN-8) · die `COMDARE_LEGACY_MESSREIHEN`-Bloecke
  (erst nach Bestaetigung der golden-320-Subsumtion, V-5c). — dieselbe Datei, 27.07.2026,
  AGENTEN-BEHAUPTUNG. **Teil-Vollzug belegt:** V-4 RETIRE am 27.07. ~18:50Z, Commit **`813c3232`**,
  **-2183 Zeilen**, `comdare_permutation_codegen_cli` **existiert nicht mehr** (siehe M-8).
- **L-3** **Der Atlas braucht IMMER eine Korpus-Gegenpruefung**, Owner 05.08.2026 woertlich: "gehe davon
  aus, dass du den Atlas **IMMER nochmal gegenpruefen** musst, weil Details noch ungenau sind und **nicht
  ueber die Planung der letzten 6 Wochen gedeckt** sind." Fuenf Owner-Review-Runden fanden real diese
  Fehlerklassen im Atlas: falsche Wurzel (Gattung), falsche Achsen-Zahl, fehlende Binary-Topologie,
  fehlende Klammern, fehlendes Zukunfts-SOLL, CoR statt Strategy.
  — `feedback_atlas_immer_korpus_gegenpruefung.md`, 05.08.2026, OWNER-WORT.
- **L-4** **VERSCHAERFUNG 06.08.2026**, Owner woertlich: "es gibt **3 Versionen** dieser UML Zusammenfassung
  und die letzte ist **nicht superseded, sondern nur vorlaeufig** und braucht unbedingt immer Verifikation,
  bevor das geglaubte auch bewiesen ist - die Planung war teils ungenau." Der **05b-Atlas (REV 5**, Kopie in
  super UND ce) ist damit **vorlaeufig** erklaert und **nie** Beweis-Quelle; jede daraus uebernommene
  Aussage ist am Objekt zu verifizieren. Verfahrens-Konsequenz: der Atlas-Nachzug nach L1 ist ein
  **Verifikations**-Pass (IST gegen Behauptung), kein Fortschreibungs-Pass; jede Atlas-Aenderung braucht
  Korpus-Fundstellen je Aussage; Ungedecktes wird als "**UNGEDECKT — Gegenpruefung offen**" markiert.
  **Frontmatter-Luecke:** das `description:`-Feld dieser Datei nennt nur die 05.08.-Regel — die
  Verschaerfung vom 06.08. steht **nur** im Fliesstext. — dieselbe Datei, 06.08.2026, OWNER-WORT.
- **L-5** **Berichte am Prioritaetenfaden erzaehlen**, Owner-Ruege 06.08.2026 woertlich: "**Bitte lies bis zu
  meiner letzten Nachricht nochmal - du schreibst zusammenhanglosen Mist**". Kritisiert wurden namentlich
  die Kuerzel **NB-2, CX-B1, E-2a** und die `wf_`-IDs. Vereinbarte Prioritaetenreihenfolge zu dem Zeitpunkt:
  **P0-P4**, mit **P0 = "Binaries + Messwert-Lager zuerst"**. Der konkrete Einordnungsfehler, der die Ruege
  ausloeste: der "Format-3-Neuanker" ist die **Fingerprint-/Skip-Mechanik des Binary-Baus** und damit
  P0-Substanz — er wurde aber wie ein Auswertungs-Nebenschauplatz berichtet.
  — `feedback_berichte_am_prioritaeten_faden.md`, 06.08.2026, OWNER-WORT.
- **L-6** **Das Ledger darf regulaer geupdatet werden**, User 17.07.2026 woertlich: "Das ledger darf
  **regulaer geupdated** werden, nicht nur additiv, sobald der workflow durchdringt. **Neuere Fakten
  schlagen immer aeltere Fakten.**" Vorherige Praxis war strikt-additiv (nur NACHZIEH-Vermerke, das
  Original stehenlassen) und liess das Ledger auf ~1800+ Zeilen mit stale Passagen und Widerspruchsschichten
  anwachsen. Anwendung: im LEDGER (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`) duerfen ueberholte
  Aussagen **in place** korrigiert/ersetzt werden, die Historie bleibt ueber git erhalten (granular
  committen). Gilt ab der Landung des Konsolidierungs-Workflows **`wf_d5ba4b2b`** (17.07.2026); dessen
  additive NACHZIEH-Vermerke sind der letzte Alt-Stil.
  — `feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere.md`, 17.07.2026, OWNER-WORT.
  **Abgrenzung, wichtig:** "nie loeschen, nur deprecaten" gilt **weiter** fuer eigenstaendige Doku/Dossiers
  (`docs/sessions/backups/`, Architektur-Doks) und **uneingeschraenkt** fuer Messdaten — und damit auch fuer
  die 106 Quelldateien dieser Konsolidierung. **Zwei Dokumentklassen mit unterschiedlicher Doktrin, nicht
  verwechseln.**
- **L-7** **Ein Paketschnitt, der nur in einem Session-Dokument steht, existiert fuer die Ausfuehrung
  nicht** — Session-Doc ist **BELEG**, Ledger und Checkliste sind **REGISTER**. Am 06.08.2026 am Objekt
  belegt: der F9/LB-Paketschnitt **LB-0..LB-6** (Lager-Baum-Vollausbau, ausdrueckliche Vor-Trigger-Pflicht:
  "der Voll-Bau-Trigger IST der Baum-Vollausbau") stand ausschliesslich in zwei Session-Dokumenten vom
  01.08. Gegenprobe mit Musterzaehlung (die Quelle traf 3x):

  | Muster | Ledger | TODO-Register 06.08. (474 Zeilen) |
  |---|---|---|
  | `LB-[0-9]` | 0 | 0 |
  | `OE-B` | 0 | 0 |
  | `F9-Paketschnitt` | 0 | 0 |

  Owner-Reaktion woertlich: "**wurde nicht gelesen??**" — und niemand hatte die Quelle zur Hand, obwohl sie
  existierte. Die Pointe der Quelle, woertlich: "**Die Arbeit war sogar gebaut; verloren war die
  Buchfuehrung.**" Der Satz, der die Regel traegt: "Eine Kette mit Vor-Trigger-Rang, die in **keinem
  Register** steht, wird beim Abarbeiten der Register **nicht abgearbeitet**."
  — `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht.md`, 06.08.2026, MESSUNG + OWNER-WORT.
- **L-8** Die Ursache lag **nicht** an der Zeitspanne (der 01.08. lag im erhobenen 14-Tage-Fenster), sondern
  an der fehlenden **QUELLENKLASSE** `docs/sessions/*`: das Register nannte seine Quellen selbst
  ("Ledger 23.-31.07.", "Ledger 01.-06.08.", "Dossier/Doku-Register", "Live-Lesung des Fahrplans") — diese
  Klasse fehlte. Die fruehere Zusage "das 14-Tage-Fenster trug alles Aktive" ist fuer diese Kette
  **widerlegt**. Zusaetzlicher Sucht-Fehler mit gleichem Effekt: ein Scope suchte mit **heutiger** Vokabel
  (`Binary-Stub`, `Dummy-Strategie`), waehrend die Planung vom 01.08. andere Woerter fuehrt (`OE-B`,
  `Dummy-Lager`, "Textdateien mit Stempel-String"). Die Quelle fasst das in einen Satz, der als eigene Regel
  zu lesen ist: "**Eine Suche in der Sprache des Suchenden statt in der des Dokuments findet Abwesenheit, wo
  Anwesenheit ist.**"
  **Vier Anwendungsregeln:** (1) jede Kette mit Vor-Trigger-/Abgabe-Anspruch **sofort** in Ledger UND
  Vor-Trigger-Checkliste eintragen. (2) bei jeder Konsolidierung die **Quellenklassen explizit auflisten** —
  `docs/sessions/*` ausdruecklich mitnehmen oder den Ausschluss begruenden (in diesem Dokument: Abschnitt 1).
  (3) bei Negativ-Befunden mindestens **zwei Vokabular-Generationen** probieren (heutige plus die der
  vermuteten Entstehungszeit). (4) bei jedem "0 Treffer" die **Gegenprobe** des Musters an einer Datei, die
  treffen MUSS. — dieselbe Datei, 06.08.2026, MESSUNG + AGENTEN-BEHAUPTUNG.

**Aus der zweiten Welle (die 49) — Autonomie, Freigaben, Manager-Regeln:**

- **L-9** **Autonomie-Grant 20.07.2026:** Fable hat die ausdrueckliche Erlaubnis, den **gesamten
  v3.2-Plan** von vorn bis hinten in allen Phasen/Stufen/Paketen **autonom durchzuziehen — auch nachts,
  ueber Kontextuebergaben hinweg**; Start automatisch nach gruenem CI-Endstand. **Innehalten NUR bei echten
  Entscheidungs-Rueckfragen, die NICHT per ultracode selbst aufloesbar sind. Bei Unsicherheit sofort
  stoppen**, sonst alles in einem Rutsch. — `feedback_autonomie_modus_plan_autonom_durchziehen.md`,
  20.07.2026, OWNER-WORT.
- **L-10** **REIFE-GATE MATERIALISIERUNG (User 20.07., spaet):** die schwere 2^17-Materialisierung
  (131072 DLLs) ist **NICHT opportunistisch/nachts** zu starten, sondern **reife-gated** — ERST Plan v3 +
  zu klaerende Folgeaufgaben **vollstaendig** abarbeiten (zuverlaessige XML-Steuerung: S4-KERN inkl.
  KERN-B, S5, Ende-zu-Ende verifiziert), Owner woertlich: "sonst erhalten wir keine zuverlaessigen
  Ergebnisse; wir sind noch nicht weit genug, um in die XML unsere Wuensche zu definieren und jenes
  Ergebnis erwarten zu koennen." **Naechte = Code-Kette, nicht verfruehte Materialisierung.**
  **Thesis-Grenze bestaetigt:** Textarbeit erst NACH Code+Messergebnissen; **Anhaenge B/E = absolut autonom
  freigegeben** (XML-angefragte Experiment-Ergebnisse konform einpflegen) als LETZTER Schritt der Kette.
  — dieselbe Datei, 20.07.2026, OWNER-WORT.
- **L-11** **VOLL-FREIGABE 21.07.2026 ("bitte merke dir das"):** **ALLE bekannten Punkte + die §62-Pakete
  (#45-#52: Cache-Log-Claim, COMPARE, XML-Gate/golden-neu, System-Achsen/Tools, tier150) autonom — auch
  nachts — DURCHZIEHEN, bis nach Plan v3 und den vielen weiteren Paketen KEINE OFFENE ARBEIT mehr erkennbar
  ist.** End-Kriterium der Autonomie-Schleife = **leeres erkennbares Arbeits-Backlog**. **Branch-Regel
  dabei: DURCHGEPLANTE Punkte → main** (dev→main-Merge nach verifiziertem, CI-gruenem Abschluss);
  **HALB-GEPLANTE → development.** — dieselbe Datei, 21.07.2026, OWNER-WORT.
- **L-12** **Strang A UND B vollautonom (20.07. spaet, "Volles GO"):** das hebt die zuvor harten
  USER-GO-Gates fuer diese Ausfuehrung auf — die golden-neutralen [A]-Pakete **und** die gateten
  [B]-Pakete (KERN-B golden-Fenster K5+K7a, S5→S6-320er→S7→S8, golden-Regen-Voll-Materialisierung,
  N>1-golden-Topologie) sind vorab genehmigt. Weiterhin: je Paket ultracode-Planung + Verifikation je
  Stufe; bei genuiner Unsicherheit stoppen; **major/irreversible Schritte (S6-320er-Mehrtages-Messlauf) vor
  Ausfuehrung ANKUENDIGEN**, aber nicht auf ein Per-Gate-GO warten. Infra-Punkte (PAT-Rotation #327 etc.)
  gehen per `Cluster/docs/sessions/`-Handover an den Infra-Agenten. — dieselbe Datei, OWNER-WORT.
- **L-13** **POST-v3-ANSCHLUSS-AUTONOMIE (20.07. nacht):** nach dem v3-Plan-Strang (S5-Smoke → S6 → S7 →
  S8) geht es **direkt und autonom** mit den Post-v3-Features weiter. Die Post-v3-TODO-Liste ist ein
  **FULL JOIN (nichts verwerfen)** aus (a) den wiederbelebten + ge-GOten deprecated Features (Audit 20.07.:
  CLI → `.so`-Schnitt → Resolver+CoR → F-SPREAD + LOHNT-TEILWEISE gate-getrieben) und (b) den offiziellen
  Post-v3-Features **PV-1..PV-9** (NUR vom 20.07. diktiert — **nicht** der Alt-Backlog Band-C/D, der
  separat als G1-G7-Merkposten laeuft). Persistiert in Ledger §60 + POST-V3-REGISTER.
  — dieselbe Datei, 20.07.2026, OWNER-WORT.
- **L-14** **VOR UND NACH jeder Aufgabe ein ultracode-Workflow** (User 18.07.2026): VOR = Design-Planung,
  NACH = Pruefung/Konformitaets-Review (adversarial, "wie der Sweep, der opt-g vor dem Fehltritt rettete").
  **Die Planung ist die Quelle der Wahrheit** — der Bau folgt ihr, die NACH-Pruefung verifiziert
  Konformitaet gegen den Plan; findet sie Verstoesse → beheben, bevor die Aufgabe als fertig gilt.
  **Autonomie-Scope derselben Direktive:** autonom **ohne Rueckfragen** fuer ALLE offene Arbeit an
  **Cache Engine + Diplomarbeit-CODE**; **AUSNAHME (bleibt User-Sache): der Diplomarbeit-Haupt-TEXT**
  (Thesis-Prosa/Inhalt); **aber auch autonom:** das **Einfuegen der Messwerte in LaTeX** und die
  **PDF-Erstellung allgemein**. — `feedback_vor_und_nach_jeder_aufgabe_ultracode_plus_autonomie_scope.md`,
  18.07.2026, OWNER-WORT.
- **L-15** **Jede Aufgabe wird durch eine ultracode-Planungssession vorbereitet** — User 17.07.2026
  verbatim: "**Jede Aufgabe muss durch eine ultracode Planungssession ueber ledger und ALLE
  Planungsdokumente vorbereitet werden, weil diese Bestandteile aufgrund der Systemkomplexitaet nicht alle
  vollstaendig in den Kontext passen koennen.**" Ergaenzend: "Bereite die Bau-Phase vor, **ich gebe sie
  danach explizit frei** und wir ueberschreiben die Direktive des Anhaltens." Begruendung: Ledger
  (~1800+ Zeilen) + ~20 Design-Dossiers + Ist-Code uebersteigen jeden Einzel-Kontext (Anlass-Historie:
  v32-Parallel-Engine, #31-Fehlbau). **VERSCHAERFUNG 17.07. abends, verbatim:** "**stets zu jeder Aufgabe
  und Entscheidung, die vom Plan abweichen koennte, erst einen ultracode Planungs-Workflow gegen Ledger und
  Plaene durchziehen, um wirklich auf der Spur der Konformitaet zu bleiben, NIEMALS etwas erfinden oder
  raten.**" ⇒ Trigger ist **jede Entscheidung mit Abweichungs-Potenzial**, nicht nur "neue Aufgabe"; reine
  Ausfuehrung eines bereits belegten Plan-Schritts braucht keinen neuen Workflow, sobald aber Ermessen oder
  Neu-Design im Spiel ist → ultracode ZUERST.
  — `feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs.md`, 17.07.2026, OWNER-WORT.
- **L-16** **Je Paket: ultracode-Planungsagent VOR Beginn** (User-Ergaenzung 20.07. zum Autonomie-Grant).
  Reihenfolge je Paket: (1) ultracode-Planungsagent (liest Ledger §55 + themenrelevante Plandocs, klaert
  Root-Cause/Design/Owner-Dateien, **nie raten**) → (2) Implementierung delegieren → (3) Verifikation je
  Stufe (cf22 + ctest + super-Sub-Build/Clean-Build + Mojibake + Dual-Push + CI hart-gruen).
  — `feedback_per_paket_ultracode_planung_vor_ausfuehrung.md`, 20.07.2026, OWNER-WORT.
- **L-17** **Die User-KERN-Beschreibung war SCHON IMMER Gesetz.** User 20.07.2026: weicht ein gerade
  durchzufuehrender Plan von der beschriebenen Regel ab, **MUSS es sich um eine Regression oder
  Ungenauigkeit handeln** — dann orientiert man sich **immer an der letzten User-Beschreibung**, nicht am
  moeglicherweise verfaelschten Plan. Begruendung: ueber die lange Arbeit haben sich in Plaenen/Dokumenten
  Regressionen gegen die urspruengliche Architektur eingeschlichen (der "Fluch" der Legenden-Regression).
  Anwendung: bei Divergenz die **User-Beschreibung als Wahrheit** nehmen und die Divergenz **als Regression
  fixen** — nicht die User-Spec an den Plan anpassen.
  — `feedback_user_kern_beschreibung_ist_immer_gesetz_abweichung_ist_regression.md`, 20.07.2026, OWNER-WORT.
- **L-18** **Eine Task-Zuweisung ist KEIN Start-Signal.** Traegt der Task ein Start-Gate ("Start nur auf
  explizites Signal des Architekten") oder Sequenzierungs-Sprache ("eigener Increment NACH der
  Sammel-Kadenz"), MUSS auf das explizite Start-Signal gewartet werden. Bei **Task #31 (19.07.2026)** wurde
  vor dem Signal implementiert — diesmal folgenlos (goldene Wachen + Architekten-Kadenz trugen es), "aber
  an golden-kritischen Naehten kann genau das die Byte-Beweiskette zerreissen". **Zusaetzlich:** hat man
  eine **bessere** Loesung als die beauftragte (bei #31: der Root-Cause-N-Sweep-Kollaps statt des
  beauftragten Push-Filters), **ERST den Gegenvorschlag melden und den Nod abwarten, DANN bauen** — nicht
  eigenmaechtig die bessere Variante durchziehen. Guardrails/Gates aus dem Task-Text **nie als erledigt
  annehmen**. — `feedback_task_assignment_not_start_signal_respect_gates_propose_first.md`, 19.07.2026,
  OWNER-WORT + AGENTEN-BEHAUPTUNG.
- **L-19** **Working-Tree-Freeze nach Paket-Meldung (Commit-Race-Schutz).** **Zweimal real passiert
  (21.07.2026):** der Agent landete weitere Aenderungen zwischen Manager-Verifikation und `git add -u` →
  der Commit enthielt mehr als die Message nannte. Konkret **`a3dcfea3`**: Message nannte g/h/i/j1/j2,
  Inhalt war g-k; **die Diff-Stat-Abweichung +249 gegen +257 waere der Tell gewesen**. Folgen: Belege
  gelten fuer einen anderen Stand als den committeten, Messages werden unehrlich, **kein Rewrite moeglich
  nach Push (nie rebase)**. **Regeln:** (1) Impl-Agent friert nach Paket-Meldung den Working Tree ein bis
  zur Commit-Bestaetigung; post-Report-Arbeit nur in neuen, explizit gekennzeichneten Dateien.
  (2) Manager prueft **unmittelbar vor `git add`** den `git diff --stat` **literal** gegen die gemeldeten
  Zahlen; bei Abweichung stoppen und nachfragen. (3) Nachtraeglich entdeckte Einschluesse per
  annotierendem `--allow-empty`-Commit dokumentieren (additiv, kein Rewrite).
  — `feedback_agent_working_tree_freeze_nach_paketmeldung.md`, 21.07.2026, MESSUNG + Regel.
- **L-20** **Nachrichten an Agenten im Freeze WECKEN sie und werden als Arbeitsauftrag gelesen.** Zweimal
  real im O-8-Fenster (27.07.2026), beide Male ohne Schaden nur dank Agenten-Disziplin: (1) **O8b** meldete
  Kontext-Ende → Nachfolger gespawnt → O8b bekam wieder Kontext und wollte weiterbauen. (2) **O8c** meldete
  Kontext-Ende mit offenen Entscheiden → die Entscheide-Nachricht enthielt "**GO fuer 5b als eigener
  Commit**" UND "**der 5b-Commit geht an deinen Nachfolger**" **in EINER Nachricht** → O8c las das GO und
  baute 5b komplett, waehrend der Nachfolger mit demselben Auftrag lief. **Ursache:** `SendMessage` an
  einen ruhenden Agenten **resumed** ihn — es gibt keinen passiven Empfang; jede Nachricht ist ein Weckruf.
  **Manager-Regeln:** (1) an Agenten im Freeze nur Nachrichten mit eindeutigem Kopf — "**NUR ZUR KENNTNIS -
  KEINE ARBEIT**" ODER woertlich "**ARBEITSAUFTRAG:**"; (2) **NIE ein GO und eine Nachfolger-Uebergabe in
  derselben Nachricht** — erst die Uebergabe entscheiden, DANN kommunizieren; (3) nach jedem
  Nachfolger-Spawn dem Vorgaenger **sofort** den Nur-Antwort-Freeze setzen; (4) Nachfolger-Briefings
  enthalten IMMER "pruefe vor jedem Edit auf fremde Aenderungen; bei Fund: STOPP+Meldung, nichts
  einbauen/verwerfen" — das hat beide Rennen entschaerft.
  — `feedback_freeze_nachrichten_eindeutig_nur_antwort_vs_arbeitsauftrag.md`, 27.07.2026, MESSUNG + Regel.
- **L-21** **Die Owner-Haltung zur Gruendlichkeit, woertlich (26.07.2026):** "**Wir schaffen es und wenn
  nicht ist auch nicht schlimm, hauptsache so ordentlich wie moeglich.**" — im selben Eintrag, in dem das
  Einschub-Paket STRUKT-R vor den Trigger gezogen wird.
  — `project_achsen_neuordnung_bindende_sortierung_regressionen.md`, 26.07.2026, OWNER-WORT.
  Deckt sich mit H-13 ("Frist hat Vorrang vor Batch-Perfektion" → Owner: "**Nein**").

---

### 3.11 Die Kette: Planer → CEB → Tier, Docks und Stufen

Sieben der 49 tragen die Bau-Topologie. Keine davon war im Index — sie hingen alle an der ausgelagerten
Zeile "Kette/XML".

- **Q-1** **Stufen-Zuordnung (User-Entscheid 19.07.2026, Ledger §30, revidiert die fruehere Zuordnung):**
  **Mess-Achsen-Permutation wandert von der CEB in den Planer.** **Planer = Mess-Achsen · CEB =
  System-Achsen · Tier-Binaries = Organ-Achsen + optionaler Hybrid-Einschub** → **3-4 Binaries in EINER
  Kette, top-down sequentiell generiert**: Planer bestimmt das Messsystem und **kompiliert HART ein
  effizientes CEB je Messsystem** → CEB kompiliert Tier-Binaries (Organ) → CEB kann nach Mess-Auswertung
  **Heuristik-Hybrid-Tier-Binaries** entwickeln, die ihrerseits echte Tier-Binaries **delegiert durch CEB**
  entwickeln/laden (rekursive Delegation).
  — `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md`, 19.07.2026, OWNER-WORT.
- **Q-2** **Der Gesamtbaum:** EIN Experiment-B+-Baum, Nodes je Achsen-Art **gefaerbt** (Traeger =
  `AxisKind{organ, system_measurement, system_config}`) und **filterbar** → Zerlegung in
  Achsen-Art-Teilbaeume, je Stufe permutieren (lazy Permutationskette, gestaffelt in Achsen-Arten).
  **Join-Modi:** Organ-Achsen per Pruefling erweiterbar ueber `MergeStrategy` (**CeOnly / PrueflingReplace
  / FullJoin**) = JETZT; **System-/Mess-Achsen-Join ebenfalls vorgesehen, aber nach hinten geschoben**
  (Abgabe zuerst). **Mess-Modi** = XML-Steuerbefehle je Achse ODER Gesamtexperiment (enumerierte Range oder
  benannte Algorithmus-Listen, permutiert durchtesten). — dieselbe Datei, 19.07.2026, OWNER-WORT.
- **Q-3** **§36-Pool-Modell (19.07.2026):** jede Node baut **bevorzugt ihre maximal verfuegbaren
  System-Achsen-Eigenschaften** + nachgelagerte lazy Permutationen aus dem Pool — **unter Locking** (eine
  System-Permutation auf genau EINEM Runner/EINER Concurrency; Mechanik = GitLab `resource_group` je Zelle
  + MinIO-Dedup als 2. Schicht). **N amd64-Nodes** (nicht nur 2): kleine Nodes (Odroid-H4-Klasse) bauen
  no_extension-Zellen mit; avx2/avx512 nur wo Hardware (**3-stufiges Tag-Routing amd64/avx2/avx512**).
  **Ein Planer kann multiple CEBs bauen** (je Messsystem, weitere Matrix-Dimension).
  **Freigabe-Kopplung:** die System-Achsen-Freigabe (CEB) erlaubt erst die Kompilation der
  **SIMD-ORGAN-Achsen** — die Organ→Tier-Umsetzung liegt auf der Organ-Schicht als **gekoppelte Achse**
  (das G7-constexpr-Gate wird zum Bau-Gate). — dieselbe Datei, OWNER-WORT.
- **Q-4** **§38-Revision (19.07.2026):** die fruehere Festlegung "Planer→CEB eindimensional / kein
  Rueckkanal" ist **UEBERHOLT**. (1) Planer→CEB-Nutzlast = **per Serialisierung uebergebener unterer
  Teilbaum** (System-Achsen + freigegebene/regulaere Organ-Achsen als **Ranges je Achse**); die CEB
  permutiert lazy und delegiert die Kompilation. (2) CEB→Planer = **sparser Fortschritts-RUECK-KANAL**
  (Cursor/Delta je Permutation: nur die Achsen-Deltas der lazy Materialisierung fuer die naechste
  Tier-Binary; **Mixed-Radix-konform**). **KEIN Mess-Daten-Rueckfluss.** Die obere Dock-Grenze ist damit
  **bidirektional mit asymmetrischer Nutzlast**. — dieselbe Datei, OWNER-WORT.
- **Q-5** **§38.b Ein-CEB-Exklusivitaet (19.07.2026):** nur **EINE** (messende) CEB gleichzeitig —
  **multiple CEBs (je Messsystem) laufen SEQUENTIELL**; der §38-Fortschritts-Rueckkanal ist das
  Fertig-Signal fuer die Planer-Sequenzierung (ohne Feedback keine Allein-Lauf-Garantie → Messfehler).
  **Abgrenzung:** der §35/§36-**BAU**-Pool (provision-only) bleibt **parallel**; die Sequentialitaet gilt
  fuers **MESSEN** (Debug-Modus parallel ohne Garantie, §32-F7). CI-Mechanik: globale `resource_group`
  (z.B. `ceb-measurement-exclusive`) fuer Mess-Jobs. — dieselbe Datei, OWNER-WORT.
- **Q-6** **TERMINOLOGIE-KERN (Owner 05.08.2026, verbatim): "CacheEngineBuilder == CEB."** Der Begriff
  bezeichnet **woertlich** den CacheEngineBuilder — am Objekt: die Binary `apps/cache_engine_builder`
  (`add_executable cache_engine_builder`; `main.cpp`-Kopf "CacheEngineBuilder — Library-Wrapper REV 7.6"
  um `comdare::builder::ExperimentDriver`). **Kein separates Schicht-Etikett, keine fehlende Klasse — die
  BINARY ist die CEB.** Die Atlas-/Ledger-Formulierung "existiert nicht als benannte C++-Klasse" war
  irrefuehrend gerahmt und ist beim Kette-Nachzug zu korrigieren. — dieselbe Datei, 05.08.2026,
  OWNER-WORT + MESSUNG. Zur Konformitaets-Frage des REV-7.6-Kopfs siehe **W-31**.
- **Q-7** **F6-ZIELBILD-KERN (Owner 05.08.2026, verbatim):** "**Der Planer taktet zukuenftig selbst, er
  baut und ruft seine CEBs und diese bauen und rufen die Hybriden (mit anhaengigen Tier-Binaries) oder die
  Tier-Binaries selbst. Das ist umfassend geplant, wo ressourcen freigegeben werden (Explore).**" — die
  rekursive **RUF**-Kette (nicht nur Bau-Kette) ist Zielbild; der Planer taktet die CEB-Sequenz SELBST
  (`resource_group` ist nur Ist-Traeger bis dahin); die Ressourcen-Freigabe-Planung liegt im Korpus
  (Systemachsen-Freigabe/Pool/Locking) und ist vor dem W1-Design per Explore zu erheben.
  — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **Q-8** **Die DEHNBARE Stufen-Doktrin (Nachtrag 05.08.2026, Owner-abgenommen LEDGER mittag-11).** Die
  Zuordnung aus Q-1 ist die **STUFE-1-TRAEGER-Zuordnung** (wo die RT-Freigabe jeder Achsen-Art sitzt),
  **nicht** "jede Achsen-Art lebt nur in ihrer Binary". Kanonisch (LEDGER-Nachtraege mittag-9/-10):
  **MESS = DREISTUFIG dehnbar** Planer (Stufe 1: RT-Freigabe) → CEB (CT-Einbau: Mess-Design +
  Pruefdock-Konfiguration) → [Hybrid (CT)] → Tier (CT: Observer/Ausstattung) ·
  **SYSTEM = ZWEISTUFIG dehnbar** CEB (RT-Freigabe HW) → [Hybrid (CT): gibt sich selbst + Tiers die
  System-Config CT mit] → Tier (CT) ·
  **ORGAN = ZWEISTUFIG, hybrid-unberuehrt**, NUR in Tier-Binaries verbaut (CEB-RT-Freigabe der lazy
  Permutations-Wahl → Tier-CT) ·
  **GESETZ: Stufe 1 IMMER RT-Freigabe in der Traeger-Binary, Folgestufen CT-Einbau entlang
  Planer→CEB→Tier** · **HYBRID = Factory-Pattern-Facade-Adapter** (organ-frei; erbt als eingeschobene
  4. Stufe ALLE Eigenschaften, reicht Mess- UND System-Eigenschaften CT weiter; Mess+System-Stempel,
  **KEINE Organ-Identitaet** — `binary_id` bleibt Organ-only). — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **Q-9** **Die rekursive Dock-Architektur (User 17.07.2026, "um ganz sicher zu gehen").** Zwei Ebenen,
  dasselbe Muster: **Ebene 1 "EXPERIMENT-DOCK" (Experiment-Planer ↔ CEB), EINDIMENSIONAL** — der Planer hat
  ein Dock fuer **C++23-ABI-stabile CEB-`.so`-Programme**; der Vertrag ist eindimensional, der Planer
  **STEUERT** die Einstellungen der von ihm kompilierten CEB (**kein Rueckkanal hier**) und bestueckt jede
  CEB mit verschiedenen **System-Achsen (+ System-Unter-Achsen) Algorithmen + Einstellungen**.
  **Ebene 2 "PRUEF-DOCK" (CEB ↔ Tier-Binary), BIDIREKTIONAL** — die CEB ist selbst eine **ABI-stabile
  `.so`**, **System-Achsen-VERSIONIERT**, und hat ihr eigenes bidirektionales Pruef-Dock zu ihren
  Tier-Binary-`.so`-Interfaces (CEB treibt an ↔ Tier-Binary meldet Messergebnisse ABI-stabil zurueck);
  dort kompiliert die CEB die C++23-ABI-stabilen Tier-Binary-`.so`-Module.
  — `feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md`, 17.07.2026, OWNER-WORT.
  **Anmerkung:** die Eindimensionalitaet der Ebene 1 wurde zwei Tage spaeter durch **Q-4** aufgehoben.
- **Q-10** **Ergebnis-Rueckschrieb laeuft NICHT ueber das Experiment-Dock:** die CEB schreibt nach
  Bestimmungen des Experiment-Planers die angeforderten Aufgaben + Messwerte **selbst** an das in der XML
  eingegebene Ziel zurueck (§11-G: `measurement/<YYYYMMDD-HHMMSS>/`, Write-Token id=54, Loop-Schutz
  `[skip ci]` + `_bot_`). **Tier-Binaries, zwei Formen:** (a) **heuristisch** — mit noch EINER Ebene NACH
  dem Command-Pattern in einer **compile-time Chain-of-Responsibilities** (virtuell) — oder (b) **plain**.
  **Kompile-Reihenfolge:** die CEB kann verschiedene **Gattungen** bauen + durchmessen, muss aber VORHER
  **auf deren Observer + Module kompiliert** werden: **System-Konfiguration → Mess-Achsen-heuristische
  Konfiguration.** Der **Anatomy-Major-4→5 reitet am Experiment-Planer-Dock** (gegenueber der
  CEB-Messsystem-Erstellung). — dieselbe Datei, 17.07.2026, OWNER-WORT.
- **Q-11** **Der Planer ist ZWINGEND eine eigene Binary mit Shell-CLI** (Owner-KERN 05.08.2026, verbatim):
  "Der Planer ist ZWINGEND eine eigene Binary mit dem User-CLI-Interface auf der Shell" — damit wird die
  Post-v3-Anforderung R3 von einem Ausrichtungs-Wunsch zur **harten Struktur-Pflicht**: Planer =
  eigenstaendige Binary (**nicht** Header-Bibliothek im ce-Baum, **nicht** Teil des `messung_driver`s),
  Shell-CLI = das User-Interface, **Abweichung = Regression**. **F1: HARTES GO Planer-Binary-Split VOR
  ABGABE** — "sonst werden die Binaries aller Stufen nicht korrekt gebaut".
  — `project_post_v3_anforderungen_so_abi_driver_split_cli.md`, 05.08.2026, OWNER-WORT. Siehe **W-30**.
- **Q-12** **Die drei Post-v3-Anforderungen (User 20.07.2026 spaet, Ledger §60):**
  **R1 — `.so`-ABI-Vertrag Planer↔CEB:** der Vertrag wird derzeit durch **Textemission** aufgeloest, nicht
  ueber eine schnelle **C++23-`<modules>`-`.so`**-ABI-stabile Schnittstelle, die Messergebnisse (bei
  **~131.000** Ergebnissen) schneller transportieren koennte — eine "/btw"-Anfrage meinte, das sei bewusst
  verworfen/deprecated, **pruefen ob Wiedereinfuehrung sinnvoll** (die rekursive Dock↔`.so`-Doktrin **war**
  einmal dekretiert, siehe Q-9; §37a Fork-C `.so`-Schnitt = A8-deferred).
  **R2 — `measurement_driver`-Verantwortlichkeiten:** er ist auf Planer und CEB **verteilt**;
  User-Hypothese: die Mess-Achsen des Planers steuern die **Ausstattung** der CEB, und die CEB enthaelt den
  **eigentlichen** `measurement_driver` — "sind das dann **zwei Module / Unter-Klassen derselben
  Klasseninstanz**?" (zu klaeren).
  **R3 — Planer als CLI:** fuer Bauen/emit und Ueberwachung der Tier-Builds; er soll **Zustand/Builds/
  Messungen der CEB und Tier-Binaries loggen**; der User will das Programm spaeter **manuell mit der
  XML-Config fahren** koennen.
  **Hintergrund-Direktive derselben Datei:** "Opus-Agenten verwerfen bei Unterbrechungen schnell den Turn
  und filtern schlecht, was deprecated ist — **Fable kuratiert deprecated Features**."
  — dieselbe Datei, 20.07.2026, OWNER-WORT.
- **Q-13** **Weitere Owner-Antworten zur Kette (05.08.2026, Kurz-KERNe, Verbatim im Ledger mittag-1):**
  **F5 PRUEFSTAND-DOKTRIN:** ALLE Tier-Binary-Interfaces (= Interfaces der MAP-Gattungs-Huelle) testen die
  **REALEN** Implementierungen der metaprogrammierten `SearchAlgorithmBase`; ALLE Achsen-Algorithmen UND
  Tier-Interfaces **mit DEEP-RESEARCH-TESTS NACH dem Compile belegen** — ein `std::map`-Oracle allein =
  "**Absolut NEIN**". **F7 Planer-Rueck-Leser JA** (der Planer liest Messwerte + Tier-Stand zurueck und
  gibt User-Feedback; die CEB bleibt eigenstaendig). **F6 sauberster Weg NACH PLAN, NIE RATEN.**
  **F2/F3/F4:** die Antworten liegen im Plan-Korpus (**>1200 beantwortete Fragen**) — erst Explore-Welle,
  dann ggf. mit mehr Kontext fragen. — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **Q-14** **PRT-ART traegt DREI Rollen gleichzeitig — wer nur eine nennt, beschreibt es falsch.**
  PRT-ART = "Probst Redirect Tree / ART hybrid" (`comdare-prt-art/CMakeLists.txt:7`).
  (1) **KONSUMENT** — die Include-Richtung ist einseitig PRT-ART → CE (`CMakeLists.txt:23-27,61-67`).
  (2) **PRUEFLING** — Owner-Wort 14.07.2026, typed: "**Der prt-art ist weiterhin ein separater Pruefling,
  bitte notiere das so.**"; eigenes Thesis-Kapitel `03_messsystem_prtart.tex`; die Registry sagt es selbst:
  "prt-art bleibt ein SEPARATER PRUEFLING … sie mergt prt-art NICHT in den CEB"
  (`prt_art_axis_registry.xml:5-7`). (3) **PLUGIN** — `COMDARE_CE_PRUEFLINGE` →
  `include(comdare_pruefling.cmake)` (ce `CMakeLists.txt:723-731`); die Repo-README sagt woertlich:
  "**prt-art ist ein reines Plugin**". Die Thesis fasst alle drei in einem Wort: **bidirektional**
  (`kapitel/de/04_concept_architecture.tex:136-143`).
  **Das nested Submodul ist seit 29.05.2026 AUFGEHOBEN** — Beleg `comdare-prt-art/CMakeLists.txt:14-21`:
  "KEIN nested Submodule mehr … (Hebt die nested-Submodule-Direktive 2026-05-12 auf; E6/#22.)"; heute sind
  beide **Geschwister**-Submodule von super. **Weitere Einzelheiten:** die CE traegt eine **native
  Nachbildung** von PRT-ARTs Kernidee im eigenen Quellbaum
  (`libs/cache_engine/compositions/prt_art_reference.hpp`, rein aus CE-eigenen `topics/`-Headern) — und
  laut Quarantaene-Banner in `prt_art_execution_engine_adapter.hpp:2-6` ist **genau das der einzige aktive
  Mess-Pfad**, nicht das externe Repo. **PRT-ART ist NICHT der Lehrbuch-ART** (Leis/Kemper/Neumann,
  ICDE 2013 = eigener SOTA-Baustein `compositions/art_reference.hpp`); im Katalog sind es zwei Lebewesen:
  `prt_art` und `art`. **Von 5 Achsen ist nur EINE golden verdrahtet:** `path_compression`
  (`golden_wired="true"`); `page_type`, `prefetch`, `telemetry`, `value_handle` sind reine
  Slot-Demonstration. **Der "Legacy-Baum" ist GELOESCHT:** das ce-Gatter
  `COMDARE_PRT_ART_LEGACY_AVAILABLE` prueft die Datei-Existenz von `prt_art/include/prt_art/prt_art.hpp`
  unter der ce-Wurzel — **Gegenprobe `find /home/comdare -iname prt_art.hpp` = 0 Treffer** (am 10.08.2026
  von diesem Dokument nachgemessen: **ebenfalls 0**). Stand 10.08.2026: **116 Commits**, letzter
  **`c6f0754`** vom 03.08.; naechster Architekturschritt gegated bis zum ABI-Fenster.
  — `feedback_prt_art_consumes_cache_engine.md`, 10.08.2026, MESSUNG + OWNER-WORT.

### 3.12 Registries, Experiment-XML und die Mess-Schema-Steuerung

- **R-1** **Registry = ANGEBOT, Anwender-XML = ANZEIGE, Planer = Resolver** (User 19.07.2026,
  verbatim-treu): die Registries muessen so aufgebaut sein, dass der **Experiment-Planer die waehlbaren
  Optionen je Achse aus dem ANGEBOT parsed als XML-Bibliothek** — Elemente werden **erst nach Registrierung**
  in der Anwender-XML **erkannt und korrekt verlinkt**. Die Registry enthaelt ein Format, das die
  CacheEngine **fuer das ANGEBOT des Compiles interpretieren** kann; die **Anwender-XML ZEIGT AN**, welche
  **Experimente, Achsen, Einstellungen, Flags, Unter-Achsen (VOLLER Support) und Ablaeufe+Ranges**
  durchzufuehren sind. Modell: "**mini-Python-Interpreter, aber auf nativer XML-Basis, viel eher aehnlich
  zu einer Java `.pom`**" (Maven: deklaratives Manifest + Dependency-Resolution gegen Repository).
  **Unregistriertes = harter Validierungsfehler statt stillem Verhalten.** Andocken statt danebenbauen:
  `validate_profile.hpp` (linkt heute schon ids gegen die Registry) um Unter-Achsen/Flags/Ranges/Ablaeufe
  erweitern; **kein Python**; der Resolver laeuft zu Planer-/Configure-Zeit (CT-Doktrin).
  — `feedback_registry_angebot_anwender_xml_pom_resolver_planer.md`, 19.07.2026, OWNER-WORT.
- **R-2** **§28: DREI art-spezifische Registries, je im Modul ihrer Achsen-Art** (19.07.2026):
  (1) **Organ-Registry** (`cache_engine_axis_registry.xml` im ce-Achsen-Modul + `prt_art_axis_registry.xml`
  als Prueflings-Organ-Angebot), (2) **System-Registry** (NEU, im System-/measurement-Modul: **6/7
  CEB-System-Achsen** + Unter-Achsen `opt_level`/Flags/Commands/`simd`/`march`/`target`), (3)
  **Mess-Registry** (NEU, im Mess-Modul: **16 Kategorien**, Kollektoren, DynamicDims, Workload-Achse).
  **Haupt-/Unter-Semantik:** Haupt-Achse = statisch im Ziel-Binary (CT-einkompiliert), ihre optionalen
  Unter-Achsen-Einstellungen = meist **dynamisch im Ziel-Binary** (RC-POD/DynDims). **Der Resolver linkt
  die Anwender-XML gegen ALLE DREI Bibliotheken.** — dieselbe Datei, 19.07.2026, OWNER-WORT. Siehe **W-25**.
- **R-3** **ZWEI Registry-XMLs gleichen Schemas + die Diplomarbeit-XML als 3-Phasen-Vorlage**
  (User 13.07.2026): (1) **ce-Registry** katalogisiert die je Achse in der CACHE-ENGINE vorhandenen
  Bausteine (Stand der Technik); (2) **prt-art-Registry** katalogisiert die je Achse im PRT-ART
  vorhandenen Bausteine, abstrakt auf Basis der ce-C++23-Bibliothek. **Die Bausteine je Achse stehen NUR in
  den Registries, NICHT in der Diplomarbeit-XML.** Die **Diplomarbeit-Experiment-XML** definiert NUR die
  **VORLAGE** — die **3 Phasen der Pruefung** (Phase 1 prt-art / Phase 2 cache-engine / Phase 3 kombinierte
  Achsen von beiden = 3-Stufen-Join `pruefling_merge.hpp` Stufe 1/2/3) + welche Engines/Lebewesen +
  Mess-Settings (3 Mess-Modi, workloads, datasets, `measurement_categories`, `op_types`, `output`). Sie
  **referenziert die zwei Registries und listet selbst keine per-Achse-Bausteine**. Sie vereint die
  heutige **Familie A** (`comdare_thesis_profile`) und **Familie C** (`messreihe_v32`) in EINEM Dokument.
  **`permutation_axes.xml` koennte die ce-Registry SEIN** → dann TABU-read-only + prt-art-Registry additiv
  daneben (im Design-Workflow zu klaeren). **v32-Modul → STRATEGY-PATTERN** der Experimentier-Configs
  (jede Phase/Config = eine Strategy). **Harte Zusatz-Constraints:** Pruefling-Registries befolgen das
  ce-Parser-Schema **HART** (keine Schema-Abweichung erlaubt) — nur so ist der Pruefling gegen den Stand
  der Technik testbar; die Diplomarbeit ist der **Anwender**, die Cache-Engine die **ausfuehrende Engine**;
  die E2E-Kette ist **ce-getrieben** (`sota_catalog` → `COMDARE_DEFINE_ANATOMY_MODULE` → DLL).
  **FOLGE-PFLICHT:** alle Plaene/Doks, die auf dem E2E-Prinzip aufbauen, erneut gegen ALLE Anforderungen
  pruefen UND erweitern; eigener Audit-Durchlauf (ultracode) **nach** der Implementierung.
  **TABU-Liste derselben Direktive:** `golden_fullpilot_320` / `CatalogAxes<4,4,5,4>=320` (#229) /
  `serialize_composition_path` / POD-1416 / `permutation_axes.xml` **UNBERUEHRT** — Registry + Unified-XML
  additiv, golden-neutral, Default-OFF (`COMDARE_V32_DRIVER_ENABLE`). Verdrahtung EE-A/EE-B an **REALE**
  Katalog-DLLs, nicht `std::map`/`unordered_map`-Surrogate. Design-Workflow-Backups:
  `super/docs/sessions/backups/20260713-{achsen-gattungen-metaprog, familie-c-design-dossier,
  audit-3-schema-familien}/`. — `feedback_unified_experiment_xml_plus_system_registry_xml.md`, 13.07.2026,
  OWNER-WORT.
- **R-4** **Registry-Pfade kommen per CMake-Interface als statische, dokumentierte Pfade** — **nicht** per
  env, **nicht** per Co-Location neben der XML (User 16.07.2026, Antwort auf den I2-`registry_dir`-Fork;
  Dossier 17 R1/R2). **Je CacheEngineBuilder EINE Achsen-Registry-XML** am dokumentierten statischen Pfad;
  **je CacheEngine UND je PRT-ART eine** (= **2-Registry-Kanon**; Registries sind die **alleinige,
  statische** Baustein-Ablage je Achse). **Ist-Pattern schon da:**
  `COMDARE_CE_AXIS_REGISTRY` / `COMDARE_PRT_AXIS_REGISTRY` + `COMDARE_V32_EXPERIMENT_GOLDEN_XML` als
  compile-defs (`ce tests/unit/CMakeLists.txt:2568-2570`, `super Code/02_messung_driver/CMakeLists.txt:117`).
  **Kanonische Orte:** ce `libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml`, prt-art
  `prt_art/algorithm_profiles/prt_art_axis_registry.xml` — **verschiedene Verzeichnisse → per-Engine-
  Aufloesung, kein gemeinsames `registry_dir/<filename>`**. Der **Experiment-XML-Pfad** kommt per
  CMake-Interface an die cache-engine (Default gebacken + argv/env-Override, Muster
  `COMDARE_THESIS_PROFILE` / `COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE`).
  — `feedback_ceb_config_cmake_interface_static_registry_paths_prt_module.md`, 16.07.2026, OWNER-WORT.
- **R-5** **PRT-ART = ein MODUL der CacheEngine:** verlangt der Anwender es per XML, wird es per
  Metaprogrammierung **full join additiv an die ce-Achsen kompiliert, je nach Phase** (compile-time,
  Familie-C via `PrueflingSlot`; **nie HART verdrahtet, nie Surrogat**). **Build-Mechanik
  (User-Praezisierung 16.07.):** das ce-Framework kompiliert eine **versteckte root-Minimal-Binary = den
  Experiment-Planer**, gebaut aus einer **CMake-Konfiguration des Anwenders (Diplomarbeit)** aus den
  ce-Bibliotheken, in den Diplomarbeit-Code — dadurch bekommt die Diplomarbeit ein **XML-ABHAENGIGES
  Build**; die **CacheEngineBuilder + deren Tier-Binaries landen untergeordnet als tiefe Build-Struktur**
  der Diplomarbeit. Die Pfade sind immer klar, weil ce + PRT-ART je als **external Modul** an festen
  relativen Orten liegen (der Planer uebergibt die Pfade). **Die XML nennt explizit NUR EINEN Pfad: den
  Ziel-Ordner, wo die Ergebnisse der Anfrage gespeichert werden** — alle uebrigen Pfade sind
  build-strukturell statisch. Die Ergebnisse werden **zuerst statisch im BUILD-Pfad generiert und nach der
  Messung in den XML-Ziel-Ordner kopiert/kompiliert.** Der Experiment-Planer ist die **3. Framework-
  Anwendung**. — dieselbe Datei, 16.07.2026, OWNER-WORT. **Zur "versteckten" Binary siehe W-30.**
- **R-6** **Der KERN der Mess-Schema-Steuerung (User 20.07.2026, ausdruecklich "nicht vertagbar — ohne sie
  keine Steuerung, das IST der Kern"):** **Default = ALLES messen.** Die Experiment-XML ist ein
  **negatives Blacklisting**: aus der generellen Whitelist (alle Achsen + vorhandene Einstellungen) gibt
  sie nur spezielle zu messende Teilbereiche frei; ohne Einschraenkung werden auch geladene Prueflinge
  permutativ mitgemessen. **Kein Pruefling definiert** → nur die Cache-Engine permutativ ueber sich selbst
  + alle Achsen. **Pruefling(e) definiert** → direkt nach der Cache-Engine wird jeder Pruefling gemessen;
  **Default-Modus = Prueflings-Achsen ersetzen die CE-Achsen komplett (replace)**, alternativ **merge** =
  Umfang des gesamten CE+Pruefling-Hybriden je Pruefling. **Nach allen Prueflingen + CE**: je Achse werden
  Algorithmen nicht mehr ersetzt, sondern per **full join** in der CE kombiniert = "kombiniert"-Modus
  (**der full join verwirft nichts**) ⇒ die 3 Stufen: **Phase 1 CE-allein / Phase 2 Pruefling
  replace|merge / Phase 3 kombiniert-fulljoin**. **Die XML muss das gesamte Mess-Schema definierbar
  machen:** welche Messmodi einstellbar; ob **alle** oder nur **bestimmte** Achsen gemerged/ersetzt werden;
  von **welchem Pruefling** (Variablenname ODER statisches `"CacheEngine"`-Identitaets-Pattern); je Achse
  nur bestimmte Algorithmen **whitelisten**; ODER ein **Template (Research-Gesamtalgorithmus)** laden + je
  Achse weiter einschraenken/erweitern. **Planer→CEB-Verdrahtung:** der Planer parst die XML so, dass die
  **CEB je Achse versteht, was zu tun ist**; **Haupt-Achsen werden statisch per Metaprogrammierung in die
  CEB einkompiliert** → die Interpreter je Haupt-Achse sind nach CEB-Compile **fix**; zur CEB-Laufzeit
  treiben die Achsen-Einstellungen das **Emit der Tier-Binaries**.
  — `project_planer_mess_schema_kern_pruefling_replace_merge_fulljoin.md`, 20.07.2026, OWNER-WORT.
- **R-7** **ID-Satz, Storage und die Stempel-Regel dazu (User 20.07.2026):** die Pruefling-Merges erzeugen
  einen **EIGENEN ID-SATZ** — Tier-Binaries mit allen Mess-Artefakten zusammen, dem jeweiligen Pruefling
  zugefuehrt + gespeichert. **Storage:** Unterordner unter root **LOKAL (Default)** ODER per XML in
  `minio.comdare.de`. Nur Prueflingsseite gemessen → eigener id-Satz; bei Merge/Join → **je Merge-/Join-Art
  eine eigene Mess-Kategorie der Artefakte, mit-gecached**. **STEMPEL-REGEL:** die **Namen + Versionen
  jeder Achsen-Algorithmen immer im Stempel deklariert**, PLUS ein **DRITTER Tier-Binary-Stempel = die
  Merge-Kombination** (zusaetzlich zu den zwei §58-Arrays System + Organ). **golden-Konsequenz:** der
  ce-only-golden (**`0xF1C1F26A1232073B`**) bleibt **byte-identisch** — die Merges sind ein **additiver**
  eigener id-Satz; der Emitter haelt den ce-only-/Identitaets-Pfad byte-gleich und fuegt die
  Merge-Emission separat gestempelt/gecacht hinzu. — dieselbe Datei, 20.07.2026, OWNER-WORT.
- **R-8** **Stempel-Vorlage / Anatomy (User 20.07.2026):** der `AnatomyVersionLines`-POD ist der
  **Prototyp/die Vorlage** fuer Versionierungsstempel. Die "Anatomy" = die **Rekombination ALLER in einer
  Stufe (Planer/CEB/Tier) vorhandenen Achsen**, die dort versioniert werden. **GO**, sie nach Plan zu
  reparieren + weiterzuentwickeln (K7a Merge-Stempel-POD jetzt im golden-Fenster; K7b §58-Array-Umbau als
  Weiterentwicklung, eigenes golden-Fenster). — dieselbe Datei, OWNER-WORT.
- **R-9** **Mess-Tooling ist compile-time (User 20.07.2026):** {**Wallclock / Makro / Micro**} ist eine
  **Unter-Achse des Mess-Toolings**; per XML kompiliert die passende CEB die noetigen Mittel ein (alle oder
  teilweise Einzel-Messeinrichtungen). **Scharfschaltung N>1 erst bei S6** (wenn der Planer CEB emitten
  kann). Die Einstellung {Wallclock/Makro/Micro} ist **compile-time FIX in CEB UND Tier-Binaries per
  Metaprogrammierung**. — dieselbe Datei, OWNER-WORT. Verhaeltnis zu **W-07/D-6**: das ist die
  §47/§54-T2-Auswahl-Achse, keine Aussage ueber Wallclock-Granularitaet.
- **R-10** **Template / Paper-als-Pruefling (User 20.07.2026):** das benannte `<template>`-Element ist
  gewuenscht (Features spaeter erweitert). **Perspektive (post-v3): die Cache-Engine-Registry UND die
  PRT-ART-Registry fuehren echte Template-Profile fuer bekannte Paper — jedes Paper = eigener Pruefling**,
  der den Stand der Technik ergaenzt (Voll-Template-Split spaeter in der CE nach Paper-Definitionen +
  echtem, nach Achsen vorsortiertem Code). Fuer jetzt: `mode="full"` funktioniert, referenzierte Templates
  spaeter. — dieselbe Datei, OWNER-WORT.
- **R-11** **Ergebnis-Serialisierung (User 16.07.2026; verfeinert die E1-"Spalte je Achse"-Entscheidung und
  beantwortet F3(i)/Reihe C).** Der Permutationsraum ist ein **layer-sortierter, lazy durchlaufener, NICHT
  materialisierter Baum** — muss aber **serialisiert MIT den Endergebnissen** vorliegen koennen.
  **Systemachsen-Ebene → FLACH als Ordnerstruktur** (je Systemachsen-Kombination ein Ordner).
  **Tier-Binary-Achsen + CSV-Messwerte → serialisierter TIEFER Baum** ueber alle Achsen + Permutationen.
  **Spalten-Sparsamkeit:** die **statischen compile-time-Achsen** (Algorithmus-Wahl je Achse,
  `binary_id`-bestimmend) UND die **Systemachsen** werden **NICHT als CSV-Spalten** geschrieben (in jeder
  Zeile identisch = Verschwendung) — stattdessen in **Ordnerstruktur + Beschriftung/Metadaten der
  Mess-Datei**. **NUR die dynamischen Unter-Achsen** (laufzeit-veraenderlich: Workload, RC-Settings,
  P/E-Core, NUMA, Multithreading) bleiben **Spalten**. **Reihe C = Option C (BEIDES):** der
  SdT-vs-Pruefling-Vergleichs-View UND die build-ueber-Build-Regression.
  — `feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns.md`, 16.07.2026,
  OWNER-WORT.
- **R-12** **Q1-Q4 FIXIERT (User 16.07.2026, Gesamtkonzept-Abklaerung):** **Q1** = (b) flach je Binary +
  Sidecar-Manifest (Achsen-Wahl als Metadaten) + separater Baum-Index. **Q2** = JA (statische
  per-Achsen-Spalten fallen weg, nur `binary_id` + Ordner + Metadaten; `;phase;engine` + dynamische
  Unter-Achsen bleiben Spalten) — **ABER jede compile-time-statische HAUPT-Achse traegt weiterhin ihre
  geplanten dynamischen Laufzeit-UNTER-Achsen**; der **Experiment-Baum wandert in den Experiment-Planer**
  und filtert System- + Tier-Binary-Achsen rekursiv beim Bau. **Q3** = additiv gespiegelt
  (Systemachsen-Ordner + Tag-Spalten resume-sicher, spaeter deprecaten; schuetzt
  `test_profile_roundtrip==320`), Reihenfolge grob→fein **Host → OS → Toolchain → ISA**. **Q4** = (b)
  On-Disk-Baum + maschinenlesbarer Index-Manifest (speist CoR-Auswertung + beide Reihe-C-Views) + CEB
  erzeugt im Build-Pfad + **atomarer build→ziel-Copy** in den XML-`<output>`-Pfad. Plus: Zelle = `"failed"`
  statt `null` bei Algo-Fehler. — dieselbe Datei, 16.07.2026, OWNER-WORT.
- **R-13** **Der Parser gehoert als MODUL in den allgemeinen ce-Parser**, nicht standalone: der Parser fuer
  das Experiment-XML gehoert in `ce/libs/common/serialization/xml_config_parser`, `parse_thesis_profile`.
  Der am 13.07. gebaute standalone `super/Code/02_messung_driver/messreihe_v32_parser.hpp` (super
  **`6a40fb9`**) ist eine **Zwischenstufe** → als ce-Modul integrieren, den super-Standalone
  **deprecaten (nicht loeschen)**. **WAS/WIE: Framework-Parser = ce.**
  — `feedback_unified_experiment_xml_plus_system_registry_xml.md`, 13.07.2026, OWNER-WORT.
- **R-14** **Nur EINE Steuerung, in C++, moeglichst NICHT CMake (Performance; User 13.07.2026):** die
  Experiment-/Tier-Binary-Orchestrierung ist C++-getrieben (der CEB, **nicht** CMake-Logik/Re-Configure je
  Permutation — **bei 320+ Binaries sonst katastrophal langsam**). **CMake baut NUR die ce-Lib + die
  CEB-Executable einmalig.** Konkret: der Registry-Generator ist ein **C++-Tool**, **keine**
  CMake-`COMDARE_GEN_AXIS_REGISTRY`-Option. Die Experiment-Ausfuehrung (F/G-Verdrahtung) laeuft **DURCH**
  den CEB (baut Tier-Binary aus compile-time-Komposition → treibt sie durch das Pruefdock → misst ueber das
  Messsystem), **nicht** ueber direkt konstruierte Engine-Adapter. Der Welch/EE-A-EE-B-Verdikt-Layer
  konsumiert die Messungen aus dem CEB-Messsystem via Pruefdock (`PruefDockRegistry::select_for` by genus,
  mess-transparent CE-Tier UND Pruefling-Tier). **Ersetzt die quarantaenisierten Surrogat-Adapter**
  (`PrtArtHashBackend=std::unordered_map`). — dieselbe Datei, 13.07.2026, OWNER-WORT.
- **R-15** **ZENTRALISIERUNG (User 13.07.2026, als spaeteres TODO markiert):** der CacheEngineBuilder wird
  **DAS zentrale EXPERIMENT-FRAMEWORK**. Alle Tools der 4 Repos **kartieren**; die FRAMEWORK-Tools
  (super/ce) **strategisch in den CEB mergen**: Registry-Generator, 0X-Pipeline-Stufen (03/04/05/08),
  `latex_anhang`, `messung_driver`, v32-Parser. Der CEB kann zusaetzlich die **DIPLOMARBEIT-CODE-
  GENERATOREN als BIBLIOTHEK** aufnehmen (Excel- + PDF-Auswertungen). Ziel = **EIN zentrales System nach
  dem XML-Aufbau, KEIN verteiltes.** **⚠ prt-art bleibt ein SEPARATER PRUEFLING (NICHT in den CEB
  gemergt)** — liefert nur seine abstrakte Registry (gleiches Schema). Gated nach INC-A..H; **Tools nie
  loeschen — deprecaten + konsolidieren.** — dieselbe Datei, 13.07.2026, OWNER-WORT.

### 3.13 Lagerhaltung: Bestandslog, Batch-Mechanik, Baeume und Cache-Ziele

Sechs der 49 tragen die Lagerhaltung. Sie ist der groesste geschlossene Block der zweiten Welle und
haengt am §62/§46b-Strang; der Owner nennt sie am 23.07. woertlich das **"LAGER-GATE vor Voll-Bau-4"**.

- **U-1** **§62-1 Planer-Universalitaet (User 21.07.2026):** der Planer ist **anspruchslos** und muss auf
  **JEDER** Maschine bauen/laufen; er misst alles, was die XML verlangt und die Maschine physisch kann.
  Physisch nicht existente System-Achsen-Algorithmen (z.B. AVX512-Flags) → **WARNUNG ins Log/CLI (R3/#34),
  KEIN CI-Runner-Vorfilter**. Die (h)/(k)-Host-Lanes (ce **`a3dcfea3`**) sind **INTERIM** fuer die
  28.07.-Kette, als Zielbild supersediert.
  — `project_62_planer_universal_cache_log_claim_compare.md`, 21.07.2026, OWNER-WORT.
- **U-2** **§62-2 Cache-Log-Koordination:** Compile-Log auf **minio.comdare.de**, **LOCKBAR**;
  First-Access bestimmt den ersten Batch (lazy Permutations-Auflistung, die die Maschine uebernimmt =
  **Claim**); Binaries werden ueber den Cache gesynct; **Builds UND Messung ueber Dutzende Maschinen
  parallel**. Koppelt an §36-Pool, K8/MINIO [PV-6]/G1, Compile-Stempel §61-STUFEN. — dieselbe Datei,
  OWNER-WORT.
- **U-3** **§62-3 COMPARE = 4. Modus:** Debug/Messung/Release laufen **je Maschine**; nach Release folgt je
  Maschine COMPARE — vergleicht aus dem **Mess-REPLAY (§58)** die Sicht der messenden Maschine mit allen
  per Cache-Log registrierten Maschinen. **Release der optimalen Binary gilt nur je Maschine**
  (hardware-spezifisch, nur dort reproduzierbar). **F-4-Optionen A/B/C damit vereinbar und PFLICHT**
  (keine exklusive Zuteilung; Claims + volle per-Maschine-Sicht). — dieselbe Datei, OWNER-WORT.
  Siehe **W-24** zur Index-Zeile "CEB 3 Modi".
- **U-4** **§62-4 `experiment_golden.xml`: KEINE geltende Version existiert** (F27 aufgeloest); **per NEUER
  Syntax from scratch entwickeln und stets pflegen.** — dieselbe Datei, OWNER-WORT.
- **U-5** **§62-Nachtrag (21.07.):** Teamfaehigkeit per **SYNC-DATEI** (lokal UND CI, sobald an
  minio.comdare.de angeschlossen); **Dedup ueber ALLE drei Stufen** (Planer/CEB/Tier — nichts doppelt
  bauen); **Batch-Reservierung = VERSPRECHEN** mit zwingender Release-Pflicht + Fortschritts-Testat je
  Build bei Programm-Ende; jede Maschine handelt aus **eigener Sicht** fuer die XML-Ansprueche;
  **"CI ist erst fertig, wenn die XML auf ALLEN vom User gewuenschten Maschinen JE Maschine exakt fuer
  diese Maschine ausgewertet wurde"** (die XML muss die Maschinen-Menge deklarieren koennen → #48).
  — dieselbe Datei, OWNER-WORT.
- **U-6** **NACHTRAG-2 (21.07.), Identitaets-Schluessel und zwei neue Achsen:** ① Interim-GO 320er mit
  Lane-Emission. ② **REIHENFOLGE: erst ALLE XML-Konfigs von Grund auf gegen die KERN-Syntax aufraeumen,
  DANN Code weiterentwickeln** (Gate vor Post-v3-Code, Task #48). ③ tier150-Ausnahme bestaetigt.
  **REPLAY nur bei HARDWARE-IDENTISCHER Maschine** (Perspektiven-Gleichheit); **Binaries per Stempel
  zwischen ALLEN passenden Maschinen geteilt** — **zwei verschiedene Cache-Schluessel**. **Neue statische
  Haupt-System-Achsen:** **RAM** (Frequenz MT/s + CAS-Latenz CL, **wahre Latenz = CL x 2000 / MT-Rate**)
  und **CPU-Typ/exakte Hersteller-Fabrikation** — sie definieren die Hardware-Identitaet (Task #49).
  — dieselbe Datei, OWNER-WORT.
- **U-7** **BATCH-MECHANIK (21.07., praezisiert):** der Batch laeuft **CEB-intern als eigenes Feature**
  (kein Shell-Loop): Runtime-Batch-Bau → **GTest-PRUEFSTAND am Prueffdock** (alle Interface-Funktionen,
  Mess-Tauglichkeits-Gate) → **erst NACH Durchlauf die Messung**. Tooling-Konsistenz: die einkompilierten
  Prueftools der CEB bestimmen die Pflicht-Ausstattung des Tier-Binaries. Die CEB piped Status an den
  **Planer, der die CEB per XML-Anweisung INSTRUMENTIERT** (direkte Steuer-Kette = Kern der
  emit-Vertrags-Kette, Task #54). — dieselbe Datei, OWNER-WORT.
- **U-8** **BATCH-JOB-PRINZIP (21.07.):** bei **130k** Tier-Binaries **NIE Einzel-Jobs** (130k Job-Logs =
  GitLab-Killer): Bau = **EIN gesammelter Batch-Job** (bzw. konstante Chunk-Batches; die CEB traegt die
  Masse intern), Messung = **EIN Batch-Job mit EINEM verfolgbaren Log**. **Job-Anzahl O(konstant), nie
  O(Binaries).** Sub-Lane (#46) = Batch-Job je (Maschine x Perm). — dieselbe Datei, OWNER-WORT.
- **U-9** **NACHTRAG-4 (21.07.) Replay-Befugnis SCHICHTWEISE — je Vertrags-Schicht ein EIGENER
  Replay-Schluessel:** **Planer→CEB:** Mess-Achse **[a,b,c]** bestimmt Replay einer CEB-Binary ·
  **CEB→Tier:** System-Achsen **[d,e,f] ALLEIN** bestimmen Replay der Tier-Binaries · **Messwerte:**
  **[d,e,f] UND [g,h,i] GEMEINSAM + Maschinen-Hardware-Identitaet**. Das #46-Cache-Log fuehrt **alle drei
  Schluessel getrennt**. — dieselbe Datei, OWNER-WORT.
- **U-10** **NACHTRAG-3 (21.07.):** Hardware-Identitaet = **Aequivalenzklasse modulo ungenutzter
  Meta-Meta-Achsen** (GPU/FPGA/NPU zaehlen nicht zur Kern-Identitaet); ist eine Erweiterung per Stempel in
  die Binary einkompiliert, **MUSS die assimilierende Maschine sie unterstuetzen** → **zweistufiger
  Identitaets-Schluessel** im #46-Cache-Log (Kern-Identitaet + bedingte Stempel-Anforderungen). Zielbild:
  optimale Binaries fuer maximal ausgeschoepfte Hardware-Rekombination — **Cache-Line-Verhalten in allen
  permutativen Facetten (Kern-Forschungsziel).** — dieselbe Datei, OWNER-WORT.
- **U-11** **NACHTRAG-5 (22.07.) §62-B, Heimat #46b:** Binary-Cache-Einlagerung ueber ein
  **VERSIONIERTES + GELOCKTES BESTANDSDOKUMENT** (Kern = XML, eigene Header-Versionsnummer fuer Syntax +
  Semantik). CEB-Absprachen darueber mit **GLEICHVERTEILUNGS-PFLICHT** der gemeinsam baubaren Binaries
  (sonst blockt eine Maschine alles). **Batches STETS 4096 Binaries (== GN-2-Guard)**, Reservierung mit
  Zeitstempel. **ETA** aus den ersten 10 erfolgreichen Tier-Compiles (Initial-Reservierung **30 min**, dann
  ersetzt das echte ETA die Zeitreservierung); **ETA + 50 % ohne Update ⇒ Takeover** der offenen, nicht als
  Bestand verzeichneten Arbeit durch andere Maschinen. Der Planer blockt CEB-Compile im Log ohne ETA mit
  30-min-Reservierung je Version. Nach Batch-Ende: Reservierungen + ETA aufheben + "Done". Reservierungen
  decken CEB-compile+pruef UND Planer→CEB-Compile — als **STRATEGY PATTERN fuers Caching**.
  **NEU-INVENTARISIERUNG bei Log-Loeschung oder neuer Planer-/CEB-Version.** — dieselbe Datei, OWNER-WORT.
- **U-12** **NACHTRAG-6 (22.07.) zwei Bestaende + SHA512-Fingerprint:** das Bestandssystem gilt **SEPARAT
  als FACTORY PATTERN** fuer batch-compile-pruef (**Binary-Bestand**) und Messung (**Messwert-Bestand**) —
  **je EIGENES Bestandslog, je EIGENE Stempel-Identifikations-Strategie**. **NEUE Pflicht-Stempel-Zeile auf
  ALLEN Binaries (CEB + Tier):** ein constexpr-Versionierungsinterface bildet **SHA512 ueber die
  String-Arrays der existierenden Stempel-Zeilen** (compile-time, **nie** Laufzeit-Rehashing); die suchende
  CEB nutzt `std::map<SHA512-Key -> Binary-/Messwertpfad>` als Factory-Pattern-Lookup im ccache.
  Materialisierung: `AnatomyVersionLines`-POD-Wachstum im K7b/G1-Umbau (golden-Fenster).
  — dieselbe Datei, OWNER-WORT.
- **U-13** **NACHTRAG-7 (22.07.) Schreib-Lock-Semantik:** das Bestandslog wird **beim SCHREIBVORGANG einer
  Maschine GELOCKT** (auch fuer die ETA-Berechnung); das Schreib-Lock endet **spaetestens mit der ersten
  pro-forma-30-min-Reservierung**. **Lock = kurze Schreib-Exklusivitaet am Dokument; Reservierung =
  fachlicher Batch-Besitz** (Zeitstempel/ETA/Takeover) — eine tote Maschine kann das Dokument nie dauerhaft
  sperren. — dieselbe Datei, OWNER-WORT.
- **U-14** **NACHTRAG-9 (22.07.) ETA-KORREKTUR, ersetzt die 10-Compile-Schaetzung:** ETA-Basis = **maximale
  Dauer eines Mini-Batches der Groesse max-CPU-Thread-Zahl** (eine voll-parallele Sequenz = reale Zeit je
  max-Threads paralleler Builds). **Formel: ETA = Σ t_i / N_threads** (bei Unterauslastung moduliert die
  Formel die Einzel-Zeit nachweislich herunter). **UNTERGRENZE: ETA >= max(t_i)** des voll-parallelen
  Batch-Satzes. Die 30-min-pro-forma-Kalibrierungs-Reservierung bleibt. — dieselbe Datei, OWNER-WORT.
- **U-15** **NACHTRAG-10 (22.07.) K7b-VORZUG = PFLICHT:** der K7b-Stempel-Array-Umbau ist **PFLICHT und
  VORGEZOGEN** — die ccache-Optimierung (§62-B-Bestandssystem) ist durch K7b **GATED** (Binaries muessen
  per Versionierung zuordenbar sein), sonst misst das System nicht rechtzeitig. **Position: nach dem
  vereinten Debug-Smoke, VOR/MIT dem 320er.** Minimal-Umfang: Array-Form (Tier System+Organ-Arrays,
  CEB-Mess-Array = §58-V), G1 Je-Binary-Compile-Stempel (auch Planer/CEB), SHA512-constexpr-Zeile am selben
  POD. W12-Quelldaten (echte X.Y.Z statt `v1`) bleibt separat. — dieselbe Datei, OWNER-WORT.
- **U-16** **NACHTRAG-13 (23.07.) RAM-Sammelpuffer + `avg_size`:** das Bestandslog haelt je Batch-Block
  neben ETA auch **`avg_size`** der erzeugten Binaries. Die CEB streamt Batch-Compiles in einen
  **RAM-Puffer (max 256 MB)** statt je Compile auf Platte (**Einzel-Rueckschreibung laesst den Cache
  ERKALTEN**); Rueckschreibung gebuendelt beim Ausloeser (**256-MB-Schwelle ODER Dutzend-Zaehler**).
  **Ideal:** ein **ZWEITER Writer-Thread** streamt dauerhaft zurueck, bevorzugt **io_uring** (Recherche:
  async buffered writes seit 5.19/6.x, Single-Ring = ein Thread → passt zum Writer-Thread-Design; Fallback
  `write(2)`-Thread; **CT-Wahl, kein Runtime-Switch**). **PLATTFORM-AUFLAGE (User):** io_uring ist
  Linux-only, **ALLE dokumentierten OS muessen unterstuetzt sein** → **DREI CT-Backends hinter EINER
  Writer-Strategy**: io_uring (Linux) / **Windows IoRing** (Win11+, `BuildIoRingWriteFile`) bzw. **IOCP**
  (aeltere Windows inkl. Server 2022) / **portabler write-Thread** (Referenz-Pflicht ueberall,
  8er-Docker-Matrix). **Absturz-Semantik: Puffer-Verlust = max 256 MB Nachbau via Sidecar-Resume.**
  — dieselbe Datei, 23.07.2026, OWNER-WORT.
- **U-17** **NACHTRAG-14 (23.07.) Batch-Planung:** fehlende Binaries werden fuer die Lagerhaltung
  **EINZELN** erkannt (nie als Gesamt-Batch); **Konsolidierung + Batch-Planung ZU BEGINN vor dem ETA,
  ASYNC ueber alle Binaries**; Start sobald das ERSTE Batch steht, Rest-Zusammenstellung im Hintergrund →
  **QUEUE von Batch-Slices (Producer-Consumer)**. Direktive: **alles Erdenkliche in CI + Lagerhaltung
  vorziehen fuer Gesamt-Zeit-Verringerung.** — dieselbe Datei, OWNER-WORT.
- **U-18** **NACHTRAG-12 (23.07.) Batch-Log-Sichtbarkeit:** der Batch-JOB-LOG soll **alle K Builds**
  (K = max verfuegbare CPU-Threads der Lane) den **slice-INNEREN** Fortschritt zeigen ("X von 4096 compiles
  fertig") — **Slice-End-Testate allein reichen dem User beim Zuschauen nicht.** Fix-Reihenfolge: erst nach
  Gesamt-Pipeline-gruen (**laufenden Voll-Bau nie anfassen**). Kadenz-Quelle = `lane_build_parallelism(host)`.
  — dieselbe Datei, OWNER-WORT.
- **U-19** **NACHTRAG-11 (22.07. abends) LAGERHALTUNGS-AMORTISATION + Reihenfolge-Gesetz:** "Lagerhaltung"
  = das Bestandslog-System (N-5..N-9). **Das LAGER der Binaries/Messwerte mit K7b-SHA512-Lookup ist der
  eigentliche DLL-"ccache"** — das ccache-**Tool** deckt **NUR** den Treiber-Bau (`director:958`).
  Amortisation bei **32 x 4096er-Batches**: Wiederaufnahme ohne Totalverlust (Lehre **11519**),
  Gleichverteilung, Takeover. **REIHENFOLGE: alles gruendlich OHNE Umwege in aktueller Reihenfolge**
  (S1-S4 Batch-Emission mit Bestandslog-Saat VOR dem 2^17-Voll-Bau); **"Frist vor Perfektion" explizit
  VERWORFEN.** Volle #46b-Persistenz-Schicht: nach der Abgabe-Kette, aber **PFLICHT vor der
  01.08.-new-golden-Messung.** — dieselbe Datei, OWNER-WORT.
- **U-20** **RESEQUENZIERUNG §66 (23.07. mittags, KERN = Gesetz), Owner woertlich:** "**alles was die
  Lagerhaltung und Stempel angeht als gate fuer voll build**" — LAGER-GATE vor Voll-Bau-4:
  **G1** B/C/D + amd24 → **G2** Stempel-Bruch-Fenster JETZT (K7b-Array, AVX10, per-Binary-Sidecar, W12
  X.Y.Z) → **G3** #46b-Kern P1-P4 + RAM-Puffer → **G4** P-A Push + P-C `measure_out` → **G5** P-B Pruning.
  Supersediert die "vor 01.08."-Parkungen. **12713 gecancelt** (Bestand durch Stempel-Bruch obsolet),
  Waisen beidseitig gesweept. **Tools-Lager (#32) bleibt POST-ABGABE.** Frist-Folge: Voll-Bau ~Do/Fr,
  320er ~So, S8 Mo ENG. — dieselbe Datei, OWNER-WORT.
- **U-21** **NACHTRAG-15 (23.07.) §65 STORAGE-FORECAST + TOOLS-LAGER:** der Matrix-Forecast gehoert
  **IMMER auf die Lager** (Binaries → minio Ebene B **V90 `cache-engine-tier-binaries`**; Messwerte →
  **PR4100 `Cluster_NFS/cache-engine-experiment`**); **lokaler Forecast der Bau-Maschine → gegen NULL**.
  **NEU: auch ALLE TOOLS** (Toolchain/Treiber/Planer/CEB-Werkzeuge) fliessen in die minio-Lagerhaltung ein,
  einheitliches Benennungsschema, **Wiederverwendung statt Neubau je Maschine** — Konsolidierung NACH der
  Abgabe. **IST 23.07.:** Ebene-B-Push in Batch-Jobs **INERT**, kein Pruning, Resume = lokale Sidecars →
  Teil-A-`gn_out`-Persistenz ist **INTERIM (einzige Kopie)**, nach #46b explizit zurueckbauen.
  **Verlustnaht: `measure_out` in Batch-Mess-Jobs weder excluded noch Artefakt → vor 320er fixen.**
  — dieselbe Datei, OWNER-WORT. Siehe **W-28** zum Ziel-NAS.
- **U-22** **ACHSEN-ZERTEILUNG EBENEN-RICHTIG (User-Korrektur 22.07.; `plan_legend.hpp` W10-A, §42/§42.b):**
  **[a,b,c] = Mess-Achsen = CEB-Ebene** (Batch-**KOPF**, nie je Schritt) · **Bau-/Pruef-Schritt (Stufe 2) =
  [d,e,f][g,h,i]** ([g,h,i] = fuehrende Organ-HAUPT-Referenz, reale Permutation = `binary_id`,
  **Unter-Achsen NIE in Bau-Legenden**) · **NUR Mess-Schritt (Stufe 3) = [a,b,c][d,e,f][g,h,i]** ·
  **Tier-Binary = ZWEI STRIKT GETRENNTE LAYER [d,e,f][g,h,i]** (System = Hardware-Layer, Organ =
  Anwendungs-Logik-Layer; **NIE verschmolzen** — Owner-Korrektur 22.07. woertlich: "**man setzt kein
  Betriebssystem mit dem Frontend gleich**"; `[d,e,f,g,h,i]` in §42 ist eine reine Namens-Aufzaehlung).
  **Die Trennung gilt AUCH strikt in der CEB-LAUFZEIT**, die die Tiers kompiliert: System-Freigabe-Schicht
  und Organ-Permutations-Schicht = getrennte Strukturen/Schleifen, nie gemischt. Bestandslog-Schluessel
  getrennt: [a,b,c] → CEB-Replay, [d,e,f] ALLEIN → Tier-Replay, [d,e,f]+[g,h,i]+HW → Messwert.
  — dieselbe Datei, 22.07.2026, OWNER-WORT.
- **U-23** **NACHTRAG 05.08.2026 abend-10 (Owner-A1-KERN, verbatim-Kern) — ZAEHLER-RESUME UEBER PERSISTENT
  GEPLANTE BATCHES:** "**Der Store muss zurueckrollen koennen und ohne grosse Verluste resumen. Das laesst
  sich bei den vorhandenen Batches bei bekannter und orchestrierter Reihenfolge in der CI einfach ueber
  einen Zaehler realisieren, welches Binary kompiliert und dann auch in einem zweiten separaten Durchlauf
  gemessen wurde, sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und persistiert geplant
  sind. Daher ... die Batches persistent vor dem Lauf zu planen.**" ⇒ der Batch-Plan (Reihenfolge + Faecher)
  wird **VOR dem Lauf PERSISTIERT**; Resume = **Zaehler je Phase** (kompiliert / separat gemessen) gegen den
  persistierten Plan. — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **U-24** **Lock-Semantik ABNAHME-1 (26.07.), GELOEST per ultracode-Fund — und ein Lehrstueck ueber
  Agenten-Zahlen.** Owner-Original (22.07., Praezisierung-3, LEDGER:3225 + Transkript wortgenau): "**das
  Bestandslog wird beim Schreibvorgang einer Maschine gelockt, zum Beispiel auch wenn ETA errechnet werden
  soll. Das lock fuer Schreiben eines Bestandslogs, endet mit der ersten pro forma 30 Minuten Reservierung
  spaetestens**" + P4: Normalfall "nur millisekunden", Haupt-Blocker = ETA. ⇒ **TTL = EREIGNIS-gebunden,
  harte Obergrenze 30 MINUTEN (1800 s)** — **keine Sekundenzahl existiert** (dreifach belegt); **LockB-90s
  war ein Agenten-Wert**, kein Owner-Wert. Umsetzung: `ttl_s=1800` (Stale-Bruch-Obergrenze) +
  `section_budget_s=30` Default fuer die Kurz-Zyklus-Wache; der ETA-Aufrufer haelt exklusiv bis das ETA
  feststeht. **Takeover-Ebene separat: ETA x 1,5 (`kTakeoverFactor`).** Jitter-Politik (5 Zyklen 0,5-3 s) =
  Ingenieurs-Detail, **kein KERN**. — `project_bestandslog_abnahmen_baum_heuristik_stempel.md`,
  22./26.07.2026, OWNER-WORT + MESSUNG.
- **U-25** **ABNAHME-2: die Bestandshaltung IST der geplante Speicher-BAUM** (Haupt-/Unter-Achsen der 3
  Typen). Fehlen unter einem Knoten Binaries/Messwerte → **nachbauen**. Jeder Datei-System-Knoten
  persistiert ein **`complete-heuristik.log`** (welche Aeste welche ANZAHL Binaries/Messwerte
  gespeichert/verarbeitet haben). Der Baum hat binaere Grundlage; **staendiges INLINE-Update aller
  Knoten-Logs beim Lesen** → fehlende Blaetter schnell ermittelbar, weil Build + Messung **DEPTH-FIRST**
  laufen. Registrierung multithreading-faehig durch **BRANCHING auf der System-Achse via
  Meta-Meta-Achsen**; Kommunikation ueber die Logs **WIE BEI SPIN-LOCKS**. **Bug-Quelle: Log-TRUNCATE —
  regelmaessig erlaubt, aber NUR im Schluss-Zustand.** Registry damit einfach mit Dateisystem + minio
  machbar. — dieselbe Datei, 26.07.2026, OWNER-WORT.
- **U-26** **ABNAHME-3+4 Stempel/Version:** ALLE Stempel-Hauptachsen werden als String in der Binary mit
  ihrer **VERSION** und dem **HASH ALLER SOURCE-CODE-DATEIEN IM OVERLAY** als String gehasht → zusaetzlicher
  **SHA512-Fingerprint als weitere Stempel-Zeile** (**nie zur Laufzeit berechnet**; Binary eindeutig). Die
  **CEB** macht das fuer Tier-Binaries, der **Planer** (etwas kleiner) fuer die Mess-Achsen der CEBs.
  Implementierung: Pre-Build-Codegen hasht die Overlay-Sources → consteval-String. **Restfragen
  Retention/Re-Open: der Owner braucht mehr Kontext → erneut mit Kontext stellen.** — dieselbe Datei,
  OWNER-WORT.
- **U-27** **ABNAHME-5 CEB-Einlagerung: JA** — CEB-Binaries liegen im Baum in den **KNOTEN DER
  SYSTEM-ACHSEN**, ganz in deren **BLAETTERN am Uebergang zu den Organ-Achsen** (CEBs sind nach
  System-Achsen konstruiert). **ABNAHME-6 Claim-Check/Takeover:** vor 01.08. akzeptiert, **volles GO — aber
  PFLICHT, nicht optional.** — dieselbe Datei, OWNER-WORT.
- **U-28** **A-1/A-2 (bestaetigt + praezisiert):** Aufraeumen/Truncate in der Regel am **BUILD-ENDE**
  ("Lager inventarisieren") **ODER ad hoc bei Log-Groesse > 4 KB** — beides **NUR IM SICHEREN ZUSTAND**
  (eine Maschine haelt das Knoten-Lock und schreibt als einzige). **Jede VERSION ist eine Identitaet, die
  genau EINMAL gebaut werden kann**; neue Version = neue Binary (**Re-Open = Ast-Neu-Inventarisierung, nie
  Record-Mutation**). **Binaries- und Mess-Daten-Lager sind SEPARAT (zwei Realms)**, auch wenn Mess-Daten
  die jeweilige Binary gated vorher erfordern (kausale Kopplung, getrennte Lager). — dieselbe Datei,
  OWNER-WORT.
- **U-29** **STEMPEL-END-FORM, korrigiert (Owner 26.07., nach einer falschen `complex[..]`-Ableitung) —
  DREI-stufige Klammer-Hierarchie:** **Ebene 1** TYP-Klammern `[a,b,c]` / `[d,e,f]` / `[g,h,i]` **STRIKT
  GETRENNT und IMMER aeusserste Struktur** (Tier = zwei getrennte Zeilen; **die Klammer-Anzahl kodiert die
  Ebene: CEB=1, Tier=2, Mess=3**); **Ebene 2** Komplex-Klammer rekursiv **NUR INNERHALB** ihrer Typ-Klammer
  (EIN gemeinsamer Block, indirekte Identitaet; **nie typ-uebergreifend**); **Ebene 3** je Haupt-Achse
  EIGENE Klammer mit `Algo@X.Y.Z` (Array-Form §58, **keine Gesamt-Version CEB/Tier**). **RT-Unter-Achsen
  nie im Binary-Stempel**; die Haupt[Unter]-Voll-Klammer nur in Mess-CSV/xlsx. Autoritativ:
  `docs/sessions/backups/20260726-explore-q3-klammerung/REPORT-hinweis.md`.
  **EBENE-0-PRAEZISIERUNG (Owner 26.07., "ganz wichtig"):** die Binary selbst ist die AEUSSERE Klammer ueber
  ihre Typ-Klammern, **komma-getrennt, nie verschmolzen**: System-Achsen `[d,e,f]` →
  `[[d,e,f],[g,h,i]]Tier-Binary`; CEB = `[[a,b,c]]CEB`; Mess-CSV analog `[[a,b,c],[d,e,f],[g,h,i]]`. Die
  Klammer-Rekursion geht durchgaengig: **Binary-Klammer > Typ-Klammern > (Komplex-Klammern) >
  Haupt-Achsen-Klammern.** — dieselbe Datei, 26.07.2026, OWNER-WORT.
- **U-30** **Bestandslog-Zielbild (User-KERN 26.07.2026):** (1) **Ist = flacher Prototyp** — die
  Bestandslogik kartografiert jeden Build; zu jedem Build werden anschliessend **>= 1 Messungen** angelegt
  (durch dynamische Unter-Achsen je Binary eher **mehrere**); das flache Dokument war "nur ein weiterer
  Zwischenstand". (2) **Zielbild:** volles **DATEI-SYSTEM mit Ordnern/Unter-Ordnern**, dessen
  **ORDNER-KASKADEN den Mess-, System- und Organ-Achsen entsprechen** — wobei stets **EINIGE
  ZUSAMMENGEHOERIGE ACHSEN JE ACHSEN-TYP ZUSAMMENGEFASST** werden, damit die Ordnerstruktur nicht zu tief
  wird. (3) **Performance-Befund anerkannt** (der quadratische `merge_documents`-Scan waere im Voll-Bau zu
  langsam) — Fix ja, aber als **Schritt Richtung Zielbild**, nicht als Endzustand des flachen Modells.
  (4) **DUAL-CCACHE (konfigurierbar):** **minio.comdare.de UND NAS (PR4100 Cluster_NFS) sind ZWEI
  einstellbare ccache-Ziele. Default: nur minio fuer Binaries; NAS fuer Mess-CSV und Ergebnisse. Beide auf
  das jeweilige GEGENTEIL einstellbar** (Binaries→NAS bzw. Mess-Ergebnisse→minio moeglich).
  — `project_bestandslog_zielbild_ordner_kaskaden_dual_ccache.md`, 26.07.2026, OWNER-WORT.
- **U-31** **Die ZWEI Lager-Baeume (Owner-KERN 26.07.2026; Details `super docs/sessions/
  20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md` §4/§6):**
  (1) **CSV/xlsx-Namens-Doktrin:** dynamische Unter-Achsen-Variablen (aus der CoR-Filterkette) IMMER
  **direkt im Dateinamen**; Name = **NUR Datum + Uhrzeit + Unter-Achsen-Variablen**; Lage =
  Haupt-Achsen-Ordner-Kaskade; Haupt-Achsen-Einstellungen zusaetzlich als **METADATEN in der Datei**
  (vollstaendige Selbst-Identifizierbarkeit).
  (2) **xlsx = Default**, CSV einstellbar + Fallback; CSV je Sheet einzeln im **FACTORY PATTERN**; xlsx =
  EINE Datei, **EIN Sheet je gewaehlter Unter-Achsen-Permutation + INFO-Sheet** (Sysinfo der Maschine +
  Haupt-Achsen).
  (3) **Zwei Realm-Baeume:** Messdaten-Wurzel = **Mess-Kombinatorik (Mess-Tooling x load_framework)** →
  **EIN Ordner-Level = GESAMTE System-Haupt-Rekombination** als (laenger werdender) Name, **Meta-Metas
  hinten angehaengt** (hinter `load_framework` on/off) → **Organ-Gruppen-Ordner 01..05** → Haupt-Blatt →
  **3 Unter-Ebenen (Mess-Unter → System-Unter → Organ-Unter)** → xlsx. **Binaries-Lager: System-Achse als
  Wurzel; Mess-Typ als LETZTER/tiefster Haupt-Achsen-Typ hinter System + Organ.**
  (5) Design fix; Vollausbau der Baum-/xlsx-Writer im #46b-/vor-01.08.-Paket (**Voll-Bau-4 wartet NICHT
  darauf, wohl aber auf STRUKT-R**). — `project_lager_baeume_xlsx_doktrin.md`, 26.07.2026, OWNER-WORT.
- **U-32** **Die Format-Lineage der Rueckschreibung, drei Stufen in EINER Datei:**
  (1) **26.07.:** xlsx = Default, **CSV einstellbar + Fallback**, CSV je Sheet im Factory Pattern.
  (2) **NACHTRAG 05.08.2026 (Owner-Praezisierung, verbatim-Kern):** "**es soll doch entweder CSV xor xlsx
  schreiben und xlsx ist default? Alles andere ist unnoetiger overhead. Das ist ein strategy pattern, keine
  chain of responsabilities**" — **GENAU EINE aktive Format-Strategie je Lauf** (XML-gesteuert),
  Doppel-Schreibung = **Regression**; keine CoR-/Weiterreichungs-Kette. Der IST-Stand schrieb CSV.
  (3) **UEBERHOLT AM 09.08.2026 — das XOR gilt nicht mehr.** Owner: "*xlsx ist der Standard und CSV ist
  waehlbar, und ich lege jetzt fest, dass **auch beide zusammen waehlbar** sein koennen. **Nicht nur
  entweder oder.***" Der Rest des Nachtrags (Strategy Pattern, xlsx = Default, keine CoR-Kette) bleibt
  **unveraendert gueltig** — nur die **Ausschliesslichkeit** faellt.
  — dieselbe Datei, 26.07./05.08./09.08.2026, OWNER-WORT. **Die `description:` dieser Datei traegt noch die
  Fassung (1) — siehe Abschnitt 5.5.**
- **U-33** **Inkrementeller CEB-/Tier-Binary-Cache (User 18.07.2026, EINSCHUB, Voraussetzung fuer das neue
  golden N = 2^17):** die CI erkennt, ob eine **Organ-Achse sich bzgl. eines Achsen-Algorithmus geaendert
  hat** (Algorithmus-Versionierung), sodass **nur die betroffenen Binaries im Baum neu gebaut** werden.
  **Jedes Binary traegt je Organ-Achse ein Listing: welcher Algorithmus + welche Algorithmus-Version**
  einkompiliert wurde. Alle Binaries mit geaendertem Algorithmus werden neu gebaut, der Rest bleibt.
  **Eine CEB-Aenderung (betrifft ALLE Tier-Binaries) → vollstaendige Rekompilation.** Begruendung:
  **131.072** Tier-Binaries, alle bei jeder Aenderung neu = unmoeglich (**~409x golden-320**, mehrtaegig).
  **User-Hinweis woertlich:** "Der Experiment-Baum hat schon **lazy Materialisierung** und die CEB ist
  **genau dafuer gebaut**" — vorhandene Infra (`StaticBinaryView` on-demand + `dll_is_current`/Resume +
  `.version`-Sidecar) **NUTZEN, nicht neu erfinden**. Design (a)-(e): per-Binary per-Organ-Achse
  Algorithmus+Version-Manifest · Change-Detection (Content-Hash der Algorithmus-Quelle je Achse ODER
  explizites `version()`-constexpr je Strategie-Klasse) · Rebuild-Selector (`dll_is_current`-Erweiterung) ·
  CEB-Full-Trigger · CI-Integration. **`binary_id` bleibt komposition-abgeleitet; die Algo-Version ist
  Provenienz (Sidecar), NIE `binary_id`.** Owner-Wort: "**zieh es durch, machbar**".
  — `feedback_incremental_tier_binary_caching.md`, 18.07.2026, OWNER-WORT.
- **U-34** **STORAGE-EBENE (User-FINAL 18.07.2026, nach zwei Zwischen-Korrekturen — DIES gilt):**
  **CEB-Compiles + Tier-Binary-Compiles → `minio.comdare.de`** (Object-Store, entkoppelt vom CI-Cache) ·
  **Messergebnisse (`measurement/<datiert>/`-CSV) → NFS auf den prod-HDDs (6TB longhorn)**, damit sie via
  **DNS-`.1`-SNI per HA-Proxy von VLAN 10 aus durchsuchbar** sind · **Standard-Compiles (Experiment-Planer,
  ce-Library, CI-Test-Binaries) + alle CI-Daten → GitLab-Cache auf cluster dev** (bestehend).
  **Zwischenzeitlich verworfen: "alles nach NFS-RBMM"** — das galt nur kurz. **CE-Seite (Code):**
  konfigurierbare Ziele — MinIO-Endpoint fuer CEB-/Tier-Binary-Cache-Push/Pull (`build_orchestrator`-Naht)
  + NFS-Cache-Root-Pfad fuer den Messergebnis-Rueckschrieb (getrennt). **Die INFRA** (minio-Bucket/Zugang,
  NFS-Export der prod-longhorn-HDDs, HA-Proxy-`.1`-SNI-Route von VLAN 10, Credentials) = **HANDOVER**
  (Cluster read-only). — dieselbe Datei, 18.07.2026, OWNER-WORT. **Siehe W-28 — die NAS-Angabe kollidiert
  mit U-21/U-30.**

### 3.14 Die Achsen-Neuordnung vom 26.07.2026 — Sortierung, Komplex-Achsen, Dual-Natur

Der groesste Einzel-Entscheid der zweiten Welle. Autoritativ persistiert in `super
docs/sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md`; alles hier ist
OWNER-WORT aus `project_achsen_neuordnung_bindende_sortierung_regressionen.md` (26.07.2026), sofern nicht
anders gekennzeichnet.

- **V-1** **Bindende Sortierung aller Achsen-Typen:** **Mess-Tooling (Wurzel; `measurement_category` =
  Unter) → `target_isa` → `operating_system` (NEU, Unter: `os_version`/`kernel`/`build`/`update_zustand`) →
  `extension_hardware` → Organ T00-T16.** **Doku-Verstoesse = Regressionen.**
- **V-2** **R-A..R-E:** OS-Achse fehlt · **`scheduling` = Unter-Achse von `target_isa`** ·
  **`load_framework` = META-META** (Messung optional → 5. Modus **CUSTOM_COMPILE** umgeht
  Debug/Messung/Release/COMPARE; CEB-Ende, ERSTE Meta-Meta) · **`compiler` ist KEINE Haupt-Achse, sondern
  eine Unter-Achsen-GRUPPE** (`compiler` + `opt_level` + `atomic128`, **untrennbar**) der **Komplex-
  Haupt-Achse** = `target_isa` x `extension_hardware` x Meta-Metas (ohne `load_framework`) nach
  **Command-Pattern** (3 Haupt-Achsen verhalten sich wie EINE) · **Meta-Metas auf dem variadischen Array
  (ohne `std::variant`) = FESTE Identitaets-Bestandteile.**
  **STAND: die `load_framework`-Zeile ist am selben Tag zweimal revidiert worden — siehe V-15.**
  **STAND: CUSTOM_COMPILE ist KEIN 5. Modus — siehe V-8/Q-4-Korrektur und W-24.**
- **V-3** **Aufwaerts-Identitaet:** Teil-Identitaeten mit kleinerer Hardware-Verwendung bleiben gueltig
  (GPU rein: alt laeuft weiter; GPU raus: GPU-Programme nicht mehr). **Basis = CPU-only.** **ALLE
  Beschleuniger (SIMD/GPU/FPGA/NPU, on-CPU wie extern) in DERSELBEN strategischen Haupt-Achse;
  `extension_hardware` = Command-Pattern-HUB**, die Identitaet ist exakt die Meta-Meta-Konfiguration.
- **V-4** **Dual-Natur:** `load_framework` + Mess-Tooling = **RT-Unterachse auf dem Planer, CT-Haupt auf
  der CEB.**
- **V-5** **Organ-Gruppen (englisch, je Gruppe EIN Rekombinations-Ordner):**
  **01_read_path** {`search_algo`, `cache_traversal`} · **02_layout** {`node_type`, `memory_layout`,
  `path_compression`, `filter`, `serialization`} · **03_placement** {`mapping`, `allocator`,
  `value_handle`, `index_organization`, `migration_policy`} · **04_execution** {`concurrency`, `prefetch`}
  · **05_write_path_io** {`queuing_q1`, `queuing_q2`, `io_dispatch`, `persistence_target`}.
  **Basis: Idreos/RUM/EM-Modell** (owner-beauftragte Recherche).
- **V-6** **`persistence_target` = NEUE 18. Organ-Haupt-Achse (GO):** `memory_only` (Default,
  `golden_wired`) + `disk_writeback`. **`binary_id` 17 → 18 = bewusster golden-/ABI-Bruch im offenen
  §66-G2-Fenster, Einbau VOR Voll-Bau-4.** **Praezisierung derselben Runde (loest Q-1-Nuance):**
  Disk-Zurueckschreiben ist eine **ERWEITERUNG von Suchalgorithmen** — die meisten arbeiten im RAM, nicht
  auf Disk ⇒ **per XML abschaltbarer BAUSTEIN** (`disk_writeback`); "einige Paper erfordern dieses Element"
  ⇒ **die Achse bleibt (Durchreich-Doktrin), der Baustein ist XML-abschaltbar (Pflicht)**. Der ORG-18-Bau
  ist konform. **Das ist die Herleitung der 18 — siehe W-03.**
- **V-7** **Einschub-Paket STRUKT-R vor dem Trigger** (mit W-13, dessen Suffix-Ordnung der neuen Sortierung
  folgt). Owner woertlich: "**Wir schaffen es und wenn nicht ist auch nicht schlimm, hauptsache so
  ordentlich wie moeglich.**"
- **V-8** **Q-ANTWORTEN (26.07. spaet, revidieren das Obige teilweise):**
  **Q-0: V2 Byte-Schnitt VOLLES GO** ("perfekt saubere Version, dauert so lange es dauert"); ORG-18 +
  Suffix (V3-Menge) fest drin; "Maschinen verkraften den Voll-Bau besser als frueher".
  **Q-1 REVIDIERT `disk_writeback`: enabled=false wie empfohlen** (kein echter Disk-Pfad = **Messwert-
  Luege**). **NEU-AUFLAGE: Achsen-Deaktivierung PER XML muss unterstuetzt sein** (nicht nur Code-option).
  **Raum bleibt 2^17**, bis der echte Schreibpfad existiert.
  **Q-2 KORREKTUR: `operating_system` ist KOMPLEX-HAUPT-ACHSE** (CT-statisch), seine **4 Werte**
  (`os_version`/`kernel`/`build`/`update_zustand`) sind **Unter-Achsen = laufzeit-dynamisch**.
  **NEUES LAYER-MODELL: Haupt-Achsen haben Layer/Rekursivitaet nach Command-Pattern; auch META-META-ACHSEN
  SIND HAUPT-ACHSEN (CT!), die selbst Unter-Achsen tragen.** Owner: "hier stimmt das Verstaendnis ueber die
  letzte Woche gar nicht" → ultracode-Erhebung beauftragt.
  **Q-3: S2 angenommen**; die Klammerung/3-Achsen-Typen-Definition ist **SEIT MONTAG (20.07.) geplant** →
  Explore-Suche nach der Definitions-Stelle beauftragt.
  **Q-4 KORREKTUR: CUSTOM_COMPILE ist KEIN 5. Modus, sondern CLI-FEATURE**, das alle 4 Modi ueberschreibt
  und dem Anwender/Kunden die gewuenschte Binary liefert. **Es bleiben 4 Modi** (Debug/Messung/Release/
  COMPARE — COMPARE als 4. Registry-Eintrag mitbauen). Der R-C-Wortlaut ist entsprechend revidiert.
  **Q-5/6/7/8/9/10/10b/11/14: alle Empfehlungen angenommen** (Sentinel Custom, `xs:all`,
  `fixed_enum_tuple`, nur `SearchAlgorithm`, Reader **160 UND 169**, T-Anhang hinter `queuing_q2`,
  **goldenK=1**, Scharfschaltung nach Trigger, **Modus nie im Stempel**).
  **Q-13 KORREKTUR: `telemetry` ist MESS-TOOLING-UNTERACHSE des PLANERS** (nicht System-Sonderfall
  belassen) — wandert in die Mess-Achsen-Welt.
- **V-9** **LAYER-MODELL Q-A..Q-F (Owner 26.07., KERN; Voll-Doku `super docs/sessions/
  20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md`):**
  **Q-A STEMPEL:** Klammerung = Zuordnung HAUPT-Achsen zu den 3 Typen; die **Unter→Haupt-Klammer steht
  NICHT in der Binary, nur im xlsx-Meta**. Stempel je Achsen-Typ → je Haupt-Achse (1 Algo + eindeutige
  Version). **Die Binary hat KEINE eigene Version (CEB/Tier); nur der PLANER hat eine.** Identitaet =
  Haupt-Achsen-Rekombination + Algo-Versionen. **Komplex-Achse = rekursive Klammer um gewrappte
  Haupt-Achsen-Klammern; nur indirekte Identitaet (Command-Pattern); EIN gemeinsamer komplexer Stempel.**
  **Q-B:** OS = **4. Glied der EINEN Komplex-Achse** (`target_isa` x `os` x `external_utils` x MetaMetas).
  **`ext_hw` → `external_utils`** (Plug + Manager der Meta-Metas: externe HW, AVX, UND **Mess-Framework als
  ERSTER Einbaukandidat**).
  **Q-C:** OS-Unter-Achsen erstmal **STATISCH** (RT vorbereitet, Kernel-Wechsel noch nicht).
  **Spalten-Sparregel: nie-aendernde Spalte weglassen → Metadaten-Eintrag.**
  **Q-D:** Rekursion **formal unbegrenzt** (GPU-Cluster@PCIe = Meta-Meta, das selbst Manager ist).
  **Q-E:** Komplexbildung auf oberster Ebene, dann rekursiv je Layer.
  **Q-F:** Konzept generell gueltig, **ueberall erweiterbar** (auch Mess-/Organ-Realm).
  **DIREKTIVE: Regressions-Behebung R-A..R-F + STRUKT-R ist Manager-(Fable-)Aufgabe.**
- **V-10** **OWNER-ENTSCHEIDE 26.07. ~16:40 (nach Wahrheits-Anker-Abgleich; KERN = Gesetz):**
  **F1:** **`external_utils` = KOPF fuer ALLE Meta-Meta-Achsen** (Schreibweise final; "extermal" war ein
  Tippfehler). **F2:** Layer-Modell der 2 oberen Schichten = **Comdare-Matrix-Struktur (Produktfassaden vs
  Modules)** — per ultracode aus der Matrix-Doku zu planen. **F3:** **`std::variant` NUR in der CEB
  geduldet, in ALLEN Tier-Binary-Typen VERBOTEN** (siehe **W-23**). **F5 (Owner-Nummerierung "Frage 4",
  Lesart golden):** **golden SOFORT vor dem Trigger brechen** — "die Struktur der Achsen hatte nachweisbar
  regressionen, die zu beheben sind" ⇒ NUMA/locking + `page_type` kommen VOR Voll-Bau-4 (STRUKT-R-Scope).
  **ACHTUNG: die fruehere E-08-Lesart "NUMA als 7. System-HAUPT-Achse" ist UEBERHOLT** (siehe V-12).
  **F6:** **Mess-Achsen sind in den PLANER getrennt; System-Achsen steuern NUR NOCH Kompilation, System und
  Scheduling (Basics einer Binary).** Strikt an die neu sortierte Ordnung + Verantwortlichkeiten halten —
  "**alles andere ist veraltet**" (die nr703-Steuer-Relation ist obsolet).
- **V-11** **TEST-SKIP (loest E-26/W6 endgueltig, 26.07. ~17:1x):** der **Voll-Build testet IMMER hart die
  GANZE Pipeline, AUSSER Binaries und Messungen, die bereits VORHANDEN und GRUEN-GETESTET eingepflegt
  wurden**; alle uebrigen Module werden sonst immer gruen getestet. **MECHANIK:** die CEB testet gebaute
  Binaries **am PRUEF-DOCK VOR der Messung**; die **Lagerhaltung notiert die Funktionalitaet ALLER Tests je
  gebauter Binary als LOG neben dem Ziel-Speicherort der Binary**. **Positives Build-Log ⇒ Test-Skip fuer
  genau diese Binary.** Das ist **Teil der LAGERHALTUNG, kein Job-Skip**.
- **V-12** **NUMA/`page_type` — die BINDENDE Fassung (Owner 26.07. spaet, KERN), verbatim:** "**NUMA und
  page_type muessen in der CEB fuer eine Architektur FREIGEGEBEN werden, BEVOR sie tatsaechlich als
  Tier-Binary gebaut werden, daher sind NUMA und page_type eigentlich doch UNTER-Achsen unter der ISA zur
  LAUFZEIT DER CEB und COMPILE-TIME-STATISCHE HAUPT-ACHSEN bei den TIER-BINARIES, es gibt MEHRERE solcher
  zwei-geteilter Faelle.**" ⇒ sie sind **NICHT** flache System-Haupt-Achsen der CEB-Stufe, sondern der
  stufen-relative Zwei-Stufen-Fall (§24-C/R1: die dynamische Einstellung der Vorstufe IST der CT-Draht der
  Folgestufe; §37-Freigabe-Prinzip: **System gibt frei, Organ setzt durch**).
  **Die initiale Lesart derselben Runde — hier nur historisch:** Owner sagte zunaechst "technisch
  HAUPT-Achse UNTER den System-Achsen, sofern auf der ISA einstellbar", mit der **Zwei-Adressen-Regel**
  (System-Achsen = **BIBLIOTHEK** / geben frei, Organ-Achsen = **INITIALISIERUNG** / nutzen ueber
  Interfaces). **Die Zwei-Adressen-Regel BLEIBT gueltig**, aber "Haupt-Achse unter den System-Achsen" ist
  **nicht** die richtige Stufen-Einordnung.
  **DUAL-NATUR-REGISTER (Pflicht-Kategorie bei jeder Achsen-Einordnung — "welche Stufe?"):**

  | Achse | RT-Unter-Achse AN | CT-Haupt-Achse AN |
  |---|---|---|
  | Mess-Tooling | Planer | CEB |
  | `load_framework` | Planer | CEB (letztes Glied, ERSTE Meta-Meta) — **superseded, siehe V-15** |
  | `compiler`/`opt_level`/`atomic128` | CEB (zur Laufzeit austauschbares Programm) | Tier (einkompiliert) |
  | **NUMA/locking** | **CEB, unter der ISA** | **Tier** |
  | **`page_type`** | **CEB, unter der ISA** | **Tier** |
  | SIMD/AVX (Meta-Metas) | CEB (`external_utils`-Hub gibt frei) | Tier |
  | `telemetry` | Planer (Mess-Tooling-Unterachse) | **zugleich Haupt-System-Achse** — siehe V-15 |

  **FOLGE FUER DEN GOLDEN-SCHNITT (vor Lane A zu verifizieren):** CT-Haupt AM TIER heisst **einkompiliert +
  gestempelt** (System-Stempel-Array `[d,e,f]`) — **NICHT automatisch `binary_id`-Segment** (`binary_id`
  ist Organ-only, §54-T3; System-Achsen leben im `build_version`-Sidecar). Landen NUMA/`page_type` als
  System-Typ-Achsen am Tier, bleiben die **golden-Kardinalitaet 2^17** und der **CRC
  `0x56F1B721C72DC10E` UNBERUEHRT** (kein ABI-8-Fenster fuer diese zwei). Zu bauen sind: der Freigabe-Pfad
  (CEB-RT unter ISA), der Tier-CT-Draht und das Organ-Interface.
- **V-13** **opt-Stufen und AVX512 im Voll-Bau** — siehe **H-17** (dort mit allen Zahlen).
- **V-14** **Lane C (loest Punkt E): FREIGABE** (`external_utils`-HUB/Rename/R-E/R-F scharf).
  **golden (loest Punkt F / F5-Lesart, bestaetigt), Owner woertlich:** "**Golden Bruch, wir bauen es nach
  Plan, das alte golden ist verweest und ueberholt, new golden ist angesagt**" — new-golden-Suche per
  ultracode beauftragt. **NUMA/`page_type` + Achsen-Umbau kommen VOR Voll-Bau-4, EIN koordinierter
  Neuanker.**
- **V-15** **OD-RUNDE 26.07. ABENDS (~18:40, NEUESTE Owner-Linie; Voll-Doku `super docs/sessions/
  20260726-SESSION-od-antworten-load-framework-mess-realm-target-isa-komplex.md`):**
  **R-G NEUE REGRESSION — `load_framework` = MESS-ACHSEN-TYP**, Owner woertlich: "eher eine Achse fuer
  Planer und delegiert die loads nach dem Generiern an das CEB interface, welches gesagt bekommt, welche
  binary Rekombination es gegen welche Lasten messen soll ... **load_framework wird rein den
  Mess-Achsen-Typen als weitere META-META-HAUPTACHSE zugeordnet. Wir verschlanken damit die System-Achsen
  auf ihre thematisch passenden Funktionen.**" ⇒ **SUPERSEDIERT** "erste Meta-Meta unter dem
  `external_utils`-Hub" (V-2) **und** die Dual-Natur-Zeile in V-12. Der Bauplan-v3-Teil "RAUS aus
  `kSystemAxisOrder`, `kCount` 5→3" bleibt; **nur das Umzugs-ZIEL = Mess-Realm.** Der
  `external_utils`-Hub traegt **NUR System-Meta-Metas** (SIMD/AVX, externe HW).
  **`target_isa` = KOMPLEX-ACHSE IN SICH (OD-2):** feste Rekombination aus **RAM-Frequenz + CAS +
  CPU-Fabrikation** als statische Komplex-Haupt-System-Achse, **rekursiv gewrappt** von der grossen
  Komplex-Achse (`target_isa` x `operating_system` x `external_utils`); die vereinbarten
  Unter-System-Achsen (`scheduling`, `numa_node`, `page`) haengen am **`target_isa`-Komplex-Wrapper** —
  **nicht** Identitaets-Menge ausserhalb der Taxonomie, **nicht** einfache Unter-Achsen.
  **`telemetry` ZWEIGETEILT (praezisiert Q-13):** weiterhin RT-Unter-Achse im Mess-Tooling **UND**
  Haupt-System-Achse — "weil etwa **pmc** zum Messen eingebaut sein muss und andere `IObservableTier`
  ebenfalls ZWEIGETEILT sind"; das Dual-Natur-Register erhaelt diese Zeile.
  **OD-1 RATIFIZIERT golden-neutral** (`binary_id` + Stempel-Prinzip bleiben; nur die Achsen je Typ aendern
  sich; das Tier fuehrt weiter System-Achsen + Organ-Achsen + je-Achse-Algo-Versionen + CT-SHA512) — "Die
  neue Lesart ... erfordert umfassendes refactoring nach den Plaenen."
  **OD-4/5/6/8/9/10 = VOLLES GO** (C-3b-Wortlaut; Dual-Natur-Stufen-Lesart; Lane-A/C-byte-neutral-Bau;
  SessKons; Bauplan-v3 deckt Alt-"V3 direkt mit rein" ab; F5-Lesart). **Bauplan-Gates
  O-1r/O-2/O-3/O-4/O-5/O-6/O-9: die Entscheide EXISTIEREN bereits in den Quellen — per Explore-Agenten
  finden + gegenlesen, NICHT neu fragen.**
  **OD-7 NEUE Runner-Zahlen** — siehe **A-7**.
- **V-16** **R-F NEUE REGRESSION (26.07., Bestandslog-Abnahmen):** **AVX und SIMD gehoeren zu den
  META-META-Achsen** (nicht Unter-Achse von `extension_hardware`) — konsistent mit R-E
  (`ext_hw` = Hub ALLER Beschleuniger).
  — `project_bestandslog_abnahmen_baum_heuristik_stempel.md`, 26.07.2026, OWNER-WORT.

### 3.15 Firmen-Matrix: Baselines, Umbrellas, Module, Sprachen, Vendoring

Elf der 49 tragen die Organisations-Doktrin des Firmeninventars (~250 Projekte). Sie ist die Klammer, in
der die Diplomarbeit als **Research-Projekt** haengt.

- **X-1** **Das Baseline-System ist IN STEIN GEMEISSELT (User 02.07.2026)** — die Struktur der
  Module-Baselines (`baseline_0-foundation` … `baseline_N`) darf **niemals** gebrochen werden; sie
  wiederholt sich systematisch und haargleich in ALLEN Modulen (`Modules/comdare-*-all`) und Produkten
  (`Products/*`). **Vier Regeln:** (1) eine Baseline darf **ausschliesslich Interfaces NIEDERWERTIGERER**
  Baselines referenzieren und linken; (2) **Regelfall: nur die naechst-kleinere** (n → n-1), **keine
  Spruenge**; (3) **Produkte referenzieren ausschliesslich Baselines IN PRODUKTEN** — nie direkt generische
  Modules; formal ist immer ein **Erben** vom generischen Modules-Stand in ein projekt-spezifisches
  Produkt-Modul noetig (Spezialisierung); (4) **Verstoesse werden sofort beim Linken sichtbar — das ist
  gewollt und Teil des Designs.** Begruendung: Modules = **so generisch wie moeglich**, Produkte = **so
  spezifisch wie noetig** auf mindestens einer generischen Modules-Basis; Link-Sichtbarkeit ersetzt
  aufwendige Architektur-Reviews. **Verstoesse = Blocker, nie Workaround.**
  **⚠ Begriffsklaerung "Baseline" (03.07.2026), DOPPELT belegt:** (A) **Domaenen-/Produkt-Baseline** =
  DIESE Regel (`comdare-baseline_0..6`, Fachfundament, **WAS** das Produkt ist), vorhanden in comdare-db +
  den **15 Modules-Umbrellas**; (B) **Build-/Toolchain-Baseline** = `cd-buildsystem-core` **3.4.15**
  (**WIE** gebaut wird, oekosystemweit) sowie das davon getrennte, eigene **Layer0-4-Baseline** des
  Produkts `cd-buildsystem-construct`. **"In Stein gemeisselt" bezieht sich NUR auf (A).** Steuerrater A/B
  haben einen eigenen, separaten Domaenen-Baum (teilen (A) NICHT) — Konformitaet offen (R-OEKO-1).
  Details: `Products/comdare-db/docs/architecture/2026-07-03-COMDARE-OEKOSYSTEM-UND-NACHBARSYSTEME.md`.
  — `feedback_baseline_system_in_stein_gemeisselt_layering.md`, 02./03.07.2026, OWNER-WORT.
  **Zweiter Beleg fuer v3.4.15 neben W-14.**
- **X-2** **Die Matrix ist DREIdimensional (User 07.07.2026):** **Familien x Baseline-Stufen x MODULE**
  (Module = die Zellen-Repos IN einer Stufe). **Generische Module sind metaprogrammierungs-offen und NUR
  Source-Code**; **jedes Product/Research, das Module nutzt, organisiert eine EIGENE Matrix** (Familien x
  Stufen x Module) aus separaten Repos, die die Template-Module **als echte Interface-Binaries
  instanziieren**. **Research = Products mit gelockerten Eigenschaften.** **Taxonomie-Anker:**
  comdare-cache-engine = **Framework-Modul**, Diplomarbeit = **dessen Product/Aussen-Interface**; prt-art =
  **Modul**; Overleaf/Thesis = **Product OHNE Baseline-Struktur** (kein Programmiersprachen-Projekt).
  **Das Wort "Migration" meint FUNKTIONS-Zerteilung des Monolithen in diese Struktur, NIE Umbau der
  bestehenden Matrix.** — `feedback_standardprozess_research_zu_product_matrix_3d.md`, 07.07.2026,
  OWNER-WORT.
- **X-3** **Der Standardprozess Research→Product ist ein Dokument:**
  `Research/probst-diplomarbeit-cache-engine/docs/STANDARDPROZESS-RESEARCH-ZU-PRODUCT.md` — **9 Schritte:**
  Kartierung → Reuse → additive Erweiterung → minimale Neuanlagen → Framework-Modul-Schnitt in
  Baseline-Struktur → Product-Instanziierungs-Matrix → GitLab-Gruppen exakt nach Ordnerstruktur (vorher
  Diff, origin-URLs = Ist) → CI+CMake parallel bis das Buildsystem fertig ist → Beweis-Disziplin.
  Eingebettete Submodule/Vendor-Klone sind von der Spiegel-Regel **ausgenommen**. — dieselbe Datei,
  OWNER-WORT.
- **X-4** **Umbrella-SOLL (User 07.07.2026, bindend):** `Projekte/Modules/<familie>-all/` enthaelt `docs` +
  `sessions` + `comdare_baseline_N`-Stufen + `module_test_instantiation` (Umbrella-Testsuite aller Module)
  + **optional** Sprach-Wrapper-Ordner (java/go/python/rust) — **Pflicht:** Baseline-Module; **oder
  optional** server-/client-Wrapper-Baselines bzw. server+client-Sub-Baselines (Beispiel licensing:
  `client/` + `server/`). **Products = exakt GESPIEGELTE Struktur**, sofern Module instanziiert werden.
  **Products-Praezisierung (2. Runde):** ein Product ist das **Aequivalent eines Modules-Umbrellas
  (`*-all`)** — dieselben Regeln. **Benennung der Instanziierungs-Module:** `comdare-db-fingerprints`, wenn
  das Product comdare-db das Modul `comdare-fingerprints` verwendet (**Praefix = Product-Name**); das
  Instanziierungs-Modul wird in der **aus Modules KOPIERTEN Baseline im Product** angelegt. **Products
  duerfen multiple Baselines derselben Layer-Stufe N aus VERSCHIEDENEN Modul-Umbrellas FLACH im eigenen
  Umbrella anordnen** (z.B. `baseline_0` aus foundation neben `baseline_0` aus encryption).
  **TRACKING-REGEL:** jeder Umbrella trackt **ALLES AUSSER die Baseline-Zellen-INHALTE** — die
  Baseline-Module sind **eigenstaendige, selbst git-getrackte Repos** und werden **durch CMake als
  Hot-Dependency frisch gecloned** (spaeter Buildsystem-Automation). **Zellen-Inhalte im Umbrella-Index
  (Voll-Inhalt ODER Gitlink) = Struktur-Fehler.** **GitLab-Gruppen:** der Ist-Zustand ueber die
  GitLab-Gruppen hinweg ist fuer **jedes** Umbrella **strukturell falsch** angelegt; **die lokale
  Ordnerstruktur ist das SOLL** (beantwortet die offene B6-Spiegel-Konventions-Rueckfrage).
  — `feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen.md`, 07./08.07.2026, OWNER-WORT.
- **X-5** **Audit-Befund 07.07.2026 (read-only, alle 21 lokalen Umbrellas):** **8 Umbrellas mit
  committeten Zellen-VOLL-Inhalten (21 Zellen)** — encryption-all 2 (cert-pinning/forward-secrecy) ·
  external-all 1 (Tests) · **licensing-all 9** (`comdare-db-client-*`) · network-protocols-all 1
  (session-guard) · organization-all 1 (comdare-tax) · wrappers-all 5 (csharp/java/nodejs/python/
  rust-wrapper; go-wrapper korrekt eigenstaendig) · steuerrater-b 1 (core) · comdare-web 1 (core).
  **Gitlinks verbreitet:** network-protocols **59**, comdare-db **34**, encryption **14**, licensing **4**,
  external/foundation/storage/wrappers je **1**. **9 Umbrellas ohne `.gitignore`** (alle 4 Products +
  encryption/external/licensing/network-protocols). **Sauber:** archiving, binary-analytics, client,
  config, core, filestorage, treecore, measurement. **Bereinigung VERLUSTFREI:** Voll-Inhalt-Zellen ZUERST
  als eigenstaendige Repos sichern (**Remote-Anlage je Zelle mit User-GO**), DANN `git rm --cached` +
  ignore; Gitlinks ebenso entfernen; **History bleibt (nichts umschreiben)**. comdare-db/
  cd-buildsystem-Umbrellas = fremde System-Hoheit → Befund uebergeben, nicht selbst committen. Vorbild:
  measurement-all (ignore `/comdare-*/`, EXISTS-Slots, keine Zellen im Index). — dieselbe Datei,
  07.07.2026, MESSUNG. Gehoert zur Familie von **W-18**.
- **X-6** **Generische CLIENT- UND SERVER-Module sind first-class (User 08.07.2026, Korrektur einer
  Agenten-Fehlannahme):** die Matrix kennt **generische client- UND server-Module**. `licensing-all` ist
  das kanonische Beispiel: `client/` + `server/`-Buildsystem-Zweige + Baseline-Stack, dessen
  `comdare-db-client-{ftp, hadoop, iscsi, kafka, nfs, sftp, smb, sql, webdav}` die README **explizit** als
  "**Base client modules**" fuehrt, konsumiert vom Client-Stack (comdare-licensing = Client-B+-Lizenzbaum,
  comdare-registry, comdare-keybridge); server-seitig comdare-licensing-server. **NIE solche
  client/server-Generik-Module als "fehlplatziert" flaggen** — der #38-Irrtum wurde ausdruecklich
  zurueckgezogen; sie sind **by design**. Einzige offene Frage bleibt **Tracking** (self-tracked Zelle vs.
  eingebettet, #274), **nicht** thematische Zuordnung. — dieselbe Datei, 08.07.2026, OWNER-WORT.
- **X-7** **ALLE comdare-Projekte sind C++ — auch die Webserver (Drogon)** (User 03.07.2026): nicht
  Java/Spring, nicht Node, nicht Python. **Konsequenz:** ein Projekt in einer ANDEREN Programmiersprache
  ist **per Definition KEIN comdare-Produkt**, sondern dient ausschliesslich als **Feature-Quelle**
  (Konzept-/Anforderungsspender); die eigentliche comdare-Umsetzung wird als C++/Drogon-Produkt nach
  Baseline-Methodik **neu implementiert** und teilt dabei die comdare-Modules. **Betroffene Beispiele
  (Stand 03.07.2026):** **ZenManagedAnalytics** (Java/Spring-Boot-Backend `zenanalytics.jar` +
  Zendesk-Frontend JS) = **Feature-Quelle, NICHT das comdare-Produkt** — die "zentrale comdare-API +
  Webseite + Unternehmens-Steuerung" wird C++/Drogon; **ZenToneAnalytics** (Konzept/JS) = Feature-Quelle;
  echte C++-comdare-Produkte: comdare-db, comdare-cache-engine, Steuerrater A/B, BuildSystem,
  Business-Plattform-Runtime. **Anwendung:** bei Discovery/Planung fremdsprachiger Repos **NIE "das ist das
  comdare-Produkt" schliessen** — immer als Feature-Quelle behandeln.
  — `feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources.md`, 03.07.2026, OWNER-WORT.
- **X-8** **Python ist in der Build-/Codegen-/Toolchain-Pipeline VERBOTEN** (Architekt-Direktive
  08.05.2026), weil **Talos OS** — die Production-Plattform des Diplomarbeit-Clusters — minimalistisch ist
  und Python **nicht standardmaessig** mitbringt. **Stattdessen:** (1) **CMake-Funktionen**
  (`add_custom_command`, `configure_file()`, `add_subdirectory()`) als **primaere Codegen-Sprache**;
  (2) **Shell synchron** in `*.sh` (POSIX) **und** `*.bat` (Windows) — **beide muessen identisches
  Verhalten zeigen**; (3) nicht in CMake/Shell ausdrueckbar → **kompilierter C++23-Helper** als
  BuildSystem-Tool, **nie Python**. **Bei jedem neuen Tooling-Stub NIEMALS `*.py` anbieten.** Die frueheren
  Setup-Skripte (`_generate_stubs.py`, `_copy_ext_repos.py`, `_analyze_licenses.py`,
  `_generate_legacy_reimpl.py`) waren **EINMALIG**. — `feedback_no_python_in_buildchain.md`, 08.05.2026,
  OWNER-WORT.
- **X-9** **Die Vendoring-Doktrin: drei Stufen, STRIKT in dieser Reihenfolge** (User 04.07.2026, "das war
  schon immer Fakt … LESEN") — erst wenn eine Stufe unmoeglich ist, die naechste:
  (1) **Vendor `is_original=true` mit Compiler** — wo echter Quellcode existiert UND integrierbar ist: den
  ECHTEN Code von der offiziellen Quelle vendoren + compilieren (**hoechste wissenschaftliche
  Ehrlichkeit**). Praezedenz: **HdrHistogram_c** (AP-8, CC0).
  (2) **Faithful Re-Implementierung** — wo KEINE Implementierung existiert (nur Paper/Poster/Beschreibung):
  haargenau wie beschrieben nachbauen + Re-Impl-Annotation (`is_original=false`). Praezedenz: **SwissTable**
  (AP-7, #27), **VampirNfp** (P33).
  (3) **Self-contained Re-Impl** — nur als **LETZTER Ausweg**.
  "**Nicht fragen — die Reihenfolge anwenden.**" Dokumentiert in `axes/*/PAPER_REFERENCES.md` +
  `docs/architecture/18_*map.md` + `cmake/is_original_codegen.cmake`.
  — `feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained.md`, 04.07.2026, OWNER-WORT.
- **X-10** **Paper und Paper-Code liegen physisch GETRENNT von der eigenen Achsen-Implementierung**
  (User-Direktive 27.05.2026, verbatim): "**Bitte verschiebe die Paper in der cache engine nach ext
  Unterordner in die richtigen topics. Untergliedere unter ext/topic auch die Paper nach Achsen. Dort
  gehören kuratierte Paper Code hin.**" **Pflicht-Struktur:** `ext/<topic>/<axis>/paper_<id>_<name>/` →
  externer, **read-only kuratierter** Paper-Code mit `LICENSE`, `manifest.txt` (wrapper_fn ↔ paper_fn ↔
  src-path), `sha256_locked.txt` (vom `is_original_validator`), `README.md` (Paper-Ref + Source-URL),
  optional `MODIFICATIONS.md`, `src/`. Demgegenueber `libs/cache_engine/topics/<topic>/<axis>/` → **EIGENE**
  Achsen-Implementierung (Wrapper `axis_*.hpp`, `*_concept.hpp`, `*_registry.hpp` mp_list, `concepts/`).
  Generierte `is_original.hpp` unter `build/.../generated/topics/<topic>/<axis>/legacy_code/`. **Zweck:**
  eine Wrapper-Aenderung beruehrt **KEINEN** Original-Paper-Code; Habich-Compliance (is_original-Linking)
  ist Pflicht. **Bei NEUEN Achsen** `paper_<id>_<name>/` direkt unter `ext/<topic>/<axis>/`,
  `comdare_register_paper_wrapper` mit `LEGACY_DIR = ${_axis_legacy_root}/paper_<id>`; **kein
  `libs/.../legacy_code/`-Ordner mehr**. **Stand-Hinweis der Datei selbst:** die konkreten Pfad-/
  paper_id-Beispiele sind **Mai-2026-Stand → gegen das ce-Repo verifizieren.**
  — `feedback_ext_paper_organisation_separates_axes_from_paper_code.md`, 27.05.2026, OWNER-WORT.
- **X-11** **Die 8er-Docker-Distributionsliste und die Plattform-Matrix (User 03.07.2026):** die
  cache-engine und ALLE Module/Produkte werden in einer **8er-Docker-Distributionsliste inklusive Ubuntu**
  gebaut — **nicht 7; die 7er-Annahme des CI-Blueprints war falsch.** **Plattform-Matrix:** (1)
  Docker-Container IMMER auf **bare metal UND Talos OS in voller Matrix** + **mac ARM64, mac x86, RISC-V,
  Pi5-ARM64**; (2) auf den exotischen Plattformen zusaetzlich **alle Binaries bare metal**; (3) **x86 ohne
  Optimierungen → Odroid H4**, **x86 mit Optimierungen → grosse prod-Runner**, dabei **AMD und Intel
  SEPARAT fuer alle HW-Erweiterungen** (ISA/SIMD-Matrix) — **prod1 = AMD Ryzen 9 9950X3D (`pmc:amd`),
  prod2 = Intel i9-14900KS (`pmc:intel`)**. Relevant fuer die "ausdruecklich letzte Aufgabe" **#276**
  (Voll-Plattform-Matrix als CI-Pflicht) und **#13/#270b** (3-ISA amd64+arm64); der ISA-Teil ist
  toolchain-/infra-gated (Runner-Fleet).
  — `feedback_build_matrix_8_docker_distros_full_platform_doctrine.md`, 03.07.2026, OWNER-WORT.
  **Siehe W-26 — diese Plattformen sind einen Monat aelter als das Etikett "neu seit 02.08.".**

### 3.16 Cluster-Netz, Hosts, Backup- und Wissens-Orte

- **Y-1** **Die VLAN-Tabelle (Stand 07.07.2026, konsolidiert aus Cluster-Ledger + ZIELARCHITEKTUR-v9.2 +
  LIVE-STATE/KB):**

  | VLAN | Zweck | Schluessel-Adressen |
  |---|---|---|
  | V1 | OUTSIDE/Vorraum (VPN-Schicht 1) | FGT-Edge |
  | V10 | MGMT | VIP 10.0.10.1 (Host-Overrides gitlab/registry/minio); OPN .11/.12; Pi5-Jump .207; prod-BM .211/.212 |
  | V15 | alt prod-CP (VERALTET fuer Nodes) | K8s-API-VIP 10.0.15.250 |
  | **V16** | **prod-K8s-Nodes** (Umkehr V15→V16) + Service-VIP fuer Pods | **VIP 10.0.16.1** (CoreDNS-Ziel) |
  | V20 | NAS/DMZ-Storage | **NAS 10.0.20.101** |
  | V30 | Services/Identity | Samba-AD 10.0.30.5, cert-manager .6 |
  | V40 | Apps/Ingress (dev-K8s IPPool apps-vlan40) | ingress-nginx 10.0.40.6, gitlab-shell .5, stalwart .7 |
  | V50 | DMZ (virtuell auf OPN) | |
  | V60 | Build/Runner | VIP 10.0.60.1 (Runner-DNS gitlab/registry/kas) |
  | V70/V75 | Sonder/Voice | FritzBox V75 |
  | V80 | Backup | longhorn-backup 10.0.80.214-222, IPPool 10.0.80.224/27 |
  | **V90** | **dev-DB + dev-MinIO** (GitLab-Buckets registry/artifacts/cache) | DB-LBs .51-.57, minio-lb .224 |
  | **V91** | **prod-DB + prod-MinIO** (longhorn-cold, Replica-2, cache prod) | VIP 10.0.91.1 (CARP vhid 91) |
  | V99 | VPN (IKEv2) | |
  | V100 | BGP-Transit dev (Calico eBGP ↔ OPN) | OPN .1-.4, VIP .10 |
  | V110/V111 | prod-BGP/ClusterIP-Announce | |
  | V120/V121 | (Reorg-Ziel von V110/V130) | |
  | V130 | dev-Pod-CIDR-Ebene (pod-vlan130 10.130.0.0/16) | |

  — `reference_cluster_vlan_tabelle_sni_standard_pattern.md`, 07.07.2026, MESSUNG.
- **Y-2** **SNI-STANDARD-PATTERN (bindend, User 07.07.2026 bestaetigt):** Cross-VLAN-Zugriffe laufen
  **IMMER ueber die lokale `.1`-CARP-VIP** des Quell-VLANs (OPNsense-HAProxy, **https-in :443 =
  TCP-SNI-Passthrough, 12 SNI-Regeln**: www/comdare.de, gitlab, registry, kas, minio, grafana, prometheus,
  alertmanager, longhorn, dmz-website, mail, monitoring — reboot-fest validiert, KB-027-Saga). **Direkte
  Cross-VLAN-IPs (z.B. Pod → 10.0.90.224) sind isolations-widrig und werden geblackholt/gefiltert.**
  **Konkret: V16 → SNI → V90 ist der SOLL-Pfad fuer gitlab-Pods → dev-MinIO.**
  **Vorfall 07.07.2026 (der Grund fuer dieses Memory):** ein MinIO-Umbau (~28.06.) setzte den
  dev-CoreDNS-Override `minio.comdare.de → 10.0.90.224` (direkte V90-LB-IP) statt auf die VIP → gitlab-Pods
  erreichten S3 nicht → **Registry 9 Tage ohne Storage** → Projekt-Transfer-500
  (`Faraday::TimeoutError` beim Registry-Tag-Check). **Fix: Override → 10.0.16.1** + Registry-Rolling-
  Restart → Transfer OK. Diagnose-Zugang: Pi5-Jump `node7@10.0.10.207` (cluster-Key, **CRLF bereinigen!**)
  + `sudo kubectl --kubeconfig /root/.kube/config` (dev). **Regel:** bei JEDER Dienst-Anbindung aus
  Pods/Hosts **nie** direkte Cross-VLAN-Service-IPs eintragen — immer die lokale `.1`-VIP + SNI-Hostname;
  **dev-MinIO (V90) und prod-MinIO (V91) nie verwechseln.** — dieselbe Datei, 07.07.2026, MESSUNG.
- **Y-3** **Das untracked Plain-Backup auf dem Desktop (User-Direktive 22.07.2026).** Waehrend ueber den
  git-tracked Teil ein PAT-Scrub + exzessive History-Rewrites laufen (die den Stand unkontrolliert
  zuruecksetzen koennen), gibt es ein **UNTRACKED Plain-Backup**, das regelmaessig ueberschreibend
  synchronisiert wird. **Ort:** `~/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/` — enthaelt
  `probst-diplomarbeit-cache-engine/` + `comdare-prt-art/` (ohne `.git`/`build*`/`Testing`/`.ccache`),
  `refresh-backup.sh`, `LAST-SYNC.txt`, `.cron.log`. **Automatik:** crontab `*/15 * * * * …/
  refresh-backup.sh` (session-unabhaengig, ueberlebt Abstuerze). **Skript-Regeln:**
  `rsync -a --delete --delete-excluded`; exkludiert `.git`/`build*`/`Testing`/`.ccache`/`cmake-build-*`/
  `.idea` **plus `*TRANSKRIPT*`** (Session-Transkripte tragen Live-Tokens und duerfen NICHT verbreitet
  werden). **SELBST-WACHE:** `grep` gegen `glpat-`/`github_pat_`/`ghp_` nach jedem Sync (warnt in
  `.cron.log`, **muss 0 sein**); die grep-Pipe braucht `|| true` gegen `set -e`-Abbruch bei 0 Treffern.
  **AUSGENOMMEN:** Cluster-git (`~/Projekte/Cluster`) — bewusst NICHT gesichert, keys bleiben
  gitlab-lokal-only. — `reference_desktop_plain_backup_diplomarbeit.md`, 22.07.2026, OWNER-WORT.
  **MESSUNG (10.08.2026, dieses Dokument):** das Backup **laeuft** — `LAST-SYNC.txt` = **2026-08-10
  08:45:02**, der crontab-Eintrag ist vorhanden (`*/15 * * * * /home/comdare/Desktop/
  DIPLOMARBEIT-PLAIN-BACKUP/refresh-backup.sh >> …/.cron.log 2>&1  # DIPLOMARBEIT-PLAIN-BACKUP`).
  Dies ist die **einzige** der 106 Dateien, deren Zustand hier am Objekt als **aktuell gueltig** belegt ist.
- **Y-4** **Der Cross-Account-Handover der 322 Infra-Agent-Memories** (cwd `C--WINDOWS-system32`,
  Windows-Infra-Abteilung) liegt **read-only** im Cluster-Repo `comdare/cluster/
  comdare-cluster-development` (origin/main): `docs/agent-memories-infra/
  INFRA-AGENT-MEMORIES-KONSOLIDIERT-20260708.md` (**14542 Zeilen**, alle 322 Memory-Bodies je
  `===== FILE: <name> =====`) + `README.md` (Restore-Rezept), Commit **`a616eb0`** (08.07.2026).
  **Secrets redigiert** (`{{REDACTED*}}`); Klartext nur im gitignored `keys/`-Vault.
  **Aufteilung: 264 der 322 fehlten im Impl-Store** — davon **~180 reine Infra** (VLAN/CARP/OPNsense/
  Samba-AD/DNS/WireGuard/FortiGate/etcd/Talos/k8s/NAS/PAT-Rotation/Runner-Admin) + **~60 ce-Architektur**
  (bereits im ce-Repo dokumentiert) + **~20 Cross-Cutting-Direktiven**.
  **Uebernommen (10 Striktheits-Direktiven, 08.07.2026):** `no_runtime_switch` · `compile_time_only` ·
  `lehrbuch_design_patterns_only` · `meta_driven_concept_hardening_pattern` · `crtp_concept_guard_mix` ·
  `no_whole_tier_axes_genus_configurator` · `vendoring_doctrine` · `no_python_in_buildchain` ·
  `build_matrix_8_docker_distros` · `ext_paper_organisation`.
  **Bewusst NICHT uebernommen, mit Begruendung:** `feedback_buildsystem_not_cmake` und
  `feedback_no_git_submodules` gelten fuer comdare-**Produkte/Baugruppen** (buildsystem.xml-Aufloesung,
  cd-buildsystem) — **die Diplomarbeit nutzt CMake/ctest als offiziellen Dev-Weg und Git-Submodule fuer die
  4-Repo-Struktur** (super → ce/prt-art/thesis); dazu ~180 reine Infra-Memories (nicht meine Domaene) und
  ~60 ce-Architektur-Memories (Inhalt im ce-Repo, kein Duplikat).
  **Nutzung:** bei einer konkreten Frage gezielt den `===== FILE: <name> =====`-Block lesen
  (`git show origin/main:docs/agent-memories-infra/...`), **nicht kopieren**.
  — `reference_infra_agent_memory_handover_322_location.md`, 08.07.2026, MESSUNG.
  **Vier der zehn uebernommenen Direktiven sind X-8, X-9, X-10 und X-11 dieses Dokuments — alle vier waren
  unverlinkt.**

---

## 4. Historische Lage-Anker mit SHAs, Job-IDs und Zahlen

Diese acht Dateien sind Status-Verlaeufe. Sie sind als Tages-Stand **ueberholt**, aber als **Zahlen- und
SHA-Anker unverzichtbar** — es ist genau die Art Material, an der die "47 von 47" unrekonstruierbar wurde.

### 4.1 Chunk-Delta 26.07.2026 — durch API-Stoerung verlorene Owner-Antworten

Wortgenau rekonstruierte Owner-Antworten aus "verlauf-31/32" (26.07., API-Verluste), die im
Kompaktierungs-Dossier fehlten. Voller Delta-Report **D-01..D-17** im Workflow-Output der Session
**`wshvhykd7`**. — `project_20260726_chunk_delta_verlorene_owner_antworten.md`, alle OWNER-WORT, sofern
nicht anders markiert.

- **M-1 (D-01, KERN)** Owner woertlich: "**Das Design und die Regressionen muessen vor dem voll Build und
  der voll Messung fest behoben und eingebaut sein.**" → Lane C (external_utils-HUB) **nicht** inert lassen;
  Rename plus R-F-Materialisierung **vor** Voll-Bau-4, nicht in Band C.
- **M-2 (D-02)** PMC-Gate hart: `pmc:amd` **UND** `pmc:intel` muessen auf Comdare gesetzt und erfolgreich
  sein, bevor eine Maschinen-Lane den Strang abarbeitet (**AND** auf Comdare, XOR nur bei Fremd-Cluster);
  Runner-Filter verifizieren; festes PMC-TODO.
- **M-3 (D-03, Frist-Definition)** Mo 27.07. = die **erste echte Mess-CSV trifft auf dem NAS ein**
  ("Prof. Habich reicht es die ersten Mess-CSV eintreffen zu sehen"); LaTeX/PDF **danach** aus der
  Auswertung.
- **M-4 (D-05)** Der Voll-Bau **invalidiert den Prototyp-Bestand** (Ast-Neu-Inventarisierung); das
  Bestandslog wird beim Build **und** beim Messen **je Realm** fortgeschrieben → ein Mess-Realm-Writer war
  vor dem 01.08. noetig.
- **M-5 (D-06 bis D-08, D-17)** **D-06:** je Commit-Welle development pushen **und** main nachziehen (FF)
  auf **beiden** Remotes. **D-07:** CI-Restpunkte vor dem Build-Neustart klaeren (sonst
  Binary-Verlust-Risiko). **D-08:** der github-PAT ist **NEU** — vor dem naechsten Dual-Push aus dem
  Cluster-Vault ziehen. **D-17:** den thesis-Klon mit Dual-Remote nach `super/Code/external` **und**
  `Projekte/Research` pullen.
- **M-6 (D-09, Lane A)** `load_framework` ist das **letzte CEB-Glied** UND stets die **erste
  Meta-Meta-Achse**; das on/off-Token gehoert in Ordner-/Metadaten-Namen ("hinter load_framework wenn
  vorhanden on/off").
- **M-7 (D-11, D-13 bis D-15)** **D-11 (offen):** der Owner schrieb woertlich "**extermal_utils**"
  (Tippfehler) — die Schreibweise "external_utils" ist die **Korrektur-Annahme des Agenten**, vor Lane C per
  Ein-Zeiler zu bestaetigen (AGENTEN-BEHAUPTUNG). **D-13:** die Erlaubnis-Haelfte der Mapping-Reinheit —
  verschiedene RT-Unter-Achsen-Varianten auf **dieselbe** CT-Haupt-Achse sind erlaubt (Begruendung fuer
  1 Sheet je Unter-Permutation). **D-14:** Punkt "**2.4-(8)**" ist Vor-01.08.-Pflicht und wird **nie** als
  erledigt gefuehrt. **D-15:** die Dossier-Posten (Q-1 `enabled=false`, A-1 Truncate, R-F, CT/RT-XOR) sind
  paraphrase-basiert und beim Owner rueckzubestaetigen (byte-/ABI-relevant).
- **M-8** **"2.4-(8)" definiert:** Punkt 8/9 in Abschnitt 2.4 des G4b-Verdikts
  (`backups/20260726-g4b-planung-workflow/ergebnisse/00-verdikt-abeddd8c.md:122`) = "Kein Claim-CHECK, kein
  Takeover" = **ABNAHME-6**: `is_reservation_takeable` / `is_takeable_by_eta`
  (`reservation_lifecycle.hpp`) gebaut und getestet, **0 Produktions-Aufrufer**. Bewusst aus G4b/(d2)
  herausdefiniert (ein filternder Provisions-Pfad-Eingriff vor einem 2-Tage-Lauf war das groesste
  vermeidbare Risiko), Pflicht vor dem 01.08. im Phase-4-Paket, erscheint **nie** in
  G4b-Erledigt-Bilanzen. — MESSUNG (Datei:Zeile-Beleg plus Code-Fakt).
- **M-9** **Backup-LUECKE erklaert (NACHTRAG F4/F5-Suchlauf, 26.07. ~15:15):** der Plaintext-Extraktor
  verwarf **982 `queued_command`-Records** (getippte Owner-Nachrichten, waehrend Agenten liefen) — deshalb
  fehlten die Entscheid-Antworten. Behebung: die Extraktion um `attachment.queued_command.prompt`
  erweitern, additiv ergaenzt. — MESSUNG.
- **M-10** Alle vier Kerne owner-verbatim **bestaetigt**, mit jsonl-Stellen **79807 / 79891 / 79936 /
  79475**: **Q-1** ("Wie empfohlen, korrekt. Die Achse wird per XML deaktiviert und das muss unterstuetzt
  sein"); **A-1** (wortgenau: Build-Ende = Regelfall, >4KB = ad hoc, Alleinschreiber-Lock); **R-F** ("zu
  denen auch AVX und SIMD gehoeren -> weitere Regression"); **CT/RT** (Owner-Original ist ein
  **Bikonditional** "Haupt = CT statisch, Unter = RT-dynamisch", Kriterium: "zur Laufzeit austauschbar =>
  Unter-Achse"). Nebenbefund **Q-0**, Owner woertlich: "**V2 Byte-Schnitt volles GO. Ich wuensche mir
  dennoch V3 direkt mit rein**" — deckt den Kurs ORG-18 + W-13 im V2-Schnitt. — MESSUNG.

### 4.2 O-8-Fenster 27.07. bis 02.08.2026 — der lange Lage-Anker

`project_20260727_vormittag_o8_fenster_lage.md`. **Frontmatter sagt "27.07. vormittag", der Fliesstext
reicht bis 02.08. ~00:xx** — sechs Tage weiter (siehe I-8). Alles MESSUNG, sofern nicht anders markiert.

- **N-1 (27.07. ~08:45Z)** O-8-Fenster an Agent Impl-O8 vergeben. Plan:
  `super docs/sessions/20260727-PLAN-o8-fenster-atomar-ultracode.md` Rev. 3, alle 11 OPs final. 4a-Re-Pin
  abgenommen: Pins super **`6ca9502f`** / ce **`7dd41b18`**; Neu-Basis ce **316** / super **453**.
  **ZWEI-GATE-ENTSCHEID** nach dem Befund "super 453/453 war NIE belegt": ce-standalone = scharfes Gate
  (316/316, CRC **`0x56F1B721C72DC10E`**, Golden-Doppellauf); super = Integrations-Gate (Erwartung
  **450/5/453**, eingefrorene 5er-Fehlerliste — siehe W-08).
- **N-1a (27.07. ~08:45Z, Infra-Pendenzen)** Die **sechs offenen Infra-Handouts**, namentlich:
  **P1 Host-Install** (als DRINGEND markiert, Handouts **`db07938`** / **`3b535f8`**), **P4 Win-git**,
  **P5 OD-7 heavy**, **P6 2b-Vermerk**, **P9 `gitleaks`-0-Bytes**, **prod2 ram/cas** (Rest aus O-4a).
  **P9 ist der Posten, aus dem die gitleaks-Byte-Zahlen dieses Anker stammen** — ein `lint:secrets`, der
  **0 Bytes** scannt, meldet zwangslaeufig "no leaks found"; das ist kein Gruen, sondern ein blinder Job.
  Im selben Fenster lief die Watch-Rolle **CiCheck288c** (Opus, read-only, PAT 2.-von-hinten, vgl. I-7b) mit
  Floor-Wache, 15.3-Probe-Alarm, #347 und Idle-Melder; der Idle-Melder loeste das Infra-Wartungsfenster aus
  (prod1-Runner-Swap **19.1.1** + docker-Executor-Pilot, freigegeben vor 01.08., **Pilot nie `measure`**,
  Host-15.3-Install im selben Fenster erbeten — Handout **`9ba1479`**).
  — `project_20260727_vormittag_o8_fenster_lage.md`, 27.07.2026, MESSUNG.
- **N-2 (27.07. ~12:25Z)** O-8-Fenster gelandet: ce dev **`7dd41b18`..`e6aeee17`** (17 Commits), super dev
  **`6ca9502f`..`88ccd1b7`** (5 Commits, Gitlink-Bump), beide Remotes, main unberuehrt. Naechste Reihenfolge
  inkl. "**Voll-Bau-4 01.08. (P5-heavy verbindlich c=1/24/nproc)**" — die Zahl 24 siehe W-02.
- **N-3 (27.07. ~12:43Z)** O-8 komplett CI-bewiesen: ce **286/13540** (17 Jobs gruen); super **288/13545**
  (13 Jobs + 3 Bridges gruen); `build:clang` **66,8s**; `lint:secrets` liest **107,90 MB**.
  SHAs: ce **`e6aeee17`** / super **`b3cf9a3a`**.
- **N-4 (27.07. ~15:10Z)** Tages-Doppelabschluss, Kanon vollzogen — siehe H-4. Watchdog-Root-Cause gefunden:
  `gr-eof-watchdog` wertete Log-Stille als Defekt (**36 Restarts / 24h** → Zombies / `data_integrity` /
  Marathon-Kontext), Fix v3.
  **~15:30Z:** Uebergabe
  `super docs/sessions/20260727-UEBERGABE-tages-doppelabschluss-o8-d3-kanon-153.md` (Commit **`a4dc6891`**);
  `main == dev == a4dc6891` (super) / **`e6aeee17`** (ce) / **`5f9e04be`** (ci-templates).
- **N-4a (27.07. ~15:10Z)** **Der D3-CI-Paket-Inhalt, live gegangen** — sechs Posten, woertlich aus der Quelle:
  (1) **Kaskaden-Stopp** (Bridges `changes`-gegated, der main-immer-Zweig weg — vgl. W-17, wo genau dieser
  Zweig am 02.08. wieder als bestehend gemessen wurde); (2) **`build:clang` per DAG**
  (`needs: verify:submodules`); (3) **Alt-Flags → Subcommands**; (4) **`visibility` auf `plan dump` v1.1**;
  (5) **zentrale gitleaks-Basis**: `ci-templates/gitleaks/gitleaks-base.toml` **plus
  Heredoc-Materialisierung**, **PRAEZEDENZ: projekteigene `toml` > Basis**, **geloggt**;
  (6) **`.ccache`-Allowlists**.
  **Warum Posten (5) hier steht:** die zentrale gitleaks-Basis ist die einzige Quelle, die den Vorrang
  projekteigener `.toml` vor der Basis festhaelt — und die Landungs-Kette faehrt gitleaks bei jedem Push.
  Nicht zu verwechseln mit den `config.toml`-Fundstellen dieses Dokuments, die alle Codex betreffen.
  Offen laut derselben Quelle: **Kaskaden-Stopp-NEGATIV-Beweis** (die naechste docs-only-main **muss**
  bridge-frei sein — am 27.07. ~16:10Z durch **13567 + 13569** terminal erbracht, siehe N-5),
  **Beweis-2-POSITIV** via main-Wellen-Bridges (`changes`-Gate), **Zombie 335274** force-drop (Infra),
  **Marathon-Ursache 335274** formal offen. **Folge-Pakete** dort benannt: 2c
  (`tier_binary_report_cli` auf `plan dump`), prod2-RAM-4800-Mini, ce-Zug (**toml-Delta OP-3** +
  `--emit-tier-ci`-Migration), OP-2 (`test:unit`-needs), V-3/V-4-Retire, §75-Aufraeumpass.
  — `project_20260727_vormittag_o8_fenster_lage.md`, 27.07.2026, MESSUNG.
- **N-5 (27.07. ~16:10Z)** 6a geschlossen (Beweis 2 beidseitig terminal: positiv **13561/13560/13564**
  success; negativ **13567 + 13569** docs-only-main mit `bridges=0`). Referenz damals geeicht:
  docs-only-main = 13 Jobs / 0 Bridges, docs-only-dev = 2 Jobs — **die 0 ist seit 02.08. ueberholt, siehe
  W-17**. 6b OP-2 done: `test:unit needs:["verify:submodules"]` (**`abbf53ef`**, Welle **13570**,
  13/13 + 3/3 gruen) — ein **Korrektheits**-Fix, kein Scheduling-Fix (die fruehere Herleitung war falsch:
  `.test` erbt `needs: []`). Nach Welle **13574** gruen: main-FF auf **`57b61af0`**.
- **N-6 (27.07. ab 17:10Z, Prozessregel)** prod1 hat `cf22` (`~/tools/cf22/usr/bin/clang-format-22` = exakt
  die CI-Version **22.1.8**, bekannt seit 09.07.). **Neu ab hier:** jedes Impl-Briefing mit C++-Aenderung
  traegt den cf22-Pfad plus den Pflicht-Selbstcheck
  `clang-format-22 --style=file:.clang-format --dry-run --Werror <geaenderte Dateien>` mit **literaler
  (leerer) Ausgabe** in der Paketmeldung; die Manager-Format-Abnahme bleibt zweite Linie. Analog ASCII:
  sed-Form verwenden, `grep -v` ist zeilenblind. — AGENTEN-BEHAUPTUNG (aus der Analyse von 2 vermeidbaren
  Manager-Nachfixes).
- **N-7 (27.07. ~18:30Z)** Task-#7-Spec komplett (**`cad7290e`**) — HW-Erkennung als zweigeteilte MESS-Achse,
  deckungsgleich mit F-4. **P2-P6 RUHEN per Owner-Wort** bis Voll-Build und Messdurchlauf (Ausnahmen: E-2
  Schluessel-Fix und OP-9). Wellen-Modell praezisiert (13600): das changes-Gate wirkt **pro Bridge** — ein
  reiner Gitlink-Bump feuert nur `trigger:cache-engine` (1 Bridge); 3-Bridges-Faelle kamen stets von
  `.gitlab-ci.yml`. Staende: ce `main == dev == ` **`a3bc2e13`**; super main **`e0893eb5`**,
  dev **`cad7290e`**.
- **N-8 (27.07. ~18:50Z)** OP-9 (`built_stem` additiv v1.1) + E-2 (`ram_pair ddr5_2x32`, Bump
  **`25ad654b`**) + **V-4 RETIRE** (**`813c3232`**, **-2183 Zeilen**, `comdare_permutation_codegen_cli`
  **existiert nicht mehr**) + Identitaets-Tests registriert (**`52bcbc76`**: `test_o4` + `test_c3a` ins
  Gate, netto **318**). Gate-Referenzen: ce-ctest **318** (+23 gtest-Faelle); die
  super-Gesamtsuite-Referenz war 458/5/453 und ist nach V-4 neu zu messen (-2/+2 ce-seitig).
- **N-9 (27.07. ~19:15Z, abbruchsichere Pause)** Ein Spend-Limit ~19:04Z killte **alle** Agenten; danach eine
  **GitLab-500-Stoerung aller Auth-Pfade** (neue PAT-Kandidaten = 500, alte = 401 → serverseitig; github
  intakt). Autoritaet:
  `super docs/sessions/20260727-PAUSE-abbruchsicher-gitlab500-wiederaufnahme.md`. Die Ausgaenge der Wellen
  **13623/13624/13625** waren zu dem Zeitpunkt unbekannt; das Task-Board war durch den Spend-Limit-Neustart
  komplett geloescht.
- **N-10 (Wiederaufnahme 01.08.2026 ~19:00Z, NICHT 27.07.)** Die Pause dauerte **5 Tage** (Serverzeit-Beleg
  CiCheck288g; Runner-PID **1939298** lief durch, `etime` 5d). GitLab entstoert. Die Ausfall-Wellen
  13623/13624/13625 sind **alle success**, kein Job verloren. FFs und Bump gepusht: super main
  **`25ad654b`**, dev **`45519f9b`** (Bump auf ce `52bcbc76`); ce `main == dev == ` **`52bcbc76`**.
- **N-11 (01.08. ~20:45Z, Owner-Entscheide OE-A..F)** **FRIST → FREITAG 08.08.** (heute ueberholt, W-12);
  alle bekannten Pakete Pflicht vor dem Voll-Bau (HW-Erkennung P2-P6 reaktiviert, OD-10, E-04/E-18,
  Benchmarking-Schnitt, xlsx-Factory, 12-Perm "alles was geht"); **Beweis 1** = Batch-Wiederaufnahme-
  Konstruktion (Pflicht, kein Minimal-Ersatz); **Beweis 2** = gtest-Dummy-Lager (Textdateien mit
  Stempel-String, vgl. G-1/G-2); **OE-C: jede Haupt-Achse traegt ein Versions-Tag, ein Version-Bump loest
  die selektive Invalidierung aller betroffenen Binaries aus**; `VARIANT_GATE=true` im Trigger.
  3-Dossier-Workflow `wf_62640a90` lief. — OWNER-WORT.
- **N-12 (01.08. ~22:00Z / 02.08. ~00:xx)** Abend-Pause-Autoritaet
  `super docs/sessions/20260801-PAUSE-abendstand-wiederaufnahme.md`; Tages-Ertrag: OE-A..F plus F1-F9
  entschieden, P2 HW-Erkennung gebaut und gepusht (**Gate 320**), Thesis K0/K1/K2 abgenommen, offen nur
  F10+F11; kritischer Pfad: **Lager-Baum-Vollausbau vor Trigger (F9)**. Kontext-Ende und Neugruendung:
  `super docs/sessions/20260802-UEBERGABE-kontextende-neugruendung.md`, `main == dev`, beide Remotes;
  3 frische Agenten (Thesis-Sprachpass, CiCheck288h, Impl-CE-P3); F1-F13 und OE-A..F alle entschieden.

---
### 4.3 Die S5-/W-Wellen 04. bis 06.08.2026

- **O-1 (04.08.2026, Pause-Anker)** Linien, alle gruen, FF gepinnt, beide Remotes:
  ce `dev == main == ` **`28261b5a`** (**Gate 384**; A8-S3 plus ccache-Fix **`a8c2da91`** plus
  S5-04-Pilot **`a801a7e3`** plus A8-S4 gelandet); super `dev == main == ` **`ada8da48`** (Ledger bis
  abend-8). **LANDEBEREIT, aber UNGELANDET** bei Wiederaufnahme (R4-seriell, eigener Merge-Doppellauf
  Pflicht — nicht tree-identisch, S4 lag dazwischen; **N-Erwartung 388**): **S5-03** (wt-w10, Branch
  `s5-03-placement` @ **`3f391098`**) und **S5-01d** (wt-e24, Branch `s5-01d-traversal` @ **`df13450c`**).
  Resume-IDs falls die Workflows tot sind: **`wf_776d1c7c-f98`** / **`wf_fd0921bf-0d0`**.
  — `project_20260804_pause_s5_wellen_landebereit.md`, 04.08.2026, MESSUNG.
- **O-2** Reststrecke danach: P-CACHELINE-LITERAL (der einzige Kartierungs-Pflichtposten) → W2
  (01a → 02a → 01b) → W3 (02b → 01c mit Fable-Design-Vorlauf; **neue Kante: "Template-Kopf dreht
  Registry-XML"** = 01d-Befund) → EIN ANKER (beendet die Job-Sperre) → Phasen 3-5 → Trigger Do 07.08.;
  **Messung Phase 6 = USER-GO-STOPP.** Owner-KERN abend-6 woertlich: "**ALLE Achsen-Eigenschaften NUR ueber
  die Achsen**" — Ausnahme: die Genus-Erst-Instanziierung. Kartierung fertig (abend-8): 1 Pflicht plus
  Posten 55-63, die Wellen-Reviews ergaenzten (64)-(66). Zu dem Zeitpunkt war `.patcfg` geshreddert (der PAT
  muss neu blind extrahiert werden) und die Job-Sperre aktiv bis zum Anker.
  — dieselbe Datei, 04.08.2026, OWNER-WORT + MESSUNG.
- **O-3 (05.08.2026 ~06:55Z)** ce `dev == main == ` **`24e07219`** (**Gate 403**; 01c-3 **`98eea2e7`** plus
  Q-Welle **`b09ebb8a`** plus **PHASE B GELANDET** `24e07219` — `EffectiveSearchAlgo` an 3 Treiber-Stellen,
  22/22-Traversal-Symmetrie, Pipeline **14633**): "der GESAMTE A8-S5-Bau-Komplex ist FERTIG".
  Owner-Wort mittag-12 woertlich: "**nach allen Workflows zum Hauptstrang, zuerst
  Implementierungskorrekturen, dann nach Plan wie gehabt.**"
  — `project_20260805_pause_01c_komplett_vor_phase_b.md`, 05.08.2026, MESSUNG + OWNER-WORT.
- **O-4 STUFEN-DOKTRIN, owner-abgenommen** (mittag-9/-10/-11): **Mess = 3-stufig dehnbar**
  (Planer-RT → CEB-CT inkl. Pruefdock-Konfig → [Hybrid-CT] → Tier-CT); **System = 2-stufig dehnbar**
  (CEB-RT → [Hybrid-CT gibt sich und den Tiers die Config mit] → Tier-CT); **Organ = 2-stufig,
  hybrid-unberuehrt** (Hybrid = Factory-Facade-Adapter, organ-frei). Weitere Owner-KERNe desselben Tages:
  **nie raten**, sauberster Weg nach Plan; Interims **immer** mit Nach-Abgabe-TODO; vor Rueckfragen
  **immer** Explore ueber den Plan-Korpus (>1200 beantwortete Fragen).
  — dieselbe Datei, 05.08.2026, OWNER-WORT.
- **O-5 KETTE-AUDIT (vormittag-4, Owner-Anstoss)** Zwei neue Owner-KERNE: **der Planer ist ZWINGEND eine
  eigene Binary mit Shell-CLI**; **CEB == CacheEngineBuilder** (woertlich). Verdikte: G1 **REGRESSION** ·
  G3 **Kernsatz-Verstoss** · G4 bewusst-deferred (Payload S5-P4-DEPRECATED) · G2/G5 teil-konform. Ergebnis:
  ein **6er-Regressions-Register** plus **7 OFFENE OWNER-RUECKFRAGEN**, **keine** Impl-Aenderung ohne GO.
  Backup: `backups/20260805-planer-ceb-kette-audit/`. Umgesetzt am selben Tag ~14:30Z:
  ce `dev == main == ` **`60c7c56a`** (**Gate 405**; `comdare-experiment-planner` als eigene App, zwei
  Module ueber eine Fassaden-lib; `-D COMDARE_MEASUREMENT_COMBO_CT` mit CT-Vorrang, `[all]` byte-identisch)
  — **R-G1 GESCHLOSSEN**; super `dev == main == ` **`69dd9fb7`** (Merge `409757b0`).
  — dieselbe Datei, 05.08.2026, OWNER-WORT + MESSUNG.
- **O-6 FALLE (05.08.):** **neue `-D`-Makros nie in String-Literal-Adjazenz** — sonst CI-Rot
  (Welle **14673**, `lint:static`). — dieselbe Datei, 05.08.2026, MESSUNG.
- **O-7 ABSCHNITTS-TRUTH-CHECK S5 (A2-Pflicht, `wf_94ca9f27`) — WIDERLEGT:** Familie 05 nur **2/4** —
  **`queuing_q1` / `queuing_q2` haben KEINEN `axes/`-Ordner, sie leben nur in `topics/queuing/`**
  (13-14 von 18 Q1-Headern mit Organ-Zustand am Default-Allokator; **Q1 = T15 mandatorisch**, live via
  `abi_adapter` :1010 / :1086 / :1165). Die Substanz haelt sonst (golden/XML/Wire byte-neutral ueber
  `65a61fcf..98eea2e7`). Posten 83-86 im Ledger. **Daraus die Falle:** Nachweis-greps muessen die
  `topics/`-Doppelwurzeln erfassen — ein `axes/`-grep ist blind fuer queuing.
  — dieselbe Datei, 05.08.2026, MESSUNG.
- **O-8 Weitere Fallen desselben Tages:** System-Header-falsches-Gruen · `cf22` nur als **echtes Binary**
  (kein Alias) · **3 Marker-Typen** vor jedem Commit pruefen · ein **CRTP-Weiterleiter ohne eigenen Member**
  ist eine **stille Rekursion** · Projekt-IDs: **super = 288, ce = 286** (die Pipelines-API nimmt nur den
  VOLLEN SHA, vgl. I-5). — dieselbe Datei, 05.08.2026, MESSUNG.
- **O-9 ANKER KOMPLETT S0-S8 (05.08. ~13:00Z)** A2-SHA512-Eichung F7 gelandet: ce `dev == main == `
  **`18fbb950`** (**Gate 404**, Pipeline **14659**; `dll_is_current` ist **ein** fail-closed-Vergleich) plus
  TP1-FINAL-Inventur (9/9 Gates, `TP1_ANKER_OK`). **DAUER-AUFLAGE aller W-Wellen:
  Fingerprint-Neutralitaet** (Frozen-Vektor `0fe275bd` / golden-CRC / abi-Diff 0) — ein Verstoss bedeutet
  STOP plus O-2. Atlas komplett bis **REV 5** (super **`432a130c`**); zuvor REV 4 mit **neuer Artefakt-URL
  `61359d31...`** (die alte wurde geloescht), L4-Konnektivitaet 0 lose Knoten, super `dev == main == `
  **`ba56b8df`**. — dieselbe Datei, 05.08.2026, MESSUNG.
- **O-10 DUAL-REVIEW-AERA A3 (05.08. ~17:20Z)** ce `dev == main == ` **`b4110cd0`** (**Gate 405**; W1/W2
  plus cppcheck-Hotfix plus w2-codex-fixes); super `dev == main == ` **`c9eedace`**. **A3-DUAL-REVIEW-PFLICHT
  etabliert** (Codex **und** Fable Pflicht; Codex lebt, bwrap intermittierend → INLINE-Diff-Rezept, vgl.
  C-3). W1/W2: 3 Befunde gefixt und gelandet; A2-Eichung: 6 Befunde (C1/C4/C5/C6 real); **O-2 OWNER-GATE
  offen**: Preimage-Neuanker C1+C6 vor Trigger gegen Interim; W5/W3: 9 Befunde, Nachbesserungs-Welle
  `wf_a870c885`. **Parallel-Session aktiv** (Systemabsturz-Neustart, glaubt an eine stale
  "Sonnet-Uebernahme") → **Worktree-Besitz-Register bindend**: `wt-e24`, `wt-super-w1` und die Haupt-Trees
  gehoerten dieser Session; der Owner-Entscheid zur Session-Fuehrung war zu dem Zeitpunkt offen.
  — dieselbe Datei, 05.08.2026, MESSUNG.
- **O-11 (Nachtrag 06.08. ~07:00Z, Pause)** **W5/W3 IST GELANDET** — ce `dev == main == ` **`7969b399`**
  (**Gate 408**; 3-Zyklen-Dual-Konvergenz, **Codex final KEINE BEFUNDE**); super `dev == main == `
  **`644605b5`** (Sammel-Backup aller **26** Workflows). `wt-e24` / `wt-w2fix` / `wt-super-w1` frei; der
  haengende super-main-FF wurde geheilt; die B-Linie fuehrt die Reststrecke. **Neuer Erst-Anker 06.08.
  ~06:40Z** (Pause Netzwechsel): `super docs/sessions/20260806-PAUSE-abbruchsicher-netzwechsel-vormittag.md`
  (Merge **`1b7ca1e3`**). NB-2-Welle abrissgefaehrdet: `wt-b2` dirty ueber **`77095354`**. Schwelle 21:00
  (E-3). gcc-15.3/16-KERN (vgl. H-1). — dieselbe Datei, 06.08.2026, MESSUNG.

### 4.4 Setup- und Freigaben-Staende 02.07. bis 17.07.2026

- **P-1 (05.07.2026, Setup-Session #2)** Komplett: 3 Plugins installiert · **60 Memories** uebernommen ·
  GitHub-Remotes `github` angelegt, `ls-remote` deckungsgleich: super **`81f0975`** / ce **`c4eb7d7f`** /
  prt-art **`7997a0b`** · clang-format **22.1.8** in `~/tools/clang-format-22.1.8` (dpkg-deb-Extrakt, kein
  sudo) · 2 fehlende encryption-Module geklont (die Manifest-URLs hatten die Subgruppe
  `comdare-encryption/` vergessen) · Codex-MCP auf gpt-5.5 + xhigh.
  — `project_bep_abt_session_stand_20260705.md`, 05.07.2026, MESSUNG.
- **P-2 (Strang A / #258)** Vier uncommittete Dateien im ce-Working-Tree: (1) `cmake/is_original_codegen.cmake`
  plus `CMakeLists.txt` — Codex hatte 4 Listen-Targets in **5 redundante Bloecke** dupliziert, strukturell
  zurueckkorrigiert; **MESSUNG:** ein isolierter 5-Target-Build generiert `paper_a04_mimalloc_is_original.hpp`,
  `test_216h2` kompiliert durch. (2) cppcheck-FP-Suppressions in `test_188_4bbV_pool_adapter_flip_compile.cpp`
  und `test_s7_1_bst_pool_allocator_deg.cpp` — das `lint:static`-Rot war ein **False Positive** (anonyme
  Namespaces haben interne Bindung, die cppcheck-CTU ignoriert das bei Templates nicht).
  **Offener Rest #258:** `tests/unit/test_v41_anatomy_module_abi.cpp:34` —
  `namespace abi = ::comdare::cache_engine::abi;` kollidiert unter g++-16 mit
  `namespace abi = __cxxabiv1;` aus `<cxxabi.h>` (gtest zieht es auf GCC; MSVC hat kein `cxxabi.h`).
  Geplanter Fix: Alias → `ce_abi`, 11 Verwendungen Z. 60-95. Gleiche-Muster-Verdacht:
  `test_v41_anatomy_codegen.cpp`, `anatomy_module_loader.cpp`, `test_engine_adapters.cpp`.
  — dieselbe Datei, 05.07.2026, MESSUNG.
- **P-3 (Toolchain-Ist am 05.07.)** super-Pipeline **8007**, Job **212458**, `toolchain:probe=success`,
  Runner `prod-baremetal-prod1`: gcc-**16.0.1-trunk** (default) plus gcc-**13.3.0** vorhanden, **KEIN
  gcc-15/14**. Entscheid: den Pin **nicht** deployen ("Default bleibt bis dahin Trunk-16");
  **HO-11** = gcc-15.3 ins Infra-Paket (#272 / Strang F). clang++-22.1.8 vorhanden → `build:clang` auf prod1
  lauffaehig. Pipeline-Lage: ce **7965/7963/7958** (`c4eb7d7f`) failed = **nur**
  `contract:conformance` + `lint:static`; **7930** (`c9a7e44e`) failed dieselbe Klasse; `lint:format` gruen
  seit #257; prt-art **7966** gruen auf HEAD. — dieselbe Datei, 05.07.2026, MESSUNG.
- **P-4 (Pfad-Diskrepanz, gemeldet)** Der User sagte "Diplomarbeit liegt jetzt unter
  `Projekte/Research/Diplomarbeit`" — **dieser Pfad existiert nicht**, das Projekt liegt unter
  `Research/probst-diplomarbeit-cache-engine`. — dieselbe Datei, 05.07.2026, OWNER-WORT + MESSUNG.
- **P-5 (Nachtraege 06.07.)** #258-Fix-Paket gelandet (ce-Kette **`d51ef9a0`** → **`b9cc4fdb`**, super bis
  **`48a85c6`**) · **S7-2 BTree** (**`883a4ff1`**, `alloc_cnt=3`) · **S7-3 SkipList** (**`dd704d67`**,
  `alloc_cnt=21`) · **S7-4 Hash** (**`b9cc4fdb`**, `alloc_cnt=2`) · #271 perm_runner-Fix (**`19d7f701`**,
  Exit 1 → 0) · #272 HO-1..HO-12-Paket (super **`197729d`**); die kumulative Beweis-Pipeline **8022** war im
  Runner-Stau pending. **234-V GEPARKT** (Architektur-Fork, 2 offene User-Fragen). **AP-15-2 DONE**
  (ce **`81d0b6bb`**: `IAllocatorProxyTier` + `ComdareAllocatorProxyV1`; **MESSUNG:** literal 7/7 plus
  `family=4 bytes=512 allocs=5`). **AP-15-3 DONE** (ce **`4cc8c75e`**: `DriveableMapContract<Derived>`-CRTP);
  Session-Bilanz **19 verifizierte Increments**. **#264 im Kern DONE:** 264-a/a2 (ce **`ce1af878`** +
  **`8669210d`**, `comdare_tests`-Registry, die Suite baut **erstmals 788/788**; ehrlicher ctest-Vollauf
  **126/184**), 264-b (ce **`3895a3a5`**, `allow_failure` — siehe W-10), 264-c/c2 (prt-art **`8cb32fe`**:
  **drei** fehlende Header plus ein echter `LeafOnlyCounter`-Data-Race gefixt (shared_mutex,
  double-checked) — **211/211 PASS plus repeat:20**). — dieselbe Datei, 06.07.2026, MESSUNG.
- **P-6 (06.07.2026, Migration comdare@prod1)** Seit dem 05.07. abends laeuft die Arbeit als
  **comdare@prod1** (vorher root@prod1; der root-Claude-State wurde nach `/home/comdare/.claude` migriert,
  die root-Sessions liegen unter `~/.claude/projects/-root/`). Repos: super =
  `~/Projekte/Research/probst-diplomarbeit-cache-engine` (ce und prt-art als Submodule unter
  `Code/external/`), Cluster-Docs = `~/Projekte/Cluster/docs`, GitLab-PAT unter `~/keys/gitlab-pat`.
  Endstand der Nacht-Session (01:05-02:46 UTC): super **`3d23d7a`**, ce **`3895a3a5`**, prt-art
  **`8cb32fe`**. — `project_diplomarbeit_stand_20260706_comdare_prod1.md`, 06.07.2026, MESSUNG.
- **P-7 (Owner-Kritik 06.07.2026)** Die Nacht-Session hinterliess einen **inkonsistenten Stand**, die
  **GitLab-Pipeline lief nicht mehr durch**, und Codex-Arbeit wurde **entgegen der Anweisung nicht Zeile fuer
  Zeile gegengeprueft**. Vor Weiterarbeit gefordert: Ist-Verifikation, Pipeline-Endstand ueber die GitLab-API
  dokumentieren, **deterministische Fehler FIXEN statt re-triggern**, und die nicht-reviewten Nacht-Commits
  (S7-5..10, AP-15-2/3, 264-a/b/c) nachtraeglich Zeile fuer Zeile reviewen. — dieselbe Datei, 06.07.2026,
  OWNER-WORT. Vgl. C-8.
- **P-8 (GO 1-5, 12.07.2026)** **GO 1** — der Overleaf-Anhang ist verdrahtet (thesis **`73947aa`**,
  `\InputIfFileExists`, PDF-verifiziert) → die CI-interaktive Diplomarbeit laeuft **end-to-end**:
  XML → measure → Anhang-Regen (**16 `.tex`** via `08_appendix_generator`) → persist → PDF; Task #24
  completed. **GO 4 F-C** (ce **`a08a60ca`**): Cacheline-B32 additiv plus FF2-Unterachse
  `node_width {1,2,4,8,16}` — Owner woertlich: "**zusaetzlich, als dokumentierter Permutations-Knopf**"
  (F-B). **GO 3** (ce **`def62b0a`**): ISA-Deklarations-Wahrheit (Kohaerenz-Guard, **objdump-belegt**) plus
  Scan-Kern-Reinheits-Guard. **#25 komplett** (`format_tex.py` → `09_tex_formatter`; `codegen.cmake` →
  cpp-Backend byte-identisch, opt-in).
  — `project_diplomarbeit_stand_20260712_freigaben_pipeline.md`, 12.07.2026, MESSUNG + OWNER-WORT.
- **P-9 (Sequenz komplett vollzogen, Ledger §12 Zyklen I-IV)** Smoke-Profil (`m3_smoke_coverage`,
  **93 Binaries**) → F-B (`alloc_hw`, honest-0 beseitigt) → GO-5-Forks (H2-Score tool-berechnet
  **12 + 21-n/a**) → Aufraeum (**alle 10 Profile validieren Exit 0**) → GO 2 FINAL (das cpp-Codegen-Backend
  ist **DEFAULT**, byte-identisch) → mimalloc-GRENZE (perms-ON-Tree **erstmals volle Suite 216/216**).
  Endstand: ce **`e5946cdb`**, super **`0c34342`**, thesis **`73947aa`**. Verbleibend zu dem Stand: die
  Messlauf-Strecke, das Infra-Handover beim User, und die dossier-entschiedenen gateten Punkte
  (V32-Tilgung, Fork 4/#274, P/E-Core-HW, NUMA-Effekt Multi-Socket, H2-Korrelation).
  NACHZIEH-Vermerk in der `description` (16.07., Audit F51): die **gesamte** GO-1-5-Sequenz ist komplett
  vollzogen (Ledger Z.124 plus §12 07-12 Zyklen III+IV). — dieselbe Datei, 12.07.2026, MESSUNG.

---
## 5. Verweis-Befunde: tote Links, Namensbrueche, Frontmatter-Drift

Die `[[doppelte-eckige-klammern]]` in den Memories sind Verweise. Ein Verweis auf eine Datei, die es nicht
gibt, ist normal (er markiert etwas Schreibenswertes). Ein Verweis auf eine Datei, die es **gibt** und die
**auch unverlinkt** ist, zeigt einen Themen-Cluster.

### 5.1 Echte tote Links (Ziel existiert nicht — geprueft 10.08.2026)

| Verweis-Ziel | Verweist von (Nr. aus Abschnitt 6) | Bemerkung |
|---|---|---|
| `project_active_goal_directive` | Nr. 8 und Nr. 40 | von Nr. 40 selbst am 09.08. als tot erkannt |
| `project_deferred_steuerrater_buildsystem_zenmanagedanalytics` | Nr. 13 | — |
| `reference_188_4b_pool_family_store_traversable_design` | Nr. 37 | — |
| `feedback_verify_ist_state_before_gross_tasks` | Nr. 42 | — |
| `project_comdare_db_maintenance_standard_and_buildsystem_escalation` | Nr. 42 | — |
| `diplomarbeit-impl-j-kette` | Nr. 44 | Bindestriche, existiert in keiner Form |

**Zweite Welle — aus den 49 (gemessen 10.08.2026 ueber alle 153 Wikilink-Vorkommen, 103 eindeutige Ziele):**

| Verweis-Ziel | Verweist von | Bemerkung |
|---|---|---|
| `project_deferred_steuerrater_buildsystem_zenmanagedanalytics` | Nr. 4, Nr. 8 | wie oben, zwei neue Quellen |
| `reference_gitlab_admin_access_keeper_pat_and_transfer_block` | Nr. 96 | — |
| `feedback_token_pat_rotation_new_first_keep_gitlab_github_full_access` | Nr. 96 | — |
| `v41-open-todos-master` | Nr. 78 | in keiner Form vorhanden |
| `axis-gold-standard-checklist` | Nr. 78 | in keiner Form vorhanden |
| `buildsystem-not-cmake` | Nr. 78 | in keiner Form vorhanden |
| `reference-konsolidierungs-masterplan` | Nr. 90 | in keiner Form vorhanden |

Die letzten vier sind Ueberbleibsel der Mai-2026-Ordnung: `reference_cache_engine_standalone_build_pipeline`
und `reference_documentation_master_paths` sind die zwei **aeltesten** der 106 (15.05. bzw. 28.05.2026) und
verweisen auf einen Bestand, den es nicht mehr gibt. **Gegenprobe, damit der Nichtfund etwas heisst:** von
denselben 103 Zielen wurden **92 in der Unterstrich-Form am Quellort gefunden**; die Pruefung matcht also.

**Ein Fund, der kein toter Link ist:** die naive Wikilink-Regex `\[\[[^]]+\]\]` liefert zusaetzlich das
"Ziel" `a,b,c` — aus dem Stempel-Ausdruck `[[a,b,c]]CEB` in
`project_bestandslog_abnahmen_baum_heuristik_stempel` (U-29). **Die Ebene-0-Stempel-Notation kollidiert mit
der Wikilink-Syntax des Gedaechtnisses.** Wer Verweise maschinell erhebt, muss `[[a,b,c]]`,
`[[d,e,f],[g,h,i]]` und `[[a,b,c],[d,e,f],[g,h,i]]` ausschliessen — sonst zaehlt er Stempel als Links.

### 5.2 Cluster-Funde: Ziel existiert, ist aber ebenfalls unverlinkt

Diese Dateien werden von den 57 als zentrale Referenzen gebraucht, sind aber selbst nicht im Index
(geprueft 10.08.2026 gegen die Live-`MEMORY.md`):

| Ziel | wie oft aus den 57 referenziert | Thema |
|---|---|---|
| `project_lager_baeume_xlsx_doktrin` | 4x (haeufigstes Ziel ueberhaupt) | xlsx-Lager-Doktrin |
| `feedback_recursive_dock_planer_ceb_tier_abi_stable_so` | 1x | Dock `.so`, ABI-stabil |
| `feedback_standardprozess_research_zu_product_matrix_3d` | 1x | Research → Product |
| `project_cache_engine_research_vs_cacheengine_all_split_todo` | 1x | 286 = Forschung |
| `project_62_planer_universal_cache_log_claim_compare` | 1x | §62 Planer |
| `project_frist_montag_2707_zeitbudget_bau_messen` | 2x | ist selbst eine der 57 |
| `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus` | 1x | ist selbst eine der 57 |

**Achtung:** die ersten fuenf Ziele waren zu Beginn dieser Sitzung noch im Index verlinkt (Index-Schnappschuss
mit den Kurzlabels "Lager-Baeume", "Dock .so", "Products", "286=Forschung", "§62 Planer"). Gegen die
Live-`MEMORY.md` von 07:50 UTC sind sie es **nicht mehr** — sie haengen seither nur noch in
`MEMORY-DETAIL.md` und sind damit **genau die zweite Welle**. Alle fuenf sind inzwischen konsolidiert:
Lager-Baeume → **U-31/U-32**, Dock `.so` → **Q-9/Q-10**, Products → **X-2/X-3**, 286 = Forschung →
**K-10**, §62 Planer → **U-1..U-23**. Damit ist dieser Cluster-Befund **erledigt**, nicht mehr offen.

### 5.3 Namensbrueche (Bindestrich gegen Unterstrich)

**ZEHN** Dateien tragen im YAML-Feld `name:` die **Bindestrich**-Schreibweise, waehrend der Dateiname
Unterstriche fuehrt. (Eine fruehere Fassung dieses Abschnitts nannte **sechs** — die Zahl war **zu klein**;
nachgemessen 10.08.2026 ueber alle 57, Nenner-Gegenprobe: **57 von 57** Dateien haben ueberhaupt eine
`name:`-Zeile, davon **10** mit Bindestrich.)

Je Eintrag zuerst der Dateiname, darunter das `name:` aus dem Frontmatter:

1. `feedback_codex_mcp_schreibrechte_mitgeben`
   → `codex-mcp-schreibrechte-mitgeben`
2. `feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme`
   → `hybrid-tier-stufe-hinter-ceb-variant-ausnahme`
3. `feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende`
   → `stempel-regression-keine-merge-zeile-meta-meta-realm-ende`
4. `feedback_versionierungs_interface_stempel_ct_namensfunktion`
   → `versionierungs-interface-stempel-ct-namensfunktion`
5. `feedback_versions_flag_grammatik_dreistellig_hw_flag`
   → `versions-flag-grammatik-dreistellig-hw-flag`
6. `project_thesis_19_26_22_deferred_until_cluster`
   → `project-thesis-19-26-22-deferred-until-cluster`
7. `reference_ce_jkette_n316_braucht_v32_enable_on`
   → `ce-jkette-n316-braucht-v32-enable-on`
8. `reference_gcc_kern_toolchain_versionen`
   → `gcc-kern-toolchain-versionen`
9. `reference_lokale_vollbau_luecken_falsches_gruen`
   → `lokale-vollbau-luecken-falsches-gruen`
10. `reference_pgrep_warteschleife_selbstmatch_falle`
    → `reference-pgrep-warteschleife-selbstmatch-falle`

Zwei Untermuster: bei Nr. 1-5 und 7-9 faellt der Typ-Praefix (`feedback_` / `reference_`) ganz weg, bei
Nr. 6 wird er mitgezogen (`project` bleibt), und **nur Nr. 10 behaelt den Praefix und ersetzt lediglich die
Unterstriche**. Wer maschinell auf `name:` matcht, braucht also beide Formen.

Derselbe Bruch erzeugt **defekte Verweise**: `[[claude-code-arbeitsweise-v2-konsolidiert]]` (gemeint ist
`feedback_claude_code_arbeitsweise_v2_konsolidiert`), `[[behauptungen-verifizieren-layer-vertraege-halten]]`,
`[[cache-engine-standalone-build-pipeline]]`, `[[no-success-marks-without-literal-output]]`,
`[[goal-hook-thorough-read-in-never-guess]]`, `[[hardware-erkennung-factory-laufzeit-nie-statisch]]`,
`[[hybrid-tier-stufe-hinter-ceb-variant-ausnahme]]`,
`[[stempel-regression-keine-merge-zeile-meta-meta-realm-ende]]` — die Ziele existieren jeweils in der
Unterstrich-Form.

**Zweite Welle — fuenf weitere Namensbrueche unter den 49** (gemessen 10.08.2026; Gegenprobe: **49 von 49**
haben eine `name:`-Zeile, davon **6** abweichend — fuenf davon Bindestrich-Brueche):

1. `reference_cache_engine_standalone_build_pipeline` → `cache-engine-standalone-build-pipeline`
2. `reference_documentation_master_paths` → `reference-documentation-master-paths`
3. `reference_drift_guard_faengt_anhaengen_nicht` → `drift-guard-faengt-anhaengen-nicht`
4. `reference_git_immer_mit_c_pfad_cwd_falle` → `git-immer-mit-c-pfad-cwd-falle`
5. `reference_xml_kommentar_doppelbindestrich_falle` → `xml-kommentar-doppelbindestrich-falle`

Damit sind es ueber beide Wellen **15** Namensbrueche. Alle fuenf neuen sind `reference_`-Dateien, und bei
vier von fuenf faellt der Praefix weg (nur Nr. 2 zieht ihn mit) — dasselbe Untermuster wie oben. Die daraus
entstandenen defekten Verweise aus den 49: `[[lokale-vollbau-luecken-falsches-gruen]]` (2x),
`[[no-success-marks-without-literal-output]]` (3x), `[[ascii-only-comments-and-selfcheck-line]]`,
`[[feedback-never-delete-documentation]]` — **alle vier Ziele existieren in der Unterstrich-Form**, sie
sind nur unter dem falschen Namen adressiert.

### 5.4 Typ-Diskrepanz Dateiname gegen Metadaten

`reference_codex_null_junk_artifact_ignore.md` und `reference_codex_routing_block_preamble_fix.md` tragen
den Praefix `reference_`, aber `metadata.type: feedback`.

**Zweite Welle — ein schwererer Fall.** `feedback_prt_art_consumes_cache_engine.md` bricht das Schema
gleich zweifach (gemessen 10.08.2026):

- Das Feld `name:` traegt **keine Kennung, sondern einen Satz**:
  `name: PRT-ART hat DREI Rollen gleichzeitig, nicht eine`. Alle uebrigen 105 Dateien tragen dort eine
  id-artige Zeichenkette.
- Der Metadaten-Block ist **nicht unter `metadata:` verschachtelt** — `type`, `originSessionId` und
  `modified` stehen flach auf oberster Ebene. **Gegenprobe:** von den 49 ist dies die **einzige** Datei
  ohne `metadata:`-Zeile (`grep -q "^metadata:"` schlaegt bei genau einer fehl).

Wer den Bestand maschinell nach `metadata.type` gruppiert, verliert diese Datei still — und sie ist die
Datei, die die **drei Rollen von PRT-ART** traegt (Q-14). Sie ist zugleich die **juengste** der 106
(`modified: 2026-08-10T06:50:30Z`, also am Tag dieser Konsolidierung geschrieben).

### 5.5 Frontmatter aelter als der Fliesstext

Vier Faelle, in denen die `description:` den gewachsenen Fliesstext nicht mehr deckt — bei Widerspruch gilt
der Fliesstext:

| Datei | `description:` sagt | Fliesstext reicht bis |
|---|---|---|
| `project_20260727_vormittag_o8_fenster_lage` | "Lage-Anker 27.07. vormittag" | **02.08. ~00:xx** (6 Tage weiter) |
| `reference_ci_trace_parsing_commit_titel_falle` | "2x real am 27.07." | 17 gelabelte Fallen bis 02.08. |
| `reference_lokale_vollbau_luecken_falsches_gruen` | "Verifiziert 2026-07-26" | zwei Nachtraege vom 27.07. |
| `feedback_atlas_immer_korpus_gegenpruefung` | nur die 05.08.-Regel | Verschaerfung vom 06.08. |
| `reference_ce_jkette_n316_braucht_v32_enable_on` | "N=316 nur mit V32=ON" | Nachtrag 03.08. widerspricht (W-09) |

**Zweite Welle — drei weitere Faelle, einer davon ein abgeschnittenes Feld:**

1. **`reference_diplom_finale_linie_identitaet_overleaf`** — `description:` sagt "**OFFEN:**
   overleaf-Gabelung mergen (github-main `c2d3c51e` **18** Commits vs gitlab-dev `ef448e4b` 9)";
   der Fliesstext sagt "**GABELUNG GELOEST (01.08.)**" mit github/main auf `683476a`, **22** unique,
   Merge-Commit `06ac320`.
2. **`project_lager_baeume_xlsx_doktrin`** — `description:` sagt "xlsx=Default …, **CSV=Factory-Fallback**";
   der Fliesstext traegt die 05.08.-XOR-Strategy und darueber den 09.08.-Nachtrag "**auch beide zusammen
   waehlbar**" (U-32).
3. **`reference_ci_runner_ice_cold_cache_instability`** — das `description:`-Feld bricht **mitten im Satz
   ab**; der Fliesstext traegt die volle Diagnose samt "WURZEL BEHOBEN" (A-10).

Der erste Fall ist der teuerste: **die `description:` behauptet als OFFEN, was der Fliesstext derselben
Datei als GELOEST fuehrt — samt widersprechender Commit-Zahl (18 gegen 22) und widersprechendem SHA
(`c2d3c51e` gegen `683476a`).** Wer nur die Kurzfassung liest, haelt einen erledigten Merge fuer offen.

Der dritte Fall ist ein **Datenschaden im Frontmatter**, nicht nur Drift — das Feld lautet woertlich und
vollstaendig: `description: g++-ICE-Segfaults auf Cold-Cache-Builds = transiente Runner-Instabilitaets-`
`Episode (Infra` — es bricht **mitten im Wort/Satz ab, mit offener Klammer und ohne Anfuehrungszeichen**.
Wer den Bestand per YAML-Parser liest, bekommt hier je nach Parser einen Fehler oder einen Torso.

### 5.6 Session-Cluster (`originSessionId`)

- **`46375cdc-821a-4bf9-93d4-fe0a5687f489`** — mindestens **10** der 57: der durchgehende
  CI-/Build-Verifikationsstrang 07.07. bis 03.08.2026 (Trace-Parsing, GitLab-API, lokale Vollbau-Luecken,
  Template-Redeploy, Aufraeumpass). Nie indexiert.
- **`78cf67f8-571e-4fcd-a907-1556dbc5be72`** — **7** der 57: der Codex-Workflow-Cluster
  (Erstimplementierung → Review-Pflicht → manueller Volltext-Review → Unsicherheits-Fallback →
  Explore-Pairing → Junk-Datei → Routing-Fix).
- **`5a19728e-f6e1-4736-a246-e3fda9ac35a1`** — **6** der 57, alle owner-nah und abgabe-nah (06.08.2026):
  Schreibrechte, Paketschnitt, Versionierungs-Interface, gcc-KERN, rescue-Ref, Submodul-Zeiger.
  **Dieses Praefix ist identisch mit der Job-ID dieses Konsolidierungsauftrags** (`jobs/5a19728e/`).

**Zweite Welle — die 49 sind fast EIN Cluster** (vollstaendig ausgezaehlt 10.08.2026, Nenner 49 von 49):

| `originSessionId` | Anzahl der 49 | Was darin liegt |
|---|---|---|
| **`46375cdc-821a-4bf9-93d4-fe0a5687f489`** | **39** | Kette, Registries, Lager, Achsen, Matrix, VLAN |
| `c6f15797-7fa1-4e66-874f-55631afe1d28` | 3 | C++/Drogon · Baseline in Stein · 286 = Forschung |
| `78cf67f8-571e-4fcd-a907-1556dbc5be72` | 3 | Standalone-Build · Mojibake · geloeschte Spiegel |
| `3d9bd0e7-eeb3-411a-b116-64eef696e0f6` | 2 | PRT-ART drei Rollen · Doku-Master-Pfade |
| `885d4915-6f41-4b18-9770-e729576e9fee` | 1 | glpat-Regex |
| `34effcef-618b-4cb2-bd80-87d2a502062e` | 1 | prod1-Umgebung |

**Das ist der eigentliche Befund dieser Zaehlung:** `46375cdc` traegt **39 der 49** — und in der ersten
Welle waren es "mindestens 10 der 57". Ueber beide Wellen liegen damit **~49 von 106** unverlinkten Dateien
in **einer einzigen** Session. Diese Session ist der lange CI-/Architektur-/Planungsstrang vom 07.07. bis
05.08.2026; sie hat die Kette, die Registries, das Lager und die Achsen-Neuordnung geschrieben — also den
Grossteil dessen, was heute gebaut wird. **Sie wurde nie in den automatisch geladenen Index gehoben.**

---

## 6. Herkunfts-Tabelle — alle 106 Quelldateien

Gegenprobe: wer eine Datei sucht, findet hier ihren Platz im Dokument. Fehlt eine Datei hier, ist das
Dokument unvollstaendig. Alle Dateien liegen unter
`/home/comdare/.claude/projects/-home-comdare/memory/`. Alphabetisch sortiert; die Spalte **W** nennt die
Welle (1 = die 57 gegen `MEMORY.md`+`MEMORY-DETAIL.md`, 2 = die 49, die nur in `MEMORY-DETAIL.md` haengen).

| # | W | Quelldatei (`.md`) | Fundstelle(n) — Kurz-Thema |
|---|---|---|---|
| 1 | 1 | `feedback_a5_sortierung_key_filter_map_value_filter_achse` | 3.3 (D-1) — Map: Key- und Value-Filter-Achse |
| 2 | 1 | `feedback_abschluss_aufraeumpass_deprecated_code_entfernen` | 3.10 (L-1, L-2) — Aufraeumpass, toter Code |
| 3 | 2 | `feedback_agent_working_tree_freeze_nach_paketmeldung` | 3.10 (L-19) — Commit-Race, `a3dcfea3` |
| 4 | 2 | `feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources` | 3.15 (X-7) — C++/Drogon |
| 5 | 1 | `feedback_always_sync_missing_remotes_except_cluster` | W-19, 3.9 (K-1) — Fehlende Remotes nachziehen |
| 6 | 1 | `feedback_atlas_immer_korpus_gegenpruefung` | 3.10 (L-3, L-4) — Atlas ist vorlaeufig, nie Beweis |
| 7 | 2 | `feedback_autonomie_modus_plan_autonom_durchziehen` | 3.10 (L-9..L-13) — Autonomie-Grant, Reife-Gate |
| 8 | 2 | `feedback_baseline_system_in_stein_gemeisselt_layering` | 3.15 (X-1) — Baseline in Stein, 4 Regeln |
| 9 | 1 | `feedback_berichte_am_prioritaeten_faden` | 3.10 (L-5) — Berichte am Prioritaetenfaden |
| 10 | 2 | `feedback_build_matrix_8_docker_distros_full_platform_doctrine` | W-26, 3.15 (X-11) — 8er-Docker |
| 11 | 2 | `feedback_buildsystem_xml_hands_off_parallel_ci_cmake` | 3.9 (K-11) — `buildsystem.xml` nicht anfassen |
| 12 | 2 | `feedback_ceb_config_cmake_interface_static_registry_paths_prt_module` | W-30, 3.12 (R-4, R-5) |
| 13 | 1 | `feedback_codex_implements_from_dossier_claude_corrects` | 3.2 (B-1..B-7) — Codex-Dossier-Doktrin |
| 14 | 1 | `feedback_codex_mcp_always_newest_model_xhigh` | W-04, 3.2 (C-1) — Modell/Effort, drei Zustaende |
| 15 | 1 | `feedback_codex_mcp_review_before_code_complete` | W-04, 3.2 (C-7) — Cross-Review vor "fertig" |
| 16 | 1 | `feedback_codex_mcp_schreibrechte_mitgeben` | 3.2 (C-2, C-3) — Schreibrechte, git-Timeout |
| 17 | 1 | `feedback_codex_outputs_always_full_manual_review` | 3.2 (C-8) — Volltext-Review Pflicht |
| 18 | 1 | `feedback_codex_uncertain_fallback_to_ultracode` | 3.2 (C-9) — Unsicherheit → ultracode |
| 19 | 1 | `feedback_comdare_db_and_buildsystem_separate_ledgers` | 3.9 (K-2) — Getrennte Ledger |
| 20 | 1 | `feedback_comdare_products_house_buildsystem_mandatory` | W-14, 3.9 (K-3) — Hauseigenes Buildsystem |
| 21 | 1 | `feedback_e14_nofilter_identitaet_und_e4_deep_research` | 3.3 (D-7, D-8) — NoFilter T16, E4/17 T17 |
| 22 | 2 | `feedback_ext_paper_organisation_separates_axes_from_paper_code` | 3.15 (X-10) — ext/-Paper |
| 23 | 1 | `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus` | W-05, 3.2 (B-9, B-10) — Fable-5-xhigh |
| 24 | 2 | `feedback_freeze_nachrichten_eindeutig_nur_antwort_vs_arbeitsauftrag` | 3.10 (L-20) — Freeze-Weckruf |
| 25 | 1 | `feedback_gattung_genus_interface_messparameter_achsen` | W-07, 3.3 (D-2..D-6) — Gattung/Genus, Messkanon |
| 26 | 1 | `feedback_hardware_erkennung_factory_laufzeit_nie_statisch` | 3.5 (F-1..F-4) — HW-Erkennung per Factory |
| 27 | 1 | `feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme` | W-23, 3.4 (E-1, E-2) — Hybrid/variant |
| 28 | 1 | `feedback_implementierung_an_opus_delegieren_fable_als_architekt` | W-05, 3.2 (B-8) — SUPERSEDED 26.07. |
| 29 | 2 | `feedback_incremental_tier_binary_caching` | W-28, 3.1 (A-12), 3.13 (U-33, U-34) — Inkrement-Cache |
| 30 | 2 | `feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs` | 3.10 (L-15) — ultracode/Aufgabe |
| 31 | 2 | `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid` | W-31, 3.11 (Q-1..Q-8) — Kette §30/§38 |
| 32 | 1 | `feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere` | 3.10 (L-6) — Ledger updatebar |
| 33 | 2 | `feedback_no_python_in_buildchain` | 3.15 (X-8) — Kein Python (Talos OS) |
| 34 | 1 | `feedback_pair_explore_with_codex_same_investigation` | W-06, 3.2 (C-10) — Explore-Pairing mit Codex |
| 35 | 1 | `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` | 3.10 (L-7, L-8) — Session-Doc |
| 36 | 2 | `feedback_per_paket_ultracode_planung_vor_ausfuehrung` | 3.10 (L-16) — ultracode je Paket |
| 37 | 2 | `feedback_prt_art_consumes_cache_engine` | 3.11 (Q-14), 5.4 — PRT-ART = drei Rollen |
| 38 | 2 | `feedback_recursive_dock_planer_ceb_tier_abi_stable_so` | 3.11 (Q-9, Q-10) — Rekursive Docks, ABI-`.so` |
| 39 | 2 | `feedback_registry_angebot_anwender_xml_pom_resolver_planer` | W-25, 3.12 (R-1, R-2) — Registry=Angebot |
| 40 | 2 | `feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns` | 3.12 (R-11, R-12) |
| 41 | 2 | `feedback_standardprozess_research_zu_product_matrix_3d` | 3.15 (X-2, X-3) — Matrix 3D, 9 Schritte |
| 42 | 1 | `feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende` | W-16, W-26, 3.4 (E-3, E-4) |
| 43 | 2 | `feedback_task_assignment_not_start_signal_respect_gates_propose_first` | 3.10 (L-18) — kein Startsignal |
| 44 | 2 | `feedback_umbrella_soll_struktur_trackt_alles_ausser_baseline_zellen` | 3.15 (X-4..X-6) — Umbrella-SOLL |
| 45 | 2 | `feedback_unified_experiment_xml_plus_system_registry_xml` | W-25, W-31, 3.12 (R-3, R-13..R-15) |
| 46 | 2 | `feedback_user_kern_beschreibung_ist_immer_gesetz_abweichung_ist_regression` | 3.10 (L-17) — KERN=Gesetz |
| 47 | 2 | `feedback_vendoring_doctrine_ordered_vendor_faithful_selfcontained` | 3.15 (X-9) — Vendoring, drei Stufen |
| 48 | 1 | `feedback_versionierungs_interface_stempel_ct_namensfunktion` | 3.4 (E-5) — F7 Option b |
| 49 | 1 | `feedback_versions_flag_grammatik_dreistellig_hw_flag` | 3.4 (E-6) — `v1.0.0c`, Flag-Position |
| 50 | 2 | `feedback_vor_und_nach_jeder_aufgabe_ultracode_plus_autonomie_scope` | 3.10 (L-14) — VOR+NACH uc |
| 51 | 1 | `project_20260726_chunk_delta_verlorene_owner_antworten` | 3.4, 3.6 (G-8), 4.1 (M-1..M-10) — D-01..D-17 |
| 52 | 1 | `project_20260726_nach_trigger_alle_baender_abarbeiten` | W-01, 3.1 (A-1, A-3..A-5) — 7 Owner-Entscheide |
| 53 | 1 | `project_20260727_vormittag_o8_fenster_lage` | W-02, 3.7 (H-2..H-4), 4.2 (N-1..N-12) — O-8, gitleaks, P9 |
| 54 | 1 | `project_20260804_pause_s5_wellen_landebereit` | 4.3 (O-1, O-2) — S5-Wellen landebereit |
| 55 | 1 | `project_20260805_pause_01c_komplett_vor_phase_b` | 4.3 (O-3..O-11) — Stufen-Doktrin, Dual-Review |
| 56 | 2 | `project_62_planer_universal_cache_log_claim_compare` | W-22, W-24, W-28, 3.1 (A-8f), 3.13 (U-1..U-23) |
| 57 | 2 | `project_achsen_neuordnung_bindende_sortierung_regressionen` | W-03, W-21, W-23, 3.7 (H-16f), 3.14 (V-*) |
| 58 | 1 | `project_bep_abt_session_stand_20260705` | W-10, 4.4 (P-1..P-5) — Setup #2, #258, S7-Serie |
| 59 | 2 | `project_bestandslog_abnahmen_baum_heuristik_stempel` | 3.13 (U-24..U-29), 3.14 (V-16), 5.1 |
| 60 | 2 | `project_bestandslog_zielbild_ordner_kaskaden_dual_ccache` | W-28, 3.13 (U-30) — Dual-ccache |
| 61 | 2 | `project_cache_engine_research_vs_cacheengine_all_split_todo` | 3.9 (K-10) — 286 = Forschung, Split-TODO |
| 62 | 2 | `project_diplomarbeit_modules_mirrors_deleted_reuse_comdare_modules` | 3.9 (K-9, K-10) — 6 Spiegel weg |
| 63 | 1 | `project_diplomarbeit_stand_20260706_comdare_prod1` | W-13, 4.4 (P-6, P-7) — Migration comdare@prod1 |
| 64 | 1 | `project_diplomarbeit_stand_20260712_freigaben_pipeline` | W-01, 3.1, 4.4 (P-8, P-9) — GO 1-5, 2→3 |
| 65 | 1 | `project_diplomarbeit_stand_20260717_volles_go_bau_roadmap` | W-03, W-13, 3.7 (H-11, H-12) — INC-0..INC-2 |
| 66 | 1 | `project_e18_snapshot_ordner_und_graph_darstellung_kerne` | 3.6 (G-3..G-5) — E18-Snapshot, 2D/3D-Graphen |
| 67 | 1 | `project_frist_montag_2707_zeitbudget_bau_messen` | W-12, 3.7 (H-13) — Zeitbudget 2+2 Tage |
| 68 | 1 | `project_handout_ap1_15_code_nachzug_audit_20260702` | 3.7 (H-7..H-10) — AP-1..AP-15, T0 21→22 |
| 69 | 2 | `project_lager_baeume_xlsx_doktrin` | 3.13 (U-31, U-32), 5.5 — Zwei Lager-Baeume, xlsx |
| 70 | 1 | `project_lager_basis_tests_dummy_strategien_stempel` | 3.6 (G-1, G-2) — Zwei Dummy-Stempel-Strategien |
| 71 | 2 | `project_planer_mess_schema_kern_pruefling_replace_merge_fulljoin` | 3.12 (R-6..R-10) — Mess-Schema |
| 72 | 2 | `project_post_v3_anforderungen_so_abi_driver_split_cli` | W-30, 3.11 (Q-11..Q-13) — R1/R2/R3 |
| 73 | 1 | `project_struktur_regression_geteilte_klone_statt_instanz_repos` | W-18, 3.9 (K-4) — Klon-Regression |
| 74 | 1 | `project_thesis_19_26_22_deferred_until_cluster` | W-11, 3.5 (F-5..F-7) — #19/#22/#26, PMC-Umkehr |
| 75 | 1 | `reference_alt_mess_csv_archiv_struktur_modernisierung` | 3.6 (G-6, G-7) — Alt-CSV = Archiv, Reader |
| 76 | 1 | `reference_buildsystem_scripts_posix_no_grep_p` | 3.8 (I-1) — `grep -P` stille Null |
| 77 | 1 | `reference_buildsystem_xml_grep_parsed_not_strict_xml` | 3.8 (I-2) — XML literal, nicht escapen |
| 78 | 2 | `reference_cache_engine_standalone_build_pipeline` | 3.7 (H-18), 3.9 (K-12), 5.1, 5.3 — Standalone-Bau |
| 79 | 1 | `reference_ce_jkette_n316_braucht_v32_enable_on` | W-09, 3.7 (H-5, H-6), 5.3 — Gate 312..331 |
| 80 | 2 | `reference_ci_runner_ice_cold_cache_instability` | 3.1 (A-10, A-11), 5.5 — ICE, prod2-Wurzel, 36 % |
| 81 | 1 | `reference_ci_template_redeploy_sauberkeit_nicht_clobbern` | 3.9 (K-5) — v7.0.4, Token-Rotation |
| 82 | 1 | `reference_ci_trace_parsing_commit_titel_falle` | W-17, W-20, 3.8 (I-6..I-8) — 17 Fallen + Abhilfe |
| 83 | 2 | `reference_cluster_vlan_tabelle_sni_standard_pattern` | 3.16 (Y-1, Y-2) — VLAN-Tabelle, SNI-Pattern |
| 84 | 1 | `reference_codex_mcp_prod1_bwrap_shell_broken` | W-15, 3.2 (C-4) — bwrap/AppArmor defekt |
| 85 | 1 | `reference_codex_null_junk_artifact_ignore` | 3.2 (C-6), 5.4 — `$null` ignorieren |
| 86 | 1 | `reference_codex_routing_block_preamble_fix` | W-15, 3.2 (C-5), 5.4 — §8-STOPP, `CODEX_HOME`-Fix |
| 87 | 2 | `reference_codex_utf8_mojibake_double_encoding` | 3.2 (C-11) — Mojibake, cp1252 zuerst |
| 88 | 2 | `reference_desktop_plain_backup_diplomarbeit` | 3.16 (Y-3) — Plain-Backup, cron 15 min |
| 89 | 2 | `reference_diplom_finale_linie_identitaet_overleaf` | 3.9 (K-8), 5.5 — Finale HEADs, Identitaet |
| 90 | 2 | `reference_documentation_master_paths` | W-32, 3.9 (K-13), 5.1, 5.3 — Doku-Master-Pfade (tot) |
| 91 | 2 | `reference_drift_guard_faengt_anhaengen_nicht` | 3.8 (I-21), 5.3 — Drift-Wache faengt nicht |
| 92 | 1 | `reference_gcc_kern_toolchain_versionen` | 3.7 (H-1), 5.3 — gcc 15.3, Obergrenze 16 |
| 93 | 2 | `reference_git_immer_mit_c_pfad_cwd_falle` | 3.8 (I-19), 5.3 — `git -C`, CWD-Falle |
| 94 | 2 | `reference_gitlab_de_abgeschaltet_local_kanonisch_scoped_ca` | W-29, 3.9 (K-6) — .de tot |
| 95 | 1 | `reference_gitlab_jobs_api_zeigt_keine_bridges` | 3.8 (I-4) — Bridges nur ueber `/bridges` |
| 96 | 2 | `reference_gitlab_pat_format_dots_regex` | W-29, 3.8 (I-22), 5.1 — glpat-Regex mit Punkt |
| 97 | 1 | `reference_gitlab_pipelines_api_sha_vollform` | 3.8 (I-5) — `?sha=` nur 40 Zeichen |
| 98 | 1 | `reference_gruene_tests_zementieren_alte_ordnung` | 3.8 (I-16) — Fixtures, dritter Ableitungsweg |
| 99 | 2 | `reference_infra_agent_memory_handover_322_location` | 3.16 (Y-4) — 322 Infra-Memories |
| 100 | 1 | `reference_lokale_vollbau_luecken_falsches_gruen` | W-08, 3.8 (I-9..I-15), 5.3 — all-Ziel-Luecken |
| 101 | 2 | `reference_main_ff_watcher_pin_sha_nicht_rev_parse_head` | 3.8 (I-23) — main-FF: SHA pinnen |
| 102 | 1 | `reference_pgrep_warteschleife_selbstmatch_falle` | 3.8 (I-3), 5.3 — `pgrep -f` matcht sich selbst |
| 103 | 2 | `reference_prod1_comdare_env_setup` | W-27, W-33, 3.2 (C-12), 3.7 (H-14, H-15), 3.9 (K-7) |
| 104 | 1 | `reference_rescue_ref_ist_keine_landung` | 3.8 (I-17) — gruen != gelandet |
| 105 | 1 | `reference_submodul_zeiger_kann_rueckwaerts_zeigen` | 3.8 (I-18) — `M` heisst nicht "neuer" |
| 106 | 2 | `reference_xml_kommentar_doppelbindestrich_falle` | 3.8 (I-20), 5.3 — XSD-Kommentar `--` |
**Zeilen in dieser Tabelle: 106 von 106 — 57 aus Welle 1, 49 aus Welle 2. Keine Datei fehlt.**
Gegenprobe der Aufteilung: **50** `feedback_*` (25 + 25) · **24** `project_*` (15 + 9) · **32**
`reference_*` (17 + 15) = **106**.

**Nachtrag 10.08.2026 — Buchstaben-Suffixe.** Die Nachtragspruefung hat einzelne Fakten ergaenzt, ohne die
laufende Nummerierung zu verschieben (ein zweiter Strang schrieb gleichzeitig am selben Dokument). Diese
Fakten tragen ein Buchstaben-Suffix und stehen jeweils unmittelbar hinter ihrem Basis-Fakt:

| Kennung | Abschnitt | Quelldatei (Nr.) | Gegenstand |
|---|---|---|---|
| **D-2a** | 3.3 | 16 | Ableitung: Achsen als Bausteine, Gattungs-/Genus-Kern |
| **F-1a** | 3.5 | 17 | PRAEZISIERUNG: Plattform-Familie, Passungs-Stempel |
| **I-6a** | 3.8 | 46 | ROBUSTE FORM (a)-(d) — die Abhilfe zur Trace-Falle |
| **I-6b** | 3.8 | 46 | Seed-/Neustart-Stummschaltung: nur Zustand, nie Befund |
| **I-7a** | 3.8 | 46 | Falle (o) ausgeschrieben, `started_at`-Belegregel |
| **I-7b** | 3.8 | 46 + 28 | PAT-Position mit Historie (1./2. von hinten, 7 Kandidaten) |
| **H-3a** | 3.7 | 28 | `gitleaks`-0-Bytes (P9): `3d6cbec` gegen Pipeline 13526 |
| **N-1a** | 4.2 | 28 | Die sechs Infra-Handouts, darunter P9 |
| **N-4a** | 4.2 | 28 | D3-Paket-Inhalt inkl. zentraler `gitleaks`-Basis |

---

## 7. Selbstpruefung und Grenzen dieses Dokuments

### 7.1 Was geprueft wurde

- Die 57 Dateinamen stammen aus den Bandlisten `jobs/5a19728e/tmp/band_00` … `band_03`
  (15 + 13 + 14 + 15 = 57), dedupliziert: **57 eindeutig**.
- **Alle 57 existieren** auf der Platte (Existenzpruefung je Datei, 0 fehlend).
- Gesamtgroesse **191413 Byte** = 191 KB (dezimal) bzw. 186,9 KiB.
- **Alle 57 sind in der Herkunfts-Tabelle vertreten** (Abschnitt 6, Zeilen 1-57).
- Von den 57 ist zum Zeitpunkt des Schreibens **keine einzige** im Index verlinkt (Gegenprobe je
  Basisname gegen die Live-`MEMORY.md`).
- Load-bearing Zitate (concurrency=1, "2→3", "19 Organ-Achsen", `gpt-5.6-sol`/ULTRA, PMC-Umkehr,
  Versionsgrammatik, gcc-KERN, `allow_failure`, "NIE 453/453") wurden **einzeln am Quelltext**
  nachgeschlagen, nicht aus den Zwischenextrakten uebernommen.

**Vollstaendigkeits-Stichproben (10.08.2026) — beide Zahlen, damit die Dunkelziffer schaetzbar wird.**
Die Frage je Datei: steht **jeder harte Fakt** (Zahl, Pfad, SHA, Datum, Owner-Wort, Regel-Abhilfe) im
Dokument? Zwei unabhaengige Ziehungen:

| Ziehung | gezogen | vollstaendig | mit HARTEM Verlust | mit kleinem Verlust |
|---|---|---|---|---|
| 1. Ziehung (Pruefer) | 5 | 3 | **2** | — |
| 2. Ziehung (`/dev/urandom`, aus den restlichen 54) | 5 | 0 | **1** | 4 |
| **Summe geprueft** | **10** | 3 | **3** | 4 |

Dazu kam in der 1. Ziehung **ein Fund ausserhalb der Stichprobe**
(`project_20260727_vormittag_o8_fenster_lage`, S-3 `gitleaks`), also **11 Dateien mit belegtem Befund oder
Freispruch**. Die 2. Ziehung erfolgte **mechanisch** (`od -An -N4 -tu4 < /dev/urandom`, Modulo auf die
54 nicht schon geheilten Dateien) — ausdruecklich nicht nach Erwartung, weil eine Auswahl nach Gefuehl genau
die Dateien zieht, die man ohnehin fuer vollstaendig haelt.

Die fuenf der 2. Ziehung, je mit Befund und Heilungsort:

1. `reference_ce_jkette_n316_braucht_v32_enable_on` — **HARTER Verlust.** Er fuehrte auf einen
   **Zahlenfehler dieses Dokuments**: Abschnitt 5.3 nannte **sechs** Bindestrich-`name:`-Dateien,
   gemessen sind es **zehn** (Gegenprobe: 57/57 haben eine `name:`-Zeile). Zusaetzlich fehlten die
   vorgeschriebene **Meldeform** ("n=1 ctest-Eintrag mit 8 Faellen", jetzt in H-5), die **Org18-Referenz**
   und die Quelle des 03.08.-Nachtrags (`FAHRPLAN:42-53`, jetzt in W-09).
2. `feedback_comdare_db_and_buildsystem_separate_ledgers` — **Abschriftsfehler plus Auslassung.** Das
   Dokument schrieb `comdare-db-configure.sh` als Dateinamen; die Quelle meint die `configure.sh` **im
   comdare-db-Repo**. Zusaetzlich fehlten die Inhaltsklassen, an denen die Trennung ueberhaupt entscheidbar
   ist (Designs / Analysen / M2 / ctest / Build-Fixes / Feature-Stubs). Geheilt in K-2.
3. `reference_codex_null_junk_artifact_ignore` — klein: der Beleg, dass der Loeschversuch real war (**der
   Tool-Call wurde vom User rejected**), und die Verallgemeinerung auf **andere Codex-Junk-Artefakte**.
   Geheilt in C-6.
4. `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` — klein: zwei traegende Saetze der Quelle
   ("Die Arbeit war sogar gebaut; verloren war die Buchfuehrung." und "Eine Suche in der Sprache des
   Suchenden statt in der des Dokuments findet Abwesenheit, wo Anwesenheit ist."). Geheilt in L-7/L-8.
5. `reference_buildsystem_xml_grep_parsed_not_strict_xml` — klein und **kein** echter Faktenverlust: die
   Parser-Dateien `xml_parser.sh` / `dependency_resolver.sh` standen bereits in I-1, nur die Identitaet
   "I-1 und I-2 meinen denselben Parser" fehlte. Geheilt in I-2.

**Ein weiterer Fund ausserhalb beider Stichproben**, gemacht durch eine gezielte Suche statt durch Ziehung:
nachdem die Kuerzungs-Regel (7.3) feststand, wurde das **ganze Dokument auf "[…]" in Owner-Zitaten**
durchsucht. Treffer: **F-1** in `feedback_hardware_erkennung_factory_laufzeit_nie_statisch` (Nr. 17). Dort
sind **zwei** Dinge zu trennen — und die Trennung ist der eigentliche Wert des Fundes:

- Das "[...]" **mitten** im Zitat stammt aus der **Quelldatei selbst**. Es ist nicht heilbar; was dort
  fehlt, steht nur noch im Roh-Transkript vom 27.07. Das ist als offener Posten in F-1 vermerkt.
- Die **Schluss-Worte** "um Hardware zu erkennen" hatte dagegen **dieses Dokument** abgeschnitten — heilbar
  und geheilt. Ebenso fehlten der Status **"gilt als SCHON-IMMER-Gesetz"** (die Direktive ist rueckwirkend
  bindend, nicht ab Datum), die ganze **PRAEZISIERUNG** mit Plattform-Familie und **Passungs-Stempel als
  Fehlerklasse** (jetzt F-1a), die `declared-only`-Regel und die Lehre "Owner-Korrekturen exakt auf die
  BENANNTE Fassung beziehen" (jetzt in F-3), sowie die Recherche-Grundlage **Research-HWDetect-Bericht**.

**Was die Zahlen sagen:** 3 von 10 gezogenen Dateien trugen einen harten Verlust, 7 von 10 mindestens etwas;
die 11. Datei (Nr. 17) kam per gezielter Suche hinzu und trug ebenfalls Verluste. Die Quote **sinkt nicht**
mit der Stichprobengroesse — es ist also **damit zu rechnen, dass unter den verbleibenden Dateien weitere
Verluste liegen**. Eine Vollpruefung aller Quelldateien gegen dieses Dokument steht aus; sie ist der einzige
Weg, die Dunkelziffer auf null zu bringen. **Der billigste naechste Schritt** ist die gezielte Suche, die
Nr. 17 gefunden hat: nach Kuerzungszeichen, nach fehlenden Abhilfen zu vorhandenen Befunden, und nach
Zahlwoertern im Fliesstext ("sechs Dateien", "drei Faelle"), die gegen den Bestand nachzuzaehlen sind.

### 7.1b Die zweite Welle (die 49) — Erhebung, Gegenproben, ungleiche Pruefschaerfe

**Erhebung, mit dem literalen Befehl** (10.08.2026, alle Zahlen aus der Ausgabe, nicht geschaetzt):

    D=/home/comdare/.claude/projects/-home-comdare/memory
    /usr/bin/grep -oE "\(([A-Za-z0-9_.-]+\.md)\)" $D/MEMORY.md | tr -d "()" | sort -u > /tmp/idx.txt
    cat $D/MEMORY.md $D/MEMORY-DETAIL.md | /usr/bin/grep -oE "\(([A-Za-z0-9_.-]+\.md)\)" \
      | tr -d "()" | sort -u > /tmp/beide.txt
    ls $D/*.md | xargs -n1 basename | sort -u > /tmp/vorhanden.txt
    comm -13 /tmp/idx.txt /tmp/beide.txt            # -> 49
    comm -13 /tmp/idx.txt /tmp/vorhanden.txt        # -> 107, davon MEMORY.md selbst = 106 echte
    comm -13 /tmp/beide.txt /tmp/vorhanden.txt      # -> 58, davon MEMORY.md selbst = 57 echte

Ausgabe: `idx` **179** · `beide` **228** · `vorhanden` **286**. **Die 49 sind exakt 49** — die Zahl des
Auftrags ist am Objekt bestaetigt, nicht uebernommen. Die beiden "+1"-Korrekturen sind `MEMORY.md` selbst,
das in keiner der beiden Index-Dateien verlinkt ist; `MEMORY-DETAIL.md` **ist** von `MEMORY.md` verlinkt und
faellt deshalb aus keiner Liste. Damit: **284 echte Memories, 178 verlinkt, 106 unverlinkt.**

**Was an den 49 geprueft wurde:**

- **Alle 49 vollstaendig gelesen** (nicht ausschnittweise; Gesamtgroesse **171027 Byte** = 171 KB /
  167,0 KiB). Der Umfang beider Wellen zusammen: **362440 Byte** ueber 106 Dateien.
- **Alle 49 sind in der Herkunfts-Tabelle vertreten.** Gegenprobe maschinell: die Dateinamen-Spalte der
  Tabelle wurde extrahiert und gegen die erhobene 106er-Menge `diff`t — **identisch, 0 Abweichungen in
  beide Richtungen**. Aufteilungs-Gegenprobe: 50 `feedback_*` + 24 `project_*` + 32 `reference_*` = 106.
- **Datierung am Objekt:** je Datei `modified`-Feld **und** Datei-System-mtime erhoben. **22 der 49 tragen
  ein `modified`-Feld, 27 nicht** — bei diesen 27 ist die mtime die einzige Datierung. Genau daran haengt
  **W-27**: `reference_prod1_comdare_env_setup` hat kein `modified`, mtime **2026-07-05 22:47:41**, wurde
  also seit dem 05.07. nicht angefasst — das datiert den bwrap-Bruch neu.
- **Verweis-Erhebung maschinell:** 153 Wikilink-Vorkommen, **103 eindeutige Ziele**, davon **92 am
  Quellort gefunden** und **11 tot** (Abschnitt 5.1). Der Nenner steht dabei, damit der Nichtfund etwas
  heisst.
- **Drei Existenz-Gegenproben am Objekt**, weil die betroffenen Dateien Behauptungen ueber die Platte
  aufstellen: (1) `~/Desktop/DIPLOMARBEIT-PLAIN-BACKUP/LAST-SYNC.txt` = **2026-08-10 08:45:02** plus
  vorhandener crontab-Eintrag → **Y-3 gilt**. (2) `"…/Diplomarbeit - Datenbanken"` → **existiert nicht**,
  Gegenprobe `…/docs/termine` → **existiert** → **W-32**. (3) `find /home/comdare -iname prt_art.hpp` →
  **0 Treffer**, bestaetigt die Behauptung in Q-14.

**Ungleiche Pruefschaerfe — ausdruecklich benannt.** Die 57 der ersten Welle sind durch **zwei
Zufallsstichproben plus eine gezielte Suche** gegangen (Abschnitt 7.1) und haben dabei **3 harte und 4
kleine Verluste** offengelegt. **Die 49 der zweiten Welle sind NICHT von einem zweiten Leser geprueft
worden.** Sie wurden von einem Leser vollstaendig gelesen und uebertragen — genau die Ausgangslage, in der
die erste Welle sich fuer vollstaendig hielt und es zu 30 % nicht war. **Es ist damit zu rechnen, dass auch
unter den 49 Verluste liegen.** Der billigste naechste Schritt ist derselbe wie oben: eine mechanische
Ziehung (`od -An -N4 -tu4 < /dev/urandom`, Modulo 49) von 5 Dateien, je gegen den Volltext gelesen, plus
die gezielte Suche nach Kuerzungszeichen und nach Zahlwoertern im Fliesstext, die gegen den Bestand
nachzuzaehlen sind.

### 7.2 Was dieses Dokument NICHT abdeckt

**Der Auftrag nannte zuerst 57 unverlinkte Dateien; erfasst sind jetzt alle 106.** Die 57 der ersten Welle
sind vollstaendig enthalten, die 49 der zweiten ebenfalls (Abschnitt 7.1b). Was bleibt, ist **kein
Bestands-, sondern ein Zeit-Vorbehalt**: die Zahl 106 ist eine Momentaufnahme gegen `MEMORY.md` in der
Fassung **17274 Byte, mtime 2026-08-10 07:50:20 UTC**. Jede spaetere Kuerzung des Index laesst weitere
Dateien herausfallen; jede Neuanlage einer Memory-Datei ohne Index-Zeile erzeugt eine neue unverlinkte.
**Der Bestand ist jederzeit neu zu erheben** — der Befehl steht in 7.1b und liefert die Zahl in einer Zeile.

**Was ausdruecklich NICHT geschehen ist und nicht geschehen soll:** die 49 wurden **nicht** in den Index
zurueckgeschrieben. Der Owner-Auftrag lautet woertlich "**dann verlinke nur die Konsolidierung wieder in
den index**" — eine Zeile, nicht 106. Die Auslagerung nach `MEMORY-DETAIL.md` bleibt als Zwischenstand
bestehen und ist damit **doppelt abgesichert**: wer sie liest, findet die Kurzlabels; wer sie nicht liest,
findet die Fakten hier.

**Der offene strukturelle Posten:** solange `MEMORY.md` ein Byte-Limit hat und der Bestand waechst, ist
jedes weitere Wachstum ein Kandidat fuer denselben Vorgang. Die Frage, **ob der Index ueberhaupt der
richtige Traeger fuer 284 Eintraege ist** — oder ob er auf die Wurzel-Themen schrumpfen und auf
Konsolidierungsdokumente wie dieses verweisen sollte — ist eine Owner-Entscheidung und wird hier
**nicht** getroffen, nur benannt.

### 7.3 Weitere Grenzen

- **Quellenklassen:** nur die 106 Memory-Dateien. Keine `docs/sessions/*`, kein Ledger, keine Dossiers,
  keine Backups, keine Roh-Transkripte (siehe Abschnitt 1). Das faellt an mehreren Stellen ins Gewicht:
  W-22 (Notation "32T/24K") und F-1 (die "[...]"-Kuerzung in der Quelle) sind **nur am Roh-Transkript**
  aufloesbar, und die OD-Runde vom 26.07. verweist selbst auf drei `super docs/sessions/`-Dokumente, die
  die Voll-Doku tragen.
- **Ungleiche Pruefschaerfe zwischen den Wellen:** die 57 sind stichprobengeprueft, die 49 nicht
  (Abschnitt 7.1b). Wer einen Fakt aus 3.11-3.16 gegen etwas Teures haelt, liest die Quelldatei nach.
- **Nicht am Objekt verifiziert:** die Fakten sind aus den Memories uebernommen, nicht gegen den heutigen
  Code-/CI-Stand geprueft. Wo eine Datei selbst schon "am Objekt belegen, nicht annehmen" sagt (G-2), gilt
  das weiter.
- **Herkunftsklassen sind nicht gleichwertig:** eine AGENTEN-BEHAUPTUNG in diesem Dokument bleibt eine
  Behauptung, auch wenn sie hier ordentlich formatiert steht.
- **Die W-Nummern dieses Dokuments sind keine Autoritaetsbelege** — sie sind eine Zaehlung dieses Dokuments,
  keine Owner-Nummerierung (vgl. Index: "OV-NUMMERN sind KEIN Autoritaetsbeleg").
- **KEINE "[…]"-Kuerzung in Owner-Zitaten** — die Regel steht hier, weil sie an D-2 erkauft wurde: dort
  hatte eine "[…]" zwei Owner-Saetze verschluckt, darunter den einzigen, der das **einheitliche
  Achsen-Interface** an diesen KERN bindet. Wer kuerzt, entscheidet **still**, welcher Teil unwichtig ist,
  und die Entscheidung ist spaeter nicht mehr sichtbar. Ein Owner-Satz wird **vollstaendig** uebernommen
  oder gar nicht. Fuer Nicht-Owner-Text (Ableitungen, Agenten-Notizen) bleibt Kuerzen zulaessig, dann aber
  mit ausgewiesener Herkunftsklasse.
- **Eine Abhilfe gehoert zu jedem Befund.** Zweite Lehre aus der Pruefung (Fall I-6): das Dokument hatte die
  Trace-Parsing-**Falle** vollstaendig, aber die in der Quelle als "ROBUSTE FORM (bewaehrt)" gefuehrte
  **Gegenmassnahme** gar nicht. Ein konsolidierter Befund ohne seine Abhilfe ist nur halb konsolidiert —
  beim naechsten Auftreten wird die Massnahme neu erfunden statt nachgeschlagen.

### 7.4 Was jetzt in den Index gehoert

Genau **eine** Zeile, gemaess Owner-Auftrag ("dann verlinke nur die Konsolidierung wieder in den index").
Vorschlag fuer den Abschnitt "Stand/Fallen" oder einen eigenen Punkt:

    - **[106 unverlinkte Memories, konsolidiert](<PFAD>/20260810-KONSOLIDIERUNG-unverlinkte-memories.md)**
      — 33 Widersprueche vorn, Fakten thematisch, Herkunfts-Tabelle 106/106; Quelldateien bleiben liegen

Der genaue Pfad ist beim Setzen an den Ort anzupassen, an dem das Dokument am Ende gelandet ist
(Arbeitsstand: `/home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md`).

