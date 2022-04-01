module top (
	input 				clock,
	input 				resetn,
	input  				valid,
	output reg			ready,
	input 		[3:0]	wstrb,
	input 		[31:0]	addr,
	input 		[31:0]	wdata,
	output reg 	[31:0]	rdata
);
	// integer i;

	/********** Global Wires **********/

	wire reset = ~resetn;
	//reg trigger_reset;

	wire busy;

	wire        qmem_done;
	reg         qmem_rdone;
	reg         qmem_read;
	reg  [ 3:0] qmem_write;
	reg  [15:0] qmem_addr;
	reg  [31:0] qmem_wdata;
	wire [31:0] qmem_rdata;

	reg         seq_start;
	reg         seq_stop;
	reg  [15:0] seq_addr;
	wire        seq_busy;

	wire        smem_valid;
	wire        smem_ready;
	wire [15:0] smem_addr;
	wire [31:0] smem_data;

	wire        comp_valid;
	wire        comp_ready;
	wire [31:0] comp_insn;

	wire        comp_busy;
	wire        comp_simd;
	wire        comp_nosimd;

	wire        cmem_ren;
	wire [ 7:0] cmem_wen;
	wire [15:0] cmem_addr;
	wire [63:0] cmem_wdata;
	wire [63:0] cmem_rdata;

	/********** Reset Generator **********/
