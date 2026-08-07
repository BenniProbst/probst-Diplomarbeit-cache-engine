# PAUSE (abbruchsicher) 2026-08-07 frueh -- numa-Verify GRUEN, Fable-5 wieder frei

> ERST-ANKER fuer den Wiedereinstieg. Owner-Auftrag verbatim: "Bitte lege eine
> Abbruchsichere Pause ein". Davor: "Bitte weiter" + Freigabe Fable 5 wieder nach
> der Claude-Code-Arbeitsweise ("Das Kontingent ist zurueck").
> Vor jeder Handlung neu messen -- das Repo ist live. ASCII (Paragraph erlaubt).

## 0. STAND IN FUENF SAETZEN
1. HAUPTSTRANG WIEDER FREIGEGEBEN (Owner 07.08.): der pausierte Hauptstrang
   (Messkette/Bau) laeuft wieder; die Konsolidierung (Gesamt-Dossier a6f8b8d8) +
   Selbst-Audit sind abgeschlossen und gelandet.
2. FABLE-5 ZURUECK: die 06.08.-Opus-5-Umstellung ist per Owner-Wort AUFGEHOBEN --
   es gilt wieder Matrix A1/v2.1 (Lead/Planung/Design/Review/Synthese=Fable-5-xhigh,
   Bau=Opus-5, Explore=Sonnet-5-max UNVERAENDERT, Codex=Regressions-Lens). Im
   Memory verankert (feedback_claude_code_arbeitsweise_v2_konsolidiert, WIDERRUF 07.08.).
3. NUMA-PAKET auf aktueller dev-Basis gebaut+gruen: ce-Branch
   b-numa-luecken-schliessen HEAD=f138ec41 (= dev 54106bc9 + numa-core_class +
   Umbenennung + Gap-Fixes L-1/L-2/L-3 in a73fecbe). Bau GRUEN (gcc 15.3, 25/25
   Tests), Fable-Adversarial-Review LANDEBEREIT (0 Regressionen, L-3-Bissbeweis
   durch Ausfuehrung gegen b1753926 bewiesen).
4. VOLL ABBRUCHSICHER: f138ec41 als rescue-Ref auf BEIDEN Remotes
   (refs/rescue/20260807-numa-luecken-f138ec41, gitlab + github, gitleaks sauber);
   die uncommittete super-Arbeit als Patch-Buendel unter
   ~/backups-workflow/20260807-PAUSE-abbruchsicher/.
5. OFFEN bei Wiederaufnahme: EINE Owner-Entscheidung (Codex-Lens noch fahren ODER
   mit Bau+Fable landen), dann die numa-Landung BEIDER Repo-Haelften zusammen.

## 1. REFS (Objekt-Ist 07.08. frueh)
- ce: development==main-origin==54106bc9 (main lokal im Hauptklon veraltet auf
  b241a272 -- N-4-Falle, gegen origin/main messen). numa-Arbeit NICHT auf dev.
- super: development=f86a90c3 (wt-super-landung), main=2871fabf (FF bewusst
  zurueckgestellt: nur Doku-Commits offen, main-FF nach gruener Pipeline).
  Hauptklon steht auf b-ci-rueckschrieb-beide-zeiger @ 18a0bdf3 mit uncommitteter
  Arbeit (V-10-Falle -- Sicherung s. Abschnitt 3).
- thesis: 19e1592 (dev==main). cluster: d7eab98.

## 2. NUMA-PAKET -- Zustand + was noch fehlt
Das Paket gibt der Ausfuehrungs-Lokalitaets-Unterachse numa_cpu_pin_process_probe
(Owner-KERN 8, Pendant zu numa_page_probe) ihre drei Review-Luecken zu:
- L-1 Provenienz luegt plattformfremd: CoreTopologySource fuehrte Windows/macOS
  faelschlich als HybridPmu (Linux cpu_core/cpu_atom sysfs). FIX: additiv
  WindowsEfficiencyClass=3 + DarwinPerflevel=4 (Bestands-Nummern 0/1/2 per
  static_assert festgenagelt, K5/FK-8), Disjunktheits-Asserts, Plattform-Blaetter
  konsistent.
- L-2 Kopfkommentar vs macOS-Blatt: Widerspruch aufgeloest (Groessen prozessfrei
  via hw.nperflevels+hw.perflevel<N>.logicalcpu da; nur Kern-Id->Ebene-Zuordnung
  fehlt; Pinning ehrlich KeineSchnittstelle).
- L-3 Kreuzpruefung fehlte: Stufe 2 (L3-Domaene) prueft jetzt ZWISCHEN den Listen
  (ein Kern in grosser UND kleiner L3-Domaene = QuelleKorrupt). Bissbeweis
  EinKernInBeidenL3DomaenenIstEinBefundUndKeineDoppelteKarte (ROT->GRUEN, durch
  Ausfuehrung gegen b1753926 bewiesen) + Gegenprobe disjunkter Mengen.

