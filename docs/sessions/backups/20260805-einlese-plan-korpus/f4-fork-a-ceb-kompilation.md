# LENS f4-fork-a-ceb-kompilation — Einlese-Bericht (05.08.2026)

Frage 4 / Fork-A-Haerte: WIE soll die harte CEB-Kompilation je Messsystem materialisiert werden
(Codegen? -D-Defines? CMake-Emission? eigener CEB-Quelltext je [a,b,c]?) und was ist als Interim zulaessig?

Abkuerzungen: LEDGER = docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md ·
BAUPLAN = docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md ·
AUDIT = docs/sessions/backups/20260805-planer-ceb-kette-audit/ (alle Pfade relativ zu
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/).

---

## A. BEANTWORTET (mit Fundstellen)

### A1. WAS "hart" heisst — §30.6 ist der Kernsatz
LEDGER:2259 (§30 Punkt 6, User verbatim-treu): "Der **Planer bestimmt das Messsystem und
kompiliert HART ein effizientes CEB** fuer dieses Messsystem → der **CEB kompiliert Tier-Binaries**
mit den gewuenschten Organ-Achsen → ... (rekursive Delegation)".
LEDGER:2263 (§30-Einordnung): "die Nutzlast der Planer→CEB-Grenze = Messsystem-Wahl (CEB wird
messsystem-HART kompiliert, **nicht runtime-konfiguriert**)".
LEDGER:2264: "**Fork A des Bauplans ist damit ENTSCHIEDEN-VERSCHAERFT:** die CEB ist nicht nur eine
`.so`-Grenze, sondern eine **vom Planer GENERIERTE+kompilierte Binary je Messsystem** ...
Compile-time-Doktrin ueber die Stufen: jede Vorstufe friert die Wahl der Folgestufe als CT-Draht ein."

### A2. WIE materialisiert — Antwort des Korpus: PLANER-CODEGEN zur Configure-/Pre-Build-Zeit,
### emittiert ueber die zwei ConcreteBuilder (CMake + CI-YAML); NICHT Runtime-Env
BAUPLAN:243 (KONSOLIDIERUNG §30, autoritativ): "der Planer bestimmt das Messsystem und
**kompiliert HART ein effizientes CEB je Messsystem** (**Configure-/Pre-Build-Zeit-Codegen nach
`catalog_codegen.cmake`-Blaupause — kein Runtime-Konfigurieren**)."
BAUPLAN:244: "**FORK A VERSCHAERFT ENTSCHIEDEN:** die CEB ist ... eine **vom Planer
GENERIERTE+kompilierte Binary je Messsystem**. Die ... .so-Zeilen der Spiegel-Tabelle (4 Symbole /
Magic-Major-Gate / Loader / `host_compatible_with`) sind damit ZIEL-Design; die Sequenzierung
(Vertragsform zuerst, echte Generierung danach) bleibt Fork-C-Schnittfrage."
BAUPLAN:54: "der Codegen laeuft **strikt Configure/Pre-Build-Zeit**, keine vtable im gemessenen
Hot-Path" — Traeger: Interpreter + EIN `ExperimentPlanDirector` + ZWEI ConcreteBuilder
(`CMakeGraphBuilder` --emit-cmake / `CiYamlBuilder` --emit-ci, BAUPLAN:185) + Template-Method + CoR.
LEDGER:2403 (§40.b, User): "Der **Experiment-Planer steuert die Bau-Jobs von CEBs** und die
**CEBs steuern Bau-Jobs von Tier-Binaries**" — Stufe 1 = Planer emittiert die CEB-Bau-Jobs
(Child-Pipeline 1, **je Messsystem**/Maschinen-Signatur).
=> Die dokumentierte Ziel-Form ist also die Kombination "Planer-Codegen (generierte CEB) + harte
Kompilation je Messsystem + Emission via CMake-/CI-Builder". Ein reines -D-Define-Schema wird
nirgends als Ziel-Form genannt; ein Runtime-Env-Schalter ist zweifach explizit ausgeschlossen
("nicht runtime-konfiguriert" LEDGER:2263, "kein Runtime-Konfigurieren" BAUPLAN:243).

