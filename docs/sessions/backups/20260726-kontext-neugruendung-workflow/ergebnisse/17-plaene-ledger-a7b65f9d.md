Gelesen (lückenlos): Ledger 3424 Z., Masterplan 336 Z., INDEX 108 Z., Handover-Board 64 Z., Plan `noble-shimmying-fairy.md` 208 Z.

# PLAN-UEBERBLICK (Stand Ledger 23.07., N-13-Befund 26.07.)

## (a) BESCHLOSSENE ROADMAP + GATES IN REIHENFOLGE

**Aktuell gueltige Kette (juengste Sektionen schlagen aeltere):**

1. **LAGER+STEMPEL-GATE (§66, KERN=Gesetz) — laeuft JETZT, blockiert den Voll-Build**
   - G1 `#27` B/C/D + amd24 landen
   - G2 **STEMPEL-Finalisierung** `#36` = bewusstes Cache-Bruch-Fenster jetzt (K7b Array-Form, AVX10-Feld, per-Binary-Sidecar, W12 X.Y.Z) — supersediert die "vor 01.08."-Parkung
   - G3 `#10` **#46b-Bestandslog-Kern P1–P4** + RAM-Sammelpuffer (256 MB) / avg_size / Writer-Backends (io_uring | Win-IoRing/IOCP | portabler write-Thread, CT-Strategy) / async Slice-Queue
   - G4 `#34`/`#33` P-A Ebene-B-Push-Aktivierung + P-C `measure_out`-Verlustnaht; **G4a** per-Lane-PMC-Preflight `#37`
   - G5 `#35` P-B Pruning lokal→0 (`verify_remote_then_prune`)
   - Nicht im Gate: `#32` Tools-Lagerhaltung = POST-ABGABE
2. **Voll-Bau-4** (2^17 new-golden ueber die dynamische CE-Kette; 12713/Voll-Bau-3 am 23.07. gecancelt)
3. **320er-Messlauf** (Abgabe-Datensatz, `when: manual`, Ein-CEB-Exklusivitaet **pro Maschine**)
4. **S7** Hybrid-Binary (4. Kettenglied, ABGABE-PFLICHT) + M-4 (19→17-Nachzug) + PDF-Kette
5. **S8** PDF-Abgabe
6. **Post-v3 Full-Join-Liste (§60, Reihenfolge freigegeben):** `#34` CLI-Haertung → `#35` Fork-A-.so-Schnitt (Planer↔CEB) → `#36` #19-Resolver + CoR → `#44` Paper-Template-Profile → `#38` K7b/K8 (Stempel/Storage) → `#37` F-SPREAD → gate-getrieben (A16-Pinning, A17-NUMA, A13-Locking) → `PV-9` Deprecated-Kuration (laufend)
7. **Ab 01.08.:** new-golden VOLL-MESSUNG (mehrtaegig, 1-Thread)

**Uebergeordnete Gates (chronologisch beschlossen, teils erfuellt):**
- §45-GATE "erst optimierte Pipeline, dann Voll-Build" → **ERFUELLT** (§46, E2E 11562→11611, dreistufige Legenden-Kette produktiv)
- §41/GN-11: **Bau = new-golden (Pflicht, §51-B1), Messung = 320er (Zwischenergebnis), N-Messung ab 01.08.**
- §33 **Beweis-Doktrin:** golden-320 ist KEIN Systembeweis (13/17 Achsen gepinnt, nur Byte-Wache); legitimer Beweis = new-golden Voll-Konfiguration (N=2^17, CRC64-Anker `kNewGolden131072Crc64`, `test_reflect_versions_all17`)
- §61: **Dual-Weg-Pflicht** (CI **und** lokal/bare-metal) fuer ALLE Funktionen; Modi-Stufen Debug → Messung → Release (+ 4. Modus COMPARE, §62-C); exactly-one Modus je XML-Call
- §66-N2: **PMC-Pflicht je deklarierter Lane** (pmc:amd auf AMD, pmc:intel auf Intel, beide hart; `COMDARE_PMC_LANES`)
- Stehende USER-GO-Gates: ABI/golden-Regen-Fenster, 320er-manual, ISA-Alt-Ausbau (Q3), Gattung-Genus→Typ-ABI (S12/Q4), je Bau-Phase

