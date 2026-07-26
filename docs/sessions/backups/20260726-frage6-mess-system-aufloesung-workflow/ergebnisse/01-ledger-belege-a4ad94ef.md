# 20260726-frage6-mess-system-aufloesung-workflow / ledger-belege (agent a4ad94ef)

runId: wf_3ed15f5c-7d7
agentId: a4ad94ef85ba06eb4
label-Zuordnung: ledger-belege (Prompt-Marker-Deckung 67%)

---

LEDGER = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (3424 Zeilen)

NEGATIV-BEFUND ZUERST (literal, grep ueber die ganze Datei):
- "kSystemAxisOrder" = 0 Treffer; "Sortierung"/"SORTIER" = 0; "Position 1" = 0; "Kaskade" nur
  als Fehler-/Flag-Kaskade (Z.471/500/555/603); "W-13" = 0; "Lane F" = 0; "R-A".."R-F" = 0;
  "external_utils"/"ext_hw"/"persistence_target" = 0; "target_isa" nur Z.2100/2101/2166/2657/1662.
  => Die bindende Achsen-SORTIERUNG (Mess=Position 1) und die R-A..R-E/W-13-Nomenklatur sind im
  Ledger NICHT verankert; sie leben ausschliesslich in den 26.07.-Plan-/Session-Docs. Der Ledger
  traegt aber die ZWEI-EBENEN-Substanz (Ordnung/Benennung vs. Steuerung) mehrfach explizit.

BELEGE, chronologisch nach Paragraph:

LEDGER:1467 (§16.2-M2/Q, 16.07.) "Systemachsen-Ebene -> FLACH als Ordnerstruktur (je Kombination
ein Ordner). Tier-Binary-Achsen + CSV-Messwerte -> serialisierter TIEFER Baum ... NUR dynamische
Unter-Achsen ... bleiben Spalten."
=> Aeltester Beleg, dass Lager/Verzeichnis eine EIGENE Ordnung ist (Ordner vs. Spalten), getrennt
von der Steuer-Zuordnung.

LEDGER:1488 (§16.2-Q3) "Q3 = additiv gespiegelt (Systemachsen-Ordner + Tag-Spalten resume-sicher,
spaeter deprecaten ...), Reihenfolge grob->fein Host->OS->Toolchain->ISA."
=> Der einzige Ledger-Satz, der eine VERZEICHNIS-Reihenfolge normiert: Ordnungs-Kriterium ist
grob->fein, nicht die Steuer-Verantwortung; Mess-Position-1 waere die konsistente Fortsetzung
(grobste Klammer zuerst), ist im Ledger aber nicht geschrieben.

LEDGER:1662 (SUPERSEDED-Vermerk -> §30) "heute 6 CT-System-Achsen (compiler/opt_level/simd/
target_isa/scheduling/load_framework) ueber 17 Organ-Achsen".
=> scheduling ist im Ledger eine EIGENE CT-System-HAUPT-Achse in der 6er-Liste, NICHT als
Unter-Achse von target_isa gefuehrt (R-B waere insoweit eine Neuerung gegenueber dem Ledger).

LEDGER:1663 (§18.3, LED:370-F2) "Scheduling (#37) = zunaechst SYSTEM-Achse, unter der die CEB
gebaut wird".
=> Stuetzt die F6-Formel "Kompilation, System und Scheduling": Scheduling ist System-Achsen-Seite
(CEB-Bau), nicht Planer/Mess-Seite.

LEDGER:1666 (§18.3) "Last/Last-Frameworks (H-9) = die Wahl der Lasten und Last-Frameworks ist
ebenfalls System-Achse in der CEB."
=> Zweite Haelfte von F6 "System": load_framework/Scheduling gehoeren zur Binary-Basics-Stufe.

LEDGER:2040 (§24.C) "die dynamische Einstellung der Vorstufe ist oft der compile-time-Draht der
gebauten Folgestufe. => 'statisch/dynamisch' ist stufen-relativ".
=> Das generische Zwei-Ebenen-Gesetz: dieselbe Achse hat je Stufe verschiedene Rolle - Grundlage
dafuer, dass Lager-Ordnung und Steuer-Verantwortung sich nicht widersprechen muessen.

LEDGER:2150 (§28) "immer eine Haupt-Achse (statisch im Ziel-Binary) auch optionale Unter-Achsen-
Einstellungen (meist dynamisch im Ziel-Binary). Jede der 3 Achsen-Arten braucht ihre EIGENE
Registry in IHREM Modul per XML."
=> Drei Achsen-TYP-Registries als Angebot; die Typ-Trennung ist eine Modul-/Angebots-Ordnung,
keine Aussage ueber Verzeichnis-Rang.

