# LENS topologie-vertraege — Binary-Topologie der Kette + kanonische Vertrags-Namen

> READ-ONLY-Nachschlag im Plan-Korpus, 2026-08-05. Anlass: Owner-Atlas-Review Runde 3 (Ledger mittag-3).
> Quellen (alle gelesen): Memories `feedback_recursive_dock_planer_ceb_tier_abi_stable_so.md`, `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md`, `feedback_ceb_drei_modi_arbeitsmodus_hot_tier_switching.md`, `project_post_v3_anforderungen_so_abi_driver_split_cli.md` · super-Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§30 :2249-2266, §38/§38.b :2360-2380, §42/§42.b :2419-2432, Nachträge vormittag-3 :4014ff, vormittag-4, mittag-1, mittag-3 :4044ff) · Kette-Audit `docs/sessions/backups/20260805-planer-ceb-kette-audit/{soll,synthese,ist-ceb}.md`.

---

## 0. Owner-Anstoß (Ledger mittag-3, VERBATIM)

> "Wenn ich mir jetzt den Atlas nochmal anschaue gibt es immer noch das Problem, dass die L5 Heustik nicht optional zwischen der Binary L4 mit den Achsen-Organen liegt und selbst eine binary nach Plan darstellt. Die L2 CEB kapselt weiterhin L3 und L4, diese Layer sind IN der CEB eingebaut und das ist nicht erkennbar. Die Vertraege sind weiterhin nicht korrekt bezeichnet zwischen den Binaries. Die Uebersicht hilft mir und dir derzeit die Fehler in der Architektur zu erkennen."

Drei Defizite: (1) Heuristik = OPTIONALE EIGENE BINARY der Kette, (2) Binary-Topologie (welche Layer leben IN welcher Binary) fehlt, (3) kanonische Vertrags-NAMEN an den Kanten fehlen. Der Korpus-Befund unten deckt alle drei.

---

## A. BINARY-TOPOLOGIE der Kette (nach Plan)

### A.1 Die Kette: 3–4 Binaries, top-down sequentiell generiert

Ledger §30.6 (User-Entscheid 19.07., verbatim):
> "**3 bis 4 Binaries in EINER Kette**, die **vom Kopf bis Fuß top-down nacheinander in sequentieller Abhängigkeit, Steuerung und Ausrichtung GENERIERT werden**: Der **Planer bestimmt das Messsystem und kompiliert HART ein effizientes CEB** für dieses Messsystem → der **CEB kompiliert Tier-Binaries** mit den gewünschten Organ-Achsen → und der **CEB kann nach der Auswertung der Messung noch effizientere Heuristik-Hybrid-Tier-Binaries entwickeln, die ihrerseits echte Tier-Binaries delegiert durch CEB entwickeln und laden können** (rekursive Delegation …)"

Ledger §30.5: "**Planer = Mess-Achsen · CEB = System-Achsen · Tier-Binaries = Organ-Achsen** — **+ Hybrid-Einschub** einer weiteren generierten Binary in der Kette (**optional**)." — die 4. Binary ist EXPLIZIT optional.

Stufen-relative CT-Doktrin (§30-Einordnung): "jede Vorstufe friert die Wahl der Folgestufe als CT-Draht ein". Registry-Speisung 1:1 (§30-Einordnung): "**Mess-Registry→Planer · System-Registry→CEB · Organ-Registry(+prt)→Tier**".

Rekursives Muster (Memory feedback_recursive_dock, 17.07.): "= dasselbe Dock/ABI-stabile-.so/Vertrags-Muster REKURSIV (Planer→CEB gespiegelt zu CEB→Tier-Binary, geteilte Concepts)" — jede Ebene = C++23-ABI-stabile .so + Vertrag am Dock (R1-Interim s. B.1.4).

### A.2 Binary 1 — PLANER: Mess-Achsen + Resolver + CLI

