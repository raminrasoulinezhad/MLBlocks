module stream_flex (
		clk, 
		reset,

		in,
		en,

		out,

		depth,
		cascade
	);

	///////// Parameters
	parameter WIDTH = 8;

	parameter DEPTH = 4;
	localparam DEPTH_HALF = DEPTH / 2;

	///////// IOs
	input clk;
	input reset;

	input [WIDTH-1:0] in;
	input en;

	output [WIDTH-1:0] out;

	input [DEPTH_HALF-1:0] depth;
	output [WIDTH-1:0] cascade;

	///////// internal signals
	reg [WIDTH-1:0] a_reg [DEPTH-1:0];

	reg [WIDTH-1:0] a_out_temp [DEPTH_HALF:0];

	integer i, j;
	always @ (posedge clk)begin
		if (reset) begin 
			for (i = 0; i < DEPTH; i = i + 1) begin 
				a_reg[i] <= 0;
			end 
		end else if (en) begin
			for (j = 0; j < DEPTH_HALF; j = j + 1) begin 
				a_reg [2*j] <= a_out_temp[j];		
				a_reg [2*j+1] <= a_reg [2*j];				
			end 
		end 
	end

	integer k;
	always @ (*) begin 
		a_out_temp[0] = in;
		for (k = 1; k <= DEPTH_HALF; k = k + 1) begin 
			a_out_temp[k] = (depth[k-1])? a_reg[2*k-1] : a_out_temp[k-1];
		end 
	end 

	assign out = a_reg[0];

	assign cascade = a_out_temp[DEPTH_HALF];

endmodule 
