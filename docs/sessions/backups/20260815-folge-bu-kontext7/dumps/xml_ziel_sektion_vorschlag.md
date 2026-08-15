# VORSCHLAG: XML-<output>-ZIEL-SEKTION (Publikation #48 + Cache-Wahl KON65-04 + rebuild D3)

Stand 15.08.2026, Design-Vorschlag, KEIN Bau. Autor: Fable-Subagent (wf 5a19728e).
Quellen: tmp/kon64_sammlung.md (Owner verbatim Teil 1-7), tmp/lager_minio_explore_RAWDATA.md,
Code/test_data_xml/experiment_schema.xsd:662-680 (OutputType + storage-Slot),
Code/external/comdare-cache-engine/libs/cache_engine/profile_facade/validate_profile.hpp:1164-1177
(Enum {local,minio}), Code/test_data_xml/experiment_golden_kern.xml:439-445 (Ist-<output>).

---

## 0. AUFTRAGSLAGE (Owner verbatim, je Fundstelle)

- CACHE-FRAGE 3 (Teil 7): 3 Ziel-Klassen korrekt -> "designe eigenstaendig eine XML Syntax
  dafuer und praesentiere mir einen Vorschlag." => DIESES Dokument.
- KON65-04 (Teil 5): "In der XML sollte einstellbar sein, ob ein minio caching oder custom
  artifact caching fuer alle Planer und Traeger-Stufen verwendet werden sollte, sowohl fuer
  die lokale Komplett-Durchfuehrung durch einen Anwender, als auch in der CI auf gitlab."
- LAGER-PRAEZISIERUNG (Teil 7): "Daher landen alle Binaries mit Planer und Traegern
  versioniert und einsortiert im Lager." + CI-SKIP-REGEL: "Wenn die CI im Lager exakt den
  Stempel schon findet, der jetzt per Versionierung gebaut werden sollte, ueberspringt sie
  das Ziel, es sei denn, wir setzen ein spezielles rebuild flag je Planer bzw. Traeger
  Stufe ... Wir lassen also rebuild erstmal dauerhaft an."
- CACHE-FRAGE 4 (Teil 7): "Freigabe, die XML Richtlinien sollen stets andere Variablen bei
  Ausfuehrung temporaer ueberschreiben." (XML > Env, temporaer je Ausfuehrung.)
- Task #48 (Owner-GO 14.08.): 4 Artefakt-Klassen Binaries/Messdaten/LaTeX/PDF -- "je
  git-Ziel mit definierbarem Branch + fail-loud UND/ODER Filesystem".
- D3/KON60-09 (13.08.): Lager verwaltet ALLE VIER Traeger-Stufen (Teilprojekte per KON43),
  ueberspringt Builds bei gleichem Teilprojekt-Commit; Stempel = Skip-Kriterium
  (perm.dll.fingerprint).
- Rahmen: 1-XML-Doktrin (nur EIN offizielles XML-getriebenes Programm), KON21-02
  (XML = Wahrheit der Realisierung), allow_failure-VERBOT (06.07.).

## 1. DESIGN-PRINZIPIEN

P1  ADDITIV, INERT BEI ABWESENHEIT: beide neuen Elemente sind minOccurs=0 und werden ans
    ENDE der OutputType-Sequenz gehaengt (hinter <storage>). Jede Bestands-XML bleibt
    byte-unveraendert valide; fehlt die Sektion, gilt EXAKT das heutige Verhalten
    (Genus-Default binary->minio / measurement->NAS wo gebaut; rebuild faktisch immer an;
    storage-Slot inert). Muster: COMPARE/hybrid_tier-Kommentar-Reserve (XSD:102-124).
