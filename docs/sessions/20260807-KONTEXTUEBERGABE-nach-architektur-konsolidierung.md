# KONTEXTUEBERGABE 07.08.2026, ~00:45 — nach der Architektur-Konsolidierung

**ERST-ANKER.** Wer hier weitermacht: **diese Datei zuerst**, dann Ledger-Nachtrag **abend-4**
(die zwoelf Architektur-KERNe), dann `docs/sessions/20260807-BILANZ-vergessene-arbeit.md`.

---

## 1. DER STAND — alle sechs Refs gleichauf, verifiziert

| Repo | development | main | Pipeline |
|---|---|---|---|
| **ce** (286) | `54106bc9` | `54106bc9` | 15139 **gruen** (19 success + 1 manual) |
| **super** (288) | `2871fabf` | `2871fabf` | 15141 **gruen** (14/14 + Bridge gruen) |
| **thesis** (289) | `19e1592` | `19e1592` | gruen |

**Die Kette T-1 ist vollstaendig vollzogen**, zum ersten Mal in der richtigen Reihenfolge:
Pipeline verifizieren -> main-FF -> Submodul-Bump -> super-Pipeline -> super-main-FF.
Die `trigger:cache-engine`-Bridge ist gruen — der Trigger baut den **aktuellen** ce-Stand.

---

## 2. WAS HEUTE NACHT GELANDET IST

| SHA | Paket |
|---|---|
| ce `bba4d90f` | **M-1 Identitaets-Naht** — die Mess-Achse bekommt Wirkung (D-1/D-4/D-2 + vier Restluecken) |
| ce `c4c04315` | **PMC-L3-honest** — der stille Rueckfall auf 0 ist beendet |
| ce `54106bc9` | **M-1h-CI-Heilung** — lint:format whole-file + falsches pmc-Label |
| super `1aba34f8` | Drei Wellen-Dokumente, die auf KEINEM Zweig lagen (2433 Z.) |
| super `5a98036d` | Infra-Handout **P-6**: `amd_l3`-Uncore-PMU nicht geladen |
| super `cabba179` | ce-Bump, vier Merges nachgezogen |
| super `2871fabf` | `.gitignore` fuer die Mess-Bau-Ordner (Befund W-6 widerlegt) |

**Der wichtigste Einzelbefund aus M-1:** Das **Preimage-FORMAT aendert sich NICHT** — die drei
ABI-Dateien sind sha256-identisch zu development. Der urspruenglich geplante Format-Bump 3->4
war **unnoetig** und haette im schlimmsten Fall 34,4 h Neubau ausgeloest.

---

## 3. WAS OFFEN IST — nach Dringlichkeit

### O-1 — DIE MODUL-AUSGABE (beim Owner)
Der Owner laedt `amd_uncore` auf prod1. **Diese Maschine IST prod1** (`127.0.1.1 prod1`).
Modul vorhanden (`/lib/modules/6.17.0-35-generic/kernel/arch/x86/events/amd/amd-uncore.ko.zst`,
signiert, keine Abhaengigkeiten, nicht geblacklistet), CPU Family 26 (Zen 5) wird unterstuetzt,
`perf_event_paranoid = 1`. **`amd_l3` fehlt in `/sys/bus/event_source/devices/`.**

```
sudo modprobe amd_uncore && ls /sys/bus/event_source/devices/ | grep amd
perf stat -e amd_l3/event=0x04,umask=0xff/ -a -- sh -c 'dd if=/dev/zero of=/dev/null bs=1M count=4096'
echo amd_uncore | sudo tee /etc/modules-load.d/amd-uncore.conf
```

**Der Lead kam ans sudo-Passwort NICHT heran** — 29 Vault-Kandidaten plus der unterste Wert,
keiner akzeptiert. Weiter zu raten riskiert `faillock`. Der Vault trennt AD-Realm-PWs vom
lokalen Login; das aktive `admin-management`-PW aus der K105-Rotation ist nicht als reiner
String auffindbar.

**Wenn `amd_l3` erscheint und die Gegenprobe != 0 liefert:** `linux_perf_pmc_source.hpp` oeffnet
L3 heute ueber den generischen `PERF_TYPE_HW_CACHE`, der auf Zen 5 mit `errno=2` scheitert. Mit
`amd_l3` braeuchte es den PMU-Typ aus `/sys/bus/event_source/devices/amd_l3/type`. **Einschraenkung,
die in den Anhang gehoert:** Uncore-PMUs zaehlen **maschinenweit**, nicht prozesslokal — das ist
eine andere Groesse als die per-Core-Zaehler `l1`/`dtlb` und muss ausgewiesen werden.

