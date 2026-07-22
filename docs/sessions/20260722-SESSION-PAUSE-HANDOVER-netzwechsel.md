# PAUSE-HANDOVER 22.07.2026 ~11:00 — Netzwechsel (Shell-Cache-Reset erwartet)

> Absturzfeste Sicherung VOR dem Netzwerkwechsel. Falls Session/Teammates/Monitore verloren gehen:
> ALLES Noetige steht hier + in den referenzierten Docs. Vorgaenger: 20260722-SESSION-KONTEXTUEBERGABE-
> nacht-audit-sweep.md (frueh) + 20260722-SESSION-REIHENFOLGE-UPDATE-praezisierungen.md (Fahrplan).

## 1. HARTE STAENDE (alle dual gepusht gitlab+github, Working Trees clean)
- **ce**: development `bceefa8d` (K7b-1 SHA512-Primitiv) · main `8a3a58c9`.
- **super**: development `a316f87` (Gitlink ab245e84 + §64-Phase-1) · main `332c74a`→`332c54a` (unveraendert).
  Spaetere super-Commits heute: f262dac(P1+Sweep) fd1a626(B4) b8a19c1(ArchDoc) b50bdd4/8b6de63(R8a)
  0cf2776(R8b) 09238db/2bbcf3f/9f35260/4f637ab/1460f9e(§62-B-P1-4+ETA) 21712eb/8336e2d(§64) 74ce29e(K7b-Vorzug)
  c4b2cc9(Versionierungs-Klaerung) a763c86(Reihenfolge) 2d4e4ff(Schicht4) a316f87(Ph1-Bump).
- ce-Kette heute: 3c2bad51(R7) 50c519f7(R7-Pin+P2) 8ac2c1f5(P3/R6) fa912241(R8a) cf551722(DocFix)
  c85ddafe(Schicht1-3) 11c4315f(Schicht4) ab245e84(§64-Ph1) bceefa8d(K7b-1).