- **Eigene Binary = HARTE Struktur-Pflicht** (Owner-KERN 05.08., verbatim-treu, project_post_v3:19): "Der Planer ist ZWINGEND eine eigene Binary mit dem User-CLI-Interface auf der Shell" — Abweichung = Regression. Owner-Antwort F1 (Ledger mittag-1, verbatim): "Definitiv vor Abgabe, weil sonst die Binaries aller Stufen nicht korrekt gebaut werden."
- **Inhalt/Layer IN der Planer-Binary:**
  - **Mess-Achsen-Träger** (§30.5: "Die Mess-Achsen-Permutation wandert von der CEB in den PLANER"); Mess-Achsen-Workload-Unter-Achsen permutiert der Planer zur Laufzeit gegen alle CEBs (§42.b).
  - **Resolver/Linker** gegen die 3 Achsen-Art-Registries (ANGEBOT) × Anwender-XML (ANZEIGE, .pom-Modell); Unregistriertes = harter Validierungsfehler (soll.md Glied 2, feedback_registry).
  - **Shell-CLI** (§60-R3): Subkommandos, loggt "Zustand/Builds/Messungen der CEB und der Tier-Binaries"; manuelles Fahren per XML-Config.
  - **Rück-Leser** (Owner F7, mittag-1 verbatim): "Ja klar, er ist eine eigene Binary und die CEB laeuft eigenstaendig, wie soll sonst der Planer dem User feedback ueber die zurueckgeschriebenen Messwerte und durch CEB kompilierten Tier-Binaries geben?"
  - **Versions-Stempel**: EINZIGE Binary mit EINEM X.Y.Z + ISA/OS-Deklaration, KEINE Achsen-Arrays ("der Planer permutiert, er ist keine Permutation", §43.b/§64 via soll.md 1.5).
  - GoF-Gestalt der CEB-Emission: Interpreter + ExperimentPlanDirector (EIN Walk) + ConcreteBuilder (CMakeGraph/CiYaml…), Codegen strikt Configure-/Pre-Build-Zeit (Bauplan Phase 1 via soll.md 3.3).
- IST-Abweichung (Audit synthese.md Glied 1, KOPF-REGRESSION): Planer heute nur Rolle im comdare-messung-driver (super main.cpp:552 "Planer- + CEB-Rolle in EINEM Binary"); Split = Bauwelle W1 mit F1-GO.

### A.3 Binary 2 — CEB (CacheEngineBuilder): System-Achsen-versionierte Bau-/Prüf-/Mess-Maschinerie, KAPSELT die nachgelagerten Schichten

- **Begriff** (Terminologie-KERN 05.08., feedback_kette:25 verbatim): "**CacheEngineBuilder == CEB**" — die Binary apps/cache_engine_builder IST die CEB (kein Schicht-Etikett).
- **Erzeugung**: "vom Planer GENERIERTE+kompilierte Binary je Messsystem" (Fork A ENTSCHIEDEN-VERSCHÄRFT, §30-Einordnung), "System-Achsen-VERSIONIERT", ABI-stabile .so (feedback_recursive_dock Ebene 2); "messsystem-HART kompiliert, nicht runtime-konfiguriert" (§30 Bauplan-Korrektur). Stempel `kMeasurementAxisVersionLine` [a,b,c] je Mess-Haupt-Achse (soll.md 3.5).
- **Rolle** (§30 V7.2-Vermerk): "die CEB-Rolle = NUR Kompilation + System + Scheduling der Binary-Basics".
- **Inhalt/Layer IN der CEB-Binary** (die Kapselung, die der Owner im Atlas vermisst):
  - Owner mittag-3 verbatim: "Die L2 CEB kapselt weiterhin L3 und L4 [L3=Anatomie, L4=Achsen-Organe], diese Layer sind IN der CEB eingebaut" — Lesart (Ledger mittag-3): "Tier-Binary enthaelt Anatomie+Achsen-Organe; die CEB kapselt sie zur BAUZEIT". Die CEB trägt also die Anatomie-/Achsen-Quellen-Schichten als BAU-WISSEN in sich und kompiliert daraus die Tier-Binaries.
  - User-Direktive (ist-ceb.md:153-154 verbatim): "**Anatomie enthaelt nur Achsen + Observer; alle Tools gehoeren in CacheEngineBuilder**" — die gesamte Werkzeug-Maschinerie ist CEB-Inhalt.
  - Konkret (soll.md Glied 5 + synthese.md): lazy Permutations-Maschinerie (Ranges lokal permutieren, Kompilation delegieren, §37.b/§38); CEB-INTERNER 4096er-Batch + RAM-Spool 256MB + Writer-Thread (§62-B); **Prüfstand** am Prüf-Dock VOR der Messung (§62-B; F5-Doktrin: deep-research-Tests aller Tier-Interfaces = MAP-Gattungs-Hüllen-Interfaces gegen die realen SearchAlgorithmBase-Implementierungen); Mess-Maschinerie — R2 (§60): "die CEB enthält den **eigentlichen measurement_driver**", die Mess-Achsen des Planers steuern nur die AUSSTATTUNG; Mess-Tooling-Default VEREINT {wallclock, macro, micro} in EINER CEB (§64); Selbst-Rückschrieb (s. B.4); Laufzeit-Layer-Trennung System-Freigabe (äußere Schleife) vs. Organ-Permutation (inneres Fenster) — "nie eine gemischte Sechs-Achsen-Struktur" (§62-B via soll.md 5.7).
  - Kompile-Reihenfolge (feedback_recursive_dock): CEB "**VORHER auf Gattungs-Observer + Module kompiliert**" (System-Konfiguration → Mess-Achsen-heuristische Konfiguration), erst dann bauen+durchmessen.
