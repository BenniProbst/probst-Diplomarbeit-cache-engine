# 20260727-PLAN: D3-CI-PAKET (P2 + P8 + zentrale gitleaks-Basis + 2b-visibility + main-Nachzug)

Stand: 27.07.2026. Ausfuehrungsplan, kompakt. Grundlage: 2B-SPEZ-Extrakt (Diplom-Handout
`Cluster/docs/sessions/2026-07-27-DIPLOM-AN-INFRA-2b-visibility-job-umbau-dump-plan.md`) und
P2/P8/TOML-Extrakt (alle Belege datei:zeile, Ist am 27.07. gegengelesen).

---

## (0) Rahmen

- GOs: super-Ownership bei DIPLOM bestaetigt; INFRA-AN-DIPLOM Punkt 2 = GO fuer zentrale
  `.gitleaks.toml` in ci-templates (DIPLOM setzt um); P2 ist der groesste Durchsatz-Hebel gegen
  die 286-Echo-Kaskade (main-immer-Bridges + strategy:depend + build:clang ohne needs =
  Slot-Fresser/Deadlock).
- Editierte Repos: **super** (`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`)
  und **ci-templates** (`/home/comdare/Projekte/Cluster-ci-templates`).
- **KEINE ce-Inhalts-Aenderungen** (O-8-Fenster). Der ce-main-Nachzug in D3.5 ist eine reine
  Git-Topologie-Operation (merge development->main), kein Inhalt.
- Kanon: git IMMER mit `-C <pfad>`; nie rebase, immer merge; Push -> Pipeline hart gruen;
  §74 kein Cancel laufender Pipelines; Bridges NUR via `GET /pipelines/<id>/bridges` pruefen
  (`/jobs` zeigt KEINE Bridges).

---

## (1) D3.1 - P2: Bridges changes-gaten + build:clang an den DAG (super/.gitlab-ci.yml)

Am **Job-Namen ankern**, nicht an Zeilennummern (bekannte Drift). Ist-Zeilen dieses Klons in
Klammern.

Edit A - `build:clang` (:151-176): `needs: ["verify:submodules"]` einfuegen (**hart**, Ziel-Form;
`optional: true` nicht noetig). PRAEZISIERUNG (Review 27.07.): die Existenz-Kopplung gilt NUR in
der tragenden Richtung build:clang => verify:submodules - die build:clang-rules 2-4 sind eine
echte Teilmengen-Bedingung der `.code-rules` (:89-100). Die Gegenrichtung gilt NICHT: mit
`COMDARE_CLANG_MATRIX != "1"` (build:clang-Regel 1, :158-159, z.B. per Pipeline-Variable)
existiert verify:submodules OHNE build:clang - fuer die needs-Validitaet harmlos (nur die
tragende Richtung zaehlt), aber der neue YAML-Kommentar darf KEINE "beide existieren immer
gemeinsam"-Aequivalenz behaupten. Gleiches Muster wie die gleich-gegateten Jobs
:305/:328/:358/:396/:450. Kommentar :155 "needs UNVERAENDERT (Verdikt V4)" ist durch
INFRA-AN-DIPLOM Punkt 1 superseded -> Kommentar fortschreiben.

Edit B - alle 3 Bridges `trigger:cache-engine` (:218) / `trigger:prt-art` (:237) /
`trigger:thesis` (:256): den Zweig `- if: '$CI_COMMIT_BRANCH == "main"'` (:223/:242/:261)
**ersatzlos entfernen**. Quellen-Zweig (web/api/pipeline/trigger/MR) und changes-Listen bleiben.

