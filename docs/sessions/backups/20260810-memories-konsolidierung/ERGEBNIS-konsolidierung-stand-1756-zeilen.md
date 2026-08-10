# Konsolidierung der unverlinkten Memories

**Erstellt:** 10.08.2026 · **Auftrag (Owner, woertlich, 10.08.2026):**
"Bitte konsolidiere alle unverlinkten memories mit ultracode als Planungsdokument in die Diplomarbeit,
sodass wir die hinten rausgefallenen Fakten weiterhin zugreifen koennen, dann verlinke nur die
Konsolidierung wieder in den index"

## 1. Warum es dieses Dokument gibt

Das Gedaechtnis-Verzeichnis `/home/comdare/.claude/projects/-home-comdare/memory/` trug bei der Erhebung
**286 Memory-Dateien** (der Auftrag nennt 284; zwei kamen im Lauf des 10.08. hinzu). Gelesen wird davon nur,
was der Index `MEMORY.md` verlinkt — der Index ist die einzige Datei, die automatisch in den Kontext kommt.

**Gemessen am 10.08.2026 gegen `MEMORY.md` (17274 Byte, mtime 2026-08-10 07:50:20 UTC):
57 Dateien sind in KEINER Index-Zeile verlinkt. Sie umfassen 191413 Byte (191 KB / 186,9 KiB).**
Gegenprobe nach der Extraktion, ~08:10 UTC: von den 57 ist weiterhin **0** verlinkt.

**Warnung zur Zahl 57:** sie ist eine Momentaufnahme. Gegen dieselbe Live-`MEMORY.md` sind zum Zeitpunkt des
Schreibens bereits **106 von 285** Dateien unverlinkt — die 57 sind darin vollstaendig enthalten, **49
weitere sind seit der Erhebung zusaetzlich aus dem Index gefallen**, weil `MEMORY.md` zwischenzeitlich
gekuerzt wurde. Diese 49 sind hier **nicht** konsolidiert. Einzelheiten und der Erhebungsbefehl stehen in
Abschnitt 7.2.

Ausloeser war ein Zufallsfund: zwei bis dahin unsichtbare Dateien erwiesen sich am 10.08. als unmittelbar
arbeitsauslösend — die Runner-Concurrency (der wahre Speicher-Multiplikator hinter dem OOM) und die
PMC-Mikroarchitektur-Trennung. Beide sind inzwischen im Index verlinkt und **daher nicht Teil der 57**;
sie erscheinen hier nur als Gegenstuecke in der Widerspruchs-Tabelle. Die Dunkelziffer hinter diesen zwei
Funden ist der Grund fuer diesen Auftrag.

### Was NICHT geschieht

**Die 57 Quelldateien werden NICHT geloescht.** Hausregel: Doku wird nie geloescht, nur deprecatet
(`feedback_never_delete_documentation`). Sie bleiben unveraendert liegen unter:

    /home/comdare/.claude/projects/-home-comdare/memory/<dateiname>.md

Es aendert sich ausschliesslich, WO man sie findet: ab jetzt ueber dieses Planungsdokument, auf das der
Index EINMAL verweist. Wer den Volltext braucht, findet ueber die Herkunfts-Tabelle (Abschnitt 5) den
Dateinamen und liest ihn am Quellort.

### Wie dieses Dokument zu lesen ist

- **Abschnitt 2** ist der Teil, der Arbeit ausloest: jeder Fakt, der einer heute geltenden Annahme
  widerspricht. Wer wenig Zeit hat, liest nur diesen.
- **Abschnitt 3/4** traegt die Fakten thematisch, mit Zahlen, Pfaden, SHAs und Daten woertlich.
- **Abschnitt 5** ist die Gegenprobe: alle 57 Dateinamen mit dem Abschnitt, in dem ihre Fakten stehen.

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

