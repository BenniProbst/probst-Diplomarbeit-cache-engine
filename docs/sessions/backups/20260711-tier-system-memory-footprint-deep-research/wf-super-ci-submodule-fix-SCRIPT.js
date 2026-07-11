export const meta = {
  name: 'super-ci-submodule-fix',
  description: 'Robuster super-.gitlab-ci.yml-Fix fuer Cross-Projekt-Private-Submodul-Fetch (Deploy-Token), nach 2 gescheiterten insteadOf-Versuchen',
  phases: [
    { title: 'Investigate' },
    { title: 'Synthesize' },
    { title: 'Refute' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CITEMPL = '/home/comdare/Projekte/Cluster/_infra/ci-templates/base-pipeline.yml'

phase('Investigate')
const DIM = [
  {
    key: 'ci-templates',
    prompt: `Lies VOLLSTAENDIG die GitLab-CI-Template-Datei ${CITEMPL} (READ-ONLY, NICHT aendern). Aufgabe: Enumeriere JEDEN dort definierten Job/Template-Anchor (.build-*, .lint-*, .test, .toolchain-probe, etc.). Fuer JEDEN: (a) definiert er ein eigenes before_script ODER erbt er default:before_script? (b) setzt er GIT_SUBMODULE_STRATEGY selbst? (c) braucht er die Submodule (ce/prt-art/thesis) fuer seinen Zweck? (d) definiert er hooks? Zusaetzlich: wie laeuft get_sources relativ zu hooks.pre_get_sources_script und before_script (Reihenfolge)? Gibt es post_get_sources hooks? Antworte als strukturierte Tabelle Job -> {own_before_script, own_git_submodule_strategy, needs_submodules, defines_hooks}. WICHTIG fuer die Folge-Entscheidung: Wenn ci-templates-Jobs eigene before_script definieren, wuerde ein super-seitiges default:before_script fuer sie IGNORIERT. Belege mit datei:zeile.`,
  },
  {
    key: 'super-yaml',
    prompt: `Lies VOLLSTAENDIG ${SUPER}/.gitlab-ci.yml. Aufgabe: (1) Enumeriere jeden Job + welche Stage + ob er via extends aus ci-templates kommt oder super-eigen ist. (2) Welche Jobs BRAUCHEN die Submodule ce/prt-art/thesis geklont (orchestrate/analyse/test/integration/manifest/thesis-pdf)? Welche NICHT (lint:*)? (3) Dokumentiere den aktuellen Submodul-Auth-Stand: die 2 gescheiterten Fix-Versuche (default.hooks.pre_get_sources_script mit git config url.insteadOf + CI_JOB_TOKEN, dann + Group-Deploy-Token CE_SUBMODULE_USER/CE_SUBMODULE_TOKEN), variables GIT_SUBMODULE_STRATEGY=recursive + GIT_SUBMODULE_FORCE_HTTPS=true. (4) Gibt es bereits vorhandene CI-Vars CE_SUBMODULE_USER/CE_SUBMODULE_TOKEN (im yaml referenziert)? Belege mit datei:zeile. NICHTS aendern.`,
  },
  {
    key: 'mechanism',
    prompt: `GitLab-CI-Mechanik-Analyse (konzeptionell, keine Datei noetig, aber du darfst ${SUPER}/.gitlab-ci.yml lesen). Frage: WARUM wurde bei 2 Fix-Versuchen die 'git config --global url."https://USER:TOKEN@host/".insteadOf "https://host/"' vom GitLab-Auto-Submodul-Fetch IGNORIERT? Hypothese zu pruefen: GitLab's get_sources mit GIT_SUBMODULE_FORCE_HTTPS=true schreibt die relativen Submodul-URLs selbst auf 'https://gitlab-ci-token:${'$'}{CI_JOB_TOKEN}@host/...' um — die Credentials sind also SCHON in der URL eingebettet, sodass insteadOf auf dem Praefix 'https://host/' NICHT matcht (die Auto-Fetch-URL beginnt mit 'https://gitlab-ci-token:...@host/'). Verifiziere/widerlege diese Hypothese aus GitLab-Doku-Wissen. Dann: was ist das KANONISCHE, robuste Muster fuer Cross-Projekt-PRIVATE-Submodule mit einem Deploy-Token in GitLab CI? (Erwartete Antwort: GIT_SUBMODULE_STRATEGY=none abschalten + manueller 'git config insteadOf' + 'git submodule sync --recursive' + 'git submodule update --init --recursive' in einem Script-Step der NACH get_sources laeuft.) Nenne die genauen Fallstricke: laeuft before_script nach get_sources? kann man das manuelle Klonen so platzieren, dass es fuer ALLE submodul-brauchenden Jobs greift, auch wenn ci-templates-Jobs eigene before_script haben?`,
  },
]
const invest = await parallel(DIM.map(d => () => agent(d.prompt, { label: `invest:${d.key}`, phase: 'Investigate' })))
const investText = DIM.map((d, i) => `### ${d.key}\n${invest[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Synthesize')
const DIFF_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['approach', 'yaml_changes', 'per_job_impact', 'verification_steps', 'risk_notes'],
  properties: {
    approach: { type: 'string', description: 'Kurze Beschreibung des gewaehlten robusten Ansatzes' },
    yaml_changes: {
      type: 'array',
      description: 'Konkrete Aenderungen an super/.gitlab-ci.yml (NUR diese Datei, NICHT ci-templates)',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['location', 'old_snippet', 'new_snippet', 'why'],
        properties: {
          location: { type: 'string', description: 'z.B. "variables-Block" oder "default:before_script (neu)" + Zeilenbereich' },
          old_snippet: { type: 'string', description: 'Exakter alter Text (leer wenn Neu-Einfuegung)' },
          new_snippet: { type: 'string', description: 'Exakter neuer Text' },
          why: { type: 'string' },
        },
      },
    },
    per_job_impact: { type: 'string', description: 'Fuer jeden Job-Typ (lint:*, orchestrate, analyse, test, integration, manifest, thesis-pdf): bricht/hilft der Fix? Adressiere explizit das before_script/extends-Clobbering-Risiko.' },
    verification_steps: { type: 'array', items: { type: 'string' }, description: 'Wie ich (der Parent) auf einem Isolations-Branch verifiziere dass get_sources + verify:submodules gruen werden' },
    risk_notes: { type: 'string', description: 'Token-Sicherheit (nie committen), Nebenwirkungen auf Lint-Jobs, ci-templates-Unberuehrtheit' },
  },
}
const draft = await agent(
  `Du bist GitLab-CI-Architekt. Auf Basis der Investigation synthetisiere den MINIMALEN, ROBUSTEN Fix fuer super/.gitlab-ci.yml, der den Cross-Projekt-Private-Submodul-Fetch mit dem Group-Deploy-Token (CI-Vars CE_SUBMODULE_USER/CE_SUBMODULE_TOKEN, bereits angelegt) zum Laufen bringt.\n\nHARTE CONSTRAINTS:\n- NUR super/.gitlab-ci.yml aendern. ci-templates (${CITEMPL}) ist TABU (fremder Infra-Agent).\n- Lint-Jobs (lint:secrets/format/static) duerfen NICHT verlangsamt/gebrochen werden (sie setzen bewusst GIT_SUBMODULE_STRATEGY:none, wollen keine Submodule).\n- Token-Wert NIE im yaml hartkodieren — nur \${CE_SUBMODULE_USER}/\${CE_SUBMODULE_TOKEN}-Referenzen.\n- Muss robust gegen das before_script/extends-Clobbering sein: wenn ci-templates-Build-Jobs eigene before_script haben, wird ein super default:before_script fuer sie ignoriert. Beruecksichtige das (z.B. muss der manuelle Submodul-Klon so platziert werden, dass er greift — via hooks.pre_get_sources_script kann man NICHT klonen (Repo noch nicht da), aber man kann dort die insteadOf-Config setzen die dann der Auto-Fetch NUTZT falls GIT_SUBMODULE_STRATEGY!=none; ODER GIT_SUBMODULE_STRATEGY:none + Klon in einem Step der sicher laeuft).\n\nBeachte: falls das Investigation-Ergebnis zeigt, dass GIT_SUBMODULE_FORCE_HTTPS die insteadOf umgeht, ist evtl. die SAUBERSTE Loesung: GIT_SUBMODULE_FORCE_HTTPS entfernen/false + die insteadOf im pre_get_sources_script (die dann fuer den Auto-Fetch greift, weil GitLab dann die relative URL nicht selbst mit CI_JOB_TOKEN umschreibt). Pruefe DIESE Alternative explizit gegen die STRATEGY:none+manuell-Alternative und waehle die robustere/wartbarere (Direktive: sauberste, nicht einfachste Loesung).\n\nINVESTIGATION:\n${investText}`,
  { label: 'synth:diff', phase: 'Synthesize', schema: DIFF_SCHEMA },
)

phase('Refute')
const REFUTE_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['refuted', 'breaks_which_job', 'reasoning', 'fix_suggestion'],
  properties: {
    refuted: { type: 'boolean', description: 'true wenn der Fix einen Job bricht oder nicht funktioniert' },
    breaks_which_job: { type: 'string' },
    reasoning: { type: 'string' },
    fix_suggestion: { type: 'string', description: 'Falls refuted: wie zu korrigieren' },
  },
}
const lenses = [
  'Lint-Jobs: bricht/verlangsamt der Fix lint:secrets/format/static (die GIT_SUBMODULE_STRATEGY:none wollen)? Wird ihnen ungewollt ein Submodul-Klon aufgezwungen?',
  'before_script/extends-Clobbering: definieren die ci-templates-Build-Jobs (.build-clang-latest, .test, .toolchain-probe) eigene before_script, sodass ein super default:before_script fuer sie IGNORIERT wird und der Submodul-Klon dort NICHT laeuft -> Build failt weiter?',
  'Auth-Mechanik: greift die insteadOf-Credential (Deploy-Token) beim tatsaechlichen (Auto- oder manuellen) rekursiven Submodul-Update wirklich? Oder wird sie erneut umgangen wie in den 2 Vorversuchen?',
]
const draftStr = JSON.stringify(draft, null, 1)
const verdicts = await parallel(lenses.map((lens, i) => () =>
  agent(`Adversariale Widerlegung des vorgeschlagenen super-CI-Submodul-Fixes durch die LINSE: "${lens}". Default refuted=true bei Unsicherheit. Lies bei Bedarf ${CITEMPL} (READ-ONLY) und ${SUPER}/.gitlab-ci.yml.\n\nVORGESCHLAGENER FIX:\n${draftStr}`,
    { label: `refute:${i}`, phase: 'Refute', schema: REFUTE_SCHEMA })))

return {
  draft,
  investigation: investText,
  refutations: verdicts.filter(Boolean),
  survives: verdicts.filter(Boolean).filter(v => v.refuted).length === 0,
}
