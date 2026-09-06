# docs/sessions/backups -- VERSCHOBEN auf das NAS (06.09.2026)

Owner-Wort 06.09.2026 (verbatim): "Es wird lokal NUR die backup workflows unter den Sessions ins NAS verschoben, sonst
nichts." Praezedenz: Cluster-Repo Commit 4f807378 (A-16 Quell-Entfernung, 05.09.2026).

- Ziel: backup2 (10.0.20.242, NFS /mnt/backup2-nfs) `sessions-rohdaten/workflow-backups/probst-diplomarbeit-cache-engine/
  docs/sessions/backups/` -- 4946 Dateien (4047 git-getrackt + 899 ignorierte Log-/Rohdateien), 598 MB, root:root.
- Nachweis: `sessions-rohdaten/workflow-backups/.MANIFESTE/M-src-20260906-probst-diplomarbeit-cache-engine.sha256`
  (sha256 der Quelle bei git HEAD 768ede76, Pfade repo-relativ) und `M-nas-20260906-...sha256` (NAS-Kopie nach
  Redaktion); rsync -rc Verify vor der Redaktion: 0 Differenzen bei 4946/4946 Dateien.
- 81 Dateien wurden auf der NAS-Kopie redigiert (Secret-Klassen urlcred 205 + runners_token 777 Treffer in alten
  Workflow-Rohdaten; Liste `M-diff-src-vs-nas-20260906-...txt`). Die Git-Historie traegt die Originale weiter.
- Die Ordner dieses Verzeichnisses (20260709-... bis 20260824-vollaudit-welle2-stand) sind ueber die Git-Historie
  (bis Commit 768ede76) und ueber das NAS erreichbar. Verweise in Ledger/Plaenen auf docs/sessions/backups/... zeigen
  auf den NAS-Pfad mit demselben Unterpfad.
