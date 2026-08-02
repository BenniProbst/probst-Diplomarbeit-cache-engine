#!/usr/bin/env bash
set -u
WD=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/e23
CA=/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt
CFG="$WD/curlrc"
API=https://gitlab.comdare.local/api/v4
G() { curl -s --max-time 60 --cacert "$CA" -K "$CFG" "$@"; }

# --- Plausibilitaets-Anker: Gesamtzahlen aus Response-Headern ---
G -D "$WD/hdr_projects.txt" -o /dev/null "$API/projects?per_page=1&simple=true&archived=false"
G -D "$WD/hdr_projects_all.txt" -o /dev/null "$API/projects?per_page=1&simple=true"
G -D "$WD/hdr_groups.txt" -o /dev/null "$API/groups?per_page=1&all_available=true"
echo "--- HDR projects (archived=false) ---"; grep -iE '^x-total|^x-total-pages' "$WD/hdr_projects.txt"
echo "--- HDR projects (alle inkl. archiviert) ---"; grep -iE '^x-total|^x-total-pages' "$WD/hdr_projects_all.txt"
echo "--- HDR groups ---"; grep -iE '^x-total|^x-total-pages' "$WD/hdr_groups.txt"

# --- S1a: ALLE sichtbaren Gruppen, Pagination ---
: > "$WD/groups.ndjson"
p=1
while :; do
  G -o "$WD/_g.json" "$API/groups?per_page=100&all_available=true&order_by=path&sort=asc&page=$p"
  n=$(python3 -c "import json,sys;print(len(json.load(open('$WD/_g.json'))))" 2>/dev/null || echo 0)
  [ "$n" = "0" ] && break
  python3 -c "
import json
for g in json.load(open('$WD/_g.json')): print(json.dumps(g))
" >> "$WD/groups.ndjson"
  p=$((p+1))
  [ "$p" -gt 50 ] && break
done
echo "GRUPPEN_GEZAEHLT=$(wc -l < "$WD/groups.ndjson")"

# --- S1b: je Gruppe die DIREKTEN Projekte (ohne Subgruppen) ---
: > "$WD/group_projects.ndjson"
while read -r gid; do
  p=1
  while :; do
    G -o "$WD/_p.json" "$API/groups/$gid/projects?per_page=100&include_subgroups=false&order_by=path&sort=asc&page=$p"
    n=$(python3 -c "import json;print(len(json.load(open('$WD/_p.json'))))" 2>/dev/null || echo 0)
    [ "$n" = "0" ] && break
    python3 -c "
import json
for x in json.load(open('$WD/_p.json')):
    x['_owner_group_id']=$gid
    print(json.dumps(x))
" >> "$WD/group_projects.ndjson"
    p=$((p+1)); [ "$p" -gt 30 ] && break
  done
done < <(python3 -c "
import json
for l in open('$WD/groups.ndjson'):
    print(json.loads(l)['id'])
")
echo "GRUPPEN_PROJEKTE_GEZAEHLT=$(wc -l < "$WD/group_projects.ndjson")"

# --- S1c: GLOBALE Projektliste (Admin sieht alles) als Gegenprobe ---
: > "$WD/projects_all.ndjson"
p=1
while :; do
  G -o "$WD/_ap.json" "$API/projects?per_page=100&order_by=id&sort=asc&page=$p&statistics=false"
  n=$(python3 -c "import json;print(len(json.load(open('$WD/_ap.json'))))" 2>/dev/null || echo 0)
  [ "$n" = "0" ] && break
  python3 -c "
import json
for x in json.load(open('$WD/_ap.json')): print(json.dumps(x))
" >> "$WD/projects_all.ndjson"
  p=$((p+1)); [ "$p" -gt 60 ] && break
done
echo "PROJEKTE_GLOBAL_GEZAEHLT=$(wc -l < "$WD/projects_all.ndjson")"
