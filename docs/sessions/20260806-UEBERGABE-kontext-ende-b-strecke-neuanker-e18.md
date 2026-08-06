# KONTEXT-UEBERGABE 06.08.2026 ~06:50 Berlin — Audit-/B-Strecken-Session (Kontext endet; Arbeit laeuft weiter)

> **ERST-ANKER:** super-Ledger `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` Nachtraege **abend-1..abend-13 + frueh-1** (rueckwaerts). Dann Pause-/Lage-Doc `20260805-PAUSE-abbruchsicher-abend-audit-und-b-strecke.md` (Zwei-Sessions-Register, Reststrecke Abschnitt 4, Fallen Abschnitt 6). Dann Memories: `feedback_wiederanlauf_doktrin_nach_session_abriss`, `feedback_claude_code_arbeitsweise_v2_konsolidiert` (inkl. Explore=Sonnet-5-max-Regel + Dual-Review-Pflicht Codex+Fable).

## 1. LINIEN-IST (verifiziert 06:43 UTC+2)

- **ce**: `dev == main == b4110cd0` (Gate 405). Komplett gelandet: A8-S5 + ANKER GATE 5 (Job-Sperre BEENDET) + W1 Planer-Binary + W2 + w2-codex-Fixes.
- **super**: `dev == 4d8d9e4a` (nach frueh-1-Commit), **`main == 61548676` — main-FF HAENGT** (Doku-Kette aede384b..4d8d9e4a; nach CI-Gruen pinnen: `git -C super push origin <VOLL-SHA>:refs/heads/main` + github).
- Platte ~56G frei. Frist: **Abgabe Fr 08.08.**; Kollisionsregel (Owner F5): **Substanz gewinnt, Trigger darf rutschen.**

## 2. ZWEI-SESSIONS-REGISTER (bindend, Ledger abend-2/-3/-5)

- **BAU-SESSION** (b15ade0e): besitzt `wt-e24` (Branch `w5-w3-kern`, @ff6560b9, **UNGELANDET**, W5/W3-Nachbesserung nach 9 Codex-Befunden), `wt-super-w1`, Haupt-Baeume. Ihre Landung ist das GATE fuer Neuanker-Teil-2 und B13-Bau.
- **DIESE LINIE** (Audit/B-Strecke): besitzt `wt-b*`-Namensraum. Landungen NUR nach **Lebend-Check** (Worktree-HEAD-Vergleich nach Wartezeit + pgrep) + Ledger-Koordinationsvermerk. Jeder Merge existiert GENAU EINMAL.

## 3. UNGELANDETE STAENDE (die eigentliche Arbeit)

| Was | Wo | Stand | Naechster Schritt |
|---|---|---|---|
| **Neuanker Teil 1** (O-2=A, Format 3) | `wt-b2-neuanker` @c371a9c6 (3 Commits: a16208ac C-1 Sidecar / 8f9b73de C-2 KERN / c371a9c6 C-4a) | Dual-Review **BEIDE NACHBESSERN** | **NB-Welle CX-1..CX-4+FB-1** (s.u.), dann Zweit-Dual-Review |
| **E-18 Vorwaerts-Kanal** (B1, HAUPT-ZIEL) | ce: `wt-b1-e18` @253bcd86 (2 docs-Commits); super: **PATCH-Vorschlag** `backups/20260805-b1-e18-nachbesserung/super-anteil/` (apply --check RC=0) | **LANDEBEREIT** (Fable-Zweitreview; Codex-Ausfall spend-limit dokumentiert = Ersatz-Klausel) | ce-docs mergen (kollisionsfrei) + super-Patch in EIGENEM frischen Worktree landen; Voll-Kadenz; **Job bleibt INERT** (COMDARE_ANHANG_FORWARD) |
| **B13 ETA/headless** | Plan fertig (`backups/20260805-b13-eta-plan/plan.md`), `wt-b13-eta` leer | GATED auf W5/W3-Landung | danach Branch NEU ab dev + Re-Anker-Pass, C1..C5 bauen |
| **W5/W3** | Bau-Session, wt-e24 | ungelandet | beobachten; NICHT anfassen |

