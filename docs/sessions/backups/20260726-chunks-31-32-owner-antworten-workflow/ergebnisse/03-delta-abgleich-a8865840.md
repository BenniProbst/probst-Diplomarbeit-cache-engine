# 20260726-chunks-31-32-owner-antworten-workflow / delta-abgleich (agent a8865840)

runId: wf_dd62751f-cd7
agentId: a886584083a6e7685
label-Zuordnung: delta-abgleich (Prompt-Marker-Deckung 50%)

---

DELTA-REPORT DOSSIER vs. OWNER-WORTLAUT (Chunk 31 + 32). Zitate aus Chunk 32 transliteriert (ASCII-Pflicht). Reihenfolge: schwerste zuerst.

D-01 REGRESSIONEN VOR DEM VOLL-BAU (haerteste Kollision)
(1) A17: "Das Design und die Regressionen muessen vor dem voll Build und der voll Messung fest behoben und eingebaut sein." + A19: "nach dem der Plan an die korrekten Stellen vor dem Voll-Build eingeschoben ist".
(2) Dossier 5. sagt gegenteilig: Lane C IDENT/external_utils-HUB "byte-neutral, inert, Scharfschaltung erst nach Trigger"; Board #5 fuehrt "external_utils-Rename-Restweg" in Band C (also NACH dem Trigger). R-F (SIMD/AVX als Meta-Meta) hat gar keine Lane vor dem Trigger.
(3) UNGEPLANT: entweder Scharfschaltung von Lane C + Rename + R-F-Materialisierung VOR dem Trigger einplanen, oder eine ausdrueckliche Owner-Ausnahme einholen. Aktuell wuerde Voll-Bau-4 auf teil-inertem Design laufen = Regression nach Owner-Definition.

D-02 PMC-GATE FEHLT VOLLSTAENDIG
(1) B10/B11: "reaktiviere das pmc:intel, sobald es sich um einen Intel CPU vendor handelt, trage die Antwort als festes TODO ein zu PMC ... Ist dieser gitlab runner filter gesetzt? Beide muessen fuer den Erfolg der Pipeline hart gesetzt und erfolgreich sein, bevor eine Lane einer Maschine den gesamten Strang abarbeiten darf" + "VERFUEGBARKEIT xor ... Die Pipeline auf Condare fuer pmc Test ist AND".
(2) FEHLT: kein Wort zu pmc:amd/pmc:intel, Runner-Filter, AND/XOR-Doktrin - weder in 2., 9. (Board) noch im TRIGGER-REZEPT/AUFLAGEN.
(3) UNGEPLANT: PMC-Preflight als hartes Trigger-Gate, Runner-Filter-Verifikation, XOR-Verfuegbarkeits-Logik fuer Fremd-Cluster (Verschiffbarkeit), festes PMC-TODO aufs Board.

D-03 DEFINITION DER MONTAGS-ABGABE
(1) A10-P6: "Die ersten Messergebnisse werden rechtzeitig auf dem NAS landen, um das Prinzip und die Genauigkeit zu beweisen. Latex und PDF werden aufgrund des Durchlaufes und der Auswertung dann danach entwickelt. Prof. Habich reicht es die ersten Mess-CSV eintreffen zu sehen".
(2) Dossier 0.5: "Frist Mo 27.07. = ZWISCHEN-Abgabe (Gruendlichkeit vor Termin)" ohne Artefakt-Definition; "Voll-Messung 2^17 ab 01.08."; Board #5 listet S8 PDF DE+EN in derselben Band-Aufzaehlung wie Vor-01.08.-Punkte.
(3) UNGEPLANT: kein Plan-Schritt erzeugt bis Montag EINE echte Mess-CSV am Ziel. Es fehlt ein kleiner Mess-Beweis-Lauf (oder eine bewusste Owner-Neuverhandlung der Frist) und die Reihenfolge-Fixierung "PDF erst nach Auswertung".

D-04 NAS-ZIELPFAD UND LOKALER FUSSABDRUCK
(1) B2: "der Matrix forecast sollte doch immer auf ccache fuer die binaries und auf PR4100 Cluster_NFS experiment-ordner immer die Messergebnisse geschrieben werden? Der forecast auf der Maschine selbst sollte daher gegen null gehen".
(2) Dossier 3.7 nennt "NAS" nur abstrakt; TRIGGER-AUFLAGEN sichern nur COMDARE_MINIO_ENDPOINT gegen die mc-Falle. Kein PR4100/Cluster_NFS-Pfad, keine Null-Fussabdruck-Regel.
(3) UNGEPLANT: NAS-Endpoint-Preflight (gleiche Silent-local-write-Falle wie minio), expliziter Experiment-Ordner-Pfad in der Doktrin, df-Wache auf "lokal gegen null".

