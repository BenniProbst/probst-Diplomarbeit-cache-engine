---
name: feedback_buildsystem_xml_hands_off_parallel_ci_cmake
description: User 07.07. (F1) — Buildsystem ist HALBFERTIG; bis Fertigstellung parallele Direktentwicklung mit CI+CMake; buildsystem.xml NICHT anfassen (eigener Buildsystem-Agent); halbfertige Funktionen in notwendigen Modulen fertigstellen
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

User-Antwort F1 zur #274-Migration (2026-07-07): Die buildsystem.xml-Dependent-Referenzen sind Artefakte des **eigenen, noch halbfertigen Buildsystems**. Solange es nicht fertig ist: **parallele direkte Entwicklung mit CI und CMake**; die **buildsystem.xml-Dateien in Ruhe lassen — ein anderer Agent kuemmert sich darum**. Referenzmodule werden mit dem eigenen aufzutrennenden cache-engine-Fortschritt fertiggestellt/erweitert; **halbfertige Funktionen werden fertiggestellt, sofern in einem notwendigen Modul erkannt**.

**Why:** Verhindert Scope-Kollision zwischen Diplomarbeits-/Migrations-Agent und Buildsystem-Agent (vgl. [[feedback_comdare_db_and_buildsystem_separate_ledgers]]); buildsystem.xml-Edits meinerseits waeren Doppelarbeit gegen fremden Fortschritt.

**How to apply:** Bei Migration/Transfers (#274 Schritt 3 ff.): NUR CMake-/CI-Referenzen fixen; buildsystem.xml-Aenderungen weder vornehmen noch als Blocker behandeln (im Handover an den Buildsystem-Agenten notieren). Beim Reifen eines notwendigen Moduls entdeckte halbfertige Funktionen: fertigstellen statt umgehen.
