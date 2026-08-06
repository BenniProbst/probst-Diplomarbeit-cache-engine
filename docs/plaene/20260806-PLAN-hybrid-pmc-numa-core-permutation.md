# Die Hybrid-PMC-Messung als Achsen-Permutation -- EINE CEB, EINE Binary, zwei Pinnings

**Erhebungsstand:** 2026-08-06. super `18a0bdf3` · ce-Submodul `90bca126` (Arbeitsbaum sauber).
Alle Datei:Zeile-Angaben gegen diesen Stand, jede aus Live-Lesung.

**Pfad-Kuerzel:**
`super/` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
`ce/` = `super/Code/external/comdare-cache-engine`

**Was dieser Plan ist und was nicht.** Der Owner hat die Mechanik VORGEGEBEN. Dieser Plan sucht sie
nicht, sondern buchstabiert am Objekt aus, **wo sie in den Code greift** und was daraus folgt.
Er baut nichts. Wo ein Befund dem KERN widerspricht, gewinnt der KERN -- der Widerspruch steht in
Abschnitt 9 als Owner-Frage, nicht als Einwand.

---

## 1. Die Vorgabe

### 1.1 Der Owner-KERN, verbatim

> "Die CEB **kann beide Messfuehler tragen**, aber legt die Ergebnisse **je PMC getrennt** ab.
> Die Tier-Binary wird ueber die Permutation aller Achsen insbesondere ueber die **Permutation
> der NUMA Achse und deren Core-Unterachse** zur Laufzeit der CEB und zur Runtime der
> Tier-Binary gemessen. Kurz und knapp: Die CEB kann alles messen, aber startet **einmal die
> Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core** und misst die
> Tier-Binary dann mit dem entsprechenden PMC. Das ist eine **reine Wiederverwendung durch
> Achsen-Permutation durch die CEB auf einer dafuer zustaendigen SYSTEM-Achse**."

Ergaenzend, aus demselben KERN-Feld:

> "die gleiche binary auf der SELBEN MASCHINE mit den selben Messachsen liefert identische Ergebnisse"

### 1.2 Was der KERN FESTLEGT

| # | Festlegung | Wortlaut-Anker |
|---|---|---|
| **V-1** | **EINE CEB**, die **beide** Messfuehler traegt | "kann beide Messfuehler tragen" |
| **V-2** | Die Trennung liegt in der **ABLAGE**, nicht in der Binary | "legt die Ergebnisse je PMC getrennt ab" |
| **V-3** | **Dieselbe** Tier-Binary wird **zweimal gefahren**, je gepinnt | "startet einmal ... auf einen E-Core und einmal ... auf einen P-Core" |
| **V-4** | Die Kern-Wahl ist eine **SYSTEM-Achse**: NUMA-Achse mit Core-Unterachse | "auf einer dafuer zustaendigen SYSTEM-Achse" |
| **V-5** | System-Achsen sind **zweistufig**; Stufe 1 = RT-Freigabe in der CEB. **Das Pinning IST die Laufzeit-Freigabe** | "zur Laufzeit der CEB und zur Runtime der Tier-Binary" |
| **V-6** | Der Vorgang ist **reine Wiederverwendung durch Achsen-Permutation** | "reine Wiederverwendung durch Achsen-Permutation durch die CEB" |
| **V-7** | Identitaets-Zusage: gleiche Binary + gleiche Maschine + gleiche **Messachsen** ⇒ identische Ergebnisse | KERN-Zitat oben |

### 1.3 Was der KERN AUSDRUECKLICH AUSSCHLIESST

| # | Ausschluss | Folge fuer diesen Plan |
|---|---|---|
| **X-1** | **Keine zweite CEB.** Die frueher gefallene Lead-Formulierung "eine CEB je PMU-Domaenen-Satz" ist damit widerlegt | Die CEB-Menge bleibt **1** (`super/docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:663`: "CEB-Binaries **1** (je Plattform x Mess-Aufgabe)") |
| **X-2** | **Keine zweite Tier-Binary.** Dieselbe Binary wird zweimal GESTARTET | Die Flotte bleibt bei **524.288**, verdoppelt sich NICHT |
| **X-3** | **Kein Neubau.** Das Fingerprint-Preimage bleibt unberuehrt | In Abschnitt 6 am Objekt bewiesen, nicht behauptet |

**Merksatz des Owners, der alles ordnet: die Hybrid-Trennung ist eine PERMUTATION, kein zweiter Bau.**

---

## 2. Der Ist-Zustand: was die CEB heute tut, wenn sie eine Tier-Binary misst

### 2.1 Die Aufrufkette, von oben nach unten

| # | Ort | Was geschieht |
|---|---|---|
| 1 | `ce/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:2099-2107` | **Der Perm-Walk des Planers.** Zweistufige Schleife `for (opt_id) for (simd_id)` -- die einzige System-Achsen-Permutation, die es heute gibt |
| 2 | ebd. `:2089` | `header.perm_count = opt_perms.size() * simd_perms.size();` -- die Kardinalitaets-Single-Source |
| 3 | ebd. `:1430`, `:1438`, `:1461` (Debug-Zweig) bzw. `:1470` (Release-Zweig) | Je `PlanPerm` **ein** Treiber-Aufruf: `"$DRIVER" experiment_config "$CI_PROJECT_DIR/Code/measure_out/<slug>/perm<idx>"` |
| 4 | `ce/libs/cache_engine/profile_facade/profile_run_entry.hpp:1092,1097,1101` | Der System-Zell-Walk: eigener Zell-Ordner + `build_version`-Suffix, dann `run_all_passes()` |
| 5 | `ce/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:1613` | `run_lazy_static_then_dynamic(...)` = der CEB-Host-Treiber |
| 6 | ebd. `:1618` | `std::vector<DynamicDim> const dyn_dims = tree.dynamic_filter();` -- der dynamische Sub-Filterbaum |
| 7 | ebd. `:2585-2592` | `collect_ordered(builds.size(), cfg.measure_parallelism, [] { return make_pmc_source(); }, ...)` -- **je Mess-Worker EINE PMC-Quelle** |
| 8 | ebd. `:2098` | `measure_one_binary(BuildResult const& b, measurement::IPmcSource* cell_pmc)` |
| 9 | ebd. `:2376` | `AnatomyModuleLoader::load(b.output, handle)` -- **`dlopen`, kein Prozess-Start** |
| 10 | ebd. `:2470-2475` | `if (ctrl != nullptr && !dyn_dims.empty()) loop.run(*ctrl, dyn_dims, measure_under_setting); else { RuntimeSetting s{}; measure_under_setting(s); }` |
| 11 | ebd. `:2423-2432` | `measure_under_setting` bildet `setting_id` und ruft `run_workload_perm(...)` bzw. `run_observable_perm(...)` |
| 12 | `ce/libs/cache_engine/harness/perm_runner.hpp:314-317` | Das PMC-Fenster: `pmc->begin(); run_workload_profile(...); r.pmc = pmc->end();` |
| 13 | `cache_engine_builder_iterator.hpp:2575` | `return oc; // handle: RAII entlaedt die DLL beim Verlassen der Zelle` |

### 2.2 Der zentrale Ist-Befund: die Tier-Binary ist heute KEIN Prozess

`cache_engine_builder_iterator.hpp:2373-2374`, verbatim:

> `// (2) LADEN: DLL -> IAnatomyBase* -> Sub-Interfaces via Dock-Vertrag. AnatomyModuleLoader::load ist thread-safe`
> `//     fuer verschiedene .so (dlopen glibc-serialisiert, kein statischer Loader-Zustand) -> Pool-unbedenklich.`

**Null mit Nenner und Gegenprobe:** in derselben Datei (2718 Zeilen) liefert
`/usr/bin/grep -n "std::system\|popen\|fork(\|execv\|posix_spawn\|CreateProcess"` **0** Treffer;
die Gegenprobe `AnatomyModuleLoader::load` liefert dort **3** Treffer (`:11`, `:2373`, `:2376`).
**Im CEB-Mess-Pfad gibt es keinen Prozess-Start.**

**Konsequenz fuer V-3:** Der Owner-Satz "startet ... die Tier-Binary gepinnt" trifft heute auf ein
`dlopen` plus In-Process-Treiben in einem Worker-Thread. Ein Pinning waere damit eine
**Thread**-Affinitaet (`sched_setaffinity(0, ...)`), keine Prozess-Affinitaet. Beide Lesarten von
"startet" sind baubar; welche gilt, ist Owner-Frage **F-1** (Abschnitt 9).

### 2.3 Wo die Kette heute ENDET -- die vier Naht-Stellen

**(a) Der Planer-Perm-Walk endet bei `opt x simd`.**
`experiment_plan_director.hpp:2101-2102` traegt genau zwei Schleifenebenen. Der Traeger `PlanPerm`
(`:161-163`) hat den Kopfkommentar:

> `/// EINE opt x simd Permutation (system_config => NIE binary_id, NIE N; nur BAU-/MESS-Matrix + build_version-Suffix).`

Die Legende `ce/libs/cache_engine/profile_facade/planner/plan_legend.hpp:102-105` heisst bereits
`[d,e,f]` -- **drei** Positionen --, traegt aber nur zwei Argumente:

```cpp
// -- [d,e,f] -- die System-Achsen-Permutation (opt x simd des Director-Walks; die HAUPT-System-Achsen). --
[[nodiscard]] inline std::string system_perm(std::string const& opt_id, std::string const& simd_id) {
    return axis_array({opt_id, simd_id});
}
```

**Die dritte Position ist frei.**

**(b) Der CEB-interne Setting-Loop endet bei den heutigen `DynamicDim`.**
`ce/libs/cache_engine/builder/experiment_tree/runtime_variable_loop.hpp:101-106` expandiert die
volle Kartesik; der Datei-Kopf `:4-9` sagt die Semantik verbatim:

> "die DYNAMISCHEN Knoten sind eine FOR-SCHLEIFE auf EINER bereits geladenen Tier-Binary -- sie
> probieren nacheinander die Test-Einstellungen ueber die Variablen-Schnittstelle
> (Algorithm_Resource_Control, KF-4) durch und erzeugen KEINE neue Binary."

