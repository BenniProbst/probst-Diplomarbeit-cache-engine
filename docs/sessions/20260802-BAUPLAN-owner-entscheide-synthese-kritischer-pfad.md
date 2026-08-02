# BAUPLAN — Synthese der ultracode-Designplanung Owner-Entscheide 02.08. (Manager-Synthese nach A1)

> Quellen: 6 Design-Stränge + 6 adversariale Reviews (alle Fable xhigh), Rohdaten in `backups/20260802-design-owner-entscheide-workflows/` (00-result.json + 01-journal.jsonl, 1,6M Tokens). Der Synthese-Agent fiel ans Session-Limit; Synthese per Arbeitsweise A1 durch den Manager. Alle 6 Reviews: NACHBESSERN — Kern jeweils owner-treu, Korrekturen unten als bindende Auflagen eingearbeitet. Owner-Wortlaut-Autorität: `20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md`.

## 0. Zentrale Sequenz-Erkenntnis (kritischer Pfad)

**OS-U vorziehen → A13 danach → W10-Zellwerte → SHA512-Gate (A2) ZULETZT.**
Begründungen: (a) OS-U ist stempel-neutral und sofort baubar (A14-Review F2). (b) A13 ändert das Stempel-Layout (merge-Zeile fällt, POD v6, Fingerprint-Preimage) — jedes vorher geeichte SHA512-Gate müsste doppelt neu geankert werden. (c) **W10-Zellwert-Anschluss ist neues PFLICHT-Paket** (A14-Review B1, CONFIRMED): system_stamp_line trägt heute NUR Code-Versionen, keine Zellwerte — linux/macos/riscv-Bauten hätten identische System-Zeile → identischer SHA512 → das Skip-Gate würde ein Linux-Binary für macOS „wiederverwenden". Ohne W10 ist Owner-E3 (Wiederverwendbarkeit/Zuordbarkeit) NICHT eingelöst. Übergangsregel bis W10: Skip nur innerhalb gleicher OS-Familie.
Lager-Bezug: Fingerprint-Global-Shift durch A13-M2/M3 → parallel entstehende Lager-Probe-Bestände (TP1) müssen nach M3 neu inventarisiert werden (Schnittstelle an Lager-Strecke gemeldet).

## 1. Finale Paket-Sets je Strang (Review-Korrekturen = bindende Auflagen)

### A14 OS-Unter-Achsen (VORGEZOGEN, alle S/M, trigger-blockierend)
OS-U1 Typ-Einhängung FINAL DREI (os_version/kernel/build; update_zustand in build gemerged) → OS-U2 Registry/Generator/XSD (+registry_roundtrip.cmake als benanntes Gate, atomarer Commit) → OS-U3 Laufzeit-Erhebung (AUFLAGE K2: **prozess-frei** — macos sysctl/SystemVersion.plist statt sw_vers; linux uname(2)-Syscall + /etc/os-release-Read; windows RtlGetVersion; AUFLAGE K5: versioniertes probe_id je Familie; AUFLAGE K3: A-08-Abweichungs-Meldung an Owner VOR OS-U3 — steht in §3) → OS-U4 Provenienz-/Lager-Anschluss (Token-Tripel-Vertrag FRÜH an Lager-Strecke) → OS-U5 Doku/Ledger (OP-10-Teil-Supersede). Fehlerklassen in die #29-Framework-Welt, NICHT CompilerCompilerErrorClass (K4). Versions-Bump-Verbot kSystemAxisCodeVersions[operating_system] als Review-Wache.

