# OWNER-VORLAGE — ZEHN ENTSCHEIDE FÜR DEN VOLLAUSBAU DER TRÄGER-BAUKETTE

> **Stand:** Di 11.08.2026 nachts · **Frist: Do 14.08.** (Kipp-Punkt K-1 aus Wellenplan §14.5)
> **Anlass:** Owner-Entscheid *„volles Risiko, komplette Träger-Baukette, alle Teile in
> Reihenfolge"* (Wellenplan §14). Diese zehn Punkte sind die einzigen, die eine Recherche nicht
> auflösen konnte — je mit dem gegangenen Weg.
>
> **Regel, nach der diese Liste entstand:** *„ALLES IST GEPLANT"* — vorgelegt wird nur, was ein
> Explore nicht beantwortet. Zwei Explores mit zusammen **86 Agenten und 0 Fehlern** liefen dafür;
> ein elfter Punkt (O-2) ist danach wieder herausgefallen, weil er sich als eigener
> Interpretationsfehler erwies und nun per Explore geklärt wird (KON11-02).
>
> **Jede Frage ist in einem Satz beantwortbar.** Wo ich eine Empfehlung habe, steht sie dabei —
> sie ist ein Vorschlag, kein Vorgriff.

---

## ÜBERSICHT: WAS JEDER ENTSCHEID FREISCHALTET

| ID | Frage in Kurzform | schaltet frei | Dringlichkeit |
|---|---|---|---|
| **O-1** | Syntax **und Semantik** je Achsen-Kategorie über `c` hinaus | S-2, S-3, S-7 | 🔴 **höchste** — Abgabe-Pflicht |
| **O-3** | Fordert ein Flag seine Voraussetzung, oder impliziert es sie? | S-3 | 🔴 hoch |
| **O-4** | Meta-Meta-Achsen von System und Organ | S-3 | hoch |
| **O-5** | K1 · K2 · K5 — Hybrid-Lager, Loader-Schichten, Snapshot-Aggregation | S-15 | vor dem ersten Linken |
| **O-6** | Mini-Pipeline = Child-Pipeline oder Job-Gruppe? | S-12 | 🔴 hoch |
| **O-7** | Mini-Pipelines statisch eingecheckt oder vom Planer emittiert? | S-12 | 🔴 hoch |
| **O-8** | Wo sitzt der Hybrid, wenn das Nesting-Budget erschöpft ist? | S-12, S-15 | 🔴 hoch |
| **O-9** | Buildsystem-Cache-Wurzel: NAS-Ordner oder MinIO-Bucket? | S-13, S-17 | hoch |
| **O-10** | Mini-Pipeline je Träger-**Typ** (4) oder je **Instanz** (n)? | S-12 | mittel |
| **O-11** | Was heißt „eigene Bedürfnisse" konkret? | S-12 | mittel |

---

## O-1 — DIE FREIGEGEBENE SYNTAX UND SEMANTIK JE ACHSEN-KATEGORIE

**Deine Festlegung, die diesen Punkt erzeugt:**

> *„Es braucht also je Achsen-Kategorie die von mir definiert freigegebene **Syntax und Semantik**,
> die jeweils nach den beschriebenen Regeln über `c` hinausgeht. **Das ist Pflicht und Basis für die
> Abgabe.**"*

**Die Frage:** Welche Flag-Syntax **und welche Bedeutung** gibst du je Achsen-Kategorie (Mess ·
System · Organ) frei — über die reine `c`-Baseline hinaus?

**Was recherchiert wurde und was dabei herauskam:**

* Die **Syntax** steht vollständig: Flag-Grammatik v2 in `algo_semver.hpp`, Regeln R1–R8, **295
  `static_assert`**, 238 Parse-Stellen.
* Die **Taxonomie** steht: `flag_grammar_catalog.hpp` mit `HardwareBasis` (`c`/`g`/`f`/`n`),
  `HardwareUnterklasse` (`p`/`e`), `BreitenSubset`, `MedienSubset`.
* Die **Semantik fehlt** — es gibt keine Ordnung über Flag-Mengen. Gegenprobe gefahren:
  `teilmenge`/`dominiert`/`ist_hoeher` = 0 Treffer, `constexpr` 54 bzw. 21, `static_assert` 295.
