module stream_flex (
		clk, 
		reset,

		a,
		a_en,

		mult_out,

		a_mux,
		a_out
	);

	///////// Parameters
	parameter A_W = 8;

	parameter A_D = 4;
	localparam A_D_HALF = A_D / 2;

	///////// IOs
	input clk;
	input reset;

	input [A_W-1:0] a;
	input a_en;

	output [A_W-1:0] mult_out;

	input [A_D_HALF-1:0] a_mux;
	output [A_W-1:0] a_out;

	///////// internal signals
	reg [A_W-1:0] a_reg [A_D-1:0];

	reg [A_W-1:0] a_out_temp [A_D_HALF:0];

	integer i, j;
	always @ (posedge clk)begin
		if (reset) begin 
			for (i = 0; i < A_D; i = i + 1) begin 
				a_reg[i] <= 0;
			end 
		end else if (a_en) begin
			for (j = 0; j < A_D_HALF; j = j + 1) begin 
				a_reg [2*j] <= a_out_temp[j];		
				a_reg [2*j+1] <= a_reg [2*j];				
			end 
		end 
	end

	integer k;
	always @ (*) begin 
		a_out_temp[0] = a;
		for (k = 1; k <= A_D_HALF; k = k + 1) begin 
			a_out_temp[k] = (a_mux[k-1])? a_reg[2*k-1] : a_out_temp[k-1];
		end 
	end 

	assign mult_out = a_reg[0];

	assign a_out = a_out_temp[A_D_HALF];

endmodule 
