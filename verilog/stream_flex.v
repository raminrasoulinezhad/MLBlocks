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

	///////// IOs
	input clk;
	input reset;

	input [A_W-1:0] a;
	input a_en;

	output [A_W-1:0] mult_out;

	input a_mux;
	output [A_W-1:0] a_out;

	///////// internal signals
	reg [A_W-1:0] a_reg_0;
	reg [A_W-1:0] a_reg_1;	

	always @ (posedge clk)begin
		if (reset) begin 
			a_reg_0 <= 0;
			a_reg_1 <= 0;
		end else if (a_en) begin
			a_reg_0 <= a;
			a_reg_1 <= a_reg_0;
		end 
	end

	assign mult_out = a_reg_0;

	assign a_out = (a_mux)? a_reg_1 : a;

endmodule 
