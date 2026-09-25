# 05d UML-Klassenatlas -- Vertragsanlage (Browser-Export vom 05.08.2026) -- VERALTET

**Status: VERALTET.** Dieser Ordner ist die Kopie des UML-Klassen-Ordners aus dem Vertraege-Ordner der UG (NAS,
Vertragsanlage), uebernommen am 24.09.2026 nach Owner-Order 475. Er wird NICHT gepflegt. Die Aktualisierung auf den
dann geltenden Architektur-Zustand ist das letzte Glied der Basis-Strecke (Wellenplan) nach Welle 7; Traeger ist
Board #295. Bis dahin gilt fuer die Architektur der lebende Bestand (02_aktueller_master_REV7_7.md, 05b/05c).

Owner-Order 475 (24.09.2026 16:59:52Z, ASCII-Transliteration; byte-genau in der Order-Datei des Leads):
"Ich habe noch einen Auftrag fuer dich, der zur Basis-Strecke gehoert. Nach Welle 7 ganz zum Schluss muss das sich
unter Z:\Dokumente\Firmensachen\BEP_Venture_UG\Vertraege befindliche folder der UML-KLassen aktualisiert auf den dann
geltenden Architektur-Zustand geupdated werden, wir fuegen es jetzt schon unter docs in einen Architektur-Ordner hinzu
und vermerken es als veraltet."

## Herkunft und Stand

- Quelle: Vertraege-Ordner auf dem NAS (Share Cloud, Dokumente/Firmensachen/BEP_Venture_UG/Vertraege), Eintraege
  'comdare-cache-engine -- UML-Klassenatlas.htm' + '..._files/' (Original-Namen mit Gedankenstrich und Leerzeichen;
  hier auf einen ASCII-Namen gebracht, die Verzeichnis-Referenzen in der .htm entsprechend umgeschrieben, sonst
  byte-gleich). Dateidatum auf dem NAS: 05.08.2026 10:40Z (alle sechs Dateien).
- Art: Browser-Export "Webseite, komplett" der gerenderten Artefakt-Seite (frame-shell, a_002 = Atlas-Inhalt).
- Stand des Atlas: REV 5 (05.08.2026), ce-Stand 98eea2e7 -- derselbe Architektur-Stand wie
  05b_uml_klassenatlas_20260805.html (Roh-Artefakt-HTML, Commit 432a130c) und
  05c_uml_klassenatlas_20260902_artefakt-export.htm (Browser-Export vom 02.09.2026, Commit 74282893).
  Textgleichheit (Tags entfernt) zu 05c: 0.974; zu 05b: 0.868 (Rendering-Unterschiede, keine Inhaltsrevision).
- Pruefsummen (md5) der NAS-Kopie, remote gegen lokal 6/6 gleich; gitleaks ueber die Kopie: 0 Funde.
- Git normalisiert beim Einchecken CRLF -> LF (text=auto); die Repo-Blobs der .htm-Dateien tragen daher nicht die
  NAS-md5. Die byte-genaue NAS-Kopie (uml.tar) liegt im Lead-Beweisort 20260924-order-475-uml-klassenatlas/.

| Datei | Bytes | md5 (NAS-Kopie) |
|---|---|---|
| ...-export.htm (3 Referenzen umgeschrieben) | 164418 | adfd9787 (Original, vor Umschreibung) |
| _files/a_002_bbyy.htm | 10469531 | f5b3eec5 |
| _files/a_bbyy.htm | 420 | 6df81785 |
| _files/frame-shell-D3ziHTWQ_bbyy.js | 30158 | 0dd53a9e (identisch mit 05c) |
| _files/ProtectMainFrameFixed_bbyy.js | 199937 | 8af062ae |
| _files/a_data/main_bbyy.js | 21975 | 1df9f806 |

## Pflege

- Keine Aenderungen an diesem Ordner bis zur Aktualisierung nach Welle 7 (#295). Dann: neuer Export des dann
  geltenden Atlas, Ablage als 05e (oder Folge-Nummer) UND Rueckgabe in den Vertraege-Ordner (Vertragsanlage).
- Lebender Architektur-Bestand: 02_aktueller_master_REV7_7.md, 05b_uml_klassenatlas_20260805.md (+ .html), 05c.
