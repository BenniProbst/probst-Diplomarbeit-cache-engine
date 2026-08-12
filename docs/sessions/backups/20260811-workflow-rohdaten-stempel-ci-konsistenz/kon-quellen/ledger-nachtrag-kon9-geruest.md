## NACHTRAG 11.08.2026 NACHTS — KON9: DIE STEMPEL-ARCHITEKTUR, KONSOLIDIERT GEGEN KON7/KON8

**Dieser Nachtrag schreibt KON7, KON8 und KON8-12 FORT und korrigiert sie an drei Stellen.**
Er entsteht aus einem Owner-Dialog, der nach KON8 weiterlief und dessen Antworten Teile von KON8
praezisieren. Wo eine Aussage von KON7/KON8 faellt, steht sie hier mit ihrer Korrektur — die alte
Fassung bleibt dort stehen (Doku wird deprecatet, nicht geloescht).

---

### KON9-01 — 🔴 ORT UND ZEIT SIND ZWEI ORDNUNGEN. MEINE VERMENGUNG WAR EIN FEHLER.

**Owner verbatim:** *„Doch der Hybrid wird bei den **Traegern vor das Tier-Binary eingefuegt wie
gehabt**, aber **zeitlich erst nach dem einzel-Messungs-Durchlauf der Tier-binaries erzeugt** und
dann eingeschoben angewendet. Bitte **trenne zeitliche Abfolge von ORT**."*

    ORT   (Traeger-Ordnung, Vertragskomplex)
          Planer ──▶ CEB ──▶ HYBRID ──▶ Tier
          Der Hybrid steht VOR dem Tier. Das ist die Ordnung, aus der die PHASIGKEIT folgt.

    ZEIT  (Erzeugung)
          Tier-Binaries bauen ──▶ EINZELMESSUNG ──▶ Hybrid erzeugen ──▶ einschieben ──▶ anwenden
          Der Hybrid entsteht ZULETZT, weil seine Bereichskarte die Einzelmess-Kurven braucht.

**Mein Fehler, protokolliert:** ich hatte aus *„das hybrid wird nach den Tier-Binaries und der
Einzelmessung erzeugt"* geschlossen, der Hybrid stehe **nicht** vor dem Tier — und damit meine
eigene, richtige F1-Ableitung zurueckgenommen. **Beides gilt zugleich.** Fehlerklasse: dieselbe wie
am 11.08. mittags bei *„Lager-Ordnung = Stufen-Ordnung"* — **eine Ordnung fuer die andere genommen**.
Das ist der zweite Beleg derselben Klasse an EINEM Tag.

**Regel, die daraus folgt:** bei jeder Reihenfolge-Aussage ueber dieses System ist zu benennen,
**welche Ordnung** gemeint ist. Es gibt mindestens vier, und sie stimmen nicht ueberein:
Traeger-Ordnung (ORT) · Erzeugungs-Ordnung (ZEIT) · Lager-Kaskaden (zwei, je Realm, D-12) ·
Stempel-Zeilen-Ordnung (System vor Organ).

---

### KON9-02 — DER HYBRID IST NICHT STEMPELFREI. ER IST SELBST EIN GENUS MIT FLAECHE 2.

**Owner verbatim:** *„er ist **nicht stempelfrei**, weil er **selbst ein Genus mit Flaeche 2** ist,
aber **zusaetzlich** zu seinen eigenen Mess/System/Organ Achsen **zur Laufzeitanfrage** die
**Eigenschaften seiner Parameterfunktionen** (bzw. die Funktion selbst als string mit deren
Parametern im System) und die **Stempel seiner Tier-Binaries** […] durchgereicht werden."*

    HYBRID-FLAECHE 2, DREI ANTEILE:
      (1) EIGENE Mess/System/Organ-Achsen   -- wie jedes Genus, im Stempel
      (2) die Eigenschaften seiner PARAMETERFUNKTIONEN  -- ZUR LAUFZEITANFRAGE
          bzw. die Funktion SELBST als String mit ihren Parametern im System
      (3) die STEMPEL SEINER TIER-BINARIES              -- ZUR LAUFZEITANFRAGE durchgereicht