**Das ist woertlich der Owner-Merksatz "Permutation, kein zweiter Bau" -- als bereits gebaute Mechanik.**

**(c) Die PMC-Quelle endet bei EINER Instanz je Worker, parameterlos erzeugt.**
`ce/libs/cache_engine/builder/pmc_source_factory.hpp:29-37`:

```cpp
[[nodiscard]] inline std::unique_ptr<measurement::IPmcSource> make_pmc_source() {
#if defined(COMDARE_ENABLE_PMC) && defined(_WIN32)
    return std::make_unique<WindowsPcmPmcSource>();
#elif defined(COMDARE_ENABLE_PMC) && defined(__linux__)
    return std::make_unique<LinuxPerfPmcSource>();
#else
    return std::make_unique<measurement::NullPmcSource>();
#endif
}
```

**Sie nimmt kein Argument** -- es gibt heute keinen Kanal, um eine PMU-Domaene oder einen Kern-Typ
anzufordern. Lebensdauer, `cache_engine_builder_iterator.hpp:2037-2039` verbatim:

> `// #45 (Sekt.16.2-M1/Sekt.61-MODI): der PMC-Source wird PRO Mess-Worker einmal erzeugt (make_pmc_source in collect_ordered's`
> `// Ctx-Factory) -- NICHT je Op/Binary und NICHT geteilt (ein realer LinuxPerfPmcSource ist nicht thread-safe teilbar).`
> `// Sequentiell (measure/release/default) => genau EIN Source fuer den ganzen Lauf (byte-identisch zum Ist).`

Und die Counter werden bereits **im Konstruktor** geoeffnet:
`ce/libs/cache_engine/builder/linux_perf_pmc_source.hpp:211-216` (drei `open()`-Aufrufe im Rumpf des
Konstruktors `:208`), der Open selbst `:110`:

```cpp
long const r = perf_event_open(&attr, /*pid*/ 0, /*cpu*/ -1, /*group_fd*/ -1, /*flags*/ 0);
```

`pid=0, cpu=-1` = Self-Monitoring des **aufrufenden Threads**, CPU-unabhaengig.
**Die Reihenfolge Pinnen-dann-Oeffnen ist damit heute nicht gewaehrleistet.**

**(d) Der Pin-Aktuator existiert -- aber nicht an der CEB.**
`ce/libs/cache_engine/builder/measurement/thread_pinning.hpp:52-64`:

```cpp
cpu_set_t previous{};
if (::sched_getaffinity(0, sizeof(previous), &previous) != 0) return;
cpu_set_t target{};
CPU_ZERO(&target);
CPU_SET(core, &target);
if (::sched_setaffinity(0, sizeof(target), &target) != 0) return;
previous_mask_ = previous;
active_        = true;
```

plus das Policy-Paar `NoPinPolicy` / `CorePinPolicy{unsigned core}` (`:96-104`).

**Null mit Nenner und Gegenprobe:** `/usr/bin/grep -ic "pin"` in `cache_engine_builder_iterator.hpp`
(2718 Zeilen) = **3** Treffer, alle unbeteiligt (`:148` "Kompositions-Pinnung", `:956` dito, `:1405`
"NAMENS-PIN"); Gegenprobe `pmc` in derselben Datei = **47** Treffer. Der einzige produktive Konsument
des Aktuators ist `ce/apps/f15_compare/main.cpp:225`:

```cpp
auto measurement_pin = pin_core.has_value() ? bld::CorePinPolicy{*pin_core}.pin() : bld::NoPinPolicy{}.pin();
```

-- und dort steht der Pin (`:225`) **vor** der Quelle (`:335` `make_pmc_source()`). **Das ist die
einzige vorhandene Praezedenz fuer die richtige Reihenfolge.**

### 2.4 Wo die Permutations-Ebene hinein muesste -- zwei Kandidaten-Naehte

| | **Naht A -- Planer-Perm (dritte Schleifenebene)** | **Naht B -- `DynamicDim` in der CEB** |
|---|---|---|
| Ort | `experiment_plan_director.hpp:2101-2102` + `:2089` + `PlanPerm` `:162` + `plan_legend.hpp:103` | `cache_engine_builder_iterator.hpp:1618` (`dyn_dims`) + `runtime_variable_loop.hpp:101-106` |
| Was entsteht | je Kern-Klasse **ein eigener Treiber-Aufruf** (`:1461` (Debug-Zweig) bzw. `:1470` (Release-Zweig)) mit **eigenem Ordner** `perm<idx>` (`:1438`) | je Kern-Klasse **ein weiteres RuntimeSetting** auf **derselben geladenen** DLL |
| Traegt "startet ... einmal ... und einmal" | woertlich (zwei Starts) | im Sinne von "faehrt zweimal an" (zwei Durchlaeufe, ein Prozess) |
| Traegt "durch die CEB" | nein -- der **Planer** permutiert | ja -- die **CEB** permutiert |
| Pinning-Mechanik | Exec-Praefix noetig (`taskset`/`numactl`); heute **nicht vorhanden** | `ScopedThreadPin` -- **vorhanden und getestet** |
| Ablage-Trennung | Ordner-Trennung faellt gratis ab (`measure_out/<slug>/perm<idx>`) | Spalten-Trennung ueber `setting` faellt gratis ab |
| Kosten | Emissions-Aenderung + Prozess-Mechanik | Loop-Anschluss + Aktuator-Kanal |

**Empfehlung: Naht B**, weil sie als einzige den KERN-Halbsatz "**durch die CEB**" erfuellt und weil
der Aktuator dort bereits liegt. Die Ordner-Trennung, die Naht A gratis mitbraechte, ist ueber
Abschnitt 5 auch in Naht B erreichbar. **Die Entscheidung gehoert dem Owner (F-1).**

