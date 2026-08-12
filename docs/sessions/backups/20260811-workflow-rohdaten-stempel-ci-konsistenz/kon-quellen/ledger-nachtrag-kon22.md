## NACHTRAG 12.08.2026 — KON22: DIE 5-KONTEXTE-ERNTE — ZEHN UNVERBUCHTE OWNER-ENTSCHEIDE (WF3)

**Der Einlese-Auftrag aus KON17-04 ist erfüllt** (7 Leser über 6 Kontexte, 180 distinkte
Owner-Texte über drei Transkript-Pfade, Ledger-Abgleich: **23 verbucht · 10 UNVERBUCHT ·
1 Widerspruch**). Volltext: `docs/sessions/20260812-WF3-SYNTHESE-fuenf-kontexte-einlesen.md`
*(Kopf der Synthese technisch abgeschnitten; die Rohdaten aller 9 Agenten sind vollständig im
Journal und im Backup)*. **Jeder Eintrag unten trägt seine Transkript-Zeile** — Zitate wörtlich.

---

### KON22-01 — 🔴 DIE ZEHN UNVERBUCHTEN OWNER-ENTSCHEIDE, jetzt verbucht

**(1) Abgabe = Ausfertigungsdatum** *(Z. 35912)* — *„D-4: Abgabe wird das Ausfertigungsdatum."*
Schließt die in KON3-09 ausdrücklich als FEHLT geführte Prüfungsamt-Frage: **15.09.2026 ist das
Ausfertigungsdatum.**

