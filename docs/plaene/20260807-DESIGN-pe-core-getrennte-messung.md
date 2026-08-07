# DESIGN — Getrennte P/E-Core-Messung (P1 aus dem Scope-Freeze, OD-11-RT-K)

**Datum:** 2026-08-07
**Auftrag:** P1 aus dem Scope-Freeze — seit 09.04.2026 Pflicht, nie gebaut. Ledger `:4279-4285` (Vier-Punkte-Vorgabe) und `:4315-4333` (Mechanik-Vorgabe).
**Arbeitsstand:** `wt-ce-pecore`, Branch `bau/pe-core-messung`, Basis `origin/development` = `5060489e`.
**Ergebnis dieses Dokuments:** **STUFE 1 — Analyse und Entwurf. Kein Bau.** Begründung in §6.

---

## 0. DIE KURZFASSUNG — vier Sätze

1. **prod1 ist nicht hybrid** (AMD Ryzen 9 9950X3D, kein `cpu_core`/`cpu_atom`), **aber sehr wohl kern-asymmetrisch**: zwei L3-Domänen, 96 MB gegen 32 MB, Faktor 3. Die Probe erkennt das am Objekt korrekt und behauptet dabei **nicht**, es seien P- und E-Cores.
2. Die **Erkennung** ist gebaut und funktioniert (Bissbeweis §3). Die **Messung** fehlt — aber nicht als isoliertes Loch: es fehlt der **Resolver**, der `machine_resolved`-Achsenwerte in die Permutation trägt, und der fehlt für **alle drei** RT-Unter-Achsen (`numa_node`, `page`, `core_class`).
3. Die Ablage-Trennung ist **kein Byte-Ereignis** — das ist im Code begründet, nicht nur angenommen (`target_isa` trägt `binary_id="never"`).
4. **Der Owner muss zwei Dinge entscheiden**, bevor sinnvoll gebaut werden kann (§7). Ohne sie führt jeder Bau entweder einen Sonderweg ein oder legt die Ablage-Form ohne Mandat fest.

---

## 1. DIE OWNER-VORGABE, VERBATIM

Ledger `:4279-4285`, die vier Festlegungen:

> 1. **Die Frage lautet nie "ist PMC verfuegbar", sondern "welche PMU-Domaenen hat diese Maschine und welche Zaehler traegt jede".** prod2 (i9-12900K, Alder Lake) hat **zwei** (`cpu_core` / `cpu_atom`), prod1 (Ryzen 9 9950X3D) **eine**.
> 2. **P-Core und E-Core werden GETRENNT gemessen UND GETRENNT ausgewertet.** Nicht gemittelt, nicht zusammengefasst, nicht "die erste, die antwortet".
> 3. **Die Abdeckung ist eine DEEP-RESEARCH-PFLICHT**, kein Best-Effort. honest-0 nur, wo die Hardware es wirklich nicht hergibt -- und dann mit Begruendung.
> 4. **Einbau je Konfiguration CT in die CEB, nach Planer-Freigabe.**

Ledger `:4315-4333`, die Mechanik (Owner-Korrektur einer früheren Lead-Fehllesung):

> *"Die CEB **kann beide Messfuehler tragen**, aber legt die Ergebnisse **je PMC getrennt** ab. […] Die CEB kann alles messen, aber startet **einmal die Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core** und misst die Tier-Binary dann mit dem entsprechenden PMC. Das ist eine **reine Wiederverwendung durch Achsen-Permutation durch die CEB auf einer dafuer zustaendigen SYSTEM-Achse**."*

Daraus hart: **EINE CEB**, **KEINE zweite Tier-Binary**, dieselbe Binary **zweimal GESTARTET**, Trennung in der **ABLAGE**. Merksatz des Ledgers: *die Hybrid-Trennung ist eine PERMUTATION, kein zweiter Bau.*

**Wichtig für den Zuschnitt:** Der Ledger bemerkt bei Punkt 1 selbst, dass **prod1 nur EINE PMU-Domäne hat**. Der Auftrag ist damit von vornherein einer, dessen P/E-Ausprägung auf prod2 zielt.

---

## 2. IST-KARTIERUNG — was existiert, was nicht

