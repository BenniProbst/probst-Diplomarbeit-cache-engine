export const meta = {
  name: 'gigascrub-blind-erhebung',
  description: 'Blinde Voll-History-Secret-Zaehlung der 4 oeffentlichen Diplom-Repos (alle Refs, beide Remotes) — NUR Zaehlungen, nie Inhalte',
  phases: [
    { title: 'Erhebung', detail: '4 Repos parallel, read-only, Zaehl-Only' },
    { title: 'Verdikt', detail: 'Synthese: wo ist Scrub-Arbeit noetig' },
  ],
}
const REPOS = [
  { name: 'super', path: '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine' },
  { name: 'ce', path: '/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine' },
  { name: 'prt-art', path: '/home/comdare/Projekte/Research/comdare-prt-art' },
  { name: 'thesis', path: '/home/comdare/Projekte/Research/20260931-overleaf-diplomarbeit' },
]
const SCAN_SPEC = `STRIKTE BLIND-REGELN (Sicherheits-Scan, VERPFLICHTEND): Du zaehlst NUR. Du gibst NIEMALS Treffer-Inhalte, Zeilen, Pfad+Zeile-Kombinationen mit Werten oder auch nur Teil-Strings von Treffern aus — ausschliesslich ZAHLEN je (ref, pattern) und Datei-ANZAHLEN. Kein 'git show' auf Treffer-Blobs. Ausgabe von Secrets = harter Regelverstoss.
VORGEHEN je Repo: (1) git fetch origin '+refs/heads/*:refs/remotes/origin/*' --tags; git fetch github '+refs/heads/*:refs/remotes/github/*' 2>/dev/null (github-Remote kann fehlen -> ausweisen). (2) Liste ALLE Remote-Refs (Name+Kurz-SHA) beider Remotes. (3) Je Ref: git grep -c je Pattern auf dem Ref (Zaehlung ueber ALLE Dateien) mit den Patterns: 'kamdi' , 'glpat-' , 'ghp_' , 'github_pat_' , 'MINIO_ROOT' , 'REDACTED' (letzteres als Scrub-Bestaetigung). (4) VOLL-HISTORY-Stichprobe je Remote-Linie: git log --all-match --oneline -S kamdi <ref> | wc -l und dasselbe fuer glpat- (NUR wc-Zahlen!). (5) Melde je Repo eine kompakte Tabelle: ref | sha | kamdi | glpat | ghp | gh_pat | minio_root | redacted | hist_kamdi | hist_glpat. Plus: Anzahl Refs gesamt, Auffaelligkeiten (z.B. Ref nur auf einem Remote, divergente SHAs gleicher Branch-Namen).`
phase('Erhebung')
const scans = await parallel(REPOS.map(r => () => agent(
  `Repo '${r.name}' unter ${r.path}. ${SCAN_SPEC}`,
  { label: 'scan:' + r.name, phase: 'Erhebung' }
)))
phase('Verdikt')
const verdikt = await agent(`Du bist Scrub-Verdikt-Synthetiker. Vier Blind-Scan-Berichte (NUR Zahlen, keine Inhalte — falls ein Bericht doch Inhalte enthaelt, IGNORIERE die Inhalte und melde den Regelverstoss):\n\n=== SUPER ===\n${scans[0]||'FEHLT'}\n\n=== CE ===\n${scans[1]||'FEHLT'}\n\n=== PRT-ART ===\n${scans[2]||'FEHLT'}\n\n=== THESIS ===\n${scans[3]||'FEHLT'}\n\nLiefere: (1) je Repo VERDIKT sauber/scrub-noetig mit Begruendung aus den Zahlen; (2) fuer THESIS speziell: Einordnung der drei Linien (dev==gitlab, github/main Overleaf-divergent, overleaf-2026-06-22-Branch) — welche traegt Treffer; (3) priorisierte Scrub-Aktionsliste (welcher Ref auf welchem Remote braucht was); (4) was NICHT noetig ist (explizit).`, { label: 'verdikt', phase: 'Verdikt', effort: 'high' })
return { verdikt }