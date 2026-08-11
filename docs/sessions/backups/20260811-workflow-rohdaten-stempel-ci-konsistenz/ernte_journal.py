#!/usr/bin/env python3
"""Erntet die fertigen Agenten-Ergebnisse aus einem Workflow-Journal.

Das Journal ist die Wahrheit (Hausdoktrin): jede "type":"result"-Zeile traegt den
Rueckgabewert eines Agenten. Der Task-Output ist fluechtig, das Journal nicht.

Aufruf:  ernte_journal.py <journal.jsonl> <ziel.md>
"""
import json
import sys
from pathlib import Path


def entpacke(wert):
    """Ein Agenten-Ergebnis kann ein String oder ein validiertes Schema-Objekt sein."""
    if isinstance(wert, str):
        try:
            return json.loads(wert)
        except Exception:
            return wert
    return wert


def main():
    journal = Path(sys.argv[1])
    ziel = Path(sys.argv[2])

    ergebnisse = []
    gestartet = []
    for zeile in journal.read_text(encoding="utf-8", errors="replace").splitlines():
        if not zeile.strip():
            continue
        try:
            e = json.loads(zeile)
        except Exception:
            continue
        typ = e.get("type")
        if typ == "started":
            gestartet.append(e.get("label") or e.get("id") or "?")
        elif typ == "result":
            ergebnisse.append(e)

    zeilen = []
    zeilen.append(f"# ERNTE aus {journal.parent.name}")
    zeilen.append("")
    zeilen.append(f"Journal: {journal}")
    zeilen.append(f"Gestartet: {len(gestartet)} Agenten · Ergebnisse: {len(ergebnisse)}")
    zeilen.append("")
    zeilen.append("Erntet wurde aus dem JOURNAL, nicht aus dem Task-Output. Das Journal ist die")
    zeilen.append("Wahrheit -- der Task-Output ist fluechtig und war die Ursache des verlorenen")
    zeilen.append("15-Pakete-Designplans vom 11.08.")
    zeilen.append("")

    for i, e in enumerate(ergebnisse, 1):
        label = e.get("label") or e.get("id") or f"agent-{i}"
        zeilen.append("")
        zeilen.append("=" * 78)
        zeilen.append(f"## [{i}/{len(ergebnisse)}] {label}")
        zeilen.append("=" * 78)
        wert = entpacke(e.get("result") if "result" in e else e.get("value"))
        if isinstance(wert, (dict, list)):
            zeilen.append("```json")
            zeilen.append(json.dumps(wert, ensure_ascii=False, indent=1))
            zeilen.append("```")
        elif wert is None:
            zeilen.append("(leeres Ergebnis -- der Agent lieferte nichts)")
        else:
            zeilen.append(str(wert))

    ziel.write_text("\n".join(zeilen) + "\n", encoding="utf-8")
    print(f"{len(ergebnisse)} Ergebnisse -> {ziel}  ({ziel.stat().st_size} Bytes)")


if __name__ == "__main__":
    main()