**Historische Roadmaps (im Ledger als Historie erhalten, nicht mehr steuernd):**
- Bau-INC-0 (DLL-Load Option B) → INC-1 (System-Achsen-Schichtung) → INC-2 (4→5) → INC-2c/2d (5→6) → INC-3/INC-4 — **INC-0/1/2c/2d gelandet**
- Plan-V2 S1–S9 + S10–S23 (§49/§53 VOLLES GO), Baender A–D, Wellen W1–W12, Schicht-Sequenz E4→E3→E2→M→E1 (**komplett**)
- `/home/comdare/.claude/plans/noble-shimmying-fairy.md` = **Dossier 16 (E1–E4-Konsolidierung, genehmigt 09.07.)**: Phase 0 (Doku-Konsolidierung), 0.5 (G2-Revert `88738285`+`4d8aedce`) und Phase 4/#31 sind vollzogen; die Roadmap-Phasen 1/2/3/5/6 (#188, #221, #223, #215, #156/#162) sind teils erledigt (#188, #221, #223), teils weiterhin HELD (#215/#156/#162). Der offene Design-Fork des Dossiers (V32-Schema aktivieren) ist per §12-E10/Fork-A ueberholt.
- `MASTERPLAN_KONSOLIDIERUNG_TERMINE.md` (K-A..K-J, 10 Doku-Phasen, Mai): K-A/K-B/K-D/K-E/K-J DONE; **K-C (architektur/), K-F (forschungslandkarte/), K-G (termine_konsolidiert/), K-H (drawio REV7) pending**, K-I teilweise (INDEX.md = K-I.1). Reihenfolge K-B → {K-C,K-D,K-E,K-F} → K-G → K-I, dann K-H → K-J.

## (b) OFFENE PUNKTE MIT NUMMERN + STATUS