Gelesen wurden **ausschliesslich** die 57 unverlinkten `.md`-Dateien im Memory-Verzeichnis.
**NICHT** gelesen wurden: `docs/sessions/*`, der Ledger, Dossiers, Backups, Roh-Transkripte.
Diese Angabe steht hier, weil `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` (Regel 2) genau das
von jeder Konsolidierung verlangt — dort war das Fehlen der Quellenklasse `docs/sessions/*` die Ursache
eines verlorenen Paketschnitts.

---

## 2. Widersprueche — der Teil, der Arbeit ausloest

Kurztabelle zuerst, Einzelheiten mit Quellen und Zitaten direkt darunter (W-01 … W-20).

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

### W-03 Organ-Achsen: 19 (17.07.) gegen 18 (heute bindend)

- **Geltend:** Index fuehrt bindend `reference_organ_achsen_sind_achtzehn_nicht_neunzehn` — "18 ORGAN-ACHSEN,
  nicht 19".
- **Widerspruch aus den 57, woertlich:** "**INC-1:** CEB-System-Achsen-Schichtung (die 4 System-Achsen als
  gemeinsame Schicht UEBER den **19 Organ-Achsen**; heute flach)."
  — `project_diplomarbeit_stand_20260717_volles_go_bau_roadmap.md`, 17.07.2026, AGENTEN-BEHAUPTUNG.
- **Zu tun:** das Korrektur-Datum 19 → 18 belegen (in den 57 nicht enthalten) und die INC-1-Beschreibung
  nachziehen, damit der Bauplan nicht gegen eine tote Zahl gebaut wird.

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
  `test_v41_anatomy_adhoc_autobuilt_load`. Beweis: `ctest -N`-Mengen-Diff frisches Dir gegen
  Referenz-Build-Dir `build-ninja-s4`, einziger CMakeCache-Unterschied war die Option. Stand `be827881`.
- **Fassung 2 (Nachtrag 03.08.2026, Gegenlese D-01):** "`COMDARE_V32_ENABLE` gated **KEINEN** Test (einzige
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

- **Alt:** docs-only-main = **13 Jobs / 0 Bridges**; code-only-main = 13/0.
- **Neu (KORREKTUR 02.08.2026 abends, CiWatch2, MESSUNG):** `trigger:cache-engine` feuert auf super-**main**
  IMMER (diff-unabhaengig), `trigger:thesis` nur bei thesis-Gitlink im Diff. Referenzen NEU:
  docs-only-main = **13/1**, code-only-main = **13/1**, Gitlink(thesis)-main = **13/2**,
  Gitlink(ce)-main = **13/1**, docs-only-dev = **2/0** (unveraendert), prt-art (287) = **6/0**.
  `prebackup:measurements` ist ein regulaerer Job, **kein** Mess-Job.
  — `reference_ci_trace_parsing_commit_titel_falle.md`, 02.08.2026, MESSUNG.
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
  ignorieren sie.**" `rm -f '$null'` scheitert (OneDrive-/Windows-Lock). Schutz: gezieltes Staging
  (`git add <konkrete Pfade>`, **nie** `git add -A`) — `$null` bleibt als `?? $null` in `git status`.
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

### 3.3 Architektur-KERNe: Gattung, Genus, Achsen, Messmodell

- **D-1** Owner-KERN A5, 05.08.2026 (abend-10), woertlich: "**MAP grundsaetzlich eine key und eine value
  Filter-Achse**". Einordnung des Agenten (nicht Owner-Wort): Sortierungen zaehlen als Key-Filter-Klasse.
  Es existieren **4 Umsetzungs-Optionen**, die bewusst **unbewertet** bleiben; der Folgeentscheid faellt
  erst **nach Abgabe**, als Register-Zeile. Ausdrueckliche Abgrenzung: **nicht** zu verwechseln mit der
  Sortier-REIHENFOLGE der 18 Achsen.
  — `feedback_a5_sortierung_key_filter_map_value_filter_achse.md`, 05.08.2026, OWNER-WORT.
