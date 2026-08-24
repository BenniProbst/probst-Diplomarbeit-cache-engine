# Z16 EXPLORE-BEFUND (3 Achsen, VOR dem Merge dokumentiert) -- 24.08.2026

Ziel: super-Phase Merge 1: bau/s13schema @ 1e92b77e --no-ff in development
(super-Hauptklon /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine).
Schreiber: lande-w2-zug Z16 (Slot2-Claim traegt "lande-w2-zug"; kein Bau noetig).
Pflichtlektuere VOLL gelesen: SYNTHESE-S1-AUDIT.md (757 Z.) + SYNTHESE-S2-AUDIT.md
(1010 Z.) + GEGENLESE-GATE.md (501 Z.) + s13schema/audit-runde-2.md (357 Z., juengste
Runde inkl. R2-W/R2-W2) + Commit 1e92b77e Volltext+Volldiff.

## 1. STRUKTURELL (eigene Messungen 24.08. ~12:3xZ)

- Ziel-Branch: development lokal = origin = github = 348f54f4 (ls-remote beide Remotes
  selbst gemessen). Der Auftrags-Stand "lokal e6c90277 = origin 93542880 + 1" ist vom
  Lead ueberholt (docs/sessions-Nachtraege [ci skip], gepusht); KEIN Vorsprung mehr --
  der Merge setzt development lokal auf origin+1, Phasen-Push = Z23 (R4 eingehalten).
- merge-base development bau/s13schema = a7e8e151.
- Branch-Umfang: EXAKT 1 Commit (1e92b77e), EXAKT 1 Datei:
  Code/test_data_xml/experiment_schema.xsd, +17/-6 (Kommentar-only).
- dev-Seite: `git diff --name-only a7e8e151..development -- Code/test_data_xml/
  experiment_schema.xsd` = LEER; `git log a7e8e151..development -- <datei>` = 0 Commits
  -> die Datei ist seit der merge-base NUR vom Branch beruehrt.
- `git merge-tree --write-tree development bau/s13schema` = 68f6b2ef, RC=0, KEINE
  Konflikt-Sektion -> KONFLIKTFREI; keine Harmonisierungs-Flaeche (kein CMakeLists-Ende,
  kein Ledger im Diff).
