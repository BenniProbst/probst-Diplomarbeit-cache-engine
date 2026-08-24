# SESSION-VORLAGE B.0 -- Neugruendung und Schreiberwechsel (angelegt 24.08.2026, Z21-docs-Sammel)

STATUS: Dies IST die "Session-Vorlage B.0". Sie existierte bis zum 24.08.2026 als Objekt
nirgends (U-4-Befund, Wellenplan par.23.5-Umfeld: 0 Treffer fuer 'Stopp-Baustein',
'Session-Vorlage', 'B.0' in Board, par.18-21 und Register 12.4+13). AB-07 verlangte:
Ort ZUERST klaeren/anlegen (offene Frage 7 des Fahrplans), DANN den K16-Stopp-Baustein
einsetzen, Vollzug im KON-/Docs-Zug quittieren.

ORT-FESTLEGUNG (Kandidaten-Abwaegung, ablock/lande-auflagen.md Abschnitt 6):
(a) Wellenplan-Session-Gruendungs-Block -- verworfen: der Wellenplan ist ein PLAN-Dokument
    mit hoher Anbau-Kollisionslage (lebende Nachtrags-Zweige); eine Betriebs-VORLAGE gehoert
    nicht in die Plan-Historie.
(b) Neugruendungs-/ARBEITSWEISE-Dokument der Handover-Konvention docs/sessions/ -- GEWAEHLT:
    die Handover-/Session-Konvention lebt im super unter docs/sessions/
    (reference_diplomarbeit_impl_session_handover_location); dort wird B.0 als EIGENES,
    benanntes Vorlagen-Dokument angelegt (diese Datei). Kuenftige B.0-Bausteine
    (z. B. T-14-Memory-Neuzugaenge der 12.4-Docs-/Memory-Zug-Liste) werden HIER gebuendelt.

VERWENDUNG: Bei jeder Session-Neugruendung nach Kipp/Riss UND bei jedem Worktree-
Schreiberwechsel ist diese Vorlage der Einstieg; der K16-Stopp-Baustein unten ist PFLICHT
bei jedem Worktree-Uebergang. Ergaenzungen nur ADDITIV mit Datum (Doku nie loeschen).

--------------------------------------------------------------------------------
## B.0.1 K16-STOPP-BAUSTEIN (Schreiberwechsel-Protokoll, Pflicht bei jedem Worktree-Uebergang)

K16-STOPP-BAUSTEIN (Schreiberwechsel-Protokoll, Pflicht bei jedem Worktree-Uebergang):
Ein Worktree-Schreiberwechsel ist ein PROTOKOLL (Stopp -> Bestaetigung -> Start), kein Spawn.
1. VOR jedem Nachfolger-Start im selben Worktree: dem Vorgaenger eine explizite STOPP-ORDER
   senden und die Bestaetigung abwarten (oder seine Mailbox-Lage pruefen) -- "Kontext am Ende"
   + saubere Uebergabe ist KEIN Stillstand, solange Nachrichten zustellbar sind; jede
   SendMessage resumed den Agenten.
2. EIN Schreiber je Worktree; git commit nimmt die ganze Staging-Area.
3. Symptom-Erkennung: "Aenderung spurlos verschwunden" oder Fremd-Edits im eigenen Baum
   => SOFORT lsof/Prozessliste auf parallele Schreiber, nicht Umgebungs-Mystik.
(Quelle: K16-Vorfall 18.08.2026, bump15-a/bump15-b; KON119-02-Vorfallskern.)

--------------------------------------------------------------------------------
## B.0.2 NEUGRUENDUNGS-MINIMUM (Verweise, kein Ersatz der Quellen)

1. Kipp-Ritual: ARBEITSWEISE + Memories der letzten 3 Tage lesen (Owner-Doktrin;
   /goal-Trio NIE voll einlesen, Paragraph-Nachschlag erlaubt).
2. Ledger-Kopf = juengste KON (docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md) ZUERST lesen.
3. Slot-/Worktree-Lage messen (Bauslots wer-Dateien, git worktree list) BEVOR ein Claim oder
   ein Schreiber-Start erfolgt; K20: nie interaktive Sessions killen, TTY-idle beweist nichts.
4. Uebergaben in EIGENE Datei, nie in die wer-Datei eines fremden Claims.
