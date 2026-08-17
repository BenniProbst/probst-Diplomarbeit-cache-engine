# REST-KARTE r4 — Ledger Z. 24701-27400 (Nachtraege 05.08. abend → 07.08. abend-17)

Gelesen: VOLLSTAENDIG, Z. 24701-27400 (alle Zeilen, 21 Read-Happen).
Massstab: kopf_referenz_kon60_93.md · ledger_gegenlese_karte.md (73 Posten) · KON94 (Full-Join FJ-1..FJ-10, Arena E1-E11, 6GB) · KON95 (O1 markierter Leerwert · O2 E(A)=kV3AxisSchema+seg_* · O3 feingliedrig disjunkt) · KON96.
Segment-Inhalt real: 06.08. frueh-1..vormittag-33 (Wellen-/Landungs-Betrieb), 05.08. abend-2..abend-13 (Owner-Entscheide A1-A9, E-1..E-5, B1-B13-Checkliste, Deep-Research A4/A5), 06.08. abend (A-7/A-8-Entkraeftung, REGEL-ZEILE 17), 07.08. morgen-1 bis abend-17 (D-1 PMU, Modi-Kumulativitaet, O-A..O-F, Benchmark-Zuordnung, Flag-Grammatik v2 Bau+Landung, PMC-Ehrlichkeit, P/E-Core, STOPP-Gates). **Keine Gate-Tabellen, kein Register, keine Juli-Paragraphen in diesem Segment** — das ist durchgehend die 05.-07.08.-Nachtragsstrecke.

---

## (A) LEBEND-UNGEDECKT

### KORB A — beruehrt F2 Fr 21.08. / das EINE golden-Fenster

