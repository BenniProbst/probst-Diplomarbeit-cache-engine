# ERGEBNIS — Frage E-3 (PV-4 Paper-Kopplung)

## VERDIKT: TEIL-ENTSCHIEDEN

Die Frage zerfällt in zwei Teile mit unterschiedlichem Status: das **Bau-GO ist entschieden**, die **Reichweiten-/Termin-Frage ist offen** — und wird buchstäblich *heute* (17.08., Fristtag) zum wiederholten Mal als unbeantwortete Owner-Vorlage geführt.

---

## (1) ENTSCHIEDEN: Das Bau-GO selbst

**Owner wörtlich** (aktueller/primärer Fundort — die im Dokument mehrfach zitierten Anker `:15584`, `:16628`, `:16760` sind **stale** und zeigen wegen späterer Einfügungen ins Ledger auf falsche Stellen; der tatsächliche Text steht hier):

> `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:29396` — Tabelle „VIER ENTSCHEIDE, die der Owner in derselben Nachricht getroffen hat", Zeile „Paper-Kopplung bauen?": **„Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache mit mir im Detail."**

Kontext davor, ebenfalls Owner verbatim, definiert den **Gegenstand** exakt so, wie ihn die Aufgabenstellung zitiert:

> `:29353` — „Das ist die wissenschaftliche Frage der Arbeit in einem Satz: nicht *welche Komposition ist die beste*, sondern **‚waere Papers X Algorithmus fuer Achse A besser gewesen als der von Paper Y, bei sonst gleicher Konfiguration?'**"
> `:29268-29269` — Präzisierung: der Auftrag heißt nicht „koppeln", sondern **„je Paper die XML ermitteln"** (jedes Paper wird als eigenes Experiment-XML reproduziert, PRT-ART-Prüfling in dieselben Achsen eingesetzt).

Datum: **08.08.2026**, Abschnitt „NACHTRAG 08.08.2026 — OWNER-KERN: DER EXPERIMENT-B+-BAUM IST DIE VERGLEICHS-ORDNUNG" (`:29316`). Definition als Posten: **PV-4** = „Referenzierte Paper-Template-Profile" (`:21633`, §60-SCHLUSS, U-8-③).

**Was daraus für den Bau folgt:** Bauauftrag steht — je Paper ein Experiment-XML, Paper als eigener Prüfling in der PRT-ART-Registry, „sorgfältige Design-Planung" **und** eine Owner-Rücksprache „im Detail" sind explizite Vorbedingungen, keine Formalität.

---

## (2) OFFEN: Die vom Owner selbst gesetzte Bedingung ist nie erfüllt worden

Drei unabhängige Dokumente stellen **übereinstimmend** fest, dass die zugesagte Rücksprache nie stattfand:

