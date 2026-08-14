# LESER 9 von 12 -- Extraktion (Batch: i % 12 == 8, 0-basiert)

BATCH-DATEILISTE (Index / Name / Bytes):
- 8   w76o2kmbd.json  216679
- 20  wdtdyqbmh.json  131370
- 32  wu5ujw3xn.json  94163
- 44  wbpblbrwp.json  75935
- 56  w18xiad7j.json  58939
- 68  wdz7tb4cm.json  42609
- 80  wr7tt88v0.json  32752
- 92  wa3azpzk6.json  28115
- 104 whrh78rq1.json  20393
- 116 wqjxtc4jv.json  13692
- 128 wsb78kl70.json  9715
- 140 wqxpvgwwt.json  7142

HINWEIS ZUR QUELLE w76o2kmbd.json: Deep-Research-Workflow vom 06.08. (5 Scopes + Konsolidierung,
6 Agenten, 1.526.225 Tokens). Stand der Erhebung: super `72eab9ae` / ce `47c4ef1d`; die
Konsolidierung selbst korrigiert auf super `46824fba` / ce `b241a272`. Vieles kann seit 13.08.
ueberholt sein -- Abgleich macht der Designer.

## Datei 1: w76o2kmbd.json (Deep-Research Owner-Antworten 06.08., 5 Scopes + Konsolidierung)

### [w76o2kmbd.json] 1
GEGENSTAND: Batch-Einheit ist die BINARY (nicht GitLab-Job): 1 BuildJob = 1 Tier-Binary, kGnBatchSlice=4096 Scheiben-Groesse; GitLab-Jobs O(Maschinen)=4.
ORT: ce build_orchestrator.hpp:125-131,:167,:728; experiment_plan_director.hpp:610,:1238-1256; Ledger:3320/:3324/:3414/:3415
SOLL/FIX: Lesart A (4096 Binaries je Batch) als einzige plan+code-konforme Lesart bestaetigen; Lesart B (4096 GitLab-Jobs) widersprich Par.62-B.
STATUS LT. QUELLE: nur-hinweis (Klaerung durch Owner R-1/E-4 in Konsolidierung als ENTSCHIEDEN "Binary" gefuehrt)
ABHAENGIGKEIT/FLAECHE: Owner-Frage R-1 (Scope 3), E-4 (Konsolidierung)

### [w76o2kmbd.json] 2
GEGENSTAND: Realer Bau-Umfang = 524.288 Tier-Binaries (4 System-Perms x 131.072), NICHT 131.072 (Fenster je Perm) und NICHT 2.097.152 (line_size-Faktor inert).
ORT: super/.gitlab-ci.yml:79 (COMDARE_GN_TOTAL=131072); experiment_plan_director.hpp:989-990; experiment_golden_kern.xml:285; 05_evaluation.tex:94-101
SOLL/FIX: 524.288 als Abgabe-Menge festschreiben; XML-Kommentar :285 korrigieren; per B-1/T-0(a) ZAEHLEN statt addieren; Wache test_bau_mengen_invariante neben golden_n_consistency_check.cmake.
STATUS LT. QUELLE: offen (Zahl gerechnet, nicht gemessen -- Trockenlauf T-0(a) muss bestaetigen)
ABHAENGIGKEIT/FLAECHE: R-T1; Owner-Fragen R-2 (Scope 3), R-5 (Scope 1), R-4 (Konsolidierung)

### [w76o2kmbd.json] 3
GEGENSTAND: "Kappung auf 131.072" existiert NICHT: cap im comdare_experiment-Dialekt ungeparst, im thesis-Dialekt wirkungslos (min(cap,basis)=131072).
ORT: xml_config_parser.cpp:425-432 vs :444-570; profile_runner.hpp:163-169; experiment_golden_kern.xml:246
SOLL/FIX: Fehlbeschreibung "gekappt auf 131.072" aus Plandokumenten tilgen; cap-Kanal entweder im experiment-Parser lesen oder irrefuehrenden Kommentar korrigieren (Teil von M-8/B-6).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-3 (Scope 1); O-A-Entscheid stand auf dieser Fiktion

### [w76o2kmbd.json] 4
GEGENSTAND: XML kann Bau und Messung heute NICHT getrennt definieren -- Trennung existiert nur als Env-Schalter (COMDARE_GOLDEN_N_RANGE/PROVISION_ONLY) + hartkodierte Emitter-Asymmetrie; Owner nennt Fehlen selbst "Regression".
ORT: experiment_schema.xsd:24-130 (kein Kanal); xml_config_parser.hpp:246ff (ThesisProfile ohne build/measure-Feld); experiment_plan_director.hpp:1238-1256 (Bau) vs :1366-1369 (Mess)
SOLL/FIX: B-2 (Scope 1): <measure_axes> + <measure_options cap> additiv, minOccurs=0, Abwesend=Mess=Bau byte-identisch; HARTE fail-closed Teilmengen-Wache (jede binary_id aus mess_view MUSS in basis_view sein); Emitter :1366-1369 liest Mess-Menge. Alternative Form B-4 (Scope 2): scope="build|measure|both"-Attribut. Konsolidierung: <measure_selection> UEBER der Bau-Menge (Variante 1).
STATUS LT. QUELLE: offen (Owner-Pflicht "sonst regression")
ABHAENGIGKEIT/FLAECHE: B-D im ce-Buendel L-1; Owner-Fragen R-1 (Scope 1), R-2 (Konsolidierung)

### [w76o2kmbd.json] 5
GEGENSTAND: Mess-Batch hat KEIN 4096er-Batching -- Bau slict korrekt, Mess faehrt volles Fenster 0:COMDARE_GN_TOTAL in EINEM Treiber-Aufruf je Perm; Wiederaufnahme hat auf der Mess-Seite kein Korn.
ORT: experiment_plan_director.hpp:1366-1369 (verbatim: 'export COMDARE_GOLDEN_N_RANGE="0:${COMDARE_GN_TOTAL:-16}"  # volles Zell-Fenster')
SOLL/FIX: B-3 (Scope 1): dieselbe while-START<TOTAL-Schleife wie emit_batch_build_job, als EINE gemeinsame Emitter-Funktion (nicht zwei Kopien -- Korn-Drift-Gefahr, plan_slice_korn cache_engine_builder_iterator.hpp:1126); je Scheibe [MESS-TESTAT] fenster=..., offen=...; SLICE bleibt kGnBatchSlice hart; Test EXPECT_EQ(count_occurrences(yaml,"SLICE=4096"),4u).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B-E im ce-Buendel L-1; D-1/D-5 (Owner "maximal 4096 jobs fuer compile und Messung" nur halb umgesetzt)

### [w76o2kmbd.json] 6
GEGENSTAND: Mess-Batch findet die gebauten Binaries lokal NICHT -- Bau schreibt gn_out/<slug>/<host>/perm<idx>, Mess liest measure_out/<slug>/perm<idx>; Bruecke nur ueber minio-Lager-Pull; ohne Lager baut Mess-Batch alles neu.
ORT: main.cpp:1234/:1275/:1391; cache_pull main.cpp:1036-1038; Emitter-Kommentar :1440-1442 ("der Mess-Batch findet sie vor" -- heute FALSCH)
SOLL/FIX: B-4 (Scope 1): Weg (1) Mess-Batch auf denselben dll_dir-Baum zeigen, nur CSV-Senke nach measure_out (billiger, macht Kommentar wahr); ODER Weg (2) Lager-Pull hart (COMDARE_STORAGE_CACHE=true Vorbedingung + Testat [HYDRATION] verified=N pruned=M, N>0). DoD: Zwei-Lauf-Biss GN_TOTAL=64: Lauf1 built>0, Lauf2 built=0 skipped=64.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-7 (Scope 1)

### [w76o2kmbd.json] 7
GEGENSTAND: 320er-Messung laeuft ueber voellig EIGENE Selektion (m3v2_study.profile.xml, 4x4x5x4=320); nur 16/320 (5,0%) liegen im 2^17-Bau-Raum, 304/320 (95%) tragen nicht gebaute Werte; zudem keine <system_axes> => Identitaets-Perm, anderer Stempel/Lager-Schluessel -- auch die 16 gemeinsamen sind 0/320 stempelgleich.
ORT: super .gitlab-ci.yml:738 (measure:golden-320); 02_messung_driver/CMakeLists.txt:32-35; m3v2_study.profile.xml:38-72,:152; source_catalog.hpp:144,:172; golden_fullpilot_320_binary_ids.txt; Sonde /tmp/scope1probe/count.sh
SOLL/FIX: R-1/R-2 (Scope 1): Teilmenge hart bewachen; Empfehlung additiv: alte 320 als m3v2_study belassen (Alt-Datenreihe), NEUE golden_kern_320.profile.xml als echte Teilmenge des 2^17 fuer den Abgabe-Messlauf.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: Fingerprint-KERN "identische Achsen -> identische binary -> identische Messdaten" greift fuer 95% der Mess-Zeilen nicht; Messdaten-nie-loeschen-Doktrin

### [w76o2kmbd.json] 8
GEGENSTAND: Mess-ETA: heute emittierter Mess-Batch (0:131072 je Perm) = ~266 h = 11,1 Tage je Perm (~22,2 Tage je Lane) bei 7,3 s/Zelle -- im Terminfenster nicht ausfuehrbar; 320er = ~39 min.
ORT: 20260723-SESSION-vormittag...:22 (7,3 s/Mess-Zelle, Smoke 12667/12684); experiment_plan_director.hpp:1366-1369
SOLL/FIX: R-3 (Scope 1): Mess-Menge = neue 320er je System-Perm (4x320x7,3s = ~2,6 h); Voll-Bau bleibt Systembeweis, nicht Messgegenstand.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: R-1 Konsolidierung (Mess-Umfang, Wege A/B/C/D)

### [w76o2kmbd.json] 9
GEGENSTAND: Kompilierzeit IST gemessen (FAHRPLAN:415 "unbekannt" ist ueberholt): 19,4 min/4096-Slice amd@24W, 32,25 min intel@24W (Pipeline 12690); Voll-Bau-Wanduhr ~34,4 h (Engpass intel).
ORT: 20260723-SESSION-vormittag...:32-35; 20260723-SESSION-mittag...:41-45
SOLL/FIX: mit dem ersten 4096er-Batch literal nachmessen und die Zahl auf EINE Quelle stellen (Verknuepfung heute nur ueber ZWEI Dokumente via Pipeline 12690).
STATUS LT. QUELLE: teilweise (gemessen, aber Zwei-Quellen-Beleg; UEBERNOMMEN, nicht nachgemessen)
ABHAENGIGKEIT/FLAECHE: D-5 (Scope 1); P-KAL / M-5 (Scope 3); V-06 Erst-Batch

### [w76o2kmbd.json] 10
GEGENSTAND: golden_range-Fenster wirkt NUR im Basis-Pass; die 17 axis_sweep-Paesse laufen in jedem der 32 Scheiben-Aufrufe ungefenstert voll (~78 Zellen je Perm-Aufruf zusaetzlich im Mess-Batch).
ORT: profile_run_entry.hpp:761 (if golden_range_count>0 && pass_axis.empty()), :721-745
SOLL/FIX: D-9 (Scope 1): Fenster-Wirkung auf Sweep-Paesse pruefen/ausweiten (NIEDRIG Bau / MITTEL Mess).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: B-2/B-3-Umbau

### [w76o2kmbd.json] 11
GEGENSTAND: COMDARE_E4_CAP hat ZWEI Semantiken (Basis-Zellen-Cap im Thesis-Weg vs SOTA-Pass-Cap im Experiment-Weg), im Repo nirgends gesetzt.
ORT: profile_run_entry.hpp:190/:388 vs experiment_run_entry.hpp:273/:399 + profile_run_facade.hpp:172
SOLL/FIX: B-7 (Scope 1): zwei Felder mit sprechenden Namen (basis_cap / sota_pass_cap), Default 0, byte-neutral; ctest pinnt unterschiedliche Wirkung. Konsolidierung E-10: kein Owner-Entscheid, Aufraeumpass.
STATUS LT. QUELLE: offen (Aufraeumpass)
ABHAENGIGKEIT/FLAECHE: D-8 (Scope 1)

### [w76o2kmbd.json] 12
GEGENSTAND: Zwei tote XSD-Kanaele: run_options und organ_subaxes im experiment-Dialekt deklariert aber ungeparst; Trigger-Traeger (comdare_thesis_profile) hat GAR KEIN XSD.
ORT: experiment_schema.xsd:59/:75-77/:81; xml_config_parser.cpp:444-570; all_axes_golden.profile.xml (0 xsi-Attribute)
SOLL/FIX: B-6 (Scope 1): parse_experiment_profile um run_options + organ_subaxes erweitern -- ERST NACH B-2 (line_size vervierfacht sonst Bau ohne Mess-Gegenwert); zusaetzlich VOR Konsum die kLbufBytes-Auflage (abi_adapter.hpp, 3 Pfade x 3 64-Literale) -- laut Scope 3/B6 ist kLbufBytes-OOB inzwischen GELANDET (abi_adapter.hpp:622/731/873 abgeleitet + static_assert).
STATUS LT. QUELLE: offen (B-6); kLbufBytes-Teil behoben lt. Scope 3
ABHAENGIGKEIT/FLAECHE: D-10 (Scope 1); R-4 (Scope 1: line_size im Abgabe-Bau NEIN, Unterstuetzung JA)

### [w76o2kmbd.json] 13
GEGENSTAND: kGnBatchSlice je Phase verschieden (Bau 4096 / Mess kleiner)? Owner sagt "maximal" -- erlaubt kleiner, aber Plan-Stempel bindet Koerner; Korn-Divergenz hat schon einmal "kein passender Batch-Plan" ausgeloest.
ORT: experiment_plan_director.hpp:601-603; planer_driven_build.hpp:60; cache_engine_builder_iterator.hpp:1126 (plan_slice_korn); T2-A/F4-NB2 :2668
SOLL/FIX: R-6 (Scope 1): beide Phasen auf demselben Korn 4096 halten (B-3 als EINE geteilte Emitter-Funktion); kleineres Mess-Korn nur MIT fail-loud-Wache gegen abweichendes Bau-Korn.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: B-3/B-E

### [w76o2kmbd.json] 14
GEGENSTAND: binary_id ist Organ-only (18 Segmente, kein Mess-Segment) -- dreifach belegt; Fingerprint Format 3 traegt Mess NUR auf Haupt-Achsen-Koernung (Glied [3] = Tooling-Ids@Version + load_framework-Klammer).
ORT: golden_fullpilot_320_binary_ids.txt:1-2; profile_run_entry.hpp:887-888; anatomy_version_stamp.hpp:216-231,:237-238; anatomy_fingerprint.hpp:462-472,:427-438
SOLL/FIX: (Kontext fuer 15/16) -- Mess-Glied-Inhalt unvollstaendig, s. Fund 16.
STATUS LT. QUELLE: nur-hinweis (Ist-Feststellung)
ABHAENGIGKEIT/FLAECHE: D-6 (Scope 3), R-3 (Konsolidierung)

### [w76o2kmbd.json] 15
GEGENSTAND: SCHWERSTER BEFUND: COMDARE_MEASUREMENT_ON (+CE_ENABLE_STATISTICS, EXPERIMENT_MODE_ON, ANATOMY_MODULE_BUILD) veraendert die Tier-ABI (IObservableTier/IScannableTier/IRollbackableTier, run_workload Pfad A) und steht in KEINEM Preimage-Glied -- Release-Nachmessung ("ohne Mess-Einrichtungen neu kompiliert", Owner 05.08.) erzeugt andere Binary mit identischem Fingerprint => stiller Falsch-Skip.
ORT: profile_run_facade.cpp:273-275 (perm_mess_defines); observable_tier.hpp:191; abi_adapter.hpp:393-394,:589,:1123 + 8 weitere Stellen; dll_is_current build_orchestrator.hpp:330-337
SOLL/FIX: MEASUREMENT_ON (+PMC, +Statistics, +ExperimentMode) als Preimage-Feld (Toolchain-Glied [5] 10. Feld "mess" ans Feld-ENDE mit positionellem static_assert), Format-Bump 3->4, JETZT im offenen Fenster (0 .fingerprint-Sidecars = kostenlos).
STATUS LT. QUELLE: offen (blockiert lt. Konsolidierung den ersten Batch; Klasse ALPHA)
ABHAENGIGKEIT/FLAECHE: R-4 (Scope 2), R-3 (Konsolidierung) [ROT]; B-B im ce-Buendel L-1; ObservableTier-Audit (D-8)

### [w76o2kmbd.json] 16
GEGENSTAND: Fingerprint-unsichtbare Mess-Groessen: 16 MeasurementCategory (nur CSV-Spalten), run_methodology, Workload-WERTE, COMDARE_ENABLE_PMC (erreicht Tier-Compile gar nicht: .so via g++-Subprozess, nicht CMake); Glied [4] nur 3 Organ-Sub-Achsen; Glied [5] 9 Felder ohne Mess-Feld.
ORT: measurement_axis_registry.hpp:33-48; experiment_plan_director.hpp:97-105; anatomy_version_stamp.hpp:169-174; subaxis_valueset_segment.hpp:59-64; toolchain_stamp_glied.hpp:248; PLAN-p-pmc-1-messkette.md:447-462
SOLL/FIX: M-7 (Scope 3): Mess-Glied [3] um measurement_categories (Enabled-Menge), measurement_framework, run_methodology erweitern; Budget kAnatomyFingerprintMeasurementMax=256 (anatomy_fingerprint.hpp:377) pruefen/heben; Format [0] auf 4. Biss: zwei Baue mit unterschiedlicher Kategorien-Menge => verschiedene Fingerprints, dll_is_current=false. Owner-Frage R-3 (Scope 3): ALLE Mess-Achsen oder nur einkompilierte?
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-6/D-7 (Scope 3): ohne M-7 wird L2/L3-Nachruestung still nicht in die Flotte gebaut

### [w76o2kmbd.json] 17
GEGENSTAND: Sicherheitsnetz faellt: Fingerprint-Provider ist Opt-in (ohne COMDARE_BESTANDSLOG=true leere FingerprintFn => kein Sidecar => dll_is_current immer false => ehrlicher Neubau); Voll-Bau-4 soll mit aktivem Provider fahren -- ab Trigger ist das Netz weg.
ORT: profile_run_entry.hpp:434-436; Ledger nachmittag-2 05.08.
SOLL/FIX: M-6/B-F: Gate umkehren (Default AN) ODER im Trigger-Rezept verbindlich + harte Wache (Voll-Lauf ohne Provider bricht ab statt still zu degradieren); cfg.bestand_fingerprint_fn bzw. mess_bestand_fingerprint_fn in BEIDE Aktiv-Bedingungen (cache_engine_builder_iterator.hpp:1658-1660 UND :1665-1668), fail-closed. Owner-Antwort E-3: Bestandslog "Pflicht wie im Plan" = JA.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-9 (Scope 3), i-5+i-6; B-F im ce-Buendel L-1

### [w76o2kmbd.json] 18
GEGENSTAND: Eine Mess-Achsen-Aenderung, die Glied [3] bewegt, invalidiert 100% der Flotte (genau EINE Mess-Achsen-Einstellung existiert; beide produktiven XMLs deklarieren EINE combo [all]); Teilmengen-Semantik erst mit N>1 Combos (S6).
ORT: experiment_plan_director.hpp:1825-1829,:258; all_axes_golden.profile.xml:225; experiment_golden_kern.xml:415-417 (:398-414 Regressions-Nachzug 3->1); lazy_adhoc_source_gen.hpp:236-243,:304-307
SOLL/FIX: (Kontext fuer Buendelung) -- s. Fund 20.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Klasse ALPHA

### [w76o2kmbd.json] 19
GEGENSTAND: CEB-Fortpflanzung ist Disziplin, nicht Mechanik: kCebFingerprint shiftet bei Tooling-Registry-Aenderung, aber KEIN Gate konsumiert ihn (reine Log-Kopf-Provenienz); CEB-Neubau haengt nur an ninja/ccache der 4 cmake-Emissionen.
ORT: ceb_version_stamp.hpp:199-201,:11-13; experiment_plan_director.hpp:843,879,1196,1344; Konsolidierung: Provenienz-Kette profile_run_facade.cpp:901 -> planer_block_value.hpp:59-66 -> bestandslog_document.hpp:256 verfolgt, kein Gate vergleicht
SOLL/FIX: B-3 (Scope 2): kCebFingerprint in --version-Block des Treibers + Kopf jeder emittierten Batch-Job-Zeile (Divergenz Bau-/Mess-CEB im Trace sichtbar, ohne Neuanker). B-J (Konsolidierung, Klasse BETA): echtes Gate bauen -- solange B-J fehlt, loest CEB-Aenderung KEINEN Binary-Neubau aus.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-2 (Scope 2), D-7 (Scope 3); B-I/B-J zusammen entscheiden (beide ceb_version_stamp.hpp)

### [w76o2kmbd.json] 20
GEGENSTAND: Buendelungs-Gebot: wenn Mess-Aenderung identitaetswirksam (R-1 Scope 2 = Empfehlung JA), gehoeren in DIESELBE Welle: (1) Tooling-Registry-Bump v1.0.0c->v1.1.0c, (2) MEASUREMENT_ON als Preimage-Feld, (3) CE_ENABLE_STATISTICS+EXPERIMENT_MODE_ON, (4) Overlay-Source-Hash [7] scharf, (5) ObservableTier-Fix falls CT-wirksam, (6) fingerprint_format 3->4, (7) Neuanker der 3 Frozen-Vektoren (test_m_w12_stamp_bausteine.cpp:662, test_w10_system_cell_values.cpp:431, test_g3_sha512_index.cpp:68).
ORT: measurement_tooling_registry.hpp:46-50; anatomy_fingerprint.hpp:80-88,:89,:91-111
SOLL/FIX: B-5 (Scope 2): EIN Commit in genannter Reihenfolge; Abnahme: abi/-Diff nur benannte Zeilen, golden-CRC 0x56F1B721C72DC10E unberuehrt, 320er-ids unberuehrt, Doppellauf ctest. NICHT in die Welle: XML-Trennung + PMC-Flag-Fix (fingerprint-neutral, VORHER fahren).
STATUS LT. QUELLE: offen (gegatet auf Owner R-1 Scope 2)
ABHAENGIGKEIT/FLAECHE: O-2-Praezedenz (Ledger:4131 "GEBUENDELT in EINEM Entscheid"); Klasse ALPHA

### [w76o2kmbd.json] 21
GEGENSTAND: Bestand-Bilanz: 0 .fingerprint-Sidecars lokal; 328 .version/.algos; 90 perm_*.so (nur Fixtures/Alt-Baeume); minio UNBELEGT (Ledger-Feststellung "Enumeration ENTFAELLT BEGRUENDET", Nachhol-Naht P11); Alt-Bestaende ohnehin fail-closed-invalid (+ceb=7.x vs lebend 8.0), additiv liegen lassen.
ORT: anatomy_module_abi_v1_decl.hpp:89 (ABI_MAJOR 8), :459; Ledger:3652/:3759/:3809/:4117
SOLL/FIX: R-5 (Scope 2): Ein-Zeilen-Zaehlung durch Infra-Rolle (mc ls --recursive | wc -l) als Vorbedingung von B-5 -- verwandelt letzte UNBELEGT-Stelle in Zahl.
STATUS LT. QUELLE: offen (Infra-Fenster noetig)
ABHAENGIGKEIT/FLAECHE: Cluster-read-only-Doktrin; R-6 Konsolidierung (Ebene-B-Push)

### [w76o2kmbd.json] 22
GEGENSTAND: PMC/L2/L3 leben im Treiber (CEB), erzwingen fuer sich KEINEN Tier-Neubau; der EINE echte Entscheid ist, ob die Mess-Aenderung IDENTITAETS-wirksam wird (dann Voll-Neubau 524.288 bzw. 1.572.864).
ORT: linux_perf_pmc_source.hpp; make_pmc_source Aufrufer cache_engine_builder_iterator.hpp:2586, harness/perm_runner.hpp:130
SOLL/FIX: R-1 (Scope 2): Empfehlung (a) identitaetswirksam, JETZT (0 schuetzenswerter Bestand; zweiter Shift kostet spaeter zweiten globalen Neuanker; nur (a) haelt den FINGERPRINT-Satz).
STATUS LT. QUELLE: offen (Owner-Entscheid) [ROT]
ABHAENGIGKEIT/FLAECHE: blockiert B-5 (Scope 2); Klasse ALPHA

