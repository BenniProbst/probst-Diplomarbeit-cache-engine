# STANDARDPROZESS: Umwandlung eines Research-Projekts in ein Product (v1, 2026-07-07)

**Quelle:** User-Definition 07.07. (Chat, wörtlich verankert in Ledger §12) · Pilot = Diplomarbeit/cache-engine (#274). Dieses Dokument ist der wiederverwendbare Prozess für JEDES künftige Research-Projekt, das Product werden will.

> **Nachtrag 2026-07-09 (additiv, orthogonal):** Die hier definierte **3D-Matrix (Familien × Baseline-Stufen × Module)** ist die **Modul-/Instanziierungs-Struktur (E0-Querschnitt + Product/Research-Matrix)** — sie ist **orthogonal** zur **E0-E4-Experiment-Maschinerie** (Experiment-Pipeline-Modell der Diplomarbeit, `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` + Ledger `§10.1`). Die Matrix ordnet den CODE (WO lebt ein Modul); E0-E4 fährt das EXPERIMENT (XML→B+-Baum→Binary→RC). Kein Widerspruch, zwei orthogonale Achsen.

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

## 1b. Ergänzungen aus den User-Antworten A–D (07.07., zweite Runde)

- **Product-Familien heißen `comdare-<familie>-product`** (NICHT `-all`) und beherbergen **nur das benötigte SUBSET** der für das Product relevanten Module unter den Baselines. **Ist eine Baseline leer, wird ihr Ordner NICHT angelegt.** Products sind die **Instanzen** der Module (binary-kompilierbar) mit **eigener Gruppenstruktur als Subset-Abklatsch** der generischen Modulschicht.
- **cache-engine-Familie bestätigt** (B „wie empfohlen" = GOALV2-Teil-2-Stufung 0-isa/1-measurement/2-core/3-search-engine/4-build-tools+test-system als Empfehlungsbasis): der domänenspezifische Kern wird eigene Modules-Familie; **prt-art ist eine abstrakte Anordnung neuer Algorithmen unter BESTEHENDEN Achsen → Achsen-erweiterndes Metaprogrammierungs-Modul IN der cache-engine-Familie** (kein eigenes Familien-Repo).
- **D-Prinzip:** Beim Anlegen neuer Familien-/Product-Matrizen wird vom **Prinzip und System** der bestehenden Strukturen abgeleitet, NICHT von den Themen der einzelnen Baselines — die Stufen-NAMEN sind je Familie individuell.
- **Normative Quelle gefunden:** `docs/sessions/20260705-matrix-grundlagen-goalv2/MATRIX-GRUNDLAGEN-GOALV2.md` (Teil 1 = kanonische Regeln INV-1..4 + Zellen-Konventionen; Teil 4/1.3-Fassaden per Ledger-§9-Doktrin qualifiziert).
- **GitLab-Abbildungs-Constraint (technisch):** GitLab kann Projekte nicht UNTER Projekten nesten — der lokale Umbrella-Ordner (zugleich Repo UND Container der Zellen) wird als **Familien-GRUPPE + Umbrella-PROJEKT darin** gespiegelt; Baseline-Stufen als UNTERGRUPPEN mit den Zellen-Projekten. Massen-Nachzug (B6) erst nach expliziter Konventions-Bestätigung je Kategorie.

## 2. Taxonomie-Anker des Piloten (verbindlich, User 07.07.)

- **comdare-cache-engine = Framework-MODUL** (Mess-/Achsen-Framework); **die Diplomarbeit = dessen PRODUCT und Außeninterface.**
- **comdare-prt-art = MODUL** (neben der cache-engine).
- **Overleaf-/Thesis-Projekt = PRODUCT ohne Baseline-Struktur** (kein C++/Java/Python/Go/Rust-Projekt).
- Fernziel (F4): cache-engine + Diplomarbeit als **Piloten der automatischen Buildsystem-Optimierung** (Achsen = wiederverwendbare Organ-Bestandteile mit getesteten Interfaces; Buildsystem = Product mit eigener Interface-Ebene, bestückt Programme automatisch mit Beschleuniger-Code).