**A-01 · SW-5/E-14 `active_telemetry_is_silent()` gibt konstant `false` zurueck** (07.08. morgen-1, Z25143)
`profile_run_facade.cpp:241-242`, Aufrufer `:533`. Mindestens 10 `thesis_profiles/*.profile.xml` deklarieren `<telemetry silent="true">` (u. a. `all_axes_golden`, `m3_golden_coverage`) — der Wert wird nie durchgereicht, weil das Wiring `+tel=silent` ans golden-`build_version` haengt und die Byte-Identitaet BRICHT. Bewusst deaktiviert, als OFFEN/golden-beruehrend verbucht. → **Task-Karte: gehoert in das EINE golden-Fenster (#16/B2/F5/#72), sonst entsteht ein zweiter Bruch nach F2.**

**A-02 · Zwei Flag-Grammatik-Entscheide sind im Header markiert und BEWUSST offen** (07.08. abend-12, Z27067-27072)
(1) MMX/3DNow liegen auf x87-aliasierten MM-Registern — blosses Top-Level-Token (wie ein Companion) ODER eigene Basis `c.x64{mmx...}`; der Agent nennt es ausdruecklich *"eine Aussage ueber die Hardware, keine Formfrage"*. (2) Praefix-Stripping-Kurzform `x128{2.3.41.42}` verlangt, die Token-Regel (mindestens ein Buchstabe) aufzugeben, und oeffnet damit die stille Fehllesung von `avx10.1`. Beide sind Stempel-Zeichenvorrat. → **Owner-Vorlage + #15/#38a2 (vor dem naechsten Preimage-Bruch).**

**A-03 · Grammatik-Deckel sind an HEUTE bemessen, nicht an der Zukunft** (Z26961-26963, 27014-27018)
`kMaxFlagNodes=96` (Vollausbau heute = 58 Knoten: c{p.e} 3 + x128 11 + x256 13 + x512 15 + Companion/Skalar 11 + MMX 5), `kMaxFlagTokenLen=16`, `kMaxFlagDepth=4`, alle drei per `static_assert`. Der urspruengliche Deckel 32 haette eine LEGITIME Eingabe verworfen (*"Ein Deckel, der eine legitime Eingabe verwirft, ist ein Defekt und keine Wache"*). → **#15-Design: zusammen mit `kAnatomyFingerprintPreimageMax=4096` (Gegenlese Korb A #2) rechnen — 18 Achsen x voll deklarierter Flag-Tail ist die eigentliche Preimage-Laenge.**

**A-04 · Identitaet im Flag-Katalog ist das PAAR (token, eltern), nicht das Token** (07.08. abend-17, Z27401-27404)
`flag_grammar_catalog.hpp:144` fuehrt `f` als FPGA-Hardware-Basis (Tiefe 0), `:208` fuehrt `f` als AVX-512-Foundation unter `x512`. Dasselbe Token, zwei Bedeutungen, entschieden allein durch das Elternteil. 104 `static_assert`s, 62 zugelassene + 14 begruendet abgelehnte Token. → **Designplan-TDD + ARBEITSWEISE: jede Wache/Map, die Flag-Tokens FLACH vergleicht, ist falsch (deckungsgleich mit der Memory-Regel „Kuerzel immer zerlegen").**

**A-05 · Wachen-Deckungs-Doktrin: eine Wache pruefen heisst pruefen, ob sie JEDEN Entstehungspfad deckt** (07.08. abend-12, Z26996-27011)
Der erste Grammatik-Commit bestand die eigene Probe NICHT: eine Composition mit `"v1.0.0c"` an allen 18 Organ-Achsen uebersetzte klaglos und lieferte achtzehn `@0.0.0` in SHA512-Fingerprint und Lager-Identitaet. Ursache: `guard_all_registered_organ_versions()` deckt nur REGISTRIERTE Varianten, `organ_stamp_line<Comp>` stempelt aber JEDE Composition (auch test-lokale und pruefling-eigene). Geschlossen per `static_assert` **an der Stempel-STELLE** (`anatomy_version_stamp.hpp:125`/`:185`). Die Lead-Probe gegen die Wache haette die Luecke nie gefunden. → **ARBEITSWEISE + #15: unmittelbar anwendbar auf das 10. Glied und auf den Pruefling (KON30-02, „eigener Stempel und alles").**

**A-06 · Der STOPP-Gate-POD-Entwurf kompiliert gegen keine der drei Glied-Zahlen** (07.08. abend-10, Z26869-26875)
Der Plan `20260806-PLAN-versionierungs-interface-stempel.md` rechnet mit „Format 3, 8 Glieder" + Frozen `17148e5a`; `development` trug am 07.08. bereits **Format 4, 9 Glieder** (`anatomy_fingerprint.hpp:106`, `MessGatesGlied` als neuntes, `:369`). Die dort vorgesehene Wache `static_assert(kStampKategorieCount == kAnatomyFingerprintGliedCount)` traegt 8 Kategorien — sie kompiliert weder gegen 9 noch gegen die im Massstab geplante **10** (Korb A #1: Format 4→5, Glied 9→10). → **#15: diese Wache im selben Bruch mitziehen.**

**A-07 · VS-A..VS-F (= E-A..E-F): sechs STOPP-Gate-Entscheide, ALLE OFFEN, alle unter „ohne Entscheid kein Byte"** (07.08. mittag-7 Z25993-26001 · abend-10 Z26864-26910)
Hex-Laenge im Stempel-Namen · Name im Symbol? · drei Provenienz-Sidecars auf den POD? · Ordner/CSV auf Stempel-Namen? · Overlay-Glied scharf? · Planer-Stufe honest-empty oder eigenes Set? Vorlage fertig (537 Z., `docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md`), Empfehlung nach Nachmessung `b/ii/a/a/a/a`. Sie **blockieren den Owner-KERN F7=(b) vollstaendig**. Zwei Nachmessungen kippten Buchstaben: **E-C entlastet** (`dll_is_current`, `build_orchestrator.hpp:331-338`, liest heute AUSSCHLIESSLICH das `.fingerprint`; die drei Sidecars *„entscheiden ueber KEINEN Skip mehr"* — das zu buendelnde Invalidierungs-Ereignis existiert nicht mehr), **E-E verbilligt**. **E-E ist groesser als (a)/(b)**: `anatomy_fingerprint.hpp:120-123` nennt drei Unterfragen, die der Plan nicht kennt — Verzeichnis-Schnitt, Sortier-Ordnung, Hash je Datei vs. Konkatenation; *ohne sie ist E-E auch bei „ja" nicht baubar*. **E-F kollidiert** mit `planner/planner_version.hpp:4-7` (Section43.b: der Planer traegt KEINE Achsen-Arrays). Die STOPP-Doktrin deckt namentlich nur E-B/E-C/E-D/E-E — **E-A und E-F sind Bau-Parameter von S1/S2 und stehen NICHT darunter.** → **Owner-Vorlage (unbedingt) + #15.** *Gegenprobe-Auflage:* E-E („Overlay-Glied scharf?") ist durch **KON58-05** („Overlay-Glied [7] hasht Quelltext") vermutlich faktisch bejaht — am Objekt pruefen und Marker setzen, sonst wird ein bereits gebauter Zustand erneut zur Entscheidung vorgelegt.

**A-08 · Dritte Namenskollision auf demselben Buchstabenraum** (Z26907-26910)
Alle 43 `E-x`-Treffer im Ledger gehoeren zum alten `DD-A..DD-E`-Satz; `LEDGER:400` dokumentiert, dass DER schon einmal wegen Kollision mit E0-E4 umbenannt wurde. Vorschlag im Segment: die sechs Gates als **`VS-A..VS-F` (Versions-Stempel)** fuehren. → **Register-/Vokabelpflege (dritte belegte Kollision neben V1-V10/V-1..V-8 und OV-Nummern).**

---

### KORB B — W2-Buendel Di 25.08. (#18 S-13 / Arena / Sheet-System / Full-Join)

**B-01 · Die Bruecke Profil → xlsx ist ECHT_OFFEN, und zwar strukturell** (07.08. mittag-4, Z25661-25670)
Die a9-xlsx-Struktur ist eine **Zeile-pro-Messergebnis**-Tabelle je Unter-Achsen-Permutation (`SheetSchluessel{mess_unter,system_unter,organ_unter}`) — **kein Zeitreihen-Traeger**, keine nativen Chart-Objekte (obwohl die vendorte libxlsxwriter das koennte). Das 06.08.-Dossier: *„Es gibt keine Datenstruktur namens Chart/Diagramm im Mess-Kern."* Und: **eine Zeitnahme INNERHALB eines Funktionsaufrufs existiert heute nicht** (0 Treffer fuer sieben Namensmuster; Gegenprobe `seg_ns` = 326 Treffer, die Suche greift). Die vorhandenen `fill_checkpoints{10,100,1000}` sind FUELLSTANDS-Stuetzpunkte, **keine Ausfuehrungs-Checkpoints**. Der Owner-Satz *„formal als xlsx Messwerte"* ist damit eine NEUE Festlegung, die Spalten, Sheets und Zeitachse noch braucht. → **#18 + Designplan-TDD: KON60(iii) (checkpoint-measure-Wrapper) und KON88 (Sheet je Unter-Achse) setzen diese Zeitachse voraus, ohne sie zu spezifizieren.**

**B-02 · E4/17-KERN: das Genus-Interface schuldet Messparameter UND ein zeitlich geloggtes Zugriffsprofil** (06.08. vormittag-22, Z24775, Owner verbatim)
*„aus einer Interface Funktion einer Gattung->Genus [sind] immer alle in der interface Funktion vollzogenen Messparameter abrufbar, die waehrend des Aufrufs durchlaufen wurden, zusammen mit einem zeitlich geloggten Profil der Achsen-Zugriffsmuster"*; Gattung = KERN der Tier-Binary-Interface-Funktionen, Genus = spezifische Erweiterung (`push_back` haben alle Container, `push_front` nur wo das Substrat es traegt); die Funktionen bilden sich UEBER die Achsen ab. → **Designplan-TDD: das ist die QUELLE der Zeitachse aus B-01 und die Praezisierung des Mess-Visitors am Genus-Interface (Gegenlese Kern 17).**

**B-03 · E1/E2/E3: wo welche Benchmarks hingehoeren — Owner-Auftrag O-B, beantwortet** (07.08. mittag-4, Z25639-25651)
| Ebene | GEGENSTAND | MESSORT | INSTRUMENT |
|---|---|---|---|
| E1 Micro | EINE Achse ueber ihr **Achsen-Interface** | **IN die Tier-Binary einkompiliert** | GEMISCHT: Wallclock **und** PMC |
| E2 Macro (timed) | EINE Gattung+Genus-Funktion | **CEB-seitig am Pruefdock**, gegen die Tier-Binary | Wallclock + Schritt-Checkpoints |
| E3 Macro large scope | EIN Lastprofil = Aggregat ALLER E2-Charts | CEB | aggregiert E2 |
E3 aggregiert E2; E1 steht daneben und misst den Achsen-Boden. Der Messvertrag fuer E1 ist als **18-Zeilen-Tabelle T0..T17** ausgeschrieben (`ce docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:187-211`; z. B. T6 allocator = allocate/deallocate **REALE Ops, kein Stats-READ als Zeit-Surrogat**). Alle drei Ebenen erben die Dreistufigkeit (Planer RT-Freigabe → CEB CT-Einbau → Tier CT); **keine** Owner-Aussage zu je Ebene unterschiedlicher Stufenzahl (Nullbefund mit Gegenprobe). → **Designplan-TDD (fehlt im Massstab vollstaendig).**

**B-04 · „Micro" und „Mess-Layer" bedeuten je ZWEIERLEI** (Z25653-25659)
Die Tooling-Achse `{wallclock, macro, micro}` schneidet **INSTRUMENTE** (`measurement_tooling_registry.hpp:30`: „feinkoernige PMC/Counter-Instrumentierung"), die Ebenen E1/E2/E3 schneiden **GEGENSTAENDE**. „Mess-Layer" meint zusaetzlich den VIERTEN Observer-Layer (Gattung/Genus, Owner-KERN 06.08.). → **Register + siehe Widerspruch C-2 (KON88 verwendet w/ma/mi als Gegenstaende).**

**B-05 · KF-6/A4-Designinput ist SOTA-belegt und bindend** (05.08. abend-11, Z25020)
Muster: **CT-NTTP-Instanz je line_size {32,64,128,256}** ueber die fertige Achsen-Bruecke `line_bytes_of<T>()` + **einmalige CEB-RT-Wahl** (exakt Haupt-/Unter-Doktrin). Praezedenz: glibc IFUNC/FMV, OpenBLAS DYNAMIC_ARCH, FFTW Codelets/Wisdom, P0154R1 — **kein System macht einen Runtime-Switch im Hot-Path**. Bauskizze: `kLbufBytes = kRecords * round_up(kRecordSize, kLineBytes)` + Alignment + lmbench-Precondition-Gate (static_assert CT / Mess-Abbruch RT) + OOB-Biss-Negativtest + Instanziierungs-Matrix aller 4 Groessen. **HW-Erkennung gehoert AUSSCHLIESSLICH an die CEB-Grenze.** Zweiter schlafender Literal: `axis_05_memory_layout_cache_line_aligned.hpp:60 kCacheLine=64` — erst dessen Anbindung macht die Cacheline-Achse an der Scan-Stelle messbar differenzierend. **MESS-SEMANTIK-WARNUNG:** bei `kRecordSize=48` fallen B32/B64 auf `aligned_stride 64` zusammen — die Aequivalenzklasse ist zu dokumentieren, **sonst wird sie spaeter als Regression fehlgedeutet**. → **Designplan-TDD + #18 (line_size ist zugleich einer der Bau-Mengen-Faktoren, siehe B-09).**

**B-06 · honest-empty ist der bereits GEBAUTE Praezedenzfall fuer KON95-O1 (markierter Leerwert)** (06.08. vormittag-14, Z24821)
Drei Zell-Klassen, in beiden Writern ueber EINE Wache (`cell_displayable`): **positiv** = log-Meta · **ECHT-0** = eigene Farbklasse eine Dekade unter der kleinsten Mess-Dekade mit literalem `$0$`-Tick (symlog-Muster) · **nicht ausgefuehrt** = NaN-Auslass. 3D: Loecher via `unbounded coords=jump`, und **die z-Achse faellt bei echter 0 auf LINEAR, weil `zmode=log` die 0 LAUTLOS verschluckt** (= ein verschwiegener Messwert). Empirisch kalibriert (pgfplots droppt `z=nan` still). → **#18/KON95-O1: die Darstellungsform des markierten Leerwerts muss nicht erfunden werden, sie existiert und ist pdflatex-erprobt.**

**B-07 · Die feinkoernige PMC-Wahrheit geht am POD verloren — KON95-O1 muss bis dorthin reichen** (07.08. abend-8 Z26681-26694 · abend-14 Z27208-27213)
Zwei CSV-Pipelines: **(A) golden/CI** rendert nur bei `*_source_available == true` eine Zahl, sonst `"n/a"` — der Guard haelt. **(B) `measurement_snapshot.hpp:140-143`** kopiert bei `pmc.available == true` **alle sechs** Counter **blind**; auf AMD Zen5 ist `pmc.available == true` (L1D oeffnete), `cache_misses_l3` bleibt POD-Default `0`, und `pmc_available = 1` **behauptet, alle sechs seien real gemessen** (das LL-Event scheitert real: `errno=2`). Die Datei nennt sich viermal „EHRLICH" — die Marke ist aber **grobkoernig**. Der Ziel-POD `ComdareMeasurementSnapshotV1` traegt nur `pmc_available`; heilbar nur durch Flag-Felder im POD und damit **neue CSV-Spalten**; `pipeline16` traegt nicht einmal `pmc_available`. Entlastung: `f15_compare` haengt an KEINEM CI-Job (0 Treffer). → **#18 + Owner (Schema-Zusatz wurde bewusst zurueckgehalten, nicht gebaut).**

**B-08 · GN-2/§26.6-Guard: 4096 ist eine compile-time erzwungene Schranke, kein Richtwert** (07.08. abend-4, Z26435-26445)
`source_catalog.hpp:192-212`: `kMaxMaterializableCatalogCardinality = 4096`, `static_assert(catalog_axis_product<FullSourceCatalog>() > 4096)` (die 2^17-Vollform ist IMMER ausgeschlossen) und `static_assert(catalog_axis_product<golden_320_catalog>() <= 4096)`. Verbatim: *„die materialisierende Naht bricht ill-formed, BEVOR ein kuenftiger Codegen-/Repoint-Change die 2^17-Vollform je materialisieren kann"* — **KEIN stilles Hochdrehen** (:203). → **#7/#18: jede Full-Join-/S-19-Rechnung stoesst an diese Wache; eine Anhebung braucht einen Compile-Feasibility-Bauplan.**

**B-09 · 2^17 ist das Organ-Fenster JE SYSTEM-PERMUTATION, nicht der Bau-Umfang** (07.08. morgen-1 Z25126 · abend-9 Z26768-26782)
Vier Kandidaten, am Objekt gemessen: **131.072** (`static_assert(catalog_axis_product<FullSourceCatalog>() == 131072u)`, `COMDARE_GN_TOTAL`) / **524.288** (vier System-Perms O2/O3 x {no_extension, avx2} laut `all_axes_golden.profile.xml:189-198` = realer Ist) / **1.572.864** (12-Perm-Doktrin OE-D, **nicht** ins Profil nachgezogen) / **2.097.152** (x line_size 4, ebenfalls nicht nachgezogen). Die Kardinalitaet kommt NICHT aus einer XML-Zahl, sondern aus `COMDARE_GN_TOTAL x #System-Perms` (Perm-Walk `experiment_plan_director.hpp:2089-2107`, heute nur `opt x simd`); `run_options cap` kappt nichts (No-op `min(131072,131072)`). Der „Faktor 16" kam aus DREI vermischten Ebenen. **Faellig vor der Voll-Messung, NICHT vor dem ersten Batch** (der erste Batch ist in allen Varianten identisch — Scheibe aus Perm 0). → **#7 (S-19-Input): die Frage lautet „welche System-Perm-Menge, und faellt line_size hinein", nicht „welche Zahl".**

**B-10 · Zaehler-Resume-KERN + Resume-Fingerprint-Kopplung** (05.08. abend-10 Z25025-25026 · 06.08. vormittag-27 Z24747 · 07.08. abend-9 Z26755-26766)
Owner verbatim: *„der Store muss zurueckrollen koennen und ohne grosse Verluste resumen … ueber einen Zaehler … sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und persistiert geplant sind."* → Batch-Plan PERSISTENT VOR dem Lauf, Resume = Zaehler je Phase (kompiliert / separat gemessen). **Der schwere Teil (Codex K2):** der Resume-Stamp muss den VOLLEN neuen Fingerprint tragen, nicht nur `algo_sig` — sonst uebernimmt ein echter Neubau ALTE Messwerte aus `result.csv` („neue DLL / alte Messwerte"). **Gebaut/geheilt** (`847c93c9`, `41091cb4`): der alte Code las die Plan-Werte nur bei `slice_seq == 0` **im Loop-Rumpf, den ein voll resumierter Lauf nie betritt**; der Fix setzt `lies_plan_werte()` an ZWEI Lesepunkte, der Tripwire ist umgeschlagen, produktiv gerufen aus `cache_engine_builder_iterator.hpp:1900`. → **#13/#18: vor der W3-Kampagne am Objekt nachmessen, dass beide Lesepunkte und die Fingerprint-Kopplung nach allen seitherigen Bruechen (Format 4/9, Grammatik v2) noch tragen.**

**B-11 · §58-REPLAY: OFFEN, hoch, ohne GEBAUT-Vermerk** (07.08. mittag-2, Z25409-25413)
`single_thread` kann die Owner-Semantik nicht ausdruecken: die Felder sind Compile-Time-Konstanten (`run_methodology_registry.hpp:74-79`), einziger Konsument `measure_parallelism.hpp:23-25` steuert nur den Parallelitaetsgrad — **nicht, ob gemessen oder das Lager abgefragt wird**. Der Mechanismus dafuer ist §58-REPLAY (`LEDGER:2968,:3133`). Ohne ihn messen `compare` und `release` erneut, statt nachzulesen. Beruehrt `kOrganAxisVersionLine` (deshalb im Grammatik-Fenster bewusst nicht vergeben). → **#18 (bzw. #15-Nachbar): O-A macht Replay zur Voraussetzung von compare UND release.**

**B-12 · Scheibe-6: Weg b gebaut, Weg a offen — und die ce-Fixture ist KEINE Kopie** (06.08. vormittag-25, Z24758-24759)
MASTER = `super Code/test_data_xml/experiment_golden_kern.xml`, kanonisch seit 27.07. Die ce-Datei `tests/unit/thesis_tiere/experiment_golden_kern.xml` ist laut eigenem Kopf eine **eigenstaendige Parser-/Validator-Naht-Fixture mit ABSICHTLICH divergenten Werten** (`merge=fulljoin`, `backend=minio`, eigener mapping-Override), in 12 Tests hart verdrahtet — **Byte-Sync wuerde sie rot schiessen**. Gebaut wurde Weg b (`fixture_schema_subset_check.cmake`, Vokabular-Teilmengen-Wache, koexistiert mit dem alten `fixture_sync_check.cmake`). Weg a (ce-Umbenennung) ist offen und war eine explizite Owner-Frage (F3, Z24718). → **#15/#18 + Owner. Beruehrt KON30-02 (`FullJoin` umbenennen) und KON91 („FULL JOIN") — drei Objekte, ein Wort.**

---

### KORB C — Bau-Trigger Mi 26.08. / W3-Kampagne ab Sa 29.08.

**C-01 · prod1 ist NICHT hybrid, aber KERN-ASYMMETRISCH — Faktor 3 im L3 auf DERSELBEN CPU** (07.08. abend-15, Z27241-27255) — **HOECHSTE PRIORITAET**
Vom Lead selbst gemessen: `AMD Ryzen 9 9950X3D 16-Core`; `/sys/devices/cpu_core` und `cpu_atom` **existieren NICHT** (keine Hybrid-PMU); `cache/index3/size`: **16x 98304K und 16x 32768K** — zwei L3-Domaenen, 96 MB gegen 32 MB (X3D mit einem 3D-V-Cache-CCD). Fuer eine Cache-Engine-Arbeit ist das **ein Ergebnis fuer sich** — und ohne Pinning entscheidet der Scheduler, welchen L3 eine Messzelle sieht. Die gebaute Probe faellt ehrlich auf die L3-Stufe zurueck (`quelle=quelle_l3_domaene`, `klasse=kern_grosser_cache` cpus 0..7,16..23 / `kern_kleiner_cache` cpus 8..15,24..31) und **behauptet nirgends P/E**. prod2 ist nicht aufloesbar (Infra #207). → **W3-Vorbereitung + #53 + #7: die Mechanik (Klasse erkennen → pinnen → getrennt ablegen) ist auf prod1 an der L3-Achse HEUTE vollstaendig verifizierbar; ungepinnt ist die Kampagne an dieser Stelle nicht reproduzierbar.**

**C-02 · Der RESOLVER fehlt fuer ALLE DREI RT-Unter-Achsen — das Angebot hat keinen Abnehmer** (07.08. abend-15, Z27268-27288)
`probe_numa_cpu_pin_process_topology()` (`hardware_probe_factory.hpp:481`) ist **Produktionscode mit NULL Rufern** (3 Fundstellen, alle in den definierenden Headern); die Schwester `probe_numa_page_topology()` hat genau einen — eine Testzeile. **Weder OD-10-RT-K noch OD-11-RT-K existiert.** Praezisierung: *„die Topologie wird heute nicht erkannt — sie WUERDE erkannt, wenn jemand fragte. Niemand fragt."* `hybrid_core_aware` hat **genau eine** Fundstelle (die Deklaration, `i_measurement_source.hpp:55`), kein Schreiber, kein Leser, kein Test — und sitzt in der falschen Familie (`MeasurementSourceCaps`, waehrend der reale Messpfad ueber `IPmcSource`/`LinuxPerfPmcSource` laeuft); es auf `true` zu setzen haette die Messung *„nicht geaendert — nur so ausgesehen, als sei P/E beruecksichtigt"*. **Drei Owner-Entscheide Ω-1/Ω-2/Ω-3** (Z27302-27311): Ω-1 Resolver generisch ueber `TargetIsaOpenSubAxes` (loest OD-10 und OD-11 zugleich) oder nur `core_class`? Ω-2 Ablage: CSV-Spalten `core_class` **+ `core_class_source`** — *die Provenienz MUSS mit, sonst wird `kern_grosser_cache` spaeter als `kern_hohe_leistung` ausgewertet, und das waere eine Falschaussage in den Daten*. Ω-3 auf prod1 an der L3-Achse scharf schalten? **KEIN Byte-Ereignis** (dreifach belegt: `target_isa` traegt `binary_id="never"`; `core_class` steht in `kSystemCellValueForbiddenKeys`; A-15-Neutralitaet) — **ABER Falle R-1:** `core_class` lebt in der Registry/RT-Welt, nicht in der axes26/CT-Welt von `build_system_axis_levels()`; wer beides verwechselt, erzeugt sehr wohl ein Byte-Ereignis. → **Owner-Vorlage + #53 (PMC-Bau).**

**C-03 · Die fail-closed-Wache fuer `target_isa.numa_node`/`.page`/`.core_class` fehlt ABSICHTLICH** (07.08. abend-16, Z27352-27368)
Vierfach belegt: der Parser fuellt sie, *„niemand liest sie"*; die Gueltigkeitspruefung folgt *„mit dem Resolver-Schritt"* (Aktenzeichen OD-11-RT-K); die XSD fuehrt beide Felder absichtlich als `xs:string`, *„damit eine additive Erweiterung des Wertraums das Schema nicht bricht"* — **keine Enumeration, gegen die man pruefen koennte**; es gibt keine Soll-Seite. Eine Wache zu bauen hiesse, einen Wertebereich zu ERFINDEN (was dieselbe Datei 50 Zeilen weiter oben verbietet). **Kontrastprobe am echten CLI:** Bogus-`isa` wird abgelehnt („Erlaubt = x86_64, aarch64", VALIDAT FEHLGESCHLAGEN), Bogus in **allen drei** Unter-Achsen laeuft durch (VALIDAT OK). → **#53 + T-13/T-14-Fehlerklassen: eine XML-Fehleingabe faellt im Messfenster nicht auf. Dieselbe Resolver-Luecke wie C-02, unabhaengig gefunden.**

**C-04 · GN-9 Feasibility-/Kalibrierungs-Gate hat bis heute KEINEN Slot im Fahrplan** (07.08. mittag-4, Z25745-25746)
Per Definition VOR der Voll-Matrix faellig; im Ledger-Audit als einer von zwei ungeloesten Alt-Posten benannt (neben A14/FF0). → **#7-Ausgang / Wellenplan vor W3.**

**C-05 · Distributions-Matrix ENTSCHIEDEN: 21 Images** (07.08. mittag-3, O-C, Z25517-25526)
Owner verbatim: *„Wir machen die vollstaendigste Liste 3 ueber alle 7 OS der Liste 1 ueber 3 neueste Versionen jedes OS."* = die SIEBEN OS der produktiven Cluster-Registry (`debian-sid`, `ubuntu-2404`, `fedora-42`, `alpine-321` [musl], `archlinux`, `opensuse-tw`, `rocky-9`) x 3 neueste Versionen. **Damit ist die 7-vs-8-Frage (Gate W10-00) beantwortet: nicht 7, nicht 8, nicht 18, sondern 21.** Ubuntu IST eines der sieben. → **Wellenplan/Infra + Marker an allen 7/8/18-Fundstellen (der Entscheid steht nirgends im Massstab).**

**C-06 · Plattform-Rollen und Debug-Only-Plattformen** (07.08. mittag-2, Z25332-25340)
Docker-Builds auf bare metal UND Talos in voller Matrix; **prod1+prod2 tragen zusaetzlich Windows Server 2022 + Win 11 als vier eigene Runner** (id53/id55 prod1, id54/id19 prod2 — nur id19 online, drei brauchen Auth-Token-Reset + Vault-Creds), in der cache-engine-CI **0 Windows-Jobs**; macOS x86+ARM, RISC-V (VisionFive 2), Pi 5 kompilieren und messen **nur im DEBUG-Modus**; PILOT: prod1+prod2 zuerst vollstaendig, nur echt gemessenes bare metal, Rest nach der Abgabe — **die ZIH-Erweiterung wird trotzdem vollzogen** (Owner, zweimal bestaetigt). → **Wellenplan + Infra-Handout Teil B.**

**C-07 · Talos-Rollentrennung vollzogen — und minio.comdare.de ist DEV, nicht prod** (07.08. morgen-1 Z25116 · nachmittag-1 Z26085-26095)
Die Erhebung laeuft NUR unter root-Linux baremetal (16/16 CSV-Zeilen `platform=linux-x86_64`; Mess-Jobs hart `[prod, baremetal, amd]`); Talos ist die immutable Bau-/CI-/Cache-Schicht. Die Thesis-Korrektur ist vollzogen (thesis `eaf7fe8`, Praesens Passiv → Sollform + Vollzugsstand, ADR-12 mit eigenem Feld „Vollzugsstand", DE fuehrend). **Nebenbefund:** `minio.comdare.de` ist durchgaengig **dev-MinIO** (`.gitlab-ci.yml:55`), nicht prod — der Owner nannte es „cluster PROD"; im Text als dev-MinIO fuehren. → **Thesis (erledigt) + Cache-Landschaft/KON67-Topologie (Bezeichnung).**

**C-08 · O-C Pinning-Pflicht** (07.08. mittag-1, Owner verbatim)
*„Pinning ist Pflicht bei hybrid Architekturen, deren CPU-Kerne sich unterscheiden (sofern pinning durch mehrere Achsen freigegeben ist -> bereits geplant)."* Mit C-01 greift das auf prod1 **heute schon** an der L3-Achse. → **W3-Betrieb.**

**C-09 · Kollisionsregel: Substanz gewinnt, der Trigger darf rutschen** (05.08. abend-5, F5, Owner verbatim: *„Bitte Variante b: Wir bauen geradeaus weiter."*)
→ **Rangfolge-Regel bei Konflikten am 26.08.-Fenster (steht nicht im Massstab).**

---

### KORB D — ohne Frist-Anker (Abgabe, Prozess, Register)

**D-01 · DREI Lizenz-Abweichungen Thesis ↔ Allokator-Akte — gedruckte Tabelle** (07.08. abend-10, Z26852-26862)
`michael_lockfree`: Akte **LGPL-2.1-or-later**, Thesis BSD-3 (PAPER_REFERENCES nennt zusaetzlich MIT — dritte Angabe) · `tcmalloc`: Akte **Apache-2.0**, Thesis BSD-3 · `lrmalloc`: Akte **MIT**, Thesis BSD-3. **Das Gate faengt das nicht** (die Thesis liegt in einem anderen Repo) und sagt das in seinem Selbstcheck auch. Nebenbefund: `ext/A05-jemalloc` ist eine **getrackte Dublette** zu `ext/allocator/A05-jemalloc`. → **Release-Checkliste + Owner (bei einer Diplomarbeit mit gedruckter Lizenz-Tabelle nichts, was still korrigiert wird).**

**D-02 · Allokator-Aktenbestand + eine Test-Doktrin-Lehre** (07.08. abend-6/abend-10, Z26542-26588, 26836-26850)
23 Doku-Akten (**alle** tragen den `DOKU-AKTE`-Kopf mit Aktenzeichen #48 Scheibe 2), 10 implementiert (= exakt die zehn der Thesis-Tabelle A01 A03 A04 A05 A06 A07 A08 A10 A11 A20), 13 reine Doku; die alte README-Zeile „Mitglieder (10)" benannte die MITTLERE Menge. Gate gelandet (`5adf59ea`, sieben Bissproben). **BISS-B-Fund:** der KF-1-Reader ist **fehlertolerant, nicht validierend** — eine abgeschnittene Datei zaehlt weiter als „sauber geparst" (PARSE-QUOTE blieb 23/23); rot wird das Gate nur ueber die Pflichtfeld-Pruefung. Und: *„ein Bestands-Gate, das sich seine Erwartung aus demselben Verzeichnis holt, das es prueft, kann per Konstruktion nichts entdecken."* → **Fallen-Register + Test-Doktrin (#28).**

**D-03 · T-9-Katalog gebaut — und eine echte Owner-Frage blieb offen** (07.08. mittag-6, Z25921-25953)
`heuristik/axis_optimization_catalog.hpp` (436 Z., constexpr): 19 Achsen T0..T18, **45 Zielgroessen** mit expliziter Richtung, jede mit BEFUND-Zeilennummer rueckverfolgbar. **Kern: die Richtung haengt an der ZIELGROESSE, nicht an der Achse** (T3 will MAX Kompressionsrate UND MIN Baumhoehe). Pareto-Achsen **T5/T6/T18 verweigern compile-time** die Einzel-Richtungs-Frage. Korrigierte Zahlen: 17 MAX / 32 MIN Nennungen, operationalisiert 17 MAX / 28 MIN / 45. **OFFEN (Owner):** `persistence_target`/T19 hat **keine Katalog-Zeile** — `catalog_axis_from_name` ist dort honest-empty, ein consteval-Anker (17 gemeinsam + 2 nur-Katalog + 1 nur-Komposition) bricht bei jeder kuenftigen Verschiebung. → **Owner-Vorlage; koppelt an KON80-V10 (ORG-19-IO) und Gegenlese-W14.**

**D-04 · G-3: der Selektor kennt nur Minimize** (07.08. abend-9, Z26795)
`best_binary_selector.hpp:236-254` traegt alle SECHS Metriken hart `Minimize` — im Widerspruch zum T-9-Katalog (17 MAX). Die Bruecke ist ein SPIEGEL (Selektor C++17, Katalog C++23) mit echtem Paritaets-Gate: der Test inkludiert den ECHTEN Katalog-Header und haelt Enum-Gleichheit + zwei Katalog-Zeugen per `static_assert`, Drift bricht compile-time. → **#18/Auswertung + Owner (siehe C-7 unten).**

**D-05 · T-8: der Selektor lieferte eine DOMINIERTE Binary aus** (07.08. nachmittag-1, Z26054-26063)
`rank_binaries` rankte EINE Metrik, `best_binary_selector_main` nahm `ranked.front()`; bei Median-Gleichstand entschied der Tie-Break „mehr Samples zuerst". Bissbeweis mit dem echten CLI: `bin_tie_loser` (lookup=100, scan=500) wurde **versandt**, obwohl `bin_true` (lookup=100, scan=200) sie strikt dominiert. *„Es ist der Auslieferungspfad."* Gelandet (`21560a2e`). → **keine Aktion; als KLASSE in die Verify-Pflicht (der Auslieferungspfad ist der teuerste Ort fuer stille Defekte).**

**D-06 · Vor-Push-Wache: Zwei-Punkt- statt Drei-Punkt-Diff — eine Wache, die zur Regression verleitet** (07.08. abend-16, Z27327-27350)
`git diff origin/development..HEAD` → 12 Dateien (Endpunkt gegen Endpunkt), `...HEAD` → 1 Datei (ab der Abzweigung). Zwei Schaeden: der Autor sucht in fremdem Code nach einem Verstoss, der ihm nicht gehoert — **und „heilt" fremde Zeilen auf seinen ALTEN Stand zurueck, schleppt also einen Rueckwaerts-Merge ein**. Behoben (`962457b0`): Drei-Punkt-Semantik, die Abzweigung wird mitausgegeben, ein weitergezogener Basiszweig wird ausdruecklich gemeldet. **Lead-Fehler derselben Klasse:** Nicht-ASCII ueber die GANZE Datei gezaehlt (134) statt ueber die Zusatzzeilen (0). → **ARBEITSWEISE + #19: das ist die Vorlage fuer die zweite, schwaechere Diff-Hygiene-Fassung in super (Gegenlese Korb D #11).**

**D-07 · REGEL-ZEILE 17 — ein Befund traegt sein Erhebungsdatum** (06.08. abend, Z25102-25106)
> *„Ein Befund traegt sein Erhebungsdatum. Wer ihn zur Handlung macht, misst ihn vorher gegen den heutigen HEAD — nicht gegen den Stand, an dem er geschrieben wurde."*
Anlass: das Checkheft verdichtete 121 Berichte, ohne nachzumessen; zwei Fixe, die GENAU DIESELBEN Zeilen heilten, waren beim Verdichten bereits gelandet (`c1c76c87`, `0b5ed557`) — **die Befunde ueberholten sich selbst, bevor sie jemand las**. *„Ein ungeprueft gebauter Befund, der sich als bereits geheilt herausstellt, waere teurer als der urspruengliche Defekt."* → **ARBEITSWEISE — gilt unmittelbar fuer diese Konsolidierung.**

**D-08 · NULLBEFUND-Doktrin, zweifach** (07.08. abend-4 Z26467-26469 · abend-5 Z26510-26514 · abend-6 Z26553-26560)
(i) *„Ein Befund der Form ‚X ist nicht verdrahtet / fehlt / ist nicht gebaut' ist ein NULLBEFUND"* und wird erst zur Aussage mit der Gegenprobe *wer inkludiert, linkt, ruft, referenziert X?* — der gesuchte Aufruf stand in `cmake_language(DEFER DIRECTORY ... CALL <fn> <target>)`, eine Namenssuche in `tests/` findet ihn nicht; die Gegenprobe kostete **drei greps**. (ii) *„Ein Nullbefund in EINER Quelle ist kein Befund ueber die Sache"* — die Antwort auf die allocators-Frage stand in **jeder einzelnen der 23 Dateien**, nur nicht im Ledger. Vier Auspraegungen an EINEM Tag (Phasen-Fehlzuordnung · Committen waehrend laufender Pruefung · „nicht verdrahtet" · „vergessen"); gemeinsamer Nenner: **eine Abwesenheit wurde als Aussage genommen**. → **ARBEITSWEISE.**

**D-09 · Fallen dieses Segments (fuers Fallen-Register)**
- `git -C <worktree>/thesis rev-parse --show-toplevel` liefert das **ELTERNREPO**, wenn das Submodul dort nicht ausgecheckt ist — `git -C` sucht aufwaerts statt zu scheitern (Z26652-26657).
- **Vor jeder Objekt-Messung Checkout UND Branch feststellen:** der ce-Hauptcheckout stand auf `b-m2-pmc-invariante`, `wt-landung` auf `bau/flag-grammatik-v2-s1` mit 173 uncommitteten Dateien → `git show <sha>:<pfad>` statt Arbeitsbaum (Z25753-25755, 26748-26753).
- **Die `/jobs`-API zeigt keine Bridges** — eine Pipeline kann rot sein, waehrend alle Jobs gruen sind (Z25469).
- **Falsches ROT durch stale Generator:** `ninja` uebersprang Targets, das `*_registry_gen`-Binary blieb vom Vortag; der Roundtrip wurde falsch rot, ausgerechnet an der `core_class`-Zeile. Gegenmittel: **zuerst `stat -c '%y'` Generator-Binary gegen Quellen**, dann den Code verdaechtigen; `EXCLUDE_FROM_ALL`-Generatoren haengen nicht am Default-Target (Z25892-25908, 27215-27219).
- **Vor `worktree remove --force` IMMER die ungetrackten Dateien sichern** — ein am Limit gestorbener Agent hat typischerweise NICHT committet; die geborgene Fassung war ausserdem **nicht uebersetzbar** (gtest-Makros an Komma-getrennten Template-Argumenten), der UNGEPRUEFT-Vermerk trug (Z26065-26083).
- **Ein Lint-Werkzeug darf nie den fuehrenden (deutschen) Text umformen** — projekteigener Weg ist die Inline-Ausnahme `% chktex NN` (17 .tex-Dateien nutzen sie) (Z25472).
- **Es existieren ZWEI Thesis-Checkouts**; der Separat-Klon `20260931-overleaf-diplomarbeit` ist veraltet, das Submodul traegt den Stand — zwei Plandokumente und ein Agent haben sich daran verlesen (Z25452-25456, 25822-25823).

**D-10 · 79 von 220 CMake-Zielen tot** (07.08. mittag-7, Z26019-26023)
`tests/unit/CMakeLists.txt`: 35 namentlich + 44 schleifengeneriert. Als Zweizeiler gelandet, aber **nicht** in der §75-Kandidatenliste; die namentliche Liste existiert nur im Endbericht des Workflows. Ebenso fehlt `COMDARE_VARIANT_GATE` dort. → **#28 / Aufraeumpass.**

**D-11 · A15/§55-Gesamt-Reconcile ist NIE vollzogen — der Wurzel-Fund des Ledger-Audits** (07.08. mittag-4, Z25737-25746)
43 von 43 geprueften Positionen nicht sauber erfasst. Ursache: das Konsolidierungs-Register ist **per Konstruktion ein 14-Tage-Fenster ab 23.07.**, der letzte Voll-Block §55 (LEDGER:2829-3060, 20.07.) liegt DAVOR und wurde nie ueberfuehrt; die B-Liste (B1-B13) wurde mitgenommen, die A-Liste (A14/A15) derselben Quelle nicht — **und der Posten, der genau diese Uebertragung anmahnte, ist selbst der prominenteste Verlust**. **A14/FF0 Multi-Plattform-Generalitaet** steht im Alt-Block ausdruecklich als „Abgabe-Blocker, hoch" (§55:2916) und wurde seither nur zweimal selbstreferenziell erwaehnt. Volle Liste lag in `tmp/wisfvjd8z.output` (Temp-Pfad — vermutlich verloren). → **Wellenplan/W4 + genau diese Konsolidierung: das Fenster-vor-23.07. ist strukturell ungelesen.**

**D-12 · E-1 Owner-KERN: der Compile muss nachvollziehbar sein** (06.08. frueh-6, Z24960, Owner verbatim)
*„in Zukunft soll die Diplomarbeit einerseits fertig auf den branch gepusht werden, aber andererseits wird sie zusaetzlich in einen Ordner an der Wurzel der Messwerte kopiert, samt latex compile-export (Benennung nach Datum und Uhrzeit). so laesst sich ein compile nachvollziehen."* Gebaut als E18-SNAP (`measurement/thesis_compiles/<TS>/` mit PDF + `compile-export.txt` + `QUELLSTAND.txt` [289-SHA/288-SHA/Lauf-ID], sha256-verifiziert, Schalter `AF_COMPILE_SNAPSHOT`/`AF_SNAPSHOT_ROOT`). Load-bearing-Fund: `super/.gitignore *.log` (Z.49) haette `compile.log` **stumm geschluckt** → daher `compile-export.txt` (Owner-Vokabular). **Landungsstand ungeklaert** — auf `5c4cf900` liegt ein stehendes NICHT-LANDEN-Verdikt (Z26026). → **#18 (E-18-Buendel): Status am Objekt pruefen; der Owner-KERN steht nirgends im Massstab.**

**D-13 · E-2 Owner-KERN: 2D/3D-Graphen nach Paper-Vorbild statt Heatmap** (06.08. frueh-6, Z24961, Owner verbatim)
*„eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper? Orientiere dich daran und verwende 2D und 3D Graphen."* Der SOTA-Katalog der Paper-Darstellungsformen + Top-3 je Mess-Dimension (2D/3D, pgfplots-Machbarkeit) liegt in `backups/20260806-e2a-planungs-welle/`. → **#18 / W4-Auswertung.**

**D-14 · A5 Owner-Achsen-KERN: Sortierungen sind KEY-Filter, MAP traegt key- UND value-Filter-Achse** (05.08. abend-10/abend-11, Z25021, 25025-25026)
Owner verbatim: *„Sotierungen zaehlen unter key Filter … wobei MAP grundsaetzlich eine key und eine value Filter-Achse haben sollte. Dies wird auch in einigen Papern betrachtet."* Deep-Research-Ergebnis: **Filter-Achse ist T16** (nicht T14 = I/O-Dispatch — genau die T-ids-Falle); Sortierung-als-Key-Filter literatur-durchgaengig gestuetzt (Zonemaps/SMA seit VLDB'98, Fence Pointers, LSM-Runs; Monkey SIGMOD'17 fuehrt beide KOMPLEMENTAER); Posten 60 liefert ungenutzt bereits ein O(1)-Min/Max-Zonemap-Fenster und wandert vom search_algo-Wrapper zur Filter-Familie. **Vier UNBEWERTETE Optionen fuer die Value-Filter-Verortung** (A T19-Hauptachse / B Sub-Familie in T16 / C Gattungs-Ebene MAP / D Wrapper-Familie). **DOKU-EHRLICHKEIT (Pflicht):** kein Paper traegt woertlich „Key-+Value-Filter-Achse" fuer eine Map — die Owner-These ist eine literaturgestuetzte SYNTHESE (Idreos + NEXT/Perseid + Curator) und ist in Thesis/Doku als solche auszuweisen. → **Designplan (Bau nach Abgabe) + Thesis.**

**D-15 · SF-1: eigenes Owner-Fenster VOR der Abgabe** (06.08. vormittag-22, Z24778, Owner verbatim: *„SF-1: Vor Abgabe bitte ein eigenes Fenster."*)
Gegenstand: anatomy→builder-Traits-Split (G8). Steht nirgends im Massstab. → **Wellenplan.**

**D-16 · Posten 92 Registry-Kanon-Divergenz** (06.08. frueh-6, E-5, Z24964)
Heilung `validate`-2er vs. `plan`-3er, Owner: *„Noch vor Abgabe bitte, wir koennen die Nacht durch arbeiten."* → **Task-Karte/Wellenplan (Status am Objekt pruefen).**

**D-17 · Anhang-A-Reichweite: 16/44 belegt, KEINE Owner-Freigabe** (07.08. morgen-1, Z25130)
Anhang A deklariert je Sprache 44 Fragmente, 16 mit echten Messdaten, 28 leer (per `\InputIfFileExists` gegatet, im PDF unsichtbar). Lead-Empfehlung Weg 1 (bei 16/44 bleiben + Luecken-Zeile in `le_limitierung.tex` DE+EN) liegt vor, ohne Freigabe; die „NACH-Abgabe"-Praemisse ist durch die Termin-Korrektur auf 15.09. widerlegt. Spaeter gemessen: `\InputIfFileExists` DE=30 / EN=30 (abend-7). → **Thesis/Owner; koppelt an KON58-13 (28-vs-13) und das F5-Anhang-Gate.**

**D-18 · Der Generator dreht die Ehrlichkeits-Korrektur still zurueck** (07.08. mittag-7, Z25969-25991)
`anhang/{de,en}/tabellen/le_limitierung.tex` Zeile 1: `% AUTO-GENERATED durch csv_to_latex::write_limitations_longtable`. Der Generator lebt in **super** (`Code/04_csv_to_latex/csv_to_latex.cpp:951 ff.`, ce hat 0 Fundstellen) und emittiert *„Cache-Misses: L1/L2/L3 + dTLB + Coherence + Energy = 0 / nicht erhoben"* — die seit der V-08-Nachmessung **widerlegte** Fassung. **Der naechste Generatorlauf ersetzt die richtige Aussage durch die falsche.** EINE Textstelle. *„Die gerade gelandete Ehrlichkeits-Korrektur hat damit ein Verfallsdatum, das niemand notiert hatte."* → **#18/Thesis — Status am Objekt pruefen.**

**D-19 · Thesis-Stolperstelle 2^17 bei achtzehn Achsen** (07.08. abend-7, Z26615-26627)
Die Thesis rechnet RICHTIG: `source_catalog.hpp:135` — *„Owner-Entscheid Q-1 = FALL B: 17 Achsen je 2, `persistence_target` (K17) auf 1 GEPINNT"*, `CatalogAxes<2,...,2,1>` = 2^17 x 1. Die Formulierung nennt das Pinning aber nicht — ein Pruefer, der 2^18 rechnet und 2^17 liest, verliert Vertrauen in die Zahl. Halbsatz ergaenzen („davon eine auf einen Wert gepinnt"), DE fuehrend. Aufschaltung waere K17 auf 2 **und** `COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK=ON`. → **Thesis + siehe Widerspruch C-6 (ORG-19/required koennte K17 entpinnen).**

**D-20 · DE/EN-Referenzstand (fuer kuenftige Drift-Messungen)** (07.08. abend-7, Z26594-26613)
Struktur 1:1 (6 lebende Kapitel + 6 Anhaenge je Sprache), Section-/Subsection-Zahlen und `\label{}`-Namen **zu 100 % identisch**; EN/DE-Wortverhaeltnis 1,08-1,27; DE **204** / EN **194** Seiten, 0 LaTeX-Fehler, 0 undefined refs; Messwerte in den 18 auto-generierten Tabellen byte-gleich; die acht toten Alt-Kapitel liegen in BEIDEN Sprachordnern mit Deprecation-Kopf und identischen Fundstellen-Zahlen. **Null Widersprueche.** → **keine Aktion — als Nullpunkt festhalten.**

**D-21 · 1xN-/Nx1-Matrix bricht `matrix plot` fatal** (06.08. vormittag-6, Z24864)
Nur 1 Algorithmus ODER 1 Workload im Korpus → Bestandsfehler, als B-REST-Kandidat registriert. Trifft jeden Teil-Korpus und jede Einzel-Achsen-Auswertung. → **#18.**

**D-22 · VIER namensgleiche Modi-Vokabulare** (07.08. mittag-2, Z25323-25326)
`RunMethodology{debug,measure,release,compare}` · die vier „Betriebsmodi des Builders" (`kapitel/de/03_messsystem_prtart.tex:1428-1431`, Zukunftsbild) · die drei Pruefling-Mess-Schema-Modi (`05_evaluation.tex:212-216`) · `--mode=defined|full|full-sampled` (`apps/cache_engine_builder/main.cpp:52,79`). → **Register/Vokabelpflege.**

**D-23 · Codex-MCP-Schreibrechte** (06.08. vormittag-31, Z24725, Owner-Dauer-Regel)
*„codex fragt staendig um erlaubnis per mcp, bitte in Zukunft die Rechte zum Schreiben mitgeben"* → jeder `mcp__codex__codex`-Aufruf mit `approval-policy=never` + `sandbox=workspace-write` + `cwd`. → **ARBEITSWEISE.**

**D-24 · Spend-Limit-Abriss verhaelt sich wie ein Session-Fork** (06.08. vormittag-33, Z24708)
*„Commits ueberleben, Berichte nicht"* — die Wiederanlauf-Doktrin (Objekt-Ist vor Journal-Glauben) griff exakt. Folgeregel: Agenten in kleinen, committeten Schritten arbeiten lassen. → **ARBEITSWEISE (ergaenzt die Memory-Regel „STUMME WORKFLOW-TODE").**

---

## (B) UEBERHOLT-OHNE-MARKER (Marker-Nachzug)

| # | Anker | Ueberholte Aussage | Ueberholt durch |
|---|---|---|---|
| B-a | Z25375-25376 (07.08. mittag-2, §3 ROLLEN) | *„Fable-5 bleibt Agenten-Modell … aber NIE als Director. Explore bleibt Sonnet-5-max."* | Memory 12.08. („ueberall nur Fable 5 max, bis Widerruf") · KON58-09 v3.6 (Opus ERHEBT / Fable BEWERTET) · Owner 13.08. (Code-Review-Analyse = Opus 5 max EXPLORE + Fable 5 max ANALYST) |
| B-b | Z25049-25050 (05.08. abend-6, Owner-Dauer-Regel) | *„fuer einen Explore Agenten immer Sonnet 5 auf max effort very thourough"* | dieselben drei; die Regel wird im Segment noch zweimal bekraeftigt (Z24858, Z24718-F2) |
| B-c | Z24779/24781 (06.08. vormittag-22) | „OD-7: Runner-Direktive **2/2 normal + 24 Worker heavy** DURCHSETZEN" | KON73-F7 (CI-normal 3/2 je 4 Kerne, heavy 16, ce `floor((T-4)/4)x4`, `--debug` Tx1) + Memory „prod1 = 16 Kerne/32 Threads" |
| B-d | Z25341-25346 (07.08. mittag-2, §2.5) | „OFFENE DISKREPANZ 7 vs 8 Distributionen … im Ledger als Gate W10-00 auf ‚nach der Abgabe' gebucht" | **O-C desselben Tages** (Z25517-25526): 7 OS x 3 Versionen = **21 Images** — die aeltere Stelle traegt keinen Marker |
| B-e | Z25037-25038 (05.08. abend-8, PREIMAGE-SOLL) | „Format 3, **8 Glieder**, GliedCount 6→8" | Format 4 / 9 Glieder (`anatomy_fingerprint.hpp:106`, MessGatesGlied) — und im Massstab bereits Ziel **Format 5 / 10 Glieder** (Gegenlese Korb A #1) |
| B-f | Z26869-26875 (07.08. abend-10) | „`development` traegt Format 4, 9 Glieder" (als Ist gefuehrt) | Gegenlese Korb A #1 (Format 4→5, GliedCount 9→10 im #15-Fenster) |
| B-g | Z26256-26257 (07.08. abend-2, O-KERN) und Z26888-26891 (abend-10, E-E) | *„Fenster 0 steht offen (null Binaries, null .fingerprint), ein Byte-Ereignis kostet JETZT nichts, spaeter **34,4 h** Neubau"* | **Fenster 0 ist geschlossen** (F1 geliefert 14.08., Messung 377503, KON63) · die Neubau-Zahl ist durch KON41-01/OV-4 ersetzt (41,4 h@24W → ~45,6 h@16W) · Memory: „Umbauten heute kostenlos, ab 26.08. teuer" |
| B-h | Z24956 (06.08. frueh-7) und Z24940 (frueh-9) | Prioritaets-Baender **P0-P4** als bindende Reihenfolge | Wellenplan + Task-Karte (#3…#74) + Ledger-§18-Task-Zuordnung 13.08.; P0-P4 taucht im Massstab nicht mehr auf |
| B-i | Z25062-25066 (05.08. abend-4, VOR-TRIGGER-CHECKLISTE B1-B13) | die 13 Posten als offene Arbeitsliste | grossteils vollzogen (B1/E-18, B7/V4-Vorlage, B12-Linie, B14/golden-XML, B6-Entscheide) — **ohne Vollzugs-Marker an der Listenstelle**; ausdruecklich NICHT vollzogen bleiben A14 und A15 (siehe A/D-11) |
| B-j | Z25431-25433 und Z26228-26229 | Zeitfenster-Semantik „T1 = vor dem ersten 4096er-Batch … **T3 = vor dem 15.09.**" | Kopf: **T-3 ~Sa 12.09. = manueller Reset + ECHTE Messung** — dasselbe Kuerzel, anderer Gegenstand (vierte Bedeutung von „T-n" neben T0-T18, T-8/T-9/T-10 und den Zeitfenstern) |
| B-k | Z25221-25223 / Z25368-25370 (07.08. mittag-1/-2) | „der xlsx-Writer EXISTIERT NICHT (0 Treffer …)" | KON74 (xlsx-SOLL: EINE Datei, Sheet je Unter-Achsen-Permutation) · KON87/88 (Sheet-Hierarchie-Design 13/13, P1-VOLLBILD) · KON89-D3 (CSV=FACTORY) — Ist-Stand am Objekt neu zu messen |
| B-l | Z26990-26994 (07.08. abend-12, Pipeline-Tabelle) | „ce 15221 **LAEUFT** — der kritische Lauf" | abend-13 (Z27085): *„genau so ist heute Pipeline 15221 rot geworden"* (Plattenkapazitaet) — die Tabelle traegt keinen Nachtrag |
| B-m | Z25443-25444 (07.08. mittag-2) | Anhang D: „die drei Mess-Modi existieren noch nicht als Typen" | O-E desselben Tages (vier Modi, existieren als Enum + constexpr-Registry) — im Segment entschieden, an der Ledger-Stelle nicht markiert |

---

## (C) WIDERSPRUECHE zum Massstab (beide Wortlaute, ohne erkennbare Aufloesung)

**C-1 · `resource_group` fuer die Messung: gebaut oder nie umgesetzt?**
- Massstab (Gegenlese Korb C #10, aus KON29-04): *„die Messung ist NICHT ZWEILANIG: `resource_group ceb-measurement-exclusive` hart amd/prod1; §61-Revision (`ceb-measure-<host>`, 21.07.) **nie umgesetzt**, Intel-Gegenstueck fehlt; `window_belongs_to` gebaut, nicht verdrahtet."*
- Segment (07.08. nachmittag-1, Z26050): *„| E | **resource_group PMU host-scoped** | ce `0c80aa78` |"* — als GELANDETE Welle gefuehrt; Anlass war der Befund *„PMU ist eine EXKLUSIVE Ressource ohne `resource_group`; `resource_group` kommt in der CI null-mal vor"* (Z25393-25398).
→ **Aufloesung:** am Objekt messen, was `0c80aa78` wirklich host-scoped gemacht hat (CI-YAML vs. Code) — entweder ist die KON29-04-Zeile stale, oder die Welle deckte nur den ce-Anteil. **Vor W3 klaeren, sonst faehrt die Kampagne einlanig oder mit falscher Annahme.**

**C-2 · Sind `w/ma/mi` INSTRUMENTE oder GEGENSTAENDE?**
- Segment (Z25653-25659): *„Die Tooling-Achse {wallclock,macro,micro} schneidet **INSTRUMENTE**, die Ebenen [E1/E2/E3] schneiden **GEGENSTAENDE**"* — mit Beleg `measurement_tooling_registry.hpp:30` („feinkoernige PMC/Counter-Instrumentierung").
- Massstab (KON88-P1): *„unter `ma` je Genus-Interface, `mi` je Achsen-Microbenchmark"* — das ist der **Gegenstands**-Schnitt (E2 bzw. E1), nicht der Instrumenten-Schnitt.
→ **Aufloesung:** die beiden Schnitte fallen NUR fuer `ma`/`mi` zufaellig zusammen; `w` (Wallclock) ist als Instrument in E1 UND E2 vertreten (E1: „GEMISCHT — Wallclock und PMC"). Die Sheet-Hierarchie braucht die Entscheidung explizit, sonst landen E1-Wallclock-Zeilen unter `w` statt unter `mi`. **Kein Owner noetig, wenn das #18-Design den Schnitt benennt; sonst Owner-Vorlage.**

**C-3 · Break-Even: Ort vs. Parameter — vertraeglich, aber nirgends zusammengefuehrt**
- Segment (Owner 07.08., B-4): *„Break even lebt nur in der CEB nach Messungs-Schluss und wird dort **im RAM** ueber alle Tier-Binary-Messergebnisse ausgewertet … Das Verwerfen IST FALSCH, da wird NICHTS gekuerzt. Voll-Build."* → kein Lager-Objekt.
- Massstab (KON80-V7): *„Break-Even NUR ueber Organ-Parameter der w/ma/mi (Mess+System = Umwelt-Permutation+Freigabe)."*
→ **Aufloesung:** V7 bestimmt die PARAMETER, B-4 den ORT und die Vollstaendigkeit. Beide gelten; **Ein-Satz-Vermerk an V7**, dass der Ort CEB-RAM ist und nichts gekuerzt wird (das verbietet insbesondere eine Break-Even-Vorauswahl auf einer Teilmenge).

**C-4 · Bau-Menge: „nur die 320er, die wir messen" vs. Voll-Matrix**
- Segment (Owner 07.08., D-3, zweimal verbatim): *„Wir bauen nur die 320er die wir auch tatsaechlich messen und stellen die golden XML darauf um."*
- Segment/Massstab: realer Ist-Umfang 524.288 (vier System-Perms), 12-Perm-Doktrin 1.572.864, line_size 2.097.152 (B-09) · KON71: *„Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet sie."*
→ **Aufloesung:** D-3 ist eine Regel („Bau-Menge folgt Mess-Menge"), keine Zahl; die Zahlen sind S-19-Eingangshypothesen. **Der ausfuehrbare Teil von D-3 — golden-XML auf die tatsaechliche Mess-Menge umstellen — ist im Massstab nirgends verbucht und beruehrt B14/#16.**

**C-5 · Optimierungs-Richtung: Katalog vs. Selektor**
- Segment (T-9, Z25921-25937): 45 Zielgroessen, **17 MAX / 28 MIN**, Richtung an der Zielgroesse.
- Segment (G-3, Z26795): `best_binary_selector.hpp:236-254` — **alle sechs Metriken hart `Minimize`**, als bestaetigter Owner-Entscheidungsbedarf gefuehrt.
→ **Aufloesung:** der Selektor spiegelt heute nur eine Teilmenge; das Paritaets-Gate haelt Enum-Gleichheit, **nicht** Richtungs-Gleichheit. **Owner-Vorlage: welche der sechs Selektor-Metriken sind MAX?** (Ohne das rechnet die Auslieferungs-Auswahl fuer jede MAX-Groesse falsch herum — dieselbe Klasse wie der T-9-Ausgangsdefekt.)

**C-6 · `persistence_target`: gepinnt (2^17) vs. erste required-Deklaration (ORG-19)**
- Segment (Z26619-26623): K17 = `persistence_target` ist **auf 1 GEPINNT** (Owner-Entscheid Q-1, FALL B) → 2^17 x 1 = 131.072; Aufschaltung braeuchte K17=2 **und** `COMDARE_AXIS_PERSISTENCE_ENABLE_DISK_WRITEBACK=ON`. Zusaetzlich: `persistence_target` hat **keine T-9-Katalog-Zeile** (D-03).
- Massstab (KON80-V10 / KON91): ORG-19-IO = erste Organ-Meta-Meta-Achse, XML-opt-in, Genus-Interface +`store()`/`load()`; *„erste required-Deklaration = Festplatten-IO/ORG-19"*; Gegenlese-W14 fragt bereits, ob `persistence_target` (T17, OFF) daneben bestehen bleibt.
→ **Aufloesung:** Explore am Objekt — wird ORG-19 scharf, entpinnt das K17? Dann aendert sich die **gedruckte Zahl 2^17** in der Thesis (D-19) und die Bau-Menge (B-09). **Vor jeder Thesis-Zahlenaenderung klaeren.**

**C-7 · Enum-Ordnung `run_methodology` vs. Stufen-Ordnung**
- Segment (O-A, Z25485-25498, Owner verbatim): *„formal kommt compare als Stufe mit eigenen Optionen (lesend Messwertlager) vor dem release, der auch die Messwerte nachlesen muss, aber dann eine optimale binary produziert."* → geltende Ordnung **measure → compare → release**, kumulativ; §62-C SUPERSEDED, im Code an vier Stellen nachgezogen (ce `491fff65`).
- Segment (Z25871-25876): der Enum bleibt **`{debug, measure, release, compare}`** — *„bewusst nicht umgestellt, er ist stempel-/ABI-relevant"*, stattdessen eine NICHT-VERWECHSELN-Notiz; *„Falls der Owner will, dass der Enum die Ordnung abbildet, ist das ein eigenes Byte-Ereignis"* — **vorgelegt, nie beantwortet** (G-5 verstaerkt die Frage, Z26799-26801).
→ **Aufloesung:** Owner-Entscheid, und wenn ja, gehoert er in das F2-Bump-Fenster (#15) — nach dem 26.08. ist die Ordinal-Verschiebung ein Flotten-Preis.

**C-8 · Mess-Ebenen-Zahl**
- Segment (Z25639-25651): **drei** Ebenen E1/E2/E3, E3 aggregiert E2, Nullbefund zu abweichender Stufenzahl.
- Massstab (Gegenlese W3): drei Ebenen, die **vierte = SPALTE der Macro-Stufe beim Hybrid**, PMC = Meta-Meta (keine Ebene).
→ **Aufloesung:** vertraeglich — E3 („EIN Lastprofil = Aggregat ALLER E2-Charts") ist NICHT die vierte Ebene, sondern die Aggregation; die vierte Spalte (Hybrid-Macro) steht daneben. **Ein-Satz-Vermerk an beiden Stellen, damit E3 nicht kuenftig als „die Vierte" gelesen wird.**

---

## (D) ARCHITEKTUR-KERNE DIESES SEGMENTS

1. **Compiler-Achse, Owner-Herleitung (05.08., F1/O-2 — die tragende Quelle fuer KON55/56):** *„per Plan und Dokumentation [geben] die System-Achsen und Organ-Achsen auf der CEB die Freigaben fuer den compile der Organ-Achsen auf den Tier-Binaries, was unweigerlich dazu fuehrt, dass ALLE Laufzeit Hauptachsen wie Compiler auf der CEB, zwangsweise compile time Hauptachsen auf der entstehenden Tier-Binary sein muessen … Die Flags des Compilers werden in der Tier-Binary statisch verbaut, sind also in der Compiler Haupt-Achse ein Teil der Haupt-Achsen Definition selbst."*
2. **Zwei getrennte Stempel-Objekte (D-1-Aufloesung):** Mess-ZEILEN-Stempel traegt die PMU-Domaene voll (*„zwei verschiedene Kombinationen und bekommen zwei verschiedene Stempel; die Binary bleibt eine"*), der BINARY-Stempel ist compile-hart gesperrt (`core_class` in `kSystemCellValueForbiddenKeys`), *„weil die CEB sonst NICHT dieselbe Tier-Binary einmal auf einen E-Core und einmal auf einen P-Core gepinnt starten koennte"*.
3. **Faehigkeit (CT) vs. Laufzeit-Tatsache (RT):** `c{p.e}` sagt *„diese Binary KANN P/E unterscheiden"*, `core_class` sagt *„diese Messung LIEF auf Kern-Klasse X"*. Kein Widerspruch — zwei Welten, zwei Traeger.
4. **Owner, Flag-Semantik (07.08.):** *„jedes character ist ein filter fuer einen Hardware Bereich oder Eigenschaft, in der die Binary gueltig ist und dort laufen kann … Wenn die System-Achse flags und Hardware freigibt, muessen auch nur Achsen-Algorithmen verwendet werden, die mindestens die minimal-Anforderungen unterstuetzen, also ohne Erweiterung oder stufenweise mit Erweiterung bis zur vollen Optimierungs-Stufe."*
5. **Owner, Notation (07.08.):** *„Wir machen also x512.f.vl.bw.dq aus der Notation und trennen das Komposit Flag `memory@1.0.0c.p.e.{x512.f.vl.bw.dq}` … Das flag 'e' fuer experimental ist deprecated weil es jetzt fuer efficiency core steht. Jeder Algorithmus kann eigenstaendig gegen zusaetzliche Meta-Meta-Achsen als Komposit-Erweiterungs-Flags optimiert und kompiliert werden. Die Basis-System-Achsen sind statisch in ihrer Zeile, aber die Meta-Meta-Achsen bilden je Algorithmus eine spezielle Signatur fuer die Kennzeichnung der Eignung einer binary fuer ein System."*
6. **Das war bereits geplant, nur ohne Schreibweise** (LEDGER §40.a:2402, 19.07.): *„je Maschine eine DEKLARIERTE Signatur einzelner SIMD-Flags (cpuid-Ebene, avx512f/vl/bw/dq/vnni), NICHT der Grob-Level avx2/avx512. Organ-Achsen deklarieren ihrerseits, welche Flags sie sinnvoll konsumieren (Organ <= Maschinen-Signatur geschnitten Organ-Sinnhaftigkeit)."* Die Leiter ist GEBAUT und INERT (`simd_organ_requirement.hpp`: `static_assert(!any_organ_declares_required())` — alle neun Organ-Klassen tragen die Leermenge).
7. **Owner, Invalidierung (07.08. abend):** *„Wir WOLLEN den gesamten Bestand invalidieren, weil uns das spaeter das Leben erleichtert. Die Entscheidung fuer den Umbau steht."* Einzige Auflage: **der Bruch muss LAUT sein** — ein Alt-Literal darf nie still zum Sentinel werden.
8. **Owner, Modi (07.08.):** *„release beinhaltet den vorgeschalteten Modus measure und erweitert ihn, und compare beinhaltet den Modus measure ebenfalls als Basis. Wir koennen nur das bauen oder vergleichen, was wir schon gemessen haben."* — `measure ⊂ compare ⊂ release`, Reihenfolge **measure → compare → release** (O-A), Regelfall ist REPLAY, nicht Neumessung.
9. **Owner, Break-Even (07.08.):** *„Break even lebt nur in der CEB nach Messungs-Schluss und wird dort im RAM ueber alle Tier-Binary-Messergebnisse ausgewertet, um dann bei Anforderung durch den Planer in Latex Dokumente, PDF oder xlsx Tabellen nach Zielorte zu giessen (XML bestimmt Verhalten). Das Verwerfen IST FALSCH, da wird NICHTS gekuerzt. Voll-Build."*
10. **Owner, Mess-Granularitaet (O-B/W-3, die STRENGERE Variante):** *„jeder Funktionsaufruf in der Kette aller Aufrufe der CEB ueber die Lastprofile am Pruefdock gegen die Tier-Binary wird als Macro-Benchmark aufgenommen … Das Profil wird je Mess-Layer aufgezeichnet und in einem zeitlich orientierten chart als Profil abgespeichert, der formal als xlsx Messwerte gilt."*
11. **Owner, Genus-Interface (E4/17):** aus jeder Gattung→Genus-Interface-Funktion sind **alle waehrend des Aufrufs durchlaufenen Messparameter abrufbar**, zusammen mit einem **zeitlich geloggten Profil der Achsen-Zugriffsmuster**; Gattung = Kern der Interface-Funktionen, Genus = spezifische Erweiterung.
12. **Owner, Resume (A1):** *„der Store muss zurueckrollen koennen und ohne grosse Verluste resumen … ueber einen Zaehler, welches Binary kompiliert und dann auch in einem zweiten separaten Durchlauf gemessen wurde, sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und persistiert geplant sind."*
13. **Owner, golden-XML (A7):** *„Das ist eine Datei, die zum Trigger als input Basis dient, also zum build. Sie muss bezueglich der vorhandenen Achsen und Einstellungen aber staendig geupdated werden, um auch gegen syntaktische Aenderungen konsistent zu bleiben."*
14. **Owner, KF-6 (A4):** *„Das ist das zu testende Kernfeature … es muessen dennoch alle unterstuetzt sein, sofern von der Hardware freigegeben"* — Musterwahl CEB-RT + Tier-CT, aber **alle** line_sizes im parametrischen Vollausbau.
15. **Owner, Filter-Achsen (A5):** *„Sotierungen zaehlen unter key Filter … wobei MAP grundsaetzlich eine key und eine value Filter-Achse haben sollte."*
16. **Owner, Methode (D-1):** *„CEB und Tier-Binary bauen fuer die Messung den vom Planer DREIPHASIG eingestellten Mess-Apparat. NIE RATEN, IMMER LESEN."*
17. **Owner, Kollisionsregel (F5):** *„Bitte Variante b: Wir bauen geradeaus weiter."* — Substanz gewinnt, der Trigger darf rutschen.
18. **Owner, Vollstaendigkeit (06.08. frueh-9):** *„So machen wir die Reihenfolge, aber wir lassen dennoch nichts in der gesamten Kette aus, es aendert sich nur die Reihenfolge."*
19. **Lead-Doktrin, die sich viermal an einem Tag bewaehrt hat:** eine ABWESENHEIT ist keine Aussage (Nullbefund + Gegenprobe), ein BEFUND traegt sein Erhebungsdatum (REGEL-ZEILE 17), eine ENTLASTUNG ist eine Behauptung (von drei geprueften Entlastungen war **keine einzige** unveraendert haltbar), und eine WACHE ist erst geprueft, wenn sie jeden Entstehungspfad des geschuetzten Werts deckt.
20. **Und der teuerste Einzelbefund des Segments in einem Satz:** der Auslieferungspfad selbst war defekt — `best_binary_selector` versandte eine strikt dominierte Binary, bewiesen am echten CLI, nicht am Papier.