- Exklusivität (§38.b verbatim): "Multiple CEBs laufen sequentiell" — nur EINE messende CEB gleichzeitig; Fertig-Signal via §38-Rück-Kanal.

### A.4 Binary 3 (optional, ZWISCHEN CEB und echten Tiers) — HEURISTIK-/HYBRID-TIER-BINARY

- Position: §30.5/6 "+ Hybrid-Einschub einer weiteren generierten Binary in der Kette (optional)"; nach Mess-Auswertung von der CEB entwickelt; Owner mittag-3: liegt "optional zwischen" CEB-Kette und der Binary mit den Achsen-Organen "und stellt selbst eine binary nach Plan dar".
- Wesen (feedback_ceb_drei_modi, User 10.07., verbatim-treu): "Die HEURISTIK-OPTIMIERUNGS-ACHSE ist eine EIGENE SYSTEMACHSE: uebernimmt per Metaprogrammierung die Gattung ihrer Tier-Binaries, hat ein Pruef-Dock (im Arbeitsmodus 'Arbeits-Dock'), **wird SELBST zur Tier-Binary kompiliert** (dockt am CEB-Pruefdock an, **reicht Befehle an statisch zugewiesene echte Tier-Binaries weiter** = Metaprogrammierungs-Command-Pattern); … ABI-stabiles Gattungsinterface = als Suchalgorithmus-Huelle verwendbar ('**virtuelles ganzes Tier-Binary**')."
- Form (feedback_recursive_dock, Tier-Formen): "(a) heuristisch — mit noch EINER Ebene NACH dem Command-Pattern in einer compile-time Chain-of-Responsibilities (Heuristik-Command-Pattern-Tier, virtuell) — oder (b) plain ein Tier-Binary am CEB-Prüf-Dock."
- Rekursive Delegation (§30.6): Heuristik-Hybrid-Tiers "entwickeln und laden" echte Tier-Binaries "delegiert durch CEB". §42-Legende: "… XOR ([d,e,f,g,h,i]Hybrid-Heuristik-Tier-Binary -> ausgemessene beste, no permutation und static pick [d,e,f,g,h,i]Tier-Binaries)". variant-Ausnahme NUR dort (Memory-Index feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme).

### A.5 Binary 4 — TIER-BINARY (.so): Anatomie + Achsen-Organe hinter der ABI-Grenze

