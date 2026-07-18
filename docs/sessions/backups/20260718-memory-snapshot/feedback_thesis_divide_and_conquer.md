---
name: feedback-thesis-divide-and-conquer
description: Diplomarbeit-Wartbarkeit — Pipeline-Stufen als XX_operation/ Module mit eigener Doku + Tests + gecachten Eingangsfixtures
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3d9bd0e7-eeb3-411a-b116-64eef696e0f6
---

Diplomarbeit-Code muss "Teile und Herrsche" sichtbar zeigen damit Habich
als Pruefer die Modularisierung anerkennt.

Regel: Jede Pipeline-Stufe in eigenem Verzeichnis `XX_operation/` (zweistellige
Index-Praefix, einheitlicher Name) mit:
- eigener README.md (Was/Warum/Wie)
- eigener tests/ Dir mit ausgiebigen Tests pro Einzelschritt
- tests/fixtures/cached/ mit echten Beispiel-Eingangsdateien aus der
  vorangegangenen Stufe (cached, nicht zur Laufzeit generiert)

Wartbarkeits-Konsequenzen:
- Jede Stufe kann isoliert getestet werden (mit fixtures statt full-pipeline-run)
- Pruefer kann pro Stufe Tests + Doku + Code unabhaengig pruefen
- User klickt jede Stufe manuell im Debug-Modus durch -> XX_operation hilft Navigation

**Why:** User-Direktive 2026-05-22 — "Professor moechte das Prinzip Teile und
Herrsche vorfinden, was bedeutet dass auch jeder Einzelschritt ausgiebige Tests
haben muss."

**How to apply:** Wenn neue Pipeline-Stufe oder Refactoring der bestehenden 6
Module (sample_data_generator, messung_driver, binary_to_csv, csv_to_latex,
diagram_generator, latex_to_pdf): NEUE Module unter XX_operation/ anlegen,
bestehende migrieren via git mv (NICHT loeschen — Memory v24 [[feedback-never-delete-documentation]]).
Pro Stufe Fixtures-Dir + Schritt-Tests verlangen.