### A3. Je Tooling-Wahl EINE eigene hart kompilierte CEB-Strecke [a,b,c] + Stempel
LEDGER:2497 (§47, bindend): "**Jede Tooling-Wahl = eine eigene hart kompilierte CEB = eine eigene
`ceb:build:[a,b,c]`-Strecke.** Diese Wahl traegt den `kMeasurementAxisVersionLine`-Stempel (§43)."
LEDGER:2815 (§54/STUFE 1): "`ceb:build:[a,b,c]` -> `ceb:emit:[a,b,c]` (--emit-tier-ci) ->
`ceb:trigger:[a,b,c]`. **[a,b,c] = Mess-Tooling-HAUPT.**"
LEDGER:3065 (§56): "`ceb:build:[a,b,c]` — die **Mess-Achse baut NUR die CEB** auf und delegiert sie;
die CEB ist die **statische Repraesentative** der Mess-Achse."
LEDGER:3077 (§56-T2/D4, User-Klarstellung): "die per-CEB-Emission ist KEIN neues Konzept — **der
Planer emittiert CEB, das CEB emittiert ALLE Tier-Binaries; jede Schicht verifiziert/steuert NUR die
naechste, strikt durch die VERTRAEGE getrennt (DAS WAR SCHON IMMER SO).**" D4 = je `ceb:emit`-Lauf
NUR die tier-Jobs SEINER EINEN Mess-Konfig; fuer saubere N>1-Trennung fehlen 3 Teile
(Combo-Selektor an --emit-tier-ci · Selektor-Durchreichung im Stufe-1-Builder · combo-skopierter
Director-Walk).

### A4. Fan-out-Default SUPERSEDIERT durch §64: Default = EINE vereinte CEB (Vollmenge)
LEDGER:3381 (§64 GESETZ, 22.07.): "STEHT DAZU NICHTS IN DER XML: alle 3 Verfahren in der CEB
GEMEINSAM abgebildet per METAPROGRAMMIERUNG, und das PRUEF-DOCK nimmt alle 3 Features vom
Tier-Binary GEMISCHT ab." Getrennt/Teilmengen/nacheinander = XML-Recht.
LEDGER:3383: "die m3v2-F-3-Auslegung '3 separate Combos' und der measurement_combos_of-N>1-Fanout
als DEFAULT sind damit supersediert (bleiben als XML-Option)". LEDGER:3387: die §47/§54-Lesart
"jede Tooling-KONFIG erzeugt eine eigene ceb:build:[a,b,c]-Strecke, N->N Pipelines" ist "durch §64
SUPERSEDIERT (bleibt XML-Option ...)". LEDGER:3388: realer Code-Default war ohnehin die EINE
[all]-CEB ("LIVE-Default [all] GEHALTEN, N>1 gated", §56-T2).
Memory feedback_mess_tooling_default_vereint_eine_ceb bestaetigt inkl. Schichten-Zuordnung
(LEDGER:3397-3400): wallclock = CEB-Seite; macro/micro = CEB UND Tier ueber das Pruefdock
einkompiliert; Kette Planer-Mess-Achse -> CEB-Mess-Ausrichtung -> Tier-Observer = EIN statischer Draht.
=> "je Messsystem" heisst im Default: EIN Messsystem = die Vollmenge {wallclock,macro,micro},
also EINE hart kompilierte CEB; erst eine XML-Teilmengen-Anforderung erzeugt N>1 Strecken —
jede davon wieder als eigene HART kompilierte CEB.

### A5. Compile/Runtime-Grenze der CEB — was per Env/Call fliessen DARF
LEDGER:3095 (§57-S1, User verbatim): "die **Mess-Achse ist FEST EINKOMPILIERT** (compile-time;
**bis auf die dynamischen Unter-Achsen = Planer-Variablen**). **System-Achse und Organ-Achse sind an
der CEB NOCH RUNTIME** — die CEB baut zu IHRER LAUFZEIT die COMPILE-TIME Tier-Binaries."
LEDGER:3339 (§62-C): "Modi sind CALL-Parameter der XML (run_methodology), **nie Binary-Merkmal**";
LEDGER:3291 (§61-STUFEN-PRAEZISIERUNG): Modus-Wahl per XML, exactly-one je Call.
=> Env-/Call-Kanaele sind kanonisch NUR fuer Mess-UNTER-Achsen (Ablaufmethodik, Workloads,
Planer-Variablen). Die Mess-HAUPT-Achse (Tooling-Menge) MUSS compile-time in der CEB liegen —
genau das schliesst eine Env-Differenzierung der [a,b,c]-HAUPT-Wahl aus.

