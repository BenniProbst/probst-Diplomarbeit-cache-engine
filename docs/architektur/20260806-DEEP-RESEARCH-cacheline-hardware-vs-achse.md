# DEEP RESEARCH 06.08.2026 -- Cache-Line: was die MASCHINE kann vs. was die ACHSE permutiert

STATUS: Synthese-Dokument (READ-ONLY erhoben, kein Commit, keine Code-Aenderung).
ANLASS: Owner-Frage 06.08.2026, verbatim:

> "Unterstuetzt die Maschine jene Cache Line Einstellung die dann durch die System-Achse
> freigegeben und in der Tier-Binary als fest einkompilierte Achse verbucht wird? Deep research
> wie wir herausfinden, welche Cache line Groessen und Einstellungen eine Maschine auf den
> verfuegbaren CPUs unterstuetzt? Sind sie dynamisch einstellbar oder fest?"

GELTUNGSBEREICH UND PRUEFGRENZEN (vorab, damit nichts als staerker gelesen wird als es ist):

- Projekt-Anker (Datei:Zeile) sind von mir SELBST am Objekt geprueft, Repo-Wurzel
  `Code/external/comdare-cache-engine` auf `development`, HEAD `3bbcb8ed`.
- Die Host-Werte in Abschnitt 1a/2 habe ich SELBST auf `prod1` erhoben (Ausgaben unten literal).
- Die breitere Hardware-Landschaft (ARM/POWER/RISC-V/Apple, MSR-Bits, historische Designs) stammt
  aus der parallelen HW-Recherche dieses Fensters; sie ist als solche markiert und mit Quelle
  versehen. Ich habe sie NICHT auf fremder Hardware nachgemessen.
- KEIN Root/MSR-Zugriff in diesem Fenster (`sudo` verlangt Passwort). Alles zu MSR `0x1A4` /
  `0xC001102x` ist deshalb Dokumentations-Aussage, nicht Messung.

---

## 1. DIE DIREKTE ANTWORT

### (a) Unterstuetzt die Maschine jene Cache-Line-Einstellung?

Nein -- nicht in dem Sinn, in dem die Frage gestellt ist. `prod1` (AMD Ryzen 9 9950X3D, Zen 5)
hat auf ALLEN vier Cache-Ebenen eine Line-Groesse von genau 64 Byte, und dieser Wert ist im
Silizium verdrahtet; die Achse permutiert aber vier Werte `{32, 64, 128, 256}`
(`libs/cache_engine/axes/cacheline/cacheline_config.hpp:35`). Von diesen vier entspricht genau
EINER -- 64 -- der echten Hardware-Line; die anderen drei sind auf dieser Maschine keine
Hardware-Einstellung, sondern eine SOFTWARE-seitige Ausrichtungs- und Zaehl-Granularitaet. Das
ist kein Defekt der Achse: der Header sagt selbst, was `line_size` bewirkt --
"line_size -> alignas/Packing-Granularitaet" (`cacheline_config.hpp:16`), und die einzige
Auswertung des Feldes ist `alignment_bytes()`, das `line_size` als Alignment-Zahl zurueckgibt
(`cacheline_config.hpp:51-54`). Wer also fragt "unterstuetzt die Maschine line=128?", bekommt zwei
verschiedene, beide wahre Antworten: als HARDWARE-Line nein, als Alignment-/Padding-Granularitaet
ja, denn `alignas(128)` ist auf jeder x86-64-Maschine gueltig und wirkt messbar.

Zusatz, der die Frage praktisch entschaerft: heute dringt die Achse ohnehin nicht bis zur
Tier-Binary durch. Alle fuenf Organ-Strategie-Basen lassen das NTTP `CacheLineCfg` defaulted, der
Codegen emittiert die per-Organ-Config noch nicht -- so steht es als NAHT im Code selbst:
"heute instanziieren alle Strategie-Basen die Default-CacheLineConfig{} (line_size = B64), weil der
Codegen die per-Organ-Config noch nicht als NTTP emittiert"
(`libs/cache_engine/axes/cacheline/cacheline_line_bytes.hpp:16-18`). Der materialisierte
Katalog-Codegen weist `cacheline` in `permute_axes` sogar HART zurueck
(`apps/catalog_codegen_tool/main.cpp:183-190`). Es wird also derzeit nichts einkompiliert, was die
Maschine nicht koennte -- weil ueberall der Achsen-Default 64 steht, der exakt der Hardware
entspricht.

### (b) Wie ermittelt man, was eine Maschine unterstuetzt?

Man liest es zur Laufzeit aus der CPU bzw. dem OS aus -- es gibt dafuer auf jeder Plattform einen
architektonisch vorgesehenen, dokumentierten Kanal, und das Projekt hat drei davon bereits
implementiert. Auf x86-64 ist es `CPUID`: Leaf `01H` EBX[15:8] (CLFLUSH-Line, Wert x 8 = Bytes),
Leaf `04H` EBX[11:0] ("System Coherency Line Size") bzw. AMD-seitig `8000001DH` EBX mit identischer
Bitaufteilung und `80000005H`/`80000006H` fuer L1/L2/L3. Auf ARM64 ist es das Register `CTR_EL0`
(Felder `DminLine`, `IminLine`, `CWG`, `ERG`), auf RISC-V eingeschraenkt `riscv_hwprobe`
(CBO-Blockgroessen), unter Linux zusaetzlich `/sys/devices/system/cpu/cpu*/cache/index*/coherency_line_size`
und `sysconf(_SC_LEVEL1_DCACHE_LINESIZE)`, unter Windows
`GetLogicalProcessorInformationEx(RelationCache, ...)` -> `CACHE_RELATIONSHIP.LineSize`, unter
macOS `sysctl hw.cachelinesize`. Im Projekt existieren davon bereits: CPUID
(`libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp:174`), sysfs
(`.../platform_probe/sysfs_cache_probe.hpp:74`) und eine Quellenkette CPUID -> vendored
SIMD-Detector -> sysfs, deren Ergebnis in `props.measured_metrics["cache_line_bytes"]` landet
(`.../platform_probe/cpuid_platform_probe.hpp:45-49`). Der Kanal ist also gebaut; was fehlt, ist
nicht die Erhebung, sondern ihre Verwendung (Abschnitt 3).

### (c) Fest oder dynamisch einstellbar?