**Null mit Nenner und Gegenprobe zur Prozess-Variante:** `/usr/bin/grep -rn "pin-core|pin_core|taskset|numactl"`
ueber `super/.gitlab-ci.yml` + `super/Code` = **0** Treffer; Gegenprobe `numa_node` dort =
`super/Code/test_data_xml/experiment_schema.xsd:410,536,541`. Der einzige `taskset`/`numactl`-Pfad
im ce ist `ce/libs/cache_engine/builder/experiment_tree/slurm_launcher.hpp`, und der ist als
**deprecated** gefuehrt (`ce/docs/architecture/05b_uml_klassenatlas_20260805.html:985`:
"KF-12: architektonische Laufzeit-Ausnahmen des privilegierten Pre-Exec-Blocks (deprecated)") und
emittiert nur Text (`ce/tests/unit/test_kf12_kf13_slurm_prepare.cpp:1-2`: "VORBEREITET, NICHT
AUSGEFUEHRT ... KEINE Submission").

---

## 3. Die NUMA-Achse mit Core-Unterachse

### 3.1 Was EXISTIERT

**(a) Die NUMA-Achse liegt genau dort, wo der KERN sie hinlegt -- als RT-Unter-Achse am
`target_isa`-Komplex.**

`ce/libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml:38`:

```xml
<sub_axis id="numa_node" parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>
```

Der Registry-Kopf `:5-7` legt die vom KERN geforderte Zweistufigkeit (V-5) fest:

> "Haupt-Achse=CT-statisch (stage=ct, in die CEB/Tier-Binary einkompiliert); Unter-Achse=dynamisch
> (stage=runtime, vom Planer permutiert)."

Die Haupt-Achse selbst, `:10`:

```xml
<axis id="target_isa" category="system_config" axis_kind="system_config" binary_id="never" stage="ct" baustein_count="2">
```

**`binary_id="never"` -- die Achse kann die Tier-Binary-Identitaet strukturell nicht anfassen.
Das ist X-3 auf Registry-Ebene.**

**(b) Der Achsen-Typ.** `ce/libs/cache_engine/include/cache_engine/measurement/target_isa_sub_axes.hpp:57-61`:

```cpp
/// numa_node -- Spiegel des Organ-Members alloc_hw.numa_node. Werte = die Node-Ids der Maschine.
struct NumaNodeSubAxis final : TargetIsaSubAxis<NumaNodeSubAxis> {
    [[nodiscard]] static constexpr std::string_view do_axis_label() noexcept { return "numa_node"; }
    [[nodiscard]] static constexpr std::string_view do_option_source() noexcept { return "machine_resolved"; }
};
```

mit compile-harten Wachen `:79-84`
(`static_assert(std::same_as<NumaNodeSubAxis::parent_axis, TargetIsaAxisTag>)`, `axis_depth_v == 1`).

**(c) Der XML-Kanal.** XSD `super/Code/test_data_xml/experiment_schema.xsd:541`
(`<xs:element name="numa_node" minOccurs="0">`, Werte als offener `xs:string`, begruendet `:536-540`);
Parser `ce/libs/common/serialization/xml_config_parser/xml_config_parser.cpp:129-132`:

```cpp
if (auto const* nn = ti->child("numa_node"))
    for (auto const* o : nn->children_named("option")) target_isa.numa_node.push_back(o->attr("value"));
if (auto const* pg = ti->child("page"))
    for (auto const* o : pg->children_named("option")) target_isa.page.push_back(o->attr("value"));
```

**(d) Die Laufzeit-Erhebung der Werte -- und die Owner-Regel "HW-Erkennung per Factory zur Laufzeit"
ist dort bereits erfuellt.** `ce/libs/cache_engine/include/cache_engine/measurement/hardware_probe_factory.hpp:34-38`:

> `// -- OD-10-RT: DIE ZWEITE ERHEBUNG AN DERSELBEN ZELLE --`
> `// Seit OD-10-RT haengt neben der RAM-Kette eine zweite Erhebung an dieser Factory: die numa/page-Probe`
> `// (numa_page_probe.hpp). Sie waehlt ihre Familie ueber DIESELBE Zell-Koordinate und bezieht ihre`
> `// Zugriffs-Wurzeln als Zell-Handles (numa_node_root/hugepage_root).`

Der Erhebungs-Vorgang, `:381-385`:

```cpp
template <class Device = CebHardwareProbeDevice>
    requires HardwareProbeDeviceConcept<Device>
[[nodiscard]] inline NumaPageTopology probe_numa_page_topology(NumaPageProbeContext const& ctx) {
    return NumaPageProbe<typename Device::os_axis>::collect(ctx);
}
```

und die Naht, an der sie haengt, `:388-395`:

> `// 4. DIE CEB-FREIGABE-NAHT: EINE Erhebung je Prozess`
> `// WO DAS HIER SITZT: neben live_hostname()/identify_machine() -- an der Naht, an der die CEB EINMAL`
> `// beim Start klaert, auf welcher Maschine sie laeuft (simd_build_gate.hpp, O-4). Die Erhebung liest`
> `// Dateien; sie darf deshalb NIE in einer Statik-Initialisierung stehen ... Lazy beim ersten Aufruf,`
> `// danach memoisiert.`

**Das ist exakt die Owner-Regel: Factory zur Laufzeit, nie statisch.** Die Quelle:
`ce/libs/cache_engine/include/cache_engine/measurement/numa_page_probe.hpp:192,197`
(`/sys/devices/system/node` + Blattname `online`; `:194-196` begruendet `online` statt `possible`).

### 3.2 Was FEHLT

**(a) Eine Core-Unterachse existiert NICHT.**
Nenner: die Registry hat **11** `sub_axis`-IDs (`atomic128, build, compiler, kernel, numa_node,
opt_level, os_version, page, scheduling, simd, target_isa_complex`) -- **keine** enthaelt "core".
Gegenprobe: dieselbe Grep-Form findet `axis id="target_isa"` sofort.
`target_isa_sub_axes.hpp:72-73` fuehrt `kTargetIsaSubAxisLabels` mit `size()==2`.

**(b) Es gibt keinen Erheber fuer Kern-Typen.**
`numa_page_probe.hpp:181-184`:

```cpp
struct NumaPageTopology {
    NumaNodeSetResult       numa_nodes;
    PageCapabilitySetResult page_sizes;
};
```

**Node-IDs und Seitengroessen -- keine CPU-Liste, keine Kern-Klasse.**
CPUID-Leaf 0x1A wird nicht gelesen: Nenner `ce/libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp`
= 196 Zeilen, `/usr/bin/grep -ic "0x1a"` = **0**; Gegenprobe `cpuid(` in derselben Datei = **8** Treffer.
Ausdruecklich abgeschaltet, `ce/libs/cache_engine/include/cache_engine/platform_probe/cpuid_platform_probe.hpp:38-39`:

> `// AP-13: Topologie/Pinning bleibt bewusst ungesetzt (has_hybrid_cores,`
> `// cpu_core_atom_perf_separation, preferred_pinning_policy).`

**(c) Das P/E-Vokabular existiert dreifach -- und ist ueberall auf dem Nullwert festgenagelt.**

| Vokabel | Ort | Zustand |
|---|---|---|
| `CoreClass { Generic, HighIpc /* P-Cores / V-Cache-CCDs */, LowIpc /* E-Cores */, Specialized }` | `ce/libs/cache_engine/include/cache_engine/platform/core_layout.hpp:14-19` | **0 Implementierungen** (nur Interface + Test) |
| `HeteroCoreDispatch { None, HybridAware, PCoresOnly, ECoresOnly }` | `ce/libs/cache_engine/include/cache_engine/concepts/scheduling_strategy.hpp:39` | einzige Auspraegung `None` (`measurement/scheduling_system_axis.hpp:76-78`), Registry-Ordinal `0` (`system_axis_registry.xml:34`) |
| `bool hybrid_core_aware` | `ce/libs/cache_engine/include/cache_engine/measurement/i_measurement_source.hpp:55` | **nie gesetzt** -- repo-weit 1 produktiver Treffer = die Deklaration |

**(d) Der Konsument der Probe fehlt -- und das ist als Paket benannt, nicht vergessen.**
`numa_page_probe.hpp:66-69`, verbatim:

> `// DER PRODUKTIVE KONSUMENT KOMMT GETRENNT UND PLANMAESSIG: die erhobenen Werte-Mengen in die`
> `// Planer-/CEB-Aufloesung und in die Mess-Ausgabe zu tragen ist das Folge-Paket OD-10-RT-K -- exakt so,`
> `// wie OS-U3 seine Werte fuer OS-U4 vorbereitet hat, ohne sie selbst zu verdrahten. Das ist eine`
> `// deklarierte Paket-Grenze, kein vergessener Anschluss.`

**Die Luecke sitzt an EINER Naht: zwischen erhobener Werte-Menge und Perm-Bildung.**

### 3.3 `target_isa.numa_node` ist heute geparst-aber-ungelesen -- und **das ist der Andockpunkt**

**Der Befund, am Objekt und mit Nenner.** `/usr/bin/grep -rn "\.numa_node\b|target_isa\.numa"` ueber
den ce (ohne `axes/alloc`, ohne `ext/`, ohne `/build/`) liefert **genau 2 produktive Treffer**, beide
Schreibstellen: `xml_config_parser.cpp:130` und `:132`. **Kein Leser.** Der Header sagt es selbst,
`ce/libs/common/serialization/xml_config_parser/xml_config_parser.hpp:234-235`:

> `// KEIN KONSUMENT in diesem Paket: der Parser fuellt sie, niemand liest sie. Damit ist der Kanal erreichbar`
> `// (BLOCKER-4 aufgehoben), ohne dass sich Verhalten, Bytes oder golden aendern.`

Und der Parser-Kommentar direkt darueber, `xml_config_parser.cpp:127-128`:

> `// das Verhalten ist byte-identisch zum Ist. In diesem Paket gibt es KEINEN Konsumenten der Felder;`
> `// die Gueltigkeits-Pruefung gegen das Angebot folgt mit dem Resolver-Schritt.`

**Die Owner-Frage O-E beantwortet sich damit von selbst -- und ich sage das ausdruecklich.**

Die Frage stand so (`super/docs/plaene/20260806-PLAN-testoffensive-und-gruene-pipeline.md:442`):

> `| **O-E** | target_isa.numa_node / .page: vor der Abgabe anschliessen, oder als *declared-inert* in der Arbeit ausweisen? | Scope der Diplomarbeit | Ausweisen. Der Code-Anschluss ist nach der Abgabe billig; eine unbenannte Schein-Achse ist es nie |`

**Der Owner-KERN hat die Frage ueberholt.** Denn:

1. Der KERN legt die Kern-Wahl **auf genau diese Achse** (V-4: "NUMA Achse und deren Core-Unterachse",
   "auf einer dafuer zustaendigen SYSTEM-Achse").
2. Der KERN verlangt **Laufzeit-Permutation durch die CEB** (V-5) -- also genau das, was
   `stage="runtime"` an `system_axis_registry.xml:38` schon deklariert und was heute niemand ausfuehrt.
3. Damit ist der Anschluss von `target_isa.numa_node` **nicht mehr eine Aufraeum-Frage nach der Abgabe,
   sondern der tragende Traeger des KERNs.** Ein "declared-inert ausweisen" waere die Ausweisung
   ausgerechnet jener Achse als wirkungslos, auf der der KERN die Hybrid-Messung fahren laesst.

**Antwort auf O-E, aus dem KERN abgeleitet: anschliessen. Die Alternative "ausweisen" ist mit dem
KERN nicht mehr vertraeglich.** Der Umfang des Anschlusses ist klein und in Abschnitt 4 benannt.

**Zwei Praezisierungen, die dazugehoeren -- sonst trifft der Anschluss die falsche Achse:**

- **Die Namensfalle ist real.** `super/docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md:1155-1158`
  hat O-E am selben Tag als "falsch gefasst" markiert, weil es eine **zweite, voll verdrahtete**
  Unterachse `alloc_hw.numa_node` gibt. Am Objekt: das **einzige** Profil-XML im Repo, das
  `<numa_node>` deklariert, ist `ce/libs/cache_engine/algorithm_profiles/thesis_profiles/fb_numa_page_study.profile.xml:50-52`
  -- und es haengt unter `<axis ref="alloc_hw">` (`:49`), also an der **Organ**-Achse.
  Nenner: 91 Profil-XMLs unter `algorithm_profiles/`; **kein einziges** deklariert `<target_isa><numa_node>`.
  **Gemeint ist die System-Achse `target_isa.numa_node`, nicht die Organ-Achse `alloc_hw.numa_node`.**
- **Der TYP ist nicht tot, nur das POD-Feld.** `NumaNodeSubAxis` hat zwei Konsumenten
  (`ce/tools/system_axis_registry_gen/main.cpp:375`, `numa_page_probe.hpp`). Die Aussage
  "geparst-aber-ungelesen" gilt fuer das **Parser-POD-Feld** `TargetIsaAxisSel::numa_node`
  (`xml_config_parser.hpp:239`), nicht fuer das Achsen-Angebot.

---

## 4. Die Mechanik, Schritt fuer Schritt

**Voraussetzung:** Naht B aus 2.4 (Empfehlung; bei Naht A verschiebt sich Schritt 4 auf die
Emissionsstelle `experiment_plan_director.hpp:1461,:1470`). Alle Schritte sind in der Sprache des
Codes beschrieben; **nichts davon ist gebaut**, dieser Plan baut nichts.

### Schritt 0 -- Die CEB klaert beim Start, auf welcher Maschine sie laeuft

Bereits vorhanden: die CEB-Freigabe-Naht `hardware_probe_factory.hpp:388-395` neben
`live_hostname()`/`identify_machine()` (`ce/libs/cache_engine/include/cache_engine/measurement/simd_build_gate.hpp:328,335`).
**Lazy beim ersten Aufruf, danach memoisiert; nie in einer Statik-Initialisierung, nie im gemessenen Pfad.**

### Schritt 1 -- **Wer erfaehrt, welche Kern-Typen die Maschine hat**: eine zweite Erhebung an derselben Zelle

Die Owner-Regel lautet: **HW-Erkennung per Factory zur LAUFZEIT, nie statisch.** Der Bauplatz dafuer
existiert und ist im Code sogar begruendet -- `hardware_probe_factory.hpp:36-38`:

> `// WARUM HIER UND NICHT DANEBEN: die Aussage "auf dieser Plattform liegt der Zugang so" gehoert genau`
> `// einmal in den Bestand. Ein zweiter, paralleler Zell-Raum haette dieselbe Plattform-Zuordnung ein`
> `// zweites Mal behauptet -- und zwei Behauptungen ueber dieselbe Sache driften.`

**Was neu entsteht:** eine dritte Erhebung an derselben ISA-x-OS-Zelle, nach dem Muster der
numa/page-Probe -- eine **Kern-Topologie-Probe**, die je logischem Prozessor eine `CoreClass`
(`core_layout.hpp:14-19`) liefert. Die Detektions-Kette ist im Dossier vom 16.07. bereits festgelegt
(`super/docs/plaene/20260716-e17-e18-deep-research-DOSSIER.md:13`, **H-3**):

> "**H-3:** Detektions-Kette CPUID->sysfs->hwloc (erster Treffer)."

Mit der SOTA-Begruendung `:9` verbatim:

> "CPUID 0x1A ist inhaerent LAUFZEIT (EAX[31:24]: 0x40=P/0x20=E des Kerns, auf dem es laeuft -> volle
> Karte nur per Pinnen+CPUID je logischem Prozessor -> statische Compile-Time-Einrichtung sinnlos).
> Ab Meteor Lake 0x1A unzureichend -> Linux sysfs `cpu_core`/`cpu_atom` + `cpu_capacity` autoritativ"

