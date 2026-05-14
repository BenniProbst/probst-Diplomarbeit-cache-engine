
An Example Python Processing Script Explaining the Call Graph Analysis Process in Hierarchical Prefetching

Input:
    program.dmp: Obtained by running `objdump -d your_program`
    program.table: Obtained by running `objdump -t your_program`
    threshold: Static threshold in bytes

Output:
    A list of functions, where the call and return instructions of these functions are marked as potential entry points of Bundles.
