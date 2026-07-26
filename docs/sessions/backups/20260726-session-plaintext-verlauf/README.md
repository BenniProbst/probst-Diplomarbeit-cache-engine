# Plaintext-Session-Verlauf (Sicherung wegen API-Instabilitaet, 26.07.)

Redigierter Klartext-Verlauf (User+Assistant-sichtbarer Text, tool-Bloecke/thinking entfernt)
der Manager-Session 46375cdc, in 32 Chunks (verlauf-NN.txt). Quelle 221 MB jsonl; 24 Redaktionen
per 233-Regel-Pass, regel-bewusster 0-Treffer-Verify. Reine SICHERUNG — keine Struktur-Autoritaet
(die liegt in den benannten Session-Docs + Memories). Agent-Volltranskripte nie committet.
Ergaenzt die Owner-Antworten-Doku 20260726-SESSION-layer-modell-antworten-QA-QF-stempel-doktrin.md.

## Nachtrag: verlauf-queued-ergaenzung-NN.txt (Extraktor-Luecke geschlossen)

Der Extraktor der verlauf-NN.txt hat Records vom Typ `attachment.queued_command` verworfen.
Diese 6 Dateien tragen alle 982 solcher Records nach (Owner-Prompts + Task-Benachrichtigungen,
alle isSidechain=false), chronologisch, je Eintrag `=== jsonl:ZEILE TIMESTAMP [commandMode/origin] ===`
plus Klartext. Deckungsanalyse gegen verlauf-NN.txt: 526 Eintraege sind NEU (88 commandMode=prompt,
438 task-notification), 456 lagen bereits vor (sie erschienen dort als regulaere user-Message):
bewusst vollstaendig gesichert statt gefiltert, die jsonl-Zeilennummer macht jeden Eintrag zuordenbar.
Redaktion per 233-Regel-Pass (Regel-md5 2ae0ce0e8a1af561936cd1d879ba06a9): 4 Ersetzungen
(3x gitlab-pat, 1x minio-credentials, beides Credential-NAMEN, keine Werte). Verify: 0 Treffer fuer
glpat-/glrt-/glft-/github_pat_/ghp_/sk-ant-/AKIA/PEM/ssh-pubkey mit Wert; die verbleibenden
Wort-Treffer (token/secret/passwortlos, Bearer-freie ${CI_JOB_TOKEN}-Platzhalter, SSHPASS-Ortsangabe)
sind Prosa und einzeln beurteilt. Quell-jsonl (221 MB, enthaelt Live-Tokens) ist NICHT im Repo.