LEDGER:2179 (§30, 19.07.) "Die Mess-Achsen-Permutation wandert von der CEB in den PLANER ... Daraus
ergibt sich die Stufen-Zuordnung: Planer = Mess-Achsen . CEB = System-Achsen . Tier-Binaries =
Organ-Achsen - + Hybrid-Einschub".
=> Der Ur-Beleg der VERANTWORTLICHKEITS-Trennung, die Owner-F6 26.07. nur wiederholt (Mess raus
aus der CEB); F6 ist damit keine Neuerung, sondern §30 verbatim.

LEDGER:2183 (§30) "die DREI Achsen-Art-Registries speisen exakt die drei Binary-Stufen -
Mess-Registry->Planer . System-Registry->CEB . Organ-Registry(+prt)->Tier."
=> 1:1-Zuordnung Typ->Stufe: kSystemAxisOrder darf demnach nur System-Achsen enthalten, Mess
gehoert in den Planer-Satz.

LEDGER:2186 (§30) "EIN Baum mit AxisKind-gefaerbten Ebenen + Filter-/Zerlege-Operation je
Achsen-Art (Organ-Teilbaum->binary_id ...; System-Teilbaum->CEB-Kompilation; Mess-Teilbaum->
Planer-Permutation)."
=> EIN Gesamtbaum (eine Ordnung) + typ-weise Zerlegung (Verantwortung) - genau die im Fragetext
vermutete Zwei-Ebenen-Lesart, hier bereits Ledger-Gesetz.

LEDGER:2266 (§37.4) "Die Freigabe betrifft NUR statische System-HAUPT-Achsen - NICHT die
dynamischen System-UNTER-Achsen, die (wie etwa Threads) als Runtime-Variable an die Tier-Binaries
... durchgereicht werden."
=> Scheduling-nahe Groessen (Threads) sind als UNTER-Achse runtime-durchgereicht; eine
Scheduling-Unter-Achse unter einer System-Haupt-Achse ist ledger-konform.

LEDGER:2339 (§42, User verbatim) "Mess-Achse[a,b,c] -> [a,b,c]CEB-Typ -> CEB definiert
System-Achsen [d,e,f] -> ... -> [d,e,f,g,h,i]Tier-Binary".
=> Die kanonische KETTEN-/BENENNUNGS-Ordnung beginnt mit der Mess-Klammer [a,b,c] an Position 1 -
das ist der naechstliegende Ledger-Beleg fuer "Mess = Position 1" als NAMENS-/Legenden-Ordnung.

LEDGER:2347 (§42.b) "[d,e,f,g,h,i] benennt nur die HAUPT-Achsen ... Die Laufzeit-Parameter werden
immer von ihrer Haupt-Achse freigegeben."
=> Bau-/Namens-Legenden tragen ausschliesslich Haupt-Achsen; Unter-Achsen nie im Verzeichnis-/
Job-Namen.

LEDGER:2355 (§43) "Die Tier-Binaries haben ihren string_view-Versionierungs-Stempel ueber die
[d,e,f][g,h,i]-Kombination in 2 verschiedenen string_view-Zeilen: eine fuer System-Achsen und eine
fuer Organ-Achsen".
=> Stempel-Ordnung am Tier: System vor Organ, Mess NICHT im Tier-Stempel.

LEDGER:2359 (§43) "CEB = kMeasurementAxisVersionLine ([a,b,c], vom Planer bei der CEB-Generierung
einkompiliert). Nur HAUPT-Achsen."
=> Die Mess-Stempel-Zeile sitzt an der CEB, gesetzt vom Planer: Stempel-Traeger CEB, Steuer-Owner
Planer - Zwei-Ebenen auch im Stempel.

LEDGER:2410 (§47, User verbatim) "Haupt-Achse ist das sogenannte Mess-Tooling ... deren Unter-Achse
ist Debug vs Messen vs Release ... Unter-Achsen, weil sie an die CEB delegiert werden".
=> Mess-HAUPT = Tooling; die Delegation an die CEB ist Ausfuehrung, nicht Eigentum.

LEDGER:2413 (§47) "Jede Tooling-Wahl = eine eigene hart kompilierte CEB = eine eigene
ceb:build:[a,b,c]-Strecke. Diese Wahl traegt den kMeasurementAxisVersionLine-Stempel (§43)."
=> Mess-Achse ist die AEUSSERSTE Auffaecherung der Kette (spaeter durch §64 auf Default=Vollmenge
korrigiert, s.u.) - Grund, warum sie in Legende/Lager vorne steht.

LEDGER:2721 (§54-T4) "Der Permutations-Baum ist je ACHSEN-TYP, nicht je Gattung ... Organ-Baum /
System-Baum / Mess-Baum."
=> Lager-Baeume sind typ-getrennt; eine typ-gemischte Kaskade waere ein T4-Bruch.

