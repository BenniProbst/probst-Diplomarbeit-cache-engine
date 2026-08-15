# SESSION 15.08.2026 — „Wo stehen wir?" Layer-Übersicht der gesamten offenen Arbeit

> **Anlass:** Owner-Auftrag per /btw-Fork („wo stehen wir mit offener Arbeit, allen
> Wellen/Phasen/Aufgaben bitte eine Elaborate Layer Übersicht") + „Bitte dokumentiere
> die wo stehen wir fork als Session, sobald sie fertig ist." Erstellt 16:11 Uhr vom
> Fork mit vollem Sitzungs-Kontext; hier unverändert als Session-Dokument gelandet.
> **Lebende Quellen (nicht duplizieren):** Ledger-Kopf = KON74 (+ KORREKTUR 15.08.
> in KON74-02), Owner-Vorlagen = `20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md`,
> Wellenplan §18, Karte `staffelungs_karte_49.json` (via Folge-BU).

**Fixpunkte:** F1 ✅ GELIEFERT (14.08.) · **F2-Identitäts-Freeze Fr 21.08.** · Bau-Trigger
**Mi 26.08. 06:00** · W3-Kampagne ab Sa 29.08. · W4-Auswertung 07.–11.09. · T−3-Reset ≈ 12.09. ·
**Abgabe Di 15.09.** — super development @ 1bcd1469 (4 grüne CIs heute: 15863/15868/15869/15872),
ce dev @ 0817c7bf, GitLab v19.1.4 (Rev. 24, Valkey).

---

## Layer 0 — LIVE in diesem Moment

**#75 Nachstufe W-A/W-B** (wf_bb387379; verbindlich VOR jeder Landung): Verifies beider
Stränge ✅ TRAEGT_MIT_FUNDEN · beide A2.5-Fix-Runden ✅ **offene=0** (W-A: T17-stat_*-MUSS
behoben; W-B: Waisen-Zählung 4-statt-7, Ledger bereits korrigiert 57280246) · Dual-Review
**3/4 zurück** (1× TRAEGT, 2× TRAEGT_MIT_FIXES → Abschluss-Fix-Stufe verifiziert deren
MUSS-Funde am Objekt), 1 Lens läuft. **Ausgang = landereif-Urteil je Branch-Familie;
blockiert ganz Layer 1.**

Bau-Stände, die auf dieses Urteil warten: `bau/b2-gate-trennung` @ 11972b3d+Fixes (CI 15862
grün) · `bau/prtart-waisen-archiv` @ 7e1bf6a9 (CI 15861/15864) · prt-art
`bau/prtart-ladeweg-w0a` @ a782c56 (CI 15858) · dazu landereif wartend: `bau/golden-homes`
@ 0eea2a0a (#16-Vorbau, CI 15844) und S-14a-Riegel @ 8cc564d5 (P11, längst LANDEREIF).

## Layer 1 — Serielle Schluss-Strecke (deklarierte Ordnung KON73-05/KON74-06; startet mit #75-Terminal)

1. **#61 Thesis-Trailer-Rewrite** — exklusiver Slot (kein Parallel-Workflow):
   Bundle-Sicherung → filter-repo entfernt Co-Authored-By-Trailer → Force-Push 3 Remotes →
   **beide** super-Gitlinks nachziehen.
2. **#67 Thesis-Sync** — Owner-Änderungen der letzten 2 Wochen gegenlesen; Code→Thesis
   vorrangig, Owner-Ergänzungen→Code-Teil; neue Commits ohne KI-Trailer. Cave aus #49:
   `06_evaluation_methodology.tex` seit 02.08. **nicht eingebunden** (nur Teil-Übernahme
   in Kap. 5) — hier heilen oder deklarieren.
3. **#62 Branch-Löschung** — 14 ce-origin-Branches: Re-Prüfung → Archiv-Bundle → Löschung +
   Gegenprobe; die lebenden Bau-Branches (B2, Waisen, golden-homes, ci-dual-emission
   731b5655, #16-Fessel-Reste) sind ausgenommen.
4. **golden-Fenster = EIN Bruch** (KON70-01): **B2-Landung** (#24; Preimage-Glied bewegt
   sich = bestellte Wirkung) + **#16** golden festschreiben → Homes MESS/SYSTEM +
   S-18-Wächter (Design #96) + **organ_axes-Rename** (F5: drei Homes
   mess/system/organ_axes) + **#72 queuing-Umzug** (42 Lock-Records ins Organ-Home).
   Form: Harmonisierung an Vertragsflächen (nicht nur Merge) → Lock-Regen → Komplex-Fix →
   EIN Push → CI terminal. S-14a-Riegel (P11) landet in dieser Ordnung davor/mit.

## Layer 2 — W1-Rest bis F2 (Fr 21.08.) — identitäts-/preimage-wirksam

- **#15 S-6-Fenster** (letzter Preimage-Schritt vor F2): S-6b sofort baubar (W-E1:
  entsperrt seit KON21-03; KON60-04 unbequellt/stale). Bump-Bündel = ABI-Layout 6→7
  (S-6a-POD + Hybrid-Komposit-Zeile KON45-01) + Format 4→5 als **ein** Bruch, gebündelt
  mit **#38a2** (Comp-Gate-Stempel) + **#38d** (Budget). ⟵ **Owner-V2**.
- **#17 G-2-Semantik** (nach den Homes, in Achsen-Nummerierungs-Reihenfolge) — schließt
  die Stempel-Strecke, **gibt #7/S-19 frei**. ⟵ golden-Fenster.
- **#20 Fläche-3-Vereinigung** IMessVisitor ≡ measurement-Durchstich + Deckungs-Test
  CEB=AUS/Tier=AN (Test-Teil nutzt die B2-Gates).
- **#24-Rest Mess-Schalter:** B3 hat **Owner-Datum vor F2** (KON34-04) · B1 W1-Ende ·
  B5 nach S-5 · B4 = W2.
- **#70 XorFilter** vor der nächsten Messreihe (Defekt reproduziert 30/256,
  owner-geregelt P78) ⟵ **Owner-V1**.
- **#40 Ultracode-Nachimplementierung** — 38 NE-Posten/20 Aufträge, W0b–W1;
  Flächen-Koordination mit golden-Fenster nötig; NE-01-Zahlenkorrektur gilt (644.020 nie
  mehr zitieren).
- **#53-Rest PMC:** Owner-Vorlage je Achse vor Bau (design_pmc_schwester_v2.md, 576 Z.,
  OP-1–OP-5) — Vorlage fertig, wartet aufs Owner-Fenster; danach Lastsequenz-Achse
  (10W-Explore-Pflicht) + Planer-Vertrags-Slot.