- Von der CEB am Prüf-Dock kompilierte "C++23-ABI-stabilen Tier-Binary-.so-Module" (feedback_recursive_dock Ebene 2); Träger der **Organ-Achsen** (§30.5).
- Inhalt hinter der ABI-Grenze: die Anatomie-Schichtung Gattung→Genus→Komposition (Owner F5 mittag-1: "Interfaces ihrer MAP-Huelle … (bitte Gattung/Genus/Terminologie der Anatomie Schichtung nachschlagen)"; anatomy_base.hpp: AnatomyGattung{Map, Container, Graph}, "Das Genus erbt von der gemeinsamen Gattung" — Ledger vormittag-3) + die metaprogrammierte SearchAlgorithmBase mit den Achsen-Organen. Atlas-Layer-Zuordnung (vormittag-3): L3 Anatomie + L4 Achsen-Organe (+L5-Kern-Anteile) leben IM Tier-Binary; ABI-Grenze = L2.
- Zwei strikt getrennte Layer im Tier: [d,e,f] System-Schicht und [g,h,i] Organ-Schicht (§62-B Testat-Grammatik via soll.md 5.7); Unter-Achsen d[d1,d2,d3] = Laufzeit-Parameter, von der Haupt-Achse freigegeben, NIE Neubau (§42.b).
- Prüf-Dock-seitig: "je Anatomie-Gattung EIN Prüf-Dock" (ist-ceb.md:210); ABI = gattungs-eigenes Antriebs-Sub-Interface (synthese.md L1-Sektion 7).

### A.6 Atlas-Konsequenz (Lesart Ledger mittag-3)

Das bisherige Atlas-Layer-Modell zeigt Verzeichnis-Schichten als GESCHWISTER (L0 Planer / L1 CEB / L2 ABI-Grenze / L3 Anatomie / L4 Achsen-Organe / L5 Kern, vormittag-3) — die BINARY-TOPOLOGIE fehlt: Binaries als CONTAINER mit ihren Layern zeichnen (Planer[Mess+Resolver+CLI] → CEB[System+Bau/Prüf/Mess-Maschinerie, kapselt Anatomie+Organe zur Bauzeit] → optional Heuristik-Tier[eigene Binary] → Tier[Anatomie Gattung/Genus/Komposition + Achsen-Organe hinter ABI]), Heuristik als optionale 4. Binary, Vertrags-Namen an den Kanten (Teil B).

---

## B. KANONISCHE VERTRAGS-NAMEN zwischen den Binaries

### B.1 „EXPERIMENT-DOCK" — Ebene 1, Planer ↔ CEB

- **Name** (feedback_recursive_dock, 17.07., verbatim): "**Ebene 1 — „EXPERIMENT-DOCK" (Experiment-Planer ↔ CEB), EINDIMENSIONAL**: Der Experiment-Planer hat ein Dock für C++23-ABI-stabile CEB-.so-Programme; der Vertrag ist eindimensional — der Planer STEUERT die Einstellungen der von ihm kompilierten CEB (Planer → CEB, KEIN Rückkanal hier)."
- **§38-REVISION (19.07., bindend)**: "Die frühere ‚Planer→CEB eindimensional/kein Rückkanal'-Festlegung ist ÜBERHOLT" — die obere Dock-Grenze ist "**bidirektional wie der Fuß**, aber mit **asymmetrischer Nutzlast**":
  - **Hinab (Planer→CEB)**: "die **zusammenhängenden unteren Teilbäume der System-Achsen mit nachfolgenden freigegebenen und regulären Organ-Achsen werden per SERIALISIERUNG vom Experiment-Planer an die CEB übergeben** … **direkt die RANGES jeder System- und Organ-Achse**" (§38.1 verbatim). Grenz-Nutzlast = Messsystem-Wahl (CEB wird messsystem-HART kompiliert, §30 Bauplan-Korrektur).
  - **Hinauf (CEB→Planer) = §38-Fortschritts-Cursor**: "**sparse immer nur die Achse(n) in der lazy Materialisierung mit der gewählten Konfiguration übermittelt, die für eine neue Permutation und Erzeugung der nächsten Tier-Binary notwendig sind**" (§38.2 verbatim) — Mixed-Radix-Deltas; "**KEIN Mess-Daten-Rückfluss**" (§38-Einordnung). Zusatzfunktion §38.b: das Fertig-Signal für die sequentielle Planer-Sequenzierung multipler CEBs.
