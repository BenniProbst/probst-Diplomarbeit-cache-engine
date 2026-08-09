# EXPLORE-ERGEBNIS 09.08.2026 — Lagerhaltung, Hardware-Job-Pool, AVX-Maximalkompilierung

> **Anlass:** Owner-Auftrag vom 09.08.2026, wörtlich: *„bitte explore zur Lagerhaltung und wie ein
> Maschine zum Maximum ihrer technischen Möglichkeiten AVX binaries kompiliert"* — gestellt
> unmittelbar nachdem der Owner eine Fehldeutung des Leads richtiggestellt hatte.
>
> **Verfahren:** Strang 11, fünf **blind voreinander** laufende Suchmodalitäten (Lager-Vokabular ·
> Maschinen-Vokabular · SIMD-Vokabular · Chronologie rückwärts · Memory-Korpus), Sonnet 5 max
> effort „very thorough", über **213 Sessions · 126 Pläne · 248 Memories** ab 07.06.2026, danach
> Synthese mit Fable 5 max effort. **111 Funde**, davon 20 wörtliche Owner-Worte, **15
> Widersprüche**. Jeder Nichtfund mit Gegenprobe belegt.
>
> **Rohdaten:** Workflow `w019hmcge`, Journal unter
> `.claude/projects/-home-comdare/5a19728e-*/subagents/workflows/wf_4655b248-8b0/journal.jsonl`

---

## DAS ERGEBNIS IN DREI SÄTZEN

**Erstens: der Owner hatte recht, und zwar vollständig.** Der Begriff „Hardware-Job-Pool" ist neu
vom 09.08. — *das Konzept ist seit dem 19.–22.07. vollständig festgelegt und seit dem 25.06.
angelegt.* Es heißt dort **§62 MULTI-MASCHINEN-ARCHITEKTUR** und trägt das **SYMMETRIE-PRINZIP**:
*„prod1 baut ALLES, was es kann, und prod2 baut ALLES, was es kann — beide Maschinen führen aus,
was sie können, und MESSEN es durch. Die XML ist für BEIDE Maschinen GLEICH."*