D-05 BESTANDS-INVALIDIERUNG + MESS-SEITIGE FORTSCHREIBUNG
(1) A10-P2: "Der Haupttreiber muss laufen, der Bestand wird schliesslich invalidiert und neu gebaut ... Das Bestandslog wird selbstverstaendlich beim Build UND beim Messen je Realm gepflegt und fortgeschrieben".
(2) Dossier: Bestandslog AN im Trigger; Mess-Realm-Writer steht in Board #5 unter "Phase-4 vor 01.08." - also erst nach dem Trigger; ein Invalidierungs-Schritt existiert nirgends.
(3) UNGEPLANT: (a) definierter Invalidierungs-/Neu-Inventarisierungs-Schritt des Prototyp-Bestands vor Voll-Bau-4 (Bezug A-2 "Re-Open=Ast-Neu-Inventarisierung"), (b) Mess-Realm-Fortschreibung muss VOR dem 01.08.-Messstart stehen, nicht danach.

D-06 MAIN-NACHZUG AUF BEIDEN REMOTES
(1) A3: "commit und push mal auf development und beide remotes und ziehe mal main nach (auch auf remote)".
(2) Dossier 11. Schritt 3 endet bei "Dual-Push ... -> CI beobachten"; 2. nennt nur "main Vorfahr von development".
(3) UNGEPLANT: je Welle ein expliziter main-Fast-Forward + Push auf gitlab UND github; sonst bricht die vom Owner gepruefte dev==main-Eigenschaft nach der Join-Welle.

D-07 CI-AUFGABEN VOR BUILD-NEUSTART
(1) B4: "Es gab einen Haufen Aufgaben in der CI, die erledigt werden muessen, bevor der Build nochmal starten kann, sonst riskieren wir Binary-Verlust".
(2) Dossier Board #5 fuehrt "CI-Wartung" in Band C = nach dem Trigger; vor dem Trigger stehen nur 3 AUFLAGEN (minio, keine Parallel-Jobs, Facade).
(3) UNGEPLANT: Auflistung+Abschluss der CI-Restpunkte als Trigger-Vorbedingung oder belegte Aussage, dass das Lager-Gate den Binary-Verlust-Pfad vollstaendig deckt.

D-08 NEUER GITHUB-PAT
(1) B23: "ein neuer github PAT muss durch Cluster git aus dem cred vault gezogen werden, der PAT ist neu".
(2) Dossier 1. SECURITY beschreibt nur den glpat-Zugriff; github wird als "flache Out-of-House-Sicherung" gefuehrt, ohne Credential-Schritt.
(3) UNGEPLANT: Vault-Pull des neuen github-PAT vor dem naechsten Dual-Push; sonst scheitert die github-Haelfte der Join-Welle.

D-09 POSITION VON load_framework
(1) A16: "load_framework ist in der CEB korrekt am Ende angesiedelt aber stets die erste Meta-Meta-Achse"; A17: "wir haengen hinten an (hinter load_framework wenn vorhanden on/off)".
(2) Dossier R-C nennt load_framework nur als Meta-Meta (Messung optional); 3.1 hat keinen load_framework-Slot; 3.7 sagt bloss "Meta-Metas hinten". Die Doppelregel "letzte Position in der CEB / erste Meta-Meta" fehlt, ebenso das on/off-Token im Ordner-/Metadaten-Namen.
(3) UNGEPLANT: Ordnungs-Single-Source (kSystemAxisOrder) und die Meta-Meta-Array-Reihenfolge fuer Lane A sind damit unterspezifiziert; Namens-Generator kennt das on/off-Segment nicht.

D-10 OS-UNTER-ACHSEN-SATZ IST OFFEN, NICHT DREI
(1) A16: "Unter-Achsen von OS sind die OS Version,Kernel,Build und Update Zustand"; 1.10: "Kernel Version, OS Version, Update Status und so weiter".
(2) Dossier R-A fixiert genau drei: "os_version, kernel, build/update_status" (Build und Update verschmolzen), ohne Erweiterbarkeits-Vermerk.
(3) UNGEPLANT: Lane A muss den OS-Unter-Achsen-Satz XML-erweiterbar bauen; 3-vs-4-Aufteilung (Build separat?) ist eine offene Owner-Rueckfrage.

