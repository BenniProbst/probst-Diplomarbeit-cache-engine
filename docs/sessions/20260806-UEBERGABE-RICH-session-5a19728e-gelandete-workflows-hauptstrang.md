# REICHE KONTEXT-UEBERGABE 06.08.2026 ~10:00 Berlin — Session 5a19728e (Lead/Fable), vor Kompaktierung

> **ERST-ANKER bei Wiederaufnahme (Reihenfolge bindend):** (1) super-Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Nachtraege **frueh-3 .. vormittag-28** (rueckwaerts). (2) DIESES Doc. (3) `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` (direktiven-gegengeprueftes TODO-Register). (4) Memories (MEMORY.md-Index). **ERDUNGS-DOKTRIN:** VOR jedem Handeln Ledger + Objekt-Ist + Lebend-Check; NACH Compact zusaetzlich den Session-Log nachvollziehen. NIE blind resumen. main-FF-Ziel = IMMER der CI-gruene Paket-Merge-SHA, NIE die Ledger-Spitze.

---

## 0. EINORDNUNG IN DEN HAUPTSTRANG (das grosse Bild)

**Mission:** TU-Dresden-Diplomarbeit = Cache-Engine-EXPERIMENT-SYSTEM. Der Permutationsraum (~1.57 Mio Tier-Binaries, compile-time) wird ueber die E1-E4-Maschinerie gefahren: E4-XML (Bauanleitung) -> E3-Permutationsbaum -> E2-Tier-Binaries (compile-time) -> E1-RC-Laufzeit. Kern-Beitrag = die **Achsen-Library** (18 Organ-Achsen als Bausteine; Gattung Map/Container/Graph -> Genus). **Frist: Abgabe Fr 08.08., Trigger-Ziel Do 07.08.** Kollisionsregel: Substanz gewinnt, Trigger darf rutschen. **Phase 6 (Messung) = USER-GO-STOPP.**

**Wo wir im Hauptstrang stehen (Owner-Reihenfolge P0-P4, bindend frueh-7/-9, "nichts auslassen, nur Reihenfolge"):**
- **P0 = Bau-Kette freimachen** (Neuanker-Fingerprint-Mechanik) — der Fingerprint entscheidet beim mehrtaegigen Voll-Bau, welche Binary neu gebaut/gemessen und welche uebersprungen wird. Das ist Voraussetzung fuer verlaesslichen Binary-Compile. **HIER liegt der kritische Pfad.**
- **P1 = Trigger-Werkzeuge** (B13 headless/ETA, B14 GOLDEN-XML=Bauanleitung, Posten 92 Planer-Konsistenz).
- **P2 = Messwert-Lager** (CSV-Schema P2-P8, A1-Wurf-Vertrag, Lager-Kaskaden+xlsx) — VOR Messbeginn.
- **P3 = Trigger -> Voll-Bau-4 -> Phase 6 (USER-GO-STOPP).**
- **P4 = Darstellung/Kanal** (honest-empty [gelandet], 2D/3D-Graphen, E18-SNAP, B12) — nach Trigger.

**Der zentrale Befund dieser Session:** Die Neuanker-Fingerprint-Mechanik (P0) ist NAHEZU fertig, hat aber ein **noch offenes Kern-Loch**, das Codex fand: das Mess-**Resume** ist nicht an den neuen Fingerprint gekoppelt -> der "neue DLL / alte Messwerte"-Bug, den der ganze Neuanker heilen soll, ueberlebt noch (Details P0 unten). Deshalb ist P0 NICHT abgeschlossen — und das ist gut so erkannt worden, nicht vorschnell gelandet.

---

## 1. LINIEN-IST (verifiziert ~10:00)

- **super:** dev == `854a9bf6` (beide Remotes); **origin/main == `030d2c62`** (= letzter Paket-Merge honest-empty; dev laeuft mit Doc-Nachtraegen voraus — DOKTRIN-KONFORM, main nur auf Paket-Merges).
- **ce:** dev == main == `c837d830` (beide Remotes; nach Doku-77/78-Landung + FF).
- Frueherer ce-Anker: `7969b399` (Gate 408, W5/W3+E-18), dann `be4f0a16` (UML-Atlas), dann `c837d830` (Doku-77/78).
- **EIN-INSTANZ-REGIME** (Owner): alle Hoheiten bei dieser Linie; Alt-Worktrees abgebaut (~70G frei). Achtung: durch Session-Fork (Kompaktierung) gibt es ORPHAN-Bauagenten (siehe A1 unten) — bei Wiederaufnahme Lebend-Check + Ein-Schreiber-Regel.

