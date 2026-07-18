---
name: reference_super_ci_cannot_fetch_new_ce_submodule_commits
description: "Super-Repo-CI kann NEUE Submodule-Commits (ce UND thesis) nicht fetchen (Job-Token-Scope) — Pointer-Bump auf frisches ce/thesis-Commit failt verify:submodules + test:unit; super lagt bewusst am gecachten Commit. Beim Merge fremder Branches (Thesis-Agent) den Submodul-Pointer prüfen, sonst Grün-Regression"
metadata:
  type: reference
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

## ✅ GELÖST (2026-07-11, super-Pipeline 9791 ci-fix-submodule-deploy-token: verify:submodules GRÜN mit NEUEM ce-Commit 270c6c8c)

**Die WAHRE Ursache (REV 17, per DIAG-Dump Pipeline 9787 bewiesen — die extraheader-Hypothese REV 15/16 war
FALSCH):** Der Runner setzt KEINEN Auth-extraheader (der einzige extraheader ist `X-Gitaly-Correlation-ID`,
harmlos). Der Auth-Fehler kam daher: die 3 `.gitmodules`-URLs sind RELATIV (`../<repo>.git`); sie loesen gegen
`origin` == `CI_REPOSITORY_URL` == `https://gitlab-ci-token:${CI_JOB_TOKEN}@…` auf (Parent-Origin-Vererbung),
UND **`git submodule update --init` schreibt genau diese aufgeloeste CI_JOB_TOKEN-URL in `.git/config`** — es
ueberschreibt JEDES vorher gesetzte `git config submodule.<>.url`-Override. Deshalb wurde immer der CI_JOB_TOKEN
(ohne Cross-Projekt-Klonrecht) benutzt → `HTTP Basic: Access denied … did not contain <sha>`. **Warum REV 13–16
scheiterten:** REV 13/14 (insteadOf) matchten die Prefixe nicht; REV 15/16 (submodule.url-Override + extraheader-
Reset) wurden vom `--init`-Overwrite zunichte gemacht. **Warum 9731/9770 (REV 15) truegerisch gruen waren:** der
Runner-Build-Dir hatte das ALTE ce-Commit (fc855b20) GECACHT → `git submodule update` fand es lokal, fetchte NICHT,
Auth-Pfad nie ausgeuebt. Erst der Bump auf ein NEUES Commit (270c6c8c) erzwang einen echten Fetch und deckte den
Bug auf (Pipeline 9777 rot).

**Der wirksame Fix (super `.gitlab-ci.yml`, REV 17, commit 38d411f):**
1. `variables: GIT_SUBMODULE_STRATEGY: none` → failendes Auto-Fetch in get_sources aus.
2. `default:before_script` (laeuft NACH get_sources): die Deploy-Token-URLs DIREKT in `.gitmodules` setzen
   (nicht in `.git/config` — das ueberschreibt `--init`), dann liest `sync`+`init` sie:
   ```
   for spec in "Code/external/comdare-cache-engine:comdare-cache-engine" \
               "Code/external/comdare-prt-art:comdare-prt-art" \
               "thesis/diplomarbeit:20260931-overleaf-diplomarbeit"; do
     p="${spec%%:*}"; r="${spec##*:}"
     git config -f .gitmodules "submodule.${p}.url" "https://${CE_SUBMODULE_USER}:${CE_SUBMODULE_TOKEN}@${CI_SERVER_HOST}/comdare/research/${r}.git"
   done
   git submodule sync --recursive
   git submodule update --init --recursive
   git checkout -- .gitmodules   # ephemeren Rewrite restaurieren (sauberer Work-Tree)
   ```
   Guard `if [ -f .gitmodules ] && git rev-parse --is-inside-work-tree` schuetzt Repo-lose Jobs (toolchain:probe).
   Lint-Jobs erben den Block NICHT (eigenes `.lint-base`-before_script) → submodul-frei.
Deploy-Token = Group-Deploy-Token `gitlab+deploy-token-39` (read_repository, `comdare/research`, deckt 286/287/289),
maskierte super-CI-Vars `CE_SUBMODULE_USER`/`CE_SUBMODULE_TOKEN` (masked=True, protected=False). NIE das Token-Value
committen/ausgeben. `ci-templates` UNBERUEHRT.

