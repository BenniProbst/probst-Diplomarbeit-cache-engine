export const meta = {
  name: 'bestandslog-plan-luecken',
  description: 'User-Korrektur P2/P3/P4: Plan-Quellen (Ledger-Verbatim, Sessions, User-Transkript-Worte, Code-Ist) gegen die Verdikt-Behauptungen — N7-Soll-Semantik, E1-E5-Antworten AUS dem Plan, Bestandslog-AN-Ertuechtigung',
  phases: [
    { title: 'Quellen', detail: '4 parallele Voll-Leser (Ledger, Code, User-Worte, Verdikt-Behauptungen)', model: 'opus' },
    { title: 'Abgleich', detail: 'Behauptung-fuer-Behauptung gegen Plan+Code', model: 'opus' },
    { title: 'Design-Vorlage', detail: 'zur User-Abnahme', model: 'opus' },
  ],
}

const S = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = S + '/Code/external/comdare-cache-engine'
const BK = S + '/docs/sessions/backups'

phase('Quellen')
const [ledger, code, worte, behauptungen] = await parallel([
  () => agent(
    `Lies aus ${S}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md ALLE Abschnitte zu §62 (komplett, alle B-Nachtraege N5 bis N15), §65 und §66 — grep -n nach '62' Sektions-Markern, dann die Blocke VOLLSTAENDIG lesen. Extrahiere WOERTLICH (Zitat + Zeilennummer) jeden User-KERN-Satz zu: (1) Schreib-Lock-Semantik (was deckt das Lock, wie lange, wann endet es — N7), (2) Multi-Write-Freigabe + Reservierungs-Eintrag-Dauer (N8: 'Millisekunden'?), (3) ETA-Berechnung als Haupt-Blocker, (4) Reservierung=Versprechen+Release-Pflicht+Takeover (+50%-Regel), (5) planer_block: WAS genau blockt der Planer fuer WEN ('CEB-Compile ohne ETA mit 30-min-Reservierung je Version'), (6) Bestandsdokument: Versionierung, Union-Merge, Neu-Inventarisierung, (7) zwei Bestaende/Realms (Binary vs Messwert, je eigene Strategy), (8) Batch-Planung/Slice-Queue/Producer-Consumer (N14), (9) 4096er-Batches, Gleichverteilungs-Pflicht. Nichts paraphrasieren, wo das Original zitierbar ist.`,
    { label: 'ledger-62-verbatim', phase: 'Quellen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `Lies den KOMPLETTEN Bestandslog-Code unter ${CE}/libs/cache_engine/builder/bestandslog/ (ALLE Dateien: bestandslog_document.hpp, bestandslog_lock.hpp, bestandslog_factory.hpp, reservation_lifecycle.hpp, lager_presence.hpp, artifact_cache_transport.hpp, fingerprint-bezogene, spool/writer falls dort) PLUS die Lager-Abschnitte in ${CE}/libs/cache_engine/builder/cache_engine_builder_iterator.hpp (Lager-Load, run_planer_driven_provision, store_reservation, bestandslog_active, ETA) PLUS store_document_merged und try_acquire_lock/release_lock Pfade. Liefere die IST-SEMANTIK praezise mit datei:zeile: (1) Was genau umschliesst try_acquire_lock..release_lock — nur den Dokument-Schreibvorgang oder auch object_store-Netz-Roundtrips? Wo liegen die Retries relativ zum Lock? (2) LockRecord.ttl_s Wert + Stale-Break-Logik, (3) Union-Merge-Komplexitaet real (Datenstrukturen: Vektor-Scan oder Map?), Dokumentgroesse-Treiber, (4) Reservierungs-Lebenszyklus (pro-forma 30min, ETA-Ersatz, Takeover-Funktionen + wer sie ruft), (5) pick_reservierung-Monotonie (done vs offen), (6) parse_bestandslog-Verhalten bei unbekanntem typ/status + store_document_merged bei unlesbarem Remote (Voll-Wipe-Pfad real?), (7) Wo der Bau-Pfad flusht (je 4096-Fenster? je Binary?) und ob der Mess-Pfad Bestandslog-Schreiber hat.`,
    { label: 'code-ist-semantik', phase: 'Quellen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `Sammle die WOERTLICHEN User-Beschreibungen der Bestandslog-/Lock-/Reservierungs-Architektur aus den Session-Quellen: (1) ${S}/docs/sessions/ — alle Dateien mit Datum 20260722/20260723 (grep -l -i 'bestand\\|lager\\|lock\\|reservierung' ${S}/docs/sessions/2026072*.md, dann die Treffer VOLLSTAENDIG lesen); (2) die Transkript-Extrakte ${BK}/20260726-kontext-neugruendung-workflow/ergebnisse/*transkript*.md — grep -l -i 'bestandslog\\|lager\\|lock\\|reservier' und die Treffer-Dateien vollstaendig lesen, USER-Direktiven wortgenau herausziehen (Zeilen die mit USER beginnen bevorzugt). Liefere: chronologische Liste der User-Saetze (wortgenau) zu Lock/Reservierung/Bestandslog-Pflege-beim-Messen/Realms/planer_block, je mit Quelle. KEINE eigenen Interpretationen, nur Zitate + minimale Einordnung.`,
    { label: 'user-worte', phase: 'Quellen', model: 'opus', effort: 'high' }
  ),
  () => agent(
    `Lies ${BK}/20260726-g4b-planung-workflow/ergebnisse/00-verdikt-abeddd8c.md komplett + 05-adversarial-*.md komplett + 03-ledger-konformitaet-*.md komplett. Extrahiere als nummerierte PRUEFLISTE jede TATSACHEN-Behauptung, auf der die Verdikt-Entscheide (d2-HOLD, N7-Aufschub, Bestandslog-AUS-Empfehlung P-2) beruhen — insbesondere: (B1) 'kritische Sektion enthaelt object_store mit ~49min Worst-Case' (12 Retries a 5s + 2x120s), (B2) 'LockRecord.ttl_s=30', (B3) 'quadratischer Merge O(|a|*|b|), ~8.6e9 Vergleiche bei 131072', (B4) '35-40MB XML je flush, komplett runter+hochgeladen', (B5) '2x store_document_merged je 4096er-Fenster, Bau nicht auf provision_only gegated', (B6) 'pick_reservierung: done verwirft spaeteres offen unter gleicher id', (B7) 'Voll-Wipe: parse nullopt -> to_write=local', (B8) 'planer_block-Anker = Tier-Emission statt CEB-Compile-Strecke (E1)', (B9) 'owner_uuid nirgends gesetzt', (B10) 'run_planer_driven_provision = anderer ungetesteter Bau-Treiber', plus alle weiteren. Je Behauptung: exakte Quellen-Zeile im Bericht + welche Code-Anker genannt werden. NUR extrahieren, nicht bewerten.`,
    { label: 'verdikt-behauptungen', phase: 'Quellen', model: 'opus', effort: 'medium' }
  ),
])

phase('Abgleich')
const abgleich = await agent(
  `Du prueftest fuer den Architekten die Behauptungen des G4b-Verdikts gegen PLAN (User-KERN, Ledger-Verbatim, User-Worte) und CODE-IST. Der User (Owner) hat erklaert: das Verdikt hat 'den Plan nicht verstanden', die N7-Lock-Sektion dauert KEINE 40 Minuten, 'da sind gravierende Luecken', 'der Plan steht'. Deine Aufgabe: Behauptung fuer Behauptung (Liste unten) klassifizieren als BESTAETIGT (Plan+Code decken sie) / LUECKE-IM-VERDIKT (Verdikt hat Plan/Code missverstanden — erklaere den Denkfehler praezise) / ECHTER-CODE-DEFEKT (der Code weicht vom Plan ab — dann ist der CODE zu fixen, nicht der Plan zu aendern; KERN=Gesetz-Doktrin). Beachte besonders: N7 sagt 'Lock = kurze Schreib-Exklusivitaet am Dokument' und N8 'Reservierungs-Eintrag = Millisekunden' — wenn der Code die object_store-Retries INNERHALB des Locks ausfuehrt, ist das ein CODE-Defekt gegen N7, nicht ein Grund, N7 aufzuschieben. Pruefe Code-Anker selbst nach (Read in ${CE}), wo die Berichte sich widersprechen. Arbeite VOLLSTAENDIG durch alle Behauptungen.\n\n===== LEDGER-VERBATIM =====\n${ledger || 'AUSGEFALLEN'}\n\n===== CODE-IST =====\n${code || 'AUSGEFALLEN'}\n\n===== USER-WORTE =====\n${worte || 'AUSGEFALLEN'}\n\n===== VERDIKT-BEHAUPTUNGEN =====\n${behauptungen || 'AUSGEFALLEN'}`,
  { label: 'abgleich', phase: 'Abgleich', model: 'opus', effort: 'xhigh' }
)

phase('Design-Vorlage')
const vorlage = await agent(
  `Erstelle aus dem Abgleich (unten) die DESIGN-VORLAGE ZUR USER-ABNAHME fuer den heutigen Bau, gegliedert: \n(1) N7-LOCK-SOLL: exakte Semantik nach Plan (was das Lock deckt, Dauer, Ende-Bedingung), Ist-Abweichungen im Code als konkrete Fix-Schnitte (datei:zeile, minimal), Aufwands-Schaetzung ehrlich.\n(2) E1-E5-ANTWORTEN AUS DEM PLAN (planer_block Vertragsebene/Anker, id-Semantik+Maschinen-Feld+Re-Open/Retention, Strecken-Feld/POD, Wert-Funktion, Lock): je Entscheid die Plan-Antwort mit Zitat-Beleg; wo der Plan wirklich schweigt, EXPLIZIT 'PLAN SCHWEIGT — Owner-Entscheid noetig' schreiben (nichts erfinden).\n(3) BESTANDSLOG-AN-ERTUECHTIGUNG fuer Voll-Bau-4 (Option B, User-Order): minimale, gruendliche Fix-Liste, priorisiert (Voll-Wipe-Guard, Merge-Frage nach Abgleich-Ergebnis, try/catch, TRIES, echte 30-min-Frist, emit_storage_activation, Claim-Check/Takeover-Verdrahtung, Mess-Realm-Schreiber) — je Punkt: noetig-vor-Trigger JA/NEIN mit Grund, Schnitt, Aufwand.\n(4) BAU-REIHENFOLGE HEUTE (G4b-1 laeuft parallel nach Smoke): welche Scheiben, welche Agenten-Lanes, was seriell wegen Datei-Ueberlapp.\nASCII (§ ok), keine Secrets, alles mit datei:zeile bzw. Ledger-Zeilen-Belegen.\n\n===== ABGLEICH =====\n${abgleich || 'AUSGEFALLEN'}`,
  { label: 'design-vorlage', phase: 'Design-Vorlage', model: 'opus', effort: 'xhigh' }
)

return { vorlage }