---

## 2. IN DIESER SESSION GELANDETE WORKFLOWS (dual-review-sauber, CI-gruen) + ZUSAMMENHAENGE

| # | Workflow | Merge-SHA | Was + Zusammenhang |
|---|---|---|---|
| 1 | **E-18-Vorwaerts-Kanal** (B1) | ce `253bcd86` + super `8131a9a2` (frueh-4/-5) | LaTeX-Anhang-Kanal je CI (INERT); 289-Write-Token id=95 (least-privilege) + CI-Vars. Basis fuer E18-SNAP. |
| 2 | **super main-FF-Heilung** | super `b6d1a736` (frueh-4) | Haengender main-FF nachgezogen; 4-Projekt-Remote-Sync (frueh-12). |
| 3 | **honest-empty** (P4-Vorzieher) | super `40bf8a66` (vormittag-14) | Stufe-05-Flaechen-Writer: nie-ausgefuehrte Metriken werden EHRLICH ausgelassen (statt 0.0000-Heatmap -> pgfplots-Fatal); echte-0 bleibt sichtbar (eigene Farbklasse); 3D-Loecher statt Phantom. **Dual-Review konvergiert** (Codex fand echte-0-Ueberkorrektur, geheilt, Fable verifiziert). Loest die D-03-PDF-Gate-Falle. Zusammenhang: macht das PDF-Gate des E18-Kanals bei Teil-Korpora gruen. |
| 4 | **UML-Klassenatlas nach ce** | ce `be4f0a16` (vormittag-19/-20) | 05b-Atlas (REV 5, IST-treu) aus super nach ce docs/architecture kopiert (Owner-Auftrag). CI war Infra-Flake-ROT -> Retry gruen. |
| 5 | **Posten-77/78-Doku** | ce `c837d830` (vormittag-23) | Owner-A2/A3: kReal-Suffix-Kollaps auf kurzen Keys (Mess-Interpretations-Pin) + **XorFilter-FALSE-NEGATIVES-Doku-Pflicht** (30/256; nie als Nicht-Membership-Beleg zitieren, auch Thesis-/Messbild-Doku). Comment-only. |

**Roter Faden der Landungen:** E-18-Kanal (1) braucht ein gruenes PDF-Gate -> honest-empty (3) liefert es -> E18-SNAP (Compile-Export, gebaut aber ungelandet, s.u.) baut darauf. Der UML-Atlas (4) und die Filter-Doku (5) sind Doku-Konsolidierungen parallel dazu.

---

## 3. FERTIG GEBAUT + GESICHERT, LANDUNG AUFGESCHOBEN (je rescue-Ref beide Remotes)

**Doktrin dieser Session (hart bewaehrt):** Codex fand HEUTE bei **fuenf** Wellen echte Regressionen, NACHDEM Fable schon LANDEBEREIT sagte (honest-empty, E18-SNAP, A1, B14, Teil-2). Deshalb: **kein Landen auf Fable allein — fresh Codex-Pass vor jeder Landung.**

- **E18-SNAP-NB** (`1ae02cdf`, rescue/e18snap-nb-1ae02cdf): Owner-E-1-KERN — je Kanal-Lauf datierter Compile-Export-Ordner an der Messwerte-Wurzel (`measurement/thesis_compiles/JJJJMMTT-HHMMSS/` mit PDF+compile-export.txt+QUELLSTAND-SHAs). Erntet die ohnehin gebaute Thesis-PDF. 6 Codex-Befunde geheilt (Retry-Verlust, Kollisions-Race, Non-FF-Divergenz, errexit, Override, Rollback-Loeschpfad). Fable LANDEBEREIT. **Landung braucht:** Codex-Pass + `.gitlab-ci.yml`-Patch durch Lead (LEAD-ONLY-Hotspot, liegt als apply-gepruefter Patch-Vorschlag) + B-5-Lebend-Check + 289-Token/Var-Scharfschaltung. Job bleibt INERT bis dahin.
- **A1-NB** (30 Dateien, WIP-Patch `a1-nb-wip.patch` 822Z gesichert; Basis rescue/a1-base-0b5ed557): A1-Wurf-Vertrag der Allokator-Achse + 3 Codex-Heilungen (Fingerprint-Bump v1.0.0c->v1.0.1c aller Allokator-Varianten [erreicht die Naht: VOR 6246342b != NACH 0d9714e1, golden-320 ohne @ unbewegbar, Frozen/CRC/TABU unberuehrt], PMR wirft bei bytes==0, Concept-ThrowTranslatingStrategy). Fable LANDEBEREIT. **ACHTUNG:** Bauagent war ORPHAN (Session-Fork), Worktree war in Bewegung -> Commit aufgeschoben auf Ein-Schreiber-Moment. **Landung braucht:** sauberen Commit (Bauagent-Rest ODER Patch auf 0b5ed557 anwenden) + 2x-Gate + Codex-Pass.

