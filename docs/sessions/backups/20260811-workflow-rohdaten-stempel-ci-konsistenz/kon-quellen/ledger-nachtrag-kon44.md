## NACHTRAG 12.08.2026 — KON44: WF9 IST ZURÜCK — DER DURCHSTICH FÄHRT HEUTE NICHT: EMITTER UND PRÜFGATE WIDERSPRECHEN SICH, UND EINE STILLE n/a-FALLE IST GEFUNDEN

**WF9 (`wf_1fb6bc6f`, 5/5 Agenten, 0 Tode): Kern-Explores STIMMT_TEILWEISE · Bau komplett
(4 Posten, alle Abnahmen literal) · Verify **LANDEFAEHIG_MIT_FIXES**. Der Bau-Schnitt war
klein (die Kette ist fast vollständig gelandet: measure:smoke-Job, f1_durchstich-Profil,
Marker/Gates/Frische, persist, anhang:forward, PDF-Gate) — aber der GEFAHRENE lokale
Beweis-Lauf hat den Kern-Befund gedreht.** Rohdaten + Messbelege im Backup.

---

### KON44-01 — 🔴 DER BLOCKER: KON5-01 GILT FÜR DEN EMITTER, DAS PRÜFGATE VERLANGT DIE VOLLMENGE

    GEMESSEN (lokaler Lauf, ce 670483c0 = exakt der CI-Stand):
      fehlerklasse=mess_konsistenz  status=deklaration_leer
      haupt_ist=0  haupt_soll=3  measured=0  exit=1
    MECHANISMUS: das f1_durchstich-Profil faehrt label=basis-320 -> der KATALOG bedient
      die id -> die emittierte perm.cpp traegt die 2-ARG-Form von
      COMDARE_ANATOMY_VERSION_STAMP (KEINE Mess-Zeile; der lazy Gen, der die Mess-Zeile
      traegt, wird per INC-G6 NIE konsultiert, weil er HINTER base_union steht).
      Die PRUEFSEITE (mess_konsistenz_gate, faehrt VOR JEDER MESSUNG, fail-closed)
      verlangt die VOLLMENGEN-Zeile (haupt_soll=3, UNGESETZT loest zu "[all]" auf).
    => KON5-01 ("leerer Mess-Stempel = Soll, kein Riss") gilt fuer den EMITTER --
       aber Emitter und Pruefgate WIDERSPRECHEN SICH auf dem Katalog-Pfad.
       Die CI trifft es identisch (measure:smoke setzt exakt diese Env) -> der Job
       ginge ROT, VOR dem Marker. DER DURCHSTICH FAEHRT HEUTE NICHT.

**Die drei Wege zum F1-Schnitt (Owner-Entscheid, kommt in die Fragen-Runde nach WF10):**
(a) den Stempel-Anteil **vorziehen** (S-6-nah, preimage-wirksam — „heute kostenlos", bricht
aber die S-6-Fenster-Planung Mo–Mi) · (b) **F1 neu schneiden** (Lieferung ohne echten
End-zu-End-Messwert) · (c) **der lazy Pfad**: das f1-Profil auf eine Zelle AUSSERHALB der
Basis-320 stellen — der lazy Gen emittiert die **3-arg-Form MIT Mess-Zeile** (WF2-Karte:
`lazy_adhoc_source_gen.hpp:357-376` emittiert O,S,M) → Gate grün, Kette fährt **ohne**
preimage-wirksamen Umbau. *(c) ist am Objekt noch kurz zu verifizieren (non-320-Zelle im
Profil wählbar?) — läuft als Lead-Check vor der Vorlage.*

---

