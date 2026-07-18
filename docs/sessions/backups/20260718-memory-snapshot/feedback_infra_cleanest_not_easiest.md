---
name: feedback_infra_cleanest_not_easiest
description: "IMMER die sauberste UND wartbarste Strategie wählen, NIE die einfachste — gilt für ALLE Entscheidungen (Code, Architektur, Infra, Strategie), nicht nur Infra (User 2026-06-17, generalisiert 2026-07-01)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

User-Direktive (2026-06-17): **Bei Infrastruktur müssen wir immer den SAUBERSTEN, nicht den einfachsten Weg wählen** — auch wenn er aufwändiger ist. Kein Quick-Bypass/Shortcut, der eine Architektur-Direktive umgeht.

**Generalisierung (User 2026-07-01, wörtlich „nie die einfachste, sondern immer die sauberste und wartbarste Strategie, merke dir das"):** Gilt für ALLE Entscheidungen — Code, Architektur, Infra, Strategie — NICHT nur Infra. Mehr Dateien/Aufwand für saubere Konsistenz + Wartbarkeit ist GERECHTFERTIGT und gewollt. Nie „minimal/simpel für Durchsatz" als Begründung; immer die konsistente, wartbare Variante (z.B. eigenes Enable-Flag je Wrapper statt Wiederverwendung eines Familien-Flags; etablierte Präzedenzfälle spiegeln). Verwandt: [[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]] · [[feedback_no_quick_fixes]] · [[feedback_thorough_assumptions_workflow_planning]].

**Why:** Architektur-Konsistenz + langfristige Wartbarkeit/DR-Korrektheit > kurzfristiger Aufwand. Ein Bypass verschiebt das Problem nur und verletzt die etablierten Direktiven (HAProxy-überall, Per-Service-VIP, 3-Abstraktionsebenen, BGP-ECMP, VLAN-Isolation).

**How to apply:** Vor jeder Infra-Entscheidung die Architektur-Direktiven prüfen + die saubere Variante wählen; bei Unsicherheit Planungssession (siehe [[feedback_never_guess_always_lookup_state_of_art_and_docs]]). Einen Shortcut NUR mit ausdrücklicher User-Freigabe.

**Pflicht-Prozess (User 2026-06-17, Schärfung):** (1) IMMER ZUERST in den Docs recherchieren, BEVOR gehandelt wird. (2) Für ALLE Lösungen AUSSER der offensichtlich-saubersten ist zusätzlich **Web-Recherche PFLICHT** (Stand der Technik). (3) **Die VLAN-Isolierung darf NIEMALS durch die HAProxy-Weiterleitung gebrochen werden** — die HAProxy-CARP-VIP-Weiterleitung IST der Isolations-Mechanismus; Cross-VLAN-Zugriff ausschließlich darüber, NIE ein Bypass/direkter Cross-VLAN-Pfad. Verschärft [[feedback_haproxy_vlan_isolation_principle]].

**Konkret-Anlass:** Longhorn-BackupTarget LB-IP `10.0.80.223` (V80) ist vom Node/Host-Kontext nicht erreichbar (**calico#9152** Blackhole für BGP-announcte LB-IPs; aus Pods erreichbar). Der EINFACHE Weg (BackupTarget auf ClusterIP/svc-DNS umbiegen) = Bypass der Per-Service-VIP/HAProxy-Architektur → **VERWORFEN**. Saubere Optionen stattdessen: OPN-HAProxy-CARP-VIP für das Backup-Ziel (Node erreicht die echte-VLAN-VIP, OPN als BGP-Empfänger erreicht .223), ODER off-cluster-Backup-Ziel (S3/MinIO/NAS — erfüllt zugleich 3-2-1-DR). Verwandt: [[feedback_haproxy_vlan_isolation_principle]], [[feedback_per_service_vip_isolation_service_chains]].

**DEFINITION „sauber" (auf User-Nachfrage 2026-07-06 fixiert; Prüfliste in dieser Reihenfolge):**
1. **Architektur-konform:** folgt den etablierten Invarianten des Projekts (Baseline-Matrix INV-1..4 + Feingliederung, ABI-4-Freeze, Achsen-/Gattungs-Taxonomie, compile-time-Metaprogrammierung [[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]]) statt sie zu umgehen — Verstöße sind Blocker, nie Workaround.
2. **Offizieller Weg:** offizielle Build-/Test-/Verify-Pfade (CMake/ctest, CI-Pipeline als Beweis, dokumentierte Prerequisites) — keine parallelen Behelfswege, Scratch-Skripte, Bypässe [[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]].
3. **Wissenschaftlich ehrlich:** Messpfad unverfälscht (compile-time bleibt compile-time, kein künstlicher Laufzeit-Overhead), keine Attrappen/fabrizierten Werte (honest-0 statt Erfindung), golden-320/Oracle/Messdaten unantastbar, jede Erfolgsmarke literal belegt [[feedback_no_success_marks_without_literal_output]].
4. **Konsistent + wartbar:** spiegelt etablierte Präzedenzmuster (S7-1-Muster, Sammel-Target-Muster, ext/-Vendor-Muster), ein Konzept an einem Ort, Konventionen (Namespace/Include/Branch/Format) eingehalten — auch wenn es MEHR Dateien/Aufwand kostet als die einfache Variante.
5. **Wiederverwendend:** Bestehendes nutzen statt neu erfinden (Matrix-Reuse: bestehende Haupt-/Baseline-Module linken, mit abgeleiteten Modulen erweitern) — Neuanlage nur nach Bestandsprüfung.
6. **Nachvollziehbar + reversibel:** granulare Commits mit Beleg, additive Doku/Rohdaten (nie löschen), Ledger fortgeschrieben, beide Remotes.
**NICHT sauber (Negativliste):** die einfachste/schnellste Lösung als Selbstzweck · Quick-Fix/Workaround · unbegründete Suppression · Silent-Fallback/QUIET/Dummy · Runtime-Krücke statt Template · Löschen statt Markieren · ungeprüfte Codex-Übernahme · Erfolgsmarke ohne literale Ausgabe.
