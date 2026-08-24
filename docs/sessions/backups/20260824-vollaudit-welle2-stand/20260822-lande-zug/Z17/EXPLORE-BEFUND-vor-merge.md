# Z17 EXPLORE-BEFUND (3 Achsen) -- VOR dem Merge dokumentiert

Datum: 24.08.2026. Akteur: Z17-Lande-Agent (Fable 5 max, StructuredOutput-Subagent des
lande-w2-zug; slot2.d traegt "lande-w2-zug", kein Bau in diesem Ziel noetig).
Objekt: super bau/cidual @ 223ab5182fa868f14bafc8c5a941c8c4165c541d -> development
(super-Hauptklon /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine,
development VOR Merge @ ff800699 = Z16-Stand).

## 1. STRUKTURELL
- merge-base development bau/cidual = a7e8e151a3b1647cc87b8cf9faaeeb242b372e3d
  (== Audit-Basis; Branch = genau 1 Commit, 1 Datei .gitlab-ci.yml).
- git log a7e8e151..development -- .gitlab-ci.yml = LEER (0 Commits): development hat
  die Datei seit der Basis NICHT beruehrt -> trivialer 3-Wege-Fall, KEINE Konfliktflaeche,
  KEINE Harmonisierungs-Flaeche (die bekannte tests/unit/CMakeLists.txt-Flaeche liegt im
  ce-Repo, nicht hier).
- git merge-tree --write-tree development bau/cidual -> rc=0 (konfliktfrei), Ergebnis-Tree
  24eacc16a942a07c35a92afcb8acfd9ff21fe106; Beweis: merge-tree-probe.txt in DIESEM Ordner.
- Blob-Identitaet im Ergebnis-Tree: .gitlab-ci.yml = d9616e1f (== Tip 223ab518, voll
  uebernommen; Basis==dev-Blob fe7de7aa); Code/test_data_xml/experiment_schema.xsd =
  c6e347c4 (== development, Z16/s13schema-Stand ERHALTEN).
- Branch-Diff a7e8e151..223ab518 BYTE-IDENTISCH zur Audit-Beweiskopie
  cidual/beweis-diff-a7e8e151-223ab518.txt (diff -q leer, 253 Zeilen; Diffstat 79+/56-).
- Der grosse dev..cidual-Diffstat (249 Dateien, -184538) ist reine Blickrichtung
  (development seit Basis vorwaerts: docs/sessions + XSD); NICHT Merge-Gegenstand.

## 2. DESIGN
- Audit-runde-1 (22.08., Fable-max) VOLL gelesen: Verdikt SITZT -- 0 ERNST, 0 MILD,
  2 KLEIN (F-CD-1 Zeilennummern-Staleness, F-CD-2 4.-Bridge-Halbsatz; beide reine
  Bericht-Doku-Deltas, Objekt fehlerfrei). 12/12 P-Punkte ERFUELLT. LANDEREIF bestaetigt.
- R1: build:clang-Kill-Switch (if COMDARE_CLANG_MATRIX != "1" + when:never) weg;
  Variable :123 ersatzlos gestrichen; 0 funktionale Leser (git grep am Tip: 0 Treffer in
  ci/ scripts/ Code/; 4 verbleibende Treffer in .gitlab-ci.yml = Prosa-Kommentare
  :123/:261/:270/:1280).
- R2: 4x test:unit*-changes:-Drossel weg (.code-rules aus extends entfernt, .ccache-pull
  bei test:unit erhalten) + verify:submodules unbedingt; harte needs-Kanten
  build:clang->verify:submodules und test:unit->verify:submodules; alle 6 Zellen
  rules=[{when: on_success}]; .code-rules behaelt genau 8 Rest-Konsumenten.
- KEIN allow_failure/changes: eingefuehrt (grep am Beweis-Diff rc=1); einziges
  Bestands-allow_failure = deklarierte NE-20-Ausnahme (ergebnis:holen, byte-identisch
  an der Basis).
- Owner-Mandat: KON119-05 ("doppelter Compile-Test gcc+clang PFLICHT fuer ALLE
  Bereiche, kein when:never-/changes:-Skip") + Memory-Doktrin CI-DUAL (#106).
- SYNTHESE-S1 L-04 [PFLICHT] + Lande-Sequenz 1b; SYNTHESE-S2 D-3.2 S-2b (nach S-2a
  s13schema = Z16 GELANDET, Reihenfolge eingehalten; "danach sind die wartenden
  YAML-Posten E-10-YAML/E-14/E-15/prt-art-Scope frei").
- Abnahme-Definition dieses Ziels: CI-Lint valid / 0 errors / 47 Jobs (am gemergten
  Stand zu reproduzieren); T-11b-Kombibau ist ausdruecklich Pflicht des Lande-Zug-
  ENDSTANDS (ce-seitig bereits mit Z10/Z12 erfolgt; super-Phasen-Gates + Push = Z23,
  KEIN eigener Push in Z17, R4).

## 3. HISTORISCH
- Tip-Frische: bau/cidual lokal == origin/bau/cidual == wt-super-cidual-HEAD ==
  223ab518 (ls-remote origin literal; github traegt den Branch nicht -- flache
  Out-of-house-Sicherung, kein Fund). Genau 1 Commit auf der Basis, Trailer vorhanden.
- Juengste Messungen bestaetigen denselben Tip: SYNTHESE-S2 D-3.1 (24.08. 07:55,
  "Unlandete super-Zweige ... bau/cidual 223ab518"); GEGENLESE-GATE Zeile 162:
  audit-runde-1 SITZT (0/0/2) -> OK, KEINE runde-2 noetig, KEIN Ueberholt-Marker
  gegen den Strang (einzige UEBERHOLT-Treffer in der soll-karte betreffen F-31/T-13,
  beide zugunsten des Strangs aufgeloest).
- Landung stand bis zuletzt aus: merge-base --is-ancestor 223ab518 development rc=1
  (Audit P-09; identisch zur Lage vor DIESEM Merge). wt-super-cidual porcelain=0.
- KLEIN-Traeger: F-CD-1/F-CD-2-Korrektur-Wortlaute liegen in SYNTHESE-S1 L-08f(i)/(ii),
  Uebernahme durch T7/#122-Sammel-Docs/Ledger-Zug (= Z21 dieses Zuges); Raeumung
  wt-super-cidual = Z26.

## ENTSCHEID
Alle drei Achsen sauber, Audit LANDEREIF, Reihenfolge S-2a->S-2b eingehalten, Merge
konfliktfrei vorgeprueft -> MERGE JETZT (--no-ff, Trailer, kein Push, Gitlink-Sperre
bis Z23 unangetastet: dirty Gitlink Code/external/comdare-cache-engine bleibt
unberuehrt, build-l4/ untracked bleibt liegen).
