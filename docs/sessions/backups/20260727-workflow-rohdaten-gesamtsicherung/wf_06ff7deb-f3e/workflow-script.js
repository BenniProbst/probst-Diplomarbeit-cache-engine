export const meta = {
  name: 'deprecated-features-audit',
  description: 'Inventar + Wiederverwendungs-Bewertung aller deprecated Features (ce+super) inkl. R1/R2/R3-Tiefensonden',
  phases: [
    { title: 'Inventar', detail: '4 parallele Sonden: Code-Marker, Docs/Ledger, .so-ABI-Historie, Driver-Split+CLI' },
    { title: 'Bewertung', detail: 'Synthese: je Feature Wiedereinfuehrungs-Verdikt + Antworten R1/R2/R3' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'

const ITEMS = {
  type: 'object',
  properties: {
    items: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          anchor: { type: 'string', description: 'datei:zeile oder Ledger-§' },
          why_deprecated: { type: 'string' },
          replacement: { type: 'string', description: 'was es ersetzt hat / wohin migriert' },
          residual_value: { type: 'string', description: 'was daran noch taugen koennte (ehrlich, ggf. nichts)' },
        },
        required: ['name', 'anchor', 'why_deprecated', 'residual_value'],
      },
    },
  },
  required: ['items'],
}

phase('Inventar')
const [codeDep, docsDep, soAbi, driverSplit] = await parallel([
  () => agent(
    'Du bist eine read-only Inventar-Sonde. Finde ALLE als deprecated/legacy/verworfen markierten FEATURES im ce-CODE: ' + CE + ' . ' +
    'Grep case-insensitiv nach DEPRECATED, DEPRECATED-BY-DESIGN, deprecat, verworfen, SUPERSEDED, "DO NOT USE", legacy, stillgelegt in libs/ apps/ tools/ tests/ (Kommentare+Banner). ' +
    'Je Fund: um welches FEATURE geht es (nicht nur die Zeile), warum deprecated (aus dem Kommentar/Kontext), was ist der Ersatz, und was daran koennte ehrlich noch taugen (residual_value; "nichts erkennbar" ist eine gueltige Antwort). ' +
    'Bekannte Kandidaten die du VERIFIZIEREN sollst (nicht raten): ExperimentSubtreePayload (frisch S5-P4-deprecated, planner/experiment_dock_payload.hpp), abi/module_loader.hpp PermutationModule-Legacy (0 Consumer), V32-Alt-Antriebs-Pfad (DEPRECATED-BY-DESIGN, aber PhaseStrategyFor/execute_messreihe wurden als Planer-Skelett REAKTIVIERT — genau nachschauen was davon heute welchen Status hat), variant-Baustein-Insel (§23.D-Triade), .golden_n_build statische Matrix (DEPRECATED-Fallback super .gitlab-ci.yml). ' +
    'Dedupliziere auf Feature-Ebene. Liefere NUR die strukturierte Liste.',
    { label: 'inventar:code', phase: 'Inventar', schema: ITEMS }
  ),
  () => agent(
    'Du bist eine read-only Inventar-Sonde. Finde alle als deprecated/verworfen/SUPERSEDED gefuehrten FEATURES in der DOKU: Ledger ' + LEDGER + ' (grep DEPRECATED, SUPERSEDED, verworfen, VERWORFEN, entfaellt, abgeloest) + ' + SUPER + '/docs/plaene/20260720-verworfene-referenzen-erinnerung-fuer-wiederverwendung.md (VOLL lesen — sie ist genau die Wiederverwendungs-Merkliste: A1-A22 + Gruppen B/C/D) + ' + SUPER + '/docs/architektur/02_aktueller_master_REV7_7.md nur Kopf (SUPERSEDED-Vokabular 3-Saeulen/F-S-Nummern/IExecutingEngine). ' +
    'Je Feature: warum verworfen, Ersatz, residual_value (die verworfene-referenzen-Doku nennt ihn oft explizit — uebernimm ihn). Fokus auf FEATURES/Konzepte, nicht auf erledigte TODOs. Max ~25 wichtigste Items, dedupliziert. NUR die strukturierte Liste.',
    { label: 'inventar:docs', phase: 'Inventar', schema: ITEMS }
  ),
  () => agent(
    'Du bist eine read-only Tiefensonde fuer §60-R1: die Historie des Planer<->CEB-Vertrags — TEXTEMISSION vs. .so/C++23-modules-ABI. Repo ce=' + CE + ', super=' + SUPER + ', Ledger=' + LEDGER + '. ' +
    'Ermittle mit datei:zeile/§-Belegen: (1) WIE der Vertrag heute laeuft (Textemission: --dump-ci/--emit-tier-ci YAML, --dump-cmake/--emit-tier-cmake; wo emittiert, wo konsumiert). (2) Die ECHTE Entscheidungs-Historie: Ledger §36 (Pool), §38 (Rueck-Kanal), §37a (Fork-C .so-Schnitt — in A8 DEFERRED mit Begruendung "kein DoD-Traeger"), die REKURSIVE-Dock<->.so-Doktrin vom 19.07. (grep rekursiv/Dock/.so/ABI-stabil im Ledger + docs/plaene/20260719-welle5-dock-protokoll-BAUPLAN.md + 20260719-planer-ceb-tier-topdown-BAUPLAN.md) und W12 (Stempel-Cache). War die .so-Schnittstelle BEWUSST VERWORFEN oder nur DEFERRED — und mit welcher woertlichen Begruendung? (3) Der Daten-Rueckweg heute: Messergebnisse fliessen als CSV-Dateien; bei ~131k Ergebnissen — wo genau waere Textemission der Engpass (Steuerung: YAML-Jobs; Daten: CSV) und was wuerde eine ABI-stabile .so-Schnittstelle (C++23 modules) konkret schneller machen? Ehrliche technische Einschaetzung, keine Gefaelligkeit. (4) Was existiert schon als Vorleistung (anatomy_module_abi_v1-POD-Familie, AnatomyModuleLoader dlopen-Kette, experiment_dock_payload als deprecated Wire-Format, ExperimentSubtreePayload)? Liefere einen kompakten, belegten Fliesstext-Report.',
    { label: 'tiefe:so-abi-R1', phase: 'Inventar' }
  ),
  () => agent(
    'Du bist eine read-only Tiefensonde fuer §60-R2+R3. Repo ce=' + CE + ', super=' + SUPER + '. ' +
    '(R2) Kartiere den measurement_driver-Split: WAS misst/steuert der PLANER (ExperimentPlanDirector + Fassade: Mess-Achsen-Wahl, Tooling, Legenden, Job-Emission) vs. WAS enthaelt die CEB (der eigentliche Mess-Vollzug: run_profile/experiment_run_entry-Loop, Zwei-Phasen-Op-Schleife, Observer-Pull, CSV-Schreiber)? Wo liegt der Code jeweils (datei:zeile)? Bewerte die User-Hypothese: "Die Mess-Achsen des Planers steuern die AUSSTATTUNG der CEB, und die CEB enthaelt den eigentlichen measurement_driver zu den Festlegungen des Planers — also zwei Module und Unter-Klassen derselben Klasseninstanz." Stimmt das Modell fachlich (vgl. Ledger §24-Ketten-Statik: Planer=Mess-HAUPT-CT/Unter-RT delegiert, CEB=System, Tier=Organ; §59-D Anatomy=Stempel-Vorlage je Stufe)? Wo passt es, wo nicht (z.B. ist es EHER Haupt/Unter-Delegation als Vererbung?) — ehrliche Architektur-Antwort. ' +
    '(R3) Kartiere die heutige CLI-Oberflaeche des Treibers (super Code/02_messung_driver/main.cpp: alle Flags --validate/--dump-plan/--dump-ci/--dump-cmake/--emit-tier-ci/--emit-tier-cmake/--measurement-combo + Env-Variablen) + was an Zustands-/Fortschritts-Logging existiert (S5-ProgressSink stderr [progress] + progress.cursor; REFUSED-Marker; VALIDAT-Report) — und was zur User-Anforderung fehlt (umgaengliches Shell-UI, Zustands-Uebersicht CEB+Tier-Builds+Messungen, manuelles XML-Fahren als Erstklass-Weg). Liefere einen kompakten, belegten Fliesstext-Report mit Gap-Liste.',
    { label: 'tiefe:driver-cli-R2R3', phase: 'Inventar' }
  ),
])