- **Anatomy-Major-Versionierung**: "Der **Anatomy-Major-4→5 reitet am Experiment-Planer-Dock** (gegenüber der CEB-Messsystem-Erstellung)" (feedback_recursive_dock, verbatim).
- **R1-Textemission-Interim** (§60-R1/soll.md 4.4): Ist-Vertrag = **TEXTEMISSION** (emittierter CMake-/YAML-Text + Env), nicht die C++23-`<modules>`-.so-ABI-Schnittstelle; im Code als bewusster Entscheid markiert (S5-P4 "Band-C DEFERRED Task #19", experiment_dock_payload.hpp:57-64); Prüf-Auftrag "Wiedereinführbarkeit + Sinnhaftigkeit prüfen, dann als Post-v3-Strang planen". Kein stiller Doktrin-Verlust (synthese.md Glied 4).

### B.2 „PRÜF-DOCK" — Ebene 2, CEB ↔ Tier-Binary (im Arbeitsmodus: „ARBEITS-DOCK")

- **Name** (feedback_recursive_dock, verbatim): "**Ebene 2 — „PRÜF-DOCK" (CEB ↔ Tier-Binary), BIDIREKTIONAL**: Die CEB … hat ihr EIGENES Prüf-Dock — ein bidirektionales Prüf-Dock zu seinen verschiedenen Arten von Tier-Binary-.so-Interfaces (**CEB treibt an ↔ Tier-Binary meldet Messergebnisse ABI-stabil zurück**). Dort kompiliert die CEB die C++23-ABI-stabilen Tier-Binary-.so-Module."
- **Richtungen/Nutzlasten**: hinab Antrieb (System-Nutzlast `CebSystemAxisDrive` CEB→Tier-Stufe, §30 Bauplan-Korrektur; Bau + Befehle/Command-Pattern, Mess-Ansteuerung), hinauf ABI-stabile Messergebnis-/Observer-Meldung. Prüfstand-Funktion: "import → GATE → (nur bei pass) messen" + F5-Doktrin (deep-research-Tests NACH dem Compile); je Anatomie-Gattung EIN Prüf-Dock.
- **Arbeitsmodus-Alias** (feedback_ceb_drei_modi, verbatim): die Heuristik-Systemachse "hat ein Pruef-Dock (**im Arbeitsmodus „Arbeits-Dock"**)" — dasselbe Dock, im Arbeitsmodus (Hot-Tier-Switching, Tiers hot im RAM, Switch an der bewussten ABI-Grenze) unter dem Namen ARBEITS-DOCK.

### B.3 Heuristik-Andocken — am PRÜF-DOCK, kein eigener dritter Dock-Typ

- (feedback_ceb_drei_modi, verbatim): die Heuristik "wird SELBST zur Tier-Binary kompiliert (**dockt am CEB-Pruefdock an**, reicht Befehle an statisch zugewiesene echte Tier-Binaries weiter = Metaprogrammierungs-Command-Pattern); die Heuristik-Rekombination ist selbst permutierbar gegen die echten Tier-Binaries". Ledger-mittag-3-Lesart: "Heuristik dockt am Pruef-Dock an und delegiert per Command-Pattern an statisch zugewiesene echte Tiers." D.h. an der Kante CEB↔Heuristik gilt derselbe PRÜF-DOCK-Vertrag; die Heuristik ist zu den echten Tiers hin Suchalgorithmus-Hülle über deren ABI-Gattungsinterface ("virtuelles ganzes Tier-Binary").

### B.4 Ergebnis-Rückschrieb — NICHT über die Docks (kein Dock-Vertrag)

