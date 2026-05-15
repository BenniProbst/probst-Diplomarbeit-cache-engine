"""Extrahiert ersten Text aus allen PDFs in ./Forschungsarbeiten und schreibt
   strukturierte Verifikationstabelle.
"""
import sys
from pathlib import Path
from pypdf import PdfReader

ROOT = Path(r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Forschungsarbeiten")
OUT  = Path(r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\20260508 Termin 7\_extracted_text\pdf_verification.txt")

def extract_first_text(pdf_path: Path, max_chars: int = 1500) -> tuple[str, str, str]:
    """Returns (title_meta, first_text, error_or_empty)."""
    try:
        r = PdfReader(str(pdf_path))
        meta = r.metadata or {}
        title_meta = (meta.get("/Title") or "").strip()
        if not r.pages:
            return title_meta, "", "no pages"
        text = r.pages[0].extract_text() or ""
        if len(text) < max_chars and len(r.pages) > 1:
            text += "\n--PAGE2--\n" + (r.pages[1].extract_text() or "")
        text = text.strip()[:max_chars]
        return title_meta, text, ""
    except Exception as e:
        return "", "", f"ERROR: {e}"

lines = ["================================================================================",
         f"PDF VERIFIKATIONSTABELLE",
         f"Quelle:  {ROOT}",
         f"Stand:   2026-05-04 (REV2 nach Nachladung)",
         "================================================================================",
         ""]

pdfs = sorted(ROOT.glob("*.pdf"))
lines.append(f"Anzahl PDFs (Hauptordner): {len(pdfs)}")
lp_pdfs = sorted((ROOT / "low priority").glob("*.pdf")) if (ROOT / "low priority").exists() else []
lines.append(f"Anzahl PDFs (low priority): {len(lp_pdfs)}")
lines.append("")

for i, pdf in enumerate(pdfs, 1):
    lines.append(f"--------------------------------------------------------------------------------")
    lines.append(f"[{i:02d}] FILENAME: {pdf.name}")
    lines.append(f"     SIZE:     {pdf.stat().st_size:,} bytes")
    title, text, err = extract_first_text(pdf)
    if err:
        lines.append(f"     {err}")
    else:
        lines.append(f"     META-TITLE: {title or '(kein /Title in Metadaten)'}")
        lines.append("     FIRST-TEXT:")
        for ln in text.split("\n"):
            lines.append(f"        {ln}")
    lines.append("")

if lp_pdfs:
    lines.append("================================================================================")
    lines.append("LOW-PRIORITY ORDNER")
    lines.append("================================================================================")
    for i, pdf in enumerate(lp_pdfs, 1):
        lines.append(f"  LP{i:02d}: {pdf.name}  ({pdf.stat().st_size:,} bytes)")

OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text("\n".join(lines), encoding="utf-8")
print(f"Verifikation geschrieben nach {OUT} ({len(lines)} Zeilen)")
