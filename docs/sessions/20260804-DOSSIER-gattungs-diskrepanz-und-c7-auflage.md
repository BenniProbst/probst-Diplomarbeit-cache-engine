# DOSSIER: Gattungs-Diskrepanz (Map/Container/Graph) und C7-Formgebungs-Auflage

Datum: 2026-08-04 | Synthese-Los der Analyse-Welle wf_eea7e75d (read-only)
Quellen: A1 (Ist-Erhebung HEAD 44bcda99, Anatomy-Flaeche) + A2 (cppreference-Live-Erhebung)
+ LEDGER Nachtraege mittags-3/NACHTRAG 4/5 (docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:3832-3837)
+ E24-Bauplan Abschnitt 1.6 (docs/sessions/20260803-DOSSIER-e24-fenster-bauplan.md:138-148, S12.3 = OPTION A)
+ NACH-ERHEBUNG dieser Synthese (eigene Greps am HEAD, unten als [SYN] markiert).
ASCII-only: Umlaute in Code-Zitaten sind transliteriert (ue/oe/ae/ss).
KANON: Owner-Wortlaut = MASSSTAB. Wo das Ist widerspricht, ist das ein BEFUND, keine Owner-Korrektur.

---

## 0. Massstab (verbatim)

OWNER-KERN NACHTRAG 4 (LEDGER:3836, FINAL, supersedet die offene Diskrepanz-Frage aus mittags-3):

> "Einfach gesprochen: Das Genus erbt von der gemeinsamen Gattung. Ein Set erbt bezueglich des
> Interface von Container (Container ist kein Genus, sondern die Hauptgattung und SearchAlgorithm
> ist ein Genus unter der Gattung 'Map'). Die Gattung Graph hat noch keine Genus implementiert und
> ist daher derzeit stub. Sofern doch etwas implementiert ist, muss das bezueglich der beiden
> Ebenen eingeordnet werden."

OWNER-WORTLAUT mittags-3 (LEDGER:3833, Definitions-Kern):

> "Eine Gattung hat immer die gleichen Huellen-Template-Parameter und ein teilidentisches Interface
> der gesamten Gattung nach aussen (gemeinsames Interface ist eine Teilmenge bzw. mathematischer
> Kern aller Interface Bestandteile [...]). Es gibt einen Terminologie Fehler der Zuordnung von
> Containern bezueglich Gattung."

OWNER-KERN NACHTRAG 5 (LEDGER:3837, Klammer): Gattung und Genus sind GESTAFFELTE
Interface-Definitionen, per Abstract Factory compile-time implementiert; Achsen = Bausteine
unter der Genus-Haupt-Implementierung, cross-Gattung/cross-Genus/cross-Achse nutzbar.

FINALES MODELL damit:
- EBENE 1 (Gattungen) = { Map (Huelle <Key,Value>, map-Gleichnis), Container (Huelle <T>,
  vector-Gleichnis), Graph (Stub, keine Genera) }.
- EBENE 2 (Genera) = { SearchAlgorithm IN Map; Set/Sequence/Adapter/View IN Container }.
- Das Genus ERBT das Gattungs-Interface; Gattungs-Kern = mathematische Schnittmenge der
  Genus-Interfaces; Genus erweitert.

---

## 1. Owner-Modell praezise, mit A2-Belegen

### 1.1 Huellen-Signatur-Kriterium (Element-Parameter-Aritaet) am C++-Standard belegt

Literal erhobene Signaturen (A2, cppreference live 04.08.2026):

| std-Typ | Signatur (Element-Parameter fett gedacht) | Element-Aritaet |
|---|---|---|
| vector | `template<class T, class Allocator = std::allocator<T>> class vector` | 1 (T) |
| set | `template<class Key, class Compare = std::less<Key>, class Allocator = std::allocator<Key>> class set` | 1 (Key; Allocator sogar allocator<Key>, KEIN pair) |
| map | `template<class Key, class T, class Compare, class Allocator = std::allocator<std::pair<const Key, T>>> class map` | 2 (Key, T) |
| stack/queue | `template<class T, class Container = std::deque<T>> class stack` | 1 (T) |
| priority_queue | `template<class T, class Container = std::vector<T>, class Compare> class priority_queue` | 1 (T) |
| span | `template<class T, std::size_t Extent = std::dynamic_extent> class span` | 1 (T) |

