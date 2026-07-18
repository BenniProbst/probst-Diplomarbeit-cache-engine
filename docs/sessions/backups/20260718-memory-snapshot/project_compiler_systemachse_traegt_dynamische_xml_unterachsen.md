---
name: project_compiler_systemachse_traegt_dynamische_xml_unterachsen
description: "Compiler-System-Haupt-Achse trägt dynamische XML-Unterachsen (Opt/Flags/Commands je Compiler); in einem dynamischen XML-System existiert kein \"global\""
metadata: 
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**Architektur-Klärung (User-Ruling 2026-07-17, korrigiert meine falsche F1-Empfehlung):** Die
**Compiler-System-Haupt-Achse** (die 5. CEB-System-Achse aus INC-1h, gcc|clang) ist die **TRÄGERIN
dynamischer Unterachsen je Compiler**: Optimierungsstufe (O0…Ofast), Flags und Commands (je Compiler
VERSCHIEDEN) werden als Unterachsen darunter verwahrt und **permutiert**, um unterschiedliche
Tier-Binaries über diese Achse zu erzeugen. Die Optimierungsstufe ist KEINE dedizierte Geschwister-Achse
(mein falscher Bauplan-Vorschlag INC-2c.opt §2/F1) — sie lebt als **dynamische Unterachse UNTER der
Compiler-Achse**. Zusätzliche Unterachsen forcieren maximale Hardware-Erweiterungs-Nutzung (SIMD/AVX →
**deep research** über Hardware-Erweiterungen gefordert). Voll {O0,O1,O2,O3,Ofast}, nicht minimal {O2,O3}.

**PRINZIP (F3, kategorial):** In einem **dynamischen, XML-getriebenen System existiert „global" NICHT**.
ALLES ist eine **per XML konfigurierbare Achse mit XML-konfigurierbaren Unterachsen** (der Experiment-Planer
permutiert die Achsen → Tier-Binaries; E4-XML→E3-Permutation→E2-Binary). Nicht in statischen CMake-Flags /
hartkodierten CompileFn-Nähten denken — das war mein Kernfehler.

**Why:** Meine INC-2c.opt-Planung (wf_abf79fd6) verortete die Optimierungsstufe als dedizierte
Geschwister-Achse und stellte einen „global vs. per-Ausprägung"-Fork — beides architektonisch falsch
(falsche Achsen-Ebene + statisch statt dynamisch gedacht). Der User bewertete das Verständnis als schlecht.

**How to apply:** Bei INC-2c.opt (und jeder Compile-Flag-/Optimierungs-/SIMD-Arbeit): die Compiler-Achse
als Trägerin dynamischer XML-Unterachsen modellieren, alles XML-konfigurierbar, nichts „global"/hartkodiert.
Vor Bau: ultracode-Neuplanung gegen die XML-Experiment-Planer-Achsen-Architektur + deep research
Hardware-Erweiterungen. Siehe [[feedback_q2_option_c_erweiterungshardware_sechste_systemachse]],
[[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]],
[[feedback_unified_experiment_xml_plus_system_registry_xml]].

**PRÄZISIERUNG (OF-1/2/3-Rulings 2026-07-17):** Die **Compiler-Haupt-Achse** trägt **parallele** dynamische
XML-Unterachsen: `opt_level` (voll {O0..Ofast}) · `flags`/`cflags` · `commands` · **CPU-Erweiterungen
(SIMD/AVX)**. **OF-1:** Die bisherige eigenständige `extension_hardware`-Achse (Q2-C) wird aufgeteilt —
CPU-SIMD/AVX **wandert als Compiler-Unterachse** (Fold-in), während **GPU/FPGA/externe Beschleuniger ein
System-Hauptachsen-ARRAY dynamischer Größe** werden (EINE Achse je Gerät). **OF-2:** **NICHTS ist gepinnt,
JEDES Teil ist beweglich** — CEB-**Default = Ofast** (nicht -O2!), per XML überschreibbar; volle
Optimierungs-Permutation gegeneinander als XML-Experiment-Bestandteil, Einstellungen in **ranges/batches
oder einzeln**. (⇒ die frühere „Byte-Identität-Default-O2"-Annahme ist HINFÄLLIG.) **OF-3:** `commands` +
`flags`/`cflags` als **parallele Unterachsen** unter derselben Compiler-Haupt-Achse; Start mit flags/cflags,
commands folgt.
