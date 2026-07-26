# DOSSIER: GESAMTSTAND DER MANAGER-SESSION 26.07.2026 (Kompaktierungs-Anker)

> ZWECK: Vollstaendiges Session-Gedaechtnis vor einem Kontext-Compact (API-Erholung nach
> Compact ist die Regel). Nach dem Compact: DIESES Dossier + MEMORY.md-Index + Board =
> voller Wiedereinstieg ohne weiteren Kontext. ALLES hier ist verifizierter Stand bzw.
> woertlicher Owner-KERN. ASCII bis auf Paragraph-Zeichen.
> AUTORITAETS-KETTE bei Widerspruch: Owner-KERN-Beschreibung > dieses Dossier > aeltere
> Session-Docs > Bauplaene > Ist-Code.
> LESE-REIHENFOLGE Kalt-Start: (1) dieses Dossier; (2) 20260726-SESSION-layer-modell-
> antworten-QA-QF-stempel-doktrin.md; (3) 20260726-SESSION-achsen-neuordnung-lager-baeume-
> xlsx-regressionen.md; (4) backups/20260726-explore-q3-klammerung/REPORT-hinweis.md;
> (5) HANDOVER-6; (6) MEMORY.md Abschnitt "Achsen-Neuordnung + finale Linie".

===============================================================================
## 0. STAND IN FUENF SAETZEN
===============================================================================
1. Das Lager-Gate (Bestandslog-Ertuechtigung) ist KOMPLETT gebaut, gepusht und CI-relevant
   gruen (ce ..e3a0c6ff auf beiden Remotes; +2 lokale Commits 0cb1902a/42b34354 warten auf
   die Org18-Join-Welle).
2. STRUKT-R (Achsen-Neuordnung + 18. Organ-Achse persistence_target) laeuft mid-flight:
   ORG-18 B-1..B-14 fertig+verifiziert (18 Slots, POD 1344/v8, ABI-Major 7/Magic .A7., neuer
   golden-CRC 0x56F1B721C72DC10E), B-15 (golden-Neuanker) am TABU-Gate; MODE (COMPARE) fertig;
   (d2)/planer_block fertig inkl. E2E-Beweis. Offen: Lane A (SYS-TAX), Lane C (Ident), Lane F
   (W-13-Suffix).
3. ALLE Owner-Entscheide des Tages sind eingeholt und persistiert: Bestandslog-Abnahmen 1-6 +
   A-1/A-2, STRUKT-R Q-0..Q-14, Layer-Modell Q-A..Q-F, Stempel-Klammer-Hierarchie Ebene 0-3.
