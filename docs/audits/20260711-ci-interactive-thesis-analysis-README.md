# Backup — CI-interaktive Diplomarbeit: Anhang-Automatisierungs-Analyse (2026-07-11)

Rohdaten + Synthese der 3 parallelen Analysen zum User-Auftrag „Anhänge automatisiert aus Messwerten +
datengetrieben-optimale Darstellung + C++23-Teil-App statt Behelfsweg".

## Synthese (autoritativ)
→ **`docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md`** (das Dossier: Ist-Analyse +
Viz-Mapping + C++23-App-Architektur + Implementierungs-Roadmap + C++23-Ersetzungs-TODOs).

## Rohdaten der 3 Analysen
| Analyse | Agent/Workflow | Kernbefund |
|---|---|---|
| **Anhang-Audit A–F (DE+EN)** | general-purpose Agent | nur A_measurements messwert-automatisierbar; B/E leere Stubs; C/D/F handgepflegt; 2 Windows-`.ps1` = einzige Verdrahtung; Tools zu ~80% fähig |
| **Viz-Deep-Research** | general-purpose Agent (feld-fundiert: ART/HOT/SuRF/ALEX/Wormhole/Marcus/Ailamaki) | Datentyp→Darstellung-Mapping; lc_surface LINEAR-viridis-Sättigungs-Defekt (P6 log-Fix); Fit ungenutzt (P1); 6 neue Darstellungen P1–P6 |
| **C++23-Ersetzungs-Audit** | ultracode-Workflow `wf_2c594d82` (25→4 adversarial) → `wf-cpp23-replacement-audit-RESULT.json` | kein high-Perf-Kandidat (Groß-Parsen schon C++); 4 Behelfsweg-Kandidaten: 2×.ps1(=#24), format_tex.py, codegen.sh |

Die vollständigen Agent-Transkripte liegen unter `.claude/projects/…/subagents/`. Das Workflow-Rohergebnis
(voll, 4 bestätigte Kandidaten + Synthese) = `wf-cpp23-replacement-audit-RESULT.json`.

## Konsequenz
Tasks #24 (Anhang-Generator C++23) + #25 (C++23-Ersetzungen). Nächster Schritt = Increment 1 aus der Roadmap
(byte-identische Reproduktion als Regressionsnetz), nach User-GO.
