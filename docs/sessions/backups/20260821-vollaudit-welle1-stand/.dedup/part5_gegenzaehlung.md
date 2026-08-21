
## Gegenzaehlung (nichts still verworfen)

| Groesse | Wellenplan | Register | Memory/Tasks | Summe |
|---|---|---|---|---|
| Roh-Posten (vor Dedup) | 929 | 439 | 404 | **1772** |
| davon in Teil-A-Cluster aufgegangen (zusammengefuehrt) | 55 | 22 | 36 | **113** |
| davon als Einzelquellen-Zeile unveraendert uebernommen (Teil B/C/D) | 874 | 417 | 368 | **1659** |
| Kontrollsumme je Quelle (Merge-Anteil + Einzel-Anteil = Roh) | 55+874=929 ✓ | 22+417=439 ✓ | 36+368=404 ✓ | 113+1659=1772 ✓ |

**Roh-Summe:** 1772 Posten (929 Wellenplan + 439 Register + 404 Memory/Tasks), alle drei Leser-Dateien vollstaendig gelesen (Z1-Ende je Quelle).

**Zusammengefuehrt:** 113 Rohzeilen (55 Wellenplan + 22 Register + 36 Memory/Tasks) wurden in 36 quellenuebergreifende bzw. eindeutig identifizierte Gegenstaende (Teil A) verdichtet — davon 33 Cluster ueber mindestens 2 Quellen hinweg, 3 Cluster als eindeutige Fortschreibungs-Paare/-Tripel innerhalb derselben Quelle (OV-5/prod2, EIN-BLECH-REGEL, CI-DUAL-COMPILER/#106). Das spart 113 − 36 = **77 Zeilen** gegenueber einer reinen Konkatenation.

**Dedupliziert (End-Zeilen der konsolidierten Tabelle):** 36 (Teil A) + 874 (Teil B) + 417 (Teil C) + 368 (Teil D) = **1695 Zeilen**.

**Nichts still verworfen — Vollstaendigkeits-Beweis:** 1659 Einzelquellen-Zeilen (unveraendert, Teil B/C/D) + 113 in Teil A eingegangene Rohzeilen = 1772 = Roh-Summe. Jede der 1772 gelesenen Rohzeilen ist entweder (a) wortgleich als eigene Zeile in Teil B, C oder D vorhanden, oder (b) als benannte Quelle (WP-Zxxx / R-Zxxx / MT-Zeile) in genau einer Teil-A-Zeile referenziert und deren Inhalt in Status-/Traeger-Zelle synthetisiert. Keine Zeile wurde geloescht, gekuerzt auf "erledigt sich von selbst" oder ohne Verbleib ausgelassen.

**Status-Konflikte, die im Dedup sichtbar ausgewiesen wurden (nicht glattgezogen):** Task #15 (Board-GELANDET vs. Wellenplan/Register-Snapshot-OFFEN), #38a2 (Audit-Erhebung uneindeutig, Board bestaetigt weiter offene Audit-Pflicht), #95/V-08R (Board-GELANDET vs. Register-Vorbehalt "OHNE dokumentierte Abnahme"), prod1-16/32 (Sachverhalt behoben, Doku-Marker-Luecke offen), `checkpoint_measure` (interner Widerspruch der Register-Audit-Tafel FEHLT vs. GEBAUT, nicht aufgeloest), B3/W1-V2 (Anker-Korrektur zwischen zwei Register-Passagen).

---
*Erstellt vom KONSOLIDIERER-Subagenten des Vollaudits, 20260820. Quellen: `leser-wellenplan.md`, `leser-register.md`, `leser-memory-tasks.md` (alle im selben Verzeichnis, vollstaendig gelesen vor Konsolidierung).*
