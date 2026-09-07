# measure_out_d03 -- VERSCHOBEN auf das NAS (Owner G-096, 07.09.2026 12:12:56Z)

Owner verbatim (ASCII-Transliteration): "Bitte verschiebe es in den workflow backup Ordner auf dem NAS und dann loesche
es
durch einen commit lokal (->verschieben). Daher (a) raeumen und verschieben ins NAS."
Quelle: Code/measure_out_d03 (untracked, .gitignore; 66 Dateien, 3.7 MB, juengste mtime 2026-07-26; Messdaten der Debug-
Stufe d03 -- nie geloescht, nur verschoben).
Ziel (NAS backup2, NFS 10.0.20.242):
mnt/backup2-nfs/sessions-rohdaten/workflow-backups-prod1-lead-5a19728e/probst-diplomarbeit-cache-engine/Code/
  measure_out_d03-VERSCHOBEN-20260907
Manifest: <Ziel>.MANIFEST-md5.txt (66 Dateien, md5 Quelle == Ziel verifiziert 2026-09-07T12:36:55Z).
Hinweis: sessions-rohdaten/workflow-backups/ ist root:root 755 (fuer den Lead nicht schreibbar, seit dem root-mv
06.09.);
deshalb liegt die Kopie im Schwester-Ordner workflow-backups-prod1-lead-5a19728e/ (comdare-eigen). Infra-Handgriff
(Handout):
Ordner nach workflow-backups/ mergen oder die Lead-Ordner dort auf comdare chown-en.
Folge: cppcheck-Wache V-3 (#135/#147) hatte auf diesem ignorierten Ordner rot geschlagen -- Gegenstand entfaellt.
