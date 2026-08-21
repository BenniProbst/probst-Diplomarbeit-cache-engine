
## Gegenzaehlung (nichts still verworfen)

**Roh-Summe je Quelle** (Tabellenzeilen ohne Kopf-/Trenn-/Leerzeilen, programmatisch geparst):

| Quelle | Rohzeilen |
|---|---|
| Transkript 13 (leser-transkript-13.md) | 499 |
| Transkript 14 (leser-transkript-14.md) | 742 |
| Transkript 15 (leser-transkript-15.md) | 470 |
| Transkript 16 (leser-transkript-16.md) | 319 |
| Transkript 17 (leser-transkript-17.md) | 435 |
| Transkript 18 (leser-transkript-18.md) | 316 |
| Transkript 19 (leser-transkript-19.md) | 311 |
| Transkript 20 (leser-transkript-20.md) | 316 |
| Transkript 21 (leser-transkript-21.md) | 477 |
| Transkript 22 (leser-transkript-22.md) | 436 |
| Transkript 23 (leser-transkript-23.md) | 347 |
| **Roh-Summe (11 Quellen)** | **4668** |

**Dedupliziert (Zeilen in dieser konsolidierten Tabelle):** 4534

**Zusammengefuehrt (Rohzeilen, die in eine bereits bestehende Zeile eingegangen sind, statt
eigene Zeile zu bleiben):** 134

**Kontrollrechnung:** 4668 (roh) − 134 (zusammengefuehrt) = 4534 (dedupliziert) ✓
4534 (dedupliziert) + 134 (zusammengefuehrt) = 4668 (roh) ✓ — jede Rohzeile ist entweder
selbst eine der 4534 Tabellenzeilen ODER als Mitglied einer der 86 Mehrfach-Gruppen in einer
solchen Zeile aufgegangen (Nachweis je Gruppe in `_merge_groups_transspaet.json`, 86 Gruppen
mit 2-8 Mitgliedern: 63×2, 11×3, 4×4, 6×5, 1×7, 1×8 = 220 Rohzeilen, davon 134 "ueberzaehlig"
zusammengefuehrt und 86 als jeweils EINE Repraesentantenzeile stehengeblieben — 4668 − 220 +
86 = 4534). Kein Rohbefund wurde geloescht oder ausgelassen; jede zusammengefuehrte
Aeltere-Status-Fassung ist im Statusfeld der jeweiligen Zeile als `⚠ STATUS-VERLAUF/vorher`
ausgewiesen, sofern ihr Wortlaut vom finalen Status abwich.

**Methodik-Hinweis zur Deduplizierungsquote:** Die vergleichsweise niedrige Quote (~2,9%)
ist inhaltlich plausibel und kein Artefakt zu laxer Suche: die 11 Quelldateien decken
ueberwiegend DISJUNKTE, chronologisch aufeinanderfolgende Zeitfenster desselben
Arbeits-Marathons ab (kein wiederholtes Ablesen derselben Zeitspanne durch mehrere
Leser-Agenten, wie es z. B. bei einer mehrfach rueckwaerts gelesenen Ledger-Konsolidierung
der Fall waere). Echte Wiederholung entsteht damit vor allem dort, wo ein Gegenstand ueber
mehrere Tage/Kontextfenster hinweg wieder aufgegriffen wird (Task-Karten, KON-Ledger-Zuege,
benannte Arbeitsstraenge wie S-14a-Riegel, #15-Bump-Buendel, #17/g2, HY-A, work_mode-Umbau,
main-FF, queuing-Umzug) — genau diese Faelle wurden identifiziert und zusammengefuehrt
(86 Gruppen). Ein erster, ungedeckelter Testlauf mit einer zu grosszuegigen
Ein-Wort-ID-Regel haette rechnerisch weit mehr (bis zu 649 Zeilen) "zusammengefuehrt",
das war jedoch bei Stichprobenpruefung nachweislich falsch (u. a. eine 272 Zeilen
umfassende Fehl-Gruppe aus voellig verschiedenen KON-Eintraegen, die nur ueber Ketten
generischer Einzelwoerter verbunden waren) und wurde verworfen zugunsten der hier
dokumentierten, stichprobengeprueften, konservativeren Regel.
