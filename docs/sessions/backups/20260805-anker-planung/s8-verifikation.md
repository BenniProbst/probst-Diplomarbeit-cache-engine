# S8-VERIFIKATIONS-LENS — ANKER-VOLLZUG (GATE 5) — 05.08.2026

READ-ONLY-Pruefung am Objekt (ce + super + Ledger + Session-Doc). Referenz: vollzugs-plan.md
(S0-S9/G0-G8), Ledger-Nachtrag nachmittag-2, Session-Doc 20260805-SESSION-anker-vollzug-gate5.md.

## VERDIKT: VOLLZUG-KONSISTENT

Alle sechs Pflicht-Punkte halten literal. Zwei nicht-vollzugs-brechende Beobachtungen (unten).

## Punkt 1 — GENAU-EINMAL-Zustand

- `grep -c 'ANKER VOLLZOGEN'` im LEDGER (Working Tree) = **1** (Kopfzeile Nachtrag nachmittag-2;
  waehrend der Lens von 4103 auf 4108 gerueckt durch parallel eingefuegten Nachtrag nachmittag-3 —
  Zaehler blieb 1). Auch in origin/main-Version des Ledgers: **1**.
- `git -C CE log --oneline --all | grep -ci 'anker-a2'` = **3** — alle drei Zeilen sind die EINE
  Welle: 426aeaef (F7-Substanz) + deee6406 (Kommentar-Wahrheiten) + Merge 18fbb950. Keine zweite
  Eich-Spur.
- Rescue-Refs: genau EINE einschlaegige — `refs/rescue/anker-a2-deee6406` = deee6406 (ls-remote
  origin), identisch mit dem Wellen-Kopf. Lokaler Branch anker-a2-eichung zeigt ebenfalls deee6406.

## Punkt 2 — Linien (nach fetch)

- ce: `origin/development` == `origin/main` == **18fbb950a83e2c15f7a24a66125bfefe2975a280**.
- super: `origin/development` == `origin/main` == **afa6842e8ad055dd136ef622b82297fc566292de**.
- super-Gitlink (origin/main) zeigt 160000 commit **18fbb950** — kein Gitlink-Drift.
- ce-Submodule-Checkout: HEAD == 18fbb950, porcelain leer.

## Punkt 3 — Eich-Substanz am Objekt (ce @ 18fbb950)

- `dll_is_current(output, expected_fingerprint)` build_orchestrator.hpp:293-300: DER EINE Vergleich
  `return *vorhanden == expected_fingerprint;` (Z.299); fail-closed-Zweige gelesen:
  (1) expected leer -> false (Z.294), (2) DLL fehlt -> false (Z.296), (3)+(4) Sidecar
  fehlt/leer/nicht-128-hex -> nullopt via read_fingerprint_sidecar -> false (Z.297-298).
- `read_fingerprint_sidecar` existiert (fingerprint_sidecar.hpp:101) und wird von
  fingerprint_key_source.hpp:79 genutzt (`return experiment::read_fingerprint_sidecar(output);`,
  Delegation dokumentiert Z.56/72) — dieselbe Lese-Wahrheit fuer Skip-Gate und Lager-Binder.
- kFrozenFingerprintV1-Wert `0fe275bddc7af1af9474cea655ff28280b93cfb3acc299c00d76d3489822993b` in
  GENAU 3 TUs: test_g3_sha512_index.cpp (:45), test_w10_system_cell_values.cpp,
  test_m_w12_stamp_bausteine.cpp — sonst nirgends.
- `COMDARE_OVERLAY_SOURCE_HASH`: GENAU 1 `#define` (anatomy_fingerprint.hpp:84, mit #ifndef:83);
  alle uebrigen Fundstellen sind Kommentare/Nutzung (kOverlaySourceHash:86).
- abi/-Diff 24e07219..18fbb950: `git diff --stat -- .../abi/` = **0 Zeilen** (auch Pathspec
  '*abi*' = 0).
- test_a2_sha512_skip_gate registriert: tests/unit/CMakeLists.txt:4759-4766 (add_executable,
  add_test, COMDARE_TEST_TARGETS, Labels "a2;blut").

## Punkt 4 — Inventur-Beleg (Ledger nachmittag-2, auch in origin/main)

- Dreiteilige INVENTUR-FESTSTELLUNG vorhanden: (1) prae-Anker-Bestaende FAIL-CLOSED-INVALID (grep
  origin/main = 1 Treffer), (2) Alt-Bestaende ADDITIV, kein Loesch-Schritt, (3) EINE Schluessel-Welt
  (Skip-Gate == minio-Key == Bestandslog key_sha512 == Baum-Blatt == ceb_key_sha512).
- **TP1_ANKER_OK** dokumentiert (Ledger: 9/9 Gates, '100% tests passed ... out of 9', ctest-N 404)
  UND am Objekt vorhanden: test_tp1_planer_filter_iterator.cpp:737 druckt TP1_ANKER_OK bei g_fail==0.

## Punkt 5 — Backups (kanonischer super-Backup-Ort docs/sessions/backups/)

- `git -C SUPER ls-files | grep 20260805-anker-planung` = 4 Dateien (definition.md,
  ergebnis-roh.json, ist.md, vollzugs-plan.md) — >= 4, committet UND in origin/main (ls-tree).
- `... | grep 20260805-anker-a2-eichung` = 2 Dateien (eich-wellen-plan.md, ergebnis-roh.json) —
  genau die im Ledger deklarierten [Roh + eich-wellen-plan.md], committet UND in origin/main.

## Punkt 6 — Task-Board/Docs

- Session-Doc docs/sessions/20260805-SESSION-anker-vollzug-gate5.md committet und in origin/main
  (Blob aa683d24). Inhalt deckt S0-S7 + Substanz + Dauer-Auflage.
- W-Wellen-DAUER-AUFLAGE FINGERPRINT-NEUTRALITAET im Ledger (origin/main grep = 1; zusaetzlich im
  Session-Doc als "DAUER-AUFLAGE aller W-Wellen").

## Beobachtungen (NICHT vollzugs-brechend)

1. UNTRACKED: docs/sessions/backups/20260805-anker-a2-eich-welle/ (8 Dateien: Biss-Beweis-Logs,
   Gate-C1/C2-Doppellauf-Logs, Plaene) liegt im super-Working-Tree, ist aber NICHT committet. Die im
   Ledger deklarierten Backups sind vollstaendig committet; dieser Zusatz-Ordner traegt jedoch die
   literalen Gate-Roh-Belege — Empfehlung: mit dem naechsten Doku-Commit additiv sichern
   (Workflow-Backup-SOFORT-Doktrin), sonst Verlustrisiko der Roh-Ausgaben.
2. LEDGER working tree ist gegenueber origin/main um 2 neue Nachtraege voraus (nachmittag-3 Owner-
   Praezisierung u.a.) — parallele, anker-fremde Arbeit; der Anker-Nachtrag selbst ist gelandet.
