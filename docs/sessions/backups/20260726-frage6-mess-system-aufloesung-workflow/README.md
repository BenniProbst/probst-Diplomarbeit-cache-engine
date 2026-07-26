# 20260726 Frage-6 Mess/System-Relation Aufloesung (Workflow-Rohdaten)

ZWECK: Die Relation zwischen Mess- und System-Achsen (Ordnung, Steuer-Verantwortung,
kSystemAxisOrder) aus den vorhandenen Owner-Definitionen SELBST aufloesen, statt den Owner
ein weiteres Mal zu fragen - Vorleistung fuer die Lane-A-Beauftragung (SYS-TAX).

AGENTEN: 4 (ledger-belege, owner-wortlaute, ist-code als parallele Beleg-Sammler + 1
xhigh-Aufloesung).

KERN-ERGEBNIS: Es gibt zwei unabhaengige Ebenen, damit keinen Widerspruch - (a) die
ORDNUNGS-/BENENNUNGS-Ebene (Rang eines Achsen-Typs im Verzeichnisbaum, Legende, Datei-/Job-Name)
und (b) die STEUER-/VERANTWORTUNGS-Ebene (Planer = Mess-Achsen, CEB = System-Achsen,
Tier = Organ-Achsen). Beweis: derselbe Achsen-Typ steht owner-seitig im Messdaten-Baum an der
Wurzel, im Binaries-Lager als tiefster Haupt-Achsen-Typ; eine Eigentums-Hierarchie koennte nicht
baumabhaengig kippen, eine Lager-Ordnung darf es. Damit sind E-05/W4 geschlossen, nicht offen.

HINWEIS: Rohdaten-Sicherung, keine Struktur-Autoritaet. Autoritativ sind die benannten
Session-Docs und die Memories. Agent-Volltranskripte (agent-*.jsonl) sind NICHT gesichert.
