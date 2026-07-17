# Vollständiges Sibling-Audit: welche Test-Targets nutzen boost/mp11 ohne boost-Pfad?
# BEIDE Muster (comdare_add_test + add_executable), ALLE Compiler-.d-Dateien.
# Lauf: python3 audit-boost-link.py  (aus dem ce-Repo-Root, nach vollem Build)
import re, pathlib, glob
cml = pathlib.Path("tests/unit/CMakeLists.txt").read_text()
t_helper = set(re.findall(r'comdare_add_test\(\s*([A-Za-z0-9_]+)', cml))
t_raw    = set(re.findall(r'add_executable\(\s*([A-Za-z0-9_]+)', cml))
targets = t_helper | t_raw
has_boost = set(re.findall(r'target_link_libraries\(\s*([A-Za-z0-9_]+)[^\)]*Boost::mp11', cml))
has_comdarelib = set(re.findall(r'target_link_libraries\(\s*([A-Za-z0-9_]+)[^\)]*comdare::', cml))
uses_boost=set()
for d in glob.glob("build/tests/unit/CMakeFiles/*.dir/*.cpp.o.d"):
    t = pathlib.Path(d).parent.name[:-4]
    if 'boost/mp11' in pathlib.Path(d).read_text(errors='replace'): uses_boost.add(t)
risk = sorted(t for t in uses_boost if t in targets and t not in has_boost and t not in has_comdarelib)
print(f"Targets={len(targets)} boost={len(uses_boost)} Boost::mp11-direkt={len(has_boost)} comdare-lib={len(has_comdarelib)}")
print("RISIKO:", risk or "KEINE")