Edit C - Doku-Fortschreibung (sonst Doku-Luege): V2-Doktrin-Text :82 ("NUR main laeuft IMMER
voll") und die 3 Bridge-Kommentare :221/:240/:259 ("V2: nur main immer voll") auf die neue
Semantik umschreiben: main ist changes-gegated wie development; nur web/api/pipeline/trigger/MR
feuern immer.

Wirkung (geprueft):
- main docs-only: source=push matcht :222 nicht; ohne main-Zweig entscheidet `changes` (wird auf
  Branch-Push-Pipelines auch auf main gegen den Push-Diff ausgewertet) -> kein Pfad-Treffer ->
  `when: never` -> **keine Bridge erzeugt, Kaskade gestoppt**.
- Code-/Gitlink-Wellen auf main: Gitlink-Bump = Pfad-Change -> Bridge feuert weiterhin;
  `.gitlab-ci.yml`/`.gitmodules` feuert alle 3.
- DAG-sicher: auf development docs-only existieren verify:submodules UND build:clang beide nicht
  (gleiche Allowlist); auf main docs-only existieren beide -> needs haengt nie.

Nebenwirkungs-Klaerung (dokumentiert, Entscheidungen s. OPs):
1. Semantik-Verlust main: reine `Code/**/*`-Welle ohne Gitlink triggert trigger:cache-engine
   nicht mehr (changes-Liste :224-228 enthaelt `Code/**/*` nicht). Downstream-Stand unberuehrt
   (Kopplung = nur Gitlink) -> vertretbar, aber bewusst abnehmen (OP-1).
2. test:unit (:204-212) bleibt ohne needs stage-blockiert hinter orchestrate auf Code-Wellen;
   P2 loest nur build:clang (OP-2).
3. Bot-Writeback-Echo via source=pipeline (:222 bleibt) weiter moeglich; Bot-PUSHES auf main
   sind kuenftig changes-gegated - Mess-Trigger unberuehrt.
4. `needs: ["lint:secrets"]` der Bridges bleibt gueltig (lint:secrets existiert in jeder Welle,
   :184-185 `when: on_success`).
5. Rand: CI_COMMIT_BEFORE_SHA=0000... (erster Branch-Push) -> changes=true -> Bridges feuern =
   sichere Richtung; auf main praktisch irrelevant.

Beweis: siehe (6) Wellen W3 (Code-Welle: Bridges feuern, build:clang startet per DAG direkt nach
verify:submodules statt hinter orchestrate) und W4 (docs-only-main: `/bridges`-API leer, keine
neue 286-Pipeline, build:clang laeuft trotzdem).

---

## (2) D3.2 - P8: 3 Alt-Flag-Zeilen auf CLI-Subkommandos (super/.gitlab-ci.yml)

DRIVER = comdare-messung-driver (:631/:717/:941). Edits:
- measure:smoke :635: `"$DRIVER" --validate ...` -> `"$DRIVER" validate ...`
- measure:golden-320 :720: `"$DRIVER" --validate ...` -> `"$DRIVER" validate ...`
- planer:delegate :945: `"$DRIVER" --dump-ci "$COMDARE_GOLDEN_N_PROFILE" > ...` ->
  `"$DRIVER" plan ci "$COMDARE_GOLDEN_N_PROFILE" > ...`
- Mitziehen (Doku-Drift): Flag-Nennungen in echo-/Kommentar-Zeilen :633, :719, :899, :905,
  :919, :922, :944.

Beweis: lokal Mode A (`"$DRIVER" validate` und `"$DRIVER" plan ci <profil>` gegen den lokal
gebauten Treiber, Ausgabe literal sichten - kein Haken ohne Ausgabe); im CI beweist der naechste
regulaere measure:smoke- bzw. planer:delegate-Lauf (kein Extra-Lauf des mehrtaegigen golden-320,
#156 bleibt HELD).

---

## (3) D3.3 - Zentrale gitleaks-Basis in ci-templates + Einbindung + Projekt-Deltas

Edit A - NEU `Cluster-ci-templates/gitleaks/gitleaks-base.toml` (Policy §3a :120-161):
- `[extend]` `useDefault = true` + `disabledRules = ["generic-api-key"]`.
- Allowlist Block 1 (Nicht-Quell-/Vendor-/Build-Pfade, IMMER mit `(^|/)`-Praefix - P9-Falle;
  sicher nur weil der Job relativ scannt, `gitleaks dir .`):
  `ext/ _deps/ build/ build-*/ cmake-build-*/ _archive_code_pre_migration/ .citools/`.
- Allowlist Block 2 (Wert-Marker-Regex):
  `(example|dummy|sample|test|fake|placeholder)[-_]?(key|token|secret|pw|password)`.
- Bewusst NICHT in der Basis: Blanket `docs/` (Policy :163-164) und kein Blanket ueber
  Session-/Backup-Baeume (:132).

Edit B - `Cluster-ci-templates/base-pipeline.yml`, `.lint-secrets` (:156-198):
- Materialisierung: ci-templates ist hosted include, Dateien daneben landen nicht im Checkout ->
  Basis-toml per **Inline-Heredoc im script** nach `${COMDARE_CITOOLS_DIR}/gitleaks-base.toml`
  schreiben (sauberste Variante: kein Cross-Projekt-Fetch, kein Job-Token-Thema, eine Quelle in
  derselben Datei; Alternative bootstrap_lint_tools.sh verworfen).
- Config-Praezedenz explizit (Policy §4 :255): existiert `./.gitleaks.toml` ->
  `-c .gitleaks.toml`, sonst `-c "${COMDARE_CITOOLS_DIR}/gitleaks-base.toml"`; `--redact`
  bleibt; 0-Byte-Boden :179-195 UNVERAENDERT im Job (gehoert nicht in die toml).

Edit C - super `.gitleaks.toml`: funktional UNVERAENDERT lassen (Projekte mit eigener toml
behalten volle Delta-tomls, Basis-Bloecke dupliziert - Policy :126 erlaubt das explizit;
`[extend] path` auf vendorte Basis braeche lokale gitleaks-Laeufe ausserhalb CI). Nur
Kommentar-Marker einziehen: welcher Block = Basis-Duplikat (extend, Vendor/Build-Pfade,
Wert-Marker-Regex), welcher = super-Delta. KORREKTUR (Review 27.07.): echte super-Deltas sind
NUR `Code/external/`, `thesis/`, `Forschungsarbeiten/`. `Code/build/` (super/.gitleaks.toml:19)
ist eine redundante Teilmenge des Basis-Eintrags `(^|/)build/` (:20 - matcht jedes
`.../build/`-Segment inklusive `Code/build/`) -> als Basis-Duplikat markieren, NICHT als Delta;
der redundante Eintrag selbst entfaellt erst im spaeteren Abschluss-Aufraeumpass, nicht in D3.

ce `.gitleaks.toml`: in D3 NICHT anfassen (Rahmen). ce-Delta-Zuschnitt (`modules/` +
Konfliktpunkt Blanket-`docs/` behalten-und-dokumentieren vs eng scopen) -> OP-3.

Empirische Regression (builds-Pfad-Probe wie P9, lokal im Scratch):
1. Scan-Baum mit Fake-Secret unter `build-x/` und identischem Fake-Secret unter `src/` anlegen;
   `gitleaks dir . -c gitleaks-base.toml` -> Erwartung: build-Pfad allowlisted (0 Findings dort),
   src-Pfad DETEKTIERT (>=1 Finding) - beweist, dass die Allowlist nicht zu breit greift.
2. Sauberer Baum -> Report existiert und 0-Byte-Boden im Job greift weiter.
Beide Ausgaben literal sichten.

Beweis CI: naechste super-Welle zeigt im lint:secrets-Log den `-c .gitleaks.toml`-Zweig
(Projekt-toml) und bleibt gruen; Projekte ohne toml (z.B. comdare-web nach Adoption) laufen
gegen die zentrale Basis statt gegen nackte Defaults.

---

## (4) D3.4 - P6/2b: visibility:tier-binaries auf `--dump-plan` v1.1 (super/.gitlab-ci.yml)

Am Job-Namen ankern (Handout nennt :346-372, real :324-346 - Zeilendrift). Umbau gemaess
Handout-Auftraegen 1-3:

- Target-Wechsel: statt `tier_binary_report_cli` das Target `comdare-messung-driver` bauen
  (Name wie in analyse:thesis-data :315); `find`-Exe-Name entsprechend. `tier_binary_report_cli`-
  Bau und `--visibility`-Aufruf entfallen im Job (2c ruestet das CLI separat um).
- Manifest-Pruefung (`test -s .../permutations_manifest.txt`) entfaellt ERSATZLOS.
- Aufruf: `"$DRIVER" --dump-plan` ohne Profil-Argument (Fallback-Kette COMDARE_THESIS_PROFILE ->
  gebackenes Default; rein-lesend, baut keine DLL). Rohe Ausgabe nach
  `build-visibility/dump_plan.txt` (tee/Redirect).
- Ein-Format-Regel (§73.1): der Job liest NUR den rohen `--dump-plan`-Output (denselben, den 2c
  fuer tier_binary_report_cli vorsieht); kein Zwischenformat, keine eigene Datei; Caching NUR
  als Job-Artefakt der rohen Ausgabe.
- Pruefkette im Job:
  1. Kopf-Wache: `grep -q '^# comdare-experiment-plan v1.1' dump_plan.txt` (Formatanker).
  2. Startgate/Sichtbarkeit: `STEPS=$(grep -Ec '^  step [0-9]+ .*binary_id=' dump_plan.txt)`;
     `test "$STEPS" -ge 1` -> >=1 geplante step-Zeile mit binary_id-FELD = sichtbarer Bau-Raum.
     BEWUSST Feld-Praesenz, NICHT Wert-ungleich-`-`: THESIS-Profile emittieren `binary_id=-`
     (director.hpp:1690), nur EXPERIMENT-Profile tragen echte ids (:1737); ein Nicht-`-`-Filter
     waere beim Thesis-Default leer -> ROT. Handout-Wortlaut "nach `step ... binary_id=`
     filtern" deckt Feld-Praesenz (Option a). Strengere Pruefung nur nach Ruecksprache (OP-4).
  3. Zaehler + head der Ausgabe ins Log echoen (Sichtbarkeits-Zweck des Jobs).
- Artefakt: `artifacts: paths: [Code/build-visibility/dump_plan.txt]`, `when: always`
  (auch rote Laeufe surfacen die Rohausgabe), kurze expire_in.
- Job-Kopf-Kommentar (:318-323) NEU schreiben: alte Manifest-/Codegen-Erklaerung raus; Hinweis
  aufnehmen, dass der Treiber-Bau schwerer ist als das alte CLI (BILLIG-Klausel entfaellt;
  .ccache-pull mildert). `extends`, `stage`, `tags`, `needs: ["verify:submodules"]` bleiben.
- Kein binary_id-Filter im Treiber vorhanden (verifiziert) -> Filter liegt wie geplant beim Job
  (grep). Falls die Spez an weiteren Stellen Luecken zeigt: als OP markieren, NICHT raten.
- Rueckmeldung an INFRA: Vollzugs-Commit im Handout-Thread genuegt; danach zieht 2c nach (OP-8).

---

## (5) D3.5 - main-Nachzug BEIDER Repos (merge, nie rebase; ce VOR super)

1. ce: `git -C .../Code/external/comdare-cache-engine merge` development->main (reine
   Topologie, kein Inhalt), push (dual-remote, origin=gitlab), Pipeline hart gruen.
2. super: development->main mergen (enthaelt D3.1-D3.4 + ce-Gitlink-Bump), push, gruen.
Erwartung nach P2: die super-main-Welle ist eine legitime Code-Welle (Gitlink +
`.gitlab-ci.yml` = Pfad-Change) -> Bridges feuern korrekt; main-Wellen sind jetzt
gruen-faehig; nachfolgende docs-only-main-Wellen erzeugen KEIN Doku-Echo mehr.
Kanon: main bleibt Vorfahr (Gitflow), 4 Klone synchron halten, main-Nachzug je Welle.

---

## (6) Beweis-/Wellen-Plan (je Schritt; §74 kein Cancel, Runner-Backlog beachten)

| Welle | Inhalt | beweist |
|---|---|---|
| W0 | ci-templates: gitleaks-base.toml + .lint-secrets-Edit (D3.3 A+B), push auf **development** (NICHT Default=main - super inkludiert `ref: development`, s. OP-7 GEKLAERT); main-Nachzug per merge (Gitflow) | ci-templates-Pipeline gruen; Heredoc/Config-Zweig syntaktisch sauber; Aenderung liegt auf der Ref, der super folgt |
| W1 | lokal, keine Pipeline: gitleaks-Regressionsprobe (D3.3), Treiber-Subkommando-Probe (D3.2), lokaler `--dump-plan`-Filterlauf (D3.4) | Allowlist-Schnitt korrekt; `validate`/`plan ci` existieren und laufen; step-Filter liefert >=1 auf Default-Profil |
| W2 | super development: 3 granulare Commits (D3.1 P2, D3.2 P8, D3.4 visibility), EIN Push | `.gitlab-ci.yml`-Change -> alle 3 Bridges feuern (legitim); build:clang startet per DAG nach verify:submodules; lint:secrets nutzt `-c .gitleaks.toml`; visibility:tier-binaries GRUEN auf plan-dump-Weg (war ROT/instabil auf Manifest-Weg - bekannt, unblockierend) |
| W3 | D3.5: ce main-Merge-Push, dann super main-Merge-Push | Code-Welle auf main: Bridges feuern weiterhin (via `/pipelines/<id>/bridges`), Gesamtlage gruen |
| W4 | docs-only-Commit auf super main (z.B. Nachzug dieser Plan-/Vollzugs-Doku) | KERN-Beweis P2: `/bridges`-API der main-Pipeline LEER, keine neue 286-Pipeline entsteht (Kaskade gestoppt); build:clang + verify:submodules laufen (main-Zweig :161/:92 bleibt) |

Je Welle: Pipeline-Gruen literal verifizieren (Trace, nicht Commit-Titel - Trace-Parser-Falle);
Bridges ausschliesslich ueber den bridges-Endpunkt; laufende Jobs nie canceln.

---

## (7) Offene Punkte / OPs

- OP-1: Owner-Abnahme Semantik-Verlust main: reine `Code/**/*`-Welle (ohne Gitlink) triggert
  trigger:cache-engine nicht mehr - vertretbar (Kopplung nur Gitlink), aber bewusst abnehmen.
- OP-2: test:unit ohne needs bleibt auf Code-Wellen stage-blockiert hinter orchestrate ->
  Folge-Edit `needs: ["verify:submodules"]` analog build:clang (nicht Teil von P2/D3).
- OP-3: ce-`.gitleaks.toml`-Delta-Zuschnitt (`modules/` + Blanket-`docs/` behalten-dokumentiert
  vs eng scopen) - im naechsten ce-Zug, nicht in D3 (Rahmen: keine ce-Aenderungen).
- OP-4: visibility: strengere Pruefung `binary_id != -` (nur EXPERIMENT-Profile tragen echte
  ids) - nur nach Ruecksprache mit dem Handout-Autor; D3 prueft Feld-Praesenz.
- OP-5: visibility: Profil-Pinning (explizites `--dump-plan <profil>` statt Env-Fallback-Kette),
  falls haerterer Determinismus gegen CI-Env-Drift gewuenscht.
- OP-6: COMDARE_BUILD_PERMUTATIONS-Codegen im Configure ist fuer den visibility-Job nun
  irrelevant - perspektivisches Entkoppeln moeglich, explizit NICHT Teil des 2b-Auftrags.
- OP-7 GEKLAERT (Review 27.07., MAJOR): super pinnt das include auf `ref: development`
  (super/.gitlab-ci.yml:11-14); Default-Branch von ci-templates ist main (origin/HEAD ->
  origin/main; main Vorfahr, development voraus). Ein W0-Push auf den Default-Branch main
  liesse die von super inkludierte base-pipeline (development) UNVERAENDERT -> D3.3 Edit B
  wirkte in super nicht, der W2-Beweis (`-c .gitleaks.toml`-Zweig) schluege sichtbar fehl =
  verschwendete Welle auf dem gestauten Runner-Backlog. Folge: W0 pusht
  ci-templates-**development** (s. Wellen-Tabelle), main-Nachzug per merge (Gitflow-Kanon);
  KEIN Ref-Bump noetig (Branch-Ref, kein SHA-Pin).
- OP-8: 2c (tier_binary_report_cli + 2 Fixtures auf `--dump-plan`-Form) folgt als gebuendeltes
  Diplom-Paket NACH dem Vollzugs-Commit an INFRA.

---

## (8) Review-Einarbeitung (27.07., zweiter Verifikationspass)

Alle drei Befunde am Ist gegengeprueft und EINGEARBEITET:
- MAJOR W0/OP-7 (Ziel-Branch ci-templates-Push): Wellen-Tabelle W0 korrigiert (development statt
  Default=main) + OP-7 GEKLAERT. Beleg: super/.gitlab-ci.yml:11-14 (`ref: development`);
  Cluster-ci-templates `origin/HEAD -> origin/main`, main Vorfahr, development voraus.
- MINOR D3.1 Edit A: needs-Begruendung auf die tragende Richtung build:clang =>
  verify:submodules praezisiert. Beleg: build:clang-Regel 1 :158-159 (`COMDARE_CLANG_MATRIX`)
  fehlt in `.code-rules` :89-100.
- MINOR D3.3 Edit C: `Code/build/` von super-Delta auf Basis-Duplikat umklassifiziert. Beleg:
  super/.gitleaks.toml:19 vs :20 (`(^|/)build/` matcht `Code/build/` mit).

Verworfen: keine - kein Befund widerlegt.

Selbstcheck: Datei ASCII-only bis auf `§` (transliteriert: ae/oe/ue/ss, Pfeile als `->`).
