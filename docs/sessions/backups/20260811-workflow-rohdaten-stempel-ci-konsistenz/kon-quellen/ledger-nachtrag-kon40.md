## NACHTRAG 12.08.2026 — KON40: ZWISCHENSTAND-KONSOLIDIERUNG — DER DURCHSTICH LÄUFT, DIE 17-vs-18 IST GEKLÄRT, UND F-D TRÄGT EINE SPANNUNG

**Owner-Auftrag:** *„lande alles … beginne die Strecke mit dem ##25 Durchstich … konsolidiere
alles vergessene ins ledger und eine Zwischenstand session … stelle mir aber zunächst alle
verbliebenen Fragen mit mehr Kontext."* Zwischenstand-Dokument:
`docs/sessions/20260812-ZWISCHENSTAND-strecke-beginnt-durchstich-laeuft.md`.

---

### KON40-01 — DIE STRECKE HAT BEGONNEN: WF9 = ##25-DURCHSTICH (Posten 1)

**WF9 `wf_1fb6bc6f` läuft** — der Besitzer für die F1-Lieferung ist gesetzt (V-1 geschlossen,
sobald gelandet). Vier Phasen: Kern-Explore (2× sonnet max) → Design (fable max) → Bau
(opus max, **eigener Worktree**, kein Push) → Verify (fable xhigh). Landung + CI-Beweis
danach seriell durch den Lead.

    KERN-EXPLORE-AUFLAGE (die F1-KERN-Lehre): NUR bauen was FEHLT — schon gelandet sind
    D3-1-Kern+D3-2 (7444d8c0) · D3-7 (028684ac) · D3-3 (4e0b7e0d) · ##23-NAHT · D3-6
    (6d2e3dce) · ##08 · D2-G1 (ca6d8af1). Kernfrage: braucht der Durchstich die zwei
    10.08.-Aenderungen (measurement_line len=0 / Reihenfolge) NOCH — KON5-01 sagt
    SOLLVERHALTEN, die Reihenfolge ist S-6-Gegenstand NACH F1. VERBOTE: nichts
    Preimage-Wirksames · keine Golden/TABU-Beruehrung · Ledger Lead-only.

**Hotspot-Serialisierung (Betriebsentscheidung, protokolliert):** ⭐S-1 und Strang D
(#83→#84→#80) starten erst nach Vorliegen des WF9-Bau-Fußabdrucks — ce-Submodul-Store und
`.gitlab-ci.yml` sind gemeinsame Hotspots (Ein-Schreiber-Regel; `.gitlab-ci.yml` = Lead-only).

---

### KON40-02 — 🟢 OF-1 AM OBJEKT GEKLÄRT: 17 CODE-DATEIEN + 1 README = 18

Eigene Zählung (ce am Gitlink `670483c0`, `/usr/bin/grep`):

    SYSTEM B, die Traeger-Menge:
      mess/                           6 Dateien  (genus_kaskade · konfiguration · mess_naht ·
                                                  pilot_achsen · pilot_suche_impl · steuer_dock)
      builder/measure_storage/        3 Dateien  (stapel_arena · checkpoint_speicher ·
                                                  checkpoint_measure)
      Code-Referenzierer ausserhalb   8 Dateien  (planner_mengen_types · ergebnis_mappe ·
                                                  test_ck1_messkette_koeder · tests/CMakeLists ·
                                                  ck1_naht_koerper · test_a9s3 · test_d55 ·
                                                  apps/experiment_planner/main.cpp)
      = 17 CODE-DATEIEN.  + hybrid/README.md (Doku-Erwaehnung) = 18.
    => BEIDE kursierenden Zahlen messen DIESELBE Menge; die Differenz ist genau die README.
    NEBENBEFUND: das AUSWAHL-Subsystem (measurement_tooling_registry) hat heute 17
    Referenz-Dateien (KON29-05 zaehlte 18 — eine Datei Drift, unkritisch, Menge gelistet).

⇒ **KON34-06(d) ist damit sachlich geschlossen** — OF-1 geht nur noch als Bestätigung an den
Owner. B4-Umfang: die 9 Kern-Dateien (mess/ + measure_storage/) sind der Umbau-Gegenstand,
die 8 Referenzierer die Ripple-Menge.

---

### KON40-03 — 🔴 DIE F-D-SPANNUNG (OF-5, neu): „3 TAGE VOR ABGABE" GEGEN „WIE EMPFOHLEN"

Die KON37-04-Antwort trägt einen inneren Widerspruch, der bei der Verbuchung zugunsten des
wörtlichen Owner-Datums aufgelöst wurde — **die Wahl gehört aber dem Owner:**

    OWNER-WORT:   "--debug wird 3 Tage vor Abgabe aufgehoben und echt gemessen.
                   Daher wie empfohlen."
    DIE EMPFEHLUNG WAR ABER: Umschaltpunkt VOR W3 (29.08.) — die Kampagne misst ECHT.
    T−3 (~12.09.) liegt NACH der W3-Kampagne. Beide Haelften des Satzes passen nicht
    zusammen — verbucht wurde (a), vorzulegen sind BEIDE Lesarten:
      (a) T−3 GILT: W3 = Debug-Generalprobe (ungenau, loeschpflichtig), die ECHTE Messung
          laeuft Sa 12.–Mo 14.09. — verlangt XML→PDF-VOLLAUTOMATIK + Lager-Skip bis W3.
      (b) "WIE EMPFOHLEN" GILT: Umschaltpunkt VOR W3, die Kampagne liefert die echten
          Zahlen; "3 Tage vor Abgabe" bezog sich auf das endgueltige Abschalten von
          --debug in der CI-KETTE (nicht auf die Messung).
    => GROESSTE Plan-Weiche der Strecke (Posten 45/46). OF-5 mit Kontext vorgelegt.

---

### KON40-04 — DAS ÜBRIGE VERGESSENE, VERBUCHT

* **Marker-Verifikation:** alle 21 A.5-Marker am Objekt bestätigt (8 GOAL · 7 Wellenplan
  inkl. FORTSCHREIBUNG · 6 Designplan inkl. STAND-HINWEIS); Diff rein additiv — die eine
  „−"-Zeile ist die beauftragte In-Zeile-Anfügung an der Designplan-Meta-Zeile.
* **Fünf Fragen + v3.5 liegen beim Owner** (OF-1…OF-5 mit Kontext; v3.5 = 15 Kandidaten,
  Teil A.4). **Kein OF blockiert den Durchstich** — OF-1/OF-2 blockieren B4/#7-Nenner (ab
  Mi 19. bzw. Fr 21.), OF-5 die W3/W5-Gestalt.
* **Blanko-GO für die Strecke** (Owner 12.08.: *„Fahre dann alle Wellen nach Plan ab"*) —
  Standardzustand ist Weiterarbeiten, Rückfrage nur bei nicht billig rücknehmbarem Schaden.
* **Task-Stand:** #9 ✅ (KON39) · #26 ✅ · #11 in_progress (WF9) · #25 ✅ (KON36) · neu
  #27 E-WARMUP-Explore · #28 TEST-KONSOLIDIERUNG. MEMORY-Index auf KON36+ gezogen
  (Stempel-Fable-max-Zeile ergänzt).
* **KON39-Nummern-Hinweis:** der WF8-interne „kon37_entwurf" wurde als KON39 gelandet
  (KON37/38 waren vergeben — Gegenstand vor Nummer, L-8).