* Der Katalog selbst sagt seit dem 07.08., er sei *„ausdrücklich noch nicht recherchiert"*, und
  trägt eine **S2-Katalog-Andockstelle** bei `algo_semver.hpp:73`, die seither unverändert wartet.
* Der IST-Bestand: alle rund **137** ce-eigenen Flag-Literale tragen genau `c` und sonst nichts.
  *(Zahl aus einem Agentenbericht vom 11.08.; im Explore zur Neuerhebung aufgegeben, hier nicht als
  eigene Messung geführt.)*

**Was ich nicht entscheiden kann:** welche Flags über `c` hinaus **gelten sollen**. Das ist eine
Setzung, keine Ableitung — der Katalog wäre sonst geraten.

**Empfehlung:** je Kategorie ein **kleiner, vollständiger** Satz statt eines großen unvollständigen:
* **System** — die Hardware-Grammatik, die schon existiert: `c{p.e}` · `x128` · `x256` · `x512{…}`
  plus die Einzel-Flags des Vollausbaus (59 Knoten stehen als `kVollausbau` im Code).
* **Organ** — dieselbe Grammatik, aber nur die Teilmenge, die ein Algorithmus tatsächlich nutzt
  (deine Regel: *„kann, muss nicht"*).
* **Mess** — die PMC-Familie als Meta-Meta-Achse mit eigener Permutation (AMD ≠ Intel).

**Frist: Do 14.08.** Ohne O-1 steht S-2 (drei Grammatiken) und mit ihm die Kette ab dem Wochenende.

---

## O-3 — FORDERT EIN FLAG SEINE VORAUSSETZUNG, ODER IMPLIZIERT ES SIE?

**Die Frage in einem Satz:** Wenn ein Algorithmus `x512{vl}` deklariert, ohne `f` zu nennen — ist
das ein **Fehler** (das Flag *fordert* die Voraussetzung) oder wird `f` **stillschweigend ergänzt**
(das Flag *impliziert* sie)?

**Was recherchiert wurde:** **Der Code stellt diese Frage selbst und beantwortet sie nicht.**
`algo_semver.hpp:1525-1528`, wörtlich:

> *„ABHAENGIGKEITEN ZWISCHEN FLAGS. `'1.0.0.c.x512{vl}'` ohne `'f'` geht durch, obwohl alle
> AVX-512-Subsets auf `avx512f` gegated sind […] eine Voraussetzungs-Wache ist ein eigener Schritt
> mit eigener Semantik-Frage (**fordert das Flag die Voraussetzung, oder impliziert es sie?**)"*

Die Lücke ist per `static_assert` bei `:1533` **bewiesen**, nicht vermutet. Das Vorbild für die
Wache liegt vor: `bvset_teilmenge.hpp` (187 Zeilen).

**Empfehlung: FORDERN, nicht implizieren** — also `x512{vl}` ohne `f` ist ein harter
Compile-Fehler. Begründung: Implikation macht aus einem Schreibfehler stillschweigend eine andere
Binary, und der Stempel ist der Cache-Schlüssel; ein still ergänztes Flag erzeugt eine Identität,
die niemand geschrieben hat. Fordern ist außerdem die fail-closed-Richtung, die im Haus überall
sonst gilt.

---

## O-4 — DIE META-META-ACHSEN VON SYSTEM UND ORGAN

**Die Frage:** Welche Meta-Meta-Achsen gibt es bei System und Organ — und gibt es sie dort
überhaupt?

**Was recherchiert wurde:** Du hast sie selbst als *„die zu recherchierenden Meta-Meta-Achsen
Systeme"* bezeichnet — also ausdrücklich als offen markiert. Am Objekt: die **Organ-Liste ist
leer**, **System hat genau eine Familie (SIMD)**. Bei **Mess** dagegen sind sie festgelegt: PMC mit
eigener Permutation, Einträge ans **Ende** der Realm-Zeile.

**Warum es blockiert:** die Meta-Meta-Achsen bestimmen die **Granularität der Freigabe** — also
gegen welche Menge die Teilmengen-Prüfung läuft. Ohne sie ist S-3 nicht schneidbar.

**Empfehlung:** falls es bei System/Organ **keine** gibt, das ausdrücklich festhalten — ein
belegter Nichtbestand ist auch eine Antwort und verhindert, dass die Frage in vier Wochen erneut
aufkommt.

---

## O-5 — K1 · K2 · K5: DREI HYBRID-ENTSCHEIDE VOR DEM ERSTEN LINKEN

**Die Fragen:**
* **K1** — Welche **Lager-Identität** trägt die Hybrid-`.so`?
* **K2** — Welcher **Loader-Schicht** ist der Hybrid zugeordnet?
* **K5** — Wie werden **Snapshots aggregiert**, wenn ein Hybrid mehrere Tier-Binaries hält?

**Was recherchiert wurde:** K1 ist im Lager bereits teilweise beantwortet — *„K1 sortiert Hybrid
als reguläre Gattung+Genus in die Wurzelebenen ein"*, das L3-Manager-Verbot ist aufgehoben. **K5 ist
ausdrücklich unentschieden.**

**Warum jetzt:** sie fallen **vor dem ersten Linken** an, und der Hybrid entsteht in W3 nach der
Einzelmessung. Ein Entscheid im Messfenster wäre der teuerste mögliche Zeitpunkt.

---

## O-6 — IST „MINI-PIPELINE" EINE CHILD-PIPELINE ODER EINE JOB-GRUPPE?

**Dein Satz:** *„jede Träger-Stufe muss unbedingt als eigene **mini Pipeline innerhalb der
Haupt-Pipeline** gebaut und getestet werden."*

**Die Frage:** Meinst du eine **GitLab-Child-Pipeline** (eigene Pipeline, per `trigger:` gestartet)
oder eine **Job-Gruppe innerhalb einer Stufe** der Haupt-Pipeline?

**Was recherchiert wurde:** *„innerhalb der Haupt-Pipeline"* schließt eine eigenständige
**Downstream**-Pipeline eher aus — aber zwischen Child-Pipeline und Job-Gruppe entscheidet der Satz
nicht. **Keine Quelle** im gesamten Korpus; die frühere Stelle, auf die du verwiesen hast, ist
**nicht auffindbar** (Nichtfund mit Gegenprobe über 19 `.jsonl`, Ledger, `plaene`, `sessions`,
`memory`). Der Satz vom 11.08. ist die einzige wörtliche Fassung.

**Empfehlung: Job-Gruppe je Träger**, weil das Nesting-Budget bereits erschöpft ist (siehe O-8) und
*„innerhalb"* wörtlich dafür spricht.

---

## O-7 — STATISCH EINGECHECKT ODER VOM PLANER EMITTIERT?

**Die Frage:** Sollen die vier Mini-Pipelines **im `.gitlab-ci.yml` stehen** oder **vom Planer zur
Configure-Zeit erzeugt** werden?

**Was recherchiert wurde:** Die heutige Architektur **emittiert** — der `CiYamlBuilder` ist im
Bauplan vom 19.07. genau dafür vorgesehen (*„`CiYamlBuilder` → Child-Pipeline
`trigger:include:artifact:`"*). Zugleich ist die `.gitlab-ci.yml` heute **hand-geschrieben**
(*„REV 10 hand-maintained"*), und die XML→CI-Erzeugung ist als **Soll** geführt, nicht als Ist.

**Der Zielkonflikt:** emittiert passt zum Selbstkompilations-Prinzip, statisch ist **prüfbar** und
liegt im Diff. Ein emittiertes CI, das niemand liest, ist schwer zu bewachen.

**Empfehlung: emittiert, aber mit eingechecktem Abzug** — der Planer erzeugt, und ein Gate
vergleicht die Emission gegen eine versionierte Referenz. Damit ist beides erfüllt: das Prinzip und
die Prüfbarkeit.

---

## O-8 — 🔴 WO SITZT DER HYBRID? DAS NESTING-BUDGET IST ERSCHÖPFT

**Der gemessene Befund:** `super/.gitlab-ci.yml:2686-2688` nennt die Grenze selbst — *„parent →
child → grandchild = GitLab-Nesting-Tiefe 2"*. **Drei der vier Träger belegen bereits alle drei
Ebenen** (Haupt/Planer-Delegation → Stufe-1 CEB → Stufe-2 Tier). Für den Hybrid ist **keine vierte
Ebene mehr da**.

**Die Frage:** Welche der drei Auflösungen?

1. **Hybrid auf eine bestehende Ebene** — neben Tier, nicht darunter. *(Passt zu deiner Aussage
   „Hybrid und Tier sind gleichauf, die CEB baut beide gleichrangig".)*
2. **Emission flach ziehen** — eine Ebene weniger, dafür breitere Job-Matrix.
3. **Andere Verschachtelung** nach deiner Vorgabe.

**Empfehlung: (1).** Du hast gesagt, die CEB baue Hybrid und Tier **gleichrangig** und der Hybrid
könne *„nicht bauen, sondern nur messen"*. Genau das ist eine Geschwister-Beziehung, keine
Verschachtelung — die Architektur gibt die Antwort bereits.

---

## O-9 — BUILDSYSTEM-CACHE-WURZEL: NAS-ORDNER ODER MinIO-BUCKET?

**Dein Satz:** *„Die Träger-Binaries werden auch an der **Wurzel des Buildsystem-Caches (bereits auf
NAS aufgebaut)** gespeichert."*

**Was recherchiert wurde:** **`comdare-buildsystem` = 0 Treffer** in `ce/libs` + `ce/apps`. Die
Env-Variablen aus dem TWO-CACHE-STORAGE-Bauplan (18.07.) wurden **nie angelegt**. Und im Ledger
steht ein **ungelöster Widerspruch** (07.08.): **MinIO-Bucket gegen NAS-Ordner**.

Dazu die Storage-Zuordnung aus §31-A4, die du selbst präzisiert hast: **CI-Cache (dev-MinIO) = nur
die Planer-Binary · prod-MinIO (`cache-engine-tier-binaries`) = alle generierten Folge-Stufen +
Sidecars**.

**Die Frage:** Ist die „Wurzel des Buildsystem-Caches auf NAS" **dasselbe** wie das prod-MinIO aus
§31-A4 — oder ein **dritter**, davon getrennter Ort?

**Warum es blockiert:** ohne diese Antwort hat der **genus-lose Planer überhaupt kein Ablageziel**
(der Lager-Baum verlangt Gattung und Genus, die der Planer nicht hat).

---

## O-10 — JE TRÄGER-TYP ODER JE TRÄGER-INSTANZ?

**Die Frage:** Gilt „eine Mini-Pipeline je Träger-Stufe" für die **vier Typen** (Planer, CEB, Tier,
Hybrid) — oder für **jede Instanz**, also auch für jede einzelne der 128 Tier-Binaries?

**Was recherchiert wurde:** *„je Träger-Stufe"* deutet auf **Typ**; eine explizite Quelle gibt es
nicht.

**Empfehlung: je Typ (4 Stück).** Eine Pipeline je Instanz wären bei 128 Permutationen 128
Pipelines — das widerspricht dem Ziel *„final ist die Kette durch Caching schneller"*.

---

## O-11 — WAS HEISST „EIGENE BEDÜRFNISSE"?

**Dein Satz:** *„also ein eigenes Binary mit **eigenen Bedürfnissen** ist."*

**Die Frage:** Welche Dimension meinst du — **Runner-Tags** (welche Maschine), **Toolchain**
(Compiler/Standard), **Sanitizer-Profil**, **Test-Suite**, oder mehrere davon?

**Was recherchiert wurde:** keine Quelle. Der Satz vom 11.08. ist die einzige Fassung.

**Empfehlung: alle vier**, je Träger deklariert — das ist die Lesart, die „eigenes Binary mit
eigenen Bedürfnissen" am vollständigsten trägt, und sie ist additiv erweiterbar.

---

## WAS NACH DEINEN ANTWORTEN SOFORT LÄUFT

    O-1  ──▶ S-2 drei Grammatiken (Wochenende 15./16.08.)
    O-3  ──▶ S-3 Voraussetzungs-Wache  (W1)
    O-4  ──▶ S-3 Teilmengen-Granularitaet
    O-5  ──▶ S-15 Hybrid  (W3, aber Entscheid jetzt)
    O-6..O-8, O-10, O-11 ──▶ S-12 CI-Geruest  (W2)
    O-9  ──▶ S-13 Cache + S-17 Lager-Verdrahtung

**Was ohne deine Antwort schon läuft** — und heute begonnen wird: **P-0** (super-Repo reconcilen),
**S-1** (gemeinsame Stempel-Basisklasse), **S-14** (Bump-Wache von 6 auf 136 Dateien ausrollen),
**S-17** (Lager-Baum-Writer verdrahten, soweit ohne O-9 möglich), und die Klärung von **W-1** per
Explore.
