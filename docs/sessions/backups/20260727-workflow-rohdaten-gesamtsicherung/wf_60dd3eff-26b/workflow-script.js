export const meta = {
  name: 'buildsystem-two-cache-storage-final-vor',
  description: 'VOR (FINAL): Buildsystem-Ziele + CE-Rolle; CEB/Tier-Binaries->minio.comdare.de, Messergebnisse->NFS prod-HDDs (HA-Proxy .1-SNI VLAN10), CI/Standard->GitLab-Cache dev; sequentiell nie parallel zur Messung; CE-Seite Code / Infra Handover',
  phases: [
    { title: 'Kartierung', detail: '3 Kartierer: Buildsystem-Ziele / CE-Artefakt+Mess-Ausgabe-Nähte / Infra-Grenze+VLAN' },
    { title: 'Plan', detail: 'Zwei-Cache-Design + sequentielle Naht + CE-Integration + Infra-Handover' },
  ],
}

const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'

phase('Kartierung')

const readers = [
  {
    label: 'buildsystem-ziele',
    prompt: `Read-only Kartierung: die ZIELE des Buildsystems + wo die Cache Engine sitzt. Lies/grep im ${SUPER}/docs/ + LEDGER (§0-GOAL, rekursive Dock-.so Planer<->CEB<->Tier, E4-XML-Build-Orchestrierung, buildsystem.xml NUR lesen).
ZIEL, datei:zeile: (1) die erklaerten Buildsystem-Ziele + CE-Rolle darin; (2) Grenze Experiment-PLANER (Standard-Compiles: Planer-Binary, ce-Library, CI-Tests) vs CACHE ENGINE (CEB + Tier-Binary-DLLs, viele/gross); (3) was sagt buildsystem.xml/Ziel-Doku ueber Caching/Storage; (4) der Messergebnis-Fluss (measurement/<datiert>/-CSV) — wo entsteht er, wohin geschrieben heute. NUR Kartierung.`,
  },
  {
    label: 'ce-artefakt-mess-naht',
    prompt: `Read-only Kartierung: die NÄHTE, an denen (a) die Tier-Binary/CEB-Artefakte und (b) die Messergebnisse ausgegeben werden. Lies:
  ${CE}/libs/cache_engine/builder/build_orchestrator/build_orchestrator.hpp (dll_dir/src_dir/output_dir, provision_all, .version+result.csv-Ausgabe je Binary, die Bau->Mess-Sequenz)
  ${CE}/libs/cache_engine/profile_facade/profile_run_facade.cpp (out_csv, dll_dir, RunProfileArgs, die Mess-CSV-Ausgabe)
  ${CE}/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp (die Bau->Lade->Mess-Schleife je Binary; wo Bau endet und Messung beginnt)
ZIEL, datei:zeile:
(1) Wohin schreibt die CEB die Tier-Binary-DLLs (dll_dir) + je-Binary-Artefakte (.version/.algos/result.csv)? Konfigurierbar oder lokal?
(2) Wohin die Messergebnis-CSV (out_csv / measurement/<datiert>/)? Konfigurierbar?
(3) Die SEQUENZ je Binary: Bau -> Laden -> MESSEN -> Ergebnis-Schreiben. Wo GENAU koennte ein Cache-Push (Binary->minio) + Ergebnis-Schreib (CSV->NFS) NACH der Messung eingehaengt werden, sodass es NIE PARALLEL zur laufenden Messung laeuft (der User: sequentiell, sonst Messfehler durch I/O-Contention)? Ist die Mess-Schleife schon 1-Thread/sequentiell?
(4) Trennung: Tier-Binary/CEB-Artefakte (->minio) vs Standard-Compile (->CI-Cache) vs Messergebnisse (->NFS) — sind die Ausgabe-Pfade schon getrennt?
NUR Kartierung.`,
  },
  {
    label: 'infra-grenze-vlan',
    prompt: `Read-only Kartierung: die INFRA-GRENZE + die VLAN/SNI/HA-Proxy-Erreichbarkeit. Direktiven: Impl-Agent macht KEINE Infra; Cluster read-only; minio.comdare.de-Provisionierung + NFS-Export prod-6TB-longhorn + HA-Proxy-Route = HANDOVER. Messergebnisse sollen via DNS-.1-SNI per HA-Proxy von VLAN 10 durchsuchbar sein.
Lies/grep im ${SUPER}: .gitlab-ci.yml (MinIO/S3/Cache, Messdaten-Rueckschrieb-Endpoint), Cluster-VLAN/SNI-Doku (.1-VIP+SNI-Muster, minio.comdare.local/.de), Handover-Doku (docs/sessions/), env/CI-Var-Endpoint-Referenzen (NUR Struktur, KEINE Secrets).
ZIEL: (1) nutzt die CI/das Repo heute minio.comdare.local (Endpoint/Bucket/Cred-Referenz)? Geht der Messdaten-Rueckschrieb schon irgendwohin? (2) was ist ueber minio.comdare.de + den NFS-prod-Mount + die DNS-.1-SNI-HA-Proxy-Route-von-VLAN10 bekannt vs ganz neu (=Handover)? (3) CE-SEITE: konfigurierbare Endpoints (env COMDARE_*_ENDPOINT/_CACHE_ROOT) fuer minio-Push (Tier-Binaries) + NFS-Pfad (Messergebnisse), sauber getrennt. (4) INFRA-HANDOVER exakt: minio.comdare.de-Bucket/Zugang, NFS-Export prod-longhorn + Mount, HA-Proxy-.1-SNI-Route VLAN10->prod-NFS, Credentials. NUR Kartierung, KEINE Secrets.`,
  },
]