LEDGER:2726/2727 (§54-T6) "STUFE 1 (CiYamlBuilder, Planer-Rolle, Mess-Achsen-Stufe): ceb:build:
[a,b,c] ... [a,b,c] = Mess-Tooling-HAUPT." / "die Mess-Achse gehoert NICHT in die Tier-Build-
Legende - sie IST die CEB."
=> Kern-Antwort auf die Frage: Mess steht als Stufe-1-Klammer VORNE (Ordnung), darf aber in der
Tier-Build-Legende (System x Organ) NICHT auftauchen (Verantwortung) - kein Widerspruch, zwei
Ebenen, im Ledger explizit.

LEDGER:2995 (§57, User verbatim) "Bei der CEB sind System-Achse und Organ-Achse noch runtime und
die Mess-Achse fest einkompiliert ... Die CEB hat ihren eigenen Typ+Versions-Stempel ueber die
Mess-Achse des Planers."
=> Mess ist an der CEB Identitaet (eingefroren), System/Organ sind dort Bau-Raum: erklaert, warum
Mess die aeussere Klammer/Lager-Wurzel bildet.

LEDGER:3009/3010 (§57-S3) "Tier-Binary-Stempel (Typ + Version) = System-Achse x Organ-Achse" /
"binary_id bleibt Organ-only ... Zwei Stempel-Ebenen: CEB=Mess, Tier=System x Organ."
=> Stempel-/Suffix-Ordnung final: Mess nur auf CEB-Ebene, Tier = System dann Organ.

LEDGER:3021 (§58-V) "TIER-BINARY: KEINE Gesamt-Versionierung. ZWEI SEPARATE Array-Versionierungen:
eine fuer die System-Achse, eine fuer die Organ-Achse ... Nur HAUPT-Achsen im Stempel."
=> Reihenfolge und Inhalt der Tier-Stempel-Arrays: System-Array zuerst, Organ-Array danach.

LEDGER:3022 (§58-V) "MESS-CSV ...: der VOLL-PERMUTATIVE Stempel. Fuer ALLE Messwert-Abschnitte muss
mindestens die CSV-BENENNUNG ALLE Haupt-Achsen UND Unter-Achsen als Kurzform-Legende mit
Versionierung ... tragen ... Das ist der einzige Ort mit voll-permutativer Identitaet."
=> Explizit: BENENNUNG (Lager) traegt mehr als der Binary-Stempel - Benennungs-Ordnung und
Steuer-/Stempel-Ordnung sind im Ledger bewusst VERSCHIEDENE Ebenen.

LEDGER:3059 (§59-C) "STEMPEL - DRITTER Tier-Binary-Stempel: ... ein dritter Tier-Binary-Stempel =
die Merge-Kombination - ZUSAETZLICH zu den zwei §58-Arrays."
=> Tier traegt drei Arrays (System, Organ, Merge); Mess bleibt aussen vor.

LEDGER:3063 (§59-D) "Jede Stufe stempelt aus derselben Anatomy-Vorlage ihren stufen-eigenen
Achsen-Satz (Planer=Mess X.Y.Z . CEB=Array je Mess-Haupt-Algo . Tier=System-Array + Organ-Array +
Merge-Kombination)."
=> "Stufen-eigener Achsen-Satz" ist die praeziseste Ledger-Formel fuer die Frage nach dem Inhalt
von kSystemAxisOrder: pro Stufe genau ihr Typ-Satz, nichts fremdes.

LEDGER:3243-3245 (§62-D, User-bestaetigte Tabelle) "CEB-Binary | Mess-Achse [a,b,c] | Planer" /
"Tier-Binary | System-Achsen [d,e,f] ALLEIN | CEB" / "Messwerte | [d,e,f] UND [g,h,i] GEMEINSAM +
Maschinen-Hardware-Identitaet | messende Maschine".
=> Drei getrennte Replay-/Lager-SCHLUESSEL je Schicht: die Mess-Klammer keyt NUR die CEB, nie das
Tier - harte Grenze fuer jede Lager-Kaskade.

LEDGER:3308-3310 (§62-B-NACHTRAG, Testat-Grammatik, 22.07.) "Batch-/CEB-KOPF (einmal je
Batch-Job): CEB-Identitaet [a,b,c] (Mess-Achsen, Stufe 1) + lane=<host>. Die [a,b,c] steht NICHT je
Schritt - sie ist die CEB-Ebene." / "BAU-/PRUEF-Testat je Schritt ...: zelle=[d,e,f][g,h,i]" /
"NUR die Mess-Ebene traegt alle drei Klammern".
=> Der direkteste Ledger-Beleg fuer die gesuchte Aufloesung: die Mess-Klammer steht ganz OBEN/VORN
als Kopf-/Wurzel-Ordnung (einmal je Batch, Lager-/Log-Wurzel), waehrend die STEUERUNG je Schritt
System x Organ ist - genau "Lager-/Benennungs-Ordnung vs. Steuer-Verantwortung".

