/* 16K X 64bit ram,16bit 对齐读取写入,单周期写入，双周期读出 */
module memory (
	input             clock,
	input      [15:0] addr,
	input      [ 7:0] wen,
	input      [63:0] wdata,
	output reg [63:0] rdata
);
	wire [2:0] shamt = 4 - addr[1:0];
	reg [1:0] shamt_rev_q;

	wire [7:0] shifted_wen = {wen, wen} >> (shamt[1:0] * 2);
	wire [63:0] shifted_wdata = {wdata, wdata} >> (shamt[1:0] * 16);
	wire [63:0] shifted_rdata;

	wire [3:0] addr_offsets = 8'b 0000_1111 >> shamt;

	wire [13:0] addr0 = addr[15:2];
	wire [13:0] addr1 = addr0 + 1;

	/* 四个ram,16K X 64bit ram,16bit 对齐读取写入 */
	memory_spram ram [3:0] (
		.clock(clock),
		.wen(shifted_wen),
		.addr({
			addr_offsets[3] ? addr1 : addr0,
			addr_offsets[2] ? addr1 : addr0,
			addr_offsets[1] ? addr1 : addr0,
			addr_offsets[0] ? addr1 : addr0
		}),
		.wdata(shifted_wdata),
		.rdata(shifted_rdata)
	);

	always @(posedge clock) begin
		shamt_rev_q <= addr[1:0];
		rdata <= {shifted_rdata, shifted_rdata} >> (shamt_rev_q * 16);
	end
endmodule
/*  16K X 16 bit ram ,当拍发送命令，下拍返回数据 or 写入成功*/


module memory_spram (
	input         clock,
	input  [ 1:0] wen,
	input  [13:0] addr,
	input  [15:0] wdata,
	output [15:0] rdata
);

`ifndef SIM
	wire [15:0] WEN = {{8{wen[1]}},{8{wen[0]}}};
mem16384x16 #(
.ASSERT_PREFIX(""),
.BITS(16),
.WORDS(16384),
.MUX(16),
.MEM_WIDTH(256), // redun block size 8, 128 on left, 128 on right
.MEM_HEIGHT(1024),
.WP_SIZE(1),
.UPM_WIDTH(3),
.UPMW_WIDTH(2),
.UPMS_WIDTH(0)
) u_mem16384(
	 .CENY(),
	 .WENY(),
	 .AY(),
	 .GWENY(),
	 .Q(rdata),
	 .SO(),
	 .CLK(clock),
	 .CEN(1'b0),
	 .WEN(~WEN),
	 .A(addr),
	 .D(wdata),
	 .EMA(3'b0),
	 .EMAW(2'b0),
	 .TEN(1'b1),
	 .TCEN(1'b0),
	 .TWEN(16'b0),
	 .TA(14'b0),
	 .TD(16'b0),
	 .GWEN(~(&(~WEN))),
	 .TGWEN(1'b0),
	 .RET1N(1'b1),
	 .SI(2'b0),
	 .SE(1'b0),
	 .DFTRAMBYP(1'b0)
);

`else

	wire [15:0] rdata0,rdata1;

	reg CHIPSELECT_r;
	always@(posedge clock) begin
		CHIPSELECT_r <= addr[13];	
	end

	spsram8192161782 u0_spsram8192161782(
		.ADDRESS(addr[12:0]),
		.DATAIN(wdata),
		.MASKWREN(wen),
		.WREN(|wen),
		.CHIPSELECT(~addr[13]),
		.CLOCK(clock),
		.DATAOUT(rdata0)
	);

	spsram8192161782 u1_spsram8192161782(
		.ADDRESS(addr[12:0]),
		.DATAIN(wdata),
		.MASKWREN(wen),
		.WREN(|wen),
		.CHIPSELECT(addr[13]),
		.CLOCK(clock),
		.DATAOUT(rdata1)
	);
	
	assign rdata = CHIPSELECT_r ? rdata1:rdata0;
`endif


	/*  16K X 16 bit ram ,当拍发送命令，下拍返回数据 or 写入成功*/
	
endmodule

`ifdef SIM
module spsram8192161782 (
	input [12:0] ADDRESS,
	input [15:0] DATAIN,
	input [1:0] MASKWREN,
	input WREN, CHIPSELECT, CLOCK,
	output reg [15:0] DATAOUT
);
	reg [15:0] mem [0:8192];
	always @(posedge CLOCK) begin
		if(CHIPSELECT && !WREN) begin
			DATAOUT <= mem[ADDRESS];
		end
		if(CHIPSELECT && WREN) begin
			if(MASKWREN[0]) mem[ADDRESS][7 :0] <= DATAIN[7 :0];
			if(MASKWREN[1]) mem[ADDRESS][15:8] <= DATAIN[15:8];
		end
	end
endmodule
`endif