**Der Rueckgabewert ist eine Werte-Menge fuer die Achse** -- genau wie `NumaNodeSetResult` die
Node-IDs liefert. Auf einer nicht-hybriden Maschine ist die Menge einelementig; das ist die
`honest-0`-Form, die das Dossier `:11` ausdruecklich vorsieht ("honest-0 auf Nicht-Hybrid").

### Schritt 2 -- **Wer waehlt das Pinning**: die CEB, aus der Achsen-Werte-Menge

Die erhobene Menge wird zu einer `DynamicDim` (`cache_engine_builder_iterator.hpp:1618`
`tree.dynamic_filter()`). Ab da faehrt die **vorhandene** Mechanik:
`runtime_variable_loop.hpp:101-106` expandiert sie kartesisch mit den uebrigen Dimensionen und
serialisiert je Wert ein Label-Segment `d.axis + "." + d.variable + "=" + val`.

**Damit ist V-6 mechanisch erfuellt:** der Loop-Kopf `:4-9` sagt selbst, dass er "KEINE neue Binary"
erzeugt. Zwei Kern-Werte = zwei Durchlaeufe derselben geladenen `.so`.

### Schritt 3 -- **Die harte Luecke**: das Label ist heute beschriftet, aber wirkungslos

`runtime_variable_loop.hpp:52-64` kennt genau fuenf POD-Felder und ignoriert alles andere **still**:

```cpp
static void set_field(anatomy::ComdareResourceControlV1& pod, std::string const& var, std::uint64_t v) noexcept {
    if (var == "thread_count") pod.thread_count = v;
    else if (var == "prefetch_distance") ...
    else if (var == "pool_budget_bytes") ...
    else if (var == "batch_size") ...
    else if (var == "inline_threshold_bytes") ...
    // sonst: architektonische Laufzeit-Ausnahme (hw_prefetcher/MSR ...) -> kein POD-Feld (KF-12-Launcher).
}
```

**Praezedenz, die man kennen muss:** `hw_prefetcher` steht heute in jedem `setting`-Label und wird
**nie angewandt** -- Datei-Kopf `:11-13`. Wer die Kern-Klasse nur als `DynamicDim` einhaengt und sonst
nichts tut, erzeugt genau dieselbe Attrappe: doppelte Zeilen mit unterschiedlichem Label und
identischer Wirkung.

**Was gebraucht wird:** neben dem POD-Kanal ein **Aktuator-Kanal** im Loop -- eine Stelle, an der eine
Dimension nicht in `ComdareResourceControlV1` geschrieben, sondern an einen Host-seitigen Aktuator
gereicht wird. Der Aktuator selbst ist fertig, getestet und ungenutzt: `ScopedThreadPin` /
`CorePinPolicy` (`thread_pinning.hpp:18,52-64,96-104`; Test `ce/tests/unit/test_ap13_thread_pinning.cpp`,
CMake `ce/tests/unit/CMakeLists.txt:1295`).

### Schritt 4 -- **Wo gepinnt wird**: `sched_setaffinity`, im Mess-Thread, vor `pmc->begin()`

Das PMC-Fenster liegt **innerhalb** des Tier-Laufs, im selben Thread
(`ce/libs/cache_engine/harness/perm_runner.hpp:314-317`):

```cpp
if (pmc != nullptr) pmc->begin();
wd::WorkloadRunResult const res = wd::run_workload_profile(tier, rb_exact ? rollback : nullptr, ops, cfg.name, scan);
if (pmc != nullptr) r.pmc = pmc->end();
```

mit dem Vertrag `:312-313`: "PMC klammert NUR die gemessene Run-Phase (run_workload_profile) -- die
LOAD-Phase oben ist ungemessen".

**Der Pin muss also die ganze Setting-Ausfuehrung halten, mindestens aber vom Setup bis nach
`pmc->end()`.** Weil `ScopedThreadPin` RAII ist und die alte Maske in `previous_mask_` sichert
(`thread_pinning.hpp:49-63`), ist die natuerliche Form ein Objekt mit der Lebensdauer von
`measure_under_setting` (`cache_engine_builder_iterator.hpp:2423-2468`).

**Eine Ehrlichkeits-Auflage, die aus dem Code folgt:** `ScopedThreadPin::pin` hat **drei stille
Rueckkehr-Pfade** ohne Fehlermeldung (`thread_pinning.hpp:53,56,62` -- `core >= CPU_SETSIZE`,
`sched_getaffinity`-Fehler, `sched_setaffinity`-Fehler) und setzt dann `active_` nicht. **Ein
gewuenschtes Pinning kann also fehlschlagen, ohne dass irgendjemand es erfaehrt.** Genau deshalb
verlangt Abschnitt 5 neben der Konfigurations-Spalte eine **beobachtete** Spalte.

### Schritt 5 -- **Wer waehlt den passenden PMC**

Heute: niemand -- `make_pmc_source()` ist parameterlos (`pmc_source_factory.hpp:29`) und oeffnet die
fds im Konstruktor (`linux_perf_pmc_source.hpp:211-216`), also **bevor** irgendein Pin wirken koennte.

Das Ziel benennt das Dossier `20260716-e17-e18-deep-research-DOSSIER.md:9` verbatim:

> "perf misst pro Kern-Typ (PMU-Type-ID in `attr.config[63:32]`)"

und `:13`, **H-5**:

> "**H-5:** Hybrid-PMU-Wahl (`cpu_core`/`cpu_atom`) hinter `hybrid_core_aware` als Folge-Increment."

**Zwei baubare Formen, die Entscheidung haengt an einer Messung, die noch aussteht (F-2 in Abschnitt 9):**

- **Form (i) -- ein Oeffnen, zwei Pins.** Wenn `perf_event_open(pid=0, cpu=-1)` dem Thread folgt und
  der Kernel auf Hybrid-PMUs die Domaene nicht beim Oeffnen festnagelt, genuegt die Reihenfolge
  Pin -> Oeffnen -> Messen, und die vorhandene Quelle bleibt unveraendert.
- **Form (ii) -- zwei Oeffnungen.** Andernfalls braucht `make_pmc_source()` einen Parameter
  (Kern-Typ bzw. PMU-Type) und die Quelle muss je Perm neu erzeugt werden. Der Ctx-Traeger der
  `collect_ordered`-Naht (`cache_engine_builder_iterator.hpp:2586-2587`) waere dann von
  `std::unique_ptr<IPmcSource>` auf einen Traeger umzustellen, der die Quelle je Zweig neu bezieht.

**In beiden Formen bleibt es EINE CEB (V-1)** -- die Quelle ist Treiber-Code, ihre Aenderung ist der
Klasse **CEB-ONLY** (Abschnitt 7). Das vendor-neutrale Cap-Feld fuer die Ansage steht bereits da und
ist tot: `i_measurement_source.hpp:55` `bool hybrid_core_aware = false; ///< P/E-Core separate Event-Codes`.

### Schritt 6 -- **Wie die Kern-Klasse in die Ergebniszeile landet**

Der Schluessel je Zeile, `cache_engine_builder_iterator.hpp:2426`:

```cpp
std::string const setting_id = s.setting_label.empty() ? binary_id : (binary_id + "#" + s.setting_label);
```

Der CSV-Kopf beginnt `:422`:

```cpp
std::string h = "binary_id;setting;repetition;n_ops;total_ns;ns_per_op;";
```

**Ein neues `DynamicDim`-Segment erscheint automatisch in der Spalte `setting`** -- genau wie
`workload.workload_id` und `repetition.repetition_index` es heute tun. **Kein Schema-Bruch, keine
neue Spalte, kein Umbau am Kopf.** Das ist die Konfigurations-Haelfte. Die beobachtete Haelfte
braucht mehr; siehe Abschnitt 5.

---

## 5. Die getrennte Ablage

### 5.1 Was heute da ist

| Traeger | Ort | Zustand |
|---|---|---|
| Zeilen-Schluessel | `cache_engine_builder_iterator.hpp:2426` | `binary_id#<setting_label>` -- **traegt jedes Dyn-Segment automatisch** |
| CSV-Kopf | ebd. `:422` (Beginn), `:504` (`pmc_branch_misses`) | 7+1 PMC-Spalten, **kein Domaenen-Diskriminator** |
| Globale Ablage | `profile_run_entry.hpp:1106-1120` | eine `out_csv` |
| Je-Binary-Ablage | `cache_engine_builder_iterator.hpp:2483-2494` | `bin_dir/result.csv` + `result.csv.stamp` |
| Perm-Ablage (Planer) | `experiment_plan_director.hpp:1438` | `measure_out/<slug>/perm<idx>` -- **bereits perm-indiziert** |
| Zell-Ordner | `profile_facade/system_version_suffix.hpp:147-161` | Segmente **nur** `cxx`, `opt`, `simd`, `build_type` |
| Transport | `perm_runner.hpp:133`, `cache_engine_builder_iterator.hpp:365` | je **genau ein** `PmcCounters`-Feld |

