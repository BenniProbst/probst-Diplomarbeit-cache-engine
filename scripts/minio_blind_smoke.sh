#!/bin/bash
# =============================================================================
# MINIO BLIND-SMOKE (#10): findet ein GUELTIGES minio-Schluesselpaar im Vault,
# OHNE je einen Wert auszugeben -- nur Indizes, Laengen, rc.            (scripts/)
# =============================================================================
#
# ZWECK
#   Prueft, ob im Vault ein <access,secret>-Paar liegt, mit dem sich ein minio-
#   Endpunkt oeffnen laesst (mc ls). Ergebnis ist EIN Bit fuer den Aufrufer:
#   exit 0 = ein Paar oeffnet, exit 1 = KEIN Paar oeffnet. Nie ein Klartext-Wert
#   auf stdout -- der Blind-Teil ist der Punkt (Vault-Werte bleiben im Vault).
#   Anlass 13.08.2026: der Lauf war ROT (kein gueltiges Paar in beiden Vaults,
#   beiden Endpunkten, rueckwaerts) -- Beleg fuer die Owner-Vorlage #10, dass
#   die Keys neu erzeugt werden muessen (Infra/MinIO-Admin-Territorium).
#
# VAULT-DOKTRIN (Memory 'VAULT NIE GREPPEN')
#   Vault-Dateien werden NICHT gegrept, sondern BLIND per mapfile eingelesen und
#   Token fuer Token als Kandidat probiert. Dieses Skript liest die Zeilen mit
#   mapfile, zerlegt sie mechanisch und probiert JEDE Paar-Rolle (a als access +
#   b als secret UND umgekehrt) an BEIDEN Endpunkten, rueckwaerts (neueste Zeilen
#   zuerst). Es liest die Vaults nur -- es schreibt sie nie, druckt keinen Wert.
#   Grenze deklariert: nur Paare AUS DERSELBEN Zeile werden getestet, keine
#   Cross-Zeilen-Kombinationen (die Ausgabezeile am Ende sagt es).
#
# K13 -- DER KOEDER MUSS BEISSEN (vor jeder Null)
#   Vor der Vault-Schleife wird je Endpunkt ein GARANTIERT falsches Paar
#   ('koederAK...'/'koederSK...') geprobt; es MUSS rc!=0 liefern. Tut es das
#   nicht, ist die spaetere 'KEIN PAAR GRUEN'-Null wertlos (das Werkzeug oder die
#   Verbindung waere kaputt, nicht der Vault leer). Der Koeder-rc steht in der
#   Ausgabe ('KOEDER @<ep> rc=N (MUSS !=0)') -- er ist der Biss-Beleg.
#
# AUFRUF
#   bash scripts/minio_blind_smoke.sh
# EXIT
#   0 = ein Paar oeffnet (TREFFER-Zeile nennt Vault/Zeile/Position/Endpunkt)
#   1 = kein Paar oeffnet (echte Null NUR gueltig, wenn der Koeder oben biss)
#
# ABHAENGIGKEITEN: mc (MinIO-Client) unter /usr/local/bin/mc; Vault-Dateien unter
#   Cluster/keys/. Beide sind Infra-Bestand, kein Repo-Inhalt -- fehlen sie,
#   scheitert der Lauf laut (kein stilles Gruen).
# ASCII-only. Herkunft: minio_blind_smoke_v2.sh (Job-tmp 5a19728e, 13.08.2026),
#   hier versioniert, damit das Werkzeug nicht mit dem Job stirbt (NE-11b).
# =============================================================================
set -u
MC=/usr/local/bin/mc
ENDPOINTS=("minio.comdare.de:9000" "minio.comdare.local:9000")
VAULTS=(/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-DEV.md
        /home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-PROD.md)

probe() { MC_HOST_probe="https://$1:$2@$3" timeout 12 "$MC" --insecure ls probe/ >/dev/null 2>&1; }

# Koeder (Mechanik-Beweis) einmal je Endpunkt:
for ep in "${ENDPOINTS[@]}"; do
  probe "koederAK1234567890" "koederSK123456789012345678901234" "$ep"; echo "KOEDER @$ep rc=$? (MUSS !=0)"
done

for vf in "${VAULTS[@]}"; do
  mapfile -t Z < "$vf"
  # Zeilen rueckwaerts (neueste Eintraege unten):
  for (( i=${#Z[@]}-1; i>=0; i-- )); do
    lc="${Z[$i],,}"
    [[ "$lc" == *minio* ]] || continue
    [[ "$lc" == *entwertet* ]] && { echo "$(basename $vf) Z$i: markiert 'entwertet' - uebersprungen"; continue; }
    read -ra T <<< "${Z[$i]//[|:=\`]/ }"
    cands=()
    for t in "${T[@]}"; do
      n=${#t}
      if [ $n -ge 12 ] && [ $n -le 64 ] && [[ "$t" =~ [0-9] ]] && [[ "$t" =~ ^[A-Za-z0-9+/_.-]+$ ]]; then
        cands+=("$t")
      fi
    done
    [ ${#cands[@]} -ge 2 ] || continue
    for (( a=0; a<${#cands[@]}; a++ )); do
      for (( b=0; b<${#cands[@]}; b++ )); do
        [ $a -eq $b ] && continue
        for ep in "${ENDPOINTS[@]}"; do
          if probe "${cands[$a]}" "${cands[$b]}" "$ep"; then
            echo "TREFFER: $(basename $vf) Z$i pos$a(L${#cands[$a]}) als ACCESS + pos$b(L${#cands[$b]}) als SECRET @$ep"
            nb=$(MC_HOST_probe="https://${cands[$a]}:${cands[$b]}@$ep" \
                   timeout 12 "$MC" --insecure ls probe/ 2>/dev/null | wc -l)
            echo "Buckets sichtbar: $nb"
            exit 0
          fi
        done
      done
    done
    echo "$(basename $vf) Z$i: ${#cands[@]} Kandidaten, alle Paar-Rollen rot"
  done
done
echo "KEIN PAAR GRUEN (v2, Paar-aus-Zeile; Cross-Zeilen-Paare NICHT getestet)"
exit 1
