"""Erweiterte Suche im SOSP-Band: TOC, Poster-Section, Bildtitel."""
from pypdf import PdfReader

P = r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Forschungsarbeiten\low priority\SOSP - October - Koblenz, Germany - Proceedings of the Twenty-Ninth ACMSymposium on Operating Systems Principles.pdf"

reader = PdfReader(P)
n = len(reader.pages)
print(f"Total pages: {n}")
print()

# Step 1: Lese die ersten 30 Seiten (TOC, Posters-Section moeglich)
print("=" * 60)
print("ERSTE 30 SEITEN - Suche nach 'Poster' / TOC")
print("=" * 60)
for i in range(min(30, n)):
    text = reader.pages[i].extract_text() or ""
    if text.strip():
        for ln in text.split("\n"):
            if any(k in ln.lower() for k in ["poster", "vampir", "koblenz", "proc.", "table of"]):
                print(f"  Page {i+1}: {ln.strip()[:200]}")

# Step 2: Suche nach laxen Stichworten ueberall
print()
print("=" * 60)
print("VOLLE SUCHE: lax (Memory, Dresden, Lehner, Pipeline, Poster)")
print("=" * 60)
needles = ["VAMPIR", "Vampir", "Berthold", "Schirmeier", "Bartuschka",
           "Pipeline Scheduling", "Non-Functional", "Habich"]
for i in range(n):
    try:
        text = reader.pages[i].extract_text() or ""
    except Exception:
        continue
    for needle in needles:
        if needle in text:
            print(f"  Page {i+1}: enthaelt '{needle}' -> {text[:300].replace(chr(10),' | ')}")
            break

# Step 3: Pruefe wenige Schluesselseiten (oft am Ende der Posters-Section)
print()
print("=" * 60)
print("ENDE DES BANDES - letzte 50 Seiten Stichwoerter")
print("=" * 60)
for i in range(max(0, n - 50), n):
    text = reader.pages[i].extract_text() or ""
    if "VAMPIR" in text or "Berthold" in text or "Habich" in text or "Lehner" in text:
        print(f"  Page {i+1}: {text[:400].replace(chr(10),' | ')[:400]}")