const maps = await parallel(readers.map(r => () => agent(r.prompt, { label: r.label, phase: 'Kartierung' })))

phase('Plan')

const PLAN_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['buildsystem_goals', 'two_cache_design', 'sequential_write_naht', 'ce_side_integration', 'infra_handover', 'code_changes', 'conformance_verdict', 'open_decisions', 'risks'],
  properties: {
    buildsystem_goals: { type: 'string' },
    two_cache_design: { type: 'string', description: 'CEB/Tier-Binaries->minio.comdare.de; Messergebnisse->NFS prod-HDDs (HA-Proxy .1-SNI VLAN10); Standard-Compiles+CI-Daten->GitLab-Cache dev' },
    sequential_write_naht: { type: 'string', description: 'Wo GENAU Cache-Push (Binary->minio) + Ergebnis-Schreib (CSV->NFS) NACH der Messung eingehaengt wird, NIE parallel (I/O-Contention=Messfehler)' },
    ce_side_integration: { type: 'string', description: 'CE-SEITE Code: konfigurierbare Endpoints, minio-Client-Naht (dll_dir/output), NFS-Mess-Rueckschrieb, gekoppelt an das Algo-Versions-Manifest' },
    infra_handover: { type: 'array', items: { type: 'string' } },
    code_changes: { type: 'array', items: { type: 'object', additionalProperties: false, required: ['file', 'change'], properties: { file: { type: 'string' }, change: { type: 'string' } } } },
    conformance_verdict: { type: 'string' },
    open_decisions: { type: 'array', items: { type: 'string' } },
    risks: { type: 'array', items: { type: 'string' } },
  },
}

const plan = await agent(
  `Du bist der Architekt fuer die Buildsystem-Storage-Trennung. User-Direktive (FINAL 2026-07-18, nach Korrekturen): "die CEB-Compiles und Tier-Binary-Compiles in die minio.comdare.de, aber die Messergebnisse in ein NFS auf den prod-HDDs, damit ich es auf einer DNS-.1-SNI per HA-Proxy von VLAN 10 aus durchsuchen kann. Die uebrigen Bestandteile (Standard-Compiles Experiment-Planer + alle CI-Daten) bleiben normal im gitlab cache auf cluster dev. prod = 6TB longhorn." + "Das Schreiben der Binaries UND Ergebnisse muss SEQUENTIELL zu den Messungen erfolgen und NIE parallel Messfehler erzeugen."

KRITISCHE DIREKTIVE: Impl-Agent (ich) macht KEINE Infra. Cluster read-only. minio.comdare.de-Provisionierung + NFS-Export prod-longhorn + HA-Proxy-.1-SNI-Route = HANDOVER. buildsystem.xml = eigener Agent (nur lesen). Ich baue die CE-SEITE: konfigurierbare Endpoints + die Push/Schreib-Naehte. Kein Python; sauberster Weg. Verwandt: der inkrementelle Rebuild-Cache (wf_911c8162, perm.algos-Sidecar + dll_is_current) — die minio-gecachten Binaries + ihre Sidecars sind, was zwischen Laeufen persistiert.

Drei Kartierungen:

=== BUILDSYSTEM-ZIELE ===
${maps[0]}

=== CE-ARTEFAKT + MESS-NAHT ===
${maps[1]}

=== INFRA-GRENZE + VLAN ===
${maps[2]}

Erstelle den Plan: (a) Buildsystem-Ziele + CE-Rolle; (b) das Zwei-Cache-Design (CEB/Tier-Binaries->minio.comdare.de; Messergebnisse->NFS prod-HDDs HA-Proxy-.1-SNI-VLAN10; Standard-Compiles+CI->GitLab-Cache dev; sauber getrennt); (c) die SEQUENTIELLE Schreib-Naht (Cache-Push + Ergebnis-Schreib NACH der Messung je Binary, NIE parallel zur laufenden Messung — die exakte Stelle in der Bau->Mess-Schleife); (d) die CE-Seite (Code): konfigurierbare Endpoints (env), der minio-Push-Client (Tier-Binary+Sidecar nach Bau/Messung), der NFS-Mess-Rueckschrieb, gekoppelt ans Algo-Versions-Manifest; (e) die Infra-Handover-Liste (minio.comdare.de-Bucket, NFS-Export prod-longhorn+Mount, HA-Proxy-.1-SNI-Route VLAN10, Credentials — exakt fuer ein Handover-Dokument); (f) geordnete CE-Code-Aenderungen; (g) Konformitaets-Verdikt (CE/Infra getrennt, Cluster read-only, kein Python, sequentiell); (h) echte offene Entscheidungen fuer den User; (i) Risiken (v.a. I/O-Contention-Messfehler, minio-Push-Fehlerbehandlung). Wenn eine Kartierung eine Luecke laesst (minio-Config, NFS-Konvention, VLAN-Route), benenne sie EXPLIZIT statt zu raten.`,
  { label: 'synthese', phase: 'Plan', schema: PLAN_SCHEMA, effort: 'high' }
)

return plan
