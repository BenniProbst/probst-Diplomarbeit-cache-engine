# Sammelstrecke Leser 6 — Ledger Zeilen 23001-27600

Quelle: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (Segment 23001-27600 von 32210)

| KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| §45-Voll-Bau-GATE | AUFGABE | Z23001 | ERLEDIGT (via §46, CI gruen 16/16 Legenden-Jobs) | CI/Legenden-Kette |
| §44.5-W7-Child-Submodul-Auth | AUFGABE | Z23001 | CI-BEWIESEN (via §46, REV-17-Deploy-Token, 5 E2E-Runden) | Deploy-Token-Fluss |
| Migration-A1/A5/A7 | AUFGABE | Z23001 | VERTAGT (GO via §52-B15, 3 Auflagen, ans Projektende geparkt) | Modul-Migration |
| §48-KORREKTUR-§13.3-#266 | REGRESSION | Z23001 | OFFEN (config-Owner-Gate bleibt einziges offenes Gate; §48 hatte faelschlich als erledigt gelistet) | Doku-Korrektur |
| §54-T1-T7-Konformitaets-Audit | AUFGABE | Z23005 | TEIL/ERLEDIGT (2026-07-20 A10) | Terminologie-Nachzug §47/§48/§50/§51 |
| §54-T1 | AUFGABE | Z23006 | ERLEDIGT (Inline-Pointer gesetzt) | Achsen-TYP statt Achsen-Gattung |
| §54-T2 | AUFGABE | Z23007 | TEIL (additive Vermerke Doc23/16/NW1/NW2/§28/§47 gesetzt) | measurement_categories=Mess-Tooling-Unter-Achsen |
| §54-T3 | AUFGABE | Z23008 | OFFEN | einkompilierter Achsen-Satz = System-Achsen ∪ 17 Organ-Achsen |
| §54-T4 | AUFGABE | Z23009 | ERLEDIGT (Pointer §10.1-E4->§54-T4 gesetzt) | Permutations-Baum je Achsen-Typ statt je Gattung |
| §54-T5 | AUFGABE | Z23010 | OFFEN | Hardware-Haupt-Achse verwaltet/gibt Meta-Meta-Achsen frei |
| §54-T6 | REGRESSION | Z23011 | BEHOBEN (Plan-Spiegel korrigiert, Code seit S0.5/§56 sauber, grep-Beleg==0) | tier:build-Legende Mess x System (falsch) |
| §54-T7 | AUFGABE | Z23011 | ERLEDIGT (mit T6 behandelt) | Legenden-Trennung Measurement/Tier-Build |
| §54-Rest-Schuld-19-zu-17 | AUFGABE | Z23012 | VERTAGT (laeuft als §50-M-4) | volle Terminologie-Umsetzung Thesis-Text |
| §9-METAPROG | AUFGABE | Z23013 | OFFEN kritisch bindend | Metaprogrammierungs-/Interface-Doktrin, Research-Zellen |
| §19.F-Kadenz/§19.E-4 | AUFGABE | Z23014 | OFFEN kritisch stehend | Verifikations-Kadenz je Increment (ctest+golden+cf22+Mojibake+Remotes+CI) |
| §33-Beweis-Doktrin | OWNER-ENTSCHEID | Z23015 | OFFEN kritisch | golden-320 KEIN Systembeweis, nur new-golden Voll-Konfig-Lauf beweist |
| §21.E-Sweep | AUFGABE | Z23016 | TEIL hoch | Konformitaets-Sweep-Roadmap #38-#48, gemeinsames ABI/golden-Fenster |
| §50-K-5 | REGRESSION | Z23017 | OFFEN hoch (Daten-Korrektheit) | best_binary_selector ABI-Spiegel stale kAbiMajor=5 vs Host-ABI 6 |
| §50-9dim-G3 | FEATURE | Z23018 | OFFEN hoch | ThesisProfile-system_axes-Feld+Baum-Verdrahtung, COMDARE_PILOT_ENV entfaellt |
| §20.B-Fehlerklassen | AUFGABE | Z23019 | TEIL hoch | Fehlerklassifizierung alle Achsen->Unter-Achsen->Algorithmen (#29 SampleStatus-Split) |
| §23.A-Direktive | OWNER-ENTSCHEID | Z23020 | OFFEN bindend | std::variant-Verbot Haupt-Achsen, Hybrid-Ausnahme via §49 |
| §24.E-#54 | AUFGABE | Z23021 | OFFEN mittel | Nachweis Achsen weiter XML-B+-Baum-gesteuert, kein Bypass |
| §25-2-Audits | AUFGABE | Z23022 | TEIL mittel (7/7 done via §52-B13, Rest 2 Prosa-Drifts) | 9-Dim+Ketten-Konformitaets-Fix-Listen G1-G10/P1-P8 |
| §26-07-16-AUDIT-83 | AUFGABE | Z23023 | OFFEN mittel | F57 noexcept-auf-Alloc ~15 Bodies + DATA-07 vor #46 |
| §50-K-13 | REGRESSION | Z23024 | BEHOBEN (ERLEDIGT-STALE A11 2026-07-20, live 17/82) | axis_registry.xml-Drift 18/86 isa-composition vs HEAD |
| §15.8-g-F62 | REGRESSION | Z23025 | OFFEN mittel user-gated | W4-CI-Coverage-Defizit Surrogat hart, W4-Treiber 0 CI (Fork B) |
| §26-Quick-Wins | AUFGABE | Z23026 | ERLEDIGT (A11 2026-07-20) | golden-neutraler Batch sizeof==1272, host_compatible_with etc. |
| §13.10-OFFEN-Quellen | AUFGABE | Z23027 | OFFEN niedrig | nicht gesichtete Quellen Doc29, S7-DEG, ch4-3.3-Historie |
| §50-9dim-constexpr-Gate | AUFGABE | Z23028 | OFFEN niedrig | 9dim-constexpr-Freigabe compile-time-Naht fehlt |
| §50-9dim-Dach-Rehang | AUFGABE | Z23029 | OFFEN niedrig | topics::AxisBase->topics::Axis<Derived> umhaengen |
| §52-B13-Rest | REGRESSION | Z23030 | OFFEN niedrig (Doku/Label-Kosmetik) | 2 Prosa-Drifts (History-Zeilen alte "19", perm_runner.hpp:45) |
| §25-2-Audits-G4G5G8G9G10-a1a2 | AUFGABE | Z23032 | BEHOBEN (VERIFIZIERT ERLEDIGT via §52-B13) | a1a2-Verzeichnis-Zyklus 7/7 im IST-Code |
| §23.A-Hybrid-Ausnahme | OWNER-ENTSCHEID | Z23032 | ENTSCHIEDEN (Option 1+3, IMPL-offen) | variant nur dyn. Traeger via §49/§49-KORREKTUR |
| §0-V6.3/V6.4/V6.6 | OWNER-ENTSCHEID | Z23036 | OFFEN kritisch dauerhaft bindend | ultracode-Planungssession, User-Bau-Release-Gate, Deadline 28.07. |
| §15.10-G | OWNER-ENTSCHEID | Z23037 | OFFEN kritisch bindende Sperre | golden/ABI, Loeschungen, V32-Rueckbau, Overleaf-Push, Cluster-Write, G6-Trigger HART GESPERRT |
| §53-PLAN-V2/§49-S1-S8 | OWNER-ENTSCHEID | Z23038 | VOLLES GO je-Phase-gated kritisch | Roadmap S1-S8+parallele Straenge S10-S23 |
| §16.4-DIR | OWNER-ENTSCHEID | Z23039 | OFFEN bindend | offene Entscheidung erst Ledger+Plandocs lesen sonst PAUSIEREN |
| §20.E-Gated | AUFGABE | Z23040 | TEIL mittel | S-7-Deep-Research+G5/#274 |
| §26-USER-GO-Forks-D/§44.8 | AUFGABE | Z23041 | GEPARKT mittel | O-1 rm Mess-CSVs(Konflikt), E-2 opt-Timing, O-3/5/6 golden-N, O-7..11 Storage-Policy, O-13 Nummern-Kollision |
| §50-§0-DoD5/#193 | AUFGABE | Z23042 | OFFEN mittel | EXPERIMENT_MODE+MANUAL_RUN.md eigene DoD-Zeile |
| §8-User-gated/#225 | AUFGABE | Z23043 | GEPARKT niedrig | Second-Execution-Grundsatz nur Diskussion |
| §50-Parallel-Modell | AUFGABE | Z23044 | OFFEN niedrig | 7 Straenge+Gates SYNC-1(INC-2)/SYNC-2(Messlauf vor 28.07.) |
| §53-VOLLES-GO-Supersede | OWNER-ENTSCHEID | Z23046 | ENTSCHIEDEN | supersediert §49-Scope, volle Roadmap inkl. S10-S23 |
| §53-W11-Async-Freigabe | OWNER-ENTSCHEID | Z23046 | ENTSCHIEDEN FREIGEGEBEN+PFLICHT | async NUR Binary-Erstellung/-Upload minio, git+Mess-Sink synchron |
| §52-B15-Modul-Migration-GO | OWNER-ENTSCHEID | Z23046 | ENTSCHIEDEN VERTAGT (3 Auflagen, Projektende geparkt) | Modul-Migration |
| §55-PFLEGE-HINWEIS-SSOT | OWNER-ENTSCHEID | Z23048 | ENTSCHIEDEN | §55 SSOT statt §48 (§48 deprecated, nicht geloescht) |
| §55-SSOT-Uebergang-V7 | OWNER-ENTSCHEID | Z23050 | GESTRICHEN/UEBERHOLT (SSOT-Rolle an §0-GOAL-V7 uebergegangen, Stand 26.07.) | Zahlen ueberholt: 18 Organ-Achsen, ABI-7, 3 System-Haupt-Glieder |
| §56-Legenden-Vertrag-Korrektur | OWNER-ENTSCHEID | Z23054-23056 | ENTSCHIEDEN (2026-07-20, User verbatim) | tier:build=System x Organ, Mess-Achse baut nur CEB |
| §56-Legenden-Vertrag-Definition | FEATURE | Z23058-23061 | ENTSCHIEDEN | ceb:build:[a,b,c] / tier:build:[d,e,f][g,h,i] / measure:[a,b,c][d,e,f][g,h,i] |
| §56-Wurzel-T6-Regression | REGRESSION | Z23064 | BEHOBEN (in-place korrigiert, 2 Stellen) | §54-T6 selbst falsch formuliert (Ledger) |
| §56-Fortpflanzung-§55 | REGRESSION | Z23065 | BEHOBEN (additiv superseded) | betroffene Anker 2347,2399,2486,2726,2737,2738,2752,2759,2801,2810,2811,2911,2921 |
| §56-PLAN-V2-sauber | AUFGABE | Z23066 | BESTAETIGT sauber | Fehlform nur in v3-Korrektur-Sektion Z.582-643 + Code |
| §56-CODE-TIER-LEGENDE | REGRESSION | Z23068-23069 | BEHOBEN (committet ce c96a4da1/super 9eecdc6, 5 Key-Tests+252-Sammellauf gruen) | plan_legend.hpp:109-111 tier_build_job |
| §56-T2-FANOUT-SEQUENZ+D4 | AUFGABE | Z23071 | TEIL (Kern GEBAUT+committet, N>1 gated) | measurement_tooling_registry.hpp, Sequenz D1->D2->D4 |
| §56-Stand-26.07-V7.1/V7.2 | AUFGABE | Z23073 | AKTUALISIERT | 18 Organ-Achsen T00-T17, ABI-7, golden CRC64 0x56F1B721C72DC10E, 3 System-Haupt-Glieder |
| §56-S0-Audit-Revision-AP-S0-6 | REGRESSION | Z23076 | REVIDIERT (SAUBER->RESIDUE/VERSTOSS) | T6 zweite RESIDUE neben T2 |
| §56-Scope | AUFGABE | Z23079 | Doku-Fixes erledigt, Code-Fix GO-pflichtig | Tier-Build-Job-Legende isoliert von ceb:build/measure |
| §57-Stempel-Schichtung-Chunk-Semantik | OWNER-ENTSCHEID | Z23083-23085 | ENTSCHIEDEN (2026-07-20, User verbatim) | praezisiert §54-T3/T6+§56 |
| §57-S1-Compile-Runtime-Grenze | FEATURE | Z23087 | DEFINIERT | Planer/CEB/Tier-Binary Compile/Runtime-Grenzen |
| §57-S2-Chunk-Semantik | FEATURE | Z23092 | DEFINIERT (praezisiert §56) | CEB-chunk=Erlaubnis+tobecompiled, Tier-chunk=Durchfuehrung+kompiliert |
| §57-S3-Stempel-Schichtung | FEATURE | Z23097 | DEFINIERT | CEB-Stempel=Mess-Achse, Tier-Stempel=System x Organ, binary_id bleibt Organ-only |
| §58-Versionierungsmodell | OWNER-ENTSCHEID | Z23104-23106 | ENTSCHIEDEN (2026-07-20, User verbatim) | Planer X.Y.Z, CEB-Array, Tier-2-Arrays, CSV voll-permutativ, Replay, Async-MinIO |
| §58-V-Stempel-Hierarchie | FEATURE | Z23108 | DEFINIERT | Planer/CEB/Tier/CSV: keine Gesamt-Versionierung ausser Planer |
| §58-C-Caching-Replay | FEATURE | Z23114 | DEFINIERT | suchen->Replay-oder-Materialisieren, koppelt §51-B7+§35+W12 |
| §58-S-Async-MinIO-Storage | FEATURE | Z23117 | DEFINIERT | Planer-Binary+CEBs+Tier+CSV async, git/Mess-Sink bleibt synchron |
| §58-STEMPEL | AUFGABE | Z23121 | OFFEN hoch GO-pflichtig | Stempel-System auf Arrays umstellen (kOrganAxisVersionLine etc.) |
| §58-CSV-STEMPEL | AUFGABE | Z23122 | OFFEN hoch | CSV-Benennung+Spalten voll-permutativ |
| §58-REPLAY | AUFGABE | Z23123 | OFFEN hoch | Planer-Caching-Replay als Lazy-Materialisierungs-Erweiterung |
| §58-MINIO | AUFGABE | Z23124 | OFFEN hoch | Async-MinIO-Persistenz Planer/CEB/Tier/CSV |
| §59-Kern-Mess-Schema-Steuerung | OWNER-ENTSCHEID | Z23128-23130 | ENTSCHIEDEN "schon immer Gesetz", Abweichung=Regression | Mess-Schema-Steuerung=KERN, Default=ALLES messen, XML=neg. Blacklisting |
| §59-A-3-Mess-Stufen | FEATURE | Z23132 | DEFINIERT (existiert im IST-Code, katalog-verdrahtet auf 1 Pruefling `prt_art`) | CE allein / Pruefling replace-merge / fulljoin |
| §59-B-XML-Steuerung | FEATURE | Z23139 | DEFINIERT | Messmodi, per-Achse merge/replace, Pruefling-Wahl, Whitelist, Template |
| §59-C-id-Satz-Storage-Stempel | FEATURE | Z23146 | DEFINIERT | eigener id-Satz je Pruefling-Merge, Storage lokal/minio, dritter Tier-Stempel=Merge-Kombination |
| §59-golden-Konsequenz | AUFGABE | Z23150 | BESTAETIGT byte-identisch | ce-only-golden 0xF1C1F26A1232073B unveraendert |

| §59-D-Anatomy-Stempel-Vorlage | FEATURE | Z23153 | DEFINIERT | Mess-Tooling Unter-Achse compile-time fix, N>1 erst S6 |
| §59-E-Bau-Sequenz-K1-K8 | AUFGABE | Z23156 | DEFINIERT/TEIL | KERN-A(K1-K4,K6 golden-neutral)/KERN-B(K5,K7a golden-Fenster)/Post-Abgabe(K7b,K8) |
| §59-F-golden-Klassifikation | AUFGABE | Z23161 | BESTAETIGT | golden-gated=S2/A1, Band-B golden-neutral; #19 loest sich in S4-KERN auf |
| §59-6-Forks | OWNER-ENTSCHEID | Z23167 | ENTSCHIEDEN (User-GO 2026-07-20) | Phasen/Traeger/CacheEngine-Pruefling/Merge-Default/extend/K5-additiv |
| §59-SCHEMA | AUFGABE | Z23171 | OFFEN kritisch | K1-K4+K6 Schema/Parser/XSD/validate/Director/Auto-Phasen |
| §59-EMITTER | AUFGABE | Z23172 | OFFEN hoch | K5 sota_module_for katalog->direktiven-getrieben |
| §59-MERGE-STEMPEL | AUFGABE | Z23173 | OFFEN hoch GO-pflichtig | K7a Merge-Stempel-POD 56->72 |
| §59-STORAGE | AUFGABE | Z23174 | OFFEN hoch | K7b/K8 id-Satz je Merge/Join, lokal/minio |
| §59-TEMPLATE | AUFGABE | Z23175 | OFFEN mittel post-v3 | benanntes template-Element+restrict/extend+Paper-als-Pruefling |
| §59-G-Session-Chronik | AUFGABE | Z23178 | DOKUMENTIERT | voller Kontext-Log in docs/sessions/2026-07-20-... |
| §59-Offen-main-Lag-Merge-Timing | OWNER-ENTSCHEID | Z23181/23223 | OFFEN (User-Entscheid steht aus) | ce development->main Band-A-Abgabe-Merge |
| §59-Security-PAT-Rotation-#327 | REGRESSION | Z23181/23225 | OFFEN (nicht autonom rotiert) | Vault-PAT-Exposition |
| §59-E3-page_type-Heimat | AUFGABE | Z23181 | BEHOBEN (aufgeloest via §52-B10) | RAUM=System axis_12 HW4, DURCHSETZUNG=Organ AllocPageHint |
| §59-KERN-Frage1-XML-Blacklisting | OWNER-ENTSCHEID | Z23190 | VERBATIM ENTSCHIEDEN | vollstaendiges Mess-Schema-XML-Zitat (Kern des Planers) |
| §59-Frage2-CI-getrieben-GO | OWNER-ENTSCHEID | Z23191 | ENTSCHIEDEN | "Volles GO. Jetzt anstossen, direkt los CI-getrieben" |
| §59-Band-B-Reparatur-Auftrag | AUFGABE | Z23192 | BEAUFTRAGT | ultracode Diff gegen Plan ergruenden+reparieren |
| §59-S3-Resolver-GO | OWNER-ENTSCHEID | Z23193 | VOLLES GO | fehlplatzierte Achsen sofort beheben |
| §60-R1-so-ABI-Vertrag | AUFGABE | Z23235 | OFFEN hoch Post-v3 | Planer<->CEB C++23 modules .so ABI-stabil statt Textemission |
| §60-R2-Driver-Split | AUFGABE | Z23236 | OFFEN hoch->ANALYSE-BEANTWORTET | measurement_driver Planer/CEB verteilt, Konsolidierung nicht geboten |
| §60-R3-Planer-CLI | AUFGABE | Z23237 | OFFEN hoch Post-v3 | CLI fuer Bauen/emit+Logging Zustand/Builds/Messungen |
| §60-NACHTRAG-Post-v3-Reihenfolge | OWNER-ENTSCHEID | Z23241 | FREIGEGEBEN GO | CLI-Haertung->Fork-A-so-Schnitt->#19-Resolver->F-SPREAD->nachrangig |
| §60-Sofort-Hygiene | AUFGABE | Z23241 | ERLEDIGT | Deprecation-Banner module_loader.hpp+2 stale Kommentare auf PL-0 |
| §60-Nicht-Wiedereinfuehren | OWNER-ENTSCHEID | Z23241 | ENTSCHIEDEN (bleibt gesperrt) | variant-Insel/alte Loader-Welt/Surrogat-Strang/IS_ORIGINAL-Macro |
| §60-PV-1-so-ABI-Vertrag | AUFGABE | Z23246 | OFFEN (Task #35) | Planer<->CEB |
| §60-PV-2-Driver-Split | AUFGABE | Z23246 | ANALYSE-BEANTWORTET | Haupt/Unter-Delegation, kein eigener Bau-Task, feeds #35 |
| §60-PV-3-Planer-CLI | AUFGABE | Z23246 | OFFEN (Task #34) | §60-R3 |
| §60-PV-4-Paper-Template-Profile | AUFGABE | Z23246 | OFFEN (Task #44 NEU) | CE-+PRT-ART-Registry je Paper |
| §60-PV-5-Anatomy-Stempel-Weiterentwicklung | AUFGABE | Z23246 | TEIL (K7a GELANDET, K7b=Task #38/G1) | Stempel-Array |
| §60-PV-6-Pruefling-Merge-Caching | AUFGABE | Z23246 | TEIL (Stempel GELANDET, Rest Task #38/K8) | id-Satz/minio/Mess-Kategorie |
| §60-PV-7-Anhaenge-B-E-autonom | AUFGABE | Z23246 | OFFEN (stehendes Abgabe-Gate #24) | letzter Ketten-Schritt aus XML-Experiment-Ergebnissen |
| §60-PV-8-Reihenfolge | AUFGABE | Z23246 | FREIGEGEBEN | #34-37 |
| §60-PV-9-Kurations-Pflicht | AUFGABE | Z23246 | LAUFEND | deprecated-Audit-Doc |
| §60-Full-Join-TODO-Liste | AUFGABE | Z23249-23250 | DEFINIERT (Reihenfolge #34/#35/#36/#44/#38/#37) | v3-Strang zu Ende dann Full-Join-Liste (U-18) |
| §60-Full-Join-Gate-getrieben | AUFGABE | Z23250 | OFFEN (Gate-getrieben) | Legacy-Mikrobench, SLURM-KF-12, A16-Pinning, A17-F-A/F-B, A13-Locking |
| §60-Alt-Backlog-G1-G7 | AUFGABE | Z23250 | VERTAGT (separater Merkposten Band-C/D) | #38-#43 |
| §60-S6-GO-320er-Messlauf | OWNER-ENTSCHEID | Z23252 | FREIGEGEBEN (2026-07-21 frueh) | F1-F4 Rulings, wallclock-first, m3v2-320 Abgabe-Satz |
| §61-Dual-Weg-Pflicht | OWNER-ENTSCHEID | Z23258 | OFFEN(Luecke)/bindend | GitLab-CI+lokal cmake+Shell fuer ALLE Funktionen, praezisiert §15.10-B |
| §61-Dual-Weg-Namens-Korrektur | AUFGABE | Z23259 | OFFEN (0 Durchfahr-Belege seit 27.07., laeuft unter A3/G.5) | comdare_tier_measure_<host> statt _perm<i> |
| §61-Debug-Parallelitaet | OWNER-ENTSCHEID | Z23261 | FREIGEGEBEN | max Parallelitaet aller CPU-Threads fuer Debug-Laeufe; echte Messung Release+sequentiell |
| §61-Debug-Parallelitaet-Regression | REGRESSION | Z23261 | BEHOBEN (Korrektur smoke-Mode->debug-Methodik) | Smoke-Messjob lief faelschlich in measure-Methodik (1-Thread) |
| §61-Multi-Maschinen-Parallel-Pflicht | OWNER-ENTSCHEID | Z23263 | PFLICHT | resource_group je Maschine statt global, Host-Lanes amd/intel |
| §61-Anker-Nachtrag | AUFGABE | Z23265 | DOKUMENTIERT (Herkunfts-Karte) | Dual-Weg/Debug-parallel/Multi-Maschine Provenienz |
| §61-38b-Revision | OWNER-ENTSCHEID | Z23268 | REVIDIERT (GLOBAL->PRO MASCHINE) | §38.b Messung war global-exklusiv, jetzt pro Maschine |
| §61-Modi-Volldefinition | OWNER-ENTSCHEID | Z23270 | ENTSCHIEDEN "war schon immer so" | Debug/Messung/Release-Modi-Definition |
| §61-Modi-Messung-Regression | REGRESSION | Z23272 | OFFEN (Fix in S6-P1(g)) | S5-measure-Job setzt COMDARE_BUILD_PARALLEL=1 (sequentieller Bau) faelschlich |
| §61-Release-Ziel-Gesamtprojekt | OWNER-ENTSCHEID | Z23274 | DEFINIERT | Messwerte->Break-Even-Heuristik->Hybrid-Tier-Binaries->finale schnellste Binary |
| §61-Release-Wallclock-Beweis | AUFGABE | Z23275 | OFFEN (verankert an #17/G3) | eigener Deliverable-Schritt S7/Post-Kette |
| §61-Stufen | OWNER-ENTSCHEID | Z23277 | PFLICHT fuer CI | Debug->Messung->Release stufenweise, Compile-Einstellungs-Stempel |
| §61-Stufen-Praezisierung | OWNER-ENTSCHEID | Z23283 | ENTSCHIEDEN | Debug=Dual-Compile, Modus-Wahl per XML exactly-one |
| §61-Konsolidierung-a | AUFGABE | Z23288 | SUPERSEDIERT | Z.3166-Halbsatz smoke-Mode-Korrektur ueberholt durch Stufen-Praezisierung |
| §61-Konsolidierung-b-paralleler-Mess-Loop | REGRESSION | Z23289 | BEHOBEN (Stand 03.08., Task #45 GEBAUT) | measure_parallelism.hpp+parallel_measure_pool.hpp, COMDARE_MEASURE_PARALLEL |
| §61-Konsolidierung-c | AUFGABE | Z23291 | PRAEZISIERT | ceb-measurement-exclusive gilt pro Maschine, sequentiell=nur Messen |
| §61-Konsolidierung-d-F4-Multi-Maschine | AUFGABE | Z23292 | AUFGELOEST | Mess-Tooling-Combo entscheidet Host-Lane statt SIMD-Lane-Regel |
| §61-Konsolidierung-e | AUFGABE | Z23293 | Lesart geklaert | Debug-Modus Default vs. Provisions-Strang kein Widerspruch |
| §61-Konsolidierung-f-Dual-Compile-Parallel | AUFGABE | Z23294 | AUFGELOEST (Nacht-Audit-Auflage B4, 22.07.) | Vollzug sequentiell, beide Staende je Debug-Lauf |
| §62-A-Planer-Universalitaet | OWNER-ENTSCHEID | Z23296-23300 | ENTSCHIEDEN (supersediert Runner-Tag-Vorfilterung) | Planer anspruchslos, baut/misst auf jeder Maschine, Warnungen statt Vorfilter; (h)/(k)-Host-Lanes INTERIM |

| §62-B-Cache-Log-Koordination-#46 | FEATURE | Z23302 | DEFINIERT | SYNC-Datei auf minio.comdare.de, teamfaehig |
| §62-B-3-Stufen-Dedup | FEATURE | Z23303 | DEFINIERT | bereits gebaute Planer/CEB/Tier nie erneut gebaut |
| §62-B-Batch-Reservierung-Versprechen | FEATURE | Z23304 | DEFINIERT (ZWINGEND) | Reservierung immer aufheben bei Beendigung, Lease/Timeout |
| §62-B-Binary-Sync | FEATURE | Z23305 | DEFINIERT | Binaries ueber Cache zwischen Maschinen gesynct, parallel gebaut+gemessen |
| §62-B-Symmetrie-Prinzip | OWNER-ENTSCHEID | Z23307 | ENTSCHIEDEN (User 21.07.) | prod1+prod2 bauen alles was sie koennen, gleiche XML, Cache-Sync live PFLICHT |
| §62-B-Batch-Job-Prinzip | OWNER-ENTSCHEID | Z23308 | ENTSCHIEDEN (User 21.07.) | NIE Einzel-Jobs je Binary, EIN Gesammel-Job/Chunk-Batch-Jobs, O(konstant) |
| §62-B-Batch-Mechanik-CEB-intern | OWNER-ENTSCHEID | Z23309 | ENTSCHIEDEN (User 21.07., Paket #54) | RUNTIME-BATCH in CEB, GTest-Pruefdock vor Messung, Planer instrumentiert CEB |
| §62-B-IST-Verstoss-Einzel-Jobs | REGRESSION | Z23310 | OFFEN (Umsetzungsauftrag, Position nach K7b vor 320er) | ceb:trigger emittiert Einzel-Jobs je (System-Perm x Chunk) statt Batches |
| §62-B-Log-Flush-Regression | REGRESSION | Z23310 | OFFEN (Flankierender Pflicht-Fix) | Mess-/Batch-Lauf flusht Log nicht (3,5h stumm), Fix zeilengepuffert+Heartbeat |
| §62-B-Bestandsdokument | FEATURE | Z23312 | DEFINIERT (Heimat #46b) | versioniertes gelocktes XML-Bestandslog fuer ccache-Binaries |
| §62-B-Gleichverteilungs-Pflicht | OWNER-ENTSCHEID | Z23313 | ENTSCHIEDEN | Binaries beide Maschinen gleichverteilt kompiliert |
| §62-B-Batch-Groesse-4096 | OWNER-ENTSCHEID | Z23314 | ENTSCHIEDEN | Batches stets 4096 Binaries mit Zeitstempel (=kMaxMaterializableCatalogCardinality) |
| §62-B-ETA-Mechanik-Korrektur | REGRESSION | Z23315 | BEHOBEN (KORRIGIERT 22.07., ersetzt 10-Compile-Schaetzung) | ETA=Sum(t_i)/N_threads, Untergrenze=max(t_i), 30min-Kalibrierung |
| §62-B-Takeover-Regel | OWNER-ENTSCHEID | Z23316 | ENTSCHIEDEN | ETA um 50% ohne Update ueberschritten -> Pipeline gilt gestorben, andere uebernehmen |
| §62-B-Planer-Block | FEATURE | Z23317 | DEFINIERT | Planer blockt CEB-Compile direkt im Log, 30min-Reservierung |
| §62-B-Done-Semantik | FEATURE | Z23318 | DEFINIERT | Reservierungen/ETAs nach Batch-Fertigstellung aufgehoben+Done markiert |
| §62-B-Neu-Inventarisierung | FEATURE | Z23320 | DEFINIERT | ccache-Bestand neu inventarisiert bei Log-Loeschung/neuer Version |
| §62-B-Schreib-Lock-Semantik | OWNER-ENTSCHEID | Z23321 | ENTSCHIEDEN (Praezisierung-3) | Bestandslog gelockt beim Schreiben, endet spaetestens mit 30min-pro-forma |
| §62-B-Praezisierung-4-Multi-Write | OWNER-ENTSCHEID | Z23322 | ENTSCHIEDEN (User 22.07.) | Multi-Write ab Kompilierbeginn, ETA je Block wiederholt, Batch-Typen nie gemischt, Thread-Budget prod1=32/24 prod2=24/16 |
| §62-B-Praezisierung-2-Zwei-Bestandssysteme | OWNER-ENTSCHEID | Z23327 | ENTSCHIEDEN (User 22.07.) | Factory Pattern Binaries+Messergebnisse SEPARAT, je eigenes Bestandslog |
| §62-B-SHA512-Fingerprint-Stempel | FEATURE | Z23329 | DEFINIERT (Heimat #46b, Materialisierung K7b/G1) | constexpr SHA512 ueber Stempel-Zeilen, std::map-Lookup |
| §62-C-Modi-je-Maschine-Compare | FEATURE | Z23333 | DEFINIERT | 4. Modus COMPARE nach Release, run_methodology exactly-one |
| §62-C-CI-Fertigkeits-Gate | OWNER-ENTSCHEID | Z23333 | DEFINIERT | CI fertig erst wenn XML auf ALLEN gewuenschten Maschinen ausgewertet (#48-Syntax) |
| §62-C-F4-Aufloesung | OWNER-ENTSCHEID | Z23333 | ENTSCHIEDEN | Optionen A/B/C vereinbar+Pflicht statt getrennt |
| §62-C-Terminologie-bt-Compile-Typ | OWNER-ENTSCHEID | Z23333 | ENTSCHIEDEN (bewusst nicht aufgeloest) | +bt= traegt cmake-Compile-Typ, NICHT Modus |
| §62-D-Replay-Befugnis-Tabelle | FEATURE | Z23335-23341 | User-bestaetigte Tabelle | CEB=[a,b,c]/Tier=[d,e,f]allein/Messwerte=[d,e,f]+[g,h,i]+HW-Identitaet |
| §62-D-Hardware-Identitaet | FEATURE | Z23343 | DEFINIERT | CPU-Typ+RAM-Frequenz/CAS Aequivalenzklasse modulo ungenutzter Meta-Meta-Achsen |
| §62-D-Binary-Sharing | FEATURE | Z23344 | DEFINIERT | stempel-gekeyt zwischen allen Maschinen geteilt |
| §62-D-Plattform-Provenienz | AUFGABE | Z23345 | GEBAUT (ce d778f8da) | COMDARE_PLATFORM=<lane>@hostname in CSV-platform-Spalte |
| §62-E-Neue-System-Achsen-#49 | FEATURE | Z23347 | OFFEN->UEBERHOLT (s.u.) | RAM Frequenz+CAS-Latenz (a), CPU-Typ/Fabrikation (b) |
| §62-E-Erkennungs-Werkzeuge | AUFGABE | Z23347 | User-GO fuer externe Abhaengigkeit | libcpuid primaer, google/cpu_features Fallback, decode-dimms+dmidecode |
| §62-E-Stand-26.07-Ueberholung | REGRESSION | Z23349 | UEBERHOLT/GESTRICHEN (V7.2: KEINE neuen System-Haupt-Glieder, genau DREI) | RAM/CPU werden Identitaets-Unter-Merkmale statt Haupt-Achsen; offene Owner-Frage OD-2 |
| §62-F-XML-Aufraeum-Gate-#48 | AUFGABE | Z23351 | REIHENFOLGE-DIREKTIVE (F27 aufgeloest) | erst XML-Configs aufraeumen, dann Code weiterentwickeln |
| §62-F-Stand-03.08-Teil-Superseded | REGRESSION | Z23352 | BEHOBEN (experiment_golden_kern.xml existiert seit 27.07., kanonisch) | Eingangssatz "keine geltende golden.xml" falsch geworden |
| §62-F-Rest-Scheibe6-XML-Sync-Gate | AUFGABE | Z23352 | OFFEN (gated nach 320er+GO) | fixture_sync_check.cmake:3 zeigt aufs Alt-Paar |
| §62-G1-Interim-GO-320er | OWNER-ENTSCHEID | Z23354 | ENTSCHIEDEN | 28.07.-320er faehrt mit committeter Lane-Emission waehrend #46 entsteht |
| §62-G3-tier150-Ausnahme | OWNER-ENTSCHEID | Z23354 | ENTSCHIEDEN (aktiv genutzt) | tier150_measurements.csv Ersatz+Loeschung erst nach 320er-Umstellung |
| §62-G-Alte-Mess-CSV-geloescht | REGRESSION | Z23354 | AUSGEFUEHRT (21.07., punktuelle Ausnahme) | E2E-Realdaten-Aggregat+2 Observer-Pilot-CSVs geloescht |
| §62-G-Remote-Branches-Regel | OWNER-ENTSCHEID | Z23354 | STEHEND (E14 beantwortet) | nur loeschen wenn gemerged, sonst behalten |
| §62-G4-Debug-DLL-Compile-Pfad-GO | AUFGABE | Z23354 | ENTSCHIEDEN/GEBAUT (Verdikt B) | COMDARE_BUILD_TYPE=Debug -O0 -g, +bt=Debug; make_gpp_compile_fn war build-typ-blind |
| §62-G-Plattform-Pflicht-Debug | OWNER-ENTSCHEID | Z23354 | PFLICHT | Win11/WinServer/Ubuntu+7 Linux/macOS x86+ARM, toolchain-abstrahiert |
| §62-G5-Pauschal-GO-Empfehlungen | OWNER-ENTSCHEID | Z23354 | ENTSCHIEDEN | #49-Tool-Wahl, O-1 ABGELEHNT bestaetigt, E13 Option1 GO (#41) |
| §62-H-Zielbild | AUFGABE | Z23356 | DEFINIERT | optimale Binaries fuer maximal ausgeschoepfte HW-Rekombination |
| §63-Voll-Freigabe-Autonomie | OWNER-ENTSCHEID | Z23358-23360 | FREIGEGEBEN (auch nachts) | #45/#46/#47/#48/#49/#51 autonom bis leeres Backlog |
| §63-Branch-Regel | OWNER-ENTSCHEID | Z23362 | ENTSCHIEDEN | durchgeplant->main, halb-geplant->development, NIE rebase |
| §63-Nachtrag-Prioritaets-Direktive | OWNER-ENTSCHEID | Z23364 | ENTSCHIEDEN | CI+Caching vorgezogen (#46a, #53) vor 320er |
| §63-Emit-Vertrags-Kette | AUFGABE | Z23366 | GEPLANT (koppelt R1/#35/#36) | Planer->CEB->Tier-Vertraege korrekt aufbauen nach CI-Stand |
| §63-Arbeitsmodus-Wechsel | OWNER-ENTSCHEID | Z23367 | ENTSCHIEDEN | groebere Schritte direkt implementieren+gruendlich lokal testen |
| §63-GO-Stempel | OWNER-ENTSCHEID | Z23369 | VOLLES AUTONOMES GO (auch nachts) | #46a+#53+V1-V5, Scheiben-Kette S4->S1->S2->S3, Fahrplan bis Post-v3 |
| §64-Befund-Mess-Tooling-3-Lanen | REGRESSION | Z23371-23373 | OFFEN (an Smoke 12124) | wallclock/macro/micro einzeln statt Default=vereint, Tests dauern mehrfach laenger |
| §64-Gesetz-XML-getrennt-oder-vereint | OWNER-ENTSCHEID | Z23375 | GESETZ | XML ermoeglicht getrennt ODER gemeinsame Wunsch-Konfig, Default=alle 3 vereint |
| §64-Fundstellen-Nachtrag | AUFGABE | Z23379-23383 | DOKUMENTIERT (Explore 22.07.) | VEREINT=Messarchitektur-V5-Basis, SEPARAT=§47/§54-Umdeutung als Regressionsquelle, Live-Default war ohnehin [all] |
| §64-Versionierungs-Klaerung-SOLL | FEATURE | Z23386 | DOKUMENTIERT (kein Doku-Gap) | Planer=X.Y.Z, CEB=Array je Mess-Achse, Tier=2Arrays+Merge-Stempel |
| §64-Versionierungs-IST-Abweichungen | REGRESSION | Z23387 | OFFEN (4 Punkte) | Einzel-Zeilen statt Array, CEB-Mess-Array fehlt, X.Y.Z reiner Formatter (hart v1), XML-Registries ohne Versionsfelder |
| §64-Stale-Note-Ueberholt | REGRESSION | Z23387 | BEHOBEN (UEBERHOLT) | LED:2447/2785 "kMeasurementAxisVersionLine fehlt" - measurement_line+merge_line existieren real |
| §64-Phase2-Tooling-Provenienz | AUFGABE | Z23388 | GEPLANT (minimaler Slice) | measurement_stamp_line: Menge {wallclock,macro,micro} je-Tool-Version |
| §64-K7b-Vorzug-Pflicht | OWNER-ENTSCHEID | Z23389 | ENTSCHIEDEN (REVIDIERT Post-Abgabe->Pflicht, User 22.07.) | K7b vor/mit 320er, Array-Form+G1-Compile-Stempel+SHA512-Fingerprint |
| §64-Schichten-Zuordnung | FEATURE | Z23391-23394 | BESTAETIGT "jetzt richtig" (User 22.07.) | Wallclock=CEB-Seite, Makro/Micro=CEB+Tier ueber Pruefdock, Ausrichtungs-Mechanik |
| §62-B-Nachtrag-Lagerhaltungs-Amortisation | OWNER-ENTSCHEID | Z23398-23400 | ENTSCHIEDEN (User verbatim 22.07. abends) | ccache verdient Zeit ueber Lagerhaltung zurueck, gruendlich ohne Umwege |
| §62-B-Nachtrag-Amortisations-Logik | AUFGABE | Z23404 | DEFINIERT | 131072 Binaries in 32x4096er-Batches, Wiederaufnahme ohne Totalverlust |
| §62-B-Nachtrag-Reihenfolge-Gesetz | OWNER-ENTSCHEID | Z23405 | ENTSCHIEDEN ("Frist vor Perfektion" VERWORFEN) | S1->S2->S3->S4(Bestandslog-Saat) dann 2^17-Voll-Bau |
| §62-B-Nachtrag-Testat-Grammatik | REGRESSION | Z23406-23409 | BEHOBEN (Korrektur 22.07. abends) | Batch/CEB-Kopf, Bau/Pruef-Testat, Mess-Testat ebenen-richtig getrennt |
| §62-B-Nachtrag-Tier-Zwei-Layer | OWNER-ENTSCHEID | Z23410 | ENTSCHIEDEN (User-Korrektur 22.07. abends) | System[d,e,f]=Hardware-Layer, Organ[g,h,i]=Anwendungs-Layer STRIKT getrennt, auch in CEB-Laufzeit |
| §62-B-Nachtrag-Bestandslog-Schluessel-getrennt | FEATURE | Z23411 | DEFINIERT | [a,b,c]->CEB, [d,e,f]allein->Tier, [d,e,f]+[g,h,i]+HW->Messwert |
| §62-B-Nachtrag-#46b-Persistenz-Pflicht | AUFGABE | Z23412 | OFFEN (PFLICHT vor 01.08.-Voll-Messung) | Bestandslog-Persistenzschicht |
| §62-B-Nachtrag-Praezisierung-Nacheinander | OWNER-ENTSCHEID | Z23413 | ENTSCHIEDEN (User 23.07. frueh) | PFLICHT-Restpunkte in der Kette abschliessen, nicht parken |
| §62-B-Nachtrag2-RAM-Sammelpuffer | OWNER-ENTSCHEID | Z23415-23417 | ENTSCHIEDEN (User-Idee 23.07. mittags) | avg_size im Bestandslog, max 256MB RAM-Cache statt Einzel-Rueckschreibung |
| §62-B-Nachtrag2-Zweiter-Writer-Thread | FEATURE | Z23417 | IDEE (io_uring bevorzugt) | dauerhaftes Rueckstreamen kompilierter Binaries |
| §62-B-Nachtrag2-io_uring-Recherche | AUFGABE | Z23421 | RECHERCHIERT | Kernel 5.19/6.x async buffered writes, Single-Ring-Disziplin, Fallback write(2) |
| §62-B-Nachtrag2-Batch-Planungs-Praezisierung | OWNER-ENTSCHEID | Z23423 | ENTSCHIEDEN (User 23.07. mittags) | per-Binary-Erkennung, async Vorplanung, Producer-Consumer Slice-Queue |
| §62-B-Nachtrag2-Zuordnung-Minimal-vs-Vollausbau | OWNER-ENTSCHEID | Z23424 | ENTSCHIEDEN | Minimal-Teil naechstes Paket nach 2^17-Voll-Bau; Vollausbau=#46b Pflicht vor 01.08. |
| §62-B-Nachtrag2-Plattform-Auflage-io_uring | OWNER-ENTSCHEID | Z23426 | ENTSCHIEDEN (User 23.07.) | 3 CT-Backend-Familien: io_uring(Linux)/IoRing+IOCP(Windows)/portabler write-Thread |
| §65-Storage-Forecast-Doktrin | OWNER-ENTSCHEID | Z23428-23434 | GESETZ (User-Kern a, 23.07. mittags) | Binaries->ccache/minio Ebene B, Messergebnisse->PR4100 Ebene C, lokaler Forecast->NULL |
| §65-Tools-Lagerhaltung-NEU | OWNER-ENTSCHEID | Z23436 | ENTSCHIEDEN (User-Kern b, NEU) | AUCH Toolchain/Treiber-Binaries in minio-Lagerhaltung, Heimat #46b-Familie |
| §65-IST-Befund-Ebene-B-Push-inert | REGRESSION | Z23441-23446 | OFFEN (ultracode wf_2a8f2489, 23.07.) | Ebene-B-Push inert in Director-Jobs, Voll-Bau-Binaries nur lokal, gn_out-Interim MUSS zurueckgebaut werden |
| §65-Lokaler-Forecast-58-65G | AUFGABE | Z23447 | DOKUMENTIERT | Voll-Bau-4 auf prod1 ~58-65G, Platz-Pflege noetig |

| §65-Verlustnaht-Mess-Phase | REGRESSION | Z23450-23453 | BEHOBEN (GESCHLOSSEN, Stand 03.08.) | GIT_CLEAN_FLAGS excludes+artifacts always fuer CSV/logs |
| §65-Folgen-i-ii-iii | AUFGABE | Z23455 | GEPLANT | Push-Aktivierung nach #46b, Tools-Lagerhaltung Post-Abgabe, df-Wache |
| §66-Resequenzierung-Lager-Stempel-Gate | OWNER-ENTSCHEID | Z23459-23463 | GESETZ (User 23.07. mittags) | Lagerhaltung+Stempel-Punkte VOR Voll-Build als Gate |
| §66-Lager-Gate-G1-G5 | AUFGABE | Z23466-23471 | DEFINIERT | G1 B/C/D+amd24, G2 Stempel-Finalisierung, G3 #46b-Kern, G4 Push-Aktivierung, G5 Pruning |
| §66-Voll-Bau-3-Cancel | AUFGABE | Z23472 | AUSGEFUEHRT (23.07. ~12:45) | 12713 gecancelt, Waisen beseitigt |
| §66-Tools-Lagerhaltung-Post-Abgabe | OWNER-ENTSCHEID | Z23475 | VERTAGT (explizit Post-Abgabe) | #32 nicht Teil des Gates |
| §66-Frist-Ehrlichkeit | AUFGABE | Z23477 | DOKUMENTIERT | Gate kostet 1-2 Tage, S8-PDF-Endgate wird eng |
| §66-Opus-Impl-Superseded | REGRESSION | Z23480 | BEHOBEN (SUPERSEDED durch §67) | Opus-Impl-Verweis ab 26.07. durch Fable-5-xhigh ersetzt |
| §66-Nachtrag-Frist-Einordnung | OWNER-ENTSCHEID | Z23482 | ENTSCHIEDEN (User 23.07.) | Lagerhaltungs-Punkte nach vorn, Gate-Gruendlichkeit schlaegt Mo-Termin |
| §66-Nachtrag2-PMC-Doktrin-je-Vendor | OWNER-ENTSCHEID | Z23489 | ENTSCHIEDEN/GEBAUT (ce 194dee57) | pmc:amd/pmc:intel je Maschine hart, kein allow_failure |
| §66-Nachtrag2-PMC-Preflight-#37 | AUFGABE | Z23495 | BEHOBEN (GEBAUT, Stand 03.08.) | per-Lane-PMC-Preflight in Mess-Batch-Jobs (director:1269-1280) |
| §66-Nachtrag2-Praezisierung-Verschiffbarkeit | AUFGABE | Z23498 | GEBAUT (ce 57dc0245) | COMDARE_PMC_LANES deklarierte Vendor-Menge, XOR-Verfuegbarkeit |
| §66-Nachtrag3-Mapping-Reinheits-Doktrin | OWNER-ENTSCHEID | Z23507 | GESETZ (User 23.07. nachmittags) | std::variant verboten in CEB+Tier, nur CT->CT und RT->RT |
| §66-Nachtrag3-Stand-26.07-V7.2-Superseded | REGRESSION | Z23518 | BEHOBEN (SUPERSEDED) | variant in CEB GEDULDET, Tier-Verbot+Mapping-Reinheit bleiben bindend |
| §66-Nachtrag3-Owner-E1-Hybrid-Ausnahme | OWNER-ENTSCHEID | Z23519 | ENTSCHIEDEN (Nachtrag 02.08.) | Hybrid-Tier-Stufe = einzige Ausnahme, Abstract Factory Dock-Array |
| §66-N4-RAM-Sammelpuffer-Compile-Seam | AUFGABE | Z23521 | REALISIERT (Befund 26.07., N-13-Kern) | B6-SpoolWriter+W11-Async-Push-Pump; I2b entfaellt |
| §67-Fable-5-xhigh-Direktive | OWNER-ENTSCHEID | Z23534-23536 | GESETZ (26.07.2026) | ALLE Agenten Fable-5-xhigh, kein Opus mehr (3 Achsen-Fehler von Opus) |
| §68a-Bindende-Achsen-Sortierung | OWNER-ENTSCHEID | Z23540 | GESETZ (Verstoss=Regression) | Mess-Tooling->target_isa->operating_system->external_utils->Organ T00-T17, kSystemAxisOrder |
| §68b-Test-Skip-Gesetz | OWNER-ENTSCHEID | Z23542 | GESETZ (zwei Ebenen) | Voll-Build testet hart, Skip nur bei gruen-inventarisierten Bestaenden |
| §68c-Bau-Pakete-E04-E18 | AUFGABE | Z23544 | GEPLANT (vor Voll-Bau-4-Trigger) | E-04 CI-Live-Fortschritt, E-18 LaTeX-Anhang-Kanal (Hauptziel) |
| §68d-Offen-OD1-OD4 | OWNER-ENTSCHEID | Z23546 | OFFEN (owner-gegatet) | golden-neutral-Ratifikation, O-6-Kanal-Merge-Wortlaut |
| §69.1-R-G-load_framework-Mess-Achse | REGRESSION | Z23550 | BEHOBEN (Owner-Korrektur 26.07.) | load_framework=Meta-Meta-Haupt-Achse der MESS-Achsen statt external_utils-Hub |
| §69.2-OD-2-target_isa-Komplex-Achse | OWNER-ENTSCHEID | Z23552 | ENTSCHIEDEN | RAM-Frequenz+CAS+CPU-Fabrikation=feste Glieder der target_isa-Komplex-Identitaet |
| §69.3-OD-1-ratifiziert-telemetry-Zweiteilung | OWNER-ENTSCHEID | Z23553 | RATIFIZIERT (golden-neutral) | telemetry=runtime-Unter-Achse UND Haupt-System-Achse |
| §69.4-Weitere-GOs-OD4-OD10 | OWNER-ENTSCHEID | Z23556 | VOLLES GO | OD-4/OD-5/OD-6/OD-8/OD-9/OD-10 |
| §69.5-OD-3-Infra-Kanal | OWNER-ENTSCHEID | Z23558 | ENTSCHIEDEN | Fable unterbindet Infra-Themen, Handout an Infra-Agent (Opus-5-xhigh) |
| §69.6-OD-7-Neue-Runner-Zahlen | OWNER-ENTSCHEID | Z23560 | ENTSCHIEDEN | HEAVY concurrency=1, NORMAL prod1/prod2 concurrency=2x12 Threads |
| §69.7-Meta-Direktive-Bauplan-Gates | OWNER-ENTSCHEID | Z23562 | ENTSCHIEDEN | O-1r..O-9 nicht neu fragen, per Explore aus Quellen belegen |
| §69.8-Folge-Arbeit | AUFGABE | Z23564 | GEPLANT | V4-Delta-Kartierung, Explore-Gegenlese, Bau-Start byte-neutral |
| §69.9-Nachtrag-C-3a-Vorab-GO | OWNER-ENTSCHEID | Z23566 | ENTSCHIEDEN (26.07. ~18:55) | C-3a direktes GO sobald Gate faellt, kein weiteres Owner-Gate |
| §70.1-RF-1-measurement_meta_meta | OWNER-ENTSCHEID | Z23570 | VOLLES GO | neue AxisKind-Kategorie additiv, Mess-Stempel-Migration freigeschaltet |
| §70.2-RF-2-D1-gesperrte-Perms-eigener-CSV | OWNER-ENTSCHEID | Z23570 | JA ENTSCHIEDEN | eigener CSV-Datensatz+D1-Token statt sample_status_token |
| §70.3-RF-3-BetriebssystemFeatureFehlt | AUFGABE | Z23570-23571 | BEHOBEN (GEBAUT, Stand 03.08.) | D1-Klasse Count 4->5, axis_error.hpp:50, A15/FK-0+OS-U3 verknuepft |
| §70.4-RF-4-CI-Fallback-Matrizen-Archiv | OWNER-ENTSCHEID | Z23570 | ENTSCHIEDEN | archiviert, nie geloescht, per Infra-Handout |
| §70.5-RF-5-mehr-Kontext | OWNER-ENTSCHEID | Z23570 | OFFEN (erneut gestellt) | V36.B-Codegen-CMake |
| §70.6-RF-6-target_isa-Glieder-je-Maschine | OWNER-ENTSCHEID | Z23570 | ENTSCHIEDEN | RAM/CAS/CPU je Maschine deklariert, System-Achsen tragen build_version statt Algo-Version |
| §70.7-RF-7-Stempel-Klammerung | OWNER-ENTSCHEID | Z23570 | ENTSCHIEDEN | Komplex-Achse=EIN Feld im Haupt-Achsen-Array |
| §70.8-RF-8-telemetry-Sweep-Unter-Achse | OWNER-ENTSCHEID | Z23570 | ENTSCHIEDEN | echte Sweep-Unter-Achse Planer erzeugt echte Compile-Haupt-Achse CEB |
| §70.9-C-3a-Zusatz-Auflage | OWNER-ENTSCHEID | Z23570 | ENTSCHIEDEN (ce 429240f9) | Gate-Sub-Feature-Flags implizieren AVX512F, Gate-Beitraege in Identitaet sichtbar |
| §71-RF-5-V36B-Retire-Merge | OWNER-ENTSCHEID | Z23573-23575 | ENTSCHIEDEN | alter Kanal RETIRED+GEMERGED, EIN Kanal je Achsen-Typ, keine CMake-Umwege |
| §72-Volles-GO-O8-Fenster-Vorab | OWNER-ENTSCHEID | Z23577-23579 | ERTEILT (26.07. ~22:15) | O-8-Fenster A2/A3/A8.2/A8.3/Lane F/Mess-Stempel-Segment, TEIL-V-Einplanungs-GO |
| §73.1-Ein-Hauptkanal-Doktrin | OWNER-ENTSCHEID | Z23583 | GESETZ (verschaerft §71) | EIN Hauptkanal, keine Skripte ausser CMake sparsam |
| §73.2-Q1-sse42-neon-gemergt | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN | eigene System-Meta-Meta-Hauptachse SIMD-Erweiterungs-Familie |
| §73.3-Q4-MSVC-Windows-Standard | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN | Win11+WinServer2022 Standard-Weg, Infra-Handout Runner id53/54/55 |
| §73.4-Q5-gpp15.3-Minimum-Standard | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN (korrigiert V-6iii) | KEIN g++16-Pin, mp11 stets Metaprog-Erweiterung |
| §73.5-Q6-Angebots-Zuschnitt-XML | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN | CMake-Options optionaler Fallback, XML gewinnt immer |
| §73.6-Q7-CLI-Subcommand | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN JETZT | clig.dev-Umbau in V-6 |
| §73.7-Volles-GO-sonstige-Punkte | OWNER-ENTSCHEID | Z23583 | ENTSCHIEDEN | M1-M3 Manager-Vorentscheide, V-0..V-7-Reihenfolge |
| §74-Pipelines-hart-durch-kein-interruptible | OWNER-ENTSCHEID | Z23585-23587 | GESETZ (26.07. ~23:00) | interruptible:true ABGELEHNT, auto_cancel disabled bleibt |
| §75-Abschluss-Aufraeumpass | OWNER-ENTSCHEID | Z23589-23591 | GEPLANT (eigenes Paket nach allen Aufgaben) | deprecated Header+toter Code entfernen, Doku-nie-loeschen bleibt fuer Doku |
| §75-Nicht-Kandidaten-Hybrid-Freihaltung | OWNER-ENTSCHEID | Z23592 | GESPERRT (HY-D2 02.08.) | axis_spline/break_even/measurement_curve_loader, IPruefDock::measure, AnatomyModuleHandle |
| §75-Zeiger-08.08-Kandidatenliste | AUFGABE | Z23594 | VERSCHOBEN (aktuelle Arbeitsgrundlage) | docs/plaene/20260808-KANDIDATENLISTE-75, Ketten (1)-(92) |
| §76-OP1-OP5-GO-Infra-Handout-Pause | OWNER-ENTSCHEID | Z23596-23598 | ENTSCHIEDEN (27.07. ~06:35) | OP-1 gegenstandslos, OP-5 CompoundSystemAxis im O-8, Pause nach Sicherung |
| §77-Volles-GO-D3-CI-Paket | OWNER-ENTSCHEID | Z23600-23602 | ENTSCHIEDEN (27.07. ~15:15) | OP-1 abgenommen, OP-7 ci-templates auf development, P8-Rest --emit-tier-ci Alt-Flag |
| NACHTRAG-02.08-A14-OS-U1-3-Unter-Achsen | FEATURE | Z23606 | GEBAUT (E-12) | operating_system: os_version/kernel/build, OperatingSystemAxisTag, FINAL-DREI-Wache |
| NACHTRAG-02.08-A14-K5-Stempel-Neutralitaet | AUFGABE | Z23607 | ENTSCHIEDEN/BEGRUENDET | kSystemAxisCodeVersions bleibt v1.0.0, kein SHA512-Bump |
| NACHTRAG-02.08-A14-OS-U2-Suffix | AUFGABE | Z23608 | ENTSCHIEDEN | build_version-Suffix bekommt KEIN operating_system-Segment |
| NACHTRAG-02.08-A14-OS-U2-Deklarations-Kanal | FEATURE | Z23609 | GEBAUT | <machine>-Attribute os_version/kernel/build/os_declaration_source in XSD |
| NACHTRAG-02.08-OP10-Teil-Supersede | REGRESSION | Z23610 | TEIL-SUPERSEDED (Owner-E3 02.08.) | Distro/Version sind jetzt Unter-Achsen os_version/kernel/build, nicht nur Stempel-Variablen |

| A13-M1-e-Versions-Fundament | FEATURE | Z23611 | GEBAUT (golden-neutral additiv) | Owner-E2 02.08., experimental-Suffix e in AlgoSemVer |
| A13-M1-K5-Null-Tripel-Sentinel | AUFGABE | Z23612 | ERFUELLT | v0e/v0.0.0e/0.0.0e falten auf Default-Sentinel, is_sentinel() |
| A13-M1-ce-Golden-Schutz | REGRESSION | Z23613 | BEHOBEN (CT-Wache gebaut) | ce-eigene Registry darf nie 'e' tragen, Beweis im echten Pfad |
| A13-M1-Stempel-POD-Bit0 | FEATURE | Z23614 | GEBAUT | 'e' reist als Bit0 reserved-Feld AnatomyStampEntryV1, kein Layout-Bruch |
| A13-M1-Q2-Namens-Toleranz | OWNER-ENTSCHEID | Z23615 | FESTGESCHRIEBEN | hierarchische Namen prt-art.memory.abc@1.0.0 |
| A13-M1-Q3-Kurzform-vNe | OWNER-ENTSCHEID | Z23616 | IMPLEMENTIERT (Owner-Bestaetigung erbeten) | 'e'-Suffix auch an Kurzform v1e |
| A15/FK-0-Hygiene-Wahrheit | REGRESSION | Z23617 | VOLLZOGEN (Owner-E6 02.08., ce 14f63636+62f0e32c) | RF-3-Guard war unregistriert, jetzt registriert+static-Fix, 323->324 |
| A15-Review-K8-Supersede-Fehlerklassen-Design | REGRESSION | Z23618 | BEWUSST ABGEWICHEN (additiv) | externer Bindungs-Header statt Concept-Requirement |
| NACHTRAG-Welle2c-TP1FK1-B1-Takeover-Sweep | AUFGABE | Z23622 | GEBAUT (f3475418) | SweepScope Pflicht-Parameter, kein Default, Reaper-Luecke fuer planer_block notiert |
| NACHTRAG-Welle2c-B2-Transport-Kontrakt-Wirft | REGRESSION | Z23623 | BEHOBEN (c7a6ec20, VERHALTENS-AENDERUNG) | push_tier_binary wirft ArtefaktPushFehler statt log+return |
| NACHTRAG-Welle2c-B3-Bestandslog-Parser-fail-closed | REGRESSION | Z23624 | BEHOBEN (86f97cd5) | parse_seconds optional<double>, epoch_from_utc_iso Zivildatum |
| NACHTRAG-Welle2c-B4-Takeover-Zaehlung | REGRESSION | Z23625 | BEHOBEN (f3475418) | uebernommen/ids aus Revalidierung am Store-Ergebnis |
| NACHTRAG-Welle2c-B5-Progress-Cursor | REGRESSION | Z23626 | BEHOBEN (a3db9ddb) | ProgressDelta::cursor fenster-relativ statt builds-Laufvariable |
| NACHTRAG-Welle2c-B10-Mess-Resume | REGRESSION | Z23627 | BEHOBEN (1a1fc224) | !b.ok()-Gate vor Resume-Kurzschluss, Bau-Fehler invalidiert Ablage |
| NACHTRAG-Welle2c-B10-Offene-Owner-Frage-F-B10 | OWNER-ENTSCHEID | Z23627 | OFFEN (spaeter Default b umgesetzt, s.u.) | result.csv.stale statt Ueberschreiben |
| NACHTRAG-Welle2c-B6-kSystemAxisCodeVersions-Assert | FEATURE | Z23628 | GEBAUT (ffdd37df) | static_assert je Eintrag, DOPPEL-ABSICHT bei Bump |
| NACHTRAG-Welle2c-B11-take_uint-Deckel | REGRESSION | Z23629 | BEHOBEN (85ee0805) | Ziffern-Deckel+Ueberlauf-Wache+Leading-Zero-Verbot |
| NACHTRAG-Welle2c-B12-Registry-Versions-Politik | FEATURE | Z23630 | GEBAUT (c7f3e005) | zentrale Politik algo_semver.hpp, an 4 Registry-Wachen verdrahtet |
| NACHTRAG-Welle2c-B7-SubAxisMembership | FEATURE | Z23631 | GEBAUT (1017d209) | Metaprog-Wurzel, FINAL-DREI-Wache auf OperatingSystemSubAxes::size |
| NACHTRAG-Welle2c-B13-FK1-Reader-Negativtest | REGRESSION | Z23632 | TEIL BEHOBEN (205a4bcd) | Listen-Pin/Netz-Deckung/Tragend getrennt; OFFEN Waisen-TU test_rf2 |
| NACHTRAG-Welle2c-Infra-Lehre-2-Phasen-Configure | REGRESSION | Z23633 | DOKUMENTIERT (bestaetigt Memory-Lehre) | frisches Bauverzeichnis 322 statt 326 Tests |
| NACHTRAG-Welle2b-A13-M2-Zeilen-Grammatik | OWNER-ENTSCHEID | Z23637 | BINDEND (Owner-Q1) | Klammer-Form line:=[segment], EBENE=Klammer-Tiefe |
| NACHTRAG-Welle2b-B2-Grammatik-durchgesetzt | REGRESSION | Z23637 | BEHOBEN (02.08. abends) | F1-F5 brechen jetzt hart statt stumm durchzuparsen |
| NACHTRAG-Welle2b-A13-M2-Zwei-Namensraeume | AUFGABE | Z23638 | UNVERAENDERT | Ebene in Klammern, hierarchische Namen in Punkten vor @ |
| NACHTRAG-Welle2b-Entry-POD-Bit-Belegung | FEATURE | Z23639 | UNVERAENDERT (sizeof bleibt 48) | Bit0=experimental, Bits1-2=HW-Flag, Bits3-5=Meta-Meta-Ebene |
| NACHTRAG-Welle2b-Realm-Zeilen-Ist-Stand | FEATURE | Z23640 | UNVERAENDERT | System 4 Eintraege, Mess mit load_framework-Anhang, Organ 18 |
| NACHTRAG-Welle2b-OP-3-Superseded-load_framework-Ende | REGRESSION | Z23641 | BEHOBEN (Owner-E2) | load_framework jetzt geklammerter Anhang am ENDE der Mess-Zeile |
| NACHTRAG-Welle2b-OP-11-Superseded-organ_meta_meta | REGRESSION | Z23642 | BEHOBEN (Owner-E2, B4-Nachbesserung) | AxisKind::organ_meta_meta neu, Kommentar-Fix 8 Stellen |
| NACHTRAG-Welle2b-Meta-Meta-Versions-Pflicht | OWNER-ENTSCHEID | Z23643 | ENTSCHIEDEN/B1-B3-Fix | SystemMetaMetaAxisConcept fordert axis_code_version |
| NACHTRAG-Welle2b-Fingerprint-Global-Shift | AUFGABE | Z23644 | VOLLZOGEN (gewollt) | alle kuenftigen Fingerprints verschieben sich vor Voll-Bau-4 |
| NACHTRAG-Welle2b-Zeichenvorrat-erweitert | FEATURE | Z23645 | UNVERAENDERT | Stempel-Strings auf =@;.+_[] + alnum erweitert |
| NACHTRAG-Welle2b-Review-Schliessung-B1-B4 | REGRESSION | Z23646 | GESCHLOSSEN (alle 4) | Waisen-TU+Grammatik+Naht-Liste+Kommentare |
| NACHTRAG-Welle2b-Basis-Aktualisierung-Merge | AUFGABE | Z23647 | VOLLZOGEN (Merge-Commit 7a49ce1c) | keine Textkonflikte, disjunkte Hunks |
| §68c-NACHTRAG-E04-P1-Marker-Familie-v2 | FEATURE | Z23648 | GELANDET (02.08.) | PLAN-TESTAT/BILANZ-TESTAT/PRUEF-BILANZ mit lane=/zelle=/fenster= |
| §68c-NACHTRAG-Zaehler-Quelle | AUFGABE | Z23649 | DOKUMENTIERT | Treiber einzige Zaehler-Quelle, fenster=globale Indizes |
| NACHTRAG-Neue-ENV-Vertraege-E04-P1 | FEATURE | Z23650 | GEBAUT | COMDARE_LANE, COMDARE_HEARTBEAT_EVERY (5 Zweige gepinnt) |
| §75-Aufraeum-Kandidatenliste-fortschreiben | AUFGABE | Z23651 | ENTSCHAERFT | built_skip nicht mehr leserlos, Kandidat(1) entschaerft |
| NACHTRAG-Diagnostik-Regel-E04-P1 | FEATURE | Z23652 | GEBAUT | pruef_only-Lauf MUSS gebaut_neu=0 zeigen |
| F-B10-Owner-Default-b-umgesetzt | REGRESSION | Z23653 | BEHOBEN (Branch w2b-B10stale, 1d5530c0+46d8b112) | result.csv->result.csv.stale statt Ueberschreiben |
| NACHTRAG-E19-I112-Schliessung | AUFGABE | Z23654 | GESCHLOSSEN (Welle 2b) | 5 Review-Befunde: Rename, node7-Korrektur, prod2-HW, riscv64-3-Wege |
| NACHTRAG-Welle3-OS-U3-Laufzeit-Erhebung | FEATURE | Z23658 | GEBAUT UND GRUEN | OperatingSystemProbe je Familie CT-spezialisiert, ctest 326->327 |
| NACHTRAG-Q8-Vollzugs-Vermerk | AUFGABE | Z23659 | VOLLZOGEN (Laufzeit-Lesart) | unabhaengig zweitgelesene Gegenproben |
| NACHTRAG-L6-Producer-Vermerk-Schliessung | REGRESSION | Z23660 | GESCHLOSSEN (OS-U3=erster Producer) | BetriebssystemFeatureFehlt hatte nie Erzeuger, jetzt has_native_probe() |

| OS-U3-Lande-Hinweise | AUFGABE | Z23661 | OFFEN (Reviewer-Hinweise fuer Folgewellen) | kOsProbeVersion in M3-Naht, Win/macOS-Pfade nie uebersetzt |
| NACHTRAG-Welle2d-Hergang-Abbruch | AUFGABE | Z23665 | DOKUMENTIERT (Abbruch am Spend-Limit) | Manager-Verdikt: verifiziert-fertigstellen statt verwerfen |
| NACHTRAG-Welle2d-Commits-CX-W1-W8 | REGRESSION | Z23666-23667 | BEHOBEN (alle CX-W1-W8 geschlossen) | Flag-Cluster+Transport-Cluster, 6 Commits |
| NACHTRAG-Welle2d-GA02-GA04-Bugs | REGRESSION | Z23667 | GESCHLOSSEN | GA-02/GA-03/GA-04 BLOCK-Befunde alle gefallen |
| NACHTRAG-Welle2d-Folgeschulden | REGRESSION | Z23667 | OFFEN (3 benannte Folgeschulden, kein Blocker) | stamp_bleibt ohne Testabdeckung, Alt-Stamp-Rest, kein flush-Check |
| NACHTRAG-Welle2d-Doppellauf-Gate-331 | AUFGABE | Z23668 | BEWIESEN | ctest 331/331 doppelt, Namens-Diff +2 |
| NACHTRAG-Welle2d-Reviews | AUFGABE | Z23669 | LANDEBEREIT (nach Nachbesserung) | Flag-Cluster landebereit, Transport nachgebessert |
| NACHTRAG-Welle2d-Landung-Pipeline-14334 | REGRESSION | Z23670 | BEHOBEN (Fix 1cb1efbf) | cppcheck-FP throwInEntryPoint, gitlab HTTP500 |
| NACHTRAG-Welle2d-CWD-Falle | REGRESSION | Z23671 | BEHOBEN (Beifang der Neugruendung) | 2 Doku-Commits versehentlich im ce-Repo gelandet |
| NACHTRAG-Review-GA02-GA04-Zuordnung | REGRESSION | Z23677 | GEFIXT (alle 3 BLOCK-Befunde) | GA-02==Z-01, GA-03==CX-W1, GA-04==CX-W2 |
| NACHTRAG-M3-Fenster-Z03-Z11 | REGRESSION | Z23678 | GEPLANT (M3-Fenster) | Z-03/Z-02/Z-09/GA-06/Z-07/GA-05/Z-10/Z-11 |
| NACHTRAG-OF-M3-1-Fingerprint-nicht-injektiv | OWNER-ENTSCHEID | Z23679 | OFFEN (Owner-Frage, Default A) | GA-01 BLOCK, Trenner-Haertung 5 Preimage-Glieder |
| NACHTRAG-Aufraeumpass-GA08-ASCII | AUFGABE | Z23680 | OFFEN (§75-Kandidat) | 1132 Quelldateien Nicht-ASCII-Altbestand |
| NACHTRAG-Lead-Doku-GA07-Z12 | AUFGABE | Z23681 | DOKUMENTIERT (keine Code-Aenderung) | Migrations-Groesse stale-korrigiert 194 statt 122 |
| NACHTRAG-Ist-Feststellungen-GA09-Z08 | AUFGABE | Z23682 | DOKUMENTIERT | Waisen-TU-Bestand 7, OS-U3 0 Nicht-Test-Konsumenten |
| NACHTRAG-Widerlegt-GA11-GA13 | REGRESSION | Z23683 | WIDERLEGT (Kanon bestaetigt, keine echten Bugs) | GA-11 variant, GA-12 set-e, GA-13 catch(...) |
| NACHTRAG-Q-M3-Gate-Owner-Definition | OWNER-ENTSCHEID | Z23687 | ENTSCHIEDEN (Owner ~21:2x 02.08.) | A13-M3-Gate: Codex-Review oder Fable-Ersatz-Lens |
| NACHTRAG-Codex-Ausfall-belegt | REGRESSION | Z23688 | OFFEN (2x hart belegt) | bwrap loopback Failed RTM_NEWADDR |
| NACHTRAG-Gate-Erfuellung-Option-b | AUFGABE | Z23689 | ERFUELLT | 3 Fable-xhigh-Adversarial-Laeufe+2 Cluster-Reviews |
| NACHTRAG-Verbleibende-Codex-Schuld | AUFGABE | Z23690 | OFFEN | Ersatz-Lens nicht echte Codex-Haelfte, Z-02/Z-03 dringend |
| NACHTRAG-Q-M3-Gate-erfuellt-Folge | OWNER-ENTSCHEID | Z23691 | ERFUELLT | A13-M3 startklar nach 2d-Landung gruen |
| NACHTRAG-A13-M3-Dossier-v4 | AUFGABE | Z23695 | BINDEND (v4, Audit-Verdikt GRUENDLICH) | M1+M1b+M2 fertig, M3 startklar |
| NACHTRAG-OF-M3-2-Overlay-Definition | OWNER-ENTSCHEID | Z23698 | OFFEN (Default A konditioniert) | S8-Overlay im M3-Fenster oder zweiter Neuanker |
| NACHTRAG-DV-3-v0-Kurzform-Sentinel | OWNER-ENTSCHEID | Z23699 | OFFEN (Default a unangetastet) | CX-W13/V4 "v0"-Sentinel im rohen .algos-Pfad |
| NACHTRAG-DV-1-merge-Stempel-Code-entfernt | OWNER-ENTSCHEID | Z23700 | ENTSCHIEDEN (Default a, Owner-E2) | merge_stamp_line SOFORT in C3 entfernt |

| §75-Kandidatenliste-Zeiger-19-22 | REGRESSION | Z23704 | GEMISCHT ((19)TEIL-ERLEDIGT,(20)ERLEDIGT,(21)OFFEN,(22)OFFEN wachsend) | Stand 08.08. |
| §75-Kandidat-19-stales-build | REGRESSION | Z23706 | TEIL-ERLEDIGT | build/ Codegen alt vor ORG-18/T17, Mess-CSV-Vorsicht |
| §75-Kandidat-20-Stamp-Write-flush | REGRESSION | Z23707 | BEHOBEN (ce 3a88eb88) | fehlender flush/good-Check, Fehlrichtung sicher |
| §75-Kandidat-21-Mess-Pfad-Testluecke | REGRESSION | Z23708 | OFFEN | stamp_bleibt-Zweig ungetestet |
| §75-Kandidat-22-ASCII-Sweep | REGRESSION | Z23709 | OFFEN (1132 Dateien) | Box-Drawing U+2500, kein Mojibake |
| NACHTRAG-Triage-Rest-Zuordnung | AUFGABE | Z23713 | ZUGEORDNET | Z-04/Z-05/Z-06/Z-08/Z-07/Z-11/Z-12 auf A14/A13-M3 |
| NACHTRAG-Widerlegt-Vermerke-final | REGRESSION | Z23714 | GESCHLOSSEN (widerlegt) | variant/set-e/catch-Verschlucken alle widerlegt |
| NACHTRAG-2d-Folgeschulden-FS1-FS4 | REGRESSION | Z23715 | OFFEN (4 Folgeschulden) | Mess-Pfad-Test, Fundstelle B, Resume-Stamp-flush, TOCTOU |
| §75-Kandidaten-Waisen-TU-7 | AUFGABE | Z23716 | OFFEN (Owner-Vorlage) | 7 Waisen-TUs, F-WAISEN-Sammel-Entscheid |
| NACHTRAG-OS-U4-Eingangsmarke | AUFGABE | Z23717 | PLANMAESSIG (GATE 2/3 abgearbeitet) | OS-U3 0 Nicht-Test-Konsumenten |
| NACHTRAG-Owner-Vorlagen-Konsolidiert-11 | OWNER-ENTSCHEID | Z23721 | DEFAULTS LAUFEN (Einspruch jederzeit) | OF-M3-1/OF-M3-2/DV-3/CX-W2-Wire/Fundstelle-B/V3-V6/#327/Z-02 |
| NACHTRAG-Dedupe-Vermerk | AUFGABE | Z23722 | ERLEDIGT (nicht erneut vorlegen) | V1/V2 vollzogen, Q-M3-GATE entschieden |
| NACHTRAG-OF-M3-1-vollzogen | OWNER-ENTSCHEID | Z23723 | VOLLZOGEN (Option A) | '\n'-Separator+Injektivitaets-Probe in M3-Welle |
| NACHTRAG-OF-M3-2-Fallback-B-aktiv | OWNER-ENTSCHEID | Z23723 | AKTIV (OFFEN fuer Ratifikation) | Overlay bleibt leer, GATE-9-Supersede-Vermerk noetig |
| NACHTRAG-D-04-F3-Testschuld | REGRESSION | Z23727 | OFFEN (reaktiviert) | Iterator-Test discard_fresh_with_pfad_prefix |
| NACHTRAG-D-10-46er-Differenz | AUFGABE | Z23728 | OFFEN | lokale ctest vs CI test:unit Differenz belegen |
| §75-Kandidaten-23-24 | REGRESSION | Z23729 | OFFEN | (void)-ohne-try Takeover, FreeRamFn/system_ram |
| NACHTRAG-D-15-Vortrag-nach-Abgabe | OWNER-ENTSCHEID | Z23730 | ENTSCHIEDEN | Vortrag erst nach Abgabe |
| NACHTRAG-D-11-Korrektur-Backup-Attribution | REGRESSION | Z23731 | BEHOBEN (Korrektur-Notiz) | "prod2 280" faelschlich Welle1, gehoert Welle 2a |
| NACHTRAG-Explore-Konsolidierung-11-Entscheide | OWNER-ENTSCHEID | Z23735-23736 | ENTSCHIEDEN (alle 11) | OF-M3-1/OF-M3-2/DV-3/CX-W2/V3/V4/E-23/V5/V6/#327 |
| NACHTRAG-DV-3-korrigiert-auf-Rueckbau | REGRESSION | Z23735 | KORRIGIERT (b) | v0 Rueckbau in C4 gebuendelt statt unangetastet |
| NACHTRAG-E23-f1-gegen-Vorlagen-Empfehlung | OWNER-ENTSCHEID | Z23735 | ENTSCHIEDEN GEGEN Empfehlung | Gitflow-Doktrin Default main bleibt |
| NACHTRAG-Ehrlichkeits-Vermerke | REGRESSION | Z23736 | BEHOBEN (Etikett-Korrektur) | anatomy_fingerprint.hpp:5 "D3 User-GO" war quellenlos |

| NACHTRAG-ce-dev-Pipeline-14338-hart-gruen | AUFGABE | Z23741 | GRUEN | main-FF gepinnt 1cb1efbf, 285/285 |
| NACHTRAG-thesis-prtart-Anhaenge-Welle-gruen | AUFGABE | Z23742 | GRUEN | Anhaenge-Realm-Welle 8 Stuecke, D-02 Kapitel-Stempel-Nachzug |
| NACHTRAG-Gitflow-Zwischenfall-Anhaenge-Merge | REGRESSION | Z23742 | BEHOBEN | Anhaenge-Merge zunaechst faelschlich auf thesis-main |
| NACHTRAG-super-14339-14344-rot-lint-format | REGRESSION | Z23743 | BEHOBEN (Fix 79dd5fe9) | Thesis-Wellen-Commit ohne cf22-Abnahme gepusht |
| A13-M3-Landung-Neuanker-Fenster | AUFGABE | Z23746-23751 | GELANDET | C1-C6 Commits, Pipeline 14353 hart gruen, main-FF b3372021 |
| NACHTRAG-GATE-9-Zitierfehler-korrigiert | REGRESSION | Z23752 | BEHOBEN | S8-Overlay-Quelle verkuerzt zitiert, Supersede-Vermerk entfaellt |
| NACHTRAG-TP1-Lager-Signal-Fingerprint-Shift | AUFGABE | Z23753 | VOLLZOGEN | TP1-Probe-Bestaende neu zu inventarisieren |
| NACHTRAG-Naechste-Schritte-nach-M3 | AUFGABE | Z23754 | GEPLANT (bindende Reihenfolge) | M4->OD-10-RT->A1-Lager-Rest->W10->E-24->A2-Eichung |
| A13-M4-Landung-A13-Komplett | AUFGABE | Z23758-23759 | GELANDET (A13 KOMPLETT M1-M4) | kCebContractCodegenMinor 0->1, Pipeline 14363 hart gruen |
| NACHTRAG-Design-Dossiers-A8-E24-A9-E07 | AUFGABE | Z23760 | GELANDET | E-07-Gate-Definition-Luecke geschlossen |
| NACHTRAG-OD-10-RT-Welle-laeuft | AUFGABE | Z23761 | LAEUFT | prozessfreie NUMA/page-Laufzeit-Erhebung |
| OD-10-RT-Landung | FEATURE | Z23765-23766 | GELANDET | numa_page_probe.hpp, Gate 331->332, main-FF 0b3a0b39 |
| NACHTRAG-Kompaktierungs-Ueberbrueckung | AUFGABE | Z23767 | DOKUMENTIERT | Lager-Rest-Welle lebt, kein Duplikat-Neustart |
| NACHTRAG-Naechste-Schritte-nach-OD10 | AUFGABE | Z23768 | GEPLANT (bindend) | Lager-Rest->W10->E-24-Fenster->A2-Eichung->Trigger |
| NACHTRAG-Bauplan-Dossiers-W10-E24 | AUFGABE | Z23772 | GELANDET (TRAGFAEHIG) | E-24-Fenster-Bauplan+W10-Bauplan, main-FF gepinnt |
| E-24-C0-Landung | FEATURE | Z23773 | GELANDET (M0-Vorstufe ABI-neutral) | OrganConcept, 27 Pruefpunkte, Gate 332->333 |
| NACHTRAG-C1-Fenster-Mitgift | AUFGABE | Z23774 | DOKUMENTIERT (widerlegt Bauplan-Satz) | statistics/value_type-Teilmenge widerlegt, C1+C2-Welle laeuft |

| NACHTRAG-L20-Hygiene | AUFGABE | Z23775 | VOLLZOGEN | Scratchpad-Creds-Sweep, 13/21 Worktrees entfernt, 7 Faelle §75 |
| NACHTRAG-Kompaktierungs-Serie-Komplett-Gruen | AUFGABE | Z23776 | GRUEN | alle main-FFs gepinnt beide Remotes |
| A1-Lager-Rest-Welle-Landung | AUFGABE | Z23780-23781 | GELANDET (5 Scheiben S0-S5) | Gate 333->338, main-FF f40dfb4b |
| NACHTRAG-S1-L9-B2-Kontraktpruefung | AUFGABE | Z23782 | KEIN Fixbedarf, Patch angewendet | main.cpp:1250ff werfender Kontrakt |
| NACHTRAG-L22-Strukt-R-Komplett-Quittung | AUFGABE | Z23783 | VERIFIZIERT | kSystemAxisOrder R-A..R-F Endzustand |
| NACHTRAG-Lager-Rest-Deklarierte-Luecken | REGRESSION | Z23784 | OFFEN (deklariert) | list-Verb ungebunden, G-E3-Host-Binder fehlt |
| §75-Kandidaten-30-31 | REGRESSION | Z23784 | OFFEN | test_s5_artifact_cache_bounded Tempdir, Presence-Asymmetrie |
| NACHTRAG-Folge-Freigaben-W10-A9S2-E24 | AUFGABE | Z23785 | GESTARTET | W10-Bau, A9-S2 frei, E-24 C1+C2 laeuft |
| E-24-C1-C2-Landung | FEATURE | Z23789-23790 | GELANDET (nach Lint-Nachbesserung) | Op-Familie, OrganGuard, main-FF c6559eaf, Gate 344 |
| NACHTRAG-Lint-Praezedenz-ODR-Fixtures | REGRESSION | Z23790 | BEHOBEN (Fix c6559eaf) | cppcheck ctuOneDefinitionRuleViolation |
| NACHTRAG-401-Unterbrechung-Resume | AUFGABE | Z23791 | UEBERBRUECKT | OAuth abgelaufen ~6h Pause, W10a-Cache erhalten |
| NACHTRAG-Offene-Bau-Fronten-3 | AUFGABE | Z23792 | LAUFEND (3 parallel) | W10b, C3-C5, A8-S1 |
| §75-Kandidaten-32 | REGRESSION | Z23792 | OFFEN | kAdapterCompositionSlotCount 13 vs live 11 |
| NACHTRAG-Pause-Owner-Order-Auslaufen | OWNER-ENTSCHEID | Z23794 | ENTSCHIEDEN | auslaufen lassen, abbruchsichere Pause |
| NACHTRAG-Wellen-Auslauf-W10-A8S1-C3 | AUFGABE | Z23796 | LANDEBEREIT (W10+A8-S1), GESTOPPT (C3 4/5) | rescue-Refs gesichert |
| NACHTRAG-A8-S1-Befunde-Folge-Scheiben | AUFGABE | Z23798 | DOKUMENTIERT | axis_stats[17] S3-Nachbarschaft, CSV-Semantik |
| W10-Landung-Byte-Ereignis | FEATURE | Z23800-23803 | GELANDET | Gate 346, main-FF 51c012c5, COMDARE_SYSTEM_CELL_VALUES |
| NACHTRAG-Skip-nur-gleiche-OS-Familie-beendet | REGRESSION | Z23803 | BEHOBEN (Uebergangsregel-Ende) | in C5 dokumentiert |
| A8-S1-Landung-T17-Fix | REGRESSION | Z23804 | BEHOBEN | T17-Messwert-Verlust behoben, main-FF de7688b9, Gate 347 |
| NACHTRAG-E24-b-Startklar-3-erfuellt | AUFGABE | Z23804 | ERFUELLT | A8-S1 gelandet vor b-Teil-Start |
| NACHTRAG-C3-C5-Resumed | AUFGABE | Z23805 | RESUMED | WIP 0bac9fbe Cross-Genus vollendet |
| Owner-Kern-observe_axes-Deep-Research | OWNER-ENTSCHEID | Z23807-23809 | ENTSCHIEDEN (04.08. verbatim) | einige Achsen brauchen observe_axes unter Deep-Research |

| Owner-Kern-04.08-Nachtrag2-Substitutionsprinzip | OWNER-ENTSCHEID | Z23811 | ENTSCHIEDEN (verbatim) | Achsen ersetzen aequivalente Code-Stellen global, Programm-Messbaeume |
| Owner-Kern-04.08-Nachtrag3-Vier-Praezisierungen | OWNER-ENTSCHEID | Z23812 | ENTSCHIEDEN (verbatim) | Qualitaet(Algorithmus|Achse), 'ohne'-Optimierung valide, Rekursions-Invariante |
| Auslegung-Nachtrag3-Gegenlese-Massstaebe | AUFGABE | Z23813 | DOKUMENTIERT | Mess-Objekt=Algorithmus, Container-Gattung, Rekursions-Invariante |
| E-24-a-Teil-C3-C4-C5-Landung | FEATURE | Z23815-23819 | GELANDET (Gate 347->357) | Cross-Genus, Konformitaets-Orakel, FK-7/FK-8, main-FF 44bcda99 |
| NACHTRAG-Befunde-Folge-Fenster-C6-Vorlage | REGRESSION | Z23819 | OFFEN (C6-VORLAGE) | SA-Gattung nicht ABI-faehig fuer Cross-Genus |
| §75-Kandidaten-33-34 | REGRESSION | Z23819 | OFFEN | SetDock/SetPruefDock-Doppel-Schicht, Nummerierungs-Drift |
| NACHTRAG-E24-b-Teil-Startklar-Wartend | AUFGABE | Z23820 | WARTET | C6-Baustart wartet auf Qualitaets-Parameter-Katalog |
| Qualitaets-Parameter-Katalog-fertig | FEATURE | Z23824 | FERTIG TRAGFAEHIG (REV2) | 855 Zeilen, 27 Themen |
| NACHTRAG-SA-Wire-Befund | AUFGABE | Z23825 | ENTLASTET (8 Felder reichen) | keine V3-Schema-Erweiterung noetig |
| NACHTRAG-C6-Blockierende-Entscheide-E1-E5-E13 | OWNER-ENTSCHEID | Z23826 | GEFAELLT (Manager) | E1 Milli-Fixpunkt, E5 Huellen-Vor-C6, E13 per-Slot-Timing |
| NACHTRAG-Triage-uebrige-Entscheide-E2-E12 | OWNER-ENTSCHEID | Z23827 | TRIAGIERT | A8-S3/Phase-6/Nach-Abgabe verteilt |
| NACHTRAG-C6-Baustart-Gate-offen | AUFGABE | Z23828 | GEOEFFNET | C6-V ABI-neutral sofort, dann b-Teil seriell |
| Owner-Kern-04.08-Gattungs-Definition-Huellen | OWNER-ENTSCHEID | Z23832 | ENTSCHIEDEN (verbatim) | SA=map-Gleichnis 2 Parameter, Container=vector-Gleichnis 1 |
| Auslegung-Gattungs-Definition | AUFGABE | Z23833 | DOKUMENTIERT (Analyse-Welle gestartet) | Diskrepanz AnatomyGattung vs Genus vor C7 |
| Owner-Kern-04.08-Nachtrag4-Zwei-Ebenen-Modell-FINAL | OWNER-ENTSCHEID | Z23834 | ENTSCHIEDEN FINAL (supersedet mittags-3) | Genus erbt von Gattung, Map/Container/Graph |
| Auslegung-Nachtrag4-Final | AUFGABE | Z23835 | DOKUMENTIERT | IST-Fehler: AnatomyGattung::SearchAlgorithm muss 'Map' heissen |
| Owner-Kern-04.08-Nachtrag5-Abstract-Factory-Klammer | OWNER-ENTSCHEID | Z23836 | ENTSCHIEDEN (verbatim) | Gattung/Genus gestaffelte Interfaces, Abstract Factory CT |
| Gattungs-Diskrepanz-Dossier-fertig | FEATURE | Z23840 | FERTIG TRAGFAEHIG | Diskrepanz-Kern exakt, ZEITKRITISCH source-only vor C7 |
| C7-Auflagen-C7-1-bis-C7-8 | AUFGABE | Z23841 | BINDEND (in b-Teil-Auftrag) | Umbenennung SearchAlgorithm->Map, Kern erhoben |
| NACHTRAG-Manager-Entscheide-offene-Punkte | OWNER-ENTSCHEID | Z23842 | ENTSCHIEDEN | FK-8-CSV-Etiketten belassen, Map-Kopf-Framework ratifiziert |

| C6-V-Landung | FEATURE | Z23846-23847 | GELANDET (Gate 357->361) | 5 Statistics-PODs, main-FF 19adba05 |
| NACHTRAG-C6-V-Katalog-Korrektur | REGRESSION | Z23846 | BEHOBEN (WIDERLEGT) | Katalog-Zeile C-A "nur 1 Growth-Policy" widerlegt |
| NACHTRAG-b-Teil-C6-C11-gestartet | AUFGABE | Z23848 | GESTARTET | Opus-5 seriell+3 Fable-Gates, Startklar-9 Job-Sperre danach |
| E-24-b-Teil-Landung-DER-MAJOR | FEATURE | Z23850-23853 | GELANDET (Gate 361->377, ABI-Major 7->8) | C6-C11, main-FF 19f27223 |
| NACHTRAG-Job-Sperre-Aktiv | OWNER-ENTSCHEID | Z23854 | AKTIV (Startklar-9) | kein Trigger/Lager-Voll-Lauf bis Anker-Vollzug |
| NACHTRAG-Manager-Entscheide-Fenster-Befunde | AUFGABE | Z23855 | ENTSCHIEDEN | print_version_facade deklarierte Luecke, §75(35)-(38) |
| Struktur-Audit-SF-1-Schnitt-Fehler | REGRESSION | Z23857-23861 | OFFEN (Owner-Fenster, niemals still heilen) | anatomy->builder-Aufwaertskante container_framework.hpp:37 |
| Struktur-Audit-Struktur-OK | AUFGABE | Z23861 | VERIFIZIERT | Zwei-Ebenen-Modell vollzogen, Include-Kanten-Karte |
| §75-Kandidaten-39-53 | REGRESSION | Z23862 | OFFEN (15 Kandidaten) | abi->builder-Altkante, topics->anatomy, organ_location.hpp |
| NACHTRAG-Offene-Entscheide-Struktur-Audit | OWNER-ENTSCHEID | Z23863 | OFFEN (kein Blocker) | SF-1-Heilungs-Fenster, Posten-43-Fenster, F27-Kanonik |
| A8-S3-Landung | FEATURE | Z23865-23868 | GELANDET (Gate 377->380) | T17-Observer-Fix, SA-18-Achsen, CSV-Klasse-C, main-FF 65a61fcf |
| NACHTRAG-A8-S3-Beleg-Schablonen-Regel | REGRESSION | Z23868 | BEHOBEN (neue Regel) | TABU-Muster golden_fullpilot_320* statt Verzeichnis-Pauschale |
| NACHTRAG-A8-S3-Offene-Punkte | AUFGABE | Z23869 | OFFEN | Katalog P2-P8 CSV-Schema, Peak-Quelle, fill_observer_v3-Umzug |
| NACHTRAG-A8-S4-S5-gestartet | AUFGABE | Z23870 | GESTARTET | Konstitutiv-Matrix, S5-Planung 70er-Bestand |
| A8-S5-Planung-Familien-Schnitt | AUFGABE | Z23874 | FERTIG (objekt-hart) | 70 Dateien, 49 echte Code-Treffer, 5 Familien |
| NACHTRAG-Deckel-Live-Planungsverifikation | AUFGABE | Z23875 | DOKUMENTIERT | Platte 12G frei, RAM ~20G, 3 Worktrees-Deckel |
| NACHTRAG-Manager-Entscheide-S5 | OWNER-ENTSCHEID | Z23876 | GEFAELLT (5 Entscheide) | static_assert-Wache, Kommentar-only mitziehen |
| NACHTRAG-Pilot-04-execution-gestartet | AUFGABE | Z23877 | GESTARTET (wf_27bbb037) | Scrub 04_execution, Gate-Muster |

| CI-Cache-Regression-quantifiziert | REGRESSION | Z23879-23884 | BEHOBEN (ce a8c2da91) | restore_cache 4s->150s (37x), Klassen-Keys+MAXSIZE 3G |
| NACHTRAG-Infra-Handout-Runner-Cache | AUFGABE | Z23885 | GESCHRIEBEN | Cluster-Handout Platten-Bereinigung prod1 |
| NACHTRAG-Owner-GO-prod1-prod2-Cleanup | OWNER-ENTSCHEID | Z23886-23887 | AUSGEFUEHRT | prod1 -8G, prod2 kein Problem (Spiegel-Annahme widerlegt) |
| Owner-Kern-Generalisierte-Schnitt-Regel | OWNER-ENTSCHEID | Z23891 | ENTSCHIEDEN (verbatim) | ALLE Achsen-Eigenschaften nur ueber Achsen, Genus-Ausnahme |
| NACHTRAG-Konsequenz-Plan-Schnitt-Regel | AUFGABE | Z23892-23893 | GEPLANT | Kartierungs-Workflow je Achsen-Thema |
| S5-04-Pilot-Landung | FEATURE | Z23897 | GELANDET (main-FF a801a7e3) | Pfad-Trajektorie INLINE, Gate-Muster steht |
| A8-S4-Landung | FEATURE | Z23898 | GELANDET (Gate 384, main-FF 28261b5a) | Konstitutiv-Matrix 5x18, Release-Pfad-Neutralitaet |
| NACHTRAG-Laufend-S5-03-01d-Kartierung | AUFGABE | Z23899 | LAUFEND | S5-03, S5-01d, Kartierung Schnitt-Regel |
| Kartierung-Schnitt-Regel-fertig | AUFGABE | Z23903 | FERTIG TRAGFAEHIG | 69 Befunde: 5 mechanisch, 4-5 semantisch, 60 legitim |
| P-CACHELINE-LITERAL-Vor-Anker-Pflicht | REGRESSION | Z23904 | OFFEN (einzige Vor-Anker-Pflicht) | LayoutAwareChunkedStore hartkodiert kLineBytes=64 |
| §75-Kandidaten-55-63 | REGRESSION | Z23905 | OFFEN (9 Kandidaten) | xmmintrin-Include, HOT-Patricia-Duplikat |
| NACHTRAG-Entlastungs-Befunde | AUFGABE | Z23906 | ENTLASTET | T7-Prefetch korrekt, cacheline_sw_hint legitim |
| NACHTRAG-Abbruchsichere-Pause-04.08 | OWNER-ENTSCHEID | Z23908-23911 | ENTSCHIEDEN/VOLLZOGEN | 2 S5-Wellen landebereit ungelandet |
| §75-Kandidaten-64-66 | REGRESSION | Z23912 | OFFEN | nullptr-OOM-Durchreichung, iterable_aspect-Kommentar |
| NACHTRAG-Wiederaufnahme-S5-03-01d-Landung | FEATURE | Z23915-23918 | GELANDET (Gate 388) | main-FF 1c03925f + 1246ccd8 |
| NACHTRAG-Substanz-Vermerk-Zweit-Review | AUFGABE | Z23919 | DOKUMENTIERT | Registry-Organe binden ueber benannten Alias |
| §75-Kandidaten-67-70 | REGRESSION | Z23920 | OFFEN | HashLookup-Fibonacci-Hash, T6-Einsammel-Frage, Tempdir-Kollision |

| Owner-Kern-T6-Posten68-Option-B-strikt | OWNER-ENTSCHEID | Z23924-23925 | ENTSCHIEDEN (verbatim) | multiple Allokatoren hinter Achsen-Interface, metaprogrammiert |
| NACHTRAG-Regressions-Definition-Organ-ohne-Achse | REGRESSION | Z23925 | NEUE WACHE-KLASSE | Organ-Algorithmus ohne Achsen-Zuordnung = Regression |
| Posten-60-SortedArrayKeySet-Regression-hochgestuft | REGRESSION | Z23925 | OFFEN (benannt, Default nach Abgabe) | anatomy/set_default_organ.hpp ohne Achsen-Zuordnung |
| Haertung-64-69-70-Landung | REGRESSION | Z23930 | BEHOBEN (Gate 388->389, main-FF fb623528) | StdAllocatorAdapter->bad_alloc, Test-Temp-Wurzel suffixiert |
| P-CACHELINE-Landung | REGRESSION | Z23931 | BEHOBEN (Gate 389->390, main-FF a6487f9e) | LayoutAwareChunkedStore aus cacheline-Unterachse |
| §75-Kandidaten-71-73 | REGRESSION | Z23932 | OFFEN | PmrResourceAdapter nullptr-Durchreichung, Ueberlauf-Wache |
| KF-6-Praezisierung-Posten62 | AUFGABE | Z23933 | PRAEZISIERT (Pflicht-Wissen) | NTTP-Belegung, kLbufBytes OOB-Warnung scharf |
| S5-02a-Landung-Herz-Befund | REGRESSION | Z23937 | BEHOBEN (Gate 390->392) | Chunk-Index ueber echten Kompositions-Allokator |
| S5-01a-Landung | FEATURE | Z23938 | GELANDET (Gate 392->394) | 9 Pool-/Layout-Stores geflippt, std::allocator 34->0 |
| NACHTRAG-Fallen-Lehre-Marker-Grep | REGRESSION | Z23939 | BEHOBEN (Merge-Marker vor Push) | oeffnender <<<<<<< HEAD-Marker blieb stehen |
| §75-Kandidaten-74-76 | REGRESSION | Z23940 | OFFEN | OOM-Roh-Route memset ungeprueft, 01a-Gate-Schwaechen |
| NACHTRAG-01b-01c-Design-laufend | AUFGABE | Z23941 | LAUFEND | 01b, 01c-Design-Vorlauf 3 Fable-Designs |
| 01c-Design-Entscheid-D1-Wrapper-Fassade | OWNER-ENTSCHEID | Z23945 | ENTSCHIEDEN (D1 gewinnt) | Zwei-Ebenen-Schnitt, Registry-Kante byte-stabil geloest |
| NACHTRAG-Vor-Anker-Scope-01c | AUFGABE | Z23946 | GEPLANT | Phase A+B+Gates, T6-Einsammlung Mess-Schnitt-Fenster |
| NACHTRAG-Owner-Punkte-Judge | OWNER-ENTSCHEID | Z23947 | NUR-KENNTNIS | kein XML-Fenster noetig, K2-K16 Leaf-Klassen |
| NACHTRAG-02b-gestartet | AUFGABE | Z23948 | GESTARTET | filter/SuRF Papertreue |
| 3-OAuth401-01b-02b-ueberbrueckt | AUFGABE | Z23952 | UEBERBRUECKT | resumeFromRunId, 01b fand echte Luecke |
| S5-02b-Landung | FEATURE | Z23953 | GELANDET (Gate 396) | composable Filter-Organe, Membership bit-identisch 272961 |
| §75-Kandidaten-77-78 | REGRESSION | Z23953 | OFFEN | kReal16-Suffix-Kollaps, XorFilter 30/256 False Negatives |
| S5-01b-Landung-Scrub-komplett | FEATURE | Z23954 | GELANDET (Gate 398, Scrub bis auf 01c komplett) | AxisBoundBuffer, 6 Walk-Stacks |
| §75-Kandidaten-79-80 | REGRESSION | Z23955 | OFFEN | mutable walk_stack_, Mimalloc-jmp-Befund unverifiziert |
| NACHTRAG-01c-Pilot-gestartet | AUFGABE | Z23956 | GESTARTET | Mimalloc-Nachpruefung, linear_scan Core/Fassade |
| NACHTRAG-CI-ROT-14571-Hotfix-Boost | REGRESSION | Z23957 | BEHOBEN (Hotfix cda964e0, Pipeline 14572) | boost::mp11 System-Header-Fallback, CI fing es |
| Owner-Kern-XML-Direktive-gelockert | OWNER-ENTSCHEID | Z23961 | ENTSCHIEDEN (verbatim) | XML-Aenderungen kuenftig als Rueckfrage statt Design-Verrenkung |

| NACHTRAG-Prozess-Regel-Rueckfrage-Gate | OWNER-ENTSCHEID | Z23962 | ENTSCHIEDEN (bindend) | Registry-XML-Vereinfachung -> Rueckfrage statt Sperre |
| NACHTRAG-Manager-Entscheid-01c-D1-bleibt | OWNER-ENTSCHEID | Z23963 | ENTSCHIEDEN | D1 Wrapper-Fassade bleibt fuer Scheiben 2-4, Posten(81) nach Abgabe |
| 01c-1-Pilot-Landung-h81-Klassen-Fix | REGRESSION | Z23965-23969 | BEHOBEN (Gate 400, main-FF 81198700) | CRTP-Weiterleiter-Rekursion 25/26 Strategien |
| NACHTRAG-Zwei-CI-Rot-Hotfixes | REGRESSION | Z23970 | BEHOBEN (binnen Minuten) | Boost-Link-Hotfix, cf22-Nachformat, neue Lead-Gate-Pflicht |
| NACHTRAG-01c-2-gestartet | AUFGABE | Z23971 | GESTARTET | interpolation+eytzinger+k_ary |
| 01c-2-Landung-per-K-Kante-unbewacht | REGRESSION | Z23975-23976 | BEHOBEN (Gate 400, main-FF 40e8bf27) | K2-K16-Aliase trugen nie ORGAN_LOCATION |
| NACHTRAG-XML-Rueckfrage-Kandidaten-K1-K2 | OWNER-ENTSCHEID | Z23976 | OFFEN (Entscheid nach Abgabe) | per-K-Familie, Fassaden-Ebene |
| NACHTRAG-01c-3-gestartet | AUFGABE | Z23977 | GESTARTET | 14 verbleibende OFF-Organe |
| NACHTRAG-Pause-05.08-01c3-landebereit | OWNER-ENTSCHEID | Z23979-23982 | ENTSCHIEDEN/VOLLZOGEN | 01c-3 fertig landebereit ungelandet, Pin 22/22 |
| NACHTRAG-Review-Befund-B3-Methodik-Falle | REGRESSION | Z23983 | GEFUNDEN (nicht blockierend) | ninja -t commands zeigt zuerst Modul-Scan, falsch-gruen moeglich |
| NACHTRAG-Posten-82-original_surf-if-constexpr | REGRESSION | Z23983 | GEMELDET (nicht still geheilt) | fehlendes if constexpr um insert-Rumpf |
| NACHTRAG-XML-Rueckfrage-Kandidaten-K3-K4 | OWNER-ENTSCHEID | Z23984 | OFFEN (nach Abgabe buendeln) | ORGAN_LOCATION-Duplikation, enabled=false-Sichtbarkeit |
| NACHTRAG-Owner-Ruege-Arbeitsweise | REGRESSION | Z23989 | SELBST-AUDIT (A1/A2-Verstoss eingestanden) | Lead-Selbst-Edits nur mechanisch, Truth-Check nachgeholt |
| 01c-3-Landung | FEATURE | Z23990 | GELANDET (Gate 400, main-FF 98eea2e7) | inkl. Lead-surf-Heilung |
| S5-Truth-Check-Abschluss-mit-Auflagen | REGRESSION | Z23991 | ABSCHLUSS-MIT-AUFLAGEN (2 Widerlegungen) | Vollstaendigkeits-Luecke Familie 05 (queuing 2/4) |
| NACHTRAG-Q-Welle-gestartet-Manager-Entscheid | OWNER-ENTSCHEID | Z23992 | ENTSCHIEDEN (Auflage 2) | SCRUB statt Scope-Deklaration, Q-Welle vor Anker |
| NACHTRAG-Neue-Posten-Truth-Check-83-86 | REGRESSION | Z23993 | OFFEN | Familien-Gate-Kopplung, Observer-Copy-Semantik |
| NACHTRAG-Q-Welle-Ablauf-Falle-hart-abgeschnitten | REGRESSION | Z23997 | BEHOBEN (Resume-Weg) | Bau-Agent ohne Journal-Result |
| S5-05q-Q-Welle-Landung | FEATURE | Z23998-24004 | GELANDET (Gate 402, main-FF b09ebb8a) | Familie 05 jetzt 4/4, Truth-Check-Auflagen erfuellt |
| NACHTRAG-Q2-Befund-0-Commits-korrekt | AUFGABE | Z24000 | VERIFIZIERT | axis_q2_queuing haelt keinen dynamischen Zustand |
| NACHTRAG-Naechste-Schritte-Phase-B-Anker | AUFGABE | Z24004 | GEPLANT | Phase B->EIN ANKER->Phasen 3-5, Trigger Do 07.08. |

| UML-Klassenatlas-fertig-persistiert | AUFGABE | Z24008 | FERTIG+PERSISTIERT | docs/architektur/05b, 1918 Typ-Definitionen |
| NACHTRAG-Erhebungsqualitaet-Nachzug | REGRESSION | Z24009 | BEHOBEN (Volllektuere-Nachzug) | Regex-Abkuerzung in Shard lookup-1 |
| Atlas-Rev2-Owner-Review | REGRESSION | Z24012-24017 | BEHOBEN (Owner-Kritik bestaetigt) | SearchAlgoBase/Map falsch, 18 statt 19 Achsen |
| NACHTRAG-CEB-nicht-benannte-Klasse | AUFGABE | Z24016 | NUR-KENNTNIS | CacheEngineBuilder existiert nicht als C++-Klasse |
| Owner-Kern-Planer-eigene-Binary-CEB-Begriff | OWNER-ENTSCHEID | Z24021 | ENTSCHIEDEN (verbatim, 2 neue Kerne) | Planer zwingend eigene Binary, CEB==CacheEngineBuilder |
| Planer-CEB-Vertragsketten-Audit-Verdikte | REGRESSION | Z24022 | GEMISCHT (1 Regression, 3 Teil-Konform) | Glied1 REGRESSION, Glied2/3 TEIL-KONFORM |
| Regressions-Register-6-R-G1-bis-R-G5 | REGRESSION | Z24023 | OFFEN (6 Regressionen) | Planer-Binary-Split fehlt, keine harte CEB-Kompilation |
| NACHTRAG-7-Owner-Rueckfragen-Kette | OWNER-ENTSCHEID | Z24024 | OFFEN (registriert) | Glied-1-Umbau, R2-Modul-Schnitt, R1-.so-Entscheid |
| Atlas-Kette-Nachzug-Rev3 | AUFGABE | Z24025 | VOLLZOGEN (super 138ffa78) | SOLL/IST-ehrlich, Regressionen markiert |
| Owner-Antworten-7-Kette-Rueckfragen-F1-F7 | OWNER-ENTSCHEID | Z24029-24030 | ENTSCHIEDEN (verbatim, RUEGE) | F1 hartes GO Planer-Split vor Abgabe, F5 Pruefstand-Doktrin neu |
| NACHTRAG-Ruege-Vollzug-Ultracode-Einlese | AUFGABE | Z24031 | GESTARTET | 6 Themen-Lenses ueber Plan-Korpus |
| Phase-B-Landung-letzte-Bau-Scheibe | FEATURE | Z24035-24040 | GELANDET (Gate 403, main-FF 24e07219) | Traversal-Mapping-Symmetrie, EffectiveSearchAlgo |
| NACHTRAG-Neue-Posten-87-89 | REGRESSION | Z24038 | OFFEN | organ_hull_-Kompositionen Level-2, Mess-CSV-Einpreisung |
| Owner-Atlas-Review-Runde-3 | OWNER-ENTSCHEID | Z24044-24046 | ENTSCHIEDEN (verbatim) | Heuristik=optionale eigene Binary, Vertrags-Namen fehlen |
| NACHTRAG-Einlese-Synthese-fertig-F2-F3-F4 | AUFGABE | Z24050-24054 | BEANTWORTET | F2 zwei Module keine Vererbung, F3 Textemission Abgabe |
| NACHTRAG-Roadmap-nach-Phase-B | AUFGABE | Z24055 | GEPLANT (ehrlich) | ANKER->W1+W2->W5-Kern->Trigger Do |

| NACHTRAG-7-Rueckfragen-mit-Empfehlungen | OWNER-ENTSCHEID | Z24056 | OFFEN (spaeter beantwortet mittag-6) | W2-Interim, F3-Bestaetigung, W3-Schnitt |
| Owner-Entscheide-alle-7-Rueckfragen-mittag6 | OWNER-ENTSCHEID | Z24060-24061 | ENTSCHIEDEN (verbatim) | R1 -D-Define, R6 Planer taktet selbst |
| NACHTRAG-Neue-Dauer-Regel-sauberster-Weg-TODO | OWNER-ENTSCHEID | Z24062 | ENTSCHIEDEN | Interims immer als TODO, nach Abgabe abarbeiten |
| F6-Explore-fertig-Freigabe-Hierarchie | AUFGABE | Z24067-24071 | FERTIG (aus Korpus erhoben) | System gibt frei, Organ setzt durch, Bestandslog |
| Owner-Korrektur-mittag9-Stufen-Symmetrie | OWNER-ENTSCHEID | Z24076-24079 | ENTSCHIEDEN (verbatim, korrigiert mittag-8) | Mess=dreistufig, System/Organ=zweistufig |
| Owner-Praezisierung2-mittag10-System-dehnbar | OWNER-ENTSCHEID | Z24083-24085 | ENTSCHIEDEN (verbatim) | System dehnbar wie Mess, Hybrid=Factory-Facade-Adapter |
| NACHTRAG-Posten-90-Hybrid-Design-Doc-Ergaenzung | AUFGABE | Z24085 | OFFEN | GoF-Einordnung+CT-Weitergabe-Pflicht |
| Owner-Abnahme-Stufen-Doktrin-mittag11 | OWNER-ENTSCHEID | Z24089-24090 | ABGENOMMEN (verbatim, Konsolidierungs-GO) | kanonische Form owner-abgenommen |
| Sonnet5-Audit-fertig-kein-Objektschaden | AUFGABE | Z24094-24096 | VERIFIZIERT (kein Objektschaden) | 8/8 Prueffelder bestanden |
| NACHTRAG-Sonnet5-Prozess-Befunde-2-mittel | REGRESSION | Z24095 | BEHOBEN (Doktrin nachgeschaerft) | Blind-Resume vor Ist-Check, Fremd-Akteur uebersehen |
| NACHTRAG-Kurs-Korrekturen-Wiederanlauf-Doktrin | AUFGABE | Z24096 | VOLLZOGEN | neues Memory verankert |
| Owner-Auftrag-Sonnet5-Gruendlichkeits-Audit | OWNER-ENTSCHEID | Z24098-24100 | BEAUFTRAGT (verbatim) | pruefe Sonnet-5-Uebernahme |

| NACHTRAG-Session-Luecken-Reconcile-Wahrer-Stand | AUFGABE | Z24104-24107 | REKONSTRUIERT | ce Gate 405, super 8baa7082, Atlas REV5 |
| Codex-Dual-Review-Pflicht-etabliert | OWNER-ENTSCHEID | Z24108 | ENTSCHIEDEN (nachtraeglich) | Codex+Fable Pflicht ab sofort, Auflage 11 war stale |
| A2-Eichung-Codex-Nachreview-6-Befunde | REGRESSION | Z24109/24123/24129-24131 | GEMISCHT (C1/C4/C5/C6=REAL) | Preimage ohne cxx/opt/build_type |
| W1-W2-Codex-Nachreview-3-Befunde | REGRESSION | Z24110/24135-24136 | REAL (B1/B2 HOCH) | sticky CMake-Cache-Var, Schluessel-Welt-Split |
| Owner-Gate-O2-Preimage-Neuanker | OWNER-ENTSCHEID | Z24111/24125-24126 | OFFEN (echtes Owner-Gate) | Option A jetzt vs Option B Interim+Nach-Abgabe |
| W3-W5-Kern-gebaut-nicht-gelandet | AUFGABE | Z24112 | GEBAUT NICHT GELANDET | Branch w5-w3-kern, Codex-Nachreview noch aus |
| NACHTRAG-Korrigierte-Reststrecke-P2 | AUFGABE | Z24113 | GEPLANT | P2-Kette 3 Teile, P3 Phasen 3-5 |
| Codex-W5-W3-9-Befunde-nicht-landebereit | REGRESSION | Z24117 | OFFEN (Nachbesserungswelle) | H1 Fremd-Fenster-Ergebnisse falsch, H2 Bilanz-Fehler |
| w2fix-Strecke-landebereit | REGRESSION | Z24118 | BEHOBEN (LANDEBEREIT) | install(PROGRAMS)-Naht, MANUAL_RUN-Partial-Build |
| NACHTRAG-Lehre-Codex-findet-Regressionsklassen | AUFGABE | Z24119 | BESTAETIGT | Dual-Review bleibt Pflicht, Codex-Inline-Diff Standard |
| Owner-Nachfrage-Dual-Review-verbatim | OWNER-ENTSCHEID | Z24140-24142 | ENTSCHIEDEN (verbatim) | Codex lebt, Dual-Review-Pflicht ab sofort (A3) |

| W1-Planer-Binary-Split-Landung | FEATURE | Z24144-24150 | GELANDET (Gate 405, F1-hart erfuellt) | comdare-experiment-planner, R-G1+R-G3-Interim geschlossen |
| W2-Minimalhaerte-Landung | FEATURE | Z24147 | GELANDET (Gate 404->405) | -D COMDARE_MEASUREMENT_COMBO_CT, fingerprint-neutral |
| NACHTRAG-Posten-92-R-G2-Registry-Kanon-Divergenz | REGRESSION | Z24148 | OFFEN (mitgenommen, benannt) | validate=2er vs plan=3er |
| NACHTRAG-CI-Rot-14673-Geheilt | REGRESSION | Z24149 | BEHOBEN (Hotfix 60c7c56a) | cppcheck-unknownMacro, neue Fallen-Kanon-Regel |
| Owner-Dauer-Regel-Atlas-Gegenpruefung | OWNER-ENTSCHEID | Z24152-24155 | ENTSCHIEDEN (verbatim) | jede Atlas-Aussage vorlaeufig bis Korpus-gedeckt |
| Owner-Praezisierung-Rueckschreibe-Format-Strategy | OWNER-ENTSCHEID | Z24157-24160 | ENTSCHIEDEN (verbatim) | CSV XOR xlsx, xlsx=Default, Strategy nicht CoR |
| Anker-Vollzogen-Gate5-Eichung | FEATURE | Z24162-24166 | VOLLZOGEN (Gate 404, main-FF 18fbb950) | dll_is_current EIN Vergleich fail-closed |
| NACHTRAG-Job-Sperre-beendet | OWNER-ENTSCHEID | Z24166 | BEENDET | Dauer-Auflage Fingerprint-Neutralitaet ab jetzt |
| Owner-Atlas-Review-Runde5-Zukunftsphasen | OWNER-ENTSCHEID | Z24168-24173 | ENTSCHIEDEN (verbatim) | Rueckschreibe-Kette+4-Modi-Zukunftsphasen fehlen als SOLL |
| NACHTRAG-Posten-91-Hinweis-Regeln | AUFGABE | Z24173 | OFFEN (Erst-Entwurf REV5) | Regel-Katalog Nachholbedarf-Indikatoren |
| Owner-Direktive-Hauptstrang-Rueckkehr-Einordnung | OWNER-ENTSCHEID | Z24177-24182 | ENTSCHIEDEN (verbatim) | P0-P3-Einordnung Hauptstrang/Nebenstrang |
| Owner-Verbatim-Mess-Achsen-CEB-Design-Freigabe | OWNER-ENTSCHEID | Z24184 | ENTSCHIEDEN (verbatim, mid-turn) | CEB setzt Mess-Design durch in Tier UND Pruefdock |
| NACHTRAG-Anker-Planung-fertig-S0-S9 | AUFGABE | Z24185 | FERTIG (adversarial bestaetigt) | Vollzugs-Plan Gates G0-G8, Risiken R1-R10 |
| NACHTRAG-Atlas-Topologie-Freigabe | AUFGABE | Z24186 | FREIGEGEBEN | Binary-Topologie-Diagramm, Heuristik optionale Binary |
| NACHTRAG-mittag8-Lesart-superseded | REGRESSION | Z24187-24188 | SUPERSEDED (durch mittag-9/-10) | Dreistufig-symmetrisch-Etikett war Zwischenstand |

| Owner-Atlas-Review-Runde4-Achsen-Klammer | OWNER-ENTSCHEID | Z24190-24194 | ENTSCHIEDEN (verbatim) | Achsen-Arten-Trichotomie als Klammer fehlt, lose UML-Module |
| NACHTRAG-Architektur-Konsolidierung-Auftrag | OWNER-ENTSCHEID | Z24196-24209 | BEAUFTRAGT (verbatim) | 12 Owner-Praezisierungen Mess-Auswertungs-Kette |
| Architektur-Kette-Bild-0-Kopf-der-Schlange | FEATURE | Z24212-24233 | DEFINIERT (verbatim) | Planer->CEB->Hybrid->Tier-Binary, Kopf=Laufzeit |

| Achsen-Arten-3-Typen-Klaerung | FEATURE | Z24237-24259 | GEKLAERT (per Explore) | Mess=3 Stufen, System/Organ=2 Stufen, Fortpflanzungs-Asymmetrie |
| Beleg-Korrektur-dreiphasig-case-sensitiv | REGRESSION | Z24261-24267 | BEHOBEN (Register-Korrektur) | falsche "0 Treffer" war case-sensitiv, real 8 |
| Owner-Kern-PMC-ist-Menge-keine-Einrichtung | OWNER-ENTSCHEID | Z24273-24279 | ENTSCHIEDEN (verbatim) | ALLE AMD/Intel-Architekturen mit PMC, P/E-Core getrennt |
| PMC-4-Festlegungen-plus-Hybrid-Baustein | FEATURE | Z24281-24305 | DEFINIERT (geplant, nicht gebaut) | PMU-Domaenen-Frage, HybridCorePinning-Baustein seit 09.04. |
| Mechanik-eine-CEB-zwei-Pinnings-Lead-Korrektur1 | REGRESSION | Z24309-24336 | BEHOBEN (Lead-Lesart war falsch) | Lead dachte "CEB je PMU-Domaene", real EINE CEB zweimal gestartet |
| Wo-Faehigkeit-geprueft-wird-Planer-Lead-Korrektur2 | REGRESSION | Z24340-24365 | BEHOBEN (Lead-Lesart war falsch) | Planer prueft RT, CEB traegt CT ein, nicht CEB prueft |
| Owner-Kern-Kompromiss-wenn-nicht-gepinnt | OWNER-ENTSCHEID | Z24369-24394 | ENTSCHIEDEN (verbatim) | warn statt fatal: "no pinned locality on hybrid architecture" |
| Vollstaendige-Schwere-Leiter-WARN-ERROR-FATAL | OWNER-ENTSCHEID | Z24398-24433 | ENTSCHIEDEN (verbatim, Bestand belegt) | WARN=Wert unbestimmt, ERROR=Anforderung unerfuellbar, FATAL=Integritaet zerstoert |
| Luecke-Doktrin-Vokabeln-verstreut | REGRESSION | Z24435-24438 | OFFEN | honest-0/honest-empty/honest-100% ueber Ledger/Thesis verstreut |
| Owner-Kern-Stiller-Rueckfall-verboten | OWNER-ENTSCHEID | Z24444-24464 | ENTSCHIEDEN (verbatim, allgemeine Regel) | Fehlschlag ohne Anzeige ist verboten |
| 3-Praezedenzfaelle-stiller-Rueckfall-geheilt | REGRESSION | Z24466-24470 | BEHOBEN (3 Faelle) | Cacheline-64-Literal c1c76c87, PerfCounter::open errno, gitleaks-0-commits |
| Offener-Fall-pmc_cache_misses_l3-AMD-Null | REGRESSION | Z24472-24478 | OFFEN (vor Messung faellig) | AMD errno=2 faellt still auf 0, Intel liefert 4M+ |
| Fehlende-Unter-Achse-numa_cpu_pin_process_probe | FEATURE | Z24482-24507 | OFFEN (nur im Plan, nicht gebaut) | Ausfuehrungs-Lokalitaet, spiegelt numa_page_probe |
| Hybrid-Binary-Funktions-Definition | FEATURE | Z24511-24540 | DEFINIERT (IST=nur README, ungebaut) | Factory-Facade-Adapter, Stufe2 gemischte Lasten |
| Auswertungs-Kette-mathematischer-Kern-Schnitte | FEATURE | Z24544-24570 | DEFINIERT | Messwerte->Funktions-Synthese->Schnitt-Kurven->optimale Konfig |
| Break-Even-drei-Benchmark-Ebenen | FEATURE | Z24574-24614 | DEFINIERT (verbatim) | Micro/Macro-timed/Macro-large-scope, H2-operative Form |
| Offene-Abgrenzungsfrage-3-Ebenen-vs-Tooling-Achse | REGRESSION | Z24615-24617 | OFFEN (in Klaerung) | wallclock/macro/micro hat 0 funktionale Konsumenten laut Befund |
| Bau-Posten-B1-numa_cpu_pin_process_probe-Erhebung | AUFGABE | Z24625 | OFFEN (Welle laeuft) | CEB-only, kein Tier-Neubau |
| Bau-Posten-B2-Konsument-Pinning-im-Mess-Loop | AUFGABE | Z24626 | OFFEN (vor Voll-Messung) | Planer-Freigabe->CEB-CT-Einbau |
| Bau-Posten-B3-getrennte-Ablage-je-PMU-Domaene | AUFGABE | Z24627 | OFFEN (vor Messung, sonst Datenbruch) | CSV-/Lager-Schema |
| Bau-Posten-B4-warn-no-pinned-locality | AUFGABE | Z24628 | OFFEN (mit B-2) | Zustand+Ausgabe |
| Bau-Posten-B5-pmc_cache_misses_l3-Status-Token | AUFGABE | Z24629 | OFFEN (vor Messung) | ehrlicher Status-Token statt stiller 0 |
| Bau-Posten-B6-RAW-Events-je-Mikroarchitektur | AUFGABE | Z24630 | OFFEN (vor Voll-Messung) | Deep-Research-Pflicht Zen3/4/5, Alder/Raptor Lake |
| Bau-Posten-B7-B10-Micro-Macro-BreakEven-Hybrid | AUFGABE | Z24631-24634 | OFFEN (nach Abgabe) | Micro-Benchmarks, Checkpoints, Break-Even, Hybrid-Adapter |
| Zwei-Primaerquellen-nicht-gelesen-Regel18 | REGRESSION | Z24641-24663 | BEHOBEN (Regel-Zeile 18 neu) | docs/termine 309 Dateien+Thesis als Spezifikation ungelesen |
| F-01-Talos-Falschaussage-Abgabe | REGRESSION | Z24669-24676 | OFFEN (Owner-Entscheidung noetig) | "jede Messung unter Talos+root-Linux" 0 Treffer im Code |
| F-02-flat_hash_map-Falschaussage-Abgabe | REGRESSION | Z24677-24679 | OFFEN (Owner-Entscheidung noetig) | Aufgabenstellung nennt es, Code hat SwissTable-Reimpl |
| Owner-Kern-PE-Core-Trennung-nie-gebaut | REGRESSION | Z24681-24683 | OFFEN | P1 Scope-Freeze seit 09.04., nie gebaut |
| Regel-Zeile-16-gesicherte-Vorarbeit-lesen | OWNER-ENTSCHEID | Z24686-24692 | ENTSCHIEDEN (Prozess-Regel neu) | Vor jeder Welle Abgleich gegen bereits Gemessenes |
| 6-Landungen-Anhang-A-Ehrlichkeit | REGRESSION | Z24698 | BEHOBEN (thesis 19e1592) | 28/28 Eintraege mit Ersatztext statt 11 |
| 6-Landungen-Beide-Thesis-Zeiger | AUFGABE | Z24699 | GELANDET (super 123b2f32) | Gitlinks identisch |
| 6-Landungen-super-Diff-Hygiene-Wache | FEATURE | Z24700 | GELANDET (super 7780c6af) | 558 Zeilen, 0 Verstoesse |
| 6-Landungen-Ueberblick-677-Zeilen | AUFGABE | Z24701/24707-24711 | GELANDET (super 1c7cdcb6) | 22MB Rohdaten verdichtet, 10 Befund-Gruppen A-J |
| 6-Landungen-Struktur-Haertung-Codegen | REGRESSION | Z24702 | BEHOBEN (ce b708c572) | 3/3 deterministischer Compile-Fehler bei Attach-Entzug |
| 6-Landungen-E14-NoneFilter | FEATURE | Z24703 | GELANDET (ce 77ed15fa) | golden-320 Round-Trip ALLE OK, cap=0->320 |

| Gestoppte-Welle-M1-drei-echte-Defekte-D1-D4-D2 | REGRESSION | Z24713-24726 | KORRIGIERT (Welle neu gestartet) | D-1 Mess-Achse 0 funktionale Konsumenten, D-4 Injektivitaetsverletzung |
| Praezisierung-MEASUREMENT_ON-ABI-wirksam-nicht-Preimage | REGRESSION | Z24725 | OFFEN | Release-Nachmessung erzeugt andere Binary mit identischem Fingerprint |
| Zwei-eigene-Fehlgriffe-Commit-in-Arbeitsbranch | REGRESSION | Z24727-24729 | BEHOBEN (bindende Konsequenz) | Landungen ab sofort ueber eigene Worktrees |
| Dritte-stille-Null-gitleaks-thesis-Submodul | REGRESSION | Z24731 | BEHOBEN (Elternrepo-Mount) | "no leaks found" bei 0 commits scanned |
| Entlastungen-Fingerprint-Block-vollstaendig-main | AUFGABE | Z24735 | ERLEDIGT (entlastet) | R4/T2-A/B14/A1 alle auf main |
| Entlastung-Test-lief-gegen-veralteten-lokalen-main | REGRESSION | Z24736 | BEHOBEN | lokalen main nachgezogen |
| Entlastung-Anhang-A-bricht-Bau-nicht | AUFGABE | Z24737 | ENTLASTET | 16 harte \input vollzaehlig |
| Neu-eingereiht-CI-erzeugt-Thesis-Divergenz-selbst | REGRESSION | Z24741 | OFFEN (Welle laeuft praeventiv) | anhang:forward bumpt nur einen Pfad |
| Neu-eingereiht-Alt-Bestands-Nicht-ASCII-super | REGRESSION | Z24742 | OFFEN (bewusst nicht gegatet) | 845 Nicht-ASCII+174 Breiten-Zeilen aus 18714 |
| Zwei-unwahre-Messgroessen-vor-Messung | REGRESSION | Z24743 | OFFEN (muessen vor erstem Batch stehen) | bytes_in_use_peak Momentanwert, Literal 64 |
| Regel-Zeile-15-Pruefung-ohne-Nenner-ist-keine | OWNER-ENTSCHEID | Z24747-24752 | ENTSCHIEDEN (Prozess-Regel neu) | jede Pruefung muss Nenner mitfuehren |
| Kette-T1-vollzogen-nach-zweimaligem-Abbruch | AUFGABE | Z24754-24756 | VOLLZOGEN | ce origin 2 Landungen hinterher |

| Vollzug-5-Schritte-je-Landung-T1 | AUFGABE | Z24758-24768 | VOLLZOGEN | ce+super 4 Refs ein Stand |
| Stille-Null-1-gitleaks-Submodul-nichts-geprueft | REGRESSION | Z24770-24776 | BEHOBEN (Elternrepo-Mount) | Submodul .git-Datei zeigt ins Leere im Container |
| Offener-Posten-fruehere-ce-Pushes-ungeprueft | REGRESSION | Z24776 | OFFEN (nicht rekonstruierbar) | Wache gehoert in Skript mit Nenner |
| Stille-Null-2-Sicherheitsrelevant-390-Runner-Tokens | REGRESSION | Z24778-24789 | BEHOBEN (abgefangen, Quarantaene) | 390 Runner-Registration-Tokens im Klartext im Backup |
| Schwererer-Befund-Token-nicht-rotiert | REGRESSION | Z24790-24798 | OFFEN (kritisch) | ce/super/thesis runners_token noch in Leck-Menge |
| Methodischer-Nebenbefund-Rotations-Test-Verfahrensfehler | REGRESSION | Z24800 | BEHOBEN | Mengentest ohne Zuordnung neu gebaut |

| Owner-Entscheid-Rotation-Cluster-Schreiboperation | OWNER-ENTSCHEID | Z24802 | OFFEN (Empfehlung: 3 Projekt-Token rotieren) | 387 uebrige Fremdprojekte separate Frage |
| Vier-Wellen-zwei-Teammate-Spuren-disjunkt | AUFGABE | Z24804-24814 | LAUFEND (bewiesen disjunkt) | M-1/M-2/E14/Struktur-Haertung/Backup-Verdichtung |
| G-E3-bewusst-nicht-freigegeben | AUFGABE | Z24815 | ZURUECKGESTELLT | schreibt gleiche Datei wie M-1a |
| E14-Freigabe-golden-320-bricht-nicht | REGRESSION | Z24817 | BEHOBEN (Owner-Freigabe traegt) | K14 Position immer Index 0 |
| Regel-Zeile-13-14-Frist-und-Buchfuehrung-veraltet | OWNER-ENTSCHEID | Z24821-24834 | ENTSCHIEDEN (2 neue Prozessregeln) | Frist muss im Ledger stehen |
| Zweite-Verlustwelle-Frist-Korrektur-15.09-0-0 | REGRESSION | Z24819-24844 | BEHOBEN (schwerster Einzelverlust) | Owner-Auftrag Buchfuehrung dokumentieren |

| N-1-Frist-Korrektur-Endtermin-15.09-woechentlich | OWNER-ENTSCHEID | Z24861-24889 | GEBUCHT (schwerster Einzelverlust) | Endtermin 15.09.2026 mit Freitags-Lieferung, 08.08. war Zwischenziel |
| N-1-Termin-Vokabular-Umstellung-T1-T4 | AUFGABE | Z24882-24888 | GEPLANT | T1=vor 4096er-Batch, T2=vor Voll-Messung, T3=vor 15.09 |

| N-2-Kalibrier-Stichprobe-erledigt-vor-Beauftragung | AUFGABE | Z24892-24920 | ERLEDIGT/GESTRICHEN (Task #21 erledigt) | 23.07-Slice-Empirie deckt Forderung |
| N-3-Zeit-Bilanz-Voll-Bau-Hochrechnung | AUFGABE | Z24924-24943 | BERECHNET | prod1 20,7h, prod2 34,4h Engpass |

| N-4-Bau-Umfang-korrigiert-524288-keine-Kappung | REGRESSION | Z24958-24998 | BEHOBEN (korrigiert nachmittag-11+Fahrplan) | 131072=Fenster je System-Perm, real 524288, keine Kappung wirkt |

| N-5-Batch-Semantik-4096-Aufloesung | AUFGABE | Z25005-25023 | GEBUCHT (Verstaendigungsposten) | 4096 Binaries je Scheibe, GitLab-Jobs O(Maschinen)=4 |
| N-6-XML-Trennung-Bau-Messung-Regression | REGRESSION | Z25027-25053 | OFFEN (Bau-Posten, Termin T2) | XML muss Bau/Messung getrennt definieren, nur Env-Schalter |

| N-7-LB-0-LB-6-Status-Konsolidierung | AUFGABE | Z25057-25101 | TEIL (LB-6 Stufe1 gelandet, LB-4/LB-5 offen) | ce b241a272, Buchungs-Fall geschlossen, Register-Haelfte offen |

| N-8-A10-HW-Erkennung-P4-P6 | AUFGABE | Z25105-25122 | OFFEN (T2, ins Register+P4-P6 bauen) | Vendor-Familie x OS Passungs-Stempel |
| N-9-A11-ccache-Allowlist-Drop-Widerspruch | OWNER-ENTSCHEID | Z25126-25146 | OFFEN (Owner-Entscheid, Empfehlung zurueckziehen) | Plan will Eintrag weg, Code MUSS bleiben |

| N-10-A12-NAS-Creds-backup1-backup2 | AUFGABE | Z25150-25162 | OFFEN (T3, Owner-Frage) | offene Owner-Frage ob A12 noch gilt |
| Neun-Korrektur-Punkte-eigener-Nachmessung | REGRESSION | Z25166-25202 | BEHOBEN (9 Korrekturen dokumentiert) | LB-0-LB-6 Zahlen ueberholt, Zeilen-Referenzen falsch |
| Strukturbefund-unversionierte-Dispositionsdateien | REGRESSION | Z25206-25213 | BEHOBEN (2 weitere Faelle gefunden) | Termin-Klassifikation+XML-Trennung waren unversioniert |

| Entlastung-3-Dateien-versioniert | AUFGABE | Z25214-25218 | BEHOBEN (1517071b+e110cf6d) | schaerfster Strukturbefund nachmittag-11 geheilt |
| Regel-Zeile-10-Kopf-nachmittag11 | OWNER-ENTSCHEID | Z25254-25257 | ENTSCHIEDEN (Regel wiederholt) | Paketschnitt nur in Session-Doc existiert fuer Ausfuehrung nicht |

| Vier-Verlustmechanismen-M1-M4 | AUFGABE | Z25276-25311 | DOKUMENTIERT (2 neue Mechanismen) | M1-Zeitfenster, M2-Quellenklasse, M3-Namenskollision, M4-Stellvertreterbuchung |
| Regel-Zeile-11-Namenskollision | OWNER-ENTSCHEID | Z25302-25304 | ENTSCHIEDEN (neue Prozessregel) | Trefferzahl erst Buchungsnachweis wenn gelesen |
| Regel-Zeile-12-E07-Stellvertreterbuchung | REGRESSION | Z25305-25311 | OFFEN (Regel neu, K1-K5/N1-N3 fehlen) | "Definition liegt vor" ist nicht "Gate erfuellt" |

| a-1-KK-5-P-1-allow_failure-Voll-Mess-Batch | REGRESSION | Z25318-25327 | OFFEN (VOR-TRIGGER, Plandokument unversioniert) | allow_failure auf Job-Ebene statt nur Mess-Zellen |
| a-6-E-07-Abnahmekriterien-K1-K5-N1-N3-Musterfall-M4 | REGRESSION | Z25360-25361+ | OFFEN (Musterfall Stellvertreterbuchung) | Dossier gelandet aber Kriterien 0x im Ledger/Code |

| a-6-E-07-Nachbuchung-B10 | REGRESSION | Z25370-25379 | NACHGEBUCHT (B10=E-07/B5, trigger-blockierend) | GO-Kriterium K1-K5+N1-N3 literal erfuellen |
| a-7-DEG-3-Masstree-Reference-keys-0 | REGRESSION | Z25381-25385 | OFFEN (Nachziehbedingung eingetreten) | for_each_record fehlt in composed_masstree_search.hpp |
| a-8-B2-180-reproduzierbarer-IDE-Einstieg | REGRESSION | Z25387-25390 | OFFEN | 0 launch.json unter Code/ |
| a-9-L19-vier-Doku-Defekte-FS4-Nummerierung | REGRESSION | Z25392-25398 | OFFEN | Alt-CRC-Anker lebt weiter, cmake globt nur topics/ |
| a-10-bis-a-15-sechs-Code-Anker-ohne-Buchung | REGRESSION | Z25400-25415 | OFFEN (6 Anker 0/0) | D-12 GraphBfs, V41.F.2/F.3 driftend 17 statt 18 |

| a-16-276-W10-00-Gate-verloren | REGRESSION | Z25417-25419 | OFFEN (Abnahmebedingung verloren) | Gate W10-00 0x im Ledger und CI |
| a-17-Chaos-Gate-User-Direktive-459 | REGRESSION | Z25421-25429 | OFFEN (0/0 trotz "GERETTET") | drift_detector.hpp ohne Produktions-Aufrufer |
| a-18-A9b-XML-DEAKT | AUFGABE | Z25431-25433 | GEBAUT (Buchung fehlt) | active=true|false-Kanal |
| b-184-Loader-Verdrahtung | REGRESSION | Z25437-25444 | OFFEN (Anspruch verloren) | echte Aufrufe nur in Test |
| b-AP12-246-Fairness-Harness | REGRESSION | Z25445-25446 | OFFEN | FairnessHarness 0 Dateien |
| b-REV-CXX-DATA-CI-TEX-30-Review-TODOs | REGRESSION | Z25447-25450 | OFFEN (Register 0) | P0-Teilmenge vor Vollmessung bedingt |
| b-AP7b3-27-Ledger-widerspricht-sich | REGRESSION | Z25451-25457 | TEIL (beide Aussagen teilw. recht) | SwissTableOrganSimd nirgends konsumiert |

| Streichung-2-KK1-PMC-bestgebucht | REGRESSION | Z25468-25471 | GESTRICHEN (bestgebuchter Posten, kein Verlust) | nachmittag-10 Abschnitt D + Task #11 |
| Streichung-3-KK2-K01-COMDARE_BESTANDSLOG-widerlegt | REGRESSION | Z25472-25476 | GESTRICHEN (widerlegt) | Variable wird real durchgereicht, Repo-Grep als Laufzeit-Aussage gelesen |
| Streichung-4-KK3-K05-doppelter-Job-Schluessel | REGRESSION | Z25477-25479 | GEHEILT | .gitlab-ci.yml:447 + neue Wache ci_yaml_key_guard.sh |
| Streichung-5-KK9-bytes_in_use_peak-selbst-entlastet | REGRESSION | Z25480-25481 | ENTLASTET (Doku-Rest P-5 bleibt) | f15_compare weist Spalte als honest-0 aus |
| Streichung-6-KK4-KK6-KK8-Bestandslog-Scope | AUFGABE | Z25482-25484 | VERTAGT (protokolliert nach Abgabe) | keine Kostenklammer |
| Streichung-7-K04-K07-K08-K09-entlastet | AUFGABE | Z25485-25487 | ENTLASTET | K-04 umklassifiziert zu geschuetzter Vollstaendigkeit |
| Streichung-9-CI-Chaos-Job-fehlt-bestaetigt | REGRESSION | Z25490-25492 | BESTAETIGT FEHLEND (beweist Job fehlt, entlastet nicht) | grep -ci chaos .gitlab-ci.yml = 0 |
| Streichung-10-R1-R9-Nacht-Audit-22.07-archiviert | AUFGABE | Z25493-25497 | TEIL (R8/R2 archiviert, R3-R7/R9 unbelegt) | RF-4 archiviert LEDGER:3580 |
| Streichung-11-KF4-KF7-KF10-KF11-D7a-D7b | AUFGABE | Z25498-25500 | GESTRICHEN (Scope D zog Erstbefund zurueck) | sachlich gebucht unter #221/H-9 |
| Streichung-12-A8-S3-A8-S4-Regex-Fehler | REGRESSION | Z25501-25502 | BEHOBEN (Regex-Fehler "a8s3" korrigiert) | klar gebucht LEDGER:3802-3804 |
| Streichung-13-Scope-C-durchgehend-sauber | AUFGABE | Z25503-25506 | GESTRICHEN | #188/#51/W12/GN-11 sauber verbucht |
| Streichung-14-171-172-gebucht | AUFGABE | Z25507 | GESTRICHEN | sota_catalog/best_binary_selector gebucht |
| Streichung-15-diverse-Bindestrich-Schreibweise | AUFGABE | Z25508-25509 | GESTRICHEN | AP-13/AP-5/AP-9/D-15/KF-12/OD-2/RF-1-7 korrekt gebucht |

| Nachmittag11-Prioritaeten-P2-P3-Kostenklammer-Plan | AUFGABE | Z25535 | VERTAGT (nach Abgabe) | aus Kostenklammer-Plan |
| Nachmittag11-Bilanz-18-verloren-15-umbenannt | AUFGABE | Z25543-25557 | DOKUMENTIERT | nur 2 echte Vor-Trigger-Postem, schaerfster Befund=unversionierte Datei |

| Codex-Lage-M4-Stellvertreterbuchung-Herkunft | AUFGABE | Z25561-25568 | DOKUMENTIERT | Codex-Aussage korrigiert bei #276/W10-00 |
| Unbelegt-Punkte-nicht-als-Fund-gefuehrt | AUFGABE | Z25569-25573 | OFFEN (unbelegt) | R3-R7/R9, GATE-7-Supersede-Pflicht 0 Treffer |
| Methodische-Groesstluecke-Keyword-Grep | REGRESSION | Z25574-25576 | OFFEN (113/133 Dateien nur gesiebt) | LB-artiger Fall koennte durchgefallen sein |
| Nachmittag10-Vollzug-beide-Repos-gruen | AUFGABE | Z25581-25610 | GELANDET | ce+super gruen, main-FF vollzogen beide Repos |

| Korrektur-Bridges-fehlten-in-Zaehlung | REGRESSION | Z25612-25626 | BEHOBEN (7 gruene Laeufe, 2 Bridges) | /pipelines/jobs zeigt keine Bridges |
| Zwei-Lint-Fixes-gemeinsame-Ursache | REGRESSION | Z25628-25661 | BEHOBEN (98952e02+e7aa1244) | lint:format+lint:static nie gegen Landung gefahren |
| Regel-Zeile-8-Submodul-Zeiger-rueckwaerts | OWNER-ENTSCHEID | Z25665-25666 | ENTSCHIEDEN (neue Prozessregel) | M heisst nicht neuer |

| Regel8-Beleg-Submodul-Rueckstand-78-Commits | REGRESSION | Z25673-25683 | BEHOBEN (Pathspec verhinderte Schaden) | thesis-Submodul 78 Commits zurueck |
| Regel9-Beleg-rescue-Ref-keine-Landung | REGRESSION | Z25685-25701 | BEHOBEN (nachgeholt) | Gate-8-Graph-Abbildungen CI-geprueft aber in keinem Zweig |
| Vollzug-Gate8-gelandet | AUFGABE | Z25706-25714 | GELANDET | super development=85b74237, Pipeline 15034 success |
| A1-Verdikt-Landen-mit-Auflage | AUFGABE | Z25716-25721 | LANDET (Lead-Entscheid, Bau laeuft) | reallocate-Fix 24 Strategie-Header ohne ABI-Bump |

| Owner-Doktrin-Bump-Entscheidung-4-Sub-Concepts | REGRESSION | Z25722-25734 | BEHOBEN (Lead entschied FUER Bump) | Inkonsistenz zur Vorwelle, 4 statt 3 neue Sub-Concepts |
| PMC-Sperrposten-vierte-Wache-nicht-defekt | REGRESSION | Z25736-25763 | OFFEN (4 Wachen statt 3) | #37-PMC-Preflight beisst nicht, exit 0 bei fehlendem Flag |
| PMC-Wurzel-Pflicht-an-2-Job-Namen-geheftet | REGRESSION | Z25765-25776 | OFFEN (Fehlerklasse von R4) | dynamische Kette liess Pflicht bei alten Job-Namen zurueck |

| I-PMC-2-bleibt-offen-Anhang-begrenzt | REGRESSION | Z25782-25785 | OFFEN (vor Phase 6 entscheiden) | L3/L2/coherence/energy bleiben 0 auch mit Flag |
| Korrektur-Lager-Scope-Fehlsuche-verschiedene-Vokabel | REGRESSION | Z25789-25802 | BEHOBEN (Korrektur an eigenem Nachtrag) | OE-B Dummy-Lager auf Baum-Form erweitert existiert |
| F9-LB-Paketschnitt-buchhalterisch-verloren-innerhalb-Fenster | REGRESSION | Z25804-25828 | OFFEN (Ursache=Quellenklasse nicht gelesen) | LB-0..LB-6 0/0 trotz Vor-Trigger-Rang |

| Entwarnung-4-Kopf-Bausteine-gebaut | AUFGABE | Z25830-25844 | TEIL (LB-0/LB-1 getestet, LB-2/LB-3 keine Beweiswelle) | 33+23 TEST-Makros |
| Zwei-Folgeposten-LB6-Stufe1-Pflicht-und-F7-aelter | AUFGABE | Z25852-25864 | OFFEN (Empfehlung vor Trigger) | Versionierungs-Interface aelter als F7 (22.07.) |
| Nachtrag-selbst-Pipeline-15037-nur-2-Jobs | AUFGABE | Z25866-25879 | DOKUMENTIERT (Musterfalle) | rules:changes laesst nur betroffene Jobs fahren |

| Nachgeholte-Verifikation-4-Owner-Pushes | AUFGABE | Z25882-25893 | VERIFIZIERT | ce/super/thesis alle 4 Pushes gruen |
| Thesis-baut-blg-Beleg-Methoden-Hinweis | AUFGABE | Z25895-25907 | VERIFIZIERT | DE 202 Seiten, EN 192 Seiten, Trace-Zaehl-Falle |
| Korrektur-Thesis-nicht-Wiederbelebung | REGRESSION | Z25909-25912 | BEHOBEN (Annahme korrigiert) | 12 Laeufe heute allein, Regelfall |
| Offen-PMC-3-Dinge-vor-Phase6 | OWNER-ENTSCHEID | Z25914-25921 | OFFEN | Flag als Invariante, Wache drehen, Anhangs-Umfang |
| Nachmittag9-Pipeline-15022-rot-15025-gruen | REGRESSION | Z25923-25933 | BEHOBEN | contract:axis-version-lock war 3 Wochen faktisch AUS |

| Zwei-Fixes-Format-Nachzug-cppcheck | REGRESSION | Z25938-25959 | BEHOBEN (98952e02+e7aa1244) | Format 94/13 reproduziert, cppcheck Werkzeug-Limit |
| Betriebs-Doktrin-gitleaks-mit-Repo-Konfig | OWNER-ENTSCHEID | Z25966-25971 | ENTSCHIEDEN (neue Regel) | gitleaks immer mit Repo-Config und ueber Push-Inhalt |
| Regel-Zeile-6-7-Gate-deckt-nur-Gegenstand | OWNER-ENTSCHEID | Z25973-25989 | ENTSCHIEDEN (2 neue Regeln) | Diff-Hygiene != clang-format, Gate-Umfang repo-spezifisch |

| Submodul-Bump-committet-wartet-super-gruen | AUFGABE | Z25991-25999 | WARTET | ce-Gitlink 7969b399->e7aa1244 committet nicht gepusht |
| Nebenbefund-herrenloses-Submodul-Drift | REGRESSION | Z25997-25999 | OFFEN (braucht Besitzer) | overleaf-diplomarbeit Drift unversioniert |
| Main-unangetastet-Owner-Entscheid | OWNER-ENTSCHEID | Z26001-26004 | OFFEN (liegt beim Owner) | main darf nie auf roten Stand zeigen |
| PMC-Sperrposten-verschaerft-Windows-Beschreibung | REGRESSION | Z26006-26032 | OFFEN (Sperrposten vor Phase 6) | Option-Beschreibung irrefuehrend, gated auch Linux |
| Nachmittag8-L1-Buendel-gelandet | FEATURE | Z26034-26043 | GELANDET (lokal, ungepusht) | T2-A+B14+CI-Invariante 3 Merges |

| A1-NB2-bewusst-draussen | AUFGABE | Z26045-26048 | OFFEN (fehlt Freigabe) | Lens-Verdikt fehlt |
| Testzahl-407-nicht-409-geklaert | REGRESSION | Z26054-26063 | BEHOBEN (geklaert) | 4 Tests haengen an Configure-Zeit-Bedingungen |
| Probe-aufs-Exempel-Wache-besteht-eigenen-Bestand | AUFGABE | Z26065-26074 | BESTANDEN | 8792 Zusatzzeilen 0 Nicht-ASCII, 407/407 Abdeckung |
| Frozen-TABU-gelandeter-Stand-rein | AUFGABE | Z26076-26081 | VERIFIZIERT | Neuanker rein, kein Mischzustand |
| Pruefbereichs-Familie-Regel-1-2 | OWNER-ENTSCHEID | Z26083-26098 | ENTSCHIEDEN (2 neue Regeln) | Gate-Zahl braucht Pruefbereich=Merge-Base |

| Pruefbereichs-Familie-Regel-3-4-5 | OWNER-ENTSCHEID | Z26101-26116 | ENTSCHIEDEN (3 weitere Regeln) | Bau-Zustand, generierte Artefakte, Vollstaendigkeitsaussage |
| K-01-widerlegt-COMDARE_BESTANDSLOG-durchgereicht | REGRESSION | Z26118-26153 | WIDERLEGT (beide Befunde richtig) | Variable via append_forward_var_literal durchgereicht |

| Offen-Owner-Infra-Frage-Trigger-Bestandslog | OWNER-ENTSCHEID | Z26157-26161 | OFFEN | faehrt Trigger-Lauf mit gesetztem COMDARE_BESTANDSLOG? |
| B14-cc20b63d-Format-Rausch-Lehre | REGRESSION | Z26163-26179 | BEHOBEN (geschlossen nicht vertagt) | Zweit-Review meldete rot faelschlich, Branch bewegte sich |
| Offen-nach-Landung-liste-nachmittag8 | AUFGABE | Z26181-26188 | OFFEN (mehrere Punkte) | Push+main-FF, super-Pakete Breiten-Heilung |
| Nachmittag7-Trockenprobe-Bereichs-Lehre-9-Verstoesse | REGRESSION | Z26190-26206 | BEHOBEN (Lehre dokumentiert) | Format-Commit traf 3 Dateien, 9 Verstoesse in 5 anderen |

| Trockenprobe-Reihenfolge-nicht-frei-R4CI-Wache | REGRESSION | Z26212-26245 | BEHOBEN (Reihenfolge korrigiert) | Wache faende eigene Pakete rot wenn zuerst gelandet |
| T2A-9-Verstoesse-zerlegt-Doxygen-Kommentar | REGRESSION | Z26247-26254 | BEHOBEN (Owner/Lead Weg1) | 1 Zeile 121 Byte, Umbruch statt Kuerzung |
| Dritte-Messung-nach-Fix-gruen-409 | AUFGABE | Z26256-26262 | VERIFIZIERT | Fix traf genau 5 Dateien, 409/409 Tests |

| Praezisierung-Gate-Formulierung-Frozen-Block | REGRESSION | Z26266-26271 | BEHOBEN (korrigiert) | "Datei unbewegt" falsch, "Frozen-Block byte-identisch" richtig |
| Wache-verifiziert-2-synthetische-Proben | AUFGABE | Z26273-26283 | VERIFIZIERT (offene Beobachtung) | Koordinaten-Abweichung bei b14, Arbeitsregel awk |
| Frozen-TABU-Buendel-vereinigter-Baum-haelt | AUFGABE | Z26285-26299 | VERIFIZIERT | kein Mischzustand, 0 Alt-Vektor-Reste |
| Korrektur-main-Divergenz-existiert-nicht | REGRESSION | Z26301-26311 | BEHOBEN (Meldung korrigiert) | lokaler Branch 10 Tage alt, keine echte Divergenz |
| Korrektur-Submodul-Zeiger-nicht-zurueckgedreht | REGRESSION | Z26313-26317 | BEHOBEN (Meldung korrigiert) | kein Paket fasst Zeiger an |

| Verfahren-Bump-uebernommen | AUFGABE | Z26321-26325 | DEFINIERT (Verfahren) | 4-Schritt-Reihenfolge fuer Submodul-Bump |
| B14-kein-Blocker-mehr-XXE-geheilt | REGRESSION | Z26327-26342 | BEHOBEN (cb4b15e9+2a58e2ed) | XXE strukturell geheilt, RANGE-Null-Pruefung |
| B14-3-Punkte-bewusst-nicht-geheilt | AUFGABE | Z26336-26338 | ENTSCHIEDEN (bewusst) | namensraum-tolerante Wache waere permissiver |
| Landereif-Stand-nach-Fix-nachmittag7 | AUFGABE | Z26344-26349 | LANDEREIF | ce T2-A/A1-NB2/B14-ce/R4CI, super frei |
| Offen-4-Punkte-Fail-closed-Patch | AUFGABE | Z26351-26366 | OFFEN (4 Punkte, meist nach Abgabe) | present_-Gate, Formwache verfeinern |

| Owner-Doktrin-gegen-Kostenklammern | OWNER-ENTSCHEID | Z26370-26374 | ENTSCHIEDEN (verbatim) | "heute unerreichbar" entlastet nicht |
| Vier-Befunde-Opus-Zweit-Review-a-d | REGRESSION | Z26376-26385 | OFFEN/TEIL (gleiche Fehlerklasse) | Kollisions-Eimer, Miss-Zahl weggeworfen, Push-Barriere, Fingerprint-Form |
| Entscheidungen-Kostenklammer-faellt-teilweise | OWNER-ENTSCHEID | Z26387-26393 | ENTSCHIEDEN | Glied1 raus, Glied2 Fail-Safe bleibt, Codex-Auflagen in Patch |
| Mess-Falle-ASCII-Gates-still-gruen-ugrep | REGRESSION | Z26395-26401 | BEHOBEN (Ursache gemessen) | ugrep -G bricht bei grep -v ab, RC=2, 0 ohne Messung |
| Nebenbefund-120-Zusage-haelt-nicht-Gesamtserie | REGRESSION | Z26401 | BEHOBEN (kosmetisch) | 2 Verstoesse in faa525d7 uebersehen |
| Zwei-Prozess-Lehren-Lebend-Check | OWNER-ENTSCHEID | Z26403-26406 | ENTSCHIEDEN (2 Lehren) | Lebend-Check vor Bereinigung, Vollstaendigkeitsaussagen |
| Stand-T2A-B14-CI-Invariante-Korrekturen | AUFGABE | Z26408-26421 | UNGELANDET (3 Zuordnungs-Korrekturen) | alle Pakete ungelandet, *.log-Falle 3x |
| Offen-Liste-nachmittag6 | AUFGABE | Z26421 | OFFEN | Host-Belegung batch_plan_datei 0 Treffer |

| Owner-Kern-Lager-Basis-Tests-Dummy-Strategien | OWNER-ENTSCHEID | Z26423-26437 | ENTSCHIEDEN (verbatim, SOLL-Bild bindend) | Factory Stempel-Erkennung, Stufe1 Text, Stufe2 Binary-Stub |
| Lead-Fehler-Kosten-Klammer-uebernommen-widerlegt | REGRESSION | Z26425 | BEHOBEN (Owner hat recht) | Fehlerklasse 11 neu |
| Sofort-Konsequenz-Verifikations-Welle-L1-Dual-Review | AUFGABE | Z26444 | LAEUFT | 3 Optionen a/b/c |
| T2A-NB2-fertig-Neuanker-komplett | FEATURE | Z26446-26452 | GEBAUT (12 Commits, finales Review laeuft) | WIP-Uebernahme-Bilanz, 5 eigene Eingriffe |
| Entscheid-Befund2-Mess-Zaehler-echte-Praefix-Semantik | OWNER-ENTSCHEID | Z26450 | ENTSCHIEDEN | Owner-KERN woertlich Front |
| Cacheline-Deep-Research-fertig-CLU-Phantom | AUFGABE | Z26454-26461 | FERTIG (Owner-Frage beantwortet) | line_size 3 Dimensionen, nur Zaehl-Einheit Phantom |
| Entschaerfung-Cacheline-dringt-heute-nicht-durch | AUFGABE | Z26458 | ENTLASTET | Codegen emittiert per-Organ-Config nicht |
| Super-Codex-Blocker-xmllint-Migration-neue-Luecken | REGRESSION | Z26463-26472 | OFFEN (6 HOCH-Befunde) | Ausnahme-Lexer nicht quote-bewusst, stille Entity-Verweigerung |
| Methoden-Durchbruch-Codex-git-Haenger | REGRESSION | Z26465 | BEHOBEN (Workaround verifiziert) | Codex git selbst ausfuehren haengt |
| Lead-Konsequenz-B14-NB4-gestoppt-neu-aufgesetzt | AUFGABE | Z26473 | GESTOPPT/NEU (wf_e18c1d53) | unvollstaendiges Befundbild haette NB5 erzwungen |
| Pause-beendet-alle-Straenge-hochgefahren | AUFGABE | Z26475-26477 | RESUMED (ultracode-Modus) | Erdung vor Resume, Worktree-Ist geprueft |

| Resume-Entscheidung-Lehre-nie-blind-resumen | OWNER-ENTSCHEID | Z26478 | ENTSCHIEDEN (neue Lehre) | Eintrittsgate gegen Objekt-Ist pruefen |
| Fehlerklassen-Pruefliste-10-Klassen | OWNER-ENTSCHEID | Z26480/26484 | ENTSCHIEDEN (Auflage) | jedem Bau-Auftrag mitgeben |
| Korrektur-18-Achsen-Widerspruch-ueberholt | REGRESSION | Z26485 | WIDERLEGT (V-01 eine Stunde spaeter) | 7 Stellen liegen in UN-INCLUDED Alt-Dateien |
| B14-NB3-Verdikt-Konvergenz-ce-blockiert | REGRESSION | Z26487-26497 | OFFEN (CE blockiert) | CLU-Befund bestaetigt, neue Wache pinnt falsches SOLL |
| XXE-Kanarienvogel-mittel-neu | REGRESSION | Z26491 | OFFEN (Zusatz-Bedingung noetig) | --nonet blockt Netz nicht lokales Dateisystem |
| Flag-Umgehung-konstruiert | REGRESSION | Z26492 | OFFEN (Fix=1 Zeile) | Wache prueft nicht ob Fehler wirklich Doppelbindestrich |
| Divergenz-Lenses-Churn-Leck-Lead-folgt-Opus | OWNER-ENTSCHEID | Z26495 | ENTSCHIEDEN (kein Landeblocker) | Code-Begruendung muss umgeschrieben werden |
| Gate-Spiegel-Luecke-CE-Logs-fehlen | REGRESSION | Z26496 | OFFEN (Auflage vor Landung) | nur behauptet nicht abgelegt |
| B14-NB3-CE-nicht-landen-64-Konsument | REGRESSION | Z26499-26506 | OFFEN (Landeblocker) | Fix erzeugt neue falsche Werte an anderer Stelle |
| Latenter-OOB-vom-Diff-unberuehrt | REGRESSION | Z26504 | OFFEN | ComposedStore/NodeChunkedStore lesen ausserhalb Backing |
| Parallel-gestartet-T2A-NB2-V01-A15-Konsolidierung | AUFGABE | Z26507 | GESTARTET | 20 vergessene Positionen ueberfuehren |
| T2A-Nachbesserung-fertig-5-Befunde-geheilt | REGRESSION | Z26509-26518 | BEHOBEN (4 Commits) | Indexfolge-Bindung, Multi-Writer-.tmp, Provider-Doppelaufruf |
| F8-Doktrin-als-Erwartung-festgeschrieben | OWNER-ENTSCHEID | Z26514 | FESTGESCHRIEBEN (Owner-Frage) | gleicher Fingerprint->spaeterer Lauf resumiert |
| F1-Spiegel-Entscheid-spiegeln | OWNER-ENTSCHEID | Z26515 | ENTSCHIEDEN | Defekt real+produktiv, Spiegel gebaut |
| Neu-notiert-Korn-Divergenz-Stempel | REGRESSION | Z26517 | OFFEN (Folge-Welle) | hartes vs parametrisiertes Korn divergiert |
| Offen-4-Voll-Scope-Befunde-Folge-Welle | AUFGABE | Z26518 | OFFEN | Bau-Zaehler vor Push-Drain, Mess-Zaehler kein Praefix |
| ABC-Delta-fertig-Verlustklasse-Bruecke-Vor-Zeit | AUFGABE | Z26520-26529 | FERTIG (20 Positionen, 6 relevant) | §55 nie ueberfuehrt |
| 6-Trigger-Abgabe-relevante-vergessene-Posten-V01-V08 | REGRESSION | Z26526 | OFFEN (6 Owner-Vorlage) | V-06 GN-9, V-03 neunzehn-Achsen-Textstellen, V-08 Cache-Misses |
| 2-Sofort-Posten-V11-V13 | REGRESSION | Z26527 | GEMISCHT (V11 offen, V13 verifiziert) | #327 PAT-Rotation Security, rescue-Ref verifiziert |
| Lehre-Konsolidierung-Zeitfenster-als-Grenze | OWNER-ENTSCHEID | Z26529 | ENTSCHIEDEN (Dauer-Regel-Kandidat) | letzter Voll-Block davor als Eingang mitnehmen |
| Modell-Matrix-Fable-faellt-aus-Opus-Dauer-Regel | OWNER-ENTSCHEID | Z26531-26535 | ENTSCHIEDEN (verbatim) | Fable Kontingent erschoepft, Opus 5 max dauerhaft |

| Codex-Voll-Scope-4-neue-Befunde | REGRESSION | Z26537-26547 | OFFEN (Folge-Welle) | Bau-Zaehler vor Push-Drain, F4 umgeht Fingerprint |
| Cross-Run-Halbzustand-F8-Owner-Frage | OWNER-ENTSCHEID | Z26546 | OFFEN (F8 bleibt) | Neubau mit gleichem Fingerprint invalidiert Stamp nicht |
| Lager-Explore-Owner-hat-recht | AUFGABE | Z26551-26555 | UNGELANDET+INERT | Ebene1 heute inert, pa.batch_plan_datei 0 Treffer |
| Versionierungs-Interface-Phase1-Erhebung | AUFGABE | Z26557-26560 | TEIL (Format3 ja, dev Format2 nein) | System-Unter-Achsen Compiler-Gruppe fehlen |
| Owner-Korrektur-F4-read_batch_plan-echt | REGRESSION | Z26562-26567 | BEHOBEN (Lead-Fehler eingestanden) | Kommentar widerspricht Planung |
| CI-Wurzel-geschlossen-9-statt-1-ungedeckte-Tests | REGRESSION | Z26569-26578 | BEHOBEN (baaaea62+dcb2f08f) | test:coverage-guard neu, 21 tote Tests wiederkehrend |
| Neuer-Vorbefund-contract-axis-version-lock-zweimal | REGRESSION | Z26577 | OFFEN (Lead/Owner-Entscheid) | letzter Schluessel gewinnt, Tripwire de facto aus |
| T2A-NB-Welle-gestartet-5-Befunde | AUFGABE | Z26579-26580 | GESTARTET | 5 Befunde heilen |
| B14-NB3-super-Wurzel-geloest-xmllint | REGRESSION | Z26582-26588 | BEHOBEN (1ba29b63) | Selbstbau-Parser ersatzlos durch xmllint abgeloest |
| Zusatzbefund-all_axes_golden-nicht-wohlgeformt | REGRESSION | Z26587 | BEHOBEN (Flag selbst-zurueckziehend) | -- in 3 Kommentaren, libxml2 lehnt ab |
| B14-NB3-CE-Mess-Validitaets-Loch-geschlossen | REGRESSION | Z26590-26596 | BEHOBEN (16a173f2) | Achse sagt 32/64/128/256, ALT las immer 64 |
| Geschwister-Befund-ObservableMemoryLayout | REGRESSION | Z26592 | BEHOBEN | dasselbe Literal, jetzt byte-neutral gefixt |
| Offener-Posten-zweites-Leck-Churn-Segment | REGRESSION | Z26594 | OFFEN (bewusst nicht geheilt) | liegt im gemessenen T6-Fenster |

| Scope-F4-Echte-Kritisch-Indexfolge | REGRESSION | Z26597-26602 | ECHT KRITISCH (Lead uebernimmt) | Zaehler bindet nicht eindeutig an Indexfolge |
| Scope-K2-Verdikt-geschlossen-F8-Doktrinfrage | OWNER-ENTSCHEID | Z26604-26609 | GESCHLOSSEN (SCHWER=Doktrinfrage) | Cross-Run kein Bug sondern Doktrin, F8 offen |
| Scope-Perm-Verdikt-F1-fehlt-im-Zwilling | REGRESSION | Z26611-26619 | HOCH (L1-Auflage kein Blocker) | Experiment-Zwilling ueberschreibt DLL je Zelle |
| Owner-Architektur-Kern-Versionierungs-Interface | OWNER-ENTSCHEID | Z26621-26627 | ENTSCHIEDEN (verbatim, F7) | CT-Namensfunktion, gesondertes Interface Planer/CEB/Tier |
| Trigger-Blocker-geheilt-847c93c9-zweiter-Defekt | REGRESSION | Z26629-26636 | BEHOBEN | Lese-Punkt im toten Winkel, F7 3 Optionen |
| Owner-Anregung-Codex-parallele-Scopes | OWNER-ENTSCHEID | Z26638-26643 | ENTSCHIEDEN (verbatim, Dauer-Muster) | 3 Scope-Lenses gestartet |
| Owner-Direktive-Wurzel-statt-Ausschluss-R4 | OWNER-ENTSCHEID | Z26645-26652 | ENTSCHIEDEN (verbatim) | Vollstaendigkeits-Invariante statt Job-Config-Fix |
| Owner-CI-Loch-korrigieren-R4-Welle-delegiert | OWNER-ENTSCHEID | Z26654 | ENTSCHIEDEN (verbatim) | R4-Welle gestartet |

| R4-Auftrag-erweitert-Inventur-ganze-Klasse | AUFGABE | Z26656-26659 | AUFGEBAUT (b=Job-Config) | Gesamtmenge gegen Vereinigung aller Job-Auswahlen |
| Batchplan-Kette-gebaut | FEATURE | Z26663-26665 | GEBAUT (41091cb4) | Feld fehlte auf 3 Schichten |
| Befund-B-Trigger-Blocker-resumiertes-Fenster | REGRESSION | Z26666 | OFFEN (Heilungswelle gestartet) | built=0 -> provision_ok=false -> exit1 |
| Befund-A-Wirksamkeitsgrenze-18-Paesse | REGRESSION | Z26667 | OFFEN | Plan-Stempel haengt an Selektion des Passes |
| F5-Golden-Plan-fertig-keine-Wache | REGRESSION | Z26670-26673 | OFFEN (Plan fertig) | experiment_golden_kern.xml gar keine Wache |
| E18-SNAP-NB2-Codex-nicht-landen-9-Kipp | REGRESSION | Z26675-26678 | OFFEN (P4 kein Trigger-Blocker) | Remote-Validator akzeptiert leere Belege |
| F3-Plan-fertig-3-Korrekturen-CI-Loch | REGRESSION | Z26680-26686 | OFFEN (R4 real) | Label contract ausgeschlossen, kein CI-Job |
| Gate8-fertig-23-Abbildungen | FEATURE | Z26688-26694 | GEBAUT (8970465d) | appendix_generator-basiert |
| Nebenbefund-axis_inventory-nie-eingebunden | REGRESSION | Z26695 | OFFEN (Aufraeumpass-Kandidat 9) | wird geschrieben aber nirgends eingebunden |
| Owner-Lead-Rolle-temporaer-Opus5-6-Wellen | OWNER-ENTSCHEID | Z26697-26707 | ENTSCHIEDEN (verbatim) | 6 Wellen gestartet disjunkt |
| B14-Codex-super-Blocker-ce-Nachbessern-8-Kipp | REGRESSION | Z26709-26714 | OFFEN (nicht landefaehig) | CDATA-Stripper ohne Lexikalzustand |
| Neue-Falle-2-Pass-Configure-praezisiert | REGRESSION | Z26712 | BEHOBEN (Gate-Doktrin) | 404 statt 408, 3. Configure noetig |
| Graph-Umbau-komplett-4-Fehler-1-Bestandsfehler | REGRESSION | Z26714 | BEHOBEN (5 Commits) | seg_attribution.tex seit Landung nicht kompilierbar |

| Owner-Entscheide-F1-F3-F4-F5-O3-verbatim | OWNER-ENTSCHEID | Z26718-26727 | ENTSCHIEDEN (verbatim, 5 Antworten) | F5 Golden-Update-Fenster neu, O-3 Loesch-GO |
| F4-UML-Doktrin-Korrektur-3-Versionen | REGRESSION | Z26724 | BEHOBEN (Doktrin verschaerft) | letzte REV5 nicht superseded sondern vorlaeufig |
| A1-NB2-ausgelaufen-gesichert-5-Mittel-geheilt | REGRESSION | Z26729-26733 | BEHOBEN (6 Commits fdfa68ee) | 3 Sub-Concepts, Versions-Orakel |
| E18-SNAP-NB2-ausgelaufen-91-56-Proben | AUFGABE | Z26735-26738 | GESICHERT (5c4cf900) | alle 5 Mindestanforderungen mit ALT-Gegenproben |
| Mess-Layer-Kanon-rekonstruiert-Fabrikation | REGRESSION | Z26740-26744 | BEHOBEN (vormittag-38 war Fabrikation) | V5-Zwei-Phasen-Op-Schleife |
| Owner-F6-neue-Frage-§47-Supersede | OWNER-ENTSCHEID | Z26744 | OFFEN | verwirft Fehl-Deutung auch §47-Konzept selbst? |
| Owner-Auslaufen-lassen-abbruchsicher-vormittag46 | OWNER-ENTSCHEID | Z26746-26749 | ENTSCHIEDEN (verbatim) | 7 laufende Straenge auslaufen |
| Owner-Scan-vergessene-Arbeit-5-Verdraengungen | AUFGABE | Z26751-26759 | GEBORGEN (5 Verdraengungen) | search_algo-Pin-Frage F5, 4-Klone-Sync |
| Fable-Review-T2A-landebereit-3-Auflagen | REGRESSION | Z26759 | TEIL (landebereit mit Auflagen) | batch_plan_datei braucht auch ce-Facade-Glied |
| Graph-Welle-Zwei-Schreiber-Kollision-Lead-Fehler | REGRESSION | Z26761-26765 | BEHOBEN (neue Falle dokumentiert) | SendMessage an laufenden Workflow resumt zweite Instanz |
| Posten92-Option-A-gelandet | FEATURE | Z26767-26770 | GELANDET (ce Merge 3bbcb8ed) | Kanon-Einordnung Registry-Partitionierung |
| Owner-Korrektur-Mess-Layer-Mikro-Makro-falsch | OWNER-ENTSCHEID | Z26772-26774 | ENTSCHIEDEN (verbatim) | Wallclock je Tier-Binary-Funktion x Last |

| OD7-Handout-committet-Register-stale | REGRESSION | Z26776 | BEHOBEN (Memory korrigiert) | 16-Kerne-Cap kein Code-Beleg |
| T2A-komplett-P0-Bau-fertig | FEATURE | Z26778-26784 | GEBAUT (3a42bf90) | K2+F4-Mechanik, Dual-Review gestartet |
| Gitignore-Falle-log-Gate-Spiegel-3-Faelle | REGRESSION | Z26783 | BEHOBEN (force-added) | *.log schluckte 21/26 Dateien stumm |
| Posten92-Kartierung-entschaerft | REGRESSION | Z26786-26790 | TEIL (Option A gestartet) | Single-Source-Verstoss kein Datenfehler |
| P2-P8-Kartierung-fertig-33-Spalten | FEATURE | Z26792-26796 | KARTIERT (Bau-Queue) | reine Namensvergabe, kein ABI-Bruch |
| Owner-Kern-Gattung-Genus-vierter-Layer | OWNER-ENTSCHEID | Z26798-26802 | ENTSCHIEDEN (verbatim) | Explore-Modell nur Sonnet-5-max |
| Owner-maximal-parallel-8-Straenge | OWNER-ENTSCHEID | Z26804-26816 | ENTSCHIEDEN (verbatim) | 8 disjunkte Straenge |
| A1-Codex-frisch-Nachbessern-7-Kipp | REGRESSION | Z26817-26821 | NACHBESSERN (7. Kipp) | 5 MITTEL neu/restlich |
| Owner-Dauer-Regel-Behauptungen-verifizieren | OWNER-ENTSCHEID | Z26821 | ENTSCHIEDEN (verbatim) | Memory neu |
| B14-NB2-Verifikation-6-6-gedeckt | REGRESSION | Z26825 | BEHOBEN (verifiziert) | 7 Praeparate ALT stumm-gruen -> NEU RC=1 |
| ce-WIP-Fund-gesichert-kLbufBytes | AUFGABE | Z26826 | GESICHERT (Patch) | inhaltlich fertig uncommitted |
| Owner-Korrektur-kein-CSV-Lager-xlsx-default | REGRESSION | Z26827 | BEHOBEN (Erklaerung korrigiert) | xlsx=Default, CSV=Fallback Strategy |
| E18-SNAP-Codex-nicht-landen-6-Kipp | REGRESSION | Z26829-26833 | OFFEN (P4 kein Blocker) | mkdir-Lock nicht runneruebergreifend |

| Spend-Limit-Abriss-beide-Wellen-Substanz-gerettet | REGRESSION | Z26835-26842 | BEHOBEN (Wiederanlauf-Doktrin) | Commits ueberleben, Berichte nicht |
| Session-Log-Luecken-Explore-9-geheilt | AUFGABE | Z26844-26852 | GEHEILT (9 Luecken) | Owner-/compact-Direktive nachpersistiert |
| Offene-Owner-Fragen-4-vormittag32 | OWNER-ENTSCHEID | Z26852 | OFFEN (4 Fragen) | E-1-Praezisierung, Explore-Modell, Scheibe-6, UML |
| Journal-Vollpruefung-16-16-0-Luecken | AUFGABE | Z26854-26859 | VERIFIZIERT | 1 Teil-Luecke geschlossen (rescue-Ref) |
| Owner-Direktive-Codex-Rechte-mitgeben | OWNER-ENTSCHEID | Z26859 | ENTSCHIEDEN (verbatim, Dauer-Regel) | approval-policy=never+sandbox=workspace-write |
| Neugruendung-A1-NB-Fixup-fertig-landebereit | REGRESSION | Z26861-26866 | BEHOBEN (62d8c715) | algo_version-Bump 26 Varianten |
| Reiche-Kontext-Uebergabe-geschrieben | AUFGABE | Z26868-26871 | DOKUMENTIERT | Wiederaufnahme-Anker |
| E18-SNAP-NB-A1-NB-landebereit-Codex-ausstehend | AUFGABE | Z26873-26876 | LANDEBEREIT wartend auf Codex | 1ae02cdf |
| Teil2-Uebernahme-fertig-Dual-Review-Split | REGRESSION | Z26878-26882 | NICHT LANDEN (Codex ueberstimmt Fable) | K2 SCHWER Mess-Resume nicht an Fingerprint |
| A1-NB-Zwei-Schreiber-Alarm-aufgeloest | REGRESSION | Z26884-26888 | BEHOBEN (kein echter Konflikt) | Fingerprint-Beweis VOR!=NACH |
| Scheibe6-Explore-Antwort-verbucht | AUFGABE | Z26890-26893 | BEANTWORTET (Weg b gebaut) | fixture_schema_subset_check.cmake |
| Abbruchsichere-Workflow-Sicherung-ehrlicher-Landestand | AUFGABE | Z26895-26898 | GESICHERT (4 nicht landefaehig bewusst) | keine Force-Landung Doktrin |

| Posten77-78-Doku-gelandet | REGRESSION | Z26902-26904 | BEHOBEN (Merge c837d830) | kReal-Suffix-Kollaps + XorFilter-FN |
| Owner-Entscheide-6er-Block-verbatim | OWNER-ENTSCHEID | Z26906-26915 | ENTSCHIEDEN (verbatim, 6 Entscheide) | E4/17 Deep-Research min/max, E14 NoFilter GO |
| B14-Codex-Nachbessern-A1-Codex-gestartet | REGRESSION | Z26916 | NACHBESSERN | N=2^17 nicht kodiert, Registry-Namen |
| Explore-Konsolidierung-3-vergessene-Kleinpunkte | AUFGABE | Z26918-26921 | GESTOPFT (3 Funde) | Gates-Spiegel-Auflage harte L1-Auflage |
| ce-CI-Rot-Infra-Verdacht-Retry | REGRESSION | Z26921 | OFFEN (Infra-Verdacht) | docs-only kann contract-Jobs nicht brechen |
| B14-NB-fertig-UML-Atlas-kopiert | REGRESSION | Z26923-26926 | BEHOBEN (d8073913) | golden-320-Aussage war stale |
| Owner-Frage-18-vs-17-Achsen-ergruendet | AUFGABE | Z26928-26932 | BEANTWORTET (Forensik) | 19->18->17 dann ORG-18 neu 18 |
| A1-Scheibe-gebaut-fable-landebereit | REGRESSION | Z26934-26936 | BEHOBEN (0b5ed557) | PoolResource OOM=nullptr-Vertrag |
| B14-KF6-gebaut-Review-Nachbessern-klein | FEATURE | Z26938-26940 | GEBAUT (2 Commits) | XSD-Erweiterung organ_subaxes |
| Owner-Frage-Kontinuitaets-Luecke-beantwortet | AUFGABE | Z26942-26945 | BEANTWORTET (JA, geschlossen) | Kontext-Kompaktierung+parallele Resume-Instanz |
| E18-SNAP-Codex-nachbessern-dritter-Fall | REGRESSION | Z26945 | NACHBESSERN | Retry verliert Snapshot dauerhaft |
| Owner-Ruege-main-FF-Ziel-verbatim | REGRESSION | Z26947-26951 | BEHOBEN (Regel verschaerft) | main-FF zielte auf Ledger-Spitze statt Paket-Merge |
| Honest-empty-gelandet-E2a-E2b-komplett | REGRESSION | Z26953-26956 | BEHOBEN (Merge 40bf8a66) | executed-Maske HeatmapData, 3D-Phantom getilgt |
| TODO-Konsolidierung-komplett-Register-committet | AUFGABE | Z26958-26961 | KOMPLETT | B-3 HOCH Lager-Gate G5 superseded ohne Nachfolger |

| E18-SNAP-Welle-komplett-Lead-Entscheide | AUFGABE | Z26965-26966 | GEBAUT (bda34e79, Fable landebereit) | ERNTE der ohnehin gebauten Thesis-PDF |
| Owner-Ein-Instanz-Regime-Alt-Worktree-Abbau | OWNER-ENTSCHEID | Z26968-26972 | ENTSCHIEDEN (verbatim) | 4 Alt-Worktrees entfernt |
| Owner-Volles-GO-Teil2-Uebernahme | OWNER-ENTSCHEID | Z26974-26978 | ENTSCHIEDEN (verbatim) | T2-D uebernehmen+fertigstellen |
| Owner-Entscheid-a-Diese-Linie-fuehrt-Teil2 | OWNER-ENTSCHEID | Z26980-26983 | ENTSCHIEDEN (verbatim) | Todes-Beweis-Doktrin angewandt |
| Codex-kippt-honest-empty-Nachbessern | REGRESSION | Z26985-26988 | NACHBESSERN | echte-0-Klassifikation ausgelassen |
| Owner-Klarstellungen-Teil2-Stopp-Zweite-Instanz | REGRESSION | Z26990-26994 | BEHOBEN (doktrin-konformer Stopp) | Doppelbelegung wt-b2 tabu |
| Honest-empty-fertig-fable-landebereit | REGRESSION | Z26996-26999 | BEHOBEN (ba5e48eb) | z_field_executed-Wache |
| Owner-Auftrag-TODO-Konsolidierung-14-Tage | OWNER-ENTSCHEID | Z27001-27005 | ENTSCHIEDEN (verbatim) | Welle todo-konsolidierung-14t |
| P2-P8-Katalog-geklaert | AUFGABE | Z27007-27011 | GEKLAERT | E1-E3 gedeckt, nur E9 offen-klein |
| Owner-Memories-andere-Session-gefunden | AUFGABE | Z27013-27016 | GEFUNDEN (keine Widersprueche) | Memory-Lage konsistent |
| Fahrplan-Synthese-bindend-E1E4-aufgeloest | AUFGABE | Z27018-27022 | AUFGELOEST (6/8 Pakete erledigt) | Kollisionsmatrix 16/21 disjunkt |
| Kanon-Klaerung-NB2-Dual-Review-Verdikt | REGRESSION | Z27024-27028 | BEHOBEN (harte Teil-2-Auflagen) | Tier-Treiber-Realversion nie gemessen |

| E1E4-Strang-GO-wieder-aufgenommen | OWNER-ENTSCHEID | Z27030-27034 | ENTSCHIEDEN (verbatim "Volles GO fuer den Parallel-Strang") | Welle e1e4-strang-ueberschneidungen: Ist-Abgleich + Ueberschneidungskarte |
| Max-Parallelisierung-ultracode-Design-Workflow-GO | OWNER-ENTSCHEID | Z27036-27040 | ENTSCHIEDEN (verbatim) | 3 Straenge: Fahrplan-Design, honest-empty-Bau-Vorzieher, NB-2-Dual-Review-Resume |
| Parallel-Session-Merge-Owner-Auftrag | OWNER-ENTSCHEID | Z27042-27046 | ENTSCHIEDEN (verbatim: neu gruenden + parallele Session finden + mergen) | Sessions-Merge aus 5 Dokus, B-Linie fuehrt |
| Session-4abae2c3-Prioritaets-Aenderungen-verloren | REGRESSION | Z27045 | OFFEN (Rueckfrage an Owner gestellt, nicht rekonstruierbar; P0-P4 gilt bis Antwort) | Task-Store-Verlust, Board neu #1-#5 |
| W5-W3-gelandet-Netzwechsel-Wiederaufnahme | REGRESSION | Z27048-27050 | BEHOBEN/GELANDET (ce dev==main==7969b399, Merge 124711ed, 3-Zyklen-Dual-Konvergenz, final KEINE BEFUNDE) | E-3-Schwelle 21:00 obsolet |
| NB-2-Bau-ueberlebte-Netzwechsel-Abriss | AUFGABE | Z27051-27053 | FORTGESETZT (resumeFromRunId, wt-b2@aa46c524, Review Fable+Codex neu gestartet) | Fallen uebernommen: kaltes Configure 2-Pass, EXCLUDE_FROM_ALL, .patcfg-Shred, Codex-Inline-Rezept |
| 4-Projekt-Remote-Sync-vollzogen | OWNER-ENTSCHEID | Z27055-27059 | ENTSCHIEDEN+ERLEDIGT (verbatim: gcc 15.3 Arbeits-Compiler, gcc16 neueste real) | alle 4 Projekte beide Remotes synchron; Toolchain-Realitaets-Kern keine Phantom g++-17/18 |
| Owner-Ruege-Berichts-Stil | OWNER-ENTSCHEID | Z27061-27065 | ENTSCHIEDEN (verbatim Ruege "zusammenhanglosen Mist" + Dauer-Regel) | Jeder Bericht beginnt mit Prioritaeten-Einordnung |
| E-2a-Planungswelle-fertig-honest-empty-Plan | FEATURE | Z27067-27070 | GEPLANT fertig, Bau geparkt als P4 | honest-empty 0.0000-Heatmap-Fix, 3 Aenderungsorte diagram_generator.cpp aggregate_surface_matrix+write_heatmap |
| Owner-Abnahme-P0-P4-Reihenfolge | OWNER-ENTSCHEID | Z27072-27074 | ENTSCHIEDEN (verbatim "nichts faellt weg, nur Verschiebung") | P0-P4 bindend |
| NB-Dual-Review-Nachbessern-CX-B1-B2-B3 | REGRESSION | Z27075-27077 | NACHBESSERN (3x KRITISCH ueberstimmt Fable-landebereit: Skip-Gate-Kollision, Realversions-Deckung fail-open, Preimage ungeprueft) | NB-2-Welle gestartet; mittel: bvset unescaped, stille Verwerfung, lazy_adhoc Leer-Werte; gering: static_assert Fremd-Toolchain |
| Neuanker-NB-Welle-fertig-CX-geheilt | REGRESSION | Z27079-27085 | BEHOBEN (CX-1..CX-4+FB-1 geheilt, Fable-Zweitreview LANDEBEREIT, Codex-Zweit-Lens frisch angestossen) | toolchain_stamp_glied Compiler-Real-Versions-Erhebung; Landung gated hinter W5/W3+Teil2/C-3 |
| Owner-Prioritaets-Kern-Binaries-vor-Darstellung | OWNER-ENTSCHEID | Z27087-27090 | ENTSCHIEDEN (verbatim: Binary+Messwert-Lager vor PDF-Auswertung) | Reihenfolge P0-P4 vorgeschlagen |
| Owner-Entscheide-E1-E5-GO-bis-Messung | OWNER-ENTSCHEID | Z27092-27099 | ENTSCHIEDEN (verbatim, 5 Entscheide + Gesamt-GO) | E-1 289-Branch+E18-SNAP, E-2 honest-empty jetzt+2D/3D SOTA, E-3 Schwelle 21:00, E-4 xlsx Erst-Format+Shortcut-Doktrin, E-5 Posten92 vor Abgabe; autonom bis Phase6 USER-GO-STOPP |
| E-18-Infra-Gate-geschlossen-289-Token | AUFGABE | Z27101-27109 | ERLEDIGT (ce-CI gruen, ce main-FF, Token id=95 angelegt, CI-Vars gesetzt) | Least-Privilege 289-Token comdare-thesis-writeback-e18; OFFEN R2-Ziel-Branch-Frage + B-5-Lebend-Check |
| E-18-Landung-beidseitig-super-main-FF | REGRESSION | Z27110-27117 | BEHOBEN/GELANDET (super main-FF b6d1a736, ce E-18-docs FF 253bcd86, super-Patch 347684cb+8131a9a2, INERT-Beweis Pipeline 14756) | Fallen: find bfs -newermt nur ISO-Timestamps |
| Owner-Dauer-Regel-Compact-Neugruendung | OWNER-ENTSCHEID | Z27118-27121 | ENTSCHIEDEN (verbatim: nach jedem Compact neu gruenden + Session-Log vollstaendig nachvollziehen) | Wiederanlauf-Doktrin verschaerft |
| Owner-Pruef-Auftrag-letzte-5-Workflows | AUFGABE | Z27122-27127 | VOLLZOGEN (Abgleich 5 eigene Wellen alle verbucht) | Neu-Fund Bau-Session W5/W3 nach 3 Codex-Zyklen LANDEBEREIT @ff6560b9 Gate 408, ungelandet |
| E-18-NB-fertig-Codex-Spend-Limit-Ausfall | REGRESSION | Z27129-27133 | BEHOBEN/LANDEBEREIT (4 Befundsklassen behoben, Fable-Zweitreview bestaetigt; Codex-Zweitreview AUSFALL spend-limit, Ersatzklausel A3) | E-18 landebereit, ce-docs+super-Patch |
| Neuanker-Teil1-gebaut-Dual-Review-Nachbessern | REGRESSION | Z27135-27139 | NACHBESSERN (Codex CX-1 Blocker+CX-2/3/4 + Fable FB-1 Vakuum-Pfad-Beweis) | Struktur fertig (Format3,Glieder,Wachen,Frozen), Substanz-Befuellung fehlt; KEINE Landung |
| B1-E18-gebaut-bewiesen-Dual-Review-mixed | REGRESSION | Z27141-27149 | TEIL/NACHBESSERN (Fable LANDEBEREIT, Codex NACHBESSERN 2 MAJOR+2 MINOR) | E-18 Kern super+289-Paket, ce=NULL Code; Nachbesserungswelle wf_726f7f45 |
| Posten93-honest-empty-Diagram-Generator | FEATURE | Z27149 | OFFEN neu HOCH | honest-empty im Flaechen-Writer Stufe-05 diagram_generator, keine Heatmap ohne Datenpunkte |

| A4-KF6-Design-Input-SOTA | FEATURE | Z27151-27154 | GEPLANT bindend (Design-Input ins KF-6-Fenster) | CT-NTTP line_size + CEB-RT-Wahl; 2 neue Literal-Funde abi_adapter:462, axis_05_memory_layout kCacheLine=64 |
| A5-Filter-Design-Input-T16-Korrektur | REGRESSION | Z27155 | BEHOBEN (T-ids-Falle korrigiert: Filter-Achse=T16 statt T14) | Value-Filter 4 Optionen offen fuer Owner-Entscheid nach Abgabe |
| Owner-Entscheide-V5-Vorlage-A1-A9 | OWNER-ENTSCHEID | Z27157-27161 | ENTSCHIEDEN (verbatim, 9 Entscheide A1-A9) | A1 Zaehler-Resume-Batch-Plan, A4 KF-6-Kernfeature+DeepResearch, A5 Sortierung=Key-Filter+MAP Key/Value-Filter-Achse, A7 GOLDEN-XML neuer Vor-Trigger-Posten B14, A9 VOLLZOGEN /tmp/comdare_test_1001 geloescht 170M |
| Platte-voll-Zwischenfall-Neuanker-Worktree | REGRESSION | Z27163-27167 | BEHOBEN (doktrin-konform: 60G frei, all19_pilot.csv gerettet, 9 Worktrees beweisbar abgebaut) | Neuanker Teil1 gestartet danach |
| Neuanker-SOLL-8-Glieder-Preimage-Format3 | FEATURE | Z27169-27173 | GEPLANT fertig, BAU GESTARTET (STOP-vor-C3-Gate) | Toolchain-Glied[5]+bvset-Glied[6], Buendel-Plan C-0..C-4, owner_offen LEER |
| B13-ETA-Plan-fertig-headless-definiert | FEATURE | Z27175-27179 | GEPLANT fertig, BAU GATED auf W5/W3-Landung | headless-Definition kanonisch, 6 Ueberlappungsstellen belegt |
| Owner-Dauer-Regel-Explore-Sonnet5-max | OWNER-ENTSCHEID | Z27181-27184 | ENTSCHIEDEN (verbatim) | Explore-Lenses ab naechster Welle Sonnet5+max+very thorough |
| Owner-Entscheide-6-B-Checklisten-F1-F6 | OWNER-ENTSCHEID | Z27186-27191 | ENTSCHIEDEN (verbatim, 6 Entscheide) | O-2=Option A Achsen-Vollstaendigkeits-Neuanker, B12 xlsx in Abgabe, B6 Variante a, B13 vorgezogen+headless, Kollisionsregel=Substanz gewinnt weiterbauen, Session in Bau-Rolle eigene Worktrees |
| Liegengebliebenen-Sweep-B1-B13-Checkliste | AUFGABE | Z27193-27201 | FERTIG (very thorough, konsolidierte VOR-TRIGGER-CHECKLISTE bindend fuer P3) | B1 E-18 HAUPT-ZIEL, B2-B13 Vor-Trigger-Pflichten inkl. B12 xlsx-Default-Writer, B13 L18-ETA; + Vor-Abgabe-Klaerungen A14/A15; 8 unverbucht-erledigt; 19 geparkt |
| Rollen-Deklaration-Besitz-Register-bestaetigt | AUFGABE | Z27202-27207 | ENTSCHIEDEN/VOLLZOGEN | Audit-Session read-only, Bau-Session Landungshoheit; Dual-Review-Welle gestoppt obsolet; ZWEI abend-2-Nachtraege dokumentierte Kollision |
| Session-Koordination-Sachstand-Korrektur-Worktree-Besitz | REGRESSION | Z27209-27213 | BEHOBEN (stale Reconcile 01b6f48c korrigiert) | Worktree-/Branch-Besitz bindend fuer alle Sessions festgelegt |
| Sammel-Backup-26-Workflows-Bau-Session | AUFGABE | Z27215-27219 | ERLEDIGT (Owner-Auftrag vollzogen, 0 Secret-Treffer) | docs/sessions/backups/20260806-SESSION-workflows-46375cdc-b15ade0e/; W5/W3-Landung = dasselbe Ereignis wie Z27048 (Session-Label-Kollision frueh-2, dedupliziert) |
| A-7-Peak-Spalte-falsch-etikettiert-ENTKRAEFTET | REGRESSION | Z27225-27226 | GESTRICHEN/ENTKRAEFTET (Urgency-Praemisse falsch, nur 1 nicht-produktiver CLI-Aufrufer f15_compare, 0 CI-Treffer) | measurement_snapshot.hpp:124, Owner-Entscheid A8-S3 04.08. deckt Parallel-WIDE-Schema |
| A-8-Literal64-ueberlebt-B14-ENTKRAEFTET | REGRESSION | Z27228-27234 | GESTRICHEN/ENTKRAEFTET (4 Stellen bereits erledigt oder falsch zugeordnet, Gegenprobe 0 weitere Funde) | system_axis.hpp:325 c1c76c87, node_width_config.hpp:54 0b5ed557, measure.hpp:38 toter Testcode, axis_05:60 kein Fehler |
| Regel-Zeile-17-Befund-Erhebungsdatum | OWNER-ENTSCHEID | Z27236-27242 | ENTSCHIEDEN (neue Dauer-Regel aus Anlassfall) | Befund gegen heutigen HEAD nachmessen vor Handlung, git log -1 Pflicht |
| F-01-Talos-zwei-OS-Regime-Rollentrennung | REGRESSION | Z27248-27250,Z27482-27486,Z28219-28229 | BEHOBEN (thesis eaf7fe8: 3 Stellen je Sprache Praesens Passiv->Sollform+Vollzugsstand, ADR-12 eigenes Feld; Lehre: Umklassifizierung ersetzt nicht die verordnete Massnahme) | chktex 0 Warnings DE 204/EN 194 S. |
| B-2-sechs-Messkette-Fragen-vier-beantwortet | AUFGABE | Z27252-27254 | TEIL (4/6 F1,F3,F5,F6 dokumentiert beantwortet; F4 kein Owner-verbatim + F2/F5-Restentscheid offen) | best_binary_selector nur Auswahl+Vergleich, Rueckschreiben DEFERRED #156 |
| B-3-Core-Achse-non-kongruent | REGRESSION | Z27256-27258 | OFFEN (Owner-Entscheid noetig) | HeteroCoreDispatch Code None vs Dossier Unpinned Namens-Diskrepanz, 5-Modus vs 4-Werte |
| B-4-Bau-Menge-vier-Kandidaten | AUFGABE | Z27260 | OFFEN (4 Kandidaten statt 3: 131072/524288/1572864/2097152) | COMDARE_GN_TOTAL x System-Perms, run_options cap ist No-op |
| B-5-O4-F7-B6-Anhang-A-Reichweite | AUFGABE | Z27262-27264 | OFFEN (Anhang A 16/44 Fragmente belegt, keine Owner-Freigabe; Termin 15.09. widerlegt NACH-Abgabe-Praemisse) | F7 GRUNDSATZ ENTSCHIEDEN Option b Versionierungs-Interface; B-6 nur O-5 entschieden Rest offen |
| Selbst-Audit-Opus48-Verdikt-nicht-vollstaendig | REGRESSION | Z27266-27269 | OFFEN dokumentiert (30% Anker-Fehlerquote 6/20; 2 Owner-Kerne abgeschnitten+2 Nachrichten fehlten) | Gesamt-Verdikt NICHT VOLLSTAENDIG, ersetzt keine frische Owner-Ruecklesung |

| R-3-Mess-Defines-nicht-im-Fingerprint | REGRESSION | Z27274-27276,Z27397 | BEHOBEN/GELANDET (ce 85847715 dev==main, Pipeline 15167 gruen 19+1, Bissbeweis durch Ausfuehrung) | COMDARE_MEASUREMENT_ON ABI-wirksam ohne Fingerprint-Preimage |
| SW-5-E14-active_telemetry_is_silent-konstant-false | REGRESSION | Z27277 | OFFEN golden-beruehrend, kein Defekt | 10+ profile.xml deklarieren silent=true, Wiring wuerde golden-Byte-Identitaet brechen |
| D-1-PMU-Domaene-Owner-Total-Falsch-Gedaechtnisluecke | OWNER-ENTSCHEID | Z27289-27327 | ENTSCHIEDEN (verbatim "TOTAL FALSCH", Lead-Gedaechtnisluecke) | core_class RT-Unter-Achse GEBAUT aa223961; Mess-Zeile stempel-pflichtig, Binary-Identitaet COMPILE-HART GESPERRT kSystemCellValueForbiddenKeys |
| Tag-cpe-neu-dann-UEBERHOLT | REGRESSION | Z27319-27326 | GESTRICHEN/UEBERHOLT (Korrektur 07.08. abend G-7: cpe-Form existiert nicht mehr, Flag-Grammatik v2 komplett neu definiert) | massgeblich docs/plaene/20260807-DESIGN-flag-grammatik-v2-punkt-notation-komposit.md |
| B-4-Break-Even-kein-Lager-Objekt-korrigiert | OWNER-ENTSCHEID | Z27330-27335 | ENTSCHIEDEN (verbatim, Lead-Empfehlung war falsch: "Verwerfen IST FALSCH") | Break-even nur CEB RAM nach Messungsschluss, Voll-Build |
| D-3-Bau-Menge-folgt-Mess-Menge | OWNER-ENTSCHEID | Z27336-27337 | ENTSCHIEDEN (verbatim) | nur 320er die gemessen werden, golden-XML umgestellt |
| O-C-Pinning-Pflicht-Hybrid | OWNER-ENTSCHEID | Z27338-27339 | ENTSCHIEDEN (verbatim) | Pinning Pflicht bei Hybrid-Architekturen mit unterschiedlichen Kernen |
| Plattform-Rolle-ZIH-Erweiterung | OWNER-ENTSCHEID | Z27340-27341 | ENTSCHIEDEN | prod1/prod2 lokaler Pilot, ZIH-Erweiterung trotzdem vollzogen |
| Modi-Staffelung-kumulativ-korrigiert | OWNER-ENTSCHEID | Z27342-27350 | ENTSCHIEDEN (Lead-Fehldeutung korrigiert, verbatim) | measure subset compare subset release kumulativ, single_thread-Spalte missverstaendlich |
| O-4-Volles-GO-Diplomarbeit-Audit-gegen-Diff | OWNER-ENTSCHEID | Z27351-27354 | ENTSCHIEDEN (verbatim) | Text an Code nachziehen nur fuer belegt veraltete Stellen, sonst CODE_RUECKSTAND |
| xlsx-Standard-fuer-Messung-Writer-fehlt | REGRESSION | Z27355-27357 | OFFEN (Owner: Standard fuer Messung ist xlsx; Writer EXISTIERT NICHT 0 Treffer) | Gegenprobe csv=103, 3 xlsx-Fundstellen nur Kommentare |
| O-4-Zahlenbasis-korrigiert-Separat-Klon-veraltet | REGRESSION | Z27359-27368 | BEHOBEN (beide Plandokumente massen gegen veralteten Separat-Klon 20260931-overleaf@29a1700 statt Submodul@19e1592) | richtig: 31 gegatete InputIfFileExists, 18 harte input, 18 real existierend; FALLEN neu: immer gegen Submodul messen |
| Methoden-Lehre-Negativsuche-Vokabular | OWNER-ENTSCHEID | Z27372-27377 | ENTSCHIEDEN (neue Dauer-Regel) | Synonym-Durchgang + Klassifikation Roh-Treffer Pflicht vor "existiert nicht"-Aussage; Belege T-10/D-1/cpe |

| Owner-Auftrag-Vollkonsolidierung-nie-Faden-verlieren | OWNER-ENTSCHEID | Z27381-27390 | ENTSCHIEDEN (verbatim) | Meta-Referenzen-Register 155 Dateien/337 Zeilen-Referenzen docs/sessions/20260807-META-REFERENZEN-register.md |
| O-4-Thesis-Textnachzug-EN-gelandet | AUFGABE | Z27398 | ERLEDIGT (thesis 8197a2c dev==main, Pipeline 15172 gruen 4/4, PDF DE 204 S.) | O-4 Volles-GO Diplomarbeit-Audit |
| Gitlink-Bump-super-gelandet | AUFGABE | Z27399-27400 | ERLEDIGT (super 5ed70229, Pipeline 15174) | ce + beide Thesis-Zeiger |
| Compare-Sequenzierung-vor-oder-nach-Release-offene-Spannung | REGRESSION | Z27440-27446,Z27619-27632 | BEHOBEN/ENTSCHIEDEN (O-A verbatim: geltende Ordnung measure->compare->release kumulativ; SUPERSEDED LEDGER:3343 Sec62-C) | compare eigene Optionen + lesender Lager-Zugriff, release produziert optimale Binary |
| RunMethodology-vier-Werte-XML-Pflicht-Verwechslungswarnung | AUFGABE | Z27448-27460 | GEBAUT/DOKUMENTIERT (XSD exactly-one; OS-Support-Build-Frage strukturell beantwortet) | 3 weitere namensgleiche Modi-Vokabulare (Builder-Betriebsmodi, Pruefling-Mess-Schema-Modi, --mode=defined/full/full-sampled) |
| Plattform-Matrix-Windows-macOS-RiscV-Pi5-Debug-only | FEATURE | Z27462-27474 | GEPLANT/TEIL (Docker voll bare-metal+Talos; Windows 4 VMs 3 brauchen Auth-Reset; macOS/RISC-V/Pi5 nur DEBUG-Modus) | Pilot prod1+prod2 zuerst vollstaendig, Rest nach Abgabe |
| Diskrepanz-7-vs-8-Distributionen | REGRESSION | Z27475-27480,Z27651-27660 | BEHOBEN/ENTSCHIEDEN (O-C verbatim: 21 Images = 7 OS Cluster-Registry x 3 neueste Versionen; Gate W10-00 beantwortet) | debian-sid/ubuntu-2404/fedora-42/alpine-321/archlinux/opensuse-tw/rocky-9 x3 |

| F-02-flat_hash_map-Gattung-MAP-nicht-Container | OWNER-ENTSCHEID | Z27488-27494 | ENTSCHIEDEN (Textpass Option a) | SwissTable Genus SearchAlgorithm->Gattung MAP, Substitutions-Prinzip vendor->faithful->self |
| Thesis-Sprachrichtung-DE-fuehrt-EN-Nachzug | OWNER-ENTSCHEID | Z27505-27508 | ENTSCHIEDEN (verbatim, Dauer-Regel) | DE fuehrt immer, EN nachziehen, Konsistenz pruefen |
| Rollen-Lead-CTO-Fable-nie-Director | OWNER-ENTSCHEID | Z27509-27510 | ENTSCHIEDEN | Lead=CTO/Director, Fable-5=Agenten-Modell Planung/Design/Review/Synthese, Explore=Sonnet-5-max |
| T-8-Beste-Binary-Pareto-Front-nicht-umgesetzt | REGRESSION | Z27513-27514,Z28185-28197 | BEHOBEN/GELANDET (Welle C ce 21560a2e; SCHWERSTER FUND: Selektor lieferte DOMINIERTE Binary aus, bin_tie_loser wurde versandt trotz Dominanz von bin_true, Auslieferungspfad betroffen) | Paritaets-Gate Spiegel+static_assert gegen echten T-9-Katalog |
| T-9-MinMax-Katalog-existiert-nicht-konsumiert | REGRESSION | Z27515-27518,Z28055-28071 | BEHOBEN/GELANDET (ce 875a57cd: axis_optimization_catalog.hpp 436Z constexpr, 19 Achsen/45 Zielgroessen, 3 Bissbeweise literal, 417/417) | break_even.hpp v1->v2 OptimizationDirection NTTP |
| T-10-Last-Erkennungsheuristik-Falschbefund-korrigiert | REGRESSION | Z27519-27524 | GESTRICHEN/UEBERHOLT (Befund "0 Code 0 Design 0 Register" war FALSCH, 327-zeiliger Deep-Research-Befund 09.07. existiert) | OtterTune/QueryBot5000/Self-Driving-DBMS, Suchbegriffe verfehlten Plan-Terminologie |
| PMU-exklusive-Ressource-ohne-resource_group | REGRESSION | Z27527-27532,Z28184 | BEHOBEN (Welle E ce 0c80aa78: resource_group PMU host-scoped) | mehrtaegige Messung: parallele PMC-Nutzung verfaelscht nicht mehr still |
| Stiller-Ruckfall-auf-measure-bei-Tippfehler | REGRESSION | Z27533-27536,Z28183 | BEHOBEN (Welle B ce 0c08fa15: fail-closed Modus) | run_methodology_registry.hpp:137,140,144-151 |
| PlanBuildSemantic-measurement_on-Phantom-Feld | REGRESSION | Z27537-27538,Z28183 | BEHOBEN (Welle B ce 0c08fa15: Phantom angenagelt) | experiment_plan_director.hpp:115/1994 |
| macOS-Off-by-one-Maximalwert | REGRESSION | Z27539-27542,Z28183 | BEHOBEN (Welle B ce 0c08fa15) | numa_cpu_pin_process_probe_macos.hpp:98 vs korrekter Linux-Zwilling :168 |
| single_thread-kann-Owner-Semantik-nicht-ausdruecken | REGRESSION | Z27543-27547 | OFFEN HOCH (Mechanismus Paragraph58-REPLAY ohne GEBAUT-Vermerk) | run_methodology_registry.hpp:74-79, measure_parallelism.hpp:23-25 |
| DE-EN-Konsistenz-T15-T16-Tippfehler-behoben | REGRESSION | Z27550-27556 | BEHOBEN (2x HOCH, nur EN geaendert) | anhang/en/D_building_block_matrix.tex:588,642 T15->T13, T16->T14 |
| DE-EN-Konsistenz-2-Niedrig-Stil-nicht-geaendert | REGRESSION | Z27557-27559 | OFFEN NIEDRIG bewusst nicht geheilt (nur Stil) | kapitel/en/03_messsystem_prtart.tex:731,796 |
| T1-Fenster-Vor-4096er-Batch-Pflichten | AUFGABE | Z27565-27567 | OFFEN (vor erstem 4096er-Batch) | D-4 allow_failure am Voll-Mess-Batch, D-5 PMC fail-closed kPmcExpected, R-2 XML-Trennung+Slicing 4096, D-3-Umsetzung golden-XML auf 320er |
| Owner-Entscheide-die-bleiben-W3-B5-C4-C5-C6 | OWNER-ENTSCHEID | Z27573-27578 | OFFEN (mehrere ungeklaerte Punkte) | W-3 Akzeptanzkriterium Ebene2 widerspruechliche Owner-Aussagen 6min53s auseinander, B-5 Break-Even-Schwellen CT vs RT, C-4 H2 fehlende Durchsatz-Spalte, C-5 vier Lastprofil-XML, C-6 ChainRef bis 28.08., Anhang D drei-vs-vier Mess-Modi |

| Methoden-Lehren-Werkzeug-Fallen-3-bis-9 | REGRESSION | Z27591-27607 | BEHOBEN (7 Lektionen, Regeln verschaerft) | gefilterte tail-Ausgabe verschluckt Verdikt, find liefert leer meldet trotzdem sauber, gitleaks 0-commits-Falle, ASCII-Selbstcheck braucht LC_ALL=C, /jobs-API zeigt keine Bridges, Lint darf DE-Fuehrungstext nicht umformen |
| O-B-W3-Ebene2-strengere-Variante-Schritte-Checkpoints | OWNER-ENTSCHEID | Z27634-27649 | ENTSCHIEDEN (verbatim, loest KERN11-vs-KERN12-Widerspruch; ersetzt W-3-Teil von Z27573) | xlsx-Writer ist Traeger des MESS-PROFILS selbst, nicht nur Auswertungs-Ausgabe; Explore wf_acd866c1-fc8 laufend |
| O-E-Anhang-D-drei-zu-vier-Mess-Modi-Textnachzug | OWNER-ENTSCHEID | Z27662-27666 | ENTSCHIEDEN (verbatim; loest Anhang-D-Teil von Z27573) | vier RunMethodology {debug,measure,release,compare} als Enum+constexpr-Registry, Textnachzug DE fuehrend |
| O-F-cpe-ist-String-HW-Flag-Grammatik-Lead-Frage-falsch | OWNER-ENTSCHEID | Z27668-27687 | ENTSCHIEDEN (verbatim, Lead-Fehler korrigiert: cpe=Q3-HW-Flag-String am Versions-Stempel, nicht CSV-Token) | v1.0.0c-Format Hardware-Flag c/g/f/n + optional e; Explore wf_acd866c1-fc8 laufend fuer Parser/Wachen/Migration |

| Lehre-Falsch-gestellte-Frage-Subsystem-zuerst-pruefen | OWNER-ENTSCHEID | Z27688-27694 | ENTSCHIEDEN (neue Dauer-Regel) | bei Owner-Begriff zuerst Subsystem feststellen (Stempel/Achse/CSV/XML), dann fragen |
| O-F-Nachtrag-HW-Flags-gelten-fuer-Stempel-und-Mess-Ausgabe | OWNER-ENTSCHEID | Z27695-27719 | ENTSCHIEDEN (verbatim, loest scheinbaren Widerspruch) | 3 Bau-Glieder: Stempel-Grammatik->String, Freigabe-Kette System-Achse, Mess-Ausgabe xlsx+CSV; cpe=Faehigkeit CT vs core_class=Laufzeit-Tatsache RT |
| O-F-cpe-kollidiert-mit-experimental-e-Grammatik-Konflikt | REGRESSION | Z27720-27761 | OFFEN kritisch (Grammatik kann nicht beides: 'e' Suffix UND Flag-Buchstabe gleichzeitig) | algo_semver.hpp IST-Grammatik HWFLAG=1 char; v1.0.0cpe wird HEUTE ABGELEHNT (Bissbeweis); 5+ betroffene Wachen; Explore wf_acd866c1-fc8 sucht Antwort im Session-Log |
| Explore-Ernte-Benchmark-Zuordnung-O-B-beantwortet | AUFGABE | Z27767-27786 | BEANTWORTET (E1/E2/E3-Tabelle, 18-Zeilen-Messvertrag T0-T17) | E3 aggregiert E2, alle 3 Ebenen erben Dreistufigkeit Planer-RT->CEB-CT->Tier-CT |

| Profil-zu-xlsx-Bruecke-echt-offen | REGRESSION | Z27795-27804 | OFFEN (Owner-Entscheid noetig, NEUE Festlegung noetig) | a9-xlsx ist Zeile-pro-Messergebnis kein Zeitreihen-Traeger keine Chart-Objekte; fill_checkpoints sind Fuellstands- nicht Ausfuehrungs-Checkpoints |
| cpe-ist-NICHT-geplant-Owner-Annahme-widerlegt-neue-Grammatik | REGRESSION | Z27806-27845,Z28233-28285 | PRAEZISIERT (OWNER-KERN nachmittags loest die 3 vorgelegten Fragen: Punkt-Notation, Komposit-Flags {x512.f.vl.bw.dq}, 'e'=EFFICIENCY CORE statt experimental; Lead-Bestaetigung AUSSTEHEND, Umsetzung 6 harte Bruchstellen offen) | 138 Bestands-Literale einbuchstabig; B12-Wache "ce-Registry traegt NIE e" jetzt sinnwidrig |
| V-08-branch_misses-Entlastung-korrigiert-zwei-drittel-richtig | REGRESSION | Z27847-27927 | TEIL BEHOBEN (korrigierte Bilanz: 2/3 richtig, L1+L3 real via perf_event_open, nur branch_misses honest-0; Lead hatte selbst zweimal falsch behauptet, Entlastung dann Alarm; 1 Restfehler CMakeLists.txt:5338 BEHOBEN) | offener Posten M-3a bereits im Code gefuehrt |
| V-03-19er-Zaehlung-teilweise-26-in-eingebundenen-Dateien | REGRESSION | Z27944-27957 | TEIL (Kurzformel "nur un-included" woertlich falsch: 26/92 in eingebundenen Dateien inkl. 2 Anhaenge; Sachaussage "kein Abgabe-Defekt" haelt, alle historisch markiert) | Nebenbefund 06_evaluation_methodology.tex fehlender Deprecation-Kopf GESETZT |
| V-05-Stub-Quarantaene-WIDERLEGT | REGRESSION | Z27959-27985,Z28012-28024 | BEHOBEN (Task#37/W4 GEBAUT ce 2f9c6abc: Gate wirft statt Stub, Test umgedreht, Bissbeweis+421/421 ctest gruen) | kQuarantinedPrtArtProfileId; #162-Zaehlbeleg pruefen |
| Ledger-Audit-43-von-43-nicht-sauber-erfasst | REGRESSION | Z27871-27880 | OFFEN (Wurzel-Fund: A15/Sec55-Gesamt-Reconcile nie vollzogen, B-Liste mitgenommen A-Liste nicht) | A14/FF0 Multi-Plattform Abgabe-Blocker unbearbeitet, GN-9 Feasibility-Gate kein Slot; Volle Liste tmp/wisfvjd8z.output |

| Reconcile-Pass-Bilanz-keine-Entlastung-unveraendert-haltbar | REGRESSION | Z27987-27990 | OFFEN (Lehre: eine Entlastung ist eine Behauptung, uebrige 17 Positionen desselben Passes verdaechtig) | V-08 2/3 richtig, V-03 Formel falsch Sache haltbar, V-05 Kern widerlegt |
| O-A-im-Code-nachgezogen-Enum-Reihenfolge-bewusst-belassen | AUFGABE | Z27996-28010 | ERLEDIGT (ce 491fff65, Pipeline 15189 gruen, 4 Code-Stellen korrigiert mit SUPERSEDED-Vermerk) | 2 Bau-Konsequenzen offen Paket D2 ungebaut: compare eigene Optionen, release optimale Binary |
| Falsches-Rot-stale-Generator-Binary-Fallen-Register | REGRESSION | Z28026-28042 | BEHOBEN (Fehlbefund vermieden durch Wegstashen+Neumessen; nach erzwungenem Neubau 421/421 gruen) | GEGENMITTEL bindend: Generator-Alter gegen Quellen pruefen vor Code-Verdacht |
| Owner-Direktive-Wellenplan-strikt-parallel-temporaere-Branches | OWNER-ENTSCHEID | Z28048-28050 | ENTSCHIEDEN (Modus-Wechsel: temporaere Branches je Welle, merge+loeschen bei Erfolg) | ultracode-Doppel-Audit Fable5-xhigh+Codex wf_355205a7 ueber letzte 3 Kontexte |
| Kein-Datum-Uhrzeit-im-Fingerprint-beantwortet | AUFGABE | Z28051-28053 | BEANTWORTET (consteval, Uhr=Compile-Fehler, alle 9 Glieder zeitfrei) | experiment_substitute_date fliesst nur in cout-Logzeile |
| Lead-Vorerhebung-13MAX-19MIN-falsch-korrigiert-17MAX-32MIN | REGRESSION | Z28073-28078 | BEHOBEN (Suchmuster **MAX** verfehlte inline-Nennungen ohne Bold) | korrekt 17 MAX/28 MIN/45 als Zielgroessen operationalisiert |
| T19-persistence_target-keine-Katalog-Zeile | FEATURE | Z28080-28085 | OFFEN (Owner-Entscheid noetig, Welle A hat keine Richtung geraten, honest-empty) | consteval-Anker bricht bei kuenftiger Verschiebung |

| Explore-Ungelesene-Workflows-34-ohne-Ergebnis | AUFGABE | Z28093-28101 | TEIL (100 wf-Verzeichnisse, 90/100 zitiert, 34 ohne Ergebnis; wf_90b95e92 selbst zur Haelfte gestorben Spend-Limit) | Arbeit von 4/8 Lenses nicht rekonstruierbar |
| Generator-dreht-Thesis-Korrektur-zurueck-falsche-Aussage | REGRESSION | Z28103-28125 | OFFEN KRITISCH (naechster Generatorlauf ersetzt richtige Aussage durch falsche, Verfallsdatum niemand notiert) | csv_to_latex.cpp:985-986 in super; ZU TUN nicht gebaut Owner-Pause |
| Sechs-STOPP-Gate-Entscheide-E-A-E-F-blockieren-F7b | OWNER-ENTSCHEID | Z28127-28136 | OFFEN (0 echte Treffer in Ledger/Dossier/Owner-Vorlagen, blockiert Owner-KERN F7=b vollstaendig) | Hex-Laenge Stempel-Name, Name im Symbol, Provenienz-Sidecars, Ordner/CSV, Overlay-Glied, Planer-Stufe; Lead-Empfehlungen b/ii/b/a/b/a |
| Drei-stale-Ledger-Anker-Zeilendrift | REGRESSION | Z28137-28143 | OFFEN KLEIN (40 Zeilen Drift + Off-by-one, Substanz R-3 unberuehrt) | LEDGER:5328 vs real :1373, DOSSIER:1302 Selbstwiderspruch, LEDGER:7282 "8 Treffer" real 7 |
| RAPL-root-only-ungeprueft-als-Tatsache | REGRESSION | Z28145-28151 | OFFEN MITTEL (Ursprungsbericht sagt UNGEPRUEFT, Dossier fuehrt es als Tatsache; 20% Intel-Laeufe SMOKE_SKIP) | Vorschlag RAPL-Probe an bare_metal.before_script |
| 79-von-220-CMake-Ziele-tot-nicht-in-Kandidatenliste | REGRESSION | Z28153-28157 | OFFEN KLEIN | COMDARE_VARIANT_GATE fehlt ebenfalls in Aufraeumpass-Liste |
| Zwei-Workflow-Empfehlungen-falsch-nicht-ausgefuehrt | REGRESSION | Z28159-28164 | GESTRICHEN/UEBERHOLT (E18-SNAP 5c4cf900 NICHT-LANDEN-Verdikt steht; Gate-8 8970465d laengst Vorfahr) | 2/7 Empfehlungen falsch, Lehre: auch Fund-Bericht ist Behauptung |
| 7-unreferenzierte-Alt-Workflows-entlastet-kein-Verlust | AUFGABE | Z28166-28171 | ENTLASTET (Ergebnisse als Commits materialisiert) | 0b5ed557,838612f3,bda34e79,d8073913 |

| Wellenplan-5-Wellen-gelandet | AUFGABE | Z28177-28186 | ERLEDIGT (5 Wellen, je eigener temp. Branch, Bissbeweis, Branch geloescht nach Merge) | A T-9 875a57cd, B fail-closed+macOS+Phantom 0c08fa15, E resource_group 0c80aa78, C T-8 Pareto 21560a2e, D T-10 Workload-Cluster offline a1d0c201 |
| Welle-D-Spend-Limit-Rettung-worktree-force-Warnung | REGRESSION | Z28199-28217 | BEHOBEN (gerettete erste Fassung NICHT uebersetzbar bestaetigt; 2. Anlauf uebernommen+gehaertet, 3 Commits) | LEHRE Fallen-Register: vor worktree remove --force ungetrackte Dateien sichern; k-Wahl-Luecke geschlossen Sweep+Silhouette/Elbow nie erzwungen |
| Owner-Kern-Flag-Grammatik-neu-Punkt-Notation-Komposit-e-efficiency | OWNER-ENTSCHEID | Z28233-28271 | ENTSCHIEDEN (verbatim, 2 Schritte; Lead-Auslegung Bestaetigung AUSSTEHEND) | achse@X.Y.Z.<flag>.<flag>.{<komposit>...}; Trenner '.'; e=EFFICIENCY CORE (experimental DEPRECATED); p=performance core |
| Flag-Grammatik-Bruchstellen-6-hart | REGRESSION | Z28273-28285 | OFFEN (6 harte Bruchstellen durch Grammatik-Neudefinition, Umsetzung aussteht) | Kardinalitaet 1->n, e-Bedeutung geaendert, Trenner kollidiert mit SemVer-Punkt, Komposit-Klammern neue Syntax-Ebene, POD nur 2+1 Bit |

<!-- SEGMENT 23001-27600 VOLLSTAENDIG GELESEN (mit Ueberschuss bis Z28285, siehe Auffaelligkeiten im Return). KEIN weiterer Lesebedarf fuer dieses Segment. -->