### 2.1 Was gebaut ist (und heute nachgeprüft wurde)

| Baustein | Ort | Zustand |
|---|---|---|
| Kern-Klassen-Vokabular (5 Werte) | `numa_cpu_pin_process_probe.hpp:155-172` | vollständig, mit Begründung warum vier statt zwei |
| Provenienz-Vokabular (5 Quellen) | `numa_cpu_pin_process_probe.hpp:197-224` | vollständig, inkl. L-1-Korrektur vom 07.08. |
| Erkennungs-Kaskade (3 Stufen) | `numa_cpu_pin_process_probe_linux.hpp:386-408` | **funktioniert am Objekt**, siehe §3 |
| Achse `core_class` als Typ | `target_isa_sub_axes.hpp:97-107` | Unter-Achse von `target_isa`, `machine_resolved` |
| Achse in der Registry-XML | `system_axis_registry.xml:40` | `stage="runtime"`, eingetragen |
| Achse in den RT-Zellwerten | `system_cell_values.hpp:166-174` | als Stempel-**Verbot** geführt (§4.4) |
| XML-Kanal für Anwenderwerte | `xml_config_parser.cpp:137-138` | `<target_isa><core_class><option value=…>` wird geparst |
| Pinning-Aktuator (Thread) | `builder/measurement/thread_pinning.hpp:18-91` | `ScopedThreadPin`, `sched_setaffinity(0,…)` |
| Pinning-Präfix (Prozess) | `experiment_tree/slurm_launcher.hpp:63-71` | `taskset -c` — **nur im SLURM-Pfad** |
| Der Owner-WARN als Konstante | `numa_cpu_pin_process_probe.hpp:343` | `"warn: no pinned locality on hybrid architecture"` — formuliert, **nicht ausgegeben** |

### 2.2 Was fehlt — und die Paket-Grenze, die es benennt

Der Probe-Header **deklariert seine eigene Grenze** und benennt mein Paket (`numa_cpu_pin_process_probe.hpp:110-118`, verbatim):

> *"PAKET-GRENZE, DEKLARIERT […]: dieses Paket ist das ANGEBOT, nicht sein Konsument. Die erhobenen Werte in die Planer-/CEB-Aufloesung, in die Permutation und in die Mess-Ausgabe zu tragen -- die CEB, die DIESELBE Tier-Binary einmal auf einen E-Core und einmal auf einen P-Core gepinnt startet, die getrennte Auswertung je Klasse, und die Ausgabe des WARN-Textes in Log und CSV -- ist das Folge-Paket **OD-11-RT-K**, exakt so wie OD-10-RT-K fuer die Seiten-Seite. Ebenso NICHT Teil dieses Pakets: das Pinnen der Mess-Naht selbst (der Aktuator ScopedThreadPin und seine Verdrahtung in perm_runner/experiment_driver) und die Hybrid-PMU-Wahl (cpu_core/cpu_atom-PMC)."*

Der Auftrag ist also nicht unbenannt — er ist **OD-11-RT-K**, sauber abgegrenzt.

### 2.3 Der Befund, der den Zuschnitt bestimmt: das Angebot hat keinen Abnehmer

`probe_numa_cpu_pin_process_topology<Device>()` (`hardware_probe_factory.hpp:481-484`) ist Produktionscode — **aber niemand ruft es**. Nachgeprüft über den gesamten Baum ausserhalb der Probe-Dateien: **kein einziger Rufer**, auch kein Test.

Die Schwester-Funktion `probe_numa_page_topology()` hat genau **einen** Rufer: `tests/unit/test_od10_numa_page_probe.cpp:461`.

**Damit ist weder OD-10-RT-K noch OD-11-RT-K gebaut.** Beide RT-Erhebungen sind fertige Angebote ohne Konsument. Das ist die eigentliche Lücke — und sie ist **eine Ebene grösser als „P/E fehlt"**.

**Konsequenz für den Schnitt:** Der fehlende Baustein ist der **Resolver**, der eine `machine_resolved`-Unter-Achse von der Probe in die Planer-Permutation trägt. Er fehlt für `numa_node`, `page` **und** `core_class`. Ihn nur für `core_class` zu bauen, schafft die vierte Sonderbehandlung — genau die Falle, die der Code unter dem Namen **B7** bereits zweimal geschlossen hat (`target_isa_sub_axes.hpp:110-115`: eine dritte Unter-Achse wäre *"entweder unemittiert geblieben ODER unbewacht in die XML gelaufen"*).

