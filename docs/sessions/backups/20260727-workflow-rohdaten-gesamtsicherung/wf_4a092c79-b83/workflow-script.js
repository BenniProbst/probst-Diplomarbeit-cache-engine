export const meta = {
  name: 'goal-v3-konsolidierung-ledger-audit',
  description: 'Widersprüche in Ledger+Doku finden (neueste Aussage gewinnt) und GOAL-TEXT V3 entwerfen',
  phases: [
    { title: 'Audit', detail: '5 parallele Widerspruchs-Auditoren' },
    { title: 'Synthese', detail: 'GOAL-TEXT V3 + Korrekturliste' },
  ],
}

const R = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const L = `${R}/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
const S = `${R}/docs/sessions`

const CHRONO = `AUFLÖSUNGS-REGEL (bindend): Die NEUESTE Aussage gewinnt. Chronologie (älteste→neueste):
§0–§11 des Ledgers (Stand 03./04.07.) < §12-Einträge chronologisch < §13.1–13.8 (05.07.) < §13.9 USER-ENTSCHEIDE (05.07., autoritativ) < §13.10 W1–W5 (05.07.) < §13.11 (05.07. abends) < §12-Einträge vom 06.07. < die 06.07.-User-Direktiven (in §9 + §12 verankert: Matrix-Reuse-Schärfung an #256; Codex NUR Erstimplementierung/Fixes manuell; Pipeline STRIKT GRÜN je großer Aufgabe; Metaprogrammierung zwingend durchsetzen; Metaprogrammierungs-/Interface-Doktrin inkl. Product-Matrix-Instanziierung; Research = early Products — supersediert „Fassaden NUR Produkte/Research direkt"). USER-Aussagen schlagen abgeleitete Doku. Melde jede Kollision mit Zeilennummern beider Seiten.`

const AUDIT_SCHEMA = {
  type: 'object',
  properties: {
    widersprueche: { type: 'array', items: { type: 'object', properties: {
      fundstelle_alt: { type: 'string', description: 'Datei:Zeile + Wortlaut-Kern der ÄLTEREN/verlierenden Aussage' },
      fundstelle_neu: { type: 'string', description: 'Datei:Zeile + Wortlaut-Kern der NEUESTEN/gewinnenden Aussage' },
      korrektur: { type: 'string', description: 'Konkrete additive Korrektur-Aktion (was wird wie markiert/nachgezogen)' },
      schwere: { type: 'string', enum: ['BLOCKER', 'STATUS-STALE', 'NACHRICHTLICH'] },
    }, required: ['fundstelle_alt', 'fundstelle_neu', 'korrektur', 'schwere'] } },
    fuer_goal_v3: { type: 'array', items: { type: 'string' }, description: 'Was GOAL-TEXT V3 gegenüber V2 ändern/aufnehmen muss (aus Sicht dieses Auditors)' },
  },
  required: ['widersprueche', 'fuer_goal_v3'],
}

phase('Audit')
const audits = await parallel([
  () => agent(`${CHRONO}

Du auditierst die ÄLTERE Ledger-Hälfte gegen die neueste. Lies ${L} VOLLSTÄNDIG. Prüfe JEDE Aussage in §0–§11 (GOAL/MISSION §0, FF-Tabelle §1, Blocker §2, Spur S §3, ABI-Budget §4, Spur P §5, Mess-Gate §6, CI §7, Deferred §8, Governance §9, Taxonomie §10, TODO-Liste §11) darauf, ob sie durch §12/§13 oder die 06.07.-Direktiven überholt/widersprochen ist (z.B. erledigte Punkte noch als offen, alte Reihenfolgen, alte ABI-/CMD-Aussagen, S5/S6-Status, AP-2-Alt-Definition, veraltete Achsen-/Familien-Zählungen). Antworte auf Deutsch.`, { label: 'audit-alt-vs-neu', phase: 'Audit', schema: AUDIT_SCHEMA }),

  () => agent(`${CHRONO}

Du auditierst TODO-Katalog + Goal-Text. Lies in ${L} die §13.3 (TODO-Katalog #253–#272), §13.4 (GOAL-TEXT V2 wörtlich), die NEUE-TODOs-Zeile nach §13.9 (#273–#275) und ALLE §12-Einträge vom 05.–06.07. Prüfe: (a) jeden #25x/#27x-Status in §13.3 gegen die §12-Realität (was ist DONE/teilweise/gated — z.B. #261 sagt „9 Einzel-Commits", real S7-1..10 = 10 Familien KOMPLETT; #262-Rest; #263 KOMPLETT; #264 a–c done/264-d gated; #268 DONE; #271 DONE; #265 265-a done; #257/#258-Stand; #274-Plan-Entwurf); (b) jede Zeile des GOAL-TEXT V2 (KONTEXT-PFLICHT/ARBEITSREIHENFOLGE/DEFAULTS E-A..E-E/KADENZ/TABUS/ESKALATION/STOP) auf Widerspruch zu §13.9/§13.10/§13.11/06.07.-Direktiven (z.B. E-A „keine Fassade" vs. Research=early-Products-Instanziierung; E-D „8er-Liste NUR vom User" vs. W5/D1; Reihenfolge nennt erledigte Punkte). Antworte auf Deutsch.`, { label: 'audit-katalog-goalv2', phase: 'Audit', schema: AUDIT_SCHEMA }),

  () => agent(`${CHRONO}

Du auditierst die Doku-Dateien gegen die 06.07.-Doktrin. Lies VOLLSTÄNDIG: (1) ${S}/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md (bes. Teil 4 Fassaden/Research), (2) ${R}/docs/HANDOVER-BEP-ABTEILUNG-20260705.md (§2 GOAL-VORLAGE, §4 Stränge, §5 Gates), (3) ${S}/20260706-274-MATRIX-MIGRATIONSPLAN-ENTWURF.md, (4) in ${L} den §9-Doktrin-Block + die §12-Einträge vom 06.07. Finde JEDE Stelle in (1)-(3), die durch die Doktrin (Metaprogrammierung Modul-intern erlaubt; Products+Research=eigene Instanziierungs-Matrix; Binary-only nach außen; Quellreferenz-Pflicht) überholt ist — bes. „Fassaden NUR Produkte", „Research darf direkt konsumieren", #274-Plan Schritt 13 „Research-Verdrahtung via source=modules + Übergangs-Aliase", GOAL-VORLAGE-Verweise auf V2. Antworte auf Deutsch.`, { label: 'audit-doku-doktrin', phase: 'Audit', schema: AUDIT_SCHEMA }),

  () => agent(`${CHRONO}

Du auditierst Prozess-/Kadenz-Regeln auf Kollisionen und konsolidierst sie für V3. Lies in ${L}: §13.4-KADENZ-Zeile, §9 (inkl. 06.07.-Doktrin), die §12-Direktiven-Einträge (05.–06.07., bes. Voll-Review-Pflicht, Mojibake-Check, Remote-Lösch-Verbot, „Codex nur Erstimplementierung/Fixes manuell", „Pipeline strikt grün je großer Aufgabe", ci.skip-Praxis für docs-only-Pushes bei laufender Beweis-Pipeline, Metaprogrammierungs-Review-Linse) + ${R}/docs/HANDOVER-BEP-ABTEILUNG-20260705.md §2 Kadenz-10-Punkte. Liefere: (a) Kollisionen (z.B. V2-Kadenz „codex exec" als Standard vs. 06.07. „nur Erstimplementierung"; „max 1× re-triggern" vs. „Fehler manuell fixen"), (b) die DEDUPLIZIERTE, konsolidierte Kadenz-+TABU-Liste für V3 (vollständig, nummeriert, keine Doppelungen, neueste Fassung je Regel). Antworte auf Deutsch.`, { label: 'audit-kadenz-regeln', phase: 'Audit', schema: AUDIT_SCHEMA }),

  () => agent(`${CHRONO}

Du auditierst §13.5–§13.11 + Handover-Restbestand auf innere Fehler. Lies in ${L} §13.5 (RESTORE), §13.6 (Matrix-Fragen), §13.7 (AP-2-K2), §13.8 (S7-Forks), §13.9, §13.10 (W1–W5 inkl. „Korrigierte TODO-Definitionen" + OFFEN-Liste), §13.11 + ${R}/docs/sessions/20260705-SESSION-HANDOVER-goalv2-audit-restore-ci-s7-ap7b.md §4 (Degenerationen) + §6 (13 User-Gates). Prüfe: (a) Welche §13.6/§13.7/§13.8-Fragen sind durch §13.9 (A1–E3) bzw. durch §12-06.07.-Realität BEANTWORTET, stehen aber noch als offen? (b) Welche Handover-§4-Degenerationen sind inzwischen GESCHLOSSEN (z.B. §4-1 honest-0-Familien durch S7-1..10; §4-5 perm_runner durch #271)? (c) Welche der 13 Gates aus Handover-§6 sind durch §13.9 beantwortet vs. echt offen? (d) Zähl-/Zahlenfehler (Familien 9 vs. 10, Achsen 21/25 vs. 22/26, Umbrella 16 vs. 22 …). Antworte auf Deutsch.`, { label: 'audit-1358-handover', phase: 'Audit', schema: AUDIT_SCHEMA }),
])

phase('Synthese')
const clean = audits.filter(Boolean)
const synth = await agent(`Du bist der Konsolidierungs-Autor. Aus den 5 Audit-Ergebnissen entwirfst du GOAL-TEXT V3 und die Korrekturliste. ${CHRONO}

AUDITS:
${JSON.stringify(clean, null, 2)}

LIEFERE auf Deutsch:
1. goal_text_v3: Der VOLLSTÄNDIGE GOAL-TEXT V3 in exakt der V2-Blockstruktur (> **KONTEXT-PFLICHT:** … > **ARBEITSREIHENFOLGE:** … > **ENTSCHEIDUNGS-DEFAULTS:** … > **KADENZ je Increment:** … > **HARTE TABUS:** … > **ESKALATION:** … > **STOP-BEDINGUNG:**), Markdown-Blockquote-Zeilen. Inhaltlich: Reihenfolge nur noch NICHT-erledigter Punkte (Stand 06.07.: K1 done bis auf Pipeline-Beweise; als nächstes #267 CMD-1 → 265-b → #266 → dann gated/User-GO-abhängig #270a/#256-nach-#274-GO/234-V-nach-Antwort; 264-d gated #179; #269/#244 nach W5-Definition; #272 Infra-HO), Defaults nach neuester Fassung (E-A präzisiert um Instanziierungs-Doktrin; E-D nach D1/W5 korrigiert), Kadenz = die konsolidierte 06.07.-Fassung (Codex NUR Erstimplementierung + Dossier-Verbot compile-time→runtime; Fixes MANUELL; Voll-Review Zeile-für-Zeile; Mojibake; clang-format 22.1.8; doppelt-literal; granular; beide Remotes; Pipeline STRIKT GRÜN je großer Aufgabe VOR nächster Hauptaufgabe; docs-only mit ci.skip bei laufender Beweis-Pipeline; Ledger §12 fortschreiben), TABUS inkl. Metaprogrammierungs-Doktrin + Remote-Lösch-Verbot + golden/ABI/Oracle + Cluster-read-only + AskUserQuestion NIE + User-Live-Dateien, ESKALATION (Fork→GEPARKT; Codex unsicher→ultracode; Infra→HO; Unklarheit→Diplomarbeit-TEXT nachlesen), STOP-BEDINGUNG wie V2.
2. korrekturen: Die konsolidierte, deduplizierte Korrekturliste (jede: Ledger-/Doku-Zeile, verlierende Aussage kurz, gewinnende Aussage kurz, additive Aktion, Schwere) — nach Schwere sortiert.
3. geschlossene_punkte: Liste der Fragen/Gates/Degenerationen, die als BEANTWORTET/GESCHLOSSEN markiert werden können (mit Beleg).`, {
    label: 'synthese-v3', phase: 'Synthese', schema: {
      type: 'object',
      properties: {
        goal_text_v3: { type: 'string' },
        korrekturen: { type: 'array', items: { type: 'string' } },
        geschlossene_punkte: { type: 'array', items: { type: 'string' } },
      },
      required: ['goal_text_v3', 'korrekturen', 'geschlossene_punkte'],
    },
  })

return { synth, audits: clean }