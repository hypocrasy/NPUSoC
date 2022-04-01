module sequencer (
	input             clock,
	input             reset,
	input             start,
	input      [15:0] addr,
	output            busy,

	output            smem_valid,
	input             smem_ready,
	output     [15:0] smem_addr,
	input      [31:0] smem_data,

	output            comp_valid,
	input             comp_ready,
	output     [31:0] comp_insn
);
Sequencer u_Sequencer(
  .clock(clock),
  .reset(reset),
  .io_start(start),
  .io_addr(addr),
  .io_busy(busy),
  .io_comp_valid(comp_valid),
  .io_comp_ready(comp_ready),
  .io_comp_insn(comp_insn),
  .io_smem_valid(smem_valid),
  .io_smem_ready(smem_ready),
  .io_smem_addr(smem_addr),
  .io_smem_data(smem_data)
);

endmodule

module Sequencer(
  input         clock,
  input         reset,
  input         io_start,
  input  [15:0] io_addr,
  output        io_busy,
  output        io_comp_valid,
  input         io_comp_ready,
  output [31:0] io_comp_insn,
  output        io_smem_valid,
  input         io_smem_ready,
  output [15:0] io_smem_addr,
  input  [31:0] io_smem_data
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] stack [0:127]; // @[Sequencer.scala 18:32]
  wire [15:0] stack_pc_MPORT_data; // @[Sequencer.scala 18:32]
  wire [6:0] stack_pc_MPORT_addr; // @[Sequencer.scala 18:32]
  wire [15:0] stack_MPORT_data; // @[Sequencer.scala 18:32]
  wire [6:0] stack_MPORT_addr; // @[Sequencer.scala 18:32]
  wire  stack_MPORT_mask; // @[Sequencer.scala 18:32]
  wire  stack_MPORT_en; // @[Sequencer.scala 18:32]
  reg [31:0] queue [0:127]; // @[Sequencer.scala 43:32]
  wire [31:0] queue_queue_insn_MPORT_data; // @[Sequencer.scala 43:32]
  wire [6:0] queue_queue_insn_MPORT_addr; // @[Sequencer.scala 43:32]
  wire [31:0] queue_MPORT_1_data; // @[Sequencer.scala 43:32]
  wire [6:0] queue_MPORT_1_addr; // @[Sequencer.scala 43:32]
  wire  queue_MPORT_1_mask; // @[Sequencer.scala 43:32]
  wire  queue_MPORT_1_en; // @[Sequencer.scala 43:32]
  reg  comp_valid; // @[Sequencer.scala 79:30]
  reg [31:0] comp_insn; // @[Sequencer.scala 81:30]
  reg  smem_valid; // @[Sequencer.scala 83:30]
  reg [15:0] smem_addr; // @[Sequencer.scala 85:30]
  reg  busy; // @[Sequencer.scala 87:30]
  reg [16:0] pc; // @[Sequencer.scala 90:30]
  reg  running; // @[Sequencer.scala 91:30]
  reg [6:0] ptr; // @[Sequencer.scala 17:30]
  reg [6:0] iptr; // @[Sequencer.scala 44:32]
  reg [6:0] optr; // @[Sequencer.scala 45:32]
  reg  full; // @[Sequencer.scala 46:24]
  wire [6:0] fill = iptr - optr; // @[Sequencer.scala 47:34]
  reg [31:0] queue_insn; // @[Sequencer.scala 95:30]
  reg  queue_insn_valid; // @[Sequencer.scala 96:35]
  reg [31:0] buffer_insn; // @[Sequencer.scala 97:30]
  reg  buffer_insn_valid; // @[Sequencer.scala 98:36]
  wire [31:0] insn = buffer_insn_valid ? buffer_insn : queue_insn; // @[Sequencer.scala 100:30]
  wire  insn_valid = buffer_insn_valid | queue_insn_valid; // @[Sequencer.scala 101:45]
  wire [6:0] next_buffer_insn_hi_hi = insn[31:25]; // @[Sequencer.scala 104:40]
  wire [9:0] next_buffer_insn_hi_lo = insn[24:15] - 10'h1; // @[Sequencer.scala 104:67]
  wire [8:0] next_buffer_insn_lo_hi = insn[14:6] + 9'h1; // @[Sequencer.scala 104:91]
  wire [5:0] next_buffer_insn_lo_lo = insn[5:0]; // @[Sequencer.scala 104:101]
  wire [31:0] next_buffer_insn = {next_buffer_insn_hi_hi,next_buffer_insn_hi_lo,next_buffer_insn_lo_hi,
    next_buffer_insn_lo_lo}; // @[Cat.scala 30:58]
  wire  _next_buffer_insn_valid_T_1 = next_buffer_insn_lo_lo == 6'h3; // @[Sequencer.scala 102:49]
  wire  _next_buffer_insn_valid_T_3 = next_buffer_insn_lo_lo == 6'h7; // @[Sequencer.scala 102:49]
  wire  next_buffer_insn_valid = (_next_buffer_insn_valid_T_1 | _next_buffer_insn_valid_T_3) & insn[24:15] != 10'h1 &
    insn_valid; // @[Sequencer.scala 105:122]
  wire  stall_queue = next_buffer_insn_valid | comp_valid & ~io_comp_ready; // @[Sequencer.scala 107:54]
  wire  _T_1 = reset | io_start; // @[Sequencer.scala 109:29]
  wire [16:0] _pc_T = {io_addr, 1'h0}; // @[Sequencer.scala 114:48]
  wire  _T_4 = io_smem_data[5:0] == 6'h1; // @[Sequencer.scala 120:48]
  wire [16:0] _T_6 = pc + 17'h4; // @[Sequencer.scala 122:49]
  wire [6:0] _ptr_T_1 = ptr + 7'h1; // @[Sequencer.scala 21:28]
  wire  _T_12 = ptr == 7'h0; // @[Sequencer.scala 29:21]
  wire  _T_13 = ~_T_12; // @[Sequencer.scala 125:38]
  wire [6:0] _pc_ptr_T_1 = ptr - 7'h1; // @[Sequencer.scala 25:28]
  wire [16:0] _pc_T_2 = {stack_pc_MPORT_data, 1'h0}; // @[Sequencer.scala 126:59]
  wire [6:0] _GEN_0 = ~_T_12 ? _pc_ptr_T_1 : ptr; // @[Sequencer.scala 125:51 Sequencer.scala 25:21 Sequencer.scala 17:30]
  wire [16:0] _GEN_4 = ~_T_12 ? _pc_T_2 : pc; // @[Sequencer.scala 125:51 Sequencer.scala 126:44 Sequencer.scala 90:30]
  wire  _GEN_5 = ~_T_12 & running; // @[Sequencer.scala 125:51 Sequencer.scala 91:30 Sequencer.scala 129:49]
  wire [6:0] _iptr_T_1 = iptr + 7'h1; // @[Sequencer.scala 51:31]
  wire  _GEN_9 = io_smem_data[5:0] == 6'h2 & _T_13; // @[Sequencer.scala 124:72 Sequencer.scala 18:32]
  wire  _GEN_15 = io_smem_data[5:0] == 6'h2 ? 1'h0 : 1'h1; // @[Sequencer.scala 124:72 Sequencer.scala 43:32 Sequencer.scala 52:22]
  wire  _GEN_27 = io_smem_data[5:0] == 6'h1 ? 1'h0 : _GEN_9; // @[Sequencer.scala 120:65 Sequencer.scala 18:32]
  wire  _GEN_32 = io_smem_data[5:0] == 6'h1 ? 1'h0 : _GEN_15; // @[Sequencer.scala 120:65 Sequencer.scala 43:32]
  wire  _GEN_35 = smem_valid & io_smem_ready ? 1'h0 : smem_valid; // @[Sequencer.scala 118:51 Sequencer.scala 119:36 Sequencer.scala 83:30]
  wire  _GEN_39 = smem_valid & io_smem_ready & _T_4; // @[Sequencer.scala 118:51 Sequencer.scala 18:32]
  wire  _GEN_45 = smem_valid & io_smem_ready & _GEN_27; // @[Sequencer.scala 118:51 Sequencer.scala 18:32]
  wire  _GEN_50 = smem_valid & io_smem_ready & _GEN_32; // @[Sequencer.scala 118:51 Sequencer.scala 43:32]
  wire  _GEN_53 = running & ~smem_valid & ~full | _GEN_35; // @[Sequencer.scala 139:60 Sequencer.scala 140:37]
  wire  _T_19 = iptr == optr; // @[Sequencer.scala 65:22]
  wire  _T_20 = ~_T_19; // @[Sequencer.scala 146:30]
  wire [6:0] _queue_insn_optr_T_1 = optr + 7'h1; // @[Sequencer.scala 55:30]
  wire  _GEN_63 = ~stall_queue & _T_20; // @[Sequencer.scala 145:35 Sequencer.scala 43:32]
  wire [3:0] _comp_insn_T_3 = comp_insn[5:0] == 6'h4 ? 4'h4 : 4'h8; // @[Sequencer.scala 161:80]
  wire [16:0] _GEN_104 = {{13'd0}, _comp_insn_T_3}; // @[Sequencer.scala 161:75]
  wire [16:0] comp_insn_hi_hi = comp_insn[31:15] + _GEN_104; // @[Sequencer.scala 161:75]
  wire [8:0] comp_insn_hi_lo = comp_insn[14:6] + 9'h1; // @[Sequencer.scala 162:65]
  wire [31:0] _comp_insn_T_7 = {comp_insn_hi_hi,comp_insn_hi_lo,comp_insn[5:0]}; // @[Cat.scala 30:58]
  assign stack_pc_MPORT_addr = ptr;
  assign stack_pc_MPORT_data = stack[stack_pc_MPORT_addr]; // @[Sequencer.scala 18:32]
  assign stack_MPORT_data = _T_6[16:1];
  assign stack_MPORT_addr = ptr + 7'h1;
  assign stack_MPORT_mask = 1'h1;
  assign stack_MPORT_en = _T_1 ? 1'h0 : _GEN_39;
  assign queue_queue_insn_MPORT_addr = optr;
  assign queue_queue_insn_MPORT_data = queue[queue_queue_insn_MPORT_addr]; // @[Sequencer.scala 43:32]
  assign queue_MPORT_1_data = io_smem_data;
  assign queue_MPORT_1_addr = iptr;
  assign queue_MPORT_1_mask = 1'h1;
  assign queue_MPORT_1_en = _T_1 ? 1'h0 : _GEN_50;
  assign io_busy = busy; // @[Sequencer.scala 88:25]
  assign io_comp_valid = comp_valid; // @[Sequencer.scala 80:25]
  assign io_comp_insn = comp_insn; // @[Sequencer.scala 82:25]
  assign io_smem_valid = smem_valid; // @[Sequencer.scala 84:25]
  assign io_smem_addr = smem_addr; // @[Sequencer.scala 86:25]
  always @(posedge clock) begin
    if(stack_MPORT_en & stack_MPORT_mask) begin
      stack[stack_MPORT_addr] <= stack_MPORT_data; // @[Sequencer.scala 18:32]
    end
    if(queue_MPORT_1_en & queue_MPORT_1_mask) begin
      queue[queue_MPORT_1_addr] <= queue_MPORT_1_data; // @[Sequencer.scala 43:32]
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      if (~comp_valid | io_comp_ready) begin // @[Sequencer.scala 155:51]
        comp_valid <= insn_valid;
      end
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      if (~comp_valid | io_comp_ready) begin // @[Sequencer.scala 155:51]
        if (insn_valid) begin // @[Sequencer.scala 158:41]
          if (_next_buffer_insn_valid_T_3) begin // @[Sequencer.scala 160:68]
            comp_insn <= _comp_insn_T_7; // @[Sequencer.scala 161:51]
          end else begin
            comp_insn <= insn; // @[Sequencer.scala 165:51]
          end
        end
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      smem_valid <= 1'h0; // @[Sequencer.scala 116:37]
    end else begin
      smem_valid <= _GEN_53;
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      if (running & ~smem_valid & ~full) begin // @[Sequencer.scala 139:60]
        smem_addr <= pc[16:1]; // @[Sequencer.scala 141:37]
      end
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      busy <= ~reset & (running | _T_20 | io_start | stall_queue | comp_valid); // @[Sequencer.scala 172:22]
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      pc <= _pc_T; // @[Sequencer.scala 114:37]
    end else if (smem_valid & io_smem_ready) begin // @[Sequencer.scala 118:51]
      if (io_smem_data[5:0] == 6'h1) begin // @[Sequencer.scala 120:65]
        pc <= io_smem_data[31:15]; // @[Sequencer.scala 123:37]
      end else if (io_smem_data[5:0] == 6'h2) begin // @[Sequencer.scala 124:72]
        pc <= _GEN_4;
      end else begin
        pc <= _T_6; // @[Sequencer.scala 134:37]
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      running <= io_start; // @[Sequencer.scala 115:37]
    end else if (smem_valid & io_smem_ready) begin // @[Sequencer.scala 118:51]
      if (!(io_smem_data[5:0] == 6'h1)) begin // @[Sequencer.scala 120:65]
        if (io_smem_data[5:0] == 6'h2) begin // @[Sequencer.scala 124:72]
          running <= _GEN_5;
        end
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      ptr <= 7'h0; // @[Sequencer.scala 32:21]
    end else if (smem_valid & io_smem_ready) begin // @[Sequencer.scala 118:51]
      if (io_smem_data[5:0] == 6'h1) begin // @[Sequencer.scala 120:65]
        ptr <= _ptr_T_1; // @[Sequencer.scala 21:21]
      end else if (io_smem_data[5:0] == 6'h2) begin // @[Sequencer.scala 124:72]
        ptr <= _GEN_0;
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      iptr <= 7'h0; // @[Sequencer.scala 60:22]
    end else if (smem_valid & io_smem_ready) begin // @[Sequencer.scala 118:51]
      if (!(io_smem_data[5:0] == 6'h1)) begin // @[Sequencer.scala 120:65]
        if (!(io_smem_data[5:0] == 6'h2)) begin // @[Sequencer.scala 124:72]
          iptr <= _iptr_T_1; // @[Sequencer.scala 51:23]
        end
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      optr <= 7'h0; // @[Sequencer.scala 61:22]
    end else if (~stall_queue) begin // @[Sequencer.scala 145:35]
      if (~_T_19) begin // @[Sequencer.scala 146:43]
        optr <= _queue_insn_optr_T_1; // @[Sequencer.scala 55:22]
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      full <= 1'h0; // @[Sequencer.scala 62:22]
    end else begin
      full <= &fill[6:3]; // @[Sequencer.scala 48:14]
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      if (~stall_queue) begin // @[Sequencer.scala 145:35]
        if (~_T_19) begin // @[Sequencer.scala 146:43]
          queue_insn <= queue_queue_insn_MPORT_data; // @[Sequencer.scala 147:44]
        end
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      queue_insn_valid <= 1'h0; // @[Sequencer.scala 112:37]
    end else if (~stall_queue) begin // @[Sequencer.scala 145:35]
      queue_insn_valid <= _T_20;
    end
    if (!(reset | io_start)) begin // @[Sequencer.scala 109:42]
      if (~comp_valid | io_comp_ready) begin // @[Sequencer.scala 155:51]
        buffer_insn <= next_buffer_insn; // @[Sequencer.scala 156:37]
      end
    end
    if (reset | io_start) begin // @[Sequencer.scala 109:42]
      buffer_insn_valid <= 1'h0; // @[Sequencer.scala 113:37]
    end else if (~comp_valid | io_comp_ready) begin // @[Sequencer.scala 155:51]
      buffer_insn_valid <= next_buffer_insn_valid; // @[Sequencer.scala 157:43]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    stack[initvar] = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 128; initvar = initvar+1)
    queue[initvar] = _RAND_1[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  comp_valid = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  comp_insn = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  smem_valid = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  smem_addr = _RAND_5[15:0];
  _RAND_6 = {1{`RANDOM}};
  busy = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  pc = _RAND_7[16:0];
  _RAND_8 = {1{`RANDOM}};
  running = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  ptr = _RAND_9[6:0];
  _RAND_10 = {1{`RANDOM}};
  iptr = _RAND_10[6:0];
  _RAND_11 = {1{`RANDOM}};
  optr = _RAND_11[6:0];
  _RAND_12 = {1{`RANDOM}};
  full = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  queue_insn = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  queue_insn_valid = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  buffer_insn = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  buffer_insn_valid = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
