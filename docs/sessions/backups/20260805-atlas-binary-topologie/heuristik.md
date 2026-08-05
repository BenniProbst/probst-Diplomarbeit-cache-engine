# LENS heuristik-binary — Kanon-Erhebung HEURISTIK-/HYBRID-Stufe (05.08.2026)

READ-ONLY-Nachschlag im Plan-Korpus. Alle Zitate verbatim mit Fundstelle. SOLL/IST strikt getrennt.
Abkuerzungen: LED = super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Zeilennummern Ist-Stand
05.08.); MEM = `/home/comdare/.claude/projects/-home-comdare/memory/`; ce = `Code/external/comdare-cache-engine`.

---

## 0. Owner-Anlass (Ledger mittag-3, LED:4044-4047, verbatim)

> "Wenn ich mir jetzt den Atlas nochmal anschaue gibt es immer noch das Problem, dass die L5 Heustik
> nicht optional zwischen der Binary L4 mit den Achsen-Organen liegt und selbst eine binary nach Plan
> darstellt. Die L2 CEB kapselt weiterhin L3 und L4, diese Layer sind IN der CEB eingebaut und das ist
> nicht erkennbar. Die Vertraege sind weiterhin nicht korrekt bezeichnet zwischen den Binaries."

Ledger-LESART (LED:4046): Die Heuristik-Stufe ist eine **OPTIONALE EIGENE BINARY der Kette ZWISCHEN
CEB und den echten Tier-Binaries**; kanonische Vertrags-Namen an den Kanten: **EXPERIMENT-DOCK**
(Planer↔CEB, eindimensional + §38-Cursor-Rueckkanal) / **PRUEF-DOCK** (CEB↔Tier, bidirektional; im
Arbeitsmodus ARBEITS-DOCK) / "Heuristik dockt am Pruef-Dock an und delegiert per Command-Pattern an
statisch zugewiesene echte Tiers."

---

## 1. Antworten auf die KERNFRAGEN (Kanon-Synthese, je mit Beleg)

### 1.1 Ist die Heuristik-Stufe eine EIGENE kompilierte Binary? — JA (SOLL)
- **LED:818 (10.07., USER-DIREKTIVE, verbatim):** "VIERTER Modus = HYBRID-MODUS = das ZIEL der
  Diplomarbeit — Compare-Feature auf E4 (kombinierte Wall-Clock + Makro-/Mikrobenchmarks cross alle
  Tier-Binaries per **Mess-Command-Pattern** ueber die optimierte Rekombination als **virtuelles
  ganzes Tier-Binary**); die **Heuristik-Optimierungs-Achse** [...] uebernimmt per Metaprogrammierung
  die Gattung ihrer Tier-Binaries, hat ein **Arbeits-Dock** und **wird SELBST zur Tier-Binary
  kompiliert** [...]; muendet in erneuter Messung des Heuristik-Tier-Binaries."
- **MEM feedback_kette_planer_mess_ceb_system_tier_organ_hybrid (Z.11):** "Tier-Binaries =
  Organ-Achsen **+ optionaler Hybrid-Einschub** (weitere generierte Binary) → **3–4 Binaries in EINER
  Kette, top-down sequentiell generiert** [...] CEB kann nach Mess-Auswertung
  **Heuristik-Hybrid-Tier-Binaries** entwickeln, die ihrerseits echte Tier-Binaries delegiert durch
  CEB entwickeln/laden (rekursive Delegation)."
- **Bauplan topdown (docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md:245):** "Phasen-Struktur
  + **4. Binary (optionaler HYBRID-Einschub)** [...] Ketten-Position: **Planer → CEB →
  [Hybrid-Tier ↔ CEB] → Tier**." — plus NACHTRAG §31 (:246): Bau war "nach Abgabe", REVIDIERT zu
  "ABGABE-PFLICHT vor 28.07."; Owner-E1 02.08. verlegt den BAU erneut in die **Auswertungsphase**
  (Design JETZT, s. 1.6).
