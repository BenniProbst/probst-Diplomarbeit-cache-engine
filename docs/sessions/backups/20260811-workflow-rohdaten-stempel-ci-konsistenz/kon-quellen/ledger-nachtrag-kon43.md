## NACHTRAG 12.08.2026 — KON43: OWNER-FESTLEGUNG — VIER TRÄGER-UNTERPROJEKTE, BAU STRIKT IN STUFENREIHENFOLGE, MONOLITH-SPLIT BEIM AUFRÄUMEN

**Owner verbatim 12.08.2026:**

> *„Ich lege weiterhin hiermit fest, dass wir **erst den Planer aufbauen, dann die CEB, dann
> die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht anders.** Im Projekt der
> cache engine brauchen wir also **4 unter-Projekte die in Träger-stufenform aufeinander
> aufbauen**. Wir **splitten den aktuellen Monolithen falls noch nicht erfolgt in
> übersichtliche Ordnerstrukturen beim Aufräumen**."*

---

### KON43-01 — DIE DREI FESTLEGUNGEN

    (1) BAU-REIHENFOLGE, VERSCHAERFT ("nicht anders"):
        PLANER -> CEB -> TIER-BINARIES -> HYBRID.
        Bekraeftigt KON30-03 (Traeger-Stufen-Reihenfolge, Planer zuerst) und macht sie
        AUSNAHMSLOS: kein Ketten-Bau an einer hoeheren Stufe, bevor die niedrigere steht.
        (Die STEMPEL-Strecke S-1..S-7 ist QUERSCHNITT der Identitaet aller Traeger und
        speist den Planer zuerst -- version_xyz() ist ein Nur-Planer-Interface, KON7-04;
        sie widerspricht der Reihenfolge nicht, sie bedient sie.)

    (2) 🔴 VIER UNTER-PROJEKTE im cache-engine-Projekt:
        je Traeger EIN Unter-Projekt (Planer · CEB · Tier · Hybrid), die IN
        TRAEGER-STUFENFORM AUFEINANDER AUFBAUEN -- die Projektstruktur bildet die
        Kette ab (Stufe N+1 haengt nur von Stufe N ab, nie umgekehrt).

    (3) MONOLITH-SPLIT BEIM AUFRAEUMEN:
        der heutige ce-Monolith (libs/cache_engine mit planner/builder/anatomy/hybrid/
        mess/axes in EINEM Baum) wird -- falls noch nicht erfolgt -- in uebersichtliche
        Ordnerstrukturen gesplittet, ALS TEIL DER AUFRAEUM-AUFGABE (Konsolidierungs-
        Architektur #88; dockt an das Home-Prinzip KON27-01 an: Achsen-Homes ordnen
        die KATEGORIEN, die Unter-Projekte ordnen die TRAEGER -- zwei orthogonale
        Ordnungen derselben Ziel-Struktur).

### KON43-02 — KONSEQUENZEN FÜR DIE STRECKE

* **Zielform-Pflicht ab sofort** (Arbeitsprinzip KON11-01: „in der Zielform aktivieren"):
  **S-8 (Planer-Kopf) und S-9 (CEB-Generierung) bauen in die Vier-Unterprojekt-Zielform**,
  nicht in den Monolithen — die Ziel-Ordnerstruktur wird VOR dem S-8-Bau (W2) geschnitten
  (kleiner Design-Posten im WE-Fenster; kein Preimage-Bezug, aber Include-Kanten →
  Abstimmung mit S-6d/#67-Benennung).
* **Der volle Monolith-Split** ist ein Aufräum-Posten (#88-Familie) — **nicht vor F1/F2
  erzwungen**; neue Bauten entstehen ab jetzt in der Zielform, Bestand wandert beim
  Aufräumen (konsolidieren → archivieren → in der Zielform aktivieren).
* **Wellen-Wirkung:** die W2-Emissions-Kette (S-8→S-9→S-10/S-11→S-12→S-13) folgt der
  Träger-Reihenfolge ohnehin; die Hybrid-Posten (HY-A ff.) bleiben hinter den Tier-Posten.
