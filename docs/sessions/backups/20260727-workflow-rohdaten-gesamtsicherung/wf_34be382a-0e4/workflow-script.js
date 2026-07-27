export const meta = {
  name: 'parallelisierungs-strategie-offene-todos',
  description: 'Strategische Parallelisierungs-Planung der GESAMTEN offenen TODO-Liste: disjunkte parallele Straenge + sequentielle Ketten + Synchronisationspunkte',
  phases: [
    { title: 'Inventar', detail: '4 parallele Straenge: Stack/Roadmap, Folgearbeiten+gated, Abgabe-Blocker+Thesis, Abhaengigkeits-Kanten' },
    { title: 'Strategie', detail: 'Strang-Plan autorieren (Parallelitaet maximieren, Konflikte vermeiden)' },
  ],
}

const SUPER = '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine'
const CE = SUPER + '/Code/external/comdare-cache-engine'
const LEDGER = SUPER + '/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md'
const BACKUPS = SUPER + '/docs/sessions/backups'

const COMMON = 'GEMEINSAME DIREKTIVEN: (1) Belege datei:zeile bzw. Abschnitts-Referenz. (2) Keine Secrets. (3) KEINE Commits/Code-Edits; nur die eine Dossier-Datei in der Strategie-Phase. (4) Rueckgabe = roher Daten-Report. (5) Token-effizient. Pfade: SUPER=' + SUPER + ' CE=' + CE + ' LEDGER=' + LEDGER + ' BACKUPS=' + BACKUPS + '\n\nKONTEXT (autoritativ):\n' + args.facts + '\n\n'

phase('Inventar')

