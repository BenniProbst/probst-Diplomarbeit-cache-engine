export const meta = {
  name: 'secure-measurement-push-token-design',
  description: 'Deep-Research: sicherheits-maximale, projekt-spezifische, minimal-scoped, rotierbare Credential-Loesung fuer den CI-Auto-Push der Messwerte nach development (#22), getrennt vom Admin-PAT',
  phases: [{ title: 'Research' }, { title: 'Design' }, { title: 'Refute' }],
}
const SUP = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const COMMON = `KONTEXT: Der #22-persist:measurements-CI-Job (super/.gitlab-ci.yml, INERT-by-default) soll am Pipeline-Ende die Auswertungsdokumente in measurement/<datiert>/ committen und per MERGE+push nach development ZURUECKSCHREIBEN. Er nutzt CI-Vars COMDARE_WRITEBACK_USER/COMDARE_WRITEBACK_TOKEN (masked+protected). USER-DIREKTIVE 2026-07-11: ein SEPARATER, PROJEKT-SPEZIFISCHER Token (NICHT der Admin/Master-PAT, damit der Admin-PAT unabhaengig rotierbar bleibt), MINIMAL gescoped NUR fuer den Messwert-Push, Sicherheit MAXIMIEREN. Umgebung: self-managed GitLab (gitlab.comdare.de), Projekt super = comdare/research/probst-diplomarbeit-cache-engine (ID via API ermittelbar), Ziel-Branch development (protected? pruefen). Bestehend: ein Group-Deploy-Token gitlab+deploy-token-39 (read_repository, comdare/research) fuer den Submodul-FETCH — reicht NICHT fuer push (read-only). Loop-Schutz im Job: push -o ci.skip + [skip ci] + rules _bot_->never.`

phase('Research')
const DIM = [
  {
    key: 'gitlab-mechanismen',
    prompt: `${COMMON}\n\nAufgabe: recherchiere die GitLab-NATIVEN Credential-Mechanismen fuer einen CI-Job, der git-over-HTTPS auf einen (moeglicherweise protected) Branch PUSHEN muss, gerankt nach SICHERHEIT (least privilege, blast radius, Rotierbarkeit, Ablauf). Vergleiche konkret: (1) Project Access Token (Scope write_repository, Rolle? Developer reicht fuer protected-push nur wenn allowed_to_push; Maintainer sonst) — projekt-lokale Bot-Identitaet, unabhaengig vom Admin-PAT rotierbar, mit expires_at; (2) Project Deploy Token (write_repository) — projekt-lokal, aber KANN Deploy-Tokens auf protected branches pushen? (Einschraenkungen); (3) Group Access Token; (4) dedizierter Bot-User mit Projekt-Mitgliedschaft + PAT; (5) CI_JOB_TOKEN (kann NICHT auf protected branches pushen — warum, und aendert das die Protected-Konfiguration?). Fuer JEDEN: minimaler Scope, blast-radius-bei-Leak, Rotation, expires_at, ob write_repository ausreicht (kein api-Scope noetig fuer reinen git push). Nenne die self-managed-GitLab-Verfuegbarkeit (Free vs. Premium/Ultimate) je Mechanismus. Beziehe GitLab-Doku-Wissen ein.`,
  },
  {
    key: 'least-privilege-haertung',
    prompt: `${COMMON}\n\nAufgabe: recherchiere die SICHERHEITS-HAERTUNGEN, die den blast-radius eines Push-Credentials fuer NUR-Messwert-Push minimieren (defense-in-depth), gerankt: (1) Protected-Branch push-allowlist: nur die Bot-Identitaet darf development pushen (allowed_to_push = nur der Token/Bot; force-push aus); (2) Push Rules (GitLab Premium/Ultimate?) — commit-message-Regex, author-mail-Restriktion, file-path-Restriktion (NUR measurement/** darf committet werden → selbst bei Leak nur measurement/ berührbar), max file size; (3) CI/CD-Variable-Haertung: masked (glpat-Format maskierbar? Punkte), protected (nur auf protected branches sichtbar → nur development-Pipelines, nie Feature-Branch-Leak), environment-scope; (4) expires_at + Rotationsplan; (5) job-token-scope/allowlist; (6) CODEOWNERS/approval. Welche dieser Haertungen sind auf self-managed FREE verfuegbar, welche brauchen Premium? Was ist der REST-Angriffsvektor nach allen Haertungen? Belege mit GitLab-Doku-Wissen.`,
  },
  {
    key: 'ist-stand-gitlab',
    prompt: `${COMMON}\n\nAufgabe: ermittle den IST-Stand via GitLab-API (der Master-Token in ~/.git-credentials hat admin/sudo — ABER wir wollen ihn NICHT als Push-Credential; nur zum EINMALIGEN Anlegen des projekt-spezifischen Tokens + Konfig). Frage: (a) GitLab-Version + Tier (Free/Premium/Ultimate) von gitlab.comdare.de — curl /api/v4/version + /api/v4/metadata; (b) super-Projekt-ID + ist development ein PROTECTED branch (/projects/:id/protected_branches) + wer darf pushen; (c) existieren schon Project Access Tokens / Deploy Tokens im super-Projekt (/projects/:id/access_tokens, /deploy_tokens) — Namen/Scopes, ohne Werte; (d) sind Push Rules verfuegbar (/projects/:id/push_rule) — Tier-Indikator; (e) die bestehenden CI-Vars CE_SUBMODULE_*/COMDARE_WRITEBACK_* (Flags masked/protected). Token token-sicher aus 'git credential fill' ziehen, NIE ausgeben. Gib die konkreten Fakten zurueck, die die Loesung determinieren.`,
  },
]
const research = await parallel(DIM.map(d => () => agent(d.prompt, { label: `res:${d.key}`, phase: 'Research' })))
const researchText = DIM.map((d, i) => `### ${d.key}\n${research[i] || '(kein Ergebnis)'}`).join('\n\n')