FEST. Die Cache-Line-Groesse ist eine Eigenschaft der Mikroarchitektur (Tag/Index/Offset-Aufteilung
der Cache-Arrays im Silizium) und laesst sich weder vom Betriebssystem noch von privilegiertem Code
zur Laufzeit veraendern -- es gibt auf keiner der untersuchten Architekturen ein Schreibregister
dafuer; `CPUID`, `CTR_EL0` und `riscv_hwprobe` sind ausnahmslos LESE-Kanaele. Genau so steht es
auch bereits korrekt in der Thesis:
`kapitel/de/02_fundamentals.tex:31-46` -- "Programme koennen die tatsaechliche Groesse zur Laufzeit
*auslesen* [...] sie aber nicht veraendern." Was TATSAECHLICH dynamisch ist und deshalb leicht
verwechselt wird, sind drei benachbarte Dinge: (1) der Zustand der HARDWARE-PREFETCHER (Intel MSR
`0x1A4` Bits 0-3, AMD `0xC0011020-0xC001102B`) -- der Adjacent-Line-Prefetcher laesst eine
64-Byte-Line-Maschine sich bei Miss wie 128 Byte VERHALTEN, ohne die Line zu aendern; (2)
SOFTWARE-Prefetch-Hints (`_mm_prefetch` T0/T1/T2/NTA) und (3) Alignment/Padding im Programm. Nur
Punkt (1) ist eine echte Laufzeit-Stellschraube der Maschine -- und das Projekt hat das schon 2026-06-02
richtig gesehen: `docs/sessions/20260602-cacheline-konfigurator-design-und-hw-recherche.md:74-75`
fuehrt Intel x86 und AMD Zen ausdruecklich mit "64 B (fix)" und nur den Prefetcher als
HW-einstellbar.

**Eine Praezisierung, die nicht unterschlagen werden darf:** ueber ARCHITEKTUREN hinweg variiert die
Line-Groesse sehr wohl (32 B auf aelteren/embedded Kernen, 64 B x86-64 und Cortex-A/Neoverse, 128 B
Apple-Silicon und IBM POWER, 256 B Fujitsu A64FX). "Fest" heisst also: fest JE MASCHINE, nicht
universell 64. Genau darum ist die Erhebung aus (b) eine Pflicht und keine Kosmetik -- und genau
darum ist die Owner-Doktrin "HW-Werte nie statisch, Laufzeit-Factory ISA x OS" hier vollstaendig
richtig, auch wenn die Groesse selbst unveraenderlich ist: unveraenderlich ist nicht dasselbe wie
vorhersagbar.

**Belegte Erhebung auf dieser Maschine (selbst ausgefuehrt, 06.08.2026, literal):**

```
$ getconf LEVEL1_DCACHE_LINESIZE / LEVEL2_CACHE_LINESIZE / LEVEL3_CACHE_LINESIZE
64 / 64 / 64

$ for i in 0 1 2 3; do cat /sys/devices/system/cpu/cpu0/cache/index$i/coherency_line_size; done
64 64 64 64

$ lscpu -C
NAME ONE-SIZE ALL-SIZE WAYS TYPE        LEVEL  SETS PHY-LINE COHERENCY-SIZE
L1d       48K     768K   12 Data            1    64        1             64
L1i       32K     512K    8 Instruction     1    64        1             64
L2         1M      16M   16 Unified         2  1024        1             64
L3        96M     128M   16 Unified         3 98304        1             64

$ grep -m1 "model name" /proc/cpuinfo ; uname -r
model name : AMD Ryzen 9 9950X3D 16-Core Processor
6.17.0-35-generic
```

Aus der parallelen HW-Recherche desselben Fensters (CPUID direkt, eigenes Programm, `taskset`-gepinnt)
kommt ein Befund, der das Bild abrundet und fuer die Thesis wertvoll ist: `CPUID.8000001DH` sub=3
meldet auf `cpu0` 98304 Sets (= 96 MiB L3) und auf `cpu24` 32768 Sets (= 32 MiB L3) -- die
asymmetrische 3D-V-Cache-Bestueckung der beiden CCDs -- ABER `line_size` ist auf BEIDEN CCDs 64.
Kapazitaet und Line-Granularitaet sind unabhaengige Achsen; die Line variiert nicht einmal
innerhalb dieser CPU. Man beachte auch: `lscpu -C` zeigt fuer L3 `ONE-SIZE 96M` neben
`ALL-SIZE 128M` -- dieselbe Asymmetrie, aus zweiter Quelle.

---

## 2. DIE BEGRIFFS-TRENNUNG, DIE ALLES ENTSCHEIDET

Vier Dinge heissen umgangssprachlich "Cache-Line-Groesse". Sie sind verschieden, und die Antwort auf
die Owner-Frage haengt vollstaendig davon ab, welches gemeint ist.

| # | Begriff | Wer legt ihn fest | Aenderbar? | Auf prod1 |
|---|---|---|---|---|
| (a) | **Physische Line-Groesse** der Cache-Arrays (Tag/Index/Offset im RTL) | CPU-Hersteller, Silizium | NEIN, nie | 64 B (L1d/L1i/L2/L3) |
| (b) | **Kohaerenz-Granularitaet** (MESI/MOESI-Block, "System Coherency Line Size", CPUID.04H EBX[11:0] / CTR_EL0.CWG) | Mikroarchitektur | NEIN | 64 B (== (a); heute praktisch immer deckungsgleich) |
| (c) | **Prefetch-/Sektor-Verhalten** (Adjacent-Line-Prefetcher, sektorierte Caches) | HW-Design + MSR-Zustand | JA, zur Laufzeit (privilegiert) | Prefetcher-MSRs vorhanden (AMD `0xC0011020-2B`), in diesem Fenster nicht messbar (kein Root) |
| (d) | **Alignment / Padding / Packing im Programm** (`alignas`, Padding gegen False Sharing, Struct-Stride) | Programmierer / Compiler / Allokator | JA, frei -- Compile-Time | frei waehlbar, 32/64/128/256 alle gueltig |

**Welche dieser vier permutiert die Achse heute? Eindeutig (d).**

Beleg am Objekt, nicht aus dem Gedaechtnis:

- `cacheline_config.hpp:16` (Kopf-Kommentar der Achse selbst): "line_size -> alignas/Packing-Granularitaet
  (Struktur an 64/128/256-B-Grenze)".
- `cacheline_config.hpp:51-54`: `alignment_bytes(CacheLineConfig c)` -- die EINZIGE Stelle, an der
  `line_size` semantisch ausgewertet wird, gibt es als Alignment-Zahl zurueck
  (`None -> alignof(max_align_t)`, sonst `static_cast<size_t>(c.line_size)`).
