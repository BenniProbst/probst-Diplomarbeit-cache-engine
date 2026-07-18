---
name: feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen
description: "Fehlerklassen + Behandlung sind PFLICHT für alle Achsen → Unterachsen → Algorithmen; Hardware-/Compile-Fehlen (z.B. AVX512) = klassifizierter Experiment-Planer Compiler-Compiler-Fehler im Log, kein Absturz"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive (2026-07-17, verbatim-treu):** „Das Problem [SIMD/AVX512-Configure-Fehler] ist ein
**Klassiker für einen Experiment-XML-compile Fehler** und muss als **Experiment-Planer Compiler-Compiler
Fehler im Log deklariert werden** … uns [fehlen] die Fehlerklassifizierungen, um das Fehlen von etwa
AVX512 zu erkennen (**Fehlerklassen und Behandlung sind für alle Achsen → Unterachsen → Algorithmen
Pflicht**)."

**Why:** Ein fehlendes Hardware-Feature (AVX512 auf einem Host ohne AVX512, GPU/FPGA fehlt) oder eine
inkompatible Achsen-Kombination ist ein **erkennbarer, klassifizierbarer Zustand** — KEIN Absturz. Heute
riss genau so ein Fall (COMDARE_HOST_RUNS_AVX512F leer → CMake-Arity-Crash) die ganze CI-Pipeline, statt
als deklarierter Fehler im Log zu erscheinen und das Experiment weiterlaufen zu lassen. Der Experiment-Planer
ist ein **Compiler-Compiler** (er erzeugt Compile-Kommandos je Achsen-Permutation für die Tier-Binaries);
er MUSS die Fehlerklassen kennen und je Permutation die passende erkennen/loggen, statt hart abzubrechen.
Erweitert [[feedback_measurement_failure_visibility_csv_failed_not_null_plus_log]] („failed"+Log statt null,
Harness misst weiter) von der Runtime- auf die **Planer-/Compile-Ebene** (Compiler-Compiler-Fehlerklasse).

**How to apply:** JEDE Achse (System/Organ/Gattung), JEDE Unterachse (z.B. Compiler ⊃ opt/flags/commands/
CPU-SIMD; siehe [[project_compiler_systemachse_traegt_dynamische_xml_unterachsen]]) und JEDER Algorithmus
(Strategie-Ausprägung) braucht eine **deklarierte Fehlerklasse + Behandlung**. Drei Ebenen: (a) Hardware-/
Erweiterungs-Fehlen → Compiler-Compiler-Fehler-Klasse, im Log deklariert, Experiment misst weiter; (b) Compile-
Fehler einer Achsen-Kombination (ISA-Inkompatibilität, Compiler-Dialekt); (c) Runtime-Algo-Fehler. Nie hart
abbrechen, wo ein klassifizierter Fehler + Weitermessen möglich ist. Der SIMD-Quoting-Fix (ce `355faa7f`) war
die Sofort-Härtung; die eigentliche Lösung ist das **Fehlerklassifizierungs-Framework** (Folge-Task), das mit
den INC-2c.opt-Compiler-/SIMD-Unterachsen zusammengebaut wird.
