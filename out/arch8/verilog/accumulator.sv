module accumulator (
		clk, 
		reset,

		Res_in,
		Res_en,
		
		Res_mode,
		Res_depth,

		mult_result,

		Res_cascade
	);
	
	///////// Parameters
	parameter TYPE = "FEEDBACK";	// "FEEDBACK", "FEEDFORWARD"
	parameter WIDTH = 32;
	parameter DEPTH = 1;

	localparam DEPTH_CNTL = (DEPTH == 1) ? 1 : (DEPTH-1); 

	///////// IOs
	input clk;
	input reset;

	input signed [WIDTH-1:0] Res_in;
	input Res_en;

	input Res_mode;
	input [DEPTH_CNTL-1:0] Res_depth;

	input signed [WIDTH-1:0] mult_result;

	output signed [WIDTH-1:0] Res_cascade;

	///////// internal signals

	reg signed [WIDTH-1:0] acc [DEPTH-1:0];
	wire signed [WIDTH-1:0] acc_in;
	reg signed [WIDTH-1:0] acc_temp [DEPTH-1:0];

	generate  
		if (TYPE == "FEEDBACK") begin 
			assign acc_in = (Res_mode == 1'b0) ? Res_in : acc[0];
		end else begin 
			assign acc_in = Res_in;
		end 
	endgenerate

	integer i;
	always @(posedge clk)begin
		if (reset) begin
			for (i = 0; i < DEPTH; i = i + 1) begin 
				acc[i] <= 0;
			end 
		end else if (Res_en) begin
			acc[0] <= acc_in + mult_result;

			for (i = 1; i < DEPTH; i = i + 1) begin 
				acc[i] <= acc_temp[i-1];
			end 
		end 
	end
	
	integer j;
	always @ (*)begin
		acc_temp[0] = acc[0];
		for (j = 1; j < DEPTH; j = j + 1) begin 
			acc_temp[j] = (Res_depth[j-1]) ? acc[j] : acc_temp[j-1];
		end
	end 

	assign Res_cascade = acc_temp[DEPTH-1];

endmodule 