/*
	reg [3:0] reset_cnt = 0;
	wire next_resetn = &reset_cnt;

	always @(posedge clock) begin
		if (trigger_reset)
			reset_cnt <= 0;
		else
			reset_cnt <= reset_cnt + !next_resetn;

		if (!resetn) begin
			reset_cnt <= 0;
		end
		reset <= !next_resetn;
	end
*/
	
	reg state_wait;
	/********** control from pico **********/
	always @(posedge clock) begin
		seq_start <= 0;
		seq_stop  <= 0;
		if(valid && addr[17] == 1) begin
			//configure
			if(& wstrb) begin
				//run
				if(wdata[0]) begin
					seq_start 	<= 1;
					seq_addr  	<= wdata[31:16];
					ready		<= 1;
				end else
				//stop
				if(wdata[1]) begin
					seq_stop	<= 1;
					ready 		<= 1;
				end
				//status
			end else begin
				rdata	<= {32{busy}};
				ready  	<= 1;
			end
		end

		if(valid && addr[17] != 1) begin
			if(state_wait == 1 && qmem_done && |wstrb)  begin
				ready	<= 1;
			end else
			if(state_wait == 1 && qmem_rdone) begin
				ready	<= 1;
				rdata	<= qmem_rdata;
			end

			if(state_wait == 0) begin
				state_wait <= 1;
				if(| wstrb) begin
					qmem_write <= wstrb;
					qmem_wdata <= wdata;
					qmem_addr  <= {addr[16:2],1'b0};
				end else begin
					qmem_read  <= 1;
					qmem_addr  <= {addr[16:2],1'b0};
				end
			end
		end
		
		if(ready) begin
			ready <= 0;
			state_wait <= 0;
		end
		
		if (reset || qmem_done) begin
			qmem_read <= 0;
			qmem_write <= 0;
		end

		if (reset) begin
			state_wait 	<= 0;
			//trigger_reset <= 0;
			ready 		<= 0;
		end
	end

	/********** Sequencer and Compute **********/

	sequencer seq (
		.clock      (clock     ),
		.reset      (reset     ),

		.start      (seq_start ),
		.addr       (seq_addr  ),
		.busy       (seq_busy  ),

		.smem_valid (smem_valid),
		.smem_ready (smem_ready),
		.smem_addr  (smem_addr ),
		.smem_data  (smem_data ),

		.comp_valid (comp_valid),
		.comp_ready (comp_ready),
		.comp_insn  (comp_insn )
	);

	compute comp (
		.clock       (clock      ),
		.reset       (reset      ),
		.busy        (comp_busy  ),

		.cmd_valid   (comp_valid ),
		.cmd_ready   (comp_ready ),
		.cmd_insn    (comp_insn  ),

		.mem_ren     (cmem_ren   ),
		.mem_wen     (cmem_wen   ),
		.mem_addr    (cmem_addr  ),
		.mem_wdata   (cmem_wdata ),
		.mem_rdata   (cmem_rdata ),

		.tick_simd   (comp_simd  ),
		.tick_nosimd (comp_nosimd)
	);

// 四个周期不busy才输出不busy
	reg [3:0] busy_q;

	always @(posedge clock) begin
		if (reset)
			busy_q <= 0;
		else
			busy_q <= {busy_q, seq_busy || comp_busy};
	end

	assign busy = busy_q || seq_busy || comp_busy;
	/********** Main Memory **********/

	reg mem_client_qmem;
	reg mem_client_smem;
	reg mem_client_cmem;

	reg  [15:0] next_mem_addr;
	reg  [ 7:0] next_mem_wen;
	reg  [63:0] next_mem_wdata;

	reg  [15:0] mem_addr;
	reg  [ 7:0] mem_wen;
	reg  [63:0] mem_wdata;
	wire [63:0] mem_rdata;

	reg [2:0] smem_state;
	reg [2:0] qmem_state;

	always @* begin
		mem_client_qmem = 0;
		mem_client_smem = 0;
		mem_client_cmem = 0;

		next_mem_addr = cmem_addr;
		next_mem_wen = cmem_wen;
		next_mem_wdata = cmem_wdata;

		if (cmem_ren || cmem_wen) begin
			mem_client_cmem = 1;
		end else
		if ((qmem_read || qmem_write) && !qmem_state) begin
			mem_client_qmem = 1;
			next_mem_addr = qmem_addr;
			next_mem_wen = qmem_write;
			next_mem_wdata = qmem_wdata;
		end else
		if (smem_valid && !smem_state) begin
			mem_client_smem = 1;
			next_mem_addr = smem_addr;
			next_mem_wen = 0;
		end
	end

	assign qmem_rdata = mem_rdata[31:0];
	assign qmem_done = qmem_state[1];
	assign smem_data = mem_rdata[31:0];
	assign smem_ready = smem_state[2];
	assign cmem_rdata = mem_rdata;

	always @(posedge clock) begin
		mem_addr <= next_mem_addr;
		mem_wen <= next_mem_wen;
		mem_wdata <= next_mem_wdata;
		qmem_rdone <= qmem_read && qmem_done;

		smem_state <= {smem_state, mem_client_smem};
		qmem_state <= {qmem_state, mem_client_qmem};

		if (reset) begin
			qmem_rdone <= 0;
			mem_wen <= 0;
			smem_state <= 0;
			qmem_state <= 0;
		end
	end

	memory mem (
		.clock (clock    ),
		.addr  (mem_addr ),
		.wen   (mem_wen  ),
		.wdata (mem_wdata),
		.rdata (mem_rdata)
	);



`ifdef TRACE
	reg perfcount_active;
	integer perfcount_cycles;
	integer perfcount_simd;
	integer perfcount_nosimd;

	always @(posedge clock) begin
		if (busy) begin
			perfcount_active <= 1;
			perfcount_cycles <= perfcount_cycles + 1;
			perfcount_simd <= perfcount_simd + comp_simd;
			perfcount_nosimd <= perfcount_nosimd + comp_nosimd;
		end else
		if (perfcount_active) begin
			$display("-------------------");
			$display("Number of clock cycles:          %d", perfcount_cycles);
			$display("Number of SIMD-instructions:     %d", perfcount_simd);
			$display("Number of non-SIMD-instructions: %d", perfcount_nosimd);
			$display("");
			$display("Avg. ops per cycle:       %8.2f", (1.0*perfcount_nosimd + 16.0*perfcount_simd) / perfcount_cycles);
			$display("Avg. simd ops per cycle:  %8.2f", 16.0*perfcount_simd / perfcount_cycles);
			$display("");
			$display("Avg. insn per cycle:      %8.2f", (1.0*perfcount_nosimd + 1.0*perfcount_simd) / perfcount_cycles);
			$display("Avg. simd insn per cycle: %8.2f", 1.0*perfcount_simd / perfcount_cycles);
			$display("");
			$display("MMACC/s at 20 MHz: %8.2f", 20*16.0*perfcount_simd / perfcount_cycles);
			$display("MMACC/s at 35 MHz: %8.2f", 35*16.0*perfcount_simd / perfcount_cycles);
			$display("-------------------");

			perfcount_active <= 0;
			perfcount_cycles <= 0;
			perfcount_simd <= 0;
			perfcount_nosimd <= 0;
		end

		if (reset) begin
			perfcount_active <= 0;
			perfcount_cycles <= 0;
			perfcount_simd <= 0;
			perfcount_nosimd <= 0;
		end
	end
`endif

//wire debug_write = |(wstrb & {4{valid}});
//wire debug_read  = !debug_write && valid;

endmodule
