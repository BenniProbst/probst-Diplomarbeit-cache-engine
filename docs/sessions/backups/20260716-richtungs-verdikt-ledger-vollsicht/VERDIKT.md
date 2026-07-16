# VERDIKT: Richtungs-Validierung §15.9(d) gegen Ledger-Voll-Lesen (7 Sektionen, konsolidiert + gegen Ledger-Ist spot-verifiziert)

Spot-Verifikation gegen `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (1268 Z.): §0-V5 (Z.75–118), §12-E-Runde/Audit (Z.368–393), §14.1-Gates-Tabelle (Z.1112–1124), §14.2 (Z.1126–1131), §15.5–15.9 (Z.1200–1268). Mehrere gemeldete Konflikte/Lücken erwiesen sich dabei als bereits NACHZIEH-aufgelöst — aussortiert (s. u.).

---

## (1) IST DIE RICHTUNG KORREKT?

**JA — MIT ANPASSUNGEN.** Die Grundrichtung ist belastbar: §15.9(c)/(d) ist die autoritative Quelle des Plans und deckt ihn wörtlich; die E1–E16-Runde (Z.368), Fork-A/Option-A (Z.369) und alle 7 Sektions-Bestätigungen stützen Reihenfolge, Gates und Kadenz. **Kein Befund kippt die Richtung.** Nötig sind: ein Schnitt-Fix an WP-3 (E11-Kollision), eine Re-Klassifikation von E16 (Code statt Doku), drei Ergänzungen der offenen-Entscheidungen-Liste (Fork B, G5-Vorlage, 48er-Rest u. a.) und eine End-Phasen-Bindung (#276). Die Abarbeitung darf sofort mit dem autonomen Teil (5) beginnen.

---

## (2) KONSOLIDIERTE KONFLIKT-LISTE (dedupliziert, nach Schwere)

**K1 — HOCH: WP-3-Schema-Anteil kollidiert mit E11.** Der Validator kodiert heute „genau 2 engines / phase.merge ∈ 3-Stufen-Enum"; E11 (User, neueste Runde): Kardinalität ==3 ist „KOMPLETT FALSCH — es gibt mehr als 3 Phasen"; Z.368 wörtlich: „Schema-/Validator-Increments warten auf das E11-Ergebnis". → **WP-3 splitten:** nur der phasen-orthogonale Härtungs-Anteil ist parallel-autonom; alles Kardinalitäts-/Engine-Zahl-/merge-Enum-berührende wartet auf E11-A/B. WP-4 bleibt phasen-orthogonal parallel-fähig.

**K2 — MITTEL: E16 falsch als „Doku-Increment" klassifiziert.** User wörtlich: echte Tilgung „als Arbeits-Tasks aufnehmen" — E9-raw-string-Ablösung + Naming-Reste sind **Code-Arbeit**. Plan-Einordnung riskiert Doku-statt-Tilgung (verstößt gegen „keine Erfolgsmarke ohne echte Tilgung").

**K3 — MITTEL (bindende Sequenz-Auflage, kein Widerspruch): #37-Bau.** Z.102/Z.202: TABU-GO + **Design-Vorlage VOR jeder golden/ABI-Änderung**, GENAU EIN 4→5. „Gates je Signal" darf beim #37 nicht nachgelagert gelesen werden — Design-Phase kommt VOR Baubeginn.

**K4 — MITTEL: Behelfsweg-Löschungen (Z.252/258, V5.4(g)) vs. E19.** V5.4(g) fordert Code-Behelfe-Löschung ohne NACHZIEH-Vermerk; E19 (07-16, neueste Aussage): **KEIN Lösch-GO — nichts löschen.** Vorrang-Regel: Löschanteil geparkt bis je-Repo-GO; autonom erlaubt nur Deprecation + Abhängigkeiten-Umhängen + Paritäts-Vorarbeit (P5).

**K5 — KLEIN: #276-Endbindung + V3-Label.** User-Anordnung (Z.1068, nie supersediert; §14.2 Z.1131 führt #276 als „ALLERLETZTE"): 3-ISA-Teilmatrix als harte CI-Pflicht = **ausdrücklich letzte Aufgabe vor der STOP-Prüfung** — fehlt in der (d)5-Gate-Liste. Zusätzlich Hygiene: §13.12/V3 trägt „AKTIV" ohne Supersede-Vermerk zugunsten V4/V5 (V4-Kopf löst V3 real ab).

**K6 — AUFLAGE an WP-4:** Die 2026-07-09 verworfene `axis_binding_registry` (Z.665: 14/5-Klassifikation ist Single-Source in `profile_to_tree.hpp:68-87`) darf durch die Round-Trip-Gates NICHT als Doppelquelle wieder einwandern — WP-4-Schnitt = XML-Baustein-Registries (F29/F33/F64/F66), nicht Achsen-Klassifikation.

**K7 — AUFLAGE an alle „parallel autonomen" WPs:** Struktur-Analyse-Pflicht (Z.1233(4), bindende Direktive) gilt je WP; der I1-deckungsgleiche WP-4-Anteil wird nicht vor den E-Entscheiden festgezurrt.

**Aussortierte False-Positives (verifiziert):** E14-Branch-Audit „fehlt als Arbeitspaket" — DONE (§15.9(b), 446c654, „0 Merges nötig") · gitlab-Batch-Nachzug — GELÖST (NACHZIEH F35/F52, beide Remotes seit 07-14/15; CI-Grün-Batch ist in (d)5 getrackt) · **DoD-7** — durch **E9 = „DoD-7=JA je Experiment" ENTSCHIEDEN** (nur die stale Klammer in V5.2/Z.79 braucht einen NACHZIEH-Vermerk → WP-6-Rest) · 40-major-Gate — abgehakt (Z.393: 35/40 FIXED, 4 GATED, „nichts still übergangen") · G-Q2/G-234V-a+b/G-7b3/G-268 — alle per NACHZIEH F42 entschieden/DONE · G8-Anhänge B/E — getrackt ((c)3 E21 + (d)5 G8) · E2-Sidecar-vs-Reserve — aufgelöst (CMD-2 ABI-neutral geliefert, Reserve→#37) · #29-Rest/Set-Sequence — getrackt als G-AP15-Rest/E18 · AP-2/B8, „#36-Scheduling", §11-A/B/C-Runway — NACHZIEH-neutralisiert (F50/F52/F46) · Smoke-first-Doktrin — in V5.5 verankert · #266-Q2/6-vs-48-Kern — Re-Gating-Artefakte (F55) · GO-2/graceful-skip — GO-2 VOLLZOGEN (F51; nur kurz verifizieren).

---

## (3) KONSOLIDIERTE VERGESSENE-PUNKTE-LISTE (echt untracked im Plan)

**A. In die Offene-User-Entscheidungen-Liste (c) aufnehmen:**
1. **Fork B „CI-Politik-W4"** (F62: CI zementiert Surrogat 5×, W4-Treiber 0 CI) — einziger der 9 Audit-Forks, der weder in E1–E16 beantwortet noch in E17–E21 geparkt ist.
2. **G5/#274 Design-Fork-Vorlage** (G-274-Rest nach Schritten 0–7; Z.1120/Z.1242): Vorlage autonom vorbereiten, Entscheid beim User — fehlt in (c) UND in der (d)5-Gate-Liste.
3. **48er-Datensatz-Rest** (G-6v48-Rest, user-gated; Z.1116).
4. **Hybrid-Intel-Re-Evaluation ~September** (i7-1270P-Ausschluss / 14900KS-RMA; GH200/E15 = ARM, deckt die Intel-Hybrid-Klasse NICHT) — zeitgebunden.
5. **#24-Rest:** vorbereiteter Overleaf-`\input`-Commit (READY, User-GO) + **Overleaf-Sync als offene User-Aktion** (beide Pushes lt. Remote-Topologie).
6. **§15.8(f)-Rest nachhalten:** V5 via `/goal` setzen · Antwort-Status der 4 vorgelegten E2E-Architektur-Befunde (G5-Facade-Vorschlag, Workload-Metaprog-Grenze, 2× ABI-Bump-GO, Subject-Rename-TABU-Gate).
7. **CMD-2-Rest** c2/c3-Skalar-Semantik-Entscheid; **#46 Fleet-github-Sweep** (~50 Repos, je-Repo-GO; nicht DA-kritisch); **A5-Status** (Modul-Repos main/master — Löschanteil unter E14/E19-Beleg-Doktrin verifizieren).

**B. Autonomer Backlog (ins Board, verletzen keine Gates):**
8. **snmalloc-A07-Laufzeit-Segfault** (Z.376: „separat zu tracken", Vendor-Runtime unter g++16/glibc) — VOR G6-Voll-Lauf relevant, sonst A07-Messungen gefährdet.
9. **WP-6-Rest Ledger-Hygiene** (F67/F46-Kern ist via G4-Paket ✅): F40-Nummernraum #33–#40, restliche F35–F55-Stales, DoD-7-Klammer-NACHZIEH (Z.79/83), V3-„AKTIV"-Label, nie angehängte #276-Matrix-Recherche.
10. **#40 Dead-Code-Reklassifikation** — in 15.8(c) „autonom-offen", in 15.9 verschwunden (verify-first, KEINE Löschungen).
11. **#31-Folge verifizieren:** ce-Parser-`<workload>`-Feld war Job-Token-Allowlist-gebumpt — durch REV17 (Deploy-Token-URLs) vermutlich **ENTSPERRT** und nirgends getrackt (OP-1..6-Vokabular).
12. **#266-P3** memory-Konsum-Kartierung (read-only, Z.1166-Korrektur) · **AP-12/#246**-Verifikation gegen AP-2-neu-Gate · **AP-7b**-Verifikations-TODO · **#217-2b** (Signal-Owner benennen) · **Review-C5-Debt** ce-Coverage profile_facade · **super `main→development`-Back-Merge-Beleg** (Z.388 „⚠️ OFFEN" ohne NACHZIEH; E14-Audit deckte Extra-Branches — main-Konsistenz-Beleg nachtragen).
13. **In die I1–I7-Revision explizit aufnehmen:** E4-Ziel-Anspruch („Firmware-Compile": Binaries zur Reproduktion + statische Heuristik-Steuerung) · Dataset-`<datasets>`-Konsum-Single-Source (E7-Verlängerung) · **P6** E4-XML=Alleinweg (im Brücken-Dossier als Ziel von E10/Subsumtion verankern) · **P5** Capability-Parität sweep_axis/--validate (Vorbedingung der gegateten Behelfsweg-Löschung).
14. **CI-Härtungs-Backlog beim CI-Batch-Signal:** #278 (User-PFLICHT: kein allow_failure, 58er-Strecke), #277 Lazy-Caching, CI-2..CI-6, #186-EPIC, #179 — großteils baremetal-P1-gebunden.
15. **Kleinteile:** P1-escape_latex-Doppel-Escape bei P1-Bau mitfixen (G6-Entsperrliste) · known_workload_ids-Auflage neuer Hosts (G6-Doku) · 12 `lc_surface_*.tex`-Regeneration (data-gated, an INC-2 koppeln) · „L für Node-Pools"-Code-Vollausbau · Baum-Pruning/Cross-Familie-Constraints als Entscheidung dokumentieren · „4 Schichten"-Begriff bestätigen · G-INFRA CRC64 (im V5.3-G-Stack, nie im Plan) · #188-Architektur-Rest (§11-A/B/C) · Zentralisierung Tools→CEB (gated, §15.5-P5/R4).

**C. Infra-delegiert (nur nachhalten, nicht selbst bauen — Cluster read-only):** §14.2-Block #21 [TOP-PRIO] · #23/H11–H18 (H11 CoreDNS KRITISCH) · #270b arm64-Beweis · #272/HO-1..12+WCM-Rotation · #273-T2 gcc-15.3-Pin · #279-Rest · ccache-S3+H15 · DoD-6-NFS-Parallel-Backup · Mess-CI-Tag-Mismatch (optionale Code-Milderung = User-Frage).

---

## (4) ANPASSUNGEN AN DER ABARBEITUNGS-REIHENFOLGE

1. **Neuer Schritt 0 — EIN konsolidiertes Klartext-Fork-Paket an den User** (AskUserQuestion NIE): E11-A/B/C + E13 (Vorlagen liegen in `backups/20260716-e11-phasen-e13-kontext/`) **+ Fork B (CI-Politik-W4) + G5-Design-Fork-GO-Frage + 48er-Rest + E20-Default-Bestätigung + Hybrid-September + §15.8(f)-Rest** — statt die Nachzügler einzeln nachzureichen.
2. **WP-3 splitten** (K1): phasen-orthogonale Härtung jetzt; Kardinalität/merge-Enum erst nach E11.
3. **E16 umhängen:** von (d)3-„Doku" in Arbeits-Tasks (Code-Tilgung); Tasks sofort anlegen, golden-neutrale Teile autonom abarbeiten.
4. **Nach WP-5 klein einschieben: WP-6-Rest** (Ledger-Hygiene, Punkt B9) — verhindert weitere Stale-Ansteuerung.
5. **G5-Design-Fork-Vorlage** als autonomen Vorbereitungs-Increment VOR die Kernfeature-Phase ziehen (Vorlage bauen ≠ entscheiden).
6. **(d)5-Gate-Liste ergänzen:** + G5 · + #276-Endbindung (allerletzte Aufgabe vor STOP-Prüfung) · + snmalloc-A07 als G6-Vorbedingung. #37 bleibt letztes Kernfeature mit Design-VOR-Bau (K3).
7. Sonst **Reihenfolge bestätigt:** I-Revision wartet auf E11/E13; Default #35→#38→#37 (E20); E10-Rückbau erst nach Subsumtions-Beweis; keinerlei Löschungen (E19).

---

## (5) JETZT AUTONOM STARTBAR (ohne offene User-Entscheide zu verletzen; je: Struktur-Analyse des offiziellen Pfads VOR Aufnahme + volle Kadenz + beide Remotes)

- **WP-5**: F56-REV-Mining (≥9 IDs; REV-DATA-01 + DATA-07 VOR G6) + F57 noexcept-auf-Alloc (~15 Bodies) — golden-neutral.
- **WP-4**: Registry-Round-Trip-Gates F29/F33/F64/F66 — mit Auflage K6 (keine Klassifikations-Registry) und ohne I1-Festzurrung (K7).
- **WP-3 (nur phasen-orthogonaler Teil)**: Test-Verdrahtung, fail-loud-/Pfad-Checks — KEINE Kardinalitäts-/Engine-Zahl-Regeln.
- **Doku-Increments**: **E12** (inhaltlich bereits user-entschieden, Z.102 „[E12 ENTSCHIEDEN]" — nur Propagation in die Doku-Landschaft) · **E15** (GH200-§8-Zeile, messgebunden) · **L1–L4** · WP-6-Rest-Hygiene.
- **E16-Tilgungs-Tasks anlegen** + golden-neutrale Tilgungen ausführen (raw-string-Ablösung, Naming) — als Code-Arbeit.
- **Verifikations-Backlog (read-only/golden-neutral):** #31-`<workload>`-Entsperrung prüfen · main→development-Back-Merge-Beleg · AP-12/#246 · GO-2/graceful-skip-Reststatus · A5-Status · #40-Reklassifikation (verify-first) · #266-P3-Kartierung · snmalloc-A07-Untersuchung (Repro/Diagnose, kein Vendor-Patch ohne Vorlage).
- **Vorlagen VORBEREITEN (kein Bau):** G5-Design-Fork-Dokument · #35-Kernfeature-Vorlage · konsolidiertes Fork-Paket aus (4)-Schritt-0.

**NICHT autonom (hart):** alles golden/ABI-Berührende inkl. #37-Bau (Design+TABU-GO zuerst) · Schema-/Validator-Kardinalität (E11) · jede Löschung (E19: KEIN GO) · V32-Rückbau (erst Subsumtions-Beweis) · Overleaf-/outward-facing Pushes (User-GO) · Cluster-Schreibzugriffe (read-only, Infra=Handover) · G6-Voll-Lauf-Triggerung außerhalb des freigegebenen opt-in-CI-Wegs (nie pollen).

Quelle: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (1268 Zeilen; Spot-Verifikate Z.75–118, 368–393, 1112–1131, 1194–1268).