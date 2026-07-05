---
name: feedback_never_guess_always_lookup_state_of_art_and_docs
description: Raten STETS verboten; bei JEDER Unsicherheit teure Planungssession gegen Architektur + Doku + aktuellen Ist-Stand VOR Design/Code/Behauptung
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

**Raten ist IMMER verboten.** Jede Definitions-, Architektur-, Begriffs-, Modell- oder **Netz-/Pfad**-Unklarheit erzwingt einen bewusst teuren Lookup, BEVOR implementiert oder etwas behauptet wird: (1) **Stand der Technik** (Web-Recherche / etablierte Spezifikation) UND (2) die **Projekt-Dokumentation** (Architektur-Dokumente, Memory, Ledger) UND (3) der **aktuelle Ist-Stand** (live verifizieren).

**Bei Unsicherheit: teure Planungssession ist PFLICHT (User 2026-06-04).** Statt zu raten oder „plausibel" zu bauen, IMMER eine bewusst teure Planungssession fahren, die den Plan gegen **(a) die Architektur, (b) die Dokumentation und (c) den aktuellen Stand** prüft — BEVOR gebaut wird. Lieber teuer planen (oder den User fragen) als raten. Gilt verschärft für alles, was die Netz-/VLAN-/Cross-Site-/Storage-/Identitäts-Architektur berührt.

**Why:** Wiederholte schwere Fehler entstanden ausschließlich durch Raten statt Lookup/Planung — die korrekte Vorgabe stand bereits in Doku/Memory:
- **Infra (2026-06-04):** Cross-Cluster-Monitoring #57 als **direkten** dev-Prometheus→prod-kubelet `10.0.15.x:10250`-Scrape + monitoring-NetPol-Egress `ipBlock 10.0.0.0/16` gebaut → **Verstoß gegen die HAProxy-Cross-VLAN-Isolations-Grunddirektive** ([[feedback_haproxy_vlan_isolation_principle]], [[feedback_vlan_ip_isolation_strict]], [[feedback_per_service_vip_isolation_service_chains]]: Cross-VLAN NUR über HAProxy + echte CARP-VIP). Ursache: k8s-Mechanik erschlossen statt gegen die COMDARE-Architektur geplant. Vom User gestoppt („schon wieder"). Zurückgerollt, dann Planungssession.
- **Thesis:** queuing-als-Gattung / Adapter-als-Gattung — Doc 27/30/24 hatten es wörtlich korrekt; ich verletzte sogar meine eigene Korrektur im Code.

**How to apply:** Bei JEDER Unklarheit zuerst `grep`/`read` der Architektur-Dokumente + Memory-Recall + Live-Ist-Check, plus ggf. Web-Recherche — ERST dann Design, dann Code. Für nicht-triviale / architektur-berührende Schritte (Netz, VLAN, Cross-Site, Storage, Identität) eine explizite teure Planungssession gegen Architektur+Doku+Ist fahren, bevor gebaut wird. Kein „klingt plausibel". Verschärfend zusätzlich zu [[feedback_web_research_per_algorithm_pflicht]] und [[feedback_no_success_marks_without_literal_output]] (User 2026-06-03/2026-06-04).

**SCHÄRFUNG (User 2026-06-14, FritzBox-V75-Vorfall):** Der User hat das GESAMTE COMDARE-System von Anfang an vollständig durchgeplant — **der Plan EXISTIERT bereits in den Docs.** Meine Aufgabe ist IMMER nur: die zuständige Plan-Doku FINDEN + LESEN, bevor ich handle/behaupte. **NIE blind probieren** (ping/ARP/curl gegen eine Ziel-IP, die laut Plan erst NACH Konfiguration existiert) und daraus „offline/blockiert" folgern. **Verstoß:** FritzBox 5590 (V75) per random ping/ARP/curl gegen `10.0.75.10` als „offline" deklariert — dabei stand in `docs/architecture/V75-FRITZBOX-VOICE-BUILDOUT-K80.md` wörtlich „.10 noch NICHT erreichbar (ARP incomplete) ⏳ User/physisch; Verbleibt: FritzBox-Config + Kabel + FGT-Seite muss V75 tragen". Die FritzBox/SIP/V75-Pläne liegen in: `V75-FRITZBOX-VOICE-BUILDOUT-K80.md`, `EDGE-V1-OUTSIDE-RECHERCHE-K80.md`, `15_CBS250_CBS350_PORT_LAYOUT.md`, Alt-System `roles/04_external_infra/fritzbox_outside/`, `docs/02_NETZWERK_VLAN_PLAN.txt`, Tasks #33/#34, IMPL-PLAN §13. → Bei Hardware-/Netz-/Erreichbarkeits-Fragen ZUERST `grep` nach Gerätename/VLAN/Funktion (FRITZ/SIP/V75/…) → Plan-Doku lesen → gegen Architektur denken → DANN erst eine Live-Probe (und deren Ergebnis gegen den Plan interpretieren, nicht roh).
