module stream_mem (
		clk, 
		reset,

		b,
		b_en, 

		mult_out,
		b_addr,

		b_out,
		b_en_out
	);

	///////// Parameters
	parameter B_W = 8;
	parameter B_D = 4;

	localparam B_D_LOG2 = $clog2(B_D);

	///////// IOs
	input clk;
	input reset;

	input [B_W-1:0] b;
	input b_en;

	output [B_W-1:0] mult_out;
	input [B_D_LOG2-1:0] b_addr;

	output [B_W-1:0] b_out;
	output b_en_out;

	///////// internal signals
	reg [B_W-1:0] mem [B_D-1:0];
	
	integer i;
	always @ (posedge clk) begin
		if (reset) begin
			for (i = 0; i < B_D; i = i + 1) begin
				mem[i] <= 0;
			end 
		end else if (b_en) begin
			mem[0] <= b;
			for (i = 1; i < B_D; i = i + 1) begin
				mem[i] <= mem[i-1];
			end 
		end
	end

	assign b_out = mem[B_D-1];
	assign b_en_out = b_en;

	assign mult_out = mem[b_addr];

endmodule 