phase('Design')
const SCHEMA = { type: 'object', additionalProperties: false,
  required: ['recommended_token_type', 'rationale', 'creation_steps', 'hardening_layers', 'residual_risk', 'rotation_plan', 'ci_var_config'],
  properties: {
    recommended_token_type: { type: 'string', description: 'z.B. Project Access Token write_repository (Developer + protected-branch allowed_to_push), NICHT Admin-PAT' },
    rationale: { type: 'string', description: 'Warum diese Wahl sicherheits-maximal + admin-PAT-unabhaengig rotierbar + minimal-scoped' },
    creation_steps: { type: 'array', items: { type: 'string' }, description: 'Exakte API/curl-Schritte (mit dem Master-Token EINMALIG) zum Anlegen — token-sicher, Wert nie echoen; scope, role, expires_at' },
    hardening_layers: { type: 'array', items: { type: 'string' }, description: 'defense-in-depth: protected-branch-allowlist, push-rules-path-restrict (falls Tier), masked+protected CI-Var, expires_at — je mit Tier-Verfuegbarkeit' },
    residual_risk: { type: 'string', description: 'Rest-Angriffsvektor nach allen Haertungen + dessen Begrenzung' },
    rotation_plan: { type: 'string', description: 'Wie der projekt-Token unabhaengig vom Admin-PAT rotiert wird (expires_at + Neuanlage-Prozedur)' },
    ci_var_config: { type: 'string', description: 'Exakte CI-Var-Konfig: COMDARE_WRITEBACK_USER (Wert) + COMDARE_WRITEBACK_TOKEN (masked+protected), + development als protected branch' },
  } }
const design = await agent(
  `${COMMON}\n\nSynthetisiere die SICHERHEITS-MAXIMALE, projekt-spezifische, minimal-scoped, admin-PAT-unabhaengig rotierbare Loesung fuer den #22-Messwert-Push aus der Research. Prinzip: least privilege + defense-in-depth. Der Token darf NUR das koennen, was der persist-Job braucht (git push nach development, idealerweise nur measurement/**-Pfade). Konkret + umsetzbar auf dem ermittelten GitLab-Tier. Wenn eine Haertung Premium braucht + der Tier Free ist, nenne die beste Free-Alternative.\n\nRESEARCH:\n${researchText}`,
  { label: 'design', phase: 'Design', schema: SCHEMA })

phase('Refute')
const RS = { type: 'object', additionalProperties: false, required: ['refuted', 'issue', 'fix'], properties: { refuted: { type: 'boolean' }, issue: { type: 'string' }, fix: { type: 'string' } } }
const lenses = [
  'Least-Privilege: ist der Token WIRKLICH minimal (kein api-Scope, kein Admin, projekt-lokal, kein group-weiter Zugriff)? Kann er mehr als measurement-Push (z.B. andere Branches/force-push/Repo-Loeschung)?',
  'Rotation/Unabhaengigkeit: ist der Token WIRKLICH unabhaengig vom Admin-PAT (Admin kann seinen PAT rotieren ohne den Push zu brechen)? Hat er expires_at?',
  'Leak/blast-radius: bei Token-Leak (Log/CI-Var) — was ist der Schaden? Greifen masked+protected + protected-branch-allowlist + (falls Tier) path-push-rule? Ist der Rest-Vektor akzeptabel?',
]
const dStr = JSON.stringify(design, null, 1)
const verds = await parallel(lenses.map((lens, i) => () => agent(`Adversariale Sicherheits-Pruefung der Push-Token-Loesung, LINSE: "${lens}". Default refuted=true bei Sicherheits-Zweifel. GitLab-Doku-Wissen + ${SUP}/.gitlab-ci.yml.\n\nLOESUNG:\n${dStr}`, { label: `refute:${i}`, phase: 'Refute', schema: RS })))
return { design, research: researchText, refutations: verds.filter(Boolean), survives: verds.filter(Boolean).every(v => !v.refuted) }