Owner-These EXAKT bestaetigt: set liegt trotz std-Kategorie "AssociativeContainer" auf der
1-Parameter-Seite wie vector; NUR map/multimap/unordered_map tragen 2 Element-Parameter
(named_req/AssociativeContainer live: "In addition, std::map and std::multimap associate an
arbitrary mapped type T with the Key" -- mapped_type existiert NUR fuer map/multimap).
Die gesamte Owner-Container-Gattung (Set/Sequence/Adapter/View-Gleichnisse) = 1 Element-Parameter;
die Map-Gattung allein = 2. Der Owner-Schnitt (nach Huellen-Aritaet) und der std-Schnitt (nach
Kategorien) sind BEIDE an den Signaturen belegbar; der Owner-Schnitt ist MASSSTAB.

### 1.2 Interface-Kern-Kriterium am C++-Standard belegt

Container-named-requirements (A2 live): Typen value_type/reference/const_reference/iterator/
const_iterator/difference_type/size_type; Operationen Konstruktion/Kopie/Zerstoerung,
begin/end/cbegin/cend, ==/!=, swap (Member+frei), size/max_size/empty; optional <=> (C++20).
Der Kern enthaelt KEIN operator[], KEIN insert/erase, KEIN front/back, KEIN find --
nur Traversal + Groesse + Gleichheit + Swap + Kopie/Zerstoerung. Das ist die std-Praezedenz
fuer "gemeinsames Interface = mathematischer Kern": klein, und der Standard fuehrt darueber
hinaus OPTIONALE Bloecke ("optional container requirements") = gestuftes Interface-Muster.

WICHTIGE Kern-Reichweiten-Einschraenkung (A2, D3): Adaptoren und Views erfuellen die
Container-named-requirements NICHT (kein named requirement "ContainerAdaptor" -- HTTP 404;
stack hat kein begin/end, span kein operator== und kein swap). Der VOLLE Kern traegt im
std-Gleichnis nur ueber Set+Sequence; ueber vector+set+stack+span schrumpft der ehrliche
Schnitt auf ~{size(), empty(), Kopie/Zerstoerung}. Folge fuer C7: siehe Abschnitt 4/5.

---

## 2. IST-Abgleich je Genus: Huellen-Signatur real vs. Owner-Soll

### 2.1 Befund-Tabelle (alle Belege A1, HEAD 44bcda99)

| Genus | Huellen-Signatur IST | Element-Typ-Member IST | Owner-Soll (Gattungs-Huelle) |
|---|---|---|---|
| SearchAlgorithm | `template<IsComposition Composition>` (search_algorithm_anatomy.hpp:34-35) | key_type=uint64_t + value_type=uint64_t GETRENNT (:38-39) | Map <Key,Value> |
| Set | `template<class Composition>` (set_anatomy.hpp:103-104) | key_t=value_t=set_organ_t::key_type PRIVATE, "Set: K=V" (:279-280; K=V-Casts :120/:130/:139) | Container <T> |
| Sequence | (sequence_anatomy.hpp:80-81) | element_type=uint64_t (:85) | Container <T> |
| Adapter | (adapter_anatomy.hpp:214-215) | element_type=inner_t::element_type (:219) | Container <T> |
| View | (view_anatomy.hpp:68-69) | element_type=uint64_t (:74) | Container <T> |

BEFUND D2: ALLE 5 Anatomie-Huellen tragen GENAU EINEN Template-Parameter -- die Composition
(das Achsen-Tupel), NICHT Key/Value/T. Das Owner-Gleichnis <Key,Value> vs <T> lebt am Ist NUR
in Typ-MEMBERN (hartkodiert uint64), nicht in der Huellen-Signatur. Die einzigen echten
<T>-Huellen sind die Adapter-Ebene-3-Inner-Substrate: DequeInner<class T=uint64_t>
(adapter_anatomy.hpp:51-53), VectorInner<class T=uint64_t> (:68-70), HeapInner<class T,
class Compare=std::less<T>> (:89-91) -- UNTER dem Adapter-Genus, nicht an der Gattungs-Huelle.
Das Owner-Kriterium "EINE Gattung == EINE Huellen-Template-Signatur" ist damit am Ist als
BAUFORM (K->V getrennt vs. K=V vs. V-indiziert) realisiert, nicht als Signatur.

### 2.2 Set-K=V-Frage EHRLICH beantwortet

Frage (mittags-3-Auslegung): Ist Set am Ist map-artig gebaut, obwohl es per Owner-Modell zur
<T>-Container-Gattung gehoert?

Antwort: NEIN an der Aussenflaeche, JA nur als interner Antriebs-Trick -- und BEIDES ist
std-konform:
- AUSSEN ist Set <T>-foermig: ISetTier fuehrt tier_set_insert(k)/tier_set_contains(k)/
  tier_set_erase(k) EIN-argumentig (set_tier.hpp:40-61); es gibt kein mapped-Value an der
  ABI-Flaeche. Das entspricht exakt std::set: value_type == Key (named_req/AssociativeContainer
  live: value_type = "Key (for std::set and std::multiset only)"; unordered_set: "the value
  type is the same as the key type"). Auch die Signatur-Aritaet stimmt: std::set hat EINEN
  Element-Parameter, Allocator = allocator<Key>.
- INNEN treibt SetAnatomy ein K->V-Organ als MENGE, indem es K=V setzt: insert(k,k)
  (set_anatomy.hpp:120), key_t=value_t (:279-280, Kommentar "Set: K=V (Value-Typ == Key-Typ)").
  Das ist eine Adapter-Bauform ueber map-foermige Organe -- KEIN Terminologie-Fehler und
  KEIN Gattungs-Verstoss, denn die Gattungs-Zugehoerigkeit bemisst sich am AUSSEN-Interface
  und der Huellen-Signatur (Owner-Definition mittags-3), nicht am inneren Substrat.
  std-Praezedenz fuer "Container-Genus ueber fremdem Substrat": stack/queue adaptieren deque.

VERDIKT: Set gehoert zur Container-Gattung; die K=V-Bauform bleibt; nur Kommentar-Klarstellung
noetig (Klasse K1, Abschnitt 6). KEINE Umbau-Auflage fuer C7.

---

## 3. IST->SOLL-Einordnung ALLER implementierten Teile (beide Ebenen) + exakte Diskrepanz

### 3.1 Der Diskrepanz-Kern (exakte Benennung)

D1 -- DER Owner-benannte IST-FEHLER: Die Ebene-1-Kategorie, die semantisch die MAP-Gattung ist
("K -> V Schluessel-Wert-Interface (std::map-artig)", Enumerator-Kommentar), traegt das Etikett
ihres einzigen Genus: `AnatomyGattung::SearchAlgorithm = 0` (anatomy_base.hpp:41).
Folgeschaeden desselben Fehlers:
- gattung_name() liefert den GATTUNGS-String "SearchAlgorithm" (anatomy_base.hpp:47-54, Case :49).
- gattung_of() mappt Genus::SearchAlgorithm auf Gattung::SearchAlgorithm statt Gattung::Map
  (anatomy_base.hpp:100-109, Case :102).
- Der 3-Ebenen-Kommentar formuliert verkehrt "SearchAlgorithm ist eine Gattung MIT einer
  Tier-Unterklasse" (anatomy_base.hpp:36) -- nach NACHTRAG 4: SearchAlgorithm ist das GENUS,
  die Gattung heisst Map.
- DOPPELNAME auf beiden Ebenen: SearchAlgorithm steht als Gattung (:41) UND als Genus (:79)
  im Code -- die Misch-Struktur, die der Owner als "Diskrepanz zwischen der AnatomyGattung
  und der Genus Unterkategorie" meldete.

Der Ebene-2-INHALT ist dagegen KORREKT: `AnatomyGenus { SearchAlgorithm=0, Set=1, Sequence=2,
Adapter=3, View=4 }` (anatomy_base.hpp:78-84) -- alle 5 sind Genera; AnatomyGenus::SearchAlgorithm
bleibt als Name RICHTIG (das Genus heisst so). Auch die eingebaute Gleichnis-Tabelle
(anatomy_base.hpp:62-66: SA->map/multimap/unordered_map, Set->set/..., Sequence->vector/...,
Adapter->stack/..., View->span/...) ist deckungsgleich mit NACHTRAG 4.

D2 -- Huellen-Signatur nur semantisch (Abschnitt 2.1): kein Befund-Fehler des Owners, sondern
eine DEKLARIERTE LUECKE des Ist gegenueber der Gattungs-Definition; C7-Behandlung Abschnitt 5.3.

D3 -- Der Gattungs-Interface-Kern existiert weder als Typ noch als Vererbung: "Genus erbt von
der gemeinsamen Gattung" hat am Ist KEINE Entsprechung. Die 4 Container-Tier-Interfaces sind
bewusst basisklassen-frei und disjunkt (alle untemplatisiert, OHNE gemeinsame Basisklasse, A1-b);
Set weicht sogar im Namensmuster ab (tier_set_*-Praefix durchgehend, set_tier.hpp:40-61,
gegen tier_size/tier_clear bei Sequence/Adapter). Details Abschnitt 4.

### 3.2 Einordnungs-Tabelle: jedes implementierte Teil bezueglich BEIDER Ebenen

| Teil (datei:zeile) | Ebene 2 (Genus) | Ebene 1 SOLL (NACHTRAG 4) | Ist-Etikett-Status |
|---|---|---|---|
| SearchAlgorithmAnatomy (search_algorithm_anatomy.hpp:34-35) | SearchAlgorithm | Map | Gattungs-Zuordnung am Ist "SearchAlgorithm" (via gattung_of :102) = D1 |
| SetAnatomy (set_anatomy.hpp:103-104) | Set | Container | Ebene-1 korrekt (gattung_of); Kommentare nennen Set-GENUS "Gattung" (K1) |
| SequenceAnatomy (sequence_anatomy.hpp:80-81) | Sequence | Container | dito |
| AdapterAnatomy (adapter_anatomy.hpp:214-215) | Adapter | Container | dito; EINZIGE Anatomie mit gattung()-Member (:226) -- Asymmetrie |
| ViewAnatomy (view_anatomy.hpp:68-69) | View | Container | dito |
| SearchAlgorithmAbiAdapter (abi_adapter.hpp:175-176, 2 Parameter <A, ShapeCarrier>) | SearchAlgorithm | Map | static_assert-Text :195 "SearchAlgorithm-Gattung-Anatomie" = Klasse B |
| SetAbiAdapter (set_abi_adapter.hpp:17-18) | Set | Container | Diagnosetext :20 "Set-Gattung-Anatomie" = K1 |
| SequenceAbiAdapter (sequence_abi_adapter.hpp:15-16) | Sequence | Container | Diagnosetext :18 = K1 |
| AdapterAbiAdapter (adapter_abi_adapter.hpp:26-27) | Adapter | Container | -- |
| ViewAbiAdapter (view_abi_adapter.hpp:16-17) | View | Container | Diagnosetext :19 = K1 |
| IDriveableTier (idriveable_tier.hpp:28-46, tier_insert(k,v)/tier_lookup/tier_erase/tier_clear/tier_size) | SA-Antrieb | = de-facto MAP-GATTUNGS-Interface (K/V-Kern) | nirgends "Map" benannt (Klasse C); sachlich passend |
| IObservableTier (observable_tier.hpp:185-201) | SA-Observe | Map (Mess-Flaeche) | "Gattungs-API"-Wortung :8/:176 = Klasse C |
| ISetTier (set_tier.hpp:40-61) | Set | Container-GENUS-Interface | Kopf :2/:6/:8/:38 "Gattung" = K1 |
| ISequenceTier (sequence_tier.hpp:34-52) | Sequence | Container-Genus-Interface | :2/:32 = K1 |
| IAdapterTier (adapter_tier.hpp:51-70) | Adapter | Container-Genus-Interface | :48 attributiert Genus-Interface als "Sub-Interface der CONTAINER-Gattung" = Klasse C (Hybrid) |
| IViewTier (view_tier.hpp:32-47; bewusst KEIN clear/insert/erase :30-31) | View | Container-Genus-Interface | :2/:30 = K1 |
| Permutation-Engines: search_algorithm_/set_/sequence_/adapter_/view_permutation_engine.hpp | je Genus | SA->Map; Rest->Container | Gattungs-Wort-Treffer siehe 3.3; adapter_permutation_engine.hpp:84 traegt korrekt gattung=Container |
| Docks: pruef_dock_registry(_default).hpp + set_dock.hpp usw. | 5 Genus-Docks | SA-Dock->Map; 4->Container | "fuenf Ebene-2-Gattungen" (pruef_dock_registry.hpp:2,:4-8,:12; _default.hpp:33/:35/:37) = Hybrid K1 |
| GenusBindingTraits (genus_binding_traits.hpp; :69 gattung=Container nur bei Adapter) | je Genus | wie oben | :17-19/:29/:89/:91/:116/:118/:141/:165-166 "Gattung(en)" = K1; Traits-Asymmetrie (nur Adapter traegt Ebene 1) |
| container_framework.hpp (ContainerType :45-46, type_list :50-53, type_traits :63-81, Asserts :85-99) | -- (Ebene-1-Keim) | Container-Gattungs-Kopf = C7-Vorlage | Assert-INHALT :90-91 richtig (!ContainerType<SA>), Assert-TEXT falsch ("SearchAlgorithm ist eine EIGENE Gattung" -- muss: Genus der Gattung Map); Kommentar :49 "Reihenfolge = Enum-Reihenfolge" faktisch falsch (Adapter vor Set/Sequence) |
| AnatomyExecutionContext-SA-Auslagerung (search_algorithm_anatomy.hpp:174-186) | SearchAlgorithm | Map | -- |
| FK-8-Fehlerklassen (axis_error.hpp:58-59 + CSV :128-129) | Genus-Bau-Bindung | betrifft GENUS-Ebene | Namen "Gattungs*" fuer Genus-Sachverhalt = Sonderfall K3 (Abschnitt 6) |
| Graph (anatomy_base.hpp:43 Enumerator + genus_binding_traits.hpp:8 Erwaehnung; genus_build_admission.hpp:15/:101/:190-192 [SYN]) | KEIN Genus | Graph = STUB | deckungsgleich NACHTRAG 4; admit_gattung_build_path weist Graph constexpr ab = korrekte Stub-Wache |
| IAnatomyBase (anatomy_base.hpp:167) | Wire-Identitaet | transportiert NUR genus(), KEIN gattung() | Ebene 1 ist der Wire-Flaeche unbekannt -- C7-relevant (5.6) |

### 3.3 Terminologie-Fehler-Liste (vollstaendig aus A1-e, mit datei:zeile)

KLASSE A -- Genus als "Gattung" etikettiert (47 Code-Treffer, reine Prosa/Diagnosetexte):
set_anatomy.hpp:2,:17,:48,:117; set_tier.hpp:2,:6,:8,:38; sequence_anatomy.hpp:2,:7,:40,:86,:94,:120;
sequence_tier.hpp:2,:32; view_anatomy.hpp:2,:37,:75,:83,:101; view_tier.hpp:2,:30;
set_abi_adapter.hpp:20; sequence_abi_adapter.hpp:18; view_abi_adapter.hpp:19;
set_permutation_engine.hpp:40,:48,:59,:71,:77; sequence_permutation_engine.hpp:37,:56,:68,:74;
view_permutation_engine.hpp:37,:56,:68,:74,:106; adapter_permutation_engine.hpp:52,:91,:98;
set_composition.hpp:15; set_default_organ.hpp:3; cross_genus_organ.hpp:38;
organ_concept.hpp:122,:130,:138,:150,:275; topics/sequence/axis_growth/axis_growth_policies.hpp:2;
topics/view/view_policies.hpp:2; include/cache_engine/abi/adapter_module_abi_v1.hpp:5;
genus_binding_traits.hpp:17,:18,:19,:29,:89,:91,:116,:118,:141,:165,:166.

KLASSE B -- SA/Map-Vermischung + "5 Gattungen"-Zaehlweise (nach NACHTRAG 4: 3 Gattungen, 5 Genera):
anatomy_base.hpp:8,:36,:41,:49,:102,:111,:166 (genus()-Doku nennt die 5 Genera "Anatomie-Gattung
(Saeugetier/Vogel/Reptil/Wirbelloses/Pflanze)"),:169; abi_adapter.hpp:20,:128,:132,:195,:221,:884;
search_algorithm_anatomy.hpp:48; search_algorithm_permutation_engine.hpp:45,:56,:97,:119;
container_framework.hpp:44,:91; pruefling_merge.hpp:45,:69;
include/cache_engine/abi/anatomy_module_abi_v1.hpp:81; compositions/prt_art_merge_reference.hpp:204,:212;
axes/lookup/composable/surf_fst_map_pool_concept.hpp:10; "5/fuenf Gattungen"-Zaehlung:
execution_engine_base.hpp:14, organ_concept.hpp:74,:92,:484, set_anatomy.hpp:273,
adapter_permutation_engine.hpp:8, anatomy_base.hpp:31.

KLASSE C -- Gattungs-Wort an Ebene-1-nahen Interfaces ohne Map-Namen / Genus-Interface als
Gattungs-Interface attributiert: idriveable_tier.hpp:2,:7,:23; abi_adapter.hpp:884;
observable_tier.hpp:8,:176; adapter_tier.hpp:3,:48; pruef_dock_registry.hpp:2,:4-8,:12;
pruef_dock_registry_default.hpp:33,:35,:37; set_dock.hpp:2,:5-7,:41,:52-53,:62,:91-95.

SONDERFALL FK-8 (Log-reisend): CompilerCompilerErrorClass::GattungsBindungFehlt=5 /
GattungsSlotAritaet=6 (axis_error.hpp:58-59) + CSV-Etiketten "gattungs_bindung_fehlt"/
"gattungs_slot_aritaet" (:128-129); Kommentar :52 "die vier Container-Gattungen".
Etiketten UND Nummern reisen in Experiment-Logs (RF-3-Auflage, axis_error.hpp:55-57 +
machine_identity.hpp:529).

HISTORIE: Die Genus-als-Gattung-Etiketten stammen aus der Vor-Doc-30-Aera (D9/D10/D11
2026-06-02); die "Vokabular-Bruecke" (anatomy_base.hpp, F1a-Block vor dem AnatomyGenus-Enum
[SYN]) hat die Zwei-Namen-Realitaet bereits dokumentiert -- sie ist nach NACHTRAG 4 in der
Richtung zu aktualisieren (User-"Gattung" meinte Ebene 2; das FINALE Modell vergibt "Gattung"
an Ebene 1 mit Map/Container/Graph).

---

## 4. IST-KERN vs. C++-KERN (Container-Gattungs-Interface-Herleitung)

### 4.1 Was am Ist beweisbar gemeinsam ist

Ueber ALLE 5 Genera (compile-beweisbar): NUR Identitaet + Beobachtung.
OrganConcept = AnatomyConcept (composition_t / composition_name() / paper_id() / organ_count()
/ genus(), anatomy_base.hpp:120-127) + OrganObservable (observe_all() noexcept)
(organ_concept.hpp:61-78: "Genau diese Schnittmenge ist am heutigen Ist ueber alle fuenf
Gattungen beweisbar"). Zusaetzlich alle 5: observable_axis_count() + per-Slot-Organ-Accessoren.

Op-Verb-Schnittmenge ueber alle 5 = LEER (organ_concept.hpp:92-101: "Selbst size() ist NICHT
gemeinsam (SA hat keins), clear() erst recht nicht (SA und View haben keins). Ein
vereinheitlichtes Op-Verb waere deshalb ERFUNDEN, nicht erhoben -- und genau das ist untersagt.").

Ueber die 4 CONTAINER-Genera (die C7-relevante Menge):
- In-process (Anatomie-Ebene): size() 4/4 (OrganSized, organ_concept.hpp:112-116);
  clear() 3/4 (OrganClearable :118-120, View fehlt bewusst -- non-owning);
  Schreib-/Lese-Verben je Genus DISJUNKT (insert/contains/erase vs push_back/at vs
  put/push/pop_* vs bind/read); die 4 Container-Genera teilen observe_axes() (C3).
- Tier-/ABI-Ebene: literal-gleiche Namen tier_size/tier_clear nur bei Sequence+Adapter
  (+View tier_size); Set prefixt ALLES mit tier_set_ (set_tier.hpp:40-61); Observe-Ops
  4x verschieden benannt UND typisiert (SetObserverSnapshotV1 usw.). Kein gemeinsames
  Basis-Interface (A1-b: alle untemplatisiert, OHNE gemeinsame Basisklasse).

IST-KERN Container-Gattung (ehrlich erhoben): { Identitaet (AnatomyConcept), observe_axes/
observe_all, size } + { clear } nur als 3/4-Block. C1 hat dafuer bereits die ehrliche Form
gebaut: OrganOpSurface = EIN Name ueber 5 DISJUNKTE Concepts (KeyedOrganOps :124,
IndexedOrganOps :132, AdaptedOrganOps :141, BoundViewOrganOps :152, AxisOrganAccessOps :180;
Disjunktheits-Beweis organ_op_family_count()==1; organ_concept.hpp:484-495).

### 4.2 Abgleich mit den Container-named-requirements

| named-req-Kern (A2) | Ist der 4 Container-Genera | Verdikt |
|---|---|---|
| size()/empty() | size 4/4 (Anatomie) bzw. tier_*size 4/4 (Tier, Namen uneinheitlich) | KERN-tauglich; empty ableitbar (size()==0; std definiert empty()==(begin()==end()), am Ist ohne Iteratoren via size) |
| begin()/end()/Iteratoren | existiert an KEINER der 5 Flaechen | NICHT erfinden (organ_concept.hpp:92-101-Verbot); deklarierte Luecke -- std-Praezedenz: stack/span erfuellen den vollen Kern auch nicht |
| ==/swap/Kopie | keine Gattungs-Flaeche am Ist | dito deklarierte Luecke (span hat std-seitig auch kein ==/swap) |
| clear/insert/erase | NICHT im std-Kern; am Ist clear 3/4 | wie std: als OPTIONALER Block fuehren, nicht als Kern |
| value_type | std-Kern: value_type=T; Ist: element_type bei Sequence/Adapter/View, key_t/value_t privat bei Set | vereinheitlichbar als Gattungs-Typ-Member (5.3) -- reine Addition |

SCHLUSS: Der std-Befund (voller Kern nur ueber Sequence+Set; ueber Adaptoren/Views schrumpft
er auf size/empty/Lebenszyklus) DECKT den Ist-Befund (size 4/4, clear 3/4, Rest disjunkt).
Das Owner-Modell "teilidentisches Interface = mathematischer Kern" ist am Ist also mit
GENAU dem Kern einloesbar, den der Standard selbst fuer eine derart breite Gattung hergibt:
klein + gestufte optionale Bloecke. Ein breiterer Kern waere ERFUNDEN.

---

## 5. C7-FORMGEBUNGS-AUFLAGEN (S12.3 Option A, comdare::container-Kopf-Framework)

Rahmen: E24-Bauplan 1.6 = OPTION A (Genera bleiben; die GATTUNG wird ABI-Flaeche ueber dem
type_traits-Re-Export container_framework.hpp:60-80; Major bleibt derselbe -- die Promotion
IST der Major). Die folgenden Auflagen formen C7 auf dem FINALEN Modell Map/Container/Graph.

- AUFLAGE C7-1 (Ebene-1-Umbenennung VOR dem Freeze, im C7-Fenster): AnatomyGattung::
  SearchAlgorithm -> AnatomyGattung::Map (anatomy_base.hpp:41), gattung_name()-Case
  "SearchAlgorithm" -> "Map" (:49), gattung_of()-Case (:102), 3-Ebenen-Kommentar (:36) und
  Vokabular-Bruecke nachziehen. [SYN]-Beweis der Machbarkeit: gattung_name() hat am HEAD
  NULL Aufrufer repo-weit (libs/src/tools/include); AnatomyGattung wird ausschliesslich an
  compile-time-Flaechen verwendet (9 Dateien: container_framework.hpp:5/:12/:21/:25/:27/:46/
  :67/:98-99, adapter_anatomy.hpp:3/:28/:226, adapter_permutation_engine.hpp:37/:84,
  adapter_execution_context.hpp:68, genus_build_admission.hpp:15/:101/:190-192,
  pruef_dock_version.hpp:63, genus_binding_traits.hpp:69, abi_adapter.hpp:2114, anatomy_base.hpp);
  IAnatomyBase transportiert KEIN gattung() (anatomy_base.hpp:167). Die Umbenennung ist HEUTE
  source-only -- NACH C7 (Gattung ABI-sichtbar) waere sie ABI-Bruch. Deshalb MUSS sie im
  C7-Fenster VOR der Sichtbar-Machung landen, sonst friert C7 das falsche Etikett ein.
- AUFLAGE C7-2 (Kern als Ebene-1-Interface, ERHOBEN statt erfunden): Das Kopf-Framework formt
  den Container-Gattungs-Kern als { Identitaet + observe_axes + size } mit clear als
  gestuftem optionalem Block (View-Ausnahme deklariert, D2-Doktrin: leere Spalte MIT Grund);
  KEIN vereinheitlichtes Schreib-/Lese-Op-Verb (organ_concept.hpp:92-101-Verbot); die
  disjunkten Genus-Op-Familien (OrganOpSurface, C1) bleiben die Genus-Erweiterungen ueber
  dem Kern -- exakt "Genus erbt von der gemeinsamen Gattung, Genus erweitert" (NACHTRAG 4)
  im std-Muster Kern+optionale Bloecke (A2). Bestehende Asserts fortschreiben: type_count==4
  bleibt; !ContainerType<SearchAlgorithm> bleibt INHALTLICH, TEXT korrigieren zu
  "SearchAlgorithm ist ein Genus der Gattung Map, kein Container-Typ" (container_framework.hpp:90-91).
- AUFLAGE C7-3 (einheitliche <T>-Huellen-Signatur als Gattungs-Typ-Ebene): Da alle Anatomien
  <Composition>-parametrisch sind (D2), wird die Owner-Huellen-Signatur <T> in C7 als
  GATTUNGS-TYP-VERTRAG geformt, nicht als neuer Template-Parameter: type_traits<G> erhaelt
  element_type (Ist: uint64_t bei Sequence/View, inner_t::element_type beim Adapter,
  set_organ_t::key_type beim Set) + static_assert, dass alle 4 Container-Genera denselben
  element_type tragen (am Ist uint64_t -- der Fixpunkt ist die INSTANZIIERTE Gattungs-Huelle
  T=uint64_t). Das ist reine Addition (kein ABI, kein golden). Eine ECHTE
  Element-Typ-Parametrisierung (T als Template-Parameter der Huellen) waere Scope-Erweiterung
  des Fensters und ist NICHT gedeckt -> als deklarierte Luecke + offener Entscheid fuehren (7).
- AUFLAGE C7-4 (SA-Sonderrolle / Map-Gattung): SA bleibt ausserhalb von ContainerType (Assert
  bleibt). Die Map-Gattung braucht in C7 KEIN eigenes Kopf-Framework (nur 1 Genus; eine
  Schnittmenge ueber 1 Element ist das Element selbst): IDriveableTier (tier_insert(k,v)/
  tier_lookup/tier_erase/tier_clear/tier_size, idriveable_tier.hpp:28-46) IST der de-facto
  Map-Gattungs-Kern und wird in Doku/Diagnosetexten als solcher BENANNT (Klasse-C-Heilung);
  das SA-Typ-Member-Paar key_type/value_type (search_algorithm_anatomy.hpp:38-39) ist die
  <Key,Value>-Instanz (beide uint64). Ob die Mess-Flaeche (IObservableTier + die SA-Zusatz-
  Subinterfaces) zum Map-Gattungs-Kern gehoert, ist NICHT kartiert -> offener Entscheid (7).
- AUFLAGE C7-5 (Set-K=V): bleibt unveraendert (std-konform, Abschnitt 2.2); nur
  Kommentar-Klarstellung "Genus Set der Gattung Container; internes K=V-Substrat".
- AUFLAGE C7-6 (Wire-Flaeche): IAnatomyBase transportiert nur genus(); die Ebene-1-Zuordnung
  ist daraus via constexpr gattung_of() ableitbar. C7 soll die Gattung ABI-sichtbar machen,
  OHNE einen neuen Wire-String einzufrieren: bevorzugt Ableitung host-seitig aus genus()
  (kein neues ABI-Feld); falls doch ein gattung()-Wire-Member kommt, dann als uint8 (Enum-Wert)
  NACH der C7-1-Umbenennung -- nie der String.
- AUFLAGE C7-7 (Nebenbefunde mitziehen): container_framework.hpp:49 Kommentar "Reihenfolge =
  Enum-Reihenfolge" korrigieren (Liste beginnt mit Adapter=3 vor Set=1/Sequence=2); stale
  Versions-Kommentar container_framework.hpp:15-25 ("Version 4->5", Ist 7->8 per LEDGER:3731,
  E24-Bauplan:64); Traits-/Member-Asymmetrie heilen: gattung an ALLEN 4 Container-Genera
  einheitlich (heute nur AdapterAnatomy::gattung() :226 und GenusBindingTraits<Adapter> :69).
- AUFLAGE C7-8 (Fixture-Nachzug einplanen): [SYN] 7 Test-Dateien verwenden AnatomyGattung/
  gattung_of literal (test_29_container_framework.cpp, test_container_genus.cpp,
  test_striktheit_metaprog_guard.cpp, test_e24_c2_adapter_permutation_engine.cpp,
  test_e24_c3_adapter_anatomy.cpp, test_e24_c5_fk8_genus_baupfad_d1.cpp,
  test_genus_permutation_engines.cpp); 21+ Test-Dateien enthalten das Wort "Gattung".
  Doktrin "Gruene Tests zementieren alte Ordnung": der Umbenennungs-Commit MUSS den
  Fixture-Sweep enthalten (Liste aus Diff ableiten, nie handgepflegt).

---

## 6. KORREKTUR-KLASSEN je Fund (mit Fenster-Zuordnung)

| # | Fund | Klasse | Fenster |
|---|---|---|---|
| K1 | Klasse-A-Etiketten (47 Treffer, 3.3) + Klasse-B-Kommentare/-Zaehlweisen + Klasse-C-Attributionen + anatomy_base.hpp:36 + Vokabular-Bruecke + static_assert-DiagnoseTEXTE (set/sequence/view_abi_adapter, abi_adapter.hpp:195, container_framework.hpp:91) + pruef_dock/set_dock-Wortungen + axis_error.hpp:52-Kommentar | Prosa/Kommentar-only -- compile-neutral, golden-neutral, ABI-neutral | SOFORT mitziehbar (jede Welle); spaetestens im C7-Commit als Sammel-Pass |
| K2 | AnatomyGattung::SearchAlgorithm -> Map + gattung_name()-String + gattung_of()-Case (anatomy_base.hpp:41/:49/:102) inkl. 9 Verwendungs-Dateien + 7 Test-Fixtures | Code-Umbenennung -- source-sichtbar, aber [SYN]-verifiziert OHNE Wire-Exposition am HEAD (gattung_name 0 Aufrufer; kein gattung() in IAnatomyBase; alle Verwendungen compile-time) | C7-Fenster, zwingend VOR der Ebene-1-ABI-Sichtbarmachung (danach waere es ABI-Bruch) |
| K3 | FK-8: Klassen-NAMEN GattungsBindungFehlt/GattungsSlotAritaet (axis_error.hpp:58-59) + CSV-Etiketten gattungs_bindung_fehlt/gattungs_slot_aritaet (:128-129) | ABI-/Log-relevant -- Etiketten UND Nummern reisen in Experiment-Logs (RF-3, axis_error.hpp:55-57 + machine_identity.hpp:529); Umbenennung = deklariertes Ereignis | NUR im offenen E-24-Fenster UND nur als deklariertes Ereignis; Nummern 5/6 NIE aendern; ob die CSV-Etiketten umbenannt oder belassen werden = offener Entscheid (7) |
| K4 | element_type-Vereinheitlichung als Gattungs-Typ-Vertrag (C7-3) + gattung-Member-Symmetrie (C7-7) | Reine Addition (neue Traits/Asserts, kein Bestand bricht) | C7-Fenster (Teil der Formgebung) |
| K5 | Echte <T>-Template-Parametrisierung der Huellen (Owner-Signatur syntaktisch) | ABI-/golden-relevant, Scope-Erweiterung -- NICHT gedeckt | NICHT in diesem Fenster; eigener Owner-Entscheid (7) |

Merkposten zur Abgrenzung: AnatomyGenus::SearchAlgorithm und genus_name()-String
"SearchAlgorithm" sind Ebene 2 und bleiben KORREKT -- KEINE Korrektur (NACHTRAG 4).

---

## 7. OFFENE ENTSCHEIDE (nur echtes NICHT-GEFUNDEN; keine stille Scope-Erweiterung)

1. FK-8-CSV-Etiketten (K3): "gattungs_bindung_fehlt"/"gattungs_slot_aritaet" umbenennen zu
   genus_*-Formen (deklariertes Ereignis im offenen Fenster) ODER belassen
   (Bestandslog-Kontinuitaet) mit reiner Kommentar-Heilung -- aus NACHTRAG 4 nicht ableitbar;
   Owner-/Manager-Entscheid.
2. Map-Gattungs-Kern-Reichweite: Die SA-Zusatz-Subinterfaces (IResourceControllableTier,
   IAllocatorProxyTier, IRollbackableTier, IMigratableTier, IScannableTier,
   IMeasurableWorkload/V2/V3; nur als Vererbungsliste erhoben, abi_adapter.hpp:177-192) sind
   verb-seitig NICHT kartiert -- ob C7/Doku die Mess-Flaeche in den Map-Gattungs-Kern hebt,
   ist offen.
3. Echte Element-Typ-Parametrisierung <T>/<Key,Value> der Anatomie-Huellen (K5): eigener
   Owner-Entscheid nach Abgabe/eigenem Fenster; C7 fuehrt sie als deklarierte Luecke
   (T=uint64_t-Fixpunkt = instanziierte Gattungs-Huelle).
4. Repo-weiter Graph-Sweep ausserhalb der Anatomy-Flaeche (topics/axes/builder + CMake/XML/
   Codegen: anatomy_codegen_tool, buildsystem-XML, permutation_axes.xml) steht aus --
   NACHTRAG-4-Klausel "Sofern doch etwas implementiert ist, muss das ... eingeordnet werden";
   am Anatomy-Ist ist Graph beweisbar Stub (anatomy_base.hpp:43; genus_build_admission.hpp:
   190-192 weist Graph constexpr ab [SYN]).
5. Voll-Sweep tests/ + docs/architecture auf Gattungs-Etiketten: [SYN] liefert die Zaehlung
   (7 Dateien AnatomyGattung-literal, 21+ mit "Gattung"), aber keine zeilen-genaue
   Fixture-Karte -- im C7-Umbenennungs-Commit aus dem Diff abzuleiten.
6. Ob ein eigenes Map-Kopf-Framework (Pendant zu container_framework.hpp) gewuenscht ist:
   NACHTRAG 4 verlangt die EINORDNUNG, nicht zwingend ein Framework; Default dieser Synthese =
   nur Benennung/Doku (C7-4), kein Bau -- Bestaetigung durch Manager/Owner ausstehend.
7. Line-Drift-Hygiene: Ledger-/Dossier-Referenzen auf prae-C3-Zeilen (z.B. set_anatomy.hpp:81-82,
   heute :279-280) beim C7-Formgebungs-Dossier nachziehen (Buchhaltung, kein Code).

---
ENDE DOSSIER. Read-only-Erhebung; keine Code-Aenderung, kein Commit, kein Build.
