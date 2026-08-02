# I112 -- Runner-Fleet Ist/Soll ueber ALLE Architekturen + Poll-Jitter (E-19, Stufe 1)

**Stand:** 2026-08-02 - **Paket:** A16-P2 Stufe 1 (E-19 aus dem Owner-R7-Pflicht-Buendel)
**Owner-Deckung:** `docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:19`
("E-24, E-19, E-02, E-23, E-21 sind jetzt PFLICHT") + `:13`/`:44` (RISC-V + macOS M1 + macOS x86 kommen dazu).
**Hoheits-Trennung:** Ist-Erhebung an der Fleet, Nachaktivierung, Tag-Vergabe und Poll-Konfiguration sind
**INFRA-Territorium** (der Diplomarbeits-Strang liest das Cluster-Repo read-only). Dieses Dokument ist der
diplomarbeits-seitige Ist-Soll-Abgleich und der Anker des Infra-Handouts -- es aendert nichts am Cluster.
**Gate-Status:** **Stufe 1 = dieses Doc + Infra-Handout = trigger-blockierend.** Die **Nachtrags-Stufe**
(Abschnitt 8, nach Infra-Vollzugs-Meldung) ist **ausdruecklich NICHT gate-relevant**: der Voll-Bau-4-Trigger
haengt nicht am Infra-Vollzug der drei neuen Plattformen (Bau und Messung laufen auf prod1/prod2).

---

## 1 Auftrag (Owner-Wortlaut, verbatim)

Aus `docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-E01-E26.md:91-94` (E-19):

> "Laufen weiterhin alle im cluster geplanten gitlab runner ueber alle Architekturen nach der Cluster gitlab
> runner Beschreibung? Ansonsten aktiviere das bitte nachtraeglich"

> "alle 2+rand(0.0 ... 1.0) Sekunden nach neuen jobs pollen"

Owner-Entscheid E4 vom 02.08. (OWNER-Doc `:13`, verbatim):

> "Ja bitte schaerfen, heute kommt noch RISC-V und ein macOS M1 und macOS x86 dazu."

Daraus die drei Deliverables der Stufe 1: (a) Ist-Soll-Matrix ueber ALLE Architekturen (Abschnitt 3),
(b) einheitliches Tag-Schema als Vorschlag zur Infra-Bestaetigung (Abschnitt 4), (c) Poll-Soll woertlich an
Infra mit Verifikations-Forderung (Abschnitt 7).

---

## 2 Methodik und Beleg-Klassen (was hier Ist heisst -- und was nicht)

**KEIN eigener Admin-API-Call.** `GET /api/v4/runners/all` ist in der GitLab-API **admin-only**; mit einem
Projekt- oder Gruppen-PAT liefert er 403 oder eine gefilterte/leere Liste. Ein leeres Ergebnis als "Ist" zu
fuehren waere das gefaehrlichste Muster (leeres Ergebnis als Befund fehlgedeutet). Die Ist-Spalte wird deshalb
**normativ als "von Infra zu bestaetigen"** gefuehrt und ausschliesslich mit den Beleg-Klassen unten unterlegt.

