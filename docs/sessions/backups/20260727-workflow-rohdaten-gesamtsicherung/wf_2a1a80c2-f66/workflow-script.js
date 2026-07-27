export const meta = {
  name: 'matrix-migrationsplan-274-recherche',
  description: 'Bestandsprüfung für #274: Wohin gehören die 6 cacheengine-Module in der bestehenden Matrix (A1/A6/A7 + User-Direktive 06.07.)',
  phases: [
    { title: 'Bestand', detail: '4 parallele Kartierer: Backups, buildsystem, Modules-Live, 6-Module-Inhalt' },
    { title: 'Planentwurf', detail: 'Synthese zum #274-Migrationsplan-Entwurf' },
  ],
}

const DB = '/home/comdare/Projekte/Products/comdare-db'
const BK = `${DB}/docs/architecture/_backup-discovery-rohdaten-20260702`
const BS = '/home/comdare/Projekte/Products/cd-buildsystem-construct'
const MOD = '/home/comdare/Projekte/Modules'
const CEALL = `${MOD}/comdare-cacheengine-all`
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'

const KART_SCHEMA = {
  type: 'object',
  properties: {
    befunde: { type: 'array', items: { type: 'string' }, description: 'Kernbefunde mit datei:zeile-Belegen' },
    zuordnungs_kandidaten: { type: 'array', items: { type: 'string' }, description: 'Konkrete Zuordnungen: welche BESTEHENDE Familie/Umbrella/Baseline-Zelle deckt welche Funktionalität der 6 cacheengine-Module (measurement/isa-dispatch/cache-engine-core/search-engine/build-tools/test-system)' },
    konventionen: { type: 'array', items: { type: 'string' }, description: 'Include-Layout/Namespace/Branch/buildsystem.xml-Konventionen des jeweiligen Owners (A4: beim Owner nachschlagen)' },
    offene_fragen: { type: 'array', items: { type: 'string' } },
  },
  required: ['befunde', 'zuordnungs_kandidaten', 'konventionen', 'offene_fragen'],
}

phase('Bestand')
const [backups, buildsystem, modulesLive, sechsModule] = await parallel([
  () => agent(`Kartiere READ-ONLY die comdare-db-Analyse-Backups unter ${BK}/ (Verzeichnis listen, INDEX/Mapping-Dateien zuerst, dann relevante Rohdaten-Dateien vollständig lesen).

FRAGE (Ledger §13.9 A1, autoritativ): Die 6 cacheengine-Module (measurement, isa-dispatch, cache-engine-core, search-engine, build-tools, test-system) sollen NICHT als eigene Familie in die Matrix, sondern auf BESTEHENDE (auch unvollständig implementierte/geplante) Teilsysteme von comdare-db und buildsystem konsolidiert werden. Welche existierenden Teilsysteme/Familien/Baseline-Zellen in den comdare-db-Analysen (IST-Kartografie, SOLL-FEATURES-MASTER, Konsumenten-Karten) decken die Funktionalität: (a) Mess-/Telemetrie-Framework (Snapshots, HDR, latency), (b) Plattform-/ISA-Erkennung, (c) Suchalgorithmus-/Index-Kern, (d) Codegen/Build-Orchestrierung, (e) Test-/Conformance-Infrastruktur? Nenne exakte Modul-/Zellen-Namen mit Fundstellen. Auch: comdare-metrics (IMeasurementObserver) — wo lebt es, welche Baseline? Antworte auf Deutsch.`, { label: 'backups-db', phase: 'Bestand', schema: KART_SCHEMA }),

  () => agent(`Kartiere READ-ONLY das buildsystem-Produkt unter ${BS}/ (Struktur, Layer, cd-buildsystem-core/docs/BUILDSYSTEM-LEDGER.md falls vorhanden, docs/architecture).

FRAGE (Ledger §13.9 A6, autoritativ): cache-engine gehört funktional zu OPTIMIERUNG = "buildsystem-Fraktion" (misst Algorithmus-Eigenschaften aus, bestimmt bei Auswahl den besten). Welche bestehenden buildsystem-Module/Layer/Kategorien gibt es (Layer0-4?), welche davon sind Kandidaten für: build-tools (Codegen/Orchestrierung), test-system (Conformance/Prüf-Infrastruktur), measurement (Auswertung/Optimierungs-Messung)? Welche Konventionen gelten dort (Include-Layout, buildsystem.xml, Branches)? Gibt es eine dokumentierte "Fraktions"-/Kategorien-Systematik? Antworte auf Deutsch mit Fundstellen.`, { label: 'buildsystem', phase: 'Bestand', schema: KART_SCHEMA }),

  () => agent(`Kartiere READ-ONLY das live Modules-Matrix-System unter ${MOD}/ (16 Umbrellas). Für JEDES Umbrella: baseline_N-Ordner auflisten + je 2-3 Zellen-Namen (nur ls, keine Vollreads). Tiefer lesen NUR bei: comdare-foundation-all (platform/simd — Include-Layout + Namespace einer Zelle exemplarisch VOLLSTÄNDIG: CMakeLists + 1 Header), comdare-config-all, comdare-core-all, comdare-treecore-all (Such-/Baum-Nähe?), comdare-storage-all (indexmanager?).

FRAGEN: (1) Existiert bereits eine Kategorie/Zelle für Messung/Metriken/Telemetrie irgendwo (grep -ril "metric\\|measurement\\|telemetry" über die Umbrella-READMEs/Zellen-Namen)? (2) Was ist das EXAKTE Include-Layout + Namespace-Muster der foundation-Zellen (A4: Owner-Konvention nachschlagen — include/comdare/<ns>/? Alias comdare::<x>?)? (3) Welche Umbrellas haben welche Baseline-Stufen-Namen (foundation-all hat 0-foundation/1-core/2-math/3-extensions — andere?)? (4) Wo würden isa-dispatch-Inhalte (cpuid/isa_features) vs. das foundation-simd/platform kollidieren/überlappen? Antworte auf Deutsch mit Pfad-Belegen.`, { label: 'modules-live', phase: 'Bestand', schema: KART_SCHEMA }),

  () => agent(`Kartiere READ-ONLY: (1) Die 6 Modul-Skelette unter ${CEALL}/ (welche Header führen sie heute je Modul — ls -R je Modul, include-Präfixe, namespaces aus 2-3 Headern je Modul); (2) im Monolithen ${CE}/libs/ die REALEN Quell-Teilbäume, die laut #256-Mapping extrahiert werden sollen: measurement←(builder/measurement_snapshot, HDR, latency_stats, provenance, dataset_loader, pinning) · isa-dispatch←(cpuid/platform_probe/isa_features) · search-engine←(SearchEngine/Organe = axes/lookup) · cache-engine-core←(anatomy/ABI-Kern) · build-tools←(builder/codegen, Orchestrator) · test-system←(builder/pruef_dock, conformance) — je Teilbaum: Pfad existiert? grobe Größe (Dateizahl)? Abhängigkeiten zu anderen Teilbäumen (Include-Richtungen stichprobenartig)?

ZIEL: Für den Migrationsplan wissen, WAS wohin muss und welche INV-2-Kanten (nur n→n-1) sich daraus ergeben. Antworte auf Deutsch mit Pfad-Belegen.`, { label: 'sechs-module-ist', phase: 'Bestand', schema: KART_SCHEMA }),
])

