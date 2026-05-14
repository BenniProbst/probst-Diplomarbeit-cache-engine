import re
import subprocess


filename = "program.dmp"
symbol_file = "program.table"
threshold = 240000
output = "/output/file/dir"
is_cpp = False


def cppfilt(mangled_name):
    if is_cpp:
        result = subprocess.run(['c++filt', mangled_name], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            raise Exception(f"Error in c++filt: {result.stderr.decode('utf-8')}")
        return result.stdout.decode('utf-8').strip()
    return mangled_name


addr_func_list = []
addr_size = {}
# print("processing symbol table...")
with open(symbol_file, 'r') as f:
    lines = f.readlines()
    for i, line in enumerate(lines):
        parts = line.split()
        if len(parts) >= 6:
            func_addr = int(parts[0], 16)
            func_size = int(parts[4], 16)
            func_name = ' '.join(parts[5:])
            if func_size == 0:
                continue
            addr_func_list.append((func_addr, func_size, func_name))
            addr_size[func_addr] = func_size


def parse_objdump(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    func_pattern = re.compile(r'^([0-9a-f]+) <(.+)>:$')
    call_pattern = re.compile(r'.*callq  ([0-9a-f]+) <.*>$')
    call_graph = {}
    addr_name = {}
    called = set()
    current_func = None
    for line in lines:
        func_match = func_pattern.match(line)
        if func_match: # function begin
            current_func = int(func_match.group(1), 16)
            func_name = func_match.group(2)
            addr_name[current_func] = func_name
            if current_func not in call_graph:
                call_graph[current_func] = set()
        call_match = call_pattern.match(line)
        if call_match and current_func is not None:
            call_addr = int(call_match.group(1), 16)
            call_graph[current_func].add(call_addr)
            called.add(call_addr)
    # print(f"callgraph size:{len(call_graph)}, all funcs appeared:{len(called)}")
    return addr_name, call_graph
addr_name, call_graph = parse_objdump(filename)
# print(f"call-graph built, size={len(call_graph)}")


def calculate_subtree_sizes_include_self(graph):
    subtree_sizes = {}
    def dfs(node, visited):
        if node in visited:
            return 0, 0
        visited.add(node)
        if node not in graph:
            return 1, 0x20
        size = 1
        footprint = addr_size[node] if node in addr_size else 0x20
        for child in graph.get(node, []):
            child_size, child_footprint = dfs(child, visited)
            size += child_size
            footprint += child_footprint
        return size, footprint
    for node in graph:
        s, f = dfs(node, set())
        subtree_sizes[node] = (s, f)
    return subtree_sizes


# addr to subtree-size
subtree_sizes = calculate_subtree_sizes_include_self(call_graph)
sorted_subtree_sizes = sorted(subtree_sizes.items(), key=lambda kv: kv[1][1], reverse=True)


addr_fathers = {}
for father in call_graph:
    father_size = subtree_sizes[father][1] # father size
    for son in call_graph[father]:
        if son in call_graph:
            if son not in addr_fathers:
                addr_fathers[son] = set()
            addr_fathers[son].add(father_size)


with open(output, "w") as output_file:
    base_taskid = 0
    for addr, (size, footprint) in sorted_subtree_sizes:
        if footprint < threshold:
            break
        fname = cppfilt(addr_name[addr])
        base_taskid += 1
        func_size = addr_size[addr]
        output_file.write(f"\n{hex(addr)} {hex(func_size)} [{hex(base_taskid)}]: {fname.ljust(70)} subtree={size, footprint} ")
        # if addr in addr_fathers:
        #     output_file.write(f"fathers={addr_fathers[addr]}")
