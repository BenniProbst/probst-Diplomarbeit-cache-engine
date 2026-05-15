"""Sucht im SOSP'23-Proceedings nach dem VAMPIR-Poster + Kontext."""
from pypdf import PdfReader

P = r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Forschungsarbeiten\low priority\SOSP - October - Koblenz, Germany - Proceedings of the Twenty-Ninth ACMSymposium on Operating Systems Principles.pdf"
OUT = r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\20260508 Termin 7\_extracted_text\sosp_vampir_search.txt"

reader = PdfReader(P)
n = len(reader.pages)
hits = []
needles = ["VAMPIR", "Vampir", "Berthold", "Schirmeier",
           "Habich", "Schmidt", "Bartuschka",
           "Virtualized Non-Functional", "Data-Pipeline Scheduling"]

for i in range(n):
    try:
        text = reader.pages[i].extract_text() or ""
    except Exception:
        continue
    matched = [n for n in needles if n in text]
    if matched:
        hits.append((i + 1, matched, text[:1500]))

lines = [f"SOSP'23 Proceedings — VAMPIR-Suche",
         f"Total pages: {n}",
         f"Hits gefunden auf {len(hits)} Seite(n)",
         "=" * 80, ""]

for page_no, matched, text in hits:
    lines.append(f"--- PAGE {page_no} (matched: {', '.join(matched)}) ---")
    for ln in text.split("\n"):
        lines.append(f"  {ln}")
    lines.append("")

# Auch: Suche nach "Posters" Section / Table of Contents
lines.append("=" * 80)
lines.append("ZUSAETZLICH: Pages mit 'Poster' oder 'POSTER' (Inhaltsverzeichnis):")
for i in range(min(30, n)):
    try:
        text = reader.pages[i].extract_text() or ""
    except Exception:
        continue
    if "Poster" in text or "POSTER" in text:
        for ln in text.split("\n"):
            if "Poster" in ln or "POSTER" in ln or "VAMPIR" in ln.upper():
                lines.append(f"  Page {i+1}: {ln.strip()}")

import os
os.makedirs(os.path.dirname(OUT), exist_ok=True)
open(OUT, "w", encoding="utf-8").write("\n".join(lines))
print(f"Geschrieben: {OUT}")
print(f"Gefunden: {len(hits)} Seite(n) mit Hits")
for page_no, matched, _ in hits:
    print(f"  Seite {page_no}: {', '.join(matched)}")