### A13 Stempel-Regression (M1 S / M2 M / M3 L / M4 S, trigger-blockierend)
M1 'e'-Fundament sofort (golden-neutral; AUFLAGE K-5: 'v0e'→Sentinel-Wache) ∥ M2 Meta-Meta-Anhängung (GATED auf Owner-Frage Q1 Punkt-Pfad vs. Klammer; OP-11/OP-3-Rückbau; Anker-Listen aus Diff ableiten) → M3 merge-Zeile raus (POD v6 sizeof 136→120, Layout==6-GLEICHHEITS-Wache statt >=6 [K-4]; AUFLAGE K-1: anatomy_fingerprint_hex-Umstellung HART BRECHEND via benanntem OverlayHash-Typ/deleted overload — deckt ceb_version_stamp.hpp:136-Falle; AUFLAGE K-3: SOTA-Katalog-Produktionspfad (render_sota_module_source) bekommt volle Stempel-Zeilen als M3-Unterpunkt — sonst bleiben SOTA-Binaries identitätslos fürs Gate; AUFLAGE K-2: Merge-Strategie-Provenienz → Owner-Frage Q2, Default-Empfehlung Einfaltung '+strategie' ins Organ-Segment; B3-Frozen-Vektor-Neueinfrieren in EINEM Commit; K-6-Kommentar-Sweep per grep) → M4 CEB-Contract-Minor 0→1 + Voll-Verifikation + KATALOG-E.0-merge-Unterpunkt-Supersede.

