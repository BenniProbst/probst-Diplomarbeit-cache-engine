---
name: project_struktur_regression_geteilte_klone_statt_instanz_repos
description: "User 07.07. — STRUKTUR-REGRESSION notiert: (1) geteilte Klone/Mehrfach-Einbettungen statt eigener Instanz-Repos (Opus-4.1-Aera); (2) ALT-NAMING 'redcomponent' und 'bep' als Technik-/Produkt-Praefixe — Marke ist Comdare, Firma ist 'BEP Venture UG' (nur juristisch/Lizenztexte). Aufloesung = Teil der #274-Migration, nicht der Branch-Konsolidierung."
metadata:
  node_type: memory
  type: project
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Feststellung (2026-07-07, waehrend der Fleet-Branch-Konsolidierung):** Zur Zeit der Entwicklung der lokalen Matrix-"Klone" gab es nur Opus 4.1, und es war **nie die Absicht, Klone zu erzeugen** — jedes Projekt muss die bestehenden Module mit **seinen eigenen separaten Repo-Instanzmodulen** anbieten (3D-Matrix-Doktrin: Products/Research bauen eine EIGENE Instanziierungs-Matrix aus eigenen Repos, [[feedback_standardprozess_research_zu_product_matrix_3d]]). **Das Vorgefundene ist eine Struktur-Regression.**

**Belege (Ist-Befund der Konsolidierungs-Session, read-only erhoben):**
- `comdare-config-module` existiert als ZWEI GitLab-Projekte in zwei Familien-Gruppen (`comdare/modules/comdare-foundation/comdare-config-module` id 156 UND `comdare/modules/comdare-config/comdare-config-module` id 155).
- Lokale Matrix-Zellen zeigen per origin (teils via Namespace-Redirect) auf Projekte ANDERER Familien-Positionen (z.B. `Modules/comdare-foundation-all/comdare-baseline_1-core/comdare-config` -> `comdare/modules/comdare-foundation/comdare-config-module`); der Gruppen-vs-Ordner-DIFF (`docs/sessions/20260707-gitlab-gruppen-vs-ordner-DIFF.md`) dokumentiert 268/294 Abweichungen.
- Dokumentierter Altfall: `Modules/comdare-cacheengine-all` bettet DASSELBE Research-Remote ein statt einer eigenen Modul-Instanz ([[project_cache_engine_research_vs_cacheengine_all_split_todo]]).
- Identische origin-URL an mehreren lokalen Positionen: nur prt-art (super-Submodul + Research-Arbeitskopie) = GEWOLLTE Ausnahme (Arbeitskopien EINES Forschungsrepos, [[feedback_diplomarbeit_4_projects_local_clones_keep_in_sync]]), KEINE Regression.

**NAMING-REGRESSION (User-Ergaenzung 07.07., gleiche Kategorie):** Die Woerter **"redcomponent"** und **"bep"** sind als Struktur-Regression notiert. **Marke = Comdare** (alle Produkt-/Modul-/Namespace-/Repo-Namen); **Firma = "BEP Venture UG"** (NUR juristische Entitaet — in LICENSE-/EULA-/Rechtstexten korrekt und zu erhalten). Regressiv sind: `redcomponent`-Namespaces/Header/Modulnamen (z.B. `include/redcomponent/...` in den 4 behaltenen foundation-master-Branches; Historie: "rename redcomponent-* -> comdare-*" P3.1 / S2683 lief bereits, Reste existieren) und `bep`/`BEP` als Technik-/Produkt-Praefix (z.B. tote `BEPBuildSystem`-cmakePackage-Referenz, "BEP-EULA" als Produktlabel). Bei Sweeps: Firmenname "BEP Venture UG" NICHT wegrefactoren.

**Why:** Geteilte Klone verschmelzen die Instanziierungs-Schichten der Matrix (generisches Modul vs. projekt-eigene Binary-Instanz) und brechen INV-3/Product-Matrix-Prinzip; Aenderungen eines Konsumenten schlagen unkontrolliert auf andere durch. Alt-Naming (redcomponent/bep) verwaessert die Marken-Identitaet Comdare und zeigt Alt-System-Staende an.

**How to apply:**
1. KEINE neuen geteilten Einbettungen/Klone anlegen — Modul-Konsum IMMER ueber eine eigene Instanz-Repo-Zelle des konsumierenden Projekts (Research = early Product, gleiche Regel).
2. Die Aufloesung der Bestands-Regression ist ein #274-Migrationsarbeitspaket (Instanz-Repos anlegen, Einbettungen umhaengen, Duplikat-Projekte je Familie klaeren) — NICHT Teil der Branch-Konsolidierung (diese hat nur Branches vereinheitlicht und die Regression SICHTBAR gemacht, nichts verschoben).
3. Vor Aufloesungs-Schritten: Gruppen-vs-Ordner-DIFF + [[feedback_consult_analysis_backups_via_ultracode_before_decisions]] konsultieren; Remote-Anlagen/Transfers nur mit User-GO je Schritt ([[feedback_remote_deletion_requires_explicit_user_authorization]]).
