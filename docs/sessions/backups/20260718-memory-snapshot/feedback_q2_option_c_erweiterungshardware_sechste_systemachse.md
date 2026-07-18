---
name: feedback_q2_option_c_erweiterungshardware_sechste_systemachse
description: "Q2-Ruling (User 2026-07-17): Option C + Erweiterungshardware (SIMD, später GPU) = eigene 6. System-Achse; die CEB permutiert simd_extension SELBST zur Laufzeit und baut Tier-Binaries compile-time damit; Flags an der CompileFn-Naht, Provenienz im H-10-Sidecar, NIE in der binary_id"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Q2-Ruling (User 2026-07-17, verbatim): „**Option C: Die CEB bekommt die Einstellungen vom Experiment-Planer, aber Permutiert etwa simd_extension selbst für die Systemachse zu seiner Laufzeit durch, um Tier-Binaries zur compile time mit diesen Eigenschaften auszustatten und durchzumessen. Daher sind die Systemachse der Erweiterungshardware (SIMD, GPU) eine weitere eigene Systemachse, die erstmal nur auf SIMD ausgedehnt wird. GO für den Bau**"

**Die CEB-System-Achsen sind damit SECHS:** (1) Scheduling (compile-time-CRTP #37) · (2) Hardware/ISA (Host-Deskriptor + Mess-Gate „Binary-ISA ⊆ Host-Capability") · (3) Telemetrie · (4) Last + Last-Frameworks · (5) Compiler (gcc|clang, Planer baut mit beiden, ≤5%-Vergleich) · (6) **Erweiterungshardware (SIMD → später GPU)**: die `-march`/`-mavx`-/SIMD-Extension-**Politik**; Ausprägungen werden von der **CEB zur Laufzeit selbst permutiert** (Werte-Rahmen kommt als Einstellung vom Experiment-Planer über das eindimensionale Experiment-Dock), je Ausprägung baut die CEB die Tier-Binaries **compile-time** mit den Flags aus und misst durch.

**Why:** löst die H-7-„-march-Aufhängungs"-Frage nach Option C: WERT-Quelle = Erweiterungshardware-System-Achse (CEB-laufzeit-permutiert), ORT = die injizierte `CompileFn`-Naht (`make_gpp_compile_fn`), UNTERSCHEIDBARKEIT = H-10-Sidecar-Provenienz (neue Metadaten-Version in INC-2) — **NIE in der binary_id** (golden==320 bleibt; 09b bleibt deklarative Build-Achse).

**How to apply:** In Bau-INC-1d/1h: `ExtensionHardwareSystemAxis` als 6. `CebSystemAxis<Derived>`-Ableitung (zunächst nur SIMD-Ausprägungen); ihre Werte erzeugen die `-march`-Flag-Sätze, die per Extra-Flags-Kanal (Muster `COMDARE_FACADE_PERM_EXTRA_CFLAGS`/`link_libs`) in den Laufzeit-g++-Perm-Bau fließen; je Compiler getrennt geführt (`-march=native`-Defaults differieren = Quelle des 5%-Vergleichs); Sidecar dokumentiert die aktive Belegung. GPU = spätere Ausdehnung derselben Achse. Siehe [[feedback_recursive_dock_planer_ceb_tier_abi_stable_so]], [[feedback_q1_axis_dach]] (falls angelegt), [[feedback_system_axes_measurement_own_abstract_root_blood]].