### 2.4 Zwei getrennte Achsen-Welten — keine Verwechslung zulassen

| Welt | Träger | Beispiele | Permutiert von |
|---|---|---|---|
| **axes26 / CT** | `registry_to_axis_levels.hpp:151-160` | `page_type`, `simd_extension`, `isa`, `telemetry` | `build_system_axis_levels()` |
| **Registry / RT** | `system_axis_registry.xml`, `target_isa_sub_axes.hpp` | `numa_node`, `page`, **`core_class`** | **niemandem** |

`build_system_axis_levels()` führt die **CT**-System-Achsen. `core_class` gehört in die **RT**-Welt und hat dort keinen Treiber. Wer die beiden verwechselt, baut `core_class` als CT-Achse ein — und **das wäre ein Byte-Ereignis**, weil CT-Achsen in die Bau-Konfiguration gehen.

---

## 3. DIE HARTEN FRAGEN — beantwortet, mit Beleg

### 3.1 Läuft prod1 hybrid? — NEIN. Aber die Maschine ist nicht blind.

```
$ hostname
prod1
$ grep -m1 'model name' /proc/cpuinfo
model name	: AMD Ryzen 9 9950X3D 16-Core Processor
$ ls /sys/devices/cpu_core
ls: cannot access '/sys/devices/cpu_core': No such file or directory
$ ls /sys/devices/cpu_atom
ls: cannot access '/sys/devices/cpu_atom': No such file or directory
```

**Kein `cpu_core`, kein `cpu_atom` — prod1 hat genau eine PMU-Domäne.** Das deckt sich mit dem Ledger (`:4283`), ist also keine Überraschung, sondern eine Bestätigung.

**Aber prod1 ist kern-asymmetrisch.** Am Objekt erhoben:

```
$ cat /sys/devices/system/cpu/cpu*/cache/index3/size | sort | uniq -c
     16 32768K
     16 98304K
$ cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u
0-7,16-23
8-15,24-31
```

**Zwei L3-Domänen: 96 MB (V-Cache-CCD) gegen 32 MB. Faktor 3.** Für eine Cache-Forschungsarbeit ist das ein hochrelevanter Unterschied — vermutlich relevanter als P/E es auf prod2 wäre.

**Bissbeweis — die gebaute Probe auf prod1, literale Ausgabe:**

```
$ ./bissprobe_coreclass
pmu_root  = /sys/devices
cpu_root  = /sys/devices/system/cpu
quelle    = quelle_l3_domaene
gruppen   = 2
  klasse=kern_grosser_cache     cpus=16  [0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23]
  klasse=kern_kleiner_cache     cpus=16  [8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31]
pinning   = erlaubte_kerne=32 maske_wiederhergestellt=1
```

**Das ist die geforderte Ehrlichkeit, am Objekt bewiesen:** Die Probe findet keine Hybrid-PMU, fällt auf die L3-Stufe zurück, meldet die Quelle als `quelle_l3_domaene` und benennt die Klassen `kern_grosser_cache`/`kern_kleiner_cache` — **sie behauptet nirgends, es seien P- und E-Cores.** Genau der Defekt, den der Auftrag fürchtet, tritt hier nicht ein.

**prod2 ist nicht erreichbar:**
```
$ ping -c1 -W2 prod2
ping: prod2: Name or service not known
```
Der Zugang hängt am offenen Infra-Posten **#207 (`prod2-I/O→pmc:intel`)**, der im Ledger `:340` als Gate-Grund für den M3-Gesamtlauf geführt wird.

**Folgerung:** Die P/E-**Ausprägung** ist heute nirgends verifizierbar. Die **Mechanik** (Klasse erkennen → pinnen → getrennt ablegen) ist auf prod1 an der L3-Achse **vollständig verifizierbar** — es ist dieselbe Achse `core_class`, dasselbe Pinning, dieselbe Ablage-Trennung. **Das ist der Hebel, der diesen Auftrag trotz fehlender Hybrid-Hardware baubar macht.**

