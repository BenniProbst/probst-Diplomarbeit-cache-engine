# 2c-Befund — `test_all19_segment_timer` Layout-5%-Check ist VORBESTEHEND flaky (kein 2c-Bruch)

**Kontext (Bau-INC-2c, 2026-07-17):** Nach dem 19→18-Schnitt blieb als letzter ctest-Rot der
Empfindlichkeits-Check „aos_strict(48) != cache_line_aligned(64) seg_memory_layout (>5%)".
Verify-first-Auftrag: Ist das eine 2c-Regression oder Vorzustand?

## Messreihe (alle: gleiche Maschine, `taskset -c 4`, je 3 Läufe)

**Arbeitsstand 2c (build-conf, unoptimiert, batches=16):** rel_diff = −1.5% / −4.6% / −4.1% → rot.
Fester Kern: −2.8% / **+2.9% (Vorzeichen-Flip!)** → reines Messrauschen bei 16 Batches.
Nach Statistik-Erhöhung batches 16→64 (Test-seitig, Schwelle UNVERÄNDERT 5%): −4.7% / −2.6% / −0.3% → rot.

**Referenz 2b (`86769bc9`, Worktree, UNVERÄNDERTER Code):**
- Release (-O3): −23.4% / −29.1% / −49.3% → grün, deutlich.
- **Unoptimiert wie build-conf (fairer Vergleich): −2.6% (= ROT) / −6.8% / −6.4%** — der Check fällt
  auch auf dem unangetasteten 2b-Stand unter die 5%-Schwelle (Lauf 1).

## Verdikt
- **Keine 2c-Regression**: Der T5-Treiber-Block (`MemLayout::scan_field_sum`) ist byte-identisch zu 2b;
  der Check ist auf dem UNOPTIMIERTEN build-conf-Profil grenzwertig kalibriert und kippt mit
  Maschinenzustand (heute: Stunden 8-Thread-Builds, warme Maschine). Unter -O3 ist der Effekt >20%.
- 2c-seitig getan: Test-Statistik 16→64 Batches erhöht (ehrliche Varianzreduktion, KEINE
  Schwellen-Aufweichung — Direktive „Schwellen nur unter Absprache" respektiert).

## Offene MORGEN-ENTSCHEIDUNG (User)
Optionen für den dauerhaft ehrlichen Check (eine wählen):
1. **Schwelle build-profil-bewusst kalibrieren** (z. B. >5% nur bei NDEBUG/-O-Build, sonst >1% + Vorzeichen-Pin).
2. **Scan-Volumen des T5-Segments erhöhen** (kLbufBytes/kRecords im Treiber — Produktcode, präziser Effekt).
3. **Median-of-N im Test** (N Wiederholungen, Median gegen Schwelle).
Bis zur Entscheidung gilt: Check als bekannt-flaky dokumentiert (dieser Befund); 2c-Verifikation zählt
ihn nicht als 2c-Bruch (2b-Beweis oben, Lauf 1 rot auf unverändertem Stand).
