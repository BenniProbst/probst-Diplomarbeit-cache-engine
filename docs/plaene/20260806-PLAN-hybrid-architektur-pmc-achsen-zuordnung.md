# Die Intel-Hybrid-Architektur im Achsen-System -- und was PMC dort zu suchen hat

> **Erhebungsstand:** 2026-08-06, abends. **Quellstaende:** super `18a0bdf3` ·
> ce `90bca126` (Hauptklon `Code/external/comdare-cache-engine`) · zusaetzlich gelesen:
> unveroeffentlichter Diagnose-Commit `3f0d989d` im Arbeitsbaum `/home/comdare/wt-pmc-errno`.
> **Modus:** READ-ONLY erhoben (keine Code-Aenderung, kein Commit, kein Worktree-Eingriff);
> dieses Dokument ist die einzige geschriebene Datei.
> **Alle Suchen mit `/usr/bin/grep`** (der Shell-`grep` ist auf ugrep umgebogen und liefert
> bei manchen Mustern still 0 -- siehe Nenner-Bloecke).
>
> **Bindende Vorgabe dieses Dokuments** ist der Owner-KERN vom 06.08. (Abschnitt 0). Wo ein
> Sucher-Befund ihm widerspricht, gewinnt der KERN; der Widerspruch steht in Abschnitt 7.

---

## 0. DER OWNER-KERN, gegen den hier gearbeitet wird

Owner, 2026-08-06, verbatim (aus dem Auftrag dieses Dokuments):

> "Soweit ich mich erinnere muessen **ALLE per deep research belegbaren Architekturen von AMD
> und Intel mit PMC unterstuetzt werden**. Dazu gehoeren **Performance Core und E-Core PMC
> Einrichtungen, die getrennt gemessen und ausgewertet werden**. Damit hat die Intel Maschine
> **effektiv 2 PMC und nicht nur eins**. Dieses muss **je Konfiguration compile time nach der
> Freigabe durch den Planer in die CEB eingearbeitet werden**."

Vier Festlegungen, die im Folgenden nicht mehr hinterfragt, sondern ausbuchstabiert werden:

| # | Festlegung | Ort der Ausbuchstabierung |
|---|---|---|
| K-1 | PMC ist eine **Menge je Maschine**, keine Einrichtung | 3b.1 |
| K-2 | P-Core und E-Core werden **getrennt gemessen UND getrennt ausgewertet** | 3b.2, 3b.3 |
| K-3 | Abdeckung aller belegbaren AMD-/Intel-Architekturen = **Deep-Research-Pflicht** | 3b.4 |
| K-4 | **Planer gibt frei (RT) -> CEB baut ein (CT) je Konfiguration** | 3.3 |

---

## 1. Was der Plan sagt

### 1.1 Kurzverdikt zur Owner-Erinnerung

**Die Erinnerung ist belegt -- und sie hat zwei Traeger, nicht einen.** Der Owner erinnert sich
"vage" an einen Plan; es sind zwei, sie sind sechs Wochen auseinander, und sie sagen zusammen
genau das, was der KERN heute wiederholt:

1. **Der PMC-Architektur-Plan vom 2026-05-31** -- er enthaelt die Vendor-/Architektur-Matrix,
   die Hybrid-Zeile, die `hybrid_core_aware`-Fahne und den Compile-Time-Selektor. **Das ist der
   Plan, der die Owner-Erinnerung traegt.**
2. **Die Betreuer-/Termin-Dokumente vom 2026-04-09 und 2026-04-12** -- sie machen die
   Hybrid-Plattform zur *Pflichtplattform* und schreiben die Trennregel `cpu_core`/`cpu_atom`
   woertlich fest, drei Wochen vor dem Kauf der prod-Maschinen.

**Was NICHT gefunden wurde:** ein Dokument, das die *Anschaffung* einer Maschine mit ihrer
Hybrid-Architektur begruendet (Nenner + Gegenprobe in 1.5). Der Kauf-Anlass der beiden
prod-Maschinen ist im einzigen auffindbaren Dokument K8s. **Das ist aber die schwaechere
Frage.** Was existiert, ist staerker als eine Beschaffungsnotiz: die Hybrid-CPU steht in der
**Forschungsfrage** und in der **Abgabe-Thesis**.

### 1.2 Der Traeger-Plan: `20260531-mess-abstraktion-cross-platform-architektur-plan.md`

Ort: `Code/external/comdare-cache-engine/docs/sessions/20260531-mess-abstraktion-cross-platform-architektur-plan.md`.

**User-Auftrag im Kopf des Plans, verbatim (`:4-6`):**

> "**solide Messverfahren unter derselben Abstraktion, PCM als EINE Implementierung unter allen
> Chip-Vendors/ISA** … CacheEngineBuilder gibt arch-adaptierte Werkzeuge fuers Pruef-Dock …
> Build mit Metaprogrammierung … CMake-Check ob Binaries zur Plattform passen, sonst neu bauen"

Das ist derselbe Satz wie der heutige KERN, nur frueher formuliert: *eine* Abstraktion, *viele*
Vendor-/Architektur-Implementierungen darunter.

**Die Hybrid-Zeile der Implementierungs-Matrix (`:132`, verbatim):**

> | Intel Hybrid | x86_64 P+E (Alder/Raptor) | PCM + intel/perfmon JSON | **P/E-separate Event-Codes**; AVX-512 evtl. BIOS-disabled | RAPL Package | **`hybrid_core_aware=true`, Core-Pinning noetig** |

**Die Deep-Research-Pflicht, woertlich, im selben Plan (`:139-141`):**

> "Die Event-Code-Zuordnung pro Vendor ist **Annahme aus dem Inventar** und gehoert **vor
> Implementierung pro Event web-verifiziert** (Direktive 'Web-Recherche pro Algorithmus', hier
> analog **pro Event-Code**)."

**Der Compile-Time-Selektor -- die Stufigkeit, sechs Wochen vor der Stufen-Doktrin (`:145-152`):**

> "CMake setzt … eine einzige Cache-Variable `COMDARE_MEASUREMENT_VENDOR ∈ {intel_pcm,
> amd_uprof, arm_papi, wallclock}` … Im Code waehlt ein `mp_if`/`if constexpr`-Alias
> `using SelectedMeasurementSource = …;` die Implementierung **zur Compile-Zeit** -- konform zu
> 'Kein Runtime-Switch im Hot-Path'. **Die einzige Laufzeit-Verzweigung ist die einmalige
> `capabilities()`/`open()`-Gate-Pruefung ausserhalb der Messschleife** (begruendete Ausnahme:
> HW-Verfuegbarkeit ist erst zur Laufzeit bekannt; sie liegt nicht im Hot-Path)."

**Das ist wortwoertlich die spaetere Stufen-Doktrin, auf PMC angewandt:** eine
Laufzeit-Freigabe (Stufe 1) plus ein Compile-Time-Einbau (Stufe 2). Der Plan hat sie fuer PMC
schon 2026-05-31 formuliert, bevor sie 2026-08-05 als allgemeines Gesetz im Ledger stand.

**Status des Plans:** Kopf `:3` -- *"Status: PLAN (keine Marke 'erledigt/verifiziert')"*.
**Nicht superseded**, sondern **teilgebaut und explizit als Design-Quelle zitiert**: der
Interface-Header `libs/cache_engine/include/cache_engine/measurement/i_measurement_source.hpp:1-3`
sagt selbst: *"Phase-6-Vorbau (2026-07-10): vendor-neutrale Mess-Quellen-Abstraktion **nach der
Design-Quelle** docs/sessions/20260531-…-plan.md §2.2"*. Und die Hybrid-Fahne aus der Matrix
steht dort real im Code -- `i_measurement_source.hpp:55`:

```cpp
    bool                                  hybrid_core_aware = false; ///< P/E-Core separate Event-Codes
```

### 1.3 Der aeltere, staerkere Traeger: Hybrid als Pflichtplattform und Teil der Forschungsfrage

- **Scope-Freeze 2026-04-12** (`docs/termine/20260412 Termin 4/20260412_Arbeitsaufstellung_PRT_ART_Termin4_final.docx`,
  Absatz 955): *"Die Pflichtplattformen sind lokal **Alder-Lake-P (P/E getrennt)** und
  Barnard/Sapphire Rapids."*
- **Finale Forschungsfrage** (`…/20260412_PRT_ART_Scope_Freeze_Termin4_final.docx`, Abschnitt 1):
  *"… gegenueber passiven, statischen Layouts **auf Hybrid-CPUs** und Sapphire-Rapids-Systemen?"*
- **Trennregel, 2026-04-09** (`…/20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx`,
  Abschnitt "Hybrid-Regel lokal"): *"P- und E-Cores werden **nicht zusammenaggregiert**. perf
  dokumentiert dafuer getrennte PMUs **cpu_core** und **cpu_atom**; gruppierte Events ueber beide
  PMUs werden vermieden."*
- **Risiko-Tabelle desselben Dokuments:** Risiko *"Hybrid-CPU-Zaehler werden falsch aggregiert"*,
  Gegenmassnahme *"strikte Trennung cpu_core/cpu_atom; JSON-Ausgabe aus perf"*.
- **In der Abgabe-Thesis, LIVE und eingebunden** --
  `thesis/diplomarbeit/kapitel/de/05_evaluation.tex:68-82` (eingebunden ueber
  `diplomarbeit.tex:284`): *"… plus die eigenen Produktions-Zielmaschinen (Ryzen~9~9950X3D,
  **Intel~Core~i9-12900K**) … und **auf Hybrid-CPUs werden P- und E-Cores getrennt vermessen
  (ueber die eigenen Zaehler-Domaenen `cpu_core` und `cpu_atom`) statt zusammenaggregiert**."*

**Einordnung:** Die Trennung ist keine Kuer. Sie ist eine **veroeffentlichte Methodik-Zusage**
im Abgabe-Text und ein **Term der Hauptforschungsfrage**. Ein `pmc:intel`, das auf der
Hybrid-Maschine nicht domaenen-getrennt misst, laesst nicht einen Job rot -- es laesst eine
Zusage der Thesis ungedeckt.

### 1.4 Die dritte Fundstelle: der Achsen-Ort ist bereits owner-entschieden

Zwei unabhaengige Owner-Entscheide, gleiches Ergebnis:

**§16.3-E17** (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1576-1577`, verbatim-treu):

> "**P/E-Core (CPUID 0x1A) = separate Systemachse, aber DYNAMISCHE Unter-Achse unter der
> Hardware-Systemachse; H-1 wie empfohlen.** … statische Compile-Time-Einrichtung ist sinnlos
> (0x1A ist inhaerent Laufzeit); deep research Pflicht. **H-1 = wie empfohlen: Hardware traegt
> das FAKTUM (Core-Typ-Karte + `ran_on_core_type`), die aktive Pinning-POLICY als
> Scheduling-Unter-Achse**"