- **#65-Rest PRT-ART:** 10-Wochen-Planungs-Explore + Aufräumen (a) + die V1-Diskrepanz
  (Prüfling-Exklusivität lokal-vs-CI; Mechanismus belegt: Cache-Persistenz +
  Ein-Prüfling-CI) an der #65/#29-Fläche.
- **#38a1:** C-3a-Owner-Vorlage gelandet — **Frist Mi 19.08.**

## Layer 3 — W2 (Mo 24.–Fr 28.08.) — mengen-wirksam vor dem Trigger

- **#7 S-19 Planungs-Simulation** (Sa 22.–Mo 24.) — **MEILENSTEIN** („Hauptziel der
  nächsten Wellen"): rechnet die dynamische Mess-Permutation >32 am Experiment-B+-Baum,
  **produziert die B-4-Zahl**; Bau-Zahlen Di 25.; OV-4-Vorlage mit Zahlen Fr 21.08. Sechs
  Design-Festlegungen liegen (check-size-CEB-Hälfte, Geschwister-Familien-View,
  Range-Aggregat, OS-Realm-Nenner, Dynamik-Quellen, Arena-2-vs-18). ⟵ #17.
- **#3 S-12 CI-Gerüst** — vier Trägerstufen-Mini-Pipelines gcc+clang × Release+Debug,
  kein changes:-Skip; Vorbau 731b5655 (E1–E5); Landung Di 25.
- **Design-Bündel Di 25.08. (engster Slot):** **#18 S-13** Export-Element + Ziel-Filter +
  per-Binary-XLSX (heilt measurement_sink) + **#48** XML-publish-Sektion
  (Direkt-Ziele-Karte komplett; Kern-Hebel: AF_BRANCH hart in YAML:2550 → XML-erreichbar
  machen; PDF-Dualität existiert schon) + **#57** Lager-Vollausbau (6 Lücken:
  Planer-Blattfunktion, CEB-Vollplatzierung, Hybrid-Push, Commit-Skip, rebuild-Flag,
  publish-Topologie) + xlsx-SOLL aus #55 (Sheets S001..Snnn ⟵ **V3**).
- **#13 T-15b-Umzug** Sa/So 22./23. (Mess-Fenster; binary-berührend ⇒ vor dem Trigger;
  je 5 Build+Messung, 3 Werte einzeln, Arena ×5).
- **#19 main-FF beider Repos** — #31 ✅ ⇒ praktisch frei; davor kumulative Hygiene-Wache
  lokal über den FF-Bereich (push-lokal-Falle).
