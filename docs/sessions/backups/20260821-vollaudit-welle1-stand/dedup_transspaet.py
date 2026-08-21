#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Konsolidierer 'trans-spaet' des Vollaudits.
Liest leser-transkript-13.md .. leser-transkript-23.md (11 Dateien, JEDE deckt
ein EXKLUSIVES, chronologisch AUFSTEIGENDES Zeitfenster des Session-Korpus ab:
Datei 13 = fruehestes Fenster dieses Segments, Datei 23 = spaetestes/letztes
Fenster. INNERHALB jeder Datei ist der Inhalt ebenfalls chronologisch
aufsteigend (Zeile weiter unten = spaeter).

Dedupliziert gleiche Gegenstaende (Namens-Varianten werden ueber eine
normalisierte Kernform + Wortueberlappung zusammengefuehrt) und schreibt EINE
konsolidierte Tabelle mit Spalte 'Quellen'. Bei Status-Konflikt gewinnt die
JUENGSTE Quelle (hoehere Datei-Nr. = juenger, bei gleicher Datei: hoehere
Zeilenposition = juenger); der/die aeltere(n) Status-Werte werden im
Statusfeld als Verlauf ausgewiesen, NICHTS wird still verworfen.
"""
import re
import unicodedata
import json
from collections import defaultdict, OrderedDict

BASE = "/home/comdare/backups-workflow/20260820-vollaudit-sammelstrecke"
FILE_NUMS = list(range(13, 24))
FILES = [(n, f"{BASE}/leser-transkript-{n}.md") for n in FILE_NUMS]

STOP = set("""
und der die das ist war wird nicht auf vor nach als mit aus eine einer eines einem
im in am an zu von fuer fur bei ueber uber unter durch dieser diese dieses diesem
noch nur schon auch nie immer sein ihre ihr ihrer wurde wurden werden worden haben hat
hatte hatten kann koennen konnten muss muessen musste soll sollen sollte sind waren
gibt gab lag lagen liegt liegen wie was wo wer wenn dass ob bzw etc als1 usw
sich sie er es ich wir ihr man alle alles jede jeder jedes kein keine keinen
ohne mehr sehr etwas zwei drei vier fuenf funf sechs sieben acht neun zehn
neue neuen neuer neues alte alten alter altes offen gebaut gebauten geplant
entschieden bestaetigt bestatigt geheilt behoben festgelegt landbar gelandet
ledger konsolidierung konsolidiert nachtrag owner user quelle status klasse
kuerzel name traeger task aufgabe feature regression unklar wurde stelle
stellen fund funde befund befunde punkt punkte posten thema gegenstand
zeile zeilen anker verbatim woertlich wortlich session bau code test tests
workflow agent agenten kontext fenster block gelesen datei dateien
""".split())

def parse_file(path, file_idx):
    rows = []
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()
    order = 0
    for raw in lines:
        line = raw.rstrip("\n")
        if not line.startswith("|"):
            continue
        # protect already backslash-escaped pipes (author-intended literal '|') before splitting
        SENT = "\x00PIPE\x00"
        protected = line.replace("\\|", SENT)
        parts = [p.strip() for p in protected.split("|")]
        if parts and parts[0] == "":
            parts = parts[1:]
        if parts and parts[-1] == "":
            parts = parts[:-1]
        if len(parts) < 5:
            continue
        VALID_KLASSE_TOK = ("AUFGABE", "REGRESSION", "FEATURE", "OWNER-ENTSCHEID", "UNKLAR")
        if len(parts) > 5:
            # source row itself contains an unescaped '|' inside prose (grammar notation,
            # OR-lists, etc). Robust recovery: the well-formed table has exactly 5 cells,
            # so find the split point where fields [1] looks like a real Klasse token; if
            # none found, treat the surplus pipes as belonging to the KUERZEL free-text cell
            # (rightmost 3 fields are far more reliably real columns: quelle/status/traeger
            # rarely themselves get split further apart than the leading kuerzel prose does).
            fixed = None
            for split_at in range(1, len(parts) - 3):
                cand_klasse = parts[split_at]
                if any(cand_klasse.upper().startswith(v) for v in VALID_KLASSE_TOK):
                    kuerzel_join = "|".join(parts[:split_at])
                    fixed = [kuerzel_join, parts[split_at], parts[split_at + 1],
                             parts[split_at + 2], "|".join(parts[split_at + 3:])]
                    break
            if fixed is None:
                # fallback: assume last 4 real fields are klasse/quelle/status/traeger
                fixed = ["|".join(parts[:-4])] + parts[-4:]
            parts = fixed
        kuerzel, klasse, quelle, status, traeger = parts[0], parts[1], parts[2], parts[3], parts[4]
        kuerzel = kuerzel.replace(SENT, "\\|")
        klasse = klasse.replace(SENT, "\\|")
        quelle = quelle.replace(SENT, "\\|")
        status = status.replace(SENT, "\\|")
        traeger = traeger.replace(SENT, "\\|")
        ku_up = kuerzel.upper().replace(" ", "")
        if ku_up.startswith(("KUERZEL/NAME", "KUERZEL/", "KÜRZEL/NAME")):
            continue
        if not kuerzel or set(kuerzel) <= {"-"}:
            continue
        if klasse.strip().startswith("---"):
            continue
        order += 1
        rows.append({
            "kuerzel": kuerzel, "klasse": klasse, "quelle": quelle,
            "status": status, "traeger": traeger,
            "file_idx": file_idx, "order": order,
        })
    return rows

def normalize_key(s):
    s = unicodedata.normalize("NFKD", s)
    s = s.lower()
    s = re.sub(r"[^a-z0-9 ]+", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s

ID_PATTERNS = [
    re.compile(r"#\d{1,4}"),                      # Task #58, ##25 (kept incl. hashes)
    re.compile(r"\bKON\d{1,4}(-\d{1,3})?\b", re.I),  # KON47, KON9-04
    re.compile(r"\b[0-9a-f]{7,12}\b", re.I),        # commit SHAs (short/long)
    re.compile(r"\bS-\d{1,2}[a-z]?\b", re.I),       # S-14a, S-6b
    re.compile(r"\bV[LG]-?\d[a-zRb]*\b", re.I),     # VL-1, VG-3
    re.compile(r"\bT-\d{1,2}[a-z]?\b", re.I),       # T-15b
]

def extract_ids(raw):
    ids = set()
    for pat in ID_PATTERNS:
        for m in pat.findall(raw) if pat.groups else pat.findall(raw):
            pass
    for pat in ID_PATTERNS:
        for m in pat.finditer(raw):
            ids.add(m.group(0).lower())
    return ids

def norm_words(s):
    s = unicodedata.normalize("NFKD", s)
    s = s.lower()
    s = re.sub(r"[^a-z0-9 ]+", " ", s)
    words = [w for w in s.split() if len(w) >= 4 and w not in STOP]
    return words

all_rows = []
per_file_counts = OrderedDict()
for n, path in FILES:
    rows = parse_file(path, n)
    per_file_counts[f"leser-transkript-{n}.md (Transkript {n})"] = len(rows)
    all_rows.extend(rows)

raw_total = len(all_rows)
for idx, r in enumerate(all_rows):
    r["idx"] = idx
    r["rank"] = (r["file_idx"], r["order"])  # HIGHER = newer/later (ascending chronology across 13->23)
    r["key_full"] = normalize_key(r["kuerzel"])
    words = norm_words(r["kuerzel"])
    r["wordset"] = set(words)
    # also fold Traeger/Task field ids in (Task#/KON# often live there, not in kuerzel)
    r["ids"] = extract_ids(r["kuerzel"]) | extract_ids(r["traeger"])

# --- Pass 1: exact normalized-key groups ---
groups_by_full = defaultdict(list)
for idx, r in enumerate(all_rows):
    groups_by_full[r["key_full"]].append(idx)

parent = list(range(raw_total))
gsize = [1] * raw_total
MAX_GROUP = 9  # safety valve against Union-Find chain-explosion via weak transitive links

def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]
        x = parent[x]
    return x

def would_exceed(a, b):
    ra, rb = find(a), find(b)
    if ra == rb:
        return False
    return gsize[ra] + gsize[rb] > MAX_GROUP

def union(a, b):
    ra, rb = find(a), find(b)
    if ra != rb:
        parent[ra] = rb
        gsize[rb] += gsize[ra]

for key, idxs in groups_by_full.items():
    if len(idxs) < 2 or len(key) < 6:
        continue
    base = idxs[0]
    for other in idxs[1:]:
        union(base, other)

# --- Pass 2: near-duplicate via distinctive-word Jaccard overlap (conservative) ---
df = defaultdict(int)
for r in all_rows:
    for w in r["wordset"]:
        df[w] += 1
GENERIC_THRESHOLD = 22
generic = {w for w, c in df.items() if c > GENERIC_THRESHOLD}

inv = defaultdict(list)
for r in all_rows:
    distinctive = {w for w in r["wordset"] if w not in generic}
    r["distinctive"] = distinctive
    for w in distinctive:
        inv[w].append(r["idx"])

pair_seen = set()
merges_made_pass2 = 0
merges_made_pass2b = 0

def consider_pair(a, b, require_id=False):
    global merges_made_pass2, merges_made_pass2b
    if find(a) == find(b):
        return
    key = (a, b) if a < b else (b, a)
    if key in pair_seen:
        return
    pair_seen.add(key)
    ra, rb = all_rows[a], all_rows[b]
    if ra["file_idx"] == rb["file_idx"]:
        return  # same-file near-identical wording = distinct sub-step, keep separate
    if would_exceed(a, b):
        return  # safety valve: never let weak transitive links build mega-clusters
    sa, sb = ra["distinctive"], rb["distinctive"]
    shared_ids = ra["ids"] & rb["ids"]
    if not sa or not sb:
        return
    inter = sa & sb
    uni = sa | sb
    jac = (len(inter) / len(uni)) if uni else 0.0
    min_len = min(len(sa), len(sb))
    if min_len >= 3 and len(inter) >= 3 and jac >= 0.6:
        union(a, b); merges_made_pass2 += 1; return
    if min_len >= 2 and len(inter) >= 2 and jac >= 0.75:
        union(a, b); merges_made_pass2 += 1; return
    # ID-anchored merge: same explicit Task#/KON#/S-.. id PLUS still a meaningful
    # (if lower) shared-word bar -- avoids colliding reused small numbers (e.g. a
    # reset task-tracker's "#1"/"#2") purely on ID, requires real textual echo too.
    if shared_ids and len(inter) >= 2 and jac >= 0.25:
        union(a, b); merges_made_pass2b += 1; return

for w, idxs in inv.items():
    if len(idxs) < 2 or len(idxs) > 50:
        continue
    for i in range(len(idxs)):
        for j in range(i + 1, len(idxs)):
            consider_pair(idxs[i], idxs[j])

# id-anchored blocking pass (independent inverted index keyed by id token)
inv_id = defaultdict(list)
for r in all_rows:
    for tok in r["ids"]:
        inv_id[tok].append(r["idx"])
for tok, idxs in inv_id.items():
    if len(idxs) < 2 or len(idxs) > 40:
        continue
    for i in range(len(idxs)):
        for j in range(i + 1, len(idxs)):
            consider_pair(idxs[i], idxs[j], require_id=True)

print(f"pass2b_id_anchored_merges={merges_made_pass2b}")

groups = defaultdict(list)
for idx in range(raw_total):
    groups[find(idx)].append(idx)

n_groups = len(groups)
multi = {g: idxs for g, idxs in groups.items() if len(idxs) > 1}
rows_absorbed = sum(len(v) for v in multi.values())

print(f"raw_total={raw_total}")
print(f"pass2_merges={merges_made_pass2}")
print(f"dedup_groups(final rows)={n_groups}")
print(f"groups_with_2plus={len(multi)}")
print(f"raw_rows_in_multi_groups={rows_absorbed}")
print(f"zusammengefuehrt(=raw_total-n_groups)={raw_total - n_groups}")
for k, v in per_file_counts.items():
    print(f"  {k}: {v}")

# ---- Build consolidated table rows ----
CLASS_ORDER_HINT = {"OWNER-ENTSCHEID": 0, "REGRESSION": 1, "AUFGABE": 2, "FEATURE": 3, "UNKLAR": 4}

def status_short(s, n=90):
    s = s.strip()
    return s if len(s) <= n else s[: n - 1] + "…"

out_groups = []
for gid, idxs in groups.items():
    members = sorted((all_rows[i] for i in idxs), key=lambda r: r["rank"])
    rep = members[-1]  # newest
    older = members[:-1]
    # collect distinct statuses among older members that differ from rep's status
    seen_status = OrderedDict()
    for m in members:
        sk = m["status"].strip()
        if sk not in seen_status:
            seen_status[sk] = []
        seen_status[sk].append(m)
    conflict = len(seen_status) > 1
    quellen = sorted({f"T{m['file_idx']}" for m in members}, key=lambda t: int(t[1:]))
    out_groups.append({
        "gid": gid,
        "members": members,
        "rep": rep,
        "conflict": conflict,
        "seen_status": seen_status,
        "quellen": quellen,
        "first_rank": members[0]["rank"],
    })

# sort by first-appearance (preserve narrative/chronological flow of first mention)
out_groups.sort(key=lambda g: g["first_rank"])

def esc(s):
    # keep markdown table well-formed: escape literal pipes, collapse newlines
    s = s.replace("\n", " ").replace("\r", " ")
    s = s.replace("|", "\\|")
    return s.strip()

with open(f"{BASE}/_merge_groups_transspaet.json", "w", encoding="utf-8") as fh:
    dump = []
    for g in out_groups:
        if len(g["members"]) < 2:
            continue
        dump.append({
            "gid": g["gid"],
            "quellen": g["quellen"],
            "members": [
                {"file": m["file_idx"], "order": m["order"], "kuerzel": m["kuerzel"],
                 "klasse": m["klasse"], "status": m["status"], "traeger": m["traeger"]}
                for m in g["members"]
            ],
        })
    json.dump(dump, fh, ensure_ascii=False, indent=1)
print(f"wrote _merge_groups_transspaet.json with {len(dump)} multi-member groups")

# ---- write full consolidated markdown table ----
lines = []
lines.append("| KUERZEL/Name | Klasse | Quelle (Z-Anker/Abschnitt) | Status LAUT QUELLE | Traeger/Task | Quellen |")
lines.append("|---|---|---|---|---|---|")
for g in out_groups:
    rep = g["rep"]
    kuerzel = rep["kuerzel"]
    klasse = rep["klasse"]
    quelle = rep["quelle"] + (f" [orig. zuerst: T{g['members'][0]['file_idx']}]" if g["members"][0]["file_idx"] != rep["file_idx"] else "")
    status = rep["status"]
    traeger = rep["traeger"]
    if g["conflict"]:
        # append status history (older -> excluding rep's own current) if the text differs
        hist_parts = []
        for st, ms in g["seen_status"].items():
            if st == rep["status"].strip():
                continue
            src = ",".join(f"T{m['file_idx']}" for m in ms)
            hist_parts.append(f"{status_short(st, 70)} ({src})")
        if hist_parts:
            status = status + "  ⚠ STATUS-VERLAUF/vorher: " + "  ‧  ".join(hist_parts)
    quellen_str = ", ".join(g["quellen"])
    row = f"| {esc(kuerzel)} | {esc(klasse)} | {esc(quelle)} | {esc(status)} | {esc(traeger)} | {esc(quellen_str)} |"
    lines.append(row)

with open(f"{BASE}/_table_body_transspaet.md", "w", encoding="utf-8") as fh:
    fh.write("\n".join(lines) + "\n")
print(f"wrote _table_body_transspaet.md with {len(lines)-2} data rows")