- **ce Design-Doc `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (485 Z., Abschnitt 3
  via hybrid/README.md-Tabelle):** geplante Datei `hybrid_tier_module.cpp` = "Export der
  Hybrid-Binary **als normales Tier-Modul (4 ABI-Pflicht-Symbole)**" — also eine eigene .so-Binary an
  der bestehenden Anatomy-ABI, **kein neuer ABI-Schritt** (README Z.50-51: "beide Grenzen der Stufe
  sind die bestehende Anatomy-ABI (Major 7, anatomy_module_abi_v1_decl.hpp:62)").

### 1.2 Wo dockt sie an? — Am CEB-PRUEF-DOCK; sie selbst traegt N eigene HYBRID-PRUEF-DOCKS (Rekursions-Ebene 3)
- **LED:818:** "(dockt am CEB-Pruefdock an, Befehle an statisch zugewiesene echte Tier-Binaries =
  Metaprogrammierungs-Command-Pattern; Rekombination selbst permutierbar; ABI-stabiles
  Gattungsinterface = Suchalgorithmus-Huelle)".
- **Owner-E1 02.08. (super `docs/sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:7`, verbatim):**
  "die Hybrid-Tier Binaries [sind] klar als eine **weitere Stufe hinter der CEB** definiert [...] Sie
  haben **mehrere Pruef-docks** und verwenden fuer den Einsatz ihrer Pruef-Docks zur **Proxy
  Verwendung ihrer Tier-Binaries als Factory Pattern**, in der Regel als Ausnahmen std::variant. Aber
  in den plain Tier-Binaries ist das verboten. [...] Es ist auch einstellbar, dass die **Anzahl der
  ABI stabilen Pruefdocks an der hybrid-Tier-Binary zahlenmaessig dynamisch variieren** kann, genau
  dafuer braucht es std::variant in einem **wahlweise statischen oder runtime array**."
- **Design-Doc §2 (Dock-Ketten-Tabelle):** Ebene 1 Planer-Dock (eindimensional) · Ebene 2
  CEB-Pruef-Dock (bidirektional, ABI-7, gebaut: `IPruefDock`/`PruefDockRegistry`/
  `SearchAlgorithmDock`/Sequencer) · **Ebene 3 = Hybrid-Pruef-Docks (Hybrid-Tier-Binary ↔ plain
  Tier-Binaries), bidirektional, NEU; N Docks statt einem, N dynamisch.** ce hybrid/README.md:13:
  "Rekursions-Ebene 3 der Dock-Kette (Planer-Dock -> CEB-Pruef-Dock -> **Hybrid-Pruef-Docks**)."
- Zwischenloesung statische Pruef-Docks ↔ austauschbare plain Tier-Binaries je Pruefdock =
  **XML-Konfiguration auf Anwender-Wunsch in der AUSWERTUNGSPHASE** (Owner-E1 verbatim).

### 1.3 Wie delegiert sie? — Command-Pattern + compile-time Chain-of-Responsibility, Factory-Proxy je Dock
- **Tier-Formen a/b (MEM feedback_recursive_dock_planer_ceb_tier_abi_stable_so Z.15; LED:518/1741):**
  "**Tier-Binaries** (am CEB-Pruef-Dock), zwei Formen: **(a) heuristisch** — mit noch EINER Ebene NACH
  dem Command-Pattern in einer **compile-time Chain-of-Responsibilities** (Heuristik-Command-
  Pattern-Tier, virtuell) — oder **(b) plain** ein Tier-Binary am CEB-Pruef-Dock."
- **LED:1741 (H-8):** "Governor+Prefetcher = Tier-Binary-Achse; der Governor ist Teil des
  Strategy-Pattern bzw. der **automatischen Heuristik-Command-Pattern-Einschaetzung eines
  (virtuellen) Tier-Binaries**."
- **Owner-E1:** Dock-Einsatz per **Factory Pattern als Proxy** auf ihre Tier-Binaries; §49-KORREKTUR
  (Design-Doc §1 Ende, LEDGER:2663): "variant NUR als Traeger abweichender
  Unter-Pruef-Dock-Typen/-Vertraege, gelesen und verarbeitet per **Abstract-Factory-Methode**; die
  **Haupt-Kommunikation zu den Tier-Binary-Observern bleibt statisch** (IObservableTier, zero-cost)."
- **Design-Doc geplante Bausteine (hybrid/README.md:30-42):** `hybrid_dock_factory.hpp` (Abstract
  Factory, einziger Konstruktions-Ort der variant-Alternativen) · `hybrid_binary_proxy.hpp` (Proxy je
  Dock auf seine plain Tier-Binary, besitzt `AnatomyModuleHandle`) · `hybrid_router.hpp`
  ("Break-Even-Router, **Compile-Time-Chain-of-Responsibility**") · `hybrid_eviction.hpp`
  (Verdraengungs-Strategie, CT-Strategy) · `hybrid_dock_array.hpp` (`DockArray<Policy>` statisch ODER
  Runtime) · `hybrid_config_xml.hpp` (`<hybrid_tier>`-Sektion, NUR-EIN-XML-Programm-Doktrin).
- **Rekursive Delegation (MEM kette Z.11):** Hybrid-Tiers "delegier[en] durch CEB" die Entwicklung/
  das Laden echter Tier-Binaries — die Kompilation laeuft also weiter ueber die CEB.
- **Abzugrenzen — CoR im CEB (nicht in der Hybrid-Binary):** "Auswertung = Filterkette = Chain of
  Responsibility (GoF) — **STRIKT im CacheEngineBuilder-Bereich** fuer die Kontrolle der
  Tier-Binary-GENERIERUNG" (MEM feedback_heuristik_messkurven_typsystem_chain_of_responsibility
  Punkt 4; LED:829). Es gibt also ZWEI CoR-Orte: CEB-Auswertungs-Filterkette
  (`selection_filter_chain.hpp`) und CT-CoR IN der heuristischen Tier-Binary (Break-Even-Router).

### 1.4 Ist sie OPTIONAL je Kette? — JA (XOR-Glied), aber als DoD ABGABE-PFLICHT
- **MEM kette Z.11:** "+ optionaler Hybrid-Einschub (weitere generierte Binary)" → "3–4 Binaries".
- **W10-User-Direktive (LED:2421, verbatim):** "... -> **[d,e,f,g,h,i]Tier-Binary XOR
  ([d,e,f,g,h,i]Hybrid-Heuristik-Tier-Binary -> ausgemessene beste, no permutation und static pick
  [d,e,f,g,h,i]Tier-Binaries)**." LED:2425 (SOLL W10): "... XOR Hybrid-Heuristik-Tier-Binary (static
  pick der ausgemessenen besten, **KEINE Permutation im Hybrid-Pfad**)."
- **Pflicht-Status:** LED:2272 (§31 A2, verbatim): "'Da der Fuss und die Tier-Binary-Permutation
  vollstaendig steht, ist dies auch ein **Abgabekriterium** [...], das ist mit Pflicht.' ⇒
  Hybrid-Einschub (4. Ketten-Glied) = ABGABE-PFLICHT vor 28.07." — zeitlich ueberlagert durch
  Owner-E1 02.08.: "Designplanung JETZT via Fable 5 xhigh + ultracode; **Bau in der
  Auswertungsphase**" und V7.4-Gate-Reihenfolge (LED:104): "... 320er-Abgabemessung → **S7 Hybrid** →
  G8-Anhaenge → S8 PDF."
- **F7/Release-Modus (LED:2292):** "(3) Release-Modus = erst Messung, zum Schluss eine perfekt
  optimierte Tier-Binary **oder** Heuristik-Hybrid-Binary OHNE eingebautes Messsystem" — auch hier
  Wahl, nicht Pflichtglied jeder Kette.

### 1.5 Eigene Systemachse? — Aelteres Framing, per Owner-E1 SUPERSEDED zugunsten des STUFEN-Modells
- Alt (LED:215(e) + LED:818, 10.07.): "**Hybrid** (Heuristik-Optimierungs-Achse als eigene
  Systemachse)" / "die Heuristik-Optimierungs-Achse ist eine EIGENE SYSTEMACHSE".
- Neu (LED:97, Einordnung K4): "Owner-E1 definiert die Hybrid-Natur als **STUFE** hinter der CEB. Das
  aeltere Framing 'Hybrid = Heuristik-Optimierungs-Achse als eigene Systemachse' (LEDGER:187(e)) ist
  [...] insoweit **superseded** (V7.2 kennt genau drei System-Glieder). Rest-Klaerung als Owner-Frage
  **Q6** ausdruecklich OFFEN gefuehrt" — Q6 wurde per Owner-GO ~17:4x 02.08. mit Default freigegeben:
  "**Q6 Ein-Gattung-Hybrid + MaxN=8 + LEDGER:187(e) superseded**" (Owner-Session NACHTRAG ~17:4x;
  LED:3724 DEDUPE-VERMERK: "Hybrid-Q6 (Ein-Gattung, MaxN=8) [...] Owner-entschieden").
- MEM feedback_hybrid_tier_stufe_hinter_ceb_variant_ausnahme: Stufe HINTER der CEB; std::variant dort
  definierte Ausnahme, **in plain Tier-Binaries VERBOTEN** (V7.2/§23 gilt dort uneingeschraenkt).

### 1.6 3–4 Binaries in EINER Kette? — JA (§30-Kanon)
- LED:2249/2258 (§30): "Planer = Mess-Achsen · CEB = System-Achsen · Tier-Binaries = Organ-Achsen —
  **+ Hybrid-Einschub** einer weiteren generierten Binary in der Kette (**optional**)." MEM kette:
  "3–4 Binaries in EINER Kette, top-down sequentiell generiert." Storage (LED:2273 A4): CI-Cache haelt
  NUR den Planer; prod-MinIO haelt "ALLE generierten Folge-Stufen (CEB je Messsystem + Tier-Binaries
  **+ Hybrid**) + Systemaufstellungen."

---

## 2. F8-Heuristik-DoD + Break-Even-Kanon (LED §32-F8)

- **LED:2294 (F8, ENTSCHIEDEN):** "Minimale Baseline bestaetigt (**Heuristik-Hybrid-Tier-Binary aus
  realen Messdaten, durch CEB kompiliert+geladen, delegiert echte Tier-Binaries via CEB,
  ctest-bewiesen**) PLUS: Die Messungen muessen eine **Spline-Funktion auf jeder Achse** [...]
  bereitstellen, um [...] bei Eingabe einer Anfrage auf das Interface (klassifizierte Operationen ×
  Workload) **rueckwaerts die optimale Binary mit den optimalen Algorithmen-Saetzen** [...] zu laden."
- **Drei Break-Even-Optionen (LED:2295-2296 + 2602):** (1) heuristik-erkannte Algorithmen doch direkt
  als `std::variant` in DIESELBE Tier-Binary ("bewusste, eng begrenzte Ausnahme vom §23-variant-
  Verbot, **nur im Heuristik-Hybrid-Kontext**"); (2) "bei komplexen Multi-Break-Even-Uebergaengen
  **ganze Tier-Binaries hot neu an das Dock laden**"; (3) "Array multipler Docks mit
  Memory-Verdraengungs-Algo" (LED:2601-2602; Break-Even = **Spline-Schnittpunkte**).
- **Messkurven-Typsystem + Observer-Matrix (MEM feedback_heuristik_messkurven..., LED:829, Doc
  `architektur/20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md`):** Messfehler-Erkennung durch
  3-Varianten-Observer-Einbau im Heuristik-Modus ((a) Observer in allen Tieren + Heuristik-Hybrid-
  Tier, (b) nur im Heuristik-Tier-Binary, (c) keiner) + komplementaerer 4. Schritt: untergebene
  Heuristik-Tiere OHNE Observer/Benchmarks neu bauen, Wall-Clock-Vergleich, "Paper-Vergleich geht
  vor"; Ergebnis = multidimensionale Custom-Mess-DB.
- **Kompile-Reihenfolge (MEM recursive_dock Z.16):** CEB muss VORHER "auf deren Observer + Module
  kompiliert" werden: "**System-Konfiguration → Mess-Achsen-heuristische-Konfiguration**."

---

## 3. IST am Objekt (ce, live gelesen 05.08.)

### 3.1 `libs/cache_engine/heuristik/` — 3 Header, MATHEMATIK-Bibliothek, KEINE Binary
- `axis_spline.hpp` (261 Z.): "Spline-Interpolation ueber (x,y)-Stuetzstellen einer
  Organ-Achsen-Variante. PAKET W3-C (Ledger Sec.32-F8, Abgabe-Pflicht). Header-only"; Strategy (GoF)
  compile-time, Default monotone kubische Hermite (Fritsch-Carlson 1980), honest-empty (<2
  Stuetzstellen → `std::nullopt`). Namespace `comdare::cache_engine::heuristik`.
- `break_even.hpp` (148 Z.): "Schnittpunkt-Finder zweier AxisSpline f/g DERSELBEN Organ-Achse [...]
  'Switch-Thresholds = Schnittpunkte zwischen den f(x)-Spline-Funktionen'"; Bisektion,
  `BreakEvenPoint{x,y,links_besser,rechts_besser}`.
- `measurement_curve_loader.hpp` (219 Z.): laedt (x,y)-Reihen je (achse,variante,workload) aus realer
  Mess-CSV (WIDE-Pfad `lazy_csv_header` Semikolon / SNAPSHOT-Pfad Komma); ehrliche Nicht-Zahl-Tokens
  "n/a"/"failed"/"gesperrt"/"nicht_gebaut" → skipped_rows, nie Phantom-Punkt.
- **Befund:** Das ist die F8-Spline-/Break-Even-MATHEMATIK (Zulieferung der Heuristik-Stufe), im
  Library-Baum — es ist NICHT die Heuristik-Binary selbst. Owner mittag-3 ruegt exakt das: heuristik/
  darf im Atlas nicht als "Kern/Basis-Layer" erscheinen, die Stufe ist eine optionale EIGENE Binary
  ZWISCHEN CEB und Tier.

### 3.2 `libs/cache_engine/hybrid/` — reiner Reservierungs-STUB, kein Code
- Einzige Datei `README.md` (Paket HY-D2, 02.08.): "reine NAMENS- UND SCHNITTSTELLEN-RESERVIERUNG
  [...] KEIN Header, KEINE Quelle, KEINE CMakeLists, KEIN Build-Anschluss [...] ANFASSEN ERST in der
  Auswertungsphase (Pakete HY-B1..HY-B4), nach Voll-Bau-4 und nach E-24." Stufe = "Rekursions-Ebene 3
  der Dock-Kette"; Namespace reserviert `comdare::cache_engine::hybrid`; bindendes Design =
  ce `docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` (485 Z., "DESIGN FESTGESCHRIEBEN,
  BAU IN DER AUSWERTUNGSPHASE"). Geplante 9 Dateien (Dock-Contract/Docks/Factory/DockArray/Proxy/
  Eviction/Router/XML/`hybrid_tier_module.cpp`). Erster Meilenstein = "F8-Minimal-DoD (genau 1
  Standard-Dock, ctest-bewiesen)". Offene Auflagen K1 (Lager-Identitaet der Hybrid-.so), K2
  (Loader/Drive-Schicht), K4 (LEDGER:187(e)-Verhaeltnis), K5 (Snapshot-Aggregation) VOR dem
  jeweiligen Bauschritt. Dock-Bestueckung = Runtime-Konfig im **Sidecar-Manifest, NIE binary_id**;
  Sidecar-Format erst NACH A13-Stempel-Regression.
- Weitere IST-Anker: `subsystems/c09_heuristik_engine/i_heuristik_engine.hpp` (aelteres Subsystem-
  Interface), `builder/bestandslog/knoten_heuristik_log.hpp` (Bestandslog-Heuristik, anderes Thema),
  CEB-CoR `builder/experiment_tree/selection_filter_chain.hpp` (`run_selection_filter_chain`/
  `ResumeFilter` — Bauplan topdown :39 "vorhanden, UNWIRED"; :228 Andockpunkt `resolve_selection`
  existierte nicht als Naht; Verdrahtungs-Stand vor Behauptung neu pruefen).

### 3.3 SOLL/IST-Diff (ehrlich)
1. Heuristik-BINARY existiert NICHT (nur Mathematik-Header + Design-Doc + Stub) — plankonform, da Bau
   per Owner-E1 in der Auswertungsphase liegt; ATLAS muss sie dennoch als optionale 4. Binary der
   Kette zeigen (Owner mittag-3), nicht als Library-Layer.
2. Hybrid-Pruef-Docks (Ebene 3) existieren NICHT im Code (nur Design). CEB-Pruef-Dock (Ebene 2)
   existiert (`IPruefDock` vtable `pruef_dock.hpp:57`, per Bauplan-Anker).
3. Das aeltere "eigene Systemachse"-Framing ist superseded (Stufen-Modell); Q6-Defaults
   (Ein-Gattung-Hybrid, MaxN=8) sind Owner-freigegeben.

---

## 4. Kanonische Ketten-/Vertrags-Namen fuer den Atlas (Konsolidierung)

Planer —(EXPERIMENT-DOCK, eindimensional steuernd + §38 sparser Fortschritts-Rueckkanal, KEIN
Messdaten-Rueckfluss)→ CEB —(PRUEF-DOCK, bidirektional, ABI-stabil; im Arbeitsmodus ARBEITS-DOCK)→
**[optional: Hybrid-Heuristik-Tier-Binary]** —(N HYBRID-PRUEF-DOCKS, ABI-stabil, Factory-Proxy,
variant-Dock-Array)→ plain Tier-Binaries. XOR-Regel je Kette (W10): Tier-Binary ODER
Hybrid-Heuristik-Tier-Binary (static pick der ausgemessenen besten, keine Permutation im
Hybrid-Pfad). Ergebnis-Rueckschrieb NIE uebers Experiment-Dock, sondern CEB → XML-`<output>`-Ziel.