**Zweitens: die Frage nach dem AVX-Maximum ist beantwortet, aber anders als vermutet.**
`-march=native` ist **ausdrücklich verworfen** („host-abhängig, nicht golden-portabel", 17.07.).
Das Maximum entsteht nicht durch Host-Erkennung, sondern dadurch, dass eine Maschine **alle
Achsen-Zellen baut, die ihre Hardware freigibt** — prod1 alle drei SIMD-Stufen, prod2 nur
`no_extension`+`avx2`. Was sie nicht kann, fällt **nicht durch einen CI-Vorfilter** weg, sondern
maschinenseitig mit **Warnung samt `machine_id` und Fehlerklasse `HardwareErweiterungFehlt`** —
und das Experiment misst weiter.

**Drittens: meine Sorge um den SKIP ist auf Plan-Ebene unbegründet — auf Objekt-Ebene offen.**
Der Entwurf trennt AVX-512- von AVX2-Binaries sehr wohl, nur nicht über die `binary_id` (die trägt
SIMD **nie**), sondern über `build_version` + `+ext=`-Sidecar + den **SHA512-Fingerprint über die
Stempel-Zeilen**. Ob der **IST-Code** das beim SKIP tatsächlich auswertet, ist die offene Frage —
das 08.08.-Audit fand Storage-Tree-Writer und realen SKIP-Arbiter **unverbunden** und
`COMDARE_BESTANDSLOG` **ungesetzt**.

---

## WAS DAS FÜR MEINE ARBEIT BEDEUTET

Der 08.08.-Befund („44 von 48 Jobs floaten") war **korrekt gemessen**. Die Deutung war falsch, und
zwar zweifach: das Floaten ist der Entwurf (Owner 21.07.: keine Zuständigkeits-Aufteilung per
Konfiguration; GitLab-Tags sind als Steuerung **supersediert**), und die Koordination läuft über
das **gelockte Bestandslog auf minio** — mit Batch-Reservierung à 4096 Binaries samt Zeitstempel,
Gleichverteilungs-Pflicht für die gemeinsame Menge, First-come für den ersten Zugriff und
**Takeover bei ETA+50 % ohne Update**.

Der Explore belegt damit die Owner-Doktrin *„ALLES IST GEPLANT"* an einem konkreten Fall: die
Antwort lag **19 Tage** vor meiner Frage im Ledger, in einem Abschnitt, der genau danach benannt
ist. Die Suche hätte vor der Deutung stehen müssen, nicht danach.

---

Alle tragenden Zitate sind am Objekt verifiziert (Anmerkung vorab: das Ledger wird in-place editiert, Zeilennummern wandern — ich gebe die heute gueltigen Zeilennummern an, wo ich selbst nachgelesen habe). Hier die Synthese.

---

# SYNTHESE — Lagerhaltung · Hardware-Job-Pool · AVX-Maximalkompilierung: was in neun Wochen GEPLANT wurde

Kennzeichnung: **[OWNER]** = woertliches oder verbatim-treu protokolliertes Owner-Wort (bindet). [Doku] = Lead-/Agenten-Notiz, Konsolidierung oder IST-Befund (bindet schwaecher).

---

## (1) DIE ZEITACHSE

**25.06.2026 — Gruendung des Themas.** [OWNER] A2: jede Kombination ISA+OS zusaetzlich × bare-metal/docker/k8s (3D-Bau-Matrix); A9: „die Messung wird immer maximal genau, so genau wie die ISA+OS+Umgebung es anbietet" (`sessions/20260625-USER-ANTWORTEN-13-ENTSCHEIDUNGEN-CICD-MESS-ARCHITEKTUR.md:31-32,57-60`). [Doku] prod1 (id 16, Ryzen 9 9950X3D) / prod2 (id 17, i9-14900KS) erstmals dokumentiert (`sessions/20260625-CICD-PIPELINE-ARCHITEKTUR...md:108`). Aeltestes Dokument im Korpus — vor dem 25.06. existiert keine Datei (Chronologie-Modalitaet, verifiziert ueber 352 Dateien).

**03.07.** [OWNER] Rollentrennung: „x86 ohne Optimierungen → Odroid H4; x86 mit Optimierungen → große prod-Runner, AMD und Intel SEPARAT für alle HW-Erweiterungen" (`memory/feedback_build_matrix_8_docker_distros_full_platform_doctrine.md:3,15`).

**06.07.** [OWNER-Auftrag] #276 Voll-Plattform-Matrix; vier Odroid-H4-Ultra (pve1/pve2/node3/node4, ids 6-9) inventarisiert (`sessions/20260706-276-VOLL-PLATTFORM-MATRIX.md:1,9`).

**10.07.** [Doku] SIMD-Dispatch Phase 0.1: Pfadwahl strikt compile-time (`#if __AVX512F__/__AVX2__`), kein Runtime-Switch im Hot-Path; Tests immer kompiliert, ausgefuehrt nur bei Host-Support → kein SIGILL (`plaene/20260710-phase01-simd-dispatch-DOSSIER.md:1-11,47-49`). Achse→`-march`-Flag-Kopplung noch offen.

**17.07. — der dichteste Tag (vier Runden, selber Tag):**
- [OWNER] **H-7**: „eine Tier-Binary wird durch eine CEB-System-Achse STATISCH für system-passende Optimierungen kompiliert (AVX512 + andere Befehlssatzerweiterungen nicht überall vorhanden → speziell passend für optimale Systemausnutzung einkompiliert ODER zum Performance-Vergleich NICHT mit einkompiliert → volle Kontrolle)" (Ledger:1064, selbst verifiziert). **Das ist die „Maximum"-Direktive.**
- [OWNER] **Q2 Option C** (verbatim): CEB „Permutiert etwa simd_extension selbst für die Systemachse zu seiner Laufzeit durch, um Tier-Binaries zur compile time mit diesen Eigenschaften auszustatten … Daher sind die Systemachse der Erweiterungshardware (SIMD, GPU) eine weitere eigene Systemachse … GO für den Bau" → SECHSTE System-Achse; Wert=System-Achse, Ort=CompileFn-Naht, Provenienz=H-10-Sidecar, NIE binary_id (Ledger:2571, selbst verifiziert).
- [Doku, gebaut am selben Tag] INC-1g/H-10: `build_version`+Sidecar tragen `+ext=…+cxx=…` (literal: `m3v2+ext=no_extension+cxx=g++-16`) (Ledger:2572).
- [OWNER] **OF-1** (spaetere Runde desselben Tages, verbatim): „Extension Hardware ist im Falle von CPU Erweiterungen ab sofort eine compiler-Unterachse und im Falle von GPU und externen Beschleunigern eine eigene Hauptachse bzw. ein System-Hauptachsen-array dynamischer Größe" (Ledger:2579, selbst verifiziert) — **widerspricht Q2-C am selben Tag**; der Lead flaggte das als „echt entscheidungsbedürftig … keine stille Migration" (`plaene/20260717-inc2copt-planung-BAUPLAN-INC2C-OPT-KORRIGIERT-COMPILER-UNTERACHSEN.md:60`).
- [OWNER] Fehlerklassen-Pflicht nach realem CI-Riss (COMDARE_HOST_RUNS_AVX512F leer → CMake-Arity-Crash): fehlendes AVX512 = klassifizierter Fehler im Log, kein Absturz (`memory/feedback_fehlerklassen_pflicht_alle_achsen_unterachsen_algorithmen.md:10-19`). [OWNER] „die gesamte pipeline IMMER hart grün" (`memory/feedback_gesamte_pipeline_immer_hart_gruen.md:10`). [Doku] `-march=native` als „host-abhängig, nicht golden-portabel" eingeordnet — bewusst NICHT der Weg (`…inc2copt…:24`; `plaene/20260717-inc1-bauplan-ADDENDUM…:132,144`).

**18.07.** [OWNER] INC-2d: target_isa als eigene System-Achse herausgeloest (Cross-Compile zulaessig) (`plaene/20260718-inc-2d-vor-deep-research-BAUPLAN-INC-2D-ISA-SYSTEM-ACHSE.md:12-14`). [Doku] Freigabe-Doktrin: System-Achsen geben HW frei, Organ-Achsen setzen durch, SIMD=Pilot (`memory/feedback_systemachsen_freigabe_organachsen_durchsetzung_ressourcen.md:13,23`).

**19.07. — Pool-Geburt und Kehrtwende in einer Nacht:**
- [OWNER] **§35** (verbatim-treu, Rohtranskript `sessions/backups/20260726-session-plaintext-verlauf/verlauf-22.txt:404`): „Die Maximalkapazitäten einer Node enablen die parallele Pool-Mitarbeit und Cross-Runner-Sync über … System-Achsen-Permutationen, die je nur EINMAL gebaut werden sollen — egal wo" (Ledger:2865, selbst verifiziert).
- [OWNER] **§36** (verlauf-22.txt:439; Ledger:2876-2879, selbst verifiziert): „Jede Node baut bevorzugt ihre maximal verfügbaren System-Achsen-Eigenschaften … aus dem Pool auf — unter LOCKING (eine Permutation genau auf EINEM Runner gleichzeitig)"; „N Nodes … z.B. können die Odroid H4 nur Kompilation und System-Achsen mitbauen, deren Erweiterungen sie anbieten"; Freigabe-Kopplung System→Organ sitzt in der CEB.
- [Doku] §35.2: Ein-Build-pro-Permutation via minio-Cache, Key `<build_version>/<stem>`, skip+pull statt Neubau (Ledger:2869). §39: Capability-Tags real gesetzt — prod1 `+amd64,avx2,avx512`, prod2 `+amd64,avx2` (Ledger:2937). §40.a: je Maschine deklarierte Signatur EINZELNER SIMD-Flags statt Grob-Level (Ledger:2947). 23-Flag-Katalog live auf prod1 verifiziert; „einziger AVX-512-Träger im Cluster ist prod1" (`docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md:1-8,108-123`).
- [Doku] **Noch in derselben Nacht**: W10/§42 ersetzt die Steuerungsrolle der frisch entworfenen statischen 24-Zellen-Tag-Matrix durch die dynamische CE/Planer-Kette (`plaene/20260719-welle10-legenden-kette-CE-steuert-BAUPLAN.md:1-4`); am 20.07. formal DEPRECATED, nie geloescht (`plaene/20260720-verworfene-referenzen…:160-162`). Ebenfalls 20.07.: INC-1d hat die **Q2-C-Variante gebaut** (ExtensionHardwareSystemAxis, no_extension/avx2/avx512); OF-1-Faltung nur Absicht (env-pilotiert) (ebd.:112).

**21.07. — §62 entsteht (KONSOLIDIERTE FASSUNG, User):**
- [Doku/OWNER-konsolidiert] **§62-A PLANER-UNIVERSALITAET** „supersediert Runner-Tag-Vorfilterung als Zielbild": Planer anspruchslos, baut auf JEDER Maschine; physisch fehlende Achsen (z.B. AVX512-Flags) → „WARNUNGEN ins Log … kein Vorfilter, keine stille Auslassung"; Host-Lanes = INTERIM (Ledger:3855, selbst verifiziert).
- [OWNER] **§62-B SYMMETRIE-PRINZIP**: „prod1 baut ALLES, was es kann, und prod2 baut ALLES, was es kann … Die XML ist fuer BEIDE Maschinen GLEICH … Koordination (kein Doppelbau) laeuft AUSSCHLIESSLICH ueber den Cache-Sync: ‚Wir bauen darauf, dass der cache-sync LIVE sein muss'" (Ledger:3862, selbst verifiziert). Lockbare SYNC-DATEI auf minio; Batch-Reservierung = VERSPRECHEN, „wer zuerst zugreift, bestimmt den ersten Batch"; Builds UND Messung „ueber Dutzende Maschinen parallelisiert" (Ledger:3857-3860).
- [OWNER] **BATCH-JOB-PRINZIP**: niemals Einzel-Jobs je Binary; Job-Anzahl O(konstant)/O(Maschinen), NIE O(Binaries) (Ledger:3863).
- [Doku] §61: Mess-Betriebs-Pflichten — Host-Lanes amd/intel, „eine Mess-Lane bleibt vollstaendig auf EINER Maschine", resource_group je Maschine (Ledger:3818). §62-D: platform-Spalte `<lane>@hostname` je Mess-Job; **simd-Gate liegt VOR dem dll_is_current-Skip und darf vom Pull-Pfad nie umgangen werden** (`plaene/20260721-PLAN-46a-53-minimal-cache-ci-durchsatz-DOSSIER.md:103`).

**22.07. — §62-B-Praezisierungen [alle OWNER]:** Bestandsdokument versioniert+gelockt, im Kern XML (Ledger:3867). **Gleichverteilungs-Pflicht**: „Binaries, die BEIDE Maschinen verarbeiten koennen, werden GLEICHVERTEILT … Sonst blockt die eine Maschine den Fortschritt komplett" (Ledger:3868). **Batch stets 4096**, mit Zeitstempel reserviert (Ledger:3869). ETA = Σt_i/N_threads, Untergrenze max(t_i), vorher 30 min pro forma (Ledger:3870). **Takeover bei ETA+50% ohne Update** — nur die nicht als Bestand verzeichnete Arbeit wird uebernommen (Ledger:3871). **Schreib-Lock endet SPAETESTENS mit der ersten pro-forma-30-Minuten-Reservierung** — Lock (kurze Dokument-Exklusivitaet) und Reservierung (fachlicher Batch-Besitz) getrennt (Ledger:3876). Batch-Typen NIE gemischt, sequentiell; Thread-Budget prod1 32 Threads/24 Kerne, prod2 24/16, je Batch VOLL (Ledger:3880-3881). **PRAEZISIERUNG-2**: zwei Bestaende (Binaries/Messergebnisse) als Factory Pattern, je eigenes Log + Stempel-Strategie; **constexpr-SHA512-Fingerprint ueber die Stempel-Zeilen als neue Stempel-Zeile jeder Binary**; Lookup via SHA512-Key-map (Ledger:3882-3885, selbst verifiziert; Konsolidierungs-Anm.: „Mess-Bestand keyt voll-permutativ + Hardware-Identitaet"). [OWNER] IST-VERSTOSS benannt: Einzel-Jobs je Perm×Chunk → Auftrag „je Maschine EIN Build+Pruef-Batch-Job + EIN Mess-Batch-Job" (Ledger:3865). [OWNER] Abends praegt der Owner das Wort „Lagerhaltung" (Ledger:3955).

**23.07.** [Doku] Lager-Gate komplett gebaut: Bestandslog, Lock/Union-Merge, SHA512-Factory-Index, Lifecycle/ETA/Takeover, Batch-Planer/Slice-Queue, RAM-Spool 256MB (`sessions/20260723-SESSION-nachmittag-lager-gate-bau.md:16-18`).

**26.07. — Baum-Zielbild + Abnahmen [OWNER-KERN]:** ZWEI LAGER-BAEUME mit je eigener Wurzel und **unterschiedlicher Ebenen-Reihenfolge**: Messdaten-Baum Wurzel = Mess-Tooling×load_framework → System-Rekombination → Organ-Gruppen → … → xlsx; Binaries-Lager Wurzel = SYSTEM-Achse direkt, Mess-Typ als LETZTER/tiefster Typ (`sessions/20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md:54-63`, selbst verifiziert). ABNAHME-1: Lock-TTL ereignisgebunden, harte Obergrenze 30 min — „LockB-90s war Agenten-Wert", verworfen (`memory/project_bestandslog_abnahmen_baum_heuristik_stempel.md:13`). **TEST-SKIP-GESETZ** (Owner-Wortlaut zweifach bestaetigt): „Lager-Skip nur bei grünem Test-Log am Binary", sonst testet der Voll-Build IMMER hart (Ledger:4097). [OWNER] R-E/R-F: AVX/SIMD werden **Meta-Meta-Achsen unter dem external_utils-Hub** (`memory/project_20260726_chunk_delta_verlorene_owner_antworten.md:51`). [Doku] Voll-Bau = 4 opt × 3 simd = 12 System-Perms; avx512-Ausschluss auf prod2 MASCHINENSEITIG per Freigabe+WARNUNG (Fehlerklasse HardwareErweiterungFehlt), „misst weiter", NICHT als stiller Profil-Filter; **opt/simd binary_id="never" → Suffix/Sidecar, nicht Katalog** (`memory/project_achsen_neuordnung_bindende_sortierung_regressionen.md:88-94`).

**27.07.** [OWNER-KERN] „Hardware-Werte nie statisch; CEB liest zur Laufzeit" + Passungs-Stempel-Konzept (ISA×OS einkompiliert, Loader prueft, Statuscode 9 platform_mismatch) (`sessions/20260727-PLAN-hw-erkennung-zwei-ebenen-factory-stempel.md:1-10,79-89`). [Doku] Am selben Tag wurde real die prod2-CPU getauscht: i9-14900KS → i9-12900K (belegt in `plaene/20260807-ANALYSE-paper-permutationen-prod1-prod2.md:302-315`).

**01.08. [OWNER F5-F9]:** **F9** (juengste Aussage, bindend): „Der Voll-Bau-Trigger IST der Baum-Vollausbau — Lagerhaltung SAMT BAUM muss VOR dem Compile stehen" — VERDRAENGT ausdruecklich die 26.07.-Aussage „Voll-Bau-4 wartet NICHT auf den Baum-Vollausbau" (`sessions/20260801-KONSOLIDIERT-gesamtarchitektur-lager-batch-eta-sha512.md:4-5`, selbst verifiziert). **F6**: 4096er-Batches = JOB-MEILENSTEINE, am Stueck von JE EINER Maschine, nie geteilt/unterbrochen (ebd.:30). **F7**: SKIP ausschliesslich auf SHA512-Fingerprint (ebd., „F7-Konvergenz" spaeter im Writer). P5 Passungs-Stempel ruht bewusst bis nach Voll-Build+Messlauf (`sessions/20260727-PLAN…:279-284`).

**02.08.** [OWNER] Entscheid 3: Maschinen-/OS-Diversitaets-Paket PFLICHT — „Grundlage der Wiederverwendbarkeit und **Zuordbarkeit der Binaries** … das System funktioniert sonst nicht" (`sessions/20260802-OWNER-entscheide-hybrid-tier-stempel-regression-os-unterachsen.md:11`).

**05.08.** [OWNER] Batch-Plan-Persistenz: „sofern die Binary Reihenfolge und der Faecher fuer das Batch klar und persistiert geplant sind. Freigabe." — Resume ueber Zaehler (`plaene/20260806-PLAN-host-belegung-batch-plan-ablage.md:17-22`). [Doku] Zulaessigkeits-Filter sitzt an der CEB-Bau-Delegations-Naht (provision_all/CompileFn) (Ledger:4623).

**06.08.** [OWNER] **Fingerprint-Doktrin**: „die gleiche binary auf der selben Maschine mit den selben Messachsen liefert identische Ergebnisse … Daher: Mess-Achsen + System-Achsen + Organ-Achsen identisch → fingerprint fuer identische binary fuer identische Messdaten" (`memory/project_owner_kerne_20260806_abend_frist_messkette_ceb.md:45`). [OWNER] Lager-Basis-Tests: Dummy-Textdokumente + leere Stub-Binaries (`memory/project_lager_basis_tests_dummy_strategien_stempel.md:15`). [Doku] IST-Befund: `batch_plan_datei` nirgends belegt → gebaute Ebene 1 im Trigger-Lauf wirkungslos (`plaene/20260806-PLAN-host-belegung…:6-11`).

**07.08.** [Doku] IST-Code: **drei** System-Achsen (target_isa, operating_system, **external_utils.simd** mit no_extension/avx2/avx512), external_utils.simd **binary_id-NEUTRAL** — multipliziert nur Bau-Matrix/Sidecar (`+opt=/+ext=`), nie die 2^17-Organ-Kartesik; prod1 13 AVX-512-Flags live, prod2 0 per static_assert; Namensdrift `Prod2RaptorLakeSignature` (`plaene/20260807-ANALYSE-paper-permutationen-prod1-prod2.md:279-343`).

**08.08. [OWNER-KERNe, mehrfach]:** „Die operation bei Validen Messdaten ist skip für die XLSX, sofern von der **exakt gleichen binary** gemessen wird. Jede neue Version … behält die alte Version zusätzlich. Und **CSV wird NIE verwendet**" (Ledger:12577-12580, selbst verifiziert). „Die Operation bei validen **Binaries** ist ebenfalls skip. Die binaries und Messdaten teilen sich denselben Lagerhaltungs-Baum … nur unterschiedliche factory pattern und detail pattern … beide verwenden **exakt denselben Baum**" (Ledger:12618-12620). NACHTRAG: „der **Strategy-Storage-Tree** ist im code derselbe … über **zwei verschiedene file system wurzeln** … Eine wurzel binaries, eine wurzel measurements" (Ledger:12666-12668). NACHTRAG 2: „konzeptionell synchron … in der Realität … erst **lazy** … erst gebaut und dann in einem **zweiten durchlauf** die Messungen" (Ledger:12691-12693). Der Ledger loest daran die Baum-Lesart auf: **die je Realm abweichende Ebenen-Reihenfolge (26.07.) ist die Detail-Pattern-Differenz, KEIN Defekt** (Ledger:12654-12681, selbst verifiziert; ein `LagerBaumWriter`, zwei CT-Policies). [Doku, selber Tag] 23-Agenten-Audit: Storage-Tree-Writer und realer SKIP-Arbiter im Code NICHT verbunden; `COMDARE_BESTANDSLOG` nirgends gesetzt (`plaene/20260808-WELLENPLAN-ANLAGE-luecken-defekte-einwaende.md:347-361`); prod2 per ping unbekannt, OV-5: Thesis-Methodik auf Ein-Maschinen-Betrieb (`plaene/20260808-GESAMTBILD…:367`; `…WELLENPLAN-ENDFASSUNG…` OV-5); [OWNER, referiert] AVX-512-Luecke auf prod2 „korrekt und gewollt" (`plaene/20260808-GESAMTBILD…:384`). Im WELLENPLAN entsteht die Fehldeutung „zweite Maschine = zweite Fehlerquelle".

**09.08. — Richtigstellung [OWNER, der Anlass dieses Auftrags]:** Befund 44/48 Jobs floaten, Pipeline 15412, Job real auf prod2/i9-12900K (Ledger:19-45). Owner woertlich: **„Ehm, das war so geplant, dass über das Lager die Maschinen abstimmen, wer welches Batch verarbeitet und es können auch erstmal alle Maschinen alle Jobs aufnehmen."** (Ledger:94-95, selbst verifiziert). Fehldeutung zurueckgezogen; „Die Folgerung ist aber nicht ‚Jobs pinnen', sondern: jede solche Wache muss ihren Nenner MIT der Maschine ausweisen" (Ledger:123). **Strang 8 bleibt offen**: „baut jede Maschine zum Maximum … und unterscheidet das Lager die beiden Ergebnisse? … Ob er zutrifft, ist offen und wird gerade am Objekt geprüft" (Ledger:126-131). [OWNER] Achtgliedrige Verarbeitungskette mit benanntem Kettenglied **„Hardware-Job-Pool ueber Maschinenfaehigkeiten (gleiche CI fuer alle Maschinen, custom Filterung der Compiles je Hardware-Freigabe)"** (`memory/project_verarbeitungskette_acht_stationen_hardware_job_pool.md:11-22`, selbst verifiziert; `plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:305` [Zeile heute, war :194]; `plaene/20260808-GOAL-V8-DOSSIER…:339,348,353`).

**Abloesungs-Kette in einem Satz:** Tag-Routing (19.07.) → supersediert durch Planer-Universalitaet/Lager-Koordination (21.07.) → praezisiert 22.07.-01.08. → am 09.08. vom Owner unter dem neuen Namen „Hardware-Job-Pool" bestaetigt, nicht neu erfunden.

---

## (2) DER ENTWURF, WIE ER HEUTE GILT

### (a) Lagerhaltung

**Baum.** EIN Strategy-Storage-Tree im Code, ZWEI Filesystem-Wurzeln — eine `binaries`, eine `measurements` [OWNER 08.08., Ledger:12666-12668]. Konzeptionell synchron, physisch **lazy** (Ordner/Dateien erst beim Schreiben), Befuellung in **zwei Durchlaeufen**: erst Binaries bauen, dann darueber messen [OWNER 08.08., Ledger:12691-12693]. Die Realm-Wahl ist eine **CT-Policy** (Template-Parameter + Concept-Guard, GoF Factory/Strategy — kein Runtime-Switch, kein std::variant) [Doku am Objekt, Ledger:12641-12643]. Die **Ordner-Kaskaden** je Realm sind die vom Owner am 26.07. festgelegten und am 08.08. als „Detail-Pattern-Differenz" bestaetigten: Messdaten-Realm Wurzel = Mess-Tooling×load_framework → System-Haupt-Rekombination (Meta-Metas hinten) → 5 Organ-Gruppen → Haupt-Blatt → Mess-Unter → System-Unter → Organ-Unter → xlsx; Binaries-Realm Wurzel = System-Achse direkt → Organ → **Mess-Typ als tiefster Typ**; CEB-Binaries liegen in den System-Achsen-Knoten am Uebergang zu den Organ-Achsen [OWNER-KERN 26.07., `sessions/20260726-SESSION…:54-63` + ABNAHME-5; bestaetigt Ledger:12647-12662]. Jeder Knoten fuehrt ein `complete-heuristik.log` (Zaehlung je Ast, Spin-Lock-artige Kommunikation, depth-first) [ABNAHME-2, 26.07., `sessions/20260801-KONSOLIDIERT…:13`]. Blatt-Identitaet: „Skip-Marke, minio-Key, Bestandslog-`key_sha512` und Baum-Blatt sind DASSELBE Preimage" (F7-Konvergenz) [Doku am Objekt, Ledger:12635-12637]. Dateinamen tragen NUR Datum+Uhrzeit+dynamische Unter-Achsen-Variablen; Haupt-Achsen liegen in der Ordner-Kaskade und als Metadaten in der Datei [26.07., `…KONSOLIDIERT…:15`]. Ablage-Ziele: minio=Binaries, NAS=Messdaten, beide umkonfigurierbar [26.07., ebd.:16]. **Der Baum-Vollausbau steht VOR dem Voll-Bau-Trigger** [OWNER F9 01.08., verdraengt 26.07.].

**Ausgabeformat.** xlsx ist die Ausgabe (EINE Datei, EIN Sheet je Unter-Achsen-Permutation + INFO-Sheet); **CSV wird NIE verwendet** [OWNER 08.08., Ledger:12577-12580; xlsx-Writer = Eigenbau, Fork/Orientierung libxlsxwriter erlaubt, F3 01.08.].

**Gueltigkeit und SKIP.** Gueltiger Bestand ⇒ SKIP, fuer Messdaten UND Binaries [OWNER 08.08., Ledger:12577/12618]. Kriterium: **exakt gleiche Binary-Identitaet** = SHA512-Fingerprint [OWNER 08.08. + F7 01.08.]; der Fingerprint entsteht constexpr ueber die String-Arrays der Stempel-Zeilen [OWNER 22.07., Ledger:3884] und deckt per Doktrin „Mess-Achsen + System-Achsen + Organ-Achsen" [OWNER 06.08.]. Zusatzbedingung: SKIP nur fuer **gruen-getestet inventarisierte** Binaries (Test-Log neben der Binary = Lagerhaltung); sonst testet der Voll-Build immer hart; der Pruef-Dock-Test laeuft VOR jeder Messung [OWNER-Wortlaut zweifach, 26.07., Ledger:4097]. Neue Version ⇒ neuer Datensatz **zusaetzlich**, nie Ersatz; kein Ueberschreiben, kein truncate ausser im Alleinschreiber-Schlussfall [OWNER 08.08. + A-1 26.07.]. Neu-Inventarisierung bei Log-Loeschung oder neuer Planer/CEB-Version [OWNER 22.07., Ledger:3875]; Version-Bump EINER Haupt-Achse ⇒ selektive Invalidierung aller Binaries, die sie enthalten [OE-C 01.08.].

**Batch.** Korn stets **4096** Binaries, von EINER CEB aufgenommen, MIT ZEITSTEMPEL reserviert [OWNER 22.07., Ledger:3869]. Ein Batch = Job-Meilenstein genau EINER Maschine, nie geteilt/unterbrochen; Batch-Typen (CEB-Compile vs. Tier) auf derselben Maschine nie gemischt, sequentiell; Thread-Budget je Batch voll (prod1 32/24, prod2 24/16) [OWNER 22.07. + F6 01.08.]. Job-Anzahl O(Maschinen): je Maschine EIN Build+Pruef-Batch-Job (CEB iteriert intern, GTest-Pruefstand je Tier) + EIN Mess-Batch-Job [OWNER 21./22.07., Ledger:3863-3865]. Batch-Plan (Reihenfolge + Faecher) wird VOR dem Lauf persistiert; Resume ueber Zaehler [OWNER 05.08.]. ETA: Mini-Batch der Groesse N_threads, ETA=Σt_i/N_threads, Untergrenze max(t_i), vorher 30 min pro forma, je Block wiederholt [OWNER 22.07., Ledger:3870/3879].

**Koordination (Bestandslog).** Versioniertes, gelocktes Bestandsdokument (Header-Version fuer Syntax UND Semantik, im Kern XML) auf minio; zwei Bestaende (Binaries/Messergebnisse) als Factory Pattern mit je eigener Stempel-Strategie [OWNER 22.07., Ledger:3867/3883]. Schreib-Lock = kurze Dokument-Exklusivitaet, endet spaetestens mit der ersten pro-forma-30-min-Reservierung (harte Obergrenze 1800 s, ereignisgebunden; einziger langer Fall = ETA-Berechnung; Multi-Write sobald kompiliert wird — Registrieren in Millisekunden) [OWNER 22.07. + ABNAHME-1 26.07.]. Reservierung = Versprechen mit Release-Pflicht + Done-Kennzeichnung; **Takeover bei ETA+50% ohne Update** („Maschine GESTORBEN"), uebernommen wird nur, was nicht als Bestand verzeichnet ist [OWNER 22.07., Ledger:3871/3873]. Basis-Tests des Lagers: zwei Dummy-Stufen (simulierte Textdokumente mit Stempeln; leere Stub-Binaries nur mit statischem Versionierungs-Interface) [OWNER 06.08.].

### (b) Hardware-Job-Pool

Der Begriff ist vom 09.08.; der Inhalt ist §62 (21./22.07.) auf dem Fundament von §35/§36 (19.07.) und A2/A9 (25.06.). Festgelegt ist:

1. **Gleiche CI/XML fuer alle Maschinen.** Keine per-Maschine-XML, keine Zustaendigkeits-Aufteilung per Konfiguration [OWNER 21.07., Ledger:3862]; „es können auch erstmal alle Maschinen alle Jobs aufnehmen" [OWNER 09.08., Ledger:94-95]. Das Floaten der CI-Jobs zwischen den bare-metal-Runnern ist der Entwurf. GitLab-Tags sind als Steuerung supersediert [§62-A, 21.07.]; **Ausnahme**: die Mess-Jobs sind bewusst maschinen-gepinnt (Lane vollstaendig auf EINER Maschine, resource_group je Maschine) [§61, 21.07.; bestaetigt am Objekt 09.08.: measure:golden-320/measure:smoke `tags: [prod, baremetal, amd]`, Ledger:47].
2. **Filterung je Hardware-Freigabe, maschinenseitig.** Jede Maschine baut das Maximum ihrer Faehigkeiten; was sie nicht kann (z.B. avx512-Zellen auf prod2), faellt NICHT durch einen CI-Vorfilter weg, sondern maschinenseitig durch die Freigabe-Kopplung (System-Achse gibt frei, Organ ≤ Freigabe) — mit **WARNUNG samt machine_id und Grund** (Fehlerklasse HardwareErweiterungFehlt), das Experiment misst weiter [§62-A 21.07.; §36 19.07.; 26.07.]. Der Filter sitzt an der CEB-Bau-Delegations-Naht (provision_all/CompileFn) [05.08., Ledger:4623]. Odroid-H4-Klasse: baut mit, aber nur Zellen, deren Erweiterungen sie anbietet (no_extension ueberall; avx2/avx512 nur wo Hardware) [OWNER §36, 19.07.].
3. **Abstimmung ueber das Lager, wer welches Batch nimmt.** Ueber das gemeinsam sichtbare Bestandslog: 3-Stufen-Dedup (nie erneut bauen, was als Bestand verzeichnet ist — jede Permutation clusterweit genau EINMAL, „egal wo" [§35]), Batch-Reservierung first-come („wer zuerst zugreift, bestimmt den ersten Batch") [OWNER 21.07.], **Gleichverteilungs-Pflicht fuer die gemeinsame Menge** („Binaries, die BEIDE Maschinen verarbeiten koennen, werden GLEICHVERTEILT") [OWNER 22.07.], Takeover-Regel fuer tote Maschinen [OWNER 22.07.]. Ein Batch gehoert immer ganz einer Maschine [F6 01.08.].
4. **Modi und Abschluss je Maschine.** Debug/Messung/Release laufen JE MASCHINE; danach COMPARE ueber das Mess-Replay; „das Release der optimalen Binary gilt NUR je EINZELNE Maschine mit ihrer System-Achsen-Konfiguration (Hardware) und ist nur dort reproduzierbar"; CI erst fertig, wenn die XML auf ALLEN gewuenschten Maschinen je Maschine ausgewertet ist [§62-C, 21.07., Ledger:3888].

**Wo der Bestand schweigt:** Eine Zuteilungs-Heuristik FEINER als „Gleichverteilung der gemeinsamen Menge + first-come + Takeover" (etwa Prioritaeten, Affinitaeten, Kostenmodelle) ist nirgends festgelegt — der Korpus kennt nur diese drei Regeln. Ebenso ist nirgends festgelegt, dass eine dritte konkrete Maschine bereits am Bestandslog-Verbund teilnimmt (Zielbild „Dutzende Maschinen"/N Nodes ist Owner-Wort, konkrete Thread-Budgets existieren nur fuer prod1/prod2).

### (c) AVX-Maximalkompilierung

1. **Wie das Maximum entsteht:** NICHT durch automatische Host-Erkennung beim Compile. `-march=native` ist ausdruecklich als „host-abhängig, nicht golden-portabel" eingeordnet und nicht der Mechanismus [17.07.]. Stattdessen: Die SIMD-Stufe ist eine **deklarierte Achsen-Auspraegung** (no_extension/avx2/avx512, Flags je Compiler getrennt), die die **CEB selbst zur eigenen Laufzeit permutiert** und je Auspraegung Tier-Binaries **compile-time statisch** ausstattet — „einkompiliert ODER zum Performance-Vergleich NICHT mit einkompiliert → volle Kontrolle" [OWNER H-7 + Q2-C, 17.07.]. Eine Maschine erreicht ihr „Maximum", indem sie **alle Achsen-Zellen baut, die ihre Hardware freigibt** (prod1: alle 3 simd-Stufen; prod2: no_extension+avx2) [§36 19.07.; §62-B 21.07.; 26.07.: 4 opt × 3 simd = 12 Perms, avx512 faellt auf prod2 mit Warnung weg]. Feingranular ist je Maschine eine **deklarierte Signatur einzelner SIMD-Flags** vorgesehen (avx512f/vl/bw/…, nicht Grob-Level), gegen die Organ-Bedarfe geschnitten werden [§40.a 19.07.; 23-Flag-Katalog `docs/architektur/20260719-simd-flag-signaturen-REFERENZ.md`]. Kein Runtime-Switch im Hot-Path [10.07.]; cpuid/XGETBV-Probe gegen SIGILL [15.07.]; Passungs-Stempel (ISA×OS, Loader-Pruefung, Statuscode 9) ist **spezifiziert, aber bewusst ruhend** [27.07./01.08.].
2. **Achse oder Bau-Umgebung:** SIMD ist eine **System-Achse der Bau-Umgebung, keine Organ-/Prueflings-Achse** — und sie ist **binary_id-neutral**: sie multipliziert nur die Bau-Matrix/den Sidecar (`build_version` traegt `+opt=…+ext=…`), nie die Organ-Kartesik [Q2-C 17.07. „NIE binary_id"; 26.07. binary_id="never"; IST 07.08. bestaetigt]. Die **Einordnung im Achsen-Gefuege** hat sich bewegt: eigenstaendige 6. System-Achse „Erweiterungshardware" [OWNER Q2-C, 17.07.] → Compiler-Unterachse fuer CPU-SIMD [OWNER OF-1, spaeter am 17.07.] → **Meta-Meta-Achse unter dem external_utils-Hub** [OWNER R-F, 26.07. — juengste Owner-Einordnung] → IST-Code 07.08.: `external_utils.simd` als eine von drei System-Achsen. Der 17.07.-Selbstwiderspruch wurde nie als solcher ausdruecklich aufgeloest (siehe (3) und (5)).
3. **Fehlerverhalten:** Fehlende Hardware-Erweiterung ist ein klassifizierter, geloggter Fehler mit Weiterlauf, nie ein Absturz und nie eine stille Auslassung [OWNER 17.07.; §62-A 21.07.; 26.07.].

---

## (3) DIE LUECKEN, SAUBER GETRENNT

### GEFUNDEN UND ENTSCHIEDEN (Auswahl der tragenden Festlegungen)
- Job-Floaten ohne Tag-Pin = Entwurf; Koordination ueber das Lager [OWNER 21.07. Ledger:3862 + 09.08. Ledger:94-95].
- Gleiche XML/CI fuer alle Maschinen; Gleichverteilung der gemeinsamen Menge; Batch 4096/Zeitstempel; Takeover ETA+50%; Lock-Obergrenze 30 min [OWNER 21./22.07., Ledger:3862-3881].
- SKIP-Kaskade: gruenes Test-Log Pflicht [26.07., Ledger:4097] · SHA512-Fingerprint als alleiniger Schluessel [F7 01.08.] · Fingerprint-Trias Mess+System+Organ [OWNER 06.08.] · exakt gleiche Binary, additiv, xlsx, CSV nie [OWNER 08.08., Ledger:12577-12580].
- Ein Storage-Tree, zwei Wurzeln, lazy, zwei Durchlaeufe; Realm-Differenz nur Factory/Detail-Pattern; 26.07.-Kaskaden gelten fort [OWNER 08.08., Ledger:12618-12693 — inkl. expliziter Aufloesung der Baum-Lesart].
- Baum-Vollausbau VOR Voll-Bau-Trigger [OWNER F9 01.08., verdraengt 26.07.].
- H-7-Maximalkompilierung statisch ueber Achsen-Zellen, `-march=native` nicht der Weg [OWNER 17.07.].
- Warnung-statt-Vorfilter mit machine_id+Fehlerklasse [§62-A 21.07.; 26.07.].
- simd binary_id-neutral, Provenienz im `+ext=`-Sidecar/build_version; minio-Key `<build_version>/<stem>` [17.07. H-10/INC-1g, Ledger:2572; §35.2 19.07., Ledger:2869].
- Mess-Jobs gepinnt (eine Lane = eine Maschine), Bau-Jobs floaten — zwei Regeln fuer zwei Job-Klassen [§61 21.07.; Ledger:47+123, 09.08.].
- Kein generelles Job-Pinning als Antwort auf den 09.08.-Befund; stattdessen: Wachen weisen ihren Nenner MIT Maschine aus [09.08., Ledger:121-125].

### GEFUNDEN, ABER OFFEN GELASSEN (besprochen und ausdruecklich vertagt/ungeklaert)
- **Strang 8**: „unterscheidet das Lager die beiden Ergebnisse?" — vom Lead selbst als offen markiert, „wird gerade am Objekt geprüft" [09.08., Ledger:126-131]. Siehe (4).
- **Q2-C vs. OF-1** (SIMD eigenstaendige 6. Achse vs. Compiler-Unterachse, beide OWNER, beide 17.07.): vom Lead als „echt entscheidungsbedürftig … keine stille Migration" geflaggt [`…inc2copt…KORRIGIERT…:60`]; eine spaetere Owner-Ruling, die DIESEN Konflikt benennt und entscheidet, wurde nicht gefunden (vokabular-avx, gezielt gesucht, mit Gegenprobe); sachlich ueberholt durch R-F 26.07. (Meta-Meta/external_utils) und den IST-Stand 07.08., aber formal nie geschlossen.
- **GPU/FPGA-Beschleuniger-Array** (OF-1, dynamische System-Hauptachsen): NACH-ABGABE geparkt [20.07., bestaetigt 06.08.].
- **P5 Passungs-Stempel** (Fehl-Deploy-Schutz): spezifiziert, ruht bewusst bis nach Voll-Build+Messlauf [OWNER SPEC-SCHLUSS 01.08.].
- **machine_signature/active_machine_signature() als aktiver Gate-Konsument**: im §48-Statusblock als „bewusst spaeter"/OFFEN gefuehrt (vokabular-maschine).
- **OV-5-Spannung**: Thesis-Methodik auf Ein-Maschinen-Betrieb (prod1) umgestellt [08.08.] bei gleichzeitig owner-bestaetigter Zwei-Maschinen-Architektur [09.08.] — wie beides zugleich gilt, ist nicht entschieden.
- **„synchron angelegt"** war kurz offen und wurde vom Owner noch am 08.08. geschlossen (lazy, konzeptionell synchron) — hier nur als Beispiel, dass der Ledger solche Restfragen explizit fuehrt [Ledger:12683-12699].

### NIRGENDS GEFUNDEN (je ≥2 Modalitaeten unabhaengig, je mit Gegenprobe)
- **„Hardware-Job-Pool"** (auch „Job-Pool") vor dem 08./09.08.: 0 Treffer in sessions/, plaene/, Ledger und 248 Memories — drei Modalitaeten (vokabular-maschine, chronologie, memory-korpus), Gegenproben bestanden (job-pool-Muster trifft exakt die 09.08.-Dateien; Kontrollmuster „Owner" 76/248). **Der Begriff ist neu am 09.08.; das Konzept ist seit 19.-22.07. vollstaendig, seit 25.06. angelegt.**
- **„Maschinenfähigkeiten"** vor 09.08.: 0 Treffer — zwei Modalitaeten; Gegenprobe: Wortstamm „Maschinen" allein 450+37 Treffer.
- **Pipeline „15412" / „44 von 48"** ausserhalb der Fund-Dokumente vom 08./09.08.: 0 Treffer — zwei Modalitaeten (chronologie; memory-korpus 0/248 mit Gegenprobe). Der ausloesende Messbefund ist eine einmalige, nirgends wiederholte Erhebung.
- **Eine explizite Korpus-Aussage „das Lager unterscheidet AVX-512- von AVX2-Binaries (bzw. liest +ext= beim SKIP)"** in genau dieser Form: nicht vorhanden — zwei Modalitaeten (vokabular-avx; memory-korpus, je mit Gegenprobe). Vorhanden sind nur die Bausteine, aus denen es folgt (siehe (4)).
- Nur einfach belegt (eine Modalitaet, mit Gegenprobe — nach Auftragsregel nicht als harter Nichtfund behauptbar, hier als Randnotiz): `COMDARE_GN_SIMD` (0 Treffer; real sind COMDARE_PILOT_SIMD_POLICY/COMDARE_HOST_RUNS_*), „Anmeldeverfahren"/„Sperre" als Fachbegriffe (das Projekt sagt Lock/Reservierung), `storage_tree` als snake_case in der Prosa (Code heisst `LagerBaumWriter`), sowie: der Owner-Satz mit „Hardware-Job-Pool" steht woertlich NICHT im Ledger selbst, nur in plaene/ + Memory (Ledger zitiert nur den ersten Satz) — trotz Single-Source-Anspruch des Ledgers.

---

## (4) DIE FRAGE, DIE DEN AUSSCHLAG GIBT

**War geplant, dass verschieden faehige Maschinen VERSCHIEDENE Binaries desselben Prueflings bauen — und wie sollte das Lager sie unterscheiden?**

**Ja — aber in einer praezisen Form: verschieden nach ACHSEN-ZELLE, nicht nach Maschine.** Der Entwurf kennt keine zwei maschinenabhaengigen Varianten derselben Permutation. Die SIMD-Stufe ist eine deklarierte System-Achsen-Auspraegung (no_extension/avx2/avx512); **jede Permutation wird clusterweit genau EINMAL gebaut — „egal wo"** [OWNER §35, 19.07., Ledger:2865]. Verschieden faehige Maschinen bauen daher verschiedene **Teilmengen des Permutationsraums**: „prod1 baut ALLES, was es kann, und prod2 baut ALLES, was es kann" [OWNER §62-B, 21.07.]; „Binaries, die BEIDE Maschinen verarbeiten koennen, werden GLEICHVERTEILT" [OWNER 22.07., Ledger:3868] — der Satz setzt logisch voraus, dass es Binaries gibt, die nur EINE Maschine bauen kann: die avx512-Zellen gehoeren allein prod1 (§36: avx2/avx512 „nur wo Hardware"; 26.07.: avx512-Perm faellt auf prod2 mit Warnung weg). Derselbe Pruefling (dieselbe binary_id/Organ-Komposition) existiert also planmaessig als mehrere Zellen-Binaries: einmal je simd×opt×compiler-Auspraegung [H-7 17.07.: einkompiliert ODER bewusst nicht — beide sind gewollte, getrennte Produkte].

**Die Unterscheidung im Lager ist geplant ueber die Achsen-Identitaet in Stempel und Schluessel, nicht ueber eine Maschinen-ID:**
- `build_version` + H-10-Sidecar tragen `+ext=…+cxx=…` (literal belegt: `m3v2+ext=no_extension+cxx=g++-16`) [17.07., Ledger:2572]; der Cache-/minio-Key ist `<build_version>/<stem>` [§35.2, 19.07., Ledger:2869] — zwei simd-Stufen desselben Prueflings haben damit per Entwurf verschiedene Keys.
- Der SKIP-Schluessel ist der constexpr-**SHA512-Fingerprint ueber die Stempel-Zeilen** [OWNER 22.07., Ledger:3884; F7 01.08.: SKIP ausschliesslich Fingerprint], und die Fingerprint-Doktrin nennt die System-Achsen ausdruecklich als Bestandteil: „Mess-Achsen + System-Achsen + Organ-Achsen identisch → fingerprint" [OWNER 06.08.]. F7-Konvergenz: Skip-Marke, minio-Key, `key_sha512`, Baum-Blatt = **dasselbe Preimage** [Ledger:12635].
- Wichtige Nuance: die **binary_id selbst traegt simd NICHT** (binary_id="never" → Suffix/Sidecar) [26.07.] — wer nur die binary_id vergleicht, kann avx2 und avx512 nicht trennen; der Entwurf legt die Trennung deshalb in build_version/Sidecar/Fingerprint.
- Flankierend: das **simd-Gate liegt VOR dem dll_is_current-Skip** und darf vom Pull-Pfad nie umgangen werden; jede Mess-Zeile traegt die platform-Spalte `<lane>@hostname` [§62-D, 21.07.]; der Mess-Bestand keyt „voll-permutativ + Hardware-Identitaet" [Ledger:3883]; das Release ist „NUR je EINZELNE Maschine mit ihrer System-Achsen-Konfiguration … nur dort reproduzierbar" [§62-C, 21.07.].

**Was der Korpus NICHT hergibt:** ob der IST-Code diesen geplanten Unterschied beim SKIP-Vergleich tatsaechlich AUSWERTET. Genau das ist die am 09.08. offen gelassene Strang-8-Frage („wird gerade am Objekt geprüft", Ledger:126-131); zwei Modalitaeten fanden keine Korpus-Stelle, die sie beantwortet (je mit Gegenprobe), und das 08.08.-Audit fand Storage-Tree-Writer und realen SKIP-Arbiter im Code unverbunden sowie `COMDARE_BESTANDSLOG` ungesetzt [`plaene/20260808-WELLENPLAN-ANLAGE…:347-361`]. **Plan-Ebene: eindeutig ja, mit benanntem Mechanismus. Objekt-Ebene: offen — das ist ein Befund, keine Luecke dieses Berichts.**

---

## (5) WIDERSPRUECHE (beide Daten, neuere Fassung gekennzeichnet)

1. **Baum vor Trigger.** 26.07.: „Voll-Bau-4 wartet NICHT auf den Baum-Vollausbau" (`memory/project_lager_baeume_xlsx_doktrin.md:17`) ↔ **NEUER, gilt**: F9 01.08. „Lagerhaltung SAMT BAUM muss VOR dem Compile stehen" — die Quelle markiert die aeltere Aussage selbst als VERDRAENGT (`sessions/20260801-KONSOLIDIERT…:4-5`).
2. **Tag-Routing.** 19.07. §35/§36/§39: SIMD-Tag-Routing entworfen UND real scharf geschaltet (Ledger:2868/2937) ↔ **NEUER, gilt**: 21.07. §62-A supersediert Tag-Vorfilterung („sie sollten keine Rolle spielen", Ledger:3855); die statische 24-Zellen-Matrix verlor ihre Steuerungsrolle noch in der Nacht des 19.07. (W10/§42) und wurde am 20.07. DEPRECATED. Die 09.08.-Owner-Aussage deckt sich mit der neueren Linie; der 09.08.-Text erwaehnt die zwischenzeitliche Kehrtwende nicht.
3. **Selber Tag, zwei Regeln (21.07.).** §61 verlangt Host-Lanes per Runner-Tag (avx512→amd) ↔ §62-A verbietet Vorfilter. Aufloesung steht in der Quelle: Lanes = INTERIM, als Zielbild supersediert — UND als bleibende Zweiteilung: **Mess-Jobs gepinnt, Bau-Jobs floaten** (bestaetigt 09.08., Ledger:47/123).
4. **Q2-C vs. OF-1, selber Tag (17.07., beide OWNER).** SIMD = eigenstaendige 6. System-Achse (Ledger:2571) ↔ SIMD = Compiler-Unterachse (Ledger:2579). Nie explizit aufgeloest; gebaut wurde zunaechst Q2-C (20.07.), die juengste Owner-Einordnung ist R-F 26.07. (Meta-Meta unter external_utils), der IST-Code 07.08. zeigt diesen dritten Weg.
5. **Lock-TTL.** Agenten-Wert „LockB-90s" (~24.07.) ↔ **OWNER-Original gilt**: ereignisgebunden, Obergrenze 30 min (22.07., Ledger:3876; ABNAHME-1 26.07. weist den 90s-Wert ausdruecklich zurueck).
6. **prod2-Identitaet.** 25.06./03.07./06.07./19.07. uebereinstimmend „i9-14900KS (Raptor Lake Refresh)", API-verifiziert ↔ **NEUER**: 07.08.-Analyse und 09.08.-Live-`== Host ==` „i9-12900K (Alder Lake)". Die 07.08.-Analyse datiert einen **realen CPU-/Maschinentausch auf den 27.07.** und benennt den fortbestehenden Code-Namensdrift `Prod2RaptorLakeSignature`; die memory-korpus-Modalitaet vermutete alternativ eine Uebernahme aus dem PMC-Erklaerbeispiel (06.08.). Beide Linien einig: prod2 hat kein AVX-512.
7. **prod2-Erreichbarkeit.** 08.08.: `ping prod2` unbekannt, OV-5 stellt die Thesis auf Ein-Maschinen-Betrieb ↔ **09.08.**: Pipeline-Job 368969 laeuft nachweislich auf prod2. Zustandswechsel binnen Stunden; die Spannung OV-5 (eine Maschine in der Methodik) vs. bestaetigte Zwei-Maschinen-Architektur ist nicht aufgeloest.
8. **Runner-Concurrency, selber Tag (26.07.).** „concurrency=1 als Mess-Schutz, gewollt" (`memory/project_20260726_nach_trigger…:18`) ↔ **live widerlegt**: real 3/2 seit 18.07., „Es gab NIE ein haengt auf concurrency=1 als Mess-Schutz" (`memory/reference_runner_concurrency_ist_3_2_stau_ist_backlog.md:12-19`); 06.08. SOLL=4/4. Die empirisch verifizierte Fassung gilt.
9. **Hart-Gruen vs. Warnung vs. rote 15412.** 17.07.: „gesamte pipeline IMMER hart grün" [OWNER] und zugleich: fehlendes AVX512 = Warnung, Experiment laeuft weiter [OWNER 17.07., 26.07.] ↔ 08./09.08.: Pipeline 15412 wird WEGEN des AVX-512-Hardware-Unterschieds rot (Test-Sichtbarkeits-Wache mit prod1-Nenner biss auf prod2). Die 09.08.-Richtigstellung korrigiert nur die Koordinations-Deutung; ob das Rot selbst regelkonform war, beantwortet sie nicht — als verbleibende Aufgabe benannt ist nur „Nenner MIT Maschine ausweisen" (Ledger:121-125).
10. **O(Maschinen) vs. 48 Jobs.** §62-B (22.07.) verlangt O(Maschinen)-Batch-Jobs und benennt die damalige Chunk-Job-CI als IST-VERSTOSS ↔ 09.08. zaehlt 48 Jobs beider Repos. K3 (01.08.) erklaert die Stufe-2-Batch-Ebene fuer korrekt konsolidiert (konstant 4 Batch-Jobs); ob die 48er-Gesamtzahl (Bau/Test/Sanitize etc. beider Repos) dem Batch-Gesetz widerspricht, laesst sich aus dem Korpus allein nicht entscheiden — dieser Auftrag hat keinen Code geprueft.
11. **Scheinwiderspruch, in der Quelle aufgeloest:** „ZWEI LAGER-BAEUME" (26.07.) ↔ „exakt derselbe Baum" (08.08.) — der Ledger loest ihn selbst: derselbe Baum = dieselbe Grammatik/Identitaet/Mechanik (ein Writer, zwei CT-Policies); die je Realm verschiedene Ordner-Kaskade ist die vom Owner gemeinte „Detail-Pattern"-Differenz, kein Defekt (Ledger:12654-12681).

---

**Kernaussage in einem Absatz:** Alles, was der Owner am 09.08. als „so geplant" bezeichnete, steht seit dem 19.-22.07. woertlich im Ledger (§35/§36 Pool + §62 A-D), mit Wurzeln am 25.06.; neu am 09.08. ist nur das Vokabular („Hardware-Job-Pool", „Maschinenfaehigkeiten", „gleiche CI", „custom Filterung" — drei Modalitaeten, je mit Gegenprobe). Die Lagerhaltung ist als Koordinations- UND Identitaetsschicht vollstaendig festgelegt (Baum, SKIP-Fingerprint, 4096er-Batches, Lock/Takeover, Gleichverteilung); die AVX-Maximalkompilierung ist als statische Achsen-Permutation mit maschinenseitiger Freigabe-Filterung festgelegt (H-7/Q2-C/§36/§62-A), nicht als `-march=native`. Offen im Korpus sind exakt drei Dinge: die formale Aufloesung Q2-C/OF-1 (sachlich durch R-F 26.07. ueberholt), die OV-5-Spannung Ein- vs. Zwei-Maschinen-Betrieb, und Strang 8 — ob der IST-SKIP die geplante `+ext=`-Unterscheidung tatsaechlich liest. Fuer Strang 8 liefert der Plan-Korpus die eindeutige SOLL-Antwort (Fingerprint ueber System-Achsen-Stempel; simd-Gate vor dem Skip), aber keine Objekt-Bestaetigung — die liegt im Code, nicht in den Dokumenten.