- `cacheline_line_bytes.hpp:53-61`: `line_bytes_of<T>()` liefert denselben Wert als ZAEHL-Einheit an
  Konsumenten weiter -- rein `constexpr`, kein Laufzeitwert.
- Verbrauch dieser Zaehl-Einheit: `libs/cache_engine/axes/node/axis_04_node_type_layout_aware_store.hpp:570-600`
  markiert beruehrte "Linien" ueber `b / kLineBytes` -- ein MODELL der Linien, gerechnet in der
  eingestellten Granularitaet, NICHT eine Messung der Hardware-Linien.
- Die beiden anderen Dimensionen der Achse -- `alignment` (none/cacheline_aligned/padded) und
  `sw_hint` (none/T0/T1/T2/NTA, `cacheline_config.hpp:57-78` via `__builtin_prefetch`/`_mm_prefetch`)
  -- sind ebenfalls reine (d)-Groessen bzw. SW-Hints. Nichts an der Achse beruehrt (a), (b) oder (c).

**Passt der Name dazu? Teilweise -- und die Luecke ist genau die, die der Owner erfragt.**

`cacheline`/`line_size` mit Werten `{32,64,128,256}` LIEST sich als Aussage ueber (a). Der Code
LEISTET (d). Nach der Doktrin "keine Zusage, die der Code nicht haelt" ist das ein
Benennungs-Defizit, kein Implementierungs-Defekt: die Implementierung ist in sich sauber und
dokumentiert ihre Bedeutung sogar korrekt im Header. Zwei Stellen tragen die Zusage dagegen
GRENZWERTIG nach aussen:

1. `anhang/de/D_building_block_matrix.tex` (Tabelle "Dynamische Sub-Achsen", CacheLineSize-Zeile):
   "**Runtime-Parameter** fuer die Zielplattform-Cache-Zeile: 64 Byte [...] 128 Byte [...] oder
   32 Byte [...]. Wird zur **Compile-Time** ueber CacheLineConfig-NTTP gewaehlt". Der Satz sagt in
   einem Atemzug Runtime und Compile-Time, und er steht unter der Ueberschrift "Dynamische
   Sub-Achsen". Das ist die einzige Stelle in der Thesis, die sich als Zusage ueber (a)/(c) lesen
   laesst. Der Rest des Satzes ("beeinflusst Alignment-/Padding-Overhead aller alignierten Layouts")
   ist bereits die richtige (d)-Aussage.
2. Die Owner-Randnotiz in `kapitel/de/02_fundamentals.tex:14` (auskommentiert, nicht im Satz):
   "seit einiger Zeit die cache-line Groessen auf CPUs dynamisch anpassbar, was Ziel dieser Arbeit
   ist". Diese Annahme ist nach der Recherche NICHT haltbar -- und der KOMPILIERTE Text des
   Kapitels sagt bereits das Richtige (`02_fundamentals.tex:31-46`: auslesbar, nicht veraenderbar).
   Der Fliesstext ist also schon korrekt; nur die Notiz traegt noch die alte Annahme.

Der spannende Punkt fuer die Arbeit: der zweite Teil derselben Owner-Notiz beschreibt exakt das,
was tatsaechlich geht und was die Arbeit auch tut -- "die Ermittlung der statischen cache-line
Eigenschaften zur systemoptimierten binary-Kompilation als Automatisierung der Optimierung". Das
ist die haltbare Neuheits-Behauptung. Nicht "wir stellen die Cache-Line dynamisch ein", sondern
"wir ERHEBEN sie dynamisch je ISA x OS und BACKEN daraus die passende Binary". Genau dieser Satz
ist zugleich der Bau-Auftrag aus Abschnitt 3.

---

## 3. DIE FREIGABE-KETTE: SOLL, IST, BAU-AUFTRAG

### 3.1 SOLL nach der Stufen-Doktrin

Die Doktrin ist im Projekt fuer die ISA-Achse bereits vollstaendig gebaut und laesst sich 1:1
uebertragen:

```
SYSTEM-ACHSE (RT, CEB/Planer)                ORGAN-ACHSE (CT, Tier-Binary)
  erhebt Host-Eigenschaft                      traegt die freigegebene Auspraegung
  -> gibt Auspraegungen FREI                   als NTTP fest einkompiliert
  -> nicht freigegebene: ehrlich ueberspringen
```

Fuer die Cacheline hiesse das: die CEB erhebt zur Laufzeit die ECHTE Hardware-Line des Bau-/Mess-Hosts
(bzw. der DEKLARIERTEN Zielmaschine) und entscheidet daraufhin, welche `line_size`-Auspraegungen
ueberhaupt gebaut und gemessen werden duerfen -- bzw., wenn sie alle gebaut werden sollen, dass die
nicht-hardware-deckenden ehrlich als solche gekennzeichnet in die Messung gehen.

### 3.2 IST: existiert diese Pruefung? NEIN -- fuer cacheline nicht eine Zeile

Verifiziert per Grep ueber den gesamten Baum:

- `host_supported` kommt genau DREIMAL vor und nie in Code:
  `libs/cache_engine/algorithm_profiles/thesis_profiles/cacheline_study.profile.xml:126`
  (`<require axis="isa" host_supported="true"/>` -- bezieht sich auf `isa`, NICHT auf `cacheline`),
  `.../thesis_profiles/SCHEMA.md:34` (Doku-Zeile),
  `docs/sessions/20260602-cacheline-konfigurator-design-und-hw-recherche.md:156` (Design-Notiz).
  Keine `.hpp`/`.cpp` parst oder implementiert das Attribut.
- Die gemessene Hardware-Line ist ein SACKGASSEN-WERT: `measured_metrics["cache_line_bytes"]`
  (`platform_probe/cpuid_platform_probe.hpp:48`) wird ausserhalb von Tests nirgends gelesen.
  `cpuid_probe().cache_line_bytes` fliesst nur in Provenienz-/Anzeige-Pfade
  (`libs/cache_engine/builder/provenance_manifest.hpp:67,89`;
  `libs/cache_engine/include/cache_engine/abi/module_abi_v1.hpp:85`; `apps/f15_compare/main.cpp:145`).
  Kein Bau-Gate, kein Planer-Filter, keine Verbindung zu `CacheLineConfig`.
- Die deklarierte Maschine kennt das Feld gar nicht: `struct DeclaredMachine`
  (`libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp:164-178`) traegt
  `ram_frequency_mhz`, `cas_latency_cl`, SIMD-Signatur, Kern-Kennung -- aber KEIN
  `cache_line_bytes`.