**Null mit Nenner und Gegenprobe:** im gesamten Header-Baublock `lazy_csv_header()`
(`cache_engine_builder_iterator.hpp:421-528`, 107 Zeilen) gibt es **keinen** Spaltennamen mit
`core`/`cpu`/`numa`/`pin`. Gegenprobe im selben Block: `platform` -> Treffer `:474`.

### 5.2 Der Stempel: gesperrt, und zwar compile-hart

`ce/libs/cache_engine/include/cache_engine/abi/system_cell_values.hpp:163-167`:

```cpp
///   numa_node/page/scheduling -- die RT-Unter-Achsen am target_isa-Komplex (OD-10-RT bzw. A3-Umzug).
///       Sie sind Instanz-Eigenschaften der Maschine, nicht Familien-Eigenschaften des Baus.
inline constexpr std::array<std::string_view, 7> kSystemCellValueForbiddenKeys = {
    "os_version", "kernel", "build", "os_family", "numa_node", "page", "scheduling"};
```

durchgesetzt `:193-196`:

```cpp
static_assert(detail::system_cell_value_keys_avoid_traps(),
              "W10-C1/A-15: ein Zellwert-Schluessel steht im RT-Unter-Achsen-Verbots-Katalog. "
              "RT-Unter-Achsen stehen NIE im Binary-Stempel -- die Instanz-Zuordnung einer Messung "
              "laeuft ueber Mess-Spalten/Dateinamen (OS-U4).");
```

**Der Code schreibt die vom Owner gewaehlte Form nicht nur zu, er erzwingt sie.** Ein Stempel-Anteil
fuer die Kern-Klasse ist nicht "unerwuenscht", sondern nicht uebersetzbar.

### 5.3 Der Ordner: was geht und was bricht

- **In Naht A (Planer-Perm)** faellt die Ordner-Trennung gratis ab: `measure_out/<slug>/perm<idx>`
  (`experiment_plan_director.hpp:1438`) plus je eigene Log-Datei `perm<idx>_mess.log` (`:1466`).
- **Ein zusaetzliches Segment im System-ZELL-Ordner ist dagegen gesperrt.**
  `system_version_suffix.hpp:164-173` koppelt jedes Pfad-Segment compile-time an ein **Suffix**-Segment
  (= Bau-Identitaet). Eine RT-Achse hat kein Suffix-Gegenstueck; die Wache braeche. **Das ist die
  Ordner-Grenze, und sie ist dieselbe Aussage wie 5.2: RT gehoert nicht in die Bau-Identitaet.**

### 5.4 Die kleinste Form, die die Trennung EHRLICH abbildet

**Die kleinste Form ueberhaupt ist Null Aenderung am Schema:** ein `DynamicDim` erscheint in der
Spalte `setting`. Das erfuellt V-2 buchstaeblich -- die Ergebnisse liegen je PMC in getrennten Zeilen
mit unterscheidbarem Schluessel.

**Sie ist aber nicht ehrlich, und der Grund steht im Code.** Die Spalte `setting` traegt die
**gewuenschte** Belegung. `ScopedThreadPin::pin` kann still scheitern (Schritt 4 oben,
`thread_pinning.hpp:53,56,62`). Eine Zeile mit `numa.core_type=e`, die faktisch auf einem P-Core lief,
waere eine Falschaussage ohne Signal.

**Die kleinste EHRLICHE Form sind zwei Angaben -- und das Projekt hat sie beide schon benannt:**

`super/docs/plaene/20260716-e17-e18-deep-research-DOSSIER.md:11`, verbatim:

> "CSV-Spalten (dynamisch): `pe_policy` (config) + `ran_on_core_type` (beobachtet 0x40/0x20)."

und `:13`, **H-4**: "CSV = `pe_policy` + `ran_on_core_type` (beide)."

Der SSOT bestaetigt denselben Namen -- `super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1577`:

> "**H-1 = wie empfohlen:** Hardware traegt das FAKTUM (Core-Typ-Karte + `ran_on_core_type`), die
> aktive Pinning-POLICY als Scheduling-Unter-Achse"

und die Serialisierungs-Doktrin `:1538`:

> "Statische compile-time-Achsen ... UND Systemachsen NICHT als CSV-Spalten ... **NUR dynamische
> Unter-Achsen** (Workload, RC-Settings, **P/E-Core**, NUMA, Multithreading) bleiben Spalten."

**Ergebnis, konkret:**

| Angabe | Traeger | Aenderung am Schema |
|---|---|---|
| **Konfiguration** (welche Kern-Klasse war gewollt) | Spalte `setting`, Segment `numa.core_type=<p\|e>` | **keine** -- faellt aus dem Dyn-Loop ab |
| **Beobachtung** (auf welcher Kern-Klasse lief es wirklich) | **eine neue Spalte** `ran_on_core_type` | eine Zeile in `lazy_csv_header()` (`:421-528`) + ein Feld an `LazyMeasuredRow` (`:365`-Umgebung) |
| **Stempel** | -- | **keine, gesperrt** (5.2) |
| **Ordner** | in Naht A gratis `perm<idx>`; im Zell-Ordner **gesperrt** (5.3) | **keine** |

`ran_on_core_type` existiert heute **nicht** im Code (Null mit Nenner: Header-Block `:421-528`, kein
`core`-Spaltenname; Gegenprobe `platform` `:474`). **Eine Spalte ist die gesamte Schema-Kosten.**

**Kein zweites `PmcCounters`-Feld noetig.** `PermResult` (`perm_runner.hpp:133`) und `LazyMeasuredRow`
(`cache_engine_builder_iterator.hpp:365`) tragen je genau ein `PmcCounters`. Das reicht **genau dann**,
wenn die Trennung -- wie der KERN sagt (V-3) -- ueber **zwei Laeufe derselben Binary** geht, also ueber
**zwei Zeilen**, statt ueber zwei gleichzeitige Werte in einer Zeile. **Der KERN waehlt die billigere
und doktrin-konforme Form.**

---

## 6. Die Identitaets-Frage

### 6.1 Traegt der KERN "gleiche Binary + gleiche Maschine + gleiche Messachsen ⇒ identische Ergebnisse"?

**Ja, ohne Aenderung -- und das ist beweisbar, nicht nur plausibel.**

Die Kern-Klasse ist per V-4 eine **System-Achsen-Auspraegung** (Unter-Achse am `target_isa`-Komplex).
Damit ist sie Teil der "Messachsen" im Sinne der Zusage V-7. Zwei Laeufe, die sich **nur** in der
Kern-Klasse unterscheiden, unterscheiden sich also in einer **Messachse** -- sie sind nicht "dieselben
Messachsen", und abweichende Ergebnisse sind kein Bruch der Zusage, sondern ihr Inhalt.

Die Gegenprobe: zwei Laeufe mit **identischer** Kern-Klasse auf derselben Maschine mit derselben
Binary haben identische Achsen-Belegung -- die Zusage greift unveraendert.

**Der Code stuetzt genau diese Einordnung.** `system_cell_values.hpp:164-165`:

> `///   numa_node/page/scheduling -- die RT-Unter-Achsen am target_isa-Komplex (OD-10-RT bzw. A3-Umzug).`
> `///       Sie sind Instanz-Eigenschaften der Maschine, nicht Familien-Eigenschaften des Baus.`

**"Instanz-Eigenschaft der Maschine" ist exakt die Kategorie, in die eine Kern-Klasse gehoert.**
Die Zusage V-7 spricht ohnehin von "der SELBEN MASCHINE" -- die Instanz-Achse praezisiert *welcher
Teil* der Maschine, sie widerspricht ihr nicht.

### 6.2 Beruehrt die Aenderung das Fingerprint-Preimage? **NEIN -- Glied fuer Glied belegt.**

Das Preimage hat **acht** Glieder. `ce/libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp:462-471`:

```cpp
[[nodiscard]] constexpr std::array<std::string_view, kAnatomyFingerprintGliedCount>
anatomy_fingerprint_glieder(std::string_view organ, std::string_view system, std::string_view measurement,
                            ToolchainGlied toolchain = ToolchainGlied{kToolchainStampGlied},
                            BvsetGlied     bvset     = BvsetGlied{kBuildVariantSetSignatureGlied},
                            OverlayHash    overlay   = OverlayHash{kOverlaySourceHash}) {
    ...
    return {kAnatomyFingerprintFormat, organ,        system,        measurement, kSubAxisValuesetSegment,
            toolchain.wert(),          bvset.wert(), overlay.wert()};
}
```

| # | Glied | Beruehrt? | Beleg |
|---|---|---|---|
| [0] | `kAnatomyFingerprintFormat` | **nein** | Format-Konstante |
| [1] | `organ` | **nein** | Organ-Stempelzeile, 17 Organ-Haupt-Achsen (`anatomy_module_abi_v1_decl.hpp:212`) |
| [2] | `system` | **nein** | traegt die drei System-**Haupt**-Achsen + Meta-Meta-Anhang (`anatomy_module_abi_v1_decl.hpp:214-218`), vervollstaendigt um die System-**Zellwerte**; `numa_node` steht dort im **Verbots-Katalog** (`system_cell_values.hpp:166-167`, `static_assert` `:193-196`) |
| [3] | `measurement` | **nein** | Mess-Stempelzeile `{wallclock,macro,micro}` (`anatomy_module_abi_v1_decl.hpp:221`) |
| [4] | `kSubAxisValuesetSegment` | **nein** | rendert ausschliesslich **drei ORGAN-Unter-Achsen**: `"sub=cacheline@v<N>,node_width@v<N>,alloc_hw@v<N>"` (`abi/subaxis_valueset_segment.hpp:60-65`) -- **keine System-Unter-Achse** |
| [5] | `toolchain` | **nein** | Toolchain-Identitaet (`profile_facade/toolchain_stamp_naht.hpp:3`) |
| [6] | `bvset` | **nein** | Build-Varianten-Set-Signatur |
| [7] | `overlay` | **nein** | Overlay-Quell-Hash |