### O-2 — DIE DREI NUMA-LUECKEN (beim Teammate, GO erteilt)
Branch `b-numa-cpu-pin-process-probe` (`b1753926`), Basis `2b5ecd29`, 18 Dateien, +2800/-33.
**Gesichert:** `refs/rescue/20260807-numa-cpu-pin-umbenannt` auf beiden Remotes.
- **L-1:** `CoreTopologySource` kennt nur `HybridPmu/L3Domaene/Homogen` — luegt auf Windows/macOS.
- **L-2:** Kopfkommentar `:25` sagt "keine prozessfreie Schnittstelle" fuer macOS, das eigene
  macOS-Blatt liest sie ueber PERFLEVEL-sysctls. **Einer von beiden ist falsch.**
- **L-3:** Stufe 2 (`:360-363`) prueft nur `adjacent_find` INNERHALB der Listen — keine
  Kreuzpruefung, obwohl der Kommentar "ein Kern in zwei Domaenen" nennt. **Biss ist Pflicht.**

**ACHTUNG — das Paket ist ueber ZWEI Repos gesplittet:** die super-Haelfte
(`Code/test_data_xml/experiment_schema.xsd`, +24 Zeilen `core_class`) liegt auf **keinem Zweig**,
nur im super-Arbeitsbaum. Als Patch gesichert unter
`backups-workflow/20260807-ungesicherte-arbeit/experiment_schema.xsd-core_class.patch`.
**Beide Haelften zusammen landen.**

### O-3 — DAS GESAMT-DOSSIER (Welle laeuft, Task `wktkhd1cj`)
80 Seiten aus dieser Session. **Quelle sind die 77 Wellen-Journale mit 250 result-Ereignissen**
(`subagents/workflows/*/journal.jsonl`, 3,76 MB) — nicht die verdichteten .md. Der erste Anlauf
kannte sie nicht und wurde deshalb gestoppt und neu gestartet.

### O-4 — OWNER-ENTSCHEIDE, unbeantwortet
1. **Zwei Falschaussagen in der Abgabe** (`docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md`,
   Abschnitt 1): **F-01 Talos** ("jede Messung unter zwei Betriebssystem-Regimes", 0 Treffer im
   Code, kein Limitierungs-Punkt entlastet — Empfehlung: Aussage zuruecknehmen, <1h) und
   **F-02 `flat_hash_map`** (in der GESETZTEN Aufgabenstellung namentlich zugesagt, im Code nur
   eine eigene SwissTable-Reimplementierung).