- **D-2** Owner-KERN 06.08.2026, woertlich: "Wir halten fest, dass aus einer Interface Funktion einer
  Gattung->Genus immer alle in der interface Funktion (etwa eines Suchalgoritmus) vollzogenen Messparameter
  abrufbar sind, die waehrend des Aufrufs durchlaufen wurden, zusammen mit einem **zeitlich geloggten Profil
  der Achsen-Zugriffsmuster**. […] Die Gattung->Genus verwendet in der Gattung einen **Kern** der
  Interfacefunktionen der Tier-Binary und im Genus eine **spezifische Erweiterung** (etwa bei Containern hat
  ein `std::vector` zwar ein `push_back` und das haben alle Container, aber es hat nicht wie eine double
  liked list ein `push_front`)."
  — `feedback_gattung_genus_interface_messparameter_achsen.md`, 06.08.2026, OWNER-WORT.
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

- **F-1** **Hardware-Erkennung nie statisch** (Owner 27.07.2026, Anlass Intel prod2, woertlich): die
  RAM-Frequenz "sollte nie fest gesetzt werden, sondern wird durch CEB mithilfe der Hardware-Haupt-
  Systemachsen aus dem OS ausgelesen, daher nie statisch, es braucht **eine Klasse mit einem factory Pattern
  fuer die Hardware Erkennung**, welche dies ueber alle Systemachsen wie **ISA x OS** fuer den Anfang
  erkennen kann. […] Es gibt dutzende Bibliotheken welche man je nach OS ebenfalls zur Hilfe nehmen kann."
  — `feedback_hardware_erkennung_factory_laufzeit_nie_statisch.md`, 27.07.2026, OWNER-WORT.
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
  `kAllTargetIsaComplexIds x kAllOperatingSystemIds`. Verworfen bleibt nur die engere Deutung "Planer nur
  CPUID-Vendor/Familie". — dieselbe Datei, 27.07.2026, OWNER-WORT.
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
  **grep/awk-basiert** und entschluesselt **keine** XML-Entities. Gotcha real: beim T-03-Fix scheiterte
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
  g++>=15.3" haette die Floor-Abbruch-Wache auf **jedem gruenen Job** der Welle ausgeloest.
  — `reference_ci_trace_parsing_commit_titel_falle.md`, 27.07.2026, MESSUNG.
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
  selbst `needs: []` mit → der erbende Job ist **stage-frei**; Empirie: `test:unit` lief 4 von 4 Wellen
  **vor** `verify:submodules`. **(p)** Testzahlen sind host-abhaengig (siehe W-20). **(q)** Der
  `get_sources`-Block zeigt "HEAD is now at `<ALTER-SHA>`" **vor** dem Submodul-Update — autoritativ ist nur
  `git submodule status` im `step_script` (real fast falsch gemeldet bei super `13587` / ce `bc5dc37c`).
  — dieselbe Datei, 27.07.–02.08.2026, MESSUNG.
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
  Tokens Analyse-Arbeit" — eine Vermischung entwertet sie. Pfade/Namen exakt: comdare-db = eigenes git-Repo
  `Products/comdare-db`, GitHub `BenniProbst/comdare-db`, GitLab `comdare/products/comdare-db`;
  Sessions-Konvention `YYYYMMDD-HH-MM-NNNNNN-*.md` unter `comdare-db/sessions/`. Buildsystem-Ledger:
  `cd-buildsystem-construct/Layer1-Foundation/cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md`, Master-Ledger
  mit den Kennungen **T-01 bis T-61**; Buildsystem-Sessions unter `cd-buildsystem-core/docs/sessions/`.
  **Integrationsregel** bei Beruehrung beider Systeme (Beispiel rc → cd in `comdare-db-configure.sh`): der
  Buildsystem-Aspekt kommt ins Buildsystem-Ledger, der DB-Code-Aspekt ins DB-Ledger. **Umzugsregel:**
  additiv umziehen (Zielort schreiben, dann Quellort entfernen), Inhalt woertlich erhalten.
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
  die 57 Quelldateien dieser Konsolidierung. **Zwei Dokumentklassen mit unterschiedlicher Doktrin, nicht
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

  Owner-Reaktion woertlich: "**wurde nicht gelesen??**"
  — `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht.md`, 06.08.2026, MESSUNG + OWNER-WORT.
