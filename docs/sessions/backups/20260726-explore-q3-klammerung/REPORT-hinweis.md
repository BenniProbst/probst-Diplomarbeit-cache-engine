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

KONSOLIDIERTE STEMPEL-END-FORM (Lane A-II) — KORRIGIERT 26.07. (Owner: "Die Stempel-End-Form
ist falsch, weil im Plan und den memory direktiven immer die strikte Trennung der Achsen-Typen
verlangt ist. Da fehlen klare Klammern"):

DREI-STUFIGE KLAMMER-HIERARCHIE, die TYP-Klammern sind die OBERSTE, STRIKT GETRENNTE Struktur
(§56 drei Gruppen; §57-S3 zwei Stempel-Ebenen; §66-N3 je Achse ihre eigene Klammer; Testat-
Grammatik LEDGER:3308-3310 Klammer-Anzahl kodiert die Ebene):

  Ebene 0  BINARY-KLAMMER (Owner-Praezisierung 26.07., "ganz wichtig"): die Binary selbst
           ist eine AEUSSERE Klammer ueber ihre Typ-Klammern (Komma-getrennt, nie
           verschmolzen — die Rekursion geht bis zur Binary-Ebene durch):
             System-Achsen [d,e,f] -> [[d,e,f],[g,h,i]]Tier-Binary
             CEB = [[a,b,c]]CEB (eine Typ-Klammer)
             Mess-CSV analog ueber alle drei: [[a,b,c],[d,e,f],[g,h,i]]
  Ebene 1  TYP-KLAMMER (je Typ eigene Klammer, nie verschmolzen):
           CEB-Stempel   = [a,b,c]-Klammer (Mess-Typ)
           Tier-Stempel  = [d,e,f]-Klammer (System-Typ) GETRENNT VON [g,h,i]-Klammer (Organ-Typ)
                           = zwei separate Zeilen/Arrays (§58), gemeinsam nur durch die
                           Ebene-0-Binary-Klammer umschlossen
  Ebene 2  KOMPLEX-KLAMMER (rekursiv, NUR INNERHALB ihrer Typ-Klammer): Klammern um die
           Haupt-Achsen-Klammern, die sie wrappt; EIN gemeinsamer Stempel-Block mit
           indirekter Identitaet. Beispiel System-Typ-Zeile:
             [d,e,f] = [ complex[ [target_isa@X.Y.Z] [os@X.Y.Z]
                                  [external_utils[ [avx512@X.Y.Z] [gpu@X.Y.Z] ... ]] ] ]
           (external_utils klammert seine Meta-Meta-HAUPT-Achsen rekursiv; jede Haupt-Achse
           behaelt IHRE eigene Klammer + Algo@Version.)
  Ebene 3  HAUPT-ACHSEN-KLAMMER: je Haupt-Achse eigene Klammer mit gewaehltem Algorithmus +
           eindeutiger X.Y.Z (Array-Form je Typ, §58; keine Gesamt-Version fuer CEB/Tier,
           nur der Planner hat eine eigene).

- Stempel-Inhalt stufen-relativ: NUR die in DIESER Binary CT-einkompilierten (Haupt-)Achsen
  (§58-Transkript: "alle statischen Achsen, die compile time in Tier-Binary landen, sind im
  Stempel zu deklarieren").
- RT-Unter-Achsen (scheduling, OS-Werte, opt_level/atomic128 auf ihrer RT-Stufe) NIE im
  Binary-Stempel; die Haupt[Unter]-Voll-Klammer (Xa[Unter-k,...]) NUR im Mess-CSV/xlsx
  (Name + Spalten + Spalten-Sparregel + Info-Sheet-Meta).
- NIE typ-uebergreifend klammern: die Komplex-Klammer darf nur Haupt-Achsen DESSELBEN
  Achsen-Typs wrappen (Q-E "in derselben Kategorie"); [d,e,f] und [g,h,i] bleiben auch im
  Tier-Stempel zwei getrennte Zeilen, [a,b,c] gehoert dem CEB.
