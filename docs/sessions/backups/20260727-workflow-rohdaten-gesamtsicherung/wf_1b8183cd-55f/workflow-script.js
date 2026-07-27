export const meta = {
  name: 's4-batch-emission-design',
  description: 'Judge-Panel: 3 Design-Entwuerfe fuer den S4-Batch-Emissions-Umbau, vergleichend bewertet, Synthese zum Bauplan',
  phases: [
    { title: 'Entwurf', detail: '3 Architekten mit verschiedenen Linsen (read-only Code-Zugriff)' },
    { title: 'Judge', detail: '3 vergleichende Judges (Korrektheit / Gesetzestreue / Umsetzbarkeit)' },
    { title: 'Synthese', detail: 'Sieger-Design + beste Ideen -> konkreter Bauplan' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

const FAKTEN = `VERIFIZIERTE KARTIERUNG (Basis, alle Belege geprueft):
- Ist-Verstoss: TierCiYamlBuilder.end_perm (${CE}/libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp:765-771) emittiert je System-Perm kTierChunkCount=4 (:412) tier:build-Jobs (emit_tier_build_job :783-853) + 1 Mess-Job (emit_measure_job :865+, needs=Chunk-Jobs, resource_group ceb-measure-<host>). Bei 4 Perms => 20 Jobs, O(Perms x Chunks).
- Chunk = reine CI-Partition des binary_id-Index-Raums via COMDARE_GOLDEN_N_RANGE=START:COUNT (Shell-Arithmetik :825-845); der Treiber konsumiert das Fenster bereits.
- Der Treiber iteriert INTERN bereits vollstaendig: run_profile (profile_run_entry.hpp:231) faehrt die opt x simd-Perm-Schleife (:566-568) + Selektions-Paesse (:471); run_lazy_static_then_dynamic (cache_engine_builder_iterator.hpp:754) ist die je-binary_id-Schleife: provision_all (:815) baut, measure_one_binary (:898) misst, Konformitaets-Gate VOR Messung eingebettet.
- Pruef-Infrastruktur header-only vorhanden: IPruefDock::measure (pruef_dock.hpp:78), PruefDockRegistry::select_for, run_conformance_gate (${CE}/libs/cache_engine/builder/pruef_dock/conformance_gate.hpp:65, RF1-RF14 + 2000 Zufalls-Ops gg. std::map-Oracle, GTest-FREI), AnatomyModuleLoader::load/load_all. FEHLT: Pruef-ONLY-Eintritt (Gate entkoppelt von Messung) = Scheibe S3 (wird parallel gebaut).
- S1 (Log-Flush-Testate) + S2 (kleines Smoke-Umfangs-Profil) werden gerade gebaut — als gegeben annehmen.
- Perms sind an Runner-Tags gebunden (end_perm :767 runner-tags=simd_runner_tags(p.simd_id)) — Maschinen-Zuordnung ist SIMD-getrieben (z.B. avx2/no_ext vs avx512).
- Mess-Jobs haben schon resource_group je Host (measure_host_lane) — prod1+prod2 messen parallel.`

const GESETZE = `BINDENDE GESETZE:
- §62-B: je Maschine EIN Build+Pruef-Batch-Job + EIN Mess-Batch-Job, O(Maschinen); Log-Legende [d,e,f][g,h,i] je Schritt + Fortschritts-Testate; P4: Batch-Typen-Sequenz (Build+Pruef-Batch und Mess-Batch NIE gemischt gleichzeitig je Maschine), Thread-Budgets prod1=32T/24K prod2=24T/16K (voll nur je einzelnem Batch); 4096er-Batches+Zeitstempel als Bestandslog-Saat (VOLLES Bestandslog = spaeteres Paket #46b, hier nur nicht verbauen).
- §64: Default alle 3 Mess-Verfahren vereint in EINER CEB ([all]-Lane) — Batch-Umbau darf das nicht aufbrechen.
- §61: Env waehlt PROFIL, nie Methodik-WERT; Debug=parallel, Messen=1-Thread-Doktrin (Mess-Batch!).
- golden/CRC-TABU: kNewGolden131072Crc64=0xF1C1F26A1232073B unveraendert; TierCiYamlBuilder ist golden-neutral (reine CI-Text-Matrix) — MUSS so bleiben.
- Statischer Dispatch, kein Runtime-Switch; kein Python; ASCII; CMake/ctest offizieller Weg.
- GN-11-TAUGLICHKEIT: Dieselbe Batch-Kette muss den 2^17-Voll-BAU (GN_TOTAL=131072, provision-only, ~2 Tage, beide Maschinen) fahren koennen: Wiederaufnahme nach Abbruch (ccache/GN-Cache existiert: GN_CACHE_KEY/GN_DECISION), Sichtbarkeit (S1-Testate), Fehler je Zelle sichtbar (CSV failed + Log, misst/baut weiter).`

const AUFGABE = `ENTWIRF den S4-Umbau (Batch-Emission) KONKRET: (1) Neue Job-Struktur, die der TierCiYamlBuilder emittiert (wie viele Jobs, Namen, needs, resource_groups, Variablen je Job). (2) Wie erfaehrt der Treiber im Batch-Job seine Perm-TEILMENGE (SIMD/Maschinen-Zuordnung) + sein binary_id-Fenster — welche bestehenden Naehte werden wiederverwendet (COMDARE_GOLDEN_N_RANGE, run_profile-Perm-Schleife), was muss NEU (Perm-Filter?)? (3) Ablauf im Build+Pruef-Batch: Reihenfolge bauen/pruefen je Perm (S3-Gate), Log-Legende je Schritt, Testate. (4) Mess-Batch: 1-Thread-Doktrin, Host-Lane, Abgrenzung zur Build-Phase (P4-Sequenz). (5) Lockstep: welche Emissions-Tests (test_experiment_plan_director u.a.) aendern sich wie. (6) Was passiert mit kTierChunkCount/emit_tier_build_job (entfaellt? Batch-intern?). (7) GN-11: exakt wie der 2^17-Voll-Bau ueber die neue Kette getriggert wird (Variablen, Wiederaufnahme nach Abbruch). (8) Aufwands-Schaetzung in Arbeitsschritten + Risiken. Lies den Code selbst nach (read-only), zitiere datei:zeile.`

const DESIGN_SCHEMA = {
  type: 'object',
  properties: {
    kernidee: { type: 'string' },
    job_struktur: { type: 'string' },
    perm_teilmenge_mechanik: { type: 'string' },
    build_pruef_ablauf: { type: 'string' },
    mess_batch: { type: 'string' },
    lockstep_tests: { type: 'string' },
    chunk_verbleib: { type: 'string' },
    gn11_trigger: { type: 'string' },
    aufwand_risiken: { type: 'string' },
    belege: { type: 'array', items: { type: 'string' } },
  },
  required: ['kernidee', 'job_struktur', 'perm_teilmenge_mechanik', 'build_pruef_ablauf', 'mess_batch', 'lockstep_tests', 'chunk_verbleib', 'gn11_trigger', 'aufwand_risiken', 'belege'],
}

phase('Entwurf')
const LINSEN = [
  { key: 'minimal', linse: 'MINIMAL-INVASIV: maximale Wiederverwendung bestehender Naehte, kleinster Diff, geringstes Regressions-Risiko. Bevorzuge Loesungen, die NUR den TierCiYamlBuilder + Env-Variablen aendern und den Treiber unangetastet lassen, wo irgend moeglich.' },
  { key: 'gesetz', linse: '\u00a762-B-GESETZESTREUE: vollstaendige Erfuellung ALLER \u00a762-B-Vorgaben (P4-Sequenz, Thread-Budgets, Log-Legende je Schritt, Testate, Bestandslog-Saat 4096er) — auch wenn der Diff groesser wird. Pruefe jeden Gesetzes-Punkt einzeln ab.' },
  { key: 'betrieb', linse: 'BETRIEBS-ROBUSTHEIT fuer den 2-Tage-Voll-Bau: Wiederaufnahme nach Abbruch (Netzwechsel/Crash/Runner-Neustart), ccache-Ausnutzung, Fortschritts-Sichtbarkeit von aussen, Fehler-Isolation je Zelle, Ressourcen-Schonung (RAM-Drossel existiert: FreeRamFn). Denke vom Betrieb her rueckwaerts.' },
]

const entwuerfe = await parallel(LINSEN.map(l => () =>
  agent(`Du bist Software-Architekt (C++/Metaprogrammierung/CI) der Diplomarbeit-cache-engine. LINSE: ${l.linse}\n\n${FAKTEN}\n\n${GESETZE}\n\n${AUFGABE}`,
    { label: `entwurf:${l.key}`, phase: 'Entwurf', schema: DESIGN_SCHEMA, effort: 'high' })
    .then(d => ({ linse: l.key, ...d }))))

const gueltige = entwuerfe.filter(Boolean)
if (gueltige.length === 0) throw new Error('kein Entwurf geliefert')
log(`${gueltige.length}/3 Entwuerfe liegen vor`)

phase('Judge')
const VERDIKT_SCHEMA = {
  type: 'object',
  properties: {
    ranking: { type: 'array', items: { type: 'string' }, description: 'Linsen-Keys, bester zuerst' },
    begruendung: { type: 'string' },
    fatale_maengel: { type: 'array', items: { type: 'string' }, description: 'je "linse: mangel" — Dinge, die ein Design disqualifizieren' },
    beste_einzelideen: { type: 'array', items: { type: 'string' }, description: 'je "linse: idee" — uebernehmenswerte Ideen auch aus Verlierer-Designs' },
  },
  required: ['ranking', 'begruendung', 'fatale_maengel', 'beste_einzelideen'],
}
const JUDGE_LINSEN = [
  { key: 'korrektheit', frage: 'Korrektheit + golden/CRC-Neutralitaet + keine stillen Verhaltensaenderungen der Mess-Semantik ([all]-Lane, 1-Thread-Messen). Versuche aktiv, jedes Design zu WIDERLEGEN (Code nachlesen!).' },
  { key: 'gesetzestreue', frage: 'Vollstaendigkeit gegen \u00a762-B/\u00a764/\u00a761 (P4-Sequenz, Thread-Budgets, Log-Legende, Testate, O(Maschinen), Env=Profil-Selektor). Zaehle je Design die erfuellten/verletzten Gesetzes-Punkte.' },
  { key: 'umsetzbarkeit', frage: 'Umsetzbarkeit bis Donnerstag-Vormittag (ein Implementierungs-Agent, Nacht + Vormittag) + GN-11-2-Tage-Bau-Betriebstauglichkeit (Wiederaufnahme, Sichtbarkeit). Bewerte Aufwands-Realismus hart.' },
]
const verdikte = await parallel(JUDGE_LINSEN.map(j => () =>
  agent(`Du bist strenger Design-Judge (Linse: ${j.frage})\n\n${FAKTEN}\n\n${GESETZE}\n\nHier ${gueltige.length} konkurrierende Entwuerfe als JSON:\n${JSON.stringify(gueltige, null, 1)}\n\nVergleiche ALLE Entwuerfe aus deiner Linse. Lies bei Zweifel den Code nach (read-only).`,
    { label: `judge:${j.key}`, phase: 'Judge', schema: VERDIKT_SCHEMA, effort: 'high' })
    .then(v => ({ judge: j.key, ...v }))))

phase('Synthese')
const BAUPLAN_SCHEMA = {
  type: 'object',
  properties: {
    sieger_linse: { type: 'string' },
    bauplan: { type: 'string', description: 'nummerierte konkrete Arbeitsschritte mit datei:zeile' },
    uebernommene_ideen: { type: 'array', items: { type: 'string' } },
    verworfene_ansaetze: { type: 'array', items: { type: 'string' }, description: 'mit Grund' },
    offene_entscheide: { type: 'array', items: { type: 'string' }, description: 'was der Manager/User noch entscheiden muss' },
    gn11_trigger_rezept: { type: 'string' },
    test_plan: { type: 'string' },
  },
  required: ['sieger_linse', 'bauplan', 'uebernommene_ideen', 'verworfene_ansaetze', 'offene_entscheide', 'gn11_trigger_rezept', 'test_plan'],
}
const bauplan = await agent(
  `Synthetisiere aus Entwuerfen und Judge-Verdikten den FINALEN S4-Bauplan. Sieger nach Judge-Mehrheit; fatale Maengel MUESSEN adressiert sein; beste Einzelideen der Verlierer einarbeiten, wo sie den Sieger verbessern. Der Bauplan muss von einem Implementierungs-Agenten ohne Rueckfragen ausfuehrbar sein (konkrete Dateien, Reihenfolge, Tests, Belege).\n\n${FAKTEN}\n\n${GESETZE}\n\nENTWUERFE:\n${JSON.stringify(gueltige, null, 1)}\n\nVERDIKTE:\n${JSON.stringify(verdikte.filter(Boolean), null, 1)}`,
  { label: 'synthese:bauplan', phase: 'Synthese', schema: BAUPLAN_SCHEMA, effort: 'xhigh' })

return { bauplan, verdikte: verdikte.filter(Boolean).map(v => ({ judge: v.judge, ranking: v.ranking, fatale_maengel: v.fatale_maengel })) }