**Die Trennung, an der alles haengt:** (1) ist **Stempel** (compile time, in der Binary).
(2) und (3) sind **Laufzeitanfrage** — sie werden **durchgereicht**, nicht eingebrannt. Das ist
dieselbe Trennung wie bei der CEB (KON8: zwei System-Anzeigen, compile-time in den Stempel /
Laufzeit in die Freigabe).

**Meine IST-Messung bleibt richtig, mein Schluss war falsch:** `libs/cache_engine/hybrid/` traegt
heute vier Header (`heuristik_adapter_gate` 189 Z. · `klassifikation` 256 · `strategy` 246 ·
`synthese_matrix` 252 = **943 Zeilen**) und **0 Treffer** fuer `version_stamp|fingerprint` in
**4 von 4** Dateien. Das misst den **Bestand**, nicht das **SOLL**. *(Nebenbefund: der Wellenplan
sagt bis heute `git ls-tree origin/development libs/cache_engine/hybrid/` = „genau `README.md`" —
diese Zeile ist **ueberholt** und im Wellenplan nachzuziehen.)*

---

### KON9-03 — DER HYBRID IST EIN TRANSPARENTER MULTIPLEXER, KEINE FREIGABE-STUFE

**Owner verbatim:** *„Der Hybrid ist in all seinen Lebenslagen **transparent** und ein steuerbarer
**Multiplexer-Handlanger der CEB** (die nur **EIN Pruefdock** hat), um virtuell gesteuert zu
bestimmten Zustaenden verschiedene Tier-Binaries schalten zu koennen. Hybrid setzt also selbst die
CEB Freigaben um und **reicht sie dann weiter durch**, sodass hybrid nur die Tier-Binaries andocken
kann, zu deren **Spezifikations-Teilmenge es selbst gebaut wurde**."*

Und weiter: *„die CEB baut das Hybrid und jede Tier-Binary **gleichrangig**, das **Hybrid kann
nicht bauen**, sondern nur Tier-Binaries **messen** die schon gebaut sind. Daher sind Hybrid und
Tier-binary **gleich auf** und das Hybrid ein **unabhaengiges Stecksystem**, das Tier-Binaries als
»**Verteiler-Dose**« halten kann."*

    Die CEB hat GENAU EIN Pruefdock.
    Sie baut GLEICHRANGIG:  Tier-Binaries  und  Hybrid.
    Das Hybrid BAUT NICHT. Es MISST bereits gebaute Tier-Binaries.
    Es ist TRANSPARENT: es reicht die CEB-Freigabe durch, es verengt sie nicht.

**Die Unabhaengigkeit der Optimierung, ausdruecklich:** *„Hybrid kann **staerkere oder schwaechere**
Hardware Optimierungen als seine Tier-Binaries fahren und umgekehrt, **beide sind unabhaengig**"* —
weil beide unmittelbar von der CEB gebaut werden und beide maximal die Spezifikation der
System-Achsen-Freigabe erreichen, jeder fuer sich.

**Die EINE Bindung, die zaehlt:** *„das Hybrid **muss passend zu den Genus-Interfaces seiner
Tier-Binaries** gebaut werden und **das ist alles was zaehlt**."*
⇒ Die Kopplung Hybrid↔Tier ist eine **Interface-Kopplung** (Flaeche 1), **keine
Hardware-Spezifikations-Kopplung** (Flaeche 2). Wer sie auf der Hardware-Seite sucht, sucht falsch.

**Damit ist meine Frage (C) beantwortet und ihre Praemisse widerlegt:** der Hybrid ist **keine
zweite Freigabe-Stufe**. Die Teilmengen-Pruefung im Hybrid-Zweig laeuft also **nicht zweimal** —
sie laeuft einmal, und die Andock-Bedingung ist eine **Genus-Interface-Passung**.

---

### KON9-04 — DREI GRAMMATIKEN, GESCHNITTEN NACH PHASIGKEIT