Status `LEDGER:1578`: **"NACHGEHOLT"** (nicht mehr geparkt).

**§51-B8** (`LEDGER:2760`, Owner 20.07.) -- das allgemeine Kriterium:

> "… **SOFERN** deren Eigenschaften **compile-statisch** erkennbar sind (dann Haupt-Achse);
> **ansonsten ist es eine dynamische System-UNTER-Achse zur Laufzeit** … **User-Einschaetzung:**
> auf modernen Systemen dynamisch -> **Unter-Achse UNTER der ISA-Achse**."

**§69.3** (`LEDGER:3564`, Owner 26.07.) -- und hier steht PMC namentlich:

> "**telemetry ist ZWEIGETEILT:** runtime-Unter-Achse im Mess-Tooling UND Haupt-System-Achse
> (**'weil etwa pmc zum Messen eingebaut sein muss** und andere IObservableTier ebenfalls
> ZWEIGETEILT sind')"

**§70.8 / RF-8** (`LEDGER:3578-3580`; Volltext
`docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md:47-50`, Owner verbatim):

> "**Echte sweep Unter-Achse im Planer die eine echte compile Haupt-Achse in der CEB fuer die
> Realisierung von Messeinrichtungen erzeugt (tiefe CPU und Hardware Messung ausserhalb der
> bekannten Micro/Macro/wallclock benchmarks).**"

Das Wort des heutigen KERNs -- *"PMC **Einrichtungen**"* -- ist dasselbe Wort wie in RF-8
(*"Realisierung von **Messeinrichtungen**"*). **RF-8 ist die Planer-RT -> CEB-CT-Mechanik, die
der KERN heute fuer die zwei PMU-Domaenen verlangt.**

### 1.5 NICHT GEFUNDEN -- mit Nenner und Gegenprobe

| Behauptung | Ergebnis | Nenner | Gegenprobe (findet das Verfahren?) |
|---|---|---|---|
| Ein Dokument begruendet die **Anschaffung** einer Maschine mit Hybrid | **NICHT GEFUNDEN** | `docs/` super (3736 Dateien, davon 1111 `.md`) + `/home/comdare/Projekte/Cluster/` (8036 Dateien); Begriffe `Beschaffung/beschafft/Anschaffung/gekauft/Kauf/bestellt/neue Maschine/Messstand` | `Beschaffung` in `docs/` -> **6 Treffer in 5 Dateien** (PMC-Software-Specs, Windows-Lizenzen, OPNsense) -> das Wort ist im Korpus produktiv, die Null ist echt |
| Der Kauf-Anlass ist dokumentiert | **GEFUNDEN, aber K8s** | -- | `Cluster/docs/sessions/20260506-…-masterplan-v8-…md:6`: *"User hat … **zwei kraeftige Maschinen (Ryzen 9 9950X3D, i9 14900KS) fuer ein zweites K8s-Cluster (Production)**"* |
| Irgendein ce-Code liest `cpu_core`/`cpu_atom` als PMU-Domaene | **0 Treffer** | **1929** Quelldateien unter `ce/{libs,apps,tools,tests}` (`*.hpp *.cpp *.h *.xml *.cmake CMakeLists.txt`), `grep -rlw` | `perf_event_open` -> **5 Dateien** (`experiment_plan_director.hpp`, `pmc_source_factory.hpp`, `linux_perf_pmc_source.hpp`, `tests/unit/CMakeLists.txt`, `linux_perf_pmc_smoke.cpp`) |
| `PERF_TYPE_RAW` oder sysfs-PMU-`type` wird gelesen | **0 Dateien** | dieselben 1929 | dito |
| CPUID-Leaf `0x1A` (Hybrid) wird abgefragt | **0 Dateien** | `platform_probe/` | `cpuid` in `cpuid_probe.hpp` -> 13 Treffer; gelesene Leaves 0/1/7/0x8000000x |

**Zur Maschinen-Historie (belegt, aber nicht der gesuchte Plan):** der i9-12900K auf prod2 ist
ein **RMA-Stabilitaets-Rootfix**, kein Hybrid-Beschaffungsakt
(`Cluster/…/2026-07-09-K90-…/memories/project_prod2_hardware_verdict_io_not_cpu.md`: *"USER-ENTSCHEID:
CPU-Tausch i9-14900KS -> i9-12900K (Alder Lake, nicht betroffen)"*). **Beide** CPUs sind hybrid --
die Eigenschaft ging nie verloren; der Tausch hat sie sogar plan-konformer gemacht, weil der
Scope-Freeze woertlich *"Alder-Lake-P"* fordert.

---

## 2. Der Ist-Zustand: was heute passiert

### 2.1 In der Sprache des Achsen-Systems

Der rote `pmc:intel` ist **kein Rechte-Problem und kein Maschinen-Defekt.** Er ist die Stelle, an
der eine **Achse fehlt und ihr Fehlen als Messfehler sichtbar wird**. Praezise:

> **Das System kann heute nicht ausdruecken, dass eine Maschine mehr als eine PMU-Domaene hat.**
> Es gibt keinen Typ, keine Registry-Zeile, keine CSV-Spalte und keinen Stempel dafuer. Folglich
> waehlt der Mess-Code keine Domaene -- er nimmt den generischen Typ und ueberlaesst die Wahl dem
> Kernel.

### 2.2 Die Mechanik, Zeile fuer Zeile

**(a) Die Oeffnungsstelle** -- `libs/cache_engine/builder/linux_perf_pmc_source.hpp:99-117`,
entscheidend `:110`:

```cpp
        long const r        = perf_event_open(&attr, /*pid*/ 0, /*cpu*/ -1, /*group_fd*/ -1, /*flags*/ 0);
```

`cpu = -1` heisst "jede CPU, auf der der Thread gerade laeuft". Auf einer uniformen PMU ist das
wohldefiniert. Auf zwei getrennten PMU-Domaenen ist es die eine Angabe, die **nicht** wohldefiniert
ist.

**(b) Der Ereignis-Typ ist eine Konstante** -- `:211/:213/:215` oeffnen drei Zaehler,
alle mit `PERF_TYPE_HW_CACHE`. **Die Naht fuer eine Domaenenwahl existiert bereits**: `open()`
nimmt den `type` als **Parameter** (`:99`) -- nur der Aufrufer reicht eine Konstante durch.

**(c) Die Factory diskriminiert OS, nicht Hardware** --
`libs/cache_engine/builder/pmc_source_factory.hpp:29-37`, Kommentar `:27-28` woertlich:
*"Die OS-Diskriminierung (\_WIN32 vs \_\_linux\_\_) macht AUSSCHLIESSLICH diese Factory"*.
Es gibt keine Vendor- und keine Mikroarchitektur-Zelle.

**(d) Der Datenslot fuer Hybrid existiert -- und wird bewusst nicht gefuellt** --
`libs/cache_engine/include/cache_engine/platform/i_platform_probe.hpp:19-20`:

```cpp
    bool                          has_hybrid_cores              = false;
    bool                          cpu_core_atom_perf_separation = false;
```

`platform_probe/cpuid_platform_probe.hpp:38-39` sagt warum:
*"AP-13: Topologie/Pinning bleibt **bewusst ungesetzt** (has_hybrid_cores,
cpu_core_atom_perf_separation, preferred_pinning_policy)"* -- und `tests/unit/test_cpuid_probe.cpp:62-64`
**verriegelt** den Zustand:

```cpp
    EXPECT_FALSE(props.has_hybrid_cores);
    EXPECT_FALSE(props.cpu_core_atom_perf_separation);
    EXPECT_EQ(props.preferred_pinning_policy, static_cast<std::uint16_t>(0));
```

**(e) Warum es heute rot wird und frueher nicht** --
`tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp:55-59` setzt `kPmcExpected = true`, sobald
`COMDARE_ENABLE_PMC && __linux__` gebaut ist, und `:97-104` macht `available==0` zum
**SMOKE\_FAIL**. Der Kommentar `:44-45` nennt den Grund:

> "Owner-Auflage F3 (2026-08-06): »Es ist PFLICHT, dass das gemessen wird, was gemessen werden
> kann.« Ein Zaehler, den die Maschine liefern koennte und den wir nicht bekommen, ist damit ein
> FEHLER."

**Der Job ist also nicht neu kaputt -- er ist neu ehrlich.** Vorher war derselbe Zustand ein
gruener Skip.

### 2.3 Was BEWIESEN ist und was nicht

**Widerlegt** (Nachmessung vor der Rechte-Lockerung, Commit-Nachricht `wt-pmc-errno` `3f0d989d`,
verbatim):

> "Owner hatte auf Empfehlung `perf_event_paranoid` als Ursache der pmc:intel-Rotwerdung genannt
> bekommen und wollte Cluster-Rechte lockern. Eigene Nachmessung (**paranoid=1 identisch auf prod1
> UND prod2**) hat das entkraeftet, BEVOR die Lockerung ausgefuehrt wurde"

**NICHT bewiesen** -- dieselbe Quelle, ebenso woertlich:

> "Neuer Verdacht: Hybrid-PMU (Intel i9-12900K, P-/E-Core) gegen den generischen
> PERF\_TYPE\_HW\_CACHE-Typ mit cpu=-1 -- gestuetzt durch den bereits im Ledger bestehenden Posten
> 'P/E-Core (HW+#215)', aber **NICHT BEWIESEN**, weil `PerfCounter::open()` errno bewusst nicht in
> Rueckgabewert/Messdaten uebernimmt"

**Der Fund, der beide Vendoren betrifft** (lokale Verifikation desselben Commits, auf einem
Ryzen 9 9950X3D = prod1-Modell):

> "`[PMC-DIAG] perf_event_open fehlgeschlagen: event=cache_misses_l3_ll type=3 config=65538
> errno=2 (No such file or directory)` -- ein echter, bisher unsichtbarer **ENOENT auf dem
> LL-Counter**, den es vorher schon gab, der aber nie einen Fehlercode zeigte."

**Das ist der wichtigste Ist-Befund dieses Abschnitts und er stuetzt K-3:** der generische
`PERF_TYPE_HW_CACHE` liefert **schon auf AMD** nicht alles, was die Maschine kann. Die
Deep-Research-Pflicht ist damit nicht "Intel-Sonderfall", sondern die Reparatur einer
Vendor-Blindheit, die auf beiden Lanes wirkt.

**Ungeklaerte Restfrage, ehrlich benannt:** ob auf prod2 `perf_event_open` **fehlschlaegt** (dann
`available=0` -> SMOKE\_FAIL) oder **stillschweigend die falsche Domaene** trifft (dann waeren die
Zahlen da, aber unbeschriftet), ist mit den vorliegenden Belegen **nicht entschieden**. Die
errno-Zeile aus `3f0d989d` ist genau dafuer gebaut und **noch nicht auf prod2 gelaufen**. Bis
dahin gilt: die Hybrid-Erklaerung ist die bestbelegte Hypothese, nicht der Beweis.

---

## 3. DIE ZUORDNUNG

### 3.0 Die Doktrin, an der gemessen wird

Owner verbatim, `LEDGER:4082` (Stufen-Doktrin, 05.08., Abnahme `LEDGER:4095`
*"Jetzt ist alles korrekt … Volles go"*):

> "Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind ZWEISTUFIG symmetrisch und
> die Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei **die erste stufe immer Runtime Freigabe und
> die nachfolgenden Stufen compile time Einbau sind Planer->CEB-TierBinaries.**"

Kanonisch, `LEDGER:4083` / `:2253`:

| Achsen-Art | Stufigkeit | Kette |
|---|---|---|
| **MESS** | DREISTUFIG | Planer (1: **RT-Freigabe**) -> CEB (2: CT-Einbau, **inkl. Pruefdock-Konfiguration**) -> Tier (3: CT-Einbau) |
| **SYSTEM** | ZWEISTUFIG | CEB (1: RT-Freigabe) -> Tier (2: CT-Einbau) |
| **ORGAN** | ZWEISTUFIG | CEB (1: RT-Freigabe) -> Tier (2: CT-Einbau); **nur in Tier-Binaries verbaut** |

> **VOKABEL-WARNUNG, wichtig fuer die Lesart:** das Wort "Hybrid" in der Stufen-Doktrin
> (`LEDGER:4082`: *"Wenn wir die **Hybriden** betrachten und sie als vierte Stufe eingeschoben
> sind…"*) meint die **Hybrid-TIER-Stufe hinter der CEB**, nicht die Hybrid-CPU. Zwei voellig
> verschiedene Dinge mit demselben Wort. In diesem Dokument heisst "Hybrid" **immer** die
> CPU-Heterogenitaet; die Tier-Stufe wird ausdruecklich "Hybrid-Tier" genannt.

### 3.1 Die Trennung, die alles ordnet: FAKTUM vs. POLICY vs. EINRICHTUNG

Der Owner-Entscheid H-1 (`LEDGER:1577`) teilt bereits zwei Dinge. Der heutige KERN fuegt ein
drittes hinzu. **Drei Dinge, drei Achsen-Orte -- sie zu vermischen ist die eigentliche Falle:**

| Ding | Frage, die es beantwortet | Achsen-Art | Ort | Beleg |
|---|---|---|---|---|
| **FAKTUM** | Hat diese Maschine getrennte Kern-Klassen / PMU-Domaenen? Auf welcher lief die Messung? | **SYSTEM** | dynamische Unter-Achse an `target_isa` | §16.3-E17 `LEDGER:1577`; §51-B8 `LEDGER:2760` |
| **POLICY** | Worauf pinne ich den Mess-Thread? | **SYSTEM** | Unter-Achse `scheduling` (existiert, CT) | H-1 `LEDGER:1577`; `concepts/scheduling_strategy.hpp:38-39` |
| **EINRICHTUNG** | **Welche PMC-Apparatur wird einkompiliert -- und wie viele?** | **MESS** | Mess-Tooling/Collector-Achse (Planer-RT -> CEB-CT) | **KERN K-4**; RF-8 `LEDGER:3580`; §69.3 `LEDGER:3564` |

**Die dritte Zeile ist das Neue am heutigen KERN.** Alle bisherigen Befunde haben P/E-Core als
*Hardware-Eigenschaft* verhandelt (FAKTUM) und die Pinning-Frage daneben gestellt (POLICY).
Der KERN sagt: **die PMC-Einrichtung selbst vervielfacht sich.** Das ist keine
Hardware-Beschreibung mehr, das ist eine **Mess-Apparatur** -- und Mess-Apparaturen sind per
Doktrin Mess-Achsen.

### 3.2 Welche Achsen-Art? -- Antwort: **beide, an genau definierten Stellen**

**Die PMC-Einrichtung ist eine MESS-Achse.** Begruendung an der Stufen-Doktrin:

1. Nur die Mess-Achse hat eine **Stufe VOR der CEB** (den Planer). Der KERN sagt woertlich
   *"nach der **Freigabe durch den Planer**"* -- eine Freigabe durch den Planer ist per
   Definition Stufe 1 einer **Mess**-Achse. System-Achsen beginnen erst *in* der CEB.
2. Owner hat die HW-Erkennungs-Einrichtung bereits genau so eingeordnet --
   `docs/sessions/20260727-PLAN-hw-erkennung-zwei-ebenen-factory-stempel.md:234-243`, verbatim:
   *"Die Hardware-Erkennung ist somit eine weitere zweigeteilte Haupt-Achse ueber Planer runtime
   und CEB compile time, **es ist eine MESS-ACHSE ('misst' Hardware-Eigenschaften aus)**."*
   Umgesetzt in `measurement/hardware_probe_factory.hpp:8-13`: *"Sie ist **AUSDRUECKLICH KEIN
   System-Achsen-Anbau** … Die Erkennung ist **Konsument** der Achsen, nicht ihr Bestandteil."*
3. PMC lebt **host-seitig, nicht in der Tier-`.so`** -- `i_measurement_source.hpp:3-6` verbatim:
   *"Bewusst HOST-seitig (nicht ueber die DLL-Grenze): PMC-Zugriff braucht OS-Privilegien/Treiber,
   die ein Lebewesen-Modul nicht haben soll; die echte Erhebung umklammert host-seitig den
   run_workload-/tier_*-Aufruf am Dock."* Eine Einrichtung, die in der CEB lebt und die
   Tier-Binary nur umklammert, ist Mess-Realm.

**Das FAKTUM bleibt eine SYSTEM-Achse.** Es ist eine Eigenschaft des Hosts, keine Apparatur --
und §16.3-E17 hat es bereits zugewiesen. Es ist zugleich die **Freigabe-Quelle**, aus der die
Mess-Achse ihre Kardinalitaet zieht (3.3).

**Organ-Achse: NEIN.** Organ-Achsen sind per `LEDGER:4083` *"NUR in Tier-Binaries verbaut"* und
hybrid-unberuehrt. Die einzige P/E-Beruehrung auf Organ-Ebene ist eine abgeleitete
SIMD-Zulaessigkeit -- `topics/hardware/axis_09b_simd_extension/axis_09b_simd_extension_avx512.hpp:67-72`:
*"KRITISCH: Intel Alder Lake/Raptor Lake/Meteor Lake disabled AVX-512 in BIOS wegen E-Cores"*.
Das ist eine **Folge** der Hybridizitaet, nicht ihr Ort.

### 3.3 Haupt-Achse oder Unter-Achse? Und was ist RT, was CT?

> **[UEBERHOLT-MARKER 15.08.2026 -- betrifft die EINRICHTUNG-Zeile der Tabelle unten
> ('PMC-Domaenen-Satz = Unter-Achse der Mess-Tooling-Achse (micro)'):** die Zuordnung
> 'PMC als Unter-Achse von micro' ist UEBERHOLT. (1) Owner 10.08.: PMC = META-META-Achse
> mit EIGENER Permutation (AMD != Intel), keine Unter-Achse der Tooling-Achse
> (OWNER-ANTWORTEN 10.08.). (2) Owner 14./15.08. (KON64-03 F-G1-8-KORREKTUR + KON65):
> PMC = EIGENSTAENDIGE DREIPHASIGE Meta-Meta-Achse mit SONDER-GRAMMATIK (existiert keine
> PMC, wird gar nicht erst eine eingetragen -- KEIN Eintrag statt leerer Slot); als
> ZUSAETZLICHE permutierende Messeinrichtung erweitert sie den Nenner gegen w/ma/mi;
> Planer-Hardware-Erkennung AUSNAHMSWEISE NUR fuer PMC, die System-Achse fungiert als
> PROXY; ZWEI PMC-Systeme (AMD/Intel) via Durchreichen + Kompilate. Geltende Fassung:
> G-1-Design Paragraf 12.5 (20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md) +
> PMC-Schwester-Design der Mess-Achsen-Familie (Task #53). Das Original unten bleibt
> unveraendert stehen (Doku-nie-loeschen).]**

| Ding | Haupt/Unter | Stufe 1 (RUNTIME-Freigabe) | Stufe 2 (COMPILE-TIME-Einbau) | Stufe 3 |
|---|---|---|---|---|
| **FAKTUM** `is_hybrid` + Domaenen-Karte | **dyn. UNTER-Achse an `target_isa`** | CEB erhebt zur Laufzeit: CPUID 0x1A -> sysfs `cpu_core`/`cpu_atom` -> hwloc | als Host-Deskriptor in den Stempel; **nicht** in `binary_id` | -- |
| **POLICY** `pe_policy` (Pinning) | **UNTER-Achse `scheduling`** (existiert) | Planer/CEB gibt die zulaessige Menge frei | `HeteroCoreDispatch` wird CT gesetzt statt hartverdrahtet | -- |
| **EINRICHTUNG** PMC-Domaenen-Satz | **Unter-Achse der Mess-Tooling-Achse (`micro`)** | **Planer gibt frei** (KERN: *"nach der Freigabe durch den Planer"*) | **CEB kompiliert je Konfiguration EINE Domaenen-Apparatur ein** | Tier traegt Observer-Ausstattung (unveraendert) |

**Warum FAKTUM Unter-Achse und nicht Haupt-Achse:** §51-B8 (`LEDGER:2760`) macht es am Kriterium
fest -- Haupt-Achse nur bei **compile-statischer** Erkennbarkeit. CPUID 0x1A ist inhaerent
Laufzeit (`docs/plaene/20260716-e17-e18-deep-research-DOSSIER.md:9`), ab Meteor Lake sogar
unzureichend (dort ist sysfs autoritativ). Es gibt bereits **zwei Praezedenzfaelle mit exakt
dieser Form** in der Registry --
`measurement/system_axis_registry.xml:38-39`:

```xml
    <sub_axis id="numa_node" parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>
    <sub_axis id="page"      parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>
```

mit der Begruendung in `measurement/target_isa_sub_axes.hpp:16-22`: *"**WARUM KEIN
CT-OPTIONS-KATALOG** -- … die zulaessige Node-Zahl bzw. Seitengroessen-Freigabe **haengt an der
konkreten Maschine und ist zur Bauzeit nicht erkennbar** … Sie deklarieren deshalb eine
`option_source` statt einer Options-Liste."*

**Ein `core_class`-Geschwister neben `numa_node`/`page` braucht keine einzige Struktur-Aenderung.**

**Warum die EINRICHTUNG dagegen CT-Haupt-Wirkung hat:** die Mess-Tooling-Achse ist bereits so
gebaut -- `measurement/measurement_tooling_registry.hpp:2-5`, verbatim:

> "die AUFFAECHERUNGS-Achse des CEB-Typs [a,b,c]. {WallClock, Macro, Micro} = die Mess-
> INSTRUMENTIERUNG, die **je Wahl fest in eine CEB (und ihre Tier-Binaries) einkompiliert wird**
> (F7-Selektivitaet). **Jede Tooling-KONFIG erzeugt eine eigene "ceb:build:[a,b,c]"-Strecke
> (N Tooling-Konfigs -> N CEB-Pipelines).**"

**Das ist woertlich der Mechanismus, den K-4 verlangt.** "Je Konfiguration compile time in die
CEB" heisst in dieser Anlage: **N Domaenen-Konfigurationen -> N CEB-Strecken.**

### 3.4 Verhaeltnis zur sechsten Systemachse "Erweiterungshardware"

**Es ist NICHT dasselbe und auch kein Teil davon. Es steht daneben.** Belegt am
Definitionssatz des Owners, §51-B3 (`LEDGER:2765`, verbatim):

> "**ALLES ist eine Hardware-Erweiterung, das kein CPU-Core im herkoemmlichen Sinne ist und
> speziellen Befehlssatz benoetigt.**"

P- und E-Cores **sind** CPU-Cores im herkoemmlichen Sinn und brauchen **keinen** eigenen
Befehlssatz -- beide sind x86-64, und auf Alder/Raptor Lake ist AVX-512 gerade *deaktiviert*,
damit der ISA-Schnitt uniform bleibt. Das Q2-Ruling selbst
(`docs/plaene/20260717-inc1-bauplan-ADDENDUM-Q1-DACH-Q2-VORLAGE-Q3-COMPILER.md:177`, Owner
verbatim) bindet die Achse an SIMD-Permutation und `-march`-Flags:

> "… Permutiert etwa **simd_extension** selbst fuer die Systemachse zu seiner Laufzeit durch …
> Daher sind die Systemachse der **Erweiterungshardware (SIMD, GPU)** eine weitere eigene
> Systemachse, die erstmal nur auf SIMD ausgedehnt wird. GO fuer den Bau"

und `:189-193` praezisiert: *"**Flag-QUELLE** = `ExtensionHardwareSystemAxis<D>`", "**ORT** =
`CompileFn`-Naht: `-march`/`-mavx…`"*. Eine PMU-Domaene ist keine `-march`-Auspraegung und wird
nicht permutiert.

**Zum heutigen Stand der Achse, damit die Zahl "sechste" nicht in die Irre fuehrt:** die Achse
ist gebaut, **umbenannt und zum Hub umgezogen** (`measurement/external_utils_family_axis.hpp:1-8`:
*"der Knoten hiess bis hierher 'extension_hardware'; der Hub-Zuschnitt macht ihn zum KOPF aller
SYSTEM-Meta-Metas"*), und die Zahl der System-**Haupt**-Achsen ist heute **DREI**, nicht sechs --
`abi/system_axis_order.hpp:42-46`:

```cpp
inline constexpr std::array<std::string_view, kSystemAxisOrderCount> kSystemAxisOrder{{
    "target_isa",
    "operating_system",
    "external_utils",
}};
```

mit `:15-16`: *"A3 (O-8 Schritt 4) SETZT die finale Ordnung des Owner-KERNs: **GENAU DREI
Haupt-Achsen**"*. Die alte Insel ist ausdruecklich ausgeschlossen
(`measurement/system_axis_registry.xml:8-9`: *"AUSSCHLUSS: `extension_hardware_system_axis.hpp` =
DEPRECATED-Insel"*).

### 3.5 Verhaeltnis zur Owner-Regel "HW-Erkennung per Factory zur Laufzeit, nie statisch"

**Die Zuordnung erfuellt die Regel nicht nur -- sie ist die einzige, die sie erfuellt.**
Owner-KERN (Memory `feedback_hardware_erkennung_factory_laufzeit_nie_statisch`, 27.07.,
verbatim):

> "sollte nie fest gesetzt werden, sondern wird durch CEB mithilfe der Hardware-Haupt-Systemachsen
> aus dem OS ausgelesen, daher **nie statisch**, es braucht eine **Klasse mit einem factory
> Pattern fuer die Hardware Erkennung**, welche dies ueber alle Systemachsen wie **ISA x OS** fuer
> den Anfang erkennen kann."

Die Factory **existiert und ist gebaut** -- `measurement/hardware_probe_factory.hpp:106-107`
(`HardwareProbeDevice<IsaComplexAxis, OsAxis>`), Totalitaets-Wache `:264-268`. Sie traegt seit
OD-10-RT bereits **zwei** Erhebungen (`:33-39`: *"neben der RAM-Kette haengt eine zweite Erhebung
an dieser Factory: die numa/page-Probe … Sie waehlt ihre Familie ueber DIESELBE Zell-Koordinate"*).
**Die Domaenen-Erhebung ist die dritte** -- gleiche Zelle, gleiche Form, keine Strukturaenderung.

**Und hier liegt der schaerfste Ist-Widerspruch zur Regel** -- er betrifft die POLICY-Zeile:
`measurement/system_axis_registry.xml:29-34` fuehrt

```xml
    <sub_axis id="scheduling" parent="target_isa" stage="ct" kind="fixed_enum_tuple">
      …
      <sub_dim id="hetero_core_dispatch" value_ordinal="0"/>
```

`value_ordinal="0"` ist `HeteroCoreDispatch::None`
(`concepts/scheduling_strategy.hpp:39`: `enum class HeteroCoreDispatch : std::uint8_t
{ None = 0, HybridAware = 1, PCoresOnly = 2, ECoresOnly = 3 };`). **Die P/E-Eigenschaft steht
heute als statische Compile-Zeit-Konstante `None` in der System-Achsen-Registry.** Genau das
verbietet der Owner-KERN, und genau das nennt §16.3-E17 *"sinnlos"*.

> **Die Zuordnung loest den Widerspruch, ohne die CT-Zeile zu verbieten:** `hetero_core_dispatch`
> ist die **POLICY** und darf CT sein (eine Politik *waehlt* man beim Bau). Was **nicht** CT sein
> darf, ist das **FAKTUM** -- und das ist heute gar nicht modelliert, sondern nur als `false`
> festgenagelt. Die CT-Policy muss lediglich aus der RT-Freigabe des FAKTUMS gespeist werden
> statt aus einer Konstante. **Das ist exakt die zweistufige Form aus `LEDGER:4083`.**

---

## 3b. DIE ZWEI-PMC-KONSEQUENZ

### 3b.1 Was ist die Einheit, die zwei Mal vorkommt?

**Sie hat im Code bereits einen Namen und einen Ort: `PmcSystemAxis`, ein Baustein der
`collector`-Achse der MESS-Registry.**

`measurement/measurement_axis_registry.xml:24-41` (generiert, `tools/measurement_axis_registry_gen/main.cpp:153`):

```xml
  <axis id="collector" category="system_measurement" axis_kind="system_measurement" binary_id="never" stage="ct" baustein_count="3">
    <baustein name="WallClockSystemAxis" … regime_ordinal="0"> … </baustein>
    <baustein name="ObserverSnapshotSystemAxis" … regime_ordinal="0"> … </baustein>
    <baustein name="PmcSystemAxis" wrapper="PmcSystemAxis" … enabled="true" regime_ordinal="1">
      <category ref="CACHE_MISS_L1"/> … <category ref="ENERGY_J"/>
    </baustein>
  </axis>
```

Der Typ: `measurement/system_axis.hpp:389-394`

```cpp
struct PmcSystemAxis final : SystemAxis<PmcSystemAxis> {
    using counters_t = ::comdare::cache_engine::measurement::PmcCounters;
    counters_t const* counters = nullptr;
    explicit constexpr PmcSystemAxis(counters_t const& counters_) noexcept : counters(&counters_) {}
```

**Damit ist die Einheit praezise benannt:** ein `PmcSystemAxis` ist *ein Sammler, der an genau
einen `PmcCounters`-Satz gebunden ist* und *sieben Mess-Kategorien bedient*. **Er ist heute ein
Singleton der Registry** (`baustein_count="3"`, davon genau **ein** PMC-Sammler).

**Der KERN sagt: auf prod2 muss es zwei davon geben.** Nicht zwei Werte in einem Sammler,
sondern zwei Sammler -- weil `PmcCounters` (`measurement/pmc_source.hpp:19-28`) ein *flacher*
Satz ohne Domaenen-Feld ist und die getrennte Auswertung (K-2) zwei Reihen verlangt, nicht eine
mit Doppelbelegung.

**Die zweite Einheit derselben Sache, eine Ebene tiefer:** `IPmcSource` und die Factory
`make_pmc_source()` (`builder/pmc_source_factory.hpp:29`). Sie wird heute **einmal je
Mess-Worker** erzeugt -- `builder/experiment_tree/cache_engine_builder_iterator.hpp:2036-2038`,
verbatim:

> "#45 (§16.2-M1/§61-MODI): der PMC-Source wird **PRO Mess-Worker einmal erzeugt** … NICHT je
> Op/Binary und NICHT geteilt (ein realer LinuxPerfPmcSource ist nicht thread-safe teilbar).
> Sequentiell (measure/release/default) => **genau EIN Source fuer den ganzen Lauf**"

**Das ist der Satz, an dem der KERN heute bricht:** "genau EIN Source fuer den ganzen Lauf" ist
auf prod2 falsch. Es muessen **zwei Sources je Lauf** sein, oder **zwei Laeufe**.

### 3b.2 Zwei CEB, zwei Mess-Laeufe, oder eine CEB mit zwei Domaenen?

**Antwort: ZWEI CEB-KOMPILATE auf prod2, EINES auf prod1. Kein Runtime-Schalter.**

Ableitung, Schritt fuer Schritt an der Doktrin:

1. Der KERN sagt *"je Konfiguration **compile time** … in die CEB eingearbeitet"*. Damit ist
   ein Runtime-Zweig ausgeschlossen -- er widerspraeche zusaetzlich
   `feedback_no_runtime_switch` und dem 05-31-Plan (*"Kein Runtime-Switch im Hot-Path"*).
2. Die Mess-Tooling-Achse ist die Achse, die **je Wahl eine eigene CEB erzeugt** --
   `measurement_tooling_registry.hpp:4-5`: *"N Tooling-Konfigs -> N CEB-Pipelines"*.
3. Die PMU-Domaene ist eine Auspraegung der Mess-**Einrichtung** (3.1) -> sie faechert also
   dieselbe Auffaecherung wie `[a,b,c]` weiter auf.
4. **Stufe 1 (RT) macht die Kardinalitaet:** die CEB erhebt zur Laufzeit *"diese Maschine hat
   zwei Domaenen"* (FAKTUM-Unter-Achse) -> der Planer gibt die Domaenen-Menge frei -> **Stufe 2
   (CT)** baut je freigegebener Domaene ein CEB-Kompilat mit fest einkompilierter
   Domaenen-Apparatur.
5. **Stufe 3** bleibt unberuehrt: die Tier-Binary traegt keinen PMC-Code (`i_measurement_source.hpp:3-6`,
   host-seitig), also **kein Tier-Neubau**. Das ist der Grund, warum diese Zuordnung billig ist
   (Abschnitt 6).

**Warum nicht "eine CEB mit zwei einkompilierten Domaenen":** technisch moeglich, aber es
verschiebt die Wahl in die Laufzeit der CEB (welche Domaene misst gerade?) und damit den
Domaenen-Wert aus der **Identitaet** in eine **Variable**. Der Owner hat fuer die Mess-Tooling-Achse
bereits gegenteilig entschieden (je Wahl eine CEB) -- und die Fingerprint-Frage (Abschnitt 5)
verlangt dieselbe Haerte. **Empfehlung: zwei Kompilate. Owner-Entscheid O-A in 7.**

### 3b.3 Wie viele Mess-Zeilen entstehen dann?

Bezugsgroesse, belegt:
`docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:663` --
**216 Mess-Settings je Binary** = 6 workloads x 4 working\_set x 3 hw\_prefetcher x 1 thread x
3 repetitions, Quelle `all_axes_golden.profile.xml:112,126,156,157,160` (von mir am Objekt
nachgezaehlt: `<workloads>` 6 Token, `<working_set_sweep>` 4 Werte, `<hw_prefetcher>` 3 Werte,
`<thread_count>1</thread_count>`, `<repetitions count="3">`).

**Je Binary:**

| Maschine | PMU-Domaenen | Mess-Zeilen je Binary |
|---|---:|---:|
| prod1 (Zen 5, uniform) | 1 | **216** |
| prod2 (Alder Lake-S, hybrid) | 2 (`cpu_core`, `cpu_atom`) | **432** |
| odroid (Alder Lake-N, reine E-Kerne) | 1 | **216** |

**Ueber die Flotte** (524.288 Tier-Binaries, `profile_facade/source_catalog.hpp:169`
`static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)` x 4 System-Perms):

Heute wird jede Binary **einmal** gemessen, aufgeteilt auf zwei Lanes. Mit der Zwei-PMC-Regel
verdoppelt sich der Ertrag *und* der Aufwand der Intel-Lane. Die faire Aufteilung verschiebt
sich damit:

```
    Ausgleichsbedingung   216 * n_amd  =  432 * n_intel      und  n_amd + n_intel = 524.288
    =>  n_amd   = 349.525 Binaries  (2/3)
        n_intel = 174.763 Binaries  (1/3)
    Zeilen      = 349.525*216 + 174.763*432 = 75.497.400 + 75.497.616 = 150.995.016
```

**Gegen heute:** 524.288 x 216 = **113.246.208** Zeilen. Also **+33,4 % Mess-Zeilen** und, bei
gleicher Zeit je Zeile, **+33,4 % Wanduhr je Lane**.

Mit der belegten Zeit je Mess-Fach (109,4 ms, aus echtem CSV;
`docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md:178`, dort ausdruecklich als
**Untergrenze** gefuehrt):

| | heute | mit Zwei-PMC |
|---|---:|---:|
| Zeilen gesamt | 113,2 Mio | **151,0 Mio** |
| Wanduhr je Lane (2 Lanes, 1 Thread) | 71,7 Tage | **95,6 Tage** |

**Einordnung, unbequem:** beide Zahlen liegen weit ueber den 40 Tagen bis zum 15.09. Die
Zwei-PMC-Regel **verschaerft eine bereits bestehende, owner-bekannte Luecke** (Posten B-3, dort:
*"Empfehlung Weg C (320er-Auswahl voll + alle Binaries flach) ≈ 3,1 d"*), sie erzeugt sie nicht.
**Auf einer 320er-Auswahl gerechnet** (Weg C, ~3,1 d heute) bedeutet Zwei-PMC entsprechend
**~4,1 d** -- das ist im Fenster. Die Frage "welche Teilmenge wird gemessen" (Owner-Entscheid
R-1) bleibt der Hebel; die Zwei-PMC-Regel aendert nur den Faktor, nicht die Machbarkeit.

**Nicht belegt und bewusst nicht gerechnet:** ob eine Domaenen-getrennte Messung *dieselbe*
Zeit je Fach braucht. Auf E-Kernen ist mit laengerer Laufzeit je Fach zu rechnen (niedrigere
IPC) -- das ist eine plausible, aber **unbelegte** Annahme und gehoert an der ersten realen
Scheibe nachkalibriert.

### 3b.4 Die Deep-Research-Pflicht: wie viele Architekturen, und woher die Ereignis-Kodierung?

**Was die Anlage HEUTE deklariert (belegt, `measurement/machine_simd_signature.hpp` +
`measurement/system_axis_registry.xml:154-201`):** genau **drei** Maschinen-Signaturen --

| Signatur | CPU | Mikroarchitektur(en) | PMU-Domaenen |
|---|---|---|---|
| `prod1_zen5` | Ryzen 9 9950X3D | Zen 5 | **1** |
| `prod2_raptor_lake` (Etikett stale, s. 7) | i9-12900K | **Golden Cove (P) + Gracemont (E)** | **2** |
| `odroid_gracemont` | Alder Lake-N | Gracemont | **1** |

Kommentar `machine_simd_signature.hpp:100`: *"Odroid-H4-Klasse: **Intel Alder Lake-N
(Gracemont)** -- kein AVX-512"*.

**Minimale Abdeckung nach K-3 ist damit: 3 Mikroarchitekturen / 4 PMU-Domaenen.** Und die
Odroid-Maschine ist dabei ein Geschenk: sie ist eine **reine E-Kern-Maschine**, auf der sich die
`cpu_atom`-Kodierung **isoliert verifizieren** laesst, ohne die Hybrid-Mehrdeutigkeit.

**Ein Nebenbefund, der zeigt, dass die Hybridizitaet heute schon durchschlaegt -- nur unbenannt:**
`prod2_raptor_lake` und `odroid_gracemont` haben in der Registry **exakt dieselben 9 Flags**
(`system_axis_registry.xml:179-200`), waehrend prod1 22 traegt. Die 22-vs-9-Differenz ist genau
die AVX-512-Familie. **prod2 ist in der Registry bereits auf sein E-Kern-Niveau gekappt** --
die Anlage traegt die Hybrid-Folge, ohne die Hybrid-Ursache zu kennen.

**Woher kommt die Ereignis-Kodierung? -- Heute: aus nichts von beidem.**

| Quelle | Existiert heute? | Beleg / Nenner |
|---|---|---|
| Generische Kernel-Abstraktion `PERF_TYPE_HW_CACHE` | **JA, ausschliesslich** | `linux_perf_pmc_source.hpp:211/213/215` -- 3 Events |
| Tabelle roher Event-Codes je Mikroarchitektur | **NEIN** | `PERF_TYPE_RAW`: **0 von 1929** Quelldateien |
| Kernel-Abfrage der PMU-Geraete (sysfs) | **NEIN** | `event_source/devices`: **0 von 1929** |
| Gegenprobe | -- | `perf_event_open` -> 5 Dateien; `PERF_TYPE_HW_CACHE` -> 1 Datei. Das Verfahren findet perf-Symbole. |

**Und der generische Weg ist nachweislich unzureichend -- auf BEIDEN Vendoren:**

- `linux_perf_pmc_source.hpp:216-217` (Selbstauskunft): *"L2 + coherence\_invalidations: **KEIN
  portabler generischer Counter** -> bewusst NICHT geoeffnet, Feld 0."*
- Der ENOENT-Fund aus 2.3: **auch `cache_misses_l3` faellt auf einem Zen-5-Host aus.**
- `measurement/system_axis.hpp:414-418`: `IPC_CPI` ist honest-0, *"es fehlen die
  Zaehler-QUELLEN, nicht der Sinn"* -- weil `PmcCounters` keine cycles/instructions traegt.

**Empfehlung (meine Ableitung, kein gefundener Entscheid): BEIDES, in dieser Rangfolge.**

1. **Primaer sysfs.** Der Kernel exponiert je PMU-Domaene sowohl den `type`
   (`/sys/bus/event_source/devices/cpu_core/type`) als auch **benannte Ereignisse**
   (`…/events/*`). Das loest die Domaenen-Routung **ohne jede Mikroarchitektur-Tabelle** und
   folgt der Owner-Regel "nie statisch": die Erhebung ist Laufzeit, das Ergebnis wird CT
   eingebaut. Es ist zugleich der einzige Weg, der ab Meteor Lake noch traegt
   (`20260716-e17-e18-deep-research-DOSSIER.md:9`: *"Ab Meteor Lake 0x1A unzureichend -> Linux
   sysfs `cpu_core`/`cpu_atom` + `cpu_capacity` **autoritativ**"*).
2. **Sekundaer eine CT-Tabelle je Mikroarchitektur** -- nur fuer die Ereignisse, die sysfs
   **nicht** benennt (L2, Kohaerenz-Invalidierungen). Quelle je Zeile: die Vendor-Referenz
   (Intel perfmon-JSON, AMD PPR), **pro Event-Code web-verifiziert** -- exakt die Pflicht, die
   der 05-31-Plan `:139-141` bereits formuliert.
3. **honest-0 nur dort, wo beide Wege leer bleiben** -- mit Begruendung in der Spalte, nach der
   bereits gebauten Fehlerklassen-Semantik (`system_axis.hpp:400-403`:
   `mark_source_unavailable()` statt Schein-0).

---

## 4. Was daraus fuer PMC folgt

### 4.1 Die vier Aenderungen, in Abhaengigkeitsreihenfolge

| # | Was | Wo genau | Klasse |
|---|---|---|---|
| **H-a** | FAKTUM erheben: `is_hybrid` + Domaenen-Liste zur **Laufzeit** | `platform_probe/cpuid_probe.hpp` (Leaf 0x1A, heute 0 Treffer) -> primaer sysfs; Ergebnis in `i_platform_probe.hpp:19-20` (Felder existieren); als dritte Erhebung an `hardware_probe_factory.hpp:106` | CEB-ONLY |
| **H-b** | Domaenen-`type` statt Konstante | `linux_perf_pmc_source.hpp:99` **nimmt `type` bereits als Parameter** -- nur `:211/:213/:215` reichen die Konstante durch. `cpu = -1` (`:110`) wird durch Pinning **oder** je-Domaene-fd aufgeloest | CEB-ONLY |
| **H-c** | Zwei Sammler statt einem | `measurement/system_axis.hpp:389` (`PmcSystemAxis` je Domaene) + `cache_engine_builder_iterator.hpp:2586` (`collect_ordered`-Ctx-Factory liefert heute *eine* Source) | CEB-ONLY |
| **H-d** | Domaene reist in die Daten | CSV additiv am Ende (`cache_engine_builder_iterator.hpp:481-504`, etabliertes Muster) + CEB-Identitaet (Abschnitt 5) | CEB-ONLY (+ Fingerprint, s. 5) |

### 4.2 Wo wird entschieden, WELCHE Domaene gewaehlt wird?

**Antwort nach der Stufen-Doktrin -- an drei Stellen, jede genau einmal:**

```
  [Planer, RT]      liest die FAKTUM-Unter-Achse der Maschine ("diese Maschine: {cpu_core, cpu_atom}")
                    und GIBT die Domaenen-Menge FREI                       <- Stufe 1, KERN: "Freigabe durch den Planer"
        |
        v
  [CEB, CT]         kompiliert JE freigegebener Domaene EIN Kompilat mit
                    fest einkompilierter Domaenen-Apparatur                <- Stufe 2, KERN: "compile time in die CEB"
        |
        v
  [Tier, CT]        unveraendert (PMC lebt host-seitig, nicht in der .so)  <- Stufe 3, kein Neubau
```

**Die einzige Laufzeit-Verzweigung, die bleiben darf**, ist die Gate-Pruefung ausserhalb der
Messschleife -- so bereits im 05-31-Plan `:150-152` begruendet und heute als
`available()`/`capabilities()` im Interface vorhanden (`i_measurement_source.hpp:51-56`,
`pmc_source.hpp:36`).

### 4.3 Wie reist die Entscheidung in die Messdaten? -- Heute: **gar nicht**

Das ist die Luecke, ohne deren Schliessung jede Domaenen-Spalte wertlos bliebe.

**Belegt:** die CSV-Spalte `platform` traegt **nicht** die messende Maschine, sondern ein
Profil-Literal. `profile_facade/profile_run_entry.hpp:390-392`:

```cpp
    std::string tag_platform      = a.platform_override.empty()
                                        ? (ro.platform.empty() ? std::string{"win-x86_64"} : ro.platform)
                                        : a.platform_override;
```

Quelle des Werts: `all_axes_golden.profile.xml:163` `platform="win-x86_64"`. Der Planer
**exportiert** zwar die messende Maschine -- `planner/experiment_plan_director.hpp:1418-1421`,
Kommentar verbatim: *"(platform-Tag) §61/§62 Plattform-Provenienz: die CSV-Spalte 'platform'
**MUSS die MESSENDE Maschine tragen**"* -- aber **niemand liest `COMDARE_PLATFORM`**
(0 Treffer ueber `libs/`; Gegenprobe: `getenv("COMDARE_` findet `COMDARE_MEASUREMENT_COMBO`,
`COMDARE_BESTANDSLOG`, `COMDARE_CXX` u. a.).

**Empirie, real:** in
`measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` steht in Spalte
`platform` durchgaengig `linux-x86_64` -- der Profil-Literalwert, nicht `amd@prod1` /
`intel@prod2`.

> **Konsequenz, hart:** waeren heute beide Lanes gelaufen, laegen die Zeilen von prod1 und prod2
> **in derselben Datei ohne unterscheidendes Merkmal.** Die Domaenen-Spalte ist also die
> **zweite** noetige Spalte -- die erste ist die Maschine.

---

## 5. Die Fingerprint-/Identitaets-Frage

### 5.1 Die Frage, praezise gestellt

Owner-KERN (E), verbatim
(`docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:63`):

> "**Mess-Achsen + System-Achsen + Organ-Achsen identisch -> fingerprint fuer identische binary
> fuer identische Messdaten.**" -- *"Hauptidee des Systems und des Lagers."*

Auf eine Hybrid-CPU angewandt zerfaellt der Satz in zwei Fragen, die getrennt beantwortet werden
muessen:

1. Muss die **Binary** je Domaene verschieden sein? (Fingerprint-Frage)
2. Muessen die **Messzeilen** je Domaene unterscheidbar sein? (Identitaets-Frage der Daten)

### 5.2 Antwort 1: NEIN -- die Domaene darf den Tier-Fingerprint NICHT beruehren

**Begruendung, dreifach belegt:**

- Das Preimage hat genau acht Glieder
  (`abi/anatomy_fingerprint.hpp:462-472`, selbst gelesen):
  `{Format, Organ, System, MESSUNG, Sub-Achsen, Toolchain, bvset, Overlay}`.
- PMC ist **nicht tier-bau-wirksam**: `add_compile_definitions(COMDARE_ENABLE_PMC)` wirkt auf den
  CMake-Teilbaum (den Treiber); die Tier-`.so` entsteht ueber einen eigenen `g++`-Subprozess, und
  `perm_mess_defines()` fuehrt das Flag nicht
  (`20260806-PLAN-messkette-ceb-observabletier.md:710-716`, dort mit
  `/usr/bin/grep -c COMDARE_ENABLE_PMC` = **0** in `build_orchestrator.hpp` belegt).
- Faende die Domaene den Weg ins Tier-Preimage, **verdoppelte sich die Flotte auf der
  Intel-Seite** -- 524.288 zusaetzliche Binaries fuer eine Eigenschaft, die in keiner davon
  Code aendert. Das waere ein reiner Identitaets-Phantomschmerz.

> **Bau-relevante Warnung, und der Grund, warum dieses Dokument HEUTE gebraucht wird:** Paket
> **M-1b** will Glied [5] (Toolchain, `abi/toolchain_stamp_glied.hpp:248`, heute 9 Felder) um ein
> Feld `mess` erweitern, das *"`MEASUREMENT_ON` + `ENABLE_PMC` + den Combo-Namen fuehrt"*
> (`…messkette…:453-456`). **Wenn dieses Feld unspezifisch "den Mess-Define-Satz" aufnimmt und
> die Domaenen-Wahl spaeter dort landet, ist die Flottenverdopplung eingebaut, ohne dass es
> jemand beschlossen hat.** Der Schnitt muss also lauten: *Glied [5] traegt, WAS die Tier-Binary
> baut -- nicht, WOMIT gemessen wird.*

### 5.3 Antwort 2: JA, zwingend -- und hier ist die unbequeme Wahrheit

**Die Messzeilen muessen unterscheidbar sein, und heute sind sie es nicht.** Schlimmer: auf
prod2 ist der Owner-KERN heute **nicht erfuellbar**, und zwar aus einem Grund, der nichts mit
PMC zu tun hat.

**Der Beleg:** es gibt **kein Pinning im Produktions-Messpfad**. Die Politik existiert
(`builder/measurement/thread_pinning.hpp`, `ScopedThreadPin`/`CorePinPolicy`/`NoPinPolicy`), hat
aber **genau einen** Aufrufer -- und der ist opt-in und nicht der Treiber:
`apps/f15_compare/main.cpp:225`

```cpp
    auto measurement_pin = pin_core.has_value() ? bld::CorePinPolicy{*pin_core}.pin() : bld::NoPinPolicy{}.pin();
```

mit `:173` *"AP-13/#247: **opt-in** Mess-Thread-Pinning (`--pin-core=N`); leer => kein Pinning"*.
Im Mess-Treiber-Pfad (`cache_engine_builder_iterator.hpp`, `profile_facade/`) sind es **0
Treffer** (`ScopedThreadPin|CorePinPolicy|NoPinPolicy` ueber beide Verzeichnisse).

**Daraus folgt, unbequem:**

> Auf prod2 kann der Scheduler den Mess-Thread waehrend eines Mess-Fachs zwischen einem
> Golden-Cove-Kern und einem Gracemont-Kern verschieben. **Dieselbe Binary, dieselbe Maschine,
> dieselben Mess-Achsen liefern dort heute NICHT reproduzierbar dieselben Ergebnisse** -- und
> zwar unabhaengig davon, ob PMC laeuft, weil auch die Wall-Clock-Zeit vom Kerntyp abhaengt.
>
> **Der Owner-KERN (E) ist auf prod2 heute strukturell verletzt.** Er ist nicht "noch nicht
> ueberprueft", er ist verletzt -- und er war es auch, bevor jemand ueber PMC nachdachte.

**Der Ausweg, und es gibt nur einen:** der Kerntyp muss **Teil der Mess-Konfiguration** werden,
nicht ein Zufall der Laufzeit. Konkret zwei Spalten, wie sie das E17/E18-Dossier bereits
vorschlaegt (`20260716-e17-e18-deep-research-DOSSIER.md:11-12`):

| Spalte | Bedeutung | Charakter |
|---|---|---|
| `pe_policy` | **worauf gepinnt wurde** (`Unpinned` / `PCoresOnly` / `ECoresOnly` / `HybridAware`) | **Konfiguration** -- gehoert zur Zeilen-Identitaet |
| `ran_on_core_type` | **worauf tatsaechlich gelaufen wurde** (beobachtet) | **Beobachtung** -- der Beleg, dass die Konfiguration gehalten hat |
| `pmu_domain` | **welche PMU-Domaene die Zaehler lieferte** (`cpu_core`/`cpu_atom`/`n/a`) | **Konfiguration** (neu, aus dem KERN) |
| `platform` | **welche Maschine gemessen hat** (heute Literal, s. 4.3) | **Konfiguration** -- muss repariert werden |

**Die Zeilen-Identitaet lautet damit:** *(binary\_fingerprint, Maschine, pe\_policy, pmu\_domain,
Mess-Setting)*. Erst mit diesem Tupel ist der Owner-Satz auf einer Hybrid-CPU ueberhaupt
**pruefbar**.

**Und die Owner-Regel dafuer existiert bereits** -- RF-6, `LEDGER:3580` / Volltext
`docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md:30-37`, Owner verbatim:

> "je Maschine deklariert und bei match gilt die Achse als **Wiederverwendbar**, wenn exakt
> gleiche Eigenschaften beider Systeme sonst angenommen werden koennen, auch wenn es sich nicht
> um den formal selben Maschinentyp handelt. … **Nur stempel Identitaet Auswirkung fuer gleiche
> Kombination auch gleicher Stempel**"

**Auf den Fall angewandt:** eine PMU-Domaene ist eine *deklarierte Maschinen-Eigenschaft* mit
*Stempel-Wirkung, aber ohne Bau-Wirkung* -- genau die Klasse, die RF-6 beschreibt. Der
`prod2/cpu_core`-Satz und der `prod2/cpu_atom`-Satz sind zwei verschiedene Kombinationen und
bekommen zwei verschiedene Stempel; die Binary bleibt eine.

### 5.4 Die dritte, kleinere Wahrheit

Selbst *innerhalb* einer Domaene ist "identische Ergebnisse" eine Naeherung (Turbo, Thermik,
Nachbar-Kerne). Der KERN meint erkennbar **Determinismus der Konfiguration**, nicht Bit-Gleichheit
der Zahlen. Die Hybrid-CPU ist trotzdem ein qualitativer Sprung: dort variiert nicht die
Streuung, sondern die **Messapparatur selbst**. Deshalb reicht "mehr Wiederholungen" hier
nicht -- es braucht die Spalte.

---

## 6. Bau-Reihenfolge und Kosten

### 6.1 Die Kostenklassen (belegt, `…messkette…:672-676`)

| Klasse | Was sie beruehrt | CEB | Tier-Binaries | Kosten |
|---|---|---:|---:|---|
| **CEB-ONLY** | Treiber-Compile-Graph | 1 | **0** | **~77 s** + Pipeline |
| **TIER** | Define-Menge des `g++`-Subprozesses | 1 | 524.288 | **~34,4 h** |
| **FINGERPRINT** | Preimage / `dll_is_current` | 1 | die **bereits gebauten** | **heute 0 h** (Bestand 0) · nach dem 1. Batch: 34,4 h + Entwertung aller Messdaten |

**Das offene Fenster, belegt (`…messkette…:679-687`):**

```
    Bestand an .fingerprint-Sidecars HEUTE          :  0
    Kosten einer Fingerprint-Aenderung HEUTE        :  0 h
    Kosten derselben Aenderung nach dem 1. Batch    :  34,4 h Neubau + ALLE Messdaten wertlos
```

*"Das Fenster schliesst mit dem ersten `.fingerprint`, den `provision_core` schreibt -- und das
tut auch ein reiner `provision_only`-Bau."*

### 6.2 Einordnung der vier Pakete aus 4.1

| Paket | Klasse | Begruendung am Objekt | Fenster-relevant? |
|---|---|---|---|
| **H-a** FAKTUM-Erhebung (0x1A/sysfs, Factory-Zelle) | **CEB-ONLY** | Probe + Platform-POD sind Host-/Treiber-Code; `perm_mess_defines()` unberuehrt | nein |
| **H-b** Domaenen-`type` + `cpu`-Aufloesung | **CEB-ONLY** | `linux_perf_pmc_source.hpp` ist Treiber-Code (`…messkette…:700-701` fuehrt M-3a/b/c genauso) | nein |
| **H-c** zwei `PmcSystemAxis`-Sammler | **CEB-ONLY** | `system_axis.hpp` + Iterator sind Treiber-Code | nein |
| **H-d** CSV-Spalten (`pmu_domain`, `pe_policy`, `ran_on_core_type`) + `platform`-Reparatur | **CEB-ONLY**, **aber Datenbruch-relevant** | additive Spalten, kein Define -- **aber** Zeilen vor und nach der Aenderung tragen andere Spalten-Semantik (`…messkette…:751`: *"Datenbruch ohne Neubau"*) | **ja, vor der zu behaltenden Messung** |
| **H-e** Domaene aus dem Tier-Preimage **heraushalten** (Schnitt-Auflage an M-1b) | **FINGERPRINT** | s. 5.2 | **JA, HEUTE** |
| **G-270a** Sichtung der drei verriegelten Testzeilen | **Diagnose/Owner** | `tests/unit/test_cpuid_probe.cpp:62-64` -- sobald die Probe ehrlich erkennt, wird `EXPECT_FALSE(has_hybrid_cores)` auf prod2 rot und auf prod1 gruen | Voraussetzung fuer H-a |

**Die gute Nachricht, klar gesagt:** **die gesamte Zwei-PMC-Zuordnung ist Klasse CEB-ONLY.**
Kein Tier-Neubau, keine 34,4 h. Der Grund ist strukturell und nicht Glueck: PMC lebt host-seitig
(`i_measurement_source.hpp:3-6`), also beruehrt die Domaenen-Wahl die Tier-Binary nicht.

**Die schlechte Nachricht:** **H-e ist HEUTE faellig**, obwohl es selbst nichts baut. Es ist eine
**Schnitt-Auflage an das M-1b-Preimage**, und Preimage-Entscheidungen sind ab dem ersten
`.fingerprint` nicht mehr kostenlos.

### 6.3 Vorgeschlagene Reihenfolge

| Stufe | Was | Warum jetzt / warum spaeter |
|---|---|---|
| **T0 -- heute, mit M-1b** | **H-e:** die Auflage schriftlich, dass Glied [5] nur **bau-wirksame** Mess-Defines traegt; PMU-Domaene und Kern-Klasse gehoeren in **Stempel/CSV**, nicht ins Tier-Preimage | Das Fenster ist offen (0 Sidecars) und schliesst mit dem ersten Batch. Kostet 0 h, spart potenziell 34,4 h. |
| **T0 -- heute, ohne Bau** | **G-270a**-Sichtung der 3 Zeilen `test_cpuid_probe.cpp:62-64` | Es ist der einzige verbliebene echte Riegel. Die Hardware ist seit 13.07. da (`LEDGER:785`: *"cache-misses/cache-references auf **cpu_core+cpu_atom verifiziert**"*). |
| **T1 -- vor dem 1. Batch** | **H-d** Spalten additiv (`platform`-Reparatur zuerst) | Spaeter = Datenbruch ohne Neubau. Und ohne `platform` ist jede Domaenen-Spalte wertlos (4.3). |
| **T1/T2 -- Diagnose zuerst** | den errno-Diagnose-Commit `3f0d989d` **auf prod2 laufen lassen** | Er beantwortet in einem Lauf, ob prod2 fehlschlaegt (ENOENT/EINVAL) oder still die falsche Domaene trifft. **Ohne diesen Lauf ist H-b ein Bau auf Verdacht.** |
| **T2 -- vor der Voll-Messung** | **H-a** + **H-b** + **H-c** (die eigentliche Zwei-PMC-Mechanik) | ~77 s Bau je Welle; kein Fingerprint-Bezug, solange H-e haelt. |
| **T3** | Deep-Research-Tabelle fuer L2/Kohaerenz je Mikroarchitektur | Erst wenn sysfs zeigt, was es benennt und was nicht. |

---

## 7. Die offenen Owner-Fragen

### O-A -- Zwei CEB-Kompilate oder eine CEB mit zwei Domaenen?

**Empfehlung: ZWEI Kompilate.** Begruendung: der KERN sagt *"je Konfiguration compile time"*, und
die Mess-Tooling-Achse ist bereits so gebaut (*"N Tooling-Konfigs -> N CEB-Pipelines"*,
`measurement_tooling_registry.hpp:4-5`). Eine CEB mit zwei Domaenen verschiebt die Wahl in eine
Laufzeit-Variable und macht sie aus der Identitaet heraus.
**Preis:** doppelte CEB-Bauzeit auf der Intel-Lane -- 2 x ~77 s, vernachlaessigbar.
**Was ich nicht entscheiden kann:** ob die zweite CEB eine eigene CI-Strecke bekommt (wie
`[a,b,c]`) oder als zweiter Job derselben Lane laeuft. Das beruehrt die Runner-Belegung.

### O-B -- Traegt der Tier-Fingerprint die PMU-Domaene?

**Empfehlung: NEIN, ausdruecklich nicht** (Begruendung 5.2: sonst 524.288 zusaetzliche Binaries
fuer eine Eigenschaft, die in keiner davon Code aendert). **Aber die Domaene MUSS in die
CEB-Identitaet und in die CSV-Zeile.** Die Frage ist deshalb keine Ja/Nein-Frage, sondern eine
Schnitt-Frage, und sie ist **heute** faellig, weil M-1b das Preimage einfriert.

### O-C -- `pe_policy`: Default `Unpinned` oder Pflicht-Pinning?

**Das ist die schwerste Frage dieses Dokuments und sie ist keine PMC-Frage.**
`Unpinned` als Default ist golden-neutral und kostet einen Pass
(`20260716-e17-e18-deep-research-DOSSIER.md:12`) -- **aber es haelt den Owner-KERN (E) auf prod2
strukturell verletzt** (5.3). Pflicht-Pinning erfuellt den KERN, aendert aber die Messgroesse:
gemessen wird dann nicht mehr "die Maschine", sondern "ein Kerntyp der Maschine".
**Meine Empfehlung: Pflicht-Pinning auf prod2, Default `Unpinned` auf uniformen Maschinen** --
weil die Thesis genau das zusagt (*"P- und E-Cores getrennt vermessen … statt
zusammenaggregiert"*, `05_evaluation.tex:76-79`), und weil eine unpinned Hybrid-Messung eine
Zahl liefert, die keine Frage der Thesis beantwortet.
**Warum ich es nicht entscheide:** es aendert die Semantik der Intel-Spalte in allen Diagrammen
des Anhangs.

### O-D -- Wie weit reicht "ALLE belegbaren Architekturen"?

Die Anlage kennt heute **3 Signaturen / 4 Domaenen** (3b.4). "Alle belegbaren AMD- und
Intel-Architekturen" waere deutlich mehr (Zen 2/3/4/5, Skylake…Raptor, Alder, Meteor…) --
**ohne die Hardware ist jede weitere Zeile unverifizierbar** und damit genau das
Phantom-Risiko, das der GO-5-Entscheid schon einmal ausgeschlossen hat
(`20260712-go5-forks-und-smoke-profil-DOSSIER.md:213-218`: *"jeder Vorbau waere unverifizierbar
= Phantom-Risiko"*).
**Empfehlung: die Tabelle wird *strukturell* fuer beliebig viele Architekturen gebaut, aber
*befuellt* nur fuer die drei belegten Maschinen** -- alles weitere traegt einen expliziten
`unverified`-Marker und liefert honest-0 mit Begruendung. Das erfuellt K-3 dem Verfahren nach,
ohne unbelegte Event-Codes in die Messdaten zu lassen.

### O-E -- Die Mess-Zeit

Zwei-PMC bedeutet **+33,4 %** Mess-Zeilen bei ausgeglichener Lane-Aufteilung (3b.3). Auf die
Vollmenge gerechnet sind das 95,6 statt 71,7 Tage je Lane -- beides ausserhalb des Fensters bis
15.09. **Das ist kein neuer Befund** (Posten B-3), aber der Faktor verschiebt sich, und der
Owner-Entscheid **R-1** (welche Teilmenge gemessen wird) wird dadurch dringender, nicht
weniger dringend.

### O-F -- Das Etikett `prod2_raptor_lake`

Die Registry-ID (`system_axis_registry.xml:23,179`; `machine_identity.hpp:444`) sagt
*Raptor Lake*, das Fabrikations-Tupel `GenuineIntel/6/151/2` ist **Alder Lake-S**, und die
Kommentare wissen es (`machine_identity.hpp:196-198`: *"Family 6 / Model 151 / Stepping 2 ist
**Alder Lake-S**, die CPU des Hosts prod2 (i9-12900K)"*). **Reiner Etiketten-Drift, kein
Wertfehler** -- aber sobald eine Mikroarchitektur-Tabelle danebensteht, wird das Etikett zur
Fehlerquelle.
**Empfehlung: umbenennen, aber erst im selben Fenster wie H-d**, weil die ID in Stempel und
Registry reist.

---

## 8. WIDERSPRUECHE zwischen KERN und Sucher-Befunden -- benannt, nicht geglaettet

| # | Der Befund | Der KERN | Aufloesung |
|---|---|---|---|
| **W-1** | §16.3-E17 ordnet P/E-Core der **System**-Welt zu (dyn. Unter-Achse unter Hardware) | Der KERN spricht von **PMC-Einrichtungen**, die der **Planer** freigibt und die **CEB** einkompiliert -- das ist die **Mess**-Welt | **Kein echter Widerspruch, sondern zwei Dinge:** FAKTUM (System) und EINRICHTUNG (Mess). Beide Owner-Aussagen gelten, an verschiedenen Objekten (3.1). Der Praezedenzfall ist die HW-Erkennung selbst (`hardware_probe_factory.hpp:8-13`: Mess-Realm, **liest** System-Achsen). |
| **W-2** | Der 05-31-Plan waehlt **einen** Vendor je Bau (`COMDARE_MEASUREMENT_VENDOR ∈ {…}`, `SelectedMeasurementSource`) | Der KERN verlangt **zwei PMC auf einer Maschine** | Der Plan ist **zu grob**: seine Achse ist *Vendor*, die noetige Achse ist *PMU-Domaene*. Der Plan ist nicht falsch, er ist **eine Ebene zu hoch**. Sein Mechanismus (CT-Selektor + RT-Gate) traegt die feinere Achse unveraendert. |
| **W-3** | `LEDGER:265` fuehrt `P/E-Core (HW+#215)` als **doppelt gegatet**, GO-5 (`…go5…:213-218`) haelt den Fork *"gated, kein Vorbau"* mit Begruendung *"HARDWARE (RMA bis ~September)"* | Der KERN behandelt Zwei-PMC als **Vorgabe**, nicht als Fork | **Die Gate-Begruendung ist SUPERSEDED.** Die Hardware ist seit 13.07. da (`LEDGER:3662`: *"prod2-HW ist **GEKLAERT** … i9-12900K (Alder Lake …) per Live-lscpu; #276:14 ist pre-RMA-stale"*), der Runner seit 08.07. online mit *"cpu_core+cpu_atom verifiziert"* (`LEDGER:785`). Das verbliebene Gate ist **G-270a = eine Owner-Sichtung von 3 Testzeilen**, kein Hardware-Gate. |
| **W-4** | Die Registry fuehrt `hetero_core_dispatch` als **`stage="ct"`, Wert `None`** | Owner-KERN: HW-Erkennung **nie statisch**; E17: *"statische Compile-Time-Einrichtung ist sinnlos"* | Aufgeloest durch die FAKTUM/POLICY-Trennung (3.5): die **Politik** darf CT sein, das **Faktum** nicht. Heute ist gar kein Faktum modelliert -- nur eine auf `false` festgenagelte Politik. |
| **W-5** | Der Mechanik-Sucher meldete *"Pinning: 0 Produktionsaufrufer"* | -- | **Praezisierung durch eigene Nachzaehlung:** es gibt **einen** Aufrufer, `apps/f15_compare/main.cpp:225`, opt-in per `--pin-core=N`. Im **Mess-Treiber-Pfad** sind es 0. Die Schlussfolgerung bleibt, die Zahl war ungenau. |
| **W-6** | Drei Dokumente fuehren *"pmc:intel … bis ~September BLOCKIERT"* fort (`LEDGER:865-872`; `20260806-PLAN-messkette-ceb-observabletier.md:903` mit *"Raptor Lake"* **und** *"14900KS-RMA blockiert"*; `20260716-richtungs-verdikt…:39`) | -- | **Alle drei sind stale aus derselben Wurzel.** Besonders `…messkette…:903` ist heutigen Datums und wuerde RAW-Event-Codes fuer die **falsche Mikroarchitektur** ableiten (Raptor statt Alder). **Vor jeder Event-Tabelle zu korrigieren.** |

---

## 9. Zusammenfassung in einem Bild

```
   PLANER  (Mess-Realm, Stufe 1 = RUNTIME-Freigabe)
     |  liest: FAKTUM-Unter-Achse "diese Maschine hat {cpu_core, cpu_atom}"
     |  gibt frei: Domaenen-Menge + pe_policy-Menge
     v
   CEB     (Stufe 2 = COMPILE-TIME-Einbau)            <-- HIER sagt der KERN "eingearbeitet"
     |  je freigegebener Domaene EIN Kompilat:
     |    - PmcSystemAxis-Sammler fest auf cpu_core   (Kompilat 1)
     |    - PmcSystemAxis-Sammler fest auf cpu_atom   (Kompilat 2)
     |  prod1: 1 Kompilat.  prod2: 2 Kompilate.  odroid: 1 Kompilat.
     v
   TIER    (Stufe 3)  -- UNVERAENDERT, PMC lebt host-seitig  -> KEIN Neubau, KEINE 34,4 h
     |
     v
   CSV     platform=intel@prod2 | pmu_domain=cpu_atom | pe_policy=ECoresOnly | ran_on_core_type=E
           ^^^^^^^^^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^
           heute LITERAL         existiert nicht      existiert nicht        existiert nicht

   FINGERPRINT der Tier-Binary:  UNBERUEHRT.  Die Domaene ist Stempel + Spalte, nie binary_id.
```

---

## 10. Belegte Dateien (absolute Pfade)

**super** (`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`):

- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Z. 265, 785, 865-878, 1137, 1312, 1576-1578, 2760, 2765, 3564, 3578-3580, 3662, 4082-4083, 4095)
- `docs/sessions/20260726-SESSION-rf-antworten-1-bis-8.md` (RF-6 Z. 30-37, RF-8 Z. 47-50)
- `docs/sessions/20260727-PLAN-hw-erkennung-zwei-ebenen-factory-stempel.md` (Z. 234-243, 246-263, 286-292)
- `docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md` (Z. 60-63, 415-419, 453-456, 655-760, 903)
- `docs/plaene/20260806-PLAN-owner-antworten-vertiefung.md` (Z. 102, 115, 160-260)
- `docs/plaene/20260716-e17-e18-deep-research-DOSSIER.md` (Z. 7-13)
- `docs/plaene/20260712-go5-forks-und-smoke-profil-DOSSIER.md` (Z. 203-224)
- `docs/plaene/20260717-inc1-bauplan-ADDENDUM-Q1-DACH-Q2-VORLAGE-Q3-COMPILER.md` (Z. 177, 184, 189-193)
- `docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md` (Z. 178)
- `docs/termine/20260409 Termin 3/*.docx` · `docs/termine/20260412 Termin 4/*.docx`
- `thesis/diplomarbeit/kapitel/de/05_evaluation.tex` (Z. 68-82, LIVE) · `…/01_einleitung.tex:94` · `…/06_evaluation_methodology.tex:1-2` (NICHT eingebunden)

**ce** (`…/Code/external/comdare-cache-engine`):

- `docs/sessions/20260531-mess-abstraktion-cross-platform-architektur-plan.md` (Z. 4-6, 105, 132, 139-141, 145-152, 182, 187)
- `libs/cache_engine/builder/linux_perf_pmc_source.hpp` (Z. 10-17, 36, 99-117, 206-223)
- `libs/cache_engine/builder/pmc_source_factory.hpp` (Z. 27-37)
- `libs/cache_engine/builder/measurement/thread_pinning.hpp`
- `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` (Z. 481-504, 2036-2038, 2578-2590)
- `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp` (Z. 22-24, 389-429)
- `libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.xml` (Z. 8-41)
- `libs/cache_engine/include/cache_engine/measurement/measurement_tooling_registry.hpp` (Z. 2-5, 26-31, 44-49)
- `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml` (Z. 8-9, 18-39, 154-201)
- `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp` (Z. 182-201, 266-268, 444)
- `libs/cache_engine/include/cache_engine/measurement/machine_simd_signature.hpp` (Z. 90-128)
- `libs/cache_engine/include/cache_engine/measurement/hardware_probe_factory.hpp` (Z. 8-13, 19-24, 33-39, 106-110)
- `libs/cache_engine/include/cache_engine/measurement/target_isa_sub_axes.hpp` (Z. 16-22)
- `libs/cache_engine/include/cache_engine/measurement/i_measurement_source.hpp` (Z. 1-6, 51-56)
- `libs/cache_engine/include/cache_engine/measurement/pmc_source.hpp` (Z. 19-28)
- `libs/cache_engine/include/cache_engine/platform/i_platform_probe.hpp` (Z. 14-23)
- `libs/cache_engine/include/cache_engine/platform/core_layout.hpp` (Z. 14-19, 37, 43)
- `libs/cache_engine/include/cache_engine/platform_probe/cpuid_platform_probe.hpp` (Z. 38-39)
- `libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp`
- `libs/cache_engine/include/cache_engine/abi/system_axis_order.hpp` (Z. 10-46)
- `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp` (Z. 85-111, 462-472)
- `libs/cache_engine/include/cache_engine/concepts/scheduling_strategy.hpp` (Z. 38-39)
- `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` (Z. 273-291, 597-604, 1418-1421)
- `libs/cache_engine/profile_facade/profile_run_entry.hpp` (Z. 390-392)
- `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` (Z. 112, 126, 156-163)
- `libs/cache_engine/topics/hardware/axis_09b_simd_extension/axis_09b_simd_extension_avx512.hpp` (Z. 67-72)
- `apps/f15_compare/main.cpp` (Z. 173, 225)
- `tests/unit/test_cpuid_probe.cpp` (Z. 62-64) · `tests/unit/thesis_tiere/linux_perf_pmc_smoke.cpp` (Z. 44-59, 97-104)
- `tools/measurement_axis_registry_gen/main.cpp` (Z. 153)

**Arbeitsbaum** (nur gelesen, nicht angefasst): `/home/comdare/wt-pmc-errno`, Commit `3f0d989d`.