## 2. CI LIVE BEIM NETZWECHSEL (laeuft serverseitig weiter / Abriss-Risiko)
- **VEREINTER SMOKE 12160** (a316f875): Standard-Bridges thesis/prt-art/ce GRUEN; planer:delegate-trigger
  war pending -> die LANEN-EMISSION passiert waehrend der Pause. BEWEIS-ERWARTUNG: EINE [all]-CEB-Lane
  (statt 3), 4 Perms/16 Chunks, Mess-Jobs mit debug-Methodik (COMDARE_PLAN_METHODIK_PROFILE=
  m3_smoke_coverage -> #45-parallel + (j3)-Dual-Compile sichtbar im Log).
- **Alt-Mess-Jobs 288981/288982** (wallclock-O2 no_ext/avx2, F-1-Kern, >110 min measure-Grind, Lane 12130).
- **RISIKO:** prod1-Runner = DIESE Maschine. Netzverlust -> laufende Jobs koennen als runner-failure enden;
  abgerissene Mess-Jobs koennen [RUN-1]-Zombie-Driver hinterlassen.

## 3. RESUME-CHECKLISTE (Reihenfolge)
1. GitLab-Erreichbarkeit (curl API). 2. Status 12160-Kette (Bridges rekursiv) + 288981/288982.
3. Bei Abriss: `ps -C comdare-messung-driver` auf prod1; Zombies -> runner:sweep-zombies-Job
   (COMDARE_SWEEP_ZOMBIES=true + SWEEP_TAG, [c]-Trick-Fix ist drin); Job-Retrys.
4. Monitor neu bewaffnen (Muster: Status-only-Hash, kein duration-Feld; Heartbeat alle 15 min).
5. Smoke-Beweis auswerten -> K7b-3-GO an Impl-Agent (s. Abschnitt 4).
6. Nach K7b-3->2->4: Gitlink-Bump, 320er (VEREINTE Lane), S7, S8 — Fahrplan im Reihenfolge-Doc.

## 4. AGENT Impl-S6-P1 — ZUSTAND + NEU-SPAWN-REZEPT (falls Teammate verloren)
STATUS: idle/eingefroren im K7b-3-STANDBY, Working Tree clean, NICHTS Offenes. Heute geliefert:
Audit-P1-P3, R8a/b, Doku-Fix, Methodik-Schnitt S1-4, §64-Ph1, K7b-1 — alle committet.
ARBEITSREGELN (bei Neu-Spawn mitgeben): Opus, background; FREEZE nach Paketmeldung, NIE committen;
cf22 NUR /home/comdare/tools/clang-format-22.1.8 (--dry-run --Werror); ASCII in neuen Zeilen (§ erlaubt);
TABU-Wachen (golden-CRC 0xF1C1F26A1232073B, Byte-Wachen); Belege literal; diff-stat-Literalpruefung
durch Manager vor add; Basis IMMER erst syncen.
NAECHSTER AUFTRAG = **K7b-3** (nach Smoke-Beweis, GO erteilt): AnatomyVersionLines +{sha512_line,len}
ans POD-Ende (anatomy_module_abi_v1_decl.hpp:144; Offsets stabil), layout 3->4 (:150), sizeof 72->88
(:157); Makro abi_v1.hpp:129-139 berechnet sha512(concat) INNEN consteval (Quelle K7b-1:
src/sha512/ctsha512.hpp) -> emittierter Call-Text UNVERAENDERT -> golden-NEUTRAL. Lockstep:
test_m_w12_stamp_bausteine.cpp:131/133/134/135 + neuer offsetof(sha512_line)=72; decl:157/160.
DANACH **K7b-2** (Measurement-MENGEN-Provenienz, D1=OPTION B: der [all]-Default stempelt die volle
3-Tool-Menge je @1.0.0 -> BEWUSSTER kNewGolden131072Crc64-RE-ANCHOR unter golden-Fenster-Regeln,
alter Wert als Historie im Test-Kommentar; 320er-Katalog-Anker 0xF1C1F26A bleibt unberuehrt =
PFLICHT-Testbeleg). DANACH **K7b-4** (G1: --version-Zweig im Treiber; Quelle system_axes_version_suffix
+ build_type_version_suffix + kCebContractVersion, komponiert wie print_cache_key_facade).
ENTSCHEIDUNGEN FIX: D2={char const*,uint64}; D3=Preimage concat(organ+system+measurement+merge)
fixe Reihenfolge als dokumentierte Konstante (Saat #46b-std::map-Lookup).
KERN-ENTLASTUNG (Kartierung): der POD hat NULL Laufzeit-Konsumenten (Loader dlsymt ihn nie;
Frische-Welt liest Sidecars) — Umbau beruehrt nur Byte-Wache + Makro.

## 5. GESETZES-STAND HEUTE (alles im Ledger, Kurzzeiger)
§62-B-P1-4 (Bestandsdokument/4096/ETA=Summe(t_i/N)>=max(t_i)/Lock<=30min/Multi-Write/Thread-Budget
prod1=32T prod2=24T/Batch-Typen-Sequenz) · §62-B-P2 (2 Bestaende Factory + SHA512-constexpr-Stempel)
· §64 KOMPLETT (Vereinigungs-Default + Mengen-Stempel X.Y.Z je Tag + Schichten-Zuordnung wallclock=CEB,
macro/micro=CEB+Tier via Pruefdock + Fundstellen + Versionierungs-Klaerung §58-V) · K7b-VORZUG=PFLICHT
(gated ccache; Position nach Smoke VOR/MIT 320er) · Reihenfolge-Doc a763c86.

## 6. OFFENE MERKPOSTEN
2 Runtime-Beweise (R8b-Key-Gleichheit Matrix-Opt-in; R1/R2-HIT GN_DECISION=skip) · CI-Wartung
(contract-Label-Luecke; prt-art-Geschwister-Checkout-Race; Suffix-Reihenfolge-Single-Source;
~14min-Treiber-Bau je Mess-Job; xmllint '--'-Kommentare; Testing/-gitignore) · W12-Quelldaten (v1->
echte X.Y.Z, Band-C) · #48-Scheibe-6 (gegated) · G7-User-Punkte.
