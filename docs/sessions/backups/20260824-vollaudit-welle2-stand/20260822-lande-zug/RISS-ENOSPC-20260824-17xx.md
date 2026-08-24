# ZUG-RISS ENOSPC 24.08.2026 ~17:2x UTC (Lead-Protokoll, riss-sicher ausserhalb Repo)

LAGE: Waehrend Z22/Z23-Fenster lief die Platte auf 0 Bytes (97->100%). Owner-Order
"stop den workflow sofort" + "Die disk ist voll". Hooks fielen mit aus (uv-ENOSPC-
Totalblockade); Owner raeumte per !-Kommandos (rm builds-v0, pkill cmake/ninja,
rm ~/.cache/ccache); Task wg3va8971 starb selbst am ENOSPC ("No task found").

GESICHERT VOR/IM RISS: Z21 KOMPLETT (Journal-Result 7323 B; 3 Commits a578396c/
01ff20d9/7ab2b051: par.25 OV-16/17-BUCHUNG + Ledger-NACHTRAG + 12 W-Marker W11-
zuerst + T12b-##55 + H-5/S5-06 + F-101-Karte). Z22 HALB: Commit 16893298 (np34-
csv_to_latex-Umschrift BEIDE Rows DE+EN = L-01-Haelfte, pmcpaket-A-1 eingeloest)
LIEGT lokal; Abnahme/Result FEHLT (Agent a9f1b1f4 starb 17:2x). super dev lokal =
16893298, ahead origin 4 (a578396c..16893298); Z16-Z20-Merges bereits origin-seitig.

LEAD-MASSNAHMEN NACH RISS: build-w2fix geraeumt (+3.7G, Doppel-Bedingung 0/0;
Bilanzen in fixlogs/ gesichert; wt-ce-w2fix + Branch 926f8d70 stehen) · slot2.d-
Claim des toten Zugs ausgetragen (Todes-Beweis: Task weg, 0 Prozesse) · VERLUST-
PRUEFUNG Owner-Panik-rm: golden_fullpilot_320 16/16 getrackt+auf Platte, 0 deleted
beide Repos, K17-Baeume 4/4 (16G) stehen; ccache = verlustfrei; codex state_5.sqlite
I/O-beschaedigt (Fix: mv + Neuaufbau, kein Projektverlust).

PLATZ-LAGE 18:0x: 12G frei (96%). Runner-Volumes (~21.5G, pg-384xxx/385xxx) =
gitlab-runner-Territorium, NICHT anfassen (Infra-Agent-Bericht, Lead-bestaetigt;
Runner-Cache nach ccache-Verlust wertvoll fuer Z23-Pipeline). Notfall-Hebel beim
Infra-Agenten: ext4-Systemreserve 13.7G (reversibel) + backup1-Transfer +14G.
Raeum-Kandidat mit Owner-GO: ~/.cache/comdare/_deps (FetchContent-googletest-
Bauten, Cache-Klasse, verlustfrei neu baubar).

RESUME-REZEPT (nach Owner-GO): Workflow({scriptPath: ".../lande-zug-sequentiell-
wf_b546634b-3f5.js", resumeFromRunId: "wf_b546634b-3f5"}) — Z01-Z21 aus Cache;
Z22 laeuft NEU, findet 16893298 vor (NICHT doppelt committen — verifizieren +
Abnahme schreiben, z12neu-Muster analog); dann Z23 Phasen-Push + Gitlink-Bump
ATOMAR mit np34 (np34-HAELFTE DURCH 16893298 SCHON DA — Bump-Zug prueft und
buendelt; Frist Mi 26. 06:00) + Gates + Dual-Push + Pipeline 288; Z24-Z27.
VOR Resume: df >=5G-Gate + Modell-Wache je Neuspawn.