### 3.2 Wie wird gepinnt?

Drei Kandidaten im Bestand:

| Weg | Ort | Granularität | Passt? |
|---|---|---|---|
| `ScopedThreadPin` | `thread_pinning.hpp:18` | **Thread** des eigenen Prozesses (`sched_setaffinity(0,…)`) | nein — Owner verlangt Prozess-Start |
| `taskset -c` Präfix | `slurm_launcher.hpp:67` | Prozess, aber **nur im SLURM-Skript-Pfad** | teilweise |
| `std::system(cmd)` | `experiment_driver.cpp:256,276` | Prozess-Start **ohne jedes Pinning** | das ist die Lücke |

Die Probe-Datei begründet ausdrücklich, warum sie `ScopedThreadPin` **nicht** benutzt (`numa_cpu_pin_process_probe.hpp:59`) — die Erhebung darf den Aufrufer nicht verändert zurücklassen.

**Empfehlung:** `sched_setaffinity` über `posix_spawn` — nicht `taskset`. Begründung: der Probe-Header erklärt die Shell-Freiheit zur Doktrin (`:13`: *"reine C++-Logik -- kein taskset, kein numactl, kein lscpu, kein hwloc, keine Shell"*), und `artifact_cache.hpp:1059` sowie `build_orchestrator.hpp:798` führen bereits das Muster `posix_spawnp` ohne `/bin/sh` vor. `taskset` bliebe dem SLURM-Pfad vorbehalten, wo ohnehin ein Shell-Skript erzeugt wird.

### 3.3 Was passiert auf nicht-hybrider Hardware?

**Diese Frage ist bereits richtig gelöst** — sie muss nur konsumiert werden:

- Die Kaskade ist dreistufig (`numa_cpu_pin_process_probe_linux.hpp:302`): HybridPmu → L3Domaene → **Homogen**.
- `CoreClassKind::Uniform` ist ausdrücklich **eine echte Antwort, kein Fehlschlag** (`numa_cpu_pin_process_probe.hpp:157`: *"Das ist eine ECHTE Antwort (prod1 ist so), nicht 'nichts gefunden'"*).
- Die Provenienz `CoreTopologySource` **reist mit dem Ergebnis** — eine L3-basierte Klassifikation kann nie als PMU-basierte missgelesen werden.
- Der WARN-Text existiert wörtlich als Konstante und hat ein sauberes Prädikat: er feuert **nur**, wenn mehr als eine Klasse existiert **und** das Pinning nicht durchgesetzt ist — nicht, wenn die Erhebung fehlschlug (`:345-352`).

**Die Antwort ist also nicht „dann misst es halt einmal und nennt es P-Core".** Sie lautet: eine Maschine mit einer Klasse liefert **eine** Permutation, etikettiert `kern_uniform`, mit Provenienz `quelle_homogen`. Auf prod1 liefert sie **zwei** Permutationen, etikettiert `kern_grosser_cache`/`kern_kleiner_cache`, mit Provenienz `quelle_l3_domaene`.

**Offene Stelle:** Die Auswertungsseite muss verstehen, dass `kern_grosser_cache` ≠ `kern_hohe_leistung`. Zwei Läufe auf verschiedenen Maschinen sind nur vergleichbar, **wenn die Provenienz mitgeführt wird**. Sie in die Ablage zu schreiben ist deshalb keine Kür, sondern Bedingung — siehe §4.

### 3.4 Wie wird die Trennung in der Ablage sichtbar? Byte-Ereignis?

**Zur Binary-Identität: NEIN, kein Byte-Ereignis.** Dreifach belegt, im Code selbst begründet:

1. `system_axis_registry.xml:10` — `target_isa` trägt `binary_id="never"`. Die Achse **kann** die Binary-Identität strukturell nicht anfassen.
2. `system_cell_values.hpp:166-172` führt `core_class` in `kSystemCellValueForbiddenKeys` — mit exakt dieser Begründung, verbatim:
   > *"stuende sie im Stempel, waere die Kern-Klasse Teil der Binary-Identitaet -- und die CEB koennte NICHT 'DIESELBE Tier-Binary einmal auf einen E-Core und einmal auf einen P-Core gepinnt' starten, weil die beiden Laeufe dann verschiedene Binaries braeuchten. Genau das schliesst der KERN aus."*