**Owner verbatim:** *„Bitte zu (A) **zwei Grammatiken fuer DREIPHASIG und VIERPHASIG und eine
Grammatik fuer ZWEIPHASIG**."*

    ZWEIPHASIG   System/Organ ohne Hybrid          ──▶  EINE Grammatik
    DREIPHASIG   Mess ohne Hybrid                  ──▶  eigene Grammatik
                 System/Organ MIT Hybrid
    VIERPHASIG   Mess MIT Hybrid                   ──▶  eigene Grammatik

**Meine Frage war falsch gestellt.** Ich hatte gefragt, ob die zwei heute existierenden Grammatiken
(Flag-Grammatik v2 in `algo_semver.hpp` gegen die bvset-Grammatik in `bvset_teilmenge.hpp`)
zusammengefuehrt werden. Der Schnitt laeuft **nicht** entlang der heutigen Dateien, sondern entlang
der **Phasigkeit** — also entlang der Zahl der Traeger-Stufen, die eine Freigabe durchlaufen muss.

**Was daraus fuer den Bau folgt:** die Grammatik ist **kein Merkmal der Achse**, sondern ein
**Merkmal der Kette**, die sie durchlaeuft. Dieselbe Organ-Achse traegt im reinen Tier-Zweig
(zweiphasig) eine andere Grammatik als im Hybrid-Zweig (dreiphasig).

---

### KON9-05 — DIE ORDNUNGS-RELATION UEBER FLAG-MENGEN IST BESTAETIGT UND WEITER GEFASST

**Anlass:** ich hatte gemessen, dass die Flag-Grammatik v2 zwar eine vollstaendige **Syntax**
(R1–R8, **295 `static_assert`**, 238 Parse-Stellen) und eine vollstaendige **Taxonomie**
(`HardwareBasis` · `HardwareUnterklasse` · `BreitenSubset` · `MedienSubset`) traegt, aber **keine
Ordnung** — `BreitenSubset` sagt *„`vl` gehoert zur Breiten-Familie"*, nicht
*„`x512{f.vl}` ⊆ `x512{f.vl.bw}`"*. Gegenprobe gefahren: `teilmenge`/`dominiert`/`ist_hoeher` =
0 Treffer in beiden Dateien, `constexpr` 54 bzw. 21, `static_assert` 295 — die Null traegt.

**Owner verbatim:** *„Aber **genau das ist richtig und muss festgehalten werden**. Es gilt fuer den
**gesamten Satz an Hardware, den ein Rechner fahren kann**. Und aus dem Fakt, dass eine Organ-Achse
die Hardware eines Rechners nutzen **KANN**, aber nicht alles nutzen **MUSS**, ergibt sich, dass die
gewaehlten **Achsen-Algorithmen** auch einen **Hardware-Spezifikations-Stempel mit Versionsnummer
X.Y.Z mit voller System-Achsen-Syntax und Semantik** unterstuetzen muessen."*

    (1) DIE ORDNUNG GILT:      x512{f.vl}  ⊆  x512{f.vl.bw}
    (2) IHR GEGENSTAND IST:    der GESAMTE Hardware-Satz, den ein Rechner fahren kann
                               -- nicht nur die Flags eines einzelnen Algorithmus
    (3) DIE ABLEITUNG:         Organ-Achse KANN die Hardware nutzen, MUSS aber nicht alles nutzen
    (4) DIE FOLGE:             jeder Achsen-Algorithmus traegt einen eigenen
                               HARDWARE-SPEZIFIKATIONS-STEMPEL  X.Y.Z
                               in VOLLER System-Achsen-Syntax UND SEMANTIK