4. Der Giga-Scrub ist ABGESCHLOSSEN: Infra hat die 4 Diplom-Repos gescrubbt+identity-
   normalisiert; prod1 adoptiert; finale Linie super e542effb.. / ce ce81ec62.. ; Identitaet
   ueberall benjamineliasprobst@gmail.com; offen nur overleaf-Merge (Board #2) + public-Schaltung.
5. Naechster Meilenstein: Org18-B-15-Paket -> Join -> Lane A/C/F -> W-13 -> 4 Beweise ->
   Voll-Bau-4-Trigger (2^17, Bestandslog AN). Frist Mo 27.07. = ZWISCHEN-Abgabe (Gruendlichkeit
   vor Termin, Verzug begruendbar). Voll-Messung 2^17 ab 01.08.

===============================================================================
## 1. PROJEKT / ROLLEN / UMGEBUNG
===============================================================================
- Diplomarbeit TU Dresden (Prof. Habich): Cache-Engine-EXPERIMENT-SYSTEM. Kern = Achsen-
  Library; compile-time-Permutationsraum ~1.4e14 Tier-Binaries, gefahren ueber die Kette
  Experiment-Planer -> CEB (Cache-Engine-Builder) -> Tier-Binary (+Hybrid).
- ROLLEN: Fable (ich) = Architekt/Manager: Decomposition, Entscheide, Abnahme (diff-stat
  literal + eigener ctest + literale Ausgaben), granulare Commits, Dual-Push, CI-Gruen.
  Opus-Agenten = Implementierung. Je Scheibe: ultracode-Planung -> Impl -> Manager-Abnahme ->
  Commit -> Dual-Push.
- REPOS (4 Diplom-Repos, alle research/): super = probst-diplomarbeit-cache-engine (BASE/
  Umbrella, Projekt 288) ce = comdare-cache-engine (Submodul Code/external/, Projekt 286)  
  comdare-prt-art (Pruefling) 20260931-overleaf-diplomarbeit (Thesis, Submodul thesis/ +
  Code/external/, Overleaf-gekoppelt).
- FINALE LINIE nach Giga-Scrub (26.07.): super e542effb / ce ce81ec62 / prt-art 32e8ffa8
  (dev==main, Laptop=node7=gitlab=github). IDENTITAET Diplom-Repos einheitlich
  "Benjamin-Elias Probst <benjamineliasprobst@gmail.com>" (pruefungsrechtlich; lokale
  git-config in ALLEN 5 Repos gesetzt - bei neuen Klonen zuerst setzen). Backups PRE-IDENTITY/
  PRE-SCRUB auf backup2-NFS+prod1, backup-Refs auf Laptop/node7 - NIE loeschen.
- MASCHINEN: prod1 (AMD Zen5, 24 Threads gedrosselt) + prod2 (Intel Raptor Lake) + node7/Cluster.
  Root-Wege: admin-management@localhost(prod1,NOPASSWD) / @10.0.10.212(prod2) / root@10.0.10.201
  (pve1->kubectl/Rails). GitLab-Runner concurrency=1 (Mess-Schutz, gewollt seriell).
- SECURITY (dauerhaft): PAT via grep -oE 'glpat-...' $VAULT | tail -1 (neuster am Ende), NIE
  printen/committen. Vault=/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-{DEV,PROD}.md.
  CA=comdare-gitlab-ca.crt. Cluster-git=intern gitlab-only+Vault-Heimat, wird NIE redigiert/
  gescrubbt. NIE rebase; Remote-Force nur je-Repo-GO. Messdaten/Doku nie loeschen. Transkripte=
  Live-Tokens nie committen. NIE AskUserQuestion. kein Python in Buildchain (ABER python3-re als
  Scanner-Tool des Scrubs sanktioniert). ASCII-Kommentare (Paragraph ok) + Selbstcheck je
  Paketmeldung. cf22 NUR /home/comdare/tools/clang-format-22.1.8, nie auf .cmake/.yml.

===============================================================================
## 2. BINDENDE DIREKTIVEN (Memory + heute; KERN=Gesetz)
===============================================================================
PROZESS:
- Nie raten; Ist live pruefen; stale Doku=Verdacht. Kein Erfolgs-Haken ohne literale Ausgabe.
- Keine Quick-Fixes/Behelfswege; immer der schwerere offizielle Weg (CMake/ctest/CI); sauberste
  Strategie. NUR EIN offizielles XML-getriebenes Programm.
- Increments architekturkonform, NICHT nur gruen ("gruen != korrekt").
- Vor JEDER Aufgabe ultracode-Planung ueber Ledger + alle Plandocs; nach jeder Aufgabe
  adversariale Konformitaets-Pruefung. Bei Unklar/Absolut-Anspruch: ultracode.
- Task-Zuweisung ist KEIN Start-Signal; Start-Gates respektieren; Gegenvorschlag zuerst.
- Working-Tree-Freeze nach jeder Paketmeldung; Manager prueft diff-stat literal vor add; nie
  git add -A, immer granular; je-Commit-baubar.
- USER-KERN-Beschreibung war SCHON IMMER Gesetz; Abweichung im Plan/Code = Regression (an der
  User-Beschreibung orientieren, nicht umgekehrt).
- Impl an Opus delegieren, Fable=Architekt. NIE std::variant fuer statische Achsen (Bloat);
  nur CT->CT und RT->RT (Mapping-Reinheit, §66-N3); Achsen immer getrennt klammern.
- Compile-time only im Hot-Path (Templates/if constexpr/Concepts/CRTP); Pre-Build-Codegen;
  statischer Dispatch; nur benannte Lehrbuch-Patterns (GoF), zero-cost.
- Sessions rueckwaerts lesen (neueste zuerst); backups nur Workflow-Rohdaten; Fortschritt in
  NEUE Session-Docs, Ledger nur bei User-Technik.
- Dual-Remote: origin=gitlab (Fokus), github=flache Out-of-House-Sicherung. Gitflow: main
  Vorfahr von development; nie rebase, vor Push fetch+merge.
- Dual-Weg-Pflicht (§61): jede Funktion ueber CI UND lokal (cmake+Shell). Debug=parallel/
  Messung=1-Thread; prod1+prod2 parallel messen (nie global seriell).
HEUTE NEU (26.07.):
- Regressions-Behebung R-A..R-F + STRUKT-R ist MANAGER-(Fable-)Aufgabe.
- Bau-Laufzeit des Voll-Baus = Arbeitsfenster: nach Trigger alle offenen Baender abarbeiten
  (soweit definiert). concurrency=1 beachten; Code-Baender lokal doppelt verifizieren (Mode A).
- Lokaler Build-Stand ist erheblich hinterher = eigenes TODO (Board #5-Teil, 28.07.-Anker
  V6.6/F12(i): CI UND standalone messfaehig auf EINER Maschine).
- Alte Mess-CSV sind hoechstens ARCHIV (durch die 17->18-/Struktur-Umbrueche); Struktur wird
  NACH PLAN modernisiert (Ordner-Kaskaden + xlsx). tier150 etc.: Datei byte-unveraendert
  (Messdaten-Doktrin), Reader normalisiert Alt-ids beim Lesen.

===============================================================================
## 3. ACHSEN-ARCHITEKTUR (das Herzstueck, alles KERN)
===============================================================================
### 3.1 Bindende Sortierung (Doku-Verstoss = Regression)
Verzeichnis-/Ordnungs-Kette: (1) MESS-TOOLING (Mess-Haupt; measurement_category=Unter) ->
(2) target_isa -> (3) operating_system (NEU, Komplex-Haupt) -> (4) extension_hardware
(-> external_utils) -> (5) ORGAN T00-T16 (+persistence_target T17). Dann letztes Haupt-Blatt ->
3 Unter-Ebenen: Mess-Unter -> System-Unter -> Organ-Unter.

### 3.2 Regressions-Register R-A..R-F
- R-A: operating_system fehlt als System-Haupt-Achse (NEU; jetzt KOMPLEX-Haupt-Achse, s. Q-B).
  Unter-Achsen (STATISCH, RT vorbereitet): os_version, kernel, build/update_status.
- R-B: scheduling ist faelschlich Haupt-Achse -> real UNTER-Achse von target_isa.
- R-C: load_framework ist faelschlich System-Haupt -> META-META-Achse (Messung optional).
  CUSTOM_COMPILE ist KEIN Modus, sondern CLI-FEATURE (ueberschreibt die 4 Modi, liefert die
  Wunsch-Binary). Es bleiben 4 Modi: Debug/Messung/Release/COMPARE.
- R-D: compiler ist faelschlich Haupt-Achse -> UNTER-ACHSEN-GRUPPE (compiler+opt_level+
  atomic128, untrennbar) der KOMPLEX-Haupt-Achse (target_isa x external_utils x MetaMetas,
  ohne load_framework), Command-Pattern (3 Haupt-Achsen verhalten sich wie EINE).
- R-E: Meta-Metas auf variadischem Array (ohne std::variant) = FESTE Identitaets-Bestandteile.
  Aufwaerts-kompatible Identitaet (Teil-Identitaeten mit kleinerer HW gueltig; GPU rein: alt
  laeuft weiter; GPU raus: GPU-Programme nicht). Basis=CPU-only. extension_hardware=Command-
  Pattern-HUB ALLER Beschleuniger.
- R-F: SIMD/AVX gehoeren zu den META-META-Achsen (nicht Unter-Achse von extension_hardware).

### 3.3 Layer-Modell R1-R10 (belegt, backups/20260726-layer-modell-erhebung-workflow)
- R1 CT/RT als XOR, STUFEN-RELATIV: Haupt=CT-statisch, Unter=RT-dynamisch; die dynamische
  Einstellung der Vorstufe ist der CT-Draht der Folgestufe (Owner-Haerte supersediert die
  "in der Regel"-Hedges). Dual-Natur: load_framework + Mess-Tooling = RT-Unter am Planer,
  CT-Haupt an der CEB.
- R2 KOMPLEX-Haupt-Achse: mehrere Haupt-Achsen verhalten sich wie EINE; Haupt-Achsen bekommen
  Schichtungen in derselben Kategorie.
- R3 Command-Hub: Manager verwaltet+gibt frei; jedes Glied handelt als eigenstaendige Instanz.
- R4 REKURSION: Layer-Alternation statisch->dynamisch->statisch; EIN Concept fuer alle Achsen;
  Unter-Achse = VOLL-Achse. FORMAL unbegrenzt (Beispiel GPU-Cluster@PCIe = Meta-Meta selbst
  Manager). Komplexbildung: oberste Ebene, dann rekursiv je Layer.
- R5 Meta-Metas SIND volle CT-Haupt-Achsen (Existenz Schicht1 an/aus + Werte Schicht2).
- R6 Meta-Metas tragen EIGENE RT-Unter-Achsen.
- R2-R6 gelten GENERELL (auch Mess-/Organ-Realm bei Erweiterung; Q-F).

### 3.4 Q-B: OS-Einbau + external_utils
operating_system = 4. GLIED der EINEN Komplex-Achse: target_isa x os x external_utils x
MetaMetas. extension_hardware wird umbenannt zu external_utils = Plug+Manager der Meta-Metas
(externe HW, AVX, UND das Mess-Framework als ERSTER Einbaukandidat).

### 3.5 STEMPEL-KLAMMER-HIERARCHIE (Ebene 0-3; autoritativ REPORT-hinweis.md)
Owner-Kern: strikte Trennung der Achsen-Typen, KLARE Klammern.
- Ebene 0 BINARY-KLAMMER (aeussere Klammer ueber die Typ-Klammern, Komma-getrennt, NIE
  verschmolzen): System-Achsen [d,e,f] -> [[d,e,f],[g,h,i]]Tier-Binary; CEB=[[a,b,c]]CEB;
  Mess-CSV=[[a,b,c],[d,e,f],[g,h,i]]. (Die alte §42-Form [d,e,f,g,h,i] war reine Namens-
  Aufzaehlung; kanonisch ist die geschachtelte Zwei-Klammer-Form.)
- Ebene 1 TYP-KLAMMERN [a,b,c]=Mess / [d,e,f]=System / [g,h,i]=Organ; je Typ eigene Klammer;
  Tier = zwei getrennte Zeilen/Arrays; Klammer-ANZAHL kodiert die Ebene (CEB=1, Tier=2, Mess=3).
- Ebene 2 KOMPLEX-KLAMMER: rekursiv NUR innerhalb ihrer Typ-Klammer; Klammern um die gewrappten
  Haupt-Achsen-Klammern; EIN gemeinsamer Stempel-Block; indirekte Identitaet (Command-Pattern);
  NIE typ-uebergreifend.
- Ebene 3 HAUPT-ACHSEN-KLAMMER: je Haupt-Achse eigene Klammer mit gewaehltem Algorithmus +
  eindeutiger X.Y.Z (Array-Form je Typ, §58).
STEMPEL-DOKTRIN (§43/§58-V, seit 19./20.07. geplant): Stempel je Achsen-Typ -> je Haupt-Achse
(Algo + X.Y.Z). Binary hat KEINE eigene Version (CEB/Tier) - NUR der PLANNER hat eine eigene;
CEB/Tier identifizieren sich aus der Haupt-Achsen-Rekombination + Algo-Versionen. Dritter
Merge-Stempel (§59). Nur die in DIESER Binary CT-einkompilierten Haupt-Achsen; RT-Unter-Achsen
NIE im Binary-Stempel; die Haupt[Unter]-Voll-Klammer (Xa[Unter-k,...]) NUR im Mess-CSV/xlsx.
ABNAHME-3/4-Zusatz: zusaetzliche SHA512-Stempel-Zeile ueber Achsen-Strings+Versionen+HASH ALLER
Overlay-Source-Dateien (Pre-Build-Codegen, consteval, nie Laufzeit; CEB fuer Tiers, Planer fuer
CEBs). OFFEN im Ist-Code (Delta): Array-Form statt Einzel-Zeile (§58-STEMPEL, LEDGER:3031),
echte X.Y.Z-Quellen statt v1-Formatter (§62:3288), Komplex-Wrapper existiert noch nicht.

### 3.6 Organ-Gruppen (Lager-Baum-Ordner, englisch, Basis Idreos/RUM/EM)
01_read_path{search_algo,cache_traversal} 02_layout{node_type,memory_layout,path_compression,
filter,serialization} 03_placement{mapping,allocator,value_handle,index_organization,
migration_policy} 04_execution{concurrency,prefetch} 05_write_path_io{queuing_q1,queuing_q2,
io_dispatch,persistence_target}.

### 3.7 Lager-Baeume + xlsx-Doktrin
Zwei Realm-Baeume: MESSDATEN-Wurzel = Mess-Kombinatorik (Mess-Tooling x load_framework) ->
System-Haupt-Rekombinations-Ordner (Meta-Metas hinten) -> Organ-Gruppen 01-05 -> Haupt-Blatt ->
3 Unter-Ebenen -> xlsx. BINARIES-Lager: System-Wurzel; Mess-Typ als tiefster Haupt-Achsen-Typ.
xlsx=Default (EINE Datei, EIN Sheet je gewaehlter Unter-Achsen-Permutation + INFO-Sheet mit
Sysinfo + Haupt-Achsen), CSV=Factory-Fallback je Sheet. NAMENS-DOKTRIN: dynamische Unter-Achsen-
Variablen IMMER direkt im Dateinamen (Name = Datum+Uhrzeit+Unter-Achsen); Haupt-Achsen als
Ordner-Kaskade + Metadaten in der Datei. SPALTEN-SPARREGEL: nie-aendernde Spalte weglassen ->
Metadaten-Eintrag. DUAL-CCACHE: minio+NAS konfigurierbar; Default minio=Binaries / NAS=Mess-CSV,
beide aufs Gegenteil einstellbar. Ist=flacher Prototyp mit complete-heuristik.log je Knoten
(spin-lock-artig, depth-first, Truncate NUR im sicheren Zustand am Build-Ende oder >4KB).

===============================================================================
## 4. LAGER-GATE-BAU (KOMPLETT, gepusht ausser Join-Welle)
===============================================================================
ce-Kette (finale Scrub-Basis ce81ec62):
- 7d45ebcd Lane B: Voll-Wipe-Wache, owner-Pflicht, Map-Merge O((n+m)log n) (gemessen 17-72x),
  with_document_lock (RAII, Frist-Wache).
- 12515b53 Lane C: with_object_budget, Sidecar-Push/Pull-Vervollstaendigung (.fingerprint/
  .variant im Push-Satz), Prune-Deckungsgleichheit + Drift-Wache.
- 51992898 G4b-1: Host-Verdrahtung Bestandslog (Fingerprint-key_of, 5-Feld bestand_cache-Naht,
  Doppel-Gate, FAIL-LOUD exit 6).
- 2224fff3 G4b-1-Kommentar-Korrektur (minio_enabled).
- c9da967d ABNAHME-1: Lock-ttl ereignisgebunden 30 min (kLockTtlSeconds=1800, Owner-Fund
  LED:3225) + section_budget_s=30.
- d0c6dbf4 Lane E: Iterator-Gates (provision_only), Store-rc + Re-Queue, echte 30-min-Frist,
  N7-Lock-Verdrahtung der 3 Schreibstellen.
- e3a0c6ff G4b-Test: G3CacheEbenenPraedikate + flush-Nachzug (GEPUSHT-Grenze; bis hier dev==main
  beide Remotes).
- 0cb1902a E3 (LockB): ceb_legende + ceb_key_sha512 optionale batch-Attribute, kSyntaxVersion 3.
  [LOKAL, wartet auf Join-Welle]
- 42b34354 MODE (ModeD): COMPARE als 4. Registry-Modus (D2-Tripwire). [LOKAL]
super-Kette: 38c57b11 (Gitlink) -> 7b9649a8 (d1) -> b4e6dcd5 (Gate=minio_enabled, SCHLOSS
scharfen Defekt: drop-only haette toten Transport gebunden) -> ce82db35 (Sichtbarkeits-WARNUNG)
-> 10177e7e (Gitlink Lager-Welle) -> caaf5047 (HANDOVER-6) -> 1db8e045 (Layer-Modell-Backup) ->
f13aabe7 (Q-A..Q-F + Plaintext-Sicherung) -> 79e6b329 (Stempel-Plan-Suche) -> fb77fccd (Q-3-
Report) -> f5bd942a (Stempel-Form korrigiert) -> a1d3715a (Ebene-0-Klammer). Working-Tree:
main.cpp (d2, uncommitted) + Gitlink.

===============================================================================
## 5. STRUKT-R (mid-flight)
===============================================================================
Umfang V2-Byte-Schnitt (Owner Q-0). Kritischer Pfad A -> Join -> F.
- ORG-18 (Impl-Org18, B-1..B-14 FERTIG+verifiziert, B-15 am TABU-Gate): 18. Organ-Achse
  persistence_target{memory_only(enabled,golden_wired), disk_writeback(enabled=FALSE, kein
  echter Disk-Pfad, dreifach ehrlich sichtbar)}; Slot T17 hinter queuing_q2. Aritaets-Bruch:
  17->18 Slots, POD sizeof 1272->1344, POD-Version 7->8, ABI-Major 6->7 (Magic .A6.->.A7.),
  CSV 160->169, Registry 18/83 (FALL-B; Bauplan-84 war FALL-A). Neuer golden-CRC (literaler
  Tool-Output): 0x56F1B721C72DC10E (alt 0xF1C1F26A1232073B), Kardinalitaet unveraendert 131072.
  B-15-GO erteilt: ZUERST golden_fullpilot_320_binary_ids.txt additiv als _abi6.txt einfrieren
  (kein rm), DANN regenerieren (Kopf 18 Slots), DANN CRC neu ankern. Q-8=nur SearchAlgo (Set/
  Sequence/Adapter/View 11/13/9/5 unberuehrt), Q-9=Reader 169+160, Q-10=T17-Anhang, Q-10b=
  goldenK 1 - alle owner-bestaetigt. tier150-Entscheid (a): CSV byte-unveraendert, Reader
  normalisiert Alt-17-Segment-ids beim Lesen durch +/persistence_target=persistence_memory_only.
  io_dispatch-Concept-Fix (axis_tag/family_id/enabled durchreichen) kommt mit ins Paket.
- MODE (Impl-ModeD, FERTIG 42b34354): COMPARE = 4. Registry-Modus (cmake_build_type Release,
  misst nicht, D2-Tripwire-Anker). CUSTOM_COMPILE NICHT in Registry (CLI-Feature, Paket D2).
  D2-Substanz-Naht: emits_measure_job als 4. PlanBuildSemantic-Feld + 5 Director-Nahtstellen.
- (d2)/planer_block (Impl-G4b, FERTIG inkl. E3-Setter, wartet auf Join): 6 ce + 1 super.
  Lifecycle in der Umbrella-TU (PlanerBlockContext-POD, umbrella-frei; Decorator
  LegendCollectingBuilder sammelt ceb_legende im selben Walk). E1-Anker --dump-ci/--dump-cmake.
  E2 id=owner_uuid+"/planer", owner_uuid+maschine eigene Felder. Guarded-emission-Mantel
  (catch->cerr+return 1; exit 6 exklusiv fuer konfiguration_unvollstaendig). emit_ac=
  from_env().with_object_budget(1,10). emit_storage_activation zu freier inline-Funktion
  gehoben (dritter Aufrufer in anderer Klasse). VOLLSTAENDIGER E2E-BEWEIS: ein Gate-an-Lauf hat
  ein reales v3-Dokument geschrieben (syntax_version 3, id ...@prod1/planer, 30-min-Frist exakt,
  status done, ceb_legende="[all]", ceb_key_sha512=128hex). Mehr-Combo-Fall: leer + cerr
  ceb_legende_nicht_eindeutig. E2-Ableitung (CI_JOB_ID@host) bleibt Trigger-Rezept, KEIN Code.
- OFFENE LANES (nach Join, mit vollstaendiger Erhebungs-Grundlage): Lane A SYS-TAX (R-A..R-D +
  Ordnungs-Single-Source kSystemAxisOrder + Stempel A-II/A-III nach Q-A-Doktrin + Generator +
  Validat; ~32-36 Ah, kritischer Pfad); Lane C IDENT/external_utils-HUB (byte-neutral, inert,
  Scharfschaltung erst nach Trigger); Lane F SUFFIX/W-13 (seriell nach A: Single-Source
  build_version_suffix in neuer Ordnung, +ceb LETZTES Segment, T-c-Golden-String-Wache zuerst,
  atomar). Q-2-KORREKTUR: OS=Komplex-Haupt (nicht flach); Meta-Metas als volle Achsen-Typen
  (nicht Descriptor-Daten); offene Rekursion (kein festes 3. Level); generischer Wrapper (kein
  hartkodiertes Label). Diese vier Punkte (D1/D3/D4/D5 der Layer-Erhebung) muss Lane A ggue.
  dem alten Bauplan korrigieren.

===============================================================================
## 6. OWNER-ABNAHMEN (alle eingeholt)
===============================================================================
BESTANDSLOG 1-6 + A-1/A-2: (1) Lock ereignisgebunden 30 min. (2) Baum-System mit complete-
heuristik.log. (3+4) Stempel-SHA512 ueber Achsen-Strings+Versionen+Overlay-Source-Hashes. (5)
CEB-Binaries in System-Achsen-Blaettern. (6) Claim-Check/Takeover PFLICHT vor 01.08. A-1:
Truncate am Build-Ende oder >4KB, nur unter Knoten-Lock. A-2: Version=einmalige Identitaet,
Re-Open=Ast-Neu-Inventarisierung; Binary- und Mess-Lager SEPARAT (kausal gekoppelt).
STRUKT-R Q-0..Q-14: Q-0 V2-Byte-Schnitt. Q-1 disk_writeback enabled=false (kein Disk-Pfad=
Messwert-Luege), XML-Deaktivierbarkeit PFLICHT, Raum 2^17. Q-2 OS=Komplex-Haupt (Layer-Modell).
Q-3 S2 -> als 3-stufige Klammer-Hierarchie praezisiert. Q-4 CUSTOM_COMPILE=CLI-Feature. Q-5/6/7/
8/9/10/10b/11/14 wie empfohlen. Q-13 telemetry=Mess-Tooling-Unterachse des Planers.
LAYER-MODELL Q-A..Q-F: siehe 3.4/3.5. Q-A Stempel-Doktrin, Q-B external_utils, Q-C OS statisch/
Spalten-Sparregel, Q-D Rekursion unbegrenzt, Q-E oberste Ebene+rekursiv, Q-F generell gueltig.

===============================================================================
## 7. GIGA-SCRUB (ABGESCHLOSSEN)
===============================================================================
Infra-Agent (Laptop) hat Phase-B vollzogen: Scrub (359 Meta-Pollution-Pfade entfernt, Leak=0,
Messdaten byte-identisch), gitlab Blob-Purge (Alt-Blobs 404), Identity-Normalisierung (alle
Author/Committer/Tagger -> benjamineliasprobst@gmail.com, 0 Fremd-Identitaet). prod1 adoptiert
(finale Linie), git-Identitaet gesetzt. OFFEN (Board #2): overleaf-Content-Gabelung MERGEN
(github-main c2d3c51e 18 Commits Habich-2 x gitlab-dev ef448e4b 9 Commits, dieselben Kapitel,
nie rebase, Superset, kapitelweise, dann identity-normalisieren + Gitlink). Weiter offen:
public-Schaltung beider Remotes NACH 100%-Verify+Blob-404 (nur Diplom-Repos); github-Alt-
Commit-Residual (SHA-direkt, kein Secret) = Infra/Owner; gitlab-Visibility private->public via
dedizierte Gruppe (Infra kuendigt URL-Wechsel an).

===============================================================================
## 8. ERHEBUNGS-WORKFLOWS (alle in backups/ persistiert+gepusht)
===============================================================================
- 20260726-kontext-neugruendung-workflow: 39 Agenten, Architektur komplett + 5 Sessions +
  Plaene + Transkript-Nachrichten -> Synthese-Lage-Dossier. Workflow-Skript = Vorlage.
- 20260726-g4b-planung-workflow: Verdikt G4b-1 GO / (d2) HOLD (spaeter freigegeben), W-30
  (Mess-Loop gebaut), W-13 (Suffix-Fix vor Trigger).
- 20260726-bestandslog-plan-nachlese-workflow: N7-Soll, E1-E5, Ertuechtigung, Design-Vorlage.
- 20260726-layer-modell-erhebung-workflow: R1-R10 + Abweichungsliste D1-D13.
- 20260726-strukt-r-planung-workflow: Bauplan Lanes A-G, Owner-Fragen Q-0..Q-14.
- 20260726-stempel-plan-suche-workflow: Stempel-Schema war wortgenau geplant.
- 20260726-explore-q3-klammerung: Klammerungs-Definition + korrigierte Ebene-0-3-Form.
- 20260726-session-plaintext-verlauf: 32 Chunks redigierter User/Assistant-Verlauf (API-Anker).
REDAKTIONS-DOKTRIN: Workflow-Rohdaten vor jedem Commit durch 233-Regel-Pass
(/home/comdare/.scrub-rules-diplom.txt, md5 2ae0ce0e8a1af561936cd1d879ba06a9) + regel-bewusster
0-Treffer-Verify. Agent-Volltranskripte NIE committen.

===============================================================================
## 9. BOARD / OFFENE ARBEIT IN GATE-REIHENFOLGE
===============================================================================
#1 STRUKT-R (in_progress): ORG-18 B-15 -> Join -> Lane A/C/F -> W-13.
#2 OVERLEAF-Merge -> identity -> Gitlink (Bau-Fenster).
#3 LAGER-SCHEIBEN (fast fertig): (d2)-Join-Verifikation + Commit-Welle offen.
#4 VOLL-BAU-4-TRIGGER (2^17): nach STRUKT-R + W-13 + 4 Beweisen.
#5 ABGABE+BAENDER: 320er (manual+USER-GO) -> S7 Hybrid -> G8-Anhaenge -> S8 PDF DE+EN;
   Phase-4 vor 01.08. (#46b-Vollausbau: Lager-Baeume/xlsx-Writer, N8-Variante-B, Claim-Check,
   Mess-Realm, Tools-Lager); Band C (D2-Modus-Vollzug, external_utils-Rename-Restweg, #49 HW-
   Achsen RAM/CPU-Fab, CI-Wartung); Dual-Weg-lokal (28.07.-Anker, lokaler Build-Stand hinterher).

DIE 4 LOKALEN BEWEISE vor Trigger: (1) Resume-Skip (GN_DECISION=skip literal); (2) Hydration-
Smoke verified>0 UND pruned>0; (3) Variant-Gate-E2E; (4) Bestandslog-E2E gegen minio (2 Prozesse,
Sektion < Budget, Log lesbar).

TRIGGER-REZEPT (Voll-Bau-4): POST /projects/288/pipeline ref=development, COMDARE_BUILD_GOLDEN_N=
true + COMDARE_STORAGE_CACHE=true + COMDARE_BESTANDSLOG=true + COMDARE_BESTANDSLOG_DOC_KEY +
COMDARE_BESTANDSLOG_OWNER_UUID=$CI_JOB_ID@$(hostname) + _MASCHINE. 24/24 Worker; df+Cron-Wachen.
AUFLAGEN: COMDARE_MINIO_ENDPOINT NIEMALS Platzhalter (mc-Falle: unbekannter Alias schreibt lokal
statt zu scheitern; Preflight mc alias list); keine schweren parallelen CI-Jobs; Facade
comdare_profile_run_facade EXPLIZIT bauen vor jedem Voll-ctest (liegt nicht im all-Ziel).

===============================================================================
## 10. AGENTEN-ZUSTAENDE / FALLEN / CHECKLISTE
===============================================================================
AGENTEN (alle Opus, FREEZE/Standby ausser Org18): Impl-Org18 (B-15 laufend) Impl-G4b (d2
fertig, wartet JOIN FREI) Impl-LockB (E3 fertig) Impl-TransC (fertig) Impl-IterE (fertig)  
Impl-ModeD (fertig, entlassbar) Explore-Q3 (entlassen). Alle Agenten-Nachrichten STRIKT
7-Bit-ASCII (API schneidet an Nicht-ASCII ab - dreifacher Vorfall heute).
FALLEN/LEHREN: (a) API-Abschneidung an Nicht-ASCII -> Agenten-Kommunikation 7-Bit. (b) mc-Falle:
unbekannter minio-Alias = lokaler Pfad, faellt NIE durch. (c) Facade nicht im all-Ziel: lokaler
Voll-ctest sagt nichts ueber die Fassaden-TU -> explizit bauen. (d) stale-green: Reconfigure
deckt maskierte Objekte auf. (e) Spawn-Duplikat bei API-Stoerung -> vor Spawn pruefen. (f)
Meldungs-Kreuzungen: bei Abweichung immer den git-Ist-Stand als Wahrheit nehmen.
JE-COMMIT-BAUBAR + granular + diff-stat literal + eigener ASCII-Check vor jedem add; Push
gesammelt je Welle (concurrency=1). Nach Zyklusende Wachen beenden.

===============================================================================
## 11. UNMITTELBAR NAECHSTE SCHRITTE (Reihenfolge)
===============================================================================
1. Org18-B-15-Paketmeldung abnehmen (golden-Neuanker _abi6 + CRC + tier150-Reader + io_dispatch;
   die 6 roten Zahlen-Tests muessen dann gruen sein).
2. Org18 landen (ce-Commit) -> "JOIN FREI" an G4b -> G4b faehrt 5-Schritte-Join (Facade explizit,
   Voll-ctest N/N, Byte-Wachen, env-frei byte-identisch, Gate-an mit ECHTEM Fehl-Store).
3. Commit-Welle baubar: Org18 ce-Commit -> (d2) ce-Commit -> super (d1 + Gitlink) -> Dual-Push
   (mit 0cb1902a/42b34354, die noch lokal warten) -> CI beobachten.
4. Lane A (SYS-TAX, korrigiert per Layer-Modell D1/D3/D4/D5 + Stempel-Klammer Ebene 0-3) starten;
   Lane C (external_utils-HUB, inert) parallel; danach Lane F (W-13) seriell.
5. Ledger-§67 "Layer-Modell" + external_utils-Rename dokumentieren; D2-Modus-Vollzug-Merkposten.
6. 4 lokale Beweise -> Voll-Bau-4-Trigger.
7. Danach Bau-Fenster: Baender + overleaf-Merge + Dual-Weg-lokal.

*Erstellt 26.07. ~14:15. Ersetzt die zwei abgebrochenen HANDOVER-7-Fragmente (API-Stoerung).*
