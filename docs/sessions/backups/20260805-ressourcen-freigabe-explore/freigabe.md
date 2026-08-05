# LENS ressourcen-freigabe — Erhebung der umfassenden Ressourcen-Freigabe-Planung (READ-ONLY)

Datum: 2026-08-05 · Auftrag: OWNER-KERN F6 ("Der Planer taktet zukuenftig selbst ... Das ist umfassend geplant, wo ressourcen freigegeben werden (Explore).")
Quellen: super-Ledger `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (LEDGER:n = Zeile) + Memory-Korpus `/home/comdare/.claude/projects/-home-comdare/memory/`.

---

## 0. OWNER-KERN F6 (Anlass, verbatim)

LEDGER:4062 (NACHTRAG 05.08. mittag-6, OWNER-NACHRICHT VERBATIM):
> "Frage 6: Der Planer taktet zukuenftig selbst, er baut und ruft seine CEBs und diese bauen und rufen die Hybriden (mit anhaengigen Tier-Binaries) oder die Tier-Binaries selbst. Das ist umfassend geplant, wo ressourcen freigegeben werden (Explore)."

LEDGER:4063 (bindender Entscheid R6):
> "**R6/§38.b-ZIELBILD-KERN: DER PLANER TAKTET ZUKUENFTIG SELBST** — er baut und ruft seine CEBs, diese bauen und rufen die Hybriden (mit anhaengigen Tier-Binaries) oder die Tier-Binaries selbst; die RESSOURCEN-FREIGABE-Planung existiert umfassend im Korpus -> EXPLORE-Pflicht (Welle gestartet; **resource_group bleibt Ist-Traeger bis zur Planer-Takt-Umsetzung**)."

Memory-Spiegel: `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md:27` (NACHTRAG 05.08., F6-ZIELBILD-KERN verbatim + Lesart: "Die rekursive RUF-Kette (nicht nur Bau-Kette) ist Zielbild: Planer taktet die CEB-Sequenz SELBST (resource_group nur Ist-Traeger bis dahin); Ressourcen-Freigabe-Planung liegt im Korpus (Systemachsen-Freigabe/Pool/Locking) und ist vor W1-Design per Explore zu erheben.").

---

## 1. Achsen-Ebene: System-Achsen GEBEN FREI, Organ-Achsen SETZEN DURCH

Quelle KOMPLETT: `memory/feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen.md` (User-Ruling 2026-07-18; 16 Tage alt, Prinzip unverändert kanonisch):

**Vertrag Freigabe -> Durchsetzung (verbatim):**
- "**System-Achsen = 'Freigabe der Existenz zu testender Hardware-Eigenschaften'**: geben Ressourcen/HW-Features frei (extension_hardware/simd gibt AVX2/AVX512 frei; compiler gibt opt_level/-march/-mcx16 frei; hardware_isa gibt die Ziel-ISA frei, inkl. Cross-Compile x86->ARM64)."
- "**Organ-Achsen = 'Durchsetzung verfuegbarer Hardware NACH der Freigabe der System-Achsen'**: ein Organ-Algorithmus darf ein HW-Feature nur nutzen/durchsetzen, wenn die System-Achse es freigegeben hat (**Organ-Nutzung <= System-Freigabe**)."
- Verortung: KEINE opt/OptO-Haupt-Achse; malloc = Allokator-ORGAN-Achse; Compile-Flags (-march/-mcx16/SNMALLOC_*) = Compiler-System-Achse ("snmalloc braucht -mcx16 -> die Compiler-System-Achse gibt es frei (Freigabe-Prinzip in Aktion)").
- Dach: Mess- + System- + Organ-Achse unter EINEM `topics::Axis`.

**§37-Generalisierung (Memory, deckungsgleich LEDGER:2340-2352, verbatim-treu):**
- "Die Kopplung gilt fuer ALLE System-Achsen gegen die Organ-Achsen. SIMD ist hier ein **Pilot** fuer das Prinzip, weil eine Maschine ja nur ISA/OS/Hardware testen kann, die sie auch wirklich besitzt." (LEDGER:2343)
- "**Die Freigabe betrifft NUR statische System-HAUPT-Achsen** — NICHT die dynamischen System-UNTER-Achsen, die (wie etwa **Threads**) als **Runtime-Variable an die Tier-Binaries als Direkt-Einstellung fuer eine Messung durchgereicht** werden." (LEDGER:2346) — [V7.2-Warnvermerk LEDGER:2349: Dual-Natur-Register, mehrere Achsen zweigeteilt RT-Unter@Vorstufe + CT-Haupt@Folgestufe; NUMA/locking+page_type, compiler-Gruppe, Mess-Tooling/load_framework, SIMD/AVX.]
- Kuenftige Haupt-Freigaben: NUMA, NPU/GPU/FPGA — "Eine Tier-Binary kann jene Optimierungen nur mit einkompiliert haben und getestet werden, wenn die Maschine ueber die Hardware verfuegt." (LEDGER:2347)
- **Mechanik:** "einige System-Achsen sind ... mit einer System-Achsen-Aufnahme UND Organ-Achsen-Aufnahme ausgestattet (**Dual-Aufnahme**), um **von der CEB ueber ein STATE PATTERN durch das Pruef-Dock** von der System-Achse ausgehend **in der Organ-Achsen-Repraesentation dieser Freigabe-System-Organ-Achse freigeschaltet** zu werden." (LEDGER:2350) Ist-Vorbilder: simd_extension 09b, isa-Organ-Codegen-Traeger, general_hardware (LEDGER:2352).

**§37.b Bau-Delegation (LEDGER:2354-2358, User verbatim):**
> "die CEB bestimmt zur Laufzeit aus ihren System-Achsen-Freigaben, was gebaut werden darf, und delegiert eine Kompilation der Organ-Achsen eines Tier-Binaries mit der Konfiguration, die aufgrund der Freigabe der System-Achsen als Organ-Achsen-Rekombination gewaehlt/permutiert wurde."

Einordnung LEDGER:2358: Der Zulaessigkeits-Filter (Organ <= System-Freigabe) sitzt an der **CEB-Bau-Delegations-Naht** (`BuildOrchestrator::provision_all`/CompileFn) — **nicht im Tier, nicht im Planer**.

**Verwandte Links ([[...]] gefolgt):**
- `feedback_q2_option_c_erweiterungshardware_sechste_systemachse.md`: Q2-Ruling (User 17.07. verbatim): "Die CEB bekommt die Einstellungen vom Experiment-Planer, aber Permutiert etwa simd_extension selbst fuer die Systemachse zu seiner Laufzeit durch, um Tier-Binaries zur compile time mit diesen Eigenschaften auszustatten und durchzumessen." Flags an der CompileFn-Naht, Provenienz im Sidecar, NIE binary_id. [V7.2-Hinweis: die "6 System-Achsen" sind inzwischen auf GENAU DREI Glieder konsolidiert — LEDGER:90: `target_isa`/`operating_system`/`external_utils`; `external_utils` = HUB der Meta-Metas, gibt SIMD/AVX frei (LEDGER:92).]
- `feedback_gattung_own_genus_own_abi_nonintersecting_mutually_usable.md`, `feedback_system_axes_measurement_own_abstract_root_blood.md`: Achsen-Taxonomie-Kontext (Organ/Gattung bzw. Mess-Wurzel), keine eigene Ressourcen-Mechanik.
- `feedback_kette_planer_mess_ceb_system_tier_organ_hybrid.md:19`: "**Freigabe-Kopplung:** System-Achsen-Freigabe (CEB) erlaubt erst die Kompilation der SIMD-ORGAN-Achsen — Organ->Tier-Umsetzung liegt auf der Organ-Schicht als **gekoppelte Achse** (**G7-constexpr-Gate wird Bau-Gate**)."

---

## 2. Cluster-/CI-Ebene: Pool, Locking, Tag-Routing (§35/§36)

**§35 (LEDGER:2316-2324, User verbatim-treu):** System-Achsen-Permutationen "je nur EINMAL gebaut ... egal wo"; parallel:matrix ueber opt x simd, **Runner-Tags nach SIMD-Faehigkeit** (avx512-Zellen NUR auf avx512-Runnern); Ein-Build-pro-Permutation via MinIO-Dedup (`cache-engine-tier-binaries`, skip+pull bei Hit — "Der MinIO-Cache IST der Sync-Punkt zwischen den Runnern"); Invalidierer = `algo_sig`/`dll_is_current` (Neubau NUR bei nachweislicher Aenderung).

**§36 Pool-Modell (LEDGER:2326-2338, User verbatim-treu):**
1. "Jede Node baut bevorzugt ihre maximal verfuegbaren System-Achsen-Eigenschaften ... aus dem Pool — **unter LOCKING, sodass eine System-Achsen-Permutation nur genau auf EINEM Runner und EINER Concurrency gleichzeitig gebaut werden kann**."
2. "Ein Experiment-Planer kann MULTIPLE CEBs bauen."
3. N amd64-Nodes: kleine Nodes (Odroid H4) bauen nur, "deren Erweiterungen sie anbieten" (no_extension ueberall; avx2/avx512 nur wo Hardware).
4. "**die SIMD-/System-Achsen-FREIGABE sitzt in der CEB**, und die Umsetzung von Organ-Achsen zu Tier-Binaries ... liegt auf der Organ-Achsen-Schicht als GEKOPPELTE Achse (... **Audit-G7-constexpr-Gate wird damit Bau-relevant**)."
- Umsetzung: **Locking = GitLab `resource_group` je System-Permutations-Zelle** (`gn-<opt>-<simd>-<chunk>`) = "genau EIN laufender Job je resource_group ueber alle Pipelines/Runner"; MinIO-Dedup als 2. Schicht; **Tag-Routing 3-stufig** amd64/avx2/avx512; Emitter-Kopplung W4-B: "SIMD-Organ-Varianten nur in Zellen bauen, deren System-simd-Freigabe sie erlaubt ... **G7-Gate wird Bau-Gate**" (LEDGER:2338).
- Maschinen-Freigabe-Ist: LEDGER:93 — "avx512 nur wo die Maschine es freigibt (prod1_zen5 ja, prod2 fused-off -> Skip+WARNUNG, §62-A Planer misst alles Verfuegbare)"; Capability-Tags prod1 `+amd64,avx2,avx512`, prod2 `+amd64,avx2` (LEDGER:2388, §39).

---

## 3. Takt-Hoheit des Planers: Sequenzierung, Fertig-Signal (§38/§38.b)

**§38 (LEDGER:2360-2369):** Planer haelt die Voll-Konfiguration des Experiment-B+-Baums; "die zusammenhaengenden unteren Teilbaeume der System-Achsen mit nachfolgenden freigegebenen und regulaeren Organ-Achsen werden per SERIALISIERUNG vom Experiment-Planer an die CEB uebergeben" (Achsen-RANGES). **RUECK-KANAL CEB->Planer** = sparser Fortschritts-/Cursor-Kanal (nur Achsen-Deltas der lazy Materialisierung; KEIN Mess-Daten-Rueckfluss).

**§38.b (LEDGER:2371-2378, User verbatim):**
> "Es kann nur eine CEB gleichzeitig laufen — daher ist sonst je CEB bei multiplen Messsystem-Ansaetzen des Experiment-Planers ohne Feedback eine Abschaetzung nicht moeglich, ob eine Messung wirklich in der Gesamt-Permutation allein laeuft (sonst Messfehler). **Multiple CEBs laufen sequentiell.**"

Einordnung (LEDGER:2376) — DAS Takt-Modell: "der §38-Fortschritts-Rueck-Kanal liefert dem Planer genau das **Fertig-Signal**, mit dem er die **naechste CEB erst nach Abschluss der vorigen** startet (**Sequenzierung ueber den Rueck-Kanal** — ohne ihn keine Allein-Lauf-Garantie)." Abgrenzung: der §35/§36-**BAU** bleibt parallel (er MISST nicht); Sequentialitaet gilt fuer messende CEB-Laeufe. CI-Ist-Traeger: globale resource_group `ceb-measurement-exclusive` (LEDGER:2378, seit W5-A aktiv, LEDGER:2389) — per **§61 REVIDIERT von GLOBAL auf PRO MASCHINE** (`ceb-measure-<host>`, LEDGER:3274/3297).

**Planer-Steuer-Kette (§62-B, LEDGER:3315):** "Die CEB PIPED die Shell-/Status-Ausgaben an den PLANER weiter — der Planer ruft die emittete CEB auf und STEUERT sie: **der Planer wird aufgerufen, die CEB per XML-ANWEISUNG zu INSTRUMENTIEREN**" (Batch CEB-intern; erst Build+Pruef-Batch am GTest-Pruefstand des Pruefdocks, DANN Messung; Paket #54 — per R4 (05.08.) Endform = dedizierte XML-Anweisungs-Datei). §40 (LEDGER:2395): Steuerung "liegt nicht im Planer oder darauffolgend in der CEB. Das muss sich bitte aendern" — Planer erkennt CEB-Eigenschaften aus XML, kompiliert sie dynamisch, setzt "als automatische Aktion den Rest der CI".

**Replay-Vorrang (§58-C, LEDGER:3121):** Fordert der Planer eine Messung an, sucht er ZUERST per voll-permutativem CSV-Stempel -> REPLAY; sonst stoesst ER den Gesamtvorgang an (CEB bauen -> Tier bauen -> messen -> CSV). Der Planer ist also auch Cache-Takt-Herr.

---

## 4. Thread-/Maschinen-Budgets (§61 + amd24-Korrektur)

**§61 (LEDGER:3262-3300):**
- **Debug-Parallelitaet:** User gibt "MAXIMALE Parallelitaet ALLER CPU-Threads frei (**prod1: 32 Threads/24 Kerne**; generell nproc)" (LEDGER:3267). ECHTE Messung = Release + sequentiell/**1-Thread**.
- **Multi-Maschinen-Parallel-PFLICHT** (LEDGER:3269): prod1 AMD/Zen5 + prod2 Intel/RaptorLake MUESSEN parallel durchmessen; global-sequentiell "untersagt"; `resource_group` je MASCHINE (`ceb-measure-<host>`); Lane-Konsistenz (eine Mess-Lane vollstaendig auf EINER Maschine).
- **Modi** (LEDGER:3277-3279): Debug = je Maschine parallel bauen + parallel messen; Messung = parallel BAUEN + sequentiell messen; Release = auf der System-Achsen-korrekten Maschine, Auslieferung ohne Mess-Overhead + Wallclock-Beweis. Stufen Debug->Messung->Release sind CI-PFLICHT; Compile-Einstellungs-Stempel = Reuse-Schluessel (LEDGER:3283-3287).
- Aelterer CI-BAU-Deckel bleibt: CMAKE_BUILD_PARALLEL_LEVEL=6 fuer die CI-Kompilation ("von §61 NICHT aufgehoben", LEDGER:3273).

**§62-B Praezisierung-4 (LEDGER:3332), Thread-Budget fuer Batch-Compile (User 22.07.):**
> "**prod1 = 32 Threads / 24 Kerne; prod2 = 24 Threads / 16 Kerne.** ALLE Threads duerfen (und sollten) NUR JE EINZELNEN Batch-Compile VOLL ausgeschoepft werden — maximale Kerne voraus fuer den CEB-Batch-Compile (Tier-Binaries) UND den Planer-CEB-Compile." [Konsolidierungs-Anm.: ein Batch nutzt die Maschine exklusiv-voll; prod2-Zahlen = fuer Batch-Compile VERFUEGBARE Kapazitaet, nicht Rohspezifikation.]

**amd24-KORREKTUR (T-WERT-KORREKTUR, User 23.07. mittags — ueberstimmt die 32T-Lesart fuer amd):** `memory/project_62_planer_universal_cache_log_claim_compare.md:51`:
> "'AMD worker bitte auf 24 Threads drosseln' — nach Slice-1-Empirie (amd@32W 19,95min == amd@24W 19,4min, aber 20G Swap + OOM-Kills paralleler CI-Jobs auf 60G-RAM-Maschine). Neu: **lane_build_parallelism amd=24, intel=24**."
(Ledger-Echo: §66 LAGER-GATE "G1 B/C/D+amd24 landen (#27)", LEDGER:3472.)

---

## 5. Batch-Claims, Lease/Takeover, ETA, Gleichverteilung (§62-B — die Bestandslog-Ressourcen-Vergabe)

**§62-A Planer-Universalitaet (LEDGER:3306):** Planer ist ANSPRUCHSLOS, laeuft auf JEDER Maschine, "misst alles Verfuegbare, was die XML verlangt"; physisch fehlende Achsen -> WARNUNG statt Vorfilter; Host-Lanes = INTERIM, als Zielarchitektur SUPERSEDIERT.

**§62-B Cache-Log = lockbare SYNC-DATEI auf minio.comdare.de (#46/#46b), LEDGER:3308-3337:**
- **3-Stufen-Dedup:** gebaute Planer/CEB/Tier NIE erneut bauen.
- **Batch-Reservierung = VERSPRECHEN** (LEDGER:3310): Maschine reserviert Batches ueber LAZY Permutations-Auflistung ("wer zuerst zugreift, bestimmt den ersten Batch"); bei Programm-Ende ZWINGEND Promise-Release + Fortschritts-Testat je Build.
- **SYMMETRIE + GLEICHVERTEILUNGS-PFLICHT** (LEDGER:3313/3319): XML fuer BEIDE Maschinen GLEICH, keine Zustaendigkeits-Aufteilung per Konfiguration; "Binaries, die BEIDE Maschinen verarbeiten koennen, werden **GLEICHVERTEILT** auf beiden Maschinen kompiliert. Sonst blockt die eine Maschine den Fortschritt komplett." Koordination AUSSCHLIESSLICH ueber den live Cache-Sync.
- **Batch-Groesse:** STETS **4096** Binaries, Reservierung MIT ZEITSTEMPEL (== GN-2-Guard kMaxMaterializableCatalogCardinality) (LEDGER:3320).
- **ETA-Mechanik (korrigiert 22.07.)** (LEDGER:3321): Mini-Batch der Groesse max-CPU-Threads liefert die Basis; **ETA = Sigma t_i / N_threads**, Untergrenze ETA >= max(t_i); Kalibrierung: ZUERST **30 Minuten pro forma** reserviert, bis das echte ETA die Reservierung ersetzt. ETA-Berechnung je Batch-Block wiederholt (LEDGER:3330).
- **Takeover-Regel (ersetzt Lease-Design-Note)** (LEDGER:3322): "wird das ETA um **50% OHNE UPDATE** ueberschritten, duerfen andere Maschinen davon ausgehen, dass die Pipeline der Maschine GESTORBEN ist, und nehmen stattdessen die Arbeit auf, die noch offen und nicht im Log als Bestand verzeichnet ist."
- **Planer-Block** (LEDGER:3323): "ein Planer blockt einen Compile einer CEB DIREKT im Log ohne ETA mit einer Reservierung von **30 Minuten** fuer diese Version."
- **Done-Semantik** (LEDGER:3324): Reservierungen+ETAs nach Batch-Ende AUFGEHOBEN + "Done".
- **SCHREIB-LOCK-SEMANTIK** (LEDGER:3327): Bestandslog beim SCHREIBVORGANG gelockt; Schreib-Lock endet SPAETESTENS mit der ersten pro-forma-30-min-Reservierung. LOCK (kurze Schreib-Exklusivitaet) != RESERVIERUNG (fachlicher Batch-Besitz mit Zeitstempel/ETA/Takeover) — "Eine tote Maschine kann das Dokument also nie dauerhaft sperren."
- **MULTI-WRITE-Freigabe** (LEDGER:3329): sobald kompiliert wird, ist das Log multi-write (Registrierung = Millisekunden); Haupt-Blocker = ETA-Berechnung.
- **Batch-Typen-Sequenz** (LEDGER:3331): CEB-Compile- und Tier-Batches auf derselben Maschine NIE gemischt, sequentiell.
- **Batch-JOB-Prinzip** (LEDGER:3314): Job-Anzahl O(Maschinen)/O(konstant), NIE O(Binaries) — die Masse laeuft IN der CEB; EIN Build+Pruef-Batch-Job + EIN Mess-Batch-Job je Maschine (Emissions-Umbau LEDGER:3316).
- **Zwei Bestaende als Factory Pattern** (LEDGER:3334): Binaries + Messwerte je EIGENES Bestandslog; SHA512-constexpr-Fingerprint-Stempel als Lookup-Key (LEDGER:3335-3336). Reservierungen decken "compile+pruef der CEB UND den Compile der CEB durch den Planer" als STRATEGY PATTERN (LEDGER:3325). Neu-Inventarisierung bei Log-Loeschung oder neuer Planer-/CEB-Version (LEDGER:3326).
- **§62-C:** Modi je Maschine + 4. Modus COMPARE nach Release; CI erst fertig, wenn XML auf ALLEN gewuenschten Maschinen JE Maschine ausgewertet (LEDGER:3339).
- **§62-D:** Replay-Befugnis schichtweise — CEB-Binary <- Mess-Achse [a,b,c] (Sicht: Planer) · Tier-Binary <- System [d,e,f] ALLEIN · Messwerte <- [d,e,f]+[g,h,i]+Hardware-Identitaet; Binary-Sharing stempel-gekeyt zwischen ALLEN passenden Maschinen (LEDGER:3341-3351).
- **RAM-Sammelpuffer** (§62-B-NACHTRAG-2, Memory NACHTRAG-13): 256-MB-RAM-Puffer + Writer-Thread (io_uring/IoRing/write-Thread, 3 CT-Backends); Batch-Slice-QUEUE Producer-Consumer (NACHTRAG-14).

**Autonomie-Freigaben der Ressourcen-Ebene:** §39 (LEDGER:2382-2389): "Das Cluster ist **nur fuer dich reserviert** und du hast die **Freigabe, Infrastruktur autonom einzurichten** mit den Schluesseln aus dem Cred-Vault"; Mess-Exklusivitaet bleibt trotzdem PFLICHT ("Messfehler-Vermeidung, nicht Ressourcen-Hoeflichkeit"). §63 (LEDGER:3366): VOLL-FREIGABE aller §62-Pakete (#45-#51) autonom, auch nachts.

---

## 6. Antwort auf die KERNFRAGEN

**WER gibt WANN WELCHE Ressource frei?**
| Ressource | Freigeber | Wann/Mechanik |
|---|---|---|
| HW-Feature (SIMD/ISA/OS/NUMA/NPU-GPU-FPGA) | **statische System-HAUPT-Achse** (in der CEB einkompiliert; `external_utils`-Hub fuer SIMD/AVX) | zur CEB-LAUFZEIT vor der Bau-Delegation; Organ <= Freigabe; State-Pattern-Freischaltung durchs Pruef-Dock (§37/§37.b); G7-constexpr-Gate = Bau-Gate |
| Threads (u.a. dyn. Unter-Achsen) | System-UNTER-Achse, KEINE Freigabe-Instanz | als Runtime-Variable an die Tier-Binary durchgereicht (§37.4) |
| Maschine/Runner fuer eine Bau-Zelle | GitLab **resource_group** `gn-<opt>-<simd>-<chunk>` + Tag-Routing amd64/avx2/avx512 | pro System-Perm-Zelle genau EIN Job cluster-weit; MinIO-Dedup als 2. Schicht (§35/§36) — Ist-Traeger bis Planer-Takt (R6) |
| Mess-Exklusivitaet | resource_group **`ceb-measure-<host>`** (per §61 PRO Maschine, revidiert global §38.b) | genau EINE messende CEB je Maschine; Bau bleibt parallel |
| Batch (4096 Binaries) | **Bestandslog-Reservierung** (Claim der Maschine/CEB, First-Access) | Zeitstempel + 30-min-pro-forma -> echtes ETA; Release bei Programm-Ende; Takeover bei ETA+50% ohne Update; "Done" nach Abschluss |
| Bestandslog-Schreibzugriff | **Schreib-LOCK** am Dokument | nur Millisekunden bzw. bis erste 30-min-Reservierung; danach Multi-Write; ETA-Rechnung = einziger langer Lock |
| CEB-Compile durch den Planer | **Planer-Block** im Log | ohne ETA, 30-min-Reservierung je Version |
| Thread-Budget je Batch-Compile | User-Vorgabe §62-B-P4 | prod1=32T/24K, prod2=24T/16K; VOLL nur je einzelnem Batch; **amd24-Korrektur 23.07.: lane_build_parallelism amd=24, intel=24** |
| Cluster/Infra gesamt | User (§39/§63) | Cluster fuer den Agenten reserviert, Infra autonom, Vault-Schluessel; Mess-Exklusivitaet bleibt Pflicht |

**Takt-Hoheit des Planers (Zielbild R6):** Der Planer baut und RUFT seine CEBs selbst (rekursive Ruf-Kette Planer -> CEB -> Hybrid/Tier); Sequenzierung der (messenden, sequentiellen §38.b-) CEBs ueber das **Fertig-Signal des sparsen §38-Fortschritts-Rueck-Kanals**; Steuerung per **XML-Anweisung/Instrumentierung** (#54, Endform dedizierte XML-Anweisungs-Datei per R4); Replay-Vorrang §58-C (suchen -> Replay oder Materialisierungs-Anstoss); Claims/ETA/Takeover des §62-B-Bestandslogs = die Multi-Maschinen-Absprache, die der Planer-Takt konsumiert. **Bis zur Umsetzung bleibt `resource_group` der Ist-Traeger** (R6 verbatim).
