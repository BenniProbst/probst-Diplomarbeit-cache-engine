# BEFUND — Workload-Cluster-Bildung für den CEB-Auswertungsmodus (Deep Research, 2026-07-09)

> **Auftrag (Team-Lead, 09.07.):** Der CEB-Auswertungsmodus soll aus den Messungen „minimale Stränge der
> Permutationen aller Eigenschaften gegeneinander für bestimmte Workload-CLUSTER" bilden; im Arbeitsmodus
> hält der CEB die relevanten Tier-Binaries je stochastisch häufiger Last hot im RAM und switcht ABI-stabil
> (Dossier 19 Teil G, `docs/architektur/19_SCHICHTEN_FERTIGSTELLUNG_E4_E1_INTERFACE_VERTRAEGE.md:62-71`).
> **Die Cluster-Bildungs-Methodik ist zu ERFORSCHEN, nicht zu erfinden.**
>
> **Ehrlichkeits-Markierung durchgängig (wie Pareto-BEFUND):** `[THESIS]` = im Diplomarbeit-Text/Code belegt ·
> `[LIT]` = peer-reviewed Literatur · `[EMPF]` = Empfehlung dieses Befunds (Schlussfolgerung, nicht direkt belegt).
>
> **Autoritative lokale Quellen (verifiziert gegen den Klon-Stand):**
> `thesis/diplomarbeit/kapitel/de/{03_messsystem_prtart,04_concept_architecture,06_evaluation_methodology}.tex`
> · ce `Code/external/comdare-cache-engine/libs/cache_engine/builder/cacheline_policy/cacheline_policy_selector.hpp`
> · Anschluss-BEFUNDe `20260709-pareto-objectives-t6-t18-t5/BEFUND.md` §4 und
> `20260709-axes-optimization-deep-research/BEFUND.md` §0.3/§4.

---

## 0. Rahmen — was die Thesis schon festlegt und wo die Lücke ist