P2  EIN VOKABULAR, ERWEITERT STATT ERSETZT: das bestehende <storage backend="local|minio">
    bleibt unangetastet (Section-59-C-Slot). Die neue Ziel-Typ-Menge {lager, minio,
    filesystem, git} ist eine VERFEINERUNG: `local` faechert in `filesystem`+`lager` auf,
    `minio` behaelt Wort UND Laufzeitbedeutung, `git` kommt dazu (#48). Mapping in §5.
P3  XSD STRUKTURELL, C++-VALIDATOR HART: wie im Bestand (backend-Enum lebt in
    validate_profile.hpp:1168, nicht im XSD) prueft das XSD nur Struktur; Klassen-/Typ-/
    Attribut-Pflichten prueft validate_profile fail-loud. §7.
P4  STEMPEL BLEIBT UNBERUEHRT: die Sektion adressiert Stufen ueber Klarnamen
    (planner|ceb|tier|hybrid), NIE ueber Stempel-Kuerzel; sie liest den Stempel nur als
    Skip-Kriterium. (Stempel-Syntax besonders behutsam, Owner 14.08.)
P5  KONTEXT WIRD ERKANNT, NICHT BEHAUPTET: scope="local|ci" FILTERT Ziele; ob ein Lauf CI
    ist, entscheidet die Laufzeit (CI-Env), nie die XML.
P6  XML > ENV, TEMPORAER: alle endpoint/bucket/Schalter-Werte aus der XML ueberschreiben
    Env-/CI-Variablen NUR fuer die Dauer des Laufs (CACHE-FRAGE 4 verbatim).
P7  PROVENIENZ (KON21-02): der Runner schreibt die EFFEKTIV benutzten Ziele (nach
    Scope-Filter und Env-Aufloesung) in die Lauf-Provenienz/Sidecar -- die XML bleibt die
    Wahrheit der Realisierung, der Sidecar die Wahrheit des Laufs.

## 2. DIE SYNTAX (Kern-Beispiel, kanonisch)

```xml
<output>
  <!-- Bestand unveraendert (Pflicht-Trio + optionale Slots) -->
  <binary_path>golden_kern/measurements/all_permutations.bin</binary_path>
  <csv_path>golden_kern/measurements.csv</csv_path>
  <latex_path>golden_kern/golden_kern_table.tex</latex_path>

  <!-- NEU, optional: Publikations- und Cache-Ziel-Sektion (#48 + KON65-04).
       PRAEZEDENZ (CACHE-FRAGE 4, Owner 15.08. verbatim): "die XML Richtlinien sollen
       stets andere Variablen bei Ausfuehrung temporaer ueberschreiben." XML > Env,
       nur fuer diesen Lauf. ABWESENHEIT der Sektion = heutiges Verhalten (inert). -->
  <publish>
    <artifact class="planner_binary">
      <!-- lager = kaskaden-konform: KEINE Attribute erlaubt; das Lager platziert
           allein nach Stempel (Realm binaries; Planer-Blattfunktion = Bauposten). -->
      <target type="lager"/>
    </artifact>
    <artifact class="ceb_binary">
      <target type="lager"/>
    </artifact>
    <artifact class="tier_binary">
      <target type="lager"/>
      <!-- minio: endpoint/bucket OPTIONAL; Default aus Env/CI-Variable,
           XML-Wert ueberschreibt temporaer. scope filtert je Kontext. -->
      <target type="minio" scope="ci" bucket="cache-engine-tier-binaries"/>
    </artifact>
    <artifact class="hybrid_binary">
      <target type="lager"/>
    </artifact>
    <artifact class="measurement">
      <target type="lager"/>  <!-- Realm messdaten: Kaskade MESS->SYSTEM->ORGAN (D-12) -->
      <!-- git: repo+branch PFLICHT; IMMER fail-loud (Push-Fehler = Job rot;
           allow_failure-Verbot 06.07.) -- nicht konfigurierbar. -->
      <target type="git" repo="comdare/super" branch="persist/measurements"/>
    </artifact>
    <artifact class="latex">
      <target type="git" repo="comdare/thesis" branch="ingest/latex"/>
      <target type="filesystem" scope="local" path="out/latex"/>
    </artifact>
    <artifact class="pdf">
      <target type="filesystem" path="out/pdf"/>
    </artifact>
  </publish>

  <!-- NEU, optional: rebuild-Flag je Planer-/Traeger-Stufe (D3/KON60-09).
       Owner 15.08.: "Wir lassen also rebuild erstmal dauerhaft an." => force-Default
       TRUE (= abwesend identisch). force="false" ERLAUBT den Lager-Skip: exakter
       Stempel-Fund + gleicher Teilprojekt-Commit => Ziel wird uebersprungen.
       VOLL-ctest bleibt davon unberuehrt Pflicht (D3: Test-Skip verboten). -->
  <rebuild>
    <stage name="planner" force="true"/>
    <stage name="ceb"     force="true"/>
    <stage name="tier"    force="true"/>
    <stage name="hybrid"  force="true"/>
  </rebuild>
</output>
```

## 3. SEMANTIK IM EINZELNEN

### 3.1 Artefakt-Klassen (`artifact@class`, 7 Token)
`planner_binary | ceb_binary | tier_binary | hybrid_binary | measurement | latex | pdf`
Die #48-Klasse "Binaries" ist per KON43/D3 in die vier Teilprojekt-Stufen aufgefaechert
(je Stufe eigener Cache-/Lager-Schluessel). Jede Klasse traegt 0..n `<target>`-Kinder
("UND/ODER" aus #48 = Mehrfachziele). Ungenannte Klassen behalten das heutige Verhalten
(additive Teilkonfiguration erlaubt).

### 3.2 Ziel-Typen (`target@type`, 4 Token) und ihre Attribute

| type       | Pflicht-Attribute | Optionale Attribute | Verbotene Attribute | Fehlerverhalten |
|------------|-------------------|---------------------|---------------------|-----------------|
| lager      | keine             | scope               | ALLE weiteren (kaskaden-konform: das Lager platziert allein nach Stempel/Realm-Policy) | Lager nicht erreichbar / Stufe ohne Blattfunktion = Job rot |
| minio      | keine             | scope, endpoint, bucket (Defaults aus Env; XML ueberschreibt temporaer) | --- | Push-Fehler = Job rot; minio ohne endpoint im scope=local = Warnung (Muster :1176) |
| filesystem | path              | scope               | --- | Pfad nicht beschreibbar = Job rot |
| git        | repo, branch      | scope               | jedes Weich-Attribut (kein on_error, kein allow_failure) | IMMER fail-loud: Push-/Auth-Fehler = Job rot (#48-Pflicht + allow_failure-Verbot 06.07.) |

Klassen-Typ-Plausibilitaet (Validator, §7): latex/pdf nur {git, filesystem};
measurement {lager, git, filesystem}; die 4 Binary-Klassen {lager, minio, filesystem, git}
(#48 erlaubt git je Klasse; Binary-in-git s. Offener Punkt O9). measurement@minio = Fehler
(Ebene C ist NAS/measure-drop; kein minio-Messdaten-Pfad im Bestand).

### 3.3 Kontext-Scopes (`@scope`)
`local | ci | all` (Default all). Ein Ziel wirkt nur, wenn der Laufzeit-Kontext passt
(CI = GitLab-CI-Env vorhanden, sonst local). Damit ist die Owner-Anforderung "sowohl fuer
die lokale Komplett-Durchfuehrung ... als auch in der CI" EIN Dokument mit abweichender
Wahl je Kontext -- keine zwei XMLs (1-XML-Doktrin).

### 3.4 rebuild-Flag (`rebuild/stage`)
`stage@name` in {planner, ceb, tier, hybrid}; `@force` xs:boolean Default TRUE
(Owner: "erstmal dauerhaft an"); `@scope` optional wie 3.3. force=false erlaubt den
ZWEIGLEISIGEN Skip (D3): exakter Stempel-Fund im Lager UND gleicher Teilprojekt-Commit.
Ausdruecklich NICHT beruehrt: Compiler-Doktrin "Gebaut wird immer" fuer den Nicht-Skip-Fall
(gcc+clang) und VOLL-ctest-Pflicht (kein Test-Skip). Hinweis Klassen-CEB: ceb_binary meint
die KLASSE der CEB-Kompilate je Mess-Belegungs-Variation (KON65/Teil 4); force wirkt auf
die ganze Klasse (feinere Granularitaet je Einzelvertrag: Offener Punkt O1).

### 3.5 Praezedenz und Provenienz
XML > Env, temporaer je Ausfuehrung (CACHE-FRAGE 4 verbatim; gilt fuer endpoint, bucket,
COMDARE_STORAGE_CACHE-artige Schalter). Der Runner protokolliert die effektiven Ziele im
Lauf-Sidecar (P7). Env bleibt der Traeger der Credentials -- Secrets stehen NIE in der XML.

## 4. XSD-SKIZZE (Element-/Attribut-Baum, kein Volltext)

```
OutputType  (bestehend; Sequenz ADDITIV verlaengert)
+-- binary_path, csv_path, latex_path      (unveraendert, Pflicht)
+-- comparison_metrics?                    (unveraendert)
+-- storage? @backend @endpoint            (unveraendert; Enum-Pruefung bleibt im Validator)
+-- publish?                                                            [NEU, minOccurs=0]
|   +-- artifact*   @class  xs:string     (7-Token-Registry im Validator)
|       +-- target* @type   xs:string     ({lager|minio|filesystem|git} im Validator)
|                   @scope  xs:string     (optional; {local|ci|all}, Default all)
|                   @path   xs:string     (optional; filesystem-Pflicht via Validator)
|                   @repo   xs:string     (optional; git-Pflicht via Validator)
|                   @branch xs:string     (optional; git-Pflicht via Validator)
|                   @endpoint xs:string   (optional; minio)
|                   @bucket xs:string     (optional; minio)
+-- rebuild?                                                            [NEU, minOccurs=0]
    +-- stage*  @name xs:string ({planner|ceb|tier|hybrid} im Validator)
                @force xs:boolean (optional, Default true)
                @scope xs:string  (optional, Default all)
```
Attribute bewusst xs:string + optional im XSD (Haus-Muster "XSD nur strukturell", vgl.
measurement_framework :302-306); die Haerte liegt in validate_profile. version-Attribut
des Wurzelelements bleibt v2 (additiv => kein Bump noetig, KERN #48-S5-Muster).

## 5. VOKABULAR-KOPPLUNG (Forderung f): Mapping XSD <-> Code <-> Owner

| NEU target@type | Bestand XSD storage@backend | Code heute | Owner-Begriff | Physik heute |
|---|---|---|---|---|
| filesystem | local (Teilmenge; "local = Dateisystem lokal ODER Netz") | plain Pfade / nas_ablage ('nas') | "Filesystem" (#48) | lokale Platte oder NAS-Mount |
| lager | local (Netz-Fall, kaskadiert) | LagerRealm::{binaries,messdaten} + BinariesRealmPolicy (lager_baum_writer.hpp) | "im Lager versioniert und einsortiert" (Teil 7) | NAS-Lager-Baum (Kaskaden D-12) |
| minio | minio | objekt_store ('minio'); ArtifactCache push/pull = Ebene B | "custom artifact caching" (Bucket-Teil): "optional als getrennter bucket ..., sofern der bucket gross genug ist" | S3, Bucket cache-engine-tier-binaries |
| git | --- (neu) | git-persist:measurements-Doppelpersistenz (Bestand) | "git-Ziel mit definierbarem Branch + fail-loud" (#48) | GitLab-Repos (dual-remote) |
| (nicht adressierbar) | --- | --- | "minio caching" = Ebene A | GitLabs eigener cache:-Mechanismus (config.toml [runners.cache.s3] -> buildsystem-cache; nur ccache+Tools; CE-Code unbeteiligt; existiert lokal NICHT) |

Erweitern statt ersetzen: kValidStorageBackends {local,minio} (validate_profile.hpp:1168)
bleibt unveraendert bestehen; NEUE, getrennte Tabelle kValidPublishTargetTypes
{lager,minio,filesystem,git}. Widerspruch <storage backend> vs. <publish> => publish
gewinnt + Warnung (storage bleibt der inerte 59-C-Slot).

## 6. DURCHGERECHNETE BEISPIELE

### B1 -- Anwender, lokale Komplett-Durchfuehrung (offline-faehig, ohne NAS/minio)
```xml
<output>
  <binary_path>run_local/measurements/all_permutations.bin</binary_path>
  <csv_path>run_local/measurements.csv</csv_path>
  <latex_path>run_local/tables.tex</latex_path>
  <publish>
    <artifact class="planner_binary"><target type="filesystem" scope="local" path="run_local/bin/planner"/></artifact>
    <artifact class="ceb_binary">    <target type="filesystem" scope="local" path="run_local/bin/ceb"/></artifact>
    <artifact class="tier_binary">   <target type="filesystem" scope="local" path="run_local/bin/tier"/></artifact>
    <artifact class="hybrid_binary"> <target type="filesystem" scope="local" path="run_local/bin/hybrid"/></artifact>
    <artifact class="measurement">   <target type="filesystem" scope="local" path="run_local/measurements"/></artifact>
    <artifact class="latex">         <target type="filesystem" scope="local" path="run_local/latex"/></artifact>
    <artifact class="pdf">           <target type="filesystem" scope="local" path="run_local/pdf"/></artifact>
  </publish>
  <!-- rebuild abwesend = force=true je Stufe: der Anwender baut immer voll (Owner-Default) -->
</output>
```
Wirkung: kein Netz-Ziel noetig; hat der Anwender NAS, tauscht er filesystem gegen lager.
"minio caching" (Ebene A) existiert lokal nicht -- genau deshalb ist es hier KEIN Token.

### B2 -- CI-Messlauf (der kanonische Fall) = Kern-Beispiel §2
Wirkung je Zeile: 4 Binary-Klassen -> Lager-Kaskade (Teil 7: "alle Binaries mit Planer und
Traegern versioniert und einsortiert im Lager"); tier zusaetzlich minio-Spiegel NUR in CI
(heutiger Ebene-B-Pfad bleibt CI-getestet: "stets auf der CI gegen minio zu testen");
Messdaten -> Lager (measure-drop/NAS) UND git-Doppelpersistenz; LaTeX -> git fail-loud
(Thesis-Ingest) und lokal zusaetzlich ins Dateisystem; PDF -> Dateisystem. rebuild explizit
alle true = dokumentierter Owner-Default.

### B3 -- Feature-Entwicklung am Tier (rebuild selektiv, der Speed-Fall)
```xml
<publish>
  <artifact class="tier_binary">
    <target type="lager"/>
    <target type="minio" scope="ci"/>
  </artifact>
  <!-- ungenannte Klassen: heutiges Verhalten -->
</publish>
<rebuild>
  <stage name="planner" force="false"/> <!-- Skip ERLAUBT: Stempel-Fund + gleicher Teilprojekt-Commit -->
  <stage name="ceb"     force="false"/>
  <stage name="tier"    force="true"/>  <!-- Gegenstand der Arbeit: IMMER neu -->
  <stage name="hybrid"  force="true"/>  <!-- haengt vom Tier ab -->
</rebuild>
```
Wirkung: genau der Owner-Satz "der job wird schneller, sobald das Lager aufgrund der
Stempel korrekt funktioniert" -- Planer/CEB kommen aus dem Lager, Tier/Hybrid bauen frisch.
VOLL-ctest laeuft trotzdem (Test-Skip bleibt verboten, D3).

### B4 -- Abwesenheit (die Rueckwaerts-Probe)
```xml
<output>
  <binary_path>golden_kern/measurements/all_permutations.bin</binary_path>
  <csv_path>golden_kern/measurements.csv</csv_path>
  <latex_path>golden_kern/golden_kern_table.tex</latex_path>
</output>
```
= experiment_golden_kern.xml:439 ff. UNVERAENDERT valide; Verhalten byte-identisch heute:
Genus-Default (binary->minio, measurement->NAS, wo gebaut), rebuild faktisch an, storage
inert. Kein Schema-Bruch, kein Byte-Effekt auf golden.

## 7. WACHEN- / validate_profile-ANSCHLUSS

Validator (validate_profile.hpp, Muster :1164-1177; neue Zaehler publish_targets_checked,
rebuild_stages_checked; alle Regeln fail-loud als errors, benannte Ausnahmen warnings):
- R1 artifact@class in 7-Token-Registry; unbekannt = ERROR.
- R2 target@type in {lager,minio,filesystem,git}; unbekannt = ERROR.
- R3 filesystem ohne path = ERROR; git ohne repo ODER branch = ERROR; lager mit
  IRGENDEINEM Attribut ausser scope = ERROR (kaskaden-konform).
- R4 git = immer fail-loud; jedes Weichzeichner-Attribut = ERROR (allow_failure-Verbot).
- R5 Klassen-Typ-Matrix (§3.2): latex/pdf nur git|filesystem; measurement ohne minio;
  Verstoss = ERROR.
- R6 minio@scope=local ohne endpoint = WARNUNG (Spiegel von :1176).
- R7 storage-Slot vs. publish widerspruechlich = WARNUNG, publish gewinnt.
- R8 rebuild/stage@name in {planner,ceb,tier,hybrid}; Duplikat je (name,scope) = ERROR.
- R9 planner_binary@lager / hybrid_binary@minio: solange Blattfunktion/Push-Pfad im Code
  fehlen (RAWDATA (2)): ERROR "deklariert, aber Bau fehlt" -- LAUT statt still (Doktrin
  "erst laute Compile-/Validierungs-Fehler, dann verschieben").
Wachen: (W1) golden-Byte-Stabilitaet: publish-freie XMLs bleiben byte-identisch;
(W2) XSD-Additivitaets-Probe: alle Bestands-XMLs validieren unveraendert;
(W3) Koeder-Pflicht (K13): je ein Negativ-XML mit unbekannter class/type/Weich-Attribut
muss ROT beissen (Debug UND Release, gcc UND clang);
(W4) Sidecar-Provenienz-Wache: effektive Ziele im Lauf-Protokoll (KON21-02);
(W5) S-13-Kopplung: die measurement-Ziel-Auswertung ERSETZT den unbedingten
measurement_sink-Kanal (KON32-01, Ebene-C-401-Leak) -- kein zweiter stiller Kanal daneben.

## 8. OFFENE PUNKTE (O1-O10)

O1  Klassen-CEB-Granularitaet: ceb_binary = KLASSE je Mess-Belegungs-Variation (Teil 4);
    Build-Granularitaet "je Einzelvertrag" (Teil 6) feiner als das Flag -- braucht ggf.
    spaeter ein Sub-Adressierungs-Attribut (NICHT in v1 des Vorschlags).
O2  Planer-Lager-Platz: lager_baum_writer.hpp hat 0 Planer-Treffer; Blattfunktion fuer
    einen Traeger OHNE Gattung/Genus ist Design+Bau-Posten (KON9-11: "wenn sie Gattung
    und Genus haben" liess den Planer offen).
O3  Hybrid-minio-Push unbelegt (kein eigener Push-Pfad; Tier-Mechanismus-Erweiterung).
O4  D3-Commit-Skip-Mechanik im Code 0 Treffer ("Teilprojekt") -- bis zum Bau ist das
    rebuild-Flag DEKLARIERT-INERT wie der storage-Slot (ehrlich im XSD-Kommentar).
O5  lager_ziel_strategie.hpp (Genus-Matrix, KON66-05) in diesem Checkout nicht auffindbar
    -- Harmonisierungs-Flaeche bei der Landung (v4.2/A2.1b): publish-Sektion auf dem
    Branch landen, der die Genus-Matrix wirklich traegt.
O6  Instanz-Frage #55 (.local separate Instanz?) blockiert die endpoint-Defaults.
O7  Binary-in-git (#48 erlaubt git je Klasse): LFS-/Repo-Wahl ungeklaert; bis dahin
    Validator-WARNUNG bei binary-Klasse@git empfohlen.
O8  Code-Enum-Umbau (objekt_store/nas_ablage -> 4 Ziel-Typen) = eigener Bauposten;
    Mapping §5 ist die Vertrags-Tabelle dafuer.
O9  Ebene A bleibt ausserhalb der XML (CE-Code unbeteiligt) -- falls der Owner sie doch
    steuern will: Generator-Weg ueber "der Planer emittiert einen PROZESS" (s. Frage 2).
O10 measurement@filesystem vs. Pflicht-Trio binary_path/csv_path/latex_path: langfristig
    Zusammenfuehrung (das Trio ist heute die implizite filesystem-Publikation) -- erst
    nach S-13 (#18) anfassen.

## 9. CACHE-FRAGEN 1+2, NEU FORMULIERT (owner-tauglich)

### FRAGE 1 (neu): Physische Heimat von Lager-Gut vs. minio-Gut + Instanz-Wahl

LAGE: Explore-verifiziert: (i) "minio caching" = Ebene A = GitLabs eigener Runner-Cache
(config.toml [runners.cache.s3] -> minio.comdare.de:9000/buildsystem-cache; Inhalt nur
ccache+Tools; war laut Job-Trace nie krank). (ii) Unser einziger echter Binary-Push heute:
Tier -> Bucket cache-engine-tier-binaries (ArtifactCache, Ebene B); Planer liegt nirgends,
CEB nur als Versions-Segment im Tier-Key. (iii) Die Bezeichnung dev/prod fuer den Hostnamen
minio.comdare.de hat sich im Projektverlauf verschoben (07.07.: ".de = dev-V90, separates
prod-V91 minio.prod.comdare.de"; ab ~10.08. heisst ".de" prod); A3 (14.08.) bewies: die
Instanz hinter .de/cluster-intern traegt gitlab-backups UND buildsystem-cache. Ob
minio.comdare.local eine separate Instanz ist, ist offen (nur Reachability-Fail, Task #55).
Deine Festlegungen dazu: "alle Binaries mit Planer und Traegern versioniert und einsortiert
im Lager" + "minio soll alles halten, was im Lager nicht nativ gehalten werden kann, also
alles ausser Planer/CEB/Tier/Hybrid Binaries" + ArtifactCache "optional als getrennter
bucket ..., sofern der bucket gross genug ist" und "stets auf der CI gegen minio zu testen".

FRAGE: Bestaetigst du diese Ziel-Topologie -- (i) WAHRHEIT der 4 Traeger-Binary-Klassen =
NAS-Lager-Kaskade; (ii) minio haelt PFLICHT nur Ebene A + GitLab-Interna + Nicht-Lager-Gut;
(iii) der getrennte ArtifactCache-Bucket bleibt als OPTIONALER, stempel-gekeyter CI-Spiegel
des Lagers (CI-testbar) -- und auf WELCHER Instanz soll dieser Bucket leben, solange GitLab
auf dem dev-Cluster mit schwachen Nodes laeuft?

OPTIONEN: (a) Topologie (i)-(iii) wie beschrieben; Bucket auf der A3-geheilten
.de/cluster-internen Instanz, Umzug erst nach Klaerung #55. (b) Lager nutzt minio selbst
als physisches Medium (Bucket = Lager-Wurzel) -- dann laegen die Traeger-Binaries weiter im
minio, nur unter Lager-Regie, und "alles ausser ..." waere neu zu fassen. (c) Getrennte
Instanzen je Kontext (CI-Spiegel auf .de, Anwender-Lager nur NAS).

EMPFEHLUNG: (a) -- deckt alle drei deiner Festlegungen ohne Widerspruch (Merge statt
Verdraengung), laesst Ebene A unangetastet und macht den Tier-Bucket zum Uebergangs-/
Spiegelpfad statt zur zweiten Wahrheit.

### FRAGE 2 (neu): Was genau waehlt die XML -- und bleibt Ebene A draussen?

LAGE: Explore-verifiziert: "minio caching" (Ebene A) und "custom artifact caching"
(Ebene B+C) sind KEINE zwei gleichartigen, austauschbaren Cache-Systeme: Ebene A ist
GitLabs eigener cache:-Mechanismus (config.toml, vom CE-Code unbeteiligt, kann keine
Traeger-Stufen unterscheiden und existiert bei der lokalen Komplett-Durchfuehrung gar
nicht). Eine XML-Wahl "A oder B je Traeger-Stufe" waere darum technisch leer -- das
erklaert, warum die fruehere Frage-2-Formulierung falsch klang. Was echt waehlbar ist,
sind die ZIELE unserer eigenen Maschinerie je Stufe und Kontext.

FRAGE: Sollen wir deine XML-Anforderung ("ob ein minio caching oder custom artifact
caching fuer alle Planer und Traeger-Stufen ... lokal ... und in der CI") so umsetzen,
dass die XML je Artefakt-Klasse und Kontext (local|ci) die Ziele der EIGENEN Maschinerie
waehlt -- {lager | minio | filesystem | git} gemaess beiliegendem Syntax-Vorschlag --
und Ebene A unangetastet GitLab-nativ bleibt?

OPTIONEN: (a) Ja: XML steuert nur Lager/ArtifactCache/Publikation (Ebene B/C + git/FS);
Ebene A bleibt config.toml-Sache. (b) Nein: die XML soll auch Ebene A steuern -- dann
braeuchte es einen Emitter, der cache:-Bloecke der CI aus der XML erzeugt (konform zur
Doktrin "der Planer emittiert einen Prozess", aber neuer Bauplatz). (c) Mischform: XML
dokumentiert Ebene A nur deklarativ (read-only), steuert B/C.

EMPFEHLUNG: (a) -- Ebene A traegt nur ccache+Tools (kein experiment-relevanter Inhalt,
nie krank gewesen); (b) bleibt ueber die Emitter-Doktrin jederzeit nachruestbar, falls
du Ebene A doch je Lauf variieren willst.

---
SELF-CHECK: ASCII-only ja; alle Owner-Zitate verbatim mit Fundstelle (kon64_sammlung.md
Teil 5/7, LEDGER-Zeilen via RAWDATA); jede Zahl mit Nenner/Quelle; Nichtfunde (Planer im
Lagerbaum, Teilprojekt-Skip, lager_ziel_strategie.hpp) aus RAWDATA mit Gegenprobe uebernommen.