**Glied [4] ist die Stelle, an der man sich haette irren koennen** -- es heisst "Sub-Achsen-Werteset".
Am Objekt rendert es aber nur die drei Organ-Unter-Achsen `cacheline`, `node_width`, `alloc_hw`
(`subaxis_valueset_segment.hpp:24-26` inkludiert genau deren drei Config-Header). **Eine neue
System-Unter-Achse geht dort nicht ein.**

Dazu die Berechnungs-Stelle: der Fingerprint entsteht **consteval in der Makro-Expansion** der
Tier-Binary (`abi/anatomy_module_abi_v1.hpp:130-133`, `:159-160`), nicht im emittierten Quelltext.
Eine Achse, die zur **CEB-Laufzeit** permutiert wird, kann dort strukturell nicht ankommen.

**Und die Registry sagt dasselbe eine Ebene hoeher:** `system_axis_registry.xml:10`
`binary_id="never"` fuer `target_isa`; `PlanPerm`-Kopf `experiment_plan_director.hpp:161`:
"system_config => NIE binary_id, NIE N".

**Fazit: Fingerprint-Preimage unberuehrt, `binary_id` unberuehrt, Stempel unberuehrt, golden unberuehrt.
X-3 des Owner-KERNs ist am Objekt belegt.**

---

## 7. Kosten und Bau-Reihenfolge

### 7.1 Die drei Neubau-Klassen und wo die Aenderung faellt

Die Klassifikation stammt aus `super/docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:670-674`:

| Klasse | Was sie beruehrt | CEB | Tier-Binaries | Kosten |
|---|---|---|---|---|
| **CEB-ONLY** | Treiber-Compile-Graph (`comdare-messung-driver`) | 1 | **0** | **~77 s** `[BERICHT]` + Pipeline |
| **TIER** | die Define-Menge des `g++`-Subprozesses fuer `perm_<id>.cpp` | 1 | **524.288** | ~34,4 h `[BERICHT]` |
| **FINGERPRINT** | das Preimage von `anatomy_fingerprint_hex` bzw. `dll_is_current` | 1 | die bereits GEBAUTEN | heute 0 h (Bestand = 0) |

Die ~77 s sind dort belegt als `[BERICHT]` (`:665`): "`/tmp`-Bau der Voranalyse: 76,7 s ohne / 77,0 s
mit Flag, 13 CXX-Compiles davon 12 neu, 32 Kerne (P-PMC-1 Sekt.5.1)".

**Einordnung jedes Bausteins dieses Plans:**

| Baustein | Ort | Klasse | Begruendung |
|---|---|---|---|
| Kern-Topologie-Probe (Schritt 1) | `measurement/hardware_probe_factory.hpp` + neues Probe-Blatt | **CEB-ONLY** | Header wird nur vom Treiber gezogen; `hardware_probe_factory.hpp` ist Mess-/Treiber-Code |
| Achsen-Typ `CoreClassSubAxis` + Registry-Zeile | `measurement/target_isa_sub_axes.hpp`, `system_axis_registry.xml` | **CEB-ONLY** | Achse ist `stage="runtime"`, `binary_id="never"` (`:10`) |
| Aktuator-Kanal im Dyn-Loop | `builder/experiment_tree/runtime_variable_loop.hpp` | **CEB-ONLY** | Builder-Seite, "das WIE des Messens" (Datei-Kopf `:15`) |
| Pin-Aufruf in `measure_under_setting` | `builder/experiment_tree/cache_engine_builder_iterator.hpp:2423-2468` | **CEB-ONLY** | dito |
| PMC-Quelle mit Domaenen-Parameter | `builder/pmc_source_factory.hpp`, `builder/linux_perf_pmc_source.hpp` | **CEB-ONLY** | ausdrueckliche Feststellung des Mess-Plans `:700-701`: "`linux_perf_pmc_source.hpp` ist Treiber-Code" |
| Spalte `ran_on_core_type` | `cache_engine_builder_iterator.hpp:421-528` | **CEB-ONLY** | CSV-Kopf ist Treiber-Code |
| XSD/Parser-Anschluss `target_isa.numa_node` | `experiment_schema.xsd`, `xml_config_parser.*` | **CEB-ONLY** | reine Parser-/Resolver-Seite |

**Kein einziger Baustein faellt in die Klasse TIER.** Der Grund ist strukturell und in Abschnitt 6
bewiesen: nichts davon geht in `perm_mess_defines()`/`perm_compile_flags()` oder ins Preimage.

### 7.2 Bleibt die Flotte unberuehrt? **Ja -- Beleg, kein Widerspruch**

1. **Registry:** `system_axis_registry.xml:10` `binary_id="never"` fuer `target_isa`.
2. **Planer:** `experiment_plan_director.hpp:161` "system_config => NIE binary_id, NIE N".
3. **Preimage:** Abschnitt 6.2, alle acht Glieder unberuehrt.
4. **Stempel:** `system_cell_values.hpp:166-167` + `static_assert :193-196` -- `numa_node` explizit verboten.
5. **Loop:** `runtime_variable_loop.hpp:4-9` "erzeugen KEINE neue Binary".

**Die Flotte bleibt bei 524.288** (`profile_facade/source_catalog.hpp:169`
`static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)`, mal 4 System-Perms).
**Bau-Zeit der Aenderung: ~77 s, nicht 34,4 h.** Das ist der Owner-Merksatz, in Zahlen.

### 7.3 Was sich stattdessen verdoppelt: die MESS-Zeit, und nur auf prod2

**Bezugsgroessen, alle belegt:**

| Groesse | Wert | Beleg |
|---|---|---|
| Mess-Settings je Binary | **216** = 6 workloads x 4 working_set x 3 hw_prefetcher x 1 thread x 3 repetitions | `all_axes_golden.profile.xml:112,126,156,157,160` (von mir am Objekt nachgezaehlt) |
| Kosten EINER Messung | **109,4 ms** Mittel (Spanne 6,5 .. 448,4 ms), 16 Datenzeilen | `super/docs/plaene/20260806-PLAN-owner-antworten-vertiefung.md:104-110` (Mittelwert `:109`), Korpus `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` |
| Messen ist doktrinaer 1-Thread | | `experiment_plan_director.hpp:1336` ("NUR das Messen ist 1-Thread (run_profile-Loop)"), `:1613` dito, `:116` `bool single_thread = true;` *(Anmerkung: der Quell-Plan `20260806-PLAN-owner-antworten-vertiefung.md:112` nennt `:1370-1372` -- diese Zeilen tragen den Satz am Stand `90bca126` nicht mehr; die Aussage steht unveraendert an den hier genannten Stellen)* |
| Hybrid-Maschine der Flotte | **genau eine**: prod2 = i9-12900K (Alder Lake, 8P+8E) | `measurement/machine_identity.hpp:190-192`; Live-`lscpu` `/home/comdare/Projekte/Cluster/docs/sessions/2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md:9-15` |

**Die Rechnung.**

Auf prod2 verdoppelt eine zweiwertige Kern-Unterachse die Settings je Binary:

```
216 Settings  x 2 Kern-Klassen  =  432 Settings je Binary   (nur prod2)
216 Settings  x 1               =  216 Settings je Binary   (prod1, honest-0)
```

Angewandt auf die vom Owner-Antworten-Plan gerechneten Wege (`:141-146`), Mess-Kosten 0,1094 s:

| Weg | heute (2 Lanes) | mit Kern-Perm, **gleiche Lane-Aufteilung** | mit Kern-Perm, **umverteilt** (2/3 der Binaries auf prod1) |
|---|---|---|---|
| **(A)** 320er-Auswahl, Faecher voll | 2,1 h | **4,2 h** (prod2 wird Engpass) | ~2,8 h |
| **(B)** alle Binaries, flacher Faecher (9 Settings) | ~3,0 d | **~6,0 d** | **~4,0 d** |
| **(C)** = (A)+(B) gestaffelt, Empfehlung des Mess-Plans | ~3,1 d | ~6,2 d | ~4,1 d |
| (D) Vollmenge | 71,7 d | 143,4 d | 95,6 d |

**Rechenweg zu (B), nachvollziehbar:** 524.288 Binaries x 9 Settings x 0,1094 s = 516.214 s =
143,4 h Ein-Lane-Arbeit; auf 2 Lanes = 71,7 h = 2,99 d (deckt sich mit `:144`). Verdoppelt sich der
prod2-Anteil, kostet dieselbe Menge bei gleicher Aufteilung 143,4 h auf prod2 = 5,97 d. Bei optimaler
Umverteilung (Anteil f auf prod2, 2f = 1-f, also f = 1/3) liegt die Wanduhr bei 2/3 x 143,4 h =
95,6 h = 3,98 d.

**Zwei ehrliche Einschraenkungen dieser Zahlen:**
1. **109,4 ms ist eine UNTERGRENZE** -- der Quell-Plan sagt das selbst (`:121-124`): der Korpus wurde
   bei `working_set_n = 4096` erhoben, der golden-Sweep geht bis 8.388.608, und `total_ns` enthaelt
   weder Working-Set-Aufbau noch Warmup noch Rollback.
2. **Die Umverteilungs-Rechnung setzt gleiche Mess-Durchsatzraten beider Lanes voraus.** Das ist
   **nicht belegt** -- der 109,4-ms-Korpus stammt von einer Maschine, die ich nicht zuordnen kann.
   Die Zahl der Zeile "umverteilt" ist damit eine **Rechnung**, keine Messung.