- **L-8** Die Ursache lag **nicht** an der Zeitspanne (der 01.08. lag im erhobenen 14-Tage-Fenster), sondern
  an der fehlenden **QUELLENKLASSE** `docs/sessions/*`: das Register nannte seine Quellen selbst
  ("Ledger 23.-31.07.", "Ledger 01.-06.08.", "Dossier/Doku-Register", "Live-Lesung des Fahrplans") — diese
  Klasse fehlte. Die fruehere Zusage "das 14-Tage-Fenster trug alles Aktive" ist fuer diese Kette
  **widerlegt**. Zusaetzlicher Sucht-Fehler mit gleichem Effekt: ein Scope suchte mit **heutiger** Vokabel
  (`Binary-Stub`, `Dummy-Strategie`), waehrend die Planung vom 01.08. andere Woerter fuehrt (`OE-B`,
  `Dummy-Lager`, "Textdateien mit Stempel-String").
  **Vier Anwendungsregeln:** (1) jede Kette mit Vor-Trigger-/Abgabe-Anspruch **sofort** in Ledger UND
  Vor-Trigger-Checkliste eintragen. (2) bei jeder Konsolidierung die **Quellenklassen explizit auflisten** —
  `docs/sessions/*` ausdruecklich mitnehmen oder den Ausschluss begruenden (in diesem Dokument: Abschnitt 1).
  (3) bei Negativ-Befunden mindestens **zwei Vokabular-Generationen** probieren (heutige plus die der
  vermuteten Entstehungszeit). (4) bei jedem "0 Treffer" die **Gegenprobe** des Musters an einer Datei, die
  treffen MUSS. — dieselbe Datei, 06.08.2026, MESSUNG + AGENTEN-BEHAUPTUNG.

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
- **N-2 (27.07. ~12:25Z)** O-8-Fenster gelandet: ce dev **`7dd41b18`..`e6aeee17`** (17 Commits), super dev
  **`6ca9502f`..`88ccd1b7`** (5 Commits, Gitlink-Bump), beide Remotes, main unberuehrt. Naechste Reihenfolge
  inkl. "**Voll-Bau-4 01.08. (P5-heavy verbindlich c=1/24/nproc)**" — die Zahl 24 siehe W-02.
- **N-3 (27.07. ~12:43Z)** O-8 komplett CI-bewiesen: ce **286/13540** (17 Jobs gruen); super **288/13545**
  (13 Jobs + 3 Bridges gruen); `build:clang` **66,8s**; `lint:secrets` liest **107,90 MB**.
  SHAs: ce **`e6aeee17`** / super **`b3cf9a3a`**.
- **N-4 (27.07. ~15:10Z)** Tages-Doppelabschluss, Kanon vollzogen — siehe H-4. Watchdog-Root-Cause gefunden:
  `gr-eof-watchdog` wertete Log-Stille als Defekt (**36 Restarts / 24h** → Zombies), Fix v3.
  **~15:30Z:** Uebergabe
  `super docs/sessions/20260727-UEBERGABE-tages-doppelabschluss-o8-d3-kanon-153.md` (Commit **`a4dc6891`**);
  `main == dev == a4dc6891` (super) / **`e6aeee17`** (ce) / **`5f9e04be`** (ci-templates).
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
Live-`MEMORY.md` von 07:50 UTC sind sie es **nicht mehr**. Siehe Abschnitt 7.2.

### 5.3 Namensbrueche (Bindestrich gegen Unterstrich)

