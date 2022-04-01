#!/bin/bash
FILELIST	= testbench.f
OPTIONS      	= -full64 -lca +vcs+lic+wait -l comp.log -sverilog  -debug_access -debug_region=cell+lib -cm line+cond+fsm+branch+tgl -y /eda/synopsys/dc/dc_2020.09-SP5-1/dw/sim_ver +libext+.v+.V+ -timescale=1ns/1ps +nospecify
DEFINE		= +define+TRACE +define+SIM
SUBDIR = $(shell find $(SRC_PATH)/testcase -mindepth 1 -type d)
testcase=$(SRC_PATH)/testcase/Call $(SRC_PATH)/testcase/Excute $(SRC_PATH)/testcase/LdAdd $(SRC_PATH)/testcase/MACC $(SRC_PATH)/testcase/MACCZ $(SRC_PATH)/testcase/MAX $(SRC_PATH)/testcase/MMAXN $(SRC_PATH)/testcase/MMAXZ $(SRC_PATH)/testcase/MNIST $(SRC_PATH)/testcase/ReLU $(SRC_PATH)/testcase/Store
# SUBDIR = $(SRC_PATH)/testcase/MACC  
SRC_PATH=/home/users/team3_03/Desktop/1377
accsimiv:
	iverilog -DTRACE -DSIM  -s testbench -o testbench testbench.v top.v memory.v sequencer.v compute.v -y /eda/synopsys/dc/dc_2020.09-SP5-1/dw/sim_ver +libext+.v+.V
	vvp -N testbench
accsimalps:
	alpsMS testbench.v top.v compute.v memory.v sequencer.v -y /eda/synopsys/dc/dc_2020.09-SP5-1/dw/sim_ver +libext+.v+.V+ ${DEFINE} -vcd a
accsim:	
		vcs ${DEFINE} ${OPTIONS}  -top testbench -f ${FILELIST}
		./simv -ucli -i  dump.tcl -cm line+cond+fsm+branch+tgl

test:
	$(foreach subdir, $(testcase),\
		echo $(subdir);\
		cd $(subdir); cp -r -f demo.hex demo_out.hex $(SRC_PATH)/Running; \
		cd $(SRC_PATH)/rtl;vcs ${DEFINE} ${OPTIONS} -cm_dir $(subdir)/sim -top testbench -f ${FILELIST};\
		./simv -ucli -i  dump.tcl -cm line+cond+fsm+branch+tgl; )
 
reportcm:test
	urg -dir $(SRC_PATH)/testcase/Call/sim.vdb $(SRC_PATH)/testcase/Excute/sim.vdb $(SRC_PATH)/testcase/LdAdd/sim.vdb $(SRC_PATH)/testcase/MACC/sim.vdb $(SRC_PATH)/testcase/MACCZ/sim.vdb $(SRC_PATH)/testcase/MAX/sim.vdb $(SRC_PATH)/testcase/MMAXN/sim.vdb $(SRC_PATH)/testcase/MMAXZ/sim.vdb $(SRC_PATH)/testcase/MNIST/sim.vdb $(SRC_PATH)/testcase/ReLU/sim.vdb $(SRC_PATH)/testcase/Store/sim.vdb
contrast:
	
wave:
	verdi -sx ${DEFINES} ${OPTIONS} -f ${FILELIST} -top testbench -nologo -ssy -ssv -ssz -autoalias &

clean:
	rm -rf *log csrc simv* urgReport ucli.key .*xml verdiLog testbench.vf *fsdb novas*
