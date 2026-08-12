#!/usr/bin/env python3
# Extrahiert Owner-Nachrichten aus den letzten 5+1 Kontexten der Session 5a19728e
# ueber die DREI Pfade (Union per Text-Hash), Token-redigiert.
# Doktrin: reference_transkript_extraktor_zwei_pfade (DREI Pfade!) +
#          reference_session_transkripte_enthalten_live_tokens_nie_committen
import json, re, hashlib, sys

F = '/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl'
START = 34441  # Beginn Kontext -5 (die 5 vollstaendigen vor dem aktuellen)
GRENZEN = [34441, 36299, 38112, 40465, 41971, 43299]  # Kontext-Starts (isCompactSummary-Zeilen)

TOKEN = re.compile(r'(glpat-[A-Za-z0-9_\-]{10,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}'
                   r'|AKIA[A-Z0-9]{12,}|Bearer\s+[A-Za-z0-9._\-]{15,}|PRIVATE-TOKEN:\s*\S+'
                   r'|-----BEGIN[^-]*PRIVATE KEY-----)')

def redigiere(t):
    return TOKEN.sub('[REDIGIERT]', t)

def kontext_nr(zeile):
    k = 0
    for i, g in enumerate(GRENZEN):
        if zeile >= g: k = i + 1
    return k  # 1..6 (6 = aktueller)

def texte_aus(obj):
    """Liefert Owner-Texte aus einer JSONL-Zeile ueber alle drei Pfade."""
    out = []
    # Pfad 1: type==user mit echtem Human-Prompt
    if obj.get('type') == 'user':
        msg = obj.get('message', {})
        c = msg.get('content')
        ps = obj.get('promptSource') or (obj.get('origin') or {}).get('kind')
        texts = []
        if isinstance(c, str):
            texts = [c]
        elif isinstance(c, list):
            texts = [b.get('text', '') for b in c if isinstance(b, dict) and b.get('type') == 'text']
        for t in texts:
            if not t.strip(): continue
            # System-generierte user-Turns aussortieren
            if t.startswith(('<system-reminder>', '<task-notification>', '<local-command',
                             'Tool loaded', '[Request interrupted')): continue
            if t in ('/login',) or t.startswith('/model') or t.startswith('/effort'): continue
            if 'session is being continued' in t[:200]: continue
            if ps in ('typed', 'queued') or (obj.get('origin') or {}).get('kind') == 'human':
                out.append(('P1', t))
            elif ps is None and isinstance(c, str):
                out.append(('P1?', t))
    # Pfad 2: attachment queued_command
    att = obj.get('attachment')
    if isinstance(att, dict) and att.get('type') == 'queued_command':
        t = att.get('prompt') or att.get('command') or ''
        if t.strip() and not t.lstrip().startswith(('<task-notification>','<system-reminder>','<local-command')) and t.strip() not in ('/login',):
            out.append(('P2', t))
    # Pfad 3: queue-operation enqueue
    if obj.get('type') == 'queue-operation' and obj.get('operation') == 'enqueue':
        t = obj.get('prompt') or obj.get('content') or ''
        if isinstance(t, str) and t.strip() and not t.lstrip().startswith(('<task-notification>','<system-reminder>','<local-command')) and t.strip() not in ('/login',):
            out.append(('P3', t))
    return out

seen = {}
reihenfolge = []
with open(F, encoding='utf-8') as fh:
    for nr, line in enumerate(fh, 1):
        if nr < START: continue
        try: obj = json.loads(line)
        except Exception: continue
        for pfad, t in texte_aus(obj):
            h = hashlib.sha256(t.strip().encode()).hexdigest()[:16]
            if h in seen:
                seen[h]['pfade'].add(pfad); continue
            seen[h] = {'zeile': nr, 'kontext': kontext_nr(nr), 'pfade': {pfad}, 'text': redigiere(t.strip())}
            reihenfolge.append(h)

print(f"{len(reihenfolge)} distinkte Owner-Texte ab Zeile {START}", file=sys.stderr)
pfad_stat = {}
for h in reihenfolge:
    for p in seen[h]['pfade']: pfad_stat[p] = pfad_stat.get(p, 0) + 1
print(f"Pfad-Verteilung: {pfad_stat}", file=sys.stderr)

for h in reihenfolge:
    e = seen[h]
    print(f"\n{'='*90}\n### KONTEXT -{6-e['kontext']} | Zeile {e['zeile']} | Pfade {sorted(e['pfade'])}\n{'='*90}")
    print(e['text'])
