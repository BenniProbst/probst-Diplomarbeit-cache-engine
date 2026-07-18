# WP-1 gestoppt — Fork A entschieden (2026-07-16)

Der WP-1-Agent (Haertung des v32-Parallel-Treibers, Audit F01-F04/F11/F12) wurde vom User
gestoppt: „baut gerade eine zweite sinnlose parallele Engine". Fork-Entscheid: **Option A** —
die v32-Strecke wird zur duennen Orchestrierung UEBER dem offiziellen E4/CEB-Pfad
zurueckgeschnitten (3-Phasen-XML -> CEB-Build-Selektionen -> echte DLLs -> Loader -> Pruefdock ->
E4-Lastprofile -> offizielle 16-col-CSV; Welch konsumiert die offizielle CSV).
Generalregel (User, bindend): IMMER bei der offiziellen Architektur bleiben.

`wp1-halbfertige-edits.patch` = die verworfenen, halbfertigen Agent-Edits (uncommitted-Stand
vor dem Reset; additiv gesichert, Doku-nie-loeschen-Geist). Die mode-/op_types-Validierungs-
Logik daraus ist beim Brueckenbau wiederverwendbar. Die Audit-Befunde F01-F03 (Gate/mode/OP-Typen)
bleiben GUELTIG und werden in der Bruecke geloest (nicht in der Parallelstrecke).
