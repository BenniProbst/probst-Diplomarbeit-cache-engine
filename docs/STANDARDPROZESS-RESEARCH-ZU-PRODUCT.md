# STANDARDPROZESS: Umwandlung eines Research-Projekts in ein Product (v1, 2026-07-07)

**Quelle:** User-Definition 07.07. (Chat, wörtlich verankert in Ledger §12) · Pilot = Diplomarbeit/cache-engine (#274). Dieses Dokument ist der wiederverwendbare Prozess für JEDES künftige Research-Projekt, das Product werden will.

## 0. Begriffs-Fundament (in Stein gemeißelt)

- Die Matrix ist **dreidimensional: Familien × Baseline-Stufen × Module.** Familien = `comdare-<familie>-all`-Umbrellas; Stufen = `comdare-baseline_N-<name>/`-Ordner (eine Stufe referenziert nur niederwertigere, Regelfall die nächst-kleinere); Module = die Zellen IN einer Stufe (je Zelle ein eigenes Repo).
- **Generische Module (unter `Modules/`) sind metaprogrammierungs-offen und NUR Source-Code** (Template-Module, keine Binaries).
- **Jedes Product/Research, das Module verwenden will, organisiert eine EIGENE Matrix (Familien × Stufen × Module)** aus eigenen, separaten Repos/Implementierungen, die die Template-Module **als echte Interface-Binaries instanziieren** (§9-Doktrin: außen binary, innen compile-time-Metaprogrammierung).
- **Research = Products mit gelockerten Eigenschaften** (früher Lebenszyklus; Instanziierungs-Prinzip gilt identisch).
- Achsen-/Themen-Frameworks: je Achsen-Thema ein **Modul-Framework mit Metaprogrammierungs-Interface** (Kopf-Framework, keine Produkte) — compile-time heuristisch optimale Auswahl in die Ziel-Binary (F6-Doktrin).

## 1. Der Prozess (Schritte, je EIN Commit-Scope, Kadenz-Pflicht)

1. **Bestandsprüfung/Kartierung** des Research-Monolithen GEGEN die live-Matrix + Analyse-Backups (nie raten): Was existiert generisch bereits? Was ist domänenspezifisch?
2. **Wiederverwendung zuerst:** vorhandene Modul-Zellen konsumieren statt duplizieren; Duplikate im Monolithen auf die Module umstellen.
3. **Additive Erweiterung** bestehender Zellen um fehlende Generika (Interfaces stabil; je Fremd-Repo ein Commit mit Owner-GO; Provenienz-Artefakt Quell-Repo+SHA+Datum).
4. **Minimale Neuanlagen:** neue Familien/Zellen nur mit explizitem GO; Baseline-Stufennamen mit Owner-Konvention abgleichen (Recherche-Pflicht bei neuen Mess-/Fach-Ebenen).
5. **Framework-Modul-Schnitt:** der domänenspezifische Kern wird als Framework-Modul(e) **sauber in Baseline-Struktur** geschnitten (frisch aus einer Scratch-Kopie mit fixiertem Commit-Hash; Alt-Skelette = Archiv/Tombstone, nie Arbeitsgrundlage).
6. **Product-Seite:** das Research-/Product-Repo behält das **Außeninterface** und baut seine **eigene Instanziierungs-Matrix** (Familien × Stufen × Module als eigene Repos), die die Template-Module zu Binary-Interfaces materialisiert (Pilot: Tier-DLLs anatomy_module_abi_v1 = End-Interfaces).
7. **GitLab-Gruppen-Nachzug:** die Gruppenstruktur wird **exakt nach der Ordnerstruktur** nachgezogen — VORHER Ist-vs-Soll-Diff erstellen (origin-URLs = Ist-Pfade), Konvention bestätigen lassen, dann Transfers (Historie+Redirects, nie Copy+Delete, nichts löschen).
8. **Build-Übergang:** bis das hauseigene Buildsystem fertig ist, läuft die Direktentwicklung PARALLEL über CI+CMake; `buildsystem.xml` bleibt unangetastet (eigener Buildsystem-Agent). Halbfertige Funktionen in notwendigen Modulen werden fertiggestellt.
9. **Beweis-Disziplin:** jeder Schritt lokal + CI strikt grün; Ledger additiv; Doku nie löschen.

## 2. Taxonomie-Anker des Piloten (verbindlich, User 07.07.)

- **comdare-cache-engine = Framework-MODUL** (Mess-/Achsen-Framework); **die Diplomarbeit = dessen PRODUCT und Außeninterface.**
- **comdare-prt-art = MODUL** (neben der cache-engine).
- **Overleaf-/Thesis-Projekt = PRODUCT ohne Baseline-Struktur** (kein C++/Java/Python/Go/Rust-Projekt).
- Fernziel (F4): cache-engine + Diplomarbeit als **Piloten der automatischen Buildsystem-Optimierung** (Achsen = wiederverwendbare Organ-Bestandteile mit getesteten Interfaces; Buildsystem = Product mit eigener Interface-Ebene, bestückt Programme automatisch mit Beschleuniger-Code).
