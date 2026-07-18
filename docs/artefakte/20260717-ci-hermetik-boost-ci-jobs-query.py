import sys, json, collections, urllib.request, ssl, subprocess

CA = "/home/comdare/Projekte/Cluster/keys/gitlab-ca-ROOTCA-20260621.crt"
VAULT = "/home/comdare/Projekte/Cluster/keys/CREDENTIALS-VAULT-DEV.md"
API = "https://gitlab.comdare.local/api/v4"

# PAT aus Vault Z.288 (nie ausgeben)
line = subprocess.check_output(["sed", "-n", "288p", VAULT]).decode()
import re
m = re.search(r"glpat-[A-Za-z0-9._-]{20,}", line)
PAT = m.group(0)

ctx = ssl.create_default_context(cafile=CA)

def get(url):
    req = urllib.request.Request(url, headers={"PRIVATE-TOKEN": PAT})
    return json.load(urllib.request.urlopen(req, context=ctx))

proj, pipe = sys.argv[1], sys.argv[2]
js = get(f"{API}/projects/{proj}/pipelines/{pipe}/jobs?per_page=100")
c = collections.Counter(j["status"] for j in js)
print("  " + "  ".join(f"{k}={v}" for k, v in sorted(c.items())))
for j in js:
    st = j["status"]; af = j.get("allow_failure")
    if st in ("failed", "canceled") and not af:
        print(f"    HARD-{st.upper()}: {j['name']} (stage={j['stage']}) id={j['id']}")
    elif st == "failed" and af:
        print(f"    soft(allow): {j['name']}")
