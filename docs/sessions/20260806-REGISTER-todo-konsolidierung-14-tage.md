# TODO-KONSOLIDIERUNG 14 TAGE (06.08.2026, ultracode + adversariale Direktiven-Gegenpruefung)

> Owner-Auftrag vormittag-5. Quellen: 4 Lenses + Konsolidierer + Direktiven-Pruefer (Rohdaten backups/20260806-todo-konsolidierung/). Dieses Doc = beschlossene Fassung; Board neu aufgesetzt daraus.

# KONSOLIDIERTES REGISTER — Offene Posten/Auflagen gesamte Kette (Stand 06.08.2026)

**Methodik:** Zusammenführung dreier Lens-Ergebnisse (Ledger 23.–31.07., Ledger 01.–06.08. inkl. Live-Repo-Checks, Dossier/Doku-Register) plus Live-Lesung des Fahrplans `docs/plaene/20260806-FAHRPLAN-parallel-sequenz-optimiert.md` (Sequenz-Autorität für Klassenzuordnung). Status-Verdikte sind aus den Lenses geerbt; keine darüber hinausgehende Code-Verifikation. Klassen = Owner-Reihenfolge P0–P4 (bindend, frueh-7/-9) + VOR-ABGABE/OWNER-FENSTER/PHASE-6/NACH-ABGABE. Sortierung je Klasse = Ausführungsreihenfolge laut Fahrplan-DAG.

---

