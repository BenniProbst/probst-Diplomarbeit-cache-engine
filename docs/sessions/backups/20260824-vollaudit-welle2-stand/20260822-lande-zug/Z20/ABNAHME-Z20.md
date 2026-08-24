# Z20 ABNAHME -- super-Phase Merge 5: bau/kampvor @ 025e0c42 --no-ff in development

Datum: 2026-08-24 ~13:13-13:15Z, Agent: Z20-Lande-Agent (Fable 5 max, slot2
"lande-w2-zug", Claim-Zeile Z20 ab 13:12:43Z). Status: GELANDET (lokal, kein Push --
R4, Phasen-Push Z23).

## 1. MERGE-IDENTITAET (K18, selbst gemessen)

- Merge-SHA: **66426ea541a26f076ee97f9bd0d148a8c3e46585** (development, --no-ff,
  'ort'-Strategie, MERGE_RC=0; Botschaft per amend praezisiert, Eltern/Tree dabei
  UNVERAENDERT -- eigener, ungepushter Commit, kein rebase, kein force).
- Eltern: Erst-Elter d4d721c7 (Lead-docs "Nachtrag 11", s. Abschnitt 2) +
  Zweit-Elter 025e0c42 (= Auftrags-quelle_tip, EXAKT).
- Tree: 0ca384b3a4be51479e7eb7bd7cf0fffcb173d7c5 == merge-tree-Gegenprobe am realen
  Erst-Elter (RC=0, keine Konfliktzeilen) -- BYTE-GLEICH.
- Inhalt: exakt 6 Dateien, 385 insertions(+), 26 deletions(-), alle unter ci/ --
  deckungsgleich mit audit-runde-1 Abschnitt 0 und dem Explore-Befund.
- Ancestor-Umkehr: `git merge-base --is-ancestor 025e0c42 development` VOR dem Merge
  RC=1 (nicht enthalten), NACH dem Merge **RC=0** (enthalten) -- Landung am Objekt.
- Commit-Trailer "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>": 1x (grep -c).

## 2. ZWISCHENFALL (dokumentiert, kein Schaden): Lead-docs-Commit zwischen Explore und Merge

Zwischen Explore-Messung (HEAD 17c93c2a) und Merge (13:13:10Z) landete
**d4d721c7** (13:12:09Z, "docs(sessions): Nachtrag 11 -- W2-Abschluss-Zug terminal
voll verbucht ... [ci skip]", 1 Datei docs/sessions/+68, bereits auf origin --
origin/development == d4d721c7). Messungen: `git diff --name-only
17c93c2a..d4d721c7 -- ci/` = **0** (keine Beruehrung der Merge-Flaeche);
merge-tree am realen Erst-Elter d4d721c7 = 0ca384b3 == HEAD^{tree} (RC=0,
konfliktfrei). Einordnung: Lead-Territorium (docs/sessions ist Lead-only),
docs-only, ci-skip -- der Merge sitzt sauber DARAUF; die Explore-Kernaussagen
(Tip, Basis, Flaeche, TABU/YAML/CMakeLists 0, Audit-Lage) bleiben unveraendert
gueltig. Die Merge-Botschaft dokumentiert beide merge-tree-OIDs (Explore 663bbe24
an 17c93c2a; real 0ca384b3 an d4d721c7).

## 3. DEKLARIERTE ABNAHME (S-2c-Gates, F-153-konform; Log: abnahme-f153-lints.log)

Am gemergten Stand 66426ea5, rc je direkt (kein Pipe-rc):
- PFLICHT-GATE 1: `bash -n ci/persist_sammler.sh` -> **RC=0 GRUEN** (bash-Datei).
- PFLICHT-GATE 2: `sh -n ci/frische_wache.sh` -> **RC=0 GRUEN** (sh-Datei).
- ZUSATZ je Shebang (beide Mengen benannt -- Zusatz, nicht Pflicht): sh -n auf
  mess_ausbeute_wache.sh / tests/frische_wache_probe.sh /
  tests/mess_ausbeute_bissprobe.sh / tests/persist_sammler_probe.sh -> 4x RC=0;
  bash -n tests/persist_sammler_probe.sh -> RC=0.
- F-153-GEGENPROBE (Koeder-Charakter, erwartet ROT): `sh -n ci/persist_sammler.sh`
  -> RC=2, Literal "ci/persist_sammler.sh: 273: Syntax error: redirection
  unexpected" -- EXAKT die audit-dokumentierte BESTAND-Stelle (KLEIN-2/F-153:
  "Z.230 -> Z.273 nur um den +43-Diff verschoben"); kein Regress, bestaetigt
  zugleich, dass die Lint-je-Datei-Doktrin notwendig ist.
