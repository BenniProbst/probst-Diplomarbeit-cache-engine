# PLAN 06.08.2026 -- DER BAU-PLAN FUER DIE MESS-KETTE (CEB <-> ObservableTier)

> **STATUS: PLANUNG. Kein Edit, kein Commit, kein Push, kein Worktree unter `/home/comdare/wt-*`
> beruehrt.** Dieses Dokument ist die Lead-Synthese der drei Deep-Research-Scopes des Abends
> (Phasen-Fortpflanzung / PMC-ins-Pruefdock / ObservableTier-Audit) zu **einem ohne Rueckfrage
> ausfuehrbaren Bau-Plan**.
>
> **VORLAUF (Owner-Dauerregel "zuerst Planung und Ledger, dann Code") eingehalten:** Ledger
> (6169 Zeilen, Nachtraege rueckwaerts, neueste ab Z.4202) -> `docs/plaene/` (40 Dokumente, darunter
> die vier heutigen) -> `docs/sessions/` inkl. `backups/*/` -> `docs/architektur/` -> Memories unter
> `/home/comdare/.claude/projects/-home-comdare/memory/` -> **erst danach der Code.**
>
> **Alle Zaehlungen mit `/usr/bin/grep` absolut** (in dieser Shell ist `grep` eine Funktion auf
> ugrep -- Regel R-1 des Checkhefts). Jede Zahl mit Bezugsgroesse. Was ich nicht selbst gemessen
> habe, steht als `[BERICHT]` oder `UNBELEGT` -- nicht weggelassen.

---

## 0. STAND, ABGRENZUNG, METHODIK

### 0.1 Der Stand, den ich selbst gemessen habe

| Gegenstand | Wert | Messmittel |
|---|---|---|
| super `HEAD` (lokal, Arbeitsbaum) | **`699edaa2`** | `git rev-parse HEAD` |
| super `origin/development` | `77993f6e` -- **HEAD ist 1 Commit VORAUS, ungepusht** | `git ls-remote origin`; `rev-list --count origin/development..HEAD` = 1, Gegenrichtung 0 |
| super `origin/main` | `5534c23c` -- **12 Commits main-FF-Rueckstand** | `rev-list --count 5534c23c..HEAD` = 12 |
| ce Checkout == `origin/development` | **`b241a272`** | `git -C <ce> rev-parse HEAD` + `git ls-remote origin` |
| ce `origin/main` | `47c4ef1d` -- **6 Commits main-FF-Rueckstand** | `rev-list --count 47c4ef1d..b241a272` = 6 |
| **super-Gitlink auf ce** | **`47c4ef1d`** -- **6 Commits hinter dem Checkout, uncommittet** | `git ls-tree HEAD Code/external/comdare-cache-engine` |
| Richtung des Gitlink-`M` (Regel 8) | **vorwaerts** (`47c4ef1d` ist Vorfahr von `b241a272`) | `merge-base --is-ancestor` |
| `.fingerprint`-Sidecars im gesamten super-Baum | **0** | `find . -name "*.fingerprint" -not -path "./.git/*" \| wc -l` |
| `perm_*.so` im Baum | **90** (Test-Fixtures/Alt-Baeume, **keine** golden-Flotte) | `find . -name "perm_*.so" -not -path "./.git/*" \| wc -l` |

**Korrektur gegen den Auftrags-Kopf:** der Auftrag nennt ce `47c4ef1d` und super `72eab9ae`. Beide
Repos sind seitdem weitergelaufen (ce +6, super +5 gegenueber `72eab9ae`). **Alle Datei:Zeile-Angaben
unten sind an `b241a272` / `699edaa2` nachgelesen**, nicht aus den Scope-Berichten uebernommen. Wo eine
Zeile gegenueber einem Scope-Bericht gewandert ist, steht die Drift ausdruecklich dabei (N-2:
Zeilenangaben altern).

### 0.2 Was dieses Dokument NICHT wiederholt

Drei Plaene des heutigen Tages decken Teilmengen ab. Dieses Dokument **verweist** und
**widerspricht, wo es widerspricht** -- es dupliziert nicht:

| Dokument | Deckt | Verhaeltnis zu diesem Plan |
|---|---|---|
| `docs/plaene/20260806-PLAN-p-pmc-1-messkette.md` (651 Z.) | Das PMC-Flag als Invariante (B1/B2), die vier fail-open-Wachen, die Spalten-Bilanz, `branch_misses` | **Uebernommen als Paket M-2.** Sein Erhebungsstand ist `e7aa1244` -- **zwei Landungen alt**; ich habe seine sechs tragenden Fundstellen an `b241a272` nachgemessen (alle bestaetigt, eine Zeilendrift, s. 1.3 Fussnote). |
| `docs/plaene/20260806-PLAN-owner-antworten-vertiefung.md` (695 Z.) | Die Rueckfragen R-1..R-6, die Paketkarte B-A..B-U, die Disjunktheits-/Konflikt-Analyse K-1..K-7 | **Uebernommen als Rahmen.** Dieser Plan **schaerft** seine Neubau-Bilanz (Abschnitt 3) und **korrigiert** eine ihrer Annahmen (3.4: PMC ist CEB-only, nicht flotten-wirksam). |
| `docs/sessions/20260806-DOSSIER-regressionen-checkheft.md` (629 Z.) | Die 10 Regeln + 25 Befunde + Termin-Klassen T1..T4 | **Termin-Klassen uebernommen** (0.4). |

### 0.3 Die Owner-KERNe dieses Abends, als Pruefliste

Sechs KERNe loesen diesen Auftrag aus. Jeder bekommt unten eine Zeile in der Abstands-Tabelle (1.3)
und einen Bau-Posten (Abschnitt 2). **Keiner wird gestrichen.**

| KERN | Owner-Satz (Kurzform) | Bau-Posten |
|---|---|---|
| **(A)** | Mess-Achsen-Aenderung erzwingt Neubau von CEB **und ALLEN** Binaries; Vertrag CEB vs Tier / CEB vs Tier-Hybrid beachten. *"Das ist eine Gedaechtnisluecke."* | **M-1** (Identitaets-Naht) |
| **(B)** | *"PFLICHT, dass das gemessen wird, was gemessen werden kann"* -- PMC **muss in die CEB fuer deren Pruefdock**. *"NIE abkuerzen, immer mit deep research fixen."* | **M-2** + **M-4** |
| **(C)** | Der ObservableTier-Vertrag ist **FALSCH implementiert**; *"der Einbau in die CEB und deren Orchestration der Konstruktion in die Tier-binaries und Hybrid ist FALSCH"*; *"DAS IST DIE KERN Achse des Planers und wird nicht gestrichen."* | **M-1** + **M-5** |
| **(D)** | L2/L3/Kohaerenz *"gehoert in die Messachse und wird durch die CEB einkompiliert nach Planer Freigabe ... direkt nachruesten nach Plan. PFLICHT und KERN der ANLAGE."* | **M-3** |
| **(E)** | *"Mess-Achsen + System-Achsen + Organ-Achsen identisch -> fingerprint fuer identische binary fuer identische Messdaten."* -- Hauptidee des Systems und des Lagers. | **M-1** |
| **(F)** | *"nur weil sie kompiliert werden sollten, heisst es nicht dass sie auch gemessen werden muessen, das muss die XML getrennt fuer build und Messung definieren koennen sonst regression."* | **M-6** |

### 0.4 Termin-Rahmen (bindend, aus der Owner-Korrektur des Abends)

**Endtermin 15.09.2026. Woechentliche Lieferung jeden Freitag.** Von mir nachgerechnet:

    Heute        Do 06.08.2026
    Endtermin    Di 15.09.2026        =  40 Tage
    Freitage     07.08 / 14.08 / 21.08 / 28.08 / 04.09 / 11.09   =  6 Liefertage

**BEFUND, klein aber lesewirksam:** die aelteren Plandokumente schreiben durchgaengig *"Trigger Do
07.08., Abgabe Fr 08.08."* -- **beide Wochentage sind falsch**: der 07.08.2026 ist ein **Freitag**,
der 08.08.2026 ein **Samstag** (`date -d`). Wer die alten Plaene nach Wochentag liest, verschiebt
sich um einen Tag. **Der "morgen" des Owner-Auftrags ist Fr 07.08. -- also zugleich der ERSTE
Liefertag der neuen Kadenz.** Das ist kein Zufall und praegt Abschnitt 4.

Termin-Klassen wie im Checkheft (`docs/sessions/20260806-DOSSIER-regressionen-checkheft.md:31`):
**T1** = vor dem ersten 4096er-Batch ·
**T2** = vor der Voll-Messung · **T3** = vor dem 15.09. · **T4** = danach.

---

# 1. DIE KONSOLIDIERTE LAGE

## 1.1 DER PLAN -- die Mess-Kette, wie sie definiert ist

Der Plan ist an **vier** Stellen kanonisch und widerspruchsfrei. Alle vier sind Owner-verbatim oder
Owner-abgenommen.

### (P-1) Die Stufen-Doktrin -- die Antwort auf "DREIPHASIG / ZWEIPHASIG"

**Owner verbatim, `LEDGER:4082` (Nachtrag 05.08. mittag-9):**

> "Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind ZWEISTUFIG symmetrisch und die
> Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei die erste stufe immer Runtime Freigabe und die
> nachfolgenden Stufen compile time Einbau sind Planer->CEB-TierBinaries. Wenn wir die Hybriden
> betrachten und sie als vierte Stufe eingeschoben sind, erben sie ALLE Eigenschaften vorausgegangener
> Stufen und geben die Eigenschaften der Mess-Achse an ihre Tier-Binaries zur compile Zeit weiter"

**Owner-Abnahme, `LEDGER:4095` (mittag-11):** *"Jetzt ist alles korrekt, wie du es beschrieben hast
… Volles go, jetzt ist alles perfekt von dir verstanden hier in der Session"*

Kanonische Form, `LEDGER:2253` / `:4083`, **mit dem Pruefdock namentlich darin**:

| Achsen-Art | Stufigkeit | Kette |
|---|---|---|
| **MESS** | **DREISTUFIG, dehnbar** | Planer (1: **RT-Freigabe**) -> **CEB (2: CT-Einbau -- Mess-Design + PRUEFDOCK-KONFIGURATION)** -> [Hybrid (CT)] -> Tier (3: CT-Einbau -- Observer/Ausstattung) |
| **SYSTEM** | **ZWEISTUFIG, dehnbar** | CEB (1: RT-Freigabe) -> [Hybrid (CT): gibt sich SELBST und seinen Tiers die System-Config CT mit] -> Tier (2: CT-Einbau) |
| **ORGAN** | **ZWEISTUFIG, hybrid-unberuehrt** | CEB (1: RT-Freigabe) -> Tier (2: CT-Einbau); Organ-Achsen sind **NUR in Tier-Binaries verbaut** |

**Gesetz (`LEDGER:4083`, woertlich):** "Die ERSTE Stufe ist IMMER Runtime-Freigabe in der
Traeger-/Freigabe-Binary, alle NACHFOLGENDEN Stufen sind Compile-Time-EINBAU entlang der Kette
Planer->CEB->Tier-Binaries."

**Warum die Mess-Achse die einzige ist, die nach OBEN durchschlaegt:** sie ist die einzige mit einer
Stufe **VOR** der CEB. System und Organ starten erst **in** der CEB -- ihre Stufe 1 ist eine
Laufzeit-Freigabe der CEB selbst. Eine System-Achsen-Aenderung baut also die Tiers neu, **nicht** die
CEB. Eine Mess-Achsen-Aenderung baut **beides** neu. Das ist genau die Asymmetrie in Owner-KERN (A).