3. `numa_cpu_pin_process_probe.hpp:119-126` (A-15-Stempel-Neutralität) — der Header bietet keine Naht zu Stempel, Registry, XML oder Binary-ID.

**Der Stempel wird also nicht berührt — vorausgesetzt, `core_class` bleibt in der RT-Welt (§2.4).**

**Zur Ablage-Form: UNENTSCHIEDEN.** Das ist die Owner-Frage. Der Ledger sagt *"legt die Ergebnisse je PMC getrennt ab"* — was „getrennt" konkret heisst, sagt er nicht. Drei Kandidaten in §7.

---

## 4. DER SCHNITT — vier Stufen, aufsteigend im Risiko

### S-0 (gebaut) — Erkennung
Liegt vor. Bissbeweis §3.1.

### S-1 — Der Resolver: `machine_resolved` → Permutationswerte
Die generische Naht für **alle drei** RT-Unter-Achsen. Nimmt die Probe-Ergebnisse, gleicht sie gegen das Registry-Angebot ab (der in `xml_config_parser.cpp:136` bereits als *"Resolver-Schritt (OD-11-RT-K)"* angekündigte Abgleich), und liefert dem Planer die zulässige Werte-Menge je Achse.

**Das ist die eigentliche Arbeit — und der Punkt, an dem der Owner-Entscheid Ω-1 (§7) hängt.**

### S-2 — Gepinnter Prozess-Start
`posix_spawn` + `sched_setaffinity` auf einen Repräsentanten der Klasse. Berührt `experiment_driver.cpp:256/276`. Additiv: ohne aufgelöste Klasse bleibt der Start unverändert.

### S-3 — Getrennte Ablage
Hängt an Ω-2 (§7). **Nicht bauen, bevor entschieden.**

### S-4 — PMU-typisierte Events (nur prod2)
`LinuxPerfPmcSource` (`linux_perf_pmc_source.hpp:218-232`) öffnet heute generisch:
```
attr.type = PERF_TYPE_HW_CACHE;      // generisch
perf_event_open(&attr, /*pid*/ 0, /*cpu*/ -1, …);   // self-monitoring
```
Auf einer Hybrid-CPU braucht es stattdessen die **dynamische PMU-Typnummer** aus `/sys/devices/cpu_core/type` bzw. `cpu_atom/type`. **Auf prod1 nicht verifizierbar** (die Dateien existieren nicht). Ungetestet einzubauen wäre genau „grün und trotzdem falsch" — deshalb: **erst mit prod2-Zugang.**

---

## 5. RISIKEN

| # | Risiko | Gegenmassnahme |
|---|---|---|
| R-1 | `core_class` landet versehentlich in der CT-Welt → **Byte-Ereignis** | `static_assert`, dass `core_class` **nicht** in `build_system_axis_levels()` auftaucht; die drei Stempel-Verbote aus §3.4 sind bereits scharf |
| R-2 | L3-Klassen werden als P/E ausgewertet → **Falschaussage in den Daten** | Provenienz (`CoreTopologySource`) ist **Pflichtfeld** der Ablage, nicht optional |
| R-3 | Sonderweg nur für `core_class` → B7-Falle zum dritten Mal | S-1 generisch über `TargetIsaOpenSubAxes` bauen, nicht achsen-spezifisch |
| R-4 | Pinning meldet Erfolg, ohne zu wirken | Bereits gelöst: die Probe prüft die Maske **nach** dem Setzen (`numa_cpu_pin_process_probe.hpp:54`) |
| R-5 | `hybrid_core_aware` wird gesetzt und niemand liest es | **Bestandsbefund, siehe §6.2** |
| R-6 | Mess-Zeit verdoppelt sich | Vom Ledger `:4331` ausdrücklich akzeptiert (*"Was sich verdoppelt, ist die Mess-ZEIT"*) |

---

## 6. WARUM STUFE 1 UND NICHT STUFE 2

Der Auftrag erlaubt Stufe 2 nur, wenn Stufe 1 zeigt, dass es **ohne Owner-Entscheid** geht. Das tut sie nicht. Drei Gründe, jeder für sich hinreichend:

### 6.1 Die kleinste sinnvolle Baustufe ist eine Architektur-Entscheidung
S-1 ist der Resolver für **drei** Achsen (§2.3). Ob er generisch oder `core_class`-spezifisch entsteht, ist eine Struktur-Entscheidung mit Bestandswirkung auf `numa_node` und `page` — nicht meine.

### 6.2 Die vom Lead vorgeschlagene Mini-Stufe wäre ein Feigenblatt
Vorgeschlagen war, `hybrid_core_aware` wahrheitsgemäss zu setzen. **Das Feld hat keinen Leser.** Vollständige Fundortliste im gesamten Baum:

```
libs/…/measurement/i_measurement_source.hpp:55      <- die Deklaration
docs/sessions/20260531-…-plan.md:105, :132          <- der Plan von damals
```

Kein Schreiber, kein Leser, kein Test. Zusätzlich sitzt es in der **falschen Familie**: `MeasurementSourceCaps` gehört zu `IMeasurementSource` (Phase-6-Vorbau vom 10.07.), während der reale Messpfad über `IPmcSource`/`LinuxPerfPmcSource` läuft. Ein `true` in diesem Feld würde die Messung **nicht** ändern — es würde nur so aussehen, als sei P/E berücksichtigt. **Das ist die Fehlerklasse, die dieser Auftrag ausdrücklich verbietet.**

### 6.3 Die P/E-Ausprägung ist heute nicht verifizierbar
prod1 hat keine Hybrid-PMU, prod2 ist nicht erreichbar (§3.1). S-4 wäre ungetesteter Code auf dem kritischen Messpfad.

**Was das nicht heisst:** Der Auftrag ist nicht blockiert. §3.1 zeigt den Weg — die **Mechanik** ist auf prod1 an der L3-Achse vollständig baubar und verifizierbar. Nur die **P/E-Ausprägung** wartet auf prod2.

---

## 7. WAS DER OWNER ENTSCHEIDEN MUSS

### Ω-1 — Zuschnitt des Resolvers (§2.3)
Der Resolver fehlt für `numa_node`, `page` und `core_class` gleichermassen.

- **(a) Generisch** über `TargetIsaOpenSubAxes` — löst OD-10-RT-K und OD-11-RT-K in einem Zug, vermeidet die B7-Falle, ist grösser.
- **(b) Nur `core_class`** — kleiner und schneller, schafft aber die dritte Sonderbehandlung; `numa_node`/`page` bleiben offen.

**Meine Empfehlung: (a).** Der Bestand hat die B7-Falle bereits zweimal geschlossen und dokumentiert sie als Lehre; ein dritter Sonderweg liefe ihr direkt zuwider. Der Mehraufwand ist gering, weil die Mitgliedschafts-Typliste `TargetIsaOpenSubAxes` bereits existiert und bewacht ist.

### Ω-2 — Form der Ablage-Trennung (§3.4)
Der Stempel ist unberührt (dreifach belegt). Offen ist die **Sichtbarkeit**:

- **(a) CSV-Spalten** `core_class` + `core_class_source` — die Provenienz **muss** mit (R-2). Berührt das CSV-Schema; der Bestand kennt dafür bereits die additive Praxis (`experiment_run_entry.hpp:20`: *"KEINE neue Spalte — I4 nutzt lazy_csv_header()"* markiert die Empfindlichkeit).
- **(b) Getrennte Unterordner** je Klasse — schemaneutral, aber die Provenienz braucht dann einen eigenen Träger.
- **(c) Sidecar-Segment** analog `+target=`/`+tel=` (`system_version_suffix.hpp:58`).

**Meine Empfehlung: (a), additiv.** Getrennte **Auswertung** ist eine der vier Owner-Festlegungen; eine Spalte ist der einzige der drei Wege, der sie ohne Nachbau ermöglicht. Zwei Spalten, weil eine Klasse ohne ihre Provenienz missdeutbar ist.

### Ω-3 — Nachfrage, keine Blockade: gilt der Auftrag auch für die L3-Achse?
Der Auftrag heisst „P/E-Core-Messung". Auf prod1 gibt es kein P/E, **wohl aber eine reale, dreifach unterschiedliche Cache-Domäne** (§3.1). Die gebaute Probe deckt beides mit derselben Achse ab.

