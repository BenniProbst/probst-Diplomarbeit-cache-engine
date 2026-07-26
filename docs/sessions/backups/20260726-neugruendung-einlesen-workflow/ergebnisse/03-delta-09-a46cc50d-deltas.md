## Eintrag 1

**kategorie:** user_direktive

**was:** Zielauftrag ueber alles (11.07., Ledger-verankert als §0-DoD-6 / §11-G / Task #22): die Diplomarbeit-Pipeline muss die Auswertungsdokumente (LaTeX-PDF + Messwerte-CSV) beim Lauf ueber die cache-engine erzeugen UND am Pipeline-Ende automatisch nach development ZURUECKSCHREIBEN (sonst gehen die Messergebnisse verloren); je Lauf ein datierter Ordner im Diplomarbeit-Root unter measurement/ (User-Wunsch YYYYMMTT-HH:SS, wegen Windows-illegalem ':' FS-sicher als YYYYMMDD-HHMMSS notiert = offener Klaerungspunkt G-a); git-Datenakkumulation ist bewusst akzeptiert; SPAETER zusaetzlich PARALLEL nach backup1.comdare.de/Cluster_NFS/cache-engine-experiment mit denselben datierten Ordnern. Das Dossier nennt weder den measurement/-Rueckschreib-Zweig noch den NFS-Zielpfad (nur DUAL-CCACHE minio/NAS in 3.7).

**beleg:** verlauf-09.txt:1661

## Eintrag 2

**kategorie:** offener_faden

**was:** #22 persist:measurements ist bis Chunk-Ende NUR ein reviewter Design-Entwurf, NICHT implementiert: Stage 'persist', inert-by-default (rules gaten auf COMDARE_PERSIST_MEASUREMENTS=='true' && CI_COMMIT_BRANCH=='development'), Push nur mit COMDARE_WRITEBACK_USER/COMDARE_WRITEBACK_TOKEN (= offener Punkt G-b: der REV-17-Deploy-Token ist bewusst read-only, ein write_repository-Credential fehlt noch), dreifacher Loop-Schutz (push -o ci.skip + '[skip ci]' + rules _bot_ -> never), needs auf thesis:pdf(optional)/manifest:provenance/prebackup:measurements, GIT_DEPTH=0 load-bearing. Vorlage = bestehendes prebackup:measurements-Pattern (additiv, sha256-verifiziert, NIE ueberschreiben); ein measurement/-Ordner existierte damals nicht. Im Dossier-Board (#1-#5) fehlt dieser Faden vollstaendig.

**beleg:** verlauf-09.txt:1738

## Eintrag 3

**kategorie:** widerspruch_zum_dossier

**was:** Der vom Design-Workflow gelieferte persist:measurements-Entwurf implementiert die non-ff-Behandlung als 'git rebase origin/$CI_COMMIT_BRANCH' mit 5x-Retry, obwohl der Owner unmittelbar vorher entschieden hat: 'die Rueckschreibung erfolgt per MERGE, nicht rebase' und das Dossier/Memory bindend 'NIE rebase; vor Push fetch+merge' festschreibt. Der Entwurf wurde als Draft gesichert, die Merge-Korrektur war nur angekuendigt ('ich review sein Ergebnis genau darauf') - ungeprueft, ob sie im spaeteren Code gelandet ist.

**beleg:** verlauf-09.txt:1724

## Eintrag 4

**kategorie:** fakt

**was:** Definitive Wurzel des super-Submodul-CI-Blockers (nach 3 Fehlversuchen REV13/14/15): der GitLab-Runner klont mit CLEAN URLs und injiziert das CI_JOB_TOKEN via 'http.extraheader' (nicht als URL-Credential) -> KEINE insteadOf-Regel matcht; zudem identifiziert sich das Token falsch als 'cd-buildsystem-construct' und hat genuin kein Cross-Projekt-Klon-Recht ('Authentication by CI/CD job token not allowed ... to project #286'). Wirksam wurde erst REV 17 (Deploy-Token-URLs direkt in .gitmodules), weil 'git submodule --init' URL-Overrides mit der origin-aufgeloesten CI_JOB_TOKEN-URL ueberschreibt. Group-Deploy-Token 'gitlab+deploy-token-39' (read_repository, Gruppe comdare/research) als maskierte super-CI-Variable (CE_SUBMODULE_TOKEN, masked=True, non-protected). Das Dossier nennt diese Mechanik und die Token-Namen nicht.

**beleg:** verlauf-09.txt:1441

## Eintrag 5

**kategorie:** fakt

**was:** Daten-Ehrlichkeits-Regel aus dem T8-Phantom-Fix (Fix B, ce fa9f31ac/b3224369): eine RT-Achse, die gespeichert aber nicht konsumiert wird, darf NICHT im applied_axis_count erscheinen (Vertrag resource_controllable_tier.hpp:66-67 'real angenommen'); konkret thread_count = label-only, applied 5->4 (test_e2_contract_abi_vertrag.cpp:99), m3v2_study.profile.xml:138 von '1 2 4' auf 1 gepinnt, test_d13_dll_runtime_measure zum Phantom-Guard umgebaut. Folgerung des Assistenten: der lokale golden-320-Lauf ist damit Pipeline-Validierung, NICHT die finale Datenbasis (auch hw_prefetcher ist MSR-Cluster-only). Dossier nennt die analoge Ehrlichkeits-Doktrin nur fuer disk_writeback, nicht diese Regel/den T8-Guard.

**beleg:** verlauf-09.txt:1339

## Eintrag 6

**kategorie:** fakt

**was:** GitLab-Projekt-IDs des Diplom-Verbunds: ce=286, super=288, thesis/20260931-overleaf-diplomarbeit=289 (prt-art als drittes Submodul mit Gitlink faa4e76e). Das Dossier nennt nur super=288 und ce=286; die thesis-Projekt-ID 289 fehlt, ist aber fuer den offenen overleaf-Merge (Board #2) und Submodul-Auth load-bearing.

**beleg:** verlauf-09.txt:187
