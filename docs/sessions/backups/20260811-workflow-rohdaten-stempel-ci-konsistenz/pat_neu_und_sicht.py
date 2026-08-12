#!/usr/bin/env python3
"""Neuen PAT blind aus dem Vault holen (Kandidaten RUECKWAERTS bis HTTP 200) und
die Sicht-Aufgaben fahren. Der Token-Wert verlaesst dieses Skript NIE."""
import json, ssl, sys, urllib.request, urllib.error

VAULT = "/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-DEV.md"
CA    = "/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt"
HOST  = "https://gitlab.comdare.local"

def kandidaten():
    with open(VAULT, encoding="utf-8", errors="replace") as fh:
        zeilen = fh.readlines()
    out = []
    for i, z in enumerate(zeilen):
        for w in z.replace("`"," ").replace("|"," ").split():
            w = w.strip(",;*:'\"()")
            if w.startswith("glpat-") and 20 <= len(w) <= 60:
                out.append((i+1, w))
    return out

def api(pfad, token):
    ctx = ssl.create_default_context(cafile=CA)
    req = urllib.request.Request(HOST + pfad, headers={"PRIVATE-TOKEN": token})
    try:
        with urllib.request.urlopen(req, context=ctx, timeout=15) as r:
            return r.status, json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        return e.code, None
    except Exception as e:
        return -1, str(type(e).__name__)

ks = kandidaten()
print(f"Kandidaten im Vault: {len(ks)} (Werte werden nicht ausgegeben)")
tok = None
for zeile, k in reversed(ks):
    st, u = api("/api/v4/user", k)
    print(f"  Kandidat @Z{zeile}: HTTP {st}")
    if st == 200:
        tok = k
        print(f"  -> AKTIV: '{u.get('username')}' (Name: {u.get('name')}), Zeile {zeile}")
        break
if not tok:
    print("KEIN Kandidat lieferte HTTP 200."); sys.exit(2)

# Token-Selbstauskunft (Scopes/Ablauf -- keine Secrets)
st, ti = api("/api/v4/personal_access_tokens/self", tok)
if st == 200:
    print(f"Token: name={ti.get('name')} scopes={ti.get('scopes')} expires={ti.get('expires_at')} active={ti.get('active')}")

for name, pid in [("super", 288), ("ce", 286)]:
    st, pls = api(f"/api/v4/projects/{pid}/pipelines?ref=development&per_page=3", tok)
    if st == 200 and pls:
        for p in pls:
            print(f"{name}: pipeline {p['id']} {p['status']} sha={p['sha'][:8]} ({p['updated_at']})")
    else:
        print(f"{name}: pipelines HTTP {st}")

# CI-Variablen (nur unkritische Werte zeigen: URLs/bools; alles andere nur Existenz)
UNKRITISCH = {"COMDARE_MEASUREMENT_DROP_URL", "COMDARE_STORAGE_CACHE"}
for name, pid in [("super", 288), ("ce", 286)]:
    st, vs = api(f"/api/v4/projects/{pid}/variables?per_page=100", tok)
    if st != 200:
        print(f"{name}: variables HTTP {st}"); continue
    for v in vs:
        k = v.get("key","")
        if k in UNKRITISCH:
            print(f"{name}: {k} = {v.get('value')}")
        elif "DROP" in k or "STORAGE" in k or "MEASUREMENT" in k:
            print(f"{name}: {k} = [existiert, Wert nicht gezeigt]")
# Gruppen-Variablen (Gruppe 3)
st, vs = api("/api/v4/groups/3/variables?per_page=100", tok)
if st == 200:
    for v in vs:
        k = v.get("key","")
        if k in UNKRITISCH:
            print(f"gruppe3: {k} = {v.get('value')}")
        elif "DROP" in k or "STORAGE" in k:
            print(f"gruppe3: {k} = [existiert]")
else:
    print(f"gruppe3: variables HTTP {st}")

# Runner-Sicht
st, rs = api("/api/v4/runners/all?per_page=50", tok)
if st != 200:
    st, rs = api("/api/v4/runners?per_page=50", tok)
if st == 200:
    on = [r for r in rs if r.get("online")]
    print(f"Runner sichtbar: {len(rs)}, online: {len(on)}")
    for r in rs[:12]:
        print(f"  {r.get('description','?')[:40]:40} online={r.get('online')} tags={','.join(r.get('tag_list',[])[:4])}")
else:
    print(f"runner: HTTP {st}")
