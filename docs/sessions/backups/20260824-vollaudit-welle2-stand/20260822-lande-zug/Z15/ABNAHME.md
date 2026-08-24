# Z15 ABNAHME -- prt-art B14-Merge + W1L-4-Kombibau + Dual-Push + Branch-CI-Beweis
# (Rezept #107 Schritte 2-3; 24.08.2026, Fable-max-Lande-Schritt)

Alle Zahlen aus EIGENER Objekt-Messung (K18); Beweisorte = GESICHERTE KOPIEN in diesem
Ordner; Exit-Codes via PIPESTATUS. ASCII-only.

## 1. MERGE (Schritt 2 des Rezepts #107)

- Merge-Commit: **16c90628651fd50538d1448d4e68a151ba6fbb9f** "merge(dev): #107 Schritt 2 --
  bau/w1luecken-prtart (B14) @ 3710ac4c --no-ff in development; .gitlab-ci.yml-Konflikt
  ZUGUNSTEN D-10a"; parents = 7a658fe6 (Z14-Stand) + 3710ac4c (B14-Tip); Trailer 1x.
- Konflikt: NUR .gitlab-ci.yml (merge-tree MT_RC=1 vorab, UU im Merge) -- ZUGUNSTEN D-10a
  aufgeloest (checkout --ours) + EINZIGER B14-Mehrwert eingefuegt: Bau-Proben-Notiz als
  4 Kommentarzeilen im D-10a-variables-Kommentar (Wortlaut-Kern "lokale Bau-Probe
  2026-08-21: Configure gelingt ohne ce mit Warnung, der BUILD bricht [rc=1]; mit ce
  60/60 Targets").
- Wirkung auf development (HEAD^1..HEAD): `4 0 .gitlab-ci.yml` (numstat). Wirkung gegen
  pinduo-Tip 25bbf2e: identisch `4 0 .gitlab-ci.yml` -- Code byte-identisch zum
  T9(c)-geprueften Stand. B14 ist Ancestor (merge-base RC=0). porcelain 0.
- YAML-Invarianten am Commit: 16 Top-Level-Keys (safe_load), Anker .ce-pin-clone = Liste
  mit 3 Items, 5/5 Jobs mit Anker an script-Position 0, 5x `*ce_pin_clone`, 0x !reference,
  global COMDARE_CE_PIN_SHA=66de5c09 (H-18, BEWUSST), Job-Var build:registry-roundtrip =
  196a621a (BEWUSST, F-86-Bump nur mit XML-Beleg). ASCII der Plus-Zeilen: 0 Non-ASCII.
- W1L-5/T10b-Protokollzahl: die pinduo-YAML-Aenderung heisst ".gitlab-ci.yml 58+/5-
  (Summe 63)" (numstat-Literal; die 63 war die --stat-Summenspalte).

## 2. W1L-4-KOMBIBAU (T-11b sinngemaess, VOR dem Push, am Endstand 16c9062)

CI-aequivalentes Layout: ce-pin-Klon @ 66de5c09 in der Wurzel (Echo-Beleg literal
"ce-Pin ausgecheckt: 66de5c0972290ec1ae3d219988ecc207d8f5de6b (SOLL ...)"), Configure je
Zelle `-DCOMDARE_CACHE_ENGINE_DIR=$PWD/ce-pin`, ccache-Launcher (belegtes Lead-GO).
4/4 Zellen GRUEN, je LITERAL "100% tests passed, 0 tests failed out of 224":
- gcc-rel   (GNU 15.3.0, Release), 60/60 Targets
- gcc-dbg   (GNU 15.3.0, Debug),   60/60 Targets
- clang-rel (Clang 22.1.8, Release), 60/60 Targets
- clang-dbg (Clang 22.1.8, Debug),   60/60 Targets
"KOMBIBAU-Z15-ENDE FAIL=0 2026-08-24T12:21:55Z". Echtheit geprueft: Compiler-Identifikation
je Zelle im configure-Log, ninja [n/60]-Zeilen gezaehlt (60), ctest-Einzelzeilen bis
"224/224 Test #224 ... Passed" (kleine Unit-Tests, 0.00-sec-Klasse; ccache-warm).
BEIDE MENGEN: gedeckt {prt-art-224er-Suite, gcc+clang, Release+Debug, lokal, ce-pin-Layout};
nicht gedeckt lokal {Sanitizer, echte Runner-Workspaces, registry-roundtrip-Strecke} -->
durch die Branch-CI (Abschnitt 4) gedeckt.
RAEUMUNG (K14, eigener Schritt nach gelesener Pruef-Ausgabe): Doppel-Bedingung gemessen --
git ls-files je Verzeichnis = 0; csv/xlsx ausserhalb _deps = 8, ALLE 8 = GETRACKTE
Bestandsdateien des ce-pin-Wegwerf-Klons (ce-pin porcelain 0, alle 8 in ce-pin git-getrackt,
HEAD exakt 66de5c09; keine Messdaten dieses Laufs) -> build-z15-* + ce-pin entfernt.
df: 16G vor Bau / 15G nach Bau / 16G nach Raeumung.

## 3. PUSH-WACHEN + DUAL-PUSH

- gitleaks (wirksame Repo-Config .gitleaks.toml, gitleaks 8.30.1):
  KOEDER glpat-+20 (Gesamtlaenge 26 ASSERTIERT) via stdin --config: RC=1, "leaks found: 1"
  (gitleaks-koeder.log). ECHT-SCAN Push-Bereich origin/development..HEAD: RC=0,
  LITERAL "4 commits scanned." + "no leaks found" == rev-list --count --no-merges = 4
  (total 6, davon 2 Merges). Koeder nur in stdin/Log, NIE committet.
- R4 Pipelines-Lage VOR Push (r4-pipelines-lage-vor-push.txt): Projekte 286/287/288 je
  juengste 5 Pipelines -- KEINE running/pending; 1 Push = 1 Pipeline eingehalten.
- Dual-Push: origin `777fff7..16c9062` (push-origin.log, OHNE ci.skip = echte Branch-CI,
  W1L-1/T9b) + github `777fff7..16c9062` (push-github.log). ls-remote beidseitig
  verifiziert: development = 16c90628... auf origin UND github.

## 4. BRANCH-CI-BEWEIS Projekt 287 (W1L-1, Messlatte #104: SUCCESS 9/9)

- Projekt-Identitaet AM API verifiziert (offene Frage 13): GET /projects/287 -> id 287,
  path comdare/research/comdare-prt-art (projekt-287-identitaet.json).
- Pipeline **16184** auf development @ 16c90628: Status **success** (TERMINAL; created
  2026-08-24T12:23:51Z, finished 12:27:34Z; pipeline-16184-final.json).
- Job-Nenner = /jobs UNION /bridges = **9 + 0**; BILANZ **9/9 success** (lint:secrets,
  lint:format, lint:static, build:standalone, build:standalone:debug,
  build:registry-roundtrip, build:clang, build:clang:debug, sanitize:asan-ubsan) --
  pipeline-16184-jobs-final.json. = #104-Messlatte "SUCCESS 9/9" EXAKT.
- PIN-LOG-BEWEIS ALLER 6 ce-konsumierenden Jobs aus GESICHERTEN Trace-Kopien (ci-traces/):
  build:standalone 384906 / :debug 384907 / build:clang 384909 / :debug 384910 /
  sanitize:asan-ubsan 384911 je LITERAL "ce-Pin ausgecheckt:
  66de5c0972290ec1ae3d219988ecc207d8f5de6b (SOLL 66de5c09...)";
  build:registry-roundtrip 384908 LITERAL "ce-Pin ausgecheckt: 196a621a8a1180dbd47163b75cbb
  8b102e66a08b (SOLL 196a621a...)" (Job>global-Praezedenz BEWUSST). 6/6 "Job succeeded".
- ctest-Bilanzen in echter CI: 5 Bau-Jobs je "100% tests passed, 0 tests failed out of 224";
  registry-roundtrip "out of 1" (Gate-Test). T9-WIRKBEWEIS: Test #200
  LizenzKonsistenz.KeinFremderSpdxBezeichnerImEigencode ... Passed MIT ce-pin/ im Workspace.
- FINDINGS#11-ALLOWLIST-BELEG: (a) GET /projects/286/job_token_scope/allowlist enthaelt
  (287, comdare/research/comdare-prt-art) -- findings11-allowlist-beleg.json (Scope ist
  projekt-scharf, deckt alle 6 Jobs; SPANNUNG-5/W1L-1c damit am API aufgeloest, kein
  Einrichtungs-Schritt noetig gewesen); (b) alle 6 CI_JOB_TOKEN-Klone liefen (Job-Traces),
  SUCCESS 9/9. (#104-HTTP-201 war der historische Einrichtungs-Call; heute belegt der
  GET + der Vollzug.)

## 5. RAEUMUNG wt-prt-pinduo (Verfahren Z11, NACH gruen+gemergt)

Vorbedingungen einzeln gemessen: porcelain 0, stash 0, untracked 0 (nichts zu sichern),
kein .gitmodules, keine nested .git; Tip 25bbf2e = origin refs/heads/bau/pinduo UND
Ancestor von origin/development (merge-base RC=0). `git worktree remove` RC=0;
worktree list zeigt nur noch den Hauptklon; Branch bau/pinduo BLEIBT als Referenz.
Standalone-Klon bleibt (Ziel-Vorgabe) auf development @ 16c9062.

## 6. NICHT GEDECKT / RESTPOSTEN (beide Mengen; Uebergabe an Lead)

Nicht Gegenstand dieses Schritts: T10/W1L-6 FINDINGS#13-Lead-Quittung (Board #122,
KEIN prt-art-Edit -- Wortlaut-Traeger SYNTHESE-S2 D-5), W1L-7 F-86-Bump (NACHLANDE,
nur mit XML-Byte-Beleg), W1L-8 YAML-Zug-Scope-Buchung (E-14/E-15), KON-Ledger-Nachtrag
der Landung (Lead), super-Submodul-Store-Frische (16c9062 fehlt im Store), lokale
prt-art-Alt-Refs ohne origin (bau/ci-dual-prtart 7444ad1, w2-E02-Ledger 3798a7f --
Triage = Owner-GO-Doktrin), lokales main 01e8b7d hinter origin/main c6f0754 (kein
Lande-Grund beruehrt).