Sechs Dateien tragen im YAML-Feld `name:` die **Bindestrich**-Schreibweise, waehrend der Dateiname
Unterstriche fuehrt: `feedback_codex_mcp_schreibrechte_mitgeben` (`codex-mcp-schreibrechte-mitgeben`),
`feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme`,
`feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende`,
`feedback_versionierungs_interface_stempel_ct_namensfunktion`,
`feedback_versions_flag_grammatik_dreistellig_hw_flag`, `project_thesis_19_26_22_deferred_until_cluster`.
Derselbe Bruch erzeugt **defekte Verweise**: `[[claude-code-arbeitsweise-v2-konsolidiert]]` (gemeint ist
`feedback_claude_code_arbeitsweise_v2_konsolidiert`), `[[behauptungen-verifizieren-layer-vertraege-halten]]`,
`[[cache-engine-standalone-build-pipeline]]`, `[[no-success-marks-without-literal-output]]`,
`[[goal-hook-thorough-read-in-never-guess]]`, `[[hardware-erkennung-factory-laufzeit-nie-statisch]]`,
`[[hybrid-tier-stufe-hinter-ceb-variant-ausnahme]]`,
`[[stempel-regression-keine-merge-zeile-meta-meta-realm-ende]]` — die Ziele existieren jeweils in der
Unterstrich-Form.

### 5.4 Typ-Diskrepanz Dateiname gegen Metadaten

`reference_codex_null_junk_artifact_ignore.md` und `reference_codex_routing_block_preamble_fix.md` tragen
den Praefix `reference_`, aber `metadata.type: feedback`.

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

---

## 6. Herkunfts-Tabelle — alle 57 Quelldateien

Gegenprobe: wer eine Datei sucht, findet hier ihren Platz im Dokument. Alle Dateien liegen unter
`/home/comdare/.claude/projects/-home-comdare/memory/`. Alphabetisch sortiert.

