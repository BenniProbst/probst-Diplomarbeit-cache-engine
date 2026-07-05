---
name: feedback_thesis_tabellen_legende_notiz_unter_float
description: "Thesis-Tabellen-Legenden gehören als kurze Notiz UNTER die Tabelle (im Float), nicht in Caption noch als losgelöster Textblock"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d70c447-50f5-41bf-a389-d9c5da819589
---

Spalten-Legenden (Codes wie Op-Mix, neg%, `expected_workload`) in der Diplomarbeit gehören als **kurze, zentrierte `\footnotesize`-Notiz direkt unter `\end{tabular}`** jeder betroffenen Tabelle — innerhalb des `table`-Floats, sodass sie mit dem Float mitwandert. Jede Tabelle dokumentiert nur ihre **eigenen** codierten Spalten (kurze Notiz, keine Voll-Legenden-Wiederholung).

**Why:** Der User hat das in zwei Korrekturschritten geschärft (2026-06-23/24): (1) NICHT in den Tabellenkopf/die Caption quetschen und NICHT denselben Legendentext pro Tabelle wiederholen; (2) ein einzelner „gemeinsamer Legenden-Block" als Prosa-Absatz vor der Tabellengruppe ist FALSCH — wegen `[!htbp]`-Float-Platzierung bleibt er an fester Textstelle hängen und landet „mitten im Text" statt unter den Tabellen.

**How to apply:** Pro Tabelle nach `\end{tabular}` (vor `\end{table}`): `\smallskip` + `{\footnotesize <Spalten-Code-Erklärung>\par}`; das aktive `\centering` der Tabelle zentriert die Notiz. Notiz knapp halten (idealerweise eine Zeile). Bei `\ref` auf andere Tabellen aufpassen — Floats clustern unvorhersehbar über mehrere Seiten. Verifikation: PDF-Seiten via `pdftoppm -png` rendern und als Bild ansehen (Sichtprüfung), nicht nur `pdftotext`. Anlass: Kap. 3 „Lastprofile und Workload-Affinität" (Tab. 3.4/3.5/3.6). Verwandt: [[feedback_thesis_nur_user_ideen_persistieren]].
