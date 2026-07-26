# Chunk 23/30 — Chronologische Extraktion (Diplomarbeit-Managersession)

Zeitraum: ca. 2026-07-19 22:20 UTC bis 2026-07-20 spät. Keine Secret-Werte enthalten (Deploy-Token nur als CI-Variablennamen referenziert).

---

## PHASE 1 — W10 E2E-Härtung Runde 2–5 + §45-Gate (Z. 1–400)

### (c) Paketmeldungen/Abnahmen/Commits — Nacharbeiten des W10-Agenten
| # | Inhalt | Integrations-Commits | Verifikation |
|---|---|---|---|
| **Nacharbeit 2** | `emit_child_submodule_prolog()` — Parent-gespiegelter Deploy-Token-Klon als erster Script-Schritt aller Bau-Jobs beider Child-Stufen; pfad-geskopt auf ce + prt-art (Thesis-Submodul NICHT); `--force` + Sync auf gepinnten gitlink-SHA; global `GIT_SUBMODULE_STRATEGY: "none"`; Token **nur** als CI-Variablen-Referenz | ce `3d1cf3e5`, super `a1b34ef` | 25/25 Contract (#248), 287/287 Suite, Byte-Determinismus (dump-ci 5271B / emit-tier-ci 35472B) |
| **Nacharbeit 3** | ccache via **Runtime-Shell-Export** im Prolog statt YAML-`variables` | ce `fceff591`, super `513fc10` | 26/26, 287/287, 5855B/40144B |
| **Nacharbeit 4** | `$CI_PROJECT_DIR`-**Klassen-Schluss**: beide Offender (`COMDARE_GOLDEN_N_PROFILE`, `CCACHE_DIR`) aus `variables:` entfernt → nur Runtime-Export; **harte Klassen-Wache** im Contract-Test (variables-Block-Vorkommen == 0) | ce `635aafa6`, super `1ddffcb` | 27/27, 287/287, 6133B/44272B |
| **Nacharbeit 5** | Chunk-Fenster-**Zerlegung** in der Tier-Emission (Laufzeit-Berechnung disjunkter Teilfenster je Job, No-Op jenseits TOTAL, Steuerung über `COMDARE_GN_TOTAL`); globales Fixfenster `${COMDARE_GN_RANGE:-0:4}` ersatzlos entfallen | ce `11a43b57`, super `08d2fde` | 28/28, 287/287, Disjunktheitsbeweis 2^17: chunk0→0:32768 … chunk3→98304:32768 |

### (d) Fehler + Fixes (die 5 Vererbungslücken)
1. **Lauf 1 „Erfolg" war Workdir-Artefakt** — Child-YAMLs hatten keine Submodul-Mechanik (`Skipping Git submodules setup`); neues `main.cpp` kompilierte gegen **stale ce-Reste**. Auto-Fetch (`GIT_SUBMODULE_STRATEGY:recursive`) scheitert am Runner-**extraheader**-Problem → bewusst keine Option.
2. **Lauf 3 ccache-Rückkehr** = **Runner-Versions-Divergenz** (prod2 19.1.1 / prod1 18.9.0); `$CI_PROJECT_DIR` im YAML-Wert expandierte leer → Pfad `/.ccache`. Als **P12 im Infra-Handout** dokumentiert (`c1fbfab`), Update-Empfehlung prod1, gekoppelt an P8/P11-Lehre (nicht während laufender Jobs restarten).
3. **Lauf 4** — dieselbe Expansions-Falle an neuer Stelle (`COMDARE_GOLDEN_N_PROFILE`) → Klassen-Schluss statt Einzel-Fix.
4. **Lauf 4 Durchbruch:** Stufe 1 komplett grün, Grandchild 11597 real instanziiert, alle 16 Tier-Jobs gestartet.
5. **Range-Lücke vor Voll-Build:** 4 chunk-Jobs teilten sich ein globales Fenster statt es zu zerlegen → 4×-Redundanz.

### (b) Architektur-/Scope-Entscheidungen
- Explizite Allowlist/Token-Doktrin: Token **nie Klartext** im Emissions-Code, Contract-Test wacht dagegen (Byte-Determinismus + kein Leak).
- Gegatete Mess-Jobs (`when:manual`-Skelett, kein Bau) tragen **bewusst keinen** Prolog — Forward-Hinweis: bei 320er/GN-11-Scharfschaltung braucht der Mess-Job eigenen Runtime-Export.

### Ergebnis
- **Serie-E2E-5 (Pipeline 11600)**: pipeline/bridge/child = success, Grandchild 11608 mit allen 16 Tier-Jobs → **§45-Gate erfüllt**, W10 abgeschlossen (Task #27).
- **Finaler Mini-Serie-Lauf 11611** = success (Default TOTAL 16, 4 disjunkte 4er-Fenster).
- **Voll-Build 11621 gestartet** (`COMDARE_GN_TOTAL=131072`), Prognose ~24h+.
- Nachtbilanz im Ledger §39–§46: §40, §42, §42.b, §43 implementiert; §45 umgesetzt (W9-Konformität, W11-Caching, W12-Stempel, W10-Restrukturierung mit 5 Härtungsrunden).

---

## PHASE 2 — Systemabsturz, Wiederaufnahme, TOTAL-Bug (Z. 402–445)

### (a) User-Direktive (wörtlich)
> „Wir hatten einen Systemabsturz, bitte weiter wo wir aufgehört hatten"

(Vorher per `/model` Fable 5 gesetzt, `/effort` = ultracode.)

### (d) Kritischer Fehler — „grün aber inhaltlich leer"
- **Voll-Build 11621 war grün, baute aber nur TOTAL=16** statt 131072. Belege: chunk0 → `[0,4)`, chunk3 → `[12,16)`, je ~69 Binaries.
- Ursache: `COMDARE_GN_TOTAL` wird an **beiden Trigger-Grenzen verschluckt** (self-contained Child-/Grandchild-Pipelines erben per-API gesetzte Pipeline-Variablen nicht).
- Folge 2: **Bucket weiterhin nur 521 perm.dll** (Kalibrier-Bestand) — Dedup-HIT, nichts Neues gepusht.
- Folge 3: `forward:` existiert bereits differenziert an den Modul-Triggern → sauberer Fix = Forward an den zwei Planer-Ketten-Grenzen.
- Task **ehrlich** aktualisiert, **nicht** als erfüllt markiert (Direktive „kein ✓ ohne Ausgabe").

### Zweiter, tieferer Befund (User-Hinweis)
- `measurement_combos_of()` erzeugt **strukturell immer genau eine** Kombination (`return {combo}`), kollabiert wegen aller-16 zum `[all]`-Sentinel → nur **eine** CEB-Strecke statt mehrerer.
- Die 16 `<measurement_categories>` sind laut Profil-Kommentar **Spalten-Projektionen (binary_id-neutral)**.
- Der Mess-Vollzug (`measure:`-Ebene) ist nur `when:manual`-Echo-Skelett mit Env-Toggle `COMDARE_RUN_MEASURE`, den es im Treiber gar nicht gibt.

---

## PHASE 3 — §47 Mess-Achsen-Klärung (Z. 446–488)

### (a) User-Direktiven (wörtlich, bindend)
> „Bitte lies auch manuell im gesamten Ledger alles ab Punkt §20 , dort findest du wichtigen Kontext, viel schlimmer: in den Mess-Achsen wurde nicht nach statischen Haupt-Achsen für unterschiedliche CEB strecken und dynamische Unter-Achsen als Laufzeitparameter FÜR jede statsiche CEB unterschieden. (Prinzip über alle Achsen analog je Vertragspunkt zwischen Planung vs CEB vs Tier-Binary)"

> „Bitte starte einen ultracode Agenten, welcher für alle offenen Ziele der Diplomarbeit einen Konsolidierten Gesamtblock über ALLE §XX Kapitel pflegt. Danach lies diesen Artikel direkt in den Kontext, damit auch nichts vergessen wird"

> **§47-KERN (wörtlich):** „Die zusätzlich fehlende Hauptachse ist das sogenannte Mess-Tooling (fest einkompiliert ob CEB nur wallclock time, geplante makro-benchmarks oder micro-benchmarks über die observer misst) und deren Unter-Achse ist Debug vs Messen vs Release sind Ablaufmethodik (welches Ziel hat der Lauf ultracode in der Planung dafür) Unter-Achsen weil sie an die CEB delegiert werden, welche dann die Haupt-Achsen Eigenschaften in die Tier-Binaries einkompiliert und den Unter-Achsen Ablauf beim Vorgehen einhält. Bitte korrigiere das jeweils in der Dokumentation. Beides sind 2 verschiedene Achsen-Regularien (Haupt-Achse vs Unter-Achse auf den Mess-Achsen). Soviel zum Konflikt"

> „Bitte starte einen Explore Agenten um die genannten Hinweise im Ledger zu finden und starte erneut einen ultracode Agenten, der die Klärung meiner Ergänzung in die Zusammenfassung der offenen Punkte konsolidiert. Dazu muss aber der andere workflow erst fertig werden"

### (b) Architektur-Entscheidung mit Begründung
- **§24 wörtlich (aus Ledger zitiert):** „Haupt-Achsen … statische Einstellungen die zur compile time gesetzt und fest verdrahtet sind … Unter-Achsen … runtime Eigenschaften … Weil wir aber eine Kette Experiment-Planer → CEB → Tier-Binary laufen, sind die dynamischen Einstellungen der vorhergehenden Stufe, oft die zu übernehmenden compile Time Drähte der gebauten nachfolgenden Stufe."
- Fable hatte **falsch empfohlen** (Mess-Modus Debug/Mess/Release = HAUPT); User korrigierte → **Mess-Tooling = HAUPT**, Debug/Messen/Release = UNTER. Konflikt §32-F1 ↔ F7 damit aufgelöst: **F1 war korrekt, F7 korrigiert**.

### (c) Commits
- `baf2ca3` — §47 verbatim im Ledger; §32-F1 additiver **[§47-PRÄZISIERUNG]**, §32-F7 **[§47-KORREKTUR]**; W10-Bauplan-Nachtrag.
- `fd167f4` — Explore-Fundstellen-Report als W10-B-Impl-Referenz (`docs/plaene/20260720-mess-achsen-§47-fundstellen-W10B-REFERENZ.md`).

### Explore-Report (Kernbefunde)
- **[WIDERSPRICHT] Code:** `plan_legend.hpp:69–83` (`measurement_combo()` aus `<measurement_categories>`), `experiment_plan_director.hpp:83–92` (`PlanMeasurementCombo`), `:953–965` (`measurement_combos_of`, gibt genau 1 Combo).
- **Fehlende Schema-Elemente:** `<measurement_tooling>` / `<run_methodology>` — **repo-weit 0 Treffer**.
- **[WIDERSPRICHT] Docs:** `23_SYSTEMACHSEN_KONZEPT…:108/110/187`, `16_E1_E4_KONSOLIDIERUNG…:124/151`.
- **[NACHZIEHEN]:** Ledger §28/§29/§42.b/§43, achsen-nachschlagewerk-Docs, xml_config_parser, validate_profile.

---

## PHASE 4 — §48-Gesamtblock + Session-Plan + §50 (Z. 489–746)

### (a) User-Direktiven (wörtlich)
> „Volles GO für alle Punkte. Du bist ein C++ Entwickler und Experte auf deinem Gebiet, sowie Software Architekt und leitest als Manager die Organisation und Delegation der offenen Arbeit, indem du mit ultracode einen elaboraten sequentiellen Plan für die Ausführung entwickelst, der bei disjunkten Arbeiten je sequentiellen Schritt auf möglichst viele parallele Agenten verteilt wird. Bitte stelle das Plan design bereit damit ich es freigeben kann. Der Plan wird als Session-Plan gespeichert."

> „Bitte starte einen zusätzlichen ultracode workflow, welcher in Batches ALLE Ledger Punkte durchgeht und vergessene Features in die TODO Dokumentation ergänzt, sofern sich diese nicht gegen alle Punkte der TODO Dokumentation wiedersprechen. Bitte beziehe auch Pläne der letzten 3 Tage mit ein, in denen noch Blöcke und Wellen vergessen wurden. Die Workflows von gestern sind immer noch relevant. Bitte stelle Rückfragen, welche alten Punkte weiterhin übernommen werden sollen und welche wir beiseite legen."

> „Volles GO für alle Punkte. Ich gebe die std::variant im Hybrid-Tier-Binary frei, das ist korrekt. Dock array mit Verdrängung und Verdrängungs-Strategie (Speicher heuristiken bitte im web recherchieren) ist auch korrekt. Fallback R1 ziehen wir kompromisslos durch, zusammen mit ALLEN Messbmethoden UND den Observer-Prüfdock Bestandteilen (ultracode für die Präzisierung bitte als S9 verankern). Plan bis hierhin freigegeben, warten wir auf den anderen workflow"

> **variant-Korrektur (wörtlich):** „die std::variant im hybrid Tier ist nur limitiert freigegeben, sofern das einbinden der Tier-Binary Unter-Prüf-Docks per abstract Factory Methode gelesen und verarbeitet wird. Die std::variant sind nur dazu da um bestimmte abweichende Prüfdock-Typen und Verträge dynamisch zu unterstützen, aber nicht die Haupt-Kommunikation zu den Tier-Binary observern."

### (c) Commits/Abnahmen
- `d330c65` — **§48 KONSOLIDIERTER GESAMTBLOCK**, 437 Ziele über §0–§47, 8 Stränge, Executive Summary, Pflege-Hinweis → ab jetzt **Single-Source** (ersetzt die verlorene Task-Liste).
- `2752ca9` — 10-Punkte-Patch (§47-Klärung in §48 eingearbeitet: Exec-Summary-2, §27/§28-Registries, §30 AxisKind, §43 `kMeasurementAxisVersionLine`, „3-Modi"-Zeile → **zwei getrennte Regularien**, §42.b, §24-Ketten-Statik, neues Impl-Ziel, DOKU-NACHZUG Doc 23/16). 10/10 angewandt, 0 fehlgeschlagen.
- `e2f482c` — `docs/plaene/20260720-SESSION-PLAN-ausfuehrung-offene-arbeit.md` (S1–S8).
- `7f18fc7` / `cb569a4` — §49 Design-Freigaben + **§49-Korrektur** (variant limitiert) + S9 angehängt, R1 umgedeutet.
- `6f8ac0a` — **§50-Nachtrag** (~40 vergessene Features): F12iii Telemetrie-aus-binary_id, H-7 march-Kopplung, INC-1-Schichtung, Fehlerklassen-#29, Resolver-Forks R1–R8, Planer-Forks B–E, M-4/M-8/M-9-Writer, GN-9-Bloat-Report, §40.a-Deliverables, CEB-Selbst-Emission, **K-5 ABI-Spiegel stale (Daten-Korrektheit!)**, 9dim-G3.
- `9afe979` — §51 (B1–B15-Entscheide + Meta-Meta-Konzepte).

### Session-Plan S1–S8 (Struktur)
Sequentielle Schritte; je Schritt datei-**disjunkte** Pakete auf max. 5–6 parallele Agenten. **Planer-Kern** (`experiment_plan_director.hpp` + `validate_profile.hpp` + `xml_config_parser.*`) = **ein Owner, strikt seriell** (Engpass). Manager integriert je Schritt selbst (cf22 + ctest + Mojibake + super-Sub-Build + Dual-Push + CI-grün).

S1 P-TOTAL+golden-Vorbereitung (5) · S2 Voll-Build 2^17/new-golden im **einen ABI-Regen-Fenster** + P-SYSREG + P-INFRA(PAT-Rotation #327) (4) · S3 P-RESOLVER (3) · S4 Schema+Mess-Tooling-Auffächerung · S5 P-VOLLZUG · S6 USER-GO→320er-Messlauf · S7 Hybrid+M-4+PDF-Rückschrieb · S8 PDF-Abgabe. Deadline 28.07., Zwischen-Meilenstein 24.07., BAND-C ab 01.08.

### (a) User-Entscheide B1–B15 (wörtlich, verbindlich)
> „**B1:** new golden ist die neue Pflicht. Nur für das Zwischenergebnis akzeptieren wir die Messung der 320er, aber bauen bereits new golden auf. Also wie bereits entschieden und empfohlen. Bitte halte die Entscheidung verbindlich fest. **B4:** Die ISA Achse sollte per Fork A gebaut werden und die alte Version ausgebaut werden. Dabei muss beachtet werden, dass es sich bei dieser System-Achse um eine Freigabe-Haupt-Achse für durchführbare Organ-Achsen handelt (wie Compiler und Hardware Achse auch, Hardware Haupt-Achse als Beispiel mit der Hardware-Erweiterung AVX512 belegt), sie existiert als in den System-Achsen und kann in den Organ-Achsen als Raum ausgearbeitet werden, wobei dieser in der Regel nur der einen lokalen ISA entspricht, aber für explizite cross compile jobs erweitert sein kann. Hinweis: bezüglich der Versionierungsstempel muss es möglich sein, diese als System erweitern zu können, wenn neue System-Achsen in den Raum der Organ-Achsen einkompiliert werden sollen. **B7:** Akzeptiert, Freigabe. **B9:** Die Thesis hängt derzeit bei unseren Plänen hinterher, aber bezüglich der geforderten Thesis Profile WAS und WIE zu messen ist, müssen wir diese vollständig übernehmen und die entsprechenden Mess-Tooling Unterachsen für Mess-Frameworks und deren Workload-Delegation an die CEB übernehmen. Die Anforderungen wird per Schema in XML direkt definiert und es ist deine Aufgabe die Mittel und Werkzeuge im Experiment-Planer und allen Stufen zu entwickeln, damit diese korrekt durchgeführt werden können. **B5/B6:** Wie empfohlen. **B14:** mit ultracode prüfen und diff in die Planung persistieren. **B2:** Bitte diese Gattung als ABI Schritt als letzten Schritt zusammen mit einer eigenen ultracode Planung anhängen und mit der Vervollständigung der Gattung der SearchAlgorithm und Container erweitern, wie im Ledger klassifiziert, weil die SearchAlgorithm optimierte Container und Sets gleichermaßen mitverwenden sollten, wie deklariert. Bei weitem nicht erfüllt, gigantische Erweiterung über parallele Achsensysteme weiterer Gattungen. … Organ-Haupt-Achsen und Unter-Achsen identifizieren und exakt nach Schema der SearchAlgorithm implementieren. **B3:** Diese extension Hardware ist eigentlich ein dynamisches Array an Erweiterungshardware, jeder Typ an Erweiterungshardware bekommt dort EINE EIGENE Achse. … AVX512 mit seinem komplexen Flag System … eine eigene Erweiterungs-Achse … ALLES ist eine Hardware-Erweiterung, das kein CPU-Core im herkömmlichen Sinne ist und speziellen Befehlssatz benötigt. Wir nennen Haupt-Achsen eines statischen Achsen Arrays, die durch eine normale statische Hauptachse als Manager klassifiziert werden ‚Meta-Meta-Achsen'… haben die Organ-Achsen entsprechend ein analoges Haupt-Achsen-Array und Versionierungs-Stempel für den durch CEB materialisierten compile-Raum. **B8:** Die 6 Achsen sind korrekt und müssen durch eine siebte NUMA/locking System-Achse erweitert werden, sofern wir deren Eigenschaften als compile-statisch erkennen können, ansonsten ist dies eine dynamische System-Unter-Achse zur Laufzeit… Ich denke sie ist dynamisch auf modernen Systemen und eine Unter-Achse unter der Isa-Achse. **B10:** … die page-type sind genau so ein zusätzlicher Fall, weil die Hardware diesen page type unterstützen muss, dies ist für das Messen von cache awareness Pflicht und vermutlich eine System-Unter-Achse unter ISA, die dynamisch zur Laufzeit angepasst werden kann… **B11:** Bitte mit ultracode analysieren… **B12:** Bitte erkläre mir genau mit reichem Kontext, was hier liegt. **B13:** Bitte mit ultracode untersuchen, ob wirklich erledigt, weil in process unterbrochen wurde. **B15:** Volles go, falls per ultracode die Abdeckung bestätigt ist."

> „Bitte starte je ultracode Anforderung einen eigenen workflow, um die Probleme zu analysieren, lege mir danach alle Entscheidngen vor und schreibe jetzt erstmal eine elaborate Session Übergabe weil der Kontext jetzt endet. Dann führst du im selben Wortlaut mit der Erweiterung der überarbeitung meiner Präzisieurng die Planung erneut so gründlich durch, wie zuletzt und erweiterst, den aktuellsten Plan"

**8 Hintergrund-Workflows gestartet:** B2 `w5kiys8v7` · B3 `wcd6khth0` · B10 `wv69pjepi` · B11 `whf5t5fws` · B12 `w0mazjfkh` · B13 `w2l4l5v7a` · B14 `ww0rj4w0x` · B15 `wi6hdpj6z`. Danach **Kontext-Kompaktierung**.

---

## PHASE 5 — B-Workflow-Auswertung (§52) + Plan V2 (Z. 840–970)

### (b) Ergebnisse der 8 Analysen → **§52** im Ledger
- **B2 Gattung:** Gerüst für 5 Genera da, aber SearchAlgorithm treibt 9 Organe, Set/Sequence/Adapter/View je nur **1**. Weg = gemeinsames **`OrganConcept`** + Cross-Genus-**Komposition** (Join bleibt typ-unmöglich). Eigener ABI-Schritt zuletzt.
- **B3 Meta-Meta:** baubar als 3-Ebenen-CRTP + `boost::mp11` (vendored); `hardware` = Manager über `mp_list`-Array; AVX512 eigene Achse mit 13–14 Flag-Subsets; Stempel per **Fold** statt hardcoded.
- **B8/B10:** **User-Annahme korrigiert** — CPU wechselt page_type NICHT dynamisch; Allokations-Zeit-Eigenschaft (MAP_HUGETLB) bzw. asynchrone Kernel-Politik (THP). Code bereits korrekt zweigeteilt: System gibt Raum frei (`axis_12`, `huge_page_capable`) → Organ setzt durch (`AllocPageHint`). **Namensfalle:** `axis_01_page_type` = Baum-Struktur, nicht HW-Page. NUMA vermutlich dynamisch → Unter-Achse unter ISA.
- **B11:** INC-0 DLL-Load **erledigt** (ce `418e4b76`, `nm -D` zeigt `mi_*`=T, 105 echte Messzeilen). Verwirrung durch **zweites** „INC-0" (malloc/Flag-Facade 18.07.). Rest: `build-i2` stale-rot.
- **B12 F-SPREAD:** betrifft nur *welche* 2 Werte je Achse; `first-2` HAUPT (fixture-verankert), Max-Kontrast = optionaler INC-G7 ab 01.08. → geparkt.
- **B13:** 9dim-Fixes **7/7 erledigt**, nur 2 Prosa-Drifts.
- **B14 §38-Dock:** **Struktur erfüllt** (ce `d7d35c36`), 3 Kettenlauf-Reste offen (ProgressSink ohne Konsumenten, `ExperimentSubtreePayload` nur Struktur+Test, `resource_group` fehlt am dynamischen Mess-Job).
- **B15:** GO bestätigt unter 3 Auflagen (A5-Master-Löschung je-Repo-GO, Schritt-13 neu schneiden, neue Remotes je-Repo-GO).

### (a) User-Antworten auf die 4 Rückfragen (wörtlich)
> „**Frage 1:** Bitte erweitere und korrigiere den bestehenden Session Plan aus dem letzten Kontext mit allen bekannten Korrekturen unter verwendung des ultracode Workflows, nachdem du eine identische Kopie als Grundlage davon angefertigt hast… **Frage 2:** Alle großen Erweiterungen werden JETZT mitgeplant und hinten an die Abarbeitung als parallele weitere Stränge angehängt. Die Abgabe ist nur eine Zwischen-Abgabe und wir werden die wichtigen Stränge priorisieren, aber grundsätzlich keine der Stränge auslassen, wir planen voll und kommen einfach so weit wie möglich, das ist nicht schlimm… **Frage 3:** Wie empfohlen, aber die Löschung der alten Sachen direkt als Pflicht an das Ende des Stranges setzen. **Frage 4:** Separates Fenster als Agenten Delegation direkt hinter dem Fenster im selben Strang - kompromiss beides dennoch direkt zusammen zu übernehmen in 2 getrennten sequentiellen Stufen. Volles GO für den Start der ultracode Planung nach Vorbild des workflows im letzten Kontext"

### (c) Plan V2 — Datei + Commits
`docs/plaene/20260720-SESSION-PLAN-V2-voll-erweitert-alle-straenge.md` (identische Kopie + Block **PLAN-V2-ERWEITERUNG A–E**), Workflow `wf_a612d2db-d5f` (6 Reader → Architekt, 648k Tokens). Commits `b28fc7c`, dann `4c46e78`.

**A — Korrekturen D0–D6:** D0 Zielzahl 437→~477 · D1/D2 B11 INC-0 erledigt / S7-„DLL-Load Fork A" ist ein *anderer*, echter Rest · D3 9dim 7/7 · D4 §38 Struktur erfüllt · D5 page_type keine neue Achse · **D6 K-5** `best_binary_selector` ABI-Spiegel stale → falsche Provenienz → **vor S7 ziehen (BAND-A)**.
**B — Schärfungen:** S4-Delta B9 Thesis-Profile voll · S5-Delta §38-Reste · Emitter W10-A/W7 · §40.a-W8 · M-4 19→17 · 9dim-G3.
**C — Neue Stränge:** S10 ISA-Fork-A + Meta-Meta + Stempel-Fold (3 Stufen, Alt-Ausbau = Pflicht-Schluss) · S11 NUMA/page_type · S12 Gattung (S12.1 OrganConcept seriell → S12.2 5 Genera parallel → S12.3 **2-Stufen-ABI-Fenster**) · S13–S23 (B7 inkr. Cache, Storage V90/V91, GN-9, Heuristik-Writer M-8/M-9/M-15, INC-Reste, Forks-Register, Migration, INC-G7).
**D/E:** BAND-Tabelle A/B/C/D, Parallel-Topologie, Owner-Konflikt-Matrix; kritischer Pfad S1→S8 bleibt 28.07.-Fokus.
**Storage-Korrektur (B5/B6):** Ebene B = **dev-MinIO V90**, Ebene C = **prod-NFS V91** (korrigiert stale „prod-MinIO V91").

### (a) W11-Trennung (wörtlich) + Freigabe
> „Perfekt. W11 async push ist nur für die Erstellung von Binaries auf minio.comdare.de Pflicht und freigegeben, der Push hat weiterhin kein async, bitte trennen und wieder mit aufnehmen. Danach volles GO für den Plan."

→ **§53** im Ledger: (a) FREIGEGEBEN+PFLICHT = async Erstellung/Upload der Binary-Artefakte auf `minio.comdare.de`; (b) **synchron** = git-Push **und** Mess-Rückschrieb-Sink (Storage-Naht-Doktrin, I/O-Contention = Messfehler). **Plan V2 voll freigegeben (§53).**

> „Du bist jetzt ein experte Software Architekt und Manager und delegierst Arbeit über die Phasen des neuesten Plans an Opus 4.8 max-effort Agenten." / „GO"

---

## PHASE 6 — S1-Implementierung, 5 parallele Opus-Agenten (Z. 976–1505)

### (c) Paketmeldungen (alle lokal verifiziert, **nicht committet**)

**A1 P-TOTAL** — `COMDARE_GN_TOTAL` an beiden Grenzen.
- Diagnose: Variable nur im DEPRECATED statischen `.golden_n_build`-Job (`:710`), an keiner Trigger-Grenze; Konsument `TOTAL="${COMDARE_GN_TOTAL:-16}"` (`experiment_plan_director.hpp:668`).
- Fix: globaler `COMDARE_GN_TOTAL: "131072"`; an beiden Grenzen `variables: {COMDARE_GN_TOTAL: "$COMDARE_GN_TOTAL"}` + `forward: {yaml_variables: true, pipeline_variables: false}`.
- **Wichtig:** GitLab hat **kein natives Per-Variable-Allowlist-Feld** — die kanonische Umsetzung ist genau diese Konstruktion. Allowlist = exakt `{COMDARE_GN_TOTAL}`, mit Begründung je Nicht-Aufnahme (`COMDARE_GOLDEN_N_PROFILE` bleibt Runtime-Export; CHUNK_COUNT ist CT-Literal; GN_RANGE Legacy; Gate-Vars super-lokal).
- Beweis: mit Forward `TOTAL=131072` → Fenster `0:32768`. Neuer Contract-Test `CebTriggerForwardsGnTotalAsExplicitAllowlist`. cf22 EXIT=0, ctest #248 1/1, Mojibake 0.
- **Architekt-Ratifikation:** globaler Default **131072** (nicht 16) — ein 16-Default würde die stille „grün-aber-16"-Fehlklasse reproduzieren; Doppelsperre = `COMDARE_BUILD_GOLDEN_N`-Gate + `when:manual`.

**A2 P-OBS** — `axis_observer_classification.hpp:58/:60` telemetry+isa von `SearchAlgorithmObserver` → `DefinitionOnly` (17 SA / 9 DefinitionOnly / 0 Container = 26). Rest des Codes stand längst auf 17 (`kCompositionAxisNames=17`, `kV3AxisCount=17`, `ObserverAggregate<17>`). **golden- und ABI-NEUTRAL** (nur constexpr-Diagnosetabelle + 2 Tests) — entgegen der Plan-Einordnung „golden-relevant". `kSegmentCount` existiert im Parser **nicht** (lebt in super `diagram_generator.hpp:194`, leitet bereits aus `kV3AxisCount+1` ab). H-10-Sidecar bereits implementiert (`profile_run_facade.cpp:340-350`). prt-art telemetry-Demo-Slot **nicht** implementiert (ROADMAP K-28 offene Entscheidung, bewusst nicht geraten). ctest 2/2, cf22 rc=0, Mojibake 0.

**A3 P-W12A3** — `measurement_line`/`measurement_len` **append-only** an `AnatomyVersionLines` (`anatomy_module_abi_v1_decl.hpp:133-134`), `kAnatomyVersionLinesLayout` 1→2, neues Gate `static_assert(sizeof == 56)` (vorher 40), `alignof==8`. Neue Fn `measurement_stamp_line(tooling)` — **nur Tooling-HAUPT** im Stempel. `COMDARE_ANATOMY_VERSION_STAMP_M` (3-arg) + rückwärtskompatibler 2-arg-Forward. **Plan-Korrektur:** das im Plan genannte `sizeof==1272` ist `ComdareTierObserverSnapshot` (`observable_tier.hpp:152`), NICHT AnatomyVersionLines → A3→A4-sizeof-Übergabe hinfällig. ctest 8/8, Round-Trip-Byte-Wache grün, binary_id/CRC unberührt. **Koordinationsrisiko:** A3 editierte die Makro-Region in der A4-Owner-Datei → Manager schickte Koordinationshinweis.

**A4 P-KONFORM (verschlankt)** — 3 von 4 Items bereits erledigt (all_axes-Rename `4f7f645f`; reflect_versions<17> registriert; SampleStatus→"failed" `122c1783`). Genuin offen und implementiert: **#1-Fix Organ-only-binary_id-Guard** in `profile_to_tree.hpp` (Helper `is_organ_composition_axis`, Guard bei `:82`) → nur die 17 Organ-Achsen erzeugen binary_id-Level; **Struktur statt Autor-Konvention**. Kollateral: 3 Tests von System-Achse `isa` auf Organ-Achse `memory_layout` umgestellt. **build-i2 war reine Build-Tree-Staleness, KEIN Include-Root-Gap** (die 17 nicht-existenten `-I` sind symmetrisch/harmlos in beiden Trees) → Reconfigure+Rebuild genügt, **kein Code-Fix**; Ledger §26-L5 umdeuten. Prosa-Drifts gefixt, aber `composition_factory.hpp` „Slot 12 von 19" **bewusst faithful erhalten** (isa ist entfernt, nicht Slot 12) — vom Manager **ratifiziert**. Verifikation: build-conf **252/252**, build-i2 **8/8**, golden-roundtrip 320 literal, cf22 EXIT 0, Mojibake 0.

**A5 P-HYBRID + K-5** — **K-5 war bereits am 19.07. gefixt** (`best_binary_selector.hpp:49 kAbiMajor=6`, `:51 .A6.`); die Task-Prämisse und Ledger §50:2633 / §52:2701-D6 sind **selbst stale**. Scaffolding: natürlicher kubischer Spline (Thomas-Algo) + `spline_intersections`, `PiecewiseCurve`/`BreakEvenPoint`/`SelectionObjective`(Strategy)/`HybridBinarySelector`, decision_lambda_trees-Brücke — **kein std::variant** (§49-Grenze dokumentiert). Eigener Randfall-Bug gefixt (Bisektion Grid-Treffer d==0). ctest 3/3, 33/33 Checks. **Fehler+Fix:** A5 meldete zunächst „cf22 lokal nicht verfügbar" — falsch, Pfad ist `/home/comdare/tools/cf22/usr/bin/clang-format-22`; Manager verifizierte selbst (5/5 rc=1!), schickte A5 zurück → nach Reformat **5/5 rc0**, ctest weiterhin 3/3.

### (b) Manager-Entscheidungen / Ausführungsdisziplin
- Integrator-Verifikation im **kombinierten Tree**: cf22 **20/20 OK**, Mojibake **0**, golden-roundtrip 320, reflect_versions<17> 6/6, hybrid-scaffold, m-w12-stamp, br3/d7b — alle grün.
- **Commit-Split:** golden-neutral (A1+A2+A4+A5) sofort committfähig; **ABI-Touch A3 (POD 40→56, layout 1→2, CRC-neutral) braucht USER-GO** (§15.10-G).
- Nicht-blockierende Follow-ups getrackt: SampleStatus „failed" auch auf Aggregat-Metriken; prt-art telemetry-Demo-Slot (K-28); `composition_factory`-Historie faithful.
- **Trust-but-verify** als Prinzip etabliert (A5s cf22-Fehltreffer wurde nur so gefunden).

---

## PHASE 7 — Architektur-Erklärung + §54-Korrekturen T1–T7 (Z. 1336–1575)

### (a) User-Direktive
> „Bitte erkläre mir die aktuelle Architektur mit deinen Worten"

Fable lieferte eine 15-Abschnitt-Erklärung (Experiment-Maschine, dreistufige Kette, §24 Haupt/Unter, drei Achsen-Gattungen, Freigabe-Prinzip, Anatomie, B+-Baum, Meta-Meta, Metaprog-Doktrin, Legenden-Kette, golden).

### (a) User-KORREKTUR (wörtlich, bindend → §54-T1–T6)
> „Kleine Ergänzung zu den Organ-Achsen: die Tier-Binaries haben nach außen immer für den Vertrag ein einheitliches Gattungs-Interface für die Hülle, die sie bezüglich Suchalgorithmen/Container -Typen verkörpern. Jede Gattung bildet ein einheitliches Basis-Interface, welches per Metaprogrammierung auch für Tier-Typen erweitert sein kann. Es gibt KEINE Achsen Gattungen, sondern Achsen-Typen. Es gibt Tier-Binary Interface-Gattungen (Namensauflösung war falsch). Die measurement_categories sind eine Unter-Achse des Mess-Toolings im Planer, sowie auch alle vom Anwender verlangten Methoden, die Ergebnisse zurückzuschreiben. Zur Freigabe: der System-Achsen an die Organ-Achsen: Die Organ-Achsen sind die freigegebenen System-Achsen plus die eigentlichen 17 Organ-Achsen, einkompiliert mit Stempel in die Tier-Binaries. Der Baum ist je Achsen-Typ, weil Gattung nur das Interface bezeichnet. Eine Meta-Meta-Achse führt dazu, dass die Hardware-Haupt-Achse diese Meta-Meta-Achsen verwaltet und freigibt und die Meta-Meta-Achsen dann nach dem command Pattern als eigenständige Instanz Freigaben an die Organ-Achsen erteilen. Damit wächst die eigentliche System-Achsen und Organ-Achsen Zahl dynamisch je System-Eigenschaften der Maschine auf der alles läuft. Der Tier-Build array ist unvollständig, lies ihn nochmal nach, Measurement ist extra."

### (a) User-Präzisierung T7 (wörtlich)
> „Das ist jetzt korrekt, und weil die Meta-Meta-Achsen selbst durch eine statische hardware Haupt-Achse verwaltet werden, wird diese Haupt-Achse auch beauftragt die Existenz aller Meta-Meta-Achsen zu permutieren (an/aus), was zu einer zweischichtigen Kern-Permutation in einer managenden Haupt-Achse anderer Meta-Meta-Achsen führt. Grundsätzlich wird also dadurch in der nächst höheren Stufe (CEB -> Tier-Binaries) einmal Tier-Binaries mit wechselnden oder ganz fehlenden Hardware-Erweiterungen gebaut, wobei die Meta-Meta-Achse dennoch eine volle Haupt-Achse ist, die zur compile time ausgerollt wird. Du hast es korrekt verstanden. Bitte starte einen ultracode workflow, um die TODOs in den Diplom-Arbeit TODOs aus dem letzten Kontext in einer neuen konsolidierten Version gegen ALLE Ledger Einträge in Batches zu erweitern und fehlendes zu ergänzen. Die erste Beschreibung in deinen Worten und die aktuelle Korrektur in deinen Worten sind dabei perfekt korrekt und Maßgeblich. In einem zweiten Schritt starte einen ultracode workflow um den Plan v2 auf v3 gegen die Korrekturen zu updaten, erweitere diesen v3 Plan mit einem zu allererst durchzuführenden Audit auf Konformität bezüglich der falsch zusammengezogenen Architektur. Ich kann die nächste Stufe des Plans nur freigeben, wenn wir eine saubere Grundlage nachweisen können. Der Plan v3 behält die Struktur von v2 genau bei und ist eine dann erweiterte exakte Kopie der Plan v2 Version"

### (b) §54-T1–T7 (persistiert, korrigiert §47/§48/§51 additiv)
- **T1** Gattung = **Tier-Binary-INTERFACE** (Hülle), nie eine Achse; Achsen nach **TYP** {Organ/System/Mess}.
- **T2** `measurement_categories` **UND Rückschrieb-Methoden** = Mess-Tooling-**UNTER-Achsen im Planer** (nicht „passive CSV-Spalten"; sie *manifestieren* sich als Spalten).
- **T3** Einkompilierter Achsen-Satz = **freigegebene System-Achsen ∪ 17 Organ-Achsen, alle gestempelt**; `binary_id` = 17-Organ-Kern.
- **T4** Permutations-Baum je **Achsen-TYP**, nicht je Gattung (E3 „B+-Baum pro Gattung" falsch).
- **T5** Meta-Meta per **COMMAND-Pattern**: Hardware-Haupt-Achse verwaltet+gibt frei; jede Meta-Meta-Achse erteilt als eigenständige Instanz Organ-Freigaben → Achsen-Zahl wächst **dynamisch je Maschine**.
- **T6** **Tier-Build-Array vs. Measurement getrennt:** `tier:build:[a,b,c][d,e,f]:chunk<k>` = Mess-HAUPT × System-HAUPT × gebündelter 2^17-Organ-chunk (nur Haupt-Achsen, kein Organ); Measurement **EXTRA**: `measure:[a,b,c][d,e,f][g,h,i]`, `when: manual`, GN-11/320er-gegatet.
- **T7** **Zweischichtige Kern-Permutation:** Schicht 1 = Existenz (an/aus) jeder Meta-Meta-Achse, Schicht 2 = deren Werte; Existenz-Wahl compile-time; CEB baut Binaries mit wechselnden **oder ganz fehlenden** HW-Erweiterungen.

**S1 bleibt bewusst pausiert** (uncommitted im Working-Tree) — A3-GO steht aus **und** S1 soll erst gegen den Konformitäts-Audit gehalten werden.

---

## PHASE 8 — §55-Konsolidierung + Plan v3 + S0-Audit (Z. 1576–1714)

### (d) Fehler + Fix (Workflow-Handling)
- Erster Kurator-Output **unvollständig** (69 Zeilen, nur Infra/Konformitaet/Bookkeeping — Header, Exec-Summary und 5 Stränge fehlten wegen Output-Längenlimit) → Split in **3 parallele Teil-Kuratoren** (G1 Bau+Mess+Header, G2 Thesis/Hybrid/Storage, G3 Infra/Konformitaet/Bookkeeping), Batches aus Cache via Resume `wf_ca6274fb-b2c`.
- Parse-Fehler beim Skript (verschachtelte Backticks im Template-String) → Skript in Datei ausgelagert.

### (a) User-Direktive (Redundanz-Prüfung, wörtlich)
> „Ich sehe, dass du Kuratoren zu G1, G2, G3 gestartet hast, aber diese Punkte sind redundant und die älteren dieser Redundanz schon eine Woche her, bitte prüfe manuell ob dass mit den Kuratoren so stimmen kann. Dann weiter wie geplant. Lass den Workflow bitte durchlaufen"

**Manuelle Verifikation (Ergebnis positiv):** Batches haben im `status_geaendert`-Feld alle Wochen-alten Vorkommen korrekt gemappt (INC-0 in 4 §-Ranges, 9dim, §38-Dock, Migration, page_type, Break-Even, W11, ISA-Fork-A). Zusätzlich **falsch-erledigte** gefangen: **#266** (config-Owner-Gate ist noch offen — §48 hatte es fälschlich unter „Erledigt") und **#262/7b-3**. Cross-Group-Dedup sauber; Mehrfach-Vorkommen sind intendierte Offen/Erledigt-**Splits**. **Zwei „stale-als-offen"-Punkte** (K-5, #1-Organ-only-Guard) sind ledger-treu, weil die S1-Integration pausiert ist → beim S1-Commit nachziehen.

### (c) §55 + Commits
- **§55 — KONSOLIDIERTER GESAMTBLOCK v2** (architektur-korrigiert gegen §0–§54, löst §48 **additiv** ab; §48 bleibt als Vorstand mit Superseded-Marker). 226 Zeilen assembliert, 8 Stränge, 0 Mojibake. Ledger jetzt 2955 Zeilen. Commit **`24fa2d6`** (beide Remotes ref-gleich).
- Exec-Summary §55: (1) new-golden = Bau-PFLICHT §51-B1; (2) Mess-Vollzug Design final/Impl offen; (3) Experiment-Planer als 3. Framework-App existiert NICHT = größter Bau-Block; (4) neue Achsen-Konzepte S10/S11; (5) Gattungs-Vervollständigung = LETZTER ABI-Schritt; (6) Hybrid-Binary Abgabe-Pflicht; (7) Mess-Smoke 24.07. + 320er-Messlauf 28.07.
- **`763243a`** — Architektur-Dokument in eigenen Worten: `docs/architektur/2026-07-20-cache-engine-architektur-in-eigenen-worten.md` (13 Abschnitte, §54-T1-T7-korrigiert).

### (a) User-Direktive (Break-Even + verworfene Referenzen, wörtlich)
> „Hinweis: Der Punkt zur Auswertung von Break even ist wie vieles weiterhin im Plan zu halten, um die Hybrid-Tier-Binaries korrekt zu bilden. Bitte persistiere die ‚verworfenen' Referenzen als Erinnerung für später und starte auch einen ultracode workflow um diese zu finden, wir machen das separat NACH dem Gesamtplan und schauen, was wir wiederverwenden können. Die meisten Konzepte sind im Kern noch valide und dienen späteren Auswertungsstufen. Nach dem Plan müssen wir die Erinnerungen mit reichem Kontext auf wiederverwendbarkeit gemeinsam durchgehen und durch Rückfragen wieder einbauen, sofern sie dem aktuellen Stand nicht wiedersprechen. Weiterhin hatte ich dich heute mehrfach gebeten, das Projekt in eigenen Worten wiederzugeben, bitte erstelle eine reiche finale Version in deinen eigenen Worten und lege sie als Architektur Dokument ab. Dann weiter mit dem Hauptstrang und der erneuten Plan-Überarbeitung + Audit."

> „Bitte merke dir die reiche finale Architektur in deinen Worten als allererstes nochmal komplett zu überarbeiten, sobald die beiden Workflows da sind. Alles andere weiterhin wie gehabt."

→ Als getrackte Aufgabe **#5** verankert (höchste Priorität nach Workflow-Rückkehr).

### (b) Plan v3 + S0-Audit (Workflow `wf_337625a5-5f9`, Output gesichert als `para-v3.md`, 75 Zeilen, **noch nicht integriert**)
- v3 = exakte v2-Kopie (570 Zeilen) + Erweiterungsblock; v2-Fließtext wird **nicht physisch geändert** (Alt-Zitate = Historie), Korrekturen gelten als „wo v2 X sagt, gilt Y (§54-T#)".
- **9 Terminologie-Korrekturen KORR-1..9:** KORR-1/2/3 (S4, Z.74/264 — T2+T6, Hauptlast) · KORR-4 (Z.416 „nicht übernommen", T2) · KORR-5/6 (S10, Z.294/302 — T5 Command + T7 2-Schicht) · KORR-7 (S10 Z.303 — T3 Freigabe-Achsen-Satz) · KORR-8 (S12 Z.357/358/361 — T1-Anker) · KORR-9 (Z.46/453 — „6/7 System-Achsen" wird dynamisch).
- **Bereits §54-konform, kein Change** (gegen Phantom-Jagd): T1 (kein „Achsen-Gattung" im Plan), T4 (kein „Baum je Gattung"), T6-Notation (`ceb:build:[a,b,c]` und volle Legende koexistieren korrekt).
- **S0-Audit** (7 Pakete, zu allererst, Gate): je Paket binär **SAUBER** (literaler Beleg) oder **RESIDUE/LÜCKE** (Datei:Zeile → Folge-TODO). Kein ✓ ohne literale Ausgabe.

### Live-verifizierte S0-Vorschau (Reader-Befunde im Ist-Code)
- **T1/T4 SAUBER:** `topics/axis.hpp:17-20` `AxisKind = {organ, system_measurement, system_config}` — **kein `genus`-Enumerator**.
- **T3 SAUBER:** `profile_to_tree.hpp:96` guardet binary_id auf die 17 `kCompositionAxisNames`.
- **T6 SAUBER:** `plan_legend.hpp:18-19, 109-116` trennen `tier:build:…:chunk<k>` und `measure:…[g,h,i]` sauber.
- **T5/T7 = LÜCKE, kein Verstoß** (Meta-Meta-Array ist S10-Bauziel; heutiger Familien-Knoten ist CT/vtable-frei/binary_id-neutral → zielarchitektur-kompatibel).
- **EINE echte Residue (T2), blockierend:** **`plan_legend.hpp:69`** bildet den `[a,b,c]`-HAUPT-Slot noch aus `measurement_combo(categories)` statt aus dem Mess-Tooling — exakt die „falsch zusammengezogene" Stelle; deckt sich mit dem ohnehin geplanten §47/S4-Umbau.

### Verworfene-Referenzen-Finder (`wf_98b50d3d-772`, **fertig am Chunk-Ende**, noch nicht persistiert)
Gruppe A (hohe Wiederverwendbarkeit) u.a.: **A1** DLL-Load Option A (Arena-Kontamination — Negativbeleg für Allokator-Fairness) · **A2** `workload_matrix.hpp` (mp_product-Enumeration für Workload-Unter-Achsen) · **A3** V32-Orchestrator/`execute_messreihe` (SUPERSEDIERT→reaktiviert als offizielles Planer-Skelett; Welch-t-Test SdT-vs-Prüfling) · **A4** WP-1 Parallel-Mess-Engine (nur Konzept-Transfer: Debug-Parallel-Modus, fail-loud-Fehlerklassen, injektives `key_for`) · **A5** Legacy-Mikrobench V37.C/V38.C (Alt-Referenzkurve für Break-Even, bewusst nicht getilgt) · **A6** golden==320 als Alias/Doppel-Anker + 2^17 als einer von 4 Sweep-Stützpunkten {2^14,2^17,2^20,2^23} · **A7** Reihe C = 2 Auswertungs-Views · **A8** CoR-Selektions-Filterkette (`selection_filter_chain.hpp:87`, heute Dead-Code, Keimzelle der Resolver-Stufe) · **A9** F-SPREAD/Max-Kontrast (INC-G7) · **A10** Break-Even-Option 2 (Zwischenform) · **A11** variant unbegrenzt → limitiert · **A12** MeasurementVisitable-Concept.

---

## (e) Offene Fäden am Chunk-Ende

**Unmittelbar blockierend / wartend:**
1. **USER-GO für das kleine Version-Line-ABI-Gate (A3, POD `AnatomyVersionLines` 40→56, layout 1→2, CRC-neutral)** — steht seit Z.1498 aus; ohne GO kein S1-Commit.
2. **S1 komplett uncommitted im geteilten Working-Tree** (22 ce-Dateien + super/.gitlab-ci.yml, 5 Pakete verifiziert, kombinierter Tree grün) — bewusst pausiert, auch um S1 gegen den S0-Audit zu halten. **Working-Tree-Freeze-Risiko:** mehrere Agenten haben denselben Tree editiert.
3. **Beide Workflows sind jetzt zurück** (`wf_337625a5-5f9` v3+S0 und `wf_98b50d3d-772` Finder) → **getrackte Aufgabe #5 zuerst: komplette Überarbeitung des Architektur-Dokuments in eigenen Worten.**

**Danach in dieser Reihenfolge (vom Manager angekündigt):**
4. v3-Block in `20260720-SESSION-PLAN-V3-*.md` integrieren (Struktur von v2 exakt beibehalten), committen/pushen.
5. **S0-Konformitäts-Audit formal ausführen** — Gate; der User gibt die nächste Plan-Stufe erst nach literal nachgewiesener sauberer Grundlage frei.
6. Erinnerungs-Doku der verworfenen Referenzen persistieren (`docs/…-verworfene-referenzen-erinnerung.md`); Wiederverwendungs-Prüfung **separat nach dem Gesamtplan**, gemeinsam per Rückfragen.
7. **Blockierender Folge-TODO aus S0:** `plan_legend.hpp:69` (T2-Residue) — Teil des S4/§47-Umbaus.

**Ledger-Nachzüge, die beim S1-Commit fällig sind:**
- **K-5 erledigt** (§50:2633 + §52:2701-D6 sind stale — `best_binary_selector` steht seit 19.07. auf `kAbiMajor=6`/`.A6.`).
- **#1 Organ-only-Guard erledigt** (A4).
- **§26-L5 / §20.D-B2/B4 umdeuten:** „Include-Root-Gap" → „stale Build-Tree" (17 fehlende `-I` sind symmetrisch/harmlos).
- P-OBS/`kSegmentCount`-Plan-Notiz korrigieren.

**Getrackte Nicht-Blocker:** SampleStatus „failed" auf Aggregat-Metriken (total_ns/ns_per_op/13 Legacy-Counter rendern noch „0") · prt-art telemetry-Demo-Slot (K-28, offene Entscheidung) · `br4_load.cpp:69` `organ_count()==19` (IAnatomyBase-ABI, eigener Begriff) · `test_obs_phaseB_pilot.cpp:6` stale „19"-Header · prod1-Runner 18.9.0 Update-Entscheid (P12) · PAT-Rotation #327 (Security, S2/A3) · #266 config-Owner-Gate zurück auf offen.

**Termin-Rahmen am Chunk-Ende:** 24.07. = alles baut + messbar (BAND-A) · 28.07. = **Zwischen**-Abgabe (320er-Messdatensatz + Hybrid-Binary + Thesis-PDF) · ab 01.08. = new-golden-Voll-Messung (BAND-C) · kritischer Pfad S1→S8 unverändert; alle großen Erweiterungen (S10–S23) als parallele Stränge dahinter, kein Strang wird ausgelassen.