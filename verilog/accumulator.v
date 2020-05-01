module accumulator (

		clk, 
		reset,

		acc_en,
		acc_mode,
		acc_depth,

		res_in_select,
		res_in_h,
		res_in_v,

		shifter_res,

		res_out_h,
		res_out_v

	);
	
	///////// Parameters
	parameter TYPE = "FEEDBACK";	// "FEEDBACK", "FEEDFORWARD"
	parameter WIDTH = 32;
	parameter DEPTH = 1;

	localparam DEPTH_CNTL = (DEPTH == 1) ? 1 : (DEPTH-1); 

	///////// IOs
	input clk;
	input reset;

	input acc_en;
	input acc_mode;
	input [DEPTH_CNTL-1:0] acc_depth;

	input res_in_select;
	input signed [WIDTH-1:0] res_in_h;
	input signed [WIDTH-1:0] res_in_v;

	input signed [WIDTH-1:0] shifter_res;

	output signed [WIDTH-1:0] res_out_h;
	output signed [WIDTH-1:0] res_out_v;

	///////// internal signals
	wire [WIDTH-1:0] res_in;

	reg signed [WIDTH-1:0] acc [DEPTH-1:0];
	wire signed [WIDTH-1:0] acc_in;
	reg signed [WIDTH-1:0] acc_temp [DEPTH-1:0];

	assign res_in = (res_in_select == 1'b1) ? res_in_v : res_in_h;

	generate  
		if (TYPE == "FEEDBACK") begin 
			assign acc_in = (acc_mode == 1'b0) ? res_in : acc[0];
		end else begin 
			assign acc_in = res_in;
		end 
	endgenerate

	integer i;
	always @(posedge clk)begin
		if (reset) begin
			for (i = 0; i < DEPTH; i = i + 1) begin 
				acc[i] <= 0;
			end 
		end else if (acc_en) begin
			acc[0] <= acc_in + shifter_res;

			for (i = 1; i < DEPTH; i = i + 1) begin 
				acc[i] <= acc_temp[i-1];
			end 
		end 
	end
	
	integer j;
	always @ (*)begin
		acc_temp[0] = acc[0];
		for (j = 1; j < DEPTH; j = j + 1) begin 
			acc_temp[j] = (acc_depth[j-1]) ? acc[j] : acc_temp[j-1];
		end
	end 

	assign res_out_h = acc_temp[DEPTH-1];
	assign res_out_v = acc_temp[DEPTH-1];

endmodule 