- Bissproben-Wiederholung: laut S-2c NICHT noetig (5 Proben-Logs persistiert,
  F-152: kampvor/proben-logs/ -- 17/17+7/7, 18/18+9/9, 32/32+5/5, ROT 14/17
  F6c/F6d/F6e, ROT 15/18 P16/P17/P18). NICHT GEDECKT durch diese Abnahme:
  Laufzeit-Verhalten der Wachen in einer echten 288-Pipeline (naechste echte
  super-CI-Welle nach dem Phasen-Push Z23) und der super-Phasen-Endstand-Lauf
  (Z23, T-11b sinngemaess).

## 4. P-26/F-C (T14-5) -- BEIDE kampvor-Pushes jetzt API-belegt pipelinefrei

Projekt 288, sha 025e0c42: GENAU EINE Pipeline **16070** (ref bau/kampvor, source
push, created 2026-08-21T17:40:52Z), status **skipped**; Nenner /jobs = [] UNION
/bridges = [] = **0 Jobs** (Dateien: p26-analog-288-pipelines-sha025e0c42.json +
.NENNER.txt). ce-Haelfte war bereits belegt (16071 skipped, ZUG-BILANZ Z09).
Damit ist der kampvor-Audit-Teilpunkt P-26 (TEIL: "ohne API-Token nicht pruefbar")
fuer beide Haelften GESCHLOSSEN.

## 5. RAHMEN: Gitlink-Sperre, kein Push, Raeumung, df

- Gitlink COMMITTED unveraendert 66de5c09 (`git ls-tree HEAD` literal); Arbeitsbaum-
  Dirty-Gitlink + untracked build-l4/ unangetastet (Sperre bis Z23 eingehalten).
- KEIN Push (R4): origin/development steht bei d4d721c7; der Phasen-Push (Z23)
  traegt 17c93c2a..66426ea5 gesammelt.
- CACHE-RAEUMUNG des gelandeten Strangs: GEGENSTANDSLOS -- wt-super-kampvor traegt
  KEIN build*-Verzeichnis (ls RC=2; 763M = reiner Repo-Bestand; Shell-only-Strang,
  in diesem Schritt wurde nicht gebaut). Doppel-Bedingung damit objektlos; nichts
  geloescht.
- WORKTREE wt-super-kampvor: STEHT (Raeumung = Z26 per Auftrag, rekursive Doktrin
  dort).
- df -h / vor/nach: 15G frei / 15G frei (kein Bau, keine Raeumung).

## 6. RESTPOSTEN (Traeger je benannt; Lead-only-Flaechen NICHT beschrieben)

1. T12b/K-1: CCD0+CCD1-Verdopplungs-Semantik in DERSELBEN ##55-Zeile des
   F-108-docs-Zugs (Wellenplan Z.718 "2x128 MiB CCD" -> "96+32 MiB (2 CCD)")
   + CCD1-Menge als zweite SOLL-Deklaration im W3-Vorstaffel-Posten -> docs-Sammel
   **Z21** (Auftrags-Zuweisung).
2. F-112-Rest (Treiber-Konsument window_belongs_to) + F-114 (Pin-AKTUATOR,
   prod2-Topologie) -> W3-Vorstaffel.
3. E-10-YAML-Haelfte (COMDARE_MACHINE_RANK/-MACHINES) -> Staffel-3-YAML-Zug.
4. F-113 C-10-Karten-Hygiene -> Karten-Konsolidierung Phase 5.
5. T-9-Codex-Pass der 5 neuen Pruef-Gegenstaende -> Folgewelle.
6. Phasen-Push + super-Endstand-Gates (PZW/Gates/YAML-Wohlform, Pipeline-gruen,
   T-11b sinngemaess) -> Z23; Gitlink-Bump + np34 (L-01/S-2e, Frist Mi 26.08.
   06:00) -> Bump-Zug.
7. Raeumung wt-super-kampvor -> Z26. Ledger-/Board-Nachtraege (u.a. kampvor-
   Landungs-Buchung, P-26-Schliessung) -> Lead-Nachlande-Zug (KON122-Umfeld).

## BEWEIS-INVENTAR DIESES ORDNERS

EXPLORE-BEFUND-Z20.md (3 Achsen, vor dem Eingriff) | merge-beweis-66426ea5.log
(Identitaet, Volltext-Botschaft, Stat, ANC-Umkehr, Gitlink, df) |
abnahme-f153-lints.log (8 Lint-Laeufe mit rc-Literalen) |
p26-analog-288-pipelines-sha025e0c42.json + .NENNER.txt (API-Rohantwort + Nenner).
