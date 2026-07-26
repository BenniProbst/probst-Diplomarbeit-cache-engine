# SESSION 26.07. — Layer-Modell-Antworten Q-A..Q-F + Stempel-Doktrin (KERN=Gesetz)

> Owner-Antworten auf die 6 offenen Layer-Modell-Fragen + neue Direktive. Persistiert wegen
> API-Instabilitaet. ALLES KERN=Gesetz. ASCII bis auf §.

## 0. NEUE DIREKTIVE
Regressions-Behebung R-A..R-F + STRUKT-R ist AUSDRUECKLICH meine (Fable/Manager-)Aufgabe
(Owner: "Dann ist es auch deine Aufgabe, die Regressionen zu beheben").

## Q-A — KLAMMERUNG + STEMPEL-DOKTRIN (zentral)
- **Achsen-Klammerung** = die Zuordnung der HAUPT-Achsen zu den 3 Achsen-Typen (Mess / System /
  Organ). Das ist der Sinn der [a,b,c][d,e,f][g,h,i]-Notation.
- **Unter-Achsen-Klammerung zu ihrer Haupt-Achse** ist in den BINARIES NICHT PRAESENT — nur als
  META-INFO in den xlsx-Dateien.
- **STEMPEL sind je ACHSEN-TYP gegliedert** und untergliedern sich je Typ in die HAUPT-Achsen,
  je Haupt-Achse EIN gewaehlter Algorithmus mit dessen EINDEUTIGER Versionsnummer.
- **Eine Binary hat KEINE eigene Versionsnummer** (fuer CEB und Tier-Binaries) — NUR der PLANNER
  hat eine eigene. CEB/Tier identifizieren sich AUS den gewaehlten Haupt-Achsen-Rekombinationen
  + deren Algorithmus-Versionierung.
- **Komplex-Achse:** traegt als REKURSIVE KLAMMERUNG die Haupt-Achsen, die sie wrappt (einfach
  Klammern um die anderen Haupt-Achsen-Klammern). Sie hat NUR eine INDIREKTE Identitaet ueber die
  gewrappten echten Haupt-Achsen (Command-Pattern) und formt EINEN gemeinsamen komplexen Stempel
  fuer ihre komplexe Achsen-Haupt-Klammer.
- Owner: "das ist schon genau geplant" -> ultracode-Suche in backups/sessions beauftragt.
  (Loest Q-A-Teil "ein Stempel oder N": Komplex-Achse = EIN gemeinsamer Stempel ueber die
  gewrappten Haupt-Achsen; die Glieder behalten ihre je-Achse-Klammer im Inneren.)

## Q-B — OS-EINBAU-FORM: Variante (i)
operating_system ist ein **4. Glied der EINEN Komplex-Achse** (target_isa x os x ext_hw x
MetaMetas). **ext_hw wird umbenannt zu `external_utils`** = Plug + Manager der Meta-Meta-Achsen;
dazu gehoeren: externe Hardware, AVX (Hardware-Erweiterung) UND das MESS-FRAMEWORK (stets ERSTER
Einbaukandidat). (external_utils = generalisierter Command-Pattern-Hub.)

## Q-C — OS-UNTER-ACHSEN: statisch (jetzt), RT vorbereitet
Die 4 OS-Werte (kernel_version, os_version, update_status, ...) sind ERSTMAL STATISCH (Variante
i / deklarativ). Kernel-Wechsel zur Laufzeit ist noch nicht moeglich, wird aber VORBEREITET.
**SPALTEN-SPARREGEL:** aendert sich eine Spalte in einem xlsx-Sheet / einer CSV NIE, wird sie
WEGGELASSEN (spart Speicher) -> stattdessen EIN Eintrag in die METADATEN.

## Q-D — REKURSIONS-TIEFE: formal rekursiv, unbegrenzt
Das Prinzip ist FORMAL REKURSIV. Beispiel: NVIDIA-GPUs als Cluster am PCIe (eine Meta-Meta-Achse
kann selbst Manager/Komplex-Achse sein -> Meta-Meta-Meta...). Kein festes 3. Level.

## Q-E — MITGLIEDSCHAFT: oberste Ebene wie vorgeschlagen, dann rekursiv je Layer
Per Q-D: Komplexbildung auf der obersten Ebene (target_isa x os x external_utils x MetaMetas),
dann REKURSIV je Layer-Unterteilung.

## Q-F — KOMPLEXBILDUNG generell gueltig
Solche Achsen gibt es noch nicht, aber das Konzept ist GENERELL GUELTIG und darf bei Erweiterung
UEBERALL (auch Mess-/Organ-Realm) zum Einsatz kommen.

## KONSEQUENZEN FUER STRUKT-R (Lane A/C Neuschnitt)
- Meta-Metas = VOLLE CT-Haupt-Achsen-Typen mit eigenen RT-Unter-Achsen (nicht Descriptor-Daten).
- Offene Rekursions-Tiefe: CebSubAxis-Concept NICHT auf System-Haupt fest-asserten; ein Concept
  fuer alle Achsen, Unter-Achse = Voll-Achse.
- Komplex-Achse = generischer rekursiver Wrapper (kein hartkodiertes "build_target_complex"-Label);
  Identitaet indirekt ueber gewrappte Glieder; EIN gemeinsamer Stempel.
- ext_hw -> external_utils (Hub; Mess-Framework als erster Meta-Meta-Kandidat).
- OS als 4. Komplex-Glied, 4 statische Unter-Achsen (RT vorbereitet), Spalten-Sparregel im Writer.
- Stempel-Struktur: je-Typ -> je-Haupt-Achse (Algorithmus + Version); Binary-Identitaet = Haupt-
  Achsen-Rekombination, KEINE eigene CEB/Tier-Version (nur Planner). Klammer der Unter->Haupt nur
  in xlsx-Meta, nicht in der Binary.
