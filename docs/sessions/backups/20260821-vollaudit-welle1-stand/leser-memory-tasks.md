# Sammelstrecke: MEMORY.md + MEMORY-DETAIL.md + task_board_dump.md -- Vollaudit-Extraktion

Quellen (VOLLSTAENDIG per Read gelesen, je 1 Block ohne Truncation): MEMORY.md (108 Z.), MEMORY-DETAIL.md (62 Z.), task_board_dump.md (46 Z.). Dedup nur innerhalb der jeweils gleichen Quelldatei. Owner-Worte immer eigene Zeile. Unklares = Klasse UNKLAR, nie weggelassen.

| KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| NUR FABLE 5 MAX (voruebergehend) | OWNER-ENTSCHEID | MEMORY.md:3 | GELANDET (aktiv seit 12.08., bis Widerruf; danach zurueck zu A1-Matrix+KON38) | Owner 12.08. |
| STAND 10.08. (Auslaufdokument) | UNKLAR | MEMORY.md:6 | GESTRICHEN (abgeloest durch Ledger-Kopf KON118) | -- |
| 12/14 Definitionen in STAND 10.08. falsch | REGRESSION | MEMORY.md:6 | BEHOBEN (lebender Stand jetzt=Ledger-Kopf KON118, 18.08.) | -- |
| ZWEI MESS-ARCHITEKTUREN (System A live / System B dormant) | FEATURE | MEMORY.md:7 | GEPLANT (Konflikt dokumentiert) | KON34 |
| HARDWARE-ERWEITERUNG IST ADDITIV | OWNER-ENTSCHEID | MEMORY.md:8 | GELANDET (nur Funktionseinschraenkung erzwingt Neubau) | -- |
| PMC = Meta-Meta | OWNER-ENTSCHEID | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08. |
| Fallback-Reihenfolge 5/2/1 | OWNER-ENTSCHEID | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08. |
| Binary-Zahl NUR aus Planungs-Simulation | OWNER-ENTSCHEID | MEMORY.md:9 | GELANDET | Owner-Antworten 10.08.; rechnet S-19 |
| GOAL v8 + TDD-Vertrag | AUFGABE | MEMORY.md:10 | GEPLANT (Frist 15.09., 5 Pruefungen T-1..T-9) | -- |
| MEMORY-DETAIL.md (Auslagerung Architektur/Kette/Infra/Rollen/Planung/Thesis) | UNKLAR | MEMORY.md:11 | GELANDET (Verweisziel, separat ausgewertet) | -- |
| 106 UNVERLINKTE MEMORIES (Konsolidierung) | AUFGABE | MEMORY.md:12 | OFFEN (liegt in super docs/plaene/20260810-KONSOLIDIERUNG-*) | -- |
| STEMPEL-STRECKE = FABLE 5 MAX UEBERALL | OWNER-ENTSCHEID | MEMORY.md:15 | GELANDET | Owner-KERN 12.08., KON38 |
| STEMPEL: FUENF ROLLEN (Identitaet/Cache/Lager/Skip/Einordnung) | FEATURE | MEMORY.md:16 | GEPLANT/dokumentiert | -- |
| ORT != ZEIT (keine Phasigkeit aus ORT-Satz) | OWNER-ENTSCHEID | MEMORY.md:17 | GELANDET (KON8-12/KON13) | -- |
| KEINE YAML -- Planer emittiert PROZESS | OWNER-ENTSCHEID | MEMORY.md:18 | GELANDET | -- |
| DREI FLAECHEN (Genus/Stempel/measurement-Durchstich) | FEATURE | MEMORY.md:19 | dokumentiert | -- |
| SELBSTKOMPILATION (Director/Builder+AxisCommand) | FEATURE | MEMORY.md:20 | GEBAUT (3/4 Bausteine da), fehlt Steuerung->Compile | -- |
| Ledger-Kopf = juengste KON (aktuell KON118) | OWNER-ENTSCHEID | MEMORY.md:21 | GELANDET (18.08.) | Konsolidierung IV, Wellenplan Par.18 |
| KON35 nie vergeben | UNKLAR | MEMORY.md:21 | OFFEN (Luecke in KON-Nummerierung) | -- |
| ZEITHORIZONTE UEBERGEHEN -- ALLES SOFORT | OWNER-ENTSCHEID | MEMORY.md:24 | GELANDET | Owner 20.08. |
| VERTAGT = NUR ZWISCHENZUSTAND | OWNER-ENTSCHEID | MEMORY.md:25 | GELANDET (landen -> Vertagte durchziehen -> NACHLANDEN) | Owner 19.08. |
| NIE KUERZEN -- KETTE VOLL, ALLE FEATURES | OWNER-ENTSCHEID | MEMORY.md:26 | GELANDET (Dauerregel 3x owner-gesetzt, zuletzt 19.08.) | Owner |
| STEMPEL-KUERZEL IMMER ZERLEGEN | OWNER-ENTSCHEID | MEMORY.md:27 | GELANDET (cpe=c{p.e} nie flach) | -- |
| ZWOELF-WOCHEN-ultracode-EXPLORE fuer JEDE Frage | AUFGABE | MEMORY.md:28 | GELANDET (Normalfall) | -- |
| Falsch-Null-Muster (Encoding/Case/~95-Zeichen-Umbruch) | REGRESSION | MEMORY.md:28 | OFFEN-REGRESSION (staendiges Risiko bei Explore) | -- |
| CODE-REVIEW = Opus max ERHEBT + Fable max BEWERTET | OWNER-ENTSCHEID | MEMORY.md:29 | GELANDET | -- |
| CI-DUAL-COMPILER ALLE BEREICHE | OWNER-ENTSCHEID | MEMORY.md:30 | GELANDET (20.08.) | Owner-KERN; Erhebung+Fix=#106 |
| SYNTHESE = Fable 5 max, NIE Opus | OWNER-ENTSCHEID | MEMORY.md:31 | GELANDET (nur uebers Workflow-Tool setzbar) | -- |
| BESTANDS-PFLICHT vor Neuimplementierung | AUFGABE | MEMORY.md:32 | GELANDET | -- |
| NEU GRUENDEN + VOLL KIPPEN nach jedem Compact | OWNER-ENTSCHEID | MEMORY.md:33 | GELANDET (Dauerorder) | -- |
| K17-Pausen-Sonderorder | OWNER-ENTSCHEID | MEMORY.md:33 | GESTRICHEN (verbraucht 20.08., Owner "Dann weiter") | -- |
| GOAL allein genuegt NICHT (Arbeitsweise eigenes Dokument) | AUFGABE | MEMORY.md:34 | GELANDET | -- |
| Sessions ab 08.08. LESEN statt Reviews fahren | AUFGABE | MEMORY.md:34 | GELANDET | -- |
| ERST LAUTE COMPILE-FEHLER, DANN VERSCHIEBEN | AUFGABE | MEMORY.md:35 | GELANDET | -- |
| FERTIGE ARBEIT LANDEN (erst Landung, dann aufraeumen) | AUFGABE | MEMORY.md:36 | GELANDET | -- |
| WORKTREE loeschen erst gruen+gemergt | AUFGABE | MEMORY.md:37 | GELANDET | -- |
| Submodul-Branches VORHER pruefen (vor Worktree-Loeschung) | OWNER-ENTSCHEID | MEMORY.md:37 | GELANDET | -- |
| NESTED Worktrees sterben mit dem Eltern-Worktree | REGRESSION | MEMORY.md:37 | OFFEN-REGRESSION (Risiko bei Loeschung) | -- |
| STUMME WORKFLOW-TODE (journal.jsonl=Wahrheit) | REGRESSION | MEMORY.md:38 | OFFEN-REGRESSION (Diagnoseweg: zuerst df -h) | -- |
| VOLLE PLATTE TOETET AUCH HOOKS | REGRESSION | MEMORY.md:39 | BEHOBEN (Ausweg: rm -rf ~/.cache/uv/builds-v0) | -- |
| PARALLEL BAUEN, SEQUENTIELL LANDEN | AUFGABE | MEMORY.md:40 | GELANDET (Lande-Stufe im Workflow, landet den Zweig) | -- |
| LANDUNG HARMONISIERT VERTRAEGE | OWNER-ENTSCHEID | MEMORY.md:41 | GELANDET (harmonisieren statt mergen; Zaehlwerke einmal live) | -- |
| EIN SCHREIBER JE WORKTREE | AUFGABE | MEMORY.md:42 | GELANDET | -- |
| WARNUNGS-REVIEW ZWEIMAL (gcc dann clang) | AUFGABE | MEMORY.md:43 | GELANDET | -- |
| Google Tests Debug+Release (keine Shell-Proben) | AUFGABE | MEMORY.md:43 | GELANDET | -- |
| VOLLBAU-LUECKEN = FALSCHES GRUEN | REGRESSION | MEMORY.md:44 | OFFEN-REGRESSION | J-0b PRUEFLINGE-Var, J-1 SIEBEN Werkzeuge->RE-CONFIGURE->Vollbau |
| VERDECKTE exit-ZWEIGE (Mutant bleibt gruen) | REGRESSION | MEMORY.md:45 | OFFEN-REGRESSION (nicht beobachtbar) | -- |
| ABSCHRIFT statt Aufruf -- Loeschung bricht nur bei Aufrufern | AUFGABE | MEMORY.md:45 | GELANDET (Prinzip) | -- |
| Nie raten -- immer State-of-Art/Docs nachschlagen | AUFGABE | MEMORY.md:46 | GELANDET | -- |
| GOAL-Hook thorough read in "never guess" | AUFGABE | MEMORY.md:46 | GELANDET | -- |
| Kein Erfolgs-Haken ohne woertlichen Output | AUFGABE | MEMORY.md:46 | GELANDET | -- |
| Gruendliche Annahmen im Workflow-Planning | AUFGABE | MEMORY.md:46 | GELANDET | -- |
| Keine Quick-Fixes | OWNER-ENTSCHEID | MEMORY.md:47 | GELANDET | -- |
| Immer schwererer offizieller Weg (CMake/ctest, keine Behelfswege) | AUFGABE | MEMORY.md:47 | GELANDET | -- |
| Infra: sauberste statt einfachste Loesung | AUFGABE | MEMORY.md:47 | GELANDET | -- |
| Nur EIN offizielles XML-getriebenes Programm, keine Behelfswege | OWNER-ENTSCHEID | MEMORY.md:47 | GELANDET | -- |
| Deploy Key nur privates CI-Template, nie in public Repos | OWNER-ENTSCHEID | MEMORY.md:47 | GELANDET | -- |
| ultracode-Workflow fuer Unklarheit und absolute Behauptungen | AUFGABE | MEMORY.md:48 | GELANDET | -- |
| "Scheint fertig?" -> ultracode-Verifikation Pflicht | AUFGABE | MEMORY.md:48 | GELANDET | -- |
| Analyse-Backups vor Entscheidungen via ultracode konsultieren | AUFGABE | MEMORY.md:48 | GELANDET | -- |
| Ledger komplett + ultracode-Richtung vor Abschnitten | AUFGABE | MEMORY.md:48 | GELANDET | -- |
| bwrap DAUERHAFT defekt fuer Codex (7 Belege) | REGRESSION | MEMORY.md:49 | BEHOBEN (Workaround: codex exec + Volltext im Prompt) | -- |
| Codex klein schneiden + IMMER zweiten Lens parallel | OWNER-ENTSCHEID | MEMORY.md:49 | GELANDET | -- |
| Ledger immer ZUERST lesen vor Handeln | OWNER-ENTSCHEID | MEMORY.md:50 | GELANDET | -- |
| Vor jedem TODO liest Agent vollen Ledger + manuelle Details | AUFGABE | MEMORY.md:50 | GELANDET | -- |
| Offene Entscheidung -> erst Ledger+Plandocs erneut lesen | AUFGABE | MEMORY.md:50 | GELANDET | -- |
| Fehlende Entscheidung erst Explore, alles ist entschieden | AUFGABE | MEMORY.md:50 | GELANDET | -- |
| Vor Aufgaben erst Projektstruktur-Analyse | AUFGABE | MEMORY.md:50 | GELANDET | -- |
| Nie rebase, immer merge | OWNER-ENTSCHEID | MEMORY.md:51 | GELANDET | -- |
| Gitflow-Branch-Doktrin (main Autoritaet, development voraus) | OWNER-ENTSCHEID | MEMORY.md:51 | GELANDET | -- |
| Alle Projekte Dual-Remote GitHub+GitLab | OWNER-ENTSCHEID | MEMORY.md:51 | GELANDET | -- |
| GitHub flache Out-of-house-Sicherung, Fokus GitLab | AUFGABE | MEMORY.md:51 | GELANDET | -- |
| Nach Push GitLab-Pipeline-Gruen verifizieren | AUFGABE | MEMORY.md:51 | GELANDET | -- |
| Remote-Loeschung erfordert explizite User-Autorisierung | OWNER-ENTSCHEID | MEMORY.md:51 | GELANDET | -- |
| Diplomarbeit 4 Projekte lokale Klone synchron halten | AUFGABE | MEMORY.md:51 | GELANDET | -- |
| Messdaten nie loeschen, auch wenn ABI bricht | OWNER-ENTSCHEID | MEMORY.md:52 | GELANDET | -- |
| Dokumentation nie loeschen, nur deprecaten | OWNER-ENTSCHEID | MEMORY.md:52 | GELANDET | -- |
| Raw-Data-Backups additiv, nie loeschen | OWNER-ENTSCHEID | MEMORY.md:52 | GELANDET | -- |
| Backups nur Workflow-Rohdaten, nie Sessions/Plaene | AUFGABE | MEMORY.md:52 | GELANDET | -- |
| rm build/-Verzeichnis enthaelt getrackte Mess-CSV (Falle) | REGRESSION | MEMORY.md:52 | OFFEN-REGRESSION | -- |
| Tasks-Liste ist nutzersichtbares TODO, aktuell halten | AUFGABE | MEMORY.md:53 | GELANDET | -- |
| Pipeline #286 (Multi-Day-Experiment) nie pollen | OWNER-ENTSCHEID | MEMORY.md:53 | GELANDET | -- |
| Monitore duerfen nie stumm haengen -- Vollblick/Heartbeat | AUFGABE | MEMORY.md:53 | GELANDET | -- |
| Zielgetriebene Autonomie -- Shells/Monitore beenden | AUFGABE | MEMORY.md:53 | GELANDET | -- |
| Nie AskUserQuestion verwenden (crasht Session) | REGRESSION | MEMORY.md:53 | BEHOBEN (Tool wird gemieden) | -- |
| Session-Transkripte enthalten Live-Tokens, nie committen | OWNER-ENTSCHEID | MEMORY.md:53 | GELANDET | -- |
| Wiederanlauf-Doktrin nach Session-Abriss | AUFGABE | MEMORY.md:54 | GELANDET | -- |
| Sessions rueckwaerts lesen, beide Repos, =5 | AUFGABE | MEMORY.md:54 | GELANDET | -- |
| Diplomarbeit-Impl-Session-Handover-Ort | UNKLAR | MEMORY.md:54 | GELANDET (Referenz) | -- |
| Doku-Policy neue Session: Docs+Ledger, nur User-Technik | AUFGABE | MEMORY.md:54 | GELANDET | -- |
| Kontext-Neugruendung Workflow-Backup-Ort | UNKLAR | MEMORY.md:54 | GELANDET (Referenz) | -- |
| NIE EINE FLOTTE GEBAUT (Identitaets-Umbauten) | REGRESSION | MEMORY.md:57 | OFFEN-REGRESSION (kostenlos nur bis 26.08., danach teuer; vor F2 ordnen) | -- |
| VERSIONIERUNG: SOLL je Stufe (CEB nur Mess+System) | FEATURE | MEMORY.md:58 | GEPLANT | -- |
| GLIEDER-REIHENFOLGE: ZWEI WELTEN (Lager vs. aussen) | FEATURE | MEMORY.md:59 | GEBAUT | S-6a, Task #15 |
| CACHE-LANDSCHAFT: LETZTES WORT (Runner lesen nur ccache+NAS) | OWNER-ENTSCHEID | MEMORY.md:60 | GELANDET | -- |
| LAGER-ORDNUNG != STUFEN-ORDNUNG (zwei Kaskaden) | FEATURE | MEMORY.md:61 | dokumentiert (D-12) | -- |
| STEMPEL-REIHENFOLGE: SYSTEM VOR ORGAN | FEATURE | MEMORY.md:62 | GEBAUT (seit S-6a/#15) | -- |
| GATTUNG+GENUS = Interface-Hierarchie (keine Achsen) | FEATURE | MEMORY.md:63 | GEPLANT/dokumentiert | -- |
| GENUS_impl Abstract Factory -> EIN Tier-Binary | FEATURE | MEMORY.md:63 | GEPLANT/dokumentiert | -- |
| NUR VIER BINARY-TYPEN (Planer/CEB/Tier/Hybrid, CEB traegt 8 Behelfs-CLIs) | FEATURE | MEMORY.md:64 | GEPLANT/dokumentiert | -- |
| HYBRID = eigene Gattung (Heuristik-Adapter, Reroute-Genus) | FEATURE | MEMORY.md:65 | GEPLANT | -- |
| Hybrid Owner-Entscheide 09.08. (vier Blocker) | OWNER-ENTSCHEID | MEMORY.md:65 | GELANDET | -- |
| SINGLE+HYBRID-Zweig symmetrisch nach Auswerten | FEATURE | MEMORY.md:65 | GEPLANT | -- |
| 18 ORGAN-ACHSEN (nicht 19) | FEATURE | MEMORY.md:66 | GEPLANT/dokumentiert | -- |
| KEINE flat_hash_map -- Swisstable Gattung-Map, nicht Container | OWNER-ENTSCHEID | MEMORY.md:66 | GELANDET | -- |
| 8-STATIONEN-KETTE dokumentiert, REAL SIND 15 STATIONEN | REGRESSION | MEMORY.md:66 | OFFEN-REGRESSION (Doku 8 vs. real 15, gemaess KON97) | -- |
| CT/Achsen/Gattung-Verweis (18 Eintraege) | UNKLAR | MEMORY.md:67 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- |
| Thesis-Verweis (Eigentum/Lizenz/HDR/DE fuehrt/Handwerk, 17 Eintraege) | UNKLAR | MEMORY.md:70 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- |
| PIPELINES STRENG SEQUENTIELL (sonst OOM) | OWNER-ENTSCHEID | MEMORY.md:73 | GELANDET | -- |
| LOKALE Maschine IST prod1 (kein dritter Host) | UNKLAR | MEMORY.md:74 | GELANDET | -- |
| prod1 = 16 Kerne/32 Threads (fruehere Annahme "24 Kerne" war falsch) | REGRESSION | MEMORY.md:74 | BEHOBEN (korrigiert auf 16/32) | -- |
| BASTION-ALIAS EXISTIERT NICHT | UNKLAR | MEMORY.md:75 | GELANDET (Workaround: ssh -i Cluster/keys/cluster root@10.0.10.201, pve1) | -- |
| References/Infra-Restverweis (-O0 vs Release, Cluster read-only, Infra+Vault) | UNKLAR | MEMORY.md:76 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- |
| MESS-PERMUTATION DYNAMISCH >32 (nie statische Nenner) | OWNER-ENTSCHEID | MEMORY.md:79 | GELANDET | nur S-19 rechnet |
| allow_failure VERBOTEN seit 06.07. (Zelle=Warnung, Job=rot) | OWNER-ENTSCHEID | MEMORY.md:80 | GELANDET | -- |
| Gesamte Pipeline immer hart gruen | OWNER-ENTSCHEID | MEMORY.md:80 | GELANDET | -- |
| Messung-Verweis E-Ebenen/CI-golden/Rueckschrieb (27 Eintraege) | UNKLAR | MEMORY.md:81 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- |
| Messung-Verweis Weitere (Mess-Visitor/Steuerkanal/Arenen/CSV) | UNKLAR | MEMORY.md:82 | GELANDET (Verweisziel MEMORY-DETAIL.md) | -- |
| MEINE Arbeitsfehler K1-K17 (Lead-Berichte nie uebernehmen) | REGRESSION | MEMORY.md:85 | BEHOBEN (Register gefuehrt) | -- |
| K11 PIPESTATUS | REGRESSION | MEMORY.md:85 | BEHOBEN | -- |
| K13 Koeder beisst | REGRESSION | MEMORY.md:85 | BEHOBEN | -- |
| K15 juengste KON+Bauplan (auch ~/backups-workflow) | REGRESSION | MEMORY.md:85 | BEHOBEN | -- |
| K16 Schreiberwechsel-Protokoll | REGRESSION | MEMORY.md:85 | BEHOBEN | -- |
| K17 Lande-Merge ohne Endstand-Kombibau (CI nie Erstpruefung) | REGRESSION | MEMORY.md:85 | BEHOBEN (Lehre gezogen; Sonderorder 20.08. verbraucht) | -- |
| ALLES IST GEPLANT (unloesbare Frage = eigene Luecke, 12W-Explore) | OWNER-ENTSCHEID | MEMORY.md:86 | GELANDET | -- |
| GEDAECHTNIS ZUERST (Gedaechtnis->Review->Explore->Design->Bau->Verify) | AUFGABE | MEMORY.md:87 | GELANDET | -- |
| EXPLORE PFLICHT je Welle+Strang | OWNER-ENTSCHEID | MEMORY.md:88 | GELANDET | -- |
| Explore 2-stufig (Sonnet5 max kartiert, dann selbst gegenlesen) | AUFGABE | MEMORY.md:88 | GELANDET | -- |
| 6+ parallele Straenge + ultracode immer frei (disjunkt) | OWNER-ENTSCHEID | MEMORY.md:89 | GELANDET | -- |
| DEFEKT = IMMER BEHEBEN (egal wie gross) | OWNER-ENTSCHEID | MEMORY.md:90 | GELANDET | -- |
| BLANKO-GO (alle Phasen autonom am Stueck, Melden != fragen) | OWNER-ENTSCHEID | MEMORY.md:90 | GELANDET | -- |
| Bestand invalidieren ist gewollt, kein Migrationszwang | OWNER-ENTSCHEID | MEMORY.md:90 | GELANDET | -- |
| RANGFOLGE OWNER > PLAN > THESIS (erst Ausschluss, dann MERGEN) | OWNER-ENTSCHEID | MEMORY.md:91 | GELANDET | -- |
| docs/termine ist die Primaerquelle | OWNER-ENTSCHEID | MEMORY.md:91 | GELANDET | -- |
| xlsx IST DIE AUSGABE (CSV nie Skip bei gleicher Binary) | OWNER-ENTSCHEID | MEMORY.md:92 | GELANDET | -- |
| Owner-KERNe 06.08. abends (Frist Messkette CEB) | OWNER-ENTSCHEID | MEMORY.md:92 | GELANDET | -- |
| LUECKE = BEHEBUNG PFLICHT (kein Randfall, kein Hinweis-statt-Ernst) | OWNER-ENTSCHEID | MEMORY.md:93 | GELANDET | -- |
| Behauptungen verifizieren, Layer-Vertraege halten | AUFGABE | MEMORY.md:94 | GELANDET | -- |
| "bis jemand anderes macht es" ist immer mein Auftrag | OWNER-ENTSCHEID | MEMORY.md:94 | GELANDET | -- |
| Claude Code Arbeitsweise v2 konsolidiert | AUFGABE | MEMORY.md:94 | GELANDET | -- |
| ASCII-only Kommentare + Selbstcheck-Zeile | AUFGABE | MEMORY.md:95 | GELANDET | -- |
| Par.61 Dual-Weg-Pflicht (Debug parallel Multi-Maschine) | OWNER-ENTSCHEID | MEMORY.md:95 | GELANDET | -- |
| E-21 TODO-Stack LIFO, verbose Owner-Fragen, Vollpersistenz | AUFGABE | MEMORY.md:95 | GELANDET | -- |
| Workflow-Backup SOFORT bei Fertigstellung | OWNER-ENTSCHEID | MEMORY.md:95 | GELANDET | -- |
| Stand-Anker sind HISTORIE -- lebender Stand = Ledger + super docs/sessions/ | OWNER-ENTSCHEID | MEMORY.md:98 | GELANDET | -- |
| DIFF-HYGIENE-Wache misst PUSH-lokal, nie kumulativ | AUFGABE | MEMORY.md:99 | GELANDET | -- |
| EIN GRUENES GATE deckt nur seinen Gegenstand (beide Mengen nennen) | AUFGABE | MEMORY.md:100 | GELANDET | -- |
| FALLEN-REGISTER Werkzeuge und CI (grep -v /build frisst /builder/) | REGRESSION | MEMORY.md:101 | OFFEN-REGRESSION | -- |
| ugrep ASCII-Gate stille Null (Falle) | REGRESSION | MEMORY.md:101 | OFFEN-REGRESSION | -- |
| LEERES pgrep != TOTER Hintergrundlauf | REGRESSION | MEMORY.md:102 | BEHOBEN (Lebendprobe=Log-Wachstum+Endmarke statt Prozessname) | -- |
| OV-NUMMERN KEIN Autoritaetsbeleg | REGRESSION | MEMORY.md:103 | BEHOBEN (Gegenstand im Roh-Transkript pruefen) | -- |
| VAULT-Dateien NIE greppen, nur blind verarbeiten | OWNER-ENTSCHEID | MEMORY.md:104 | GELANDET (mapfile, rueckwaerts bis HTTP 200) | -- |
| gitleaks-Koeder MUSS aus einer Regel der wirksamen Config stammen | REGRESSION | MEMORY.md:105 | BEHOBEN (glpat-+20 gilt, AWS beisst nicht) | -- |
| gitleaks push: Bereich statt geratener Klontiefe | REGRESSION | MEMORY.md:106 | BEHOBEN (stdin: --config PFLICHT) | -- |
| Fallen-Sammlung 08.08. (gitleaks/AWS/Codex/pgrep) | REGRESSION | MEMORY.md:106 | GELANDET (dokumentiert) | -- |
| Koeder-Literale in Commit-Texten maskieren (stdin-Wache triggert sonst) | AUFGABE | MEMORY.md:107 | GELANDET | -- |
| Transkript-Extraktor: DREI Pfade (Union aus 3 Quellen) | FEATURE | MEMORY.md:108 | GEBAUT | -- |
| MEMORY-DETAIL.md ausgelagert 10.08.2026 (MEMORY.md Lese-Limit 20.691/24.400 Byte) | UNKLAR | MEMORY-DETAIL.md:3-5 | GELANDET (nichts entfernt) | -- |
| C++/Drogon u.a. Sprachen sind Feature-Quellen | AUFGABE | MEMORY-DETAIL.md:8 | GELANDET | -- |
| Baseline-System in Stein gemeisselt (Layering) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:8 | GELANDET | -- |
| Umbrella-SOLL-Struktur trackt alles ausser Baseline-Zellen | FEATURE | MEMORY-DETAIL.md:8 | GEPLANT | -- |
| Standardprozess-Research zu Product-Matrix 3D | AUFGABE | MEMORY-DETAIL.md:8 | GEPLANT | -- |
| Vendoring-Doktrin: ordered vendor, faithful, selfcontained | OWNER-ENTSCHEID | MEMORY-DETAIL.md:8 | GELANDET | -- |
| ext/-Paper-Organisation trennt Achsen von Paper-Code | FEATURE | MEMORY-DETAIL.md:8 | GEPLANT | -- |
| Kein Python in der Buildchain | OWNER-ENTSCHEID | MEMORY-DETAIL.md:8 | GELANDET | -- |
| 8er-Docker Build-Matrix (volle Plattform-Doktrin) | FEATURE | MEMORY-DETAIL.md:8 | GEPLANT | -- |
| buildsystem.xml haende-weg, parallel CI/CMake | OWNER-ENTSCHEID | MEMORY-DETAIL.md:8 | GELANDET | -- |
| PRT-ART konsumiert Cache-Engine (3 Rollen) | FEATURE | MEMORY-DETAIL.md:8 | GEPLANT | -- |
| 286 = Forschung (Cache-Engine-Research vs. CacheEngine-all Split-TODO) | AUFGABE | MEMORY-DETAIL.md:8 | OFFEN | -- |
| Diplomarbeit-Module-Spiegel geloescht, comdare-Module wiederverwenden | REGRESSION | MEMORY-DETAIL.md:8 | BEHOBEN | -- |
| Kette Par.38 (Planer->Mess->CEB->System->Tier->Organ->Hybrid) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| Recursive Dock .so (Planer/CEB/Tier ABI-stabil) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| Registry=ANGEBOT (Anwender-XML, POM-Resolver, Planer) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| 2 Registry (unified experiment.xml + system-registry.xml) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| CMake PRT (Interface static, Registry-Pfade, PRT-Modul) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| flach=Baum (flat SystemAxis-Ordner, deep Tier-Tree, dynamic-only Columns) | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| Tier-Binary incremental Caching | FEATURE | MEMORY-DETAIL.md:11 | GEPLANT | -- |
| Cache-Engine Standalone-Build-Pipeline | FEATURE | MEMORY-DETAIL.md:14 | GEPLANT/GEBAUT | -- |
| XML Kommentar Doppelbindestrich-Falle | REGRESSION | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- |
| Drift-Wache faengt Anhaengen nicht (Luecke) | REGRESSION | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- |
| git -C immer mit Pfad, cwd-Falle | REGRESSION | MEMORY-DETAIL.md:14 | BEHOBEN (Regel etabliert) | -- |
| Codex UTF8 Mojibake Double-Encoding | REGRESSION | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- |
| Documentation Master-Paths | UNKLAR | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- |
| GitLab PAT-Format Punkte-Regex | UNKLAR | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- |
| GitLab .de abgeschaltet, .local kanonisch (scoped CA) | REGRESSION | MEMORY-DETAIL.md:14 | BEHOBEN (umgestellt) | -- |
| Cluster VLAN-Tabelle SNI-Standard-Pattern | UNKLAR | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- |
| prod1 comdare Env-Setup | UNKLAR | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- |
| CI-Runner ICE Cold-Cache-Instabilitaet | REGRESSION | MEMORY-DETAIL.md:14 | OFFEN-REGRESSION | -- |
| Infra-Agent Memory-Handover 322 Location | UNKLAR | MEMORY-DETAIL.md:14 | GELANDET (Referenz) | -- |
| Desktop Plain-Backup Diplomarbeit | AUFGABE | MEMORY-DETAIL.md:14 | GELANDET | -- |
| main-FF Watcher pinnt SHA, nicht rev-parse HEAD | REGRESSION | MEMORY-DETAIL.md:14 | BEHOBEN | -- |
| Freeze-Nachrichten eindeutig, nur Antwort vs. Arbeitsauftrag | AUFGABE | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Task-Zuweisung ist kein Start-Signal, Gates respektieren, zuerst vorschlagen | OWNER-ENTSCHEID | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Agent-Working-Tree-Freeze nach Paketmeldung | AUFGABE | MEMORY-DETAIL.md:17 | GELANDET | -- |
| User-KERN-Beschreibung ist immer Gesetz, Abweichung ist Regression | OWNER-ENTSCHEID | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Autonomie-Modus: Plan autonom durchziehen | OWNER-ENTSCHEID | MEMORY-DETAIL.md:17 | GELANDET | -- |
| VOR+NACH jeder Aufgabe ultracode plus Autonomie-Scope | AUFGABE | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Jede Aufgabe ultracode-Planungssession, Ledger, alle Plandocs | AUFGABE | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Per Paket ultracode-Planung vor Ausfuehrung | AUFGABE | MEMORY-DETAIL.md:17 | GELANDET | -- |
| Statischer Dispatch, kein Runtime-Switch | OWNER-ENTSCHEID | MEMORY-DETAIL.md:20 | GELANDET | -- |
| Codegen compile-time-only, kein Runtime | OWNER-ENTSCHEID | MEMORY-DETAIL.md:20 | GELANDET | -- |
| CRTP+Concept-Guard-Mix-Pattern | FEATURE | MEMORY-DETAIL.md:20 | GEPLANT | -- |
| Nur GoF-Lehrbuch-Design-Patterns, Zero-Cost-Metaprog | OWNER-ENTSCHEID | MEMORY-DETAIL.md:20 | GELANDET | -- |
| MOF Meta-driven Concept-Hardening-Pattern | FEATURE | MEMORY-DETAIL.md:20 | GEPLANT | -- |
| Metaprogrammierung compile-time zwingend durchsetzen (CT->RT) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:20 | GELANDET | -- |
| Kein std::variant, statische Achsen-Bloat vermeiden | OWNER-ENTSCHEID | MEMORY-DETAIL.md:20 | GELANDET | -- |
| Haupt-Achse static/Unter-Achse runtime, Chain CT-Wiring | FEATURE | MEMORY-DETAIL.md:21 | GEPLANT | -- |
| Achsen-Thema/Modul/Framework/Metaprogramming/Interface (Kopf-Framework) | FEATURE | MEMORY-DETAIL.md:21 | GEPLANT | -- |
| Keine Whole-Tier-Achsen, Genus-Configurator | OWNER-ENTSCHEID | MEMORY-DETAIL.md:21 | GELANDET | -- |
| Systemachsen-Freigabe, Organachsen-Durchsetzung/Ressourcen | FEATURE | MEMORY-DETAIL.md:21 | GEPLANT | -- |
| Fehlerklassen Pflicht fuer alle Achsen/Unterachsen/Algorithmen | OWNER-ENTSCHEID | MEMORY-DETAIL.md:21 | GELANDET | -- |
| Q2 Option C Erweiterungshardware = sechste Systemachse | OWNER-ENTSCHEID | MEMORY-DETAIL.md:21 | GELANDET | -- |
| Compiler-Systemachse traegt dynamische XML-Unterachsen | FEATURE | MEMORY-DETAIL.md:21 | GEPLANT | -- |
| AP15 Container-Gattung comdare-Container-Sequence-Plan (Interface-Familie) | FEATURE | MEMORY-DETAIL.md:22 | GEPLANT | -- |
| Gattung eigenes Genus, eigenes ABI, nonintersecting mutually usable | OWNER-ENTSCHEID | MEMORY-DETAIL.md:22 | GELANDET | -- |
| Command-Pattern Achsen-Mess-Visitor Container in SA | FEATURE | MEMORY-DETAIL.md:22 | GEPLANT | -- |
| Observable-Wrapper muss Concept-Members forwarden (Falle) | REGRESSION | MEMORY-DETAIL.md:22 | OFFEN-REGRESSION | -- |
| E1-E4 Experiment-Maschinerie und Konsolidierung | FEATURE | MEMORY-DETAIL.md:25 | GEPLANT | -- |
| E4-XML autoritative Bauanleitung, CEB orchestriert | FEATURE | MEMORY-DETAIL.md:25 | GEPLANT | -- |
| Organ/System-Achsen Measurement eigene abstrakte Root (Blood) | FEATURE | MEMORY-DETAIL.md:25 | GEPLANT | -- |
| E-Schichten separat fertigstellen, top-down | AUFGABE | MEMORY-DETAIL.md:25 | GELANDET | -- |
| Max. Tiefe bei Problemen, saubersten Zustand | AUFGABE | MEMORY-DETAIL.md:25 | GELANDET | -- |
| Elaborate Dossier fuer komplexe Planung | AUFGABE | MEMORY-DETAIL.md:25 | GELANDET | -- |
| Axes-Optimization-Semantics Deep-Research Observer-Strategy (Min/Max) | FEATURE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| Heuristik-Messkurven-Typsystem Chain-of-Responsibility | FEATURE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| CEB drei Modi Arbeitsmodus Hot-Tier-Switching | FEATURE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| Measurement-Modes Debug=parallel, Measure=singlethread, Planer generiert CI/CMake | FEATURE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| Measurement-Failure-Visibility: Fehler->CSV failed, nicht null, plus Log | FEATURE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| Mess-Tooling Default vereint EINE CEB | OWNER-ENTSCHEID | MEMORY-DETAIL.md:26 | GELANDET | -- |
| New golden all axes XML >320 (golden 2^17) | AUFGABE | MEMORY-DETAIL.md:26 | GEPLANT | -- |
| CI-Gesamtlauf ist Messung abgeschaltet, PDF kompiliert | OWNER-ENTSCHEID | MEMORY-DETAIL.md:27 | GELANDET | -- |
| Autonomous Measurement via CI-Job autorisiert | OWNER-ENTSCHEID | MEMORY-DETAIL.md:27 | GELANDET | -- |
| Production-Track voller Golden-Run findet Fehler | FEATURE | MEMORY-DETAIL.md:27 | GELANDET | -- |
| CI gruen messfaehig nur bei punktuellen Refactorings | AUFGABE | MEMORY-DETAIL.md:27 | GELANDET | -- |
| Increments muessen architekturkonform sein, nicht nur gruen | OWNER-ENTSCHEID | MEMORY-DETAIL.md:27 | GELANDET | -- |
| Mess-Ergebnis-Rueckschreibung-Pipeline persistiert (WRITE-Token) | FEATURE | MEMORY-DETAIL.md:28 | GEPLANT/GEBAUT | -- |
| Measurement-Writeback-Token 288 secure (Token 54) | UNKLAR | MEMORY-DETAIL.md:28 | GELANDET (Referenz) | -- |
| super-CI kann neue CE-Submodule-Commits nicht fetchen (Deploy) | REGRESSION | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION | -- |
| Tier-Metaphor System-Axis-Properties, Graph=PHANTOM | REGRESSION | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION (Graph existiert nur als Phantom) | -- |
| CE-Facade Super-Subbuild verify+clang-format prod1-Gap (~15 vendored) | REGRESSION | MEMORY-DETAIL.md:28 | OFFEN-REGRESSION | -- |
| Selbst implementieren ab 10.07., Codex abgeloest | OWNER-ENTSCHEID | MEMORY-DETAIL.md:29 | GELANDET | -- |
| Alt-Golden darf brechen, erst additiv, dann aufraeumen unter Absprache | OWNER-ENTSCHEID | MEMORY-DETAIL.md:29 | GELANDET | -- |
| Dual-Verifikation Baremetal lokal+CI synchron gruen | AUFGABE | MEMORY-DETAIL.md:29 | VERTAGT (GEPARKT) | -- |
| Autonomous-Overnight-Note offene Entscheidungen fuer Morgen | AUFGABE | MEMORY-DETAIL.md:29 | VERTAGT (Schlaeft) | -- |
| Vortrag nach Abgabe, technischer Hintergrund zuerst | AUFGABE | MEMORY-DETAIL.md:32 | GEPLANT | -- |
| Thesis Habich-Restruktur allgemein->speziell | AUFGABE | MEMORY-DETAIL.md:32 | GELANDET | -- |
| Thesis-LaTeX-Struktur bilingual (DE+EN) | FEATURE | MEMORY-DETAIL.md:32 | GEPLANT | -- |
| Thesis-Kernbeitrag = Achsen-Library | UNKLAR | MEMORY-DETAIL.md:32 | GELANDET (Referenz) | -- |
| Thesis Design-Space Fachvokabular (Idreos) | UNKLAR | MEMORY-DETAIL.md:32 | GELANDET (Referenz) | -- |
| Thesis universelle Baum-Anatomie und Prinzipsuche | FEATURE | MEMORY-DETAIL.md:32 | GEPLANT | -- |
| Diplomarbeit-Design ist Quelle der Implementierung (LaTeX=Quelle) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:32 | GELANDET | -- |
| Thesis nur User-Ideen persistieren | OWNER-ENTSCHEID | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Thesis linear, Aufgabenstellung, keine Loesung vorweg | OWNER-ENTSCHEID | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Thesis Sequential-Referencing-Regel (Verweis rueckwaerts) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Thesis Tabellen-Legende-Notiz unter Float | AUFGABE | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Thesis Divide-and-Conquer (XX_op) | AUFGABE | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Text-Agent-Sessions gehoeren in Thesis, nicht Impl-Repo | OWNER-ENTSCHEID | MEMORY-DETAIL.md:33 | GELANDET | -- |
| Thesis Git-Topologie Remotes+Overleaf | UNKLAR | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- |
| TUD Informatik Thesis-Format-Norm | UNKLAR | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- |
| Thesis-Achsen T-IDs vs. Dir-Numbers | UNKLAR | MEMORY-DETAIL.md:34 | GELANDET (Referenz) | -- |
| Thesis-Build-Check .blg AlphaDIN | AUFGABE | MEMORY-DETAIL.md:34 | GELANDET | -- |
| Post-v3-Anforderungen SO/ABI/Driver-Split/CLI | FEATURE | MEMORY-DETAIL.md:37 | GEPLANT | -- |
| Planer-Mess-Schema Kern/Pruefling Replace/Merge/Fulljoin | FEATURE | MEMORY-DETAIL.md:37 | GEPLANT | -- |
| Par.62 Planer Universal Cache Log Claim Compare | FEATURE | MEMORY-DETAIL.md:37 | GEPLANT | -- |
| Bestandslog-Zielbild Ordner-Kaskaden Dual-ccache | FEATURE | MEMORY-DETAIL.md:37 | GEPLANT | -- |
| Bestandslog-Abnahmen Baum-Heuristik-Stempel | FEATURE | MEMORY-DETAIL.md:37 | GEPLANT | -- |
| Lager-Baeume xlsx-Doktrin | OWNER-ENTSCHEID | MEMORY-DETAIL.md:37 | GELANDET | -- |
| Achsen-Neuordnung bindende Sortierung, Regressionen | OWNER-ENTSCHEID | MEMORY-DETAIL.md:37 | GELANDET | -- |
| Diplom finale Linie, Identitaet, Overleaf | UNKLAR | MEMORY-DETAIL.md:37 | GELANDET (Referenz) | -- |
| EIGENTUM: ZWEI ENTITAETEN (Thesis=BEP privat, CE+PRT-ART=BEP Venture UG); Abk. "BEP" fuer Person VERBOTEN | OWNER-ENTSCHEID | MEMORY-DETAIL.md:43 | GELANDET | -- |
| LIZENZ je Repo (super=Apache, ce+PRT-ART=Forschung frei/proprietaer, Diplomarbeit=nur Copyright BEP) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:44 | GELANDET (10.08.) | -- |
| HDR = Thesis-Zusage (3 Praesens-Stellen) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:45 | GELANDET | -- |
| DE FUEHRT IMMER, EN zieht nach (Lint via chktex NN) | OWNER-ENTSCHEID | MEMORY-DETAIL.md:45 | GELANDET | -- |
| LOKAL -O0 gegen CI Release -- Beobachtbarkeits-Luecke | REGRESSION | MEMORY-DETAIL.md:52 | OFFEN-REGRESSION (Koeder wuerfeln auf beiden Stufen) | -- |
| Diplomarbeit-Impl-Agent: Cluster read-only, keine Infra | OWNER-ENTSCHEID | MEMORY-DETAIL.md:53 | GELANDET | -- |
| Infra immer ultracode ueber Sessions zuerst | AUFGABE | MEMORY-DETAIL.md:53 | GELANDET | -- |
| Infra-Autonomie-Freigabe, Cluster reserviert | OWNER-ENTSCHEID | MEMORY-DETAIL.md:53 | GELANDET | -- |
| CI/Infra blockiert -> lokal weiter, Doppel-Verify Mode A | AUFGABE | MEMORY-DETAIL.md:53 | GELANDET | -- |
| MESS-VISITOR am Genus-Interface (Sidecar ist falsch) | FEATURE | MEMORY-DETAIL.md:59 | GEPLANT | -- |
| Variadische Mess-Template nicht durch die Kaskade gereicht | REGRESSION | MEMORY-DETAIL.md:59 | OFFEN-REGRESSION (kein Signal im Tier-Binary) | -- |
| Steuerkanal Planer-CEB, sechs Steuerdocks variadisch | FEATURE | MEMORY-DETAIL.md:60 | GEPLANT (Release GESAMMELT) | -- |
| MeasureStorage-Modul Custom-Arena, append-measure-to-latex (ZWEI Arenen) | FEATURE | MEMORY-DETAIL.md:60 | GEPLANT | -- |
| Drift-Gate = 18x Durchlaeufe je Zelle-Kapazitaet | FEATURE | MEMORY-DETAIL.md:61 | GEPLANT | -- |
| CSV ist Strategy-Pattern der xlsx-Erzeugung (Richtung xlsx->csv) | FEATURE | MEMORY-DETAIL.md:61 | GEPLANT | -- |
| Task-Board-Dump Header: VOLLSTAENDIG 106 Tasks (Stand 20.08. ~15:30Z) | UNKLAR | task_board_dump.md:1-2 | GELANDET (Selbstauskunft der Quelle) | -- |
| #3 S-12 CI-Geruest (4 Traegerstufen-Mini-Pipelines gcc+clang x Release+Debug) | AUFGABE | task_board_dump.md:5 | OFFEN (Landung Di 25.08.) | KON55/T-11b, Vorbau @731b5655 |
| #7 S-19 Planungs-Simulation (produziert B-4-Zahl) | AUFGABE | task_board_dump.md:6 | OFFEN (Sa 22.-Mo 24.08., frei seit #15/#17) | -- |
| #13 T-15b-Umzug (Mess-Fenster Sa/So) | AUFGABE | task_board_dump.md:7 | OFFEN (binary-beruehrend vor Trigger) | -- |
| #18 S-13 Export-Element+Ziel-Filter+per-Binary-XLSX | AUFGABE | task_board_dump.md:8 | OFFEN (Di 25.08., engster Slot; KON32-01) | -- |
| #19 main-FF beider Repos | AUFGABE | task_board_dump.md:9 | OFFEN (Blocker #31 completed, kumulative Hygiene davor, volle SHA) | -- |
| #22 OD-7 --debug-CLI-Haelfte (mit S-8 in W2) | AUFGABE | task_board_dump.md:10 | IN_PROGRESS | -- |
| #24 Mess-Schalter B1-B5 | AUFGABE | task_board_dump.md:11 | OFFEN (B3 Owner-Datum vor F2, B5 nach S-5/KON119, B1 W1-Ende, B4=W2/OF-1) | -- |
| #24-B2 Mess-Schalter B2 | AUFGABE | task_board_dump.md:11 | GELANDET | -- |
| #28 TEST-KONSOLIDIERUNG (KON37-08) | AUFGABE | task_board_dump.md:12 | OFFEN (Dauerposten mit S-16 bis W4) | -- |
| #38a2 Comp-Gate-Stempel | AUFGABE | task_board_dump.md:13 | UNKLAR (im Bump-Buendel gelandet? -> Audit noetig) | -- |
| #38a3 IO-Vollausbau | AUFGABE | task_board_dump.md:13 | OFFEN (W7) | -- |
| #38b Warmup-Paar | AUFGABE | task_board_dump.md:13 | OFFEN (W2 Sa/So) | -- |
| #38d Budget | AUFGABE | task_board_dump.md:13 | GELANDET (im Bruch gelandet) | -- |
| #40 ULTRACODE-NACHIMPLEMENTIERUNG (38 NE-Posten/20 Auftraege) | AUFGABE | task_board_dump.md:14 | OFFEN | -- |
| #40 NE-01-Zahlenkorrektur | OWNER-ENTSCHEID | task_board_dump.md:14 | GELANDET (bindend) | -- |
| #48 XML-PUBLIKATIONS-SEKTION (4 Klassen) | AUFGABE | task_board_dump.md:15 | OFFEN (Di 25.08., mit #18/#57) | -- |
| #49 Staffelungs-Design-Dokument | AUFGABE | task_board_dump.md:16 | OFFEN (VOR W4, nach Owner-V7-Antwort) | -- |
| #49 C1-Widerspruch | OWNER-ENTSCHEID | task_board_dump.md:16 | OFFEN (wartet auf Owner) | -- |
| #53 DESIGN MESS-ACHSEN-FAMILIE | FEATURE | task_board_dump.md:17 | IN_PROGRESS (PMC-Schwester-Design zuerst, dann Lastsequenz; Owner-Vorlage je Achse vor Bau) | -- |
| #57 LAGER-VOLLAUSBAU (6 Punkte) | AUFGABE | task_board_dump.md:18 | OFFEN (Owner 15.08. "ALLE schliessen"; Di 25.08. mit #18/#48) | -- |
| #65 PRT-ART Nachstufe | AUFGABE | task_board_dump.md:19 | IN_PROGRESS (Rest: 10W-Planungs-Explore+Aufraeumen+V1-Diskrepanz) | -- |
| #69 #41-Nachlauf Messwert-Rohbefund 750-vs-1310 | REGRESSION | task_board_dump.md:20 | OFFEN-REGRESSION (Diskrepanz, prod2-TeX-Probe aussteht) | -- |
| #71 Triage-Sammelposten Leser-Hebungen | AUFGABE | task_board_dump.md:21 | OFFEN (KON-15/43/44 + machines + concurrency-Vorlage) | -- |
| #74 Repo-Rollen-Umbau F6 | AUFGABE | task_board_dump.md:22 | OFFEN (W-G-Karte liegt, 15 CE-Kandidaten) | -- |
| #77 THESIS-AUDIT-EINARBEITUNG Runde 1 | AUFGABE | task_board_dump.md:23 | OFFEN (nach F2 Fr 21.08.) | -- |
| #82 I-PMC-2/3 bauen | AUFGABE | task_board_dump.md:24 | OFFEN (Owner-GO 17.08.; Vorstaffel WE 22./23.) | -- |
| #83 PMC fail-loud-Paket | AUFGABE | task_board_dump.md:25 | OFFEN (Owner-GO 17.08.; eigener Zug vor Trigger 26.08.) | -- |
| #84 Infra-Rotation | AUFGABE | task_board_dump.md:26 | OFFEN (wartet auf Wartungsfenster, vor Mi 26.!) | -- |
| #85 Nachzugs-Paket Voll-Lesung 17.08. | AUFGABE | task_board_dump.md:27 | OFFEN (D-2-Vorlage Spline-Trias, Ledger-Korrekturen, docs-Zug, X-3) | -- |
| #86 ORG-19-IO anlegen+einbinden+T19-Katalog-Zeile+E-1/Thesis-Textzug | AUFGABE | task_board_dump.md:28 | OFFEN (Owner-GO 17.08.) | -- |
| #87 Talos-Lane D-5 (Debug-Messung mit Core-PMC) | AUFGABE | task_board_dump.md:29 | OFFEN (Voraussetzung Talos v1.13.x, Infra) | -- |
| #88 KON110-Posten (Parameter-Filter-Registry RF-B+Deep-Research+Lager-Typ 3+4+Hybrid-ML+kleine Hybride) | AUFGABE | task_board_dump.md:30 | OFFEN | -- |
| #89 P-H Paper->Prueflinge+Ledger-#44/PV-4-Bau | AUFGABE | task_board_dump.md:31 | OFFEN (mit #18/S-13) | -- |
| #90 P-A Kanalwerk-/Arena-Designplan | AUFGABE | task_board_dump.md:32 | OFFEN (Fable max, W1->vor Trigger, #53-Umfeld) | -- |
| #91 Unifikations-Designplan CEB-Modulsteuerung | AUFGABE | task_board_dump.md:33 | IN_PROGRESS (Design KOMPLETT/design91-v2 GELANDET @0778c6ef, Verbuchung offen; Identitaets-Entscheide vor Mi 26.) | -- |
| #94 C-F4 Abi7-Historien-Freeze kapseln | AUFGABE | task_board_dump.md:34 | OFFEN (decl.hpp, W2/W) | -- |
| #96 WIEDERAUFNAHME-Vollzug Dauer-Register | AUFGABE | task_board_dump.md:35 | OFFEN (Feinplatzierung aller Vertagten, Di-25-Schnitt naechste Pflichtinstanz) | -- |
| #97 C-13 Skip-Oekonomie+C-14 Bestandslog-SKIP-Wache | AUFGABE | task_board_dump.md:36 | OFFEN (vor Kampagne Sa 29.08.) | -- |
| #98 F-07b 2D+3D-Diagramm-Bau | FEATURE | task_board_dump.md:37 | OFFEN (W4) | -- |
| #98 Wellenplan-Par.5-Arithmetik-Korrektur | REGRESSION | task_board_dump.md:37 | OFFEN-REGRESSION | -- |
| #99 B-5f Tooling-Ordnungs-Validierung (an allen drei Stellen) | AUFGABE | task_board_dump.md:38 | OFFEN (Di-25) | -- |
| #103 TSan-VOLLAUSBAU eigene Objektklasse | FEATURE | task_board_dump.md:39 | OFFEN (build-tsan braucht Neubau) | -- |
| #105 NP-24+W2-Miniposten-Trio(A9/A10/A11)+X-12-Bau+HDR-Verdrahtung | AUFGABE | task_board_dump.md:40 | OFFEN (Di-25) | -- |
| #106 CI-DUAL-COMPILER-VOLLAUSBAU | AUFGABE | task_board_dump.md:41 | IN_PROGRESS (Fix-Design+Landung Di-25 mit #3) | Owner-KERN 20.08. |
| #106-Erhebung: nur 9/41 Jobs dual-compiled, 13/23 Konfigurationen nie clang | REGRESSION | task_board_dump.md:41 | OFFEN-REGRESSION (Erhebung komplett, Fix-Raenge 1-10 priorisiert) | -- |
| #1 WF1 KON23 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #2 WF2 KON20 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #39 (fehlt im Dump) | UNKLAR | task_board_dump.md (Luecke, weder pending noch completed) | OFFEN (nicht auffindbar trotz "106 Tasks"-Kopfzeile) | -- |
| #4 S-7 gelandet | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #5 Frage10 KON17-04 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #6 WF3 KON22 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #8 WF4 KON26 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #9 Referenz-Konsolidierung KON39 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #10 MinIO-Keys geheilt | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #11 Durchstich CI (##25) | AUFGABE | task_board_dump.md:44 | CI-BEWIESEN | -- |
| #12 WF5 KON29 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #14 ce-CI 15751 gruen | AUFGABE | task_board_dump.md:44 | CI-BEWIESEN | -- |
| #15 BUMP-BUENDEL komplett (W1-Schlussstein, 16042-16052) | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #16 golden-Fenster CI 15937 | AUFGABE | task_board_dump.md:44 | CI-BEWIESEN | -- |
| #17 G-2 gelandet | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #20 Flaeche-3 KON116 | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #21 E-Block | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #23 WF6 KON34 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #25 WF7 KON36 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #26 ultracode-Planung KON39 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #27 E-Warmup KON45 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #29 Zielstruktur 85c1174d | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #30 S-1 gelandet | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #31 13-Branches-Triage | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #32 Fixup S-1/C | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #33 S-14a | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #34 #22-Q6 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #35 Fixup2 | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #36 Fixup3 | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #37 Wellen-Plan-Schnitt | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #41 F1 geliefert KON63 | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #42 P6 Lizenz | OWNER-ENTSCHEID | task_board_dump.md:44 | GELANDET | -- |
| #43 #81-Wiederhol-Verify | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #44 Drei-Stufen-Landung+F1 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #45 BU-Workflow | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #46 Freigaben A2+A4 | OWNER-ENTSCHEID | task_board_dump.md:44 | GELANDET | -- |
| #47 A1 Writeback-Token | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #50 D12 | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #51 Umbrella-CI | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #52 GitLab-Vorstrecke | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #54 Rotations-Turnus dormant | FEATURE | task_board_dump.md:44 | GELANDET (dormant) | -- |
| #55 xlsx-Aufmachung | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #56 Lande-Zug CI-Dual+Lizenz | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #58 Lande-Zug2 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #59 Vorlagen-Runde 15.08. | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #60 Flotten-Runner | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #61 Thesis-Trailer-Rewrite | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #62 15-Branches | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #63 helm-Upgrade | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #64 Zombie-Cancel | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #66 Randbestand | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #67 Thesis-Sync KON77 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #68 Folge-BU | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #70 XorFilter KON116 | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #72 queuing-Umzug | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #73 helm-Nachlauf | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #75 W-A/W-B | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #76 Wo-stehen-wir-Session | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #78 KON97/98 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #79 super-15941-Heilung | REGRESSION | task_board_dump.md:44 | BEHOBEN | -- |
| #80 HY-A | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #81 Vorlauf-Welle | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #92 P-G/S-22 KON117 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #93 W1-Audit | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #95 V-08R (16045) | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #100 tools-3-Format | FEATURE | task_board_dump.md:44 | GELANDET | -- |
| #101 W2-1 Bytevergleich | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #102 golden-Zug F6 | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| #104 prt-art-Pin (16048) | AUFGABE | task_board_dump.md:44 | GELANDET | -- |
| Welle 1 formal KOMPLETT (#15 completed, alle CIs SUCCESS) | AUFGABE | task_board_dump.md:46 | CI-BEWIESEN (ce 66de5c09, super e674d0be, prt-art 777fff7) | KON119=Ledger-Kopf |
| Freeze-Check F2 | AUFGABE | task_board_dump.md:46 | OFFEN (MORGEN Fr 21.08.) | -- |
| Bau-Trigger | AUFGABE | task_board_dump.md:46 | GEPLANT (Mi 26.08. 06:00) | -- |
| Kampagne | AUFGABE | task_board_dump.md:46 | GEPLANT (Sa 29.08.) | -- |
| Abgabe (Thesis-Deadline) | AUFGABE | task_board_dump.md:46 | GEPLANT (Di 15.09.) | -- |

---
Extraktion abgeschlossen: 404 Posten-Zeilen aus 3 Quellen (MEMORY.md 108/108 Z., MEMORY-DETAIL.md 62/62 Z., task_board_dump.md 46/46 Z. -- alle Zeilen mindestens einmal gesehen). Klassen: AUFGABE 161, OWNER-ENTSCHEID 96, FEATURE 71, REGRESSION 49, UNKLAR 27.