- Der Gegenbeweis, dass die Doktrin sonst gebaut IST: fuer ISA existiert die volle Kette --
  `system_axis_host_supports_simd()`
  (`libs/cache_engine/profile_facade/profile_run_entry.hpp:245-267`) prueft erst die DEKLARIERTE
  Maschinen-Signatur, sonst `__builtin_cpu_supports`; der Walk ueberspringt host-unfaehige Zellen
  ehrlich mit Fehlerklasse (`.../experiment_run_entry.hpp:293-297` und
  `profile_run_entry.hpp:848,889`, Klasse `HardwareErweiterungFehlt`,
  `include/cache_engine/measurement/axis_error.hpp:42`); der Planer annotiert statt zu filtern
  (`.../planner/experiment_plan_director.hpp:173, 2064`); das Praedikat ist freistehend testbar
  (`libs/cache_engine/profile_facade/gn_cell_filter.hpp:37-47`).

**Verdikt: die Freigabe-Naht existiert als MUSTER, aber fuer die Cacheline-Achse ist sie leer.
Heute ist das nicht scharf** (die Achse dringt wegen der fehlenden NTTP-Emission und der harten
Ablehnung in `catalog_codegen_tool/main.cpp:183-190` gar nicht bis zur Tier-Binary durch). **Sie
wird in der Sekunde scharf, in der KF-6 / Posten 62 die NTTP-Emission nachruestet** -- dann werden
Binaries mit einer Line-Annahme gebaut, die zur Maschine nicht passt, ohne dass irgendwer widerspricht.

### 3.3 BAU-AUFTRAG (praezise, so dass er ohne Rueckfrage ausfuehrbar ist)

**B-1: Die Sonde -- WO.**
Nicht neu bauen; anhaengen. `libs/cache_engine/include/cache_engine/measurement/hardware_probe_factory.hpp`
ist ausweislich seines eigenen Kopfes (Zeilen 1-6, 34-40) die CT-Factory `HardwareProbeDevice<Isa, Os>`
plus "die EINE memoisierte Erhebung an der CEB-Freigabe-Naht", an der bereits ZWEI Erhebungen
haengen (RAM-Kette, und seit OD-10-RT die numa/page-Probe). Die Cache-Line-Erhebung ist die DRITTE
an derselben Zell-Koordinate -- exakt die Owner-Doktrin "Laufzeit-Factory ISA x OS", und exakt die
Begruendung, die im Header schon steht: "die Aussage 'auf dieser Plattform liegt der Zugang so'
gehoert genau einmal in den Bestand".
Die Ketten-Glieder existieren bereits und muessen nur unter die Zelle gehaengt werden:
`platform_probe/cpuid_probe.hpp:174-189` (x86 CPUID Leaf 1; Apple-Silicon-Sonderfall 128),
`platform_probe/sysfs_cache_probe.hpp:74` (Linux `coherency_line_size`),
Reihenfolge wie in `platform_probe/cpuid_platform_probe.hpp:45-49` (erster Nicht-Null gewinnt).
Fehlend fuer Vollstaendigkeit der Matrix: ARM64 `CTR_EL0` (DminLine/CWG), Windows
`GetLogicalProcessorInformationEx`, macOS `sysctl hw.cachelinesize` -- als eigene Zell-Zeilen,
nicht als Sonderfall im x86-Glied.

**B-2: Die Deklaration -- WO.**
`struct DeclaredMachine` (`measurement/machine_identity.hpp:164-178`) bekommt ADDITIV am Ende
`std::uint32_t cache_line_bytes = 0;` mit derselben Ehrlichkeits-Regel wie `ram_frequency_mhz`:
**0 == NICHT DEKLARIERT, niemals als Wert verwendet** (die Regel steht schon da,
`machine_identity.hpp:170` und `ram_identity_verdict.hpp:250`). Vorrangregel identisch zu
`system_axis_host_supports_simd`: **deklarierte Maschine schlaegt Host-Probe; ohne Deklaration
Host-Probe als ehrlicher Fallback** (`profile_run_entry.hpp:236-244` beschreibt genau diese
Begruendung fuer SIMD und ist wortgleich uebertragbar).

**B-3: Das Praedikat -- WO und WIE.**
Neu, als Spiegel von `system_axis_host_supports_simd`, im selben Header
(`profile_facade/profile_run_entry.hpp`, direkt daneben, damit beide Praedikate eine Naht bilden):

```
system_axis_host_line_bytes()  -> uint32_t   // deklariert > gemessen > 0 (== unbekannt)
system_axis_supports_line(uint32_t requested) -> LineSupport
```

`LineSupport` ist bewusst DREIWERTIG, nicht bool -- das ist der Kern der ganzen Frage:

- `Exakt`      : `requested == host_line` -- die Messung ist hardware-wahr.
- `Modell`     : `requested != host_line`, aber ein gueltiges Alignment (Zweierpotenz,
                 `>= alignof(max_align_t)`, `<= 256`) -- baubar, aber KEINE Aussage ueber die
                 Hardware-Line. Das ist auf prod1 der Fall fuer 32, 128 und 256.
- `Unbekannt`  : `host_line == 0` (Sonde lieferte nichts, keine Deklaration) -- fail-closed.

**B-4: Das Verhalten -- die eigentliche Owner-Entscheidung, hier mit Empfehlung.**
Drei Optionen standen zur Wahl; ich empfehle die dritte, weil sie als einzige die
Alignment-Semantik nicht zerstoert:

- *Ueberspringen* (wie bei SIMD): waere FALSCH. Bei SIMD kann die Binary auf dem Host gar nicht
  laufen (SIGILL) -- da ist Ueberspringen die einzige ehrliche Wahl. Bei einer
  Alignment-Granularitaet laeuft die Binary einwandfrei und misst einen ECHTEN Effekt
  (Abschnitt 4). Ueberspringen wuerde die Achse auf einen einzigen Wert kollabieren und das
  Kernthema der Arbeit loeschen.
- *Fail-closed hart*: nur fuer `Unbekannt` richtig. Wenn die Sonde nichts liefert, darf keine
  hardware-bezogene Kennzahl (CLU) berechnet werden -- dann `mark_source_unavailable()`, nicht
  raten. Die Mechanik dafuer existiert bereits (`measurement/system_axis.hpp:319-334`).
