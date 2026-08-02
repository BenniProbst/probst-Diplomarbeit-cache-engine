#!/usr/bin/env bash
set -u
WD=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/e23
CA=/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt
CFG="$WD/curlrc"; API=https://gitlab.comdare.local/api/v4
G() { curl -s --max-time 60 --cacert "$CA" -K "$CFG" "$@"; }
mkdir -p "$WD/trees" "$WD/readmes"
# Mess-Familie + cacheengine-Familie
for id in 300 76 320 321 293 294 295 296 297 298; do
  : > "$WD/trees/$id.ndjson"
  p=1
  while :; do
    G -o "$WD/_t.json" "$API/projects/$id/repository/tree?recursive=true&per_page=100&page=$p"
    n=$(python3 -c "
import json
d=json.load(open('$WD/_t.json'))
print(len(d) if isinstance(d,list) else 0)" 2>/dev/null || echo 0)
    [ "$n" = "0" ] && break
    python3 -c "
import json
for x in json.load(open('$WD/_t.json')): print(json.dumps(x))" >> "$WD/trees/$id.ndjson"
    p=$((p+1)); [ "$p" -gt 40 ] && break
  done
  br=$(python3 -c "
import json
for l in open('$WD/projects_all.ndjson'):
    d=json.loads(l)
    if d['id']==$id: print(d.get('default_branch') or 'main'); break")
  G -o "$WD/readmes/$id.md" "$API/projects/$id/repository/files/README%2Emd/raw?ref=$br"
  echo "id=$id entries=$(wc -l < "$WD/trees/$id.ndjson") readme_bytes=$(stat -c%s "$WD/readmes/$id.md")"
done