LEDGER:3311 (§62-B-NACHTRAG, User-Korrektur 22.07.) "Tier-Binary = ZWEI STRIKT GETRENNTE LAYER,
NIE verschmolzen ... Die §42-Schreibweise [d,e,f,g,h,i] ist reine NAMENS-AUFZAEHLUNG der
Haupt-Achsen im Binary-Namen, KEINE Achsen-Verschmelzung."
=> Wortgenaue Unterscheidung NAMENS-Aufzaehlung vs. Struktur/Verantwortung - dieselbe Zwei-Ebenen-
Logik, vom User selbst gezogen; Vorbild fuer die Mess-Position-1-Lesart.

LEDGER:3312 (§62-B-NACHTRAG) "Bestandslog-Schluessel GETRENNT (Nachtrag-4): [a,b,c] -> CEB-Binary-
Replay . [d,e,f] ALLEIN -> Tier-Binary-Replay . [d,e,f]+[g,h,i] GEMEINSAM + Hardware-Identitaet ->
Messwert. Die Testat-Grammatik speist diese drei Schluessel - deshalb ist die Ebenen-Trennung
PFLICHT."
=> Lager-Kaskaden sind ebenen-rein zu bilden; Mess als Wurzel-Klammer ok, aber niemals in den
Tier-Bau-Schluessel gemischt.

LEDGER:3276 (§64-GESETZ, 22.07.) "STEHT DAZU NICHTS IN DER XML: alle 3 Verfahren in der CEB
GEMEINSAM abgebildet per METAPROGRAMMIERUNG, und das PRUEF-DOCK nimmt alle 3 Features vom
Tier-Binary GEMISCHT ab."
=> Default = EINE CEB mit Tooling-MENGE; die Mess-Klammer faechert per Default NICHT auf, ist also
im Regelfall eine EIN-elementige Wurzel der Lager-Kaskade (kein Fan-out-Zwang).

LEDGER:3293-3295 (§64-SCHICHTEN-ZUORDNUNG, User 22.07.) "Wallclock wird auf der CEB-SEITE gebaut/
erhoben" / "Makro- und Micro-Benchmarking muss durch CEB UND TIER-BINARY einkompiliert ueber das
PRUEFDOCK unterstuetzt werden" / "Die CEB richtet die Mess-Einrichtung ihres Tier-Binary-Prueflings
aufgrund IHRER statischen compile-time Mess-Achsen-Ausrichtung (die der PLANER-Mess-Achse folgt)
AUCH AUF DEM TIER-BINARY aus".
=> Die Mess-Achse WIRKT bis ins Tier (Observer), ohne dort eine Achse zu sein: ein durchgereichter
statischer Draht - genau der Grund, warum Mess ordnungs-relevant, aber nicht Tier-Achse ist.

LEDGER:3331 (§65-KERN a) "Der Matrix-Forecast gehoert IMMER auf die Lager: Binaries -> ccache/minio
(Ebene B ...), Messergebnisse -> PR4100 Cluster_NFS/cache-engine-experiment (Ebene C ...)."
=> Lager-Realms sind nach ARTEFAKT-Art getrennt (Binaries vs. Messergebnisse) - stuetzt zwei
Realm-Wurzeln in den Lager-Baum-Kaskaden.

LEDGER:3412 (§66-NACHTRAG-3, KERN=Gesetz, 23.07.) "ALLE Achsen sind IMMER getrennt zu behandeln und
zu KLAMMERN (keine Fusion in Signaturen/Schluesseln/Stempeln - je Achse ihr eigenes Feld/ihre
eigene Klammer)."
=> Bindender Schluss-Satz fuer Stempel-/Suffix-/Lager-Ordnung: Ordnung darf umsortieren, aber
niemals fusionieren; Mess bleibt eigene Klammer, System und Organ je eigene.

LEDGER:3409 (§66-NACHTRAG-3) "ERLAUBT: verschiedene RUNTIME-Varianten der UNTER-Achsen auf dieselben
COMPILE-TIME-HAUPT-Achsen (§59-Haupt/Unter-Prinzip). Die REGISTRY entscheidet, wie zu bauen ist."
=> Eine scheduling-Unter-Achse unter einer System-Haupt-Achse ist mapping-rein (runtime->runtime);
sie darf keine runtime->compile-time-Bruecke werden.
