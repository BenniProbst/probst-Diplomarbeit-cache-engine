---
name: feedback_all_comdare_cpp_drogon_other_langs_are_feature_sources
description: "ALLE comdare-Projekte sind C++ — auch Webserver (Drogon-Framework). Projekte in anderen Sprachen (Java/Spring, JS/Zendesk, Python …) sind KEINE comdare-Produkte, sondern NUR Feature-Quellen für eine künftige C++/Drogon-Neuimplementierung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c6f15797-7fa1-4e66-874f-55631afe1d28
---

**Direktive (User, 2026-07-03):** Alle comdare-Projekte sind **C++**. Selbst die Webserver werden mit **Drogon** (C++-Web-Framework) gebaut — nicht Java/Spring, nicht Node, nicht Python.

**Konsequenz:** Ein Projekt in einer ANDEREN Programmiersprache ist per Definition KEIN comdare-Produkt, sondern dient ausschließlich als **Feature-Quelle** (Konzept-/Anforderungsspender). Die eigentliche comdare-Umsetzung wird als C++/Drogon-Produkt nach Baseline-Methodik neu implementiert und teilt dabei die comdare-Modules.

**Betroffene Beispiele (Stand 2026-07-03):**
- *****REDACTED***** (Java/Spring-Boot-Backend `zenanalytics.jar` + Zendesk-Frontend JS) = Feature-Quelle, NICHT das comdare-Produkt. Die „zentrale comdare-API + Webseite + Unternehmens-Steuerung" wird C++/Drogon.
- *****REDACTED***** (Konzept/JS) = Feature-Quelle.
- comdare-db, comdare-cache-engine, Steuerrater A/B, BuildSystem, Business-Plattform-Runtime = echte C++-comdare-Produkte.

**How to apply:** Bei Discovery/Planung fremdsprachiger Repos NIE „das ist das comdare-Produkt" schließen — immer als Feature-Quelle behandeln und die C++/Drogon-Zielarchitektur separat nach Baseline-Methodik planen ([[feedback_baseline_system_in_stein_gemeisselt_layering]]). Web-Layer eines comdare-Produkts = Drogon. Siehe [[project_deferred_steuerrater_buildsystem_***REDACTED***]].