### A6. Stempel-Materialisierung (Beweis, dass die Wahl einkompiliert sein muss)
LEDGER:3104 (§57-S3): "**CEB-Stempel** (Typ + Version) = **die Mess-Achse des Planers** (die CEB IST
ein bestimmtes Mess-Tooling-Kompilat)." LEDGER:3116 (§58-V): CEB = "**KEINE Gesamt-Versionierung.**
Ein **ARRAY** `[Xa.Ya.Za, ...]` je einkompilierter **Mess-Achse [a,b,c]**".
LEDGER:3394 (§64-Phase-2): Mengen-Stempel {wallclock,macro,micro} mit je-Tool-Version an der
measurement_stamp_line; das CEB-Mess-ARRAY materialisiert im K7b.
LEDGER:3395 (K7b-VORZUG = PFLICHT, User 22.07.): (a) Array-FORM der Stempel (CEB:
Mess-Haupt-Achsen-Array), (b) G1 = IMMER-expliziter Je-Binary-**Compile-Stempel** (auch Planer/CEB
erhalten build_version), (c) constexpr-SHA512-Fingerprint-Zeile.
LEDGER:3285 (§61-STUFEN): "JEDE Binary im GESAMTEN System (Planer/CEB/Tier) braucht einen weiteren
Stempel, UNTER WELCHER COMPILE-EINSTELLUNG sie erzeugt wurde" (+bt= = cmake-Compile-TYP, nie Modus).

### A7. Bauplan-Phasen zur CEB-Erzeugung (generieren+kompilieren)
BAUPLAN:20-26: drei Phasen — Phase 1 (Kopf, NEU): benannter Codegen Interpreter + EIN Director +
ZWEI ConcreteBuilder + Template-Method + Planer-Executable + Planer↔CEB-Vertragsgrenze, "angedockt
an run_experiment_profile (nicht daneben)"; Phase 2 (CEB, WIRING); Phase 3 (Fuss, REUSE).
BAUPLAN:85 + 243: die Mess-Achsen-Haelfte von Phase 2 ist ÜBERHOLT — Nutzlast der Planer→CEB-Grenze
= Messsystem-Wahl + HARTE CEB-Kompilation je Messsystem; `CebSystemAxisDrive` bleibt System-Nutzlast
CEB→Tier. BAUPLAN:200: "Doktrin-Kompile-Reihenfolge bleibt: CEB VORHER auf Gattungs-Observer+Module
kompilieren, dann bauen+durchmessen (System-Config → Mess-Achsen-Heuristik)."
LEDGER:1723 (§18.1.1): CEB "selbst eine ABI-stabile .so, **SYSTEM-ACHSEN-VERSIONIERT**, mit eigenem
bidirektionalem Pruef-Dock" (Ziel-Design; .so-Form s. Interim A9/R1).

### A8. IST-Stand (Audit 05.08. — NICHT neu erhoben, nur referiert)
AUDIT synthese.md:36-38: "IST-VERSTOSS (verifiziert): Der Planer kompiliert NICHTS hart je
Messsystem. Der emittierte ceb:build-Job baut per `cmake --build build --target
comdare-messung-driver` stets DENSELBEN generischen Treiber (director:769-770) ...; die
Messsystem-Differenzierung [a,b,c] kommt zur LAUFZEIT per Env COMDARE_MEASUREMENT_COMBO in dieselbe
Binary — exakt die von §30.6 ausgeschlossene Runtime-Konfiguration. Kein im Ledger markierter
Deferred-Posten deckt diese Luecke (R1/#19 deckt die ABI-/Payload-Form, nicht die
Kompilat-Spezialisierung)." (identisch LEDGER:4024, Glied 3 = TEIL-KONFORM mit KERNSATZ-VERSTOSS).
Flankierende IST-Fakten: docs/sessions/20260727-PLAN-hw-erkennung-zwei-ebenen-factory-stempel.md:22
— "die Planer-Wahl (COMDARE_MEASUREMENT_COMBO) landet nur in der TIER-Binary
(anatomy_version_stamp.hpp:203-222), nie in der CEB" (CEB-Stempel-Zeile = Angebot in VOLLMENGE,
consteval). docs/sessions/20260801-DOSSIERS-oe-a-c-e-lager-stempel-bestandslog.md:130 (W-11):
"ein COMDARE_MEASUREMENT_COMBO-Wechsel verschiebt den Lager-Ort, aber dieselbe lokale Binary gilt
weiter als 'aktuell', obwohl die Combo die DLL-Bytes real stempelt".
docs/plaene/20260721-PLAN-46a-53-minimal-cache-ci-durchsatz-DOSSIER.md:123: "der _M-Tooling-Stempel
(COMDARE_MEASUREMENT_COMBO) aendert DLL-Bytes ohne Key-Wirkung — beides in cache_key_prefix ...
einfalten?" (offene Key-Klaerung).