phase('Bewertung')
const inv = { code: codeDep, docs: docsDep }
const verdict = await agent(
  'Du bist der Bewertungs-Synthesizer des deprecated-Features-Audits (Diplomarbeit cache-engine). Ehrlich, keine Gefaelligkeits-Verdikte; alles auf den mitgelieferten Sonden-Ergebnissen + eigenen Stichproben-Verifikationen (Repos: ce=' + CE + ', super=' + SUPER + ', Ledger=' + LEDGER + ' §59/§60). ' +
    'SONDEN-ERGEBNISSE (JSON + Reports): CODE-INVENTAR=' + JSON.stringify(inv.code).slice(0, 12000) + ' DOCS-INVENTAR=' + JSON.stringify(inv.docs).slice(0, 12000) + ' SO-ABI-REPORT: ' + String(soAbi).slice(0, 14000) + ' DRIVER-CLI-REPORT: ' + String(driverSplit).slice(0, 14000) + ' ' +
    'LIEFERE: (1) Eine kuratierte Tabelle der ~10-18 wichtigsten deprecated Features mit je: Status (hart-verworfen / deferred / reaktivierbar), Rest-Wert, Wiedereinfuehrungs-Verdikt {LOHNT (wann/als was) | LOHNT TEILWEISE | LOHNT NICHT (warum)}, grobe Kosten. (2) Fundierte Antworten auf R1 (.so-ABI: verworfen vs deferred? Sinnhaftigkeit der Wiedereinfuehrung fuer Steuerung vs Daten getrennt bewerten; C++23-modules-Realismus mit g++-16), R2 (Driver-Split: stimmt die Zwei-Module-derselben-Klasse-Hypothese? welches Modell ist das richtige?), R3 (CLI: was fehlt, wie gross). (3) Eine empfohlene Post-v3-Strang-Reihenfolge fuer die lohnenden Wiedereinfuehrungen. Kompakt, belegt, deutsch.',
  { label: 'bewertung:synthese', phase: 'Bewertung', effort: 'high' }
)

return { inventar_code: codeDep, inventar_docs: docsDep, so_abi_report: soAbi, driver_cli_report: driverSplit, verdict: verdict }