# TEIL-2-SCHLUSSMELDUNG cifix-vl3-debug (23.08.2026 ~20:07 UTC, an Lead K31) — WOERTLICHE SICHERUNG

Strecke TERMINAL. CI 16101 = SUCCESS @ 3841d717, dreifach belegt: eigener Monitor
(TERMINAL:success), API (status=success, sha=3841d7175086), Lead-Messung deckungsgleich.

## (a) ENDBILANZ DER KETTE db66714a -> b6698eaf -> b247a339 -> 1f51eb3d -> 3841d717

- db66714a: Instanz-A-Basis (Fenster-Retry-Ursprungslinie; Zwei-Instanzen-Wahrheit fuer KON122).
- b6698eaf: Reset-Anker nach der Weg-B-Verwerfung — 5a8e2841 entfernt, nie gepusht;
  Patch-Beleg VERWORFEN-5a8e2841-riegel-weg-b.patch (additiv).
- b247a339: Form-(c)-Maskierung (Define-Token-Flaeche, Zaehler pmc_define_tokens) —
  CI 16097 SUCCESS, Push-Grund des ERSTEN Dual-Push; blieb als Drift-Wache scharf.
- 1f51eb3d: Env-Riegel COMDARE_PMC_PROBE_AUS in construct_plan_into (Cherry-Pick vom
  Endstand-Pruefer, per Lead-Antwort A als Doppelboden akzeptiert); Koexistenz mit Form (c)
  am Objekt: 10 grep-Treffer, grundstellung() setzt Riegel, PmcProbeLebtOhneRiegel als Gegentest.
- 3841d717: zwei Pflicht-Verschaerfungen — (i) Riegel-AUSWEIS befund_grund=<fehlgrund>
  IMMER im [PMC-TESTAT]-FEHLER + exit 1 (Mess-Preflight, experiment_plan_director.hpp ~1758),
  (ii) NUR-TEST-Deklaration an der getenv-Stelle; K13-Biss literal (#361 rc=8, drei
  Fehlertexte) -> ruecknahme gruen; Pruefer las die K13-Probe unabhaengig gegen (SITZT).
  K17-r4 4/4 Zellen volle 7er-J-1-Treppe + Test 509 3x gruen Debug; Gates 6/6 STRIKT;
  gitleaks 2==2 (19079 B, 0 Funde); Floor 544==544; EIN zweiter serieller Dual-Push
  origin+github (beide ls-remote 3841d7175086); CI 16101 SUCCESS.

## (b) BEWEISORTE

~/backups-workflow/20260821-w1l-landung/cifix2-vl3debug/ (26 Dateien, alles gesichert):
R4-BILANZ.md · k17-r4-{gcc-rel,clang-rel,clang-dbg,gcc-dbg}.log + k17-r4-gcc-dbg-NACHBEWEIS.log
+ build-dbg-LastTest-nachbeweis-1406.log · gates-6x-3841d717.log + gates-6x-b247a339.log ·
k13-formc-mutation-ROT.log + k13-riegel-ausweis-mutation-ROT.log · k17-z1..z4-Logs (r3) ·
raeumung-r4.log · repro.log/ursache.md/fix-beweis.log/nachtrag-riegel.log ·
ci16073-job382856-trace-vollkopie.txt · VERWORFEN-5a8e2841-Patch. Zusaetzlich
(Pruefer-Sicherung): Z10/endstand-beweis/r4-lasttest/ (3 weitere LastTest-Kopien);
Patch-Kopie 20260823-pause-sicherung/.

## (c) K16/K11-VERMERK fuer KON122 (woertlich)

Beim r4-Kombibau pruefte das Zellen-Script den ctest-rc ueber eine Pipe (K11-PIPESTATUS-
Klasse: rc von tail statt ctest) und tail-3 schnitt die 100%-Bilanzzeile ab; zusaetzlich
lag in build-dbg ein stale LastTestsFailed.log aus der eigenen K13-Mutationsphase (13:49).
Selbst gefunden VOR der Meldung, geheilt durch frischen Voll-ctest @ 3841d717 mit
PIPESTATUS[0]-rc: RC=0, LastTestsFailed FEHLT nach Lauf, 544 end-time-Bloecke,
0x 'Test Failed.', 540x 'Test Passed.' + 4 WILL_FAIL-Negativ-Compile-Proben
(e24_c1/e24_c4/hy_a1_reroute/hy_a1_contract) — vierfach belegt.
LEHRE: ctest-Bilanz nie durch tail/Pipe fuehren; LastTest.log-Kopie als Nenner-Beleg sichern.

## (d) NICHT ERLEDIGT / UEBERGEBEN

1. Raeumung 4 Bau-Baeume + ccache + wt-ce-lande-Loeschpruefung (O-6-rekursiv) =
   AN LANDE-ZUG wf_b546634b uebergeben (Fahrer hat NICHT begonnen); Vorpruefung
   (porcelain 0, Tip 53c5524e Ancestor, keine nested) ist Momentaufnahme ~13:2xZ —
   der Zug muss frisch messen.
2. Slot-Mutex bauslots/slot2.d additiv als BEENDET markiert (nicht geloescht);
   der Zug darf raeumen.
3. 🔴 MERKPOSTEN (Pruefer-Warnung): PmcProbeLebtOhneRiegel faehrt die ECHTE Host-Probe
   (erwartet erhoben=1, lage-unabhaengig wahr) — die EINZIGE Stelle des Zuges mit
   Runner-PMU-Abhaengigkeit; kippt kuenftig ein CI-Lauf genau dort, ist das der BEFUND,
   nicht der Test. (-> Fallen-Register-Nachtrag)
4. Die 4 K17-Baeume stehen absichtlich (Beweis-/Wiederanlauf-Wert fuer den Zug).
5. KON122 zusaetzlich: Zwei-Instanzen-/Uebergabe-Protokoll (db66714a/b6698eaf,
   Cherry-Pick-Herkunft Endstand-Pruefer, Zustell-Latenz-Konflikt 09:08/09:20
   transparent aufgeloest).

Fahrer haelt an — kein Push, kein Commit, keine Raeumung. (idle_notification 20:06:58Z)
