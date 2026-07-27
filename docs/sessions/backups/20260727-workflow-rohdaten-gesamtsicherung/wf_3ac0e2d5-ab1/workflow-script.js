export const meta = {
  name: 'bauplan-inc1-ceb-systemachsen-schichtung',
  description: 'Planungssession Bau-INC-1: CEB-System-Achsen-Schichtung (System ⊃ Tier, ABI-4-kompatibel) — Bauplan-Dossier zur Freigabe',
  phases: [
    { title: 'Erfassung', detail: '4 parallele Straenge: Architektur-Modell, Plandocs, Ist-Code der 4 verstreuten System-Achsen, ABI/TABU-Grenze' },
    { title: 'Synthese', detail: 'BAUPLAN-INC1-Dossier autorieren (ABI-4-kompatibel, ohne 4->5-Bump)' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BACKUPS = SUPER + '/docs/sessions/backups'

const COMMON = 'GEMEINSAME DIREKTIVEN (strikt): (1) Belege als datei:zeile. (2) NIEMALS Tokens/Secrets (glpat/oauth2/eyJ -> [MASKIERT]). (3) KEINE git-Commits/Pushes, KEINE Code-Edits (reine Planung/Lesung; Dateien schreiben nur wo die Aufgabe es sagt). (4) Rueckgabe = roher Daten-Report, kein Menschentext. (5) Token-effizient: grep vor Read, Read mit offset/limit, wc -l vor grossen Dateien. Pfade: SUPER=' + SUPER + ' CE=' + CE + ' LEDGER=' + LEDGER + ' BACKUPS=' + BACKUPS + '\n\nKONTEXT (autoritativ):\n' + args.facts + '\n\n'

phase('Erfassung')

const [modell, plandocs, istcode, abigrenze] = await parallel([
  () => agent(COMMON +
    'AUFGABE 1 — ARCHITEKTUR-MODELL DER SCHICHTUNG (Soll). Lies im LEDGER: §19.C (definitives Modell), §19.D (Delta-Befund), §18.1.2 (CEB-System-Achsen ⊃ Tier-Achsen — die zentrale Soll-Schichtung; grep "18.1.2"), §18.2.2 (Delta-Tabelle der 4 verstreuten System-Achsen; grep "18.2.2"), §20.C (INC-0 erledigt), §0-GOAL-V6.2 (Arbeitsprogramm, grep "V6.2"). Liefere praezise: (a) Die 4 CEB-System-Achsen (Scheduling / Hardware-ISA / Telemetrie / Last+Last-Frameworks) — je: was ist ihre Soll-Rolle als System-Achse, wie umschliesst sie die 19 Organ-Achsen? (b) Was heisst "System ⊃ Tier" konkret fuer die Datenstruktur (heute FLACH: 26 in std::vector<AxisLevel>)? Soll = 2 getrennte Schichten mit eigener abstrakter Wurzel ("Blut", Organ- vs System-Achsen NIE mischen). (c) Welche INVARIANTEN muessen erhalten bleiben (golden==320 aus den 19 Organ-Achsen; CEB system-achsen-versioniert; compile-time-only CRTP+Concept, keine vtable)? (d) Die Naht zu INC-2: was gehoert NICHT in INC-1 (der 4->5-Major-Bump, POD/Schema-Bruch, Telemetrie-Herausloesung aus binary_id mit golden-Neubau) — INC-1 ist ABI-4-KOMPATIBEL und legt NUR den compile-time-Schichtungs-Rahmen.',
    { label: 'erfassung:modell', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 2 — PLANDOCS-DEEP-READ (Muss-Lektuere INC-1 aus Bauplan-INC0 §6). Lies vollstaendig, sofern vorhanden (erst ls ' + BACKUPS + '/ | sort, dann je Verzeichnis die Haupt-.md): (1) ' + BACKUPS + '/20260717-konstruktionslogik-durchdringung/KONSTRUKTIONSLOGIK.md §6/§8 (Schichtung = INC-1-Kern) + F12III-DESIGN-VORLAGE.md (nur die INC-1-relevanten Grenzen), (2) ' + BACKUPS + '/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md §6 (Planungs-Index INC-1: exakte Dossier-Liste + 3 kritischste Design-Punkte), (3) die 4-System-Achsen-/Hardware-Dossiers: suche per ls nach 20260716-*systemachsen* / *e18*ebene1*h1*hardware* / *e17* / 20260710-*simd* (H-7 -march) / 20260710-*general-hardware* / 20260716-*s7-locking* — lies je Kopf + Kernaussagen. Liefere: (a) je Dossier 2-3 Saetze Kernbeitrag zur Schichtung, (b) die konsolidierten Design-Vorgaben fuer JEDE der 4 System-Achsen (Scheduling=compile-time-CRTP-System-Achse #37; Hardware-ISA/H-7=-march/-mavx-Kopplung + AVX512-Kontrolle; Telemetrie=System-Achse [ABER Herausloesung aus binary_id ist INC-2!]; Last+Last-Frameworks=System-Achse via Pruef-Dock-Settings H-9), (c) Widersprueche/offene Punkte zwischen den Dossiers explizit.',
    { label: 'erfassung:plandocs', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 3 — IST-CODE-KARTIERUNG der 4 verstreuten System-Achsen + der flachen Achsen-Struktur, datei:zeile-genau. Arbeitsverzeichnis CE=' + CE + '. Erfasse: (1) Die FLACHE Achsen-Struktur: wo ist "std::vector<AxisLevel>" definiert/befuellt (grep -rn "std::vector<AxisLevel>" + "AxisLevel" in libs/cache_engine/builder + anatomy), wie werden die 26 Achsen (19 Organ + Build-Achsen + die System-Achsen) heute registriert (axis_library_registry.hpp — Struktur, Achsen-Liste, wie werden System- vs Organ-Achsen unterschieden ODER eben NICHT)? (2) Scheduling = verwaiste Runtime-vtable: concepts/scheduling_strategy.hpp (Ist nach F6-DEPRECATED-Marker: ISchedulingStrategy/DefaultSchedulingStrategy — vtable-basiert, 0 Konsumenten), wie muesste die compile-time-CRTP-System-Achse #37 aussehen (Muster: die bestehenden CRTP+Concept-Achsen, z.B. eine Organ-Achse als Vorlage — nenne eine konkrete als Referenz-Muster mit datei:zeile). (3) Telemetrie: heute Organ-Slot T10 (grep telemetry in anatomy/composition + kCompositionAxisNames) — wo genau, und was waere die System-Achsen-Sicht (NUR Rahmen in INC-1, Herausloesung=INC-2). (4) Hardware/ISA: die Build-Achse (page_type/isa) + Organ-Achse isa (axis_12/13?) — wo, und wo muesste die -march/-mavx-Kopplung andocken (Bezug make_gpp_compile_fn defines + die SIMD-Dispatch-Achse). (5) Last/Last-Frameworks: wo werden Workloads/Lastprofile geladen (workload_driver, load_profile_parser) — heute Antriebspunkt, Soll=System-Achse. (6) CEB-System-Achsen-Versionierung (H-10): wo werden Build-Variant-Metadaten heute geschrieben (grep build_version / .version / metadata neben Binary). Liefere eine praezise Ist-Tabelle + je Achse den Andockpunkt fuer die Schichtung.',
    { label: 'erfassung:istcode', phase: 'Erfassung', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 4 — ABI/TABU-GRENZE + COMPILE-TIME-DOKTRIN fuer INC-1. INC-1 MUSS ABI-4-kompatibel bleiben (der 4->5-Bump ist INC-2, TABU-GO nur dort). Erfasse: (1) Wo ist ABI-MAJOR==4 verankert (grep -rn "ABI_MAJOR\\|A4\\.\\|abi_major\\|Major = 4" in CE) — was darf INC-1 NICHT anfassen (POD-1416 ComdareTierObserverSnapshot, kV3AxisSchema, GenusBindingTraits, serialize_composition_path, golden_fullpilot_320, permutation_axes.xml, Registry-mp_list)? (2) Kann eine NEUE compile-time-System-Achsen-SCHICHT additiv eingezogen werden, OHNE die binary_id-Projektion der 19 Organ-Achsen (golden==320) zu veraendern? Pruefe: berechnet sich binary_id NUR aus den 19 Organ-Achsen (dann sind System-Achsen orthogonal und golden bleibt 320) — belege via serialize_composition_path / binary_id-Bildung / kCompositionAxisNames. (3) Compile-time-Doktrin: die Schichtung muss CRTP+Concept sein (keine vtable, kein Runtime-Switch); welche benannten Lehrbuch-Patterns passen (CRTP-Basis + Concept-Guard je Achse; die System-Achsen-Schicht als eigene abstrakte Wurzel)? (4) Wie wird die CEB heute unter Achsen kompiliert (grep COMDARE_.*AXIS / compile-def / die Registry-Pfade aus feedback_ceb_config) — wo docktet die System-Achsen-Versionierung an? Liefere: die harte TABU-Liste fuer INC-1 + den Nachweis, dass die Schichtung golden-neutral+ABI-4-kompatibel machbar ist (oder wo NICHT — dann Warnung).',
    { label: 'erfassung:abigrenze', phase: 'Erfassung', model: 'opus' }),
])

const okN = [modell, plandocs, istcode, abigrenze].filter(Boolean).length
log('Erfassung INC-1 fertig: ' + okN + '/4 Straenge')

phase('Synthese')

const bauplan = await agent(COMMON +
  'AUFGABE S — BAUPLAN-DOSSIER INC-1 SCHREIBEN (Datei anlegen, KEIN Ledger-Edit, KEIN Commit, KEIN Code). Erstelle Verzeichnis ' + BACKUPS + '/20260717-inc1-bauplan/ und schreibe BAUPLAN-INC1-CEB-SYSTEMACHSEN-SCHICHTUNG.md — der vollstaendige, freigabefaehige Bauplan fuer Bau-INC-1 (CEB-System-Achsen-Schichtung, System ⊃ Tier, ABI-4-KOMPATIBEL, KEIN 4->5-Bump), auf Basis der 4 Erfassungs-Reports unten. Struktur:\n' +
  '(0) KOPF: Zweck (die 4 CEB-System-Achsen als gemeinsame compile-time-Schicht ueber den 19 Organ-Achsen; heute flach/verstreut §19.D). Scope-Grenze HART: ABI-4-kompatibel, golden==320 UNVERAENDERT, TABU unberuehrt, KEINE Telemetrie-Herausloesung-aus-binary_id (das ist INC-2), KEIN Major-Bump. User-Freigabe-Status: ERSTELLT ZUR FREIGABE — Bau erst nach explizitem User-GO fuer Bau-INC-1.\n' +
  '(1) IST-KARTIERUNG datei:zeile (aus Report 3).\n' +
  '(2) DESIGN der Schichtung: (a) die eigene abstrakte Wurzel fuer System-Achsen ("Blut", getrennt von den Organ-Achsen) — CRTP-Basis + Concept-Guard, konkrete Typ-Skizze; (b) je der 4 System-Achsen (Scheduling #37 / Hardware-ISA+H-7 / Telemetrie-RAHMEN / Last+Frameworks) das compile-time-Interface (CRTP+Concept, benanntes Pattern), WIE sie die Organ-Achsen-Schicht umschliesst, und der Andockpunkt; (c) Nachweis golden-Neutralitaet (binary_id nur aus 19 Organ-Achsen -> System-Achsen orthogonal) + ABI-4-Kompatibilitaet; (d) CEB-System-Achsen-Versionierung (H-10-Metadaten) Andockpunkt.\n' +
  '(3) SCHRITTFOLGE als Mini-Increments (INC-1a..1x, je: Dateien, Aenderungsskizze, EIGENE literale Verifikation lokal-doppelt ce-standalone build-conf + super build-i2). Konservativ schneiden: erst die abstrakte System-Achsen-Wurzel+Concept, dann je Achse EINE, jede fuer sich golden==320 + ctest gruen.\n' +
  '(4) VERIFIKATIONS-PLAN: je Mini-Increment ctest + golden-Roundtrip==320 + cf22==0 + Mojibake==0 + beide Remotes; super-Sub-Build PFLICHT.\n' +
  '(5) RISIKEN + ROLLBACK (v.a.: versehentliches Beruehren der binary_id-Projektion -> golden-Bruch; versehentlicher ABI-Bruch -> gehoert zu INC-2; vtable-Ruecklfall bei Scheduling).\n' +
  '(6) NAHT ZU INC-2 explizit: welche Punkte INC-1 BEWUSST offen laesst fuer den koordinierten 4->5-Bump (Telemetrie-Herausloesung, Metadaten-Versionsfeld, Set-Ebene-1).\n' +
  '(7) OFFENE DETAILFRAGEN AN DEN USER (nur ECHT offene nach Doktrin-Check gegen Ledger/Plandocs; wenn ein Report die Antwort hat, ist es NICHT offen). Erwartung: die 3 kritischsten Design-Punkte aus Bauplan-INC0 §6 sind meist schon entschieden — pruefe.\n' +
  'Alle Aussagen mit datei:zeile-Beleg. Bei Widerspruechen zwischen Reports: beide nennen + konservative Empfehlung. RUECKGABE: Dateipfad + Executive Summary (10 Saetze) + Liste offener Detailfragen + Einschaetzung ob INC-1 in EINEM Zug baubar ist oder in mehrere Freigabe-Phasen zerfaellt.\n\n' +
  '=== REPORT 1 (Modell) ===\n' + (modell || '(ausgefallen)') +
  '\n\n=== REPORT 2 (Plandocs) ===\n' + (plandocs || '(ausgefallen)') +
  '\n\n=== REPORT 3 (Ist-Code) ===\n' + (istcode || '(ausgefallen)') +
  '\n\n=== REPORT 4 (ABI/TABU-Grenze) ===\n' + (abigrenze || '(ausgefallen)'),
  { label: 'synthese:bauplan-inc1', phase: 'Synthese', model: 'opus' })

return { erfassung_ok: okN, bauplan: bauplan || 'AUSGEFALLEN' }