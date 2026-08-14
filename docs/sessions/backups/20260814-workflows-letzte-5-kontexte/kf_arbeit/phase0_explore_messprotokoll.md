# PHASE 0 -- GROSSES EXPLORE: Messprotokoll (read-only, 14.08.2026)
# Alle Messungen mit /usr/bin/grep absolut, rc auf eigener Zeile, git read-only.

## S0.1 OBJEKT-STAND (frisch gemessen)
ce  HEAD = 643102fb55a1fcdde05c749012160c0fbeaf355b (branch development, rc=0)
ce  rev-list --count origin/development..HEAD = 12
super HEAD = 13a16b4629a7edb56ab741dc413035e9cc61565f (branch development, rc=0)
super rev-list --count origin/development..HEAD = 29
super Gitlink am HEAD: 160000 commit 5f3f26a5294f75572a7d2907ec8ebbb1de482f2a (kein Bump, korrekt)
Lock-sha256 (Worktree-Datei UND git show HEAD:tools/axis_version_lock/axis_version.lock):
  e7263b82042ce662c40aada63cad33acc1d10d39f866388c9bb10e6b6c65cdfd
Floor scripts/ci_test_inventory_floor.txt: avx512f 492 (:367) / avx2 488 (:368) / basis 486 (:369)
Ledger: 27445 Zeilen; Kopf-KON = KON60 (Z.19); KON60-NACHTRAG A (Z.357); KON61 = 0 Treffer (FREI)
MANUAL_RUN.md:279 traegt ':1310ff' (stale); real '(3b) PDF-GATE' = ci/anhang_forward_core.sh:1321 (frisch, rc=0)
ABWEICHUNGEN gegen Design-Kopf (dort super 09cd97a3, 27 voraus, Ledger 27383 Z.):
  +2 Commits seit Design: 16f777be (A2.5-Fix Anker 662->710) + 13a16b46 (KON60-Nachtrag A, +62 Ledger-Z.)
  -> deckungsgleich mit RAHMEN-Angabe "13a16b46 nach Stufe-1-Fix". Sonst 0 Abweichungen.

## S0.2 #97 RIEGEL-ECHTFALL (4 Literale, alle belegt)
(a) -rw-rw-r-- 2944 Aug 13 12:13 s7-riegel-echtfall-20260813.log
    lrwxrwxrwx s7-riegel-echtfall-20260814.log -> s7-riegel-echtfall-20260813.log
(b) Log woertlich: [1] --check rc=1 (ROT) "ROT Digest geaendert OHNE gueltigen Version-Bump
    (1.0.0.c -> 1.0.0.c) libs/cache_engine/axes/lookup/axis_03a_search_algo_array256.hpp"
    [2] --write rc=0, sha danach e580a636fbcf0b73302886b881e0f52884b1dbcd4d3f2b5a534dc071051e1ef3
    [3] --check rc=0 (GRUEN) "GRUEN bestand konsistent -- 718 Dateien (heuristik=6, organ=640,
    system=16, mess=1, tier_substanz=55) -- deckt 712 von 712 Overlay-Quellen"
    Ruecknahme: sha == e7263b82... (Referenz), git status --porcelain => 0 Byte (LEER), --check rc=0
(c) git show HEAD:...axis_version.lock | sha256sum = e7263b820...cdfd (Praefix e7263b82, unveraendert)
(d) S-7-Diff (d215b127^1..d215b127) = 8 Dateien; je Datei grep -cF im Lock = 0 (Summe 0/8);
    Gegenprobe axis_03a_search_algo_array256.hpp = 2 Treffer (Muster beisst)

## S0.3 START-GRENZE WALLCLOCK (Zitate)
Ledger KON60-08 (:203-237), KON51-01 (:1481-1493 LADE-VERANTWORTUNG), KON51-02 (:1501, nur ENDE),
KON25-08 (:4465-4485 Raketen-Mechanik).
ce-Objekt: konfiguration.hpp:85-89 (AnschliessenBefehl/StartBefehl/EndeBefehl = Kanal-Lebenszyklus,
getrennt), :106-109 (Wallclock = MessEbene::Compare); steuer_dock.hpp:118 ("Die WEICHE VOR der
Messung"), :123-127 anschliessen(); pruef_dock.hpp:41 (Exit 4 "vor Messung"), :85 ("Misst EIN
geladenes Modul"), :88 (Konformitaets-Gate "VOR der Messung").
BEFUND: Start-Grenze aus Bestand ableitbar -- Laden/Anschliessen liegt VOR der Klammer.

## S0.4 B4-KETTE (Fundstellen)
26.07. FASSUNG 1 KERN=GESETZ: Ledger:26497-26505 (NACHTRAG 08.08., :26484) + Session
  20260726-SESSION-achsen-neuordnung-lager-baeume-xlsx-regressionen.md:89-98 Par.6;
  Rohtranskript 46375cdc...jsonl: "xlsx ist in Zukunft default und CSV einstellbar und fallback"
05.08. nachmittag-1: Ledger:19403-19405 (Owner verbatim, "default xlsx geschrieben")
05.08. nachmittag-3: Ledger:19392-19395 (Owner verbatim "CSV xor xlsx ... xlsx ist default?
  ... strategy pattern"); Rohtranskripte 46375cdc + b15ade0e (mehrfach)
08.08.: Ledger:26484 "XLSX: DIE DEFINITION EXISTIERT SEIT DEM 26.07., DER WRITER FEHLT"
13.08. B4: Rohtranskript -home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:52798
  (type=user): "B4: Es gibt keine CSV ohne xlsx und xlsx ist Standard, bitte Explore ueber
  10 Wochen wie das war." -> KON60-05 (Ledger:143-163)
D-12: Ledger:3027 + :4976-4977 (Messdaten MESS->SYSTEM->ORGAN, Binaries SYSTEM->ORGAN->MESS)
Wellenplan v2: 20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md:27 (##26-Formel) + :710 (##56)
ABWEICHUNG: Design-Zeiger "KON22" traegt KEINE xlsx-Substanz (KON22-01..03, Ledger:4766-4832,
  grep strategy|rueckschreib|format|xlsx|csv ueber den Block rc=1); Kette laeuft ueber die o.g. Knoten.

## S0.5 B2-REFERENZ
KON60-07 (Ledger:181-201): "0/8-Kollisions-Erhebung eigenstaendig reproduziert (8 Token gegen
Hardware-Katalog kFlagGrammarCatalog[62] + Reserve[14], Positiv-Kontrolle 'bw' beisst; ...)".
Syntax-Auflage beachtet: :190-Zitat "cpe ist ein Kuerzel wie 'g','e','f','n'" ist PROSA,
nie als Beleg fuer flache Kuerzel lesen -- geltende Form c{p}/c{e}/c{p.e}.
