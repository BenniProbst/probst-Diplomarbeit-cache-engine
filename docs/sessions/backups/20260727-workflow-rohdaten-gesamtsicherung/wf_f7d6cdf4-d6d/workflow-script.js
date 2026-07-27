export const meta = {
  name: 'buildsystem-goals-nfs-rbmm-cache-vor',
  description: 'VOR (korrigiert): Buildsystem-Ziele + CE-Rolle + CEB/Tier-Binary-Compiles -> RBMM-Cache-Hierarchie als NFS auf prod-HDDs; Rest -> GitLab-Cache auf cluster dev; CE-Seite Code / Infra Handover',
  phases: [
    { title: 'Kartierung', detail: '4 Kartierer: Buildsystem-Ziele / RBMM-Hierarchie+NFS / CE-Artefakt-Ausgabe / Infra-Grenze' },
    { title: 'Plan', detail: 'NFS-RBMM-Cache-Design + CE-Integration + Infra-Handover' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

phase('Kartierung')

const readers = [
  {
    label: 'buildsystem-ziele',
    prompt: `Read-only Kartierung: die ZIELE des Buildsystems + wo die Cache Engine (CEB/Tier-Binaries) darin sitzt. Lies/grep:
  ${SUPER}/docs/ (architektur/architecture, E4-XML-Build-Orchestrierung, CEB<->Tier-Dock, buildsystem.xml falls vorhanden — NUR lesen)
  ${SUPER}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (§0-GOAL, rekursive Dock-.so-Architektur Planer<->CEB<->Tier)
ZIEL, exakt datei:zeile:
(1) Die erklaerten ZIELE des Buildsystems + wie die Cache Engine ein TEIL davon ist.
(2) Die Trennung Experiment-PLANER (Standard-Compiles) vs CACHE ENGINE (generiert CEB + Tier-Binaries) — was baut wer, wo die Grenze.
(3) buildsystem.xml / Build-System-Ziel-Dokument: was sagt es ueber Caching/Artefakt-Storage? (nur lesen)
(4) Artefakt-Unterschiede: CEB+Tier-Binaries (viele, gross) vs Standard-Compile (Planer-Binary, ce-Library, CI-Test-Binaries).
NUR Kartierung.`,
  },
  {
    label: 'rbmm-nfs-hierarchie',
    prompt: `Read-only Kartierung: die RBMM-CACHE-HIERARCHIE + wie das NFS-Storage-Layout auf den prod-HDDs strukturiert wird. Der User: "ALLE Ergebnisse, die CEB-Compiles und Tier-Binary-Compiles nach der Hierarchie der RBMM-Cache-Hierarchie als NFS-Dateisystem auf die prod-HDDs (6TB longhorn) schreiben." Grep/lies:
  ${SUPER}/docs/ nach "RBMM" (Treffer u.a. 20260706-274-MATRIX-MIGRATIONSPLAN: "RBMM:399-409, ARCHITECTURE.md:55, Layer4-Zelle Benchmarking/BenchmarkOptimizer"; "RBMM-Konvention" Sub-Engine-Slots C01-C12)
  jede ARCHITECTURE.md / Layer-Architektur-Doku, die die RBMM-Hierarchie / Cache-Hierarchie / Layer-Struktur definiert
ZIEL, exakt datei:zeile:
(1) Was IST die RBMM-Cache-Hierarchie? Wofuer steht RBMM? Wie ist sie strukturiert (Layer/Ebenen/Konvention)? (Nicht raten — aus den Doks belegen; falls unauffindbar, das explizit melden.)
(2) Wie wuerde ein NFS-Verzeichnis-Layout aussehen, das die CEB+Tier-Binary-Artefakte "nach der RBMM-Hierarchie" ablegt? Welche Ebenen/Pfad-Segmente (z.B. nach Achse/Algorithmus/Version/binary_id)?
(3) Passt die RBMM-Hierarchie zur binary_id-/Achsen-Struktur der Tier-Binaries (17 Achsen, Algorithmus+Version je Achse)? Wie mappt man die Tier-Binary-Cache-Ablage auf die RBMM-Ebenen?
(4) Die prod-HDDs (6TB longhorn) als NFS: gibt es dokumentierte Konventionen fuer NFS-Mounts/Pfade auf prod? (nur Struktur, keine Secrets)
NUR Kartierung. Falls RBMM in den zugaenglichen Doks nicht klar definiert ist, melde das als GAP (der Infra-/Architektur-Kontext koennte im read-only Cluster liegen).`,
  },
  {
    label: 'ce-artefakt-ausgabe',
    prompt: `Read-only Kartierung: WIE + WOHIN die Cache Engine ihre Tier-Binaries + CEB-Compiles heute ausgibt (wo der NFS-RBMM-Cache andockt). Lies:
  ${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (dll_dir, src_dir, DLL-Ausgabe, provision_all, dll_is_current, .version-Sidecar)
  ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (out_csv, dll_dir, Ausgabe-Pfade, RunProfileArgs)
ZIEL, exakt datei:zeile:
(1) Wohin schreibt die CEB die Tier-Binary-DLLs heute (dll_dir)? Lokaler build/-Pfad oder konfigurierbar? Wer setzt dll_dir/src_dir?
(2) Welche Dateien entstehen je Tier-Binary (DLL + .version-Sidecar + result.csv)? Und was ist der CEB-Compile-Output (die generierte Quelle + Objekt)?
(3) Wie liesse sich ein NFS-CACHE-WURZELVERZEICHNIS (nach RBMM-Hierarchie strukturiert) additiv als Ausgabe-/Cache-Ziel einziehen — an welcher Naht (dll_dir/src_dir auf den NFS-Cache-Pfad zeigen; pull-from-cache vor Bau / push-to-cache nach Bau)? Ohne Behelfsweg.
(4) Trennung: CEB/Tier-Binary-Artefakte (-> NFS-RBMM-Cache prod) vs Standard-Compile (Planer-Binary, ce-Library -> GitLab-Cache dev) — sind die Ausgabe-Pfade schon getrennt oder muss die Trennung eingezogen werden?
NUR Kartierung.`,
  },
  {
    label: 'infra-grenze',
    prompt: `Read-only Kartierung: die INFRA-GRENZE (CE-Seite-Code vs Infra-Handover). Direktiven: Impl-Agent macht KEINE Infra; Cluster read-only; NFS-Mount/longhorn-PVC/RBMM-Verzeichnis-Provisionierung = HANDOVER. prod = 6TB longhorn HDDs; CI-Cache = GitLab auf cluster dev.
Lies/grep im ${SUPER}:
  vorhandene Handover-/Infra-Doku (docs/sessions/, docs/*handover*)
  wie Messdaten-Rueckschrieb + Pfade/Endpoints heute als env/CI-Var/Handover referenziert (NUR Struktur, keine Secrets)
ZIEL:
(1) Eindeutig CE-SEITE (Code, den ich baue): der Cache-Ablage-Client (Schreiben/Lesen in ein konfigurierbares NFS-Cache-Wurzelverzeichnis nach RBMM-Hierarchie), der konfigurierbare Pfad (env COMDARE_*_CACHE_ROOT o.ae.), das per-Organ-Achse-Algorithmus-Versions-Manifest, der Rebuild-Selector.
(2) Eindeutig INFRA-HANDOVER: NFS-Export der prod-6TB-longhorn-HDDs, der NFS-Mount auf den CI-Runnern/prod, die RBMM-Verzeichnis-Struktur-Bereitstellung, die Trennung dev-GitLab-Cache vs prod-NFS.
(3) Wie uebergibt man das sauber (Handover-Dokument: NFS-Export-Pfad, Mount-Punkt, erwartete Groesse/Retention, RBMM-Layout)? Wo liegen Handover heute?
(4) Konvention, wie CE-Code einen konfigurierbaren Cache-Root-Pfad erwartet (env), sodass der Infra-Agent nur den NFS-Mount bereitstellen muss?
NUR Kartierung. KEINE Secrets.`,
  },
]

const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartierung' })))

phase('Plan')

const PLAN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['buildsystem_goals', 'nfs_rbmm_cache_design', 'ce_side_integration', 'infra_handover', 'code_changes', 'conformance_verdict', 'open_decisions', 'risks'],
  properties: {
    buildsystem_goals: { type: 'string', description: 'Buildsystem-Ziele + CE-Rolle (Planer=Standard-Compile vs CE=CEB/Tier-Binaries)' },
    nfs_rbmm_cache_design: { type: 'string', description: 'CEB+Tier-Binary-Compiles -> RBMM-Cache-Hierarchie als NFS auf prod-HDDs (Verzeichnis-Layout nach RBMM); Rest -> GitLab-Cache auf cluster dev; RBMM-Definition (oder GAP falls unklar)' },
    ce_side_integration: { type: 'string', description: 'CE-SEITE (Code): Cache-Ablage-Client (NFS-Schreib/Lese in RBMM-Layout), konfigurierbarer Cache-Root (env), Naht in build_orchestrator (dll_dir/src_dir), gekoppelt an das Algo-Versions-Manifest' },
    infra_handover: { type: 'array', items: { type: 'string' }, description: 'Infra-Handover (NFS-Export prod-longhorn, Mount, RBMM-Layout-Provisionierung, dev-vs-prod-Trennung)' },
    code_changes: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['file', 'change'], properties: { file: { type: 'string' }, change: { type: 'string' } } } },
    conformance_verdict: { type: 'string', description: 'Konform (CE-Seite Code / Infra Handover getrennt, Cluster read-only, kein Python, sauberster Weg, NFS-RBMM-Trennung sinnvoll)?' },
    open_decisions: { type: 'array', items: { type: 'string' } },
    risks: { type: 'array', items: { type: 'string' } },
  },
}