**⚠ Zwei Nummernraeume kollidieren (Ledger fuehrt das selbst als `O-13` "Nummern-Kollision"):** Session-Task-Raum 07-20 ff. vs. Alt-Ledger-Raum (#1–#279). Nummern immer mit §-Anker lesen.

**Neuer Raum (Session-Tasks, aktuell steuernd):**
| # | Punkt | Status |
|---|---|---|
| #10 | #46b-Kern: RAM-Puffer/avg_size/Writer/Slice-Queue | OFFEN, Gate G3, kritisch |
| #27 | B/C/D + amd24 | OFFEN, Gate G1 |
| #32 | Tools-Lagerhaltung (minio, einheitl. Benennung) | OFFEN, POST-ABGABE |
| #33 | P-C `measure_out`-Verlustnaht | OFFEN, Gate G4 |
| #34 | P-A Push-Aktivierung **/ (Post-v3:) Planer-CLI-Haertung** | OFFEN, Gate G4 / PV-3 |
| #35 | P-B Pruning lokal→0 **/ (Post-v3:) Fork-A-.so-Schnitt (R1)** | OFFEN, Gate G5 / PV-1 |
| #36 | Stempel-Finalisierung K7b **/ (Post-v3:) #19-Resolver + CoR** | OFFEN, Gate G2 / PV |
| #37 | per-Lane-PMC-Preflight **/ (Post-v3:) F-SPREAD Max-Kontrast** | OFFEN, G4a / nach Abgabe |
| #38 | K7b-§58-Array + K8 Storage/id-Satz | OFFEN, Caching-Phase |
| #44 | PV-4 referenzierte Paper-Template-Profile | OFFEN, nach #36 |
| #45 | paralleler Mess-Loop (Debug-parallel MESSEN existiert NICHT) | OFFEN, ehrlich ausgewiesen (§61-b) |
| #46 / #46a / #46b | Cache-Log-Claim / Minimal-Cache / Bestandslog-Persistenz | #46a vorgezogen; #46b PFLICHT vor 01.08. |
| #47 | COMPARE-Modus (4. run_methodology-Wert) | OFFEN |
| #48 | XML-Aufraeum-Gate + golden-XML NEU (F27: keine kanonische `experiment_golden.xml`) | OFFEN, Gate VOR Post-v3-Code |
| #49 | neue statische Haupt-System-Achsen (RAM MT/s+CL, CPU-Fabrikation) + Erkennungs-Tools (libcpuid / cpu_features / decode-dimms / dmidecode) | OFFEN |
| #51 | tier150-CSV-Ausnahme (Heuristik-Loader) | OFFEN, Ersatz erst nach 320er |
| #53 | CI-Wartung/Durchsatz | OFFEN, vorgezogen |
| #54 | CEB-interner Batch + GTest-Pruefstand + Status-Pipe an Planer | OFFEN, hoch |

**Alt-Raum (weiterhin offen/gated):**
- `#156` M3/Voll-Messlauf **HELD** (nie pollen) · `#162` ≥8 Rang-1-SOTA HELD · `#215` DER EINE 320-DLL-Neubau/CoW HELD · `#216`-Rest seg_ns n>1
- `#229` "Diplomarbeit aendert nur die XML" TEIL · `#179` Wartbarkeits-Sweep XL TEIL · `#186` EPIC CI laufend
- `#266` **config-Owner-Gate = das EINE genuin offene Matrix-Gate** (foundation-b1 vs config-all; §48 fuehrte es faelschlich als erledigt)
- `#270a` P/E-Core (HW-gated, 14900KS-RMA) · `#270b` arm64-Gruen (node7-Freeze) · `#273-T2` gcc-15.3-Pin
- `#274`/`#256` Modul-Migration Schritte 8–15 (GO mit 3 Auflagen, **Projektende**) · `#276` 3-ISA-CI = **ALLERLETZTE Aufgabe**
- `#24`/`#25` Overleaf-/Thesis-Text (User schreibt) · `#226` Appendix-Limitierungen · `#225` Second-Execution (nur Diskussion)
- `#29` Fehlerklassen-Framework TEIL · `#40` Dead-Code-Reklassifikation · `#31`-Reste · `#19`(alt) Vendor-Allokatoren echt linken
- Infra-Paket `#189`/`#199`–`#210`/`#231`/`#272`, `#21` Runner-Cache, `#277`-Reste, `#46`(alt) github-Sweep — GEPARKT/infra-gated
- **Security SOFORT:** PAT-Rotation `#327` (Vault-PAT exponiert; nicht autonom rotiert)
- Ehrlich offen: **S-7 Deep-Research** (Tooling/Safety-Block) · `§26-L5` build-i2 stale-rot (Include-Root-Gap, einziger INC-0-Rest) · `K-5` best_binary_selector ABI-Spiegel stale (.A5. vs Host ABI-6) · F-8 main-Lag-Merge-Timing · F-9-E3 (per §52-B10 aufgeloest)

**Handover-Board 20260705** (`HANDOVER-ANHANG-TODO-BOARD-20260705.md`) ist ein **historischer Snapshot** (275 Eintraege, Stand 05.07.); dessen offene Punkte (#10, #19, #24, #25, #125, #149, #152, #156, #162–#165, #179, #184–#189, #199–#210, #215–#217, #225–#274) sind ueber §12/§55 fortgeschrieben — nicht als Ist lesen.

## (c) TERMINE / FRISTEN

- **Do 24.07.2026** — Voll-Bau-Start spaetestens; GN-11-Bau-Nachweis new-golden + Messfaehigkeits-Nachweis ("das Meiste messen") CI **und** bare-metal
- **Mo 27.07.2026** — Frist-Rahmen ~2 Tage Bau + ~2 Tage Messen/Testen; S8-PDF-Endgate; §66: **ZWISCHEN-Abgabe (nicht End-Abgabe)**, wird durch das Lager-Gate ENG, Verzug ist begruendbar (Gruendlichkeit schlaegt Termin)
- **Di 28.07.2026** — der governing Deadline-Anker (V6.6/F12i): CI **und** standalone messfaehig, cmake+C++23 auf EINER Maschine; 320er-Abgabe-Messdatensatz; **Hybrid-Binary = ABGABE-PFLICHT**; Anhaenge A/B/E + CRC64
- **Ab 01.08.2026** — new-golden VOLL-MESSUNG (Anschlussarbeit); `#46b` ist davor PFLICHT
- **~September 2026** — prod2 (i9-14900KS) zurueck aus RMA → Hybrid-CPU/P-E-Core-Messungen (`#270a`, FF0-Teil)
- Write-Token Projekt 288 laeuft **2026-10-09** ab (Rotation einplanen; kein Wert zitiert)
- Historisch: Termin 8 = 15.05.2026 (Masterplan K-A), Habich-Runde 2 abgeschlossen 11.07.

## (d) WAS DER LEDGER ALS BINDEND MARKIERT

**Autoritaet / Lesereihenfolge**
- Der Ledger ist **Single-Source und schlaegt bei Widerspruch alle Session-Docs**; **neuere Fakten schlagen aeltere** (in-place-Update erlaubt, Historie via git)
- **§59-Autoritaets-Regel:** die User-KERN-Beschreibung war "SCHON IMMER Gesetz" — Abweichung des Plans = **Regression**, nicht Neuentscheid
- **§55 = Single-Source aller offenen Punkte** (loest §48 ab, §48 bleibt als Historie); **§54-T1–T7 = bindende Terminologie** (Gattung = Tier-Binary-Interface, NIE Achse; Achsen-TYPEN {Organ/System/Mess}; Baum je Achsen-Typ; measurement_categories + Rueckschrieb = Mess-Tooling-UNTER-Achsen; Meta-Meta-Achsen per Command-Pattern; `tier:build:[d,e,f][g,h,i]` getrennt von `measure:[a,b,c][d,e,f][g,h,i]`)
- Lesereihenfolge historisch §20→§19→§18→§17→§16; faktisch gilt "neueste Sektion zuerst" (§66 → §65 → §64 → …)

**Prozess (Pflicht je Aufgabe)**
- **ultracode-Planungssession VOR** jeder Aufgabe ueber Ledger + ALLE Plandocs, **adversariale Konformitaets-Pruefung NACH** der Aufgabe; nie raten, nie erfinden
- Bei scheinbar offener Entscheidung: erst Ledger + alle Plandocs erschoepfend lesen; nur wenn unauffindbar → Rueckfrage + **PAUSIEREN**
- **Verifikations-Kadenz je Increment (literal):** ctest + golden-Roundtrip==320 (nur noch Byte-Neutralitaets-Beleg) + CRC64-Anker + clang-format-22.1.8 `--dry-run --Werror`==0 + Mojibake-grep `Ã|â€`==0 + **super-Sub-Build PFLICHT** (nicht nur ce-standalone) + beide Remotes ref-gleich + **gesamte Pipeline hart gruen** (ce+super, prod1+prod2, kein allow_failure)
- **Dual-Weg-Pflicht (§61):** jede Funktion muss ueber GitLab-CI **und** lokal (cmake+Shell) laufen; Dual-Beweis gehoert in jede Verifikation
- Granulare Commits (nie `git add -A`), **NIE rebase / IMMER merge**, `main` stets Vorfahr; **Branch-Regel §63:** durchgeplant → main, halbfertig → development
- **Autonomie §63:** volles autonomes GO (auch nachts) bis kein erkennbares Backlog mehr; Cluster fuer Impl reserviert (Infra-Autonomie §39)

**Architektur-Doktrinen (hart)**
- compile-time-only im Hot-Path (CRTP + Concept-Guard, **keine vtable, kein Runtime-Switch**); CT→RT-Degradierung ist zurueckzukorrigieren
- **std::variant-VERBOT** fuer alle statischen (Haupt-)Achsen (§23) — verschaerft durch **§66-N3 Mapping-Reinheit**: nur CT→CT und RT→RT, keine runtime→compile-time-Bruecken; einzige, eng limitierte Ausnahme = Hybrid-Tier-Unter-Pruefdock-Vertraege via Abstract-Factory (§49-Korrektur)
- Nur benannte Lehrbuch-Design-Patterns; WAS/WIE-Trennung (ce = Framework, super = Definition); rekursive Dock-/ABI-stabile-.so-Kette Planer↔CEB↔Tier; Baseline-Layering in Stein; System-Achsen geben frei, Organ-Achsen setzen durch (Organ ≤ System)
- **Achsen immer getrennt klammern** — keine Fusion in Signaturen/Schluesseln/Stempeln
- **Batch-Job-Prinzip (§62-B):** Job-Anzahl O(Maschinen), NIE O(Binaries); 130k Einzel-Jobs sind untersagt; Batch = 4096 Binaries, CEB-intern + GTest-Pruefstand vor der Messung
- **Mess-Doktrin:** Messung NIE als Nullen abschalten — Fehler → CSV-Zelle **"failed" + Log**, Harness misst weiter; honest-100% / Anti-Phantom (falscher Wert schlimmer als honest-0); Debug=parallel / Messen=1-Thread / Release=ohne Messsystem; **Mess-Exklusivitaet pro Maschine** (`ceb-measure-<host>`), Bau bleibt parallel; **Default = alle 3 Mess-Verfahren VEREINT in EINER CEB** (§64), Trennung nur per XML

**TABU / Stand der Invarianten**
- Aktuell **ABI-6**, Magic `.A6.`, POD **1272**, **17 Organ-Achsen**, 6 (+meta-meta) System-Achsen; `golden_fullpilot_320` = Alias/Byte-Wache; alte Fixtures `_abi4`/`_abi5` additiv eingefroren
- `permutation_axes.xml` read-only (Legacy-Katalog); kein ABI-/golden-Bruch ohne koordiniertes GO-Fenster; Messdaten-Zerstoerung nur per punktuellem je-Fall-GO (alte CSVs 21.07. geloescht, fuer neue gilt die Doktrin unveraendert)
- **Doku nie loeschen** (nur deprecaten/additiv); Remote-/Branch-Anlage und -Loeschung nur je-Repo-GO; **kein Python** in der Buildchain; **nie AskUserQuestion**; **nie ✓ ohne woertliche Tool-Ausgabe**

Relevante Pfade: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (§55 = offene Punkte, §66 = aktuelles Gate), `.../docs/MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`, `.../docs/INDEX.md`, `.../docs/HANDOVER-ANHANG-TODO-BOARD-20260705.md` (historisch), `/home/comdare/.claude/plans/noble-shimmying-fairy.md` (= Dossier 16, Phase 0/0.5/4 vollzogen).