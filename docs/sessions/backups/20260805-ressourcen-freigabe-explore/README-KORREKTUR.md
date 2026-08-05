# README-KORREKTUR (05.08.2026) — Stufen-Doktrin-Nachzug fuer diesen Backup-Ordner

Dieser Ordner (`20260805-ressourcen-freigabe-explore/`) ist ein Backup der F6-Explore-Welle
(mittag-7). Die Berichte selbst (`freigabe.md`, `rufkette.md`, `ergebnis-roh.json`) bleiben nach
Doku-Doktrin UNVERAENDERT — dieses README traegt den additiven Korrektur-Vermerk daneben.

## Was hier STALE ist (mittag-7-Lesart)

- `freigabe.md` §1 (Zeilen 20-44) und die Freigeber-Tabelle §6 (Zeilen 122-133) tragen die
  **Ein-Stufen-Form** "System-Achsen GEBEN FREI, Organ-Achsen SETZEN DURCH" als Kernaussage.
  Die Tabelle kennt auf Achsen-Ebene NUR die System-HAUPT-Achse als Freigeber — die
  Mess-Achsen-Freigabe (Planer -> CEB), die Organ-Stufe-1 (CEB-RT-Freigabe der lazy
  Permutations-Wahl) und der Hybrid fehlen vollstaendig.
- `rufkette.md` §1.2 (Bullet "Ressourcen-Freigabe-Korpus") zitiert dieselbe Ein-Stufen-Form
  (mild — die Ruf-Ketten-Erhebung selbst ist kanon-vertraeglich und traegt keinen Stufen-Claim).

## Kanonische Stufen-Doktrin (Owner-abgenommen; LEDGER Nachtraege 05.08. mittag-9 + mittag-10, GO mittag-11)

- **MESS-Achsen = DREISTUFIG DEHNBAR:** Planer(Stufe 1: RUNTIME-Freigabe) -> CEB(Stufe 2:
  COMPILE-TIME-Einbau, Mess-Design + Pruefdock-Konfiguration) -> [Hybrid(CT)] ->
  Tier-Binaries(CT-Einbau, Observer/Ausstattung).
- **SYSTEM-Achsen = ZWEISTUFIG DEHNBAR** (exakt wie Mess gegen Hybride): CEB(Stufe 1:
  RUNTIME-Freigabe HW) -> [Hybrid(CT): gibt sich SELBST und seinen Tiers die System-Config CT
  mit] -> Tier(CT-Einbau).
- **ORGAN-Achsen = ZWEISTUFIG, HYBRID-UNBERUEHRT:** CEB(RT-Freigabe der lazy Permutations-Wahl)
  -> Tier(CT-Einbau); NUR in den Tier-Binaries verbaut.
- **GESETZ:** Stufe 1 IMMER Runtime-Freigabe in der Traeger-Binary; alle Folgestufen
  COMPILE-TIME-Einbau entlang Planer->CEB->Tier.
- **HYBRID = Factory-Pattern-Facade-ADAPTER** (organ-frei): erbt als eingeschobene 4. Stufe ALLE
  Eigenschaften vorausgegangener Stufen, reicht Mess- UND System-Eigenschaften CT an seine
  anhaengigen Tiers weiter; traegt Mess+System-Stempel, KEINE Organ-Identitaet (binary_id bleibt
  Organ-only bei echten Tiers).

## Was hier WEITER GUELTIG ist

Die Ressourcen-/Zulaessigkeits-Ebene (§37/§37.b: Organ-Nutzung <= System-Freigabe an der
CEB-Bau-Delegations-Naht), die Cluster-/CI-Ebene (§35/§36 Pool/Locking/Tag-Routing), die
Batch-Ebene (§62-B Bestandslog) und die Takt-Hoheits-/Ruf-Ketten-Erhebung — all das ist Teil bzw.
Umfeld der jeweiligen Stufe-1-RT-Freigabe und bleibt Design-Input fuer W1/W5.

## Hinweis zum angekuendigten Ergaenzungs-Bericht

Der in der Ledger-mittag-8-LESART angekuendigte "Ergaenzungs-Bericht in
backups/20260805-ressourcen-freigabe-explore/" wurde NIE erstellt; die mittag-8-Lesart selbst ist
durch mittag-9/-10 SUPERSEDED (Vermerk direkt im Ledger). Dieses README nimmt den Platz des
Ergaenzungs-Berichts ein.
