# RAW-DATA: Lager-Festlegung + minio-Cache-Topologie (Explore, sehr gruendlich)

Stand der Recherche: 14./15.08.2026. Repo: /home/comdare/wt-super-landung (READ-ONLY).
Primaerquelle: docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md (28.252 Zeilen) + Code
(Code/external/comdare-cache-engine) + docs/plaene/*. Rohtranskript-Hinweis: die einzige
vorab extrahierte Owner-Rohdatei (`5a19728e_owner_raw.jsonl`, 1318 Zeilen) deckt NUR
2026-08-06T05:08Z bis 2026-08-09T11:06Z ab (Datei-mtime 09.08. 11:09) -- sie ist damit fuer
den 11.-15.08-Zeitraum STALE (Falsch-Null-Gefahr, Gegenprobe durchgefuehrt). Fuer 11.-15.08.
wurden deshalb die Ledger-Nachtraege verwendet, die selbst mit Transkript-Fundstelle zitieren
(z.B. "Transkript 5a19728e:52798").

---

## (1) LAGER-FESTLEGUNG

### Owner-Zitat-Kette (chronologisch, alle mit Fundstelle)

**KON9-11, Owner verbatim 11.08.2026** (LEDGER:7757-7770):
> "der Stempel ist zu allem Ueberfluss auch noch der Schluessel zur Lagerhaltung und
> Caching, ohne ihn geht nichts, er ist die zentrale Kurzform der Identitaet der
> Einordnung einer Binary in das Gesamtsystem."
> "jede Traeger-Stufe muss unbedingt als eigene Mini-Pipeline innerhalb der Haupt-Pipeline
> gebaut und getestet werden, also ein eigenes Binary mit eigenen Beduerfnissen [...]
> dieses Binary wird im Cache hinterlegt und soll nur neu gebaut werden, wenn es sich
> aendert. Damit wird bei Implementierung ein Update von X.Y.Z im Stempel PFLICHT, sodass
> das Binary ueberhaupt neu gebaut wird. Aber final ist die Kette durch Caching schneller.
> Die Traeger-Binaries werden auch an der Wurzel des Buildsystem-Caches (bereits auf NAS
> aufgebaut) gespeichert und wenn sie Gattung und Genus haben, unter weiteren Kategorien
> ins Lager einsortiert."

Daraus destilliert der Ledger 5 Stempel-Rollen (LEDGER:7772-7778): Identitaet,
Cache-Schluessel, Lager-Schluessel, Skip-Marke, Einordnung. "jede Traeger-Stufe" deckt sich
mit KON7-02 "Vier Traeger, und nur vier: Planer -> CEB -> Tier -> Hybrid" (LEDGER:3728) --
der Planer ist NICHT ausgenommen. Einschraenkung im selben Zitat: "wenn sie Gattung und
Genus haben" -- ob der Planer selbst Gattung/Genus traegt, bleibt in DIESEM Zitat offen
(er hat de facto keine Gattung/Genus-Belegung wie ein Tier-Binary).

**KON43, Owner verbatim 12.08.2026** (LEDGER:2910-2916):
> "Ich lege weiterhin hiermit fest, dass wir erst den Planer aufbauen, dann die CEB, dann
> die Tier-Binaries und dann Hybrid. In der Reihenfolge und nicht anders. Im Projekt der
> cache engine brauchen wir also 4 unter-Projekte die in Traeger-stufenform aufeinander
> aufbauen. Wir splitten den aktuellen Monolithen falls noch nicht erfolgt in
> uebersichtliche Ordnerstrukturen beim Aufraeumen."

Das ist die Quelle des Begriffs "Teilprojekt"/"Unter-Projekt" = die vier Traeger-Stufen
Planer/CEB/Tier/Hybrid als eigene Baueinheiten im ce-Projekt (LEDGER:2930-2933).

**KON60-09 = "D3", 13.08.2026, Quelle Owner-Nachricht 13.08. 14:19:56Z, Transkript
5a19728e:52798 (LEDGER:830-832, 1046-1066):**

Die Vorlagen-Frage selbst (docs/plaene/20260813-OWNER-VORLAGE-sammelrunde-welle2-vor-
komplexfix.md:88-93) war eng gefasst (NUR die Test-Skip-Frage):
> "D3 - E-4c KON-57/E-26 TEST-SKIP [...] Bau-Seite ('Gebaut wird immer, skip ist VERBOTEN')
> und Lager-Seite (Skip nur fuer gueltigen Bestand) sind entschieden. OFFEN allein die
> TEST-Schicht [...]: Frage: bleibt VOLL-ctest in jeder Pipeline Pflicht (Empfehlung), oder
> ist Fingerprint-basierter Test-Skip zulaessig?"

Der Owner antwortete knapp mit "Wie empfohlen, Freigabe." (=VOLL-ctest bleibt Pflicht) UND
lieferte im selben 14:19:56Z-Block eine ERWEITERUNG, die der Ledger so zusammenfasst
(LEDGER:1049-1053):
> "das Lager verwaltet ALLE VIER Traeger-Stufen (Teilprojekte per KON43) mit und
> ueberspringt Builds bei 'nichts geaendert bzw. gleicher commit des Teilprojektes wie
> letztes Mal'. Das ist das EINZIGE echte NOVUM der Owner-Nachricht 13.08.; der Begriff
> 'Teilprojekt' hatte vor diesem Nachtrag 0 Ledger-Treffer."

WICHTIG (Praezision): "Wie empfohlen, Freigabe." selbst ist das woertliche Owner-Zitat; der
Satz "das Lager verwaltet ALLE VIER Traeger-Stufen ... ueberspringt Builds bei ... gleicher
commit" ist die LEDGER-EIGENE Verdichtung dessen, was der Owner im selben Nachrichtenblock
zusaetzlich sagte (nicht Wortlaut-identisch mit der engen Vorlagen-Frage). Das ist exakt der
Gegenstand, den die Owner-Erinnerung vom Auftrag ("wir hatten festgelegt ... rebuild flag je
Planer bzw. Traeger Stufe") trifft: "gleicher commit des Teilprojektes" = die
Rebuild/Skip-Bedingung, "je Teilprojekt" = je Traeger-Stufe (inkl. Planer).

Drei Ebenen werden dabei ausdruecklich GETRENNT gebucht (LEDGER:1057-1062):
1. Compiler-Doktrin "Gebaut wird immer" (gcc+clang PFLICHT)
2. Test-Pflicht (VOLL-ctest in jeder Pipeline, KEIN Fingerprint-Test-Skip)
3. Lager-Build-Skip (Stempel/Fingerprint + Teilprojekt-Commit-Gleichheit, ZWEIGLEISIG --
   Commit-Gleichheit deckt NUR den Build-Skip, nicht Identitaets-/Einordnungs-Korrektheit;
   die X.Y.Z-Bump-Wache bleibt noetig)

**UEBERHOLT-Marker (datiert 14.08., LEDGER:1063-1066):** die fruehere (09.08.)
Assistant-Folgerung "Die Lagerhaltung lagert MESSDATEN, nicht Binaries" ist ausdruecklich
UEBERHOLT durch D-12-Kaskaden + KON9-11 + D3; Persistenz auf NAS/MinIO steht nicht im
Konflikt mit "Tier nur RAM-hot".

### Aeltere, damit zu harmonisierende Festlegung: §31-A4 (19.07.2026)

Vor KON9-11/KON43/D3 galt eine ENGERE Storage-Stufen-Zuordnung (LEDGER:18307, auch
docs/plaene/20260719-FINALES-DESIGN-ABSTRACT-kette-baum-registries.md:110):
> "CI-Cache (dev, minio.comdare.local) = NUR Planer-Binary (statisch, Kopf) ·
> prod-MinIO (https://minio.prod.comdare.de, Bucket cache-engine-tier-binaries) = ALLE
> generierten Folge-Stufen-Binaries (CEB je Messsystem + Tier + Hybrid) + Systemaufstellungen
> (Sidecars/Provenienz)"

Diese Fassung (19.07.) hatte den Planer AUSSERHALB des "Lagers" (prod-MinIO) verortet -- nur
im CI-Runner-Cache. KON9-11 (11.08.) und D3/KON60-09 (13.08.) ERWEITERN das: der Planer soll
"ebenfalls" (Owner-Erinnerungswort) ins Lager, mit eigenem Cache-Schluessel + eigener
Rebuild-Bedingung wie die anderen drei Traeger-Stufen. Das ist die Bewegung, die der
15.08-Owner-Satz zusammenfasst.

### Code-Gegenprobe (Objekt-Ebene, was der Bau HEUTE hergibt)

**lager_baum_writer.hpp** (Code/external/comdare-cache-engine/libs/cache_engine/builder/
bestandslog/lager_baum_writer.hpp, 946 Zeilen, vollstaendig gelesen):
- Definiert GENAU zwei Realms: `LagerRealm::binaries`, `LagerRealm::messdaten`.
- `BinariesRealmPolicy::kaskade()`: volle Kaskade Gattung->Genus->Realm->System->
  5 Organ-Gruppen->Mess-Typ -- das ist die TIER/HYBRID-Ablage (K1, "Hybrid ist bereits
  regulaere Gattung+Genus").
- `BinariesRealmPolicy::ceb_blatt_ebenen()`: eigene Funktion, EIGENSTAENDIG (nicht als
  Praefix von kaskade()) -- Gattung->Genus->Realm->System (OHNE Organ/Mess-Typ). Kommentar
  "ABNAHME-5: der Praefix, in dessen BLAETTERN die CEB-Binaries liegen". CEB HAT also eine
  eigene, echte Lager-Platzierungsfunktion.
- `grep -in "planer"` auf der GESAMTEN Datei = **0 Treffer**. Es gibt keine
  `PlanerBlattEbenen()`, keine Planer-Realm-Policy, keinen Planer-Platzierungspfad im
  Lagerbaum. Der Planer hat HEUTE keinen kodierten Platz im Lagerbaum.

**artifact_cache.hpp** (Code/external/comdare-cache-engine/libs/cache_engine/builder/
artifact_transport/artifact_cache.hpp, 1180 Zeilen, Kopf+Kern gelesen):
- `cache_key_prefix(build_version)` haengt `+ceb=<major>.<minor>` (CEB-Contract-Version),
  `+mtool=<combo>`, `+mrg=none` an -- das CEB-Contract-Glied dient NUR als
  Invalidierungs-Segment im TIER-Key, es ist KEIN eigener CEB-Objekt-Push.
- `push_tier_binary`/`pull_tier_binary`/`verify_remote_then_prune`/`pull_tier_prefix`:
  ALLE Funktionen bewegen ausschliesslich `perm.dll` (+Sidecars) -- also NUR Tier-Binaries.
  Es gibt kein `push_ceb_binary`, kein `push_planner_binary`.
- `grep -in "planer"` auf der Datei = 0 Treffer (nur in Kommentaren zu measurement_combo,
  die "vom Planer gewaehlt" wird, referenziert -- kein Push/Pull-Pfad).
=> Der reale minio-Push/Pull-Transport deckt HEUTE nur Tier-Binaries. CEB ist nur indirekt
   (als Versions-Segment im Tier-Key) vertreten. Planer ist NICHT vertreten.

**Teilprojekt/Commit-Skip-Mechanik** (D3-Novum): `grep -rn "Teilprojekt"` ueber
`libs/cache_engine/builder/bestandslog/` = 0 Treffer. `commit` kommt nur in
`reservation_lifecycle.hpp` als generisches RAII-Transaktions-`commit()` vor (PromiseGuard),
NICHT als Git-Commit-Gleichheits-Vergleich je Teilprojekt. => Die "rebuild-flag je
Planer/Traeger-Stufe"-Mechanik ist ENTSCHIEDEN (13.08.), aber im Code NICHT GEFUNDEN
(Nichtfund; Gegenprobe: gezielt in bestandslog/*.hpp UND per Volltext-Grep im ce-Baum).

**Struktur-Split (KON43, "4 Unter-Projekte")**: Design PUBLIZIERT (85c1174d,
docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md, Zielnamen
englisch "planner": `libs/traeger/{planner,ceb,tier,hybrid}`, Target `comdare_planner`).
Objekt-Gegenprobe in diesem Checkout: `find Code -type d -iname planner` liefert NUR
`libs/cache_engine/profile_facade/planner` (ein Unterordner IM Monolithen, nicht die
Zielstruktur `libs/traeger/*`). Kein `comdare_planner`-Target in den durchsuchten
CMakeLists. => Der Vier-Unterprojekte-Schnitt ist eine PUBLIZIERTE, owner-abgenommene
Design-Entscheidung, aber (in diesem Worktree) NOCH NICHT gebaut -- ausdruecklich auch
NICHT vor F1/F2 erzwungen (KON43-02, Task #88, "Aufraeum-Posten").

### FAZIT Teil 1

**Beleg vorhanden, keine Nichtfund-Situation.** Die vom Auftrag zitierte Owner-Erinnerung
deckt sich in der Sache mit einer Kette von drei Ledger-Nachtraegen (KON9-11 11.08. ->
KON43 12.08. -> KON60-09/D3 13.08.), die zusammen GENAU das ergeben: alle vier
Traeger-Stufen (inkl. Planer) sollen als eigene Teilprojekte mit eigenem Cache-/
Lager-Schluessel gefuehrt werden, Bau wird uebersprungen bei unveraendertem
Teilprojekt-Commit (= die "rebuild flag je Traeger-Stufe"). Das literale Owner-Wort
"Wie empfohlen, Freigabe." (D3, 13.08. 14:19:56Z) ist knapp; die inhaltliche Breite
("ALLE VIER Traeger-Stufen") ist die Ledger-eigene, aus demselben Nachrichtenblock
gezogene Zusammenfassung -- als solche kenntlich gemacht, nicht als Owner-Wortlaut
ausgegeben. Code-seitig ist das NICHT umgesetzt: Lagerbaum kennt nur Tier (voll) und CEB
(Praefix), Planer gar nicht; minio-Transport bewegt nur Tier-Binaries; keine
Commit-Gleichheits-Skip-Logik gefunden.

---

## (2) BAU-STAND JE TRAEGER (Zusammenfassung, mit Fundstellen)

| Traeger | Stempel-Klasse | Lager-Platzierung (Code) | minio-Push/Pull | Bemerkung |
|---|---|---|---|---|
| Planer | `PlanerStempel` existiert (planner_version.hpp:74, Vertrag :94); `fingerprint_sha()` bewusst LEER (`kFingerprintShaBewusstLeer=true`, :80-83) | **keine** (0 Treffer "planer" in lager_baum_writer.hpp) | **keine** (0 Treffer in artifact_cache.hpp) | Nur EIN Nur-Planer-Interface `version_xyz()` (KON7-04); "4-Unterprojekte"-Zielordner nur als Design publiziert, nicht gebaut |
| CEB | `CebStempel` existiert (ceb_version_stamp.hpp:623, Vertrag :650); `system_zeile()` bewusst LEER (:630-632) | **ja, Praefix** (`ceb_blatt_ebenen()`, ABNAHME-5: CEB liegt im Blatt des System-Achsen-Knotens) | **indirekt nur**: `+ceb=<major>.<minor>` als Versions-Segment im TIER-Key; kein eigener CEB-Objekt-Push | Contract-Bump invalidiert automatisch alle Tier-Keys |
| Tier | Klasse fehlt (kein `TierStempel`; "grep StempelTraeger::Tier ausserhalb Basis/Trait = 0") | **ja, voll** (`BinariesRealmPolicy::kaskade()`: Gattung->Genus->Realm->System->5 Organ-Gruppen->Mess-Typ) | **ja, einzige echte Push/Pull-Klasse** (`push_tier_binary`/`pull_tier_binary`, `perm.dll`+Sidecars) | Das einzige heute vollstaendig "im Lager UND im Cache" lebende Artefakt |
| Hybrid | Klasse fehlt (kein `HybridStempel`, gleicher 0-Treffer-Befund wie Tier) | **ja, wie Tier** (K1: "Hybrid ist im Lager bereits regulaere Gattung+Genus", eigene Gattung HeuristikAdapter) | **nein** (kein eigener Hybrid-Push-Pfad gefunden; wuerde ueber denselben Tier-Mechanismus laufen muessten, ist aber nicht belegt) | |

Cross-cutting (KON9-11, 11.08., LEDGER:7791-7816): von den 5 Stempel-Rollen (Identitaet,
Cache-Schluessel, Lager-Schluessel, Skip-Marke, Einordnung) waren zum Zeitpunkt 11.08. laut
Ledger 4 "durchgesetzt" am Objekt (Blatt-Identitaet=v6-Fingerprint deckt Skip-Marke/
minio-Key/Bestandslog-key_sha512/Baum-Blatt als DASSELBE Preimage) -- offen blieb NUR Rolle
2 (Cache-Schluessel wirkt am Buildsystem-Cache/NAS als solcher). Fuer die "Skip-Marke" (=
funktional die Rebuild-Flag) gilt an anderer Stelle im selben Ledger (LEDGER:3798-3800,
"Fuenf Rollen (KON9-11)"): "Durchgesetzt sind ZWEI (Identitaet, Einordnung) -- Lager-
Schluessel und Skip-Marke haben nur Test-Aufrufer" -- diese Version ist die haeufiger
zitierte und deckt sich mit dem obigen Code-Befund (Teilprojekt-Commit-Skip nirgends
produktiv verdrahtet).

---

## (3) MINIO-CACHING-TOPOLOGIE (Cache-Frage 1)

### Die drei Ebenen (KON66-05, ledger jüngster Stand, wf_618a5525, LEDGER:119-155)

> "TRENNUNG (Plan-Regeln): 'minio caching' = Ebene A = GitLabs EIGENER cache:-Mechanismus
> (key+paths je Job; Runner-config.toml [runners.cache.s3] -> minio.comdare.de:9000/
> buildsystem-cache; Inhalt laut KON15-05 NUR ccache+Tools; CE-Code unbeteiligt).
> 'custom artifact caching' = Ebene B+C = die EIGENE ArtifactCache-Klasse (Storage #51,
> 18.07.): B = CEB-/Tier-Bau-Artefakte per mc-Shellout in GETRENNTEN Bucket (Key
> build_version/<stem>/perm.dll, Marke perm.dll-zuerst/.version-zuletzt,
> perm.dll.fingerprint = Skip-Kriterium); C = Messergebnisse per HTTPS-PUT an den
> measure-drop-Filterpod (KEIN POSIX-Mount)."

D.h. die Owner-Unterscheidung "minio caching" vs. "custom artifact caching" ist NICHT
willkuerlich, sondern trifft zwei technisch getrennte Mechanismen: Ebene A ist GitLabs
eigener Runner-Cache (an dem der cache-engine-Code NICHT beteiligt ist), Ebene B/C ist die
selbstgeschriebene `ArtifactCache`-Klasse.

### config.toml-Belege (aus fruehen Explores zitiert, chronologisch)

1. **2026-07-06/07 (frueheste Belege, LEDGER:16682, 16774, 16776):** SNI-Standard-Pattern
   "V16->SNI->V90 = Soll-Pfad gitlab->dev-MinIO; **V90 = dev-MinIO (GitLab-Buckets)**,
   **V91 = prod-MinIO**" -- getrennte Stacks. Am 07.07. TLS-SAN-Beweis: der Endpunkt
   `minio.comdare.de` (SNI/443) traegt SANs `minio[-lb|-0..3].databases.svc.cluster.local`
   = **dev-Cluster-MinIO (V90)**; prod-MinIO laeuft separat unter `minio.prod.comdare.de`
   ueber eigenes OPN-HAProxy-ACL.
2. **2026-07-18 (VERORTUNGS-BRIEF, docs/plaene/20260718-storage-infra-verortung-
   VERORTUNGS-BRIEF.md:52-55):** "Runner-Cache: minio-s3-FE bind 10.0.60.1:9000, Bucket
   `buildsystem-cache` (= Ebene A)." Buckets dev (K46-Audit): `buildsystem-artifacts`
   (16 GiB), `gitlab-artifacts`, `buildsystem-cache` (17 GiB/7778 Obj), Rest leer, alle
   `policy=private`. **prod-MinIO (nicht Ziel fuer B):** separater Stack
   `minio.prod.comdare.de`, `be-minio-prod` via Calico-ClusterIP `10.32.243.80:9000`
   ueber V111-BGP (KEIN V91-LB), Bucket `gitlab-runner-cache`.
3. **~10.-11.08. ("A4", LEDGER:18307):** "dev-Cluster `minio.comdare.local` traegt den
   GitLab-Runner-Cache; Binaries werden auf dem schnelleren cluster prod (`minio.comdare.de`,
   CI-Var-Wert `https://minio.prod.comdare.de`, Bucket `cache-engine-tier-binaries`)
   gecacht. [...] Der CI-Cache haelt NUR den Experiment-Planer als statisch gebaute Binary."
   -- HIER kippt die Zuordnung: `.de` heisst jetzt "prod", `.local` heisst "dev" -- das
   Gegenteil der 07.07/18.07-Befunde, wo `.de` (SNI) = dev-V90 war.
4. **14.08. (A3-MinIO-Key-Rotation, LEDGER:305-309, OBJEKT-VERIFIKATION):** neues
   Schluesselpaar `comdare-ci-r20260814` sofort gueltig GENAU an der Instanz hinter
   `.de`/cluster-intern (K8s `databases`-Namespace); Blind-Smoke GRUEN "Buckets sichtbar:
   16, SMOKE_EXIT=0".
5. **15.08. (KON65-04, LEDGER:252-258):** "MINIO-KLAERUNGSFRAGE: dev `minio.comdare.local`
   vs prod `minio.comdare.de` -- geheilt (A3) ist die Instanz hinter `.de`/cluster-intern
   (K8s databases-Namespace; Beweis: neuer Key dort sofort gueltig,
   **gitlab-backups+buildsystem-cache dort**); ob `.local` eine SEPARATE dev-Instanz mit
   eigenem Paar ist = **PRUEFPOSTEN (Task #55, weiterhin OFFEN)**; Verify hatte `.local`
   als Reachability-Fail markiert, NICHT Auth-Reject."
6. **15.08. (KON66-05, wf_618a5525, LEDGER:119-142, JUENGSTER, gezielt georderter
   Explore):** bestaetigt config.toml `[runners.cache.s3] -> minio.comdare.de:9000/
   buildsystem-cache` als HEUTIGEN Ist-Zustand. Speed-Wahrheit: A3 heilte nur die
   288-Variablen-Familie (Toolbox/CE-eigene Credentials), NICHT den Runner-nativen
   `cache:`-Pfad (ANDERE Credential-Familie, `config.toml`-Svcacct) -- der war laut
   Job-376333-Trace ("cache.zip is up to date") NIE krank. Kein Job wird heute schneller;
   Speed-Gewinn kommt erst, wenn Ebene B (Fingerprint-Binary-Skip) scharfgeschaltet wird
   (W-Strecke S-17/D3).

### Verifikation der Owner-Neuinfo "minio prod obwohl gitlab auf dev"

**BESTAETIGT am Objekt, mit der oben dokumentierten Einschraenkung:**
- Das aktuell (14./15.08.) per Schluessel-Rotation und per config.toml-Lektuere GEPRUEFTE
  Faktum ist: der Hostname `minio.comdare.de` (das, was die neueren Ledger-Eintraege
  "prod" nennen) ist die Instanz, die SOWOHL `gitlab-backups` ALS AUCH `buildsystem-cache`
  (den GitLab-Runner-Cache, Ebene A) traegt -- UND ist exakt der Endpunkt, den
  `[runners.cache.s3]` in der Runner-config.toml eintraegt. D.h.: der Owner hat recht,
  dass der GitLab-Runner-Cache "auf" der ALS-PROD-bezeichneten minio-Instanz liegt, obwohl
  man (angesichts der Namen "prod" vs. "dev") das Gegenteil erwarten wuerde.
- **Aber:** dieselbe Instanz wurde am 07.07./18.07. (fruehere, ebenfalls objektbewiesene
  Explores) NOCH "dev-MinIO (V90)" genannt, mit einer SEPARATEN "prod-MinIO"-Instanz
  (V91, `minio.prod.comdare.de`, eigener Calico-Stack, eigener Bucket
  `gitlab-runner-cache`) daneben. Die Bezeichnung "dev" vs. "prod" fuer denselben
  `.de`-Hostnamen hat sich also im Projektverlauf VERSCHOBEN bzw. wird uneinheitlich
  verwendet -- ob das eine echte Infra-Konsolidierung (Zusammenlegung/Ablösung der
  separaten V91-prod-Instanz) oder eine Terminologie-Drift ist, ist im Korpus NICHT
  abschliessend geklaert. Das ist genau der offene Praefpunkt (Task #55), den der Owner mit
  seiner neuen Frage selbst schon anstoesst.
- Ob `minio.comdare.local` heute eine ECHTE, separate zweite Instanz mit eigenem
  Credential-Paar ist, ist ausdruecklich NICHT verifiziert (nur "Reachability-Fail", was
  ebenso gut "Host nicht auflösbar von diesem Client" bedeuten kann wie "Instanz existiert
  nicht mehr").

### Kuenftige Regel "minio haelt alles ausser Planer/CEB/Tier/Hybrid-Binaries" gegen den Bestand

Aus dem Korpus ist HEUTE (mit obigem Objekt-Befund) folgendes Bild belegt:
- **Was NICHT im minio liegt (Gegenteil der Formulierung "ausser"):** eigentlich liegt
  GENAU EIN Traeger-Binary-Typ (Tier) HEUTE aktiv im minio (Ebene B, Bucket
  `cache-engine-tier-binaries`), zusaetzlich indirekt CEB (nur als Versions-Segment).
  Hybrid folgt konzeptionell dem Tier-Pfad, hat aber keinen eigenen belegten Push-Code.
  Planer liegt NIRGENDS im minio (weder Ebene A [ccache/Tools] noch B).
- **Was HEUTE im minio liegt, das NICHT Traeger-Binary ist:** Ebene A (`buildsystem-cache`
  = ccache+Build-Tools, GitLab-eigen) UND `gitlab-backups`/`gitlab-artifacts` (GitLab-
  interne Objekte) -- das sind exakt die Dinge, die eine Regel "minio haelt ALLES AUSSER
  Planer/CEB/Tier/Hybrid-Binaries" beschreiben WUERDE, wenn man sie so liest, dass
  Binaries NICHT im minio landen sollen. Das steht aber im Widerspruch zu §31-A4/KON9-11/
  D3 (Tier/CEB/Hybrid/Planer SOLLEN gerade INS Lager/minio) -- die "kuenftige Regel" aus
  dem Auftrag ist also entweder eine NEUE, dem bisherigen Kurs entgegengesetzte Idee, oder
  sie meint einen ANDEREN Adressaten (z.B. "minio haelt CI-Ebene-A-Zeug plus alles ausser
  den 4 Traeger-Klassen, DIE laufen separat ueber die NAS/Lager-Kaskade") -- diese
  Unterscheidung konnte im Korpus NICHT eindeutig aufgeloest werden (Nichtfund einer
  woertlichen Owner-Formulierung dieser genauen Regel; sie wird im Auftrag als "kuenftige"
  Regel bezeichnet, ist also mutmasslich ein Vorschlag, der zur Klaerung ansteht, keine
  bereits belegte Festlegung).

---

## (4) BUCKET-INVENTAR (grob, ohne Secrets)

Namentlich im Korpus belegte Buckets:

| Bucket-Name | Ebene/Zweck | Instanz (Stand des jeweiligen Zitats) | Quelle |
|---|---|---|---|
| `buildsystem-cache` | Ebene A: GitLab-Runner-`cache:` (ccache+Build-Tools) | frueher "dev-MinIO V90" (18.07.), heute ueber `minio.comdare.de:9000` erreicht (15.08., KON66-05) | LEDGER:122-123, VERORTUNGS-BRIEF:52-53 |
| `buildsystem-artifacts` | dev, 16 GiB (18.07.-Audit) | dev-MinIO (V90) | VERORTUNGS-BRIEF:53 |
| `gitlab-artifacts` | dev (18.07.-Audit), Inhalt nicht naeher spezifiziert | dev-MinIO (V90) | VERORTUNGS-BRIEF:53 |
| `gitlab-runner-cache` | separater PROD-Stack (18.07.-Audit) | `minio.prod.comdare.de`, Calico-ClusterIP 10.32.243.80:9000 | VERORTUNGS-BRIEF:55 |
| `cache-engine-tier-binaries` | Ebene B: Tier-Binaries (+CEB-Contract-Segment im Key, +Sidecars/Provenienz) | wechselnd "prod-MinIO" (A4-Text, ~10.-11.08.) bzw. "dev-MinIO V90" (§51-B5/B6-Revision) | LEDGER:18307, 18650, 19003 |
| `gitlab-backups` | GitLab-eigene Backups | Instanz hinter `.de`/cluster-intern (A3-Beweis, 14.08.) | LEDGER:255 |

**"16 Buckets sichtbar" (LEDGER:307, 14.08. Blind-Smoke nach A3-Key-Rotation)** ist eine
reine ANZAHL aus einem `mc ls`-artigen Smoke-Test, KEINE Namensliste. Aus dem Korpus lassen
sich davon nur die o.g. 4-6 Namen konkret belegen; die restlichen ~10-12 Bucket-Namen sind
im durchsuchten Dokumentenbestand NICHT enumeriert (Nichtfund -- Gegenprobe: gezielte Suche
nach "Bucket", "bucket_name", Listen-Mustern in allen docs/-Bereichen ohne Treffer auf eine
vollstaendige Liste). Plausibel (NICHT belegt, nur Einordnung): bei selbst-gehostetem
GitLab sind zusaetzliche, GitLab-interne Object-Storage-Buckets ueblich (z.B. LFS-Objects,
Job-Artifacts getrennt von `gitlab-artifacts`, Container-Registry, Dependency-Proxy,
CI-Secure-Files, Pages, Terraform-State, Uploads) -- diese wurden in diesem Explore NICHT
verifiziert und sind daher als Hypothese, nicht als Fakt zu behandeln.

**Lager-Gut vs. Cache-Gut (Einordnung):**
- **Cache-Gut** (ephemer, CI-intern, kein Bestandslog-Bezug): `buildsystem-cache`,
  `buildsystem-artifacts`, `gitlab-artifacts`, `gitlab-runner-cache`, `gitlab-backups` --
  alles GitLab-/Runner-eigen, vom CE-Code laut KON66-05 ausdruecklich UNBETEILIGT
  ("CE-Code unbeteiligt").
- **Lager-Gut** (Bestandslog-gefuehrt, Skip-Kriterium, Teil der Traeger-Kette):
  `cache-engine-tier-binaries` -- der einzige Bucket, der ueber `perm.dll.fingerprint` als
  echtes Skip-Kriterium und ueber die vier Push/Pull-Methoden der `ArtifactCache`-Klasse
  angesprochen wird.

---

## (5) ZIEL-KOMBINATIONEN (Genus-Matrix x Stufen-Wunsch), fuer die praezise Owner-Frage

### Was heute GEBAUT ist (Genus-Matrix, KEINE Stufen-Dimension)

KON66-05 (LEDGER:129-132): "Wahl HEUTE per Artefakt-GENUS als CT-Strategy
(`StandardZiel<Genus>`: binary->minio, measurement->NAS, beidseitig drehbar;
`lager_ziel_strategie.hpp:156-173/216-225`) -- KEINE Stufen-Dimension, KEIN lokal-vs-CI-
Unterschied; globaler Schalter `COMDARE_STORAGE_CACHE` Default AUS."

**Objekt-Gegenprobe:** `find` nach `lager_ziel_strategie.hpp` im aktuellen Checkout
(Code/external/comdare-cache-engine) liefert **0 Treffer** -- die Datei, auf die KON66-05
sich beruft, ist in DIESEM Worktree (wt-super-landung) nicht vorhanden. Entweder liegt sie
auf einem hier noch nicht gemergten Branch, oder in einem anderen, hier nicht eingebundenen
Worktree/Stand. Das ist selbst ein Fund: die im Ledger als "CE-Seite fertig env-gated"
beschriebene Genus-Matrix ist aus DIESEM Checkout heraus nicht nachpruefbar (Nichtfund,
Gegenprobe per `find`+`grep -rl StandardZiel` im gesamten `Code/`-Baum, ebenfalls 0
Treffer).

Damit ist die heutige (laut Ledger gebaute, aber hier nicht auffindbare) Matrix EINDIMENSIONAL:
- Genus **binary** -> Ziel **minio**
- Genus **measurement** -> Ziel **NAS** (via measure-drop-Filterpod, HTTPS-PUT)
- KEINE Unterscheidung nach Planer/CEB/Tier/Hybrid, KEINE Unterscheidung lokal/CI.

### Was der Owner per XML will (Stufen-Wunsch), KON65-04, Owner verbatim (15.08., LEDGER:244-248)

> "In der XML sollte einstellbar sein, ob ein minio caching oder custom artifact caching
> fuer alle Planer und Traeger-Stufen verwendet werden sollte, sowohl fuer die lokale
> Komplett-Durchfuehrung durch einen Anwender, als auch in der CI auf gitlab."

Das fuegt der bestehenden 1D-Genus-Matrix ZWEI neue Dimensionen hinzu: **Traeger-Stufe**
(Planer/CEB/Tier/Hybrid) und **Kontext** (lokaler Anwender-Lauf vs. CI/GitLab).

### KON66-05s eigene vier offene Design-Fragen (LEDGER:143-155), die GENAU diese
### Verschraenkung betreffen

1. Was heisst "minio caching" LOKAL, wenn es kein GitLab-`cache:` gibt (Ebene A existiert
   dort gar nicht)?
2. **Ziel-Matrix Stufe x Kontext ODER Stufe x Kontext x Genus** (bleibt die
   Genus-Default-Matrix darunter erhalten)?
3. Welches Vokabular traegt die XML-Cache-Sektion (bestehendes Enum {local,minio} +
   Mechanismus-Attribut vs. eigenes Element)? Drei UNGEKOPPELTE Vokabulare bestehen
   parallel: XSD {local,minio} | Code {objekt_store/'minio', nas_ablage/'nas'} |
   Owner-Dichotomie {minio caching, custom artifact caching}.
4. Praezedenz XML vs. Env/CI-Variablen + ein bekannter Leak (Job 376333 sendet trotz
   INERT-Konfiguration Ebene-C-Daten, HTTP 401) -- faellt in S-13/#18.

### Enumerierte, konkret vorlegbare Ziel-Kombinationen je Artefakt-Klasse

Fuer eine praezise Owner-Frage lassen sich die real moeglichen Kombinationen so auflisten
(auf Basis obiger Belege; ANZAHL der Zellen wird bewusst nicht als bereits entschiedene
Matrixgroesse behauptet):

1. **Binaries x 4 Traeger-Stufen (Planer/CEB/Tier/Hybrid) x 2 Kontexte (lokal/CI) x
   Ziel-Optionen {minio (Ebene B, ArtifactCache), NAS/Lager-Baum (Bestandslog-Filesystem-
   Pfad), rein lokal/kein Push}** -- heute REAL gebaut: NUR Tier x CI(+lokal, da
   Kontext-blind) x minio; alle uebrigen 4x2x-Zellen sind unbelegt/Design-offen.
2. **Messdaten x 2 Kontexte x Ziel-Optionen {NAS via measure-drop-HTTPS-PUT, paralleler
   git-persist:measurements (Doppel-Persistenz, laut artifact_cache.hpp-Kopf
   ausdruecklich NICHT ersetzt), minio (nicht vorgesehen)}** -- heute: NAS (Ebene C) +
   git-Doppelpersistenz, kontext-blind.
3. **LaTeX/PDF x Ziel {git-Ziel mit definierbarem Branch, Filesystem}** -- eigene, vierte
   Artefakt-Klasse laut Task #48 (XML-Publikations-Sektion, Owner-GO 14.08.: "4 Klassen:
   Binaries/Messdaten/LaTeX/PDF -- je git-Ziel mit definierbarem Branch + fail-loud
   UND/ODER Filesystem"); minio taucht hier NICHT als Ziel-Option auf, sondern git+FS.
4. **ccache/Tools (Ebene A) x Ziel {minio.comdare.de:9000/buildsystem-cache}** -- FEST
   verdrahtet ueber GitLabs eigenen `cache:`-Mechanismus, vom CE-Code/der XML-Sektion NICHT
   erreichbar/konfigurierbar (KON66-05: "CE-Code unbeteiligt") -- fuer den lokalen
   Anwender-Kontext existiert dieser Pfad GAR NICHT (offene Design-Frage 1 oben).

Diese vier Zeilen (Binaries/Messdaten/LaTeX-PDF/ccache-Tools) sind die vom Auftrag
verlangten "Artefakt-Klassen"; die Owner-Frage kann jetzt konkret als 2- bzw. 3-dimensionale
Matrixfrage GENAU AUF Zeile 1 (Binaries x Traeger-Stufe x Kontext) gestellt werden, weil nur
dort die Stufen-Dimension ueberhaupt strittig ist -- bei Messdaten/LaTeX-PDF/ccache gibt es
laut Korpus keine Traeger-Stufen-Unterscheidung zu treffen (Messdaten sind stufenunabhaengig,
LaTeX/PDF sind keine Traeger-Artefakte, ccache/Tools sind fest an Ebene A gebunden).