### [w76o2kmbd.json] 23
GEGENSTAND: System-Perm-Widerspruch: Doktrin V7.4 sagt 12 Perms (O0-O3 x {no_ext,avx2,avx512}), beide produktiven XMLs sagen 4 (O2,O3 x no_ext,avx2); Faktor 3 = 128 vs 384 Batches.
ORT: all_axes_golden.profile.xml:189-198; experiment_golden_kern.xml:363-379; Ledger:93/:104/:2492/:3687/:4117/:4131
SOLL/FIX: R-3 (Scope 2)/R-4 (Konsolidierung): bei 4 bleiben, Widerspruch im Ledger als bewusste Reduktion vermerken (O0/O1 fachlich fragwuerdig, avx512 nur prod1); wenn Owner 12 will, Nachzug VOR B-5 in die XMLs.
STATUS LT. QUELLE: offen (Owner-Frage) [GELB]
ABHAENGIGKEIT/FLAECHE: B-5-Kardinalitaet; Profil-Kommentar :183-188 traegt fachliche Begruendung (Ofast/IEEE-754, avx512)

### [w76o2kmbd.json] 24
GEGENSTAND: Overlay-Source-Hash Glied [7] leer (Fallback B); Scharfschaltung braucht 3 Owner-Festlegungen (Dateimenge, Sortier-Ordnung, Hash-Verfahren), die NIE geraten werden duerfen; spaeter kostet sie eigenen Neuanker.
ORT: anatomy_fingerprint.hpp:91-111,:99-107; L14/OF-M3-2 Ledger:4171
SOLL/FIX: R-2 (Scope 2): JA mitnehmen, aber nur wenn die 3 Festlegungen mit dem R-1-GO kommen; sonst bewusst bei Fallback B bleiben.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: B-5 Punkt 4

### [w76o2kmbd.json] 25
GEGENSTAND: Mess-Inventar-Wache fehlt: keine Instanz pinnt "jede messwirksame Groesse steht im Preimage ODER auf deklarierter Ausnahmeliste".
ORT: (neu) ce/tests/unit/test_mess_identitaets_deckung.cpp
SOLL/FIX: B-1 (Scope 2): neue TU pinnt die Invariante; Startbelegung Ausnahmeliste: 16 MeasurementCategory, run_methodology, Workload-Werte, ENABLE_PMC, MEASUREMENT_ON, CE_ENABLE_STATISTICS, EXPERIMENT_MODE_ON (je mit Datei:Zeile). fingerprint-neutral, ~1 h.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w76o2kmbd.json] 26
GEGENSTAND: Die vier Tier-Defines sichtbar machen: Literal-Vektor in benannte inline constexpr heben + Warn-Kommentar (ABI-wirksam, in keinem Preimage-Glied; wer variabel macht, MUSS in Glied [5] aufnehmen).
ORT: profile_run_facade.cpp:273-275
SOLL/FIX: B-2 (Scope 2), byte-neutral, ~30 min; belegt zugleich D-5 fuer das Audit.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: ObservableTier-Audit