- **W2/W-Slots:** #22-Rest (--debug-CLI mit S-8, vor W3-Generalprobe) · #28
  Test-Konsolidierung (Eigentümer + Inventur-Beginn) · #71 Leser-Hebungen
  (KON-43/KON-44/machines; KON-15 + Posten 74 per KON74-05 bereits nachgeführt;
  concurrency-Vorlage gegen F7/R-F7 prüfen — evtl. gegenstandslos) · **#74 Repo-Rollen**
  (W-G-Karte liegt: 15 CE-Kandidaten) · #69 Messwert-Rohbefund 750-vs-1310 + prod2-TeX ·
  #38b Warmup-Paar Sa/So.

## Layer 4 — W3→W5 (Anker, noch nicht schneidbar)

**Trigger Mi 26.08. 06:00** (braucht: golden-Fenster zu, S-19-Zahlen, S-12, S-13, T-15b)
→ **W3** Debug-Generalprobe + HY-B-Kurven + gedeckelte Kampagne (`<measure_selection>`,
≤4,5 Maschinentage; W3-Abbruch-Gate: nicht_gebaut>0 = Abbruch; nur beide
Ubuntu-bare-metal = Komplett-Pflicht, nie allow_failure) → **W4** Auswertung 07.–11.09.
(E0–E5-Skelett aus #49 liegt: Break-Even 3× querschneidend, hybrid_router-CoR,
Anhang-Wache mit Laufzeit-Soll, FF0–FF4 5/5, C5-Kapitel) ⟵ **V7 + #49-Rest
Staffelungs-Design** · Messreihen-Ordnung A→B→C je Micro→Makro→Gesamt · P/E-Core
getrennt · Perzentile nur aus HDR → **T−3/W5** Reset + echte Messung + PDF-Schluss
(Owner-Anker: Binaries+Lager VOR Darstellung, PDF = SCHLUSS) → Abgabe. Dahinter
W7-Parkplatz: #38a3 IO-Vollausbau, Monolith-Split #88, P/E-Core-Feinformen.

## Layer 5 — Offene Owner-Entscheide (Dokument `20260815-OWNER-VORLAGEN-V1-V7-nachstufen-tag.md`, 1bcd1469)

| V | Gegenstand | blockiert |
|---|---|---|
| V1 | XorFilter: P78 re-bestätigen + FN-Ausweisung ODER Offline-Peeling-Umbau | #70, nächste Messreihe |
| V2 | S-6 baubar (KON60-04 stale) | #15/S-6b |
| V3 | xlsx-Sheet-Namen (A: S001..Snnn+Legende / B: sprechend) | #18-Bündel-Detail |
| V4 | OF-4: id=54-Ablösung (api-Scope) + ROTATE_TOKEN + Schedule aktiv | #54-Aktivierung (Turnus dormant) |
| V5 | Sidekiq-HPA behalten oder Replicas pinnen | Values-Hygiene |
| V6 | node6 Remote-Login · node5 physisch · id56 · id18 | Flotten-Vervollständigung |
| V7 | Mess/System = Schnitt-Parameter, Diagramm-Form nur an Organ? | W4-Formen, #49-Rest |

Dazu terminiert: **C-3a-Antwort bis Mi 19.08.** (#38a1) und B3-Owner-Datum vor F2.

## Layer 6 — Betrieb/Sicherung (kein Pfad-Blocker, aber Pflicht)

Folge-BU der neuen Journale (wf_a2f3387c, wf_bb387379, wf_ec5b9516) + Sammlung Teile
26–30 + staffelungs_karte_49.json bei nächster Arbeits-Pause · Talos-CA-Trust x509 als
eigener Infra-Posten · A4-Rotationen (06.08.-Ära + MinIO-Altkeys + id=98-Vormerkung)
erst bei Pause · Worktree-Räumung (wt-ce-b2, wt-ce-prtart-waisen, wt-ce-golden-homes,
wt-prtart-lizenz, wt-super-landung) erst nach grün+gemergt+Submodul-Branch-Prüfung ·
Platte 17G frei (Peaks beim Kombibau beobachten).

---

**Kritischer Pfad in einem Satz:** #75-Abschluss (läuft, 3/4 Reviews da) → #61→#67→#62 →
golden-Fenster (B2+#16+organ_axes+#72) → #17 → S-19 (Sa–Mo) → S-12/S-13/T-15b (Di 25.) →
**Trigger 26.08.** — die drei Owner-Sätze mit unmittelbarer Pfad-Wirkung sind **V2**
(S-6), **V1** (XorFilter) und **V7** (W4-Formen); alles andere ist eingeplant und hat
einen Slot.