- (feedback_recursive_dock, verbatim): "**Ergebnis-Rückschrieb (NICHT über das eindimensionale Experiment-Dock)**: Die CEB schreibt nach Bestimmungen des Experiment-Planers die angeforderten Aufgaben + Messwerte SELBST an das in der XML eingegebene Ziel zurück." Pipeline `measurement/<YYYYMMDD-HHMMSS>/`, Write-Token, Loop-Schutz; §42.b: je Haupt-Achsen-Permutation EIN Mess-Job `measure:[a,b,c][d,e,f][g,h,i]`, der den Unter-Achsen-Sweep beherbergt und "als CSV zurueckschreibt". Der §38-Cursor bleibt strikt messdatenfrei. Der Planer LIEST die zurückgeschriebenen Messwerte separat rück (Owner F7) — Lese-Pfad, kein Dock-Kanal.

### B.5 Kanten-Legende (Schlüssel-Disziplin an den Verträgen)

- §42/§62-D (via soll.md 4.6): `[a,b,c]` NUR auf CEB-Ebene (`ceb:build:[a,b,c]`) · Tier-Bau `tier:build:[d,e,f][g,h,i]:chunk<k>` · Messung `measure:[a,b,c][d,e,f][g,h,i]`; Replay-Schichtung [a,b,c]→CEB · [d,e,f] ALLEIN→Tier · [d,e,f]+[g,h,i]+HW-Identität→Messwert — nie fusioniert. Zweistufige Steuerung §40.b (verbatim): "Der **Experiment-Planer steuert die Bau-Jobs von CEBs** und die **CEBs steuern Bau-Jobs von Tier-Binaries**" — keine Stufe überspringt die andere.

---

## C. Kompakt-Tabelle für den Atlas-Umbau

| Kante | Kanonischer Vertrags-Name | Richtung | Nutzlast hinab | Nutzlast hinauf |
|---|---|---|---|---|
| Planer ↔ CEB | **EXPERIMENT-DOCK** (Ebene 1) | historisch „eindimensional", per §38 REVIDIERT: bidirektional, asymmetrisch | serialisierter unterer B+-Teilbaum: System- + freigegebene/reguläre Organ-Achsen als RANGES je Achse; Messsystem-Wahl = harte CEB-Kompilation | §38-Fortschritts-Cursor: sparse Mixed-Radix-Achsen-Deltas + Fertig-Signal (§38.b); NIE Messdaten. Anatomy-Major reitet an diesem Dock. R1: Ist-Form Textemission (deferred .so-ABI) |
| CEB ↔ Tier-Binary | **PRÜF-DOCK** (Ebene 2; im Arbeitsmodus **„ARBEITS-DOCK"**) | BIDIREKTIONAL | Kompilation + Antrieb (CebSystemAxisDrive, Befehle, Prüfstand import→GATE→messen) | Messergebnisse/Observer ABI-stabil zurück |
| CEB ↔ Heuristik-Tier (optional, eigene Binary) | Andocken am **PRÜF-DOCK** (kein dritter Dock-Typ) | wie Prüf-Dock | wie Prüf-Dock | wie Prüf-Dock |
| Heuristik-Tier → echte Tiers | Metaprogrammierungs-**Command-Pattern** über das ABI-Gattungsinterface („virtuelles ganzes Tier-Binary"; static pick, no permutation) | Befehls-Weiterreichung an statisch zugewiesene Tiers | — | — |
| CEB → XML-Ziel | **Ergebnis-Rückschrieb** (KEIN Dock) | einseitig | CSV je Zelle → measurement/-Pipeline/Bestandslog | — (Planer liest separat rück, F7) |

Binary-Container: **Planer** [Mess-Achsen + 3-Registry-Resolver (.pom) + Shell-CLI + Rück-Leser + X.Y.Z-Stempel] → **CEB** [System-Achsen, [a,b,c]-versioniert; Bau-/Prüf-/Mess-Maschinerie (Batch 4096, RAM-Spool, Prüfstand, measurement_driver); KAPSELT Anatomie+Achsen-Organ-Layer zur Bauzeit] → optional **Heuristik-Tier** [eigene generierte Binary; CoR/Command; eigene Systemachse] → **Tier-Binary .so** [Anatomie Gattung/Genus/Komposition + Achsen-Organe hinter der ABI-Grenze; Layer [d,e,f]|[g,h,i] getrennt].