VERIFIKATION (Workflow wf_3097900d-0de, 07.08. frueh):
- Bau (Opus-5, frisches Build-Dir, gcc 15.3.0): kompiliert, ctest
  test_od11_numa_cpu_pin_process_probe 100% (25/25 Faelle, 0 Skipped). Literal.
- Fable-Adversarial-Review: landebereit=true, l1/l2/l3 geschlossen,
  l3_bissbeweis_echt=true, regressionen=[]. Kein Blatt deklariert die alte
  Vokabel; kein Stempel-/Serialisierungs-Pfad beruehrt (binary_id-neutral, A-15).

NOCH FEHLT VOR LANDUNG:
(a) Codex-Regressions-Lens (2. Dual-Review-Haelfte) -- war beim Model-Switch mit
    abgebrochen, NICHT verbatim neu starten. Owner-Entscheidung offen:
    (a) Codex noch fahren (read-only, ~3 min) ODER (b) mit Bau+Fable landen (Fall
    ist klein: 7 Header, additive Enum-Erweiterung, echter Bissbeweis, 0 Regr.).
(b) LANDUNG beider Haelften ZUSAMMEN: ce b-numa-luecken-schliessen -> dev-Merge
    -> Pipeline gruen -> ce-main-FF; super-Haelfte experiment_schema.xsd core_class
    (+24 Z., uncommittet) auf eigenen super-Branch -> Gitlink-Bump auf neuen
    ce-dev -> super-Pipeline gruen -> super-main-FF (Kette T-1, fuenf Schritte).
    Kein Klasse-ALPHA-Posten (kein Neubau der Flotte); binary_id="never".

## 3. SICHERUNGEN AUSSERHALB GIT (abbruchsicher)
~/backups-workflow/20260807-PAUSE-abbruchsicher/
- super-hauptklon-tracked.patch (163 KB) -- der gesamte tracked-Diff des
  super-Hauptklons gegen 18a0bdf3 (enthaelt ce-Gitlink + xsd + Ledger + Checkheft;
  das meiste ist bereits auf development, Hauptklon nur veraltet -- V-10).
- super-numa-core_class-experiment_schema.xsd.patch (2,2 KB) -- die EINZIGE echt
  ungelandete super-Kern-Arbeit, die zum numa-Paket gehoert.
- super-untracked-liste.txt (55 Eintraege) -- Klassifikation offen; measure_out_d03
  ist gitignored (Messdaten, byte-identisch getrackt vorhanden), die docs/plaene/*
  + docs/sessions/* sind ganz ueberwiegend schon auf development.
Frueheres Backup der ungesicherten Arbeit: ~/backups-workflow/20260807-numa-luecken-WIP/
(436-Z.-Patch, jetzt als a73fecbe committet + rescue-gepusht -> obsolet, aber steht).

## 4. WIEDERAUFNAHME (Reihenfolge)
1. Erden: dieses Doc, dann Objekt-Ist (beide Remotes fetchen, dev/main-SHAs, alle
   Worktree-HEADs + porcelain), Lebend-Check (pgrep cmake/ctest/ninja ohne
   Selbstmatch; codex mcp-server laeuft dauerhaft, kein aktiver Job).
2. numa: Owner-Entscheidung (a)/(b) einholen bzw. umsetzen -> Codex-Lens optional
   -> Landung beider Haelften (Kette T-1). rescue-Ref f138ec41 ist der Startpunkt
   (rescue ALTERT nicht, solange der Branch nicht weiterwandert -- hier stabil).
3. Danach weitere Hauptstrang-Posten nach Verfallsfenster (Gesamt-Dossier §17.9):
   R-3 (Mess-Defines nicht im Fingerprint-Preimage, kostenlos solange 0
   .fingerprint-Sidecars) + SW-5/E-14 (active_telemetry_is_silent konstant false,
   golden-beruehrend) sind die zwei offenen Mess-Sperrposten (Ledger morgen-1 Ende).
4. Offene Owner-Entscheide unveraendert: F-01 Talos (.tex-GO offen, Rollentrennung),
   F-02 flat_hash_map, B-2..B-5 (§17.9 des Gesamt-Dossiers).
5. Gesamt-Dossier = super docs/sessions/20260807-GESAMTDOSSIER-aktuell-jetzt-
   konsolidiert.md (3704 Z.) ist die fuehrende Wissensbasis.

## 5. PROZESS-NOTIZEN
- Fable-5 wieder als Agent zulaessig (Lead/Design/Review/Synthese); Explore BLEIBT
  Sonnet-5-max (nie Fable als Explore, Owner-Dauer-Regel).
- Ein Model-Switch-Abbruch ist KEINE inhaltliche Ablehnung des Vorhabens, sondern
  ein Modell-Wechsel; abgebrochene Tool-Calls (hier Codex-Lens) NICHT verbatim
  wiederholen, sondern als Entscheidung neu vorlegen.
- PAT/github-Token blind rueckwaerts aus dem Vault (Positionen rotieren: PAT
  Position 7 v. hinten, github Position 4 v. hinten -- NIE hartcodieren), Wert nie
  ausgeben, via askpass aus 0600-Datei (nie in der Prozessliste), Token-Dateien
  geschreddert.
