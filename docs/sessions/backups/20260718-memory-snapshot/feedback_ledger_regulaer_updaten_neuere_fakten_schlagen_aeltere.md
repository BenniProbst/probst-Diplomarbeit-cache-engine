---
name: feedback_ledger_regulaer_updaten_neuere_fakten_schlagen_aeltere
description: "Ledger-Doktrin geändert (User 2026-07-17): das Ledger darf REGULÄR geupdated werden (in-place, nicht nur additiv); neuere Fakten schlagen IMMER ältere Fakten"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Direktive (2026-07-17, verbatim): „**Das ledger darf regulär geupdated werden, nicht nur additiv, sobald der workflow durchdringt. Neuere Fakten schlagen immer ältere Fakten.**"

**Why:** Die bisherige strikt-additive Praxis (nur `NACHZIEH`-Vermerke, Original stehen lassen) hat das Ledger auf ~1800+ Zeilen mit stale Passagen + Widerspruchsschichten anwachsen lassen; ein lebendes Steuer-Dokument braucht Ist-Wahrheit, nicht Schichtarchäologie.

**How to apply:** Im LEDGER (`docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`) dürfen überholte Aussagen in-place korrigiert/ersetzt werden — neuere Fakten überschreiben ältere. Historie bleibt über git erhalten (jede Änderung committet, granular). Die Doktrin [[feedback_never_delete_documentation]] gilt WEITER für eigenständige Doku/Dossiers (`docs/sessions/backups/`, Architektur-Doks: nie löschen, nur deprecaten) und [[feedback_messdaten_nie_loeschen_abi_darf_brechen]] für Messdaten uneingeschränkt. Gilt ab Landung des Konsolidierungs-Workflows wf_d5ba4b2b (2026-07-17); dessen additive `NACHZIEH`-Vermerke sind der letzte Alt-Stil und dürfen fortan in reguläre Updates aufgelöst werden. Siehe [[feedback_jede_aufgabe_ultracode_planungssession_ledger_alle_plandocs]].
