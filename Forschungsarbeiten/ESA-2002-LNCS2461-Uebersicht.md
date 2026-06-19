# ESA 2002 (LNCS 2461) - Tagungsband-Übersicht

Der Band *Algorithms - ESA 2002* enthält die begutachteten Beiträge des 10th Annual European Symposium on Algorithms (Rom, 17.-21.9.2002), herausgegeben von Rolf Möhring und Rajeev Raman und erschienen als Band 2461 der *Lecture Notes in Computer Science* bei Springer. Es handelt sich um rund 78 weitgehend unabhängige Einzelbeiträge quer durch die gesamte Algorithmik - von Berechnungsgeometrie über Graphalgorithmen, Approximation und Scheduling bis hin zu Datenstrukturen und Speicherhierarchie. Für eine Diplomarbeit über cache-bewusste, hardware-adaptive Suchdatenstrukturen ist nur ein kleiner Ausschnitt einschlägig; der große Rest dient dem thematischen Überblick.

## Einordnung: Efficient Tree Layout in a Multilevel Memory Hierarchy

Das Paper *Efficient Tree Layout in a Multilevel Memory Hierarchy* von Michael A. Bender, Erik D. Demaine und Martin Farach-Colton (S. 165-173, Beitrag #18 dieses Bandes) ist nachweislich ein Auszug aus genau diesem Tagungsband. Titelseite, Autorenschaft und Seitenbereich (165-173) stimmen exakt mit dem ESA-2002-Volume (LNCS 2461) überein; das Paper steht inhaltlich im Datenstruktur-/Speicherhierarchie-Cluster des Symposiums, zusammen mit den eng verwandten Beiträgen #16 und #17 derselben Autorengruppe.

## Für die Diplomarbeit relevante Beiträge

| Relevanz | Titel | Autor:innen | Seiten | Warum relevant |
|---|---|---|---|---|
| 3 | Scanning and Traversing: Maintaining Data for Traversals in a Memory Hierarchy | M. A. Bender, R. Cole, E. D. Demaine, M. Farach-Colton | 139-150 | Cache-oblivious geordnete Mengen, sortiertes vs. lokal-geordnetes Layout (PMA), sequentielle vs. zufällige Zugriffe als Messdimension; verbessert cache-oblivious B-Bäume. |
| 3 | Two Simplified Algorithms for Maintaining Order in a List | M. A. Bender, R. Cole, E. D. Demaine, M. Farach-Colton, J. Zito | 152-164 | Order-Maintenance via List Labeling und implizitem Trie, dichtebasierte Lückenverwaltung (Packed Memory Array), vorbildliches Datenstruktur-Benchmarking. |
| 3 | Efficient Tree Layout in a Multilevel Memory Hierarchy | M. A. Bender, E. D. Demaine, M. Farach-Colton | 165-173 | Cache-bewusstes und cache-oblivious Knoten-zu-Block-Layout von Tries/Bäumen zur Minimierung von Blocktransfers - Kernthema der Arbeit. |
| 3 | Engineering a Lightweight Suffix Array Construction Algorithm | G. Manzini, P. Ferragina | 698-710 | Suffix-Arrays als Trie-Verwandte, explizites Speicherbudget-Engineering (5n/8n/15n Byte), korpusbasiertes Benchmarking, lcp als adaptives Schwierigkeitsmaß. |
| 2 | Implementing I/O-efficient Data Structures Using TPIE | L. Arge, O. Procopiuc, J. S. Vitter | 88-100 | I/O-/External-Memory-Modell (PDM), blockbasierte Suchbäume, mmap-vs-read/write als austauschbares Storage-Organ, sauberes Benchmarking. |
| 2 | External-Memory Breadth-First Search with Sublinear I/O | K. Mehlhorn, U. Meyer | 723-735 | Lehrbeispiel des Standard-I/O-Modells (M/B/D, sort()), Umschreiben zufälliger Pointer-Zugriffe in sequentielle Block-Scans via Clustering + Hot-Pool. |

### Scanning and Traversing: Maintaining Data for Traversals in a Memory Hierarchy (S. 139-150)

Das Paper behandelt die Pflege einer dynamischen geordneten Menge unter Einfügen, Löschen und logischen Traversierungen von k aufeinanderfolgenden Elementen. Als Modelle dienen das DAM-Zweiebenenmodell (Block B, interner Speicher M), vor allem aber das cache-oblivious Modell für unbekannte, mehrstufige Hierarchien sowie zusätzlich die Unterscheidung zwischen sequentiellen und zufälligen Blockzugriffen (auf Platte Faktor ~10, wachsend), die über die Restriktion "nur O(1) physische Scans pro Operation" eingefangen wird.

Die zentrale Idee bricht mit einer impliziten Annahme der Literatur: Elemente müssten in Adress-Sortierreihenfolge liegen. Durch ein "lokal geordnetes", aber global ungeordnetes Layout (unordered divide-and-conquer mittels rekursiver Widgets) durchbricht man die polylogarithmische Schranke. Bei erlaubter Unordnung erreicht eine cache-oblivious Struktur Updates in O((log log N)^(2+epsilon)/B) amortisierten Blocktransfers - eine exponentielle Verbesserung gegenüber der unteren Schranke Omega((log N)/B) im sortierten Fall - bei Traversierung in O(k/B) (mit kleinem additiven B^epsilon-Term, durch self-adjusting Scans amortisiert eliminiert; schwache Tall-Cache-Annahme M=Omega(B^tau)). Mit O(1) physischen Scans und sortiertem Layout: Updates in O((log^2 N)/B). Als Korollar verbessert dies cache-oblivious B-Bäume (Suche O(log_B N), Update amortisiert O(log_B N), Traversierung O(k/B)).

Beweistechnisch stützt sich die Arbeit auf rekursive Widget-Raumanalyse (S(l)=Theta(l)), Aktivierungs-/Kaskaden-Amortisation über geometrische Reihen, Dichte-Schwellen-Argumente der Packed-Memory-Variante und Block-Granularität (Blöcke der Größe Theta(B), intern unsortiert) für sequentielle Zugriffsmuster.

Für die Diplomarbeit liefert das Paper direkt eine "Traversierungs-/Scan-Achse" bzw. ein "Layout/Ordnungs-Organ" - den Trade-off zwischen strenger Adress-Sortierung (gut für Scans, teuer für Updates) und lokaler Ordnung (billige Updates). Konkret übertragbar sind: (1) die Unterscheidung cache-oblivious vs. cache-aware als eigene Achse; (2) "Anzahl physischer Scans/Seeks" als zusätzliche Messdimension neben Blocktransfers; (3) self-adjusting/splay-artige Re-Sortierung beim Lesen als amortisierende Strategie; (4) die Packed-Memory-/Ordered-File-Struktur und Block-Granularität als konkrete Bausteine für modular austauschbare Storage-/Layout-Organe.

### Two Simplified Algorithms for Maintaining Order in a List (S. 152-164)

Behandelt wird das Order-Maintenance-Problem: Erhaltung einer Totalordnung unter Insert(X,Y), Delete(X) und Order(X,Y)-Vorgängerabfragen. Modell ist das Standard-RAM mit Wortgröße Theta(log n). Die bekannten optimalen Lösungen von Dietz und Sleator gelten als korrekt, aber kompliziert (kontraintuitives Potentialfunktions-Argument); Ziel ist es, dieselben Schranken einfacher zu erreichen.

Kernidee ist die Reduktion auf Online List Labeling: Elemente erhalten ordnungserhaltend ganzzahlige Tags aus [0,u) mit u=n^c. Die Bits der Tags bilden implizit einen virtuellen Trie/Binärbaum; Relabeling entspricht dem Rebalancieren eines gewichtsbalancierten Baums, der jedoch nicht explizit gespeichert wird. Der neue "Tag-range Relabeling"-Algorithmus scannt geometrisch wachsende Tag-Bereiche (Größe 2^i) statt wachsender Elementzahlen und relabelt den kleinsten umschließenden Bereich, dessen Dichte unter dem Overflow-Schwellenwert tau_i = T^(-i) liegt (mit T zwischen 1 und 2).

Resultate: O(log n) amortisierte Insertion bei O(log n) Tag-Bits; über eine Indirektionsebene (zweistufige Struktur, Blöcke der Größe Theta(log n)) ergibt sich O(1) amortisierte Insert/Delete und O(1) Worst-Case-Query. Zusätzlich ein O(log^2 n)-Worst-Case-File-Maintenance-Verfahren in 5 statt Willards 54 Seiten. Der Beweis ist unabhängig von der Tag-Wahl; Average- und Consecutive-Inserts schneiden experimentell nahezu gleich ab. Ein sinnvoller Bit/Relabel-Tradeoff wird empirisch bestätigt (T=1.5 erreicht ~430.000 Einträge bei 32-Bit-Tags).

Methodisch werden amortisierte Dichteanalyse pro umschließendem Bereich, die Verbindung zu weight-balanced Trees (BB[alpha], Skip-Lists, weight-balanced B-Trees) sowie eine rekursive Array-Partitionierung mit über Phasen verteiltem inkrementellem Rebalancing genutzt.

Für die Diplomarbeit ist dies direkt übertragbar auf die Achsen "Layout/Speicher-Organisation" (gap-/dichtebasiertes sequentielles Packing = Packed Memory Array, das Kernprimitiv cache-bewusster Strukturen wie CO-B-Trees) und "Allocator/Rebalancing-Strategie". Der dichteschwellenbasierte Relabel-Mechanismus liefert hardware-adaptive Lokalität (sequentielle Scans, O(k)-Range-Queries); der variable Schwellenwert T ist ein konkreter, messbarer Tuning-Parameter (Bit-Budget vs. Relabel-Kosten) und damit ideal als eigene Permutationsachse mit per-Achsen-Observer.

### Efficient Tree Layout in a Multilevel Memory Hierarchy (S. 165-173)

Das Paper behandelt das Layout eines Baums oder Trie mit fester Eltern-/Kind-Topologie (Suchbäume, die nicht rebalanciert werden können, z.B. Tries, Suffixbäume, Cartesian-Trees, k-d-Trees, BSP-/Quadtrees). Gegeben ist eine Wahrscheinlichkeitsverteilung auf den Blättern; die Wahrscheinlichkeit eines inneren Knotens ist die Summe der Blattwahrscheinlichkeiten in seinem Teilbaum. Modell ist die hierarchische (Block-/External-Memory-)Speicherung: N Knoten werden in Blöcke der Größe B partitioniert. Ziel ist die Minimierung der erwarteten Anzahl Block-Transfers auf einem Wurzel-zu-Blatt-Pfad. Die Vorarbeit von Gil und Itai lieferte ein optimales, aber teures dynamisches Programm (O(N B^2 log Delta) Zeit, O(B log N) Raum). B-Bäume sind hier nur bei Gleichverteilung optimal.

Die Kernidee ist ein einfacher Greedy-Algorithmus: Als Wurzelblock werden zusammenhängend jene B Knoten mit maximaler Wahrscheinlichkeitssumme gewählt (äquivalent: er maximiert die erwartete Blatttiefe im Wurzelblock); dieser Block wird konzeptuell entfernt, und das Verfahren rekursiert auf den Restteilbäumen. Ein Strukturlemma garantiert, dass ein optimales Layout existiert, in dem der Wurzelblock einen zusammenhängenden Teilbaum bildet.

Resultate: Greedy läuft in O(N log B) und liegt additiv um höchstens (B-1)/B < 1 über dem Optimum (Theorem 1). Eine relaxierte Variante (jeder Knoten mit Wahrscheinlichkeit >= epsilon mal Bestwert zulässig) kostet höchstens 1/epsilon mal Optimum plus (B-1)/B (Theorem 2). Die cache-oblivious Variante (Blockgröße unbekannt; rekursive Halbierung, bis der Wurzelblock etwa der erwarteten Kinder-Teilbaumgröße entspricht) ist höchstens 4-fach optimal plus 4 und gilt simultan für jede Ebene einer mehrstufigen Hierarchie (Theorem 3). Beweisinstrumente sind Austauschargumente plus ein "smooth cost"-Modell (Blockkosten j/B statt 1) als untere Schranke; Demotion/Promotion von Min-/Max-Wahrscheinlichkeitsblättern zeigt strikte Kostensenkung. Implementiert wird über eine Priority-Queue (Größe <= B^2) und Order-Statistics.

Für die Diplomarbeit ist das Paper direkt als eigene Achse "Knoten-zu-Block-Layout / Speicheranordnung" für cache-bewusste Suchstrukturen übertragbar, mit der relaxierten Greedy-Variante als Tuning-Parameter (epsilon = Kosten/Flexibilitäts-Abwägung). Besonders wertvoll sind die cache-oblivious, hardware-adaptive Layout-Strategie (automatische Anpassung an unbekannte B über mehrere Memory-Ebenen, verwandt mit dem van-Emde-Boas-Layout) sowie die verteilungsabhängige (skew-aware) Optimierung als messbares, modular austauschbares Organ neben Allocator- und ISA-Achsen.

### Engineering a Lightweight Suffix Array Construction Algorithm (S. 698-710)

Konstruiert wird das Suffix-Array SA[1,n] eines Textes T[1,n], also die lexikographische Sortierung aller Suffixe - in vielen String-Matching-, Volltextindex- und Kompressionsanwendungen (Burrows-Wheeler, komprimierte/succinct Indexe) der zeit- und vor allem speicherkritische Engpass. Praxisnahe Engineering-Annahmen: Alphabet |Sigma| <= 256 (1 Byte/Zeichen, T belegt n Byte), n <= 2^32 (Suffix-Position in 4-Byte-Wort, SA belegt 4n Byte). "Lightweight" heißt: 5n Byte (genau Text + SA) plus wenig Zusatzspeicher. Als Schwierigkeitsmaß dient das durchschnittliche lcp (Länge des längsten gemeinsamen Präfixes aufeinanderfolgender Suffixe).

Kernidee: Die existierenden 5n-Byte-Verfahren (Itoh-Tanaka two-stage, Seward copy) sind schnell bei kleinem lcp, brechen aber bei großem lcp um Faktor 100+ ein. Das Paper nutzt eine kleine, einstellbare Zusatzmenge (5n+cn Byte, c <= 0,03; das beste Verfahren 5,03n) mit maßgeschneiderten Ad-hoc-Datenstrukturen, um genau diese Degradation bei hohem lcp zu vermeiden.

Komplexität: Suffix-Baum-Verfahren erreichen Theta(n) Zeit, brauchen aber >= 15n Byte (unpraktisch). qsufsort (Larsson-Sadakane, Doubling) läuft in O(n log n) bei 8n Byte (bisheriger Marktführer). two-stage/copy: Theta(n^2 log n) Worst Case bei 5n Byte. Das neue Verfahren ist für lcp < 100 schneller als Sewards copy und etwa doppelt so schnell wie qsufsort und nur bei der allergrößten lcp langsamer. Methodisch beruht es auf der Doubling-Invariante, der Typ-A/Typ-B-Suffix-Trennung (nur Typ-B direkt sortieren, Typ-A daraus per SA-Durchlauf ableiten) und der Bucket/small-bucket-Kopierregel.

Für die Diplomarbeit ist die Achse "Speicher-Budget / Working-Set-Größe" als tunbarer Parameter c direkt übertragbar - ein hardware-adaptiver Knopf, der Space gegen Laufzeit tauscht. Ebenso übertragbar: das Abwägen eines billigen Schlüssel-Vergleichs (lcp/Doubling-Rang) gegen direkten Zeichenvergleich (lcp als adaptives Eingabe-Schwierigkeitsmaß zur Strategiewahl), das Bucket/small-bucket-Schema als cache-freundliche Layout-/Partitionierungsachse und das "Engineering vs. Asymptotik"-Argument als Begründung für hybride, eingabe-adaptive Strategieumschaltung (z.B. Radix-/Multikey-/Insertion-Sort nach Gruppengröße). (Hinweis: Der vorliegende Quelltext-Auszug bricht in Abschnitt 2.3 ab; der eigentliche Deep-Shallow-Kern der Autoren auf S. 703-710 sowie die Detail-Messtabellen sind nicht enthalten.)

### Implementing I/O-efficient Data Structures Using TPIE (S. 88-100)

Die TPIE-Bibliothek (Transparent Parallel I/O Environment, Duke University) adressiert das Problem, dass bei massiven Datensätzen nicht die CPU-Zeit, sondern die I/O-Kommunikation zwischen schnellem Hauptspeicher und langsamen Platten den Engpass bildet. Modell ist das Parallel Disk Model (PDM, Vitter/Shriver): Prozessor, fester Speicher M, Blockgröße B, N Datenelemente, D Platten (hier nur D=1); gemessen werden Anzahl I/Os, Plattenplatz und Rechenzeit. Annahme: Blocktransfer amortisiert teure Seek-/Wartezeiten (Millisekunden vs. Nanosekunden, Faktor ~10^6). Kernkritik: PDM unterscheidet nicht zwischen sequentiellem und zufälligem I/O - letzterer ist real teurer.

Die Bibliothek ist templatebasiert in C++ aufgebaut, mit einem Kernel (BTE Block Transfer Engine, Memory Manager, Access Method Interface AMI) plus aufgesetzten Datenstrukturen. Phase 1 unterstützte sequentielle Stream-Muster (Scan/Sort/Merge/Permute); Phase 2 (dieses Paper) fügt einen Random-Access-BTE für Online-Strukturen mit zufälligem Zugriff hinzu. Der Random-BTE implementiert eine "block collection" (Array fester Blöcke in einer UNIX-Datei, Block-ID = Index, Offset per Seek); gelöschte IDs werden auf einem plattenresidenten Stack recycelt (O(1) create/delete). Zwei Implementierungen: BTE_coll_mmap (zero-copy via mmap/munmap, bevorzugt) und BTE_coll_ufs (read/write). Das AMI_block<E,I>-Template gibt Blöcken typisierte Struktur (Array von Block-ID-Links, Array von Elementen E, Info-Feld I); Effizienz durch Dirty-Flags, keine virtuellen Funktionen (Inlining), zero-copy. Die Fallstudie K-D-B-tree zeigt experimentell, dass mmap-basiertes BTE bei zufälligen Zugriffen (Range Query) klar schneller ist als read/write, während rein sequentielles Bulk Loading von der I/O-Wahl unbeeinflusst bleibt.

Für die Diplomarbeit ist die Achse "I/O-/Speicher-Backend" (mmap vs. read/write) als austauschbares Organ direkt analog zur Allocator-/Storage-Delegation. Ebenso übertragbar: das typisierte Block-Konzept (Links/Elemente/Info) als Modell für cache-zeilenbewusste Knoten-Layouts, application-level Caching als konfigurierbare Achse statt fixem Kernel-Cache und das PDM/B-M-N-Schema als sauberes, messbares Kostenmodell pro Achse. Behandelt wird allerdings die Platte-Hauptspeicher-Ebene, nicht die für die Arbeit zentrale CPU-Cache-Ebene - daher Hintergrund-/Methodenreferenz statt Kernquelle.

### External-Memory Breadth-First Search with Sublinear I/O (S. 723-735)

Breitensuche (BFS) zerlegt einen Graphen mit n Knoten und m Kanten in Levels und ist Baustein vieler Graph- und Kürzeste-Wege-Algorithmen. Im External-Memory-Modell (Vitter/Shriver) zählt nur I/O: Hauptspeicher M, D parallele Platten, Blockgröße B; Sortieren kostet sort(x)=Theta(x/(DB)·log_{M/B}(x/B)). Annahmen: ungerichtete (bzw. dünne gerichtete Eulersche) Graphen; semi-extern gilt c·n <= M < m. Das Standard-O(n+m)-In-Memory-Verfahren erzeugt extern Theta(n+m) I/Os - der Theta(n)-Term stammt aus unstrukturierten Zugriffen auf Adjazenzlisten, der Theta(m)-Term aus den Nachbarschafts-Abfragen.

Kernidee ist die Verfeinerung des Munagala/Ranade-Algorithmus (Theta(n+sort(n+m)), der den m-Term durch Sortieren/Duplikat-Elimination beseitigt, aber pro Knoten noch eine I/O zahlt). Mehlhorn/Meyer entfernen auch den n-Term durch Vorverarbeitung: Der Graph wird in disjunkte Teilgraphen kleinen inneren Durchmessers partitioniert (Master-Knoten zufällig mit Wahrscheinlichkeit mu; erwarteter Abstand O(1/mu)). Adjazenzlisten werden gebündelt in eine externe Datei umgeschrieben. In Phase 2 hält man eine "hot pool"-Datei der gerade aktiven Bündel; statt zufälliger Listenzugriffe wird diese sequentiell gescannt. Jede Liste wird einmal in den Pool kopiert und im Mittel nur O(1/mu) Schritte gebraucht.

Resultate: O(sqrt(n(n+m)/(DB)) + sort(n+m)) I/Os (randomisiert erwartet bzw. deterministisch worst-case), optimal bei mu = sqrt((n+m)/(n·DB)). Für dünne Graphen (m=O(n)) Verbesserung um Faktor Omega(sqrt(DB)). SSSP mit kleinen Gewichten {1..W}: O(sqrt(Wn(n+m)/(DB)) + W·sort). SEM-BFS auf gerichteten Eulerschen Graphen: O((n+m)/(DB)^(1/3) + sort·log n). Korrektheit nutzt, dass bei ungerichteten Graphen Nachbarn nur in den Levels L(t-2..t) liegen; ferner Amortisation über Pool-Verweildauer und Chernoff-artige Partitions-Argumente.

Für die Diplomarbeit ist das Prinzip direkt auf die Achsen "Allokator/Layout" und "Storage/node-chunked" übertragbar: "Zufällige Pointer-Zugriffe in sequentielle Block-Scans umschreiben via clusternde Vorverarbeitung + Hot-Pool" ist das cache-bewusste Pendant zur Cache-Line-Lokalität. Der hardware-adaptive Parameter mu (abhängig von B, D bzw. Cache-Line-/Cache-Größe) liefert eine messbare, parametrisierte Achse zwischen "pro-Element-Random-Access" und "Voll-Scan" - ideal als permutierbares Organ, dessen Trade-off pro Maschine empirisch vermessen wird.

## Vollständiger Überblick nach Themengebiet

### Datenstrukturen / Speicherhierarchie

- **Implementing I/O-efficient Data Structures Using TPIE** (L. Arge, O. Procopiuc, J. S. Vitter, S. 88-100) - Templatebasierte C++-Bibliothek mit Random-Access-BTE; mmap schlägt read/write bei zufälligen Zugriffen auf externe Suchbäume.
- **Scanning and Traversing: Maintaining Data for Traversals in a Memory Hierarchy** (M. A. Bender, R. Cole, E. D. Demaine, M. Farach-Colton, S. 139-150) - Lokal-ungeordnetes cache-oblivious Layout druckt Update-Kosten exponentiell unter die Schranke des sortierten Falls bei O(k/B)-Traversierung.
- **Two Simplified Algorithms for Maintaining Order in a List** (M. A. Bender, R. Cole, E. D. Demaine, M. Farach-Colton, J. Zito, S. 152-164) - Stark vereinfachte O(1)-amortisierte Order-Maintenance via List Labeling und impliziten Trie, plus knappes File-Maintenance-Verfahren.
- **Efficient Tree Layout in a Multilevel Memory Hierarchy** (M. A. Bender, E. D. Demaine, M. Farach-Colton, S. 165-173) - Greedy- und cache-oblivious Layout fester Baum-/Trie-Topologien minimiert erwartete Blocktransfers bei nicht-uniformer Verteilung.

### Strings / Suffix-Strukturen

- **Engineering a Lightweight Suffix Array Construction Algorithm** (G. Manzini, P. Ferragina, S. 698-710) - 5,03n-Byte-Suffix-Array-Konstruktion vermeidet die lcp-Degradation bisheriger 5n-Byte-Verfahren und schlägt qsufsort.

### Graphalgorithmen

- **On Distance Oracles and Routing in Graphs** (M. Thorup, S. 3-3, Invited) - Platzsparende approximative Distanzorakel und Distance-Labeling für kompaktes Routing, mit besseren Schranken für planare/baumweitenbeschränkte Graphen.
- **New Heuristics and Lower Bounds for the Min-Max k-Chinese Postman Problem** (D. Ahr, G. Reinelt, S. 64-74) - Augment-Merge- und Cluster-Heuristiken schlagen die FHK-Approximation und drei neue untere Schranken für das Min-Max-Briefträgerproblem.
- **On the k-Splittable Flow Problem** (G. Baier, E. Köhler, M. Skutella, S. 101-113) - NP-Härte schon bei k=2, optimale 2/3-Approximation für k=2,3 und Reduktion auf uniforme exakt-k-splittbare Flüsse.
- **Classical and Contemporary Shortest Path Problems in Road Networks: TRANSIMS Router** (C. Barrett, K. Bisset, R. Jacob, G. Konjevod, M. Marathe, S. 126-138) - Dijkstra-Verallgemeinerung für sprach-beschränkte, zeitabhängige kürzeste Wege in Millionen-Knoten-Verkehrsnetzen mit statistischer Versuchsplanung.
- **Eager st-Ordering** (U. Brandes, S. 247-256) - Linearzeit-st-Ordnung biconnected Graphen ohne Lowpoints in einem einzigen, jederzeit stoppbaren DFS-Durchlauf.
- **Wide-Sense Nonblocking WDM Cross-Connects** (P. Haxell, A. Rasala, G. Wilfong, P. Winkler, S. 538-550) - Online-Kantenfärbung bipartiter Multigraphen zeigt, dass wide-sense ab ~k^2/4 Wellenlängen keinen Vorteil gegenüber strikt bringt.
- **Efficient Implementation of a Minimal Triangulation Algorithm** (P. Heggernes, Y. Villanger, S. 550-562) - Reimplementierung von LB-triang über Baumzerlegung erreicht beweisbar O(nm) Zeit und empirisch O(n^2).
- **External-Memory Breadth-First Search with Sublinear I/O** (K. Mehlhorn, U. Meyer, S. 723-735) - Erste sublinear-I/O-BFS für dünne Graphen durch clusternde Vorverarbeitung und sequentiell gescannte Hot-Pool-Adjazenzlisten.
- **Frequency Channel Assignment on Planar Networks** (M. Molloy, M. R. Salavatipour, S. 736-747) - Entladungsmethode liefert lambda^p_q(G) <= 5/3·(2q-1)·Delta + ... und eine (5/3+o(1))-Approximation für planare Graphen.
- **Design and Implementation of Efficient Data Types for Static Graphs** (S. Näher, O. Zlotowski, S. 748-759) - Array-basierte, parametrisierte statische LEDA-Graphtypen mit XOR-kodierten Kantenendpunkten beschleunigen bestehenden Code ohne Änderung.
- **Complexity of Compatible Decompositions of Eulerian Graphs and Their Transformations** (J. Maxova, J. Nesetril, S. 711-722) - Effiziente Transformation F-kompatibler Zerlegungen Eulerscher Graphen in geschlossene Trails mit höchstens +1 Subtrail.
- **Approximation Algorithm for the Maximum Leaf Spanning Tree Problem for Cubic Graphs** (K. Lorys, G. Zwozniak, S. 686-698) - Linearzeit-7/4-Approximation für den Maximum-Leaf-Spanning-Tree kubischer Graphen.
- **A Simple Linear Time Algorithm for Finding Even Triangulations of 2-Connected Bipartite Plane Graphs** (H. Zhang, X. He, S. 902-913) - Gerade Triangulierung direkt aus Dualgraph-Kantenorientierung in O(n), verbessert Art-Gallery-/Prison-Guard-Algorithmen.

### Berechnungsgeometrie

- **Computing Shapes from Point Cloud Data** (T. K. Dey, S. 2-2, Invited) - Oberflächenrekonstruktion "Cocone" mit beweisbaren Garantien aus Voronoi-Analyse plus Dezimierung und mediale Achse.
- **Kinetic Medians and kd-Trees** (P. K. Agarwal, J. Gao, L. J. Guibas, S. 5-17) - Pseudo-/überlappende kd-Bäume als kinetische Datenstrukturen mit O(n^(1/2+e)+k)-Anfragen und optimal vielen Ereignissen.
- **Range Searching in Categorical Data: Colored Range Searching on Grid** (P. K. Agarwal, S. Govindarajan, S. Muthukrishnan, S. 17-28) - Erste farbige Bereichssuche auf Gittern via Tries, van-Emde-Boas-Bäume und Exponential-Bäume.
- **Near-Linear Time Approximation Algorithms for Curve Simplification** (P. K. Agarwal, S. Har-Peled, N. H. Mustafa, Y. Wang, S. 29-41) - Gierige (epsilon/2-optimale) Kurvenvereinfachung unter Hausdorff bzw. Frechet in O(n) bzw. O(n log n).
- **Translating a Planar Object to Maximize Point Containment** (P. K. Agarwal, T. Hagerup, R. Ray, M. Sharir, M. Smid, E. Welzl, S. 42-53) - Random Sampling plus Cuttings liefern (1-epsilon)-Approximation des Optimal-Placement in nahezu linearer Zeit.
- **Approximation Algorithms for k-Line Center** (P. K. Agarwal, C. M. Procopiuc, K. R. Varadarajan, S. 54-63) - (1+epsilon)-Approximation des k-Zylinder-Überdeckungsproblems in O(n log n) über kleine Zertifikatsmengen.
- **A Computational Basis for Conic Arcs and Boolean Operations on Conic Polygons** (E. Berberich, A. Eigenwillig, M. Hemmer, S. Hert, K. Mehlhorn, E. Schömer, S. 174-186) - Exakter, vollständiger Sweep-Line-Kernel für konische Polygone via niedriggradige algebraische Zahlen.
- **TSP with Neighborhoods of Varying Size** (M. de Berg, J. Gudmundsson, M. J. Katz, C. Levcopoulos, M. H. Overmars, A. F. van der Stappen, S. 187-199) - Erste Konstant-Faktor-Approximation für TSPN mit disjunkten konvexen fetten Objekten; allgemeines TSPN ist APX-hart.
- **Constructing Plane Spanners of Bounded Degree and Low Weight** (P. Bose, J. Gudmundsson, M. Smid, S. 234-246) - O(n log n)-Konstruktion planarer t-Spanner mit Maximalgrad 27 und MST-proportionalem Gewicht aus der Delaunay-Triangulation.
- **Three-Dimensional Layers of Maxima** (A. L. Buchsbaum, M. T. Goodrich, S. 257-269) - Optimales O(n log n)-Verfahren via 3D-Sweep und erweitertes dynamisches Fractional Cascading (Knoten hohen Grades).
- **Optimal Terrain Construction Problems and Applications in IMRT** (D. Z. Chen, X. S. Hu, S. Luan, X. Wu, C. X. Yu, S. 270-283) - Exaktes Leaf-Sequencing als kürzeste Wege in einem DAG mit matching-basierten Kantengewichten für die Strahlentherapie.
- **Geometric Algorithms for Density-Based Data Clustering** (D. Z. Chen, M. Smid, B. Xu, S. 284-296) - Subquadratisches dichtebasiertes Clustering über dynamische Bereichssuche (BBD-Baum) unabhängig von der Datenverteilung.
- **Approximating the Medial Axis from the Voronoi Diagram with a Convergence Guarantee** (T. K. Dey, W. Zhao, S. 387-398) - Skalen-/dichteunabhängige Filterung des Voronoi-Diagramms mit beweisbarer Konvergenz gegen die mediale Achse.
- **Computing Homotopic Shortest Paths Efficiently** (A. Efrat, S. G. Kobourov, A. Lubiw, S. 411-423) - Bündelung homotop-äquivalenter Pfadstücke plus Funnel/Shielding ergibt O(k log n + n·sqrt(n)) statt O(nk).
- **Determining Similarity of Conformational Polymorphs** (A. Enosh, K. Kedem, J. Bernstein, S. 436-448) - Verwebung von Graphisomorphie und geometrischem 3D-Substruktur-Matching zum quantitativen Polymorph-Vergleich.
- **Speeding Up the Incremental Construction of the Union of Geometric Objects in Practice** (E. Ezra, D. Halperin, M. Sharir, S. 473-484) - Disjoint-Cover-Reihenfolge erzeugt nachweislich weniger innere Schnittpunkte als zufällige inkrementelle Konstruktion.
- **Dynamic Additively Weighted Voronoi Diagrams in 2D** (M. I. Karavelas, M. Yvinec, S. 586-598) - Vollständig dynamisches AW-Voronoi-Diagramm über den dualen Delaunay-Graphen mit Einfügen und Löschen.
- **Covering Things with Things** (S. Langerman, P. Morin, S. 662-674) - FPT-Algorithmen für ein abstraktes Dim-Set-Cover über Suchbäume und Kernelisierung, anwendbar auf viele geometrische Überdeckungen.
- **An Exact Algorithm for the Uniformly-Oriented Steiner Tree Problem** (B. K. Nielsen, P. Winter, M. Zachariasen, S. 760-772) - Zwei-Phasen-FST-Verfahren löst lambda-SMT exakt bis 10.000 Terminals (lambda=4 bis ~30% kürzer als lambda=2).
- **High-Level Filtering for Arrangements of Conic Arcs** (R. Wein, S. 884-896) - CGAL-Traits für Kegelschnittbögen mit Konstruktions-Historie als High-Level-Filter statt durchgehend exakter Arithmetik.
- **High-Level Filtering for Arrangements of Conic Arcs** (R. Wein, S. 896-901) - Ergänzende Darstellung: GGT-basierte Koordinatentrennung und Loos-Schranke (<= 23+20·log2(M) Bits) ersetzen hochgradige Wurzelextraktion.

### Kombinatorische Optimierung / Ganzzahlige Programmierung

- **Solving Traveling Salesman Problems** (W. Cook et al., S. 1-1, Invited) - Lösung einer Million-Städte-TSP-Instanz bis 0,09% Optimalität und exakte Lösung mit 15.112 Städten.
- **SCIL - Symbolic Constraints in Integer Linear Programming** (E. Althaus, A. Bockmayr, M. Elf, M. Jünger, T. Kasper, K. Mehlhorn, S. 75-87) - Symbolische/globale Constraints aus der CP in die ILP übertragen; C++-System auf LEDA/ABACUS mit Terminierungsbeweis.
- **Branch-and-Bound Algorithms for the Test Cover Problem** (K. M. J. De Bontridder, B. J. Lageweg, J. K. Lenstra, J. B. Orlin, L. Stougie, S. 223-233) - Neues "Power"-Kriterium liefert stärkere untere Schranken als die informationsbasierte Schranke für Test-Cover.
- **Simple and Fast: Improving a Branch-And-Bound Algorithm for Maximum Clique** (T. Fahle, S. 485-498) - Cost-Based Domain Filtering subsumiert 7 von 8 oberen Schranken und reduziert Verzweigungspunkte um Faktoren bis ~30.
- **A Primal Approach to the Stable Set Problem** (C. Gentile, U.-U. Haus, M. Köppe, G. Rinaldi, R. Weismantel, S. 525-537) - Clique-Path-Substitution perfektioniert Graphen und übersetzt duale in primale Separation von Odd-Hole-Ungleichungen.
- **Extending Reduction Techniques for the Steiner Tree Problem** (T. Polzin, S. Vahdati Daneshmand, S. 795-807) - Rekursive Baum-Expansion plus schranken-basierte Tests lösen zuvor ungelöste SteinLib-Instanzen.
- **Lagrangian Cardinality Cuts and Variable Fixing for Capacitated Network Design** (M. Sellmann, G. Kliewer, A. Koberstein, S. 845-858) - Lagrange-basierte Variablenfixierung und lokale Kardinalitätsschnitte für das Capacitated Network Design Problem.
- **An Algorithm for Dualization in Products of Lattices and Its Applications** (K. M. Elbassioni, S. 424-435) - Quasi-polynomielle Dualisierung in Verbandsprodukten beschränkter Breite mit Anwendungen in Data Mining und Geometrie.

### Approximation / Randomisierte Algorithmen

- **1.375-Approximation Algorithm for Sorting by Reversals** (P. Berman, S. Hannenhalli, M. Karpinski, S. 200-210) - Verbessert das Approximationsverhältnis für das Sortieren unsignierter Permutationen durch Reversals von 1,5 auf 1,375.
- **Non-independent Randomized Rounding and an Application to Digital Halftoning** (B. Doerr, H. Schnieder, S. 399-409) - Block-randomisiertes Runden mit eingebauten Abhängigkeiten senkt den erwarteten 2x2-Box-Fehler in Linearzeit.
- **The Probabilistic Analysis of a Greedy Satisfiability Algorithm** (A. C. Kaporis, L. M. Kirousis, E. G. Lalas, S. 574-586) - Greedy-Davis-Putnam nach Literalgrad verbessert die untere 3-SAT-Erfüllbarkeitsschwelle auf c < 3,42.
- **A Fast, Accurate and Simple Method for Pricing European-Asian and Saving-Asian Options** (K. Ohta, K. Sadakane, A. Shioura, T. Tokuyama, S. 772-784) - Randomisierte DP-Variante mit Martingal-/Azuma-Analyse liefert volatilitätsunabhängige Fehlerschranke für asiatische Optionen.

### Scheduling / Online-Algorithmen

- **Minimizing the Maximum Starting Time On-line** (L. Epstein, R. van Stee, S. 449-460) - Greedy ist Theta(log m)-kompetitiv; phasenbasiertes BALANCE erreicht konstanten Faktor 12; Resource Augmentation macht Greedy optimal.
- **Vector Assignment Problems: A General Framework** (L. Epstein, T. Tassa, S. 461-473) - Einheitliches PTAS-Framework für eine breite, auch nicht-monotone Klasse von Vektor-Zuweisungs-Zielfunktionen.
- **Scheduling Malleable Parallel Tasks: An Asymptotic FPTAS** (K. Jansen, S. 562-574) - AFPTAS für malleable parallele Tasks via LP-Lösung des präemptiven Problems und Reduktion auf fraktionales Strip-Packing.
- **Partially-Ordered Knapsack and Applications to Scheduling** (S. G. Kolliopoulos, G. Steiner, S. 612-624) - Bikriterielles FPTAS für 2-dimensionale Ordnungen und erster polynomieller Spezialfall (chordal-bipartit) von POK.
- **Real-Time Dispatching of Guided and Unguided Automobile Service Units with Soft Time Windows** (S. O. Krumke, J. Rambau, L. M. Torres, S. 637-648) - ZIBDIP löst ADAC-Pannenhilfe-Disposition (215 Anfragen) per Dynamic Pricing Control in unter einer Minute auf <=1% Optimalität.
- **Randomized Approximation Algorithms for Query Optimization Problems on Two Processors** (E. Laber, O. Parekh, R. Ravi, S. 649-661) - Deterministische 2-Approximation (uniform) und randomisierte 8/3-Approximation für das Dynamic Bipartite Ordering Problem.
- **A Comparison of Multicast Pull Models** (K. Pruhs, P. Uthaisombut, S. 808-819) - Server-seitiges Out-of-order-Senden bringt keine QoS, client-seitige Out-of-order-Pufferung schon (Multicast-Pull, Lp-Normen).
- **Online Scheduling for Sorting Buffers** (H. Räcke, C. Sohler, M. Westermann, S. 820-832) - Lazy "Bounded Waste"-Strategie ist O(log^2 k)-kompetitiv beim Minimieren der Farbwechsel im Sortierpuffer.
- **Minimizing Makespan and Preemption Costs on a System of Uniform Machines** (H. Shachnai, T. Tamir, G. J. Woeginger, S. 859-871) - PTAS für präemptions-beschränktes uniformes Scheduling plus passende Schranken für die minimale Präemptionszahl.
- **Minimizing the Total Completion Time On-line on a Single Machine, Using Restarts** (R. van Stee, H. La Poutre, S. 872-883) - Einfacher Restart-Algorithmus RSPT ist 3/2-kompetitiv und schlägt jeden restartfreien Algorithmus.
- **On-Line Dial-a-Ride Problems under a Restricted Information Model** (M. Lipmann, X. Lu, W. E. de Paepe, R. A. Sitters, L. Stougie, S. 674-685) - SNIFFER ist 3-kompetitiv im unvollständigen Informationsmodell (Ziel erst beim Aufgreifen bekannt).

### Datenstrom-Algorithmen / Sketching

- **Estimating Rarity and Similarity over Data Stream Windows** (M. Datar, S. Muthukrishnan, S. 323-335) - Erste Streaming-Schätzer für Rarity und Jaccard-Ähnlichkeit im Sliding-Window-Modell via Min-wise Hashing und Treap-Spine.
- **Frequency Estimation of Internet Packet Streams with Limited Space** (E. D. Demaine, A. Lopez-Ortiz, J. I. Munro, S. 348-360) - "Frequent" verallgemeinert Boyer-Moore-Majority auf m Zähler (O(1)-Massendekrement) für Heavy Hitters in einem Durchlauf.

### Netzwerke / Verteilte Algorithmen

- **Balanced-Replication Algorithms for Distribution Trees** (E. Cohen, H. Kaplan, S. 297-309) - Optimaler und lokaler (randomisierter "gap"-) Algorithmus zur Replikatplatzierung gegen Hotspots in Verteilungsbäumen.
- **Butterflies and Peer-to-Peer Networks** (M. Datar, S. 310-322) - Zensurresistentes CAN über Multi-Butterfly/Multi-Hypercube mit O(log n)-Routing und O(1)-Replikationsfaktor.
- **Deterministic Communication in Radio Networks with Large Labels** (L. Gąsieniec, A. Pagourtzis, I. Potapov, S. 512-524) - Deterministisches Gossiping ohne Round-Robin via Selektoren/compound selectors, bis nahezu linear für ungerichtete Netze.

### Spieltheorie / Mechanism Design

- **Mechanism Design for Fun and Profit** (A. R. Karlin et al., S. 3-3, Invited) - Profit-maximierende, wahrheitsgemäße verallgemeinerte Auktionen und ein kompetitives Bewertungs-Framework.
- **Truthful and Competitive Double Auctions** (K. Deshmukh, A. V. Goldberg, J. D. Hartline, A. R. Karlin, S. 361-373) - Reduktion jeder beta-kompetitiven Basisauktion in eine 2beta-kompetitive Doppelauktion; verbesserte CORE-Variante (3,75).

### Online-/Caching-Theorie

- **Online Companion Caching** (A. Fiat, M. Mendel, S. S. Seiden, S. 499-511) - Marking-Algorithmen für den hybriden (n,k)-Companion-Cache; deterministisch exakt (n+1)(k+1)-1-kompetitiv.

### Graphexploration

- **Optimal Graph Exploration without Good Maps** (A. Dessmark, A. Pelc, S. 374-386) - Exakte Overhead-Schranken (Linien, Bäume, allgemein) für Roboter-Exploration je nach Kartenkenntnis; DFS optimal mit Overhead 2.

### Frequenzzuweisung / Graphfärbung

- **Radio Labeling with Pre-assigned Frequencies** (H. L. Bodlaender, H. Broersma, F. V. Fomin, A. V. Pyatkin, G. J. Woeginger, S. 211-222) - Schranken und Komplexität des Radio-Labeling mit vorbelegten Frequenzen (Linearzeit-Approximation bei girth>=5).

### Optimale Such- und Codierungsbäume

- **Partial Alphabetic Trees** (A. Barkan, H. Kaplan, S. 114-125) - Pseudo-polynomielle DP für kostenminimale Bäume mit blockweiser Inorder-Restriktion (verallgemeinert Huffman und alphabetische Bäume).

### Kombinatorik / Kodierungstheorie

- **Efficient Constructions of Generalized Superimposed Codes ...** (A. De Bonis, U. Vaccaro, S. 335-347) - (p,r,d)-superimposed codes mit Schranken, angewandt auf Gruppentests mit Inhibitoren und Konfliktauflösung in Mehrfachzugriffskanälen.

### Kryptographie

- **A Software Library for Elliptic Curve Cryptography** (E. Konstantinou, Y. Stamatiou, C. Zaroliagis, S. 625-637) - Portable, modulare ANSI-C-ECC-Bibliothek mit Complex-Multiplication-Methode (Hilbert-/Weber-Polynome).

### Sortieren / Untere Schranken

- **Sorting 13 Elements Requires 34 Comparisons** (M. Peczarski, S. 785-794) - Erschöpfende Suche über lineare Erweiterungen beweist S(13)=34 und widerlegt Knuths Vermutung 33.

### Algorithmische Komplexität / Untere Schranken

- **Finding the Sink Takes Some Time: An Almost Quadratic Lower Bound for Finding the Sink of Unique Sink Oriented Cubes** (I. Schurr, T. Szabo, S. 833-844) - Erste super-lineare untere Schranke Omega(n^2/log n) im Vertex-Orakel-Modell (Abstraktion linearer Programmierung).

## Fazit & Empfehlung

Für eine Diplomarbeit über cache-bewusste, hardware-adaptive Suchdatenstrukturen sind aus diesem Band vier Beiträge wirklich lese- und zitierwürdig:

1. **Efficient Tree Layout in a Multilevel Memory Hierarchy** (Bender/Demaine/Farach-Colton, S. 165-173) - die zentrale Primärquelle: das Greedy- und cache-oblivious Block-Layout fester Trie-/Baum-Topologien ist unmittelbar als eigene Layout-Achse der Cache-Engine umsetzbar und als Standardreferenz zu cache-oblivious B-Bäumen zu zitieren.

2. **Two Simplified Algorithms for Maintaining Order in a List** (Bender/Cole/Demaine/Farach-Colton/Zito, S. 152-164) - zitieren für Order-Maintenance, das implizite Trie-Tag-Modell und vor allem den Packed-Memory-/dichtebasierten Lückenmechanismus als tunbare Permutationsachse (Schwellenwert T als messbarer Parameter).

3. **Scanning and Traversing** (Bender/Cole/Demaine/Farach-Colton, S. 139-150) - zitieren für die theoretische Fundierung von sortiertem vs. lokal-geordnetem Layout und für "sequentielle vs. zufällige Zugriffe" als zusätzliche Messdimension neben Blocktransfers; liefert das Range-Scan-/Traversierungs-Organ.

4. **Engineering a Lightweight Suffix Array Construction Algorithm** (Manzini/Ferragina, S. 698-710) - zitieren als Musterbeispiel für Algorithm Engineering mit explizitem Speicherbudget (5n/8n/15n Byte) und korpusbasiertem Benchmarking; begründet eingabe-adaptive Strategieumschaltung und den Speicher-Budget-Knopf.

Ergänzend als methodischer Hintergrund (nicht zwingend, aber nützlich fürs Mess- und I/O-Kapitel): **Implementing I/O-efficient Data Structures Using TPIE** (S. 88-100) für das austauschbare Storage-Backend und das saubere PDM-Kostenmodell, sowie **External-Memory BFS with Sublinear I/O** (S. 723-735) als Lehrbeispiel, wie zufällige Pointer-Zugriffe per Clustering in sequentielle Block-Scans umgeschrieben werden - das External-Memory-Pendant zur Cache-Line-Lokalität. Alle übrigen ~72 Beiträge sind für das Thema nicht einschlägig und dienen nur dem Überblick.
