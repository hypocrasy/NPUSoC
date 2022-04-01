`default_nettype wire

module testbench;
	reg clock = 0;
	reg resetn = 1;
	wire ready;
	reg valid;
	wire [31:0] rdata;
	reg [3:0] wstrb;
	reg [31:0] addr;
	reg [31:0] wdata;
    localparam clock_period = 5;

top uut(
	.resetn(resetn),
	.valid(valid),
	.ready(ready),
	.wstrb(wstrb),
	.addr(addr),
	.wdata(wdata),
	.rdata(rdata),
	.clock(clock)
);

	reg [31:0] xfer;

	task xfer_posedge;
		begin
				#clock_period;
				clock = 1;
		end
	endtask

	task xfer_negedge;
		begin
				#clock_period;
				clock = 0;
		end
	endtask
	
	task xfer_step;
		begin
				xfer_posedge;
				xfer_negedge;
		end
	endtask
	//要求字对齐
	task xfer_send_word;
	input [31:0] send_data;
	input [31:0] send_addr;
		begin
			if(send_addr[1:0] != 0)
				$display("ERROR!  xfer_send_word:send_addr must be 4 bytes aligned!");
			valid = 1;
			wstrb = {4{1'b1}};
			wdata = send_data;
			addr  = {send_addr[31:2],2'b0};
			while(ready != 1)	xfer_step;
			valid = 0;
			wstrb = 0;
			xfer_step;
		end
	endtask

	//要求半字对齐
	task xfer_send_hword;
	input [15:0] send_data;
	input [31:0] send_addr;
		begin
			if(send_addr[0] != 0) 
				$display("ERROR!  xfer_send_hword:send_addr must be 2 bytes aligned!");


			addr  = {send_addr[31:2],2'b0};
			valid = 1;
			if(send_addr[1] == 0) begin
				wdata = {{16{1'b0}},send_data};
				wstrb = {{2{1'b0}},{2{1'b1}}};
			end
			if(send_addr[1] == 1) begin
				wdata = {send_data,{16{1'b0}}};
				wstrb = {{2{1'b1}},{2{1'b0}}};
			end
			while(ready != 1)	xfer_step;
			valid = 0;
			wstrb = 0;
			xfer_step;
		end
	endtask

	task xfer_send_byte;
	input [7:0] send_data;
	input [31:0] send_addr;
		begin
			addr  = {send_addr[31:2],2'b0};
			valid = 1;
			if(send_addr[1:0] == 0) begin
				wstrb = 1;
				wdata = send_data;
			end
			if(send_addr[1:0] == 1) begin
				wstrb = 2;
				wdata = send_data << 8;
			end
			if(send_addr[1:0] == 2) begin
				wstrb = 4;
				wdata = send_data << 16;
			end
			if(send_addr[1:0] == 3) begin
				wstrb = 8;
				wdata = send_data << 24;
			end
			while(ready != 1)	xfer_step;
			valid = 0;
			wstrb = 0;
			xfer_step;
		end
	endtask
	
	//字对齐：接受32位，半字对齐：接受16位，字节对齐：接受8位
	task xfer_recv;
	input [31:0] recv_addr;
		begin
            valid = 1;
			addr  = {recv_addr[31:2],{2{1'b0}}};

			while(ready != 1)	xfer_step;
			valid = 0;

			xfer = rdata >> recv_addr[1:0] * 8;
			xfer_step;
		end
	endtask

	task acc_run;
	input [15:0] start_addr;
		begin
			xfer_send_word({start_addr,15'b0,1'b1},32'h00020000);
		end
	endtask

	task acc_stop;
		begin
			xfer_send_word({30'b0,1'b1,1'b0},32'h00020000);
		end
	endtask

	task acc_status;
		begin
			xfer_recv(32'h03020000);
		end
	endtask
	
	integer i,len,cursor;
	reg [7:0] indata [0:1024*128-1];
	reg [7:0] outdata [0:1024*128-1];

	initial begin
		$readmemh("../Running/demo.hex",indata);
		$readmemh("../Running/demo_out.hex",outdata);
	end

	initial begin
		resetn = 0;
		for(i=0;i<100;i=i+1)	xfer_step;
		resetn = 1;
		for(i=0;i<100;i=i+1)	xfer_step;

		$display("Uploading demo kernel.");
		$fflush;

		cursor = 0;
		while (cursor < 128*1024) begin
			if (indata[cursor] !== 8'h XX) begin
				len = 1;
				while ((len < 1024) && (len+cursor < 128*1024) &&
						(indata[cursor+len] !== 8'h XX)) len = len+1;

				if ((cursor % 2) != 0) begin
					cursor = cursor - 1;
					len = len + 1;
				end

				if ((len % 4) != 0) begin
					len = len - (len % 4) + 4;
				end

				if (len > 1024) begin
					len = 1024;
				end

				$display("  uploading %4d bytes to 0x%05x", len, cursor);
				$fflush;

				for (i = 0; i < len; i = i+1)
					xfer_send_byte(indata[cursor+i],cursor+i);

				for(i=0;i<10;i=i+1)	xfer_step;

				cursor = cursor + len;
			end else begin
				cursor = cursor + 1;
			end
		end

		$display("Readback.");
		$fflush;

		cursor = 0;
		while (cursor < 128*1024) begin
			if (indata[cursor] !== 8'h XX) begin
				len = 1;
				while ((len < 1024) && (len+cursor < 128*1024) &&
						(indata[cursor+len] !== 8'h XX)) len = len+1;

				if ((cursor % 2) != 0) begin
					cursor = cursor - 1;
					len = len + 1;
				end

				if ((len % 4) != 0) begin
					len = len - (len % 4) + 4;
				end

				if (len > 1024) begin
					len = 1024;
				end

				$display("  downloading %4d bytes from 0x%05x", len, cursor);
				$fflush;

				for (i = 0; i < len; i = i+1) begin
					xfer_recv(cursor+i);
					if (indata[cursor+i] !== 8'h XX && indata[cursor+i] !== xfer[7:0]) begin
						$display("ERROR at %d: expected 0x%02x, got 0x%02x", cursor+i, indata[cursor+i], xfer[7:0]);
					end
				end

				cursor = cursor + len;
			end else begin
				cursor = cursor + 1;
			end
		end
		
		for(i=0;i<10;i=i+1) xfer_step;

		$display("Running kernel.");
		$fflush;

		acc_run(0);

		for(i=0;i<10;i=i+1)	xfer_step;
		acc_status;
		while (xfer != 8'h 00)
			acc_status;

		$display("Checking results.");
		$fflush;

		cursor = 0;
		while (cursor < 128*1024) begin
			if (outdata[cursor] !== 8'h XX) begin
				len = 1;
				while ((len < 1024) && (len+cursor < 128*1024) &&
						(outdata[cursor+len] !== 8'h XX)) len = len+1;

				if ((cursor % 2) != 0) begin
					cursor = cursor - 1;
					len = len + 1;
				end

				if ((len % 4) != 0) begin
					len = len - (len % 4) + 4;
				end

				if (len > 1024) begin
					len = 1024;
				end

				$display("  downloading %4d bytes from 0x%05x", len, cursor);
				$fflush;

				for (i = 0; i < len; i = i+1) begin
					xfer_recv(cursor+i);
					if (outdata[cursor+i] !== 8'h XX && outdata[cursor+i] !== xfer[7:0]) begin
						$display("ERROR at %d: expected 0x%02x, got 0x%02x", cursor+i, outdata[cursor+i], xfer[7:0]);
					end
				end

				cursor = cursor + len;
			end else begin
				cursor = cursor + 1;
			end
		end
		$display("Done.");
		$fflush;
		
		//repeat(10000000000) xfer_step;
		repeat (100) @(posedge clock);
		$finish;
	end



endmodule