---

## 4. NICHT LANDEFAEHIG — die P0-Kern-Baustellen

- **Teil-2-Uebernahme** (5/6 gebaut, `a6a6875b`, rescue/t2-uebernahme-a6a6875b; Gates-Spiegel backups/20260806-neuanker-teil2/gates/ VOLL = 53 Dateien inkl. 6 Merge-Logs). Gebaut: T2-D (NB-3-Haertungen), T2-B (per-Perm-Glied, O2!=O3 bewiesen), T2-C (RT-Realversions-Sonde, fail-closed gegen Injection), T2-E (tc=1-Verifikation), T2-F (C-4-Rest). **Dual-Review SPLIT:** Fable LANDEBEREIT, **Codex NICHT-FREIGABEFAEHIG** — Lead folgt Codex:
  - **T2-A fehlt ganz** (Owner-Zaehler-Resume-KERN: Batch-Plan PERSISTENT VOR Lauf, Resume=Zaehler je Phase). Bewusster Stopp des Bauagenten (zu heikel unter Zeitdruck).
  - **K2 (SCHWER):** Mess-Resume nicht an neuen Fingerprint gekoppelt — Stamp bleibt `resume-v5`/nur `algo_sig`, wird auch nach echtem Neubau geprueft -> g++-16 16.0.1->16.3 baut DLL neu, uebernimmt aber ALTE result.csv-Messwerte = **der Kern-Bug den der Neuanker heilen soll**.
  - **H1:** leere Zellfelder kollabieren per-Perm-Fingerprints (`!perm_cell_values.empty()`-Gate, aber leer=API-Default) = Loch in T2-B.
  - **H2:** compile_for_perm-Fallback stempelt anderen Bau.
  - **NAECHSTE WELLE (T2-A, praezise spez in vormittag-27):** T2-A F1/F4 Zaehler-Resume + K2 (Resume-Stamp traegt VOLLEN neuen Fingerprint, nach Neubau NICHT alte Messwerte) + H1 + H2. Anker: `cache_engine_builder_iterator.hpp:876/883/904/952/1950`, `profile_run_entry.hpp:806/943`. Dann Dual-Review -> L1-Buendel KOMPLETT -> TP1+4+1 EINMAL.
- **B14/KF-6** (`d8073913`, rescue/b14-kf6-d8073913): GOLDEN-XML-Pflege (17->18-Achsen-Drift geheilt) + KF-6 line_sizes via additiver XSD-Erweiterung `organ_subaxes` + Scheibe-6-Vokabular-Wache + F-3-Fix. **Codex NACHBESSERN (2xHOCH):** golden_kern:185 N=2^17 nicht kodiert (Trigger zeigt real auf `all_axes_golden.profile.xml:1152`); `binary_search/linear_search:156` keine gepinnten Registry-Namen; `organ_subaxes` wird von `parse_experiment_profile` NICHT gelesen. **B14-NB2 noetig** + kLbufBytes-OOB-Auflage (abi_adapter:454-464) mitziehen.

---

## 5. OFFENE TODOs (Board Tasks #1-#7 + Register-Reststrecke)