const plan = await agent(
  `Du bist der Architekt fuer die Buildsystem-Ziele + den NFS-RBMM-Cache. User-Direktive (2026-07-18, KORRIGIERT verbatim): "wir schreiben ALLE Ergebnisse, die CEB-Compiles und Tier-Binary-Compiles nach der Hierarchie der RBMM-Cache-Hierarchie als NFS-Dateisystem auf die prod-HDDs. Die uebrigen Bestandteile bleiben normal im gitlab cache auf cluster dev. Die Cache Engine ist Teil des Buildsystems und schreibt ihre generierten Ergebnisse der CEB und Tier-Binaries in einen ANDEREN Cache als die Standard-Compiles (Experiment-Planer + alle CI-Daten). Auf prod ist genug Platz mit 6TB longhorn HDDs."

Kontext: die Cache Engine generiert bis zu 131.072 Tier-Binary-DLLs (golden N=2^17) + die CEB-Compiles. Diese -> RBMM-Cache-Hierarchie als NFS-Dateisystem auf den prod-6TB-longhorn-HDDs (SEPARATER Cache). Standard-Compiles (Experiment-Planer, ce-Library, CI-Test-Binaries, alle CI-Daten) -> GitLab-Cache auf cluster dev (bestehend). Zusammen mit dem inkrementellen Rebuild (nur geaenderte Achsen-Algorithmen, separater VOR wf_911c8162) macht dieser NFS-RBMM-Cache das grosse golden feasible.

KRITISCHE DIREKTIVE: Impl-Agent (ich) macht KEINE Infra. Cluster read-only. NFS-Export der prod-longhorn-HDDs, der Mount, die RBMM-Verzeichnis-Provisionierung = HANDOVER an den Infra-Agent. buildsystem.xml = eigener Agent (nur lesen). Ich baue die CE-SEITE: den Cache-Ablage-Client (Schreiben/Lesen in ein konfigurierbares NFS-Cache-Wurzelverzeichnis nach RBMM-Hierarchie), den konfigurierbaren Pfad (env), die Naht in build_orchestrator (dll_dir/src_dir). Kein Python; sauberster Weg.

Vier Kartierungen:

=== BUILDSYSTEM-ZIELE ===
${maps[0]}

=== RBMM-HIERARCHIE + NFS-LAYOUT ===
${maps[1]}

=== CE-ARTEFAKT-AUSGABE ===
${maps[2]}

=== INFRA-GRENZE ===
${maps[3]}

Erstelle den Plan: (a) die Buildsystem-Ziele + CE-Rolle; (b) das NFS-RBMM-Cache-Design (CEB+Tier-Binary-Compiles -> RBMM-Cache-Hierarchie-Verzeichnis-Layout als NFS auf prod-HDDs; Rest -> GitLab-Cache dev; die RBMM-Hierarchie-Definition oder ein explizites GAP falls in den zugaenglichen Doks unklar); (c) die CE-Seite (Code): der Cache-Ablage-Client (NFS-Schreib/Lese der Tier-Binaries+CEB-Compiles+Sidecar-Manifest ins RBMM-Layout), der konfigurierbare Cache-Root (env COMDARE_*_CACHE_ROOT), die Naht in build_orchestrator (dll_dir/src_dir auf den NFS-RBMM-Pfad; pull-vor-Bau/push-nach-Bau), gekoppelt an das per-Organ-Achse-Algorithmus-Versions-Manifest (aus wf_911c8162); (d) die Infra-Handover-Liste (NFS-Export prod-6TB-longhorn, Mount-Punkt, RBMM-Layout, dev-vs-prod-Trennung — exakt fuer ein Handover-Dokument); (e) geordnete CE-Code-Aenderungen; (f) Konformitaets-Verdikt (CE-Seite/Infra sauber getrennt, Cluster read-only, kein Python); (g) echte offene Entscheidungen fuer den User (v.a. falls die RBMM-Hierarchie-Definition unklar ist -> welche Struktur); (h) Risiken. Wenn eine Kartierung eine Luecke laesst (RBMM-Definition, .gitlab-ci.yml, NFS-Konvention), benenne sie EXPLIZIT statt zu raten.`,
  { label: 'synthese', phase: 'Plan', schema: PLAN_SCHEMA, effort: 'high' }
)

return plan