D-11 SCHREIBWEISE DES RENAME-ZIELS
(1) 1.9 wortgenau: "sollte besser extermal_utils heissen".
(2) Dossier schreibt durchgehend "external_utils" (3.1, 3.4, 5., Board #5) - die Tippfehler-Korrektur wurde nie vom Owner bestaetigt.
(3) UNGEPLANT: Ein-Zeilen-Bestaetigung vor Lane C. Ein repo-weiter Rename auf die falsche Schreibweise ist teuer rueckabzuwickeln.

D-12 MITTLERE EBENE DES BINARIES-LAGERS
(1) A17: "die Lagerhaltung der Binaries [hat] direkt die System-Achse als Wurzel und fuehren die Mess-Achse nicht ganz intuitiv hinter System-Achse UND Organ-Achse ein als letzter und tiefster Haupt-Achsen-Typ".
(2) Dossier 3.7 verkuerzt auf "BINARIES-Lager: System-Wurzel; Mess-Typ als tiefster Haupt-Achsen-Typ" - die Organ-Ebene in der Mitte fehlt.
(3) UNGEPLANT: Pfad-Spezifikation System -> Organ -> Mess fuer den Binary-Lager-Writer; sonst entsteht System -> Mess -> Organ.

D-13 N:1-LIZENZ RT-UNTER ZU CT-HAUPT
(1) B13: "Ansonsten sind verschiedene runtime Varianten der Unter-Achsen auf dieselben compile time Haupt-Achsen erlaubt."
(2) Dossier 2. nennt nur die Verbots-Haelfte ("nur CT->CT und RT->RT"); die Erlaubnis-Haelfte ist nicht notiert.
(3) UNGEPLANT: Diese Lizenz ist die Begruendung fuer "ein Sheet je Unter-Achsen-Permutation" und fuer mehrere Messungen je Binary (A11) - fehlt sie im Regelwerk, kann ein Agent die Mehrfach-Permutation als Verstoss gegen die Mapping-Reinheit ablehnen.

D-14 DAUERHAFT OFFENER PUNKT 2.4-(8)
(1) Chunk 32, Abschnitt C, Z.460 (Owner-Frist, Wortlaut verloren): 2.4-(8) ist "VOR-01.08.-Pflicht, wird NIE als erledigt gefuehrt".
(2) Dossier kennt Vor-01.08.-Punkte (Board #5, ABNAHME-6 Claim-Check), aber keinen "wird nie geschlossen"-Marker.
(3) UNGEPLANT: Board-Flag "permanent offen" fuer 2.4-(8); sonst wird der Punkt bei der naechsten Bereinigung faelschlich abgehakt.

D-15 PROVENIENZ-UEBERZEICHNUNG
(1) Chunk 31 Dateiende: die Abnahmen nach Z.1448 wurden im Log NICHT mehr beantwortet; Chunk 32 Abschnitt C: A-1/A-2, Q-0/Q-1/Q-4/Q-13-Bilanz, R-F-Ursprung, "Haertung vom 26.07.", 2.4-(8) existieren NUR als Assistenten-Referat.
(2) Dossier 0.3 behauptet absolut: "ALLE Owner-Entscheide des Tages sind eingeholt und persistiert" und fuehrt sie in 6. wie Wortlaut.
(3) UNGEPLANT: Diese Posten als paraphrase-basiert kennzeichnen und die tragenden (Q-1 enabled=false, A-1 Truncate-Regel, R-F, CT/RT-XOR-Haertung) mit einem Satz rueckbestaetigen - sie sind Byte- und ABI-relevant.

D-16 (Grenzfall) OWNER-VERFUEGBARKEIT ALS ARBEITSREGEL
(1) A6: "Ich stehe den gesamten Tag fuer Rueckfragen zur Verfuegung"; A9: "Bitte stelle mir Rueckfragen und Entscheidungen zu den gefundenen Stellen".
(2) Dossier 2. hat nur "Task-Zuweisung ist KEIN Start-Signal; Gegenvorschlag zuerst" - keine Pflicht, gefundene Entscheidungsstellen sofort als Vorlage zu buendeln.
(3) UNGEPLANT: Regel "jede gefundene Entscheidungsstelle wird noch am selben Tag als Vorlage gestellt, nicht geparkt" - sonst sammeln sich stille Annahmen (genau die Ursache von R-A..R-F).

D-17 (Grenzfall) FUENFTES REPO / THESIS-KLON
(1) B22: "Den thesis clon brauchst du aber unter der Diplomarbeit um nachher die latex Diagramme einzubauen, bitte pull das mit doppel remote in die super/external Projekte und nach Projekte/Research".
(2) Dossier 1. nennt "4 Diplom-Repos", verlangt aber git-config "in ALLEN 5 Repos" - das fuenfte wird nie benannt, der Dual-Remote-Auftrag fuer den thesis-Klon fehlt.
(3) UNGEPLANT: Existenz/Remotes des thesis-Klons an beiden Orten verifizieren; Board #2 (overleaf-Merge + Gitlink) setzt ihn voraus.

Selbstcheck: 7-Bit-ASCII geprueft (keine Umlaute, keine Gedankenstriche, keine Unicode-Pfeile); Dossier vollstaendig gelesen (349/349 Zeilen); alle Owner-Passagen A1-A21, B1-B27, Chunk-32 1.1-1.14/Passage-2/B-1/B-2 und Abschnitt C einzeln gegen das Dossier geprueft; 17 Deltas, davon 2 als Grenzfall markiert; kein Report-File geschrieben.