**Die Vokabel-Kollision, die die Gedaechtnisluecke erzeugt hat:** im gesamten `docs/`-Baum gibt es
**genau einen** Treffer auf `zweiphasig` und **null** auf `dreiphasig` (`/usr/bin/grep -rn`, ueber
`docs/`). Die Paar-Formel existiert im Plan **ausschliesslich** als Stufen-Doktrin, dort aber
"-stufig" geschrieben. Erschwerend: die **stale** mittag-8-Lesart ("DREISTUFIG SYMMETRISCH" als
Gesamt-Etikett) steht in **Datei-Reihenfolge NACH** mittag-9/-10, ist chronologisch aber AELTER
(`LEDGER:4194` fuehrt den SUPERSEDED-Vermerk). Wer den Ledger sequenziell liest, sieht die falsche
Form zuletzt. **Das ist die mechanische Ursache der Luecke** -- und sie ist damit geschlossen.

### (P-2) Die CEB IST das Messsystem -- kein Runtime-Konfigurieren

**Owner, `LEDGER:3095` (§57, 20.07.):**

> "Bei der CEB sind System-Achse und Organ-Achse noch runtime und die Mess-Achse fest einkompiliert
> (bis auf Variablen des Planers ueber dynamische Unter-Achsen); die CEB baut zu ihrer Laufzeit die
> compile-time Tier-Binaries auf … Die CEB hat ihren eigenen Typ+Versions-Stempel ueber die
> Mess-Achse des Planers."

**Owner, `LEDGER:3066` (§56):** *"Die Mess-Achse baut nur das CEB auf und delegiert es."*
`LEDGER:3069-3070`: *"die CEB ist die statische Repraesentative der Mess-Achse … Die Mess-Achse
`[a,b,c]` gehoert NICHT in die Tier-Build-Legende -- sie IST die CEB."*

**`docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md:243`:** *"der Planer bestimmt das
Messsystem und kompiliert HART ein effizientes CEB je Messsystem (Configure-/Pre-Build-Zeit-Codegen
… -- kein Runtime-Konfigurieren)."*

### (P-3) Die AUSRICHTUNGS-MECHANIK -- der durchgereichte statische Draht

**§64-Schichten-Zuordnung, User 22.07. (vom Owner mit "jetzt richtig" bestaetigt),
`LEDGER:3402-3404`:**

> "Wallclock wird auf der CEB-SEITE gebaut/erhoben … Makro- und Micro-Benchmarking muss durch CEB UND
> TIER-BINARY einkompiliert ueber das PRUEFDOCK unterstuetzt werden (beidseitig: die CEB traegt die
> Pruef-Tools, das Tier-Binary die Observer).
> **AUSRICHTUNGS-MECHANIK:** Die CEB richtet die Mess-Einrichtung ihres Tier-Binary-Prueflings
> aufgrund IHRER statischen compile-time Mess-Achsen-Ausrichtung (die der PLANER-Mess-Achse folgt)
> AUCH AUF DEM TIER-BINARY aus -- indem dort macro- und micro-Benchmarks FUER DIE OBSERVER
> einkompiliert werden."

**Und die Kopplung, User 21.07., `LEDGER:3319` -- das ist der von KERN (A) genannte Vertrag:**

> "KOMPILATIONS-STATUS-KOPPLUNG: welche Pruef-Tools in die CEB EINKOMPILIERT sind
> (Mess-Tooling-Achse), bestimmt, was auch das Tier-Binary beinhalten MUSS (Tooling-Konsistenz
> CEB<->Tier)."

### (P-4) Der ObservableTier-Vertrag selbst

`ce docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md:396-407` (Sechs-Schritt):
bauen -> laden -> **Gattungs-API DURCHTESTEN** -> **eingebaute Observer MESSEN** -> **als flacher POD
ZIEHEN** -> **persistieren**.

`ce docs/architecture/messarchitektur_klarstellungen_und_entscheidungen.md:70-73`: *"Es soll EINE
Schnittstelle geben, die Handle-/Pruef-Dock-Operation + deren Parameter + den Observer zusammen
uebertraegt -- als eine Bruecken-Operation, nicht als getrennte Probes."*
`:117-118`: *"Ein vollstaendiger Mess-Durchlauf je Binary = `genus()` -> richtiges Pruef-Dock ->
Schleife ueber alle passenden Lastprofile -> je Profil: Operationsfolge gegen den Handle treiben +
(im Messmodus) `observe_all` korreliert ziehen."*

`ce docs/architecture/31_observer_interface_konsolidierung_i1.md:84`: **EINE**
`IObservableTier::tier_observe(ComdareTierObserverSnapshot*)`, **EIN** versionierter POD.

**Der VIERTE Layer (Owner-KERN 06.08.,
Memory `feedback_gattung_genus_interface_messparameter_achsen`):**
> "aus einer Interface Funktion einer Gattung->Genus [sind] immer alle in der interface Funktion …
> vollzogenen Messparameter abrufbar …, die waehrend des Aufrufs durchlaufen wurden, zusammen mit
> einem zeitlich geloggten Profil der Achsen-Zugriffsmuster. … Das ist ein vierter Layer der Observer
> Stufe im Vertrag zwischen CEB und Tier-Binary!"
> Korrektur: *"Wallclock time wird je Tier-Binary Funktion und ueber eine Kombination einer Last
> JEWEILS gemessen."*

### (P-5) Der Dock-Vertrag

`LEDGER:1881` (User 17.07.): Experiment-Dock (Planer->CEB) **eindimensional**, **Pruef-Dock
bidirektional** (CEB<->Tier). `docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md:52`
(D15): vier gespiegelte Invarianten; *"die Nutzlast oben ist per §30 die Messsystem-Wahl (harte
CEB-Kompilation)"*.

**§64-Vollmenge, `LEDGER:3383-3387`:** *"Der Ist-Zustand (3 getrennte Lanen als Default) ist eine
REGRESSION"* · *"alle 3 Verfahren in der CEB GEMEINSAM abgebildet per METAPROGRAMMIERUNG, und das
PRUEF-DOCK nimmt alle 3 Features vom Tier-Binary GEMISCHT ab."*

---

## 1.2 DER IST -- am Objekt, bei ce `b241a272`

### (I-1) Die Stufe-1->Stufe-2-Schiene ist gebaut und live

| Glied | Ort | Ist |
|---|---|---|
| ANGEBOT Mess-Tooling (HAUPT) | `libs/cache_engine/include/cache_engine/measurement/measurement_tooling_registry.hpp:47-49` | 3 Eintraege: `wallclock` / `macro` / `micro` |
| ANGEBOT Mess-Kategorien (UNTER) | `.../measurement/measurement_axis_registry.hpp` + `measurement_category.hpp:11-26` | 16 Kategorien, Index==Enum |
| Anwahl (Planer, RT) | `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:1829` / `:1878` | `measurement_combos_of(cats, tooling)` |
| Legende | `.../planner/plan_legend.hpp:82,90-92` | Vollmenge/leer => `[all]` |
| **Stufe-2-CT-Einbau** | `.../planner/experiment_plan_director.hpp:257-260` (`ceb_combo_compile_define`) | `[all]` => ` -UCOMDARE_MEASUREMENT_COMBO`; sonst ` "-DCOMDARE_MEASUREMENT_COMBO=<legende>"` |
| Emission (4 Stellen) | `:841`, `:877`, `:1194`, `:1342` -- je gefolgt von `cmake --build build --target comdare-messung-driver` | **alle vier** tragen `ceb_combo_compile_define` (`:842`, `:878`, `:1195`, `:1343`) |
| Stufe 3 (Tier-CT) | `abi/anatomy_version_stamp.hpp` `measurement_stamp_line*` | Mess-Zeile im Tier-Stempel |

### (I-2) DER ERSTE SCHNITT: die Mess-Achse gibt nichts frei -- sie ist rein nominal

**Zaehlung, von mir gefahren** (`/usr/bin/grep -rn "MeasurementTooling::Micro|Macro|WallClock"` ueber
`libs/`, `apps/`, `tools/`, `tests/`): **3 Treffer, alle drei in
`measurement_tooling_registry.hpp:47-49` -- also in der Tabelle selbst.**

**Konsequenz, unausweichlich:** eine CEB, die fuer `[micro]` gebaut wird, ist im **Verhalten
byte-gleich** zu einer fuer `[wallclock]`. Der Kopfkommentar der Registry sagt es selbst (`:14`):
*"GOLDEN/HOST-NEUTRAL: reine constexpr-Identitaet, keine Host-/Bau-/Mess-Semantik"*. Alle
tatsaechlichen Konsumenten (`plan_legend`, `ceb_version_stamp`, `lazy_adhoc_source_gen`,
`validate_profile`) verarbeiten die Tooling-id **nur als Zeichenkette** fuer Legende, Stempel und
Cache-Key.

**Die 16 Kategorien werden validiert, aber nicht konsumiert.** `validate_profile.hpp:353-362` und
`:1265-1275` pruefen die **Namen** gegen die Registry -- das ist echt. Der Verhaltens-Konsum fehlt:
`experiment_plan_director.hpp:1967-1968` sagt es woertlich:

> "Die 16 <measurement_categories> sind Mess-Tooling-UNTER (CSV-Spalten, §54-T2) und faechern den
> CEB-Typ NICHT auf -- sie reisen als combo.categories mit."

**=> Die Mess-Achse ist heute eine Legende, kein Schalter.** Owner-KERN (C) trifft exakt hier.

### (I-3) DER ZWEITE SCHNITT: EIN unbedingter Schalter statt der Ausrichtungs-Mechanik

`libs/cache_engine/profile_facade/profile_run_facade.cpp:273-275`, woertlich:

```cpp
[[nodiscard]] std::vector<std::string> perm_mess_defines() {
    std::vector<std::string> d = {"-DCOMDARE_ANATOMY_MODULE_BUILD=1", "-DCOMDARE_MEASUREMENT_ON=1",
                                  "-DCOMDARE_CE_ENABLE_STATISTICS=1", "-DCOMDARE_EXPERIMENT_MODE_ON=1"};
```

**Vier hart verdrahtete Defines, fuer JEDE Tier-Binary, ohne jeden Bezug auf die Mess-Achse.** Und
`-DCOMDARE_ENABLE_PMC` steht nicht darunter.

Was an diesem einen Define haengt: `anatomy/abi_adapter.hpp:393` -- unter `#if COMDARE_MEASUREMENT_ON`
erbt der Adapter **sieben** zusaetzliche Sub-Interfaces (`IObservableTier`, `IMeasurableWorkload`
V1/V2/V3, `IRollbackableTier`, `IMigratableTier`, `IScannableTier`), sonst nur `IDriveableTier`.
Dazu die Mess-Bloecke `:589`, `:1148`, `:1165`, `:1258`, `:1307` (K10-PMAJOR-04).

**Das ist der Kern von Owner-KERN (C), in einer Zeile:** die Plan-Definition verlangt, dass die CEB
die Mess-Einrichtung des Prueflings **aufgrund ihrer eigenen compile-time Mess-Achsen-Ausrichtung**
ausrichtet (P-3). Der Ist ist ein **konstanter Vektor**. Die Ausrichtung findet nicht statt; sie ist
durch eine Konstante ersetzt. Genau das nennt der Owner *"eine falsche Interpretation der Messung,
die implementiert wurde"*.

### (I-4) DER DRITTE SCHNITT: die Fortpflanzung ist MECHANISCH ABGESCHNITTEN -- dreifach

Owner-KERN (A) verlangt: eine Mess-Achsen-Aenderung erzwingt Neubau von CEB **und allen** Binaries.
**Heute kann das nicht passieren -- und es faellt nicht auf, sondern ueberspringt still.** Drei
unabhaengige Schnitte, jeder allein schon hinreichend:

| # | Schnitt | Beleg (selbst gemessen bei `b241a272`) |
|---|---|---|
| **S-a** | Eine Mess-Achsen-Aenderung aendert die CEB gar nicht **im Verhalten** | I-2: 3 Treffer, alle in der Registry-Tabelle |
| **S-b** | Der CEB-Fingerprint reist mit, aber **kein Gate vergleicht ihn** | `kCebFingerprint` -> `profile_run_facade.cpp:901` (`ceb_key`) -> Bestandslog-Record. `dll_is_current` (`builder/build_orchestrator/build_orchestrator.hpp:330-337`) ist **genau EIN** Vergleich: `return *vorhanden == expected_fingerprint;` -- gegen das `.fingerprint`-Sidecar, **nicht** gegen die CEB |
| **S-c** | Das einzige Preimage-Glied, das eine tier-seitige Quell-Aenderung faengt, ist **leer** | `include/cache_engine/abi/anatomy_fingerprint.hpp:109-111`: `#ifndef COMDARE_OVERLAY_SOURCE_HASH / #define COMDARE_OVERLAY_SOURCE_HASH ""`. Der eigene Kommentar `:99-101`: *"HEUTE LEER, UND ZWAR EHRLICH: der Codegen existiert noch nicht (0 Treffer fuer eine Overlay-Hash-Quelle im Baum)"* -- von mir nachgezaehlt: 0 |

**Die Folge in einem Satz:** aendert heute jemand `abi_adapter.hpp` (also die Mess-Ausstattung der
Tier-Binary), so aendert sich **kein** Fingerprint, `dll_is_current` liefert `true`, und der Bau
**ueberspringt** die betroffene Binary. Es entstuenden Messdaten aus Binaries, die die Aenderung
nicht tragen -- **ohne jedes Fehlersignal**. Das ist genau die Fehlerklasse des Checkhefts
(*"eine Messung war fuer sich korrekt und beantwortete die falsche Frage"*), eine Ebene tiefer.

**Entlastung, ebenfalls gemessen:** heute existieren **0 `.fingerprint`-Sidecars** im gesamten
super-Baum. Der stille Skip ist also **heute noch nicht scharf**. **Er wird scharf in dem Moment, in
dem der erste 4096er-Batch sein erstes Sidecar schreibt.** (`build_orchestrator.hpp:378-385`:
`provision_core` schreibt das Sidecar -- auch im reinen `provision_only`-Bau.)

### (I-5) PMC: die Naht ist da, PMC faehrt nicht darauf

| Messung | Ergebnis |
|---|---|
| `/usr/bin/grep -c "COMDARE_ENABLE_PMC" experiment_plan_director.hpp` | **0** |
| `/usr/bin/grep -n "cmake -B build"` (ohne den Kommentar `:219`) | **4** Emissionen: `:841`, `:877`, `:1194`, `:1342` |
| davon mit `ceb_combo_compile_define` | **4 von 4** (`:842`, `:878`, `:1195`, `:1343`) |
| davon mit PMC-Flag | **0 von 4** |
| `CMakeLists.txt:67` | `option(COMDARE_ENABLE_PMC … OFF)` -- Default AUS; gated auf Linux auch den `perf_event_open`-Zweig |
| PMC-Quelle ohne Flag | `pmc_source_factory.hpp` -> `NullPmcSource` -> alle Zaehler strukturell 0 |

**Die Schiene, ueber die die Mess-Achse in die CEB kompiliert wird, laeuft exakt durch die vier
Zeilen, an denen PMC fehlt.** Nichts ist zu bauen -- es ist zu **belegen**.

**Wo PMC lebt (entscheidungsrelevant, s. 3.4):** `make_pmc_source()` wird an genau zwei Stellen
gerufen -- `builder/experiment_tree/cache_engine_builder_iterator.hpp:2586` und
`harness/perm_runner.hpp:130`. **Beide sind Treiber-Code, also CEB.** Die Tier-`.so` entsteht ueber
einen eigenen `g++`-Subprozess des Treibers, nicht ueber CMake-Targets
(`build_orchestrator.hpp`, `/usr/bin/grep -c COMDARE_ENABLE_PMC` darauf = **0**).
**=> PMC ist heute vollstaendig CEB-seitig. Es beruehrt keine einzige Tier-Binary.**

### (I-6) L2 / L3 / Kohaerenz / branch_misses -- die Spalten-Wahrheit

`PmcCounters` (`include/cache_engine/measurement/pmc_source.hpp:20-27`): 7 Zaehlfelder + `available`.
`builder/linux_perf_pmc_source.hpp`, von mir gelesen:

| Feld | ohne Flag | mit Flag (Linux) | Beleg |
|---|---|---|---|
| `cache_misses_l1` | 0 | **REAL** (`PERF_COUNT_HW_CACHE_L1D`) | `:202-203`, Doku `:191` |
| `cache_misses_l3` | 0 | **REAL als Last-Level** (`PERF_COUNT_HW_CACHE_LL`) | `:204-205`, Doku `:192` |
| `dtlb_misses` | 0 | **REAL** (`PERF_COUNT_HW_CACHE_DTLB`) | `:206-207`, Doku `:193` |
| `energy_micro_joules` | 0 | **BEST-EFFORT** (RAPL sysfs, root-abhaengig) | `:152-157` |
| `cache_misses_l2` | 0 | **0** -- *"KEIN portabler generischer Counter -> bleibt 0 (kein RAW-Rateversuch)"* | `:194`, `:208`, `:295` |
| `coherence_invalidations` | 0 | **0** -- dito | `:195`, `:208`, `:295` |
| `branch_misses` | 0 | **0** -- **kein Opener, s.u.** | eigene Zaehlung |

**`branch_misses` ist eine Zusage ohne Deckung -- von mir am Objekt bestaetigt.**
`/usr/bin/grep -rn "branch_misses"` ueber `libs/`: 5 Felddefinitionen mit Default 0, **1 Kopie**
(`builder/measurement_snapshot.hpp:145`: `m.branch_misses = pmc.branch_misses;`), 2 Leser
(`i_measurement_source.hpp:175`, `system_axis.hpp:413` -- die Kategorie `BRANCH_MISS` sampelt genau
dieses Feld), CSV-Header (`cache_engine_builder_iterator.hpp:504`) und Zelle (`:777`).
**Keine einzige PMC-Quelle weist es je zu.** `LinuxPerfPmcSource` oeffnet drei Counter (`:202-207`);
`PERF_COUNT_HW_BRANCH_MISSES` ist nicht darunter.

Trotzdem steht seit 04.08. im CSV-Header-Kommentar (`cache_engine_builder_iterator.hpp:499-500`,
woertlich): *"PmcCounters ERHEBT branch_misses real (pmc_source.hpp)"*. **Die Praemisse ist falsch.**

**Und die XML deklariert genau diese Spalten als messbar:** `all_axes_golden.profile.xml:136-153`
fuehrt **16 Kategorien**, darunter `CACHE_MISS_L2`, `CACHE_MISS_L3`, `BRANCH_MISS`, `ENERGY_J`,
`IPC_CPI`, `FILL_BUFFER_OCCUPANCY`, `CLU`. **Vier davon sind heute strukturell 0.** Das ist der
direkte Verstoss gegen Owner-KERN (B): *"PFLICHT, dass das gemessen wird, was gemessen werden kann"*.

### (I-7) Das Pruefdock ist gebaut -- und im Produktionspfad nicht befahren

`libs/cache_engine/builder/pruef_dock/pruef_dock.hpp:2-8` definiert es kanonisch: *"der
builder-seitige, per-Gattung ABI-stabile Mess-Uebergang … Die CacheEngineBuilder besitzt den vollen
Lebenszyklus: Anatomie-Konfiguration + Compile (Binary-Tier-Modul) + Pruef-Dock-Messung."*
Bindender Ablauf `:74-79`: **"Reihenfolge import -> GATE -> messen"**, gueltig fuer *"JEDEN
produktiven Mess-Eintrittspunkt ausserhalb der Docks"*.

**Aufrufer-Bilanz, von mir gefahren** (`/usr/bin/grep -rln` ueber `libs/`, `apps/`, `tests/`):

| Symbol | Produktions-Aufrufer ausserhalb `builder/pruef_dock/` | Sonst |
|---|---|---|
| `PruefDockRegistry` / `select_for` | **0** | `apps/f15_compare/main.cpp` + 4 Test-TUs |
| `measure_genus_sequential` | **0** | `apps/f15_compare/main.cpp` + 4 Test-TUs |
| `drive_two_phase_tier_trace_abi` | **0** | `builder/pruef_dock/search_algorithm_dock.hpp` (Definition) + 1 Test-TU |
| `testat_observable_tier` (+ 6 Schwestern) | **0** | `mess_interface_testate.hpp:212` + 2 Test-TUs |

**Was der Produktionspfad stattdessen tut** (`builder/experiment_tree/cache_engine_builder_iterator.hpp`):
`:1995` `pruef_dock::run_so_conformance_gate(b.output)` (das ist echt und richtig) ->
`:2394-2395` `pruef_dock::acquire_search_algorithm_drive(handle, drive)` -- **rohe Bundel-Beschaffung
statt `IPruefDock::measure()`** -> `harness/perm_runner.hpp:195` `apply_conformance_gate_` ->
`:225` **genau ein** `tier.tier_observe(&r.unified)`.

**Damit ist die Plan-Aussage aus P-4 (*"genus() -> richtiges Pruef-Dock -> Schleife ueber alle
passenden Lastprofile"*) im Produktionspfad nicht umgesetzt.** Das Dock existiert, ist getestet und
wird umfahren. **Das ist die zweite Haelfte von Owner-KERN (C)** -- und es ist der Ort, an dem
KERN (B) *"in die CEB fuer deren Pruefdock"* konkret wird: das Prueflings-Testat, das PMC pruefen
soll, laeuft heute nicht.

### (I-8) XML: die Trennung Bau/Messung existiert nicht

| Messung | Ergebnis |
|---|---|
| `/usr/bin/grep -rn "measure_selection\|measure_set\|mess_selektion"` ueber `libs/` + `algorithm_profiles/` | **0 Treffer** |
| `struct ThesisProfile` (`common/serialization/xml_config_parser/xml_config_parser.hpp:242-302`) | **kein Feld**, das Bau- und Mess-Menge trennt |
| Die einzige Trennung, die existiert | **Laufzeit**, ueber Env: `provision_only` (*"true = nur bauen, nicht messen"*, `profile_facade/profile_run_entry.hpp:213`) und `pruef_only` (`:216`) |

**=> Die von Owner-KERN (F) benannte Regression ist am Objekt belegt: die XML kann es heute nicht.**

**Zweiter Befund derselben Familie:** die **Mess**-Seite ist nicht in 4096er-Scheiben geteilt. Die
Bau-Seite slict (`experiment_plan_director.hpp:1240-1252`, `SLICE=4096`); der Mess-Batch faehrt das
volle Fenster in EINEM Treiber-Aufruf je Perm -- Kommentar `:1365` woertlich: *"Mess-Fenster = das
VOLLE [0:COMDARE_GN_TOTAL) der Zelle (BYTE-GLEICH zur Vor-S4-Emission). Einmal je Batch."*
(**Zeilendrift-Vermerk N-2:** der Vertiefungs-Plan nennt `:1367-1369` bei ce `47c4ef1d`; bei
`b241a272` steht der Satz auf `:1365`. Suchbegriff: `Mess-Fenster = das VOLLE`.)

Dazu die vier **entkoppelten** `4096`-Literale, von mir nachgezaehlt:
`planner/experiment_plan_director.hpp:610` (`kGnBatchSlice`) ·
`builder/bestandslog/batch_planner.hpp:51` (`kGnBatchSlice`, **zweite Definition**) ·
`builder/bestandslog/planer_driven_build.hpp:60` (`kBuildSliceGrain`) ·
`profile_facade/source_catalog.hpp:205` (`kMaxMaterializableCatalogCardinality`).
Kopplung per `static_assert`: **0 Treffer**. Drei tragen die Kopplungs-Zusage im Prosa-Kommentar.

### (I-9) Eine wichtige ENTLASTUNG: die §64-Vollmengen-Combo ist bereits gebaut

`libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:221-226`, der
Kommentar woertlich:

> "§64 (2026-07-22): EINE Vollmengen-Combo {wallclock,macro,micro} = EINE vereinte CEB (Default;
> Legende kollabiert auf [all], measurement_combos_of => 1 Combo). Die frueheren 3 separaten
> Ein-Tool-Combos (3 CEB-Lanen) waren die F-3-Regression; getrennt/Teilmengen bleibt XML-Recht."