| # | Quelldatei (`.md`) | Abschnitt(e) | Kurz-Thema |
|---|---|---|---|
| 1 | `feedback_a5_sortierung_key_filter_map_value_filter_achse` | 3.3 (D-1) | Map: Key- und Value-Filter-Achse |
| 2 | `feedback_abschluss_aufraeumpass_deprecated_code_entfernen` | 3.10 (L-1, L-2) | Aufraeumpass, toter Code |
| 3 | `feedback_always_sync_missing_remotes_except_cluster` | W-19, 3.9 (K-1) | Fehlende Remotes nachziehen |
| 4 | `feedback_atlas_immer_korpus_gegenpruefung` | 3.10 (L-3, L-4) | Atlas ist vorlaeufig, nie Beweis |
| 5 | `feedback_berichte_am_prioritaeten_faden` | 3.10 (L-5) | Berichte am Prioritaetenfaden |
| 6 | `feedback_codex_implements_from_dossier_claude_corrects` | 3.2 (B-1..B-7) | Codex-Dossier-Doktrin |
| 7 | `feedback_codex_mcp_always_newest_model_xhigh` | W-04, 3.2 (C-1) | Modell/Effort, drei Zustaende |
| 8 | `feedback_codex_mcp_review_before_code_complete` | W-04, 3.2 (C-7) | Cross-Review vor "fertig" |
| 9 | `feedback_codex_mcp_schreibrechte_mitgeben` | 3.2 (C-2, C-3) | Schreibrechte, git-Timeout |
| 10 | `feedback_codex_outputs_always_full_manual_review` | 3.2 (C-8) | Volltext-Review Pflicht |
| 11 | `feedback_codex_uncertain_fallback_to_ultracode` | 3.2 (C-9) | Unsicherheit → ultracode |
| 12 | `feedback_comdare_db_and_buildsystem_separate_ledgers` | 3.9 (K-2) | Getrennte Ledger |
| 13 | `feedback_comdare_products_house_buildsystem_mandatory` | W-14, 3.9 (K-3) | Hauseigenes Buildsystem |
| 14 | `feedback_e14_nofilter_identitaet_und_e4_deep_research` | 3.3 (D-7, D-8) | NoFilter T16, E4/17 T17 |
| 15 | `feedback_fable5_xhigh_agenten_fuer_alles_kein_opus` | W-05, 3.2 (B-9, B-10) | Fable-5-xhigh, OD-3-Ausnahme |
| 16 | `feedback_gattung_genus_interface_messparameter_achsen` | W-07, 3.3 (D-2..D-6) | Gattung/Genus, Mess-Kanon |
| 17 | `feedback_hardware_erkennung_factory_laufzeit_nie_statisch` | 3.5 (F-1..F-4) | HW-Erkennung per Factory |
| 18 | `feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme` | 3.4 (E-1, E-2) | Hybrid-Stufe, variant-Ausnahme |
| 19 | `feedback_implementierung_an_opus_delegieren_fable_als_architekt` | W-05, 3.2 (B-8) | SUPERSEDED 26.07. |
| 20 | `feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere` | 3.10 (L-6) | Ledger regulaer updatebar |
| 21 | `feedback_pair_explore_with_codex_same_investigation` | W-06, 3.2 (C-10) | Explore-Pairing mit Codex |
| 22 | `feedback_paketschnitt_nur_im_sessiondoc_existiert_nicht` | 3.10 (L-7, L-8) | Session-Doc ist kein Register |
| 23 | `feedback_stempel_regression_keine_merge_zeile_meta_meta_realm_ende` | W-16, 3.4 (E-3, E-4) | E2/E3 Stempel, OS |
| 24 | `feedback_versionierungs_interface_stempel_ct_namensfunktion` | 3.4 (E-5) | F7 Option b, CT-Namensfunktion |
| 25 | `feedback_versions_flag_grammatik_dreistellig_hw_flag` | 3.4 (E-6) | `v1.0.0c`, Flag-Position |
| 26 | `project_20260726_chunk_delta_verlorene_owner_antworten` | 3.4, 3.6 (G-8), 4.1 (M-1..M-10) | D-01..D-17 |
| 27 | `project_20260726_nach_trigger_alle_baender_abarbeiten` | W-01, 3.1 (A-1, A-3..A-5) | 7 Owner-Entscheide |
| 28 | `project_20260727_vormittag_o8_fenster_lage` | W-02, 3.7 (H-2..H-4), 4.2 (N-1..N-12) | O-8-Fenster, Kanon 15.3 |
| 29 | `project_20260804_pause_s5_wellen_landebereit` | 4.3 (O-1, O-2) | S5-Wellen landebereit |
| 30 | `project_20260805_pause_01c_komplett_vor_phase_b` | 4.3 (O-3..O-11) | Stufen-Doktrin, Dual-Review |
| 31 | `project_bep_abt_session_stand_20260705` | W-10, 4.4 (P-1..P-5) | Setup #2, #258, S7-Serie |
| 32 | `project_diplomarbeit_stand_20260706_comdare_prod1` | W-13, 4.4 (P-6, P-7) | Migration comdare@prod1 |
| 33 | `project_diplomarbeit_stand_20260712_freigaben_pipeline` | W-01, 3.1, 4.4 (P-8, P-9) | GO 1-5, 2→3 |
| 34 | `project_diplomarbeit_stand_20260717_volles_go_bau_roadmap` | W-03, W-13, 3.7 (H-11, H-12) | INC-0..INC-2 |
| 35 | `project_e18_snapshot_ordner_und_graph_darstellung_kerne` | 3.6 (G-3..G-5) | E18-Snapshot, 2D/3D-Graphen |
| 36 | `project_frist_montag_2707_zeitbudget_bau_messen` | W-12, 3.7 (H-13) | Zeitbudget 2+2 Tage |
| 37 | `project_handout_ap1_15_code_nachzug_audit_20260702` | 3.7 (H-7..H-10) | AP-1..AP-15, T0 21→22 |
| 38 | `project_lager_basis_tests_dummy_strategien_stempel` | 3.6 (G-1, G-2) | Zwei Dummy-Stempel-Strategien |
| 39 | `project_struktur_regression_geteilte_klone_statt_instanz_repos` | W-18, 3.9 (K-4) | Klon-Regression, Naming |
| 40 | `project_thesis_19_26_22_deferred_until_cluster` | W-11, 3.5 (F-5..F-7) | #19/#22/#26, PMC-Umkehr |
| 41 | `reference_alt_mess_csv_archiv_struktur_modernisierung` | 3.6 (G-6, G-7) | Alt-CSV = Archiv, Reader |
| 42 | `reference_buildsystem_scripts_posix_no_grep_p` | 3.8 (I-1) | `grep -P` stille Null |
| 43 | `reference_buildsystem_xml_grep_parsed_not_strict_xml` | 3.8 (I-2) | XML literal, nicht escapen |
| 44 | `reference_ce_jkette_n316_braucht_v32_enable_on` | W-09, 3.7 (H-5, H-6) | Gate-Zahl 312..331 |
| 45 | `reference_ci_template_redeploy_sauberkeit_nicht_clobbern` | 3.9 (K-5) | v7.0.4, Token-Rotation |
| 46 | `reference_ci_trace_parsing_commit_titel_falle` | W-17, W-20, 3.8 (I-6..I-8) | 17 Trace-Parser-Fallen |
| 47 | `reference_codex_mcp_prod1_bwrap_shell_broken` | W-15, 3.2 (C-4) | bwrap/AppArmor defekt |
| 48 | `reference_codex_null_junk_artifact_ignore` | 3.2 (C-6) | `$null` ignorieren |
| 49 | `reference_codex_routing_block_preamble_fix` | W-15, 3.2 (C-5) | §8-STOPP, `CODEX_HOME`-Fix |
| 50 | `reference_gcc_kern_toolchain_versionen` | 3.7 (H-1) | gcc 15.3, Obergrenze 16 |
| 51 | `reference_gitlab_jobs_api_zeigt_keine_bridges` | 3.8 (I-4) | Bridges nur ueber `/bridges` |
| 52 | `reference_gitlab_pipelines_api_sha_vollform` | 3.8 (I-5) | `?sha=` nur 40 Zeichen |
| 53 | `reference_gruene_tests_zementieren_alte_ordnung` | 3.8 (I-16) | Fixtures, dritter Ableitungsweg |
| 54 | `reference_lokale_vollbau_luecken_falsches_gruen` | W-08, 3.8 (I-9..I-15) | `all`-Ziel-Luecken, Zwei-Gate |
| 55 | `reference_pgrep_warteschleife_selbstmatch_falle` | 3.8 (I-3) | `pgrep -f` matcht sich selbst |
| 56 | `reference_rescue_ref_ist_keine_landung` | 3.8 (I-17) | gruen != gelandet |
| 57 | `reference_submodul_zeiger_kann_rueckwaerts_zeigen` | 3.8 (I-18) | `M` heisst nicht "neuer" |