### [w76o2kmbd.json] 27
GEGENSTAND: PMC-Registry verspricht mehr als die Quelle liefert: 16 Kategorien enabled=true, aber L2 bewusst nicht geoeffnet, coherence=0, branch_misses NIRGENDS zugewiesen (18 Treffer, 0 Quellen), IPC/CPI kein Counter; L3 gebaut als Last-Level aber im D-03-Lauf 0 in allen 16 Zeilen (Diagnose noetig, nicht Neubau).
ORT: measurement_axis_registry.xml; linux_perf_pmc_source.hpp:192,:194-195,:208,:263-266,:295; PLAN-p-pmc-1-messkette.md:202-234
SOLL/FIX: M-14 (Scope 3): PERF_COUNT_HW_BRANCH_MISSES ergaenzen (:202-207); L2+coherence via Zen-5-RAW (I-PMC-3/#187); IPC/CPI aus INSTRUCTIONS/CPU_CYCLES; jede nicht lieferbare Kategorie enabled=false ODER honest-0-Begruendung VOR dem Lauf. Rang-Aenderung D-3: von NACH-ABGABE auf Owner-PFLICHT ("PFLICHT und KERN der ANLAGE").
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: setzt M-7 voraus (D-7); B-I (Klasse BETA)

### [w76o2kmbd.json] 28
GEGENSTAND: PMC-Flag fehlt in allen 4 Planer-Emissionen (grep COMDARE_ENABLE_PMC experiment_plan_director.hpp = 0; CMakeLists.txt:67 = OFF); 4 Wachen beissen nicht (SMOKE_SKIP + return 0; pmc_seam_ok = available || counters_all_zero).
ORT: experiment_plan_director.hpp:841,:877,:1194,:1342; linux_perf_pmc_smoke.cpp:58-63; m3v2_pmc_smoke.cpp:71
SOLL/FIX: M-1 (Scope 3): -DCOMDARE_ENABLE_PMC=ON in alle 4 Emissionen, Begruendung woertlich aus super/.gitlab-ci.yml:673-676; :1194+:1342 MUESSEN gemeinsam landen (geteiltes Code/build); Invarianten-Test ("jede cmake -B build-Emission traegt das Flag"), Muster count_occurrences :398. M-2: SMOKE_SKIP hinter --require-available; m3v2_pmc_smoke.cpp:71 NICHT anfassen (M-CE-25-Inversionsfix); "Quelle nicht gebaut" wird Fehler. Biss: ohne Flag ROT, mit Flag GRUEN.
STATUS LT. QUELLE: offen (Owner: "fixen und neu messen ist Pflicht")
ABHAENGIGKEIT/FLAECHE: B-C im ce-Buendel; M-3 gleiche Zeilenregion => zwingend dieselbe Welle

### [w76o2kmbd.json] 29
GEGENSTAND: allow_failure: true am Mess-Batch (Doktrin-Konflikt: Par.66-N2 "BEIDE hart" + #278 "0 allow_failure" vs Sichtbarkeits-Doktrin).
ORT: experiment_plan_director.hpp:1332-1333
SOLL/FIX: M-3 (Scope 3): allow_failure entfernen, Zell-Sichtbarkeit auf CSV-'failed'+Log; R-5 (Scope 3): Trennung nach Fehlerart -- Zell-Fehler CSV, Infra-/PMC-Ausfall der Lane hart rot; braucht GO. Konsolidierung E-2: Owner-Antwort JA (Entfernen), konkrete Form ist Bau-Entscheid.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: P-1/KK-1-Buendel (kostenklammer-restposten.md:512-553); gleiche Welle wie M-1

### [w76o2kmbd.json] 30
GEGENSTAND: Drei ungesicherte Arbeitspakete (Stand 06.08.): U-1 ce b-lb6-stufe1=3558466d (wt-lb6, +506/-37, kein Remote); U-2 thesis b-thesis-ehrlichkeit-anhang=a6c7598c (+2 dirty A_measurements.tex, kein Remote); U-3 zwei ??-Plan-Docs + Code/measure_out_d03/ (einziger realer Lauf mit pmc_available=1).
ORT: /home/comdare/wt-lb6; Code/external/20260931-overleaf-diplomarbeit; super-Baum
SOLL/FIX: 0.1: rescue-Refs auf BEIDE Remotes; Plan-Docs mit explizitem Pathspec committen; measure_out_d03 additiv sichern (die 4 Logs sind der einzige Zugang zur offenen PMC-Ursachenfrage) + .gitignore mit Begruendung.
STATUS LT. QUELLE: U-1/U-2 lt. Konsolidierung ERLEDIGT (b241a272 gemerged, thesis a6c7598 gelandet); U-3/measure_out_d03 offen (WELLE 0.3)
ABHAENGIGKEIT/FLAECHE: M-5 (Konsolidierung); Messdaten-nie-loeschen

### [w76o2kmbd.json] 31
GEGENSTAND: Gelandet-Bilanz 06.08.: ce a9a352bb/6c300e68/86be2420 (T2-A Format 3), 4b38d072/16a173f2 (B14-ce ABI 8.0->8.1), fdfa68ee/9eb1e7d6 (A1), dcb2f08f/557d8023 (R4), 3bbcb8ed (P92), e7aa1244/47c4ef1d -- alle GELANDET; super 1ba29b63/9934a7e5/31af5a92/4b1cd5e3/725ead43/b35aea1b/85b74237/953ce412/d8073913 GELANDET; thesis 8970465d GELANDET; NICHT gelandet: super b-e18-snap=5c4cf900 (stehendes NICHT-LANDEN-Verdikt CODEX-VERDIKT-NB2).
ORT: merge-base --is-ancestor geprueft; docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md
SOLL/FIX: Bau-Block (R4+T2-A+B14-ce+A1) geschlossen; Fingerprint-Anker steht. Ledger war einen Schritt hinter dem Objekt (b00638f2, c911c2fb, 72eab9ae unverbucht).
STATUS LT. QUELLE: behoben@diverse (SHA-Behauptungen wie gelistet); e18-snap offen
ABHAENGIGKEIT/FLAECHE: -

### [w76o2kmbd.json] 32
GEGENSTAND: Vor-Trigger-Checkliste B1-B14 Bilanz (Stand 06.08.): 3/14 erledigt (B6-Teil, B7, B14), B1 bau-erledigt/aktivierungs-offen (anhang:forward INERT-by-default, Scharfschaltung + B-5-Lebend-Check offen), 10 offen: B2-Vollausbau(P4), B3, B4 (Termin-Widerspruch "vor Messung" vs P4), B5 (Bau offen, Namens-Kollision B5 vs B-5), B6-Rest (77/78-Doku: kReal16-Pin-Wache, XorFilter-FN-Doku inkl. Thesis-Pflicht), B8 (J-Hygiene L2 + D-10-Eichung -> P3; Zitat-Drift P4), B9 (P11 Pre-Flight, umklassiert P4->P3), B10 (=LB-6 Beweis 1), B11 (stale build/ mit Mess-CSV-Falle), B12 (xlsx=DEFAULT: nur 1 Kommentar lager_ziel_strategie.hpp:166, kein Writer -- Phase 6 faehrt auf CSV), B13 (L18-ETA, Worktree abgebaut, neuer Branch + Re-Anker noetig).
ORT: Ledger 05.08. abend-4 Z.5814-5822 + abend-10; .gitlab-ci.yml:1029/:1051
SOLL/FIX: je Posten wie gelistet; B12: xlsx-Default-Writer bauen (Owner-KERN xlsx=DEFAULT).
STATUS LT. QUELLE: offen (10 von 14)
ABHAENGIGKEIT/FLAECHE: P2-Band "VOR Messbeginn Pflicht" (Leitplanke 4); B-T (Konsolidierung)

### [w76o2kmbd.json] 33
GEGENSTAND: Offene Phasen-Landkarte (Stand 06.08.): P0 TP1+4+1 + Stempel-/RF-Rest (G2/#36, RF-1/2/6/7/8, C-3a/b, O-2-Ratifikation) + Atlas-Nachzug OFFEN; P2 komplett OFFEN (P2-P8-WIDE-Schema, Lager-Kaskaden+xlsx, B5, #46b-Rest, G-E3-Host-Binder, 77/78); P3 komplett OFFEN (Trigger-Checkliste, P-KAL, B9/P11, Forecast/df-Wache, OD-7, E8, Ebene-B-Push, G1, V-06, V-05-#162, V-17 Reaper, Posten 89); P4-Reste OFFEN; Wellenplan 1B/1C/1D/2A/2B/2C/3A/3B/4 OFFEN; LB-6 Beweis 1+4 OFFEN; K/KK: P-1..P-5, davon P-1 allow_failure vor Trigger.
ORT: Scope 3 Par.2; docs/plaene/20260806-PLAN-wellenplan-vollbild-und-parallelisierung.md
SOLL/FIX: wie je Posten; M-10 P11-Pre-Flight traegt Ebene-B-Enumerations-Nachholung + Env-Check des Voll-Bau-4.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w76o2kmbd.json] 34
GEGENSTAND: OD-7 Runner-Konflikt: einzige bekannte aktive Abweichung von einer Owner-Direktive (SOLL 2/2 + heavy 24, IST 3/2 + 16); dazu Memory-Konflikt prod1=16 Kerne/32 Threads vs OD-7 setzt 24.
ORT: M-11 (Scope 3)
SOLL/FIX: OD-7 Runner-Ist Live-Check vor Messung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Trigger-Checkliste P3

### [w76o2kmbd.json] 35
GEGENSTAND: Posten 89 T6-Rebound-Leaf-Einpreisung fehlt -- sonst Falsch-Regressions-Lesung beim ERSTEN Vergleich gegen Alt-CSV.
ORT: M-12 (Scope 3)
SOLL/FIX: vor erstem Alt-CSV-Vergleich einpreisen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Mess-Auswertung

### [w76o2kmbd.json] 36
GEGENSTAND: ObservableTier-Vertrags-Audit (Owner: Orchestration der Konstruktion in Tier/Hybrid "ist FALSCH", Vertrag "muss auditiert werden"; Achse bleibt "KERN Achse des Planers"): IObservableTier in 30 Dateien; CEB konstruiert/treibt via tier_observe_trace_abi.hpp:125/:198, search_algorithm_dock.hpp:45/:81 (dynamic_cast aus .so), mess_interface_testate.hpp:212; kein Plan-Dokument deckt den Auftrag.
ORT: wie genannt
SOLL/FIX: M-13: Audit read-only als Befundliste gegen Stufen-Doktrin (Planer-RT -> CEB-CT -> [Hybrid-CT] -> Tier-CT), Bau erst nach Owner-Abnahme. R-4 (Scope 3): Praezisierung noetig -- (a) CEB konstruiert statt freizugeben, (b) Hybrid erbt statt weiterzureichen, (c) beides?
STATUS LT. QUELLE: offen (Owner-Frage + Audit unausgefuehrt)
ABHAENGIGKEIT/FLAECHE: B-G; D-5 (Scope 2: Owner-Befund am Objekt bestaetigt -- MEASUREMENT_ON ist CEB-Orchestration, nicht im Fingerprint)

### [w76o2kmbd.json] 37
GEGENSTAND: Abgabe-Blocker-Liste A-1..A-8 (Scope 3): Anhang A 44/44 (O-4 Weg 2); A_measurements.tex:11-12 widerlegte Limitierung nachziehen (V-08-Rest, HEUTE schon widerlegt, nicht erst Phase 6); R-T1-Textkorrektur 05_evaluation.tex:94-101 DE+EN; R-T2 Branch-Misses/IPC aus 05_evaluation.tex:86-91 streichen oder honest-0; R-T3 Spalte l3 vs Counter last-level (eine Zeile le_limitierung.tex); U-2 sichern/landen; V-02-Rest Mess-Manifest/Provenance; 77/78-Doku (XorFilter-FN = Thesis-Pflicht).
ORT: wie genannt
SOLL/FIX: wie je Posten.
STATUS LT. QUELLE: offen (U-2 lt. Konsolidierung gelandet)
ABHAENGIGKEIT/FLAECHE: B-P (Konsolidierung); Owner "erst die Messdaten beheben"

### [w76o2kmbd.json] 38
GEGENSTAND: Anhang-A-Aufloesung (Scope 4): die 28 fehlenden Fragmente haengen NICHT an V-04/M-8/M-9/M-15 -- alle 28 seit 06.08. 17:46 in der 08-Facade verdrahtet; Generator GEFAHREN: 28/28 bedient, PDF DE+EN 0 Fehler; 20/29 Deficit-Positionen mit echten Werten baubar, 6 ehrliche Vermerke, 3 honest-empty. LEDGER:5149-Praemisse ("Anhang A haengt an V-04") am Objekt FALSCH.
ORT: appendix_generator.cpp:380-540; appendix_generator.hpp:151-188; Diagnose /home/comdare/diag-scope4/*
SOLL/FIX: P-2 (Scope 4): Variante A additiv (nur die 26/28 fehlenden kopieren, NICHT ci/anhang_forward_core.sh fahren -- dessen Whitelist ueberschreibt die 12 Kern-Fragmente, 11 von 12 schrumpfen, 3 werden Platzhalter, ld_exchange_memory_layout leere Tabelle).
STATUS LT. QUELLE: offen (Owner-Frage R-1 Scope 4: Variante A vs B; Empfehlung A mit Naht-Auflage)
ABHAENGIGKEIT/FLAECHE: chktex-Blocker (Fund 40); Naht-Auflage (Fund 41)

### [w76o2kmbd.json] 39
GEGENSTAND: Messdaten-Ehrlichkeit VOR Anhang (Scope 4 P-1): le_limitierung Zeile 1 ("L1-L3+dTLB+Coherence+Energy=0/nicht erhoben; NullPmcSource available=false") und Zeile 2 ("Nur 4 Achsen variieren") sind gegen den d03-Korpus FALSCH (pmc_available=1, L1+dTLB real 16 Werte; NUR 3 Achsen variieren, memory_layout gepinnt; telemetry/isa existieren nicht mehr in der 18-Segment-id).
ORT: csv_to_latex.cpp write_limitations_longtable ab :951 (DE), :1108ff (EN); A_measurements.tex:12-13 (DE)/:11-12 (EN); measurement/20260726-164259-d03-strukt-r-erstbeleg/ (17 Zeilen, 173 Spalten, sha256 437af9f2...)
SOLL/FIX: P-1a: Zeilen richtigstellen (L1+dTLB real; L2/Coherence/Energy bewusst nicht geoeffnet; branch_misses honest-0 ohne Quelle); P-1b: A_measurements.tex nachziehen (REGISTER:418 jetzt faellig); P-1c: veralteter Verweis auf generate_measurement_appendix.ps1 -> 08-Facade. Biss: Test in test_04_csv_to_latex_cached_fixtures.cpp (19->21 Vorbehalte); keine committeten Golden-.tex in 04/05/08 => keine Fixture-Risse. UNBELEGT: WARUM der d03-Lauf PMC-Werte hat (Flag in keinem Log).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R-2 (Scope 4: Ist des Korpus vs Faehigkeit der Kette -- Empfehlung Ist mit Fussnote); B-P

### [w76o2kmbd.json] 40
GEGENSTAND: HARTER BLOCKER chktex: 289er-Gate (thesis .gitlab-ci.yml:63, kein "|| true") wird von generierten Dateien gerissen -- Variante A: 18 Befunde (16x W1 \endfirsthead/head/foot/lastfoot + 2x W8 ECDF-Bindestrich), Variante B: 55; anhang:forward-PDF-Gate prueft NUR Baubarkeit, chktex laeuft erst NACH dem Push. Konsolidierung misst unabhaengig: EXIT 123, 31 Warnungen ueber 8 Dateien (W1x28, W8x1, W11x1, W18x1).
ORT: Emit-Stellen: csv_to_latex.cpp:673,675,677,678,969,972,974,1319,1322,1324,1369,1372,1374; diagram_generator.cpp:2026,2029,2031,1921-1922; appendix_generator.cpp:207,210,212; Variante-B-Zusatz: :1050/:1120 catch(...), z.B./e.g., :1061 Anfuehrungszeichen
SOLL/FIX: P-2a: je ein angehaengtes % (Form der committeten Dateien: \endfirsthead%); ECDF-Titel -> --; Biss: chktex -q -n36 -n17 ueber frisch generierte .tex == 0.
STATUS LT. QUELLE: offen (B-O [ROT] in Konsolidierung; "sobald Anhang A committet wird, geht lint:latex rot")
ABHAENGIGKEIT/FLAECHE: K-4: B-O ZUERST, dann B-Q (M-9-Verdrahtung), sonst neue W1-Verstoesse

### [w76o2kmbd.json] 41
GEGENSTAND: Pflicht-Auflage Korpora-Naht: Variante A mischt 2 Messlaeufe (16 Fragmente aus nicht reproduzierbarem cowfix-v1/21-Lastprofile-Korpus [LEDGER:854], 26 aus d03 2-Lastprofile/3-Achsen) -- genau der als "unehrlich" verworfene Weg 2b, sofern die Naht nicht sichtbar wird.
ORT: PLAN-thesis-posten:178-181,:200-205
SOLL/FIX: neue Zeile in write_limitations_longtable: welche Fragmente aus welchem Lauf (16 vs 26, Lauf-Kennungen, 6 Vermerke + 3 Auslassungen aus op_erase_n=op_scan_n=op_rmw_n=0). "Damit steht die Naht im Dokument, nicht nur im Ledger."
STATUS LT. QUELLE: offen (Pflicht-Auflage fuer Variante A)
ABHAENGIGKEIT/FLAECHE: R-1 (Scope 4)

### [w76o2kmbd.json] 42
GEGENSTAND: P-2b: observer_detail.tex 12 Overfull hbox a 1563,6 pt (multicolumn mit ~470-Zeichen binary_id, umbruchfrei); zudem skaliert der Writer nicht (keine Zeilen-Kappung, ~97 LaTeX-Zeilen je Messzeile -- im Voll-Lauf unbaubar).
ORT: diagram_generator.cpp:2045-2047 (Kopfzeile), :2036-2059 (keine Kappung); A_measurements.tex:132
SOLL/FIX: p{\textwidth}-Zelle mit \seqsplit/\allowbreak an /-Grenzen; Biss: grep -c Overfull DE-Log <= 5. R-5 (Scope 4): fuer Voll-Lauf aggregieren (Median/Min/Max je Achse+Feld), Roh-Zeilen als Beilage -- VOR dem Trigger entscheiden.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Phase 6

### [w76o2kmbd.json] 43
GEGENSTAND: M-9-Writer-Bilanz: 3 von 4 existieren und liefern echten Inhalt, sind aber NICHT in der 08-Facade verdrahtet (write_sota_series_table, write_sweep_axis_longtable, write_seg_coverage_appendix); M-8 (Varianz-Attribution) und M-15 (Welch-Stufe in super) haben KEINEN Code; ce fuehrt welch_t_test.hpp etc. im builder/commands.
ORT: csv_to_latex.hpp:251/:258/:263; diagram_generator.hpp:403; Sonde /home/comdare/diag-scope4/m9_probe.cpp
SOLL/FIX: P-3a/B-Q: die 3 Writer in Facade haengen (Muster appendix_generator.cpp:452-461) + je eine Input-Zeile; R-3 (Scope 4)/R-5 (Konsolidierung): M-9 jetzt, M-8/M-15 nach erstem echten Korpus (Korpus hat repetition=1 -- Varianz/Signifikanz braucht Wiederholungen).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: K-4 (nach B-O); NICHT Blocker fuer die 28

### [w76o2kmbd.json] 44
GEGENSTAND: axis_inventory.tex entsteht im CI NIE: .gitlab-ci.yml:711/:803 und ci/anhang_forward_core.sh:173 rufen den Generator OHNE --*-registry; Anhang D bindet die Datei seit df54a2c ein (REGISTER:394 dazu ueberholt -- Luecke ist jetzt CI-seitig).
ORT: wie genannt
SOLL/FIX: P-3b: Registry-Argumente in die CI-Aufrufe aufnehmen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Anhang D

### [w76o2kmbd.json] 45
GEGENSTAND: ld_sweep_* = Kurve mit EINEM Punkt (working_set_n konstant 4096; Writer weitet x-Achse selbst auf Oktave); Flaechen 4x2 statt 4x21; Schema-Versatz: d03-Korpus 173 Spalten ohne pmc_branch_misses, neuer Lauf >=174 -- Vergleich muss projizieren.
ORT: Scope 4 2.2 Einschraenkungen; measurement/NOTIZ-binary-id-grammatik-der-archive.md
SOLL/FIX: Einschraenkungen dem Owner benennen; Projektion beim Alt/Neu-Vergleich.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [w76o2kmbd.json] 46
GEGENSTAND: BEFUND 1 (Scope 5): doppelte Thesis-Einbindung -- zweiter Mount Code/external/20260931-overleaf-diplomarbeit hat NULL Konsumenten (CI 0, CMake 0; ein Test schliesst ihn aktiv aus: test_experiment_plan_director.cpp:1854-1856), Anlass ("LaTeX-Diagramm-Einbindung", User-Auftrag e1a8e230 26.07.) von anhang:forward abgeloest; .gitmodules-Block 4 ohne branch/update (zweite Driftquelle); Vorfall 85b74237 -> 72eab9ae (55 min, CI-PDF war Fassung vom 03.08.); Board-Posten #74 nur SHAs gleichgezogen, Ursache blieb; Ledger:4618 "braucht einen Besitzer".
ORT: .gitmodules Z.1-19; .gitlab-ci.yml (0 Treffer 20260931); 20260803-od10-rt-welle/phasencheck-bericht.md:45 (L17)
SOLL/FIX: Bau-Anweisung 1.7 (Scope 5), 7 Schritte: git rm --cached; .gitmodules-Block loeschen; Arbeitsbaum VERSCHIEBEN nicht loeschen; config-Section entfernen; Doku-Deprecation-Kopfnotiz in 2 Plan-Docs (6 Fundstellen bleiben); Ledger #74 fortschreiben; Overleaf-Naht getrennt pushen. Verifikation: submodule status genau 3 Zeilen ohne -/+/U; ls-tree ^160000 = 3; grep 20260931 .gitlab-ci.yml = 0/Exit 1; Pipeline gruen inkl. verify:submodules, thesis:pdf mit Artefakten, 3 Bridges; PDF enthaelt 23 Gate-8-Abbildungen (>202 S.); github/main == 8970465d.
STATUS LT. QUELLE: offen (braucht Owner-GO R5-1, da Anlass ein User-Auftrag war)
ABHAENGIGKEIT/FLAECHE: K-6: .gitmodules in changes ALLER 3 Bridges (:249,:267,:285) => 3 Kind-Pipelines, ALLEIN landen; B-R

### [w76o2kmbd.json] 47
GEGENSTAND: NEBENBEFUND Overleaf-Naht: Gate-8-Commit (23 Anhang-A-Abbildungen, +199/-2 an A_measurements.tex DE+EN) liegt auf GitLab (8970465d), NICHT auf GitHub (29a1700d) -- also nicht in Overleaf ("Overleaf synct GitHub/main", Ledger:5768). Konsolidierung: inzwischen 5 Commits Rueckstand, reiner FF (Gegenrichtung 0).
ORT: thesis-Submodul github/main vs origin/main
SOLL/FIX: R5-2/E-9/B-S: sofort und getrennt pushen (git -C thesis/diplomarbeit push github <sha>:refs/heads/main + development) -- reiner FF, konfliktfrei gemessen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Abgabe-Substanz sichtbar machen; unabhaengig von allem anderen

### [w76o2kmbd.json] 48
GEGENSTAND: BEFUND 2 (Scope 5): Bridges triggern branch: main (dokumentiert-absichtlich, Ledger:2044 -- Option B OFF THE TABLE), aber die Durchsetzung fehlt: KEINE Instanz prueft Gitlink gegen Downstream-main (grep merge-base/is-ancestor = 0 in beiden CI); auf super/main GERADE verletzt: main-Pipeline misst ce 47c4ef1d / thesis 8970465d, bettet aber e7aa1244 / 29a1700d ein; super origin/main 9 Commits FF-Rueckstand.
ORT: .gitlab-ci.yml:253-255,:271-273,:289-291; Ledger:2044/:2045
SOLL/FIX: Empfehlung (c)+(b3): neuer super-Job verify:gitlink-vs-downstream (Stage submodules, hart, kein Token): je Paar LINK=ls-tree, MAIN=rev-parse origin/main; auf main: LINK==MAIN sonst Exit 1 mit PFAD/LINK/DOWNSTREAM-MAIN/DISTANZ; auf development: MAIN Vorfahr von LINK UND LINK in Downstream-development gelandet (Regel 9, LEDGER:4290); immer FF-SCHULD-Zeile je Pfad (nie Sammelzahl). Biss 3 Faelle (kuenstlich rueckwaerts; nur-lokal; gruen mit FF-SCHULD sichtbar). Danach main-FF 5534c23c->72eab9ae + main-Pipeline gruen. b1 (Tag) und b2 (SHA-Variable) verworfen; b2 wuerde strategy:depend entwerten. [UNBELEGT: Bridge kann keine nackte SHA -- Produktwissen; Verifikationsweg: GET /api/v4/version + POST /projects/288/ci/lint mit branch:<SHA>, read-only -- R5-7 bittet um Freigabe/Infra].
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R5-3 (Haerte auf development: FF-Schuld als Zahl, nicht rot); Befund 3 haengt daran; E-13 (Konsolidierung: Bridge-Aenderung entschieden dagegen)

### [w76o2kmbd.json] 49
GEGENSTAND: BEFUND 3 (Scope 5): super hat KEINE Abdeckungs-Invariante -- 1 Test-Job (test:unit, -L da_unit): Bau A 472 registriert/145 gefahren/327 (69,3%) nicht; Bau B (06.08.) 555/151/404; genannte Zahl 399 UNBELEGT (Rekonstruktion 404-5). ce-Deckung gilt fuer ce/main in ce-Standalone-Konfig -- super embeddet anderen Commit in anderer Konfig (11 Options-Delta, u.a. HAVE_MIMALLOC/SNMALLOC, V32, BUILD_PERMUTATIONS); Code/CMakeLists.txt:196-210 belegt Kipp-Faelle. Super-eigener Test ohne da_unit-Label liefe in KEINEM Job; coverage-guard im super 0 Treffer, kein scripts/-Verzeichnis.
ORT: .gitlab-ci.yml:219-236,:407; LastTest.log "375/472"; nb4-super-gate-da_unit-j1.txt; ce .gitlab-ci.yml:274-276; Ledger:5195
SOLL/FIX: Bau-Anweisung 3.5: Schritt 0 Zahl live herstellen (2-Pass-Diagnosebau ausserhalb des Repos, ctest -N und -N -L da_unit, beide Zahlen ins Ledger mit Bau-Zustand); Schritt 1 ci/super_test_coverage_manifest.sh (POSIX sh, ASCII, kein Python/YAML-Regex; AUSSCHLUSS-Block _cache_engine_external mit Auffang-Nachweis "trigger:cache-engine -> ce test:coverage-guard" GEBUNDEN an gruenes verify:gitlink-vs-downstream; FROZEN-Block 9 Eintraege je mit Klasse+Begruendung -- nicht mehr fehlschlagender FROZEN-Eintrag macht Wache ebenfalls rot); Schritt 2 Job test:coverage-guard (Restmenge nicht leer => Exit 1 mit Namen); Schritt 3 drei Beweise (Inventur-Summe, 3 Biss-Faelle, echter Lauf); Schritt 4 Zwei-Gate-Modell-Zahlen fortschreiben (additiv, alte Fassung als ueberholt markieren).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: haengt an Befund 2; R5-5, R5-6

### [w76o2kmbd.json] 50
GEGENSTAND: Die 3 super-roten *_registry_roundtrip-Tests sind KEIN Code-Drift, sondern planmaessige Referenz-Konfigurations-Meldung (super-Bau hat mimalloc+snmalloc => baustein_count 3->5); LastTestsFailed.log 27.07. zeigt SIEBEN Fehlschlaege, nicht fuenf -- Zwei-Gate-Doktrin nennt test_permutation_codegen_byte_identity_{smoke,medium} nicht; nur EINER der drei Roundtrips war damals rot ("3 echte Fehlschlaege" nicht reproduzierbar, [BERICHT]).
ORT: registry_roundtrip.cmake:12-18; Code/build-test/Testing/Temporary/LastTestsFailed.log (mtime 27.07. 07:57); regenerated_registry.xml-Diff
SOLL/FIX: R5-4: deklarierte Konfigurations-Ausnahme im super-Manifest (Vendor-Allokatoren sind Mess-Substanz, nicht abschalten), Ausnahme muss rot werden wenn Test unerwartet gruen; Anschlussfragen: (a) HAVE-abhaengige Bausteine mit header="" emittieren? (leere Pflicht-Angabe = stille Unwahrheit, Aufraeumpass); (b) zweite HAVE-ON-Referenz-XML ins Repo?
STATUS LT. QUELLE: offen (Owner-Fragen)
ABHAENGIGKEIT/FLAECHE: FROZEN-Liste (Fund 49); Artefakte teils stale (27.07. vs XML 02.08.)

### [w76o2kmbd.json] 51
GEGENSTAND: Konsolidierungs-Stand-Korrektur (nach den Scopes): super dev=46824fba, ce dev=b241a272; super-Gitlink auf ce zeigt 47c4ef1d = DRIFT gegen Checkout b241a272 (super-CI baut ce OHNE LB-6 und ohne Build-Graph-Kante 678a4487); ce origin/main 6 Commits Rueckstand, super origin/main 10; thesis beide Mounts 8e58f691, github 5 zurueck (reiner FF). Pfad-Korrektur: experiment_plan_director.hpp liegt unter libs/cache_engine/profile_facade/planner/ (Scope 1+2 zitierten builder/planner/ -- existiert nicht; Zeilennummern stimmen).
ORT: git rev-parse/ls-tree am Objekt (06.08. spaet)
SOLL/FIX: B-A Gitlink-Nachzug auf b241a272 (sofort, Minuten, Landebahn L-0); B-N main-FF beide Repos (ce 6, super 10) vor Voll-Messung; K-7: Gitlink-Bump immer LETZTER Schritt, nie eigenes Paket.
STATUS LT. QUELLE: offen (Stand 06.08.)
ABHAENGIGKEIT/FLAECHE: Bridges gaten branch:main => gegen alten Stand

### [w76o2kmbd.json] 52
GEGENSTAND: Konsolidierung R-1 [ROT]: Voll-Messung braucht ~72 Tage auf 2 Lanes (524.288 x 216 Mess-Settings je Binary x 0,1094 s; Fach-Rechnung aus all_axes_golden: workloads 6 x sweep 4 x hw_prefetcher 3 x threads 1 x repetitions 3 = 216; 109,4 ms Mittel aus 16 d03-Zeilen, UNTERGRENZE), verfuegbar 40 Tage -- Faktor ~1,8.
ORT: profile_run_entry.hpp:365-380,:165-166; d03-CSV total_ns
SOLL/FIX: Wege: (A) 320er-Auswahl Faecher voll 2,1 h; (B) alle Binaries Faecher flach(9) ~3,0 d; (C) beides gestaffelt ~3,1 d = EMPFEHLUNG; (D) Vollmenge 71,7 d passt nicht. Entscheid VOR DEM ERSTEN BATCH (formt die XML-Trennung).
STATUS LT. QUELLE: offen (Owner-Entscheid [ROT])
ABHAENGIGKEIT/FLAECHE: R-2, B-D, B-H

### [w76o2kmbd.json] 53
GEGENSTAND: Konsolidierung 1.1: 13 von 21 Rueckfragen-Kandidaten aus dem Plan beantwortet/eliminiert (E-1 PMC fixen; E-2 allow_failure JA entfernen; E-3 Bestandslog JA; E-4 Batch=Binary; E-5 E-18-Ziel development; E-6 A1 gelandet; E-7 Fingerprint traegt Mess-Achse JA per Owner-Prinzip, Umfang offen; E-8 zweiter Mount kein Owner-Entscheid noetig, kein Remote geloescht; E-9 thesis-github-Push konfliktfrei; E-10 E4_CAP Aufraeumpass; E-11 V-11 PAT-Rotation terminiert "nach Messfenster"; E-12 O-3 Loesch-GO by design offen; E-13 Bridge main entschieden dagegen).
ORT: Konsolidierung 1.1
SOLL/FIX: verbleibende echte Owner-Fragen: R-1 Mess-Umfang [ROT], R-2 Form der XML-Trennung [ROT], R-3 Fingerprint-Reichweite/Release-Nachmessung [ROT], R-4 Bau-Umfang [GELB], R-5 Anhang-Tiefe [GRUEN], R-6 Ebene-B-Push [GELB].
STATUS LT. QUELLE: teilweise (13 beantwortet, 6 offen)
ABHAENGIGKEIT/FLAECHE: HARTER STOPP vor L-1: R-1, R-2, R-3

### [w76o2kmbd.json] 54
GEGENSTAND: Konsolidierung M-1: Abgabe-Begriff ungeklaert -- gesamter Planbestand auf "Abgabe Fr 08.08." geschrieben, 15.09./Freitags-Kadenz nirgends verbucht (grep 0 Treffer); P0-P4-Ordnung des Registers auf falschen Termin geeicht ("groesste stille Fehlerquelle der aktuellen Planung").
ORT: Ledger (endet nachmittag-10), docs/plaene, docs/sessions
SOLL/FIX: 15.09. als Abgabe fuehren, Freitage als Ergebnis-Kadenz definieren (je Freitag: gruener Voll-Lauf + neuer Datenstand in Anhang A).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: M-3: V-11/Runner-Token-Posten auf festen Freitag ziehen (Bezugsgroesse verzehnfacht)

### [w76o2kmbd.json] 55
GEGENSTAND: Konsolidierung M-2: "die 320er XML Einstellung" existiert als Fixture und Legendenbegriff, KEIN *320*.profile.xml.
ORT: golden_fullpilot_320_binary_ids.txt; Profile-Verzeichnis
SOLL/FIX: als <measure_selection> im golden-Profil realisieren ("auf der Basis ALLER kompilierter binaries" beschreibt woertlich eine Selektion); faellt mit R-2 zusammen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: R-2/B-D

### [w76o2kmbd.json] 56
GEGENSTAND: Konsolidierung M-4: VIER entkoppelte 4096-Literale ohne koppelndes static_assert (0 Treffer): experiment_plan_director.hpp:610 kGnBatchSlice; batch_planner.hpp:51 kGnBatchSlice (ZWEITE Definition!); planer_driven_build.hpp:60 kBuildSliceGrain; source_catalog.hpp:205 kMaxMaterializableCatalogCardinality -- Zusicherung im Prosatext statt Wache.
ORT: wie gelistet
SOLL/FIX: eine Konstante, drei static_assert-gekoppelte Spiegel; Minuten; kein Blocker.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ledger-Regel 6 Fehlerklasse

### [w76o2kmbd.json] 57
GEGENSTAND: Konsolidierung Ergebnis 2: Paket-Ordnung -- (i) blockiert ersten Batch: B-A Gitlink, B-B Fingerprint-Fortpflanzung, B-C PMC-Welle, B-D XML-Trennung, B-E Mess-Batch-4096, B-F Bestandslog, B-G Audit; (ii) blockiert Voll-Messung: B-H Selektion, B-I L2/L3/Kohaerenz, B-J Phasen-Fortpflanzung, B-K V-06, B-L Ebene-B, B-M P11+Voll-Lauf, B-N main-FF; (iii) blockiert Abgabe: B-O chktex [ROT], B-P Anhang-Ehrlichkeit, B-Q M-9, B-R Mount, B-S Overleaf, B-T P2-Lager (xlsx! "wenn die Messung laeuft, ist es zu spaet"), B-U LB-6 Beweise 1+4; (iv) danach: M-8, M-15, KF-6-NTTP, E4_CAP, 4096-Kopplung, B3, B8-Zitat, V-20, NACH-ABGABE-Kette, O-3, W-11, W2.
ORT: Konsolidierung Ergebnis 2
SOLL/FIX: Klasse ALPHA (B-B, B-C, B-G + kuenftige kMeasurementToolingRegistry/load_framework-Aenderungen): ALLE IN EIN BUENDEL, EIN BUMP, VOR DEM ERSTEN BATCH. Klasse BETA (B-I, B-J): vor Flottenbau zusammen entscheiden. Rechnung: alles vorher = 1 Voll-Bau 34,4 h; ein einziger danach = 68,8 h + Entwertung aller Messdaten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: NICHT neubau-relevant (jederzeit): B-O, B-P, B-Q, B-R, B-S, B-T, B-N, B-A

### [w76o2kmbd.json] 58
GEGENSTAND: Konsolidierung Ergebnis 3 (Disjunktheit/Konflikte): K-1 B-C/B-E/B-F schreiben ALLE experiment_plan_director.hpp (:1333/:1362/:1367/:1240-1252/:952-955) => EIN PAKET; K-2 B-B vs B-F profile_run_facade (gleiche TU) => serialisieren; K-3 B-D/B-F beide profile_run_entry.hpp => serialisieren; K-4 B-O vor B-Q; K-5 B-T strikt NACH ce-Buendel; K-6 B-R allein landen; K-7 B-A immer letzter Schritt. Fuenf unbeweisbare Disjunktheiten im ce-Buendel L-1 zusammengefasst (B-B/B-F, B-D/B-F, B-T/B-F, B-I/B-J, B-G/B-B).
ORT: Konsolidierung Ergebnis 3
SOLL/FIX: Reihenfolge: L-0 B-A sofort -> [OWNER R-1/R-2/R-3 HARTER STOPP] -> L-1 ce-BUENDEL "MESS-ANLAGE" (B-B+B-C+B-D+B-E+B-F+B-G(Bau); EIN Branch, EIN Voll-Gate, EIN Dual-Review, EINE Landung, EIN Bump 3->4) -> ce main-FF(6) -> super-Bump -> super main-FF(10) -> L-2 B-M -> L-3 erster Batch (liefert B-K) -> [OWNER R-6 mit Zahl] -> [OWNER R-4] -> B-H -> L-4 Voll-Bau/Voll-Messung. super-SLOT parallel: S-1 B-O, S-2 B-Q, S-3 B-R, S-4 B-T (nach L-1). THESIS-BAHN: B-S, B-P. NICHT PARALLEL Zusatzregeln 11-15.
STATUS LT. QUELLE: offen (Plan)
ABHAENGIGKEIT/FLAECHE: Bahn-Obergrenze: 1 ce-Voll-Gate, 1 super-Slot, 1 Landebahn, n read-only

### [w76o2kmbd.json] 59
GEGENSTAND: UNBELEGT-Liste der Quelle: durchschnittliche .so-Groesse (Bezugsgroesse R-6/V-06); minio-Bestand; Ursache der PMC-Werte im d03-Korpus; Slice-Bauzeiten 19,4/32,25 min (UEBERNOMMEN); Pipeline-Nummern 15025-15043; xmllint-Praesenz prod1/prod2; Runner-Ist; dirty-Staende wt-*; erzeugender Job von measure_out_d03; ob validate_profile ein measure_axes strukturell ablehnen wuerde; ob Runner-Kapazitaet 34,4-h-Bau ohne Timeout traegt (timeout: 7d emittiert, director:1183); GitLab-Bridge-SHA-Semantik.
ORT: Scope-Grenzen-Abschnitte
SOLL/FIX: je als Messauftrag im Bau-Workflow (V-06 Erst-Batch liefert Bytes/DLL und t/TU).
STATUS LT. QUELLE: offen (UNBELEGT)
ABHAENGIGKEIT/FLAECHE: R-6, P-KAL

<!-- Selbstcheck folgt am Dateiende nach Abschluss aller 12 Dateien -->

## Datei 2: wdtdyqbmh.json (Synthese 08.08. "Haben wir etwas vergessen?", 8 Agenten, 96 Urteile: 28 erledigt / 6 gegenstandslos / 23 teilweise / 38 wirklich offen / 1 nicht pruefbar; 13 blockieren Messung, 4 Abgabe)

### [wdtdyqbmh.json] 1
GEGENSTAND: S-01/O-A: PMC-Flag im Voll-Mess-Pfad -- alle 4 cmake-Emissionen setzen -DCOMDARE_V32_ENABLE=ON, KEINE -DCOMDARE_ENABLE_PMC=ON; CMakeLists.txt:67 OFF. Kuerzel-Kollision: zweites O-A (Modi-Sequenz 07.08.) ist ENTSCHIEDEN+gelandet (ce 491fff65).
ORT: experiment_plan_director.hpp:841/877/1194/1342; wellenplan:431; ANKLAGE KK-1
SOLL/FIX: Entscheid vor jeden anderen Phase-6-Schritt ziehen; im Vorlagentext beide O-A ausschreiben. "Entscheiden BEVOR Phase 6 startet -- danach ist es irreversibel."
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: S-05 dieselbe Welle; Kuerzel-Kollisions-Register S-33

### [wdtdyqbmh.json] 2
GEGENSTAND: S-02/K-1: B5/T6-Einsammel-Naht kann nicht funktionieren -- scharfer Sammel-Aufruf auskommentiert; aktiver Zweig prueft nur if [ -d "$CI_PROJECT_DIR/measure_out" ], das Verzeichnis entsteht aber in der GRANDCHILD-Pipeline (Nesting-Tiefe 2).
ORT: super .gitlab-ci.yml:1383-1391 (auskommentiert), :1316-1329 (Grandchild)
SOLL/FIX: Ueber needs: auf die Grandchild-Artefakte umbauen, nicht ueber find im eigenen Workspace -- "sonst kommt aus Phase 6 keine einzige CSV zurueck."
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: Mess-Rueckkanal

### [wdtdyqbmh.json] 3
GEGENSTAND: S-03/K-2/G-E3: Host-Binder fehlt -- mess_bestand_doc_key/key_of/versions haben 0 Zuweisungen (12 mess_bestand-Treffer, ALLE in cache_engine_builder_iterator.hpp: Dekl :316/:317/:320, Konsum :1941/:1943/:2145/:2882/:2888); mess_bestandslog_active strukturell immer false -- messwert_registrierung.hpp schreibt im Mess-Lauf nichts, faellt erst NACH der Messung auf.
ORT: cache_engine_builder_iterator.hpp wie genannt
SOLL/FIX: Host-Binder bauen (die drei cfg-Felder aus Planer/CEB-Aufrufer setzen) BEVOR irgendein Mess-Lauf startet.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: P2-Band; S-06/K-06/KK-4

### [wdtdyqbmh.json] 4
GEGENSTAND: S-04: all_axes_golden.profile.xml ist NICHT wohlgeformtes XML -- xmllint rc=1, drei Fehler: Z.62+64 "Double hyphen within comment", Z.207 "Comment must not contain '--'"; eigener Parser ueberspringt Kommentare, die harte xmllint-Wache laeuft "in KEINEM CI-Job dieses Repos".
ORT: origin/development libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml; Wache Code/tests/xml_canonical_utils.cmake:80-84
SOLL/FIX: Drei -- in Kommentaren ersetzen UND xmllint-Wohlgeformtheits-Wache ueber alle *.profile.xml in die CI (xmllint auf prod1: /usr/bin/xmllint).
STATUS LT. QUELLE: offen (blockiert-messung; Memory-Falle reference_xml_kommentar_doppelbindestrich_falle)
ABHAENGIGKEIT/FLAECHE: golden-Profil der Abgabe-Messung

### [wdtdyqbmh.json] 5
GEGENSTAND: S-05/O-B: allow_failure: true am Job ergebnis:holen (Kopf :1364, stage planer), Anker von :1373 auf :1379 gewandert; Kontrast im selben File :254 und :455 ("Hart, kein allow_failure").
ORT: super .gitlab-ci.yml:1379
SOLL/FIX: Zusammen mit S-01 entscheiden; solange weich, geht fehlgeschlagenes Einsammeln nach mehrtaegigem Lauf gruen durch.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: O-A-Buendel

### [wdtdyqbmh.json] 6
GEGENSTAND: S-06/O-C: Faehrt der Trigger-Lauf mit COMDARE_BESTANDSLOG? Nicht am Repo entscheidbar (Runner-Env). Code-Befund entschaerft: Opt-in bestaetigt (profile_run_entry.hpp:435), Durchreichung existiert (experiment_plan_director.hpp:952-955 append_forward_var_literal) -- "laeuft still falsch, sobald jemand opt-in setzt" statt "totes Holz".
ORT: wie genannt; wellenplan:433
SOLL/FIX: Ja/Nein-Zeile vom Owner; bei JA vorher K-06/KK-4 heilen (cache_engine_builder_iterator.hpp:1658-1668, BEIDE Gates ohne Fingerprint-Bedingung).
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: Kuerzel-Kollision O-C(07.08. Pinning) ist entschieden (Ledger:7418/:7579)

### [wdtdyqbmh.json] 7
GEGENSTAND: S-07: Vier Bau-Posten der Break-Even-/PMU-Kette ohne Board-Zeile: B-2 (:4706 "vor der Voll-Messung"), B-3 (:4707 "vor der Messung (sonst Datenbruch)"), B-4 (:4708), B-6 (:4710 RAW-Events je Mikroarchitektur Zen 3/4/5 + Alder/Raptor Lake, Deep-Research-Pflicht). B-5=#28 in_progress, B-1=#33 completed.
ORT: Ledger:4705-4714; Board (65 Eintraege)
SOLL/FIX: B-2/B-3/B-4/B-6 als eigene Board-Posten "vor der Voll-Messung"; B-3 ZUERST (Schema-Posten, Nachruestung nach Messbeginn = Datenbruch).
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 8
GEGENSTAND: S-08: Bau-Menge D-2 golden-N unentschieden, Faktor 16 (131072/524288/1572864/2097152); Ist-Umfang 524.288 (4 Perms x 2^17); OE-D-12-Perm und line_size-Faktor nicht nachgezogen.
ORT: Ledger:10112, :8990-8996; source_catalog.hpp:139/:169; all_axes_golden.profile.xml:187-200
SOLL/FIX: Owner-Entscheid: "welche System-Perm-Menge, und faellt line_size hinein"; danach --check-size (S-09) darauf ansetzen.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: S-09

### [wdtdyqbmh.json] 9
GEGENSTAND: S-09: Board #21 (--check-size BAUEN) und #52 (Experiment-Groesse erheben) sind DERSELBE Posten, beide pending; Bericht belegt: kein fruehere Auftrag (Nullbefund 5 Muster); Planer und CEB linken DIESELBE Bibliothek (comdare::profile_run_facade) -- kein Prozesswechsel noetig.
ORT: 20260808-BERICHT-check-size-messkette-break-even.md (d); Ledger:11245ff
SOLL/FIX: #21+#52 verschmelzen und bauen -- ohne die Zahl ist die Bau-Menge fuer Phase 6 unbestimmt.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: S-08

### [wdtdyqbmh.json] 10
GEGENSTAND: S-10: Micro-/Macro-Messung (G2/G3) teilen EIN Compile-Gate COMDARE_CE_ENABLE_STATISTICS -- kein zweites Gate existiert (grep ENABLE_MACRO|MACRO_STATISTICS|ENABLE_G3|MACRO_MEASURE = 0); von 6 geplanten CEB-Kombinationen nur 2 herstellbar.
ORT: profile_facade/CMakeLists.txt:128; tests/unit/CMakeLists.txt:1717-1744; Ledger:11230-11243
SOLL/FIX: Eigenes CMake-Gate fuer die Macro-Ebene einziehen BEVOR die CEB-Kombinationen fuer Phase 6 gebaut werden -- sonst faehrt die Messung mit 2 statt 6 Kombinationen.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: 6-CEB-Matrix

### [wdtdyqbmh.json] 11
GEGENSTAND: S-11: TP1+4+1 (Neun-Gates-Inventur + V7.4-Beweise + E2E-.rsp-Beweis) -- zum DRITTEN Mal durchgefallen, weil der Lauf per Konstruktion "operativ, KEIN ce-Commit" ist (kein Objekt, nichts kann rot werden); Emitter existiert (test_tp1_planer_filter_iterator.cpp:1985 TP1_ANKER_OK/FAIL); L1-Blockade seit 06.08. gefallen.
ORT: Ledger:7178/:7195/:4171/:7089
SOLL/FIX: Lauf fahren UND Protokoll als Datei ins Repo (docs/audits/<datum>-TP1-FINAL-inventur.txt).
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: Muster "Posten ohne Objekt"

### [wdtdyqbmh.json] 12
GEGENSTAND: S-12/Posten 89: T6-Rebound-Leaf-Einpreisung (Allokationszahlen steigen um Organ-Anteil) -- reine Auswerte-Auflage ohne Artefakt.
ORT: wellenplan:401; PLAN-katalogposten-p2p8:239-261 (K-5)
SOLL/FIX: Einpreis-Regel JETZT in die compare-/Auswerte-Spezifikation schreiben, nicht erst beim ersten Vergleich gegen Alt-CSV.
STATUS LT. QUELLE: offen (blockiert-messung)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 13
GEGENSTAND: S-13/K-6: P2-P8 WIDE-Mess-Schema (~33 stat_-Spalten, 14 Themen) NICHT PRUEFBAR -- 52 stat_-Treffer existieren, aber welche der 33 Soll-Spalten belegt sind (144 Schema-Slots) ungediffed.
ORT: PLAN-katalogposten-p2p8:265-297
SOLL/FIX: Eigener Lauf, der die 33 Soll-Spalten gegen die Writer-Spalten diffed; Schema muss VOR der Messung stehen (sonst Datenbruch).
STATUS LT. QUELLE: nicht-pruefbar/offen
ABHAENGIGKEIT/FLAECHE: P2-Band

### [wdtdyqbmh.json] 14
GEGENSTAND: S-14: MMX-Basisfrage (blosses Token oder eigene Fingerprint-Basis c.x64{mmx...}) -- "Der falsche Schnitt stuende danach in JEDEM Fingerprint-Preimage"; 6 Zeilen static_assert-markiert; Recherche-Doc liegt, Agent lief.
ORT: Ledger:10151-10155; docs/plaene/20260807-RECHERCHE-mmx-3dnow-basis-oder-token.md
SOLL/FIX: Nach Agent-Ruecklauf Ein-Seiten-Vorlage mit Empfehlung an Owner.
STATUS LT. QUELLE: offen (blockiert-abgabe)
ABHAENGIGKEIT/FLAECHE: Fingerprint-Preimage-Zementierung

### [wdtdyqbmh.json] 15
GEGENSTAND: S-15/K-12: #46b-Restumfang (G3-Rest: XML-Bestandslog-Persistenz, avg_size-Log, Gleichverteilung/Takeover) unbeziffert -- kein Dokument schliesst K-12.
ORT: PLAN-katalogposten-p2p8:472-486
SOLL/FIX: Abgrenzungslauf an den Anfang des naechsten P2-Fensters.
STATUS LT. QUELLE: offen (blockiert-abgabe)
ABHAENGIGKEIT/FLAECHE: P2

### [wdtdyqbmh.json] 16
GEGENSTAND: S-16/N-10: 1xN-/Nx1-Matrix-Fatal im diagram_generator -- :237 prueft nur matrix.empty(); bei nx=1 emittiert :465-467 mesh/cols=1 + xtick={0,1,...,0}; kein Test.
ORT: Code/05_diagram_generator/diagram_generator.cpp:237,:465-467
SOLL/FIX: Wache + zwei Tests (1xN und Nx1) bevor Auswertung mit reduzierten Mengen faehrt (Ein-Algorithmus-Auswertung bei D-3 realistisch).
STATUS LT. QUELLE: offen (blockiert-abgabe)
ABHAENGIGKEIT/FLAECHE: P4

### [wdtdyqbmh.json] 17
GEGENSTAND: S-17/G-5: RunMethodology-Enum-Reihenfolge {Debug, Measure, Release, Compare} bildet die Owner-Stufenordnung measure->compare->release nicht ab; Widerspruch im Code nur VERMERKT (:58); Nicht-Umstellung begruendet (Ledger:8087 "stempel-/ABI-relevant").
ORT: run_methodology_registry.hpp:54-59,:62
SOLL/FIX: Owner-Entscheid, ob die Reihenfolge im SF-1-/Stempel-Fenster mitgezogen wird -- danach ABI-fest.
STATUS LT. QUELLE: offen (blockiert-abgabe, Owner-Frage)
ABHAENGIGKEIT/FLAECHE: SF-1/Stempel-Fenster

### [wdtdyqbmh.json] 18
GEGENSTAND: S-18: Atlas-Nachzug REV 5 -- 05b_uml_klassenatlas_20260805.md steht auf 98eea2e7 (05.08.), 231 Commits dahinter (FK-3/FK-4, Flag-Grammatik v2, ORG-18, A9-S3); super-Kopie gleicher Stand.
ORT: ce docs/architecture/05b_uml_klassenatlas_20260805.md:3; super docs/architektur/... (+.html)
SOLL/FIX: Neu erheben, beide Kopien (ce+super, md+html), Stand-Zeile auf aktuellen ce-SHA.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: war auf L1 gegatet, Gate verfallen

### [wdtdyqbmh.json] 19
GEGENSTAND: S-19: ce-GitHub-Spiegel-Drift = 90 Commits (Board #61 sagt "7") -- origin/main 0ef4ef4f (08.08. 13:52) vs github/main 85847715 (07.08. 08:21); super synchron 0/0.
ORT: /home/comdare/wt-ce-fk rev-list --left-right --count
SOLL/FIX: ce FF-Push github; Board #61 mit echter Zahl korrigieren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Dual-Remote-Doktrin

### [wdtdyqbmh.json] 20
GEGENSTAND: S-20: F2 "bitte pull mal Cluster git, die creds stehen dort jetzt drin" NICHT erfolgt -- lokal cd7c64d (07.08. 20:34) vs Remote 52bfc690.
ORT: /home/comdare/Projekte/Cluster
SOLL/FIX: git pull + neue Credentials gegen den Vault abgleichen (Zweizeiler).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Vault-Doktrin (nie greppen)

### [wdtdyqbmh.json] 21
GEGENSTAND: S-21/O-Token: refs/backup/pre-secret-scrub-20260802 (5ba3d03f, 776 Runner-Token) steht unveraendert auf super origin; Loeschung braucht Owner-GO.
ORT: git ls-remote origin 'refs/backup/*'
SOLL/FIX: Ein Satz an den Owner; mit GO ein Einzeiler.
STATUS LT. QUELLE: offen (Owner-GO fehlt)
ABHAENGIGKEIT/FLAECHE: feedback_remote_deletion_requires_explicit_user_authorization

### [wdtdyqbmh.json] 22
GEGENSTAND: S-22: Grundsatzfrage "darf der Lead die THESIS anfassen?" unbeantwortet, WAEHREND faktisch geschrieben wird (wt-thesis-nachzug auf b-thesis-o4-nachzug mit Commits 798e946, 99d966c, eaf7fe8).
ORT: Ledger:10116-10118; /home/comdare/wt-thesis-nachzug
SOLL/FIX: Explizite Ja/Nein-Frage vorlegen mit Hinweis auf laufende Thesis-Agenten -- entsperrt bzw. stoppt mehrere Straenge.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: reference_eigentum_thesis_privat (getrennter Rechtstraeger)

### [wdtdyqbmh.json] 23
GEGENSTAND: S-23/K-7(b): COMDARE_STORAGE_CACHE wird von ArtifactCache::from_env() NICHT gelesen (Aktivierung haengt allein an endpoint+bucket nicht leer, :271); ELSE-Zweig des Aktivierungs-Skripts unsetzt nichts (Z.62-65) -- Ebene B trotz ausgeschaltetem Schalter scharf, wenn Env die Vars traegt (Planer reicht STORAGE_CACHE durch, director:1003).
ORT: artifact_cache.hpp:232-275; scripts/comdare_storage_activation.sh:49/:53/:62-65
SOLL/FIX: Dieselben unset-Zeilen in den ELSE-Zweig -- eine Zeile, dokumentierte Inertheit stimmt wieder.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ebene B

### [wdtdyqbmh.json] 24
GEGENSTAND: S-24/T-i-1: XXE-/Entity-Bissbeweis fehlt (0 Treffer DOCTYPE|ENTITY|xxe in ce tests/); Sperre existiert nur als Skip-Logik (xml_reader.hpp:7,:73,:99).
ORT: wie genannt; wellenplan:303
SOLL/FIX: Zwei Fixtures (mit DOCTYPE/ENTITY + harmlos) + add_test, Doppelprobe, ~1 h.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 25
GEGENSTAND: S-25/T-i-2: contract:axis-version-lock -- Doppel-Definition geheilt (ce .gitlab-ci.yml:266/:662, ueberlebender Job :477-488), aber KEIN Bissbeweis ("ein gruener Job ist von einem inerten nicht zu unterscheiden").
ORT: wie genannt
SOLL/FIX: Heuristik-Header lokal minimal aendern, comdare_axis_version_lock --check fahren, ROTEN Exit als bissbeweis-Datei ablegen (Minuten).
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 26
GEGENSTAND: S-26/T-ii-2: Fingerprint-Kreuzprobe Schreib-/Lesepfad fehlt (nur zwei Einzelpfad-Proben: test_r3_mess_gate_fingerprint_biss.cpp, test_resthygiene2_organ_fingerprint.cpp).
ORT: ce tests/unit; wellenplan:306 (2-4 h)
SOLL/FIX: Roundtrip-Test: Schreiber erzeugt Sidecar -> Leser akzeptiert -> mutierte Form abgelehnt.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 27
GEGENSTAND: S-27: Stempel-/RF-Rest-Verifikation (RF-1/2/6/7/8, G2-Rest, C-3a/C-3b) + O-2-Schliessvermerk -- Auflage "ultracode-Gegenpruefung IM L1-Fenster" verstrichen (L1-Landung 86be2420 erfolgte OHNE belegten Gegenpruef-Pass).
ORT: wellenplan:364; Ledger:7040
SOLL/FIX: Neu terminieren statt verfallen lassen: ultracode-Lauf gegen RF-1/2/6/7/8 + C-3a/C-3b auf heutigem Stand.
STATUS LT. QUELLE: offen (OFFEN-UNGEPRUEFT)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 28
GEGENSTAND: S-28/G-2: persistence_target (18. Achse) hat KEINE Katalog-Zeile im Optimierungs-Katalog -- catalog_axis_from_name liefert honest-empty; Code hat bewusst nicht geraten.
ORT: axis_optimization_catalog.hpp:46,:50-51,:421
SOLL/FIX: Owner-Entscheid Min/Max/keine Richtung -- darf NICHT durch Annahme geschlossen werden.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 29
GEGENSTAND: S-29/G-4: fuenf Cluster-Entscheide Welle D offen (k-Wahl-Konsens: Gap braucht Referenz+Seed, BIC eine GMM-Variante; Linkage-Kriterium; Noise-Schwellwert; vier Skalierungs-Lesarten; vier Datensatz-Features honest-0); Bau gelandet (ce 47f6e46d/9f08a241/64299385, Merge a1d0c201) -- bewusst offen, nie vorgelegt.
ORT: Ledger:9010; 20260807-STAND-...md:95-101
SOLL/FIX: EINE gebuendelte Owner-Vorlage, fuenf Fragen je mit Default-Empfehlung.
STATUS LT. QUELLE: offen (Owner-Fragen)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 30
GEGENSTAND: S-30/G-3: drei von vier Pareto-Entscheiden ohne Schliessbeleg (MAX-Spalten im WIDE-Schema, Bruecke CSV-Spalte->Zielgroessen-Id, Default-Zielgroessenmenge); front_best_in liefert weiterhin GENAU EINEN Kandidaten (:196-198, ":33 Versand-SICHT, NICHT das Auswahl-Ergebnis").
ORT: best_binary_selector_main.cpp:169-174,:189,:196-198,:33
SOLL/FIX: Default-Zielgroessenmenge aus der XML statt aus Agenten-Setzung -- die Teilfrage, die still falsche Ergebnisse produziert.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: E-18 (Pareto-Front-Fix 1207a9c5 ist separat/erledigt)

### [wdtdyqbmh.json] 31
GEGENSTAND: S-31/G-6: Dual-Review-Pflicht (LEDGER:4114) im Wellenplan-Fenster nicht eingehalten (kein Vermerk bei 5 Landungen); Praxis laeuft inzwischen wieder (codex-*/fable-review-*/opus-review-* aktiv); Grundsatzfrage offen: gilt die Pflicht weiter oder durch Vor-Push-Wache abgeloest?
ORT: Ledger:9017-9022
SOLL/FIX: Grundsatzfrage beantworten lassen, Antwort in ARBEITSWEISE-GESAMT-DOKTRIN.
STATUS LT. QUELLE: offen (Owner-Frage)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 32
GEGENSTAND: S-32/V-14/A16: Posten-Register existiert nicht -- Posten (2)-(18)+(25)-(29) leben nur in Session-Docs; grep A16 im Ledger findet nur :12/:3321/:3330. "Voraussetzung der bindenden Nach-Abgabe-Kette" ohne Fundament.
ORT: wellenplan:424
SOLL/FIX: Posten in EINE Ledger-Sektion ueberfuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Nach-Abgabe-Kette

### [wdtdyqbmh.json] 33
GEGENSTAND: S-33 META: NEUN Kuerzel-Kollisionen (A15, O-A, D-4, R-2, F3, E18-SNAP, P-1, T-n, B-1; "P-1 bezeichnet gleichzeitig KK-5 allow_failure UND die 30 Review-TODOs") + DREI parallele B-1..B-N-Nummernkreise; "DER LEDGER IRRT IN BEIDE RICHTUNGEN ... ein Ledger-Satz ist kein Beleg" (GN-9 als offen gefuehrt obwohl superseded :7885; :7016 entlastet einen xlsx-Writer, der nicht existiert). Suchfalle: grep 'ESET' 26 Treffer, grep -w 'ESET' 0.
ORT: Ledger:9745-9752; 20260808-KANDIDATENLISTE-75:31
SOLL/FIX: Kuerzel-Register (Kuerzel | Datum | Bedeutung | Quelle) als eigene Ledger-Sektion.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: jede "ist X offen"-Suche systematisch fehleranfaellig

### [wdtdyqbmh.json] 34
GEGENSTAND: S-34: active_telemetry_is_silent() liefert hart konstant false (profile_run_facade.cpp:242-244), >=10 Profile deklarieren <telemetry silent="true">, einziger Konsument :542 laeuft nie; Disposition: KK-7 golden-brechend, GOLDEN-UPDATE-Fenster nach Abgabe.
ORT: wie genannt
SOLL/FIX: Im GOLDEN-UPDATE-Fenster mitziehen -- es fehlt nur der Termin.
STATUS LT. QUELLE: offen (disponiert nach Abgabe)
ABHAENGIGKEIT/FLAECHE: GOLDEN-UPDATE-Fenster

### [wdtdyqbmh.json] 35
GEGENSTAND: S-35/O-E: target_isa.numa_node/.page deklariert (system_axis_registry.xml:38-39), NULL Leser im Code (Gegenprobe: nur Fremd-Treffer alloc_hw bzw. slurm_launcher-eigenes Feld).
ORT: wie genannt; wellenplan:277
SOLL/FIX: Plan-eigener Vorschlag: Code nach Abgabe, EINE Doku-Zeile VOR der Abgabe -- Zeile jetzt schreiben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 36
GEGENSTAND: S-36/Board #13 Rest: fail-closed-Wache fuer numa_node/page fehlt -- validate_profile.hpp:206-210 laesst alloc_hw-Zweig mit Warnung+continue durch; :1061 prueft nur ep.target_isa.isa. (VARIANT_GATE-Haelfte geschlossen, KANDIDATENLISTE-75:150, super af314885.)
ORT: validate_profile.hpp:206-210,:1061
SOLL/FIX: Warnung -> harter Reject bei unbekannten numa_node/page-Werten.
STATUS LT. QUELLE: offen (Haelfte 1); Haelfte 2 behoben@af314885
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 37
GEGENSTAND: S-37/O-3 Loesch-GO: korrekt geparkt, kein GO gebucht; Nachfolge von G5 dokumentiert (Ledger:7040/:7240).
ORT: wellenplan:440; Board #4
SOLL/FIX: Bei naechster Owner-Vorlage eine Zeile mitfuehren.
STATUS LT. QUELLE: offen (geparkt by design)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 38
GEGENSTAND: S-38: comdare-measurement-all-Zergliederung nach Facade-Konvention -- vom Owner ZWEIMAL als "vergessen" angemahnt; 5a metrics-Transfer + 5b Struktur ohne Vollzugsbeleg; Ledger:347 = User-Gate.
ORT: Ledger:331,:347,:806,:812
SOLL/FIX: Design-Fork (welcher Diplomarbeits-Teil -> welches baseline-Modul) als Owner-Vorlage -- das Gate verlangt ihn vor jedem Byte.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: G5/#274

### [wdtdyqbmh.json] 39
GEGENSTAND: S-39/O-D: xmllint auf prod2 ungeprueft (prod1 entlastet: /usr/bin/xmllint); Wachen hart registriert, aber "in KEINEM CI-Job aufgerufen" (:38-39).
ORT: xml_canonical_utils.cmake:80-84; Code/tests/CMakeLists.txt:170/:178
SOLL/FIX: Infra fragt EINE Zeile: which xmllint auf 10.0.10.212; positiv => O-D gegenstandslos, Wachen bleiben hart.
STATUS LT. QUELLE: offen (halb)
ABHAENGIGKEIT/FLAECHE: S-04-Wache

### [wdtdyqbmh.json] 40
GEGENSTAND: S-40: perf-Rechte prod2/Intel nur ueber Job-Trace 365257 belegt (delta.available=1, cache_misses_l3=4048837, SMOKE_OK), nicht live; prod1 voll belegt (paranoid=1, amd_uncore geladen, PMU-Devices exponiert).
ORT: 20260806-ANWEISUNG-pmc-intel-perf-rechte.md:9-25
SOLL/FIX: Dieselben drei Befehle auf prod2 fahren, an die ANWEISUNG anhaengen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: PMC-Kette

### [wdtdyqbmh.json] 41
GEGENSTAND: S-41/A12/E-14: NAS -- Mount-Haelfte erledigt (backup1 19T, backup2 7.3T, comdare-buildsystem 20T, rw, fstab reboot-fest, Board #44); CI-Credentials-Haelfte NUR deklariert (.gitlab-ci.yml:690-691 Kommentar; :700-711 Ebene B/C inert wenn fehlend); Projekt-288-Vars nicht messbar (Cluster read-only).
ORT: wie genannt
SOLL/FIX: Infra-Abfrage: COMDARE_MEASUREMENT_DROP_URL/_NFS_DROP_TOKEN + MINIO_ACCESS_KEY/SECRET_KEY in Projekt 288 gesetzt? Mount-Teil nicht mehr als A12 mitzaehlen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: S-42

### [wdtdyqbmh.json] 42
GEGENSTAND: S-42: NAS/Storage Ebene B/C -- Code-Seite NICHT 0 (artifact_cache_transport.hpp INERT-NEUTRAL; lager_pfad_grammatik "Baum-Pfad == minio-Objekt-Praefix"); ungeloester Kern = Transport-Widerspruch POSIX-Mount-Copy vs HTTPS-PUT ueber Filterpod.
ORT: wie genannt
SOLL/FIX: Sechs Entscheide auf die EINE blockierende Frage eindampfen und dem A8-nas-infra-Agenten als Auftrag geben.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Ebene-B-Push

### [wdtdyqbmh.json] 43
GEGENSTAND: S-43/K-14: 77/78-Auflagen -- Code-Haelfte erledigt (ce 442c960b, axis_filter_xor.hpp:45/:55/:60 FN-Aussage verbatim); THESIS-Haelfte fehlt: 0 Treffer Falsch-Negativ|false negative|no-FN in allen *.tex; D_building_block_matrix.tex:642 beschreibt Xor-Filter nur ueber Falsch-Positiv-Rate.
ORT: wie genannt; Ledger:6984
SOLL/FIX: Satz zur FN-Eigenschaft (30/256 gemessen) in Anhang D, DE fuehrend, EN nachziehen -- "sonst steht in der Abgabe eine Membership-Struktur ohne ihre schaerfste Einschraenkung."
STATUS LT. QUELLE: teilweise (Code behoben@442c960b, Thesis offen)
ABHAENGIGKEIT/FLAECHE: Thesis-Pflicht

### [wdtdyqbmh.json] 44
GEGENSTAND: S-44/E-1: Thesis-KAPITEL kennen die 3-Typen-Taxonomie nicht (Anhang D vollstaendig nachgezogen; Kapitel 02/04/05/07/08 je 0 Treffer 'Mess-Achse').
ORT: kapitel/de/*; anhang/de/D_building_block_matrix.tex
SOLL/FIX: Kapitel 04/05/07 auf die Anhang-D-Taxonomie nachziehen (DE fuehrend, EN nachziehen); Agenten Thesis-DE-EN-Drift/A4-thesis-nachzug haben das Feld.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: S-22 (Thesis-Befugnisfrage)

### [wdtdyqbmh.json] 45
GEGENSTAND: S-45/E18-SNAP: gebaut (bda34e79 auf b-e18-snap: measurement/thesis_compiles/<TS>/ mit PDF+compile-export.txt+QUELLSTAND.txt, sha256, Schalter AF_COMPILE_SNAPSHOT/AF_SNAPSHOT_ROOT), aber "NICHT LANDEN"-Verdikt steht; .gitlab-ci.yml-Anteil nur als unangewandter Patch.
ORT: Ledger:7045-7046; wellenplan 1.7
SOLL/FIX: Vor dem Trigger entscheiden, ob E18-SNAP landet.
STATUS LT. QUELLE: offen (Lande-Gate)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 46
GEGENSTAND: S-46/A15-Reconcile: von 43 Positionen sind 19 OFFEN + 5 OWNER-FRAGEN (5 vollzogen, 5 superseded, 7 Duplikat, 2 nicht entscheidbar) -- die 19 stehen nur im Reconcile-Dokument, nicht im Board.
ORT: 20260807-RECONCILE-43-positionen-disposition.md 1.1 (Mess-Stand super c26f8a77; Audit-Zeilennummern ab 7250 verschoben)
SOLL/FIX: Die 19 ins Board heben; die 5 Owner-Fragen in die naechste Vorlage.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 47
GEGENSTAND: S-47/E-21: STACK-/LIFO-Form + Verbose fehlt in ARBEITSWEISE-GESAMT-DOKTRIN.md v3.1 (0 Treffer), lebt nur in Ledger:179 (V7.6). E-19 erledigt (I112-Doku); E-02 teilweise (prt-art-Ledger nicht pruefbar).
ORT: docs/ARBEITSWEISE-GESAMT-DOKTRIN.md
SOLL/FIX: E-21 in die Doktrin v3.1 aufnehmen; prt-art-Ledger bei Gelegenheit gegenpruefen.
STATUS LT. QUELLE: offen (E-21), teilweise (E-02)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 48
GEGENSTAND: S-48: A14/FF0-Abgabe-Blocker-Lage widerlegt (06_fazit.tex:22-33 beantwortet FF0; Anhaenge B/E kein Stub); GN-9 superseded (Ledger:7885 ist der Fehler). Echter Rest: (i) Bezifferung nach E2E-Laeufen je Plattform, (ii) Mess-Manifest/Provenance (:9765 Reconcile "nicht geschafft").
ORT: 20260806-DELTA-abc-straenge-vs-neue-wellen.md:244
SOLL/FIX: Ledger:7885 additiv korrigieren; Mess-Manifest/Provenance als eigenen Vor-Abgabe-Posten fuehren.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: V-02-Rest

### [wdtdyqbmh.json] 49
GEGENSTAND: S-49/DELTA C: atomic128 fehlt UNBEGRUENDET in golden-XML system_axes (target_isa hat Begruendung :185, atomic128 nicht -- obwohl glied-eigenes Fingerprint-Feld: system_version_suffix.hpp:201/:214/:270, toolchain_stamp_naht.hpp:215).
ORT: all_axes_golden.profile.xml:187-200
SOLL/FIX: Begruendungszeile nachziehen ODER Achse aufnehmen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Fingerprint

### [wdtdyqbmh.json] 50
GEGENSTAND: S-50: P2-Band-Pauschalaussage "gebaut ist davon nichts" ist FALSCH -- Lager-Kaskaden+xlsx-Geruest GEBAUT (ce 907b0433/60e03d66/cf871f92, ergebnis_mappe.hpp 430 Z. + xlsx_ergebnis_writer.cpp 213 Z.), 77/78 GELANDET (442c960b), B-5 in Arbeit (#28), G-E3 UNGEBAUT, #46b ungeprueft; P2-Band hat keinen Ledger-Besitzer (grep 'P2-Band' = 0).
ORT: wie genannt; PLAN-katalogposten-p2p8:652-658
SOLL/FIX: P2-Band als Ledger-Zeile mit Einzel-Status anlegen (a/b erledigt, c laeuft, d offen, e ungeprueft).
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: verdeckt den echten Rest G-E3 (S-03)

### [wdtdyqbmh.json] 51
GEGENSTAND: S-51: LB-6 Stufe 2 fehlt -- Binary-Stub-Haelfte der Dummy-Strategie (kompilierte leere Tier-Binary mit nur dem Stempel-Interface); Haelfte 1 gebaut (b241a272, oeb_stempel_zeilen.hpp -- Text-Literale); Ledger:5173 "NICHT GEBAUT: LB-4, LB-5, LB-6 Stufen ueber 1 hinaus."
ORT: tests/unit/support/oeb_stempel_zeilen.hpp; test_lb0_lager_pfad_grammatik.cpp:558/:586
SOLL/FIX: SHARED-Target nach Muster tests/unit/CMakeLists.txt:305 (comdare_perm_mock_test), Stempel-Block zeilenweise gegen den Erzeuger geprueft.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: OE-B/Lager-Tests

### [wdtdyqbmh.json] 52
GEGENSTAND: S-52/O-4: M-8/M-9/M-15 -- 0 Code-Treffer; Welch nur in apps/f15_compare (haengt an keinem CI-Job); Owner-KERN 08.08. (Transkript L16957) verlangt fuer den Anhang "nicht die rohen Messwerte ... sondern deren Auswertung von Break-even Punkten" = M-8/M-9-Klasse -- Default "NACH-ABGABE" faktisch ueberholt, O-4 nirgends als beantwortet gebucht.
ORT: Ledger:6608; Board #45/#46
SOLL/FIX: O-4 als beantwortet buchen, M-8/M-9/M-15 unter Board #45/#46 terminieren.
STATUS LT. QUELLE: offen (Buchung + Bau)
ABHAENGIGKEIT/FLAECHE: Anhang A

### [wdtdyqbmh.json] 53
GEGENSTAND: S-53/Board #16: Zahl veraltet -- real hoechstens SECHS offene Owner-Entscheide (G-1..G-6; G-7 sofort erledigt; R-3 am 08.08. beantwortet: Ledger:11484ff, super 3326ac7a, ce cf871f92; G-1 laut E-27 erledigt).
ORT: Ledger:9003,:9023
SOLL/FIX: Board #16 umschreiben, je einen Ledger-Anker anhaengen.
STATUS LT. QUELLE: offen (Buchung)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 54
GEGENSTAND: S-54: Post-v3-Anforderungsblock (Planer/CEB/Driver-Verantwortlichkeiten, Planer-CLI mit Status-Logging, XML-manueller Fahrmodus) -- persistiert (Memory), Bau verteilt (#21/#52/#60/#63), nicht abgearbeitet.
ORT: Board #21/#52/#60/#63; ce cc028e1d (#60 Soll-Design)
SOLL/FIX: Post-v3-Dachzeile ueber #21/#52/#60/#63 beim naechsten Board-Sweep.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 55
GEGENSTAND: S-55: aus "Variante a"-Paket ohne Schliessbeleg NUR noch: Posten 74 (OOM-Rohdaten-Route) und KF-6 (kLbufBytes). Rest belegt geliefert (Ledger:7205/:7207; 77/78 gelandet).
ORT: Ledger:7269
SOLL/FIX: Nur diese beiden einzeln abschliessen.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: Hinweis: Datei-1-Quelle (Scope 3/B6) meldet kLbufBytes-OOB als GELANDET -- Konflikt der Quellen, Designer klaeren

### [wdtdyqbmh.json] 56
GEGENSTAND: S-56/B13: L18-ETA-Neustart unter neuem Namen erfolgt (wt-ce-eta, Branch bau/a5-eta-kalibrierung, Agent Bau-A5-ETA), Pflicht-Schritt 1 (Re-Anker-Pass aller W5-Zeilen-Anker) ungeprueft.
ORT: /home/comdare/wt-ce-eta
SOLL/FIX: Beim Ruecklauf pruefen, ob der Re-Anker-Pass gelaufen ist -- er war die Bedingung des Neustarts.
STATUS LT. QUELLE: teilweise
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 57
GEGENSTAND: Randnotizen S-57..S-63: S-57 Tools->minio-Lagerhaltung (Owner 23.07., L21-Zeile fehlt); S-58 Tool-Kartierung 4 Repos (Owner 14.07. "bitte persistiere da", nie ausgefuehrt); S-59 Odroid-H4-Runner reaktivieren + Tag-Mismatch baremetal/bare-metal (grep odroid = 0 in beiden CI); S-60 O-F 234-V-b Shaped-Emission ohne Produktiv-Aufrufer (anschliessen oder VORHALTUNG nach Muster a06eb912); S-61 X-31/AP-10 DREI referenzlose using-SearchAlgo-Aliase (abi_adapter.hpp:595/:710/:819; der vierte :2420 ist benutzt); S-62 vierte OS-Unter-Achse "Update-Zustand" fehlt (system_axis_registry.xml:42-48 fuehrt drei); S-63 Board-#53-Beleg-SHA falsch (61730ff4 statt cf871f92).
ORT: je wie genannt
SOLL/FIX: je wie genannt (S-57+S-58 als EINE L21-Zeile; S-61 drei Zeilen entfernen; S-62 eine Zeile; S-63 SHA korrigieren).
STATUS LT. QUELLE: offen (Randnotizen)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 58
GEGENSTAND: Entlastungen mit Restzweifel/Detail (Quittungen): E-03 NAS-8TB erfuellt ueber ANDERES Volume desselben PR4100 (Memory-Anker "F1: nur 3,6T frei" widerlegt); E-08 Fingerprint-Neuanker Option A VOLLZOGEN (anatomy_fingerprint.hpp:116 format=4, :416 NEUN Glieder, Overlay scharf c7158b2b/a2b928eb, Pipeline 15250) -- WICHTIG: ueberholt Datei-1-Stand (dort Format 3/8 Glieder); E-12/E-14 xlsx-Writer gebaut+Blattform entschieden (cf871f92, 60e03d66, 10988324, 61730ff4, Board #53) -- ueberholt Datei-1-B12-Behauptung "kein Writer"; E-27 G-1 sechs STOPP-Gates gebucht+gebaut (a2b928eb; E-A/E-B fielen ANDERS aus als Lead-Empfehlung); E-29 scheduling-Praemisse war INVERTIERT (Owner WILL es unter target_isa); G-05 cpe-Grammatik existiert nicht mehr (Neubau 5060489e, 422/422); 3.3 Korrektur: axis_inventory.tex = erledigt (Build-Zeit-Erzeugnis), seg_attribution.tex = gegenstandslos (kein Erzeuger).
ORT: je wie genannt
SOLL/FIX: Designer: diese Entlastungen als STAND-KORREKTUREN gegen aeltere Quellen (insb. w76o2kmbd) verwenden.
STATUS LT. QUELLE: behoben@diverse (wie gelistet)
ABHAENGIGKEIT/FLAECHE: Konflikt mit Datei-1-Staenden (Format 3 vs 4; xlsx-Writer)

### [wdtdyqbmh.json] 59
GEGENSTAND: Pruefluecken der Synthese (5.1-5.10): 300-MB-Session Mitte (14.07.-04.08.) nur per 6-Stichwort-Grep (Umlaut-Doppelung nicht dokumentiert); Assistant-Turns GAR NICHT gelesen (Klasse "Zusage ohne Einloesung" strukturell unterbelegt); 4 kleine .jsonl ungeoeffnet; prod2 nicht messbar; Projekt-288-CI-Vars nicht einsehbar; prt-art-Ledger fehlt in allen Baeumen; Codex-MCP-Logs unzugaenglich; K-6 nicht gediffed; Board bewegliches Ziel (>70 Agenten parallel); Ledger nur mit Datums-/Kuerzel-Disambiguierung als Quelle tauglich.
ORT: Synthese Par.5
SOLL/FIX: Luecken als solche fuehren; keine Vollstaendigkeits-Behauptung ableiten.
STATUS LT. QUELLE: nur-hinweis (Grenzen)
ABHAENGIGKEIT/FLAECHE: -

### [wdtdyqbmh.json] 60
GEGENSTAND: Muster-Diagnose der Synthese: "Erledigung wird erzaehlt, nicht gemessen" -- Posten ueberlebt nur mit Objekt, das von selbst rot werden kann; vier Wahrheitsquellen (Transkript/Board/Ledger/Docs), KEINES fuehrt. Drei Gegenmassnahmen: (1) jeder Posten bekommt ein Objekt (kein "operativ, kein Commit"), (2) jede Wache bekommt einen Bissbeweis, (3) Kuerzel-Register.
ORT: Synthese Par.4
SOLL/FIX: die drei Gegenmassnahmen in dieser Reihenfolge.
STATUS LT. QUELLE: offen (Prozess-Auflage)
ABHAENGIGKEIT/FLAECHE: S-11, S-24, S-25, S-33

## Datei 3: wu5ujw3xn.json (M-1 Identitaetsnaht-Workflow, 9 Agenten, Worktree /home/comdare/wt-m1-naht, Branch b-m1-identitaetsnaht; Basis ce b241a272; VERDIKT LANDEBEREIT, HEAD 4fdedbbf NICHT gepusht/gemergt lt. Quelle)

### [wu5ujw3xn.json] 1
GEGENSTAND: Kern-Korrektur des Auftrags: Mess-Achse hatte 0 funktionale Konsumenten -- perm_mess_defines() war mess-achsen-blind (drei Mess-Defines als Literale); Format-Bump 3->4 NICHT noetig (alle Heilungen fuellen bestehende Glieder mit dem richtigen WERT).
ORT: profile_run_facade.cpp:273-297; Kanal: perm_compile_flags() (:409-420) -> 4x make_gpp_compile_fn -> build_orchestrator.hpp:878 @rsp
SOLL/FIX: D-1 gebaut@b9fd81ff: neue mess_achsen_naht.hpp -- EINE Aufloesung (resolve_live_measurement_combo_legend), ZWEI Verbraucher (Stempel Glied [3] + Bau); Define-Vektoren je Legende ([wallclock] ohne CE_ENABLE_STATISTICS etc.).
STATUS LT. QUELLE: behoben@b9fd81ff (auf b-m1-identitaetsnaht, ungelandet lt. Quelle)
ABHAENGIGKEIT/FLAECHE: Wurzel von D-1: Trennlinie war nicht baubar -- 2 ungeschuetzte mig_organ_.reset() (STATISTICS-Member in MEASUREMENT_ON-Bloecken) geheilt mit if constexpr requires; macro/micro sind heute NICHT trennbar (G2/G3 teilen ein Gate) -- G3-Herausloesung ist eigenes Folgepaket

### [wu5ujw3xn.json] 2
GEGENSTAND: Tooling-Semantik G1/G2/G3 erhoben: [wallclock]=G1 (nur IDriveableTier+IMeasurableWorkload, Hot-Path = konstitutive Kette {T0,T4,T5,T6}); [macro]=G1+G2 (Observer); [micro]=G1+G2+G3 (22 Segment-Timer) = heutiger Voll-Ausbau. WICHTIG: micro ist NICHT PMC-im-Tier (perf_event|rdtsc in anatomy/ = 0 Treffer; PMC lebt host-seitig).
ORT: measurement_tooling_registry.hpp:29-32; measurement_axis_registry.xml (collector-Achse); abi_adapter.hpp:389-397 (Konstitutiv-Matrix), 30x MEASUREMENT_ON, 10x CE_ENABLE_STATISTICS
SOLL/FIX: O-1 (Owner): Ist die G1/G2/G3-Zuordnung die gewollte Semantik? micro hat auf Tier-Stufe kleinere Wirkung als seine Registry-Zeile suggeriert.
STATUS LT. QUELLE: offen (Owner-Frage O-1)
ABHAENGIGKEIT/FLAECHE: Stufen-Doktrin; PmcSystemAxis = reine Host-Kollektor-Wahl

### [wu5ujw3xn.json] 3
GEGENSTAND: D-4: CEB-Schluessel renderte das ANGEBOT statt der WAHL -- kCebFingerprint hing an nichts, was COMDARE_MEASUREMENT_COMBO_CT kennt; vier verschieden einkompilierte CEBs -> EIN Schluessel (004251f4...); ceb_key_sha512 hat NULL Lese-Stellen (reine Provenienz).
ORT: ceb_version_stamp.hpp:95/:118/:159-161/:199-201; Konsument profile_run_facade.cpp:901->bestandslog_document.hpp:256
SOLL/FIX: behoben@62a5b6f7: consteval-Filter ueber NTTP-Traeger CebComboLegend, EINE Zerlegung (ceb_tooling_list) fuer Laenge+Renderer (Zwillings-Schleifen-Falle); ODR-Falle O-2 geschlossen fail-closed (INTERFACE-Ziel comdare_measurement_combo_ct + COMDARE_MEASUREMENT_COMBO_CT_WIRED + #error); Drift-Guard umgestellt statt geloescht; Biss 21 Paare/0 Kollisionen + ROT-NACHWEIS 21/21; End-to-end an echter CEB-Binary verifiziert; kein Skip-Gate (bewusst, 3 Gruende -- fail-open-Gefahr); Bestandslog KEINE Entwertung ([all]-Default byte-identisch 004251f4...).
STATUS LT. QUELLE: behoben@62a5b6f7 (ungelandet lt. Quelle)
ABHAENGIGKEIT/FLAECHE: Ueberunterscheidung permutierter Legenden ([wallclock,micro] vs [micro,wallclock] verschiedene Schluessel) = benannte eigene Scheibe mit Owner-Entscheid (Byte-Ereignis am Tier-Preimage)

### [wu5ujw3xn.json] 4
GEGENSTAND: D-2: CEB<->Tier-Tooling-Konsistenz-Vertrag (LEDGER:3319) hat NIE existiert -- das GESAMTE Zeilen-Tripel des AnatomyVersionLines-POD (organ/system/measurement_line) hat 0 produktive Leser; produktive Identitaets-Strecke laeuft nur ueber den Fingerprint.
ORT: anatomy_module_abi_v1_decl.hpp:193-194,:221-222; mess_interface_testate.hpp
SOLL/FIX: behoben@246b2793: neues Gate builder/pruef_dock/mess_konsistenz_gate.hpp (Sibling), verdrahtet an BEIDEN Ladestellen (measure_one_binary Schritt 2b VOR acquire_search_algorithm_drive; pruef_only); vergleicht die ZEILE byte-gleich (nicht Tooling-Menge -- sonst Versions-Sprung unsichtbar); fail-closed 6 Fehlerklassen (Layout-Gate VOR Feldzugriff wegen -16-Offset-Falle); Falle vermieden: entries-Zaehlung Ebene-0 gegen Ebene-0 via stamp_entry_meta_level. Nebenbefund geschlossen: Experiment-Weg reichte GAR KEINEN Mess-Stempel durch (project_experiment_to_sota_passes ohne Stempel -- nimmt ihn jetzt append-only, Default leer == Identitaet).
STATUS LT. QUELLE: behoben@246b2793 (ungelandet lt. Quelle)
ABHAENGIGKEIT/FLAECHE: Organ-/System-Zwillinge = DIESELBE nie gebaute Bruecke, EIGENE Scheibe (offen)

### [wu5ujw3xn.json] 5
GEGENSTAND: Verify-LUECKE (Verdikt 0): Der #else-Zweig von resolve_live_measurement_combo_legend macht Stufe 2 zur LAUFZEIT-Stufe -- Default-CEB (ohne CT-Define) liest std::getenv(COMDARE_MEASUREMENT_COMBO): vier verschiedene Tier-Ausstattungen aus EINER CEB, EIN ceb_key, KEIN Wurf; D-1 hat die Env vom Stempel- auf den Bau-Kanal AUSGEWEITET; D-2-Gate kann es nicht fangen (SOLL und IST aus derselben Env, selbstkonsistent ok).
ORT: mess_achsen_naht.hpp:227 (#else getenv), Wachen :217/:223 nur im #ifdef; CMakeLists.txt:157-165; TierCmakeGraphBuilder emittiert die Env real (director:1656-1658), aeusserer Configure nur Hinweis-Echo (:460-463)
SOLL/FIX: Vorschlag (dann als H-A gebaut): #else-Zweig fail-loud, sobald Env eine spezifische (nicht-[all]) Combo nennt ohne CT-Define -- Fehlerklasse konfiguration_widerspruch; [all]/ungesetzt bleibt byte-stabiler Default.
STATUS LT. QUELLE: behoben@8f70898a (H-A, ROT-NACHWEIS 22 ERR)
ABHAENGIGKEIT/FLAECHE: Owner-KERN F2 (Stufen-Doktrin CEB=CT-EINBAU)

### [wu5ujw3xn.json] 6
GEGENSTAND: Verify-LUECKE-1 (Verdikt 1): Registry-Version eines Toolings, das NICHT in der Combo steht, aber dessen Gate einkompiliert IST -- jede [macro]-Binary traegt den Wallclock-Messcode (G1), Glied [3] nennt ihn nicht; wallclock-Versions-Bump v1->v2: Tier-OBJEKT aendert sich, tier_fp und ceb_key UNVERAENDERT => dll_is_current falsch-current ueber Mess-Code-Versionsgrenze (Owner-KERN F2 verletzt).
ORT: mess_achsen_naht.hpp (G1-Wortlaut); Reproduktion mit Registry-Bump gemessen
SOLL/FIX: behoben@8f70898a (H-1): Combo ohne wallclock => Wurf (G1 IST das wallclock-Instrument); ROT-NACHWEIS 8 ERR.
STATUS LT. QUELLE: behoben@8f70898a
ABHAENGIGKEIT/FLAECHE: Preimage traegt bestellte Menge, nicht tatsaechliche Ausstattung (Fehlerklasse)

### [wu5ujw3xn.json] 7
GEGENSTAND: Verify-LUECKE-2 (die schwerere): PMC an/aus = gleicher Schluessel, andere Zahlen -- ENABLE_PMC OFF/ON: NullPmcSource vs LinuxPerfPmcSource, cache_misses_l1 0 vs 1.898.596, Glied [3] und ceb_key IDENTISCH; PMC steht in KEINEM Identitaets-Glied (0 Treffer in ceb_version_stamp/anatomy_fingerprint/toolchain_stamp_glied; tel-Feld aus telemetry_is_system_axis, nicht PMC); auch die PMC-Invariante auf development (4fd42896) schliesst das nicht.
ORT: CMakeLists.txt:67 (Wurzel add_compile_definitions)
SOLL/FIX: teilweise behoben@8f70898a (H-2, EINSEITIG: micro einkompiliert => PMC muss einkompiliert sein; symmetrische Wache VERWORFEN weil development M-2/P-PMC-1 (8894d983) -DCOMDARE_ENABLE_PMC=ON fuer JEDE Combo emittiert -- haette [wallclock] unbaubar gemacht, F9-Widerspruch). REST: hand-konfigurierte CEB [wallclock]+PMC=ON bleibt benannte Grenze -- sauber schliessen = PMC als Identitaets-Glied = Byte-Ereignis mit Owner-Entscheid.
STATUS LT. QUELLE: teilweise (H-2 einseitig; PMC-Identitaets-Glied offen, Owner-Entscheid)
ABHAENGIGKEIT/FLAECHE: Owner-KERN F6; deckt sich mit Datei-1 R-1 (Scope 2) / B-B

### [wu5ujw3xn.json] 8
GEGENSTAND: Verify-LUECKE (Verdikt 2/B): Der Luegen-Stempel wandert in die MESSDATEN -- [wallclock]-Binary traegt IObservableTier (JA), tier_observe-Rumpf komplett unter #ifdef CE_ENABLE_STATISTICS => Snapshot leer; perm_runner setzt unified_real=true BEDINGUNGSLOS => in jede stat_-Spalte wird literal 0 geschrieben statt n/a; auch tier_fill_level=0 und observable_axes=0 sachlich falsch (Zuweisungen ausserhalb des Gates werden nie gerufen); "eine [wallclock]-Messzeile ist von einer echten Messung eines leeren Tiers nicht unterscheidbar"; D-1+D-2+D-4-Kette gibt den Lauf GRUEN frei. Diese Scheibe hat die Gefahr ERZEUGT (vorher war der Zustand unerreichbar).
ORT: abi_adapter.hpp:2071,:1711-1713; harness/perm_runner.hpp:225-226,:334-335; cache_engine_builder_iterator.hpp:723-731 (n/a-Alternative existiert, unerreichbar)
SOLL/FIX: behoben@8f70898a (H-B): unified_real konjugiert mit der Ausstattung; 13 Observer-Zellen gewacht; ROT-NACHWEIS 18 ERR/13 Null-Luegen; Selbstkorrekturen des Testers dokumentiert (falsche Spaltennamen vom NENNER gefangen; Rot-Nachweis auf Produktions-Form geschaerft).
STATUS LT. QUELLE: behoben@8f70898a
ABHAENGIGKEIT/FLAECHE: O-3 des Bau-Berichts (CSV n/a statt 0) -- Treiber liegt im super-Repo, dort NICHT Teil dieses Scans (Rest offen?)

### [wu5ujw3xn.json] 9
GEGENSTAND: Verify tabu-und-pins (Verdikt 3): HAELT -- TABU 0 Dateien, Preimage/ABI unberuehrt, Default-ceb_key byte-gleich dev vs branch; 416/416. Zwei Rand-Beobachtungen: B-1 STALE NEGATIV-LISTE: docs/architecture/20260804-e24_g8_negativliste_gesperrte_abi_flaechen.md:69/:258 sagt fingerprint_format=2/6 Glieder -- Ist ist 3/8 (Doku-Nachzug faellig, vorbestehend); B-2 Objekt-Cache-Key deckt den Define-Vektor nicht (+mtool= aus Env, nicht aus Compile-Kommando) -- prae-D-1-Objekt unter gleichem +mtool waere Cache-Treffer trotz anderem Kommando; heute folgenlos (0 .fingerprint), auf .so-Ebene fail-closed gedeckt; VOR dem ersten Nicht-[all]-Batch auf Maschine mit warmem Objekt-Cache benennen.
ORT: wie genannt; artifact_cache.hpp:246
SOLL/FIX: B-1: Negativ-Liste nachziehen; B-2: vor erstem Nicht-[all]-Batch adressieren.
STATUS LT. QUELLE: offen (beide Rand-Beobachtungen)
ABHAENGIGKEIT/FLAECHE: -

### [wu5ujw3xn.json] 10
GEGENSTAND: Gate-Verdikt LANDEBEREIT: Paket aendert Preimage-FORMAT nicht (Format 3, Glied-Zahl/-Ordnung unveraendert, abi/-Dateien sha-identisch) => Landung NICHT fensterkritisch; 418/418 (413 warm + exakt die 5 Paket-Tests); DIFF-HYGIENE gruen NACH Heilung von 5 Spaltenbreiten-Verstoessen aus D-4/D-2 (89bf2ee6 -- deren Berichte "sauber" meldeten, weil nur eigener Commit geprueft); cf22 GEFAHREN (clang-format 22.1.8 IST vorhanden unter /tmp/cfmt/usr/lib/llvm-22/bin -- Vorberichte "nicht installiert" widerlegt), Commit 4fdedbbf; test_rcu flakt (2/14 unter Parallel-Last, vorbestehend, byte-identisch zu dev).
ORT: Commits development..HEAD: 4fdedbbf, 89bf2ee6, c637f7aa (Merge 2b5ecd29), 8f70898a, 246b2793, 62a5b6f7, b9fd81ff
SOLL/FIX: Landung des Pakets (Merge, nie Rebase); danach die zwei offenen Byte-Ereignisse mit Owner-Entscheid: (a) PMC als Identitaets-Glied, (b) Kanonisierung permutierter Legenden.
STATUS LT. QUELLE: offen (landebereit, NICHT gelandet lt. Quelle -- Designer: aktuellen Stand am Objekt pruefen)
ABHAENGIGKEIT/FLAECHE: development zog waehrend der Arbeit auf 2b5ecd29/fb9aefdc/8894d983 -- merge-tree konfliktfrei (read-only geprueft)

### [wu5ujw3xn.json] 11
GEGENSTAND: Offene Rest-Punkte des M-1-Pakets: (1) [wallclock]-Baubeweis deckt 73/534 TUs, NICHT die golden-320 -- vor dem ersten produktiven [wallclock]-Batch Sonde ueber den vollen Kompositionssatz; (2) O-3-Rest: super-Treiber-CSV-Seite (n/a statt 0) nicht Teil dieses Scans; (3) O-4/D-2-Organ+System-Zwillings-Testat eigene Scheibe; (4) G3-Herausloesung (macro vs micro echt trennen) eigenes Folgepaket inkl. A8-S4-Praeprozessor-Wache (kennt genau zwei Gate-Makros, test_a8s4_release_pfad_neutralitaet:12-19 -- jedes neue Gate-Makro muss dort eingetragen werden).
ORT: wie genannt
SOLL/FIX: je als eigene Scheiben fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

## Datei 4: wbpblbrwp.json (Klaerungs-Workflow 06.08. spaet: ZWEIPHASIG/DREIPHASIG + "3 Typen" + Schlangen-Mechanik; 4 Agenten; Ergebnis-Doc docs/plaene/20260806-KLAERUNG-zweiphasig-dreiphasig-drei-typen.md)

### [wbpblbrwp.json] 1
GEGENSTAND: Klaerung entschieden: "3 Typen" = die drei Kettenglieder Planer/CEB/Tier-Binary == zugleich die drei Achsen-Arten Mess/System/Organ (LEDGER:2955 bindet 1:1: Planer->Mess, CEB->System, Tier->Organ); DREIPHASIG/ZWEIPHASIG = Stufen-Doktrin (Mess=3, System=2, Organ=2; LEDGER:4082, Owner-abgenommen :4095); Stufe = achsen-relativ und DEHNBAR (Hybrid macht Mess vierstufig), Typ = fester Bestand (immer 3; Hybrid ist selbst Tier-Binary, "kein dritter Dock-Typ" LEDGER:4076).
ORT: LEDGER:2955/:3095/:3097-3100/:4076/:4082/:4089/:4090/:4095/:4194; Owner-Volltext Transkript 5a19728e...jsonl:5704 und :7256/:7262
SOLL/FIX: Klaerungs-Dokument geschrieben (20260806-KLAERUNG-...md); der frueher aktenkundige Widerspruch (ANKNUEPFPUNKTE:1162 "F2: zwei Berichte widersprechen sich") ist AUFGELOEST.
STATUS LT. QUELLE: behoben (Dokument geschrieben; nicht committet zum Zeitpunkt der Quelle)
ABHAENGIGKEIT/FLAECHE: Owner-KERN F2 Fortpflanzung; ORT!=ZEIT-Memory

### [wbpblbrwp.json] 2
GEGENSTAND: WIDERLEGT und darf nicht weiterzitiert werden: die Beweisfuehrung in PLAN-messkette-ceb-observabletier.md:124 ("genau EIN zweiphasig, NULL dreiphasig in docs/") -- real 34-38 zweiphasig / 5-8 dreiphasig; Ursache CASE-SENSITIVE Suche (Owner schreibt DREIPHASIG in VERSALIEN); der Bericht zitierte den Owner-Satz, den er als nicht existent meldete, im selben Dokument.
ORT: docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md:122-125
SOLL/FIX: Beweisfuehrungs-Zeile korrigieren/deprecaten; METHODISCHE DAUER-REGEL: jede -phasig/-stufig-Suche MUSS -i tragen -- zweite, von der ugrep-Falle unabhaengige Null-Quelle.
STATUS LT. QUELLE: offen (Doku-Korrektur) / Regel etabliert
ABHAENGIGKEIT/FLAECHE: Fallen-Register

### [wbpblbrwp.json] 3
GEGENSTAND: Ketten-Mechanik am Code belegt: Planer laeuft (plan ci, rein lesend) + bestimmt CT der CEB (Combo via ceb_combo_compile_define :262-265, PMC via ceb_pmc_compile_define :296, BUILD_TYPE) + gibt RT frei (COMDARE_LANE/BUILD_PARALLEL/GOLDEN_N_RANGE/PLATFORM); CEB baut per eigenem g++-Subprozess (posix_spawnp, @rsp) die Tier UND fuehrt sie aus (run_lazy_static_then_dynamic: provision_all -> dlopen -> messen, EINE Funktion/Binary); Tier baut nichts (0 Treffer posix_spawn|system|execvp|popen in anatomy/+axes/ bei 399 Dateien; Gegenprobe builder/ = 24).
ORT: experiment_plan_director.hpp:855,:874-876,:912/914,:1233/1236,:1386/1389,:1268-1281,:1440-1449; build_orchestrator.hpp:874-916; cache_engine_builder_iterator.hpp:1607-1613,:1720,:1824,:2373-2376,:2423-2471; 02_messung_driver/CMakeLists.txt
SOLL/FIX: (Ist-Beleg, kein Fix) -- Praeziseste Einzelstelle: director:284-286 "cmake baut die CEB, die CEB baut per eigenem g++-Subprozess die Tier" (PMC = Klasse CEB-ONLY, 0 Tier-Binaries).
STATUS LT. QUELLE: nur-hinweis (belegte Mechanik)
ABHAENGIGKEIT/FLAECHE: Hinweis: Quelle zeigt PMC-Invariante + Combo-Define BEREITS in den Emissions-Zeilen (ceb_pmc_compile_define) -- ueberholt Datei-1/2-Stand "PMC-Flag fehlt in allen 4 Emissionen"; Designer: Zeitachse klaeren (M-2/P-PMC-1 landete zwischenzeitlich)

### [wbpblbrwp.json] 4
GEGENSTAND: Hybrid ist heute KEIN Glied: libs/cache_engine/hybrid/ enthaelt NUR README.md ("RESERVIERTER STUB ... KEIN CODE", nicht in CMakeLists eingehaengt, "Bau-Zeitpunkt: Auswertungsphase"); Kette DREIGLIEDRIG im Ist, dehnbar auf vier im Soll (LEDGER:4086/:4092).
ORT: libs/cache_engine/hybrid/README.md:1,:4-10,:13,:18; libs/cache_engine/CMakeLists.txt (0 Treffer hybrid, 5 add_subdirectory)
SOLL/FIX: (Ist-Beleg) -- Frage "drei- oder viergliedrig" beantwortet.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wbpblbrwp.json] 5
GEGENSTAND: FUND: die drei Typen stehen als Enum im Code und der Code nennt sie PHASEN: enum class BatchTyp { tier, ceb, planer_block } + type_phase_rank (planer_block(0)->ceb(1)->tier(2)) + is_valid_type_sequence (Rueckfall-Verbot, B13 Batch-Typ-Sequenz-Wache).
ORT: bestandslog_document.hpp:117-121; batch_planner.hpp:81-96
SOLL/FIX: Lesart (B) dem Owner vorlegen; OFFEN: type_phase_rank hat keinen geprueften produktiven Konsumenten -- wenn nur Test-/Wachen-Code, ist die Dreiheit dokumentiert-aber-inert.
STATUS LT. QUELLE: offen (Konsumenten-Nachweis + Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: -

### [wbpblbrwp.json] 6
GEGENSTAND: "Phase" hat im Korpus VIER unabhaengige Bedeutungen (Vokabel-Falle): P-I Position in der Kette (BatchTyp); P-II Arbeitsschritt eines Laufs (phase=bau|pruef|mess, director:1293/1316/1474, slice_marker.hpp:85, PhasenZaehler kompiliert/gemessen, Modi provision_only/pruef_only/voll); P-III Zwei-Phasen-Messung (save->warmup->rollback->measure, two_phase_valid); P-IV Stempel-Ausbaustufe (anatomy_version_stamp.hpp:118-125 W10-Phasen).
ORT: wie genannt
SOLL/FIX: bei jeder Phasen-Diskussion Bedeutung disambiguieren.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Kuerzel-/Vokabel-Kollisionen (S-33 in Datei 2)

### [wbpblbrwp.json] 7
GEGENSTAND: UNBELEGT/Offene Punkte der Klaerung: (1) ob planer_block die Owner-Kategorie "Typ" meint (Interpretation, kein Owner-Wort); (2) ob der Planer als "Erbauer" zaehlt, obwohl er nur emittiert (wenn "baut" = "startet Compiler", baut nur die CEB wirklich -- vierte Lesart, Owner-Rueckfrage); (3) welche Zaehlung Z-1/Z-2/Z-3/Z-5 der Owner konkret meint (kein Owner-Satz definiert "3 Typen"; einziger harter Anker: "TYPEN" in LEDGER:2955).
ORT: Befund-Abschnitte 6/10
SOLL/FIX: als Owner-Rueckfragen fuehren, falls entscheidungsrelevant.
STATUS LT. QUELLE: offen (UNBELEGT)
ABHAENGIGKEIT/FLAECHE: -

### [wbpblbrwp.json] 8
GEGENSTAND: Ledger-Lese-Falle bestaetigt: die SUPERSEDED mittag-8-Lesart steht in LEDGER:4193 NACH mittag-9 (:4080) -- chronologisch aelter; sequenzielles Lesen zeigt die falsche Form zuletzt (SUPERSEDED-Vermerk :4194 mit expliziter Datei-Reihenfolge-Falle-Warnung).
ORT: LEDGER:4193-4194
SOLL/FIX: beim Ledger-Lesen Datums-Anker pruefen, nie Positions-Reihenfolge.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

### [wbpblbrwp.json] 9
GEGENSTAND: Nullbefunde mit Nenner: "Schlange/Kopf der Schlange" als Ketten-Metapher 0/38 (alle Warteschlange); "3 Typen" im SSOT-Ledger 0; Kandidat (C) als benannte Dreiteilung 0 woertliche Belege; dreiphasig vor dem 06.08. 0 Treffer (alle 5 Fundstellen vom 06.08., selbstbezueglich); kein "Drei-Phasen"-Messtreiber als Gegenpart der Zwei-Phasen-Op-Schleife (0 bei 33837 Dateien).
ORT: Befund-Abschnitte 5/6/9; N-1..N-4
SOLL/FIX: (Absicherungs-Nullbefunde) -- Schlangen-Metapher und "3 Typen" sind NEU und noch nicht im Ledger -- Ledger-Nachtrag noetig.
STATUS LT. QUELLE: offen (Ledger-Nachtrag des neuen Owner-KERNs)
ABHAENGIGKEIT/FLAECHE: -

## Datei 5: w18xiad7j.json (WF8 Wellenkonsolidierung 12.08., KON19-00: vier /goal-Dokumente = Haupt-Referenz + strategische Reihenfolge; Ergebnis docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md + Ledger-Nachtrag KON39; Reviews 2x TRAEGT_MIT_FIXES, 22 Fixes eingearbeitet)

### [w18xiad7j.json] 1
GEGENSTAND: KON19-00 vollzogen: GOAL-v8-Dossier/Wellenplan-v2/DESIGNPLAN-tdd/ARBEITSWEISE = Haupt-Referenz; einbaufertige Nachtraege (GOAL-Kopf + 10 Marker; Wellenplan Par.17; Designplan Par.10; ARBEITSWEISE nur v3.5-Vorlage Owner-gated, 15 Punkte inkl. #15 = KON38-Regel Stempel=Fable-max).
ORT: docs/plaene/20260812-WELLENKONSOLIDIERUNG-und-strategische-reihenfolge.md; Ledger-Nachtrag KON39 (Nummer 39, weil KON37/38 vergeben -- L-8 Gegenstand vor Nummer)
SOLL/FIX: sofort_liste: (1) Plan-Dokument anlegen + KON39 VOR KON38 einfuegen + Historik + BU SOFORT; (5) Teil A einpflegen (Doku-Agent, je Datei ein Auftrag, seriell landen; ARBEITSWEISE NICHT anfassen).
STATUS LT. QUELLE: Design fertig; Einpflege-Schritte als Sofort-Liste offen
ABHAENGIGKEIT/FLAECHE: KON37-09-Auflage (Abgleich gegen KON37+KON38) vollzogen

### [w18xiad7j.json] 2
GEGENSTAND: [ROT] V-1: der ##25-DURCHSTICH (#11, DIE F1-Lieferung Fr 14.08.) war bis 12.08. mittags OHNE Besitzer -- Sofortposten; Wellenplan:1358 nennt ihn "#21" (Nummern-Kollision, Gegenstand zaehlt).
ORT: Strecke Teil B Posten 1/7/12; KON27-04
SOLL/FIX: Besitzer SOFORT setzen (Bau-Agent Opus 5 max, eigener Worktree, Strang C); FR 14.08.: ##25-DURCHSTICH LANDET.
STATUS LT. QUELLE: offen (geschlossen sobald Besitzer steht)
ABHAENGIGKEIT/FLAECHE: F1-Frist

### [w18xiad7j.json] 3
GEGENSTAND: Owner-Fragen-Restliste: NUR NOCH VIER -- OF-1 KON34-06(d) System-B-Doppelbau 17 vs 18 Dateien (Frist Mi 19.08., blockiert #24/B4-Umfang); OF-2 KON34-06(a) "32 Docks = 32 Mess-Permutationen" Bestaetigung im Subset-Modell (Fr 21.08., blockiert #7/S-19-Nenner); OF-3 O-5/K1 Lager-Identitaet der Hybrid-.so (Fr 21.08., blockiert S-15/Binaries-Kaskade W3); OF-4 O-4-Rest Festplatten-IO neuer OrganMetaMetaAxis-Typ oder Bestand T12/T17 (F3 28.08., blockiert W3-Bauumfang). 11 Alt-Fragen entfallen mit Beleg (KON37-01..-07, KON30-04 R-4 GESTRICHEN, Par.13.4c Variante B, KON29-03).
ORT: Teil C der Strecke
SOLL/FIX: HEUTE (12.08.) als EIN Paket mit v3.5-Vorlage vorlegen -- Lead direkt, kein Agent.
STATUS LT. QUELLE: offen (Owner-Vorlage)
ABHAENGIGKEIT/FLAECHE: NICHT erneut vorlegen-Liste beachten

### [w18xiad7j.json] 4
GEGENSTAND: KON37-Antworten (alle acht F-A..F-H geschlossen): KON37-01 Wallclock-SOLL = MERGE (Freigabe Planer, Schalter-Hoheit CEB, Durchfuehrung im Vertrag; "Wallclock-Umzug" = Umzug der SCHALTER-HOHEIT, kein Instrument-Umzug -- Tier-Pflicht-Wurf abi_adapter.hpp:476-491 faellt); KON37-02 Auswahl-Subsystem NEUBAU, <measurement_tooling> um Stufen-Dimension erweitert, Altes ARCHIVIERT, Korrelations-Pflicht via CT-Permutation; KON37-03 Reihenfolge = statische Anordnungs-Freigabe in der Mess-Achse (Adressierung, KEINE Nenner-Dimension; Nenner bleibt 32; KON25-03 = SOLL-Belegung, kein Typ-Verbot; S-19 PRODUZIERT die B-4-Zahl); KON37-04 T-3 (~Sa 12.09.) = echte Messung, davor alles --debug; KON37-05 E-Label-Umbenennung genehmigt, Lastsequenz = Framework-Mess-Achse; KON37-06 T-15b je 5 fuer Build UND Messung, 3 Erfolgswerte einzeln (KF-10) + E-WARMUP-Explore; KON37-07 W-6 vier Klone = Zielzustand unter Konsolidierungspflicht (#88); KON37-08 TEST-KONSOLIDIERUNG kein W7-Behaelter mehr.
ORT: Wellenplan Par.17.1
SOLL/FIX: (Referenz-Stand fuer den Designer -- Gates gefallen wie gelistet)
STATUS LT. QUELLE: behoben (beantwortet); Folge-Posten offen
ABHAENGIGKEIT/FLAECHE: -

### [w18xiad7j.json] 5
GEGENSTAND: [ROT] T-15b-IST-Defekt: die Retry-5 liegt FALSCH auf der Drift-Achse (ce 4cd1ab91) -- SOLL: ZWEITE Retry-Klammer um measure_one_binary (Build UND Messung JE 5, nicht 1+5), getrennt von Drift-max_reruns (T-15a/D4); 3 Erfolgs-Wiederholungen einzeln persistiert (nie gemittelt); Soft-Ausnahme nur fehlende Messeinrichtung (PMC) -> xlsx-Warnung; Umzug + 8-Punkte-Ripple checkpoint_speicher.hpp:119-123.
ORT: ce 4cd1ab91; Wellenplan Par.17.4; Strecke Posten 42 (#13, W2 Sa/So -- Abweichung von KON27-04-W1 DEKLARIERT)
SOLL/FIX: Umzug der 5 auf die richtige Achse + Ripple; VOR Kampagne.
STATUS LT. QUELLE: offen [ROT]
ABHAENGIGKEIT/FLAECHE: KON26-04/KON28-02/KON37-06

### [w18xiad7j.json] 6
GEGENSTAND: [ROT] IST-Verstoesse (Ledger-IV/G): measure-drop-Kanal sendet CSV unbedingt je Binary (KON32-01, "bleibt falsch") -- Heilung [W] vor Kampagne (Strecke Posten 42); S-17: LagerBaumWriter 0 Produktionsaufrufer => Messdaten-Kaskade ohne Einsortier-Pfad (KON12-03) -- S-17 [M] ab Sa 22.08. parallel, Emission endet im Lager, setzt O-9 voraus.
ORT: wie genannt
SOLL/FIX: wie gelistet; S-17 mit [STERN] Fable-max-Schluessel-Anteilen.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Trigger-Kriterium

### [w18xiad7j.json] 7
GEGENSTAND: B1-B5 (System A live / System B dormant, KON34) praezisiert: B1 XML-Konsum je Stufe (KON37-02 Registry-NEUBAU + Archiv + Korrelations-Pflicht via Filterkette KON9-06) -- landet F2; B2 Gate-Trennung G2/G3 (ohne sie "Tier je an/aus" UNERFUELLBAR) -- Reserve-WE; B3 Hybrid-Gates (erst damit 5 statt 3 Schalter; Owner-Datum VOR F2, KON34-04) -- Mo-Mi; B4 System B umstellen+anschliessen (Typliste = statische Anordnungs-Freigabe, anzahl==6 faellt; Gate nur noch OF-1) -- W2; B5 Stempel-Pflicht je Schalter ([STERN] Fable max, KON38) -- Mo-Mi, Lande-Slot ggf. A (Datei-Mengen-Explore A<->E Posten 21b VOR Mo 17.). --debug und Mess-Schalter streng disjunkt (KON34-05). checkpoint_measure MUSS gebaut werden (Owner-KERN 09.08., KON34-02/-03) -- nicht W7.
ORT: Wellenplan Par.17.3; Strecke Posten 20/24/25/34/40
SOLL/FIX: wie gelistet; Fristen: B3 explizit vor F2 (Owner-Datum), B1/B2/B4/B5 vor F2 als ABLEITUNG.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KON34/KON37; A<->E-Flaechen-Disjunktheit (engstes Glied 4)

### [w18xiad7j.json] 8
GEGENSTAND: Kritischer Pfad + engste Glieder: S-1 -> #4 S-3+S-7 -> S-5 -> [Layout-Bump decl.hpp:293 verbietet Layout 7 -- VOR S-6a-POD loesen] -> #15 S-6-Fenster -> F2-FREEZE Fr 21.08.; parallel golden -> #16 Homes (KON27-01 Home-Prinzip) -> #17; dann #7 S-19-Simulation (produziert B-4-Zahl, BAU-ZAHLEN Di 25.08.); Emissions-Ast S-8..S-13+S-17; BAU-TRIGGER Mi 26.08. 06:00 (Kriterium: #7-Zahlen + S-13/S-17 + B1/B2/B4/B5 + S-14-Vollausrollung + #68 oder dokumentierter Verzicht); W3 = DEBUG-GENERALPROBE; T-3 12.09. echte Messung (Debug-Werte loeschen, KON29-01 -- einzige Ausnahme von "Messdaten nie loeschen"); Abgabe 15.09. ENGSTE GLIEDER: (1) Layout-Bump vor S-6a, (2) OF-1/OF-2 vor B4/#7-Nenner, (3) S-13/S-17-Landung erst Di 25., (4) A<->E-Disjunktheit, (5) XML->PDF-Vollautomatik + Lager-Skip bis W3 (sonst traegt T-3 nicht).
ORT: Strecke Teil B Schluss
SOLL/FIX: wie gelistet; #68 selektiver Rebuild = deklarierter ERSTER Verzicht bei Zeitnot (V-10).
STATUS LT. QUELLE: offen (Plan)
ABHAENGIGKEIT/FLAECHE: -

### [w18xiad7j.json] 9
GEGENSTAND: Einzelposten der Strecke mit Objekt-Ankern: #83 lint:format ZUERST (blockiert jede Landung) dann #84 Vorbestands-Rot -> #80 coverage-guard (ce hat GENAU EINEN roten Job = test:coverage-guard, stempelfremder ISA/Host-Grund; Fix-Reihenfolge "erst F1 dann F2" = GUARD-INTERNE Schritte F1=Operanden vergleichbar/F2=when:always, NICHT die Fristen); #22-Paket: runner-mode.sh:43 HEAVY_J 24->16 + Par.69.6-Vermerk + N-3/N-4 mit 16 Workern + debug-nproc + Q6-MaxN 8->32 (synthese_matrix.hpp:33-51) + 2 Ledger-Zitat-Korrekturen (KON28-01); #10 MinIO-Keys + 776-Token-Rotation + test:secrets aus prod2 (KON22-01/5+6); S-14a Bump-Wache Teil 1 (heute 6/136 gedeckt; Vollausrollung ab Sa 22. parallel, Build-Blocker-Klasse 6/>=152, im Trigger-Kriterium).
ORT: Strecke Posten 4/6/9/11/41
SOLL/FIX: wie gelistet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: KON8-11/KON33-02 (coverage-guard); KON22 (Token)

### [w18xiad7j.json] 10
GEGENSTAND: Designplan-Drift D-1..D-6 (neues Par.10): D-1 Hybrid-Bestand NICHT null (4 Header/943 Z. + 1802 Z. Vorarbeit, 0 Konsumenten; HY-Vertrag PINNT kGenusCount); D-2 Kapazitaet: #87/#78/#86/KON9-05/HY-A = (P) vor F2, fallen NIE; Band B/W1 62 h "geschlossen gestrichen"; D-3 Shell-Bissproben Alt-Last -> Google Tests (S-16: 14 Dateien/8.528 Z., 0 retired; Skip-Verbot KON22; TEST-KONSOLIDIERUNG dockt an); D-4 S-Strecke hat KEINE Testposten im 117er-Katalog (S-6, S-13, S-14, S-17..S-21 fehlen; NEU S-21 Kategorien-Ordnungs-Wache = S-6c, Owner-GO; S-6-Umfang erst nach Layout-Bump schaetzbar); D-5 xlsx-Nenner: 8 von 9 thesis_profiles xlsx-blind -- Kampagnen-Blocker, fehlender T-3-Klasse-Posten; D-6 PMC-Vertragsfolge ungetestet (PMC = Meta-Meta-Achse, AMD/Intel 2 Komponenten KON8-12; CI faehrt PMC ohne Vendor WARNING KON34-02; MT-L11 misst nur Injektion). Summen-Regel: 117/386 h NICHT anfassen bis S-Strecke durchgezaehlt.
ORT: Designplan Par.10 (Entwurf)
SOLL/FIX: je Marker/[D-n]-Verweis einpflegen; Posten ableiten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w18xiad7j.json] 11
GEGENSTAND: W7-Liste gezaehlt (23 Posten = 9 Behaelter + 14 Zaehler), u.a.: P/E-Core-Cluster CPUID 0x1A ohne Implementierer (KON20-04); S-16; NOTICE/GPL-Widerspruch (NOTICE=Apache2.0 vs LICENSE=Dual; wh.c-Kopie ungedeckt, KON2-24/25); Betreuer-PDFs vor Public-Release (KON22-01/4); Stage-Topologie coverage-guard vor test:unit + ctest_unit_inventar.txt 0 Verbraucher (KON4-03); XML-Wache zwei unbeobachtbare Zweighaelften (KON3-03); Bestandslog-SKIP-Risiko EIN Eintrag je binary_id mit leerer Zelle trotz 320-facher opt-x-simd-Bindung (KON3-06); Backup-Ref-Loeschung gestuft (A-1-Vorlagetext VORHER -- offen Par.17.1); Flag-Katalog 59 Knoten (f-Kollision FPGA/AVX-512 faellt VOR Trigger); 14 Zaehler-Posten #26 #29 #30 #32 #34 #42 #44 #48 #50 #63 #64 #69 #71 #72.
ORT: Teil D
SOLL/FIX: TEST-KONSOLIDIERUNG als AKTIVER Posten (Eigentuemer setzen, KON37-08).
STATUS LT. QUELLE: offen (nach W7/Abgabe, ausser TEST-KONSOLIDIERUNG aktiv)
ABHAENGIGKEIT/FLAECHE: -

### [w18xiad7j.json] 12
GEGENSTAND: Offen nach KON39-Nachtrag (explizite Liste): OF-1..OF-4  |  A-1-Vorlagetext (vor jeder Backup-Ref-Aktion)  |  R-2-Namensvorschlag (MergeStrategy, im S-6-Fenster durch uns)  |  E-WARMUP-Explore (cache warmup, 10 Wochen, ZUERST in der Kampagnen-Vorstaffel)  |  TEST-KONSOLIDIERUNG-Eigentuemer  |  T-3-Ripple-Posten (XML->PDF-Automatik + Lager-Skip)  |  Layout-Bump decl.hpp:293  |  V-1 (bis Besitzer steht).
ORT: kon37_entwurf Schluss
SOLL/FIX: wie gelistet.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [w18xiad7j.json] 13
GEGENSTAND: GOAL-Marker-Fakten (Referenz-Korrekturen): Kette = Bau-Modul-Emission (Tiefe 3, Tier+Hybrid sequentiell auf derselben Stufe, Traeger-Rakete rueckwaerts gebaut, Emission fertig erst wenn CEBs+Tier+Hybrid IM LAGER; ORT-Reihenfolge der vier Traeger gilt unveraendert); Hybrid "0% ANGESCHLOSSEN" statt "0% gebaut"; E-1-final: Gattung::HeuristikAdapter=3 + Genus::FunctionInterfaceReroute=5 (sechswertig), genus() NIE Reroute (Pass-through Weg C), 14 Entscheide; MESS-NENNER=32 aus 5 Schaltern, Hybrid-Mess-Schicht HAELT (B3 baut sie); D5: 3/5 erledigt (ce c98b4b95), offen D5-2+D5-4; Zeilenanker gedriftet (:1810/:2038, :2736/:2751, 38/41) -- Anker ueber Symbol/Commit/KON, nie Zeilennummer.
ORT: GOAL-Nachtrag Tabelle A + A.5-Marker
SOLL/FIX: Marker an die Stellen selbst (nichts loeschen).
STATUS LT. QUELLE: offen (Einpflege)
ABHAENGIGKEIT/FLAECHE: -

## Datei 6: wdz7tb4cm.json (Hauptstrang P0->L1, 06.08. vormittag: Lebend-Check, B14-Klaerung, Gate-Pruefung, FAHRPLAN; 4 Agenten. ACHTUNG: Landeblock R4/T2-A/B14/A1 ist lt. Datei 1 (Scope 3) inzwischen GELANDET -- Posten hier nur soweit dauerhaft)

### [wdz7tb4cm.json] 1
GEGENSTAND: B14-Verdikt LANDEN am Tip 4b38d072 (nicht 16a173f2): Literal-64-CLU-Konsument verschwunden (system_axis.hpp:345-358 liest axis_stats[5][5]), fail-closed + klebrige Einheiten-Vergiftung (note_line_unit_), ABI-Minor 8.0->8.1 vollstaendig durchgezogen; 410/410 gruen per Neu-Build.
ORT: wt-b14-ce; Kette cacheline_config.hpp -> axis_04 -> axis_05 -> abi_adapter.hpp:1490-1504 -> system_axis.hpp
SOLL/FIX: (gelandet lt. Datei 1) -- Biss-Test CluIstInvariantGegenDieCachelineUnterachse beisst, sobald jemand 64 zurueckholt.
STATUS LT. QUELLE: behoben@4b38d072 (Landung spaeter vollzogen)
ABHAENGIGKEIT/FLAECHE: -

### [wdz7tb4cm.json] 2
GEGENSTAND: OFFENER Dauer-Posten "zweites Churn-Leck": kChurn=2048-Bloecke des Segment-2-Churn lecken, wenn alloc.allocate MITTEN in der Schleife wirft (max 512 KiB je Fehlschlag); Deferral-Begruendung woertlich in Kosten-Nutzen-Sprache -- Widerspruch zur bindenden Anti-Kostenklammer-Doktrin des Owners.
ORT: ce abi_adapter.hpp:238-254 (Kommentar-Zusage im Code)
SOLL/FIX: Lead-/Owner-Bewertung: vor Landung schliessen oder als eigenstaendiger Posten deklariert fuehren; FAHRPLAN B14-3: "Churn-Leck schliessen oder mit Begruendung zuruecksetzen (20-30 min)".
STATUS LT. QUELLE: offen (bewusst zurueckgestellt; Doktrin-Konflikt benannt)
ABHAENGIGKEIT/FLAECHE: feedback_luecke_ist_auftrag (13.08.: kein "Randfall" mehr zulaessig)

### [wdz7tb4cm.json] 3
GEGENSTAND: B14-Tests in KEINEM CI-Job verdrahtet (.gitlab-ci.yml selektiert nur explizite -R-Namenslisten; Label b14 deckt 2/8) -- R4-Nachzug "erster Slot NACH B14" war der Auffang; K4-Korrektur: die Ledger-Auflage "R4 erst nach B14" war gegenstandslos (R4 beruehrt tests/unit/CMakeLists.txt gar nicht).
ORT: ce .gitlab-ci.yml; Ledger #7 SOFORT-POSTEN R4
SOLL/FIX: CI-Verdrahtung der B14-Tests via R4-Invariante (inzwischen gelandet dcb2f08f/557d8023 lt. Datei 1).
STATUS LT. QUELLE: behoben (R4 gelandet); Restpruefung ob alle 8 Tests laufen: unbekannt
ABHAENGIGKEIT/FLAECHE: coverage-guard

### [wdz7tb4cm.json] 4
GEGENSTAND: axis_version.lock war auf development BEREITS ROT (measurement_curve_loader.hpp sha 9a5753fc vs Lock 274b3a39): zwei semantische Drifts ohne Bump (seit 150b0ede 26.07. und 0fdeccff 02.08.); Ursache: contract:axis-version-lock stand ZWEIMAL in .gitlab-ci.yml (Z.343 unbedingt, Z.502 gegatet -- YAML nimmt den letzten, Tripwire seit 19.07. AUS).
ORT: development .gitlab-ci.yml; tools/axis_version_lock/axis_version.lock
SOLL/FIX: R4/557d8023 heilt (AXIS_ALGO_VERSION 1->2 + Lock-Regen + Doppel-Eintrag entfernt); Biss-Beweis blieb offen (siehe Datei 2 S-25).
STATUS LT. QUELLE: behoben@557d8023; Bissbeweis offen
ABHAENGIGKEIT/FLAECHE: S-25 (Datei 2)

### [wdz7tb4cm.json] 5
GEGENSTAND: E18-SNAP 5c4cf900: stehendes Codex-NICHT-LANDEN-Verdikt (4/5 Mindestanforderungen offen: falsche Remote-Belegakzeptanz, nicht erzwungener Nachhol-Bau, fail-open Fetch, .tmp-False-Positive, unvollstaendige Recovery-Identitaet) + CI-Integration NICHT wirksam (gitlab-ci-delta.patch unangewandt -- "ohne ihn persistiert das Feature nichts").
ORT: docs/sessions/backups/20260806-e18-snap-welle/CODEX-VERDIKT-NB2-5c4cf900-NICHT-LANDEN.md; wt-b-e18snap
SOLL/FIX: NB3-Welle MIT .gitlab-ci.yml-Lead-Patch im P4-Fenster, altes Verdikt ERSETZEN nicht umdeuten.
STATUS LT. QUELLE: offen (NICHT-LANDEN steht)
ABHAENGIGKEIT/FLAECHE: S-45 (Datei 2)

### [wdz7tb4cm.json] 6
GEGENSTAND: Gate-Auflagen der damaligen Pakete (historisch, Landung erfolgte spaeter): Graph 2 Nicht-ASCII (Par.) diagram_generator.cpp:1718/1756; Voll-Korpus-PDF-Gate ausstehend; A1: cf22 auf prod1 + #12-Scope-Zustimmung (24x reallocate) + Lens-Pass offen; K5: drei Paket-Spitzen (4b38d072, 557d8023, 9934a7e5) waren OHNE rescue auf Remotes.
ORT: Gates-Abschnitt; FAHRPLAN
SOLL/FIX: (weitgehend durch Landung ueberholt) -- Designer: pruefen, ob Par.-Zeichen und PDF-Gate bei der Landung geheilt wurden.
STATUS LT. QUELLE: offen lt. Quelle / vermutlich ueberholt
ABHAENGIGKEIT/FLAECHE: -

### [wdz7tb4cm.json] 7
GEGENSTAND: FAHRPLAN-Kernaussagen: Merge-Matrix 16/16 SAUBER (Reihenfolge nicht konfliktgetrieben, sondern Identitaets-Block: R4+T2-A+B14-ce+A1 VOLLSTAENDIG vor Trigger, sonst Voll-Bau wiederholen); Kalibrier-Stichprobe (~200 Binaries, Minuten) als Vor-Trigger-Posten, "der in keiner Liste steht" (5s=7,6h vs 30s=45,5h -- Zahl damals ungemessen); O-A-Kopplung: Owner-KERN A4 fordert UNTERSTUETZUNG aller line_sizes, nicht Messung aller Kreuzprodukte -- Unterscheidung entscheidet den Zeitplan.
ORT: docs/sessions/20260806-FAHRPLAN-hauptstrang-landung.md (565 Z., damals nicht committet)
SOLL/FIX: Kalibrier-Stichprobe = P-KAL (spaeter M-5/0.5 in Datei 1); line_size-Entscheid = R-4 (Scope 1).
STATUS LT. QUELLE: offen (P-KAL), Rest gelandet/ueberholt
ABHAENGIGKEIT/FLAECHE: Datei 1 Fund 9/12

### [wdz7tb4cm.json] 8
GEGENSTAND: Damalige Korrekturen am gemeldeten IST (Methodik-Lehren): K2 super-main-Divergenz existierte nicht (ls-remote beidseitig 030d2c62 -- Worktree-Fetch-Stand war stale); Worktree-Namen wichen von Erwartung ab (wt-b2-neuanker statt wt-b14-neuanker; verwaistes detached-HEAD-Scratchpad /tmp/.../ce-audit-7150cc51); alle 8 ungelandeten Pakete waren lueckenlos per rescue-Ref doppelt gesichert.
ORT: Ist-Aufnahme
SOLL/FIX: (Lehre: Remote-Zustaende immer frisch fetchen; verwaiste Scratchpad-Worktrees aufraeumen -- Bestandshygiene)
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

## Datei 7: wr7tt88v0.json (Bau-Phase Do 13.08.: golden-Baseline + S-14a-Riegel [seriell] + Q6-Kommentar-Nachzug [parallel]; Basis ce 7d65eb6c = gemergter development-Tip, CI 15770 gruen; beide Zweige NUR LOKAL, kein Push)

### [wr7tt88v0.json] 1
GEGENSTAND: S-14a-Riegel GEBAUT: Branch bau/golden-s14a-riegel (Worktree /home/comdare/wt-ce-golden-s14a), Kette 7d65eb6c -> a8465ef3 (golden Baseline 158 Traeger, 6/130/22/158, 152 Insertionen/0 Deletionen) -> 8424a331 (Tripwire-ctest rot-zuerst, Koeder D belegt v1-Luecke, ctest -N 485->486) -> f2f9fc05 (Riegel v2: OrganDetail-Discovery axes/+topics/queuing, kommentar-/string-bewusster Scan, algo_semver-Parser, Sentinel=>ROT, verwaist=>ROT, Lock v2 158/158 digest-identisch, CI-Job ohne 6-Pfad-Liste) -> bb5d3f3c (Lock als Zweizeilen-Record, Diff-Hygiene GRUEN). 4x Vollbau gruen (gcc+clang x Debug+Release je 486/486, KON55-Kombibau komplett lokal). 10 Koeder-Protokolle mit literalen ROT/GRUEN-Belegen.
ORT: tools/axis_version_lock/{axis_version_lock.cpp,CMakeLists.txt,axis_version.lock}; tests/unit/test_s14_axis_version_lock_tripwire.cpp; tests/unit/CMakeLists.txt; .gitlab-ci.yml (nur Job contract:axis-version-lock)
SOLL/FIX: LANDEFAEHIG JA_MIT_AUFLAGEN: (1) Lead-Review des .gitlab-ci.yml-Diffs (Lead-only-Hotspot); (2) Landung als MERGE des Zweigs (nie rebase, atomar per T-8), nach Push contract:axis-version-lock + test:unit per Monitor beobachten; (3) BETRIEBSFOLGE aktiv kommunizieren: JEDE Aenderung an einem der 122 organ-Traeger erzwingt X.Y.Z-Bump ODER bewussten Lock-Regen-Commit (--write); die 30 Forwarder/Prosa-Dateien verlangen IMMER den Regen-Commit -- trifft die S-6/S-7-Wellen unmittelbar.
STATUS LT. QUELLE: landereif (Verify TRAEGT), NICHT gepusht/gelandet
ABHAENGIGKEIT/FLAECHE: S-14a (Bump-Wache); KON27-01 golden VOR Homes; Merge-Flaeche .gitlab-ci.yml

### [wr7tt88v0.json] 2
GEGENSTAND: S-14a offene Punkte: (0) ABWEICHUNG deklariert: Planungszahl 123 organ-Traeger vs am Objekt 122 (axis_06_allocator_strategy_base.hpp Z.115 = Kommentar-Prosa); (1) BESTANDSWARNUNG gcc-15 Release -Wstringop-overflow in axis_03a_search_algo_interpolation.hpp (erase/memmove-Inlining via test_v41_topic_traversal) -- Behebung ist ab sofort Traeger-Edit mit Bump-Pflicht, Lead-Entscheid noetig; (2) clang-Vendor-Warnung gtest-printers.h:524 (fremd, nicht anfassbar); (3) KEIN Push -- CI-Gruen steht aus (CI-Aequivalente lokal gruen); (4) queuing im HEUTIGEN Pfad festgeschrieben -- #16-Umzug (Sa) verlangt bewussten Lock-Regen-Commit, Digests wandern digest-stabil; (5) SYSTEM/MESS-Detail-Klassen bewusst NICHT angelegt (Homes existieren nicht; benannte ASCII-Leerstelle im Tool-Kopf fuer #16); (6) kein Belege-Textfile (Belege in 4 Commit-Messages); (7) Temp-Dateien unter /tmp fluechtig.
ORT: wie genannt
SOLL/FIX: je wie gelistet; Punkt (1) als Lead-Entscheid fuehren.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: #16 Homes (S-18); S-6/S-7

### [wr7tt88v0.json] 3
GEGENSTAND: Verify-NOTIZEN zu S-14a (alle "kein tragender Defekt" -- ACHTUNG Owner-Dauerregel 13.08.: Luecke=Behebungspflicht, kein "NOTIZ"-Rabatt): (0) Berichts-Prosa-Binnenaufteilung der 30 digest-only-Records falsch (am Objekt 12 Observable + 18 Base; Summe 30 und Lock korrekt); (1) Kommentar axis_version_lock.cpp:187 irrefuehrend -- eine NEUE unlesbare .hpp bliebe STILL (erreicht Digest-Schritt nie; laut nur via Verwaist-Check); (2) HeuristikDetail::version_of WARNUNG jetzt in BEIDEN Modi (Sichtbarkeits-Verschaerfung, am Bestand wirkungslos); (3) parse_lock_v2 (Z.449-467) toleriert Extra-Tokens in HANDEDITIERTEM Lock still (--write erzeugt solche nie).
ORT: tools/axis_version_lock/axis_version_lock.cpp:149,:187,:449-467
SOLL/FIX: Kommentar praezisieren; unlesbare-Datei-Pfad laut machen; Parser haerten -- Designer entscheidet Einordnung unter der 13.08.-Dauerregel.
STATUS LT. QUELLE: nur-hinweis lt. Quelle (potentiell Pflicht lt. Dauerregel)
ABHAENGIGKEIT/FLAECHE: feedback_luecke_ist_auftrag

### [wr7tt88v0.json] 4
GEGENSTAND: Q6-Dock32-Nachzug GEBAUT: Branch bau/q6-dock32-nachzug (Worktree /home/comdare/wt-ce-q6), 1 Commit 58579575 (docs: 32er-Entscheid an 4 Stellen nachgetragen, KON28-03/KON41-03/KON42-01); Diff DOKU-ONLY bewiesen (preprocessed-Hash identisch); K13-Koeder biss (static_assert 32==8 -> RC=1 literal); ctest 485/485 in allen 4 Zellen; Verify TRAEGT.
ORT: libs/cache_engine/hybrid/heuristik_adapter_synthese_matrix.hpp; hybrid/README.md; docs/architecture/20260802-hybrid_tier_stufe_soll_design.md
SOLL/FIX: LANDEFAEHIG JA; Landung (Merge nach development + Gitlink-Bump im super) ist Lead-Sache; Worktree bleibt stehen bis gruen+gemergt (KON49).
STATUS LT. QUELLE: landereif, NICHT gepusht
ABHAENGIGKEIT/FLAECHE: HY-A3 (max_docks-XML-Override) bewusst NICHT Teil; K1 (Lager-Identitaet), K2 (Loader/Drive), K5 (Snapshot-Aggregation) bleiben offen (README-Vermerk)

### [wr7tt88v0.json] 5
GEGENSTAND: Q6-Verify-Details: Zeilen-Anker vor/nach Stand dokumentiert (Zahlen-Widerspruch-Zeile alt Z.82 -> neu Z.94); Preset gcc-debug existiert NICHT in CMakePresets.json (nur msvc-*/gcc-release/clang-release) -- Debug-Konfigurationen des Bau-Agenten manuell/geraeumte User-Presets, 4 Toolchain-Bilanzen am Objekt nicht mehr nachpruefbar (Nenner konfig-unabhaengig belegt); ctest-Nenner 485 unabhaengig zweistufig nachgemessen (481 + 4 Werkzeug-Tests nach J-1..J-3); historische Nenner 490 (09.08.)/486 (10.08.) = aeltere Staende, kein Widerspruch.
ORT: Verify Q6 Befunde 5-7
SOLL/FIX: (Beleg-Hinweise fuer Landung)
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: -

## Datei 8: wa3azpzk6.json (T2 Teil-2-Uebernahme 06.08.: T2-B/C/D/E/F gebaut auf b2-neuanker-format3 @a6a6875b, T2-A bewusst OFFEN; Fable-Review LANDEBEREIT, Codex-Review "Nicht freigabefaehig" -- spaetere T2-A-Landung 86be2420 lt. Datei 1; Codex-Befunde muessen gegen den gelandeten Stand geprueft werden)

### [wa3azpzk6.json] 1
GEGENSTAND: T2-Bau-Stand: 5/6 Pakete fertig gegatet (Commits cb9a7204 T2-D, dbdd2f9b T2-B per-Perm-Glied[5], bbd72c2a T2-C RT-Realversions-Sonde, e2c95179 T2-E, a6a6875b T2-F; 12 Dateien +1139/-80; 408/408 Doppellauf je Commit; Frozen-Vektor unbewegt 560 B/17148e5a...); T2-A (F1 + F4 Zaehler-Resume) NICHT angefasst -- bewusster Stopp (neues persistentes Format + resume-v5->v6-Bump + Kopplung an b.skipped).
ORT: wt-b2-neuanker; Anker fuer Fortfuehrer: lazy_resume_stamp_prefix iterator:883, "resume-v5|build=" :904 (EINZIGER Ort des Formatworts), kLazyResumeRowsKey :876 (Leser :952, Schreiber :1950 -- F4 haengt "|fpr=" an DIESE Ordnung an, KEIN viertes Literal), F1-Anker profile_run_entry.hpp:584 + director:1236
SOLL/FIX: T2-A gemaess Anker bauen (lt. Datei 1 spaeter als 86be2420 gelandet -- Vollzug pruefen).
STATUS LT. QUELLE: T2-B..F behoben@a6a6875b; T2-A offen lt. Quelle (spaeter gelandet lt. Datei 1)
ABHAENGIGKEIT/FLAECHE: "NEUE DLL, ALTE MESSWERTE"-Heilung

### [wa3azpzk6.json] 2
GEGENSTAND: Codex-KRITISCH 1: persistenter Batch-Plan + Phasenzaehler fehlen vollstaendig (Planer streamt RAM-Slices sofort, nur globale fluechtige Summen; keine "Plan dauerhaft schreiben, dann laufen"-Reihenfolge; Crash verliert Plan+Fortschritt; IDs werden VOR Bau/Messung gezaehlt, auch Fehlversuche).
ORT: batch_planner.hpp:87; experiment_run_entry.hpp:107,:362; profile_run_entry.hpp:806
SOLL/FIX: genau der T2-A/F4-Gegenstand -- pruefen, ob die spaetere T2-A-Landung dies deckt.
STATUS LT. QUELLE: offen (zum Review-Zeitpunkt)
ABHAENGIGKEIT/FLAECHE: Owner-KERN Batch-Plan PERSISTENT VOR dem Lauf

### [wa3azpzk6.json] 3
GEGENSTAND: Codex-KRITISCH 2: Mess-Resume nicht an neuen Fingerprint gekoppelt -- Stamp bleibt resume-v5, enthaelt je Binary nur algo_sig, wird auch nach echtem Neubau geprueft; Beispiel: g++-16 16.0.1->16.3 baut DLL wegen Fingerprint-Drift neu, uebernimmt danach ALTE Messwerte aus result.csv.
ORT: cache_engine_builder_iterator.hpp:904,:1668,:1822
SOLL/FIX: F4 "|fpr="-Kopplung (T2-A-Gegenstand); Vollzug am gelandeten Stand pruefen.
STATUS LT. QUELLE: offen (zum Review-Zeitpunkt)
ABHAENGIGKEIT/FLAECHE: T2-A

### [wa3azpzk6.json] 4
GEGENSTAND: Codex-HOCH-Befunde (6): (a) leere Zellfelder kollabieren per-Perm-Fingerprints (Umschaltung haengt faelschlich an !perm_cell_values.empty(); O3 kann O2-DLL skippen) profile_run_entry.hpp:943; (b) compile_for_perm-Fallback stempelt anderen Bau (a.compile verwendet, Soll-Fingerprint per-Perm; Sidecar :689 falsch) :925/:951 + build_orchestrator.hpp:689; (c) BEIDE target_isa-Zweige gebrochen (allein: aktiviert Perm-Pfad nicht + achsenleeres Live-Glied; mit opt/simd: Targetflags verworfen, Ziel-ISA als Zelle gestempelt => x86/aarch64-Kollision) profile_run_facade.cpp:569/:650 + toolchain_stamp_naht.hpp:400; (d) positiver Realversionscache vergiftbar (nur Treiber-Tag-indiziert; PATH/Symlink-Wechsel => alter Stempel, falscher Skip) toolchain_stamp_naht.hpp:318; (e) Shell-Sonden-Allowlist erlaubt Globbing ([ ] passieren; Tag unquotiert an popen; /tmp/g++[12] sondiert anderes Executable) anatomy_fingerprint.hpp:139 + naht:332; (f) result.csv/Stamp nicht crash-atomar (CSV direkt trunciert, alter Stamp bleibt; Leser zaehlt unvollstaendige letzte Zeile) iterator:1941/:972.
ORT: wie je genannt
SOLL/FIX: je Befund heilen bzw. am gelandeten Stand verifizieren; Fable-Review hatte (d)/(e) mit eigenen Sonden als nicht ausnutzbar eingestuft (Doppel-Gate) -- Widerspruch der Lenses, Designer klaeren.
STATUS LT. QUELLE: offen (zum Review-Zeitpunkt; Verbleib unbekannt)
ABHAENGIGKEIT/FLAECHE: Fingerprint-/Skip-Integritaet; Lens-Widerspruch

### [wa3azpzk6.json] 5
GEGENSTAND: Codex-MITTEL (3): (a) nichtleerer Gate-Beitrag unbaubar (Produktionswert gate=[...] enthaelt '=', im Toolchain-Feldwert verboten -- sobald Gate-Flags aktiviert werden, wirft die per-Perm-Gliedbildung VOR dem Bau) simd_build_gate.hpp:369 + toolchain_stamp_glied.hpp:384; (b) GliedSterbenderString sperrt const std::string&& nicht (dangling string_view moeglich) anatomy_fingerprint.hpp:242 -- deckungsgleich Fable-M1 (Haertung remove_cvref_t); (c) Sondenantwort nicht voll fail-closed (einzelnes fgets 256 B ohne Vollstaendigkeitspruefung; kein Timeout/Prozessbegrenzung unter gehaltenem Mutex) toolchain_stamp_naht.hpp:271.
ORT: wie genannt
SOLL/FIX: als Aufraeumpass-/Haertungs-Kandidaten fuehren; (a) ist ein tickender Blocker fuer die erste Gate-Flag-Aktivierung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

### [wa3azpzk6.json] 6
GEGENSTAND: Bau-eigene offene Punkte/Fallen: (2) atomic128-Wahl haengt bei SNMALLOC=1 an globaler Compile-Definition (ODR-Beobachtungsposten, Fable-M3); (3) Debug-Ueber-Diskriminierung: bei COMDARE_BUILD_TYPE=Debug ersetzt CompileFn opt durch "-O0 -g", Glied nennt die opt-ACHSE -- zwei Debug-Perms O2/O3 ueber-diskriminiert (ein Neubau zuviel, fail-closed) -- Aufraeumpass; (4) ct_realversion_deckt_treiber nur noch Trace-Zusatzinfo, bewusst nicht geloescht -- Aufraeumpass-Kandidat; Fable-M2: T2-C-Diagnose etikettiert Sonden-Ausfall als KonfigXmlParse (fremde Fehlerklasse, Kosmetik).
ORT: wie genannt
SOLL/FIX: Aufraeumpass-Kandidatenliste.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: -

## Datei 9: whrh78rq1.json (super ASCII-/Breiten-Wache 06.08.: Bau + adversarische Verifikation)

### [whrh78rq1.json] 1
GEGENSTAND: Befund bestaetigt: super hatte KEINE eigene ASCII-/Breiten-Wache (scripts/ existierte nicht; Code/tests/CMakeLists.txt:202 verwies ins Leere); lint:format prueft ASCII gar nicht und Breite nur teilweise (ReflowComments:false laesst 140-Spalten-ASCII-Kommentar durch; Scope nur C/C++-Endungen, keine .cmake/.sh); super-Pakete wurden mit ce-Skript geprueft.
ORT: super .gitlab-ci.yml; ci-templates
SOLL/FIX: Wache gespiegelt: Commit 7780c6af auf b-super-ascii-wache (scripts/ci_diff_ascii_width_guard.sh 610 Z. + neuer Job lint:diff-hygiene, stage lint, GIT_DEPTH:0, kein allow_failure; Spiegel-Begruendung: Lint-Stufe hat GIT_SUBMODULE_STRATEGY:none => zentrale Wache technisch unmoeglich); Biss-Nachweis GRUEN/ROT literal; Alt-Bestand bewusst nicht gegatet (845 Nicht-ASCII/174 Breiten aus 18714 Zeilen -- Diff-Wache, keine Bestands-Wache).
STATUS LT. QUELLE: behoben@7780c6af (NICHT gepusht -- Landung offen; Designer: heutigen Stand pruefen, super-Wache existiert lt. Datei 3/M-1-Gate inzwischen als ci_diff_ascii_width_guard.sh im ce)
ABHAENGIGKEIT/FLAECHE: Diff-Hygiene-Memory (misst PUSH-lokal)

### [whrh78rq1.json] 2
GEGENSTAND: Verify-LUECKE A (echt): Arbeitsbaum-Modus der Wache sieht UNGETRACKTE Dateien NICHT -- liefert nackte 0/GRUEN genau im dokumentierten Handbetrieb ("manuelle Vor-Paketmeldung-Pruefung"), obwohl brandneue Datei der typische Paketfall ist; CI nicht betroffen (--seit-basis).
ORT: scripts/ci_diff_ascii_width_guard.sh (Arbeitsbaum-Modus, git diff HEAD)
SOLL/FIX: git ls-files --others --exclude-standard mitpruefen ODER bei nichtleerer Untracked-Liste FATAL/Warnung.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: falsches Gruen im Handbetrieb

### [whrh78rq1.json] 3
GEGENSTAND: Verify-LUECKE B (echt, Fehlalarm-Richtung): is_scoped() kennt keine Pfad-Ausnahme -- 897 getrackte Fremdcode-Dateien (Code/external/, Forschungsarbeiten/) im Scope; naechster Vendor-Import faehrt die Pipeline ROT gegen Code, den die Vendoring-Doktrin unveraendert lassen will; Code/external/ heute nur durch Zufall (SUBMODULE_STRATEGY none) entlastet; Nenner-Beschriftung "super-eigener Code" falsch.
ORT: scripts/ci_diff_ascii_width_guard.sh is_scoped()
SOLL/FIX: Pfad-Ausschluss ^Code/external/, ^Forschungsarbeiten/ + Nenner-Zeile ehrlich "im Scope" beschriften.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: Vendoring-Doktrin (faithful)

### [whrh78rq1.json] 4
GEGENSTAND: Befund C (erklaerte Null, kein Fehler): auf main laeuft der Job mit 0/0/0 gruen (rules ohne if; merge-base==HEAD) -- kostet einen Runner-Slot je main-Pipeline. Restrisiko nicht entscheidbar: ob origin/$CI_DEFAULT_BRANCH auf dem baremetal-Runner existiert -- Ausfall waere EXIT=2 laut. Verify-Detail: alte GNU-grep-Kette ('^\+' ... grep -v '^\+\+\+') verlor ALLE NEUN Zusatzzeilen, nicht nur die +++-Zeile -- Schaden groesser als im Bau-Bericht; cat-Ausfall = schwaechste Stelle (Verstossliste weg, Nenner+ROT bleiben); awk-Portabilitaet gawk/mawk/busybox belegt.
ORT: wie genannt
SOLL/FIX: optional rules-if; Rest nur Kenntnisnahme.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: Fallen-Register (grep-Ketten)

## Datei 10: wqjxtc4jv.json (P4-Vorzieher honest-empty Stufe-05-Flaechen-Writer, 06.08.; Commit ba5e48eb auf b-honest-empty; Fable-Review LANDEBEREIT -- lt. Datei 1 spaeter GELANDET)

### [wqjxtc4jv.json] 1
GEGENSTAND: HONEST-EMPTY-Fix gebaut: op_<art>_n gelesen (Parser 1:1 p99-Muster), z_field_executed-Wache (Zaehler zuerst, sonst p50>0), NaN statt 0.0 fuer Zellen ohne Stichprobe, ASCII-Platzhalter statt pgfplots-Fatal (status_ok, damit 08-Facade + \input-Wiring unberuehrt); write_surface3d mitgezogen; 5 neue Tests; D-03-Probe vorher RC=1 Fatal / nachher RC=0 3 Seiten.
ORT: Code/05_diagram_generator/{diagram_generator.cpp,.hpp,tests/...}
SOLL/FIX: (gelandet) -- empirisch begruendete Abweichungen: z=nan wird von pgfplots VERWORFEN (stille Fehl-Darstellung) bzw. Fatal -- Auslass via point meta=nan; Achsen schrumpfen NICHT (1-Spalten-Matrix selbst fatal).
STATUS LT. QUELLE: behoben@ba5e48eb (gelandet lt. Datei 1)
ABHAENGIGKEIT/FLAECHE: -

### [wqjxtc4jv.json] 2
GEGENSTAND: Deklarierter Rest-/Folge-Posten: 1xN-/Nx1-Matrix (nur EIN search_algo ODER EIN workload) => matrix plot* bricht fatal ("'matrix input=image' is unsupported for line plots") -- vorbestehend, weder verursacht noch behoben; 3D-Pfad hebt bei TEIL-Daten nicht-ausgefuehrte Zellen weiter auf den 1e-3-Boden (vorbestehendes Darstellungsverhalten, nur Voll-Datenlosigkeit ist jetzt ehrlich).
ORT: Code/05_diagram_generator/diagram_generator.cpp
SOLL/FIX: Folge-Posten (deckt sich mit S-16/N-10 in Datei 2: Wache + zwei Tests 1xN/Nx1); 1e-3-Boden-Teilfall ggf. eigener Ehrlichkeits-Posten.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: D-3-Szenario (Ein-Algorithmus-Auswertung realistisch)

### [wqjxtc4jv.json] 3
GEGENSTAND: Review-Zusatzbefund: test_axis_registry_roundtrip failt mit BYTE-DRIFT im gepinnten ce-Submodul (vorbestehend bei ce=7969b399, nicht attributierbar); kalter Voll-Lauf zeigt reihenfolge-abhaengige Erstlauf-Failures, die sich im Zweitlauf selbst heilen (bekanntes Voll-Bau-Luecken-Muster J-1..J-4).
ORT: super Voll-ctest
SOLL/FIX: deckt sich mit Datei-2-S-50-Kontext und Datei-2-Fund 50 (Referenz-Konfigurations-Drift, Vendor-HAVE); kein neuer Posten, Bestaetigung.
STATUS LT. QUELLE: nur-hinweis
ABHAENGIGKEIT/FLAECHE: reference_lokale_vollbau_luecken_falsches_gruen

## Datei 11: wsb78kl70.json (T2-A-NB nach Dual-Review, 06.08.: 4 Commits auf b2-neuanker-format3, HEAD 6c300e68 -- Bestandteil der spaeteren T2-A-Landung 86be2420 lt. Datei 1)

### [wsb78kl70.json] 1
GEGENSTAND: Geheilte Review-Befunde: (1 KRITISCH) Phasen-Zaehler band nicht an die Indexfolge -- batchplan-v1 identisch fuer A={0,1,2,3} vs B={0,5,7,9}; Heilung slice_index_digest (sha512 ueber \n-Dezimalfolge, injektives Preimage), Format-Bump batchplan-v1->v2; Ueberlauf-Haertung plan_atome/plan_resume_faecher; (2) fester .tmp-Name Multi-Writer-unsicher (45-48 Fehlschlaege/64) -- pid+ns+Zaehler, Reste auf jedem Fehlerpfad geraeumt, prozess_identitaet.hpp extrahiert; (3) |fpr=-Form: Muell-Suffix wurde als gueltiger Stamp akzeptiert -- fp_is_hex_128 fail-closed + Stamp faellt SOFORT am Punkt der Erkennung; (4) Provider wird GENAU EINMAL je Binary gelesen (BuildResult::fingerprint); (5) F1-Spiegel im Experiment-Zwilling GESPIEGELT (compose_system_zell_pfad, 5 Zeilen).
ORT: wt-b2-neuanker Commits 511671c9, bcc49119, 823f6eb5, 6c300e68
SOLL/FIX: (gelandet via T2-A) -- Ehrlich deklariert: Digest != Identitaet (Kollision moeglich); F1-Spiegel hat in KEINEM Zwilling einen VERHALTENSTEST fuer die Wirkung (output_dir je Zelle) -- "so gedeckt wie sein Vorbild, nicht besser".
STATUS LT. QUELLE: behoben@6c300e68; Verhaltenstest-Luecke offen
ABHAENGIGKEIT/FLAECHE: resume-v6; 409/409 + Frozen-Beweis + golden 12/12

### [wsb78kl70.json] 2
GEGENSTAND: NEU NOTIERT (nicht im Auftrag, am Objekt verifiziert): cache_engine_builder_iterator.hpp:2340 bildet den Plan-Stempel des MESS-Laufs mit hartem bestandslog::kBuildSliceGrain, waehrend der Bau-Weg das Korn als Parameter fuehrt (:1109) -- bei abweichendem Korn divergieren die Stempel => fail-closed (kein Zaehlerschrieb), heute nur aus Tests erreichbar.
ORT: wie genannt
SOLL/FIX: Korn-Quelle vereinheitlichen (deckt sich mit Datei-1 R-6/M-4: EINE Konstante + gekoppelte Spiegel).
STATUS LT. QUELLE: offen (notiert)
ABHAENGIGKEIT/FLAECHE: plan_slice_korn; Mess-Batching B-E

### [wsb78kl70.json] 3
GEGENSTAND: Bewusst NICHT geheilt: Cross-Run/F8 nur als Doktrin festgeschrieben (Test 6g: gleicher Fingerprint -> spaeterer Lauf resumiert; kein Verbot gebaut) -- bleibt Owner-Frage F8; read_batch_plan nie aufgerufen (fail-closed by design, unberuehrt); die 4 Voll-Scope-Befunde der Task-Liste NICHT angefasst: Bau-Zaehler vor Push-Drain, Mess-Zaehler kein Praefix, zwei Fortschritts-Wahrheiten, Zaehler umgeht dll_is_current.
ORT: Task-Liste T2-A-Voll-Scope
SOLL/FIX: die 4 Voll-Scope-Befunde als eigene Posten pruefen/fuehren; F8 in Owner-Fragen-Katalog.
STATUS LT. QUELLE: offen
ABHAENGIGKEIT/FLAECHE: T2-A-Restflaeche

### [wsb78kl70.json] 4
GEGENSTAND: clang-format-Gate STEHT AUS (Maschine ohne clang-format zum Zeitpunkt) -- "Nicht bestanden gemeldet". (Datei 3 zeigte spaeter: clang-format 22.1.8 IST unter /tmp/cfmt/usr/lib/llvm-22/bin vorhanden -- cf22 war fahrbar.)
ORT: T2-A-NB-Gates
SOLL/FIX: cf22-Nachzug fuer den T2-A-Bereich pruefen (ob bei der Landung erfolgt).
STATUS LT. QUELLE: offen (zum Zeitpunkt)
ABHAENGIGKEIT/FLAECHE: cf22-Doktrin; Quellen-Konflikt "nicht installiert" vs "/tmp/cfmt vorhanden"

## Datei 12: wqxpvgwwt.json (Gate 8 Graph-Abbildungen, 06.08.: Commit 8970465d auf b-gate8-graph-abbildungen -- GELANDET lt. Datei 1)

### [wqxpvgwwt.json] 1
GEGENSTAND: Gate 8 erledigt: 23 neue \InputIfFileExists-Eintraege je Sprache in A_measurements.tex (+199/-2; Namen aus Code, nicht geraten: 6 surface3d + 3 sweep + 6 ratio + 6 normbar + exchange_forest_vs_reference + latency_tradeoff); Proben: DE 202 S./EN 192 S. RC=0; Einbindungs-Probe mit Stellvertreter-Datei belegt Fallback; Encoding-Konvention ASCII mit LaTeX-Escapes eingehalten; 2 dokumentierte Muster-Abweichungen (Ersatztext nur am ersten Gruppen-Eintrag; A.8 vor Achsen-Austauschbarkeit wegen "Verweise rueckwaerts").
ORT: thesis anhang/{de,en}/A_measurements.tex; wt-b-gate8
SOLL/FIX: (gelandet)
STATUS LT. QUELLE: behoben@8970465d
ABHAENGIGKEIT/FLAECHE: -

### [wqxpvgwwt.json] 2
GEGENSTAND: Nebenbefund (bewusst nicht mitgeloest): axis_inventory.tex wird von der Facade geschrieben (appendix_generator.cpp:423), war in KEINER .tex eingebunden -- braucht eigene Entscheidung, in welchen Abschnitt die Tabelle gehoert. (Lt. Datei 1 Scope 4 inzwischen in Anhang D:1442 eingebunden seit df54a2c; Rest-Luecke CI-seitig: Generator-Aufrufe ohne --*-registry.)
ORT: wie genannt
SOLL/FIX: CI-Registry-Argumente nachziehen (= Datei-1 Fund 44 / P-3b).
STATUS LT. QUELLE: teilweise (Einbindung erfolgt, CI-Erzeugung offen)
ABHAENGIGKEIT/FLAECHE: Anhang D

---

# BILANZ LESER 9

- Dateien gelesen: 12 von 12 (vollstaendig, via pp-Expansion; workflowProgress-Metadaten gesichtet, nur Substanz extrahiert).
- Extrahierte Posten: 184 (Datei 1: 59  |  Datei 2: 60  |  Datei 3: 11  |  Datei 4: 9  |  Datei 5: 13  |  Datei 6: 8  |  Datei 7: 5  |  Datei 8: 6  |  Datei 9: 4  |  Datei 10: 3  |  Datei 11: 4  |  Datei 12: 2).
- QUELLEN-KONFLIKTE fuer den Designer (Dedup/Zeitachse):
  (K-a) PMC-Flag: Datei 1/2 (06.-08.08.) melden "fehlt in allen 4 Emissionen"; Datei 3 (M-1-Gate, 07./08.08.) und Datei 4 (ceb_pmc_compile_define) zeigen die PMC-Invariante GEBAUT (dev 8894d983, M-2/P-PMC-1) -- neuerer Stand gewinnt, Alt-Posten nur als Historie.
  (K-b) Fingerprint-Format: Datei 1 (Format 3, 8 Glieder, "Bump 3->4 noetig") ist durch Datei 2 E-08 UEBERHOLT (Format 4, 9 Glieder, Overlay scharf, Board #34).
  (K-c) xlsx-Writer: Datei 1 B12 "kein Writer" UEBERHOLT durch Datei 2 E-12/E-14 + S-50 (gebaut cf871f92 etc.); offen bleibt D-5 (8/9 Profile xlsx-blind, Datei 5).
  (K-d) kLbufBytes/KF-6: Datei 1 Scope 3/B6 "GELANDET (abi_adapter 622/731/873)" vs Datei 2 S-55 "ohne Schliessbeleg" -- am Objekt klaeren.
  (K-e) clang-format: "nicht installiert" (Datei 3 D-4/D-2-Berichte, Datei 11) vs "vorhanden unter /tmp/cfmt, cf22 gefahren" (Datei 3 Gate) -- Werkzeug-Suchpfad-Falle.
  (K-f) Codex vs Fable zu T2 (Datei 8): Realversionscache/Globbing als HOCH (Codex) vs "nicht ausnutzbar" (Fable) -- unaufgeloester Lens-Widerspruch.
  (K-g) M-1-Paket (Datei 3) "LANDEBEREIT, nicht gelandet" -- heutiger Landestand am Objekt zu verifizieren (b-m1-identitaetsnaht, HEAD 4fdedbbf).
- Nicht extrahiert: reine Agenten-/Token-Metadaten (workflowProgress), Prompt-Previews.

ASCII-SELBSTCHECK: Diese Datei ist beabsichtigt ASCII-only; Pruefkommando: /usr/bin/grep -nP '[^\x00-\x7F]' leser_09.md (Erwartung: 0 Treffer).
