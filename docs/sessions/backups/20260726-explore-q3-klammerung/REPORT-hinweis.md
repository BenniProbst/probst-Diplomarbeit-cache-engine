# Explore-Q3-Report: Montag-Klammerungs-Definition (26.07., via Agent-Message)

Der vollstaendige Report liegt im Session-Verlauf (Agent-Message Explore-Q3) und in der
Plaintext-Sicherung. KERN-ERGEBNISSE:

1. ERST-DEFINITION der Klammer-Notation: Nacht So 19.07. -> Mo 20.07. (§42 LEDGER:2339
   "Mess-Achse[a,b,c] -> ... System-Achsen [d,e,f] ... [d,e,f,g,h,i]Tier-Binary");
   geschachtelte Form d[d1,d2,d3] = §42.b LEDGER:2347; Stempel-Klammer §43 LEDGER:2353-2359.
   Kanonische 3-Typen-Festschreibung MONTAG 20.07.: §54-T1 (LEDGER:2715), §56 (LEDGER:2970
   "drei Gruppen: [a,b,c]=Mess . [d,e,f]=System . [g,h,i]=Organ"), §57-S3, §58 (LEDGER:3022
   Xa[Unter-k, Unter-l, Unter-m] als MESS-CSV-Stempel-Form).
2. ZWEI ORTHOGONALE KLAMMER-EBENEN: Typ-Klammern (Anzahl kodiert Ebene: CEB=1, Tier=2,
   Messung=3; LEDGER:3308-3310) + Haupt[Unter]-Verschachtelung.
3. GELTUNGS-ABGRENZUNG (§58): Haupt[Unter]-Klammer gilt fuer den VOLL-PERMUTATIVEN
   MESS-CSV-Stempel; BINARY-Stempel bleiben HAUPT-ONLY ("Unter-Achsen fliessen durch").
4. S2-EINORDNUNG: target_isa[scheduling] = exakte Anwendung der Montags-Notation; die
   Spannung "Unter-Zeilen im Binary-Stempel (S2) vs Haupt-only (§58)" ist durch die
   Owner-Q-A-Antwort AUFGELOEST: "Die Klammerung der Unter-Achsen zu ihrer Haupt-Achse
   ist in den Binaries NICHT praesent, nur als Meta-Info in den xlsx" -> §58-strenge Lesart.

KONSOLIDIERTE STEMPEL-END-FORM (Lane A-II, ersetzt die S2-Woertlichkeit):
- Binary-Stempel je Achsen-Typ, Array-Form, NUR die in DIESER Binary CT-einkompilierten
  (Haupt-)Achsen mit gewaehltem Algo + X.Y.Z (stufen-relativ: was hier CT ist, ist hier Haupt;
  §58-Transkript: "alle statischen Achsen, die compile time in Tier-Binary landen, sind im
  Stempel zu deklarieren").
- KOMPLEX-Klammer IM Stempel erlaubt und gefordert (Haupt-ueber-Haupt, rekursiv):
  complex[target_isa@X.Y.Z, os@X.Y.Z, external_utils[metameta1@..., ...]] = EIN gemeinsamer
  Stempel der Komplex-Achse (Q-A 26.07.).
- RT-Unter-Achsen (scheduling, OS-Werte, opt_level/atomic128 auf ihrer RT-Stufe) NIE im
  Binary-Stempel; voll-permutative Haupt[Unter]-Klammer NUR im Mess-CSV/xlsx (Name +
  Spalten + Spalten-Sparregel + Info-Sheet-Meta).
