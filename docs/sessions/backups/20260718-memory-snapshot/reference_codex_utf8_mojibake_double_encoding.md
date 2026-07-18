---
name: reference_codex_utf8_mojibake_double_encoding
description: "Codex kann beim Editieren UTF-8-Umlaute/Sonderzeichen zu Mojibake doppelkodieren (ü→Ã¼, —→â€\") — nach jedem Codex-Lauf grep-Check + cp1252-Umkehr-Rezept"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Befund 2026-07-05 (AP-15-1, cache-engine `conformance_gate.hpp` + 2 Tests): Codex (gpt-5.5, Windows) hat beim Umschreiben einer UTF-8-Datei mit deutschen Kommentaren ALLE Nicht-ASCII-Zeichen doppelkodiert (UTF-8-Bytes als cp1252 gelesen, als UTF-8 zurückgeschrieben): `Konformität`→`KonformitÃ¤t`, `—`→`â€"`, `§`→`Â§`, auch in NEU eingefügten Strings (`Ã¼bersprungen`). clang-format und alle Test-Claims blieben grün — nur der Voll-Review (Datei lesen) fand es. Genau der Fall, für den [[feedback_codex_outputs_always_full_manual_review]] existiert.

**Check nach jedem Codex-Lauf** (in die Review-Kadenz aufgenommen): `grep -c "Ã\|â€" <angefasste Dateien>` — muss 0 sein.

**Reparatur-Rezept** (Python, zeilenweise nur betroffene Zeilen — schützt echte Nicht-ASCII-Zeichen):
```python
def unmoji(line):
    for enc in ("cp1252", "latin-1"):   # cp1252 ZUERST: € (in â€") existiert in latin-1 NICHT
        if "Ã" not in line and "â" not in line and "Â" not in line: break
        try: line = line.encode(enc).decode("utf-8")
        except (UnicodeEncodeError, UnicodeDecodeError): continue
    return line
```
latin-1 allein repariert nur die Ã¤-Klasse; die â€-Klasse (em-dash/„") braucht cp1252. Danach erneut greppen + clang-format dry-run.