**Kernaussage, die davon unberuehrt bleibt:** die Verdopplung trifft **die Mess-Zeit auf einer
Maschine**, nicht die Bau-Zeit und nicht die Flotte. Der Mess-Plan hat die Mess-Zeit ohnehin als den
Engpass ausgewiesen (`20260806-PLAN-messkette-ceb-observabletier.md:831`: "die Mess-Zeit ist der
Engpass, nicht der Bau"). **Die Kern-Permutation verschaerft genau diesen Engpass und keinen anderen.**

### 7.4 Bau-Reihenfolge (Vorschlag, ohne Freigabe)

| Stufe | Inhalt | Klasse | Warum in dieser Reihenfolge |
|---|---|---|---|
| **S-0** | **Messen** (nicht bauen): ob `perf_event_open(pid=0,cpu=-1)` auf prod2 der Thread-Affinitaet folgt | -- | entscheidet Form (i) gegen Form (ii) in Schritt 5. **Ohne diese Antwort ist alles Weitere geraten.** |
| **S-1** | Kern-Topologie-Probe an der ISA-x-OS-Zelle (Schritt 1), Detektionskette CPUID->sysfs | CEB-ONLY | liefert die Werte-Menge; nichts haengt davon ab ausser S-2 |
| **S-2** | Achsen-Typ + Registry-Zeile + XSD/Parser-Anschluss (`target_isa.numa_node`, O-E) | CEB-ONLY | macht die Achse deklarierbar; heilt zugleich die Schein-Achse aus 3.3 |
| **S-3** | Aktuator-Kanal im Dyn-Loop + Pin in `measure_under_setting` | CEB-ONLY | erst jetzt kann das Label auch wirken (Schritt 3) |
| **S-4** | PMC-Domaenen-Wahl in Form (i) oder (ii), je nach S-0 | CEB-ONLY | haengt hart an S-0 |
| **S-5** | Spalte `ran_on_core_type` | CEB-ONLY | macht die Trennung ehrlich (5.4); **muss vor dem ersten Batch stehen**, sonst tragen frueh und spaet erhobene Zeilen verschiedene Semantik |

**Achtung, Datenbruch-Regel aus dem Mess-Plan** (`20260806-PLAN-messkette-ceb-observabletier.md:736`):
eine CEB-ONLY-Aenderung **nach** dem ersten Batch kostet zwar keinen Neubau, erzeugt aber
"**Datenbruch ohne Neubau**". **S-5 gehoert deshalb vor den ersten Batch oder gar nicht in diese Kampagne.**

---

## 8. Die Deep-Research-Pflicht

### 8.1 Was der Code heute kann

`ce/libs/cache_engine/builder/linux_perf_pmc_source.hpp:200-205`, verbatim:

```
///   cache_misses_l1         <- PERF_COUNT_HW_CACHE_L1D / OP_READ / RESULT_MISS   (portabel)
///   cache_misses_l3         <- PERF_COUNT_HW_CACHE_LL  / OP_READ / RESULT_MISS   (Last-Level; ehrlich LL)
///   dtlb_misses             <- PERF_COUNT_HW_CACHE_DTLB/ OP_READ / RESULT_MISS   (portabel)
///   cache_misses_l2         <- KEIN portabler generischer Counter -> bleibt 0 (kein RAW-Rateversuch)
///   coherence_invalidations <- KEIN portabler generischer Counter -> bleibt 0 (kein RAW-Rateversuch)
///   energy_micro_joules     <- best-effort RAPL (powercap energy_uj, Delta) -> 0 ohne Zone/Leserecht
```

und `:217-218`: "L2 + coherence_invalidations: KEIN portabler generischer Counter -> bewusst NICHT
geoeffnet, Feld 0."

### 8.2 Was fehlt -- Umfang, nicht Loesung

**(a) Es gibt keine RAW-Event-Tabelle. Null mit Nenner und Gegenprobe:**

| Pruefung | Nenner | Treffer |
|---|---|---|
| `PERF_TYPE_RAW` in `ce/libs` | **1265** `.hpp`/`.cpp` | **0** |
| `PERF_TYPE_` in `ce/libs` (Gegenprobe) | dieselben 1265 | **5**, alle in `linux_perf_pmc_source.hpp` |
| `0x1A` in `platform_probe/cpuid_probe.hpp` | 196 Zeilen | **0** |
| `cpuid(` in derselben Datei (Gegenprobe) | 196 Zeilen | **8** |

**(b) Die einzige vorhandene Vorlage ist eine Spec vom 01.06., deren Plattform-Annahmen tot sind.**
`ce/docs/sessions/20260601-26-pmc-counter-beschaffungs-spec.md:64,67`:

> `| cache_misses_l2 | i.d.R. kein generischer Code -> PERF_TYPE_RAW mit Modell-Event |`
> `| coherence_invalidations | nur PERF_TYPE_RAW (Snoop/HITM), modellspezifisch -> wenn unbekannt: 0 + ehrlich |`

**SUPERSEDED-Warnung:** das Dokument zielt auf Windows/i7-1270P und ZIH-Barnard; der i7-1270P wurde
laut Ledger `:874` am 15.06. von Messwerten ausgeschlossen, gemessen wird heute baremetal auf
prod1/prod2. **Die technische Substanz (RAW noetig fuer L2+Kohaerenz, Mapping-Tabellen, PAPI) gilt;
die Plattform-Zuordnung nicht.**

**(c) Der einzige gebuchte Auftrag ist auf EINE Mikroarchitektur geschrieben.**
Ledger `:2917`: "I-PMC-3/#187 PMC-Auto-Adaption (L2+coherence **Zen-5-RAW**)". Und die Konsequenz,
Ledger `:5298-5300`:

> "**I-PMC-2 BLEIBT OFFEN, und das begrenzt den Anhang:** auch **mit** Flag bleiben L3, L2, coherence
> und energy auf 0 ... **Der Anhang kann also selbst im besten Fall nur L1D + dTLB zeigen**"

**(d) Eine Pflicht "alle belegbaren AMD-/Intel-Architekturen" ist im Bestand NICHT gebucht.**
Nenner: gesamter `super/docs`-Baum + Ledger (6735 Zeilen). Zaehlungen im Ledger:
`Mikroarchitektur`=0 · `RAW-Event`=0 · `Zen 3`=0 · `Zen 4`=0 · `Golden Cove`=0 · `Gracemont`=0.
Die **einzige** belegte Deep-Research-Pflicht ist `:1577` ("deep research Pflicht") und sie bezieht
sich auf die **P/E-Achsen-Modellierung**, nicht auf einen Architektur-Katalog.
**Der Anspruch ist damit neu und zu ERFASSEN, nicht nachzuschlagen** -- er gehoert als Owner-Posten
gebucht (F-5).

**(e) Der heutige Ist-Umfang der Flotte, als Bezugsgroesse, nicht als Zielvorgabe:**
`system_axis_registry.xml` `<machine_signatures count="3">` -- `prod1_zen5`, `prod2_raptor_lake`
(faktisch Alder Lake, siehe F-6), `odroid_gracemont`. `machine_identity.hpp` deklariert **2**
Maschinen (`kProd1Zen5Core` `:182-187`, `kProd2AlderLakeCore` `:200`); odroid bleibt undeklariert.

**Umfang der Pflicht, benannt (nicht geloest):**

1. Je Ziel-Mikroarchitektur eine **Event-Code-Tabelle** fuer die heute stummen Felder
   (`cache_misses_l2`, `coherence_invalidations`) -- Vendor-Dokumentation, nicht ableitbar.
2. Eine **Auswahl-Mechanik**: aus der Live-CPUID/Vendor-Kennung die Tabelle waehlen. Der Traeger dafuer
   existiert (`machine_identity.hpp`), der Inhalt nicht.
3. Fuer Hybrid zusaetzlich die **PMU-Type-Aufloesung** `cpu_core`/`cpu_atom` -- die Kernel-Abfrage
   (sysfs `/sys/bus/event_source/devices/*/type`) und ihr Transport in `attr.config[63:32]`
   (Dossier `:9`). **Im Projekt heute nirgends implementiert** -- `linux_perf_pmc_source.hpp:110`
   oeffnet ausschliesslich `PERF_TYPE_HW_CACHE` ohne PMU-Selektor.
4. Eine **Ehrlichkeits-Regel** fuer unbekannte uarch: 0 + ausgewiesen, nie geraten. Die Regel steht
   schon (`:203-204` "kein RAW-Rateversuch") und ist beizubehalten.

---

## 9. Offene Owner-Fragen

Jede Frage mit Empfehlung. **Keine davon entscheide ich.**

### F-1 -- Naht A oder Naht B: "startet" = Prozess oder = Durchlauf?

**Der Widerspruch, ehrlich benannt:** der KERN sagt "**startet** einmal die Tier-Binary gepinnt auf
einen E-Core und einmal gepinnt auf einen P-Core" (V-3). Heute wird die Tier-Binary im CEB-Mess-Pfad
**nie gestartet**, sondern per `dlopen` geladen (`cache_engine_builder_iterator.hpp:2373-2376`; Null
mit Nenner in 2.2). Derselbe KERN sagt aber "Achsen-Permutation **durch die CEB**" -- und die CEB ist
genau die Instanz, die in-process laedt und faehrt.

**Empfehlung: Naht B** (`DynamicDim` + `ScopedThreadPin`), Lesart "startet" = "faehrt an".
Begruendung: sie erfuellt "durch die CEB" woertlich, der Aktuator ist vorhanden und getestet, der
PMC laeuft im selben Thread wie der Pin, und die Ablage-Trennung faellt ueber `setting` gratis ab.
Naht A braeuchte eine Prozess-/Exec-Praefix-Mechanik, die es im Projekt nicht gibt (der einzige
`taskset`-Pfad ist deprecated, 2.4).

### F-2 -- Bindet der Kernel die Hybrid-PMU beim OEFFNEN oder folgt sie dem Thread?

Das ist die **technisch kritischste** offene Frage; sie entscheidet Form (i) gegen Form (ii)
in Schritt 5 und damit, ob `make_pmc_source()` einen Parameter braucht.
Der Code oeffnet CPU-unabhaengig (`linux_perf_pmc_source.hpp:110`, `pid=0, cpu=-1`); der Datei-Kopf
`:36-37` zitiert die man7-Semantik ohne Hybrid-Fall. **Im Repo nirgends belegt, und ich habe es nicht
gemessen.**

**Empfehlung:** als **S-0** vor jedem Bau am Objekt messen (ein kurzer Pin-dann-Oeffnen-Test auf
prod2, gegen Pin-nach-Oeffnen). Das ist eine Messung von Minuten und ersetzt eine Raterei, die eine
ganze Kampagne verderben koennte.

### F-3 -- NUMA-Achse oder Hardware+Scheduling: welcher Ort gilt?

**Der KERN gewinnt** -- er legt die Kern-Wahl unter die **NUMA-Achse** (V-4). Der Widerspruch gehoert
trotzdem hierher, weil er aus dem SSOT stammt:

`super/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:1577` (Sekt.16.3-E17, 16.07.):
> "Der P/E-Core-Aspekt ist eine SEPARATE System-Achse, jedoch als DYNAMISCHE Unter-Achse **unter der
> Hardware-Systemachse** (**neben NUMA**, Multithreading) ... **H-1 = wie empfohlen:** Hardware traegt
> das FAKTUM (Core-Typ-Karte + `ran_on_core_type`), die aktive Pinning-POLICY als
> **Scheduling-Unter-Achse**"

Der 16.07.-Entscheid legt das Faktum unter Hardware und die Policy unter Scheduling, NUMA steht
*daneben*. Der KERN vom 06.08. legt beides unter NUMA. Beide Orte haengen heute am selben
`target_isa`-Komplex (`system_axis_registry.xml:29` fuer `scheduling`, `:38` fuer `numa_node`), der
Unterschied ist also die Einordnung, nicht der Baum.

**Empfehlung: dem KERN folgen** (Kern-Unterachse unter `numa_node` bzw. als Geschwister-Unterachse am
`target_isa`-Komplex) **und die Abweichung in der Arbeit benennen**, weil E-17 im Ledger als Entscheid
steht. Praktische Konsequenz gering: `scheduling` ist heute `stage="ct"` (`:29`) und traegt
`hetero_core_dispatch` mit der einzigen Auspraegung `None` (`scheduling_system_axis.hpp:76-78`), waere
also fuer eine RT-Permutation ohnehin erst umzuziehen. Zusatz-Befund: `scheduling` hat **keinen**
XSD-Kanal (`/usr/bin/grep -c "scheduling" experiment_schema.xsd` = **0**; Gegenprobe `numa_node` = **3**).

### F-4 -- Wieviele Auspraegungen hat die Achse auf prod1?

prod1 ist ein **AMD Ryzen 9 9950X3D** (`machine_identity.hpp:182-187`) -- kein P/E-Hybrid, aber ein
Zwei-CCD-Teil. Das Projekt-Vokabular sieht das ausdruecklich vor, `platform/core_layout.hpp:15-17`:

```cpp
    HighIpc     = 1, // generisch fuer P-Cores / V-Cache-CCDs / "starke" Cores
    LowIpc      = 2, // generisch fuer E-Cores / "schwache" Cores
```

**Frage:** soll die Achse auf prod1 einelementig sein (honest-0, Dossier `:11`) oder zwei
Auspraegungen tragen (V-Cache-CCD gegen Nicht-V-Cache-CCD)?

**Empfehlung: fuer diese Kampagne einelementig auf prod1.** Begruendung: (a) der KERN spricht von
E-Core/P-Core, (b) die Mess-Zeit ist der Engpass (7.3) und eine zweite Verdopplung auf der schnelleren
Lane frisst die Umverteilungs-Reserve, (c) die CCD-Unterscheidung braucht eine eigene Erhebung, die
nicht in der CPUID-0x1A/sysfs-Kette des Dossiers steht. **Als Folge-Increment sauber nachziehbar,
weil die Achse dann schon existiert.**

### F-5 -- Ist die Deep-Research-Pflicht "alle belegbaren AMD-/Intel-Architekturen" so gemeint?

Der Anspruch ist im Bestand **nicht gebucht** (8.2(d), Nullen mit Nenner). Gebucht ist nur
`#187 PMC-Auto-Adaption (L2+coherence Zen-5-RAW)` (Ledger `:2917`) -- also **eine** Mikroarchitektur.

**Empfehlung:** den Anspruch als neuen Posten buchen und **auf die Flotte begrenzen**, die es real
gibt (Zen 5 / Alder Lake P+E / Gracemont, `system_axis_registry.xml` `count="3"`). Ein Katalog fuer
nicht vorhandene Hardware waere unpruefbar -- und unpruefbare Tabellen sind genau das, was die
bestehende Regel "kein RAW-Rateversuch" (`linux_perf_pmc_source.hpp:203-204`) verhindern soll.

### F-6 -- Namens-Drift `prod2_raptor_lake` gegen `kProd2AlderLakeCore`

Die Registry fuehrt die Maschine als `prod2_raptor_lake` mit `cpu_fabrication="GenuineIntel/6/151/2"`;
die Identitaets-Konstante heisst `kProd2AlderLakeCore` und ihr Kommentar sagt
(`machine_identity.hpp:190-192`): "Family 6 / Model 151 / Stepping 2 ist Alder Lake-S, die CPU des
Hosts prod2 (i9-12900K)." **Der Wert ist korrekt, nur das Label ist alt.** Die Drift betrifft
ausgerechnet die einzige Hybrid-Maschine der Flotte. Ungebucht: `raptor_lake` kommt im SSOT-Ledger
**0**-mal vor (Gegenprobe `numa_node` = 5 Treffer).

**Empfehlung:** als Doku-Zeile ausweisen, **nicht** umbenennen. Ein Registry-ID-Wechsel beruehrt
Zell-Zuordnungen und ist vor der Abgabe unnoetiges Risiko; die Verwechslungsgefahr heilt eine
benannte Zeile genauso.

### F-7 -- Was ist mit dem Gate `P/E-Core (HW+Nr.215)`?

Der Ledger fuehrt den Posten unter G7 als "GENUIN GATED" (`:265`: "**P/E-Core (HW+#215)**"). Beide
Beine sind aus meiner Sicht gefallen:

- **Bein "HW"** = die Intel-Hybrid-Maschine. **Aufgeloest seit 27.07.**: prod2 ist ein i9-12900K
  (8P+8E), online, Live-`lscpu` in
  `/home/comdare/Projekte/Cluster/docs/sessions/2026-07-27-INFRA-AN-DIPLOM-o4a-prod2-cpu-VOLLZUG.md:9-15`.
  Die Ledger-Zeilen `:865-872`, `:2065`, `:2596`, `:2642`, `:2943`, `:2999` ("14900KS-RMA ~September",
  "hardware-blockiert") tragen **aeltere** Erhebungsdaten und sind damit **STALE**.
- **Bein "Nr.215"** = der EINE reservierte 320-DLL-Neubau-Slot. **Faellt weg**, weil der KERN keinen
  Neubau verlangt (X-3) und Abschnitt 6.2 das am Objekt belegt.

**Verbleibt genau ein Gate:** `G-270a` -- die gemeinsame Sichtung der verriegelten Plattform-Tests
(Ledger `:1312`: "aendert verriegelte Plattform-Tests ... **User-Sichtung noetig**"). Die betroffenen
Assertions sind am Objekt: `ce/tests/unit/test_cpuid_probe.cpp:63` und
`ce/tests/unit/test_platform_concepts.cpp:38` -- beide `EXPECT_FALSE(...cpu_core_atom_perf_separation)`.
**Sie kippen in dem Moment, in dem die Probe die Wahrheit sagt (Schritt 1).**

**Empfehlung:** die Sichtung dieser **zwei** Assertions als eigenen, winzigen Owner-Termin fuehren --
sie sind der einzige verbliebene Blocker der ganzen Strecke.

---

## 10. Kurzfassung

1. **Die Achse existiert und liegt richtig:** `numa_node` als `stage="runtime"`-Unter-Achse am
   `target_isa`-Komplex mit `binary_id="never"` (`system_axis_registry.xml:38,10`). Was fehlt, ist die
   **Core-Unterachse** und ein **Erheber fuer Kern-Typen** -- `NumaPageTopology` traegt heute nur
   Node-IDs und Seitengroessen (`numa_page_probe.hpp:181-184`).
2. **Der Andockpunkt ist `target_isa.numa_node`, und O-E beantwortet sich damit von selbst:**
   das POD-Feld hat 2 Schreibstellen und 0 Leser (`xml_config_parser.cpp:130,132`; Header-Zusage
   `:234-235`) -- der Owner-KERN macht den Anschluss von der Aufraeum-Frage zum tragenden Traeger.
   **Anschliessen, nicht als declared-inert ausweisen** -- und dabei die Namensfalle
   `alloc_hw.numa_node` meiden.
3. **Es ist eine Permutation, kein Bau:** alle acht Preimage-Glieder bleiben unberuehrt
   (`anatomy_fingerprint.hpp:463-471`, insbesondere Glied [4] `subaxis_valueset_segment.hpp:60-65`,
   das nur Organ-Unter-Achsen rendert), der Stempel ist per `static_assert` gesperrt
   (`system_cell_values.hpp:166-167,193-196`), der Dyn-Loop "erzeugt KEINE neue Binary"
   (`runtime_variable_loop.hpp:4-9`). **Klasse CEB-ONLY, ~77 s -- nicht 34,4 h.**
   Was sich verdoppelt, ist die **Mess-Zeit auf prod2**: 216 -> 432 Settings je Binary.

---

**Selbstcheck:** Dieses Dokument schreibt keinen Code, aendert keine Konfiguration und trifft keine
Entscheidung. Alle Datei:Zeile-Angaben stammen aus Live-Lesung am Stand super `18a0bdf3` /
ce `90bca126`; alle Nullen tragen Nenner und Gegenprobe; alle mit `[BERICHT]` markierten Zahlen sind
uebernommen und nicht von mir nachgemessen. Keine Haken-Marken, keine erfundene Plan-Referenz.