**FOLGE: super KANN jetzt NEUE ce/prt-art/thesis-Commits fetchen** → der ce-Gitlink darf/soll vorwaerts gebumpt
werden (die alte „Gitlink-Lag"-Behelfsregel ist RETIRED). Der ganze Mess→PDF-Fluss laeuft durch
(verify:submodules → analyse → … → thesis:pdf); s. [[feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert]].
`toolchain:probe` flakt gelegentlich (Runner-Instabilitaet, allow_failure=false) — Infra-Flake, 1× retrien
([[reference_ci_runner_ice_cold_cache_instability]]). Test-Branch `ci-fix-submodule-deploy-token` nach Voll-Gruen
nach development bringen (je-Repo-GO fuer Branch-Loeschung).

---

## HISTORIE (Fehl-Hypothesen 10.–11.07., superseded von ✅ GELÖST oben)

**Befund (2026-07-10, super Pipeline 9419):** Ein Bump des ce-Submodule-Pointers im super-Repo
(`Code/external/comdare-cache-engine`, relative URL `../comdare-cache-engine.git`) auf ein **neues**
ce-Commit lässt die super-CI failen: `verify:submodules` UND `test:unit` brechen im get_sources ab mit
`HTTP Basic: Access denied ... Authentication failed for comdare-cache-engine.git ... did not contain
<sha>. Direct fetching of that commit failed.` Der CI-Runner hat nur das **vorherige** ce-Commit gecacht
und darf neue nicht ziehen = **cross-project CI-Job-Token-Scope** (GitLab-Projekt-Setting, INFRA — kein Code).

**Regel:** Den ce-Submodule-Pointer im super-Repo **NICHT** bei jedem ce-Increment bumpen. Super lagt bewusst
am zuletzt CI-fetchbaren ce-Commit (z. B. c022ce05). Die ce-Code selbst lebt sicher auf ihren eigenen Remotes
mit eigener grüner Pipeline; der Bump ist rein kosmetisch für den super-Gitlink. Wenn ein Bump versehentlich
CI rot macht → **forward `git revert`** des Bump-Commits (keine History-Rewrite), beide Remotes, CI grün
verifizieren.

**GILT AUCH FÜR DAS thesis-Submodul (2026-07-11, super Pipelines 9393→9427 rot):** Der Thesis-/Habich-Text-Agent
bumpte auf `main` das `thesis/diplomarbeit`-Submodul (`20260931-overleaf-diplomarbeit.git`) auf frische Commits
(8a3f502 → 1a0a6eb) → super-`main` seit Pipeline 9393 (10.07. 22:26) DURCHGEHEND ROT mit exakt demselben
`HTTP Basic: Access denied … did not contain <sha>. Direct fetching failed.` in verify:submodules + test:unit.
Letzte grüne main-Pipeline war 9389 (thesis noch fetchbar). **Cross-Agent-Lehre:** Beim `git merge origin/main`
(Thesis-Strom) in mein `development` (Code-Strom) zog der Merge den unfetchbaren thesis-Bump herein und
regredierte development von grün (9463, thesis 838bf3fc) auf rot → gefixt per **thesis-Pointer-Lag auf 838bf3fc**
(`git update-index --cacheinfo 160000,<sha>,thesis/diplomarbeit`, alle Habich-TEXTE additiv behalten, nur der
Gitlink laggt). **REGEL:** Nach jedem Merge eines fremden Branches den Submodul-Pointer (`git ls-tree HEAD
<pfad>`) gegen den zuletzt CI-fetchbaren prüfen, sonst erbt man fremde CI-Regressionen. Fremde Autoritäts-Branch
(main = Thesis-Domäne) NICHT eigenmächtig auf gelaggten Pointer zurückzwingen — nur den eigenen (development)
grün halten und die Cross-Agent/Infra-Ursache dem User flaggen.

**⚠️ URSACHEN-KORREKTUR (2026-07-11, Admin-API-verifiziert): NICHT die Allowlist.** Mit dem Cluster-Vault-Admin-Token
(root) live geprüft: super(288) ist BEREITS in den inbound-Job-Token-Allowlists von ce(286) UND thesis(289); meine
ce-Commits (z.B. 22ddf94c) LIEGEN in gitlab-ce(286). TROTZDEM failt der super-CI-Bump auf 22ddf94c identisch
(`Authentication failed … did not contain … Direct fetching failed`, super-Pipeline 9559). ⇒ Die Allowlist ist gesetzt
und NICHT der Fix. Die echte Ursache ist der **frische Submodul-Fetch-Auth am Runner**: der Runner hat nur den ALTEN
Commit (c022ce05) im persistenten Build-Dir/Submodul-Cache (viele grüne Läufe); neue Commits brauchen einen frischen
`git fetch`, dessen `gitlab-ci-token:CI_JOB_TOKEN`-Auth abgelehnt wird (vermutlich stale Credential im gecachten
Submodul-`.git/config`, den `GIT_SUBMODULE_FORCE_HTTPS` nicht überschreibt). **KANDIDATEN-FIX (zu testen, Runner-Domäne):**
`GIT_STRATEGY: clone` im super-CI (erzwingt frischen Klon inkl. Submodul-Cache-Purge) ODER Runner-Build-Dir/Cache
leeren. Test sauber auf ISOLIERTEM super-Branch (nicht main/development rot machen). thesis-Sonderfall bleibt: thesis-
Commit 1a0a6eb fehlt ZUSÄTZLICH ganz in gitlab-thesis(289)=404 (Thesis-Agent-Push-Gap; nur er kann ihn pushen).
Zusatzfakt: NIE super rot lassen (viele Agenten remote, immer sauber mergen) → bei fehlgeschlagenem Bump sofort
forward-revert auf den fetchbaren Lag-Stand.

**⚠️ ENDGÜLTIGER BEFUND (2026-07-11, Test-Branch `ci-test-ce-bump`, super-Pipeline 9577 ROT, Admin-API-verifiziert):**
`GIT_STRATEGY: clone` ist NICHT der Fix — es macht es SCHLIMMER. Mit clone failt der Frischklon an **ALLEN DREI**
Submodulen (ce 286, prt-art 287, thesis 289) mit `remote: HTTP Basic: Access denied … Authentication failed for
'…/comdare-prt-art.git/'` (get_sources bricht ab). Admin-API bestätigt gleichzeitig: die inbound-`job_token_scope`-
Allowlists sind für ALLE DREI korrekt gesetzt (`{inbound_enabled:true}` + super(288) ∈ Allowlist von 286 UND 287 UND
289). ⇒ **Die Allowlist ist vollständig korrekt und trotzdem wird der CI_JOB_TOKEN beim Cross-Projekt-Submodul-Klon
per HTTP-Basic ABGELEHNT.** Das ist kein Allowlist- und kein CI-YAML-Problem mehr, sondern **Runner-/Instance-Ebene**
(Kandidaten: Instance-Setting „CI/CD job token allowlist / limit access", Runner-Credential-Injection-Bug, oder die
Submodul-URL-Rewrite-Auth `gitlab-ci-token:$CI_JOB_TOKEN` greift beim rekursiven Submodul-Update nicht). **HARTE
REGEL bekräftigt:** super-ce-Gitlink BLEIBT auf dem letzten CI-fetchbaren Commit **c022ce05** gelaggt; NICHT bumpen,
bis Infra den Runner-Token-Fix liefert. Der Test-Branch `ci-test-ce-bump` (isoliert, rot) ist ein Diagnose-Artefakt —
Löschung braucht je-Repo-User-GO ([[feedback_remote_deletion_requires_explicit_user_authorization]]).

**⚠️ `branch=development`-Tracking LÖST ES NICHT (2026-07-11, verifiziert).** Der User selbst bumpte den ce-Gitlink
per `cc4582a` (c022ce05→22ddf94c) + ergänzte `.gitmodules branch=development` für alle 3 Submodule — super-Pipeline
9589 (cc4582a) failte trotzdem an get_sources. Mein anschließender Merge (super `ccf960f`, ce-Gitlink=dd0fe177, mit
P0–P5) → super-Pipeline **9601 ebenfalls FAILED** an `verify:submodules`+`test:unit`, identisch `remote: HTTP Basic:
Access denied … clone of comdare-cache-engine.git … failed. Retry scheduled`. Die **ce-EIGENE** Pipeline für exakt
diese Commits ist GRÜN (9537 für 22ddf94c, **9597 für dd0fe177 = success**) — nur super kann sie nicht klonen. ⇒ der
Fetch-Auth-Block ist **Runner-/Instance-Ebene**, `branch=development` ändert nichts.
**NEUE LAGE (User-getrieben):** Der User treibt den ce-Pointer bewusst VORWÄRTS (Lag-Auflösung, „track development",
„merge autonom") und AKZEPTIERT super-CI-rot bis zum Infra-Fix. ⇒ die alte „ce-Gitlink auf c022ce05 laggen"-Regel ist
durch die User-Direktive ÜBERFORMT; super trackt jetzt ce-development (dd0fe177). Zurück-Laggen ist FALSCH (bräche
super-P5 `--validate`, das `validate_profile_facade` erst in dd0fe177 hat). super-CI-rot = reiner Infra-Fetch, kein
Code-Fehler; NICHT durch Pointer-Revert „reparieren". Der Runner-CI_JOB_TOKEN-Cross-Projekt-Klon-Fix bleibt Infra-Handover.

**⚠️ ROOT-CAUSE + FIX-WEG (2026-07-11, User-GO „Diplomarbeit-CI autonom fixen", Admin-Token):** Es ist NICHT nur
„fresh fetch" — das **CI_JOB_TOKEN hat GENUIN keinen Cross-Projekt-git-KLON-Zugriff** auf die privaten Submodule
(ce/prt-art/thesis), auch root-getriggert; die inbound-Allowlist ist NICHT der wirksame Gate für den git-Klon. Zwei
Fix-Versuche scheiterten: (1) `default.hooks.pre_get_sources_script` mit `git config url.insteadOf` + CI_JOB_TOKEN
(Hook LIEF laut Trace, Haupt-Repo klappte, aber GitLab's **Auto-Submodul-Fetch ignoriert die insteadOf** und nutzt sein
eigenes CI_JOB_TOKEN → failt); (2) dieselbe insteadOf mit einem **Group-Deploy-Token** (`gitlab+deploy-token-39`,
read_repository, `comdare/research`, als maskierte super-CI-Vars `CE_SUBMODULE_USER`/`CE_SUBMODULE_TOKEN`) — failt
identisch, weil der Auto-Fetch die insteadOf weiter ignoriert. **➡️ FINALER FIX (nächste Session, hohe Konfidenz):**
`GIT_SUBMODULE_STRATEGY: none` in super-`variables` (Auto-Fetch AUS, get_sources bricht nicht mehr ab) + ein
`default:before_script`, das MANUELL klont: `git config --global url."https://${CE_SUBMODULE_USER}:${CE_SUBMODULE_TOKEN}@${CI_SERVER_HOST}/".insteadOf …`
→ `git submodule sync --recursive` → `git submodule update --init --recursive --depth 20`. Der manuelle Klon nutzt die
insteadOf-Credential (Deploy-Token) = authentifiziert. Danach `verify:submodules` grün → Mess-CI-Job triggerbar. Details
+ Track-A-Mess-Job in `super/docs/sessions/20260711-SESSION-ENDE-produktions-ci-fix-golden-run-achsen.md` §2. Deploy-Token
+ CI-Vars sind bereits angelegt (read-only, revoke-bar). NIE das Token-Value committen/ausgeben.

**INFRA-REST (Rest, nicht mein Domain):** Der Runner-seitige Fetch-Auth/Cache-Fix (Instance-Job-Token-Setting bzw.
Runner-Credential-Injection) ist Runner-/CI-Internals. Verwandt:
[[feedback_buildsystem_xml_hands_off_parallel_ci_cmake]], [[feedback_verify_gitlab_pipeline_green_after_push]],
[[reference_session_transkripte_enthalten_live_tokens_nie_committen]] (Token-Rotation könnte den Scope geändert
haben), [[feedback_diplomarbeit_4_projects_local_clones_keep_in_sync]].
