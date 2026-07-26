# 20260726 Rueckfragen-Selbst-Aufloesung A-F (Workflow-Rohdaten)

ZWECK: Owner-Auflage "loese es selbst auf, wir haben diese Fragen schon 6 mal beantwortet" -
sechs offene Klaerungspunkte allein aus den vorhandenen Owner-Definitionen entscheiden
(Ziel: 0 Owner-Rueckfragen), jede Aussage mit Quelle:Zeile belegt.

AGENTEN: 7 (6 parallele Aufloeser A-F mit Beleg-Pflicht + 1 xhigh-Schluss-Verdikt).
A=Test-Skip, B=XML-Deaktivierung Achse vs Baustein, C=page_type-Heimat/NUMA,
D=Opt-Stufe Voll-Bau-4, E=Lane-C-Blocker-Analyse, F=Verifikation der F5-Lesart.

KERN-ERGEBNIS: Alle sechs Punkte wurden aus den Quellen entschieden. Kern-Entscheide:
KEIN Test-Skip auf irgendeiner Ebene (lazy lebt nur als Bau-Artefakt-Reuse, Voll-ctest je Welle
bleibt Pflicht); XML-Deaktivierung braucht ein additives active="true|false" am <axis ref>, weil
der wirksame Hebel heute in CMake statt in der Anwender-XML liegt; page_type ist keine neue Achse,
sondern System-Capability page_topology + Organ-NTTP AllocPageHint.

HINWEIS: Rohdaten-Sicherung, keine Struktur-Autoritaet. Autoritativ sind die benannten
Session-Docs und die Memories. Agent-Volltranskripte (agent-*.jsonl) sind NICHT gesichert.