### 0.1 Der Auswertungsmodus ist in der Thesis ein Ausblick, nicht implementiert `[THESIS]`
Die Evaluationsmethodik markiert den ganzen Heuristik-Extraktions-Schritt **explizit als Ausblick**:
„*Dieser Abschnitt beschreibt einen Ausblick, keine im Rahmen dieser Arbeit umgesetzte Funktion*"
(`06_evaluation_methodology.tex:153`); ebenso `04_concept_architecture.tex:373` („im aktuellen Stand
*noch nicht implementiert*"). Der vorgesehene Mechanismus ist eine **ML-Klassifikation in drei Schritten**
(Feature-Extraktion → Klassifikator → beste Konfiguration je Workload/Datensatz,
`06_evaluation_methodology.tex:158-172`). **Wichtig:** Die Thesis nennt einen *Klassifikator*, aber
**nirgends ein Cluster-Verfahren**. Die „Workload-CLUSTER" aus Dossier 19 Teil G sind der noch offene
Zwischenschritt: Bevor ein Klassifikator „Last → Konfiguration" lernen kann, müssen die Lasten zu
**Klassen** aggregiert werden. Genau diese Aggregation ist die hier zu erforschende Cluster-Bildung —
ein `[EMPF]`, das die von Dossier 19 benannte Lücke füllt und auf `[LIT]` aufsetzt.

### 0.2 Die 14 Lastprofile sind bereits eine *hand-kuratierte* Clusterung `[THESIS]`
Die Arbeit destilliert aus der 33-Paper-Analyse **vierzehn distinkte Lastprofile LP01–LP14**
(`03_messsystem_prtart.tex:272-304`, Tab. `tab:lp-catalog`), jedes mit **Op-Mix**
(Einfügen/Lookup/Löschen/Scan/RMW), **Schlüssel-Verteilung** (uniform-seq, uniform-rand, zipfian(.99),
real-corpus, tpcc-nonuniform) und **neg%** (Anteil negativer Lookups). Das ist faktisch schon eine
**manuelle Clusterung des Lastraums** — 14 Archetypen, von Hand aus der Literatur abgeleitet. Für die
maschinelle Cluster-Bildung ist das ein doppelter Gewinn: (a) ein **starker Prior für die Cluster-Anzahl**
(die natürliche Zahl der Archetypen liegt im Bereich ~14, nicht ~100), und (b) eine **Validierungs-Referenz**
(ein datengetriebenes Clustering sollte die LP-Archetypen grob reproduzieren, sonst ist der Merkmalsraum
falsch gewählt). Ich nutze LP01–LP14 durchgängig als Anker.

### 0.3 Der Heuristik-Selektor + die Pareto-Objectives existieren schon `[THESIS]`
`cacheline_policy_selector.hpp` ist bereits der **GoF-Strategy-Heuristik-Kern** und leitet aus einem
`WorkloadProfileAggregate` (Merkmale `scan_share`/`point_share`/`write_share` + `working_set_n`,
`cacheline_policy_selector.hpp:61-108`) die Steuerung ab. Der Pareto-BEFUND (§4) hat gezeigt, dass die
Endauswertung **je (Last × Füllstand × Beschaffenheit) eine Pareto-Front** statt eines Einzelsiegers
ausgeben muss. Die Cluster-Bildung ist die **fehlende Achse „Last"** in genau diesem Tripel: Sie definiert,
über welche Last-Äquivalenzklassen die Pareto-Fronten überhaupt gebildet werden.

---

## 1. Merkmalsraum-Empfehlung — welche gemessenen Größen als Cluster-Features

### 1.1 Grundprinzip: über Last-*Beschreiber* clustern, nicht über die Achsen-Belegung `[EMPF]`
Die Thesis-Feature-Liste mischt zwei Sorten Merkmale (`06_evaluation_methodology.tex:161-164`): „einerseits
die **Lastprofil- und Datensatz-Merkmale** …, andererseits die **Achsen-Belegung der Permutation**". Für die
**Cluster-Bildung** dürfen **nur die Lastprofil-/Datensatz-Merkmale** eingehen — die Achsen-Belegung ist die
*Zielgröße* (was der Klassifikator später vorhersagt), nicht ein Cluster-Feature. Sonst clustert man
Konfigurationen statt Lasten und die Aufgabe „welche Konfiguration je Last-Cluster" wird zirkulär. Das ist
konsistent mit `04_concept_architecture.tex:370`: der Klassifikator sagt die Konfiguration **aus den
Lastprofil-Merkmalen** (Zugriffsverteilung, Schreib-/Lese-Anteil, Schlüssel-/Wert-Datentyp) voraus.

### 1.2 Empfohlener Cluster-Merkmalsvektor (alle thesis-verankert)
| Feature-Gruppe | Konkrete Merkmale | Thesis-/Code-Anker | Skala |
|---|---|---|---|
| **Op-Mix** | Anteile Einfügen / Lookup / Löschen / Scan / RMW | `03:283-303` (LP-Katalog); `cacheline_policy_selector.hpp:75-86` (`scan_share`/`point_share`/`write_share`) | [0,1], Simplex |
| **Zugriffsverteilung** | Skew-Kennzahl (uniform ↔ zipfian(θ) ↔ latest ↔ tpcc-nonuniform) | `03:283-303` (Spalte Verteilung); `04:370` („Zugriffsverteilung") | ordinal/θ-kontinuierlich |
| **Negativ-Anteil** | neg% (Anteil erfolgloser Lookups) | `03:283-303` (Spalte neg%); LP06/LP07 | [0,1] |
| **Working-Set / Füllstand** | Records bzw. key-range-Breite | `cacheline_policy_selector.hpp:67`; Pareto-BEFUND „Füllstand" | log-skaliert |
| **Datensatz-Beschaffenheit** | Schlüssellänge, Alphabet-Größe, Präfix-Entropie, Wert-Größe | `06:82-102` (Tab. `tab:datasets`: url/dna/protein/xml/tpcds-id/trec-terms); `06:161-163`; `04:370` („Schlüssel-/Wert-Datentyp") | gemischt, je z-normiert |
| **Nebenläufigkeit** | Thread-Zahl / Kontentions-Grad (LP12/LP13) | `03:296-297` (concurrent-*); heute honest-0 im Selektor `:172-173` | log/ordinal |

**Ehrliche Marke:** Die *Datensatz-Beschaffenheit* (Präfix-Entropie, Alphabet) ist in der Thesis als
Merkmal **benannt** (`06:161-163`), aber im heutigen `WorkloadProfileAggregate` **nicht erfasst** (dort nur
Op-Mix + Working-Set). Sie ist ein **Erweiterungs-Feature** `[EMPF]`, das die Hypothesen H1/H3
(`06:53-61`: Page-Dichte ↔ Verteilung; ValueHandle-Verteilung ↔ Page-Dichte) für die Cluster-Trennung
nutzbar macht.

### 1.3 Normalisierung ist Pflicht, nicht Kosmetik `[LIT]`
Weil alle empfohlenen Verfahren (§2) **euklidisch/distanzbasiert** sind, dominiert ohne Skalierung das
Feature mit der größten Spannweite (Working-Set in Millionen ⋙ Op-Anteile in [0,1]). Feature-Scaling vor
k-Means ist der „*essential yet often neglected step*"; **z-Score-Standardisierung** (Mittel 0, Std 1)
schnitt in kontrollierten Studien am besten ab (PLOS One 2024, *The impact of neglecting feature scaling in
k-means clustering*). **Empfehlung:** Op-Mix bleibt als Simplex-Anteil (schon [0,1]); Working-Set und
Alphabet/Länge **log-transformiert dann z-normiert**; Skew als θ-Parameter der Zipf-Verteilung
(kontinuierlich) statt als kategoriales Label. `[EMPF]`

---

## 2. Verfahren-Vergleich + Empfehlung

Drei Kandidaten, alle in der DB-/Workload-Literatur belegt. Der Vergleich trennt **Offline-Auswertungsmodus**
(Cluster einmal aus der Voll-Messung bilden) von **Online-Arbeitsmodus** (ankommende Last live zuordnen, §5).

### 2.1 k-Means `[LIT]`
- **Prinzip:** partitioniert in *k* Cluster um Zentroide; schnell, skaliert; verlangt **vorgegebenes k** und
  neigt zu **sphärischen, ähnlich großen** Clustern (euklidisch).
- **DB-Präzedenz:** **OtterTune** (Van Aken et al., SIGMOD 2017) clustert seine DBMS-Metriken via k-Means
  (nach Factor Analysis) und behält je Cluster **die zentrums-nächste Metrik** — reduziert 131→~9 Metriken
  bei MySQL. *Characterizing and Subsetting Big Data Workloads* (arXiv 1409.0792, ISPASS 2014) nutzt k-Means
  zur Workload-Gruppierung und wählt je Cluster einen **Repräsentanten**, mit **BIC** zur k-Wahl.
- **Passung hier:** stark für den **Repräsentanten-je-Cluster**-Schritt (ein Stellvertreter-Lastprofil je
  Cluster = genau das, was als wiederverwendbares XML-Lastprofil persistiert wird, `06:174-178`).

### 2.2 Agglomerative hierarchische Clusterung `[LIT]`
- **Prinzip:** baut ein **Dendrogramm** (Objekte → Gruppen nach Distanz); **kein festes k** nötig (Schnitt
  im Baum wählt k *post hoc*); zeigt die **Ähnlichkeits-Struktur** direkt.
- **DB-Präzedenz:** *Characterizing and Subsetting* nennt hierarchische Clusterung „*one common way … for it
  can quantitatively show the similarity among workloads via a dendrogram*".
- **Passung hier:** ideal für den **Thesis-Text** — das Dendrogramm ist eine *interpretierbare Abbildung*,
  die zeigt, wie die 14 LP-Archetypen (§0.2) zu Ober-Clustern verschmelzen (z. B. alle Scan-Lasten LP08 ⊕
  bereichsoptimierte Verteilungen). Klein-*n* (14 LP × 6 Datensätze × Füllstände = überschaubar) → die
  O(n²)-Kosten der Hierarchie sind **irrelevant**.

### 2.3 DBSCAN (dichtebasiert) `[LIT]`
- **Prinzip:** findet **beliebig geformte** Cluster über Dichte (eps, minPts); **kein festes k**;
  **rausch-robust** (Ausreißer = „noise" statt Zwangszuordnung).
- **DB-Präzedenz — der direkteste:** **QueryBot 5000** (Ma, Van Aken, Hefny, Mezerhane, Pavlo, Gordon,
  SIGMOD 2018) gruppiert Query-Templates mit **modifiziertem DBSCAN** über die **Ähnlichkeit ihrer
  Ankunftsraten-Zeitreihen**, um die Zahl der Forecasting-Modelle zu reduzieren, und **re-clustert
  fortlaufend** (online), wenn neue Last eintrifft. Das ist das peer-reviewed Vorbild für den **Arbeitsmodus**
  (§5).
- **Passung hier:** für den **Online**-Fall überlegen (novel Last → „noise" → sicherer Fallback statt
  falscher Cluster-Zuordnung); für den **Offline**-Fall empfindlich gegen die eps-Wahl im gemischt-skalierten
  Feature-Raum.

### 2.4 Empfehlung `[EMPF]`
**Zweistufig, je nach Betriebsmodus getrennt — kein Einheitsverfahren:**

1. **Offline-Auswertungsmodus → agglomerative Hierarchie als Primär-Verfahren, k-Means als Verfeinerung.**
   Begründung: (a) Der Merkmalsraum ist **klein, kuratiert und niedrig-dimensional** (§1.2) → das
   O(n²)-Argument gegen Hierarchie entfällt, ihr **Interpretierbarkeits-Vorteil (Dendrogramm)** trägt direkt
   in den Thesis-Auswertungstext und macht die Verschmelzung der 14 LP-Archetypen sichtbar. (b) Auf dem im
   Dendrogramm gewählten k **k-Means nachlagern**, um je Cluster den **zentrums-nächsten Repräsentanten** zu
   bestimmen (OtterTune-/Subsetting-Muster) — dieser Repräsentant wird das persistierte XML-Lastprofil
   (`06:174-178`). So kombiniert man die Struktur-Sicht der Hierarchie mit der Repräsentanten-Logik von
   k-Means.
2. **Online-Arbeitsmodus → modifiziertes DBSCAN (QueryBot-5000-Muster).** Begründung: Rausch-Robustheit
   (unbekannte Last landet als „noise" → CEB fällt sicher auf den Common-Denominator-Default zurück, statt
   eine falsche Binary hot zu switchen) und **kein festes k** (die Zahl aktiver Last-Cluster schwankt zur
   Laufzeit). Präzedenz peer-reviewed und im Self-Driving-DBMS-Kontext (§5).

**Verworfen als Alleinlösung:** reines k-Means offline (erzwingt sphärische Cluster + festes k, das der
Lastraum nicht hergibt) und reines DBSCAN offline (eps-Kalibrierung im gemischten Feature-Raum fragil). Beide
bleiben als **Bausteine** (Repräsentant bzw. Online) erhalten.

---

## 3. Cluster-Anzahl-Methodik

### 3.1 Die drei kanonischen Verfahren `[LIT]`
- **Elbow (Within-Cluster-Sum-of-Squares):** k an der „Ellenbogen"-Stelle, ab der die Intra-Cluster-Varianz
  nicht mehr merklich fällt. Schwäche: auf runden Kurven schwer eindeutig abzulesen.
- **Silhouette (Rousseeuw 1987):** misst **Trennung** (wie gut jeder Punkt im eigenen Cluster liegt vs.
  Nachbarn); hoher mittlerer Silhouette-Wert = gutes k. Bevorzugt **Separierung** statt Kompaktheit.
- **Gap-Statistik (Tibshirani, Walther, Hastie 2001):** vergleicht die WCSS gegen eine **Null-Referenz ohne
  Struktur**; wählt das kleinste k, dessen Gap innerhalb einer Standardabweichung des Gap bei k+1 liegt.
- **BIC (über GMM):** modell-basiertes Kriterium; von *Characterizing and Subsetting* (arXiv 1409.0792)
  konkret zur k-Wahl beim Workload-Subsetting eingesetzt.

Die Verfahren **widersprechen sich regelmäßig** (Elbow k=9, Silhouette/Gap k=12 im Standard-Beispiel) — daher
keines allein.

### 3.2 Empfehlung `[EMPF]`
- **Mehrere Kriterien konsensuell** (Silhouette **und** Gap-Statistik als Haupt, Elbow als Plausibilität,
  BIC falls GMM-Variante) statt eines einzelnen.
- **Domänen-Anker als Regularisierung:** Das Ergebnis gegen die **14 LP-Archetypen** (§0.2) prüfen. Die
  natürliche k liegt **nicht bei ~100**, sondern in der Größenordnung der von der Thesis von Hand
  destillierten Archetypen — grob **~6 Ober-Cluster** (die 6 Herkunfts-Cluster A–F der Kompositions-Achsen,
  `04_concept_architecture.tex:77`: Trie/Knoten · Hybrid/Layout · Allokation · Prefetching · Synchronisation ·
  Hardware/Messung) bis **~14 Fein-Cluster** (LP01–LP14). Ein datengetriebenes k weit außerhalb [6, ~20] ist
  ein Warnsignal für einen falsch normierten Merkmalsraum, nicht für 50 „echte" Lasttypen.
- **Konsequenz für den Arbeitsmodus:** k klein zu halten ist auch **RAM-ökonomisch** — je Cluster wird eine
  Pareto-Front an Binaries hot vorgehalten (§5); wenige, gut getrennte Cluster = wenige hot Binaries.

---

## 4. „Minimale Stränge der Permutationen je Cluster" — formale Fassung

### 4.1 Übersetzung der User-Formulierung in ein bekanntes Objekt `[EMPF, gestützt auf Pareto-BEFUND §4]`
Dossier 19 Teil G verlangt „**minimale Stränge der Permutationen aller Eigenschaften gegeneinander für
bestimmte Workload-Cluster**". Formal ist das die **Pareto-Front je Cluster im Mess-Dreieck** — exakt die
Struktur, die der Pareto-BEFUND §4.1 schon etabliert hat. Definition:

> Sei **C** ein Workload-Cluster (aus §2). Sei **P** die Menge aller gemessenen Achsen-Permutationen
> (Tier-Binaries). Jede Permutation *p* ∈ P hat unter C ein **Trade-off-Profil** im Dreieck
> **(Latenz p50/p99, Durchsatz ops/s, Speicher Peak-Bytes)** — die Thesis-eigene Pareto-Formulierung
> (`02_suchbaeume_grundlagen.tex:594-622`, via Pareto-BEFUND §0.1) `[THESIS]`. Der **minimale Strang von C**
> ist die **Pareto-Front** — die Menge der **nicht-dominierten** Permutationen: alle *p*, für die keine
> andere Permutation *q* existiert, die in allen drei Größen mindestens gleich gut und in mindestens einer
> echt besser ist.

„**Minimal**" ist hier präzise: Die Pareto-Front ist die **kleinste hinreichende Menge**, um *jede*
Objective innerhalb des Clusters optimal zu bedienen — alles Dominierte ist redundant und wird gestrichen.
„**Aller Eigenschaften gegeneinander**" = genau die **paarweise gegenläufigen Achsen** (RUM: Read ⟂ Update ⟂
Memory), die der Pareto-BEFUND für T6/T18/T5 als multi-objektiv belegt hat `[LIT: RUM-Konjektur, EDBT 2016]`.

### 4.2 Objective kollabiert den Strang zum Punkt `[EMPF]`
Der „Strang" (die Front) ist das **cluster-interne** Ergebnis; er wird **zum einzelnen Punkt**, sobald eine
**Objective** gewählt wird — genau die objective-parametrisierte Auswertung, die die Thesis schon variabel
nennt („Zielgröße ist … **etwa Durchsatz oder Tail-Latenz**", `06_evaluation_methodology.tex:161-164`) `[THESIS]`
und die der GoF-Strategy-Selektor (`ScanOptimizing`/`LatencyOptimizing` + das vorgesehene
`durchsatz-optimierend`, `cacheline_policy_selector.hpp:29-30,136-201`) bereits als Muster trägt. Damit:

- **Auswertungs-Ausgabe je Cluster** = die **Pareto-Front** (der minimale Strang), **nicht** ein Einzelsieger.
- **Default-Auslieferung** = der Front-Punkt der **Default-Objective** je Achse (Pareto-BEFUND §1.4/§2.4/§3.4:
  T6→Throughput, T18→WriteAmplification/lazy, T5→CacheLineUtilization+Locality).
- **Persistenz** = je Cluster ein **XML-Lastprofil** (`06:174-178`), das **die Front + die gewinnende
  Objective** trägt (Objective-Tag am Output, Pareto-BEFUND §4.2) — nachvollziehbar, welcher Punkt gemeint ist.

### 4.3 Warum „je Cluster" und nicht „global" `[THESIS+LIT]`
Der Kern-Befund der Lastprofil-Analyse ist ein **systematischer Bias**: jede Publikation gewinnt nur im
**selbstgewählten Heimprofil** (`03_messsystem_prtart.tex:358-366`) `[THESIS]`. Erst wenn *alle* Lastprofile
gegen *alle* Binaries laufen (Workload als dynamische Achse), wird der Bias sichtbar. Die Cluster-Bildung
**operationalisiert genau das**: die Pareto-Front wird **je Last-Äquivalenzklasse** gebildet, sodass ein
Binary nur dort als „Sieger" erscheint, wo es unter *dieser* Last-Klasse wirklich nicht-dominiert ist. Das ist
die **bias-reduzierte** Form der Endauswertung und literaturseitig die RUM-Aussage „kein Punkt minimiert alle
drei zugleich → per-Last-Betriebspunkt wählen" `[LIT]`.

---

## 5. Arbeitsmodus-Bezug — Online-Klassifikation ankommender Last → Cluster → vorgehaltene Binaries

### 5.1 Die drei Betriebs-Bausteine (Dossier 19 Teil G ↔ Literatur)
Dossier 19 Teil G beschreibt den Arbeitsmodus: der CEB hält „**alle relevanten Tier-Binaries für die aktuell
stochastisch häufig auftretende Workload-Last … hot im RAM**" und „**switcht die Tier-Binary … unter der Haube
hot auf das ABI-stabile Interface**" (`19_…:69`). Das ist bausteinweise **exakt das Self-Driving-DBMS-Muster**:

| CEB-Arbeitsmodus-Baustein (Dossier 19 G) | Peer-reviewed Entsprechung |
|---|---|
| „stochastisch häufig auftretende Last" erkennen | **Forecast der Ankunftsrate je Cluster** — QueryBot 5000 (SIGMOD 2018): modifiziertes DBSCAN über Ankunftsraten-Zeitreihen + Vorhersage (LR/RNN/Kernel-Regression) je Cluster & Horizont `[LIT]` |
| ankommende Last einer Klasse zuordnen | **Workload-Mapping auf nächsten bekannten Punkt** — OtterTune (SIGMOD 2017): euklidische Distanz des Metrik-Vektors zum nächsten Repositorium-Workload `[LIT]` |
| relevante Binaries hot vorhalten + switchen | **classify → forecast → act** — Pavlo et al., *Self-Driving DBMS*, CIDR 2017 (Peloton klassifiziert Workloads, prognostiziert, steuert Ressourcen) `[LIT]` |
| Wechsel an der bewussten Ladegrenze | ABI-stabiler DLL-Wechsel an der **E2-Grenze** (`IObservableTier`), **kein** Runtime-Switch im Tier — Dossier 19 G Architektur-Konsequenz `[THESIS]` |

### 5.2 Online-Klassifikation = Nearest-Cluster-Zuordnung `[EMPF, gestützt auf LIT]`
Der Arbeitsmodus braucht **kein** teures Re-Clustering im Hot-Path: Die Cluster stehen aus dem
Offline-Auswertungsmodus (§2.4/1). Zur Laufzeit wird der **Merkmalsvektor der ankommenden Last** (§1.2,
laufend aus dem observer-basierten Mess-Rückkanal E1→E4 geschätzt) dem **nächsten Cluster-Zentroid** zugeordnet
(OtterTune-Muster: euklidische Distanz zum nächsten bekannten Punkt) `[LIT]`. Fällt die Last in kein Cluster
(DBSCAN-„noise", QB5000-Muster), → **sicherer Default** (Common-Denominator, `06:130-133`) `[THESIS]`.

### 5.3 „Hot im RAM vorhalten" = Pareto-Front der wahrscheinlichsten Cluster `[EMPF]`
Der stochastische Teil („häufig auftretend") ist die **prognostizierte Cluster-Wahrscheinlichkeit** (QB5000
liefert Ankunftsraten je Cluster) `[LIT]`. Der CEB hält je **wahrscheinlichstem Cluster** dessen **minimalen
Strang** (Pareto-Front, §4) an Binaries hot — nicht alle 10¹⁴ Permutationen, sondern die wenigen
nicht-dominierten je aktivem Cluster. Kleines k (§3.2) = wenige hot Binaries = RAM-ökonomisch. Der Hot-Switch
selbst ist der **bestehende „CEB wechselt die GANZE Binary"-Mechanismus, jetzt last-getrieben statt
mess-getrieben** (`19_…:69`) `[THESIS]`.

### 5.4 Konzept-Drift / Nachführung `[LIT]`
Weil sich Lasten über Zeit verschieben (Konzept-Drift), muss der Offline-Cluster-Satz **periodisch
nachgeführt** werden. Standard: **adaptive Sliding-Windows (ADWIN, Bifet & Gavaldà 2007)** — Fenster wächst
bei stationärer Last, schrumpft bei Änderung und verwirft stale Daten; QueryBot 5000 löst dasselbe durch
**fortlaufendes Online-Re-Clustering** `[LIT]`. **Empfehlung:** Drift-Erkennung triggert ein **Offline-Re-Clustering
im Auswertungsmodus** (nicht im Hot-Path) → neue Pareto-Fronten → aktualisierte hot-Binary-Menge. Der Hot-Path
bleibt reine Nearest-Cluster-Zuordnung (zero-cost, keine ML im `do_batch`-Loop, konsistent mit der
Metaprogrammierungs-/honest-0-Doktrin und `cacheline_policy_selector.hpp:32-34`). `[EMPF]`

### 5.5 Einordnung in die Rest-Strecke `[THESIS]`
Dossier 19 G ordnet den Arbeitsmodus **nach E4′** ein (braucht Messdaten #156 + diese Cluster-Research) und
„als eigener Increment **NACH den Schichten** zu planen" (`19_…:71`). Dieser BEFUND ist der Research-Input; die
Umsetzung bleibt nach E4→E1 + #156.

---

## 6. Ehrlichkeits-Bilanz (was ist womit belegt)

| Aussage | Status | Beleg |
|---|---|---|
| Heuristik-/ML-Auswertung ist Ausblick, **nicht** implementiert | `[THESIS]` | `06_evaluation_methodology.tex:153`; `04_concept_architecture.tex:373` |
| Thesis nennt *Klassifikator*, **kein Cluster-Verfahren** — die Cluster-Bildung ist die offene Lücke | `[THESIS]` | `06:158-172`; Dossier 19 G `:68` („per deep research zu ergründen") |
| 14 Lastprofile = hand-kuratierte Clusterung (Op-Mix/Verteilung/neg%) → Prior für k + Validierung | `[THESIS]` | `03_messsystem_prtart.tex:272-304` |
| Cluster-Features = Lastprofil-/Datensatz-Merkmale, **nicht** Achsen-Belegung | `[EMPF]` | Schluss aus `06:161-164`; `04:370` |
| Merkmale: Op-Mix, Zugriffsverteilung, neg%, Working-Set, Alphabet/Präfix, Nebenläufigkeit | `[THESIS]` (benannt) / `[EMPF]` (Präfix-Entropie noch nicht im Code erfasst) | `06:161-163`, `03:283-303`, `cacheline_policy_selector.hpp:61-108` |
| z-Score-Normalisierung vor euklidischem Clustering ist Pflicht | `[LIT]` | PLOS One 2024, *Neglecting feature scaling in k-means* |
| k-Means: Repräsentant je Cluster (zentrums-nächst) | `[LIT]` | OtterTune SIGMOD 2017; Subsetting arXiv 1409.0792 |
| Hierarchie: Dendrogramm zeigt Workload-Ähnlichkeit (interpretierbar) | `[LIT]` | Subsetting arXiv 1409.0792 |
| DBSCAN modifiziert, online, rausch-robust, über Ankunftsraten | `[LIT]` | QueryBot 5000, SIGMOD 2018 |
| **Empfehlung: Hierarchie+k-Means offline · modifiziertes DBSCAN online** | `[EMPF]` | Synthese der drei DB-Präzedenzen auf den kuratierten Merkmalsraum |
| Cluster-Anzahl: Silhouette/Elbow/Gap/BIC, konsensuell + Domänen-Anker (~6–14) | `[LIT]` (Verfahren) / `[EMPF]` (Anker an LP + A–F-Cluster) | Tibshirani et al. 2001; Rousseeuw 1987; `03:285-298`, `04:77` |
| „Minimaler Strang je Cluster" = Pareto-Front im Latenz/Durchsatz/Speicher-Dreieck | `[EMPF]` | Formalisierung; Pareto-BEFUND §4; `02:594-622` (via Pareto-BEFUND §0.1) |
| Objective kollabiert die Front zum Auslieferungs-Punkt (Durchsatz **oder** Tail-Latenz) | `[THESIS]` | `06:161-164`; `cacheline_policy_selector.hpp:29-30` |
| „je Cluster statt global" ist die bias-reduzierte Form (Heimprofil-Bias) | `[THESIS]` | `03:358-366` |
| Arbeitsmodus = classify→forecast→act; ABI-Switch an E2-Grenze, kein Runtime-Switch im Tier | `[THESIS]` (Architektur) / `[LIT]` (Muster) | Dossier 19 G `:69-71`; Pavlo CIDR 2017; QB5000; OtterTune |
| Online-Klassifikation = Nearest-Cluster-Zuordnung + Default bei „noise" | `[EMPF]` | OtterTune-Mapping + QB5000-noise, angewandt |
| Konzept-Drift → periodisches Offline-Re-Clustering (ADWIN/Online-DBSCAN), Hot-Path bleibt zero-cost | `[LIT]` (Drift) / `[EMPF]` (Trigger-Architektur) | Bifet & Gavaldà 2007; QB5000; `cacheline_policy_selector.hpp:32-34` |
| Arbeitsmodus als Increment NACH den Schichten (braucht #156 + diese Research) | `[THESIS]` | Dossier 19 G `:71` |

---

## Quellen (Web, abgerufen 2026-07-09; peer-reviewed bevorzugt)

- Ma, Van Aken, Hefny, Mezerhane, Pavlo, Gordon, *Query-based Workload Forecasting for Self-Driving Database
  Management Systems*, **SIGMOD 2018** — <https://www.pdl.cmu.edu/PDL-FTP/Database/sigmod18-ma.pdf> ·
  <https://www.cs.cmu.edu/~dvanaken/papers/forecasting-sigmod18.pdf> · Code
  <https://github.com/malin1993ml/QueryBot5000> (modifiziertes DBSCAN über Ankunftsraten, Online-Re-Clustering).
- Van Aken, Pavlo, Gordon, Zhang, *Automatic Database Management System Tuning Through Large-scale Machine
  Learning* (OtterTune), **SIGMOD 2017**, S. 1009–1024 — <https://db.cs.cmu.edu/papers/2017/p1009-van-aken.pdf>
  · Zusammenfassung <https://blog.acolyer.org/2017/08/11/automatic-database-management-system-tuning-through-large-scale-machine-learning/>
  (Factor Analysis + k-Means-Metrik-Pruning; euklidisches Workload-Mapping).
- Pavlo et al., *Self-Driving Database Management Systems*, **CIDR 2017** —
  <https://www.cidrdb.org/cidr2017/papers/p42-pavlo-cidr17.pdf> (classify → forecast → act; Peloton).
- *Characterizing and Subsetting Big Data Workloads*, **arXiv 1409.0792** (ISPASS 2014) —
  <https://arxiv.org/pdf/1409.0792> (hierarchisch + k-Means + BIC + PCA; Repräsentant je Cluster).
- Cooper, Silberstein, Tam, Ramakrishnan, Sears, *Benchmarking Cloud Serving Systems with YCSB*, **SoCC 2010**
  — <https://dl.acm.org/doi/10.1145/1807128.1807152> · Core-Workloads A–F
  <https://github.com/brianfrankcooper/YCSB/wiki/Core-Workloads> (A update-heavy 50/50, B read-mostly 95/5,
  C read-only, D read-latest, E short-scans, F read-modify-write; Verteilungen uniform/zipfian/latest).
- Rousseeuw, *Silhouettes: a graphical aid to the interpretation and validation of cluster analysis*, J. Comput.
  Appl. Math. 1987 (Silhouette). · Tibshirani, Walther, Hastie, *Estimating the number of clusters via the gap
  statistic*, JRSS-B 2001 (Gap-Statistik).
- Bifet, Gavaldà, *Learning from Time-Changing Data with Adaptive Windowing (ADWIN)*, SDM 2007 (Konzept-Drift,
  adaptives Fenster).
- *The impact of neglecting feature scaling in k-means clustering*, **PLOS One 2024** —
  <https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0310839> (z-Score-Standardisierung).
- Athanassoulis et al., *Designing Access Methods: The RUM Conjecture*, **EDBT 2016** (über Pareto-BEFUND;
  R/U/M-Trade-off = „kein Punkt minimiert alle drei", per-Last-Betriebspunkt).

*Erstellt 2026-07-09. Nur additiv unter `docs/sessions/backups/20260709-workload-cluster-research/`,
nicht committet (per Auftrag). Alle datei:zeile-Belege gegen den lokalen Klon-Stand
`probst-diplomarbeit-cache-engine` verifiziert; Web-Belege peer-reviewed bevorzugt und am Abrufdatum geprüft.
Anschluss an Pareto-BEFUND (`…20260709-pareto-objectives-t6-t18-t5/BEFUND.md` §4) und Achsen-Optimierungs-BEFUND
(`…20260709-axes-optimization-deep-research/BEFUND.md` §0.3/§4).*