**Das ist der praezise Bauauftrag hinter KON8-08** („Basis-Flags haben alle Achsen-Kategorien"):
nicht nur die Basis, sondern die **volle** System-Achsen-Grammatik, und **mit Semantik** — also
mit der Ordnungs-Relation, die heute fehlt.

**Und es erklaert, warum sie fehlen durfte:** solange kein Algorithmus mehr als `c` trug, brauchte
niemand eine Ordnung. Der IST-Bestand (rund **137** ce-eigene Flag-Literale, alle genau `c`) ist
damit kein Zufall, sondern der Zustand **vor** dieser Festlegung. *(Die Zahl 137 stammt aus einem
Agentenbericht vom 11.08. und ist im laufenden Explore zur Neuerhebung mit eigener Zaehlweise
aufgegeben — sie ist hier NICHT als eigene Messung gefuehrt.)*

---

### KON9-06 — 🔴 DIE FILTERKETTE IST DER SELBSTKOMPILATIONS-MECHANISMUS

**Owner verbatim:** *„Die Filterkette ist ein **C++23 concept zur compile time von mp11** und zur
Laufzeit wird auf der **CEB** die **hardware analysiert und gegen die Organ-Achsen freigegeben**.
Die Filterkette ist also ein **concept fuer einen Vertrag einer freigebenden Seite gegen ein compile
time Ziel je Phasigkeit**, wobei **nur bestimmte concept builds zur Laufzeit eines niederen Traegers
den compile eines hoeheren Traegers bilden duerfen**. Es ist also der **Mechanismus der
Selbstkompilation aus C++ Binaries heraus** (nur cmake erlaubt, keine Skripte erlaubt). **Du hattest
das schon entworfen.**"*

    compile time :  C++23 concept, gebaut mit BOOST.MP11
    Laufzeit     :  die CEB analysiert die HARDWARE und gibt gegen die ORGAN-ACHSEN frei
    Vertrag      :  concept einer FREIGEBENDEN Seite gegen ein COMPILE-TIME-ZIEL,
                    JE PHASIGKEIT eines
    Bedeutung    :  nur bestimmte concept-builds zur LAUFZEIT eines NIEDEREN Traegers
                    duerfen den COMPILE eines HOEHEREN Traegers bilden
    Klasse       :  SELBSTKOMPILATION aus C++-Binaries heraus.
                    NUR CMake. KEINE Skripte. (deckt sich mit der stehenden No-Skript-Doktrin)

**Damit ist die Filterkette kein Nebenbau, sondern der Kern der ganzen Kette.** Sie ist die Stelle,
an der aus einer Laufzeit-Freigabe ein Compile-Auftrag wird — also genau die Naht
`FREIGABE (Laufzeit) → DURCHFUEHRUNG (compile time)` aus KON8-12, hier zum ersten Mal als
**Mechanismus** benannt und nicht nur als Relation.

**Die CoR/Strategy-Fassung aus KON8 bleibt gueltig und bekommt ihren Ort:** die Kette der Filter
(Chain of Responsibility) ist eine `mp11`-Liste, jeder Filter ein concept; die zwei Massstaebe
(Filter A monoton fuer Hardware, Filter B zweischneidig fuer Mess) sind die Strategy.

**🔴 EIGENE GEDAECHTNISLUECKE, ausdruecklich protokolliert:** *„Du hattest das schon entworfen."*
Der Entwurf ist im Bestand und war mir nicht praesent. Er ist Gegenstand von Schnitt 1 des am
11.08. nachts gefahrenen Explores. **Bis er vorliegt, wird nichts an dieser Stelle gebaut** —
nach der Hausregel *„eine unloesbare Frage ist zuerst eine eigene Gedaechtnisluecke"*.

---

### KON9-07 — NEUER OWNER-AUFTRAG: EXPLORE ZU INTERFACE-ARTEN UND VERSIONIERUNGS-PUNKTEN

**Owner verbatim:** *„Dazu **explore zu den verschiedenen Interface Arten und Punkten fuer
Versionierung** bitte."*

Gefahren als Schnitt 6 desselben Explores. Der IST-Ausgangspunkt, am 11.08. nachts am Objekt
gemessen (ce `670483c0`, Worktree `wt-ce-warn-libs`) — **fuenf** Versionierungs-Punkte:

| Datei | Zeilen | traegt |
|---|---|---|
| `libs/cache_engine/profile_facade/g1_binary_version_stamp.hpp` | 56 | — |
| `libs/cache_engine/builder/ceb_version_stamp.hpp` | 619 | CEB-Stempel; **System-Anteil literal leer** |
| `libs/cache_engine/builder/pruef_dock/pruef_dock_version.hpp` | 208 | 5 **handgeschriebene** Dock-Versionen, alle `"1.0.0.c"` |
| `libs/cache_engine/include/cache_engine/abi/anatomy_version_stamp.hpp` | 399 | — |
| `libs/cache_engine/include/cache_engine/measurement/axis_version_stamp.hpp` | 85 | — |

Dazu die zwei Grammatik-Traeger: `algo_semver.hpp` (1535 Z.) und `flag_grammar_catalog.hpp` (755 Z.).

**Die drei bekannten Luecken, am heutigen Stand bestaetigt:**
* **CEB-System ist leer** — `ceb_version_stamp.hpp` uebergibt literal `("", "", Mess-Zeile)`; der
  Kommentar sagt es selbst: *„der system-Parameter dieses Aufrufs ist `""` — der Vervollstaendiger
  wird hier gar nicht [aufgerufen]"*. Das SOLL (Owner 10.08.) verlangt **Mess + System**.
* **Genus-Versionen handgeschrieben** — fuenf freie Literale, alle `"1.0.0.c"`. Das SOLL verlangt
  **zusammengesetzt compile-time aus allen Mess/System/Organ-Achsen**.
* **Planer-SHA fehlt** — das SOLL verlangt Fingerprint-SHA fuer **alle vier** Binary-Typen.

---

### KON9-08 — KANN UND MUSS: DIE FREIGABE EROEFFNET, SIE ERZWINGT NICHT

**Owner verbatim:** *„Die System-Achse gibt also der Organ-Achse frei, welche Hardware-Erweiterungen
sie **tragen koennte** und daher **darf jeder `algorithmus@X.Y.Z.<tags>` die volle Syntax der
System-Achsen tragen** und die **CEBs KOENNEN die volle Syntax der durch den Planer freigegebenen
Mess-Achsen tragen — muessen aber nicht**."*

    System ──▶ Organ :  jeder algorithmus@X.Y.Z.<tags>  DARF  die VOLLE System-Syntax tragen
    Planer ──▶ CEB   :  die CEB  KANN  die volle freigegebene Mess-Syntax tragen,  MUSS NICHT

Deckt sich mit KON8-05: **nur die tatsaechlich verwendete Konfiguration kommt in den Stempel**,
die Freigabe ist Laufzeit.

---

### KON9-09 — MIN IST EIN QUERSCHNITTSKONZEPT MIT ZWEI FILTERN

*(Volltext in KON8-12 und im Owner-Antwort-Block F2; hier nur die Kernform, damit KON9 fuer sich
lesbar bleibt.)*

    MIN ist GLOBAL, nicht je Vertrag:  die einfachste CPU-Variante OHNE Erweiterungen  =  1.0.0.c
    Es gilt an JEDEM Uebergang  FREIGABE (Laufzeit) ──▶ DURCHFUEHRUNG (compile time).

    FILTER A -- HARDWARE-ACHSEN (System + Organ)
      additiv, MONOTON, aufwaertskompatibel. Mehr Features = nie schlechter.
    FILTER B -- MESS-ACHSE
      NICHT monoton, ZWEISCHNEIDIG: mehr Messfuehler = mehr Features ABER mehr Latenz.
      Eine KLEINERE Menge kann die BESSERE sein. Gegenstand: die 6 CEB-Versionen (3!).

    Die Filter sind ERWEITERBAR zu bauen (Chain of Responsibility), der Massstab je
    Achsen-Kategorie ist die Strategy.

**PFLICHT FUER DIE ABGABE, Owner-Wort:** *„Es braucht also je Achsen-Kategorie die von mir definiert
freigegebene **Syntax und Semantik**, die jeweils nach den beschriebenen Regeln ueber `c` hinausgeht.
**Das ist Pflicht und Basis fuer die Abgabe.**"*

---

### KON9-10 — DER PLAN WIRD NACHGEBESSERT, NICHT NEU GESCHNITTEN

**Owner verbatim (F4):** *„Ich denke wir konvergieren mit **Verbesserungsrunden**, weil der Haupt-Bau
schon steht und das diff ueberschaubar ist. Klar ist auch die **gesamte Steuerung und die Vertraege**
betroffen in ihrem Muster **Planung → Freigabe → Bau-Run** der einzelnen Traeger in der Kette, aber
das bekommen wir schrittweise geaendert."*

**Und die Reihenfolge (F5/F6):**

    1. NEU GRUENDEN                    -- erledigt: vier /goal-Dokumente + sechs Sessions vom 11.08.
    2. STEMPEL zuende planen UND CHATTEN
    3. PIPELINE DEBUGGEN
    4. KONSOLIDIERUNG (#88) wie geplant

**Befund zum Designplan-Bestand:** der am 11.08. erzeugte Stempel-Designplan mit den 15 Paketen
(ST-00…ST-14) existiert **nirgends als Datei**. Er lag ausschliesslich im fluechtigen
Workflow-Ergebnis; `/usr/bin/grep -l 'ST-00\|ST-14\|ST-08'` ueber alle 180 Workflow-Outputs vom
11.08. → **0 Treffer**, ueber `docs/` → **0 Treffer**. Erhalten sind nur die **Paketnamen** und die
**vier Nachbesserungs-Befunde** in `docs/sessions/20260811-KONTEXTUEBERGABE-nacht-7-…md` §4.

**Warum das kein Verlust ist:** der Plan war zweimal als NACHBESSERN beurteilt, seine
Verifikationsbasis war 14 Commits alt (`wt-ce-d37b @ 346b6da9`), und die Architektur hat sich
seitdem an fuenf Stellen geschaerft (KON9-01 bis KON9-06). **Ein Neuschnitt gegen den heutigen Stand
ist ohnehin richtiger als die Nachbesserung eines verlorenen Dokuments** — die Owner-Festlegung
„Verbesserungsrunden" betrifft **Steuerung und Vertraege im Code**, nicht das Plandokument.

---

### KON9-11 — 🔴 DER STEMPEL IST DER SCHLUESSEL ZU LAGER UND CACHE. OHNE IHN GEHT NICHTS.

**Owner verbatim 11.08.2026:** *„der Stempel ist zu allem Ueberfluss auch noch der **Schluessel zur
Lagerhaltung und Caching**, **ohne ihn geht nichts**, er ist die **zentrale Kurzform der Identitaet
der Einordnung einer Binary in das Gesamtsystem**."*

Und die CI-Kopplung, ebenfalls Owner 11.08.:

> *„jede Traeger-Stufe muss unbedingt als eigene **Mini-Pipeline innerhalb der Haupt-Pipeline**
> gebaut und getestet werden, also ein **eigenes Binary mit eigenen Beduerfnissen** […] dieses
> Binary wird im **Cache** hinterlegt und soll **nur neu gebaut werden, wenn es sich aendert**.
> Damit wird bei Implementierung ein **Update von X.Y.Z im Stempel PFLICHT**, sodass das Binary
> ueberhaupt neu gebaut wird. Aber final ist die Kette durch Caching **schneller**. Die
> Traeger-Binaries werden auch an der **Wurzel des Buildsystem-Caches (bereits auf NAS aufgebaut)**
> gespeichert und wenn sie **Gattung und Genus** haben, unter **weiteren Kategorien ins Lager**
> einsortiert."*

#### Der Stempel traegt damit FUENF Rollen, nicht eine

    (1) IDENTITAET        Flaeche 2 -- was die Binary IST
    (2) CACHE-SCHLUESSEL  neu gebaut wird nur, was sich aendert
    (3) LAGER-SCHLUESSEL  Einordnung ins Lager, unter Gattung und Genus
    (4) SKIP-MARKE        fuer Messdaten
    (5) EINORDNUNG        die zentrale Kurzform im Gesamtsystem

#### 🔴 DIE FEHLERKLASSE, DIE DARAUS FOLGT

**Eine Implementierungs-Aenderung ohne `X.Y.Z`-Bump fuehrt dazu, dass das Binary NICHT NEU GEBAUT
wird.** Der Lauf ist dann **schneller** und **falsch** — und er sieht von aussen aus wie ein
Cache-Treffer, also wie Erfolg. Das ist exakt die Hausklasse *„ein richtiges Messgeraet am falschen
Gegenstand"*: nichts klappert.

⇒ **Die Bump-Pflicht braucht ein WERKZEUG, nicht Disziplin.** *„Wir achten darauf"* gilt nach der
Abnahme-Regel als **nicht abgenommen**. Ob heute eine Wache diese Klasse faengt, ist Gegenstand von
Schnitt 2 des CI-Explores vom 11.08. nachts.

#### DER CODE WEISS DAS BEREITS — vier der fuenf Rollen sind durchgesetzt

Am Objekt, ce `670483c0`, `libs/cache_engine/builder/bestandslog/lager_baum_writer.hpp:50-53`,
**woertlich**:

> *„BLATT-IDENTITAET = v6-FINGERPRINT (F7-Konvergenz): **Skip-Marke, minio-Key,
> Bestandslog-`key_sha512` und Baum-Blatt sind DASSELBE Preimage**. […] Dieser Writer rechnet
> NICHTS nach […] Ein zweiter Preimage waere genau die Drift, die A13-M3 geschlossen hat."*

Zwei Anschlussbefunde derselben Datei:
* **Der Hybrid ist im Lager bereits regulaere Gattung+Genus** — *„L3 (Manager) ist mit K1
  AUFGEHOBEN: bis dahin verbot die Grammatik jeden `hybrid`-Token auf jeder Ebene. K1 sortiert
  Hybrid stattdessen als regulaere Gattung+Genus in die Wurzelebenen ein."* Das ist genau die
  Owner-Regel *„wenn sie Gattung und Genus haben, unter weiteren Kategorien ins Lager einsortiert"*
  — bereits gebaut.
* **Die CEB-Binaries liegen in den BLAETTERN der System-Achsen-Knoten**, am Uebergang zu den
  Organ-Achsen (`ceb_blatt_ebenen()`, ABNAHME-5).

Und der Messwert-Schluessel, `messwert_key_source.hpp:88-99`: er ist
`hash(fingerprint, hardware_identitaet)` und **fail-closed** — leere Hardware-Identitaet liefert
`nullopt`, mit der Begruendung *„lieber gar kein Messwert-Lager als eines, in dem prod1 und prod2
ununterscheidbar sind"*.

**Was damit offen ist: Rolle (2).** Der Buildsystem-Cache auf NAS und die Frage, ob der Stempel dort
heute als Schluessel wirkt, ist die einzige der fuenf Rollen ohne Objektbeleg. Sie ist Gegenstand
von Schnitt 3 des CI-Explores.

#### WAS DAS FUER DIE DRINGLICHKEIT AENDERT

*„Alle Blocker klemmen an der Stempel-Mechanik"* war bisher als **Policy-Aussage** gefuehrt (KON7)
und als technische Aussage ausdruecklich eingeschraenkt (die Kontextuebergabe nacht-7 §6.4 hielt
fest, `test:coverage-guard` sei **stempelfrei** rot). **Diese Einschraenkung faellt teilweise:**
sobald der Stempel der Cache- und Lager-Schluessel ist, haengt an ihm **jeder Neubau und jede
Einordnung** — also der Bau selbst, nicht nur seine Beschreibung. Die Policy-Aussage traegt weiter
voll; die technische traegt jetzt ueber Cache und Lager, nur nicht ueber die ISA-Gattierung des
coverage-guard.

---

### KON9-12 — WAS DAMIT OFFEN BLEIBT

| # | Gegenstand | Klasse |
|---|---|---|
| 1 | **Der Selbstkompilations-Entwurf** — „Du hattest das schon entworfen" | eigene Gedaechtnisluecke, Explore laeuft |
| 2 | **Syntax + Semantik je Achsen-Kategorie** ueber `c` hinaus | **OWNER-DEFINITION**, Abgabe-Pflicht |
| 3 | **Meta-Meta-Achsen von System und Organ** | zu recherchieren (KON8-12) |
| 4 | Die drei Grammatiken je Phasigkeit — konkrete Form | Bau, nach (1) und (2) |
| 5 | Die Ordnungs-Relation ueber Flag-Mengen (`⊆` als `constexpr`) | Bau |
| 6 | Hybrid-Flaeche 2: Durchreichen der Tier-Stempel zur Laufzeitanfrage | Bau |
| 7 | Wellenplan-Zeile „`hybrid/` = genau README.md" | Doku-Nachzug, ueberholt |
