vcd dumpfile top_module_tb.vcd
vcd dumpvars -m top_module_tb -l 0
run 2000 ns
vcd dumpflush
