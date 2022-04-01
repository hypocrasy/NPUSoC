/* verilog_memcomp Version: 4.0.5-EAC1 */
/* common_memcomp Version: 4.0.5-beta22 */
/* lang compiler Version: 4.1.6-beta1 Jul 19 2012 13:55:19 */
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2021 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Single-Port Register File
//
//       Instance Name:              mem256x32
//       Words:                      256
//       Bits:                       32
//       Mux:                        4
//       Drive:                      6
//       Write Mask:                 On
//       Write Thru:                 Off
//       Extra Margin Adjustment:    On
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Power Gating:               Off
//       Retention:                  On
//       Pipeline:                   Off
//       Read Disturb Test:	        Off
//       
//       Creation Date:  Tue Oct  5 21:47:38 2021
//       Version: 	r1p1
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v3.0 or v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`timescale 1 ns/1 ps
`define ARM_MEM_PROP 1.000
`define ARM_MEM_RETAIN 1.000
`define ARM_MEM_PERIOD 3.000
`define ARM_MEM_WIDTH 1.000
`define ARM_MEM_SETUP 1.000
`define ARM_MEM_HOLD 0.500
`define ARM_MEM_COLLISION 3.000
// If ARM_UD_MODEL is defined at Simulator Command Line, it Selects the Fast Functional Model
`ifdef ARM_UD_MODEL

// Following parameter Values can be overridden at Simulator Command Line.

// ARM_UD_DP Defines the delay through Data Paths, for Memory Models it represents BIST MUX output delays.
`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
// ARM_UD_CP Defines the delay through Clock Path Cells, for Memory Models it is not used.
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
// ARM_UD_SEQ Defines the delay through the Memory, for Memory Models it is used for CLK->Q delays.
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif

`celldefine
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
module mem256x32 (VDDCE, VDDPE, VSSE, Q, CLK, CEN, WEN, A, D, EMA, EMAW, GWEN, RET1N);
`else
module mem256x32 (Q, CLK, CEN, WEN, A, D, EMA, EMAW, GWEN, RET1N);
`endif

  parameter ASSERT_PREFIX = "";
  parameter BITS = 32;
  parameter WORDS = 256;
  parameter MUX = 4;
  parameter MEM_WIDTH = 128; // redun block size 4, 64 on left, 64 on right
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 1 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 2;
  parameter UPMS_WIDTH = 0;

  output [31:0] Q;
  input  CLK;
  input  CEN;
  input [31:0] WEN;
  input [7:0] A;
  input [31:0] D;
  input [2:0] EMA;
  input [1:0] EMAW;
  input  GWEN;
  input  RET1N;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

  reg pre_charge_st;
  integer row_address;
  integer mux_address;
  reg [127:0] mem [0:63];
  reg [127:0] row, row_t;
  reg LAST_CLK;
  reg [127:0] row_mask;
  reg [127:0] new_data;
  reg [127:0] data_out;
  reg [31:0] readLatch0;
  reg [31:0] shifted_readLatch0;
  reg [31:0] Q_int;
  reg [31:0] writeEnable;
  reg clk0_int;

  wire [31:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  reg  CEN_p2;
  wire [31:0] WEN_;
  reg [31:0] WEN_int;
  wire [7:0] A_;
  reg [7:0] A_int;
  wire [31:0] D_;
  reg [31:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire [1:0] EMAW_;
  reg [1:0] EMAW_int;
  wire  GWEN_;
  reg  GWEN_int;
  wire  RET1N_;
  reg  RET1N_int;

  assign Q[0] = Q_[0]; 
  assign Q[1] = Q_[1]; 
  assign Q[2] = Q_[2]; 
  assign Q[3] = Q_[3]; 
  assign Q[4] = Q_[4]; 
  assign Q[5] = Q_[5]; 
  assign Q[6] = Q_[6]; 
  assign Q[7] = Q_[7]; 
  assign Q[8] = Q_[8]; 
  assign Q[9] = Q_[9]; 
  assign Q[10] = Q_[10]; 
  assign Q[11] = Q_[11]; 
  assign Q[12] = Q_[12]; 
  assign Q[13] = Q_[13]; 
  assign Q[14] = Q_[14]; 
  assign Q[15] = Q_[15]; 
  assign Q[16] = Q_[16]; 
  assign Q[17] = Q_[17]; 
  assign Q[18] = Q_[18]; 
  assign Q[19] = Q_[19]; 
  assign Q[20] = Q_[20]; 
  assign Q[21] = Q_[21]; 
  assign Q[22] = Q_[22]; 
  assign Q[23] = Q_[23]; 
  assign Q[24] = Q_[24]; 
  assign Q[25] = Q_[25]; 
  assign Q[26] = Q_[26]; 
  assign Q[27] = Q_[27]; 
  assign Q[28] = Q_[28]; 
  assign Q[29] = Q_[29]; 
  assign Q[30] = Q_[30]; 
  assign Q[31] = Q_[31]; 
  assign CLK_ = CLK;
  assign CEN_ = CEN;
  assign WEN_[0] = WEN[0];
  assign WEN_[1] = WEN[1];
  assign WEN_[2] = WEN[2];
  assign WEN_[3] = WEN[3];
  assign WEN_[4] = WEN[4];
  assign WEN_[5] = WEN[5];
  assign WEN_[6] = WEN[6];
  assign WEN_[7] = WEN[7];
  assign WEN_[8] = WEN[8];
  assign WEN_[9] = WEN[9];
  assign WEN_[10] = WEN[10];
  assign WEN_[11] = WEN[11];
  assign WEN_[12] = WEN[12];
  assign WEN_[13] = WEN[13];
  assign WEN_[14] = WEN[14];
  assign WEN_[15] = WEN[15];
  assign WEN_[16] = WEN[16];
  assign WEN_[17] = WEN[17];
  assign WEN_[18] = WEN[18];
  assign WEN_[19] = WEN[19];
  assign WEN_[20] = WEN[20];
  assign WEN_[21] = WEN[21];
  assign WEN_[22] = WEN[22];
  assign WEN_[23] = WEN[23];
  assign WEN_[24] = WEN[24];
  assign WEN_[25] = WEN[25];
  assign WEN_[26] = WEN[26];
  assign WEN_[27] = WEN[27];
  assign WEN_[28] = WEN[28];
  assign WEN_[29] = WEN[29];
  assign WEN_[30] = WEN[30];
  assign WEN_[31] = WEN[31];
  assign A_[0] = A[0];
  assign A_[1] = A[1];
  assign A_[2] = A[2];
  assign A_[3] = A[3];
  assign A_[4] = A[4];
  assign A_[5] = A[5];
  assign A_[6] = A[6];
  assign A_[7] = A[7];
  assign D_[0] = D[0];
  assign D_[1] = D[1];
  assign D_[2] = D[2];
  assign D_[3] = D[3];
  assign D_[4] = D[4];
  assign D_[5] = D[5];
  assign D_[6] = D[6];
  assign D_[7] = D[7];
  assign D_[8] = D[8];
  assign D_[9] = D[9];
  assign D_[10] = D[10];
  assign D_[11] = D[11];
  assign D_[12] = D[12];
  assign D_[13] = D[13];
  assign D_[14] = D[14];
  assign D_[15] = D[15];
  assign D_[16] = D[16];
  assign D_[17] = D[17];
  assign D_[18] = D[18];
  assign D_[19] = D[19];
  assign D_[20] = D[20];
  assign D_[21] = D[21];
  assign D_[22] = D[22];
  assign D_[23] = D[23];
  assign D_[24] = D[24];
  assign D_[25] = D[25];
  assign D_[26] = D[26];
  assign D_[27] = D[27];
  assign D_[28] = D[28];
  assign D_[29] = D[29];
  assign D_[30] = D[30];
  assign D_[31] = D[31];
  assign EMA_[0] = EMA[0];
  assign EMA_[1] = EMA[1];
  assign EMA_[2] = EMA[2];
  assign EMAW_[0] = EMAW[0];
  assign EMAW_[1] = EMAW[1];
  assign GWEN_ = GWEN;
  assign RET1N_ = RET1N;

  assign `ARM_UD_SEQ Q_ = (RET1N_ | pre_charge_st) ? ((Q_int)) : {32{1'bx}};

// If INITIALIZE_MEMORY is defined at Simulator Command Line, it Initializes the Memory with all ZEROS.
`ifdef INITIALIZE_MEMORY
  integer i;
  initial begin
    #0;
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
  end
`endif
  always @ (EMA_) begin
  	if(EMA_ < 2) 
   	$display("Warning: Set Value for EMA doesn't match Default value 2 in %m at %0t", $time);
  end
  always @ (EMAW_) begin
  	if(EMAW_ < 0) 
   	$display("Warning: Set Value for EMAW doesn't match Default value 0 in %m at %0t", $time);
  end

  task failedWrite;
  input port_f;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitval;
    begin
      isBitX = ( bitval===1'bx || bitval==1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction



  task readWrite;
  begin
    if (RET1N_int === 1'bx || RET1N_int === 1'bz) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int, EMAW_int, RET1N_int} === 1'bx) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      Q_int = GWEN_int !== 1'b1 ? Q_int : {32{1'bx}};
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 2'b11);
      row_address = (A_int >> 2);
      if (row_address > 63)
        row = {128{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWEN_int) ) begin
        writeEnable = {32{1'bx}};
        D_int = {32{1'bx}};
      end else
          writeEnable = ~ ( {32{GWEN_int}} | {WEN_int[31], WEN_int[30], WEN_int[29],
          WEN_int[28], WEN_int[27], WEN_int[26], WEN_int[25], WEN_int[24], WEN_int[23],
          WEN_int[22], WEN_int[21], WEN_int[20], WEN_int[19], WEN_int[18], WEN_int[17],
          WEN_int[16], WEN_int[15], WEN_int[14], WEN_int[13], WEN_int[12], WEN_int[11],
          WEN_int[10], WEN_int[9], WEN_int[8], WEN_int[7], WEN_int[6], WEN_int[5],
          WEN_int[4], WEN_int[3], WEN_int[2], WEN_int[1], WEN_int[0]});
      if (GWEN_int !== 1'b1) begin
        row_mask =  ( {3'b000, writeEnable[31], 3'b000, writeEnable[30], 3'b000, writeEnable[29],
          3'b000, writeEnable[28], 3'b000, writeEnable[27], 3'b000, writeEnable[26],
          3'b000, writeEnable[25], 3'b000, writeEnable[24], 3'b000, writeEnable[23],
          3'b000, writeEnable[22], 3'b000, writeEnable[21], 3'b000, writeEnable[20],
          3'b000, writeEnable[19], 3'b000, writeEnable[18], 3'b000, writeEnable[17],
          3'b000, writeEnable[16], 3'b000, writeEnable[15], 3'b000, writeEnable[14],
          3'b000, writeEnable[13], 3'b000, writeEnable[12], 3'b000, writeEnable[11],
          3'b000, writeEnable[10], 3'b000, writeEnable[9], 3'b000, writeEnable[8],
          3'b000, writeEnable[7], 3'b000, writeEnable[6], 3'b000, writeEnable[5], 3'b000, writeEnable[4],
          3'b000, writeEnable[3], 3'b000, writeEnable[2], 3'b000, writeEnable[1], 3'b000, writeEnable[0]} << mux_address);
        new_data =  ( {3'b000, D_int[31], 3'b000, D_int[30], 3'b000, D_int[29], 3'b000, D_int[28],
          3'b000, D_int[27], 3'b000, D_int[26], 3'b000, D_int[25], 3'b000, D_int[24],
          3'b000, D_int[23], 3'b000, D_int[22], 3'b000, D_int[21], 3'b000, D_int[20],
          3'b000, D_int[19], 3'b000, D_int[18], 3'b000, D_int[17], 3'b000, D_int[16],
          3'b000, D_int[15], 3'b000, D_int[14], 3'b000, D_int[13], 3'b000, D_int[12],
          3'b000, D_int[11], 3'b000, D_int[10], 3'b000, D_int[9], 3'b000, D_int[8],
          3'b000, D_int[7], 3'b000, D_int[6], 3'b000, D_int[5], 3'b000, D_int[4], 3'b000, D_int[3],
          3'b000, D_int[2], 3'b000, D_int[1], 3'b000, D_int[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
      end else begin
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[124], data_out[120], data_out[116], data_out[112], data_out[108],
          data_out[104], data_out[100], data_out[96], data_out[92], data_out[88], data_out[84],
          data_out[80], data_out[76], data_out[72], data_out[68], data_out[64], data_out[60],
          data_out[56], data_out[52], data_out[48], data_out[44], data_out[40], data_out[36],
          data_out[32], data_out[28], data_out[24], data_out[20], data_out[16], data_out[12],
          data_out[8], data_out[4], data_out[0]};
        shifted_readLatch0 = readLatch0;
        Q_int = {shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
      end
      if( isBitX(GWEN_int) ) begin
        Q_int = {32{1'bx}};
      end
    end
  end
  endtask
  always @ (CEN_ or CLK_) begin
  	if(CLK_ == 1'b0) begin
  		CEN_p2 = CEN_;
  	end
  end

`ifdef POWER_PINS
  always @ (VDDCE) begin
      if (VDDCE != 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDCE should be powered down after VDDPE, Illegal power down sequencing in %m at %0t", $time);
       end
        $display("In PowerDown Mode in %m at %0t", $time);
        failedWrite(0);
      end
      if (VDDCE == 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDPE should be powered up after VDDCE in %m at %0t", $time);
        $display("Illegal power up sequencing in %m at %0t", $time);
       end
        failedWrite(0);
      end
  end
`endif
`ifdef POWER_PINS
  always @ (RET1N_ or VDDPE or VDDCE) begin
`else     
  always @ RET1N_ begin
`endif
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && RET1N_int == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 && pre_charge_st == 1'b1 && (CEN_ === 1'bx || CLK_ === 1'bx)) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end
`else     
`endif
`ifdef POWER_PINS
`else     
      pre_charge_st = 0;
`endif
    if (RET1N_ === 1'bx || RET1N_ === 1'bz) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_ === 1'b0 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_ === 1'b1 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end
`ifdef POWER_PINS
    if (RET1N_ == 1'b0 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 1;
    end else if (RET1N_ == 1'b0 && VDDPE == 1'b0) begin
      pre_charge_st = 0;
      if (VDDCE != 1'b1) begin
        failedWrite(0);
      end
`else     
    if (RET1N_ == 1'b0) begin
`endif
      Q_int = {32{1'bx}};
      CEN_int = 1'bx;
      WEN_int = {32{1'bx}};
      A_int = {8{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      GWEN_int = 1'bx;
      RET1N_int = 1'bx;
`ifdef POWER_PINS
    end else if (RET1N_ == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 &&  pre_charge_st == 1'b1) begin
      pre_charge_st = 0;
    end else begin
      pre_charge_st = 0;
`else     
    end else begin
`endif
        Q_int = {32{1'bx}};
      CEN_int = 1'bx;
      WEN_int = {32{1'bx}};
      A_int = {8{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      GWEN_int = 1'bx;
      RET1N_int = 1'bx;
    end
    RET1N_int = RET1N_;
  end


  always @ CLK_ begin
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
`endif
`ifdef POWER_PINS
  if (RET1N_ == 1'b0) begin
`else     
  if (RET1N_ == 1'b0) begin
`endif
      // no cycle in retention mode
  end else begin
    if ((CLK_ === 1'bx || CLK_ === 1'bz) && RET1N_ !== 1'b0) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        WEN_int = WEN_;
        A_int = A_;
        D_int = D_;
        GWEN_int = GWEN_;
      end
      clk0_int = 1'b0;
      CEN_int = CEN_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        WEN_int = WEN_;
        A_int = A_;
        D_int = D_;
        GWEN_int = GWEN_;
      end
      clk0_int = 1'b0;
    readWrite;
    end else if (CLK_ === 1'b0 && LAST_CLK === 1'b1) begin
    end
  end
    LAST_CLK = CLK_;
  end
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
 always @ (VDDCE or VDDPE or VSSE) begin
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
 end
`endif

endmodule
`endcelldefine
`else
`celldefine
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
module mem256x32 (VDDCE, VDDPE, VSSE, Q, CLK, CEN, WEN, A, D, EMA, EMAW, GWEN, RET1N);
`else
module mem256x32 (Q, CLK, CEN, WEN, A, D, EMA, EMAW, GWEN, RET1N);
`endif

  parameter ASSERT_PREFIX = "";
  parameter BITS = 32;
  parameter WORDS = 256;
  parameter MUX = 4;
  parameter MEM_WIDTH = 128; // redun block size 4, 64 on left, 64 on right
  parameter MEM_HEIGHT = 64;
  parameter WP_SIZE = 1 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 2;
  parameter UPMS_WIDTH = 0;

  output [31:0] Q;
  input  CLK;
  input  CEN;
  input [31:0] WEN;
  input [7:0] A;
  input [31:0] D;
  input [2:0] EMA;
  input [1:0] EMAW;
  input  GWEN;
  input  RET1N;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

  reg pre_charge_st;
  integer row_address;
  integer mux_address;
  reg [127:0] mem [0:63];
  reg [127:0] row, row_t;
  reg LAST_CLK;
  reg [127:0] row_mask;
  reg [127:0] new_data;
  reg [127:0] data_out;
  reg [31:0] readLatch0;
  reg [31:0] shifted_readLatch0;
  reg [31:0] Q_int;
  reg [31:0] writeEnable;

  reg NOT_CEN, NOT_WEN31, NOT_WEN30, NOT_WEN29, NOT_WEN28, NOT_WEN27, NOT_WEN26, NOT_WEN25;
  reg NOT_WEN24, NOT_WEN23, NOT_WEN22, NOT_WEN21, NOT_WEN20, NOT_WEN19, NOT_WEN18;
  reg NOT_WEN17, NOT_WEN16, NOT_WEN15, NOT_WEN14, NOT_WEN13, NOT_WEN12, NOT_WEN11;
  reg NOT_WEN10, NOT_WEN9, NOT_WEN8, NOT_WEN7, NOT_WEN6, NOT_WEN5, NOT_WEN4, NOT_WEN3;
  reg NOT_WEN2, NOT_WEN1, NOT_WEN0, NOT_A7, NOT_A6, NOT_A5, NOT_A4, NOT_A3, NOT_A2;
  reg NOT_A1, NOT_A0, NOT_D31, NOT_D30, NOT_D29, NOT_D28, NOT_D27, NOT_D26, NOT_D25;
  reg NOT_D24, NOT_D23, NOT_D22, NOT_D21, NOT_D20, NOT_D19, NOT_D18, NOT_D17, NOT_D16;
  reg NOT_D15, NOT_D14, NOT_D13, NOT_D12, NOT_D11, NOT_D10, NOT_D9, NOT_D8, NOT_D7;
  reg NOT_D6, NOT_D5, NOT_D4, NOT_D3, NOT_D2, NOT_D1, NOT_D0, NOT_EMA2, NOT_EMA1, NOT_EMA0;
  reg NOT_EMAW1, NOT_EMAW0, NOT_GWEN, NOT_RET1N;
  reg NOT_CLK_PER, NOT_CLK_MINH, NOT_CLK_MINL;
  reg clk0_int;

  wire [31:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  reg  CEN_p2;
  wire [31:0] WEN_;
  reg [31:0] WEN_int;
  wire [7:0] A_;
  reg [7:0] A_int;
  wire [31:0] D_;
  reg [31:0] D_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire [1:0] EMAW_;
  reg [1:0] EMAW_int;
  wire  GWEN_;
  reg  GWEN_int;
  wire  RET1N_;
  reg  RET1N_int;

  buf B0(Q[0], Q_[0]);
  buf B1(Q[1], Q_[1]);
  buf B2(Q[2], Q_[2]);
  buf B3(Q[3], Q_[3]);
  buf B4(Q[4], Q_[4]);
  buf B5(Q[5], Q_[5]);
  buf B6(Q[6], Q_[6]);
  buf B7(Q[7], Q_[7]);
  buf B8(Q[8], Q_[8]);
  buf B9(Q[9], Q_[9]);
  buf B10(Q[10], Q_[10]);
  buf B11(Q[11], Q_[11]);
  buf B12(Q[12], Q_[12]);
  buf B13(Q[13], Q_[13]);
  buf B14(Q[14], Q_[14]);
  buf B15(Q[15], Q_[15]);
  buf B16(Q[16], Q_[16]);
  buf B17(Q[17], Q_[17]);
  buf B18(Q[18], Q_[18]);
  buf B19(Q[19], Q_[19]);
  buf B20(Q[20], Q_[20]);
  buf B21(Q[21], Q_[21]);
  buf B22(Q[22], Q_[22]);
  buf B23(Q[23], Q_[23]);
  buf B24(Q[24], Q_[24]);
  buf B25(Q[25], Q_[25]);
  buf B26(Q[26], Q_[26]);
  buf B27(Q[27], Q_[27]);
  buf B28(Q[28], Q_[28]);
  buf B29(Q[29], Q_[29]);
  buf B30(Q[30], Q_[30]);
  buf B31(Q[31], Q_[31]);
  buf B32(CLK_, CLK);
  buf B33(CEN_, CEN);
  buf B34(WEN_[0], WEN[0]);
  buf B35(WEN_[1], WEN[1]);
  buf B36(WEN_[2], WEN[2]);
  buf B37(WEN_[3], WEN[3]);
  buf B38(WEN_[4], WEN[4]);
  buf B39(WEN_[5], WEN[5]);
  buf B40(WEN_[6], WEN[6]);
  buf B41(WEN_[7], WEN[7]);
  buf B42(WEN_[8], WEN[8]);
  buf B43(WEN_[9], WEN[9]);
  buf B44(WEN_[10], WEN[10]);
  buf B45(WEN_[11], WEN[11]);
  buf B46(WEN_[12], WEN[12]);
  buf B47(WEN_[13], WEN[13]);
  buf B48(WEN_[14], WEN[14]);
  buf B49(WEN_[15], WEN[15]);
  buf B50(WEN_[16], WEN[16]);
  buf B51(WEN_[17], WEN[17]);
  buf B52(WEN_[18], WEN[18]);
  buf B53(WEN_[19], WEN[19]);
  buf B54(WEN_[20], WEN[20]);
  buf B55(WEN_[21], WEN[21]);
  buf B56(WEN_[22], WEN[22]);
  buf B57(WEN_[23], WEN[23]);
  buf B58(WEN_[24], WEN[24]);
  buf B59(WEN_[25], WEN[25]);
  buf B60(WEN_[26], WEN[26]);
  buf B61(WEN_[27], WEN[27]);
  buf B62(WEN_[28], WEN[28]);
  buf B63(WEN_[29], WEN[29]);
  buf B64(WEN_[30], WEN[30]);
  buf B65(WEN_[31], WEN[31]);
  buf B66(A_[0], A[0]);
  buf B67(A_[1], A[1]);
  buf B68(A_[2], A[2]);
  buf B69(A_[3], A[3]);
  buf B70(A_[4], A[4]);
  buf B71(A_[5], A[5]);
  buf B72(A_[6], A[6]);
  buf B73(A_[7], A[7]);
  buf B74(D_[0], D[0]);
  buf B75(D_[1], D[1]);
  buf B76(D_[2], D[2]);
  buf B77(D_[3], D[3]);
  buf B78(D_[4], D[4]);
  buf B79(D_[5], D[5]);
  buf B80(D_[6], D[6]);
  buf B81(D_[7], D[7]);
  buf B82(D_[8], D[8]);
  buf B83(D_[9], D[9]);
  buf B84(D_[10], D[10]);
  buf B85(D_[11], D[11]);
  buf B86(D_[12], D[12]);
  buf B87(D_[13], D[13]);
  buf B88(D_[14], D[14]);
  buf B89(D_[15], D[15]);
  buf B90(D_[16], D[16]);
  buf B91(D_[17], D[17]);
  buf B92(D_[18], D[18]);
  buf B93(D_[19], D[19]);
  buf B94(D_[20], D[20]);
  buf B95(D_[21], D[21]);
  buf B96(D_[22], D[22]);
  buf B97(D_[23], D[23]);
  buf B98(D_[24], D[24]);
  buf B99(D_[25], D[25]);
  buf B100(D_[26], D[26]);
  buf B101(D_[27], D[27]);
  buf B102(D_[28], D[28]);
  buf B103(D_[29], D[29]);
  buf B104(D_[30], D[30]);
  buf B105(D_[31], D[31]);
  buf B106(EMA_[0], EMA[0]);
  buf B107(EMA_[1], EMA[1]);
  buf B108(EMA_[2], EMA[2]);
  buf B109(EMAW_[0], EMAW[0]);
  buf B110(EMAW_[1], EMAW[1]);
  buf B111(GWEN_, GWEN);
  buf B112(RET1N_, RET1N);

   `ifdef ARM_FAULT_MODELING
     mem256x32_error_injection u1(.CLK(CLK_), .Q_out(Q_), .A(A_int), .CEN(CEN_int), .GWEN(GWEN_int), .WEN(WEN_int), .Q_in(Q_int));
  `else
  assign Q_ = (RET1N_ | pre_charge_st) ? ((Q_int)) : {32{1'bx}};
  `endif

// If INITIALIZE_MEMORY is defined at Simulator Command Line, it Initializes the Memory with all ZEROS.
`ifdef INITIALIZE_MEMORY
  integer i;
  initial begin
    #0;
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
  end
`endif
  always @ (EMA_) begin
  	if(EMA_ < 2) 
   	$display("Warning: Set Value for EMA doesn't match Default value 2 in %m at %0t", $time);
  end
  always @ (EMAW_) begin
  	if(EMAW_ < 0) 
   	$display("Warning: Set Value for EMAW doesn't match Default value 0 in %m at %0t", $time);
  end

  task failedWrite;
  input port_f;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitval;
    begin
      isBitX = ( bitval===1'bx || bitval==1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction



  task readWrite;
  begin
    if (RET1N_int === 1'bx || RET1N_int === 1'bz) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_int === 1'b0 && CEN_int === 1'b0) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{CEN_int, EMA_int, EMAW_int, RET1N_int} === 1'bx) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
      Q_int = GWEN_int !== 1'b1 ? Q_int : {32{1'bx}};
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 2'b11);
      row_address = (A_int >> 2);
      if (row_address > 63)
        row = {128{1'bx}};
      else
        row = mem[row_address];
      if( isBitX(GWEN_int) ) begin
        writeEnable = {32{1'bx}};
        D_int = {32{1'bx}};
      end else
          writeEnable = ~ ( {32{GWEN_int}} | {WEN_int[31], WEN_int[30], WEN_int[29],
          WEN_int[28], WEN_int[27], WEN_int[26], WEN_int[25], WEN_int[24], WEN_int[23],
          WEN_int[22], WEN_int[21], WEN_int[20], WEN_int[19], WEN_int[18], WEN_int[17],
          WEN_int[16], WEN_int[15], WEN_int[14], WEN_int[13], WEN_int[12], WEN_int[11],
          WEN_int[10], WEN_int[9], WEN_int[8], WEN_int[7], WEN_int[6], WEN_int[5],
          WEN_int[4], WEN_int[3], WEN_int[2], WEN_int[1], WEN_int[0]});
      if (GWEN_int !== 1'b1) begin
        row_mask =  ( {3'b000, writeEnable[31], 3'b000, writeEnable[30], 3'b000, writeEnable[29],
          3'b000, writeEnable[28], 3'b000, writeEnable[27], 3'b000, writeEnable[26],
          3'b000, writeEnable[25], 3'b000, writeEnable[24], 3'b000, writeEnable[23],
          3'b000, writeEnable[22], 3'b000, writeEnable[21], 3'b000, writeEnable[20],
          3'b000, writeEnable[19], 3'b000, writeEnable[18], 3'b000, writeEnable[17],
          3'b000, writeEnable[16], 3'b000, writeEnable[15], 3'b000, writeEnable[14],
          3'b000, writeEnable[13], 3'b000, writeEnable[12], 3'b000, writeEnable[11],
          3'b000, writeEnable[10], 3'b000, writeEnable[9], 3'b000, writeEnable[8],
          3'b000, writeEnable[7], 3'b000, writeEnable[6], 3'b000, writeEnable[5], 3'b000, writeEnable[4],
          3'b000, writeEnable[3], 3'b000, writeEnable[2], 3'b000, writeEnable[1], 3'b000, writeEnable[0]} << mux_address);
        new_data =  ( {3'b000, D_int[31], 3'b000, D_int[30], 3'b000, D_int[29], 3'b000, D_int[28],
          3'b000, D_int[27], 3'b000, D_int[26], 3'b000, D_int[25], 3'b000, D_int[24],
          3'b000, D_int[23], 3'b000, D_int[22], 3'b000, D_int[21], 3'b000, D_int[20],
          3'b000, D_int[19], 3'b000, D_int[18], 3'b000, D_int[17], 3'b000, D_int[16],
          3'b000, D_int[15], 3'b000, D_int[14], 3'b000, D_int[13], 3'b000, D_int[12],
          3'b000, D_int[11], 3'b000, D_int[10], 3'b000, D_int[9], 3'b000, D_int[8],
          3'b000, D_int[7], 3'b000, D_int[6], 3'b000, D_int[5], 3'b000, D_int[4], 3'b000, D_int[3],
          3'b000, D_int[2], 3'b000, D_int[1], 3'b000, D_int[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
      end else begin
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[124], data_out[120], data_out[116], data_out[112], data_out[108],
          data_out[104], data_out[100], data_out[96], data_out[92], data_out[88], data_out[84],
          data_out[80], data_out[76], data_out[72], data_out[68], data_out[64], data_out[60],
          data_out[56], data_out[52], data_out[48], data_out[44], data_out[40], data_out[36],
          data_out[32], data_out[28], data_out[24], data_out[20], data_out[16], data_out[12],
          data_out[8], data_out[4], data_out[0]};
        shifted_readLatch0 = readLatch0;
        Q_int = {shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
      end
      if( isBitX(GWEN_int) ) begin
        Q_int = {32{1'bx}};
      end
    end
  end
  endtask
  always @ (CEN_ or CLK_) begin
  	if(CLK_ == 1'b0) begin
  		CEN_p2 = CEN_;
  	end
  end

`ifdef POWER_PINS
  always @ (VDDCE) begin
      if (VDDCE != 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDCE should be powered down after VDDPE, Illegal power down sequencing in %m at %0t", $time);
       end
        $display("In PowerDown Mode in %m at %0t", $time);
        failedWrite(0);
      end
      if (VDDCE == 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDPE should be powered up after VDDCE in %m at %0t", $time);
        $display("Illegal power up sequencing in %m at %0t", $time);
       end
        failedWrite(0);
      end
  end
`endif
`ifdef POWER_PINS
  always @ (RET1N_ or VDDPE or VDDCE) begin
`else     
  always @ RET1N_ begin
`endif
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && RET1N_int == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 && pre_charge_st == 1'b1 && (CEN_ === 1'bx || CLK_ === 1'bx)) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end
`else     
`endif
`ifdef POWER_PINS
`else     
      pre_charge_st = 0;
`endif
    if (RET1N_ === 1'bx || RET1N_ === 1'bz) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_ === 1'b0 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (RET1N_ === 1'b1 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end
`ifdef POWER_PINS
    if (RET1N_ == 1'b0 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 1;
    end else if (RET1N_ == 1'b0 && VDDPE == 1'b0) begin
      pre_charge_st = 0;
      if (VDDCE != 1'b1) begin
        failedWrite(0);
      end
`else     
    if (RET1N_ == 1'b0) begin
`endif
      Q_int = {32{1'bx}};
      CEN_int = 1'bx;
      WEN_int = {32{1'bx}};
      A_int = {8{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      GWEN_int = 1'bx;
      RET1N_int = 1'bx;
`ifdef POWER_PINS
    end else if (RET1N_ == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 &&  pre_charge_st == 1'b1) begin
      pre_charge_st = 0;
    end else begin
      pre_charge_st = 0;
`else     
    end else begin
`endif
        Q_int = {32{1'bx}};
      CEN_int = 1'bx;
      WEN_int = {32{1'bx}};
      A_int = {8{1'bx}};
      D_int = {32{1'bx}};
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      GWEN_int = 1'bx;
      RET1N_int = 1'bx;
    end
    RET1N_int = RET1N_;
  end


  always @ CLK_ begin
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
`endif
`ifdef POWER_PINS
  if (RET1N_ == 1'b0) begin
`else     
  if (RET1N_ == 1'b0) begin
`endif
      // no cycle in retention mode
  end else begin
    if ((CLK_ === 1'bx || CLK_ === 1'bz) && RET1N_ !== 1'b0) begin
      failedWrite(0);
        Q_int = {32{1'bx}};
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        WEN_int = WEN_;
        A_int = A_;
        D_int = D_;
        GWEN_int = GWEN_;
      end
      clk0_int = 1'b0;
      CEN_int = CEN_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        WEN_int = WEN_;
        A_int = A_;
        D_int = D_;
        GWEN_int = GWEN_;
      end
      clk0_int = 1'b0;
    readWrite;
    end else if (CLK_ === 1'b0 && LAST_CLK === 1'b1) begin
    end
  end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || EMAW_int[0] === 1'bx || EMAW_int[1] === 1'bx || 
      EMA_int[0] === 1'bx || EMA_int[1] === 1'bx || EMA_int[2] === 1'bx || RET1N_int === 1'bx || 
      clk0_int === 1'bx) begin
        Q_int = {32{1'bx}};
      failedWrite(0);
    end else begin
      #0;
      readWrite;
   end
    globalNotifier0 = 1'b0;
  end
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
 always @ (VDDCE or VDDPE or VSSE) begin
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
 end
`endif

  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN31 begin
    WEN_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN30 begin
    WEN_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN29 begin
    WEN_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN28 begin
    WEN_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN27 begin
    WEN_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN26 begin
    WEN_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN25 begin
    WEN_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN24 begin
    WEN_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN23 begin
    WEN_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN22 begin
    WEN_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN21 begin
    WEN_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN20 begin
    WEN_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN19 begin
    WEN_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN18 begin
    WEN_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN17 begin
    WEN_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN16 begin
    WEN_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN15 begin
    WEN_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN14 begin
    WEN_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN13 begin
    WEN_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN12 begin
    WEN_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN11 begin
    WEN_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN10 begin
    WEN_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN9 begin
    WEN_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN8 begin
    WEN_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN7 begin
    WEN_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN6 begin
    WEN_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN5 begin
    WEN_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN4 begin
    WEN_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN3 begin
    WEN_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN2 begin
    WEN_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN1 begin
    WEN_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_WEN0 begin
    WEN_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A7 begin
    A_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA2 begin
    EMA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA1 begin
    EMA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA0 begin
    EMA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW1 begin
    EMAW_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW0 begin
    EMAW_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_GWEN begin
    GWEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RET1N begin
    RET1N_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end



  wire RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0;
  wire RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0;
  wire RET1Neq1, RET1Neq1aCENeq0aWEN31eq0aGWENeq0, RET1Neq1aCENeq0aWEN30eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN29eq0aGWENeq0, RET1Neq1aCENeq0aWEN28eq0aGWENeq0, RET1Neq1aCENeq0aWEN27eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN26eq0aGWENeq0, RET1Neq1aCENeq0aWEN25eq0aGWENeq0, RET1Neq1aCENeq0aWEN24eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN23eq0aGWENeq0, RET1Neq1aCENeq0aWEN22eq0aGWENeq0, RET1Neq1aCENeq0aWEN21eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN20eq0aGWENeq0, RET1Neq1aCENeq0aWEN19eq0aGWENeq0, RET1Neq1aCENeq0aWEN18eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN17eq0aGWENeq0, RET1Neq1aCENeq0aWEN16eq0aGWENeq0, RET1Neq1aCENeq0aWEN15eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN14eq0aGWENeq0, RET1Neq1aCENeq0aWEN13eq0aGWENeq0, RET1Neq1aCENeq0aWEN12eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN11eq0aGWENeq0, RET1Neq1aCENeq0aWEN10eq0aGWENeq0, RET1Neq1aCENeq0aWEN9eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN8eq0aGWENeq0, RET1Neq1aCENeq0aWEN7eq0aGWENeq0, RET1Neq1aCENeq0aWEN6eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN5eq0aGWENeq0, RET1Neq1aCENeq0aWEN4eq0aGWENeq0, RET1Neq1aCENeq0aWEN3eq0aGWENeq0;
  wire RET1Neq1aCENeq0aWEN2eq0aGWENeq0, RET1Neq1aCENeq0aWEN1eq0aGWENeq0, RET1Neq1aCENeq0aWEN0eq0aGWENeq0;
  wire RET1Neq1aCENeq0;


  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && !EMA[1] && !EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && !EMA[1] && !EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && !EMA[1] && !EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && !EMA[1] && !EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && !EMA[1] && EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && !EMA[1] && EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && !EMA[1] && EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && !EMA[1] && EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && EMA[1] && !EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && EMA[1] && !EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && EMA[1] && !EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && EMA[1] && !EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && EMA[1] && EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && EMA[1] && EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && !EMA[2] && EMA[1] && EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && !EMA[2] && EMA[1] && EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && EMA[2] && !EMA[1] && !EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && EMA[2] && !EMA[1] && !EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && EMA[2] && !EMA[1] && !EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && EMA[2] && !EMA[1] && !EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && EMA[2] && !EMA[1] && EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && EMA[2] && !EMA[1] && EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && EMA[2] && !EMA[1] && EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && EMA[2] && !EMA[1] && EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && EMA[2] && EMA[1] && !EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && EMA[2] && EMA[1] && !EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && EMA[2] && EMA[1] && !EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && EMA[2] && EMA[1] && !EMA[0] && EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0 = RET1N && EMA[2] && EMA[1] && EMA[0] && !EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0 = RET1N && EMA[2] && EMA[1] && EMA[0] && !EMAW[1] && EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0 = RET1N && EMA[2] && EMA[1] && EMA[0] && EMAW[1] && !EMAW[0] && !CEN;
  assign RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0 = RET1N && EMA[2] && EMA[1] && EMA[0] && EMAW[1] && EMAW[0] && !CEN;

  assign RET1Neq1aCENeq0aWEN31eq0aGWENeq0 = RET1N && !CEN && !WEN[31] && !GWEN;
  assign RET1Neq1aCENeq0aWEN30eq0aGWENeq0 = RET1N && !CEN && !WEN[30] && !GWEN;
  assign RET1Neq1aCENeq0aWEN29eq0aGWENeq0 = RET1N && !CEN && !WEN[29] && !GWEN;
  assign RET1Neq1aCENeq0aWEN28eq0aGWENeq0 = RET1N && !CEN && !WEN[28] && !GWEN;
  assign RET1Neq1aCENeq0aWEN27eq0aGWENeq0 = RET1N && !CEN && !WEN[27] && !GWEN;
  assign RET1Neq1aCENeq0aWEN26eq0aGWENeq0 = RET1N && !CEN && !WEN[26] && !GWEN;
  assign RET1Neq1aCENeq0aWEN25eq0aGWENeq0 = RET1N && !CEN && !WEN[25] && !GWEN;
  assign RET1Neq1aCENeq0aWEN24eq0aGWENeq0 = RET1N && !CEN && !WEN[24] && !GWEN;
  assign RET1Neq1aCENeq0aWEN23eq0aGWENeq0 = RET1N && !CEN && !WEN[23] && !GWEN;
  assign RET1Neq1aCENeq0aWEN22eq0aGWENeq0 = RET1N && !CEN && !WEN[22] && !GWEN;
  assign RET1Neq1aCENeq0aWEN21eq0aGWENeq0 = RET1N && !CEN && !WEN[21] && !GWEN;
  assign RET1Neq1aCENeq0aWEN20eq0aGWENeq0 = RET1N && !CEN && !WEN[20] && !GWEN;
  assign RET1Neq1aCENeq0aWEN19eq0aGWENeq0 = RET1N && !CEN && !WEN[19] && !GWEN;
  assign RET1Neq1aCENeq0aWEN18eq0aGWENeq0 = RET1N && !CEN && !WEN[18] && !GWEN;
  assign RET1Neq1aCENeq0aWEN17eq0aGWENeq0 = RET1N && !CEN && !WEN[17] && !GWEN;
  assign RET1Neq1aCENeq0aWEN16eq0aGWENeq0 = RET1N && !CEN && !WEN[16] && !GWEN;
  assign RET1Neq1aCENeq0aWEN15eq0aGWENeq0 = RET1N && !CEN && !WEN[15] && !GWEN;
  assign RET1Neq1aCENeq0aWEN14eq0aGWENeq0 = RET1N && !CEN && !WEN[14] && !GWEN;
  assign RET1Neq1aCENeq0aWEN13eq0aGWENeq0 = RET1N && !CEN && !WEN[13] && !GWEN;
  assign RET1Neq1aCENeq0aWEN12eq0aGWENeq0 = RET1N && !CEN && !WEN[12] && !GWEN;
  assign RET1Neq1aCENeq0aWEN11eq0aGWENeq0 = RET1N && !CEN && !WEN[11] && !GWEN;
  assign RET1Neq1aCENeq0aWEN10eq0aGWENeq0 = RET1N && !CEN && !WEN[10] && !GWEN;
  assign RET1Neq1aCENeq0aWEN9eq0aGWENeq0 = RET1N && !CEN && !WEN[9] && !GWEN;
  assign RET1Neq1aCENeq0aWEN8eq0aGWENeq0 = RET1N && !CEN && !WEN[8] && !GWEN;
  assign RET1Neq1aCENeq0aWEN7eq0aGWENeq0 = RET1N && !CEN && !WEN[7] && !GWEN;
  assign RET1Neq1aCENeq0aWEN6eq0aGWENeq0 = RET1N && !CEN && !WEN[6] && !GWEN;
  assign RET1Neq1aCENeq0aWEN5eq0aGWENeq0 = RET1N && !CEN && !WEN[5] && !GWEN;
  assign RET1Neq1aCENeq0aWEN4eq0aGWENeq0 = RET1N && !CEN && !WEN[4] && !GWEN;
  assign RET1Neq1aCENeq0aWEN3eq0aGWENeq0 = RET1N && !CEN && !WEN[3] && !GWEN;
  assign RET1Neq1aCENeq0aWEN2eq0aGWENeq0 = RET1N && !CEN && !WEN[2] && !GWEN;
  assign RET1Neq1aCENeq0aWEN1eq0aGWENeq0 = RET1N && !CEN && !WEN[1] && !GWEN;
  assign RET1Neq1aCENeq0aWEN0eq0aGWENeq0 = RET1N && !CEN && !WEN[0] && !GWEN;

  assign RET1Neq1 = RET1N;
  assign RET1Neq1aCENeq0 = RET1N && !CEN;

  specify

    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1 && GWEN == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $period(posedge CLK, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `else
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& RET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aCENeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `endif


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $width(posedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `else
       $width(posedge CLK &&& RET1Neq1, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK &&& RET1Neq1, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `endif

    $setuphold(posedge CLK &&& RET1Neq1, posedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN);
    $setuphold(posedge CLK &&& RET1Neq1, negedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge WEN[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge WEN[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_WEN0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN31eq0aGWENeq0, posedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN31eq0aGWENeq0, negedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN30eq0aGWENeq0, posedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN30eq0aGWENeq0, negedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN29eq0aGWENeq0, posedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN29eq0aGWENeq0, negedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN28eq0aGWENeq0, posedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN28eq0aGWENeq0, negedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN27eq0aGWENeq0, posedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN27eq0aGWENeq0, negedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN26eq0aGWENeq0, posedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN26eq0aGWENeq0, negedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN25eq0aGWENeq0, posedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN25eq0aGWENeq0, negedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN24eq0aGWENeq0, posedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN24eq0aGWENeq0, negedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN23eq0aGWENeq0, posedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN23eq0aGWENeq0, negedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN22eq0aGWENeq0, posedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN22eq0aGWENeq0, negedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN21eq0aGWENeq0, posedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN21eq0aGWENeq0, negedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN20eq0aGWENeq0, posedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN20eq0aGWENeq0, negedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN19eq0aGWENeq0, posedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN19eq0aGWENeq0, negedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN18eq0aGWENeq0, posedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN18eq0aGWENeq0, negedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN17eq0aGWENeq0, posedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN17eq0aGWENeq0, negedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN16eq0aGWENeq0, posedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN16eq0aGWENeq0, negedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN15eq0aGWENeq0, posedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN15eq0aGWENeq0, negedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN14eq0aGWENeq0, posedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN14eq0aGWENeq0, negedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN13eq0aGWENeq0, posedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN13eq0aGWENeq0, negedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN12eq0aGWENeq0, posedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN12eq0aGWENeq0, negedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN11eq0aGWENeq0, posedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN11eq0aGWENeq0, negedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN10eq0aGWENeq0, posedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN10eq0aGWENeq0, negedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN9eq0aGWENeq0, posedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN9eq0aGWENeq0, negedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN8eq0aGWENeq0, posedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN8eq0aGWENeq0, negedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN7eq0aGWENeq0, posedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN7eq0aGWENeq0, negedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN6eq0aGWENeq0, posedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN6eq0aGWENeq0, negedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN5eq0aGWENeq0, posedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN5eq0aGWENeq0, negedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN4eq0aGWENeq0, posedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN4eq0aGWENeq0, negedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN3eq0aGWENeq0, posedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN3eq0aGWENeq0, negedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN2eq0aGWENeq0, posedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN2eq0aGWENeq0, negedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN1eq0aGWENeq0, posedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN1eq0aGWENeq0, negedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN0eq0aGWENeq0, posedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aWEN0eq0aGWENeq0, negedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN);
    $setuphold(posedge CLK, posedge RET1N, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge CLK, negedge RET1N, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(negedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge CEN, negedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge CEN, posedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
  endspecify


endmodule
`endcelldefine
`endif
`timescale 1ns/1ps
module mem256x32_error_injection (Q_out, Q_in, CLK, A, CEN, WEN, GWEN);
   output [31:0] Q_out;
   input [31:0] Q_in;
   input CLK;
   input [7:0] A;
   input CEN;
   input [31:0] WEN;
   input GWEN;
   parameter LEFT_RED_COLUMN_FAULT = 2'd1;
   parameter RIGHT_RED_COLUMN_FAULT = 2'd2;
   parameter NO_RED_FAULT = 2'd0;
   reg [31:0] Q_out;
   reg entry_found;
   reg list_complete;
   reg [17:0] fault_table [63:0];
   reg [17:0] fault_entry;
initial
begin
   `ifdef DUT
      `define pre_pend_path TB.DUT_inst.CHIP
   `else
       `define pre_pend_path TB.CHIP
   `endif
   `ifdef ARM_NONREPAIRABLE_FAULT
      `pre_pend_path.SMARCHCHKBVCD_LVISION_MBISTPG_ASSEMBLY_UNDER_TEST_INST.MEM0_MEM_INST.u1.add_fault(8'd163,5'd6,2'd1,2'd0);
   `endif
end
   task add_fault;
   //This task injects fault in memory
      input [7:0] address;
      input [4:0] bitPlace;
      input [1:0] fault_type;
      input [1:0] red_fault;
 
      integer i;
      reg done;
   begin
      done = 1'b0;
      i = 0;
      while ((!done) && i < 63)
      begin
         fault_entry = fault_table[i];
         if (fault_entry[0] === 1'b0 || fault_entry[0] === 1'bx)
         begin
            fault_entry[0] = 1'b1;
            fault_entry[2:1] = red_fault;
            fault_entry[4:3] = fault_type;
            fault_entry[9:5] = bitPlace;
            fault_entry[17:10] = address;
            fault_table[i] = fault_entry;
            done = 1'b1;
         end
         i = i+1;
      end
   end
   endtask
//This task removes all fault entries injected by user
task remove_all_faults;
   integer i;
begin
   for (i = 0; i < 64; i=i+1)
   begin
      fault_entry = fault_table[i];
      fault_entry[0] = 1'b0;
      fault_table[i] = fault_entry;
   end
end
endtask
task bit_error;
// This task is used to inject error in memory and should be called
// only from current module.
//
// This task injects error depending upon fault type to particular bit
// of the output
   inout [31:0] q_int;
   input [1:0] fault_type;
   input [4:0] bitLoc;
begin
   if (fault_type === 2'd0)
      q_int[bitLoc] = 1'b0;
   else if (fault_type === 2'd1)
      q_int[bitLoc] = 1'b1;
   else
      q_int[bitLoc] = ~q_int[bitLoc];
end
endtask
task error_injection_on_output;
// This function goes through error injection table for every
// read cycle and corrupts Q output if fault for the particular
// address is present in fault table
//
// If fault is redundant column is detected, this task corrupts
// Q output in read cycle
//
// If fault is repaired using repair bus, this task does not
// courrpt Q output in read cycle
//
   output [31:0] Q_output;
   reg list_complete;
   integer i;
   reg [5:0] row_address;
   reg [1:0] column_address;
   reg [4:0] bitPlace;
   reg [1:0] fault_type;
   reg [1:0] red_fault;
   reg valid;
   reg [3:0] msb_bit_calc;
begin
   entry_found = 1'b0;
   list_complete = 1'b0;
   i = 0;
   Q_output = Q_in;
   while(!list_complete)
   begin
      fault_entry = fault_table[i];
      {row_address, column_address, bitPlace, fault_type, red_fault, valid} = fault_entry;
      i = i + 1;
      if (valid == 1'b1)
      begin
         if (red_fault === NO_RED_FAULT)
         begin
            if (row_address == A[7:2] && column_address == A[1:0])
            begin
               if (bitPlace < 16)
                  bit_error(Q_output,fault_type, bitPlace);
               else if (bitPlace >= 16 )
                  bit_error(Q_output,fault_type, bitPlace);
            end
         end
      end
      else
         list_complete = 1'b1;
      end
   end
   endtask
   always @ (Q_in or CLK or A or CEN or WEN or GWEN)
   begin
   if (CEN === 1'b0)
      error_injection_on_output(Q_out);
   else
      Q_out = Q_in;
   end
endmodule