- *Bauen, aber ehrlich kennzeichnen* -- EMPFOHLEN. Alle Auspraegungen werden gebaut und gemessen;
  jede Permutation traegt einen Stempel `cacheline_host_bytes` (was die Maschine hat) und
  `cacheline_assumed_bytes` (was die Binary annimmt) und ein abgeleitetes
  `cacheline_hw_exact = true|false`. Bei `false` ist die Zeile eine gueltige Padding-/
  Alignment-Messung, aber keine Hardware-Line-Messung -- und genau das steht dann auch im Datensatz,
  statt im Kopf des Lesers. Fuer die Fehlerklassen-Pflicht: `HardwareErweiterungFehlt`
  (`axis_error.hpp:42`) passt hier NICHT semantisch (nichts fehlt, die Binary laeuft); die
  ehrliche Einordnung ist ein NEUER, additiv angehaengter Klassen-Eintrag im Sinne der bestehenden
  RF-3-Auflage ("Etiketten UND Nummern reisen in Logs, deshalb ANHAENGEN, Nummern 0..4 stehen
  still", `axis_error.hpp:63-64`) -- Arbeitstitel `HardwareAnnahmeAbweichend`. Wer vor der Abgabe
  keinen Klassen-Zuwachs will, laesst die Klasse weg und behaelt nur die zwei Stempel-Spalten;
  die Ehrlichkeit haengt am Stempel, nicht am Enum.

**B-5: Wo die Stempel hin koennen, ohne Schema-Bruch.**
`kV3AxisSchema[5]` (memory_layout) ist heute
`{"scan","records","field_bytes","cache_lines","checksum", nullptr, nullptr, nullptr}`
(`libs/cache_engine/anatomy/observable_tier.hpp:80`) -- **die Slots 5, 6, 7 sind frei**. Ein
zusaetzliches Feld `line_bytes` in Slot 5 waere layout-neutral und sizeof-neutral (genau das
Vorgehen, das bei T2/Slot 6 bereits dokumentiert praktiziert wurde, `observable_tier.hpp:77`).
ACHTUNG, nicht als kostenlos verkaufen: es gibt einen `contract:axis-version-lock`-Job und eine
Byte-Wache; die Namensvergabe ist ein Schema-Ereignis und braucht den zugehoerigen
Versions-/Wachen-Nachzug. Das ist ein bekannter, beherrschter Vorgang, aber er ist nicht null.

---

## 4. KONSEQUENZ FUER DIE MESSUNG -- DER EHRLICHE TEIL

### 4.1 Was misst `line=128` auf einer 64-Byte-Maschine wirklich?

Es ist **keine Phantom-Achse, aber auch keine Hardware-Line-Messung.** Die Trennung verlaeuft
entlang der DREI Dimensionen der Achse, und sie ist fuer jede Dimension anders:

**`alignment` (none / cacheline_aligned / padded) bei `line_size=128`: ECHTE, gueltige, sogar
literaturgestuetzte Messung.** `alignas(128)` auf einer 64-B-Maschine bedeutet: Objekte beginnen
auf jeder zweiten realen Line, Padding gegen False Sharing spannt zwei reale Lines. Das ist kein
Kunstgriff, sondern gaengige Praxis -- Folly nutzt auf x86-64 bewusst 128 Byte fuer
`cacheline_align`, weil der Adjacent-Line-Prefetcher Paare von 64-B-Lines zieht und
False-Sharing-Schutz deshalb ueber 128 Byte gehen muss. Was hier gemessen wird, ist ein Trade-off,
den die Arbeit ohnehin untersuchen will: **weniger Kontention gegen mehr Speicher-Footprint,
schlechtere Line-Fuellung und hoeheren dTLB-Druck.** Diese Zeilen gehoeren in die Auswertung.

**`sw_hint` (T0/T1/T2/NTA): vollstaendig hardware-unabhaengig gueltig.** Die Hints sind
Locality-Hinweise an den Prefetch-Pfad und haben mit der Line-Groesse nichts zu tun. Keine
Einschraenkung.

**`line_size` als ZAEHL-Einheit (die CLU-Quelle): hier und nur hier wird es zur Phantom-Groesse.**
`axis_04_node_type_layout_aware_store.hpp:570-600` markiert beruehrte "Linien" ueber
`byte_offset / kLineBytes`. Bei `kLineBytes=128` auf einer 64-B-Maschine zaehlt der Store genau
halb so viele "Linien" wie die Hardware real beruehrt. Der Zaehler wird damit vom Messwert zum
MODELLWERT -- er beantwortet die Frage "wie viele 128-B-Bloecke haette ich beruehrt", nicht "wie
viele Cache-Lines habe ich beruehrt". Das ist verteidigbar, solange man es SAGT.

### 4.2 Was das fuer die CLU-Metrik heisst (die B14-Kette)

Der aktive Konsument steht in
`libs/cache_engine/include/cache_engine/measurement/system_axis.hpp:325-337`:

```
case MeasurementCategory::CLU: {
    std::uint64_t const field_bytes = snapshot->axis_stats[5][2];
    std::uint64_t const cache_lines = snapshot->axis_stats[5][3];
    ...
    sample.mark_ok((field_bytes * 100u) / (cache_lines * 64u));   // Zeile 336: LITERAL 64
```

Hier laufen zwei UNTERSCHIEDLICHE Fehler zusammen, die man nicht verwechseln darf -- und genau
diese Verwechslung ist der Grund, warum B14 zu Recht nicht gelandet ist:

**Fehler 1 (reiner Kopplungs-Defekt, unabhaengig von Hardware):** Erzeuger und Verbraucher
rechnen mit verschiedenen Einheiten. Der Erzeuger zaehlt in `kLineBytes` (Achse), der Verbraucher
teilt durch das Literal 64. Solange alles am Default B64 steht, faellt das nicht auf -- das ist
der einzige Grund, warum die Kette heute korrekte Werte liefert. Sobald KF-6 die NTTP-Emission
scharfstellt, produziert derselbe Code stillschweigend Werte um Faktor 2/4/0.5 daneben. Der
B14-Fix (Literal ersetzen durch die Achsen-Groesse) ist fuer DIESEN Fehler richtig.

**Fehler 2 (der Grund, warum Fix 1 allein nicht reicht):** Selbst nach dem Kopplungs-Fix ist
CLU bei `assumed != host` keine Cache-Line-Auslastung mehr, sondern eine Block-Auslastung in einer
fiktiven Blockgroesse. Bei `line=128` auf 64-B-Hardware waere die "CLU" formal konsistent
gerechnet und trotzdem physikalisch falsch etikettiert: die Hardware hat doppelt so viele echte
Lines angefasst, wie die Zahl unterstellt. Wer nur Fehler 1 heilt, ersetzt einen sichtbaren
Rechenfehler durch einen unsichtbaren Bedeutungsfehler -- das ist die schlechtere Lage.

**Der saubere Zustand ist deshalb dreiteilig, und alle drei Teile gehoeren in DASSELBE Gate:**

1. **Einheiten-Kopplung schliessen:** der Nenner kommt aus derselben Quelle wie der Zaehler.
   Sauberste Form: der Erzeuger legt seine `kLineBytes` in den Snapshot (freier Slot
   `axis_stats[5][5]`, `observable_tier.hpp:80`), der Verbraucher liest sie dort -- kein zweiter
   Kanal, keine Annahme, kein Literal. Das ist zugleich die Heilung des ledger-gefuehrten
   Aufraeum-Postens `measure.hpp:38` (`ctx.cache_lines_used += used_bytes / 64;` -- dasselbe
   Literal, zweite Stelle).
2. **Fail-closed bei fehlender Quelle:** liefert der Snapshot kein `line_bytes` (alte Binary,
   Achse nicht getragen), dann `mark_source_unavailable()` -- nicht auf 64 zurueckfallen. Die
   Mechanik steht schon direkt daneben (`system_axis.hpp:330-334`) und ist damit kein Neubau.
3. **Ehrliche Etikettierung:** die CSV-Zeile traegt `cacheline_assumed_bytes` und
   `cacheline_host_bytes` (aus B-1/B-2). Ist `assumed != host`, ist CLU ein MODELLWERT.

### 4.3 Wie die Thesis das benennen sollte

Vorschlag fuer die Formulierung, die die Arbeit ehrlich UND stark macht -- nicht defensiv, sondern
als praezisierte Beitragsaussage:

> Die Cache-Line-Groesse ist je Mikroarchitektur fest verdrahtet und zur Laufzeit auslesbar, aber
> nicht veraenderbar. Die Unterachse `cacheline` permutiert daher nicht die Hardware-Line, sondern
> die ANNAHME der uebersetzten Binary ueber sie: Alignment-, Padding- und Packing-Granularitaet
> sowie den Software-Prefetch-Hint. Faellt die Annahme mit der erhobenen Hardware-Line zusammen,
> ist die gemessene Cache-Line-Auslastung hardware-wahr; weicht sie ab, misst der Lauf den
> Ueber- bzw. Unter-Alignment-Effekt (Footprint, dTLB-Druck, False-Sharing-Distanz) und die
> Auslastungskennzahl ist als Modellwert in der angenommenen Blockgroesse zu lesen. Beide Zahlen
> reisen deshalb je Messzeile mit: die angenommene und die erhobene Line-Groesse.

Das deckt sich mit dem, was in `kapitel/de/02_fundamentals.tex:31-46` bereits korrekt steht, und
es macht `anhang/de/D_building_block_matrix.tex` (CacheLineSize-Zeile, heute "Runtime-Parameter"
unter "Dynamische Sub-Achsen") zu einer einzeiligen Korrektur statt zu einem Widerspruch.
Der eigentliche Neuheits-Satz bleibt unangetastet und wird sogar schaerfer: **die Automatisierung
liegt in der ERHEBUNG je ISA x OS und der daraus abgeleiteten Uebersetzung, nicht in einer
Verstellung der Hardware.**

---

## 5. EMPFEHLUNG -- OPTIONEN FUER DEN OWNER

Rahmenbedingungen, die ich bewusst mitgewichte: Abgabe **Fr 08.08.**, Trigger-Ziel **Do 07.08.**;
`cacheline` ist **nicht** Teil des laufenden golden-Korpus (`all_axes_golden.profile.xml` fuehrt
`cacheline` nicht unter `permute_axes`; `experiment_golden.xml` / `experiment_golden_kern.xml`
ebenfalls nicht -- selbst geprueft, 0 Treffer); die Achse dringt heute wegen der fehlenden
NTTP-Emission gar nicht bis zur Tier-Binary durch. **Der Zeitdruck trifft diese Frage also NICHT
im kritischen Pfad der Messung.** Das ist der entscheidende Umstand fuer die Wahl.

### Option 1 -- NUR DIE WAHRHEIT (Doku + Stempel-Nachzug), ca. 1-2 h

Kein Achsen-Umbau. Es wird korrigiert, was heute eine Zusage macht, die der Code nicht haelt:
`D_building_block_matrix.tex` (CacheLineSize-Zeile: "Runtime-Parameter" -> "Uebersetzungs-Parameter;
die Hardware-Line ist auslesbar, nicht setzbar"); der Achsen-Header bekommt einen expliziten
Abgrenzungs-Satz (permutiert (d), nicht (a)); die erhobene Host-Line wird -- da sie in
`provenance_manifest.hpp:67,89` ohnehin schon geschrieben wird -- im Bericht sichtbar gemacht.

- **Konsequenz:** Die Arbeit ist ehrlich, kein Messwert aendert sich, kein golden-Lauf beruehrt.
  Die Freigabe-Luecke bleibt bestehen -- aber sie ist heute nicht scharf.
- **Risiko:** Wenn KF-6 nach der Abgabe nachgeruestet wird, ohne dass jemand diese Notiz liest,
  entsteht genau der stille Bedeutungsfehler aus 4.2. Gegenmassnahme: Ledger-Posten mit
  Sperrvermerk "KF-6 NICHT ohne B-1..B-3".

### Option 2 -- WAHRHEIT + DIE EINE NAHT, DIE B14 BRAUCHT, ca. 3-5 h

Option 1 PLUS der dreiteilige CLU-Fix aus 4.2 (Einheiten-Kopplung ueber Snapshot-Slot,
fail-closed, Stempel `assumed`/`host`) PLUS die Sonde B-1 unter der bestehenden
`hardware_probe_factory`-Zelle und das Praedikat B-3 mit `LineSupport`. Die
`DeclaredMachine`-Erweiterung B-2 ist additiv und billig.

- **Konsequenz:** B14 kann landen, OHNE den vom ce-Codex korrekt erkannten Folgeschaden (neue
  falsche Werte statt alter falscher Kopplung). Die Freigabe-Naht existiert danach fuer cacheline
  genauso wie fuer ISA, und KF-6 waere danach gefahrlos nachruestbar.
- **Aufwand/Risiko:** Der Snapshot-Slot ist frei (`observable_tier.hpp:80`, Slots 5-7), aber die
  Namensvergabe ist ein Schema-Ereignis -> `contract:axis-version-lock` + Byte-Wache muessen
  nachgezogen werden, und dieser Job ist laut Ledger derzeit ohnehin auffaellig (doppelt definiert).
  Das ist der einzige echte Zeitfresser in dieser Option.

### Option 3 -- VOLLE FREIGABE-KETTE inkl. Bau-Filter, > 1 Tag

Option 2 PLUS: Planer-Annotation `host_line_exact` je Permutation (Spiegel von
`experiment_plan_director.hpp:2064`), `<require axis="cacheline" host_supported="..."/>` im
Profil-Schema tatsaechlich implementiert, neue Fehlerklasse `HardwareAnnahmeAbweichend`, ARM64-/
Windows-/macOS-Zellen der Sonde, und KF-6-NTTP-Emission.

- **Konsequenz:** Das architektonische Zielbild ist vollstaendig.
- **Bewertung:** **Vor der Abgabe klar abzulehnen.** Es beruehrt Planer, Profil-Schema,
  Fehlerklassen-Enum (das laut `axis_error.hpp:63-64` in Logs reist) und den Codegen gleichzeitig
  -- vier Gates in einem Fenster, in dem der golden-Lauf getriggert werden soll, fuer eine Achse,
  die im golden-Korpus gar nicht vorkommt.

### MEINE EMPFEHLUNG

**Option 2 -- aber in zwei getrennten Landungen, und die Reihenfolge ist wichtig.**

1. **SOFORT (heute, golden-neutral, kein Schema-Ereignis):** der Doku-/Wahrheits-Teil aus Option 1.
   Er kostet fast nichts, er beruehrt keinen Messwert, und er beseitigt die einzige Stelle, an der
   die Arbeit eine Zusage macht, die der Code nicht haelt. Nach der Doktrin "keine Zusage, die der
   Code nicht haelt" hat dieser Teil Vorrang vor allem anderen in diesem Dokument.
2. **IM B14-FENSTER (nicht davor, nicht daneben):** der dreiteilige CLU-Fix plus Sonde plus
   Praedikat. Begruendung fuer die Kopplung an B14: der ce-Codex hat B14 genau deshalb zu Recht
   abgelehnt, weil der `/64`-Konsument nach dem Fix neue falsche Werte erzeugt haette --
   Abschnitt 4.2 zeigt, dass der fehlende dritte Teil (Stempel + fail-closed) exakt die Luecke
   ist, die das Verdikt meint. Diese Teile in ZWEI Gates zu legen, wuerde denselben Fehler ein
   zweites Mal machen.
3. **NACH DER ABGABE:** Option 3, gemeinsam mit KF-6 / Posten 62. **Mit Sperrvermerk im Ledger:
   KF-6 darf nicht ohne B-1..B-3 landen** -- sonst baut das Projekt Binaries mit einer
   Hardware-Annahme, der niemand widerspricht.

Zur Owner-Doktrin "HW-Werte nie statisch, Laufzeit-Factory ISA x OS": sie ist hier **nicht
abgeschwaecht, sondern bestaetigt**. Dass die Line-Groesse fest ist, ist kein Argument fuer eine
Konstante im Code -- sie ist je Maschine verschieden (32/64/128/256 real belegt), also muss sie
erhoben werden. Der einzige Unterschied zu RAM-Frequenz oder SIMD-Signatur ist, dass niemand sie
verstellen kann; erhoben werden muss sie genauso. Das heutige `kDefaultLineBytes = 64`
(`cacheline_line_bytes.hpp:37-38`) ist unter dieser Doktrin ein legitimer ACHSEN-Default (die
Achse darf einen Default haben), aber es waere unter derselben Doktrin ein Fehler, ihn als
HARDWARE-Aussage zu benutzen -- und genau das tut `system_axis.hpp:336` heute mit seinem
Literal 64.

---

## ANHANG A -- Geprueft am Objekt (Auswahl, alle selbst verifiziert 06.08.2026)

Repo-Wurzel: `Code/external/comdare-cache-engine`, Branch `development`, HEAD `3bbcb8ed`.

| Anker | Aussage |
|---|---|
| `libs/cache_engine/axes/cacheline/cacheline_config.hpp:16` | "line_size -> alignas/Packing-Granularitaet" -- die Achse sagt selbst, dass sie (d) ist |
| `.../cacheline_config.hpp:35` | `CacheLineSize {B32,B64,B128,B256}` |
| `.../cacheline_config.hpp:40-46` | `CacheLineConfig`, NTTP-Default `line_size = B64` |
| `.../cacheline_config.hpp:51-54` | `alignment_bytes()` -- einzige semantische Auswertung von `line_size` |
| `.../cacheline_config.hpp:57-78` | `prefetch<Hint>()` -- `_mm_prefetch`/`__builtin_prefetch`, `if constexpr` |
| `.../cacheline_config.hpp:99-132` | `all_configs()` (60), `make_config()` -- 0 Produktions-Aufrufer |
| `.../cacheline_line_bytes.hpp:16-20` | KF-6-NAHT: Codegen emittiert die per-Organ-Config NICHT als NTTP |
| `.../cacheline_line_bytes.hpp:37-38` | `kDefaultLineBytes == 64` + `static_assert` |
| `.../cacheline_line_bytes.hpp:53-61` | `line_bytes_of<T>()` dreistufig, rein `constexpr` |
| `libs/cache_engine/axes/node/axis_04_node_type_layout_aware_store.hpp:570-600` | Linien-Zaehlung ueber `b / kLineBytes` -- Modell in der eingestellten Granularitaet |
| `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp:325-337` | CLU-Konsument, **Literal 64 in Zeile 336** |
| `libs/cache_engine/include/cache_engine/measurement/measure.hpp:38` | zweite `/64`-Stelle (`cache_lines_used += used_bytes / 64`) |
| `libs/cache_engine/anatomy/observable_tier.hpp:80` | `kV3AxisSchema[5]` -- Slots 5,6,7 frei |
| `libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp:174-189` | CPUID Leaf 1 -> `cache_line_bytes`; Apple-Silicon 128 |
| `.../platform_probe/sysfs_cache_probe.hpp:74` | `coherency_line_size` aus sysfs |
| `.../platform_probe/cpuid_platform_probe.hpp:45-49` | Quellenkette, Ergebnis -> `measured_metrics["cache_line_bytes"]` |
| `libs/cache_engine/builder/provenance_manifest.hpp:67,89` | einziger Produktions-Konsument der Host-Line (Provenienz, kein Gate) |
| `libs/cache_engine/include/cache_engine/measurement/machine_identity.hpp:164-178` | `DeclaredMachine` -- KEIN `cache_line_bytes` |
| `libs/cache_engine/include/cache_engine/measurement/hardware_probe_factory.hpp:1-6,34-40` | CT-Factory ISA x OS, "die EINE memoisierte Erhebung an der CEB-Freigabe-Naht", 2 Erhebungen haengen dran |
| `libs/cache_engine/profile_facade/profile_run_entry.hpp:245-267` | `system_axis_host_supports_simd()` -- das Muster fuer B-3 |
| `libs/cache_engine/profile_facade/experiment_run_entry.hpp:293-297` | ehrliches Ueberspringen mit Fehlerklasse |
| `libs/cache_engine/profile_facade/gn_cell_filter.hpp:37-47` | freistehend testbares Gate-Praedikat |
| `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:173,2064` | Planer ANNOTIERT statt zu filtern |
| `libs/cache_engine/include/cache_engine/measurement/axis_error.hpp:42,63-64` | `HardwareErweiterungFehlt`; RF-3-Auflage "Klassen ANHAENGEN" |
| `apps/catalog_codegen_tool/main.cpp:183-190` | `cacheline` in `permute_axes` wird HART abgelehnt |
| `libs/cache_engine/algorithm_profiles/thesis_profiles/cacheline_study.profile.xml:74-87,126` | einziger Ort mit `line_size`-Werten; `host_supported` nur fuer `isa` |
| `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` | `cacheline` NICHT enthalten (0 Treffer) |
| `docs/sessions/20260602-cacheline-konfigurator-design-und-hw-recherche.md:70-100` | Projekt-HW-Recherche 06/2026: x86/Zen "64 B (fix)", nur Prefetcher-MSR einstellbar |

Thesis-Repo `/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit`:

| Anker | Aussage |
|---|---|
| `kapitel/de/02_fundamentals.tex:31-46` | bereits KORREKT: auslesbar via CPUID/CTR_EL0/riscv_hwprobe, "sie aber nicht veraendern" |
| `kapitel/de/02_fundamentals.tex:14` | Owner-Randnotiz (auskommentiert) mit der Annahme "dynamisch anpassbar" -- durch die Recherche widerlegt |
| `anhang/de/D_building_block_matrix.tex` (CacheLineSize-Zeile, Abschnitt "Dynamische Sub-Achsen") | "Runtime-Parameter" + "zur Compile-Time gewaehlt" -- die eine Stelle, die zu korrigieren ist |

## ANHANG B -- Hardware-Quellen

Selbst erhoben auf `prod1` (06.08.2026): `getconf LEVEL{1_DCACHE,2_CACHE,3_CACHE}_LINESIZE` = 64/64/64;
`/sys/devices/system/cpu/cpu0/cache/index{0,1,2,3}/coherency_line_size` = 64/64/64/64; `lscpu -C`
(COHERENCY-SIZE 64 auf L1d/L1i/L2/L3, L3 ONE-SIZE 96M vs ALL-SIZE 128M); `/proc/cpuinfo` model name
AMD Ryzen 9 9950X3D; Kernel 6.17.0-35-generic.

Aus der parallelen HW-Recherche dieses Fensters uebernommen (dort literal belegt, von mir nicht
nachgemessen): `sysconf(_SC_LEVEL*_*CACHE_LINESIZE)` = 64 (glibc liest auf x86 via CPUID, eigener
Weg); CPUID.01H EBX[15:8] = 8 -> 64 B; CPUID.80000005H/80000006H (AMD L1/L2/L3) je `line_size=64`;
CPUID.8000001DH sub=3 auf cpu0 = 98304 Sets (96 MiB) vs. cpu24 = 32768 Sets (32 MiB), `line_size`
auf beiden CCDs 64 (asymmetrischer 3D-V-Cache).

Dokumentation / Literatur:
- Intel SDM, `CPUID`-Beschreibung: Leaf 01H EBX[15:8] "CLFLUSH line size (Value * 8 = cache line size
  in bytes)"; Leaf 04H EBX[11:0] "L = System Coherency Line Size", EBX[21:12] Partitions,
  EBX[31:22] Ways, ECX Sets. Online-Spiegel: felixcloutier.com/x86/cpuid
- AMD64 Architecture Programmer's Manual / PPR: `CPUID Fn8000_001D_EBX` mit identischer
  Bitaufteilung (Line/Partitions/Ways)
- ARM Architecture Reference Manual, `CTR_EL0` (Cache Type Register): `IminLine`, `DminLine`, `CWG`
  (Cache Writeback Granule), `ERG` (Exclusives Reservation Granule);
  developer.arm.com -> AArch64-Registers/CTR-EL0
- Microsoft Learn, `CACHE_RELATIONSHIP.LineSize` (via `GetLogicalProcessorInformationEx`,
  `RelationCache`)
- Intel SDM Table 2-20 / MSR `0x1A4` MISC_FEATURE_CONTROL, Bits 0-3 (L2 Streamer, L2 Adjacent-Line,
  DCU Next-Line, DCU-IP); BIOS-Beschreibung "Adjacent Cache Line Prefetch ... within a 128-byte
  sector" (SPEC-Flag-Beschreibung NEC/Intel)
- AMD Prefetch-Konfiguration: MSR-Region `0xC0011020-0xC001102B` (DC/L2 Prefetch Config) --
  im Projekt bereits notiert in `docs/sessions/20260602-...:75`
- Apple: `sysctl hw.cachelinesize` = 128 auf M1 und Nachfolgern (7-cpu.com/cpu/Apple_M1.html)
- Historische Gegenbeispiele: Pentium III 32-B-L1-Line; Pentium 4 NetBurst 128-B-L2-Line in zwei
  64-B-Sektoren (sektorierter Cache -- der Fall, in dem (a) und (c) zusammenfallen)
- Folly (facebook/folly), `cacheline_align` = 128 Byte auf x86-64 wegen des
  Adjacent-Line-Prefetchers -- Beleg dafuer, dass 128-B-Padding auf 64-B-Hardware gaengige,
  begruendete Praxis ist (relevant fuer Abschnitt 4.1)

<!-- Selbstcheck: ASCII-only geprueft (keine Umlaute/Sonderzeichen ausserhalb 0x20-0x7E im
     Fliesstext); alle Projekt-Anker per Read/Grep am Objekt verifiziert, HEAD 3bbcb8ed; alle
     Host-Werte in Abschnitt 1c selbst ausgefuehrt; fremd uebernommene HW-Werte als solche
     markiert; kein Commit, keine Code-Aenderung. -->
