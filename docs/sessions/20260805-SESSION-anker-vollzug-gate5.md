# SESSION 05.08.2026 — ANKER-VOLLZUG (GATE 5): A2-SHA512-Eichung + TP1-Final-Inventur — JOB-SPERRE BEENDET

> Vollzugs-Protokoll des GENAU-EINMAL-Vorgangs. Autoritative Kurzform: LEDGER Nachtrag nachmittag-2.
> Plan/Gates: `backups/20260805-anker-planung/vollzugs-plan.md` (S0-S9, G0-G8, R1-R10).
> Wellen-Backup: `backups/20260805-anker-a2-eichung/` (Roh + eich-wellen-plan.md).

## Vollzugs-Kette (alle Gates literal)

| Schritt | Ergebnis |
|---|---|
| S0 Vorflug | Waechter `grep 'ANKER VOLLZOGEN'` = 0; ce dev==main==24e07219; super synchron; Freeze 0; keine 286-Pipelines |
| S1 Plan | eich-wellen-plan.md (READ-ONLY; TABU-Anker verifiziert: Frozen-Vektor exakt 3 TU-Fundstellen, Overlay-Define genau 1) |
| S2 Bau | 426aeaef (F7-Substanz, 10 Dateien 639+/267-) + deee6406 (Kommentar-Wahrheiten); Biss ZWEISTUFIG am Alt-Stand (compile-hart + semantisch 5/6 ROT) |
| S3 Lokal | Doppellauf 2x404/404 seriell am Commit-Objekt (Basis 403); TABU 6/6 literal; cf22 0; ASCII 0; Freeze 0 |
| S4 CI | Pipeline **14659 = success** am VOLL-SHA 18fbb950 |
| S5 Landung | Merge 18fbb950 tree-identisch zu deee6406; 3-Marker 0; Lead-cf22 0; gitleaks 2/clean; main-FF beide Remotes; rescue anker-a2-deee6406 |
| S6 Inventur | 9/9 Gates gruen am Merge-Tree (N=404), **TP1_ANKER_OK** literal; dreiteilige Inventur-Feststellung (fail-closed-invalid / additiv / EINE Schluessel-Welt) im Ledger |
| S7 Persistenz | Ledger nachmittag-2 „ANKER VOLLZOGEN" (Waechter scharf: genau 1 Treffer); dieses Session-Doc; Task #3 completed; super-Commit + CI + main-FF |

## Substanz der Eichung (F7)

`dll_is_current(output, expected_fingerprint)` ist der EINE Vergleich `expected CT-Fingerprint == .fingerprint-Sidecar`, fail-closed in allen vier Zweifelsfaellen (leer / DLL fehlt / Sidecar fehlt oder leer / nicht-128-hex). `expected` wird EINMAL je Job berechnet und ZWEIMAL benutzt (Skip-Gate + `write_fingerprint_sidecar`), gelesen ueber DIESELBE `read_fingerprint_sidecar`-Funktion wie der Lager-Binder — die EINE Schluessel-Welt (Skip-Gate == minio-Key == Bestandslog key_sha512 == Baum-Blatt == ceb_key_sha512) ist damit Code-Konstruktion statt Disziplin. `.version` bleibt Transport-Vollstaendigkeits-Marke ohne Skip-Rolle; K1-Cross-Check ersatzlos vollzogen. L14: Overlay-Glied 0 Zeilen beruehrt (deklarierte Luecke, Heilung Phase 6 nach Abgabe).

## Ab jetzt

- **JOB-SPERRE BEENDET.** Reststrecke: P2 Implementierungskorrekturen (W1 `comdare_experiment_planner` + W2-Minimal + W5-Kern + W3-Kern) -> P3 Phasen 3-5 -> Trigger Do 07.08. (nur mit gruener W1/W2-Emission; 7-Auflagen woertlich) -> **Phase 6 Messung = USER-GO-STOPP**.
- **DAUER-AUFLAGE aller W-Wellen:** Fingerprint-Neutralitaet (Frozen-Vektor + golden-CRC + abi/-Diff-0 je Review); Verstoss => STOP + O-2.
- Default-Modus ohne `COMDARE_BESTANDSLOG=true`: kein Bau-Resume-Skip (ehrlicher Neubau, owner-gedeckt); P11-Pre-Flight prueft das Env vor dem Trigger.