### Neuanker-NB-Befunde (Ledger abend-13, VOR Landung zu heilen)
- **CX-1 (BLOCKER):** Preimage-Injektivitaet nur fuer CT-Defines bewiesen — RT-injizierte Werte brauchen Laufzeit-Newline-/Format-Wache.
- **CX-2 (MAJOR):** Toolchain-Renderer nicht intern injektiv (rohes `;={}@`-Konkat — Escaping/Zeichenvorrats-Wache).
- **CX-3:** Compiler-REAL-Versions-Erhebung EXISTIERT NICHT (nur Felder; `__GNUC__`/`__clang__`-Parser bauen — DER A2-C1-Heilungs-Kern; Erhebung an CEB-/Configure-Grenze per Plan `backups/20260805-neuanker-soll/soll-spez.md`).
- **CX-4:** Live-Defines leer (`COMDARE_TOOLCHAIN_STAMP_GLIED ""`) — Injektion an der Bau-Naht.
- **FB-1:** STOP-GATE-Beweis auf ECHTEN Pfad (`builder/experiment_tree/cache_engine_builder_iterator.hpp` — nicht `builder/`).
- Danach: Teil 2 = C-3 (F1 Zell-Pfad + F4 resume-v6 **mit Owner-KERN Zaehler-Resume**: Batch-Plan [Reihenfolge+Faecher] persistent VOR Lauf, Resume=Zaehler je Phase kompiliert/gemessen) + C-4-Rest — NACH W5/W3; Merge-Reihenfolge W5/W3 zuerst, dann Buendel komplett; danach **TP1-Wiederholung + 4+1-Beweise EINMAL** auf finalem Stand.

## 4. RESTSTRECKE (Reihenfolge, Owner-GO liegt fuer ALLES vor)

1. Neuanker-NB-Welle → Zweit-Dual-Review → (Gate W5/W3) Teil 2 → Landung Buendel → TP1+4+1.
2. E-18-Landung (ce-docs + super-Patch, eigener Worktree, Lebend-Check).
3. B13-Bau nach W5/W3. 4. A1-Scheibe (layout_aware-Wurf-Vertrag, Posten 74). 5. **B14** GOLDEN-XML-Aktualitaet+Sync-Gate (A7-KERN: staendig gepflegte Trigger-Input-Basis). 6. B-Rest B2/B3/B4/B8/B9/B11 (Ledger abend-4; B12 xlsx waehrend Voll-Bau + IN die Abgabe). 7. KF-6-Fenster mit SOTA-Design-Input (`backups/20260805-deep-research-a4-a5/synthese.md`). 8. Phasen 3-5 → Trigger → **Phase 6 = USER-GO-STOPP**.

## 5. HEUTE NEUE OWNER-KERNE (alle verbatim im Ledger, Memories nachgezogen)

Zaehler-Resume (A1) · Sortierung=Key-Filter + Map traegt Key- UND Value-Filter-Achse (A5; 4 Optionen unbewertet fuer nach Abgabe) · GOLDEN-XML=gepflegte Trigger-Input-Basis (A7→B14) · KF-6=Kernfeature-Vollausbau alle line_sizes (A4) · Explore-Lenses=Sonnet-5+max+very-thorough · Dual-Review Codex+Fable Pflicht (Ersatz nur nach frischer Defekt-Probe) · 289-Token liegt im Cred-Vault "Cluster git" (dort ZUERST suchen) · E-18-Ziel-Branch-Entscheid development-vs-main OFFEN beim Owner.

## 6. BETRIEBS-WARNUNGEN

- **SPEND-LIMIT:** Codex fiel mit "monthly spend limit"; auch die Haupt-Session sah die Meldung. Vor Codex-Nutzung frische Probe; Ausfall ehrlich verbuchen (Ersatz-Klausel).
- PAT: `.patcfg` im Scratchpad der 46375cdc-Session; bei neuem Fenster Blind-Extraktion (PAT-FALLE-Memory: rueckwaerts gegen /api/v4/user, Position rotiert). Projekt-IDs: ce=286, super=288, thesis=289.
- Wiederanlauf-Doktrin IMMER: Ledger-Volltext + Objekt-Ist + Lebend-Check, NIE blind resumen; Momentaufnahmen kennzeichnen; Doppellauf-Literale ins Backup; Redaktionspass vor Backup-Commit; CI-Wachen mit Job-Liste; `measure_out_d03` bleibt untracked (Owner-Default).