- `docs/plaene/20260808-WELLENPLAN-ANLAGE-luecken-defekte-einwaende.md:481` (Einwand E3): „Der Plan schiebt das als »Paper-Research-Vollausbau« nach W7 … **ohne Owner-Vorlage, ohne Risiko-Eintrag**."
- `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-369-soll-211-ist.md:773` (OV-13, „ersetzt OV-7"): „**Die Ruecksprache hat nie stattgefunden.**"
- `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/explore_karte_e3.md` (Fund 2, Code-Gegenprobe 16.08.): `grep -rn "Paper-Kopplung|PV-4|paper_template"` über den ganzen ce-Baum = **0 Treffer**.

**OV-Nummern-Kollision** (Ledger selbst warnt davor, `:1380-1387`, und dokumentiert sie hier `:12889-12902`, W-9): dieselbe Reichweiten-Frage lief nacheinander als **OV-7 → OV-13 → OV-14** über verschiedene Plan-Dokumente, **nie vom Owner konfirmiert** — nur als *Empfehlung* geführt:

> `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:1007` — „OV-14 PAPER-KOPPLUNG": „Bau nach der Abgabe … — ja?" Empfehlung (fett, **nicht Owner-Antwort**): „ja … dies IST die von dir geforderte Rücksprache im Detail". **Frist: „Mo 17.08., sonst automatisch W7."**
> `:974` (Abschnitt „WAS FÄLLT"): „Paper-Kopplung (OV-14) → W7 mit Klartext-Satz in Kap. 5".

`docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` — Gegenprobe: **0 Treffer** für PV-4/Paper-Kopplung/OV-13/OV-14. Der Posten hat **keine Nummer im Haupt-Taskboard** (#15–#84).

**Heute (17.08., der genannte Fristtag selbst)** wurde die Frage frisch und eigenständig neu gestellt:

> `docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:419-444`, „E-3 — Paper-Kopplung / PV-4: Reichweite bestaetigen". Empfehlung: „**Die Ruecksprache jetzt fuehren, in einem eigenen Slot vor W4**" — mit demselben GO-Zitat, derselben Owner-Kernfrage, plus Objektbeleg: 33 SOTA-Profile ohne Experiment-XML, `profile_ref` geparst/nie dereferenziert, 7 `base_tiers` erzeugen 0 Binaries.

**Live-Stand des Ledgers** (heute, während dieser Prüfung): der Owner beantwortet dasselbe Fragenbündel gerade jetzt, Gruppe für Gruppe — `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:115` (KON103, Gruppen A/B/C) und `:19` (KON104, Gruppe D, neuester Eintrag) sind bereits gebucht. **Gruppe E (E-1…E-4, darunter E-3) ist zum Zeitpunkt der jüngsten Konsolidierung noch nicht erreicht/gebucht** — kein KON105 vorhanden.

---

## (3) Engste Rest-Frage (ein Satz)

**Findet die am 08.08. zugesagte „Rücksprache im Detail" zur Reichweite von PV-4 jetzt statt, in einem eigenen Slot vor W4 (Empfehlung sowohl der alten OV-13/OV-14-Zeile als auch der heutigen E-3-Vorlage) — oder bestätigt der Owner stattdessen die automatische Verschiebung nach W7 mit einem Methodikgrenze-Satz in Kapitel 5?**

Das deckt sich mit der Vermutung der Aufgabenstellung: es ist **keine offene Richtungsfrage** mehr (die wissenschaftliche Frage und das Bau-GO sind seit 08.08. wortwörtlich fixiert), sondern eine **Termin-/Scope-Bestätigung**, die bereits als fertig formulierter Slot-Vorschlag vorliegt und nur noch der Owner-Unterschrift bedarf.

**Randbefund (nicht Kern der Frage, nicht tiefgeprüft):** „P7 Paper-Isolations-Modus" (`:1413`, KON77-03) ist ein **separater, kleinerer** Posten mit eigenem Platz im Plan („eigener Planer-Feature-Posten Wellenplan §18, nach F1") — nicht dieselbe Reichweitenfrage.

---

## (4) GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT:** Ledger (PV-4-Definition `:21633`; primäre GO-Quote `:29268-29396`; W-1/W-9-Selbstkorrekturen `:12760-12902`; §60-Post-v3-Liste `:21550-21650`; KON77-03 `:1395-1413`; Live-Konsolidierungen KON97–KON104 `:19-906`) · WELLENPLAN-ANLAGE (`:183`, `:481`) · WELLENPLAN-ENDFASSUNG-369 (`:191`, `:702-774`) · WELLENPLAN-ENDFASSUNG-v2 (`:974`, `:1007-1014`, Kopf) · GOAL-V8-DOSSIER (Gegenprobe, 0 Treffer) · heutige Owner-Vorlage E-3 vollständig · explore_karte_e3.md (Fund 2) · ce-Checkout: Existenz von `algorithm_profiles/sota/`, `profile_facade/sota_catalog.hpp` bestätigt.

**NICHT GEPRÜFT:** restliche Rohdaten-Karten unter `docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/` (r1–r5, DOSSIER.md) außer dem für E-3 zitierten Ausschnitt · `docs/termine/` (Betreuer-Glossare) auf Ursprungserwähnung · Quelltext von `sota_catalog.hpp`/`profile_run_facade.cpp` im Detail (33-Profile-Zahl aus E-3/r5-A26 übernommen, nicht selbst nachgezählt) · mögliche Owner-Antwort auf Gruppe E, die zeitgleich mit dieser Prüfung in der laufenden Mehr-Agenten-Session entstanden sein könnte (Live-Dokument, Momentaufnahme zum Lesezeitpunkt).