**P0:** T2-A-Welle (s.o.) -> L1 -> TP1+4+1. Danach faellt das TABU auf den C-3-/Naht-Dateien.
**P1:** B14-NB2 -> Posten 92 (validate-2er vs plan-3er, Owner: vor Abgabe) -> B13 headless/ETA (Branch NEU ab dev + Re-Anker-Pass; Plan backups/20260805-b13-eta-plan/).
**P2 (vor Messbeginn):** A1-Landung; P2-P8-CSV-Schema-Bau (Katalog 20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md Abschn. 3, bindende Slot-Vergabe, G8-Byte-Wachen je Commit); **E14 NoFilter-Blatt=Identitaet** (Owner volles GO); B5-Mess-Schnitt (T6-Naht, != B-5-Lebend-Check); G-E3-Host-Binder (mess_bestand_*-Verdrahtung); Lager-Kaskaden+xlsx-GERUEST. **Posten 89 (HOCH/zeitkritisch):** seit Phase B materialisiert fremde T6-Wahl den Rebound-Leaf statt der Fassade -> Allokationszahlen steigen um den Organ-Anteil -> MUSS beim ersten Vergleich gegen Alt-Mess-CSV eingepreist werden (sonst Falsch-"Regression"-Lesung).
**P3-TRIGGER-VORBEREITUNG (aus Direktiven-Pruefung vorgezogen):** Ebene-B-Push AKTIVIEREN (G4, ist INERT!), Lager-Gate G1, **OD-7 Runner-Direktive DURCHSETZEN** (Owner: normal 2/2, heavy 24 Worker; Ist 3/2+16 = Verstoss; Infra-Handout), E8-PMC-Beleg-Form, Platz-Wache/df, G5-Nachfolger O-3-Loesch-GO.
**P4 (nach Trigger):** E18-SNAP-Landung + Codex-Pass; **2D/3D-Graph-Umbau** (SOTA-Katalog backups/20260806-e2a-planungs-welle/); B-5-Lebend-Check + Scharfschaltung (mit COMDARE_TEXLIVE_AVAILABLE=true); B12-xlsx-Fuellung; B-Rest (B2/B3/B4/B8/B9/B11); Aufraeumpass (1xN-Matrix-Bestandsfehler, leere 3D-caption, Posten 73/84-88, SF-1-Fenster).
**OWNER-FENSTER/nach Abgabe:** SF-1 (anatomy->builder-Traits-Split, eigenes Fenster VOR Abgabe, Owner-GO); **E4/17 T17-Min/Max = DEEP-RESEARCH** ueber Observer (min-vs-max je Achsen-Parameter; Architektur-KERN Memory feedback_gattung_genus_interface_messparameter_achsen); R2/289 main-FF-Rhythmus aktivieren; A5-Value-Filter-Achse; Scheibe-6-Weg-a (ce-Umbenennung) ODER Weg-b (Vokabular-Wache) dauerhaft?; A14-FF0-Multi-Plattform klaeren; Posten 92-Registry-Kanon.

---

## 6. OWNER-ENTSCHEIDE DIESER SESSION (alle verbatim im Ledger, Memories nachgezogen)

E-1..E-5 (frueh-6), P0-P4-Reihenfolge (frueh-7/-9), A1-A9 (frueh-6-Umfeld), **6er-Block vormittag-22**: E4/17-Deep-Research + Architektur-KERN (Interface-Funktion Gattung->Genus liefert IMMER alle durchlaufenen Messparameter + zeitlich geloggtes Achsen-Zugriffsprofil; Gattung=Kern der Tier-Binary-Funktionen, Genus=Erweiterung), E14=Identitaet, R2/289-FF, SF-1-Fenster, OD-7-Durchsetzung, Scheibe-6. **Dauer-Regeln neu:** Compact-Neugruendung + Session-Log-Nachvollzug (frueh-3); Berichte am Prioritaeten-Faden (frueh-11); main-FF nur auf Paket-Merge-SHA (vormittag-15).

---

## 7. BETRIEB / FALLEN

- PAT: `.patcfg` im Scratchpad `/tmp/claude-1001/-home-comdare/5a19728e-*/scratchpad/`; bei neuem Fenster Blind-Extraktion (rueckwaerts gegen /api/v4/user, Position rotiert). ce=286, super=288, thesis=289.
- **GitLab-TLS-Stoerung** (~09:25, gnutls-handshake, API-000) — transient, Push-Retry loest. **ce-CI-Rot auf docs-only = Infra-Flake** (contract-Job-Familie kann von docs-Commit nicht brechen) -> Retry vor Ursachen-Panik.
- **Session-Fork/Orphan-Agenten:** Nach Kompaktierung koennen Bauagenten verwaisen und Worktrees weiter modifizieren -> IMMER Lebend-Check (Diff-md5-Stabilitaet + pgrep) + Ein-Schreiber-Regel; nie clobbern.
- **gitleaks vor jedem Push** (podman zricethezav/gitleaks:v8.30.1, Hauptrepo + --log-opts, "N commits scanned"). NIE Worktree mounten (0-commits-Vakuum-Gruen).
- **ALLE gebauten Wellen sind rescue-gesichert + WIP als Patch im Backup** `docs/sessions/backups/20260806-workflows-abschluss-abbruchsicher/` (16 Journale + Patches + INDEX). Nichts verlierbar.
- Board = Tasks #1-#7 (User-sichtbar); Ledger ist die Wahrheit bei Task-Store-Verlust.
- Explore-Besetzung: Sonnet-5 max very-thorough (Owner-Dauer-Regel). Modell-Matrix: Fable=Plan/Design/Review/Synthese, Opus-5=Bau, Codex=Schwer/Regressions-Lens.
