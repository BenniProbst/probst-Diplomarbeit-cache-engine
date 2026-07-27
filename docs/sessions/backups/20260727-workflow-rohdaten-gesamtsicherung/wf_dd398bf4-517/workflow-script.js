export const meta = {
  name: 'measurement-ci-trigger-plan',
  description: 'Cross-Repo-Recherche: konkreter Weg, den golden-320-/Coverage-Vollmesslauf als CI-Job autonom zu triggern (trotz super-CI-Submodul-Fetch-Block)',
  phases: [{ title: 'Recherche' }, { title: 'Synthese' }],
}

const ROOT = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = ROOT + '/Code/external/comdare-cache-engine'

const dims = [
  {
    key: 'ci-mess-job-ist',
    prompt: `Ermittle den IST-Stand der Mess-CI-Jobs über die 4 Repos (ce=${CE}, super=${ROOT}, prt-art=${ROOT}/Code/external/comdare-prt-art, thesis=${ROOT}/thesis/diplomarbeit). Lies die .gitlab-ci.yml von ce + super VOLLSTÄNDIG. Frage: Welche Jobs bauen/messen? Wie läuft der ce pmc:amd-Job (bare-metal, perf_event_open)? Wie pullt super die ce-Mess-Artefakte (CI_API artifacts)? Wo ist der Voll-Mess-Lauf (messung_driver, ~43 DLLs / golden-320) definiert oder als HELD/manual/scheduled markiert? Gibt es ein comdare_pipeline_release / release_measure Target (cmake)? Belege mit datei:zeile. NUR lesen.`,
  },
  {
    key: 'super-ci-block-umgehung',
    prompt: `super-CI ist am verify:submodules/get_sources blockiert (Runner kann das private ce-Submodul nicht klonen: 'HTTP Basic Access denied', trotz korrekter inbound-job_token_scope-Allowlist). Frage: Braucht der super-MESS-Job überhaupt den ce-Submodul-Source, oder nutzt er das ce-CI-Artefakt (super .gitlab-ci.yml pullt 'jobs/artifacts/main/download?job=pmc:amd')? Kann man den Mess-Job so bauen, dass er OHNE ce-Submodul-Fetch läuft (GIT_SUBMODULE_STRATEGY none + ce-Artefakt) oder rein ce-seitig (die volle Mess-Logik run_profile_facade liegt in ce)? Lies super .gitlab-ci.yml Z. 143-240 + die ce pmc:amd-Job-Definition. Belege datei:zeile. Bewerte, ob eine .gitlab-ci.yml-Änderung nötig ist und ob sie mit dem buildsystem/CI-Agenten kollidiert.`,
  },
  {
    key: 'mess-mechanik-doku',
    prompt: `Lies die geplante/definierte Mess-Mechanik-Doku in ${ROOT}/docs: v.a. docs/sessions/20260707-279-tier-binary-sichtbarkeit-mess-modus-DOSSIER.md (release_measure/comdare_pipeline_release), den LEDGER-Abschnitt zu #156/#162 (Voll-Mess-Lauf), und alle Handover/Dossiers zu 'NAS-Writeback', 'scheduled/manual Mess-Job', 'prod-baremetal', 'COMDARE_RELEASE_MODE/COMDARE_MEASUREMENT_MODE'. Frage: Wie ist der scharfe golden-320-Mess-Lauf GEPLANT zu triggern (welcher Job, welche Variablen, welcher Runner, wohin die Artefakte)? Der User sagt 'alles ist da/geplant/definiert' — finde die Definition. Belege datei:zeile.`,
  },
]

const results = await pipeline(
  dims,
  d => agent(d.prompt, { label: d.key, phase: 'Recherche' }),
)

const synth = await agent(
  `Konsolidiere zu EINEM konkreten, ausführbaren Plan: WIE triggere ich den golden-320- (und danach den m3_golden_coverage-) Vollmesslauf als CI-Job AUTONOM, gegeben: (a) super-CI ist am ce-Submodul-Fetch blockiert (Infra), (b) der Voll-Lauf war als HELD manual/scheduled designt, (c) der g++-Linux-E4-Weg ist E2E bewiesen (Pilot: echte CSV), (d) User-GO für autonomes Messen via CI-Job. Gib: (1) den EXAKTEN Trigger-Mechanismus (welches Repo/Projekt-ID, welcher Job-Name oder welche neue when:manual/scheduled Job-Definition, welche CI-Variablen wie COMDARE_RUN_E4_XML/Profil-Pfad/cap, welcher Runner-Tag für bare-metal+PMC), (2) ob/wie der super-CI-Submodul-Block umgangen wird (ce-Artefakt vs GIT_SUBMODULE_STRATEGY none vs ce-seitiger Job), (3) den konkreten API-Call (POST pipeline/trigger job) den ich mit dem Admin-Token machen kann, (4) Risiken/TABU (buildsystem/CI-Agent-Domäne, golden-Fixture, NAS-Writeback-Konvention). Nummerierte, datei:zeile-belegte Schritte.\n\nRECHERCHE:\n` +
    results.map((r, i) => `### ${dims[i].key}\n${r}`).join('\n\n'),
  { label: 'synthese', phase: 'Synthese' },
)

return { plan: synth }