- GITLINK: `git diff a7e8e151..1e92b77e -- Code/external/comdare-cache-engine` = LEER
  -> der Branch beruehrt den ce-Gitlink NICHT; der Merge KANN den im Hauptklon dirty
  stehenden (unstaged) Gitlink nicht committen. Z23-Sperre ("Gitlink NICHT vor Z23
  committen") strukturell gesichert. Hauptklon-Status vor Merge: genau
  " M Code/external/comdare-cache-engine" (unstaged, normal vor Bump) + "?? build-l4/"
  (untracked, fremd, bleibt unangetastet).
- Non-ASCII-Probe der Plus-Zeilen des Branch-Diffs: 0 Treffer (grep -P RC=1).

## 2. DESIGN (Audit-Berichte + Commit-Volltext)

- Inhalt X-6 (aus 20260817-DESIGN-s13-buendel-di25.md Abschn. 5): Registry=Single-Source-
  Kommentare an RunMethodologyType + WritebackMethodsType; stale Dreier-Liste
  {csv/latex_table/comparison_metrics} gestrichen (kWritebackMethodRegistry traegt seit
  A9-S3 AUCH xlsx, Count=4); XSD bleibt strukturell, HAERTE (unbekannte id => ERROR mit
  Zaehler) im Validator (validate_profile.hpp, check_measurement_sub_axis, validate-CLI-
  Zweig); S13-02-Persistenz-Semantik der FORMAT-Token {csv,xlsx} dokumentiert (KON32-01;
  Default xlsx, Owner-KERN 26.07.). KEIN Element/Typ/Attribut beruehrt; alle Instanzen
  byte-unveraendert; W-A/W-B (xmllint 4/4 validates) im Commit-Text vom 21.08. belegt,
  von audit-runde-1 geprueft, eigene Nachmessung dieses Zugs s. Abnahme.
- SUBSET-DEKLARATION: X-1..X-5/X-7..X-9 = Folgestaffel-Posten (S13-04/05/12/19/20/26/27/
  32), NICHT Teil dieses Merges; Traeger Staffel 3 / D-1-Di-25-Buendel; bis dahin
  KON32-01-Toleranz (a) formal in Kraft, Board #18 pending (S1-L-20).
- Audit-Kette: audit-runde-2.md VERDIKT SITZT (2/2 BEHOBEN -- beide Funde ce-seitig:
  S13A-F1 Diff-Hygiene 1095/0/0, S13A-F2 Interpretations-Vermerk), super-Haelfte
  1e92b77e in ALLEN drei Inkarnationen (R2, R2-W, R2-W2) porcelain 0 + origin-Ref
  bestaetigt, "LANDEREIF ce c76d3116 + super 1e92b77e, H-6-Kopplung unveraendert
  deklariert". P-06 (Kopplung) intakt.
- Synthesen: S1-L-03 [PFLICHT] super-Haelfte im SELBEN Lande-Ereignis wie ce-Haelfte;
  S1-7.6(5): LANDEREIF_MIT_AUFLAGEN, super-Haelfte an den ANFANG der super-Phase (vor
  L-04/L-02/L-01) -- exakt dieser Schritt; S2-S-2a identisch; Dritt-Gate Teil III (3)(b):
  H-6 einseitig vollzogen (ce gelandet, super nicht), "beide Synthesen tragen die
  Reparatur-Order". Dieser Merge loest H-6 beidseitig ein.
- Kommentar-only => KEIN Instanzen-/Spiegel-Nachzug (fixture_sync vergleicht Instanzen,
  nicht die XSD; fixture_schema_subset laeuft per xmllint gegen die lebende XSD).
  KEIN Bau noetig (keine Code-/CMake-/CI-Flaeche im Diff); super-Phasen-Endstand-Gates
  = Z23.

## 3. HISTORISCH (ist 1e92b77e der juengste Tip? Ueberholt-Marker?)

- ls-remote origin refs/heads/bau/s13schema = 1e92b77e (HEUTE selbst gemessen) --
  origin-gesichert, deckungsgleich mit Auftrag ("quelle_tip 1e92b77e").
- Lokal refs/heads/bau/s13schema = 1e92b77e; wt-super-s13schema HEAD = 1e92b77e,
  porcelain 0 Zeilen, stash 0 -> NICHTS Ungesichertes im Quell-Worktree; kein
  Build-Verzeichnis (find build* leer).
- Juengste Quellen bestaetigen den Tip als aktuell: S1-Synthese Abschn. 8.1
  (Fable-Neufahrt 24.08. ~11:35Z): "Tips ALLE unveraendert ... super bau/s13schema
  1e92b77e"; Dritt-Gate (24.08. ~11:43-12:05Z) S1-Probe 4: "1e92b77e ... NICHT Ancestor
  von development" (Lande-Order steht). KEIN Ueberholt-Marker in S1/S2/GEGENLESE --
  im Gegenteil: E-6-Ledger-Entwurf benennt die einseitige Kopplung als zu heilen.
- ce-Haelfte c76d3116: Ancestor von ce/development (S1-8.1 merge-base rc=0; Z10-Landung
  5ddda4e5, heute 943c70ee, CI 16150 SUCCESS laut super-Nachtrag 9) -> die Kopplung wird
  mit diesem Merge BEIDSEITIG.
- Kein juengerer Kandidat: for-each-ref zeigt genau einen s13schema-Branch im super.

## ENTSCHEID

Alle drei Achsen GRUEN -> Merge --no-ff JETZT, Botschaft mit Strang/Tip/Audit-Verdikt/
Restposten-Traegern + Fable-Trailer (super ist NICHT das thesis-Repo). KEIN Push (R4,
Phasen-Push Z23). KEINE Cache-Raeumung (kein Build-Verzeichnis); Worktree-Raeumung = Z26.
