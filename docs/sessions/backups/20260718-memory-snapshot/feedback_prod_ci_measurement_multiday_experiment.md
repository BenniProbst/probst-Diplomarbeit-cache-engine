---
name: feedback_prod_ci_measurement_multiday_experiment
description: "Die prod-GitLab-CI-Mess-Pipeline (comdare-cache-engine 286: build:amd/intel→measure:amd/intel, PMC über viele Tiere/Permutationen) ist ein MEHRTÄGIGES wissenschaftliches Experiment → NICHT aktiv pollen/darauf warten, nur passiv im Hintergrund beobachten"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 885d4915-6f41-4b18-9770-e729576e9fee
---

User 2026-06-25: **„Die Pipeline ist ein wissenschaftliches Experiment über mehrere Tage, warte nicht aktiv darauf, sondern nur im Hintergrund."**

**Kontext:** Nach dem Entsperren der prod-GitLab-CI (Runner-Restart, MinIO-Cache, Toolchain) läuft die Mess-Pipeline auf `comdare/research/comdare-cache-engine` (286): `build:amd`@prod1 / `build:intel`@prod2 → `measure:amd`/`measure:intel` (PMC/Cache-Miss über 320 `.so` × viele Permutations-„Tiere", #156-Voll-Mess-Lauf). Die `measure`-Stage läuft **Tage** (reproduzierbare ns/Cache-Miss-Werte über viele Läufe).

**Why:** Aktives Polling (`sleep`+Status-Check in Schleife) der Pipeline ist Verschwendung + blockiert den Loop sinnlos — die Jobs ändern sich über Stunden/Tage nicht. Mein Infra-Auftrag (CI bauen-lassen mit Cache+Toolchain) ist mit `build:amd`=SUCCESS + laufender measure-Stage **erfüllt**; die Messung selbst gehört dem Impl-Agenten.

**How to apply:** Nach dem Entsperren NICHT auf Pipeline-Grün warten. Höchstens EIN Status-Snapshot pro Sitzung/auf Nachfrage. Wenn Hintergrund-Beobachtung gewünscht: langer Intervall (Stunden), kein Minuten-Poll. Erfolgskriterium meiner Arbeit = build läuft + Cache/Toolchain/PMC nachgewiesen, NICHT measure-Abschluss. Verwandt: [[feedback_implementation_agent_delegates_infra_via_k78]].