const [stack, folge, abgabe, kanten] = await parallel([
  () => agent(COMMON +
    'AUFGABE 1 — STACK+ROADMAP-INVENTAR. Lies LEDGER §0-GOAL-V6.2 (Arbeitsprogramm-Stack, ab Z.75), §20 (ab ~Z.1900, inkl. Q2-Ruling + 20.D/20.E), §19.E, sowie die INC-1-Bauplaene (' + BACKUPS + '/20260717-inc1-bauplan/BAUPLAN-INC1-CEB-SYSTEMACHSEN-SCHICHTUNG.md komplett + ADDENDUM-Q1-DACH-Q2-VORLAGE-Q3-COMPILER.md komplett) + den INC-2-Planungs-Index (' + BACKUPS + '/20260717-inc0-bauplan/BAUPLAN-INC0-DLL-LOAD-B.md §6). Liefere: (a) die exakte INC-1a..1h-Sequenz mit internen Abhaengigkeiten (was MUSS sequentiell [1a vor allen; 1b vor 1c-1g?], was ist untereinander disjunkt-parallelisierbar [1c/1d/1e/1f nach 1b?]) je mit beruehrten Dateien/Verzeichnissen (fuer Konflikt-Analyse); (b) INC-2-Bündel-Bestandteile (F1b Set + F2 Set-POD + F12iii Telemetrie + #37 + Pruef-Dock-Unify + H-7-Vollausbau + golden-Neubau) + die offene W3-Strukturfrage (golden-Materialisierung eigenes INC-3 vs. gefaltet) + was INC-2-Planung an Vorarbeit braucht; (c) welche INC-2-PLANUNGSARBEIT (nicht Bau) schon parallel zu INC-1-Bau laufen koennte.',
    { label: 'inventar:stack', phase: 'Inventar', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 2 — FOLGEARBEITEN+GATED-INVENTAR. Lies LEDGER §20.E (GATED-Status), §18.5 (Roadmap+offene Punkte), §16.4/§16.6 (grep "16.4"/"16.6"), das V6.2-Arbeitsprogramm (Folgearbeiten + gated Reststrecke) + Dossiers ' + BACKUPS + '/20260716-experiment-planer-codegen-design/ (F5-Codegen) + 20260716-gesamtkonzept-experiment-ausfuehrung/ (Serialisierung Q1-Q4, 4 Neu-Bau-Straenge: Planer-3.-App / XML-CI-Interpreter F6 / Debug-Mess-Schalter / serialisierter Ergebnis-Baum). Liefere je Posten: WAS (1 Satz), Abhaengigkeit (braucht INC-1? INC-2? nichts?), gated-Status (User/Infra/Daten/frei), beruehrte Verzeichnisse, grobe Groesse (S/M/L). Erfasse AUCH: S-7-Deep-Research (offen), G5/#274 (Projektende), der echte Mess-Lauf (nach INC-2, mehrtaegig), CI-Nachzug (geparkt bis Aufgaben-Abschluss), F12i-Ledger-Relozierung (Hygiene), F10-LaTeX-Mess-Schnittstelle, F7iii-ZIH, F9-perf-PMC-Pflicht, #193-Handbedienbarkeit, Ruckschrieb measurement/<ts>/.',
    { label: 'inventar:folgearbeiten', phase: 'Inventar', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 3 — ABGABE-BLOCKER+THESIS-INVENTAR. Lies LEDGER: grep -n "Anhang\\|Anhaenge\\|G8\\|Abgabe\\|CRC64\\|B_code_structure\\|E_architecture" + die Fundstellen-Umgebung; §0-GOAL-V6.2 letzter Stack-Punkt; Memory-Dateien /home/comdare/.claude/projects/-home-comdare/memory/project_thesis_latex_struktur_bilingual.md + reference_thesis_git_topology_remotes_overleaf.md + feedback_text_agent_sessions_belong_in_thesis_not_impl_repo.md. Liefere: (a) die Abgabe-Blocker praezise (Anhaenge A/B/E-Stubs [Thesis-Repo, Overleaf-gated?], CRC64, was noch), (b) welche Thesis-Arbeit UNABHAENGIG vom Code-Stack laufen kann (reine Text-/LaTeX-Straenge — parallelisierbar ab sofort?), (c) die F10-LaTeX-Messdaten-Schnittstelle (fest verdrahteter Output -> Overleaf-git, bei jeder Messung ueberschreiben) — Abhaengigkeit (braucht Serialisierung/Messlauf?), (d) #193-hand-bedienbar: was ist #193 (grep "#193") und was fehlt.',
    { label: 'inventar:abgabe', phase: 'Inventar', model: 'opus' }),

  () => agent(COMMON +
    'AUFGABE 4 — ABHAENGIGKEITS-KANTEN + KONFLIKT-MATRIX. Ziel: welche Arbeiten koennen GLEICHZEITIG laufen ohne sich zu beissen? Analysiere: (a) DATEI-Konflikt-Ebene: welche der Straenge (INC-1a..1h-Bau in CE libs/cache_engine/{concepts,anatomy,builder,profile_facade} · INC-2-PLANUNG [read-only] · Planer-Codegen-Design/Bau [neue Dateien tools/planer?] · Serialisierungs-Bau [builder/serialization?] · Thesis-LaTeX [SEPARATES Repo] · Ledger-Hygiene [docs/] · CI-Nachzug [.gitlab-ci.yml, GEPARKT]) beruehren dieselben Dateien/Verzeichnisse? Baue eine Konflikt-Matrix. (b) SEMANTIK-Kanten: was braucht Ergebnisse wovon (z.B. Serialisierungs-Bau braucht INC-1-Schichtung? Planer-Codegen braucht INC-2-Planer-Dock oder nur Design? F10-LaTeX braucht CSV-Format=Serialisierung)? (c) RESSOURCEN: 1 Haupt-Agent (Code-Bau sequentiell sauber) + parallele Hintergrund-WORKFLOWS (Planung/Recherche read-only) + ggf. Worktree-isolierte Bau-Agenten (Doktrin: selbst implementieren — aber Planungs-/Doku-/Thesis-Straenge sind delegierbar; beachte Memory feedback_selbst_implementieren + dass Thesis-Text-Sessions ins Thesis-Repo gehoeren). (d) Empfehlung: die maximal sichere Parallelitaets-Stufe.',
    { label: 'inventar:kanten', phase: 'Inventar', model: 'opus' }),
])

const okN = [stack, folge, abgabe, kanten].filter(Boolean).length
log('Inventar fertig: ' + okN + '/4')

phase('Strategie')

const plan = await agent(COMMON +
  'AUFGABE S — STRATEGIE-DOSSIER SCHREIBEN: ' + BACKUPS + '/20260717-parallelisierungs-strategie/STRATEGIE-PARALLELE-STRAENGE.md (KEIN Commit). Auf Basis der 4 Reports: der strategische Plan, der die GESAMTE offene TODO-Liste in disjunkte PARALLELE Straenge + sequentielle KETTEN ordnet, um maximal parallel zu entwickeln. Struktur:\n' +
  '(1) STRANG-DEFINITIONEN: benannte Straenge (z.B. STRANG-BAU = INC-1a..1h -> INC-2 -> Folge-Baus [Haupt-Agent, sequentiell sauber]; STRANG-PLAN = INC-2-Planungssession + W3-Doku-Aufloesung [ultracode, read-only, parallel]; STRANG-THESIS = LaTeX/Anhaenge [separates Repo, voll parallel]; STRANG-DOKU = Ledger-Hygiene; STRANG-INFRA = CI-Nachzug [geparkt, Trigger User-Meldung]; STRANG-MESS = echter Messlauf [gated nach INC-2]) — je: Inhalt, Abhaengigkeiten, beruehrte Pfade, wer (Haupt-Agent vs. Hintergrund-Workflow vs. delegierter Agent), Freigabe-Status.\n' +
  '(2) SEQUENZ+SYNC-PUNKTE: Zeitachse mit Synchronisationspunkten (z.B. SYNC-1 = INC-1g fertig -> INC-2-Bau-Freigabe einholen [Planung liegt dann schon vor]; SYNC-2 = INC-2 fertig -> Messlauf + F10; SYNC-3 = CI zurueck -> Batch-Nachzug).\n' +
  '(3) KONFLIKT-REGELN: aus der Konflikt-Matrix (Report 4) — welche Straenge duerfen NIE gleichzeitig dieselben Verzeichnisse anfassen; Merge-Doktrin (NIE rebase).\n' +
  '(4) SOFORT-STARTBARE PARALLEL-AKTIONEN (heute): konkret welche 2-4 Straenge JETZT anlaufen (STRANG-BAU INC-1a laeuft bereits; STRANG-PLAN INC-2-Planungssession sofort parallel? STRANG-THESIS sofort?) — je mit erstem Schritt.\n' +
  '(5) FREIGABE-BEDARFE: welche Straenge brauchen noch User-GOs (je Phase) und wann sie eingeholt werden sollten (so frueh wie moeglich batched).\n' +
  'RUECKGABE: Dateipfad + der Strang-Plan als kompakte Tabelle + die Sofort-Aktionen + Freigabe-Bedarfe.\n\n' +
  '=== REPORT 1 (Stack) ===\n' + (stack || '(ausgefallen)') +
  '\n\n=== REPORT 2 (Folgearbeiten) ===\n' + (folge || '(ausgefallen)') +
  '\n\n=== REPORT 3 (Abgabe/Thesis) ===\n' + (abgabe || '(ausgefallen)') +
  '\n\n=== REPORT 4 (Kanten/Konflikte) ===\n' + (kanten || '(ausgefallen)'),
  { label: 'strategie:plan', phase: 'Strategie', model: 'opus' })

return { inventar_ok: okN, plan: plan || 'AUSGEFALLEN' }