export const meta = {
  name: 'plan-46a-53-cache-ci',
  description: 'Planungs-Workflow: #46a Minimal-Cache (minio+Stempel-Lookup) + #53 CI-Durchsatz — Design, Inventar, Risiko, Synthese',
  phases: [
    { title: 'Analyse', detail: '3 parallele Kartierungen (Cache-Naht, CI-Durchsatz, Risiko/TABU)' },
    { title: 'Synthese', detail: 'Umsetzungs-Dossier fuer den Impl-Agenten' },
  ],
}
const CE = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine'
const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const FINDINGS = {
  type: 'object', additionalProperties: false,
  properties: {
    befunde: { type: 'array', items: { type: 'object', additionalProperties: false, properties: {
      titel: { type: 'string' }, datei_zeile: { type: 'string' }, ist: { type: 'string' }, vorschlag: { type: 'string' }, risiko: { type: 'string' } }, required: ['titel','datei_zeile','ist','vorschlag','risiko'] } },
    offene_fragen: { type: 'array', items: { type: 'string' } }
  }, required: ['befunde','offene_fragen']
}
phase('Analyse')
const [cache, ci, risiko] = await parallel([
  () => agent(`Du kartierst READ-ONLY den Ist-Stand fuer ein MINIMAL-CACHE-Paket (#46a) in der comdare-cache-engine (${CE}).
ZIEL: Binary-Ablage auf minio.comdare.de + STEMPEL-basierter Remote-Lookup vor jedem DLL-Bau (Treffer=Bau-Skip, Miss=bauen+async PUT). KEINE Locks/Claims (Ein-Wellen-Betrieb).
KARTIERE mit datei:zeile: (1) artifact_cache.hpp — from_env()-Gates, curl_put, mc-cp-Pfad, die No-Op-Naht; wie wird sie heute (nicht) aufgerufen? (2) dll_is_current (profile_run_facade.cpp) — exakter Erweiterungspunkt fuer einen Remote-GET-Fallback (lokal fehlt -> Cache-GET per Schluessel -> Sidecar schreiben -> skip); welche Sidecars (.algos, version) muessen mitgeholt werden? (3) Der vollstaendige Stempel-Schluessel einer perm.so heute: binary_id + build_version-Bestandteile (Perm [d,e,f]x[g,h,i], +bt=Debug-Suffix, Tooling _M-Stempel) — aus welchen Funktionen ist ein deterministischer Objekt-Key (z.B. <bucket>/<binary_id>/<build_version_hash>/perm.so) ableitbar? (4) Wo laeuft der async-PUT am besten (W11-Doktrin: async NUR fuer minio-Push)? (5) Wie kommen minio-Creds in CI-Jobs UND bare-metal (Env-Namen NUR benennen, NIEMALS Werte/Secrets ausgeben)?
Liefere prazise Befunde als Strukturdaten. Kein Schreiben, keine Commits.`, { label: 'cache-naht', phase: 'Analyse', schema: FINDINGS }),
  () => agent(`Du kartierst READ-ONLY den CI-DURCHSATZ (#53) im super-Repo (${SUPER}, .gitlab-ci.yml, ~900 Zeilen).
ZIEL: Die Pipeline muss schneller durchlaufen; heute erzeugt JEDER docs-Commit (Ledger/Sessions) eine volle Welle, und die Tier-Chunk-Flut staut die 2 Bare-Metal-Runner.
KARTIERE mit datei:zeile: (1) Welche Jobs koennten ein rules:changes-Gate fuer docs-only-Commits bekommen (docs/**, *.md) — und welche NICHT (Gitlink-Bumps Code/external/* sind NIE docs-only!)? Nenne die konkrete rules-Syntax je Job-Gruppe/Template. (2) Auto-Cancel: warum cancelt super Zwischenwellen nicht (Projekt-Setting auto_cancel_pending_pipelines? interruptible-Flags je Job?)? (3) Wo ist die Tier-Chunk-Zahl/Groesse definiert (Emitter-seitig im ce ODER YAML) und wie verhaelt sie sich zu 2 Bare-Metal-Runnern (29 pending im Smoke 11991)? (4) ccache: welche Jobs nutzen es, wo fehlt Waerme (cache:-Bloecke)? (5) Welche Jobs der super-Welle sind die Langlaeufer (lint:format 180s etc.) und welche liessen sich per needs entkoppeln?
Liefere praezise Befunde als Strukturdaten. Kein Schreiben.`, { label: 'ci-durchsatz', phase: 'Analyse', schema: FINDINGS }),
  () => agent(`Du bist der RISIKO-/TABU-Pruefer fuer zwei geplante Pakete im Projekt (${SUPER} + ${CE}):
(A) #46a Minimal-Cache: Remote-Stempel-Lookup vor DLL-Bau + minio-PUT. (B) #53 CI-rules-Aenderungen (docs-only-Gate, auto-cancel, Chunk-Tuning).
PRUEFE ADVERSARIAL mit datei:zeile: (1) golden-/Byte-Stabilitaet: Welche Tests/Wachen (CRC 0xF1C1F26A1232073B, test_permutation_codegen_byte_identity_smoke, TierBuildIsProvisionOnly...=48, CMakeTextIsByteDeterministic) wuerden durch einen Cache-Lookup-Einbau in dll_is_current oder durch YAML-rules-Aenderungen brechen? (2) Falsch-Treffer-Risiko: kann ein Stempel-Key kollidieren (Debug vs Release, Tooling-Combos, Merge-Stempel fehlt noch!) — was MUSS in den Key? (3) Dual-Weg: funktioniert der Lookup auch bare-metal ohne CI (Env-Gates)? (4) Mess-Validitaet: darf eine aus dem Cache geholte .so gemessen werden (Plattform-/Hardware-Identitaet §62-D: Binaries per Stempel zwischen ALLEN Maschinen teilbar — bestaetige das gegen den Ledger §62)? (5) docs-only-Gate: welche Pipelines-Pflichten (GESAMTE Pipeline hart gruen-Doktrin) koennten durch geskippte Jobs verletzt wirken? Liefere Befunde als Strukturdaten. Kein Schreiben.`, { label: 'risiko-tabu', phase: 'Analyse', schema: FINDINGS }),
])
phase('Synthese')
const dossier = await agent(`Du bist der Architektur-Synthesizer. Erstelle aus den drei Analyse-Ergebnissen ein UMSETZUNGS-DOSSIER fuer das vorgezogene Paket #46a+#53 (Ledger §63-Nachtrag: CI/Caching VOR dem 320er; Kadenz: kleine verifizierbare Scheiben, Dual-Weg, cf22, golden-neutral).
ANALYSE CACHE-NAHT: ${JSON.stringify(cache)}
ANALYSE CI-DURCHSATZ: ${JSON.stringify(ci)}
ANALYSE RISIKO/TABU: ${JSON.stringify(risiko)}
Liefere als Text: (1) Scheiben-Schnitt (3-5 Scheiben, je mit Dateien/Einfuegepunkten datei:zeile, Tests, Byte-Stabilitaets-Wachen); (2) den Objekt-Key-Vorschlag (deterministisch aus Stempeln, kollisionsfrei inkl. +bt/Tooling; Merge-Stempel-Reserve); (3) die konkreten YAML-rules-Diffs fuer docs-only (mit Gitlink-Ausnahme!); (4) Risiken mit Gegenmassnahme; (5) was BEWUSST NICHT in #46a gehoert (Claims/Locks/Sub-Lanes = #46b). Kompakt, direkt als Impl-Auftrag verwendbar.`, { label: 'synthese-dossier', phase: 'Synthese', effort: 'high' })
return { dossier, offene_fragen: [...cache.offene_fragen, ...ci.offene_fragen, ...risiko.offene_fragen] }