### A9. Interim-Lage laut Korpus (was gedeckt ist — und was nicht)
1) **Gedeckte Interims existieren nur EXPLIZIT benannt:** §62-A (LEDGER:3306) Host-Lanes "bleiben
   INTERIM fuer die 28.07.-Kette (Interim-GO s. G)"; §62-G ① (LEDGER:3360) "INTERIM-GO: der
   28.07.-320er faehrt mit der committeten Lane-Emission, waehrend #46 entsteht"; §62-B
   (LEDGER:3316) "Die heutige Chunk-Job-Struktur war INTERIM (W4/INC-G6, vor dem §62-B-Gesetz)";
   R1-.so: "Textemission ist der akzeptierte Ist-Vertrag, .so-ABI = offener Post-v3-Pruefstrang"
   (AUDIT soll.md:61/100, LEDGER §60-R1:3247). Muster: Interim gilt NUR, wo es ausgesprochen wurde.
2) **Fuer die Env-Differenzierung der Mess-HAUPT-Wahl existiert KEIN solches Interim-GO** — der
   Audit stellt genau das fest ("durch KEINEN markierten Deferred-Posten gedeckt", synthese:38/78)
   und hat die Frage als Owner-Rueckfrage #4 registriert (synthese:116; LEDGER:4026: "Fork-A-Haerte
   interim (Env akzeptiert oder mindestens -D-Compile-Define?)").
3) **Der sanktionierte Zwischenzustand, den der Korpus hergibt:** §56-T2 (LEDGER:3077) "LIVE-Default
   `[all]` GEHALTEN, N>1 gated" (Scharfschaltung erst nach D1→D2→D4 + User-golden-Topologie-GO) —
   und dieser [all]-Default ist per §64 sogar ZIEL-Default (EINE vereinte Vollmengen-CEB). D.h.:
   EINE CEB mit der Vollmenge einkompiliert ist KEIN Interim, sondern Soll-Default; ein Verstoss
   entsteht erst, wenn Teilmengen-Lanen ([a,b,c]-Differenzierung) NICHT als eigene harte
   Kompilate/Codegen-Strecken, sondern per Laufzeit-Env in dieselbe Binary gelegt werden.
4) **Bauplan-Sequenzierung als einzige dokumentierte Stufungs-Erlaubnis:** BAUPLAN:183-184 + 244:
   FORK A original "kurzfristig vor Deadline evtl. nur die Vertragsform" — durch §30 VERSCHAERFT,
   aber "die Sequenzierung (Vertragsform zuerst, echte Generierung danach) bleibt
   Fork-C-Schnittfrage". Das deckt die .so-/Vertrags-FORM-Stufung, nicht eine Runtime-Konfiguration.

---

## B. WIRKLICH OFFEN

1. **Der Interim-Mechanismus selbst (Env akzeptiert vs. mindestens -D im emittierten ceb:build-Job)**
   ist im Korpus NICHT durch einen Owner-Entscheid beantwortet — exakt deshalb als Owner-Rueckfrage
   #4 registriert (LEDGER:4026; AUDIT synthese:116). Der Korpus liefert die Leitplanken (A9): kein
   Runtime-Konfigurieren der HAUPT-Wahl; explizite Interim-GOs noetig; [all]-Vollmengen-CEB ist
   zulaessiger (sogar Soll-)Default. Eine -D-Minimalform waere naeher am Kanon als Env (Wahl liegt
   dann im Kompilat + Stempel), ist aber nirgends als zulaessige Interim-Form ausgesprochen.
2. **Granularitaet der Generierung:** ob "GENERIERTE+kompilierte Binary je Messsystem" eigenen
   CEB-QUELLTEXT je [a,b,c] verlangt oder Codegen der Konfigurations-/Stempel-Traeger + harte
   Rekompilation des Treiber-Quelltexts je Messsystem genuegt, spezifiziert der Korpus nicht ueber
   die catalog_codegen.cmake-Blaupause (BAUPLAN:243) hinaus.
3. **Cache-Key-Einfaltung der Combo** (+mtool im MinIO-Key vs .version-Sidecar ohne; Combo aendert
   DLL-Bytes ohne Key-Wirkung) — als Klaerungs-Posten notiert, nicht entschieden
   (20260721-PLAN-46a:123; 20260801-DOSSIERS W-11:130).
4. Zeitliche Einordnung: der Planer-Binary-Split ist per F1 HARTES GO vor Abgabe (LEDGER:4032);
   ob die Fork-A-Haerte-Materialisierung in derselben Vor-Abgabe-Welle oder dahinter liegt, haengt
   an der Owner-Antwort zu (1).