| Klasse | Bedeutung | Aussagekraft |
|---|---|---|
| `[CI-TRACE]` | Runner-Kopfzeile eines real gelaufenen Jobs (`Running with gitlab-runner ... on <name>`) | **haerteste** uns selbst zugaengliche Ist-Evidenz: dieser Runner hat einen Job angenommen |
| `[INFRA]` | Infra-Report im Cluster-Repo, per Admin-PAT gegen die GitLab-API erhoben (read-only gelesen) | **massgeblichste** Fleet-Quelle; Stand des Melde-Zeitpunkts, von uns nicht nachverifizierbar |
| `[CI-YAML]` | im Repo verdrahteter `tags:`-Bedarf | belegt den SOLL-Bedarf, **nie** die Runner-Existenz |
| `[DOC]` | Diplomarbeits-Doku (#276-Matrix, W4-A-Matrix, Handovers) | Planungs-/Historienstand, teils Feb--Jul 2026, potentiell stale |

**Quellen der `[INFRA]`-Zeilen** (alle `Cluster/docs/sessions/`, read-only gelesen, nichts veraendert):

- `2026-07-26-INFRA-runner-matrix-DONE.md` §A -- **Voll-Erhebung der Fleet per Admin-API** (26.07., ~19:30-21:40).
  Das ist die aktuellste auffindbare vollstaendige Fleet-Aufnahme.
- `2026-07-27-INFRA-P4-windows-runner-git-online-VOLLZUG.md` -- Windows-Runner-Status 27.07.
- `2026-07-27-INFRA-win-runner-untagged-fix-DONE.md` -- Tag-Disjunktheit Windows vs. Linux-baremetal (27.07.).
- `2026-07-27-INFRA-node7-diskgc-runner-contention-B1-VOLLZUG.md` -- node7-Rolle + `concurrent=1` (27.07.).
- `2026-08-02-K118d-SWEEP-6-DIAGNOSEN-node7-AUSFALL-V10-POLICY-KORREKTUREN.md` -- node7-Ausfall (02.08., ~14:05).
- `2026-08-02-K118f-node7-ROOT-CAUSE-sysvol-sync-backups-abgeschaltet.md` -- **node7-Root-Cause-Kandidat +
  Backup-Abschaltung auf Owner-Anweisung** (02.08.). Loest K118d als node7-Ist ab.
- `2026-08-02-K118g-KOORDINATION-offene-straenge-priorisiert.md` `:9` -- **node7-Live-Stand ~16:25**
  ("ueberlebt seit Backup-Abschaltung 23+ min", Beobachtung laeuft, #536). **Juengste node7-Quelle.**
- `2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md` `:13-15` -- prod2-CPU-Kern-Kennung, Live-`lscpu`
  auf dem prod2-Blech (Antwort auf unsere eigene Rueckfrage O-4a).
- `2026-08-02-K118c-node5-RECOVERY-RUNBOOK-drei-wege.md` und
  `2026-08-02-K118b-NACHMITTAG-BEFUNDE-node5-V10EGRESS-OFFENE-ARBEIT.md` -- node5/node6/node8-Lage (02.08.).

**Quellen-Vorrang innerhalb `[INFRA]`:** bei mehreren Berichten zum selben Host gilt der **juengste**. Fuer node7
ist das K118g `:9` (~16:25), nicht K118d (~14:05) -- die Erst-Fassung dieses Dokuments hatte genau diese Staffelung
uebersehen und node7 als hart ausgefallen gefuehrt (Korrektur unten in 3.1 und 8).

Konsequenz: **Runner-IDs, Tag-Listen, `concurrent`-Werte und Online-Status sind Uebernahmen aus diesen Quellen,
keine von uns verifizierten Ist-Werte.** Bestaetigt oder korrigiert werden sie im Ruecklauf des Handouts; erst
der Ruecklauf fuellt die Nachtrags-Stufe (Abschnitt 8).

---

## 3 Fleet-Matrix

### 3.1 Kern-Zellen: Bau-/Mess-Flotte + die drei Owner-E4-Plattformen

| Zelle (ISA x OS) | Host / Runner | Tags (Ist bzw. Soll-Vorschlag) | Beleg | Ist-Status (von Infra zu bestaetigen) |
|---|---|---|---|---|
| `x86_64` (AMD) x linux | prod1, id16 `prod-baremetal-prod1`, shell/Ubuntu | Ist `prod, baremetal, amd, amd64, avx2, avx512 (+12 Sub-Flags), x86_64` | `[CI-TRACE]` 02.08. 13:20:08Z (gitlab-runner 19.1.1) + `[INFRA]` 26.07. | **online, nimmt Jobs an.** `concurrent=3` / 10 Threads (Modus `normal`) `[INFRA]` 26.07. -> Ist heute bestaetigen |
| `x86_64` (Intel) x linux | prod2, id17 `prod-baremetal-prod2`, shell/Ubuntu | Ist `prod, baremetal, intel, amd64, avx2` | `[CI-TRACE]` 02.08. 13:23:24Z + 08:06:27Z (19.1.1) + `[INFRA]` 26.07. | **online, nimmt Jobs an.** `concurrent=2` / 12 Threads (`normal`) `[INFRA]` 26.07. -> Ist heute bestaetigen. **HW GEKLAERT (keine offene Frage):** CPU ist ein **Intel Core i9-12900K** (Alder Lake, family 6 / model 151 / stepping 2) -- Live-`lscpu` auf dem prod2-Blech, `[INFRA]` `2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md:13-15`. Der `[DOC]` #276 `:14`-Wert i9-14900KS ist **pre-RMA-stale** (dokumentierter CPU-Tausch 14900KS -> 12900K), keine echte Diskrepanz; diplomseitig bereits nachgezogen (Thesis-Commit `b224628`, KATALOG `:55` "F15-12900K-Nachzug") |
| `aarch64` x linux | node7 (Pi5), id4 `node7-rpi5-arm64` | Ist `arm64, linux` `[DOC]` #276 `:18` (Stand 06.07. -- **keine** Infra-Bestaetigung, in 8 zur Bestaetigung gefuehrt); unser Bedarf: `arm64` (ce `.gitlab-ci.yml:134`) | `[INFRA]` 27.07.: **einziger online arm64-Linux-Runner**, `concurrent=1`; `[INFRA]` K118f/K118g `:9` 02.08. ~16:25 | **In Erholung, Beobachtung laeuft (#536).** Ausfall 02.08. 13:00:03 CEST; **Root-Cause-Kandidat `samba-sysvol-sync`** (kubectl-exec-Tar-Stream alle 15 min aus der node7-User-crontab, ~9-12 min Lebensdauer je Boot). Infra hat **auf Owner-Anweisung alle 14 Backup-Jobs abgeschaltet** (reversibel, PRE gesichert); seither ist der **Node wieder zugreifbar und ueberlebt** (K118g `:9`: "23+ min", vorher 9-12). Infra deklariert den Kandidaten selbst als **stark indiziert, nicht bewiesen** (kein OOM-Kill im Journal des Crash-Boots). Kein CI-Trace, weil `build:arm64-smoke` opt-in-gegated ist (`COMDARE_ISA_MATRIX`, `allow_failure`) -- die Trace-Leere ist also **kein** Runner-Beweis in beide Richtungen |
| `riscv64` x linux (**Owner-E4 NEU**) | node8 (VisionFive2), id5 `node8-visionfive-riscv64` | Soll-Vorschlag **`riscv64`** (+ `linux`) | `[INFRA]` 26.07.: id5 unter "Online-Instanz-Runner ausserhalb prod1/2"; `[INFRA]` 02.08.: Host **online** (10.0.60.208, :22 offen) "entgegen Doku/Board" | **Infra-Vollzug ausstehend.** Runner-Registrierung existiert offenbar, aber **kein `riscv64`-Tag und keine CI-Anbindung** -> naeher am Ziel als die Alt-Doku annimmt; Tag + Nachaktivierung bestaetigen |
| `aarch64` x macos (**Owner-E4 NEU**, M1) | node6 (Mac mini M1 2020), id3 `node6-macarm-arm64` | Soll-Vorschlag **`macos-arm64`** | `[INFRA]` 26.07.: **stale**; `[INFRA]` 02.08.: Diagnose laufend (abweichend von node5) | **Infra-Vollzug ausstehend** (Registrierung + Tag + Toolchain) |
| `x86_64` x macos (**Owner-E4 NEU**) | node5 (Mac mini 2018 Intel), id2 `node5-macintel-x86_64` | Soll-Vorschlag **`macos-x86-64`** | `[INFRA]` 26.07.: **stale**; `[INFRA]` 02.08.: Recovery-Runbook offen (V10-Egress/Portlage) | **Infra-Vollzug ausstehend** (erst Host-Recovery, dann Registrierung + Tag) |

**Zwei Lesehilfen gegen typische Fehlschluesse:**

1. **Tag im YAML != Runner existiert.** Der `arm64`-Tag ist im ce-CI verdrahtet, aber der einzige Job, der ihn
   anfordert, ist opt-in und `allow_failure`. Aus der CI-Seite folgt nur der Bedarf, nie die Fleet-Realitaet.
2. **Fehlender Trace != Runner tot.** Ein gegateter Job erzeugt nie einen Trace -- die node7-Zeile stuetzt sich
   deshalb ausschliesslich auf die Infra-Befunde, nicht auf unsere Trace-Leere.

### 3.2 Weitere Fleet-Zellen (Vollstaendigkeit; ausserhalb Stufe 1)

| Zelle | Host / Runner | Tags | Ist-Status (Quelle) |
|---|---|---|---|
| `x86_64` x linux (k8s prod) | id15 `prod-k8s-talos-runner` | `prod, kubernetes, talos` | online, `concurrent=3`, Pod-Limit cpu=8 `[INFRA]` 26.07. |
| `x86_64` x linux (k8s dev) | id1 `k8s-runner`, id10, id11, id12 | `kubernetes, docker, dev, chaos-engineering, jitter` (`run_untagged=true`) | alle 4 online, je `concurrent=1` `[INFRA]` 26.07. |
| `x86_64` x windows | id53 `prod1-win2022`, id54 `prod2-win2022`, id55 `prod1-win11`, id19 `prod2-win11` | nach Tag-Disjunktheits-Fix: `windows`, `win2022`\|`win11`, `x86_64` (kein `baremetal`/`prod` mehr) | alle 4 **online** `[INFRA]` 27.07. |
| `x86_64` x debian/ubuntu (kleine Builder) | id6 pve1, id7 pve2, id8 node3, id9 node4 | `debian`\|`ubuntu`, `x86_64`, `bare-metal` | **stale** `[INFRA]` 26.07. |
| `x86_64` x linux (k8s alt) | id14 `prod-k8s-x86-main` | -- | **tot seit 2026-06-22** `[INFRA]` 26.07. -> deregistrieren oder reaktivieren (Infra-Entscheid) |
| `x86_64` x linux (HPC) | id13 `zih-barnard-socks5` | SOCKS5-Transport | **stale**/gated (eduVPN, Kontingent) `[INFRA]` 26.07. / `[DOC]` |
| `x86_64` x windows (Repro) | id52 `laptop-benja-windows-repro` | -- | online, **locked** `[INFRA]` 26.07. |

**Korrektur eines aelteren Diplomarbeits-Befunds (Stale-Doku-Falle):** Die W4-A-Matrix vom 19.07.
(`docs/plaene/20260719-cluster-parallel-build-MATRIX.md:57-60`, `:161-180`) haelt fest, **kein** Runner trage
die Capability-Tags `amd64`/`avx2`/`avx512`. Das ist **ueberholt**: `[INFRA]` 26.07. weist fuer id16
`amd64, avx2, avx512 (+12 Sub-Flags), x86_64` und fuer id17 `amd64, avx2` aus. Das W4-A-Pool-Routing ist damit
auf den beiden prod-Knoten tag-seitig bedient; offen bleibt es nur fuer die kleinen Builder (id6-id9), die
aktuell ohnehin stale sind. Die Bestaetigung dieser Tag-Listen ist Teil des Handouts.

---

## 4 Tag-Schema (Vorschlag; Infra bestaetigt oder korrigiert)

**Ist-Tag-Klassen, literal aus unseren CI-Dateien (Bedarfs-Seite):**

| Tag | Bedeutung | Beleg |
|---|---|---|
| `prod` | prod-Umgebung (Mess-/PMC-Kontext) | super `.gitlab-ci.yml:645`, `:727` (`tags: [prod, baremetal, amd]`) |
| `baremetal` | Shell-Executor auf Blech (kein Container) | ce `.gitlab-ci.yml:57` u.v.a., super `.gitlab-ci.yml:146` u.v.a. |
| `amd` | Vendor-Lane AMD (prod1) | ce `.gitlab-ci.yml:116` (`pmc:amd`) |
| `intel` | Vendor-Lane Intel (prod2) | ce `.gitlab-ci.yml:122` (`pmc:intel`) |
| `arm64` | aarch64-Linux-Lane | ce `.gitlab-ci.yml:134` (`build:arm64-smoke`) |
| `$SWEEP_TAG` | variabel `amd`\|`intel`, nur per API-Trigger | super `.gitlab-ci.yml:123` |

**Vorschlag fuer die drei neuen Zellen (Owner-E4):**

| Zelle | Vorgeschlagener Tag | Begruendung |
|---|---|---|
| RISC-V Linux | `riscv64` (+ `linux`) | ISA-Schreibweise analog zur `arm64`-Praezedenz; deckt sich mit `[DOC]` #276 (`tags riscv64,linux`) |
| macOS Apple Silicon | `macos-arm64` | OS-Familie + ISA in EINEM Tag -- verhindert, dass ein `arm64`-Job versehentlich auf macOS landet |
| macOS Intel | `macos-x86-64` | dito; **Bindestrich-Form verbindlich** |

**Schreibweisen-Regel (loest die Doku-Drift auf):** Es gilt **genau ein** Schema -- durchgaengig Bindestriche,
also `macos-x86-64` (**nicht** `macos-x86_64`). GitLab erlaubt beide Zeichen; entscheidend ist, dass
CI-Templates, Runner-Config und Doku nie auseinanderlaufen. Weicht Infra bei der Registrierung ab, gilt die
Infra-Schreibweise und dieses Dokument wird nachgezogen (nicht umgekehrt).

**Tag-Disjunktheit ist Pflicht (Lehre aus dem 27.07.-Vorfall):** Weil id53/54/55 den Tag `baremetal` additiv
erhielten, griffen **Windows-Runner Linux-`baremetal`-Jobs ab** (`[INFRA]` 27.07.: Job `lint:format` lief auf
`prod1-win11`); `run_untagged=false` half nicht, weil es nur ungetaggte Jobs steuert. Der Fix war der Entzug
von `baremetal`/`prod` auf den Windows-Runnern. **Fuer die drei neuen Zellen gilt dasselbe:** die neuen Tags
duerfen **keine** bestehende Lane-Semantik ueberlappen -- insbesondere darf ein macOS-Runner **nie** `arm64`
oder `baremetal` tragen, sonst zieht er Linux-Jobs.

**CI-Templates ziehen erst NACH der Vollzugs-Meldung nach.** Neue `tags:`/Jobs gegen nicht existente Runner
erzeugen ewig pendende Jobs bzw. rote Pipelines -- gegen die Doktrin "Pipeline immer hart gruen". Der
CI-Nachzug ist Folge-Increment, nicht Teil dieses Pakets.

---

## 5 Naht zu A14 (target_isa / operating_system) -- warum ein Runner allein nicht reicht

Der Owner-Querschnitt (OWNER-Doc `:44`) nennt die Achsen ausdruecklich. Ist-Stand in der cache-engine
(`development` 7603453b, Registry `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml`):

| Achse | Ist | Folge fuer die neuen Zellen |
|---|---|---|
| `target_isa` | `baustein_count="2"`: `x86_64`, `aarch64` (Registry `:10-12`); `kAllTargetIsaIds` = 2 Eintraege (`target_isa_system_axis.hpp:85`) | **`riscv64` fehlt in DIESER Achse** -- der Header haelt `:61` fest: "Weitere ISAs (riscv64/power) folgen mit der Runner-/Toolchain-Matrix". Die Achsen-Erweiterung ist ein **eigenes, design-/owner-gegatetes Paket** (System-Achsen-Wert-Zuwachs; jede Beruehrung von `kSystemAxisCodeVersions` unterliegt der A14-Bump-Verbots-Wache). **Hier NICHT entschieden.** **Aber Vorsicht -- das ist nicht der einzige Weg zu einer riscv64-Binary, s. 5.1.** |
| `operating_system` | 3 Familien `linux` / `windows` / `macos` (Registry `:41-44`), Unter-Achsen `os_version` / `kernel` / `build` (`:45-47`, `option_source="machine_resolved"`) | **macOS ist achsen-seitig bereits modelliert** (Familie + drei Unter-Achsen aus OS-U1/U2). Es fehlt die **Laufzeit-Erhebung** je Familie = Paket OS-U3 (macos prozess-frei ueber `sysctl`/`SystemVersion.plist`, nicht `sw_vers`). |
| Skip-/Lager-Identitaet | `system_stamp_line` traegt heute nur Code-Versionen, keine Zellwerte (W10-Paket offen) | **Uebergangsregel bis W10 gilt hier direkt:** Binary-Skip nur innerhalb derselben OS-Familie. Solange W10 nicht steht, duerfen macOS-/RISC-V-Zellen **nicht** in den gemeinsamen Lager-Skip mit den Linux-Zellen -- sonst wuerde ein Linux-Binary fuer macOS "wiederverwendet". Das ist die Fleet-seitige Sicht auf denselben Befund. |

### 5.1 Drei Ableitungswege zu einer riscv64-Binary -- die Mess-Achse ist nur einer davon

Die Erst-Fassung dieses Dokuments schloss kategorisch: "ein riscv64-Runner erzeugt noch keine
riscv64-Binaries". Das ist **zu eng** und war der gefaehrlichere Fehler, weil es Sicherheit vorspiegelt.
Die `target_isa`-**Mess**-Achse ist nur der erste von **drei** Wegen; die anderen beiden existieren am
ce-Ist bereits und stehen nicht unter der Achsen-Gatterung:

| # | Weg | Ist am ce-Stand | Was er erzeugt |
|---|---|---|---|
| 1 | **Mess-Achse `target_isa`** (Cross-Permutation ueber `-target ...`) | nur `x86_64` + `aarch64` (Registry `:10-12`) | Heute **keine** riscv64-Binary. Gegattert (A14/Bump-Wache). |
| 2 | **Nativer Bau auf einem riscv64-Host** | `cmake/platform_detection.cmake:31-33` erkennt `CMAKE_SYSTEM_PROCESSOR MATCHES "^riscv64$"` -> `COMDARE_ARCH="riscv64"`, `COMDARE_ARCH_RISCV64 ON` | **Sobald node8 CI-Jobs annimmt**, baut ein Job nach dem Muster von `build:arm64-smoke` (ce `.gitlab-ci.yml:134`) **nativ riscv64-Binaries** -- ganz ohne die Mess-Achse. |
| 3 | **SIMD-Organ-Achse 09 (ISA)** | `libs/cache_engine/axes/simd/axis_09_isa_riscv.hpp` (`class RiscVIsa`, RV64GC) + `axis_09_isa_flags.hpp.in:6` `#cmakedefine01 COMDARE_AXIS_09_USE_RISCV` | Der RISC-V-Zweig ist **im Organ-Achsen-Code vorhanden** und wird per CMake-Flag scharf geschaltet; er haengt nicht an `kAllTargetIsaIds`. |

**Konsequenz fuer die A14-Naht (der eigentliche Punkt):** Weg 2 und 3 koennen riscv64-Artefakte erzeugen,
**bevor** `target_isa` die ISA kennt. Solche Binaries waeren **stempel-/lagerseitig nicht zuordbar**: die
`system_stamp_line` traegt keinen ISA-Zellwert (W10 offen), und `kAllTargetIsaIds` kennt `riscv64` nicht --
ein nativ gebautes riscv64-Artefakt landete damit ununterscheidbar neben den x86_64-Artefakten im Lager und
faellt im Skip-Vergleich potentiell mit ihnen zusammen.

**Daraus zwei Auflagen, hier nur festgehalten, NICHT entschieden:**

1. **Reihenfolge-Auflage:** Ein riscv64-CI-Job (Weg 2) darf erst scharf geschaltet werden, wenn entweder
   `target_isa` die ISA fuehrt **oder** der Lager-Pfad des Jobs von den gemessenen Zellen getrennt ist --
   analog zur `build:arm64-smoke`-Praxis (`allow_failure`, opt-in per `COMDARE_ISA_MATRIX`, kein
   Lager-Rueckschrieb).
2. **Bump-Auflage:** Die `target_isa`-Erweiterung um `riscv64` beruehrt `kSystemAxisCodeVersions` und
   unterliegt der A14-Bump-Verbots-Wache -- eigenes, owner-gegatetes Paket, s. Abschnitt 8.

---

## 6 Querverweise

- **#276 Voll-Plattform-Matrix** -- `docs/sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md`. Dort stehen die
  Soll-Zeilen inkl. der drei neuen Zellen: node5/macOS-Intel `:16`, node6/macOS-ARM `:17`, node7/arm64 `:18`,
  node8/riscv64 `:19`, prod1 `:13`, prod2 `:14`. **Abgrenzung:** #276 ist die Voll-Matrix (Arch x OS x Docker
  x Compiler, inkl. Images/HPC/Registry); **I112 ist der Runner-Fleet-Ausschnitt mit der Ist-Verifikations-
  Spalte** und den Owner-E4-Zeilen. I112 ersetzt #276 nicht, es ergaenzt genau die Spalte, die dem
  Wahrheits-Anker nach fehlt (ANKER `:93-94`: "Voll-Plattform-Matrix #276 ohne verifizierte Abdeckung").
- **D-02 (Chunk-Delta 26.07.)** -- PMC-Gate hart als **AND**: `pmc:amd` UND `pmc:intel` muessen auf Comdare
  gesetzt und erfolgreich sein, bevor eine Maschinen-Lane den Strang abarbeitet; **Runner-Filter verifizieren**.
  Dieser Filter ist im ce-CI verdrahtet (`:116` `[baremetal, amd]`, `:122` `[baremetal, intel]`, UND-Semantik
  der Tag-Liste; PMC-Doktrin-Kommentar `:100-113`) und wird durch die Ist-Tags von id16/id17 (Abschnitt 3.1)
  getragen. E-19 "ergaenzt D-02" (ANKER `:94`): **die Fleet-Matrix ist der stehende Ist-Nachweis fuer die
  D-02-Bedingung** -- ohne bestaetigte Vendor-Zuordnung der Runner ist das AND nicht belegbar. Der
  27.07.-Vorfall (Windows-Runner greift `baremetal`-Jobs) zeigt, wie schnell diese Zuordnung kippt.
- **W4-A Pool-Routing** -- `docs/plaene/20260719-cluster-parallel-build-MATRIX.md:57-60`, `:161-180`
  (Capability-Tags; Stand 19.07., inzwischen ueberholt -- s. Korrektur in 3.2).
- **Runner-Betriebsmodi** -- `runner-mode.sh normal|heavy` auf beiden prod-Hosts: `normal` = prod1
  `concurrent=3`/10 Threads, prod2 `concurrent=2`/12 Threads; `heavy` = `concurrent=1` + physische Kerne als
  Obergrenze. Reload ausschliesslich `kill -HUP` (nie `systemctl restart`). `[INFRA]` 26.07. -- vor
  Voll-Bau/Messung `heavy`, danach `normal`.

---

## 7 Poll-Verhalten (Owner-Soll woertlich; Umsetzung = Infra)

**Soll (Owner, verbatim):** "alle 2+rand(0.0 ... 1.0) Sekunden nach neuen jobs pollen" -- also ein
Poll-Intervall von **2 + rand(0.0..1.0) s** je Runner: Grund-Intervall 2 s plus gleichverteilter Jitter unter
1 s, damit mehrere Runner nicht im Gleichtakt pollen.

**Was wir NICHT tun:** die Umsetzung vorschreiben. Nach unserem Kenntnisstand ist `check_interval` in der
Runner-`config.toml` **ganzzahlig** (Sekunden) -- damit waere ein Sub-Sekunden-Jitter moeglicherweise nicht
nativ konfigurierbar. Das ist eine **Verifikations-Forderung an Infra gegen die offizielle Runner-Doku**, keine
Behauptung und keine Vorgabe. Bezugsversion ist der Ist-Runner **19.1.1** auf beiden prod-Hosts
(`[CI-TRACE]` 02.08.).

**Gefordert im Ruecklauf:** (a) Aussage, ob die Owner-Formel nativ abbildbar ist; (b) falls nein: die von
Infra gewaehlte Naeherung (z. B. gestaffelte ganzzahlige Intervalle je Runner) **mit Begruendung**; (c) in
beiden Faellen ein **literaler `config.toml`-Auszug** der wirksamen Poll-Einstellung je Runner plus
Reload-Beleg. **Secret-Hinweis:** die Datei traegt `cache.s3`-Credentials -- nur die Poll-Zeilen zitieren,
nie die ganze Datei.

---

## 8 Nachtrags-Stufe (NICHT gate-relevant) -- Platzhalter bis zur Infra-Vollzugs-Meldung

Diese Sektion wird nach der Infra-Rueckmeldung befuellt und ist **kein Trigger-Gate**. Aufnahme-Kriterien:

- [ ] Ist-Spalte aus 3.1/3.2 durch Infra bestaetigt oder korrigiert (Runner-Namen, IDs, Status, `concurrent`,
      Tag-Listen) -- Quelle: Infra-Antwort, nicht unsere Uebernahme.
- [x] **prod2-HW: ERLEDIGT, keine Infra-Frage.** i9-12900K (Alder Lake) belegt per Live-`lscpu`
      (`[INFRA]` `2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md:13-15`, Antwort auf unsere Rueckfrage
      O-4a); `[DOC]` #276 `:14` ist pre-RMA-stale. Thesis-seitig nachgezogen (`b224628`, KATALOG `:55`).
      **Folge-Notiz (offen, fremdes Paket):** die W4-A-Matrix begruendet "prod2 ohne AVX-512" ueber
      Raptor-Lake-R. Die Ist-Tag-Liste von id17 (`avx2`, **kein** `avx512`) traegt die Aussage weiterhin,
      die Modell-Begruendung ist aber nachzuziehen. Nicht hier entschieden -- Supersede-Vermerk in
      `docs/plaene/20260719-cluster-parallel-build-MATRIX.md` empfohlen.
- [ ] node7 (arm64), #536 -- **teil-beantwortet, Beobachtung laeuft:** Root-Cause-Kandidat `samba-sysvol-sync`
      identifiziert, Backups abgeschaltet, Node wieder zugreifbar (K118f, K118g `:9`). Offen bleibt: (a) haelt die
      Stabilitaet ueber Stunden (Infras eigener Gegenbeweis-Test), (b) bleibt die arm64-Lane damit dauerhaft
      tragfaehig oder braucht sie den zweiten arm64-Linux-Runner, den Infra selbst als Bedarf flaggte (#394/#78).
      **Abschreibung der Lane steht nach heutigem Stand nicht mehr im Raum.**
- [ ] node7-Tag-Ist `arm64, linux` bestaetigen -- bislang nur `[DOC]` #276 `:18` (Stand 06.07.), keine
      Infra-Erhebung; die Voll-Erhebung 26.07. fuehrt id4 nur als "online", ohne Tag-Liste.
- [ ] riscv64 (node8, id5): Tag `riscv64` gesetzt, Runner CI-seitig ansprechbar.
- [ ] macos-arm64 (node6, id3) und macos-x86-64 (node5, id2): Runner registriert/reaktiviert, Tags gesetzt.
- [ ] Tag-Schema bestaetigt (oder Infra-Schreibweise uebernommen) -> danach CI-Template-Nachzug als eigenes
      Increment.
- [ ] Tag-Disjunktheit der neuen Tags geprueft (kein Ueberlappen mit `baremetal`/`arm64`/`prod`).
- [ ] Poll-Verhalten: Antwort + literaler Config-Beleg (Abschnitt 7).
- [ ] Danach erst: A14-Folgefrage `target_isa`-Erweiterung um `riscv64` als eigenes Paket vorlegen
      (Abschnitt 5/5.1) -- sinnvoll erst, wenn ein riscv64-Runner real Jobs annimmt. **Mit der
      Reihenfolge-Auflage aus 5.1:** ein nativer riscv64-Bau (Weg 2, `platform_detection.cmake:31-33`) ist
      auch ohne die Mess-Achse moeglich; solche Artefakte sind stempel-/lagerseitig nicht zuordbar und
      duerfen bis dahin nicht in den gemeinsamen Lager-Skip.

---

## 9 Offene Rueckfragen an Infra (im Handout gestellt)

1. **Massgebliche Fassung der "Cluster gitlab runner Beschreibung":** Der Owner-Auftrag bezieht sich woertlich
   auf diese Beschreibung. Auffindbar sind (a) das 12-Runner-Layer-Doc
   `Cluster/docs/sessions/20260225-00-00-003061-staged-build-pipeline-12runner-layer-assignments.md` (Feb 2026)
   plus `...-003059-exotic-runner-macos-gitlab-dbfix.md` und (b) die deutlich neuere Voll-Erhebung
   `2026-07-26-INFRA-runner-matrix-DONE.md` §A. **Welche gilt als Soll?** Ohne diese Festlegung ist "alle
   geplanten Runner" nicht pruefbar.
2. **Tag-Schema:** Bestaetigung oder Korrektur von `riscv64` / `macos-arm64` / `macos-x86-64` (Abschnitt 4),
   inkl. Disjunktheits-Pruefung.
3. **Poll-Verhalten:** Verifikation + literaler Config-Beleg (Abschnitt 7).
4. **Nachaktivierung:** Welche der geplanten Runner sind heute nicht registriert/aktiv, und was blockiert sie
   (Hardware, Netz, Toolchain)? Der Owner-Auftrag lautet ausdruecklich "Ansonsten aktiviere das bitte
   nachtraeglich". Konkret offen: node5, node6, node8-Tag, id14 (tot seit 06-22), id6-id9 (stale).
   **node7 ist hier bewusst herausgenommen** -- der Strang ist durch K118f/K118g teil-beantwortet (siehe 3.1);
   offen ist dort nur noch die Stabilitaets-Bestaetigung ueber Stunden und die Frage nach dem zweiten
   arm64-Linux-Runner (#394/#78).

---

## 10 Belege (literal)

```
[CI-TRACE] prod1, 2026-08-02:
2026-08-02T13:20:08.757133Z  Running with gitlab-runner 19.1.1 (24b9b726)
2026-08-02T13:20:08.757146Z    on prod-baremetal-prod1 <runner-kurz-id redigiert>, system ID: s_409f14fb9041

[CI-TRACE] prod2, 2026-08-02:
2026-08-02T13:23:24.289148Z  Running with gitlab-runner 19.1.1 (24b9b726)
2026-08-02T13:23:24.289162Z    on prod-baremetal-prod2 <runner-kurz-id redigiert>, system ID: s_0899959f8a36
2026-08-02T08:06:27.543765Z  Running with gitlab-runner 19.1.1 (24b9b726)
2026-08-02T08:06:27.543810Z    on prod-baremetal-prod2 <runner-kurz-id redigiert>, system ID: s_0899959f8a36

[INFRA] Cluster 2026-07-26-INFRA-runner-matrix-DONE.md (Voll-Erhebung per Admin-API):
  id16 prod-baremetal-prod1 | Ubuntu (shell) | online | prod, baremetal, amd, amd64, avx2,
       avx512(+12 sub-flags), x86_64 | concurrent=3 / 10 Thr (normal)
  id17 prod-baremetal-prod2 | Ubuntu (shell) | online | prod, baremetal, intel, amd64, avx2
       | concurrent=2 / 12 Thr (normal)
  id15 prod-k8s-talos-runner | online | prod, kubernetes, talos | concurrent=3
  Stale/tot: id2 node5-macintel, id3 node6-macarm, id6 pve1, id7 pve2, id8 node3, id9 node4,
       id13 zih-barnard, id14 prod-k8s-x86-main (tot seit 06-22)
  Online ausserhalb prod1/2: id4 node7-rpi5, id5 node8-visionfive,
       id52 laptop-benja-windows-repro (locked)

[INFRA] Cluster 2026-07-27-INFRA-node7-diskgc-runner-contention-B1-VOLLZUG.md:
  "node7 als einzigem online arm64-Linux-Runner bei concurrent=1 strikt seriell"
  "echter zweiter arm64-Linux-Runner noetig (#394/#78)"

[INFRA] Cluster 2026-08-02-K118d-SWEEP-6-DIAGNOSEN-node7-AUSFALL-...md (~14:05, SUPERSEDED
        als node7-Ist durch K118f/K118g):
  "NEUER TOP-BLOCKER: node7/Pi5 ist AUSGEFALLEN ... Ausfallzeitpunkt exakt belegt:
   2026-08-02 13:00:03 CEST" (#536; TCP 0/10 auf :22, ICMP intermittierend)

[INFRA] Cluster 2026-08-02-K118f-node7-ROOT-CAUSE-sysvol-sync-backups-abgeschaltet.md:
:28   "*/15 * * * * /usr/bin/flock -n /tmp/sysvol-sync.lock
       /usr/local/bin/samba-sysvol-sync.sh >/dev/null 2>&1"   (node7-User-crontab, uid 1000)
:32   "Die 15-Minuten-Kadenz deckt sich exakt mit dem beobachteten Muster und mit der
       ~9-12-Minuten-Lebensdauer je Boot."
:62   node7-crontab: 3 Jobs deaktiviert - "samba-sysvol-sync (der Crash-Kandidat)",
       backup-freshness-check, cluster-dr-bundle; root-crontab: 11 Jobs deaktiviert
:57   "Zeilen mit '#K118-DISABLED ' praefixiert => zeilenweise reversibel, nichts geloescht."
:68   "Zustand nach der Abschaltung: uptime 290 s, Mem: 7937 total / 747 used / 5716 free"
:81-84 "Der Zusammenhang 'SYSVOL-Sync -> Absturz' ist stark indiziert ..., aber nicht bewiesen."
       "Der Gegenbeweis steht aus: Bleibt node7 jetzt, mit abgeschalteten Backups, ueber
        Stunden stabil?"

[INFRA] Cluster 2026-08-02-K118g-KOORDINATION-offene-straenge-priorisiert.md:
:9    "node7: ueberlebt seit Backup-Abschaltung 23+ min (vorher ~9-12) -> Owner-OOM-These
       bestaetigt. Ursache-Kandidat = samba-sysvol-sync ... Backups alle aus (14 Jobs,
       reversibel). Persistentes Journal aktiv. Beobachtung laeuft. (#536)"
:19   Board #536: "Ursache gefunden, Backups aus | Stabilitaet ueber Stunden bestaetigen"

[INFRA] Cluster 2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md (Live-lscpu auf dem
        prod2-Bare-Metal-Host 10.0.10.212; Antwort auf unsere Rueckfrage O-4a):
:10-12 cpu family 6 | model 151 | stepping 2
:13    model name  "12th Gen Intel(R) Core(TM) i9-12900K"
:15    "(= Alder Lake; deckt sich mit dem dokumentierten CPU-Tausch i9-14900KS -> i9-12900K.)"
-> #276 :14 (i9-14900KS) ist pre-RMA-stale; Thesis nachgezogen in b224628 (KATALOG :55).

[INFRA] Cluster 2026-08-02-K118c-node5-RECOVERY-RUNBOOK-drei-wege.md:
  "#243-Korrektur: node8 ist online (10.0.60.208, :22 offen) - entgegen Doku/Board;
   RISC-V-Zelle evtl. schneller reaktivierbar"

[CI-YAML] ce .gitlab-ci.yml:
:116   tags: [baremetal, amd]      (pmc:amd)
:122   tags: [baremetal, intel]    (pmc:intel)
:134   tags: [arm64]               (build:arm64-smoke, allow_failure: true,
                                    rules: $COMDARE_ISA_MATRIX == "true")

[CI-YAML] super .gitlab-ci.yml:
:123   tags: ["$SWEEP_TAG"]          (runner:sweep-zombies, API-Trigger)
:645   tags: [prod, baremetal, amd]  (measure:smoke)
:727   tags: [prod, baremetal, amd]  (measure:golden-320)

[CODE] ce system_axis_registry.xml:
:10    <axis id="target_isa" ... baustein_count="2">
:11    <baustein name="x86_64" ... native="true"/>
:12    <baustein name="aarch64" ... triple="-target aarch64-linux-gnu"/>
:41    <axis id="operating_system" ... baustein_count="3">
:42-44 <baustein name="linux"/> <baustein name="windows"/> <baustein name="macos"/>
:45-47 <sub_axis id="os_version"/> <sub_axis id="kernel"/> <sub_axis id="build"/>

[CODE] ce cmake/platform_detection.cmake (Ableitungsweg 2, nativer Bau -- Abschnitt 5.1):
:31    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^riscv64$")
:32        set(COMDARE_ARCH "riscv64")
:33        set(COMDARE_ARCH_RISCV64 ON)

[CODE] ce libs/cache_engine/axes/simd/ (Ableitungsweg 3, Organ-Achse 09 -- Abschnitt 5.1):
axis_09_isa_flags.hpp.in:6   #cmakedefine01 COMDARE_AXIS_09_USE_RISCV
axis_09_isa_riscv.hpp        class RiscVIsa : public IsaStrategyBase<RiscVIsa>   (RV64GC)
                             static constexpr bool enabled = flags::riscv_enabled;
```

Die Runner-Kurz-ID aus der Trace-Kopfzeile ist redigiert (Token-Praefix-Charakter); Runner-Name, Zeitstempel,
Version und System-ID reichen als Ist-Beleg.

---

**Ende `docs/infra/I112_RUNNER_FLEET_IST_SOLL_ALLE_ARCHITEKTUREN.md` (Stufe 1).
Nachtrags-Stufe: Abschnitt 8, nicht gate-relevant.**

*Dateiname-Historie: bis 02.08. lag dieses Dokument unter `docs/infra/I112-fleet-matrix.md`; per `git mv` auf den
Design-Dossier-Namen und die gelebte I-Serien-Konvention (`I77_`, `I109_`, `I111_`) gezogen. Der alte Pfad wird in
aelteren Session-/Backup-Dokumenten weiter zitiert und dort bewusst NICHT nachgeschrieben (Doku wird nicht
umgeschrieben, nur fortgeschrieben).*