**=> Fuer das Traeger-Profil der Abgabe gilt: CEB-Zahl = 1.** Der §64-Owner-Satz (*"alle 3 Verfahren
in der CEB GEMEINSAM abgebildet per METAPROGRAMMIERUNG"*) ist auf der **Deklarations**-Seite bereits
erfuellt. Was fehlt, ist die **Wirkung** (I-2) und die **gemischte Dock-Abnahme** (I-7).

Das ist die Nachricht, die die ganze Bilanz billig macht: **die vier Nachruestungen multiplizieren
die CEB nicht. Sie aendern EINE CEB.**

---

## 1.3 DER ABSTAND -- Plan gegen Ist, je Owner-KERN

| KERN | PLAN sagt | IST ist | ABSTAND | Klasse |
|---|---|---|---|---|
| **(A)** Fortpflanzung | Mess-Achsen-Aenderung -> CEB neu **und** alle Tier-Binaries neu (P-1, P-2) | **Dreifach abgeschnitten** (I-4): Achse ohne Wirkung · CEB-Fingerprint ohne Gate · Overlay-Glied leer | Ein stiller Falsch-Skip statt eines erzwungenen Neubaus. **Heute noch nicht scharf (0 Sidecars); scharf ab dem ersten Batch.** | **BLOCKIEREND T1** |
| **(B)** PMC-Pflicht | Was messbar ist, MUSS gemessen werden; PMC in die CEB fuer deren Pruefdock (P-3) | 0/4 Emissionen tragen das Flag (I-5); `NullPmcSource`; 4 der 16 deklarierten Kategorien strukturell 0 (I-6); das Pruefdock laeuft im Produktionspfad nicht (I-7) | Der Mess-Lauf schreibt honest-0 in Spalten, die die XML als messbar deklariert. | **BLOCKIEREND T1** |
| **(C)** ObservableTier | CEB richtet die Tier-Mess-Ausstattung **aus ihrer eigenen CT-Mess-Achse** aus; EINE Schnittstelle; Dock-Abnahme (P-3, P-4) | **Ein konstanter Define-Vektor** (`perm_mess_defines`, I-3) + **umfahrenes Dock** (I-7) | Die Ausrichtung ist durch eine Konstante ersetzt. Der Vertrag ist nicht verletzt -- er wird **nicht ausgeuebt**. | **BLOCKIEREND T1** |
| **(D)** L2/L3/Kohaerenz | gehoert in die Mess-Achse, CEB kompiliert nach Planer-Freigabe ein; *"PFLICHT und KERN der ANLAGE"* | 2 Felder bewusst 0 + `branch_misses` als Zusage ohne Deckung (I-6) | Drei Spalten, die der Anhang zeigen soll, sind nicht erhoben. | **T1 (Fenster!), s. 3.5** |
| **(E)** Fingerprint | Mess+System+Organ identisch -> identische Binary -> identische Messdaten | Preimage traegt Organ, System, Mess-**Tooling-Ids**, Toolchain (9 Felder, `abi/toolchain_stamp_glied.hpp:248`) -- **kein Mess-DEFINE**; Overlay-Glied leer | `COMDARE_MEASUREMENT_ON` und `COMDARE_ENABLE_PMC` sind bau-wirksam und **unstempelbar**. | **BLOCKIEREND T1, Fenster schliesst** |
| **(F)** XML-Trennung | Bau-Menge und Mess-Menge getrennt deklarierbar; *"sonst regression"* | `ThesisProfile` hat kein Feld; nur Env-Laufzeit (I-8); Mess-Batch ungeslict | Der erste Batch kann nicht sagen, was er baut und was er misst. | **BLOCKIEREND T1** |

**Die Lage in einem Satz:** *Die Mess-Kette ist auf allen drei Stufen gebaut und auf allen drei Stufen
verdrahtet -- aber die Mess-Achse, die sie steuern soll, ist an drei aufeinanderfolgenden Stellen von
der Wirkung abgetrennt: sie schaltet nichts (I-2), sie richtet nichts aus (I-3), und sie invalidiert
nichts (I-4). Was gebaut ist, ist die Leitung. Was fehlt, ist der Strom.*

---

# 2. DIE REIHENFOLGE -- was vor was, und warum

## 2.0 Das Ordnungsprinzip

Die Reihenfolge folgt **nicht** der Wichtigkeit und **nicht** der Groesse. Sie folgt der
**Fortpflanzungsrichtung des Plans**: Planer (RT-Freigabe) -> CEB (CT-Einbau + Pruefdock-Konfiguration)
-> Tier (CT-Einbau). Wer weiter unten anfaengt, baut gegen eine Naht, die weiter oben noch wandert.

Dazu kommt die **Bau-Oekonomie**: alles, was das Fingerprint-Preimage oder die Tier-Defines beruehrt,
gehoert in **ein** Buendel, weil jedes Buendel genau **einen** Voll-Neubau kostet (Abschnitt 3).

## 2.1 Die sechs Pakete

### M-1 -- DIE IDENTITAETS-NAHT (KERN A + C + E)   [ZUERST -- alles haengt daran]

**Was:** Drei Teile, die zusammen die Fortpflanzung mechanisch herstellen.

**M-1a -- `perm_mess_defines()` liest die Mess-Achse, statt sie zu ignorieren.**
`profile_facade/profile_run_facade.cpp:273-275`. Der Define-Vektor der Tier-Binary wird aus der
**einkompilierten** Mess-Achse der CEB abgeleitet (Quelle: `COMDARE_MEASUREMENT_COMBO` bzw. `[all]`),
nicht aus einer Konstante. **Das ist die AUSRICHTUNGS-MECHANIK aus P-3, gebaut.**
*Biss:* ein Test, der zwei CEB-Konfigurationen (`[all]` vs. `[wallclock]`) baut und zeigt, dass die
emittierten Tier-Defines **verschieden** sind. Heute sind sie zwangslaeufig gleich -> rot.

**M-1b -- Das Fingerprint-Preimage traegt den Mess-Define-Satz.**
Glied [5] (Toolchain, `abi/toolchain_stamp_glied.hpp:248`, heute 9 Felder) um ein Feld `mess`
erweitern, das `MEASUREMENT_ON` + `ENABLE_PMC` + den Combo-Namen fuehrt; Format-Bump `3 -> 4`
(`anatomy_fingerprint.hpp:89`). **Das ist Owner-KERN (E), woertlich gebaut.**
*Biss:* zwei Baeue mit unterschiedlichem Mess-Define-Satz muessen **verschiedene** Fingerprints
liefern. Heute liefern sie denselben -> rot.

**M-1c -- Der CEB-Fingerprint bekommt ein Gate.**
`kCebFingerprint` reist bereits als Provenienz (`profile_run_facade.cpp:901`), wird aber von nichts
verglichen (I-4/S-b). `dll_is_current` (`build_orchestrator.hpp:330-337`) um die CEB-Identitaet
erweitern -- oder, sauberer, die CEB-Identitaet in das Preimage von M-1b ziehen (dann faellt M-1c
konstruktiv weg). **Entscheid gehoert in die Bau-Linie, nicht zum Owner** (beide Wege erfuellen
KERN (A); der zweite hat weniger bewegliche Teile).
*Biss:* eine geaenderte CEB, dieselben Achsen -> der Bau darf **nicht** ueberspringen.

**Warum ZUERST:** M-1a definiert, **was** die CEB in die Tier-Binary kompiliert. M-2 (PMC), M-3
(L2/L3) und M-5 (Dock) sind **Nutzlast auf dieser Naht**. Wer sie vorher baut, verdrahtet sie gegen
`perm_mess_defines()` in seiner heutigen Konstanten-Form und muss sie danach erneut anfassen.
M-1b/c sind zusaetzlich **fensterkritisch** (Abschnitt 3.3): sie sind **heute kostenlos** und kosten
ab dem ersten geschriebenen Sidecar 34,4 h `[BERICHT]` plus alle bis dahin erhobenen Messdaten.

**Owner-Deckung:** KERN (A) *"Das ist eine Gedaechtnisluecke"* · KERN (C) *"der Vertrag der
ObservableTier ist in Gefahr und muss auditiert werden gegen die Plan-Definition"* · KERN (E)
*"Hauptidee des Systems und des Lagers"* · `LEDGER:3319` (Tooling-Konsistenz CEB<->Tier).

---

### M-6 -- DIE XML-TRENNUNG BAU/MESSUNG (KERN F)   [ZWEITENS, im selben Buendel]

**Was:** `<measure_selection>` als **Auswahl UEBER der Bau-Menge** in Schema + Parser +
`ThesisProfile` + Traeger-Profil; Validierung *"Selektion ist Teilmenge der Bau-Menge"*; dazu die
4096er-Scheibung auch im **Mess**-Batch (`experiment_plan_director.hpp:1365`, heute ungeslict).

**Warum an ZWEITER Stelle und trotzdem im selben Buendel:**
1. **Vor M-2/M-3/M-5**, weil die Selektion bestimmt, **welche** Zellen ueberhaupt gemessen werden --
   und damit, wogegen die Pruefdock-Testate (M-5) und die PMC-Abnahme (M-2) laufen.
2. **Nach M-1**, weil die Selektion auf Bau-Identitaeten zeigt; zeigt sie auf Identitaeten, die
   M-1b gerade neu definiert, ist sie zweimal zu schreiben.
3. **Im selben Buendel**, weil sie `profile_run_entry.hpp` schreibt -- dieselbe Struktur wie
   `provision_only`/`pruef_only`, die M-1a beruehrt (Konflikt K-3 des Vertiefungs-Plans).

**Kostenlos in der Neubau-Bilanz:** M-6 aendert **kein** Compile-Define. 0 CEB, 0 Tier-Binaries
(3.4). Es ist ein Parser-/Emissions-Paket.

**Owner-Deckung:** KERN (F) woertlich (*"sonst regression"*); `LEDGER:3324` (*"die Batches enthalten
STETS 4096 Binaries"*) fuer die Mess-Scheibung.

---

### M-2 -- PMC ALS INVARIANTE IN DIE CEB (KERN B, Teil 1)   [DRITTENS, im selben Buendel]

**Was:** vollstaendig ausgearbeitet in `docs/plaene/20260806-PLAN-p-pmc-1-messkette.md`, Abschnitt 4
(B1..B6). Kurzform:
- **B1** `-DCOMDARE_ENABLE_PMC=ON` in **alle vier** Emissionen (`:841`, `:877`, `:1194`, `:1342`).
- **B2** Der Test pinnt die **Invariante**, nicht die Zahl vier: *"Zu jeder emittierten
  `cmake -B build`-Zeile, deren Folgezeile den Mess-Treiber baut, gehoert `-DCOMDARE_ENABLE_PMC=ON`."*
  (Die Pflicht ging 16.07. verloren, weil sie an **zwei Job-Namen** hing -- ein Test auf "4" wiederholt
  denselben Fehler eine Ebene hoeher.)
- **B3** Die beiden Smokes fail-**closed** drehen: ist die Quelle einkompiliert, ist "kein Zugriff"
  ein FEHLER; ist sie es nicht, bleibt der ehrliche Skip.
- **B4** `allow_failure: true` (`:1373`) -- **Owner-Entscheid O-1**, s. Abschnitt 5.
- **B5** Doku-Drift (`CMakeLists.txt:67` nennt nur Windows; `linux_perf_pmc_smoke.cpp:4`;
  `linux_perf_pmc_source.hpp:5`).

**Warum nach M-1:** wenn M-1a die Tier-Defines aus der Mess-Achse ableitet, ist `ENABLE_PMC` ein
Kandidat fuer **beide** Seiten (CEB-Compile **und** Tier-Define). Die Entscheidung, ob PMC eine
tier-seitige Eigenschaft wird, faellt in M-1a -- nicht in M-2.

**Warum trotzdem im selben Buendel:** B1 schreibt `experiment_plan_director.hpp`, dieselbe Datei wie
M-6 (Mess-Scheibung) und M-1c. Drei Wellen auf dieser Datei heissen drei Voll-Gates und zwei
garantierte Merge-Konflikte (Konflikt K-1).

---

### M-3 -- L2 / L3 / KOHAERENZ / branch_misses NACHRUESTEN (KERN B Teil 2 + KERN D)   [VIERTENS]

**Was, gestaffelt nach Machbarkeit:**

| Teil | Inhalt | Aufwand | Fenster |
|---|---|---|---|
| **M-3a** | `branch_misses` verdrahten: `PERF_COUNT_HW_BRANCH_MISSES` als vierter Counter in `linux_perf_pmc_source.hpp` (Muster `:202-207`) | **klein** -- generisches `PERF_TYPE_HARDWARE`-Ereignis, dasselbe open/read/close-Muster, **kein RAW-Event** | **JETZT ODER NIE** -- die Spalte steht bereits im CSV-Header **mit der ausgeschriebenen Zusage**, sie werde real erhoben (`:499-500`) |
| **M-3b** | `cache_misses_l2` real: auf x86 **nur** ueber RAW-Events je Mikroarchitektur (Zen 5 / Raptor Lake getrennt) | **mittel** -- Vendor-Fallunterscheidung, je Lane eine eigene Event-Kodierung | T2 (vor der Voll-Messung), s. 4.3 |
| **M-3c** | `coherence_invalidations` real: dito, plus die Frage, welches Ereignis fachlich gemeint ist | **mittel-gross**, mit offener Semantik-Frage | T2 / **Owner-Entscheid O-3** |
| **M-3d** | RAPL-Probe: existiert `/sys/class/powercap/intel-rapl:0/energy_uj` auf der **AMD**-Lane und ist es lesbar? | **Minuten** (ein `cat` im pmc-Job-Trace) | **T1** -- entscheidet, ob `ENERGY_J` real oder honest-0 gefuehrt wird |

**Warum nach M-2:** M-3 aendert die **Menge der real erhobenen Zaehler**. Wenn diese Menge Teil des
Fingerprints wird (M-1b), muss sie **feststehen, bevor** das Preimage eingefroren wird -- sonst ist
M-3b/c spaeter ein zweiter Bump. Deshalb: **M-3a und die Entscheidung ueber M-3b/c gehoeren ins
Buendel; die Implementierung von M-3b/c darf danach kommen, wenn der Fingerprint die Zaehler-Menge
NICHT traegt** (das ist Owner-Entscheid O-3, Abschnitt 5).

**Owner-Deckung:** KERN (D) woertlich (*"direkt nachruesten nach Plan. PFLICHT und KERN der
ANLAGE."*) · KERN (B) (*"PFLICHT, dass das gemessen wird, was gemessen werden kann"*).

**Ehrlichkeits-Auflage (Owner-Doktrin honest-100%, `LEDGER:555`):** was nach M-3 nicht real erhoben
wird, ist im Anhang **ausdruecklich als honest-0 mit Begruendung** zu fuehren -- nicht als "gemessen".
Und der falsche Kommentar `cache_engine_builder_iterator.hpp:499-500` ist in **jedem** Fall zu
korrigieren: entweder er wird wahr (M-3a) oder er wird zurueckgenommen.

---

### M-5 -- DAS PRUEFDOCK IN DEN PRODUKTIONSPFAD (KERN B Teil 3 + KERN C Teil 2)   [FUENFTENS]

**Was:** Den Produktions-Mess-Loop auf den Dock-Vertrag ziehen, statt ihn zu umfahren (I-7):
- `cache_engine_builder_iterator.hpp:2394-2395`: `acquire_search_algorithm_drive` -> `select_for()`
  + `IPruefDock::measure()` (Plan-Ablauf P-4: *"genus() -> richtiges Pruef-Dock -> Schleife ueber alle
  passenden Lastprofile"*).
- Die sieben `testat_*`-Funktionen aus `mess_interface_testate.hpp` (heute **0** Produktions-Aufrufer)
  in die Abnahme ziehen -- **das ist der Ort, an dem PMC "in der CEB fuer deren Pruefdock" wirksam
  wird** (KERN B): ein `testat_pmc`, das `pmc_available==1` und einen Zaehler `!= 0` verlangt.
- §64 gemischte Abnahme: das Dock nimmt **alle drei** Verfahren (wallclock/macro/micro) vom
  Tier-Binary **gemischt** ab (`LEDGER:3383-3387`).

**Warum ZULETZT im Buendel:** M-5 ist das einzige Paket, das den **laufenden Mess-Loop** umbaut. Es
setzt M-1a voraus (welche Ausstattung das Tier traegt), M-2 (ob PMC ueberhaupt existiert) und M-3
(welche Zaehler das Testat pruefen darf). In umgekehrter Reihenfolge waere jedes Testat zweimal zu
schreiben.

**Warum es NICHT verschiebbar ist, obwohl es das groesste Paket ist:** ohne Testat laeuft der
mehrtaegige Lauf ohne Abnahme -- genau die Klasse, die der PMC-Preflight-Kommentar selbst benennt
(`experiment_plan_director.hpp:1352-1360`: *"ohne Preflight koennte eine Lane eine mehrtaegige Messung
mit kaputtem perf_event_open durchlaufen und lauter 0-Zaehler produzieren"*).

**AUFTEILUNG (das ist der Hebel fuer den Zeitplan):**

| Teil | Inhalt | Termin |
|---|---|---|
| **M-5a** | `testat_pmc` + die vorhandenen 7 Testate in die Abnahme des Mess-Batches ziehen (**ohne** den Loop umzubauen) -- als Preflight je Batch | **T1** -- klein, additiv, hoher Schutzwert |
| **M-5b** | Der Loop-Umbau auf `select_for()` / `IPruefDock::measure()` | **T2** |
| **M-5c** | Der VIERTE Observer-Layer (Gattung/Genus: Messparameter je Interface-Aufruf + zeitlich geloggtes Achsen-Zugriffsmuster) | **T3** -- eigenes Design, s. Owner-Entscheid O-4 |

---

### M-4 -- DIE MESS-ACHSE BEKOMMT WIRKUNG (KERN B Teil 4 + KERN C Kern)   [QUER, in M-1a enthalten]

Kein eigenstaendiges Paket, sondern die **Konsequenz** von M-1a: die 3 Tooling-Werte und die 16
Kategorien muessen einen **Verhaltens-Konsumenten** bekommen, sonst bleibt die Achse eine Legende
(I-2). Minimalform, die den Vertrag erfuellt:
- `wallclock` / `macro` / `micro` steuern, **welche** Mess-Defines `perm_mess_defines()` emittiert
  und **welche** Testate das Dock fordert.
- Die 16 Kategorien steuern die **Spaltenmenge** des CSV (heute: alle immer, `:481-504`) -- das ist
  ihre Plan-Rolle (*"CSV-Spalten, §54-T2"*, `experiment_plan_director.hpp:1967`) und heute nicht
  umgesetzt.

**Das ist die Stelle, an der Owner-KERN (C) buchstaeblich erfuellt wird** -- *"DAS IST DIE KERN Achse
des Planers und wird nicht gestrichen."*

---

## 2.2 Die Reihenfolge in einem Bild

```
   [OWNER-ENTSCHEIDE O-1..O-5]          <-- HARTER STOPP, alles Weitere haengt daran
             |
   L-0  Gitlink-Nachzug 47c4ef1d -> b241a272        [Minuten, unabhaengig]
             |
   +=========== EIN ce-BUENDEL "MESS-ANLAGE" -- EIN Branch, EIN Voll-Gate, EIN Bump ===========+
   |                                                                                           |
   |   M-1  IDENTITAETS-NAHT       a) perm_mess_defines liest die Achse                        |
   |        (KERN A,C,E)           b) Fingerprint traegt den Mess-Define-Satz, Format 3->4      |
   |                               c) CEB-Identitaet im Skip-Kriterium                          |
   |            |                                                                              |
   |   M-6  XML-TRENNUNG           <measure_selection> + Mess-Batch in 4096er-Scheiben          |
   |        (KERN F)                                                                            |
   |            |                                                                              |
   |   M-2  PMC-INVARIANTE         Flag in 4/4 Emissionen + Invarianten-Test + fail-closed      |
   |        (KERN B)                                                                            |
   |            |                                                                              |
   |   M-3a  branch_misses         vierter generischer Counter   [JETZT ODER NIE]               |
   |   M-3d  RAPL-Probe            ein cat im pmc-Job-Trace                                     |
   |        (KERN B,D)                                                                          |
   |            |                                                                              |
   |   M-5a  DOCK-TESTAT           testat_pmc + 7 vorhandene Testate als Batch-Preflight        |
   |        (KERN B,C)                                                                          |
   |                                                                                           |
   +====== ce main-FF (6) -> super-Bump -> super main-FF (12) -> beide Pipelines hart gruen ====+
             |
   L-2  Trigger-Checkliste + Zugriffs-Beweis pmc:amd/pmc:intel + Kalibrier-Batch
             |
   L-3  ERSTER 4096er-BATCH   -> liefert t/TU + Bytes/DLL (V-06)
             |                 -> ab hier ist das Fingerprint-Fenster ZU
   L-4  VOLL-BAU -> VOLL-MESSUNG

   NACH dem Buendel, ohne Neubau-Folge:
     M-3b/c  L2 + Kohaerenz via RAW-Events je Mikroarchitektur     [T2]
     M-5b    Loop-Umbau auf IPruefDock::measure()                   [T2]
     M-5c    VIERTER Observer-Layer (Gattung/Genus)                 [T3]
```

## 2.3 Was ausdruecklich NICHT in dieser Reihenfolge geht -- und warum

| Reihenfolge-Fehler | Folge |
|---|---|
| M-2 vor M-1a | PMC wird gegen die Konstanten-Form von `perm_mess_defines()` verdrahtet und muss danach erneut angefasst werden -- zweiter Review, zweites Gate. |
| M-3 vor M-2 | Die Zaehler werden gebaut, aber nie geoeffnet (ohne Flag liefert die Factory `NullPmcSource`). Der Biss waere nicht zeigbar. |
| M-5 vor M-3 | Jedes Testat muesste zweimal geschrieben werden -- einmal gegen die alte, einmal gegen die neue Zaehler-Menge. |
| M-6 nach dem ersten Batch | Der Batch kann nicht sagen, was er baut und was er misst -- das ist woertlich die vom Owner benannte Regression. |
| **M-1b nach dem ersten Batch** | **Der teuerste Fehler ueberhaupt.** S. 3.3. |
| M-1c weglassen | Der stille Falsch-Skip aus I-4 bleibt bestehen: eine geaenderte CEB baut keine Binary neu. Owner-KERN (A) ist dann auf dem Papier erfuellt und in der Maschine nicht. |

---

# 3. DIE NEUBAU-BILANZ

## 3.1 Die Bezugsgroessen

| Groesse | Wert | Beleg |
|---|---|---|
| Tier-Binaries der Vollmenge | **524.288** = 4 System-Perms x 131.072 | `static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` (`profile_facade/source_catalog.hpp:169`); Perms = `opt_level {O2,O3}` x `simd {no_extension,avx2}` (`all_axes_golden.profile.xml:189-198`) |
| **CEB-Binaries** | **1** (je Plattform x Mess-Aufgabe) | EINE Vollmengen-Combo `[all]` (`all_axes_golden.profile.xml:221-226`, §64) |
| Mess-Settings je Binary | **216** = 6 workloads x 4 working_set x 3 hw_prefetcher x 1 thread x 3 repetitions | `all_axes_golden.profile.xml:112,126,156,157,160` |
| Voll-Bau der Flotte | **~34,4 h** Wanduhr auf 2 Lanes `[BERICHT]` | Slice-Traces 19,4 min amd / 32,25 min intel je 4096er-Scheibe, 128 Scheiben (`docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45`) -- **von mir nicht nachgemessen** |
| CEB-Neubau nach Define-Wechsel | **~77 s** `[BERICHT]` | `/tmp`-Bau der Voranalyse: 76,7 s ohne / 77,0 s mit Flag, 13 CXX-Compiles davon 12 neu, 32 Kerne (P-PMC-1 §5.1) -- **von mir nicht wiederholt** |
| **Heutiger Flotten-Bestand** | **0 `.fingerprint`-Sidecars** | **von mir gemessen:** `find . -name "*.fingerprint" -not -path "./.git/*" \| wc -l` = 0 |

## 3.2 Die drei Neubau-Klassen

| Klasse | Was sie beruehrt | Betroffene CEB | Betroffene Tier-Binaries | Kosten |
|---|---|---|---|---|
| **CEB-ONLY** | Treiber-Compile-Graph (`comdare-messung-driver`) | **1** | **0** | ~77 s + Pipeline `[BERICHT]` |
| **TIER** | die Define-Menge, mit der der `g++`-Subprozess `perm_<id>.cpp` uebersetzt (`perm_mess_defines()` / `perm_compile_flags()`) | 1 | **524.288** | ~34,4 h `[BERICHT]` |
| **FINGERPRINT** | das Preimage von `anatomy_fingerprint_hex` (8 Glieder) bzw. das Skip-Kriterium `dll_is_current` | 1 | **524.288, aber nur die bereits GEBAUTEN** | **heute 0 h** (Bestand = 0) · **nach dem ersten Batch: 34,4 h + Entwertung aller Messdaten** |

## 3.3 DIE EINE ZAHL, DIE ALLES ENTSCHEIDET

    Bestand an .fingerprint-Sidecars HEUTE          :  0        (von mir gemessen)
    Kosten einer Fingerprint-Aenderung HEUTE        :  0 h
    Kosten derselben Aenderung nach dem 1. Batch    :  34,4 h Neubau
                                                     + ALLE bis dahin erhobenen Messdaten wertlos
                                                     + (bei Mess-Weg C: + ~3,1 d Messung)

**Das Fenster schliesst mit dem ersten `.fingerprint`, den `provision_core` schreibt** --
und das tut auch ein reiner `provision_only`-Bau (`build_orchestrator.hpp:378-385`). Ein
"Bau-Batch ohne Messung" schliesst das Fenster **genauso** wie ein Mess-Batch.

**=> Daraus folgt die Buendelung zwingend:** jedes Paket der Klasse FINGERPRINT und jedes Paket der
Klasse TIER muss **vor dem ersten Batch** landen, oder es kostet einen zweiten Voll-Neubau.

## 3.4 Die Zuordnung je Paket -- und eine KORREKTUR am Vertiefungs-Plan

| Paket | Klasse | CEB | Tier-Binaries | Begruendung (am Objekt) |
|---|---|---:|---:|---|
| **M-1a** `perm_mess_defines` liest die Achse | **TIER** | 1 | **524.288** | aendert die Define-Menge des `g++`-Subprozesses (`profile_run_facade.cpp:273-275` -> `:299-333`) |
| **M-1b** Fingerprint-Glied + Format-Bump | **FINGERPRINT** | 1 | **524.288, heute 0 gebaut** | Preimage-Aenderung; `dll_is_current` vergleicht das **ganze** Preimage -> es gibt keine Teilmenge |
| **M-1c** CEB-Identitaet im Skip-Kriterium | **FINGERPRINT** | 1 | dito | dito |
| **M-6** XML-Trennung + Mess-Scheibung | **CEB-ONLY** | 1 | **0** | Parser + Emission; **kein** Compile-Define |
| **M-2** PMC-Flag in die 4 Emissionen | **CEB-ONLY** *(heute)* | 1 | **0** | s. Korrektur unten |
| **M-3a** `branch_misses` | **CEB-ONLY** | 1 | **0** | `linux_perf_pmc_source.hpp` ist Treiber-Code |
| **M-3b/c** L2 + Kohaerenz | **CEB-ONLY** | 1 | **0** | dito |
| **M-3d** RAPL-Probe | **keine** | 0 | 0 | ein `cat` im Job-Trace |
| **M-5a** Dock-Testat als Preflight | **CEB-ONLY** | 1 | **0** | `mess_interface_testate.hpp` + Iterator sind Treiber-Code |
| **M-5b** Loop-Umbau | **CEB-ONLY** | 1 | **0** | dito |
| **M-5c** 4. Observer-Layer | **TIER** | 1 | **524.288** | er lebt im `abi_adapter` / `observable_tier` der Tier-Binary |

### KORREKTUR gegen `20260806-PLAN-owner-antworten-vertiefung.md`, Abschnitt 2.5

Der Vertiefungs-Plan fuehrt `B-C` (PMC) unter **"KLASSE ALPHA -- aendert das Fingerprint-Preimage
(entwertet 100 % der Flotte)"**. **Am Objekt trifft das heute nicht zu:**

1. `add_compile_definitions(COMDARE_ENABLE_PMC)` (`CMakeLists.txt:77`) wirkt auf den **CMake**-Teilbaum
   -- also auf den Treiber. Die Tier-`.so` entsteht **nicht** ueber CMake-Targets, sondern ueber einen
   eigenen `g++`-Subprozess (`build_orchestrator.hpp`, `/usr/bin/grep -c COMDARE_ENABLE_PMC` = **0**).
2. `perm_mess_defines()` (`profile_run_facade.cpp:273-275`) fuehrt das Flag nicht.
3. Also: **PMC ist heute reine Klasse CEB-ONLY. 1 CEB, 0 Tier-Binaries, ~77 s.**

**ABER -- und das ist der Grund, warum die Korrektur die Buendelung nicht aufhebt, sondern
schaerft:** sobald **M-1b** das Flag ins Fingerprint-Preimage nimmt (Owner-KERN E verlangt genau das),
wird PMC **rueckwirkend** identitaetswirksam. Und sobald **M-1a** entscheidet, dass die Mess-Achse
`micro` eine tier-seitige Instrumentierung bedeutet, wird PMC zusaetzlich Klasse TIER.

**Beides sind Entscheidungen von M-1, nicht von M-2.** Die richtige Formulierung lautet daher:

> **PMC ist heute billig und wird durch M-1 teuer. Deshalb muss es MIT M-1 landen -- nicht,
> weil es selbst die Flotte entwertet, sondern weil M-1 es zur Identitaet erhebt und ein
> nachtraeglicher Einbau dann einen zweiten Bump kostet.**

## 3.5 Die Bilanz je Bau-Schritt, zusammengefasst

| Schritt | CEB-Neubauten | Tier-Neubauten | Wanduhr |
|---|---:|---:|---|
| **Buendel L-1 vollstaendig** (M-1 + M-6 + M-2 + M-3a/d + M-5a) | **1** | **0** (Bestand ist 0) | ~77 s CEB + Voll-Gate + 2 Pipelines |
| Dasselbe, aber M-1b **nach** dem ersten Batch | 2 | **4.096 .. 524.288** je nach Batch-Fortschritt | + 34,4 h + alle Messdaten wertlos |
| M-3b/c **nach** L-1, **vor** dem Batch | +1 | 0 | ~77 s |
| M-3b/c **nach** dem ersten Batch, ohne Fingerprint-Bindung | +1 | 0 | ~77 s -- **aber**: die vor der Aenderung erhobenen Zeilen tragen andere Spalten-Semantik als die danach. **Datenbruch ohne Neubau.** |
| M-5b **nach** L-1 | +1 | 0 | ~77 s |
| **M-5c** (4. Observer-Layer) | +1 | **524.288** | **34,4 h -- deshalb T3, bewusst als zweite Bau-Kampagne** |

**Die Regel, die daraus folgt und die den Auftrag beantwortet:**

> **BUENDELN, was Klasse TIER oder Klasse FINGERPRINT ist: M-1a, M-1b, M-1c -- und alles, was M-1
> zur Identitaet erhebt (M-2, M-3a). Alles der Klasse CEB-ONLY ist danach jederzeit nachziehbar,
> ohne die Flotte zu beruehren -- mit der EINEN Ausnahme M-3b/c, die zwar keinen Neubau, aber
> einen Datenbruch erzeugt und deshalb vor dem Beginn der ZU BEHALTENDEN Messung stehen muss.**

Die einzige Klasse-TIER-Position, die **bewusst draussen** bleibt, ist **M-5c** (der vierte
Observer-Layer). Sie ist zu gross fuer das Fenster und ist als **deklarierte zweite Bau-Kampagne**
zu fuehren -- s. Owner-Entscheid **O-4**.

---

# 4. DER ZEITPLAN GEGEN DEN 15.09.2026

## 4.1 Der Rahmen

    Heute        Do 06.08.2026
    Endtermin    Di 15.09.2026            =  40 Tage
    Liefertage   Fr 07.08 (= "morgen")
                 Fr 14.08 · Fr 21.08 · Fr 28.08 · Fr 04.09 · Fr 11.09      =  6 Freitage

**"Morgen" ist zugleich der erste Liefertag.** Das ist die praegende Randbedingung.

## 4.2 WAS BIS MORGEN STEHEN MUSS, DAMIT DER ERSTE 4096er-BATCH FAHREN KANN

**Die ehrliche Antwort in zwei Saetzen:**

> **Das vollstaendige Buendel L-1 passt NICHT bis morgen.** Ein Batch morgen ist trotzdem moeglich --
> aber nur als **deklariert verwerfbarer Kalibrier-Batch**, dessen Binaries und `.fingerprint`-Sidecars
> ausdruecklich weggeworfen werden. Alles andere schliesst das Fingerprint-Fenster und kostet 34,4 h.

### 4.2.1 Was tatsaechlich bis morgen leistbar ist (Weg K -- KALIBRIER-BATCH)

| # | Posten | Aufwand | Warum es geht |
|---|---|---|---|
| **K-1** | **Gitlink-Nachzug** `47c4ef1d` -> `b241a272` (super) | Minuten | Reiner Zeiger, Richtung geprueft (vorwaerts). **Ohne ihn baut die super-CI eine ce ohne LB-6 und ohne die Build-Graph-Kante `678a4487`.** |
| **K-2** | **super-Push** (1 ungepushter Commit) + **main-FF beide Repos** (ce 6, super 12) | ~1 h inkl. Pipelines | Die Bridges triggern fest `branch: main` (`LEDGER:2044`: *"dokumentiert-absichtlich"*). Solange `main` zurueckhaengt, gated die super-Pipeline gegen einen **alten** ce-Stand. |
| **K-3** | **M-2/B1+B2** -- PMC-Flag als Invariante in die 4 Emissionen + Emissions-Test | halber Tag | Der Plan liegt fertig (`P-PMC-1` §4). Klasse **CEB-ONLY**, ~77 s Neubau, **0 Tier-Binaries**. Kein Fingerprint-Bezug, solange M-1b nicht gelandet ist. |
| **K-4** | **M-3d** -- RAPL-Probe + **Zugriffs-Beweis** auf beiden Lanes (`pmc:amd`, `pmc:intel`: literal `pmc_available=1` + ein `cache_misses_l1 != 0` aus dem Job-Trace) | Minuten | Kostet nur Job-Zeit; **entscheidet ueber O-2 und ueber die Ehrlichkeit von 2 Spalten.** |
| **K-5** | **Kalibrier-Batch** = 1 Scheibe (4096 Binaries), **deklariert VERWERFBAR** | ~20-33 min Bau `[BERICHT]` | Liefert die **V-06-Zahlen** (t/TU, Bytes/DLL), den Platten-Abgleich und die erste echte PMC-Zeile. Seine Sidecars werden geloescht (Sidecars sind **keine** Messdaten -- das Memory `feedback_messdaten_nie_loeschen_abi_darf_brechen` greift nicht). |

**Was der Owner morgen dafuer bekommt:** eine reale 4096er-Scheibe, gebaut und gemessen, **mit
echten PMC-Zaehlern**, plus die beiden Zahlen, die alle weiteren Entscheide brauchen (Bytes/DLL fuer
Ebene-B, t/TU fuer die Hochrechnung). **Das ist eine vorzeigbare Freitags-Lieferung.**

**Was er ausdruecklich NICHT bekommt:** eine Scheibe, deren Binaries er behalten kann. Sie tragen den
alten Fingerprint (Format 3, ohne Mess-Defines) und werden von M-1b invalidiert.

### 4.2.2 Warum das vollstaendige Buendel nicht bis morgen passt -- die Rechnung

| Paket | Dateien (schreibend) | Neue Grammatik? | Review-Last |
|---|---|---|---|
| M-1a | `profile_run_facade.cpp` + Tests | nein, aber **Vertragsaenderung** | hoch (beruehrt jede Tier-Binary) |
| M-1b | `anatomy_fingerprint.hpp` · `toolchain_stamp_glied.hpp` · `anatomy_version_stamp.hpp` · golden-Id-Fixtures + Stempel-Tests | **Format-Bump 3->4** | **sehr hoch** (Identitaet) |
| M-1c | `build_orchestrator.hpp` + Tests | nein | mittel |
| M-6 | `xml_config_parser.{hpp,cpp}` · `experiment_schema.xsd` · `all_axes_golden.profile.xml` · `profile_run_entry.hpp` · `validate_profile.hpp` · `experiment_plan_director.hpp` | **JA -- neues XML-Element** | hoch |
| M-2 | `experiment_plan_director.hpp` · 2 Smoke-TUs · Director-Test | nein | mittel |
| M-3a | `linux_perf_pmc_source.hpp` + Smoke | nein | klein |
| M-5a | `mess_interface_testate.hpp` · `cache_engine_builder_iterator.hpp` + Tests | nein | mittel |

Dazu die bindende Kadenz (`FAHRPLAN-parallel-sequenz-optimiert.md`, Leitplanke 2): *"vor Landung Merge
dev->Branch (nie rebase) + Dual-Review + Voll-Gate + Pipeline hart gruen + Backup + Ledger"*, bei
**max EIN ce-Voll-Gate gleichzeitig** (Leitplanke 1) und **Doppellauf 2x seriell**.

**=> Sieben Pakete, davon zwei mit neuer Grammatik bzw. Format-Bump, ein Voll-Gate-Slot, Dual-Review,
zwei Repos mit main-FF und Submodul-Bump. Das ist keine Nachtarbeit. Es ist die Arbeit von
Freitag bis Freitag.**

### 4.2.3 Die Alternative, die ich NICHT empfehle (Weg S -- SOFORT SCHARF)

Man koennte morgen **nur M-1b** landen (Fingerprint-Bump allein, ohne M-1a/M-6/M-2/M-3/M-5) und den
Batch als echten Bau fahren. Dann waere das Fenster sauber geschlossen und die Sidecars gueltig.
**Warum ich abrate:** M-1b friert das Preimage ein, **bevor** entschieden ist, welche Mess-Defines es
tragen soll (das entscheidet M-1a) und welche Zaehler-Menge real ist (das entscheidet M-3). Ein
Preimage, das man in der Folgewoche noch einmal anfassen muss, ist der teuerste denkbare Fehler --
er kostet dann 34,4 h **plus** die bereits gebaute Scheibe. **Ein Format-Bump ist erst dann richtig,
wenn feststeht, was er stempeln soll.**

## 4.3 Die sechs Freitags-Lieferungen

| Liefertag | Inhalt | Termin-Klasse | Was der Owner sieht |
|---|---|---|---|
| **Fr 07.08** | K-1..K-5: Gitlink + main-FF beide Repos + PMC-Invariante + Zugriffs-Beweis + **Kalibrier-Batch (verwerfbar)** | T1 | Eine reale 4096er-Scheibe mit echten PMC-Zaehlern; V-06-Zahlen |
| **Fr 14.08** | **BUENDEL L-1 vollstaendig gelandet** (M-1a/b/c + M-6 + M-2-Rest + M-3a + M-5a), beide Repos gruen, Format 4 | T1 | Die Mess-Anlage ist identitaetsfest; das Fenster ist bewusst und sauber geschlossen |
| **Fr 21.08** | **VOLL-BAU** (~34,4 h, laeuft ueber das Wochenende) + Beginn der Messung nach dem gewaehlten R-1-Weg + M-3b/c (L2/Kohaerenz, RAW je Mikroarchitektur) | T2 | Die Flotte steht; die erste echte Mess-Kurve |
| **Fr 28.08** | M-5b (Dock-Loop-Umbau) + Mess-Fortschritt + Anhang A gegen echten Korpus | T2/T3 | Erste flaechendeckende Auswertung |
| **Fr 04.09** | M-5c-Entscheid + ggf. **zweite Bau-Kampagne** (4. Observer-Layer) ODER deklarierter Verzicht + M-8/M-15-Auswertungsstufen | T3 | Die Statistik-Stufen gegen echte Wiederholungen |
| **Fr 11.09** | Abgabe-Haertung: chktex-Heilung der Writer, Anhang-A-Ehrlichkeit, Aufraeumpass, Overleaf-Naht | T3 | Das kompilierende Gesamt-PDF |
| **Di 15.09** | **ABGABE** | -- | |

**Wo die Reserve liegt und wo nicht:** die Mess-Zeit ist der Engpass, nicht der Bau
(`20260806-PLAN-owner-antworten-vertiefung.md`, R-1: Vollmenge = **71,7 d** auf 2 Lanes gegen **40 d**
verfuegbar; Weg (C) = **~3,1 d**). **Der Zeitplan oben setzt Weg (C) oder aequivalent voraus.**
Bei Weg (D) (Vollmenge) ist die Messung am 15.09. zu rund 56 % fertig -- das ist **kein** Zeitplan,
sondern ein Torso. **Owner-Entscheid R-1 (bereits gestellt) bleibt der bestimmende Faktor.**

## 4.4 Ehrlich: was NICHT passt

| Posten | Warum nicht |
|---|---|
| Volles Buendel L-1 bis morgen | 4.2.2 -- sieben Pakete, ein Voll-Gate-Slot, Dual-Review-Pflicht |
| **M-5c (4. Observer-Layer) vor der Voll-Messung** | Klasse TIER: 524.288 Neubauten. Er kostet eine **zweite** Bau-Kampagne (34,4 h). Bei 6 Liefertagen ist das machbar -- **aber nur, wenn er die Messung nicht zweimal erzwingt.** -> Owner-Entscheid **O-4** |
| **M-3b/c (L2 + Kohaerenz via RAW) bis morgen** | Vendor-getrennte RAW-Event-Kodierungen je Mikroarchitektur; auf prod2 zusaetzlich blockiert, weil der 14900KS im RMA ist und *"erst im September"* zurueckkommt (`LEDGER:865-872`). **Die Intel-Haelfte ist bis dahin nicht verifizierbar.** |
| Vollmengen-Messung (Weg D) | 71,7 d gegen 40 d verfuegbar |

---

# 5. WAS BLEIBT OWNER-ENTSCHEID

Fuenf Entscheide, die die Bau-Linie **nicht** faellen darf. Je: Lage, beide Wege mit Folge,
Empfehlung, Dringlichkeit. Die drei Entscheide **R-1** (Mess-Umfang), **R-2** (Form der XML-Trennung)
und **R-3** (Fingerprint-Reichweite) aus `20260806-PLAN-owner-antworten-vertiefung.md` stehen
weiterhin und werden hier **nicht** wiederholt -- sie bleiben Vorbedingung von M-6 und M-1b.

---

### O-1 -- `allow_failure: true` am Mess-Batch (`experiment_plan_director.hpp:1373`)

**Lage.** #278 (Owner 06.07., PFLICHT, `LEDGER:1140`): *"in einer harten Pipeline darf es kein
allow_failure geben"*; Endstand-Buchung `LEDGER:692`: *"0 allow_failure im GESAMTEN Matrix-System
(einzige Ausnahme by design: ce `is_original:relock`)"*. §66-N2 (`LEDGER:3499-3501`) fuer die
PMC-Strecke: *"BEIDE hart (kein Gate/allow_failure)"*. Der Code begruendet die Zeile mit der
Sichtbarkeits-Doktrin (`:1332`) -- die ist aber eine **Zell**-Doktrin (CSV `failed` + Log), keine
**Job**-Doktrin. Gegenprobe: `/usr/bin/grep -n allow_failure` ueber den Ledger = **20 Treffer**,
keiner autorisiert diese Zeile.

**Weg A -- entfernen.** Ein PMC-, Bau- oder Storage-Ausfall faerbt die Pipeline rot. Zell-Sichtbarkeit
bleibt unberuehrt.
**Weg B -- belassen.** Ein mehrtaegiger Lauf kann komplett scheitern, und die Ampel bleibt gruen.

**EMPFEHLUNG: Weg A**, mit dem Buendel L-1. Eine Zeile, jederzeit reversibel; der verlorene Messlauf
ist es nicht. **Dringlichkeit: T1.**

---

### O-2 -- Haertegrad der PMC-Wache: wird "Quelle nicht gebaut" ein Fehler?

**Lage.** Heute ist die gruene PMC-Ampel eine Aussage ueber den **Compile**, nicht ueber den
**Hardware-Zugriff**: `m3v2_pmc_smoke.cpp:71` fuehrt `pmc_seam_ok = delta.available ||
counters_all_zero` -- **lauter Nullzaehler sind das Erfolgskriterium**; `linux_perf_pmc_smoke.cpp`
liefert bei `!available` einen `SMOKE_SKIP` mit **Exit 0**. Der eigens dagegen gebaute #37-Preflight
(`experiment_plan_director.hpp:1352-1364`) baut beide in dem flaglosen Baum und stempelt `pmc=ok`.

**Weg A -- fail-closed** (P-PMC-1/B3): ist die Quelle einkompiliert, ist "kein Zugriff" ein FEHLER;
ist sie es nicht, bleibt der ehrliche Skip. Folge: kuenftige Infra-Aenderungen (strengeres
`perf_event_paranoid`, Nicht-root-Executor, Fremd-Cluster) fallen sofort rot auf, statt still auf
honest-0 zu degradieren. **Preis: der Batch kann blockieren, wenn eine Lane keinen Zugriff hat.**
**Weg B -- belassen.** Die Wache bleibt ein Testat ueber ihre eigene Abwesenheit.

**EMPFEHLUNG: Weg A** -- **aber erst NACH dem Zugriffs-Beweis K-4**, damit der Batch morgen nicht an
einer Wache stirbt, deren Voraussetzung ungeprueft ist. **Dringlichkeit: T1, nach K-4.**

---

### O-3 -- Die Zaehler-Menge: was ist "was gemessen werden kann"? (KERN B + D)

**Lage.** Die XML deklariert 16 Kategorien (`all_axes_golden.profile.xml:136-153`); vier davon sind
strukturell 0 (I-6). Die Nachruestbarkeit ist **nicht** gleich verteilt:

| Kategorie | Nachruestbar? | Aufwand | Fenster |
|---|---|---|---|
| `BRANCH_MISS` | **JA, billig** -- generisches `PERF_TYPE_HARDWARE`-Ereignis, kein RAW | klein (M-3a) | **JETZT ODER NIE** (die Zusage steht bereits im CSV-Header) |
| `CACHE_MISS_L2` | **JA, teuer** -- nur per RAW-Event je Mikroarchitektur (Zen 5 / Raptor Lake getrennt) | mittel (M-3b) | T2; Intel-Haelfte durch die 14900KS-RMA bis ~September blockiert (`LEDGER:865-872`) |
| Kohaerenz (`coherence_invalidations`) | **JA, teuer + semantisch offen** -- welches Ereignis ist fachlich gemeint? | mittel-gross (M-3c) | T2 |
| `ENERGY_J` | **best-effort** -- RAPL, root-abhaengig; ob die Zone auf der AMD-Lane existiert, ist **UNBELEGT** | Probe: Minuten (M-3d) | T1 |

**Die Frage, dreiteilig:**
**(a)** Wird `branch_misses` **jetzt** verdrahtet (M-3a) oder als honest-0 gefuehrt?
**(b)** Sind L2 + Kohaerenz **im Abgabe-Umfang** (dann T2, mit Intel-Vorbehalt) oder deklariert
NACH-ABGABE?
**(c)** Traegt der Fingerprint die **Zaehler-Menge**? Wenn ja, ist M-3b/c ein **zweiter** Format-Bump
und muss ins Buendel; wenn nein, sind sie jederzeit nachziehbar -- um den Preis, dass Zeilen vor und
nach der Aenderung **verschiedene Spalten-Semantik** tragen (3.5).

**EMPFEHLUNG:** (a) **verdrahten** -- derselbe billige generische Counter-Typ wie die drei laufenden,
und die Zusage steht bereits ausgeschrieben im Quelltext. (b) **im Umfang, als T2**, mit
ausdruecklichem Intel-Vorbehalt und honest-0-Ausweis, falls die Lane bis dahin fehlt. (c) **NEIN** --
der Fingerprint traegt den **Define-Satz** (bau-wirksam), nicht die **Zaehler-Menge** (laufzeit-wirksam
und CEB-only). Das haelt M-3b/c nachziehbar. **Dringlichkeit: (a)+(c) T1, (b) T2.**

---

### O-4 -- Der VIERTE Observer-Layer (Gattung/Genus): erste oder zweite Bau-Kampagne?

**Lage.** Owner-KERN 06.08. (Memory `feedback_gattung_genus_interface_messparameter_achsen`,
verbatim): *"Das ist ein vierter Layer der Observer Stufe im Vertrag zwischen CEB und Tier-Binary!"*
-- alle waehrend eines Interface-Aufrufs durchlaufenen Messparameter abrufbar, plus ein *"zeitlich
geloggtes Profil der Achsen-Zugriffsmuster"*, und *"Wallclock time wird je Tier-Binary Funktion und
ueber eine Kombination einer Last JEWEILS gemessen"*.

**Er lebt in der Tier-Binary** (`abi_adapter` / `observable_tier`) -- also **Klasse TIER: 524.288
Neubauten, ~34,4 h.**

**Weg A -- ins Buendel L-1** (also bis Fr 14.08.): ein Bau, eine Messung, der Vertrag ist vollstaendig.
Preis: das groesste Einzelpaket des Fensters, ABI-relevant, Design nicht abgeschlossen. Realistisch
verschiebt es L-1 um mindestens eine Woche -> Voll-Bau erst Fr 28.08., Messung erst ab 04.09.
**Weg B -- deklarierte zweite Bau-Kampagne** (T3, Fr 04.09.): L-1 landet wie geplant, die Flotte wird
gebaut, die Messung laeuft. Der vierte Layer kommt als eigener Bau **nach** dem ersten Mess-Korpus.
Preis: **zweiter Voll-Bau (34,4 h)** und **zwei Mess-Korpora**, die nicht fingerprint-identisch sind.
**Weg C -- deklarierter Verzicht bis nach der Abgabe** (T4): der Vertrag bleibt dreischichtig; der
vierte Layer wird in der Arbeit als **benannte Erweiterung** gefuehrt.

**EMPFEHLUNG: Weg B**, wenn der Owner den vierten Layer in der Abgabe sehen will -- er ist der einzige
Weg, der die Messung nicht um drei Wochen verschiebt. **Weg C**, wenn die Kernaussage der Arbeit ohne
ihn traegt. **Weg A rate ich ab:** er setzt das einzige unkritische Zeitfenster (Bau+Messung) aufs
Spiel, um ein Paket unterzubringen, dessen Design noch nicht steht.
**Dringlichkeit: bis Fr 14.08.** -- er bestimmt, ob L-1 an dem Tag landet oder waechst.

---

### O-5 -- Der Kalibrier-Batch morgen: verwerfbar oder scharf?

**Lage.** Der Owner will *"morgen schon messen koennen, wenn auch nur das erste 4096er-Batch"*.
Jeder Bau -- auch `provision_only` -- schreibt `.fingerprint`-Sidecars und schliesst damit das
Fingerprint-Fenster (3.3). Heute: **0 Sidecars** (von mir gemessen).

**Weg K -- KALIBRIER-BATCH (4.2.1).** Der Batch faehrt morgen mit dem heutigen Format 3, liefert
V-06-Zahlen, PMC-Beweis und Platten-Abgleich; seine Binaries und Sidecars werden **ausdruecklich
verworfen**, bevor L-1 landet. **Kosten: ~20-33 min Bau.** Der Owner sieht morgen reale Zahlen.
**Weg E -- ECHTER BATCH.** Der Batch ist Teil der Flotte. Dann muss L-1 **heute Nacht** vollstaendig
landen (4.2.2: nicht leistbar) -- oder das Fenster ist zu und M-1b kostet 34,4 h.
**Weg W -- WARTEN.** Kein Batch morgen; der erste Bau faehrt nach L-1 (Fr 14.08.).

**EMPFEHLUNG: Weg K.** Er erfuellt den Owner-Wunsch (*"morgen schon messen"*) **und** haelt das
Fingerprint-Fenster offen -- die beiden Ziele schliessen sich nur aus, wenn man den Batch als scharf
fuehrt. Auflage: der Verwurf ist **vor** dem Batch schriftlich zu erklaeren (Ledger + Checkliste),
nicht danach -- sonst entsteht genau der Zustand, den Regel R-10 beschreibt.
**Klarstellung zum Memory `feedback_messdaten_nie_loeschen_abi_darf_brechen`:** verworfen werden
**Binaries und `.fingerprint`-Sidecars**, **nicht** die erhobenen Messwerte. Die CSV-Zeilen des
Kalibrier-Batches werden additiv gesichert und ausdruecklich als "Format 3 / Vor-L-1" gekennzeichnet.
**Dringlichkeit: HEUTE ABEND** -- er entscheidet, was morgen frueh anfaengt.

---

# 6. WAS ICH NICHT BELEGEN KANN (ausdruecklich ausgewiesen)

1. **Die 34,4 h Voll-Bau** `[BERICHT]` -- uebernommen aus
   `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45` (19,4 min amd /
   32,25 min intel je Scheibe, 128 Scheiben, 2 Lanes). Von mir nicht nachgemessen. Die
   **Richtung** (Bau ist unkritisch, Messung ist der Engpass) folgt aus der Rechnung in R-1 und ist
   belegt; die **Groesse** ist es nicht.
2. **Die ~77 s CEB-Neubau** `[BERICHT]` -- aus P-PMC-1 §5.1 (`/tmp`-Bau der Voranalyse, 13 CXX-Compiles,
   32 Kerne). Von mir nicht wiederholt.
3. **Die 109,4 ms je Einzelmessung und die daraus folgenden 71,7 d / 3,1 d** -- uebernommen aus
   `20260806-PLAN-owner-antworten-vertiefung.md` R-1 (16 Datenzeilen des getrackten Korpus). Ich habe
   die XML-Faecher-Rechnung (216) an `all_axes_golden.profile.xml:112,126,156,157,160` nachgeprueft,
   **nicht** den Zeit-Mittelwert.
4. **Die Runner-Rechtelage heute** -- ob `perf_event_open` auf prod1/prod2 offen ist und ob
   `/sys/class/powercap/intel-rapl:0` auf der AMD-Lane existiert und lesbar ist: **UNBELEGT**. Die
   Ledger-Belege stammen vom 08.07. bzw. 25.06. Genau das schliesst K-4.
5. **"Last-Level == L3" auf prod1/prod2** ist eine Hardware-Aussage, die ich nicht am Objekt erhoben
   habe -- **UNBELEGT**, pruefbar mit einem `lscpu`-Einzeiler im pmc-Job.
6. **Ob `perm_compile_flags()` ausser `perm_mess_defines()` weitere mess-wirksame Defines fuehrt** --
   ich habe `profile_run_facade.cpp:273-297` und den Kommentar `:299-303` gelesen (vier Gruppen:
   Mess/OS/Arch, Allokator-Organ, `-mcx16`, SIMD-`-march`), aber **nicht** jede der vier Gruppen bis
   in ihre Aufrufer verfolgt. Fuer die Aussage "M-1a ist Klasse TIER" ist das hinreichend; fuer eine
   vollstaendige Aufzaehlung der tier-wirksamen Defines nicht.
7. **Der Ebene-B-/minio-Bestand** -- Cluster read-only
   (`feedback_diplomarbeit_impl_agent_cluster_readonly_no_infra`), von dieser Rolle nicht enumerierbar.
8. **Die Aufwandsschaetzungen in 4.2.2** ("halber Tag", "hoch", "sehr hoch") sind **Schaetzungen einer
   Lead-Rolle, keine Messungen.** Sie stuetzen sich auf die Dateimengen (die sind gemessen) und die
   bindende Kadenz (die ist zitiert), nicht auf vergleichbare vergangene Wellen mit Stoppuhr.

---

## SELBSTCHECK

ASCII-only ausserhalb der Zitate, mit **zwei ausdruecklich benannten Ausnahmen**, die der Haususus
dieses Korpus ist (identisch in `20260806-PLAN-p-pmc-1-messkette.md` und
`20260806-PLAN-owner-antworten-vertiefung.md`): das Paragraphenzeichen als **Teil des Namens** einer
Plan-Sektion (§30, §47, §56, §57, §64, §66) und der Mittelpunkt als Aufzaehlungs-Trenner. Innerhalb
von Zitaten steht zusaetzlich das Auslassungszeichen als Elisions-Marke. **Gezaehlt:**
`LC_ALL=C /usr/bin/grep -c '[^ -~]'` = **46** Zeilen von **1018** -- ausschliesslich diese drei
Zeichen; alle 10 Auslassungszeichen stehen in Zitaten (`/usr/bin/grep -n` nachgezaehlt).

Weiter: alle Datei:Zeile-Angaben an ce `b241a272` / super `699edaa2` selbst nachgelesen, Abweichungen
gegen die Scope-Staende ausgewiesen · jede Zahl mit Bezugsgroesse · Bericht und eigene Messung
getrennt gekennzeichnet · alle sechs Owner-KERNe (A)-(F) mit Bau-Posten belegt, keiner gestrichen ·
**kein Edit am Code, kein Commit, kein Push, kein Worktree unter `/home/comdare/wt-*` beruehrt.**
