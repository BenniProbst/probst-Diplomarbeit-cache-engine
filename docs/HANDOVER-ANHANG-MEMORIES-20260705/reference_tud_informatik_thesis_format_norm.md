---
name: reference_tud_informatik_thesis_format_norm
description: "TU-Dresden-Informatik Abschlussarbeit: keine bindende Layout-Norm; Form = Betreuer-Sache; zihpub.cls fixiert nur textheight/textwidth/Raender; lange Anhang-Kopfzeilen norm-neutral via \\section[kurz]{lang} loesen"
metadata:
  node_type: memory
  type: reference
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

**Multi-Agent-Deep-Research 2026-06-24 (Workflow, 7 Agenten):** Für eine **Diplomarbeit der Fakultät Informatik der TU Dresden** existiert **keine verbindliche typografische Norm**:
- **Prüfungsordnung Diplom-Informatik (PO 2010 / Änderung 2017), § 21:** regelt nur Sprache, 2 Exemplare, „maschinengeschrieben/gebunden", digitale Form, Frist — KEINE Seitenränder/Schrift/Zeilenabstand/Kopf-/Fußzeile, KEIN Template-Zwang.
- **Offizielles Fakultäts-Hinweisdokument:** wörtlich „Es gibt keine Formatvorlage" — nur Empfehlung (~3 cm Rand, 11 pt). CGV-Lehrstuhl-Empfehlung (nicht bindend): oberer Rand ~3 cm, ~1 cm Kopfzeile mit Kapiteltitel + Seitenzahl außen.
- **`zihpub.cls` (ZIH-Vorlage) selbst** kommentiert `\headheight`, `\footskip`, `\topmargin` AUS (überlässt sie typearea); aktiv fixiert nur `\textheight=24.5cm`, `\textwidth=16cm`, `\oddsidemargin=\evensidemargin=0`. Nur diese aktiven Maße sind „die Vorlage".
- **Form-Entscheidungshoheit = betreuender Professor (hier Datenbanken/Habich), NICHT das Prüfungsamt.** ZIH-Vorlagenseite verweist Formfragen ausdrücklich „an den Betreuer".

**How to apply:** Layout-Maße der Vorlage (textheight/textwidth/Seitenränder/Schrift) NIE ändern. `headheight`/`footskip`-Eingriffe sind formal zulässig, aber unnötig invasiv. **Norm-neutrale Lösung** wenn ein langer Anhang-Sektionstitel den 1-zeiligen uppercase-Laufkopf sprengt (KOMA `scrlayer-scrpage` `\headheight too low`-Warnung + Overfull \vbox): **Kurz-Kolumnentitel** via `\section[Kurztitel]{Voller Titel}` — Laufkopf bleibt 1-zeilig, `headheight` bleibt typearea-17pt, KEINE Geometrie-/Paginierungsänderung. (Anlass: Build-SIMD-Sektion in Anhang D, Commit `afc677c`; verworfene `headheight=34pt`+`footskip=30pt`-Variante `d1eec90` revertiert.) Quellen: PO `dipl_inf_po_2010_de.pdf`, `dud.inf.tu-dresden.de/thesis/Hinweise_Beleg_Abschlussarbeiten.pdf`, `gitlab.hrz.tu-chemnitz.de/.../zihpub.cls`.