**Zeilen in dieser Tabelle: 57 von 57. Keine Datei fehlt.**

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

### 7.2 Was dieses Dokument NICHT abdeckt — der Bestand ist gewachsen

**Der Auftrag nennt 57 unverlinkte Dateien. Am 10.08.2026 gegen die Live-`MEMORY.md` (17274 Byte,
mtime 07:50:20 UTC, 79 Zeilen) sind es 106 von 285.** Die 57 sind vollstaendig darin enthalten
(Schnittmenge 57, keine der 57 wurde zwischenzeitlich verlinkt); **49 weitere Dateien sind seit der
Erhebung des 57er-Bestands zusaetzlich aus dem Index gefallen**, weil `MEMORY.md` in der Zwischenzeit von
anderen Agenten gekuerzt/umgeschrieben wurde. Belegt: fuenf Ziele, die der Index-Schnappschuss zu
Sitzungsbeginn noch unter den Kurzlabels "Lager-Baeume", "Dock .so", "Products", "286=Forschung" und
"§62 Planer" fuehrte, sind gegen die 07:50-Fassung **nicht mehr** auffindbar.

**Diese 49 sind hier NICHT konsolidiert.** Der Bestand laesst sich jederzeit neu erheben:

    M=/home/comdare/.claude/projects/-home-comdare/memory
    for f in $M/*.md; do b=$(basename "$f" .md); [ "$b" = "MEMORY" ] && continue; \
      [ "$(/usr/bin/grep -Fc "$b" $M/MEMORY.md)" = "0" ] && echo "$b"; done

Erste zwoelf der 49 (alphabetisch, zur Wiedererkennung):
`feedback_agent_working_tree_freeze_nach_paketmeldung`,
`feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources`,
`feedback_autonomie_modus_plan_autonom_durchziehen`,
`feedback_baseline_system_in_stein_gemeisselt_layering`,
`feedback_build_matrix_8_docker_distros_full_platform_doctrine`,
`feedback_buildsystem_xml_hands_off_parallel_ci_cmake`,
`feedback_ceb_config_cmake_interface_static_registry_paths_prt_module`,
`feedback_ext_paper_organisation_separates_axes_from_paper_code`,
`feedback_freeze_nachrichten_eindeutig_nur_antwort_vs_arbeitsauftrag`,
`feedback_incremental_tier_binary_caching`,
`feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs`,
`feedback_kette_planer_mess_ceb_system_tier_organ_hybrid`.

**Empfehlung:** die Index-Kuerzung pruefen, bevor eine zweite Konsolidierungsrunde gestartet wird — es kann
sein, dass die 49 versehentlich herausgefallen sind und schlicht zurueckgehoeren, statt konsolidiert zu
werden.

### 7.3 Weitere Grenzen

- **Quellenklassen:** nur die 57 Memory-Dateien. Keine `docs/sessions/*`, kein Ledger, keine Dossiers,
  keine Backups, keine Roh-Transkripte (siehe Abschnitt 1).
- **Nicht am Objekt verifiziert:** die Fakten sind aus den Memories uebernommen, nicht gegen den heutigen
  Code-/CI-Stand geprueft. Wo eine Datei selbst schon "am Objekt belegen, nicht annehmen" sagt (G-2), gilt
  das weiter.
- **Herkunftsklassen sind nicht gleichwertig:** eine AGENTEN-BEHAUPTUNG in diesem Dokument bleibt eine
  Behauptung, auch wenn sie hier ordentlich formatiert steht.
- **Die W-Nummern dieses Dokuments sind keine Autoritaetsbelege** — sie sind eine Zaehlung dieses Dokuments,
  keine Owner-Nummerierung (vgl. Index: "OV-NUMMERN sind KEIN Autoritaetsbeleg").

### 7.4 Was jetzt in den Index gehoert

Genau **eine** Zeile, gemaess Owner-Auftrag ("dann verlinke nur die Konsolidierung wieder in den index").
Vorschlag fuer den Abschnitt "Stand/Fallen" oder einen eigenen Punkt:

    - **[57 unverlinkte Memories, konsolidiert](<PFAD>/20260810-KONSOLIDIERUNG-unverlinkte-memories.md)**
      — Widersprueche vorn, Fakten thematisch, Herkunfts-Tabelle 57/57; Quelldateien bleiben liegen

Der genaue Pfad ist beim Setzen an den Ort anzupassen, an dem das Dokument am Ende gelandet ist
(Arbeitsstand: `/home/comdare/wt-super-landung/docs/plaene/20260810-KONSOLIDIERUNG-unverlinkte-memories.md`).

