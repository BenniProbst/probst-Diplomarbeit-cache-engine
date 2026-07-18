---
name: feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake
description: "Mess-Verfahren — Debug-Modus parallel über alle Threads, Mess-Modus 1 Mess-Thread (Gattungs-Threading aus Tier-Binary); Messung NIE als Nullen abschalten; perf auf beiden prod; Experiment-Planer generiert aus XML den CI- ODER cmake-Ausführungscode"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Mess-Verfahren (User 2026-07-16, beantwortet Fork B / verfeinert „CI-Grün = Messung AUS"). prod2-Ausfall behoben → Messung wieder einschaltbar; perf-basierte Messung jetzt auf **BEIDEN** prod-Clustern verfügbar.

- **Debug-Modus:** so viele Messungen **PARALLEL** wie die Maschine Threads hat (schnell — beschleunigt die mehrtägigen Läufe; für Verifikation/Coverage).
- **Mess-Modus:** **NUR EIN Thread misst**; das Threading der Gattung ist sonst den Einstellungen der **Tier-Binary** auferlegt (NICHT vom Harness überschrieben).
- **Messung wird NIE als „Nicht-Messen" verworfen** — sonst nur Nullen, keine Ergebnisse erkennbar. Also KEINE zeros-only/nicht-messende Ersatz-Abdeckung; die echte Messung läuft (im Debug schnell-parallel). Der reguläre Default-CI-Grün-Lauf bleibt opt-in-getrennt (measure:golden-320), aber wenn gemessen wird, wird ECHT gemessen.
- **Experiment-Planer generiert aus der XML den CI-Code ODER den cmake-Code** für die Ausführung der Folge-Schritte des Experiments. CI-Modus + lokaler cmake-Modus sind **SYNCHRON geplant** — in beiden Fällen erzeugt der Planer den Ausführungs-Code aus DERSELBEN XML. Verbindet F6 (XML steuert die CI dynamisch über einen Interpreter) + die versteckte-root-Minimal-Binary-Planer-Mechanik ([[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]]).

**Why:** bestimmt den Mess-/CI-/cmake-Ausführungs-Ablauf und ist 28.07.-Deadline-kritisch (CI UND standalone messfähig).

**How to apply:** das CI-Verfahren + der lokale cmake-Weg werden aktualisiert, sodass der Experiment-Planer aus der XML den jeweiligen Ausführungs-Code generiert (Debug=alle-Threads-parallel, Mess=1-Mess-Thread + Gattungs-Threading aus der Tier-Binary). Verfeinert [[feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert]]; siehe [[project_mess_ergebnis_rueckschreibung_pipeline_persistiert]] (Rückschrieb) + [[feedback_prod_ci_measurement_multiday_experiment]] (mehrtägig, nie pollen).

**NACHTRAG (User 2026-07-17, Aufbau-Phase):** „du darfst mit 8 Threads bauen und mit allen 24 Threads im Debug mode parallel Messungen durchführen, solange wir das System aufbauen und noch nicht ‚echt' messen." ⇒ Builds `-j8`; Aufbau-/Smoke-Messungen dürfen debug-parallel über alle 24 Threads laufen (der kommende Debug/Mess-Schalter-Strang setzt 24 als Debug-Default); echte Messläufe bleiben strikt 1-Thread/Maschine.