## P0 — Neuanker-Kette (CE-Slot, läuft)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **Neuanker-Teil-2 / T2-Welle** (wf_996f7155; Branch b2-neuanker-format3; „C-3-Auflagen" CX-B1/CX-B2/CX-B3; NB-2-Nachreview-Auflagen 1×KRITISCH+5×MITTEL+1×GERING) | Abschluss der Format-3-Welle in wt-b2: Merge 7969b399 + F1/F4 Zähler-Resume + per-Perm-Glieder + RT-Realversions-Sonde + NB-3-Härtungen + C-4-Rest, inkl. aller harten Review-Auflagen (Skip-Gate-Kollision Glied[5], Realversions-FAIL-OPEN, Preimage-Hex, string_view-Dangling u. a.). | OFFEN (in Arbeit; unkommittierte Änderungen an anatomy_fingerprint/toolchain_stamp_glied/toolchain_stamp_naht live verifiziert) | Ledger 4239/4287; Fahrplan Z.12 |
| **L1 Bündel-Landung** | Serielle Lead-Landung der T2-Welle nach Dual-Review + Voll-Gate + grüner Pipeline; hebt das TABU auf den 3 C-3-Dateien und Neuanker-Naht-Dateien auf. | OFFEN (blockiert auf T2-Fertigstellung) | Fahrplan Z.8/12 |
| **TP1+4+1** (B10; V7.4-„4+1"-Beweise; G6 J-0..J-5; TP1-Neun-Gates-Inventur) | EINMALIGER Re-Lauf der Neun-Gates-Inventur + 4+1-Beweise (V7.4/B10, Variant-Gate-E2E) auf dem final geeichten Neuanker-Stand, direkt nach L1. | OFFEN (blockiert auf L1) | Ledger 4265/4297/4384/4217; Tab. B B10 |
| **Stempel-/RF-Rest-Verifikation** (G2/#36-Rest; RF-1 measurement_meta_meta; RF-2/RF-6/RF-7/RF-8; C-3a/C-3b-Kette §69.9/70.9) | Nachweis, dass die 26.07.-Entscheide (Meta-Meta-Kategorie, D1-CSV, target_isa-Glieder/build_version-Stempel, Stempel-Klammerung, telemetry-Sweep-Achse, C-3a-Folge-GO) im heutigen Stempel-Stand (Versions-Flag-Grammatik 04.08., Format-3) tatsächlich aufgegangen sind. | OFFEN-UNGEPRUEFT (kein individueller Schließbeleg; vermutlich in Neuanker-Kette absorbiert — ultracode-Gegenprüfung bei L1 empfohlen) | Ledger §70 L3576-3581; Lens-1 #10/26/27/28; Memory Stempel-KERNe |

---

## P1 — B13 / B14 / Posten-92

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **Posten 92 (P92)** | Abgleich/Heilung validate-2er vs. plan-3er; Leitplanke: „Posten 92 vor Abgabe" Pflicht; Slot direkt nach TP1+4+1, vor B13. | OFFEN | Fahrplan Z.9/12 |
| **B13 L18-ETA / headless-CLI** | ETA-Teilmenge als headless-CLI bauen; Plan FERTIG (abend-7), Gate W5/W3 (Gate 408) erfüllt — aber Re-Anker-Pass fehlt (wt-b13-eta live noch auf Alt-Stand b4110cd0). | OFFEN | Ledger abend-5/-7; Tab. B B13; Fahrplan Z.12 |
| **B14 GOLDEN-XML + Sync-Gate-Umhängung** (F27-Eskalation experiment_golden.xml-Kanonik; „B14+KF-6-XML") | GOLDEN-XML-Abgleich + Umhängung des Sync-Gates vom Alt-Paar; gekoppelt mit KF-6-XML (line_sizes-Vollausbau A4 im golden-XML); Super-Slot, jederzeit einschiebbar, Re-Check nach L1 als Auflage; VOR Messbeginn Pflicht. | OFFEN (**WIDERSPRUCH:** Ledger „Welle gestartet" vormittag-6 vs. live kein wt-b14-golden-Worktree) | Ledger 4366 (Owner-A7); struktur-audit :327-328; Fahrplan Z.9/13 |
| **KF-6 Cacheline-NTTP-Vollausbau, Bau-Teil** (B6-Bau-Teil; kLbufBytes-OOB-Fix abi_adapter:454-464; schlafendes Literal axis_05:60) | Alle 4 line_sizes {32,64,128,256} HW-gated vollparametrisch, inkl. OOB-Fix; Entscheide 74/77/78 sind gefallen (Variante a, ERLEDIGT), Bau steht aus (bisher nur Kartierung). | OFFEN | Ledger 3939/4211/4366; Tab. B B6 |

---

## P2 — Messwert-Lager (VOR Messbeginn, Leitplanke 4)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **P2-P8-Schema** (P2-P8-Katalog-Klärung + Bau) | WIDE-Mess-Schema: Katalog-Quelle in A8-S3-Backups lokalisieren + Schema-Delta beziffern (read-only, SOFORT frei), dann ce-Bau-Anteil (nach A1-Scheibe). | OFFEN | Fahrplan Z.12/14; Memory Mess-Schema-KERN |
| **A1-Scheibe Wurf-Vertrag** (Posten 71/72/73/74; Vorbild Posten 64 = ERLEDIGT) | PmrResourceAdapter-nullptr-Durchreichung (71), Überlauf-Wache n*sizeof (72), cacheline-Default-Literal (73), OOM-Roh-Route layout_aware append_slot (74) — Reihenfolge: nach B13, vor P2-P8-Bau, VOR Messbeginn. | OFFEN | Ledger 3936-3946; Fahrplan Z.12 |
| **Lager-Kaskaden + xlsx-GERÜST** (B12-Gerüst; „Lager+xlsx"; Teil #46b-Vollausbau/G3-Rest; Bestandslog-Zielbild) | Ordner-Kaskaden + xlsx-Default-Writer-Gerüst (Owner-KERN xlsx=DEFAULT, Strategy CSV XOR xlsx) VOR Messbeginn; Füllung → P4. Auflösung des Quellen-Widerspruchs: Analyse vormittag-4 („B12 keine Voraussetzung für P2-P8") betrifft nur das WIDE-Schema, das Gerüst bleibt Pflicht. | OFFEN | Tab. B B12; Ledger 4222; Fahrplan Z.9/13; Lens-1 #3/#11 |
| **B5 Mess-Schnitt-Fenster** (T6-Einsammel-Naht + Posten-68 Option B Doppelzählungsregel) | Umsetzung der abend-11-Doktrin (04.08.) im P2-Fenster; Entscheid gefallen, Bau offen. **Achtung Namenskollision:** B5 (dieses) ≠ B-5-Lebend-Check (P4). | OFFEN | Tab. B B5 |
| **#46b-Restumfang** (G3-Rest: XML-Bestandslog-Persistenz, avg_size-Log, Gleichverteilung/Takeover) | Restbestand des #46b-Vollausbaus nach Herauslösung von RAM-Puffer (ERLEDIGT), ETA (→B13) und xlsx (→B12): tatsächlicher Restumfang unbeziffert. | OFFEN-UNGEPRUEFT (Dekomposition nicht sauber belegt — bei P2-Start abgrenzen) | Lens-1 #3/#11; Ledger §62-B-N2 L3434 |

---

## P3 — Trigger / Voll-Bau / Phase 6 (Trigger-Ziel Do 07.08.)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **Trigger + Voll-Bau-4** (#215; Zähler-Resume-Batches; GOLDEN-XML=Input) | Voll-Bau-4-Trigger nach P0-P2-Vollzug; Batches mit Zähler-Resume. | OFFEN | Fahrplan Z.15/19 |
| **Phase 6 = USER-GO-STOPP** | Harter Stopp: Phase 6 startet nur mit explizitem Owner-GO. | OFFEN (Gate by design, kein Bau-Posten) | Fahrplan Z.9/15 |
| **Lager-Gate G1** (#27 B/C/D + amd24) | Landung vor Voll-Bau-4-Trigger; Tasknummer #27 im Nummernraum mehrfach belegt. | OFFEN-UNGEPRUEFT (kein eindeutiger Schließbeleg) | Ledger §66 L3476 |
| **Ebene-B-Push-Aktivierung** (G4/P-A; #34/#33; Design wf_87301637) | MinIO-Push der Voll-Bau-Binaries in emittierten Batch-Jobs ist INERT — Aktivierung vor/mit Voll-Bau. (P-C measure_out = ERLEDIGT.) | OFFEN-UNGEPRUEFT | Ledger §65 L3452-3456; §66 L3480 |
| **Lager-Gate G5** (P-B Pruning lokal→0, verify_remote_then_prune) | Lokales Pruning nach Remote-Verifikation; an G3/G4-Vollzug gekoppelt. | OFFEN-UNGEPRUEFT | Ledger §66 L3481 |
| **Forecast-Platzpflege + df-Wache** | +33G-root-Kandidaten, `/var/mnt/coldstore` nirgends gemountet; Platz-Monitoring beider Maschinen während Voll-Bau (laufende Doktrin). | OFFEN-UNGEPRUEFT (Live-Disk-Stand vor Trigger prüfen) | Ledger §65 L3457-3459/3467 |
| **OD-7 Runner-Zahlen HEAVY/NORMAL** | `runner-mode.sh normal\|heavy` gebaut, ABER **WIDERSPRUCH zur Owner-Direktive:** normal blieb 3/2 statt 2/2 beidseitig, heavy prod1 auf 16 Kerne gekappt statt 24 Worker — vor Voll-Bau klären. | OFFEN (Rest; Kern gebaut mit Abweichung) | Ledger §69.6 L3570; Memory runner_concurrency |
| **E8 PMC-Beleg-Form** | Reicht Permutations-A/B als PMC-Beleg je Achsen-Thema? TRIAGE routete nach A8-S3 (gelandet 04.08.), aber **WIDERSPRUCH:** keine Methodik-Bestätigung im Landungstext auffindbar. | OFFEN-UNGEPRUEFT (vor Trigger klären) | achsen-katalog :831-832; Ledger 3833 |

---

## P4 — Darstellung/Kanal + B-Rest (nach Trigger)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **honest-empty** (wf_ca7f3d30; Fix-Commit ba5e48eb) | Fixture-Falle „0.0000-Heatmap" heilen; Fable-LANDEBEREIT, Codex-Review + Landung nach development stehen aus; Voraussetzung für B-5-Lebend-Check. | OFFEN (landebereit) | Ledger 4318/4320; Fahrplan Z.13 |
| **B-5-Lebend-Check** (E-2b Voll-Korpus) | Voll-Korpus-Lebend-Check VOR Scharfschaltung des E-18-Kanals. **Namenskollision:** ≠ B5 Mess-Schnitt (P2). | OFFEN (blockiert auf honest-empty-Landung) | Ledger 4318/4320; Fahrplan Z.16 |
| **E-18-Aktivierung** (Scharfschaltung `anhang:forward`) | CI-Job bleibt INERT bis B-5-Lebend-Check + Owner-Entscheid R2 (Zielbranch); Bau selbst ist ERLEDIGT (B1). | OFFEN | Tab. B B1; Ledger 06.08. früh |
| **E18-SNAP** (E-1-Präzisierung) | Datierter Snapshot-Ordner (PDF+Log+SHA) je Kanal-Lauf an Messwerte-Wurzel; Arbeits-Annahme `measurement/thesis_compiles/JJJJMMTT-HHMMSS/` unwidersprochen = baubar; Super-Slot nach B14+KF-6-XML. | OFFEN (kein Worktree/Commit) | Ledger 4306; Fahrplan Z.13 |
| **Graph-Umbau 2D/3D** (Graph-Darstellungs-KERNe 06.08.) | Umsetzung der 2D/3D-Graph-KERNe; SOTA-Katalog liegt. | OFFEN | Fahrplan Z.16; Memory e18_snapshot_graph-KERNe |
| **B12-Füllung** | xlsx-Lager-Füllung während/nach Messung (Gerüst → P2). | OFFEN | Fahrplan Z.13/16 |
| **B2 E-04-Vollausbau** (A7-Rest; §68c-CI-Live-Fortschritt + generische Interface-Nachtests) | Vollausbau nach E-04-P1 (gelandet 02.08., Marker-Familie v2); **WIDERSPRUCH:** 2 ungelandete Patches rescue/w2b (92ad8357/63406ce3) vs. Ledger-„gelandet" ungeklärt. | OFFEN (Teil erledigt) | Ledger §68c L3554/3656; Tab. B B2 |
| **B3 OS-U4/A14-Rest + Z-04-Tests** | OS-U3 hat 0 produktive Konsumenten; Rest-Ausbau + Tests. | OFFEN | Tab. B B3 |
| **B4 A4-12-Perm-Paket + FS1-Testschuld** (iterator:1812) | Perm-Paket + Testschuld; **WIDERSPRUCH/Terminrisiko:** Auflage „spätestens vor Messung" vs. P4-Einordnung nach Trigger. | OFFEN | Tab. B B4 |
| **B8 D-10/L11-Referenz-Eichung + J-Hygiene L2 + Zitat-Drift** | Referenz-Eichung und Zitat-Heilung. | OFFEN | Tab. B B8 |
| **B9 P11-Pre-Flight-Checkliste + Phasen 3-5 ausfalten** | „Blackbox=Verlustklasse"; **WIDERSPRUCH:** inhaltlich Pre-Flight VOR Trigger sinnvoll, im Fahrplan aber P4 nach Trigger. | OFFEN | Tab. B B9 |
| **B11 Posten 19 stale build/** | Bereinigung stale build/-Bestände; **Vorsicht:** build/ enthält getrackte Mess-CSV (Memory-Falle) — vor rm prüfen. | OFFEN | Tab. B B11; Memory ce_build_dir_csv |

---

## VOR-ABGABE (Einordnung unklar — ultracode-Prüfung nötig)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **R-G/OD-2/OD-1-Refactoring-Bündel** (load_framework→Mess-Realm; target_isa-Komplex-Wrapper; telemetry-Zweiteilung) | 3 Achsen-Architekturentscheide vom 26.07. mit „umfassendem Refactoring"; Teilaspekt durch A3/L22-STRUKT-R (ERLEDIGT) gedeckt, Rest ohne Vollzugsbeleg — möglicherweise in A8-Wellen aufgegangen. | OFFEN-UNGEPRUEFT | Ledger §69.1-69.3 L3560-3564; Lens-1 #23 |

---

## OWNER-FENSTER

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **R2 E-18-Zielbranch-Entscheid** | Owner-Entscheid über Zielbranch des E-18-Kanals; gated die E-18-Scharfschaltung. **Namenskollision:** ≠ R2 „Driver-Split" (Post-v3-Register). | OFFEN | Ledger 4318 |
| **Map-Gattungs-Kern-Reichweite** | Zählen SA-Zusatz-Subinterfaces zum Map-Gattungs-Kern? Zielfenster C7/A8-S3 gelandet, aber keine Owner-Antwort gefunden (deklariert in idriveable_tier.hpp:31-34). | OFFEN | gattungs-diskrepanz :369-373; struktur-audit :337-338 |

---

## PHASE-6

| Kanon-Name | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **E7 Multi-Thread-Messfläche** (T8/q1) | Multi-Thread vs. 1-Thread-Kanon: Phase-6-Doktrin-Frage; Default 1-Thread bleibt bis dahin. | OFFEN | achsen-katalog :829-830; Ledger 3833 |

---

## NACH-ABGABE

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **SF-1 anatomy→builder-Aufwärtskante** (container_framework.hpp:37→genus_binding_traits.hpp) | Einziger echter Schnitt-Fehler; Owner-bestätigt nach Abgabe (A6, 05.08.). | OFFEN (Owner-terminiert) | struktur-audit :133-149/321-323; Ledger 4366 |
| **SHORTCUT-R1 T6-Peak-Quelle** | Peak-Spalte bewusst `n/a` statt Zeitreihen-Ableitung; als Regression+TODO nach E-4-Doktrin geführt. | OFFEN (bewusst) | Ledger 4309/4222 |
| **E4+E14 Registry-Erweiterungen** (T17-Min/Max-Semantik; Filter-„ohne"-Lücken T14/T16/C-A) | Registry-Erweiterung = golden-320-Bruch → eigenes golden-Neuanker-Fenster nach Abgabe (Owner-V5 B0 bestätigt). | OFFEN (geparkt) | Ledger 3833; achsen-katalog :822-823; Owner-Vorlage-V5 |
| **E10 Vollausbau-Fenster Container-Varianten** (GoldenRatio/FixedChunk/Exact) | Vollausbau-Fenster; **Eingabe an dieser Stelle abgeschnitten** — Klasse per Analogie zur E-Triage vermutet. | OFFEN-UNGEPRUEFT | achsen-katalog :835ff (trunkiert) |
| **Writer-Backend io_uring/IoRing** (SIDECAR-Spool 1b; Teil von §62-B-N2 3-Familien) | Plattform-Beschleuniger-Backends hinter CT-Strategy; portables Backend (W11) gebaut, Rest als „nicht-blockierende Phase-4-Optimierung" geparkt — **Einordnung Phase-4 vs. Nach-Abgabe im Ledger nicht eindeutig.** | OFFEN (geparkt) | Ledger §62-B-N2 L3436; §66-N4 L3531-3540 |
| **Tools-Lagerhaltung #32** | Alle Toolchain-Binaries in MinIO-Lagerhaltung, einheitliches Namensschema; explizit POST-ABGABE. | OFFEN (by design) | Ledger §65 L3449 / §66 L3485 |
| **K5 Template-Parametrisierung** | Echte `<T>`/`<Key,Value>`-Parametrisierung der Anatomie-Hüllen; mehrfach nach Abgabe bestätigt. | OFFEN | gattungs-diskrepanz :374-376; Ledger 3848 |
| **A8-S6 Kommentar-Kandidaten** | 17 stale-Kommentar-Stellen (abi_adapter/observable_tier/search_algorithm_anatomy/iterator/perm_runner); Teil des §75-Aufräumpasses. Überlappt teilweise Posten 45. | OFFEN | Ledger 3804/3875 |
| **Aufräumpass Posten 33** | SetDock/SetPruefDock-Doppelschicht je Dock-Datei. | OFFEN | g8_negativliste :239 |
| **Posten 34** | Nummerierungs-Drift CMake-Kommentare (a/5 vs a/2). | OFFEN | ebd. :240 |
| **Posten 35** | SA-Dock ohne `dock_version()`-Member. | OFFEN | ebd. :241 |
| **Posten 36 (Aufräumpass)** | P11-A-Rest: 29 K1-Prosa-Stellen „SearchAlgorithm-Gattung". **Namenskollision:** ≠ #36 Stempel-Finalisierung (G2). | OFFEN | ebd. :242 |
| **Posten 37 (Aufräumpass)** | `kAdapterCompositionSlotCount==13` (frozen) vs. live 11. **Namenskollision:** ≠ #37 PMC-Preflight (ERLEDIGT). | OFFEN | ebd. :243 |
| **Posten 38** | 4 `perm_*`-Prüflings-Module absichtlich defekt — beim Aufräumen NICHT reparieren. | OFFEN (Schutzvermerk) | ebd. :244 |
| **Posten 39** | abi→builder-Altkante cache_engine_execution_engine_adapter.hpp:14-16 (V32-Insel); 0-Konsumenten-Beweis erst nach Abgabe. | OFFEN | struktur-audit :174 |
| **Posten 40** | topics→anatomy Policy-Bausteine, Ziel-Ort offen (G8-gesperrt bis Abgabe). | OFFEN | ebd. :175 |
| **Posten 41** | organ_location.hpp in anatomy/, 79 Aufwärts-Konsumenten (ggf. mit 43 bündeln). | OFFEN | ebd. :176 |
| **Posten 42** | builder/-Dünn-/Stub-Verzeichnisse + thread_pinning.hpp-Einordnung. | OFFEN | ebd. :177 |
| **Posten 43** | axes/ vs. topics/ Doppel-Wurzel (binary-berührend) — EIGENES FENSTER. | OFFEN | ebd. :178 |
| **Posten 44** | Terminologie-Sweep-Erweiterung (176+18 Treffer, Kommandos im Dossier). | OFFEN | ebd. :179 |
| **Posten 45** | Stale-Zahlen-Kommentare observable_tier.hpp/anatomy_base.hpp (Überlapp mit A8-S6). | OFFEN | ebd. :180 |
| **Posten 46** | G8-Par.1.2-Dateitabelle fortschreiben; Ziel war „nächstes ce-Fenster nach A8-S3" — A8-S3 gelandet, live verifiziert NICHT nachgezogen. | OFFEN | ebd. :181 |
| **Posten 47** | SA-Matrix-Asymmetrie kommentieren (V2-Zelle). | OFFEN | ebd. :182 |
| **Posten 48** | e24-Label-Nachzug (18/37 Tests). | OFFEN | ebd. :183 |
| **Posten 49** | 3 Testnamen ohne `test_`-Präfix. | OFFEN | ebd. :184 |
| **Posten 50** | Verweis auf „Gruppe 3 super-Kandidatenliste" — **Eingabe trunkiert, Inhalt hier nicht rekonstruierbar.** | OFFEN-UNGEPRUEFT | ebd. :185 |
| **Posten 51** | ce docs/INDEX.md + architecture/INDEX.md fortschreiben. | OFFEN | ebd. :186 |
| **Posten 52** | ce docs/architektur/ (dt.) Einzeldatei überführen. | OFFEN | ebd. :187 |
| **Posten 53** | Kompositions-Platzierungs-Asymmetrie vereinheitlichen (G8-berührt). | OFFEN | ebd. :188 |
| **§75-Startliste a–f** | V36.B-Kanal-Dateien, permutations_runtime_check.hpp, COMDARE_apply_simd_flags (0 Aufrufer), cmake/permutations.cmake, _IDS-Alias, historisierte Auflagen-Hinweise. | OFFEN | Ledger :3601 |
| **thesis_profiles-Ort** | „WAS im WIE-Haus" — NUR-KENNTNIS, kein Handlungsbedarf vor Abgabe. | OFFEN (Kenntnis) | struktur-audit :329-330 |
| **axes-interner Rekursions-Sweep** | Optional, A8-S5-nah. | OFFEN (optional) | struktur-audit :339-340 |

---

## ERLEDIGT (Beleg-Register)

| Kanon-Name (Aliasse) | Beleg |
|---|---|
| **RAM-Sammelpuffer-Kern** (N-13; B6-SpoolWriter + W11-Async-Push-Pump) | §66-N4 „REALISIERT" (26.07.) |
| **VERLUSTNAHT measure_out** (G4/P-C; #33-Anteil) | „Stand 03.08. GESCHLOSSEN", code-verifiziert experiment_plan_director.hpp:1015-1020/1379-1386 |
| **PMC-Preflight #37** (G4a-Auflage) | „Stand 03.08. GEBAUT", experiment_plan_director.hpp:1269-1280 |
| **A3 kSystemAxisOrder = 3 Glieder** | L22-STRUKT-R-Quittung 04.08., system_axis_order.hpp:41-45/102-111 |
| **OD-10 NUMA/page-Umbau** | 03.08. spätnachts, numa_page_probe.hpp, 17 Testfälle, Gate 331→332 |
| **Posten 64 StdAllocatorAdapter** | Gate 388→389, ce fb623528, main-FF beide Remotes |
| **B7 V4-Owner-Vorlage** | wf_6fc3324d, Owner A1–A9 beantwortet (abend-10 05.08.) |
| **B1 E-18-Kanal, BAU** (§68c-E-18) | ce 253bcd86 + super-Job anhang:forward 8131a9a2, live in origin/main — Aktivierung separat OFFEN (P4) |
| **B6-Entscheid-Teil** (74/77/78) | Variante a entschieden (abend-5 05.08.) — Bau → KF-6 (P1) |
| **super main-FF-Stand** | origin/main == github/main == da269bdc (ce 7969b399, Gate 408); laufende Pflege |
| **FK-8-Etiketten** | Entscheid „belassen + Kommentar-Heilung", mit C7-Commit gelandet (Ledger 3848) |
| **Graph-Sweep außerhalb Anatomy** | G8-Doc Abschn.5.2 (P11-B): explizit „ERLEDIGT" |
| **E1-E4-Dossier-Strang** | Fahrplan Z.18-19: 6/8 Pakete ERLEDIGT/SUPERSEDED, #215=Voll-Bau-4, Residuen im Board — kein eigenständiges offenes Paket |
| **G3-Kern** (A1-Lager-Rest Phase 1) | Header L3784, gelandet 04.08. früh — Rest → P2 (A1-Scheibe, Lager-Gerüst, #46b-Rest) |

---

## SUPERSEDED / GESCHLOSSEN

| Kanon-Name | Superseder |
|---|---|
| **Frist-Prognose 23.07.** (inkl. Opus-Kompressions-Maßnahme) | Mehrfache Neuplanung; aktuell: Abgabe Fr 08.08., Trigger Do 07.08. |
| **Fable-5-xhigh-Direktive §67** | ARBEITSWEISE v2/v2.1 KONSOLIDIERT (Opus5/Opus4.8/Codex-Rollen wieder eingeführt) — teilweise superseded |
| **Mapping-Reinheits-Doktrin §66-N3** | Präzisiert 26.07./02.08.: CEB geduldet, Tier verboten, Hybrid-Tier-Stufe einzige Ausnahme — kein offener Punkt |
| **A8-S2** | Nie vergeben (Volltext-Grep 0 Treffer; Sequenz S1→S3); kein Posten rekonstruierbar |
| **Struktur-Audit Abschn.9 Punkt 11** | Reine Scope-Grenzen-Deklaration, kein Handlungsposten |

---

## WIDERSPRÜCHE zwischen Quellen (explizit)

1. **OD-7 Runner-Zahlen:** Owner-Direktive (normal 2/2, heavy 24 Worker) vs. gebautes Ist (normal 3/2, heavy 16 Kerne) — einzige bekannte aktive Abweichung von einer Owner-Direktive; vor Voll-Bau klären.
2. **B9-Platzierung:** Vor-Trigger-Checkliste + „Blackbox=Verlustklasse" (Pre-Flight-Charakter) vs. Fahrplan-P4 nach Trigger.
3. **B4-Termin:** „spätestens vor Messung" vs. P4-Band nach Trigger (Messung folgt direkt auf Voll-Bau) — Terminrisiko.
4. **B2/E-04:** Ledger-„gelandet" vs. 2 ungelandete Patches 92ad8357/63406ce3 — Diskrepanz ungeklärt.
5. **B12/xlsx:** Lens-1 führt B12/#46b als P2-Pflicht, vormittag-4-Analyse als „keine Voraussetzung" — aufgelöst als Split Gerüst(P2)/Füllung(P4), Wortlaut der Quellen bleibt widersprüchlich.
6. **B14/KF-6-Welle:** Ledger „Welle gestartet" vs. live kein wt-b14-golden-Worktree.
7. **E8:** TRIAGE-Routung nach A8-S3 (gelandet) ohne auffindbare Methodik-Bestätigung im Landungstext.
8. **Writer-Backend:** „Phase-4-Optimierung" (Bau-Phasen-Bezug) vs. faktische Nach-Abgabe-Parkung — Einordnung uneindeutig.
9. **Namenskollisionen:** B5 (Mess-Schnitt, P2) ≠ B-5 (Lebend-Check, P4); R2 (E-18-Zielbranch) ≠ R2 (Post-v3 Driver-Split); Posten 36/37 (Aufräumpass) ≠ #36 Stempel / #37 PMC-Preflight; #27-Nummernraum mehrfach belegt.
10. **RF-/G2-/C-3a-Absorption:** Kein individueller Schließbeleg für RF-1/2/6/7/8, G2-Rest, C-3a — Annahme „in Neuanker-Kette aufgegangen" ist unbewiesen (P0-Posten Stempel-/RF-Rest-Verifikation).

## Erfassungslücken der Eingaben

- Ledger hat keinen Nachtrag-Header 28.–31.07. und keinen 01.08.-Block (Fensterlücke, von Lens-1/-2 bestätigt).
- Register-Eingabe trunkiert: Gruppe 2 endet mitten in E10; Gruppe 3 (super-Kandidatenliste, Posten-50-Ziel) fehlt vollständig; Tabelle B endet mitten in B14 — Restposten dieser Abschnitte können unerfasst sein.


---

# ADVERSARIALE DIREKTIVEN-PRUEFUNG (Befunde + Korrekturen)

Alle Quellen live gelesen (Ledger 3420–4414 vollständig, Fahrplan, Worktree-Ist). Der Direktiven-Maßstab war ab D-33 trunkiert — D-34ff. wurden aus dem Ledger-Live-Text rekonstruiert (Zitate mit Zeilenanker). Die Register-Eingabe war nach „Posten 36" trunkiert — Abwesenheits-Befunde zu NACH-ABGABE stehen unter diesem Vorbehalt. Hier das Ergebnis.

---

# ADVERSARIALE DIREKTIVEN-PRUEFUNG DES KONSOLIDIERTEN REGISTERS (Stand 06.08.2026)

**Methodik-Vermerk:** Maßstab D-1..D-33 wie übergeben; darüber hinausgehende Direktiven live aus `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (L3546–4414) rekonstruiert und als „D-L:<Datum/Label>" zitiert. Live-Checks: Worktree-Bestand (`wt-b14-golden` EXISTIERT, `wt-b13-eta` EXISTIERT NICHT MEHR), Fahrplan Z.1–20.

## BEFUNDE

**B-1 [HOCH | Frage 1+3] — R2 E-18-Zielbranch als OFFEN geführt, obwohl der Owner entschieden hat.**
Register: OWNER-FENSTER „R2 E-18-Zielbranch-Entscheid — OFFEN" + P4-Zeile „E-18-Aktivierung … bis B-5-Lebend-Check + Owner-Entscheid R2".
Direktive: D-L:06.08.-frueh-6 E-1 (L4328): „(a) development GEWAEHLT."
Konflikt: Das Register hält ein Owner-Gate offen, das am 06.08. früh gefallen ist (frueh-5 „NUR noch R2 offen" liegt chronologisch VOR frueh-6).
Korrektur: R2 → ENTSCHIEDEN (development); E-18-Aktivierungs-Gate reduziert auf B-5-Lebend-Check + Scharfschalt-Var (`COMDARE_ANHANG_FORWARD`; 289-Token/CI-Vars stehen seit frueh-5).

**B-2 [HOCH | Frage 1] — B9/P11-Pre-Flight nach dem Trigger einsortiert.**
Register: P4 „B9 P11-Pre-Flight-Checkliste + Phasen 3-5 ausfalten" (Widerspruch selbst vermutet, nicht aufgelöst).
Direktiven: D-L:05.08.-nachmittag-2 (L4171/4172): „Nachhol-Naht = Phase-5-Pre-Flight P11"; „Voll-Bau-4 faehrt mit aktivem Provider; P11 prueft das Env" · D-L:05.08.-mittag-12 (L4185): P3 = „Phasen 3-5 -> TRIGGER".
Konflikt: P11 trägt die Ebene-B-Enumerations-Nachholung und den Env-Check DES Voll-Bau-4 — nach dem Trigger sinnentleert; Phasen 3–5 sind per Owner-Einordnung Teil von P3 (vor Trigger).
Korrektur: B9-Kern (P11 + Phasen-3-5-Ausfaltung) → **P3, VOR Trigger**; nur nicht-trigger-relevante B9-Reste bleiben P4.

**B-3 [HOCH | Frage 1+4] — Lager-Gate G5 als P3-offen geführt, obwohl Owner-A8 es supersediert hat; Nachfolger fehlt.**
Register: P3 „Lager-Gate G5 (P-B Pruning lokal→0…) OFFEN-UNGEPRUEFT".
Direktiven: D-L:05.08.-abend-10 A8 (L4394): „G5-Pruning hiermit SUPERSEDE-vermerkt (durch Anker-Inventur-Additiv-Doktrin gedeckt; kein Loesch-Vorgang); O-3 als Board-Gate gefuehrt" · Anker-Inventur nachmittag-2: „Alt-Bestaende bleiben ADDITIV liegen — KEIN Loesch-Schritt."
Konflikt: Register führt ein nicht mehr existierendes Vor-Voll-Bau-Gate; der Nachfolger (O-3 Lösch-GO) ist nirgends benannt → Verstoß gegen die Nachfolger-Beweis-Pflicht („nichts auslassen").
Korrektur: G5 → SUPERSEDED (A8), Nachfolger = neue OWNER-FENSTER-Zeile **O-3 Lösch-GO** (lokal→0-Rückbau nur mit explizitem Owner-GO, nach Messfenster).

**B-4 [MITTEL | Frage 3] — B2-„Widerspruch" ist im Ledger längst aufgelöst.**
Register: P4 B2 „WIDERSPRUCH: 2 ungelandete Patches rescue/w2b (92ad8357/63406ce3) vs. Ledger-‚gelandet' ungeklärt".
Beleg: §68c-NACHTRAG (L3656): „die getrennten Staende 92ad8357/63406ce3 sind zur Falte 037300a6 vereinigt" — E-04-P1 IST gelandet; die rescue-Refs sind Vor-Falte-Historie.
Korrektur: Widerspruchs-Vermerk streichen. Zusätzlich Supersede sauber benennen: die Triage-Einordnung „A7-Rest VOR Trigger" (03.08., L3690/3719) ist durch die P0-P4-Abnahme (D-L:06.08.-frueh-9) auf P4 verschoben — Owner-gedeckt, Umfang unverändert (inkl. Mess-Phase-Marker-v2 E-04-P2/P4).

**B-5 [MITTEL | Frage 3+2] — B14-„Widerspruch" live widerlegt; fehlende Sequenz-Kante KF-6-Bau↔Trigger.**
Register: P1 B14 „WIDERSPRUCH: … live kein wt-b14-golden-Worktree".
Live-Beweis: `/home/comdare/wt-b14-golden` existiert (Prüfung dieses Laufs) — die Welle (vormittag-6: Kartierung→Bau) ist real angelaufen.
Zusätzlicher Direktiven-Konflikt (D-L:04.08.-abend-12, Posten-62c-WARNUNG „kLbufBytes … bei line_size>64 OOB — MUSS im KF-6-Fenster mitbewegt werden, NIE vergessen" + D-L:05.08.-abend-10 A7 „GOLDEN-XML = Trigger-Input-Basis"): Wenn B14/KF-6-XML line_sizes {128,256} in die Trigger-Input-Basis aufnimmt, der KF-6-**Bau**-Teil (OOB-Fix) aber nicht vor dem Trigger landet, läuft der Voll-Bau/Mess-Pfad in den OOB. Der Fahrplan-DAG führt KEINEN ce-KF-6-Bau-Slot.
Korrektur: Widerspruch streichen; harte Kopplungs-Auflage in beide Zeilen (B14 und KF-6): „KF-6-Bau-Teil MUSS vor Trigger gelandet sein, SOFERN das golden-XML line_sizes>64 trägt — sonst line_sizes-Erweiterung im XML zurückstellen (kein stiller Shortcut, E-4-Doktrin)."

**B-6 [MITTEL | Frage 3] — B13-Zeile stale.**
Register: „wt-b13-eta live noch auf Alt-Stand b4110cd0".
Beleg: D-L:06.08.-vormittag-11 (L4206): wt-b13-eta abgebaut („B13-Bau erfolgt ohnehin mit NEUEM Branch ab dev (Re-Anker-Pass, Plan-Auflage)"); Live-ls bestätigt Abwesenheit.
Korrektur: „B13 startet mit NEUEM Branch ab dev; Pflicht-Schritt 1 = Re-Anker-Pass aller W5-Zeilen-Anker am gelandeten Objekt (abend-7-Plan); W5/W3-Gate erfüllt (7969b399)."

**B-7 [MITTEL | Frage 3+2] — honest-empty-Status stale; neuer Folge-Posten fehlt.**
Register: P4 „honest-empty … OFFEN (landebereit)".
Beleg: D-L:06.08.-vormittag-8 (L4219-4222): Codex kippte auf NACHBESSERN ([HOCH] echte-0-Klassifikation, [MITTEL] 3D-Phantom-Vertex); NB-Welle läuft; Landung erst nach beidseitigem Verdikt. Zudem vormittag-6: Neben-Befund 1xN-/Nx1-Matrix bricht matrix plot fatal — „als B-REST-Kandidat registriert", fehlt als Register-Zeile.
Korrektur: Status → „NACHBESSERN läuft (honest-empty-nb)"; neue P4-Zeile „1xN-/Nx1-Matrix-Fatal im diagram_generator (Bestandsfehler)".

**B-8 [MITTEL | Frage 2+4] — O-2-Schließung unverbucht; TP1+4+1-Scope unvollständig.**
Register: O-2 (Preimage-Neuanker C1+C6, „letzter billiger Moment vor Trigger", L4117/4131) taucht nirgends auf — weder offen noch geschlossen.
Beleg: Format-3-SOLL (D-L:05.08.-abend-8, L4405): Glied [5] Toolchain heilt C1, Glied [6] bvset heilt C6, „owner_offen LEER"; vollzogen unter dem P0-Voll-GO (frueh-9). Ferner frueh-8: E2E-Beweis realer Tier-Bau (.rsp trägt Defines literal) OFFEN (bewusst) → TP1-Wiederholung; löst flottenweite Neubau-Welle aus.
Korrektur: (a) P0-Zeile „Stempel-/RF-Rest" um O-2-SCHLIESSUNGS-Vermerk ergänzen (O-2 = Option A, in Format-3-Gliedern [5]/[6] aufgegangen; Ratifikations-Vermerk in den L1-Lande-Text). (b) TP1+4+1-Zeile um den E2E-.rsp-Pflichtbeweis erweitern.

**B-9 [MITTEL | Frage 1] — Trigger-Zeile ohne bindende Auflagen; B8-Anteile gehören an die Trigger-Sequenz.**
Register: P3-Trigger-Zeile nackt; B8 (D-10/L11-Eichung + J-Hygiene L2) komplett in P4.
Direktiven: D-L:05.08.-mittag-12 (L4185): Trigger „NUR mit gruener W1/W2-Emission; 7-Auflagen-Satz LEDGER:98 woertlich" (nachmittag-10 erweitert: alle W-Wellen) · D-L:03.08.-spaetnachts (L3774): „TRIGGER-SEQUENZ (7-Auflagen-Satz LEDGER:98, J-Hygiene L2, D-10-Eichung L11)".
Konflikt: Auflagen, die den Trigger QUALIFIZIEREN, stehen nach dem Trigger — sinnwidrig; die Vollständigkeits-Auflage erlaubt Verschieben, aber nicht das Entwerten einer Trigger-Vorbedingung.
Korrektur: Trigger-Zeile trägt die Checkliste (7-Auflagen-Satz + grüne Emission ALLER W-Wellen + J-Hygiene L2 + D-10-Eichung L11); B8 in P4 behält nur Zitat-Drift-/Referenz-Heilung.

**B-10 [MITTEL | Frage 2] — Nach-Abgabe-Band nicht als geschlossene Kette (Vorbehalt: Eingabe trunkiert).**
Direktiven: D-L:05.08.-mittag-12 (L4185): „R3-Rest -> #35-.so -> #54-Endform-XML -> W3-Vollausbau -> Codegen-Zielform W2 -> K1-K4 -> Posten-Register" · Dauer-Regel mittag-6 („saubersten Weg IMMER als Nach-Abgabe-TODO") · R6 Planer-Takt-Vollausbau (mittag-7) · A5 Key-/Value-Filter-Achsen + Posten-60-Umzug (abend-10) · W-11 Cache-Key-Einfaltung (nachmittag-5) · Overlay-3-Festlegungen + Glied-[7]-Scharfschaltung (nachmittag-2 L14) · f2/f3-Remote-GOs (03.08.) · K1-K4-XML-Rückfragen (nacht-4) · Posten 90/91 · D-15 Vortrag.
Korrektur: Pflicht-Zeilen in NACH-ABGABE (Tabelle unten). Sofern die trunkierte Register-Hälfte einzelne davon trägt: dort gegenzeichnen statt doppeln.

**B-11 [KLEIN | Frage 3] — „Entscheide 74/77/78 ERLEDIGT" verdeckt offene Auflagen aus 77/78.**
Direktive: D-L:05.08.-abend-10 A2/A3: 77 = „Doku+Pin-Wache frei" (Bau-/Doku-Auftrag), 78 = „behalten + Einschraenkungs-DOKU PFLICHT … auch in Thesis-/Messbild-Doku".
Korrektur: ERLEDIGT gilt nur für die ENTSCHEIDE; neue Zeile für die Auflagen-Umsetzung (P2-nah bzw. Thesis-Band): kReal16-Doku+Pin-Wache (77), XorFilter-FN-Einschränkungs-Doku (78).

**B-12 [KLEIN | Frage 3] — Forecast-/Platz-Zeile stale.**
Beleg: 04.08. abend-5 (prod1 geheilt −8G; prod2 141G frei — Spiegel-Annahme WIDERLEGT) + 05.08. abend-9 (60G frei/75%). Offen: Infra-Lane builds_dir/cache_dir-Umzug + periodischer Cleaner + FF_USE_LEGACY_S3_CACHE_ADAPTER=false-Test (Handouts 5d3842e/7e2091f); df-Wache während Voll-Bau bleibt Pflicht (§65 FOLGEN iii).
Korrektur: Zeile auf Ist heben, Infra-Posten explizit benennen.

**B-13 [KLEIN | Frage 3] — E10 kann gefestigt werden.**
Beleg: Triage 04.08. mittags-2 (E10 → Phase 6.5/nach Abgabe) + C6-V-Katalog-Korrektur (C-A widerlegt: GoldenRatio/FixedChunk/Exact existieren → E10 „entschärft").
Korrektur: NACH-ABGABE bestätigt, Status OFFEN (entschärft), Vorbehalt „trunkiert" entfällt.

**B-14 [KLEIN | Frage 3] — R-G-Anteil des VOR-ABGABE-Bündels ist erledigt-belegt.**
Beleg: L22-STRUKT-R-KOMPLETT-QUITTUNG (L3789: kSystemAxisOrder == DREI + compile-harte Abgangs-Wache load_framework) + A13-M2 [5] (load_framework als Meta-Meta-Anhang der Mess-Zeile, L3649).
Korrektur: Zeile splitten — R-G = ERLEDIGT-BELEGT; Rest (OD-2-Wrapper-Vollform, OD-1-telemetry-Dual-Zeile) = OFFEN-UNGEPRUEFT, ultracode-Prüfpass bei L1 (kein Bau-Bündel vor Abgabe).

**B-15 [KLEIN | Frage 2] — P2-Lücke: G-E3-Host-Binder fehlt als Posten.**
Beleg: 04.08. früh (L3790): deklarierte Lücke „G-E3-Host-Binder fehlt (3 Iterator-cfg-Felder mess_bestand_* mit 0 Konsumenten — eigenes Fenster)" — das IST die Messwert→Lager-Verdrahtung; P2 = Messwert-Lager VOR Messbeginn (Leitplanke 4).
Korrektur: P2-Zeile ergänzen (bei P2-Start prüfen/einplanen).

**B-16 [INFO | Frage 4] — Fehlende Supersede-/Absorptions-Zeilen mit benanntem Nachfolger.**
(a) E1-E4-Strang: 6/8 ERLEDIGT/SUPERSEDED, #215→Voll-Bau-4 (P3), Residuen→P92/honest-empty — Nachfolger benannt (Fahrplan Z.18-19), gehört als eine Absorptions-Zeile ins Register. (b) D-16/§68c „E-04+E-18 VOR Trigger": teil-superseded durch P0-P4-Abnahme (frueh-9) — E-18-BAU erledigt (B1), Aktivierung→P4; E-04-Vollausbau→P4; als Supersede-Zeile ausweisen. (c) §66-G5 siehe B-3.
**B-17 [INFO] — E18-SNAP:** P4-Klassierung korrekt (frueh-7/-9); der Fahrplan-Super-Slot VOR dem Lager-Gerüst ist ein Vorzieher per Owner-Max-Parallelitäts-GO (frueh-15), kein P0-P4-Bruch — als Vermerk in die Zeile, damit die Promotion nicht als Regression gelesen wird.

---

## FINALE KORRIGIERTE KLASSEN-TABELLEN (nur geänderte/neue Zeilen)

### P0
| Kanon-Name | Änderung |
|---|---|
| **TP1+4+1** | Scope-ERGÄNZUNG: + E2E-.rsp-Beweis (Defines literal im realen Tier-Bau; löst flottenweite Neubau-Welle aus, frueh-8) — Pflichtteil des EINMALIGEN Re-Laufs. |
| **Stempel-/RF-Rest-Verifikation** | + O-2-SCHLIESSUNGS-Vermerk: O-2 (Preimage C1+C6) = Option A, vollzogen via Format-3-Glieder [5] Toolchain / [6] bvset (abend-8/Teil-1/T2); Ratifikation im L1-Lande-Text. Status bleibt OFFEN-UNGEPRUEFT nur für RF-1/2/6/7/8 + C-3a-Sichtbarkeits-Auflage 70.9 (per-Perm-Glied „gate" = Absorptions-Kandidat, bei L1 gegenprüfen). |

### P1
| Kanon-Name | Änderung |
|---|---|
| **B13 L18-ETA/headless-CLI** | Stale-Korrektur: wt-b13-eta EXISTIERT NICHT MEHR (vormittag-11-Abbau); Bau mit NEUEM Branch ab dev, Pflicht-Schritt 1 = Re-Anker-Pass aller W5-Zeilen-Anker. Gate W5/W3 erfüllt. OFFEN. |
| **B14 GOLDEN-XML + Sync-Gate** | Widerspruch GESTRICHEN: wt-b14-golden existiert live, Welle läuft. + NEUE KOPPLUNGS-AUFLAGE: line_sizes>64 nur ins golden-XML, wenn KF-6-Bau-Teil vor Trigger landet (OOB-Warnung 62c); sonst zurückstellen + Regression/TODO-Vermerk. OFFEN (in Arbeit). |
| **KF-6 Bau-Teil** | Präzisierung: „Entscheide 74/77/78 ERLEDIGT" gilt NUR für die Entscheide; 77/78-Doku-/Wachen-Auflagen als eigene Zeile (s. P2). + Trigger-Kopplung wie B14. OFFEN. |

### P2
| Kanon-Name | Änderung |
|---|---|
| **G-E3-Host-Binder** (NEU) | mess_bestand_*-Verdrahtung Iterator→Messwert-Lager (3 cfg-Felder, 0 Konsumenten; deklarierte Lücke der A1-Lager-Rest-Welle) — bei P2-Start prüfen/einplanen, VOR Messbeginn. OFFEN-UNGEPRUEFT. |
| **Posten-77/78-Auflagen** (NEU) | kReal16-Doku+Pin-Wache (A2) + XorFilter-FN-Einschränkungs-Doku inkl. Thesis-/Messbild (A3 PFLICHT) — vor Messbild/Messdeutung. OFFEN. |

### P3
| Kanon-Name | Änderung |
|---|---|
| **Trigger + Voll-Bau-4** | + Trigger-Checkliste BINDEND: 7-Auflagen-Satz LEDGER:98 wörtlich · grüne Emission ALLER W-Wellen · J-Hygiene L2 · D-10-Eichung L11 · aktiver Bestandslog-Provider + P11-Env-Check. OFFEN. |
| **B9 P11-Pre-Flight + Phasen 3-5** (UMKLASSIERT aus P4) | P11 = Phase-5-Pre-Flight (trägt Ebene-B-Enumerations-Nachholung + Env-Check des Voll-Bau-4); Phasen 3-5 sind P3 (mittag-12). VOR Trigger. OFFEN. |
| **Forecast-Platzpflege + df-Wache** | Ist-Update: prod1 60G frei/75% (abend-9), prod2 141G (Spiegel-Annahme widerlegt); OFFEN bleiben: Infra-Lane builds_dir/cache_dir-Umzug + Cleaner + Legacy-S3-Flag-Test (Handouts 5d3842e/7e2091f) + df-Wache beider Maschinen WÄHREND Voll-Bau (§65). |
| ~~Lager-Gate G5~~ | GESTRICHEN als P3-Gate — SUPERSEDED durch Owner-A8 (abend-10) + Additiv-Doktrin der Anker-Inventur; Nachfolger: OWNER-FENSTER O-3. |

### P4
| Kanon-Name | Änderung |
|---|---|
| **honest-empty** | Status-Korrektur: NACHBESSERN läuft (Codex [HOCH] echte-0 + [MITTEL] 3D-Phantom; NB-Welle honest-empty-nb); Landung nur nach beidseitigem Dual-Verdikt. OFFEN (nicht landebereit). |
| **1xN-/Nx1-Matrix-Fatal** (NEU) | diagram_generator bricht bei nur 1 Algo ODER 1 Workload fatal (Bestandsfehler, vormittag-6) — B-Rest-Kandidat. OFFEN. |
| **E-18-Aktivierung** | Gate-Korrektur: R2 ist ENTSCHIEDEN (development, E-1 frueh-6) — Rest-Gate NUR B-5-Lebend-Check + Opt-in-Var. OFFEN. |
| **E18-SNAP** | + Vermerk: Fahrplan-Super-Slot = Vorzieher per Owner-Max-Parallelitäts-GO (frueh-15), kein P0-P4-Bruch. OFFEN. |
| **B2 E-04-Vollausbau** | Widerspruch GESTRICHEN (92ad8357/63406ce3 zur Falte 037300a6 vereinigt, L3656 — P1 gelandet); + Supersede-Vermerk: Triage-„vor Trigger" durch P0-P4-Abnahme auf P4 verschoben (Owner-gedeckt); Umfang inkl. Mess-Phase-Marker-v2. OFFEN (Teil erledigt). |
| **B8** | Zuschnitt-Korrektur: J-Hygiene L2 + D-10-Eichung L11 → P3-Trigger-Checkliste; in P4 verbleibt nur Zitat-Drift-/Referenz-Heilung. OFFEN. |
| ~~B9~~ | → P3 (s.o.). |

### VOR-ABGABE
| Kanon-Name | Änderung |
|---|---|
| **R-G/OD-2/OD-1-Bündel** | SPLIT: R-G = ERLEDIGT-BELEGT (L22-Quittung L3789 + M2-Mess-Zeilen-Anhang L3649); OD-2-Wrapper-Vollform + OD-1-telemetry-Dual-Zeile = OFFEN-UNGEPRUEFT, reiner ultracode-PRÜFPASS bei L1 (kein Bau-Bündel vor Abgabe). |

### OWNER-FENSTER
| Kanon-Name | Änderung |
|---|---|
| ~~R2 E-18-Zielbranch~~ | ENTSCHIEDEN: (a) development (E-1, frueh-6, L4328) — aus dem Fenster streichen. |
| **O-3 Lösch-GO** (NEU, Nachfolger von G5) | Lokal→0-Rückbau/Pruning + Alt-Bestands-Löschungen NUR mit explizitem Owner-GO (A8-Supersede + Additiv-Doktrin; Remote-Löschungs-Memory). OFFEN (by design). |
| **O-1 Mess-GO** (NEU, deklaratorisch) | = Phase-6-USER-GO-STOPP (Querverweis P3-Zeile; mittag-2-Gate-Bestand O-1/O-3). |

### NACH-ABGABE (Pflicht-Zeilen, sofern nicht im trunkierten Teil vorhanden)
| Kanon-Name | Inhalt/Quelle |
|---|---|
| **R3-Rest CLI-Härtung** → **#35-.so-Schnitt (nur Steuerung)** → **#54-Endform-XML (Option b, direkt Endform)** → **W3-Vollausbau (Prüfstand-Deep-Research-Tests, F5)** → **W2-Codegen-Zielform + W-11 Cache-Key-Einfaltung** → **K1-K4-XML-Rückfragen (gebündelt, VERBOSE)** | Bindende Kette mittag-12 + Owner-Entscheide mittag-6 (R1-R7); Reihenfolge Owner-bestätigt. OFFEN (by design). |
| **Planer-Takt-Vollausbau (R6)** | Planer baut/ruft CEBs, CEBs rufen Hybride/Tiers; W5 = Vorstufe; resource_group = Ist-Träger bis dahin (mittag-6/-7). OFFEN. |
| **Key-/Value-Filter-Achsen (A5)** | MAP grundsätzlich Key- UND Value-Filter-Achse; Posten-60-UMZUG search_algo-Wrapper→Filter-Familie (Nachfolger-Vermerk!); T13-vs-T16 = Owner-Architekturentscheid; 4 Value-Optionen unbewertet (abend-11). OFFEN. |
| **Overlay-Fenster** | 3 Owner-Festlegungen (Verzeichnis-Schnitt/Sortierung/Hash-Form) + Scharfschaltung Glied [7] (layout-bruch-frei vorbereitet; L14-Lücke deklariert, nachmittag-2). OFFEN. |
| **E10 Vollausbau Container-Varianten** | BESTÄTIGT NACH-ABGABE (Phase 6.5), ENTSCHÄRFT durch C6-V-Befund (3 Growth-Policies existieren). OFFEN (entschärft). |
| **f2/f3-Remote-GOs · Posten 90 (Hybrid-Doc GoF+CT-Weitergabe) · Posten 91 (Hinweis-Regeln) · Vortrag (D-15)** | Je Einzel-Zeile, Owner-terminiert nach Abgabe. OFFEN. |
| **§75-Abschluss-Aufräumpass (Sammelzeile)** | EIN Paket am Ende (ultracode VOR+NACH): Kandidaten (1)-(89)+, Waisen-TU-7, Bestands-ASCII-Sweep GA-08, V36.B-Kanal-Dateien (TEIL-V-Retire-Vollzug = benannter Nachfolger von Bauplan-IV.2.10-Supersede), §75-NICHT-KANDIDATEN-Freihaltung (HY-D2). OFFEN (by design). |
| **Absorptions-/Supersede-Zeilen** (NEU) | (a) E1-E4-Strang aufgelöst: #215→Voll-Bau-4 (P3), Residuen→P92/honest-empty, Rest ERLEDIGT/SUPERSEDED mit Belegen (Fahrplan Z.18-19). (b) §68c-„vor Trigger" für E-18-Aktivierung/E-04-Vollausbau → P4 per P0-P4-Abnahme (frueh-9). (c) G5→O-3 (s.o.). Nachfolger je benannt — Vollständigkeits-Auflage erfüllt. |

---

## VOLLSTÄNDIGKEITS-VERMERK

1. Alle 4 Prüf-Fragen wurden über den vollen Direktiven-Bestand 23.07.–06.08. gefahren (D-1..D-33 aus dem Maßstab; D-34ff. live rekonstruiert aus Ledger L3546–4414, inkl. aller Owner-VERBATIM-Blöcke vom 04.–06.08.).
2. KEIN Posten wird gestrichen — jede Änderung ist Verschiebung, Status-Korrektur oder Supersede MIT benanntem Nachfolger (Owner-Auflage frueh-9 „wir lassen dennoch nichts in der gesamten Kette aus").
3. Vorbehalt: Die Register-Eingabe war nach „Posten 36" trunkiert; die NACH-ABGABE-Pflicht-Zeilen (B-10) sind gegen den trunkierten Teil gegenzuzeichnen, bevor sie als „fehlend" verbucht werden.
4. Zwei Zeilen verlangen Prüfung IM L1-Fenster (nicht später): Stempel-/RF-Rest-ultracode-Gegenprüfung (inkl. O-2-Ratifikations-Vermerk) und der VOR-ABGABE-Prüfpass OD-2/OD-1.
5. Live-verifizierte Fakten dieses Laufs: wt-b14-golden EXISTIERT, wt-b13-eta ENTFERNT, kein committetes Register-Doc mit Stand 05./06.08. unter super docs/ — die hier korrigierte Fassung ist damit die aktuellste.

---

## NACHTRAG 06.08. ~10:45 (Session-Log-Luecken-Explore + E1-E4-Karte + Journal-Vollpruefung — nachregistrierte Zeilen)

Quellen: Opus-max-Explore ueber alle 5 heutigen Transkripte (satzweiser Owner-Abgleich), E1-E4-Ueberschneidungs-Karte (backups/20260806-e1e4-ueberschneidungen/ergebnis-roh.json), explore-luecken-Posten (Ledger nacht-6 L3999 / mittag-2 L4044). KEIN Posten gestrichen — nur fehlende Register-Zeilen nachgezogen.

### P0-Ergaenzung
| **Atlas-Nachzug nach L1** | 05b-UML-Klassenatlas (REV 5, Stand 98eea2e7 = VOR W5/W3+Neuanker) nach der L1-Buendel-Landung auf End-Stand nachziehen, mit Korpus-Gegenpruefung (Dauer-Regel feedback_atlas_immer_korpus_gegenpruefung); auch die ce-Kopie (be4f0a16) nachfuehren. | OFFEN (gated auf L1) | Ledger vormittag-19 L4273 |

### P1-Ergaenzung
| **DELTA C golden-XML system_axes** | atomic128/target_isa fehlen im system_axes-Block der golden-XML — dokumentierte Folge-Zeile der B14-Kartierung; billigstes Fenster = B14-NB2/Verifikation bei B14-Landung. | OFFEN | Ledger vormittag-17 L4281 |

### P2/P3-Ergaenzung
| **Posten 89 T6-Rebound-Leaf-Einpreisung** (MESSTECHNIK-KENNTNIS, HOCH/zeitkritisch) | Seit Phase B materialisiert fremde T6-Wahl den Rebound-Leaf statt der Fassade -> Allokationszahlen steigen exakt um den Organ-Anteil; MUSS beim ERSTEN Vergleich gegen Alt-Mess-CSV eingepreist werden (sonst Falsch-Regressions-Lesung). | OFFEN (P2/P3-Checkliste) | Ledger mittag-2 L4044 |
| **Posten 88 anatomy_execution_context einarmig** | :50-63 zweiter Trait-Konsument einarmig — NICHT die Genus-Erst-Instanziierungs-Ausnahme; gegen die GENERALISIERTE SCHNITT-REGEL (04.08. abend-6) triangulieren. | OFFEN (mittel) | Ledger mittag-2 L4044 |

### P4-Ergaenzung: Aufraeumpass-KANDIDATENLISTE (fortgeschrieben, Owner-KERN: Liste statt Sammelwort)

> **ZEIGER (08.08.2026): HISTORIE — zusammengefuehrt in `docs/plaene/20260808-KANDIDATENLISTE-75-abschluss-aufraeumpass.md`.**
> Die hiesige 8er-/10er-Zaehlung ist der **dritte** Nummernkreis derselben Menge (neben der
> Ledger-Kette `(N)` und den `AP-01…AP-13`) — die zentrale Liste ordnet sie einander zu und vergibt
> keine neuen Nummern. **Nachtrag:** Posten 1 der Liste unten (leere 3D-caption) ist ERLEDIGT
> (super `7969a02c`), Posten 4 (Posten 73, cacheline-Default-Literal) ebenfalls (ce `0b5ed557`).
1. leere 3D-caption (write_surface3d data.title nie gesetzt; vormittag-14-Randbefund) 2. 1xN-Matrix-Bestandsfehler 3. Posten 86 (Kosmetik Commit-27ef28ea-Benennung) 4. Posten 73 cacheline-Default-Literal 5. A8-S6 17 stale-Kommentar-Stellen 6. Posten 45 stale-17er-Spuren 7. M1-M3 der Teil-2-Review 8. honest-0-MUSTERFORTSETZUNG: die honest-empty-Doktrin (nie-ausgefuehrt=Auslass, echt-0=eigene Klasse) auf kuenftige Writer/Graph-Umbauten uebertragen (E1-E4-Karten-Residuum).

### NACH-ABGABE-Ergaenzung
| **Posten 84 Observer-Copy-Semantik** | der migrierten 03a-Organe deklarieren (messwirksam inert, OBSERVER_PUSH Default OFF). | OFFEN (niedrig) | Ledger nacht-6 L3999 |
| **Posten 85 h81-Wachen-Haertung** | legitimer Overload-Satz macht Member-Pointer ambig -> bricht ill-formed statt erklaerender Meldung. | OFFEN (niedrig) | Ledger nacht-6 L3999 |
| **Posten 87 organ_hull_ Level-2** | ObservableComposedContainer ohne rebind_allocator. | OFFEN (niedrig) | Ledger mittag-2 L4044 |
| **Apple-Clang-Vendor-Kollision** | dokumentierte Grenze; Nach-Abgabe-TODO. | OFFEN (dokumentierte Grenze) | Ledger frueh-9 L4417 |
| **kDetectedCompilerIsKnown-static_assert** | sperrt Fremd-Toolchains der Test-Suite aus -> TODO Oeffnung/erklaerende Meldung. | OFFEN (niedrig) | Ledger frueh-9 L4417 |
| **#221-Rest T8 thread_count** | Setter vorhanden, bewusst NICHT als applied gezaehlt (In-Prozess-Tier ohne realen Konsumenten — ehrlich dokumentiert); Rest-Klaerung nach Abgabe. | OFFEN (by design) | E1-E4-Karte (backups/20260806-e1e4-ueberschneidungen/) |

### VOR-ABGABE-Klaerungszeile
| **DoD-7-Vollzugsstand Planer-Kette** | Phase-4-Abnahmekriterium ist von DoD-7 (LEDGER:205, E9 16.07.) ueberholt; Vollzugsstand war NICHT Gegenstand der E1-E4-Karte — vermutlich durch 982er-Wahrheits-Anker/Planer-Kette-Audit 05.08. gedeckt: GEGENZEICHNEN statt neu auditieren. | KLAEREN (billig) | E1-E4-Karte |

### Aufraeumpass-Kandidat Nr. 9 (NEU 06.08. mittags, aus Gate-8-Welle)
| **axis_inventory.tex nie eingebunden** | Die Facade SCHREIBT die Datei (Code/08_appendix_generator/appendix_generator.cpp:423), aber KEINE .tex des Thesis-Repos bindet sie ein -- dieselbe Luecken-Klasse wie die 23 Graph-Abbildungen (Gate 8), nur aelter/laenger unbemerkt. Braucht einen kleinen Owner-/Lead-Entscheid: in welchen Anhang-Abschnitt gehoert die Achsen-Inventar-Tabelle? | OFFEN (klein) | Gate-8-Welle wf_c974dbd3 |

---

## NACHTRAG V-01/A15: Ueberfuehrung des Paragraf-55-Blocks (20.07.) ins heutige System

> VOLLZUG des Postens, der die fehlende Uebertragung selbst angemahnt hatte (A15, LEDGER:4862 /
> LEDGER:4900). Owner-Auftrag verbatim 06.08.: "Bitte konsolidiere die gefundene fehlende Arbeit,
> sofern sie den neuen Plaenen und Aussagen nicht wiederspricht, die neuesten Aussagen gewinnen.
> Die Planung wurde schliesslich mehrfach erweitert und geaendert."
> Eingang: docs/sessions/20260806-DELTA-abc-straenge-vs-neue-wellen.md (V-01..V-20) + Alt-Block
> Paragraf 55 (LEDGER:2829-3060). Entscheidungs-Tabelle aller 20 Positionen: DELTA-Doc Abschnitt 6.
> Regel angewandt: NEUESTE gewinnt -- aber "alt" heisst NICHT "ungueltig"; wo nichts Neueres
> widerspricht, bleibt der Posten GUELTIG. Nichts ersatzlos gestrichen (Owner-Doktrin).
> BILANZ: 10 uebernommen . 4 superseded (Nachfolger je benannt) . 5 bereits erledigt (belegt) .
> 1 Owner-Entscheid noetig.

### VOR-ABGABE-Ergaenzung (aus Paragraf 55)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **V-19 STRITTIG-Vermerke D5/D6/D7** (Posten 30 test_s5-Tempdir . W12-B Cache-Key-Spiegelung . Goldener Coverage-Test #18) | Drei Vermerke, die A15 "gleich mit" schliessen sollte -- reine Doku-Vermerke, kein Bau: Posten-30-Tempdir-Kollision, W12-B-Cache-Key-Spiegelung (Pull-Key==Push-Key), #18 Goldener Coverage-Test (je Achse >=1 Config x alle Frameworks x Lastprofile). | OFFEN (billig, reine Vermerke) | synthese.md:148-150; LEDGER:2919 (#18); LEDGER:2972 (W12-B) |
| **V-14 A16 Posten-Register-Basis** ((2)-(18) + (25)-(29)) | Die Posten-Nummern (2)-(18)/(25)-(29) leben nur in Session-Docs/Backups, nicht in der Single-Source. Ohne Rekonstruktion ist die bindende NACH-ABGABE-Kette "... -> Posten-Register" (Register :344) nicht ausfuehrbar. | OFFEN (billig; Voraussetzung der Nach-Abgabe-Kette) | synthese.md:67-69 |
| **V-02-Rest Mess-Manifest/Provenance** (G8-Abgabe-Blocker-Rest) | Von V-02 verbleibt NUR der Mess-Manifest-/Provenance-Anteil: die Abgabe-CSV/PDF-Strecke muss ihre Herkunft belegen (Provenienz-Log + PMC-Beleg-Form). Anzuschliessen an die P3-Trigger-Checkliste und an E8. FF0-Anteil und Anhaenge-B/E-Anteil = erledigt/superseded (s. u.). | OFFEN | LEDGER:2940; Register P3 "E8 PMC-Beleg-Form" :56 |
| **V-08-Rest Anhang-A-Limitierung-1** | anhang/de/A_measurements.tex:11-12 (EN :10-11) sagt heute "Cache-Misses L1--L3 derzeit 0/nicht erhoben, vgl. Limitierung 1". Sobald die Voll-Bau-4-Messung reale PMC-Werte liefert, MUSS dieser Satz DE+EN nachgezogen werden -- sonst steht eine widerlegte Limitierung in der Abgabe. | OFFEN (daten-gated, an Phase 6 gekoppelt) | LEDGER:2917; anhang/de/A_measurements.tex:11; anhang/en/A_measurements.tex:10 |

### P2/P3-Ergaenzung (vor Messbeginn / vor Trigger)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **V-06-Rest ETA-Erst-Batch-Abnahme** (Nachfolge-Rest von GN-9) | Das GN-9-Feasibility-Gate selbst ist superseded (s. SUPERSEDED-Tabelle), aber sein Kern-Nutzen bleibt: das ERSTE Mini-Batch des Voll-Bau-4 liefert t/TU und Bytes/DLL -- diese beiden Zahlen sind VOR dem Weiterlaufen der Matrix gegen den Plattenstand abzunehmen (Abbruch-/Herabstufungs-Entscheid), statt eines separaten 1-Zellen-Vorlaufs. Gehoert als Punkt in die P3-Trigger-Checkliste. | OFFEN | LEDGER:2927 (Alt); Nachfolger LEDGER:3325 (ETA-Formel), :3429 (avg_size 2. Log-Wert); eta_estimator.hpp; Register P3 :313/:315 |
| **V-05-Rest #162 (>=8 Rang-1-SOTA-Lebewesen, HELD)** | Die FF-Gate-Kette AP-2 -> #162 -> #156/M3: mindestens 8 Rang-1-SOTA-Lebewesen im Katalog-Pfad. Die Stub-Seite der Kette ist erledigt (Quarantaene, s. ERLEDIGT-Tabelle); OFFEN bleibt der Zaehl-/Vollzugsbeleg im Katalog-Pfad. Vor Messauswertung Vollzug ODER ausdrueckliche Herabstufung (Shortcut=Regression+TODO). | OFFEN (HELD) | LEDGER:2915; Strang C HANDOVER-BEP-ABTEILUNG-20260705.md:41 |
| **V-17 A19 planer_block-Reaper-Folgewelle** | Bedingung "Zweit-Planer-Konsument real" ist durch den W1-Split erfuellt. STRITTIG mess-relevant: verfallene Reservierungen ohne Reaper koennten Messlaeufe beruehren (Regel "wer die Arbeit nicht uebernehmen kann, enteignet nicht" laesst planer_block stehen). Vor Messbeginn kurz bewerten, sonst NACH-ABGABE. | OFFEN (klein-mittel) | synthese.md:79-81; LEDGER:3630 (Folge-Beobachtung), :3790 (deklarierte Luecke) |

### OWNER-FENSTER-Ergaenzung

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **O-4 Anhang-A-Reichweite** (NEU; Traeger von V-04) | ENTSCHEID: Sollen die Auswertungs-Writer M-8 (Achsen-Sensitivitaets-/Varianz-Attributions-Writer), M-9 (vier Heuristik-Kurven sota_series/sweep_axis/seg_coverage/working_set_curve -> 08-Facade) und M-15 (Welch-Konsument als eigene WIDE-Auswertungsstufe) NOCH IN DIE ABGABE, weil Anhang A DE+EN an ihnen haengt -- oder bleibt Anhang A bei den heutigen Alt-Messreihen und V-04 geht komplett nach der Abgabe? Default-Vorschlag: NACH-ABGABE (Anhang A ist gefuellt und kompiliert). | OFFEN (Owner-Entscheid) | LEDGER:2923/:2924/:2925; anhang/de/A_measurements.tex (137 Z., gefuellt) |
| **V-11 #327 PAT-Rotation** (Security, Infra-Lane) | Exponierter Vault-PAT rotieren. Owner-Terminierung liegt vor: "NUR-KENNTNIS (Rotation nach Messfenster, Handout liegt)" -- damit NICHT mehr "SOFORT" wie im Alt-Block, sondern nach dem Messfenster, Cluster fuer diese Linie read-only. Zeile bleibt bestehen, damit die Rotation nach dem Messfenster nicht wieder verschwindet. | OFFEN (terminiert: nach Messfenster) | LEDGER:2993 (Alt "SOFORT"); Owner-Terminierung LEDGER:3727 |

### NACH-ABGABE-Ergaenzung (aus Paragraf 55)

| Kanon-Name (Aliasse) | Inhalt | Status | Quelle(n) |
|---|---|---|---|
| **V-07 #47 COMPARE (4. Modus je Maschine)** | Nach dem Release je Maschine vergleicht der COMPARE-Modus aus dem Mess-Replay die Sicht der gerade messenden Maschine; run_methodology erhaelt den 4. Wert `compare`, exactly-one je Call bleibt. Owner-KERN Paragraf 62-C, in der Paragraf-63-Voll-Freigabe namentlich autonom freigegeben. Einzuhaengen in die bindende NACH-ABGABE-Kette (Register :344). | OFFEN (by design, nach Release je Maschine) | LEDGER:3343, :3370; Abgabe-Blocker-Zeile LEDGER:2940 |
| **V-09 Hybrid-Bau + PL-19/PL-21 Gattungs-Docks** | Hybrid-Tier-Stufe (Heuristik-Hybrid aus realen Messdaten, Spline je Achse, Rueckwaerts-Wahl optimaler Binary-/Algo-Saetze) + rekursives Delegations-/Transport-Protokoll Hybrid-Tier<->CEB + Gattungs-Docks PL-19/PL-21 je Genus. Ist-Beleg heute: libs/cache_engine/hybrid/ enthaelt NUR README.md. Die Alt-Etikette "ABGABE-PFLICHT vor 28.07." ist superseded (s. u.), der Bau-Posten bleibt. | OFFEN | LEDGER:2952/:2959/:2940; Nachfolge-Verortung LEDGER:3529 (Owner-E1), :3602 (Paragraf-75-NICHT-KANDIDATEN, "Bau in der Auswertungsphase") |
| **V-10 L21-Phase-6.5-Behaelter** (Owner H.7 "Rest nach Abgabe PFLICHT") | Sammelbehaelter: E-01/E-03/E-06/E-16/E-17/E-25/E-26, G5/Matrix-Zergliederung, Paragraf 73.1 + 73.5-Q6, Paragraf 70.4-RF-4/Q4, O-6/OD-1, #327, K5, Posten 43. Register traegt bisher nur K5, Posten 43, OD-1 einzeln -- diese Zeile haelt den Behaelter als Ganzes. | OFFEN | synthese.md:118-120 |
| **V-12 #274 / G5 measurement-all-Modul-Migration** | Modul-Migration A1/A5/A7 (Schritte 8-15), funktionale Kategorien statt eigener Familie + Comdare-2D-Matrix; GO unter 3 Auflagen (A5-Master-Loeschung strikt je-Repo-GO+G7; Schritt 13 im Mechanismus supersediert; neue Remotes je-Repo-GO), ans Projektende geparkt. **NAMENSKOLLISION:** dieses G5 ist NICHT das Lager-Pruning-G5 (Register :53/:316 -> O-3); der dortige Supersede-Vermerk deckt diesen Posten NICHT ab. | OFFEN (geparkt, Projektende) | LEDGER:3007, :3050; Strang E HANDOVER-BEP-ABTEILUNG-20260705.md:45 |
| **V-15 A17 ce-Doku-Nachzuege** (Stufen-Doktrin C1) | Aktenkundiger Widerspruch: hybrid_tier_stufe_soll_design.md:286-288 fuehrt "[[System],[Organ]]" gegen den organ-freien Mess+System-Stempel-Kanon; C3/K4 superseded ohne Vermerk. Sachlich ist der Kanon entschieden (3 Realm-Zeilen + Fingerprint-Zeile, vierte Stempel-Zeile abgeschafft) -- OFFEN ist der DOKU-Nachzug. Register traegt bisher nur den Teil "Posten 46" (:129). | OFFEN (naechstes ce-Doku-Fenster) | synthese.md:70-74; Kanon-Beleg thesis 00876ea; Owner-KERN Stempel-Regression |
| **V-16 A25-Kleinposten ohne Heimat (8)** | SubAxisMembership-Folge-Increment target_isa . A9-S2 (freigegeben 04.08., nie gebaut -- gegen den Register-Vermerk "A8-S2 nie vergeben" :171 zu triangulieren, das ist eine andere Nummer) . A10/E-3 MSVC-/Cross-Fenster . Posten-83-Generalisierung . fill_observer_v3-Umzug + 8/9 SA-Slots . P10-Folge-Sweep . in_memory_measurement_buffer-.gitkeep etikettieren . OS-U5-Doku-Vollzug A-08. (G-E3-Host-Binder und W-11 Cache-Key sind bereits im Register.) | OFFEN (klein; Aufraeumpass-nah) | synthese.md:96-101 |
| **V-18-Rest A23/A24** | A23 = E-20 I112-Runner-Fleet-Handout-Push unbelegt (Infra-Lane). A24 = Aufraeumpass-Kandidat B-1: referenzlose `using SearchAlgo`-Aliase abi_adapter.hpp:440/:545 -- fehlte in der Kandidatenliste (Verstoss gegen Owner-KERN "Kandidaten-Liste fortschreiben") und wird hiermit als **Kandidat Nr. 10** nachgetragen. | OFFEN (klein) | synthese.md:91-92, :93-95; Kandidatenliste Register :380 + :393 |
| **V-20 Paragraf-55-Restposten (EINE Sammelzeile)** | Alle uebrigen Paragraf-55-Zeilen ohne benannten Nachfolger, gebuendelt mit Anker LEDGER:2829-3060: F12iii Telemetrie-aus-binary_id (:2873) . F2 native Set-ABI (:2871) . OF-1 Beschleuniger-Array GPU/FPGA/NPU (= 6. Systemachse/Q2) + Paragraf 37.2/3 Cross-Compile (:2891) . 3 vertagte Kern-Library-Punkte OptO*SubAxis-Namensfalle (:2875) . Paragraf-26-L5 INC-0-Rest build-i2 (:2887) . K-17 snmalloc-"failed"-Zelle (:2889) . S-7 Deep-Research Locking OptiQL/ARTSynchronized (:2897, genuin offener Owner-Entscheid :3050) . #179 Wartbarkeits-Sweep XL (:2893) . #185 io-tpie/EM-BFS (TODO-BOARD:18) . #225 Second-Execution (:3053) . #226 Appendix-Limitierungen (:2946) . #276 3-ISA "allerletzte Aufgabe" (:3006) . #270a P/E-Core (:2999), #270b arm64 (:2990) . #204 sanitize-hart+TSan (:3000) . avx512-Anschluss-Increment (:2996) . #266 config-Owner-Gate (:3004) . #254 OneDrive (:3008) . Paragraf-38-Rest (2) ExperimentSubtreePayload real emit/parse ODER deprecaten (:2879) . PhasenCheck-5.16-Rest (synthese.md:124) . Datensatz-Katalog 6-vs-48 user-gated (synthese.md:131) . B12-alt/F-SPREAD N-Paar-Wahl first-2 vs. Max-Kontrast (:2905, Namenskollision zum Register-B12 xlsx). | OFFEN (Sammelzeile, by design) | LEDGER:2829-3060; synthese.md:58-136 |
| **V-03-Rest Stufe-3-Umzugs-Auflage (Thesis)** | Die un-included Alt-Kapitel (kapitel/{de,en}/01_introduction, 02_fundamentals, 03_state_of_the_art, 04_concept_architecture, 05_implementation, 06_evaluation_methodology, 07_results_evaluation, 08_conclusion) tragen weiterhin "neunzehn Achsen"/"T0--T18" als GELTENDE Aussage. Sie kompilieren heute NICHT (diplomarbeit.tex:280-285 included nur die 6 Habich-Kapitel). AUFLAGE: bei jedem abschnittsweisen Umzug in die included Kapitel ist die Zaehlung auf 18/T0--T17 zu bringen ODER als historische Vorstufe zu kennzeichnen. Doku nie loeschen -- nur Deprecation-Kopf. | OFFEN (stehende Auflage) | diplomarbeit.tex:278-285; LEDGER:2926 |

### ERLEDIGT-Ergaenzung (Beleg-Register)

| Kanon-Name (Aliasse) | Beleg |
|---|---|
| **V-01 A15 Paragraf-55-Gesamt-Reconcile** | VOLLZOGEN mit diesem Nachtrag: 20 Positionen einzeln gegen den heutigen Stand geprueft, je Entscheid begruendet (DELTA-Doc Abschn. 6), Uebernahmen mit Besitzer in die Klassen-Tabellen. Anker: LEDGER:4862/:4900 (Anmahnung), LEDGER:4224-4232 (Delta-Verbuchung 06.08.). |
| **V-03 Thesis-Text "neunzehn Achsen" (Abgabe-Dokument)** | KEIN Abgabe-Defekt: diplomarbeit.tex included NUR kapitel/{de,en}/{01_einleitung,02_suchbaeume_grundlagen,03_messsystem_prtart,04_implementierung,05_evaluation,06_fazit} + anhang A-F (:280-295). In diesen Dateien ist JEDE Fundstelle von "neunzehn"/"nineteen"/"T0--T18" ausdruecklich als historische Vorstufe markiert ("Zwischenstand Juli 2026" / "interim state of July 2026"), DE+EN paritaetisch. Der Kanon 18/T0--T17 steht literal in 04_implementierung.tex:173 (EN :169) und 06_fazit.tex:35-37 (EN :36). Die 7 im Delta zitierten Stellen liegen ALLE in un-included Alt-Kapiteln -> Rest als stehende Auflage (s. NACH-ABGABE). |
| **V-05-Teil PRT-ART-Stub-Quarantaene** | VOLLZOGEN am Objekt: Quarantaene-Kopf "ALT-PFAD -- NICHT Teil des Mess-Pfads! ... traegt bewusst Stub-/Surrogat-Code -- sie darf NIE in den Mess-Pfad verdrahtet werden" in comdare-prt-art/prt_art/include/prt_art/identity/prt_art_pruefling_factory.hpp:2-6 UND prt_art_execution_engine_adapter.hpp:6 (AP-2-neu/#236 W4, 2026-07-07); ce-Gegenbeweis-Test tests/unit/thesis_tiere/test_ap2_katalog_pfad_stubfrei.cpp. Einziger Mess-Pfad = Katalog-Pfad (sota_catalog). |
| **V-08-Teil #152 Cache-Misses / I-PMC-2 / #165-quality_flag** | Am Objekt gebaut: measurement_snapshot.hpp:44-46 (cache_misses_l1/l2/l3), :77 (branch_misses), :162/:194 (CSV-Header), linux_perf_pmc_source.hpp:191-194 (L1 + LL real; L2 ehrlich 0, "kein RAW-Rateversuch"), windows_pcm_pmc_source.hpp:54-55 (L2/L3 via PCM), cache_engine_builder_iterator.hpp:475-480/:750-753 (pmc_branch_misses real erhoben + emittiert), #165-B annotate_quality_flags in profile_run_entry.hpp:605-609 + experiment_run_entry.hpp:244, PMC-Preflight #37 (Register :149). Rest s. VOR-ABGABE (Anhang-A-Limitierung) und NACH-ABGABE (I-PMC-3 Zen-5-RAW + system_disturbed-Provenienz, ausdruecklich GETRENNT deklariert in cache_engine_builder_iterator.hpp:334). |
| **V-13 rescue/e24-c3-wip-pause (0bac9fbe)** | GESICHERT + hiermit vermerkt: `refs/rescue/e24-c3-wip-pause` = 0bac9fbe83e5c5ae2cabd970cea0b6dd8c0dffe5 auf BEIDEN Remotes verifiziert (origin gitlab.comdare.local UND github). Der Namespace `refs/rescue/*` liegt ausserhalb `refs/heads/*` -> Branch-/Worktree-Abbau kann ihn nicht treffen. Der W3-Posten (Register :344) traegt damit seine Quelle. |
| **V-02-Teil Anhaenge-B/E-Stubs** | KEINE 4-Zeilen-Stubs mehr: anhang/de/B_code_structure.tex 257 Z. / E_architecture_decisions.tex 151 Z.; EN-Paritaet 256/153 Z.; alle sechs Anhaenge A-F included (diplomarbeit.tex:290-295). Anhaenge-Realm-Welle (8 Stuecke) gelandet auf 29a1700, thesis-Pipelines 14341/14343 gruen (LEDGER:3748). |

### SUPERSEDED-Ergaenzung (Nachfolger je benannt)

| Kanon-Name | Superseder (mit Beleg) |
|---|---|
| **V-06 GN-9 Bloat-/Kalibrierungs-Report als Feasibility-GATE** (1-Zellen-Lauf Range 0:64, t/TU + Bytes/DLL, "6-TB-Gate VOR Voll-Matrix") | (a) Owner-Klarstellung 23.07.: "die 6-TB-Rechnung bezog sich auf Cluster-Storage, nicht auf lokale Platten" (LEDGER:3443) -- die Gate-Begruendung entfaellt. (b) Die Messfunktion ist in die laufende Bestandslog-Maschinerie gewandert: Mini-Batch-ETA-Kalibrierung ueber max-Thread-Batch statt Vorlauf-Schaetzung (LEDGER:3325, eta_estimator.hpp) + avg_size als ZWEITER Log-Wert je Batch-Block (LEDGER:3429). (c) Der Platz-Schutz laeuft als P3-Zeile "Forecast-Platzpflege + df-Wache" (Register :54/:315). REST als eigene Zeile uebernommen (ETA-Erst-Batch-Abnahme, s. P2/P3). |
| **V-02 A14 FF0-Owner Multi-Plattform-Generalitaet** ("Abgabe-Blocker, hoch") | Habich-Restruktur-Fassung Kapitel 6: kapitel/de/06_fazit.tex:22-33 (EN-Paritaet) beantwortet FF0 explizit multi-plattform -- "erst nach den End-to-End-Laeufen je Plattform beziffern", "auf Hybrid-CPUs und Sapphire-Rapids gegenuebergestellt", Zuordenbarkeit ueber die Dreiteilung Organ/System/Mess strukturell beantwortet. Die Frage ist damit im Abgabe-Dokument gestellt UND methodisch beantwortet; offen ist nur die BEZIFFERUNG -> Nachfolger = P3 Trigger/Voll-Bau-4 + Phase 6 (USER-GO-STOPP). Anhaenge-B/E-Anteil erledigt (s. o.), Mess-Manifest-Anteil als VOR-ABGABE-Zeile uebernommen. |
| **V-11 #327 PAT-Rotation "Security SOFORT, deadline-unabhaengig"** | Owner-Terminierung: "#327 NUR-KENNTNIS (Rotation nach Messfenster, Handout liegt)" (LEDGER:3727). Das "SOFORT" des Alt-Blocks ist damit abgeloest; der Posten bleibt als OWNER-FENSTER-Zeile mit Termin "nach Messfenster" bestehen (nicht gestrichen). Cluster ist fuer diese Linie read-only (Memory-Doktrin). |
| **V-18-Teil A20 L12 Codex-Zweitlens Z-02/Z-03** | (a) Wegwahl entschieden: "Z-02-Wegwahl NUR-KENNTNIS (Weg (i) F6-Grammatik als M3a)" (LEDGER:3727); Z-03 ist als M3a-Commit C2 verortet (LEDGER:3686). (b) Das Verfahren "Codex-Zweitlens" ist seit 06.08. mittag-18 stehende DUAL-REVIEW-PFLICHT vor JEDER Landung -- die Sonderanforderung "Z-02/Z-03 verdienen die zweite Lens am dringendsten" (LEDGER:3698) ist damit im Regelbetrieb aufgegangen. A23/A24 bleiben als eigene Zeile (s. NACH-ABGABE). |
| **V-09-Teil "Hybrid-Binary = ABGABE-PFLICHT vor 28.07."** | Frist mehrfach neu gesetzt (aktuell Abgabe Fr 08.08.) UND Verortung durch Owner geaendert: Hybrid-Tier-Stufe = eigene Stufe HINTER der CEB (LEDGER:3529, Owner-E1) mit "Bau in der Auswertungsphase" (LEDGER:3602, Paragraf-75-NICHT-KANDIDATEN-Freihaltung). Die ABGABE-PFLICHT-Etikette ist damit abgeloest; der Bau-Posten selbst bleibt und ist als NACH-ABGABE-Zeile uebernommen. |

### Mechanik-Vermerk (Wiederholungs-Schutz, aus dem Delta)

1. **Namenskollisionen loeschen Inhalt still.** Zusaetzlich zu den in :186 gefuehrten Kollisionen sind hiermit verbucht: **G5** (Lager-Pruning, Register :53/:316 -> O-3) != **G5/#274** (measurement-all-Modul-Migration, V-12) . **A14** (OS-U4-Rest, Register :71) != **A14** (FF0-Abgabe-Blocker, V-02) . **B12** (xlsx-Lager-Fuellung, Register :69) != **B12** (N-Paar-Wahl first-2 vs. Max-Kontrast/F-SPREAD, LEDGER:2905, jetzt in V-20).
2. **Geparktes braucht eine Zeile.** "Geparkt-OK" wurde in der Uebertragung faktisch als "braucht keine Zeile" gelesen -- daraus entstanden V-09/V-13/V-20. Owner-Doktrin: nichts ersatzlos streichen, auch Geparktes bekommt eine Zeile mit Wiedervorlage-Anker.
3. **Fenster-Regel (Dauer-Regel-Kandidat).** Eine Konsolidierung darf ihr Zeitfenster nicht als Grenze setzen, ohne den letzten VOLL-Block davor als EINGANG mitzunehmen. Fuer dieses Register war das Paragraf 55 (LEDGER:2829-3060) -- hiermit nachgeholt.
