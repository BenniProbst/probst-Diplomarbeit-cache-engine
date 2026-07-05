---
name: reference_thesis_build_check_blg_alphadin
description: Beim Thesis-Build-Check BibTeX-Warnungen in der .blg prüfen (nicht nur .log); alphadin-Fallstricke @book/@misc
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

Beim Build-Check der Diplomarbeit (`build.ps1 -Lang de|en`): LaTeX-Fehler/`undefined`/Overfull stehen in `diplomarbeit-<lang>.log` — **BibTeX-Warnungen aber NUR in `diplomarbeit-<lang>.blg`**. Immer BEIDE grep'en. Im `.blg` ist `warning$ -- N` der Zähler (N=0 ⇒ sauber).

**alphadin-Fallstricke** (Stil = alphadin, TeX Live 2025 / Overleaf):
- `@book` ohne `edition` → Warnung „empty edition". Alle Buch-Einträge tragen `edition = {1|2nd|6th|…}`.
- `@misc` mit `note`-Feld oder verschachtelten Braces `{(...)}` im Titel → „literal stack isn't empty for entry". Sauberes `@misc`-Muster = author / title / `howpublished = {\url{…}}` / year (wie `spec_cpu2017`).

**Anlass (2026-06-24):** 3 neue Mess-Werkzeug-Quellen (perf/VTune/HdrHistogram) lokal fälschlich als „0 BibTeX-Warnungen" gemeldet, weil nur die `.log` geprüft wurde; der User sah die Warnungen im Overleaf-Build. Fix: `edition={1}` bei reinders2005vtune, `note` raus + `{(HDR)}`→`(HDR)` bei tene_hdrhistogram.