### A15 Fehlerklassen (FK-0 S / FK-1..4 M / FK-5 L, trigger-blockierend; FK-0..4 unabhängig von A13)
AUFLAGEN: K1 FK-2-Default fail-safe (Default ≠ Ok; Negativ-Test „default-konstruiert ist nie valid"); K2 FK-5-Erzwingung an CRTP-Basen je Achse (19 Stellen), nicht 129 Einzeldateien und nicht an Alias-Wrappern; K3 FK-1-Zeilen-Synthese festgelegt: EINE Marker-Zeile je nicht gebauter Binary, spaltenzahl-erhaltend (Token → Owner-Frage Q4); K5 Traits-Schlüssel = per-Achse-Registry-Tags verwacht gegen kOrganAxisCount; K6 MEMORY_FOOTPRINT/IPC_CPI → SourceUnavailable; K8 Supersede-Vermerk im 20260717-Dossier; K9 Autoritäts-Beleg = Owner-Direktive 17.07. FK-5 fährt im A13-Fenster mit (gleiche Wrapper, getrennte Commits).

### A7 E-04-Vollausbau (P1 M / P2 L / P3 S / P4 M, trigger-blockierend; P1–P3 VOR Kalibrierlauf)
AUFLAGEN: Marker-Familie v2 mit Pflichtfeldern **zelle= und lane=** (Owner-Wortlaut „exakt WELCHE"); Record-Identität je Fenster kollisionsfrei (seq=START/4096) + EIN gemeinsamer semantics_version-Bump mit Lager-Strecke; PRUEF-Bilanz-Schreibpfad definieren oder Teil 3 ehrlich auf Bau-Zähler beschränken; PRUEF-Fenster gegen G-A2-Lager-Skip abdichten (Presence-Prädikat auch im pruef_only-Zweig — sonst negiert der Nachtest den Lager-Skip); §68b-Testat je .so NEBEN die Binary (Format mit Lager-Strecke abstimmen); M3-Zweiteilung: M3a A13-frei sofort, M3b Stempel-Konsum nach A13-Lese-API; Zahlen ehrlich (Nachtest-Envelope 2,3–7% des Bau-Budgets, Kalibrierlauf misst real; Heartbeat-Dichte COMDARE_HEARTBEAT_EVERY + Infra-Frage output_limit ins heavy-Handout). §75-Korrektur: built_new HAT einen Leser (experiment_run_entry.hpp:385) — Kandidatenliste fortgeschrieben, nur built_skip leserlos.

### A16 E-Bündel (P1 M / P2 M / P3 S / P4 M / P5 S, trigger-blockierend mit Ausnahmen)
AUFLAGEN: P1 E-24 — **Cross-Genus-Komposition bleibt im EINEN S12-Fenster** (Review-MAJOR: kein stiller Split; „Rest" in R7 = nicht-gelistete E-Punkte, nicht E-24-Teile); Graph-Gattung als eigener Owner-Entscheid (Q5); M0 nur beweisbare static_asserts, Dossier VOR Code, „Input A13"-Marker als Default. P2 E-19 — nur Stufe 1 (Matrix-Doc + Handout) trigger-blockierend, Nachtrags-Stufe nach Infra-Vollzug ausdrücklich nicht-gate-relevant; /runners/all ist admin-only → Scope-Test + Fallback + Projekt-Gesamtzahl als Plausibilitäts-Anker; Tag-Schema einheitlich (riscv64/macos-arm64/macos-x86-64, Infra bestätigt). P3 E-02 — Vier-Ledger (prt-art+thesis anlegen; thesis: Owner-Identität ohne Trailer, CI-grün-Beleg; Vorrang-Klausel „super gewinnt"; ce-goal-v6-Zusatz-Ledger in die Audit-Klausel). P4 E-23 — Suchlauf-Scope präzisiert (GET /groups voll + path-Depth-Filter; E-25 Scan-only-Etikett). P5 E-21 — STACK/LIFO+Verbose+Voll-Persistenz via LEDGER-A11 + Memory; Tasks-Umstellung nur additiv.

### A17 Hybrid-Tier (HY-D1 S + HY-D2 S JETZT trigger-nah; HY-B1..B4 Auswertungsphase)
JETZT: HY-D1 V7.2-Präzisierung + E-11-Auflösung (additiv, LEDGER:89+:3489) + AUFLAGE K4: LEDGER:187(e)-Systemachsen-Framing einordnen (Owner-Frage Q6-Anteil); HY-D2 Architektur-Doc + Verzeichnis-Stub + XSD-Kommentar-Reserve + Freeze-Vermerke. AUFLAGEN für die B-Phase: K1 Hybrid-Lager-Identität klären (Einlagerungsform vs. „nicht eingelagert"); K2 Loader/Drive-Schichten-Entscheid (stufen-neutrale Lib); K5 Snapshot-Aggregations-Semantik als benannter Entscheid; K6 F8-Minimal-DoD zuerst (1 Standard-Dock, ctest-bewiesen); Sidecar-Manifest erst NACH A13 fixieren.

## 2. Zeitachse (aggressiv; Frist Fr 08.08., Reserve = Fr)

| Tag | Kritischer Pfad | Parallel |
|---|---|---|
| Sa 02. | Bauplan (dieses Doc) · Lager-TP1-Abnahme · OS-U1/U2 · A13-M1 | FK-0 · HY-D1/D2 · Thesis-Nachbesserung · Owner-Fragen §3 |
| So 03. | OS-U3–U5 · A13-M2 (nach Q1) | FK-1–FK-3 · E04-P1 · A16-P3/P5 |
| Mo 04. | A13-M3+M4 (+FK-5 im Fenster) · W10-Zellwerte | E04-P2-M3a · A16-P2-Stufe1 · A16-P4 |
| Di 05. | A2-SHA512-Gate (auf v6-Fingerprint) · G-E6/G-E7-Lager-Rest | E04-P2-M3b/P3 · FK-4 · A12 NAS-Creds |
| Mi 06. | Beweise 1–5 (inkl. §61-Dual-Weg) · 12-Perm · E04-P4 | A16-P1-Dossier · OD-10-RT · E-04/E-18-Rest (A7) |
| Do 07. | J-Kette · heavy-Signal · **Kalibrierlauf** · ETA · **Trigger AUTONOM** | xlsx-Writer-Start · Benchmarking-Schnitt |
| Fr 08. | Voll-Bau-4 läuft · Reserve/Nachzügler | Thesis-Rahmen-Finalisierung |

Nicht auf dem kritischen Pfad, aber Pflicht vor Trigger: A8 Benchmarking-Schnitt, A9 xlsx, A10 P4–P6, A11 — werden in die Parallel-Spuren eingetaktet; ehrliche Warnung: Das Fenster ist voll; Verzögerung bei A13-M3 ODER den Owner-Antworten Q1/Q2 verschiebt den Trigger-Tag.

## 3. Owner-Fragen aus der Designplanung (gesammelt; Q1/Q2 sind SEQUENZ-KRITISCH)

- **Q1 BEANTWORTET (Owner ~12:1x): KLAMMER-FORM** — Q-A-Auflage gilt (Klammer-Anzahl kodiert die Ebene); Punkt-Pfad-Empfehlung verworfen; A13-M2 baut die Klammer-Erweiterung des consteval-Parsers als Pflichtteil. **M2 ist entsperrt.**
- **Q2 BEANTWORTET (Owner ~12:1x):** Strategie wird durchgeführt, lebt im Stempel NUR über das 'e'-Suffix; Differenzierung über erweiterte hierarchische Algorithmus-Namen (`prt-art.memory.abc@1.0.0`, ce nach gleichem Muster). Lager-Key-Eindeutigkeit über Namens-Erweiterung + CT-Wache (byte-verschiedene Merge-Binaries nie namensgleich). **M3 ist entsperrt.** Wortlaut: Owner-Doc Nachtrag.
- **Q3 BEANTWORTET (Owner ~17:0x, ERSETZT die Empfehlung): FLAG-GRAMMATIK.** Kurzform VERBOTEN; Versionen immer `vX.Y.Z` + Hardware-Flag (`c`=CPU/`g`=GPU/`f`=FPGA/`n`=NPU) + optional `e`; CPU-only ⇒ alle Versionen enden `c`/`ce` (`v1.0.0c`, `v2.3.4ce`). → Paket **A13-M1b** (Welle 2): v1e-Kurzform-Rückbau, Flag-Parser, „genau-ein-HW-Flag"-Wache; Bestands-Migration `v1.0.0`→`v1.0.0c` ins EINE M2/M3-Neuanker-Fenster gebündelt. Wortlaut: Owner-Doc Nachtrag.
- **Q4:** CSV-Zell-Token für bau-gescheiterte Permutationen = `nicht_gebaut` (auswerte-sichtbar, analog `gesperrt`) — ok?
- **Q5:** E-24-Bündelung ins EINE 4→5-ABI-Fenster (F1b+F2+#37+E-24) bestätigen; Graph-Gattung: eigener Entscheid jetzt oder nach Abgabe?
- **Q6:** Hybrid: Ein-Gattung-Lesart (ein Hybrid-Binary je Gattung) bestätigen; Dock-Array-MaxN Default 8; LEDGER:187(e) „Heuristik-Optimierung als eigene Systemachse" durch E1-Stufen-Modell superseded?
- **Q7:** E-04: [PRUEF-TESTAT]-Semantik je-FENSTER statt je-Perm (Trace-Parser ziehen nach) — ok?
- **Q8 (NUR-KENNTNIS, Pflicht-Meldung vor OS-U3):** A-08 sagte „statisch, RT vorbereitet"; wir bauen sofortige Laufzeit-Erhebung nach deinem 27.07.-KERN (HW-Werte nie statisch, declared→Cross-Check). Einspruch nur nötig, wenn du die Statik-Lesart willst.
- **Q9 (NUR-KENNTNIS):** thesis-Ledger als docs/ledger-sections/*.md im Abgabe-Repo (privat, CI-inert, Owner-Identität) — Einspruch nur bei Nein.

## 4. Zuweisungs-Matrix (Arbeitsweise v2.1)

Design/Review/Synthese: erledigt (Fable xhigh) · Struktur/Gerüst nach Design: **Opus 5 xhigh** via Workflow (OS-U1/U2, FK-0/FK-3-Gerüst, E04-P1-Marker, A16-P3/P5, HY-D2-Stubs) · Schwere/neue Logik: **Codex gpt-5.6-sol ultra** (A13-M3, E04-P2-Nachtest-Frame, OS-U3-Proben, FK-2-Migration) · Leicht/Infra: **Opus 4.8** (Doku-Nachzüge, A16-P2-Handout, Ledger-Nachträge) · Dual-Review Fable+Codex je Landung · Manager: Abnahmen, gitleaks, R4-Serialität, Truth-Checks, Owner-Kommunikation. Session-Limit-Fenster (bis 12:30 UTC) überbrückt der Manager mit Eigenarbeit (Doc-/Thesis-Strecke), Worker-Wellen starten nach Reset.