phase('Planentwurf')
const clean = [backups, buildsystem, modulesLive, sechsModule].filter(Boolean)
const plan = await agent(`Du bist Architektur-Synthesizer. Entwirf aus diesen 4 Kartierungen den #274-MIGRATIONSPLAN-ENTWURF (Diplomarbeit cache-engine → comdare-Matrix), auf Deutsch.

BINDENDE VORGABEN:
- Ledger §13.9 A1: Die 6 Module gehören in BESTEHENDE db-/buildsystem-Familien (kein eigenes cacheengine-Umbrella); A6: cache-engine = funktional OPTIMIERUNG = buildsystem-Fraktion; A7: measurement+metrics → neue Kategorie comdare-measurement-all; Name "comdare-cache-engine-all" VERBOTEN; Migration OHNE Löschen (GitLab-Transfer/Rename statt delete+recreate); A5: Branch-Konsolidierung main/master→main + development.
- User-Direktive 06.07. (bindend): Matrix-FEINGLIEDERUNG STRIKT durchsetzen (INV-1..4, Baseline-Zellen header-only INTERFACE + comdare::<x>-Alias); wenn möglich in BEREITS BESTEHENDE Module auslagern (Haupt-Module + baseline-Untermodule führen Funktionalität); bestehende Module in Product oder Research LINKEN und dort mit EIGENEN ABGELEITETEN Modulen erweitern; Wiederverwendbarkeit maximal.
- MATRIX-GRUNDLAGEN-GOALV2 (normativ): INV-2 nur n→n-1; Modul↔Modul via source="modules"; Fassaden NUR Produkte; Research darf direkt konsumieren; simd setzt platform voraus.
- Pipeline 286 / Monolith bleibt unangetastet (Kopie-Extraktion zuerst); golden/ABI-4 neutral.

KARTIERUNGEN:
${JSON.stringify(clean, null, 2)}

LIEFERE: (1) Ziel-Zuordnungstabelle je der 6 Funktionsbereiche → bestehende Familie/Umbrella + Baseline-Stufe (mit Beleg warum); (2) was NEU angelegt werden muss (minimal — z.B. comdare-measurement-all) inkl. GitLab-Transfer/Rename-Schritte OHNE Löschen; (3) Schrittfolge (nummerierte Increments, je EIN Commit-Scope) inkl. Schritt 0 Umbrella-Rahmen; (4) die abgeleiteten Research-Erweiterungsmodule (wie linkt die Diplomarbeit die bestehenden Module und wo leben die cache-engine-SPEZIFISCHEN Ableitungen); (5) GATED-Punkte (was braucht User-GO je Repo); (6) offene Fragen. Ehrlich kennzeichnen, was Empfehlung vs. belegter Bestand ist.`, {
    label: 'plan-synthese', phase: 'Planentwurf', schema: {
      type: 'object',
      properties: {
        zuordnung: { type: 'array', items: { type: 'string' } },
        neuanlagen_minimal: { type: 'array', items: { type: 'string' } },
        schrittfolge: { type: 'array', items: { type: 'string' } },
        research_ableitungen: { type: 'string' },
        gated: { type: 'array', items: { type: 'string' } },
        offene_fragen: { type: 'array', items: { type: 'string' } },
      },
      required: ['zuordnung', 'neuanlagen_minimal', 'schrittfolge', 'research_ableitungen', 'gated', 'offene_fragen'],
    },
  })

return { plan, kartierungen: clean }