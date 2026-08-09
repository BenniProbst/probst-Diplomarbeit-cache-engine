# INFRA-HANDOVER 09.08.2026 -- GitLab-Instanz: HTTP 500 auf ALLEN authentifizierten Pfaden

**Rolle:** Diplomarbeit-Implementierungsagent (Cluster nur lesend, kein Infra -- deshalb Handover).
**Gemessen:** 2026-08-09 zwischen 05:45Z und 06:21Z, von prod1 (10.0.10.211), CA host-scoped
`Cluster/keys/gitlab-ca-ROOTCA-20260621.crt`.

## Befund in einem Satz

`gitlab.comdare.local` beantwortet JEDEN Request, der ein Token traegt, mit **HTTP 500** --
API und git-over-https gleichermassen -- waehrend alle anonymen Pfade gesund antworten.
Die Instanz laeuft; ihr **Auth-/Token-Validierungs-Subsystem reisst**.

## Literale Messungen (alle von prod1, cacert wie oben)

| Request | Auth | HTTP |
|---|---|---|
| `GET /` | anonym | 302 (auf sign_in -- normal) |
| `GET /-/readiness` | anonym | 200 |
| `GET /api/v4/version` | anonym | 401 (normal: auth verlangt) |
| `GET /api/v4/projects/288` | anonym | 404 (normal: privat) |
| `GET /api/v4/version` | PRIVATE-TOKEN (Store-Token, len 51) | **500** |
| `GET /api/v4/version` | Authorization: Bearer (dasselbe Token) | **500** |
| `GET /api/v4/user` | PRIVATE-TOKEN (Vault-glpat, 5 Kandidaten) | **5x 500** |
| `GET /api/v4/user` | PRIVATE-TOKEN (Vault-glpat, 3 aeltere Kandidaten) | 3x 401 (rotiert/alt -- Endpunkt selbst funktioniert also) |
| `git ls-remote origin` (https, Store-Credential) | Basic | **fatal: error: 500** |

Token-Handling strikt nach Vault-Doktrin: blind extrahiert (mapfile, Laengen-Selektion),
nie ausgegeben, rueckwaerts getestet; nur HTTP-Codes im Protokoll.

## Zeitfenster

- Letzter ERFOLGREICHER Push nach origin/development: **2026-08-09 01:05:46Z**
  (abfb96db, per lokalem Remote-Ref-Reflog belegt).
- Erste 500-Messung: 2026-08-09 ~05:45Z. Beginn des Ausfalls also zwischen 01:06Z und 05:45Z.

## Interpretation (Hinweis, kein Verdikt -- Infra prueft)

401 fuer alte Tokens neben 500 fuer juengere deutet auf einen Riss in der
Token-Validierung selbst (z. B. secrets-/db-key-Mismatch nach Restore oder Rotation:
Entschluesselung wirft, statt sauber abzulehnen). Anonyme Pfade und readiness sind gruen,
es ist also KEIN genereller Ausfall von Rails/HAProxy.

## Auswirkung auf die Diplomarbeit-Straenge

1. **Push -> gruen verifizieren** ist fuer alle Pushes seit 08.08. abends NICHT belegbar
   (kein API-Zugriff); betroffen mindestens: 4e0b7e0d (W0b-1/D3-3), ca901c50, 3b13bf4a,
   9686dba4, 1a657413, b566bc8f, abfb96db.
2. **fetch/push nach origin ist blockiert** (git-over-https 500) -- Landungen erreichen
   derzeit nur github.
3. **Modus a reaktiviert** (User-GO 13.07., Reaktivierungsklausel): lokal doppelt-literal
   verifizieren, beide Remotes pushen soweit erreichbar, CI-gruen zieht BATCH nach,
   sobald die Instanz-Auth zurueck ist. Die Batch-Schuld ist im Ledger vermerkt.

## Bitte an Infra

- Rails-Logs (`production.log`, `api_json.log`) im Fenster ab 01:06Z auf die 500er ziehen;
  Verdachtsbereich Token-Decrypt (`OpenSSL::Cipher::CipherError` o. ae.).
- Nach Heilung kurze Rueckmeldung, damit die CI-Gruen-Batch-Verifikation nachgezogen wird.