2. **Sechs Planungs-Rueckfragen** (Owner: *"Dann gerne Rueckfragen um die Planung zu
   vervollstaendigen, weil diese Plaene 6 Wochen alt sind"*): welche Aufrufe auf Ebene 1 getimt
   werden [F1] · ob die Messung ans Pruefdock wandert [F2] · Break-Even je Ebene? [F3] · was
   "Orchestration ueber das Lager" umfasst [F4] · wo die Schaltlogik lebt (CT oder Lager-Laufzeit)
   [F5] · ob ein Parameter je Kanal reicht [F6]. **KORREKTUR: nicht alle sechs unbeantwortet.**
   Laut Explore-Bericht `acd614d772b8ecb00.md` (Zusammenfassung Z.112-119) sind **vier
   dokumentiert**: F1 jeder Achsenaufruf in der Tier-Binary (`ROH:7716/7761`), F3 Break-Even
   **pro Ebene** (`PLAN-BREAK:334-339` -- am Objekt verifiziert), F5 Schaltlogik als
   **CT-Chain-of-Responsibility** (`PLAN-KURVEN:250-252` -- am Objekt verifiziert), F6 **mehrere**
   Optima je Last-Kanal (`ROH:7601/7603`). **Wirklich offen** sind nur: F4 -- die Phrase
   "Orchestration ueber das Lager" (0 Treffer im Session-Log; Substanz = Rueckschreiben in den
   Hybrid DEFERRED #156) -- plus je EIN Restentscheid bei F2 (Messpunkt **wandert vs. testiert**)
   und F5 (**CT-Einbau vs. RT-Tausch**).
3. **Faktorisierung der Core-Achse:** Betreuer-Plan nennt `{P|E} x {Single|All}` + Referenz;
   das Achsen-Dossier nennt `{Unpinned|PCoresOnly|ECoresOnly|HybridAware}`. **Nicht dasselbe.**
4. **Runner-Token-Rotation** — an Infra abgegeben (Handout I113), unerledigt.

### O-5 — VOR DER MESSUNG faellig
- Getrennte Ablage je PMU-Domaene im CSV-/Lager-Schema
- RAW-Events je Mikroarchitektur (Deep-Research-Pflicht)
- Die Bau-Menge ist unbekannt: **131.072 / 524.288 / 2.097.152**, Faktor 16, keine gemessen.
  `<run_options cap="131072"/>` ist NICHT pauschal dekorativ -- die Vorlage-Aussage "kein Parser
  liest es" ist zu weit. Im `comdare_thesis_profile`-Zweig parst der Parser `cap` (ce 54106bc9,
  `libs/common/serialization/xml_config_parser/xml_config_parser.cpp:426`,
  `tp.run_options.cap = to_int(...)`) UND wendet es an: `profile_run_options`
  (`profile_runner.hpp:148`) reicht es an `profile_effective_cap` (`profile_runner.hpp:163`, Aufruf
  `profile_run_entry.hpp:388`), das die Basis-Zellen-Selektion auf `min(cap, basis_count)` aufloest
  (Semantik dokumentiert `algorithm_profiles/thesis_profiles/SCHEMA.md:41`: `cap="N"` = genau N
  Basis-Zellen, auf die Basis-Zellen-Zahl geklemmt; `cap="0"`/fehlend = KEIN Cap). NUR im
  `comdare_experiment`-Zweig (`parse_experiment_profile`, ab `:448`) wird `run_options` gar nicht
  gelesen -- alle 8 `run_options`-Zeilen der Datei stehen in `:424-432`, innerhalb
  `parse_thesis_profile`. Einschraenkung/Beleg-Nenner: `cap` steuert die Zahl der SELEKTIERTEN
  Basis-Binaries; ob der konkrete Wert 131072 N tatsaechlich verkleinert, haengt per `min` an der
  Basis-Zellen-Zahl -- auch der Vorlage-Zusatz "kappt aber nichts / No-op" trifft also nur einen
  Grenzfall, nicht den Mechanismus.

---

## 4. DIE ZWOELF ARCHITEKTUR-KERNE — Kurzform (Volltext: Ledger abend-4, 489 Z.)

```
[PLANER]  laeuft (RT)  prueft Faehigkeiten, gibt frei, bewegt Unter-Achsen -> baut
[CEB]     laeuft (RT)  traegt CT die freigegebenen Routinen einkompiliert   -> baut
[HYBRID]  laeuft (RT)  Schaltungs-Adapter: waehlt je Last-Kanal             -> baut
[TIER]    laeuft (RT)  das gemessene Objekt

MESSUNG -> FUNKTIONS-SYNTHESE -> SCHNITT-KURVEN (break even) -> optimale Konfiguration
        == die zu WAEHLENDE Binary -> zurueck in den HYBRID als Schaltlogik
```

- **Merksatz:** *der Planer FRAGT (RT), die CEB TRAEGT (CT), die Tier-Binary LAEUFT (unveraendert).*
- **Drei Typen = drei Achsen-Arten.** Mess DREIPHASIG (startet ein Glied frueher, im Planer),
  System und Organ ZWEIPHASIG. Das ist der Grund der Fortpflanzungs-Asymmetrie.
- **PMC ist eine MENGE je Maschine.** P-Core und E-Core getrennt gemessen UND getrennt
  ausgewertet; prod2 (i9-12900K) hat **zwei** PMU-Domaenen, prod1 eine.
- **EINE CEB, EINE Tier-Binary, zwei Pinnings** — Permutation, kein zweiter Bau. Objekt-Beleg:
  `target_isa` traegt `binary_id="never"`.
- **Wallclock-Verortung:** Micro -> **zusaetzlich IN der Tier-Binary einkompiliert**;
  Macro und large scope -> **in der CEB**.
- **Schwere-Leiter:** `warn` (Wert existiert, Verwendbarkeit fraglich — Text woertlich
  `warn: no pinned locality on hybrid architecture`) · `error` (fehlende grundlegende
  Systemeigenschaft, z.B. XML verlangt GPU ohne GPU) · `fatal` (Integritaet zerstoert:
  Kabelabriss, Speicherverlust, **Lager-Inkonsistenz**).
- **Stiller Rueckfall ist verboten** — er ist die BAUFORM hinter der Dossier-These.
- **Break Even** ist die operative Form von **H2** ("keine universell beste Seitendarstellung"):
  die Frage ist nicht "welche ist die beste", sondern **"ab wo ist welche besser"**.
- **Arbeitsteilung:** `break_even.hpp` = die Mathematik (Fritsch-Carlson, monotonieerhaltend,
  damit keine SCHEIN-Schnittpunkte entstehen); `best_binary_selector` = die **Orchestrierung
  ueber das LAGER**. Kein Konflikt — zwei Rollen.

**QUELLEN-RANGFOLGE (korrigiert):** 1. **die Diplomarbeit** (sechs eingebundene Kapitel +
gesetzte Aufgabenstellung) = geltende Spezifikation · 2. Ledger/Plaene **nach Datum** ·
3. `docs/termine/` = **Historie**, wochen alt. *"Der neuere Stand schlaegt den alten."*

---

## 5. DIE FALLEN — jede real eingetreten

1. **Stille Nullen (3x):** gitleaks ueber ein Submodul meldet `no leaks found` bei
   `0 commits scanned` — `.git` ist dort ein Zeiger. **Elternrepo mounten**, Nenner lesen.
2. **Case-sensitiv gegen VERSALIEN:** "0 dreiphasig-Treffer" gemeldet, real 8. **Immer `-i`.**
3. **`grep -v "/build"` frisst `/builder/`** — explizite Verzeichnislisten.
4. **Gefiltertes grep verschluckt das Verdikt:** `DIFF-HYGIENE:` trifft `DIFF-HYGIENE-WACHE:`
   nicht. **Wachen-Ausgabe VOLLSTAENDIG lesen.**
5. **Lokaler `main` ist im Hauptklon veraltet** — gegen `origin/main` messen.
6. **Nicht in den Branch einer laufenden Welle committen** — ueber eigene Worktrees landen
   (`wt-landung`, `wt-super-landung`).
7. **Ein Befund traegt sein Erhebungsdatum** — vor der Handlung gegen den heutigen HEAD messen.
8. **NEU: ein rescue-Ref ALTERT, wenn der Branch weiterwandert.** Der numa-Umbenennungs-Commit
   `b1753926` lag auf **keinem Remote**, weil der Ref auf den Stand davor zeigte.
9. **NEU: ein lokales Gate ist keine Pipeline.** M-1 wurde gelandet, bevor die Pipeline durch
   war — drei Jobs fielen. `git-clang-format` prueft den **Diff**, `lint:format` **whole-file**.
10. **NEU: die Verifikation der Konsolidierungs-Welle vergessen.** Sie hatte das
    Regressions-Dossier bereits um 896 Zeilen erweitert; 2 Stunden ungesichert.

---

## 6. WORKTREES — nicht aufraeumen

`wt-landung` · `wt-super-landung` (die Landungs-Worktrees) · `wt-numa-cpu-pin` (`b1753926`) ·
`wt-m1h-ci-heal` · `wt-pmc-l3-honest` (gelandet, kann weg) · `wt-numa-process` (Vorgaenger).

## 7. SICHERUNGEN AUSSERHALB DES REPOS

- `backups-workflow/20260806-session-transkript/session-5a19728e-ROH.jsonl` — 33 MB, ganze
  Session, unrediglert
- `backups-workflow/20260807-ungesicherte-arbeit/` — die drei Plandokumente, der
  XSD-`core_class`-Patch, `measure_out_d03` (3,9 MB)
- `backups-workflow/20260806-pause-wip/pmc-l3-honest-WIP.patch`
- `backups-workflow/QUARANTAENE/bnpj776mm.output` — die 390 Runner-Token (0600), **nie ins Repo**

Im Repo: `docs/sessions/backups/20260806-session-transkript-verbatim/` (rediglert, 3847 Z.,
ab der vorletzten Kompaktierung — dort steht der WORTLAUT aller Owner-KERNe).

## 8. DIE NEUN ANALYSE-DOKUMENTE DIESER SESSION

`DOSSIER-regressionen-checkheft` (2486 Z., Kapitel VI+VII) · `UEBERBLICK-workflow-ergebnisse`
(677) · `ANKNUEPFPUNKTE-vorarbeit-je-aufgabe` (1350) · `KANON-termine-plan-soll-gegen-ist` (894) ·
`DIFF-thesis-soll-gegen-ledger-und-code` (863) · `PLAN-warnungen-und-ausgabe-bei-messfehlern`
(848) · `PLAN-break-even-und-drei-benchmark-ebenen` (825) · `KLAERUNG-zweiphasig-dreiphasig-drei-typen`
(632) · `DOSSIER-messachse-wallclock-und-mess-kette` (436) · `BILANZ-vergessene-arbeit`.
Dazu `ANWEISUNG-pmc-intel-perf-rechte` (622) · `PLAN-hybrid-architektur-pmc-achsen-zuordnung`
(1043) · `PLAN-messkurven-synthese-und-hybrid-binary` (768).

## 9. ZUGANG

PAT blind aus `Cluster/keys/CREDENTIALS-VAULT-{DEV,PROD}.md` per
`grep -hoE 'glpat-[A-Za-z0-9._-]{15,}'`, **RUECKWAERTS** gegen `GET /api/v4/user` testen bis
HTTP 200 (**Position rotiert, nie hartcodieren** — heute traf Kandidat 7 von 8).
CA `Cluster/keys/gitlab-ca-ROOTCA-20260621.crt` · Host `gitlab.comdare.local` ·
IDs ce 286 / super 288 / thesis 289. Werte **nie** ausgeben, 0600-curl-config mit `-K`,
bei Pause shreddern.