**(2) 🔴 LIZENZ: Cache Engine wird nach FÜNF JAHREN frei** *(Z. 35912)* — *„C-2: Ja, cache engine
nach 5 Jahren frei verfügbar ab heute."* Ein terminierter **Change-Date-Entscheid** (Übergang zu
freier Verfügbarkeit **fünf Jahre ab Sessiontag**, d.h. ~11.08.2031), der in der gesamten
RANG-C-Lizenzdokumentation fehlte. → in die Lizenz-Strecke (#66) einarbeiten.

**(3) Research-and-Teaching-Klausel BLEIBT** *(Z. 35912)* — *„C-4: Ja, die Research-and-Teaching-
Klausel bleibt."* (0 Ledger-Treffer zuvor.)

**(4) Prüfungsunterlagen werden MIT veröffentlicht** *(Z. 35912)* — *„C-3 JA: Prüfungsunterlagen
(8 Exposés, 3 PDFs mit Betreuer-Mailverkehr, Anmeldeformular) gehören zu super und werden
mitveröffentlicht."* Schließt die bei KON2-26 als OFFEN geführte Frage. ⚠️ Die drei PDFs tragen
Betreuer-Namen und @tu-dresden-Adressen — **vor dem Public-Release** gehört dieser Entscheid in
die Release-Checkliste (er ist Owner-Wort, die Umsetzung bleibt an den Release-Zeitpunkt gebunden).

**(5) 🔴 OPERATIV: die MinIO-Keys wurden vom Scrub MITGENOMMEN** *(Z. 37651)* — *„Die keys minio
wurden vom scrub mitgenommen. Du musst sie aus Cluster git cred vault neu suchen und neu
einsetzen, um das System zu testen."* **Status heute: UNGEPRÜFT, ob das Neu-Einsetzen je erfolgt
ist.** Ohne die Keys ist der MinIO-Teil des Systems nicht testbar. → eigener Prüf-/Bau-Posten,
Vault-Doktrin gilt (blind per mapfile, rückwärts bis HTTP 200).

**(6) GO zur Rotation** *(Z. 35912)* — Rotation der **sieben** CI/CD-Variablen (Gruppe 3 +
Projekt 288: `MINIO_SECRET_KEY`, `GITLAB_DEPLOY_TOKEN`, `CE_SUBMODULE_TOKEN`, `MINIO_ACCESS_KEY`,
`COMDARE_NFS_DROP_TOKEN`, `COMDARE_THESIS_WRITEBACK_TOKEN`, +1) **und der 776
Runner-Registration-Token** via `reset_registration_token` je Projekt — *„volles GO"*. Der
KON2-01-Fund (sieben Geheimnisse im Transkript) hat damit sein dokumentiertes GO. **Status der
Durchführung: die 7 Variablen wurden rotiert (Task #70 completed); die 776 Runner-Token sind
UNGEPRÜFT.**

**(7) `test:secrets` verlässt den prod2-Pool** *(Z. 35912)* — *„D-1: prod2 test:secrets aus dem
CI-Job-Pool herausnehmen."* (Befund: 16 s grün auf prod1, 102 min Hänger auf prod2.)
**Status: ungeprüft, ob umgesetzt.**

**(8) 🔴 DOKTRIN: beide Compiler Pflicht, Skip VERBOTEN** *(Z. 35912)* — *„D-2: Er baut immer und
es darf nicht nur clang grünen, sondern das Projekt muss auch mit gcc parallel bauen, beide
compiler Pflicht! Gebaut wird immer, skip ist VERBOTEN."* Verschärft die bestehende
gcc/clang-Historie zur **bindenden Regel**: `build:gcc` und `build:clang` sind
Pflicht-Parallel-Baustufen, kein `changes:`-Skip, kein Weglassen.

**(9) `-Wall`/`-Werror` überall: GO** *(Z. 35912)* — *„D-3: Ja, -Wall/-Werror überall
einführen."* Die Kosten-Nutzen-Vorlage hatte den Entscheid nie erhalten — er existiert.
⚠️ Zusammenzuführen mit Task #44 („-Werror global darf NICHT in einem Schritt"): das GO gilt dem
**Ziel**, die Etappen-Regel dem **Weg**.

**(10) 0-Byte-Prüfauftrag** *(Z. 34792)* — Platten-/Ursachenprüfung für 0-Byte-Ankünfte; der
konkrete Vorfall ist im Ledger nur als allgemeine Doktrin verbucht. **Erledigt** (Platte war voll,
Hooks-Ausfall dokumentiert) — hier nur der Vollständigkeit halber verbucht.

---

### KON22-02 — DER EINE WIDERSPRUCH: BACKUP-REF-LÖSCHUNG

Die Extraktion las bei A-1 *(Z. 35912)* ein *„volles GO"* zu einer Löschung von
`refs/backup/pre-secret-scrub-20260802` „nach Vollscan-Beleg". **Der Ledger führt eine gestufte,
terminierte Lösung** (stehen lassen → nach der Lieferphase in rechtebeschränktes Bundle →
**dann erst** Remote-Ref löschen). **Es gilt die gestufte Ledger-Fassung** — Remote-Löschung
braucht ausdrückliches, gegenstands-genaues GO (Hausdoktrin), und das A-1-GO deckte den
Vollscan-Beleg, nicht den Zeitpunkt. Keine Löschung vor der Lieferphase.

---

### KON22-03 — WAS DIE ERNTE SONST BESTÄTIGT

**23 Schärfungen sind bereits verbucht** (KON11-02 Konfliktregel · KON17-04 XML→PDF ·
KON18-01 C++23-Bibliothek · Vollbau-Gate mit vier Bedingungen *„Wir bauen, wenn Lagerhaltung
fertig und Stempel fertig und Algorithmen versioniert und Messung einbaubar"* (Z. 35912, deckt
sich mit dem State-Pattern-Satz) · Stempel = zentraler Blocker · 10-Wochen-Explore für ALLE
Fragen · Dual-Remote-Doktrin · Rollenmodell Design=Fable5max/Bau=Opus5max/Verify=Fable5xhigh ·
„jede Verarbeitung braucht vorne einen Explore, ob der Kern ihrer Aufgabe stimmt" · u.a.).

**Für die XML→PDF-Ketten-Planung** (KON17-04) liefert die Ernte die Prioritäts-Sätze der fünf
Kontexte in chronologischer Folge — Grundlage der Konsolidierung nach WF1/WF4-Rücklauf.