**Frage:** Soll die getrennte Messung auf prod1 **an der L3-Achse** scharf geschaltet werden, sobald S-1..S-3 stehen — oder bleibt sie schlafend, bis prod2 verfügbar ist?

**Meine Empfehlung: scharf schalten.** Damit ist die Mechanik am echten Objekt bewiesen statt nur gebaut, prod2 wird zum reinen Zuschalten einer weiteren Provenienz — und die Arbeit steht nicht bis #207 still. Für eine Cache-Arbeit ist der Faktor 3 im L3 zudem ein Ergebnis für sich.

---

## 8. GATE-PLAN — welche Beweise belegen, dass die Trennung wirkt

Kein Gate ist bestanden ohne **literale Ausgabe**.

| Gate | Beweis | Heute möglich? |
|---|---|---|
| **G-1** Erkennung ehrlich | Bissprobe §3.1 — Quelle `quelle_l3_domaene`, zwei Klassen, kein P/E behauptet | **ja, erbracht** |
| **G-2** Uniform bleibt uniform | Probe gegen ein sysfs-Fixture mit **einer** L3-Grösse → genau eine Gruppe, `kern_uniform`, `quelle_homogen` | ja (Fixture-Muster in `test_od11_…:223` vorhanden) |
| **G-3** Resolver liefert die Klassen | Planer-Lauf zeigt zwei `core_class`-Werte in der Permutationsliste | nach S-1 |
| **G-4** Pinning wirkt wirklich | Gestartete Binary meldet ihre effektive Maske; **Gegenprobe**: Maske ⊆ Klassen-CPUs, und die beiden Läufe haben **disjunkte** Masken | nach S-2, auf prod1 |
| **G-5** Trennung in der Ablage | Zwei Zeilen, gleiche `binary_id`, verschiedene `core_class` — **die gleiche binary_id ist der Beweis für „kein zweiter Bau"** | nach S-3 |
| **G-6** Stempel unberührt | `build_version` und `binary_id` **byte-identisch** vor/nach der Achsen-Aktivierung | nach S-3 |
| **G-7** WARN feuert korrekt | Mehr als eine Klasse + kein Pinning → `kNoPinnedLocalityWarning` in Log **und** CSV; eine Klasse → **kein** WARN | nach S-3 |
| **G-8** PMU-Trennung | Auf prod2: `cpu_core`- und `cpu_atom`-Events liefern **verschiedene** Zählerstände für denselben Workload | **nein — braucht #207** |

**G-5 ist das entscheidende Gate.** Es beweist die Owner-Mechanik: gleiche Binary, zwei Läufe, getrennte Ablage.

---

## 9. WAS ICH NICHT GEPRÜFT HABE

- **Windows/macOS-Blätter** — nur ihre Köpfe gelesen. Beide führen eigene Provenienz-Vokabeln (`WindowsEfficiencyClass`, `DarwinPerflevel`) und sind von der L-1-Korrektur vom 07.08. betroffen. Für den Linux-Messpfad nicht tragend.
- **Ob der Planer den Resolver aufnehmen kann, ohne seinen Plan-Cache zu invalidieren** — `experiment_plan_director.hpp` habe ich nur an zwei Stellen gelesen. Vor S-1 zu klären.
- **Die `<machines>`-Deklaration** als zweiter Kanal neben der Probe (`system_axis_registry_gen/main.cpp:429`) — möglicherweise ein zweiter Weg, Klassenwerte zu setzen. Vor S-1 zu klären, sonst droht eine Doppelquelle.
- **PAPI-Zweig** (`COMDARE_ENABLE_PAPI`) — ob der Hybrid-Trennung anders behandelt.

---

## 10. STAND

- **Nichts gebaut, nichts geändert.** Der Worktree `wt-ce-pecore` ist unverändert auf `5060489e`.
- Die Bissprobe lag ausserhalb des Worktrees (`$CLAUDE_JOB_DIR/tmp`) und hat keine Datei im Repo angefasst.
- Diese Datei ist die einzige geschriebene.
