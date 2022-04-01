#!/bin/bash
FILELIST	= testbench.f
OPTIONS      	= -full64 -lca +vcs+lic+wait -l comp.log -sverilog  -debug_access -debug_region=cell+lib -cm line+cond+fsm+branch+tgl -y /eda/synopsys/dc/dc_2020.09-SP5-1/dw/sim_ver +libext+.v+.V+ -timescale=1ns/1ps +nospecify
DEFINE		= +define+TRACE +define+SIM

socsim:	
		vcs ${DEFINE} ${OPTIONS}  -top testbench -f ${FILELIST}
		./simv -ucli -i  dump.tcl -cm line+cond+fsm+branch+tgl

wave:
	verdi -sx ${DEFINES} ${OPTIONS} -f ${FILELIST} -top testbench -nologo -ssy -ssv -ssz -autoalias &