### KON44-02 — 🔴 DIE STILLE FALLE: EINE ZEILE VOLLER n/a GILT ZWEI WACHEN ALS GRÜN

    Die eine "Datenzeile" des roten Laufs ist KEIN Messwert:
      n_ops=n/a  total_ns=n/a  ns_per_op=n/a  workload=n/a  quality_flag=n/a  (provisioned=1)
    mess_ausbeute_wache: OK.  frische_wache: OK.  NUR durchstich_wache frische faengt es.
    => OHNE dieses EINE Gate liefe eine n/a-Zeile bis in die Thesis-PDF.
    NEUER BAU-POSTEN (unabhaengig vom F1-Schnitt): das Inhalts-Gate prueft kuenftig
    NICHT nur Zeilen-Existenz, sondern ECHTE Werte (n/a-/provisioned-Zaehler mit Nenner
    in der Ausgabe) -- die D4d-Klasse ("Null wird als Divisions-Gefahr gerettet, nie als
    Daten-Aussage behandelt") auf der Wachen-Ebene.

---

### KON44-03 — 🔴 BETRIEBSBEFUND: DIE THESIS-WRITEBACK-VARIABLEN FEHLEN IN 289

    API-Existenz-Check (PAT, nur key+Attribute, NIE Werte):
      Projekt 288:  COMDARE_WRITEBACK_USER        EXISTIERT (protected)
                    COMDARE_WRITEBACK_TOKEN       EXISTIERT (protected+masked)
      Projekt 289:  COMDARE_THESIS_WRITEBACK_USER  FEHLT
                    COMDARE_THESIS_WRITEBACK_TOKEN FEHLT   (1 Variable gesamt in 289)
    => anhang:forward braeche am 289-Push HART, unabhaengig vom Architektur-Blocker.
    Dieselbe Scrub-Klasse wie die MinIO-Keys (KON22-01/5); das Rotations-GO (KON22-01/6)
    nannte COMDARE_THESIS_WRITEBACK_TOKEN -- rotiert wurde Gruppe 3 + Projekt 288, die
    289-SEITE wurde offenbar nie neu gesetzt. FIX: blind aus dem Cred-Vault neu einsetzen
    (stehendes GO-Muster, Wert fliesst Vault->API, nie in Ausgabe) -- zusammen mit
    Task #10 im Betriebs-Fix-Schritt.

---

### KON44-04 — WAS LANDEFÄHIG IST UND WAS DIE LANDUNG VORAUSSETZT (Verify-Auflagen)

    LANDEFAEHIG (Doku/Kommentare, kein Code-Verhalten):
      super ac2afddd  MANUAL_RUN.md §8b "F1-Durchstich" (75 Z.; Startzeile, 5 Variablen,
                      Warnung KEIN COMDARE_RUN_MEASURE) -- Abnahme 0->3 literal
      ce    516c05a0  P2+P3: stale '[all] => LEER/""'-Kommentare korrigiert + F1-Blocker
                      im Code festgehalten (52+/5- Zeilen, ALLE // -- Verify hat den
                      Diff selbst geprueft)
    VERIFY-AUFLAGEN vor der Landung (7 Punkte, die tragenden):
      · Kompilier-Beweis fuer 516c05a0 nachholen (oder den CI-Bau als Nenner deklarieren,
        BEIDE Mengen nennen)
      · 🔴 ce SEQUENTIELL: 670483c0 ist NICHT auf ce origin/development (346b6da9) --
        nur auf origin/landung/r5-ce-r7! ERST die r5-ce-r7-Landung nach development,
        DANN 516c05a0 mergen (nie rebase). Der super-Gitlink pinnt seit Tagen einen
        Stand, der in ce development nie ankam -- das erklaert Teil der ce-Rot-Lage.
      · super: Worktree-Branch per MERGE (origin ist 3 Ledger-Commits voraus, disjunkt);
        Gitlink NICHT bumpen (F1 faehrt den gepruefteten Stand)
      · Diff-Hygiene push-lokal · Pipeline via Monitor · Worktree erst nach gruen+gemergt
        loeschen (Belege sind additiv gesichert)
    Verbots-Checks ALLE gruen: Preimage-Diff leer · Golden/TABU unberuehrt · Ledger
    nicht angefasst · kein Push · Gitlink unveraendert · keine Messdaten geloescht.
    Nebenbefund (lokal, unschaedlich): Tier-Treiber g++-16/16.0.1 gegen CEB gcc 15.3.0 (T2-C).

**Vollzug:** Landung + F1-Schnitt-Entscheid gehen in die Fragen-Runde NACH WF10 (Owner-
Fahrplan). Belege: `wf9-durchstich-belege-messlauf.tar.gz` + Voll-Ergebnis im Backup.
